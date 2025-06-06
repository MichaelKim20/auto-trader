unit FNMatrixLineValueSeries;

interface
uses
    SysUtils, Classes, Types, Math,
    MKLineValueSeries,
    FNMatrixChartDataSeries, FNMatrixMaxMin, FNMatrixLineValue, FNMatrixConst,
    FNMatrixChartData,
    FNTradeSystem, MXOption;

const
    M_QUARK_MA                    =   0;
    M_QUARK_SIGNAL1               =   1;
    M_QUARK_SIGNAL2               =   2;
    M_QUARK_SIGNAL3               =   3;
    M_QUARK_SIGNAL4               =   4;
    M_QUARK_REALPRICE             =   5;
    M_QUARK_SIGNAL2_TP            =   6;
    M_QUARK_SIGNAL3_TP            =   7;
    M_QUARK_SIGNAL4_TP            =   8;
    M_QUARK_TP                    =   9;
    M_QUARK_SIGNAL3_TPC           =  10;
    M_QUARK_SIGNAL4_TPC           =  11;
    M_QUARK_REFINE1_REGISTER1     =  12;
    M_QUARK_REFINE1_REGISTER2     =  13;
    M_QUARK_REFINE1_REGISTER3     =  14;
    M_QUARK_FACTOR                =  15;
    M_QUARK_FACTORRATE            =  16;
    M_QUARK_REFINE2_REGISTER1     =  17;
    M_QUARK_REFINE2_REGISTER2     =  18;
    M_QUARK_REFINE2_REGISTER3     =  19;
    M_QUARK_VOLATILITY            =  20;

    M_MERGE_LINE_SYSTEMNO                 =   0;  //  시스템의 번호
    M_MERGE_LINE_REALPRICE                =   1;  //  실물가격
    M_MERGE_LINE_VOLUME                   =   2;  //  거래량
    M_MERGE_LINE_SIGNAL1_1                =   3;  //  1-1차신호
    M_MERGE_LINE_SIGNAL1_SEQ              =   4;  //  1-1차신호의 순번
    M_MERGE_LINE_SIGNAL1_SEQ2             =   5;  //  1-1차신호의 순번
    M_MERGE_LINE_SIGNAL1_2                =   6;  //  1-2차신호
    M_MERGE_LINE_SIGNAL1_3                =   7;  //  1-3차신호
    M_MERGE_LINE_ENTERCOUNT               =   8;  //  1-2차신호 내부의 2차신호의 진입횟수
    M_MERGE_LINE_SIGNAL2_1                =   9;  //  로스컷이 적용된 2차신호
    M_MERGE_LINE_SIGNAL2_2                =  10;  //  로스컷이 적용된 2차신호
    M_MERGE_LINE_ENTERPRICE2_2            =  11;  //  2차신호의 진입가격
    M_MERGE_LINE_SIGNAL2_3                =  12;  //  로스컷이 적용된 2차신호
    M_MERGE_LINE_SIGNAL2_4                =  13;  //  로스컷이 적용된 2차신호
    M_MERGE_LINE_SIGNAL3                  =  M_MERGE_LINE_SIGNAL2_4;  //  로스컷이 적용된 3차신호
    M_MERGE_LINE_PROFIT3                  =  14;  //  3차신호의 누적수익
    M_MERGE_LINE_PROFIT1                  =  15;  //  1-2차신호의 누적수익
    M_MERGE_LINE_PROFIT1_B                =  16;  //  1-2차신호의 매수거래의 누적수익
    M_MERGE_LINE_PROFIT1_S                =  17;  //  1-2차신호의 매도거래의 누적수익
    M_MERGE_LINE_PROFIT1_AVG1             =  18;  //  1-2차신호의 누적수익의 가중평균(진입필터용)
    M_MERGE_LINE_PROFIT1_AVG1_B           =  19;  //  1-2차신호의 매수거래의 누적수익의 가중평균(진입필터용)
    M_MERGE_LINE_PROFIT1_AVG1_S           =  20;  //  1-2차신호의 매도거래의 누적수익의 가중평균(진입필터용)
    M_MERGE_LINE_PROFIT1_AVG2             =  21;  //  1-2차신호의 누적수익의 가중평균(청산손절매용)
    M_MERGE_LINE_PROFIT1_AVG2_B           =  22;  //  1-2차신호의 매수거래의 누적수익의 가중평균(청산손절매용)
    M_MERGE_LINE_PROFIT1_AVG2_S           =  23;  //  1-2차신호의 매도거래의 누적수익의 가중평균(청산손절매용)
    M_MERGE_LINE_PROFIT1C                 =  24;  //  1-2차신호의 누적수익
    M_MERGE_LINE_PROFIT1C_B               =  25;  //  1-2차신호의 매수거래의 누적수익
    M_MERGE_LINE_PROFIT1C_S               =  26;  //  1-2차신호의 매도거래의 누적수익
    M_MERGE_LINE_PROFIT1C_AVG1            =  27;  //  1-2차신호의 누적수익의 가중평균(진입필터용)
    M_MERGE_LINE_PROFIT1C_AVG1_B          =  28;  //  1-2차신호의 매수거래의 누적수익의 가중평균(진입필터용)
    M_MERGE_LINE_PROFIT1C_AVG1_S          =  29;  //  1-2차신호의 매도거래의 누적수익의 가중평균(진입필터용)
    M_MERGE_LINE_PROFIT1C_AVG2            =  30;  //  1-2차신호의 누적수익의 가중평균(청산손절매용)
    M_MERGE_LINE_PROFIT1C_AVG2_B          =  31;  //  1-2차신호의 매수거래의 누적수익의 가중평균(청산손절매용)
    M_MERGE_LINE_PROFIT1C_AVG2_S          =  32;  //  1-2차신호의 매도거래의 누적수익의 가중평균(청산손절매용)
    M_MERGE_LINE_LOSCUT2_ENTPRICE         =  33;
    M_MERGE_LINE_LOSCUT2_MAXPRICE         =  34;
    M_MERGE_LINE_LOSCUT2_STEP             =  35;
    M_MERGE_LINE_LOSCUT3_ENTPRICE         =  36;
    M_MERGE_LINE_LOSCUT3_MAXPRICE         =  37;
    M_MERGE_LINE_LOSCUT3_STEP             =  38;
    M_MERGE_LINE_LOSCUT4_ENTPRICE         =  39;
    M_MERGE_LINE_LOSCUT4_MAXPRICE         =  40;
    M_MERGE_LINE_LOSCUT4_STEP             =  41;
    M_MERGE_LINE_ASSETPATTENV0            =  42;
    M_MERGE_LINE_ASSETPATTENV1            =  43;
    M_MERGE_LINE_ASSETPATTENV2            =  44;
    M_MERGE_LINE_PROFIT3C                 =  45;
    M_MERGE_LINE_FINALFILTER1             =  46;
    M_MERGE_LINE_FINALFILTER2             =  47;

    M_MERGE_LINE_SIGNAL4                  =  48;  //  4차신호
    M_MERGE_LINE_SIGNAL4_SEQ              =  49;  //  4차신호의 순번

    M_MERGE_LINE_SIGNAL5                  =  50;  //  5차신호
    M_MERGE_LINE_PROFIT5                  =  51;  //  5차신호의 누적수익
    M_MERGE_LINE_PROFIT5_B                =  52;  //  5차신호의 매수거래의 누적수익
    M_MERGE_LINE_PROFIT5_S                =  53;  //  5차신호의 매도거래의 누적수익
    M_MERGE_LINE_PROFIT5_B_STOP           =  54;  //  5차신호의 매수거래의 거래정지 여부
    M_MERGE_LINE_PROFIT5_S_STOP           =  55;  //  5차신호의 매도거래의 거래정지 여부

    M_MERGE_LINE_SIGNAL6                  =  56;  //  6차신호
    M_MERGE_LINE_PROFIT6                  =  57;  //  6차신호의 누적수익
    M_MERGE_LINE_PROFIT6_STOP             =  58;  //  6차신호의 거래정지 여부

    M_MERGE_LINE_SIGNAL7                  =  59;  //  7차신호
    M_MERGE_LINE_PROFIT7                  =  60;  //  7차신호의 누적수익

    M_MERGE_LINE_TRADE_STOP_PROFIT_MAX    =  61;
    M_MERGE_LINE_TRADE_STOP_PROFIT_STEP   =  62;
    M_MERGE_LINE_TRADE_STOP_PROFIT_STOP   =  63;  //  7차신호의 거래정지 여부


    M_MERGE_LINE_SIGNAL7_2                =  64;  //  7차신호


    M_MERGE_LINE_SIGNAL8                  =  65;  //  8차신호
    M_MERGE_LINE_PROFIT8                  =  66;  //  8차신호의 누적수익
    M_MERGE_LINE_PROFIT8_B                =  67;  //  8차신호의 누적수익
    M_MERGE_LINE_PROFIT8_S                =  68;  //  8차신호의 누적수익

    M_MERGE_LINE_VOLATILITY_L             =  69;  //  변동성
    M_MERGE_LINE_VOLATILITY_C             =  70;  //  변동성
    M_MERGE_LINE_VLC1_ENTPRICE            =  71;
    M_MERGE_LINE_VLC1_MAXPRICE            =  72;
    M_MERGE_LINE_VLC1_STEP                =  73;
    M_MERGE_LINE_VLC2_ENTPRICE            =  74;

    M_MERGE_LINE_SIGNAL9                  =  75;  //  9차신호
    M_MERGE_LINE_PROFIT9                  =  76;  //  9차신호의 누적수익


    M_MATRIX_LINE_REALPRICE             =   0;
    M_MATRIX_LINE_VALUE			        =   1;
    M_MATRIX_LINE_VALUE_MA0 	        =   2;
    M_MATRIX_LINE_VALUE_MA1  	        =   3;
    M_MATRIX_LINE_VALUE_MA2  	        =   4;
    M_MATRIX_LINE_MAXVALUE			    =   5;
    M_MATRIX_LINE_TR_INDEX              =   6;
    M_MATRIX_LINE_TR_ENTER_VALUE        =   7;
    M_MATRIX_LINE_TR_EXIT_VALUE         =   8;
    M_MATRIX_LINE_TR_VALUE              =   9;
    M_MATRIX_LINE_TR_MAXVALUE           =  10;
    M_MATRIX_LINE_TR_EXITI_NDEX         =  11;
    M_MATRIX_LINE_TR_STOP_TYPE          =  12;
    M_MATRIX_LINE_FINALVALUE			=  13;
    M_MATRIX_LINE_ENTERSTEP 			=  14;
    M_MATRIX_LINE_NOTR_LOWESTVALUE	    =  15;
    M_MATRIX_LINE_INTERVALUE1			=  16;
    M_MATRIX_LINE_TRADE_STOP   	        =  17;
    M_MATRIX_LINE_CANTRADE01            =  18;
    M_MATRIX_LINE_CANTRADE02            =  19;
    M_MATRIX_LINE_CANTRADE03            =  20;
    M_MATRIX_LINE_TR_VALUE03            =  21;
    M_MATRIX_LINE_TR_EXIT_VALUE03       =  22;


    M_MATRIX_VLINE_VOLUME               =   0;

