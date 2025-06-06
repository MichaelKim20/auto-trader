unit FNQChartBlockManager;

interface

uses
    SysUtils, Types, Classes, Math, GR32, StdCtrls, Messages, Windows, GR32_Layers, Contnrs, ExtCtrls,
    FNQChartDataSeries, FNQStreamChartDataSeries, FNQColorSet, FNQConst, FNQMaxMin, FNQueue, FNThread, SyncObjs, Graphics,
    FNQChartData, FNQLineValueSeries,
    FNQChartBlock, FNQPosInfo, FNQChartTraceEvent, FNQPosValue;

type
    pTPoint = ^TPoint;

    CFNQChartBlockManager = class(TObject)
    private
        m_ChartArray        : TList;
        m_Scale             : Integer;
        m_ChartControl      : TObject;
        m_ColorSet          : CFNQColorSet;
        m_ColorSetIndex     : Integer;

        m_ScrollBar         : TScrollBar;

        m_OverLayer        : TBitmapLayer;
        m_TraceLayer       : TBitmapLayer;
        m_PosValueLayer    : TBitmapLayer;
        m_LabelLayer       : TBitmapLayer;
        m_DrawLayer        : TBitmapLayer;
        m_SignalLayer       : TBitmapLayer;

        m_XExtraGap         : Integer;

        m_TraceVisible      : Boolean;
        m_XLabel            : Boolean;

        m_UseOPSPrice       : Boolean;

        m_SignalChartIndex  :Integer;
        m_Signal            :Integer;
        m_SignalStart       :Integer;
        m_SignalEnd         :Integer;
        m_SignalPosition    :Integer;
        m_LastTRInfo        :CFNQPosInfo;

    public
        m_BoundRect         : TRect;
        m_ChartDataSeries   : CFNQChartDataSeries;
        m_ChartType         : Integer;
        m_XMaxMin           : Integer;

        constructor Create();
        destructor  Destroy(); override;
        procedure SetUseOPSPrice(AValue: Boolean);

        procedure SetColorSetIndex(p_Value:Integer; p_Paint:Boolean = false);
        function GetColorSet() : CFNQColorSet;
        procedure SetChartControl(p_ChartControl:TObject);
        procedure SetBound(p_Left:Integer; p_Top:Integer; p_Width:Integer; p_Height:Integer);
        procedure OnResize(p_Left:Integer; p_Top:Integer; p_Width:Integer; p_Height:Integer; p_Paint:Boolean);
        procedure LayOut();
        function AddChart(p_Name:String) : CFNQChartBlock;
        function InsertChart(p_Name:String) : CFNQChartBlock;
        procedure DeleteChart(p_Name:String);
        procedure DeleteChartAll();
        procedure ClearChartAll;
        function FindChart(p_Name:String) : CFNQChartBlock;
        procedure Clear();
        procedure Draw(p_Bitmap:TBitmap32);
        procedure RePaint();
        procedure SetChartDataSeries(p_ChartDataSeries:CFNQChartDataSeries);
        procedure SetScale(p_Scale:Integer);
        function GetMaxMin() : CFNQMaxMin;
        procedure FirstEnlarge(p_Paint:Boolean);
        procedure RangeEnlarge(f_XMin:Double=-1; f_XMax:Double=-1; p_SetScrollBarPropertis:Boolean=true; p_Notify:Boolean=true);
        procedure SetXMaxMin(p_Value: Integer);
        procedure ReEnlarge(p_Value:Integer);

        procedure EnlargeValue(p_Paint:Boolean; p_Value:Integer);
        procedure Enlarge(p_Rratio:Integer; p_Paint:Boolean=false);
        procedure AllRange(p_SetScrollBarPropertis:Boolean = true);

        procedure SetScrollBar(p_ScrollBar : TScrollBar);
        procedure OnHScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: integer);
        procedure SetScrollBarPosition(p_Notify:Boolean=true);

        procedure ClearTraceLayer();
        procedure ClearPosValueLayer();
        procedure ClearActiveLayer();
        procedure ClearLabelLayer();
        procedure ClearSignalLayer;

        procedure OnMouseDown(p_X:Integer; p_Y:Integer);
        procedure OnMouseUp(p_X:Integer; p_Y:Integer);
        procedure OnMouseMove(p_X:Integer; p_Y:Integer);
        procedure OnMouseLeave();

        function RequestPrevData(p_XDirection:Integer; p_XMinDate:TDateTime; p_XMaxDate:TDateTime; p_XMinOffset:Integer; p_XMaxOffset:Integer) : Boolean;
        function RequestNextData(p_XDirection:Integer; p_XMinDate:TDateTime; p_XMaxDate:TDateTime; p_XMinOffset:Integer; p_XMaxOffset:Integer) : Boolean;
        procedure DrawTraceCaption(p_ValueX:Integer);
        procedure TraceXYOnSometime(p_TRInfo:CFNQPosInfo);

        procedure TraceXYOnAnytime(p_TRInfo:CFNQPosInfo);
        procedure SetXExtraGap(p_X:Integer);
        procedure ClearTrace();
        procedure SetTraceVisible(p_Value:Boolean; p_Paint:Boolean = false);

        function GetCompareState() : Integer;
        procedure DrawPosValueFrame(p_X:Integer; p_Y:Integer; p_Width:Integer; p_Height:Integer; p_CX:Integer; p_CY:Integer; p_Direct:Integer);
        procedure DrawTraceXValueFrame(p_X:Integer; p_Y:Integer; p_Width:Integer; p_Height:Integer);
        procedure DrawTraceYValueFrame(p_X:Integer; p_Y:Integer; p_Width:Integer; p_Height:Integer);
        procedure DrawTracePannel(p_TRInfo:CFNQPosInfo);

        procedure SetLayer();

        procedure SetVisibleXLabel(p_Value:Boolean);
        function GetVisibleXLabel():Boolean;

        procedure ReCalculator(var p_ChartDataSeries:CFNQStreamChartDataSeries; var p_PriceArray:CFNQLineValueSeries);
        procedure UpdateCalculator(var p_ChartDataSeries:CFNQStreamChartDataSeries; var p_PriceArray:CFNQLineValueSeries; p_Range:Boolean);

        procedure OnPaintOverLayerManager(Sender: TObject; Buffer: TBitmap32);
        procedure DrawTraceDate(p_Index:Integer; p_ValueX: Double);

        procedure SignalTrace(p_ChartIndex, p_Signal, p_Start, p_End, p_Position : Integer);
        procedure SignalTraceFromOuterChart(p_ChartIndex, p_Signal, p_Start, p_End, p_Position: Integer);
        procedure TraceOnLastTime;

    end;

implementation
uses
    FNGlobal, FNQChartControl, FNQChartDefine;

constructor CFNQChartBlockManager.Create();
begin
    inherited Create();

    m_ChartArray    := TList.Create();
    m_ChartType     := CFNQConst.CHART_NORMAL;
    m_Scale         := 1;
    m_ColorSet      := CFNQColorSet.Create();
    m_ColorSet.Initialize();
    SetColorSetIndex(0);

    m_XExtraGap     := 0;
    m_TraceVisible  := true;
    //m_TRInfo        := NIL;
    m_XLabel        := true;
    m_UseOPSPrice := false;


    m_Signal            := 0;
    m_SignalStart       := 0;
    m_SignalEnd         := 0;
    m_SignalPosition    := 0;

    m_LastTRInfo        := CFNQPosInfo.Create;
    m_LastTRInfo.m_ChartIndex := -999;

end;

//---------------------------------------------------------------------------
destructor CFNQChartBlockManager.Destroy();
var
    nTry : Integer;
begin
    if Assigned(m_ChartArray) then
    begin
        DeleteChartAll();

        m_ChartArray.Free();
        m_ChartArray := NIL;
    end;

    if Assigned(m_ColorSet) then
    begin
        m_ColorSet.Free();
        m_ColorSet := NIL;
    end;

    m_LastTRInfo.Free;
    m_LastTRInfo := NIL;

    inherited Destroy();
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.SetLayer();
begin
    m_OverLayer        := TBitmapLayer.Create(CFNQChartControl(m_ChartControl).Layers);
    m_OverLayer.Bitmap.DrawMode := dmBlend;
    m_OverLayer.Bitmap.CombineMode :=cmMerge;
    m_OverLayer.OnPaint := OnPaintOverLayerManager;

    m_SignalLayer        := TBitmapLayer.Create(CFNQChartControl(m_ChartControl).Layers);
    m_SignalLayer.Bitmap.DrawMode := dmBlend;
    m_SignalLayer.Bitmap.CombineMode :=cmMerge;

    m_TraceLayer       := TBitmapLayer.Create(CFNQChartControl(m_ChartControl).Layers);
    m_TraceLayer.Bitmap.DrawMode := dmBlend;
    m_TraceLayer.Bitmap.CombineMode :=cmMerge;

    m_PosValueLayer    := TBitmapLayer.Create(CFNQChartControl(m_ChartControl).Layers);
    m_PosValueLayer.Bitmap.DrawMode := dmBlend;
    m_PosValueLayer.Bitmap.CombineMode :=cmMerge;

    m_LabelLayer       := TBitmapLayer.Create(CFNQChartControl(m_ChartControl).Layers);
    m_LabelLayer.Bitmap.DrawMode := dmBlend;
    m_LabelLayer.Bitmap.CombineMode :=cmMerge;

    m_DrawLayer        := TBitmapLayer.Create(CFNQChartControl(m_ChartControl).Layers);
    m_DrawLayer.Bitmap.DrawMode := dmBlend;
    m_DrawLayer.Bitmap.CombineMode :=cmMerge;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.SetColorSetIndex(p_Value:Integer; p_Paint:Boolean = false);
