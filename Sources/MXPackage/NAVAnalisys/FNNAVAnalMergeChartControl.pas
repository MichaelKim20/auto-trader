unit FNNAVAnalMergeChartControl;

interface

uses
    SysUtils, Classes, Controls, GR32_Image, GR32, Types, Messages, Graphics, DateUtils,
    Dialogs, Math, StdCtrls, Windows, FNNAVAnalLineValueSeries, FNNAVAnalLineValueSeriesCreator,
    FNNAVAnalChartDataSeries, FNDataSet, FNNAVAnalChartData, FNQueue, GR32_Layers, FNNAVAnalConst,
    FNNAVAnalMaxMin, FNNAVAnalColorSet, FNNAVAnalChartBlockManager, FNNAVAnalChartBlock,
    FNNAVAnalChartTraceEvent, FNNAVAnalSystemManager, FNNAVAnalChartControlBase;

type
    CFNNAVAnalMergeChartControl = class(CFNNAVAnalChartControlBase)
    private
        m_SystemManager       : CFNNAVAnalSystemManager;
        m_ChartBlockManager   : CFNNAVAnalChartBlockManager;
        m_PriceChartBlock     : CFNNAVAnalChartBlock;
        m_MergeChartBlock     : CFNNAVAnalChartBlock;
        m_Initialized         : Boolean;
        m_ChartType           : Integer;
        m_OnControlPaintStage : TPaintStageEvent;
        m_ScrollBar           : TScrollBar;
        m_Scale               : Integer;
        m_ValueX              : Integer;

        m_DrawTraceChartIndex : Integer;
        m_DrawTraceValueX     : Double;
        m_DrawTraceValueY     : Double;


        m_LightVersion        : Boolean;

        procedure MyScrollMove(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: integer);

        procedure WMSize(var Message: TWMSize); message WM_SIZE;
        procedure SetScrollBar(AScrollBar : TScrollBar);

    protected
        procedure MouseMoveHandler(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
        procedure MouseDownHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
        procedure MouseUpHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);

    public
        m_ChartDataSeries   : CFNNAVAnalChartDataSeries;
        m_PriceSeries       : CFNNAVAnalLineValueSeries;
        m_MergeSeries1      : CFNNAVAnalLineValueSeries;

        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;

        procedure Initialize;
        procedure Finalize;

        procedure Clear;

        function GetEnableChartControl : Boolean;

        procedure Update(p_ChangedDailyGap:Boolean);

        procedure OnResize(p_Left:Integer; p_Top:Integer; p_Width:Integer; p_Height:Integer; p_Paint:Boolean);
        procedure SetBound(p_Left:Integer; p_Top:Integer; p_Right:Integer; p_Bottom:Integer);
        procedure RepaintDraw(p_Bitmap:TBitmap32);

        procedure SetColorSetIndex(p_Value:Integer; p_Paint:Boolean=false);
        procedure SetScale(p_Value:Integer; p_Paint:Boolean=false);
        procedure SetTraceVisible(p_Value:Boolean; p_Paint:Boolean=false);
        procedure SetChartType(p_Type:Integer; p_Paint:Boolean=false);

        procedure OnZoomIn;
        procedure OnZoomOut;
        procedure OnZoomActual;
        procedure OnFullEnlarge;
        procedure DrawTrace(p_ChartIndex:Integer; p_ValueX:Double; p_ValueY:Double);

        procedure OnControlPaintStage(Sender: TObject; Buffer: TBitmap32; StageNum: Cardinal);

        procedure GetChartMaxMin(var p_Min, p_Max:Double);
        procedure OnHScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: integer);

    private
        m_VisibleFinalProfit : Boolean;

        m_VisibleProfitOBuy : Boolean;
        m_VisibleProfitOSell : Boolean;
        m_VisibleProfitOAll : Boolean;
        m_VisibleProfitOAvgBuy1 : Boolean;
        m_VisibleProfitOAvgSell1 : Boolean;
        m_VisibleProfitOAvgAll1 : Boolean;
        m_VisibleProfitOAvgBuy2 : Boolean;
        m_VisibleProfitOAvgSell2 : Boolean;
        m_VisibleProfitOAvgAll2 : Boolean;

        m_VisibleProfitCAll : Boolean;
        m_VisibleProfitCBuy : Boolean;
        m_VisibleProfitCSell : Boolean;

        m_VisibleProfitCAvgAll1 : Boolean;
        m_VisibleProfitCAvgBuy1 : Boolean;
        m_VisibleProfitCAvgSell1 : Boolean;

        m_VisibleProfitCAvgAll2 : Boolean;
        m_VisibleProfitCAvgBuy2 : Boolean;
        m_VisibleProfitCAvgSell2 : Boolean;

        m_DisplayTypeOfTrade : Integer;

        procedure ApplyMergeLineSeries;

    public

        procedure SetVisibleFinalProfit(p_Value:Boolean);

        procedure SetVisibleProfitOBuy(p_Value:Boolean);
        procedure SetVisibleProfitOSell(p_Value:Boolean);
        procedure SetVisibleProfitOAll(p_Value:Boolean);

        procedure SetVisibleProfitOAvgBuy1(p_Value:Boolean);
        procedure SetVisibleProfitOAvgSell1(p_Value:Boolean);
        procedure SetVisibleProfitOAvgAll1(p_Value:Boolean);

        procedure SetVisibleProfitOAvgBuy2(p_Value:Boolean);
        procedure SetVisibleProfitOAvgSell2(p_Value:Boolean);
        procedure SetVisibleProfitOAvgAll2(p_Value:Boolean);

        procedure SetVisibleProfitCBuy(p_Value:Boolean);
        procedure SetVisibleProfitCSell(p_Value:Boolean);
        procedure SetVisibleProfitCAll(p_Value:Boolean);

        procedure SetVisibleProfitCAvgBuy1(p_Value:Boolean);
        procedure SetVisibleProfitCAvgSell1(p_Value:Boolean);
        procedure SetVisibleProfitCAvgAll1(p_Value:Boolean);

        procedure SetVisibleProfitCAvgBuy2(p_Value:Boolean);
        procedure SetVisibleProfitCAvgSell2(p_Value:Boolean);
        procedure SetVisibleProfitCAvgAll2(p_Value:Boolean);

        procedure SetDisplayTypeOfTrade(p_Value:Integer; p_Paint:Boolean=false);

    published
        property ScrollBar: TScrollBar read m_ScrollBar write SetScrollBar;
        property SystemManager: CFNNAVAnalSystemManager read m_SystemManager write m_SystemManager;
        property LightVersion:Boolean read m_LightVersion write m_LightVersion;

    end;

