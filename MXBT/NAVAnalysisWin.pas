unit NAVAnalysisWin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ActnList,  StdCtrls, ComCtrls,
  ExtCtrls, FNMatrixOptionFrame, ToolWin, FNMatrixBlock, FNOPSSymbolArray, FNTradeSystem, FNTrafficManager,
  FNMatrixSystem, FNMatrixSystemManager, FNMatrixOrderManager, Buttons,
  FNNAVAnalChartData, FNNAVAnalChartDataSeries, FNNAVAnalLineValue, FNNAVAnalLineValueSeries, FNNAVAnalConst,
  GR32_Image, FNNAVAnalChartControlBase, FNNAVAnalChartControl, FNNAVAnalLineValueSeriesCreator,
  DB, DBTables, ADODB;

type
    CFNNAVAnalPMData = class(TObject)
    public
        m_NetProfit                 :   Double;     // 순이익
        m_GrossProfit               :   Double;     // 총이익
        m_GrossLoss                 :   Double;     // 총손실
        m_NumberOfTrades            :   Integer;    // 전체거래수
        m_AvgDayOfTrades            :   Double;    // 일일평균거래수

        m_DayOfTrades               :   Integer;    // 전체거래일수
        m_DayOfTradable             :   Integer;    // 매매허용일수
        m_DayOfWinningTrades        :   Integer;    // 이익거래일수
        m_DayOfLosingTrades         :   Integer;    // 손실거래일수
        m_PercentProfitable         :   Double;     // 이익거래일수/전체거래일수

        m_LargestWinningTrade       :   Double;     // 최대 이익거래 금액
        m_LargestLosingTrade        :   Double;     // 최대 손실거래 금액

        m_AverageWinningTrade       :   Double;     // 평균 이익거래 금액
        m_AverageLosingTrade        :   Double;     // 평균 손실거래 금액

        m_RatioAvgWinAvgLoss        :   Double;     // 평균 이익거래 금액/평균 손실거래 금액
        m_AvgTrade                  :   Double;     // 순이익/전체거래일수
        m_MaxConsecWinners          :   Integer;    // 최대연속이익거래일수
        m_MaxConsecLosers           :   Integer;    // 최대연속손실거래일수

        m_AvgBarsWinners            :   Integer;    // 이익거래의 평균 일수
        m_AvgBarsLosers             :   Integer;    // 손실거래의 평균 일수
        m_MaxDrawdown               :   Double;     // 순이익의 최대삭감금액

        m_ProfitFactor              :   Double;     // 총이익/총손실

        m_SuccessRate               :   Double;     // 성공율

        constructor Create;
        procedure DefaultValue;
        procedure Clone(p_Source:CFNNAVAnalPMData);
    end;

    CFNNAVAnalOption = class(TObject)
    public
        m_UseMA1     :  Boolean                 ;
        m_MA1Value1  :  Double                  ;
        m_MA1Value2  :  Double                  ;
        m_MA1Value3  :  Double                  ;
        m_MA1Value4  :  Double                  ;

        m_UseMA2     :  Boolean                 ;
        m_MA2Value1  :  Double                  ;
        m_MA2Value2  :  Double                  ;
        m_MA2Value3  :  Double                  ;
        m_MA2Value4  :  Double                  ;

        m_StandDate  :  TDateTime               ;

        constructor Create;
        procedure DefaultValue;
        procedure Clone(p_Source:CFNNAVAnalOption);
    end;

  TMDINAVAnalisys = class(TForm)
    OpenDialog: TOpenDialog;
    ImageList1: TImageList;
    ActionList1: TActionList;
    Action_Load: TAction;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel3: TPanel;
    Panel4: TPanel;
    ListViewDailyPM: TListView;
    Panel1: TPanel;
    Panel2: TPanel;
    CFNNAVAnalChartControl1: CFNNAVAnalChartControl;
    Splitter1: TSplitter;
    Panel5: TPanel;
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditMA1Value1: TEdit;
    UpDownMA1Value1: TUpDown;
    UpDownMA1Value2: TUpDown;
    EditMA1Value2: TEdit;
    EditMA1Value3: TEdit;
    UpDownMA1Value3: TUpDown;
    Label4: TLabel;
    EditMA1Value4: TEdit;
    Button2: TButton;
    CheckBoxUseMA1: TCheckBox;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EditMA2Value1: TEdit;
    UpDownMA2Value1: TUpDown;
    UpDownMA2Value2: TUpDown;
    EditMA2Value2: TEdit;
    EditMA2Value3: TEdit;
    UpDownMA2Value3: TUpDown;
    CheckBoxUseMA2: TCheckBox;
    Label8: TLabel;
    EditMA2Value4: TEdit;
    TabSheet3: TTabSheet;
    Panel8: TPanel;
    ListViewPM: TListView;
    DateTimePicker1: TDateTimePicker;
    Query1: TQuery;
    Database1: TDatabase;
    ADOQuery1: TADOQuery;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListViewDailyPMData(Sender: TObject; Item: TListItem);
    procedure ListViewDailyPMCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewDailyPMCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure Action_LoadExecute(Sender: TObject);
    procedure CFNNAVAnalChartControl1ChartTraceChange(p_Index: Integer; p_ValueX, p_ValueY: Double);
    procedure Button1Click(Sender: TObject);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure OnChange(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure ListViewPMData(Sender: TObject; Item: TListItem);
    procedure ListViewPMCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewPMCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);

  protected
    m_DailyPMValueCollection:CFNDailyPMValueCollection;
    m_ChartDataSeries:CFNNAVAnalChartDataSeries;
    m_NAVSeries:CFNNAVAnalLineValueSeries;

  protected
    procedure ClearDailyPMListView;
    procedure DisplayDailyPMListView;
    procedure AnalisysNAV;
    procedure AnalisysPM;
    procedure ApplyChart;

  protected
    m_Option : CFNNAVAnalOption;
    m_EnableEvent : Boolean;
    m_PMData : Array [0..5] of CFNNAVAnalPMData;
    m_PMValueCollection : Array [0..5] of CFNPMValueCollection;

    procedure GetOption;
    procedure SetOption;

  public
    constructor Create(AOwner:TComponent);
    destructor Destroy; override;
    procedure WritePrformance(APMData:CFNNAVAnalPMData; AValueArray: CFNPMValueCollection);

  end;

var
    MDINAVAnalisys: TMDINAVAnalisys;

implementation

{$R *.dfm}

uses
    FNRegistry, FNGlobal, DateUtils, FNCommonVariable, FNSymbolData, Math,
    FNMatrixChartDataSeries, FNMatrixChartData, FNMatrixLineValue, FNPOTData, ShellAPI;

//------------------------------------------------------------------------------------
constructor TMDINAVAnalisys.Create(AOwner:TComponent);
var
    f_Index:Integer;
begin
    inherited Create(AOwner);
    m_DailyPMValueCollection := CFNDailyPMValueCollection.Create;
    m_ChartDataSeries := CFNNAVAnalChartDataSeries.Create;
    m_NAVSeries := Creator_NAV;
    m_Option := CFNNAVAnalOption.Create;
    m_EnableEvent := false;

    for f_Index := 0 to 5 do
    begin
        m_PMData[f_Index] := CFNNAVAnalPMData.Create;
        m_PMValueCollection[f_Index] := CFNPMValueCollection.Create;
    end;
end;

//------------------------------------------------------------------------------------
destructor TMDINAVAnalisys.Destroy;
var
    f_Index:Integer;
begin
    m_DailyPMValueCollection.Free;
    m_ChartDataSeries.Free;
    m_NAVSeries.Free;
    m_Option.Free;

    for f_Index := 0 to 5 do
    begin
        m_PMData[f_Index].Free;
        m_PMValueCollection[f_Index].Free;
    end;

    inherited;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.FormCreate(Sender: TObject);
begin
    m_EnableEvent := false;
    SetOption;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.GetOption;
begin
    m_Option.m_UseMA1     := CheckBoxUseMA1.Checked;
    m_Option.m_MA1Value1  := UpDownMA1Value1.Position;
    m_Option.m_MA1Value2  := UpDownMA1Value2.Position;
    m_Option.m_MA1Value3  := UpDownMA1Value3.Position;
    m_Option.m_MA1Value4  := atof(EditMA1Value4.Text);

    m_Option.m_UseMA2     := CheckBoxUseMA2.Checked;
    m_Option.m_MA2Value1  := UpDownMA2Value1.Position;
    m_Option.m_MA2Value2  := UpDownMA2Value2.Position;
    m_Option.m_MA2Value3  := UpDownMA2Value3.Position;
    m_Option.m_MA2Value4  := atof(EditMA2Value4.Text);

    m_Option.m_StandDate  := DateTimePicker1.DateTime;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.SetOption;
begin
    m_EnableEvent := false;

    CheckBoxUseMA1.Checked   :=  m_Option.m_UseMA1;
    UpDownMA1Value1.Position := Trunc(m_Option.m_MA1Value1);
    UpDownMA1Value2.Position := Trunc(m_Option.m_MA1Value2);
    UpDownMA1Value3.Position := Trunc(m_Option.m_MA1Value3);
    EditMA1Value4.Text       := FloatToStr(m_Option.m_MA1Value4);

    CheckBoxUseMA2.Checked   :=  m_Option.m_UseMA2;
    UpDownMA2Value1.Position := Trunc(m_Option.m_MA2Value1);
    UpDownMA2Value2.Position := Trunc(m_Option.m_MA2Value2);
    UpDownMA2Value3.Position := Trunc(m_Option.m_MA2Value3);
    EditMA2Value4.Text       := FloatToStr(m_Option.m_MA2Value4);

    DateTimePicker1.DateTime := m_Option.m_StandDate;

    m_EnableEvent := true;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
    if not m_EnableEvent then exit;

    GetOption;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.Action_LoadExecute(Sender: TObject);
