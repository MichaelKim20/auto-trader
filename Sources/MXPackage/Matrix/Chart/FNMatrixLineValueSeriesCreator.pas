unit FNMatrixLineValueSeriesCreator;

interface

uses
  SysUtils,
  FNMatrixLineValueSeries, MKStreamChartDataSeries, FNMatrixConst,
  FNMatrixColorSet;

function Creator_Price: CFNMatrixLineValueSeries;
function Creator_WMA: CFNMatrixLineValueSeries;
function Creator_SignalLineSeries: CFNMatrixLineValueSeries;
function Creator_MergeSeries: CFNMatrixLineValueSeries;

function Creator_MatrixSeries: CFNMatrixLineValueSeries;
function Creator_MatrixVolumeSeries: CFNMatrixLineValueSeries;

implementation

uses
  FNGlobal, FNMatrixChartDefine;

// ---------------------------------------------------------------------------
function Creator_Price: CFNMatrixLineValueSeries;
var
  f_Line: CFNMatrixLineValueSeries;
begin
  f_Line := CFNMatrixLineValueSeries.Create(g_IndicatorName[IND_PRICE_NAME], CFNMatrixConst.LINESERIES_PRICE, 5, 1, 0, 0);

  f_Line.m_ViewLabel := false;

  f_Line.m_LineNames[0] := g_LineName[LINE_NAME_PRICE1]; // '시가';
  f_Line.m_LineNames[1] := g_LineName[LINE_NAME_PRICE2]; // '고가';
  f_Line.m_LineNames[2] := g_LineName[LINE_NAME_PRICE3]; // '저가';
  f_Line.m_LineNames[3] := g_LineName[LINE_NAME_PRICE4]; // '종가';

  f_Line.m_LineColors[0] := CFNMatrixColorSet.PRICE_COLOR;
  f_Line.m_LineColors[1] := CFNMatrixColorSet.PRICE_COLOR;
  f_Line.m_LineColors[2] := CFNMatrixColorSet.PRICE_COLOR;
  f_Line.m_LineColors[3] := CFNMatrixColorSet.PRICE_COLOR;

  f_Line.m_LastValueVisible := true;
  f_Line.m_LineLastValueVisibles[0] := true;
  f_Line.m_LineLastValueVisibles[1] := false;
  f_Line.m_LineLastValueVisibles[2] := false;
  f_Line.m_LineLastValueVisibles[3] := false;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
function Creator_WMA: CFNMatrixLineValueSeries;
var
  f_Line: CFNMatrixLineValueSeries;
begin
  f_Line := CFNMatrixLineValueSeries.Create('이동평균선', CFNMatrixConst.LINESERIES_MA, 1, 1, 0, 0);
  f_Line.m_FullName := '이동평균선';

  f_Line.m_ViewLabel := false;

  f_Line.m_LineNames[0] := 'WMA';

  f_Line.m_LineTypes[0] := 0;
  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineColors[0] := 30;
  f_Line.m_LineAlphas[0] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_Precision := 4;
  Result := f_Line;
end;

// ---------------------------------------------------------------------------
function Creator_SignalLineSeries: CFNMatrixLineValueSeries;
var
  f_Line: CFNMatrixLineValueSeries;
