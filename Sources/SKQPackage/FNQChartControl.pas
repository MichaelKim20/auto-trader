unit FNQChartControl;

interface

uses
    SysUtils, Classes, Controls, GR32_Image, GR32, Types, Messages, Graphics, DateUtils, Dialogs, Math,
    StdCtrls, Windows,
    GR32_Layers, 
    FNQLineValueSeries, 
    FNQLineValueSeriesCreator, 
    FNQSetting, 
    FNQChartDataSeries,
    FNQStreamChartDataSeries,
    FNDataSet, 
    FNQChartData, 
    FNQIndicatorValue, 
    FNQueue, 
    FNQConst, 
    FNQMaxMin, 
    FNQColorSet,
    FNQChartBlockManager, 
    FNQChartBlock, 
    FNQChartDataManager, 
    FNQRequestData,
    FNQChartTraceEvent,
    FNSocketManager,
    FNSymbolCollection, 
    FNQuotData;
type

    TFNQChartTraceChange = Procedure(p_Index:Integer; p_Date:TDateTime) of Object;

    CFNQChartControl = class(TImgView32)
    private
        m_SocketManager     : CFNSocketManager;
        m_TimeFrame         : Integer;
        m_RequestCount      : Integer;
        m_ChartBlockManager : CFNQChartBlockManager;

        m_ChartBlock        : CFNQChartBlock;

        m_ChartDataSeries   : CFNQStreamChartDataSeries;
        m_PriceSeries       : CFNQLineValueSeries;
        m_VolumeSeries      : CFNQLineValueSeries;

        m_LineSeriesCreator : CFNQLineValueSeriesCreator;
        m_Setting           : CFNQSetting;
        m_Initialized       : Boolean;

        m_ChartDataManager  : CFNQChartDataManager;
        m_IndicatorSeries   : CFNQLineValueSeries;
        m_IndicatorNumber   : Integer;

        m_ChartType         : Integer;
        m_PriceBlockType    : Integer;

        m_OnControlPaintStage : TPaintStageEvent;

        m_ScrollBar             : TScrollBar;
        m_ChartCaption          : TImgView32;
        m_ChartTrace            : TImgView32;

        m_Scale                 :   Integer;
        m_FirstStage            :   Boolean;

        m_SymbolItem            :   CFNSymbolItem;
        m_SubscribeSymbolItem   :   CFNSymbolItem;          //  스트리밍 요청한 종목정보
        m_Subscribed            :   Boolean;                //  스트리밍 요청 여부

        m_pSymbolItem           :   CFNSymbolItem;
        m_pSubscribeSymbolItem  :   CFNSymbolItem;          //  스트리밍 요청한 종목정보

        m_ValueX            : Integer;
        m_UseOPSPrice       : Boolean;

        m_OnChartTraceChange : TFNQChartTraceChange;
        m_OnChange   :   TNotifyEvent;

        function GetEnableChartControl() : Boolean;
        procedure OnHScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: integer);
        procedure OnChartCaptionPaintStage(Sender: TObject; ABuffer: TBitmap32; AStageNum: Cardinal);

        procedure OnChartTracePaintStage(Sender: TObject; ABuffer: TBitmap32; AStageNum: Cardinal);
        procedure WMSize(var Message: TWMSize); message WM_SIZE;

    protected
        procedure MouseMoveHandler(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
        procedure MouseDownHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
        procedure MouseUpHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
        procedure WMMouseLeave(var Message: TWMMouse); message WM_MOUSELEAVE;

    public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy(); override;

        procedure SetSocketManager(p_SocketManager:TObject);
        procedure SetScrollBar(AScrollBar : TScrollBar);
        procedure SetChartCaption(p_ChartCaption:TImgView32);
        procedure SetChartTrace(p_ChartTrace: TImgView32);

        procedure Initialize();
        procedure Finalize();
        procedure Clear;

        procedure OnResize(p_Left:Integer; p_Top:Integer; p_Width:Integer; p_Height:Integer; p_Paint:Boolean);
        procedure SetBound(p_Left:Integer; p_Top:Integer; p_Right:Integer; p_Bottom:Integer);
        procedure RepaintDraw(p_Bitmap:TBitmap32);

        procedure SetSymbolItem(p_SymbolItem:CFNSymbolItem);
        procedure SetTimeFrame(p_Value:Integer);

        procedure SetUseOPSPrice(AValue: Boolean);
        procedure SetColorSetIndex(p_Value:Integer; p_Paint:Boolean=false);
        procedure SetScale(p_Value:Integer; p_Paint:Boolean=false);
        procedure SetTraceVisible(p_Value:Boolean; p_Paint:Boolean=false);
        procedure SetRequestCount(p_Value:Integer);
        procedure SetChartType(p_Type:Integer; p_Paint:Boolean=false);
        procedure SetSetting(p_Value:CFNQSetting);

        procedure OnDataPackage(p_Type:String; p_RequestData:CFNQRequestData; p_DataPackage:CFNDataPackage);
        procedure OnDataStream(p_StreamRecord:CFNStreamRecord);

        function Parse_TR_AC_1000(p_RequestData:CFNQRequestData; p_DataPackage:CFNDataPackage; var p_ChartDataSeries:CFNQStreamChartDataSeries) : Integer;
        procedure Request_TR_AC_1000(p_ClearDrawObject:Boolean);

        procedure SubscribeQuoteData;
        procedure UnsubscribeQuoteData;

        function AddChart(p_Identity:Integer; p_Draw:Boolean=true; p_MaxMinEnlarge:Boolean=true) : Integer;
        procedure DeleteChart(p_Identity:Integer; p_Draw:Boolean=true);
        procedure ChangeChart(p_Identity:Integer; p_Draw:Boolean=true);

        procedure OnZoomIn();
        procedure OnZoomOut();
        procedure OnZoomActual();

        procedure DrawChartCaption();
        procedure DrawTrace(p_ValueX:Integer);
        procedure DrawTraceDate(p_Index:Integer; p_Date: TDateTime);

        function GetTimeFrameIntToLabelStr(nTimeFrame:Integer) : String;

        procedure OnControlPaintStage(Sender: TObject; ABuffer: TBitmap32; AStageNum: Cardinal);

        procedure GetChartMaxMin(var p_Min, p_Max:Double);

        procedure ReEnlarge(p_Value: Integer);

        procedure SetXMaxMin(p_Value: Integer);
        procedure CreateVirualChart;

        procedure SignalTrace(p_ChartIndex : Integer; p_Signal:Integer; p_Start:TDateTime; p_End:TDateTime);
        procedure SignalTraceFromOuterChart(p_ChartIndex, p_Signal, p_Start, p_End, p_Position: Integer);

        procedure ApplySetting;

    published
        property OnChartTraceChange: TFNQChartTraceChange read m_OnChartTraceChange write m_OnChartTraceChange;
        property OnChange : TNotifyEvent read m_OnChange write m_OnChange;

    end;

procedure Register;

implementation

uses
    FNGlobal, FNQChartDefine, FNCMVariable, FNPOTCollection;

procedure Register;
begin
  RegisterComponents('SKQPackage', [CFNQChartControl]);
end;

//---------------------------------------------------------------------------
constructor CFNQChartControl.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);

    m_ChartType         := 4;
    m_PriceBlockType    := 1;
    m_RequestCount      := 1200;
    m_IndicatorNumber   := -1;
    m_Initialized       := false;
    m_FirstStage        := true;

    m_ScrollBar         := NIL;
    m_ChartCaption      := NIL;
    m_ChartTrace        := NIL;

    m_ValueX            := -1;
    m_UseOPSPrice       := false;
end;

//---------------------------------------------------------------------------
destructor CFNQChartControl.Destroy();
begin
    UnsubscribeQuoteData();
    Finalize();
    inherited Destroy();
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.Initialize();
begin
    m_ChartDataManager  := CFNQChartDataManager.Create();
    m_ChartDataManager.OnDataPackageEvent   := OnDataPackage;
    m_ChartDataManager.OnDataStreamEvent   := OnDataStream;

    m_ChartDataSeries   := CFNQStreamChartDataSeries.Create();
    m_LineSeriesCreator := CFNQLineValueSeriesCreator.Create();

    m_ChartBlockManager := CFNQChartBlockManager.Create();
    m_ChartBlockManager.SetChartControl(Self);
    m_ChartBlockManager.SetLayer();

    m_SymbolItem   := CFNSymbolItem.Create();
    m_SubscribeSymbolItem := CFNSymbolItem.Create();

    m_Initialized         := true;
    m_Subscribed        := false;

    with PaintStages[0]^ do
    begin
        if Stage = PST_CLEAR_BACKGND then
            Stage := PST_CUSTOM;
    end;
    OnPaintStage := OnControlPaintStage;
    RepaintMode := rmOptimizer;

    Self.OnMouseMove := MouseMoveHandler;
    Self.OnMouseDown := MouseDownHandler;
    //Self.OnMouseLeave := MouseLeaveHandler;

    OnResize(0, 0, Width, Height, true);
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.Finalize();
begin
    if Assigned(m_ChartDataManager) then
    begin
        m_ChartDataManager.Free();
        m_ChartDataManager := NIL;
    end;

    if Assigned(m_ChartDataSeries) then
    begin
        m_ChartDataSeries.Free();
        m_ChartDataSeries := NIL;
    end;

    if Assigned(m_LineSeriesCreator) then
    begin
        m_LineSeriesCreator.Free();
        m_LineSeriesCreator := NIL;
    end;

    if Assigned(m_ChartBlockManager) then
    begin
        m_ChartBlockManager.Free();
        m_ChartBlockManager := NIL;
    end;

    if Assigned(m_VolumeSeries) then m_VolumeSeries.Free();
    if Assigned(m_SymbolItem) then m_SymbolItem.Free();
    if Assigned(m_SubscribeSymbolItem) then m_SubscribeSymbolItem.Free();

    m_Initialized := false;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.Clear;
begin
    m_ChartDataSeries.Clear;
    m_ChartBlockManager.SetChartDataSeries(m_ChartDataSeries);
    m_ChartBlockManager.ClearChartAll();
    m_ChartBlockManager.RePaint();
    m_PriceSeries := NIL;

    if (m_ChartCaption <> NIL) then
    begin
        m_ChartCaption.Invalidate();
    end;

    m_ValueX := -1;
    if (m_ChartTrace <> NIL) then
    begin
        m_ChartTrace.Refresh;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SetUseOPSPrice(AValue:Boolean);
begin
    m_UseOPSPrice := AValue;
    m_ChartBlockManager.SetUseOPSPrice(m_UseOPSPrice);
    if (m_ChartDataSeries.m_Items.Count > 0) then
    begin
        if (m_PriceSeries <> NIL) then m_PriceSeries.Clear();
        if m_UseOPSPrice then
        begin
            if (m_PriceSeries <> NIL) then m_PriceSeries.Indicator_OPS_Price(m_ChartDataSeries);
        end else
        begin
            if (m_PriceSeries <> NIL) then m_PriceSeries.Indicator_Price(m_ChartDataSeries);
        end;

        if (m_PriceSeries <> NIL) then m_ChartBlockManager.ReCalculator(m_ChartDataSeries, m_PriceSeries);
        m_ChartBlockManager.LayOut();
        m_ChartBlockManager.RangeEnlarge();
        m_ChartBlockManager.RePaint();
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.WMMouseLeave(var Message: TWMMouse);
begin
if (GetEnableChartControl()) then
    begin
         m_ChartBlockManager.OnMouseLeave();
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.WMSize(var Message: TWMSize);
begin
    if (m_Initialized) then
        OnResize(0, 0, Width, Height, true);

    Self.Resize();
end;


