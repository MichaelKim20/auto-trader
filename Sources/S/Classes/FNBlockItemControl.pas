unit FNBlockItemControl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  CommonTRMaker,
  ExtCtrls,
  FNDataDelivery,
  FNDataSet,
  FNTradeSystem,
  FNTrafficManager,
  MXBlock,
  MXOption,
  MXSumaryOption,
  MXSystemManager,
  MXOrderManager,
  MXBlockManager,
  FNBlockContentFrame;

type
  TBlockItemControl = class(TObject)
  private
    m_Block: CMXBlock;
    m_BlockContentFrame: TBlockContentFrame;

    m_EnableEvent: Boolean;
    m_SignalCollection: CFNSignalCollection;
    m_OrderCollection: CFNOrderCollection;
    m_TradeCollection: CFNTradeCollection;

    m_AdjustCollection: CFNAdjustCollection;

    // m_TimerAutoRun:TTimer;

    m_LogEvent: TFNLogNotifyEvent;
    m_UpdateEvent: TNotifyEvent;

    m_TrafficManager: CFNTrafficManager;
    m_ValueCollection: Array [0 .. 2] of CFNPMValueCollection;

    procedure SetBlockContentFrame(ABlockContentFrame: TBlockContentFrame);
    procedure TimerAutoRunTimer(Sender: TObject);

  public
    m_BlockName: String;
    m_State: Integer;
    m_SystemSignal: Integer;
    m_OrderSignal: Integer;

    m_SDateTime: Double;
    m_SQuote: Double;
    m_SVirtualProfit: Double;
    m_SVirtualProfit_Currency: Double;

    m_SRealProfit: Double;
    m_SRealProfit_Currency: Double;

    m_SPosition: Integer;
    m_STradeCount: Integer;
    m_SCommission: Double;

    m_ODateTime: Double;
    m_OQuote: Double;
    m_OProfit: Double;
    m_OProfit_Currency: Double;
    m_OPosition: Integer;
    m_OTradeCount: Integer;
    m_OCommission: Double;

    m_TradeSymbol: String;

    m_AccountNo: String;

    m_CommissionRate: Double;

  protected

    procedure OnChangedSystemManager(Sender: TObject);

    procedure OnOptionChangedEvent(Sender: TObject);
    procedure OnBlockReadEvent(Sender: TObject);
    procedure OnSystemManagerDoneWorkEvent(Sender: TObject);
    procedure OnOrderManagerChangedEvent(Sender: TObject);
    procedure OnOrderManagerChangedProfitEvent(Sender: TObject);
    procedure OnOrderManagerChangedStateEvent(Sender: TObject);
    procedure OnOrderManagerEndWorkEvent(Sender: TObject);
    procedure OnLogEvent(ASender: TObject; ADateTime: TDateTime; AType: Integer; AMessage, AClassName: String);

    procedure Clear;

    procedure ClearOrderManagerInfo;
    procedure DisplayOrderManagerInfo;

    procedure ClearOrderManagerProfit;
    procedure DisplayOrderManagerProfit;

    procedure ClearLogInfo;
    procedure DisplayLogInfo;

  public
    procedure PrepareOfStart;

    procedure ActionStart;
    function ActionCanStart: Boolean;

    procedure ActionStop;
    function ActionCanStop: Boolean;

    procedure ActionSaveTradeResult;

    constructor Create;
    destructor Destroy; override;

    procedure GetOption;

    property Block: CMXBlock read m_Block;
    property BlockContentFrame: TBlockContentFrame read m_BlockContentFrame write SetBlockContentFrame;

    procedure DoSaveTradeResult;
    procedure DoSaveSignal;
    procedure DoDumpChartData;
    procedure DoStart;
    procedure DoStop;
    procedure DoLosscut;

    function GetTradeList: String;

    procedure DoExitCurrentSignal;

    property OnLog: TFNLogNotifyEvent read m_LogEvent write m_LogEvent;
    property OnUpdate: TNotifyEvent read m_UpdateEvent write m_UpdateEvent;
  end;

  TBlockItemControlCollection = class(TObject)
  private
    m_Option: CMXSumaryOption;

  public
    m_Items: TList;

    m_SDateTime: Double;
    m_SQuote: Double;
    m_SVirtualProfit: Double;
    m_SVirtualProfit_Currency: Double;

    m_SRealProfit: Double;
    m_SRealProfit_Currency: Double;

    m_SPosition: Integer;
    m_SBuyPosition: Integer;
    m_SSellPosition: Integer;
    m_STradeCount: Integer;
    m_SCommission: Double;

    m_ODateTime: Double;
    m_OQuote: Double;
    m_OProfit: Double;
    m_OProfit_Currency: Double;
    m_OPosition: Integer;
    m_OBuyPosition: Integer;
    m_OSellPosition: Integer;
    m_OTradeCount: Integer;
    m_OCommission: Double;

    m_PositionGap: Integer;

  public
    constructor Create;
    destructor Destroy; override;

  public
    procedure Add(ABlockItemControl: TBlockItemControl);
    procedure RemoveAll;
    procedure Delete(ABlockItemControl: TBlockItemControl);
    procedure Sort;
    procedure Prepare;
    procedure Summary;
    procedure DoLosscut;

    procedure CheckBlockName;

    property SummaryOption: CMXSumaryOption read m_Option write m_Option;

  end;

implementation

uses
  FNGlobal, DateUtils, Math, MKStreamChartDataSeries, MKChartData, FNCMVariable,
  MXVariable, FNSymbolCollection, FNAccountData, FNPOTCollection, FNDefine;

{$REGION 'TBlockItemControl'}

// ------------------------------------------------------------------------------------
constructor TBlockItemControl.Create;
var
  f_SymbolItem: CFNSymbolItem;
  f_AccountData: CFNAccountData;