type

    CFNMatrixLineValueSeries = class(CMKLineValueSeries)
    public
        m_Items                 : TList;
        m_ChartDataSeries       : CFNMatrixChartDataSeries;
        m_TimeFrame             : Integer;
        m_Name                  : String;
        m_FullName              : String;

        m_LastValueVisible      : Boolean;
        m_ViewLabel             : Boolean;
        m_LineCount             : Integer;
        m_LineColors            : Array of Integer;
        m_LineWidths            : Array of Integer;
        m_LineAlphas            : Array of Integer;
        m_LineTypes             : Array of Integer;
	    m_LineVisibles          : Array of Boolean;
        m_LineLabelVisibles     : Array of Boolean;
        m_LineLabelNameVisibles : Array of Boolean;
        m_LinePosValueVisibles  : Array of Boolean;
        m_LineLastValueVisibles : Array of Boolean;
        m_LineNames             : Array of String;
        m_LineMaxMinIndexs      : Array of Integer ;
        m_OptionCount           : Integer;
        m_Options               : Array of Double;
        m_ValueCount            : Integer;
        m_Values                : Array of Double;
        m_ValueColors           : Array of Integer;
        m_ValueWidths           : Array of Integer;
        m_ValueEnables          : Array of Boolean;
        m_MaxMinCount           : Integer;
        m_MaxMinTable           : Array of CFNMatrixMaxMin;
        m_MaxMinFactor          : Array of Double;
        m_Precision             : Integer;
        m_StartIndex            : Integer;
        m_Effect                : Boolean;
        m_Type                  : Integer;
        m_Signal                : Boolean;

    private
        m_VolatilityOrigin      : Integer;
    public
        constructor Create(
        p_Name:String;
        p_Type:Integer;
        p_LineCount:Integer = 1;
        p_OptionCount:Integer = 0;
        p_ValueCount:Integer = 0;
        p_MaxMinCount:Integer = 1);
        destructor  Destroy; override;

        procedure Clone(p_Source:CFNMatrixLineValueSeries);
        procedure Update(p_Source: CFNMatrixLineValueSeries);

        procedure SetLineCount(p_LineCount : Integer);
        procedure GetLineMaxMin(p_X1:Integer; p_X2:Integer);
        procedure Clear;
        procedure Fill(p_Count:Integer);
        procedure SetLengthSeries(p_Length:Integer);

        procedure CreateLineValueAdd(p_Index:Integer; p_Value:Double; p_Count:Integer=1);

        procedure Indicator_Price(p_ChartDataSeries:CFNMatrixChartDataSeries; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_Close(p_ChartDataSeries:CFNMatrixChartDataSeries; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_RealPrice(p_ChartDataSeries:CFNMatrixChartDataSeries; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_Volume(p_ChartDataSeries:CFNMatrixChartDataSeries; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure HiLoPrice(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_HiIndex:Integer; p_LoIndex:Integer; p_Position:Integer; var f_Hi, f_Low : Double);
        function HighestPrice(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_PriceIndex:Integer; p_Position:Integer) : Double;
        function LowestPrice(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_PriceIndex:Integer; p_Position:Integer) : Double;
        function HighestIndex(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_PriceIndex:Integer; p_Position:Integer) : Integer;
        function LowestIndex(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_PriceIndex:Integer; p_Position:Integer) : Integer;
        procedure Indicator_NAverage(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_NAverage2(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_NAverageZ(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);

        procedure Indicator_NXAverage(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_XAverage(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_XAverageZ(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);

        procedure Indicator_WAverage(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_WAverage2(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);

        procedure Indicator_WAverage3(p_Count:Integer; p_Precision:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_WAverageZ(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);

        procedure Indicator_ProfitWAverageOfBuy(p_Count:Integer; p_Precision:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_ProfitWAverageOfSell(p_Count:Integer; p_Precision:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);

        procedure Indicator_Subtraction(p_SrcLineSeries1:CFNMatrixLineValueSeries; p_SrcIndex1:Integer; p_SrcValueArray2:CFNMatrixLineValueSeries; p_SrcIndex2:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_Division(p_SrcLineSeries1:CFNMatrixLineValueSeries; p_SrcIndex1:Integer; p_SrcValueArray2:CFNMatrixLineValueSeries; p_SrcIndex2:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_MACD(p_FastMA:Integer; p_SlowMA:Integer; p_MA:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_NET(p_SmallMA:Integer; p_Increse:Integer; p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_SlowSTC(p_Length1:Integer; p_Length2:Integer; p_Length3:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_HighIndex:Integer; p_LowIndex:Integer; p_CloseIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_FastSTC(p_Length1:Integer; p_Length2:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_HighIndex:Integer; p_LowIndex:Integer; p_CloseIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_RSI(p_Length:Integer; p_MA:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_OBV(p_SrcValueArray:CFNMatrixLineValueSeries; p_CloseIndex:Integer; p_SrcValueArray2:CFNMatrixLineValueSeries; p_VolumeIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_TrueRange(p_SrcValueArray:CFNMatrixLineValueSeries; p_HighIndex:Integer; p_LowIndex:Integer; p_CloseIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_PMDM(p_SrcValueArray:CFNMatrixLineValueSeries; p_HighIndex:Integer; p_LowIndex:Integer; p_CloseIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_PMDI(p_Length:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_ADX(p_Length:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_PDIIndex:Integer; p_MDIIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_StdDev(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_PriceIndex:Integer; p_SrcValueArray2:CFNMatrixLineValueSeries; p_MIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_BBand(p_Count:Integer; p_Factor:Double; p_SrcValueArray:CFNMatrixLineValueSeries; p_PriceIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_LRL(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_IMLine(p_Length1:Integer; p_Length2:Integer; p_Length3:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_HighIndex:Integer; p_LowIndex:Integer; p_CloseIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_WilliamsR(p_Count1:Integer; p_Count2:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_HighIndex:Integer; p_LowIndex:Integer; p_CloseIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_SONA(p_Length1:Integer; p_Length2:Integer; p_Length3:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_ROC(p_Length1:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_PMAO(p_Length1:Integer; p_Length2:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_Envelope(p_Length:Integer; p_Factor:Double; p_SrcValueArray:CFNMatrixLineValueSeries; p_PriceIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_BBWidth(p_Count:Integer; p_Factor:Double; p_SrcValueArray:CFNMatrixLineValueSeries; p_PriceIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_PSY(p_Length:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_PriceIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_ATR(p_Length:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_HighIndex:Integer; p_LowIndex:Integer; p_CloseIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_CCI(p_Length:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_HighIndex:Integer; p_LowIndex:Integer; p_CloseIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_TRIX(p_Length1:Integer; p_Length2:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_SAR(p_Length:Double; p_SrcValueArray:CFNMatrixLineValueSeries; p_HighIndex:Integer; p_LowIndex:Integer; p_CloseIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_VR(p_Length:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_PriceIndex:Integer; p_SrcValueArray2:CFNMatrixLineValueSeries; p_VolumeIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_Samsun(p_SrcValueArray:CFNMatrixLineValueSeries; p_PriceIndex:Integer; p_TagIndex:Integer);
        procedure Indicator_Mamul(p_SrcValueArray1:CFNMatrixLineValueSeries; p_CloseIndex:Integer; p_SrcValueArray2:CFNMatrixLineValueSeries; p_VolumeIndex:Integer; p_TagIndex:Integer);
        procedure Indicator_MamulOverlay(p_Grade:Integer; p_SrcValueArray1:CFNMatrixLineValueSeries; p_CloseIndex:Integer; p_SrcValueArray2:CFNMatrixLineValueSeries; p_VolumeIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_PF(p_SrcValueArray:CFNMatrixLineValueSeries; p_PriceIndex:Integer; p_TagIndex:Integer);
        procedure Indicator_CompareClose(p_ChartDataSeries1:CFNMatrixChartDataSeries; p_ChartDataSeries2:CFNMatrixChartDataSeries; p_Begin:Integer = -1; p_End:Integer = -1);

        procedure Indicator_CrossSignal(p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex1:Integer; p_SrcIndex2:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_MACD_CrossSignal(p_FastMA:Integer; p_SlowMA:Integer; p_MA:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_MA_CrossSignal(p_FastMA:Integer; p_SlowMA:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_Price_MA_CrossSignal(p_MA:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_SlowSTC_CrossSignal(p_Length1:Integer; p_Length2:Integer; p_Length3:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_HighIndex:Integer; p_LowIndex:Integer; p_CloseIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_FastSTC_CrossSignal(p_Length1:Integer; p_Length2:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_HighIndex:Integer; p_LowIndex:Integer; p_CloseIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_RSI_CrossSignal(p_Length:Integer; p_MA:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_ADX_CrossSignal(p_Length:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_PDIIndex:Integer; p_MDIIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_WilliamsR_CrossSignal(p_Count1:Integer; p_Count2:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_HighIndex:Integer; p_LowIndex:Integer; p_CloseIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_SONA_CrossSignal(p_Length1:Integer; p_Length2:Integer; p_Length3:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_TRIX_CrossSignal(p_Length1:Integer; p_Length2:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);

        procedure Indicator_TrendSignal(p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
        procedure Indicator_NMA_TrendSignal(p_MA:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_WMA_TrendSignal(p_MA:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Indicator_XMA_TrendSignal(p_MA:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);

        procedure ScanSignal(p_ChartDataSeries:CFNMatrixChartDataSeries;p_SignalArray:CFNSignalArray; p_SystemNoIndex:integer; p_SrcIndex:integer; p_Begin:Integer = -1; p_End:Integer = -1);

        procedure Calc_TotalProfit(p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_PriceIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Calc_TotalProfit_Buy (p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_PriceIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Calc_TotalProfit_Sell(p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_PriceIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);

        procedure Calc_TotalProfit_Close(p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Calc_TotalProfit_Close_Buy(p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Calc_TotalProfit_Close_Sell(p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);

        procedure Calc_LastProfit(p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_PriceIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
        procedure Calc_RecentProfit(p_Min:Integer;p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_TotalProfitIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);

        function ConsecutiveUp(ALineIndex:Integer; ACount:Integer; APosition:Integer):Boolean;
        function ConsecutiveDn(ALineIndex:Integer; ACount:Integer; APosition:Integer):Boolean;
        function AboveOf(ALineIndex1:Integer; ALineIndex2:Integer; APosition:Integer):Boolean;
        function BelowOf(ALineIndex1:Integer; ALineIndex2:Integer; APosition:Integer):Boolean;
    end;

implementation
uses
    DateUtils, FNGlobal, FNVolumePriceArray;

//---------------------------------------------------------------------------
{/**
 * 생성자
 *
 * @param    p_Name         라인의 이름
 * @param    p_Type         라인의 형식
 * @param    p_LineCount    전체 라인의 수
 * @param    p_OptionCount  옵션의 수
 * @param    p_ValueCount   가로선의 수
 * @param    p_MaxMinCount  최대최소값의 수
**/}
constructor CFNMatrixLineValueSeries.Create(p_Name:String; p_Type:Integer; p_LineCount:Integer = 1; p_OptionCount:Integer = 0; p_ValueCount:Integer = 0; p_MaxMinCount:Integer = 1);
var
    f_Index     : Integer;
    p_MaxMin    : CFNMatrixMaxMin;
begin
    m_VolatilityOrigin := -1;
    inherited Create;
    m_Signal                := FALSE;
    m_Effect                := FALSE;
    m_Items                 := TList.Create;
    m_Name                  := p_Name;
    m_FullName              := p_Name;
    m_Type                  := p_Type;
    m_LineCount             := p_LineCount;
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
        m_LineColors[f_Index]   := f_Index;
        m_LineWidths[f_Index]   := 0;
        m_LineAlphas[f_Index]   := 0;
        m_LineTypes[f_Index]    := 0;
        m_LineNames[f_Index]    := '';
        m_LineVisibles[f_Index]         := TRUE;
        m_LineLabelVisibles[f_Index]    := TRUE;
        m_LineLabelNameVisibles[f_Index]:= TRUE;
        m_LinePosValueVisibles[f_Index] := TRUE;
        m_LineLastValueVisibles[f_Index] := FALSE;
        m_LineMaxMinIndexs[f_Index] := 0;
    end;

    m_OptionCount       := p_OptionCount;
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
        m_Values[f_Index]       := 0;
        m_ValueColors[f_Index]  := f_Index;
        m_ValueWidths[f_Index]  := 1;
        m_ValueEnables[f_Index] := TRUE;
    end;

    m_MaxMinCount := p_MaxMinCount;
    if (m_MaxMinCount <= 0) then m_MaxMinCount := 1;

    SetLength(m_MaxMinTable, m_MaxMinCount);
    SetLength(m_MaxMinFactor, m_MaxMinCount);
    for f_Index := 0 to m_MaxMinCount - 1 do
    begin
        p_MaxMin := CFNMatrixMaxMin.Create;
        m_MaxMinTable[f_Index]  := p_MaxMin;
        m_MaxMinFactor[f_Index] := 1.0;
    end;

    m_TimeFrame     := 360;
    m_Effect        := false;
    m_ViewLabel     := TRUE;
    m_Precision     := 2;
    m_StartIndex    := 0;

    m_LastValueVisible := false;

    m_VolatilityOrigin      := -1;
end;

//---------------------------------------------------------------------------
destructor CFNMatrixLineValueSeries.Destroy;
var
    f_Index : Integer;
begin
    Clear;

    m_Items.Free;
    m_Items			:=	NIL;
    m_LineColors	:=	NIL;
    m_LineWidths	:=	NIL;
    m_LineAlphas	:=	NIL;
    m_LineTypes		:=	NIL;
    m_LineNames		:=	NIL;
    m_LineVisibles		    :=	NIL;
    m_LineMaxMinIndexs		:=	NIL;
    m_LineLabelVisibles		:=	NIL;
    m_LineLabelNameVisibles	:=	NIL;
    m_LinePosValueVisibles	:=	NIL;

    for f_Index := 0 to m_MaxMinCount - 1 do
    begin
        CFNMatrixMaxMin(m_MaxMinTable[f_Index]).Free;
        m_MaxMinTable[f_Index] := NIL;
    end;
    m_MaxMinTable		    :=	NIL;

    m_VolatilityOrigin      := -1;

    inherited Destroy;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Clear;
begin
    while 0 < m_Items.Count  do
    begin
        CFNMatrixLineValue(m_Items[0]).Free;
        m_Items.Delete(0);
    end;
    m_VolatilityOrigin := -1;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Clone(p_Source: CFNMatrixLineValueSeries);
var
    f_LineIndex : Integer;
    f_ValueIndex : Integer;
    f_TagValue : CFNMatrixLineValue;
    f_SrcValue : CFNMatrixLineValue;
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
    m_Effect := true;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Update(p_Source: CFNMatrixLineValueSeries);
var
    f_LineIndex : Integer;
    f_ValueIndex : Integer;
    f_TagValue : CFNMatrixLineValue;
    f_SrcValue : CFNMatrixLineValue;
    f_Begin, f_End : Integer;
begin
    if m_Items.Count > 0 then
    begin
        f_Begin := m_Items.Count-1;
        if f_Begin < 0 then f_Begin := 0;
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
    end else
    begin
        Clone(p_Source);
    end;
end;

//---------------------------------------------------------------------------
{**
 * 지정한 갯수만큼 데이터를 모두 채운다.
 *
 * @param    p_Count
**}
procedure CFNMatrixLineValueSeries.Fill(p_Count: Integer);
var
    f_Index : Integer;
    f_Value : CFNMatrixLineValue;
begin
    for f_Index := 0 to p_Count - 1 do
    begin
        f_Value := CFNMatrixLineValue.Create(m_LineCount);
        m_Items.Add(f_Value);
    end;
end;

//---------------------------------------------------------------------------
{**
 * 라인의 최대값과 최소값을 계산한다. 이때 라인의 Type과 비교모드의 상태에 따라 계산방법이 달라 지므로 주의하여야한다.
 *
 * @param    p_X1            시작인덱스
 * @param    p_X2            마자막인덱스
 * @param    p_Origin        비교모드일 때 기준인덱스, 기준인덱의 값을 100으로 보면된다.
 * @param    p_CompareState  비교모드인지 아닌지 결정한다
**}
procedure CFNMatrixLineValueSeries.GetLineMaxMin(p_X1, p_X2:Integer);
var
    f_MaxLength     : Integer;
    f_Index         : Integer;
    f_Line          : Integer;
    f_MaxMin        : Integer;
    f_X1            : Integer;
    f_X2            : Integer;
    f_YOldMaxMin    : Double;
    f_YNewMaxMin    : Double;
    f_LineValue     : CFNMatrixLineValue;

    f_Value         : Double;
    f_ChartData     : CFNMatrixChartData;
begin
    f_MaxLength := m_ChartDataSeries.m_Items.Count;
    if f_MaxLength > m_Items.Count then f_MaxLength := m_Items.Count;

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

    {$REGION '주가차트'}
    if (m_Type = CFNMatrixConst.LINESERIES_PRICE) then
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
        while(f_Index <= f_X2) do
        begin
            f_LineValue := CFNMatrixLineValue(m_Items[f_Index]);

            if (f_LineValue.m_Value[CFNMatrixConst.PRICE_HIGH] <> NOT_VALUE) then
            begin
                if (f_LineValue.m_Value[CFNMatrixConst.PRICE_HIGH] > m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMax) then
                begin
                    m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMax := f_LineValue.m_Value[CFNMatrixConst.PRICE_HIGH];
                    m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMaxIndex := f_Index;
                end;
            end;

            if (f_LineValue.m_Value[CFNMatrixConst.PRICE_LOW] <> NOT_VALUE) then
            begin
                if (f_LineValue.m_Value[CFNMatrixConst.PRICE_LOW] < m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMin) then
                begin
                    m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMin := f_LineValue.m_Value[CFNMatrixConst.PRICE_LOW];
                    m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMinIndex := f_Index;
                end;
            end;

            Inc(f_Index);
        end;
    end else
    {$ENDREGION}

    {$REGION '거래량차트'}
    if (m_Type = CFNMatrixConst.LINESERIES_VOLUME) then
    begin
        for f_MaxMin := 0 to m_MaxMinCount - 1 do
        begin
            m_MaxMinTable[f_MaxMin].m_XMax := p_X2;
            m_MaxMinTable[f_MaxMin].m_XMin := p_X1;
            m_MaxMinTable[f_MaxMin].m_YMin := 0;
        end;

        f_Index := f_X1;
        while(f_Index <= f_X2) do
        begin
            f_LineValue := CFNMatrixLineValue(m_Items[f_Index]);
            if (f_LineValue.m_Value[0] <> NOT_VALUE) then
            begin
                if (f_LineValue.m_Value[0] > m_MaxMinTable[m_LineMaxMinIndexs[0]].m_YMax) then
                    m_MaxMinTable[m_LineMaxMinIndexs[0]].m_YMax := f_LineValue.m_Value[0];
            end;

            Inc(f_Index);
        end;
        m_MaxMinTable[m_LineMaxMinIndexs[0]].m_YMax := 1500;
    end else
    {$ENDREGION}

    {$REGION '그 밖의 차트'}
    begin
        for f_MaxMin := 0 to m_MaxMinCount - 1 do
        begin
            m_MaxMinTable[f_MaxMin].m_XMin := p_X1;
            m_MaxMinTable[f_MaxMin].m_XMax := p_X2;
        end;

        for f_Line := 0 to m_LineCount - 1 do
        begin
            if (not m_LineVisibles[f_Line]) then continue;
            if (4 = m_LineTypes[f_Line]) then continue;


            f_Index := f_X1;
            while( (f_Index <= f_X2) and (f_Index < m_Items.Count) ) do
            begin
                f_LineValue := CFNMatrixLineValue(m_Items[f_Index]);
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
    {$ENDREGION}

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

//---------------------------------------------------------------------------
{**
 *  p_Position에서 p_Position--p_Count+1 까지 최대값이 들어 있는 인덱스를 찾는다.
 *
 * @param    p_Count
 * @param    p_SrcValueArray
 * @param    p_PriceIndex
 * @param    p_Position
**}
function CFNMatrixLineValueSeries.HighestIndex(p_Count: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_PriceIndex, p_Position: Integer): Integer;
var
    f_Index     : Integer;
    f_DHighest  : Double;
    f_HighestIndex : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
        Result := 0;

    f_DHighest := MIN_VALUE;
    if (p_Position - p_Count + 1 < 0) then
        p_Count := p_Position + 1;

    for f_Index := 0 to p_Count - 1 do
    begin
        if (f_DHighest < CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex]) then
        begin
            f_DHighest := CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex];
            f_HighestIndex := p_Position - f_Index;
        end;
    end;

    Result := f_HighestIndex;
end;

//---------------------------------------------------------------------------
{**
 *  p_Position에서 p_Position--p_Count+1 까지 최대값을 찾는다.
 *
 * @param    p_Count
 * @param    p_SrcValueArray
 * @param    p_PriceIndex
 * @param    p_Position
**}
function CFNMatrixLineValueSeries.HighestPrice(p_Count: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_PriceIndex, p_Position: Integer): Double;
var
    f_Index : Integer;
    f_DHighest : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
    begin
        Result := 0.0;
        exit;
    end;

    f_DHighest := MIN_VALUE;
    if (p_Position - p_Count + 1 < 0) then
        p_Count := p_Position + 1;

    for f_Index := 0 to p_Count - 1 do
    begin
        if (f_DHighest < CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex]) then
            f_DHighest := CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex];
    end;

    Result := f_DHighest;
end;

//---------------------------------------------------------------------------
{**
 * 최대 최소를 계산할 갯수로서 p_Position에서 p_Position--p_Count+1 까지 구간의 최대 최소를 계산한다.
 *
 * @param    p_Count
 * @param    p_SrcValueArray  라인 시리즈
 * @param    p_HiIndex        고가가 들어 있는 인덱스
 * @param    p_LoIndex        저가가 들어 잇는 인덱스
 * @param    p_Position       현재 위치
 * @param    p_HiLow          최대값과 최소값을 담아서 전달한다.
**}
procedure CFNMatrixLineValueSeries.HiLoPrice(p_Count: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_HiIndex, p_LoIndex, p_Position: Integer; var f_Hi, f_Low : Double);
var
    f_Index : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
        exit;

    //p_HiLow.x := MIN_VALUE;
    //p_HiLow.y := MAX_VALUE;
    f_Hi := MIN_VALUE;  //-1.0E100;
    f_Low := MAX_VALUE; //1.0E100;

    if (p_Position - p_Count + 1 < 0) then
        p_Count := p_Position + 1;

    for f_Index := 0 to p_Count - 1 do
    begin
        {
        if (p_HiLow.x < CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_HiIndex]) then
            p_HiLow.x := CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_HiIndex];

        if (p_HiLow.y > CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_LoIndex]) then
            p_HiLow.y := CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_LoIndex];
        }
        if (f_Hi < CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_HiIndex]) then
            f_Hi := CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_HiIndex];

        if (f_Low > CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_LoIndex]) then
            f_Low := CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_LoIndex];
    end;
end;

//---------------------------------------------------------------------------
{**
 * ADX를 계산한다.
 *
 * @param    p_Length
 * @param    p_SrcValueArray
 * @param    p_PDIIndex
 * @param    p_MDIIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_ADX(p_Length: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_PDIIndex, p_MDIIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_ADXIndex  : Integer;
    f_DMIIndex  : Integer;
    f_DMI       : Double;
    f_DMIPlus   : Double;
    f_DMIMinus  : Double;
    f_Index2    : Integer;
    f_Index     : Integer;
    f_Size      : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_ADXIndex  := p_TagIndex;
    f_DMIIndex  := p_TagIndex + 2;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    m_Effect    := false;
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        if ((CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PDIIndex] <> NOT_VALUE)
            and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_MDIIndex] <> NOT_VALUE)) then
        begin
            f_DMIPlus := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PDIIndex];
            f_DMIMinus := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_MDIIndex];
            if ((f_DMIPlus + f_DMIMinus) <> 0) then
                f_DMI := (Abs(f_DMIPlus - f_DMIMinus) / (f_DMIPlus + f_DMIMinus)) * 100.0
            else
                f_DMI := 0;

            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_DMIIndex] := f_DMI;
        end
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_DMIIndex] := NOT_VALUE;
    end;

    Indicator_NXAverage(p_Length, Self, f_DMIIndex, f_ADXIndex);
    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_ADX_CrossSignal(p_Length: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_PDIIndex, p_MDIIndex, p_TagIndex,
  p_Begin, p_End: Integer);
var
    f_ADXIndex  : Integer;
    f_DMIIndex  : Integer;
    f_DMI       : Double;
    f_DMIPlus   : Double;
    f_DMIMinus  : Double;
    f_Index2    : Integer;
    f_Index     : Integer;
    f_Size      : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_ADXIndex  := p_TagIndex + 1;
    f_DMIIndex  := p_TagIndex + 3;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    m_Effect    := false;
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        if ((CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PDIIndex] <> NOT_VALUE)
            and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_MDIIndex] <> NOT_VALUE)) then
        begin
            f_DMIPlus := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PDIIndex];
            f_DMIMinus := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_MDIIndex];
            if ((f_DMIPlus + f_DMIMinus) <> 0) then
                f_DMI := (Abs(f_DMIPlus - f_DMIMinus) / (f_DMIPlus + f_DMIMinus)) * 100.0
            else
                f_DMI := 0;

            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_DMIIndex] := f_DMI;
        end
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_DMIIndex] := NOT_VALUE;
    end;

    Indicator_NXAverage(p_Length, Self, f_DMIIndex, f_ADXIndex);

    Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
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
**}
procedure CFNMatrixLineValueSeries.Indicator_ATR(p_Length: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    Indicator_TrueRange(p_SrcValueArray, p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End);
    Indicator_NAverage(p_Length, Self, p_TagIndex, p_TagIndex + 1, p_Begin, p_End);
    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * Bollinger Band를 계산한다.
 *
 * @param    p_Count
 * @param    p_Factor
 * @param    p_SrcValueArray
 * @param    p_PriceIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_BBand(p_Count: Integer; p_Factor: Double;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_PriceIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Index : Integer;
    f_Size  : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    Indicator_NAverage(p_Count, p_SrcValueArray, p_PriceIndex, p_TagIndex + 2);
    Indicator_StdDev(p_Count, p_SrcValueArray, p_PriceIndex, Self, p_TagIndex + 2, p_TagIndex + 3);
    for f_Index := p_Begin to p_End - 1 do
    begin
        if ((CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] <> NOT_VALUE)
            and (CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] <> NOT_VALUE)) then
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] + p_Factor * CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3];
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] - p_Factor * CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3];
        end
        else
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * Bollinger Band의 Width를 계산한다.
 *
 * @param    p_Count
 * @param    p_Factor
 * @param    p_SrcValueArray
 * @param    p_PriceIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_BBWidth(p_Count: Integer; p_Factor: Double;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_PriceIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    Indicator_NAverage(p_Count, p_SrcValueArray, p_PriceIndex, p_TagIndex + 1);
    Indicator_StdDev(p_Count, p_SrcValueArray, p_PriceIndex, Self, p_TagIndex + 1, p_TagIndex + 2);
    for f_Index := p_Begin to p_End - 1 do
    begin
        if (CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] <> NOT_VALUE) then
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
            p_Factor * CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2]
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
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
**}
procedure CFNMatrixLineValueSeries.Indicator_CCI(p_Length: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_HighIndex, p_LowIndex, p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin, p_End: Integer);
var
    f_Index : Integer;
    f_Size  : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    // M = (High + Low + Close) / 3
    for f_Index := p_Begin to p_End - 1 do
    begin
        if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE) then
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] :=
            (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex]) / 3
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;
    end;

    // m = MA(M)
    Indicator_NAverage(p_Length, Self, p_TagIndex + 0, p_TagIndex + 1, p_Begin, p_End);
    // M-m
    for f_Index := p_Begin to p_End - 1 do
    begin
        if ((CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] <> NOT_VALUE)
            and (CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] <> NOT_VALUE)) then
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] :=
            Abs(CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] - CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1])
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := NOT_VALUE;
    end;

    // d = MA(M-m)
    Indicator_NAverage(p_Length, Self, p_TagIndex + 2, p_TagIndex + 3, p_Begin, p_End);
    // CCI = (M-m) / (d * 0.015)
    for f_Index := p_Begin to p_End - 1 do
    begin
        if ((CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] <> NOT_VALUE)
            and (CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] <> NOT_VALUE)
            and (CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] <> NOT_VALUE)
            and (CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] <> NOT_VALUE)) then
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 4] := (CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] - CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1]) / (0.015 * CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3])
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 4] := NOT_VALUE;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * 종가라인시리즈를 계산한다.
 *
 * @param    p_ChartDataSeries
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_Close(p_ChartDataSeries: CFNMatrixChartDataSeries; p_Begin,
  p_End: Integer);
var
	f_Size      : Integer;
	f_Index     : Integer;
	f_ChartData : CFNMatrixChartData;
    f_Value     : CFNMatrixLineValue;
begin
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    f_Index := p_Begin;
    while (f_Index < p_End) do
    begin
        f_Value     := CFNMatrixLineValue(m_Items[f_Index]);
        f_ChartData := CFNMatrixChartData(p_ChartDataSeries.m_Items[f_Index]);

        f_Value.m_Value[0] := f_ChartData.CloseQuarkPrice;

        Inc(f_Index);
    end;

    m_ChartDataSeries := p_ChartDataSeries;
    m_Effect := true;
end;


//---------------------------------------------------------------------------
{**
 * 비교차트를 그릴 라인시리즈를 계산한다.
 *
 * @param    p_ChartDataSeries1
 * @param    p_ChartDataSeries2
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_CompareClose(p_ChartDataSeries1,
  p_ChartDataSeries2: CFNMatrixChartDataSeries; p_Begin, p_End: Integer);
var
    f_Index         : Integer;
    f_Size          : Integer;
    f_SearchIndex   : Integer;
    f_ChartData1    : CFNMatrixChartData;
    f_ChartData2    : CFNMatrixChartData;
begin
    m_Effect := false;
    f_Size := p_ChartDataSeries1.m_Items.Count;
    SetLengthSeries(f_Size);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_ChartData1 := CFNMatrixChartData(p_ChartDataSeries1.m_Items[f_Index]);
        f_SearchIndex := p_ChartDataSeries2.SearchByClose(f_ChartData1.m_OpenDateTime, true);
        if (f_SearchIndex > 0) then
        begin
            f_ChartData2 := CFNMatrixChartData(p_ChartDataSeries2.m_Items[f_SearchIndex]);
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[0] := f_ChartData2.CloseQuarkPrice;
        end
        else if (f_SearchIndex = 0) then
        begin
            f_ChartData2 := CFNMatrixChartData(p_ChartDataSeries2.m_Items[f_SearchIndex]);
            if (f_ChartData1.m_OpenDateTime < f_ChartData2.m_OpenDateTime) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[0] := NOT_VALUE;
        end
        else
            continue;
    end;

    m_StartIndex := -1;
    for f_Index := 0 to f_Size - 1 do
    begin
        if (CFNMatrixLineValue(m_Items[f_Index]).m_Value[0] <> NOT_VALUE) then
        begin
            m_StartIndex := f_Index;
            break;
        end;
    end;

    m_ChartDataSeries := p_ChartDataSeries1;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * 두 라인의 나눗셈을 계산한다.
 *
 * @param    p_SrcLineSeries1
 * @param    p_SrcIndex1
 * @param    p_SrcValueArray2
 * @param    p_SrcIndex2
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_Division(p_SrcLineSeries1: CFNMatrixLineValueSeries;
  p_SrcIndex1: Integer; p_SrcValueArray2: CFNMatrixLineValueSeries; p_SrcIndex2, p_TagIndex, p_Begin,
  p_End: Integer);
var
    f_Size  : Integer;
    f_Index : Integer;
begin
    if not Assigned(p_SrcLineSeries1) then exit;
    if not Assigned(p_SrcValueArray2) then exit;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        if ((CFNMatrixLineValue(p_SrcLineSeries1.m_Items[f_Index]).m_Value[p_SrcIndex1] <> NOT_VALUE)
            and (CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_SrcIndex2] <> NOT_VALUE)) then
        begin
            if (CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_SrcIndex2] <> 0) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CFNMatrixLineValue(p_SrcLineSeries1.m_Items[f_Index]).m_Value[p_SrcIndex1] / CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_SrcIndex2]
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
        end;
    end;

    m_ChartDataSeries := p_SrcLineSeries1.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * Envelope을 계산한다.
 *
 * @param    p_Length
 * @param    p_Factor
 * @param    p_SrcValueArray
 * @param    p_PriceIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_Envelope(p_Length: Integer; p_Factor: Double;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_PriceIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    Indicator_NAverage(p_Length, p_SrcValueArray, p_PriceIndex, p_TagIndex + 2, p_Begin, p_End);
    for f_Index := p_Begin to p_End - 1 do
    begin
        if (CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] <> NOT_VALUE) then
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] + (p_Factor / 100.0) * CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2];
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] - (p_Factor / 100.0) * CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2];
        end
        else
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
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
**}
procedure CFNMatrixLineValueSeries.Indicator_FastSTC(p_Length1, p_Length2: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin,
  p_End: Integer);
var
    f_FastKIndex    : Integer;
    f_FastDIndex    : Integer;
    f_Count         : Integer;
    f_Index         : Integer;
    f_Index2        : Integer;
    f_DHighest      : Double;
    f_DLowest       : Double;
    f_HighPrice     : Double;
    f_LowPrice      : Double;
    f_ClosePrice    : Double;
    f_Size          : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_FastKIndex := p_TagIndex;
    f_FastDIndex := p_TagIndex + 1;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    for f_Count := p_Begin to p_End - 1 do
    begin
        f_Index := f_Count - (p_Length1 - 1);
        if (f_Index >= 0) then
        begin
            if ((CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <> NOT_VALUE)
                and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <> NOT_VALUE)
                and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE)) then
            begin
                f_DHighest := MIN_VALUE;
                f_DLowest := MAX_VALUE;
                for f_Index2 := 0 to p_Length1 - 1 do
                begin
                    f_HighPrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_HighIndex];
                    f_LowPrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_LowIndex];
                    if (f_LowPrice < f_DLowest) then
                        f_DLowest := f_LowPrice;

                    if (f_HighPrice > f_DHighest) then
                        f_DHighest := f_HighPrice;
                end;

                f_ClosePrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Count]).m_Value[p_CloseIndex];
                if (f_DHighest = f_DLowest) then
                    CFNMatrixLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := 0
                else
                    CFNMatrixLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := (f_ClosePrice - f_DLowest) / (f_DHighest - f_DLowest) * 100.0;
            end;
        end
        else
            CFNMatrixLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := NOT_VALUE;
    end;

    Indicator_XAverage(p_Length2, Self, f_FastKIndex, f_FastDIndex, p_Begin, p_End);
    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_FastSTC_CrossSignal(p_Length1,
  p_Length2: Integer; p_SrcValueArray: CFNMatrixLineValueSeries; p_HighIndex,
  p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_FastKIndex    : Integer;
    f_FastDIndex    : Integer;
    f_Count         : Integer;
    f_Index         : Integer;
    f_Index2        : Integer;
    f_DHighest      : Double;
    f_DLowest       : Double;
    f_HighPrice     : Double;
    f_LowPrice      : Double;
    f_ClosePrice    : Double;
    f_Size          : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_FastKIndex := p_TagIndex + 1;
    f_FastDIndex := p_TagIndex + 2;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    for f_Count := p_Begin to p_End - 1 do
    begin
        f_Index := f_Count - (p_Length1 - 1);
        if (f_Index >= 0) then
        begin
            if ((CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <> NOT_VALUE)
                and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <> NOT_VALUE)
                and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE)) then
            begin
                f_DHighest := MIN_VALUE;
                f_DLowest := MAX_VALUE;
                for f_Index2 := 0 to p_Length1 - 1 do
                begin
                    f_HighPrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_HighIndex];
                    f_LowPrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_LowIndex];
                    if (f_LowPrice < f_DLowest) then
                        f_DLowest := f_LowPrice;

                    if (f_HighPrice > f_DHighest) then
                        f_DHighest := f_HighPrice;
                end;

                f_ClosePrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Count]).m_Value[p_CloseIndex];
                if (f_DHighest = f_DLowest) then
                    CFNMatrixLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := 0
                else
                    CFNMatrixLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := (f_ClosePrice - f_DLowest) / (f_DHighest - f_DLowest) * 100.0;
            end;
        end
        else
            CFNMatrixLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := NOT_VALUE;
    end;

    Indicator_XAverage(p_Length2, Self, f_FastKIndex, f_FastDIndex, p_Begin, p_End);

    Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
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
**}
procedure CFNMatrixLineValueSeries.Indicator_IMLine(p_Length1, p_Length2, p_Length3: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin,
  p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
    f_Count     : Integer;
    f_MaxValue  : Double;
    f_MinValue  : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_Size := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size + p_Length2);
    m_Effect := false;
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End + p_Length2 - 1 do
    begin
        if ((f_Index >= 0) and (f_Index < f_Size)) then
        begin
            f_MaxValue := HighestPrice(p_Length1, p_SrcValueArray, p_HighIndex, f_Index);
            f_MinValue := LowestPrice(p_Length1, p_SrcValueArray, p_LowIndex, f_Index);
            if ((f_MaxValue <> MIN_VALUE) and (f_MinValue <> MAX_VALUE)) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := (f_MinValue + f_MaxValue) / 2
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;

            f_MaxValue := HighestPrice(p_Length2, p_SrcValueArray, p_HighIndex, f_Index);
            f_MinValue := LowestPrice(p_Length2, p_SrcValueArray, p_LowIndex, f_Index);
            if ((f_MaxValue <> MIN_VALUE) and (f_MinValue <> MAX_VALUE)) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := (f_MinValue + f_MaxValue) / 2
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
        end
        else
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
        end;

        f_Count := f_Index - (p_Length2);
        if ((f_Count >= 0) and (f_Count < f_Size)) then
        begin
            if ((CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 0] <> NOT_VALUE)
                and (CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] <> NOT_VALUE)) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := (CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 0] + CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1]) / 2
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := NOT_VALUE;
        end
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := NOT_VALUE;

        f_Count := f_Index - (p_Length2);
        if ((f_Count >= 0) and (f_Count < f_Size)) then
        begin
            f_MaxValue := HighestPrice(p_Length3, p_SrcValueArray, p_HighIndex, f_Count);
            f_MinValue := LowestPrice(p_Length3, p_SrcValueArray, p_LowIndex, f_Count);
            if ((f_MaxValue <> MIN_VALUE) and (f_MinValue <> MAX_VALUE)) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] := (f_MinValue + f_MaxValue) / 2
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] := NOT_VALUE;
        end
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] := NOT_VALUE;

        f_Count := f_Index + (p_Length2);
        if ((f_Count >= 0) and (f_Count < f_Size)) then
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 4] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Count]).m_Value[p_CloseIndex]
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 4] := NOT_VALUE;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * LRL(Linear Regression Line)를 계산한다.
 *
 * @param    p_Count
 * @param    p_SrcValueArray
 * @param    p_SrcIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_LRL(p_Count: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_SumX      : Double;
    f_SumY      : Double;
    f_SumXX     : Double;
    f_SumXY     : Double;
    f_N         : Double;
    f_X         : Double;
    f_Y         : Double;
    f_A         : Double;
    f_B         : Double;
    f_Index     : Integer;
    f_Index2    : Integer;
    f_Size      : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

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
                f_Y := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[p_SrcIndex];
                f_SumXX := f_SumXX + (f_X * f_X);
                f_SumXY := f_SumXY + (f_X * f_Y);
                f_SumX := f_SumX + f_X;
                f_SumY := f_SumY + f_Y;
            end;

            f_B := (f_N * f_SumXY - f_SumX * f_SumY) / (f_N * f_SumXX - f_SumX * f_SumX);
            f_A := (f_SumY - f_B * f_SumX) / f_N;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_B;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := f_A;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := f_A + f_B * p_Count;
        end
        else
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := NOT_VALUE;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
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
**}
procedure CFNMatrixLineValueSeries.Indicator_MACD(p_FastMA, p_SlowMA, p_MA: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
    SetLengthSeries(p_SrcValueArray.m_Items.Count);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_End > p_SrcValueArray.m_Items.Count) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    Indicator_XAverage(p_FastMA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 0, p_Begin, p_End);
    Indicator_XAverage(p_SlowMA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 1, p_Begin, p_End);
    Indicator_Subtraction(Self, p_TagIndex + 0, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);
    Indicator_XAverage(p_MA, Self, p_TagIndex + 2, p_TagIndex + 3, p_Begin, p_End);
    Indicator_Subtraction(Self, p_TagIndex + 2, Self, p_TagIndex + 3, p_TagIndex + 4, p_Begin, p_End);
    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_CrossSignal(p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex1:Integer; p_SrcIndex2:Integer; p_TagIndex:Integer; p_Begin:Integer; p_End:Integer);
