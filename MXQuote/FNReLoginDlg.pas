unit FNReLoginDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, Messages, FNDataSet,
  AgentGlobalVariable, HDFCommAgentLib_TLB;

type
  TReLoginDlg = class(TForm)
    Label1: TLabel;
    TimerAutoRun: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerAutoRunTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);

  private
  private
    m_AutoRunState: Integer;
    m_AutoRunStartTime: TDateTime;

    procedure ApplyLanguage;

  public
    SECLogin: Boolean;
  end;

var
  ReLoginDlg: TReLoginDlg;

implementation

uses
  FNRegistry, FNGlobal, FNGlobalVariable, FNCMVariable, MXVariable;

{$R *.dfm}

// ---------------------------------------------------------------------------
procedure TReLoginDlg.ApplyLanguage;
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
// ---------------------------------------------------------------------------
procedure TReLoginDlg.FormCreate(Sender: TObject);
begin
  Caption := g_ApplicationName;

  ApplyLanguage;
end;

// ---------------------------------------------------------------------------
procedure TReLoginDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

// ---------------------------------------------------------------------------
procedure TReLoginDlg.FormShow(Sender: TObject);
begin
  SECLogin := false;

  m_AutoRunState := 0;
  m_AutoRunStartTime := 0;
  TimerAutoRun.Enabled := true;
end;

// ---------------------------------------------------------------------------
procedure TReLoginDlg.FormHide(Sender: TObject);
begin
  TimerAutoRun.Enabled := false;
end;

// ---------------------------------------------------------------------------
procedure TReLoginDlg.TimerAutoRunTimer(Sender: TObject);
var
  f_MainHWnd: HWND;
  f_HWnd: HWND;
  f_Version: Integer;
  f_VStr1: String;
  f_VStr2: String;
  I: Integer;

  f_Stream: TStringStream;
  f_FileName: String;
begin
  if m_AutoRunState = 0 then
  begin
    TimerAutoRun.Interval := 1000;
    if Trunc((Now - m_AutoRunStartTime) * 86400000) > 10000 then
    begin
      m_AutoRunStartTime := Now;

      g_HDCommAgent.CommTerminate(1);

      if (0 > g_HDCommAgent.CommInit(1)) then
      begin
        m_AutoRunState := 0;
        exit;
      end;
      m_AutoRunState := 1;
      if 1 = g_HDCommAgent.CommLogin(g_SecUserID, g_SecUserPW, g_SecCertPW) then
      begin
        Close;
      end
      else
      begin
        m_AutoRunState := 0;
      end;
    end;
  end
  else if m_AutoRunState = 1 then
  begin
    TimerAutoRun.Interval := 5000;
    f_MainHWnd := TMXGlobal.GetCertDialogHandle;
    if f_MainHWnd <> 0 then
    begin
      f_HWnd := FindWindowEx(f_MainHWnd, HWND(NIL), 'Button', PChar('인증서 선택(확인)'));
      SendMessage(f_HWnd, BM_CLICK, 0, 0);
      m_AutoRunState := 2;
    end;
  end;
end;

end.
