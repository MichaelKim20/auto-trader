unit FNTickerItem;

interface

uses
  SysUtils, Classes, Controls, Graphics, Types, Messages, ExtCtrls,
  FNDataSet,
  FNQueue,
  FNQuotData,
  FNDataDelivery,
  FNSocketManager,
  FNSymbolCollection;

const

  TICKER_PADDING_LEFT = 12;
  TICKER_PADDING_RIGHT = 12;
  TICKER_NAME_WIDTH = 120;
  TICKER_CLOSEPRICE_WIDTH = 60;
  TICKER_CHANGEPRICE_WIDTH = 45;
  TICKER_CHANGERATE_WIDTH = 50;
  TICKER_VOLUME_WIDTH = 60;

  TICKERITEM_WIDTH = TICKER_PADDING_LEFT + TICKER_PADDING_RIGHT + TICKER_NAME_WIDTH + TICKER_CLOSEPRICE_WIDTH;
  TICKERITEM_HEIGHT = 24;

type
  CFNTickerItem = class(TCustomControl)
  private
    m_OnMouseEnter: TNotifyEvent;
    m_OnMouseLeave: TNotifyEvent;

    m_VisibleFieldName: Boolean;
    m_VisibleFieldClosePrice: Boolean;

    procedure SetBgFrameWidth(p_BgFrameWidth: Integer);
    procedure SetBgColor(p_BgColor: TColor);
    procedure SetBgFrameColor(p_BgFrameColor: TColor);
    procedure SetQuotData(p_QuotData: CFNQuotData);
    procedure SetFlashed(p_Value: Boolean);
    procedure SetOvered(p_Value: Boolean);

  private
    m_SocketManager: CFNSocketManager;
    m_DataDelivery: CFNDataDelivery;
    m_SymbolItem: CFNSymbolItem;
    m_QuotData: CFNQuotData;

    procedure OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
    procedure OnStream(AStreamRecord: CFNStreamRecord);
    procedure RequestQuot;
    procedure SubscribeQuot;
    procedure UnSubscribeQuot;

  public
    procedure SetSymbolItem(ASymbolItem: CFNSymbolItem);
    property SocketManager: CFNSocketManager write m_SocketManager;

  protected
    m_BoundRect: TRect;
    m_ClientRect: TRect;
    m_BgFrameWidth: Integer;

    m_BgColor: TColor;
    m_OverColor: TColor;
    m_FlashColor: TColor;
    m_BgFrameColor: TColor;

    m_Overed: Boolean;
    m_Flashed: Boolean;

    m_MajorType: Integer;

    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMMouseFirst(var Message: TMessage); message WM_MOUSEFIRST;
    procedure WMMouseLeave(var Message: TMessage); message WM_MOUSELEAVE;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    procedure Paint; override;

    procedure Draw(ACanvas: TCanvas); Virtual;

    procedure DrawBackground(ACanvas: TCanvas);
    procedure DrawFrame(ACanvas: TCanvas);
    procedure DrawQuot(ACanvas: TCanvas);

    procedure LayOut();
    function GetWidth: Integer;

  published
    property Font;
    property Anchors;
    property Align;
    property DoubleBuffered;

    property BgFrameWidth: Integer read m_BgFrameWidth write SetBgFrameWidth;

    property BgColor: TColor read m_BgColor write SetBgColor;
    property BgFrameColor: TColor read m_BgFrameColor write SetBgFrameColor;
    property QuotData: CFNQuotData read m_QuotData write SetQuotData;
    property OnMouseEnter: TNotifyEvent read m_OnMouseEnter write m_OnMouseEnter;
    property OnMouseLeave: TNotifyEvent read m_OnMouseLeave write m_OnMouseLeave;
    property Overed: Boolean read m_Overed write SetOvered default false;
    property Flashed: Boolean read m_Flashed write SetFlashed default false;
    property MajorType: Integer read m_MajorType write m_MajorType default 1;
    property OnClick;
  end;

procedure Register;

implementation

uses
  WinProcs, FNGlobal, FNControlColorSet, CommonTRMaker;

