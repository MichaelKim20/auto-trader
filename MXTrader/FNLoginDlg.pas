unit FNLoginDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, Messages, FNSocketManager, FNDataDelivery,
  FNDataSet,
  AgentGlobalVariable, FNLoadController, FNLoadItem, OleCtrls, DCPsha1, DCPrc4,
  IdHTTP,
  pngimage, GR32_Image, ActnList, jpeg, inifiles;

const
  WM_SEC_LOGIN = WM_USER + 1234;

type
  TLoginDlg = class(TForm)
    Panel1: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    Panel3: TPanel;
    Panel2: TPanel;
    Bevel2: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    EditSecUserName: TEdit;
    EditSecPassWord1: TEdit;
    MemorySecUserNameCheckBox: TCheckBox;
    MemorySecPasswordCheckBox1: TCheckBox;
    Panel4: TPanel;
    MemoMessage: TMemo;
    LabelWorkName: TLabel;
    Panel5: TPanel;
    Label3: TLabel;
    EditSecPassWord2: TEdit;
    MemorySecPasswordCheckBox2: TCheckBox;
    Label4: TLabel;
    EditUserName: TEdit;
    MemoryUserNameCheckBox: TCheckBox;
    Label5: TLabel;
    EditPassword: TEdit;
    MemoryPasswordCheckBox: TCheckBox;
    Image2: TImage;
    Panel6: TPanel;
    Panel7: TPanel;
    ComboBox1: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    LabelVersion: TLabel;
    TimerAutoRun: TTimer;
    Panel8: TPanel;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerAutoRunTimer(Sender: TObject);

  private
    m_LoadItem_USER_0010: CFNLoadItem_USER_0010;
    m_LoadController: CFNLoadController;
    m_LoginController: CFNLoadController;

    procedure WMSecLogin(var Message: TMessage); message WM_SEC_LOGIN;

    procedure OnItemLoadStartedEvent(p_Item: CFNLoadItem);
    procedure OnItemLoadCompleteEvent(p_Item: CFNLoadItem);
    procedure OnItemLoadFaultEvent(p_Item: CFNLoadItem);
    procedure OnItemLoadMessageEvent(p_Item: CFNLoadItem);
    procedure OnStartEvent(p_Item: CFNLoadItem);
    procedure OnCompleteEvent(p_Item: CFNLoadItem);
    procedure OnFaultEvent(p_Item: CFNLoadItem);

    procedure OnLoginStartEvent(p_Item: CFNLoadItem);
    procedure OnLoginCompleteEvent(p_Item: CFNLoadItem);
    procedure OnLoginFaultEvent(p_Item: CFNLoadItem);

  private
    m_AutoRunState: Integer;
    m_AutoRunStartTime: TDateTime;

    procedure ApplyLanguage;

  public
    OPSLogin: Boolean;
    SECLogin: Boolean;
  end;

var
  LoginDlg: TLoginDlg;

implementation

uses
  FNRegistry, FNGlobal, FNGlobalVariable, FNCMVariable, MXVariable, ShellAPI;

{$R *.dfm}

// ---------------------------------------------------------------------------
procedure TLoginDlg.ApplyLanguage;
begin
  if (g_Language = 0) then
  begin
    Label4.Caption := '사용자 아이디';
    Label5.Caption := '사용자 비밀번호';
    Label1.Caption := '증권사 아이디';
    Label2.Caption := '증권사 비밀번호';
    Label3.Caption := '공인인증서';
    Label6.Caption := '접속서버유형';

    MemoryUserNameCheckBox.Caption := '저장하기';
    MemoryPasswordCheckBox.Caption := '저장하기';
    MemorySecUserNameCheckBox.Caption := '저장하기';
    MemorySecPasswordCheckBox1.Caption := '저장하기';
    MemorySecPasswordCheckBox2.Caption := '저장하기';

    OKBtn.Caption := '확인';
    CancelBtn.Caption := '취소';

    ComboBox1.Clear;
    ComboBox1.AddItem('실거래 서버', NIL);
    ComboBox1.AddItem('모의거래 서버', NIL);
  end
  else if (g_Language = 1) then
  begin
    Label4.Caption := 'User ID';
    Label5.Caption := 'Password';
    Label1.Caption := 'Sec. User ID';
    Label2.Caption := 'Sec. Password';
    Label3.Caption := 'Certification';
    Label6.Caption := 'Server type';

    MemoryUserNameCheckBox.Caption := 'Save';
    MemoryPasswordCheckBox.Caption := 'Save';
    MemorySecUserNameCheckBox.Caption := 'Save';
    MemorySecPasswordCheckBox1.Caption := 'Save';
    MemorySecPasswordCheckBox2.Caption := 'Save';

    OKBtn.Caption := 'OK';
    CancelBtn.Caption := 'Calcel';

    ComboBox1.Clear;
    ComboBox1.AddItem('Real Trading', NIL);
    ComboBox1.AddItem('Vertual Trading', NIL);
  end;
