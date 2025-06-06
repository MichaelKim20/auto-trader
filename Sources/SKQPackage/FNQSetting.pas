unit FNQSetting;

interface

uses
    SysUtils, Classes, FNRegistry, Dialogs, FNQIndicatorValue;

const
    MAXTIMEFRAMECOUNT = 14;

var
    g_TimeFrame : Array [0..MAXTIMEFRAMECOUNT-1] of Integer;

type

    CFNQSetting = class(TObject)
    public
    const
        IND_BB                      : Integer   =  0;
        IND_ENVELOP                 : Integer     =  1;
        IND_ILMOK                   : Integer     =  2;
        IND_MA                      : Integer     =  3;
        IND_MAMULOVERLAY            : Integer     =  4;
        IND_NET                     : Integer     =  5;
        IND_SAR                     : Integer     =  6;

        IND_OVERLAY_OPS             : Integer     =  7;
        IND_OVERLAY_OPSIGUK         : Integer     =  8;
        IND_OVERLAY_OPSIGUK2        : Integer     =  9;
        IND_OVERLAY_OPSSTDDEV       : Integer     = 10;
        IND_OVERLAY_OPSREL          : Integer     = 11;

        IND_ADX                     : Integer     = 12;
        IND_CCI                     : Integer     = 13;
        IND_DMI                     : Integer     = 14;
        IND_FASTSTC                 : Integer     = 15;
        IND_MACD                    : Integer     = 16;
        IND_OBV                     : Integer     = 17;
        IND_PMAO                    : Integer     = 18;
        IND_PSY                     : Integer     = 19;
        IND_ROC                     : Integer     = 20;
        IND_RSI                     : Integer     = 21;
        IND_SLOWSTC                 : Integer     = 22;
        IND_SONAR                   : Integer     = 23;
        IND_TRIX                    : Integer     = 24;
        IND_VOLUME                  : Integer     = 25;
        IND_VR                      : Integer     = 26;
        IND_WILLIAM                 : Integer     = 27;
        IND_OPS                     : Integer     = 28;
        IND_OPSIGUK                 : Integer     = 29;
        IND_OPSIGUK2                : Integer     = 30;
        IND_OPSSTDDEV               : Integer     = 31;
        IND_OPSREL                  : Integer     = 32;

        IND_PRICE_MA_CROSS_SIGNAL   : Integer     = 33;
        IND_MA_CROSS_SIGNAL         : Integer     = 34;
        IND_MACD_CROSS_SIGNAL       : Integer     = 35;
        IND_SSTC_CROSS_SIGNAL       : Integer     = 36;
        IND_FSTC_CROSS_SIGNAL       : Integer     = 37;
        IND_RSI_CROSS_SIGNAL        : Integer     = 38;
        IND_ADX_CROSS_SIGNAL        : Integer     = 39;
        IND_WILLIAM_CROSS_SIGNAL    : Integer     = 40;
        IND_SONAR_CROSS_SIGNAL      : Integer     = 41;
        IND_TRIX_CROSS_SIGNAL       : Integer     = 42;
        IND_NMA_TREND_SIGNAL        : Integer     = 43;
        IND_WMA_TREND_SIGNAL        : Integer     = 44;
        IND_XMA_TREND_SIGNAL        : Integer     = 45;

        IND_OVERLAYVALUEMIN     : Integer    =  0;
        IND_OVERLAYVALUEMAX     : Integer    = 11;

        IND_INDICATORVALUEMIN   : Integer    = 12;
        IND_INDICATORVALUEMAX   : Integer    = 32;

        IND_SIGNALVALUEMIN      : Integer    = 33;
        IND_SIGNALVALUEMAX      : Integer    = 45;

    public
        m_Indicator             : TList;
        m_SequenceO             : TList;
        m_SequenceI             : TList;
        m_SequenceS             : TList;
        m_SelectedIndexO        : Integer;
        m_SelectedIdentityO     : Integer;
        m_SelectedIndexI        : Integer;
        m_SelectedIdentityI     : Integer;
        m_SelectedIndexS        : Integer;
        m_SelectedIdentityS     : Integer;

        m_RequestCount          : Integer;
        m_BuySellReport         : Boolean;

        m_Symbol        : String;
        m_Name          : String;
        m_Scale         : Integer;
        m_TraceVisible  : Boolean;
        m_TimeFrame     : Integer;
        m_TimeFrameIndex: Integer;
        m_MinTimeFrame  : Integer;
        m_ChartType     : Integer;
        m_ColorSetIndex : Integer;
        m_ConfigVisible : Boolean;
        m_UseOPSPrice   : Boolean;

        m_Registry      : CFNRegistry;
        m_RegSection    : String;
  private

  public
        constructor Create();
        destructor  Destroy(); override;
        procedure Clear;

        procedure Initialize();
        procedure Finalize();
        function FindIdentity(p_Value:String) : Integer;

        procedure AddO(p_Value:Integer);
        function FindO(p_Value:Integer) : Integer;
        function DeleteO(p_Value:Integer) : Integer;
        function GetFirstValueO() : Integer;
        function GetIndCountO() : Integer;

        procedure AddI(p_Value:Integer);
        function FindI(p_Value:Integer) : Integer;
        function DeleteI(p_Value:Integer) : Integer;
        function GetFirstValueI() : Integer;
        function GetIndCountI() : Integer;

        procedure AddS(p_Value: Integer);
        function DeleteS(p_Value: Integer): Integer;
        function FindS(p_Value: Integer): Integer;
        function GetFirstValueS: Integer;
        function GetIndCountS: Integer;

        procedure SaveSetting();
        procedure ReadSetting();
        procedure SetRegistry(f_Registry:CFNRegistry);
        procedure SetRegSection(f_Section:String);

        procedure DeleteAll;

        procedure ClearSequenceO;
        procedure ClearSequenceI;
        procedure ClearSequenceS;
    end;

implementation
uses
    FNGlobal, FNQConst, FNQChartDefine;


//---------------------------------------------------------------------------
constructor CFNQSetting.Create();
begin
    inherited Create();

    Initialize();
end;