begin
  m_EnableEvent := true;
  m_CommissionRate := 0;;

  m_BlockContentFrame := NIL;

  m_TrafficManager := CFNTrafficManager.Create;
  m_ValueCollection[0] := CFNPMValueCollection.Create;
  m_ValueCollection[1] := CFNPMValueCollection.Create;
  m_ValueCollection[2] := CFNPMValueCollection.Create;

  m_Block := CMXBlock.Create;

  m_Block.SystemManager.Option := m_Block.Option;
  m_Block.SystemManager.BlockName := m_Block.BlockName;
  m_Block.SystemManager.BlockKey := m_Block.BlockKey;

  m_Block.SystemManager.ApplyTSOCollection(m_Block.Option.StrategyOptionCollection);
  m_Block.SystemManager.OnDoneWork := OnSystemManagerDoneWorkEvent;
  m_Block.SystemManager.OnLog := OnLogEvent;

  m_Block.OrderManager.Option := m_Block.Option;
  m_Block.OrderManager.BlockName := m_Block.BlockName;
  m_Block.OrderManager.BlockKey := m_Block.BlockKey;
  // ??m_Block.OrderManager.SymbolString := m_Block.SymbolItemArray.GetSymbolString3(m_Block.Option);

  m_Block.OrderManager.OnChanged := OnOrderManagerChangedEvent;
  m_Block.OrderManager.OnChangedState := OnOrderManagerChangedStateEvent;
  m_Block.OrderManager.OnChangedProfit := OnOrderManagerChangedProfitEvent;
  m_Block.OrderManager.OnEndedWork := OnOrderManagerEndWorkEvent;

  m_Block.OrderManager.OnLog := OnLogEvent;

  m_Block.OnRead := OnBlockReadEvent;

  m_SignalCollection := CFNSignalCollection.Create;
  m_OrderCollection := CFNOrderCollection.Create;
  m_TradeCollection := CFNTradeCollection.Create;

  m_AdjustCollection := CFNAdjustCollection.Create;
  m_EnableEvent := true;

  if g_SymbolCollection.m_Items.Count > 0 then
  begin
    f_SymbolItem := CFNSymbolItem(g_SymbolCollection.m_Items[0]);

    m_Block.Option.SetIntegerValue('COUNTRY_NO', f_SymbolItem.m_Country);
    m_Block.Option.SetIntegerValue('GROUP_NO', f_SymbolItem.m_Group);
    m_Block.Option.SetIntegerValue('MARKET_NO', f_SymbolItem.m_Market);
    m_Block.Option.SetStringValue('SYMBOL', f_SymbolItem.m_Symbol);
    m_Block.Option.SetStringValue('SEC_SYMBOL', f_SymbolItem.m_SecSymbol);
    m_Block.Option.SetStringValue('CONTRACT', f_SymbolItem.m_Contract);
    m_Block.Option.SetStringValue('TRADESYMBOL', f_SymbolItem.m_SecSymbol + f_SymbolItem.m_Contract);
  end;

  if g_AccountArray.m_Items.Count > 0 then
  begin
    f_AccountData := g_AccountArray.m_Items[0];
    m_Block.Option.SetStringValue('ACCOUNT_NO', f_AccountData.m_AccountNo);
  end
  else
  begin
    m_Block.Option.SetStringValue('ACCOUNT_NO', '');
  end;
  (*
    m_TimerAutoRun := TTimer.Create(NIL);
    m_TimerAutoRun.Enabled := false;
    m_TimerAutoRun.OnTimer := TimerAutoRunTimer;
    m_TimerAutoRun.Interval := 5000;
  *)

  m_BlockName := m_Block.BlockName;
  m_State := PROCESS_STATE_ENDED_WORK;
  m_OrderSignal := SIGNAL_NONE;
  m_SystemSignal := SIGNAL_NONE;

  m_SDateTime := 0;
  m_SQuote := 0;
  m_SVirtualProfit := 0;
  m_SVirtualProfit_Currency := 0;
  m_SRealProfit := 0;
  m_SRealProfit_Currency := 0;
  m_SPosition := 0;
  m_STradeCount := 0;
  m_SCommission := 0;

  m_ODateTime := 0;
  m_OQuote := 0;
  m_OProfit := 0;
  m_OProfit_Currency := 0;
  m_OPosition := 0;
  m_OTradeCount := 0;
  m_OCommission := 0;

  m_TradeSymbol := m_Block.Option.GetStringValue('TRADESYMBOL');
  m_AccountNo := m_Block.Option.GetStringValue('ACCOUNT_NO');
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.TimerAutoRunTimer(Sender: TObject);
begin
  ActionStart;
end;

// ------------------------------------------------------------------------------------
destructor TBlockItemControl.Destroy;
begin
  m_TrafficManager.Free;
  m_ValueCollection[0].Free;
  m_ValueCollection[1].Free;
  m_ValueCollection[2].Free;

  m_LogEvent := NIL;
  m_UpdateEvent := NIL;

  (*
    if Assigned(m_TimerAutoRun) then
    begin
    m_TimerAutoRun.Free;
    m_TimerAutoRun := NIL;
    end;
  *)

  if Assigned(m_SignalCollection) then
  begin
    m_SignalCollection.Free;
    m_SignalCollection := NIL;
  end;

  if Assigned(m_OrderCollection) then
  begin
    m_OrderCollection.Free;
    m_OrderCollection := NIL;
  end;

  if Assigned(m_TradeCollection) then
  begin
    m_TradeCollection.Free;
    m_TradeCollection := NIL;
  end;

  if Assigned(m_AdjustCollection) then
  begin
    m_AdjustCollection.Free;
    m_AdjustCollection := NIL;
  end;

  if Assigned(m_Block) then
  begin
    m_Block.Free;
    m_Block := NIL;
  end;

  inherited;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.SetBlockContentFrame(ABlockContentFrame: TBlockContentFrame);
begin
  m_BlockContentFrame := ABlockContentFrame;
  if Assigned(m_BlockContentFrame) then
  begin
    m_BlockContentFrame.BlockItemControl := Self;
    m_BlockContentFrame.OnOptionChanged := OnOptionChangedEvent;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.Clear;
begin
  if Assigned(m_BlockContentFrame) then
  begin
    m_BlockContentFrame.Clear;
  end;

  ClearLogInfo;
  ClearOrderManagerInfo;
  ClearOrderManagerProfit;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.PrepareOfStart;
begin
  if not Assigned(m_Block) then
    exit;

  if Assigned(m_BlockContentFrame) then
    m_BlockContentFrame.MatrixOptionFrame1.GetOption;
end;

{$REGION 'Action'}

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.ActionStart;
begin
  if not Assigned(m_Block) then
    exit;

  if m_Block.OrderManager.State = PROCESS_STATE_ENDED_WORK then
  begin
    if (m_Block.Option.StrategyOptionCollection.m_Items.Count = 0) then
    begin
      Dialogs.MessageDlg('선택된 시스템이 존재하지 않습니다. 먼저 시스템을 선택해 주세요.', mtError, [mbOk], 0, mbOk);

    end
    else
    begin
      if Assigned(m_BlockContentFrame) then
        m_BlockContentFrame.MatrixOptionFrame1.SetEnable(false);
      DoStart;
      m_Block.SaveStopedBlock := false;
    end;
  end;