procedure Register;
begin
  RegisterComponents('FNMXPackage', [CFNTickerItem]);
end;

// ---------------------------------------------------------------------------
constructor CFNTickerItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_SymbolItem := CFNSymbolItem.Create;
  m_QuotData := CFNQuotData.Create;
  m_DataDelivery := CFNDataDelivery.Create;
  m_DataDelivery.OnStreamEvent := OnStream; // 스트리밍 수신 이벤트 등록
  m_DataDelivery.OnReplyEvent := OnReply; // 조회성 데이터 수신 이벤트 등록

  m_VisibleFieldName := true;
  m_VisibleFieldClosePrice := true;

  Self.AutoSize := false;
  Self.ParentFont := true;

  m_BoundRect := Rect(0, 0, 0, 0);
  m_ClientRect := Rect(0, 0, 0, 0);
  m_BgFrameWidth := 1;

  m_BgColor := COLOR_GD_ITEM_BACKGROUND;
  m_OverColor := COLOR_GD_ITEM_OVER;
  m_FlashColor := RGB($00, $00, $40);
  m_BgFrameColor := RGB($40, $40, $40);

  m_Overed := false;
  m_Flashed := false;

  m_QuotData := CFNQuotData.Create;
end;

// ---------------------------------------------------------------------------
destructor CFNTickerItem.Destroy();
begin
  m_QuotData.Free;
  m_QuotData := NIL;
  m_SymbolItem.Free;
  m_DataDelivery.Free;
  m_QuotData.Free;

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
// 전체를 그린다.
procedure CFNTickerItem.Draw(ACanvas: TCanvas);
begin
  DrawBackground(ACanvas);
  DrawFrame(ACanvas);
  DrawQuot(ACanvas);
end;

// ---------------------------------------------------------------------------
// 배경을 그린다.
procedure CFNTickerItem.DrawBackground(ACanvas: TCanvas);
begin
  if m_Flashed then
  begin
    ACanvas.Brush.Color := m_FlashColor;
  end
  else if m_Overed then
  begin
    ACanvas.Brush.Color := m_OverColor;
  end
  else
  begin
    ACanvas.Brush.Color := m_BgColor;
  end;
  ACanvas.Brush.Style := bsSolid;

  ACanvas.FillRect(m_BoundRect);
end;

// ---------------------------------------------------------------------------
procedure CFNTickerItem.DrawFrame(ACanvas: TCanvas);
begin
  if (0 < m_BgFrameWidth) then
  begin
    ACanvas.Brush.Style := bsClear;
    ACanvas.Pen.Color := m_BgFrameColor;
    ACanvas.Pen.Width := m_BgFrameWidth;
    ACanvas.Rectangle(0, 0, Self.Width, Self.Height);
  end;
end;

// ---------------------------------------------------------------------------
// 외곽선을 그린다.
procedure CFNTickerItem.DrawQuot(ACanvas: TCanvas);
var
  f_Size: TSize;
  f_X, f_Y: Integer;
  f_String: String;
  f_FieldLeft, f_FieldRight: Integer;
begin
  ACanvas.Font.Size := 9;
  f_FieldLeft := TICKER_PADDING_LEFT;

  if m_VisibleFieldName then
  begin

    f_Size := ACanvas.TextExtent(m_SymbolItem.m_Name);
    f_FieldRight := f_FieldLeft + TICKER_NAME_WIDTH;
    f_X := f_FieldLeft;
    f_Y := (RectHeight(m_BoundRect) - f_Size.cy) div 2;
    ACanvas.Font.Color := COLOR_PRICE_EQ;
    ACanvas.TextOut(f_X, f_Y, m_SymbolItem.m_Name);
    f_FieldLeft := f_FieldLeft + TICKER_NAME_WIDTH;

  end;

  if not m_QuotData.m_UpdateRequest then
    exit;

  ACanvas.Font.Color := COLOR_PRICE_EQ;

  if m_VisibleFieldClosePrice then
  begin
    // 현재가
    if 0 = m_MajorType then
    begin
      f_String := Format('%.2n', [m_QuotData.m_ClosePrice]);
    end
    else
    begin
      f_String := Format('%.2n', [m_QuotData.m_CloseOPS]);
    end;
    f_Size := ACanvas.TextExtent(f_String);

    f_FieldRight := f_FieldLeft + TICKER_CLOSEPRICE_WIDTH;

    f_X := f_FieldRight - f_Size.cx;
    f_Y := (RectHeight(m_BoundRect) - f_Size.cy) div 2;
    ACanvas.TextOut(f_X, f_Y, f_String);
    f_FieldLeft := f_FieldRight;
  end;

