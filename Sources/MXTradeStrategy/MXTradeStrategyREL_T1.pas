unit MXTradeStrategyREL_T1;

interface

uses
  SysUtils, MKChartData, MKChartDataSeries, MKLineValue, MKLineValueSeries, MXTSLineValueSeries, MXTradeStrategy;

type
  // 상관관계 에 사용하는 보조지표와 신호를 계산하는 클래스
  CMXTradeStrategyREL_T1 = class(CMXTradeStrategy)
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

    procedure CalulateFactor(p_Begin: Integer; p_End: Integer);
  end;

implementation

uses MKGlobal, MKConst, MKColorSet, MXTradeStrategyOptionCollection, MKTradeStrategyConst;

// ---------------------------------------------------------------------------
// 생성자
constructor CMXTradeStrategyREL_T1.Create();
begin
  inherited Create();

  CMXTradeStrategyOption.Default_REL_T1_O2(m_Option);
  m_Category := m_Option.GetStringValue('CATEGORY');
  m_Name := m_Option.GetStringValue('NAME');
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CMXTradeStrategyREL_T1.Destroy();
begin
  inherited Destroy();
end;

// ---------------------------------------------------------------------------
// 계산에 필요한 라인을 생성한다.
procedure CMXTradeStrategyREL_T1.CreateLineValueSeries;
var
  f_LineValueSeries: CMXTSLineValueSeries;
begin
  DeleteLineValueSeries;
  Clear;

  m_ChartBlockCount := 0;

  // 첫번째 라인
  f_LineValueSeries := Creator_AnyLineValueSeries(2);
  f_LineValueSeries.m_Name := 'ST-REL-T1-L1';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);

  // 두번째 라인
  f_LineValueSeries := Creator_AnyLineValueSeries(2);
  f_LineValueSeries.m_Name := 'ST-REL-T1-L2';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);

  // 세번째 라인
  f_LineValueSeries := Creator_AnyLineValueSeries(1);
  f_LineValueSeries.m_Name := 'ST-REL-T1-L3';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);

  CreateReinforceLineValueSeries(m_ChartBlockCount);

  m_SIGNAL_LINE_ZERO := m_LineCollection.Count;

  CreateReinforceSignalLineValueSeries(m_ChartBlockCount);

  // 네번째 라인
  f_LineValueSeries := Creator_SignalLineValueSeries;
  f_LineValueSeries.m_Name := 'ST-REL-T1-S1';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);
end;

// ---------------------------------------------------------------------------
// 계산을 시작한다.
procedure CMXTradeStrategyREL_T1.Calculate(ARecalculation: Boolean);
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
  f_LineValueSeries.TS_IntraDayHL(m_ChartDataSeries, TSOPTION_VALUE_MAJOR_PRICE, 0, f_Begin, f_End);
  f_LineValueSeries.TS_NAverage(m_Option.GetIntegerValue('LENGTH1'), f_LineValueSeries, 0, 1, f_Begin, f_End);

  f_LineValueSeries := m_LineCollection.Items[1];
  f_LineValueSeries.m_Precision := m_ChartDataSeries.m_Precision;
  f_LineValueSeries.TS_HLPrice(m_PriceLineValueSeries, 1, 2, 0, f_Begin, f_End);
  f_LineValueSeries.TS_NAverage(m_Option.GetIntegerValue('LENGTH1'), f_LineValueSeries, 0, 1, f_Begin, f_End);
{$ENDREGION}
  CalulateFactor(f_Begin, f_End);

  CalculateReinforce(f_Begin, f_End);

  CalulateSignal(f_Begin, f_End);

  CalulateReinforceSignal(f_Begin, f_End);

  ApplyFilter(f_Begin, f_End);

  SetChartDataSeriesToLineSeries;
end;

// ---------------------------------------------------------------------------
procedure CMXTradeStrategyREL_T1.CalulateFactor(p_Begin: Integer; p_End: Integer);
var
  f_Index: Integer;

  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;

  f_LineValue00: CMKLineValue;
  f_LineValue10: CMKLineValue;
  f_LineValue20: CMKLineValue;
  f_LineValue01: CMKLineValue;
  f_LineValue11: CMKLineValue;
  f_LineValue21: CMKLineValue;

  f_LineValue05: CMKLineValue;
  f_LineValue15: CMKLineValue;

  f_LineValueSeries0: CMXTSLineValueSeries;
  f_LineValueSeries1: CMXTSLineValueSeries;
  f_LineValueSeries2: CMXTSLineValueSeries;

  f_PMA, f_P, f_OMA, f_O: Double;
  f_P0, f_O0: Double;
  f_Length1: Integer;
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
  f_LineValueSeries0 := m_LineCollection.Items[0]; // 가격
  f_LineValueSeries1 := m_LineCollection.Items[1]; // OPS
  f_LineValueSeries2 := m_LineCollection.Items[2];
  f_LineValueSeries2.SetLengthSeries(m_ChartDataSeries.m_Items.Count);
{$ENDREGION}
{$REGION '계산에 필요한 변수 초기화'}
  f_Length1 := m_Option.GetIntegerValue('LENGTH1');
{$ENDREGION}
{$REGION '실가격과 OPS와의 차이를 측정한다'}
  if 0 = m_Option.GetIntegerValue('METHOD') then
  begin

