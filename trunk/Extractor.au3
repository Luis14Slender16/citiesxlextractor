#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=icon.ico
#AutoIt3Wrapper_outfile=Compiled\Extractor.exe
#AutoIt3Wrapper_Res_Fileversion=1.0.0.22
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Debug.au3>
#include <Array.au3>
#Include <File.au3>

Global $language = _LanguageDetect()
_DebugMsg("Language Set to "&$language)

$AppName = _Text("appname")
$AppVersion = FileGetVersion(@ScriptFullPath)
$installFolder = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Monte Cristo\Cities XL_PATH", "Path")
$ActiveTab = RegRead("HKCU\Software\CitiesXL Extractor", "ActiveTab")
If $installFolder = "" Then $installFolder = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Monte Cristo\Cities XL_PATH", "Path") ;64bit compliance
$PakFolder = $installFolder&"\Paks"
$OutputFolder = @DesktopDir&"\CitiesXL_Data_Files"
$SinglePakOuput = $OutputFolder
$SinglePak = ""

#Region ### START Koda GUI section ### Form=C:\Users\Jeremy\Desktop\citiesxlextract\trunk\CXLExtractor.kxf
$_1 = GUICreate(_Text("apptitle"), 611, 269, -1, -1)
$File = GUICtrlCreateMenu(_Text("filemenu"))
$MenuExit = GUICtrlCreateMenuItem(_Text("exitmenu"), $File)
$Help = GUICtrlCreateMenu(_Text("helpmenu"))
$menuUpdates = GUICtrlCreateMenuItem(_Text("updatemenu"), $Help)
$menuHelp = GUICtrlCreateMenuItem(_Text("helpmenu"), $Help)
$menuAbout = GUICtrlCreateMenuItem(_Text("aboutmenu"), $Help)
GUICtrlCreateLabel(_Text("title"), 36, 8, 538, 33, $SS_CENTER)
GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")
$Tab1 = GUICtrlCreateTab(10, 56, 590, 177)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$tabRestoreSingle = GUICtrlCreateTabItem(_Text("tabSingle"))
$inputOutputFolder1 = GUICtrlCreateInput($OutputFolder, 39, 109, 440, 21)
GUICtrlCreateLabel(_Text("outputfolder"), 34, 86, 135, 17)
GUICtrlCreateLabel(_Text("PakFile"), 34, 139, 135, 17)
$inputSinglePak = GUICtrlCreateInput($SinglePak, 39, 161, 440, 21)
$btnExtractSingle = GUICtrlCreateButton(_Text("extract"), 267, 191, 75, 25, $WS_GROUP)
$btnSinglePakSelect = GUICtrlCreateButton(_Text("btnselect"), 489, 161, 75, 17, $WS_GROUP)
$btnOutputFolder1 = GUICtrlCreateButton(_Text("btnselect"), 489, 111, 75, 17, $WS_GROUP)
$tabRestoreBatch = GUICtrlCreateTabItem(_Text("tabMulti"))
$inputOutputFolder2 = GUICtrlCreateInput($OutputFolder, 39, 109, 440, 21)
GUICtrlCreateLabel(_Text("outputfolder"), 34, 86, 135, 17)
$btnOutputFolder2 = GUICtrlCreateButton(_Text("btnselect"), 489, 111, 75, 17, $WS_GROUP)
GUICtrlCreateLabel(_Text("pakfolder"), 34, 139, 135, 17)
$inputPakFolder = GUICtrlCreateInput($PakFolder, 39, 161, 440, 21)
$btnInstallFolderSelect = GUICtrlCreateButton(_Text("btnselect"), 489, 161, 75, 17, $WS_GROUP)
$btnExtractAll = GUICtrlCreateButton(_Text("extractall"), 267, 191, 75, 25, $WS_GROUP)
$tabCompile = GUICtrlCreateTabItem(_Text("tabPackage"))
GUICtrlCreateLabel(_Text("outputfile"), 34, 86, 135, 17)
$inputPackageOutput = GUICtrlCreateInput("", 39, 109, 440, 21)
$btnPackageOutputSelect = GUICtrlCreateButton(_Text("btnselect"), 489, 111, 75, 17, $WS_GROUP)
$btnPackageInputSelect = GUICtrlCreateButton(_Text("btnselect"), 489, 161, 75, 17, $WS_GROUP)
$inputPackageInput = GUICtrlCreateInput("", 39, 161, 440, 21)
$btnCompile = GUICtrlCreateButton(_Text("btnCompile"), 267, 191, 75, 25, $WS_GROUP)
GUICtrlCreateLabel(_Text("CompileFolder"), 34, 139, 135, 17)
GUICtrlCreateTabItem("")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

