unit MXTradeStrategyBB_T1;

interface

uses
  SysUtils, MKChartData, MKChartDataSeries, MKLineValue, MKLineValueSeries, MXTSLineValueSeries, MXTradeStrategy;

type
  // ---------------------------------------------------------------------------
  // 볼랜저밴드의  추세 1에 사용하는 보조지표와 신호를 계산하는 클래스
  // ---------------------------------------------------------------------------
  CMXTradeStrategyBB_T1 = class(CMXTradeStrategy)
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

uses MKGlobal, MKConst, MKColorSet, MXTradeStrategyOptionCollection, MKTradeStrategyConst;

// ---------------------------------------------------------------------------
// 생성자
// 생성자
constructor CMXTradeStrategyBB_T1.Create();
begin
  inherited Create();

  CMXTradeStrategyOption.Default_BB_T1(m_Option);
  m_Category := m_Option.GetStringValue('CATEGORY');
  m_Name := m_Option.GetStringValue('NAME');

end;

// ---------------------------------------------------------------------------
// 파괴자
// 파괴자
destructor CMXTradeStrategyBB_T1.Destroy();
begin
  inherited Destroy();
end;

// ---------------------------------------------------------------------------
// 계산에 필요한 라인을 생성한다.
procedure CMXTradeStrategyBB_T1.CreateLineValueSeries;
var
  f_LineValueSeries: CMXTSLineValueSeries;
begin
  DeleteLineValueSeries;
  Clear;

  m_ChartBlockCount := 0;

  // 첫번째 라인
  f_LineValueSeries := Creator_BBWidth;
  f_LineValueSeries.m_Name := 'ST-BB-T1-L1';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  f_LineValueSeries.SetValueCount(1);
  f_LineValueSeries.m_AbsoluteMaxMin := true;
  f_LineValueSeries.m_AbsoluteMax := 100;
  f_LineValueSeries.m_AbsoluteMin := 0;
  f_LineValueSeries.m_Values[0] := m_Option.GetDoubleValue('THRESHOLD');
  f_LineValueSeries.m_ValueColors[0] := 1;
  f_LineValueSeries.m_ValueEnables[0] := true;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);

  // 두번째 라인
  f_LineValueSeries := Creator_BBand;
  f_LineValueSeries.m_Name := 'ST-BB-T1-L2';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);

  // 세번째 라인
  f_LineValueSeries := Creator_BBand;
  f_LineValueSeries.m_Name := 'ST-BB-T1-L3';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);

  // 네번째 라인
  f_LineValueSeries := Creator_AnyLineValueSeries(9);
  f_LineValueSeries.m_Name := 'ST-BB-T1-L4';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount - 2;
  f_LineValueSeries.m_TradeStrategyIndex[1] := m_ChartBlockCount - 1;
  f_LineValueSeries.m_TradeStrategyIndex[2] := -1;
  AddLineValueSeries(f_LineValueSeries);

  CreateReinforceLineValueSeries(m_ChartBlockCount);

  m_SIGNAL_LINE_ZERO := m_LineCollection.Count;

  // 다섯번째 라인
  f_LineValueSeries := Creator_AnySignalValueSeries(2);
  f_LineValueSeries.m_Name := 'ST-BB-T1-S1';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);

  CreateReinforceSignalLineValueSeries(m_ChartBlockCount);

  // 여섯번째 라인
  f_LineValueSeries := Creator_SignalLineValueSeries;
  f_LineValueSeries.m_Name := 'ST-BB-T1-S2';
  f_LineValueSeries.m_TradeStrategy := true;
  f_LineValueSeries.m_TradeStrategyIndex[0] := m_ChartBlockCount;
  f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
  AddLineValueSeries(f_LineValueSeries);
  Inc(m_ChartBlockCount);
end;

// ---------------------------------------------------------------------------
// 옵션이 변경되어 재계산이 될 때 화면에 표시한 것들중에 옵션에 관련된 사항들을 적용한다.
procedure CMXTradeStrategyBB_T1.UpdateVisibleStateOfLineValueSeries;
var
  f_LineValueSeries: CMXTSLineValueSeries;
  f_Index: Integer;