begin
    m_ColorSetIndex := p_Value;
    m_ColorSet.SetColorSetIndex(m_ColorSetIndex);
    if (p_Paint) then
    begin
        RePaint();
    end;
end;

//---------------------------------------------------------------------------
function CFNQChartBlockManager.GetColorSet() : CFNQColorSet;
begin
    Result := m_ColorSet;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.SetChartControl(p_ChartControl:TObject);
begin
    m_ChartControl := p_ChartControl;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.SetBound(p_Left:Integer; p_Top:Integer; p_Width:Integer; p_Height:Integer);
begin
    m_BoundRect := TFNGlobal.Rect2(p_Left, p_Top, p_Width, p_Height);
    LayOut();
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.OnResize(p_Left:Integer; p_Top:Integer; p_Width:Integer; p_Height:Integer; p_Paint:Boolean);
begin
    m_BoundRect := TFNGlobal.Rect2(p_Left, p_Top, p_Width, p_Height);
    if (p_Paint) then
    begin
        LayOut();
        SetScrollBarPosition();
        RePaint();
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.LayOut();
var
    f_ChartBlock    : CFNQChartBlock;
    f_Left, f_Top, f_Right, f_Bottom : Integer;
    f_ChartIndex    : Integer;
    f_InterHeight   : Integer;
    f_SpaceRect     : TRect;
begin
    if (m_ChartArray.Count = 0) then exit;

    f_SpaceRect := TFNGlobal.Rect2(m_BoundRect.left, m_BoundRect.top-1, RectWidth(m_BoundRect), RectHeight(m_BoundRect)+2);

    if (m_ChartArray.Count = 1) then
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[0]);
        f_ChartBlock.SetBound(f_SpaceRect.left, f_SpaceRect.top, f_SpaceRect.right, f_SpaceRect.bottom);
    end else
    begin
        f_Left      := f_SpaceRect.left;
        f_Top       := f_SpaceRect.top;
        f_Right     := f_SpaceRect.right;
        f_Bottom    := f_SpaceRect.top+Round(9.0/(12.0+2*(m_ChartArray.Count-1))*RectHeight(f_SpaceRect));
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[0]);
        f_ChartBlock.SetBound(f_Left, f_Top, f_Right, f_Bottom);
        f_SpaceRect.top := f_Bottom;

        for f_ChartIndex := 1 to m_ChartArray.Count - 1 do
        begin
            f_Top := f_Bottom;
            if (f_ChartIndex = m_ChartArray.Count - 1) then
                f_Bottom := f_SpaceRect.bottom
            else
                f_Bottom := f_Top + Round(RectHeight(f_SpaceRect) / (m_ChartArray.Count - 1));

            f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]);
            f_ChartBlock.SetBound(f_Left, f_Top, f_Right, f_Bottom);
            f_Bottom := f_Bottom-1;

        end;
    end;

    m_TraceLayer.Location := FloatRect(m_BoundRect.Left, m_BoundRect.Top, m_BoundRect.Right, m_BoundRect.Bottom);
    m_TraceLayer.Bitmap.SetSize(TFNGlobal.RectToWidth(m_BoundRect), TFNGlobal.RectToHeight(m_BoundRect));

    f_SpaceRect := Rect(m_BoundRect.Left, m_BoundRect.Top, m_BoundRect.Right, m_BoundRect.Bottom);
    f_SpaceRect.Right := f_ChartBlock.m_AxisRect.Right;
    m_OverLayer.Location := FloatRect(f_SpaceRect.Left, f_SpaceRect.Top, f_SpaceRect.Right, f_SpaceRect.Bottom);
    m_OverLayer.Bitmap.SetSize(TFNGlobal.RectToWidth(f_SpaceRect), TFNGlobal.RectToHeight(f_SpaceRect));

    m_SignalLayer.Location := FloatRect(f_SpaceRect.Left, f_SpaceRect.Top, f_SpaceRect.Right, f_SpaceRect.Bottom);
    m_SignalLayer.Bitmap.SetSize(TFNGlobal.RectToWidth(f_SpaceRect), TFNGlobal.RectToHeight(f_SpaceRect));

    m_PosValueLayer.Location := FloatRect(m_BoundRect.Left, m_BoundRect.Top, m_BoundRect.Right, m_BoundRect.Bottom);
    m_PosValueLayer.Bitmap.SetSize(TFNGlobal.RectToWidth(m_BoundRect), TFNGlobal.RectToHeight(m_BoundRect));

    m_LabelLayer.Location := FloatRect(m_BoundRect.Left, m_BoundRect.Top, m_BoundRect.Right, m_BoundRect.Bottom);
    m_LabelLayer.Bitmap.SetSize(TFNGlobal.RectToWidth(m_BoundRect), TFNGlobal.RectToHeight(m_BoundRect));
end;

//---------------------------------------------------------------------------
function CFNQChartBlockManager.AddChart(p_Name:String) : CFNQChartBlock;
var
    f_ChartBlock : CFNQChartBlock;
    f_ChartIndex : Integer;
begin
    f_ChartBlock := CFNQChartBlock.Create();

    f_ChartBlock.m_ChartBlockManager     := Self;
    f_ChartBlock.m_Name                 := p_Name;

    f_ChartBlock.m_TraceLayer          := m_TraceLayer;
    f_ChartBlock.m_OverLayer           := m_OverLayer;
    f_ChartBlock.m_SignalLayer           := m_SignalLayer;

    f_ChartBlock.m_LabelLayer          := m_LabelLayer;

    f_ChartBlock.m_ChartIndex             := m_ChartArray.Count;
    f_ChartBlock.SetChartDataSeries(m_ChartDataSeries);
    f_ChartBlock.SetXExtraGap(m_XExtraGap);
    f_ChartBlock.m_ColorSet             := m_ColorSet;

    if (f_ChartBlock.m_Name = g_IndicatorName[IND_PRICE_NAME]) then
        f_ChartBlock.SetScale(m_Scale)
    else
        f_ChartBlock.SetScale(0);

    m_ChartArray.Add(f_ChartBlock);
    for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
    begin
        CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]).m_ChartIndex := f_ChartIndex;
    end;

    Result := f_ChartBlock;
end;

//---------------------------------------------------------------------------
function CFNQChartBlockManager.InsertChart(p_Name:String) : CFNQChartBlock;
var
    f_ChartBlock : CFNQChartBlock;
    f_ChartIndex : Integer;
begin
    f_ChartBlock := CFNQChartBlock.Create();

    f_ChartBlock.m_ChartBlockManager    := Self;
    f_ChartBlock.m_Name                 := p_Name;

    f_ChartBlock.m_TraceLayer          := m_TraceLayer;
    f_ChartBlock.m_OverLayer           := m_OverLayer;
    f_ChartBlock.m_SignalLayer           := m_SignalLayer;


    f_ChartBlock.m_ChartIndex           := m_ChartArray.Count;
    f_ChartBlock.SetChartDataSeries(m_ChartDataSeries);
    f_ChartBlock.SetXExtraGap(m_XExtraGap);
    f_ChartBlock.m_ColorSet             := m_ColorSet;

    if (f_ChartBlock.m_Name = g_IndicatorName[IND_PRICE_NAME]) then
        f_ChartBlock.SetScale(m_Scale)
    else
        f_ChartBlock.SetScale(0);

    if (m_ChartArray.Count > 0) then
        m_ChartArray.Insert(m_ChartArray.Count - 1, f_ChartBlock)
    else
        m_ChartArray.Add(f_ChartBlock);

    for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
    begin
        CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]).m_ChartIndex := f_ChartIndex;
    end;

    Result := f_ChartBlock;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.DeleteChart(p_Name:String);
var
    f_Index         : Integer;
    f_ChartIndex    : Integer;
    f_ChartBlock    : CFNQChartBlock;
    f_FindChart     : CFNQChartBlock;
begin
    f_FindChart := NIL;
    for f_Index := 0 to m_ChartArray.Count - 1 do
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
        if (f_ChartBlock.m_Name = p_Name) then
        begin
            f_FindChart := f_ChartBlock;
            f_FindChart.ClearObject();
            f_FindChart.Free();
            m_ChartArray.Delete(f_Index);
            break;
        end;
    end;

    for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
    begin
        CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]).m_ChartIndex := f_ChartIndex;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.DeleteChartAll();
var 
    f_Index     : Integer;
    f_ChartBlock: CFNQChartBlock;
