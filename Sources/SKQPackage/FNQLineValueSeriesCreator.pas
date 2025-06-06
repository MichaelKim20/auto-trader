unit FNQLineValueSeriesCreator;

interface
uses
    SysUtils,
    FNQLineValueSeries, FNQChartDataSeries, FNQConst, FNQColorSet;

type

    ////////////////////////////////////////////////////////////////////////////
    //목적에 맞는 CFNQLineValueSeries의 객체를 생성하는 클래스
    CFNQLineValueSeriesCreator = class(TObject)
    public
  private

    public
        constructor Create();
        destructor  Destroy(); override;

        function Creator_Price() : CFNQLineValueSeries;
        function Creator_Close() : CFNQLineValueSeries;
        function Creator_MA() : CFNQLineValueSeries;
        function Creator_IMLine() : CFNQLineValueSeries;
        function Creator_BBand() : CFNQLineValueSeries;
        function Creator_SAR() : CFNQLineValueSeries;
        function Creator_Envelope() : CFNQLineValueSeries;
        function Creator_NET(p_LineCount:Integer) : CFNQLineValueSeries;
        function ModifyLine_NET(p_LineCount:Integer; p_Line:CFNQLineValueSeries) : CFNQLineValueSeries;
        function Creator_MamulOverlay() : CFNQLineValueSeries;
        function Creator_Volume() : CFNQLineValueSeries;
        function Creator_MACD() : CFNQLineValueSeries;
        function Creator_ADX() : CFNQLineValueSeries;
        function Creator_DMI() : CFNQLineValueSeries;
        function Creator_RSI() : CFNQLineValueSeries;
        function Creator_OBV() : CFNQLineValueSeries;
        function Creator_FastSTC() : CFNQLineValueSeries;
        function Creator_SlowSTC() : CFNQLineValueSeries;
        function Creator_SONAR() : CFNQLineValueSeries;
        function Creator_PMAO() : CFNQLineValueSeries;
        function Creator_TRIX() : CFNQLineValueSeries;
        function Creator_PSY() : CFNQLineValueSeries;
        function Creator_CCI() : CFNQLineValueSeries;
        function Creator_VR() : CFNQLineValueSeries;
        function Creator_WilliamsR() : CFNQLineValueSeries;
        function Creator_ROC() : CFNQLineValueSeries;
        function Creator_BBWidth() : CFNQLineValueSeries;
        function Creator_ATR() : CFNQLineValueSeries;
        function Creator_LRL() : CFNQLineValueSeries;
        function Creator_Samsun() : CFNQLineValueSeries;
        function Creator_PF() : CFNQLineValueSeries;
        function Creator_Mamul() : CFNQLineValueSeries;
        function Creator_CompareClose(p_Lable:String) : CFNQLineValueSeries;
        procedure CalulateLine_Price(p_ChartDataSeries:CFNQChartDataSeries; p_TagValueArray:CFNQLineValueSeries; p_ChartType:Integer; p_Begin:Integer; p_End:Integer);
        procedure CalulateLine_Close(p_ChartDataSeries:CFNQChartDataSeries; p_TagValueArray:CFNQLineValueSeries; p_Begin:Integer; p_End:Integer);
        procedure CalulateLine_Volume(p_ChartDataSeries:CFNQChartDataSeries; p_TagValueArray:CFNQLineValueSeries; p_Begin:Integer; p_End:Integer);
        procedure CalulateLine_MA(p_PriceArray:CFNQLineValueSeries; p_TagValueArray:CFNQLineValueSeries; p_MA1:Integer; p_MA2:Integer; p_MA3:Integer; p_Begin:Integer; p_End:Integer);

        function Creator_PRICE_AT_OPS: CFNQLineValueSeries;
        function Creator_OPS() : CFNQLineValueSeries;
        function Creator_OPS_IGUK: CFNQLineValueSeries;
        function Creator_OPS_IGUK2: CFNQLineValueSeries;
        function Creator_OPS_STD: CFNQLineValueSeries;
        function Creator_OPS_REL: CFNQLineValueSeries;

        function Creator_PriceMACrossSignal() : CFNQLineValueSeries;
        function Creator_MACrossSignal() : CFNQLineValueSeries;
        function Creator_MACDCrossSignal() : CFNQLineValueSeries;
        function Creator_SSTCCrossSignal() : CFNQLineValueSeries;
        function Creator_FSTCCrossSignal() : CFNQLineValueSeries;
        function Creator_RSICrossSignal: CFNQLineValueSeries;
        function Creator_ADXCrossSignal() : CFNQLineValueSeries;
        function Creator_WilliamsRCrossSignal() : CFNQLineValueSeries;
        function Creator_SONARCrossSignal() : CFNQLineValueSeries;
        function Creator_TRIXCrossSignal() : CFNQLineValueSeries;

        function Creator_NMATrendSignal() : CFNQLineValueSeries;
        function Creator_WMATrendSignal() : CFNQLineValueSeries;
        function Creator_XMATrendSignal() : CFNQLineValueSeries;

    end;

implementation
uses
    FNGlobal, FNQChartDefine;

//---------------------------------------------------------------------------
constructor CFNQLineValueSeriesCreator.Create();
begin
    inherited Create();

end;

//---------------------------------------------------------------------------
destructor CFNQLineValueSeriesCreator.Destroy();
begin

    inherited Destroy();
end;

//---------------------------------------------------------------------------
procedure CFNQLineValueSeriesCreator.CalulateLine_Close(p_ChartDataSeries: CFNQChartDataSeries;
  p_TagValueArray: CFNQLineValueSeries; p_Begin, p_End: Integer);
begin
    p_TagValueArray.Indicator_Close(p_ChartDataSeries, p_Begin, p_End);
end;

//---------------------------------------------------------------------------
procedure CFNQLineValueSeriesCreator.CalulateLine_MA(p_PriceArray,
  p_TagValueArray: CFNQLineValueSeries; p_MA1, p_MA2, p_MA3, p_Begin, p_End: Integer);
begin
    p_TagValueArray.m_Options[0] := p_MA1;
    p_TagValueArray.m_Options[1] := p_MA2;
    p_TagValueArray.m_Options[2] := p_MA3;
    p_TagValueArray.Indicator_NAverage(p_MA1, p_PriceArray, 3, 0, p_Begin, p_End);
    p_TagValueArray.Indicator_NAverage(p_MA2, p_PriceArray, 3, 1, p_Begin, p_End);
    p_TagValueArray.Indicator_NAverage(p_MA3, p_PriceArray, 3, 2, p_Begin, p_End);
end;

//---------------------------------------------------------------------------
procedure CFNQLineValueSeriesCreator.CalulateLine_Price(p_ChartDataSeries: CFNQChartDataSeries;
  p_TagValueArray: CFNQLineValueSeries; p_ChartType, p_Begin, p_End: Integer);
begin
    p_TagValueArray.m_Options[0] := p_ChartType;
    p_TagValueArray.Indicator_Price(p_ChartDataSeries, p_Begin, p_End);
end;

//---------------------------------------------------------------------------
procedure CFNQLineValueSeriesCreator.CalulateLine_Volume(p_ChartDataSeries: CFNQChartDataSeries;
  p_TagValueArray: CFNQLineValueSeries; p_Begin, p_End: Integer);
