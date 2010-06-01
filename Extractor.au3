#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=icon.ico
#AutoIt3Wrapper_outfile=Compiled\Extractor.exe
#AutoIt3Wrapper_Res_Fileversion=1.0.0.7
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

Global $language = _LanguageDetect()


$AppName = _Text("appname")
$AppVersion = FileGetVersion(@ScriptFullPath)
$installFolder = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Monte Cristo\Cities XL_PATH", "Path")
If $installFolder = "" Then $installFolder = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Monte Cristo\Cities XL_PATH", "Path") ;64bit compliance
$PakFolder = $installFolder&"\Paks"
$OutputFolder = @DesktopDir&"\CitiesXL_Data_Files"
$SinglePakOuput = $OutputFolder
$SinglePak = ""

#Region ### START Koda GUI section ### Form=C:\Users\Jeremy\Desktop\citiesxlextractor\CXLExtractor.kxf
	$_1 = GUICreate(_Text("apptitle"), 523, 414, -1, -1)
	$File = GUICtrlCreateMenu(_Text("filemenu"))
	$MenuExit = GUICtrlCreateMenuItem(_Text("exitmenu"), $File)
	$Help = GUICtrlCreateMenu(_Text("helpmenu"))
	$menuUpdates = GUICtrlCreateMenuItem(_Text("updatemenu"), $Help)
	$menuHelp = GUICtrlCreateMenuItem(_Text("helpmenu"), $Help)
	$menuAbout = GUICtrlCreateMenuItem(_Text("aboutmenu"), $Help)
	GUICtrlCreateLabel(_Text("title"), 24, 8, 474, 33)
	GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")
	GUICtrlCreateGroup(_Text("grplblmulti"), 8, 112, 505, 105)
	$inputPakFolder = GUICtrlCreateInput($PakFolder, 16, 152, 401, 21)
	GUICtrlCreateLabel(_Text("pakfolder"), 16, 128, 99, 17)
	$btnInstallFolderSelect = GUICtrlCreateButton(_Text("select"), 424, 152, 75, 17, $WS_GROUP)
	$btnExtractAll = GUICtrlCreateButton(_Text("extractall"), 232, 184, 75, 25, $WS_GROUP)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup(_Text("grplblSingle"), 8, 224, 505, 105)
	GUICtrlCreateLabel(_Text("PakFile"), 16, 240, 130, 17)
	$inputSinglePak = GUICtrlCreateInput($SinglePak, 16, 264, 401, 21)
	$btnSinglePakSelect = GUICtrlCreateButton(_Text("select"), 424, 264, 75, 17, $WS_GROUP)
	$btnExtractSingle = GUICtrlCreateButton(_Text("extract"), 232, 296, 75, 25, $WS_GROUP)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$inputOutputFolder = GUICtrlCreateInput($OutputFolder, 16, 80, 401, 21)
	$btnOutputFolderSelect = GUICtrlCreateButton(_Text("select"), 424, 80, 75, 17, $WS_GROUP)
	GUICtrlCreateLabel(_Text("outputfolder"), 16, 56, 71, 17)
	GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
	Case $GUI_EVENT_CLOSE
		Exit
	Case $MenuExit
		Exit

	Case $menuUpdates
		MsgBox(0, "Sorry", "Not yet...")

	Case $menuHelp
		MsgBox(0, "Sorry", "Not yet...")

	Case $menuAbout
		_About()

	Case $btnInstallFolderSelect
		$PakFolder = FileSelectFolder("Select a Folder to scan...", "c:\")
		GUICtrlSetData($inputPakFolder, $PakFolder)

	Case $btnOutputFolderSelect
		$OutputFolder = FileSelectFolder("Select a Folder to output all files to...", "c:\", 7)
		GUICtrlSetData($inputOutputFolder, $OutputFolder)

	Case $btnSinglePakSelect
		$SinglePak = FileOpenDialog("Select File to extract...", $PakFolder & "\", "Archives (*.pak;*.patch)", 1)
		GUICtrlSetData($inputSinglePak, $SinglePak)

	Case $btnExtractAll
		If Not FileExists(GUICtrlRead($inputOutputFolder)) Then DirCreate(GUICtrlRead($inputOutputFolder))
		RunWait(@ComSpec & " /c " & '""'&@ScriptDir&'\quickbms.exe" -o "'&@ScriptDir&'\citiesxl.bms" "'&GUICtrlRead($inputPakFolder)&'" "'&GUICtrlRead($inputOutputFolder)&'""')

	Case $btnExtractSingle
		If Not FileExists(GUICtrlRead($inputOutputFolder)) Then DirCreate(GUICtrlRead($inputOutputFolder))
		RunWait(@ComSpec & " /c " & '""'&@ScriptDir&'\quickbms.exe" -o "'&@ScriptDir&'\citiesxl.bms" "'&GUICtrlRead($inputSinglePak)&'" "'&GUICtrlRead($inputOutputFolder)&'""')

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

Func _DebugMsg($msg="")

EndFunc

Func _ErrorMsg($msg="")

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

Func _DownloadDotNet4()
	InetGet("http://citiesxlextractor.googlecode.com/files/dotNetFx40_Full_x86_x64.exe", "dotNet40_Full.exe", 1, 1)
	SplashTextOn("Downloading", "Dot Net 4.0", 200, 50)
	While @InetGetActive
		Sleep(500)
	Wend
	SplashOff()
EndFunc

Func _Text($text,$section="core")
	_DebugMsg("Searching for language var of "&$text)
	$var = IniRead(@ScriptDir&"\languages\"&$language&".ini", $section, $text, $text)
	_DebugMsg("Read: "&$var)
	Return $var
EndFunc