//---------------------------------------------------------------------------
procedure CFNQChartControl.SetSocketManager(p_SocketManager:TObject);
begin
    m_SocketManager := CFNSocketManager(p_SocketManager);

    if (m_ChartDataManager <> NIL) then
        m_ChartDataManager.SetSocketManager(m_SocketManager);
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SetColorSetIndex(p_Value:Integer; p_Paint:Boolean = false);
begin
    m_ChartBlockManager.SetColorSetIndex(p_Value, p_Paint);

    DrawChartCaption();
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SetBound(p_Left:Integer; p_Top:Integer; p_Right:Integer; p_Bottom:Integer);
begin
    m_ChartBlockManager.SetBound(p_Left, p_Top, p_Right, p_Bottom);
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.OnResize(p_Left:Integer; p_Top:Integer; p_Width:Integer; p_Height:Integer; p_Paint:Boolean);
begin
    m_ChartBlockManager.OnResize(p_Left, p_Top, p_Width, p_Height, p_Paint);
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.ReEnlarge(p_Value: Integer);
begin
    m_ChartBlockManager.ReEnlarge(p_Value);
    if Assigned(m_OnChange) then m_OnChange(Self);
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SetXMaxMin(p_Value: Integer);
begin
    m_ChartBlockManager.SetXMaxMin(p_Value);
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SignalTrace(p_ChartIndex : Integer; p_Signal: Integer; p_Start, p_End: TDateTime);
var
    f_Index1, f_Index2:Integer;
begin
    if m_ChartDataSeries = NIL then exit;

    f_Index1 := m_ChartDataSeries.SearchByClose(p_Start, true);
    f_Index2 := m_ChartDataSeries.SearchByClose(p_End, true);
    
    m_ChartBlockManager.SignalTrace(p_ChartIndex, p_Signal, f_Index1, f_Index2, -1);
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SignalTraceFromOuterChart(p_ChartIndex, p_Signal, p_Start, p_End, p_Position: Integer);
begin
    if m_ChartDataSeries = NIL then exit;

    m_ChartBlockManager.SignalTraceFromOuterChart(p_ChartIndex, p_Signal, p_Start, p_End, p_Position);
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.RepaintDraw(p_Bitmap:TBitmap32);
begin
    m_ChartBlockManager.Clear();
    m_ChartBlockManager.Draw(p_Bitmap);
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SetSymbolItem(p_SymbolItem:CFNSymbolItem);
begin
    m_SymbolItem.Clone(p_SymbolItem);
    m_pSymbolItem := p_SymbolItem;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SetTimeFrame(p_Value: Integer);
begin
    m_TimeFrame := p_Value;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SetRequestCount(p_Value: Integer);
begin
    m_RequestCount := p_Value;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SetSetting(p_Value: CFNQSetting);
begin
    m_Setting := p_Value;
end;

//---------------------------------------------------------------------------
function CFNQChartControl.Parse_TR_AC_1000(p_RequestData:CFNQRequestData; p_DataPackage: CFNDataPackage; var p_ChartDataSeries:CFNQStreamChartDataSeries) : Integer;
var
    f_DataSet       : CFNDataSet;
    f_Record        : CFNRecord;
    f_Index           : Integer;
    f_RecordCount   : Integer;

    f_Items         : String;
    f_ChartData     : CFNQChartData;

    Year            : Word;
    Month           : Word;
    Day             : Word;
    Hour            : Word;
    Min             : Word;
    Sec             : Word;
    MilSec          : Word;
    f_Success       : Boolean;
    f_NewState      : Boolean;

    f_Symbol        : String;
    f_RecordIndex   : Integer;
    f_RecordList    : TStringList;
    f_FieldList    : TStringList;
begin
    f_NewState := false;

    try
        f_DataSet := p_DataPackage.GetDataSet('output1');
        if Assigned(f_DataSet) then
        begin
            f_RecordCount := f_DataSet.RecordList.Count;
            if (0 < f_RecordCount) then
            begin
                f_Record := CFNRecord(f_DataSet.RecordList.Items[0]);
                if (p_RequestData.m_State = CFNQRequestData.RQ_MAIN_NEW) then
                begin
                    p_ChartDataSeries.Clear();
                    f_NewState := true;
                end else
                begin
                    if (p_RequestData.m_ClearOldData) then
                    begin
						p_ChartDataSeries.Clear();
                        f_NewState := true;
                    end;
                end;

                f_Symbol := f_Record.GetNameToStringValue('SYMBOL');

                if (p_RequestData.m_Symbol = f_Symbol) then
                begin
                    m_ChartDataSeries.m_Country     := p_RequestData.m_Country;
                    m_ChartDataSeries.m_Group       := p_RequestData.m_Group;
                    m_ChartDataSeries.m_Market      := p_RequestData.m_Market;
                    p_ChartDataSeries.m_Symbol 	    := p_RequestData.m_Symbol;
                    p_ChartDataSeries.m_Name        := p_RequestData.m_Name;
                    p_ChartDataSeries.m_TimeFrame	:= m_TimeFrame;
                    p_ChartDataSeries.m_Precision	:= f_Record.GetNameToIntegerValue('PRECISION');
                    f_Success := true;
                end
                else
                begin
                    f_Success := false;
                end;
            end else
            begin
                f_Success := false;
            end;
        end else
        begin
            f_Success := false;
        end;
    except
        f_Success := false;
    end;

    if (not f_Success) then
    begin
        Result := 0;
        exit;
    end;

    f_RecordList := TStringList.Create();
    f_FieldList := TStringList.Create();
    try
        f_DataSet := p_DataPackage.GetDataSet('output2');
        if Assigned(f_DataSet) then
        begin
            f_RecordCount := f_DataSet.RecordList.Count;

            for f_Index := 0 to f_RecordCount - 1 do
            begin
                f_Record := CFNRecord(f_DataSet.RecordList.Items[f_Index]);

                f_RecordList.Clear();
                ExtractStrings(['|'], [], PChar(f_Record.GetNameToStringValue('ITEMS')), f_RecordList);

                for f_RecordIndex := 0 to f_RecordList.Count - 1 do
                begin
                    f_FieldList.Clear;
                    ExtractStrings([','], [], PChar(f_RecordList[f_RecordIndex]), f_FieldList);

                    f_ChartData := CFNQChartData.Create();

                    f_ChartData.m_OpenDateTime  := TFNGlobal.StringToDateTime(f_FieldList[0]);
                    f_ChartData.m_CloseDateTime := TFNGlobal.StringToDateTime(f_FieldList[1]);
                    DecodeDateTime(f_ChartData.m_CloseDateTime, Year, Month, Day, Hour, Min, Sec, MilSec);

                    f_ChartData.m_Year         := Year;
                    f_ChartData.m_Month        := Month;
                    f_ChartData.m_Day          := Day;
                    f_ChartData.m_Hour         := Hour;
                    f_ChartData.m_Min          := Min;
                    f_ChartData.m_Sec          := Sec;

                    f_ChartData.m_OpenPrice    := TFNGlobal.atof(f_FieldList[ 2]);
                    f_ChartData.m_HighPrice    := TFNGlobal.atof(f_FieldList[ 3]);
                    f_ChartData.m_LowPrice     := TFNGlobal.atof(f_FieldList[ 4]);
                    f_ChartData.m_ClosePrice   := TFNGlobal.atof(f_FieldList[ 5]);

                    f_ChartData.m_OpenOPS      := TFNGlobal.atof(f_FieldList[ 6]);
                    f_ChartData.m_HighOPS      := TFNGlobal.atof(f_FieldList[ 7]);
                    f_ChartData.m_LowOPS       := TFNGlobal.atof(f_FieldList[ 8]);
                    f_ChartData.m_CloseOPS     := TFNGlobal.atof(f_FieldList[ 9]);
                    f_ChartData.m_Volume       := TFNGlobal.atof(f_FieldList[10]);

                    if (f_ChartData.m_OpenPrice = 0) then
                        f_ChartData.m_OpenPrice := f_ChartData.m_ClosePrice;
                    if (f_ChartData.m_HighPrice = 0) then
                        f_ChartData.m_HighPrice := f_ChartData.m_ClosePrice;
                    if (f_ChartData.m_LowPrice = 0) then
                        f_ChartData.m_LowPrice := f_ChartData.m_ClosePrice;

                    p_ChartDataSeries.Add(f_ChartData);
                end;
            end;

            Result := f_RecordCount;
        end else
        begin
            Result := 0;
        end;
    except
        Result := 0;
    end;

    f_RecordList.Free;
    f_FieldList.Free;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.CreateVirualChart;
var
     nIndex : Integer;
    f_IndicatorValue : CFNQIndicatorValue;
begin
    m_ChartBlockManager.DeleteChartAll();
    m_ChartBlockManager.Clear();
    m_PriceSeries := NIL;

    m_ChartBlockManager.AddChart(g_IndicatorName[IND_PRICE_NAME]);
    for nIndex := 0 to m_Setting.m_SequenceI.Count - 1 do
    begin
        f_IndicatorValue := CFNQIndicatorValue(m_Setting.m_Indicator.Items[PInteger(m_Setting.m_SequenceI.Items[nIndex])^]);
        m_ChartBlockManager.AddChart(f_IndicatorValue.m_Name);
    end;

    for nIndex := 0 to m_Setting.m_SequenceS.Count - 1 do
    begin
        f_IndicatorValue := CFNQIndicatorValue(m_Setting.m_Indicator.Items[PInteger(m_Setting.m_SequenceS.Items[nIndex])^]);
        m_ChartBlockManager.AddChart(f_IndicatorValue.m_Name);
    end;
    m_ChartBlockManager.SetVisibleXLabel(true);
    m_ChartBlockManager.LayOut();
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.OnDataPackage(p_Type:String; p_RequestData:CFNQRequestData; p_DataPackage:CFNDataPackage);
var
    f_SvcID         : String;
    f_TRCode        : String;
    f_ErrorCode     : String;
    f_MarketCount   : Integer;

    xOldMinIndex, xOldMaxIndex : Integer;
    xNewMinIndex, xNewMaxIndex : Integer;
    szMsg : String;

    f_ChartStartIndex : Integer;
    f_ChartEndIndex : Integer;
    nIndex : Integer;