var
    F: TextFile;
    S: string;
    f_FileName: string;
    f_RecordList:TStringList;
    f_FieldList:TStringList;
    f_RecordIndex:Integer;

    f_DailyPMValueItem:CFNDailyPMValueItem;
    f_PMItem:CFNDailyPMValueItem;
    f_SumPMItem:CFNDailyPMValueItem;
    f_AvgPMItem:CFNDailyPMValueItem;

    f_Index:Integer;

    f_TProfitSum : Double;
    f_BProfitSum : Double;
    f_SProfitSum : Double;

    Year   :Word;
    Month  :Word;
    Day    :Word;
    f_ChartData:CFNNAVAnalChartData;
begin
    OpenDialog.FileName := '*.csv';
    if OpenDialog.Execute then
    begin
        m_DailyPMValueCollection.Clear;
        m_ChartDataSeries.Clear;
        f_FileName := OpenDialog.FileName;

        f_RecordList := TStringList.Create;
        f_FieldList := TStringList.Create;

        try
            f_RecordList.Clear;
            if FileExists(f_FileName) then
            begin
                AssignFile(F, f_FileName);
                Reset(F);
                while not eof(F) do
                begin
                    Readln(F, S);
                    f_RecordList.Add(S);
                end;
                CloseFile(F);
            end;

            for f_RecordIndex := 1 to f_RecordList.Count - 1 do
            begin
                f_FieldList.Clear;
                ExtractStrings([','], [], PChar(f_RecordList[f_RecordIndex]), f_FieldList);

                if f_FieldList.Count < 5 then continue;

                f_DailyPMValueItem := CFNDailyPMValueItem.Create;

                Year    := atoi(Copy(f_FieldList[0], 1, 4));
                Month   := atoi(Copy(f_FieldList[0], 6, 2));
                Day     := atoi(Copy(f_FieldList[0], 9, 2));

                f_DailyPMValueItem.m_Date := EncodeDateTime(Year, Month, Day, 0, 0, 0, 0);
                f_DailyPMValueItem.m_TProfit := atof(f_FieldList[1]);
                f_DailyPMValueItem.m_TProfitSum := atof(f_FieldList[2]);

                f_DailyPMValueItem.m_BProfit := atof(f_FieldList[3]);
                f_DailyPMValueItem.m_BProfitSum := atof(f_FieldList[4]);

                f_DailyPMValueItem.m_SProfit := atof(f_FieldList[5]);
                f_DailyPMValueItem.m_SProfitSum := atof(f_FieldList[6]);

                f_DailyPMValueItem.m_TNumberOfTrades := atof(f_FieldList[7]);
                f_DailyPMValueItem.m_BNumberOfTrades := atof(f_FieldList[8]);
                f_DailyPMValueItem.m_SNumberOfTrades := atof(f_FieldList[9]);

                f_DailyPMValueItem.m_Price := atof(f_FieldList[10]);

                m_DailyPMValueCollection.Add(f_DailyPMValueItem);

                f_ChartData := CFNNAVAnalChartData.Create;

                f_ChartData.m_Date := f_DailyPMValueItem.m_Date;

                f_ChartData.m_Year := Year;
                f_ChartData.m_Month := Month;
                f_ChartData.m_Day := Day;

                f_ChartData.m_TProfit := f_DailyPMValueItem.m_TProfit;
                f_ChartData.m_TProfitSum := f_DailyPMValueItem.m_TProfitSum;

                f_ChartData.m_BProfit := f_DailyPMValueItem.m_BProfit;
                f_ChartData.m_BProfitSum := f_DailyPMValueItem.m_BProfitSum;

                f_ChartData.m_SProfit := f_DailyPMValueItem.m_SProfit;
                f_ChartData.m_SProfitSum := f_DailyPMValueItem.m_SProfitSum;

                f_ChartData.m_TNumberOfTrades := f_DailyPMValueItem.m_TNumberOfTrades;
                f_ChartData.m_BNumberOfTrades := f_DailyPMValueItem.m_BNumberOfTrades;
                f_ChartData.m_SNumberOfTrades := f_DailyPMValueItem.m_SNumberOfTrades;

                f_ChartData.m_Price := f_DailyPMValueItem.m_Price;

                m_ChartDataSeries.Add(f_ChartData);
            end;

            f_TProfitSum := 0;
            f_BProfitSum := 0;
            f_SProfitSum := 0;

            f_SumPMItem := CFNDailyPMValueItem.Create;
            f_SumPMItem.m_Date := 1;

            f_SumPMItem.m_TProfit := 0;
            f_SumPMItem.m_TNumberOfTrades := 0;

            f_SumPMItem.m_BProfit := 0;
            f_SumPMItem.m_BNumberOfTrades := 0;

            f_SumPMItem.m_SProfit := 0;
            f_SumPMItem.m_SNumberOfTrades := 0;

            f_SumPMItem.m_Price := 0;

            for f_Index := 0 to m_DailyPMValueCollection.m_Items.Count - 1 do
            begin
                f_PMItem := m_DailyPMValueCollection.m_Items[f_Index];

                f_SumPMItem.m_TProfit := f_SumPMItem.m_TProfit + f_PMItem.m_TProfit;
                f_SumPMItem.m_BProfit := f_SumPMItem.m_BProfit + f_PMItem.m_BProfit;
                f_SumPMItem.m_SProfit := f_SumPMItem.m_SProfit + f_PMItem.m_SProfit;

                f_SumPMItem.m_TProfitSum := 0;
                f_SumPMItem.m_BProfitSum := 0;
                f_SumPMItem.m_SProfitSum := 0;

                f_SumPMItem.m_TNumberOfTrades := f_SumPMItem.m_TNumberOfTrades + f_PMItem.m_TNumberOfTrades;
                f_SumPMItem.m_BNumberOfTrades := f_SumPMItem.m_BNumberOfTrades + f_PMItem.m_BNumberOfTrades;
                f_SumPMItem.m_SNumberOfTrades := f_SumPMItem.m_SNumberOfTrades + f_PMItem.m_SNumberOfTrades;

                f_TProfitSum := f_TProfitSum + f_PMItem.m_TProfit;
                f_BProfitSum := f_BProfitSum + f_PMItem.m_BProfit;
                f_SProfitSum := f_SProfitSum + f_PMItem.m_SProfit;

                f_PMItem.m_TProfitSum := f_TProfitSum;
                f_PMItem.m_BProfitSum := f_BProfitSum;
                f_PMItem.m_SProfitSum := f_SProfitSum;
            end;

            f_AvgPMItem := CFNDailyPMValueItem.Create;
            f_AvgPMItem.m_Date := 2;

            if m_DailyPMValueCollection.m_Items.Count > 0 then
            begin
                f_AvgPMItem.m_TProfit := f_SumPMItem.m_TProfit / m_DailyPMValueCollection.m_Items.Count;
                f_AvgPMItem.m_BProfit := f_SumPMItem.m_BProfit / m_DailyPMValueCollection.m_Items.Count;
                f_AvgPMItem.m_SProfit := f_SumPMItem.m_SProfit / m_DailyPMValueCollection.m_Items.Count;

                f_AvgPMItem.m_TProfitSum := 0;
                f_AvgPMItem.m_BProfitSum := 0;
                f_AvgPMItem.m_SProfitSum := 0;

                f_AvgPMItem.m_TNumberOfTrades := f_SumPMItem.m_TNumberOfTrades / m_DailyPMValueCollection.m_Items.Count;
                f_AvgPMItem.m_BNumberOfTrades := f_SumPMItem.m_BNumberOfTrades / m_DailyPMValueCollection.m_Items.Count;
                f_AvgPMItem.m_SNumberOfTrades := f_SumPMItem.m_SNumberOfTrades / m_DailyPMValueCollection.m_Items.Count;

                f_AvgPMItem.m_Price := 0;
            end else
            begin
                f_AvgPMItem.m_TProfit := 0;
                f_AvgPMItem.m_BProfit := 0;
                f_AvgPMItem.m_SProfit := 0;

                f_AvgPMItem.m_TProfitSum := 0;
                f_AvgPMItem.m_BProfitSum := 0;
                f_AvgPMItem.m_SProfitSum := 0;

                f_AvgPMItem.m_TNumberOfTrades := 0;
                f_AvgPMItem.m_BNumberOfTrades := 0;
                f_AvgPMItem.m_SNumberOfTrades := 0;

                f_AvgPMItem.m_Price := 0;
            end;

            m_DailyPMValueCollection.Add(f_SumPMItem);
            m_DailyPMValueCollection.Add(f_AvgPMItem);

            DisplayDailyPMListView;
        finally
            f_RecordList.Free;
            f_FieldList.Free;
        end;

        AnalisysNAV;
        AnalisysPM;
        ApplyChart;

    end;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.AnalisysNAV;