begin
    while (0 < m_ChartArray.Count) do
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[0]);
        f_ChartBlock.ClearObject();
        f_ChartBlock.Free();

        m_ChartArray.Delete(0);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.ClearChartAll();
var
    f_Index     : Integer;
    f_ChartBlock: CFNQChartBlock;
begin
    for f_Index := 0 to m_ChartArray.Count - 1 do
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
        f_ChartBlock.ClearObject();
        f_ChartBlock.m_ChartIndex  := f_Index;
        f_ChartBlock.SetChartDataSeries(NIL);
        f_ChartBlock.m_ColorSet := m_ColorSet;
    end;
end;

//---------------------------------------------------------------------------
function CFNQChartBlockManager.FindChart(p_Name:String) : CFNQChartBlock;
var
    f_Index     : Integer;
    f_ChartBlock: CFNQChartBlock;
    f_FindChart : CFNQChartBlock;
begin
    f_FindChart := NIL;

    for f_Index := 0 to m_ChartArray.Count - 1 do
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
        if (f_ChartBlock.m_Name = p_Name) then
        begin
            f_FindChart := f_ChartBlock;
            break;
        end;
    end;

    Result := f_FindChart;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.Clear();
var
    f_Index     : Integer;
    f_ChartBlock: CFNQChartBlock;
begin
    ClearTraceLayer();
    ClearPosValueLayer();
    ClearLabelLayer();
    ClearSignalLayer;

    for f_Index := 0 to m_ChartArray.Count - 1 do
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
        f_ChartBlock.Clear();
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.ClearTraceLayer();
begin
    if (Assigned(m_TraceLayer)) then
    begin
        m_TraceLayer.Bitmap.Clear($00000000);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.ClearActiveLayer();
begin
    if (Assigned(m_OverLayer)) then
    begin
        m_OverLayer.Bitmap.Clear($00000000);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.ClearSignalLayer();
begin
    if (Assigned(m_SignalLayer)) then
    begin
        m_SignalLayer.Bitmap.Clear($00000000);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.ClearPosValueLayer();
begin
    if (Assigned(m_PosValueLayer)) then
    begin
        m_PosValueLayer.Bitmap.Clear($00000000);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.ClearLabelLayer();
begin
    if (Assigned(m_LabelLayer)) then
    begin
        m_LabelLayer.Bitmap.Clear($00000000);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.Draw(p_Bitmap:TBitmap32);
var
    f_Index     : Integer;
    f_ChartBlock: CFNQChartBlock;
begin
    try
        if (0 < m_ChartArray.Count) then
        begin
            for f_Index := 0 to m_ChartArray.Count - 1 do
            begin
                f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
                f_ChartBlock.Paint(p_Bitmap);

                f_ChartBlock.InitCaption();

                p_Bitmap.ResetClipRect;
                p_Bitmap.ClipRect := m_BoundRect;
            end;
            if m_Signal <> 0 then
            begin
                SignalTrace(m_SignalChartIndex, m_Signal, m_SignalStart, m_SignalEnd, m_SignalPosition);
            end;
        end else
        begin
            (*
            CFNQChartControl(m_ChartControl).CreateVirualChart;
            for f_Index := 0 to m_ChartArray.Count - 1 do
            begin
                f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
                f_ChartBlock.m_ColorSet := m_ColorSet;
                f_ChartBlock.Paint(p_Bitmap);

                p_Bitmap.ResetClipRect;
                p_Bitmap.ClipRect := m_BoundRect;
            end;
            *)
            p_Bitmap.Clear(m_ColorSet.m_Color[CFNQColorSet.CHART_BACKGROUND_COLOR]);
        end;
    finally
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.RePaint();
begin
    try
        Clear();
        CFNQChartControl(m_ChartControl).Invalidate;
    finally
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.SetChartDataSeries(p_ChartDataSeries:CFNQChartDataSeries);
var
    f_Index : Integer;
begin
    m_Signal := 0;
    m_ChartDataSeries := p_ChartDataSeries;
    for f_Index := 0 to m_ChartArray.Count - 1 do
    begin
        CFNQChartBlock(m_ChartArray.Items[f_Index]).m_ChartDataSeries := m_ChartDataSeries;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.SetScale(p_Scale:Integer);
var
    f_Index     : Integer;
    f_ChartBlock: CFNQChartBlock;
begin
    m_Scale := p_Scale;
    for f_Index := 0 to m_ChartArray.Count - 1 do
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
        if (f_ChartBlock.m_Name = g_IndicatorName[IND_PRICE_NAME]) then
            f_ChartBlock.SetScale(m_Scale)
        else
            f_ChartBlock.SetScale(0);
    end;
end;

//---------------------------------------------------------------------------
function CFNQChartBlockManager.GetMaxMin() : CFNQMaxMin;
begin
    Result := CFNQChartBlock(m_ChartArray.Items[0]).m_MaxMin;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.SetXMaxMin(p_Value: Integer);
var
    f_Index     : Integer;
    f_ChartBlock: CFNQChartBlock;
begin
    m_XMaxMin := p_Value;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.SignalTrace(p_ChartIndex, p_Signal, p_Start, p_End, p_Position: Integer);
var
    f_Index         : Integer;
    f_ChartBlock    : CFNQChartBlock;
begin
    m_SignalChartIndex  := p_ChartIndex;
    m_Signal            := p_Signal;
    m_SignalStart       := p_Start;
    m_SignalEnd         := p_End;
    m_SignalPosition    := p_Position;

    ClearSignalLayer;

    if p_Signal = 0 then exit;
    if p_Start = -1 then exit;

    for f_Index := 0 to m_ChartArray.Count - 1 do
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
        f_ChartBlock.DrawSignalTrace(p_Signal, p_Start, p_End);
    end;

end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.SignalTraceFromOuterChart(p_ChartIndex, p_Signal, p_Start, p_End, p_Position: Integer);
var
    f_Index         : Integer;
    f_ChartBlock    : CFNQChartBlock;
    f_Signal, f_Start, f_End, f_Position:Integer;
begin
    ClearSignalLayer;
    if (p_ChartIndex >= 0) AND (p_ChartIndex < m_ChartArray.Count) then
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[p_ChartIndex]);
        if Assigned(f_ChartBlock) then
        begin
            m_SignalPosition := p_Position;
            if f_ChartBlock.GetSignalRange(m_Signal, m_SignalStart, m_SignalEnd, m_SignalPosition) then
            begin
                ClearSignalLayer;
                for f_Index := 0 to m_ChartArray.Count - 1 do
                begin
                    f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
                    f_ChartBlock.DrawSignalTrace(m_Signal, m_SignalStart, m_SignalEnd);
                end;
            end;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.ReEnlarge(p_Value: Integer);
var
    f_Index     : Integer;
    f_ChartBlock: CFNQChartBlock;
begin
    m_XMaxMin := p_Value;
    for f_Index := 0 to m_ChartArray.Count - 1 do
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
        f_ChartBlock.ReEnlarge(p_Value);
    end;

    SetScrollBarPosition();

    RePaint();
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.FirstEnlarge(p_Paint:Boolean);
var
    f_Index     : Integer;
    f_ChartBlock: CFNQChartBlock;
begin
    for f_Index := 0 to m_ChartArray.Count - 1 do
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
        f_ChartBlock.FirstEnlarge();
    end;

    SetScrollBarPosition();

    if (p_Paint) then
    begin
        RePaint();
    end;

end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.EnlargeValue(p_Paint:Boolean; p_Value:Integer);
var
    f_Index : Integer;
    f_ChartBlock : CFNQChartBlock;
begin
    for f_Index := 0 to m_ChartArray.Count - 1 do
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
        f_ChartBlock.EnlargeValue(p_Value);
    end;

    SetScrollBarPosition();

    if (p_Paint) then
    begin
        RePaint();
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.Enlarge(p_Rratio:Integer; p_Paint:Boolean=false);
var
    f_PriceChart : CFNQChartBlock;
    f_Action : Boolean;
    f_MaxMin : CFNQMaxMin;
    f_AbsMin, f_AbsMax, f_MaxMinMin, f_MaxMinMax : Double;
    f_XMinDate, f_XMaxDate : TDateTime;
    f_XMinOffset, f_XMaxOffset : Double;

    f_Index : Integer;
    f_ChartBlock : CFNQChartBlock;
begin
    f_Action := false;
    f_PriceChart := CFNQChartBlock(m_ChartArray.Items[0]);
    if (f_PriceChart = NIL) then
        exit;

    if ((p_Rratio > 0) and (f_PriceChart.m_MaxMin.m_XMax - f_PriceChart.m_MaxMin.m_XMin <= 10)) then
        exit;

    f_MaxMin := f_PriceChart.GetEnlargeInfo(p_Rratio);
    f_AbsMin := f_PriceChart.m_AbsMaxMin.m_XMin;
    f_AbsMax := f_PriceChart.m_AbsMaxMin.m_XMax;
    f_MaxMinMin := f_MaxMin.m_XMin;
    f_MaxMinMax := f_MaxMin.m_XMax;
    if (f_MaxMinMin < f_AbsMin) then
        f_XMinOffset := f_MaxMinMin
    else
        f_XMinOffset := 0;

    if (f_MaxMinMax > f_AbsMax) then
        f_XMaxOffset := f_MaxMinMax - f_AbsMax
    else
        f_XMaxOffset := 0;

    if (not f_Action) then
    begin
        for f_Index := 0 to m_ChartArray.Count - 1 do
        begin
            f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
            f_ChartBlock.Enlarge(p_Rratio);
        end;

        SetScrollBarPosition();
        if (p_Paint) then
        begin
            RePaint();
        end;
    end;

    f_MaxMin.Free();

