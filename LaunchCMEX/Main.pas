unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TMainForm = class(TForm)
    Label1: TLabel;
    TimerStep: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimerStepTimer(Sender: TObject);
  private
    m_Step:Integer;

    procedure DisplayHelp;
    procedure Command;

  public

  end;

var
  MainForm: TMainForm;
  g_NewVersion:Boolean;

implementation

{$R *.dfm}

uses
    ShellAPI, FNUpdaterDlg, FNCMVariable;

procedure TMainForm.Command;
var
    f_PARAM:String;
begin
    if m_Step = 1 then
    begin
        UpdaterDlg := TUpdaterDlg.Create(Application);
        if UpdaterDlg.LoadXMLData() then
        begin
            g_NewVersion := UpdaterDlg.IsNewVersion();
            if g_NewVersion then
            begin
                PostMessage(UpdaterDlg.Handle, WM_UPDATER_DOWNLOAD, 0, 0);
                UpdaterDlg.ShowModal();
                Close;
            end else
            begin

                if ParamCount > 0 then
                begin
                    f_PARAM := ParamStr(1);
                end else
                begin
                    f_PARAM := '';
                end;
                ShellExecute(Handle,'open', PWideChar(g_ApplicationName + '.exe'), PWideChar(f_PARAM), '', SW_SHOWNORMAL);
                Close;
            end;
        end;
    end;
end;

procedure TMainForm.DisplayHelp;
begin
    if m_Step = 1 then
    begin
        Label1.Caption := '프로그램을 서버에서 다운받아 실행합니다.';
    end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    Caption := g_ApplicationName;
    m_Step := 1;
    TimerStep.Enabled := true;
end;

procedure TMainForm.TimerStepTimer(Sender: TObject);
begin
    TimerStep.Enabled := false;
    Command;
end;

end.
