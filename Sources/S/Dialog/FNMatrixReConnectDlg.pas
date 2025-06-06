unit FNMatrixReConnectDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, Messages, FNDataSet,
  FNSocketManager, FNLoadController, FNLoadItem;

type
  TMatrixReConnectDlg = class(TForm)
    TimerAutoRun: TTimer;
    Label1: TLabel;
    Label2: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerAutoRunTimer(Sender: TObject);

  private
    m_LoadItem_USER: CFNLoadItem_USER_0120;
    m_LoginController: CFNLoadController;
    m_SocketEvent : TFNSocketEvent;

    procedure ApplyLanguage;

    procedure OnLoginStartEvent(p_Item: CFNLoadItem);
    procedure OnLoginCompleteEvent(p_Item: CFNLoadItem);
    procedure OnLoginFaultEvent(p_Item: CFNLoadItem);
    procedure OnItemLoadMessageEvent(p_Item: CFNLoadItem);

  private
    m_AutoRunState: Integer;
    m_AutoRunStartTime: TDateTime;
    m_TryCount: Integer;

  public

  end;

var
  MatrixReConnectDlg: TMatrixReConnectDlg;

implementation

uses
  FNRegistry, FNGlobal, FNGlobalVariable, FNCMVariable, MXVariable;

{$R *.dfm}

// ---------------------------------------------------------------------------
procedure TMatrixReConnectDlg.ApplyLanguage;
begin
  if (g_Language = 0) then
  begin
    Label1.Caption := '재접속을 시도 합니다.';
  end
  else if (g_Language = 1) then
  begin
    Label1.Caption := 'Try to reconnect.';
  end;
end;

// ---------------------------------------------------------------------------
// 화면이 처음 시작할 때 초기화 하는 부분이다.
//
// ---------------------------------------------------------------------------
procedure TMatrixReConnectDlg.FormCreate(Sender: TObject);
begin
  m_SocketEvent := g_SocketManager.OnSocketEvent;
  g_SocketManager.OnSocketEvent := NIL;

  m_LoginController := CFNLoadController.Create;
  m_LoginController.AddItem(CFNLoadItemSocket.Create);
  m_LoadItem_USER := CFNLoadItem_USER_0120.Create;
  m_LoginController.AddItem(m_LoadItem_USER);

  m_LoginController.OnStartEvent := OnLoginStartEvent;
  m_LoginController.OnCompleteEvent := OnLoginCompleteEvent;
  m_LoginController.OnFaultEvent := OnLoginFaultEvent;
  m_LoginController.OnItemLoadMessageEvent := OnItemLoadMessageEvent;

  Caption := g_ApplicationName;

  m_AutoRunState := 0;
  m_AutoRunStartTime := 0;

  TimerAutoRun.Enabled := TRUE;
  m_TryCount := 0;

  ApplyLanguage;

end;

// ---------------------------------------------------------------------------
procedure TMatrixReConnectDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

// ---------------------------------------------------------------------------
procedure TMatrixReConnectDlg.OnLoginStartEvent(p_Item: CFNLoadItem);
begin

end;

// ---------------------------------------------------------------------------
procedure TMatrixReConnectDlg.OnLoginCompleteEvent(p_Item: CFNLoadItem);
begin
  m_AutoRunState := 1;
end;

// ---------------------------------------------------------------------------
procedure TMatrixReConnectDlg.OnLoginFaultEvent(p_Item: CFNLoadItem);
begin
  m_AutoRunState := 0;
end;

// ---------------------------------------------------------------------------
procedure TMatrixReConnectDlg.OnItemLoadMessageEvent(p_Item: CFNLoadItem);
begin
  if Assigned(p_Item) then
  begin
    if (p_Item.ResultMessage <> '') then
      Label1.Caption := p_Item.ResultMessage;
  end;
end;

// ---------------------------------------------------------------------------
procedure TMatrixReConnectDlg.TimerAutoRunTimer(Sender: TObject);
var
  f_Done: Boolean;
begin
  f_Done := false;

  if m_AutoRunState = 0 then
  begin
    m_AutoRunState := 1;

    TimerAutoRun.Interval := 10000;

    m_LoadItem_USER.m_USER_ID := UpperCase(g_MatrixUserID);
    m_LoadItem_USER.m_PASSWORD := UpperCase(TMXGlobal.MD5Hash(g_MatrixUserPW));
    m_LoadItem_USER.m_PGM_CODE := g_PGMCode;

    m_LoginController.Load;

  end else
  if m_AutoRunState = 1 then
  begin
      if (g_SocketManager.GetConnected) then
      begin
        m_AutoRunState := 2;
        g_SocketManager.ReSubscribeAll;
        g_SocketManager.OnSocketEvent := m_SocketEvent;
        Close;
      end else
      begin
        m_AutoRunState := 0;
      end;
  end;
end;

end.