var
    f_Index:Integer;
    f_SourceLineValue:CFNMatrixLineValue;
    f_LineValue0:CFNMatrixLineValue;
    f_LineValue1:CFNMatrixLineValue;
begin
    if not Assigned(p_SrcValueArray) then exit;
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_End > p_SrcValueArray.m_Items.Count) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin

        f_LineValue0 := m_Items[f_Index  ];

        if (f_Index > 0) then
        begin

            f_LineValue1 := m_Items[f_Index-1];

            f_SourceLineValue := p_SrcValueArray.m_Items[f_Index  ];
            if  (
                    (f_SourceLineValue.m_Value[p_SrcIndex1] <> NOT_VALUE) AND
                    (f_SourceLineValue.m_Value[p_SrcIndex2] <> NOT_VALUE)
                )
            then
            begin
                if f_SourceLineValue.m_Value[p_SrcIndex1] > f_SourceLineValue.m_Value[p_SrcIndex2] then
                begin
                    f_LineValue0.m_Value[p_TagIndex] :=  1;
                end else
                if f_SourceLineValue.m_Value[p_SrcIndex1] < f_SourceLineValue.m_Value[p_SrcIndex2] then
                begin
                    f_LineValue0.m_Value[p_TagIndex] := -1;
                end else
                begin
                    f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
                end;
            end else
            begin
                f_LineValue0.m_Value[p_TagIndex] := 0;
            end;
        end else
        begin
            f_LineValue0.m_Value[p_TagIndex] := 0;
        end;
    end;

end;

procedure CFNMatrixLineValueSeries.Indicator_TrendSignal(p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer; p_End:Integer);
var
    f_Index:Integer;
    f_LineValue0:CFNMatrixLineValue;
    f_LineValue1:CFNMatrixLineValue;
    f_SrcLineValue0:CFNMatrixLineValue;
    f_SrcLineValue1:CFNMatrixLineValue;
    f_SrcLineValue2:CFNMatrixLineValue;
begin
    if not Assigned(p_SrcValueArray) then exit;
    if (p_Begin = -1) then p_Begin := 0;

    if (p_End = -1) then p_End := p_SrcValueArray.m_Items.Count;

    if (p_End > p_SrcValueArray.m_Items.Count) then p_End := p_SrcValueArray.m_Items.Count;

    if (p_Begin > m_Items.Count - 1) then p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_LineValue0 := m_Items[f_Index  ];
        if (f_Index > 1) then
        begin

            f_LineValue1 := m_Items[f_Index-1];

            f_SrcLineValue0 := p_SrcValueArray.m_Items[f_Index-0];
            f_SrcLineValue1 := p_SrcValueArray.m_Items[f_Index-1];
            f_SrcLineValue2 := p_SrcValueArray.m_Items[f_Index-2];

            if  (
                    (f_SrcLineValue0.m_Value[p_SrcIndex] <> NOT_VALUE) AND
                    (f_SrcLineValue1.m_Value[p_SrcIndex] <> NOT_VALUE) AND
                    (f_SrcLineValue2.m_Value[p_SrcIndex] <> NOT_VALUE)
                )
            then
            begin
                if  (
                        (
                            (f_SrcLineValue0.m_Value[p_SrcIndex] > f_SrcLineValue1.m_Value[p_SrcIndex]) AND
                            (f_SrcLineValue0.m_Value[p_SrcIndex] > f_SrcLineValue2.m_Value[p_SrcIndex])
                        )
                    ) then
                begin
                    f_LineValue0.m_Value[p_TagIndex] :=  1;
                end else
                if  (
                        (
                            (f_SrcLineValue0.m_Value[p_SrcIndex] < f_SrcLineValue1.m_Value[p_SrcIndex]) AND
                            (f_SrcLineValue0.m_Value[p_SrcIndex] < f_SrcLineValue2.m_Value[p_SrcIndex])
                        )
                    ) then
                begin
                    f_LineValue0.m_Value[p_TagIndex] := -1;
                end else
                begin

                    f_LineValue0.m_Value[p_TagIndex] :=  f_LineValue1.m_Value[p_TagIndex];
                end;
            end else
            begin
                f_LineValue0.m_Value[p_TagIndex] := 0;
            end;
        end else
        begin
            f_LineValue0.m_Value[p_TagIndex] := 0;
        end;
    end;
end;
procedure CFNMatrixLineValueSeries.Indicator_MACD_CrossSignal(p_FastMA, p_SlowMA, p_MA: Integer; p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
    SetLengthSeries(p_SrcValueArray.m_Items.Count);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_End > p_SrcValueArray.m_Items.Count) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    Indicator_XAverage(p_FastMA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 3, p_Begin, p_End);
    Indicator_XAverage(p_SlowMA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 4, p_Begin, p_End);
    Indicator_Subtraction(Self, p_TagIndex + 3, Self, p_TagIndex + 4, p_TagIndex + 1, p_Begin, p_End);
    Indicator_XAverage(p_MA, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);
    Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * 매물차트를 그릴 라인시리즈를 계산한다.
 *
 * @param    p_SrcValueArray1
 * @param    p_CloseIndex
 * @param    p_SrcValueArray2
 * @param    p_VolumeIndex
 * @param    p_TagIndex
**}
procedure CFNMatrixLineValueSeries.Indicator_Mamul(p_SrcValueArray1: CFNMatrixLineValueSeries;
  p_CloseIndex: Integer; p_SrcValueArray2: CFNMatrixLineValueSeries; p_VolumeIndex, p_TagIndex: Integer);
var
    f_Index     : Integer;
    f_Grade     : Integer;
    f_Size      : Integer;
    f_HighPrice : Double;
    f_LowPrice  : Double;
    f_HighLow   : Double;
    f_Sum       : Double;
    f_MaxGrade  : Integer;
begin
    if not Assigned(p_SrcValueArray1) then exit;
    if not Assigned(p_SrcValueArray2) then exit;
    f_MaxGrade := 10;
    p_SrcValueArray1.GetLineMaxMin(0, p_SrcValueArray1.m_Items.Count - 1);
    f_HighPrice := p_SrcValueArray1.m_MaxMinTable[0].m_YMax;
    f_LowPrice := p_SrcValueArray1.m_MaxMinTable[0].m_YMin;
    f_HighLow := f_HighPrice - f_LowPrice;
    SetLengthSeries(f_MaxGrade);
    for f_Grade := 0 to f_MaxGrade - 1 do
    begin
        CFNMatrixLineValue(m_Items[f_Grade]).m_Value[CFNMatrixConst.MAMUL_HIGH] := f_LowPrice + ((f_Grade + 1) * f_HighLow / f_MaxGrade);
        CFNMatrixLineValue(m_Items[f_Grade]).m_Value[CFNMatrixConst.MAMUL_LOW] := f_LowPrice + ((f_Grade + 0) * f_HighLow / f_MaxGrade);
        CFNMatrixLineValue(m_Items[f_Grade]).m_Value[CFNMatrixConst.MAMUL_VOLUME] := 0;
    end;

    f_Sum := 0;
    f_Size := p_SrcValueArray1.m_Items.Count;
    for f_Index := 0 to f_Size - 1 do
    begin
        if (CFNMatrixLineValue(p_SrcValueArray1.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE) then
        begin
            f_Grade := Math.floor((CFNMatrixLineValue(p_SrcValueArray1.m_Items[f_Index]).m_Value[p_CloseIndex] - f_LowPrice) * f_MaxGrade / f_HighLow);
            CFNMatrixLineValue(m_Items[f_Grade]).m_Value[CFNMatrixConst.MAMUL_VOLUME] := CFNMatrixLineValue(m_Items[f_Grade]).m_Value[CFNMatrixConst.MAMUL_VOLUME] + CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_VolumeIndex];
            f_Sum := f_Sum + CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_VolumeIndex];
        end;
    end;

    for f_Grade := 0 to f_MaxGrade - 1 do
    begin
        CFNMatrixLineValue(m_Items[f_Grade]).m_Value[CFNMatrixConst.MAMUL_VRATOR] := (CFNMatrixLineValue(m_Items[f_Grade]).m_Value[CFNMatrixConst.MAMUL_VOLUME] * 100.0 / f_Sum);
    end;

    m_ChartDataSeries := p_SrcValueArray1.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * 매물차트를 그릴 라인시리즈를 계산한다.
 *
 * @param    p_Grade
 * @param    p_SrcValueArray1
 * @param    p_CloseIndex
 * @param    p_SrcValueArray2
 * @param    p_VolumeIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_MamulOverlay(p_Grade: Integer;
  p_SrcValueArray1: CFNMatrixLineValueSeries; p_CloseIndex: Integer; p_SrcValueArray2: CFNMatrixLineValueSeries;
  p_VolumeIndex: Integer; p_TagIndex, p_Begin, p_End: Integer);
