unit MKLineValueSeries;

interface

uses
  SysUtils, Classes, Types, Math, GR32,
  MKChartDataSeries, MKMaxMin, MKStreamChartDataSeries, MKLineValue, MKConst,
  MKChartData,
  MKSignalArray,
  MKSignalData,
  MKTradeSignalDefine;

type

  CMKLineValueSeries = class(TObject)
  public
    m_Items: TList;
    m_ChartDataSeries: CMKChartDataSeries;
    m_TimeFrame: Integer;
    m_Name: String;
    m_FullName: String;
    m_LastValueVisible: Boolean;
    m_ViewLabel: Boolean;
    m_LineCount: Integer;
    m_LineColors: Array of Integer;
    m_LineWidths: Array of Integer;
    m_LineAlphas: Array of Integer;
    m_LineTypes: Array of Integer;
    m_LineVisibles: Array of Boolean;
    m_LineLabelVisibles: Array of Boolean;
    m_LineLabelNameVisibles: Array of Boolean;
    m_LinePosValueVisibles: Array of Boolean;
    m_LineLastValueVisibles: Array of Boolean;
    m_LineNames: Array of String;

    m_LineMaxMinIndexs: Array of Integer;
    m_OptionCount: Integer;
    m_Options: Array of Double;
    m_ValueCount: Integer;
    m_Values: Array of Double;
    m_ValueColors: Array of Integer;
    m_ValueWidths: Array of Integer;
    m_ValueEnables: Array of Boolean;
    m_MaxMinCount: Integer;
    m_MaxMinTable: Array of CMKMaxMin;
    m_MaxMinFactor: Array of Double;
    m_Precision: Integer;
    m_StartIndex: Integer;
    m_Effect: Boolean;
    m_Type: Integer;
    m_OriginValue: Double;

    m_Signal: Boolean;
    m_TradeStrategySignal: Boolean;
    m_TradeStrategy: Boolean;
    m_TradeStrategyIndex: Array [0 .. 11] of Integer;

    m_AbsoluteMaxMin: Boolean;
    m_AllowOverflow: Boolean;
    m_AbsoluteMax: Double;
    m_AbsoluteMin: Double;
  private

  public
    constructor Create(p_Name: String; p_Type: Integer; p_LineCount: Integer = 1; p_OptionCount: Integer = 0;
        p_ValueCount: Integer = 0; p_MaxMinCount: Integer = 1);
    destructor Destroy(); override;

    procedure Clone(p_Source: CMKLineValueSeries);
    procedure Update(p_Source: CMKLineValueSeries);

    procedure SetValueCount(p_ValueCount: Integer);
    procedure SetLineCount(p_LineCount: Integer);
    procedure GetLineMaxMin(p_X1: Integer; p_X2: Integer; p_Origin: Integer = -1; p_CompareState: Integer = -1);
    procedure Clear();
    procedure Fill(p_Count: Integer);
    procedure SetLengthSeries(p_Length: Integer);

    procedure CreateLineValueAdd(p_Index: Integer; p_Value: Double; p_Count: Integer = 1);

    procedure Indicator_OPSPrice(p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_RealPrice(p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1; p_End: Integer = -1);

    procedure Indicator_Price(p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_Close(p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_Volume(p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure HiLoPrice(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_HiIndex: Integer; p_LoIndex: Integer;
        p_Position: Integer; var f_Hi, f_Low: Double);
    function HighestPrice(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer;
        p_Position: Integer): Double;
    function LowestPrice(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer; p_Position: Integer): Double;
    function HighestIndex(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer;
        p_Position: Integer): Integer;
    function LowestIndex(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer; p_Position: Integer)
        : Integer;
    procedure Indicator_NAverage(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_NXAverage(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_XAverage(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_WAverage(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_Subtraction(p_SrcLineSeries1: CMKLineValueSeries; p_SrcIndex1: Integer;
        p_SrcValueArray2: CMKLineValueSeries; p_SrcIndex2: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure Indicator_Division(p_SrcLineSeries1: CMKLineValueSeries; p_SrcIndex1: Integer;
        p_SrcValueArray2: CMKLineValueSeries; p_SrcIndex2: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure Indicator_MACD(p_FastMA: Integer; p_SlowMA: Integer; p_MA: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_NET(p_SmallMA: Integer; p_Increse: Integer; p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_SlowSTC(p_Length1: Integer; p_Length2: Integer; p_Length3: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_HighIndex: Integer; p_LowIndex: Integer; p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure Indicator_FastSTC(p_Length1: Integer; p_Length2: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_HighIndex: Integer; p_LowIndex: Integer; p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure Indicator_RSI(p_Length: Integer; p_MA: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_OBV(p_SrcValueArray: CMKLineValueSeries; p_CloseIndex: Integer; p_SrcValueArray2: CMKLineValueSeries;
        p_VolumeIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_TrueRange(p_SrcValueArray: CMKLineValueSeries; p_HighIndex: Integer; p_LowIndex: Integer;
        p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_PMDM(p_SrcValueArray: CMKLineValueSeries; p_HighIndex: Integer; p_LowIndex: Integer;
        p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_PMDI(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_ADX(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries; p_PDIIndex: Integer; p_MDIIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_StdDev(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer;
        p_SrcValueArray2: CMKLineValueSeries; p_MIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure Indicator_BBand(p_Count: Integer; p_Factor: Double; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_LRL(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_IMLine(p_Length1: Integer; p_Length2: Integer; p_Length3: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_HighIndex: Integer; p_LowIndex: Integer; p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure Indicator_WilliamsR(p_Count1: Integer; p_Count2: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_HighIndex: Integer; p_LowIndex: Integer; p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure Indicator_SONA(p_Length1: Integer; p_Length2: Integer; p_Length3: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_ROC(p_Length1: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_PMAO(p_Length1: Integer; p_Length2: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_Envelope(p_Length: Integer; p_Factor: Double; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_BBWidth(p_Count: Integer; p_Factor: Double; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_PSY(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer; p_TagIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_ATR(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries; p_HighIndex: Integer; p_LowIndex: Integer;
        p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_CCI(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries; p_HighIndex: Integer; p_LowIndex: Integer;
        p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_TRIX(p_Length1: Integer; p_Length2: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_SAR(p_Length: Double; p_SrcValueArray: CMKLineValueSeries; p_HighIndex: Integer; p_LowIndex: Integer;
        p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_VR(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer;
        p_SrcValueArray2: CMKLineValueSeries; p_VolumeIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);

    procedure Indicator_OPS_Price(p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_OPS(p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_OPS_IGUK(p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_OPS_IGUK2(p_Count: Integer; p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure Indicator_OPS_STD(p_Count: Integer; p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure Indicator_OPS_REL(p_Count: Integer; p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1;
        p_End: Integer = -1);

    procedure Indicator_CurveFitting(p_Count: Integer; p_SrcValueArray1: CMKLineValueSeries; p_SrcIndex1: Integer;
        p_SrcValueArray2: CMKLineValueSeries; p_SrcIndex2: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);

    procedure Indicator_CrossSignal(p_SrcValueArray: CMKLineValueSeries; p_SrcIndex1: Integer; p_SrcIndex2: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_MACD_CrossSignal(p_FastMA: Integer; p_SlowMA: Integer; p_MA: Integer;
        p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure Indicator_MA_CrossSignal(p_FastMA: Integer; p_SlowMA: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_Price_MA_CrossSignal(p_MA: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_SlowSTC_CrossSignal(p_Length1: Integer; p_Length2: Integer; p_Length3: Integer;
        p_SrcValueArray: CMKLineValueSeries; p_HighIndex: Integer; p_LowIndex: Integer; p_CloseIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_FastSTC_CrossSignal(p_Length1: Integer; p_Length2: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_HighIndex: Integer; p_LowIndex: Integer; p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure Indicator_RSI_CrossSignal(p_Length: Integer; p_MA: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_ADX_CrossSignal(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries; p_PDIIndex: Integer;
        p_MDIIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_WilliamsR_CrossSignal(p_Count1: Integer; p_Count2: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_HighIndex: Integer; p_LowIndex: Integer; p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure Indicator_SONA_CrossSignal(p_Length1: Integer; p_Length2: Integer; p_Length3: Integer;
        p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure Indicator_TRIX_CrossSignal(p_Length1: Integer; p_Length2: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);

    procedure Indicator_TrendSignal(p_SrcValueArray: CMKLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
    procedure Indicator_NMA_TrendSignal(p_MA: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_WMA_TrendSignal(p_MA: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_XMA_TrendSignal(p_MA: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);

    procedure ScanSignal(p_ChartDataSeries: CMKChartDataSeries; p_SignalArray: CMKSignalArray; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure ScanSignal2(p_ChartDataSeries: CMKChartDataSeries; p_SignalArray: CMKSignalArray; p_Sequence: Integer;
        p_Begin, p_End: Integer);
    procedure ScanSignalOfRealTime(p_ChartDataSeries: CMKChartDataSeries; p_SignalArray: CMKSignalArray; p_SrcIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);

    procedure Indicator_NAverageZ(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_XAverageZ(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);

    procedure Indicator_WAverage2(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_WAverage3(p_Count: Integer; p_Precision: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_WAverageZ(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);

  end;

implementation

uses
  MKGlobal;

// ---------------------------------------------------------------------------
{ /**
  * 생성자
  *
  * @param    p_Name         라인의 이름
  * @param    p_Type         라인의 형식
  * @param    p_LineCount    전체 라인의 수
  * @param    p_OptionCount  옵션의 수
  * @param    p_ValueCount   가로선의 수
  * @param    p_MaxMinCount  최대최소값의 수
  **/ }
constructor CMKLineValueSeries.Create(p_Name: String; p_Type: Integer; p_LineCount: Integer = 1; p_OptionCount: Integer = 0;
    p_ValueCount: Integer = 0; p_MaxMinCount: Integer = 1);
var
  f_Index: Integer;
  p_MaxMin: CMKMaxMin;
begin
  inherited Create();
  m_TradeStrategySignal := FALSE;
  m_TradeStrategy := FALSE;
  m_TradeStrategyIndex[0] := -1;

  m_AbsoluteMaxMin := FALSE;
  m_AllowOverflow := FALSE;
  m_AbsoluteMax := 0;
  m_AbsoluteMin := 0;

  m_Signal := FALSE;
  m_Effect := FALSE;
  m_Items := TList.Create();
  m_Name := p_Name;
  m_FullName := p_Name;
  m_Type := p_Type;
  m_LineCount := p_LineCount;
  SetLength(m_LineColors, m_LineCount);
  SetLength(m_LineWidths, m_LineCount);
  SetLength(m_LineAlphas, m_LineCount);
  SetLength(m_LineTypes, m_LineCount);
  SetLength(m_LineNames, m_LineCount);
  SetLength(m_LineVisibles, m_LineCount);
  SetLength(m_LineLabelVisibles, m_LineCount);
  SetLength(m_LineLabelNameVisibles, m_LineCount);
  SetLength(m_LinePosValueVisibles, m_LineCount);
  SetLength(m_LineMaxMinIndexs, m_LineCount);
  SetLength(m_LineLastValueVisibles, m_LineCount);
  for f_Index := 0 to m_LineCount - 1 do
  begin
    m_LineColors[f_Index] := f_Index;
    m_LineWidths[f_Index] := 0;
    m_LineAlphas[f_Index] := 0;
    m_LineTypes[f_Index] := 0;
    m_LineNames[f_Index] := '';
    m_LineVisibles[f_Index] := TRUE;
    m_LineLabelVisibles[f_Index] := TRUE;
    m_LineLabelNameVisibles[f_Index] := TRUE;
    m_LinePosValueVisibles[f_Index] := TRUE;
    m_LineLastValueVisibles[f_Index] := FALSE;
    m_LineMaxMinIndexs[f_Index] := 0;
  end;

  m_OptionCount := p_OptionCount;
  SetLength(m_Options, m_OptionCount);
  for f_Index := 0 to m_OptionCount - 1 do
  begin
    m_Options[f_Index] := 1;
  end;

  m_ValueCount := p_ValueCount;
  SetLength(m_Values, m_ValueCount);
  SetLength(m_ValueColors, m_ValueCount);
  SetLength(m_ValueWidths, m_ValueCount);
  SetLength(m_ValueEnables, m_ValueCount);
  for f_Index := 0 to m_ValueCount - 1 do
  begin
    m_Values[f_Index] := 0;
    m_ValueColors[f_Index] := f_Index;
    m_ValueWidths[f_Index] := 1;
    m_ValueEnables[f_Index] := TRUE;
  end;

  m_MaxMinCount := p_MaxMinCount;
  if (m_MaxMinCount <= 0) then
    m_MaxMinCount := 1;

  SetLength(m_MaxMinTable, m_MaxMinCount);
  SetLength(m_MaxMinFactor, m_MaxMinCount);
  for f_Index := 0 to m_MaxMinCount - 1 do
  begin
    p_MaxMin := CMKMaxMin.Create();
    m_MaxMinTable[f_Index] := p_MaxMin;
    m_MaxMinFactor[f_Index] := 1.0;
  end;

  m_TimeFrame := 360;
  m_Effect := FALSE;
  m_ViewLabel := TRUE;
  m_Precision := 2;
  m_StartIndex := 0;

  m_LastValueVisible := FALSE;
end;

procedure CMKLineValueSeries.SetValueCount(p_ValueCount: Integer);
var
  f_Index: Integer;
begin
  m_ValueCount := p_ValueCount;
  SetLength(m_Values, m_ValueCount);
  SetLength(m_ValueColors, m_ValueCount);
  SetLength(m_ValueWidths, m_ValueCount);
  SetLength(m_ValueEnables, m_ValueCount);
  for f_Index := 0 to m_ValueCount - 1 do
  begin
    m_Values[f_Index] := 0;
    m_ValueColors[f_Index] := f_Index;
    m_ValueWidths[f_Index] := 1;
    m_ValueEnables[f_Index] := TRUE;
  end;

end;

// ---------------------------------------------------------------------------
destructor CMKLineValueSeries.Destroy();
var
  f_Index: Integer;
begin
  Clear();

  m_Items.Free();
  m_Items := NIL;
  m_LineColors := NIL;
  m_LineWidths := NIL;
  m_LineAlphas := NIL;
  m_LineTypes := NIL;
  m_LineNames := NIL;
  m_LineVisibles := NIL;
  m_LineMaxMinIndexs := NIL;
  m_LineLabelVisibles := NIL;
  m_LineLabelNameVisibles := NIL;
  m_LinePosValueVisibles := NIL;

  for f_Index := 0 to m_MaxMinCount - 1 do
  begin
    CMKMaxMin(m_MaxMinTable[f_Index]).Free();
    m_MaxMinTable[f_Index] := NIL;
  end;
  m_MaxMinTable := NIL;

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
procedure CMKLineValueSeries.Clone(p_Source: CMKLineValueSeries);
var
  f_LineIndex: Integer;
  f_ValueIndex: Integer;
  f_TagValue: CMKLineValue;
  f_SrcValue: CMKLineValue;
begin
  Clear;
  SetLengthSeries(p_Source.m_Items.Count);

  for f_ValueIndex := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_SrcValue := p_Source.m_Items[f_ValueIndex];
    f_TagValue := m_Items[f_ValueIndex];
    for f_LineIndex := 0 to m_LineCount - 1 do
    begin
      f_TagValue.m_Value[f_LineIndex] := f_SrcValue.m_Value[f_LineIndex];
    end;
  end;
  m_ChartDataSeries := p_Source.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
procedure CMKLineValueSeries.Update(p_Source: CMKLineValueSeries);
var
  f_LineIndex: Integer;
  f_ValueIndex: Integer;
  f_TagValue: CMKLineValue;
  f_SrcValue: CMKLineValue;
  f_Begin, f_End: Integer;
begin
  if m_Items.Count > 0 then
  begin
    f_Begin := m_Items.Count - 1;
    if f_Begin < 0 then
      f_Begin := 0;
    f_End := p_Source.m_Items.Count;

    SetLengthSeries(p_Source.m_Items.Count);

    for f_ValueIndex := f_Begin to f_End - 1 do
    begin
      f_SrcValue := p_Source.m_Items[f_ValueIndex];
      f_TagValue := m_Items[f_ValueIndex];
      for f_LineIndex := 0 to m_LineCount - 1 do
      begin
        f_TagValue.m_Value[f_LineIndex] := f_SrcValue.m_Value[f_LineIndex];
      end;
    end;
  end
  else
  begin
    Clone(p_Source);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKLineValueSeries.Clear;
begin
  if not Assigned(m_Items) then
    exit;

  while 0 < m_Items.Count do
  begin
    CMKLineValue(m_Items[0]).Free();
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
{ **
  * 지정한 갯수만큼 데이터를 모두 채운다.
  *
  * @param    p_Count
  ** }
procedure CMKLineValueSeries.Fill(p_Count: Integer);
var
  f_Index: Integer;
  f_Value: CMKLineValue;
begin
  for f_Index := 0 to p_Count - 1 do
  begin
    f_Value := CMKLineValue.Create(m_LineCount);
    m_Items.Add(f_Value);
  end;
end;

// ---------------------------------------------------------------------------
{ **
  * 라인의 최대값과 최소값을 계산한다. 이때 라인의 Type과 비교모드의 상태에 따라 계산방법이 달라 지므로 주의하여야한다.
  *
  * @param    p_X1            시작인덱스
  * @param    p_X2            마자막인덱스
  * @param    p_Origin        비교모드일 때 기준인덱스, 기준인덱의 값을 100으로 보면된다.
  * @param    p_CompareState  비교모드인지 아닌지 결정한다
  ** }
procedure CMKLineValueSeries.GetLineMaxMin(p_X1, p_X2, p_Origin, p_CompareState: Integer);
var
  f_MaxLength: Integer;
  f_Index: Integer;
  f_Line: Integer;
  f_MaxMin: Integer;
  f_X1: Integer;
  f_X2: Integer;
  f_YOldMaxMin: Double;
  f_YNewMaxMin: Double;
  f_LineValue: CMKLineValue;

  f_Value: Double;
  f_ChartData: CMKChartData;
begin
  if (m_ChartDataSeries = NIL) then
    f_MaxLength := m_Items.Count
  else
    f_MaxLength := m_ChartDataSeries.m_Items.Count;

  f_X1 := p_X1;
  f_X2 := p_X2;

  if (f_X1 < 0) then
    f_X1 := 0;

  if (f_X1 >= f_MaxLength) then
    f_X1 := f_MaxLength - 1;

  if (f_X1 < 0) then
    f_X2 := 0;

  if (f_X2 >= f_MaxLength) then
    f_X2 := f_MaxLength - 1;

  if ((f_X1 < 0) or (f_X1 < 0)) then
    exit;

  for f_MaxMin := 0 to m_MaxMinCount - 1 do
  begin
    m_MaxMinTable[f_MaxMin].m_YMax := MIN_VALUE;
    m_MaxMinTable[f_MaxMin].m_YMin := MAX_VALUE;
  end;

  if (m_Type = CMKConst.LINESERIES_PRICE) then
  begin
    for f_MaxMin := 0 to m_MaxMinCount - 1 do
    begin
      m_MaxMinTable[f_MaxMin].m_XMax := p_X2;
      m_MaxMinTable[f_MaxMin].m_XMin := p_X1;
    end;

    if (m_LineCount < 4) then
      exit;

    f_Line := 0;
    f_Index := f_X1;
    while (f_Index <= f_X2) do
    begin
      f_LineValue := CMKLineValue(m_Items[f_Index]);

      if (f_LineValue.m_Value[CMKConst.PRICE_HIGH] <> NOT_VALUE) then
      begin
        if (f_LineValue.m_Value[CMKConst.PRICE_HIGH] > m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMax) then
        begin
          m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMax := f_LineValue.m_Value[CMKConst.PRICE_HIGH];
          m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMaxIndex := f_Index;
        end;
      end;

      if (f_LineValue.m_Value[CMKConst.PRICE_LOW] <> NOT_VALUE) then
      begin
        if (f_LineValue.m_Value[CMKConst.PRICE_LOW] < m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMin) then
        begin
          m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMin := f_LineValue.m_Value[CMKConst.PRICE_LOW];
          m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMinIndex := f_Index;
        end;
      end;

      Inc(f_Index);
    end;
  end
  else if (m_Type = CMKConst.LINESERIES_VOLUME) then
  begin
    for f_MaxMin := 0 to m_MaxMinCount - 1 do
    begin
      m_MaxMinTable[f_MaxMin].m_XMax := p_X2;
      m_MaxMinTable[f_MaxMin].m_XMin := p_X1;
      m_MaxMinTable[f_MaxMin].m_YMin := 0;
    end;

    f_Index := f_X1;
    while (f_Index <= f_X2) do
    begin
      f_LineValue := CMKLineValue(m_Items[f_Index]);
      if (f_LineValue.m_Value[0] <> NOT_VALUE) then
      begin
        if (f_LineValue.m_Value[0] > m_MaxMinTable[m_LineMaxMinIndexs[0]].m_YMax) then
          m_MaxMinTable[m_LineMaxMinIndexs[0]].m_YMax := f_LineValue.m_Value[0];
      end;

      Inc(f_Index);
    end;
  end
  else
  begin
    for f_MaxMin := 0 to m_MaxMinCount - 1 do
    begin
      m_MaxMinTable[f_MaxMin].m_XMin := p_X1;
      m_MaxMinTable[f_MaxMin].m_XMax := p_X2;
    end;

    for f_Line := 0 to m_LineCount - 1 do
    begin
      if (not m_LineVisibles[f_Line]) then
      begin
        continue;
      end;

      f_Index := f_X1;
      while ((f_Index <= f_X2) and (f_Index < m_Items.Count)) do
      begin
        f_LineValue := CMKLineValue(m_Items[f_Index]);
        if (f_LineValue.m_Value[f_Line] = NOT_VALUE) then
        begin
          Inc(f_Index);
          continue;
        end;

        if (f_LineValue.m_Value[f_Line] > m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMax) then
          m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMax := f_LineValue.m_Value[f_Line];

        if (f_LineValue.m_Value[f_Line] < m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMin) then
          m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMin := f_LineValue.m_Value[f_Line];

        Inc(f_Index);
      end;
    end;
  end;

  if m_AbsoluteMaxMin then
  begin
    if m_AllowOverflow then
    begin
      for f_MaxMin := 0 to m_MaxMinCount - 1 do
      begin
        m_MaxMinTable[f_MaxMin].m_XMax := p_X2;
        m_MaxMinTable[f_MaxMin].m_XMin := p_X1;
        if (m_MaxMinTable[f_MaxMin].m_YMax < m_AbsoluteMax) then
          m_MaxMinTable[f_MaxMin].m_YMax := m_AbsoluteMax;
        if (m_MaxMinTable[f_MaxMin].m_YMin > m_AbsoluteMin) then
          m_MaxMinTable[f_MaxMin].m_YMin := m_AbsoluteMin;
      end;

    end
    else
    begin
      for f_MaxMin := 0 to m_MaxMinCount - 1 do
      begin
        m_MaxMinTable[f_MaxMin].m_XMax := p_X2;
        m_MaxMinTable[f_MaxMin].m_XMin := p_X1;
        m_MaxMinTable[f_MaxMin].m_YMax := m_AbsoluteMax;
        m_MaxMinTable[f_MaxMin].m_YMin := m_AbsoluteMin;
      end;
    end;
  end;

  if (m_MaxMinFactor[f_MaxMin] <> 1.0) then
  begin
    for f_MaxMin := 0 to m_MaxMinCount - 1 do
    begin
      f_YOldMaxMin := m_MaxMinTable[f_MaxMin].m_YMax - m_MaxMinTable[f_MaxMin].m_YMin;
      f_YNewMaxMin := f_YOldMaxMin * m_MaxMinFactor[f_MaxMin];
      m_MaxMinTable[f_MaxMin].m_YMax := m_MaxMinTable[f_MaxMin].m_YMax + (f_YNewMaxMin - f_YOldMaxMin) / 2;
      m_MaxMinTable[f_MaxMin].m_YMin := m_MaxMinTable[f_MaxMin].m_YMin - (f_YNewMaxMin - f_YOldMaxMin) / 2;
    end;
  end;
end;

// ---------------------------------------------------------------------------
{ **
  *  p_Position에서 p_Position--p_Count+1 까지 최대값이 들어 있는 인덱스를 찾는다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_PIndex
  * @param    p_Position
  ** }
function CMKLineValueSeries.HighestIndex(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_PIndex, p_Position: Integer): Integer;
var
  f_Index: Integer;
  f_DHighest: Double;
  f_HighestIndex: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or
      ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
    Result := 0;

  f_DHighest := MIN_VALUE;
  if (p_Position - p_Count + 1 < 0) then
    p_Count := p_Position + 1;

  for f_Index := 0 to p_Count - 1 do
  begin
    if (f_DHighest < CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PIndex]) then
    begin
      f_DHighest := CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PIndex];
      f_HighestIndex := p_Position - f_Index;
    end;
  end;

  Result := f_HighestIndex;
end;

// ---------------------------------------------------------------------------
{ **
  *  p_Position에서 p_Position--p_Count+1 까지 최대값을 찾는다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_PIndex
  * @param    p_Position
  ** }
function CMKLineValueSeries.HighestPrice(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_PIndex, p_Position: Integer): Double;
var
  f_Index: Integer;
  f_DHighest: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or
      ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
  begin
    Result := 0.0;
    exit;
  end;

  f_DHighest := MIN_VALUE;
  if (p_Position - p_Count + 1 < 0) then
    p_Count := p_Position + 1;

  for f_Index := 0 to p_Count - 1 do
  begin
    if (f_DHighest < CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PIndex]) then
      f_DHighest := CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PIndex];
  end;

  Result := f_DHighest;
end;

// ---------------------------------------------------------------------------
{ **
  * 최대 최소를 계산할 갯수로서 p_Position에서 p_Position--p_Count+1 까지 구간의 최대 최소를 계산한다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray  라인 시리즈
  * @param    p_HiIndex        고가가 들어 있는 인덱스
  * @param    p_LoIndex        저가가 들어 잇는 인덱스
  * @param    p_Position       현재 위치
  * @param    p_HiLow          최대값과 최소값을 담아서 전달한다.
  ** }
procedure CMKLineValueSeries.HiLoPrice(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_HiIndex, p_LoIndex, p_Position: Integer; var f_Hi, f_Low: Double);
var
  f_Index: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or
      ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
    exit;

  // p_HiLow.x := MIN_VALUE;
  // p_HiLow.y := MAX_VALUE;
  f_Hi := MIN_VALUE; // -1.0E100;
  f_Low := MAX_VALUE; // 1.0E100;

  if (p_Position - p_Count + 1 < 0) then
    p_Count := p_Position + 1;

  for f_Index := 0 to p_Count - 1 do
  begin
    {
      if (p_HiLow.x < CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_HiIndex]) then
      p_HiLow.x := CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_HiIndex];

      if (p_HiLow.y > CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_LoIndex]) then
      p_HiLow.y := CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_LoIndex];
    }
    if (f_Hi < CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_HiIndex]) then
      f_Hi := CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_HiIndex];

    if (f_Low > CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_LoIndex]) then
      f_Low := CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_LoIndex];
  end;
end;

// ---------------------------------------------------------------------------
{ **
  * ADX를 계산한다.
  *
  * @param    p_Length
  * @param    p_SrcValueArray
  * @param    p_PDIIndex
  * @param    p_MDIIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_ADX(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_PDIIndex, p_MDIIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_ADXIndex: Integer;
  f_DMIIndex: Integer;
  f_DMI: Double;
  f_DMIPlus: Double;
  f_DMIMinus: Double;
  f_Index2: Integer;
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_ADXIndex := p_TagIndex;
  f_DMIIndex := p_TagIndex + 2;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  m_Effect := FALSE;
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PDIIndex] <> NOT_VALUE) and
        (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_MDIIndex] <> NOT_VALUE)) then
    begin
      f_DMIPlus := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PDIIndex];
      f_DMIMinus := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_MDIIndex];
      if ((f_DMIPlus + f_DMIMinus) <> 0) then
        f_DMI := (Abs(f_DMIPlus - f_DMIMinus) / (f_DMIPlus + f_DMIMinus)) * 100.0
      else
        f_DMI := 0;

      CMKLineValue(m_Items[f_Index]).m_Value[f_DMIIndex] := f_DMI;
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[f_DMIIndex] := NOT_VALUE;
  end;

  Indicator_NXAverage(p_Length, Self, f_DMIIndex, f_ADXIndex);
  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_ADX_CrossSignal(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_PDIIndex, p_MDIIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_ADXIndex: Integer;
  f_DMIIndex: Integer;
  f_DMI: Double;
  f_DMIPlus: Double;
  f_DMIMinus: Double;
  f_Index2: Integer;
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_ADXIndex := p_TagIndex + 1;
  f_DMIIndex := p_TagIndex + 3;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  m_Effect := FALSE;
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PDIIndex] <> NOT_VALUE) and
        (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_MDIIndex] <> NOT_VALUE)) then
    begin
      f_DMIPlus := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PDIIndex];
      f_DMIMinus := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_MDIIndex];
      if ((f_DMIPlus + f_DMIMinus) <> 0) then
        f_DMI := (Abs(f_DMIPlus - f_DMIMinus) / (f_DMIPlus + f_DMIMinus)) * 100.0
      else
        f_DMI := 0;

      CMKLineValue(m_Items[f_Index]).m_Value[f_DMIIndex] := f_DMI;
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[f_DMIIndex] := NOT_VALUE;
  end;

  Indicator_NXAverage(p_Length, Self, f_DMIIndex, f_ADXIndex);

  Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * ATR(Average True Range)을 계산한다.
  *
  * @param    p_Length
  * @param    p_SrcValueArray
  * @param    p_HighIndex
  * @param    p_LowIndex
  * @param    p_CloseIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_ATR(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  Indicator_TrueRange(p_SrcValueArray, p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End);
  Indicator_NAverage(p_Length, Self, p_TagIndex, p_TagIndex + 1, p_Begin, p_End);
  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * Bollinger Band를 계산한다.
  *
  * @param    p_Count
  * @param    p_Factor
  * @param    p_SrcValueArray
  * @param    p_PIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_BBand(p_Count: Integer; p_Factor: Double; p_SrcValueArray: CMKLineValueSeries;
    p_PIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  Indicator_NAverage(p_Count, p_SrcValueArray, p_PIndex, p_TagIndex + 2);
  Indicator_StdDev(p_Count, p_SrcValueArray, p_PIndex, Self, p_TagIndex + 2, p_TagIndex + 3);
  for f_Index := p_Begin to p_End - 1 do
  begin
    if ((CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] <> NOT_VALUE) and
        (CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] <> NOT_VALUE)) then
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] +
          p_Factor * CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3];
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] -
          p_Factor * CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3];
    end
    else
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * Bollinger Band의 Width를 계산한다.
  *
  * @param    p_Count
  * @param    p_Factor
  * @param    p_SrcValueArray
  * @param    p_PIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_BBWidth(p_Count: Integer; p_Factor: Double; p_SrcValueArray: CMKLineValueSeries;
    p_PIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  Indicator_NAverage(p_Count, p_SrcValueArray, p_PIndex, p_TagIndex + 1);
  Indicator_StdDev(p_Count, p_SrcValueArray, p_PIndex, Self, p_TagIndex + 1, p_TagIndex + 2);
  for f_Index := p_Begin to p_End - 1 do
  begin
    if (CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] <> NOT_VALUE) then
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := p_Factor * CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2]
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * CCI(Commodity Channel Index)를 계산한다.
  *
  * @param    p_Length
  * @param    p_SrcValueArray
  * @param    p_HighIndex
  * @param    p_LowIndex
  * @param    p_CloseIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_CCI(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_HighIndex, p_LowIndex, p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  // M = (High + Low + Close) / 3
  for f_Index := p_Begin to p_End - 1 do
  begin
    if (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE) then
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] :=
          (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] + CMKLineValue(p_SrcValueArray.m_Items[f_Index])
          .m_Value[p_LowIndex] + CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex]) / 3
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;
  end;

  // m = MA(M)
  Indicator_NAverage(p_Length, Self, p_TagIndex + 0, p_TagIndex + 1, p_Begin, p_End);
  // M-m
  for f_Index := p_Begin to p_End - 1 do
  begin
    if ((CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] <> NOT_VALUE) and
        (CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] <> NOT_VALUE)) then
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] :=
          Abs(CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] - CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1])
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := NOT_VALUE;
  end;

  // d = MA(M-m)
  Indicator_NAverage(p_Length, Self, p_TagIndex + 2, p_TagIndex + 3, p_Begin, p_End);
  // CCI = (M-m) / (d * 0.015)
  for f_Index := p_Begin to p_End - 1 do
  begin
    if ((CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] <> NOT_VALUE) and
        (CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] <> NOT_VALUE) and
        (CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] <> NOT_VALUE) and
        (CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] <> NOT_VALUE)) then
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 4] :=
          (CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] - CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1]) /
          (0.015 * CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3])
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 4] := NOT_VALUE;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 종가라인시리즈를 계산한다.
  *
  * @param    p_ChartDataSeries
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_Close(p_ChartDataSeries: CMKChartDataSeries; p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
begin
  m_Effect := FALSE;
  f_Size := p_ChartDataSeries.m_Items.Count;
  SetLengthSeries(p_ChartDataSeries.m_Items.Count);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  f_Index := p_Begin;
  while (f_Index < p_End) do
  begin
    f_Value := CMKLineValue(m_Items[f_Index]);
    f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);

    f_Value.m_Value[0] := f_ChartData.m_ClosePrice;

    Inc(f_Index);
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 두 라인의 나눗셈을 계산한다.
  *
  * @param    p_SrcLineSeries1
  * @param    p_SrcIndex1
  * @param    p_SrcValueArray2
  * @param    p_SrcIndex2
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_Division(p_SrcLineSeries1: CMKLineValueSeries; p_SrcIndex1: Integer;
    p_SrcValueArray2: CMKLineValueSeries; p_SrcIndex2, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
begin
  if not Assigned(p_SrcLineSeries1) then
    exit;
  if not Assigned(p_SrcValueArray2) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcLineSeries1.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if ((CMKLineValue(p_SrcLineSeries1.m_Items[f_Index]).m_Value[p_SrcIndex1] <> NOT_VALUE) and
        (CMKLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_SrcIndex2] <> NOT_VALUE)) then
    begin
      if (CMKLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_SrcIndex2] <> 0) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CMKLineValue(p_SrcLineSeries1.m_Items[f_Index])
            .m_Value[p_SrcIndex1] / CMKLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_SrcIndex2]
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
    end;
  end;

  m_ChartDataSeries := p_SrcLineSeries1.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * Envelope을 계산한다.
  *
  * @param    p_Length
  * @param    p_Factor
  * @param    p_SrcValueArray
  * @param    p_PIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_Envelope(p_Length: Integer; p_Factor: Double; p_SrcValueArray: CMKLineValueSeries;
    p_PIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  Indicator_NAverage(p_Length, p_SrcValueArray, p_PIndex, p_TagIndex + 2, p_Begin, p_End);
  for f_Index := p_Begin to p_End - 1 do
  begin
    if (CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] <> NOT_VALUE) then
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] +
          (p_Factor / 100.0) * CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2];
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] -
          (p_Factor / 100.0) * CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2];
    end
    else
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * Fast Stochastics를 계산한다.
  *
  * @param    p_Length1
  * @param    p_Length2
  * @param    p_SrcValueArray
  * @param    p_HighIndex
  * @param    p_LowIndex
  * @param    p_CloseIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_FastSTC(p_Length1, p_Length2: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_FastKIndex: Integer;
  f_FastDIndex: Integer;
  f_Count: Integer;
  f_Index: Integer;
  f_Index2: Integer;
  f_DHighest: Double;
  f_DLowest: Double;
  f_HighPrice: Double;
  f_LowPrice: Double;
  f_ClosePrice: Double;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_FastKIndex := p_TagIndex;
  f_FastDIndex := p_TagIndex + 1;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Count := p_Begin to p_End - 1 do
  begin
    f_Index := f_Count - (p_Length1 - 1);
    if (f_Index >= 0) then
    begin
      if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE)) then
      begin
        f_DHighest := MIN_VALUE;
        f_DLowest := MAX_VALUE;
        for f_Index2 := 0 to p_Length1 - 1 do
        begin
          f_HighPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_HighIndex];
          f_LowPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_LowIndex];
          if (f_LowPrice < f_DLowest) then
            f_DLowest := f_LowPrice;

          if (f_HighPrice > f_DHighest) then
            f_DHighest := f_HighPrice;
        end;

        f_ClosePrice := CMKLineValue(p_SrcValueArray.m_Items[f_Count]).m_Value[p_CloseIndex];
        if (f_DHighest = f_DLowest) then
          CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := 0
        else
          CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := (f_ClosePrice - f_DLowest) / (f_DHighest - f_DLowest) * 100.0;
      end;
    end
    else
      CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := NOT_VALUE;
  end;

  Indicator_XAverage(p_Length2, Self, f_FastKIndex, f_FastDIndex, p_Begin, p_End);
  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_FastSTC_CrossSignal(p_Length1, p_Length2: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_FastKIndex: Integer;
  f_FastDIndex: Integer;
  f_Count: Integer;
  f_Index: Integer;
  f_Index2: Integer;
  f_DHighest: Double;
  f_DLowest: Double;
  f_HighPrice: Double;
  f_LowPrice: Double;
  f_ClosePrice: Double;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_FastKIndex := p_TagIndex + 1;
  f_FastDIndex := p_TagIndex + 2;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Count := p_Begin to p_End - 1 do
  begin
    f_Index := f_Count - (p_Length1 - 1);
    if (f_Index >= 0) then
    begin
      if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE)) then
      begin
        f_DHighest := MIN_VALUE;
        f_DLowest := MAX_VALUE;
        for f_Index2 := 0 to p_Length1 - 1 do
        begin
          f_HighPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_HighIndex];
          f_LowPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_LowIndex];
          if (f_LowPrice < f_DLowest) then
            f_DLowest := f_LowPrice;

          if (f_HighPrice > f_DHighest) then
            f_DHighest := f_HighPrice;
        end;

        f_ClosePrice := CMKLineValue(p_SrcValueArray.m_Items[f_Count]).m_Value[p_CloseIndex];
        if (f_DHighest = f_DLowest) then
          CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := 0
        else
          CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := (f_ClosePrice - f_DLowest) / (f_DHighest - f_DLowest) * 100.0;
      end;
    end
    else
      CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := NOT_VALUE;
  end;

  Indicator_XAverage(p_Length2, Self, f_FastKIndex, f_FastDIndex, p_Begin, p_End);

  Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 일목균형표를 계산한다.
  *
  * @param    p_Length1
  * @param    p_Length2
  * @param    p_Length3
  * @param    p_SrcValueArray
  * @param    p_HighIndex
  * @param    p_LowIndex
  * @param    p_CloseIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_IMLine(p_Length1, p_Length2, p_Length3: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
  f_Count: Integer;
  f_MaxValue: Double;
  f_MinValue: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size + p_Length2);
  m_Effect := FALSE;
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End + p_Length2 - 1 do
  begin
    if ((f_Index >= 0) and (f_Index < f_Size)) then
    begin
      f_MaxValue := HighestPrice(p_Length1, p_SrcValueArray, p_HighIndex, f_Index);
      f_MinValue := LowestPrice(p_Length1, p_SrcValueArray, p_LowIndex, f_Index);
      if ((f_MaxValue <> MIN_VALUE) and (f_MinValue <> MAX_VALUE)) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := (f_MinValue + f_MaxValue) / 2
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;

      f_MaxValue := HighestPrice(p_Length2, p_SrcValueArray, p_HighIndex, f_Index);
      f_MinValue := LowestPrice(p_Length2, p_SrcValueArray, p_LowIndex, f_Index);
      if ((f_MaxValue <> MIN_VALUE) and (f_MinValue <> MAX_VALUE)) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := (f_MinValue + f_MaxValue) / 2
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
    end
    else
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
    end;

    f_Count := f_Index - (p_Length2);
    if ((f_Count >= 0) and (f_Count < f_Size)) then
    begin
      if ((CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 0] <> NOT_VALUE) and
          (CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] <> NOT_VALUE)) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] :=
            (CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 0] + CMKLineValue(m_Items[f_Count])
            .m_Value[p_TagIndex + 1]) / 2
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := NOT_VALUE;
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := NOT_VALUE;

    f_Count := f_Index - (p_Length2);
    if ((f_Count >= 0) and (f_Count < f_Size)) then
    begin
      f_MaxValue := HighestPrice(p_Length3, p_SrcValueArray, p_HighIndex, f_Count);
      f_MinValue := LowestPrice(p_Length3, p_SrcValueArray, p_LowIndex, f_Count);
      if ((f_MaxValue <> MIN_VALUE) and (f_MinValue <> MAX_VALUE)) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] := (f_MinValue + f_MaxValue) / 2
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] := NOT_VALUE;
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] := NOT_VALUE;

    f_Count := f_Index + (p_Length2);
    if ((f_Count >= 0) and (f_Count < f_Size)) then
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 4] := CMKLineValue(p_SrcValueArray.m_Items[f_Count])
          .m_Value[p_CloseIndex]
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 4] := NOT_VALUE;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * LRL(Linear Regression Line)를 계산한다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_LRL(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_SumX: Double;
  f_SumY: Double;
  f_SumXX: Double;
  f_SumXY: Double;
  f_N: Double;
  f_X: Double;
  f_Y: Double;
  f_A: Double;
  f_B: Double;
  f_Index: Integer;
  f_Index2: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_N := p_Count;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    if (f_Index - p_Count + 1 >= 0) then
    begin
      f_SumXY := 0;
      f_SumX := 0;
      f_SumXX := 0;
      f_SumY := 0;
      for f_Index2 := 0 to p_Count - 1 do
      begin
        f_X := p_Count - f_Index2;
        f_Y := CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[p_SrcIndex];
        f_SumXX := f_SumXX + (f_X * f_X);
        f_SumXY := f_SumXY + (f_X * f_Y);
        f_SumX := f_SumX + f_X;
        f_SumY := f_SumY + f_Y;
      end;

      f_B := (f_N * f_SumXY - f_SumX * f_SumY) / (f_N * f_SumXX - f_SumX * f_SumX);
      f_A := (f_SumY - f_B * f_SumX) / f_N;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_B;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := f_A;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := f_A + f_B * p_Count;
    end
    else
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := NOT_VALUE;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * MACD를 계산한다.
  *
  * @param    p_FastMA
  * @param    p_SlowMA
  * @param    p_MA
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_MACD(p_FastMA, p_SlowMA, p_MA: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  SetLengthSeries(p_SrcValueArray.m_Items.Count);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  Indicator_XAverage(p_FastMA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 0, p_Begin, p_End);
  Indicator_XAverage(p_SlowMA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 1, p_Begin, p_End);
  Indicator_Subtraction(Self, p_TagIndex + 0, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);
  Indicator_XAverage(p_MA, Self, p_TagIndex + 2, p_TagIndex + 3, p_Begin, p_End);
  Indicator_Subtraction(Self, p_TagIndex + 2, Self, p_TagIndex + 3, p_TagIndex + 4, p_Begin, p_End);
  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_CrossSignal(p_SrcValueArray: CMKLineValueSeries; p_SrcIndex1: Integer;
    p_SrcIndex2: Integer; p_TagIndex: Integer; p_Begin: Integer; p_End: Integer);
var
  f_Index: Integer;
  f_SourceLineValue: CMKLineValue;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin

    f_LineValue0 := m_Items[f_Index];

    if (f_Index > 0) then
    begin

      f_LineValue1 := m_Items[f_Index - 1];

      f_SourceLineValue := p_SrcValueArray.m_Items[f_Index];
      if ((f_SourceLineValue.m_Value[p_SrcIndex1] <> NOT_VALUE) AND (f_SourceLineValue.m_Value[p_SrcIndex2] <> NOT_VALUE)) then
      begin
        if f_SourceLineValue.m_Value[p_SrcIndex1] > f_SourceLineValue.m_Value[p_SrcIndex2] then
        begin
          f_LineValue0.m_Value[p_TagIndex] := 1;
        end
        else if f_SourceLineValue.m_Value[p_SrcIndex1] < f_SourceLineValue.m_Value[p_SrcIndex2] then
        begin
          f_LineValue0.m_Value[p_TagIndex] := -1;
        end
        else
        begin
          f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
        end;
      end
      else
      begin
        f_LineValue0.m_Value[p_TagIndex] := 0;
      end;
    end
    else
    begin
      f_LineValue0.m_Value[p_TagIndex] := 0;
    end;
  end;

end;

procedure CMKLineValueSeries.Indicator_TrendSignal(p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
    p_TagIndex: Integer; p_Begin: Integer; p_End: Integer);
var
  f_Index: Integer;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_SrcLineValue0: CMKLineValue;
  f_SrcLineValue1: CMKLineValue;
  f_SrcLineValue2: CMKLineValue;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_LineValue0 := m_Items[f_Index];
    if (f_Index > 1) then
    begin

      f_LineValue1 := m_Items[f_Index - 1];

      f_SrcLineValue0 := p_SrcValueArray.m_Items[f_Index - 0];
      f_SrcLineValue1 := p_SrcValueArray.m_Items[f_Index - 1];
      f_SrcLineValue2 := p_SrcValueArray.m_Items[f_Index - 2];

      if ((f_SrcLineValue0.m_Value[p_SrcIndex] <> NOT_VALUE) AND (f_SrcLineValue1.m_Value[p_SrcIndex] <> NOT_VALUE) AND
          (f_SrcLineValue2.m_Value[p_SrcIndex] <> NOT_VALUE)) then
      begin
        if (((f_SrcLineValue0.m_Value[p_SrcIndex] > f_SrcLineValue1.m_Value[p_SrcIndex]) AND
            (f_SrcLineValue0.m_Value[p_SrcIndex] > f_SrcLineValue2.m_Value[p_SrcIndex]))) then
        begin
          f_LineValue0.m_Value[p_TagIndex] := 1;
        end
        else if (((f_SrcLineValue0.m_Value[p_SrcIndex] < f_SrcLineValue1.m_Value[p_SrcIndex]) AND
            (f_SrcLineValue0.m_Value[p_SrcIndex] < f_SrcLineValue2.m_Value[p_SrcIndex]))) then
        begin
          f_LineValue0.m_Value[p_TagIndex] := -1;
        end
        else
        begin

          f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
        end;
      end
      else
      begin
        f_LineValue0.m_Value[p_TagIndex] := 0;
      end;
    end
    else
    begin
      f_LineValue0.m_Value[p_TagIndex] := 0;
    end;
  end;
end;

procedure CMKLineValueSeries.Indicator_MACD_CrossSignal(p_FastMA, p_SlowMA, p_MA: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  SetLengthSeries(p_SrcValueArray.m_Items.Count);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  Indicator_XAverage(p_FastMA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 3, p_Begin, p_End);
  Indicator_XAverage(p_SlowMA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 4, p_Begin, p_End);
  Indicator_Subtraction(Self, p_TagIndex + 3, Self, p_TagIndex + 4, p_TagIndex + 1, p_Begin, p_End);
  Indicator_XAverage(p_MA, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);
  Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_MA_CrossSignal(p_FastMA, p_SlowMA: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  SetLengthSeries(p_SrcValueArray.m_Items.Count);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  Indicator_NAverage(p_FastMA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 1);
  Indicator_NAverage(p_SlowMA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 2);
  Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_NMA_TrendSignal(p_MA: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  SetLengthSeries(p_SrcValueArray.m_Items.Count);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  Indicator_NAverage(p_MA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 1);
  Indicator_TrendSignal(Self, p_TagIndex + 1, p_TagIndex + 0, p_Begin, p_End);

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_WMA_TrendSignal(p_MA: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  SetLengthSeries(p_SrcValueArray.m_Items.Count);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  Indicator_WAverage(p_MA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 1);
  Indicator_TrendSignal(Self, p_TagIndex + 1, p_TagIndex + 0, p_Begin, p_End);

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_XMA_TrendSignal(p_MA: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  SetLengthSeries(p_SrcValueArray.m_Items.Count);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  Indicator_XAverage(p_MA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 1);
  Indicator_TrendSignal(Self, p_TagIndex + 1, p_TagIndex + 0, p_Begin, p_End);

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 단순이동평균을 계산한다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_NAverage(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_AllEffect: Boolean;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if (f_Index < p_Count - 1) then
      continue;

    if (f_Index < 1) then
      continue;

    if (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] = NOT_VALUE) then
    begin
      if (not f_AllEffect) then
      begin
        f_AllEffect := (CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_SrcIndex] <> NOT_VALUE);
        if (f_AllEffect) then
        begin
          f_Index1 := 0;
          f_Sum := 0;
          while (f_Index1 < p_Count) do
          begin
            f_Sum := f_Sum + CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];

            Inc(f_Index1);
          end;

          CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / p_Count;
        end;

        continue;
      end;
    end
    else if (f_Index >= p_Count) then
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
          (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] * p_Count + CMKLineValue(p_SrcValueArray.m_Items[f_Index])
          .m_Value[p_SrcIndex] - CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Count]).m_Value[p_SrcIndex]) / p_Count;
    end
    else
    begin
      continue;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 그물차트를 계산한다.
  *
  * @param    p_SmallMA
  * @param    p_Increse
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_NET(p_SmallMA, p_Increse, p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  SetLengthSeries(p_SrcValueArray.m_Items.Count);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := 0 to p_Count - 1 do
  begin
    Indicator_XAverage(p_SmallMA + f_Index * p_Increse, p_SrcValueArray, p_SrcIndex, p_TagIndex + f_Index, p_Begin, p_End);
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 단순이동평균을 근사치로 계산한다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_NXAverage(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_AllEffect: Boolean;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if ((f_Index < p_Count - 1) or (f_Index < 1)) then
      continue;

    if (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] <> NOT_VALUE) then
      f_AllEffect := TRUE;

    if (not f_AllEffect) then
    begin
      f_AllEffect := (CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_SrcIndex] <> NOT_VALUE);
      if (f_AllEffect) then
      begin
        f_Sum := 0;
        for f_Index1 := 0 to p_Count - 1 do
        begin
          f_Sum := f_Sum + CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        end;

        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / p_Count;
      end;

      continue;
    end;

    CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] -
        CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] / p_Count + CMKLineValue(p_SrcValueArray.m_Items[f_Index])
        .m_Value[p_SrcIndex] / p_Count;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * OBV(On Balance Volume)를 계산한다.
  *
  * @param    p_SrcValueArray
  * @param    p_CloseIndex
  * @param    p_SrcValueArray2
  * @param    p_VolumeIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_OBV(p_SrcValueArray: CMKLineValueSeries; p_CloseIndex: Integer;
    p_SrcValueArray2: CMKLineValueSeries; p_VolumeIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Count: Integer;
  f_Index: Integer;
  f_Size: Integer;
  f_mount: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  f_mount := 0;
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  f_mount := 0;
  for f_Index := p_Begin to p_End - 1 do
  begin
    if (f_Index > 1) then
    begin
      if (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] >
          CMKLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_CloseIndex]) then
        f_mount := f_mount + CMKLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_VolumeIndex]
      else if (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <
          CMKLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_CloseIndex]) then
        f_mount := f_mount - CMKLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_VolumeIndex]
      else
        f_mount := f_mount;

      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_mount;
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * PMAO(Price Oscillator)를 계산한다.
  *
  * @param    p_Length1
  * @param    p_Length2
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_PMAO(p_Length1, p_Length2: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex: Integer; p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  m_Effect := FALSE;
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  Indicator_XAverage(p_Length1, p_SrcValueArray, p_SrcIndex, p_TagIndex + 0, p_Begin, p_End);
  Indicator_XAverage(p_Length2, p_SrcValueArray, p_SrcIndex, p_TagIndex + 1, p_Begin, p_End);
  for f_Index := p_Begin to p_End - 1 do
  begin
    if ((CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] <> NOT_VALUE) AND
        (CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] <> NOT_VALUE)) then
    begin
      if CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] = 0 then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := 0;
      end
      else
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] :=
            (CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] - CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1]) *
            100.0 / CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0];
      end;
    end
    else
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := NOT_VALUE;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * PMDI를 계산한다. 이것은 DMI와 ADX를 계산하기 위해 필요하다.
  *
  * @param    p_Length
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_PMDI(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_PDMIndex: Integer;
  f_MDMIndex: Integer;
  f_TRIndex: Integer;
  f_PDIIndex: Integer;
  f_MDIIndex: Integer;
  f_PDMSUMIndex: Integer;
  f_MDMSUMIndex: Integer;
  f_TRSUMIndex: Integer;
  f_Index2: Integer;
  f_Index: Integer;
  f_Size: Integer;
  f_TRSum: Double;
  f_PDMSum: Double;
  f_MDMSum: Double;
  f_AllEffect: Boolean;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_PDMIndex := p_SrcIndex + 0;
  f_MDMIndex := p_SrcIndex + 1;
  f_TRIndex := p_SrcIndex + 2;
  f_PDIIndex := p_TagIndex;
  f_MDIIndex := p_TagIndex + 1;
  f_PDMSUMIndex := p_TagIndex + 2;
  f_MDMSUMIndex := p_TagIndex + 3;
  f_TRSUMIndex := p_TagIndex + 4;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    CMKLineValue(m_Items[f_Index]).m_Value[f_PDMSUMIndex] := NOT_VALUE;
    CMKLineValue(m_Items[f_Index]).m_Value[f_MDMSUMIndex] := NOT_VALUE;
    CMKLineValue(m_Items[f_Index]).m_Value[f_TRSUMIndex] := NOT_VALUE;
    CMKLineValue(m_Items[f_Index]).m_Value[f_PDIIndex] := NOT_VALUE;
    CMKLineValue(m_Items[f_Index]).m_Value[f_MDIIndex] := NOT_VALUE;
    if (f_Index - p_Length + 1 <= 0) then
      continue;

    if (CMKLineValue(m_Items[f_Index - 1]).m_Value[f_TRSUMIndex] <> NOT_VALUE) then
      f_AllEffect := TRUE;

    if (not f_AllEffect) then
    begin
      if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + 1]).m_Value[f_PDMIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + 1]).m_Value[f_MDMIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + 1]).m_Value[f_TRIndex] <> NOT_VALUE)) then
        f_AllEffect := TRUE
      else
        f_AllEffect := FALSE;

      if (f_AllEffect) then
      begin
        f_PDMSum := 0;
        f_MDMSum := 0;
        f_TRSum := 0;
        for f_Index2 := 0 to p_Length - 1 do
        begin
          f_PDMSum := f_PDMSum + CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[f_PDMIndex];
          f_MDMSum := f_MDMSum + CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[f_MDMIndex];
          f_TRSum := f_TRSum + CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[f_TRIndex];
        end;

        CMKLineValue(m_Items[f_Index]).m_Value[f_PDMSUMIndex] := f_PDMSum;
        CMKLineValue(m_Items[f_Index]).m_Value[f_MDMSUMIndex] := f_MDMSum;
        CMKLineValue(m_Items[f_Index]).m_Value[f_TRSUMIndex] := f_TRSum;
        if (f_TRSum <> 0) then
        begin
          CMKLineValue(m_Items[f_Index]).m_Value[f_PDIIndex] := f_PDMSum / f_TRSum * 100.0;
          CMKLineValue(m_Items[f_Index]).m_Value[f_MDIIndex] := f_MDMSum / f_TRSum * 100.0;
        end
        else
        begin
          CMKLineValue(m_Items[f_Index]).m_Value[f_PDIIndex] := 0;
          CMKLineValue(m_Items[f_Index]).m_Value[f_MDIIndex] := 0;
        end;
      end;
    end
    else
    begin
      f_TRSum := CMKLineValue(m_Items[f_Index - 1]).m_Value[f_TRSUMIndex] -
          (CMKLineValue(m_Items[f_Index - 1]).m_Value[f_TRSUMIndex] / p_Length) + CMKLineValue(p_SrcValueArray.m_Items[f_Index])
          .m_Value[f_TRIndex];
      f_PDMSum := CMKLineValue(m_Items[f_Index - 1]).m_Value[f_PDMSUMIndex] -
          (CMKLineValue(m_Items[f_Index - 1]).m_Value[f_PDMSUMIndex] / p_Length) + CMKLineValue(p_SrcValueArray.m_Items[f_Index]
          ).m_Value[f_PDMIndex];
      f_MDMSum := CMKLineValue(m_Items[f_Index - 1]).m_Value[f_MDMSUMIndex] -
          (CMKLineValue(m_Items[f_Index - 1]).m_Value[f_MDMSUMIndex] / p_Length) + CMKLineValue(p_SrcValueArray.m_Items[f_Index]
          ).m_Value[f_MDMIndex];
      CMKLineValue(m_Items[f_Index]).m_Value[f_PDMSUMIndex] := f_PDMSum;
      CMKLineValue(m_Items[f_Index]).m_Value[f_MDMSUMIndex] := f_MDMSum;
      CMKLineValue(m_Items[f_Index]).m_Value[f_TRSUMIndex] := f_TRSum;
      if (f_TRSum <> 0) then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[f_PDIIndex] := 100 * f_PDMSum / f_TRSum;
        CMKLineValue(m_Items[f_Index]).m_Value[f_MDIIndex] := 100 * f_MDMSum / f_TRSum;
      end
      else
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[f_PDIIndex] := 0;
        CMKLineValue(m_Items[f_Index]).m_Value[f_MDIIndex] := 0;
      end;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * PMDM을 계산한다. 이 것은 DMI와 ADX를 계산하기 위해 필요한다.
  *
  * @param    p_SrcValueArray
  * @param    p_HighIndex
  * @param    p_LowIndex
  * @param    p_CloseIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_PMDM(p_SrcValueArray: CMKLineValueSeries;
    p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
  f_PDMIndex: Integer;
  f_MDMIndex: Integer;
  f_PlusDM: Double;
  f_MinusDM: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_PDMIndex := p_TagIndex;
  f_MDMIndex := p_TagIndex + 1;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    if ((f_Index >= 1) and (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <> NOT_VALUE) and
        (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <> NOT_VALUE) and
        (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE)) then
    begin
      if (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <
          CMKLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_HighIndex]) then
        f_PlusDM := 0
      else
        f_PlusDM := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] -
            CMKLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_HighIndex];

      if (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] > CMKLineValue(p_SrcValueArray.m_Items[f_Index - 1]
          ).m_Value[p_LowIndex]) then
        f_MinusDM := 0
      else
        f_MinusDM := CMKLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_LowIndex] -
            CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex];

      CMKLineValue(m_Items[f_Index]).m_Value[f_PDMIndex] := f_PlusDM;
      CMKLineValue(m_Items[f_Index]).m_Value[f_MDMIndex] := f_MinusDM;
    end
    else
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[f_PDMIndex] := NOT_VALUE;
      CMKLineValue(m_Items[f_Index]).m_Value[f_MDMIndex] := NOT_VALUE;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