begin
    if Assigned(p_DataPackage) then
    begin
        f_SvcID     := p_DataPackage.GetServiceID();
        f_TRCode    := p_DataPackage.GetTRCode();
        f_ErrorCode := p_DataPackage.GetErrorCode();

        if CompareStr(f_SvcID, 'SC_ADV_CHART') = 0 then
        begin
            {$REGION '오류처리'}
            if (f_ErrorCode <> 'E00000') then
            begin
                MessageBox(Self.Handle,
                            PWideChar(g_ChartMsgTable[IDS_CMCHART_RECV_ERROR] + ' (' + f_TRCode + ')'#$0A'' + CFNRecord(p_DataPackage.m_ErrorDataSet.RecordList.Items[0]).GetNameToStringValue('err_msg')),
                            PChar(g_ApplicationName),
                            MB_OK or MB_ICONINFORMATION);
                if (p_RequestData.m_State = CFNQRequestData.RQ_MAIN_NEW) then
                begin
                    m_ChartDataSeries.Clear();
                    m_ChartBlockManager.DeleteChartAll();
                    m_ChartBlockManager.RePaint();
                    m_PriceSeries := NIL;
                end;

                exit;
            end;
            {$ENDREGION}

            try
                if CompareStr(f_TRCode, 'TR_0110') = 0 then
                begin
                    case p_RequestData.m_State of
                        CFNQRequestData.RQ_MAIN_NEW :
                        begin

                            {$REGION '신규데이터'}
                            if (0 < Parse_TR_AC_1000(p_RequestData, p_DataPackage, m_ChartDataSeries)) then
                            begin
                                m_SymbolItem.m_Name := m_ChartDataSeries.m_Name;

                                if (m_ChartDataSeries.m_Items.Count > 0) then
                                begin
                                    //:[]
                                    m_ChartBlockManager.DeleteChartAll();
                                    m_ChartBlockManager.Clear();
                                    m_ChartBlock := m_ChartBlockManager.AddChart(g_IndicatorName[IND_PRICE_NAME]);
                                    m_ChartBlock.SetChartDataSeries(m_ChartDataSeries);
                                    m_PriceSeries := NIL;

                                    m_PriceSeries := m_LineSeriesCreator.Creator_Price();
                                    if m_UseOPSPrice then
                                    begin
                                        m_PriceSeries.Indicator_OPS_Price(m_ChartDataSeries);
                                    end else
                                    begin
                                        m_PriceSeries.Indicator_Price(m_ChartDataSeries);
                                    end;
                                    m_PriceSeries.m_Precision := m_ChartDataSeries.m_Precision;
                                    m_PriceSeries.m_Options[0] := m_PriceBlockType;
                                    m_ChartBlock.AddObject(m_PriceSeries);
                                    m_ChartBlockManager.SetChartDataSeries(m_ChartDataSeries);

                                    for nIndex := 0 to m_Setting.m_SequenceO.Count - 1 do
                                    begin
                                        AddChart(PInteger(m_Setting.m_SequenceO.Items[nIndex])^, false, false);
                                    end;

                                    for nIndex := 0 to m_Setting.m_SequenceI.Count - 1 do
                                    begin
                                        AddChart(PInteger(m_Setting.m_SequenceI.Items[nIndex])^, false, false);
                                    end;

                                    for nIndex := 0 to m_Setting.m_SequenceS.Count - 1 do
                                    begin
                                        AddChart(PInteger(m_Setting.m_SequenceS.Items[nIndex])^, false, false);
                                    end;

                                    m_ChartBlockManager.SetVisibleXLabel(true);
                                    m_ChartBlockManager.LayOut();
                                    m_ChartBlockManager.FirstEnlarge(false);

                                    m_ChartBlockManager.RePaint();

                                    if ((p_RequestData.m_XMinDate <> 0) and (p_RequestData.m_XMaxDate <> 0)) then
                                    begin
                                        f_ChartStartIndex := m_ChartDataSeries.SearchByClose3(p_RequestData.m_XMinDate, true);
                                        f_ChartEndIndex := m_ChartDataSeries.SearchByClose2(p_RequestData.m_XMaxDate, true);
                                        m_ChartBlockManager.RangeEnlarge(f_ChartStartIndex, f_ChartEndIndex, true, true);
                                        m_ChartBlockManager.RePaint();
                                    end;

                                    m_FirstStage := false;
                                end else
                                begin
                                    m_ChartDataSeries.Clear();
                                    m_ChartBlockManager.DeleteChartAll();
                                    m_ChartBlockManager.RePaint();
                                    m_PriceSeries := NIL;

                                    m_FirstStage := true;
                                end;

                                SubscribeQuoteData();

                                DrawChartCaption();
                                m_ValueX := m_ChartDataSeries.m_Items.Count - 1;
                                DrawTrace(m_ValueX);

                                m_Setting.m_Symbol      := m_SymbolItem.m_Symbol;
                                m_Setting.m_Name        := m_SymbolItem.m_Name;
                                m_Setting.m_TimeFrame   := m_TimeFrame;

                                if Assigned(m_OnChange) then m_OnChange(Self);
                            end;
                            {$ENDREGION}
                        end;

                        CFNQRequestData.RQ_MAIN_ADD :
                        begin
                            {$REGION '추가데이터'}
                            if (0 < Parse_TR_AC_1000(p_RequestData, p_DataPackage, m_ChartDataSeries)) then
                            begin
                                if (m_ChartDataSeries.m_Items.Count > 0) then
                                begin
                                    m_SymbolItem.m_Name := m_ChartDataSeries.m_Name;

                                    m_PriceSeries.Clear;
                                    if m_UseOPSPrice then
                                    begin
                                        m_PriceSeries.Indicator_OPS_Price(m_ChartDataSeries);
                                    end else
                                    begin
                                        m_PriceSeries.Indicator_Price(m_ChartDataSeries);
                                    end;

                                    m_ChartBlockManager.ReCalculator(m_ChartDataSeries, m_PriceSeries);

                                    xOldMinIndex := m_ChartDataSeries.SearchByClose3(p_RequestData.m_XMinDate, true);
                                    xOldMaxIndex := m_ChartDataSeries.SearchByClose2(p_RequestData.m_XMaxDate, true);
                                    if ((xOldMinIndex < 0) or (xOldMaxIndex < 0)) then
                                    begin
                                        if ((xOldMinIndex < 0) and (xOldMaxIndex < 0)) then
                                        begin
                                            xOldMinIndex := 0;
                                            xOldMaxIndex := m_ChartDataSeries.m_Items.Count - 1;
                                            szMsg := g_ChartMsgTable[IDS_CMCHART_RECV_EMPTY_DATA]   //'해당기간의 날짜와 시간에 해당하는 데이터를 찾을 수 없습니다.#$0A'
                                                    + TFNGlobal.DateToYYYY_MM_DD_HH_MM(p_RequestData.m_XMinDate) + '#$0A'
                                                    + TFNGlobal.DateToYYYY_MM_DD_HH_MM(p_RequestData.m_XMaxDate);
                                            MessageBox(Self.Handle, PWideChar(szMsg), PChar(g_ApplicationName), MB_OK or MB_ICONINFORMATION);

                                        end
                                        else if (xOldMinIndex < 0) then
                                        begin
                                            xOldMinIndex := 0;
                                            szMsg := g_ChartMsgTable[IDS_CMCHART_RECV_EMPTY_DATA]   //'해당기간의 날짜와 시간에 해당하는 데이터를 찾을 수 없습니다.#$0A'
                                                    + TFNGlobal.DateToYYYY_MM_DD_HH_MM(p_RequestData.m_XMinDate);
                                            MessageBox(Self.Handle, PWideChar(szMsg), PChar(g_ApplicationName), MB_OK or MB_ICONINFORMATION);
                                        end
                                        else if (xOldMaxIndex < 0) then
                                        begin
                                            xOldMaxIndex := m_ChartDataSeries.m_Items.Count - 1;
                                            szMsg := g_ChartMsgTable[IDS_CMCHART_RECV_EMPTY_DATA]   //'해당기간의 날짜와 시간에 해당하는 데이터를 찾을 수 없습니다.#$0A'
                                                    + TFNGlobal.DateToYYYY_MM_DD_HH_MM(p_RequestData.m_XMaxDate);
                                            MessageBox(Self.Handle, PWideChar(szMsg), PChar(g_ApplicationName), MB_OK or MB_ICONINFORMATION);
                                        end
                                        else
                                        begin
                                            //
                                        end;
                                    end;

                                    xNewMinIndex := xOldMinIndex + p_RequestData.m_XMinOffset - p_RequestData.m_XDirection;
                                    xNewMaxIndex := xOldMaxIndex + p_RequestData.m_XMaxOffset - p_RequestData.m_XDirection;
                                    if (xNewMinIndex < 0) then
                                        xNewMinIndex := 0;

                                    if (xNewMaxIndex - p_RequestData.m_XMaxOffset > m_ChartDataSeries.m_Items.Count - 1) then
                                        xNewMaxIndex := m_ChartDataSeries.m_Items.Count - 1;

                                    m_ChartBlockManager.RangeEnlarge(xNewMinIndex, xNewMaxIndex, true, true);
                                    m_ChartBlockManager.RePaint();

                                    m_Setting.m_Symbol      := m_SymbolItem.m_Symbol;
                                    m_Setting.m_Name        := m_SymbolItem.m_Name;
                                    m_Setting.m_TimeFrame   := m_TimeFrame;

                                    if Assigned(m_OnChange) then m_OnChange(Self);
                                end;
                            end;
                            {$ENDREGION}
                        end;
                    end;

                end;

            finally
            end;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.OnDataStream(p_StreamRecord:CFNStreamRecord);
var
    f_Symbol : String;
    f_Country : Integer;
    f_Group : Integer;
    f_Market : Integer;

    f_PacketKey : String;

    f_AddCount : Integer;
    f_nTotalAddCount : Integer;
    f_Range : CFNQMaxMin;
    f_DeleteCount : Integer;
    f_DelIdx : Integer;
    f_DelTotalCnt : Integer;
    f_DelCnt : Integer;
begin
    if Assigned(p_StreamRecord) then
    begin
        f_AddCount := 0;
        f_nTotalAddCount := -1;

        f_Country    := p_StreamRecord.GetNameToIntegerValue('COUNTRY_NO');    //국가(0:한국, 1:중국)
        f_Group      := p_StreamRecord.GetNameToIntegerValue('GROUP_NO');    //주식구분(0:지수,1:주식)
        f_Market     := p_StreamRecord.GetNameToIntegerValue('MARKET_NO');    //거래소(0:상해, 1:심첨, 2:홍콩)
        f_Symbol     := p_StreamRecord.GetNameToStringValue('SYMBOL');     //주식 또는 지수의 심벌

        if  (
                (f_Country = m_SymbolItem.m_Country) AND
                (f_Group   = m_SymbolItem.m_Group  ) AND
                (f_Market  = m_SymbolItem.m_Market ) AND
                (f_Symbol  = m_SymbolItem.m_Symbol )
            ) then
        begin
            f_PacketKey := p_StreamRecord.GetPacketKey();

            if 'QUOTE' = f_PacketKey then
            begin
                f_AddCount := m_ChartDataSeries.UpdateStreamQuotData(p_StreamRecord);
                if (f_AddCount >= 0) then
                begin
                     if (f_nTotalAddCount < 0) then
                        f_nTotalAddCount := 0;

                    f_nTotalAddCount := f_nTotalAddCount + f_AddCount;
                end;
            end;
        end;

        if (f_nTotalAddCount >= 0) then
        begin
            f_Range := m_ChartBlockManager.GetMaxMin();
            if (f_nTotalAddCount = 0) then
            begin
                m_ChartBlockManager.UpdateCalculator(m_ChartDataSeries, m_PriceSeries, false);
                m_ChartBlockManager.RePaint();
            end
            else
            begin
                m_ValueX := m_ValueX + f_nTotalAddCount;
                if (m_ChartDataSeries.m_Items.Count > 5000) then
                begin
                    f_DelIdx := 0;
                    f_DelCnt := 0;
                    f_DelTotalCnt := (m_ChartDataSeries.m_Items.Count - 5000) - f_DelIdx;
                    while (f_DelCnt < f_DelTotalCnt) do
                    begin
                        CFNQChartData(m_ChartDataSeries.m_Items.Items[f_DelIdx]).Free();
                        m_ChartDataSeries.m_Items.Delete(f_DelIdx);

                        Inc(f_DelCnt);
                        Dec(m_ValueX);
                    end;

                    m_ChartBlockManager.ReCalculator(m_ChartDataSeries, m_PriceSeries);
                    m_ChartBlockManager.LayOut();
                    m_ChartBlockManager.RangeEnlarge(f_Range.m_XMin + f_nTotalAddCount-f_DelTotalCnt , f_Range.m_XMax + f_nTotalAddCount-f_DelTotalCnt);
                    m_ChartBlockManager.RePaint();
                end else
                begin
                    m_ChartBlockManager.UpdateCalculator(m_ChartDataSeries, m_PriceSeries, true);
                    m_ChartBlockManager.LayOut();
                    m_ChartBlockManager.RangeEnlarge(f_Range.m_XMin + f_nTotalAddCount, f_Range.m_XMax + f_nTotalAddCount);
                    m_ChartBlockManager.RePaint();
                end;
            end;

            m_ChartBlockManager.TraceOnLastTime;
            DrawChartCaption();
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SubscribeQuoteData();
var
    f_POTItem:CFNPOTItem;
begin

    if m_Subscribed then UnsubscribeQuoteData();

    if Assigned(g_POTCollection) then
    begin
        f_POTItem := g_POTCollection.Find(Trunc(TFNGlobal.ServerNow), m_SymbolItem.m_Country, m_SymbolItem.m_Group, m_SymbolItem.m_Market, m_SymbolItem.m_Symbol);
        if Assigned(f_POTItem) then
        begin
            f_POTItem := g_POTCollection.Find(Trunc(TFNGlobal.ServerNow + f_POTItem.m_TimeDiffrence), m_SymbolItem.m_Country, m_SymbolItem.m_Group, m_SymbolItem.m_Market, m_SymbolItem.m_Symbol);
            if Assigned(f_POTItem) then
            begin
                m_ChartDataSeries.SetPOTItem(f_POTItem);
                m_ChartDataSeries.ReadyStream;
            end;
        end;
    end;

    if m_ChartDataManager.SubscribeQuote(m_SymbolItem) then
    begin
        m_SubscribeSymbolItem.Clone(m_SymbolItem);
        m_Subscribed := true;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.UnsubscribeQuoteData();
begin
    if (m_Subscribed) then
    begin
        m_ChartDataManager.UnSubscribeQuote(m_SubscribeSymbolItem);
        m_Subscribed := false;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.Request_TR_AC_1000(p_ClearDrawObject:Boolean);
var
    f_StandDate:TDateTime;
begin

    UnsubscribeQuoteData();
	m_ChartDataManager.Request_TR_AC_1000_Type0(
        m_SymbolItem.m_Country,
        m_SymbolItem.m_Group,
        m_SymbolItem.m_Market,
        m_SymbolItem.m_Symbol,
        m_SymbolItem.m_Name,
        m_TimeFrame,
        m_RequestCount,
        p_ClearDrawObject,
        f_StandDate);
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SetChartType(p_Type:Integer; p_Paint:Boolean=false);
var
    f_MaxMin : Boolean;
    f_ChartBlock : CFNQChartBlock;
    f_ValueArray : CFNQLineValueSeries;
    f_PriceArray : CFNQLineValueSeries;
begin
    f_MaxMin := false;

    if ((p_Type >= 0) and (p_Type <= 2) and (m_ChartType > 2)) then
        f_MaxMin := true;

    m_ChartType := p_Type;
    if (p_Type = 0) then
        m_PriceBlockType := 0
    else if (p_Type = 1) then
        m_PriceBlockType := 2
    else if (p_Type = 2) then
        m_PriceBlockType := 1
    else
        ;

    if (not GetEnableChartControl()) then
        exit;

    if ((p_Type >= 0) and (p_Type <= 2)) then
    begin
        m_ChartBlockManager.Clear();
        m_ChartBlockManager.m_ChartType := CFNQConst.CHART_NORMAL;
        f_ChartBlock := m_ChartBlockManager.FindChart(g_IndicatorName[IND_PRICE_NAME]);
        if (f_ChartBlock <> NIL) then
        begin
            if (m_PriceSeries <> NIL) then m_PriceSeries.m_Options[0] := m_PriceBlockType;
            if (m_PriceSeries <> NIL) then f_ChartBlock.ChangedLineMaxMin(m_PriceSeries);
            f_ChartBlock.RangeEnlarge();
            m_ChartBlockManager.LayOut();
            if (p_Paint) then
            begin
                m_ChartBlockManager.RePaint();
            end;
        end;
        if (f_MaxMin) then
        begin
            m_ChartBlockManager.LayOut();
            m_ChartBlockManager.SetScrollBarPosition();
        end;
    end;

    m_Setting.m_ChartType := p_Type;
end;

//---------------------------------------------------------------------------
function CFNQChartControl.AddChart(p_Identity:Integer; p_Draw:Boolean=true; p_MaxMinEnlarge:Boolean=true) : Integer;
var
    f_rvalue : Integer;
    p_ChartBlock : CFNQChartBlock;
    p_ValueArray : CFNQLineValueSeries;
    p_IndicatorValue : CFNQIndicatorValue;

    f_ADX       : Integer;
    f_ADX_NMA   : Integer;
    f_PDI       : Integer;
    f_MDI       : Integer;
    f_PDMSUM    : Integer;
    f_MDMSUM    : Integer;
    f_TRSUM     : Integer;
    f_PDM       : Integer;
    f_MDM       : Integer;
    f_TR        : Integer;
begin
    f_rvalue := 0;

    p_IndicatorValue := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]);

    if (p_IndicatorValue.m_AddType = 0) then
    begin
        p_ChartBlock := m_ChartBlockManager.FindChart(g_IndicatorName[IND_PRICE_NAME]);
        if (p_ChartBlock <> NIL) AND (m_PriceSeries <> NIL) then
        begin
            p_ValueArray := p_ChartBlock.FindValueArray(p_IndicatorValue.m_Name);
            if (p_ValueArray = NIL) then
            begin
                if (p_IndicatorValue.m_Value = CFNQSetting.IND_ILMOK) then //'일목균형표') then
                begin
                    p_ValueArray := m_LineSeriesCreator.Creator_IMLine();
                    p_ValueArray.m_Precision := m_ChartDataSeries.m_Precision;
                    p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                    p_ValueArray.m_Options[1] := p_IndicatorValue.m_OptionValue[1];
                    p_ValueArray.m_Options[2] := p_IndicatorValue.m_OptionValue[2];
                    p_ValueArray.Indicator_IMLine(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), m_PriceSeries, 1, 2, 3, 0);
                    p_ChartBlock.AddObject(p_ValueArray);
                    if (p_MaxMinEnlarge) then
                        p_ChartBlock.RangeEnlarge();
                    m_ChartBlockManager.SetXExtraGap(Math.Floor(p_IndicatorValue.m_OptionValue[1]));
                end
                else if (p_IndicatorValue.m_Value = CFNQSetting.IND_MA) then //'이동평균선') then
                begin
                    p_ValueArray := m_LineSeriesCreator.Creator_MA();
                    p_ValueArray.m_Precision := m_ChartDataSeries.m_Precision;
                    p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                    p_ValueArray.m_Options[1] := p_IndicatorValue.m_OptionValue[1];
                    p_ValueArray.m_Options[2] := p_IndicatorValue.m_OptionValue[2];
                    p_ValueArray.m_Options[3] := p_IndicatorValue.m_OptionValue[3];
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[0]), m_PriceSeries, 3, 0);
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[1]), m_PriceSeries, 3, 1);
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[2]), m_PriceSeries, 3, 2);
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[3]), m_PriceSeries, 3, 3);
                    p_ChartBlock.AddObject(p_ValueArray);
                    if (p_MaxMinEnlarge) then
                        p_ChartBlock.RangeEnlarge();
                end
                else if (p_IndicatorValue.m_Value = CFNQSetting.IND_NET) then
                begin
                    p_ValueArray := m_LineSeriesCreator.Creator_NET(Math.Floor(p_IndicatorValue.m_OptionValue[2]));
                    p_ValueArray.m_Precision := m_ChartDataSeries.m_Precision;
                    p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                    p_ValueArray.m_Options[1] := p_IndicatorValue.m_OptionValue[1];
                    p_ValueArray.m_Options[2] := p_IndicatorValue.m_OptionValue[2];
                    p_ValueArray.Indicator_NET(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), m_PriceSeries, 3, 0);
                    p_ChartBlock.AddObject(p_ValueArray);
                    if (p_MaxMinEnlarge) then
                        p_ChartBlock.RangeEnlarge();
                end
                else if (p_IndicatorValue.m_Value = CFNQSetting.IND_ENVELOP) then
                begin
                    p_ValueArray := m_LineSeriesCreator.Creator_Envelope();
                    p_ValueArray.m_Precision := m_ChartDataSeries.m_Precision;
                    p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                    p_ValueArray.m_Options[1] := p_IndicatorValue.m_OptionValue[1];
                    p_ValueArray.Indicator_Envelope(Math.Floor(p_ValueArray.m_Options[0]), p_ValueArray.m_Options[1], m_PriceSeries, 3, 0);
                    p_ChartBlock.AddObject(p_ValueArray);
                    if (p_MaxMinEnlarge) then
                        p_ChartBlock.RangeEnlarge();
                end
                else if (p_IndicatorValue.m_Value = CFNQSetting.IND_BB) then
                begin
                    p_ValueArray := m_LineSeriesCreator.Creator_BBand();
                    p_ValueArray.m_Precision := m_ChartDataSeries.m_Precision;
                    p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                    p_ValueArray.Indicator_BBand(Math.Floor(p_ValueArray.m_Options[0]), 2, m_PriceSeries, 3, 0);
                    p_ChartBlock.AddObject(p_ValueArray);
                    if (p_MaxMinEnlarge) then
                        p_ChartBlock.RangeEnlarge();
                end
                else if (p_IndicatorValue.m_Value = CFNQSetting.IND_SAR) then
                begin
                    p_ValueArray := m_LineSeriesCreator.Creator_SAR();
                    p_ValueArray.m_Precision := m_ChartDataSeries.m_Precision;
                    p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                    p_ValueArray.Indicator_SAR(p_ValueArray.m_Options[0], m_PriceSeries, 1, 2, 3, 0);
                    p_ChartBlock.AddObject(p_ValueArray);
                    if (p_MaxMinEnlarge) then
                        p_ChartBlock.RangeEnlarge();
                end
                else if (p_IndicatorValue.m_Value = CFNQSetting.IND_MAMULOVERLAY) then
                begin
                    p_ValueArray := m_LineSeriesCreator.Creator_MamulOverlay();
                    p_ValueArray.m_Precision := m_ChartDataSeries.m_Precision;
                    p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                    p_ChartBlock.AddObject(p_ValueArray);
                    if (p_MaxMinEnlarge) then
                        p_ChartBlock.RangeEnlarge();
                end
                else if (p_IndicatorValue.m_Value = CFNQSetting.IND_OVERLAY_OPS) then
                begin
                    if m_UseOPSPrice then
                    begin
                        p_ValueArray := m_LineSeriesCreator.Creator_PRICE_AT_OPS();
                        p_ValueArray.m_Precision := m_ChartDataSeries.m_Precision;
                        p_ValueArray.Indicator_Close(m_ChartDataSeries);
                    end else
                    begin
                        p_ValueArray := m_LineSeriesCreator.Creator_OPS();
                        p_ValueArray.m_Precision := m_ChartDataSeries.m_Precision+2;
                        p_ValueArray.Indicator_OPS(m_ChartDataSeries);
                    end;
                    p_ChartBlock.AddObject(p_ValueArray);
                    if (p_MaxMinEnlarge) then p_ChartBlock.RangeEnlarge();
                end
                else if (p_IndicatorValue.m_Value = CFNQSetting.IND_OVERLAY_OPSIGUK) then
                begin
                    p_ValueArray := m_LineSeriesCreator.Creator_OPS_IGUK();
                    p_ValueArray.Indicator_OPS_IGUK(m_ChartDataSeries);
                    p_ChartBlock.AddObject(p_ValueArray);
                    if (p_MaxMinEnlarge) then
                        p_ChartBlock.RangeEnlarge();
                end
                else if (p_IndicatorValue.m_Value = CFNQSetting.IND_OVERLAY_OPSIGUK2) then
                begin
                    p_ValueArray := m_LineSeriesCreator.Creator_OPS_IGUK2();
                    p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                    p_ValueArray.Indicator_OPS_IGUK2(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries);
                    p_ChartBlock.AddObject(p_ValueArray);
                    if (p_MaxMinEnlarge) then
                        p_ChartBlock.RangeEnlarge();
                end
                else if (p_IndicatorValue.m_Value = CFNQSetting.IND_OVERLAY_OPSSTDDEV) then
                begin
                    p_ValueArray := m_LineSeriesCreator.Creator_OPS_STD();
                    p_ValueArray.m_Precision := m_ChartDataSeries.m_Precision;
                    p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                    p_ValueArray.Indicator_OPS_STD(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries);
                    p_ChartBlock.AddObject(p_ValueArray);
                    if (p_MaxMinEnlarge) then
                        p_ChartBlock.RangeEnlarge();
                end
                else if (p_IndicatorValue.m_Value = CFNQSetting.IND_OVERLAY_OPSREL) then
                begin
                    p_ValueArray := m_LineSeriesCreator.Creator_OPS_REL();
                    p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                    p_ValueArray.Indicator_OPS_REL(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries);
                    p_ChartBlock.AddObject(p_ValueArray);
                    if (p_MaxMinEnlarge) then
                        p_ChartBlock.RangeEnlarge();
                end;

                if (p_Draw) then
                begin
                    m_ChartBlockManager.RePaint();
                end;

                f_rvalue := 1;
            end
            else
                f_rvalue := -1;
        end;
    end
    else
    begin
        f_ADX       := 0;
        f_ADX_NMA   := 1;
        f_PDI       := 2;
        f_MDI       := 3;
        f_PDMSUM    := 4;
        f_MDMSUM    := 5;
        f_TRSUM     := 6;
        f_PDM       := 7;
        f_MDM       := 8;
        f_TR        := 9;

        p_ChartBlock := m_ChartBlockManager.FindChart(p_IndicatorValue.m_Name);
        if ((p_ChartBlock = NIL) and (m_PriceSeries <> NIL)) then
        begin
            if (p_IndicatorValue.m_Value = CFNQSetting.IND_MACD) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_MACD();
                p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                p_ValueArray.m_Options[1] := p_IndicatorValue.m_OptionValue[1];
                p_ValueArray.m_Options[2] := p_IndicatorValue.m_OptionValue[2];
                p_ValueArray.Indicator_MACD(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), m_PriceSeries, 3, 0);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_ADX) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_ADX();
                p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                p_ValueArray.m_Options[1] := p_IndicatorValue.m_OptionValue[1];
                p_ValueArray.m_Options[2] := p_IndicatorValue.m_OptionValue[2];
                p_ValueArray.Indicator_TrueRange(m_PriceSeries, 1, 2, 3, f_TR);
                p_ValueArray.Indicator_PMDM(m_PriceSeries, 1, 2, 3, f_PDM);
                p_ValueArray.Indicator_PMDI(Math.Floor(p_ValueArray.m_Options[0]), p_ValueArray, f_PDM, f_PDI);
                p_ValueArray.Indicator_ADX(Math.Floor(p_ValueArray.m_Options[1]), p_ValueArray, f_PDI, f_MDI, f_ADX);
                p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[2]), p_ValueArray, f_ADX, f_ADX_NMA);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_TRIX) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_TRIX();
                p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                p_ValueArray.m_Options[1] := p_IndicatorValue.m_OptionValue[1];
                p_ValueArray.Indicator_TRIX(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), m_PriceSeries, 3, 0);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_FASTSTC) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_FastSTC();
                p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                p_ValueArray.m_Options[1] := p_IndicatorValue.m_OptionValue[1];
                p_ValueArray.Indicator_FastSTC(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), m_PriceSeries, 1, 2, 3, 0);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_SLOWSTC) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_SlowSTC();
                p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                p_ValueArray.m_Options[1] := p_IndicatorValue.m_OptionValue[1];
                p_ValueArray.m_Options[2] := p_IndicatorValue.m_OptionValue[2];
                p_ValueArray.Indicator_SlowSTC(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), m_PriceSeries, 1, 2, 3, 0);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_RSI) then //'RSI') then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_RSI();
                p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                p_ValueArray.m_Options[1] := p_IndicatorValue.m_OptionValue[1];
                p_ValueArray.Indicator_RSI(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), m_PriceSeries, 3, 0);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_OBV) then //'OBV') then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_OBV();
                p_ValueArray.Indicator_OBV(m_PriceSeries, 3, m_PriceSeries, 4, 0);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_VR) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_VR();
                p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                p_ValueArray.Indicator_VR(Math.Floor(p_ValueArray.m_Options[0]), m_PriceSeries, 3, m_PriceSeries, 4, 0);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_DMI) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_DMI();
                p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                p_ValueArray.Indicator_TrueRange(m_PriceSeries, 1, 2, 3, f_TR - 2);
                p_ValueArray.Indicator_PMDM(m_PriceSeries, 1, 2, 3, f_PDM - 2);
                p_ValueArray.Indicator_PMDI(Math.Floor(p_ValueArray.m_Options[0]), p_ValueArray, f_PDM - 2, f_PDI - 2);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_PSY) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_PSY();
                p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                p_ValueArray.Indicator_PSY(Math.Floor(p_ValueArray.m_Options[0]), m_PriceSeries, 3, 0);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_CCI) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_CCI();
                p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                p_ValueArray.Indicator_CCI(Math.Floor(p_ValueArray.m_Options[0]), m_PriceSeries, 1, 2, 3, 0);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_PMAO) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_PMAO();
                p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                p_ValueArray.m_Options[1] := p_IndicatorValue.m_OptionValue[1];
                p_ValueArray.Indicator_PMAO(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), m_PriceSeries, 3, 0);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_SONAR) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_SONAR();
                p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                p_ValueArray.m_Options[1] := p_IndicatorValue.m_OptionValue[1];
                p_ValueArray.m_Options[2] := p_IndicatorValue.m_OptionValue[2];
                p_ValueArray.Indicator_SONA(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), m_PriceSeries, 3, 0);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_VOLUME) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_Volume();
                p_ValueArray.Indicator_Volume(m_ChartDataSeries);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ValueArray.m_Precision := 0;
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_ROC) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_ROC();
                p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                p_ValueArray.Indicator_ROC(Math.Floor(p_ValueArray.m_Options[0]), m_PriceSeries, 3, 0);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_WILLIAM) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_WilliamsR();
                p_ValueArray.m_Options[0] := p_IndicatorValue.m_OptionValue[0];
                p_ValueArray.m_Options[1] := p_IndicatorValue.m_OptionValue[1];
                p_ValueArray.Indicator_WilliamsR(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), m_PriceSeries, 1, 2, 3, 0);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_OPS) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_OPS();
                p_ValueArray.m_Precision := m_ChartDataSeries.m_Precision+2;
                p_ValueArray.Indicator_OPS(m_ChartDataSeries);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_OPSIGUK) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_OPS_IGUK();
                p_ValueArray.Indicator_OPS_IGUK(m_ChartDataSeries);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_OPSIGUK2) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_OPS_IGUK2();
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.Indicator_OPS_IGUK2(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_OPSSTDDEV) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_OPS_STD();
                p_ValueArray.m_Precision := m_ChartDataSeries.m_Precision;
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.Indicator_OPS_STD(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end
            else if (p_IndicatorValue.m_Value = CFNQSetting.IND_OPSREL) then
            begin
                p_ValueArray := m_LineSeriesCreator.Creator_OPS_REL();
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.Indicator_OPS_REL(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries);
                p_ChartBlock := m_ChartBlockManager.AddChart(p_IndicatorValue.m_Name);
                p_ChartBlock.AddObject(p_ValueArray);
            end

            else
            begin
                f_rvalue := -1;
            end;

            if (f_rvalue <> -1) then
            begin
                m_ChartBlockManager.SetVisibleXLabel(m_ChartBlockManager.GetVisibleXLabel());
                if (p_MaxMinEnlarge) then
                begin
                    m_ChartBlockManager.LayOut();
                    m_ChartBlockManager.RangeEnlarge();
                end;

                if (p_Draw) then
                begin
                    m_ChartBlockManager.RePaint();
                end;
            end;

            f_rvalue := 1;
        end
        else
        begin
            f_rvalue := -1;
        end;
    end;

end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.OnControlPaintStage(Sender: TObject; ABuffer: TBitmap32; AStageNum: Cardinal);
begin
    m_ChartBlockManager.Draw(ABuffer);
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.OnChartCaptionPaintStage(Sender: TObject; ABuffer: TBitmap32; AStageNum: Cardinal);
var
    f_ColorSet  : CFNQColorSet;
    PenColor    : TColor32;
    FontColor   : TColor32;
    FontColorUpDown : TColor32;

    f_TextWidth : Integer;
    f_TextHeight : Integer;
    f_X : Integer;
    f_Y : Integer;
    f_CtrlWidth     : Integer;
    f_CtrlHeight    : Integer;
    f_Label         : String;
    f_XOffset       : Integer;

    f_ChartData     : CFNQChartData;
    f_PreClosePrice : Double;
    f_ChangePrice   : Double;
    f_ChangeRate   : Double;
begin
    f_PreClosePrice := -1.0;
    f_ChangePrice   := -1.0;
    f_ChangeRate    := -1.0;

    f_ColorSet := m_ChartBlockManager.GetColorSet();

    ABuffer.Clear(f_ColorSet.m_Color[CFNQColorSet.CAPTION_BACKGROUND_COLOR]);

        PenColor := f_ColorSet.m_Color[CFNQColorSet.AXIS_COLOR];
        PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));

        FontColor := f_ColorSet.m_Color[CFNQColorSet.CAPTION_FIELDVALUE_TEXT_COLOR];
        FontColor := SetAlpha(FontColor, TFNGlobal.GetAlphaValue(100));

        //라인 칼라 설정
        ABuffer.PenColor := PenColor;

        ABuffer.Font.Name := CFNQColorSet.NUMBER_FONT_FAMILY;
        ABuffer.Font.Size := CFNQColorSet.NUMBER_FONT_SMALLSIZE;
        ABuffer.Font.Style := [];
        ABuffer.Font.Color := FontColor;

        f_XOffset       := 4;
        f_CtrlWidth     := m_ChartCaption.Width;
        f_CtrlHeight    := m_ChartCaption.Height;


    if (m_SymbolItem.m_Name <> '') then
    begin
        //종목
        FontColor := $00333333;
        FontColor := SetAlpha(FontColor, TFNGlobal.GetAlphaValue(100));
        ABuffer.Font.Color := FontColor;
        ABuffer.Font.Style := [fsBold];
        f_Label         := m_SymbolItem.m_Name + ' (' + m_SymbolItem.m_Symbol + ')';
        f_TextWidth     := ABuffer.TextWidth(f_Label);
        f_TextHeight    := ABuffer.TextHeight(f_Label);
        f_X             := f_XOffset;
        f_Y             := Math.Floor((f_CtrlHeight-f_TextHeight)/2);
        ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);
    end;
    FontColor := f_ColorSet.m_Color[CFNQColorSet.CAPTION_FIELDVALUE_TEXT_COLOR];
    FontColor := SetAlpha(FontColor, TFNGlobal.GetAlphaValue(100));

    ABuffer.Font.Name := CFNQColorSet.NUMBER2_FONT_FAMILY;
    ABuffer.Font.Size := CFNQColorSet.NUMBER2_FONT_SMALLSIZE2;
    ABuffer.Font.Style := [];
    ABuffer.Font.Color := FontColor;
    ABuffer.Font.Style := [];

    if GetEnableChartControl() then
    begin

        f_ChartData     := CFNQChartData(m_ChartDataSeries.m_Items[m_ChartDataSeries.m_Items.Count-1]);
        if (m_ChartDataSeries.m_Items.Count > 0) then
        begin
            if (m_ChartDataSeries.m_Items.Count > 1) then
                f_PreClosePrice := CFNQChartData(m_ChartDataSeries.m_Items[m_ChartDataSeries.m_Items.Count-2]).m_ClosePrice;
        end;

        if (f_PreClosePrice <> 0) then
        begin
            f_ChangePrice   := f_ChartData.m_ClosePrice - f_PreClosePrice;
            f_ChangeRate    := (f_ChangePrice / f_PreClosePrice) * 100.0;
        end
        else
        begin
            f_ChangePrice   := 0;
            f_ChangeRate    := 0;
        end;

        //타임프레임
        f_X             := f_X + f_TextWidth + f_XOffset;
        f_Label         := GetTimeFrameIntToLabelStr(m_TimeFrame);
        f_TextWidth     := ABuffer.TextWidth(f_Label);
        f_TextHeight    := ABuffer.TextHeight(f_Label);
        f_Y             := ((f_CtrlHeight-f_TextHeight) div 2);
        ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);

        //일자
        f_X             := f_X + f_TextWidth + f_XOffset;
        f_Y             := f_Y;
        f_Label         := TFNGlobal.DateToYYYY_MM_DD(f_ChartData.m_Year, f_ChartData.m_Month, f_ChartData.m_Day);
        if (9000 < m_TimeFrame) then
        begin
            f_Label := f_Label + ' ' + TFNGlobal.TimeToHH_MM_SS(f_ChartData.m_Hour, f_ChartData.m_Min, f_ChartData.m_Sec);
        end else
        if (360 > m_TimeFrame) then
        begin
            f_Label := f_Label + ' ' + TFNGlobal.TimeToHH_MM(f_ChartData.m_Hour, f_ChartData.m_Min);
        end;
        f_TextWidth     := ABuffer.TextWidth(f_Label);
        f_TextHeight    := ABuffer.TextHeight(f_Label);
        ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);

        //라인
        ABuffer.MoveTo((f_X + f_TextWidth + f_XOffset), f_Y);
        ABuffer.LineToAS((f_X + f_TextWidth + f_XOffset), f_Y + f_TextHeight);
        f_X             := f_X + f_XOffset;

        //OPS
        f_X             := f_X + f_TextWidth + f_XOffset;
        f_Y             := f_Y;
        f_Label         := '오메가' + ':' + TFNGlobal.NumberToString(f_ChartData.m_CloseOPS, m_ChartDataSeries.m_Precision);
        f_TextWidth     := ABuffer.TextWidth(f_Label);
        f_TextHeight    := ABuffer.TextHeight(f_Label);
        ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);


        //종가
        f_X             := f_X + f_TextWidth + f_XOffset;
        f_Y             := f_Y;
        f_Label         := g_ChartText[CT_CAPTION_CLOSE_PRICE] + ':' ;
        f_TextWidth     := ABuffer.TextWidth(f_Label);
        f_TextHeight    := ABuffer.TextHeight(f_Label);
        ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);


        ABuffer.Font.Style := [fsBold];
        //종가
        f_X             := f_X + f_TextWidth + f_XOffset;
        f_Y             := f_Y;
        f_Label         := TFNGlobal.NumberToString(f_ChartData.m_ClosePrice, m_ChartDataSeries.m_Precision);
        f_TextWidth     := ABuffer.TextWidth(f_Label);
        f_TextHeight    := ABuffer.TextHeight(f_Label);
        ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);
        ABuffer.Font.Style := [];

        //시가
        f_X             := f_X + f_TextWidth + f_XOffset;
        f_Y             := f_Y;
        f_Label         := g_ChartText[CT_CAPTION_OPEN_PRICE] + ':' + TFNGlobal.NumberToString(f_ChartData.m_OpenPrice, m_ChartDataSeries.m_Precision);
        f_TextWidth     := ABuffer.TextWidth(f_Label);
        f_TextHeight    := ABuffer.TextHeight(f_Label);
        ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);

        //고가
        f_X             := f_X + f_TextWidth + f_XOffset;
        f_Y             := f_Y;
        f_Label         := g_ChartText[CT_CAPTION_HIGHT_PRICE] + ':' + TFNGlobal.NumberToString(f_ChartData.m_HighPrice, m_ChartDataSeries.m_Precision);
        f_TextWidth     := ABuffer.TextWidth(f_Label);
        f_TextHeight    := ABuffer.TextHeight(f_Label);
        ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);

        //저가
        f_X             := f_X + f_TextWidth + f_XOffset;
        f_Y             := f_Y;
        f_Label         := g_ChartText[CT_CAPTION_LOW_PRICE] + ':' + TFNGlobal.NumberToString(f_ChartData.m_LowPrice, m_ChartDataSeries.m_Precision);
        f_TextWidth     := ABuffer.TextWidth(f_Label);
        f_TextHeight    := ABuffer.TextHeight(f_Label);
        ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);
