unit MXTradeStrategySTC_T2;

interface

uses
  SysUtils, MKChartData, MKChartDataSeries, MKLineValue, MKLineValueSeries, MXTSLineValueSeries, MXTradeStrategy;

type
  // ---------------------------------------------------------------------------
  // 스토캐스틱 추세 2에 사용하는 보조지표와 신호를 계산하는 클래스
  // ---------------------------------------------------------------------------
  CMXTradeStrategySTC_T2 = class(CMXTradeStrategy)
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

  private
    // 옵션이 변경되어 재계산이 될 때 화면에 표시한 것들중에 옵션에 관련된 사항들을 적용한다.
    procedure UpdateVisibleStateOfLineValueSeries; override;
  end;
  // ---------------------------------------------------------------------------

implementation

uses MKGlobal, MKConst, MXTradeStrategyOptionCollection, MKTradeStrategyConst;

// ---------------------------------------------------------------------------
// 생성자
constructor CMXTradeStrategySTC_T2.Create();
begin
  inherited Create();

  CMXTradeStrategyOption.Default_STC_T2(m_Option);
  m_Category := m_Option.GetStringValue('CATEGORY');
  m_Name := m_Option.GetStringValue('NAME');
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CMXTradeStrategySTC_T2.Destroy();
begin
  inherited Destroy();
end;

// ---------------------------------------------------------------------------
// 계산에 필요한 라인을 생성한다.
procedure CMXTradeStrategySTC_T2.CreateLineValueSeries;
var
  f_LineValueSeries: CMXTSLineValueSeries;
begin
  DeleteLineValueSeries;
  Clear;

  m_ChartBlockCount := 0;

  // 첫번째 라인
  f_LineValueSeries := Creator_SlowSTC();
  f_LineValueSeries.m_Name := 'ST-STC-T2-L1';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := 0;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  f_LineValueSeries.m_AbsoluteMaxMin := true;
  f_LineValueSeries.m_AbsoluteMax := 100;
  f_LineValueSeries.m_AbsoluteMin := 0;
  f_LineValueSeries.m_Values[0] := m_Option.GetDoubleValue('DN');
  f_LineValueSeries.m_Values[1] := m_Option.GetDoubleValue('UP');
  f_LineValueSeries.m_ValueColors[0] := 1;
  f_LineValueSeries.m_ValueColors[1] := 1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);

  CreateReinforceLineValueSeries(m_ChartBlockCount);

  m_SIGNAL_LINE_ZERO := m_LineCollection.Count;

  CreateReinforceSignalLineValueSeries(m_ChartBlockCount);

  // 여섯번째 라인
  f_LineValueSeries := Creator_SignalLineValueSeries;
  f_LineValueSeries.m_Name := 'ST-STC-T2-S2';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount)
end;

// ---------------------------------------------------------------------------
// 옵션이 변경되어 재계산이 될 때 화면에 표시한 것들중에 옵션에 관련된 사항들을 적용한다.
procedure CMXTradeStrategySTC_T2.UpdateVisibleStateOfLineValueSeries;
var
  f_LineValueSeries: CMXTSLineValueSeries;
begin
  f_LineValueSeries := m_LineCollection.Items[0];
  f_LineValueSeries.m_LineVisibles[0] := false;
  f_LineValueSeries.m_LineVisibles[1] := false;
  f_LineValueSeries.m_LineVisibles[2] := true;
  f_LineValueSeries.m_Values[0] := m_Option.GetDoubleValue('DN');
  f_LineValueSeries.m_Values[1] := m_Option.GetDoubleValue('UP');
end;

