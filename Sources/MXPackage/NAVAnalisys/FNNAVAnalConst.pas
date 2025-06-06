unit FNNAVAnalConst;

interface

const
  NOT_VALUE: Double = -1.0E38;
  MIN_VALUE: Double = -1.0E100;
  MAX_VALUE: Double = 1.0E100;

type
  CFNNAVAnalConst = class
  public const
    CHART_DRAW_YLABEL_WIDTH = 50;
    CHART_DRAW_XLABEL_HEIGHT = 13;
    CHART_DRAW_YBOUNDARY_OFFSET = 2;
    CHART_DRAW_YLABEL_WIDTH2 = 50;
    CHART_DRAW_XLABEL_HEIGHT2 = 13;
    CHART_DRAW_YBOUNDARY_OFFSET2 = 2;

    CHART_INTERHEIGHT = -2;
    CHART_NORMAL = 0;
    CHART_MAMUL = 3;

    LINESERIES_NAV = 0;

    TPROFITSUM = 0;
    BPROFITSUM = 1;
    SPROFITSUM = 2;

    COLOR_SET_BLACK = 0;
    COLOR_SET_WHITE = 1;

  end;

implementation

end.