(*
        //가격▲ ▼
        if (f_ChangePrice > 0) then
        begin
            f_Label := '+';
            FontColorUpDown := f_ColorSet.m_Color[CFNQColorSet.TEXT_UP_LINE];
        end
        else if (f_ChangePrice < 0) then
        begin
            f_Label := '';
            FontColorUpDown := f_ColorSet.m_Color[CFNQColorSet.TEXT_DN_LINE];
        end
        else
        begin
            f_Label := '=';
            FontColorUpDown := f_ColorSet.m_Color[CFNQColorSet.TEXT_EQ_LINE];
        end;
        FontColorUpDown := SetAlpha(FontColorUpDown, TFNGlobal.GetAlphaValue(100));

        f_X             := f_X + f_TextWidth + f_XOffset;
        f_Y             := f_Y;
        f_Label         := f_Label + TFNGlobal.NumberToString(f_ChangePrice, m_ChartDataSeries.m_Precision);
        f_TextWidth     := ABuffer.TextWidth(f_Label);
        f_TextHeight    := ABuffer.TextHeight(f_Label);
        ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColorUpDown);

        //퍼센트
        f_X             := f_X + f_TextWidth + f_XOffset;
        f_Y             := f_Y;
        f_Label         := TFNGlobal.NumberToString(f_ChangeRate, 2) + '%';
        f_TextWidth     := ABuffer.TextWidth(f_Label);
        f_TextHeight    := ABuffer.TextHeight(f_Label);
        ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColorUpDown);