procedure CMKLineValueSeries.Indicator_OPSPrice(p_ChartDataSeries: CMKChartDataSeries; p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
begin
  m_Effect := FALSE;
  f_Size := p_ChartDataSeries.m_Items.Count;
  SetLengthSeries(p_ChartDataSeries.m_Items.Count);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Value := CMKLineValue(m_Items[f_Index]);
    f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    f_Value.m_Value[0] := f_ChartData.m_OpenOPS;
    f_Value.m_Value[1] := f_ChartData.m_HighOPS;
    f_Value.m_Value[2] := f_ChartData.m_LowOPS;
    f_Value.m_Value[3] := f_ChartData.m_CloseOPS;
    f_Value.m_Value[4] := f_ChartData.m_Volume;
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
procedure CMKLineValueSeries.Indicator_RealPrice(p_ChartDataSeries: CMKChartDataSeries; p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
begin
  m_Effect := FALSE;
  f_Size := p_ChartDataSeries.m_Items.Count;
  SetLengthSeries(p_ChartDataSeries.m_Items.Count);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Value := CMKLineValue(m_Items[f_Index]);
    f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    f_Value.m_Value[0] := f_ChartData.m_OpenPrice;
    f_Value.m_Value[1] := f_ChartData.m_HighPrice;
    f_Value.m_Value[2] := f_ChartData.m_LowPrice;
    f_Value.m_Value[3] := f_ChartData.m_ClosePrice;
    f_Value.m_Value[4] := f_ChartData.m_Volume;
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
procedure CMKLineValueSeries.Indicator_Price(p_ChartDataSeries: CMKChartDataSeries; p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
begin
  m_Effect := FALSE;
  f_Size := p_ChartDataSeries.m_Items.Count;
  SetLengthSeries(p_ChartDataSeries.m_Items.Count);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Value := CMKLineValue(m_Items[f_Index]);
    f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    f_Value.m_Value[0] := f_ChartData.m_OpenPrice;
    f_Value.m_Value[1] := f_ChartData.m_HighPrice;
    f_Value.m_Value[2] := f_ChartData.m_LowPrice;
    f_Value.m_Value[3] := f_ChartData.m_ClosePrice;
    f_Value.m_Value[4] := f_ChartData.m_Volume;
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
procedure CMKLineValueSeries.Indicator_Price_MA_CrossSignal(p_MA: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_SourceLineValue: CMKLineValue;
  f_LineValue: CMKLineValue;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(p_SrcValueArray.m_Items.Count);

  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_LineValue := m_Items[f_Index];
    f_SourceLineValue := p_SrcValueArray.m_Items[f_Index];
    f_LineValue.m_Value[p_TagIndex + 1] := f_SourceLineValue.m_Value[p_SrcIndex];
  end;
  Indicator_NAverage(p_MA, Self, p_TagIndex + 1, p_TagIndex + 2);
  Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 투자심리선(Psychogical Line)을 계산한다.
  *
  * @param    p_Length
  * @param    p_SrcValueArray
  * @param    p_PIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_PSY(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_PIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
  f_Index2: Integer;
  f_PSY: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    if (f_Index - p_Length >= 0) then
    begin
      f_PSY := 0;
      f_Index2 := 1;
      while (f_Index2 <= p_Length) do
      begin
        if (CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + f_Index2 - 1]).m_Value[p_PIndex] <
            CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + f_Index2]).m_Value[p_PIndex]) then
          Inc(f_PSY);

        Inc(f_Index2);
      end;

      if (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PIndex] <> NOT_VALUE) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := (f_PSY / p_Length) * 100.0
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * ROC(Price Rate Of Change)를 계산한다.
  *
  * @param    p_Length1
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }

