unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, ShellApi, IniFiles, DateUtils, Process, FileUtil,
  unit2;

const
  APP_NAME = 'KodStick Apache MicroServer 2.0';

type

  TDllInfo = class(TObject)
    FileName: string;
    ModulName: string;
    Info: string;
  end;

  { TfrmMain }

  TfrmMain = class(TForm)
    ilPm: TImageList;
    ilTray: TImageList;
    pmPhpVer: TMenuItem;
    pmKodStick: TMenuItem;
    pmLog: TMenuItem;
    pmRestartServer: TMenuItem;
    N4: TMenuItem;
    pmExit: TMenuItem;
    pmApache: TMenuItem;
    pmRun: TMenuItem;
    N1: TMenuItem;
    pmGithub: TMenuItem;
    N2: TMenuItem;
    pmBrowser: TMenuItem;
    N3: TMenuItem;
    pmTray: TPopupMenu;
    tmr: TTimer;
    tray: TTrayIcon;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure pmBrowserClick(Sender: TObject);
    procedure pmExitClick(Sender: TObject);
    procedure pmGithubClick(Sender: TObject);
    procedure pmKodStickClick(Sender: TObject);
    procedure pmLogClick(Sender: TObject);
    procedure pmRestartServerClick(Sender: TObject);
    procedure pmTrayPopup(Sender: TObject);
    procedure tmrTimer(Sender: TObject);
  private

  public

  end;

var
  frmMain: TfrmMain;
  ini: TIniFile;
  path, port: string;
  apache_file: string;
  apache_log: string;
  APACHE_NAME: string;
  max_logfile: integer;
  browser, param: string;
  proc_apache: TProcess;
  TimeStart: TDateTime;

implementation

{$R *.lfm}

{ TfrmMain }

function GetDLLVer(const dll_fnm: string): string;
var
  i: integer;
  FileVerInfo: TFileVersionInfo;
  FileName, ModulName: string;
  aDllInfo: TDllInfo;
begin
  FileVerInfo := nil;
  try
    FileVerInfo := TFileVersionInfo.Create(nil);
    FileVerInfo.FileName := dll_fnm;
    try
      FileVerInfo.ReadFileInfo;
      ModulName := FileVerInfo.VersionStrings.Values['InternalName'];
      if ModulName <> '' then
      begin
        aDllInfo := TDllInfo.Create;
        aDllInfo.FileName := dll_fnm;
        aDllInfo.ModulName := ModulName;
        aDllInfo.Info := FileVerInfo.VersionStrings.Values['FileVersion'];
        Result := aDllInfo.Info;
      end;
    finally
      ; // nothing to do
    end;
  finally
    FileVerInfo.Free;
  end;
end;

function GetFileSize(const FileName: string): longint;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(FileName), faAnyFile, SearchRec) = 0 then
    Result := SearchRec.Size
  else
    Result := -1;
end;

procedure TfrmMain.pmExitClick(Sender: TObject);
begin
  Tag := 1;
  Close;
end;

procedure TfrmMain.pmGithubClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar('https://github.com/shaoziyang/KodStick'),
    nil, nil, 1);
end;

procedure TfrmMain.pmKodStickClick(Sender: TObject);
begin

end;

procedure TfrmMain.pmLogClick(Sender: TObject);
begin
  if frmServerLog.Visible then
    frmServerLog.FormShow(Sender);
  frmServerLog.Show;
end;

procedure TfrmMain.pmRestartServerClick(Sender: TObject);
begin
  proc_apache.Terminate(0);
end;

procedure TfrmMain.pmTrayPopup(Sender: TObject);
var
  T: int64;
  year, month, day, hour, min, sec, ms: word;
  ts: string;
