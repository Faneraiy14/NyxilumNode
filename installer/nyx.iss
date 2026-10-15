; Інсталятор NyxilumLang (nx + Nx IDE) для Windows - Inno Setup 6.
; Збирається в release.yml:
;   iscc /DMyVersion=1.10.3 /DSrcDir=<publish-out> /O<куди> installer\nyx.iss
; Ставиться для поточного користувача (%LOCALAPPDATA%\Programs\Nyx) - адмін не
; потрібен, і `nx update-self` потім може оновлювати файли сам.

#ifndef MyVersion
  #define MyVersion "0.0.0"
#endif
#ifndef SrcDir
  #define SrcDir "..\publish-out"
#endif

[Setup]
AppId={{8F2B6C1E-4D3A-4B7E-9C5D-2A1F0E6B7C9D}
AppName=NyxilumLang (nx і Nx IDE)
AppVersion={#MyVersion}
AppVerName=NyxilumLang {#MyVersion}
AppPublisher=Faneraiy14
AppPublisherURL=https://github.com/Faneraiy14/NyxilumNode
AppSupportURL=https://github.com/Faneraiy14/NyxilumNode/issues
DefaultDirName={autopf}\Nyx
DefaultGroupName=Nyx
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
ChangesEnvironment=yes
OutputBaseFilename=Nx-win-x64-setup
SetupIconFile={#SrcDir}\ide\assets\icon.ico
UninstallDisplayIcon={app}\ide\assets\icon.ico
UninstallDisplayName=NyxilumLang {#MyVersion}
LicenseFile={#SrcDir}\LICENSE
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "uk"; MessagesFile: "compiler:Languages\Ukrainian.isl"
Name: "en"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Ярлик «Nx IDE» на робочому столі"; GroupDescription: "Ярлики:"
Name: "addtopath"; Description: "Команда nx у терміналі (додати в PATH)"; GroupDescription: "Термінал:"

[Files]
Source: "{#SrcDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; nx - консольна програма: ярлик запускає її згорнутою, щоб чорне вікно
; консолі не висіло поверх IDE
Name: "{group}\Nx IDE"; Filename: "{app}\Nx.exe"; Parameters: "ide"; WorkingDir: "{userdocs}"; IconFilename: "{app}\ide\assets\icon.ico"; Flags: runminimized
Name: "{group}\Видалити NyxilumLang"; Filename: "{uninstallexe}"
Name: "{autodesktop}\Nx IDE"; Filename: "{app}\Nx.exe"; Parameters: "ide"; WorkingDir: "{userdocs}"; IconFilename: "{app}\ide\assets\icon.ico"; Flags: runminimized; Tasks: desktopicon

[Registry]
Root: HKCU; Subkey: "Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}"; Tasks: addtopath; Check: NeedsAddPath(ExpandConstant('{app}'))

[Run]
Filename: "{app}\Nx.exe"; Parameters: "ide"; WorkingDir: "{userdocs}"; Description: "Запустити Nx IDE"; Flags: postinstall nowait skipifsilent runminimized

[UninstallDelete]
; залишок nx update-self
Type: files; Name: "{app}\Nx.exe.old"

[Code]
function NeedsAddPath(Dir: string): Boolean;
var
  Path: string;
begin
  if not RegQueryStringValue(HKCU, 'Environment', 'Path', Path) then
  begin
    Result := True;
    exit;
  end;
  Result := Pos(';' + Uppercase(Dir) + ';', ';' + Uppercase(Path) + ';') = 0;
end;

procedure RemoveFromPath(Dir: string);
var
  Path: string;
  P: Integer;
begin
  if not RegQueryStringValue(HKCU, 'Environment', 'Path', Path) then exit;
  P := Pos(';' + Uppercase(Dir), Uppercase(Path));
  if P > 0 then
  begin
    Delete(Path, P, Length(Dir) + 1);
    RegWriteExpandStringValue(HKCU, 'Environment', 'Path', Path);
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
    RemoveFromPath(ExpandConstant('{app}'));
end;