//---------------------------------------------------------------------------
destructor CFNQSetting.Destroy();
begin
    Finalize();

    inherited Destroy();
end;

//---------------------------------------------------------------------------
procedure CFNQSetting.Clear;
var
    f_Registry      : CFNRegistry;
    f_RegSection    : String;
begin
    f_Registry := m_Registry;
    f_RegSection := m_RegSection;

    Finalize;
    Initialize;

    m_Registry := f_Registry;
    m_RegSection := f_RegSection;
end;

//---------------------------------------------------------------------------
procedure CFNQSetting.Initialize;
var
    f_Index     : Integer;
    f_Indicator : CFNQIndicatorValue;
begin
    m_SelectedIndexO    := -1;
    m_SelectedIndexI    := -1;
    m_SelectedIndexS    := -1;
    m_SelectedIdentityO := -1;
    m_SelectedIdentityI := -1;
    m_SelectedIdentityS := -1;

    m_Indicator         := TList.Create();
    m_SequenceO         := TList.Create();
    m_SequenceI         := TList.Create();
    m_SequenceS         := TList.Create();

    m_Registry          := NIL;
    m_RegSection        := 'Chart';

    m_TimeFrameIndex    := 4;
    m_TimeFrame         := 360;
    m_MinTimeFrame      := 5;
    m_ChartType         := 0;
    m_Scale             := 0;
    m_TraceVisible      := true;
    m_ColorSetIndex     := CFNQConst.COLOR_SET_WHITE;
    m_ConfigVisible     := true;
    m_UseOPSPrice       := false;
    m_RequestCount      := 1;
    m_BuySellReport     := true;

    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_BB_NAME];
    f_Indicator.m_Value                     := IND_BB;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.m_AddType                   := 0;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_BB_OPTION_LABEL1];  //'기간';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 20;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_ENVELOPE_NAME];        //'Envelop';
    f_Indicator.m_Value                     := IND_ENVELOP;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.m_AddType                   := 0;
    f_Indicator.SetOptionCount(2);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_ENVELOPE_OPTION_LABEL1];    //'기간';
    f_Indicator.m_OptionLabel[1]            := g_IndicatorOptionLabel[IND_ENVELOPE_OPTION_LABEL2];    //'가감값';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 100;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 20;
    f_Indicator.m_OptionDefaultValue[1]     := 5;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_ILMOK_NAME];        //'일목균형표';
    f_Indicator.m_Value                     := IND_ILMOK;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.m_AddType                   := 0;
    f_Indicator.SetOptionCount(3);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_ILMOK_OPTION_LABEL1];    //'전환선';
    f_Indicator.m_OptionLabel[1]            := g_IndicatorOptionLabel[IND_ILMOK_OPTION_LABEL2];    //'기준,후,선';
    f_Indicator.m_OptionLabel[2]            := g_IndicatorOptionLabel[IND_ILMOK_OPTION_LABEL3];    //'선행스팬';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMaximum[2]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionMinimum[2]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionStepSize[2]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 9;
    f_Indicator.m_OptionDefaultValue[1]     := 26;
    f_Indicator.m_OptionDefaultValue[2]     := 52;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    f_Indicator.m_OptionFactor[2]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_MA_NAME];        //'이동평균선';
    f_Indicator.m_Value                     := IND_MA;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.m_AddType                   := 0;
    f_Indicator.SetOptionCount(4);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_MA_OPTION_LABEL1];    //'MA1';
    f_Indicator.m_OptionLabel[1]            := g_IndicatorOptionLabel[IND_MA_OPTION_LABEL2];    //'MA2';
    f_Indicator.m_OptionLabel[2]            := g_IndicatorOptionLabel[IND_MA_OPTION_LABEL3];    //'MA3';
    f_Indicator.m_OptionLabel[3]            := g_IndicatorOptionLabel[IND_MA_OPTION_LABEL4];    //'MA4';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMaximum[2]          := 300;
    f_Indicator.m_OptionMaximum[3]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionMinimum[2]          := 1;
    f_Indicator.m_OptionMinimum[3]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionStepSize[2]         := 1;
    f_Indicator.m_OptionStepSize[3]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 5;
    f_Indicator.m_OptionDefaultValue[1]     := 20;
    f_Indicator.m_OptionDefaultValue[2]     := 60;
    f_Indicator.m_OptionDefaultValue[3]     := 120;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    f_Indicator.m_OptionFactor[2]           := 1;
    f_Indicator.m_OptionFactor[3]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_MAMULOVERLAY_NAME];
    f_Indicator.m_Value                     := IND_MAMULOVERLAY;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.m_AddType                   := 0;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_MAMULOVERLAY_OPTION_LABEL1];
    f_Indicator.m_OptionMaximum[0]          := 30;
    f_Indicator.m_OptionMinimum[0]          := 5;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 10;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_NET_NAME];
    f_Indicator.m_Value                     := IND_NET;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.m_AddType                   := 0;
    f_Indicator.SetOptionCount(3);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_NET_OPTION_LABEL1];
    f_Indicator.m_OptionLabel[1]            := g_IndicatorOptionLabel[IND_NET_OPTION_LABEL2];
    f_Indicator.m_OptionLabel[2]            := g_IndicatorOptionLabel[IND_NET_OPTION_LABEL3];
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 30;
    f_Indicator.m_OptionMaximum[2]          := 30;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionMinimum[2]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionStepSize[2]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 5;
    f_Indicator.m_OptionDefaultValue[1]     := 2;
    f_Indicator.m_OptionDefaultValue[2]     := 10;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    f_Indicator.m_OptionFactor[2]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_SAR_NAME];
    f_Indicator.m_Value                     := IND_SAR;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.m_AddType                   := 0;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_SAR_OPTION_LABEL1];
    f_Indicator.m_OptionMaximum[0]          := 0.50;
    f_Indicator.m_OptionMinimum[0]          := 0.01;
    f_Indicator.m_OptionStepSize[0]         := 0.001;
    f_Indicator.m_OptionDefaultValue[0]     := 0.02;
    f_Indicator.m_OptionFactor[0]           := 1000;
    m_Indicator.Add(f_Indicator);



    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '오메가';
    f_Indicator.m_Value                     := IND_OVERLAY_OPS;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.m_AddType                   := 0;
    f_Indicator.SetOptionCount(0);
    m_Indicator.Add(f_Indicator);


    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '오메가 이격율';
    f_Indicator.m_Value                     := IND_OVERLAY_OPSIGUK;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.m_AddType                   := 0;
    f_Indicator.SetOptionCount(0);
    m_Indicator.Add(f_Indicator);


    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '오메가2';
    f_Indicator.m_Value                     := IND_OVERLAY_OPSIGUK2;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.m_AddType                   := 0;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := '기간';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 60;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);

    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '오메가 표준편차';
    f_Indicator.m_Value                     := IND_OVERLAY_OPSSTDDEV;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.m_AddType                   := 0;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := '기간';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 60;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);

    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '오메가 상관차트';
    f_Indicator.m_Value                     := IND_OVERLAY_OPSREL;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.m_AddType                   := 0;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := '기간';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 60;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);


    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_ADX_NAME];
    f_Indicator.m_Value                     := IND_ADX;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(3);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_ADX_OPTION_LABEL1];
    f_Indicator.m_OptionLabel[1]            := g_IndicatorOptionLabel[IND_ADX_OPTION_LABEL2];
    f_Indicator.m_OptionLabel[2]            := g_IndicatorOptionLabel[IND_ADX_OPTION_LABEL3];
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMaximum[2]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionMinimum[2]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionStepSize[2]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 14;
    f_Indicator.m_OptionDefaultValue[1]     := 14;
    f_Indicator.m_OptionDefaultValue[2]     := 9;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    f_Indicator.m_OptionFactor[2]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_CCI_NAME];
    f_Indicator.m_Value                     := IND_CCI;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_CCI_OPTION_LABEL1];
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 9;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_DMI_NAME];
    f_Indicator.m_Value                     := IND_DMI;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_DMI_OPTION_LABEL1];
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 14;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_FASTSTC_NAME];
    f_Indicator.m_Value                     := IND_FASTSTC;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(2);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_FASTSTC_OPTION_LABEL1];
    f_Indicator.m_OptionLabel[1]            := g_IndicatorOptionLabel[IND_FASTSTC_OPTION_LABEL2];
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 15;
    f_Indicator.m_OptionDefaultValue[1]     := 5;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_MACD_NAME];
    f_Indicator.m_Value                     := IND_MACD;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(3);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_MACD_OPTION_LABEL1];
    f_Indicator.m_OptionLabel[1]            := g_IndicatorOptionLabel[IND_MACD_OPTION_LABEL2];
    f_Indicator.m_OptionLabel[2]            := g_IndicatorOptionLabel[IND_MACD_OPTION_LABEL3];
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMaximum[2]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionMinimum[2]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionStepSize[2]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 12;
    f_Indicator.m_OptionDefaultValue[1]     := 26;
    f_Indicator.m_OptionDefaultValue[2]     := 9;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    f_Indicator.m_OptionFactor[2]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_OBV_NAME];
    f_Indicator.m_Value                     := IND_OBV;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(0);
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_PMAO_NAME];
    f_Indicator.m_Value                     := IND_PMAO;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(2);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_PMAO_OPTION_LABEL1];
    f_Indicator.m_OptionLabel[1]            := g_IndicatorOptionLabel[IND_PMAO_OPTION_LABEL2];
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 5;
    f_Indicator.m_OptionDefaultValue[1]     := 20;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_PSY_NAME];
    f_Indicator.m_Value                     := IND_PSY;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_PSY_OPTION_LABEL1];
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 10;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_ROC_NAME];
    f_Indicator.m_Value                     := IND_ROC;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_ROC_OPTION_LABEL1];
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 12;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_RSI_NAME];
    f_Indicator.m_Value                     := IND_RSI;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(2);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_RSI_OPTION_LABEL1];
    f_Indicator.m_OptionLabel[1]            := g_IndicatorOptionLabel[IND_RSI_OPTION_LABEL2];
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 10;
    f_Indicator.m_OptionDefaultValue[1]     := 5;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_SLOWSTC_NAME];
    f_Indicator.m_Value                     := IND_SLOWSTC;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(3);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_SLOWSTC_OPTION_LABEL1];
    f_Indicator.m_OptionLabel[1]            := g_IndicatorOptionLabel[IND_SLOWSTC_OPTION_LABEL2];
    f_Indicator.m_OptionLabel[2]            := g_IndicatorOptionLabel[IND_SLOWSTC_OPTION_LABEL3];
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMaximum[2]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionMinimum[2]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionStepSize[2]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 15;
    f_Indicator.m_OptionDefaultValue[1]     := 5;
    f_Indicator.m_OptionDefaultValue[2]     := 3;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    f_Indicator.m_OptionFactor[2]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_SONAR_NAME];
    f_Indicator.m_Value                     := IND_SONAR;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(3);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_SONAR_OPTION_LABEL1];
    f_Indicator.m_OptionLabel[1]            := g_IndicatorOptionLabel[IND_SONAR_OPTION_LABEL2];
    f_Indicator.m_OptionLabel[2]            := g_IndicatorOptionLabel[IND_SONAR_OPTION_LABEL3];
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMaximum[2]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionMinimum[2]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionStepSize[2]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 12;
    f_Indicator.m_OptionDefaultValue[1]     := 26;
    f_Indicator.m_OptionDefaultValue[2]     := 9;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    f_Indicator.m_OptionFactor[2]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_TRIX_NAME];
    f_Indicator.m_Value                     := IND_TRIX;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(2);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_TRIX_OPTION_LABEL1];
    f_Indicator.m_OptionLabel[1]            := g_IndicatorOptionLabel[IND_TRIX_OPTION_LABEL2];
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 5;
    f_Indicator.m_OptionDefaultValue[1]     := 3;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_VOLUME_NAME]; //'거래량';
    f_Indicator.m_Value                     := IND_VOLUME;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(0);
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_VR_NAME]; //'VR';
    f_Indicator.m_Value                     := IND_VR;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_VR_OPTION_LABEL1];    //'기간';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 20;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := g_IndicatorName[IND_WILLIAM_NAME]; //'Williams'' %R';
    f_Indicator.m_Value                     := IND_WILLIAM;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(2);
    f_Indicator.m_OptionLabel[0]            := g_IndicatorOptionLabel[IND_WILLIAM_OPTION_LABEL1];    //'%R';
    f_Indicator.m_OptionLabel[1]            := g_IndicatorOptionLabel[IND_WILLIAM_OPTION_LABEL2];    //'%D';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 14;
    f_Indicator.m_OptionDefaultValue[1]     := 3;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    m_Indicator.Add(f_Indicator);

    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '오메가';
    f_Indicator.m_Value                     := IND_OPS;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(0);
    m_Indicator.Add(f_Indicator);


    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '오메가 이격율';
    f_Indicator.m_Value                     := IND_OPSIGUK;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(0);
    m_Indicator.Add(f_Indicator);

    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '오메가2';
    f_Indicator.m_Value                     := IND_OPSIGUK2;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := '기간';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 60;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);

    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '오메가 표준편차';
    f_Indicator.m_Value                     := IND_OPSSTDDEV;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := '기간';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 60;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);


    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '오메가 상관차트';
    f_Indicator.m_Value                     := IND_OPSREL;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := '기간';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 60;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '주가(오메가):이평 돌파 매매분석';
    f_Indicator.m_Value                     := IND_PRICE_MA_CROSS_SIGNAL;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(1);
    f_Indicator.m_OptionLabel[0]            := '기간';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 60;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////

    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '이동평균선 돌파 매매분석';
    f_Indicator.m_Value                     := IND_MA_CROSS_SIGNAL;
    f_Indicator.m_ViewIndicator             := false;

    f_Indicator.SetOptionCount(2);

    f_Indicator.m_OptionLabel[0]            := '단기이평';
    f_Indicator.m_OptionLabel[1]            := '장기이평';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 20;
    f_Indicator.m_OptionDefaultValue[1]     := 60;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////

    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := 'MACD 돌파 매매분석';
    f_Indicator.m_Value                     := IND_MACD_CROSS_SIGNAL;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(3);
    f_Indicator.m_OptionLabel[0]            := '단기이평';
    f_Indicator.m_OptionLabel[1]            := '장기이평';
    f_Indicator.m_OptionLabel[2]            := 'Signal';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMaximum[2]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionMinimum[2]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionStepSize[2]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 12;
    f_Indicator.m_OptionDefaultValue[1]     := 26;
    f_Indicator.m_OptionDefaultValue[2]     := 9;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    f_Indicator.m_OptionFactor[2]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    ///
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := 'Slow STC 돌파 매매분석';
    f_Indicator.m_Value                     := IND_SSTC_CROSS_SIGNAL;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(3);
    f_Indicator.m_OptionLabel[0]            := '기간';
    f_Indicator.m_OptionLabel[1]            := 'Slow%K';
    f_Indicator.m_OptionLabel[2]            := 'Slow%D';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMaximum[2]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionMinimum[2]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionStepSize[2]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 15;
    f_Indicator.m_OptionDefaultValue[1]     := 5;
    f_Indicator.m_OptionDefaultValue[2]     := 3;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    f_Indicator.m_OptionFactor[2]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    ///
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := 'Fast STC 돌파 매매분석';
    f_Indicator.m_Value                     := IND_FSTC_CROSS_SIGNAL;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(2);
    f_Indicator.m_OptionLabel[0]            := 'Fast%K';
    f_Indicator.m_OptionLabel[1]            := 'Fast%D';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 15;
    f_Indicator.m_OptionDefaultValue[1]     := 5;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    m_Indicator.Add(f_Indicator);


    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := 'RSI 돌파 매매분석';
    f_Indicator.m_Value                     := IND_RSI_CROSS_SIGNAL;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(2);
    f_Indicator.m_OptionLabel[0]            := '기간';
    f_Indicator.m_OptionLabel[1]            := 'Signal';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 10;
    f_Indicator.m_OptionDefaultValue[1]     := 5;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    m_Indicator.Add(f_Indicator);

    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := 'ADX 돌파 매매분석';
    f_Indicator.m_Value                     := IND_ADX_CROSS_SIGNAL;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(3);
    f_Indicator.m_OptionLabel[0]            := 'DMI기간';
    f_Indicator.m_OptionLabel[1]            := 'ADX기간';
    f_Indicator.m_OptionLabel[2]            := 'ADX이평';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMaximum[2]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionMinimum[2]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionStepSize[2]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 14;
    f_Indicator.m_OptionDefaultValue[1]     := 14;
    f_Indicator.m_OptionDefaultValue[2]     := 9;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    f_Indicator.m_OptionFactor[2]           := 1;
    m_Indicator.Add(f_Indicator);


    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := 'Williams'' %R 돌파 매매분석';
    f_Indicator.m_Value                     := IND_WILLIAM_CROSS_SIGNAL;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(2);
    f_Indicator.m_OptionLabel[0]            := '%R';
    f_Indicator.m_OptionLabel[1]            := '%D';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 14;
    f_Indicator.m_OptionDefaultValue[1]     := 3;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    m_Indicator.Add(f_Indicator);


    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := 'SONAR 돌파 매매분석';
    f_Indicator.m_Value                     := IND_SONAR_CROSS_SIGNAL;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(3);
    f_Indicator.m_OptionLabel[0]            := 'EMA기간';
    f_Indicator.m_OptionLabel[1]            := '기간';
    f_Indicator.m_OptionLabel[2]            := '이평';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMaximum[2]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionMinimum[2]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionStepSize[2]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 12;
    f_Indicator.m_OptionDefaultValue[1]     := 26;
    f_Indicator.m_OptionDefaultValue[2]     := 9;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    f_Indicator.m_OptionFactor[2]           := 1;
    m_Indicator.Add(f_Indicator);


    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := 'TRIX 돌파 매매분석';
    f_Indicator.m_Value                     := IND_TRIX_CROSS_SIGNAL;
    f_Indicator.m_ViewIndicator             := false;
    f_Indicator.SetOptionCount(2);
    f_Indicator.m_OptionLabel[0]            := '단기이평';
    f_Indicator.m_OptionLabel[1]            := 'Signal';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMaximum[1]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionMinimum[1]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionStepSize[1]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 5;
    f_Indicator.m_OptionDefaultValue[1]     := 3;
    f_Indicator.m_OptionFactor[0]           := 1;
    f_Indicator.m_OptionFactor[1]           := 1;
    m_Indicator.Add(f_Indicator);

    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '단순이평선 추세전환 매매분석';
    f_Indicator.m_Value                     := IND_NMA_TREND_SIGNAL;
    f_Indicator.m_ViewIndicator             := false;

    f_Indicator.SetOptionCount(1);

    f_Indicator.m_OptionLabel[0]            := '이평';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 60;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);

    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '가중이평선 추세전환 매매분석';
    f_Indicator.m_Value                     := IND_WMA_TREND_SIGNAL;
    f_Indicator.m_ViewIndicator             := false;

    f_Indicator.SetOptionCount(1);

    f_Indicator.m_OptionLabel[0]            := '이평';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 60;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);

    ////////////////////////////////////////////////
    f_Indicator := CFNQIndicatorValue.Create();
    f_Indicator.Initialize();
    f_Indicator.m_Name                      := '지수이평선 추세전환 매매분석';
    f_Indicator.m_Value                     := IND_XMA_TREND_SIGNAL;
    f_Indicator.m_ViewIndicator             := false;

    f_Indicator.SetOptionCount(1);

    f_Indicator.m_OptionLabel[0]            := '이평';
    f_Indicator.m_OptionMaximum[0]          := 300;
    f_Indicator.m_OptionMinimum[0]          := 1;
    f_Indicator.m_OptionStepSize[0]         := 1;
    f_Indicator.m_OptionDefaultValue[0]     := 60;
    f_Indicator.m_OptionFactor[0]           := 1;
    m_Indicator.Add(f_Indicator);
    ////////////////////////////////////////////////
    for f_Index := 0 to m_Indicator.Count - 1 do
    begin
        f_Indicator := CFNQIndicatorValue(m_Indicator[f_Index]);
        f_Indicator.SetDefaultValue();
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQSetting.Finalize();
var
    f_Index     : Integer;