end;

// ------------------------------------------------------------------------------------
function TBlockItemControl.ActionCanStart: Boolean;
begin
  result := false;
  if not Assigned(m_Block) then
    exit;

  if ((m_Block.OrderManager.State = PROCESS_STATE_ENDED_WORK) AND (Not m_Block.SystemManager.State)) then
  begin
    result := true;
  end
  else
  begin
    result := false;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.ActionStop;
begin
  if not Assigned(m_Block) then
    exit;

  if ((m_Block.OrderManager.State = PROCESS_STATE_STARTED_WORK) OR (m_Block.OrderManager.State = PROCESS_STATE_STARTING_WORK) OR (m_Block.OrderManager.State = PROCESS_STATE_DOING_WORK)) then
  begin
    if Assigned(m_BlockContentFrame) then
      m_BlockContentFrame.MatrixOptionFrame1.SetEnable(true);
    DoStop;
  end;
end;

// ------------------------------------------------------------------------------------
function TBlockItemControl.ActionCanStop: Boolean;
begin
  result := false;
  if not Assigned(m_Block) then
    exit;

  if (((m_Block.OrderManager.State = PROCESS_STATE_STARTED_WORK) OR (m_Block.OrderManager.State = PROCESS_STATE_STARTING_WORK) OR (m_Block.OrderManager.State = PROCESS_STATE_DOING_WORK)) AND (m_Block.SystemManager.State) AND (not m_Block.SystemManager.IsLosscut)) then
  begin
    result := true;
  end
  else
  begin
    result := false;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.ActionSaveTradeResult;
begin
  DoSaveTradeResult;
end;

{$REGION '명령어 처리'}

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.GetOption;
begin
  if Assigned(m_BlockContentFrame) then
    m_BlockContentFrame.MatrixOptionFrame1.GetOption;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.DoStart;
var
  f_POTItem: CFNPOTItem;
begin
  if not Assigned(m_Block) then
    exit;
  if m_Block.SystemManager.State then
    exit;
  if m_Block.OrderManager.State <> PROCESS_STATE_ENDED_WORK then
    exit;

  if (m_Block.Option.GetIntegerValue('SYSTEM_MODE') = SYSTEM_MODE_REAL) AND (m_Block.Option.GetStringValue('ACCOUNT_NO') = '') then
  begin
    ShowMessage('계좌의 비밀번호를 설정하여 주십시요.');
    if Assigned(m_BlockContentFrame) then
      m_BlockContentFrame.MatrixOptionFrame1.SetEnable(true);
    exit;
  end;

  Clear;

  if Assigned(g_POTCollection) then
  begin
    f_POTItem := g_POTCollection.Find(m_Block.Option.GetVirtualExchangeDateTime, m_Block.Option.GetIntegerValue('COUNTRY_NO'), m_Block.Option.GetIntegerValue('GROUP_NO'), m_Block.Option.GetIntegerValue('MARKET_NO'), m_Block.Option.GetStringValue('SYMBOL'));

    if Assigned(f_POTItem) then
    begin
      m_Block.Option.m_POTItem.Clone(f_POTItem);
    end;
  end;

  m_Block.SystemManager.Option := m_Block.Option;
  m_Block.SystemManager.BlockName := m_Block.BlockName;
  m_Block.SystemManager.BlockKey := m_Block.BlockKey;

  m_Block.SystemManager.ApplyTSOCollection(m_Block.Option.StrategyOptionCollection);
  m_Block.SystemManager.OnDoneWork := OnSystemManagerDoneWorkEvent;
  m_Block.SystemManager.OnLog := OnLogEvent;

  m_Block.OrderManager.Option := m_Block.Option;
  m_Block.OrderManager.BlockName := m_Block.BlockName;
  m_Block.OrderManager.BlockKey := m_Block.BlockKey;
  m_Block.OrderManager.SymbolString := '';

  m_Block.OrderManager.OnChanged := OnOrderManagerChangedEvent;
  m_Block.OrderManager.OnChangedProfit := OnOrderManagerChangedProfitEvent;
  m_Block.OrderManager.OnEndedWork := OnOrderManagerEndWorkEvent;

  m_Block.OrderManager.OnLog := OnLogEvent;

  m_Block.OrderManager.Start;
  m_Block.SystemManager.Start;

  m_BlockName := m_Block.BlockName;
  m_State := m_Block.OrderManager.State;
  m_OrderSignal := SIGNAL_NONE;
  m_SystemSignal := SIGNAL_NONE;

  m_SDateTime := 0;
  m_SQuote := 0;
  m_SVirtualProfit := 0;
  m_SVirtualProfit_Currency := 0;
  m_SRealProfit := 0;
  m_SRealProfit_Currency := 0;
  m_SPosition := 0;
  m_STradeCount := 0;
  m_SCommission := 0;

  m_ODateTime := 0;
  m_OQuote := 0;
  m_OProfit := 0;
  m_OProfit_Currency := 0;
  m_OPosition := 0;
  m_OTradeCount := 0;

  m_TradeSymbol := m_Block.Option.GetStringValue('TRADESYMBOL');
  m_AccountNo := m_Block.Option.GetStringValue('ACCOUNT_NO');
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.DoStop;
begin
  if not Assigned(m_Block) then
    exit;
  // if not m_Block.SystemManager.State then exit;
  // if m_Block.OrderManager.State <> PROCESS_STATE_DOING_WORK then exit;

  m_Block.SystemManager.StopDelay;
  m_Block.OrderManager.StopDelay;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.DoExitCurrentSignal;
begin
  if not Assigned(m_Block) then
    exit;
  if not m_Block.SystemManager.State then
    exit;
  if m_Block.OrderManager.State <> PROCESS_STATE_DOING_WORK then
    exit;

  m_Block.SystemManager.ExitCurrentSignal;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.DoLosscut;
begin
  m_Block.SystemManager.DoLosscut;
end;
{$ENDREGION}
{$REGION '신호와 주문'}

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.ClearLogInfo;
begin
  if not Assigned(m_Block) then
    exit;
  m_Block.LogCollection.Clear;
  if Assigned(m_UpdateEvent) then
    m_UpdateEvent(Self);
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.ClearOrderManagerInfo;
begin
  if not Assigned(m_Block) then
    exit;
  if Assigned(m_UpdateEvent) then
    m_UpdateEvent(Self);
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.ClearOrderManagerProfit;
begin
  if Assigned(m_UpdateEvent) then
    m_UpdateEvent(Self);
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.DisplayLogInfo;
begin
  if Assigned(m_UpdateEvent) then
    m_UpdateEvent(Self);
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.DisplayOrderManagerProfit;
begin
  if Assigned(m_UpdateEvent) then
    m_UpdateEvent(Self);
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.DisplayOrderManagerInfo;
begin
  if Assigned(m_UpdateEvent) then
    m_UpdateEvent(Self);
