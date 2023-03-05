unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, SynEdit, process;

type

  { TfrmServerLog }

  TfrmServerLog = class(TForm)
    btnUpdate: TBitBtn;
    edtLog: TSynEdit;
    procedure btnUpdateClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmServerLog: TfrmServerLog;

implementation

uses
  Unit1;

{$R *.lfm}

{ TfrmServerLog }

procedure TfrmServerLog.FormShow(Sender: TObject);
begin
  btnUpdateClick(Sender);
end;

procedure TfrmServerLog.btnUpdateClick(Sender: TObject);
var
  s: ansistring;
begin
  RunCommand('cmd.exe /c copy/y "' + apache_log + '" "' + apache_log +
    '.1"', [], s, [], swoHIDE);

  edtLog.Clear;
  if FileExists(apache_log + '.1') then
    edtLog.Lines.LoadFromFile(apache_log + '.1');

  edtLog.TopLine := edtLog.Lines.Count - edtLog.LinesInWindow + 5;
end;

end.