procedure CMKLineValueSeries.Indicator_ROC(p_Length1: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex: Integer; p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  m_Effect := FALSE;
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    if (f_Index - p_Length1 >= 0) then
    begin
      if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Length1]).m_Value[p_TagIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Length1]).m_Value[p_TagIndex] <> 0)) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
            ((CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] -
            CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Length1]).m_Value[p_SrcIndex]) /
            CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Length1]).m_Value[p_SrcIndex]) * 100.0
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * RSI(Relative Strength Index)를 계산한다.
  *
  * @param    p_Length
  * @param    p_MA
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_RSI(p_Length, p_MA: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Count: Integer;
  f_Index: Integer;
  f_Index2: Integer;
  f_Size: Integer;
  f_mount: Double;
  f_UpSum: Double;
  f_DownSum: Double;
  f_NewPrice: Double;
  f_OldPrice: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Count := p_Begin to p_End - 1 do
  begin
    f_Index := f_Count - (p_Length - 1);
    if (f_Index > 0) then
    begin
      f_UpSum := 0.0;
      f_DownSum := 0.0;
      CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := 0;
      for f_Index2 := 0 to p_Length - 1 do
      begin
        f_OldPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2 - 1]).m_Value[p_SrcIndex];
        f_NewPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_SrcIndex];
        f_mount := f_NewPrice - f_OldPrice;

        if (f_mount >= 0) then
          f_UpSum := f_UpSum + f_mount
        else
          f_DownSum := f_DownSum + (-f_mount);

        if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2 - 1]).m_Value[p_SrcIndex] = NOT_VALUE) or
            (CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_SrcIndex] = NOT_VALUE)) then
        begin
          CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := NOT_VALUE;
          break;
        end;
      end;

      if (CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex] <> NOT_VALUE) then
      begin
        if (f_UpSum + f_DownSum = 0) then
          CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := 0.0
        else
          CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := f_UpSum / (f_UpSum + f_DownSum) * 100.0;
      end;
    end
    else
      CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := NOT_VALUE;
  end;

  Indicator_NAverage(p_MA, Self, p_TagIndex + 0, p_TagIndex + 1, p_Begin, p_End);
  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;