var
    f_ValueIndex:Integer;
    f_Size:Integer;
    f_ChartData:CFNNAVAnalChartData;
    f_LineValue0:CFNNAVAnalLineValue;
    f_LineValue1:CFNNAVAnalLineValue;
    f_LineValue2:CFNNAVAnalLineValue;

    f_Value:Double;

    f_THigh:Double;
    f_BHigh:Double;
    f_SHigh:Double;

    f_LineValueOrigin:CFNNAVAnalLineValue;

    f_TOrigin:Double;
    f_BOrigin:Double;
    f_SOrigin:Double;

    f_TSum:Double;
    f_BSum:Double;
    f_SSum:Double;

    f_OriginIndex:Integer;
begin
    f_Size := m_ChartDataSeries.m_Items.Count;

    f_OriginIndex := m_ChartDataSeries.Search(m_Option.m_StandDate, true);
    if f_OriginIndex <= 0 then f_OriginIndex := Trunc(m_Option.m_MA1Value1);

    m_NAVSeries.Clear;
    m_NAVSeries.SetLengthSeries(f_Size);
    f_TSum := 0;
    f_BSum := 0;
    f_SSum := 0;
    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        f_TSum := f_TSum + f_ChartData.m_TProfit;
        f_BSum := f_BSum + f_ChartData.m_BProfit;
        f_SSum := f_SSum + f_ChartData.m_SProfit;

        f_LineValue0.m_Value[NAV_TPROFIT    ] := f_TSum;
        f_LineValue0.m_Value[NAV_BPROFIT    ] := f_BSum;
        f_LineValue0.m_Value[NAV_SPROFIT    ] := f_SSum;

        f_LineValue0.m_Value[NAV_TPROFIT2   ] := 0;

        f_LineValue0.m_Value[NAV_BPROFIT_MA1] := 0;
        f_LineValue0.m_Value[NAV_BPROFIT_MA2] := 0;
        f_LineValue0.m_Value[NAV_BPROFIT_MA3] := 0;
        f_LineValue0.m_Value[NAV_BPROFIT2   ] := 0;

        f_LineValue0.m_Value[NAV_SPROFIT_MA1] := 0;
        f_LineValue0.m_Value[NAV_SPROFIT_MA2] := 0;
        f_LineValue0.m_Value[NAV_SPROFIT_MA3] := 0;
        f_LineValue0.m_Value[NAV_SPROFIT2   ] := 0;
    end;

    if m_Option.m_UseMA1 then
    begin
        m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA1Value1), 6, m_NAVSeries, NAV_BPROFIT    , NAV_BPROFIT_MA1, 0, f_Size);
        m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA1Value2), 6, m_NAVSeries, NAV_BPROFIT_MA1, NAV_BPROFIT_MA2, 0, f_Size);
        m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA1Value3), 6, m_NAVSeries, NAV_BPROFIT_MA2, NAV_BPROFIT_MA3, 0, f_Size);

        m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA1Value1), 6, m_NAVSeries, NAV_SPROFIT    , NAV_SPROFIT_MA1, 0, f_Size);
        m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA1Value2), 6, m_NAVSeries, NAV_SPROFIT_MA1, NAV_SPROFIT_MA2, 0, f_Size);
        m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA1Value3), 6, m_NAVSeries, NAV_SPROFIT_MA2, NAV_SPROFIT_MA3, 0, f_Size);

        for f_ValueIndex := 0 to f_Size - 1 do
        begin
            f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];
            if f_ValueIndex < f_OriginIndex  then
            begin
                f_LineValueOrigin := m_NAVSeries.m_Items[f_ValueIndex];
            end else
            begin
                f_LineValue0.m_Value[NAV_TPROFIT    ] := f_LineValue0.m_Value[NAV_TPROFIT    ] - f_LineValueOrigin.m_Value[NAV_TPROFIT    ];
                f_LineValue0.m_Value[NAV_TPROFIT2   ] := f_LineValue0.m_Value[NAV_TPROFIT2   ] - f_LineValueOrigin.m_Value[NAV_TPROFIT2   ];

                f_LineValue0.m_Value[NAV_BPROFIT    ] := f_LineValue0.m_Value[NAV_BPROFIT    ] - f_LineValueOrigin.m_Value[NAV_BPROFIT    ];
                f_LineValue0.m_Value[NAV_BPROFIT_MA1] := f_LineValue0.m_Value[NAV_BPROFIT_MA1] - f_LineValueOrigin.m_Value[NAV_BPROFIT_MA1];
                f_LineValue0.m_Value[NAV_BPROFIT_MA2] := f_LineValue0.m_Value[NAV_BPROFIT_MA2] - f_LineValueOrigin.m_Value[NAV_BPROFIT_MA2];
                f_LineValue0.m_Value[NAV_BPROFIT_MA3] := f_LineValue0.m_Value[NAV_BPROFIT_MA3] - f_LineValueOrigin.m_Value[NAV_BPROFIT_MA3];
                f_LineValue0.m_Value[NAV_BPROFIT2   ] := f_LineValue0.m_Value[NAV_BPROFIT2   ] - f_LineValueOrigin.m_Value[NAV_BPROFIT2   ];

                f_LineValue0.m_Value[NAV_SPROFIT    ] := f_LineValue0.m_Value[NAV_SPROFIT    ] - f_LineValueOrigin.m_Value[NAV_SPROFIT    ];
                f_LineValue0.m_Value[NAV_SPROFIT_MA1] := f_LineValue0.m_Value[NAV_SPROFIT_MA1] - f_LineValueOrigin.m_Value[NAV_SPROFIT_MA1];
                f_LineValue0.m_Value[NAV_SPROFIT_MA2] := f_LineValue0.m_Value[NAV_SPROFIT_MA2] - f_LineValueOrigin.m_Value[NAV_SPROFIT_MA2];
                f_LineValue0.m_Value[NAV_SPROFIT_MA3] := f_LineValue0.m_Value[NAV_SPROFIT_MA3] - f_LineValueOrigin.m_Value[NAV_SPROFIT_MA3];
                f_LineValue0.m_Value[NAV_SPROFIT2   ] := f_LineValue0.m_Value[NAV_SPROFIT2   ] - f_LineValueOrigin.m_Value[NAV_SPROFIT2   ];
            end;
        end;

        for f_ValueIndex := 0 to f_Size - 1 do
        begin
            f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];
            if f_ValueIndex < f_OriginIndex then
            begin
                f_LineValue0.m_Value[NAV_TPROFIT    ] := 0;
                f_LineValue0.m_Value[NAV_TPROFIT2   ] := 0;

                f_LineValue0.m_Value[NAV_BPROFIT    ] := 0;
                f_LineValue0.m_Value[NAV_BPROFIT_MA1] := 0;
                f_LineValue0.m_Value[NAV_BPROFIT_MA2] := 0;
                f_LineValue0.m_Value[NAV_BPROFIT_MA3] := 0;
                f_LineValue0.m_Value[NAV_BPROFIT2   ] := 0;

                f_LineValue0.m_Value[NAV_SPROFIT    ] := 0;
                f_LineValue0.m_Value[NAV_SPROFIT_MA1] := 0;
                f_LineValue0.m_Value[NAV_SPROFIT_MA2] := 0;
                f_LineValue0.m_Value[NAV_SPROFIT_MA3] := 0;
                f_LineValue0.m_Value[NAV_SPROFIT2   ] := 0;
            end;
        end;

        for f_ValueIndex := 0 to f_Size - 1 do
        begin
            f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

            if f_ValueIndex > 1 then
            begin
                f_LineValue1 := m_NAVSeries.m_Items[f_ValueIndex-1];
                f_LineValue2 := m_NAVSeries.m_Items[f_ValueIndex-2];

                f_Value := (f_LineValue1.m_Value[NAV_BPROFIT_MA3] - f_LineValue2.m_Value[NAV_BPROFIT_MA3]) * 100.0;
                if f_Value >= m_Option.m_MA1Value4 then
                begin
                    f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] := 1;
                end else
                begin
                    f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] := 0;
                end;

                f_Value := (f_LineValue1.m_Value[NAV_SPROFIT_MA3] - f_LineValue2.m_Value[NAV_SPROFIT_MA3]) * 100.0;
                if f_Value >= m_Option.m_MA1Value4 then
                begin
                    f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] := 1;
                end else
                begin
                    f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] := 0;
                end;

            end else
            begin
                f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] := 1;
                f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] := 1;
            end;
        end;

    end else
    begin

        for f_ValueIndex := 0 to f_Size - 1 do
        begin
            f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];
            f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] := 1;
            f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] := 1;
        end;

    end;

    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_ValueIndex >= f_OriginIndex then
        begin
            if f_ValueIndex > 1 then
            begin
                f_LineValue1 := m_NAVSeries.m_Items[f_ValueIndex-1];
                f_LineValue2 := m_NAVSeries.m_Items[f_ValueIndex-2];

                if f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] = 1 then
                begin
                    f_LineValue0.m_Value[NAV_BPROFIT2] := f_LineValue1.m_Value[NAV_BPROFIT2] + f_ChartData.m_BProfit;
                end else
                begin
                    f_LineValue0.m_Value[NAV_BPROFIT2] := f_LineValue1.m_Value[NAV_BPROFIT2];
                end;

                if f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] = 1 then
                begin
                    f_LineValue0.m_Value[NAV_SPROFIT2] := f_LineValue1.m_Value[NAV_SPROFIT2] + f_ChartData.m_SProfit;
                end else
                begin
                    f_LineValue0.m_Value[NAV_SPROFIT2] := f_LineValue1.m_Value[NAV_SPROFIT2];
                end;
            end else
            begin
                f_LineValue0.m_Value[NAV_BPROFIT2] := f_LineValue0.m_Value[NAV_BPROFIT];
                f_LineValue0.m_Value[NAV_SPROFIT2] := f_LineValue0.m_Value[NAV_SPROFIT];
            end;
        end else
        begin
            f_LineValue0.m_Value[NAV_BPROFIT2] := f_LineValue0.m_Value[NAV_BPROFIT];
            f_LineValue0.m_Value[NAV_SPROFIT2] := f_LineValue0.m_Value[NAV_SPROFIT];
        end;

        f_LineValue0.m_Value[NAV_TPROFIT2] := f_LineValue0.m_Value[NAV_BPROFIT2] + f_LineValue0.m_Value[NAV_SPROFIT2];
    end;

    f_THigh := 0;
    f_BHigh := 0;
    f_SHigh := 0;
    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_LineValue0.m_Value[NAV_TPROFIT] > f_THigh then f_THigh := f_LineValue0.m_Value[NAV_TPROFIT];
        if f_LineValue0.m_Value[NAV_BPROFIT] > f_BHigh then f_BHigh := f_LineValue0.m_Value[NAV_BPROFIT];
        if f_LineValue0.m_Value[NAV_SPROFIT] > f_SHigh then f_SHigh := f_LineValue0.m_Value[NAV_SPROFIT];
        f_LineValue0.m_Value[NAV_TDRAWDOWN1] := f_LineValue0.m_Value[NAV_TPROFIT] - f_THigh;
        f_LineValue0.m_Value[NAV_BDRAWDOWN1] := f_LineValue0.m_Value[NAV_BPROFIT] - f_BHigh;
        f_LineValue0.m_Value[NAV_SDRAWDOWN1] := f_LineValue0.m_Value[NAV_SPROFIT] - f_SHigh;
    end;

    f_THigh := 0;
    f_BHigh := 0;
    f_SHigh := 0;
    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_LineValue0.m_Value[NAV_TPROFIT2] > f_THigh then f_THigh := f_LineValue0.m_Value[NAV_TPROFIT2];
        if f_LineValue0.m_Value[NAV_BPROFIT2] > f_BHigh then f_BHigh := f_LineValue0.m_Value[NAV_BPROFIT2];
        if f_LineValue0.m_Value[NAV_SPROFIT2] > f_SHigh then f_SHigh := f_LineValue0.m_Value[NAV_SPROFIT2];
        f_LineValue0.m_Value[NAV_TDRAWDOWN2] := f_LineValue0.m_Value[NAV_TPROFIT2] - f_THigh;
        f_LineValue0.m_Value[NAV_BDRAWDOWN2] := f_LineValue0.m_Value[NAV_BPROFIT2] - f_BHigh;
        f_LineValue0.m_Value[NAV_SDRAWDOWN2] := f_LineValue0.m_Value[NAV_SPROFIT2] - f_SHigh;
    end;

    m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA2Value1), 6, m_NAVSeries, NAV_TDRAWDOWN1   , NAV_TDRAWDOWN1MA1, 0, f_Size);
    m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA2Value2), 6, m_NAVSeries, NAV_TDRAWDOWN1MA1, NAV_TDRAWDOWN1MA2, 0, f_Size);
    m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA2Value3), 6, m_NAVSeries, NAV_TDRAWDOWN1MA2, NAV_TDRAWDOWN1MA3, 0, f_Size);

    m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA2Value1), 6, m_NAVSeries, NAV_BDRAWDOWN1   , NAV_BDRAWDOWN1MA1, 0, f_Size);
    m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA2Value2), 6, m_NAVSeries, NAV_BDRAWDOWN1MA1, NAV_BDRAWDOWN1MA2, 0, f_Size);
    m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA2Value3), 6, m_NAVSeries, NAV_BDRAWDOWN1MA2, NAV_BDRAWDOWN1MA3, 0, f_Size);

    m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA2Value1), 6, m_NAVSeries, NAV_SDRAWDOWN1   , NAV_SDRAWDOWN1MA1, 0, f_Size);
    m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA2Value2), 6, m_NAVSeries, NAV_SDRAWDOWN1MA1, NAV_SDRAWDOWN1MA2, 0, f_Size);
    m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA2Value3), 6, m_NAVSeries, NAV_SDRAWDOWN1MA2, NAV_SDRAWDOWN1MA3, 0, f_Size);
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.AnalisysPM;
var
    f_ValueIndex:Integer;
    f_Size:Integer;

    f_ChartData:CFNNAVAnalChartData;
    f_LineValue0:CFNNAVAnalLineValue;
    f_LineValue1:CFNNAVAnalLineValue;
    f_LineValue2:CFNNAVAnalLineValue;

    f_Value:Double;
    f_Profit:Double;
    f_HighProfit:Double;
    f_SumProfit:Double;
    f_Drawdown:Double;
    f_Tradable:Boolean;
    f_TradeCount:Integer;

    f_THigh:Double;
    f_BHigh:Double;
    f_SHigh:Double;

    f_LineValueOrigin:CFNNAVAnalLineValue;

    f_TOrigin:Double;
    f_BOrigin:Double;
    f_SOrigin:Double;
    f_PMData:CFNNAVAnalPMData;

    f_ConsecWinners:Integer;
    f_ConsecLosers:Integer;
    f_OriginIndex:Integer;