end;
{$ENDREGION}
{$REGION '이벤트 처리함수들'}

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.OnOptionChangedEvent(Sender: TObject);
begin
  m_BlockName := m_Block.BlockName;
  m_TradeSymbol := m_Block.Option.GetStringValue('TRADESYMBOL');
  m_AccountNo := m_Block.Option.GetStringValue('ACCOUNT_NO');
  if Assigned(m_UpdateEvent) then
    m_UpdateEvent(Self);
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.OnBlockReadEvent(Sender: TObject);
var
  f_AccountData: CFNAccountData;
  f_Index: Integer;
  f_Success: Boolean;
begin

  f_Success := false;
  for f_Index := 0 to g_AccountArray.m_Items.Count - 1 do
  begin
    f_AccountData := g_AccountArray.m_Items[f_Index];
    if f_AccountData.m_AccountNo = m_Block.Option.GetStringValue('ACCOUNT_NO') then
    begin
      f_Success := true;
      break;
    end;
  end;

  if not f_Success then
  begin
    if g_AccountArray.m_Items.Count > 0 then
    begin
      f_AccountData := g_AccountArray.m_Items[0];
      m_Block.Option.SetStringValue('ACCOUNT_NO', f_AccountData.m_AccountNo);
    end
    else
    begin
      m_Block.Option.SetStringValue('ACCOUNT_NO', '');
    end;
  end;

  m_BlockName := m_Block.BlockName;
  m_State := m_Block.OrderManager.State;
  m_OrderSignal := SIGNAL_NONE;
  m_SystemSignal := SIGNAL_NONE;

  m_SDateTime := 0;
  m_SQuote := 0;
  m_SVirtualProfit := 0;
  m_SVirtualProfit_Currency := 0;
  m_SRealProfit := 0;
  m_SRealProfit_Currency := 0;
  m_SPosition := 0;
  m_STradeCount := 0;
  m_SCommission := 0;

  m_ODateTime := 0;
  m_OQuote := 0;
  m_OProfit := 0;
  m_OProfit_Currency := 0;
  m_OPosition := 0;
  m_OTradeCount := 0;
  m_OCommission := 0;

  m_TradeSymbol := m_Block.Option.GetStringValue('TRADESYMBOL');
  m_AccountNo := m_Block.Option.GetStringValue('ACCOUNT_NO');

  if Assigned(m_UpdateEvent) then
    m_UpdateEvent(Self);
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.OnOrderManagerEndWorkEvent(Sender: TObject);
begin
  SendMessage(Application.MainForm.Handle, WM_BLOCK_STOP_EVENT, 0, 0);
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.OnSystemManagerDoneWorkEvent(Sender: TObject);
begin
  if not Assigned(m_Block) then
    exit;

  if Assigned(m_BlockContentFrame) and Assigned(m_BlockContentFrame.MatrixOptionFrame1) then
  begin
    m_BlockContentFrame.MatrixOptionFrame1.SetEnable(true);
  end;

  m_State := m_Block.OrderManager.State;
  m_OrderSignal := m_Block.OrderManager.LastSignal;

  m_ODateTime := m_Block.OrderManager.LastDate;
  m_OQuote := m_Block.OrderManager.LastPrice;

  m_SPosition := m_Block.OrderManager.SystemPosition;

  m_OProfit := m_Block.OrderManager.Profit;
  m_OProfit_Currency := m_OProfit * m_Block.Option.GetDoubleValue('POINT_VALUE');
  m_OPosition := m_Block.OrderManager.TradePosition;
  m_OTradeCount := m_Block.OrderManager.TradeCount;

  OnChangedSystemManager(Self);

  DisplayOrderManagerInfo;

  m_Block.SystemManager.StopDelay;
  m_Block.OrderManager.StopDelay;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.OnOrderManagerChangedEvent(Sender: TObject);
begin
  m_State := m_Block.OrderManager.State;
  m_OrderSignal := m_Block.OrderManager.LastSignal;

  m_ODateTime := m_Block.OrderManager.LastDate;
  m_OQuote := m_Block.OrderManager.LastPrice;

  m_SPosition := m_Block.OrderManager.SystemPosition;

  m_OProfit := m_Block.OrderManager.Profit;
  m_OProfit_Currency := m_OProfit * m_Block.Option.GetDoubleValue('POINT_VALUE');
  m_OPosition := m_Block.OrderManager.TradePosition;
  m_OTradeCount := m_Block.OrderManager.TradeCount;
  m_OCommission := m_Block.OrderManager.Commission;

  OnChangedSystemManager(Self);

  DisplayOrderManagerInfo;

  if Assigned(m_BlockContentFrame) then
    m_BlockContentFrame.DisplayOrderManagerInfo;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.OnOrderManagerChangedStateEvent(Sender: TObject);
begin
  m_State := m_Block.OrderManager.State;
  m_OrderSignal := m_Block.OrderManager.LastSignal;

  m_ODateTime := m_Block.OrderManager.LastDate;
  m_OQuote := m_Block.OrderManager.LastPrice;

  m_SPosition := m_Block.OrderManager.SystemPosition;

  m_OProfit := m_Block.OrderManager.Profit;
  m_OProfit_Currency := m_OProfit * m_Block.Option.GetDoubleValue('POINT_VALUE');
  m_OPosition := m_Block.OrderManager.TradePosition;
  m_OTradeCount := m_Block.OrderManager.TradeCount;

  OnChangedSystemManager(Self);

  DisplayOrderManagerInfo;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.OnOrderManagerChangedProfitEvent(Sender: TObject);
begin
  m_SPosition := m_Block.OrderManager.SystemPosition;

  m_ODateTime := m_Block.OrderManager.LastDate;
  m_OQuote := m_Block.OrderManager.LastPrice;

  m_OProfit := m_Block.OrderManager.Profit;
  m_OProfit_Currency := m_OProfit * m_Block.Option.GetDoubleValue('POINT_VALUE');
  m_OPosition := m_Block.OrderManager.TradePosition;
  m_OTradeCount := m_Block.OrderManager.TradeCount;

  OnChangedSystemManager(Self);

  DisplayOrderManagerProfit;

  if Assigned(m_BlockContentFrame) then
    m_BlockContentFrame.DisplayOrderManagerProfit;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.OnChangedSystemManager(Sender: TObject);
