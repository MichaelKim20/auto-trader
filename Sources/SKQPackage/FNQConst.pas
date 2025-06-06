unit FNQConst;

interface

const
    NOT_VALUE : Double   = -1.0E38;
    MIN_VALUE : Double   = -1.0E100;
    MAX_VALUE : Double   = 1.0E100;

type
    CFNQConst = class
    public
    const
        CHART_DRAW_YLABEL_WIDTH             = 50;
        CHART_DRAW_XLABEL_HEIGHT            = 13;
        CHART_DRAW_YBOUNDARY_OFFSET         = 2;
        CHART_DRAW_YLABEL_WIDTH2            = 50;
        CHART_DRAW_XLABEL_HEIGHT2           = 13;
        CHART_DRAW_YBOUNDARY_OFFSET2        = 2;


        CHART_INTERHEIGHT                   = -2;
        COMPARE_FALSE                       = 0;
        COMPARE_TRUE                        = 1;
        CHART_NORMAL                        = 0;
        CHART_MAMUL                         = 3;
        LINESERIES_PRICE                    = 0;
        LINESERIES_CLOSE                    = 1;
        LINESERIES_MA                       = 2;
        LINESERIES_ILMOK                    = 3;
        LINESERIES_BB                       = 4;
        LINESERIES_ENVELOPE                 = 5;
        LINESERIES_SAR                      = 6;
        LINESERIES_NET                      = 7;
        LINESERIES_MAMULOVERLAY             = 8;
        LINESERIES_VOLUME                   = 9;
        LINESERIES_MACD                     = 10;
        LINESERIES_ADX                      = 11;
        LINESERIES_DMI                      = 12;
        LINESERIES_RSI                      = 13;
        LINESERIES_OBV                      = 14;
        LINESERIES_FASTSTC                  = 15;
        LINESERIES_SLOWSTC                  = 16;
        LINESERIES_SONAR                    = 17;
        LINESERIES_PMAO                     = 18;
        LINESERIES_TRIX                     = 19;
        LINESERIES_PSY                      = 20;
        LINESERIES_CCI                      = 21;
        LINESERIES_VR                       = 22;
        LINESERIES_WILLIAM                  = 23;
        LINESERIES_ROC                      = 24;
        LINESERIES_LRL                      = 25;
        LINESERIES_VMAO                     = 26;
        LINESERIES_BBWIDTH                  = 27;
        LINESERIES_ATR                      = 28;
        LINESERIES_SAMSUN                   = 29;
        LINESERIES_PF                       = 30;
        LINESERIES_MAMUL                 = 31;
        LINESERIES_COMPARECLOSE         = 32;

        LINESERIES_PRICE_AT_OPS         = 33;
        LINESERIES_OPS                  = 34;
        LINESERIES_OPSIGUK              = 35;
        LINESERIES_OPSIGUK2             = 36;
        LINESERIES_OPSREL               = 37;
        LINESERIES_OPSSTDDEV            = 38;

        LINESERIES_PRICE_MA_CROSS_SIGNAL    = 40;
        LINESERIES_MA_CROSS_SIGNAL          = 41;
        LINESERIES_MACD_CROSS_SIGNAL        = 42;
        LINESERIES_SSTC_CROSS_SIGNAL        = 43;
        LINESERIES_FSTC_CROSS_SIGNAL        = 44;
        LINESERIES_RSI_CROSS_SIGNAL         = 45;
        LINESERIES_ADX_CROSS_SIGNAL         = 46;
        LINESERIES_WILLIAMSR_CROSS_SIGNAL   = 47;
        LINESERIES_SONA_CROSS_SIGNAL        = 48;
        LINESERIES_TRIX_CROSS_SIGNAL        = 49;
        LINESERIES_NMA_TREND_SIGNAL         = 50;
        LINESERIES_WMA_TREND_SIGNAL         = 51;
        LINESERIES_XMA_TREND_SIGNAL         = 52;


        PRICE_OPEN                         = 0;
        PRICE_HIGH                         = 1;
        PRICE_LOW                         = 2;
        PRICE_CLOSE                     = 3;
        SAMSUN_CLOSE                     = 0;
        SAMSUN_HIGH                     = 1;
        SAMSUN_LOW                         = 2;
        SAMSUN_SIGN                     = 3;
        SAMSUN_VALUE                     = 4;
        PCLOSE                             = 0;
        PSIGN                             = 1;
        PX                                 = 2;
        PY                                 = 3;

        PF_CLOSE                        = 0;
        PF_SIGN                         = 1;
        PF_X                            = 2;
        PF_Y                            = 3;

        MAMUL_HIGH                         = 0;
        MAMUL_LOW                         = 1;
        MAMUL_VOLUME                     = 2;
        MAMUL_VRATOR                     = 3;

        MAX_OVERLAY_COUNT               = 6;
        MAX_INDICATOR_COUNT             = 10;
        MAX_SIGNAL_COUNT                = 10;

        COLOR_SET_BLACK                 = 0;
        COLOR_SET_WHITE                 = 1;

    end;


implementation

end.
