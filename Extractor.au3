#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
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
	$inputPakFolder = GUICtrlCreateInput("%PakFolder%", 16, 88, 401, 21)
	GUICtrlCreateLabel("Cities XL Pak Folder", 16, 64, 99, 17)
	$btnInstallFolderSelect = GUICtrlCreateButton("Select...", 424, 80, 75, 17, $WS_GROUP)
	GUICtrlCreateLabel("Output Folder", 16, 120, 68, 17)
	$inputOutputFolder = GUICtrlCreateInput("%OutputFolder%", 16, 136, 401, 21)
	$btnOuputFolderSelect = GUICtrlCreateButton("Select...", 424, 138, 75, 17, $WS_GROUP)
	$btnExtractAll = GUICtrlCreateButton("Extract All", 223, 168, 75, 25, $WS_GROUP)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup("Single File Extract", 8, 216, 505, 113)
	GUICtrlCreateLabel("Pak File to extract:", 16, 240, 92, 17)
	$inputSinglePak = GUICtrlCreateInput("%SinglePak%", 16, 264, 401, 21)
	$btnSinglePakSelect = GUICtrlCreateButton("Select...", 424, 264, 75, 17, $WS_GROUP)
	$btnExtractSingle = GUICtrlCreateButton("Extract", 224, 296, 75, 25, $WS_GROUP)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
;~ Dim $CXLExtractor_AccelTable[1][2] = [["{F1}", $menuHelp]]
;~ GUISetAccelerators($CXLExtractor_AccelTable)
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

	Case $btnInstallFolderSelect

	Case $btnOuputFolderSelect

	Case $btnExtractAll

	Case $btnSinglePakSelect

	Case $btnExtractSingle

EndSwitch
WEnd