var
    f_Index     : Integer;
    f_Grade     : Integer;
    f_Size      : Integer;
    f_HighPrice : Double;
    f_LowPrice  : Double;
    f_HighLow   : Double;
    f_Sum       : Double;
    f_MaxGrade  : Integer;
begin
    if not Assigned(p_SrcValueArray1) then exit;
    if not Assigned(p_SrcValueArray2) then exit;

    f_Size := p_SrcValueArray1.m_Items.Count;
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > f_Size - 1) then
        p_Begin := f_Size - 1;

    if (p_Begin < 0) then p_Begin := 0;

    f_MaxGrade := p_Grade;

    f_HighPrice := MIN_VALUE;
    f_LowPrice  := MAX_VALUE;

    for f_Index := p_Begin to p_End - 1 do
    begin
        if (CFNMatrixLineValue(p_SrcValueArray1.m_Items[f_Index]).m_Value[CFNMatrixConst.PRICE_HIGH] <> NOT_VALUE) then
        begin
            if (CFNMatrixLineValue(p_SrcValueArray1.m_Items[f_Index]).m_Value[CFNMatrixConst.PRICE_HIGH] > f_HighPrice) then
                f_HighPrice := CFNMatrixLineValue(p_SrcValueArray1.m_Items[f_Index]).m_Value[CFNMatrixConst.PRICE_HIGH];
        end;

        if (CFNMatrixLineValue(p_SrcValueArray1.m_Items[f_Index]).m_Value[CFNMatrixConst.PRICE_LOW] <> NOT_VALUE) then
        begin
            if (CFNMatrixLineValue(p_SrcValueArray1.m_Items[f_Index]).m_Value[CFNMatrixConst.PRICE_LOW] < f_LowPrice) then
                f_LowPrice := CFNMatrixLineValue(p_SrcValueArray1.m_Items[f_Index]).m_Value[CFNMatrixConst.PRICE_LOW];
        end;
    end;

    f_HighLow := f_HighPrice - f_LowPrice;
    Clear;
    SetLengthSeries(f_MaxGrade);
    for f_Grade := 0 to f_MaxGrade - 1 do
    begin
        CFNMatrixLineValue(m_Items[f_Grade]).m_Value[CFNMatrixConst.MAMUL_HIGH] := f_LowPrice + ((f_Grade + 1) * f_HighLow / f_MaxGrade);
        CFNMatrixLineValue(m_Items[f_Grade]).m_Value[CFNMatrixConst.MAMUL_LOW] := f_LowPrice + ((f_Grade + 0) * f_HighLow / f_MaxGrade);
        CFNMatrixLineValue(m_Items[f_Grade]).m_Value[CFNMatrixConst.MAMUL_VOLUME] := 0;
    end;

    f_Sum := 0;
    for f_Index := p_Begin to p_End - 1 do
    begin
        if (CFNMatrixLineValue(p_SrcValueArray1.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE) then
        begin
            //f_Grade := Math.floor((CFNMatrixLineValue(p_SrcValueArray1.m_Items[f_Index]).m_Value[p_CloseIndex] - f_LowPrice) * f_MaxGrade / f_HighLow)
            //:[]2009.09.18 Math.Floor 0 값을 넘기면 오류발생하므로
            if (CFNMatrixLineValue(p_SrcValueArray1.m_Items[f_Index]).m_Value[p_CloseIndex] - f_LowPrice) <> 0 then
                f_Grade := Math.floor((CFNMatrixLineValue(p_SrcValueArray1.m_Items[f_Index]).m_Value[p_CloseIndex] - f_LowPrice) * f_MaxGrade / f_HighLow)
            else
                f_Grade := 0;

            if (f_Grade > f_MaxGrade-1) then
                f_Grade := f_MaxGrade-1;

            if (f_Grade < 0) then
                f_Grade := 0;

            CFNMatrixLineValue(m_Items[f_Grade]).m_Value[CFNMatrixConst.MAMUL_VOLUME] := CFNMatrixLineValue(m_Items[f_Grade]).m_Value[CFNMatrixConst.MAMUL_VOLUME] + CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_VolumeIndex];
            f_Sum := f_Sum + CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_VolumeIndex];
        end;
    end;

    for f_Grade := 0 to f_MaxGrade - 1 do
    begin
        CFNMatrixLineValue(m_Items[f_Grade]).m_Value[CFNMatrixConst.MAMUL_VRATOR] := (CFNMatrixLineValue(m_Items[f_Grade]).m_Value[CFNMatrixConst.MAMUL_VOLUME] * 100.0 / f_Sum);
    end;

    m_ChartDataSeries := p_SrcValueArray1.m_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_MA_CrossSignal(p_FastMA,
  p_SlowMA: Integer; p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex,
  p_TagIndex, p_Begin, p_End: Integer);
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
    SetLengthSeries(p_SrcValueArray.m_Items.Count);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_End > p_SrcValueArray.m_Items.Count) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    Indicator_NAverage(p_FastMA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 1);
    Indicator_NAverage(p_SlowMA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 2);
    Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_NMA_TrendSignal(p_MA: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin,
  p_End: Integer);
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
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
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_WMA_TrendSignal(p_MA: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin,
  p_End: Integer);
begin
    if not Assigned(p_SrcValueArray) then exit;

    m_Effect := false;

    SetLengthSeries(p_SrcValueArray.m_Items.Count);

    if (p_Begin = -1) then p_Begin := 0;
    if (p_End = -1) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_End > p_SrcValueArray.m_Items.Count) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_Begin > m_Items.Count - 1) then p_Begin := m_Items.Count - 1;
    if (p_Begin < 0) then p_Begin := 0;

    Indicator_WAverage3(p_MA, 6, p_SrcValueArray, p_SrcIndex, p_TagIndex + 1);
    Indicator_TrendSignal(Self, p_TagIndex + 1, p_TagIndex + 0, p_Begin, p_End);

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_XMA_TrendSignal(p_MA: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin,
  p_End: Integer);
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
    SetLengthSeries(p_SrcValueArray.m_Items.Count);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_End > p_SrcValueArray.m_Items.Count) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    Indicator_XAverage(p_MA, p_SrcValueArray, p_SrcIndex, p_TagIndex + 1);
    Indicator_TrendSignal(Self, p_TagIndex + 1, p_TagIndex + 0, p_Begin, p_End);

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * 단순이동평균을 계산한다.
 *
 * @param    p_Count
 * @param    p_SrcValueArray
 * @param    p_SrcIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_NAverage(p_Count: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_Index1    : Integer;
    f_Sum       : Double;
    f_AllEffect : Boolean;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_AllEffect := false;
    m_Effect    := false;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        if (f_Index < p_Count - 1) then
            continue;

        if (f_Index < 1) then
            continue;

        if (CFNMatrixLineValue(m_Items[f_Index-1]).m_Value[p_TagIndex] = NOT_VALUE) then
        begin
            if (not f_AllEffect) then
            begin
                f_AllEffect := (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_SrcIndex] <> NOT_VALUE);
                if (f_AllEffect) then
                begin
                    f_Index1 := 0;
                    f_Sum := 0;
                    while (f_Index1 < p_Count) do
                    begin
                        f_Sum := f_Sum + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];

                        Inc(f_Index1);
                    end;

                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / p_Count;
                end;

                continue;
            end;
        end
        else if (f_Index >= p_Count) then
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] * p_Count + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] - CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Count]).m_Value[p_SrcIndex]) / p_Count;
        end else
        begin
            continue;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_NAverage2(p_Count: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_Index1    : Integer;
    f_Sum       : Double;
    f_AllEffect : Boolean;
    f_Count     : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_AllEffect := false;
    m_Effect    := false;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        if (f_Index < 1) then continue;

        if ((f_Index < p_Count - 1) or (f_Index < 1)) then
        begin
            f_Count := f_Index + 1;
            f_Sum := 0;
            for f_Index1 := 0 to f_Count - 1 do
            begin
                f_Sum := f_Sum + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
            end;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_Count;
        end else
        begin
            if (CFNMatrixLineValue(m_Items[f_Index-1]).m_Value[p_TagIndex] = NOT_VALUE) then
            begin
                if (not f_AllEffect) then
                begin
                    f_AllEffect := (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_SrcIndex] <> NOT_VALUE);
                    if (f_AllEffect) then
                    begin
                        f_Index1 := 0;
                        f_Sum := 0;
                        while (f_Index1 < p_Count) do
                        begin
                            f_Sum := f_Sum + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];

                            Inc(f_Index1);
                        end;

                        CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / p_Count;
                    end;

                    continue;
                end;
            end
            else if (f_Index >= p_Count) then
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] * p_Count + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] - CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Count]).m_Value[p_SrcIndex]) / p_Count;
            end else
            begin
                continue;
            end;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_NAverageZ(p_Count: Integer; p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_Index1    : Integer;
    f_Sum       : Double;
    f_AllEffect : Boolean;
    f_Value     : Double;
    f_IDX     : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_AllEffect := false;
    m_Effect    := false;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        if (f_Index < 1) then continue;

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
                    f_Value := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_IDX]).m_Value[p_SrcIndex];
                end;
                f_Sum := f_Sum + f_Value;
            end;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / p_Count;
        end else
        begin
            if (CFNMatrixLineValue(m_Items[f_Index-1]).m_Value[p_TagIndex] = NOT_VALUE) then
            begin
                if (not f_AllEffect) then
                begin
                    f_AllEffect := (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_SrcIndex] <> NOT_VALUE);
                    if (f_AllEffect) then
                    begin
                        f_Index1 := 0;
                        f_Sum := 0;
                        while (f_Index1 < p_Count) do
                        begin
                            f_Sum := f_Sum + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];

                            Inc(f_Index1);
                        end;

                        CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / p_Count;
                    end;

                    continue;
                end;
            end
            else if (f_Index >= p_Count) then
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] * p_Count + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] - CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Count]).m_Value[p_SrcIndex]) / p_Count;
            end else
            begin
                continue;
            end;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
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
**}
procedure CFNMatrixLineValueSeries.Indicator_NET(p_SmallMA, p_Increse, p_Count: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Index : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
    SetLengthSeries(p_SrcValueArray.m_Items.Count);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_End > p_SrcValueArray.m_Items.Count) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := 0 to p_Count - 1 do
    begin
        Indicator_XAverage(p_SmallMA + f_Index * p_Increse, p_SrcValueArray, p_SrcIndex, p_TagIndex + f_Index, p_Begin, p_End);
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * 단순이동평균을 근사치로 계산한다.
 *
 * @param    p_Count
 * @param    p_SrcValueArray
 * @param    p_SrcIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_NXAverage(p_Count: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_Index1    : Integer;
    f_Sum       : Double;
    f_AllEffect : Boolean;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_AllEffect := false;
    m_Effect    := false;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        if ((f_Index < p_Count - 1) or (f_Index < 1)) then
            continue;

        if (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] <> NOT_VALUE) then
            f_AllEffect := true;

        if (not f_AllEffect) then
        begin
            f_AllEffect := (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_SrcIndex] <> NOT_VALUE);
            if (f_AllEffect) then
            begin
                f_Sum := 0;
                for f_Index1 := 0 to p_Count - 1 do
                begin
                    f_Sum := f_Sum + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
                end;

                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / p_Count;
            end;

            continue;
        end;

        CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] - CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] / p_Count + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] / p_Count;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * OBV(On Balance Volume)를 계산한다.
 *
 * @param    p_SrcValueArray
 * @param    p_CloseIndex
 * @param    p_SrcValueArray2
 * @param    p_VolumeIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_OBV(p_SrcValueArray: CFNMatrixLineValueSeries;
  p_CloseIndex: Integer; p_SrcValueArray2: CFNMatrixLineValueSeries; p_VolumeIndex, p_TagIndex, p_Begin,
  p_End: Integer);
var
    f_Count     : Integer;
    f_Index     : Integer;
    f_Size      : Integer;
    f_mount     : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    f_mount := 0;
    for f_Index := p_Begin to p_End - 1 do
    begin
        if (f_Index > 1) then
        begin
            if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] > CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_CloseIndex]) then
                f_mount := f_mount + CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_VolumeIndex]
            else if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] < CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_CloseIndex]) then
                f_mount := f_mount - CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_VolumeIndex]
            else
                f_mount := f_mount;

            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_mount;
        end
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_TotalProfit(p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_PriceIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
var
    f_Index:Integer;
    f_LineValue0:CFNMatrixLineValue;
    f_LineValue1:CFNMatrixLineValue;
    f_SrcLineValue0:CFNMatrixLineValue;
    f_SrcLineValue1:CFNMatrixLineValue;
    f_SrcLineValue2:CFNMatrixLineValue;
    f_Close0, f_Close1:Double;
    f_BarCount, f_X1, f_X0 : Integer;
begin
    if (p_Begin = -1) then p_Begin := 0;
    if (p_End = -1) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_End > p_SrcValueArray.m_Items.Count) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_Begin > m_Items.Count - 1) then p_Begin := m_Items.Count - 1;
    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];
        f_Close0 := f_SrcLineValue0.m_Value[p_PriceIndex];

        f_LineValue0 := m_Items[f_Index  ];
        if f_Index > 0 then
        begin
            f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index-1];
            f_Close1 := f_SrcLineValue1.m_Value[p_PriceIndex];

            f_LineValue1 := m_Items[f_Index-1];
            if (f_SrcLineValue1.m_Value[p_SignalIndex] <> NOT_VALUE) then
            begin
                //  매수 거래일 경우
                if (f_SrcLineValue1.m_Value[p_SignalIndex] > 0) then
                begin
                    f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex] + (f_Close0 - f_Close1);
                end else
                //  매도 거래일 경우
                if (f_SrcLineValue1.m_Value[p_SignalIndex] < 0) then
                begin
                    f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex] - (f_Close0 - f_Close1);
                end else
                begin
                    f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
                end;
            end else
            begin
                f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
            end;
        end else
        begin
            f_LineValue0.m_Value[p_TagIndex] := 0;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_TotalProfit_Close(p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
var
    f_Index:Integer;
    f_LineValue0:CFNMatrixLineValue;
    f_LineValue1:CFNMatrixLineValue;
    f_SrcLineValue0:CFNMatrixLineValue;
    f_SrcLineValue1:CFNMatrixLineValue;
begin
    if (p_Begin = -1) then p_Begin := 0;
    if (p_End = -1) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_End > p_SrcValueArray.m_Items.Count) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_Begin > m_Items.Count - 1) then p_Begin := m_Items.Count - 1;
    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];

        f_LineValue0 := m_Items[f_Index  ];
        if f_Index > 0 then
        begin
            f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index-1];

            f_LineValue1 := m_Items[f_Index-1];

            if (f_SrcLineValue1.m_Value[p_SignalIndex] < 0) AND (f_SrcLineValue0.m_Value[p_SignalIndex] >= 0) then
            begin
                f_LineValue0.m_Value[p_TagIndex] := f_LineValue0.m_Value[p_SrcIndex];
            end else
            if (f_SrcLineValue1.m_Value[p_SignalIndex] > 0) AND (f_SrcLineValue0.m_Value[p_SignalIndex] <= 0) then
            begin
                f_LineValue0.m_Value[p_TagIndex] := f_LineValue0.m_Value[p_SrcIndex];
            end else
            begin
                f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
            end;
        end else
        begin
            f_LineValue0.m_Value[p_TagIndex] := 0;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_TotalProfit_Close_Buy(p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
var
    f_Index:Integer;
    f_LineValue0:CFNMatrixLineValue;
    f_LineValue1:CFNMatrixLineValue;
    f_SrcLineValue0:CFNMatrixLineValue;
    f_SrcLineValue1:CFNMatrixLineValue;
begin
    if (p_Begin = -1) then p_Begin := 0;
    if (p_End = -1) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_End > p_SrcValueArray.m_Items.Count) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_Begin > m_Items.Count - 1) then p_Begin := m_Items.Count - 1;
    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];

        f_LineValue0 := m_Items[f_Index  ];
        if f_Index > 0 then
        begin
            f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index-1];

            f_LineValue1 := m_Items[f_Index-1];

            if (f_SrcLineValue1.m_Value[p_SignalIndex] > 0) AND (f_SrcLineValue0.m_Value[p_SignalIndex] <= 0) then
            begin
                f_LineValue0.m_Value[p_TagIndex] := f_LineValue0.m_Value[p_SrcIndex];
            end else
            begin
                f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
            end;
        end else
        begin
            f_LineValue0.m_Value[p_TagIndex] := 0;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_TotalProfit_Close_Sell(p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
var
    f_Index:Integer;
    f_LineValue0:CFNMatrixLineValue;
    f_LineValue1:CFNMatrixLineValue;
    f_SrcLineValue0:CFNMatrixLineValue;
    f_SrcLineValue1:CFNMatrixLineValue;
begin
    if (p_Begin = -1) then p_Begin := 0;
    if (p_End = -1) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_End > p_SrcValueArray.m_Items.Count) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_Begin > m_Items.Count - 1) then p_Begin := m_Items.Count - 1;
    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];

        f_LineValue0 := m_Items[f_Index  ];
        if f_Index > 0 then
        begin
            f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index-1];

            f_LineValue1 := m_Items[f_Index-1];

            if (f_SrcLineValue1.m_Value[p_SignalIndex] < 0) AND (f_SrcLineValue0.m_Value[p_SignalIndex] >= 0) then
            begin
                f_LineValue0.m_Value[p_TagIndex] := f_LineValue0.m_Value[p_SrcIndex];
            end else
            begin
                f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
            end;
        end else
        begin
            f_LineValue0.m_Value[p_TagIndex] := 0;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_TotalProfit_Buy (p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_PriceIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
var
    f_Index:Integer;
    f_LineValue0:CFNMatrixLineValue;
    f_LineValue1:CFNMatrixLineValue;
    f_SrcLineValue0:CFNMatrixLineValue;
    f_SrcLineValue1:CFNMatrixLineValue;
    f_SrcLineValue2:CFNMatrixLineValue;
    f_Close0, f_Close1:Double;
    f_BarCount, f_X1, f_X0 : Integer;
begin
    if (p_Begin = -1) then p_Begin := 0;
    if (p_End = -1) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_End > p_SrcValueArray.m_Items.Count) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_Begin > m_Items.Count - 1) then p_Begin := m_Items.Count - 1;
    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];
        f_Close0 := f_SrcLineValue0.m_Value[p_PriceIndex];

        f_LineValue0 := m_Items[f_Index  ];
        if f_Index > 0 then
        begin
            f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index-1];
            f_Close1 := f_SrcLineValue1.m_Value[p_PriceIndex];

            f_LineValue1 := m_Items[f_Index-1];
            if (f_SrcLineValue1.m_Value[p_SignalIndex] <> NOT_VALUE) then
            begin
                //  매수 거래일 경우
                if (f_SrcLineValue1.m_Value[p_SignalIndex] > 0) then
                begin
                    f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex] + (f_Close0 - f_Close1);
                end else
                begin
                    f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
                end;
            end else
            begin
                f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
            end;
        end else
        begin
            f_LineValue0.m_Value[p_TagIndex] := 0;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_TotalProfit_Sell(p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_PriceIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
var
    f_Index:Integer;
    f_LineValue0:CFNMatrixLineValue;
    f_LineValue1:CFNMatrixLineValue;
    f_SrcLineValue0:CFNMatrixLineValue;
    f_SrcLineValue1:CFNMatrixLineValue;
    f_SrcLineValue2:CFNMatrixLineValue;
    f_Close0, f_Close1:Double;
    f_BarCount, f_X1, f_X0 : Integer;
begin
    if (p_Begin = -1) then p_Begin := 0;
    if (p_End = -1) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_End > p_SrcValueArray.m_Items.Count) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_Begin > m_Items.Count - 1) then p_Begin := m_Items.Count - 1;
    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];
        f_Close0 := f_SrcLineValue0.m_Value[p_PriceIndex];

        f_LineValue0 := m_Items[f_Index  ];
        if f_Index > 0 then
        begin
            f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index-1];
            f_Close1 := f_SrcLineValue1.m_Value[p_PriceIndex];

            f_LineValue1 := m_Items[f_Index-1];
            if (f_SrcLineValue1.m_Value[p_SignalIndex] <> NOT_VALUE) then
            begin
                //  매도 거래일 경우
                if (f_SrcLineValue1.m_Value[p_SignalIndex] < 0) then
                begin
                    f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex] - (f_Close0 - f_Close1);
                end else
                begin
                    f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
                end;
            end else
            begin
                f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
            end;
        end else
        begin
            f_LineValue0.m_Value[p_TagIndex] := 0;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_LastProfit(p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_PriceIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
var
    f_Index:Integer;
    f_LineValue0:CFNMatrixLineValue;
    f_LineValue1:CFNMatrixLineValue;
    f_SrcLineValue0:CFNMatrixLineValue;
    f_SrcLineValue1:CFNMatrixLineValue;
    f_SrcLineValue2:CFNMatrixLineValue;
    f_Close0, f_Close1:Double;
    f_X1, f_X0 : Integer;
    f_OldValue:Double;
begin
    if (p_Begin = -1) then p_Begin := 0;
    if (p_End = -1) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_End > p_SrcValueArray.m_Items.Count) then p_End := p_SrcValueArray.m_Items.Count;
    if (p_Begin > m_Items.Count - 1) then p_Begin := m_Items.Count - 1;
    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];
        f_Close0 := f_SrcLineValue0.m_Value[p_PriceIndex];

        f_LineValue0 := m_Items[f_Index  ];
        if f_Index > 0 then
        begin
            f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index-1];
            f_Close1 := f_SrcLineValue1.m_Value[p_PriceIndex];

            f_LineValue1 := m_Items[f_Index-1];

            if (f_SrcLineValue1.m_Value[p_SignalIndex] <> NOT_VALUE) then
            begin

                if
                    (f_SrcLineValue0.m_Value[p_SignalIndex] <> f_SrcLineValue1.m_Value[p_SignalIndex]) and
                    (
                        (f_SrcLineValue0.m_Value[p_SignalIndex] > 0) or
                        (f_SrcLineValue0.m_Value[p_SignalIndex] < 0)
                    )
                then
                begin
                    f_OldValue := 0;
                end else
                begin
                    f_OldValue := f_LineValue1.m_Value[p_TagIndex];
                end;

                //  매수 거래일 경우
                if (f_SrcLineValue1.m_Value[p_SignalIndex] > 0) then
                begin
                    f_LineValue0.m_Value[p_TagIndex] := f_OldValue + (f_Close0 - f_Close1);
                end else
                //  매도 거래일 경우
                if (f_SrcLineValue1.m_Value[p_SignalIndex] < 0) then
                begin
                    f_LineValue0.m_Value[p_TagIndex] := f_OldValue - (f_Close0 - f_Close1);
                end else
                begin
                    f_LineValue0.m_Value[p_TagIndex] := f_OldValue;
                end;
            end else
            begin
                f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
            end;
        end else
        begin
            f_LineValue0.m_Value[p_TagIndex] := 0;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_RecentProfit(p_Min:Integer;p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_TotalProfitIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
var
    f_Index:Integer;
    f_LineValue0:CFNMatrixLineValue;
    f_LineValue1:CFNMatrixLineValue;
    f_SrcLineValue0:CFNMatrixLineValue;
    f_SrcLineValue1:CFNMatrixLineValue;
    f_SrcLineValue2:CFNMatrixLineValue;
    f_Close0, f_Close1:Double;
    f_BarCount, f_X1, f_X0 : Integer;
begin
    if (m_ChartDataSeries.m_TimeFrame >= 9000) then
    begin
        f_BarCount := ((p_Min * 60) div (m_ChartDataSeries.m_TimeFrame-9000));
    end else
    if (m_ChartDataSeries.m_TimeFrame < 360) then
    begin
        f_BarCount := ((p_Min * 60) div (m_ChartDataSeries.m_TimeFrame * 60));
    end else
    begin
        f_BarCount := 0;
    end;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];
        f_LineValue0 := m_Items[f_Index  ];
        if f_Index - f_BarCount > 0 then
        begin
            f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index-f_BarCount];
            f_LineValue1 := m_Items[f_Index-f_BarCount];

            f_LineValue0.m_Value[p_TagIndex] := f_SrcLineValue0.m_Value[p_TotalProfitIndex] - f_SrcLineValue1.m_Value[p_TotalProfitIndex];
        end else
        begin
            f_LineValue0.m_Value[p_TagIndex] := f_SrcLineValue0.m_Value[p_TotalProfitIndex];
        end;
    end;
