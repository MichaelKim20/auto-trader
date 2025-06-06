unit SKLoginDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Sockets,
  Buttons, ExtCtrls, Dialogs, Messages,
  FNSocketManager, FNDataSet, FNLoadController,FNLoadItem,
  OleCtrls, DCPsha1, DCPrc4, IdHTTP,
  pngimage, GR32_Image;

type
  TLoginDlg = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    LabelWorkName: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    Label6: TLabel;
    LabelVersion: TLabel;
    Timer1: TTimer;
    MemoMessage: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);

  private
    m_LoadItem_USER_0010:CFNLoadItem_USER_0010;
    m_LoadController:CFNLoadController;
    m_LoginController:CFNLoadController;

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
begin
    OPSLogin := false;
    SECLogin := false;

    Caption := g_ApplicationName;
    LabelVersion.Caption := g_Version + ' ' + g_BuilderDate;

    m_LoginController := CFNLoadController.Create;
    m_LoginController.AddItem(CFNLoadItemSocket.Create);

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

end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnLoginStartEvent(p_Item: CFNLoadItem);
begin

end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnLoginCompleteEvent(p_Item: CFNLoadItem);
begin
    OPSLogin := true;
    SECLogin := true;

    m_LoadController.Load;
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnLoginFaultEvent(p_Item: CFNLoadItem);
begin
end;

//---------------------------------------------------------------------------
procedure TLoginDlg.OnStartEvent(p_Item: CFNLoadItem);
begin

end;

procedure TLoginDlg.Timer1Timer(Sender: TObject);
begin
    Timer1.Enabled:=false;
    OPSLogin := false;

    m_LoginController.Load;
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

end.