end;

// ---------------------------------------------------------------------------
// 화면이 처음 시작할 때 초기화 하는 부분이다.
// ---------------------------------------------------------------------------
procedure TLoginDlg.FormCreate(Sender: TObject);
var
  f_Registry: CFNRegistry;
  LIniFile: TIniFile;
begin
  ApplyLanguage;

  f_Registry := CFNRegistry.Create(self);
  f_Registry.Company := g_CompanyName;
  f_Registry.ApplicationName := g_ApplicationName;

  MemoryUserNameCheckBox.Checked := f_Registry.ReadBool('Setting', 'MemoryUserName', false);
  MemoryPasswordCheckBox.Checked := f_Registry.ReadBool('Setting', 'MemoryPassword', false);

  if (MemoryUserNameCheckBox.Checked) then
  begin
    EditUserName.Text := TMXGlobal.Decrypt(f_Registry.ReadString('Setting', 'UserName', ''));
  end;

  if (MemoryPasswordCheckBox.Checked) then
  begin
    EditPassword.Text := TMXGlobal.Decrypt(f_Registry.ReadString('Setting', 'PassWord', ''));
  end;

  MemorySecUserNameCheckBox.Checked := f_Registry.ReadBool('Setting', 'MemorySecUserName', false);
  MemorySecPasswordCheckBox1.Checked := f_Registry.ReadBool('Setting', 'MemorySecPassword1', false);
  MemorySecPasswordCheckBox2.Checked := f_Registry.ReadBool('Setting', 'MemorySecPassword2', false);

  if (MemorySecUserNameCheckBox.Checked) then
  begin
    EditSecUserName.Text := TMXGlobal.Decrypt(f_Registry.ReadString('Setting', 'SecUserName', ''));
  end;

  if (MemorySecPasswordCheckBox1.Checked) then
  begin
    EditSecPassWord1.Text := TMXGlobal.Decrypt(f_Registry.ReadString('Setting', 'SecPassWord1', ''));
  end;

  if (MemorySecPasswordCheckBox2.Checked) then
  begin
    EditSecPassWord2.Text := TMXGlobal.Decrypt(f_Registry.ReadString('Setting', 'SecPassWord2', ''));
  end;

  ComboBox1.ItemIndex := f_Registry.ReadInteger('Setting', 'TradeMode', 1);

  f_Registry.Free;

  OPSLogin := false;
  SECLogin := false;

  Caption := g_ApplicationName;
  LabelVersion.Caption := g_Version + ' ' + g_BuilderDate;

  m_LoginController := CFNLoadController.Create;
  m_LoginController.AddItem(CFNLoadItemSocket.Create);
  m_LoadItem_USER_0010 := CFNLoadItem_USER_0010.Create;
  m_LoginController.AddItem(m_LoadItem_USER_0010);

  m_LoginController.OnStartEvent := OnLoginStartEvent;
  m_LoginController.OnCompleteEvent := OnLoginCompleteEvent;
  m_LoginController.OnFaultEvent := OnLoginFaultEvent;

  m_LoginController.OnItemLoadStartedEvent := OnItemLoadStartedEvent;
  m_LoginController.OnItemLoadCompleteEvent := OnItemLoadCompleteEvent;
  m_LoginController.OnItemLoadFaultEvent := OnItemLoadFaultEvent;
  m_LoginController.OnItemLoadMessageEvent := OnItemLoadMessageEvent;

  m_LoadController := CFNLoadController.Create;
  m_LoadController.AddItem(CFNLoadItem_BASIC_0010.Create);
  m_LoadController.AddItem(CFNLoadItem_BASIC_0020.Create);
  m_LoadController.AddItem(CFNLoadItem_BASIC_0030.Create);
  m_LoadController.AddItem(CFNLoadItem_CODE_0010.Create);
  m_LoadController.AddItem(CFNLoadItem_ACCOUNT_0010.Create);

  m_LoadController.OnStartEvent := OnStartEvent;
  m_LoadController.OnCompleteEvent := OnCompleteEvent;
  m_LoadController.OnFaultEvent := OnFaultEvent;

  m_LoadController.OnItemLoadStartedEvent := OnItemLoadStartedEvent;
  m_LoadController.OnItemLoadCompleteEvent := OnItemLoadCompleteEvent;
  m_LoadController.OnItemLoadFaultEvent := OnItemLoadFaultEvent;
  m_LoadController.OnItemLoadMessageEvent := OnItemLoadMessageEvent;

  m_AutoRunState := 0;

  if g_AutoRun then
  begin

    OKBtn.Enabled := false;
    CancelBtn.Enabled := false;

    EditUserName.Text := g_AutoRunConfig.m_MatrixUserID;
    EditPassword.Text := g_AutoRunConfig.m_MatrixUserPW;

    EditSecUserName.Text := g_AutoRunConfig.m_SecUserID;
    EditSecPassWord1.Text := g_AutoRunConfig.m_SecUserPW;
    EditSecPassWord2.Text := g_AutoRunConfig.m_CertPW;

    if CompareText(g_AutoRunConfig.m_TradeMode, 'REAL') = 0 then
    begin
      ComboBox1.ItemIndex := 0;
    end
    else
    begin
      ComboBox1.ItemIndex := 1;
    end;

    m_AutoRunStartTime := Now;
    TimerAutoRun.Enabled := TRUE;
  end;