begin
    f_Size := m_ChartDataSeries.m_Items.Count;

    f_OriginIndex := m_ChartDataSeries.Search(m_Option.m_StandDate, true);
    if f_OriginIndex <= 0 then f_OriginIndex := Trunc(m_Option.m_MA1Value1);

    {$REGION '1차 신호의 전체거래'}
    f_PMData := m_PMData[0];
    f_PMData.DefaultValue;
    f_HighProfit := 0;

    f_ConsecWinners:=0;
    f_ConsecLosers:=0;
    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_ValueIndex >= f_OriginIndex then
        begin
            f_Profit := f_ChartData.m_TProfit;
            f_Tradable := true;
            f_TradeCount := Trunc(f_ChartData.m_TNumberOfTrades);
            Inc(f_PMData.m_DayOfTrades);
            if f_Tradable then
            begin
                if f_Profit > 0 then
                begin
                    f_PMData.m_GrossProfit := f_PMData.m_GrossProfit + f_Profit;
                    Inc(f_PMData.m_DayOfWinningTrades);
                    if (f_PMData.m_LargestWinningTrade < f_Profit) then f_PMData.m_LargestWinningTrade := f_Profit;
                    Inc(f_ConsecWinners);
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecLosers := 0;
                end else
                if f_Profit < 0 then
                begin
                    f_PMData.m_GrossLoss := f_PMData.m_GrossLoss + f_Profit;
                    Inc(f_PMData.m_DayOfLosingTrades);
                    if (f_PMData.m_LargestLosingTrade > f_Profit) then f_PMData.m_LargestLosingTrade := f_Profit;
                    Inc(f_ConsecLosers);
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    f_ConsecWinners := 0;
                end else
                begin
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecWinners := 0;
                    f_ConsecLosers := 0;
                end;

                Inc(f_PMData.m_NumberOfTrades, f_TradeCount);
                Inc(f_PMData.m_DayOfTradable);

                f_SumProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;
                if f_HighProfit < f_SumProfit then f_HighProfit := f_SumProfit;
                f_Drawdown := f_SumProfit - f_HighProfit;
                if f_PMData.m_MaxDrawdown > f_Drawdown then f_PMData.m_MaxDrawdown := f_Drawdown;
            end;
        end;
    end;
    f_PMData.m_NetProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgDayOfTrades := f_PMData.m_NumberOfTrades / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgDayOfTrades := 0;
    end;

    if f_PMData.m_DayOfWinningTrades <> 0 then
    begin
        f_PMData.m_AverageWinningTrade := f_PMData.m_GrossProfit / f_PMData.m_DayOfWinningTrades;
    end else
    begin
        f_PMData.m_AverageWinningTrade := 0;
    end;

    if f_PMData.m_DayOfLosingTrades <> 0 then
    begin
        f_PMData.m_AverageLosingTrade := f_PMData.m_GrossLoss / f_PMData.m_DayOfLosingTrades;
    end else
    begin
        f_PMData.m_AverageLosingTrade := 0;
    end;

    if f_PMData.m_AverageLosingTrade <> 0 then
    begin
        f_PMData.m_RatioAvgWinAvgLoss := abs(f_PMData.m_AverageWinningTrade / f_PMData.m_AverageLosingTrade);
    end else
    begin
        f_PMData.m_RatioAvgWinAvgLoss := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_PercentProfitable := (f_PMData.m_DayOfWinningTrades / f_PMData.m_DayOfTradable)*100.0;
    end else
    begin
        f_PMData.m_PercentProfitable := 0;
    end;

    if f_PMData.m_GrossProfit <> 0 then
    begin
        f_PMData.m_SuccessRate := (f_PMData.m_NetProfit / f_PMData.m_GrossProfit)*100.0;
    end else
    begin
        f_PMData.m_SuccessRate := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgTrade := f_PMData.m_NetProfit / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgTrade := 0;
    end;

    if f_PMData.m_GrossLoss <> 0 then
    begin
        f_PMData.m_ProfitFactor := abs(f_PMData.m_GrossProfit / f_PMData.m_GrossLoss);
    end else
    begin
        f_PMData.m_ProfitFactor := 0;
    end;
    {$ENDREGION}

    {$REGION '1차 신호의 매수거래'}
    f_PMData := m_PMData[1];
    f_PMData.DefaultValue;
    f_HighProfit := 0;

    f_ConsecWinners:=0;
    f_ConsecLosers:=0;

    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_ValueIndex >= f_OriginIndex then
        begin
            f_Profit := f_ChartData.m_BProfit;
            f_Tradable := true;
            f_TradeCount := Trunc(f_ChartData.m_BNumberOfTrades);
            Inc(f_PMData.m_DayOfTrades);
            if f_Tradable then
            begin
                if f_Profit > 0 then
                begin
                    f_PMData.m_GrossProfit := f_PMData.m_GrossProfit + f_Profit;
                    Inc(f_PMData.m_DayOfWinningTrades);
                    if (f_PMData.m_LargestWinningTrade < f_Profit) then f_PMData.m_LargestWinningTrade := f_Profit;
                    Inc(f_ConsecWinners);
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecLosers := 0;
                end else
                if f_Profit < 0 then
                begin
                    f_PMData.m_GrossLoss := f_PMData.m_GrossLoss + f_Profit;
                    Inc(f_PMData.m_DayOfLosingTrades);
                    if (f_PMData.m_LargestLosingTrade > f_Profit) then f_PMData.m_LargestLosingTrade := f_Profit;
                    Inc(f_ConsecLosers);
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    f_ConsecWinners := 0;
                end else
                begin
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecWinners := 0;
                    f_ConsecLosers := 0;
                end;

                Inc(f_PMData.m_NumberOfTrades, f_TradeCount);
                Inc(f_PMData.m_DayOfTradable);

                f_SumProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;
                if f_HighProfit < f_SumProfit then f_HighProfit := f_SumProfit;
                f_Drawdown := f_SumProfit - f_HighProfit;
                if f_PMData.m_MaxDrawdown > f_Drawdown then f_PMData.m_MaxDrawdown := f_Drawdown;
            end;
        end;
    end;
    f_PMData.m_NetProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgDayOfTrades := f_PMData.m_NumberOfTrades / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgDayOfTrades := 0;
    end;

    if f_PMData.m_DayOfWinningTrades <> 0 then
    begin
        f_PMData.m_AverageWinningTrade := f_PMData.m_GrossProfit / f_PMData.m_DayOfWinningTrades;
    end else
    begin
        f_PMData.m_AverageWinningTrade := 0;
    end;

    if f_PMData.m_DayOfLosingTrades <> 0 then
    begin
        f_PMData.m_AverageLosingTrade := f_PMData.m_GrossLoss / f_PMData.m_DayOfLosingTrades;
    end else
    begin
        f_PMData.m_AverageLosingTrade := 0;
    end;

    if f_PMData.m_AverageLosingTrade <> 0 then
    begin
        f_PMData.m_RatioAvgWinAvgLoss := abs(f_PMData.m_AverageWinningTrade / f_PMData.m_AverageLosingTrade);
    end else
    begin
        f_PMData.m_RatioAvgWinAvgLoss := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_PercentProfitable := (f_PMData.m_DayOfWinningTrades / f_PMData.m_DayOfTradable)*100.0;
    end else
    begin
        f_PMData.m_PercentProfitable := 0;
    end;

    if f_PMData.m_GrossProfit <> 0 then
    begin
        f_PMData.m_SuccessRate := (f_PMData.m_NetProfit / f_PMData.m_GrossProfit)*100.0;
    end else
    begin
        f_PMData.m_SuccessRate := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgTrade := f_PMData.m_NetProfit / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgTrade := 0;
    end;

    if f_PMData.m_GrossLoss <> 0 then
    begin
        f_PMData.m_ProfitFactor := abs(f_PMData.m_GrossProfit / f_PMData.m_GrossLoss);
    end else
    begin
        f_PMData.m_ProfitFactor := 0;
    end;
    {$ENDREGION}

    {$REGION '1차 신호의 매도거래'}
    f_PMData := m_PMData[2];
    f_PMData.DefaultValue;
    f_HighProfit := 0;

    f_ConsecWinners:=0;
    f_ConsecLosers:=0;

    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_ValueIndex >= f_OriginIndex then
        begin
            f_Profit := f_ChartData.m_SProfit;
            f_Tradable := true;
            f_TradeCount := Trunc(f_ChartData.m_SNumberOfTrades);
            Inc(f_PMData.m_DayOfTrades);
            if f_Tradable then
            begin
                if f_Profit > 0 then
                begin
                    f_PMData.m_GrossProfit := f_PMData.m_GrossProfit + f_Profit;
                    Inc(f_PMData.m_DayOfWinningTrades);
                    if (f_PMData.m_LargestWinningTrade < f_Profit) then f_PMData.m_LargestWinningTrade := f_Profit;
                    Inc(f_ConsecWinners);
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecLosers := 0;
                end else
                if f_Profit < 0 then
                begin
                    f_PMData.m_GrossLoss := f_PMData.m_GrossLoss + f_Profit;
                    Inc(f_PMData.m_DayOfLosingTrades);
                    if (f_PMData.m_LargestLosingTrade > f_Profit) then f_PMData.m_LargestLosingTrade := f_Profit;
                    Inc(f_ConsecLosers);
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    f_ConsecWinners := 0;
                end else
                begin
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecWinners := 0;
                    f_ConsecLosers := 0;
                end;

                Inc(f_PMData.m_NumberOfTrades, f_TradeCount);
                Inc(f_PMData.m_DayOfTradable);

                f_SumProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;
                if f_HighProfit < f_SumProfit then f_HighProfit := f_SumProfit;
                f_Drawdown := f_SumProfit - f_HighProfit;
                if f_PMData.m_MaxDrawdown > f_Drawdown then f_PMData.m_MaxDrawdown := f_Drawdown;
            end;
        end;
    end;
    f_PMData.m_NetProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgDayOfTrades := f_PMData.m_NumberOfTrades / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgDayOfTrades := 0;
    end;

    if f_PMData.m_DayOfWinningTrades <> 0 then
    begin
        f_PMData.m_AverageWinningTrade := f_PMData.m_GrossProfit / f_PMData.m_DayOfWinningTrades;
    end else
    begin
        f_PMData.m_AverageWinningTrade := 0;
    end;

    if f_PMData.m_DayOfLosingTrades <> 0 then
    begin
        f_PMData.m_AverageLosingTrade := f_PMData.m_GrossLoss / f_PMData.m_DayOfLosingTrades;
    end else
    begin
        f_PMData.m_AverageLosingTrade := 0;
    end;

    if f_PMData.m_AverageLosingTrade <> 0 then
    begin
        f_PMData.m_RatioAvgWinAvgLoss := abs(f_PMData.m_AverageWinningTrade / f_PMData.m_AverageLosingTrade);
    end else
    begin
        f_PMData.m_RatioAvgWinAvgLoss := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_PercentProfitable := (f_PMData.m_DayOfWinningTrades / f_PMData.m_DayOfTradable)*100.0;
    end else
    begin
        f_PMData.m_PercentProfitable := 0;
    end;

    if f_PMData.m_GrossProfit <> 0 then
    begin
        f_PMData.m_SuccessRate := (f_PMData.m_NetProfit / f_PMData.m_GrossProfit)*100.0;
    end else
    begin
        f_PMData.m_SuccessRate := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgTrade := f_PMData.m_NetProfit / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgTrade := 0;
    end;

    if f_PMData.m_GrossLoss <> 0 then
    begin
        f_PMData.m_ProfitFactor := abs(f_PMData.m_GrossProfit / f_PMData.m_GrossLoss);
    end else
    begin
        f_PMData.m_ProfitFactor := 0;
    end;
    {$ENDREGION}

    {$REGION '2차 신호의 전체거래'}
    f_PMData := m_PMData[3];
    f_PMData.DefaultValue;
    f_HighProfit := 0;

    f_ConsecWinners:=0;
    f_ConsecLosers:=0;

    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_ValueIndex >= f_OriginIndex then
        begin
            f_Profit := f_ChartData.m_TProfit;
            f_Tradable := (f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] = 1) OR (f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] = 1);

            f_TradeCount := 0;
            if f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] = 1 then f_TradeCount := f_TradeCount + Trunc(f_ChartData.m_BNumberOfTrades);
            if f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] = 1 then f_TradeCount := f_TradeCount + Trunc(f_ChartData.m_SNumberOfTrades);


            Inc(f_PMData.m_DayOfTrades);
            if f_Tradable then
            begin
                if f_Profit > 0 then
                begin
                    f_PMData.m_GrossProfit := f_PMData.m_GrossProfit + f_Profit;
                    Inc(f_PMData.m_DayOfWinningTrades);
                    if (f_PMData.m_LargestWinningTrade < f_Profit) then f_PMData.m_LargestWinningTrade := f_Profit;
                    Inc(f_ConsecWinners);
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecLosers := 0;
                end else
                if f_Profit < 0 then
                begin
                    f_PMData.m_GrossLoss := f_PMData.m_GrossLoss + f_Profit;
                    Inc(f_PMData.m_DayOfLosingTrades);
                    if (f_PMData.m_LargestLosingTrade > f_Profit) then f_PMData.m_LargestLosingTrade := f_Profit;
                    Inc(f_ConsecLosers);
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    f_ConsecWinners := 0;
                end else
                begin
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecWinners := 0;
                    f_ConsecLosers := 0;
                end;

                Inc(f_PMData.m_NumberOfTrades, f_TradeCount);
                Inc(f_PMData.m_DayOfTradable);

                f_SumProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;
                if f_HighProfit < f_SumProfit then f_HighProfit := f_SumProfit;
                f_Drawdown := f_SumProfit - f_HighProfit;
                if f_PMData.m_MaxDrawdown > f_Drawdown then f_PMData.m_MaxDrawdown := f_Drawdown;
            end;
        end;
    end;
    f_PMData.m_NetProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgDayOfTrades := f_PMData.m_NumberOfTrades / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgDayOfTrades := 0;
    end;

    if f_PMData.m_DayOfWinningTrades <> 0 then
    begin
        f_PMData.m_AverageWinningTrade := f_PMData.m_GrossProfit / f_PMData.m_DayOfWinningTrades;
    end else
    begin
        f_PMData.m_AverageWinningTrade := 0;
    end;

    if f_PMData.m_DayOfLosingTrades <> 0 then
    begin
        f_PMData.m_AverageLosingTrade := f_PMData.m_GrossLoss / f_PMData.m_DayOfLosingTrades;
    end else
    begin
        f_PMData.m_AverageLosingTrade := 0;
    end;

    if f_PMData.m_AverageLosingTrade <> 0 then
    begin
        f_PMData.m_RatioAvgWinAvgLoss := abs(f_PMData.m_AverageWinningTrade / f_PMData.m_AverageLosingTrade);
    end else
    begin
        f_PMData.m_RatioAvgWinAvgLoss := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_PercentProfitable := (f_PMData.m_DayOfWinningTrades / f_PMData.m_DayOfTradable)*100.0;
    end else
    begin
        f_PMData.m_PercentProfitable := 0;
    end;

    if f_PMData.m_GrossProfit <> 0 then
    begin
        f_PMData.m_SuccessRate := (f_PMData.m_NetProfit / f_PMData.m_GrossProfit)*100.0;
    end else
    begin
        f_PMData.m_SuccessRate := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgTrade := f_PMData.m_NetProfit / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgTrade := 0;
    end;

    if f_PMData.m_GrossLoss <> 0 then
    begin
        f_PMData.m_ProfitFactor := abs(f_PMData.m_GrossProfit / f_PMData.m_GrossLoss);
    end else
    begin
        f_PMData.m_ProfitFactor := 0;
    end;
    {$ENDREGION}

    {$REGION '2차 신호의 매수거래'}
    f_PMData := m_PMData[4];
    f_PMData.DefaultValue;
    f_HighProfit := 0;

    f_ConsecWinners:=0;
    f_ConsecLosers:=0;

    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_ValueIndex >= f_OriginIndex then
        begin
            f_Profit := f_ChartData.m_BProfit;
            f_Tradable := (f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] = 1);

            f_TradeCount := 0;
            if f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] = 1 then f_TradeCount := f_TradeCount + Trunc(f_ChartData.m_BNumberOfTrades);

            Inc(f_PMData.m_DayOfTrades);
            if f_Tradable then
            begin
                if f_Profit > 0 then
                begin
                    f_PMData.m_GrossProfit := f_PMData.m_GrossProfit + f_Profit;
                    Inc(f_PMData.m_DayOfWinningTrades);
                    if (f_PMData.m_LargestWinningTrade < f_Profit) then f_PMData.m_LargestWinningTrade := f_Profit;
                    Inc(f_ConsecWinners);
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecLosers := 0;
                end else
                if f_Profit < 0 then
                begin
                    f_PMData.m_GrossLoss := f_PMData.m_GrossLoss + f_Profit;
                    Inc(f_PMData.m_DayOfLosingTrades);
                    if (f_PMData.m_LargestLosingTrade > f_Profit) then f_PMData.m_LargestLosingTrade := f_Profit;
                    Inc(f_ConsecLosers);
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    f_ConsecWinners := 0;
                end else
                begin
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecWinners := 0;
                    f_ConsecLosers := 0;
                end;

                Inc(f_PMData.m_NumberOfTrades, f_TradeCount);
                Inc(f_PMData.m_DayOfTradable);

                f_SumProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;
                if f_HighProfit < f_SumProfit then f_HighProfit := f_SumProfit;
                f_Drawdown := f_SumProfit - f_HighProfit;
                if f_PMData.m_MaxDrawdown > f_Drawdown then f_PMData.m_MaxDrawdown := f_Drawdown;
            end;
        end;
    end;
    f_PMData.m_NetProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgDayOfTrades := f_PMData.m_NumberOfTrades / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgDayOfTrades := 0;
    end;

    if f_PMData.m_DayOfWinningTrades <> 0 then
    begin
        f_PMData.m_AverageWinningTrade := f_PMData.m_GrossProfit / f_PMData.m_DayOfWinningTrades;
    end else
    begin
        f_PMData.m_AverageWinningTrade := 0;
    end;

    if f_PMData.m_DayOfLosingTrades <> 0 then
    begin
        f_PMData.m_AverageLosingTrade := f_PMData.m_GrossLoss / f_PMData.m_DayOfLosingTrades;
    end else
    begin
        f_PMData.m_AverageLosingTrade := 0;
    end;

    if f_PMData.m_AverageLosingTrade <> 0 then
    begin
        f_PMData.m_RatioAvgWinAvgLoss := abs(f_PMData.m_AverageWinningTrade / f_PMData.m_AverageLosingTrade);
    end else
    begin
        f_PMData.m_RatioAvgWinAvgLoss := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_PercentProfitable := (f_PMData.m_DayOfWinningTrades / f_PMData.m_DayOfTradable)*100.0;
    end else
    begin
        f_PMData.m_PercentProfitable := 0;
    end;

    if f_PMData.m_GrossProfit <> 0 then
    begin
        f_PMData.m_SuccessRate := (f_PMData.m_NetProfit / f_PMData.m_GrossProfit)*100.0;
    end else
    begin
        f_PMData.m_SuccessRate := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgTrade := f_PMData.m_NetProfit / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgTrade := 0;
    end;

    if f_PMData.m_GrossLoss <> 0 then
    begin
        f_PMData.m_ProfitFactor := abs(f_PMData.m_GrossProfit / f_PMData.m_GrossLoss);
    end else
    begin
        f_PMData.m_ProfitFactor := 0;
    end;
    {$ENDREGION}

    {$REGION '2차 신호의 매도거래'}
    f_PMData := m_PMData[5];
    f_PMData.DefaultValue;
    f_HighProfit := 0;

    f_ConsecWinners:=0;
    f_ConsecLosers:=0;

    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_ValueIndex >= f_OriginIndex then
        begin
            f_Profit := f_ChartData.m_SProfit;
            f_Tradable := (f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] = 1);

            f_TradeCount := 0;
            if f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] = 1 then f_TradeCount := f_TradeCount + Trunc(f_ChartData.m_SNumberOfTrades);

            Inc(f_PMData.m_DayOfTrades);
            if f_Tradable then
            begin
                if f_Profit > 0 then
                begin
                    f_PMData.m_GrossProfit := f_PMData.m_GrossProfit + f_Profit;
                    Inc(f_PMData.m_DayOfWinningTrades);
                    if (f_PMData.m_LargestWinningTrade < f_Profit) then f_PMData.m_LargestWinningTrade := f_Profit;
                    Inc(f_ConsecWinners);
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecLosers := 0;
                end else
                if f_Profit < 0 then
                begin
                    f_PMData.m_GrossLoss := f_PMData.m_GrossLoss + f_Profit;
                    Inc(f_PMData.m_DayOfLosingTrades);
                    if (f_PMData.m_LargestLosingTrade > f_Profit) then f_PMData.m_LargestLosingTrade := f_Profit;
                    Inc(f_ConsecLosers);
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    f_ConsecWinners := 0;
                end else
                begin
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecWinners := 0;
                    f_ConsecLosers := 0;
                end;

                Inc(f_PMData.m_NumberOfTrades, f_TradeCount);
                Inc(f_PMData.m_DayOfTradable);

                f_SumProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;
                if f_HighProfit < f_SumProfit then f_HighProfit := f_SumProfit;
                f_Drawdown := f_SumProfit - f_HighProfit;
                if f_PMData.m_MaxDrawdown > f_Drawdown then f_PMData.m_MaxDrawdown := f_Drawdown;
            end;
        end;
    end;
    f_PMData.m_NetProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgDayOfTrades := f_PMData.m_NumberOfTrades / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgDayOfTrades := 0;
    end;

    if f_PMData.m_DayOfWinningTrades <> 0 then
    begin
        f_PMData.m_AverageWinningTrade := f_PMData.m_GrossProfit / f_PMData.m_DayOfWinningTrades;
    end else
    begin
        f_PMData.m_AverageWinningTrade := 0;
    end;

    if f_PMData.m_DayOfLosingTrades <> 0 then
    begin
        f_PMData.m_AverageLosingTrade := f_PMData.m_GrossLoss / f_PMData.m_DayOfLosingTrades;
    end else
    begin
        f_PMData.m_AverageLosingTrade := 0;
    end;

    if f_PMData.m_AverageLosingTrade <> 0 then
    begin
        f_PMData.m_RatioAvgWinAvgLoss := abs(f_PMData.m_AverageWinningTrade / f_PMData.m_AverageLosingTrade);
    end else
    begin
        f_PMData.m_RatioAvgWinAvgLoss := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_PercentProfitable := (f_PMData.m_DayOfWinningTrades / f_PMData.m_DayOfTradable)*100.0;
    end else
    begin
        f_PMData.m_PercentProfitable := 0;
    end;

    if f_PMData.m_GrossProfit <> 0 then
    begin
        f_PMData.m_SuccessRate := (f_PMData.m_NetProfit / f_PMData.m_GrossProfit)*100.0;
    end else
    begin
        f_PMData.m_SuccessRate := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgTrade := f_PMData.m_NetProfit / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgTrade := 0;
    end;

    if f_PMData.m_GrossLoss <> 0 then
    begin
        f_PMData.m_ProfitFactor := abs(f_PMData.m_GrossProfit / f_PMData.m_GrossLoss);
    end else
    begin
        f_PMData.m_ProfitFactor := 0;
    end;
    {$ENDREGION}

    for f_ValueIndex := 0 to 5 do
    begin
        WritePrformance(m_PMData[f_ValueIndex], m_PMValueCollection[f_ValueIndex]);
    end;

    ListViewPM.Items.Count := m_PMValueCollection[0].m_Items.Count;
    ListViewPM.Repaint;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.ListViewPMCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
    if Item.Index mod 2 = 0 then
    begin
        Sender.Canvas.Brush.Color := RGB($FF,$FF,$FF);
    end else
    begin
        Sender.Canvas.Brush.Color := RGB($F0,$F0,$F0);
    end;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.ListViewPMCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
