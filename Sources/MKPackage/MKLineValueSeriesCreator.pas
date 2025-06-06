unit MKLineValueSeriesCreator;

interface

uses
  SysUtils,
  MKLineValueSeries, MKStreamChartDataSeries, MKConst, MKColorSet;

type

  /// /////////////////////////////////////////////////////////////////////////
  // 목적에 맞는 CMKLineValueSeries의 객체를 생성하는 클래스
  CMKLineValueSeriesCreator = class(TObject)
  public
  private

  public
    constructor Create();
    destructor Destroy(); override;

    class function Creator_Price(): CMKLineValueSeries;
    class function Creator_Close(): CMKLineValueSeries;
    class function Creator_MA(): CMKLineValueSeries;
    class function Creator_IMLine(): CMKLineValueSeries;
    class function Creator_IMLine2(): CMKLineValueSeries;
    class function Creator_BBand(): CMKLineValueSeries;
    class function Creator_SAR(): CMKLineValueSeries;
    class function Creator_Envelope(): CMKLineValueSeries;
    class function Creator_NET(p_LineCount: Integer): CMKLineValueSeries;
    class function ModifyLine_NET(p_LineCount: Integer; p_Line: CMKLineValueSeries): CMKLineValueSeries;
    class function Creator_Volume(): CMKLineValueSeries;
    class function Creator_MACD(): CMKLineValueSeries;
    class function Creator_ADX(): CMKLineValueSeries;
    class function Creator_DMI(): CMKLineValueSeries;
    class function Creator_RSI(): CMKLineValueSeries;
    class function Creator_OBV(): CMKLineValueSeries;
    class function Creator_FastSTC(): CMKLineValueSeries;
    class function Creator_SlowSTC(): CMKLineValueSeries;
    class function Creator_SONAR(): CMKLineValueSeries;
    class function Creator_PMAO(): CMKLineValueSeries;
    class function Creator_TRIX(): CMKLineValueSeries;
    class function Creator_PSY(): CMKLineValueSeries;
    class function Creator_CCI(): CMKLineValueSeries;
    class function Creator_VR(): CMKLineValueSeries;
    class function Creator_WilliamsR(): CMKLineValueSeries;
    class function Creator_ROC(): CMKLineValueSeries;
    class function Creator_BBWidth(): CMKLineValueSeries;
    class function Creator_BBWidth2(): CMKLineValueSeries;
    class function Creator_ATR(): CMKLineValueSeries;
    class function Creator_LRL(): CMKLineValueSeries;
    class procedure CalulateLine_Price(p_ChartDataSeries: CMKStreamChartDataSeries; p_TagValueArray: CMKLineValueSeries;
        p_ChartType: Integer; p_Begin: Integer; p_End: Integer);
    class procedure CalulateLine_Close(p_ChartDataSeries: CMKStreamChartDataSeries; p_TagValueArray: CMKLineValueSeries;
        p_Begin: Integer; p_End: Integer);
    class procedure CalulateLine_Volume(p_ChartDataSeries: CMKStreamChartDataSeries; p_TagValueArray: CMKLineValueSeries;
        p_Begin: Integer; p_End: Integer);
    class procedure CalulateLine_MA(p_PriceArray: CMKLineValueSeries; p_TagValueArray: CMKLineValueSeries; p_MA1: Integer;
        p_MA2: Integer; p_MA3: Integer; p_Begin: Integer; p_End: Integer);

    class function Creator_PRICE_AT_OPS: CMKLineValueSeries;
    class function Creator_OPS(): CMKLineValueSeries;
    class function Creator_OPS_IGUK: CMKLineValueSeries;
    class function Creator_OPS_IGUK2: CMKLineValueSeries;
    class function Creator_OPS_STD: CMKLineValueSeries;
    class function Creator_OPS_REL: CMKLineValueSeries;

    class function Creator_PriceMACrossSignal(): CMKLineValueSeries;
    class function Creator_MACrossSignal(): CMKLineValueSeries;
    class function Creator_MACDCrossSignal(): CMKLineValueSeries;
    class function Creator_SSTCCrossSignal(): CMKLineValueSeries;
    class function Creator_FSTCCrossSignal(): CMKLineValueSeries;
    class function Creator_RSICrossSignal: CMKLineValueSeries;
    class function Creator_ADXCrossSignal(): CMKLineValueSeries;
    class function Creator_WilliamsRCrossSignal(): CMKLineValueSeries;
    class function Creator_SONARCrossSignal(): CMKLineValueSeries;
    class function Creator_TRIXCrossSignal(): CMKLineValueSeries;

    class function Creator_NMATrendSignal(): CMKLineValueSeries;
    class function Creator_WMATrendSignal(): CMKLineValueSeries;
    class function Creator_XMATrendSignal(): CMKLineValueSeries;
  end;

implementation

uses
  MKGlobal, MKChartDefine;

// ---------------------------------------------------------------------------
constructor CMKLineValueSeriesCreator.Create();
begin
  inherited Create();

end;

// ---------------------------------------------------------------------------
destructor CMKLineValueSeriesCreator.Destroy();
begin

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
class procedure CMKLineValueSeriesCreator.CalulateLine_Close(p_ChartDataSeries: CMKStreamChartDataSeries;
    p_TagValueArray: CMKLineValueSeries; p_Begin, p_End: Integer);