begin
  f_LineValueSeries := m_LineCollection.Items[0];
  f_LineValueSeries.m_Values[0] := m_Option.GetDoubleValue('THRESHOLD');
  f_LineValueSeries.m_AbsoluteMaxMin := true;
  f_LineValueSeries.m_AllowOverFlow := true;
  f_LineValueSeries.m_AbsoluteMax := m_Option.GetDoubleValue('THRESHOLD') * 1.2;
  f_LineValueSeries.m_AbsoluteMin := 0;

  f_LineValueSeries := m_LineCollection.Items[3];

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
procedure CMXTradeStrategyBB_T1.Calculate(ARecalculation: Boolean);
var
  f_Begin, f_End: Integer;
  f_LineValueSeries: CMXTSLineValueSeries;
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
  f_LineValueSeries.m_Options[0] := m_Option.GetIntegerValue('LENGTH0');
  f_LineValueSeries.m_Options[1] := m_Option.GetIntegerValue('SIGMA0');
  f_LineValueSeries.TS_BBWidth(m_Option.GetIntegerValue('LENGTH0'), m_Option.GetDoubleValue('SIGMA0'), 5,
      m_PriceLineValueSeries, 3, 0, f_Begin, f_End);
{$ENDREGION}
{$REGION '두번째 보조지표를 계산한다'}
  f_LineValueSeries := m_LineCollection.Items[1];
  f_LineValueSeries.m_Precision := m_ChartDataSeries.m_Precision;
  f_LineValueSeries.m_Options[0] := m_Option.GetIntegerValue('LENGTH1');
  f_LineValueSeries.m_Options[1] := m_Option.GetIntegerValue('SIGMA1');
  f_LineValueSeries.TS_BBand(m_Option.GetIntegerValue('LENGTH1'), m_Option.GetDoubleValue('SIGMA1'), m_PriceLineValueSeries, 3,
      0, f_Begin, f_End);

  f_LineValueSeries := m_LineCollection.Items[2];
  f_LineValueSeries.m_Precision := m_ChartDataSeries.m_Precision;
  f_LineValueSeries.m_Options[0] := m_Option.GetIntegerValue('LENGTH2');
  f_LineValueSeries.m_Options[1] := m_Option.GetIntegerValue('SIGMA2');
  f_LineValueSeries.TS_BBand(m_Option.GetIntegerValue('LENGTH2'), m_Option.GetDoubleValue('SIGMA2'), m_PriceLineValueSeries, 3,
      0, f_Begin, f_End);

  f_LineValueSeries := m_LineCollection.Items[3];
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

