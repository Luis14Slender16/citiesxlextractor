'==========================================================================
'
'  File:        PAK.vb
'  Location:    CitiesXLLoc <Visual Basic .Net>
'  Description: CitiesXL PAK文件包
'  Version:     2010.05.07.
'  Copyright(C) F.R.C. / 3DMGame
'
'==========================================================================

Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.IO
Imports System.IO.Compression
Imports System.Text.RegularExpressions
Imports System.Security.Cryptography
Imports Firefly
Imports Firefly.Packaging
Imports Firefly.TextEncoding
Imports Firefly.Setting

Public Class PAK
    Inherits PackageDiscrete

    Public Class FileIndexDB
        Public CompressedLength As Int32
        Public OriginalLength As Int32
        Public Address As Int32
        Public SHA1 As Byte()
        Public Unknown2 As Int32
        Public Name As String
    End Class

    Private Shared Key As Byte() = New Byte() {&H3E, &HA9, &HA0, &H39, &H4A, &HAB, &H44, &HAA, &HDD, &H14, &H8C, &HFA, &HFA, &H5C, &H66, &H93}  'MD5 of "allocator"

    Private Version As Int32
    Private Unknown2 As Int32
    Private GeneralSHA1 As Byte()

    Private IndexStart As Int32
    Private FileIndexList As New List(Of FileIndexDB)

    Private Sub New()
    End Sub
    Public Sub New(ByVal sp As ZeroPositionStreamPasser)
        MyBase.New(sp)

        Dim s = sp.GetStream

        If s.ReadSimpleString(4) <> "MCPK" Then Throw New InvalidDataException
        Version = s.ReadInt32
        Unknown2 = s.ReadInt32
        GeneralSHA1 = s.Read(20)

        IndexStart = s.ReadInt32
        Dim NumFile = s.ReadInt32
        If s.ReadInt32 <> 0 Then Throw New InvalidDataException
        If s.ReadInt32 <> 0 Then Throw New InvalidDataException

        s.Position = IndexStart
        Dim IndexBytes = s.Read(s.Length - IndexStart)
        Select Case Version
            Case 3
                IndexBytes = RC4.Decrypt(Key, IndexBytes)
        End Select

        'Using st As New StreamEx("IndexTable.bin", FileMode.Create, FileAccess.ReadWrite)
        '    st.Write(IndexBytes)
        'End Using

        Using bs As New ByteArrayStream(IndexBytes)
            For n = 0 To NumFile - 1
                Dim CompressedLength = bs.ReadInt32
                Dim OriginalLength = bs.ReadInt32
                Dim Address = bs.ReadInt32
                Dim SHA1 = bs.Read(20)
                Dim Unknown2 = bs.ReadInt32
                If Unknown2 <> 256 Then Throw New InvalidDataException
                Dim NameLength = bs.ReadInt32
                Dim NameBytes = bs.Read(NameLength - 1)
                If bs.ReadByte <> 0 Then Throw New InvalidDataException
                Dim Name As String = ASCII.GetChars(NameBytes)

                Dim f = FileDB.CreateFile(Name, CompressedLength, Address)
                PushFile(f)
                f.TitleName = "{0,-24} {1,10}".Formats(f.Name, OriginalLength)

                FileIndexList.Add(New FileIndexDB With {.CompressedLength = CompressedLength, .OriginalLength = OriginalLength, .Address = Address, .SHA1 = SHA1, .Unknown2 = Unknown2, .Name = Name})
            Next
        End Using

        ScanHoles(&H30)
    End Sub

    Public Shared ReadOnly Property Filter() As String
        Get
            Return "CitiesXLLoc MCPK文件包(*.pak;*.patch;*.sgbin)|*.pak;*.patch;*.sgbin"
        End Get
    End Property

    Public Shared Function Open(ByVal Path As String) As PackageBase
        Dim s As StreamEx
        Try
            s = New StreamEx(Path, FileMode.Open, FileAccess.ReadWrite)
        Catch
            s = New StreamEx(Path, FileMode.Open, FileAccess.Read)
        End Try
        Return New PAK(s)
    End Function

    Public Overrides Property FileAddressInPhysicalFileDB(ByVal File As FileDB) As Int64
        Get
            Return FileIndexList(IndexOfFile(File)).Address
        End Get
        Set(ByVal Value As Int64)
            FileIndexList(IndexOfFile(File)).Address = Value
        End Set
    End Property

    Public Overrides Property FileLengthInPhysicalFileDB(ByVal File As FileDB) As Int64
        Get
            Return FileIndexList(IndexOfFile(File)).CompressedLength
        End Get
        Set(ByVal Value As Int64)
            FileIndexList(IndexOfFile(File)).CompressedLength = Value
        End Set
    End Property

    Public Property FileOriginalLengthInPhysicalFileDB(ByVal File As FileDB) As Int64
        Get
            Return FileIndexList(IndexOfFile(File)).OriginalLength
        End Get
        Set(ByVal Value As Int64)
            FileIndexList(IndexOfFile(File)).OriginalLength = Value
        End Set
    End Property

    Protected Overrides Sub ExtractInner(ByVal File As Firefly.Packaging.FileDB, ByVal sp As Firefly.ZeroPositionStreamPasser)
        Using s As New StreamEx
            MyBase.ExtractInner(File, s)

            s.Position = 0
            Dim Data = s.Read(s.Length)
            Dim OriginalData = ZlibCompression.Decompress(Data)

            sp.GetStream.Write(OriginalData)
        End Using
    End Sub

    Private Sub WriteIndexData()
        Dim IndexBytes As Byte() = Nothing

        Using bs As New StreamEx
            For Each f In FileIndexList
                bs.WriteInt32(f.CompressedLength)
                bs.WriteInt32(f.OriginalLength)
                bs.WriteInt32(f.Address)
                bs.Write(f.SHA1)
                bs.WriteInt32(f.Unknown2)
                Dim NameBytes = ASCII.GetBytes(f.Name)
                bs.WriteInt32(NameBytes.Length + 1)
                bs.Write(NameBytes)
                bs.WriteByte(0)
            Next

            bs.Position = 0
            IndexBytes = bs.Read(bs.Length)
        End Using

        Select Case Version
            Case 3
                IndexBytes = RC4.Encrypt(Key, IndexBytes)
        End Select

        IndexStart = (From f In Files Select f.Address + f.Length).Max

        Dim s = BaseStream

        s.Position = IndexStart
        s.Write(IndexBytes)
        s.SetLength(s.Position)

        s.Position = &H20
        s.WriteInt32(IndexStart)

        s.Position = &H30
        Using p As New PartialStreamEx(s, &H30, s.Length - &H30)
            GeneralSHA1 = GetSHA1(p.ToUnsafeStream)
        End Using
        s.Position = 12
        s.Write(GeneralSHA1)
    End Sub

    Private Function GetSHA1(ByVal b As Byte()) As Byte()
        Dim sha As New SHA1CryptoServiceProvider()
        Dim ret = sha.ComputeHash(b)
        If ret.Length <> 20 Then Throw New InvalidOperationException
        Return ret
    End Function

    Private Function GetSHA1(ByVal s As Stream) As Byte()
        Dim sha As New SHA1CryptoServiceProvider()
        Dim ret = sha.ComputeHash(s)
        If ret.Length <> 20 Then Throw New InvalidOperationException
        Return ret
    End Function

    Public Overrides Sub Replace(ByVal File As FileDB, ByVal sp As ZeroPositionStreamPasser)
        Dim fs = sp.GetStream
        Dim OriginalLength = fs.Length
        Dim Data = fs.Read(fs.Length)
        Dim CompressedData = ZlibCompression.Compress(Data)
        Dim SHA1 = GetSHA1(Data)

        Using s As New ByteArrayStream(CompressedData)
            MyBase.Replace(File, s)
        End Using

        FileIndexList(IndexOfFile(File)).SHA1 = SHA1
        FileOriginalLengthInPhysicalFileDB(File) = OriginalLength
        WriteIndexData()
    End Sub

    Protected Overrides Sub ReplaceMultipleInner(ByVal Files() As FileDB, ByVal Paths() As String)
        For n = 0 To Files.Length - 1
            Dim File = Files(n)
            Dim Path = Paths(n)

            Using fs As New StreamEx(Path, FileMode.Open, FileAccess.Read)
                Dim OriginalLength = fs.Length
                Dim Data = fs.Read(fs.Length)
                Dim CompressedData = ZlibCompression.Compress(Data)
                Dim SHA1 = GetSHA1(Data)

                Using s As New ByteArrayStream(CompressedData)
                    MyBase.Replace(File, s)
                End Using

                FileIndexList(IndexOfFile(File)).SHA1 = SHA1
                FileOriginalLengthInPhysicalFileDB(File) = OriginalLength
            End Using
        Next

        WriteIndexData()
    End Sub

    Protected Overrides Function GetSpace(ByVal Length As Int64) As Int64
        Return Length
    End Function

    Public Sub WriteToXml(ByVal XmlPath As String)
        Dim p As New PAKDescriptor
        p.Unknown1 = Version
        p.Unknown2 = Unknown2
        p.Unknown3 = GeneralSHA1

        Dim l = (From i In FileIndexList Select New IndexDescriptor With {.Path = i.Name, .Unknown1 = i.SHA1}).ToList
        p.Indices = l

        Xml.WriteFile(XmlPath, UTF16, p, New Xml.IMapper() {New ByteArrayEncoder})
    End Sub

    Public Shared Function CreateFromXml(ByVal Path As String, ByVal XmlPath As String) As PAK
        Dim p = Xml.ReadFile(Of PAKDescriptor)(XmlPath, New Xml.IMapper() {New ByteArrayEncoder})

        Dim pa As New PAK

        With pa
            Dim s As New StreamEx(Path, FileMode.Create, FileAccess.ReadWrite)
            .BaseStream = s

            s.WriteSimpleString("MCPK", 4)
            .Version = p.Unknown1
            .Unknown2 = p.Unknown2
            .GeneralSHA1 = p.Unknown3

            s.WriteInt32(.Version)
            s.WriteInt32(.Unknown2)
            s.Write(.GeneralSHA1)

            .IndexStart = &H30
            s.WriteInt32(.IndexStart)
            Dim NumFile = p.Indices.Count
            s.WriteInt32(NumFile)
            s.WriteInt32(0)
            s.WriteInt32(0)

            Dim IndexBytes As Byte() = Nothing

            Using bs As New StreamEx
                For Each i In p.Indices
                    Dim CompressedLength = 0
                    Dim OriginalLength = 0
                    Dim Address = .IndexStart
                    Dim Unknown1 = i.Unknown1
                    Dim Unknown2 = 256
                    bs.WriteInt32(CompressedLength)
                    bs.WriteInt32(OriginalLength)
                    bs.WriteInt32(Address)
                    bs.Write(Unknown1)
                    bs.WriteInt32(Unknown2)
                    Dim Name = i.Path
                    Dim NameBytes = ASCII.GetBytes(Name)
                    bs.WriteInt32(NameBytes.Length + 1)
                    bs.Write(NameBytes)
                    bs.WriteByte(0)

                    Dim f = FileDB.CreateFile(Name, CompressedLength, Address)
                    .PushFile(f)
                    f.TitleName = "{0,-24} {1,10}".Formats(f.Name, OriginalLength)

                    .FileIndexList.Add(New FileIndexDB With {.CompressedLength = CompressedLength, .OriginalLength = OriginalLength, .Address = Address, .SHA1 = Unknown1, .Unknown2 = Unknown2, .Name = Name})
                Next

                bs.Position = 0
                IndexBytes = bs.Read(bs.Length)
            End Using

            Select Case .Version
                Case 3
                    IndexBytes = RC4.Encrypt(Key, IndexBytes)
            End Select

            s.Write(IndexBytes)

            .ScanHoles(&H30)
        End With

        Return pa
    End Function
End Class

Public Class PAKDescriptor
    Public Unknown1 As Int32
    Public Unknown2 As Int32
    Public Unknown3 As Byte()

    Public Indices As List(Of IndexDescriptor)
End Class

Public Class IndexDescriptor
    Public Path As String
    Public Unknown1 As Byte()
End Class

Public Class ByteArrayEncoder
    Inherits Xml.Mapper(Of Byte(), String)

    Public Overrides Function GetMappedObject(ByVal o As Byte()) As String
        Return String.Join(" ", (From b In o Select b.ToString("X2")).ToArray)
    End Function

    Public Overrides Function GetInverseMappedObject(ByVal o As String) As Byte()
        Return (From s In Regex.Split(o.Trim(" \t\r\n".Descape.ToCharArray), "( |\t|\r|\n)+", RegexOptions.ExplicitCapture) Select Byte.Parse(s, Globalization.NumberStyles.HexNumber)).ToArray
    End Function
End Class