var
    f_Paper:TCanvas;
    f_ListView:TListView;

    f_Index:Integer;
    f_Value:CFNPMValueItem;
    f_ItemIndex:Integer;
begin
    f_ListView := TListView(Sender);

    f_Paper := f_ListView.Canvas;

    if ((Item.Index < 0) or (Item.Index >= m_PMValueCollection[0].m_Items.Count)) then exit;

    if Item.Index mod 2 = 0 then
    begin
        Sender.Canvas.Brush.Color := RGB($FF,$FF,$FF);
    end else
    begin
        Sender.Canvas.Brush.Color := RGB($F0,$F0,$F0);
    end;

    if (SubItem >= 1) then
    begin
        f_ItemIndex := Item.Index ;
        f_Value := m_PMValueCollection[SubItem-1].m_Items[f_ItemIndex];
        Item.Data := f_Value;

        if Assigned(f_Value) AND f_Value.m_SignColor then
        begin
            if (f_Value.m_Value > 0) then
            begin
                f_Paper.Font.Color := clWhite;
                f_Paper.Font.Color := RGB($EE,$00,$00);
            end else
            if (f_Value.m_Value < 0) then
            begin
                f_Paper.Font.Color := clWhite;
                f_Paper.Font.Color := RGB($00,$00,$EE);
            end else
            begin
                f_Paper.Font.Color := clWhite;
                f_Paper.Font.Color := RGB($00,$00,$00);
            end;
        end;
    end;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.ListViewPMData(Sender: TObject; Item: TListItem);