end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.AllRange(p_SetScrollBarPropertis:Boolean = true);
var
    f_XMin, f_XMax : Double;
begin
    f_XMin := 0;
    RangeEnlarge(f_XMin, f_XMax, p_SetScrollBarPropertis);
end;

//---------------------------------------------------------------------------
//특정 X축의 영역에 해당하는 최대, 최소값을 계산한다.
procedure CFNQChartBlockManager.RangeEnlarge(f_XMin:Double=-1; f_XMax:Double=-1; p_SetScrollBarPropertis:Boolean=true; p_Notify:Boolean=true);
var
    f_Index : Integer;
    f_SmallSize : Integer;
begin
    if (m_ChartArray.Count > 0) then
    begin
        if (f_XMin = -1) then
            f_XMin := CFNQChartBlock(m_ChartArray.Items[0]).m_MaxMin.m_XMin;

        if (f_XMax = -1) then
            f_XMax := CFNQChartBlock(m_ChartArray.Items[0]).m_MaxMin.m_XMax;
    end;

    for f_Index := 0 to m_ChartArray.Count - 1 do
    begin
        CFNQChartBlock(m_ChartArray.Items[f_Index]).RangeEnlarge(f_XMin, f_XMax, true);
    end;

    if (p_SetScrollBarPropertis) then
    begin
        SetScrollBarPosition(p_Notify);
        f_SmallSize := Math.floor((f_XMax - f_XMin) / 7.0);
        if (f_SmallSize = 0) then
            f_SmallSize := 1;

        m_ScrollBar.SmallChange := f_SmallSize;
        m_ScrollBar.LargeChange := f_SmallSize;
    end;
    if Assigned(CFNQChartControl(m_ChartControl).OnChange) then CFNQChartControl(m_ChartControl).OnChange(m_ChartControl);
end;


//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.SetScrollBar(p_ScrollBar : TScrollBar);
begin
    m_ScrollBar := p_ScrollBar;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.OnHScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: integer);
var
    f_ChartBlock : CFNQChartBlock;
    f_XMin, f_XMax, f_Position, f_PageSize : Double;

    f_XDirection : Integer;
    f_XMinDate, f_XMaxDate : TDateTime;
    f_ChartData1 : CFNQChartData;
    f_ChartData0 : CFNQChartData;
    f_XMinOffset, f_XMaxOffset : Integer;
begin
    if (m_ScrollBar = NIL) then
        exit;

    if (m_ChartDataSeries = NIL) then
        exit;

    if (m_ChartArray.Count = 0) then
        exit;

    if (ScrollPos > m_ScrollBar.Max-m_ScrollBar.PageSize) then
    begin
        ScrollPos := m_ScrollBar.Max-m_ScrollBar.PageSize + 1;
    end;

    f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[0]);
    f_XMin := ScrollPos;
    f_XMax := f_XMin+f_ChartBlock.m_XSize;
    if (f_XMin <> f_ChartBlock.m_MaxMin.m_XMin) then
        RangeEnlarge(f_XMin, f_XMax, false, true);

    if (f_XMin = 0) then
    begin

        f_ChartData0 := CFNQChartData(m_ChartDataSeries.m_Items.Items[Math.Floor(f_ChartBlock.m_MaxMin.m_XMin)]);
        f_ChartData1 := CFNQChartData(m_ChartDataSeries.m_Items.Items[Math.Floor(f_ChartBlock.m_MaxMin.m_XMax)]);

        if ((f_ChartData0 <> NIL) and (f_ChartData1 <> NIL)) then
        begin
            f_XMinDate := f_ChartData0.m_CloseDateTime;
            f_XMaxDate := f_ChartData1.m_CloseDateTime;
            f_XMinOffset := 0;
            f_XMaxOffset := 0;
            f_XDirection := 0;
            //CFNQChartControl(m_ChartControl).OnRequestFromChartBlockManager_Type2(f_XDirection, f_XMinDate, f_XMaxDate, f_XMinOffset, f_XMaxOffset);
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.SetScrollBarPosition(p_Notify:Boolean=true);
var
    f_ChartBlock : CFNQChartBlock;
    f_XMin, f_XMax : Integer;
    f_Position, f_PageSize : Integer;
    n : Integer;
begin
    if (m_ScrollBar = NIL) then exit;
    if (m_ChartDataSeries = NIL) then exit;
    if (m_ChartArray.Count = 0) then exit;

    f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[0]);
    f_XMin := Round(f_ChartBlock.m_AbsMaxMin.m_XMin);
    f_XMax := Round(f_ChartBlock.m_AbsMaxMin.m_XMax + f_ChartBlock.m_PaddingRight + f_ChartBlock.m_XExtraGap);
    f_PageSize := Round(f_ChartBlock.m_XSize)+1;
    f_Position := Round(f_ChartBlock.m_MaxMin.m_XMin);

    if ((f_Position = 0) and (0 >= Max(0, f_XMax-f_PageSize))) then
    begin
        m_ScrollBar.Enabled := false;
    end else
    begin
        m_ScrollBar.Enabled := true;
        m_ScrollBar.PageSize := 0;
        m_ScrollBar.SetParams(f_Position, f_XMin, Max(0, f_XMax));
        m_ScrollBar.PageSize := f_PageSize;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.OnMouseDown(p_X:Integer; p_Y:Integer);
var 
    m_EventRect : TRect;
    f_ChartIndex, f_MouseChartIndex : Integer;
begin
    f_MouseChartIndex := -1;
    for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
    begin
        m_EventRect := TFNGlobal.Rect2(CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect.Left,
                            CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect.Top,
                            TFNGlobal.RectToWidth(CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect) - 50,
                            TFNGlobal.RectToHeight(CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect));

        if (PtInRect(m_EventRect, Point(p_X, p_Y))) then
        begin
            f_MouseChartIndex := f_ChartIndex;
            break;
        end;
    end;                      

    if (f_MouseChartIndex >= 0) then
        CFNQChartBlock(m_ChartArray.Items[f_MouseChartIndex]).OnMouseDown(p_X, p_Y);
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.OnMouseUp(p_X:Integer; p_Y:Integer);
var
    m_EventRect     : TRect;
    f_CaptureMouse  : Boolean;
    f_ChartIndex, f_MouseChartIndex : Integer;
begin
    f_CaptureMouse := false;

    f_MouseChartIndex := -1;
    for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
    begin
        if (CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]).m_CaptureMouse) then
        begin
            f_MouseChartIndex := f_ChartIndex;
            f_CaptureMouse := true;
            break;
        end;
    end;

    if (f_MouseChartIndex < 0) then
    begin
        for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
        begin
            m_EventRect := TFNGlobal.Rect2(CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect.Left,
                                CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect.Top,
                                TFNGlobal.RectToWidth(CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect) - 50,
                                TFNGlobal.RectToHeight(CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect));

            if (PtInRect(m_EventRect, Point(p_X, p_Y))) then
            begin
                f_MouseChartIndex := f_ChartIndex;
                break;
            end;
        end;
    end;

    if (f_MouseChartIndex >= 0) then
        CFNQChartBlock(m_ChartArray.Items[f_MouseChartIndex]).OnMouseUp(p_X, p_Y);
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.OnMouseMove(p_X:Integer; p_Y:Integer);
var
    m_EventRect : TRect;
    f_ChartIndex, f_MouseChartIndex : Integer;
    f_ChartBlock:CFNQChartBlock;
begin
    try
        for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
        begin
            f_ChartBlock := m_ChartArray.Items[f_ChartIndex];
            m_EventRect := TFNGlobal.Rect2(f_ChartBlock.m_BoundRect.Left,
                                f_ChartBlock.m_BoundRect.Top,
                                TFNGlobal.RectToWidth(f_ChartBlock.m_BoundRect) - 50,
                                TFNGlobal.RectToHeight(f_ChartBlock.m_BoundRect));

            if (PtInRect(m_EventRect, Point(p_X, p_Y))) then
            begin
                f_ChartBlock.OnMouseMoveOnAnytime(p_X, p_Y);
                f_ChartBlock.OnMouseMoveSometime(p_X, p_Y);
            end;
        end;
    finally
    end;
end;

//---------------------------------------------------------------------------
function CFNQChartBlockManager.RequestPrevData(p_XDirection:Integer; p_XMinDate:TDateTime; p_XMaxDate:TDateTime; p_XMinOffset:Integer; p_XMaxOffset:Integer) : Boolean;
begin
    //Result := CFNQChartControl(m_ChartControl).OnRequestFromChartBlockManager_Type2(p_XDirection, p_XMinDate, p_XMaxDate, p_XMinOffset, p_XMaxOffset);