end;

// ---------------------------------------------------------------------------
procedure TLoginDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  f_Registry: CFNRegistry;
begin
  Action := caHide;

  if Assigned(m_LoadController) then
  begin
    m_LoadController.Free;
    m_LoadController := NIL;
  end;

  if Assigned(m_LoginController) then
  begin
    m_LoginController.Free;
    m_LoginController := NIL;
  end;

  f_Registry := CFNRegistry.Create(self);
  f_Registry.Company := g_CompanyName;
  f_Registry.ApplicationName := g_ApplicationName;

  if OPSLogin then
  begin
    f_Registry.WriteBool('Setting', 'MemoryUserName', MemoryUserNameCheckBox.Checked);
    f_Registry.WriteBool('Setting', 'MemoryPassword', MemoryPasswordCheckBox.Checked);

    if (MemoryUserNameCheckBox.Checked) then
    begin
      f_Registry.WriteString('Setting', 'UserName', TMXGlobal.Encrypt(EditUserName.Text));
    end
    else
    begin
      f_Registry.WriteString('Setting', 'UserName', TMXGlobal.Encrypt(''));
    end;

    if (MemoryPasswordCheckBox.Checked) then
    begin
      f_Registry.WriteString('Setting', 'PassWord', TMXGlobal.Encrypt(EditPassword.Text));
    end
    else
    begin
      f_Registry.WriteString('Setting', 'PassWord', TMXGlobal.Encrypt(''));
    end;
  end;

  if SECLogin then
  begin
    f_Registry.WriteBool('Setting', 'MemorySecUserName', MemorySecUserNameCheckBox.Checked);
    f_Registry.WriteBool('Setting', 'MemorySecPassword1', MemorySecPasswordCheckBox1.Checked);
    f_Registry.WriteBool('Setting', 'MemorySecPassword2', MemorySecPasswordCheckBox2.Checked);

    if (MemorySecUserNameCheckBox.Checked) then
    begin
      f_Registry.WriteString('Setting', 'SecUserName', TMXGlobal.Encrypt(EditSecUserName.Text));
    end
    else
    begin
      f_Registry.WriteString('Setting', 'SecUserName', TMXGlobal.Encrypt(''));
    end;

    if (MemorySecPasswordCheckBox1.Checked) then
    begin
      f_Registry.WriteString('Setting', 'SecPassWord1', TMXGlobal.Encrypt(EditSecPassWord1.Text));
    end
    else
    begin
      f_Registry.WriteString('Setting', 'SecPassWord1', TMXGlobal.Encrypt(''));
    end;

    if (MemorySecPasswordCheckBox2.Checked) then
    begin
      f_Registry.WriteString('Setting', 'SecPassWord2', TMXGlobal.Encrypt(EditSecPassWord2.Text));
    end
    else
    begin
      f_Registry.WriteString('Setting', 'SecPassWord2', TMXGlobal.Encrypt(''));
    end;

    f_Registry.WriteInteger('Setting', 'TradeMode', ComboBox1.ItemIndex);
  end;

  f_Registry.Free;