begin
    p_TagValueArray.Indicator_Volume(p_ChartDataSeries, p_Begin, p_End);
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_ADX: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_ADX_NAME], CFNQConst.LINESERIES_ADX, 10, 3, 0);
    f_Line.m_FullName           := g_IndicatorFullName[IND_ADX_NAME];   //'ADX(Average Directional Movement Index)';
    f_Line.m_LineNames[0]       := g_LineName[LINE_NAME_ADX1];  //'ADX';
    f_Line.m_LineNames[1]       := g_LineName[LINE_NAME_ADX2];  //'MA';
    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineVisibles[0]    := true;
    f_Line.m_LineVisibles[1]    := true;
    f_Line.m_LineVisibles[2]    := false;
    f_Line.m_LineVisibles[3]    := false;
    f_Line.m_LineVisibles[4]    := false;
    f_Line.m_LineVisibles[5]    := false;
    f_Line.m_LineVisibles[6]    := false;
    f_Line.m_LineVisibles[7]    := false;
    f_Line.m_LineVisibles[8]    := false;
    f_Line.m_LineVisibles[9]    := false;
    f_Line.m_LineColors[0]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_ATR: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_ATR_NAME], CFNQConst.LINESERIES_ATR, 2, 1, 0);
    f_Line.m_FullName       := g_IndicatorFullName[IND_ATR_NAME];   //'ATR(Average True Range)';
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_ATR1];  //'';
    f_Line.m_LineNames[1]   := g_LineName[LINE_NAME_ATR2];  //'ATR';
    f_Line.m_LineTypes[0]   := 0;    ;
    f_Line.m_LineTypes[1]   := 0;
    f_Line.m_LineWidths[0]  := 0;
    f_Line.m_LineWidths[1]  := 0;
    f_Line.m_LineVisibles[0]        := false;
    f_Line.m_LineVisibles[1]        := true;
    f_Line.m_LineLabelVisibles[0]   := false;
    f_Line.m_LineLabelVisibles[1]   := false;
    f_Line.m_LineColors[0]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[1]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]  := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_BBand: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line  := CFNQLineValueSeries.Create(g_IndicatorName[IND_BB_NAME], CFNQConst.LINESERIES_BB, 4, 1, 0, 0);
    f_Line.m_FullName           := g_IndicatorFullName[IND_BB_NAME];   //'Bollinger Band';
    f_Line.m_LineNames[0]       := g_LineName[LINE_NAME_BB1];  //'U';
    f_Line.m_LineNames[1]       := g_LineName[LINE_NAME_BB2];  //'L';
    f_Line.m_LineNames[2]       := g_LineName[LINE_NAME_BB3];  //'M';
    f_Line.m_LineNames[3]       := g_LineName[LINE_NAME_BB4];  //'';
    f_Line.m_LineTypes[0]       := 0;
    f_Line.m_LineTypes[1]       := 0;
    f_Line.m_LineTypes[2]       := 0;
    f_Line.m_LineTypes[3]       := 0;
    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineWidths[2]      := 0;
    f_Line.m_LineWidths[3]      := 0;
    f_Line.m_LineVisibles[0]    := true;
    f_Line.m_LineVisibles[1]    := true;
    f_Line.m_LineVisibles[2]    := true;
    f_Line.m_LineVisibles[3]    := false;
    f_Line.m_LineLabelVisibles[0]       := true;
    f_Line.m_LineLabelVisibles[1]       := true;
    f_Line.m_LineLabelVisibles[2]       := true;
    f_Line.m_LineLabelVisibles[3]       := false;
    f_Line.m_LineLabelNameVisibles[0]   := false;
    f_Line.m_LineLabelNameVisibles[1]   := false;
    f_Line.m_LineLabelNameVisibles[2]   := false;
    f_Line.m_LineLabelNameVisibles[3]   := false;
    f_Line.m_Precision          := 2;
    f_Line.m_LineColors[0]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]      := 21;
    f_Line.m_LineColors[3]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_LIGHT_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_LIGHT_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[3]      := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_BBWidth: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_BBWIDTH_NAME], CFNQConst.LINESERIES_BBWIDTH, 3, 2, 0);
    f_Line.m_FullName           := g_IndicatorFullName[IND_BBWIDTH_NAME];   //'Bollinger Band Width';
    f_Line.m_LineNames[0]       := g_LineName[LINE_NAME_BBWIDTH1];  //'Band Width';
    f_Line.m_LineNames[1]       := g_LineName[LINE_NAME_BBWIDTH2];  //'';
    f_Line.m_LineNames[2]       := g_LineName[LINE_NAME_BBWIDTH3];  //'';
    f_Line.m_LineVisibles[0]    := true;
    f_Line.m_LineVisibles[1]    := false;
    f_Line.m_LineVisibles[2]    := false;
    f_Line.m_LineLabelVisibles[0] := true;
    f_Line.m_LineLabelVisibles[1] := false;
    f_Line.m_LineLabelVisibles[2] := false;
    f_Line.m_LineLabelNameVisibles[0] := false;
    f_Line.m_LineLabelNameVisibles[1] := false;
    f_Line.m_LineLabelNameVisibles[2] := false;

    f_Line.m_LineColors[0]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_CCI: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_CCI_NAME], CFNQConst.LINESERIES_CCI, 5, 1, 0);
    f_Line.m_FullName       := g_IndicatorFullName[IND_CCI_NAME];   //'CCI(Commodity Channel Index)';
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_CCI1];  //'';
    f_Line.m_LineNames[1]   := g_LineName[LINE_NAME_CCI2];  //'';
    f_Line.m_LineNames[2]   := g_LineName[LINE_NAME_CCI3];  //'';
    f_Line.m_LineNames[3]   := g_LineName[LINE_NAME_CCI4];  //'';
    f_Line.m_LineNames[4]   := g_LineName[LINE_NAME_CCI5];  //'CCI';
    f_Line.m_LineWidths[0]  := 0;
    f_Line.m_LineWidths[1]  := 0;
    f_Line.m_LineWidths[2]  := 0;
    f_Line.m_LineWidths[3]  := 0;
    f_Line.m_LineWidths[4]  := 0;
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
    f_Line.m_LineColors[0]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[1]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[3]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[4]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[3]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[4]  := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_Close: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line  := CFNQLineValueSeries.Create(g_IndicatorFullName[IND_CLOSE_NAME], CFNQConst.LINESERIES_CLOSE, 1, 0, 0, 0);
    f_Line.m_ViewLabel := false;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_CompareClose(p_Lable: String): CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(p_Lable, CFNQConst.LINESERIES_COMPARECLOSE, 1, 0, 0, 0);
    f_Line.m_ViewLabel      := true;
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_COMPARE];  //'';
    f_Line.m_LineWidths[0]  := 0;
    f_Line.m_LineVisibles[0] := true;
    f_Line.m_LineLabelVisibles[0] := true;
    f_Line.m_LineColors[0] := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineAlphas[0] := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_DMI: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_DMI_NAME], CFNQConst.LINESERIES_DMI, 8, 1, 0);
    f_Line.m_FullName           := g_IndicatorFullName[IND_DMI_NAME];   //'DMI(Directional Movement Indicators)';
    f_Line.m_LineNames[0]       := g_LineName[LINE_NAME_DMI1];  //'PDI';
    f_Line.m_LineNames[1]       := g_LineName[LINE_NAME_DMI2];  //'MDI';
    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineVisibles[0]    := true;
    f_Line.m_LineVisibles[1]    := true;
    f_Line.m_LineVisibles[2]    := false;
    f_Line.m_LineVisibles[3]    := false;
    f_Line.m_LineVisibles[4]    := false;
    f_Line.m_LineVisibles[5]    := false;
    f_Line.m_LineVisibles[6]    := false;
    f_Line.m_LineVisibles[7]    := false;
    f_Line.m_LineColors[0]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_Envelope: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_ENVELOPE_NAME], CFNQConst.LINESERIES_ENVELOPE, 3, 2, 0, 0);
    f_Line.m_FullName           := g_IndicatorFullName[IND_ENVELOPE_NAME];   //'Envelop';
    f_Line.m_LineNames[0]       := g_LineName[LINE_NAME_ENVELOPE1];  //'U';
    f_Line.m_LineNames[1]       := g_LineName[LINE_NAME_ENVELOPE2];  //'L';
    f_Line.m_LineNames[2]       := g_LineName[LINE_NAME_ENVELOPE3];  //'M';
    f_Line.m_LineTypes[0]       := 0;
    f_Line.m_LineTypes[1]       := 0;
    f_Line.m_LineTypes[2]       := 0;
    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineWidths[2]      := 0;
    f_Line.m_LineVisibles[0]    := true;
    f_Line.m_LineVisibles[1]    := true;
    f_Line.m_LineVisibles[2]    := true;
    f_Line.m_LineLabelVisibles[0]   := true;
    f_Line.m_LineLabelVisibles[1]   := true;
    f_Line.m_LineLabelVisibles[2]   := true;
    f_Line.m_LineLabelNameVisibles[0]   := false;
    f_Line.m_LineLabelNameVisibles[1]   := false;
    f_Line.m_LineLabelNameVisibles[2]   := false;
    f_Line.m_LineColors[0]      := 22;
    f_Line.m_LineColors[1]      := 22;
    f_Line.m_LineColors[2]      := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_FastSTC: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_FASTSTC_NAME], CFNQConst.LINESERIES_FASTSTC, 2, 2, 0);
    f_Line.m_FullName       := g_IndicatorFullName[IND_FASTSTC_NAME];   //'Fast Stochastics';
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_FASTSTC1];  //'Fast %K';
    f_Line.m_LineNames[1]   := g_LineName[LINE_NAME_FASTSTC2];  //'Fast %D';
    f_Line.m_LineWidths[0]  := 0;
    f_Line.m_LineWidths[1]  := 0;
    f_Line.m_LineColors[0]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[1]  := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineVisibles[0] := true;
    f_Line.m_LineVisibles[1] := true;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_IMLine: CFNQLineValueSeries;