end;

//---------------------------------------------------------------------------
function CFNQChartBlockManager.RequestNextData(p_XDirection:Integer; p_XMinDate:TDateTime; p_XMaxDate:TDateTime; p_XMinOffset:Integer; p_XMaxOffset:Integer) : Boolean;
begin
    Result := false;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.DrawTraceCaption(p_ValueX:Integer);
var
    f_Index : Integer;
begin
    ClearLabelLayer;

    for f_Index := 0 to m_ChartArray.Count - 1 do
    begin
        CFNQChartBlock(m_ChartArray.Items[f_Index]).DrawCaption(p_ValueX);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.TraceXYOnSometime(p_TRInfo:CFNQPosInfo);
begin
    if (m_TraceVisible) then DrawTracePannel(p_TRInfo);
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.DrawTraceDate(p_Index:Integer; p_ValueX:Double);
var
    f_pt : TPoint;
    m_EventRect : TRect;
    f_ChartIndex, f_MouseChartIndex : Integer;
    f_ChartBlock:CFNQChartBlock;
    f_X, f_Y, f_Index : Integer;
    f_PosInfo:CFNQPosInfo;
begin
    try
        if (m_TraceVisible) then
        begin
            ClearTraceLayer();
            for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
            begin
                f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]);
                f_ChartBlock.DrawTraceDate(p_ValueX);
            end;
            DrawTraceCaption(Math.floor(p_ValueX));

            if (m_ChartArray.Count > 0) then
            begin
                f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[0]);
                f_PosInfo := CFNQPosInfo.Create();
                f_PosInfo.m_ChartIndex := p_Index;
                f_PosInfo.m_MX := 0;
                f_PosInfo.m_MY := 0;
                f_PosInfo.m_ValueX := p_ValueX;
                f_PosInfo.m_ValueY := 0;
                if (f_PosInfo.m_ValueX > f_ChartBlock.m_AbsMaxMin.m_XMax) then
                begin
                    f_PosInfo.m_ValueX := f_ChartBlock.m_AbsMaxMin.m_XMax;
                end;

                f_PosInfo.m_WindowX := Math.floor(f_ChartBlock.GetScreenXCenter(f_PosInfo.m_ValueX, f_ChartBlock.m_MaxMin));
                f_PosInfo.m_WindowY := Math.floor(f_ChartBlock.GetScreenY(f_PosInfo.m_ValueY, f_ChartBlock.m_MaxMin));
                f_PosInfo.m_OverLine := false;
                TraceXYOnSometime(f_PosInfo);
                f_PosInfo.Free;
            end;

            if (p_Index >= 0) AND (p_Index < m_ChartArray.Count) then
            begin
                f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[p_Index]);
                if Assigned(f_ChartBlock) then
                begin
                    m_SignalPosition := Floor(p_ValueX);
                    if f_ChartBlock.GetSignalRange(m_Signal, m_SignalStart, m_SignalEnd, m_SignalPosition) then
                    begin
                        ClearSignalLayer;
                        for f_Index := 0 to m_ChartArray.Count - 1 do
                        begin
                            f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
                            f_ChartBlock.DrawSignalTrace(m_Signal, m_SignalStart, m_SignalEnd);
                        end;
                    end;
                end;
            end;
        end;
    finally
    end;
end;
//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.TraceXYOnAnytime(p_TRInfo:CFNQPosInfo);
var
    f_Index : Integer;
    f_ChartData : CFNQChartData;
begin
    m_LastTRInfo.m_ChartIndex        := p_TRInfo.m_ChartIndex;
    m_LastTRInfo.m_MX                := p_TRInfo.m_MX                ;
    m_LastTRInfo.m_MY                := p_TRInfo.m_MY                ;
    m_LastTRInfo.m_ValueX            := p_TRInfo.m_ValueX            ;
    m_LastTRInfo.m_ValueY            := p_TRInfo.m_ValueY            ;
    m_LastTRInfo.m_WindowX           := p_TRInfo.m_WindowX           ;
    m_LastTRInfo.m_WindowY           := p_TRInfo.m_WindowY           ;
    m_LastTRInfo.m_ActiveObjectIndex := p_TRInfo.m_ActiveObjectIndex ;
    m_LastTRInfo.m_ActiveLineIndex   := p_TRInfo.m_ActiveLineIndex   ;
    m_LastTRInfo.m_OverLine          := p_TRInfo.m_OverLine          ;
    m_LastTRInfo.m_RealX             := p_TRInfo.m_RealX             ;
    m_LastTRInfo.m_RealY             := p_TRInfo.m_RealY             ;

    CFNQChartControl(m_ChartControl).DrawTrace(Round(p_TRInfo.m_ValueX));
    if (m_TraceVisible) then
    begin
        ClearTraceLayer();
        for f_Index := 0 to m_ChartArray.Count - 1 do
        begin
            CFNQChartBlock(m_ChartArray.Items[f_Index]).DrawTrace(p_TRInfo);
        end;
    end;

    if m_ChartDataSeries = nil then exit;
    if m_ChartDataSeries.m_Items.Count <= p_TRInfo.m_ValueX then exit;

    if Assigned(CFNQChartControl(m_ChartControl).OnChartTraceChange) then
    begin
        f_ChartData := m_ChartDataSeries.m_Items[Floor(p_TRInfo.m_ValueX)];
        CFNQChartControl(m_ChartControl).OnChartTraceChange(p_TRInfo.m_ChartIndex, f_ChartData.m_CloseDateTime);
    end;
end;
//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.TraceOnLastTime;
var
    f_Index : Integer;
    f_ChartData : CFNQChartData;
    f_ChartBlock : CFNQChartBlock;
begin
    if m_LastTRInfo.m_ChartIndex = -999 then exit;
    if m_LastTRInfo.m_ChartIndex < 0 then exit;
    if m_LastTRInfo.m_ChartIndex >= m_ChartArray.Count then exit;

    f_ChartBlock := m_ChartArray.Items[0];
    m_LastTRInfo.m_ValueX := Math.floor(f_ChartBlock.GetRealX(m_LastTRInfo.m_MX, f_ChartBlock.m_MaxMin));
    m_LastTRInfo.m_ValueY := f_ChartBlock.GetRealY(m_LastTRInfo.m_MY, f_ChartBlock.m_MaxMin);

    if (m_LastTRInfo.m_ValueX > f_ChartBlock.m_AbsMaxMin.m_XMax) then
        m_LastTRInfo.m_ValueX := f_ChartBlock.m_AbsMaxMin.m_XMax;

    m_LastTRInfo.m_WindowX := Math.floor(f_ChartBlock.GetScreenXCenter(m_LastTRInfo.m_ValueX, f_ChartBlock.m_MaxMin));
    m_LastTRInfo.m_WindowY := Math.floor(f_ChartBlock.GetScreenY(m_LastTRInfo.m_ValueY, f_ChartBlock.m_MaxMin));

    CFNQChartControl(m_ChartControl).DrawTrace(Round(m_LastTRInfo.m_ValueX));
    if (m_TraceVisible) then
    begin
        ClearTraceLayer();
        for f_Index := 0 to m_ChartArray.Count - 1 do
        begin
            CFNQChartBlock(m_ChartArray.Items[f_Index]).DrawTrace(m_LastTRInfo);
            CFNQChartBlock(m_ChartArray.Items[f_Index]).InitCaption();
        end;
    end;

    TraceXYOnSometime(m_LastTRInfo);
    DrawTraceCaption(Math.floor(m_LastTRInfo.m_ValueX));
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.SetXExtraGap(p_X:Integer);
var
    f_OldXExtraGap : Integer;
    f_Index : Integer;
    f_ChartBlock : CFNQChartBlock;
    p_Action : Boolean;

    f_XMin, f_XMax : Integer;
begin
    f_OldXExtraGap := m_XExtraGap;
    m_XExtraGap := p_X;
    for f_Index := 0 to m_ChartArray.Count - 1 do
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
        f_ChartBlock.SetXExtraGap(m_XExtraGap);
    end;

    p_Action := false;
    if ((CFNQChartBlock(m_ChartArray.Items[0]).m_AbsMaxMin.m_XMax + CFNQChartBlock(m_ChartArray.Items[0]).m_PaddingRight + f_OldXExtraGap)
        = CFNQChartBlock(m_ChartArray.Items[0]).m_MaxMin.m_XMax) then
        p_Action := true;

    if (p_Action) then
    begin

        f_XMax := Math.floor(CFNQChartBlock(m_ChartArray.Items[0]).m_MaxMin.m_XMax - f_OldXExtraGap + m_XExtraGap);
        f_XMin := Math.floor(CFNQChartBlock(m_ChartArray.Items[0]).m_MaxMin.m_XMin);
        if (f_XMax > Math.floor(CFNQChartBlock(m_ChartArray.Items[0]).m_AbsMaxMin.m_XMax + CFNQChartBlock(m_ChartArray.Items[0]).m_PaddingRight + CFNQChartBlock(m_ChartArray.Items[0]).m_XExtraGap)) then
            f_XMax := Math.floor(CFNQChartBlock(m_ChartArray.Items[0]).m_AbsMaxMin.m_XMax + CFNQChartBlock(m_ChartArray.Items[0]).m_PaddingRight + CFNQChartBlock(m_ChartArray.Items[0]).m_XExtraGap);

        RangeEnlarge(f_XMin, f_XMax, false);
        RePaint();
    end
    else
    begin
        SetScrollBarPosition();
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.ClearTrace();
begin
    ClearTraceLayer();
    ClearPosValueLayer();
