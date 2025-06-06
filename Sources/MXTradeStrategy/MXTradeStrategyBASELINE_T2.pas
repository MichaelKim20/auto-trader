unit MXTradeStrategyBASELINE_T2;

interface

uses
  SysUtils, MKChartData, MKChartDataSeries, MKLineValue, MKLineValueSeries, MXTSLineValueSeries, MXTradeStrategy;

type
  // ---------------------------------------------------------------------------
  // BASELINE  비추세 2에 사용하는 보조지표와 신호를 계산하는 클래스
  // ---------------------------------------------------------------------------
  CMXTradeStrategyBASELINE_T2 = class(CMXTradeStrategy)
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
constructor CMXTradeStrategyBASELINE_T2.Create();
begin
  inherited Create();

  CMXTradeStrategyOption.Default_BASELINE_T2(m_Option);
  m_Category := m_Option.GetStringValue('CATEGORY');
  m_Name := m_Option.GetStringValue('NAME');

end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CMXTradeStrategyBASELINE_T2.Destroy();
begin
  inherited Destroy();
end;

// ---------------------------------------------------------------------------
// 계산에 필요한 라인을 생성한다.
procedure CMXTradeStrategyBASELINE_T2.CreateLineValueSeries;
var
  f_LineValueSeries: CMXTSLineValueSeries;
begin
  DeleteLineValueSeries;
  Clear;

  m_ChartBlockCount := 0;

  // 첫번째 라인 -> 차트에서는 첫번째
  f_LineValueSeries := Creator_AnyLineValueSeries(1);
  f_LineValueSeries.m_Name := 'ST-BASELINE-T2-L1';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);

  // 두번째 라인  -> 차트에서는 첫번째
  f_LineValueSeries := Creator_AnyLineValueSeries(9);
  f_LineValueSeries.m_Name := 'ST-BASELINE-T2-L2';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);

  CreateReinforceLineValueSeries(m_ChartBlockCount);

  m_SIGNAL_LINE_ZERO := m_LineCollection.Count;

  CreateReinforceSignalLineValueSeries(m_ChartBlockCount);

  // 세번째 라인  -> 차트에서는 두번째
  f_LineValueSeries := Creator_SignalLineValueSeries;
  f_LineValueSeries.m_Name := 'ST-BASELINE-T2-S1';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);
end;

// ---------------------------------------------------------------------------
// 옵션이 변경되어 재계산이 될 때 화면에 표시한 것들중에 옵션에 관련된 사항들을 적용한다.
procedure CMXTradeStrategyBASELINE_T2.UpdateVisibleStateOfLineValueSeries;
var
  f_LineValueSeries: CMXTSLineValueSeries;
  f_Index: Integer;