end;

// ---------------------------------------------------------------------------
// 콤포넌트의 너비를 계산한다.
function CFNTickerItem.GetWidth: Integer;
var
  f_Width: Integer;
begin
  f_Width := TICKER_PADDING_LEFT;

  if m_VisibleFieldName then
  begin
    f_Width := f_Width + TICKER_NAME_WIDTH;
  end;

  if m_VisibleFieldClosePrice then
  begin
    f_Width := f_Width + TICKER_CLOSEPRICE_WIDTH;
  end;

  f_Width := f_Width + TICKER_PADDING_RIGHT;
  Result := f_Width;
end;

// ---------------------------------------------------------------------------
// 배치를 한다.
procedure CFNTickerItem.LayOut;
begin
  m_BoundRect := Rect(0, 0, Self.Width, Self.Height);
  m_ClientRect := Rect(m_BgFrameWidth, m_BgFrameWidth, Self.Width - (m_BgFrameWidth * 2), Self.Height - (m_BgFrameWidth * 2));
end;

// ---------------------------------------------------------------------------
// 윈도우의 그리는 이벤트를 처리
procedure CFNTickerItem.Paint;
begin
  inherited;

  Draw(Canvas);
end;

// ---------------------------------------------------------------------------
// 배경색을 지정한다.
procedure CFNTickerItem.SetBgColor(p_BgColor: TColor);
begin
  m_BgColor := p_BgColor;

  Repaint;
end;

// ---------------------------------------------------------------------------
// 외곽선의 색을 지정한다.
procedure CFNTickerItem.SetBgFrameColor(p_BgFrameColor: TColor);
begin
  m_BgFrameColor := p_BgFrameColor;

  Repaint;
end;

// ---------------------------------------------------------------------------
// 외곽선의 두께를 지정한다.
procedure CFNTickerItem.SetBgFrameWidth(p_BgFrameWidth: Integer);
begin
  m_BgFrameWidth := p_BgFrameWidth;

  Repaint;
end;

// ---------------------------------------------------------------------------
// 번쩍임을 지정한다.
procedure CFNTickerItem.SetFlashed(p_Value: Boolean);
begin
  m_Flashed := p_Value;
  Repaint;
end;

// --------------------------------------------- ------------------------------
// 마우스가 오버되었다고 지정한다.
procedure CFNTickerItem.SetOvered(p_Value: Boolean);
begin
  m_Overed := p_Value;
  Repaint;
end;

// ---------------------------------------------------------------------------
// 시세를 입력한다.
procedure CFNTickerItem.SetQuotData(p_QuotData: CFNQuotData);
begin
  m_QuotData.Clone(p_QuotData);
  Draw(Canvas);
end;

// ---------------------------------------------------------------------------
// 마우스가 진입되면
procedure CFNTickerItem.WMMouseFirst(var Message: TMessage);
begin
  if Assigned(m_OnMouseEnter) then
    m_OnMouseEnter(Self);
  m_Overed := true;
  Repaint;
end;

// ---------------------------------------------------------------------------
// 마우스가 나가면
procedure CFNTickerItem.WMMouseLeave(var Message: TMessage);
begin
  if Assigned(m_OnMouseLeave) then
    m_OnMouseLeave(Self);
  m_Overed := false;
  Repaint;
end;

// ---------------------------------------------------------------------------
// 크기가 변경되면
procedure CFNTickerItem.WMSize(var Message: TWMSize);
begin
  inherited;
  LayOut();
end;

// -------------------------------------------------------------------------------------------------
procedure CFNTickerItem.OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
var
  f_DataSet: CFNDataSet;
  f_Record: CFNRecord;

  f_Success: Boolean;
