unit MXTradeStrategy;

interface

uses
  SysUtils, Math, Classes, MKChartData,
  MKChartDataSeries,
  MKLineValue,
  MKLineValueSeries,
  MXTSLineValueSeries,
  FNDataSet,
  MXTradeStrategyOptionCollection,
  MKSignalArray,
  MKTradeStrategyCustom;

const
  STRATEGY_BUY = 1;
  STRATEGY_SELL = -1;
  STRATEGY_EXIT = 0;

  TS_SIGNAL_IDX_ORIGIN = 0;
  TS_SIGNAL_IDX_TRADING_HOUR = 1;
  TS_SIGNAL_IDX_RANDOM = 2;
  TS_SIGNAL_IDX_EXIT = 3;
  TS_SIGNAL_IDX_ENTER_DELAY = 4;
  TS_SIGNAL_IDX_ENTER_MAXCOUNT = 5;

  TS_SIGNAL_IDX_FINAL = 5;
  TS_SIGNAL_IDX_MAX = 6;

type

  /// 매매전략을 생성하고, 화면에 표시할때 필요한 최소한의 데이터와 파라메터,
  /// 그리고 결과를 담은 라인시리즈를 가지고 있는 클래스
  CMXTradeStrategy = class(CMKTradeStrategyCustom)
  public

  protected
    // 계산에 필요한 옵션들
    m_Option: CMXTradeStrategyOption;

    // 계산에 필요한 라인을 저장소에 저장한다
    procedure AddLineValueSeries(ALineValueSeries: CMKLineValueSeries);

    // 계산에 필요한 라인을 생성한다.
    procedure CreateLineValueSeries; virtual;

    // 저장소에 저장된 라인을 모두 삭제한다.
    procedure DeleteLineValueSeries;

    procedure CreateReinforceLineValueSeries(var AChartBlockCount: Integer);

    procedure CreateReinforceSignalLineValueSeries(var AChartBlockCount: Integer);

    procedure CalculateReinforce(p_Begin: Integer; p_End: Integer);

    procedure CalulateReinforceSignal(p_Begin: Integer; p_End: Integer);

  public
    // 생성자
    constructor Create();

    // 파괴자
    destructor Destroy(); override;

    procedure Clear; override;

    procedure SetChartDataSeriesToLineSeries;

    // 계산을 시작한다.
    procedure Calculate(ARecalculation: Boolean); override;

    // 필터를 시작한다.
    procedure ApplyFilter(p_Begin: Integer; p_End: Integer);

    // 거래시간에 따른 매매신호를 발생하도록 한다.
    procedure ApplyTradingHour(p_Begin: Integer; p_End: Integer);

    // 필터중 랜덤으로 진입하는 기능을 구현한다.
    procedure ApplyRandom(p_Begin: Integer; p_End: Integer);

    // 재진입의 지연과 일중최대횟수를 구현한다.
    procedure ApplyEnter(p_Begin: Integer; p_End: Integer);

    // 청산관련 모듈을 적용한다.
    procedure ApplyExit(p_Begin: Integer; p_End: Integer);

    // 최종 신호를 저장할 라인을 생성한다.
    function Creator_SignalLineValueSeries: CMXTSLineValueSeries;

    // 최종신호를 추출한다.
    procedure ScanSignal(p_SignalArray: CMKSignalArray);

    // 가격을 대신할 지표로, 가격, OPS, OPS2중에 선택한다.
    procedure SetMajorValueType(AValue: Integer);
    function GetMajorValueType: Integer;

    procedure OnChangedOption(Sender: TObject);

    // 계산파라메터를 설정한다
    procedure SetOption(AOption: CMXTradeStrategyOption);

{$REGION '옵션의 값을 읽어오는 함수'}
    function GetStringOptionValue(AKey: String): String; override;
    function GetIntegerOptionValue(AKey: String): Integer; override;
    function GetDoubleOptionValue(AKey: String): Double; override;
    function GetBooleanOptionValue(AKey: String): Boolean; override;
{$ENDREGION}
{$REGION '옵션의 값을 저장하는 함수'}
    procedure SetStringOptionValue(AKey: String; AValue: String);
    procedure SetIntegerOptionValue(AKey: String; AValue: Integer);
    procedure SetDoubleOptionValue(AKey: String; AValue: Double);
    procedure SetBooleanOptionValue(AKey: String; AValue: Boolean);
{$ENDREGION}
  private
    m_OnChanged: TNotifyEvent;

  public
    // 내부 옵션이 변경되어 계산내용이 변경되었을 때 발생하는 이벤트
    property OnChanged: TNotifyEvent read m_OnChanged write m_OnChanged;
    property Option: CMXTradeStrategyOption read m_Option write SetOption;

  private
    m_ExitIndex: Integer;
    m_EnterCount: Integer;

    m_EnterPrice, m_MaxPrice, m_TrailingStopStep: Double;

  protected
    m_EnterCondition1: Integer;
    m_EnterCondition2: Integer;

    // 기준선과 비교할 보조지표에서 각 경우에 따라 사용할 라인을 지정한다.
    function GetPMUpperLine(APrefix: String = ''): Integer;

    // 기준선과 비교할 보조지표에서 각 경우에 따라 사용할 라인을 지정한다.
    function GetPMDownLine(APrefix: String = ''): Integer;

    // 옵션이 변경되어 재계산이 될 때 화면에 표시한 것들중에 옵션에 관련된 사항들을 적용한다.
    procedure UpdateVisibleStateOfLineValueSeries; virtual;

    procedure UpdateVisibleStateOfReinforceLineValueSeries;

  protected
    m_DEFAULT_LINE_ZERO: Integer;
    m_REINFORCE_LINE_ZERO: Integer;
    m_REINFORCE1_LINE_ZERO: Integer;
    m_REINFORCE2_LINE_ZERO: Integer;

    m_SIGNAL_LINE_ZERO: Integer;
    m_REINFORCE_SIGNAL_LINE_ZERO: Integer;

  public

{$REGION '라인시리즈의 객체를 종류별로 생성하여 리턴한다'}
    class function Creator_MajorLineValueSeries: CMXTSLineValueSeries;
    class function Creator_RSI: CMXTSLineValueSeries;
    class function Creator_AnyLineValueSeries(ALineCount: Integer): CMXTSLineValueSeries;
    class function Creator_AnySignalValueSeries(ALineCount: Integer): CMXTSLineValueSeries;
    class function Creator_BBWidth: CMXTSLineValueSeries;
    class function Creator_BBand: CMXTSLineValueSeries;
    class function Creator_IMLine: CMXTSLineValueSeries;
    class function Creator_SlowSTC: CMXTSLineValueSeries;
{$ENDREGION}
  end;

implementation

uses MKGlobal, MKConst, MKColorSet, MKTradeStrategyConst;

// ---------------------------------------------------------------------------
/// 생성자
constructor CMXTradeStrategy.Create();
begin
  inherited Create();

  m_PriceLineValueSeries := Creator_MajorLineValueSeries;
  m_OPS2LineValueSeries := Creator_AnyLineValueSeries(16);

  m_Option := CMXTradeStrategyOption.Create;
  m_Option.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  m_Option.OnChanged := OnChangedOption;

  m_DEFAULT_LINE_ZERO := 0;
  m_REINFORCE_LINE_ZERO := 0;
  m_REINFORCE1_LINE_ZERO := 0;
  m_REINFORCE2_LINE_ZERO := 0;
  m_SIGNAL_LINE_ZERO := 0;
  m_REINFORCE_SIGNAL_LINE_ZERO := 0;

  CreateLineValueSeries;
end;

// ---------------------------------------------------------------------------
/// 파괴자
destructor CMXTradeStrategy.Destroy();
begin
  DeleteLineValueSeries;

  if (m_PriceLineValueSeries <> NIL) then
  begin
    CMXTSLineValueSeries(m_PriceLineValueSeries).Free;
    m_PriceLineValueSeries := NIL;
  end;

  if (m_OPS2LineValueSeries <> NIL) then
  begin
    CMXTSLineValueSeries(m_OPS2LineValueSeries).Free;
    m_OPS2LineValueSeries := NIL;
  end;

  if (m_Option <> NIL) then
  begin
    m_Option.Free;
    m_Option := NIL;
  end;
  inherited Destroy();
end;

// ---------------------------------------------------------------------------
procedure CMXTradeStrategy.SetOption(AOption: CMXTradeStrategyOption);
begin
  m_Option.Clone(AOption);
end;

// ---------------------------------------------------------------------------
// 옵션이 변경되어 재계산이 될 때 화면에 표시한 것들중에 옵션에 관련된 사항들을 적용한다.
procedure CMXTradeStrategy.UpdateVisibleStateOfLineValueSeries;
begin

end;

// ---------------------------------------------------------------------------
/// 계산을 시작한다.
procedure CMXTradeStrategy.Calculate(ARecalculation: Boolean);
begin
  if not Assigned(m_ChartDataSeries) then
    exit;

  if (ARecalculation) then
  begin
    UpdateVisibleStateOfLineValueSeries;
    UpdateVisibleStateOfReinforceLineValueSeries;

    Clear;
  end;