begin
  p_TagValueArray.Indicator_Close(p_ChartDataSeries, p_Begin, p_End);
end;

// ---------------------------------------------------------------------------
class procedure CMKLineValueSeriesCreator.CalulateLine_MA(p_PriceArray, p_TagValueArray: CMKLineValueSeries;
    p_MA1, p_MA2, p_MA3, p_Begin, p_End: Integer);
begin
  p_TagValueArray.m_Options[0] := p_MA1;
  p_TagValueArray.m_Options[1] := p_MA2;
  p_TagValueArray.m_Options[2] := p_MA3;
  p_TagValueArray.Indicator_NAverage(p_MA1, p_PriceArray, 3, 0, p_Begin, p_End);
  p_TagValueArray.Indicator_NAverage(p_MA2, p_PriceArray, 3, 1, p_Begin, p_End);
  p_TagValueArray.Indicator_NAverage(p_MA3, p_PriceArray, 3, 2, p_Begin, p_End);
end;

// ---------------------------------------------------------------------------
class procedure CMKLineValueSeriesCreator.CalulateLine_Price(p_ChartDataSeries: CMKStreamChartDataSeries;
    p_TagValueArray: CMKLineValueSeries; p_ChartType, p_Begin, p_End: Integer);
begin
  p_TagValueArray.m_Options[0] := p_ChartType;
  p_TagValueArray.Indicator_Price(p_ChartDataSeries, p_Begin, p_End);
end;

// ---------------------------------------------------------------------------
class procedure CMKLineValueSeriesCreator.CalulateLine_Volume(p_ChartDataSeries: CMKStreamChartDataSeries;
    p_TagValueArray: CMKLineValueSeries; p_Begin, p_End: Integer);