{$REGION '계산방식 함께 계산'}
(*
  //---------------------------------------------------------------------------
  procedure CMXTradeStrategyBB_T1.CalulateSignal(p_Begin:Integer; p_End:Integer);
  var
  f_Index:Integer;

  f_BASELineValue:CMKLineValue;

  f_SourceLineValue0:CMKLineValue;
  f_SourceLineValue1:CMKLineValue;

  f_MALineValue0:CMKLineValue;
  f_MALineValue1:CMKLineValue;

  f_SigLineValue0:CMKLineValue;
  f_SigLineValue1:CMKLineValue;

  f_LineValueSeries0 : CMXTSLineValueSeries;
  f_LineValueSeries1 : CMXTSLineValueSeries;
  f_LineValueSeries2 : CMXTSLineValueSeries;
  f_LineValueSeries3 : CMXTSLineValueSeries;
  f_SignalValueSeries1 : CMXTSLineValueSeries;
  f_THRESHOLD:Double;
  begin
  if (m_LineCollection.Count < 4) then exit;
  if not Assigned(m_ChartDataSeries) then exit;

  if (p_Begin = -1) then p_Begin := 0;
  if (p_End = -1) then p_End := m_ChartDataSeries.m_Items.Count;
  if (p_End > m_ChartDataSeries.m_Items.Count) then p_End := m_ChartDataSeries.m_Items.Count;

  if (p_Begin > m_ChartDataSeries.m_Items.Count - 1) then p_Begin := m_ChartDataSeries.m_Items.Count - 1;
  if (p_Begin < 0) then p_Begin := 0;

  f_LineValueSeries0 := m_LineCollection.Items[0];
  f_LineValueSeries1 := m_LineCollection.Items[1];
  f_LineValueSeries2 := m_LineCollection.Items[2];
  f_SignalValueSeries1 := m_LineCollection.Items[5];

  f_THRESHOLD := m_Option.GetDoubleValue('THRESHOLD');

  for f_Index := p_Begin to p_End - 1 do
  begin
  f_BASELineValue     := f_LineValueSeries0.m_Items   [f_Index];
  f_MALineValue0      := f_LineValueSeries3.m_Items   [f_Index];
  f_SigLineValue0     := f_SignalValueSeries1.m_Items [f_Index];

  if (f_Index > 0) then
  begin
  f_MALineValue1      := f_LineValueSeries3.m_Items   [f_Index-1];
  f_SigLineValue1     := f_SignalValueSeries1.m_Items [f_Index-1];

  f_SigLineValue0.m_Value[0] := f_SigLineValue1.m_Value[0];

  if  (
  (f_BASELineValue.m_Value[0] <> NOT_VALUE) AND
  (f_BASELineValue.m_Value[1] <> NOT_VALUE) AND
  (f_MALineValue0.m_Value[0] <> NOT_VALUE) AND
  (f_MALineValue1.m_Value[0] <> NOT_VALUE)
  )
  then
  begin
  if (abs(f_BASELineValue.m_Value[0] - f_BASELineValue.m_Value[1]) <= f_THRESHOLD) then
  begin
  f_SourceLineValue0  := f_LineValueSeries1.m_Items   [f_Index  ];
  f_SourceLineValue1  := f_LineValueSeries1.m_Items   [f_Index-1];

  if  (
  (f_SourceLineValue0.m_Value[0] <> NOT_VALUE) AND
  (f_SourceLineValue1.m_Value[0] <> NOT_VALUE) AND
  (f_SourceLineValue0.m_Value[1] <> NOT_VALUE) AND
  (f_SourceLineValue1.m_Value[1] <> NOT_VALUE) AND
  (f_SourceLineValue0.m_Value[2] <> NOT_VALUE) AND
  (f_SourceLineValue1.m_Value[2] <> NOT_VALUE)
  )
  then
  begin
  if (f_SigLineValue0.m_Value[0] <> STRATEGY_BUY) then
  begin
  //  주가또는 MA가 하한선을 상향돌파 => 매수
  if (f_SourceLineValue1.m_Value[1] >= f_MALineValue1.m_Value[0]) and (f_SourceLineValue0.m_Value[1] < f_MALineValue0.m_Value[0]) then
  begin
  f_SigLineValue0.m_Value[0] := STRATEGY_BUY;
  end else
  //  주가또는 MA가 중심선 상향돌파 => 매수
  if (f_SourceLineValue1.m_Value[2] >= f_MALineValue1.m_Value[0]) and (f_SourceLineValue0.m_Value[2] < f_MALineValue0.m_Value[0]) then
  begin
  f_SigLineValue0.m_Value[0] := STRATEGY_BUY;
  end else
  //  주가또는 MA가 상한선 상향돌파 => 매수
  if (f_SourceLineValue1.m_Value[0] >= f_MALineValue1.m_Value[0]) and (f_SourceLineValue0.m_Value[0] < f_MALineValue0.m_Value[0]) then
  begin
  f_SigLineValue0.m_Value[0] := STRATEGY_BUY;
  end;
  end;

  if (f_SigLineValue0.m_Value[0] <> STRATEGY_SELL) then
  begin
  //  주가또는 MA가 하한선을 하향돌파 => 매도
  if (f_SourceLineValue1.m_Value[1] <= f_MALineValue1.m_Value[0]) and (f_SourceLineValue0.m_Value[1] > f_MALineValue0.m_Value[0]) then
  begin
  f_SigLineValue0.m_Value[0] := STRATEGY_SELL;
  end else
  //  주가또는 MA가 중심선 하향돌파 => 매도
  if (f_SourceLineValue1.m_Value[2] <= f_MALineValue1.m_Value[0]) and (f_SourceLineValue0.m_Value[2] > f_MALineValue0.m_Value[0]) then
  begin
  f_SigLineValue0.m_Value[0] := STRATEGY_SELL;
  end else
  //  주가또는 MA가 상한선 하향돌파 => 매도
  if (f_SourceLineValue1.m_Value[0] <= f_MALineValue1.m_Value[0]) and (f_SourceLineValue0.m_Value[0] > f_MALineValue0.m_Value[0]) then
  begin
  f_SigLineValue0.m_Value[0] := STRATEGY_SELL;
  end;
  end;
  end;
  end else
  begin
  f_SourceLineValue0  := f_LineValueSeries2.m_Items   [f_Index  ];
  f_SourceLineValue1  := f_LineValueSeries2.m_Items   [f_Index-1];

  if  (
  (f_SourceLineValue0.m_Value[0] <> NOT_VALUE) AND
  (f_SourceLineValue1.m_Value[0] <> NOT_VALUE) AND
  (f_SourceLineValue0.m_Value[1] <> NOT_VALUE) AND
  (f_SourceLineValue1.m_Value[1] <> NOT_VALUE) AND
  (f_SourceLineValue0.m_Value[2] <> NOT_VALUE) AND
  (f_SourceLineValue1.m_Value[2] <> NOT_VALUE)
  )
  then
  begin
  if (f_SigLineValue0.m_Value[0] <> STRATEGY_BUY) then
  begin
  //  주가또는 MA가 하한선을 상향돌파 => 매수
  if (f_SourceLineValue1.m_Value[1] >= f_MALineValue1.m_Value[0]) and (f_SourceLineValue0.m_Value[1] < f_MALineValue0.m_Value[0]) then
  begin
  f_SigLineValue0.m_Value[0] := STRATEGY_BUY;
  end else
  //  주가또는 MA가 상한선을 상향돌파 => 매수
  if (f_SourceLineValue1.m_Value[0] >= f_MALineValue1.m_Value[0]) and (f_SourceLineValue0.m_Value[0] < f_MALineValue0.m_Value[0]) then
  begin
  f_SigLineValue0.m_Value[0] := STRATEGY_BUY;
  end;
  end;

  if (f_SigLineValue0.m_Value[0] <> STRATEGY_SELL) then
  begin
  //  주가또는 MA가 하한선을 하향돌파 => 매도
  if (f_SourceLineValue1.m_Value[1] <= f_MALineValue1.m_Value[0]) and (f_SourceLineValue0.m_Value[1] > f_MALineValue0.m_Value[0]) then
  begin
  f_SigLineValue0.m_Value[0] := STRATEGY_SELL;
  end else
  //  주가또는 MA가 상한선을 하향돌파 => 매도
  if (f_SourceLineValue1.m_Value[0] <= f_MALineValue1.m_Value[0]) and (f_SourceLineValue0.m_Value[0] > f_MALineValue0.m_Value[0]) then
  begin
  f_SigLineValue0.m_Value[0] := STRATEGY_SELL;
  end;
  end;
  end;
  end;
  end;
  end else
  begin
  f_SigLineValue0.m_Value[0]:= STRATEGY_EXIT;
  end;
  end;
  end;
*)
{$ENDREGION}

