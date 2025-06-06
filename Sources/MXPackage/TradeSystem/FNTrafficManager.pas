unit FNTrafficManager;

interface

uses
  Math, Windows, SysUtils, Classes, FNTradeSystem, MXOption;

type
  CFNTrafficItem = class;
  CFNTrafficCollection = class;

  CFNPMValueItem = class;
  CFNPMValueCollection = class;

  // ---------------------------------------------------------------------------
  CFNTrafficItem = class(TObject)
  public
    m_Signal: Integer; // 매매신호
    m_Closed: Boolean; // 청산이 되었나?

    m_EnterIndex: Integer; // 바의 번호
    m_EnterDateTime: TDateTime; // 날짜와시간
    m_EnterPrice: Double; // 진입가격
    m_EnterCount: Integer; // 진입수량
    m_EnterValue: Double; // 진입금액

    m_ExitIndex: Integer; // 바의 번호
    m_ExitDateTime: TDateTime; // 날짜와시간
    m_ExitPrice: Double; // 청산가격
    m_ExitCount: Integer; // 청산수량
    m_ExitValue: Double; // 청산금액

    m_Profit: Double; // 수익
    m_ProfitRatio: Double; // 수익률
    m_Cumulative: Double; // 누적수익
    m_SumProfitRatio: Double; // 수익률
    m_AvgProfitRatio: Double; // 수익률
    m_DrawDown: Double;

    m_Enable: Boolean;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clone(ASource: CFNTrafficItem);
    procedure CopyEnter(ASource: CFNSignalData);
    procedure CopyExit(ASource: CFNSignalData);

    procedure CopyEnterBySignalItem(ASource: CFNSignalItem);
    procedure CopyExitBySignalItem(ASource: CFNSignalItem);
  end;

  // ---------------------------------------------------------------------------
  CFNTrafficCollection = class(TObject)
  public
    m_Items: TList;
    m_NetProfit: Double; // 순이익
    m_GrossProfit: Double; // 총이익
    m_GrossLoss: Double; // 총손실
    m_NumberOfTrades: Integer; // 전체거래수
    m_NumberOfWinningTrades: Integer; // 이익거래수
    m_NumberOfLosingTrades: Integer; // 손실거래수
    m_PercentProfitable: Double; // 이익거래수/손실거래수
    m_LargestWinningTrade: Double; // 최대 이익거래 금액
    m_LargestLosingTrade: Double; // 최대 손실거래 금액
    m_AverageWinningTrade: Double; // 평균 이익거래 금액
    m_AverageLosingTrade: Double; // 평균 손실거래 금액
    m_RatioAvgWinAvgLoss: Double; // 평균 이익거래 금액/평균 손실거래 금액
    m_AvgTrade: Double; // 순이익/전체거래수
    m_MaxConsecWinners: Integer; // 최대연속이익거래수
    m_MaxConsecLosers: Integer; // 최대연속손실거래수
    m_AvgBarsWinners: Integer; // 이익거래의 평균 바수
    m_AvgBarsLosers: Integer; // 손실거래의 평균 바수
    m_MaxDrawdown: Double; // 순이익의 최대삭감금액
    m_AccountSizeRequired: Double; // 필요한 거래금액
    m_ProfitFactor: Double; // 총이익/총손실
    m_ReturnAccount: Double; // 결과
    m_ProfitRatio: Double; // 수익율

  public
    constructor Create;
    destructor Destroy; override;

  public
    procedure Clear;
    procedure Clone(ASource: CFNTrafficCollection);
    procedure Add(ATrafficItem: CFNTrafficItem);

    procedure MakePerformance(AClosePrice: Double = 0);

    procedure MakePerformanceOfBacktesting(AOption: CMXOption; AClosePrice: Double = 0);

    procedure WriteReport(AStringArray: TStrings);
    procedure WritePrformance(AValueArray: CFNPMValueCollection);
  end;

  // ---------------------------------------------------------------------------
  CFNPMValueItem = class(TObject)
  public
    m_Name: String;
    m_Value: Double;
    m_Precision: Integer;
    m_Unit: String;
    m_SignColor: Boolean;

  public
    constructor Create;
  end;

  // ---------------------------------------------------------------------------
  CFNPMValueCollection = class(TObject)
  public
    m_Items: TList;

    constructor Create;
    destructor Destroy; override;

  public
    procedure Clear;
    procedure Add(p_Value: CFNPMValueItem);
  end;

  // ---------------------------------------------------------------------------
  CFNTrafficManager = class(TObject)
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

  public
    m_LongTrafficCollection: CFNTrafficCollection;
    m_ShortTrafficCollection: CFNTrafficCollection;
    m_AllTrafficCollection: CFNTrafficCollection;

    procedure MakeTradeListBySignalArray(ASignalArray: CFNSignalArray; AClosePrice: Double = 0);
    procedure MakeTradeListBySignalCollection(ASignalCollection: CFNSignalCollection; AClosePrice: Double = 0);

    (*
      procedure MakeTradeListOfBacktesting
      (
      AOption:CFNOPSOption;
      ASignalArray:CFNSignalArray;
      AClosePrice:Double=0
      );
    *)
    procedure MakeTradeListOfBacktesting(AOption: CMXOption; ASignalArray: CFNSignalArray; AClosePrice: Double = 0);
  end;

  // ---------------------------------------------------------------------------
  CFNNAVDataItem = class(TObject)
  public
    m_DateTime: TDateTime;
    m_Asset: Double;
  public
    constructor Create;
  end;

  // ---------------------------------------------------------------------------
  CFNNAVDataCollection = class(TObject)
  public
    m_Items: TList;

    constructor Create;
    destructor Destroy; override;

  public
    procedure Clear;
    procedure Add(p_Value: CFNNAVDataItem);
    function SearchIndex(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
  end;

  // ---------------------------------------------------------------------------
  CFNDailyPMValueItem = class(TObject)
  public
    m_Date: TDateTime;

    m_TProfit: Double;
    m_BProfit: Double;
    m_SProfit: Double;

    m_TProfitSum: Double;
    m_BProfitSum: Double;
    m_SProfitSum: Double;

    m_TNumberOfTrades: Double;
    m_BNumberOfTrades: Double;
    m_SNumberOfTrades: Double;
    m_Price: Double;

  public
    constructor Create;

  end;

  // ---------------------------------------------------------------------------
  CFNDailyPMValueCollection = class(TObject)
  public
    m_Items: TList;

    constructor Create;
    destructor Destroy; override;
  private
    function Search(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;

  public
    procedure Clear;
    procedure Add(p_Value: CFNDailyPMValueItem);
    procedure Add2(p_Value: CFNDailyPMValueItem);
  end;
  // ---------------------------------------------------------------------------

implementation

uses
  FNGlobal, FNCMVariable;

{$REGION 'CFNTrafficItem'}

// ---------------------------------------------------------------------------
constructor CFNTrafficItem.Create;
begin
  inherited Create;

  m_Closed := false;
  m_Enable := true;
end;

// ---------------------------------------------------------------------------
destructor CFNTrafficItem.Destroy;
begin
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNTrafficItem.Clone(ASource: CFNTrafficItem);
begin
  m_Signal := ASource.m_Signal;
  m_EnterIndex := ASource.m_EnterIndex;
  m_EnterDateTime := ASource.m_EnterDateTime;
  m_EnterPrice := ASource.m_EnterPrice;
  m_EnterCount := ASource.m_EnterCount;
  m_EnterValue := ASource.m_EnterValue;

  m_ExitIndex := ASource.m_ExitIndex;
  m_ExitDateTime := ASource.m_ExitDateTime;
  m_ExitPrice := ASource.m_ExitPrice;
  m_ExitCount := ASource.m_ExitCount;
  m_ExitValue := ASource.m_ExitValue;

  m_Profit := ASource.m_Profit;
  m_ProfitRatio := ASource.m_ProfitRatio;
  m_Cumulative := ASource.m_Cumulative;
  m_SumProfitRatio := ASource.m_SumProfitRatio;
  m_AvgProfitRatio := ASource.m_AvgProfitRatio;
  m_DrawDown := ASource.m_DrawDown;
end;

// ---------------------------------------------------------------------------
procedure CFNTrafficItem.CopyEnter(ASource: CFNSignalData);
begin
  m_Signal := ASource.m_Signal;
  m_EnterIndex := ASource.m_Index;
  m_EnterDateTime := ASource.m_DateTime;
  m_EnterPrice := ASource.m_Price;
  m_EnterCount := 1;
  m_EnterValue := m_EnterPrice;
end;

// ---------------------------------------------------------------------------
procedure CFNTrafficItem.CopyExit(ASource: CFNSignalData);
begin
  m_ExitIndex := ASource.m_Index;
  m_ExitDateTime := ASource.m_DateTime;
  m_ExitPrice := ASource.m_Price;
  m_ExitCount := 1;
  m_ExitValue := m_ExitPrice;
end;

// ---------------------------------------------------------------------------
procedure CFNTrafficItem.CopyEnterBySignalItem(ASource: CFNSignalItem);
begin
  m_Signal := ASource.m_CorrectSignal;
  m_EnterIndex := ASource.m_BarIndex;
  m_EnterDateTime := ASource.m_DateTime;
  m_EnterPrice := ASource.m_TradePriceOfProfit;
  m_EnterCount := ASource.m_TradeVolumeOfProfit;
  m_EnterValue := ASource.m_TradeValue;
end;

// ---------------------------------------------------------------------------
procedure CFNTrafficItem.CopyExitBySignalItem(ASource: CFNSignalItem);
begin
  m_ExitIndex := ASource.m_BarIndex;
  m_ExitDateTime := ASource.m_DateTime;
  m_ExitPrice := ASource.m_TradePriceOfProfit;
  m_ExitCount := ASource.m_TradeVolumeOfProfit;
  m_ExitValue := ASource.m_TradeValue;
end;
{$ENDREGION}
{$REGION 'CFNTrafficCollection'}

// ---------------------------------------------------------------------------
constructor CFNTrafficCollection.Create;
begin
  inherited Create;

  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CFNTrafficCollection.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 배열의 구성요소를 모두 삭제한다.
procedure CFNTrafficCollection.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNTrafficItem(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;

  m_NetProfit := 0;
  m_GrossProfit := 0;
  m_GrossLoss := 0;
  m_NumberOfTrades := 0;
  m_NumberOfWinningTrades := 0;
  m_NumberOfLosingTrades := 0;
  m_PercentProfitable := 0;
  m_LargestWinningTrade := 0;
  m_LargestLosingTrade := 0;
  m_AverageWinningTrade := 0;
  m_AverageLosingTrade := 0;
  m_RatioAvgWinAvgLoss := 0;
  m_AvgTrade := 0;
  m_MaxConsecWinners := 0;
  m_MaxConsecLosers := 0;
  m_AvgBarsWinners := 0;
  m_AvgBarsLosers := 0;
  m_MaxDrawdown := 0;
  m_AccountSizeRequired := 0;
  m_ProfitFactor := 0;
  m_ReturnAccount := 0;
  m_ProfitRatio := 0;
end;

// ---------------------------------------------------------------------------
// 하나를 추가한다.
procedure CFNTrafficCollection.Add(ATrafficItem: CFNTrafficItem);
begin
  m_Items.Add(ATrafficItem);
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하여 복제한다.
procedure CFNTrafficCollection.Clone(ASource: CFNTrafficCollection);
var
  f_OldTrafficItem: CFNTrafficItem;
  f_NewTrafficItem: CFNTrafficItem;
  f_Index: Integer;
begin
  Clear;
  for f_Index := 0 to ASource.m_Items.Count - 1 do
  begin
    f_OldTrafficItem := CFNTrafficItem(ASource.m_Items.Items[f_Index]);
    f_NewTrafficItem := CFNTrafficItem.Create;
    f_NewTrafficItem.Clone(f_OldTrafficItem);
    m_Items.Add(f_NewTrafficItem);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNTrafficCollection.MakePerformance(AClosePrice: Double = 0);
var
  f_TrafficItem: CFNTrafficItem;
  f_Index: Integer;
  f_Profit: Double;
  f_ConsecWinners: Integer;
  f_ConsecLosers: Integer;
  f_TotalDaysWinners: Integer;
  f_TotalDaysLosers: Integer;
  f_Cumulative: Double;
  f_MaxCumulative: Double;
  f_Drawdown: Double;
  f_SumProfitRatio: Double;
  f_SumPrice: Double;
begin
  m_ProfitRatio := 0;
  m_GrossProfit := 0;
  m_GrossLoss := 0;

  m_NumberOfTrades := 0;
  m_NumberOfWinningTrades := 0;
  m_NumberOfLosingTrades := 0;

  m_LargestWinningTrade := 0;
  m_LargestLosingTrade := 0;

  m_MaxConsecWinners := 0;
  m_MaxConsecLosers := 0;

  m_MaxDrawdown := 0;

  f_TotalDaysWinners := 0;
  f_TotalDaysLosers := 0;

  f_ConsecWinners := 0;
  f_ConsecLosers := 0;

  f_Cumulative := 0;
  f_MaxCumulative := 0;

  f_SumProfitRatio := 0;
  f_SumPrice := 0;

  try
    for f_Index := 0 to m_Items.Count - 1 do
    begin
      f_TrafficItem := m_Items[f_Index];
      f_TrafficItem.m_Enable := true;

      if not f_TrafficItem.m_Closed then
      begin
        f_TrafficItem.m_ExitCount := f_TrafficItem.m_EnterCount;
        f_TrafficItem.m_ExitPrice := AClosePrice;
        if f_TrafficItem.m_ExitPrice = 0 then
        begin
          f_TrafficItem.m_ExitPrice := f_TrafficItem.m_EnterPrice;
        end;

        f_TrafficItem.m_ExitValue := f_TrafficItem.m_ExitPrice * f_TrafficItem.m_ExitCount;
      end;

      if (f_TrafficItem.m_Signal = SIGNAL_BUY_ENTER) then
      begin
        f_Profit := f_TrafficItem.m_ExitValue - f_TrafficItem.m_EnterValue;
      end
      else if (f_TrafficItem.m_Signal = SIGNAL_SELL_ENTER) then
      begin
        f_Profit := f_TrafficItem.m_EnterValue - f_TrafficItem.m_ExitValue;
      end
      else
      begin
        f_Profit := 0;
      end;

      if (f_Profit > 0) then
      begin
        m_GrossProfit := m_GrossProfit + f_Profit;
        Inc(m_NumberOfWinningTrades);

        if (f_Profit > m_LargestWinningTrade) then
          m_LargestWinningTrade := f_Profit;
        Inc(f_ConsecWinners);

        if (f_ConsecWinners > m_MaxConsecWinners) then
          m_MaxConsecWinners := f_ConsecWinners;
        f_TotalDaysWinners := f_TotalDaysWinners + (f_TrafficItem.m_ExitIndex - f_TrafficItem.m_EnterIndex + 1);

        f_ConsecLosers := 0;
      end
      else if (f_Profit < 0) then
      begin
        m_GrossLoss := m_GrossLoss + f_Profit;
        Inc(m_NumberOfLosingTrades);

        if (f_Profit < m_LargestLosingTrade) then
          m_LargestLosingTrade := f_Profit;
        Inc(f_ConsecLosers);

        if (f_ConsecLosers > m_MaxConsecLosers) then
          m_MaxConsecLosers := f_ConsecLosers;
        f_TotalDaysLosers := f_TotalDaysLosers + (f_TrafficItem.m_ExitIndex - f_TrafficItem.m_EnterIndex + 1);

        f_ConsecWinners := 0;
      end;

      f_Cumulative := m_GrossProfit + m_GrossLoss;

      f_Drawdown := f_Cumulative - f_MaxCumulative;

      // 최대 순이익 삭감액 계산
      if (f_Drawdown < m_MaxDrawdown) then
      begin
        m_MaxDrawdown := f_Drawdown;
      end;

      if (f_Cumulative > f_MaxCumulative) then
        f_MaxCumulative := f_Cumulative;

      f_SumPrice := f_SumPrice + f_TrafficItem.m_EnterPrice;
      f_TrafficItem.m_Profit := f_Profit;
      f_TrafficItem.m_Cumulative := m_GrossProfit + m_GrossLoss;
      if f_TrafficItem.m_EnterPrice <> 0 then
      begin
        f_TrafficItem.m_ProfitRatio := f_TrafficItem.m_Profit * 100.0 / f_TrafficItem.m_EnterPrice;
      end
      else
      begin
        f_TrafficItem.m_ProfitRatio := 0;
      end;

      f_SumProfitRatio := f_SumProfitRatio + f_TrafficItem.m_ProfitRatio;
      f_TrafficItem.m_SumProfitRatio := f_SumProfitRatio;
      Inc(m_NumberOfTrades);

      if (m_NumberOfTrades <> 0) and (f_SumPrice <> 0) then
      begin
        f_TrafficItem.m_AvgProfitRatio := f_TrafficItem.m_Cumulative * 100.0 / (f_SumPrice / m_NumberOfTrades);
      end
      else
      begin
        f_TrafficItem.m_AvgProfitRatio := 0;
      end;
      m_ProfitRatio := f_TrafficItem.m_AvgProfitRatio;
    end;

    m_NetProfit := m_GrossProfit + m_GrossLoss;

    if (m_NumberOfTrades <> 0) then
    begin
      m_PercentProfitable := (m_NumberOfWinningTrades / m_NumberOfTrades) * 100.0;
      m_AvgTrade := m_NetProfit / m_NumberOfTrades;
    end
    else
    begin
      m_PercentProfitable := 0;
      m_AvgTrade := 0;
    end;

    if (m_NumberOfWinningTrades <> 0) then
    begin
      m_AverageWinningTrade := m_GrossProfit / m_NumberOfWinningTrades;
      m_AvgBarsWinners := Round(f_TotalDaysWinners / m_NumberOfWinningTrades);
    end
    else
    begin
      m_AverageWinningTrade := 0;
      m_AvgBarsWinners := 0;
    end;

    if (m_NumberOfLosingTrades <> 0) then
    begin
      m_AverageLosingTrade := m_GrossLoss / m_NumberOfLosingTrades;
      m_AvgBarsLosers := Round(f_TotalDaysLosers / m_NumberOfLosingTrades);
    end
    else
    begin
      m_AverageLosingTrade := 0;
      m_AvgBarsWinners := 0;
    end;

    if (m_AverageLosingTrade <> 0) then
    begin
      m_RatioAvgWinAvgLoss := abs(m_AverageWinningTrade / m_AverageLosingTrade);
    end
    else
    begin
      m_RatioAvgWinAvgLoss := 0;
    end;

    if (m_GrossLoss <> 0) then
    begin
      m_ProfitFactor := abs(m_GrossProfit / m_GrossLoss);
    end
    else
    begin
      m_ProfitFactor := 0;
    end;

    m_AccountSizeRequired := abs(m_MaxDrawdown);

    if (m_AccountSizeRequired <> 0) then
    begin
      m_ReturnAccount := (m_NetProfit / m_AccountSizeRequired) * 100.0;
    end
    else
    begin
      m_ReturnAccount := 0;
    end;

  finally

  end;
end;

(*
  procedure CFNTrafficCollection.MakePerformanceOfBacktesting(AOption: CFNOPSOption; AClosePrice: Double);
  var
  f_TrafficItem:CFNTrafficItem;
  f_Index:Integer;
  f_Profit:Double;
  f_ConsecWinners:Integer;
  f_ConsecLosers:Integer;
  f_TotalDaysWinners:Integer;
  f_TotalDaysLosers:Integer;
  f_Cumulative:Double;
  f_MaxCumulative:Double;
  f_Drawdown:Double;
  f_SumProfitRatio:Double;
  f_SumPrice:Double;
  begin
  m_ProfitRatio := 0;
  m_GrossProfit := 0;
  m_GrossLoss := 0;

  m_NumberOfTrades := 0;
  m_NumberOfWinningTrades := 0;
  m_NumberOfLosingTrades := 0;

  m_LargestWinningTrade := 0;
  m_LargestLosingTrade := 0;

  m_MaxConsecWinners := 0;
  m_MaxConsecLosers := 0;

  m_MaxDrawdown := 0;

  f_TotalDaysWinners := 0;
  f_TotalDaysLosers := 0;

  f_ConsecWinners := 0;
  f_ConsecLosers := 0;

  f_Cumulative := 0;
  f_MaxCumulative := 0;

  f_SumProfitRatio := 0;
  f_SumPrice := 0;

  try
  for f_Index := 0 to m_Items.Count - 1 do
  begin
  f_TrafficItem := m_Items[f_Index];
  f_TrafficItem.m_Enable := false;

  if AOption.m_ScanLongTrade then
  begin
  if (f_TrafficItem.m_Signal = SIGNAL_BUY_ENTER) then
  begin
  f_TrafficItem.m_Enable := true;
  end;
  end;

  if AOption.m_ScanShortTrade then
  begin
  if (f_TrafficItem.m_Signal = SIGNAL_SELL_ENTER) then
  begin
  f_TrafficItem.m_Enable := true;
  end;
  end;
  end;

  for f_Index := 0 to m_Items.Count - 1 do
  begin
  f_TrafficItem := m_Items[f_Index];

  if (not f_TrafficItem.m_Enable) then
  begin
  f_TrafficItem.m_Profit            := 0;
  f_TrafficItem.m_ProfitRatio       := 0;
  f_TrafficItem.m_Cumulative        := 0;
  f_TrafficItem.m_SumProfitRatio    := 0;
  f_TrafficItem.m_AvgProfitRatio    := 0;
  f_TrafficItem.m_DrawDown          := 0;

  continue;
  end;


  if not f_TrafficItem.m_Closed then
  begin
  f_TrafficItem.m_ExitCount := f_TrafficItem.m_EnterCount;
  f_TrafficItem.m_ExitPrice := AClosePrice;

  if f_TrafficItem.m_ExitPrice = 0 then
  begin
  f_TrafficItem.m_ExitPrice := f_TrafficItem.m_EnterPrice;
  end;

  f_TrafficItem.m_ExitValue := f_TrafficItem.m_ExitPrice * f_TrafficItem.m_ExitCount;
  end;

  if (f_TrafficItem.m_Signal = SIGNAL_BUY_ENTER) then
  begin
  f_Profit := f_TrafficItem.m_ExitValue - f_TrafficItem.m_EnterValue;
  end else
  if (f_TrafficItem.m_Signal = SIGNAL_SELL_ENTER) then
  begin
  f_Profit := f_TrafficItem.m_EnterValue - f_TrafficItem.m_ExitValue;
  end else
  begin
  f_Profit := 0;
  end;

  if (f_Profit > 0) then
  begin
  m_GrossProfit := m_GrossProfit + f_Profit;
  Inc(m_NumberOfWinningTrades);

  if (f_Profit > m_LargestWinningTrade) then m_LargestWinningTrade := f_Profit;
  Inc(f_ConsecWinners);

  if (f_ConsecWinners > m_MaxConsecWinners) then m_MaxConsecWinners := f_ConsecWinners;
  f_TotalDaysWinners := f_TotalDaysWinners + (f_TrafficItem.m_ExitIndex - f_TrafficItem.m_EnterIndex + 1);

  f_ConsecLosers := 0;
  end else
  if (f_Profit < 0) then
  begin
  m_GrossLoss := m_GrossLoss + f_Profit;
  Inc(m_NumberOfLosingTrades);

  if (f_Profit < m_LargestLosingTrade) then m_LargestLosingTrade := f_Profit;
  Inc(f_ConsecLosers);

  if (f_ConsecLosers > m_MaxConsecLosers) then m_MaxConsecLosers := f_ConsecLosers;
  f_TotalDaysLosers := f_TotalDaysLosers + (f_TrafficItem.m_ExitIndex - f_TrafficItem.m_EnterIndex + 1);

  f_ConsecWinners := 0;
  end;

  f_Cumulative := m_GrossProfit + m_GrossLoss;

  f_Drawdown := f_Cumulative - f_MaxCumulative;

  // 최대 순이익 삭감액 계산
  if (f_Drawdown < m_MaxDrawdown) then
  begin
  m_MaxDrawdown := f_Drawdown;
  end;

  if (f_Cumulative > f_MaxCumulative) then f_MaxCumulative := f_Cumulative;

  f_SumPrice := f_SumPrice + f_TrafficItem.m_EnterPrice;
  f_TrafficItem.m_Profit := f_Profit;
  f_TrafficItem.m_Cumulative := m_GrossProfit + m_GrossLoss;
  if f_TrafficItem.m_EnterPrice <> 0 then
  begin
  f_TrafficItem.m_ProfitRatio := f_TrafficItem.m_Profit * 100.0 / f_TrafficItem.m_EnterPrice;
  end else
  begin
  f_TrafficItem.m_ProfitRatio := 0;
  end;

  f_SumProfitRatio := f_SumProfitRatio + f_TrafficItem.m_ProfitRatio;
  f_TrafficItem.m_SumProfitRatio := f_SumProfitRatio;
  Inc(m_NumberOfTrades);

  if (m_NumberOfTrades <> 0) and (f_SumPrice <> 0) then
  begin
  f_TrafficItem.m_AvgProfitRatio := f_TrafficItem.m_Cumulative * 100.0 / (f_SumPrice / m_NumberOfTrades);
  end else
  begin
  f_TrafficItem.m_AvgProfitRatio := 0;
  end;
  m_ProfitRatio := f_TrafficItem.m_AvgProfitRatio;

  end;

  m_NetProfit := m_GrossProfit + m_GrossLoss;

  if (m_NumberOfTrades <> 0) then
  begin
  m_PercentProfitable := (m_NumberOfWinningTrades / m_NumberOfTrades) * 100.0;
  m_AvgTrade := m_NetProfit / m_NumberOfTrades;
  end else
  begin
  m_PercentProfitable := 0;
  m_AvgTrade := 0;
  end;

  if (m_NumberOfWinningTrades <> 0) then
  begin
  m_AverageWinningTrade := m_GrossProfit / m_NumberOfWinningTrades;
  m_AvgBarsWinners := Round(f_TotalDaysWinners / m_NumberOfWinningTrades);
  end else
  begin
  m_AverageWinningTrade := 0;
  m_AvgBarsWinners := 0;
  end;

  if (m_NumberOfLosingTrades <> 0) then
  begin
  m_AverageLosingTrade :=  m_GrossLoss / m_NumberOfLosingTrades;
  m_AvgBarsLosers := Round(f_TotalDaysLosers / m_NumberOfLosingTrades);
  end else
  begin
  m_AverageLosingTrade := 0;
  m_AvgBarsWinners := 0;
  end;

  if (m_AverageLosingTrade <> 0) then
  begin
  m_RatioAvgWinAvgLoss := abs(m_AverageWinningTrade / m_AverageLosingTrade);
  end else
  begin
  m_RatioAvgWinAvgLoss := 0;
  end;

  if (m_GrossLoss <> 0) then
  begin
  m_ProfitFactor := abs(m_GrossProfit / m_GrossLoss);
  end else
  begin
  m_ProfitFactor := 0;
  end;

  m_AccountSizeRequired := abs(m_MaxDrawdown);

  if (m_AccountSizeRequired <> 0) then
  begin
  m_ReturnAccount := (m_NetProfit / m_AccountSizeRequired) * 100.0;
  end else
  begin
  m_ReturnAccount := 0;
  end;

  finally
  end;
  end;
*)
procedure CFNTrafficCollection.MakePerformanceOfBacktesting(AOption: CMXOption; AClosePrice: Double);
var
  f_TrafficItem: CFNTrafficItem;
  f_Index: Integer;
  f_Profit: Double;
  f_ConsecWinners: Integer;
  f_ConsecLosers: Integer;
  f_TotalDaysWinners: Integer;
  f_TotalDaysLosers: Integer;
  f_Cumulative: Double;
  f_MaxCumulative: Double;
  f_Drawdown: Double;
  f_SumProfitRatio: Double;
  f_SumPrice: Double;
begin
  m_ProfitRatio := 0;
  m_GrossProfit := 0;
  m_GrossLoss := 0;

  m_NumberOfTrades := 0;
  m_NumberOfWinningTrades := 0;
  m_NumberOfLosingTrades := 0;

  m_LargestWinningTrade := 0;
  m_LargestLosingTrade := 0;

  m_MaxConsecWinners := 0;
  m_MaxConsecLosers := 0;

  m_MaxDrawdown := 0;

  f_TotalDaysWinners := 0;
  f_TotalDaysLosers := 0;

  f_ConsecWinners := 0;
  f_ConsecLosers := 0;

  f_Cumulative := 0;
  f_MaxCumulative := 0;

  f_SumProfitRatio := 0;
  f_SumPrice := 0;

  try
    for f_Index := 0 to m_Items.Count - 1 do
    begin
      f_TrafficItem := m_Items[f_Index];
      f_TrafficItem.m_Enable := false;

      if (f_TrafficItem.m_Signal = SIGNAL_BUY_ENTER) then
      begin
        f_TrafficItem.m_Enable := true;
      end;

      if (f_TrafficItem.m_Signal = SIGNAL_SELL_ENTER) then
      begin
        f_TrafficItem.m_Enable := true;
      end;

    end;

    for f_Index := 0 to m_Items.Count - 1 do
    begin
      f_TrafficItem := m_Items[f_Index];

      if (not f_TrafficItem.m_Enable) then
      begin
        f_TrafficItem.m_Profit := 0;
        f_TrafficItem.m_ProfitRatio := 0;
        f_TrafficItem.m_Cumulative := 0;
        f_TrafficItem.m_SumProfitRatio := 0;
        f_TrafficItem.m_AvgProfitRatio := 0;
        f_TrafficItem.m_DrawDown := 0;

        continue;
      end;

      if not f_TrafficItem.m_Closed then
      begin
        f_TrafficItem.m_ExitCount := f_TrafficItem.m_EnterCount;
        f_TrafficItem.m_ExitPrice := AClosePrice;

        if f_TrafficItem.m_ExitPrice = 0 then
        begin
          f_TrafficItem.m_ExitPrice := f_TrafficItem.m_EnterPrice;
        end;

        f_TrafficItem.m_ExitValue := f_TrafficItem.m_ExitPrice * f_TrafficItem.m_ExitCount;
      end;

      if (f_TrafficItem.m_Signal = SIGNAL_BUY_ENTER) then
      begin
        f_Profit := f_TrafficItem.m_ExitValue - f_TrafficItem.m_EnterValue;
      end
      else if (f_TrafficItem.m_Signal = SIGNAL_SELL_ENTER) then
      begin
        f_Profit := f_TrafficItem.m_EnterValue - f_TrafficItem.m_ExitValue;
      end
      else
      begin
        f_Profit := 0;
      end;

      if (f_Profit > 0) then
      begin
        m_GrossProfit := m_GrossProfit + f_Profit;
        Inc(m_NumberOfWinningTrades);

        if (f_Profit > m_LargestWinningTrade) then
          m_LargestWinningTrade := f_Profit;
        Inc(f_ConsecWinners);

        if (f_ConsecWinners > m_MaxConsecWinners) then
          m_MaxConsecWinners := f_ConsecWinners;
        f_TotalDaysWinners := f_TotalDaysWinners + (f_TrafficItem.m_ExitIndex - f_TrafficItem.m_EnterIndex + 1);

        f_ConsecLosers := 0;
      end
      else if (f_Profit < 0) then
      begin
        m_GrossLoss := m_GrossLoss + f_Profit;
        Inc(m_NumberOfLosingTrades);

        if (f_Profit < m_LargestLosingTrade) then
          m_LargestLosingTrade := f_Profit;
        Inc(f_ConsecLosers);

        if (f_ConsecLosers > m_MaxConsecLosers) then
          m_MaxConsecLosers := f_ConsecLosers;
        f_TotalDaysLosers := f_TotalDaysLosers + (f_TrafficItem.m_ExitIndex - f_TrafficItem.m_EnterIndex + 1);

        f_ConsecWinners := 0;
      end;

      f_Cumulative := m_GrossProfit + m_GrossLoss;

      f_Drawdown := f_Cumulative - f_MaxCumulative;

      // 최대 순이익 삭감액 계산
      if (f_Drawdown < m_MaxDrawdown) then
      begin
        m_MaxDrawdown := f_Drawdown;
      end;

      if (f_Cumulative > f_MaxCumulative) then
        f_MaxCumulative := f_Cumulative;

      f_SumPrice := f_SumPrice + f_TrafficItem.m_EnterPrice;
      f_TrafficItem.m_Profit := f_Profit;
      f_TrafficItem.m_Cumulative := m_GrossProfit + m_GrossLoss;
      if f_TrafficItem.m_EnterPrice <> 0 then
      begin
        f_TrafficItem.m_ProfitRatio := f_TrafficItem.m_Profit * 100.0 / f_TrafficItem.m_EnterPrice;
      end
      else
      begin
        f_TrafficItem.m_ProfitRatio := 0;
      end;

      f_SumProfitRatio := f_SumProfitRatio + f_TrafficItem.m_ProfitRatio;
      f_TrafficItem.m_SumProfitRatio := f_SumProfitRatio;
      Inc(m_NumberOfTrades);

      if (m_NumberOfTrades <> 0) and (f_SumPrice <> 0) then
      begin
        f_TrafficItem.m_AvgProfitRatio := f_TrafficItem.m_Cumulative * 100.0 / (f_SumPrice / m_NumberOfTrades);
      end
      else
      begin
        f_TrafficItem.m_AvgProfitRatio := 0;
      end;
      m_ProfitRatio := f_TrafficItem.m_AvgProfitRatio;

    end;

    m_NetProfit := m_GrossProfit + m_GrossLoss;

    if (m_NumberOfTrades <> 0) then
    begin
      m_PercentProfitable := (m_NumberOfWinningTrades / m_NumberOfTrades) * 100.0;
      m_AvgTrade := m_NetProfit / m_NumberOfTrades;
    end
    else
    begin
      m_PercentProfitable := 0;
      m_AvgTrade := 0;
    end;

    if (m_NumberOfWinningTrades <> 0) then
    begin
      m_AverageWinningTrade := m_GrossProfit / m_NumberOfWinningTrades;
      m_AvgBarsWinners := Round(f_TotalDaysWinners / m_NumberOfWinningTrades);
    end
    else
    begin
      m_AverageWinningTrade := 0;
      m_AvgBarsWinners := 0;
    end;

    if (m_NumberOfLosingTrades <> 0) then
    begin
      m_AverageLosingTrade := m_GrossLoss / m_NumberOfLosingTrades;
      m_AvgBarsLosers := Round(f_TotalDaysLosers / m_NumberOfLosingTrades);
    end
    else
    begin
      m_AverageLosingTrade := 0;
      m_AvgBarsWinners := 0;
    end;

    if (m_AverageLosingTrade <> 0) then
    begin
      m_RatioAvgWinAvgLoss := abs(m_AverageWinningTrade / m_AverageLosingTrade);
    end
    else
    begin
      m_RatioAvgWinAvgLoss := 0;
    end;

    if (m_GrossLoss <> 0) then
    begin
      m_ProfitFactor := abs(m_GrossProfit / m_GrossLoss);
    end
    else
    begin
      m_ProfitFactor := 0;
    end;

    m_AccountSizeRequired := abs(m_MaxDrawdown);

    if (m_AccountSizeRequired <> 0) then
    begin
      m_ReturnAccount := (m_NetProfit / m_AccountSizeRequired) * 100.0;
    end
    else
    begin
      m_ReturnAccount := 0;
    end;

  finally
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNTrafficCollection.WritePrformance(AValueArray: CFNPMValueCollection);
var
  f_Value: CFNPMValueItem;
begin
  AValueArray.Clear;

  if (g_Language = 0) then
  begin
    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '수익율';
    f_Value.m_Value := m_ProfitRatio;
    f_Value.m_Precision := 1;
    f_Value.m_Unit := '%';
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '순이익';
    f_Value.m_Value := m_NetProfit;
    f_Value.m_Precision := -1;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '전체거래수';
    f_Value.m_Value := m_NumberOfTrades;
    f_Value.m_Precision := 0;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '총이익/총손실';
    f_Value.m_Value := m_ProfitFactor;
    f_Value.m_Precision := 2;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '총이익';
    f_Value.m_Value := m_GrossProfit;
    f_Value.m_Precision := -1;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '총손실';
    f_Value.m_Value := m_GrossLoss;
    f_Value.m_Precision := -1;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '이익거래수/전체거래수';
    f_Value.m_Value := m_PercentProfitable;
    f_Value.m_Precision := 2;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '이익거래수';
    f_Value.m_Value := m_NumberOfWinningTrades;
    f_Value.m_Precision := 0;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '손실거래수';
    f_Value.m_Value := m_NumberOfLosingTrades;
    f_Value.m_Precision := 0;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '평균이익거래금액';
    f_Value.m_Value := m_AverageWinningTrade;
    f_Value.m_Precision := -1;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '평균손실거래금액';
    f_Value.m_Value := m_AverageLosingTrade;
    f_Value.m_Precision := -1;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '순이익/전체거래수';
    f_Value.m_Value := m_AvgTrade;
    f_Value.m_Precision := 2;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '평균이익거래금액/평균손실거래금액 ';
    f_Value.m_Value := m_RatioAvgWinAvgLoss;
    f_Value.m_Precision := 2;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '최대연속이익거래수';
    f_Value.m_Value := m_MaxConsecWinners;
    f_Value.m_Precision := 0;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '최대연속손실거래수';
    f_Value.m_Value := m_MaxConsecLosers;
    f_Value.m_Precision := 0;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '이익거래의 평균 바수';
    f_Value.m_Value := m_AvgBarsWinners;
    f_Value.m_Precision := 0;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '손실거래의 평균 바수';
    f_Value.m_Value := m_AvgBarsLosers;
    f_Value.m_Precision := 0;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := '순이익최대삭감금액';
    f_Value.m_Value := m_MaxDrawdown;
    f_Value.m_Precision := -1;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);
  end
  else
  begin
    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Return';
    f_Value.m_Value := m_ProfitRatio;
    f_Value.m_Precision := 1;
    f_Value.m_Unit := '%';
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Net profit';
    f_Value.m_Value := m_NetProfit;
    f_Value.m_Precision := 2;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Number of trades';
    f_Value.m_Value := m_NumberOfTrades;
    f_Value.m_Precision := 0;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Profit factor';
    f_Value.m_Value := m_ProfitFactor;
    f_Value.m_Precision := 2;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Gross profit';
    f_Value.m_Value := m_GrossProfit;
    f_Value.m_Precision := -1;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Gross loss';
    f_Value.m_Value := m_GrossLoss;
    f_Value.m_Precision := 2;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Percent profitabl';
    f_Value.m_Value := m_PercentProfitable;
    f_Value.m_Precision := 2;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Number of winning trades';
    f_Value.m_Value := m_NumberOfWinningTrades;
    f_Value.m_Precision := 0;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Number of losing trades';
    f_Value.m_Value := m_NumberOfLosingTrades;
    f_Value.m_Precision := 0;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Average winning trade';
    f_Value.m_Value := m_AverageWinningTrade;
    f_Value.m_Precision := -1;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Average losing trade';
    f_Value.m_Value := m_AverageLosingTrade;
    f_Value.m_Precision := -1;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Averege trade';
    f_Value.m_Value := m_AvgTrade;
    f_Value.m_Precision := 2;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Ratio average win average loss';
    f_Value.m_Value := m_RatioAvgWinAvgLoss;
    f_Value.m_Precision := 2;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Max consec winners';
    f_Value.m_Value := m_MaxConsecWinners;
    f_Value.m_Precision := 0;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Max consec losers';
    f_Value.m_Value := m_MaxConsecLosers;
    f_Value.m_Precision := 0;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Average bars winners';
    f_Value.m_Value := m_AvgBarsWinners;
    f_Value.m_Precision := 0;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Average bars losers';
    f_Value.m_Value := m_AvgBarsLosers;
    f_Value.m_Precision := 0;
    AValueArray.Add(f_Value);

    f_Value := CFNPMValueItem.Create;
    f_Value.m_Name := 'Max Drawdown';
    f_Value.m_Value := m_MaxDrawdown;
    f_Value.m_Precision := -1;
    f_Value.m_SignColor := true;
    AValueArray.Add(f_Value);
  end;

end;

// ---------------------------------------------------------------------------
procedure CFNTrafficCollection.WriteReport(AStringArray: TStrings);
begin
  AStringArray.Clear;
  AStringArray.Add(Format('  순이익                          %12.2f       ', [m_NetProfit]) + Format('  총이익/총손실                   %12.2f       ', [m_ProfitFactor]));
  AStringArray.Add(Format('  총이익                          %12.2f       ', [m_GrossProfit]) + Format('  총손실                          %12.2f       ', [m_GrossLoss]));
  AStringArray.Add(Format('  전체거래수                      %12d       ', [m_NumberOfTrades]) + Format('  이익거래수/전체거래수           %12.2f%%     ', [m_PercentProfitable]));
  AStringArray.Add(Format('  이익거래수                      %12d       ', [m_NumberOfWinningTrades]) + Format('  손실거래수                      %12d         ', [m_NumberOfLosingTrades]));
  AStringArray.Add(Format('  최대이익거래금액                %12.2f       ', [m_LargestWinningTrade]) + Format('  최대손실거래금액                %12.2f       ', [m_LargestLosingTrade]));
  AStringArray.Add(Format('  평균이익거래금액                %12.2f       ', [m_AverageWinningTrade]) + Format('  평균손실거래금액                %12.2f       ', [m_AverageLosingTrade]));
  AStringArray.Add(Format('  순이익/전체거래수               %12.2f       ', [m_AvgTrade]) + Format('  평균이익거래금액/평균손실거래금액       %3.2f', [m_RatioAvgWinAvgLoss]));
  AStringArray.Add(Format('  최대연속이익거래수              %12d       ', [m_MaxConsecWinners]) + Format('  최대연속손실거래수              %12d         ', [m_MaxConsecLosers]));
  AStringArray.Add(Format('  이익거래의 평균 바수            %12d       ', [m_AvgBarsWinners]) + Format('  손실거래의 평균 바수            %12d         ', [m_AvgBarsLosers]));
  AStringArray.Add(Format('  순이익최대삭감금액              %12.2f       ', [m_MaxDrawdown]));

  // AStringArray.Add(Format('  필요한 거래금액                 %12.2f       ', [m_AccountSizeRequired]));
  // AStringArray.Add(Format('  결과                            %12.2f       ', [m_ReturnAccount]));
end;
{$ENDREGION}
{$REGION 'CFNPMValueItem'}

// ---------------------------------------------------------------------------
constructor CFNPMValueItem.Create;
begin
  inherited Create;
  m_Unit := '';
  m_SignColor := false;
end;
{$ENDREGION}
{$REGION 'CFNPMValueCollection'}

// ---------------------------------------------------------------------------
constructor CFNPMValueCollection.Create;
begin
  inherited Create;

  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
destructor CFNPMValueCollection.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNPMValueCollection.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNPMValueItem(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNPMValueCollection.Add(p_Value: CFNPMValueItem);
begin
  m_Items.Add(p_Value);
end;
{$ENDREGION}
{$REGION 'CFNTrafficManager'}

// ---------------------------------------------------------------------------
constructor CFNTrafficManager.Create;
begin
  inherited Create;

  m_LongTrafficCollection := CFNTrafficCollection.Create;
  m_ShortTrafficCollection := CFNTrafficCollection.Create;
  m_AllTrafficCollection := CFNTrafficCollection.Create;
end;

// ---------------------------------------------------------------------------
destructor CFNTrafficManager.Destroy;
begin
  m_LongTrafficCollection.Free;
  m_ShortTrafficCollection.Free;
  m_AllTrafficCollection.Free;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNTrafficManager.Clear;
begin
  m_LongTrafficCollection.Clear;
  m_ShortTrafficCollection.Clear;
  m_AllTrafficCollection.Clear;
end;

// ---------------------------------------------------------------------------
procedure CFNTrafficManager.MakeTradeListBySignalArray(ASignalArray: CFNSignalArray; AClosePrice: Double = 0);
var
  f_Index: Integer;
  f_SignalData: CFNSignalData;
  f_AllTrafficItem: CFNTrafficItem;
  f_LongTrafficItem: CFNTrafficItem;
  f_ShortTrafficItem: CFNTrafficItem;
  f_Signal: Integer;
  f_Count: Integer;
begin

  f_Count := ASignalArray.m_Items.Count;

  m_AllTrafficCollection.Clear;
  m_LongTrafficCollection.Clear;
  m_ShortTrafficCollection.Clear;

  f_AllTrafficItem := NIL;
  f_LongTrafficItem := NIL;
  f_ShortTrafficItem := NIL;

  f_Signal := SIGNAL_NONE;

  for f_Index := 0 to f_Count - 1 do
  begin
    f_SignalData := ASignalArray.m_Items[f_Index];

    if ((f_SignalData.m_Signal = SIGNAL_SELL_ENTER) or (f_SignalData.m_Signal = SIGNAL_BUY_ENTER)) then
    begin
      if (f_Signal = SIGNAL_SELL_ENTER) then
      begin
        if not Assigned(f_AllTrafficItem) then
          f_AllTrafficItem := CFNTrafficItem.Create;
        f_AllTrafficItem.CopyExit(f_SignalData);
        f_AllTrafficItem.m_Closed := true;
        m_AllTrafficCollection.Add(f_AllTrafficItem);
        f_AllTrafficItem := NIL;

        if not Assigned(f_ShortTrafficItem) then
          f_ShortTrafficItem := CFNTrafficItem.Create;
        f_ShortTrafficItem.CopyExit(f_SignalData);
        f_ShortTrafficItem.m_Closed := true;
        m_ShortTrafficCollection.Add(f_ShortTrafficItem);
        f_ShortTrafficItem := NIL;

      end
      else if (f_Signal = SIGNAL_BUY_ENTER) then
      begin
        if not Assigned(f_AllTrafficItem) then
          f_AllTrafficItem := CFNTrafficItem.Create;
        f_AllTrafficItem.CopyExit(f_SignalData);
        f_AllTrafficItem.m_Closed := true;
        m_AllTrafficCollection.Add(f_AllTrafficItem);
        f_AllTrafficItem := NIL;

        if not Assigned(f_LongTrafficItem) then
          f_LongTrafficItem := CFNTrafficItem.Create;
        f_LongTrafficItem.CopyExit(f_SignalData);
        f_LongTrafficItem.m_Closed := true;
        m_LongTrafficCollection.Add(f_LongTrafficItem);
        f_LongTrafficItem := NIL;
      end
    end;

    if (f_SignalData.m_Signal = SIGNAL_BUY_ENTER) then
    begin
      f_LongTrafficItem := CFNTrafficItem.Create;
      f_LongTrafficItem.CopyEnter(f_SignalData);

      f_AllTrafficItem := CFNTrafficItem.Create;
      f_AllTrafficItem.CopyEnter(f_SignalData);
    end
    else if (f_SignalData.m_Signal = SIGNAL_SELL_ENTER) then
    begin
      f_ShortTrafficItem := CFNTrafficItem.Create;
      f_ShortTrafficItem.CopyEnter(f_SignalData);

      f_AllTrafficItem := CFNTrafficItem.Create;
      f_AllTrafficItem.CopyEnter(f_SignalData);
    end
    else if (f_SignalData.m_Signal = SIGNAL_BUY_EXIT) then
    begin
      if not Assigned(f_LongTrafficItem) then
        f_LongTrafficItem := CFNTrafficItem.Create;
      f_LongTrafficItem.CopyExit(f_SignalData);
      f_LongTrafficItem.m_Closed := true;
      m_LongTrafficCollection.Add(f_LongTrafficItem);
      f_LongTrafficItem := NIL;

      if not Assigned(f_AllTrafficItem) then
        f_AllTrafficItem := CFNTrafficItem.Create;
      f_AllTrafficItem.CopyExit(f_SignalData);
      f_AllTrafficItem.m_Closed := true;
      m_AllTrafficCollection.Add(f_AllTrafficItem);
      f_AllTrafficItem := NIL;
    end
    else if (f_SignalData.m_Signal = SIGNAL_SELL_EXIT) then
    begin
      if not Assigned(f_ShortTrafficItem) then
        f_ShortTrafficItem := CFNTrafficItem.Create;
      f_ShortTrafficItem.CopyExit(f_SignalData);
      f_ShortTrafficItem.m_Closed := true;
      m_ShortTrafficCollection.Add(f_ShortTrafficItem);
      f_ShortTrafficItem := NIL;

      if not Assigned(f_AllTrafficItem) then
        f_AllTrafficItem := CFNTrafficItem.Create;
      f_AllTrafficItem.CopyExit(f_SignalData);
      f_AllTrafficItem.m_Closed := true;
      m_AllTrafficCollection.Add(f_AllTrafficItem);
      f_AllTrafficItem := NIL;
    end;
    f_Signal := f_SignalData.m_Signal;
  end;

  if Assigned(f_AllTrafficItem) then
    m_AllTrafficCollection.Add(f_AllTrafficItem);
  if Assigned(f_LongTrafficItem) then
    m_LongTrafficCollection.Add(f_LongTrafficItem);
  if Assigned(f_ShortTrafficItem) then
    m_ShortTrafficCollection.Add(f_ShortTrafficItem);

  m_AllTrafficCollection.MakePerformance(AClosePrice);
  m_LongTrafficCollection.MakePerformance(AClosePrice);
  m_ShortTrafficCollection.MakePerformance(AClosePrice);
end;

// ---------------------------------------------------------------------------
procedure CFNTrafficManager.MakeTradeListBySignalCollection(ASignalCollection: CFNSignalCollection; AClosePrice: Double = 0);
var
  f_Index: Integer;
  f_SignalItem: CFNSignalItem;
  f_AllTrafficItem: CFNTrafficItem;
  f_LongTrafficItem: CFNTrafficItem;
  f_ShortTrafficItem: CFNTrafficItem;
  f_Signal: Integer;
  f_Count: Integer;
begin
  f_Count := ASignalCollection.m_Items.Count;

  m_AllTrafficCollection.Clear;
  m_LongTrafficCollection.Clear;
  m_ShortTrafficCollection.Clear;

  f_AllTrafficItem := NIL;
  f_LongTrafficItem := NIL;
  f_ShortTrafficItem := NIL;
  f_Signal := SIGNAL_NONE;

  for f_Index := 0 to f_Count - 1 do
  begin
    f_SignalItem := ASignalCollection.m_Items[f_Index];

    if (f_SignalItem.m_ProcessStep = PST_WAITE_ORDER) or (f_SignalItem.m_ProcessStep = PST_DELETE_ORDER) then
    begin
      continue;
    end;

    if not f_SignalItem.m_Enable then
      continue;
    if f_SignalItem.m_TradeValue = 0 then
      continue;

    // 진입신호 이면..
    if ((f_SignalItem.m_CorrectSignal = SIGNAL_SELL_ENTER) or (f_SignalItem.m_CorrectSignal = SIGNAL_BUY_ENTER)) then
    begin
      // 이전신호가 매도이면 중간에 매도청산 신호를 추가한다.
      if (f_Signal = SIGNAL_SELL_ENTER) then
      begin
        if not Assigned(f_AllTrafficItem) then
          f_AllTrafficItem := CFNTrafficItem.Create;
        f_AllTrafficItem.CopyExitBySignalItem(f_SignalItem);
        f_AllTrafficItem.m_Closed := true;
        m_AllTrafficCollection.Add(f_AllTrafficItem);
        f_AllTrafficItem := NIL;

        if not Assigned(f_ShortTrafficItem) then
          f_ShortTrafficItem := CFNTrafficItem.Create;
        f_ShortTrafficItem.CopyExitBySignalItem(f_SignalItem);
        f_ShortTrafficItem.m_Closed := true;
        m_ShortTrafficCollection.Add(f_ShortTrafficItem);
        f_ShortTrafficItem := NIL;

      end
      else

        // 이전신호가 매수이면 중간에 매수청산 신호를 추가한다.
        if (f_Signal = SIGNAL_BUY_ENTER) then
        begin
          if not Assigned(f_AllTrafficItem) then
            f_AllTrafficItem := CFNTrafficItem.Create;
          f_AllTrafficItem.CopyExitBySignalItem(f_SignalItem);
          f_AllTrafficItem.m_Closed := true;
          m_AllTrafficCollection.Add(f_AllTrafficItem);
          f_AllTrafficItem := NIL;

          if not Assigned(f_LongTrafficItem) then
            f_LongTrafficItem := CFNTrafficItem.Create;
          f_LongTrafficItem.CopyExitBySignalItem(f_SignalItem);
          f_LongTrafficItem.m_Closed := true;
          m_LongTrafficCollection.Add(f_LongTrafficItem);
          f_LongTrafficItem := NIL;
        end
    end;

    // 현재 신호가 매수진입이면
    if (f_SignalItem.m_CorrectSignal = SIGNAL_BUY_ENTER) then
    begin
      f_LongTrafficItem := CFNTrafficItem.Create;
      f_LongTrafficItem.CopyEnterBySignalItem(f_SignalItem);

      f_AllTrafficItem := CFNTrafficItem.Create;
      f_AllTrafficItem.CopyEnterBySignalItem(f_SignalItem);
    end
    else

      // 현재 신호가 매도진입이면
      if (f_SignalItem.m_CorrectSignal = SIGNAL_SELL_ENTER) then
      begin
        f_ShortTrafficItem := CFNTrafficItem.Create;
        f_ShortTrafficItem.CopyEnterBySignalItem(f_SignalItem);

        f_AllTrafficItem := CFNTrafficItem.Create;
        f_AllTrafficItem.CopyEnterBySignalItem(f_SignalItem);
      end
      else

        // 현재 신호가 매수청산이면
        if (f_SignalItem.m_CorrectSignal = SIGNAL_BUY_EXIT) then
        begin
          if not Assigned(f_LongTrafficItem) then
            f_LongTrafficItem := CFNTrafficItem.Create;
          f_LongTrafficItem.CopyExitBySignalItem(f_SignalItem);
          f_LongTrafficItem.m_Closed := true;
          m_LongTrafficCollection.Add(f_LongTrafficItem);
          f_LongTrafficItem := NIL;

          if not Assigned(f_AllTrafficItem) then
            f_AllTrafficItem := CFNTrafficItem.Create;
          f_AllTrafficItem.CopyExitBySignalItem(f_SignalItem);
          f_AllTrafficItem.m_Closed := true;
          m_AllTrafficCollection.Add(f_AllTrafficItem);
          f_AllTrafficItem := NIL;
        end
        else

          // 현재 신호가 매도청산이면
          if (f_SignalItem.m_CorrectSignal = SIGNAL_SELL_EXIT) then
          begin
            if not Assigned(f_ShortTrafficItem) then
              f_ShortTrafficItem := CFNTrafficItem.Create;
            f_ShortTrafficItem.CopyExitBySignalItem(f_SignalItem);
            f_ShortTrafficItem.m_Closed := true;
            m_ShortTrafficCollection.Add(f_ShortTrafficItem);
            f_ShortTrafficItem := NIL;

            if not Assigned(f_AllTrafficItem) then
              f_AllTrafficItem := CFNTrafficItem.Create;
            f_AllTrafficItem.CopyExitBySignalItem(f_SignalItem);
            f_AllTrafficItem.m_Closed := true;
            m_AllTrafficCollection.Add(f_AllTrafficItem);
            f_AllTrafficItem := NIL;
          end;
    f_Signal := f_SignalItem.m_CorrectSignal;
  end;

  if Assigned(f_AllTrafficItem) then
    m_AllTrafficCollection.Add(f_AllTrafficItem);
  if Assigned(f_LongTrafficItem) then
    m_LongTrafficCollection.Add(f_LongTrafficItem);
  if Assigned(f_ShortTrafficItem) then
    m_ShortTrafficCollection.Add(f_ShortTrafficItem);

  m_AllTrafficCollection.MakePerformance(AClosePrice);
  m_LongTrafficCollection.MakePerformance(AClosePrice);
  m_ShortTrafficCollection.MakePerformance(AClosePrice);
end;

(*
  procedure CFNTrafficManager.MakeTradeListOfBacktesting(
  AOption: CFNOPSOption;
  ASignalArray: CFNSignalArray;
  AClosePrice: Double
  );
  var
  f_Index:Integer;
  f_SignalData:CFNSignalData;
  f_AllTrafficItem:CFNTrafficItem;
  f_LongTrafficItem:CFNTrafficItem;
  f_ShortTrafficItem:CFNTrafficItem;
  f_Signal:Integer;
  f_Count:Integer;
  begin
  f_Count := ASignalArray.m_Items.Count;

  m_AllTrafficCollection.Clear;
  m_LongTrafficCollection.Clear;
  m_ShortTrafficCollection.Clear;

  f_AllTrafficItem := NIL;
  f_LongTrafficItem := NIL;
  f_ShortTrafficItem := NIL;

  f_Signal := SIGNAL_NONE;

  for f_Index := 0 to f_Count-1 do
  begin
  f_SignalData := ASignalArray.m_Items[f_Index];

  if ((f_SignalData.m_Signal = SIGNAL_SELL_ENTER) or (f_SignalData.m_Signal = SIGNAL_BUY_ENTER)) then
  begin
  if (f_Signal = SIGNAL_SELL_ENTER) then
  begin
  if not Assigned(f_AllTrafficItem) then f_AllTrafficItem := CFNTrafficItem.Create;
  f_AllTrafficItem.CopyExit(f_SignalData);
  f_AllTrafficItem.m_Closed := true;
  m_AllTrafficCollection.Add(f_AllTrafficItem);
  f_AllTrafficItem := NIL;

  if not Assigned(f_ShortTrafficItem) then f_ShortTrafficItem := CFNTrafficItem.Create;
  f_ShortTrafficItem.CopyExit(f_SignalData);
  f_ShortTrafficItem.m_Closed := true;
  m_ShortTrafficCollection.Add(f_ShortTrafficItem);
  f_ShortTrafficItem := NIL;

  end else
  if (f_Signal = SIGNAL_BUY_ENTER) then
  begin
  if not Assigned(f_AllTrafficItem) then f_AllTrafficItem := CFNTrafficItem.Create;
  f_AllTrafficItem.CopyExit(f_SignalData);
  f_AllTrafficItem.m_Closed := true;
  m_AllTrafficCollection.Add(f_AllTrafficItem);
  f_AllTrafficItem := NIL;

  if not Assigned(f_LongTrafficItem) then f_LongTrafficItem := CFNTrafficItem.Create;
  f_LongTrafficItem.CopyExit(f_SignalData);
  f_LongTrafficItem.m_Closed := true;
  m_LongTrafficCollection.Add(f_LongTrafficItem);
  f_LongTrafficItem := NIL;
  end
  end;

  if (f_SignalData.m_Signal = SIGNAL_BUY_ENTER) then
  begin
  f_LongTrafficItem := CFNTrafficItem.Create;
  f_LongTrafficItem.CopyEnter(f_SignalData);

  f_AllTrafficItem := CFNTrafficItem.Create;
  f_AllTrafficItem.CopyEnter(f_SignalData);
  end else
  if (f_SignalData.m_Signal = SIGNAL_SELL_ENTER) then
  begin
  f_ShortTrafficItem := CFNTrafficItem.Create;
  f_ShortTrafficItem.CopyEnter(f_SignalData);

  f_AllTrafficItem := CFNTrafficItem.Create;
  f_AllTrafficItem.CopyEnter(f_SignalData);
  end else
  if (f_SignalData.m_Signal = SIGNAL_BUY_EXIT)  then
  begin
  if not Assigned(f_LongTrafficItem) then f_LongTrafficItem := CFNTrafficItem.Create;
  f_LongTrafficItem.CopyExit(f_SignalData);
  f_LongTrafficItem.m_Closed := true;
  m_LongTrafficCollection.Add(f_LongTrafficItem);
  f_LongTrafficItem := NIL;

  if not Assigned(f_AllTrafficItem) then f_AllTrafficItem := CFNTrafficItem.Create;
  f_AllTrafficItem.CopyExit(f_SignalData);
  f_AllTrafficItem.m_Closed := true;
  m_AllTrafficCollection.Add(f_AllTrafficItem);
  f_AllTrafficItem := NIL;
  end else
  if (f_SignalData.m_Signal = SIGNAL_SELL_EXIT) then
  begin
  if not Assigned(f_ShortTrafficItem) then f_ShortTrafficItem := CFNTrafficItem.Create;
  f_ShortTrafficItem.CopyExit(f_SignalData);
  f_ShortTrafficItem.m_Closed := true;
  m_ShortTrafficCollection.Add(f_ShortTrafficItem);
  f_ShortTrafficItem := NIL;

  if not Assigned(f_AllTrafficItem) then f_AllTrafficItem := CFNTrafficItem.Create;
  f_AllTrafficItem.CopyExit(f_SignalData);
  f_AllTrafficItem.m_Closed := true;
  m_AllTrafficCollection.Add(f_AllTrafficItem);
  f_AllTrafficItem := NIL;
  end;
  f_Signal := f_SignalData.m_Signal;
  end;

  if Assigned(f_AllTrafficItem) then m_AllTrafficCollection.Add(f_AllTrafficItem);
  if Assigned(f_LongTrafficItem) then m_LongTrafficCollection.Add(f_LongTrafficItem);
  if Assigned(f_ShortTrafficItem) then m_ShortTrafficCollection.Add(f_ShortTrafficItem);

  m_AllTrafficCollection.MakePerformanceOfBacktesting(AOption, AClosePrice);
  m_LongTrafficCollection.MakePerformanceOfBacktesting(AOption, AClosePrice);
  m_ShortTrafficCollection.MakePerformanceOfBacktesting(AOption, AClosePrice);
  end;
*)
procedure CFNTrafficManager.MakeTradeListOfBacktesting(AOption: CMXOption; ASignalArray: CFNSignalArray; AClosePrice: Double);
var
  f_Index: Integer;
  f_SignalData: CFNSignalData;
  f_AllTrafficItem: CFNTrafficItem;
  f_LongTrafficItem: CFNTrafficItem;
  f_ShortTrafficItem: CFNTrafficItem;
  f_Signal: Integer;
  f_Count: Integer;
begin
  f_Count := ASignalArray.m_Items.Count;

  m_AllTrafficCollection.Clear;
  m_LongTrafficCollection.Clear;
  m_ShortTrafficCollection.Clear;

  f_AllTrafficItem := NIL;
  f_LongTrafficItem := NIL;
  f_ShortTrafficItem := NIL;

  f_Signal := SIGNAL_NONE;

  for f_Index := 0 to f_Count - 1 do
  begin
    f_SignalData := ASignalArray.m_Items[f_Index];

    if ((f_SignalData.m_Signal = SIGNAL_SELL_ENTER) or (f_SignalData.m_Signal = SIGNAL_BUY_ENTER)) then
    begin
      if (f_Signal = SIGNAL_SELL_ENTER) then
      begin
        if not Assigned(f_AllTrafficItem) then
          f_AllTrafficItem := CFNTrafficItem.Create;
        f_AllTrafficItem.CopyExit(f_SignalData);
        f_AllTrafficItem.m_Closed := true;
        m_AllTrafficCollection.Add(f_AllTrafficItem);
        f_AllTrafficItem := NIL;

        if not Assigned(f_ShortTrafficItem) then
          f_ShortTrafficItem := CFNTrafficItem.Create;
        f_ShortTrafficItem.CopyExit(f_SignalData);
        f_ShortTrafficItem.m_Closed := true;
        m_ShortTrafficCollection.Add(f_ShortTrafficItem);
        f_ShortTrafficItem := NIL;

      end
      else if (f_Signal = SIGNAL_BUY_ENTER) then
      begin
        if not Assigned(f_AllTrafficItem) then
          f_AllTrafficItem := CFNTrafficItem.Create;
        f_AllTrafficItem.CopyExit(f_SignalData);
        f_AllTrafficItem.m_Closed := true;
        m_AllTrafficCollection.Add(f_AllTrafficItem);
        f_AllTrafficItem := NIL;

        if not Assigned(f_LongTrafficItem) then
          f_LongTrafficItem := CFNTrafficItem.Create;
        f_LongTrafficItem.CopyExit(f_SignalData);
        f_LongTrafficItem.m_Closed := true;
        m_LongTrafficCollection.Add(f_LongTrafficItem);
        f_LongTrafficItem := NIL;
      end
    end;

    if (f_SignalData.m_Signal = SIGNAL_BUY_ENTER) then
    begin
      f_LongTrafficItem := CFNTrafficItem.Create;
      f_LongTrafficItem.CopyEnter(f_SignalData);

      f_AllTrafficItem := CFNTrafficItem.Create;
      f_AllTrafficItem.CopyEnter(f_SignalData);
    end
    else if (f_SignalData.m_Signal = SIGNAL_SELL_ENTER) then
    begin
      f_ShortTrafficItem := CFNTrafficItem.Create;
      f_ShortTrafficItem.CopyEnter(f_SignalData);

      f_AllTrafficItem := CFNTrafficItem.Create;
      f_AllTrafficItem.CopyEnter(f_SignalData);
    end
    else if (f_SignalData.m_Signal = SIGNAL_BUY_EXIT) then
    begin
      if not Assigned(f_LongTrafficItem) then
        f_LongTrafficItem := CFNTrafficItem.Create;
      f_LongTrafficItem.CopyExit(f_SignalData);
      f_LongTrafficItem.m_Closed := true;
      m_LongTrafficCollection.Add(f_LongTrafficItem);
      f_LongTrafficItem := NIL;

      if not Assigned(f_AllTrafficItem) then
        f_AllTrafficItem := CFNTrafficItem.Create;
      f_AllTrafficItem.CopyExit(f_SignalData);
      f_AllTrafficItem.m_Closed := true;
      m_AllTrafficCollection.Add(f_AllTrafficItem);
      f_AllTrafficItem := NIL;
    end
    else if (f_SignalData.m_Signal = SIGNAL_SELL_EXIT) then
    begin
      if not Assigned(f_ShortTrafficItem) then
        f_ShortTrafficItem := CFNTrafficItem.Create;
      f_ShortTrafficItem.CopyExit(f_SignalData);
      f_ShortTrafficItem.m_Closed := true;
      m_ShortTrafficCollection.Add(f_ShortTrafficItem);
      f_ShortTrafficItem := NIL;

      if not Assigned(f_AllTrafficItem) then
        f_AllTrafficItem := CFNTrafficItem.Create;
      f_AllTrafficItem.CopyExit(f_SignalData);
      f_AllTrafficItem.m_Closed := true;
      m_AllTrafficCollection.Add(f_AllTrafficItem);
      f_AllTrafficItem := NIL;
    end;
    f_Signal := f_SignalData.m_Signal;
  end;

  if Assigned(f_AllTrafficItem) then
    m_AllTrafficCollection.Add(f_AllTrafficItem);
  if Assigned(f_LongTrafficItem) then
    m_LongTrafficCollection.Add(f_LongTrafficItem);
  if Assigned(f_ShortTrafficItem) then
    m_ShortTrafficCollection.Add(f_ShortTrafficItem);

  m_AllTrafficCollection.MakePerformanceOfBacktesting(AOption, AClosePrice);
  m_LongTrafficCollection.MakePerformanceOfBacktesting(AOption, AClosePrice);
  m_ShortTrafficCollection.MakePerformanceOfBacktesting(AOption, AClosePrice);
end;

{$ENDREGION}
{ CFNNAVDataItem }

constructor CFNNAVDataItem.Create;
begin

end;

{ CFNNAVDataCollection }

// ---------------------------------------------------------------------------
constructor CFNNAVDataCollection.Create;
begin
  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
destructor CFNNAVDataCollection.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVDataCollection.Add(p_Value: CFNNAVDataItem);
var
  f_SearchIndex: Integer;
begin
  // 데이터가 하나라도 존재하면
  if (0 < m_Items.Count) then
  begin
    // 만약 추가할 데이터의 날짜가 가장앞쪽의 데이터 보다 작다면 가장앞에 넣는다.
    if (p_Value.m_DateTime < CFNNAVDataItem(m_Items.Items[0]).m_DateTime) then
    begin
      m_Items.Insert(0, p_Value);
    end
    else
    begin
      // 만약 추가할 데이터의 날짜가 가장 앞쪽의 데이터 보다 크다면 가장뒤에 넣는다.
      if (p_Value.m_DateTime > CFNNAVDataItem(m_Items.Items[m_Items.Count - 1]).m_DateTime) then
      begin
        m_Items.Add(p_Value);
      end
      else
      begin
        // 추가할 위치를 찾아서 그 위치 바로 뒤에 넣는다.
        f_SearchIndex := SearchIndex(p_Value.m_DateTime, true);
        if (f_SearchIndex >= 0) then
        begin
          if (p_Value.m_DateTime = CFNNAVDataItem(m_Items.Items[f_SearchIndex]).m_DateTime) then
          begin
            CFNNAVDataItem(m_Items.Items[f_SearchIndex]).Free;
            m_Items.Items[f_SearchIndex] := p_Value
          end
          else
            m_Items.Insert(f_SearchIndex, p_Value);
        end;
      end;
    end;
  end
  else
  begin
    // 데이터가 없다면 그냥 추가한다.
    m_Items.Add(p_Value);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVDataCollection.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNNAVDataItem(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
function CFNNAVDataCollection.SearchIndex(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_AVDataItem: CFNNAVDataItem;
begin
  f_RecordCount := m_Items.Count;
  if (0 < f_RecordCount) then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_AVDataItem := CFNNAVDataItem(m_Items.Items[f_PosX]);
      f_Compare := p_TimeDate - f_AVDataItem.m_DateTime;
      if (0 > f_Compare) then
        f_PosR := f_PosX - 1
      else
        f_PosL := f_PosX + 1;
    until (not((f_Compare <> 0) and (f_PosL <= f_PosR)));

    if (0 = f_Compare) then
      Result := f_PosX
    else if (p_Nearest) then
      if (f_PosL >= f_RecordCount) then
        Result := -1
      else
        Result := f_PosL
    else
      Result := -1;
  end
  else
  begin
    Result := -1;
  end;
end;

{ CFNDailyPMValueItem }

constructor CFNDailyPMValueItem.Create;
begin

end;

// ---------------------------------------------------------------------------
function CFNDailyPMValueCollection.Search(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_Value: CFNDailyPMValueItem;
begin
  f_RecordCount := m_Items.Count;
  if (0 < f_RecordCount) then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_Value := CFNDailyPMValueItem(m_Items.Items[f_PosX]);
      f_Compare := p_TimeDate - f_Value.m_Date;
      if (0 > f_Compare) then
      begin
        f_PosR := f_PosX - 1
      end
      else
      begin
        f_PosL := f_PosX + 1;
      end;
    until (not((f_Compare <> 0) and (f_PosL <= f_PosR)));

    if (0 = f_Compare) then
    begin
      Result := f_PosX
    end
    else if (p_Nearest) then
    begin
      if (f_PosL >= f_RecordCount) then
        Result := -1
      else
        Result := f_PosL
    end
    else
    begin
      Result := -1;
    end;

  end
  else
  begin
    Result := -1;
  end;
end;
{ CFNDailyPMValueCollection }

procedure CFNDailyPMValueCollection.Add(p_Value: CFNDailyPMValueItem);
begin
  m_Items.Add(p_Value);
end;

procedure CFNDailyPMValueCollection.Add2(p_Value: CFNDailyPMValueItem);
var
  f_SearchIndex: Integer;
begin
  // 데이터가 하나라도 존재하면
  if (0 < m_Items.Count) then
  begin
    // 만약 추가할 데이터의 날짜가 가장앞쪽의 데이터 보다 작다면 가장앞에 넣는다.
    if (p_Value.m_Date < CFNDailyPMValueItem(m_Items.Items[0]).m_Date) then
    begin
      m_Items.Insert(0, p_Value);
    end
    else
    begin
      // 만약 추가할 데이터의 날짜가 가장 앞쪽의 데이터 보다 크다면 가장뒤에 넣는다.
      if (p_Value.m_Date > CFNDailyPMValueItem(m_Items.Items[m_Items.Count - 1]).m_Date) then
      begin
        m_Items.Add(p_Value);
      end
      else
      begin
        // 추가할 위치를 찾아서 그 위치 바로 뒤에 넣는다.
        f_SearchIndex := Search(p_Value.m_Date, true);
        if (f_SearchIndex >= 0) then
        begin
          if (p_Value.m_Date = CFNDailyPMValueItem(m_Items.Items[f_SearchIndex]).m_Date) then
          begin
            CFNDailyPMValueItem(m_Items.Items[f_SearchIndex]).Free;
            m_Items.Items[f_SearchIndex] := p_Value
          end
          else
            m_Items.Insert(f_SearchIndex, p_Value);
        end;
      end;
    end;
  end
  else
  begin
    // 데이터가 없다면 그냥 추가한다.
    m_Items.Add(p_Value);
  end;
end;

procedure CFNDailyPMValueCollection.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNDailyPMValueItem(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

constructor CFNDailyPMValueCollection.Create;
begin
  inherited Create;

  m_Items := TList.Create;
end;

destructor CFNDailyPMValueCollection.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

end.