{$REGION '시스템'}
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_LineValue00 := f_LineValueSeries0.m_Items[f_Index];
      f_LineValue10 := f_LineValueSeries1.m_Items[f_Index];
      f_LineValue20 := f_LineValueSeries2.m_Items[f_Index];

      if (f_Index > 0) then
      begin
        f_LineValue01 := f_LineValueSeries0.m_Items[f_Index - 1];
        f_LineValue11 := f_LineValueSeries1.m_Items[f_Index - 1];
        f_LineValue21 := f_LineValueSeries2.m_Items[f_Index - 1];

        f_LineValue20.m_Value[0] := NOT_VALUE;

        if ((f_LineValue00.m_Value[0] <> NOT_VALUE) AND (f_LineValue00.m_Value[1] <> NOT_VALUE) AND
            (f_LineValue10.m_Value[0] <> NOT_VALUE) AND (f_LineValue10.m_Value[1] <> NOT_VALUE)) then
        begin
          f_P := f_LineValue00.m_Value[0];
          f_PMA := f_LineValue00.m_Value[1];
          f_O := f_LineValue10.m_Value[0];
          f_OMA := f_LineValue10.m_Value[1];

          if (f_OMA <> 0) and (f_PMA <> 0) then
          begin
            f_LineValue20.m_Value[0] := (f_O / f_OMA) - (f_P / f_PMA);
          end
          else
          begin
            f_LineValue20.m_Value[0] := 0;
          end;
        end;

      end
      else
      begin
        f_LineValue20.m_Value[0] := NOT_VALUE;
      end;
    end;
{$ENDREGION}
  end
  else
  begin

{$REGION '시스템'}
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_LineValue00 := f_LineValueSeries0.m_Items[f_Index];
      f_LineValue10 := f_LineValueSeries1.m_Items[f_Index];
      f_LineValue20 := f_LineValueSeries2.m_Items[f_Index];

      if (f_Index > f_Length1) then
      begin
        f_LineValue01 := f_LineValueSeries0.m_Items[f_Index - 1];
        f_LineValue11 := f_LineValueSeries1.m_Items[f_Index - 1];
        f_LineValue21 := f_LineValueSeries2.m_Items[f_Index - 1];

        f_LineValue05 := f_LineValueSeries0.m_Items[f_Index - f_Length1];
        f_LineValue15 := f_LineValueSeries1.m_Items[f_Index - f_Length1];

        f_LineValue20.m_Value[0] := NOT_VALUE;

        if ((f_LineValue00.m_Value[0] <> NOT_VALUE) AND (f_LineValue00.m_Value[1] <> NOT_VALUE) AND
            (f_LineValue10.m_Value[0] <> NOT_VALUE) AND (f_LineValue10.m_Value[1] <> NOT_VALUE) AND
            (f_LineValue05.m_Value[0] <> NOT_VALUE) AND (f_LineValue15.m_Value[0] <> NOT_VALUE)) then
        begin
          f_P := f_LineValue00.m_Value[0];
          f_PMA := f_LineValue00.m_Value[1];
          f_O := f_LineValue10.m_Value[0];
          f_OMA := f_LineValue10.m_Value[1];

          f_P0 := f_LineValue05.m_Value[0];
          f_O0 := f_LineValue15.m_Value[0];

          if (f_O0 <> 0) and (f_P0 <> 0) then
          begin
            f_LineValue20.m_Value[0] := ((f_O - f_O0) / f_O0) - ((f_P - f_P0) / f_P0);
          end
          else
          begin
            f_LineValue20.m_Value[0] := 0;
          end;
        end;
      end
      else
      begin
        f_LineValue20.m_Value[0] := NOT_VALUE;
      end;
    end;
{$ENDREGION}
  end;
{$ENDREGION}
  f_LineValueSeries2.m_Effect := true;
end;