procedure Register;

implementation

uses FNGlobal, FNGlobalVariable, FNNAVAnalChartDefine;

//---------------------------------------------------------------------------
procedure Register;
begin
  RegisterComponents('ATPackage', [CFNNAVAnalMergeChartControl]);
end;

//---------------------------------------------------------------------------
constructor CFNNAVAnalMergeChartControl.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);

    m_LightVersion      := false;
    m_ChartType         := 2;
    m_Initialized       := false;

    m_ScrollBar         := NIL;
    m_ValueX            := -1;

    m_OnControlPaintStage := OnControlPaintStage;

    m_DrawTraceChartIndex := -1;
    m_DrawTraceValueX := -1;
    m_DrawTraceValueY := -1;

    m_VisibleProfitOBuy := true;
    m_VisibleProfitOSell := true;
    m_VisibleProfitOAll := false;

    m_VisibleProfitOAvgBuy1 := true;
    m_VisibleProfitOAvgSell1 := true;
    m_VisibleProfitOAvgAll1 := false;

    m_VisibleProfitOAvgBuy2 := true;
    m_VisibleProfitOAvgSell2 := true;
    m_VisibleProfitOAvgAll2 := false;

    m_VisibleProfitCBuy := false;
    m_VisibleProfitCSell := false;
    m_VisibleProfitCAll := false;

    m_VisibleProfitCAvgBuy1 := false;
    m_VisibleProfitCAvgSell1 := false;
    m_VisibleProfitCAvgAll1 := false;

    m_VisibleProfitCAvgBuy2 := false;
    m_VisibleProfitCAvgSell2 := false;
    m_VisibleProfitCAvgAll2 := false;

    m_VisibleFinalProfit := false;

    m_DisplayTypeOfTrade := 0;

    Initialize;
end;

//---------------------------------------------------------------------------
destructor CFNNAVAnalMergeChartControl.Destroy;
begin
    Finalize;

    inherited Destroy;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.Initialize;
