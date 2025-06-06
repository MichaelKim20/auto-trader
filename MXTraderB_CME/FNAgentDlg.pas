unit FNAgentDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AgentGlobalVariable, OleCtrls, WROControl, COMMOCXLib_TLB;

type
  TAgentDlg = class(TForm)
    CommOCX1: TCommOCX;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  AgentDlg: TAgentDlg;

implementation

{$R *.dfm}

uses
    FNCMVariable, MXVariable, FNWROAgentManager;

procedure TAgentDlg.FormCreate(Sender: TObject);
begin
    //  현재 다이얼 로그의 캡션을 설정한다.
    Caption := g_ApplicationName;
    g_WRCommAgent := CommOCX1;
    //CFNWROAgentManager(g_AgentManager).AssignHandle(Handle);
    //CFNWROAgentManager(g_AgentManager).AssignAgent(g_WRCommAgent);
    //g_WRCommAgent.Parent := Self;
    //g_WRCommAgent.Width := 0;
    //g_WRCommAgent.Height := 0;
end;


procedure TAgentDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
    //CFNWROAgentManager(g_AgentManager).AssignHandle(HWND(NIL));
    //g_WRCommAgent.OCommTerminate;
    //g_WRCommAgent.Parent := NIL;
    //g_WRCommAgent.OCommTerminate;
end;

end.
