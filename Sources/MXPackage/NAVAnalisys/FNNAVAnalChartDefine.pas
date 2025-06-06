unit FNNAVAnalChartDefine;

interface

uses
  Classes;

const
  IND_BB_NAME = 0;
  IND_ENVELOPE_NAME = 1;
  IND_ILMOK_NAME = 2;
  IND_MA_NAME = 3;
  IND_MAMULOVERLAY_NAME = 4;
  IND_NET_NAME = 5;
  IND_SAR_NAME = 6;
  IND_ADX_NAME = 7;
  IND_CCI_NAME = 8;
  IND_DMI_NAME = 9;
  IND_FASTSTC_NAME = 10;
  IND_MACD_NAME = 11;
  IND_OBV_NAME = 12;
  IND_PMAO_NAME = 13;
  IND_PSY_NAME = 14;
  IND_ROC_NAME = 15;
  IND_RSI_NAME = 16;
  IND_SLOWSTC_NAME = 17;
  IND_SONAR_NAME = 18;
  IND_TRIX_NAME = 19;
  IND_VOLUME_NAME = 20;
  IND_VR_NAME = 21;
  IND_WILLIAM_NAME = 22;
  IND_ATR_NAME = 23;
  IND_BBWIDTH_NAME = 24;
  IND_LRL_NAME = 25;
  IND_PF_NAME = 26;
  IND_SAMSUN_NAME = 27;
  IND_PRICE_NAME = 28;
  IND_CLOSE_NAME = 29;

  // ---------------------------------------------------------------------------
  // 차트 옵션 라벨명
  IND_BB_OPTION_LABEL1 = 0;
  IND_ENVELOPE_OPTION_LABEL1 = 1;
  IND_ENVELOPE_OPTION_LABEL2 = 2;
  IND_ILMOK_OPTION_LABEL1 = 3;
  IND_ILMOK_OPTION_LABEL2 = 4;
  IND_ILMOK_OPTION_LABEL3 = 5;
  IND_MA_OPTION_LABEL1 = 6;
  IND_MA_OPTION_LABEL2 = 7;
  IND_MA_OPTION_LABEL3 = 8;
  IND_MA_OPTION_LABEL4 = 9;
  IND_MAMULOVERLAY_OPTION_LABEL1 = 10;
  IND_NET_OPTION_LABEL1 = 11;
  IND_NET_OPTION_LABEL2 = 12;
  IND_NET_OPTION_LABEL3 = 13;
  IND_SAR_OPTION_LABEL1 = 14;
  IND_ADX_OPTION_LABEL1 = 15;
  IND_ADX_OPTION_LABEL2 = 16;
  IND_ADX_OPTION_LABEL3 = 17;
  IND_CCI_OPTION_LABEL1 = 18;
  IND_DMI_OPTION_LABEL1 = 19;
  IND_FASTSTC_OPTION_LABEL1 = 21;
  IND_FASTSTC_OPTION_LABEL2 = 22;
  IND_MACD_OPTION_LABEL1 = 23;
  IND_MACD_OPTION_LABEL2 = 24;
  IND_MACD_OPTION_LABEL3 = 25;
  IND_PMAO_OPTION_LABEL1 = 26;
  IND_PMAO_OPTION_LABEL2 = 27;
  IND_PSY_OPTION_LABEL1 = 28;
  IND_ROC_OPTION_LABEL1 = 29;
  IND_RSI_OPTION_LABEL1 = 30;
  IND_RSI_OPTION_LABEL2 = 31;
  IND_SLOWSTC_OPTION_LABEL1 = 32;
  IND_SLOWSTC_OPTION_LABEL2 = 33;
  IND_SLOWSTC_OPTION_LABEL3 = 34;
  IND_SONAR_OPTION_LABEL1 = 35;
  IND_SONAR_OPTION_LABEL2 = 36;
  IND_SONAR_OPTION_LABEL3 = 37;
  IND_TRIX_OPTION_LABEL1 = 38;
  IND_TRIX_OPTION_LABEL2 = 39;
  IND_VR_OPTION_LABEL1 = 40;
  IND_WILLIAM_OPTION_LABEL1 = 41;
  IND_WILLIAM_OPTION_LABEL2 = 42;

  // ---------------------------------------------------------------------------
  // Line 이름
  LINE_NAME_ADX1 = 0;
  LINE_NAME_ADX2 = 1;
  LINE_NAME_ATR1 = 2;
  LINE_NAME_ATR2 = 3;
  LINE_NAME_BB1 = 4;
  LINE_NAME_BB2 = 5;
  LINE_NAME_BB3 = 6;
  LINE_NAME_BB4 = 7;
  LINE_NAME_BBWIDTH1 = 8;
  LINE_NAME_BBWIDTH2 = 9;
  LINE_NAME_BBWIDTH3 = 10;
  LINE_NAME_CCI1 = 11;
  LINE_NAME_CCI2 = 12;
  LINE_NAME_CCI3 = 13;
  LINE_NAME_CCI4 = 14;
  LINE_NAME_CCI5 = 15;
  LINE_NAME_DMI1 = 16;
  LINE_NAME_DMI2 = 17;
  LINE_NAME_ENVELOPE1 = 18;
  LINE_NAME_ENVELOPE2 = 19;
  LINE_NAME_ENVELOPE3 = 20;
  LINE_NAME_FASTSTC1 = 21;
  LINE_NAME_FASTSTC2 = 22;
  LINE_NAME_ILMOK1 = 23;
  LINE_NAME_ILMOK2 = 24;
  LINE_NAME_ILMOK3 = 25;
  LINE_NAME_ILMOK4 = 26;
  LINE_NAME_ILMOK5 = 27;
  LINE_NAME_LRL1 = 28;
  LINE_NAME_MA1 = 29;
  LINE_NAME_MA2 = 30;
  LINE_NAME_MA3 = 31;
  LINE_NAME_MA4 = 32;
  LINE_NAME_MACD1 = 33;
  LINE_NAME_MACD2 = 34;
  LINE_NAME_MACD3 = 35;
  LINE_NAME_MACD4 = 36;
  LINE_NAME_MACD5 = 37;
  LINE_NAME_MAMULOVERLAY1 = 38;
  LINE_NAME_MAMULOVERLAY2 = 39;
  LINE_NAME_MAMULOVERLAY3 = 40;
  LINE_NAME_MAMULOVERLAY4 = 41;
  LINE_NAME_OBV1 = 42;
  LINE_NAME_PF1 = 43;
  LINE_NAME_PF2 = 44;
  LINE_NAME_PF3 = 45;
  LINE_NAME_PF4 = 46;
  LINE_NAME_PMAO1 = 47;
  LINE_NAME_PMAO2 = 48;
  LINE_NAME_PMAO3 = 49;
  LINE_NAME_PRICE1 = 50;
  LINE_NAME_PRICE2 = 51;
  LINE_NAME_PRICE3 = 52;
  LINE_NAME_PRICE4 = 53;
  LINE_NAME_PSY1 = 54;
  LINE_NAME_ROC1 = 55;
  LINE_NAME_RSI1 = 56;
  LINE_NAME_RSI2 = 57;
  LINE_NAME_SAMSUN1 = 58;
  LINE_NAME_SAMSUN2 = 59;
  LINE_NAME_SAMSUN3 = 60;
  LINE_NAME_SAMSUN4 = 61;
  LINE_NAME_SAMSUN5 = 62;
  LINE_NAME_SAR1 = 63;
  LINE_NAME_SAR2 = 64;
  LINE_NAME_SAR3 = 65;
  LINE_NAME_SAR4 = 66;
  LINE_NAME_SLOWSTC1 = 67;
  LINE_NAME_SLOWSTC2 = 68;
  LINE_NAME_SLOWSTC3 = 69;
  LINE_NAME_SONAR1 = 70;
  LINE_NAME_SONAR2 = 71;
  LINE_NAME_SONAR3 = 72;
  LINE_NAME_TRIX1 = 73;
  LINE_NAME_TRIX2 = 74;
  LINE_NAME_TRIX3 = 75;
  LINE_NAME_TRIX4 = 76;
  LINE_NAME_TRIX5 = 77;
  LINE_NAME_VOLUME1 = 78;
  LINE_NAME_VOLUME2 = 79;
  LINE_NAME_VR1 = 80;
  LINE_NAME_WILLIAM1 = 81;
  LINE_NAME_WILLIAM2 = 82;
  LINE_NAME_COMPARE = 83;

  LINE_NAME_SIGNAL1 = 84; // '10분'
  LINE_NAME_SIGNAL2 = 85; // '30분'
  LINE_NAME_SIGNAL3 = 86; // '60분'
  LINE_NAME_SIGNAL4 = 87; // '일간'

  // ---------------------------------------------------------------------------
  // 타임프레임
  TFS_MIN = 0; // '분간'
  TFS_DAY = 1; // '일간'
  TFS_WEEK = 2; // '주간'
  TFS_MONTH = 3; // '월간'
  TFS_MIN1 = 4; // '1분'
  TFS_MIN2 = 5; // '2분'
  TFS_MIN3 = 6; // '3분'
  TFS_MIN5 = 7; // '5분'
  TFS_MIN10 = 8; // '10분'
  TFS_MIN15 = 9; // '15분'
  TFS_MIN20 = 10; // '20분'
  TFS_MIN30 = 11; // '30분'
  TFS_MIN60 = 12; // '60분'

  // ---------------------------------------------------------------------------
  // 색상
  COLOR_BLACK = 0; // 블랙
  COLOR_WHITE = 1; // 블랙

  // 비교차트(200~)
  IDC_CMCHART_CAPTION = 200; // 비교차트
  IDC_CMCHART_TRACE = 201; // 위치정보
  IDC_CMCHART_YSCALE_LINEAR = 202; // Linear
  IDC_CMCHART_YSCALE_LOG = 203; // Log
  IDC_CMCHART_ZOOMIN = 204; // 확대
  IDC_CMCHART_ZOOMOUT = 205; // 축소
  IDC_CMCHART_ZOOMACTUAL = 206; // 원래대로

  // ---------------------------------------------------------------------------
  // 메세지
  IDS_CMCHART_RECV_ERROR = 1; //
  IDS_CMCHART_RECV_ERROR_PROC = 2; //
  IDS_CMCHART_RECV_ERROR_PARSER = 3; //
  IDS_CMCHART_SETTING_SAVE_ERROR = 4; //
  IDS_CMCHART_SETTING_READ_ERROR = 5; //
  IDS_CMCHART_RECV_EMPTY_DATA = 6;

  // ---------------------------------------------------------------------------
  // 라벨 및 텍스트
  CT_LOG = 0; // 비교차트 Y축 라벨
  CT_LINEAR = 1; // 비교차트 Y축 라벨
  CT_CAPTION_OPEN_PRICE = 2;
  CT_CAPTION_HIGHT_PRICE = 3;
  CT_CAPTION_LOW_PRICE = 4;
  CT_CAPTION_CLOSE_PRICE = 5;
  CT_CAPTION_VOLUME = 6;
  CT_CAPTION_DATE = 7;
  CT_CAPTION_DATETIME = 8;
  CT_CAPTION_DAY_LINE = 9;

  // ---------------------------------------------------------------------------