var
    f_Index:Integer;
    f_Value:CFNPMValueItem;
    f_ItemIndex:Integer;
begin
    if ((Item.Index < 0) or (Item.Index >= m_PMValueCollection[0].m_Items.Count)) then exit;

    f_ItemIndex := Item.Index ;
    f_Value := m_PMValueCollection[0].m_Items[f_ItemIndex];
    Item.Data := f_Value;

    if f_Value = NIL then exit;

    Item.Caption := f_Value.m_Name;
    for f_Index := 0 to 5 do
    begin
        f_Value := m_PMValueCollection[f_Index].m_Items[f_ItemIndex];
        Item.SubItems.Add(Format('%.*n', [f_Value.m_Precision, f_Value.m_Value]) + f_Value.m_Unit);
    end;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.ApplyChart;
begin
    CFNNAVAnalChartControl1.SetChartDataSeries(m_ChartDataSeries, m_NAVSeries);
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.Button1Click(Sender: TObject);
begin
    GetOption;
    AnalisysNAV;
    AnalisysPM;
    ApplyChart;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.CFNNAVAnalChartControl1ChartTraceChange(p_Index: Integer; p_ValueX, p_ValueY: Double);
begin
    CFNNAVAnalChartControl1.DrawTrace(p_Index, p_ValueX, p_ValueY);
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.ClearDailyPMListView;
begin
    ListViewDailyPM.Items.Count := 0;
    ListViewDailyPM.Repaint;
    m_DailyPMValueCollection.Clear;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.DisplayDailyPMListView;
