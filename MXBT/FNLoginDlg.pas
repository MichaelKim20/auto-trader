unit FNLoginDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Sockets,
  Buttons, ExtCtrls, Dialogs, Messages, FNSocketManager, FNDataSet, FNLoadController,FNLoadItem,
  OleCtrls, DCPsha1, DCPrc4, IdHTTP,
  pngimage, GR32_Image;

const
    WM_SEC_LOGIN         =   WM_USER + 1234;

type
  TLoginDlg = class(TForm)
    Panel1: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    Panel3: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    MemoMessage: TMemo;
    LabelWorkName: TLabel;
    Panel5: TPanel;
    Label4: TLabel;
    EditUserName: TEdit;
    MemoryUserNameCheckBox: TCheckBox;
    Label5: TLabel;
    EditPassword: TEdit;
    MemoryPasswordCheckBox: TCheckBox;
    Image2: TImage;
    Panel6: TPanel;
    Panel7: TPanel;
    Bevel2: TBevel;
    Label6: TLabel;
    LabelVersion: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    m_LoadItem_USER_0010:CFNLoadItem_USER_0010;
    m_LoadController:CFNLoadController;
    m_LoginController:CFNLoadController;

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


  public
    OPSLogin:Boolean;
    SECLogin:Boolean;
  end;

var
  LoginDlg: TLoginDlg;

implementation

uses
  FNRegistry, FNGlobal, FNGlobalVariable, FNCMVariable, MXVariable;

{$R *.dfm}
//---------------------------------------------------------------------------
// 화면이 처음 시작할 때 초기화 하는 부분이다.
//
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

    m_LoadController.OnStartEvent := OnStartEvent;
    m_LoadController.OnCompleteEvent := OnCompleteEvent;
    m_LoadController.OnFaultEvent := OnFaultEvent;

    m_LoadController.OnItemLoadStartedEvent := OnItemLoadStartedEvent;
    m_LoadController.OnItemLoadCompleteEvent := OnItemLoadCompleteEvent;
    m_LoadController.OnItemLoadFaultEvent := OnItemLoadFaultEvent;
    m_LoadController.OnItemLoadMessageEvent := OnItemLoadMessageEvent;
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
    f_Registry:CFNRegistry;
begin
    Action := caFree;

    if Assigned(m_LoadController) then
    begin
        m_LoadController.Free;
        m_LoadController := NIL;
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
// 확인버턴을 클릭하면 화면정보에서 사용자 정보를 취합해서 서버에 전달한다..
//
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
var
    f_OleVariant:OleVariant;
    f_ServerIP:String;
begin
    g_MatrixUserID := UpperCase(EditUserName.Text);
    g_MatrixUserPW := EditPassword.Text;
    OPSLogin := true;
    SECLogin := true;

    OKBtn.Enabled := false;
    CancelBtn.Enabled := false;

    m_LoadController.Load;
end;

end.