// ---------------------------------------------------------------------------
// 신호를 계산한다.
procedure CMXTradeStrategyBB_T1.CalulateSignal(p_Begin: Integer; p_End: Integer);
var
  f_Index: Integer;

  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;

  f_BASELineValue: CMKLineValue;
  f_BASELineValue0: CMKLineValue;
  f_BASELineValue1: CMKLineValue;

  f_SourceLineValue0: CMKLineValue;
  f_SourceLineValue1: CMKLineValue;

  f_PMLineValue0: CMKLineValue;
  f_PMLineValue1: CMKLineValue;

  f_SigLineValue0: CMKLineValue;
  f_SigLineValue1: CMKLineValue;

  f_LineValueSeries0: CMXTSLineValueSeries;
  f_LineValueSeries1: CMXTSLineValueSeries;
  f_LineValueSeries2: CMXTSLineValueSeries;
  f_LineValueSeries3: CMXTSLineValueSeries;

  f_SignalValueSeries0: CMXTSLineValueSeries;
  f_SignalValueSeries1: CMXTSLineValueSeries;

  f_THRESHOLD: Double;
  f_SIGNAL_SEQ: Integer;

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
  f_LineValueSeries2 := m_LineCollection.Items[2];
  f_LineValueSeries3 := m_LineCollection.Items[3];
  f_SignalValueSeries0 := m_LineCollection.Items[m_SIGNAL_LINE_ZERO + 0];
  f_SignalValueSeries1 := m_LineCollection.Items[m_SIGNAL_LINE_ZERO + 1];

  f_SignalValueSeries0.SetLengthSeries(m_ChartDataSeries.m_Items.Count);
  f_SignalValueSeries1.SetLengthSeries(m_ChartDataSeries.m_Items.Count);
{$ENDREGION}
{$REGION '계산에 필요한 변수 초기화'}
  f_MAUP_0_IDX := GetPMUpperLine();
  f_MADN_0_IDX := GetPMDownLine();
  f_THRESHOLD := m_Option.GetDoubleValue('THRESHOLD');

  f_UseTolerance := m_Option.GetBooleanValue('USE_TOLERANCE');
  f_Tolerance := m_Option.GetDoubleValue('TOLERANCE');
  f_ToleranceUnit := m_Option.GetIntegerValue('TOLERANCE_UNIT');
{$ENDREGION}
{$REGION '보조지표들의 특정을 비교하여 신호 계산'}
{$REGION '1번 신호'}
  f_SIGNAL_SEQ := 0;
  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SourceLineValue0 := f_LineValueSeries1.m_Items[f_Index];
    f_PMLineValue0 := f_LineValueSeries3.m_Items[f_Index];
    f_SigLineValue0 := f_SignalValueSeries0.m_Items[f_Index];

    if (f_Index > 0) then
    begin
      f_SourceLineValue1 := f_LineValueSeries1.m_Items[f_Index - 1];
      f_PMLineValue1 := f_LineValueSeries3.m_Items[f_Index - 1];
      f_SigLineValue1 := f_SignalValueSeries0.m_Items[f_Index - 1];

      f_SigLineValue0.m_Value[f_SIGNAL_SEQ] := f_SigLineValue1.m_Value[f_SIGNAL_SEQ];

      if ((f_SourceLineValue0.m_Value[0] <> NOT_VALUE) AND (f_SourceLineValue1.m_Value[0] <> NOT_VALUE) AND
          (f_SourceLineValue0.m_Value[1] <> NOT_VALUE) AND (f_SourceLineValue1.m_Value[1] <> NOT_VALUE) AND
          (f_SourceLineValue0.m_Value[2] <> NOT_VALUE) AND (f_SourceLineValue1.m_Value[2] <> NOT_VALUE) AND
          (f_PMLineValue0.m_Value[f_MAUP_0_IDX] <> NOT_VALUE) AND (f_PMLineValue0.m_Value[f_MADN_0_IDX] <> NOT_VALUE) AND
          (f_PMLineValue1.m_Value[f_MAUP_0_IDX] <> NOT_VALUE) AND (f_PMLineValue1.m_Value[f_MADN_0_IDX] <> NOT_VALUE)) then
      begin

        if (f_SigLineValue0.m_Value[f_SIGNAL_SEQ] <> STRATEGY_BUY) then
        begin
{$REGION '상한선 상향돌파 => 매수'}
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[0] + ((f_Tolerance / 100.0) * f_SourceLineValue1.m_Value[0]);
              f_TargetValue0 := f_SourceLineValue0.m_Value[0] + ((f_Tolerance / 100.0) * f_SourceLineValue0.m_Value[0]);
            end
            else
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[0] + f_Tolerance;
              f_TargetValue0 := f_SourceLineValue0.m_Value[0] + f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue1 := f_SourceLineValue1.m_Value[0];
            f_TargetValue0 := f_SourceLineValue0.m_Value[0];
          end;

          if (f_TargetValue1 >= f_PMLineValue1.m_Value[f_MADN_0_IDX]) and (f_TargetValue0 < f_PMLineValue0.m_Value[f_MADN_0_IDX])
          then
          begin
            f_SigLineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_BUY;
          end;
{$ENDREGION}
{$REGION '하한선을 상향돌파 => 매수'}
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[1] + ((f_Tolerance / 100.0) * f_SourceLineValue1.m_Value[1]);
              f_TargetValue0 := f_SourceLineValue0.m_Value[1] + ((f_Tolerance / 100.0) * f_SourceLineValue0.m_Value[1]);
            end
            else
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[1] + f_Tolerance;
              f_TargetValue0 := f_SourceLineValue0.m_Value[1] + f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue1 := f_SourceLineValue1.m_Value[1];
            f_TargetValue0 := f_SourceLineValue0.m_Value[1];
          end;

          if (f_TargetValue1 >= f_PMLineValue1.m_Value[f_MADN_0_IDX]) and (f_TargetValue0 < f_PMLineValue0.m_Value[f_MADN_0_IDX])
          then
          begin
            f_SigLineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_BUY;
          end;
{$ENDREGION}
        end;

        if (f_SigLineValue0.m_Value[f_SIGNAL_SEQ] <> STRATEGY_SELL) then
        begin