begin
    ListViewDailyPM.Items.Count := m_DailyPMValueCollection.m_Items.Count;
    ListViewDailyPM.Repaint;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.EditKeyPress(Sender: TObject; var Key: Char);
begin
    if Key in ['0'..'9', '-', #8, #9, #32, #3, #22, #$2E] then // 0~9, -, Tab, BS, Space, Ctrl+C, Ctrl+V ?? ???
    begin
    end else
    begin
        Key := #0;
    end;
end;

{$REGION '일별실적화면 출력'}
//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.ListViewDailyPMCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
    Sender.Canvas.Brush.Color := RGB($C0,$C0,$C0);
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.ListViewDailyPMCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
    f_PMItem:CFNDailyPMValueItem;
begin
    f_PMItem := Item.Data;

    if Item.Index <= 1 then
    begin
        Sender.Canvas.Brush.Color := RGB($C0,$C0,$C0);
    end else
    begin
        if Item.Index mod 2 = 0 then
        begin
            Sender.Canvas.Brush.Color := RGB($FF,$FF,$FF);
        end else
        begin
            Sender.Canvas.Brush.Color := RGB($F0,$F0,$F0);
        end;
    end;

    if (SubItem = 1) then
    begin
        if (f_PMItem.m_TProfit > 0) then
        begin
            Sender.Canvas.Font.Color := RGB($FF, $00,  $00);
        end else
        if (f_PMItem.m_TProfit < 0) then
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $FF);
        end else
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $00);
        end;
    end else
    if (SubItem = 2) then
    begin
        if (f_PMItem.m_TProfitSum > 0) then
        begin
            Sender.Canvas.Font.Color := RGB($FF, $00,  $00);
        end else
        if (f_PMItem.m_TProfitSum < 0) then
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $FF);
        end else
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $00);
        end;
    end else
    if (SubItem = 3) then
    begin
        if (f_PMItem.m_BProfit > 0) then
        begin
            Sender.Canvas.Font.Color := RGB($FF, $00,  $00);
        end else
        if (f_PMItem.m_BProfit < 0) then
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $FF);
        end else
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $00);
        end;
    end else
    if (SubItem = 4) then
    begin
        if (f_PMItem.m_BProfitSum > 0) then
        begin
            Sender.Canvas.Font.Color := RGB($FF, $00,  $00);
        end else
        if (f_PMItem.m_BProfitSum < 0) then
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $FF);
        end else
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $00);
        end;
    end else
    if (SubItem = 5) then
    begin
        if (f_PMItem.m_SProfit > 0) then
        begin
            Sender.Canvas.Font.Color := RGB($FF, $00,  $00);
        end else
        if (f_PMItem.m_SProfit < 0) then
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $FF);
        end else
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $00);
        end;
    end else
    if (SubItem = 6) then
    begin
        if (f_PMItem.m_SProfitSum > 0) then
        begin
            Sender.Canvas.Font.Color := RGB($FF, $00,  $00);
        end else
        if (f_PMItem.m_SProfitSum < 0) then
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $FF);
        end else
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $00);
        end;
    end else
    begin
        Sender.Canvas.Font.Color := RGB($00, $00,  $00);
    end;

    if Item.Index > 1 then
    begin
        if (SubItem = 2) or (SubItem = 4) or (SubItem = 6) then
        begin
            Sender.Canvas.Brush.Color := RGB($EE,$EE,$EE);
        end;
    end;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.ListViewDailyPMData(Sender: TObject; Item: TListItem);
var
    nItemIndex : integer;
    f_Item:CFNDailyPMValueItem;
begin
    if ((Item.Index < 0) or (Item.Index >= m_DailyPMValueCollection.m_Items.Count)) then exit;
    nItemIndex := Item.Index;
    f_Item := m_DailyPMValueCollection.m_Items[m_DailyPMValueCollection.m_Items.Count - nItemIndex - 1];

    if f_Item.m_Date = 1 then
    begin
        Item.Caption := '합계';
    end else
    if f_Item.m_Date = 2 then
    begin
        Item.Caption := '평균';
    end else
    begin
        Item.Caption := DateToStr(f_Item.m_Date);
    end;

    Item.SubItems.Add(Format('%.2n', [f_Item.m_TProfit]));
    if f_Item.m_Date < 10 then
    begin
        Item.SubItems.Add('');
    end else
    begin
        Item.SubItems.Add(Format('%.2n', [f_Item.m_TProfitSum]));
    end;

    Item.SubItems.Add(Format('%.2f', [f_Item.m_BProfit]));
    if f_Item.m_Date < 10 then
    begin
        Item.SubItems.Add('');
    end else
    begin
        Item.SubItems.Add(Format('%.2n', [f_Item.m_BProfitSum]));
    end;

    Item.SubItems.Add(Format('%.2f', [f_Item.m_SProfit]));
    if f_Item.m_Date < 10 then
    begin
        Item.SubItems.Add('');
    end else
    begin
        Item.SubItems.Add(Format('%.2n', [f_Item.m_SProfitSum]));
    end;

    Item.SubItems.Add(Format('%.2n', [f_Item.m_TNumberOfTrades]));
    Item.SubItems.Add(Format('%.2n', [f_Item.m_BNumberOfTrades]));
    Item.SubItems.Add(Format('%.2n', [f_Item.m_SNumberOfTrades]));
    Item.SubItems.Add(Format('%.2n', [f_Item.m_Price]));
    Item.Data := f_Item;