begin
  p_TagValueArray.Indicator_Volume(p_ChartDataSeries, p_Begin, p_End);
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_ADX: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_ADX_NAME], CMKConst.LINESERIES_ADX, 10, 3, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_ADX_NAME]; // 'ADX(Average Directional Movement Index)';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_ADX1]; // 'ADX';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_ADX2]; // 'MA';
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := false;
  f_Line.m_LineVisibles[3] := false;
  f_Line.m_LineVisibles[4] := false;
  f_Line.m_LineVisibles[5] := false;
  f_Line.m_LineVisibles[6] := false;
  f_Line.m_LineVisibles[7] := false;
  f_Line.m_LineVisibles[8] := false;
  f_Line.m_LineVisibles[9] := false;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_ATR: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_ATR_NAME], CMKConst.LINESERIES_ATR, 2, 1, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_ATR_NAME]; // 'ATR(Average True Range)';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_ATR1]; // '';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_ATR2]; // 'ATR';
  f_Line.m_LineTypes[0] := 0;;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineLabelVisibles[0] := false;
  f_Line.m_LineLabelVisibles[1] := false;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_BBand: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_BB_NAME], CMKConst.LINESERIES_BB, 4, 2, 0, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_BB_NAME]; // 'Bollinger Band';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_BB1]; // 'U';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_BB2]; // 'L';
  f_Line.m_LineNames[2] := g_LineName[LINE_NAME_BB3]; // 'M';
  f_Line.m_LineNames[3] := g_LineName[LINE_NAME_BB4]; // '';
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
class function CMKLineValueSeriesCreator.Creator_BBWidth: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_BBWIDTH_NAME], CMKConst.LINESERIES_BBWIDTH, 3, 2, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_BBWIDTH_NAME]; // 'Bollinger Band Width';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_BBWIDTH1]; // 'Band Width';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_BBWIDTH2]; // '';
  f_Line.m_LineNames[2] := g_LineName[LINE_NAME_BBWIDTH3]; // '';
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineVisibles[1] := false;
  f_Line.m_LineVisibles[2] := false;
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelVisibles[1] := false;
  f_Line.m_LineLabelVisibles[2] := false;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineLabelNameVisibles[1] := false;
  f_Line.m_LineLabelNameVisibles[2] := false;

  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_BBWidth2: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_BBWIDTH_NAME], CMKConst.LINESERIES_BBWIDTH, 4, 2, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_BBWIDTH_NAME]; // 'Bollinger Band Width';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_BBWIDTH1]; // 'Band Width';
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
class function CMKLineValueSeriesCreator.Creator_CCI: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_CCI_NAME], CMKConst.LINESERIES_CCI, 5, 1, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_CCI_NAME]; // 'CCI(Commodity Channel Index)';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_CCI1]; // '';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_CCI2]; // '';
  f_Line.m_LineNames[2] := g_LineName[LINE_NAME_CCI3]; // '';
  f_Line.m_LineNames[3] := g_LineName[LINE_NAME_CCI4]; // '';
  f_Line.m_LineNames[4] := g_LineName[LINE_NAME_CCI5]; // 'CCI';
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;
  f_Line.m_LineWidths[3] := 0;
  f_Line.m_LineWidths[4] := 0;
  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := false;
  f_Line.m_LineVisibles[2] := false;
  f_Line.m_LineVisibles[3] := false;
  f_Line.m_LineVisibles[4] := true;
  f_Line.m_LineLabelVisibles[0] := false;
  f_Line.m_LineLabelVisibles[1] := false;
  f_Line.m_LineLabelVisibles[2] := false;
  f_Line.m_LineLabelVisibles[3] := false;
  f_Line.m_LineLabelVisibles[4] := true;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineLabelNameVisibles[1] := false;
  f_Line.m_LineLabelNameVisibles[2] := false;
  f_Line.m_LineLabelNameVisibles[3] := false;
  f_Line.m_LineLabelNameVisibles[4] := false;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[3] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[4] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[3] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[4] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_Close: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorFullName[IND_CLOSE_NAME], CMKConst.LINESERIES_CLOSE, 1, 0, 0, 0);
  f_Line.m_ViewLabel := false;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_DMI: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_DMI_NAME], CMKConst.LINESERIES_DMI, 8, 1, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_DMI_NAME]; // 'DMI(Directional Movement Indicators)';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_DMI1]; // 'PDI';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_DMI2]; // 'MDI';
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := false;
  f_Line.m_LineVisibles[3] := false;
  f_Line.m_LineVisibles[4] := false;
  f_Line.m_LineVisibles[5] := false;
  f_Line.m_LineVisibles[6] := false;
  f_Line.m_LineVisibles[7] := false;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_Envelope: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_ENVELOPE_NAME], CMKConst.LINESERIES_ENVELOPE, 3, 2, 0, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_ENVELOPE_NAME]; // 'Envelop';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_ENVELOPE1]; // 'U';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_ENVELOPE2]; // 'L';
  f_Line.m_LineNames[2] := g_LineName[LINE_NAME_ENVELOPE3]; // 'M';
  f_Line.m_LineTypes[0] := 0;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelVisibles[1] := true;
  f_Line.m_LineLabelVisibles[2] := true;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineLabelNameVisibles[1] := false;
  f_Line.m_LineLabelNameVisibles[2] := false;
  f_Line.m_LineColors[0] := 22;
  f_Line.m_LineColors[1] := 22;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_FastSTC: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_FASTSTC_NAME], CMKConst.LINESERIES_FASTSTC, 2, 2, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_FASTSTC_NAME]; // 'Fast Stochastics';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_FASTSTC1]; // 'Fast %K';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_FASTSTC2]; // 'Fast %D';
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineVisibles[1] := true;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_IMLine: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_ILMOK_NAME], CMKConst.LINESERIES_ILMOK, 5, 3, 0, 0);
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_ILMOK1]; // '전환';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_ILMOK2]; // '기준';
  f_Line.m_LineNames[2] := g_LineName[LINE_NAME_ILMOK3]; // '선행1';
  f_Line.m_LineNames[3] := g_LineName[LINE_NAME_ILMOK4]; // '선행2';
  f_Line.m_LineNames[4] := g_LineName[LINE_NAME_ILMOK5]; // '후행';
  f_Line.m_LineColors[0] := 35;
  f_Line.m_LineColors[1] := 36;
  f_Line.m_LineColors[2] := 37;
  f_Line.m_LineColors[3] := 38;
  f_Line.m_LineColors[4] := 39;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[3] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[4] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;
  f_Line.m_LineWidths[3] := 0;
  f_Line.m_LineWidths[4] := 0;
  f_Line.m_Precision := 2;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_IMLine2: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_ILMOK_NAME], CMKConst.LINESERIES_ILMOK, 4, 3, 0, 0);
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_ILMOK1]; // '전환';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_ILMOK2]; // '기준';
  f_Line.m_LineNames[2] := g_LineName[LINE_NAME_ILMOK3]; // '선행1';
  f_Line.m_LineNames[3] := g_LineName[LINE_NAME_ILMOK4]; // '선행2';

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
class function CMKLineValueSeriesCreator.Creator_LRL: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_LRL_NAME], CMKConst.LINESERIES_LRL, 3, 1, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_LRL_NAME]; // 'LRL(Linear Regression Line)';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_LRL1]; // 'LRL';
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineVisibles[1] := false;
  f_Line.m_LineVisibles[2] := false;
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelVisibles[1] := false;
  f_Line.m_LineLabelVisibles[2] := false;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineLabelNameVisibles[1] := false;
  f_Line.m_LineLabelNameVisibles[2] := false;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_MA: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_MA_NAME], CMKConst.LINESERIES_MA, 4, 4, 0, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_MA_NAME]; // '이동평균선';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_MA1]; // '';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_MA2]; // '';
  f_Line.m_LineNames[2] := g_LineName[LINE_NAME_MA3]; // '';
  f_Line.m_LineNames[3] := g_LineName[LINE_NAME_MA4]; // '';
  f_Line.m_LineTypes[0] := 0;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;
  f_Line.m_LineTypes[3] := 0;
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;
  f_Line.m_LineWidths[3] := 0;
  f_Line.m_LineColors[0] := 30;
  f_Line.m_LineColors[1] := 31;
  f_Line.m_LineColors[2] := 32;
  f_Line.m_LineColors[3] := 33;
  f_Line.m_Precision := 2;

  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[3] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_MACD: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_MACD_NAME], CMKConst.LINESERIES_MACD, 5, 3, 0, 2);
  f_Line.m_FullName := g_IndicatorFullName[IND_MACD_NAME]; // 'MACD(Moving Average Convergence / Divergence)';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_MACD1]; // '';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_MACD2]; // '';
  f_Line.m_LineNames[2] := g_LineName[LINE_NAME_MACD3]; // 'MACD';
  f_Line.m_LineNames[3] := g_LineName[LINE_NAME_MACD4]; // 'Sign';
  f_Line.m_LineNames[4] := g_LineName[LINE_NAME_MACD5]; // 'Osc';
  f_Line.m_LineTypes[4] := 1;
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;
  f_Line.m_LineWidths[3] := 0;
  f_Line.m_LineWidths[4] := 0;
  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := false;
  f_Line.m_LineVisibles[2] := true;
  f_Line.m_LineVisibles[3] := true;
  f_Line.m_LineVisibles[4] := true;
  f_Line.m_LineMaxMinIndexs[0] := 0;
  f_Line.m_LineMaxMinIndexs[1] := 0;
  f_Line.m_LineMaxMinIndexs[2] := 0;
  f_Line.m_LineMaxMinIndexs[3] := 0;
  f_Line.m_LineMaxMinIndexs[4] := 0;
  f_Line.m_MaxMinFactor[0] := 1.0;
  f_Line.m_LineColors[0] := 0;
  f_Line.m_LineColors[1] := 0;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[3] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineColors[4] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[3] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[4] := CMKColorSet.ALPHA_LIGHT_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_NET(p_LineCount: Integer): CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
  f_Index: Integer;
  f_Alpha: Double;
  f_AlphaIncrese: Double;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_NET_NAME], CMKConst.LINESERIES_NET, p_LineCount, 3, 0, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_NET_NAME]; // '그물차트';
  f_Alpha := CMKColorSet.ALPHA_DARK_LINE;
  f_AlphaIncrese := (CMKColorSet.ALPHA_DARK_LINE) / p_LineCount;
  for f_Index := 0 to p_LineCount - 1 do
  begin
    f_Line.m_LineNames[f_Index] := '';
    f_Line.m_LineTypes[f_Index] := 0;
    f_Line.m_LineWidths[f_Index] := 0;
    f_Line.m_LineVisibles[f_Index] := true;
    f_Line.m_LineLabelVisibles[f_Index] := false;
    f_Line.m_LineLabelNameVisibles[f_Index] := false;
    f_Line.m_LinePosValueVisibles[f_Index] := false;
    f_Line.m_LineColors[f_Index] := 40;

    if ((f_Index = 0) or (f_Index = p_LineCount - 1)) then
      f_Line.m_LineAlphas[f_Index] := CMKColorSet.ALPHA_DARK_LINE
    else
      f_Line.m_LineAlphas[f_Index] := CMKColorSet.ALPHA_LIGHT_LINE;
  end;

  f_Line.m_LineLabelVisibles[0] := true;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_OBV: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_OBV_NAME], CMKConst.LINESERIES_OBV, 1, 0, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_OBV_NAME];
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_OBV1];
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_PMAO: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_PMAO_NAME], CMKConst.LINESERIES_PMAO, 3, 2, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_PMAO_NAME]; // 'PMAO(Price Oscillator)';
  f_Line.m_LineNames[2] := g_LineName[LINE_NAME_PMAO3]; // 'PMAO';
  f_Line.m_LineTypes[0] := 1;
  f_Line.m_LineTypes[1] := 1;
  f_Line.m_LineTypes[2] := 1;
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := false;
  f_Line.m_LineVisibles[2] := true;
  f_Line.m_LineLabelVisibles[0] := false;
  f_Line.m_LineLabelVisibles[1] := false;
  f_Line.m_LineLabelVisibles[2] := true;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineLabelNameVisibles[1] := false;
  f_Line.m_LineLabelNameVisibles[2] := true;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_Price: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  // f_Line := CMKLineValueSeries.Create('PRICE', CMKConst.LINESERIES_PRICE, 5, 1, 0, 0);
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_PRICE_NAME], CMKConst.LINESERIES_PRICE, 5, 1, 0, 0);
  f_Line.m_ViewLabel := false;
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_PRICE1]; // '시가';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_PRICE2]; // '고가';
  f_Line.m_LineNames[2] := g_LineName[LINE_NAME_PRICE3]; // '저가';
  f_Line.m_LineNames[3] := g_LineName[LINE_NAME_PRICE4]; // '종가';
  f_Line.m_LineColors[0] := CMKColorSet.PRICE_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.PRICE_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.PRICE_COLOR;
  f_Line.m_LineColors[3] := CMKColorSet.PRICE_COLOR;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_PSY: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_PSY_NAME], CMKConst.LINESERIES_PSY, 1, 1, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_PSY_NAME]; // '투자심리선(Psychogical Line)';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_PSY1]; // '투자심리선';
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineWidths[0] := 0;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_ROC: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_ROC_NAME], CMKConst.LINESERIES_ROC, 1, 1, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_ROC_NAME]; // 'ROC(Price Rate Of Change)';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_ROC1]; // 'ROC';
  f_Line.m_LineTypes[0] := 0;
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_RSI: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_RSI_NAME], CMKConst.LINESERIES_RSI, 2, 2, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_RSI_NAME]; // 'RSI(Relative Strength Index)';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_RSI1]; // 'RSI';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_RSI2]; // 'RSI-Signal';
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_SAR: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_SAR_NAME], CMKConst.LINESERIES_SAR, 5, 1, 0, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_SAR_NAME]; // 'Parabolic SAR(Stop and Reversal)';
  f_Line.m_LineNames[3] := g_LineName[LINE_NAME_SAR4]; // 'Parabolic';
  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := false;
  f_Line.m_LineVisibles[2] := false;
  f_Line.m_LineVisibles[3] := true;
  f_Line.m_LineVisibles[4] := false;
  f_Line.m_LineLabelVisibles[0] := false;
  f_Line.m_LineLabelVisibles[1] := false;
  f_Line.m_LineLabelVisibles[2] := false;
  f_Line.m_LineLabelVisibles[3] := true;
  f_Line.m_LineLabelVisibles[4] := false;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineLabelNameVisibles[1] := false;
  f_Line.m_LineLabelNameVisibles[2] := false;
  f_Line.m_LineLabelNameVisibles[3] := false;
  f_Line.m_LineLabelNameVisibles[4] := false;
  f_Line.m_Precision := 2;
  f_Line.m_LineTypes[3] := 2;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := 21;
  f_Line.m_LineColors[2] := 27;
  f_Line.m_LineColors[3] := 30;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[3] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;
  f_Line.m_LineWidths[3] := 0;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_SlowSTC: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_SLOWSTC_NAME], CMKConst.LINESERIES_SLOWSTC, 3, 3, 2);
  f_Line.m_FullName := g_IndicatorFullName[IND_SLOWSTC_NAME]; // 'Slow Stochastics';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_SLOWSTC1]; // 'Fast %K';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_SLOWSTC2]; // 'Slow %K';
  f_Line.m_LineNames[2] := g_LineName[LINE_NAME_SLOWSTC3]; // 'Slow %D';
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

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_SONAR: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_SONAR_NAME], CMKConst.LINESERIES_SONAR, 3, 3, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_SONAR_NAME]; // 'SONAR';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_SONAR1]; // '';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_SONAR2]; // 'SONAR';
  f_Line.m_LineNames[2] := g_LineName[LINE_NAME_SONAR3]; // 'MA';
  f_Line.m_LineTypes[0] := 0;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;
  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