end;
//---------------------------------------------------------------------------
{**
 * P&F차트를 그릴 라인시리즈를 계산한다.
 *
 * @param    p_SrcValueArray
 * @param    p_PriceIndex
 * @param    p_TagIndex
**}
procedure CFNMatrixLineValueSeries.Indicator_PF(p_SrcValueArray: CFNMatrixLineValueSeries; p_PriceIndex, p_TagIndex: Integer);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_Deep      : Integer;
    f_MaxCount  : Integer;
    f_Step      : Integer;
    f_SmallStep : Integer;
    f_Sign      : Double;
    f_ClosePrice1   : Double;
    f_ClosePrice0   : Double;
    f_ChangePrice1  : Double;
    f_ChangePrice0  : Double;
    f_Value     : CFNMatrixLineValue;
    f_done      : Boolean;
    f_OverFlow  : Boolean;
    f_Count     : Integer;
    f_Inc       : Integer;
    f_Loop      : Integer;
    f_Find      : Integer;
    f_X         : Double;
    f_Y         : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_done := false;
    f_Deep := 3;
    p_SrcValueArray.GetLineMaxMin(0, p_SrcValueArray.m_Items.Count - 1);
    f_Step := Round((p_SrcValueArray.m_MaxMinTable[0].m_YMax - p_SrcValueArray.m_MaxMinTable[0].m_YMin) * 0.02);
    if (f_Step > 1000) then
        f_Step := Round(f_Step / 100) * 100
    else if (f_Step > 100) then
        f_Step := Round(f_Step / 10) * 10
    else
        f_done := false; //if문에서  else if 다음에 else문이없을경우에 마지막 else if 문에 걸린다...그래서 의미없는 else문을추가하였다

    if (f_Step = 0) then f_Step := 100;

    f_Find := 0;
    while (not f_done) do
    begin
        f_Size := p_SrcValueArray.m_Items.Count;
        SetLengthSeries(0);
        f_OverFlow := false;
        f_X := 0;
        f_Y := 0;
        f_ClosePrice0 := CFNMatrixLineValue(p_SrcValueArray.m_Items[0]).m_Value[p_PriceIndex];
        f_ClosePrice1 := f_ClosePrice0;
        f_MaxCount := 0;
        f_ChangePrice1 := 0.0;
        for f_Index := 1 to f_Size - 1 do
        begin
            if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PriceIndex] <> NOT_VALUE) then
            begin
                f_ClosePrice0 := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PriceIndex];
                f_ChangePrice0 := f_ClosePrice0 - f_ClosePrice1;
                f_Sign := (f_ChangePrice1 * f_ChangePrice0);
                f_Count := Abs(Round(f_ChangePrice0 / f_Step));
                if (f_Count > f_Deep) then
                begin
                    //f_Inc = (f_ChangePrice0 > 0) ? 1 : -1;
                    if (f_ChangePrice0 > 0) then
                        f_Inc := 1
                    else
                        f_Inc := -1;

                    if (f_Sign < 0) then
                    begin
                        f_X := f_X + 1;
                        f_Y := f_Y + (f_Inc * 2);
                    end;

                    for f_Loop := 0 to f_Count - 1 do
                    begin
                        f_Value := CFNMatrixLineValue.Create(m_LineCount);
                        f_Value.m_Value[CFNMatrixConst.PCLOSE] := f_Index;
                        //f_Value.m_Value[CFNMatrixConst.PSIGN] := (f_ChangePrice0 > 0) ? 1 : -1;
                        if (f_ChangePrice0 > 0) then
                            f_Value.m_Value[CFNMatrixConst.PSIGN] := 1
                        else
                            f_Value.m_Value[CFNMatrixConst.PSIGN] := -1;
                        f_Value.m_Value[CFNMatrixConst.PX] := f_X;
                        f_Value.m_Value[CFNMatrixConst.PY] := f_Y;
                        m_Items.Add(f_Value);
                        Inc(f_MaxCount);
                        f_Y := f_Y + f_Inc;
                    end;

                    f_ClosePrice1 := f_ClosePrice0;
                    f_ChangePrice1 := f_ChangePrice0;
                end;

                if (f_MaxCount > 1000) then
                begin
                    f_OverFlow := true;
                    break;
                end;
            end;
        end;

        f_SmallStep := Round(f_Step / 10);
        if (f_SmallStep = 0) then
            f_SmallStep := 1;

        if (f_OverFlow) then
            f_Step := f_Step + f_SmallStep
        else if (f_MaxCount = 0) then
            f_Step := f_Step - f_SmallStep
        else
            f_done := true;

        Inc(f_Find);
        if ((not f_OverFlow) and (f_Find > 1000)) then
            f_done := true;
    end;

    m_Options[0] := f_Step;
    m_Options[1] := f_Deep;
    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * PMAO(Price Oscillator)를 계산한다.
 *
 * @param    p_Length1
 * @param    p_Length2
 * @param    p_SrcValueArray
 * @param    p_SrcIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_PMAO(p_Length1, p_Length2: Integer; p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex: Integer; p_Begin, p_End: Integer);
var
    f_Index     :Integer;
    f_Size      :Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_Size := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    m_Effect := false;
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_End > p_SrcValueArray.m_Items.Count) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    Indicator_XAverage(p_Length1, p_SrcValueArray, p_SrcIndex, p_TagIndex + 0, p_Begin, p_End);
    Indicator_XAverage(p_Length2, p_SrcValueArray, p_SrcIndex, p_TagIndex + 1, p_Begin, p_End);
    for f_Index := p_Begin to p_End - 1 do
    begin
        if  (
                (CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] <> NOT_VALUE) AND
                (CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] <> NOT_VALUE)
            )
        then
        begin
            if CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] = 0 then
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := 0;
            end else
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] :=
                (
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] -
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1]
                ) * 100.0 /
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0];
            end;
        end else
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := NOT_VALUE;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * PMDI를 계산한다. 이것은 DMI와 ADX를 계산하기 위해 필요하다.
 *
 * @param    p_Length
 * @param    p_SrcValueArray
 * @param    p_SrcIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_PMDI(p_Length: Integer; p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_PDMIndex      : Integer;
    f_MDMIndex      : Integer;
    f_TRIndex       : Integer;
    f_PDIIndex      : Integer;
    f_MDIIndex      : Integer;
    f_PDMSUMIndex   : Integer;
    f_MDMSUMIndex   : Integer;
    f_TRSUMIndex    : Integer;
    f_Index2        : Integer;
    f_Index         : Integer;
    f_Size          : Integer;
    f_TRSum         : Double;
    f_PDMSum        : Double;
    f_MDMSum        : Double;
    f_AllEffect     : Boolean;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_AllEffect     := false;
    m_Effect        := false;
    f_PDMIndex      := p_SrcIndex + 0;
    f_MDMIndex      := p_SrcIndex + 1;
    f_TRIndex       := p_SrcIndex + 2;
    f_PDIIndex      := p_TagIndex;
    f_MDIIndex      := p_TagIndex + 1;
    f_PDMSUMIndex   := p_TagIndex + 2;
    f_MDMSUMIndex   := p_TagIndex + 3;
    f_TRSUMIndex    := p_TagIndex + 4;
    f_Size          := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_PDMSUMIndex] := NOT_VALUE;
        CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_MDMSUMIndex] := NOT_VALUE;
        CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_TRSUMIndex]  := NOT_VALUE;
        CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_PDIIndex]    := NOT_VALUE;
        CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_MDIIndex]    := NOT_VALUE;
        if (f_Index - p_Length + 1 <= 0) then
            continue;

        if (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_TRSUMIndex] <> NOT_VALUE) then
            f_AllEffect := true;

        if (not f_AllEffect) then
        begin
            if ((CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + 1]).m_Value[f_PDMIndex] <> NOT_VALUE)
                and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + 1]).m_Value[f_MDMIndex] <> NOT_VALUE)
                and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + 1]).m_Value[f_TRIndex] <> NOT_VALUE)) then
                f_AllEffect := true
            else
                f_AllEffect := false;

            if (f_AllEffect) then
            begin
                f_PDMSum := 0;
                f_MDMSum := 0;
                f_TRSum := 0;
                for f_Index2 := 0 to p_Length - 1 do
                begin
                    f_PDMSum := f_PDMSum + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[f_PDMIndex];
                    f_MDMSum := f_MDMSum + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[f_MDMIndex];
                    f_TRSum := f_TRSum + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[f_TRIndex];
                end;

                CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_PDMSUMIndex] := f_PDMSum;
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_MDMSUMIndex] := f_MDMSum;
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_TRSUMIndex] := f_TRSum;
                if (f_TRSum <> 0) then
                begin
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_PDIIndex] := f_PDMSum / f_TRSum * 100.0;
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_MDIIndex] := f_MDMSum / f_TRSum * 100.0;
                end
                else
                begin
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_PDIIndex] := 0;
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_MDIIndex] := 0;
                end;
            end;
        end
        else
        begin
            f_TRSum := CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_TRSUMIndex] - (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_TRSUMIndex] / p_Length) + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[f_TRIndex];
            f_PDMSum := CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_PDMSUMIndex] - (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_PDMSUMIndex] / p_Length) + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[f_PDMIndex];
            f_MDMSum := CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_MDMSUMIndex] - (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_MDMSUMIndex] / p_Length) + CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[f_MDMIndex];
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_PDMSUMIndex] := f_PDMSum;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_MDMSUMIndex] := f_MDMSum;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_TRSUMIndex] := f_TRSum;
            if (f_TRSum <> 0) then
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_PDIIndex] := 100 * f_PDMSum / f_TRSum;
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_MDIIndex] := 100 * f_MDMSum / f_TRSum;
            end
            else
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_PDIIndex] := 0;
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_MDIIndex] := 0;
            end;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * PMDM을 계산한다. 이 것은 DMI와 ADX를 계산하기 위해 필요한다.
 *
 * @param    p_SrcValueArray
 * @param    p_HighIndex
 * @param    p_LowIndex
 * @param    p_CloseIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_PMDM(p_SrcValueArray: CFNMatrixLineValueSeries; p_HighIndex,
  p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Index         : Integer;
    f_Size          : Integer;
    f_PDMIndex      : Integer;
    f_MDMIndex      : Integer;
    f_PlusDM        : Double;
    f_MinusDM       : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect    := false;
    f_PDMIndex  := p_TagIndex;
    f_MDMIndex  := p_TagIndex + 1;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        if ((f_Index >= 1) and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <> NOT_VALUE)
                            and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <> NOT_VALUE)
                            and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE)) then
        begin
            if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] < CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_HighIndex]) then
                f_PlusDM := 0
            else
                f_PlusDM := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] - CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_HighIndex];

            if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] > CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_LowIndex]) then
                f_MinusDM := 0
            else
                f_MinusDM := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_LowIndex] - CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex];

            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_PDMIndex] := f_PlusDM;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_MDMIndex] := f_MinusDM;
        end
        else
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_PDMIndex] := NOT_VALUE;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_MDMIndex] := NOT_VALUE;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_Price(p_ChartDataSeries: CFNMatrixChartDataSeries; p_Begin, p_End: Integer);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_ChartData : CFNMatrixChartData;
    f_Value     : CFNMatrixLineValue;
begin
    m_Effect    := false;
    f_Size      := p_ChartDataSeries.m_Items.Count;
    SetLengthSeries(p_ChartDataSeries.m_Items.Count);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_Value             := CFNMatrixLineValue(m_Items[f_Index]);
        f_ChartData         := CFNMatrixChartData(p_ChartDataSeries.m_Items[f_Index]);
        f_Value.m_Value[0]  := f_ChartData.OpenQuarkPrice;
        f_Value.m_Value[1]  := f_ChartData.HighQuarkPrice;
        f_Value.m_Value[2]  := f_ChartData.LowQuarkPrice;
        f_Value.m_Value[3]  := f_ChartData.CloseQuarkPrice;
        f_Value.m_Value[4]  := f_ChartData.m_Volume;
    end;

    m_ChartDataSeries := p_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_RealPrice(p_ChartDataSeries: CFNMatrixChartDataSeries; p_Begin, p_End: Integer);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_ChartData : CFNMatrixChartData;
    f_LineValue0:CFNMatrixLineValue;
    f_LineValue1:CFNMatrixLineValue;
begin
    m_Effect    := false;
    f_Size      := p_ChartDataSeries.m_Items.Count;
    SetLengthSeries(p_ChartDataSeries.m_Items.Count);

    if (p_Begin = -1) then p_Begin := 0;
    if (p_End = -1) then p_End := f_Size;
    if (p_End > f_Size) then p_End := f_Size;
    if (p_Begin > m_Items.Count - 1) then p_Begin := m_Items.Count - 1;
    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_LineValue0 := CFNMatrixLineValue(m_Items[f_Index]);
        f_ChartData := CFNMatrixChartData(p_ChartDataSeries.m_Items[f_Index]);

        f_LineValue0.m_Value[0]  := f_ChartData.OpenRealPrice;
        f_LineValue0.m_Value[1]  := f_ChartData.HighRealPrice;
        f_LineValue0.m_Value[2]  := f_ChartData.LowRealPrice;
        f_LineValue0.m_Value[3]  := f_ChartData.CloseRealPrice;
        f_LineValue0.m_Value[4]  := 0;
(*
        if f_Index > 0 then
        begin
            f_LineValue1 := CFNMatrixLineValue(m_Items[f_Index-1]);
            f_LineValue0.m_Value[0] :=  f_LineValue1.m_Value[3];

            if f_LineValue0.m_Value[1] < f_LineValue0.m_Value[0] then f_LineValue0.m_Value[1] := f_LineValue0.m_Value[0];
            if f_LineValue0.m_Value[2] > f_LineValue0.m_Value[0] then f_LineValue0.m_Value[2] := f_LineValue0.m_Value[0];
        end;
*)
    end;

    m_ChartDataSeries := p_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_Price_MA_CrossSignal(p_MA: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin,
  p_End: Integer);