begin
  f_Line := CFNMatrixLineValueSeries.Create('System', CFNMatrixConst.LINESERIES_WMA_TREND_SIGNAL, 3, 1, 0, 1);

  f_Line.m_FullName := 'System';

  f_Line.m_LineNames[M_X_SIGNAL] := '';
  f_Line.m_LineNames[M_X_REALPRICE] := '';
  f_Line.m_LineNames[M_X_SIGNAL_TP] := 'P/L';

  f_Line.m_LineTypes[M_X_SIGNAL] := 4;
  f_Line.m_LineTypes[M_X_REALPRICE] := 0;
  f_Line.m_LineTypes[M_X_SIGNAL_TP] := 0;

  f_Line.m_LineWidths[M_X_SIGNAL] := 0;
  f_Line.m_LineWidths[M_X_REALPRICE] := 0;
  f_Line.m_LineWidths[M_X_SIGNAL_TP] := 0;

  f_Line.m_LineLabelVisibles[M_X_SIGNAL] := false;
  f_Line.m_LineLabelVisibles[M_X_REALPRICE] := false;
  f_Line.m_LineLabelVisibles[M_X_SIGNAL_TP] := true;

  f_Line.m_LineLabelNameVisibles[M_X_SIGNAL] := false;
  f_Line.m_LineLabelNameVisibles[M_X_REALPRICE] := false;
  f_Line.m_LineLabelNameVisibles[M_X_SIGNAL_TP] := true;

  f_Line.m_LineVisibles[M_X_SIGNAL] := true;
  f_Line.m_LineVisibles[M_X_REALPRICE] := false;
  f_Line.m_LineVisibles[M_X_SIGNAL_TP] := true;

  f_Line.m_LineColors[M_X_SIGNAL] := 0;
  f_Line.m_LineColors[M_X_REALPRICE] := 0;
  f_Line.m_LineColors[M_X_SIGNAL_TP] := 0;

  f_Line.m_LineAlphas[M_X_SIGNAL] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_X_REALPRICE] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_X_SIGNAL_TP] := CFNMatrixColorSet.ALPHA_DARK_LINE;

  f_Line.m_LineLastValueVisibles[M_X_SIGNAL] := false;
  f_Line.m_LineLastValueVisibles[M_X_REALPRICE] := false;
  f_Line.m_LineLastValueVisibles[M_X_SIGNAL_TP] := true;

  f_Line.m_Signal := true;
  f_Line.m_Precision := 4;
  f_Line.m_LastValueVisible := true;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
function Creator_MergeSeries: CFNMatrixLineValueSeries;
var
  f_Line: CFNMatrixLineValueSeries;