// ---------------------------------------------------------------------------
// 신호를 계산한다.
procedure CMXTradeStrategyREL_T1.CalulateSignal(p_Begin: Integer; p_End: Integer);
var
  f_Index: Integer;

  f_LineValue00: CMKLineValue;
  f_LineValue10: CMKLineValue;
  f_LineValue20: CMKLineValue;
  f_LineValue01: CMKLineValue;
  f_LineValue11: CMKLineValue;
  f_LineValue21: CMKLineValue;

  f_LineValueSeries0: CMXTSLineValueSeries;
  f_LineValueSeries1: CMXTSLineValueSeries;
  f_LineValueSeries2: CMXTSLineValueSeries;
  f_SignalValueSeries0: CMXTSLineValueSeries;

  f_SigLineValue0: CMKLineValue;
  f_SigLineValue1: CMKLineValue;

  f_UP: Double;
  f_DN: Double;
  f_Length1: Integer;
  f_UseExit: Boolean;
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
  f_LineValueSeries0 := m_LineCollection.Items[0]; // 가격
  f_LineValueSeries1 := m_LineCollection.Items[1]; // OPS
  f_LineValueSeries2 := m_LineCollection.Items[2];
  f_SignalValueSeries0 := m_LineCollection.Items[m_SIGNAL_LINE_ZERO + 0];
  f_SignalValueSeries0.SetLengthSeries(m_ChartDataSeries.m_Items.Count);
{$ENDREGION}
{$REGION '계산에 필요한 변수 초기화'}
  f_UP := m_Option.GetDoubleValue('UP');
  f_DN := m_Option.GetDoubleValue('DN');
  f_Length1 := m_Option.GetIntegerValue('LENGTH1');
  f_UseExit := m_Option.GetBooleanValue('USEEXIT');
{$ENDREGION}
{$REGION '보조지표들의 특정을 비교하여 신호 계산'}
  for f_Index := p_Begin to p_End - 1 do
  begin
    f_LineValue00 := f_LineValueSeries0.m_Items[f_Index];
    f_LineValue10 := f_LineValueSeries1.m_Items[f_Index];
    f_LineValue20 := f_LineValueSeries2.m_Items[f_Index];
    f_SigLineValue0 := f_SignalValueSeries0.m_Items[f_Index];

    if (f_Index > 1) then
    begin
      f_LineValue01 := f_LineValueSeries0.m_Items[f_Index - 1];
      f_LineValue11 := f_LineValueSeries1.m_Items[f_Index - 1];
      f_LineValue21 := f_LineValueSeries2.m_Items[f_Index - 1];
      f_SigLineValue1 := f_SignalValueSeries0.m_Items[f_Index - 1];

      f_SigLineValue0.m_Value[0] := f_SigLineValue1.m_Value[0];

      if ((f_LineValue00.m_Value[0] <> NOT_VALUE) AND (f_LineValue00.m_Value[1] <> NOT_VALUE) AND
          (f_LineValue10.m_Value[0] <> NOT_VALUE) AND (f_LineValue10.m_Value[1] <> NOT_VALUE) AND
          (f_LineValue20.m_Value[0] <> NOT_VALUE)) then
      begin
        if (f_SigLineValue0.m_Value[0] <> STRATEGY_BUY) then
        begin
          if (f_LineValue10.m_Value[1] < f_LineValue10.m_Value[0]) and // MA(OPS) < OPS
              (f_LineValue00.m_Value[1] < f_LineValue00.m_Value[0]) and // MA(P) < P
              (f_UP < f_LineValue20.m_Value[0]) // 0.003 < FACTOR
          then
          begin
            f_SigLineValue0.m_Value[0] := STRATEGY_BUY;
          end;
        end;

        if (f_SigLineValue0.m_Value[0] <> STRATEGY_SELL) then
        begin
          if (f_LineValue10.m_Value[1] > f_LineValue10.m_Value[0]) and // MA(OPS) > OPS
              (f_LineValue00.m_Value[1] > f_LineValue00.m_Value[0]) and // MA(P) > P
              (f_DN > f_LineValue20.m_Value[0]) // -0.003 > FACTOR
          then
          begin
            f_SigLineValue0.m_Value[0] := STRATEGY_SELL;
          end;
        end;
        (*
          if f_UseExit then
          begin

          if (f_SigLineValue0.m_Value[0] = STRATEGY_BUY) then
          begin
          if
          (f_LineValue10.m_Value[1] > f_LineValue10.m_Value[0]) and       //      MA(OPS) > OPS
          (f_LineValue00.m_Value[1] > f_LineValue00.m_Value[0])           //      MA(P) > P
          then
          begin
          f_SigLineValue0.m_Value[0] := STRATEGY_EXIT;
          end;
          end;

          if (f_SigLineValue0.m_Value[0] = STRATEGY_SELL) then
          begin
          if
          (f_LineValue10.m_Value[1] < f_LineValue10.m_Value[0]) and       //      MA(OPS) < OPS
          (f_LineValue00.m_Value[1] < f_LineValue00.m_Value[0])           //      MA(P) < P
          then
          begin
          f_SigLineValue0.m_Value[0] := STRATEGY_EXIT;
          end;
          end;

          end;
        *)
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