var
  f_TrafficCollection: CFNTrafficCollection;
  f_TrafficItem: CFNTrafficItem;
  f_Index: Integer;
  f_Value: CFNPMValueItem;
  f_Profit: Double;
  f_ChartData: CMKChartData;
  f_Count: Integer;
begin
  if not Assigned(m_Block) then
    exit;

  m_Block.SystemManager.Lock;
  try
    m_TrafficManager.MakeTradeListBySignalArray(m_Block.SystemManager.m_SignalArray, m_Block.SystemManager.m_RealPrice);
    f_Count := m_Block.SystemManager.m_ChartDataSeries.m_Items.Count;
    if f_Count > 0 then
    begin
      f_ChartData := m_Block.SystemManager.m_ChartDataSeries.m_Items[f_Count - 1];
      m_SDateTime := f_ChartData.m_CloseDateTime;
      m_SQuote := f_ChartData.m_ClosePrice;
    end
    else
    begin
      m_SDateTime := m_Block.Option.GetIntegerValue('STAND_DATE');
      m_SQuote := 0;
    end;
  finally
    m_Block.SystemManager.UnLock;
  end;

  m_TrafficManager.m_AllTrafficCollection.WritePrformance(m_ValueCollection[0]);
  f_TrafficCollection := m_TrafficManager.m_AllTrafficCollection;

  m_SystemSignal := SIGNAL_NONE;
  m_SCommission := 0;
  for f_Index := 0 to f_TrafficCollection.m_Items.Count - 1 do
  begin
    f_TrafficItem := f_TrafficCollection.m_Items[f_Index];
    m_SCommission := m_SCommission + (m_Block.Option.GetDoubleValue('POINT_VALUE') * f_TrafficItem.m_EnterPrice * m_Block.Option.GetIntegerValue('ORDER_COUNT') * m_CommissionRate * 0.01);

    if f_TrafficItem.m_Closed then
    begin
      m_SCommission := m_SCommission + (m_Block.Option.GetDoubleValue('POINT_VALUE') * f_TrafficItem.m_ExitPrice * m_Block.Option.GetIntegerValue('ORDER_COUNT') * m_CommissionRate * 0.01);
    end;

    if (f_Index = (f_TrafficCollection.m_Items.Count - 1)) then
    begin
      if not f_TrafficItem.m_Closed then
      begin
        m_SystemSignal := f_TrafficItem.m_Signal;
      end;
    end;
  end;

  f_Value := m_ValueCollection[0].m_Items[1];
  m_SVirtualProfit := f_Value.m_Value * m_Block.Option.GetIntegerValue('ORDER_COUNT');
  m_SVirtualProfit_Currency := m_SVirtualProfit * m_Block.Option.GetDoubleValue('POINT_VALUE');

  m_SRealProfit := f_Value.m_Value * m_Block.Option.GetIntegerValue('ORDER_COUNT');
  m_SRealProfit_Currency := m_SRealProfit * m_Block.Option.GetDoubleValue('POINT_VALUE');

  m_SPosition := m_Block.OrderManager.SystemPosition;

  f_Value := m_ValueCollection[0].m_Items[2];
  m_STradeCount := Trunc(f_Value.m_Value) * 2;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.OnLogEvent(ASender: TObject; ADateTime: TDateTime; AType: Integer; AMessage, AClassName: String);
var
  f_LogItem: CFNLogItem;
begin
  if not Assigned(m_Block) then
    exit;

  f_LogItem := CFNLogItem.Create;
  f_LogItem.m_DateTime := ADateTime;
  f_LogItem.m_Type := AType;
  f_LogItem.m_Message := AMessage;
  f_LogItem.m_ClassName := AClassName;
  m_Block.LogCollection.m_Items.Insert(0, f_LogItem);

  if Assigned(m_BlockContentFrame) then
    m_BlockContentFrame.DisplayLogInfo;

  if Assigned(OnLog) then
    OnLog(Self, ADateTime, AType, AMessage, AClassName);

end;
{$ENDREGION}
{$REGION '데이터를 저장하는 함수들'}

function TBlockItemControl.GetTradeList: String;
var
  f_Value: String;
  f_ItemIndex: Integer;
  f_SignalItem: CFNSignalItem;
  f_Line: String;
  f_Symbol: String;
begin
  m_Block.OrderManager.CopyAllCollection(m_SignalCollection, m_OrderCollection, m_TradeCollection);
  m_Block.OrderManager.CopyAdjustCollection(m_AdjustCollection);
  DisplayOrderManagerInfo;

  f_Value := '';
  f_Value := m_Block.BlockName + #$D#$A;
  f_Symbol := m_Block.Option.GetStringValue('TRADESYMBOL');

  f_Value := f_Value + '심벌,신호순번,신호날짜,신호시간,신호종류,신호가격,주문시간,주문가격,주문수량,체결가격,체결수량,수익,수익금' + #$D#$A;

  for f_ItemIndex := 0 to m_SignalCollection.m_Items.Count - 1 do
  begin
    f_SignalItem := m_SignalCollection.m_Items[f_ItemIndex];

    f_Line := f_Symbol + ',' + Format('%d', [f_SignalItem.m_SignalSequence]) + ',' + TFNGlobal.DateToString1(f_SignalItem.m_DateTime) + ',' + TFNGlobal.DateTimeToStr6(f_SignalItem.m_DateTime) + ',' + GetSignalText(f_SignalItem.m_Signal) + ',' + Format('%.5f', [f_SignalItem.m_Price]) + ',' + TFNGlobal.DateTimeToStr6(f_SignalItem.m_OrderDateTime) + ',' + Format('%.5f', [f_SignalItem.m_OrderPrice]) + ',' + Format('%d', [f_SignalItem.m_OrderVolume]) + ',' + Format('%.5f', [f_SignalItem.m_TradePrice]) + ',' +
        Format('%d', [f_SignalItem.m_TradeVolume]) + ',' + Format('%.5f', [f_SignalItem.m_Profit]) + ',' + Format('%.2f', [f_SignalItem.m_Profit * m_Block.Option.GetDoubleValue('POINT_VALUE')]) + #$D#$A;

    f_Value := f_Value + f_Line;
  end;

  result := f_Value;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.DoSaveTradeResult;