var
    f_Size      : Integer;
    f_Index:Integer;
    f_SourceLineValue:CFNMatrixLineValue;
    f_LineValue:CFNMatrixLineValue;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect    := false;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(p_SrcValueArray.m_Items.Count);

    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_End > p_SrcValueArray.m_Items.Count) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_LineValue := m_Items[f_Index  ];
        f_SourceLineValue := p_SrcValueArray.m_Items[f_Index  ];
        f_LineValue.m_Value[p_TagIndex + 1] := f_SourceLineValue.m_Value[p_SrcIndex];
    end;
    Indicator_NAverage(p_MA, Self, p_TagIndex + 1, p_TagIndex + 2);
    Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * 투자심리선(Psychogical Line)을 계산한다.
 *
 * @param    p_Length
 * @param    p_SrcValueArray
 * @param    p_PriceIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_PSY(p_Length: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_PriceIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
    f_Index2    : Integer;
    f_PSY       : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        if (f_Index - p_Length >= 0) then
        begin
            f_PSY := 0;
            f_Index2 := 1;
            while (f_Index2 <= p_Length) do
            begin
                if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + f_Index2 - 1]).m_Value[p_PriceIndex] < CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + f_Index2]).m_Value[p_PriceIndex]) then
                    Inc(f_PSY);

                Inc(f_Index2);
            end;

            if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PriceIndex] <> NOT_VALUE) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := (f_PSY / p_Length) * 100.0
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        end
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * ROC(Price Rate Of Change)를 계산한다.
 *
 * @param    p_Length1
 * @param    p_SrcValueArray
 * @param    p_SrcIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_ROC(p_Length1: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_SrcIndex, p_TagIndex: Integer; p_Begin, p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_Size := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    m_Effect := false;
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_End > p_SrcValueArray.m_Items.Count) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        if (f_Index - p_Length1 >= 0) then
        begin
            if ((CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Length1]).m_Value[p_TagIndex] <> NOT_VALUE)
                and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Length1]).m_Value[p_TagIndex] <> 0)) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := ((CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] - CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Length1]).m_Value[p_SrcIndex]) / CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Length1]).m_Value[p_SrcIndex]) * 100.0
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        end
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * RSI(Relative Strength Index)를 계산한다.
 *
 * @param    p_Length
 * @param    p_MA
 * @param    p_SrcValueArray
 * @param    p_SrcIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_RSI(p_Length, p_MA: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Count     : Integer;
    f_Index     : Integer;
    f_Index2    : Integer;
    f_Size      : Integer;
    f_mount     : Double;
    f_UpSum     : Double;
    f_DownSum   : Double;
    f_NewPrice  : Double;
    f_OldPrice  : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    for f_Count := p_Begin to p_End - 1 do
    begin
        f_Index := f_Count - (p_Length - 1);
        if (f_Index > 0) then
        begin
            f_UpSum := 0.0;
            f_DownSum := 0.0;
            CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := 0;
            for f_Index2 := 0 to p_Length - 1 do
            begin
                f_OldPrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2 - 1]).m_Value[p_SrcIndex];
                f_NewPrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_SrcIndex];
                f_mount := f_NewPrice - f_OldPrice;

                if (f_mount >= 0) then
                    f_UpSum := f_UpSum + f_mount
                else
                    f_DownSum := f_DownSum + (-f_mount);

                if ((CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2 - 1]).m_Value[p_SrcIndex] = NOT_VALUE)
                    or (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_SrcIndex] = NOT_VALUE)) then
                begin
                    CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := NOT_VALUE;
                    break;
                end;
            end;

            if (CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex] <> NOT_VALUE) then
            begin
                if (f_UpSum + f_DownSum = 0) then
                    CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := 0.0
                else
                    CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := f_UpSum / (f_UpSum + f_DownSum) * 100.0;
            end;
        end
        else
            CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := NOT_VALUE;
    end;

    Indicator_NAverage(p_MA, Self, p_TagIndex + 0, p_TagIndex + 1, p_Begin, p_End);
    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;

end;

procedure CFNMatrixLineValueSeries.Indicator_RSI_CrossSignal(p_Length,
  p_MA: Integer; p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex,
  p_TagIndex, p_Begin, p_End: Integer);
var
    f_Count     : Integer;
    f_Index     : Integer;
    f_Index2    : Integer;
    f_Size      : Integer;
    f_mount     : Double;
    f_UpSum     : Double;
    f_DownSum   : Double;
    f_NewPrice  : Double;
    f_OldPrice  : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    for f_Count := p_Begin to p_End - 1 do
    begin
        f_Index := f_Count - (p_Length - 1);
        if (f_Index > 0) then
        begin
            f_UpSum := 0.0;
            f_DownSum := 0.0;
            CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] := 0;
            for f_Index2 := 0 to p_Length - 1 do
            begin
                f_OldPrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2 - 1]).m_Value[p_SrcIndex];
                f_NewPrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_SrcIndex];
                f_mount := f_NewPrice - f_OldPrice;

                if (f_mount >= 0) then
                    f_UpSum := f_UpSum + f_mount
                else
                    f_DownSum := f_DownSum + (-f_mount);

                if  (
                        (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2 - 1]).m_Value[p_SrcIndex] = NOT_VALUE) OR
                        (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_SrcIndex] = NOT_VALUE)
                    )
                then
                begin
                    CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] := NOT_VALUE;
                    break;
                end;
            end;

            if (CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] <> NOT_VALUE) then
            begin
                if (f_UpSum + f_DownSum = 0) then
                begin
                    CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] := 0.0
                end else
                begin
                    CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] := f_UpSum / (f_UpSum + f_DownSum) * 100.0;
                end;
            end;
        end else
        begin
            CFNMatrixLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] := NOT_VALUE;
        end;
    end;

    Indicator_NAverage(p_MA, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);
    Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;

end;

//---------------------------------------------------------------------------
{**
 * 삼선전환도를 계산한다.
 *
 * @param    p_SrcValueArray
 * @param    p_PriceIndex
 * @param    p_TagIndex
**}
procedure CFNMatrixLineValueSeries.Indicator_Samsun(p_SrcValueArray: CFNMatrixLineValueSeries; p_PriceIndex,
  p_TagIndex: Integer);
var
    f_Size      : Integer;
    f_Index3    : Integer;
    f_Index2    : Integer;
    f_Deep      : Integer;
    f_Sign      : Double;
    f_ClosePrice1   : Double;
    f_ClosePrice0   : Double;
    f_ChangePrice1  : Double;
    f_ChangePrice0  : Double;
    f_Done          : Boolean;
    f_HighValue1    : Double;
    f_LowValue1     : Double;
    f_HighValueArray: Array of Double;
    f_LowValueArray : Array of Double;
    f_Value         : CFNMatrixLineValue;
    f_Index         : Integer;
    f_FirstValue    : Boolean;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_FirstValue := true;
    //f_HighValueArray = new Array(3);
    //f_LowValueArray = new Array(3);
    SetLength(f_HighValueArray, 3);
    SetLength(f_LowValueArray, 3);
    f_Size := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(0);
    f_Deep := 0;
    f_HighValueArray[0] := 0;
    f_LowValueArray[0] := 0;
    f_HighValue1 := 0;
    f_LowValue1 := 0;
    f_ChangePrice1 := 0;
    f_ChangePrice0 := 0;
    for f_Index := 0 to f_Size - 1 do
    begin
        if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PriceIndex] <> NOT_VALUE) then
        begin
            if (f_FirstValue) then
            begin
                f_ClosePrice1 := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PriceIndex];
                f_Deep := 0;
                f_HighValueArray[0] := f_ClosePrice1;
                f_LowValueArray[0] := f_ClosePrice1;
                f_HighValue1 := f_ClosePrice1;
                f_LowValue1 := f_ClosePrice1;
                f_FirstValue := false;
                continue;
            end;

            f_ClosePrice0 := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PriceIndex];
            f_ChangePrice0 := f_ClosePrice0 - f_ClosePrice1;
            f_Sign := f_ChangePrice1 * f_ChangePrice0;
            if (f_Sign > 0) then
            begin
                f_Value := CFNMatrixLineValue.Create(m_LineCount);
                if (f_ClosePrice1 < f_ClosePrice0) then
                begin
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_HIGH] := f_ClosePrice0;
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_LOW] := f_HighValue1;
                end
                else
                begin
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_HIGH] := f_LowValue1;
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_LOW] := f_ClosePrice0;
                end;

                f_Value.m_Value[CFNMatrixConst.SAMSUN_CLOSE] := f_Index;
                if (f_Sign < 0.0) then
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_SIGN] := -1
                else
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_SIGN] := 1;

                if (f_ChangePrice0 < 0.0) then
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_VALUE] := -1
                else
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_VALUE] := 1;

                m_Items.Add(f_Value);
                f_HighValue1 := f_Value.m_Value[CFNMatrixConst.SAMSUN_HIGH];
                f_LowValue1 := f_Value.m_Value[CFNMatrixConst.SAMSUN_LOW];
                f_ClosePrice1 := f_ClosePrice0;
                f_ChangePrice1 := f_ChangePrice0;
                if (f_Deep > 2) then
                begin
                    //for (f_Index2 = 0; f_Index2 < 2; f_Index2++)
                    for f_Index2 := 0 to 2 - 1 do
                    begin
                        f_HighValueArray[f_Index2] := f_HighValueArray[f_Index2 + 1];
                        f_LowValueArray[f_Index2] := f_LowValueArray[f_Index2 + 1];
                        f_Deep := 2;
                    end;
                end;

                f_HighValueArray[f_Deep] := f_Value.m_Value[CFNMatrixConst.SAMSUN_HIGH];
                f_LowValueArray[f_Deep] := f_Value.m_Value[CFNMatrixConst.SAMSUN_LOW];
                Inc(f_Deep);
            end
            else if (((f_ChangePrice0 < 0) and (f_ClosePrice0 < f_LowValueArray[0])) or ((f_ChangePrice0 > 0) and (f_ClosePrice0 > f_HighValueArray[0]))) then
            begin
                f_Value := CFNMatrixLineValue.Create(m_LineCount);
                if (f_ClosePrice1 < f_ClosePrice0) then
                begin
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_HIGH] := f_ClosePrice0;
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_LOW] := f_HighValue1;
                end
                else
                begin
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_HIGH] := f_LowValue1;
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_LOW] := f_ClosePrice0;
                end;

                f_Value.m_Value[CFNMatrixConst.SAMSUN_CLOSE] := f_Index;
                if (f_Sign < 0.0) then
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_SIGN] := -1
                else
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_SIGN] := 1;

                if (f_ChangePrice0 < 0.0) then
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_VALUE] := -1
                else
                    f_Value.m_Value[CFNMatrixConst.SAMSUN_VALUE] := 1;

                m_Items.Add(f_Value);
                f_HighValue1 := f_Value.m_Value[CFNMatrixConst.SAMSUN_HIGH];
                f_LowValue1 := f_Value.m_Value[CFNMatrixConst.SAMSUN_LOW];
                f_ClosePrice1 := f_ClosePrice0;
                f_ChangePrice1 := f_ChangePrice0;
                f_Deep := 0;
                f_HighValueArray[f_Deep] := f_Value.m_Value[CFNMatrixConst.SAMSUN_HIGH];
                f_LowValueArray[f_Deep] := f_Value.m_Value[CFNMatrixConst.SAMSUN_LOW];
                Inc(f_Deep);
            end
            else
            begin
                continue;
            end;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
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
**}
procedure CFNMatrixLineValueSeries.Indicator_SAR(p_Length: Double; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
    f_HIndex    : Integer;
    f_LIndex    : Integer;
    f_SIndex    : Integer;
    f_SARIndex  : Integer;
    f_AFIndex   : Integer;
    p_F         : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_Size := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    m_Effect := false;
    f_HIndex    := p_TagIndex + 0;
    f_LIndex    := p_TagIndex + 1;
    f_SIndex    := p_TagIndex + 2;
    f_SARIndex  := p_TagIndex + 3;
    f_AFIndex   := p_TagIndex + 4;
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        if (f_Index = 0) then
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_HIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex];
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_LIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex];
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SIndex] := 1;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex];
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_AFIndex] := p_Length;
        end
        else
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_HIndex] := CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_HIndex];
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_LIndex] := CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_LIndex];
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SIndex] := CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_SIndex];
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_SARIndex];
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_AFIndex] := CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_AFIndex];
            if (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_HIndex] < CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex]) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_HIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex];

            if (CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_LIndex] > CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex]) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_LIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex];

            if (CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SIndex] = 1) then
            begin
                if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <= CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_SARIndex]) then
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SIndex] := -1;
            end
            else
            begin
                if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] >= CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_SARIndex]) then
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SIndex] := 1;
            end;

            if (CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SIndex] = 1) then
            begin
                if (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_SIndex] <> 1) then
                begin
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_LIndex];
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_HIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex];
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_LIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex];
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_AFIndex] := p_Length;
                end
                else
                begin
                    p_F := CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_AFIndex];
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_SARIndex] + p_F * (CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_HIndex] - CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_SARIndex]);
                    if ((CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_HIndex] > CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_HIndex]) and (p_F < 0.2)) then
                    begin
                        //p_F := p_F + (((0.2 - p_F) > 0.02) ? 0.02 : (0.2 - p_F));
                        if ((0.2 - p_F) > 0.02) then
                            p_F := p_F + (0.02)
                        else
                            p_F := p_F + (0.2 - p_F);

                        CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_AFIndex] := p_F;
                    end;
                end;

                if (CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SARIndex] > CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex]) then
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex];

                if (CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SARIndex] > CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_LowIndex]) then
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_LowIndex];
            end
            else
            begin
                if (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_SIndex] <> -1) then
                begin
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_HIndex];
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_HIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex];
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_LIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex];
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_AFIndex] := p_Length;
                end
                else
                begin
                    p_F := CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_AFIndex];
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_SARIndex] + p_F * (CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_LIndex] - CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_SARIndex]);
                    if ((CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_LIndex] < CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[f_LIndex]) and (p_F < 0.2)) then
                    begin
                        //p_F = p_F + (((0.2 - p_F) > 0.02) ? 0.02 : (0.2 - p_F));
                        if ((0.2 - p_F) > 0.02) then
                            p_F := p_F + (0.02)
                        else
                            p_F := p_F + (0.2 - p_F);

                        CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_AFIndex] := p_F;
                    end;
                end;

                if (CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SARIndex] < CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex]) then
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex];

                if (CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SARIndex] < CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_HighIndex]) then
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[f_SARIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_HighIndex];
            end;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
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
**}
procedure CFNMatrixLineValueSeries.Indicator_SlowSTC(p_Length1, p_Length2, p_Length3: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin,
  p_End: Integer);
var
    f_SlowKIndex    : Integer;
    f_SlowDIndex    : Integer;
    f_FastKIndex    : Integer;
    f_Count         : Integer;
    f_Index         : Integer;
    f_Index2        : Integer;
    f_DHighest      : Double;
    f_DLowest       : Double;
    f_HighPrice     : Double;
    f_LowPrice      : Double;
    f_ClosePrice    : Double;
    f_Size          : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_FastKIndex := p_TagIndex;
    f_SlowKIndex := p_TagIndex + 1;
    f_SlowDIndex := p_TagIndex + 2;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    for f_Count := p_Begin to p_End - 1 do
    begin
        f_Index := f_Count - (p_Length1 - 1);
        if (f_Index >= 0) then
        begin
            if ((CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <> NOT_VALUE) and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <> NOT_VALUE) and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE)) then
            begin
                f_DHighest := MIN_VALUE;
                f_DLowest := MAX_VALUE;
                for f_Index2 := 0 to p_Length1 - 1 do
                begin
                    f_HighPrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_HighIndex];
                    f_LowPrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_LowIndex];
                    if (f_LowPrice < f_DLowest) then
                        f_DLowest := f_LowPrice;

                    if (f_HighPrice > f_DHighest) then
                        f_DHighest := f_HighPrice;
                end;

                f_ClosePrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Count]).m_Value[p_CloseIndex];
                if (f_DHighest = f_DLowest) then
                    CFNMatrixLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := 0
                else
                    CFNMatrixLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := (f_ClosePrice - f_DLowest) / (f_DHighest - f_DLowest) * 100.0;
            end
            else
                CFNMatrixLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := NOT_VALUE;
        end
        else
            CFNMatrixLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := NOT_VALUE;
    end;

    Indicator_XAverage(p_Length2, Self, f_FastKIndex, f_SlowKIndex, p_Begin, p_End);
    Indicator_XAverage(p_Length3, Self, f_SlowKIndex, f_SlowDIndex, p_Begin, p_End);
    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_SlowSTC_CrossSignal(p_Length1,
  p_Length2, p_Length3: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin,
  p_End: Integer);
var
    f_SlowKIndex    : Integer;
    f_SlowDIndex    : Integer;
    f_FastKIndex    : Integer;
    f_Count         : Integer;
    f_Index         : Integer;
    f_Index2        : Integer;
    f_DHighest      : Double;
    f_DLowest       : Double;
    f_HighPrice     : Double;
    f_LowPrice      : Double;
    f_ClosePrice    : Double;
    f_Size          : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_FastKIndex := p_TagIndex + 3;
    f_SlowKIndex := p_TagIndex + 1;
    f_SlowDIndex := p_TagIndex + 2;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    for f_Count := p_Begin to p_End - 1 do
    begin
        f_Index := f_Count - (p_Length1 - 1);
        if (f_Index >= 0) then
        begin
            if ((CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <> NOT_VALUE) and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <> NOT_VALUE) and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE)) then
            begin
                f_DHighest := MIN_VALUE;
                f_DLowest := MAX_VALUE;
                for f_Index2 := 0 to p_Length1 - 1 do
                begin
                    f_HighPrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_HighIndex];
                    f_LowPrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_LowIndex];
                    if (f_LowPrice < f_DLowest) then
                        f_DLowest := f_LowPrice;

                    if (f_HighPrice > f_DHighest) then
                        f_DHighest := f_HighPrice;
                end;

                f_ClosePrice := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Count]).m_Value[p_CloseIndex];
                if (f_DHighest = f_DLowest) then
                    CFNMatrixLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := 0
                else
                    CFNMatrixLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := (f_ClosePrice - f_DLowest) / (f_DHighest - f_DLowest) * 100.0;
            end
            else
                CFNMatrixLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := NOT_VALUE;
        end
        else
            CFNMatrixLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := NOT_VALUE;
    end;

    Indicator_XAverage(p_Length2, Self, f_FastKIndex, f_SlowKIndex, p_Begin, p_End);
    Indicator_XAverage(p_Length3, Self, f_SlowKIndex, f_SlowDIndex, p_Begin, p_End);

    Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
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
**}
procedure CFNMatrixLineValueSeries.Indicator_SONA(p_Length1, p_Length2, p_Length3: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex: Integer; p_Begin, p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_Size := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    m_Effect := false;
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_End > p_SrcValueArray.m_Items.Count) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    Indicator_NAverage(p_Length1, p_SrcValueArray, p_SrcIndex, p_TagIndex, p_Begin, p_End);
    for f_Index := p_Begin to p_End - 1 do
    begin
        if (f_Index - p_Length2 >= 0) then
        begin
            if ((CFNMatrixLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex] <> NOT_VALUE)
                and (CFNMatrixLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex] <> NOT_VALUE)) then

                if CFNMatrixLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex] <> 0 then
                begin
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] :=
                        (
                            (CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] - CFNMatrixLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex]) /
                            CFNMatrixLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex]
                        ) * 100.0
                end else
                begin
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := 0;
                end
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
        end
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
    end;

    Indicator_NAverage(p_Length3, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);
    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_SONA_CrossSignal(p_Length1,
  p_Length2, p_Length3: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_Size := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    m_Effect := false;
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_End > p_SrcValueArray.m_Items.Count) then
        p_End := p_SrcValueArray.m_Items.Count;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    Indicator_NAverage(p_Length1, p_SrcValueArray, p_SrcIndex, p_TagIndex+3, p_Begin, p_End);
    for f_Index := p_Begin to p_End - 1 do
    begin
        if (f_Index - p_Length2 >= 0) then
        begin
            if  (
                    (CFNMatrixLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex+3] <> NOT_VALUE) AND
                    (CFNMatrixLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex+3] <> NOT_VALUE)
                ) then
            begin
                if CFNMatrixLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex+3] <> 0 then
                begin
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] :=
                        (
                            (CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex+3] - CFNMatrixLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex+3]) /
                            CFNMatrixLineValue(m_Items[f_Index - p_Length2]).m_Value[p_TagIndex+3]
                        ) * 100.0
                end else
                begin
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := 0;
                end
            end else
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
            end;
        end else
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
        end;
    end;

    Indicator_NAverage(p_Length3, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);

    Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * 표준편차를 계산한다.
 *
 * @param    p_Count
 * @param    p_SrcValueArray
 * @param    p_PriceIndex
 * @param    p_SrcValueArray2
 * @param    p_MIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_StdDev(p_Count: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_PriceIndex: Integer; p_SrcValueArray2: CFNMatrixLineValueSeries; p_MIndex, p_TagIndex, p_Begin,
  p_End: Integer);