var
    f_Line  : CFNQLineValueSeries;
begin
    f_Line  := CFNQLineValueSeries.Create(g_IndicatorName[IND_ILMOK_NAME], CFNQConst.LINESERIES_ILMOK, 5, 3, 0, 0);
    f_Line.m_LineNames[0]       := g_LineName[LINE_NAME_ILMOK1];  //'전환';
    f_Line.m_LineNames[1]       := g_LineName[LINE_NAME_ILMOK2];  //'기준';
    f_Line.m_LineNames[2]       := g_LineName[LINE_NAME_ILMOK3];  //'선행1';
    f_Line.m_LineNames[3]       := g_LineName[LINE_NAME_ILMOK4];  //'선행2';
    f_Line.m_LineNames[4]       := g_LineName[LINE_NAME_ILMOK5];  //'후행';
    f_Line.m_LineColors[0]      := 35;
    f_Line.m_LineColors[1]      := 36;
    f_Line.m_LineColors[2]      := 37;
    f_Line.m_LineColors[3]      := 38;
    f_Line.m_LineColors[4]      := 39;
    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[3]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[4]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineWidths[2]      := 0;
    f_Line.m_LineWidths[3]      := 0;
    f_Line.m_LineWidths[4]      := 0;
    f_Line.m_Precision          := 2;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_LRL: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_LRL_NAME], CFNQConst.LINESERIES_LRL, 3, 1, 0);
    f_Line.m_FullName           := g_IndicatorFullName[IND_LRL_NAME];   //'LRL(Linear Regression Line)';
    f_Line.m_LineNames[0]       := g_LineName[LINE_NAME_LRL1];  //'LRL';
    f_Line.m_LineVisibles[0]    := true;
    f_Line.m_LineVisibles[1]    := false;
    f_Line.m_LineVisibles[2]    := false;
    f_Line.m_LineLabelVisibles[0] := true;
    f_Line.m_LineLabelVisibles[1] := false;
    f_Line.m_LineLabelVisibles[2] := false;
    f_Line.m_LineLabelNameVisibles[0] := false;
    f_Line.m_LineLabelNameVisibles[1] := false;
    f_Line.m_LineLabelNameVisibles[2] := false;
    f_Line.m_LineColors[0]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineWidths[2]      := 0;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_MA: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_MA_NAME], CFNQConst.LINESERIES_MA, 4, 4, 0, 0);
    f_Line.m_FullName           := g_IndicatorFullName[IND_MA_NAME];   //'이동평균선';
    f_Line.m_LineNames[0]       := g_LineName[LINE_NAME_MA1];  //'';
    f_Line.m_LineNames[1]       := g_LineName[LINE_NAME_MA2];  //'';
    f_Line.m_LineNames[2]       := g_LineName[LINE_NAME_MA3];  //'';
    f_Line.m_LineNames[3]       := g_LineName[LINE_NAME_MA4];  //'';
    f_Line.m_LineTypes[0]       := 0;
    f_Line.m_LineTypes[1]       := 0;
    f_Line.m_LineTypes[2]       := 0;
    f_Line.m_LineTypes[3]       := 0;
    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineWidths[2]      := 0;
    f_Line.m_LineWidths[3]      := 0;
    f_Line.m_LineColors[0]      := 30;
    f_Line.m_LineColors[1]      := 31;
    f_Line.m_LineColors[2]      := 32;
    f_Line.m_LineColors[3]      := 33;
    f_Line.m_Precision          := 2;

    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[3]      := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_MACD: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_MACD_NAME], CFNQConst.LINESERIES_MACD, 5, 3, 0, 2);
    f_Line.m_FullName           := g_IndicatorFullName[IND_MACD_NAME];   //'MACD(Moving Average Convergence / Divergence)';
    f_Line.m_LineNames[0]       := g_LineName[LINE_NAME_MACD1];  //'';
    f_Line.m_LineNames[1]       := g_LineName[LINE_NAME_MACD2];  //'';
    f_Line.m_LineNames[2]       := g_LineName[LINE_NAME_MACD3];  //'MACD';
    f_Line.m_LineNames[3]       := g_LineName[LINE_NAME_MACD4];  //'Sign';
    f_Line.m_LineNames[4]       := g_LineName[LINE_NAME_MACD5];  //'Osc';
    f_Line.m_LineTypes[4]       := 1;
    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineWidths[2]      := 0;
    f_Line.m_LineWidths[3]      := 0;
    f_Line.m_LineWidths[4]      := 0;
    f_Line.m_LineVisibles[0]    := false;
    f_Line.m_LineVisibles[1]    := false;
    f_Line.m_LineVisibles[2]    := true;
    f_Line.m_LineVisibles[3]    := true;
    f_Line.m_LineVisibles[4]    := true;
    f_Line.m_LineMaxMinIndexs[0] := 0;
    f_Line.m_LineMaxMinIndexs[1] := 0;
    f_Line.m_LineMaxMinIndexs[2] := 0;
    f_Line.m_LineMaxMinIndexs[3] := 0;
    f_Line.m_LineMaxMinIndexs[4] := 0;
    f_Line.m_MaxMinFactor[0]    := 1.0;
    f_Line.m_LineColors[0]      := 0;
    f_Line.m_LineColors[1]      := 0;
    f_Line.m_LineColors[2]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[3]      := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineColors[4]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[3]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[4]      := CFNQColorSet.ALPHA_LIGHT_LINE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_Mamul: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_MAMULOVERLAY_NAME], CFNQConst.LINESERIES_MAMUL, 4, 0, 0, 0);
    f_Line.m_FullName       := g_IndicatorFullName[IND_MAMULOVERLAY_NAME];   //'매물대';
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_MAMULOVERLAY1];  //'';
    f_Line.m_LineNames[1]   := g_LineName[LINE_NAME_MAMULOVERLAY2];  //'';
    f_Line.m_LineNames[2]   := g_LineName[LINE_NAME_MAMULOVERLAY3];  //'';
    f_Line.m_LineNames[3]   := g_LineName[LINE_NAME_MAMULOVERLAY3];  //'';
    f_Line.m_LineLabelVisibles[0] := false;
    f_Line.m_LineLabelVisibles[1] := false;
    f_Line.m_LineLabelVisibles[2] := false;
    f_Line.m_LineLabelVisibles[3] := false;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_MamulOverlay: CFNQLineValueSeries;