var
  f_FileName: String;
  f_FilePath: String;
  f_Mode: Word;
  f_FileStream: TFileStream;
  f_TimeString: String;
  f_DesEncoding: TEncoding;
  f_ByteOrderMark: TBytes;
  f_Buffer: TBytes;
  f_ItemIndex: Integer;
  f_SignalItem: CFNSignalItem;
  f_Line: String;
begin
  m_Block.OrderManager.CopyAllCollection(m_SignalCollection, m_OrderCollection, m_TradeCollection);
  m_Block.OrderManager.CopyAdjustCollection(m_AdjustCollection);
  DisplayOrderManagerInfo;

  f_FilePath := ExtractFilePath(ParamStr(0)) + 'trade\';
  if not DirectoryExists(f_FilePath) then
  begin
    CreateDir(f_FilePath);
  end;

  f_TimeString := TFNGlobal.DateTimeToString2(Now, '%04d%02d%02d');
  f_FilePath := f_FilePath + f_TimeString + '\';
  if not DirectoryExists(f_FilePath) then
  begin
    CreateDir(f_FilePath);
  end;

  f_FileName := f_FilePath + m_Block.BlockName + '.csv';
  if Not FileExists(f_FileName) then
  begin
    f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
    f_FileStream := TFileStream.Create(f_FileName, f_Mode);
    if Assigned(f_FileStream) then
    begin
      // UTF-8 변경
      if (f_FileStream.Size <= 0) then
      begin
        f_DesEncoding := TEncoding.UTF8;
        f_ByteOrderMark := f_DesEncoding.GetPreamble;

        f_FileStream.Size := 0;
        f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
      end;
    end;

    f_Line := '신호순번,신호종류,신호시간,신호가격,주문시간,주문가격,주문수량,체결가격,체결수량' + #$D#$A;

    f_Buffer := f_DesEncoding.GetBytes(f_Line);
    f_FileStream.Seek(0, FILE_END);
    f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

    f_FileStream.Free;
    f_FileStream := NIL;
  end;

  if FileExists(f_FileName) then
  begin
    f_Mode := fmOpenReadWrite or fmShareDenyWrite;
  end
  else
  begin
    f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
  end;

  f_DesEncoding := TEncoding.UTF8;
  f_FileStream := TFileStream.Create(f_FileName, f_Mode);
  if Assigned(f_FileStream) then
  begin
    // UTF-8 변경
    if (f_FileStream.Size <= 0) then
    begin
      f_ByteOrderMark := f_DesEncoding.GetPreamble;

      f_FileStream.Size := 0;
      f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
    end;

    for f_ItemIndex := 0 to m_SignalCollection.m_Items.Count - 1 do
    begin
      f_SignalItem := m_SignalCollection.m_Items[f_ItemIndex];

      f_Line := Format('%d', [f_SignalItem.m_SignalSequence]) + ',' + TFNGlobal.DateTimeToStr6(f_SignalItem.m_DateTime) + ',' + GetSignalText(f_SignalItem.m_Signal) + ',' + Format('%.2f', [f_SignalItem.m_Price]) + ',' + TFNGlobal.DateTimeToStr6(f_SignalItem.m_OrderDateTime) + ',' + Format('%.2f', [f_SignalItem.m_OrderPrice]) + ',' + Format('%d', [f_SignalItem.m_OrderVolume]) + ',' + Format('%.2f', [f_SignalItem.m_TradePrice]) + ',' + Format('%d', [f_SignalItem.m_TradeVolume]) + #$D#$A;

      f_Buffer := f_DesEncoding.GetBytes(f_Line);
      f_FileStream.Seek(0, FILE_END);
      f_FileStream.Write(f_Buffer[0], Length(f_Buffer));
    end;

    f_FileStream.Free;
    f_FileStream := NIL;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.DoSaveSignal;
var
  f_TrafficManager: CFNTrafficManager;
  f_TrafficCollection: CFNTrafficCollection;
  f_FileName: String;
  f_FilePath: String;
  f_Mode: Word;
  f_FileStream: TFileStream;
  f_TimeString: String;
  f_DesEncoding: TEncoding;
  f_ByteOrderMark: TBytes;
  f_Buffer: TBytes;
  f_ItemIndex: Integer;
  f_TrafficItem: CFNTrafficItem;
  f_Line: String;
begin

  m_Block.SystemManager.Lock;
  try
    f_TrafficManager := CFNTrafficManager.Create;
    f_TrafficManager.MakeTradeListBySignalArray(m_Block.SystemManager.m_SignalArray, m_Block.SystemManager.m_RealPrice);

    f_TrafficCollection := f_TrafficManager.m_AllTrafficCollection;

    f_FilePath := ExtractFilePath(ParamStr(0)) + 'signal\';
    if not DirectoryExists(f_FilePath) then
    begin
      CreateDir(f_FilePath);
    end;

    f_TimeString := TFNGlobal.DateTimeToString2(m_Block.Option.GetIntegerValue('STAND_DATE'), '%04d%02d%02d');
    f_FilePath := f_FilePath + f_TimeString + '\';
    if not DirectoryExists(f_FilePath) then
    begin
      CreateDir(f_FilePath);
    end;

    f_FileName := f_FilePath + m_Block.BlockName + '.csv';

    f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
    f_FileStream := TFileStream.Create(f_FileName, f_Mode);
    if Assigned(f_FileStream) then
    begin

      if (f_FileStream.Size <= 0) then
      begin
        f_DesEncoding := TEncoding.UTF8;
        f_ByteOrderMark := f_DesEncoding.GetPreamble;

        f_FileStream.Size := 0;
        f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
      end;

      f_Line := '순번,신호종류,진입시간,청산시간,진입가격,청산가격' + #$D#$A;

      f_Buffer := f_DesEncoding.GetBytes(f_Line);
      f_FileStream.Seek(0, FILE_END);
      f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

      for f_ItemIndex := 0 to f_TrafficCollection.m_Items.Count - 1 do
      begin
        f_TrafficItem := f_TrafficCollection.m_Items[f_ItemIndex];

        f_Line := Format('%d', [f_ItemIndex]) + ',' + GetSignalText(f_TrafficItem.m_Signal) + ',' + TFNGlobal.DateTimeToStr4(f_TrafficItem.m_EnterDateTime) + ',' + TFNGlobal.DateTimeToStr4(f_TrafficItem.m_ExitDateTime) + ',' + Format('%.2f', [f_TrafficItem.m_EnterPrice]) + ',' + Format('%.2f', [f_TrafficItem.m_ExitPrice]) + #$D#$A;

        f_Buffer := f_DesEncoding.GetBytes(f_Line);
        f_FileStream.Seek(0, FILE_END);
        f_FileStream.Write(f_Buffer[0], Length(f_Buffer));
      end;

      f_FileStream.Free;
      f_FileStream := NIL;
    end;
  finally
    m_Block.SystemManager.UnLock;
    if Assigned(f_TrafficManager) then
      f_TrafficManager.Free;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TBlockItemControl.DoDumpChartData;