begin
    m_ChartDataSeries 	:= CFNNAVAnalChartDataSeries.Create;

    m_ChartBlockManager := CFNNAVAnalChartBlockManager.Create;
    m_ChartBlockManager.SetChartControl(Self);
    m_ChartBlockManager.SetLayer;

    m_PriceSeries := Creator_Price;
    m_MergeSeries1 := Creator_MergeSeries;

    SetColorSetIndex(CFNNAVAnalConst.COLOR_SET_WHITE, false);
    SetScale(0, false);

    m_Initialized 	    := true;

    //컨트롤 배경 Draw 속성 설정
    with PaintStages[0]^ do
    begin
        if Stage = PST_CLEAR_BACKGND then
        begin
            Stage := PST_CUSTOM;
        end;
    end;

    //배경 Draw 이벤트 함수 등록
    OnPaintStage := m_OnControlPaintStage;
    RepaintMode := rmOptimizer;

    //Mouse Event
    Self.OnMouseMove := MouseMoveHandler;
    Self.OnMouseDown := MouseDownHandler;
    //Self.OnMouseLeave := MouseLeaveHandler;

    OnResize(0, 0, Width, Height, true);
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.Finalize;
begin
    if Assigned(m_ChartDataSeries) then
    begin
        m_ChartDataSeries.Free;
        m_ChartDataSeries := NIL;
    end;

    if Assigned(m_PriceSeries) then
    begin
        m_PriceSeries.Free;
        m_PriceSeries := NIL;
    end;

    if Assigned(m_MergeSeries1) then
    begin
        m_MergeSeries1.Free;
        m_MergeSeries1 := NIL;
    end;

    if Assigned(m_ChartBlockManager) then
    begin
        m_ChartBlockManager.Free;
        m_ChartBlockManager := NIL;
    end;
    m_Initialized := false;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.Clear;
begin
    m_ChartDataSeries.Clear;
    if m_PriceSeries <> NIL then m_PriceSeries.Clear;
    if m_MergeSeries1 <> NIL then m_MergeSeries1.Clear;

    m_ChartBlockManager.ClearChartAll;
    m_ChartBlockManager.RePaint;

    m_PriceSeries := NIL;
    m_MergeSeries1 :=  NIL;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.WMSize(var Message: TWMSize);
begin
    if (m_Initialized) then OnResize(0, 0, Width, Height, true);

    Self.Resize;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetColorSetIndex(p_Value:Integer; p_Paint:Boolean = false);
begin
    m_ChartBlockManager.SetColorSetIndex(p_Value, p_Paint);
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetBound(p_Left:Integer; p_Top:Integer; p_Right:Integer; p_Bottom:Integer);
begin
    m_ChartBlockManager.SetBound(p_Left, p_Top, p_Right, p_Bottom);
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.OnResize(p_Left:Integer; p_Top:Integer; p_Width:Integer; p_Height:Integer; p_Paint:Boolean);
begin
    m_ChartBlockManager.OnResize(p_Left, p_Top, p_Width, p_Height, p_Paint);
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.RepaintDraw(p_Bitmap:TBitmap32);
begin
    m_ChartBlockManager.Clear;
    m_ChartBlockManager.Draw(p_Bitmap);
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.Update(p_ChangedDailyGap:Boolean);
var
    nIndex:Integer;
    f_AddCount:Integer;
    f_Range : CFNNAVAnalMaxMin;
    f_Begin, f_End : Integer;