end;

// ---------------------------------------------------------------------------
/// 계산에 필요한 라인을 생성한다.
procedure CMXTradeStrategy.CreateLineValueSeries;
begin

end;

// ---------------------------------------------------------------------------
/// 계산에 필요한 라인을 저장소에 저장한다
procedure CMXTradeStrategy.AddLineValueSeries(ALineValueSeries: CMKLineValueSeries);
begin
  m_LineCollection.Add(ALineValueSeries);
end;

// ---------------------------------------------------------------------------
/// 계산에 필요한 라인을 초기화한다
procedure CMXTradeStrategy.Clear;
var
  f_LineValueSeries: CMKLineValueSeries;
  f_Index: Integer;
begin
  if Assigned(m_LineCollection) then
  begin
    for f_Index := 0 to m_LineCollection.Count - 1 do
    begin
      f_LineValueSeries := m_LineCollection.Items[f_Index];
      if Assigned(f_LineValueSeries) then
        f_LineValueSeries.Clear;
    end;
  end;

  if Assigned(m_PriceLineValueSeries) then
  begin
    m_PriceLineValueSeries.Clear;
  end;

  if Assigned(m_OPS2LineValueSeries) then
  begin
    m_OPS2LineValueSeries.Clear;
  end;

  m_ExitIndex := 0;
  m_EnterCount := 0;

  m_EnterCondition1 := 0;
  m_EnterCondition2 := 0;

  m_EnterPrice := 0;
  m_MaxPrice := 0;
  m_TrailingStopStep := 0;
end;

// ---------------------------------------------------------------------------
/// 보조지표에 차트데이터를 전달한다
procedure CMXTradeStrategy.SetChartDataSeriesToLineSeries;
var
  f_LineValueSeries: CMXTSLineValueSeries;
  f_Index: Integer;
begin
  for f_Index := 0 to m_LineCollection.Count - 1 do
  begin
    f_LineValueSeries := m_LineCollection.Items[f_Index];
    f_LineValueSeries.m_ChartDataSeries := m_ChartDataSeries;
  end;
end;

// ---------------------------------------------------------------------------
// 저장소에 저장된 라인을 모두 삭제한다.
procedure CMXTradeStrategy.DeleteLineValueSeries;
var
  f_LineValueSeries: CMXTSLineValueSeries;
begin
  if Assigned(m_LineCollection) then
  begin
    while (m_LineCollection.Count > 0) do
    begin
      f_LineValueSeries := m_LineCollection.Items[0];
      f_LineValueSeries.Clear();
      f_LineValueSeries.Free();
      m_LineCollection.Delete(0);
    end;
  end;
  m_DEFAULT_LINE_ZERO := 0;
  m_REINFORCE_LINE_ZERO := 0;
  m_REINFORCE1_LINE_ZERO := 0;
  m_REINFORCE2_LINE_ZERO := 0;
  m_SIGNAL_LINE_ZERO := 0;
  m_REINFORCE_SIGNAL_LINE_ZERO := 0;
end;

// ---------------------------------------------------------------------------
// 최종 신호를 저장할 라인을 생성한다.
function CMXTradeStrategy.Creator_SignalLineValueSeries: CMXTSLineValueSeries;
var
  f_Line: CMXTSLineValueSeries;
begin
  f_Line := Creator_AnySignalValueSeries(TS_SIGNAL_IDX_MAX);
  Result := f_Line;
end;

{$REGION '필터를 사용합니다'}

// ---------------------------------------------------------------------------
// 필터를 시작한다.
procedure CMXTradeStrategy.ApplyFilter(p_Begin: Integer; p_End: Integer);
begin
  ApplyTradingHour(p_Begin, p_End);
  ApplyRandom(p_Begin, p_End);
  ApplyExit(p_Begin, p_End);
  ApplyEnter(p_Begin, p_End);
end;

// ---------------------------------------------------------------------------
// 거래시간에 따른 매매신호를 발생하도록 한다.
procedure CMXTradeStrategy.ApplyTradingHour(p_Begin: Integer; p_End: Integer);
var
  f_Index: Integer;

  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;

  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;

  f_LineValueSeries: CMXTSLineValueSeries;

  f_SIGNAL_SEQ: Integer;

  f_Time: Double;
  f_StartTime, f_StopTime: Double;
  f_Hour, f_Min, f_Sec, f_MSec: Word;
begin
  if m_LineCollection.Count <= 0 then
    exit;
  f_LineValueSeries := m_LineCollection[m_LineCollection.Count - 1];

{$REGION '계산할 범위를 결정한다.'}
  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := m_ChartDataSeries.m_Items.Count;
  if (p_End > m_ChartDataSeries.m_Items.Count) then
    p_End := m_ChartDataSeries.m_Items.Count;
  if (p_Begin > m_ChartDataSeries.m_Items.Count - 1) then
    p_Begin := m_ChartDataSeries.m_Items.Count - 1;
  if (p_Begin < 0) then
    p_Begin := 0;
{$ENDREGION}
{$REGION '거래시간을 계산한다.'}
  if m_Option.GetBooleanValue('USE_REGULAR_MARKET') then
  begin
    f_StartTime := Math.Max(m_Option.GetIntegerValue('START_TIME') / 86400000.0, m_Option.GetIntegerValue('REGULAR_START_TIME')
        / 86400000.0);
    f_StopTime := Math.Min(m_Option.GetIntegerValue('STOP_TIME') / 86400000.0, m_Option.GetIntegerValue('REGULAR_STOP_TIME') /
        86400000.0);
  end
  else
  begin
    f_StartTime := m_Option.GetIntegerValue('START_TIME') / 86400000.0;
    f_StopTime := m_Option.GetIntegerValue('STOP_TIME') / 86400000.0;
  end;

  DecodeTime(f_StartTime, f_Hour, f_Min, f_Sec, f_MSec);
  f_StartTime := EncodeTime(f_Hour, f_Min, 0, 0);

  DecodeTime(f_StopTime, f_Hour, f_Min, f_Sec, f_MSec);
  f_StopTime := EncodeTime(f_Hour, f_Min, 0, 0);
{$ENDREGION}
{$REGION '거래시간만 신호가 나오도록 한다'}
  f_SIGNAL_SEQ := TS_SIGNAL_IDX_TRADING_HOUR;
  for f_Index := p_Begin to p_End - 1 do
  begin
    f_LineValue0 := f_LineValueSeries.m_Items[f_Index];
    f_ChartData0 := m_ChartDataSeries.m_Items[f_Index];

    if (f_Index > 0) then
    begin
      f_LineValue1 := f_LineValueSeries.m_Items[f_Index - 1];
      f_ChartData1 := m_ChartDataSeries.m_Items[f_Index - 1];

      // 날짜가 변경되면 청산한다.
      if (Trunc(f_ChartData1.m_CloseDateTime) <> Trunc(f_ChartData0.m_CloseDateTime)) then
      begin
        f_LineValue1.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
      end;

      DecodeTime(f_ChartData0.m_CloseDateTime, f_Hour, f_Min, f_Sec, f_MSec);
      f_Time := EncodeTime(f_Hour, f_Min, 0, 0);

      if (f_StartTime <= f_Time) and (f_Time <= f_StopTime) then
      begin
        f_LineValue0.m_Value[f_SIGNAL_SEQ] := f_LineValue0.m_Value[f_SIGNAL_SEQ - 1];
      end
      else
      begin
        f_LineValue1.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
        f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
      end;
    end
    else
    begin
      f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
    end;
  end;
{$ENDREGION}
end;

// ---------------------------------------------------------------------------
// 필터중 랜덤으로 진입하는 기능을 구현한다.
procedure CMXTradeStrategy.ApplyRandom(p_Begin: Integer; p_End: Integer);
var
  f_Index: Integer;

  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;

  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;

  f_LineValueSeries: CMXTSLineValueSeries;

  f_SIGNAL_SEQ: Integer;
  f_RandomNumber: Integer;
begin
  if m_LineCollection.Count <= 0 then
    exit;
  f_LineValueSeries := m_LineCollection[m_LineCollection.Count - 1];