end;

// ---------------------------------------------------------------------------
procedure CMKLineValueSeries.Indicator_RSI_CrossSignal(p_Length, p_MA: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Count: Integer;
  f_Index: Integer;
  f_Index2: Integer;
  f_Size: Integer;
  f_mount: Double;
  f_UpSum: Double;
  f_DownSum: Double;
  f_NewPrice: Double;
  f_OldPrice: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Count := p_Begin to p_End - 1 do
  begin
    f_Index := f_Count - (p_Length - 1);
    if (f_Index > 0) then
    begin
      f_UpSum := 0.0;
      f_DownSum := 0.0;
      CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] := 0;
      for f_Index2 := 0 to p_Length - 1 do
      begin
        f_OldPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2 - 1]).m_Value[p_SrcIndex];
        f_NewPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_SrcIndex];
        f_mount := f_NewPrice - f_OldPrice;

        if (f_mount >= 0) then
          f_UpSum := f_UpSum + f_mount
        else
          f_DownSum := f_DownSum + (-f_mount);

        if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2 - 1]).m_Value[p_SrcIndex] = NOT_VALUE) OR
            (CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_SrcIndex] = NOT_VALUE)) then
        begin
          CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] := NOT_VALUE;
          break;
        end;
      end;

      if (CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] <> NOT_VALUE) then
      begin
        if (f_UpSum + f_DownSum = 0) then
        begin
          CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] := 0.0
        end
        else
        begin
          CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] := f_UpSum / (f_UpSum + f_DownSum) * 100.0;
        end;
      end;
    end
    else
    begin
      CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] := NOT_VALUE;
    end;
  end;

  Indicator_NAverage(p_MA, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);
  Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;