var
  f_FileName: String;
  f_FilePath: String;
  f_Mode: Word;
  f_FileStream: TFileStream;
  f_TimeString: String;
  f_DesEncoding: TEncoding;
  f_ByteOrderMark: TBytes;
  f_Buffer: TBytes;
  f_Line: String;

  f_Index: Integer;
  f_SystemItem: CMXSystemItem;

  f_ChartDataSeries: CMKStreamChartDataSeries;
  f_ChartData: CMKChartData;
  f_RecordIndex: Integer;
begin
  try
    f_FilePath := ExtractFilePath(ParamStr(0)) + 'dump\';
    if not DirectoryExists(f_FilePath) then
    begin
      CreateDir(f_FilePath);
    end;

    f_TimeString := TFNGlobal.DateTimeToString2(m_Block.Option.GetIntegerValue('STAND_DATE'), '%04d%02d%02d');
    f_FilePath := f_FilePath + f_TimeString + '\';
    if not DirectoryExists(f_FilePath) then
    begin
      CreateDir(f_FilePath);
    end;

    for f_Index := 0 to m_Block.SystemManager.m_Items.Count - 1 do
    begin
      f_SystemItem := CMXSystemItem(m_Block.SystemManager.m_Items[f_Index]);

      f_FileName := f_FilePath + m_Block.BlockName + '_' + IntToStr(f_Index) + '.csv';

      f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
      f_FileStream := TFileStream.Create(f_FileName, f_Mode);
      if Assigned(f_FileStream) then
      begin

        if (f_FileStream.Size <= 0) then
        begin
          f_DesEncoding := TEncoding.UTF8;
          f_ByteOrderMark := f_DesEncoding.GetPreamble;

          f_FileStream.Size := 0;
          f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
        end;

        f_Line := '순번,날짜,시간,OPS,선물가격' + #$D#$A;

        f_Buffer := f_DesEncoding.GetBytes(f_Line);
        f_FileStream.Seek(0, FILE_END);
        f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

        f_ChartDataSeries := f_SystemItem.m_ChartDataSeries;

        for f_RecordIndex := 0 to f_ChartDataSeries.m_Items.Count - 1 do
        begin
          f_ChartData := f_ChartDataSeries.m_Items[f_RecordIndex];

          f_Line := Format('%d', [f_RecordIndex]) + ',' + DateToStr(f_ChartData.m_OpenDateTime) + ',' + TFNGlobal.DateTimeToStr6(f_ChartData.m_OpenDateTime) + ',' + Format('%.6f', [f_ChartData.m_OpenPrice]) + ',' + Format('%.2f', [f_ChartData.m_OpenPrice]) + #$D#$A;

          f_Buffer := f_DesEncoding.GetBytes(f_Line);
          f_FileStream.Seek(0, FILE_END);
          f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

        end;

        f_FileStream.Free;
        f_FileStream := NIL;
      end;
    end;

  finally
  end;
end;

{$ENDREGION}
{$ENDREGION}
{$REGION 'TBlockItemControlCollection'}

// ---------------------------------------------------------------------------
constructor TBlockItemControlCollection.Create;
begin

  m_Option := CMXSumaryOption.Create;

  m_Items := TList.Create;

  m_SDateTime := 0;
  m_SQuote := 0;
  m_SVirtualProfit := 0;
  m_SVirtualProfit_Currency := 0;

  m_SRealProfit := 0;
  m_SRealProfit_Currency := 0;
  m_SPosition := 0;
  m_SBuyPosition := 0;
  m_SSellPosition := 0;
  m_STradeCount := 0;
  m_SCommission := 0;

  m_ODateTime := 0;
  m_OQuote := 0;
  m_OProfit := 0;
  m_OProfit_Currency := 0;
  m_OPosition := 0;
  m_OBuyPosition := 0;
  m_OSellPosition := 0;
  m_OTradeCount := 0;

  m_PositionGap := 0;
end;

// ---------------------------------------------------------------------------
destructor TBlockItemControlCollection.Destroy;
begin;
  RemoveAll;
  if Assigned(m_Items) then
  begin
    m_Items.Free;
    m_Items := NIL;
  end;

  if Assigned(m_Option) then
  begin
    m_Option.Free;
    m_Option := NIL;
  end;
end;

// ---------------------------------------------------------------------------
procedure TBlockItemControlCollection.Summary;
var
  f_Index: Integer;
  f_BlockItemView: TBlockItemControl;
begin
  m_SDateTime := 0;
  m_SQuote := 0;
  m_SVirtualProfit := 0;
  m_SVirtualProfit_Currency := 0;
  m_SRealProfit := 0;
  m_SRealProfit_Currency := 0;
  m_SPosition := 0;
  m_SBuyPosition := 0;
  m_SSellPosition := 0;
  m_STradeCount := 0;
  m_SCommission := 0;

  m_ODateTime := 0;
  m_OQuote := 0;
  m_OProfit := 0;
  m_OProfit_Currency := 0;
  m_OPosition := 0;
  m_OBuyPosition := 0;
  m_OSellPosition := 0;
  m_OTradeCount := 0;

  m_PositionGap := 0;

  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_BlockItemView := m_Items[f_Index];

    if f_BlockItemView.m_SDateTime <> 0 then
      m_SDateTime := f_BlockItemView.m_SDateTime;
    if f_BlockItemView.m_SQuote <> 0 then
      m_SQuote := f_BlockItemView.m_SQuote;

    m_SVirtualProfit := m_SVirtualProfit + f_BlockItemView.m_SVirtualProfit;
    m_SVirtualProfit_Currency := m_SVirtualProfit_Currency + f_BlockItemView.m_SVirtualProfit_Currency;
    m_SRealProfit := m_SRealProfit + f_BlockItemView.m_SVirtualProfit;
    m_SRealProfit_Currency := m_SRealProfit_Currency + f_BlockItemView.m_SRealProfit_Currency;

    m_SPosition := m_SPosition + f_BlockItemView.m_SPosition;
    m_STradeCount := m_STradeCount + f_BlockItemView.m_STradeCount;
    m_SCommission := m_SCommission + f_BlockItemView.m_SCommission;

    if f_BlockItemView.m_SPosition > 0 then
    begin
      m_SBuyPosition := m_SBuyPosition + abs(f_BlockItemView.m_SPosition);
    end
    else if f_BlockItemView.m_SPosition < 0 then
    begin
      m_SSellPosition := m_SSellPosition - abs(f_BlockItemView.m_SPosition);
    end;

    if f_Index = 0 then
    begin
      if f_BlockItemView.m_ODateTime <> 0 then
        m_ODateTime := f_BlockItemView.m_ODateTime;
      if f_BlockItemView.m_OQuote <> 0 then
        m_OQuote := f_BlockItemView.m_OQuote;
    end;

    m_OProfit := m_OProfit + f_BlockItemView.m_OProfit;
    m_OProfit_Currency := m_OProfit_Currency + f_BlockItemView.m_OProfit_Currency;
    m_OPosition := m_OPosition + f_BlockItemView.m_OPosition;
    m_OTradeCount := m_OTradeCount + f_BlockItemView.m_OTradeCount;

    if f_BlockItemView.m_OPosition > 0 then
    begin
      m_OBuyPosition := m_OBuyPosition + abs(f_BlockItemView.m_OPosition);
    end
    else if f_BlockItemView.m_OPosition < 0 then
    begin
      m_OSellPosition := m_OSellPosition - abs(f_BlockItemView.m_OPosition);
    end;

    m_PositionGap := m_PositionGap + abs(f_BlockItemView.m_SPosition - f_BlockItemView.m_OPosition);
  end;