{$REGION '계산할 범위를 결정한다.'}
  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := m_ChartDataSeries.m_Items.Count;
  if (p_End > m_ChartDataSeries.m_Items.Count) then
    p_End := m_ChartDataSeries.m_Items.Count;
  if (p_Begin > m_ChartDataSeries.m_Items.Count - 1) then
    p_Begin := m_ChartDataSeries.m_Items.Count - 1;
  if (p_Begin < 0) then
    p_Begin := 0;
{$ENDREGION}
{$REGION '랜덤으로 진입하도록 한다'}
  f_SIGNAL_SEQ := TS_SIGNAL_IDX_RANDOM;
  if m_Option.GetBooleanValue('USE_RANDOM_TRADE') then
  begin
    if m_Option.GetIntegerValue('RANDOM_CASE') = 0 then
    begin
      f_RandomNumber := 2;
    end
    else
    begin
      f_RandomNumber := 3;
    end;
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_LineValue0 := f_LineValueSeries.m_Items[f_Index];
      if (f_Index > 0) then
      begin
        f_LineValue1 := f_LineValueSeries.m_Items[f_Index - 1];
        f_LineValue0.m_Value[f_SIGNAL_SEQ] := f_LineValue1.m_Value[f_SIGNAL_SEQ];

        if (f_LineValue1.m_Value[f_SIGNAL_SEQ - 1] <> STRATEGY_BUY) and (f_LineValue0.m_Value[f_SIGNAL_SEQ - 1] = STRATEGY_BUY)
        then
        begin
          if (Random(f_RandomNumber) < 1) then
          begin
            f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
          end
          else
          begin
            f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_BUY;
          end;
        end
        else if (f_LineValue1.m_Value[f_SIGNAL_SEQ - 1] <> STRATEGY_SELL) and
            (f_LineValue0.m_Value[f_SIGNAL_SEQ - 1] = STRATEGY_SELL) then
        begin
          if (Random(f_RandomNumber) < 1) then
          begin
            f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
          end
          else
          begin
            f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_SELL;
          end;
        end
        else if (f_LineValue1.m_Value[f_SIGNAL_SEQ - 1] <> STRATEGY_EXIT) and
            (f_LineValue0.m_Value[f_SIGNAL_SEQ - 1] = STRATEGY_EXIT) then
        begin
          f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
        end;
      end
      else
      begin
        f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
      end;
    end;
  end
  else
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_LineValue0 := f_LineValueSeries.m_Items[f_Index];
      f_LineValue0.m_Value[f_SIGNAL_SEQ] := f_LineValue0.m_Value[f_SIGNAL_SEQ - 1];
    end;
  end;
{$ENDREGION}
end;

// ---------------------------------------------------------------------------
// 청산관련 모듈을 적용한다.
procedure CMXTradeStrategy.ApplyExit(p_Begin: Integer; p_End: Integer);
var
  f_Index: Integer;

  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;

  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;

  f_LineValueSeries: CMXTSLineValueSeries;
  f_SIGNAL_SEQ: Integer;
  f_Profit, f_ProfitRate, f_MaxProfit, f_CurrentProfit: Double;
  f_TargetPrice: Double;
begin
  if m_LineCollection.Count <= 0 then
    exit;
  f_LineValueSeries := m_LineCollection[m_LineCollection.Count - 1];

{$REGION '계산할 범위를 결정한다.'}
  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := m_ChartDataSeries.m_Items.Count;
  if (p_End > m_ChartDataSeries.m_Items.Count) then
    p_End := m_ChartDataSeries.m_Items.Count;
  if (p_Begin > m_ChartDataSeries.m_Items.Count - 1) then
    p_Begin := m_ChartDataSeries.m_Items.Count - 1;
  if (p_Begin < 0) then
    p_Begin := 0;
{$ENDREGION}
{$REGION '손절청산, 이익청산, Trailing Stop'}
  f_SIGNAL_SEQ := TS_SIGNAL_IDX_EXIT;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_LineValue0 := f_LineValueSeries.m_Items[f_Index];
    f_ChartData0 := m_ChartDataSeries.m_Items[f_Index];
    if (f_Index > 0) then
    begin
      f_LineValue1 := f_LineValueSeries.m_Items[f_Index - 1];
      f_ChartData1 := m_ChartDataSeries.m_Items[f_Index - 1];
      f_LineValue0.m_Value[f_SIGNAL_SEQ] := f_LineValue1.m_Value[f_SIGNAL_SEQ];

{$REGION '매수 진입'}
      if (f_LineValue0.m_Value[f_SIGNAL_SEQ - 1] = STRATEGY_BUY) and (f_LineValue1.m_Value[f_SIGNAL_SEQ - 1] <> STRATEGY_BUY)
      then
      begin
        m_EnterPrice := f_ChartData0.m_ClosePrice;
        m_MaxPrice := f_ChartData0.m_ClosePrice;
        m_TrailingStopStep := 0;
        f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_BUY;
      end;
{$ENDREGION}
{$REGION '매도 진입'}
      if (f_LineValue0.m_Value[f_SIGNAL_SEQ - 1] = STRATEGY_SELL) and (f_LineValue1.m_Value[f_SIGNAL_SEQ - 1] <> STRATEGY_SELL)
      then
      begin
        m_EnterPrice := f_ChartData0.m_ClosePrice;
        m_MaxPrice := f_ChartData0.m_ClosePrice;
        m_TrailingStopStep := 0;
        f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_SELL;
      end;
{$ENDREGION}
{$REGION '청산'}
      if (f_LineValue0.m_Value[f_SIGNAL_SEQ - 1] = STRATEGY_EXIT) and (f_LineValue1.m_Value[f_SIGNAL_SEQ - 1] <> STRATEGY_EXIT)
      then
      begin
        f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
      end;
{$ENDREGION}
{$REGION '매수 청산'}
      if (f_LineValue0.m_Value[f_SIGNAL_SEQ] = STRATEGY_BUY) then
      begin

        f_Profit := f_ChartData0.m_ClosePrice - m_EnterPrice;
        if m_EnterPrice <= 0 then
        begin
          f_ProfitRate := 0;
        end
        else
        begin
          f_ProfitRate := f_Profit * 100.0 / m_EnterPrice;
        end;

        if m_Option.GetBooleanValue('USE_LOSSCUT') and (f_ProfitRate < m_Option.GetDoubleValue('LOSSCUT_VALUE_1')) then
        begin
          f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
        end;

        if m_Option.GetBooleanValue('USE_PROFITCUT') and (f_ProfitRate > m_Option.GetDoubleValue('PROFITCUT_VALUE_1')) then
        begin
          f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
        end;

        if m_Option.GetBooleanValue('USE_TRAILINGSTOP') then
        begin
          if m_MaxPrice < f_ChartData0.m_ClosePrice then
          begin
            m_MaxPrice := f_ChartData0.m_ClosePrice;
          end;

          if 0 = m_TrailingStopStep then
          begin
            f_TargetPrice := m_EnterPrice + m_EnterPrice * m_Option.GetDoubleValue('TRAILINGSTOP_VALUE_1') / 100.0;
            if f_ChartData0.m_ClosePrice > f_TargetPrice then
            begin
              m_TrailingStopStep := 1;
            end;
          end
          else if 1 = m_TrailingStopStep then
          begin
            f_MaxProfit := m_MaxPrice - m_EnterPrice;
            f_CurrentProfit := f_ChartData0.m_ClosePrice - m_EnterPrice;
            if (f_CurrentProfit < f_MaxProfit * (100.0 - m_Option.GetDoubleValue('TRAILINGSTOP_VALUE_2')) / 100.0) then
            begin
              f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
            end;
          end;
        end;
      end;
{$ENDREGION}
{$REGION '매도 청산'}
      if (f_LineValue0.m_Value[f_SIGNAL_SEQ] = STRATEGY_SELL) then
      begin

        f_Profit := -(f_ChartData0.m_ClosePrice - m_EnterPrice);
        if m_EnterPrice <= 0 then
        begin
          f_ProfitRate := 0;
        end
        else
        begin
          f_ProfitRate := f_Profit * 100.0 / m_EnterPrice;
        end;

        if m_Option.GetBooleanValue('USE_LOSSCUT') and (f_ProfitRate < m_Option.GetDoubleValue('LOSSCUT_VALUE_1')) then
        begin
          f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
        end;

        if m_Option.GetBooleanValue('USE_PROFITCUT') and (f_ProfitRate > m_Option.GetDoubleValue('PROFITCUT_VALUE_1')) then
        begin
          f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
        end;

        if m_Option.GetBooleanValue('USE_TRAILINGSTOP') then
        begin
          if m_MaxPrice < f_ChartData0.m_ClosePrice then
          begin
            m_MaxPrice := f_ChartData0.m_ClosePrice;
          end;

          if 0 = m_TrailingStopStep then
          begin
            f_TargetPrice := m_EnterPrice - m_EnterPrice * m_Option.GetDoubleValue('TRAILINGSTOP_VALUE_1') / 100.0;
            if f_ChartData0.m_ClosePrice < f_TargetPrice then
            begin
              m_TrailingStopStep := 1;
            end;
          end
          else if 1 = m_TrailingStopStep then
          begin
            f_MaxProfit := -(m_MaxPrice - m_EnterPrice);
            f_CurrentProfit := -(f_ChartData0.m_ClosePrice - m_EnterPrice);
            if (f_CurrentProfit < f_MaxProfit * (100.0 - m_Option.GetDoubleValue('TRAILINGSTOP_VALUE_2')) / 100.0) then
            begin
              f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
            end;
          end;
        end;
      end;
{$ENDREGION}
    end
    else
    begin
      f_LineValue0.m_Value[f_SIGNAL_SEQ] := f_LineValue0.m_Value[f_SIGNAL_SEQ - 1];
    end;
  end;
{$ENDREGION}
end;

