unit FNNAVAnalLineValueSeriesCreator;

interface

uses
  SysUtils,
  FNNAVAnalLineValueSeries, FNNAVAnalChartDataSeries, FNNAVAnalConst,
  FNNAVAnalColorSet;

function Creator_NAV: CFNNAVAnalLineValueSeries;
function Creator_DrawDown: CFNNAVAnalLineValueSeries;

implementation

uses
  FNGlobal, FNNAVAnalChartDefine;

// ---------------------------------------------------------------------------
function Creator_NAV: CFNNAVAnalLineValueSeries;
var
  f_Line: CFNNAVAnalLineValueSeries;
begin
  f_Line := CFNNAVAnalLineValueSeries.Create('수익곡선', CFNNAVAnalConst.LINESERIES_NAV, 34, 0, 0, 0);

  f_Line.m_LineNames[NAV_TPROFIT] := '전체';
  f_Line.m_LineNames[NAV_TPROFIT2] := '전체 신규';
  f_Line.m_LineNames[NAV_BPROFIT] := '매수';
  f_Line.m_LineNames[NAV_BPROFIT_MA1] := '매수 1차이평';
  f_Line.m_LineNames[NAV_BPROFIT_MA2] := '매수 2차이평';
  f_Line.m_LineNames[NAV_BPROFIT_MA3] := '매수 3차이평';
  f_Line.m_LineNames[NAV_BPROFIT2] := '매수 신규';
  f_Line.m_LineNames[NAV_SPROFIT] := '매도';
  f_Line.m_LineNames[NAV_SPROFIT_MA1] := '매도 1차이평';
  f_Line.m_LineNames[NAV_SPROFIT_MA2] := '매도 2차이평';
  f_Line.m_LineNames[NAV_SPROFIT_MA3] := '매도 3차이평';
  f_Line.m_LineNames[NAV_SPROFIT2] := '매도 신규';

  f_Line.m_LineColors[NAV_TPROFIT] := 30;
  f_Line.m_LineColors[NAV_TPROFIT2] := 30;
  f_Line.m_LineColors[NAV_BPROFIT] := 31;
  f_Line.m_LineColors[NAV_BPROFIT_MA3] := 40;
  f_Line.m_LineColors[NAV_BPROFIT2] := 31;
  f_Line.m_LineColors[NAV_SPROFIT] := 32;
  f_Line.m_LineColors[NAV_SPROFIT_MA3] := 40;
  f_Line.m_LineColors[NAV_SPROFIT2] := 32;

  f_Line.m_LineVisibles[NAV_TPROFIT] := true;
  f_Line.m_LineVisibles[NAV_TPROFIT2] := true;
  f_Line.m_LineVisibles[NAV_TDRAWDOWN1] := false;
  f_Line.m_LineVisibles[NAV_TDRAWDOWN2] := false;
  f_Line.m_LineVisibles[NAV_TDRAWDOWN1MA1] := false;
  f_Line.m_LineVisibles[NAV_TDRAWDOWN1MA2] := false;
  f_Line.m_LineVisibles[NAV_TDRAWDOWN1MA3] := false;

  f_Line.m_LineVisibles[NAV_BPROFIT] := true;
  f_Line.m_LineVisibles[NAV_BPROFIT_MA1] := false;
  f_Line.m_LineVisibles[NAV_BPROFIT_MA2] := false;
  f_Line.m_LineVisibles[NAV_BPROFIT_MA3] := true;
  f_Line.m_LineVisibles[NAV_BPROFIT_ENAVLE] := false;
  f_Line.m_LineVisibles[NAV_BPROFIT2] := true;
  f_Line.m_LineVisibles[NAV_BDRAWDOWN1] := false;
  f_Line.m_LineVisibles[NAV_BDRAWDOWN2] := false;
  f_Line.m_LineVisibles[NAV_BDRAWDOWN1MA1] := false;
  f_Line.m_LineVisibles[NAV_BDRAWDOWN1MA2] := false;
  f_Line.m_LineVisibles[NAV_BDRAWDOWN1MA3] := false;

  f_Line.m_LineVisibles[NAV_SPROFIT] := true;
  f_Line.m_LineVisibles[NAV_SPROFIT_MA1] := false;
  f_Line.m_LineVisibles[NAV_SPROFIT_MA2] := false;
  f_Line.m_LineVisibles[NAV_SPROFIT_MA3] := true;
  f_Line.m_LineVisibles[NAV_SPROFIT_ENAVLE] := false;
  f_Line.m_LineVisibles[NAV_SPROFIT2] := true;
  f_Line.m_LineVisibles[NAV_SDRAWDOWN1] := false;
  f_Line.m_LineVisibles[NAV_SDRAWDOWN2] := false;
  f_Line.m_LineVisibles[NAV_SDRAWDOWN1MA1] := false;
  f_Line.m_LineVisibles[NAV_SDRAWDOWN1MA2] := false;
  f_Line.m_LineVisibles[NAV_SDRAWDOWN1MA3] := false;

  f_Line.m_LineVisibles[NAV_BPROFIT_NMA1] := false;
  f_Line.m_LineVisibles[NAV_BPROFIT_STDDEV] := false;
  f_Line.m_LineVisibles[NAV_BPROFIT_LOWLINE] := true;

  f_Line.m_LineAlphas[NAV_TPROFIT] := CFNNAVAnalColorSet.ALPHA_LIGHT_LINE;
  f_Line.m_LineAlphas[NAV_TPROFIT2] := CFNNAVAnalColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[NAV_BPROFIT] := CFNNAVAnalColorSet.ALPHA_LIGHT_LINE;
  f_Line.m_LineAlphas[NAV_BPROFIT_MA3] := CFNNAVAnalColorSet.ALPHA_LIGHT_LINE;
  f_Line.m_LineAlphas[NAV_BPROFIT2] := CFNNAVAnalColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[NAV_SPROFIT] := CFNNAVAnalColorSet.ALPHA_LIGHT_LINE;
  f_Line.m_LineAlphas[NAV_SPROFIT_MA3] := CFNNAVAnalColorSet.ALPHA_LIGHT_LINE;
  f_Line.m_LineAlphas[NAV_SPROFIT2] := CFNNAVAnalColorSet.ALPHA_DARK_LINE;

  f_Line.m_LineLabelVisibles[NAV_TPROFIT] := false;
  f_Line.m_LineLabelVisibles[NAV_TPROFIT2] := true;
  f_Line.m_LineLabelVisibles[NAV_BPROFIT] := false;
  f_Line.m_LineLabelVisibles[NAV_BPROFIT_MA1] := false;
  f_Line.m_LineLabelVisibles[NAV_BPROFIT_MA2] := false;
  f_Line.m_LineLabelVisibles[NAV_BPROFIT_MA3] := false;
  f_Line.m_LineLabelVisibles[NAV_BPROFIT2] := true;
  f_Line.m_LineLabelVisibles[NAV_SPROFIT] := false;
  f_Line.m_LineLabelVisibles[NAV_SPROFIT_MA1] := false;
  f_Line.m_LineLabelVisibles[NAV_SPROFIT_MA2] := false;
  f_Line.m_LineLabelVisibles[NAV_SPROFIT_MA3] := false;
  f_Line.m_LineLabelVisibles[NAV_SPROFIT2] := true;

  f_Line.m_LastValueVisible := true;
  f_Line.m_LineLastValueVisibles[NAV_TPROFIT] := true;
  f_Line.m_LineLastValueVisibles[NAV_TPROFIT2] := true;
  f_Line.m_LineLastValueVisibles[NAV_BPROFIT] := true;
  f_Line.m_LineLastValueVisibles[NAV_BPROFIT_MA1] := false;
  f_Line.m_LineLastValueVisibles[NAV_BPROFIT_MA2] := false;
  f_Line.m_LineLastValueVisibles[NAV_BPROFIT_MA3] := false;
  f_Line.m_LineLastValueVisibles[NAV_BPROFIT2] := true;
  f_Line.m_LineLastValueVisibles[NAV_SPROFIT] := true;
  f_Line.m_LineLastValueVisibles[NAV_SPROFIT_MA1] := false;
  f_Line.m_LineLastValueVisibles[NAV_SPROFIT_MA2] := false;
  f_Line.m_LineLastValueVisibles[NAV_SPROFIT_MA3] := false;
  f_Line.m_LineLastValueVisibles[NAV_SPROFIT2] := true;
  f_Line.m_Precision := 2;
  Result := f_Line;