end;

// ---------------------------------------------------------------------------
{ **
  * Parabolic SAR(Stop and Reversal)를 계산한다.
  *
  * @param    p_Length
  * @param    p_SrcValueArray
  * @param    p_HighIndex
  * @param    p_LowIndex
  * @param    p_CloseIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_SAR(p_Length: Double; p_SrcValueArray: CMKLineValueSeries;
    p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
  f_HIndex: Integer;
  f_LIndex: Integer;
  f_SIndex: Integer;
  f_SARIndex: Integer;
  f_AFIndex: Integer;
  p_F: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  m_Effect := FALSE;
  f_HIndex := p_TagIndex + 0;
  f_LIndex := p_TagIndex + 1;
  f_SIndex := p_TagIndex + 2;
  f_SARIndex := p_TagIndex + 3;
  f_AFIndex := p_TagIndex + 4;
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    if (f_Index = 0) then
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[f_HIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex];
      CMKLineValue(m_Items[f_Index]).m_Value[f_LIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex];
      CMKLineValue(m_Items[f_Index]).m_Value[f_SIndex] := 1;
      CMKLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index])
          .m_Value[p_CloseIndex];
      CMKLineValue(m_Items[f_Index]).m_Value[f_AFIndex] := p_Length;
    end
    else
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[f_HIndex] := CMKLineValue(m_Items[f_Index - 1]).m_Value[f_HIndex];
      CMKLineValue(m_Items[f_Index]).m_Value[f_LIndex] := CMKLineValue(m_Items[f_Index - 1]).m_Value[f_LIndex];
      CMKLineValue(m_Items[f_Index]).m_Value[f_SIndex] := CMKLineValue(m_Items[f_Index - 1]).m_Value[f_SIndex];
      CMKLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CMKLineValue(m_Items[f_Index - 1]).m_Value[f_SARIndex];
      CMKLineValue(m_Items[f_Index]).m_Value[f_AFIndex] := CMKLineValue(m_Items[f_Index - 1]).m_Value[f_AFIndex];
      if (CMKLineValue(m_Items[f_Index - 1]).m_Value[f_HIndex] < CMKLineValue(p_SrcValueArray.m_Items[f_Index])
          .m_Value[p_HighIndex]) then
        CMKLineValue(m_Items[f_Index]).m_Value[f_HIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex];

      if (CMKLineValue(m_Items[f_Index]).m_Value[f_LIndex] > CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex])
      then
        CMKLineValue(m_Items[f_Index]).m_Value[f_LIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex];

      if (CMKLineValue(m_Items[f_Index]).m_Value[f_SIndex] = 1) then
      begin
        if (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <= CMKLineValue(m_Items[f_Index - 1])
            .m_Value[f_SARIndex]) then
          CMKLineValue(m_Items[f_Index]).m_Value[f_SIndex] := -1;
      end
      else
      begin
        if (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] >= CMKLineValue(m_Items[f_Index - 1])
            .m_Value[f_SARIndex]) then
          CMKLineValue(m_Items[f_Index]).m_Value[f_SIndex] := 1;
      end;

      if (CMKLineValue(m_Items[f_Index]).m_Value[f_SIndex] = 1) then
      begin
        if (CMKLineValue(m_Items[f_Index - 1]).m_Value[f_SIndex] <> 1) then
        begin
          CMKLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CMKLineValue(m_Items[f_Index]).m_Value[f_LIndex];
          CMKLineValue(m_Items[f_Index]).m_Value[f_HIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index])
              .m_Value[p_HighIndex];
          CMKLineValue(m_Items[f_Index]).m_Value[f_LIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index])
              .m_Value[p_LowIndex];
          CMKLineValue(m_Items[f_Index]).m_Value[f_AFIndex] := p_Length;
        end
        else
        begin
          p_F := CMKLineValue(m_Items[f_Index]).m_Value[f_AFIndex];
          CMKLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CMKLineValue(m_Items[f_Index - 1]).m_Value[f_SARIndex] + p_F *
              (CMKLineValue(m_Items[f_Index]).m_Value[f_HIndex] - CMKLineValue(m_Items[f_Index - 1]).m_Value[f_SARIndex]);
          if ((CMKLineValue(m_Items[f_Index]).m_Value[f_HIndex] > CMKLineValue(m_Items[f_Index - 1]).m_Value[f_HIndex]) and
              (p_F < 0.2)) then
          begin
            // p_F := p_F + (((0.2 - p_F) > 0.02) ? 0.02 : (0.2 - p_F));
            if ((0.2 - p_F) > 0.02) then
              p_F := p_F + (0.02)
            else
              p_F := p_F + (0.2 - p_F);

            CMKLineValue(m_Items[f_Index]).m_Value[f_AFIndex] := p_F;
          end;
        end;

        if (CMKLineValue(m_Items[f_Index]).m_Value[f_SARIndex] > CMKLineValue(p_SrcValueArray.m_Items[f_Index])
            .m_Value[p_LowIndex]) then
          CMKLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index])
              .m_Value[p_LowIndex];

        if (CMKLineValue(m_Items[f_Index]).m_Value[f_SARIndex] > CMKLineValue(p_SrcValueArray.m_Items[f_Index - 1])
            .m_Value[p_LowIndex]) then
          CMKLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index - 1])
              .m_Value[p_LowIndex];
      end
      else
      begin
        if (CMKLineValue(m_Items[f_Index - 1]).m_Value[f_SIndex] <> -1) then
        begin
          CMKLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CMKLineValue(m_Items[f_Index]).m_Value[f_HIndex];
          CMKLineValue(m_Items[f_Index]).m_Value[f_HIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index])
              .m_Value[p_HighIndex];
          CMKLineValue(m_Items[f_Index]).m_Value[f_LIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index])
              .m_Value[p_LowIndex];
          CMKLineValue(m_Items[f_Index]).m_Value[f_AFIndex] := p_Length;
        end
        else
        begin
          p_F := CMKLineValue(m_Items[f_Index]).m_Value[f_AFIndex];
          CMKLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CMKLineValue(m_Items[f_Index - 1]).m_Value[f_SARIndex] + p_F *
              (CMKLineValue(m_Items[f_Index]).m_Value[f_LIndex] - CMKLineValue(m_Items[f_Index - 1]).m_Value[f_SARIndex]);
          if ((CMKLineValue(m_Items[f_Index]).m_Value[f_LIndex] < CMKLineValue(m_Items[f_Index - 1]).m_Value[f_LIndex]) and
              (p_F < 0.2)) then
          begin
            // p_F = p_F + (((0.2 - p_F) > 0.02) ? 0.02 : (0.2 - p_F));
            if ((0.2 - p_F) > 0.02) then
              p_F := p_F + (0.02)
            else
              p_F := p_F + (0.2 - p_F);

            CMKLineValue(m_Items[f_Index]).m_Value[f_AFIndex] := p_F;
          end;
        end;

        if (CMKLineValue(m_Items[f_Index]).m_Value[f_SARIndex] < CMKLineValue(p_SrcValueArray.m_Items[f_Index])
            .m_Value[p_HighIndex]) then
          CMKLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index])
              .m_Value[p_HighIndex];

        if (CMKLineValue(m_Items[f_Index]).m_Value[f_SARIndex] < CMKLineValue(p_SrcValueArray.m_Items[f_Index - 1])
            .m_Value[p_HighIndex]) then
          CMKLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index - 1])
              .m_Value[p_HighIndex];
      end;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * Slow Stochastics를 계산한다.
  *
  * @param    p_Length1
  * @param    p_Length2
  * @param    p_Length3
  * @param    p_SrcValueArray
  * @param    p_HighIndex
  * @param    p_LowIndex
  * @param    p_CloseIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_SlowSTC(p_Length1, p_Length2, p_Length3: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_SlowKIndex: Integer;
  f_SlowDIndex: Integer;
  f_FastKIndex: Integer;
  f_Count: Integer;
  f_Index: Integer;
  f_Index2: Integer;
  f_DHighest: Double;
  f_DLowest: Double;
  f_HighPrice: Double;
  f_LowPrice: Double;
  f_ClosePrice: Double;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_FastKIndex := p_TagIndex;
  f_SlowKIndex := p_TagIndex + 1;
  f_SlowDIndex := p_TagIndex + 2;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Count := p_Begin to p_End - 1 do
  begin
    f_Index := f_Count - (p_Length1 - 1);
    if (f_Index >= 0) then
    begin
      if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE)) then
      begin
        f_DHighest := MIN_VALUE;
        f_DLowest := MAX_VALUE;
        for f_Index2 := 0 to p_Length1 - 1 do
        begin
          f_HighPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_HighIndex];
          f_LowPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_LowIndex];
          if (f_LowPrice < f_DLowest) then
            f_DLowest := f_LowPrice;

          if (f_HighPrice > f_DHighest) then
            f_DHighest := f_HighPrice;
        end;

        f_ClosePrice := CMKLineValue(p_SrcValueArray.m_Items[f_Count]).m_Value[p_CloseIndex];
        if (f_DHighest = f_DLowest) then
          CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := 0
        else
          CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := (f_ClosePrice - f_DLowest) / (f_DHighest - f_DLowest) * 100.0;
      end
      else
        CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := NOT_VALUE;
    end
    else
      CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := NOT_VALUE;
  end;

  Indicator_XAverage(p_Length2, Self, f_FastKIndex, f_SlowKIndex, p_Begin, p_End);
  Indicator_XAverage(p_Length3, Self, f_SlowKIndex, f_SlowDIndex, p_Begin, p_End);
  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_SlowSTC_CrossSignal(p_Length1, p_Length2, p_Length3: Integer;
    p_SrcValueArray: CMKLineValueSeries; p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_SlowKIndex: Integer;
  f_SlowDIndex: Integer;
  f_FastKIndex: Integer;
  f_Count: Integer;
  f_Index: Integer;
  f_Index2: Integer;
  f_DHighest: Double;
  f_DLowest: Double;
  f_HighPrice: Double;
  f_LowPrice: Double;
  f_ClosePrice: Double;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_FastKIndex := p_TagIndex + 3;
  f_SlowKIndex := p_TagIndex + 1;
  f_SlowDIndex := p_TagIndex + 2;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Count := p_Begin to p_End - 1 do
  begin
    f_Index := f_Count - (p_Length1 - 1);
    if (f_Index >= 0) then
    begin
      if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE)) then
      begin
        f_DHighest := MIN_VALUE;
        f_DLowest := MAX_VALUE;
        for f_Index2 := 0 to p_Length1 - 1 do
        begin
          f_HighPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_HighIndex];
          f_LowPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_LowIndex];
          if (f_LowPrice < f_DLowest) then
            f_DLowest := f_LowPrice;

          if (f_HighPrice > f_DHighest) then
            f_DHighest := f_HighPrice;
        end;

        f_ClosePrice := CMKLineValue(p_SrcValueArray.m_Items[f_Count]).m_Value[p_CloseIndex];
        if (f_DHighest = f_DLowest) then
          CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := 0
        else
          CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := (f_ClosePrice - f_DLowest) / (f_DHighest - f_DLowest) * 100.0;
      end
      else
        CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := NOT_VALUE;
    end
    else
      CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := NOT_VALUE;
  end;

  Indicator_XAverage(p_Length2, Self, f_FastKIndex, f_SlowKIndex, p_Begin, p_End);
  Indicator_XAverage(p_Length3, Self, f_SlowKIndex, f_SlowDIndex, p_Begin, p_End);

  Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * SONAR을 계산한다.
  *
  * @param    p_Length1
  * @param    p_Length2
  * @param    p_Length3
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_SONA(p_Length1, p_Length2, p_Length3: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex: Integer; p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  m_Effect := FALSE;
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  Indicator_NAverage(p_Length1, p_SrcValueArray, p_SrcIndex, p_TagIndex, p_Begin, p_End);
  for f_Index := p_Begin to p_End - 1 do
  begin
    if (f_Index - p_Length2 >= 0) then
    begin
      if ((CMKLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex] <> NOT_VALUE) and
          (CMKLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex] <> NOT_VALUE)) then

        if CMKLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex] <> 0 then
        begin
          CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] :=
              ((CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] - CMKLineValue(m_Items[f_Index - p_Length2])
              .m_Value[p_TagIndex]) / CMKLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex]) * 100.0
        end
        else
        begin
          CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := 0;
        end
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
  end;

  Indicator_NAverage(p_Length3, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);
  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_SONA_CrossSignal(p_Length1, p_Length2, p_Length3: Integer;
    p_SrcValueArray: CMKLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  m_Effect := FALSE;
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  Indicator_NAverage(p_Length1, p_SrcValueArray, p_SrcIndex, p_TagIndex + 3, p_Begin, p_End);
  for f_Index := p_Begin to p_End - 1 do
  begin
    if (f_Index - p_Length2 >= 0) then
    begin
      if ((CMKLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex + 3] <> NOT_VALUE) AND
          (CMKLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex + 3] <> NOT_VALUE)) then
      begin
        if CMKLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex + 3] <> 0 then
        begin
          CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] :=
              ((CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] - CMKLineValue(m_Items[f_Index - p_Length2])
              .m_Value[p_TagIndex + 3]) / CMKLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex + 3]) * 100.0
        end
        else
        begin
          CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := 0;
        end
      end
      else
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
      end;
    end
    else
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
    end;
  end;

  Indicator_NAverage(p_Length3, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);

  Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 표준편차를 계산한다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_PIndex
  * @param    p_SrcValueArray2
  * @param    p_MIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_StdDev(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer;
    p_SrcValueArray2: CMKLineValueSeries; p_MIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Sum: Double;
  f_v0: Double;
  f_v1: Double;
  f_v2: Double;
  f_Index2: Integer;
  f_Index: Integer;
  f_Size: Integer;
  f_AllEffect: Boolean;
  f_MA0: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  if not Assigned(p_SrcValueArray2) then
    exit;
  f_AllEffect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  m_Effect := FALSE;

  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := f_Size;
  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  f_Sum := 0;
  f_v1 := 0;
  for f_Index := p_Begin to p_End - 1 do
  begin
    CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if (f_Index < p_Count - 1) then
      continue;

    if (not f_AllEffect) then
    begin
      if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_PIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_MIndex] <> NOT_VALUE)) then
        f_AllEffect := TRUE
      else
        f_AllEffect := FALSE;

      if (f_AllEffect) then
      begin
        f_MA0 := CMKLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_MIndex];
        f_Sum := 0;
        for f_Index2 := 0 to p_Count - 1 do
        begin
          f_v1 := (f_MA0 - CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[p_PIndex]);
          f_Sum := f_Sum + (f_v1 * f_v1);
        end;
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Sqrt(f_Sum / p_Count);
      end;

      continue;
    end;

    f_v0 := 0;
    f_v2 := 0;
    if (f_Index >= p_Count) then
    begin
      f_MA0 := CMKLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_MIndex];
      f_Sum := 0;
      for f_Index2 := 0 to p_Count - 1 do
      begin
        f_v1 := (f_MA0 - CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[p_PIndex]);
        f_Sum := f_Sum + (f_v1 * f_v1);
      end;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Sqrt(f_Sum / p_Count);
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 두라인의 차이를 계산한다.
  *
  * @param    p_SrcLineSeries1
  * @param    p_SrcIndex1
  * @param    p_SrcValueArray2
  * @param    p_SrcIndex2
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_Subtraction(p_SrcLineSeries1: CMKLineValueSeries; p_SrcIndex1: Integer;
    p_SrcValueArray2: CMKLineValueSeries; p_SrcIndex2, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
begin
  if not Assigned(p_SrcLineSeries1) then
    exit;
  if not Assigned(p_SrcValueArray2) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcLineSeries1.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if ((CMKLineValue(p_SrcLineSeries1.m_Items[f_Index]).m_Value[p_SrcIndex1] <> NOT_VALUE) and
        (CMKLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_SrcIndex2] <> NOT_VALUE)) then
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CMKLineValue(p_SrcLineSeries1.m_Items[f_Index]).m_Value[p_SrcIndex1]
          - CMKLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_SrcIndex2];
  end;

  m_ChartDataSeries := p_SrcLineSeries1.m_ChartDataSeries;
  m_Effect := TRUE;