var
  g_IndicatorName: Array [0 .. 31 - 1] of String;
  g_IndicatorFullName: Array [0 .. 31 - 1] of String;
  g_IndicatorSmallName: Array [0 .. 31 - 1] of String;

  g_IndicatorOptionLabel: Array [0 .. 100 - 1] of String;
  g_LineName: Array [0 .. 100 - 1] of String;

  g_ChartTfString: Array [0 .. 100 - 1] of String;

  g_ChartMsgTable: Array [0 .. 1000 - 1] of String;
  g_ChartText: Array [0 .. 100 - 1] of String;

implementation

uses
  FNGlobal, FNGlobalVariable;

// ---------------------------------------------------------------------------
Initialization

begin
  g_IndicatorName[IND_BB_NAME] := '볼린저밴드';
  g_IndicatorName[IND_ENVELOPE_NAME] := 'Envelop';
  g_IndicatorName[IND_ILMOK_NAME] := '일목균형표';
  g_IndicatorName[IND_MA_NAME] := '이동평균선';
  g_IndicatorName[IND_MAMULOVERLAY_NAME] := '매물대';
  g_IndicatorName[IND_NET_NAME] := '그물차트';
  g_IndicatorName[IND_SAR_NAME] := 'Parabolic SAR';
  g_IndicatorName[IND_ADX_NAME] := 'ADX';
  g_IndicatorName[IND_CCI_NAME] := 'CCI';
  g_IndicatorName[IND_DMI_NAME] := 'DMI';
  g_IndicatorName[IND_FASTSTC_NAME] := 'Fast STC';
  g_IndicatorName[IND_MACD_NAME] := 'MACD';
  g_IndicatorName[IND_OBV_NAME] := 'OBV';
  g_IndicatorName[IND_PMAO_NAME] := 'PMAO';
  g_IndicatorName[IND_PSY_NAME] := '투자심리선';
  g_IndicatorName[IND_ROC_NAME] := 'ROC';
  g_IndicatorName[IND_RSI_NAME] := 'RSI';
  g_IndicatorName[IND_SLOWSTC_NAME] := 'Slow STC';
  g_IndicatorName[IND_SONAR_NAME] := 'SONAR';
  g_IndicatorName[IND_TRIX_NAME] := 'TRIX';
  g_IndicatorName[IND_VOLUME_NAME] := '거래량';
  g_IndicatorName[IND_VR_NAME] := 'VR';
  g_IndicatorName[IND_WILLIAM_NAME] := 'Williams %R';
  g_IndicatorName[IND_ATR_NAME] := 'ATR';
  g_IndicatorName[IND_BBWIDTH_NAME] := 'Band Width';
  g_IndicatorName[IND_LRL_NAME] := 'LRL';
  g_IndicatorName[IND_PF_NAME] := 'P&F';
  g_IndicatorName[IND_SAMSUN_NAME] := '삼선전환도';
  g_IndicatorName[IND_PRICE_NAME] := 'PRICE';
  g_IndicatorName[IND_CLOSE_NAME] := 'CLOSE';

  // ---------------------------------------------------------------------------
  // 차트 보조지표 전체 이름
  g_IndicatorFullName[IND_BB_NAME] := '볼린저밴드';
  g_IndicatorFullName[IND_ENVELOPE_NAME] := 'Envelop';
  g_IndicatorFullName[IND_ILMOK_NAME] := '일목균형표';
  g_IndicatorFullName[IND_MA_NAME] := '이동평균선';
  g_IndicatorFullName[IND_MAMULOVERLAY_NAME] := '매물대';
  g_IndicatorFullName[IND_NET_NAME] := '그물차트';
  g_IndicatorFullName[IND_SAR_NAME] := 'Parabolic SAR(Stop and Reversal)';
  g_IndicatorFullName[IND_ADX_NAME] := 'ADX(Average Directional Movement Index)';
  g_IndicatorFullName[IND_CCI_NAME] := 'CCI(Commodity Channel Index)';
  g_IndicatorFullName[IND_DMI_NAME] := 'DMI(Directional Movement Indicators)';
  g_IndicatorFullName[IND_FASTSTC_NAME] := 'Fast Stochastics';
  g_IndicatorFullName[IND_MACD_NAME] := 'MACD(Moving Average Convergence / Divergence)';
  g_IndicatorFullName[IND_OBV_NAME] := 'OBV(On Balance Volume)';
  g_IndicatorFullName[IND_PMAO_NAME] := 'PMAO(Price Oscillator)';
  g_IndicatorFullName[IND_PSY_NAME] := '투자심리선(Psychogical Line)';
  g_IndicatorFullName[IND_ROC_NAME] := 'ROC(Price Rate Of Change)';
  g_IndicatorFullName[IND_RSI_NAME] := 'RSI(Relative Strength Index)';
  g_IndicatorFullName[IND_SLOWSTC_NAME] := 'Slow Stochastics';
  g_IndicatorFullName[IND_SONAR_NAME] := 'SONAR';
  g_IndicatorFullName[IND_TRIX_NAME] := 'TRIX(Tripple Smoothed Moving Averages)';
  g_IndicatorFullName[IND_VOLUME_NAME] := '거래량';
  g_IndicatorFullName[IND_VR_NAME] := 'VR(Volume Ratio)';
  g_IndicatorFullName[IND_WILLIAM_NAME] := 'Williams %R';
  g_IndicatorFullName[IND_ATR_NAME] := 'ATR(Average True Range)';
  g_IndicatorFullName[IND_BBWIDTH_NAME] := '볼린저밴드 Width';
  g_IndicatorFullName[IND_LRL_NAME] := 'LRL(Linear Regression Line)';
  g_IndicatorFullName[IND_PF_NAME] := 'P&F';
  g_IndicatorFullName[IND_SAMSUN_NAME] := '삼선전환도';
  g_IndicatorFullName[IND_PRICE_NAME] := 'PRICE';
  g_IndicatorFullName[IND_CLOSE_NAME] := 'CLOSE';

  // ---------------------------------------------------------------------------
  // 보조지표(분석차트에서 보조지표 체크박스 캡션으로 사용)
  g_IndicatorSmallName[IND_BB_NAME] := '볼린저밴드';
  g_IndicatorSmallName[IND_ENVELOPE_NAME] := 'Envelop';
  g_IndicatorSmallName[IND_ILMOK_NAME] := '일목균형표';
  g_IndicatorSmallName[IND_MA_NAME] := '이동평균선';
  g_IndicatorSmallName[IND_MAMULOVERLAY_NAME] := '매물대';
  g_IndicatorSmallName[IND_NET_NAME] := '그물차트';
  g_IndicatorSmallName[IND_SAR_NAME] := 'Parabolic';
  g_IndicatorSmallName[IND_ADX_NAME] := 'ADX';
  g_IndicatorSmallName[IND_CCI_NAME] := 'CCI';
  g_IndicatorSmallName[IND_DMI_NAME] := 'DMI';
  g_IndicatorSmallName[IND_FASTSTC_NAME] := 'F STC';
  g_IndicatorSmallName[IND_MACD_NAME] := 'MACD';
  g_IndicatorSmallName[IND_OBV_NAME] := 'OBV';
  g_IndicatorSmallName[IND_PMAO_NAME] := 'PMAO';
  g_IndicatorSmallName[IND_PSY_NAME] := '투자심리선';
  g_IndicatorSmallName[IND_ROC_NAME] := 'ROC';
  g_IndicatorSmallName[IND_RSI_NAME] := 'RSI';
  g_IndicatorSmallName[IND_SLOWSTC_NAME] := 'S STC';
  g_IndicatorSmallName[IND_SONAR_NAME] := 'SONAR';
  g_IndicatorSmallName[IND_TRIX_NAME] := 'TRIX';
  g_IndicatorSmallName[IND_VOLUME_NAME] := '거래량';
  g_IndicatorSmallName[IND_VR_NAME] := 'VR';
  g_IndicatorSmallName[IND_WILLIAM_NAME] := 'Williams';
  g_IndicatorSmallName[IND_ATR_NAME] := 'ATR';
  g_IndicatorSmallName[IND_BBWIDTH_NAME] := 'Band Width';
  g_IndicatorSmallName[IND_LRL_NAME] := 'LRL';
  g_IndicatorSmallName[IND_PF_NAME] := 'P&F';
  g_IndicatorSmallName[IND_SAMSUN_NAME] := '삼선전환도';
  g_IndicatorSmallName[IND_PRICE_NAME] := 'PRICE';
  g_IndicatorSmallName[IND_CLOSE_NAME] := 'CLOSE';

  // ---------------------------------------------------------------------------
  // 차트 보조지표 옵션 라벨
  g_IndicatorOptionLabel[IND_BB_OPTION_LABEL1] := '기간';
  g_IndicatorOptionLabel[IND_ENVELOPE_OPTION_LABEL1] := '기간';
  g_IndicatorOptionLabel[IND_ENVELOPE_OPTION_LABEL2] := '가감값';
  g_IndicatorOptionLabel[IND_ILMOK_OPTION_LABEL1] := '전환선';
  g_IndicatorOptionLabel[IND_ILMOK_OPTION_LABEL2] := '기준,후,선';
  g_IndicatorOptionLabel[IND_ILMOK_OPTION_LABEL3] := '선행스팬';
  g_IndicatorOptionLabel[IND_MA_OPTION_LABEL1] := 'MA1';
  g_IndicatorOptionLabel[IND_MA_OPTION_LABEL2] := 'MA2';
  g_IndicatorOptionLabel[IND_MA_OPTION_LABEL3] := 'MA3';
  g_IndicatorOptionLabel[IND_MA_OPTION_LABEL4] := 'MA4';
  g_IndicatorOptionLabel[IND_MAMULOVERLAY_OPTION_LABEL1] := '갯수';
  g_IndicatorOptionLabel[IND_NET_OPTION_LABEL1] := '시작이평';
  g_IndicatorOptionLabel[IND_NET_OPTION_LABEL2] := '증가';
  g_IndicatorOptionLabel[IND_NET_OPTION_LABEL3] := '갯수';
  g_IndicatorOptionLabel[IND_SAR_OPTION_LABEL1] := 'AF최대값';
  g_IndicatorOptionLabel[IND_ADX_OPTION_LABEL1] := 'DMI기간';
  g_IndicatorOptionLabel[IND_ADX_OPTION_LABEL2] := 'ADX기간';
  g_IndicatorOptionLabel[IND_ADX_OPTION_LABEL3] := 'ADX이평';
  g_IndicatorOptionLabel[IND_CCI_OPTION_LABEL1] := '기간';
  g_IndicatorOptionLabel[IND_DMI_OPTION_LABEL1] := '기간';
  g_IndicatorOptionLabel[IND_FASTSTC_OPTION_LABEL1] := 'Fast%K';
  g_IndicatorOptionLabel[IND_FASTSTC_OPTION_LABEL2] := 'Fast%D';
  g_IndicatorOptionLabel[IND_MACD_OPTION_LABEL1] := '단기이평';
  g_IndicatorOptionLabel[IND_MACD_OPTION_LABEL2] := '장기이평';
  g_IndicatorOptionLabel[IND_MACD_OPTION_LABEL3] := 'Signal';
  g_IndicatorOptionLabel[IND_PMAO_OPTION_LABEL1] := '단기이평';
  g_IndicatorOptionLabel[IND_PMAO_OPTION_LABEL2] := '장기이평';
  g_IndicatorOptionLabel[IND_PSY_OPTION_LABEL1] := '기간';
  g_IndicatorOptionLabel[IND_ROC_OPTION_LABEL1] := '기간';
  g_IndicatorOptionLabel[IND_RSI_OPTION_LABEL1] := '기간';
  g_IndicatorOptionLabel[IND_RSI_OPTION_LABEL2] := 'Signal';
  g_IndicatorOptionLabel[IND_SLOWSTC_OPTION_LABEL1] := '기간';
  g_IndicatorOptionLabel[IND_SLOWSTC_OPTION_LABEL2] := 'Slow%K';
  g_IndicatorOptionLabel[IND_SLOWSTC_OPTION_LABEL3] := 'Slow%D';
  g_IndicatorOptionLabel[IND_SONAR_OPTION_LABEL1] := 'EMA기간';
  g_IndicatorOptionLabel[IND_SONAR_OPTION_LABEL2] := '기간';
  g_IndicatorOptionLabel[IND_SONAR_OPTION_LABEL3] := '이평';
  g_IndicatorOptionLabel[IND_TRIX_OPTION_LABEL1] := '단기이평';
  g_IndicatorOptionLabel[IND_TRIX_OPTION_LABEL2] := 'Signal';
  g_IndicatorOptionLabel[IND_VR_OPTION_LABEL1] := '기간';
  g_IndicatorOptionLabel[IND_WILLIAM_OPTION_LABEL1] := '%R';
  g_IndicatorOptionLabel[IND_WILLIAM_OPTION_LABEL2] := '%D';

  // ---------------------------------------------------------------------------
  // 라인이름
  g_LineName[LINE_NAME_ADX1] := 'ADX';
  g_LineName[LINE_NAME_ADX2] := 'MA';
  g_LineName[LINE_NAME_ATR1] := '';
  g_LineName[LINE_NAME_ATR2] := 'ATR';
  g_LineName[LINE_NAME_BB1] := 'U';
  g_LineName[LINE_NAME_BB2] := 'L';
  g_LineName[LINE_NAME_BB3] := 'M';
  g_LineName[LINE_NAME_BB4] := '';
  g_LineName[LINE_NAME_BBWIDTH1] := 'Band Width';
  g_LineName[LINE_NAME_BBWIDTH2] := '';
  g_LineName[LINE_NAME_BBWIDTH3] := '';
  g_LineName[LINE_NAME_CCI1] := '';
  g_LineName[LINE_NAME_CCI2] := '';
  g_LineName[LINE_NAME_CCI3] := '';
  g_LineName[LINE_NAME_CCI4] := '';
  g_LineName[LINE_NAME_CCI5] := 'CCI';
  g_LineName[LINE_NAME_DMI1] := 'PDI';
  g_LineName[LINE_NAME_DMI2] := 'MDI';
  g_LineName[LINE_NAME_ENVELOPE1] := 'U';
  g_LineName[LINE_NAME_ENVELOPE2] := 'L';
  g_LineName[LINE_NAME_ENVELOPE3] := 'M';
  g_LineName[LINE_NAME_FASTSTC1] := 'Fast %K';
  g_LineName[LINE_NAME_FASTSTC2] := 'Fast %D';
  g_LineName[LINE_NAME_ILMOK1] := '전환';
  g_LineName[LINE_NAME_ILMOK2] := '기준';
  g_LineName[LINE_NAME_ILMOK3] := '선행1';
  g_LineName[LINE_NAME_ILMOK4] := '선행2';
  g_LineName[LINE_NAME_ILMOK5] := '후행';
  g_LineName[LINE_NAME_LRL1] := 'LRL';
  g_LineName[LINE_NAME_MA1] := '';
  g_LineName[LINE_NAME_MA2] := '';
  g_LineName[LINE_NAME_MA3] := '';
  g_LineName[LINE_NAME_MA4] := '';
  g_LineName[LINE_NAME_MACD1] := '';
  g_LineName[LINE_NAME_MACD2] := '';
  g_LineName[LINE_NAME_MACD3] := 'MACD';
  g_LineName[LINE_NAME_MACD4] := 'Sign';
  g_LineName[LINE_NAME_MACD5] := 'Osc';
  g_LineName[LINE_NAME_MAMULOVERLAY1] := '';
  g_LineName[LINE_NAME_MAMULOVERLAY2] := '';
  g_LineName[LINE_NAME_MAMULOVERLAY3] := '';
  g_LineName[LINE_NAME_MAMULOVERLAY4] := '';
  g_LineName[LINE_NAME_OBV1] := 'OBV';
  g_LineName[LINE_NAME_PF1] := '';
  g_LineName[LINE_NAME_PF2] := '';
  g_LineName[LINE_NAME_PF3] := '';
  g_LineName[LINE_NAME_PF4] := '';
  g_LineName[LINE_NAME_PMAO1] := 'PMAO';
  g_LineName[LINE_NAME_PMAO2] := 'PMAO';
  g_LineName[LINE_NAME_PMAO3] := 'PMAO';
  g_LineName[LINE_NAME_PRICE1] := '시가';
  g_LineName[LINE_NAME_PRICE2] := '고가';
  g_LineName[LINE_NAME_PRICE3] := '저가';
  g_LineName[LINE_NAME_PRICE4] := '종가';
  g_LineName[LINE_NAME_PSY1] := '투자심리선';
  g_LineName[LINE_NAME_ROC1] := 'ROC';
  g_LineName[LINE_NAME_RSI1] := 'RSI';
  g_LineName[LINE_NAME_RSI2] := 'RSI-Signal';
  g_LineName[LINE_NAME_SAMSUN1] := '';
  g_LineName[LINE_NAME_SAMSUN2] := '';
  g_LineName[LINE_NAME_SAMSUN3] := '';
  g_LineName[LINE_NAME_SAMSUN4] := '';
  g_LineName[LINE_NAME_SAMSUN5] := '';
  g_LineName[LINE_NAME_SAR1] := '';
  g_LineName[LINE_NAME_SAR2] := '';
  g_LineName[LINE_NAME_SAR3] := '';
  g_LineName[LINE_NAME_SAR4] := 'Parabolic';
  g_LineName[LINE_NAME_SLOWSTC1] := 'Fast %K';
  g_LineName[LINE_NAME_SLOWSTC2] := 'Slow %K';
  g_LineName[LINE_NAME_SLOWSTC3] := 'Slow %D';
  g_LineName[LINE_NAME_SONAR1] := '';
  g_LineName[LINE_NAME_SONAR2] := 'SONAR';
  g_LineName[LINE_NAME_SONAR3] := 'MA';
  g_LineName[LINE_NAME_TRIX1] := '';
  g_LineName[LINE_NAME_TRIX2] := '';
  g_LineName[LINE_NAME_TRIX3] := '';
  g_LineName[LINE_NAME_TRIX4] := 'TRIX';
  g_LineName[LINE_NAME_TRIX5] := 'TRMA';
  g_LineName[LINE_NAME_VOLUME1] := '거래량';
  g_LineName[LINE_NAME_VOLUME2] := '';
  g_LineName[LINE_NAME_VR1] := 'VR';
  g_LineName[LINE_NAME_WILLIAM1] := '%R';
  g_LineName[LINE_NAME_WILLIAM2] := '%D';
  g_LineName[LINE_NAME_COMPARE] := '';

  g_LineName[LINE_NAME_SIGNAL1] := '10분'; // '10분'
  g_LineName[LINE_NAME_SIGNAL2] := '30분'; // '30분'
  g_LineName[LINE_NAME_SIGNAL3] := '60분'; // '60분'
  g_LineName[LINE_NAME_SIGNAL4] := '일간'; // '일간'

  // ---------------------------------------------------------------------------
  // 타임프레임
  g_ChartTfString[TFS_MIN] := '분간';
  g_ChartTfString[TFS_DAY] := '일간';
  g_ChartTfString[TFS_WEEK] := '주간';
  g_ChartTfString[TFS_MONTH] := '월간';
  g_ChartTfString[TFS_MIN1] := '1분';
  g_ChartTfString[TFS_MIN2] := '2분';
  g_ChartTfString[TFS_MIN3] := '3분';
  g_ChartTfString[TFS_MIN5] := '5분';
  g_ChartTfString[TFS_MIN10] := '10분';
  g_ChartTfString[TFS_MIN15] := '15분';
  g_ChartTfString[TFS_MIN20] := '20분';
  g_ChartTfString[TFS_MIN30] := '30분';
  g_ChartTfString[TFS_MIN60] := '60분';

  g_ChartMsgTable[IDS_CMCHART_RECV_ERROR] := '차트 조회 데이터 수신 오류';
  g_ChartMsgTable[IDS_CMCHART_RECV_ERROR_PROC] := '차트 데이터 수신 처리중 오류가 발생했습니다.';
  g_ChartMsgTable[IDS_CMCHART_RECV_ERROR_PARSER] := '수신한 차트 데이터 오류입니다.'#$0A' 창을 닫고 다시 실행하세요.';
  g_ChartMsgTable[IDS_CMCHART_SETTING_SAVE_ERROR] := '레지스트리 정보 저장 오류입니다.';
  g_ChartMsgTable[IDS_CMCHART_SETTING_READ_ERROR] := '레지스트리 정보 읽어오기 오류입니다.';
  g_ChartMsgTable[IDS_CMCHART_RECV_EMPTY_DATA] := '해당기간의 날짜와 시간에 해당하는 데이터를 찾을 수 없습니다.#$0A';

  // ---------------------------------------------------------------------------
  // TEXT
  g_ChartText[CT_LOG] := 'Logarithmic';
  g_ChartText[CT_LINEAR] := '';
  g_ChartText[CT_CAPTION_OPEN_PRICE] := '시가';
  g_ChartText[CT_CAPTION_HIGHT_PRICE] := '고가';
  g_ChartText[CT_CAPTION_LOW_PRICE] := '저가';
  g_ChartText[CT_CAPTION_CLOSE_PRICE] := '종가';
  g_ChartText[CT_CAPTION_VOLUME] := '거래량';
  g_ChartText[CT_CAPTION_DATE] := '날짜';
  g_ChartText[CT_CAPTION_DATETIME] := '시간';
  g_ChartText[CT_CAPTION_DAY_LINE] := '일선';
end;

// ---------------------------------------------------------------------------
Finalization

begin
end;

// ---------------------------------------------------------------------------
end.