// ---------------------------------------------------------------------------
// 재진입의 지연과 일중최대횟수를 구현한다.
procedure CMXTradeStrategy.ApplyEnter(p_Begin: Integer; p_End: Integer);
var
  f_Index: Integer;
  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_LineValueSeries: CMXTSLineValueSeries;
  f_SIGNAL_SEQ: Integer;
  f_RandomNumber: Integer;
  f_VALUE: Integer;
begin
  if m_LineCollection.Count <= 0 then
    exit;
  f_LineValueSeries := m_LineCollection[m_LineCollection.Count - 1];

{$REGION '계산할 범위를 결정한다.'}
  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := m_ChartDataSeries.m_Items.Count;
  if (p_End > m_ChartDataSeries.m_Items.Count) then
    p_End := m_ChartDataSeries.m_Items.Count;
  if (p_Begin > m_ChartDataSeries.m_Items.Count - 1) then
    p_Begin := m_ChartDataSeries.m_Items.Count - 1;
  if (p_Begin < 0) then
    p_Begin := 0;
{$ENDREGION}
{$REGION '재진입시 이전 청산시 몇바뒤에 진입하도록 한다'}
  f_SIGNAL_SEQ := TS_SIGNAL_IDX_ENTER_DELAY;
  if m_Option.GetBooleanValue('USE_ENTER_DELAY') then
  begin
    f_VALUE := m_Option.GetIntegerValue('DELAY_COUNT');
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_LineValue0 := f_LineValueSeries.m_Items[f_Index];
      if (f_Index > 0) then
      begin
        f_LineValue1 := f_LineValueSeries.m_Items[f_Index - 1];
        f_LineValue0.m_Value[f_SIGNAL_SEQ] := f_LineValue1.m_Value[f_SIGNAL_SEQ];

        if (f_LineValue1.m_Value[f_SIGNAL_SEQ - 1] <> f_LineValue0.m_Value[f_SIGNAL_SEQ - 1]) and
            (f_LineValue1.m_Value[f_SIGNAL_SEQ - 1] <> STRATEGY_EXIT) then
        begin
          m_ExitIndex := f_Index;
        end;

        if (f_LineValue0.m_Value[f_SIGNAL_SEQ - 1] = STRATEGY_BUY) and (f_LineValue0.m_Value[f_SIGNAL_SEQ] <> STRATEGY_BUY) then
        begin
          if (f_Index - m_ExitIndex) >= f_VALUE then
          begin
            f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_BUY;
          end
          else
          begin
            f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
          end;
        end
        else if (f_LineValue0.m_Value[f_SIGNAL_SEQ - 1] = STRATEGY_SELL) and
            (f_LineValue0.m_Value[f_SIGNAL_SEQ] <> STRATEGY_SELL) then
        begin
          if (f_Index - m_ExitIndex) >= f_VALUE then
          begin
            f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_SELL;
          end
          else
          begin
            f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
          end;
        end;
        if (f_LineValue1.m_Value[f_SIGNAL_SEQ - 1] <> STRATEGY_EXIT) and (f_LineValue0.m_Value[f_SIGNAL_SEQ - 1] = STRATEGY_EXIT)
        then
        begin
          f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
        end;

      end
      else
      begin
        f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
      end;
    end;
  end
  else
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_LineValue0 := f_LineValueSeries.m_Items[f_Index];
      f_LineValue0.m_Value[f_SIGNAL_SEQ] := f_LineValue0.m_Value[f_SIGNAL_SEQ - 1];
    end;
  end;
{$ENDREGION}
{$REGION '1일 최대 진입횟수를 설정한다'}
  f_SIGNAL_SEQ := TS_SIGNAL_IDX_ENTER_MAXCOUNT;
  if m_Option.GetBooleanValue('USE_MAX_ENTER_COUNT') then
  begin
    f_VALUE := m_Option.GetIntegerValue('MAX_ENTER_COUNT');
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_LineValue0 := f_LineValueSeries.m_Items[f_Index];
      f_ChartData0 := m_ChartDataSeries.m_Items[f_Index];

      if (f_Index > 0) then
      begin
        f_LineValue1 := f_LineValueSeries.m_Items[f_Index - 1];
        f_ChartData1 := m_ChartDataSeries.m_Items[f_Index - 1];

        // 날짜가 변경되면 청산한다.
        if (Trunc(f_ChartData1.m_CloseDateTime) <> Trunc(f_ChartData0.m_CloseDateTime)) then
        begin
          m_EnterCount := 0;
        end;

        f_LineValue0.m_Value[f_SIGNAL_SEQ] := f_LineValue1.m_Value[f_SIGNAL_SEQ];

        if (f_LineValue1.m_Value[f_SIGNAL_SEQ - 1] <> STRATEGY_BUY) and (f_LineValue0.m_Value[f_SIGNAL_SEQ - 1] = STRATEGY_BUY)
        then
        begin
          Inc(m_EnterCount);
          if (m_EnterCount > f_VALUE) then
          begin
            f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
          end
          else
          begin
            f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_BUY;
          end;
        end
        else if (f_LineValue1.m_Value[f_SIGNAL_SEQ - 1] <> STRATEGY_SELL) and
            (f_LineValue0.m_Value[f_SIGNAL_SEQ - 1] = STRATEGY_SELL) then
        begin
          Inc(m_EnterCount);
          if (m_EnterCount > f_VALUE) then
          begin
            f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
          end
          else
          begin
            f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_SELL;
          end;
        end
        else if (f_LineValue1.m_Value[f_SIGNAL_SEQ - 1] <> STRATEGY_EXIT) and
            (f_LineValue0.m_Value[f_SIGNAL_SEQ - 1] = STRATEGY_EXIT) then
        begin
          f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
        end;

      end
      else
      begin
        f_LineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
      end;
    end;
  end
  else
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_LineValue0 := f_LineValueSeries.m_Items[f_Index];
      f_LineValue0.m_Value[f_SIGNAL_SEQ] := f_LineValue0.m_Value[f_SIGNAL_SEQ - 1];
    end;
  end;
{$ENDREGION}
end;
{$ENDREGION}

// ---------------------------------------------------------------------------
// 최종신호를 추출한다.
procedure CMXTradeStrategy.ScanSignal(p_SignalArray: CMKSignalArray);
var
  f_LineValueSeries: CMXTSLineValueSeries;
  f_StartIndex, f_StopIndex: Integer;
  f_SIGNAL_SEQ: Integer;
begin
  f_SIGNAL_SEQ := TS_SIGNAL_IDX_FINAL;
  f_StartIndex := 0;
  f_StopIndex := m_ChartDataSeries.m_Items.Count - 1;

  if m_LineCollection.Count <= 0 then
    exit;
  f_LineValueSeries := m_LineCollection[m_LineCollection.Count - 1];
  f_LineValueSeries.ScanSignalOfRealTime(m_ChartDataSeries, p_SignalArray, f_SIGNAL_SEQ, f_StartIndex, f_StopIndex);
end;

// ---------------------------------------------------------------------------
// 내부 옵션이 변경되어 계산내용이 변경되었을 때 발생하는 이벤트
procedure CMXTradeStrategy.OnChangedOption(Sender: TObject);
begin
  Calculate(true);
  if Assigned(m_OnChanged) then
    m_OnChanged(Sender);
end;

// ---------------------------------------------------------------------------
// 가격을 대신할 지표로, 가격, OPS, OPS2중에 선택한다.
procedure CMXTradeStrategy.SetMajorValueType(AValue: Integer);
begin
  m_Option.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, AValue);
  Calculate(true);
end;

// ---------------------------------------------------------------------------
function CMXTradeStrategy.GetMajorValueType: Integer;
begin
  Result := m_Option.GetIntegerValue(TSOPTION_KEY_MAJORVALUE);
end;

{$REGION '옵션의 값을 읽어오는 함수'}

// ---------------------------------------------------------------------------
function CMXTradeStrategy.GetStringOptionValue(AKey: String): String;
begin
  Result := m_Option.GetStringValue(AKey);
end;

// ---------------------------------------------------------------------------
function CMXTradeStrategy.GetIntegerOptionValue(AKey: String): Integer;
begin
  Result := m_Option.GetIntegerValue(AKey);
end;

// ---------------------------------------------------------------------------
function CMXTradeStrategy.GetDoubleOptionValue(AKey: String): Double;
begin
  Result := m_Option.GetDoubleValue(AKey);
end;

// ---------------------------------------------------------------------------
function CMXTradeStrategy.GetBooleanOptionValue(AKey: String): Boolean;
begin
  Result := m_Option.GetBooleanValue(AKey);
end;
{$ENDREGION}
{$REGION '옵션의 값을 저장하는 함수'}

// ---------------------------------------------------------------------------
procedure CMXTradeStrategy.SetStringOptionValue(AKey: String; AValue: String);
begin
  m_Option.SetStringValue(AKey, AValue);