end;

// ---------------------------------------------------------------------------
{ **
  * TRIX(Tripple Smoothed Moving Averages)을 계산한다.
  *
  * @param    p_Length1
  * @param    p_Length2
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_TRIX(p_Length1, p_Length2: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  // TR:= EMA(EMA(EMA(CLOSE,f_N),f_N),f_N);
  Indicator_XAverage(p_Length1, p_SrcValueArray, p_SrcIndex, p_TagIndex + 0, p_Begin, p_End);
  Indicator_XAverage(p_Length1, Self, p_TagIndex + 0, p_TagIndex + 1, p_Begin, p_End);
  Indicator_XAverage(p_Length1, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);
  // TRIX : (TR-REF(TR,1))/REF(TR,1)*100;
  for f_Index := p_Begin to p_End - 1 do
  begin
    if ((f_Index > 1) and (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 2] <> NOT_VALUE)) then
    begin
      if (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 2] <> 0) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] :=
            (CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] - CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 2]
            ) * 100.0 / CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 2]
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] := 0;
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] := NOT_VALUE;
  end;

  // TRMA : MA(TRIX,M);
  Indicator_NAverage(p_Length2, Self, p_TagIndex + 3, p_TagIndex + 4, p_Begin, p_End);
  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_TRIX_CrossSignal(p_Length1, p_Length2: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  // TR:= EMA(EMA(EMA(CLOSE,f_N),f_N),f_N);
  Indicator_XAverage(p_Length1, p_SrcValueArray, p_SrcIndex, p_TagIndex + 3, p_Begin, p_End);
  Indicator_XAverage(p_Length1, Self, p_TagIndex + 3, p_TagIndex + 4, p_Begin, p_End);
  Indicator_XAverage(p_Length1, Self, p_TagIndex + 4, p_TagIndex + 5, p_Begin, p_End);
  // TRIX : (TR-REF(TR,1))/REF(TR,1)*100;
  for f_Index := p_Begin to p_End - 1 do
  begin
    if ((f_Index > 1) and (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 5] <> NOT_VALUE)) then
    begin
      if (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 5] <> 0) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] :=
            (CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 5] - CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 5]
            ) * 100.0 / CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 5]
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := 0;
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
  end;

  // TRMA : MA(TRIX,M);
  Indicator_NAverage(p_Length2, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);

  Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * TrueRange를 계산한다.
  *
  * @param    p_SrcValueArray
  * @param    p_HighIndex
  * @param    p_LowIndex
  * @param    p_CloseIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_TrueRange(p_SrcValueArray: CMKLineValueSeries;
    p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Count: Integer;
  f_Index: Integer;
  f_Size: Integer;
  f_TrueMaxMin: Double;
  f_TrueHigh: Double;
  f_TrueLow: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    if ((f_Index >= 1) and (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <> NOT_VALUE) and
        (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <> NOT_VALUE) and
        (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE)) then
    begin
      if (CMKLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_CloseIndex] >
          CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex]) then
        f_TrueHigh := CMKLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_CloseIndex]
      else
        f_TrueHigh := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex];

      if (CMKLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_CloseIndex] <
          CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex]) then
        f_TrueLow := CMKLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_CloseIndex]
      else
        f_TrueLow := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex];

      f_TrueMaxMin := f_TrueHigh - f_TrueLow;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_TrueMaxMin;
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 거래량 라인시리즈를 계산한다.
  *
  * @param    p_ChartDataSeries
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_Volume(p_ChartDataSeries: CMKChartDataSeries; p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
  f_OpenPrice00: Double;
  f_ClosePrice00: Double;
  f_ClosePrice01: Double;
begin
  m_Effect := FALSE;
  f_Size := p_ChartDataSeries.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  f_Index := p_Begin;
  while (f_Index < p_End) do
  begin
    f_Value := CMKLineValue(m_Items[f_Index]);
    f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);

    f_OpenPrice00 := f_ChartData.m_OpenPrice;
    f_ClosePrice00 := f_ChartData.m_ClosePrice;
    if (f_Index > 0) then
      f_ClosePrice01 := CMKChartData(p_ChartDataSeries.m_Items[f_Index - 1]).m_OpenPrice
    else
      f_ClosePrice01 := CMKChartData(p_ChartDataSeries.m_Items[f_Index]).m_OpenPrice;

    f_Value.m_Value[0] := f_ChartData.m_Volume;
    if (f_ClosePrice00 > f_OpenPrice00) then
      f_Value.m_Value[1] := 1
    else if (f_ClosePrice00 < f_OpenPrice00) then
      f_Value.m_Value[1] := -1
    else if (f_ClosePrice00 >= f_ClosePrice01) then
      f_Value.m_Value[1] := 1
    else
      f_Value.m_Value[1] := -1;

    Inc(f_Index);
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * VR(Volume Ratio)을 계산한다.
  *
  * @param    p_Length
  * @param    p_SrcValueArray
  * @param    p_PIndex
  * @param    p_SrcValueArray2
  * @param    p_VolumeIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_VR(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer;
    p_SrcValueArray2: CMKLineValueSeries; p_VolumeIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
  f_Index2: Integer;
  f_MinusTrdQty: Double;
  f_PlusTrdQty: Double;
  f_EqualTrdQty: Double;
  f_r1: Double;
  f_r2: Double;
  p_F: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  if not Assigned(p_SrcValueArray2) then
    exit;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  m_Effect := FALSE;
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    if (f_Index - p_Length >= 0) then
    begin
      f_MinusTrdQty := 0;
      f_PlusTrdQty := 0;
      f_EqualTrdQty := 0;

      f_Index2 := 1;
      while (f_Index2 <= p_Length) do
      begin
        if (CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + f_Index2 - 1]).m_Value[p_PIndex] <
            CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + f_Index2]).m_Value[p_PIndex]) then
          f_PlusTrdQty := f_PlusTrdQty + CMKLineValue(p_SrcValueArray2.m_Items[f_Index - p_Length + f_Index2 - 1])
              .m_Value[p_VolumeIndex]
        else if (CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + f_Index2 - 1]).m_Value[p_PIndex] >
            CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + f_Index2]).m_Value[p_PIndex]) then
          f_MinusTrdQty := f_MinusTrdQty + CMKLineValue(p_SrcValueArray2.m_Items[f_Index - p_Length + f_Index2 - 1])
              .m_Value[p_VolumeIndex]
        else
          f_EqualTrdQty := f_EqualTrdQty + CMKLineValue(p_SrcValueArray2.m_Items[f_Index - p_Length + f_Index2 - 1])
              .m_Value[p_VolumeIndex];

        Inc(f_Index2);
      end;

      f_r1 := (f_MinusTrdQty + f_EqualTrdQty * 0.5);
      f_r2 := (f_PlusTrdQty + f_EqualTrdQty + 0.5);
      if (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PIndex] <> NOT_VALUE) then
      begin
        if (f_r2 <> 0.0) then
          CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_r1 / f_r2 * 100.0
        else
          CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
      end
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 가중이동평균을 계산한다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_WAverage(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_CSum: Double;
  f_Price: Double;
  f_AllEffect: Boolean;
  f_Factor: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Sum := 0;
    f_CSum := 0;
    if (f_Index - p_Count + 1 > 0) then
    begin
      for f_Index1 := 0 to p_Count - 1 do
      begin
        f_Price := CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        f_Sum := f_Sum + f_Price * (p_Count - f_Index1);
        f_CSum := f_CSum + p_Count - f_Index1;
      end;

      if (f_CSum > 0) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
    end
    else
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * Williams %R을 계산한다.
  *
  * @param    p_Count1
  * @param    p_Count2
  * @param    p_SrcValueArray
  * @param    p_HighIndex
  * @param    p_LowIndex
  * @param    p_CloseIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_WilliamsR(p_Count1, p_Count2: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
  f_Count: Integer;
  f_MaxValue: Double;
  f_MinValue: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  m_Effect := FALSE;
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_MaxValue := HighestPrice(p_Count1, p_SrcValueArray, p_HighIndex, f_Index);
    f_MinValue := LowestPrice(p_Count1, p_SrcValueArray, p_LowIndex, f_Index);
    if ((f_MaxValue <> MIN_VALUE) and (f_MinValue <> MAX_VALUE)) then
    begin
      if ((f_MaxValue - f_MinValue) = 0) then
      begin
        if ((f_Index > 0) and (CMKLineValue(m_Items[f_Index - 1]) <> NIL)) then
          CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 0]
        else
          CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;
      end
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] :=
            (f_MaxValue - CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex]) * (-100.0) /
            (f_MaxValue - f_MinValue);
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;
  end;

  Indicator_XAverage(p_Count2, Self, p_TagIndex + 0, p_TagIndex + 1, p_Begin, p_End);
  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_WilliamsR_CrossSignal(p_Count1, p_Count2: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
  f_Count: Integer;
  f_MaxValue: Double;
  f_MinValue: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  m_Effect := FALSE;
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_MaxValue := HighestPrice(p_Count1, p_SrcValueArray, p_HighIndex, f_Index);
    f_MinValue := LowestPrice(p_Count1, p_SrcValueArray, p_LowIndex, f_Index);
    if ((f_MaxValue <> MIN_VALUE) and (f_MinValue <> MAX_VALUE)) then
    begin
      if ((f_MaxValue - f_MinValue) = 0) then
      begin
        if ((f_Index > 0) and (CMKLineValue(m_Items[f_Index - 1]) <> NIL)) then
        begin
          CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 0]
        end
        else
        begin
          CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
        end;
      end
      else
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] :=
            (f_MaxValue - CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex]) * (-100.0) /
            (f_MaxValue - f_MinValue);
      end;
    end
    else
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
    end;
  end;

  Indicator_XAverage(p_Count2, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);
  Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);
  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 지수이동평균을 계산한다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMKLineValueSeries.Indicator_XAverage(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_AllEffect: Boolean;
  f_Factor: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  if (p_Count + 1 <> 0) then
  begin
    f_Factor := 2.0 / (p_Count + 1);
    for f_Index := p_Begin to p_End - 1 do
    begin
      if (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] = NOT_VALUE) then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        continue;
      end;

      if ((f_Index <= 0) or (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] = NOT_VALUE)) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex]
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex]
            * f_Factor + (1 - f_Factor) * CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex];
    end;
  end
  else
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  *  p_Position에서 p_Position--p_Count+1 까지 최소값이 들어 있는 인덱스를 찾는다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_PIndex
  * @param    p_Position
  ** }
function CMKLineValueSeries.LowestIndex(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_PIndex, p_Position: Integer): Integer;
var
  f_Index: Integer;
  f_DLowest: Double;
  f_LowestIndex: Integer;
begin
  if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or
      ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
  begin
    Result := 0;
    exit;
  end;

  f_DLowest := MAX_VALUE;
  if (p_Position - p_Count + 1 < 0) then
    p_Count := p_Position + 1;

  for f_Index := 0 to p_Count - 1 do
  begin
    if (f_DLowest > CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PIndex]) then
    begin
      f_DLowest := CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PIndex];
      f_LowestIndex := p_Position - f_Index;
    end;
  end;

  Result := f_LowestIndex;
end;

// ---------------------------------------------------------------------------
{ **
  *  p_Position에서 p_Position--p_Count+1 까지 최소값을 찾는다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_PIndex
  * @param    p_Position
  ** }
function CMKLineValueSeries.LowestPrice(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_PIndex, p_Position: Integer): Double;
var
  f_Index: Integer;
  f_DLowest: Double;
begin
  if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or
      ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
  begin
    Result := 0.0;
    exit;
  end;

  f_DLowest := MAX_VALUE;
  if (p_Position - p_Count + 1 < 0) then
    p_Count := p_Position + 1;

  for f_Index := 0 to p_Count - 1 do
  begin
    if (f_DLowest > CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PIndex]) then
      f_DLowest := CMKLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PIndex];
  end;

  Result := f_DLowest;