begin
  f_Line := CFNMatrixLineValueSeries.Create('Merge', CFNMatrixConst.LINESERIES_WMA_TREND_SIGNAL, 14, 0, 0, 1);
  f_Line.m_FullName := 'Merge';
  f_Line.m_LineNames[M_MERGE_LINE_SYSTEMNO] := '';
  f_Line.m_LineNames[M_MERGE_LINE_REALPRICE] := '';
  f_Line.m_LineNames[M_MERGE_LINE_VOLUME] := '';
  f_Line.m_LineNames[M_MERGE_LINE_SIGNAL1] := '';
  f_Line.m_LineNames[M_MERGE_LINE_PROFIT1] := 'P/L';
  f_Line.m_LineNames[M_MERGE_LINE_SIGNAL2] := '';
  f_Line.m_LineNames[M_MERGE_LINE_PROFIT2] := '';
  f_Line.m_LineNames[M_MERGE_LINE_PROFIT1_STOP] := '';
  f_Line.m_LineNames[M_MERGE_LINE_SIGNAL3] := '';
  f_Line.m_LineNames[M_MERGE_LINE_PROFIT3] := 'Final P/L';

  f_Line.m_LineTypes[M_MERGE_LINE_SYSTEMNO] := 0;
  f_Line.m_LineTypes[M_MERGE_LINE_REALPRICE] := 0;
  f_Line.m_LineTypes[M_MERGE_LINE_VOLUME] := 0;
  f_Line.m_LineTypes[M_MERGE_LINE_SIGNAL1] := 4;
  f_Line.m_LineTypes[M_MERGE_LINE_PROFIT1] := 0;
  f_Line.m_LineTypes[M_MERGE_LINE_SIGNAL2] := 4;
  f_Line.m_LineTypes[M_MERGE_LINE_PROFIT2] := 0;
  f_Line.m_LineTypes[M_MERGE_LINE_SIGNAL3] := 4;
  f_Line.m_LineTypes[M_MERGE_LINE_PROFIT3] := 0;

  f_Line.m_LineLabelVisibles[M_MERGE_LINE_SYSTEMNO] := false;
  f_Line.m_LineLabelVisibles[M_MERGE_LINE_HIGHPRICE] := false;
  f_Line.m_LineLabelVisibles[M_MERGE_LINE_LOWPRICE] := false;
  f_Line.m_LineLabelVisibles[M_MERGE_LINE_REALPRICE] := false;
  f_Line.m_LineLabelVisibles[M_MERGE_LINE_VOLUME] := false;
  f_Line.m_LineLabelVisibles[M_MERGE_LINE_SIGNAL1] := false;
  f_Line.m_LineLabelVisibles[M_MERGE_LINE_PROFIT1] := false;
  f_Line.m_LineLabelVisibles[M_MERGE_LINE_PROFIT1_H] := false;
  f_Line.m_LineLabelVisibles[M_MERGE_LINE_PROFIT1_L] := false;
  f_Line.m_LineLabelVisibles[M_MERGE_LINE_SIGNAL2] := false;
  f_Line.m_LineLabelVisibles[M_MERGE_LINE_PROFIT2] := false;
  f_Line.m_LineLabelVisibles[M_MERGE_LINE_SIGNAL3] := false;
  f_Line.m_LineLabelVisibles[M_MERGE_LINE_PROFIT3] := false;

  f_Line.m_LineLabelNameVisibles[M_MERGE_LINE_SYSTEMNO] := false;
  f_Line.m_LineLabelNameVisibles[M_MERGE_LINE_REALPRICE] := false;
  f_Line.m_LineLabelNameVisibles[M_MERGE_LINE_SIGNAL1] := false;
  f_Line.m_LineLabelNameVisibles[M_MERGE_LINE_PROFIT1] := false;
  f_Line.m_LineLabelNameVisibles[M_MERGE_LINE_SIGNAL2] := false;
  f_Line.m_LineLabelNameVisibles[M_MERGE_LINE_PROFIT2] := false;
  f_Line.m_LineLabelNameVisibles[M_MERGE_LINE_SIGNAL3] := false;
  f_Line.m_LineLabelNameVisibles[M_MERGE_LINE_PROFIT3] := true;

  f_Line.m_LineVisibles[M_MERGE_LINE_SYSTEMNO] := false;
  f_Line.m_LineVisibles[M_MERGE_LINE_HIGHPRICE] := false;
  f_Line.m_LineVisibles[M_MERGE_LINE_LOWPRICE] := false;
  f_Line.m_LineVisibles[M_MERGE_LINE_REALPRICE] := false;
  f_Line.m_LineVisibles[M_MERGE_LINE_VOLUME] := false;
  f_Line.m_LineVisibles[M_MERGE_LINE_SIGNAL1] := true;
  f_Line.m_LineVisibles[M_MERGE_LINE_PROFIT1] := false;
  f_Line.m_LineVisibles[M_MERGE_LINE_PROFIT1_H] := false;
  f_Line.m_LineVisibles[M_MERGE_LINE_PROFIT1_L] := false;
  f_Line.m_LineVisibles[M_MERGE_LINE_SIGNAL2] := true;
  f_Line.m_LineVisibles[M_MERGE_LINE_PROFIT2] := false;
  f_Line.m_LineVisibles[M_MERGE_LINE_PROFIT1_STOP] := false;
  f_Line.m_LineVisibles[M_MERGE_LINE_SIGNAL3] := true;
  f_Line.m_LineVisibles[M_MERGE_LINE_PROFIT3] := true;

  f_Line.m_LineColors[M_MERGE_LINE_SYSTEMNO] := 0;
  f_Line.m_LineColors[M_MERGE_LINE_REALPRICE] := 0;
  f_Line.m_LineColors[M_MERGE_LINE_VOLUME] := 0;
  f_Line.m_LineColors[M_MERGE_LINE_SIGNAL1] := 0;
  f_Line.m_LineColors[M_MERGE_LINE_PROFIT1] := CFNMatrixColorSet.IND_LINE3_COLOR;
  f_Line.m_LineColors[M_MERGE_LINE_SIGNAL2] := 0;
  f_Line.m_LineColors[M_MERGE_LINE_PROFIT2] := CFNMatrixColorSet.IND_LINE3_COLOR;
  f_Line.m_LineColors[M_MERGE_LINE_SIGNAL3] := 0;
  f_Line.m_LineColors[M_MERGE_LINE_PROFIT3] := CFNMatrixColorSet.IND_LINE3_COLOR;

  f_Line.m_LineMaxMinIndexs[M_MERGE_LINE_SYSTEMNO] := 0;
  f_Line.m_LineMaxMinIndexs[M_MERGE_LINE_REALPRICE] := 0;
  f_Line.m_LineMaxMinIndexs[M_MERGE_LINE_VOLUME] := 0;
  f_Line.m_LineMaxMinIndexs[M_MERGE_LINE_SIGNAL1] := 0;
  f_Line.m_LineMaxMinIndexs[M_MERGE_LINE_PROFIT1] := 0;
  f_Line.m_LineMaxMinIndexs[M_MERGE_LINE_SIGNAL2] := 0;
  f_Line.m_LineMaxMinIndexs[M_MERGE_LINE_PROFIT2] := 0;
  f_Line.m_LineMaxMinIndexs[M_MERGE_LINE_SIGNAL3] := 0;
  f_Line.m_LineMaxMinIndexs[M_MERGE_LINE_PROFIT3] := 0;

  f_Line.m_Precision := 3;

  f_Line.m_LineAlphas[M_MERGE_LINE_SYSTEMNO] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MERGE_LINE_REALPRICE] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MERGE_LINE_VOLUME] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MERGE_LINE_SIGNAL1] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MERGE_LINE_PROFIT1] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MERGE_LINE_SIGNAL2] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MERGE_LINE_PROFIT2] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MERGE_LINE_SIGNAL3] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MERGE_LINE_PROFIT3] := CFNMatrixColorSet.ALPHA_DARK_LINE;

  f_Line.m_Signal := true;

  f_Line.m_LastValueVisible := true;
  f_Line.m_LineLastValueVisibles[M_MERGE_LINE_SYSTEMNO] := false;
  f_Line.m_LineLastValueVisibles[M_MERGE_LINE_REALPRICE] := false;
  f_Line.m_LineLastValueVisibles[M_MERGE_LINE_SIGNAL1] := false;
  f_Line.m_LineLastValueVisibles[M_MERGE_LINE_PROFIT1] := false;
  f_Line.m_LineLastValueVisibles[M_MERGE_LINE_SIGNAL2] := false;
  f_Line.m_LineLastValueVisibles[M_MERGE_LINE_PROFIT2] := false;
  f_Line.m_LineLastValueVisibles[M_MERGE_LINE_SIGNAL3] := false;
  f_Line.m_LineLastValueVisibles[M_MERGE_LINE_PROFIT3] := true;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