end;

// ---------------------------------------------------------------------------
procedure CMXTradeStrategy.SetIntegerOptionValue(AKey: String; AValue: Integer);
begin
  m_Option.SetIntegerValue(AKey, AValue);
end;

// ---------------------------------------------------------------------------
procedure CMXTradeStrategy.SetDoubleOptionValue(AKey: String; AValue: Double);
begin
  m_Option.SetDoubleValue(AKey, AValue);
end;

// ---------------------------------------------------------------------------
procedure CMXTradeStrategy.SetBooleanOptionValue(AKey: String; AValue: Boolean);
begin
  m_Option.SetBooleanValue(AKey, AValue);
end;
{$ENDREGION}
{$REGION '라인시리즈의 객체를 종류별로 생성하여 리턴한다'}

// ---------------------------------------------------------------------------
class function CMXTradeStrategy.Creator_MajorLineValueSeries: CMXTSLineValueSeries;
var
  f_Line: CMXTSLineValueSeries;
begin
  f_Line := CMXTSLineValueSeries.Create('PRICE', CMKConst.LINESERIES_PRICE, 12, 1, 0, 0);
  f_Line.m_ViewLabel := false;

  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;
  f_Line.m_LineVisibles[3] := true;
  f_Line.m_LineVisibles[4] := false;
  f_Line.m_LineVisibles[5] := false;
  f_Line.m_LineVisibles[6] := false;
  f_Line.m_LineVisibles[7] := false;
  f_Line.m_LineVisibles[8] := false;
  f_Line.m_LineVisibles[9] := false;
  f_Line.m_LineVisibles[10] := false;
  f_Line.m_LineVisibles[11] := false;

  f_Line.m_LineColors[0] := CMKColorSet.PRICE_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.PRICE_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.PRICE_COLOR;
  f_Line.m_LineColors[3] := CMKColorSet.PRICE_COLOR;
  f_Line.m_LineColors[4] := CMKColorSet.PRICE_COLOR;
  f_Line.m_LineColors[5] := CMKColorSet.PRICE_COLOR;
  f_Line.m_LineColors[6] := CMKColorSet.PRICE_COLOR;
  f_Line.m_LineColors[7] := CMKColorSet.PRICE_COLOR;
  f_Line.m_LineColors[8] := CMKColorSet.PRICE_COLOR;
  f_Line.m_LineColors[9] := CMKColorSet.PRICE_COLOR;
  f_Line.m_LineColors[10] := CMKColorSet.PRICE_COLOR;
  f_Line.m_LineColors[11] := CMKColorSet.PRICE_COLOR;
  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMXTradeStrategy.Creator_RSI: CMXTSLineValueSeries;
var
  f_Line: CMXTSLineValueSeries;
begin
  f_Line := CMXTSLineValueSeries.Create('RSI', CMKConst.LINESERIES_RSI, 1, 1, 2);
  f_Line.m_FullName := '';
  f_Line.m_LineNames[0] := 'RSI';
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;

  f_Line.m_Values[0] := 25.0;
  f_Line.m_Values[1] := 75.0;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMXTradeStrategy.Creator_AnyLineValueSeries(ALineCount: Integer): CMXTSLineValueSeries;
var
  f_Line: CMXTSLineValueSeries;
  f_Index: Integer;
begin
  f_Line := CMXTSLineValueSeries.Create('', CMKConst.LINESERIES_CCI, ALineCount, 0, 0);
  f_Line.m_FullName := '';

  for f_Index := 0 to ALineCount - 1 do
  begin
    f_Line.m_LineNames[f_Index] := '';
    f_Line.m_LineWidths[f_Index] := 0;
    f_Line.m_LineColors[f_Index] := CMKColorSet.IND_LINE1_COLOR + f_Index;
    f_Line.m_LineAlphas[f_Index] := CMKColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineVisibles[f_Index] := true;
  end;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMXTradeStrategy.Creator_AnySignalValueSeries(ALineCount: Integer): CMXTSLineValueSeries;
var
  f_Line: CMXTSLineValueSeries;
  f_Index: Integer;
begin
  f_Line := CMXTSLineValueSeries.Create('', CMKConst.LINESERIES_CCI, ALineCount, 0, 0);
  f_Line.m_FullName := '';

  for f_Index := 0 to ALineCount - 1 do
  begin
    f_Line.m_LineNames[f_Index] := '';
    f_Line.m_LineWidths[f_Index] := 1;
    f_Line.m_LineTypes[f_Index] := 4;
    f_Line.m_LineColors[f_Index] := CMKColorSet.IND_LINE1_COLOR + f_Index;
    f_Line.m_LineAlphas[f_Index] := CMKColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineVisibles[f_Index] := true;
  end;
  f_Line.m_TradeStrategySignal := true;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMXTradeStrategy.Creator_BBWidth: CMXTSLineValueSeries;
var
  f_Line: CMXTSLineValueSeries;
begin
  f_Line := CMXTSLineValueSeries.Create('Band Width', CMKConst.LINESERIES_BBWIDTH, 4, 2, 0);
  f_Line.m_FullName := 'Bollinger Band Width';
  f_Line.m_LineNames[0] := 'Band Width';
  f_Line.m_LineNames[1] := '';
  f_Line.m_LineNames[2] := '';
  f_Line.m_LineNames[3] := '';
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := false;
  f_Line.m_LineVisibles[3] := false;
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelVisibles[1] := true;
  f_Line.m_LineLabelVisibles[2] := false;
  f_Line.m_LineLabelVisibles[3] := false;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineLabelNameVisibles[1] := false;
  f_Line.m_LineLabelNameVisibles[2] := false;
  f_Line.m_LineLabelNameVisibles[3] := false;

  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMXTradeStrategy.Creator_BBand: CMXTSLineValueSeries;
var
  f_Line: CMXTSLineValueSeries;
begin
  f_Line := CMXTSLineValueSeries.Create('', CMKConst.LINESERIES_BB, 4, 2, 0, 0);
  f_Line.m_FullName := 'Bollinger Band';
  f_Line.m_LineNames[0] := 'U';
  f_Line.m_LineNames[1] := 'L';
  f_Line.m_LineNames[2] := 'M';
  f_Line.m_LineNames[3] := '';
  f_Line.m_LineTypes[0] := 0;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;
  f_Line.m_LineTypes[3] := 0;
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;
  f_Line.m_LineWidths[3] := 0;
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;
  f_Line.m_LineVisibles[3] := false;
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelVisibles[1] := true;
  f_Line.m_LineLabelVisibles[2] := true;
  f_Line.m_LineLabelVisibles[3] := false;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineLabelNameVisibles[1] := false;
  f_Line.m_LineLabelNameVisibles[2] := false;
  f_Line.m_LineLabelNameVisibles[3] := false;
  f_Line.m_Precision := 2;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := 21;
  f_Line.m_LineColors[3] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_LIGHT_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_LIGHT_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[3] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMXTradeStrategy.Creator_IMLine: CMXTSLineValueSeries;
var
  f_Line: CMXTSLineValueSeries;
begin
  f_Line := CMXTSLineValueSeries.Create('일목균형표', CMKConst.LINESERIES_ILMOK, 4, 3, 0, 0);
  f_Line.m_LineNames[0] := '전환';
  f_Line.m_LineNames[1] := '기준';
  f_Line.m_LineNames[2] := '선행1';
  f_Line.m_LineNames[3] := '선행2';

  f_Line.m_LineColors[0] := 35;
  f_Line.m_LineColors[1] := 36;
  f_Line.m_LineColors[2] := 37;
  f_Line.m_LineColors[3] := 38;

  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[3] := CMKColorSet.ALPHA_DARK_LINE;

  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;
  f_Line.m_LineWidths[3] := 0;

  f_Line.m_Precision := 2;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMXTradeStrategy.Creator_SlowSTC: CMXTSLineValueSeries;
var
  f_Line: CMXTSLineValueSeries;
begin
  f_Line := CMXTSLineValueSeries.Create('Slow Stochastics', CMKConst.LINESERIES_SLOWSTC, 3, 3, 2);
  f_Line.m_FullName := 'Slow Stochastics';
  f_Line.m_LineNames[0] := 'Fast %K';
  f_Line.m_LineNames[1] := 'Slow %K';
  f_Line.m_LineNames[2] := 'Slow %D';
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;

  f_Line.m_Values[0] := 20.0;
  f_Line.m_Values[1] := 80.0;

  Result := f_Line;
end;
{$ENDREGION}

// ---------------------------------------------------------------------------
procedure CMXTradeStrategy.CreateReinforceLineValueSeries(var AChartBlockCount: Integer);
var
  f_LineValueSeries: CMXTSLineValueSeries;
