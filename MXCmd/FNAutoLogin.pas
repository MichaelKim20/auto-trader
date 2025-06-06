unit FNAutoLogin;

interface

uses
    Math, SysUtils, Classes, FNLoadController, FNLoadItem;

type

    CFNAutoLogin = class(TObject)
    public
        constructor Create;
        destructor Destroy; override;
        procedure Load;

    private
        m_LoadController:CFNLoadController;
        m_Complete:Boolean;

        procedure OnItemLoadStartedEvent(p_Item:CFNLoadItem);
        procedure OnItemLoadCompleteEvent(p_Item:CFNLoadItem);
        procedure OnItemLoadFaultEvent(p_Item:CFNLoadItem);
        procedure OnItemLoadMessageEvent(p_Item:CFNLoadItem);
        procedure OnStartEvent(p_Item:CFNLoadItem);
        procedure OnCompleteEvent(p_Item:CFNLoadItem);
        procedure OnFaultEvent(p_Item:CFNLoadItem);

    public
        property Complete:Boolean read m_Complete;

    end;

implementation

uses
  FNRegistry, FNGlobal, FNGlobalVariable, FNCMVariable;

//------------------------------------------------------------------------------------
constructor CFNAutoLogin.Create;
begin
    inherited Create;

    m_Complete := false;

    m_LoadController := CFNLoadController.Create;

    m_LoadController.AddItem(CFNLoadItemSocket.Create);
    m_LoadController.AddItem(CFNLoadItem_BASIC_0010.Create);
    m_LoadController.AddItem(CFNLoadItem_BASIC_0020.Create);
    m_LoadController.AddItem(CFNLoadItem_BASIC_0030.Create);
    m_LoadController.AddItem(CFNLoadItem_CODE_0010.Create);

    m_LoadController.OnStartEvent       := OnStartEvent;
    m_LoadController.OnCompleteEvent    := OnCompleteEvent;
    m_LoadController.OnFaultEvent       := OnFaultEvent;

    m_LoadController.OnItemLoadStartedEvent     := OnItemLoadStartedEvent;
    m_LoadController.OnItemLoadCompleteEvent    := OnItemLoadCompleteEvent;
    m_LoadController.OnItemLoadFaultEvent       := OnItemLoadFaultEvent;
    m_LoadController.OnItemLoadMessageEvent     := OnItemLoadMessageEvent;
end;

//------------------------------------------------------------------------------------
destructor CFNAutoLogin.Destroy;
begin
    if Assigned(m_LoadController) then
    begin
        m_LoadController.Free;
        m_LoadController := NIL;
    end;

    inherited;
end;

//------------------------------------------------------------------------------------
procedure CFNAutoLogin.Load;
begin
    m_LoadController.Load;
end;

//---------------------------------------------------------------------------
procedure CFNAutoLogin.OnStartEvent(p_Item: CFNLoadItem);
begin

end;

//---------------------------------------------------------------------------
procedure CFNAutoLogin.OnCompleteEvent(p_Item: CFNLoadItem);
begin
    m_Complete := true;
end;

//---------------------------------------------------------------------------
procedure CFNAutoLogin.OnFaultEvent(p_Item: CFNLoadItem);
begin

end;

//---------------------------------------------------------------------------
procedure CFNAutoLogin.OnItemLoadStartedEvent(p_Item: CFNLoadItem);
var
    f_MessageText:String;
begin
    if Assigned(p_Item) then
    begin
        f_MessageText := '[' + p_Item.WorkName + '] ' + p_Item.ResultMessage;
        WriteLn(f_MessageText);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNAutoLogin.OnItemLoadCompleteEvent(p_Item: CFNLoadItem);
var
    f_MessageText:String;
begin
    if Assigned(p_Item) then
    begin
        f_MessageText := '[' + p_Item.WorkName + '] ' + p_Item.ResultMessage;
        WriteLn(f_MessageText);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNAutoLogin.OnItemLoadFaultEvent(p_Item: CFNLoadItem);
var
    f_MessageText:String;
begin
    if Assigned(p_Item) then
    begin
        f_MessageText := '[' + p_Item.WorkName + '] ' + p_Item.ResultMessage;
        WriteLn(f_MessageText);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNAutoLogin.OnItemLoadMessageEvent(p_Item: CFNLoadItem);
var
    f_MessageText:String;
begin
    if Assigned(p_Item) then
    begin
        f_MessageText := '[' + p_Item.WorkName + '] ' + p_Item.ResultMessage;
        WriteLn(f_MessageText);
    end;
end;

end.