{$REGION '하한선을 하향돌파 => 매도'}
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[1] - ((f_Tolerance / 100.0) * f_SourceLineValue1.m_Value[1]);
              f_TargetValue0 := f_SourceLineValue0.m_Value[1] - ((f_Tolerance / 100.0) * f_SourceLineValue0.m_Value[1]);
            end
            else
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[1] - f_Tolerance;
              f_TargetValue0 := f_SourceLineValue0.m_Value[1] - f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue1 := f_SourceLineValue1.m_Value[1];
            f_TargetValue0 := f_SourceLineValue0.m_Value[1];
          end;

          if (f_TargetValue1 <= f_PMLineValue1.m_Value[f_MAUP_0_IDX]) and (f_TargetValue0 > f_PMLineValue0.m_Value[f_MAUP_0_IDX])
          then
          begin
            f_SigLineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_SELL;
          end;
{$ENDREGION}
{$REGION '상한선을 하향돌파 => 매도'}
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[0] - ((f_Tolerance / 100.0) * f_SourceLineValue1.m_Value[0]);
              f_TargetValue0 := f_SourceLineValue0.m_Value[0] - ((f_Tolerance / 100.0) * f_SourceLineValue0.m_Value[0]);
            end
            else
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[0] - f_Tolerance;
              f_TargetValue0 := f_SourceLineValue0.m_Value[0] - f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue1 := f_SourceLineValue1.m_Value[0];
            f_TargetValue0 := f_SourceLineValue0.m_Value[0];
          end;

          if (f_TargetValue1 <= f_PMLineValue1.m_Value[f_MAUP_0_IDX]) and (f_TargetValue0 > f_PMLineValue0.m_Value[f_MAUP_0_IDX])
          then
          begin
            f_SigLineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_SELL;
          end;
{$ENDREGION}
        end;
      end;
    end
    else
    begin
      f_SigLineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
    end;
  end;
{$ENDREGION}
{$REGION '2번 신호'}
  f_SIGNAL_SEQ := 1;
  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SourceLineValue0 := f_LineValueSeries2.m_Items[f_Index];
    f_PMLineValue0 := f_LineValueSeries3.m_Items[f_Index];
    f_SigLineValue0 := f_SignalValueSeries0.m_Items[f_Index];

    if (f_Index > 0) then
    begin
      f_SourceLineValue1 := f_LineValueSeries2.m_Items[f_Index - 1];
      f_PMLineValue1 := f_LineValueSeries3.m_Items[f_Index - 1];
      f_SigLineValue1 := f_SignalValueSeries0.m_Items[f_Index - 1];

      f_SigLineValue0.m_Value[f_SIGNAL_SEQ] := f_SigLineValue1.m_Value[f_SIGNAL_SEQ];

      if ((f_SourceLineValue0.m_Value[0] <> NOT_VALUE) AND (f_SourceLineValue1.m_Value[0] <> NOT_VALUE) AND
          (f_SourceLineValue0.m_Value[1] <> NOT_VALUE) AND (f_SourceLineValue1.m_Value[1] <> NOT_VALUE) AND
          (f_SourceLineValue0.m_Value[2] <> NOT_VALUE) AND (f_SourceLineValue1.m_Value[2] <> NOT_VALUE) AND
          (f_PMLineValue0.m_Value[f_MAUP_0_IDX] <> NOT_VALUE) AND (f_PMLineValue0.m_Value[f_MADN_0_IDX] <> NOT_VALUE) AND
          (f_PMLineValue1.m_Value[f_MAUP_0_IDX] <> NOT_VALUE) AND (f_PMLineValue1.m_Value[f_MADN_0_IDX] <> NOT_VALUE)) then
      begin

        if (f_SigLineValue0.m_Value[f_SIGNAL_SEQ] <> STRATEGY_BUY) then
        begin
{$REGION '상한선 상향돌파 => 매수'}
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[0] + ((f_Tolerance / 100.0) * f_SourceLineValue1.m_Value[0]);
              f_TargetValue0 := f_SourceLineValue0.m_Value[0] + ((f_Tolerance / 100.0) * f_SourceLineValue0.m_Value[0]);
            end
            else
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[0] + f_Tolerance;
              f_TargetValue0 := f_SourceLineValue0.m_Value[0] + f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue1 := f_SourceLineValue1.m_Value[0];
            f_TargetValue0 := f_SourceLineValue0.m_Value[0];
          end;

          if (f_TargetValue1 >= f_PMLineValue1.m_Value[f_MADN_0_IDX]) and (f_TargetValue0 < f_PMLineValue0.m_Value[f_MADN_0_IDX])
          then
          begin
            f_SigLineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_BUY;
          end;
{$ENDREGION}
{$REGION '하한선을 상향돌파 => 매수'}
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[1] + ((f_Tolerance / 100.0) * f_SourceLineValue1.m_Value[1]);
              f_TargetValue0 := f_SourceLineValue0.m_Value[1] + ((f_Tolerance / 100.0) * f_SourceLineValue0.m_Value[1]);
            end
            else
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[1] + f_Tolerance;
              f_TargetValue0 := f_SourceLineValue0.m_Value[1] + f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue1 := f_SourceLineValue1.m_Value[1];
            f_TargetValue0 := f_SourceLineValue0.m_Value[1];
          end;

          if (f_TargetValue1 >= f_PMLineValue1.m_Value[f_MADN_0_IDX]) and (f_TargetValue0 < f_PMLineValue0.m_Value[f_MADN_0_IDX])
          then
          begin
            f_SigLineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_BUY;
          end;
{$ENDREGION}
        end;

        if (f_SigLineValue0.m_Value[f_SIGNAL_SEQ] <> STRATEGY_SELL) then
        begin