end;

// ---------------------------------------------------------------------------
procedure TLoginDlg.OnLoginStartEvent(p_Item: CFNLoadItem);
begin

end;

// ---------------------------------------------------------------------------
procedure TLoginDlg.OnLoginCompleteEvent(p_Item: CFNLoadItem);
begin
  PostMessage(Handle, WM_SEC_LOGIN, 0, 0);
end;

// ---------------------------------------------------------------------------
procedure TLoginDlg.OnLoginFaultEvent(p_Item: CFNLoadItem);
begin
  OKBtn.Enabled := TRUE;
  CancelBtn.Enabled := TRUE;
end;

// ---------------------------------------------------------------------------
procedure TLoginDlg.OnStartEvent(p_Item: CFNLoadItem);
begin

end;

// ---------------------------------------------------------------------------
procedure TLoginDlg.OnCompleteEvent(p_Item: CFNLoadItem);
begin
  m_AutoRunState := 9;
  Close;
  self.ModalResult := mrOK;
end;

// ---------------------------------------------------------------------------
procedure TLoginDlg.OnFaultEvent(p_Item: CFNLoadItem);
begin
  OKBtn.Enabled := TRUE;
  CancelBtn.Enabled := TRUE;
end;

// ---------------------------------------------------------------------------
procedure TLoginDlg.OnItemLoadStartedEvent(p_Item: CFNLoadItem);
begin
  if Assigned(p_Item) then
  begin
    LabelWorkName.Caption := p_Item.WorkName;
    if (p_Item.ResultMessage <> '') then
      MemoMessage.Lines.Insert(0, p_Item.ResultMessage);
  end;
end;

// ---------------------------------------------------------------------------
procedure TLoginDlg.OnItemLoadCompleteEvent(p_Item: CFNLoadItem);
begin
  if Assigned(p_Item) then
  begin
    LabelWorkName.Caption := p_Item.WorkName;
    if (p_Item.ResultMessage <> '') then
      MemoMessage.Lines.Insert(0, p_Item.ResultMessage);
  end;
end;

// ---------------------------------------------------------------------------
procedure TLoginDlg.OnItemLoadFaultEvent(p_Item: CFNLoadItem);
begin
  if Assigned(p_Item) then
  begin
    LabelWorkName.Caption := p_Item.WorkName;
    if (p_Item.ResultMessage <> '') then
      MemoMessage.Lines.Insert(0, p_Item.ResultMessage);
  end;
end;

// ---------------------------------------------------------------------------
procedure TLoginDlg.OnItemLoadMessageEvent(p_Item: CFNLoadItem);
begin
  if Assigned(p_Item) then
  begin
    LabelWorkName.Caption := p_Item.WorkName;
    if (p_Item.ResultMessage <> '') then
      MemoMessage.Lines.Insert(0, p_Item.ResultMessage);
  end;
end;

// ---------------------------------------------------------------------------
procedure TLoginDlg.TimerAutoRunTimer(Sender: TObject);
var
  f_MainHWnd: HWND;
  f_HWnd: HWND;
begin
  if (m_AutoRunState = 9) then
    exit;

  // 자동실행 모드에서 로그인 창이 30초 이상 실행된다면, 어느 부분에서 문제가 발생한 것으로 간주됨
  if Trunc((Now - m_AutoRunStartTime) * 86400000) > 30000 then
  begin
    TimerAutoRun.Enabled := false;
    g_AutoRun := false;
    TMXGlobal.SendEMail(g_AutoRunConfig.m_EMail, g_AutoRunConfig.m_MainWindowTitle, '[오류] 로그인단계에서 다음으로 진행되지 않습니다. 공인인증서 부분을 체크해주세요.');
  end;

  if m_AutoRunState = 0 then
  begin
    TimerAutoRun.Interval := 3000;
    m_AutoRunState := 1;
    OKBtnClick(self);
  end
  else if m_AutoRunState = 1 then
  begin
    f_MainHWnd := TMXGlobal.GetCertDialogHandle;
    if f_MainHWnd <> 0 then
    begin
      f_HWnd := FindWindowEx(f_MainHWnd, HWND(NIL), 'Button', PChar(g_AutoRunConfig.m_CertWindowOK));
      SendMessage(f_HWnd, BM_CLICK, 0, 0);
      m_AutoRunState := 2;
    end
    else
    begin
      f_MainHWnd := FindWindow(NIL, PChar(g_AutoRunConfig.m_CertWindowTitle));
      if f_MainHWnd <> 0 then
      begin
        f_HWnd := FindWindowEx(f_MainHWnd, HWND(NIL), 'Button', PChar(g_AutoRunConfig.m_CertWindowOK));
        SendMessage(f_HWnd, BM_CLICK, 0, 0);
        m_AutoRunState := 2;
      end
      else
      begin
        f_MainHWnd := TMXGlobal.GetCertDialogHandle;
        if f_MainHWnd <> 0 then
        begin
          f_HWnd := FindWindowEx(f_MainHWnd, HWND(NIL), 'Button', PChar('인증서 선택(확인)'));
          SendMessage(f_HWnd, BM_CLICK, 0, 0);
          m_AutoRunState := 2;
        end;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure TLoginDlg.WMSecLogin(var Message: TMessage);