*)
        //거래량
        f_X             := f_X + f_TextWidth + f_XOffset;
        f_Y             := f_Y;
        f_Label         := g_ChartText[CT_CAPTION_VOLUME] + ' ' + TFNGlobal.NumberToString(f_ChartData.m_Volume, 0);
        f_TextWidth     := ABuffer.TextWidth(f_Label);
        f_TextHeight    := ABuffer.TextHeight(f_Label);
        ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.OnChartTracePaintStage(Sender: TObject; ABuffer: TBitmap32; AStageNum: Cardinal);
var
    f_ColorSet  : CFNQColorSet;
    PenColor    : TColor32;
    FontColor   : TColor32;
    FontColorUpDown : TColor32;

    f_TextWidth : Integer;
    f_ItemWidth : Integer;
    f_TextHeight : Integer;
    f_X : Integer;
    f_Y : Integer;
    f_CtrlWidth     : Integer;
    f_CtrlHeight    : Integer;
    f_Label         : String;
    f_Text        : String;
    f_XOffset       : Integer;

    f_ChartData     : CFNQChartData;
    f_PreClosePrice : Double;
    f_ChangePrice   : Double;
    f_ChangeRate   : Double;
begin

    f_PreClosePrice := -1.0;
    f_ChangePrice   := -1.0;
    f_ChangeRate    := -1.0;

    f_ColorSet := m_ChartBlockManager.GetColorSet();

    ABuffer.Clear(f_ColorSet.m_Color[CFNQColorSet.CHART_BACKGROUND_COLOR]);

    if GetEnableChartControl() then
    begin
        PenColor := f_ColorSet.m_Color[CFNQColorSet.AXIS_COLOR];
        PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));

        FontColor := f_ColorSet.m_Color[CFNQColorSet.CAPTION_FIELDVALUE_TEXT_COLOR];
        FontColor := SetAlpha(FontColor, TFNGlobal.GetAlphaValue(100));

        //라인 칼라 설정
        ABuffer.PenColor := PenColor;

        //폰트 설정
        ABuffer.Font.Name := CFNQColorSet.NUMBER2_FONT_FAMILY;
        ABuffer.Font.Size := CFNQColorSet.NUMBER2_FONT_SMALLSIZE2;
        ABuffer.Font.Style := [];
        ABuffer.Font.Color := FontColor;


        if (m_ValueX >= 0) and (m_ValueX < m_ChartDataSeries.m_Items.Count) then
        begin

            f_ChartData     := CFNQChartData(m_ChartDataSeries.m_Items[m_ValueX]);
            if (m_ValueX > 1) then
            begin
                f_PreClosePrice := CFNQChartData(m_ChartDataSeries.m_Items[m_ValueX-1]).m_ClosePrice;
            end;

            if (f_PreClosePrice <> 0) then
            begin
                f_ChangePrice   := f_ChartData.m_ClosePrice - f_PreClosePrice;
                f_ChangeRate    := (f_ChangePrice / f_PreClosePrice) * 100.0;
            end
            else
            begin
                f_ChangePrice   := 0;
                f_ChangeRate    := 0;
            end;

            f_XOffset       := 4;
            f_CtrlWidth     := m_ChartTrace.Width;
            f_CtrlHeight    := m_ChartTrace.Height;

            //일자
            f_Label         := TFNGlobal.DateToYYYY_MM_DD(f_ChartData.m_Year, f_ChartData.m_Month, f_ChartData.m_Day);
            if (9000 < m_TimeFrame) then
            begin
                f_Label := f_Label + ' ' + TFNGlobal.TimeToHH_MM_SS(f_ChartData.m_Hour, f_ChartData.m_Min, f_ChartData.m_Sec);
            end else
            if (360 > m_TimeFrame) then
            begin
                f_Label := f_Label + ' ' + TFNGlobal.TimeToHH_MM(f_ChartData.m_Hour, f_ChartData.m_Min);
            end;

            f_TextWidth     := ABuffer.TextWidth(f_Label);
            f_TextHeight    := ABuffer.TextHeight(f_Label);
            f_X             := f_XOffset;
            f_Y             := Math.Floor((f_CtrlHeight-f_TextHeight)/2);
            ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);

            //라인
            ABuffer.MoveTo((f_X + f_TextWidth + f_XOffset), f_Y);
            ABuffer.LineToAS((f_X + f_TextWidth + f_XOffset), f_Y + f_TextHeight);
            f_X             := f_X + f_XOffset;

            //OPS
            f_X             := f_X + f_TextWidth + f_XOffset;
            f_Y             := f_Y;
            f_Label         := '오메가' + ':' + TFNGlobal.NumberToString(f_ChartData.m_CloseOPS, m_ChartDataSeries.m_Precision);

            f_TextWidth     := ABuffer.TextWidth(f_Label);
            f_TextHeight    := ABuffer.TextHeight(f_Label);
            ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);

            //종가
            f_X             := f_X + f_TextWidth + f_XOffset;
            f_Y             := f_Y;
            f_Label         := g_ChartText[CT_CAPTION_CLOSE_PRICE] + ':';
            f_TextWidth     := ABuffer.TextWidth(f_Label);
            f_TextHeight    := ABuffer.TextHeight(f_Label);
            ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);

            ABuffer.Font.Style := [fsBold];
            //종가
            f_X             := f_X + f_TextWidth + f_XOffset;
            f_Y             := f_Y;
            f_Label         := TFNGlobal.NumberToString(f_ChartData.m_ClosePrice, m_ChartDataSeries.m_Precision);
            f_TextWidth     := ABuffer.TextWidth(f_Label);
            f_TextHeight    := ABuffer.TextHeight(f_Label);
            ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);
            ABuffer.Font.Style := [];

            //시가
            f_X             := f_X + f_TextWidth + f_XOffset;
            f_Y             := f_Y;
            f_Label         := g_ChartText[CT_CAPTION_OPEN_PRICE] + ':' + TFNGlobal.NumberToString(f_ChartData.m_OpenPrice, m_ChartDataSeries.m_Precision);
            f_TextWidth     := ABuffer.TextWidth(f_Label);
            f_TextHeight    := ABuffer.TextHeight(f_Label);
            ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);

            //고가
            f_X             := f_X + f_TextWidth + f_XOffset;
            f_Y             := f_Y;
            f_Label         := g_ChartText[CT_CAPTION_HIGHT_PRICE] + ':' + TFNGlobal.NumberToString(f_ChartData.m_HighPrice, m_ChartDataSeries.m_Precision);
            f_TextWidth     := ABuffer.TextWidth(f_Label);
            f_TextHeight    := ABuffer.TextHeight(f_Label);
            ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);

            //저가
            f_X             := f_X + f_TextWidth + f_XOffset;
            f_Y             := f_Y;
            f_Label         := g_ChartText[CT_CAPTION_LOW_PRICE] + ':' + TFNGlobal.NumberToString(f_ChartData.m_LowPrice, m_ChartDataSeries.m_Precision);
            f_TextWidth     := ABuffer.TextWidth(f_Label);
            f_TextHeight    := ABuffer.TextHeight(f_Label);
            ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);