begin
    if not Assigned(m_SystemManager) then exit;

    if p_ChangedDailyGap then
    begin
        f_Range := m_ChartBlockManager.GetMaxMin();
        f_AddCount := m_SystemManager.m_ChartDataSeries.m_Items.Count - m_ChartDataSeries.m_Items.Count;
        if f_AddCount < 0 then f_AddCount := 0;

        if m_PriceSeries <> nil then m_PriceSeries.Clear;
        if m_MergeSeries1 <> nil then  m_MergeSeries1.Clear;
        if m_ChartDataSeries <> nil then m_ChartDataSeries.Clear;

        m_SystemManager.Lock;
        try
            m_ChartDataSeries.Update(m_SystemManager.m_ChartDataSeries);
        finally
            m_SystemManager.Unlock;
        end;

        m_ChartBlockManager.SetChartDataSeries(m_ChartDataSeries);

        if (m_ChartDataSeries.m_Items.Count > 0) then
        begin
            if m_PriceSeries = nil then m_PriceSeries := Creator_Price;
            if m_MergeSeries1 = nil then
            begin
                m_MergeSeries1 :=  Creator_MergeSeries;
                ApplyMergeLineSeries;
            end;

            m_SystemManager.Lock;
            try
                m_MergeSeries1.Update(m_SystemManager.m_MergeSeries1);
                m_MergeSeries1.m_ChartDataSeries := m_ChartDataSeries;
            finally
                m_SystemManager.Unlock;
            end;

            f_Begin := m_PriceSeries.m_Items.Count-1;
            f_End   := m_ChartDataSeries.m_Items.Count;

            m_PriceSeries.Indicator_RealPrice(m_ChartDataSeries, f_Begin, f_End);
            m_PriceSeries.GetLineMaxMin(0, m_PriceSeries.m_Items.Count - 1);
            m_PriceChartBlock.m_AbsMaxMin.m_XMin := 0;
            m_PriceChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
            m_PriceChartBlock.m_AbsMaxMin.m_YMin := m_PriceSeries.m_MaxMinTable[0].m_YMin;
            m_PriceChartBlock.m_AbsMaxMin.m_YMax := m_PriceSeries.m_MaxMinTable[0].m_YMax;

            if not m_LightVersion then
            begin
              m_MergeSeries1.GetLineMaxMin(0, m_MergeSeries1.m_Items.Count - 1);
              m_MergeChartBlock.m_AbsMaxMin.m_XMin := 0;
              m_MergeChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
              m_MergeChartBlock.m_AbsMaxMin.m_YMin := m_MergeSeries1.m_MaxMinTable[0].m_YMin;
              m_MergeChartBlock.m_AbsMaxMin.m_YMax := m_MergeSeries1.m_MaxMinTable[0].m_YMax;
            end;

            m_ChartBlockManager.RangeEnlarge(f_Range.m_XMin + f_AddCount, f_Range.m_XMax + f_AddCount);
            m_ChartBlockManager.RePaint;
            m_ChartBlockManager.TraceOnLastTime;
        end else
        begin
            m_ChartDataSeries.Clear;
            m_ChartBlockManager.DeleteChartAll;
            m_ChartBlockManager.RePaint;
            m_PriceSeries := NIL;
            m_MergeSeries1 :=  NIL;
        end;
    end else
    begin
        if m_ChartDataSeries.m_Items.Count = 0 then
        begin

            m_SystemManager.Lock;
            try
                m_ChartDataSeries.Update(m_SystemManager.m_ChartDataSeries);
            finally
                m_SystemManager.Unlock;
            end;

            m_ChartBlockManager.SetChartDataSeries(m_ChartDataSeries);
            if (m_ChartDataSeries.m_Items.Count > 0) then
            begin
                m_ChartBlockManager.DeleteChartAll;
                m_ChartBlockManager.Clear;

                m_PriceSeries := Creator_Price;
                m_MergeSeries1 :=  Creator_MergeSeries;
                ApplyMergeLineSeries;

                m_SystemManager.Lock;
                try
                    m_MergeSeries1.Update(m_SystemManager.m_MergeSeries1);
                    m_MergeSeries1.m_ChartDataSeries := m_ChartDataSeries;
                finally
                    m_SystemManager.Unlock;
                end;

                m_PriceChartBlock := m_ChartBlockManager.AddChart(g_IndicatorName[IND_PRICE_NAME]);

                m_PriceSeries.Indicator_RealPrice(m_ChartDataSeries);
                m_PriceSeries.GetLineMaxMin(0, m_PriceSeries.m_Items.Count - 1);
                m_PriceChartBlock.m_AbsMaxMin.m_XMin := 0;
                m_PriceChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
                m_PriceChartBlock.m_AbsMaxMin.m_YMin := m_PriceSeries.m_MaxMinTable[0].m_YMin;
                m_PriceChartBlock.m_AbsMaxMin.m_YMax := m_PriceSeries.m_MaxMinTable[0].m_YMax;

                m_PriceSeries.m_Precision := m_ChartDataSeries.m_Precision;
                m_PriceSeries.m_Options[0] := m_ChartType;
                m_PriceChartBlock.AddObject(m_PriceSeries);

                if (not m_LightVersion) then
                begin
                  m_MergeChartBlock := m_ChartBlockManager.AddChart(m_MergeSeries1.m_FullName);
                  m_MergeChartBlock.AddObject(m_MergeSeries1);

                  m_MergeSeries1.GetLineMaxMin(0, m_MergeSeries1.m_Items.Count - 1);
                  m_MergeChartBlock.m_AbsMaxMin.m_XMin := 0;
                  m_MergeChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
                  m_MergeChartBlock.m_AbsMaxMin.m_YMin := m_MergeSeries1.m_MaxMinTable[0].m_YMin;
                  m_MergeChartBlock.m_AbsMaxMin.m_YMax := m_MergeSeries1.m_MaxMinTable[0].m_YMax;
                end;

                m_ChartBlockManager.SetVisibleXLabel(true);
                m_ChartBlockManager.LayOut;
                m_ChartBlockManager.FullEnlarge(false);

                m_ChartBlockManager.RePaint;
            end
            else
            begin
                m_ChartDataSeries.Clear;
                m_ChartBlockManager.DeleteChartAll;
                m_ChartBlockManager.RePaint;
                m_PriceSeries := NIL;
                m_MergeSeries1 :=  NIL;
            end;
        end else
        begin
            f_Range := m_ChartBlockManager.GetMaxMin();
            f_AddCount := m_SystemManager.m_ChartDataSeries.m_Items.Count - m_ChartDataSeries.m_Items.Count;
            if f_AddCount < 0 then f_AddCount := 0;

            m_SystemManager.Lock;
            try
                m_ChartDataSeries.Update(m_SystemManager.m_ChartDataSeries);
            finally
                m_SystemManager.Unlock;
            end;

            m_ChartBlockManager.SetChartDataSeries(m_ChartDataSeries);

            if (m_ChartDataSeries.m_Items.Count > 0) then
            begin
                if m_PriceSeries = nil then m_PriceSeries := Creator_Price;
                if m_MergeSeries1 = nil then
                begin
                    m_MergeSeries1 :=  Creator_MergeSeries;
                    ApplyMergeLineSeries;
                end;

                m_SystemManager.Lock;
                try
                    m_MergeSeries1.Update(m_SystemManager.m_MergeSeries1);
                    m_MergeSeries1.m_ChartDataSeries := m_ChartDataSeries;
                finally
                    m_SystemManager.Unlock;
                end;

                f_Begin := m_PriceSeries.m_Items.Count-1;
                f_End := m_ChartDataSeries.m_Items.Count;
                m_PriceSeries.Indicator_RealPrice(m_ChartDataSeries, f_Begin, f_End);
                m_PriceSeries.GetLineMaxMin(0, m_PriceSeries.m_Items.Count - 1);
                m_PriceChartBlock.m_AbsMaxMin.m_XMin := 0;
                m_PriceChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
                m_PriceChartBlock.m_AbsMaxMin.m_YMin := m_PriceSeries.m_MaxMinTable[0].m_YMin;
                m_PriceChartBlock.m_AbsMaxMin.m_YMax := m_PriceSeries.m_MaxMinTable[0].m_YMax;

                if not m_LightVersion then
                begin
                    m_MergeSeries1.GetLineMaxMin(0, m_MergeSeries1.m_Items.Count - 1);
                    m_MergeChartBlock.m_AbsMaxMin.m_XMin := 0;
                    m_MergeChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
                    m_MergeChartBlock.m_AbsMaxMin.m_YMin := m_MergeSeries1.m_MaxMinTable[0].m_YMin;
                    m_MergeChartBlock.m_AbsMaxMin.m_YMax := m_MergeSeries1.m_MaxMinTable[0].m_YMax;
                end;

                m_ChartBlockManager.RangeEnlarge(f_Range.m_XMin + f_AddCount, f_Range.m_XMax + f_AddCount);
                m_ChartBlockManager.RePaint;
                m_ChartBlockManager.TraceOnLastTime;
            end else
            begin
                m_ChartDataSeries.Clear;
                m_ChartBlockManager.DeleteChartAll;
                m_ChartBlockManager.RePaint;
                m_PriceSeries := NIL;
                m_MergeSeries1 :=  NIL;
            end;
        end;
    end;

    m_ValueX := - 1;
    if m_DrawTraceValueX >= 0 then
    begin
        //DrawTrace(m_DrawTraceChartIndex, m_DrawTraceValueX, m_DrawTraceValueY);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.ApplyMergeLineSeries;