function Creator_MatrixSeries: CFNMatrixLineValueSeries;
var
  f_Line: CFNMatrixLineValueSeries;
begin
  f_Line := CFNMatrixLineValueSeries.Create('전체수익곡선', CFNMatrixConst.LINESERIES_MATRIX, 23, 0, 1);
  f_Line.m_FullName := '전체수익곡선';

  f_Line.m_LineVisibles[M_MATRIX_LINE_REALPRICE] := false;
  f_Line.m_LineVisibles[M_MATRIX_LINE_VALUE] := true;
  f_Line.m_LineVisibles[M_MATRIX_LINE_MAXVALUE] := false;
  f_Line.m_LineVisibles[M_MATRIX_LINE_TR_INDEX] := false;
  f_Line.m_LineVisibles[M_MATRIX_LINE_TR_ENTER_VALUE] := false;
  f_Line.m_LineVisibles[M_MATRIX_LINE_TR_EXIT_VALUE] := false;
  f_Line.m_LineVisibles[M_MATRIX_LINE_TR_VALUE] := false;
  f_Line.m_LineVisibles[M_MATRIX_LINE_TR_MAXVALUE] := false;
  f_Line.m_LineVisibles[M_MATRIX_LINE_TR_EXITI_NDEX] := false;
  f_Line.m_LineVisibles[M_MATRIX_LINE_TR_STOP_TYPE] := false;
  f_Line.m_LineVisibles[M_MATRIX_LINE_FINALVALUE] := true;
  f_Line.m_LineVisibles[M_MATRIX_LINE_ENTERSTEP] := false;
  f_Line.m_LineVisibles[M_MATRIX_LINE_NOTR_LOWESTVALUE] := false;
  f_Line.m_LineVisibles[M_MATRIX_LINE_INTERVALUE1] := false;
  f_Line.m_LineVisibles[M_MATRIX_LINE_TRADE_STOP] := false;
  f_Line.m_LineVisibles[M_MATRIX_LINE_VALUE_MA0] := true;
  f_Line.m_LineVisibles[M_MATRIX_LINE_VALUE_MA1] := true;
  f_Line.m_LineVisibles[M_MATRIX_LINE_VALUE_MA2] := true;
  f_Line.m_LineVisibles[M_MATRIX_LINE_CANTRADE01] := true;
  f_Line.m_LineVisibles[M_MATRIX_LINE_CANTRADE02] := true;
  f_Line.m_LineVisibles[M_MATRIX_LINE_CANTRADE03] := true;

  f_Line.m_LineVisibles[M_MATRIX_LINE_TR_EXIT_VALUE03] := false;
  f_Line.m_LineVisibles[M_MATRIX_LINE_TR_VALUE03] := false;

  f_Line.m_LineNames[M_MATRIX_LINE_REALPRICE] := '';
  f_Line.m_LineNames[M_MATRIX_LINE_VALUE] := '관리전수익';
  f_Line.m_LineNames[M_MATRIX_LINE_MAXVALUE] := '';
  f_Line.m_LineNames[M_MATRIX_LINE_TR_INDEX] := '';
  f_Line.m_LineNames[M_MATRIX_LINE_TR_ENTER_VALUE] := '';
  f_Line.m_LineNames[M_MATRIX_LINE_TR_EXIT_VALUE] := '';
  f_Line.m_LineNames[M_MATRIX_LINE_TR_VALUE] := '매매구간내수익';
  f_Line.m_LineNames[M_MATRIX_LINE_TR_MAXVALUE] := '매매구간내최대수익';
  f_Line.m_LineNames[M_MATRIX_LINE_TR_STOP_TYPE] := '';
  f_Line.m_LineNames[M_MATRIX_LINE_FINALVALUE] := '관리후수익';
  f_Line.m_LineNames[M_MATRIX_LINE_CANTRADE01] := '';
  f_Line.m_LineNames[M_MATRIX_LINE_CANTRADE02] := '';
  f_Line.m_LineNames[M_MATRIX_LINE_ENTERSTEP] := '';
  f_Line.m_LineNames[M_MATRIX_LINE_VALUE_MA0] := '';
  f_Line.m_LineNames[M_MATRIX_LINE_VALUE_MA1] := '';
  f_Line.m_LineNames[M_MATRIX_LINE_VALUE_MA2] := '';

  f_Line.m_LineTypes[M_MATRIX_LINE_REALPRICE] := 0;
  f_Line.m_LineTypes[M_MATRIX_LINE_VALUE] := 0;
  f_Line.m_LineTypes[M_MATRIX_LINE_MAXVALUE] := 0;
  f_Line.m_LineTypes[M_MATRIX_LINE_TR_INDEX] := 0;
  f_Line.m_LineTypes[M_MATRIX_LINE_TR_ENTER_VALUE] := 0;
  f_Line.m_LineTypes[M_MATRIX_LINE_TR_EXIT_VALUE] := 0;
  f_Line.m_LineTypes[M_MATRIX_LINE_TR_VALUE] := 0;
  f_Line.m_LineTypes[M_MATRIX_LINE_TR_MAXVALUE] := 0;
  f_Line.m_LineTypes[M_MATRIX_LINE_TR_STOP_TYPE] := 0;
  f_Line.m_LineTypes[M_MATRIX_LINE_FINALVALUE] := 0;
  f_Line.m_LineTypes[M_MATRIX_LINE_CANTRADE01] := 4;
  f_Line.m_LineTypes[M_MATRIX_LINE_CANTRADE02] := 4;
  f_Line.m_LineTypes[M_MATRIX_LINE_CANTRADE03] := 4;
  f_Line.m_LineTypes[M_MATRIX_LINE_VALUE_MA0] := 0;
  f_Line.m_LineTypes[M_MATRIX_LINE_VALUE_MA1] := 0;
  f_Line.m_LineTypes[M_MATRIX_LINE_VALUE_MA2] := 0;

  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_REALPRICE] := false;
  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_VALUE] := true;
  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_MAXVALUE] := false;
  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_TR_INDEX] := false;
  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_TR_ENTER_VALUE] := false;
  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_TR_EXIT_VALUE] := false;
  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_TR_VALUE] := false;
  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_TR_MAXVALUE] := false;
  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_TR_STOP_TYPE] := false;
  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_FINALVALUE] := true;
  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_CANTRADE01] := false;
  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_CANTRADE02] := false;
  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_VALUE_MA0] := true;
  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_VALUE_MA1] := true;
  f_Line.m_LineLabelVisibles[M_MATRIX_LINE_VALUE_MA2] := true;

  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_REALPRICE] := false;
  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_VALUE] := false;
  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_MAXVALUE] := false;
  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_TR_INDEX] := false;
  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_TR_ENTER_VALUE] := false;
  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_TR_EXIT_VALUE] := false;
  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_TR_VALUE] := false;
  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_TR_MAXVALUE] := false;
  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_TR_STOP_TYPE] := false;
  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_FINALVALUE] := false;
  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_CANTRADE01] := false;
  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_CANTRADE02] := false;
  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_VALUE_MA0] := false;
  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_VALUE_MA1] := false;
  f_Line.m_LineLabelNameVisibles[M_MATRIX_LINE_VALUE_MA2] := false;

  f_Line.m_LineColors[M_MATRIX_LINE_REALPRICE] := CFNMatrixColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[M_MATRIX_LINE_VALUE] := CFNMatrixColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[M_MATRIX_LINE_TR_INDEX] := CFNMatrixColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[M_MATRIX_LINE_TR_ENTER_VALUE] := CFNMatrixColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[M_MATRIX_LINE_TR_EXIT_VALUE] := CFNMatrixColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[M_MATRIX_LINE_TR_VALUE] := CFNMatrixColorSet.IND_LINE2_COLOR;
  f_Line.m_LineColors[M_MATRIX_LINE_TR_MAXVALUE] := CFNMatrixColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[M_MATRIX_LINE_FINALVALUE] := CFNMatrixColorSet.IND_LINE3_COLOR;
  f_Line.m_LineColors[M_MATRIX_LINE_CANTRADE01] := CFNMatrixColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[M_MATRIX_LINE_CANTRADE02] := CFNMatrixColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[M_MATRIX_LINE_MAXVALUE] := CFNMatrixColorSet.IND_LINE1_COLOR;
  f_Line.m_LineColors[M_MATRIX_LINE_VALUE_MA0] := CFNMatrixColorSet.IND_LINE4_COLOR;
  f_Line.m_LineColors[M_MATRIX_LINE_VALUE_MA1] := CFNMatrixColorSet.IND_LINE4_COLOR;
  f_Line.m_LineColors[M_MATRIX_LINE_VALUE_MA2] := CFNMatrixColorSet.IND_LINE5_COLOR;

  f_Line.m_LineAlphas[M_MATRIX_LINE_REALPRICE] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MATRIX_LINE_VALUE] := CFNMatrixColorSet.ALPHA_LIGHT_LINE;
  f_Line.m_LineAlphas[M_MATRIX_LINE_TR_INDEX] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MATRIX_LINE_TR_ENTER_VALUE] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MATRIX_LINE_TR_EXIT_VALUE] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MATRIX_LINE_TR_VALUE] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MATRIX_LINE_TR_MAXVALUE] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MATRIX_LINE_FINALVALUE] := CFNMatrixColorSet.ALPHA_LIGHT_LINE;
  f_Line.m_LineAlphas[M_MATRIX_LINE_CANTRADE01] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MATRIX_LINE_CANTRADE02] := CFNMatrixColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[M_MATRIX_LINE_VALUE_MA0] := CFNMatrixColorSet.ALPHA_LIGHT_LINE;
  f_Line.m_LineAlphas[M_MATRIX_LINE_VALUE_MA1] := CFNMatrixColorSet.ALPHA_LIGHT_LINE;
  f_Line.m_LineAlphas[M_MATRIX_LINE_VALUE_MA2] := CFNMatrixColorSet.ALPHA_LIGHT_LINE;

  f_Line.m_Signal := true;

  f_Line.m_LastValueVisible := true;
  f_Line.m_LineLastValueVisibles[M_MATRIX_LINE_REALPRICE] := false;
  f_Line.m_LineLastValueVisibles[M_MATRIX_LINE_VALUE] := false;
  f_Line.m_LineLastValueVisibles[M_MATRIX_LINE_TR_INDEX] := false;
  f_Line.m_LineLastValueVisibles[M_MATRIX_LINE_TR_ENTER_VALUE] := false;
  f_Line.m_LineLastValueVisibles[M_MATRIX_LINE_TR_EXIT_VALUE] := false;
  f_Line.m_LineLastValueVisibles[M_MATRIX_LINE_TR_VALUE] := false;
  f_Line.m_LineLastValueVisibles[M_MATRIX_LINE_TR_MAXVALUE] := false;
  f_Line.m_LineLastValueVisibles[M_MATRIX_LINE_FINALVALUE] := true;
  f_Line.m_LineLastValueVisibles[M_MATRIX_LINE_CANTRADE01] := false;
  f_Line.m_LineLastValueVisibles[M_MATRIX_LINE_CANTRADE02] := false;

  f_Line.m_Values[0] := 0;
  f_Line.m_Precision := 1;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
function Creator_MatrixVolumeSeries: CFNMatrixLineValueSeries;
var
  f_Line: CFNMatrixLineValueSeries;
begin
  f_Line := CFNMatrixLineValueSeries.Create(g_IndicatorName[IND_VOLUME_NAME], CFNMatrixConst.LINESERIES_VOLUME, 1, 0, 0, 0);
  f_Line.m_FullName := '거래량';

  f_Line.m_ViewLabel := true;
  f_Line.m_LineNames[0] := '';
  f_Line.m_LineColors[0] := CFNMatrixColorSet.PRICE_COLOR;
  f_Line.m_LineLabelVisibles[0] := false;
  f_Line.m_LastValueVisible := true;
  f_Line.m_LineLastValueVisibles[0] := true;
  f_Line.m_Precision := 0;

  Result := f_Line;
end;

// ---------------------------------------------------------------------------
end.