begin
  if (ADataPackage.GetServiceID = 'SC_QUOTE') then
  begin
    if (ADataPackage.GetTRCode = 'TR_0010') then
    begin
      if (ADataPackage.GetMsgCode <> 'M00000') then
      begin
        Sleep(1000);
        RequestQuot;
      end;

      f_Success := false;

      f_DataSet := ADataPackage.GetDataSet(DATASETID_OUT_01);
      if Assigned(f_DataSet) then
      begin
        if 0 < f_DataSet.RecordList.Count then
        begin
          f_Record := CFNRecord(f_DataSet.RecordList.Items[0]);
          if (m_SymbolItem.m_Country = f_Record.GetIntegerValue('COUNTRY_NO')) and (m_SymbolItem.m_Group = f_Record.GetIntegerValue('GROUP_NO')) and
            (m_SymbolItem.m_Market = f_Record.GetIntegerValue('MARKET_NO')) and (m_SymbolItem.m_Symbol = f_Record.GetStringValue('SYMBOL')) then
          begin
            f_Success := true;

            m_QuotData.OPSArrayToData(f_Record);
            m_QuotData.m_UpdateRequest := true;

            Repaint;

          end
          else
          begin
            f_Success := false;
          end;
        end
        else
        begin
          f_Success := false;
        end;
      end
      else
      begin
        f_Success := false;
      end;

      if (f_Success) then
      begin
        SubscribeQuot;
      end;
    end;
  end;
end;

// -------------------------------------------------------------------------------------------------
procedure CFNTickerItem.OnStream(AStreamRecord: CFNStreamRecord);
begin
  if (m_SymbolItem.m_Country = AStreamRecord.GetIntegerValue('COUNTRY_NO')) and (m_SymbolItem.m_Group = AStreamRecord.GetIntegerValue('GROUP_NO')) and
    (m_SymbolItem.m_Market = AStreamRecord.GetIntegerValue('MARKET_NO')) and (m_SymbolItem.m_Symbol = AStreamRecord.GetStringValue('SYMBOL')) then
  begin
    m_QuotData.OPSStreamDataToData(AStreamRecord);
    m_QuotData.m_UpdateRequest := true;
    Repaint;
  end;
  AStreamRecord.DecreaseReferenceCount;
end;

// -------------------------------------------------------------------------------------------------
procedure CFNTickerItem.SetSymbolItem(ASymbolItem: CFNSymbolItem);
begin
  m_SymbolItem.Clone(ASymbolItem);

  m_QuotData.m_UpdateRequest := false;
  UnSubscribeQuot;
  RequestQuot;

  Invalidate;
end;

// ------------------------------------------------------------------------------------
procedure CFNTickerItem.RequestQuot;
var
  f_Record: CFNRecord;
  f_DataPackage: CFNDataPackage;
begin
  if not Assigned(m_SocketManager) then
    exit;

  f_Record := CFNRecord.Create();
  f_Record.SetStringValue('SYMBOL', m_SymbolItem.m_Symbol);
  f_DataPackage := Make_SC_QUOTE_TR_0010_IN(NIL, f_Record);
  m_SocketManager.Request(m_DataDelivery, f_DataPackage);
  f_DataPackage.Free;
end;

// ------------------------------------------------------------------------------------
procedure CFNTickerItem.SubscribeQuot;
begin
  if not Assigned(m_SocketManager) then
    exit;
  m_SocketManager.SubscribeQuote(m_DataDelivery, m_SymbolItem.m_Country, m_SymbolItem.m_Group, m_SymbolItem.m_Market, m_SymbolItem.m_Symbol);
end;

// ------------------------------------------------------------------------------------
procedure CFNTickerItem.UnSubscribeQuot;
begin
  if not Assigned(m_SocketManager) then
    exit;
  m_SocketManager.UnSubscribeQuote(m_DataDelivery, m_SymbolItem.m_Country, m_SymbolItem.m_Group, m_SymbolItem.m_Market, m_SymbolItem.m_Symbol);
end;

end.