end;

// ---------------------------------------------------------------------------
{ **
  * 라인의 수를 설정한다.
  *
  * @param    p_LineCount  라인의 수
  ** }
procedure CMKLineValueSeries.SetLineCount(p_LineCount: Integer);
var
  f_Index: Integer;
begin
  Clear();

  m_LineCount := p_LineCount;
  SetLength(m_LineColors, m_LineCount);
  SetLength(m_LineWidths, m_LineCount);
  SetLength(m_LineAlphas, m_LineCount);
  SetLength(m_LineTypes, m_LineCount);
  SetLength(m_LineNames, m_LineCount);
  SetLength(m_LineVisibles, m_LineCount);
  SetLength(m_LineLabelVisibles, m_LineCount);
  SetLength(m_LineLabelNameVisibles, m_LineCount);
  SetLength(m_LinePosValueVisibles, m_LineCount);
  SetLength(m_LineMaxMinIndexs, m_LineCount);
  for f_Index := 0 to m_LineCount - 1 do
  begin
    m_LineColors[f_Index] := f_Index;
    m_LineWidths[f_Index] := 0;
    m_LineAlphas[f_Index] := 0;
    m_LineTypes[f_Index] := 0;
    m_LineNames[f_Index] := '';
    m_LineVisibles[f_Index] := TRUE;
    m_LineLabelVisibles[f_Index] := TRUE;
    m_LineLabelNameVisibles[f_Index] := TRUE;
    m_LinePosValueVisibles[f_Index] := TRUE;
    m_LineMaxMinIndexs[f_Index] := 0;
  end;
end;

// ---------------------------------------------------------------------------
{ **
  * 값의 갯수를 결정한다.
  *
  * @param    p_Length
  ** }
procedure CMKLineValueSeries.SetLengthSeries(p_Length: Integer);
var
  f_Value: CMKLineValue;
  f_Index: Integer;
  f_delIndex: Integer;
  f_DelCnt: Integer;
  f_DelTotalCnt: Integer;
begin
  while (p_Length > m_Items.Count) do
  begin
    f_Value := CMKLineValue.Create(m_LineCount);
    m_Items.Add(f_Value);
  end;

  f_delIndex := p_Length - 1;
  f_DelCnt := 0;
  f_DelTotalCnt := (m_Items.Count - p_Length);
  while (f_DelCnt < f_DelTotalCnt) do
  begin
    f_Value := CMKLineValue(m_Items[f_delIndex]);
    f_Value.Free();
    m_Items.Delete(f_delIndex);

    Inc(f_DelCnt);
  end;
end;

procedure CMKLineValueSeries.CreateLineValueAdd(p_Index: Integer; p_Value: Double; p_Count: Integer = 1);
var
  f_Index: Integer;
  f_Value: CMKLineValue;
begin
  for f_Index := 0 to p_Count - 1 do
  begin
    f_Value := CMKLineValue.Create(m_LineCount);
    f_Value.m_Value[p_Index] := p_Value;
    m_Items.Add(f_Value);
  end;
end;

procedure CMKLineValueSeries.Indicator_OPS_Price(p_ChartDataSeries: CMKChartDataSeries; p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
  f_OPS0: Double;
  f_OPS1: Double;
begin
  m_Effect := FALSE;
  f_Size := p_ChartDataSeries.m_Items.Count;
  SetLengthSeries(p_ChartDataSeries.m_Items.Count);

  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := f_Size;
  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Value := CMKLineValue(m_Items[f_Index]);
    f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);

    f_Value.m_Value[0] := f_ChartData.m_OpenOPS;
    f_Value.m_Value[1] := f_ChartData.m_HighOPS;
    f_Value.m_Value[2] := f_ChartData.m_LowOPS;
    f_Value.m_Value[3] := f_ChartData.m_CloseOPS;
    f_Value.m_Value[4] := f_ChartData.m_Volume;
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_OPS(p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1; p_End: Integer = -1);
var
  f_Size: Integer;
  f_Index: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
begin
  m_Effect := FALSE;
  f_Size := p_ChartDataSeries.m_Items.Count;
  SetLengthSeries(p_ChartDataSeries.m_Items.Count);

  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := f_Size;
  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Value := CMKLineValue(m_Items[f_Index]);
    f_Value.m_Value[0] := NOT_VALUE;

    f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    if f_ChartData.m_CloseOPS = 0 then
      continue;

    f_Value.m_Value[0] := f_ChartData.m_CloseOPS;
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_OPS_IGUK(p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1;
    p_End: Integer = -1);
var
  f_Count: Integer;
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
begin
  m_Effect := FALSE;
  f_Size := p_ChartDataSeries.m_Items.Count;
  SetLengthSeries(f_Size);

  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Value := CMKLineValue(m_Items[f_Index]);
    f_Value.m_Value[0] := NOT_VALUE;

    f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);

    if f_ChartData.m_CloseOPS = 0 then
      continue;
    if f_ChartData.m_ClosePrice = 0 then
      continue;

    if f_ChartData.m_ClosePrice <> 0 then
    begin
      f_Value.m_Value[0] := (f_ChartData.m_CloseOPS - f_ChartData.m_ClosePrice) * 100.0 / f_ChartData.m_ClosePrice;
    end
    else
    begin
      f_Value.m_Value[0] := 0;
    end;
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_CurveFitting(p_Count: Integer; p_SrcValueArray1: CMKLineValueSeries;
    p_SrcIndex1: Integer; p_SrcValueArray2: CMKLineValueSeries; p_SrcIndex2: Integer; p_TagIndex: Integer;
    p_Begin: Integer = -1; p_End: Integer = -1);
var
  f_Count: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Size: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
  f_Value0: CMKLineValue;
  f_Value1: CMKLineValue;
  f_Value2: CMKLineValue;

  f_X: Double;
  f_Y: Double;
  f_XX: Double;
  f_YY: Double;
  f_XY: Double;

  f_SumX: Double;
  f_SumY: Double;
  f_SumXX: Double;
  f_SumYY: Double;
  f_SumXY: Double;

  f_AllEffect: Boolean;

  f_A0: Double;
  f_A1: Double;
begin
  m_Effect := FALSE;
  f_Size := p_SrcValueArray1.m_Items.Count;
  SetLengthSeries(f_Size);

  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := f_Size;
  if (p_End > f_Size) then
    p_End := f_Size;
  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  Indicator_NAverage(p_Count, p_SrcValueArray1, p_SrcIndex1, p_TagIndex + 1, p_Begin, p_End);
  Indicator_NAverage(p_Count, p_SrcValueArray2, p_SrcIndex2, p_TagIndex + 2, p_Begin, p_End);

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Value := CMKLineValue(m_Items[f_Index]);
    f_Value.m_Value[p_TagIndex] := NOT_VALUE;

    if (f_Index < p_Count - 1) then
      continue;
    if (f_Index < 1) then
      continue;

    f_Value1 := p_SrcValueArray1.m_Items[f_Index];
    f_Value2 := p_SrcValueArray2.m_Items[f_Index];

    if (f_Value1.m_Value[p_SrcIndex1] = NOT_VALUE) then
      continue;
    if (f_Value2.m_Value[p_SrcIndex2] = NOT_VALUE) then
      continue;

    f_SumX := 0;
    f_SumY := 0;
    f_SumXX := 0;
    f_SumYY := 0;
    f_SumXY := 0;

    f_AllEffect := TRUE;
    for f_Index1 := 0 to p_Count - 1 do
    begin
      f_Value1 := p_SrcValueArray1.m_Items[f_Index - f_Index1];
      f_Value2 := p_SrcValueArray2.m_Items[f_Index - f_Index1];

      if ((f_Value1.m_Value[p_SrcIndex1] = NOT_VALUE) OR (f_Value2.m_Value[p_SrcIndex2] = NOT_VALUE)) then
      begin
        f_AllEffect := FALSE;
        break;
      end;

      f_X := f_Value1.m_Value[p_SrcIndex1];
      f_Y := f_Value2.m_Value[p_SrcIndex2];
      f_XX := f_X * f_X;
      f_YY := f_Y * f_Y;
      f_XY := f_X * f_Y;
      f_SumX := f_SumX + f_X;
      f_SumY := f_SumY + f_Y;
      f_SumXX := f_SumXX + f_XX;
      f_SumYY := f_SumYY + f_YY;
      f_SumXY := f_SumXY + f_XY;
    end;
    if f_AllEffect then
    begin
      if ((f_Value.m_Value[p_TagIndex + 1] <> NOT_VALUE) AND (f_Value.m_Value[p_TagIndex + 2] <> NOT_VALUE)) then
      begin
        if (p_Count * f_SumXX - f_SumX * f_SumX) <> 0 then
        begin
          f_A1 := (p_Count * f_SumXY - f_SumX * f_SumY) / (p_Count * f_SumXX - f_SumX * f_SumX);
        end
        else
        begin
          f_A1 := 0;
        end;
        f_A0 := f_Value.m_Value[p_TagIndex + 2] - f_A1 * f_Value.m_Value[p_TagIndex + 1];
        f_Value1 := p_SrcValueArray1.m_Items[f_Index];
        f_Value0 := p_SrcValueArray1.m_Items[f_Index - p_Count + 1];
        f_Value.m_Value[p_TagIndex] := f_A0 + f_A1 * f_Value1.m_Value[p_SrcIndex1];
      end
      else
      begin

      end;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray1.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_OPS_IGUK2(p_Count: Integer; p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1;
    p_End: Integer = -1);
var
  f_Count: Integer;
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
begin
  m_Effect := FALSE;
  f_Size := p_ChartDataSeries.m_Items.Count;
  SetLengthSeries(f_Size);

  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Value := CMKLineValue(m_Items[f_Index]);
    f_Value.m_Value[3] := NOT_VALUE;
    f_Value.m_Value[4] := NOT_VALUE;

    f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);

    if f_ChartData.m_CloseOPS = 0 then
      continue;
    if f_ChartData.m_ClosePrice = 0 then
      continue;

    f_Value.m_Value[4] := f_ChartData.m_ClosePrice;

    if f_ChartData.m_ClosePrice <> 0 then
    begin
      f_Value.m_Value[3] := f_ChartData.m_CloseOPS;
    end
    else
    begin
      f_Value.m_Value[3] := 0;
    end;
  end;

  Indicator_CurveFitting(p_Count, Self, 3, Self, 4, 0, p_Begin, p_End);

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_OPS_STD(p_Count: Integer; p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1;
    p_End: Integer = -1);
var
  f_Count: Integer;
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
begin
  m_Effect := FALSE;
  f_Size := p_ChartDataSeries.m_Items.Count;
  SetLengthSeries(f_Size);

  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := f_Size;
  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Value := CMKLineValue(m_Items[f_Index]);
    f_Value.m_Value[1] := NOT_VALUE;
    f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    if f_ChartData.m_CloseOPS = 0 then
      continue;
    f_Value.m_Value[1] := f_ChartData.m_ClosePrice + (f_ChartData.m_ClosePrice - f_ChartData.m_CloseOPS);
  end;

  Indicator_NAverage(p_Count, Self, 1, 2);
  Indicator_StdDev(p_Count, Self, 1, Self, 2, 0);

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_OPS_REL(p_Count: Integer; p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1;
    p_End: Integer = -1);
var
  f_Count: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Size: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
  f_Value0: CMKLineValue;
  f_Value1: CMKLineValue;

  f_X: Double;
  f_Y: Double;
  f_XX: Double;
  f_YY: Double;
  f_XY: Double;

  f_SumX: Double;
  f_SumY: Double;
  f_SumXX: Double;
  f_SumYY: Double;
  f_SumXY: Double;

  f_AvgX: Double;
  f_AvgY: Double;
  f_AvgXX: Double;
  f_AvgYY: Double;
  f_AvgXY: Double;

  f_N1, f_N2: Double;
begin
  m_Effect := FALSE;
  f_Size := p_ChartDataSeries.m_Items.Count;
  SetLengthSeries(f_Size);

  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := f_Size;
  if (p_End > f_Size) then
    p_End := f_Size;
  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Value := CMKLineValue(m_Items[f_Index]);
    f_Value.m_Value[0] := NOT_VALUE;

    if (f_Index < p_Count - 1) then
      continue;
    if (f_Index < 1) then
      continue;

    f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index - p_Count + 1]);
    if f_ChartData.m_CloseOPS = 0 then
      continue;

    f_SumX := 0;
    f_SumY := 0;
    f_SumXX := 0;
    f_SumYY := 0;
    f_SumXY := 0;

    for f_Index1 := 0 to p_Count - 1 do
    begin
      f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index - f_Index1]);
      f_X := f_ChartData.m_ClosePrice;
      f_Y := f_ChartData.m_CloseOPS;
      f_XX := f_X * f_X;
      f_YY := f_Y * f_Y;
      f_XY := f_X * f_Y;
      f_SumX := f_SumX + f_X;
      f_SumY := f_SumY + f_Y;
      f_SumXX := f_SumXX + f_XX;
      f_SumYY := f_SumYY + f_YY;
      f_SumXY := f_SumXY + f_XY;
    end;
    f_AvgX := f_SumX / p_Count;
    f_AvgY := f_SumY / p_Count;
    f_AvgXX := f_SumXX / p_Count;
    f_AvgYY := f_SumYY / p_Count;
    f_AvgXY := f_SumXY / p_Count;

    if (f_AvgXX - f_AvgX * f_AvgX = 0) OR (f_AvgYY - f_AvgY * f_AvgY = 0) then
    begin
      f_Value.m_Value[0] := 0;
    end
    else
    begin
      f_N1 := (Sqrt(Abs(f_AvgXX - f_AvgX * f_AvgX)) * Sqrt(Abs(f_AvgYY - f_AvgY * f_AvgY)));
      f_N2 := (f_AvgXY - f_AvgX * f_AvgY) * 100.0;

      if f_N1 <> 0.0 then
      begin
        f_Value.m_Value[0] := f_N2 / f_N1;
      end
      else
      begin
        f_Value.m_Value[0] := 0;
      end;
    end;

  end;
  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.ScanSignal(p_ChartDataSeries: CMKChartDataSeries; p_SignalArray: CMKSignalArray;
    p_Begin, p_End: Integer);
var
  f_Count: Integer;
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData: CMKChartData;
  f_Value0: CMKLineValue;
  f_Value1: CMKLineValue;
  f_OldValue: Integer;
  f_NewValue: Integer;
  f_SignalData: CMKSignalData;
  f_Signal: Integer;
  f_SignalIndex: Integer;