begin

  T := SecondsBetween(Now(), TimeStart);
  day := T div (24 * 3600);
  T := T mod (24 * 3600);
  hour := T div 3600;
  T := T mod 3600;
  min := T div 60;
  sec := T mod 60;

  ts := '';

  if (day > 0) then
    ts := ts + Format('%d day ', [day]);
  if (hour > 0) then
    ts := ts + Format('%d hour ', [hour]);
  if (min > 0) then
    ts := ts + Format('%d min ', [min]);
  if (sec > 0) then
    ts := ts + Format('%d sec', [sec]);
  pmRun.Caption := 'Running: ' + ts;
end;

procedure TfrmMain.tmrTimer(Sender: TObject);
begin
  pmKodStick.Enabled := proc_apache.Running;
  if proc_apache.Running then
  begin
    if ilTray.Tag <> tray.Tag then
    begin
      ilTray.Tag := tray.Tag;
      ilTray.GetIcon(ilTray.Tag, tray.Icon);
    end;
  end
  else
  begin
    proc_apache.Execute;
    if ilTray.Tag <> 0 then
    begin
      ilTray.Tag := 0;
      ilTray.GetIcon(0, tray.Icon);
    end;
  end;

end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := (Tag = 1);
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  proc_apache.Terminate(0);
  proc_apache.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  s: string;
  f: TextFile;
  sr: TSearchRec;
begin
  TimeStart := Now();
  path := ExtractFilePath(ParamStr(0));
  pmKodStick.Caption:=APP_NAME;

  // get server port from file 'httpd.conf'
  port := '80';
  try
    AssignFile(f, path + 'server\conf\httpd.conf');
    Reset(f);
    while not EOF(f) do
    begin
      readln(f, s);
      if StrLIComp(PChar(s), PChar('Listen '), 7) = 0 then
      begin
        Delete(s, 1, 7);
        port := s;
        break;
      end;
    end;
  except

  end;
  CloseFile(f);

  if FindFirst(path + 'server\php*ts.dll', faAnyFile, sr) = 0 then
  begin
    try
      pmPhpVer.Caption := 'PHP: ' + GetDLLVer(path + 'server\' + sr.Name);
    except

    end;
  end;

  // read config.ini
  ini := TIniFile.Create(path + 'config.ini');
  browser := ini.ReadString('option', 'browser', '');
  param := ini.ReadString('option', 'param', '');
  max_logfile := ini.ReadInteger('option', 'max_logfile', 1000000);
  APACHE_NAME := ini.ReadString('option', 'apache_filename', '');
  apache_log := path + 'server\logs\error.log';
  tray.Tag := ini.ReadInteger('option', 'style', 1);
  ini.Free;

  if tray.Tag < 1 then
    tray.Tag := 1;
  if tray.Tag >= ilTray.Count then
    tray.Tag := ilTray.Count - 1;

  if APACHE_NAME = '' then
  begin
    ShowMessage('No apache file name specified.');
    Application.Terminate;
  end;

  // check apach server file
  apache_file := path + 'server\' + APACHE_NAME;
  if not FileExists(apache_file) then
  begin
    ShowMessage('Apache file not found!');
    Application.Terminate;
  end;

  pmApache.Caption := 'Apache: [' + APACHE_NAME + ':' + port + ']';
  pmRun.Caption := 'Run: ';
  if browser <> '' then
    pmBrowser.Caption := 'Launch <' + browser + '>';

  // check log file size
  try
    if GetFileSize(path + 'server\logs\error.log') > max_logfile then
      DeleteFile(path + 'server\logs\error.log');
  except

  end;

  // set apache process paramters
  proc_apache := TProcess.Create(nil);
  proc_apache.Executable := apache_file;
  proc_apache.CurrentDirectory := path + 'server';
  proc_apache.Options := proc_apache.Options + [poNoConsole];
end;

procedure TfrmMain.pmBrowserClick(Sender: TObject);
begin
  if browser <> '' then
    ShellExecute(Handle, 'open', PChar(browser),
      PChar(param + ' http://localhost:' + port), nil, 1)
  else
    ShellExecute(Handle, 'open', PChar('http://localhost:' + port), nil, nil, 1);
end;

end.