begin
    while (0 < m_Indicator.Count) do
    begin
        CFNQIndicatorValue(m_Indicator[0]).Free();
        m_Indicator.Delete(0);
    end;

    while (0 < m_SequenceO.Count) do
    begin
        Dispose(m_SequenceO.Items[0]);
        m_SequenceO.Delete(0);
    end;

    while (0 < m_SequenceI.Count) do
    begin
        Dispose(m_SequenceI.Items[0]);
        m_SequenceI.Delete(0);
    end;

    while (0 < m_SequenceS.Count) do
    begin
        Dispose(m_SequenceS.Items[0]);
        m_SequenceS.Delete(0);
    end;

    m_Indicator.Free();
    m_Indicator := NIL;

    m_SequenceO.Free();
    m_SequenceO := NIL;

    m_SequenceI.Free();
    m_SequenceI := NIL;

    m_SequenceS.Free();
    m_SequenceS := NIL;

    m_Registry := NIL;
end;

//---------------------------------------------------------------------------
procedure CFNQSetting.AddI(p_Value: Integer);
var
    f_FindIndex : Integer;
    f_newValue : ^Integer;
begin
    f_FindIndex := FindI(p_Value);
    if (f_FindIndex = -1) then
    begin
        new(f_newValue);
        f_newValue^ := p_Value;
        m_SequenceI.Add(f_newValue);
    end;
