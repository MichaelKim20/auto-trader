unit MXTradeStrategyMOV_T1;

interface

uses
  SysUtils, MKChartData, MKChartDataSeries, MKLineValue, MKLineValueSeries, MXTSLineValueSeries, MXTradeStrategy;

type
  // ---------------------------------------------------------------------------
  // 이동평균선 추세 1에 사용하는 보조지표와 신호를 계산하는 클래스
  // ---------------------------------------------------------------------------
  CMXTradeStrategyMOV_T1 = class(CMXTradeStrategy)
  public
    // 생성자
    constructor Create();

    // 파괴자
    destructor Destroy(); override;

    // 계산을 시작한다.
    procedure Calculate(ARecalculation: Boolean); override;

    // 계산에 필요한 라인을 생성한다.
    procedure CreateLineValueSeries; override;

    // 신호를 계산한다.
    procedure CalulateSignal(p_Begin: Integer; p_End: Integer);
  end;

implementation

uses MKGlobal, MKConst, MKColorSet, MXTradeStrategyOptionCollection, MKTradeStrategyConst;

// ---------------------------------------------------------------------------
// 생성자
constructor CMXTradeStrategyMOV_T1.Create();
begin
  inherited Create();

  CMXTradeStrategyOption.Default_MOV_T1_O1(m_Option);
  m_Category := m_Option.GetStringValue('CATEGORY');
  m_Name := m_Option.GetStringValue('NAME');
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CMXTradeStrategyMOV_T1.Destroy();
begin
  inherited Destroy();
end;

// ---------------------------------------------------------------------------
// 계산에 필요한 라인을 생성한다.
procedure CMXTradeStrategyMOV_T1.CreateLineValueSeries;
var
  f_LineValueSeries: CMXTSLineValueSeries;
begin
  DeleteLineValueSeries;
  Clear;

  m_ChartBlockCount := 0;

  // 첫번째 라인
  f_LineValueSeries := Creator_AnyLineValueSeries(2);
  f_LineValueSeries.m_Name := 'ST-MOV-T1-L1';
  f_LineValueSeries.m_LineColors[0] := 30;
  f_LineValueSeries.m_LineColors[1] := 31;
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);

  CreateReinforceLineValueSeries(m_ChartBlockCount);

  m_SIGNAL_LINE_ZERO := m_LineCollection.Count;

  CreateReinforceSignalLineValueSeries(m_ChartBlockCount);

  // 두번째 라인
  f_LineValueSeries := Creator_SignalLineValueSeries;
  f_LineValueSeries.m_Name := 'ST-MOV-T1-S1';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);
end;

// ---------------------------------------------------------------------------
// 계산을 시작한다.
procedure CMXTradeStrategyMOV_T1.Calculate(ARecalculation: Boolean);
var
  f_Begin, f_End: Integer;
  f_LineValueSeries: CMXTSLineValueSeries;
  f_STD_VALUE: Integer;
  f_VALUE_TYPE: Integer;
  f_Index: Integer;
begin
  inherited Calculate(ARecalculation);
  if not Assigned(m_ChartDataSeries) then
    exit;

{$REGION '계산할 범위를 결정한다'}
  f_Begin := m_PriceLineValueSeries.m_Items.Count - 1;
  f_End := m_ChartDataSeries.m_Items.Count;
{$ENDREGION}
{$REGION '가격선을 구축한다'}
  CMXTSLineValueSeries(m_PriceLineValueSeries).TS_MajorLine1(m_Option.GetIntegerValue(TSOPTION_KEY_MAJORVALUE),
      m_ChartDataSeries, CMXTSLineValueSeries(m_OPS2LineValueSeries), f_Begin, f_End);
{$ENDREGION}
{$REGION '첫번째 보조지표를 계산한다'}
  f_LineValueSeries := m_LineCollection.Items[0];
  f_LineValueSeries.m_Precision := m_ChartDataSeries.m_Precision;

  if (m_Option.GetIntegerValue('AVERAGE_TYPE') = 0) then
  begin
    f_LineValueSeries.TS_NAverage(m_Option.GetIntegerValue('LENGTH1'), m_PriceLineValueSeries, 3, 0, f_Begin, f_End);
    f_LineValueSeries.TS_NAverage(m_Option.GetIntegerValue('LENGTH2'), m_PriceLineValueSeries, 3, 1, f_Begin, f_End);
  end
  else if (m_Option.GetIntegerValue('AVERAGE_TYPE') = 1) then
  begin
    f_LineValueSeries.TS_WAverage(m_Option.GetIntegerValue('LENGTH1'), m_PriceLineValueSeries, 3, 0, f_Begin, f_End);
    f_LineValueSeries.TS_WAverage(m_Option.GetIntegerValue('LENGTH2'), m_PriceLineValueSeries, 3, 1, f_Begin, f_End);
  end
  else
  begin
    f_LineValueSeries.TS_XAverage(m_Option.GetIntegerValue('LENGTH1'), m_PriceLineValueSeries, 3, 0, f_Begin, f_End);
    f_LineValueSeries.TS_XAverage(m_Option.GetIntegerValue('LENGTH2'), m_PriceLineValueSeries, 3, 1, f_Begin, f_End);
  end;
{$ENDREGION}
  CalculateReinforce(f_Begin, f_End);

  CalulateSignal(f_Begin, f_End);

  CalulateReinforceSignal(f_Begin, f_End);

  ApplyFilter(f_Begin, f_End);

  SetChartDataSeriesToLineSeries;