var
  f_OleVariant: OleVariant;

  f_Stream: TStringStream;
  f_FileName: String;

  f_RValue: Integer;
  LIniFile: TIniFile;
begin
  g_MatrixUserID := UpperCase(EditUserName.Text);
  g_MatrixUserPW := EditPassword.Text;
  OPSLogin := TRUE;

  OKBtn.Enabled := false;
  CancelBtn.Enabled := false;

  g_SecUserID := EditSecUserName.Text;
  g_SecUserPW := EditSecPassWord1.Text;
  g_SecCertPW := EditSecPassWord2.Text;

  if ComboBox1.ItemIndex = 0 then
  begin
    LIniFile := TIniFile.Create('system\Commsu.ini');
    try
      LIniFile.WriteString('STARTER', 'Simulation', '0');
    finally
      LIniFile.Free;
    end;
  end
  else
  begin
    LIniFile := TIniFile.Create('system\Commsu.ini');
    try
      LIniFile.WriteString('STARTER', 'Simulation', '1');
    finally
      LIniFile.Free;
    end;
  end;

  if (0 > g_HDCommAgent.CommInit(1)) then
  begin
    OKBtn.Enabled := TRUE;
    CancelBtn.Enabled := TRUE;
    ShowMessage('선물사의 통신프로그램 실행중 오류가 발생하였습니다.');
    exit;
  end;

  f_RValue := g_HDCommAgent.CommLogin(g_SecUserID, g_SecUserPW, g_SecCertPW);
  if 1 = f_RValue then
  begin
    OKBtn.Enabled := false;
    CancelBtn.Enabled := false;
    OPSLogin := TRUE;
    SECLogin := TRUE;
    m_LoadController.Load;
  end
  else
  begin
    OKBtn.Enabled := TRUE;
    CancelBtn.Enabled := TRUE;
    if (-1 = f_RValue) then
    begin
      ShowMessage('로그인 실패(약식).');
    end
    else if (-2 = f_RValue) then
    begin
      ShowMessage('로그인 실패(공인).');
    end
    else if (-3 = f_RValue) then
    begin
      ShowMessage('로그인 실패(정식).');
    end
    else if (-4 = f_RValue) then
    begin
      ShowMessage('메모리 초기화 실패');
    end
    else if (-5 = f_RValue) then
    begin
      ShowMessage('통신관리자 초기화 실패');
    end
    else if (-5000 = f_RValue) then
    begin
      ShowMessage('로그인 실패(약식)');
    end
    else if (-52004 = f_RValue) then
    begin
      ShowMessage('비밀번호 5회 오류');
    end;
  end;

end;

// ---------------------------------------------------------------------------
// 확인버턴을 클릭하면 화면정보에서 사용자 정보를 취합해서 서버에 전달한다..
procedure TLoginDlg.OKBtnClick(Sender: TObject);
begin
  Panel7.Visible := false;

  OPSLogin := false;
  if EditUserName.Text = '' then
  begin
    ShowMessage('사용자 아이디를 입력하세요.');
    ActiveControl := EditUserName;
    exit;
  end;

  if EditPassword.Text = '' then
  begin
    ShowMessage('사용자 비밀번호를 입력하세요.');
    ActiveControl := EditPassword;
    exit;
  end;

  m_LoadItem_USER_0010.m_USER_ID := UpperCase(EditUserName.Text);
  m_LoadItem_USER_0010.m_PASSWORD := UpperCase(TMXGlobal.MD5Hash(EditPassword.Text));
  m_LoadItem_USER_0010.m_PGM_CODE := g_PGMCode;
  m_LoginController.Load;
end;

end.