class function CMKLineValueSeriesCreator.Creator_SONARCrossSignal: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('SONAR 돌파매매분석', CMKConst.LINESERIES_SONA_CROSS_SIGNAL, 4, 3, 0);
  f_Line.m_FullName := 'SONAR 돌파매매분석';

  f_Line.m_LineNames[1] := 'SONAR';
  f_Line.m_LineNames[2] := 'MA';

  f_Line.m_LineTypes[0] := 4;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;
  f_Line.m_LineTypes[3] := 0;

  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;
  f_Line.m_LineWidths[3] := 0;

  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;
  f_Line.m_LineVisibles[3] := false;

  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE2_COLOR;

  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;

  f_Line.m_Signal := true;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_TRIX: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_TRIX_NAME], CMKConst.LINESERIES_TRIX, 5, 2, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_TRIX_NAME]; // 'TRIX(Tripple Smoothed Moving Averages)';
  f_Line.m_LineNames[3] := g_LineName[LINE_NAME_TRIX4]; // 'TRIX';
  f_Line.m_LineNames[4] := g_LineName[LINE_NAME_TRIX5]; // 'TRMA';
  f_Line.m_LineTypes[0] := 0;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;
  f_Line.m_LineTypes[3] := 0;
  f_Line.m_LineTypes[4] := 0;
  f_Line.m_LineWidths[3] := 0;
  f_Line.m_LineWidths[4] := 0;
  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := false;
  f_Line.m_LineVisibles[2] := false;
  f_Line.m_LineVisibles[3] := true;
  f_Line.m_LineVisibles[4] := true;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[3] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[4] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[3] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[4] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

