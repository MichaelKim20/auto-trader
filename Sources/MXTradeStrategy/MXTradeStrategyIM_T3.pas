unit MXTradeStrategyIM_T3;

interface

uses
  SysUtils, MKChartData, MKChartDataSeries, MKLineValue, MKLineValueSeries, MXTSLineValueSeries, MXTradeStrategy;

type
  // ---------------------------------------------------------------------------
  // 일목 추세 3에 사용하는 보조지표와 신호를 계산하는 클래스
  // ---------------------------------------------------------------------------
  CMXTradeStrategyIM_T3 = class(CMXTradeStrategy)
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

implementation

uses Math, MKGlobal, MKConst, MXTradeStrategyOptionCollection, FNMaterialCollection,
  FNCMVariable, MKTradeStrategyConst;

// ---------------------------------------------------------------------------
// 생성자
constructor CMXTradeStrategyIM_T3.Create();
begin
  inherited Create();

  CMXTradeStrategyOption.Default_IM_T3_O1(m_Option);
  m_Category := m_Option.GetStringValue('CATEGORY');
  m_Name := m_Option.GetStringValue('NAME');
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CMXTradeStrategyIM_T3.Destroy();
begin
  inherited Destroy();
end;

// ---------------------------------------------------------------------------
// 계산에 필요한 라인을 생성한다.
procedure CMXTradeStrategyIM_T3.CreateLineValueSeries;
var
  f_LineValueSeries: CMXTSLineValueSeries;
begin
  DeleteLineValueSeries;
  Clear;

  m_ChartBlockCount := 0;

  // 첫번째 라인
  f_LineValueSeries := Creator_IMLine;
  f_LineValueSeries.m_Name := 'ST-IM-T3-L1';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);

  // 두번째 라인
  f_LineValueSeries := Creator_AnyLineValueSeries(5);
  f_LineValueSeries.m_Name := 'ST-IM-T3-L2';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);

  CreateReinforceLineValueSeries(m_ChartBlockCount);

  m_SIGNAL_LINE_ZERO := m_LineCollection.Count;

  CreateReinforceSignalLineValueSeries(m_ChartBlockCount);

  // 세번째 라인
  f_LineValueSeries := Creator_SignalLineValueSeries;
  f_LineValueSeries.m_Name := 'ST-IM-T3-S1';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);
end;

// ---------------------------------------------------------------------------
// 옵션이 변경되어 재계산이 될 때 화면에 표시한 것들중에 옵션에 관련된 사항들을 적용한다.
procedure CMXTradeStrategyIM_T3.UpdateVisibleStateOfLineValueSeries;
var
  f_LineValueSeries: CMXTSLineValueSeries;
  f_Index: Integer;
begin
  f_LineValueSeries := m_LineCollection.Items[1];

  for f_Index := 0 to f_LineValueSeries.m_LineCount - 1 do
  begin
    f_LineValueSeries.m_LineVisibles[f_Index] := false;
  end;

  if (m_Option.GetIntegerValue('TREND_FILTER') = 0) then
  begin
    f_LineValueSeries.m_LineVisibles[0] := true;
    f_LineValueSeries.m_LineVisibles[1] := true;
    f_LineValueSeries.m_LineVisibles[2] := true;
    f_LineValueSeries.m_LineVisibles[3] := true;
    f_LineValueSeries.m_LineColors[0] := 30;
    f_LineValueSeries.m_LineColors[1] := 30;
    f_LineValueSeries.m_LineColors[2] := 31;
    f_LineValueSeries.m_LineColors[3] := 31;
  end
  else if (m_Option.GetIntegerValue('TREND_FILTER') = 1) then
  begin
    f_LineValueSeries.m_LineVisibles[2] := true;
    f_LineValueSeries.m_LineVisibles[3] := true;
    f_LineValueSeries.m_LineColors[2] := 31;
    f_LineValueSeries.m_LineColors[3] := 31;
  end
  else if (m_Option.GetIntegerValue('TREND_FILTER') = 2) then
  begin
    f_LineValueSeries.m_LineVisibles[2] := true;
    f_LineValueSeries.m_LineVisibles[3] := true;
    f_LineValueSeries.m_LineColors[2] := 31;
    f_LineValueSeries.m_LineColors[3] := 31;
  end
  else
  begin
    f_LineValueSeries.m_LineVisibles[2] := true;
    f_LineValueSeries.m_LineVisibles[3] := true;
    f_LineValueSeries.m_LineVisibles[4] := true;
    f_LineValueSeries.m_LineColors[2] := 31;
    f_LineValueSeries.m_LineColors[3] := 31;
    f_LineValueSeries.m_LineColors[4] := 32;
  end;