var
    f_Line  : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_MAMULOVERLAY_NAME], CFNQConst.LINESERIES_MAMULOVERLAY, 4, 1, 0, 0);
    f_Line.m_FullName           := g_IndicatorFullName[IND_MAMULOVERLAY_NAME];   //'매물대';
    f_Line.m_LineNames[0]       := g_LineName[LINE_NAME_MAMULOVERLAY1];  //'';
    f_Line.m_LineNames[1]       := g_LineName[LINE_NAME_MAMULOVERLAY2];  //'';
    f_Line.m_LineNames[2]       := g_LineName[LINE_NAME_MAMULOVERLAY3];  //'';
    f_Line.m_LineNames[3]       := g_LineName[LINE_NAME_MAMULOVERLAY4];  //'';
    f_Line.m_LineLabelVisibles[0]   := false;
    f_Line.m_LineLabelVisibles[1]   := false;
    f_Line.m_LineLabelVisibles[2]   := false;
    f_Line.m_LineLabelVisibles[3]   := false;
    f_Line.m_LineLabelNameVisibles[0]   := false;
    f_Line.m_LineLabelNameVisibles[1]   := false;
    f_Line.m_LineLabelNameVisibles[2]   := false;
    f_Line.m_LineLabelNameVisibles[3]   := false;

    Result := f_Line;
end;


//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_NET(p_LineCount: Integer): CFNQLineValueSeries;
var
    f_Line  : CFNQLineValueSeries;
    f_Index : Integer;
    f_Alpha : Double;
    f_AlphaIncrese  : Double;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_NET_NAME], CFNQConst.LINESERIES_NET, p_LineCount, 3, 0, 0);
    f_Line.m_FullName   := g_IndicatorFullName[IND_NET_NAME];   //'그물차트';
    f_Alpha             := CFNQColorSet.ALPHA_DARK_LINE;
    f_AlphaIncrese      := (CFNQColorSet.ALPHA_DARK_LINE) / p_LineCount;
    for f_Index := 0 to p_LineCount - 1 do
    begin
        f_Line.m_LineNames[f_Index]     := '';
        f_Line.m_LineTypes[f_Index]     := 0;
        f_Line.m_LineWidths[f_Index]    := 0;
        f_Line.m_LineVisibles[f_Index]  := true;
        f_Line.m_LineLabelVisibles[f_Index]     := false;
        f_Line.m_LineLabelNameVisibles[f_Index] := false;
        f_Line.m_LinePosValueVisibles[f_Index]  := false;
        f_Line.m_LineColors[f_Index]    := 40;

        if ((f_Index = 0) or (f_Index = p_LineCount - 1)) then
            f_Line.m_LineAlphas[f_Index] := CFNQColorSet.ALPHA_DARK_LINE
        else
            f_Line.m_LineAlphas[f_Index] := CFNQColorSet.ALPHA_LIGHT_LINE;
    end;

    f_Line.m_LineLabelVisibles[0] := true;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_OBV: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_OBV_NAME], CFNQConst.LINESERIES_OBV, 1, 0, 0);
    f_Line.m_FullName       := g_IndicatorFullName[IND_OBV_NAME];   //'OBV(On Balance Volume)';
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_OBV1];  //'OBV';
    f_Line.m_LineLabelVisibles[0]       := true;
    f_Line.m_LineLabelNameVisibles[0]   := false;
    f_Line.m_LineColors[0]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;


//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_PF: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_PF_NAME], CFNQConst.LINESERIES_PF, 4, 2, 0, 0);
    f_Line.m_FullName       := g_IndicatorFullName[IND_PF_NAME];   //'P&F';
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_PF1];  //'';
    f_Line.m_LineNames[1]   := g_LineName[LINE_NAME_PF2];  //'';
    f_Line.m_LineNames[2]   := g_LineName[LINE_NAME_PF3];  //'';
    f_Line.m_LineNames[3]   := g_LineName[LINE_NAME_PF4];  //'';
    f_Line.m_LineLabelVisibles[0] := false;
    f_Line.m_LineLabelVisibles[1] := false;
    f_Line.m_LineLabelVisibles[2] := false;
    f_Line.m_LineLabelVisibles[3] := false;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_PMAO: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_PMAO_NAME], CFNQConst.LINESERIES_PMAO, 3, 2, 0);
    f_Line.m_FullName           := g_IndicatorFullName[IND_PMAO_NAME];   //'PMAO(Price Oscillator)';
    f_Line.m_LineNames[2]       := g_LineName[LINE_NAME_PMAO3];  //'PMAO';
    f_Line.m_LineTypes[0]       := 1;
    f_Line.m_LineTypes[1]       := 1;
    f_Line.m_LineTypes[2]       := 1;
    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineVisibles[0]    := false;
    f_Line.m_LineVisibles[1]    := false;
    f_Line.m_LineVisibles[2]    := true;
    f_Line.m_LineLabelVisibles[0] := false;
    f_Line.m_LineLabelVisibles[1] := false;
    f_Line.m_LineLabelVisibles[2] := true;
    f_Line.m_LineLabelNameVisibles[0] := false;
    f_Line.m_LineLabelNameVisibles[1] := false;
    f_Line.m_LineLabelNameVisibles[2] := true;
    f_Line.m_LineColors[0]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineColors[2]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_Price: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    //f_Line := CFNQLineValueSeries.Create('PRICE', CFNQConst.LINESERIES_PRICE, 5, 1, 0, 0);
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_PRICE_NAME], CFNQConst.LINESERIES_PRICE, 5, 1, 0, 0);
    f_Line.m_ViewLabel      := false;
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_PRICE1];  //'시가';
    f_Line.m_LineNames[1]   := g_LineName[LINE_NAME_PRICE2];  //'고가';
    f_Line.m_LineNames[2]   := g_LineName[LINE_NAME_PRICE3];  //'저가';
    f_Line.m_LineNames[3]   := g_LineName[LINE_NAME_PRICE4];  //'종가';
    f_Line.m_LineColors[0]  := CFNQColorSet.PRICE_COLOR;
    f_Line.m_LineColors[1]  := CFNQColorSet.PRICE_COLOR;
    f_Line.m_LineColors[2]  := CFNQColorSet.PRICE_COLOR;
    f_Line.m_LineColors[3]  := CFNQColorSet.PRICE_COLOR;

    Result := f_Line;
end;


