unit FNReLoginDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Sockets,
  Buttons, ExtCtrls, Dialogs, Messages, FNDataSet,
  AgentGlobalVariable, COMMOCXLib_TLB, H5MGREXLib_TLB;

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

    procedure OnSocketStatus(ASender: TObject; nStatus: Smallint);

  private
    m_AutoRunState:Integer;
    m_AutoRunStartTime:TDateTime;

    FOnSocketStatus: TCommOCXOSocketStatus;

  private
    procedure OnH5Receive(ASender: TObject; type_: Integer; pBytes: Integer; nBytes: Integer);
    procedure DoH5Login;
    procedure H5SignOn;

  private
    m_ServerIP1:WideString;
    m_ServerIP2:WideString;
    FOnH5MgrExReceive: TH5MgrExReceive;

  public
    SECLogin:Boolean;
  end;

var
  ReLoginDlg: TReLoginDlg;

implementation

uses
  FNRegistry, FNGlobal, FNGlobalVariable, FNCMVariable, MXVariable, H5MGREXLib_Const;

{$R *.dfm}

//---------------------------------------------------------------------------
// 화면이 처음 시작할 때 초기화 하는 부분이다.
//---------------------------------------------------------------------------
procedure TReLoginDlg.FormCreate(Sender: TObject);
begin
    Caption := g_ApplicationName;
end;

//---------------------------------------------------------------------------
procedure TReLoginDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caHide;
end;

//---------------------------------------------------------------------------
procedure TReLoginDlg.FormShow(Sender: TObject);
begin
    SECLogin := false;
    FOnSocketStatus := g_WRCommAgent.OnOSocketStatus;
    g_WRCommAgent.OnOSocketStatus := OnSocketStatus;


    FOnH5MgrExReceive := g_H5MgrEx.OnReceive;
    g_H5MgrEx.OnReceive := OnH5Receive;

    m_AutoRunState := 0;
    m_AutoRunStartTime := 0;
    TimerAutoRun.Enabled := true;
end;

//---------------------------------------------------------------------------
procedure TReLoginDlg.FormHide(Sender: TObject);
begin
    TimerAutoRun.Enabled := false;
    g_WRCommAgent.OnOSocketStatus := FOnSocketStatus;
    g_H5MgrEx.OnReceive := FOnH5MgrExReceive;
end;

//---------------------------------------------------------------------------
procedure TReLoginDlg.TimerAutoRunTimer(Sender: TObject);
var
    f_MainHWnd:HWND;
    f_HWnd:HWND;
begin
    if m_AutoRunState = 0 then
    begin
        TimerAutoRun.Interval := 1000;
        if Trunc((Now - m_AutoRunStartTime) * 86400000) > 10000 then
        begin
            m_AutoRunStartTime := Now;
            m_AutoRunState := 1;

            g_WRCommAgent.OCommTerminate;
            if 0 = g_WRCommAgent.OCommLogin(g_WRSecUserName, g_WRSecPassWord, '') then
            begin
                Label1.Caption := '우리선물 로그인 성공';
                DoH5Login;
            end else
            begin
                Label1.Caption := '우리선물 로그인 실패';
                m_AutoRunState := 0;
            end;

        end;
    end else
    if m_AutoRunState = 1 then
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

//---------------------------------------------------------------------------
procedure TReLoginDlg.OnSocketStatus(ASender: TObject; nStatus: Smallint);
begin
    m_AutoRunState := 0;
end;