end;

// ---------------------------------------------------------------------------
// 계산을 시작한다.
procedure CMXTradeStrategyIM_T3.Calculate(ARecalculation: Boolean);
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

  f_LineValueSeries.m_Options[0] := m_Option.GetIntegerValue('LENGTH1');
  f_LineValueSeries.m_Options[1] := m_Option.GetIntegerValue('LENGTH2');
  f_LineValueSeries.m_Options[2] := m_Option.GetIntegerValue('LENGTH3');

  f_LineValueSeries.TS_IMLine(m_Option.GetIntegerValue('LENGTH1'), m_Option.GetIntegerValue('LENGTH2'),
      m_Option.GetIntegerValue('LENGTH3'), m_PriceLineValueSeries, 1, 2, 3, 0, f_Begin, f_End);

  f_LineValueSeries := m_LineCollection.Items[1];
  f_LineValueSeries.m_Precision := m_ChartDataSeries.m_Precision;

  f_VALUE_TYPE := m_Option.GetIntegerValue('VALUE_TYPE');

  // 전전일 고가
  f_LineValueSeries.TS_DayH(m_ChartDataSeries, m_DayChartDataSeries, 2, f_VALUE_TYPE, 0, f_Begin, f_End);

  // 전전일 저가
  f_LineValueSeries.TS_DayL(m_ChartDataSeries, m_DayChartDataSeries, 2, f_VALUE_TYPE, 1, f_Begin, f_End);

  // 전일고가
  f_LineValueSeries.TS_DayH(m_ChartDataSeries, m_DayChartDataSeries, 1, f_VALUE_TYPE, 2, f_Begin, f_End);

  // 전일저가
  f_LineValueSeries.TS_DayL(m_ChartDataSeries, m_DayChartDataSeries, 1, f_VALUE_TYPE, 3, f_Begin, f_End);

  // 전일종가
  f_LineValueSeries.TS_DayC(m_ChartDataSeries, m_DayChartDataSeries, 1, f_VALUE_TYPE, 4, f_Begin, f_End);
{$ENDREGION}
  CalculateReinforce(f_Begin, f_End);

  CalulateSignal(f_Begin, f_End);

  CalulateReinforceSignal(f_Begin, f_End);

  ApplyFilter(f_Begin, f_End);

  SetChartDataSeriesToLineSeries;
end;