begin
  f_LineValueSeries := m_LineCollection.Items[1];

  for f_Index := 0 to f_LineValueSeries.m_LineCount - 1 do
  begin
    f_LineValueSeries.m_LineVisibles[f_Index] := false;
  end;

  // 종가를 사용
  if (m_Option.GetIntegerValue('PRICEMETHOD') = 0) then
  begin
    f_LineValueSeries.m_LineVisibles[0] := true;
    f_LineValueSeries.m_LineColors[0] := 30
  end
  else
    // 고가와 저가를 사용
    if (m_Option.GetIntegerValue('PRICEMETHOD') = 1) then
    begin
      f_LineValueSeries.m_LineVisibles[1] := true;
      f_LineValueSeries.m_LineVisibles[2] := true;
      f_LineValueSeries.m_LineColors[1] := 30;
      f_LineValueSeries.m_LineColors[2] := 31;
    end
    else
      // (고가 + 저가) / 2 사용
      if (m_Option.GetIntegerValue('PRICEMETHOD') = 2) then
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
// 계산을 시작한다.
procedure CMXTradeStrategyBASELINE_T2.Calculate(ARecalculation: Boolean);
var
  f_Begin, f_End: Integer;
  f_LineValueSeries: CMXTSLineValueSeries;
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

  f_VALUE_TYPE := GetMajorValueType;

  // 전일중간값
  f_LineValueSeries.TS_DayHL(m_ChartDataSeries, m_DayChartDataSeries, 1, f_VALUE_TYPE, 0, f_Begin, f_End);
{$ENDREGION}
{$REGION '두번째 보조지표를 계산한다'}
  f_LineValueSeries := m_LineCollection.Items[1];
  f_LineValueSeries.m_Precision := m_ChartDataSeries.m_Precision;
  // 종가의 이평
  if (m_Option.GetIntegerValue('PM1_V2') = 0) then
  begin
    f_LineValueSeries.TS_NAverage(m_Option.GetIntegerValue('PM1_V1'), m_PriceLineValueSeries, 1, 0, f_Begin, f_End);
  end
  else if (m_Option.GetIntegerValue('PM1_V2') = 1) then
  begin
    f_LineValueSeries.TS_WAverage(m_Option.GetIntegerValue('PM1_V1'), m_PriceLineValueSeries, 1, 0, f_Begin, f_End);
  end
  else
  begin
    f_LineValueSeries.TS_XAverage(m_Option.GetIntegerValue('PM1_V1'), m_PriceLineValueSeries, 1, 0, f_Begin, f_End);
  end;

  if (m_Option.GetIntegerValue('PM2_V2') = 0) then
  begin
    // 고가의 이평
    f_LineValueSeries.TS_NAverage(m_Option.GetIntegerValue('PM2_V1'), m_PriceLineValueSeries, 1, 1, f_Begin, f_End);
    // 저가의 이평
    f_LineValueSeries.TS_NAverage(m_Option.GetIntegerValue('PM2_V1'), m_PriceLineValueSeries, 2, 2, f_Begin, f_End);
  end
  else if (m_Option.GetIntegerValue('PM2_V2') = 1) then
  begin
    // 고가의 이평
    f_LineValueSeries.TS_WAverage(m_Option.GetIntegerValue('PM2_V1'), m_PriceLineValueSeries, 1, 1, f_Begin, f_End);
    // 저가의 이평
    f_LineValueSeries.TS_WAverage(m_Option.GetIntegerValue('PM2_V1'), m_PriceLineValueSeries, 2, 2, f_Begin, f_End);
  end
  else
  begin
    // 고가의 이평
    f_LineValueSeries.TS_XAverage(m_Option.GetIntegerValue('PM2_V1'), m_PriceLineValueSeries, 1, 1, f_Begin, f_End);
    // 저가의 이평
    f_LineValueSeries.TS_XAverage(m_Option.GetIntegerValue('PM2_V1'), m_PriceLineValueSeries, 2, 2, f_Begin, f_End);
  end;

  f_LineValueSeries.TS_HLPrice(m_PriceLineValueSeries, 1, 2, 3, f_Begin, f_End);
  // (H+L)/2 이평
  if (m_Option.GetIntegerValue('PM3_V2') = 0) then
  begin
    f_LineValueSeries.TS_NAverage(m_Option.GetIntegerValue('PM3_V1'), f_LineValueSeries, 3, 4, f_Begin, f_End);
  end
  else if (m_Option.GetIntegerValue('PM3_V2') = 1) then
  begin
    f_LineValueSeries.TS_WAverage(m_Option.GetIntegerValue('PM3_V1'), f_LineValueSeries, 3, 4, f_Begin, f_End);
  end
  else
  begin
    f_LineValueSeries.TS_XAverage(m_Option.GetIntegerValue('PM3_V1'), f_LineValueSeries, 3, 4, f_Begin, f_End);
  end;

  f_LineValueSeries.TS_BBand(m_Option.GetIntegerValue('PM4_V1'), m_Option.GetDoubleValue('PM4_V2'), m_PriceLineValueSeries, 3,
      5, f_Begin, f_End);
{$ENDREGION}
  CalculateReinforce(f_Begin, f_End);

  CalulateSignal(f_Begin, f_End);

  CalulateReinforceSignal(f_Begin, f_End);

  ApplyFilter(f_Begin, f_End);

  SetChartDataSeriesToLineSeries;
end;