//---------------------------------------------------------------------------
procedure TReLoginDlg.DoH5Login;
begin
    //  실전
    if g_SecTradeMode = SEC_TRADE_MODE_REAL then
    begin
        m_ServerIP1 := g_H5MgrEx.GetServerIP(Integer('0'));
        m_ServerIP2 := g_H5MgrEx.GetServerIP(Integer('2'));
        g_SecTradeMode := SEC_TRADE_MODE_REAL;
    end else
    //  모의
    begin
        m_ServerIP1 := g_H5MgrEx.GetServerIP(Integer('1'));
        m_ServerIP2 := g_H5MgrEx.GetServerIP(Integer('2'));
        g_SecTradeMode := SEC_TRADE_MODE_TEST;
    end;

    if ('' = m_ServerIP1) then
    begin
        Label1.Caption := '접속 서버 아이피를 얻어 오는데 실패했습니다.!!';
        Update;
        Sleep(3000);
		Close;
    end;

    g_H5MgrEx.HFCommandVB(hf_CONNECT, m_ServerIP1, 15201);
end;

//---------------------------------------------------------------------------
procedure TReLoginDlg.OnH5Receive(ASender: TObject; type_: Integer; pBytes: Integer; nBytes: Integer);
begin
    case type_ of
        FEV_OPEN :
        begin
            if (nBytes = 0) then
            begin
                Label1.Caption := '하나대투 국내 접속 성공';
                Update;
                Sleep(1000);
                H5SignOn;
            end else
            begin
            end;
        end;

        FEV_AXIS:
        begin
            if runAXIS = LOWORD(pBytes) then
            begin
                Label1.Caption := '하나대투 국내 로그인 성공';
                Update;
                Sleep(1000);
                g_H5MgrEx.HFCommandVB(hf_DUALSIGN, m_ServerIP2, 15201);
            end else
            if runDUAL = LOWORD(pBytes) then
            begin
                SECLogin := true;
                Label1.Caption := '하나대투 해외 로그인 성공';
                Update;
                Sleep(1000);
                Close;
            end;
        end;

        FEV_ERROR:
        begin
            if pBytes <> 0 then
            begin
                Label1.Caption := Format('FEV_ERROR[%d---%s]', [pBytes, PAnsiChar(nBytes)]);
                Update;
                Sleep(1000);
                Close;
            end;
        end;
    end;
end;
//---------------------------------------------------------------------------
procedure TReLoginDlg.H5SignOn;
var
    f_SignM:TSignM;
    f_PW:String;
begin
    TFNGlobal.memset(PAnsiChar(@f_SignM), Byte(' '), sizeof(f_SignM));

    if (g_SecTradeMode = SEC_TRADE_MODE_TEST) then
    begin
        f_PW := g_H5MgrEx.GetEncript(g_SecUserPW, g_SecUserID, 1);
        CopyMemory(Addr(f_SignM.user), PAnsiChar(AnsiString(g_SecUserID)), Length(g_SecUserID));
        CopyMemory(Addr(f_SignM.pass), PAnsiChar(AnsiString(f_PW)), Length(f_PW));
        CopyMemory(Addr(f_SignM.cpas), PAnsiChar(AnsiString(g_SecCertPW)), Length(g_SecCertPW));
        CopyMemory(Addr(f_SignM.sips), PAnsiChar(AnsiString(m_ServerIP1)), Length(m_ServerIP1));
        g_H5MgrEx.HFCommand(hf_LOGIN, Integer(@f_SignM), Integer('X'));
    end else
    begin
        f_PW := g_H5MgrEx.GetEncript(g_SecUserPW, g_SecUserID, 1);
        CopyMemory(Addr(f_SignM.user), PAnsiChar(AnsiString(g_SecUserID)), Length(g_SecUserID));
        CopyMemory(Addr(f_SignM.pass), PAnsiChar(AnsiString(f_PW)), Length(f_PW));
        CopyMemory(Addr(f_SignM.cpas), PAnsiChar(AnsiString(g_SecCertPW)), Length(g_SecCertPW));
        CopyMemory(Addr(f_SignM.sips), PAnsiChar(AnsiString(m_ServerIP1)), Length(m_ServerIP1));
        g_H5MgrEx.HFCommand(hf_LOGIN, Integer(@f_SignM), Integer('2'));
    end;
end;

end.