var
    f_Sum       : Double;
    f_v0        : Double;
    f_v1        : Double;
    f_v2        : Double;
    f_Index2    : Integer;
    f_Index     : Integer;
    f_Size      : Integer;
    f_AllEffect : Boolean;
    f_MA0       : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    if not Assigned(p_SrcValueArray2) then exit;
    f_AllEffect := false;
    f_Size := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    m_Effect := false;

    if (p_Begin = -1) then p_Begin := 0;
    if (p_End = -1) then p_End := f_Size;
    if (p_End > f_Size) then p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    f_Sum := 0;
    f_v1 := 0;
    for f_Index := p_Begin to p_End - 1 do
    begin
        CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        if (f_Index < p_Count - 1) then
            continue;

        if (not f_AllEffect) then
        begin
            if ((CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_PriceIndex] <> NOT_VALUE)
                and (CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_MIndex] <> NOT_VALUE)) then
                f_AllEffect := true
            else
                f_AllEffect := false;

            if (f_AllEffect) then
            begin
                f_MA0 := CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_MIndex];
                f_Sum := 0;
                for f_Index2 := 0 to p_Count - 1 do
                begin
                    f_v1 := (f_MA0 - CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[p_PriceIndex]);
                    f_Sum := f_Sum + (f_v1 * f_v1);
                end;
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Sqrt(f_Sum / p_Count);
            end;

            continue;
        end;

        f_v0 := 0;
        f_v2 := 0;
        if (f_Index >= p_Count) then
        begin
            f_MA0 := CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_MIndex];
            f_Sum := 0;
            for f_Index2 := 0 to p_Count - 1 do
            begin
                f_v1 := (f_MA0 - CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[p_PriceIndex]);
                f_Sum := f_Sum + (f_v1 * f_v1);
            end;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Sqrt(f_Sum / p_Count);
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * 두라인의 차이를 계산한다.
 *
 * @param    p_SrcLineSeries1
 * @param    p_SrcIndex1
 * @param    p_SrcValueArray2
 * @param    p_SrcIndex2
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_Subtraction(p_SrcLineSeries1: CFNMatrixLineValueSeries;
  p_SrcIndex1: Integer; p_SrcValueArray2: CFNMatrixLineValueSeries; p_SrcIndex2, p_TagIndex, p_Begin,
  p_End: Integer);
var
    f_Size  : Integer;
    f_Index : Integer;
begin
    if not Assigned(p_SrcLineSeries1) then exit;
    if not Assigned(p_SrcValueArray2) then exit;
    m_Effect := false;
    f_Size  := p_SrcLineSeries1.m_Items.Count;
    SetLengthSeries(f_Size);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        if ((CFNMatrixLineValue(p_SrcLineSeries1.m_Items[f_Index]).m_Value[p_SrcIndex1] <> NOT_VALUE)
            and (CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_SrcIndex2] <> NOT_VALUE)) then
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CFNMatrixLineValue(p_SrcLineSeries1.m_Items[f_Index]).m_Value[p_SrcIndex1] - CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_SrcIndex2];
    end;

    m_ChartDataSeries := p_SrcLineSeries1.m_ChartDataSeries;
    m_Effect := true;

end;

//---------------------------------------------------------------------------
{**
 * TRIX(Tripple Smoothed Moving Averages)을 계산한다.
 *
 * @param    p_Length1
 * @param    p_Length2
 * @param    p_SrcValueArray
 * @param    p_SrcIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_TRIX(p_Length1, p_Length2: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    // TR:= EMA(EMA(EMA(CLOSE,f_N),f_N),f_N);
    Indicator_XAverage(p_Length1, p_SrcValueArray, p_SrcIndex, p_TagIndex + 0, p_Begin, p_End);
    Indicator_XAverage(p_Length1, Self, p_TagIndex + 0, p_TagIndex + 1, p_Begin, p_End);
    Indicator_XAverage(p_Length1, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);
    // TRIX : (TR-REF(TR,1))/REF(TR,1)*100;
    for f_Index := p_Begin to p_End - 1 do
    begin
        if ((f_Index > 1) and (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 2] <> NOT_VALUE)) then
        begin
            if (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 2] <> 0) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] := (CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] - CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 2]) * 100.0 / CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 2]
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] := 0;
        end
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] := NOT_VALUE;
    end;

    // TRMA : MA(TRIX,M);
    Indicator_NAverage(p_Length2, Self, p_TagIndex + 3, p_TagIndex + 4, p_Begin, p_End);
    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_TRIX_CrossSignal(p_Length1,
  p_Length2: Integer; p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex,
  p_TagIndex, p_Begin, p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    // TR:= EMA(EMA(EMA(CLOSE,f_N),f_N),f_N);
    Indicator_XAverage(p_Length1, p_SrcValueArray, p_SrcIndex, p_TagIndex + 3, p_Begin, p_End);
    Indicator_XAverage(p_Length1, Self, p_TagIndex + 3, p_TagIndex + 4, p_Begin, p_End);
    Indicator_XAverage(p_Length1, Self, p_TagIndex + 4, p_TagIndex + 5, p_Begin, p_End);
    // TRIX : (TR-REF(TR,1))/REF(TR,1)*100;
    for f_Index := p_Begin to p_End - 1 do
    begin
        if ((f_Index > 1) and (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 5] <> NOT_VALUE)) then
        begin
            if (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 5] <> 0) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := (CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 5] - CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 5]) * 100.0 / CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 5]
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := 0;
        end
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
    end;

    // TRMA : MA(TRIX,M);
    Indicator_NAverage(p_Length2, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);

    Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * TrueRange를 계산한다.
 *
 * @param    p_SrcValueArray
 * @param    p_HighIndex
 * @param    p_LowIndex
 * @param    p_CloseIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_TrueRange(p_SrcValueArray: CFNMatrixLineValueSeries; p_HighIndex,
  p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Count     : Integer;
    f_Index     : Integer;
    f_Size      : Integer;
    f_TrueMaxMin: Double;
    f_TrueHigh  : Double;
    f_TrueLow   : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        if ((f_Index >= 1) and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <> NOT_VALUE)
                            and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <> NOT_VALUE)
                            and (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE)) then
        begin
            if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_CloseIndex] > CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex]) then
                f_TrueHigh := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_CloseIndex]
            else
                f_TrueHigh := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex];

            if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_CloseIndex] < CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex]) then
                f_TrueLow := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - 1]).m_Value[p_CloseIndex]
            else
                f_TrueLow := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex];

            f_TrueMaxMin := f_TrueHigh - f_TrueLow;
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_TrueMaxMin;
        end
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * 거래량 라인시리즈를 계산한다.
 *
 * @param    p_ChartDataSeries
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_Volume(p_ChartDataSeries: CFNMatrixChartDataSeries; p_Begin,
  p_End: Integer);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_ChartData : CFNMatrixChartData;
    f_Value     : CFNMatrixLineValue;
    f_OpenPrice00 :Double;
    f_ClosePrice00 : Double;
    f_ClosePrice01 : Double;
begin
    m_Effect := false;
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

    if (p_Begin < 0) then p_Begin := 0;

    f_Index := p_Begin;
    while (f_Index < p_End) do
    begin
        f_Value         := CFNMatrixLineValue(m_Items[f_Index]);
        f_ChartData     := CFNMatrixChartData(p_ChartDataSeries.m_Items[f_Index]);
        f_Value.m_Value[0] := f_ChartData.m_Volume;
        Inc(f_Index);
    end;

    m_ChartDataSeries := p_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * VR(Volume Ratio)을 계산한다.
 *
 * @param    p_Length
 * @param    p_SrcValueArray
 * @param    p_PriceIndex
 * @param    p_SrcValueArray2
 * @param    p_VolumeIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_VR(p_Length: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_PriceIndex: Integer; p_SrcValueArray2: CFNMatrixLineValueSeries; p_VolumeIndex, p_TagIndex, p_Begin,
  p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
    f_Index2    : Integer;
    f_MinusTrdQty   : Double;
    f_PlusTrdQty    : Double;
    f_EqualTrdQty   : Double;
    f_r1        : Double;
    f_r2        : Double;
    p_F         : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    if not Assigned(p_SrcValueArray2) then exit;
    f_Size := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    m_Effect := false;
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

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
                if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + f_Index2 - 1]).m_Value[p_PriceIndex] < CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + f_Index2]).m_Value[p_PriceIndex]) then
                    f_PlusTrdQty := f_PlusTrdQty + CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index - p_Length + f_Index2 - 1]).m_Value[p_VolumeIndex]
                else if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + f_Index2 - 1]).m_Value[p_PriceIndex] > CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - p_Length + f_Index2]).m_Value[p_PriceIndex]) then
                    f_MinusTrdQty := f_MinusTrdQty + CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index - p_Length + f_Index2 - 1]).m_Value[p_VolumeIndex]
                else
                    f_EqualTrdQty := f_EqualTrdQty + CFNMatrixLineValue(p_SrcValueArray2.m_Items[f_Index - p_Length + f_Index2 - 1]).m_Value[p_VolumeIndex];

                Inc(f_Index2);
            end;

            f_r1 := (f_MinusTrdQty + f_EqualTrdQty * 0.5);
            f_r2 := (f_PlusTrdQty + f_EqualTrdQty + 0.5);
            if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_PriceIndex] <> NOT_VALUE) then
            begin
                if (f_r2 <> 0.0) then
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_r1 / f_r2 * 100.0
                else
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
            end
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        end
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * 가중이동평균을 계산한다.
 *
 * @param    p_Count
 * @param    p_SrcValueArray
 * @param    p_SrcIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_WAverage(p_Count: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_Index1    : Integer;
    f_Sum       : Double;
    f_CSum      : Double;
    f_Price     : Double;
    f_AllEffect : Boolean;
    f_Factor    : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_AllEffect := false;
    m_Effect    := false;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_Sum := 0;
        f_CSum := 0;
        if (f_Index - p_Count + 1 > 0) then
        begin
            for f_Index1 := 0 to p_Count - 1 do
            begin
                f_Price := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
                f_Sum   := f_Sum + f_Price * (p_Count - f_Index1);
                f_CSum  := f_CSum + p_Count - f_Index1;
            end;

            if (f_CSum > 0) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
        end
        else
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_WAverage2(p_Count: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_Index1    : Integer;
    f_Sum       : Double;
    f_CSum      : Double;
    f_Price     : Double;
    f_AllEffect : Boolean;
    f_Factor    : Double;
    f_Count     : Integer;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_AllEffect := false;
    m_Effect    := false;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_Sum := 0;
        f_CSum := 0;
        if (f_Index - p_Count + 1 > 0) then
        begin
            for f_Index1 := 0 to p_Count - 1 do
            begin
                f_Price := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
                f_Sum   := f_Sum + f_Price * (p_Count - f_Index1);
                f_CSum  := f_CSum + p_Count - f_Index1;
            end;

            if (f_CSum > 0) then
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
            end else
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
            end;
        end
        else
        begin
            f_Count := f_Index + 1;
            for f_Index1 := 0 to f_Count - 1 do
            begin
                f_Price := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
                f_Sum   := f_Sum + f_Price * (f_Count - f_Index1);
                f_CSum  := f_CSum + f_Count - f_Index1;
            end;

            if (f_CSum > 0) then
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
            end else
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
            end;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;
//-------------------------------------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Indicator_WAverage3(
    p_Count:Integer;
    p_Precision:Integer;
    p_SrcValueArray:CFNMatrixLineValueSeries;
    p_SrcIndex:Integer;
    p_TagIndex:Integer;
    p_Begin:Integer = -1;
    p_End:Integer = -1);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_Index1    : Integer;
    f_Sum       : Double;
    f_CSum      : Double;
    f_Price     : Double;
    f_AllEffect : Boolean;
    f_Factor    : Double;
    f_Count     : Integer;
    f_Factor2   : Double;
begin
    f_Factor2 := Math.Power(10, p_Precision);
    if not Assigned(p_SrcValueArray) then exit;
    f_AllEffect := false;
    m_Effect    := false;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_Sum := 0;
        f_CSum := 0;
        if (f_Index - p_Count + 1 > 0) then
        begin
            for f_Index1 := 0 to p_Count - 1 do
            begin
                f_Price := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
                f_Sum   := f_Sum + f_Price * (p_Count - f_Index1);
                f_CSum  := f_CSum + p_Count - f_Index1;
            end;

            if (f_CSum > 0) then
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Round(CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] * f_Factor2) / f_Factor2;
            end else
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
            end;
        end
        else
        begin
            f_Count := f_Index + 1;
            for f_Index1 := 0 to f_Count - 1 do
            begin
                f_Price := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
                f_Sum   := f_Sum + f_Price * (f_Count - f_Index1);
                f_CSum  := f_CSum + f_Count - f_Index1;
            end;

            if (f_CSum > 0) then
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Round(CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] * f_Factor2) / f_Factor2;
            end else
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
            end;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Indicator_WAverageZ(p_Count:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_Index1    : Integer;
    f_Sum       : Double;
    f_CSum      : Double;
    f_Price     : Double;
    f_AllEffect : Boolean;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_AllEffect := false;
    m_Effect    := false;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_Sum := 0;
        f_CSum := 0;
        if (f_Index - p_Count + 1 > 0) then
        begin
            for f_Index1 := 0 to p_Count - 1 do
            begin
                f_Price := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
                f_Sum   := f_Sum + f_Price * (p_Count - f_Index1);
                f_CSum  := f_CSum + p_Count - f_Index1;
            end;

            if (f_CSum > 0) then
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
            end else
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
            end;
        end
        else
        begin
            for f_Index1 := 0 to p_Count - 1 do
            begin
                if (f_Index - f_Index1 < 0) then
                begin
                    f_Price := 0;
                end else
                begin
                    f_Price := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
                end;

                f_Sum   := f_Sum + f_Price * (p_Count - f_Index1);
                f_CSum  := f_CSum + p_Count - f_Index1;
            end;

            if (f_CSum > 0) then
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
            end else
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
            end;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Indicator_ProfitWAverageOfBuy(p_Count:Integer; p_Precision:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_SumLoop   : Integer;
    f_Sum       : Double;
    f_CSum      : Double;
    f_Value     : Double;
    f_Factor2   : Double;
    f_ItemIndex :   Integer;
    f_ItemCount :   Integer;
begin
    f_Factor2 := Math.Power(10, p_Precision);
    if not Assigned(p_SrcValueArray) then exit;

    m_Effect    := false;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);

    if (p_Begin = -1) then p_Begin := 0;

    if (p_End = -1) then p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        if (f_Index > 0) then
        begin
            if CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index-1]).m_Value[p_SignalIndex] > 0  then
            begin

                f_Sum := 0;
                f_CSum := 0;
                f_SumLoop := 0;
                f_ItemCount := 0;

                while f_ItemCount < p_Count do
                begin
                    f_ItemIndex := f_Index - f_SumLoop;
                    if f_ItemIndex <= 0 then
                    begin
                        f_Value := 0;
                        f_Sum   := f_Sum + f_Value * (p_Count - f_ItemCount);
                        f_CSum  := f_CSum + p_Count - f_ItemCount;
                        Inc(f_ItemCount);
                    end else
                    if  CFNMatrixLineValue(p_SrcValueArray.m_Items[f_ItemIndex-1]).m_Value[p_SignalIndex] > 0  then
                    begin
                        f_Value := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_ItemIndex-1]).m_Value[p_SrcIndex];
                        f_Sum   := f_Sum + f_Value * (p_Count - f_ItemCount);
                        f_CSum  := f_CSum + p_Count - f_ItemCount;
                        Inc(f_ItemCount);
                    end;

                    Inc(f_SumLoop);
                end;

                if (f_CSum > 0) then
                begin
                    f_Value := f_Sum / f_CSum;
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Round(f_Value * f_Factor2) / f_Factor2;
                end else
                begin
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
                end;
            end else
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CFNMatrixLineValue(m_Items[f_Index-1]).m_Value[p_TagIndex];
            end;
        end else
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Indicator_ProfitWAverageOfSell(p_Count:Integer; p_Precision:Integer; p_SrcValueArray:CFNMatrixLineValueSeries; p_SignalIndex:Integer; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_SumLoop   : Integer;
    f_Sum       : Double;
    f_CSum      : Double;
    f_Value     : Double;
    f_Factor2   : Double;
    f_ItemIndex :   Integer;
    f_ItemCount :   Integer;
begin
    f_Factor2 := Math.Power(10, p_Precision);
    if not Assigned(p_SrcValueArray) then exit;

    m_Effect    := false;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);

    if (p_Begin = -1) then p_Begin := 0;

    if (p_End = -1) then p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        if (f_Index > 0) then
        begin
            if CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index-1]).m_Value[p_SignalIndex] < 0  then
            begin
                f_Sum := 0;
                f_CSum := 0;

                f_SumLoop := 0;
                f_ItemCount := 0;
                while f_ItemCount < p_Count do
                begin
                    f_ItemIndex := f_Index - f_SumLoop;
                    if f_ItemIndex <= 0 then
                    begin
                        f_Value := 0;
                        f_Sum   := f_Sum + f_Value * (p_Count - f_ItemCount);
                        f_CSum  := f_CSum + p_Count - f_ItemCount;
                        Inc(f_ItemCount);
                    end else
                    if  CFNMatrixLineValue(p_SrcValueArray.m_Items[f_ItemIndex-1]).m_Value[p_SignalIndex] < 0  then
                    begin
                        f_Value := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_ItemIndex-1]).m_Value[p_SrcIndex];
                        f_Sum   := f_Sum + f_Value * (p_Count - f_ItemCount);
                        f_CSum  := f_CSum + p_Count - f_ItemCount;
                        Inc(f_ItemCount);
                    end;

                    Inc(f_SumLoop);
                end;

                if (f_CSum > 0) then
                begin
                    f_Value := f_Sum / f_CSum;
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Round(f_Value * f_Factor2) / f_Factor2;
                end else
                begin
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
                end;
            end else
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CFNMatrixLineValue(m_Items[f_Index-1]).m_Value[p_TagIndex];
            end;
        end else
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;
//---------------------------------------------------------------------------
{**
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
**}
procedure CFNMatrixLineValueSeries.Indicator_WilliamsR(
    p_Count1, p_Count2: Integer;
    p_SrcValueArray: CFNMatrixLineValueSeries;
    p_HighIndex,
    p_LowIndex,
    p_CloseIndex,
    p_TagIndex,
    p_Begin,
    p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
    f_Count     : Integer;
    f_MaxValue  : Double;
    f_MinValue  : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_Size := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    m_Effect := false;
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_MaxValue := HighestPrice(p_Count1, p_SrcValueArray, p_HighIndex, f_Index);
        f_MinValue := LowestPrice(p_Count1, p_SrcValueArray, p_LowIndex, f_Index);
        if ((f_MaxValue <> MIN_VALUE) and (f_MinValue <> MAX_VALUE)) then
        begin
            if ((f_MaxValue - f_MinValue) = 0) then
            begin
                if ((f_Index > 0) and (CFNMatrixLineValue(m_Items[f_Index - 1]) <> NIL)) then
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 0]
                else
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;
            end
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := (f_MaxValue - CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex]) * (-100.0) / (f_MaxValue - f_MinValue);
        end
        else
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;
    end;

    Indicator_XAverage(p_Count2, Self, p_TagIndex + 0, p_TagIndex + 1, p_Begin, p_End);
    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