begin
    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT9          ]  := m_VisibleFinalProfit;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT9          ]  := m_VisibleFinalProfit;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT9          ]  := m_VisibleFinalProfit;

    //---------------------------------------------------------------------------------------------------------
    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_B        ]  := m_VisibleProfitOBuy;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_B        ]  := m_VisibleProfitOBuy;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_B        ]  := m_VisibleProfitOBuy;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_S        ]  := m_VisibleProfitOSell;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_S        ]  := m_VisibleProfitOSell;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_S        ]  := m_VisibleProfitOSell;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1          ]  := m_VisibleProfitOAll;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1          ]  := m_VisibleProfitOAll;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1          ]  := m_VisibleProfitOAll;

    //---------------------------------------------------------------------------------------------------------
    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_AVG1_B    ]  := m_VisibleProfitOAvgBuy1;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_AVG1_B    ]  := m_VisibleProfitOAvgBuy1;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_AVG1_B    ]  := m_VisibleProfitOAvgBuy1;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_AVG1_S    ]  := m_VisibleProfitOAvgSell1;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_AVG1_S    ]  := m_VisibleProfitOAvgSell1;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_AVG1_S    ]  := m_VisibleProfitOAvgSell1;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_AVG1      ]  := m_VisibleProfitOAvgAll1;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_AVG1      ]  := m_VisibleProfitOAvgAll1;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_AVG1      ]  := m_VisibleProfitOAvgAll1;

    //---------------------------------------------------------------------------------------------------------
    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_AVG2_B    ]  := m_VisibleProfitOAvgBuy2;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_AVG2_B    ]  := m_VisibleProfitOAvgBuy2;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_AVG2_B    ]  := m_VisibleProfitOAvgBuy2;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_AVG2_S    ]  := m_VisibleProfitOAvgSell2;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_AVG2_S    ]  := m_VisibleProfitOAvgSell2;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_AVG2_S    ]  := m_VisibleProfitOAvgSell2;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_AVG2      ]  := m_VisibleProfitOAvgAll2;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_AVG2      ]  := m_VisibleProfitOAvgAll2;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_AVG2      ]  := m_VisibleProfitOAvgAll2;

    //---------------------------------------------------------------------------------------------------------
    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_B        ]  := m_VisibleProfitCBuy;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_B        ]  := m_VisibleProfitCBuy;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_B        ]  := m_VisibleProfitCBuy;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_S        ]  := m_VisibleProfitCSell;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_S        ]  := m_VisibleProfitCSell;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_S        ]  := m_VisibleProfitCSell;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C          ]  := m_VisibleProfitCAll;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C          ]  := m_VisibleProfitCAll;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C          ]  := m_VisibleProfitCAll;

    //---------------------------------------------------------------------------------------------------------
    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_AVG1_B   ]  := m_VisibleProfitCAvgBuy1;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_AVG1_B   ]  := m_VisibleProfitCAvgBuy1;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_AVG1_B   ]  := m_VisibleProfitCAvgBuy1;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_AVG1_S   ]  := m_VisibleProfitCAvgSell1;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_AVG1_S   ]  := m_VisibleProfitCAvgSell1;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_AVG1_S   ]  := m_VisibleProfitCAvgSell1;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_AVG1     ]  := m_VisibleProfitCAvgAll1;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_AVG1     ]  := m_VisibleProfitCAvgAll1;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_AVG1     ]  := m_VisibleProfitCAvgAll1;

    //---------------------------------------------------------------------------------------------------------
    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_AVG2_B   ]  := m_VisibleProfitCAvgBuy2;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_AVG2_B   ]  := m_VisibleProfitCAvgBuy2;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_AVG2_B   ]  := m_VisibleProfitCAvgBuy2;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_AVG2_S   ]  := m_VisibleProfitCAvgSell2;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_AVG2_S   ]  := m_VisibleProfitCAvgSell2;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_AVG2_S   ]  := m_VisibleProfitCAvgSell2;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_AVG2     ]  := m_VisibleProfitCAvgAll2;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_AVG2     ]  := m_VisibleProfitCAvgAll2;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_AVG2     ]  := m_VisibleProfitCAvgAll2;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleFinalProfit(p_Value:Boolean);