end;

// ---------------------------------------------------------------------------
// 신호를 계산한다.
procedure CMXTradeStrategyMOV_T1.CalulateSignal(p_Begin: Integer; p_End: Integer);
var
  f_Index: Integer;

  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;

  f_SourceLineValue0: CMKLineValue;
  f_SourceLineValue1: CMKLineValue;

  f_SigLineValue0: CMKLineValue;
  f_SigLineValue1: CMKLineValue;

  f_LineValueSeries0: CMXTSLineValueSeries;
  f_LineValueSeries1: CMXTSLineValueSeries;

  f_SignalValueSeries0: CMXTSLineValueSeries;
  f_SignalValueSeries1: CMXTSLineValueSeries;

  f_TargetValue1: Double;
  f_TargetValue0: Double;
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
  f_LineValueSeries0 := m_LineCollection.Items[0];
  f_SignalValueSeries0 := m_LineCollection.Items[m_SIGNAL_LINE_ZERO + 0];
  f_SignalValueSeries0.SetLengthSeries(m_ChartDataSeries.m_Items.Count);
{$ENDREGION}
{$REGION '계산에 필요한 변수 초기화'}
  f_UseTolerance := m_Option.GetBooleanValue('USE_TOLERANCE');
  f_Tolerance := m_Option.GetDoubleValue('TOLERANCE');
  f_ToleranceUnit := m_Option.GetIntegerValue('TOLERANCE_UNIT');
{$ENDREGION}
{$REGION '보조지표들의 특정을 비교하여 신호 계산'}
  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SourceLineValue0 := f_LineValueSeries0.m_Items[f_Index];
    f_SigLineValue0 := f_SignalValueSeries0.m_Items[f_Index];
    f_ChartData0 := m_ChartDataSeries.m_Items[f_Index];

    if (f_Index > 0) then
    begin
      f_SourceLineValue1 := f_LineValueSeries0.m_Items[f_Index - 1];
      f_SigLineValue1 := f_SignalValueSeries0.m_Items[f_Index - 1];
      f_ChartData1 := m_ChartDataSeries.m_Items[f_Index - 1];

      f_SigLineValue0.m_Value[0] := f_SigLineValue1.m_Value[0];

      if ((f_SourceLineValue0.m_Value[0] <> NOT_VALUE) AND (f_SourceLineValue1.m_Value[0] <> NOT_VALUE)) then
      begin

        if (f_SigLineValue0.m_Value[0] <> STRATEGY_BUY) then
        begin
{$REGION 'MA1 > MA3 => 매수'}
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue0 := f_SourceLineValue0.m_Value[1] + ((f_Tolerance / 100.0) * f_SourceLineValue0.m_Value[1]);
            end
            else
            begin
              f_TargetValue0 := f_SourceLineValue0.m_Value[1] + f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue0 := f_SourceLineValue0.m_Value[1];
          end;

          if (f_SourceLineValue0.m_Value[0] > f_TargetValue0) then
          begin
            f_SigLineValue0.m_Value[0] := STRATEGY_BUY;
          end;
{$ENDREGION}
        end;

        if (f_SigLineValue0.m_Value[0] <> STRATEGY_SELL) then
        begin
{$REGION 'MA1 < MA3 => 매도'}
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue0 := f_SourceLineValue0.m_Value[1] - ((f_Tolerance / 100.0) * f_SourceLineValue0.m_Value[1]);
            end
            else
            begin
              f_TargetValue0 := f_SourceLineValue0.m_Value[1] - f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue0 := f_SourceLineValue0.m_Value[1];
          end;

          if (f_SourceLineValue0.m_Value[0] < f_TargetValue0) then
          begin
            f_SigLineValue0.m_Value[0] := STRATEGY_SELL;
          end;
{$ENDREGION}
        end;
      end;
    end
    else
    begin
      f_SigLineValue0.m_Value[0] := STRATEGY_EXIT;
    end;
  end;
{$ENDREGION}
  f_SignalValueSeries0.m_Effect := true;
end;

// ---------------------------------------------------------------------------

end.