// ---------------------------------------------------------------------------
// 신호를 계산한다.
procedure CMXTradeStrategyBASELINE_T2.CalulateSignal(p_Begin: Integer; p_End: Integer);
var
  f_Index: Integer;

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

  f_SignalValueSeries0: CMXTSLineValueSeries;
  f_SignalValueSeries1: CMXTSLineValueSeries;

  f_HL_1_IDX: Integer;

  f_MAUP_0_IDX: Integer;
  f_MADN_0_IDX: Integer;

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
  f_LineValueSeries1 := m_LineCollection.Items[1];
  f_SignalValueSeries0 := m_LineCollection.Items[m_SIGNAL_LINE_ZERO + 0];
  f_SignalValueSeries0.SetLengthSeries(m_ChartDataSeries.m_Items.Count);
{$ENDREGION}
{$REGION '계산에 필요한 변수 초기화'}
  f_HL_1_IDX := 0;
  f_MAUP_0_IDX := GetPMUpperLine();
  f_MADN_0_IDX := GetPMDownLine();

  f_UseTolerance := m_Option.GetBooleanValue('USE_TOLERANCE');
  f_Tolerance := m_Option.GetDoubleValue('TOLERANCE');
  f_ToleranceUnit := m_Option.GetIntegerValue('TOLERANCE_UNIT');
{$ENDREGION}
{$REGION '보조지표들의 특정을 비교하여 신호 계산'}
  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SourceLineValue0 := f_LineValueSeries0.m_Items[f_Index];
    f_PMLineValue0 := f_LineValueSeries1.m_Items[f_Index];
    f_SigLineValue0 := f_SignalValueSeries0.m_Items[f_Index];

    if (f_Index > 0) then
    begin
      f_SourceLineValue1 := f_LineValueSeries0.m_Items[f_Index - 1];
      f_PMLineValue1 := f_LineValueSeries1.m_Items[f_Index - 1];
      f_SigLineValue1 := f_SignalValueSeries0.m_Items[f_Index - 1];

      f_SigLineValue0.m_Value[0] := f_SigLineValue1.m_Value[0];

      if ((f_SourceLineValue0.m_Value[f_HL_1_IDX] <> NOT_VALUE) AND (f_SourceLineValue1.m_Value[f_HL_1_IDX] <> NOT_VALUE) AND
          (f_PMLineValue0.m_Value[f_MAUP_0_IDX] <> NOT_VALUE) AND (f_PMLineValue1.m_Value[f_MADN_0_IDX] <> NOT_VALUE) AND
          (f_PMLineValue0.m_Value[f_MAUP_0_IDX] <> NOT_VALUE) AND (f_PMLineValue1.m_Value[f_MADN_0_IDX] <> NOT_VALUE)) then
      begin
        if (f_SigLineValue0.m_Value[0] <> STRATEGY_BUY) then
        begin
{$REGION '전일중심가격을 상향돌파 => 매수'}
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue0 := f_SourceLineValue0.m_Value[f_HL_1_IDX] +
                  ((f_Tolerance / 100.0) * f_SourceLineValue0.m_Value[f_HL_1_IDX]);
            end
            else
            begin
              f_TargetValue0 := f_SourceLineValue0.m_Value[f_HL_1_IDX] + f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue0 := f_SourceLineValue0.m_Value[f_HL_1_IDX];
          end;

          if (f_TargetValue0 < f_PMLineValue0.m_Value[f_MADN_0_IDX]) then
          begin
            f_SigLineValue0.m_Value[0] := STRATEGY_BUY;
          end;
{$ENDREGION}
        end;

        if (f_SigLineValue0.m_Value[0] <> STRATEGY_SELL) then
        begin
{$REGION '전일중심가격을 하향돌파 => 매도'}
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue0 := f_SourceLineValue0.m_Value[f_HL_1_IDX] -
                  ((f_Tolerance / 100.0) * f_SourceLineValue0.m_Value[f_HL_1_IDX]);
            end
            else
            begin
              f_TargetValue0 := f_SourceLineValue0.m_Value[f_HL_1_IDX] - f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue0 := f_SourceLineValue0.m_Value[f_HL_1_IDX];
          end;

          if (f_TargetValue0 > f_PMLineValue0.m_Value[f_MAUP_0_IDX]) then
          begin
            f_SigLineValue0.m_Value[0] := STRATEGY_SELL;
          end
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