begin
    m_VisibleFinalProfit := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT9         ]    := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT9         ]    := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT9         ]    := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitOBuy(p_Value:Boolean);
begin
    m_VisibleProfitOBuy := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_B       ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_B       ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_B       ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitOSell(p_Value:Boolean);
begin
    m_VisibleProfitOSell := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_S       ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_S       ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_S       ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitOAll(p_Value:Boolean);
begin
    m_VisibleProfitOAll := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1         ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1         ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1         ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;
//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitOAvgBuy1(p_Value:Boolean);
begin
    m_VisibleProfitOAvgBuy1 := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_AVG1_B  ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_AVG1_B  ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_AVG1_B  ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitOAvgSell1(p_Value:Boolean);
begin
    m_VisibleProfitOAvgSell1 := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_AVG1_S  ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_AVG1_S  ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_AVG1_S  ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitOAvgAll1(p_Value:Boolean);
begin
    m_VisibleProfitOAvgAll1 := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_AVG1    ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_AVG1    ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_AVG1    ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitOAvgBuy2(p_Value:Boolean);
begin
    m_VisibleProfitOAvgBuy2 := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_AVG2_B  ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_AVG2_B  ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_AVG2_B  ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitOAvgSell2(p_Value:Boolean);
begin
    m_VisibleProfitOAvgSell2 := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_AVG2_S  ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_AVG2_S  ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_AVG2_S  ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitOAvgAll2(p_Value:Boolean);
