unit FNAgentDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AgentGlobalVariable, OleCtrls, WROControl, COMMOCXLib_TLB, H5MGREXLib_TLB;

type
  TAgentDlg = class(TForm)
    CommOCX1: TCommOCX;
    H5MgrEx1: TH5MgrEx;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  AgentDlg: TAgentDlg;

implementation

{$R *.dfm}

uses
    FNCMVariable, MXVariable, FNWROAgentManager, H5MGREXLib_Const;

procedure TAgentDlg.FormCreate(Sender: TObject);
begin
    //  현재 다이얼 로그의 캡션을 설정한다.
    Caption := g_ApplicationName;
    g_WRCommAgent := CommOCX1;
    g_H5MgrEx := H5MgrEx1;
    //CFNWROAgentManager(g_AgentManager).AssignHandle(Handle);
    //CFNWROAgentManager(g_AgentManager).AssignAgent(g_WRCommAgent);
    //g_WRCommAgent.Parent := Self;
    //g_WRCommAgent.Width := 0;
    //g_WRCommAgent.Height := 0;
end;


procedure TAgentDlg.FormShow(Sender: TObject);
var
    f_AppName:Array [0..256] of AnsiChar;
    f_Value:Integer;
    f_Address:Integer;
    f_ApplicationName : WideString;
begin
    StrPCopy(f_AppName, AnsiString('Hi5Pro_2014'));
    f_Address := Integer(Addr(f_AppName[0]));
    //Addr(f_AppName[0]);
    //g_H5MgrEx.HFCommand(hf_INITH5MGR, , 0);
    f_ApplicationName := 'Hi5Pro_2014';
    f_Value := g_H5MgrEx.HFCommand(hf_INITH5MGR, f_Address, 0);
    if (f_Value <> HE_OK) then
    begin
        ShowMessage(Format('H5MgrEx 초기화 오류입니다. Ecode[%d]', [f_Value]));
    end;
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