end;

//---------------------------------------------------------------------------
//오버레이지표를 추가한다.
procedure CFNQSetting.AddO(p_Value: Integer);
var
    f_FindIndex:Integer;
    f_newValue : ^Integer;
begin
    f_FindIndex := FindO(p_Value);
    if (f_FindIndex = -1) then
    begin
        new(f_newValue);
        f_newValue^ := p_Value;
        m_SequenceO.Add(f_newValue);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQSetting.AddS(p_Value: Integer);
var
    f_FindIndex:Integer;
    f_newValue : ^Integer;
begin
    f_FindIndex := FindS(p_Value);
    if (f_FindIndex = -1) then
    begin
        new(f_newValue);
        f_newValue^ := p_Value;
        m_SequenceS.Add(f_newValue);
    end;
end;

//---------------------------------------------------------------------------

function CFNQSetting.DeleteI(p_Value: Integer): Integer;
var
    f_FindIndex : Integer;
begin
    f_FindIndex := FindI(p_Value);
    if (f_FindIndex <> -1) then
    begin
        Dispose(m_SequenceI.Items[f_FindIndex]);
        m_SequenceI.Delete(f_FindIndex);
    //    m_SequenceI.splice(f_FindIndex, 1);
    end;

    Result := f_FindIndex;
end;