{$REGION '하한선을 하향돌파 => 매도'}
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[1] + ((f_Tolerance / 100.0) * f_SourceLineValue1.m_Value[1]);
              f_TargetValue0 := f_SourceLineValue0.m_Value[1] + ((f_Tolerance / 100.0) * f_SourceLineValue0.m_Value[1]);
            end
            else
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[1] + f_Tolerance;
              f_TargetValue0 := f_SourceLineValue0.m_Value[1] + f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue1 := f_SourceLineValue1.m_Value[1];
            f_TargetValue0 := f_SourceLineValue0.m_Value[1];
          end;

          if (f_TargetValue1 <= f_PMLineValue1.m_Value[f_MAUP_0_IDX]) and (f_TargetValue0 > f_PMLineValue0.m_Value[f_MAUP_0_IDX])
          then
          begin
            f_SigLineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_SELL;
          end;
{$ENDREGION}
{$REGION '상한선을 하향돌파 => 매도'}
          if f_UseTolerance then
          begin
            if 0 = f_ToleranceUnit then
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[0] - ((f_Tolerance / 100.0) * f_SourceLineValue1.m_Value[0]);
              f_TargetValue0 := f_SourceLineValue0.m_Value[0] - ((f_Tolerance / 100.0) * f_SourceLineValue0.m_Value[0]);
            end
            else
            begin
              f_TargetValue1 := f_SourceLineValue1.m_Value[0] - f_Tolerance;
              f_TargetValue0 := f_SourceLineValue0.m_Value[0] - f_Tolerance;
            end;
          end
          else
          begin
            f_TargetValue1 := f_SourceLineValue1.m_Value[0];
            f_TargetValue0 := f_SourceLineValue0.m_Value[0];
          end;

          if (f_TargetValue1 <= f_PMLineValue1.m_Value[f_MAUP_0_IDX]) and (f_TargetValue0 > f_PMLineValue0.m_Value[f_MAUP_0_IDX])
          then
          begin
            f_SigLineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_SELL;
          end;
{$ENDREGION}
        end;

      end;
    end
    else
    begin
      f_SigLineValue0.m_Value[f_SIGNAL_SEQ] := STRATEGY_EXIT;
    end;
  end;
{$ENDREGION}
{$ENDREGION}
{$REGION '2시그마의 1번과 2번을 차등적용한다'}
  for f_Index := p_Begin to p_End - 1 do
  begin
    f_BASELineValue := f_LineValueSeries0.m_Items[f_Index];
    f_SigLineValue0 := f_SignalValueSeries0.m_Items[f_Index];
    f_SigLineValue1 := f_SignalValueSeries1.m_Items[f_Index];

    if (abs(f_BASELineValue.m_Value[0]) <= f_THRESHOLD) then
    begin
      f_SigLineValue1.m_Value[0] := f_SigLineValue0.m_Value[1];
    end
    else
    begin
      f_SigLineValue1.m_Value[0] := f_SigLineValue0.m_Value[0];
    end;
  end;
{$ENDREGION}
  f_SignalValueSeries0.m_Effect := true;
  f_SignalValueSeries1.m_Effect := true;
end;

end.