//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_PSY: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_PSY_NAME], CFNQConst.LINESERIES_PSY, 1, 1, 0);
    f_Line.m_FullName       := g_IndicatorFullName[IND_PSY_NAME];   //'투자심리선(Psychogical Line)';
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_PSY1];  //'투자심리선';
    f_Line.m_LineLabelVisibles[0]       := true;
    f_Line.m_LineLabelNameVisibles[0]   := false;
    f_Line.m_LineColors[0]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineWidths[0]  := 0;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_ROC: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_ROC_NAME], CFNQConst.LINESERIES_ROC, 1, 1, 0);
    f_Line.m_FullName       := g_IndicatorFullName[IND_ROC_NAME];   //'ROC(Price Rate Of Change)';
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_ROC1];  //'ROC';
    f_Line.m_LineTypes[0]   := 0;
    f_Line.m_LineWidths[0]  := 0;
    f_Line.m_LineVisibles[0]        := true;
    f_Line.m_LineLabelVisibles[0]   := true;
    f_Line.m_LineLabelNameVisibles[0] := false;
    f_Line.m_LineColors[0]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_RSI: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_RSI_NAME], CFNQConst.LINESERIES_RSI, 2, 2, 0);
    f_Line.m_FullName       := g_IndicatorFullName[IND_RSI_NAME];   //'RSI(Relative Strength Index)';
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_RSI1];  //'RSI';
    f_Line.m_LineNames[1]   := g_LineName[LINE_NAME_RSI2];  //'RSI-Signal';
    f_Line.m_LineWidths[0]  := 0;
    f_Line.m_LineWidths[1]  := 0;
    f_Line.m_LineColors[0]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[1]  := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]  := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_Samsun: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_SAMSUN_NAME], CFNQConst.LINESERIES_SAMSUN, 5, 0, 0, 0);
    f_Line.m_FullName       := g_IndicatorFullName[IND_SAMSUN_NAME];   //'삼선전환도';
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_SAMSUN1];  //'';
    f_Line.m_LineNames[1]   := g_LineName[LINE_NAME_SAMSUN2];  //'';
    f_Line.m_LineNames[2]   := g_LineName[LINE_NAME_SAMSUN3];  //'';
    f_Line.m_LineNames[3]   := g_LineName[LINE_NAME_SAMSUN4];  //'';
    f_Line.m_LineNames[4]   := g_LineName[LINE_NAME_SAMSUN5];  //'';
    f_Line.m_LineLabelVisibles[0] := false;
    f_Line.m_LineLabelVisibles[1] := false;
    f_Line.m_LineLabelVisibles[2] := false;
    f_Line.m_LineLabelVisibles[3] := false;
    f_Line.m_LineLabelVisibles[4] := false;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_SAR: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_SAR_NAME], CFNQConst.LINESERIES_SAR, 5, 1, 0, 0);
    f_Line.m_FullName               := g_IndicatorFullName[IND_SAR_NAME];   //'Parabolic SAR(Stop and Reversal)';
    f_Line.m_LineNames[3]           := g_LineName[LINE_NAME_SAR4];  //'Parabolic';
    f_Line.m_LineVisibles[0]        := false;
    f_Line.m_LineVisibles[1]        := false;
    f_Line.m_LineVisibles[2]        := false;
    f_Line.m_LineVisibles[3]        := true;
    f_Line.m_LineVisibles[4]        := false;
    f_Line.m_LineLabelVisibles[0]   := false;
    f_Line.m_LineLabelVisibles[1]   := false;
    f_Line.m_LineLabelVisibles[2]   := false;
    f_Line.m_LineLabelVisibles[3]   := true;
    f_Line.m_LineLabelVisibles[4]   := false;
    f_Line.m_LineLabelNameVisibles[0]   := false;
    f_Line.m_LineLabelNameVisibles[1]   := false;
    f_Line.m_LineLabelNameVisibles[2]   := false;
    f_Line.m_LineLabelNameVisibles[3]   := false;
    f_Line.m_LineLabelNameVisibles[4]   := false;
    f_Line.m_Precision          := 2;
    f_Line.m_LineTypes[3]       := 2;
    f_Line.m_LineColors[0]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[1]      := 21;
    f_Line.m_LineColors[2]      := 27;
    f_Line.m_LineColors[3]      := 30;
    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[3]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineWidths[2]      := 0;
    f_Line.m_LineWidths[3]      := 0;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_SlowSTC: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_SLOWSTC_NAME], CFNQConst.LINESERIES_SLOWSTC, 3, 3, 0);
    f_Line.m_FullName       := g_IndicatorFullName[IND_SLOWSTC_NAME];   //'Slow Stochastics';
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_SLOWSTC1];  //'Fast %K';
    f_Line.m_LineNames[1]   := g_LineName[LINE_NAME_SLOWSTC2];  //'Slow %K';
    f_Line.m_LineNames[2]   := g_LineName[LINE_NAME_SLOWSTC3];  //'Slow %D';
    f_Line.m_LineWidths[0]  := 0;
    f_Line.m_LineWidths[1]  := 0;
    f_Line.m_LineWidths[2]  := 0;
    f_Line.m_LineColors[0]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[1]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]  := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineVisibles[0] := false;
    f_Line.m_LineVisibles[1] := true;
    f_Line.m_LineVisibles[2] := true;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_SONAR: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_SONAR_NAME], CFNQConst.LINESERIES_SONAR, 3, 3, 0);
    f_Line.m_FullName           := g_IndicatorFullName[IND_SONAR_NAME];   //'SONAR';
    f_Line.m_LineNames[0]       := g_LineName[LINE_NAME_SONAR1];  //'';
    f_Line.m_LineNames[1]       := g_LineName[LINE_NAME_SONAR2];  //'SONAR';
    f_Line.m_LineNames[2]       := g_LineName[LINE_NAME_SONAR3];  //'MA';
    f_Line.m_LineTypes[0]       := 0;
    f_Line.m_LineTypes[1]       := 0;
    f_Line.m_LineTypes[2]       := 0;
    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineWidths[2]      := 0;
    f_Line.m_LineVisibles[0]    := false;
    f_Line.m_LineVisibles[1]    := true;
    f_Line.m_LineVisibles[2]    := true;
    f_Line.m_LineColors[0]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]      := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

function CFNQLineValueSeriesCreator.Creator_SONARCrossSignal: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('SONAR 돌파매매분석', CFNQConst.LINESERIES_SONA_CROSS_SIGNAL, 4, 3, 0);
    f_Line.m_FullName           := 'SONAR 돌파매매분석';

    f_Line.m_LineNames[1]       := 'SONAR';
    f_Line.m_LineNames[2]       := 'MA';

    f_Line.m_LineTypes[0]       := 4;
    f_Line.m_LineTypes[1]       := 0;
    f_Line.m_LineTypes[2]       := 0;
    f_Line.m_LineTypes[3]       := 0;


    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineWidths[2]      := 0;
    f_Line.m_LineWidths[3]      := 0;

    f_Line.m_LineVisibles[0]    := false;
    f_Line.m_LineVisibles[1]    := true;
    f_Line.m_LineVisibles[2]    := true;
    f_Line.m_LineVisibles[3]    := false;

    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]      := CFNQColorSet.IND_LINE2_COLOR;

    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;


    f_Line.m_Signal := TRUE;

    Result := f_Line;end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_TRIX: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_TRIX_NAME], CFNQConst.LINESERIES_TRIX, 5, 2, 0);
    f_Line.m_FullName           := g_IndicatorFullName[IND_TRIX_NAME];   //'TRIX(Tripple Smoothed Moving Averages)';
    f_Line.m_LineNames[3]       := g_LineName[LINE_NAME_TRIX4];  //'TRIX';
    f_Line.m_LineNames[4]       := g_LineName[LINE_NAME_TRIX5];  //'TRMA';
    f_Line.m_LineTypes[0]       := 0;
    f_Line.m_LineTypes[1]       := 0;
    f_Line.m_LineTypes[2]       := 0;
    f_Line.m_LineTypes[3]       := 0;
    f_Line.m_LineTypes[4]       := 0;
    f_Line.m_LineWidths[3]      := 0;
    f_Line.m_LineWidths[4]      := 0;
    f_Line.m_LineVisibles[0]    := false;
    f_Line.m_LineVisibles[1]    := false;
    f_Line.m_LineVisibles[2]    := false;
    f_Line.m_LineVisibles[3]    := true;
    f_Line.m_LineVisibles[4]    := true;
    f_Line.m_LineColors[0]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[3]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[4]      := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[3]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[4]      := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