(*

            //가격▲ ▼
            if (f_ChangePrice > 0) then
            begin
                f_Label := '+';
                FontColorUpDown := f_ColorSet.m_Color[CFNQColorSet.TEXT_UP_LINE];
            end
            else if (f_ChangePrice < 0) then
            begin
                f_Label := '';
                FontColorUpDown := f_ColorSet.m_Color[CFNQColorSet.TEXT_DN_LINE];
            end
            else
            begin
                f_Label := '=';
                FontColorUpDown := f_ColorSet.m_Color[CFNQColorSet.TEXT_EQ_LINE];
            end;
            FontColorUpDown := SetAlpha(FontColorUpDown, TFNGlobal.GetAlphaValue(100));

            f_X             := f_X + f_TextWidth + f_XOffset;
            f_Y             := f_Y;
            f_Text         := TFNGlobal.NumberToString(f_ChartData.m_ClosePrice, m_ChartDataSeries.m_Precision);
            f_TextWidth     := ABuffer.TextWidth('+' + f_Text);

            f_Label         := f_Label + TFNGlobal.NumberToString(f_ChangePrice, m_ChartDataSeries.m_Precision);
            f_ItemWidth     := ABuffer.TextWidth(f_Label);
            f_TextHeight    := ABuffer.TextHeight(f_Label);
            ABuffer.RenderText(f_X+f_TextWidth - f_ItemWidth, f_Y, f_Label, 0, FontColorUpDown);

            //퍼센트
            f_X             := f_X + f_TextWidth + f_XOffset;
            f_Y             := f_Y;
            f_Label         := TFNGlobal.NumberToString(f_ChangeRate, 2) + '%';
            f_TextWidth     := ABuffer.TextWidth('+000.00%');
            f_ItemWidth     := ABuffer.TextWidth(f_Label);
            f_TextHeight    := ABuffer.TextHeight(f_Label);
            ABuffer.RenderText(f_X+f_TextWidth - f_ItemWidth, f_Y, f_Label, 0, FontColorUpDown);
*)
            //거래량
            f_X             := f_X + f_TextWidth + f_XOffset;
            f_Y             := f_Y;
            f_Label         := g_ChartText[CT_CAPTION_VOLUME] + ' ' + TFNGlobal.NumberToString(f_ChartData.m_Volume, 0);
            f_TextWidth     := ABuffer.TextWidth(f_Label);
            f_TextHeight    := ABuffer.TextHeight(f_Label);
            ABuffer.RenderText(f_X, f_Y, f_Label, 0, FontColor);
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SetScrollBar(AScrollBar : TScrollBar);
begin
    m_ScrollBar := AScrollBar;
    m_ScrollBar.LargeChange := 30;
    m_ScrollBar.SmallChange := 1;
    m_ScrollBar.PageSize := 0;

    m_ScrollBar.OnScroll := OnHScroll;
    m_ChartBlockManager.SetScrollBar(m_ScrollBar);
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SetChartCaption(p_ChartCaption:TImgView32);
begin
    m_ChartCaption := p_ChartCaption;
    with m_ChartCaption.PaintStages[0]^ do
    begin
        if Stage = PST_CLEAR_BACKGND then
            Stage := PST_CUSTOM;
    end;
    m_ChartCaption.OnPaintStage := OnChartCaptionPaintStage;
    m_ChartCaption.RepaintMode := rmOptimizer;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SetChartTrace(p_ChartTrace:TImgView32);