begin
  m_REINFORCE_LINE_ZERO := m_LineCollection.Count;

  m_REINFORCE1_LINE_ZERO := m_LineCollection.Count;

  f_LineValueSeries := Creator_AnyLineValueSeries(1);
  f_LineValueSeries.m_Name := '보강조건1 기준선';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := AChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);

  f_LineValueSeries := Creator_AnyLineValueSeries(9);
  f_LineValueSeries.m_Name := '보강조건1 가격선';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := AChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(AChartBlockCount);

  f_LineValueSeries := Creator_MajorLineValueSeries;
  f_LineValueSeries.m_Name := '보강조건1';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := -1;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);

  m_REINFORCE2_LINE_ZERO := m_LineCollection.Count;

  f_LineValueSeries := Creator_AnyLineValueSeries(3);
  f_LineValueSeries.m_Name := '보강조건2';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := -1;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);

end;

// ---------------------------------------------------------------------------
procedure CMXTradeStrategy.CreateReinforceSignalLineValueSeries(var AChartBlockCount: Integer);
var
  f_LineValueSeries: CMXTSLineValueSeries;
  f_Index: Integer;
begin
  m_REINFORCE_SIGNAL_LINE_ZERO := m_LineCollection.Count;

  f_LineValueSeries := Creator_AnySignalValueSeries(2);
  f_LineValueSeries.m_Name := '보강조건1 신호';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := AChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(AChartBlockCount);

  f_LineValueSeries := Creator_AnySignalValueSeries(2);
  f_LineValueSeries.m_Name := '보강조건2 신호';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := AChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(AChartBlockCount);

  f_LineValueSeries := Creator_AnySignalValueSeries(2);
  f_LineValueSeries.m_Name := '보강조건3 신호';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := AChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(AChartBlockCount);
end;

// ---------------------------------------------------------------------------
// 두번째 보조지표에서 각 경우에 따라 사용할 라인을 지정한다.
function CMXTradeStrategy.GetPMUpperLine(APrefix: String): Integer;
begin
  // 종가를 사용
  if (m_Option.GetIntegerValue(APrefix + 'PRICEMETHOD') = 0) then
  begin
    Result := 0;
  end
  else
    // 고가와 저가를 사용
    if (m_Option.GetIntegerValue(APrefix + 'PRICEMETHOD') = 1) then
    begin
      Result := 1;
    end
    else
      // (고가 + 저가) / 2 사용
      if (m_Option.GetIntegerValue(APrefix + 'PRICEMETHOD') = 2) then
      begin
        Result := 4;
      end
      else
      // 볼랜저밴드를 사용
      begin
        Result := 5;
      end;
end;

// ---------------------------------------------------------------------------
// 두번째 보조지표에서 각 경우에 따라 사용할 라인을 지정한다.
function CMXTradeStrategy.GetPMDownLine(APrefix: String): Integer;
begin
  // 종가를 사용
  if (m_Option.GetIntegerValue(APrefix + 'PRICEMETHOD') = 0) then
  begin
    Result := 0;
  end
  else
    // 고가와 저가를 사용
    if (m_Option.GetIntegerValue(APrefix + 'PRICEMETHOD') = 1) then
    begin
      Result := 2;
    end
    else
      // (고가 + 저가) / 2 사용
      if (m_Option.GetIntegerValue(APrefix + 'PRICEMETHOD') = 2) then
      begin
        Result := 4;
      end
      else
      // 볼랜저밴드를 사용
      begin
        Result := 6;
      end;
end;

// ---------------------------------------------------------------------------
// 옵션이 변경되어 재계산이 될 때 화면에 표시한 것들중에 옵션에 관련된 사항들을 적용한다.
procedure CMXTradeStrategy.UpdateVisibleStateOfReinforceLineValueSeries;
var
  f_LineValueSeries: CMXTSLineValueSeries;
  f_Index: Integer;
begin
  f_LineValueSeries := m_LineCollection.Items[m_REINFORCE_LINE_ZERO + 1];

  for f_Index := 0 to f_LineValueSeries.m_LineCount - 1 do
  begin
    f_LineValueSeries.m_LineVisibles[f_Index] := false;
  end;

  // 종가를 사용
  if (m_Option.GetIntegerValue('RF1_PRICEMETHOD') = 0) then
  begin
    f_LineValueSeries.m_LineVisibles[0] := true;
    f_LineValueSeries.m_LineColors[0] := 30
  end
  else
    // 고가와 저가를 사용
    if (m_Option.GetIntegerValue('RF1_PRICEMETHOD') = 1) then
    begin
      f_LineValueSeries.m_LineVisibles[1] := true;
      f_LineValueSeries.m_LineVisibles[2] := true;
      f_LineValueSeries.m_LineColors[1] := 30;
      f_LineValueSeries.m_LineColors[2] := 31;
    end
    else
      // (고가 + 저가) / 2 사용
      if (m_Option.GetIntegerValue('RF1_PRICEMETHOD') = 2) then
      begin
        f_LineValueSeries.m_LineVisibles[4] := true;
        f_LineValueSeries.m_LineColors[4] := 30;
      end
      else
      // 볼랜저밴드를 사용
      begin
        f_LineValueSeries.m_LineVisibles[5] := true;
        f_LineValueSeries.m_LineVisibles[6] := true;
        f_LineValueSeries.m_LineColors[5] := 30;
        f_LineValueSeries.m_LineColors[6] := 31;
      end;
end;

// ---------------------------------------------------------------------------
procedure CMXTradeStrategy.CalculateReinforce(p_Begin: Integer; p_End: Integer);
var
  f_STD_VALUE: Integer;
  f_VALUE_TYPE: Integer;
  f_LineValueSeries: CMXTSLineValueSeries;
  f_PLineValueSeries: CMXTSLineValueSeries;
  f_Index, f_SX, f_EX: Integer;
  f_Precision: Integer;
  f_Factor: Double;
  f_Tolerance: Double;
  f_ChartData0: CMKChartData;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
begin
{$REGION '보강조건1'}
  f_STD_VALUE := m_Option.GetIntegerValue('RF1_STD_VALUE');
  f_VALUE_TYPE := m_Option.GetIntegerValue('RF1_VALUE_TYPE');

{$REGION '두번째 보조지표를 계산한다'}
  f_LineValueSeries := m_LineCollection.Items[m_REINFORCE1_LINE_ZERO];
  f_LineValueSeries.m_Precision := m_ChartDataSeries.m_Precision;

  if f_STD_VALUE = 0 then
  begin
    f_LineValueSeries.TS_DayC(m_ChartDataSeries, m_DayChartDataSeries, 1, f_VALUE_TYPE, 0, p_Begin, p_End);
  end
  else
  begin
    f_LineValueSeries.TS_DayO(m_ChartDataSeries, m_DayChartDataSeries, 0, f_VALUE_TYPE, 0, p_Begin, p_End);
  end;
{$ENDREGION}
{$REGION '네번째 임시보조지표를 계산한다'}
  f_PLineValueSeries := m_LineCollection.Items[m_REINFORCE1_LINE_ZERO + 2];
  f_PLineValueSeries.TS_MajorLine2(f_VALUE_TYPE, m_ChartDataSeries, p_Begin, p_End);
{$ENDREGION}
{$REGION '세번째 보조지표를 계산한다'}
  f_LineValueSeries := m_LineCollection.Items[m_REINFORCE1_LINE_ZERO + 1];
  f_LineValueSeries.m_Precision := m_ChartDataSeries.m_Precision;

  // 종가의 이평
  if (m_Option.GetIntegerValue('RF1_PM1_V2') = 0) then
  begin
    f_LineValueSeries.TS_NAverage(m_Option.GetIntegerValue('RF1_PM1_V1'), f_PLineValueSeries, 1, 0, p_Begin, p_End);
  end
  else if (m_Option.GetIntegerValue('RF1_PM1_V2') = 1) then
  begin
    f_LineValueSeries.TS_WAverage(m_Option.GetIntegerValue('RF1_PM1_V1'), f_PLineValueSeries, 1, 0, p_Begin, p_End);
  end
  else
  begin
    f_LineValueSeries.TS_XAverage(m_Option.GetIntegerValue('RF1_PM1_V1'), f_PLineValueSeries, 1, 0, p_Begin, p_End);
  end;

  if (m_Option.GetIntegerValue('RF1_PM2_V2') = 0) then
  begin
    // 고가의 이평
    f_LineValueSeries.TS_NAverage(m_Option.GetIntegerValue('RF1_PM2_V1'), f_PLineValueSeries, 1, 1, p_Begin, p_End);
    // 저가의 이평
    f_LineValueSeries.TS_NAverage(m_Option.GetIntegerValue('RF1_PM2_V1'), f_PLineValueSeries, 2, 2, p_Begin, p_End);
  end
  else if (m_Option.GetIntegerValue('RF1_PM2_V2') = 1) then
  begin
    // 고가의 이평
    f_LineValueSeries.TS_WAverage(m_Option.GetIntegerValue('RF1_PM2_V1'), f_PLineValueSeries, 1, 1, p_Begin, p_End);
    // 저가의 이평
    f_LineValueSeries.TS_WAverage(m_Option.GetIntegerValue('RF1_PM2_V1'), f_PLineValueSeries, 2, 2, p_Begin, p_End);
  end
  else
  begin
    // 고가의 이평
    f_LineValueSeries.TS_XAverage(m_Option.GetIntegerValue('RF1_PM2_V1'), f_PLineValueSeries, 1, 1, p_Begin, p_End);
    // 저가의 이평
    f_LineValueSeries.TS_XAverage(m_Option.GetIntegerValue('RF1_PM2_V1'), f_PLineValueSeries, 2, 2, p_Begin, p_End);
  end;

  f_LineValueSeries.TS_HLPrice(f_PLineValueSeries, 1, 2, 3, p_Begin, p_End);
  // (H+L)/2 이평
  if (m_Option.GetIntegerValue('RF1_PM3_V2') = 0) then
  begin
    f_LineValueSeries.TS_NAverage(m_Option.GetIntegerValue('RF1_PM3_V1'), f_LineValueSeries, 3, 4, p_Begin, p_End);
  end
  else if (m_Option.GetIntegerValue('RF1_PM3_V2') = 1) then
  begin
    f_LineValueSeries.TS_WAverage(m_Option.GetIntegerValue('RF1_PM3_V1'), f_LineValueSeries, 3, 4, p_Begin, p_End);
  end
  else
  begin
    f_LineValueSeries.TS_XAverage(m_Option.GetIntegerValue('RF1_PM3_V1'), f_LineValueSeries, 3, 4, p_Begin, p_End);
  end;

  f_LineValueSeries.TS_BBand(m_Option.GetIntegerValue('RF1_PM4_V1'), m_Option.GetDoubleValue('RF1_PM4_V2'), f_PLineValueSeries,
      3, 5, p_Begin, p_End);
{$ENDREGION}
{$ENDREGION}
{$REGION '보강조건2'}
  f_LineValueSeries := m_LineCollection.Items[m_REINFORCE2_LINE_ZERO];
  f_SX := f_LineValueSeries.m_Items.Count - 1;
  f_EX := m_DayChartDataSeries.m_Items.Count;
  f_LineValueSeries.m_Precision := m_ChartDataSeries.m_Precision;

