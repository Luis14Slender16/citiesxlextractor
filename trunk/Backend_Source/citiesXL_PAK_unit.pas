Unit citiesXL_PAK_unit;

Interface

Uses
  Windows,  SysUtils, Classes, zlib;

Const PAK_Unit_Version : PChar = '1.00';

// values for the Cities XL "CompressionMode":
Const _citiesXL_comp_NONE = 0;
      _citiesXL_comp_CLEVER = 1;
      _citiesXL_comp_FORCE_ZLIB = 2;

Type TCallBackProcL = Procedure(L : LongInt;p : PChar);

Function CitiesXL_PAK_maker_bacter(SrcDir,
                                   TrgtPAKfileName : String;
                                   CompressionMode : Integer;
                                   CallBack : TCallBackProcL;
                                   Var _NrOfFiles : Integer) : Boolean;


Function CitiesXL_PAK_eXtract_bacter(PAKfileName,
                                     TargetDir : String;
                                     CallBack : TCallBackProcL;
                                     Var Success : Boolean) : Integer;


Procedure SampleCallBackProc(L : LongInt;pFileName : PChar);


implementation


Procedure SampleCallBackProc(L : LongInt;pFileName : PChar);
Var Total,Index : LongInt;
Begin {Proc. SampleCallBackProc}
  Index := L And $FFFF;
  Total := L Shr 16;
  WriteLn(Index,' of ',Total,' files processed: '+pFileName);
End;  {Proc. SampleCallBackProc}


Type Int160 = Packed Record
       Case Boolean Of
         True : (I : Array[0..4] Of Integer);
         False : (B : Array[0..19] Of Byte);
     End;

Type L_String = Packed Record
       Hossz : Integer;
       Chars : Array Of Char;
     End;


Type CitiesXL_PAK_HeaderType = Packed Record
       ID : Array[0..3] Of Char;
       Version : Integer;
       UnknownInt : Integer;
       SHA1 : Int160;
       DirStartPos : Integer;
       NrOfFiles : Integer;
       PaddingZero_0 : Integer;
       PaddingZero_1 : Integer;
     End;
Type CitiesXL_PAK_EntryType = Packed Record
       StoredSize : Integer;
       OriginalSize : Integer;
       FileStartPos : Integer;
       SHA1 : Int160;
       Flag : Integer;
       FileName : L_String;
     End;
Type CitiesXL_PAK_EntryArrayType = Array Of CitiesXL_PAK_EntryType;

Procedure DirZaroBackSlashHozzaad(Var Dir : String);
Begin {Proc. DirZaroBackSlashHozzaad}
  If Dir = '' Then Dir := '.';
  If Dir[Length(Dir)] <> '\' Then Dir := Dir + '\';
End;    {Proc. DirZaroBackSlashHozzaad}


