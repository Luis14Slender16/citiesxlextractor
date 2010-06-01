[Files]
Source: C:\Users\Jeremy\Desktop\citiesxlextractor\quickbms.exe; DestDir: {app}
Source: C:\Users\Jeremy\Desktop\citiesxlextractor\citiesxl.bms; DestDir: {app}
Source: C:\Users\Jeremy\Desktop\citiesxlextractor\Extractor.exe; DestDir: {app}
Source: languages\de.ini; DestDir: {app}\languages\
Source: languages\en.ini; DestDir: {app}\languages\
Source: languages\fr.ini; DestDir: {app}\languages\
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
[Dirs]
Name: {app}\languages