begin
  f_Size := p_ChartDataSeries.m_Items.Count;

  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := f_Size - 1;

  if (p_End > f_Size - 1) then
    p_End := f_Size - 1;
  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  p_SignalArray.Clear;

  for f_Index := p_Begin to p_End do
  begin
    f_ChartData := p_ChartDataSeries.m_Items[f_Index];
    f_Value0 := m_Items[f_Index];

    if (f_Value0.m_Value[0] = NOT_VALUE) then
      f_NewValue := 0
    else
      f_NewValue := Trunc(f_Value0.m_Value[0]);

    if (f_Index > p_Begin) then
    begin
      f_Value1 := m_Items[f_Index - 1];
      if (f_Value1.m_Value[0] = NOT_VALUE) then
        f_OldValue := 0
      else
        f_OldValue := Trunc(f_Value1.m_Value[0])
    end
    else
    begin
      f_Value1 := NIL;
      f_OldValue := 0;
    end;

    if (f_OldValue <> 1) AND (f_NewValue = 1) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_BUYENTER;
      f_SignalData := CMKSignalData.Create;
      f_SignalData.m_Index := f_Index;
      f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
      f_SignalData.m_Signal := SIGNAL_BUYENTER;
      f_SignalData.m_Price := f_ChartData.m_ClosePrice;
      f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
      p_SignalArray.Add(f_SignalData);
    end
    else if (f_OldValue <> -1) AND (f_NewValue = -1) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_SELLENTER;
      f_SignalData := CMKSignalData.Create;
      f_SignalData.m_Index := f_Index;
      f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
      f_SignalData.m_Signal := SIGNAL_SELLENTER;
      f_SignalData.m_Price := f_ChartData.m_ClosePrice;
      f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
      p_SignalArray.Add(f_SignalData);
    end
    else if (f_OldValue = 1) AND (f_NewValue = 0) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_BUYEXIT;
      f_SignalData := CMKSignalData.Create;
      f_SignalData.m_Index := f_Index;
      f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
      f_SignalData.m_Signal := SIGNAL_BUYEXIT;
      f_SignalData.m_Price := f_ChartData.m_ClosePrice;
      f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
      p_SignalArray.Add(f_SignalData);
    end
    else if (f_OldValue = -1) AND (f_NewValue = 0) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_SELLEXIT;
      f_SignalData := CMKSignalData.Create;
      f_SignalData.m_Index := f_Index;
      f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
      f_SignalData.m_Signal := SIGNAL_SELLEXIT;
      f_SignalData.m_Price := f_ChartData.m_ClosePrice;
      f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
      p_SignalArray.Add(f_SignalData);
    end;
  end;

  if f_Signal = SIGNAL_BUYENTER then
  begin
    f_Index := p_End;
    f_ChartData := p_ChartDataSeries.m_Items[f_Index];

    f_SignalData := CMKSignalData.Create;
    f_SignalData.m_Index := f_Index;
    f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
    f_SignalData.m_Signal := SIGNAL_BUYEXIT;
    f_SignalData.m_Price := f_ChartData.m_ClosePrice;
    f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
    p_SignalArray.Add(f_SignalData);
  end
  else if f_Signal = SIGNAL_SELLENTER then
  begin
    f_Index := p_End;
    f_ChartData := p_ChartDataSeries.m_Items[f_Index];

    f_SignalData := CMKSignalData.Create;
    f_SignalData.m_Index := f_Index;
    f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
    f_SignalData.m_Signal := SIGNAL_SELLEXIT;
    f_SignalData.m_Price := f_ChartData.m_ClosePrice;
    f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
    p_SignalArray.Add(f_SignalData);
  end;
end;

procedure CMKLineValueSeries.ScanSignal2(p_ChartDataSeries: CMKChartDataSeries; p_SignalArray: CMKSignalArray;
    p_Sequence: Integer; p_Begin, p_End: Integer);
var
  f_Count: Integer;
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData: CMKChartData;
  f_Value0: CMKLineValue;
  f_Value1: CMKLineValue;
  f_OldValue: Integer;
  f_NewValue: Integer;
  f_SignalData: CMKSignalData;
  f_Signal: Integer;
  f_SignalIndex: Integer;
begin
  f_Size := p_ChartDataSeries.m_Items.Count;

  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := f_Size - 1;

  if (p_End > f_Size - 1) then
    p_End := f_Size - 1;
  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  p_SignalArray.Clear;

  for f_Index := p_Begin to p_End do
  begin
    f_ChartData := p_ChartDataSeries.m_Items[f_Index];
    f_Value0 := m_Items[f_Index];

    if (f_Value0.m_Value[p_Sequence] = NOT_VALUE) then
      f_NewValue := 0
    else
      f_NewValue := Trunc(f_Value0.m_Value[p_Sequence]);

    if (f_Index > p_Begin) then
    begin
      f_Value1 := m_Items[f_Index - 1];
      if (f_Value1.m_Value[p_Sequence] = NOT_VALUE) then
        f_OldValue := 0
      else
        f_OldValue := Trunc(f_Value1.m_Value[p_Sequence])
    end
    else
    begin
      f_Value1 := NIL;
      f_OldValue := 0;
    end;

    if (f_OldValue <> 1) AND (f_NewValue = 1) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_BUYENTER;
      f_SignalData := CMKSignalData.Create;
      f_SignalData.m_Index := f_Index;
      f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
      f_SignalData.m_Signal := SIGNAL_BUYENTER;
      f_SignalData.m_Price := f_ChartData.m_ClosePrice;
      f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
      p_SignalArray.Add(f_SignalData);
    end
    else if (f_OldValue <> -1) AND (f_NewValue = -1) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_SELLENTER;
      f_SignalData := CMKSignalData.Create;
      f_SignalData.m_Index := f_Index;
      f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
      f_SignalData.m_Signal := SIGNAL_SELLENTER;
      f_SignalData.m_Price := f_ChartData.m_ClosePrice;
      f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
      p_SignalArray.Add(f_SignalData);
    end
    else if (f_OldValue = 1) AND (f_NewValue = 0) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_BUYEXIT;
      f_SignalData := CMKSignalData.Create;
      f_SignalData.m_Index := f_Index;
      f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
      f_SignalData.m_Signal := SIGNAL_BUYEXIT;
      f_SignalData.m_Price := f_ChartData.m_ClosePrice;
      f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
      p_SignalArray.Add(f_SignalData);
    end
    else if (f_OldValue = -1) AND (f_NewValue = 0) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_SELLEXIT;
      f_SignalData := CMKSignalData.Create;
      f_SignalData.m_Index := f_Index;
      f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
      f_SignalData.m_Signal := SIGNAL_SELLEXIT;
      f_SignalData.m_Price := f_ChartData.m_ClosePrice;
      f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
      p_SignalArray.Add(f_SignalData);
    end;
  end;

  if f_Signal = SIGNAL_BUYENTER then
  begin
    f_Index := p_End;
    f_ChartData := p_ChartDataSeries.m_Items[f_Index];

    f_SignalData := CMKSignalData.Create;
    f_SignalData.m_Index := f_Index;
    f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
    f_SignalData.m_Signal := SIGNAL_BUYEXIT;
    f_SignalData.m_Price := f_ChartData.m_ClosePrice;
    f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
    p_SignalArray.Add(f_SignalData);
  end
  else if f_Signal = SIGNAL_SELLENTER then
  begin
    f_Index := p_End;
    f_ChartData := p_ChartDataSeries.m_Items[f_Index];

    f_SignalData := CMKSignalData.Create;
    f_SignalData.m_Index := f_Index;
    f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
    f_SignalData.m_Signal := SIGNAL_SELLEXIT;
    f_SignalData.m_Price := f_ChartData.m_ClosePrice;
    f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
    p_SignalArray.Add(f_SignalData);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKLineValueSeries.ScanSignalOfRealTime(p_ChartDataSeries: CMKChartDataSeries; p_SignalArray: CMKSignalArray;
    p_SrcIndex: Integer; p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData: CMKChartData;
  f_Value0: CMKLineValue;
  f_Value1: CMKLineValue;
  f_OldValue: Integer;
  f_NewValue: Integer;
  f_SignalData: CMKSignalData;
  f_Signal: Integer;
  f_SignalIndex: Integer;

  f_LastSignalData: CMKSignalData;
begin
  f_Size := p_ChartDataSeries.m_Items.Count;

  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := f_Size;
  if (p_End > f_Size) then
    p_End := f_Size;
  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  if p_SignalArray.m_Items.Count > 0 then
  begin
    f_LastSignalData := p_SignalArray.m_Items.Items[p_SignalArray.m_Items.Count - 1];
  end
  else
  begin
    f_LastSignalData := NIL;
  end;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_ChartData := p_ChartDataSeries.m_Items[f_Index];
    f_Value0 := m_Items[f_Index];
    if (f_Value0.m_Value[p_SrcIndex] = NOT_VALUE) then
      f_NewValue := 0
    else
      f_NewValue := Trunc(f_Value0.m_Value[p_SrcIndex]);
    if (f_Index > 0) then
    begin
      f_Value1 := m_Items[f_Index - 1];
      if (f_Value1.m_Value[p_SrcIndex] = NOT_VALUE) then
        f_OldValue := 0
      else
        f_OldValue := Trunc(f_Value1.m_Value[p_SrcIndex])
    end
    else
    begin
      f_Value1 := NIL;
      f_OldValue := 0;
    end;

    if (f_OldValue <> 1) AND (f_NewValue = 1) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_BUYENTER;

      if not(Assigned(f_LastSignalData) AND (f_LastSignalData.m_Signal = SIGNAL_BUYENTER)) then
      begin
        f_SignalData := CMKSignalData.Create;
        f_SignalData.m_Index := f_Index;
        f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
        f_SignalData.m_Signal := SIGNAL_BUYENTER;
        f_SignalData.m_Price := f_ChartData.m_ClosePrice;
        f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
        p_SignalArray.Add(f_SignalData);
        f_LastSignalData := f_SignalData;
      end;
    end
    else if (f_OldValue <> -1) AND (f_NewValue = -1) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_SELLENTER;
      if not(Assigned(f_LastSignalData) AND (f_LastSignalData.m_Signal = SIGNAL_SELLENTER)) then
      begin
        f_SignalData := CMKSignalData.Create;
        f_SignalData.m_Index := f_Index;
        f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
        f_SignalData.m_Signal := SIGNAL_SELLENTER;
        f_SignalData.m_Price := f_ChartData.m_ClosePrice;
        f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
        p_SignalArray.Add(f_SignalData);
        f_LastSignalData := f_SignalData;
      end;
    end
    else if (f_OldValue = 1) AND (f_NewValue = 0) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_BUYEXIT;
      if not(Assigned(f_LastSignalData) AND (f_LastSignalData.m_Signal = SIGNAL_BUYEXIT)) then
      begin
        f_SignalData := CMKSignalData.Create;
        f_SignalData.m_Index := f_Index;
        f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
        f_SignalData.m_Signal := SIGNAL_BUYEXIT;
        f_SignalData.m_Price := f_ChartData.m_ClosePrice;
        f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
        p_SignalArray.Add(f_SignalData);
        f_LastSignalData := f_SignalData;
      end;
    end
    else if (f_OldValue = -1) AND (f_NewValue = 0) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_SELLEXIT;
      if not(Assigned(f_LastSignalData) AND (f_LastSignalData.m_Signal = SIGNAL_SELLEXIT)) then
      begin
        f_SignalData := CMKSignalData.Create;
        f_SignalData.m_Index := f_Index;
        f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
        f_SignalData.m_Signal := SIGNAL_SELLEXIT;
        f_SignalData.m_Price := f_ChartData.m_ClosePrice;
        f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
        p_SignalArray.Add(f_SignalData);
        f_LastSignalData := f_SignalData;
      end;
    end;
  end;
end;

procedure CMKLineValueSeries.Indicator_NAverageZ(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_AllEffect: Boolean;
  f_Value: Double;
  f_IDX: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if (f_Index < 1) then
      continue;

    if ((f_Index < p_Count) or (f_Index < 1)) then
    begin
      f_Sum := 0;
      for f_Index1 := 0 to p_Count - 1 do
      begin
        f_IDX := f_Index - f_Index1;
        if (f_IDX < 0) then
        begin
          f_Value := 0;
        end
        else
        begin
          f_Value := CMKLineValue(p_SrcValueArray.m_Items[f_IDX]).m_Value[p_SrcIndex];
        end;
        f_Sum := f_Sum + f_Value;
      end;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / p_Count;
    end
    else
    begin
      if (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] = NOT_VALUE) then
      begin
        if (not f_AllEffect) then
        begin
          f_AllEffect := (CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_SrcIndex] <> NOT_VALUE);
          if (f_AllEffect) then
          begin
            f_Index1 := 0;
            f_Sum := 0;
            while (f_Index1 < p_Count) do
            begin
              f_Sum := f_Sum + CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];

              Inc(f_Index1);
            end;

            CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / p_Count;
          end;

          continue;
        end;
      end
      else if (f_Index >= p_Count) then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
            (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] * p_Count + CMKLineValue(p_SrcValueArray.m_Items[f_Index])
            .m_Value[p_SrcIndex] - CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Count]).m_Value[p_SrcIndex]) / p_Count;
      end
      else
      begin
        continue;
      end;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_XAverageZ(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_AllEffect: Boolean;
  f_Factor: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  if (p_Count + 1 <> 0) then
  begin
    f_Factor := 2.0 / (p_Count + 1);
    for f_Index := p_Begin to p_End - 1 do
    begin
      if (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] = NOT_VALUE) then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        continue;
      end;

      if ((f_Index <= 0) or (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] = NOT_VALUE)) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex]
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex]
            * f_Factor + (1 - f_Factor) * CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex];
    end;
  end
  else
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CMKLineValueSeries.Indicator_WAverage2(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_CSum: Double;
  f_Price: Double;
  f_AllEffect: Boolean;
  f_Factor: Double;
  f_Count: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Sum := 0;
    f_CSum := 0;
    if (f_Index - p_Count + 1 > 0) then
    begin
      for f_Index1 := 0 to p_Count - 1 do
      begin
        f_Price := CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        f_Sum := f_Sum + f_Price * (p_Count - f_Index1);
        f_CSum := f_CSum + p_Count - f_Index1;
      end;

      if (f_CSum > 0) then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
      end
      else
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
      end;
    end
    else
    begin
      f_Count := f_Index + 1;
      for f_Index1 := 0 to f_Count - 1 do
      begin
        f_Price := CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        f_Sum := f_Sum + f_Price * (f_Count - f_Index1);
        f_CSum := f_CSum + f_Count - f_Index1;
      end;

      if (f_CSum > 0) then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
      end
      else
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
      end;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// -------------------------------------------------------------------------------------------------------
procedure CMKLineValueSeries.Indicator_WAverage3(p_Count: Integer; p_Precision: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_CSum: Double;
  f_Price: Double;
  f_AllEffect: Boolean;
  f_Factor: Double;
  f_Count: Integer;
  f_Factor2: Double;
begin
  f_Factor2 := Math.Power(10, p_Precision);
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Sum := 0;
    f_CSum := 0;
    if (f_Index - p_Count + 1 > 0) then
    begin
      for f_Index1 := 0 to p_Count - 1 do
      begin
        f_Price := CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        f_Sum := f_Sum + f_Price * (p_Count - f_Index1);
        f_CSum := f_CSum + p_Count - f_Index1;
      end;

      if (f_CSum > 0) then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
            Round(CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] * f_Factor2) / f_Factor2;
      end
      else
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
      end;
    end
    else
    begin
      f_Count := f_Index + 1;
      for f_Index1 := 0 to f_Count - 1 do
      begin
        f_Price := CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        f_Sum := f_Sum + f_Price * (f_Count - f_Index1);
        f_CSum := f_CSum + f_Count - f_Index1;
      end;

      if (f_CSum > 0) then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
            Round(CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] * f_Factor2) / f_Factor2;
      end
      else
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
      end;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
procedure CMKLineValueSeries.Indicator_WAverageZ(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
    p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_CSum: Double;
  f_Price: Double;
  f_AllEffect: Boolean;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Sum := 0;
    f_CSum := 0;
    if (f_Index - p_Count + 1 > 0) then
    begin
      for f_Index1 := 0 to p_Count - 1 do
      begin
        f_Price := CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        f_Sum := f_Sum + f_Price * (p_Count - f_Index1);
        f_CSum := f_CSum + p_Count - f_Index1;
      end;

      if (f_CSum > 0) then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
      end
      else
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
      end;
    end
    else
    begin
      for f_Index1 := 0 to p_Count - 1 do
      begin
        if (f_Index - f_Index1 < 0) then
        begin
          f_Price := 0;
        end
        else
        begin
          f_Price := CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        end;

        f_Sum := f_Sum + f_Price * (p_Count - f_Index1);
        f_CSum := f_CSum + p_Count - f_Index1;
      end;

      if (f_CSum > 0) then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
      end
      else
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
      end;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

end.