end;



procedure TMDINAVAnalisys.OnChange(Sender: TObject);
begin
    if not m_EnableEvent then exit;
    GetOption;
end;

{$ENDREGION}

//------------------------------------------------------------------------------------
constructor CFNNAVAnalOption.Create;
begin
    DefaultValue;
end;

//------------------------------------------------------------------------------------
procedure CFNNAVAnalOption.DefaultValue;
begin
    m_UseMA1     := true;
    m_MA1Value1  := 30;
    m_MA1Value2  :=  3;
    m_MA1Value3  :=  3;
    m_MA1Value4  :=  -1;

    m_UseMA2     := true;
    m_MA2Value1  :=  5;
    m_MA2Value2  :=  3;
    m_MA2Value3  :=  3;
    m_MA2Value4  :=  -1;

    m_StandDate  :=  Now-240;
end;

//------------------------------------------------------------------------------------
procedure CFNNAVAnalOption.Clone(p_Source: CFNNAVAnalOption);
begin
    m_UseMA1     := p_Source.m_UseMA1;
    m_MA1Value1  := p_Source.m_MA1Value1;
    m_MA1Value2  := p_Source.m_MA1Value2;
    m_MA1Value3  := p_Source.m_MA1Value3;
    m_MA1Value4  := p_Source.m_MA1Value4;

    m_UseMA2     := p_Source.m_UseMA2;
    m_MA2Value1  := p_Source.m_MA2Value1;
    m_MA2Value2  := p_Source.m_MA2Value2;
    m_MA2Value3  := p_Source.m_MA2Value3;
    m_MA2Value4  := p_Source.m_MA2Value4;

    m_StandDate  := p_Source.m_StandDate;
end;

//------------------------------------------------------------------------------------
constructor CFNNAVAnalPMData.Create;
begin
    DefaultValue;
end;

//------------------------------------------------------------------------------------
procedure CFNNAVAnalPMData.DefaultValue;
begin
    m_NetProfit                 :=  0;
    m_GrossProfit               :=  0;
    m_GrossLoss                 :=  0;
    m_NumberOfTrades            :=  0;

    m_AvgDayOfTrades            :=  0;

    m_DayOfTrades               :=  0;
    m_DayOfTradable             :=  0;
    m_DayOfWinningTrades        :=  0;
    m_DayOfLosingTrades         :=  0;
    m_PercentProfitable         :=  0;

    m_LargestWinningTrade       :=  0;
    m_LargestLosingTrade        :=  0;

    m_AverageWinningTrade       :=  0;
    m_AverageLosingTrade        :=  0;

    m_RatioAvgWinAvgLoss        :=  0;
    m_AvgTrade                  :=  0;
    m_MaxConsecWinners          :=  0;
    m_MaxConsecLosers           :=  0;

    m_AvgBarsWinners            :=  0;
    m_AvgBarsLosers             :=  0;
    m_MaxDrawdown               :=  0;

    m_ProfitFactor              :=  0;
    m_SuccessRate               :=  0;
end;

//------------------------------------------------------------------------------------
procedure CFNNAVAnalPMData.Clone(p_Source: CFNNAVAnalPMData);
begin
    m_NetProfit                 :=  p_Source.m_NetProfit                 ;
    m_GrossProfit               :=  p_Source.m_GrossProfit               ;
    m_GrossLoss                 :=  p_Source.m_GrossLoss                 ;
    m_NumberOfTrades            :=  p_Source.m_NumberOfTrades            ;
    m_AvgDayOfTrades            :=  p_Source.m_AvgDayOfTrades            ;

    m_DayOfTrades               :=  p_Source.m_DayOfTrades               ;
    m_DayOfTradable             :=  p_Source.m_DayOfTradable             ;
    m_DayOfWinningTrades        :=  p_Source.m_DayOfWinningTrades        ;
    m_DayOfLosingTrades         :=  p_Source.m_DayOfLosingTrades         ;
    m_PercentProfitable         :=  p_Source.m_PercentProfitable         ;

    m_LargestWinningTrade       :=  p_Source.m_LargestWinningTrade       ;
    m_LargestLosingTrade        :=  p_Source.m_LargestLosingTrade        ;

    m_AverageWinningTrade       :=  p_Source.m_AverageWinningTrade       ;
    m_AverageLosingTrade        :=  p_Source.m_AverageLosingTrade        ;

    m_RatioAvgWinAvgLoss        :=  p_Source.m_RatioAvgWinAvgLoss        ;
    m_AvgTrade                  :=  p_Source.m_AvgTrade                  ;
    m_MaxConsecWinners          :=  p_Source.m_MaxConsecWinners          ;
    m_MaxConsecLosers           :=  p_Source.m_MaxConsecLosers           ;

    m_AvgBarsWinners            :=  p_Source.m_AvgBarsWinners            ;
    m_AvgBarsLosers             :=  p_Source.m_AvgBarsLosers             ;
    m_MaxDrawdown               :=  p_Source.m_MaxDrawdown               ;

    m_ProfitFactor              :=  p_Source.m_ProfitFactor              ;
    m_SuccessRate               :=  p_Source.m_SuccessRate               ;
end;

//------------------------------------------------------------------------------------
procedure TMDINAVAnalisys.WritePrformance(APMData:CFNNAVAnalPMData; AValueArray: CFNPMValueCollection);
var
    f_PMValueItem:CFNPMValueItem;
begin
    AValueArray.Clear;

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '순이익';
    f_PMValueItem.m_Value := APMData.m_NetProfit;
    f_PMValueItem.m_Precision := 2;
    f_PMValueItem.m_SignColor := true;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '전체거래수';
    f_PMValueItem.m_Value := APMData.m_NumberOfTrades;
    f_PMValueItem.m_Precision := 0;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '일평균거래수';
    f_PMValueItem.m_Value := APMData.m_AvgDayOfTrades;
    f_PMValueItem.m_Precision := 2;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '거래일수';
    f_PMValueItem.m_Value := APMData.m_DayOfTrades;
    f_PMValueItem.m_Precision := 0;
    AValueArray.Add(f_PMValueItem);;

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '거래가능일수';
    f_PMValueItem.m_Value := APMData.m_DayOfTradable;
    f_PMValueItem.m_Precision := 0;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '총이익/총손실';
    f_PMValueItem.m_Value := APMData.m_ProfitFactor;
    f_PMValueItem.m_Precision := 2;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '총이익';
    f_PMValueItem.m_Value := APMData.m_GrossProfit;
    f_PMValueItem.m_Precision := 2;
    f_PMValueItem.m_SignColor := true;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '총손실';
    f_PMValueItem.m_Value := APMData.m_GrossLoss;
    f_PMValueItem.m_Precision := 2;
    f_PMValueItem.m_SignColor := true;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '승률';
    f_PMValueItem.m_Value := APMData.m_PercentProfitable;
    f_PMValueItem.m_Precision := 2;
    f_PMValueItem.m_Unit := '%';
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '성공율';
    f_PMValueItem.m_Value := APMData.m_SuccessRate;
    f_PMValueItem.m_Precision := 2;
    f_PMValueItem.m_Unit := '%';
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '이익거래일수';
    f_PMValueItem.m_Value := APMData.m_DayOfWinningTrades;
    f_PMValueItem.m_Precision := 0;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '손실거래일수';
    f_PMValueItem.m_Value := APMData.m_DayOfLosingTrades;
    f_PMValueItem.m_Precision := 0;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '평균이익거래금액';
    f_PMValueItem.m_Value := APMData.m_AverageWinningTrade;
    f_PMValueItem.m_Precision := 2;
    f_PMValueItem.m_SignColor := true;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '평균손실거래금액';
    f_PMValueItem.m_Value := APMData.m_AverageLosingTrade;
    f_PMValueItem.m_Precision := 2;
    f_PMValueItem.m_SignColor := true;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '순이익/전체거래일수';
    f_PMValueItem.m_Value := APMData.m_AvgTrade;
    f_PMValueItem.m_Precision := 2;
    f_PMValueItem.m_SignColor := true;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '평균이익거래금액/평균손실거래금액 ';
    f_PMValueItem.m_Value := APMData.m_RatioAvgWinAvgLoss;
    f_PMValueItem.m_Precision := 2;
    f_PMValueItem.m_SignColor := true;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '최대연속이익거래일수';
    f_PMValueItem.m_Value := APMData.m_MaxConsecWinners;
    f_PMValueItem.m_Precision := 0;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '최대연속손실거래일수';
    f_PMValueItem.m_Value := APMData.m_MaxConsecLosers;
    f_PMValueItem.m_Precision := 0;
    AValueArray.Add(f_PMValueItem);

    f_PMValueItem := CFNPMValueItem.Create;
    f_PMValueItem.m_Name := '순이익최대삭감금액';
    f_PMValueItem.m_Value := APMData.m_MaxDrawdown;
    f_PMValueItem.m_Precision :=  2;
    f_PMValueItem.m_SignColor := true;
    AValueArray.Add(f_PMValueItem);
end;

end.