//---------------------------------------------------------------------------
function CFNQSetting.DeleteO(p_Value: Integer) : Integer;
var
    f_FindIndex : Integer;
begin
    f_FindIndex := FindO(p_Value);
    if (f_FindIndex <> -1) then
    begin
        Dispose(m_SequenceO.Items[f_FindIndex]);
        m_SequenceO.Delete(f_FindIndex);
    end;

    Result := f_FindIndex;
end;

//---------------------------------------------------------------------------
function CFNQSetting.DeleteS(p_Value: Integer): Integer;
var
    f_FindIndex : Integer;
begin
    f_FindIndex := FindS(p_Value);
    if (f_FindIndex <> -1) then
    begin
        Dispose(m_SequenceS.Items[f_FindIndex]);
        m_SequenceS.Delete(f_FindIndex);
    end;

    Result := f_FindIndex;
end;

//---------------------------------------------------------------------------
function CFNQSetting.FindI(p_Value: Integer) : Integer;
var
    f_Index : Integer;
    f_Find  : Integer;
begin
    f_Find := -1;
    for f_Index := 0 to m_SequenceI.Count - 1 do
    begin
        if (PInteger(m_SequenceI.Items[f_Index])^ = p_Value) then
        begin
            f_Find := f_Index;
            break;
        end;
    end;

    Result := f_Find;