end;


//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.SetVisibleXLabel(p_Value:Boolean);
var
    f_Index : Integer;
    f_ChartBlock : CFNQChartBlock;
begin
    m_XLabel := p_Value;
    for f_Index := 0 to m_ChartArray.Count - 1 do
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_Index]);
        if (f_Index = 0) then
            f_ChartBlock.m_VisibleXLabel := m_XLabel
        else
            f_ChartBlock.m_VisibleXLabel := false;
    end;
end;

//---------------------------------------------------------------------------
function CFNQChartBlockManager.GetVisibleXLabel():Boolean;
begin
    Result := m_XLabel;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.SetTraceVisible(p_Value:Boolean; p_Paint:Boolean = false);
begin
    m_TraceVisible := p_Value;
    if (not m_TraceVisible) and (p_Paint) then
    begin
        ClearTraceLayer();
        ClearPosValueLayer();
    end;
end;

procedure CFNQChartBlockManager.SetUseOPSPrice(AValue: Boolean);
begin
    m_UseOPSPrice := AValue;
end;

//---------------------------------------------------------------------------
function CFNQChartBlockManager.GetCompareState() : Integer;
begin
    Result := CFNQChartBlock(m_ChartArray.Items[0]).m_CompareState;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.DrawPosValueFrame(p_X:Integer; p_Y:Integer; p_Width:Integer; p_Height:Integer; p_CX:Integer; p_CY:Integer; p_Direct:Integer);
var
    PenColor : TColor32;
    FillColor : TColor32;
begin
    if (m_PosValueLayer = NIL) then
        exit;

    PenColor := m_ColorSet.m_Color[CFNQColorSet.TRACE_VALUE_LINE_COLOR];
    PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));
    FillColor := m_ColorSet.m_Color[CFNQColorSet.TRACE_VALUE_FILLED_COLOR];
    FillColor := SetAlpha(FillColor, TFNGlobal.GetAlphaValue(100));

    m_PosValueLayer.Bitmap.FillRectTS(p_X, p_Y, p_X+p_Width, p_Y+p_Height, FillColor);
    m_PosValueLayer.Bitmap.FrameRectTS(p_X, p_Y, p_X+p_Width, p_Y+p_Height, PenColor);
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.DrawTraceXValueFrame(p_X:Integer; p_Y:Integer; p_Width:Integer; p_Height:Integer);
var
    PenColor : TColor32;
    FillColor : TColor32;
begin
    if (m_PosValueLayer = NIL) then
        exit;

    PenColor := m_ColorSet.m_Color[CFNQColorSet.TRACE_XY_LINE_COLOR];
    PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));
    FillColor := m_ColorSet.m_Color[CFNQColorSet.TRACE_XY_FILLED_COLOR];
    FillColor := SetAlpha(FillColor, TFNGlobal.GetAlphaValue(100));

    m_PosValueLayer.Bitmap.FillRectTS(p_X, p_Y, p_X+p_Width, p_Y+p_Height, FillColor);
    m_PosValueLayer.Bitmap.FrameRectTS(p_X, p_Y, p_X+p_Width, p_Y+p_Height, PenColor);
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.DrawTraceYValueFrame(p_X:Integer; p_Y:Integer; p_Width:Integer; p_Height:Integer);
var
    PenColor : TColor32;
    FillColor : TColor32;
begin
    if (m_PosValueLayer = NIL) then
        exit;

    PenColor := m_ColorSet.m_Color[CFNQColorSet.TRACE_XY_LINE_COLOR];
    PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));
    FillColor := m_ColorSet.m_Color[CFNQColorSet.TRACE_XY_FILLED_COLOR];
    FillColor := SetAlpha(FillColor, TFNGlobal.GetAlphaValue(100));

    m_PosValueLayer.Bitmap.FillRectTS(p_X, p_Y, p_X+p_Width, p_Y+p_Height, FillColor);
    m_PosValueLayer.Bitmap.FrameRectTS(p_X, p_Y, p_X+p_Width, p_Y+p_Height, PenColor);
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.DrawTracePannel(p_TRInfo:CFNQPosInfo);
var
    f_Index, f_LineIndex, f_LineCount : Integer;
    f_ValueArray : TList;
    p_X, p_Y, p_W, p_H : Integer;
    p_ChartData : CFNQChartData;
    p_PosValue : CFNQPosValue;
    f_Value : String;
    f_Year, f_month, f_day, f_hour, f_min, f_sec : Integer;
    p_Enabled : Boolean;
    f_ChartBlock : CFNQChartBlock;

    f_YGridPrecision : Integer;
    f_Unit : Integer;

    f_YLabelWidth : Integer;

    p_CX, p_CY : Integer;
    p_Direct : Integer;

    f_TextWdith : Integer;
    f_TextHeight : Integer;
    f_AreaHeight : Integer;
    f_OffsetY    : Integer;
    FontColor : TColor32;
    f_AxisWidth : Integer;
begin
    ClearPosValueLayer();

    //m_PosValueLayer.Bitmap.MasterAlpha := TFNGlobal.GetAlphaValue(90);

    if ((p_TRInfo.m_ValueX >= 0) and (p_TRInfo.m_ValueX < m_ChartDataSeries.m_Items.Count)) then
    begin
        p_ChartData := CFNQChartData(m_ChartDataSeries.m_Items.Items[Math.Floor(p_TRInfo.m_ValueX)]);
        f_Year := p_ChartData.m_Year;
        f_month := p_ChartData.m_Month;
        f_day := p_ChartData.m_Day;
        f_hour := p_ChartData.m_Hour;
        f_min := p_ChartData.m_Min;
        f_sec := p_ChartData.m_Sec;
        p_Enabled := true;
    end else
    begin
        p_Enabled := false;
    end;

    m_PosValueLayer.Bitmap.Font.Name := CFNQColorSet.NUMBER2_FONT_FAMILY;
    m_PosValueLayer.Bitmap.Font.Size := CFNQColorSet.NUMBER2_FONT_SMALLSIZE2;
    m_PosValueLayer.Bitmap.Font.Style := [];

    FontColor := m_ColorSet.m_Color[CFNQColorSet.TRACE_XY_TEXT_COLOR];
    FontColor := SetAlpha(FontColor, TFNGlobal.GetAlphaValue(100));

    if (p_Enabled) then
    begin
        f_Value := TFNGlobal.DateToYYYY_MM_DD(f_Year, f_month, f_day);
        if (9000 < m_ChartDataSeries.m_TimeFrame) then
        begin
            f_Value := f_Value + ' ' + TFNGlobal.TimeToHH_MM_SS(f_hour, f_min, f_sec);
        end else
        if (360 > m_ChartDataSeries.m_TimeFrame) then
        begin
            f_Value := f_Value + ' ' + TFNGlobal.TimeToHH_MM(f_hour, f_min);
        end;

        p_W := m_PosValueLayer.Bitmap.TextWidth(f_Value) + 8;
        p_H := CFNQConst.CHART_DRAW_XLABEL_HEIGHT;
        p_X := Math.Floor(p_TRInfo.m_WindowX - (p_W / 2));
        p_Y := CFNQChartBlock(m_ChartArray.Items[0]).m_AxisRect.top + RectHeight(CFNQChartBlock(m_ChartArray.Items[0]).m_AxisRect)+1;

        //X축 좌표 정보 그린다.
        DrawTraceXValueFrame(p_X, p_Y-1, p_W, p_H+3);

        f_TextHeight := m_PosValueLayer.Bitmap.TextHeight(f_Value);
        m_PosValueLayer.Bitmap.RenderText((p_X + 4), (p_Y + Math.Floor((p_H-f_TextHeight)/2))+1, f_Value, 0, FontColor);
    end;

    if p_TRInfo.m_ChartIndex >= 0 then
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[p_TRInfo.m_ChartIndex]);
        f_YGridPrecision := f_ChartBlock.GetScreenYGridPrecision();
        f_Unit := f_ChartBlock.GetUnit();

        if (f_ChartBlock.m_YGridSize <> 0.0) then
        begin
            if (GetCompareState() = CFNQConst.COMPARE_TRUE) then
                f_Value := TFNGlobal.NumberToString((p_TRInfo.m_ValueY / f_Unit) - 100, f_YGridPrecision)
            else
                f_Value := TFNGlobal.NumberToString(p_TRInfo.m_ValueY / f_Unit, f_YGridPrecision);

            f_YLabelWidth := f_ChartBlock.m_AxisRightPadding + CFNQConst.CHART_DRAW_YLABEL_WIDTH;
            p_W := m_PosValueLayer.Bitmap.TextWidth(f_Value) + 4;

            if (p_W < f_YLabelWidth) then
                p_W := f_YLabelWidth
            else
                p_W := p_W;

            f_TextHeight := m_PosValueLayer.Bitmap.TextHeight(f_Value);
            p_W := p_W;
            p_H := f_TextHeight + 3;
            p_X := m_BoundRect.right - f_YLabelWidth+1;

            p_Y := Round(p_TRInfo.m_WindowY - (p_H / 2));
            if ((p_X + p_W) > m_BoundRect.right) then
                p_X := m_BoundRect.right - p_W;

            //Y축 좌표 정보 그린다.
            DrawTraceYValueFrame(p_X, p_Y, p_W, p_H);

            m_PosValueLayer.Bitmap.RenderText(
                (p_X + p_W - m_PosValueLayer.Bitmap.TextWidth(f_Value) - 2),
                (p_TRInfo.m_WindowY - f_TextHeight div 2), f_Value, 0, FontColor);
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.OnMouseLeave();
begin
    ClearActiveLayer;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.ReCalculator(var p_ChartDataSeries:CFNQStreamChartDataSeries; var p_PriceArray:CFNQLineValueSeries);