{$REGION '계산할 범위를 결정한다.'}
  if (f_SX = -1) then
    f_SX := 0;
  if (f_EX = -1) then
    f_EX := m_DayChartDataSeries.m_Items.Count;
  if (f_EX > m_DayChartDataSeries.m_Items.Count) then
    f_EX := m_DayChartDataSeries.m_Items.Count;

  if (f_SX > m_DayChartDataSeries.m_Items.Count - 1) then
    f_SX := m_DayChartDataSeries.m_Items.Count - 1;
  if (f_SX < 0) then
    f_SX := 0;
{$ENDREGION}
  f_LineValueSeries.m_Effect := true;
  f_LineValueSeries.SetLengthSeries(m_DayChartDataSeries.m_Items.Count);

  f_Precision := m_ChartDataSeries.m_Precision;
  if f_Precision <= 0 then
    f_Precision := 0;
  f_Factor := Math.Power(10, f_Precision);

{$REGION '시가를 추출한다'}
  f_VALUE_TYPE := m_Option.GetIntegerValue('RF2_VALUE_TYPE');
  for f_Index := f_SX to f_EX - 1 do
  begin
    f_LineValue0 := f_LineValueSeries.m_Items[f_Index];
    f_ChartData0 := m_DayChartDataSeries.m_Items[f_Index];
    if (0 = f_VALUE_TYPE) then
    begin
      f_LineValue0.m_Value[0] := Round(f_ChartData0.m_OpenPrice * f_Factor) / f_Factor;
    end
    else
    begin
      f_LineValue0.m_Value[0] := Round(f_ChartData0.m_OpenOPS * f_Factor) / f_Factor;
    end;
  end;
{$ENDREGION}
{$REGION '이평을 계산한다'}
  f_Precision := m_Option.GetIntegerValue('RF2_PRECISION');
  if (f_Precision <= 0) then
    f_Precision := m_ChartDataSeries.m_Precision + 2;

  // 종가의 이평
  if (m_Option.GetIntegerValue('RF2_AVERAGE_TYPE') = 0) then
  begin
    f_LineValueSeries.TS_NAverageP(m_Option.GetIntegerValue('RF2_LENGTH'), f_Precision + 2, f_LineValueSeries, 0, 1,
        f_SX, f_EX);
  end
  else if (m_Option.GetIntegerValue('RF2_AVERAGE_TYPE') = 1) then
  begin
    f_LineValueSeries.TS_WAverageP(m_Option.GetIntegerValue('RF2_LENGTH'), f_Precision + 2, f_LineValueSeries, 0, 1,
        f_SX, f_EX);
  end
  else
  begin
    f_LineValueSeries.TS_XAverageP(m_Option.GetIntegerValue('RF2_LENGTH'), f_Precision + 2, f_LineValueSeries, 0, 1,
        f_SX, f_EX);
  end;
{$ENDREGION}
{$REGION '신호를 계산한다'}
  f_Tolerance := 5.0 / Math.Power(10, f_Precision);
  for f_Index := f_SX to f_EX - 1 do
  begin
    f_LineValue0 := f_LineValueSeries.m_Items[f_Index];
    if (f_Index >= 1) then
    begin
      f_LineValue1 := f_LineValueSeries.m_Items[f_Index - 1];
      if ((f_LineValue0.m_Value[1] - f_LineValue1.m_Value[1] > f_Tolerance)) then
      begin
        f_LineValue0.m_Value[2] := 1;
      end
      else if ((f_LineValue0.m_Value[1] - f_LineValue1.m_Value[1] < -f_Tolerance)) then
      begin
        f_LineValue0.m_Value[2] := -1;
      end
      else
      begin
        f_LineValue0.m_Value[2] := f_LineValue1.m_Value[2];
      end;
    end
    else
    begin
      f_LineValue0.m_Value[2] := 0;
    end;
  end;
{$ENDREGION}
{$ENDREGION}
end;

// ---------------------------------------------------------------------------
procedure CMXTradeStrategy.CalulateReinforceSignal(p_Begin: Integer; p_End: Integer);
var
  f_Index: Integer;
  f_SigSeq: Integer;

  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;

  f_SourceLineValue0: CMKLineValue;
  f_SourceLineValue1: CMKLineValue;

  f_PMLineValue0: CMKLineValue;
  f_PMLineValue1: CMKLineValue;

  f_SigLineValue0: CMKLineValue;
  f_SigLineValue1: CMKLineValue;

  f_LineValueSeries0: CMXTSLineValueSeries;
  f_LineValueSeries1: CMXTSLineValueSeries;
  f_LineValueSeries2: CMXTSLineValueSeries;

  f_SignalValueSeries0: CMXTSLineValueSeries;
  f_SignalValueSeries1: CMXTSLineValueSeries;
  f_SignalValueSeries2: CMXTSLineValueSeries;
  f_SignalValueSeries3: CMXTSLineValueSeries;

  f_MAUP_0_IDX, f_MADN_0_IDX: Integer;
  f_STD_VALUE, f_VALUE_TYPE: Integer;
  f_SearchIndex: Integer;
  f_NonTrendStrategy: Boolean;

  f_TargetValue: Double;
  f_UseTolerance: Boolean;
  f_Tolerance: Double;
  f_ToleranceUnit: Integer;
begin
  if not Assigned(m_ChartDataSeries) then
    exit;