function CFNQLineValueSeriesCreator.Creator_TRIXCrossSignal: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('TRIX 돌파매매분석', CFNQConst.LINESERIES_TRIX_CROSS_SIGNAL, 6, 2, 0);
    f_Line.m_FullName           := 'TRIX 돌파매매분석';

    f_Line.m_LineTypes[0]       := 4;
    f_Line.m_LineTypes[1]       := 0;
    f_Line.m_LineTypes[2]       := 0;
    f_Line.m_LineTypes[3]       := 0;
    f_Line.m_LineTypes[4]       := 0;
    f_Line.m_LineTypes[5]       := 0;

    f_Line.m_LineNames[1]       := 'TRIX';
    f_Line.m_LineNames[2]       := 'TRMA';

    f_Line.m_LineVisibles[0]    := false;
    f_Line.m_LineVisibles[1]    := true;
    f_Line.m_LineVisibles[2]    := true;
    f_Line.m_LineVisibles[3]    := false;
    f_Line.m_LineVisibles[4]    := false;
    f_Line.m_LineVisibles[5]    := false;

    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]      := CFNQColorSet.IND_LINE2_COLOR;

    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;


    f_Line.m_Signal := TRUE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_Volume: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_VOLUME_NAME], CFNQConst.LINESERIES_VOLUME, 2, 0, 0);
    f_Line.m_FullName           := g_IndicatorFullName[IND_VOLUME_NAME];   //'거래량';
    f_Line.m_LineNames[0]       := g_LineName[LINE_NAME_VOLUME1];  //'거래량';
    f_Line.m_LineNames[1]       := g_LineName[LINE_NAME_VOLUME2];  //'';
    f_Line.m_LineTypes[0]       := 3;
    f_Line.m_LineTypes[1]       := 3;
    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineVisibles[0]    := true;
    f_Line.m_LineVisibles[1]    := false;
    f_Line.m_LineMaxMinIndexs[0]    := 0;
    f_Line.m_LineMaxMinIndexs[1]    := 0;
    f_Line.m_LineLabelVisibles[0]   := true;
    f_Line.m_LineLabelVisibles[1]   := false;
    f_Line.m_LineLabelNameVisibles[0]   := false;
    f_Line.m_LineLabelNameVisibles[1]   := false;
    f_Line.m_LineColors[0]      := CFNQColorSet.VOLUME_LINE_COLOR;
    f_Line.m_LineColors[1]      := CFNQColorSet.VOLUME_LINE_COLOR;
    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_VR: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_VR_NAME], CFNQConst.LINESERIES_VR, 1, 1, 4);
    f_Line.m_FullName       := g_IndicatorFullName[IND_VR_NAME];   //'VR(Volume Ratio)';
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_VR1];  //'VR';
    f_Line.m_LineVisibles[0]        := true;
    f_Line.m_LineLabelVisibles[0]   := true;
    f_Line.m_LineLabelNameVisibles[0] := false;
    f_Line.m_LineColors[0]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_Values[0]      := 70;
    f_Line.m_Values[1]      := 150;
    f_Line.m_Values[2]      := 200;
    f_Line.m_Values[3]      := 450;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_WilliamsR: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create(g_IndicatorName[IND_WILLIAM_NAME], CFNQConst.LINESERIES_WILLIAM, 2, 2, 0);
    f_Line.m_FullName       := g_IndicatorFullName[IND_WILLIAM_NAME];   //'Williams'' %R';
    f_Line.m_LineNames[0]   := g_LineName[LINE_NAME_WILLIAM1];  //'%R';
    f_Line.m_LineNames[1]   := g_LineName[LINE_NAME_WILLIAM2];  //'%D';
    f_Line.m_LineVisibles[0] := true;
    f_Line.m_LineVisibles[1] := true;
    f_Line.m_LineColors[0]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[1]  := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]  := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

function CFNQLineValueSeriesCreator.Creator_WilliamsRCrossSignal: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('Williams'' %R 돌파매매분석', CFNQConst.LINESERIES_WILLIAMSR_CROSS_SIGNAL, 3, 2, 0);
    f_Line.m_FullName       := 'Williams'' %R 돌파매매분석';

    f_Line.m_LineNames[1]   := '%R';
    f_Line.m_LineNames[2]   := '%D';

    f_Line.m_LineTypes[0]   := 4;
    f_Line.m_LineTypes[1]   := 0;
    f_Line.m_LineTypes[2]   := 0;

    f_Line.m_LineVisibles[0] := false;
    f_Line.m_LineVisibles[1] := true;
    f_Line.m_LineVisibles[2] := true;

    f_Line.m_LineColors[1]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]  := CFNQColorSet.IND_LINE2_COLOR;

    f_Line.m_LineAlphas[1]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]  := CFNQColorSet.ALPHA_DARK_LINE;


    f_Line.m_Signal := TRUE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.ModifyLine_NET(p_LineCount: Integer;
  p_Line: CFNQLineValueSeries): CFNQLineValueSeries;
var
    f_Index     : Integer;
    f_Alpha     : Double;
    f_AlphaIncrese : Double;
begin
    p_Line.SetLineCount(p_LineCount);
    p_Line.m_FullName   := g_IndicatorFullName[IND_NET_NAME];   //'그물차트';
    f_Alpha             := CFNQColorSet.ALPHA_DARK_LINE;
    f_AlphaIncrese      := (CFNQColorSet.ALPHA_DARK_LINE) / p_LineCount;

    for f_Index := 0 to p_LineCount - 1 do
    begin
        p_Line.m_LineNames[f_Index]     := '';
        p_Line.m_LineTypes[f_Index]     := 0;
        p_Line.m_LineWidths[f_Index]    := 0;
        p_Line.m_LineVisibles[f_Index]  := true;
        p_Line.m_LineLabelVisibles[f_Index]     := false;
        p_Line.m_LineLabelNameVisibles[f_Index] := false;
        p_Line.m_LinePosValueVisibles[f_Index]  := false;
        p_Line.m_LineColors[f_Index]    := 40;
        if ((f_Index = 0) or (f_Index = p_LineCount - 1)) then
            p_Line.m_LineAlphas[f_Index] := CFNQColorSet.ALPHA_DARK_LINE
        else
            p_Line.m_LineAlphas[f_Index] := CFNQColorSet.ALPHA_LIGHT_LINE;
    end;

    p_Line.m_LineLabelVisibles[0] := true;

    Result := p_Line;
end;


function CFNQLineValueSeriesCreator.Creator_PRICE_AT_OPS: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('주가', CFNQConst.LINESERIES_PRICE_AT_OPS, 1, 0, 0);
    f_Line.m_FullName       := '주가';
    f_Line.m_LineNames[0]   := '주가';
    f_Line.m_LineTypes[0]   := 0;
    f_Line.m_LineWidths[0]  := 0;
    f_Line.m_LineVisibles[0]        := true;
    f_Line.m_LineLabelVisibles[0]   := true;
    f_Line.m_LineLabelNameVisibles[0] := false;
    f_Line.m_LineColors[0]  := CFNQColorSet.OPS_LINE_OPS;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;

end;

function CFNQLineValueSeriesCreator.Creator_OPS: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('오메가', CFNQConst.LINESERIES_OPS, 1, 0, 0);
    f_Line.m_FullName       := '오메가';
    f_Line.m_LineNames[0]   := '오메가';
    f_Line.m_LineTypes[0]   := 0;
    f_Line.m_LineWidths[0]  := 6;
    f_Line.m_LineVisibles[0]        := true;
    f_Line.m_LineLabelVisibles[0]   := true;
    f_Line.m_LineLabelNameVisibles[0] := false;
    f_Line.m_LineColors[0]  := CFNQColorSet.OPS_LINE_OPS;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;

end;

function CFNQLineValueSeriesCreator.Creator_OPS_IGUK: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('오메가 이격율', CFNQConst.LINESERIES_OPSIGUK, 1, 0, 0);
    f_Line.m_FullName       := '오메가 이격율';
    f_Line.m_LineNames[0]   := '이격율';
    f_Line.m_LineTypes[0]   := 0;
    f_Line.m_LineWidths[0]  := 2;
    f_Line.m_LineVisibles[0]        := true;
    f_Line.m_LineLabelVisibles[0]   := true;
    f_Line.m_LineLabelNameVisibles[0] := false;
    f_Line.m_LineColors[0]  := CFNQColorSet.OPS_LINE_IGUK;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;

end;

