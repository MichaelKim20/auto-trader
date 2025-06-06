unit FNAgentDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AgentGlobalVariable, OleCtrls, HDFCommAgentLib_TLB;

type
  TAgentDlg = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  end;

var
  AgentDlg: TAgentDlg;

implementation

{$R *.dfm}

uses
  FNCMVariable, MXVariable, FNHDAgentManager, FNGlobal;

procedure TAgentDlg.FormCreate(Sender: TObject);
begin
  // 현재 다이얼 로그의 캡션을 설정한다.
  Caption := g_ApplicationName;

  g_HDCommAgent := THDFCommAgent.Create(Self);
  g_HDCommAgent.Parent := Self;
  g_HDAgentManager.AssignAgent(g_HDCommAgent);

  // g_HDCommAgent := HDFCommAgent1;
  // CFNHDAgentManager(g_AgentManager).AssignHandle(Handle);
  // CFNHDAgentManager(g_AgentManager).AssignAgent(g_HDCommAgent);
  // g_HDCommAgent.Parent := Self;
  // g_HDCommAgent.Width := 0;
  // g_HDCommAgent.Height := 0;
end;

procedure TAgentDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  // CFNHDAgentManager(g_AgentManager).AssignHandle(HWND(NIL));
  // g_WRCommAgent.OCommTerminate;
  // g_WRCommAgent.Parent := NIL;
  // g_WRCommAgent.OCommTerminate;
end;

end.