If $ActiveTab Then
	If $ActiveTab = 0 Then GUICtrlSetState($tabRestoreSingle, $GUI_SHOW)
	If $ActiveTab = 1 Then GUICtrlSetState($tabRestoreBatch, $GUI_SHOW)
	If $ActiveTab = 2 Then GUICtrlSetState($tabCompile, $GUI_SHOW)
EndIf
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
	Case $GUI_EVENT_CLOSE
		Exit
	Case $MenuExit
		Exit

	Case $Tab1
		RegWrite("HKCU\Software\CitiesXL Extractor", "ActiveTab", "REG_SZ", GUICtrlRead($Tab1))

	Case $menuUpdates
		MsgBox(0, _Text("msgsry"), _Text("msgsry2"))

	Case $menuHelp
		MsgBox(0, _Text("msgsry"), _Text("msgsry2"))

	Case $menuAbout
		_About()

	Case $btnInstallFolderSelect
		$ScanFolder = FileSelectFolder(_Text("SelectFolderScan"), "")
		GUICtrlSetData($inputPakFolder, $ScanFolder)

	Case $btnOutputFolder1
		_outputfolderselect()

	Case $btnOutputFolder2
		_outputfolderselect()

	Case $btnSinglePakSelect
		$SinglePak = FileOpenDialog(_Text("SelectSinglePak"), $PakFolder & "\", "Archives (*.pak;*.patch)", 1)
		GUICtrlSetData($inputSinglePak, $SinglePak)

	Case $btnPackageOutputSelect
		$OutputFile = FileSaveDialog(_Text("SaveAs"), $PakFolder & "\", "Patch File (*.patch)|Pak File (*.pak)", 16)
		If Not StringInStr($OutputFile, ".patch") And Not StringInStr($OutputFile, ".pak") Then $OutputFile = $OutputFile&".patch"
		GUICtrlSetData($inputPackageOutput, $OutputFile)

	Case $btnPackageInputSelect
		$PackageInputFolder = FileSelectFolder(_Text("CompileFolder"), "", 2)
		GUICtrlSetData($inputPackageInput, $PackageInputFolder)

	Case $btnExtractAll
		_ExtractFiles(GUICtrlRead($inputPakFolder), GUICtrlRead($inputOutputFolder2))

	Case $btnExtractSingle
		_ExtractFiles(GUICtrlRead($inputSinglePak), GUICtrlRead($inputOutputFolder1))

	Case $btnCompile
		_Compile(GUICtrlRead($inputPackageOutput), GUICtrlRead($inputPackageInput))

EndSwitch
WEnd

Func _About()
	#Region ### START Koda GUI section ### Form=C:\Users\Jeremy\Desktop\citiesxlextractor\about.kxf
	$aboutform = GUICreate("About", 328, 231, 302, 218)
	GUISetIcon("D:\006.ico")
	GUICtrlCreateGroup("", 8, 8, 305, 169)
	GUICtrlCreateLabel(_Text("prodnamelbl","about"), 80, 24, 72, 17, $WS_GROUP)
	GUICtrlCreateLabel(_Text("versionlbl","about"), 80, 48, 39, 17, $WS_GROUP)
	GUICtrlCreateLabel(_Text("commentslbl","about"), 24, 104, 53, 17, $WS_GROUP)
	GUICtrlCreateLabel(_Text("copyrightlbl","about"), 24, 72, 48, 17, $WS_GROUP)
	GUICtrlCreateLabel($AppName, 152, 24, 147, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlCreateLabel($AppVersion, 120, 48, 86, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlCreateLabel(_Text("license","about"), 72, 72, 155, 17)
	GUICtrlCreateEdit("", 80, 104, 217, 65, BitOR($ES_READONLY,$ES_WANTRETURN))
	GUICtrlSetData(-1, StringFormat("Special Thanks to QuickBMS from\r\nhttp://xentax.com for making this possible"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$btnOk = GUICtrlCreateButton(_Text("ok","about"), 112, 192, 75, 25)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###


	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($aboutform)
				ExitLoop
			Case $btnOk
				GUIDelete($aboutform)
				ExitLoop
		EndSwitch
	WEnd
EndFunc

Func _Compile($var1, $var2)
	If $var1 = "" Or $var2 = "" Then
		_ErrorMsg(_Text("FillFields"))
	Else
		ShellExecuteWait(@ScriptDir&'\citiesXL_project.exe', 'c "'&$var1&'" "'&$var2&'"')
	EndIf
EndFunc


Func _ExtractFiles($var1, $var2)
	If $var1 = "" Or $var2 = "" Then
		_ErrorMsg(_Text("FillFields"))
	Else
		SplashTextOn(_Text("Progress"), _Text("Extracting")&@CRLF&"Preping Extraction Lists...", 700, 60, -1, 20)
		If Not FileExists($var2) Then DirCreate($var2)
		If StringInStr(FileGetAttrib($var1), "D") Then
			If StringRight($var1, 1) <> "\" Or StringRight($var1, 1) <> "/" Then $var1 = $var1&"\" ; Ensure it ends with a slash
			$listpak = _FileListToArray($var1, "*.pak")
			$listpatch = _FileListToArray($var1, "*.patch")
			$c = 1
			$TotalStep = $listpak[0] + $listpatch[0]
			For $a In $listpak
				$c = $c + 1
				If StringInStr($a, ".patch") Then
					SplashTextOn(_Text("Progress"), _Text("Extracting")&" "&$c&" "&_Text("of")&" "&$TotalStep&": "&@CRLF&$var1&$a, 700, 60, -1, 20)
					ShellExecuteWait(@ScriptDir&'\citiesXL_project.exe', 'x "'&$var1&$a&'" "'&$var2&'"')
				EndIf
			Next
			For $a In $listpatch
				$c = $c + 1
				If StringInStr($a, ".patch") Then
					SplashTextOn(_Text("Progress"), _Text("Extracting")&" "&$c&" "&_Text("of")&" "&$TotalStep&": "&@CRLF&$var1&$a, 700, 60, -1, 20)
					ShellExecuteWait(@ScriptDir&'\citiesXL_project.exe', 'x "'&$var1&$a&'" "'&$var2&'"')
				EndIf
			Next
		Else
			ShellExecuteWait(@ScriptDir&'\citiesXL_project.exe', 'x "'&$var1&'" "'&$var2&'"')
		EndIf
		SplashOff()
	EndIf
EndFunc


Func _outputfolderselect()
		$OutputFolder = FileSelectFolder(_Text("SelectFolderOutput"), "", 7)
		GUICtrlSetData($inputOutputFolder1, $OutputFolder)
		GUICtrlSetData($inputOutputFolder2, $OutputFolder)
EndFunc


Func _DebugMsg($msg="")

EndFunc


Func _ErrorMsg($msg="",$critical=0)
	_DebugMsg($msg)
	MsgBox(48, _Text("error"), $msg)
	If $critical=1 Then Exit
EndFunc


Func _LanguageDetect()
	Select
;~ 		Case StringInStr("0413 0813", @OSLang)
;~ 			Return "Dutch"

		Case StringInStr("0409 0809 0c09 1009 1409 1809 1c09 2009 2409 2809 2c09 3009 3409", @OSLang)
			Return "en"

		Case StringInStr("040c 080c 0c0c 100c 140c 180c", @OSLang)
			Return "fr"

		Case StringInStr("0407 0807 0c07 1007 1407", @OSLang)
			Return "de"

;~ 		Case StringInStr("0410 0810", @OSLang)
;~ 			Return "Italian"

;~ 		Case StringInStr("0414 0814", @OSLang)
;~ 			Return "Norwegian"

;~ 		Case StringInStr("0415", @OSLang)
;~ 			Return "Polish"

;~ 		Case StringInStr("0416 0816", @OSLang)
;~ 			Return "Portuguese"

;~ 		Case StringInStr("040a 080a 0c0a 100a 140a 180a 1c0a 200a 240a 280a 2c0a 300a 340a 380a 3c0a 400a 440a 480a 4c0a 500a", @OSLang)
;~ 			Return "Spanish"

;~ 		Case StringInStr("041d 081d", @OSLang)
;~ 			Return "Swedish"

		Case Else
			Return "en"

    EndSelect
EndFunc

Func _Text($text,$section="core")
	_DebugMsg("Searching for language var of "&$text)
	$var = IniRead(@ScriptDir&"\languages\"&$language&".ini", $section, $text, $text)
	_DebugMsg("Read: "&$var)
	Return $var
EndFunc