class function CMKLineValueSeriesCreator.Creator_TRIXCrossSignal: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('TRIX 돌파매매분석', CMKConst.LINESERIES_TRIX_CROSS_SIGNAL, 6, 2, 0);
  f_Line.m_FullName := 'TRIX 돌파매매분석';

  f_Line.m_LineTypes[0] := 4;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;
  f_Line.m_LineTypes[3] := 0;
  f_Line.m_LineTypes[4] := 0;
  f_Line.m_LineTypes[5] := 0;

  f_Line.m_LineNames[1] := 'TRIX';
  f_Line.m_LineNames[2] := 'TRMA';

  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;
  f_Line.m_LineVisibles[3] := false;
  f_Line.m_LineVisibles[4] := false;
  f_Line.m_LineVisibles[5] := false;

  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE2_COLOR;

  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;

  f_Line.m_Signal := true;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_Volume: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_VOLUME_NAME], CMKConst.LINESERIES_VOLUME, 2, 0, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_VOLUME_NAME]; // '거래량';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_VOLUME1]; // '거래량';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_VOLUME2]; // '';
  f_Line.m_LineTypes[0] := 3;
  f_Line.m_LineTypes[1] := 3;
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineVisibles[1] := false;
  f_Line.m_LineMaxMinIndexs[0] := 0;
  f_Line.m_LineMaxMinIndexs[1] := 0;
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelVisibles[1] := false;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineLabelNameVisibles[1] := false;
  f_Line.m_LineColors[0] := CMKColorSet.VOLUME_LINE_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.VOLUME_LINE_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_VR: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_VR_NAME], CMKConst.LINESERIES_VR, 1, 1, 4);
  f_Line.m_FullName := g_IndicatorFullName[IND_VR_NAME]; // 'VR(Volume Ratio)';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_VR1]; // 'VR';
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_Values[0] := 70;
  f_Line.m_Values[1] := 150;
  f_Line.m_Values[2] := 200;
  f_Line.m_Values[3] := 450;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_WilliamsR: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create(g_IndicatorName[IND_WILLIAM_NAME], CMKConst.LINESERIES_WILLIAM, 2, 2, 0);
  f_Line.m_FullName := g_IndicatorFullName[IND_WILLIAM_NAME]; // 'Williams'' %R';
  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_WILLIAM1]; // '%R';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_WILLIAM2]; // '%D';
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineColors[0] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