Function __estimated_NrOfFiles(StartDir : String) : Integer;
Var NrOfFiles : Integer;

    Procedure Collecting(Dir : String);
    Var SR: TSearchRec;
        Find_Error : Integer;
    Begin {sub Proc. Collecting}
      Find_Error := Sysutils.FindFirst(Dir+'*.*',faAnyFile,SR);
      While Find_Error = 0 Do
        Begin
          If ((SR.Attr And faDirectory) = faDirectory) Then
            Begin
              If (SR.Name <> '.') And (SR.Name <> '..') Then
                Begin
                  Collecting(Dir+SR.Name+'\');
                End;
            End Else
            Begin
              Inc(NrOfFiles);
            End;
          Find_Error := FindNext(SR);
        End;
      Sysutils.FindClose(SR);
    End;  {sub Proc. Collecting}
Begin {Func. __estimated_NrOfFiles}
  NrOfFiles := 0;
  DirZaroBackSlashHozzaAd(StartDir);
  If Not DirectoryExists(StartDir) Then
    Begin
      Result := -1;
      Exit;
    End;
  Collecting(StartDir);
  Result := NrOfFiles;
End;  {Func. __estimated_NrOfFiles}

Procedure __zlibCompression(InBuf : Pointer;
                            InBufSize : Integer;
                            Var OutBuf : Pointer;
                            Var OutBufSize : Integer);
Begin {Proc. __zlibCompression}
  CompressBuf(InBuf,InBufSize,OutBuf,OutBufSize); // ZLIB Unit
End;  {Proc. __zlibCompression}


// compression flags in the DirTable:
Const _citiesXL_flag_NO_COMP = 0;
Const _citiesXL_flag_ZLIB = $100;


// Windows 32-bit API conversions:
// JEDI API Library
// http://jedi-apilib.sourceforge.net/
//
Type ULONG_PTR = LongWord;
     HCRYPTPROV = ULONG_PTR;
     HCRYPTHASH = ULONG_PTR;
     HCRYPTKEY = ULONG_PTR;
     ALG_ID = Cardinal;
     LPBYTE = ^Byte;
Const MS_ENHANCED_PROV_A = 'Microsoft Enhanced Cryptographic Provider v1.0';
      MS_ENHANCED_PROV = MS_ENHANCED_PROV_A;
      PROV_RSA_FULL = 1;

      ALG_CLASS_HASH = 4 shl 13;
      ALG_TYPE_ANY = 0;
      ALG_SID_MD5 = 3;
      CALG_MD5 = ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MD5;

      ALG_CLASS_DATA_ENCRYPT = 3 shl 13;
      ALG_TYPE_STREAM = 4 shl 9;
      ALG_SID_RC4 = 1;
      CALG_RC4 = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_STREAM or ALG_SID_RC4;

Function CryptAcquireContext(Var phProv : HCRYPTPROV;
                             pszContainer : LPCTSTR;
                             pszProvider : LPCTSTR;
                             dwProvType : DWORD;
                             dwFlags : DWORD): BOOL; stdcall; External ADVAPI32 Name 'CryptAcquireContextA';

Function CryptCreateHash(hProv : HCRYPTPROV;
                         Algid : ALG_ID;
                         hKey : HCRYPTKEY;
                         dwFlags : DWORD;
                         Var phHash : HCRYPTHASH) : BOOL; stdcall; External ADVAPI32 Name 'CryptCreateHash';

Function CryptHashData(hHash : HCRYPTHASH;
                       pbData : LPBYTE;
                       dwDataLen,
                       dwFlags: DWORD): BOOL; stdcall; External ADVAPI32 Name 'CryptHashData';

Function CryptDeriveKey(hProv : HCRYPTPROV;
                        Algid : ALG_ID;
                        hBaseData : HCRYPTHASH;
                        dwFlags : DWORD;
                        var phKey : HCRYPTKEY): BOOL; stdcall; External ADVAPI32 Name 'CryptDeriveKey';

Function CryptDecrypt(hKey : HCRYPTKEY;
                      hHash : HCRYPTHASH;
                      Final : BOOL;
                      dwFlags : DWORD;
                      pbData : LPBYTE;
                      Var pdwDataLen: DWORD) : BOOL; stdcall; External ADVAPI32 Name 'CryptDecrypt';


Function CryptDestroyKey(hKey: HCRYPTKEY): BOOL; stdcall; External ADVAPI32 Name 'CryptDestroyKey';
Function CryptDestroyHash(hHash: HCRYPTHASH): BOOL; stdcall; External ADVAPI32 Name 'CryptDestroyHash';
Function CryptReleaseContext(hProv: HCRYPTPROV; dwFlags: ULONG_PTR): BOOL; stdcall; External ADVAPI32 Name 'CryptReleaseContext';

Function CitiesXL_aluigi_trick(pData : Pointer;DataLen : Integer) : Boolean;
Const key : PChar = 'allocator';
Var hProv :   HCRYPTPROV;
    hHash : HCRYPTHASH;
    hKey : HCRYPTKEY;
    len : DWORD;
Begin {Func. CitiesXL_aluigi_trick}
  len := DataLen;
  Result := False;
  If CryptAcquireContext(hProv,{NULL}0,MS_ENHANCED_PROV,PROV_RSA_FULL,0) Then
    Begin
      If CryptCreateHash(hProv,CALG_MD5,0,0,hHash) Then
        Begin
          If CryptHashData(hHash,LPBYTE(@key[0]),StrLen(key),0) Then
            Begin
              If CryptDeriveKey(hProv,CALG_RC4,hHash,$00800000,hKey) Then
                Begin
                  If CryptDecrypt(hKey,0,TRUE,0,LPBYTE(pData),len) Then
                    Begin
                      Result := True;
                    End;
                  CryptDestroyKey(hKey);
                End;
            End;
          CryptDestroyHash(hHash);
        End;
      CryptReleaseContext(hProv, 0);
    End;
End;  {Func. CitiesXL_aluigi_trick}


// SHA1 imports - Undocumented Advapi32.dll functions!!!
//
// TinyHash v1.1.1 - for Delphi - by f0xi - 25/04/2010
// http://files.codes-sources.com/fichier.aspx?id=41404&f=TinyHash.pas&lang=en

Type SHA1_CTX  = packed record
       _Unknow : array[0..5]  of LongWord;
       _State  : array[0..4]  of LongWord;
       _Count  : array[0..1]  of LongWord;
       _Buffer : array[0..63] of byte;
     End;
     pSHA1_CTX = ^SHA1_CTX;
     pSHA1Context = pSHA1_CTX;
     TSHA1Context = SHA1_CTX;
     pSHA1_DIG   = ^SHA1_DIG;
     SHA1_DIG    = packed array[0..4] of LongWord;
     pSHA1Digest = pSHA1_DIG;
     TSHA1Digest = SHA1_DIG;


procedure SHA1Init(const pCtx : pSHA1_CTX); stdcall; external ADVAPI32 name 'A_SHAInit';
procedure SHA1Update(const pCtx : pSHA1_CTX;
                     const Buffer;
                     const BufferSize : LongInt); stdcall; external ADVAPI32 name 'A_SHAUpdate';

procedure SHA1Final(const pCtx : pSHA1_CTX;
                    const pResult : pSHA1_DIG); stdcall;  external ADVAPI32 name 'A_SHAFinal';


Procedure __QuickLoad(FileName : String;Var p : Pointer;Var MemoSize : Integer);
Var FM0 : Word;
    f : File;
Begin {Func. __QuickLoad}
  FM0 := FileMode;
  FileMode := fmOpenRead;
  AssignFile(f,FileName);
  ReSet(f,1);
  FileMode := FM0;
  MemoSize := FileSize(f);
  GetMem(p,MemoSize);
  BlockRead(f,p^,MemoSize);
  CloseFile(f);
End;  {Func. __QuickLoad}

Function LoCase(S : String) : String;
Var I : Integer;
Begin {Func. LoCase}
  For I := 1 To Length(S) Do
      If S[I] In ['A'..'Z'] Then
        Begin
          S[I] := Char(Byte(S[I])+32);
        End;
  Result := S;
End;  {Func. LoCase}

Procedure BackSlash2SlashS(Var S : String);
Var I : Integer;
Begin {Proc. BackSlash2SlashS}
  For I := 1 To Length(S) Do
    Begin
      If S[I] = '\' Then S[I] := '/';
    End;
End;  {Proc. BackSlash2SlashS}


Function SHA1_Calculate(pData : Pointer;DataLen : Integer) : Int160;
Var KONTI : SHA1_CTX;
    pCtx : pSHA1_CTX;
    The_SHA1 : Int160;
Begin {Func. SHA1_Calculate}
  pCtx := Addr(KONTI);
  SHA1Init(pCtx);
  SHA1Update(pCtx,pData^,DataLen);
  SHA1Final(pCtx,(Addr(The_SHA1)));
  Result := The_SHA1;
End;  {Func. SHA1_Calculate}



Procedure String_2_L_String(S : String;Var L_S : L_String);
Var H : Integer;
Begin {Proc. String_2_L_String}
  L_S.Hossz := Length(S);
  Setlength(L_S.Chars,L_S.Hossz);
  If 0 < L_S.Hossz Then Move(S[1],L_S.Chars[0],L_S.Hossz);
End;  {Proc. String_2_L_String}


Function CitiesXL_PAK_maker_bacter(SrcDir,
                                   TrgtPAKfileName : String;
                                   CompressionMode : Integer;
                                   CallBack:TCallBackProcL;
                                   Var _NrOfFiles : Integer) : Boolean;

Var f : File;
    Header : CitiesXL_PAK_HeaderType;
    Entries : CitiesXL_PAK_EntryArrayType;
    Entry : CitiesXL_PAK_EntryType;
    FileIndex : Integer;
    nrOfStoredFiles,nrOfZlibbedFiles : Integer;

    p : Array Of Byte;
    Index : Integer;
    I : Integer;
    SrcDirNameLen : Integer;
    pakFileSize : Integer;
    pakDirTableSize : Integer;
    FilesEst : Integer;

    MainSHA1ctx : SHA1_CTX;
    pMainSHA1ctx : pSHA1_CTX;
    MainSHA1 : Int160;

    Procedure RecoursiveAction(Dir : String);
    Var SR: TSearchRec;
        Find_Error : Integer;
        p,p2 : Pointer;
        pSize,p2Size : Integer;
        S : String;
        zlibbed : Boolean;
    Begin {sub Proc. RecoursiveAction}
      Find_Error := Sysutils.FindFirst(Dir+'*.*',faAnyFile,SR);
      While Find_Error = 0 Do
        Begin
          If ((SR.Attr And faDirectory) = faDirectory) Then
            Begin
              If (SR.Name <> '.') And (SR.Name <> '..') Then
                Begin
                  RecoursiveAction(Dir+SR.Name+'\');
                End;
            End Else
            Begin
              Inc(_NrOfFiles);
              S := Dir+SR.Name;
              __QuickLoad(S,p,pSize);
              Delete(S,1,SrcDirNameLen);
              BackSlash2SlashS(S);
              S := LoCase(S) + #0; // !!!
              If CompressionMode = _citiesXL_comp_NONE Then
                Begin
                  zlibbed := False;
                End Else
              If CompressionMode = _citiesXL_comp_CLEVER Then
                Begin
                  CompressBuf(p,pSize,p2,p2Size);
                  zlibbed := (p2Size < pSize);
                  If not zlibbed Then FreeMem(p2,p2Size);
                End Else
              If CompressionMode = _citiesXL_comp_FORCE_ZLIB Then
                Begin
                  CompressBuf(p,pSize,p2,p2Size);
                  zlibbed := True;
                End Else
                Begin
                  zlibbed := False;
                End;

              Entry.OriginalSize := pSize; // or: SR.Size
              Entry.FileStartPos := FileIndex;
              Entry.SHA1 := SHA1_Calculate(p,pSize);
              String_2_L_String(S,Entry.FileName);
              If zlibbed Then
                Begin
                  Entry.StoredSize := p2Size;
                  Entry.Flag := _citiesXL_flag_ZLIB;
                  BlockWrite(f,p2^,p2Size);

                  SHA1Update(pMainSHA1ctx,p2^,p2Size);

                  Inc(FileIndex,p2Size);
                  FreeMem(p2,p2Size);
                  Inc(nrOfZlibbedFiles);
                End Else
                Begin
                  Entry.StoredSize := pSize;
                  Entry.Flag := _citiesXL_flag_NO_COMP;
                  BlockWrite(f,p^,pSize);

                  SHA1Update(pMainSHA1ctx,p^,pSize);

                  Inc(FileIndex,pSize);
                  Inc(nrOfStoredFiles);
                End;
              SetLength(Entries,_NrOfFiles);
              Entries[_NrOfFiles-1] := Entry;
              FreeMem(p,pSize);
              If Addr(CallBack) <> Nil Then Callback((FilesEst Shl 16) Or _NrOfFiles,PChar(S));
            End;
          Find_Error := FindNext(SR);
        End;
      Sysutils.FindClose(SR);
    End;  {sub Proc. RecoursiveAction}

Begin {Func. CitiesXL_PAK_maker_bacter}
  If (TrgtPAKfileName = '') Then
    Begin
      Result := False;
      Exit;
    End;
  DirZaroBackSlashHozzaAd(SrcDir); // append BackSlash if needed
  SrcDirNameLen := Length(SrcDir);
  If Not DirectoryExists(SrcDir) Then
    Begin
      Result := False;
      Exit;
    End;
  If Addr(CallBack) <> Nil Then Callback(0,'preparing...');
  FilesEst := __estimated_NrOfFiles(SrcDir);
  If FilesEst = 0 Then
    Begin
      // empty directory
      Result := False;
      Exit;
    End;
  // Opening the file and writing an empty header:
  AssignFile(f,TrgtPAKfileName);
  ReWrite(f,1);
  FillChar(Header,SizeOf(Header),0);
  BlockWrite(f,Header,SizeOf(Header));
  FileIndex := SizeOf(Header);
  // Collecting the files:
  _NrOfFiles := 0;
  nrOfStoredFiles := 0;
  nrOfZlibbedFiles := 0;
  SetLength(Entries,_NrOfFiles+1);
  If Addr(CallBack) <> Nil Then Callback(0,'scanning the directory...');

  pMainSHA1ctx := Addr(MainSHA1ctx);
  SHA1Init(pMainSHA1ctx);
  RecoursiveAction(SrcDir);

  pakDirTableSize := 0;
  For I := 0 To _NrOfFiles - 1 Do
    Begin
      Inc(pakDirTableSize,40 + Entries[I].FileName.Hossz);
    End;
  pakFileSize := FileIndex + pakDirTableSize;
  SetLength(p,pakDirTableSize);
  Index := 0;
  For I := 0 To _NrOfFiles - 1 Do
    Begin
      Move(Entries[I].StoredSize,p[Index],40);
      Inc(Index,40);
      If (0 < Entries[I].FileName.Hossz) Then
        Begin
          Move(Entries[I].FileName.Chars[0],p[Index],Entries[I].FileName.Hossz);
          Inc(Index,Entries[I].FileName.Hossz);
        End;
    End;

  CitiesXL_aluigi_trick(@p[0],pakDirTableSize);

  SHA1Update(pMainSHA1ctx,p[0],pakDirTableSize);
  SHA1Final(pMainSHA1ctx,(Addr(MainSHA1)));

  BlockWrite(f,p[0],pakDirTableSize);

  If Addr(CallBack) <> Nil Then Callback(0,'finishing...');
  // filling out the Header:
  Header.ID := 'MCPK';
  Header.Version := 3;
  Header.UnknownInt := $129;
  //
  Header.SHA1 := MainSHA1;
  //
  Header.DirStartPos := FileIndex;
  Header.NrOfFiles := _NrOfFiles;
  Header.PaddingZero_0 := 0;
  Header.PaddingZero_1 := 0;
  Seek(f,0);
  BlockWrite(f,Header,SizeOf(Header));
  CloseFile(f);
  Result := True;
End;  {Func. CitiesXL_PAKfile_maker_bacter}


Function Long2Hex(L : LongInt) : String;
Var Szamok : Array[0..15] Of Char;
    S : String[9];
    I : Byte;
Begin {Func Long2Hex}
  Result := IntToHex(L,8);
End;  {Func Long2Hex}


Function L_String_2_String(L_S : L_String) : String;
Var S : String;
Begin {Func. L_String_2_String}
  SetLength(S,L_S.Hossz);
  If 0 < L_S.Hossz Then Move(L_S.Chars[0],S[1],L_S.Hossz);
  Result := S;
End;  {Func. L_String_2_String}


Function CitiesXL_PAKfile_2_TSL(PAKfileName : String;Var TSL : TStringList) : Boolean;
Var S : String;
    I,J : Integer;
    POZOCSKA : Integer;
    Header : CitiesXL_PAK_HeaderType;
    Entry : CitiesXL_PAK_EntryType;
    p : Array Of Byte;
    Index : Integer;
    pakFileSize : Integer;
    pakDirSize : Integer;
    BeolvDb : Integer;
    f : File;
    FM0 : Word;
    calculatedSHA1 : Int160;
    HibaDb : Integer;

    Function Get_LStr : L_String;
    Var LS : L_String;
    Begin {sub Func. Get_LStr}
     Move(p[Index],LS.Hossz,4);
     Inc(Index,4);
     SetLength(LS.Chars,LS.Hossz);
     If 0 < LS.Hossz Then
       Begin
         Move(p[Index],LS.Chars[0],LS.Hossz);
         Inc(Index,LS.Hossz);
       End;
     Result := LS;
    End;  {sub Func. Get_LStr}

    Function Get_Int : Integer;
    Var I : Integer;
    Begin {sub Func. Get_Int}
      Move(p[Index],I,4);
      Inc(Index,4);
      Result := I;
    End;  {sub Func. Get_Int}


Begin {Func. CitiesXL_PAKfile_2_TSL}
  TSL.Clear;
  TSL.Sorted := False;
  If Not FileExists(PAKfileName) Then
    Begin
      Result := False;
      Exit;
    End;
  HibaDb := 0;
  AssignFile(f,PAKfileName);
  FM0 := FileMode;
  FileMode := fmOpenRead;
  ReSet(f,1);
  FileMode := FM0;
  FillChar(Header,SizeOf(Header),0);
  BlockRead(f,Header,SizeOf(Header),BeolvDb);
  pakFileSize := FileSize(f);
  pakDirSize := pakFileSize - Header.DirStartPos;
  If (BeolvDb <> SizeOf(Header)) Or (Header.NrOfFiles < 0) Or
     (Header.DirStartPos < SizeOf(Header)) Or (Header.Version <> 3) Or
     (Header.PaddingZero_0 <> 0) Or (Header.PaddingZero_1 <> 0) Or
     (pakFileSize < Header.DirStartPos) Then
        Begin
          CloseFile(f);
          Result := False;
          Exit;
       End;

  SetLength(p,pakDirSize+1024);
  Seek(f,Header.DirStartPos);
  BlockRead(f,p[0],pakDirSize);
  CloseFile(f);

  If Not CitiesXL_aluigi_trick(p,pakDirSize) Then
    Begin
      Result := False;
      Exit;
    End;

  Index := 0;
  For I := 0 To Header.NrOfFiles - 1 Do
    Begin
      POZOCSKA := Index;
      Entry.StoredSize := Get_Int;
      Entry.OriginalSize := Get_Int;
      Entry.FileStartPos := Get_Int;

      For J := 0 To 4 Do
        Begin
          Entry.SHA1.I[J] := Get_Int;
        End;
      Entry.Flag := Get_Int;
      Entry.FileName := Get_LStr;
      // ----------------
      S := Long2Hex(POZOCSKA) + '*' +
           Long2Hex(Entry.StoredSize) + '*' +
           Long2Hex(Entry.OriginalSize) + '*' +
           Long2Hex(Entry.FileStartPos) + '*';
      For J := 0 To 4 Do
        Begin
          S := S + Long2Hex(Entry.SHA1.I[J]) + '*';
        End;
      S := S + Long2Hex(Entry.Flag) + '*';
      S := S + L_String_2_String(Entry.FileName);
      If S[Length(S)] = #0 Then
        Begin
          Delete(S,Length(S),1);
        End Else
        Begin
          Inc(HibaDb);
        End;
      TSL.Append(S);
    End;
  Result := (Index = pakDirSize) And (HibaDb = 0);
End;  {Func. CitiesXL_PAKfile_2_TSL}


Procedure Slash2BackSlashS(Var S : String);
Var I : Integer;
Begin {Proc. Slash2BackSlashS}
  For I := 1 To Length(S) Do
    Begin
      If S[I] = '/' Then S[I] := '\';
    End;
End;  {Proc. Slash2BackSlashS}

Function LastCharPos(S:String;Ch:Char) : Integer;
Var I,IttVan : Integer;
Begin {Func. LastCharPos}
  IttVan := 0;
  For I := 1 To Length(S) Do
    If S[I] = Ch Then IttVan := I;
  Result := IttVan;
End; {Func. LastCharPos}



Function FileList2DirList(Var FileSL:TStringList;
                          Var DirSL:TStringList;
                          ElejePlusz,VegePlusz : Integer) : Integer;
Var I,FileDb,DirDb,XI : Integer;
    S,AktFullName,AktDirName,XS : String;
Begin {Proc. FileList2DirList}
  DirSL.Clear;
  DirDb := 0;
  FileDb := FileSL.Count;
  For I := 0 To FileDb-1 Do
    Begin
      S := FileSL.Strings[I];
      If 0 < ElejePlusz Then
        Delete(S,1,ElejePlusz);
      If 0 < VegePlusz Then
        S := Copy(S,1,Length(S)-VegePlusz);
      Slash2BackSlashS(S);

      AktFullName := S;
      AktDirName := Copy(AktFullName,1,LastCharPos(AktFullName,'\'));
      If AktDirName <> '' Then
        Begin
          If 0 <= DirSL.IndexOf(AktDirName) Then
            Begin
            End Else
            Begin
              XS := '';
              While AktDirName <> '' Do
                Begin
                  XI := Pos('\',AktDirName);
                  XS := XS+Copy(AktDirName,1,XI);
                  Delete(AktDirName,1,XI);
                  If 0 <= DirSL.IndexOf(XS) Then
                    Begin
                      // ez mar benne van
                    End Else
                    Begin
                      DirSL.Append(XS);
                      Inc(DirDb);
                    End;
                End;
            End;
        End Else
        Begin
        End;
    End;
  DirSL.Sort;
  Result := DirDb;
End;   {Proc. FileList2DirList}


Procedure MakeSubDirs(Dir:String;PName : PChar);
Var S : String;
    PerPoz : Byte;
Begin {Proc. MakeSubDirs}
  If Dir = '' Then Dir := '.';
  If Dir[Length(Dir)] <> '\' Then Dir := Dir + '\';
  S := StrPas(PName);
  While (S <> '') And (1 < Pos('\',S)) Do
    Begin
      PerPoz := Pos('\',S);
      Dir := Dir + Copy(S,1,PerPoz-1);
      Delete(S,1,PerPoz);
      If Not DirectoryExists(Dir) Then
        Begin
          MkDir(Dir);
        End;
      Dir := Dir+'\';
    End;
End;  {Proc. MakeSubDirs}


Procedure MakeSubDirsFromStringList(StartDir:String;TSL:TStringList);
Var I,ListaDb : Integer;
    S : String;
    p : PChar;
Begin {Proc. MakeSubDirsFromStringList}
  ListaDb := TSL.Count;
  If ListaDb = 0 Then
    Begin
      Exit;
    End;
  For I := 0 To ListaDb-1 Do
    Begin
      S := TSL.Strings[I] + #0;
      p := Addr(S[1]);
      MakeSubDirs(StartDir,p);
    End;
End;  {Proc. MakeSubDirsFromStringList}


Function Hex2Dec(S:String) : LongInt;
Var L : LongInt;
    B : Byte;
    Ch : Char;
Begin {Func. Hex2Dec}
  L := 0;
  While S <> '' Do
    Begin
      Ch := UpCase(S[1]);
      Delete(S,1,1);
      If Ch In ['1'..'9'] Then
        Begin
          B := Byte(Ch) - 48;
        End Else
      If Ch In ['A'..'F'] Then
        Begin
          B := Byte(Ch) - 55;
        End Else
        Begin
          // BAD HEX NUMBER!!!
          B := 0;
        End;
      L := L*16+B;
    End;
  Hex2Dec := L;
End;  {Func. Hex2Dec}



Function CitiesXL_PAK_eXtract_bacter(PAKfileName,
                                     TargetDir : String;
                                     CallBack : TCallBackProcL;
                                     Var Success : Boolean) : Integer;
Var TSL,DirSL : TStringList;
    f,f2 : File;
    Drb,SikerDrb : Integer;
    I,J : Integer;
    S,FN : String;
    CallBackS : String;
    CallBackLong1,CallBackLong2 : LongInt;
    FM0 : Word;
    Flag : Integer;
    OrigFileSize,PackedSize,FilePoz : Integer;
    p,p2 : Pointer;
    zlibOutSize : Integer;
    storedSHA1,calculatedSHA1 : Int160;
    SHAHibaDb : Integer;

Begin {Function CitiesXL_PAK_eXtract_bacter}
  SHAHibaDb := 0;

  Success := False;
  If Not DirectoryExists(TargetDir) Then
    Begin
      Result := -1;
      Exit;
    End;
  TSL := TStringList.Create;
  //If Addr(CallBack) <> Nil Then Callback(0,'generating the file list...');
  If Not CitiesXL_PAKfile_2_TSL(PAKfileName,TSL) Then
    Begin
      TSL.Free;
      Result := -1;
      Exit;
    End;
  DirSL := TStringList.Create;
  FileList2DirList(TSL,DirSL,90,0);
  DirZaroBackSlashHozzaad(TargetDir);
  If Addr(CallBack) <> Nil Then Callback(0,'creating sub-directory structure...');

  MakeSubDirsFromStringList(TargetDir,DirSL);
  DirSL.Free;
  FM0 := FileMode;
  FileMode := fmOpenRead; // = 0
  AssignFile(f,PAKfileName);
  ReSet(f,1);
  FileMode := FM0;
  SikerDrb := 0;
  Drb := TSL.Count;
  For I := 0 To Drb-1 Do
    Begin
      S := TSL.Strings[I];
      PackedSize := Hex2Dec(Copy(S,10,8));
      OrigFileSize := Hex2Dec(Copy(S,19,8));
      FilePoz := Hex2Dec(Copy(S,28,8));
      Flag := Hex2Dec(Copy(S,82,8));

      For J := 0 To 4 Do
        storedSHA1.I[J] := Hex2Dec(Copy(S,37+J*9,8));

      FN := S;
      Delete(FN,1,90);
      CallBackS := FN;
      Slash2BackSlashS(FN);

      AssignFile(f2,TargetDir+FN);
      ReWrite(f2,1);
      If (0 < OrigFileSize) Then
        Begin
          If FilePos(f) <> FilePoz Then Seek(f,FilePoz);
          GetMem(p,PackedSize);
          BlockRead(f,p^,PackedSize);
          If Flag = _citiesXL_flag_NO_COMP Then // 0
            Begin
              BlockWrite(f2,p^,OrigFileSize);
              Inc(SikerDrb);
              calculatedSHA1 := SHA1_Calculate(p,OrigFileSize);
              If Not CompareMem(@storedSHA1,@calculatedSHA1,20) Then Inc(SHAHibaDb);
            End Else
          If Flag = _citiesXL_flag_ZLIB Then // $100
            Begin
              // ZLIB!
              DecompressBuf(p,PackedSize,OrigFileSize,p2,zlibOutSize);
              If zlibOutSize = OrigFileSize Then
              Begin
                BlockWrite(f2,p2^,zlibOutSize);
                Inc(SikerDrb);

                calculatedSHA1 := SHA1_Calculate(p2,zlibOutSize);
                If Not CompareMem(@storedSHA1,@calculatedSHA1,20) Then Inc(SHAHibaDb);

              End;
              FreeMem(p2,zlibOutSize);
            End Else
            Begin
              // error!
            End;
          FreeMem(p,PackedSize);
        End Else
        Begin
          Inc(SikerDrb);
        End;
      CloseFile(f2);
      If Addr(CallBack) <> Nil Then
        Begin
          CallBackLong1 := I+1;
          CallBackLong2 := Drb;
          CallBack((CallBackLong2 Shl 16)Or CallBackLong1,PChar(CallBackS));
        End;
    End;
  CloseFile(f);
  TSL.Free;
  Success := (Drb = SikerDrb) And (SHAHibaDb = 0);
  If Success Then Result := Drb
             Else Result := -1;
End;  {Function CitiesXL_PAK_eXtract_bacter}


end.