var
    f_ChartIndex, f_ObjectIndex : Integer;
    p_ValueArray : CFNQLineValueSeries;

    f_ADX :Integer;
    f_ADX_NMA : Integer;
    f_PDI : Integer;
    f_MDI : Integer;
    f_PDMSUM : Integer;
    f_MDMSUM : Integer;
    f_TRSUM : Integer;
    f_PDM : Integer;
    f_MDM : Integer;
    f_TR : Integer;

    f_ChartBlock : CFNQChartBlock;
begin
    f_ADX := 0;
    f_ADX_NMA := 1;
    f_PDI := 2;
    f_MDI := 3;
    f_PDMSUM := 4;
    f_MDMSUM := 5;
    f_TRSUM := 6;
    f_PDM := 7;
    f_MDM := 8;
    f_TR := 9;

    for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]);
        f_ChartBlock.SetChartDataSeries(p_ChartDataSeries);

        for f_ObjectIndex := 0 to f_ChartBlock.m_ObjectArray.Count - 1 do
        begin
            p_ValueArray := CFNQLineValueSeries(f_ChartBlock.m_ObjectArray.Items[f_ObjectIndex]);
            case p_ValueArray.m_Type of

                CFNQConst.LINESERIES_PRICE :
                begin
                end;
                CFNQConst.LINESERIES_CLOSE :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_Close(m_ChartDataSeries);
                end;
                CFNQConst.LINESERIES_MA :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0);
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 1);
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 2);
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[3]), p_PriceArray, 3, 3);
                end;
                CFNQConst.LINESERIES_ILMOK :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_IMLine(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), p_PriceArray, 1, 2, 3, 0);
                end;
                CFNQConst.LINESERIES_BB :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_BBand(Math.Floor(p_ValueArray.m_Options[0]), 2, p_PriceArray, 3, 0);
                end;
                CFNQConst.LINESERIES_ENVELOPE :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_Envelope(Math.Floor(p_ValueArray.m_Options[0]), p_ValueArray.m_Options[1], p_PriceArray, 3, 0);
                end;
                CFNQConst.LINESERIES_SAR :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_SAR(p_ValueArray.m_Options[0], p_PriceArray, 1, 2, 3, 0);
                end;
                CFNQConst.LINESERIES_MAMULOVERLAY :
                begin
                    p_ValueArray.Clear();
                end;
                CFNQConst.LINESERIES_VOLUME :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_Volume(m_ChartDataSeries);
                end;
                CFNQConst.LINESERIES_MACD :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_MACD(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0);
                end;
                CFNQConst.LINESERIES_ADX :
                begin

                    f_ADX := 0;
                    f_ADX_NMA := 1;
                    f_PDI := 2;
                    f_MDI := 3;
                    f_PDMSUM := 4;
                    f_MDMSUM := 5;
                    f_TRSUM := 6;
                    f_PDM := 7;
                    f_MDM := 8;
                    f_TR := 9;

                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_TrueRange(p_PriceArray, 1, 2, 3, f_TR);
                    p_ValueArray.Indicator_PMDM(p_PriceArray, 1, 2, 3, f_PDM);
                    p_ValueArray.Indicator_PMDI(Math.Floor(p_ValueArray.m_Options[0]), p_ValueArray, f_PDM, f_PDI);
                    p_ValueArray.Indicator_ADX(Math.Floor(p_ValueArray.m_Options[1]), p_ValueArray, f_PDI, f_MDI, f_ADX);
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[2]), p_ValueArray, f_ADX, f_ADX_NMA);
                end;
                CFNQConst.LINESERIES_DMI :
                begin

                    f_ADX := 0;
                    f_ADX_NMA := 1;
                    f_PDI := 2;
                    f_MDI := 3;
                    f_PDMSUM := 4;
                    f_MDMSUM := 5;
                    f_TRSUM := 6;
                    f_PDM := 7;
                    f_MDM := 8;
                    f_TR := 9;


                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_TrueRange(p_PriceArray, 1, 2, 3, f_TR - 2);
                    p_ValueArray.Indicator_PMDM(p_PriceArray, 1, 2, 3, f_PDM - 2);
                    p_ValueArray.Indicator_PMDI(Math.Floor(p_ValueArray.m_Options[0]), p_ValueArray, f_PDM - 2, f_PDI - 2);
                    end;
                CFNQConst.LINESERIES_RSI :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_RSI(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 0);
                end;
                CFNQConst.LINESERIES_OBV :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_OBV(p_PriceArray, 3, p_PriceArray, 4, 0);
                end;
                CFNQConst.LINESERIES_FASTSTC :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_FastSTC(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), p_PriceArray, 1, 2, 3, 0);
                end;
                CFNQConst.LINESERIES_SLOWSTC :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_SlowSTC(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), p_PriceArray, 1, 2, 3, 0);
                end;
                CFNQConst.LINESERIES_SONAR :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_SONA(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0);
                end;
                CFNQConst.LINESERIES_PMAO :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_PMAO(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 0);
                end;
                CFNQConst.LINESERIES_TRIX :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_TRIX(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 0);
                end;
                CFNQConst.LINESERIES_PSY :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_PSY(Math.Floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0);
                end;
                CFNQConst.LINESERIES_CCI :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_CCI(Math.Floor(p_ValueArray.m_Options[0]), p_PriceArray, 1, 2, 3, 0);
                end;
                CFNQConst.LINESERIES_VR :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_VR(Math.Floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, p_PriceArray, 4, 0);
                end;
                CFNQConst.LINESERIES_WILLIAM :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_WilliamsR(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), p_PriceArray, 1, 2, 3, 0);
                end;
                CFNQConst.LINESERIES_ROC :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_ROC(Math.Floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0);
                end;
                CFNQConst.LINESERIES_NET :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_NET(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0);
                end;
                CFNQConst.LINESERIES_COMPARECLOSE :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_CompareClose(p_ChartDataSeries, p_ValueArray.m_ChartDataSeries);
                end;
                CFNQConst.LINESERIES_ATR :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_ATR(Math.Floor(p_ValueArray.m_Options[0]), p_PriceArray, 1, 2, 3, 0);
                end;
                CFNQConst.LINESERIES_PRICE_AT_OPS :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_Close(m_ChartDataSeries);
                end;
                CFNQConst.LINESERIES_OPS :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_OPS(p_ChartDataSeries);
                end;
                CFNQConst.LINESERIES_OPSIGUK :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_OPS_IGUK(p_ChartDataSeries);
                end;
                CFNQConst.LINESERIES_OPSIGUK2 :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_OPS_IGUK2(Math.Floor(p_ValueArray.m_Options[0]), p_ChartDataSeries);
                end;
                CFNQConst.LINESERIES_OPSREL :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_OPS_REL(Math.Floor(p_ValueArray.m_Options[0]), p_ChartDataSeries);
                end;
                CFNQConst.LINESERIES_OPSSTDDEV :
                begin
                    p_ValueArray.Clear();
                    p_ValueArray.Indicator_OPS_STD(Math.Floor(p_ValueArray.m_Options[0]), p_ChartDataSeries);
                end;
            end;

            p_ValueArray.GetLineMaxMin(0, p_ValueArray.m_Items.Count - 1, 0 + f_ChartBlock.m_CompareOffset, f_ChartBlock.m_CompareState);
            if  (
                    (f_ChartBlock.m_ChartIndex = 0) AND
                    (
                        (p_ValueArray.m_Type = CFNQConst.LINESERIES_PRICE_AT_OPS) or
                        (p_ValueArray.m_Type = CFNQConst.LINESERIES_OPS) or
                        (p_ValueArray.m_Type = CFNQConst.LINESERIES_OPSIGUK) or
                        (p_ValueArray.m_Type = CFNQConst.LINESERIES_OPSIGUK2) or
                        (p_ValueArray.m_Type = CFNQConst.LINESERIES_OPSREL) or
                        (p_ValueArray.m_Type = CFNQConst.LINESERIES_OPSSTDDEV)
                    )
                )
            then
            begin


            end else
            if (p_ValueArray.m_Effect) then
            begin
                f_ChartBlock.m_AbsMaxMin.m_XMin := 0;
                f_ChartBlock.m_AbsMaxMin.m_XMax := p_ChartDataSeries.m_Items.Count - 1;
                f_ChartBlock.m_AbsMaxMin.m_YMin := p_ValueArray.m_MaxMinTable[0].m_YMin;
                f_ChartBlock.m_AbsMaxMin.m_YMax := p_ValueArray.m_MaxMinTable[0].m_YMax;
            end;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.UpdateCalculator(var p_ChartDataSeries:CFNQStreamChartDataSeries; var p_PriceArray:CFNQLineValueSeries; p_Range:Boolean);