// ---------------------------------------------------------------------------
// 계산을 시작한다.
procedure CMXTradeStrategySTC_T2.Calculate(ARecalculation: Boolean);
var
  f_Begin, f_End: Integer;
  f_LineValueSeries: CMXTSLineValueSeries;
  f_STD_VALUE: Integer;
  f_VALUE_TYPE: Integer;
  f_Index: Integer;
  f_PLineValueSeries: CMXTSLineValueSeries;
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

  f_LineValueSeries.m_Options[0] := m_Option.GetIntegerValue('LENGTH1');
  f_LineValueSeries.m_Options[1] := m_Option.GetIntegerValue('LENGTH2');
  f_LineValueSeries.m_Options[2] := m_Option.GetIntegerValue('LENGTH3');

  f_LineValueSeries.TS_SlowSTC(m_Option.GetIntegerValue('LENGTH1'), m_Option.GetIntegerValue('LENGTH2'),
      m_Option.GetIntegerValue('LENGTH3'), m_PriceLineValueSeries, 1, 2, 3, 0, f_Begin, f_End);

  f_STD_VALUE := m_Option.GetIntegerValue('RF1_STD_VALUE');
  f_VALUE_TYPE := m_Option.GetIntegerValue('RF1_VALUE_TYPE');
  // f_VALUE_TYPE    := m_Option.GetIntegerValue(TSOPTION_KEY_MAJORVALUE);
{$ENDREGION}
  CalculateReinforce(f_Begin, f_End);

  CalulateSignal(f_Begin, f_End);

  CalulateReinforceSignal(f_Begin, f_End);

  ApplyFilter(f_Begin, f_End);

  SetChartDataSeriesToLineSeries;
end;

// ---------------------------------------------------------------------------
// 신호를 계산한다.
procedure CMXTradeStrategySTC_T2.CalulateSignal(p_Begin: Integer; p_End: Integer);
var
  f_Index: Integer;

  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;

  f_SourceLineValue0: CMKLineValue;
  f_SourceLineValue1: CMKLineValue;

  f_SigLineValue0: CMKLineValue;
  f_SigLineValue1: CMKLineValue;

  f_LineValueSeries0: CMXTSLineValueSeries;
  f_SignalValueSeries0: CMXTSLineValueSeries;

  f_SigSeq: Integer;
  f_UP: Double;
  f_DN: Double;

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
  f_LineValueSeries0 := m_LineCollection.Items[0];
  f_SignalValueSeries0 := m_LineCollection.Items[m_SIGNAL_LINE_ZERO + 0];

  f_SignalValueSeries0.SetLengthSeries(m_ChartDataSeries.m_Items.Count);
{$ENDREGION}
{$REGION '계산에 필요한 변수 초기화'}
  f_UP := m_Option.GetDoubleValue('UP');
  f_DN := m_Option.GetDoubleValue('DN');
  f_UseTolerance := m_Option.GetBooleanValue('USE_TOLERANCE');
  f_Tolerance := m_Option.GetDoubleValue('TOLERANCE');
  f_ToleranceUnit := m_Option.GetIntegerValue('TOLERANCE_UNIT');
{$ENDREGION}
{$REGION '보조지표들의 특정을 비교하여 신호 계산'}
  f_SigSeq := 0;
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

      f_SigLineValue0.m_Value[f_SigSeq] := f_SigLineValue1.m_Value[f_SigSeq];

      if ((f_SourceLineValue0.m_Value[1] <> NOT_VALUE) AND (f_SourceLineValue0.m_Value[2] <> NOT_VALUE)) then
      begin
        if (f_SigLineValue0.m_Value[f_SigSeq] <> STRATEGY_BUY) then
        begin
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue := f_UP + ((f_Tolerance / 100.0) * f_UP);
            end
            else
            begin
              f_TargetValue := f_UP + f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue := f_UP;
          end;

          // %D가 80을 상향돌파 => 매수
          if (f_TargetValue < f_SourceLineValue0.m_Value[2]) then
          begin
            f_SigLineValue0.m_Value[f_SigSeq] := STRATEGY_BUY;
          end;
        end;

        if (f_SigLineValue0.m_Value[f_SigSeq] <> STRATEGY_SELL) then
        begin
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue := f_DN - ((f_Tolerance / 100.0) * f_DN);
            end
            else
            begin
              f_TargetValue := f_DN - f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue := f_DN;
          end;

          // %D가 20을하향돌파 => 매도
          if (f_TargetValue > f_SourceLineValue0.m_Value[2]) then
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
  f_SignalValueSeries0.m_Effect := true;
end;

end.
