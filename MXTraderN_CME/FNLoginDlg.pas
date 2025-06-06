unit FNLoginDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Sockets,
  Buttons, ExtCtrls, Dialogs, Messages, FNSocketManager, FNDataDelivery, FNDataSet,
  AgentGlobalVariable, FNLoadController, FNLoadItem, OleCtrls,  DCPsha1, DCPrc4, IdHTTP,
  pngimage, GR32_Image, ActnList, jpeg;

const
    WM_SEC_LOGIN         =   WM_USER + 1234;

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
    Label8: TLabel;
    EditWRSecUserName: TEdit;
    MemoryWRSecUserNameCheckBox: TCheckBox;
    MemoryWRSecPasswordCheckBox: TCheckBox;
    EditWRSecPassWord: TEdit;
    Label9: TLabel;
    Button3: TButton;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerAutoRunTimer(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  private
    m_LoadItem_USER_0010:CFNLoadItem_USER_0010;
    m_LoadController:CFNLoadController;
    m_LoginController:CFNLoadController;

    procedure SaveInfo;

    procedure WMSecLogin(var Message: TMessage); message WM_SEC_LOGIN;

    procedure OnItemLoadStartedEvent(p_Item:CFNLoadItem);
    procedure OnItemLoadCompleteEvent(p_Item:CFNLoadItem);
    procedure OnItemLoadFaultEvent(p_Item:CFNLoadItem);
    procedure OnItemLoadMessageEvent(p_Item:CFNLoadItem);
    procedure OnStartEvent(p_Item:CFNLoadItem);
    procedure OnCompleteEvent(p_Item:CFNLoadItem);
    procedure OnFaultEvent(p_Item:CFNLoadItem);

    procedure OnLoginStartEvent(p_Item:CFNLoadItem);
    procedure OnLoginCompleteEvent(p_Item:CFNLoadItem);
    procedure OnLoginFaultEvent(p_Item:CFNLoadItem);

    procedure OnSocketStatus(ASender: TObject; nStatus: Smallint);

    procedure OnH5Receive(ASender: TObject; type_: Integer; pBytes: Integer; nBytes: Integer);
    procedure DoH5Login;
    procedure H5SignOn;

  private
    m_AutoRunState:Integer;
    m_AutoRunStartTime:TDateTime;

    m_ServerIP1:WideString;
    m_ServerIP2:WideString;

  public
    OPSLogin:Boolean;
    SECLogin:Boolean;
  end;

var
  LoginDlg: TLoginDlg;

implementation

uses
  FNRegistry, FNGlobal, FNGlobalVariable, FNCMVariable, MXVariable, H5MGREXLib_Const, ShellAPI;

{$R *.dfm}


//---------------------------------------------------------------------------
// 화면이 처음 시작할 때 초기화 하는 부분이다.
//---------------------------------------------------------------------------
procedure TLoginDlg.FormCreate(Sender: TObject);
var
    f_Registry:CFNRegistry;
begin

    f_Registry := CFNRegistry.Create(self);
    f_Registry.Company := g_CompanyName;
    f_Registry.ApplicationName := g_ApplicationName;

    MemoryUserNameCheckBox.Checked := f_Registry.ReadBool('Setting', 'MemoryUserName'  , false);
    MemoryPasswordCheckBox.Checked := f_Registry.ReadBool('Setting', 'MemoryPassword'  , false);

    if (MemoryUserNameCheckBox.Checked) then
    begin
        EditUserName.Text :=  TMXGlobal.Decrypt(f_Registry.ReadString('Setting', 'UserName', ''));
    end;

    if (MemoryPasswordCheckBox.Checked) then
    begin
        EditPassword.Text :=  TMXGlobal.Decrypt(f_Registry.ReadString('Setting', 'PassWord', ''));
    end;

    MemorySecUserNameCheckBox.Checked  := f_Registry.ReadBool('Setting', 'MemorySecUserName'  , false);
    MemorySecPasswordCheckBox1.Checked := f_Registry.ReadBool('Setting', 'MemorySecPassword1'  , false);
    MemorySecPasswordCheckBox2.Checked := f_Registry.ReadBool('Setting', 'MemorySecPassword2'  , false);

    if (MemorySecUserNameCheckBox.Checked) then
    begin
        EditSecUserName.Text :=  TMXGlobal.Decrypt(f_Registry.ReadString('Setting', 'SecUserName', ''));
    end;

    if (MemorySecPasswordCheckBox1.Checked) then
    begin
        EditSecPassWord1.Text :=  TMXGlobal.Decrypt(f_Registry.ReadString('Setting', 'SecPassWord1', ''));
    end;

    if (MemorySecPasswordCheckBox2.Checked) then
    begin
        EditSecPassWord2.Text :=  TMXGlobal.Decrypt(f_Registry.ReadString('Setting', 'SecPassWord2', ''));
    end;

    ComboBox1.ItemIndex := f_Registry.ReadInteger('Setting', 'TradeMode'  , 1);

    MemoryWRSecUserNameCheckBox.Checked := f_Registry.ReadBool('Setting', 'MemoryWRSecUserName'  , false);
    MemoryWRSecPasswordCheckBox.Checked := f_Registry.ReadBool('Setting', 'MemoryWRSecPassword'  , false);

    if (MemoryWRSecUserNameCheckBox.Checked) then
    begin
        EditWRSecUserName.Text :=  TMXGlobal.Decrypt(f_Registry.ReadString('Setting', 'WRSecUserName', ''));
    end;

    if (MemoryWRSecPasswordCheckBox.Checked) then
    begin
        EditWRSecPassWord.Text :=  TMXGlobal.Decrypt(f_Registry.ReadString('Setting', 'WRSecPassWord', ''));
    end;

    f_Registry.Free;

    OPSLogin := false;
    SECLogin := false;

    Caption := g_ApplicationName;
    LabelVersion.Caption := g_Version + ' ' + g_BuilderDate;

    m_LoginController := CFNLoadController.Create;
    m_LoginController.AddItem(CFNLoadItemSocket.Create);
    m_LoadItem_USER_0010 :=  CFNLoadItem_USER_0010.Create;
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

    g_WRCommAgent.OnOSocketStatus := OnSocketStatus;

    g_H5MgrEx.OnReceive := OnH5Receive;

    if g_AutoRun then
    begin
        m_AutoRunState := 0;

        OKBtn.Enabled := false;
        CancelBtn.Enabled := false;

        EditUserName.Text := g_AutoRunConfig.m_MatrixUserID;
        EditPassword.Text := g_AutoRunConfig.m_MatrixUserPW;

        EditSecUserName.Text := g_AutoRunConfig.m_SecUserID;
        EditSecPassWord1.Text := g_AutoRunConfig.m_SecUserPW;
        EditSecPassWord2.Text := g_AutoRunConfig.m_CertPW;

        EditWRSecUserName.Text := g_AutoRunConfig.m_WRSecUserID;
        EditWRSecPassWord.Text := g_AutoRunConfig.m_WRSecUserPW;

        if CompareText(g_AutoRunConfig.m_TradeMode, 'REAL') = 0 then
        begin
            ComboBox1.ItemIndex := 0;
        end else
        begin
            ComboBox1.ItemIndex := 1;
        end;

        m_AutoRunStartTime := Now;
        TimerAutoRun.Enabled := TRUE;
    end;
end;

procedure TLoginDlg.SaveInfo;
var
    f_Registry:CFNRegistry;
begin
    f_Registry := CFNRegistry.Create(self);
    f_Registry.Company := g_CompanyName;
    f_Registry.ApplicationName := g_ApplicationName;

    //if OPSLogin then
    begin
        f_Registry.WriteBool('Setting', 'MemoryUserName' , MemoryUserNameCheckBox.Checked);
        f_Registry.WriteBool('Setting', 'MemoryPassword' , MemoryPasswordCheckBox.Checked);

        if (MemoryUserNameCheckBox.Checked) then
        begin
            f_Registry.WriteString('Setting', 'UserName', TMXGlobal.Encrypt(EditUserName.Text) );
        end else
        begin
            f_Registry.WriteString('Setting', 'UserName', TMXGlobal.Encrypt(''));
        end;

        if (MemoryPasswordCheckBox.Checked) then
        begin
            f_Registry.WriteString('Setting', 'PassWord', TMXGlobal.Encrypt(EditPassword.Text) );
        end else
        begin
            f_Registry.WriteString('Setting', 'PassWord', TMXGlobal.Encrypt(''));
        end;
    end;

    //if SECLogin then
    begin
        f_Registry.WriteBool('Setting', 'MemorySecUserName'  , MemorySecUserNameCheckBox.Checked);
        f_Registry.WriteBool('Setting', 'MemorySecPassword1' , MemorySecPasswordCheckBox1.Checked);
        f_Registry.WriteBool('Setting', 'MemorySecPassword2' , MemorySecPasswordCheckBox2.Checked);

        if (MemorySecUserNameCheckBox.Checked) then
        begin
            f_Registry.WriteString('Setting', 'SecUserName', TMXGlobal.Encrypt(EditSecUserName.Text) );
        end else
        begin
            f_Registry.WriteString('Setting', 'SecUserName', TMXGlobal.Encrypt(''));
        end;

        if (MemorySecPasswordCheckBox1.Checked) then
        begin
            f_Registry.WriteString('Setting', 'SecPassWord1', TMXGlobal.Encrypt(EditSecPassWord1.Text) );
        end else
        begin
            f_Registry.WriteString('Setting', 'SecPassWord1', TMXGlobal.Encrypt('') );
        end;

        if (MemorySecPasswordCheckBox2.Checked) then
        begin
            f_Registry.WriteString('Setting', 'SecPassWord2', TMXGlobal.Encrypt(EditSecPassWord2.Text) );
        end else
        begin
            f_Registry.WriteString('Setting', 'SecPassWord2', TMXGlobal.Encrypt('') );
        end;

        f_Registry.WriteInteger('Setting', 'TradeMode', ComboBox1.ItemIndex);


        f_Registry.WriteBool('Setting', 'MemoryWRSecUserName' , MemoryWRSecUserNameCheckBox.Checked);
        f_Registry.WriteBool('Setting', 'MemoryWRSecPassword' , MemoryWRSecPasswordCheckBox.Checked);

        if (MemoryWRSecUserNameCheckBox.Checked) then
        begin
            f_Registry.WriteString('Setting', 'WRSecUserName', TMXGlobal.Encrypt(EditWRSecUserName.Text) );
        end else
        begin
            f_Registry.WriteString('Setting', 'WRSecUserName', TMXGlobal.Encrypt(''));
        end;

        if (MemoryWRSecPasswordCheckBox.Checked) then
        begin
            f_Registry.WriteString('Setting', 'WRSecPassWord', TMXGlobal.Encrypt(EditWRSecPassWord.Text) );
        end else
        begin
            f_Registry.WriteString('Setting', 'WRSecPassWord', TMXGlobal.Encrypt('') );
        end;
    end;

    f_Registry.Free;
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
    f_Registry:CFNRegistry;
begin
    Action := caHide;
    g_WRCommAgent.OnOSocketStatus := NIL;

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
        f_Registry.WriteBool('Setting', 'MemoryUserName' , MemoryUserNameCheckBox.Checked);
        f_Registry.WriteBool('Setting', 'MemoryPassword' , MemoryPasswordCheckBox.Checked);

        if (MemoryUserNameCheckBox.Checked) then
        begin
            f_Registry.WriteString('Setting', 'UserName', TMXGlobal.Encrypt(EditUserName.Text) );
        end else
        begin
            f_Registry.WriteString('Setting', 'UserName', TMXGlobal.Encrypt(''));
        end;

        if (MemoryPasswordCheckBox.Checked) then
        begin
            f_Registry.WriteString('Setting', 'PassWord', TMXGlobal.Encrypt(EditPassword.Text) );
        end else
        begin
            f_Registry.WriteString('Setting', 'PassWord', TMXGlobal.Encrypt(''));
        end;
    end;

    if SECLogin then
    begin
        f_Registry.WriteBool('Setting', 'MemorySecUserName'  , MemorySecUserNameCheckBox.Checked);
        f_Registry.WriteBool('Setting', 'MemorySecPassword1' , MemorySecPasswordCheckBox1.Checked);
        f_Registry.WriteBool('Setting', 'MemorySecPassword2' , MemorySecPasswordCheckBox2.Checked);

        if (MemorySecUserNameCheckBox.Checked) then
        begin
            f_Registry.WriteString('Setting', 'SecUserName', TMXGlobal.Encrypt(EditSecUserName.Text) );
        end else
        begin
            f_Registry.WriteString('Setting', 'SecUserName', TMXGlobal.Encrypt(''));
        end;

        if (MemorySecPasswordCheckBox1.Checked) then
        begin
            f_Registry.WriteString('Setting', 'SecPassWord1', TMXGlobal.Encrypt(EditSecPassWord1.Text) );
        end else
        begin
            f_Registry.WriteString('Setting', 'SecPassWord1', TMXGlobal.Encrypt('') );
        end;

        if (MemorySecPasswordCheckBox2.Checked) then
        begin
            f_Registry.WriteString('Setting', 'SecPassWord2', TMXGlobal.Encrypt(EditSecPassWord2.Text) );
        end else
        begin
            f_Registry.WriteString('Setting', 'SecPassWord2', TMXGlobal.Encrypt('') );
        end;

        f_Registry.WriteInteger('Setting', 'TradeMode', ComboBox1.ItemIndex);



        f_Registry.WriteBool('Setting', 'MemoryWRSecUserName' , MemoryWRSecUserNameCheckBox.Checked);
        f_Registry.WriteBool('Setting', 'MemoryWRSecPassword' , MemoryWRSecPasswordCheckBox.Checked);

        if (MemoryWRSecUserNameCheckBox.Checked) then
        begin
            f_Registry.WriteString('Setting', 'WRSecUserName', TMXGlobal.Encrypt(EditWRSecUserName.Text) );
        end else
        begin
            f_Registry.WriteString('Setting', 'WRSecUserName', TMXGlobal.Encrypt(''));
        end;

        if (MemoryWRSecPasswordCheckBox.Checked) then
        begin
            f_Registry.WriteString('Setting', 'WRSecPassWord', TMXGlobal.Encrypt(EditWRSecPassWord.Text) );
        end else
        begin
            f_Registry.WriteString('Setting', 'WRSecPassWord', TMXGlobal.Encrypt('') );
        end;
    end;

    f_Registry.Free;
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnLoginStartEvent(p_Item: CFNLoadItem);
begin

end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnLoginCompleteEvent(p_Item: CFNLoadItem);
begin
    PostMessage(Handle, WM_SEC_LOGIN, 0, 0);
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnLoginFaultEvent(p_Item: CFNLoadItem);
begin
    OKBtn.Enabled := true;
    CancelBtn.Enabled := true;
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnStartEvent(p_Item: CFNLoadItem);
begin

end;

//---------------------------------------------------------------------------
procedure TLoginDlg.Panel1Click(Sender: TObject);
begin
    SaveInfo
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnCompleteEvent(p_Item: CFNLoadItem);
begin
    Close;
    Self.ModalResult := mrOK;
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnFaultEvent(p_Item: CFNLoadItem);
begin
    OKBtn.Enabled := true;
    CancelBtn.Enabled := true;
    //g_WRCommAgent.OnOSocketStatus := NIL;
    //g_WRCommAgent.OCommTerminate;
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnItemLoadStartedEvent(p_Item: CFNLoadItem);
begin
    if Assigned(p_Item) then
    begin
        LabelWorkName.Caption := p_Item.WorkName;
        if (p_Item.ResultMessage <> '') then MemoMessage.Lines.Insert(0, p_Item.ResultMessage);
    end;
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnItemLoadCompleteEvent(p_Item: CFNLoadItem);
begin
    if Assigned(p_Item) then
    begin
        LabelWorkName.Caption := p_Item.WorkName;
        if (p_Item.ResultMessage <> '') then MemoMessage.Lines.Insert(0, p_Item.ResultMessage);
    end;
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnItemLoadFaultEvent(p_Item: CFNLoadItem);
begin
    if Assigned(p_Item) then
    begin
        LabelWorkName.Caption := p_Item.WorkName;
        if (p_Item.ResultMessage <> '') then MemoMessage.Lines.Insert(0, p_Item.ResultMessage);
    end;
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnItemLoadMessageEvent(p_Item: CFNLoadItem);
begin
    if Assigned(p_Item) then
    begin
        LabelWorkName.Caption := p_Item.WorkName;
        if (p_Item.ResultMessage <> '') then MemoMessage.Lines.Insert(0, p_Item.ResultMessage);
    end;
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.TimerAutoRunTimer(Sender: TObject);
var
    f_MainHWnd:HWND;
    f_HWnd:HWND;
begin
    //  자동실행 모드에서 로그인 창이 30초 이상 실행된다면, 어느 부분에서 문제가 발생한 것으로 간주됨
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
        OKBtnClick(Self);
    end else
    if m_AutoRunState = 1 then
    begin
        f_MainHWnd := TMXGlobal.GetCertDialogHandle;
        if f_MainHWnd <> 0 then
        begin
            f_HWnd := FindWindowEx(f_MainHWnd, HWND(NIL), 'Button', PChar(g_AutoRunConfig.m_CertWindowOK));
            SendMessage(f_HWnd, BM_CLICK, 0, 0);
            m_AutoRunState := 2;
        end else
        begin
            f_MainHWnd := FindWindow(NIL, PChar(g_AutoRunConfig.m_CertWindowTitle));
            if f_MainHWnd <> 0 then
            begin
                f_HWnd := FindWindowEx(f_MainHWnd, HWND(NIL), 'Button', PChar(g_AutoRunConfig.m_CertWindowOK));
                SendMessage(f_HWnd, BM_CLICK, 0, 0);
                m_AutoRunState := 2;
            end else
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

//---------------------------------------------------------------------------
procedure TLoginDlg.OnSocketStatus(ASender: TObject; nStatus: Smallint);
begin

end;

//---------------------------------------------------------------------------
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

//---------------------------------------------------------------------------
procedure TLoginDlg.WMSecLogin(var Message: TMessage);
begin
    g_MatrixUserID := UpperCase(EditUserName.Text);
    g_MatrixUserPW := EditPassword.Text;
    OPSLogin := true;

    OKBtn.Enabled := false;
    CancelBtn.Enabled := false;

    g_WRCommAgent.OnOSocketStatus := OnSocketStatus;

    g_WRSecUserName := EditWRSecUserName.Text;
    g_WRSecPassWord := EditWRSecPassWord.Text;

    g_WRCommAgent.OCommTerminate;

    g_H5MgrEx.OnReceive := OnH5Receive;
    if 0 = g_WRCommAgent.OCommLogin(g_WRSecUserName, g_WRSecPassWord, '') then
    begin
        OKBtn.Enabled := false;
        CancelBtn.Enabled := false;
        MemoMessage.Lines.Insert(0, '우리선물에 로그인 성공');
        DoH5Login;
    end else
    begin
        OKBtn.Enabled := true;
        CancelBtn.Enabled := true;
        ShowMessage('로그인에 실패하였습니다.');
    end;
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.Button3Click(Sender: TObject);
var
    f_FileName: String;
begin
    f_FileName := ExtractFilePath(ParamStr(0)) + 'account.dat';
    ShellExecute(0, 'open', 'notepad.exe', PChar(f_FileName), nil, SW_SHOWNORMAL);
end;

procedure TLoginDlg.DoH5Login;
begin
    //  실전
    if ComboBox1.ItemIndex = 0 then
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
        MemoMessage.Lines.Insert(0, '접속 서버 아이피를 얻어 오는데 실패했습니다.!!');
        Update;
        Sleep(1000);
        m_AutoRunState := 0;
		exit;
    end;

    g_H5MgrEx.HFCommandVB(hf_CONNECT, m_ServerIP1, 15201);
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnH5Receive(ASender: TObject; type_: Integer; pBytes: Integer; nBytes: Integer);
begin
    case type_ of
        FEV_OPEN :
        begin
            if (nBytes = 0) then
            begin
                MemoMessage.Lines.Insert(0, '하나대투 국내 접속 성공');
                Update;
                Sleep(1000);
                H5SignOn;
		        end else
            begin
            ShowMessage(Format('Connect Error .....ECode[%d]', [nBytes]));
            end;
        end;

	    FEV_CLOSE :
        begin
            MemoMessage.Lines.Insert(0, '접속이 종료되었습니다.');
            Update;
            Sleep(1000);
            m_AutoRunState := 0;
        end;

        FEV_AXIS:
        begin
            if runAXIS = LOWORD(pBytes) then
            begin
                MemoMessage.Lines.Insert(0, '하나대투 국내 로그인 성공');
                Update;
                Sleep(1000);
                g_H5MgrEx.HFCommandVB(hf_DUALSIGN, m_ServerIP2, 15201);
            end else
            if runDUAL = LOWORD(pBytes) then
            begin
                SECLogin := true;

                MemoMessage.Lines.Insert(0, '하나대투 해외 로그인 성공');
                Update;
                Sleep(1000);
                g_WRAgentManager.AssignH5Agent(g_H5MgrEx);
                m_LoadController.Load;
            end;
        end;

        FEV_ERROR:
        begin
            if pBytes <> 0 then
            begin
                MemoMessage.Lines.Insert(0, Format('FEV_ERROR[%d---%s]', [pBytes, PAnsiChar(nBytes)]));
                Update;
                Sleep(1000);
                OKBtn.Enabled := true;
                CancelBtn.Enabled := true;

                m_AutoRunState := 0;
            end;
        end;

    end;
end;
//---------------------------------------------------------------------------
procedure TLoginDlg.H5SignOn;
var
    f_SignM:TSignM;
    f_PW:String;
begin
    g_SecUserID := EditSecUserName.Text;
    g_SecUserPW := EditSecPassWord1.Text;
    g_SecCertPW := EditSecPassWord2.Text;

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