begin
    m_ChartTrace := p_ChartTrace;
    with m_ChartTrace.PaintStages[0]^ do
    begin
        if Stage = PST_CLEAR_BACKGND then
            Stage := PST_CUSTOM;
    end;
    m_ChartTrace.OnPaintStage := OnChartTracePaintStage;
    m_ChartTrace.RepaintMode := rmOptimizer;
end;

//---------------------------------------------------------------------------
function CFNQChartControl.GetEnableChartControl() : Boolean;
begin
    if Assigned(m_ChartDataSeries) then Result := (m_ChartDataSeries.m_Items.Count > 0)
    else Result := false;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.OnHScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: integer);
begin
    if (GetEnableChartControl()) then
    begin
        m_ChartBlockManager.OnHScroll(Sender, ScrollCode, ScrollPos);
        m_ChartBlockManager.RePaint();
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.OnZoomIn();
begin
    if (GetEnableChartControl()) then
    begin
        m_ChartBlockManager.Enlarge(1, true);
        if Assigned(m_OnChange) then m_OnChange(Self);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.OnZoomOut();
begin
    if (GetEnableChartControl()) then
    begin
        m_ChartBlockManager.Enlarge(-1, true);
        if Assigned(m_OnChange) then m_OnChange(Self);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.OnZoomActual();
begin
    if (GetEnableChartControl()) then
    begin
        m_ChartBlockManager.Enlarge(0, true);
        if Assigned(m_OnChange) then m_OnChange(Self);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.MouseMoveHandler(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
    inherited;
    if (GetEnableChartControl()) then
    begin
        m_ChartBlockManager.OnMouseMove(X, Y);

        //
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.MouseDownHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
    inherited;
    if (GetEnableChartControl()) then
    begin
        m_ChartBlockManager.OnMouseDown(X, Y);
        Self.OnMouseUp := MouseUpHandler;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.MouseUpHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
    inherited;
    if (GetEnableChartControl()) then
    begin
        m_ChartBlockManager.OnMouseUp(X, Y);
        Self.OnMouseUp := NIL;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SetScale(p_Value:Integer; p_Paint:Boolean=false);
begin
    m_Scale := p_Value;
    m_ChartBlockManager.SetScale(m_Scale);
    if (p_Paint) then
    begin
        m_ChartBlockManager.RePaint();
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.DeleteChart(p_Identity:Integer; p_Draw:Boolean=true);
var
    p_ChartBlock : CFNQChartBlock;
    p_ValueArray : CFNQLineValueSeries;
begin
    if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_AddType = 0) then
    begin
        p_ChartBlock := m_ChartBlockManager.FindChart(g_IndicatorName[IND_PRICE_NAME]);
        if (p_ChartBlock <> NIL) then
        begin
            p_ValueArray := p_ChartBlock.FindValueArray(CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Name);
            if (p_ValueArray = NIL)  AND (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Name = '오메가') then
            begin
                p_ValueArray := p_ChartBlock.FindValueArray('주가');
            end;

            if (p_ValueArray <> NIL) then
            begin
                if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Name = g_IndicatorName[IND_ILMOK_NAME]) then   //'일목균형표') then
                begin
                    p_ChartBlock.DeleteValueArray(CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Name);
                    m_ChartBlockManager.SetXExtraGap(0);
                    // 기간설정
                    m_ChartBlockManager.RangeEnlarge();
                    if (p_Draw) then
                    begin
                        m_ChartBlockManager.RePaint();
                    end;
                end else
                if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Name = '오메가') then
                begin
                    p_ChartBlock.DeleteValueArray('오메가');
                    p_ChartBlock.DeleteValueArray('주가');
                    m_ChartBlockManager.RangeEnlarge();
                    if (p_Draw) then
                    begin
                        m_ChartBlockManager.RePaint();
                    end;
                end else
                begin
                    p_ChartBlock.DeleteValueArray(CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Name);
                    p_ChartBlock.RangeEnlarge();
                    if (p_Draw) then
                    begin
                        m_ChartBlockManager.RePaint();
                    end;
                end;
            end;
        end;
    end
    else
    begin

        m_ChartBlockManager.DeleteChart(CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Name);
        m_ChartBlockManager.SetVisibleXLabel(m_ChartBlockManager.GetVisibleXLabel());
        m_ChartBlockManager.LayOut();
        if (p_Draw) then
        begin
            m_ChartBlockManager.RePaint();
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.ApplySetting;
var
    nIndex : Integer;
begin
    m_ChartBlockManager.DeleteChartAll();
    m_ChartBlockManager.Clear();
    m_ChartBlock := m_ChartBlockManager.AddChart(g_IndicatorName[IND_PRICE_NAME]);
    m_ChartBlock.SetChartDataSeries(m_ChartDataSeries);
    m_PriceSeries := NIL;

    m_PriceSeries := m_LineSeriesCreator.Creator_Price();
    if m_UseOPSPrice then
    begin
        m_PriceSeries.Indicator_OPS_Price(m_ChartDataSeries);
    end else
    begin
        m_PriceSeries.Indicator_Price(m_ChartDataSeries);
    end;
    m_PriceSeries.m_Precision := m_ChartDataSeries.m_Precision;
    m_PriceSeries.m_Options[0] := m_PriceBlockType;
    m_ChartBlock.AddObject(m_PriceSeries);
    m_ChartBlockManager.SetChartDataSeries(m_ChartDataSeries);

    for nIndex := 0 to m_Setting.m_SequenceO.Count - 1 do
    begin
        AddChart(PInteger(m_Setting.m_SequenceO.Items[nIndex])^, false, false);
    end;

    for nIndex := 0 to m_Setting.m_SequenceI.Count - 1 do
    begin
        AddChart(PInteger(m_Setting.m_SequenceI.Items[nIndex])^, false, false);
    end;

    for nIndex := 0 to m_Setting.m_SequenceS.Count - 1 do
    begin
        AddChart(PInteger(m_Setting.m_SequenceS.Items[nIndex])^, false, false);
    end;

    m_ChartBlockManager.SetVisibleXLabel(true);
    m_ChartBlockManager.LayOut();
    m_ChartBlockManager.FirstEnlarge(false);

    m_ChartBlockManager.RePaint();
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.ChangeChart(p_Identity:Integer; p_Draw:Boolean=true);
var
    p_ChartBlock : CFNQChartBlock;
    p_ValueArray : CFNQLineValueSeries;
    f_ADX       : Integer;
    f_ADX_NMA   : Integer;
    f_PDI       : Integer;
    f_MDI       : Integer;
    f_PDMSUM    : Integer;
    f_MDMSUM    : Integer;
    f_TRSUM     : Integer;
    f_PDM       : Integer;
    f_MDM       : Integer;
    f_TR        : Integer;