var
    f_nChartIndex, f_nObjectIndex : Integer;
    p_ValueArray : CFNQLineValueSeries;

    f_ADX :Integer;
    f_ADX_NMA : Integer;
    f_PDI : Integer;
    f_MDI : Integer;
    f_PDMSUM : Integer;
    f_MDMSUM : Integer;
    f_TRSUM : Integer;
    f_PDM : Integer;
    f_MDM : Integer;
    f_TR : Integer;

    f_Begin, f_End : Integer;

    f_ChartBlock : CFNQChartBlock;
begin
    f_ADX := 0;
    f_ADX_NMA := 1;
    f_PDI := 2;
    f_MDI := 3;
    f_PDMSUM := 4;
    f_MDMSUM := 5;
    f_TRSUM := 6;
    f_PDM := 7;
    f_MDM := 8;
    f_TR := 9;

    f_Begin := p_PriceArray.m_Items.Count-1;
    f_End := p_ChartDataSeries.m_Items.Count;

    if m_UseOPSPrice then
    begin
        p_PriceArray.Indicator_OPS_Price(p_ChartDataSeries, f_Begin, f_End);
    end else
    begin
        p_PriceArray.Indicator_Price(p_ChartDataSeries, f_Begin, f_End);
    end;

    for f_nChartIndex := 0 to m_ChartArray.Count - 1 do
    begin
        f_ChartBlock := CFNQChartBlock(m_ChartArray.Items[f_nChartIndex]);
        f_ChartBlock.SetChartDataSeries(p_ChartDataSeries);

        for f_nObjectIndex := 0 to f_ChartBlock.m_ObjectArray.Count - 1 do
        begin
            p_ValueArray := CFNQLineValueSeries(f_ChartBlock.m_ObjectArray.Items[f_nObjectIndex]);
            case p_ValueArray.m_Type of

                CFNQConst.LINESERIES_PRICE :
                begin
                    //p_ValueArray.Clear();
                    //p_ValueArray.Indicator_Price(m_ChartDataSeries);
                end;
                CFNQConst.LINESERIES_CLOSE :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_Close(m_ChartDataSeries);
                end;
                CFNQConst.LINESERIES_MA :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0, f_Begin, f_End);
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 1, f_Begin, f_End);
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 2, f_Begin, f_End);
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[3]), p_PriceArray, 3, 3, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_ILMOK :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_IMLine(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_BB :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_BBand(Math.Floor(p_ValueArray.m_Options[0]), 2, p_PriceArray, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_ENVELOPE :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_Envelope(Math.Floor(p_ValueArray.m_Options[0]), p_ValueArray.m_Options[1], p_PriceArray, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_SAR :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_SAR(p_ValueArray.m_Options[0], p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_MAMULOVERLAY :
                begin
                    //p_ValueArray.Clear();
                end;
                CFNQConst.LINESERIES_VOLUME :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_Volume(m_ChartDataSeries, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_MACD :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_MACD(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_ADX :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_TrueRange(p_PriceArray, 1, 2, 3, f_TR, f_Begin, f_End);
                    p_ValueArray.Indicator_PMDM(p_PriceArray, 1, 2, 3, f_PDM, f_Begin, f_End);
                    p_ValueArray.Indicator_PMDI(Math.Floor(p_ValueArray.m_Options[0]), p_ValueArray, f_PDM, f_PDI, f_Begin, f_End);
                    p_ValueArray.Indicator_ADX(Math.Floor(p_ValueArray.m_Options[1]), p_ValueArray, f_PDI, f_MDI, f_ADX, f_Begin, f_End);
                    p_ValueArray.Indicator_NAverage(Math.Floor(p_ValueArray.m_Options[2]), p_ValueArray, f_ADX, f_ADX_NMA, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_DMI :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_TrueRange(p_PriceArray, 1, 2, 3, f_TR - 2, f_Begin, f_End);
                    p_ValueArray.Indicator_PMDM(p_PriceArray, 1, 2, 3, f_PDM - 2, f_Begin, f_End);
                    p_ValueArray.Indicator_PMDI(Math.Floor(p_ValueArray.m_Options[0]), p_ValueArray, f_PDM - 2, f_PDI - 2, f_Begin, f_End);
                    end;
                CFNQConst.LINESERIES_RSI :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_RSI(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_OBV :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_OBV(p_PriceArray, 3, p_PriceArray, 4, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_FASTSTC :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_FastSTC(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_SLOWSTC :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_SlowSTC(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_SONAR :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_SONA(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_PMAO :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_PMAO(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_TRIX :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_TRIX(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_PSY :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_PSY(Math.Floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_CCI :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_CCI(Math.Floor(p_ValueArray.m_Options[0]), p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_VR :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_VR(Math.Floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, p_PriceArray, 4, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_WILLIAM :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_WilliamsR(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_ROC :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_ROC(Math.Floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_NET :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_NET(Math.Floor(p_ValueArray.m_Options[0]), Math.Floor(p_ValueArray.m_Options[1]), Math.Floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_COMPARECLOSE :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_CompareClose(p_ChartDataSeries, p_ValueArray.m_ChartDataSeries, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_ATR :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_ATR(Math.Floor(p_ValueArray.m_Options[0]), p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_PRICE_AT_OPS :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_Close(m_ChartDataSeries);
                end;
                CFNQConst.LINESERIES_OPS :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_OPS(m_ChartDataSeries, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_OPSIGUK :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_OPS_IGUK(m_ChartDataSeries, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_OPSIGUK2 :
                begin
                    //p_ValueArray.Clear();
                    p_ValueArray.Indicator_OPS_IGUK2(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_OPSREL :
                begin
                   // p_ValueArray.Clear();
                    p_ValueArray.Indicator_OPS_REL(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries, f_Begin, f_End);
                end;
                CFNQConst.LINESERIES_OPSSTDDEV :
                begin
                   // p_ValueArray.Clear();
                    p_ValueArray.Indicator_OPS_STD(Math.Floor(p_ValueArray.m_Options[0]), m_ChartDataSeries, f_Begin, f_End);
                end;
            end;

            if (p_Range) then
            begin
                p_ValueArray.GetLineMaxMin(0, p_ValueArray.m_Items.Count - 1, 0 + f_ChartBlock.m_CompareOffset, f_ChartBlock.m_CompareState);
                if  (
                        (f_ChartBlock.m_ChartIndex = 0) AND
                        (
                            (p_ValueArray.m_Type = CFNQConst.LINESERIES_PRICE_AT_OPS) or
                            (p_ValueArray.m_Type = CFNQConst.LINESERIES_OPS) or
                            (p_ValueArray.m_Type = CFNQConst.LINESERIES_OPSIGUK) or
                            (p_ValueArray.m_Type = CFNQConst.LINESERIES_OPSIGUK2) or
                            (p_ValueArray.m_Type = CFNQConst.LINESERIES_OPSREL) or
                            (p_ValueArray.m_Type = CFNQConst.LINESERIES_OPSSTDDEV)
                        )
                    )
                then
                begin


                end else
                if (p_ValueArray.m_Effect) then
                begin
                    f_ChartBlock.m_AbsMaxMin.m_XMin := 0;
                    f_ChartBlock.m_AbsMaxMin.m_XMax := p_ChartDataSeries.m_Items.Count - 1;
                    f_ChartBlock.m_AbsMaxMin.m_YMin := p_ValueArray.m_MaxMinTable[0].m_YMin;
                    f_ChartBlock.m_AbsMaxMin.m_YMax := p_ValueArray.m_MaxMinTable[0].m_YMax;
                end;
            end;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartBlockManager.OnPaintOverLayerManager(Sender: TObject; Buffer: TBitmap32);
var
    f_ChartIndex    : Integer;
    f_ClipRect      : TRect;
begin
    try
        for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
        begin
            f_ClipRect := Rect(m_BoundRect.Left, m_BoundRect.Top, CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]).m_AxisRect.Right-1, m_BoundRect.Bottom);
            Buffer.ResetClipRect;
            Buffer.ClipRect := f_ClipRect;

            CFNQChartBlock(m_ChartArray.Items[f_ChartIndex]).OnPaintOverLayer(Sender, Buffer);

            Buffer.ResetClipRect;
            Buffer.ClipRect := m_BoundRect;
        end;
    finally
    end;
end;


end.