{$REGION '계산할 범위를 결정한다.'}
  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := m_ChartDataSeries.m_Items.Count;
  if (p_End > m_ChartDataSeries.m_Items.Count) then
    p_End := m_ChartDataSeries.m_Items.Count;

  if (p_Begin > m_ChartDataSeries.m_Items.Count - 1) then
    p_Begin := m_ChartDataSeries.m_Items.Count - 1;
  if (p_Begin < 0) then
    p_Begin := 0;
{$ENDREGION}
{$REGION '보조지표의 객체를 연결'}
  f_LineValueSeries0 := m_LineCollection.Items[m_REINFORCE1_LINE_ZERO + 0];
  f_LineValueSeries1 := m_LineCollection.Items[m_REINFORCE1_LINE_ZERO + 1];
  f_LineValueSeries2 := m_LineCollection.Items[m_REINFORCE2_LINE_ZERO + 0]; // m_REINFORCE2_LINE_ZERO
  f_SignalValueSeries0 := m_LineCollection.Items[m_REINFORCE_SIGNAL_LINE_ZERO + 0];
  f_SignalValueSeries1 := m_LineCollection.Items[m_REINFORCE_SIGNAL_LINE_ZERO + 1];
  f_SignalValueSeries2 := m_LineCollection.Items[m_REINFORCE_SIGNAL_LINE_ZERO + 2];
  f_SignalValueSeries3 := m_LineCollection.Items[m_REINFORCE_SIGNAL_LINE_ZERO + 3];

  f_SignalValueSeries0.SetLengthSeries(m_ChartDataSeries.m_Items.Count);
  f_SignalValueSeries1.SetLengthSeries(m_ChartDataSeries.m_Items.Count);
  f_SignalValueSeries2.SetLengthSeries(m_ChartDataSeries.m_Items.Count);
  f_SignalValueSeries3.SetLengthSeries(m_ChartDataSeries.m_Items.Count);
{$ENDREGION}
{$REGION '계산에 필요한 변수 초기화'}
  f_MAUP_0_IDX := GetPMUpperLine('RF1_');
  f_MADN_0_IDX := GetPMDownLine('RF1_');
  f_STD_VALUE := m_Option.GetIntegerValue('RF1_STD_VALUE');
  f_VALUE_TYPE := m_Option.GetIntegerValue('RF1_VALUE_TYPE');
{$ENDREGION}
{$REGION '보강조건 1 의 신호를 계산한다'}
  f_UseTolerance := m_Option.GetBooleanValue('RF1_USE_TOLERANCE');
  f_Tolerance := m_Option.GetDoubleValue('RF1_TOLERANCE');
  f_ToleranceUnit := m_Option.GetIntegerValue('RF1_TOLERANCE_UNIT');
  f_SigSeq := 1;
  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SourceLineValue0 := f_LineValueSeries0.m_Items[f_Index];
    f_PMLineValue0 := f_LineValueSeries1.m_Items[f_Index];
    f_SigLineValue0 := f_SignalValueSeries0.m_Items[f_Index];
    f_ChartData0 := m_ChartDataSeries.m_Items[f_Index];

    if (f_Index > 0) then
    begin
      f_SourceLineValue1 := f_LineValueSeries0.m_Items[f_Index - 1];
      f_PMLineValue1 := f_LineValueSeries1.m_Items[f_Index - 1];
      f_SigLineValue1 := f_SignalValueSeries0.m_Items[f_Index - 1];

      f_SigLineValue0.m_Value[f_SigSeq] := f_SigLineValue1.m_Value[f_SigSeq];

      if ((f_SourceLineValue0.m_Value[0] <> NOT_VALUE) AND (f_SourceLineValue1.m_Value[0] <> NOT_VALUE) AND
          (f_PMLineValue0.m_Value[f_MAUP_0_IDX] <> NOT_VALUE) AND (f_PMLineValue0.m_Value[f_MADN_0_IDX] <> NOT_VALUE)) then
      begin

        if (f_SigLineValue0.m_Value[f_SigSeq] <> STRATEGY_BUY) then
        begin
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue := f_SourceLineValue0.m_Value[0] + ((f_Tolerance / 100.0) * f_SourceLineValue0.m_Value[0]);
            end
            else
            begin
              f_TargetValue := f_SourceLineValue0.m_Value[0] + f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue := f_SourceLineValue0.m_Value[0];
          end;

          if (f_TargetValue < f_PMLineValue0.m_Value[f_MADN_0_IDX]) then
          begin
            f_SigLineValue0.m_Value[f_SigSeq] := STRATEGY_BUY;
          end
        end;

        if (f_SigLineValue0.m_Value[f_SigSeq] <> STRATEGY_SELL) then
        begin
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue := f_SourceLineValue0.m_Value[0] - ((f_Tolerance / 100.0) * f_SourceLineValue0.m_Value[0]);
            end
            else
            begin
              f_TargetValue := f_SourceLineValue0.m_Value[0] - f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue := f_SourceLineValue0.m_Value[0];
          end;

          if (f_TargetValue > f_PMLineValue0.m_Value[f_MAUP_0_IDX]) then
          begin
            f_SigLineValue0.m_Value[f_SigSeq] := STRATEGY_SELL;
          end;
        end;

      end;
    end
    else
    begin
      f_SigLineValue0.m_Value[f_SigSeq] := STRATEGY_EXIT;
    end;
  end;
{$ENDREGION}
{$REGION '2시그마의 1번과 2번을 교집합 처리한다.'}
  if m_Option.GetBooleanValue('RF1_USE_CONDITION') then
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_SigLineValue0 := f_SignalValueSeries0.m_Items[f_Index];
      f_SigLineValue1 := f_SignalValueSeries1.m_Items[f_Index];

      if ((f_SigLineValue0.m_Value[0] <> NOT_VALUE) AND (f_SigLineValue0.m_Value[1] <> NOT_VALUE)) then
      begin
        if (f_SigLineValue0.m_Value[0] = STRATEGY_BUY) and (f_SigLineValue0.m_Value[1] = STRATEGY_BUY) then
        begin
          f_SigLineValue1.m_Value[0] := STRATEGY_BUY;
        end
        else if (f_SigLineValue0.m_Value[0] = STRATEGY_SELL) and (f_SigLineValue0.m_Value[1] = STRATEGY_SELL) then
        begin
          f_SigLineValue1.m_Value[0] := STRATEGY_SELL;
        end
        else
        begin
          f_SigLineValue1.m_Value[0] := STRATEGY_EXIT;
        end;
      end;
    end;
  end
  else
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_SigLineValue0 := f_SignalValueSeries0.m_Items[f_Index];
      f_SigLineValue1 := f_SignalValueSeries1.m_Items[f_Index];
      f_SigLineValue1.m_Value[0] := f_SigLineValue0.m_Value[0];
    end;
  end;
{$ENDREGION}
  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SigLineValue0 := f_SignalValueSeries1.m_Items[f_Index];
    f_ChartData0 := m_ChartDataSeries.m_Items[f_Index];
    f_SearchIndex := m_DayChartDataSeries.SearchDayByClose(f_ChartData0.m_OpenDateTime, true);
    if (f_SearchIndex >= 0) then
    begin
      f_SigLineValue1 := f_LineValueSeries2.m_Items[f_SearchIndex];
      f_SigLineValue0.m_Value[1] := f_SigLineValue1.m_Value[2];
    end
    else
    begin
      f_SigLineValue0.m_Value[1] := 0;
    end;
  end;

{$REGION '보강조건 2 의 신호를 계산한다'}
  if m_Option.GetBooleanValue('RF2_USE_CONDITION') then
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_SigLineValue0 := f_SignalValueSeries1.m_Items[f_Index];
      f_SigLineValue1 := f_SignalValueSeries2.m_Items[f_Index];

      if ((f_SigLineValue0.m_Value[0] <> NOT_VALUE) AND (f_SigLineValue0.m_Value[1] <> NOT_VALUE)) then
      begin
        if (f_SigLineValue0.m_Value[0] = STRATEGY_BUY) and (f_SigLineValue0.m_Value[1] = STRATEGY_BUY) then
        begin
          f_SigLineValue1.m_Value[0] := STRATEGY_BUY;
        end
        else if (f_SigLineValue0.m_Value[0] = STRATEGY_SELL) and (f_SigLineValue0.m_Value[1] = STRATEGY_SELL) then
        begin
          f_SigLineValue1.m_Value[0] := STRATEGY_SELL;
        end
        else
        begin
          f_SigLineValue1.m_Value[0] := STRATEGY_EXIT;
        end;
      end;
    end;
  end
  else
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_SigLineValue0 := f_SignalValueSeries1.m_Items[f_Index];
      f_SigLineValue1 := f_SignalValueSeries2.m_Items[f_Index];
      f_SigLineValue1.m_Value[0] := f_SigLineValue0.m_Value[0];
    end;
  end;
{$ENDREGION}
  if (0 <> Pos('-N', m_Category)) then
    f_NonTrendStrategy := true
  else
    f_NonTrendStrategy := false;

{$REGION '보강조건 3 의 신호를 계산한다'}
  if f_NonTrendStrategy and m_Option.GetBooleanValue('RF3_USE_CONDITION') then
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_SigLineValue0 := f_SignalValueSeries2.m_Items[f_Index];
      f_SigLineValue1 := f_SignalValueSeries3.m_Items[f_Index];
      if ((f_SigLineValue0.m_Value[0] <> NOT_VALUE)) then
      begin
        if (f_SigLineValue0.m_Value[0] = STRATEGY_BUY) then
        begin
          f_SigLineValue1.m_Value[0] := STRATEGY_SELL;
        end
        else if (f_SigLineValue0.m_Value[0] = STRATEGY_SELL) then
        begin
          f_SigLineValue1.m_Value[0] := STRATEGY_BUY;
        end
        else
        begin
          f_SigLineValue1.m_Value[0] := STRATEGY_EXIT;
        end;
      end;
    end;
  end
  else
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_SigLineValue0 := f_SignalValueSeries2.m_Items[f_Index];
      f_SigLineValue1 := f_SignalValueSeries3.m_Items[f_Index];
      f_SigLineValue1.m_Value[0] := f_SigLineValue0.m_Value[0];
    end;
  end;
{$ENDREGION}
  f_SignalValueSeries0.m_Effect := true;
  f_SignalValueSeries1.m_Effect := true;
  f_SignalValueSeries2.m_Effect := true;
  f_SignalValueSeries3.m_Effect := true;
end;

// ---------------------------------------------------------------------------
end.