class function CMKLineValueSeriesCreator.Creator_WilliamsRCrossSignal: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('Williams'' %R 돌파매매분석', CMKConst.LINESERIES_WILLIAMSR_CROSS_SIGNAL, 3, 2, 0);
  f_Line.m_FullName := 'Williams'' %R 돌파매매분석';

  f_Line.m_LineNames[1] := '%R';
  f_Line.m_LineNames[2] := '%D';

  f_Line.m_LineTypes[0] := 4;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;

  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;

  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE2_COLOR;

  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;

  f_Line.m_Signal := true;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.ModifyLine_NET(p_LineCount: Integer; p_Line: CMKLineValueSeries): CMKLineValueSeries;
var
  f_Index: Integer;
  f_Alpha: Double;
  f_AlphaIncrese: Double;
begin
  p_Line.SetLineCount(p_LineCount);
  p_Line.m_FullName := g_IndicatorFullName[IND_NET_NAME]; // '그물차트';
  f_Alpha := CMKColorSet.ALPHA_DARK_LINE;
  f_AlphaIncrese := (CMKColorSet.ALPHA_DARK_LINE) / p_LineCount;

  for f_Index := 0 to p_LineCount - 1 do
  begin
    p_Line.m_LineNames[f_Index] := '';
    p_Line.m_LineTypes[f_Index] := 0;
    p_Line.m_LineWidths[f_Index] := 0;
    p_Line.m_LineVisibles[f_Index] := true;
    p_Line.m_LineLabelVisibles[f_Index] := false;
    p_Line.m_LineLabelNameVisibles[f_Index] := false;
    p_Line.m_LinePosValueVisibles[f_Index] := false;
    p_Line.m_LineColors[f_Index] := 40;
    if ((f_Index = 0) or (f_Index = p_LineCount - 1)) then
      p_Line.m_LineAlphas[f_Index] := CMKColorSet.ALPHA_DARK_LINE
    else
      p_Line.m_LineAlphas[f_Index] := CMKColorSet.ALPHA_LIGHT_LINE;
  end;

  p_Line.m_LineLabelVisibles[0] := true;

  Result := p_Line;
end;

class function CMKLineValueSeriesCreator.Creator_PRICE_AT_OPS: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('주가', CMKConst.LINESERIES_PRICE_AT_OPS, 1, 0, 0);
  f_Line.m_FullName := '주가';
  f_Line.m_LineNames[0] := '주가';
  f_Line.m_LineTypes[0] := 0;
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineColors[0] := CMKColorSet.OPS_LINE_OPS;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;

end;

class function CMKLineValueSeriesCreator.Creator_OPS: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('오메가', CMKConst.LINESERIES_OPS, 1, 0, 0);
  f_Line.m_FullName := '오메가';
  f_Line.m_LineNames[0] := '오메가';
  f_Line.m_LineTypes[0] := 0;
  f_Line.m_LineWidths[0] := 6;
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineColors[0] := CMKColorSet.OPS_LINE_OPS;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;

end;

class function CMKLineValueSeriesCreator.Creator_OPS_IGUK: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('오메가 이격율', CMKConst.LINESERIES_OPSIGUK, 1, 0, 0);
  f_Line.m_FullName := '오메가 이격율';
  f_Line.m_LineNames[0] := '이격율';
  f_Line.m_LineTypes[0] := 0;
  f_Line.m_LineWidths[0] := 2;
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineColors[0] := CMKColorSet.OPS_LINE_IGUK;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;

end;

class function CMKLineValueSeriesCreator.Creator_OPS_IGUK2: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('오메가2', CMKConst.LINESERIES_OPSIGUK2, 5, 1, 0);
  f_Line.m_FullName := '오메가2';
  f_Line.m_LineNames[0] := '오메가2';
  f_Line.m_LineTypes[0] := 0;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;
  f_Line.m_LineTypes[3] := 0;
  f_Line.m_LineTypes[4] := 0;
  f_Line.m_LineWidths[0] := 2;
  f_Line.m_LineWidths[1] := 2;
  f_Line.m_LineWidths[2] := 2;
  f_Line.m_LineWidths[3] := 2;
  f_Line.m_LineWidths[4] := 2;
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineVisibles[1] := false;
  f_Line.m_LineVisibles[2] := false;
  f_Line.m_LineVisibles[3] := false;
  f_Line.m_LineVisibles[4] := false;
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelVisibles[1] := false;
  f_Line.m_LineLabelVisibles[2] := false;
  f_Line.m_LineLabelVisibles[3] := false;
  f_Line.m_LineLabelVisibles[4] := false;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineLabelNameVisibles[1] := false;
  f_Line.m_LineLabelNameVisibles[2] := false;
  f_Line.m_LineLabelNameVisibles[3] := false;
  f_Line.m_LineLabelNameVisibles[4] := false;
  f_Line.m_LineColors[0] := CMKColorSet.OPS_LINE_IGUK2;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;