end;

//---------------------------------------------------------------------------
function CFNQSetting.FindIdentity(p_Value: String): Integer;
var
    f_Index : Integer;
    f_Find  : Integer;
begin
    if (0 >= Length(p_Value)) then
    begin
        Result := -1;
        exit;
    end;

    f_Find := -1;
    for f_Index := 0 to m_Indicator.Count - 1 do
    begin
        if (CFNQIndicatorValue(m_Indicator[f_Index]).m_Name = p_Value) then
        begin
            f_Find := f_Index;
            break;
        end;
    end;

    Result := f_Find;
end;

//---------------------------------------------------------------------------
function CFNQSetting.FindO(p_Value: Integer) : Integer;
var
    f_Index : Integer;
    f_Find  : Integer;
begin
    f_Find := -1;
    for f_Index := 0 to m_SequenceO.Count - 1 do
    begin
        if (PInteger(m_SequenceO.Items[f_Index])^ = p_Value) then
        begin
            f_Find := f_Index;
            break;
        end;
    end;

    Result := f_Find;
end;

//---------------------------------------------------------------------------
function CFNQSetting.FindS(p_Value: Integer) : Integer;
var
    f_Index : Integer;
    f_Find  : Integer;
begin
    f_Find := -1;
    for f_Index := 0 to m_SequenceS.Count - 1 do
    begin
        if (PInteger(m_SequenceS.Items[f_Index])^ = p_Value) then
        begin
            f_Find := f_Index;
            break;
        end;
    end;

    Result := f_Find;
end;

//---------------------------------------------------------------------------
function CFNQSetting.GetFirstValueI: Integer;
var
    f_Index : Integer;
    f_First : Integer;
begin
    f_First := -1;
    for f_Index := 0 to m_SequenceI.Count - 1 do
    begin
        f_First := PInteger(m_SequenceI.Items[f_Index])^;
        break;
    end;

    Result := f_First;
end;

//---------------------------------------------------------------------------
function CFNQSetting.GetFirstValueO: Integer;
var
    f_Index : Integer;
    f_First : Integer;
begin
    f_First := -1;
    for f_Index := 0 to m_SequenceO.Count - 1 do
    begin
        f_First := PInteger(m_SequenceO.Items[f_Index])^;
        break;
    end;

    Result := f_First;
end;

//---------------------------------------------------------------------------
function CFNQSetting.GetFirstValueS: Integer;
var
    f_Index : Integer;
    f_First : Integer;
begin
    f_First := -1;
    for f_Index := 0 to m_SequenceS.Count - 1 do
    begin
        f_First := PInteger(m_SequenceS.Items[f_Index])^;
        break;
    end;

    Result := f_First;
end;

//---------------------------------------------------------------------------
function CFNQSetting.GetIndCountI: Integer;
begin
    Result := m_SequenceI.Count;
end;

//---------------------------------------------------------------------------
function CFNQSetting.GetIndCountO: Integer;
begin
    Result := m_SequenceO.Count;
end;

//---------------------------------------------------------------------------
function CFNQSetting.GetIndCountS: Integer;
begin
    Result := m_SequenceS.Count;
end;


//---------------------------------------------------------------------------
procedure CFNQSetting.SetRegistry(f_Registry:CFNRegistry);
begin
    m_Registry := f_Registry;
end;

//---------------------------------------------------------------------------
procedure CFNQSetting.SetRegSection(f_Section:String);
begin
    m_RegSection := f_Section;
end;

//---------------------------------------------------------------------------
procedure CFNQSetting.SaveSetting();
var
    f_Sequence : String;
    f_Index : Integer;
    f_OptionString : String;
    f_Option : Integer;
begin
    if Assigned(m_Registry) then
    begin
        try
            m_Registry.WriteString(m_RegSection, 'Symbol', m_Symbol);
            m_Registry.WriteString(m_RegSection, 'Name', m_Name);
            m_Registry.WriteInteger(m_RegSection, 'TimeFrame', m_TimeFrame);
            m_Registry.WriteInteger(m_RegSection, 'TimeFrameIndex', m_TimeFrameIndex);

            m_Registry.WriteInteger(m_RegSection, 'ChartType', m_ChartType);
            m_Registry.WriteInteger(m_RegSection, 'Scale', m_Scale);
            m_Registry.WriteInteger(m_RegSection, 'ColorSetIndex', m_ColorSetIndex);
            m_Registry.WriteBool(m_RegSection, 'TraceVisible', m_TraceVisible);
            m_Registry.WriteBool(m_RegSection, 'ConfigVisible', m_ConfigVisible);
            m_Registry.WriteBool(m_RegSection, 'BuySellReport', m_BuySellReport);
            m_Registry.WriteBool(m_RegSection, 'UseOPSPrice', m_UseOPSPrice);
            m_Registry.WriteInteger(m_RegSection, 'RequestCount', m_RequestCount);



            m_Registry.WriteString(m_RegSection, 'SelectedIndexO', IntToStr(m_SelectedIndexO));
            m_Registry.WriteString(m_RegSection, 'SelectedIndexI', IntToStr(m_SelectedIndexI));
            m_Registry.WriteString(m_RegSection, 'SelectedIndexS', IntToStr(m_SelectedIndexS));

            ///////////////////////////////////////////////////////////////
            f_Sequence := '';
            for f_Index := 0 to m_SequenceO.Count - 1 do
            begin
                f_Sequence := f_Sequence + IntToStr(PInteger(m_SequenceO.Items[f_Index])^);
                if (f_Index < m_SequenceO.Count - 1) then
                    f_Sequence := f_Sequence + '|';
            end;
            m_Registry.WriteString(m_RegSection, 'SequenceO', f_Sequence);

            f_Sequence := '';
            for f_Index := 0 to m_SequenceI.Count - 1 do
            begin
                f_Sequence := f_Sequence + IntToStr(PInteger(m_SequenceI.Items[f_Index])^);
                if (f_Index < m_SequenceI.Count - 1) then
                    f_Sequence := f_Sequence + '|';
            end;
            m_Registry.WriteString(m_RegSection, 'SequenceI', f_Sequence);


            f_Sequence := '';
            for f_Index := 0 to m_SequenceS.Count - 1 do
            begin
                f_Sequence := f_Sequence + IntToStr(PInteger(m_SequenceS.Items[f_Index])^);
                if (f_Index < m_SequenceS.Count - 1) then
                    f_Sequence := f_Sequence + '|';
            end;
            m_Registry.WriteString(m_RegSection, 'SequenceS', f_Sequence);
            ///////////////////////////////////////////////////////////////

            f_OptionString := '';
            for f_Index := 0 to m_Indicator.Count - 1 do
            begin
                f_Sequence := '';
                for f_Option := 0 to CFNQIndicatorValue(m_Indicator.Items[f_Index]).m_OptionCount - 1 do
                begin
                    f_Sequence := f_Sequence + FloatToStr(CFNQIndicatorValue(m_Indicator.Items[f_Index]).m_OptionValue[f_Option]);
                    if (f_Option < CFNQIndicatorValue(m_Indicator.Items[f_Index]).m_OptionCount - 1) then
                        f_Sequence := f_Sequence + ',';
                end;
                if f_Sequence = '' then f_Sequence := ' ';


                f_OptionString := f_OptionString + f_Sequence;
                if (f_Index < m_Indicator.Count - 1) then
                    f_OptionString := f_OptionString + '|';
            end;
            m_Registry.WriteString(m_RegSection, 'Option', f_OptionString);
            ///////////////////////////////////////////////////////////////
        except
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQSetting.ReadSetting();
var
    f_Buffer : String;
    f_StringList : TStringList;
    f_Index : Integer;
    nDeleteIdentity : Integer;
    f_Identity : Integer;
    f_Option : Integer;
    f_OptionsList : TStringList;
