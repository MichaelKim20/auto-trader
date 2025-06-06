unit MKChildFrameCustom;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  MKDefine,
  FNQuotData,
  MKIndicatorValue,
  FNSocketManager,
  FNSymbolCollection
  ;

type
  TChildFrameCustom = class(TFrame)

    protected
        m_SocketManager : CFNSocketManager;

        m_SelectedSymbolItem : CFNSymbolItem;

        m_SelectIndex:Integer;
        m_Active:Boolean;
        m_SelectedItemChanged:Boolean;

        procedure WMMessageProcess(var Message: TMessage); message WM_CHILD_PROCESS;
        procedure OnWMMessageProcess(var Message: TMessage); virtual;
        procedure SetActive(AValue:Boolean);
        procedure OnChangeActivity; virtual;

    public

        procedure OnFormCreate; virtual;
        procedure OnFormCloe; virtual;
        procedure OnFormActivate; virtual;

        property SocketManager : CFNSocketManager write m_SocketManager;
        property Active:Boolean read m_Active write SetActive default false;

    protected
        procedure ChangedSelectedSymbolItem(); virtual;
        procedure ReceiveIndicatorSetting(p_IndicatorValue:CMKIndicatorValue); virtual;
  end;

implementation

{$R *.dfm}


procedure TChildFrameCustom.ChangedSelectedSymbolItem;
begin

end;

procedure TChildFrameCustom.OnFormCreate;
begin
    m_SelectIndex := -1;
    m_SelectedItemChanged := false;
    m_Active := true;

end;


procedure TChildFrameCustom.OnChangeActivity;
begin

end;

procedure TChildFrameCustom.OnFormActivate;
begin

end;

procedure TChildFrameCustom.OnFormCloe;
begin

end;

procedure TChildFrameCustom.OnWMMessageProcess(var Message: TMessage);
begin
    if (WPARAM_SELECT_SYMBOLITEM = Message.WParam) then
    begin
        m_SelectedSymbolItem := CFNSymbolItem(Message.LParam);
        
        if m_Active then
        begin
            ChangedSelectedSymbolItem;
        end else
        begin
            m_SelectedItemChanged := true;
        end;

    end else
    if (WPARAM_INDICATOR_SETTING = Message.WParam) then
    begin
        ReceiveIndicatorSetting(CMKIndicatorValue(Message.LParam));
    end;
end;

procedure TChildFrameCustom.ReceiveIndicatorSetting(p_IndicatorValue: CMKIndicatorValue);
begin

end;

procedure TChildFrameCustom.SetActive(AValue: Boolean);
begin
    if (m_Active <> AValue) then
    begin
        m_Active := AValue;

        if not m_Active then
        begin
            m_SelectedItemChanged := false;
        end else
        begin
            if m_SelectedItemChanged then ChangedSelectedSymbolItem;
        end;

        OnChangeActivity;

    end;
end;



procedure TChildFrameCustom.WMMessageProcess(var Message: TMessage);
begin
    OnWMMessageProcess(Message);
end;

end.