end;

class function CMKLineValueSeriesCreator.Creator_OPS_STD: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('오메가 표준편차', CMKConst.LINESERIES_OPSSTDDEV, 3, 1, 0);
  f_Line.m_FullName := '오메가 표준편차';
  f_Line.m_LineNames[0] := '표준편차';
  f_Line.m_LineNames[1] := '';
  f_Line.m_LineNames[2] := '';
  f_Line.m_LineTypes[0] := 0;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;
  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineVisibles[1] := false;
  f_Line.m_LineVisibles[2] := false;
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineLabelVisibles[1] := false;
  f_Line.m_LineLabelVisibles[2] := false;
  f_Line.m_LineColors[0] := CMKColorSet.OPS_LINE_STDDEV;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;

end;

class function CMKLineValueSeriesCreator.Creator_OPS_REL: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('오메가 상관차트', CMKConst.LINESERIES_OPSREL, 1, 1, 0);
  f_Line.m_FullName := '오메가 상관차트';
  f_Line.m_LineNames[0] := '상관계수';
  f_Line.m_LineTypes[0] := 0;
  f_Line.m_LineWidths[0] := 2;
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineLabelVisibles[0] := true;
  f_Line.m_LineLabelNameVisibles[0] := false;
  f_Line.m_LineColors[0] := CMKColorSet.OPS_LINE_REL;
  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;

  Result := f_Line;
end;

class function CMKLineValueSeriesCreator.Creator_PriceMACrossSignal: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('주가:이평선 돌파 매매분석', CMKConst.LINESERIES_PRICE_MA_CROSS_SIGNAL, 3, 1, 0, 0);
  f_Line.m_FullName := '주가:이평선 돌파 매매분석';

  f_Line.m_LineNames[0] := '';
  f_Line.m_LineNames[1] := '주가';
  f_Line.m_LineNames[2] := '이평';

  f_Line.m_LineTypes[0] := 4;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;

  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;

  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;

  f_Line.m_LineColors[0] := 0;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE2_COLOR;

  f_Line.m_Precision := 2;

  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;

  f_Line.m_Signal := true;

  Result := f_Line;
end;

class function CMKLineValueSeriesCreator.Creator_MACDCrossSignal: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('MACD 돌파 매매분석', CMKConst.LINESERIES_MACD_CROSS_SIGNAL, 5, 3, 0, 2);
  f_Line.m_FullName := 'MACD 돌파 매매분석';
  f_Line.m_LineNames[0] := '';
  f_Line.m_LineNames[1] := 'MACD';
  f_Line.m_LineNames[2] := 'Sign';

  f_Line.m_LineTypes[0] := 4;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;

  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;
  f_Line.m_LineWidths[3] := 0;
  f_Line.m_LineWidths[4] := 0;

  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;
  f_Line.m_LineVisibles[3] := false;
  f_Line.m_LineVisibles[4] := false;

  f_Line.m_LineColors[0] := 0;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineColors[3] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineColors[4] := CMKColorSet.IND_LINE1_COLOR;

  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[3] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[4] := CMKColorSet.ALPHA_LIGHT_LINE;

  f_Line.m_Signal := true;

  Result := f_Line;
end;

class function CMKLineValueSeriesCreator.Creator_MACrossSignal: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('이동평균선 돌파 매매분석', CMKConst.LINESERIES_MA_CROSS_SIGNAL, 3, 2, 0, 0);
  f_Line.m_FullName := '이동평균선 돌파 매매분석';
  f_Line.m_LineNames[0] := '';
  f_Line.m_LineNames[1] := '단기이평';
  f_Line.m_LineNames[2] := '장기이평';

  f_Line.m_LineTypes[0] := 4;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;

  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;

  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;

  f_Line.m_LineColors[0] := 0;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE2_COLOR;

  f_Line.m_Precision := 2;

  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;

  f_Line.m_Signal := true;

  Result := f_Line;
end;

class function CMKLineValueSeriesCreator.Creator_SSTCCrossSignal: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('SSTC 돌파매매분석', CMKConst.LINESERIES_SSTC_CROSS_SIGNAL, 4, 3, 0);
  f_Line.m_FullName := 'SSTC 돌파매매분석';
  f_Line.m_LineNames[0] := '';
  f_Line.m_LineNames[1] := 'Slow %K';
  f_Line.m_LineNames[2] := 'Slow %D';
  f_Line.m_LineNames[3] := 'Fast %K';

  f_Line.m_LineTypes[0] := 4;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;

  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;
  f_Line.m_LineWidths[3] := 0;

  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;
  f_Line.m_LineVisibles[3] := false;

  f_Line.m_LineColors[0] := 0;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineColors[3] := CMKColorSet.IND_LINE2_COLOR;

  f_Line.m_LineAlphas[0] := 0;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[3] := CMKColorSet.ALPHA_DARK_LINE;

  f_Line.m_Signal := true;

  Result := f_Line;