begin
    m_VisibleProfitOAvgAll2 := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1_AVG2    ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1_AVG2    ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1_AVG2    ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitCBuy(p_Value:Boolean);
begin
    m_VisibleProfitCBuy := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_B      ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_B      ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_B      ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitCSell(p_Value:Boolean);
begin
    m_VisibleProfitCSell := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_S      ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_S      ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_S      ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitCAll(p_Value:Boolean);
begin
    m_VisibleProfitCAll := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C        ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C        ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C        ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;
//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitCAvgBuy1(p_Value:Boolean);
begin
    m_VisibleProfitCAvgBuy1 := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_AVG1_B ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_AVG1_B ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_AVG1_B ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitCAvgSell1(p_Value:Boolean);
begin
    m_VisibleProfitCAvgSell1 := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_AVG1_S ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_AVG1_S ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_AVG1_S ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitCAvgAll1(p_Value:Boolean);
begin
    m_VisibleProfitCAvgAll1 := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_AVG1   ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_AVG1   ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_AVG1   ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitCAvgBuy2(p_Value:Boolean);
begin
    m_VisibleProfitCAvgBuy2 := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_AVG2_B ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_AVG2_B ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_AVG2_B ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitCAvgSell2(p_Value:Boolean);
begin
    m_VisibleProfitCAvgSell2 := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_AVG2_S ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_AVG2_S ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_AVG2_S ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetVisibleProfitCAvgAll2(p_Value:Boolean);
begin
    m_VisibleProfitCAvgAll2 := p_Value;
    if m_ChartDataSeries = nil then exit;
    if m_MergeSeries1 = nil then exit;
    if m_ChartBlockManager = nil then exit;

    m_MergeSeries1.m_LineLabelVisibles       [M_MERGE_LINE_PROFIT1C_AVG2   ]  := p_Value;
    m_MergeSeries1.m_LineLabelNameVisibles   [M_MERGE_LINE_PROFIT1C_AVG2   ]  := p_Value;
    m_MergeSeries1.m_LineVisibles            [M_MERGE_LINE_PROFIT1C_AVG2   ]  := p_Value;

    m_ChartBlockManager.RangeEnlarge;
    m_ChartBlockManager.RePaint;
    m_ChartBlockManager.TraceOnLastTime;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetDisplayTypeOfTrade(p_Value:Integer; p_Paint:Boolean=false);
begin
    m_DisplayTypeOfTrade := p_Value;
    m_ChartBlockManager.SetDisplayTypeOfTrade(p_Value);
    if (p_Paint) then
    begin
        m_ChartBlockManager.RePaint;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetChartType(p_Type:Integer; p_Paint:Boolean=false);
var
    f_ChartBlock : CFNNAVAnalChartBlock;
    f_ValueArray : CFNNAVAnalLineValueSeries;
    f_PriceArray : CFNNAVAnalLineValueSeries;
begin
    if (p_Type = 0) then
        m_ChartType := 0
    else if (p_Type = 1) then
        m_ChartType := 2
    else if (p_Type = 2) then
        m_ChartType := 1
    else

    if (not GetEnableChartControl) then exit;

    if ((p_Type >= 0) and (p_Type <= 2)) then
    begin
        m_ChartBlockManager.Clear;
        m_ChartBlockManager.m_ChartType := CFNNAVAnalConst.CHART_NORMAL;
        f_ChartBlock := m_ChartBlockManager.FindChart(g_IndicatorName[IND_PRICE_NAME]);
        if (f_ChartBlock <> NIL) then
        begin
            if (m_PriceSeries <> NIL) then m_PriceSeries.m_Options[0] := m_ChartType;
            if (m_PriceSeries <> NIL) then f_ChartBlock.ChangedLineMaxMin(m_PriceSeries);
            f_ChartBlock.RangeEnlarge;
            m_ChartBlockManager.LayOut;
            if (p_Paint) then
            begin
                m_ChartBlockManager.RePaint;
            end;
        end;
            m_ChartBlockManager.LayOut;
            m_ChartBlockManager.SetScrollBarPosition;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.OnControlPaintStage(Sender: TObject; Buffer: TBitmap32; StageNum: Cardinal);