begin
    if Assigned(m_Registry) then
    begin
        try
            m_Symbol            := m_Registry.ReadString(m_RegSection,'Symbol', '');
            m_Name                := m_Registry.ReadString(m_RegSection, 'Name', '');
            m_TimeFrame            := m_Registry.ReadInteger(m_RegSection,'TimeFrame', 360);
            m_TimeFrameIndex    := m_Registry.ReadInteger(m_RegSection,'TimeFrameIndex', 4);
            if m_TimeFrameIndex < 0 then m_TimeFrameIndex := 0;
            if m_TimeFrameIndex >= MAXTIMEFRAMECOUNT then m_TimeFrameIndex := 0;

            m_ChartType         := m_Registry.ReadInteger(m_RegSection,'ChartType', 0);
            m_Scale             := m_Registry.ReadInteger(m_RegSection,'Scale', 0);
            m_ColorSetIndex     := m_Registry.ReadInteger(m_RegSection, 'ColorSetIndex', 1);
            m_TraceVisible         := m_Registry.ReadBool(m_RegSection, 'TraceVisible', true);
            m_ConfigVisible     := m_Registry.ReadBool(m_RegSection, 'ConfigVisible', true);
            m_UseOPSPrice       := m_Registry.ReadBool(m_RegSection, 'UseOPSPrice', false);
            m_RequestCount         := m_Registry.ReadInteger(m_RegSection, 'RequestCount', 1);

            m_BuySellReport     := m_Registry.ReadBool(m_RegSection, 'BuySellReport', false);


            f_StringList := TStringList.Create();

            //===========================================================================================
            //SequenceO
            f_Buffer := m_Registry.ReadString(m_RegSection, 'SequenceO', '');
            if (0 < Length(f_Buffer)) then
            begin
                f_StringList.Clear();
                ExtractStrings(['|'], [], PChar(f_Buffer), f_StringList);
                for f_Index := 0 to f_StringList.Count - 1 do
                begin
                    if (0 < Length(f_StringList[f_Index])) then
                    begin
                        AddO(TFNGlobal.atoi(f_StringList[f_Index]));
                    end;
                end;
                m_SelectedIndexO := TFNGlobal.atoi(m_Registry.ReadString(m_RegSection, 'SelectedIndexO', '0'));

                if ((m_SelectedIndexO >= 0) and (m_SelectedIndexO < m_SequenceO.Count)) then
                begin
                    m_SelectedIdentityO := PInteger(m_SequenceO.Items[m_SelectedIndexO])^;
                end
                else if (m_SequenceO.Count > 0) then
                begin
                    m_SelectedIndexO := m_SequenceO.Count - 1;
                    m_SelectedIdentityO := PInteger(m_SequenceO.Items[m_SelectedIndexO])^;
                end
                else
                begin
                    m_SelectedIndexO := -1;
                    m_SelectedIdentityO := -1;
                end;
            end
            else
            begin
                 m_SelectedIndexO := -1;
                m_SelectedIdentityO := -1;
            end;
            //AddO(IND_MA);
            if (GetIndCountO() >= (CFNQConst.MAX_OVERLAY_COUNT)) then
            begin
                nDeleteIdentity := GetFirstValueO();
                DeleteO(nDeleteIdentity);
            end;

            //SequenceI
            f_Buffer := m_Registry.ReadString(m_RegSection, 'SequenceI', '');
            if (0 < Length(f_Buffer)) then
            begin
                f_StringList.Clear();
                ExtractStrings(['|'], [], PChar(f_Buffer), f_StringList);
                for f_Index := 0 to f_StringList.Count - 1 do
                begin
                    if (0 < Length(f_StringList[f_Index])) then
                    begin
                        AddI(TFNGlobal.atoi(f_StringList[f_Index]));
                    end;
                end;
                m_SelectedIndexI := TFNGlobal.atoi(m_Registry.ReadString(m_RegSection, 'SelectedIndexI', '0'));

                if ((m_SelectedIndexI >= 0) and (m_SelectedIndexI < m_SequenceI.Count)) then
                begin
                    m_SelectedIdentityI := PInteger(m_SequenceI.Items[m_SelectedIndexI])^
                end
                else if (m_SequenceI.Count > 0) then
                begin
                    m_SelectedIndexI := m_SequenceI.Count - 1;
                    m_SelectedIdentityI := PInteger(m_SequenceI.Items[m_SelectedIndexI])^;
                end
                else
                begin
                    m_SelectedIndexI := -1;
                    m_SelectedIdentityI := -1;
                end;
            end
            else
            begin
                m_SelectedIndexI := -1;
                m_SelectedIdentityI := -1;
            end;

            if (GetIndCountI() >= (CFNQConst.MAX_INDICATOR_COUNT)) then
            begin
                nDeleteIdentity := GetFirstValueI();
                DeleteI(nDeleteIdentity);
            end;

            f_Buffer := m_Registry.ReadString(m_RegSection, 'SequenceS', '');
            if (0 < Length(f_Buffer)) then
            begin
                f_StringList.Clear();
                ExtractStrings(['|'], [], PChar(f_Buffer), f_StringList);
                for f_Index := 0 to f_StringList.Count - 1 do
                begin
                    if (0 < Length(f_StringList[f_Index])) then
                    begin
                        AddS(TFNGlobal.atoi(f_StringList[f_Index]));
                    end;
                end;
                m_SelectedIndexS := TFNGlobal.atoi(m_Registry.ReadString(m_RegSection, 'SelectedIndexS', '0'));

                if ((m_SelectedIndexS >= 0) and (m_SelectedIndexS < m_SequenceS.Count)) then
                begin
                    m_SelectedIdentityS := PInteger(m_SequenceS.Items[m_SelectedIndexS])^
                end
                else if (m_SequenceS.Count > 0) then
                begin
                    m_SelectedIndexS := m_SequenceS.Count - 1;
                    m_SelectedIdentityS := PInteger(m_SequenceS.Items[m_SelectedIndexS])^;
                end
                else
                begin
                    m_SelectedIndexS := -1;
                    m_SelectedIdentityS := -1;
                end;
            end
            else
            begin
                m_SelectedIndexS := -1;
                m_SelectedIdentityS := -1;
            end;

            if (GetIndCountS() >= (CFNQConst.MAX_SIGNAL_COUNT)) then
            begin
                nDeleteIdentity := GetFirstValueS();
                DeleteS(nDeleteIdentity);
            end;



            for f_Index := 0 to m_SequenceO.Count - 1 do
            begin
                f_Identity := PInteger(m_SequenceO.Items[f_Index])^;
                CFNQIndicatorValue(m_Indicator.Items[f_Identity]).m_ViewIndicator := true;
            end;

            for f_Index := 0 to m_SequenceI.Count - 1 do
            begin
                f_Identity := PInteger(m_SequenceI.Items[f_Index])^;
                CFNQIndicatorValue(m_Indicator.Items[f_Identity]).m_ViewIndicator := true;
            end;

            for f_Index := 0 to m_SequenceS.Count - 1 do
            begin
                f_Identity := PInteger(m_SequenceS.Items[f_Index])^;
                CFNQIndicatorValue(m_Indicator.Items[f_Identity]).m_ViewIndicator := true;
            end;

            //===========================================================================================

            //Options
            f_OptionsList := TStringList.Create();
            f_Buffer := m_Registry.ReadString(m_RegSection, 'Option', '');
            if (0 < Length(f_Buffer)) then
            begin
                f_StringList.Clear();
                ExtractStrings(['|'], [], PChar(f_Buffer), f_StringList);
                for f_Index := 0 to f_StringList.Count - 1 do
                begin
                    if (f_Index >= m_Indicator.Count) then
                        continue;

                    if (0 < Length(Trim(f_StringList[f_Index]))) then
                    begin
                        f_OptionsList.Clear();
                        ExtractStrings([','], [], PChar(f_StringList[f_Index]), f_OptionsList);
                        for f_Option := 0 to f_OptionsList.Count - 1 do
                        begin
                            if (0 < Length(f_OptionsList[f_Option])) then
                                CFNQIndicatorValue(m_Indicator.Items[f_Index]).m_OptionValue[f_Option] := StrToFloat(f_OptionsList[f_Option])
                            else
                                CFNQIndicatorValue(m_Indicator.Items[f_Index]).m_OptionValue[f_Option] := CFNQIndicatorValue(m_Indicator.Items[f_Index]).m_OptionDefaultValue[f_Option];
                        end;
                    end;
                end;
            end;
            f_OptionsList.Free();
            f_StringList.Free();
        except
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQSetting.ClearSequenceO();
begin
    while (0 < m_SequenceO.Count) do
    begin
        Dispose(m_SequenceO.Items[0]);
        m_SequenceO.Delete(0);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQSetting.ClearSequenceI();