procedure CFNMatrixLineValueSeries.Indicator_WilliamsR_CrossSignal(p_Count1,
  p_Count2: Integer; p_SrcValueArray: CFNMatrixLineValueSeries; p_HighIndex,
  p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
    f_Count     : Integer;
    f_MaxValue  : Double;
    f_MinValue  : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_Size := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    m_Effect := false;
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_MaxValue := HighestPrice(p_Count1, p_SrcValueArray, p_HighIndex, f_Index);
        f_MinValue := LowestPrice(p_Count1, p_SrcValueArray, p_LowIndex, f_Index);
        if ((f_MaxValue <> MIN_VALUE) and (f_MinValue <> MAX_VALUE)) then
        begin
            if ((f_MaxValue - f_MinValue) = 0) then
            begin
                if ((f_Index > 0) and (CFNMatrixLineValue(m_Items[f_Index - 1]) <> NIL)) then
                begin
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex + 0]
                end else
                begin
                    CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
                end;
            end else
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := (f_MaxValue - CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex]) * (-100.0) / (f_MaxValue - f_MinValue);
            end;
        end else
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
        end;
    end;

    Indicator_XAverage(p_Count2, Self, p_TagIndex + 1, p_TagIndex + 2, p_Begin, p_End);
    Indicator_CrossSignal(Self, p_TagIndex + 1, p_TagIndex + 2, p_TagIndex + 0, p_Begin, p_End);
    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * 지수이동평균을 계산한다.
 *
 * @param    p_Count
 * @param    p_SrcValueArray
 * @param    p_SrcIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_XAverage(p_Count: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_Index1    : Integer;
    f_Sum       : Double;
    f_AllEffect : Boolean;
    f_Factor    : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_AllEffect := false;
    m_Effect    := false;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    if (p_Count + 1 <> 0) then
    begin
        f_Factor := 2.0 / (p_Count + 1);
        for f_Index := p_Begin to p_End - 1 do
        begin
            if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] = NOT_VALUE) then
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
                continue;
            end;

            if ((f_Index <= 0) or (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] = NOT_VALUE)) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex]
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] * f_Factor + (1 - f_Factor) * CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex];
        end;
    end
    else
    begin
        for f_Index := p_Begin to p_End - 1 do
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 * 지수이동평균을 계산한다.
 *
 * @param    p_Count
 * @param    p_SrcValueArray
 * @param    p_SrcIndex
 * @param    p_TagIndex
 * @param    p_Begin
 * @param    p_End
**}
procedure CFNMatrixLineValueSeries.Indicator_XAverageZ(p_Count: Integer;
  p_SrcValueArray: CFNMatrixLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
    f_Size      : Integer;
    f_Index     : Integer;
    f_Index1    : Integer;
    f_Sum       : Double;
    f_AllEffect : Boolean;
    f_Factor    : Double;
begin
    if not Assigned(p_SrcValueArray) then exit;
    f_AllEffect := false;
    m_Effect    := false;
    f_Size      := p_SrcValueArray.m_Items.Count;
    SetLengthSeries(f_Size);
    if (p_Begin = -1) then
        p_Begin := 0;

    if (p_End = -1) then
        p_End := f_Size;

    if (p_End > f_Size) then
        p_End := f_Size;

    if (p_Begin > m_Items.Count - 1) then
        p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    if (p_Count + 1 <> 0) then
    begin
        f_Factor := 2.0 / (p_Count + 1);
        for f_Index := p_Begin to p_End - 1 do
        begin
            if (CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] = NOT_VALUE) then
            begin
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
                continue;
            end;

            if ((f_Index <= 0) or (CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] = NOT_VALUE)) then
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex]
            else
                CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
                CFNMatrixLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] * f_Factor + (1 - f_Factor) * CFNMatrixLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex];
        end;
    end
    else
    begin
        for f_Index := p_Begin to p_End - 1 do
        begin
            CFNMatrixLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        end;
    end;

    m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
    m_Effect := true;
end;

//---------------------------------------------------------------------------
{**
 *  p_Position에서 p_Position--p_Count+1 까지 최소값이 들어 있는 인덱스를 찾는다.
 *
 * @param    p_Count
 * @param    p_SrcValueArray
 * @param    p_PriceIndex
 * @param    p_Position
**}
function CFNMatrixLineValueSeries.LowestIndex(p_Count: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_PriceIndex, p_Position: Integer): Integer;
var
    f_Index     : Integer;
    f_DLowest   : Double;
    f_LowestIndex : Integer;
begin
    if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
    begin
        Result := 0;
        exit;
    end;

    f_DLowest := MAX_VALUE;
    if (p_Position - p_Count + 1 < 0) then
        p_Count := p_Position + 1;

    for f_Index := 0 to p_Count - 1 do
    begin
        if (f_DLowest > CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex]) then
        begin
            f_DLowest := CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex];
            f_LowestIndex := p_Position - f_Index;
        end;
    end;

    Result := f_LowestIndex;
end;

//---------------------------------------------------------------------------
{**
 *  p_Position에서 p_Position--p_Count+1 까지 최소값을 찾는다.
 *
 * @param    p_Count
 * @param    p_SrcValueArray
 * @param    p_PriceIndex
 * @param    p_Position
**}
function CFNMatrixLineValueSeries.LowestPrice(p_Count: Integer; p_SrcValueArray: CFNMatrixLineValueSeries;
  p_PriceIndex, p_Position: Integer): Double;
var
    f_Index : Integer;
    f_DLowest : Double;
begin
    if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
    begin
        Result := 0.0;
        exit;
    end;

    f_DLowest := MAX_VALUE;
    if (p_Position - p_Count + 1 < 0) then
        p_Count := p_Position + 1;

    for f_Index := 0 to p_Count - 1 do
    begin
        if (f_DLowest > CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex]) then
            f_DLowest := CFNMatrixLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex];
    end;

    Result := f_DLowest;
end;

//---------------------------------------------------------------------------
{**
 * 라인의 수를 설정한다.
 *
 * @param    p_LineCount  라인의 수
**}
procedure CFNMatrixLineValueSeries.SetLineCount(p_LineCount: Integer);
var
    f_Index : Integer;
begin
    Clear;

    m_LineCount     := p_LineCount;
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
        m_LineColors[f_Index]   := f_Index;
        m_LineWidths[f_Index]   := 0;
        m_LineAlphas[f_Index]   := 0;
        m_LineTypes[f_Index]    := 0;
        m_LineNames[f_Index]    := '';
        m_LineVisibles[f_Index]         := TRUE;
        m_LineLabelVisibles[f_Index]    := TRUE;
        m_LineLabelNameVisibles[f_Index]:= TRUE;
        m_LinePosValueVisibles[f_Index] := TRUE;
        m_LineMaxMinIndexs[f_Index] := 0;
    end;
end;

//---------------------------------------------------------------------------
{**
 * 값의 갯수를 결정한다.
 *
 * @param    p_Length
**}
procedure CFNMatrixLineValueSeries.SetLengthSeries(p_Length: Integer);
var
    f_Value : CFNMatrixLineValue;
    f_Index : Integer;
    f_delIndex : Integer;
    f_DelCnt : Integer;
    f_DelTotalCnt : Integer;
begin
    while (p_Length > m_Items.Count) do
    begin
        f_Value := CFNMatrixLineValue.Create(m_LineCount);
        m_Items.Add(f_Value);
    end;

    //if (p_Length < m_Items.length) {
    //    m_Items.splice(p_Length - 1, m_Items.length - p_Length);
    //}

    f_DelIndex        := p_Length - 1;
    f_DelCnt        := 0;
    f_DelTotalCnt   := (m_Items.Count - p_Length);
    while (f_DelCnt < f_DelTotalCnt) do
    begin
        f_Value := CFNMatrixLineValue(m_Items[f_DelIndex]);
        f_Value.Free;
        m_Items.Delete(f_DelIndex);

        Inc(f_DelCnt);
    end;
end;

procedure CFNMatrixLineValueSeries.CreateLineValueAdd(p_Index:Integer; p_Value:Double; p_Count:Integer=1);
var
    f_Index : Integer;
    f_Value : CFNMatrixLineValue;
begin
    for f_Index := 0 to p_Count - 1 do
    begin
        f_Value := CFNMatrixLineValue.Create(m_LineCount);
        f_Value.m_Value[p_Index] := p_Value;
        m_Items.Add(f_Value);
    end;
end;

procedure CFNMatrixLineValueSeries.ScanSignal(
p_ChartDataSeries:CFNMatrixChartDataSeries;
p_SignalArray:CFNSignalArray;
p_SystemNoIndex:integer;
p_SrcIndex:integer;
p_Begin, p_End: Integer);
var
    f_Index     : Integer;
    f_Size      : Integer;
    f_ChartData : CFNMatrixChartData;
    f_Value0    : CFNMatrixLineValue;
    f_Value1    : CFNMatrixLineValue;
    f_OldValue  : Integer;
    f_NewValue  : Integer;
    f_SignalData : CFNSignalData;
    f_Signal    :  Integer;
    f_SignalIndex    :  Integer;

    f_LastSignalData : CFNSignalData;
begin
    f_Size := p_ChartDataSeries.m_Items.Count;

    if (p_Begin = -1) then p_Begin := 0;
    if (p_End = -1) then p_End := f_Size;
    if (p_End > f_Size) then p_End := f_Size;
    if (p_Begin > m_Items.Count - 1) then p_Begin := m_Items.Count - 1;

    if (p_Begin < 0) then p_Begin := 0;

    if p_SignalArray.m_Items.Count > 0 then
    begin
        f_LastSignalData := p_SignalArray.m_Items.Items[p_SignalArray.m_Items.Count-1];
    end else
    begin
        f_LastSignalData := NIL;
    end;

    for f_Index := p_Begin to p_End-1 do
    begin
        f_ChartData     := p_ChartDataSeries.m_Items[f_Index];
        f_Value0        := m_Items[f_Index];
        if (f_Value0.m_Value[p_SrcIndex] = NOT_VALUE) then f_NewValue := 0
        else f_NewValue      := Trunc(f_Value0.m_Value[p_SrcIndex]);
        if (f_Index > 0) then
        begin
            f_Value1    := m_Items[f_Index-1];
            if (f_Value1.m_Value[p_SrcIndex] = NOT_VALUE) then f_OldValue  := 0
            else f_OldValue  := Trunc(f_Value1.m_Value[p_SrcIndex])
        end else
        begin
            f_Value1    := NIL;
            f_OldValue  := 0;
        end;

        if (f_OldValue <> 1) AND (f_NewValue = 1) then
        begin
            f_SignalIndex := f_Index;
            f_Signal    := SIGNAL_BUY_ENTER;

            if not (Assigned(f_LastSignalData) AND (f_LastSignalData.m_Signal = SIGNAL_BUY_ENTER)) then
            begin
                f_SignalData := CFNSignalData.Create;
                f_SignalData.m_SystemNo := Math.Floor(f_Value0.m_Value[p_SystemNoIndex]);
                f_SignalData.m_Index := f_Index;
                f_SignalData.m_DateTime := f_ChartData.m_OpenDateTime;
                f_SignalData.m_Signal := SIGNAL_BUY_ENTER;
                f_SignalData.m_Price := f_ChartData.OpenRealPrice;
                f_SignalData.m_OPS := f_ChartData.OpenQuarkPrice;
                p_SignalArray.Add(f_SignalData);
                f_LastSignalData := f_SignalData;
            end;
        end else
        if (f_OldValue <> -1) AND (f_NewValue = -1) then
        begin
            f_SignalIndex := f_Index;
            f_Signal    := SIGNAL_SELL_ENTER;
            if not (Assigned(f_LastSignalData) AND (f_LastSignalData.m_Signal = SIGNAL_SELL_ENTER)) then
            begin
                f_SignalData := CFNSignalData.Create;
                f_SignalData.m_SystemNo := Math.Floor(f_Value0.m_Value[p_SystemNoIndex]);
                f_SignalData.m_Index := f_Index;
                f_SignalData.m_DateTime := f_ChartData.m_OpenDateTime;
                f_SignalData.m_Signal := SIGNAL_SELL_ENTER;
                f_SignalData.m_Price := f_ChartData.OpenRealPrice;
                f_SignalData.m_OPS := f_ChartData.OpenQuarkPrice;
                p_SignalArray.Add(f_SignalData);
                f_LastSignalData := f_SignalData;
            end;
        end else
        if (f_OldValue =  1) AND (f_NewValue = 0) then
        begin
            f_SignalIndex := f_Index;
            f_Signal    := SIGNAL_BUY_EXIT;
            if not (Assigned(f_LastSignalData) AND (f_LastSignalData.m_Signal = SIGNAL_BUY_EXIT)) then
            begin
                f_SignalData := CFNSignalData.Create;
                f_SignalData.m_SystemNo := Math.Floor(f_Value0.m_Value[p_SystemNoIndex]);
                f_SignalData.m_Index := f_Index;
                f_SignalData.m_DateTime := f_ChartData.m_OpenDateTime;
                f_SignalData.m_Signal := SIGNAL_BUY_EXIT;
                f_SignalData.m_Price := f_ChartData.OpenRealPrice;
                f_SignalData.m_OPS := f_ChartData.OpenQuarkPrice;
                p_SignalArray.Add(f_SignalData);
                f_LastSignalData := f_SignalData;
            end;
        end else
        if (f_OldValue = -1) AND (f_NewValue = 0) then
        begin
            f_SignalIndex := f_Index;
            f_Signal    := SIGNAL_SELL_EXIT;
            if not (Assigned(f_LastSignalData) AND (f_LastSignalData.m_Signal = SIGNAL_SELL_EXIT)) then
            begin
                f_SignalData := CFNSignalData.Create;
                f_SignalData.m_SystemNo := Math.Floor(f_Value0.m_Value[p_SystemNoIndex]);
                f_SignalData.m_Index := f_Index;
                f_SignalData.m_DateTime := f_ChartData.m_OpenDateTime;
                f_SignalData.m_Signal := SIGNAL_SELL_EXIT;
                f_SignalData.m_Price := f_ChartData.OpenRealPrice;
                f_SignalData.m_OPS := f_ChartData.OpenQuarkPrice;
                p_SignalArray.Add(f_SignalData);
                f_LastSignalData := f_SignalData;
            end;
        end;
    end;
end;

function CFNMatrixLineValueSeries.ConsecutiveUp(ALineIndex:Integer; ACount:Integer; APosition:Integer):Boolean;
var
    f_Index0:Integer;
    f_Index1:Integer;
    f_Count:Integer;
    f_Up:Boolean;
    f_LineValue0:CFNMatrixLineValue;
    f_LineValue1:CFNMatrixLineValue;
begin
    f_Up := true;
    for f_Count := 0 to ACount-1 do
    begin
        f_Index0 := APosition - f_Count;
        f_Index1 := f_Index0 - 1;

        if (f_Index1 < 0) then
        begin
            f_Up := false;
            break;
        end;

        f_LineValue0 := m_Items.Items[f_Index0];
        f_LineValue1 := m_Items.Items[f_Index1];

        if (f_LineValue0.m_Value[ALineIndex] = NOT_VALUE) or (f_LineValue1.m_Value[ALineIndex] = NOT_VALUE) then
        begin
            f_Up := false;
            break;
        end else
        begin
            if (CompareValue(f_LineValue0.m_Value[ALineIndex],  f_LineValue1.m_Value[ALineIndex], 1) < 0) then
            begin
                f_Up := false;
                break;
            end else
            if (CompareValue(f_LineValue0.m_Value[ALineIndex],  0, 1) = 0) and (CompareValue(f_LineValue1.m_Value[ALineIndex],  0, 1) = 0) then
            begin
                f_Up := false;
                break;
            end;
        end;
    end;

    result := f_Up;
end;

function CFNMatrixLineValueSeries.ConsecutiveDn(ALineIndex:Integer; ACount:Integer; APosition:Integer):Boolean;
var
    f_Index0:Integer;
    f_Index1:Integer;
    f_Count:Integer;
    f_Dn:Boolean;
    f_LineValue0:CFNMatrixLineValue;
    f_LineValue1:CFNMatrixLineValue;
begin
    f_Dn := true;
    for f_Count := 0 to ACount-1 do
    begin
        f_Index0 := APosition - f_Count;
        f_Index1 := f_Index0 - 1;

        if (f_Index1 < 0) then
        begin
            f_Dn := false;
            break;
        end;

        f_LineValue0 := m_Items.Items[f_Index0];
        f_LineValue1 := m_Items.Items[f_Index1];

        if (f_LineValue0.m_Value[ALineIndex] = NOT_VALUE) or (f_LineValue1.m_Value[ALineIndex] = NOT_VALUE) then
        begin
            f_Dn := false;
            break;
        end else
        begin
            if (CompareValue(f_LineValue0.m_Value[ALineIndex],  f_LineValue1.m_Value[ALineIndex], 1) > 0) then
            begin
                f_Dn := false;
                break;
            end else
            if (CompareValue(f_LineValue0.m_Value[ALineIndex],  0, 1) = 0) and (CompareValue(f_LineValue1.m_Value[ALineIndex],  0, 1) = 0) then
            begin
                f_Dn := false;
                break;
            end;
        end;
    end;

    result := f_Dn;
end;

function CFNMatrixLineValueSeries.AboveOf(ALineIndex1:Integer; ALineIndex2:Integer; APosition:Integer):Boolean;
var
    f_Index0:Integer;
    f_Up:Boolean;
    f_LineValue0:CFNMatrixLineValue;
begin
    f_Index0 := APosition;
    f_LineValue0 := m_Items.Items[f_Index0];
    f_Up := false;
    if (f_LineValue0.m_Value[ALineIndex1] = NOT_VALUE) or (f_LineValue0.m_Value[ALineIndex2] = NOT_VALUE) then
    begin
        f_Up := true;
    end else
    if (CompareValue(f_LineValue0.m_Value[ALineIndex1], f_LineValue0.m_Value[ALineIndex2], 1) >= 0) then
    begin
        f_Up := true;
    end;

    result := f_Up;
end;

function CFNMatrixLineValueSeries.BelowOf(ALineIndex1:Integer; ALineIndex2:Integer; APosition:Integer):Boolean;
var
    f_Index0:Integer;
    f_Dn:Boolean;
    f_LineValue0:CFNMatrixLineValue;
begin
    f_Index0 := APosition;
    f_LineValue0 := m_Items.Items[f_Index0];
    f_Dn := false;
    if (f_LineValue0.m_Value[ALineIndex1] = NOT_VALUE) or (f_LineValue0.m_Value[ALineIndex2] = NOT_VALUE) then
    begin
        f_Dn := true;
    end else
    if (CompareValue(f_LineValue0.m_Value[ALineIndex1], f_LineValue0.m_Value[ALineIndex2], 1) <= 0) then
    begin
        f_Dn := true;
    end;

    result := f_Dn;
end;

end.