// ---------------------------------------------------------------------------
// 신호를 계산한다.
procedure CMXTradeStrategyIM_T3.CalulateSignal(p_Begin: Integer; p_End: Integer);
var
  f_Index: Integer;

  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;

  f_SourceLineValue00: CMKLineValue;
  f_SourceLineValue01: CMKLineValue;
  f_SourceLineValue10: CMKLineValue;
  f_SourceLineValue11: CMKLineValue;

  f_SigLineValue0: CMKLineValue;
  f_SigLineValue1: CMKLineValue;

  f_LineValueSeries0: CMXTSLineValueSeries;
  f_LineValueSeries1: CMXTSLineValueSeries;

  f_SignalValueSeries0: CMXTSLineValueSeries;
  f_SignalValueSeries1: CMXTSLineValueSeries;

  f_TrendFielter: Integer;
  f_Enable, f_UseSideCondition: Boolean;

  f_C_1_IDX: Integer;
  f_L_1_IDX: Integer;
  f_H_1_IDX: Integer;
  f_L_2_IDX: Integer;
  f_H_2_IDX: Integer;

  f_Rate: Double;

  f_TickSize: Double;
  f_MaterialItem: CFNMaterialItem;

  f_TargetValue0: Double;
  f_TargetValue1: Double;
  f_TargetValue2: Double;
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
  f_H_2_IDX := 0;
  f_L_2_IDX := 1;
  f_H_1_IDX := 2;
  f_L_1_IDX := 3;
  f_C_1_IDX := 4;

  f_TrendFielter := m_Option.GetIntegerValue('TREND_FILTER');
  f_UseSideCondition := m_Option.GetBooleanValue('USE_SIDECONDITION');

  f_UseTolerance := m_Option.GetBooleanValue('USE_TOLERANCE');
  f_Tolerance := m_Option.GetDoubleValue('TOLERANCE');
  f_ToleranceUnit := m_Option.GetIntegerValue('TOLERANCE_UNIT');
{$ENDREGION}
{$REGION '보조지표들의 특정을 비교하여 신호 계산'}
  if (f_TrendFielter = 2) then
  begin
    if Assigned(g_MaterialCollection) then
    begin
      f_MaterialItem := g_MaterialCollection.Find(m_Option.GetIntegerValue('COUNTRY_NO'), m_Option.GetIntegerValue('GROUP_NO'),
          m_Option.GetIntegerValue('MARKET_NO'), m_Option.GetStringValue('SYMBOL'));
      if Assigned(f_MaterialItem) then
      begin
        f_TickSize := f_MaterialItem.m_TickSize;
      end
      else
      begin
        f_TickSize := 0.25;
      end;
    end
    else
    begin
      f_TickSize := 0.25;
    end;
  end;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SourceLineValue00 := f_LineValueSeries0.m_Items[f_Index];
    f_SourceLineValue10 := f_LineValueSeries1.m_Items[f_Index];
    f_SigLineValue0 := f_SignalValueSeries0.m_Items[f_Index];
    f_ChartData0 := m_ChartDataSeries.m_Items[f_Index];

    if (f_Index > 0) then
    begin
      f_SourceLineValue01 := f_LineValueSeries0.m_Items[f_Index - 1];
      f_SourceLineValue11 := f_LineValueSeries1.m_Items[f_Index - 1];
      f_SigLineValue1 := f_SignalValueSeries0.m_Items[f_Index - 1];
      f_ChartData1 := m_ChartDataSeries.m_Items[f_Index - 1];

      f_SigLineValue0.m_Value[0] := f_SigLineValue1.m_Value[0];

      if ((f_SourceLineValue00.m_Value[0] <> NOT_VALUE) AND (f_SourceLineValue00.m_Value[1] <> NOT_VALUE) AND
          (f_SourceLineValue00.m_Value[2] <> NOT_VALUE) AND (f_SourceLineValue00.m_Value[3] <> NOT_VALUE) AND
          (f_SourceLineValue10.m_Value[f_H_1_IDX] <> NOT_VALUE) AND (f_SourceLineValue10.m_Value[f_L_1_IDX] <> NOT_VALUE) AND
          (f_SourceLineValue10.m_Value[f_H_2_IDX] <> NOT_VALUE) AND (f_SourceLineValue10.m_Value[f_L_2_IDX] <> NOT_VALUE) AND
          (f_SourceLineValue10.m_Value[f_C_1_IDX] <> NOT_VALUE)) then
      begin
        f_Enable := false;
        if (f_UseSideCondition) then
        begin
          if (f_TrendFielter = 0) then
          begin
            if (f_SourceLineValue10.m_Value[f_H_1_IDX] - f_SourceLineValue10.m_Value[f_L_1_IDX]) <
                (f_SourceLineValue10.m_Value[f_H_2_IDX] - f_SourceLineValue10.m_Value[f_L_2_IDX]) *
                m_Option.GetDoubleValue('M1V1') then
              f_Enable := true;
          end
          else if (f_TrendFielter = 1) then
          begin
            if (f_SourceLineValue10.m_Value[f_H_1_IDX] - f_SourceLineValue10.m_Value[f_L_1_IDX]) <
                m_Option.GetDoubleValue('M2V1') then
              f_Enable := true;
          end
          else if (f_TrendFielter = 2) then
          begin
            if (f_SourceLineValue10.m_Value[f_H_1_IDX] - f_SourceLineValue10.m_Value[f_L_1_IDX]) <
                (m_Option.GetDoubleValue('M3V1') * f_TickSize) then
              f_Enable := true;
          end
          else if (f_TrendFielter = 3) then
          begin
            try
              if CompareValue(f_SourceLineValue10.m_Value[f_C_1_IDX], 0, 0.000001) <> 0 then
              begin
                f_Rate := abs(f_SourceLineValue10.m_Value[f_H_1_IDX] - f_SourceLineValue10.m_Value[f_L_1_IDX]) * 100.0 /
                    f_SourceLineValue10.m_Value[f_C_1_IDX];
              end
              else
              begin
                f_Rate := 0;
              end;
            except
              f_Rate := 0;
            end;
            if f_Rate < m_Option.GetDoubleValue('M4V1') then
              f_Enable := true;
          end;
        end
        else
        begin
          f_Enable := true;
        end;

        if f_Enable then
        begin

          if (f_SigLineValue0.m_Value[0] <> STRATEGY_BUY) then
          begin
{$REGION '전환선 > 기준선 > 선행스팬1 > 선행스팬2 => 매수'}
            if f_UseTolerance then
            begin
              if 0 = f_ToleranceUnit then
              begin
                f_TargetValue0 := f_SourceLineValue00.m_Value[1] + ((f_Tolerance / 100.0) * f_SourceLineValue00.m_Value[1]);
                f_TargetValue1 := f_SourceLineValue00.m_Value[2] + ((f_Tolerance / 100.0) * f_SourceLineValue00.m_Value[2]);
                f_TargetValue2 := f_SourceLineValue00.m_Value[3] + ((f_Tolerance / 100.0) * f_SourceLineValue00.m_Value[3]);
              end
              else
              begin
                f_TargetValue0 := f_SourceLineValue00.m_Value[1] + f_Tolerance;
                f_TargetValue1 := f_SourceLineValue00.m_Value[2] + f_Tolerance;
                f_TargetValue2 := f_SourceLineValue00.m_Value[3] + f_Tolerance;
              end;
            end
            else
            begin
              f_TargetValue0 := f_SourceLineValue00.m_Value[1];
              f_TargetValue1 := f_SourceLineValue00.m_Value[2];
              f_TargetValue2 := f_SourceLineValue00.m_Value[3];
            end;

            if (f_SourceLineValue00.m_Value[0] > f_TargetValue0) and (f_SourceLineValue00.m_Value[1] > f_TargetValue1) and
                (f_SourceLineValue00.m_Value[2] > f_TargetValue2) then
            begin
              f_SigLineValue0.m_Value[0] := STRATEGY_BUY;
            end;
{$ENDREGION}
          end;

          if (f_SigLineValue0.m_Value[0] <> STRATEGY_SELL) then
          begin
{$REGION '전환선 < 기준선 < 선행스팬1 < 선행스팬2 => 매도'}
            if f_UseTolerance then
            begin
              if 0 = f_ToleranceUnit then
              begin
                f_TargetValue0 := f_SourceLineValue00.m_Value[1] - ((f_Tolerance / 100.0) * f_SourceLineValue00.m_Value[1]);
                f_TargetValue1 := f_SourceLineValue00.m_Value[2] - ((f_Tolerance / 100.0) * f_SourceLineValue00.m_Value[2]);
                f_TargetValue2 := f_SourceLineValue00.m_Value[3] - ((f_Tolerance / 100.0) * f_SourceLineValue00.m_Value[3]);
              end
              else
              begin
                f_TargetValue0 := f_SourceLineValue00.m_Value[1] - f_Tolerance;
                f_TargetValue1 := f_SourceLineValue00.m_Value[2] - f_Tolerance;
                f_TargetValue2 := f_SourceLineValue00.m_Value[3] - f_Tolerance;
              end;
            end
            else
            begin
              f_TargetValue0 := f_SourceLineValue00.m_Value[1];
              f_TargetValue1 := f_SourceLineValue00.m_Value[2];
              f_TargetValue2 := f_SourceLineValue00.m_Value[3];
            end;

            if (f_SourceLineValue00.m_Value[0] < f_TargetValue0) and (f_SourceLineValue00.m_Value[1] < f_TargetValue1) and
                (f_SourceLineValue00.m_Value[2] < f_TargetValue2) then
            begin
              f_SigLineValue0.m_Value[0] := STRATEGY_SELL;
            end;
{$ENDREGION}
          end;

        end
        else
        begin
          f_SigLineValue0.m_Value[0] := STRATEGY_EXIT;
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