function CFNQLineValueSeriesCreator.Creator_OPS_IGUK2: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('오메가2', CFNQConst.LINESERIES_OPSIGUK2, 5, 1, 0);
    f_Line.m_FullName       := '오메가2';
    f_Line.m_LineNames[0]   := '오메가2';
    f_Line.m_LineTypes[0]   := 0;
    f_Line.m_LineTypes[1]   := 0;
    f_Line.m_LineTypes[2]   := 0;
    f_Line.m_LineTypes[3]   := 0;
    f_Line.m_LineTypes[4]   := 0;
    f_Line.m_LineWidths[0]  := 2;
    f_Line.m_LineWidths[1]  := 2;
    f_Line.m_LineWidths[2]  := 2;
    f_Line.m_LineWidths[3]  := 2;
    f_Line.m_LineWidths[4]  := 2;
    f_Line.m_LineVisibles[0]        := true;
    f_Line.m_LineVisibles[1]        := false;
    f_Line.m_LineVisibles[2]        := false;
    f_Line.m_LineVisibles[3]        := false;
    f_Line.m_LineVisibles[4]        := false;
    f_Line.m_LineLabelVisibles[0]   := true;
    f_Line.m_LineLabelVisibles[1]   := false;
    f_Line.m_LineLabelVisibles[2]   := false;
    f_Line.m_LineLabelVisibles[3]   := false;
    f_Line.m_LineLabelVisibles[4]   := false;
    f_Line.m_LineLabelNameVisibles[0] := false;
    f_Line.m_LineLabelNameVisibles[1] := false;
    f_Line.m_LineLabelNameVisibles[2] := false;
    f_Line.m_LineLabelNameVisibles[3] := false;
    f_Line.m_LineLabelNameVisibles[4] := false;
    f_Line.m_LineColors[0]  := CFNQColorSet.OPS_LINE_IGUK2;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;

end;

function CFNQLineValueSeriesCreator.Creator_OPS_STD: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('오메가 표준편차', CFNQConst.LINESERIES_OPSSTDDEV, 3, 1, 0);
    f_Line.m_FullName       := '오메가 표준편차';
    f_Line.m_LineNames[0]   := '표준편차';
    f_Line.m_LineNames[1]   := '';
    f_Line.m_LineNames[2]   := '';
    f_Line.m_LineTypes[0]   := 0;
    f_Line.m_LineTypes[1]   := 0;
    f_Line.m_LineTypes[2]   := 0;
    f_Line.m_LineWidths[0]  := 0;
    f_Line.m_LineWidths[1]  := 0;
    f_Line.m_LineWidths[2]  := 0;
    f_Line.m_LineVisibles[0]        := true;
    f_Line.m_LineVisibles[1]        := false;
    f_Line.m_LineVisibles[2]        := false;
    f_Line.m_LineLabelVisibles[0]   := true;
    f_Line.m_LineLabelNameVisibles[0] := false;
    f_Line.m_LineLabelVisibles[1]   := false;
    f_Line.m_LineLabelVisibles[2]   := false;
    f_Line.m_LineColors[0]  := CFNQColorSet.OPS_LINE_STDDEV;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;

end;

function CFNQLineValueSeriesCreator.Creator_OPS_REL: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('오메가 상관차트', CFNQConst.LINESERIES_OPSREL, 1, 1, 0);
    f_Line.m_FullName       := '오메가 상관차트';
    f_Line.m_LineNames[0]   := '상관계수';
    f_Line.m_LineTypes[0]   := 0;
    f_Line.m_LineWidths[0]  := 2;
    f_Line.m_LineVisibles[0]        := true;
    f_Line.m_LineLabelVisibles[0]   := true;
    f_Line.m_LineLabelNameVisibles[0] := false;
    f_Line.m_LineColors[0]  := CFNQColorSet.OPS_LINE_REL;
    f_Line.m_LineAlphas[0]  := CFNQColorSet.ALPHA_DARK_LINE;

    Result := f_Line;
end;

function CFNQLineValueSeriesCreator.Creator_PriceMACrossSignal: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('주가:이평선 돌파 매매분석', CFNQConst.LINESERIES_PRICE_MA_CROSS_SIGNAL, 3, 1, 0, 0);
    f_Line.m_FullName           := '주가:이평선 돌파 매매분석';

    f_Line.m_LineNames[0]       := '';
    f_Line.m_LineNames[1]       := '주가';
    f_Line.m_LineNames[2]       := '이평';

    f_Line.m_LineTypes[0]       := 4;
    f_Line.m_LineTypes[1]       := 0;
    f_Line.m_LineTypes[2]       := 0;

    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineWidths[2]      := 0;

    f_Line.m_LineVisibles[0]    := false;
    f_Line.m_LineVisibles[1]    := true;
    f_Line.m_LineVisibles[2]    := true;

    f_Line.m_LineColors[0]      := 0;
    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]      := CFNQColorSet.IND_LINE2_COLOR;

    f_Line.m_Precision          := 2;

    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;

    f_Line.m_Signal := TRUE;

    Result := f_Line;
end;


function CFNQLineValueSeriesCreator.Creator_MACDCrossSignal: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('MACD 돌파 매매분석', CFNQConst.LINESERIES_MACD_CROSS_SIGNAL, 5, 3, 0, 2);
    f_Line.m_FullName           := 'MACD 돌파 매매분석';
    f_Line.m_LineNames[0]       := '';
    f_Line.m_LineNames[1]       := 'MACD';
    f_Line.m_LineNames[2]       := 'Sign';

    f_Line.m_LineTypes[0]       := 4;
    f_Line.m_LineTypes[1]       := 0;
    f_Line.m_LineTypes[2]       := 0;

    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineWidths[2]      := 0;
    f_Line.m_LineWidths[3]      := 0;
    f_Line.m_LineWidths[4]      := 0;

    f_Line.m_LineVisibles[0]    := false;
    f_Line.m_LineVisibles[1]    := true;
    f_Line.m_LineVisibles[2]    := true;
    f_Line.m_LineVisibles[3]    := false;
    f_Line.m_LineVisibles[4]    := false;

    f_Line.m_LineColors[0]      := 0;
    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]      := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineColors[3]      := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineColors[4]      := CFNQColorSet.IND_LINE1_COLOR;

    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[3]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[4]      := CFNQColorSet.ALPHA_LIGHT_LINE;

    f_Line.m_Signal := TRUE;

    Result := f_Line;
end;

function CFNQLineValueSeriesCreator.Creator_MACrossSignal: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('이동평균선 돌파 매매분석', CFNQConst.LINESERIES_MA_CROSS_SIGNAL, 3, 2, 0, 0);
    f_Line.m_FullName           := '이동평균선 돌파 매매분석';
    f_Line.m_LineNames[0]       := '';
    f_Line.m_LineNames[1]       := '단기이평';
    f_Line.m_LineNames[2]       := '장기이평';

    f_Line.m_LineTypes[0]       := 4;
    f_Line.m_LineTypes[1]       := 0;
    f_Line.m_LineTypes[2]       := 0;

    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineWidths[2]      := 0;

    f_Line.m_LineVisibles[0]    := false;
    f_Line.m_LineVisibles[1]    := true;
    f_Line.m_LineVisibles[2]    := true;

    f_Line.m_LineColors[0]      := 0;
    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]      := CFNQColorSet.IND_LINE2_COLOR;

    f_Line.m_Precision          := 2;

    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;

    f_Line.m_Signal := TRUE;
    
    Result := f_Line;
end;

