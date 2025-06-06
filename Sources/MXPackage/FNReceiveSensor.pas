unit FNReceiveSensor;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, Messages, FNDataDelivery, FNQueue,
  FNDataObject, FNDataSet, Forms, SyncObjs, FNPOTCollection, FNSymbolCollection,
  FNMaterialCollection;

type
  CFNReceiveSensor = class(TCustomPanel)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    procedure OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
    procedure OnStream(AStreamRecord: CFNStreamRecord);

    procedure Start;
    procedure Stop;

  protected
    m_SymbolItem: CFNSymbolItem;

    m_DataDelivery: CFNDataDelivery;
    m_Timer: TTimer;
    m_DataLock: TCriticalSection;

    m_MTQuoteReceiveTime: TDateTime;

    m_POTItem: CFNPOTItem;

    m_MTDelayMin: Integer;
    m_TimeDifference: TDateTime;

  private
    procedure OnTimer(Sender: TObject);
    procedure SubscribeQuot;
    procedure UnSubscribeQuot;

  protected
    m_MTDisconnectEvent: TNotifyEvent;
    m_RLDisconnectEvent: TNotifyEvent;

  published
    property Caption;
    property Color;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BevelWidth;
    property BorderStyle;
    property BorderWidth;
    property Font;
    property Anchors;
    property Align;
    property DoubleBuffered;
    property OnMTDisconnect: TNotifyEvent read m_MTDisconnectEvent write m_MTDisconnectEvent;
    property MTDelayMin: Integer read m_MTDelayMin write m_MTDelayMin default 5;

  end;

procedure Register;

implementation

uses
  FNGlobal, DateUtils, WinProcs, FNCMVariable, MXVariable, Dialogs;

procedure Register;
begin
  RegisterComponents('MXPackage', [CFNReceiveSensor]);
end;

// ---------------------------------------------------------------------------
constructor CFNReceiveSensor.Create(AOwner: TComponent);
var
  f_POTItem: CFNPOTItem;
begin
  inherited Create(AOwner);

  m_SymbolItem := CFNSymbolItem.Create;

  m_DataDelivery := CFNDataDelivery.Create();
  m_DataDelivery.OnStreamEvent := OnStream; // 스트리밍 수신 이벤트 등록
  m_DataDelivery.OnReplyEvent := OnReply; // 조회성 데이터 수신 이벤트 등록

  m_DataLock := TCriticalSection.Create;

  m_Timer := TTimer.Create(NIL);
  m_Timer.Enabled := false;
  m_Timer.OnTimer := OnTimer;
  m_Timer.Interval := 2000;

  m_POTItem := CFNPOTItem.Create;

  m_MTQuoteReceiveTime := TFNGlobal.ServerNow;
end;

// ---------------------------------------------------------------------------
destructor CFNReceiveSensor.Destroy();
begin
  UnSubscribeQuot;

  if Assigned(m_DataDelivery) then
  begin
    m_DataDelivery.Free;
    m_DataDelivery := NIL;
  end;

  if Assigned(m_SymbolItem) then
  begin
    m_SymbolItem.Free;
    m_SymbolItem := NIL;
  end;

  if Assigned(m_Timer) then
  begin
    m_Timer.Enabled := false;
    m_Timer.Free;
    m_Timer := NIL;
  end;

  if Assigned(m_DataLock) then
  begin
    m_DataLock.Free;
    m_DataLock := NIL;
  end;

  if Assigned(m_POTItem) then
  begin
    m_POTItem.Free;
    m_POTItem := NIL;
  end;

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
// CFNChildForm 에 포함된 넌비주얼 컴포넌터인 CFNDataDelivery에서 발생한 OnReply을
// 처리하기 위해 생성한 이벤트함수이다. 이 함수는 조회성 요청의 응답데이터를 반환한다.
procedure CFNReceiveSensor.OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
begin

end;

// ---------------------------------------------------------------------------
// CFNChildForm 에 포함된 넌비주얼 컴포넌터인 CFNDataDelivery에서 발생한 OnStream을
// 처리하기 위해 생성한 이벤트함수이다. 이 함수는 스트리밍으로 전달받은 데이터를 반환한다.
procedure CFNReceiveSensor.OnStream(AStreamRecord: CFNStreamRecord);
begin
  if (m_SymbolItem.m_Country = AStreamRecord.GetIntegerValue('COUNTRY_NO')) and (m_SymbolItem.m_Group = AStreamRecord.GetIntegerValue('GROUP_NO')) and
    (m_SymbolItem.m_Market = AStreamRecord.GetIntegerValue('MARKET_NO')) and (m_SymbolItem.m_Symbol = AStreamRecord.GetStringValue('SYMBOL')) then
  begin
    m_DataLock.Enter;
    try
      m_MTQuoteReceiveTime := TFNGlobal.ServerNow + m_TimeDifference;
    finally
      m_DataLock.Leave;
    end;
  end;

  AStreamRecord.DecreaseReferenceCount;
end;

// ---------------------------------------------------------------------------
procedure CFNReceiveSensor.OnTimer(Sender: TObject);
var
  f_MTQuoteReceiveTime: TDateTime;
  f_RLQuoteReceiveTime: TDateTime;

  f_CurrentTime: TDateTime;
  f_Time: Integer;
  f_Hour, f_Min, f_Sec: Integer;

  f_OpenTime, f_CloseTime, f_NowTime: TDateTime;
  f_OffsetMin: TDateTime;

  f_Value1: Integer;
  f_Value2: Integer;

  f_EXDateTime: Double;