begin
    while (0 < m_SequenceI.Count) do
    begin
        Dispose(m_SequenceI.Items[0]);
        m_SequenceI.Delete(0);
    end;
end;
//---------------------------------------------------------------------------
procedure CFNQSetting.ClearSequenceS();
begin
    while (0 < m_SequenceS.Count) do
    begin
        Dispose(m_SequenceS.Items[0]);
        m_SequenceS.Delete(0);
    end;
end;
//---------------------------------------------------------------------------
procedure CFNQSetting.DeleteAll;
var
    f_Index : Integer;
begin
    ClearSequenceO();
    ClearSequenceI();
    ClearSequenceS();
    for f_Index := 0 to m_Indicator.Count - 1 do
    begin
        CFNQIndicatorValue(m_Indicator.Items[f_Index]).m_ViewIndicator := false;
    end;
end;

Initialization
begin
    g_TimeFrame[ 0] := 9001;
    g_TimeFrame[ 1] := 9010;
    g_TimeFrame[ 2] := 9020;
    g_TimeFrame[ 3] := 9030;
    g_TimeFrame[ 4] :=    1;
    g_TimeFrame[ 5] :=    2;
    g_TimeFrame[ 6] :=    3;
    g_TimeFrame[ 7] :=    5;
    g_TimeFrame[ 8] :=   10;
    g_TimeFrame[ 9] :=   15;
    g_TimeFrame[10] :=   20;
    g_TimeFrame[11] :=   30;
    g_TimeFrame[12] :=   60;
    g_TimeFrame[13] :=  360;

end;
end.
