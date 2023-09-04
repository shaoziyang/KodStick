program KodPortable;

{$mode objfpc}{$H+}

uses
  Classes,
  Windows,
  jwatlhelp32,
  SysUtils,
  Process,
  IniFiles;

var
  ini: TIniFile;
  path, server_path: string;
  port, s: string;
  apache_file: string;
  APACHE_NAME: string;
  browser, param: string;
  max_logfile: integer;
  f: TextFile;
  proc_apache, proc_brow: TProcess;

{$R *.res}

  function GetFileSize(const FileName: string): longint;
  var
    SearchRec: TSearchRec;
  begin
    if FindFirst(ExpandFileName(FileName), faAnyFile, SearchRec) = 0 then
      Result := SearchRec.Size
    else
      Result := -1;
  end;

function KillProcess(const ExeName: string): integer;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;

begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := 0;

  while integer(ContinueLoop) <> 0 do
    begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeName))) then
      begin
      Inc(Result);
      TerminateProcess(OpenProcess(Process_Terminate, False, FProcessEntry32.th32ProcessID), 0);
      end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
    end;

  CloseHandle(FSnapshotHandle);
end;

begin
  //Application.Scaled:=True;

  path := ExtractFilePath(ParamStr(0));

  ini := TIniFile.Create(path + 'config.ini');
  browser := ini.ReadString('option', 'PortableBrowser', '');
  param := ini.ReadString('option', 'PortableBrowserParam', '');
  max_logfile := ini.ReadInteger('option', 'max_logfile', 1000000);
  APACHE_NAME := ini.ReadString('option', 'apache_filename', '');
  server_path := ini.ReadString('option', 'server_path', 'server');
  ini.Free;

  port := '80';
  try
    AssignFile(f, path + server_path + '\conf\httpd.conf');
    Reset(f);
    while not EOF(f) do
    begin
      readln(f, s);
      if StrLComp(PChar(s), PChar('Listen '), 7) = 0 then
      begin
        Delete(s, 1, 7);
        port := s;
        break;
      end;
    end;
    CloseFile(f);
  except

  end;

  //if browser = '' then
  //begin
  //  MessageBox(0, 'No browser specified.', 'Error!', MB_OK + MB_ICONSTOP);
  //  Halt(1);
  //end;

  if APACHE_NAME = '' then
  begin
    MessageBox(0, 'No apache file name specified.', 'Error!', MB_OK + MB_ICONSTOP);
    Halt(2);
  end;

  apache_file := path + server_path + '\' + APACHE_NAME;
  if not FileExists(apache_file) then
  begin
    MessageBox(0, 'Apache file not found!', 'Error!', MB_OK + MB_ICONSTOP);
    Halt(1);
  end;

  try
    if GetFileSize(path + 'server\logs\error.log') > max_logfile then
      DeleteFile(path + 'server\logs\error.log');
  except

  end;

  proc_apache:=TProcess.Create(nil);
  proc_apache.Executable:=apache_file;
  proc_apache.CurrentDirectory:=path + server_path;
  proc_apache.Options:=proc_apache.Options+[poNoConsole];
  proc_apache.Execute;

  proc_brow:=TProcess.Create(nil);
  proc_brow.Executable:=browser;
  proc_brow.Parameters.Add(param + ' http://localhost:' + port);
  proc_brow.Options:=proc_brow.Options + [poWaitOnExit];
  proc_brow.Execute;
  proc_brow.Free;

  proc_apache.Terminate(0);
  proc_apache.Free;
  KillProcess(APACHE_NAME);
  Halt(0);
end.