end;

// ---------------------------------------------------------------------------
function Creator_DrawDown: CFNNAVAnalLineValueSeries;
var
  f_Line: CFNNAVAnalLineValueSeries;
begin
  f_Line := CFNNAVAnalLineValueSeries.Create('DrawDown', CFNNAVAnalConst.LINESERIES_NAV, 3, 0, 0, 0);

  f_Line.m_LineNames[0] := '전';
  f_Line.m_LineNames[1] := '후';
  f_Line.m_LineNames[2] := 'MA';

  f_Line.m_LineColors[0] := 31;
  f_Line.m_LineColors[1] := 30;
  f_Line.m_LineColors[2] := 32;

  f_Line.m_LineVisibles[0] := true;
  f_Line.m_LineVisibles[1] := true;
  f_Line.m_LineVisibles[2] := true;

  f_Line.m_LineAlphas[0] := CFNNAVAnalColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[1] := CFNNAVAnalColorSet.ALPHA_DARK_LINE;
  f_Line.m_LineAlphas[2] := CFNNAVAnalColorSet.ALPHA_DARK_LINE;

  f_Line.m_LineLabelVisibles[0] := false;
  f_Line.m_LineLabelVisibles[1] := false;
  f_Line.m_LineLabelVisibles[2] := false;

  f_Line.m_LastValueVisible := false;
  f_Line.m_LineLastValueVisibles[0] := true;
  f_Line.m_LineLastValueVisibles[1] := true;
  f_Line.m_Precision := 2;
  Result := f_Line;
end;

// ---------------------------------------------------------------------------
end.