end;

class function CMKLineValueSeriesCreator.Creator_FSTCCrossSignal: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('FSTC 돌파매매분석', CMKConst.LINESERIES_FSTC_CROSS_SIGNAL, 3, 2, 0);
  f_Line.m_FullName := 'FSTC 돌파매매분석';

  f_Line.m_LineNames[0] := '';
  f_Line.m_LineNames[1] := 'Fast %K';
  f_Line.m_LineNames[2] := 'Fast %D';

  f_Line.m_LineTypes[0] := 4;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;

  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;

  f_Line.m_LineColors[0] := 0;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE2_COLOR;

  f_Line.m_LineAlphas[0] := 0;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;

  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;

  f_Line.m_Signal := true;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
class function CMKLineValueSeriesCreator.Creator_RSICrossSignal: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('RSI 돌파매매분석', CMKConst.LINESERIES_RSI_CROSS_SIGNAL, 3, 2, 0);
  f_Line.m_FullName := 'RSI 돌파매매분석';

  f_Line.m_LineTypes[0] := 4;
  f_Line.m_LineTypes[1] := 0;
  f_Line.m_LineTypes[2] := 0;

  f_Line.m_LineNames[1] := 'RSI';
  f_Line.m_LineNames[2] := 'RSI-Signal';

  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;

  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;

  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE2_COLOR;

  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;

  f_Line.m_Signal := true;

  Result := f_Line;
end;

class function CMKLineValueSeriesCreator.Creator_ADXCrossSignal: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('ADX 돌파매매분석', CMKConst.LINESERIES_ADX_CROSS_SIGNAL, 11, 3, 0);
  f_Line.m_FullName := 'ADX 돌파매매분석';
  f_Line.m_LineNames[1] := 'ADX';
  f_Line.m_LineNames[2] := 'MA';

  f_Line.m_LineWidths[1] := 0;
  f_Line.m_LineWidths[2] := 0;

  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;
  f_Line.m_LineVisibles[3] := false;
  f_Line.m_LineVisibles[4] := false;
  f_Line.m_LineVisibles[5] := false;
  f_Line.m_LineVisibles[6] := false;
  f_Line.m_LineVisibles[7] := false;
  f_Line.m_LineVisibles[8] := false;
  f_Line.m_LineVisibles[9] := false;
  f_Line.m_LineVisibles[10] := false;

  f_Line.m_LineTypes[0] := 4;

  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[2] := CMKColorSet.IND_LINE2_COLOR;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CMKColorSet.ALPHA_DARK_LINE;

  f_Line.m_Signal := true;

  Result := f_Line;
end;

class function CMKLineValueSeriesCreator.Creator_NMATrendSignal: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('단순이평선 추세전환 매매분석', CMKConst.LINESERIES_NMA_TREND_SIGNAL, 2, 1, 0, 0);
  f_Line.m_FullName := '단순이평선 추세 매매분석';
  f_Line.m_LineNames[0] := '';
  f_Line.m_LineNames[1] := '이평';

  f_Line.m_LineTypes[0] := 4;
  f_Line.m_LineTypes[1] := 0;

  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;

  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;

  f_Line.m_LineColors[0] := 0;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;

  f_Line.m_Precision := 2;

  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;

  f_Line.m_Signal := true;

  Result := f_Line;
end;

class function CMKLineValueSeriesCreator.Creator_WMATrendSignal: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('가중이평선 추세전환 매매분석', CMKConst.LINESERIES_WMA_TREND_SIGNAL, 2, 1, 0, 0);
  f_Line.m_FullName := '가중이평선 추세 매매분석';
  f_Line.m_LineNames[0] := '';
  f_Line.m_LineNames[1] := '이평';

  f_Line.m_LineTypes[0] := 4;
  f_Line.m_LineTypes[1] := 0;

  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;

  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;

  f_Line.m_LineColors[0] := 0;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;

  f_Line.m_Precision := 2;

  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;

  f_Line.m_Signal := true;

  Result := f_Line;
end;

class function CMKLineValueSeriesCreator.Creator_XMATrendSignal: CMKLineValueSeries;
var
  f_Line: CMKLineValueSeries;
begin
  f_Line := CMKLineValueSeries.Create('지수이평선 추세전환 매매분석', CMKConst.LINESERIES_XMA_TREND_SIGNAL, 2, 1, 0, 0);
  f_Line.m_FullName := '지수이평선 추세 매매분석';
  f_Line.m_LineNames[0] := '';
  f_Line.m_LineNames[1] := '이평';

  f_Line.m_LineTypes[0] := 4;
  f_Line.m_LineTypes[1] := 0;

  f_Line.m_LineWidths[0] := 0;
  f_Line.m_LineWidths[1] := 0;

  f_Line.m_LineVisibles[0] := false;
  f_Line.m_LineVisibles[1] := true;

  f_Line.m_LineColors[0] := 0;
  f_Line.m_LineColors[1] := CMKColorSet.IND_LINE1_COLOR;

  f_Line.m_Precision := 2;

  f_Line.m_LineAlphas[0] := CMKColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CMKColorSet.ALPHA_DARK_LINE;

  f_Line.m_Signal := true;

  Result := f_Line;
end;

end.
