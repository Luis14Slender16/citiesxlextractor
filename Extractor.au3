#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Fileversion=1.0.0.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Debug.au3>

$AppName = "Cities XL Extractor"
$AppVersion = FileGetVersion(@ScriptFullPath)
$PakFolder = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Monte Cristo\Cities XL_PATH", "Path")
If $PakFolder = "" Then $PakFolder = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Monte Cristo\Cities XL_PATH", "Path") ;64bit compliance
$OutputFolder = @DesktopDir&"\CitiesXL_Data_Files"
$SinglePak = ""

$var = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion", "ProgramFilesDir")


#Region ### START Koda GUI section ### Form=c:\users\jeremy\desktop\citiesxl_pak_extrator\cxlextractor.kxf
GUICreate("CXL Pak Extractor", 523, 369, -1, -1)

$File = GUICtrlCreateMenu("&File")
	$MenuExit = GUICtrlCreateMenuItem("Exit", $File)
$Help = GUICtrlCreateMenu("&Help")
	$menuUpdates = GUICtrlCreateMenuItem("Check For Updates", $Help)
	$menuHelp = GUICtrlCreateMenuItem("Help", $Help)
	$menuAbout = GUICtrlCreateMenuItem("About", $Help)

GUICtrlCreateLabel("Cities XL Pak and Patch file extractor", 48, 8, 434, 33)
GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")

GUICtrlCreateGroup("Multiple File Extract", 8, 48, 505, 161)
	$inputPakFolder = GUICtrlCreateInput($PakFolder, 16, 88, 401, 21)
	GUICtrlCreateLabel("Cities XL Pak Folder", 16, 64, 99, 17)
	$btnInstallFolderSelect = GUICtrlCreateButton("Select...", 424, 80, 75, 17, $WS_GROUP)
	GUICtrlCreateLabel("Output Folder", 16, 120, 68, 17)
	$inputOutputFolder = GUICtrlCreateInput($OutputFolder, 16, 136, 401, 21)
	$btnOuputFolderSelect = GUICtrlCreateButton("Select...", 424, 138, 75, 17, $WS_GROUP)
	$btnExtractAll = GUICtrlCreateButton("Extract All", 223, 168, 75, 25, $WS_GROUP)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup("Single File Extract", 8, 216, 505, 113)
	GUICtrlCreateLabel("Pak File to extract:", 16, 240, 92, 17)
	$inputSinglePak = GUICtrlCreateInput($SinglePak, 16, 264, 401, 21)
	$btnSinglePakSelect = GUICtrlCreateButton("Select...", 424, 264, 75, 17, $WS_GROUP)
	$btnExtractSingle = GUICtrlCreateButton("Extract", 224, 296, 75, 25, $WS_GROUP)
GUICtrlCreateGroup("", -99, -99, 1, 1)

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

	Case $menuHelp

	Case $menuAbout
		_About()
	Case $btnInstallFolderSelect

	Case $btnOuputFolderSelect

	Case $btnExtractAll

	Case $btnSinglePakSelect

	Case $btnExtractSingle

EndSwitch
WEnd

Func _About()
	#Region ### START Koda GUI section ### Form=C:\Users\Jeremy\Desktop\citiesxlextractor\about.kxf
	$aboutform = GUICreate("About", 328, 231, 302, 218)
	GUISetIcon("D:\006.ico")
	GUICtrlCreateGroup("", 8, 8, 305, 169)
	GUICtrlCreateLabel("Product Name", 80, 24, 72, 17, $WS_GROUP)
	GUICtrlCreateLabel("Version", 80, 48, 39, 17, $WS_GROUP)
	GUICtrlCreateLabel("Comments", 24, 104, 53, 17, $WS_GROUP)
	GUICtrlCreateLabel("Copyright", 24, 72, 48, 17, $WS_GROUP)
	GUICtrlCreateLabel($AppName, 160, 24, 67, 17)
	GUICtrlCreateLabel($AppVersion, 128, 48, 74, 17)
	GUICtrlCreateLabel("GNU General Public License v3", 72, 72, 155, 17)
	GUICtrlCreateEdit("", 80, 104, 217, 65, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$ES_WANTRETURN))
	GUICtrlSetData(-1, StringFormat("Special Thanks to QuickBMS from\r\nhttp://xentax.com for making this possible"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$btnOk = GUICtrlCreateButton("&OK", 112, 192, 75, 25)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($aboutform)
			Case $btnOk
				GUIDelete($aboutform)
		EndSwitch
	WEnd
EndFunc

Func _DebugMsg()

EndFunc