function CFNQLineValueSeriesCreator.Creator_SSTCCrossSignal: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('SSTC 돌파매매분석', CFNQConst.LINESERIES_SSTC_CROSS_SIGNAL, 4, 3, 0);
    f_Line.m_FullName       := 'SSTC 돌파매매분석';
    f_Line.m_LineNames[0]   := '';
    f_Line.m_LineNames[1]   := 'Slow %K';
    f_Line.m_LineNames[2]   := 'Slow %D';
    f_Line.m_LineNames[3]   := 'Fast %K';

    f_Line.m_LineTypes[0]       := 4;
    f_Line.m_LineTypes[1]       := 0;
    f_Line.m_LineTypes[2]       := 0;

    f_Line.m_LineWidths[0]  := 0;
    f_Line.m_LineWidths[1]  := 0;
    f_Line.m_LineWidths[2]  := 0;
    f_Line.m_LineWidths[3]  := 0;

    f_Line.m_LineVisibles[0]    := false;
    f_Line.m_LineVisibles[1]    := true;
    f_Line.m_LineVisibles[2]    := true;
    f_Line.m_LineVisibles[3]    := false;

    f_Line.m_LineColors[0]  := 0;
    f_Line.m_LineColors[1]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]  := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineColors[3]  := CFNQColorSet.IND_LINE2_COLOR;

    f_Line.m_LineAlphas[0]  := 0;
    f_Line.m_LineAlphas[1]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[3]  := CFNQColorSet.ALPHA_DARK_LINE;

    f_Line.m_Signal := TRUE;


    Result := f_Line;
end;

function CFNQLineValueSeriesCreator.Creator_FSTCCrossSignal: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('FSTC 돌파매매분석', CFNQConst.LINESERIES_FSTC_CROSS_SIGNAL, 3, 2, 0);
    f_Line.m_FullName       := 'FSTC 돌파매매분석';

    f_Line.m_LineNames[0]   := '';
    f_Line.m_LineNames[1]   := 'Fast %K';
    f_Line.m_LineNames[2]   := 'Fast %D';

    f_Line.m_LineTypes[0]       := 4;
    f_Line.m_LineTypes[1]       := 0;
    f_Line.m_LineTypes[2]       := 0;

    f_Line.m_LineWidths[0]  := 0;
    f_Line.m_LineWidths[1]  := 0;
    f_Line.m_LineWidths[2]  := 0;

    f_Line.m_LineColors[0]  := 0;
    f_Line.m_LineColors[1]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]  := CFNQColorSet.IND_LINE2_COLOR;

    f_Line.m_LineAlphas[0]  := 0;
    f_Line.m_LineAlphas[1]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]  := CFNQColorSet.ALPHA_DARK_LINE;

    f_Line.m_LineVisibles[0] := false;
    f_Line.m_LineVisibles[1] := true;
    f_Line.m_LineVisibles[2] := true;

    f_Line.m_Signal := TRUE;

    Result := f_Line;
end;

//---------------------------------------------------------------------------
function CFNQLineValueSeriesCreator.Creator_RSICrossSignal: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('RSI 돌파매매분석', CFNQConst.LINESERIES_RSI_CROSS_SIGNAL, 3, 2, 0);
    f_Line.m_FullName       := 'RSI 돌파매매분석';

    f_Line.m_LineTypes[0]       := 4;
    f_Line.m_LineTypes[1]       := 0;
    f_Line.m_LineTypes[2]       := 0;

    f_Line.m_LineNames[1]   := 'RSI';
    f_Line.m_LineNames[2]   := 'RSI-Signal';

    f_Line.m_LineWidths[1]  := 0;
    f_Line.m_LineWidths[2]  := 0;

    f_Line.m_LineVisibles[0] := false;
    f_Line.m_LineVisibles[1] := true;
    f_Line.m_LineVisibles[2] := true;

    f_Line.m_LineColors[1]  := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]  := CFNQColorSet.IND_LINE2_COLOR;

    f_Line.m_LineAlphas[1]  := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]  := CFNQColorSet.ALPHA_DARK_LINE;

    f_Line.m_Signal := TRUE;

    Result := f_Line;
end;

function CFNQLineValueSeriesCreator.Creator_ADXCrossSignal: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('ADX 돌파매매분석', CFNQConst.LINESERIES_ADX_CROSS_SIGNAL, 11, 3, 0);
    f_Line.m_FullName           := 'ADX 돌파매매분석';
    f_Line.m_LineNames[1]       := 'ADX';
    f_Line.m_LineNames[2]       := 'MA';

    f_Line.m_LineWidths[1]      := 0;
    f_Line.m_LineWidths[2]      := 0;

    f_Line.m_LineVisibles[0]    := false;
    f_Line.m_LineVisibles[1]    := true;
    f_Line.m_LineVisibles[2]    := true;
    f_Line.m_LineVisibles[3]    := false;
    f_Line.m_LineVisibles[4]    := false;
    f_Line.m_LineVisibles[5]    := false;
    f_Line.m_LineVisibles[6]    := false;
    f_Line.m_LineVisibles[7]    := false;
    f_Line.m_LineVisibles[8]    := false;
    f_Line.m_LineVisibles[9]    := false;
    f_Line.m_LineVisibles[10]   := false;

    f_Line.m_LineTypes[0]       := 4;

    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE1_COLOR;
    f_Line.m_LineColors[2]      := CFNQColorSet.IND_LINE2_COLOR;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[2]      := CFNQColorSet.ALPHA_DARK_LINE;

    f_Line.m_Signal := TRUE;

    Result := f_Line;
end;


function CFNQLineValueSeriesCreator.Creator_NMATrendSignal: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('단순이평선 추세전환 매매분석', CFNQConst.LINESERIES_NMA_TREND_SIGNAL, 2, 1, 0, 0);
    f_Line.m_FullName           := '단순이평선 추세 매매분석';
    f_Line.m_LineNames[0]       := '';
    f_Line.m_LineNames[1]       := '이평';

    f_Line.m_LineTypes[0]       := 4;
    f_Line.m_LineTypes[1]       := 0;

    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;

    f_Line.m_LineVisibles[0]    := false;
    f_Line.m_LineVisibles[1]    := true;

    f_Line.m_LineColors[0]      := 0;
    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE1_COLOR;

    f_Line.m_Precision          := 2;

    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;

    f_Line.m_Signal := TRUE;

    Result := f_Line;
end;


function CFNQLineValueSeriesCreator.Creator_WMATrendSignal: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('가중이평선 추세전환 매매분석', CFNQConst.LINESERIES_WMA_TREND_SIGNAL, 2, 1, 0, 0);
    f_Line.m_FullName           := '가중이평선 추세 매매분석';
    f_Line.m_LineNames[0]       := '';
    f_Line.m_LineNames[1]       := '이평';

    f_Line.m_LineTypes[0]       := 4;
    f_Line.m_LineTypes[1]       := 0;

    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;

    f_Line.m_LineVisibles[0]    := false;
    f_Line.m_LineVisibles[1]    := true;

    f_Line.m_LineColors[0]      := 0;
    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE1_COLOR;

    f_Line.m_Precision          := 2;

    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;

    f_Line.m_Signal := TRUE;

    Result := f_Line;
end;


function CFNQLineValueSeriesCreator.Creator_XMATrendSignal: CFNQLineValueSeries;
var
    f_Line : CFNQLineValueSeries;
begin
    f_Line := CFNQLineValueSeries.Create('지수이평선 추세전환 매매분석', CFNQConst.LINESERIES_XMA_TREND_SIGNAL, 2, 1, 0, 0);
    f_Line.m_FullName           := '지수이평선 추세 매매분석';
    f_Line.m_LineNames[0]       := '';
    f_Line.m_LineNames[1]       := '이평';

    f_Line.m_LineTypes[0]       := 4;
    f_Line.m_LineTypes[1]       := 0;

    f_Line.m_LineWidths[0]      := 0;
    f_Line.m_LineWidths[1]      := 0;

    f_Line.m_LineVisibles[0]    := false;
    f_Line.m_LineVisibles[1]    := true;

    f_Line.m_LineColors[0]      := 0;
    f_Line.m_LineColors[1]      := CFNQColorSet.IND_LINE1_COLOR;

    f_Line.m_Precision          := 2;

    f_Line.m_LineAlphas[0]      := CFNQColorSet.ALPHA_DARK_LINE;
    f_Line.m_LineAlphas[1]      := CFNQColorSet.ALPHA_DARK_LINE;

    f_Line.m_Signal := TRUE;

    Result := f_Line;
end;
end.