begin
    m_ChartBlockManager.Draw(Buffer);
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetScrollBar(AScrollBar : TScrollBar);
begin
    m_ScrollBar := AScrollBar;
    if m_ScrollBar = NIL then exit;

    m_ScrollBar.LargeChange := 30;
    m_ScrollBar.SmallChange := 1;
    m_ScrollBar.PageSize := 0;

    m_ScrollBar.OnScroll := OnHScroll;

    m_ChartBlockManager.SetScrollBar(m_ScrollBar);
end;

//---------------------------------------------------------------------------
function CFNNAVAnalMergeChartControl.GetEnableChartControl : Boolean;
begin
    Result := (m_ChartDataSeries.m_Items.Count > 0);
end;

//---------------------------------------------------------------------------
//스크롤 이벤트
procedure CFNNAVAnalMergeChartControl.OnHScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: integer);
begin
    if (GetEnableChartControl) then
        MyScrollMove(Sender, ScrollCode, ScrollPos);
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.MyScrollMove(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: integer);
var
    f_OldPoint :Integer;
    f_NewPoint : Integer;
    f_NowPoint : Integer;
begin
    m_ChartBlockManager.OnHScroll(Sender, ScrollCode, ScrollPos);
    m_ChartBlockManager.RePaint;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.OnZoomIn;
begin
    if (GetEnableChartControl) then
        m_ChartBlockManager.Enlarge(1, true);
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.OnZoomOut;
begin
    if (GetEnableChartControl) then
        m_ChartBlockManager.Enlarge(-1, true);
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.OnZoomActual;
begin
    if (GetEnableChartControl) then
        m_ChartBlockManager.Enlarge(0, true);
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.OnFullEnlarge;
begin
    if (GetEnableChartControl) then
        m_ChartBlockManager.FullEnlarge(true);
end;
//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.MouseMoveHandler(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
    if (GetEnableChartControl) then
    begin
        m_ChartBlockManager.OnMouseMove(X, Y);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.MouseDownHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
    if (GetEnableChartControl) then
    begin
        m_ChartBlockManager.OnMouseDown(X, Y);
        Self.OnMouseUp := MouseUpHandler;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.MouseUpHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
    if (GetEnableChartControl) then
    begin
        m_ChartBlockManager.OnMouseUp(X, Y);
        Self.OnMouseUp := NIL;
    end;
end;
//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetScale(p_Value:Integer; p_Paint:Boolean=false);
begin
    m_Scale := p_Value;
    m_ChartBlockManager.SetScale(m_Scale);
    if (p_Paint) then
    begin
        m_ChartBlockManager.RePaint;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.SetTraceVisible(p_Value:Boolean; p_Paint:Boolean = false);
begin
    m_ChartBlockManager.SetTraceVisible(p_Value, p_Paint);
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.DrawTrace(p_ChartIndex:Integer; p_ValueX:Double; p_ValueY:Double);
begin
    m_ValueX := Round(p_ValueX);
    m_DrawTraceChartIndex := p_ChartIndex;
    m_DrawTraceValueX := p_ValueX;
    m_DrawTraceValueY := p_ValueY;
    m_ChartBlockManager.DrawTrace(p_ChartIndex, p_ValueX, p_ValueY);
end;

//---------------------------------------------------------------------------
procedure CFNNAVAnalMergeChartControl.GetChartMaxMin(var p_Min, p_Max:Double);
begin
    if Assigned(m_PriceChartBlock) then
    begin
        if (m_PriceChartBlock.m_MaxMin.m_YMin < m_PriceChartBlock.m_MaxMin.m_YMax) then
        begin
            p_Min := m_PriceChartBlock.m_MaxMin.m_YMin;
            p_Max := m_PriceChartBlock.m_MaxMin.m_YMax;
        end;
    end;
end;

end.