end;

// ---------------------------------------------------------------------------
procedure TBlockItemControlCollection.DoLosscut;
var
  f_Index: Integer;
  f_BlockItemView: TBlockItemControl;
begin
  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_BlockItemView := m_Items[f_Index];
    f_BlockItemView.m_Block.SystemManager.DoLosscut;

  end;

end;

// ---------------------------------------------------------------------------
procedure TBlockItemControlCollection.Add(ABlockItemControl: TBlockItemControl);
begin
  m_Items.Add(ABlockItemControl);
end;

// ---------------------------------------------------------------------------
procedure TBlockItemControlCollection.RemoveAll;
var
  f_BlockItemView: TBlockItemControl;
begin

  if Assigned(m_Items) then
  begin
    while m_Items.Count > 0 do
    begin
      f_BlockItemView := TBlockItemControl(m_Items[0]);
      m_Items.Delete(0);
      f_BlockItemView.Free;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure TBlockItemControlCollection.Delete(ABlockItemControl: TBlockItemControl);
var
  f_Index: Integer;
  f_BlockItemView: TBlockItemControl;
begin
  f_Index := m_Items.IndexOf(ABlockItemControl);
  if f_Index >= 0 then
  begin
    f_BlockItemView := m_Items[f_Index];
    m_Items.Delete(f_Index);
    f_BlockItemView.Free;
  end;
end;

// ---------------------------------------------------------------------------
procedure TBlockItemControlCollection.CheckBlockName;
var
  LIndex1, LIndex2: Integer;
  LBlockItemView1: TBlockItemControl;
  LBlockItemView2: TBlockItemControl;
begin
  for LIndex1 := 0 to m_Items.Count - 1 do
  begin
    LBlockItemView1 := m_Items[LIndex1];
    for LIndex2 := LIndex1+1 to m_Items.Count - 1 do
    begin
      LBlockItemView2 := m_Items[LIndex2];
      if LBlockItemView1.Block.BlockName = LBlockItemView2.Block.BlockName then
      begin
        LBlockItemView2.Block.BlockName := LBlockItemView2.Block.BlockName + '-' + IntToStr(LIndex2);
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure TBlockItemControlCollection.Prepare;
var
  LIndex: Integer;
  LBlockItemView: TBlockItemControl;
  f_SymbolIndex1: Integer;
  f_SymbolIndex2: Integer;
begin
  m_SDateTime := 0;
  m_SQuote := 0;
  m_SVirtualProfit := 0;
  m_SVirtualProfit_Currency := 0;
  m_SRealProfit := 0;
  m_SRealProfit_Currency := 0;
  m_SPosition := 0;
  m_SBuyPosition := 0;
  m_SSellPosition := 0;
  m_STradeCount := 0;
  m_SCommission := 0;

  m_ODateTime := 0;
  m_OQuote := 0;
  m_OProfit := 0;
  m_OProfit_Currency := 0;
  m_OPosition := 0;
  m_OBuyPosition := 0;
  m_OSellPosition := 0;
  m_OTradeCount := 0;

  m_PositionGap := 0;

  CheckBlockName;

  for LIndex := 0 to m_Items.Count - 1 do
  begin
    LBlockItemView := m_Items[LIndex];

    LBlockItemView.Block.SystemManager.BlockName := LBlockItemView.Block.BlockName;
    LBlockItemView.Block.OrderManager.BlockName := LBlockItemView.Block.BlockName;

    LBlockItemView.Block.Option.SetStringValue('TRADESESSION_KEY', SummaryOption.GetStringValue('TRADESESSION_KEY'));
    LBlockItemView.Block.Option.SetStringValue('LEADER_SESSION', SummaryOption.GetStringValue('LEADER_SESSION'));
    LBlockItemView.Block.Option.SetStringValue('ACCOUNT_NO', SummaryOption.GetStringValue('ACCOUNT_NO'));
    LBlockItemView.Block.Option.SetStringValue('ACCOUNT_PW', SummaryOption.GetStringValue('ACCOUNT_PW'));
    LBlockItemView.Block.Option.SetIntegerValue('SYSTEM_MODE', SummaryOption.GetIntegerValue('SYSTEM_MODE'));
    LBlockItemView.Block.Option.SetBooleanValue('MIRROR_TRADE', SummaryOption.GetBooleanValue('MIRROR_TRADE'));
  end;
end;

// ---------------------------------------------------------------------------
function TBlockItemControl_Compare(Item1, Item2: Pointer): Integer;
var
  f_Item1: TBlockItemControl;
  f_Item2: TBlockItemControl;
begin
  f_Item1 := TBlockItemControl(Item1);
  f_Item2 := TBlockItemControl(Item2);

  result := AnsiCompareStr(f_Item1.Block.BlockName, f_Item2.Block.BlockName);
end;

// ---------------------------------------------------------------------------
procedure TBlockItemControlCollection.Sort;
begin
  m_Items.Sort(@TBlockItemControl_Compare);
end;

{$ENDREGION}
{$ENDREGION}

end.
