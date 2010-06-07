[Files]
Source: languages\de.ini; DestDir: {app}\languages\
Source: languages\en.ini; DestDir: {app}\languages\
Source: languages\fr.ini; DestDir: {app}\languages\
Source: Compiled\citiesXL_project.exe; DestDir: {app}
Source: Compiled\Extractor.exe; DestDir: {app}
[Icons]
Name: {group}\Cities XL Extractor; Filename: {app}\Extractor.exe; IconFilename: {app}\Extractor.exe; IconIndex: 0
[Setup]
OutputDir=.\Compiled
AppName=Cities XL Extractor
AppVerName=Cities XL Extractor
DefaultDirName={pf}\CitiesXLExtractor
AllowNoIcons=true
DefaultGroupName=Cities XL Extractor
AlwaysShowComponentsList=false
ShowComponentSizes=false
FlatComponentsList=false
DisableReadyPage=true
VersionInfoVersion=2.1
VersionInfoProductName=Cities XL Extractor
VersionInfoProductVersion=2.0
[Dirs]
Name: {app}\languages
[Registry]
Root: HKCU; Subkey: Software\CitiesXL Extractor; ValueType: string; ValueName: ActiveTab; ValueData: 0; Flags: createvalueifdoesntexist uninsdeletekey
Root: HKCR; SubKey: Folder\shell\CitiesXLPatch; ValueType: string; ValueName: Icon; ValueData: """C:\Program Files (x86)\CitiesXLExtractor\Extractor.exe"""; Flags: uninsdeletekey
Root: HKCR; SubKey: Folder\shell\CitiesXLPatch; ValueType: string; ValueData: Create Cities XL .patch file; Flags: uninsdeletekey
Root: HKCR; SubKey: Folder\shell\CitiesXLPatch\command; ValueType: string; ValueData: """C:\Program Files (x86)\CitiesXLExtractor\Extractor.exe"" /c ""%1"""; Flags: uninsdeletekey