begin
    if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_AddType = 0) then
    begin
        p_ChartBlock := m_ChartBlockManager.FindChart(g_IndicatorName[IND_PRICE_NAME]);
        if (p_ChartBlock <> NIL) then
        begin
            p_ValueArray := p_ChartBlock.FindValueArray(CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Name);
            if (p_ValueArray <> NIL) then
            begin
                if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_ILMOK) then   //'일목균형표') then
                begin
                    p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                    p_ValueArray.m_Options[1] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1];
                    p_ValueArray.m_Options[2] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[2];
                    p_ValueArray.Indicator_IMLine(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), m_PriceSeries, 1, 2, 3, 0);
                    p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
                    p_ChartBlock.RangeEnlarge();
                    m_ChartBlockManager.SetXExtraGap(Math.Floor(CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1]));
                    // 기간설정
                    p_Draw := false;
                end
                else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_MA) then   //'이동평균선') then
                begin
                    p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                    p_ValueArray.m_Options[1] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1];
                    p_ValueArray.m_Options[2] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[2];
                    p_ValueArray.m_Options[3] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[3];
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[0]), m_PriceSeries, 3, 0);
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[1]), m_PriceSeries, 3, 1);
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[2]), m_PriceSeries, 3, 2);
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[3]), m_PriceSeries, 3, 3);
                    p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
                    p_ChartBlock.RangeEnlarge();
                end
                else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_NET) then   //'그물차트') then
                begin
                    if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[2] = p_ValueArray.m_Options[2]) then
                    begin
                        p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                        p_ValueArray.m_Options[1] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1];
                        p_ValueArray.m_Options[2] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[2];
                        p_ValueArray.Indicator_NET(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), m_PriceSeries, 3, 0);
                        p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
                        p_ChartBlock.RangeEnlarge();
                    end
                    else
                    begin
                        p_ValueArray := m_LineSeriesCreator.ModifyLine_NET(Math.Floor(CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[2]), p_ValueArray);
                        p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                        p_ValueArray.m_Options[1] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1];
                        p_ValueArray.m_Options[2] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[2];
                        p_ValueArray.Indicator_NET(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), m_PriceSeries, 3, 0);
                        p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
                        p_ChartBlock.RangeEnlarge();
                    end;
                end
                else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_ENVELOP) then   //'Envelop') then
                begin
                    p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                    p_ValueArray.m_Options[1] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1];
                    p_ValueArray.Indicator_Envelope(Math.Floor(p_ValueArray.m_Options[0]), p_ValueArray.m_Options[1], m_PriceSeries, 3, 0);
                    p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
                    p_ChartBlock.RangeEnlarge();
                end
                else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_BB) then   //'Bollinger Band') then
                begin
                    p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                    p_ValueArray.Indicator_BBand(Math.Floor(p_ValueArray.m_Options[0]), 2, m_PriceSeries, 3, 0);
                    p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
                    p_ChartBlock.RangeEnlarge();
                end
                else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_SAR) then   //'Parabolic') then
                begin
                    p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                    p_ValueArray.Indicator_SAR(p_ValueArray.m_Options[0], m_PriceSeries, 1, 2, 3, 0);
                    p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
                    p_ChartBlock.RangeEnlarge();
                end
                else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_OVERLAY_OPS) then //'LRL') then
                begin
                    if m_UseOPSPrice then
                    begin
                        p_ValueArray.Indicator_Close(m_ChartDataSeries);
                    end else
                    begin
                        p_ValueArray.Indicator_OPS(m_ChartDataSeries);
                    end;
                    p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
                    p_ChartBlock.RangeEnlarge();
                end
                else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_OVERLAY_OPSIGUK) then //'LRL') then
                begin
                    p_ValueArray.Indicator_OPS_IGUK(m_ChartDataSeries);
                    p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
                    p_ChartBlock.RangeEnlarge();
                end
                else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_OVERLAY_OPSIGUK2) then //'LRL') then
                begin
                    p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                    p_ValueArray.Indicator_OPS_IGUK2(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries);
                    p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
                    p_ChartBlock.RangeEnlarge();
                end
                else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_OVERLAY_OPSSTDDEV) then //'LRL') then
                begin
                    p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                    p_ValueArray.Indicator_OPS_STD(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries);
                    p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
                    p_ChartBlock.RangeEnlarge();
                end
                else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_OVERLAY_OPSREL) then //'LRL') then
                begin
                    p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                    p_ValueArray.Indicator_OPS_REL(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries);
                    p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
                    p_ChartBlock.RangeEnlarge();
                end;

                if (p_Draw) then
                begin
                    m_ChartBlockManager.RePaint();
                end;
            end;
        end;
    end else
    begin
        f_ADX       := 0;
        f_ADX_NMA   := 1;
        f_PDI       := 2;
        f_MDI       := 3;
        f_PDMSUM    := 4;
        f_MDMSUM    := 5;
        f_TRSUM     := 6;
        f_PDM       := 7;
        f_MDM       := 8;
        f_TR        := 9;
        p_ChartBlock := m_ChartBlockManager.FindChart(CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Name);
        if ((p_ChartBlock <> NIL) and (p_ChartBlock.m_ObjectArray.Count > 0)) then
        begin
            p_ValueArray := p_ChartBlock.m_ObjectArray[0];
            if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_MACD) then   //'MACD') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.m_Options[1] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1];
                p_ValueArray.m_Options[2] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[2];
                p_ValueArray.Indicator_MACD(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), m_PriceSeries, 3, 0);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_ADX) then   //'ADX') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.m_Options[1] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1];
                p_ValueArray.m_Options[2] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[2];
                p_ValueArray.Indicator_TrueRange(m_PriceSeries, 1, 2, 3, f_TR);
                p_ValueArray.Indicator_PMDM(m_PriceSeries, 1, 2, 3, f_PDM);
                p_ValueArray.Indicator_PMDI(Math.Floor(p_ValueArray.m_Options[0]), p_ValueArray, f_PDM, f_PDI);
                p_ValueArray.Indicator_ADX(Math.Floor(p_ValueArray.m_Options[1]), p_ValueArray, f_PDI, f_MDI, f_ADX);
                p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[2]), p_ValueArray, f_ADX, f_ADX_NMA);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_DMI) then   //'DMI') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.Indicator_TrueRange(m_PriceSeries, 1, 2, 3, f_TR - 2);
                p_ValueArray.Indicator_PMDM(m_PriceSeries, 1, 2, 3, f_PDM - 2);
                p_ValueArray.Indicator_PMDI(Math.Floor(p_ValueArray.m_Options[0]), p_ValueArray, f_PDM - 2, f_PDI - 2);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_TRIX) then   //'TRIX') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.m_Options[1] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1];
                p_ValueArray.Indicator_TRIX(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), m_PriceSeries, 3, 0);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_FASTSTC) then   //'Fast STC') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.m_Options[1] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1];
                p_ValueArray.Indicator_FastSTC(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), m_PriceSeries, 1, 2, 3, 0);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_SLOWSTC) then   //'Slow STC') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.m_Options[1] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1];
                p_ValueArray.m_Options[2] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[2];
                p_ValueArray.Indicator_SlowSTC(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), m_PriceSeries, 1, 2, 3, 0);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_RSI) then   //'RSI') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.m_Options[1] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1];
                p_ValueArray.Indicator_RSI(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), m_PriceSeries, 3, 0);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_OBV) then   //'OBV') then
            begin
                p_ValueArray.Indicator_OBV(m_PriceSeries, 3, m_PriceSeries, 4, 0);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_VR) then   //'VR') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.Indicator_VR(Math.Floor(p_ValueArray.m_Options[0]), m_PriceSeries, 3, m_PriceSeries, 4, 0);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_PSY) then   //'투자심리선') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.Indicator_PSY(Math.Floor(p_ValueArray.m_Options[0]), m_PriceSeries, 3, 0);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_CCI) then   //'CCI') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.Indicator_CCI(Math.Floor(p_ValueArray.m_Options[0]), m_PriceSeries, 1, 2, 3, 0);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_PMAO) then   //'PMAO') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.m_Options[1] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1];
                p_ValueArray.Indicator_PMAO(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), m_PriceSeries, 3, 0);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_SONAR) then   //'SONAR') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.m_Options[1] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1];
                p_ValueArray.m_Options[2] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[2];
                p_ValueArray.Indicator_SONA(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), m_PriceSeries, 3, 0);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_VOLUME) then   //'거래량') then
            begin
                p_ValueArray.Indicator_Volume(m_ChartDataSeries);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_ROC) then   //'ROC') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.Indicator_ROC(Math.Floor(p_ValueArray.m_Options[0]), m_PriceSeries, 3, 0);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_WILLIAM) then   //'Williams'' %R') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.m_Options[1] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[1];
                p_ValueArray.Indicator_WilliamsR(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), m_PriceSeries, 1, 2, 3, 0);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_OPS) then
            begin
                p_ValueArray.Indicator_OPS(m_ChartDataSeries);
               p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_OPSIGUK) then
            begin
                p_ValueArray.Indicator_OPS_IGUK(m_ChartDataSeries);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_OPSIGUK2) then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.Indicator_OPS_IGUK2(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_OPSSTDDEV) then //'LRL') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.Indicator_OPS_STD(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else if (CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_Value = CFNQSetting.IND_OPSREL) then //'LRL') then
            begin
                p_ValueArray.m_Options[0] := CFNQIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_OptionValue[0];
                p_ValueArray.Indicator_OPS_REL(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries);
                p_ChartBlock.ChangedLineMaxMin(p_ValueArray);
            end
            else
            begin
                //
            end;

            m_ChartBlockManager.RangeEnlarge();
            if (p_Draw) then
            begin
                m_ChartBlockManager.RePaint();
            end;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.SetTraceVisible(p_Value:Boolean; p_Paint:Boolean = false);
begin
    m_ChartBlockManager.SetTraceVisible(p_Value, p_Paint);
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.DrawChartCaption();
begin
    if (m_ChartCaption <> NIL) then
    begin
        m_ChartCaption.Refresh();
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.DrawTrace(p_ValueX:Integer);
begin
    m_ValueX := p_ValueX;
    if (m_ChartTrace <> NIL) then
    begin
        m_ChartTrace.Refresh;
    end;
end;

//---------------------------------------------------------------------------
function CFNQChartControl.GetTimeFrameIntToLabelStr(nTimeFrame:Integer) : String;
begin
    if (9000 < nTimeFrame) then
    begin
        //분간
        Result := IntToStr(nTimeFrame-9000) + '초간';
    end
    else if (360 > nTimeFrame) then
    begin
        //분간
        Result := IntToStr(nTimeFrame) + g_ChartTfString[TFS_MIN];
    end
    else if (360 = nTimeFrame) then          //일간
    begin
        Result := g_ChartTfString[TFS_DAY    ];
    end
    else if (1000 = nTimeFrame) then        //주간
    begin
        Result := g_ChartTfString[TFS_WEEK    ];
    end
    else if (2000 = nTimeFrame) then        //월간
    begin
        Result := g_ChartTfString[TFS_MONTH    ];
    end else
    begin
        Result := '';
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.GetChartMaxMin(var p_Min, p_Max:Double);
begin
    if Assigned(m_ChartBlock) then
    begin
        if (m_ChartBlock.m_MaxMin.m_YMin < m_ChartBlock.m_MaxMin.m_YMax) then
        begin
            p_Min := m_ChartBlock.m_MaxMin.m_YMin;
            p_Max := m_ChartBlock.m_MaxMin.m_YMax;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartControl.DrawTraceDate(p_Index:Integer; p_Date:TDateTime);
begin
    if m_ChartDataSeries = NIL then exit;

    m_ValueX := m_ChartDataSeries.SearchByClose(p_Date, true);
    if (m_ChartTrace <> NIL) then
    begin
        m_ChartTrace.Refresh;
    end;
    m_ChartBlockManager.DrawTraceDate(p_Index, m_ValueX);
end;

//---------------------------------------------------------------------------

end.