begin
  m_DataLock.Enter;
  try
    f_MTQuoteReceiveTime := m_MTQuoteReceiveTime;
  finally
    m_DataLock.Leave;
  end;

  f_CurrentTime := TFNGlobal.ServerNow;
  f_EXDateTime := f_CurrentTime + m_TimeDifference;
  f_NowTime := (f_EXDateTime) - Trunc(f_EXDateTime);

  if m_POTItem.m_HoliDay = 1 then
    exit;

  if (DayOfWeek(f_EXDateTime) = 7) or (DayOfWeek(f_EXDateTime) = 1) then
    exit;

  f_Time := m_POTItem.m_Open[0];
  f_Hour := m_POTItem.NumberToHour(f_Time);
  f_Min := m_POTItem.NumberToMin(f_Time);
  f_Sec := m_POTItem.NumberToSec(f_Time);

  f_OpenTime := EncodeTime(f_Hour, f_Min, f_Sec, 0);
  // f_OpenTime  := EncodeTime(15, 40, 0, 0);

  f_Time := m_POTItem.m_Close[m_POTItem.m_HourCount - 1];
  f_Hour := m_POTItem.NumberToHour(f_Time);
  f_Min := m_POTItem.NumberToMin(f_Time);
  f_Sec := m_POTItem.NumberToSec(f_Time);

  f_CloseTime := EncodeTime(f_Hour, f_Min, f_Sec, 0);
  f_CloseTime := EncodeTime(21, 20, 0, 0);

  f_OffsetMin := (1.0 / 1440.0);

  if (f_OpenTime + f_OffsetMin * 2 <= f_NowTime) and (f_NowTime <= f_CloseTime - f_OffsetMin * 2) then
  begin
    if (f_EXDateTime - f_MTQuoteReceiveTime > (m_MTDelayMin / 1440.0)) then
    begin
      m_DataLock.Enter;
      try
        m_MTQuoteReceiveTime := TFNGlobal.ServerNow + m_TimeDifference;
      finally
        m_DataLock.Leave;
      end;

      if Assigned(g_SocketManager) then
      begin
        if Assigned(m_MTDisconnectEvent) then
        begin
          m_MTDisconnectEvent(Self);
        end
        else
        begin
          g_SocketManager.EnableEvent := false;
          try
            g_SocketManager.RecoverySession;
          finally
            g_SocketManager.EnableEvent := true;
          end;
        end;
      end
      else
      begin
        LOG_WRITE(LOG_TYPE_ERROR, 'CFNReceiveSensor', IntToStr(f_Value1) + '분 동안 시그널데이터가 전송되지 않습니다.');
      end;
    end;

  end;
end;

// ---------------------------------------------------------------------------
// 실시간 스트리밍을 요청한다.
procedure CFNReceiveSensor.Start;
var
  f_SymbolItem: CFNSymbolItem;
  f_POTItem: CFNPOTItem;
  f_MaterialItem: CFNMaterialItem;
begin
  if not Assigned(g_SymbolCollection) then
    exit;

  f_SymbolItem := g_SymbolCollection.Find(g_DefaultCountry, g_DefaultGroup, g_DefaultMarket, g_DefaultSymbol);
  if Assigned(f_SymbolItem) then
  begin
    m_SymbolItem.Clone(f_SymbolItem);
  end;

  m_TimeDifference := 0;
  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(g_DefaultCountry, g_DefaultGroup, g_DefaultMarket, g_DefaultSymbol);

    if Assigned(f_MaterialItem) then
    begin
      m_TimeDifference := f_MaterialItem.m_TimeDiffrence;
    end;
  end;

  if Assigned(g_POTCollection) then
  begin
    f_POTItem := g_POTCollection.Find(TFNGlobal.ServerNow + m_TimeDifference, m_SymbolItem.m_Country, m_SymbolItem.m_Group, m_SymbolItem.m_Market, m_SymbolItem.m_Symbol);

    if Assigned(f_POTItem) then
    begin
      m_POTItem.Clone(f_POTItem);
    end;
  end;

  m_MTQuoteReceiveTime := TFNGlobal.ServerNow + m_TimeDifference;

  SubscribeQuot;
  m_Timer.Enabled := true;
end;

// ---------------------------------------------------------------------------
procedure CFNReceiveSensor.Stop;
begin
  UnSubscribeQuot;
end;

// ---------------------------------------------------------------------------
procedure CFNReceiveSensor.SubscribeQuot;
begin
  m_MTQuoteReceiveTime := TFNGlobal.ServerNow + m_TimeDifference;

  if Assigned(g_SocketManager) then
    g_SocketManager.SubscribeQuote(m_DataDelivery, m_SymbolItem.m_Country, m_SymbolItem.m_Group, m_SymbolItem.m_Market, m_SymbolItem.m_Symbol);
end;

// ---------------------------------------------------------------------------
procedure CFNReceiveSensor.UnSubscribeQuot;
begin
  if Assigned(g_SocketManager) then
    g_SocketManager.UnsubscribeAll(m_DataDelivery);
end;

// ---------------------------------------------------------------------------
end.
