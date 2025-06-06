unit MKAVChartBlockManager;

interface

uses
  SysUtils, Types, Classes, Math, GR32, StdCtrls, Messages, Windows, GR32_Layers, Contnrs, ExtCtrls,
  MKStreamChartDataSeries, MKColorSet, MKConst, MKMaxMin, FNThread, SyncObjs, Graphics,
  MKChartData, MKLineValueSeries,
  MKAVChartBlock, MKAVPosInfo, MKAVChartTraceEvent, MKAVPosValue;

type
  pTPoint = ^TPoint;

  CMKChartBlockManager = class(TObject)
  private
    m_ChartCollection: TList;
    m_Scale: Integer;
    m_ChartControl: TObject;
    m_ColorSet: CMKColorSet;
    m_ColorSetIndex: Integer;

    m_ScrollBar: TScrollBar;

    m_OverLayer: TBitmapLayer;
    m_TraceLayer: TBitmapLayer;
    m_PosValueLayer: TBitmapLayer;
    m_LabelLayer: TBitmapLayer;
    m_DrawLayer: TBitmapLayer;
    m_SignalLayer: TBitmapLayer;

    m_XExtraGap: Integer;

    m_TraceVisible: Boolean;
    m_XLabel: Boolean;

    m_UseOPSPrice: Boolean;

    m_SignalChartIndex: Integer;
    m_Signal: Integer;
    m_SignalStart: Integer;
    m_SignalEnd: Integer;
    m_SignalPosition: Integer;
    m_LastTRInfo: CMKPosInfo;

  public
    m_BoundRect: TRect;
    m_ChartDataSeries: CMKStreamChartDataSeries;
    m_ChartType: Integer;
    m_XMaxMin: Integer;

    constructor Create();
    destructor Destroy(); override;
    procedure SetUseOPSPrice(AValue: Boolean);

    procedure SetColorSetIndex(p_Value: Integer; p_Paint: Boolean = false);
    function GetColorSet(): CMKColorSet;

    procedure SetChartControl(p_ChartControl: TObject);

    procedure SetBound(p_Left: Integer; p_Top: Integer; p_Width: Integer; p_Height: Integer);
    procedure OnResize(p_Left: Integer; p_Top: Integer; p_Width: Integer; p_Height: Integer; p_Paint: Boolean);
    procedure LayOut();

    function AddChart(p_Name: String): CMKChartBlock;
    function InsertChart(p_Name: String): CMKChartBlock;
    procedure DeleteChart(p_Name: String);
    function FindChart(p_Name: String): CMKChartBlock;
    procedure DeleteChartAll();

    procedure DeleteTradeStrategyAll();

    procedure ClearChartAll;
    procedure Clear();
    procedure Draw(p_Bitmap: TBitmap32);
    procedure RePaint();

    procedure SetChartDataSeries(p_ChartDataSeries: CMKStreamChartDataSeries);
    procedure SetScale(p_Scale: Integer);
    function GetMaxMin(): CMKMaxMin;
    procedure FirstEnlarge(p_Paint: Boolean);
    procedure RangeEnlarge(f_XMin: Double = -1; f_XMax: Double = -1; p_SetScrollBarPropertis: Boolean = true;
        p_Notify: Boolean = true);
    procedure SetXMaxMin(p_Value: Integer);
    procedure ReEnlarge(p_Value: Integer);

    procedure EnlargeValue(p_Paint: Boolean; p_Value: Integer);
    procedure Enlarge(p_Rratio: Integer; p_Paint: Boolean = false);
    procedure AllRange(p_SetScrollBarPropertis: Boolean = true);

    procedure SetScrollBar(p_ScrollBar: TScrollBar);
    procedure OnHScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure SetScrollBarPosition(p_Notify: Boolean = true);

    procedure ClearTraceLayer();
    procedure ClearPosValueLayer();
    procedure ClearActiveLayer();
    procedure ClearLabelLayer();
    procedure ClearSignalLayer;

    procedure OnMouseDown(p_X: Integer; p_Y: Integer);
    procedure OnMouseUp(p_X: Integer; p_Y: Integer);
    procedure OnMouseMove(p_X: Integer; p_Y: Integer);
    procedure OnMouseLeave();

    function RequestPrevData(p_XDirection: Integer; p_XMinDate: TDateTime; p_XMaxDate: TDateTime; p_XMinOffset: Integer;
        p_XMaxOffset: Integer): Boolean;
    function RequestNextData(p_XDirection: Integer; p_XMinDate: TDateTime; p_XMaxDate: TDateTime; p_XMinOffset: Integer;
        p_XMaxOffset: Integer): Boolean;
    procedure DrawTraceCaption(p_ValueX: Integer);
    procedure TraceXYOnSometime(p_TRInfo: CMKPosInfo);

    procedure TraceXYOnAnytime(p_TRInfo: CMKPosInfo);
    procedure SetXExtraGap(p_X: Integer);
    procedure ClearTrace();
    procedure SetTraceVisible(p_Value: Boolean; p_Paint: Boolean = false);

    procedure DrawPosValueFrame(p_X: Integer; p_Y: Integer; p_Width: Integer; p_Height: Integer; p_CX: Integer; p_CY: Integer;
        p_Direct: Integer);
    procedure DrawTraceXValueFrame(p_X: Integer; p_Y: Integer; p_Width: Integer; p_Height: Integer);
    procedure DrawTraceYValueFrame(p_X: Integer; p_Y: Integer; p_Width: Integer; p_Height: Integer);
    procedure DrawTracePannel(p_TRInfo: CMKPosInfo);

    procedure SetLayer();

    procedure SetVisibleXLabel(p_Value: Boolean);
    function GetVisibleXLabel(): Boolean;

    procedure EndDrawObject();
    procedure StartDrawObject(p_NobjectType: Integer);
    procedure SetDrawObjectColor(p_Color: TColor32);
    procedure StartDrawingCharObject(p_TextList: TStrings; p_font: TFont);

    procedure DrawLayOut();
    procedure DrawObjectXDateToValue();
    procedure DrawObjectXValueToDate();

    procedure ReCalculator(var p_ChartDataSeries: CMKStreamChartDataSeries; var p_PriceArray: CMKLineValueSeries);
    procedure UpdateCalculator(var p_ChartDataSeries: CMKStreamChartDataSeries; var p_PriceArray: CMKLineValueSeries;
        p_Range: Boolean);

    procedure OnPaintOverLayerManager(Sender: TObject; Buffer: TBitmap32);
    procedure DrawTraceDate(p_Index: Integer; p_ValueX: Double);

    procedure SignalTrace(p_ChartIndex, p_Signal, p_Start, p_End, p_Position: Integer);
    procedure SignalTraceFromOuterChart(p_ChartIndex, p_Signal, p_Start, p_End, p_Position: Integer);
    procedure TraceOnLastTime;

  end;

implementation

uses
  MKGlobal, MKAVChartControl, MKChartDefine;

constructor CMKChartBlockManager.Create();
begin
  inherited Create();

  m_ChartCollection := TList.Create();
  m_ChartType := CMKConst.CHART_NORMAL;
  m_Scale := 1;
  m_ColorSet := CMKColorSet.Create();
  m_ColorSet.Initialize();
  SetColorSetIndex(0);

  m_XExtraGap := 0;
  m_TraceVisible := true;
  // m_TRInfo        := NIL;
  m_XLabel := true;
  m_UseOPSPrice := false;

  m_Signal := 0;
  m_SignalStart := 0;
  m_SignalEnd := 0;
  m_SignalPosition := 0;

  m_LastTRInfo := CMKPosInfo.Create;
  m_LastTRInfo.m_ChartIndex := -999;

end;

// ---------------------------------------------------------------------------
destructor CMKChartBlockManager.Destroy();
var
  nTry: Integer;
begin
  if Assigned(m_ChartCollection) then
  begin
    DeleteChartAll();

    m_ChartCollection.Free();
    m_ChartCollection := NIL;
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

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.SetLayer();
begin
  m_OverLayer := TBitmapLayer.Create(CMKAVChartControl(m_ChartControl).Layers);
  m_OverLayer.Bitmap.DrawMode := dmBlend;
  m_OverLayer.Bitmap.CombineMode := cmMerge;
  m_OverLayer.OnPaint := OnPaintOverLayerManager;

  m_SignalLayer := TBitmapLayer.Create(CMKAVChartControl(m_ChartControl).Layers);
  m_SignalLayer.Bitmap.DrawMode := dmBlend;
  m_SignalLayer.Bitmap.CombineMode := cmMerge;

  m_TraceLayer := TBitmapLayer.Create(CMKAVChartControl(m_ChartControl).Layers);
  m_TraceLayer.Bitmap.DrawMode := dmBlend;
  m_TraceLayer.Bitmap.CombineMode := cmMerge;

  m_PosValueLayer := TBitmapLayer.Create(CMKAVChartControl(m_ChartControl).Layers);
  m_PosValueLayer.Bitmap.DrawMode := dmBlend;
  m_PosValueLayer.Bitmap.CombineMode := cmMerge;

  m_LabelLayer := TBitmapLayer.Create(CMKAVChartControl(m_ChartControl).Layers);
  m_LabelLayer.Bitmap.DrawMode := dmBlend;
  m_LabelLayer.Bitmap.CombineMode := cmMerge;

  m_DrawLayer := TBitmapLayer.Create(CMKAVChartControl(m_ChartControl).Layers);
  m_DrawLayer.Bitmap.DrawMode := dmBlend;
  m_DrawLayer.Bitmap.CombineMode := cmMerge;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.SetColorSetIndex(p_Value: Integer; p_Paint: Boolean = false);
begin
  m_ColorSetIndex := p_Value;
  m_ColorSet.SetColorSetIndex(m_ColorSetIndex);
  if (p_Paint) then
  begin
    RePaint();
  end;
end;

// ---------------------------------------------------------------------------
function CMKChartBlockManager.GetColorSet(): CMKColorSet;
begin
  Result := m_ColorSet;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.SetChartControl(p_ChartControl: TObject);
begin
  m_ChartControl := p_ChartControl;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.SetBound(p_Left: Integer; p_Top: Integer; p_Width: Integer; p_Height: Integer);
begin
  m_BoundRect := TMKGlobal.Rect2(p_Left, p_Top, p_Width, p_Height);
  LayOut();
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.OnResize(p_Left: Integer; p_Top: Integer; p_Width: Integer; p_Height: Integer; p_Paint: Boolean);
begin
  m_BoundRect := TMKGlobal.Rect2(p_Left, p_Top, p_Width, p_Height);
  if (p_Paint) then
  begin
    LayOut();
    SetScrollBarPosition();
    RePaint();
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.LayOut();
var
  f_ChartBlock: CMKChartBlock;
  f_Left, f_Top, f_Right, f_Bottom: Integer;
  f_ChartIndex: Integer;
  f_InterHeight: Integer;
  f_SpaceRect: TRect;
begin
  if (m_ChartCollection.Count = 0) then
    exit;

  f_SpaceRect := TMKGlobal.Rect2(m_BoundRect.left, m_BoundRect.top - 1, RectWidth(m_BoundRect), RectHeight(m_BoundRect) + 2);

  if (m_ChartCollection.Count = 1) then
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[0]);
    f_ChartBlock.SetBound(f_SpaceRect.left, f_SpaceRect.top, f_SpaceRect.right, f_SpaceRect.bottom);
  end
  else
  begin
    f_Left := f_SpaceRect.left;
    f_Top := f_SpaceRect.top;
    f_Right := f_SpaceRect.right;
    f_Bottom := f_SpaceRect.top + Round(9.0 / (12.0 + 2 * (m_ChartCollection.Count - 1)) * RectHeight(f_SpaceRect));
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[0]);
    f_ChartBlock.SetBound(f_Left, f_Top, f_Right, f_Bottom);
    f_SpaceRect.top := f_Bottom;

    for f_ChartIndex := 1 to m_ChartCollection.Count - 1 do
    begin
      f_Top := f_Bottom;
      if (f_ChartIndex = m_ChartCollection.Count - 1) then
        f_Bottom := f_SpaceRect.bottom
      else
        f_Bottom := f_Top + Round(RectHeight(f_SpaceRect) / (m_ChartCollection.Count - 1));

      f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]);
      f_ChartBlock.SetBound(f_Left, f_Top, f_Right, f_Bottom);
      f_Bottom := f_Bottom - 1;

    end;
  end;

  m_TraceLayer.Location := FloatRect(m_BoundRect.left, m_BoundRect.top, m_BoundRect.right, m_BoundRect.bottom);
  m_TraceLayer.Bitmap.SetSize(TMKGlobal.RectToWidth(m_BoundRect), TMKGlobal.RectToHeight(m_BoundRect));

  f_SpaceRect := Rect(m_BoundRect.left, m_BoundRect.top, m_BoundRect.right, m_BoundRect.bottom);
  f_SpaceRect.right := f_ChartBlock.m_AxisRect.right;
  m_OverLayer.Location := FloatRect(f_SpaceRect.left, f_SpaceRect.top, f_SpaceRect.right, f_SpaceRect.bottom);
  m_OverLayer.Bitmap.SetSize(TMKGlobal.RectToWidth(f_SpaceRect), TMKGlobal.RectToHeight(f_SpaceRect));

  m_SignalLayer.Location := FloatRect(f_SpaceRect.left, f_SpaceRect.top, f_SpaceRect.right, f_SpaceRect.bottom);
  m_SignalLayer.Bitmap.SetSize(TMKGlobal.RectToWidth(f_SpaceRect), TMKGlobal.RectToHeight(f_SpaceRect));

  m_PosValueLayer.Location := FloatRect(m_BoundRect.left, m_BoundRect.top, m_BoundRect.right, m_BoundRect.bottom);
  m_PosValueLayer.Bitmap.SetSize(TMKGlobal.RectToWidth(m_BoundRect), TMKGlobal.RectToHeight(m_BoundRect));

  m_LabelLayer.Location := FloatRect(m_BoundRect.left, m_BoundRect.top, m_BoundRect.right, m_BoundRect.bottom);
  m_LabelLayer.Bitmap.SetSize(TMKGlobal.RectToWidth(m_BoundRect), TMKGlobal.RectToHeight(m_BoundRect));

  f_SpaceRect.left := CMKChartBlock(m_ChartCollection.Items[0]).m_AxisRect.left;
  f_SpaceRect.top := CMKChartBlock(m_ChartCollection.Items[0]).m_AxisRect.top;
  f_SpaceRect.right := CMKChartBlock(m_ChartCollection.Items[0]).m_AxisRect.right;
  f_SpaceRect.bottom := CMKChartBlock(m_ChartCollection.Items[0]).m_AxisRect.bottom;
  m_DrawLayer.Location := FloatRect(f_SpaceRect.left, f_SpaceRect.top, f_SpaceRect.right, f_SpaceRect.bottom);
  m_DrawLayer.Bitmap.SetSize(TMKGlobal.RectToWidth(f_SpaceRect), TMKGlobal.RectToHeight(f_SpaceRect));
  DrawLayOut();

end;

// ---------------------------------------------------------------------------
function CMKChartBlockManager.AddChart(p_Name: String): CMKChartBlock;
var
  f_ChartBlock: CMKChartBlock;
  f_ChartIndex: Integer;
begin
  f_ChartBlock := CMKChartBlock.Create();

  f_ChartBlock.m_ChartBlockManager := Self;
  f_ChartBlock.m_Name := p_Name;

  f_ChartBlock.m_TraceLayer := m_TraceLayer;
  f_ChartBlock.m_OverLayer := m_OverLayer;
  f_ChartBlock.m_SignalLayer := m_SignalLayer;

  f_ChartBlock.m_LabelLayer := m_LabelLayer;
  f_ChartBlock.m_DrawLayer := m_DrawLayer;

  f_ChartBlock.m_ChartIndex := m_ChartCollection.Count;
  f_ChartBlock.SetChartDataSeries(m_ChartDataSeries);
  f_ChartBlock.SetXExtraGap(m_XExtraGap);
  f_ChartBlock.m_ColorSet := m_ColorSet;

  if (f_ChartBlock.m_Name = g_IndicatorName[IND_PRICE_NAME]) then
    f_ChartBlock.SetScale(m_Scale)
  else
    f_ChartBlock.SetScale(0);

  m_ChartCollection.Add(f_ChartBlock);
  for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
  begin
    CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]).m_ChartIndex := f_ChartIndex;
  end;

  Result := f_ChartBlock;
end;

// ---------------------------------------------------------------------------
function CMKChartBlockManager.InsertChart(p_Name: String): CMKChartBlock;
var
  f_ChartBlock: CMKChartBlock;
  f_ChartIndex: Integer;
begin
  f_ChartBlock := CMKChartBlock.Create();

  f_ChartBlock.m_ChartBlockManager := Self;
  f_ChartBlock.m_Name := p_Name;

  f_ChartBlock.m_TraceLayer := m_TraceLayer;
  f_ChartBlock.m_OverLayer := m_OverLayer;
  f_ChartBlock.m_SignalLayer := m_SignalLayer;

  f_ChartBlock.m_ChartIndex := m_ChartCollection.Count;
  f_ChartBlock.SetChartDataSeries(m_ChartDataSeries);
  f_ChartBlock.SetXExtraGap(m_XExtraGap);
  f_ChartBlock.m_ColorSet := m_ColorSet;

  if (f_ChartBlock.m_Name = g_IndicatorName[IND_PRICE_NAME]) then
    f_ChartBlock.SetScale(m_Scale)
  else
    f_ChartBlock.SetScale(0);

  if (m_ChartCollection.Count > 0) then
    m_ChartCollection.Insert(m_ChartCollection.Count - 1, f_ChartBlock)
  else
    m_ChartCollection.Add(f_ChartBlock);

  for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
  begin
    CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]).m_ChartIndex := f_ChartIndex;
  end;

  Result := f_ChartBlock;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.DeleteChart(p_Name: String);
var
  f_Index: Integer;
  f_ChartIndex: Integer;
  f_ChartBlock: CMKChartBlock;
  f_FindChart: CMKChartBlock;
begin
  f_FindChart := NIL;
  for f_Index := 0 to m_ChartCollection.Count - 1 do
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
    if (f_ChartBlock.m_Name = p_Name) then
    begin
      f_FindChart := f_ChartBlock;
      f_FindChart.ClearObject();
      f_FindChart.Free();
      m_ChartCollection.Delete(f_Index);
      break;
    end;
  end;

  for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
  begin
    CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]).m_ChartIndex := f_ChartIndex;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.DeleteChartAll();
var
  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
  f_Search: Boolean;
  f_LineIndex: Integer;
  f_LineValueSeries: CMKLineValueSeries;
begin
  while (0 < m_ChartCollection.Count) do
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[0]);
    f_Search := false;
    for f_LineIndex := 0 to f_ChartBlock.m_ObjectCollection.Count - 1 do
    begin
      f_LineValueSeries := f_ChartBlock.m_ObjectCollection[f_LineIndex];
      if f_LineValueSeries.m_TradeStrategy then
      begin
        f_Search := true;
        break;
      end;
    end;
    if f_Search then
    begin
      f_ChartBlock.ClearObject(false);
    end
    else
    begin
      f_ChartBlock.ClearObject();
    end;
    f_ChartBlock.Free();

    m_ChartCollection.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.DeleteTradeStrategyAll();
var
  f_ChartIndex: Integer;
  f_LineIndex: Integer;
  f_ChartBlock: CMKChartBlock;
  f_LineValueSeries: CMKLineValueSeries;
  f_Done: Boolean;
  f_Search: Boolean;
begin
  f_Done := false;
  while (not f_Done) do
  begin
    f_Done := true;
    for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
    begin
      f_ChartBlock := m_ChartCollection.Items[f_ChartIndex];
      f_Search := false;
      for f_LineIndex := 0 to f_ChartBlock.m_ObjectCollection.Count - 1 do
      begin
        f_LineValueSeries := f_ChartBlock.m_ObjectCollection[f_LineIndex];
        if f_LineValueSeries.m_TradeStrategy then
        begin
          f_Search := true;
          break;
        end;
      end;
      if f_Search then
      begin
        f_ChartBlock.ClearObject(false);
        f_ChartBlock.Free();
        m_ChartCollection.Delete(f_ChartIndex);
        f_Done := false;
        break;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.ClearChartAll();
var
  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
begin
  for f_Index := 0 to m_ChartCollection.Count - 1 do
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
    f_ChartBlock.ClearObject();
    f_ChartBlock.m_ChartIndex := f_Index;
    f_ChartBlock.SetChartDataSeries(NIL);
    f_ChartBlock.m_ColorSet := m_ColorSet;
  end;
end;

// ---------------------------------------------------------------------------
function CMKChartBlockManager.FindChart(p_Name: String): CMKChartBlock;
var
  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
  f_FindChart: CMKChartBlock;
begin
  f_FindChart := NIL;

  for f_Index := 0 to m_ChartCollection.Count - 1 do
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
    if (f_ChartBlock.m_Name = p_Name) then
    begin
      f_FindChart := f_ChartBlock;
      break;
    end;
  end;

  Result := f_FindChart;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.Clear();
var
  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
begin
  ClearTraceLayer();
  ClearPosValueLayer();
  ClearLabelLayer();
  ClearSignalLayer;

  for f_Index := 0 to m_ChartCollection.Count - 1 do
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
    f_ChartBlock.Clear();
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.ClearTraceLayer();
begin
  if (Assigned(m_TraceLayer)) then
  begin
    m_TraceLayer.Bitmap.Clear($00000000);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.ClearActiveLayer();
begin
  if (Assigned(m_OverLayer)) then
  begin
    m_OverLayer.Bitmap.Clear($00000000);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.ClearSignalLayer();
begin
  if (Assigned(m_SignalLayer)) then
  begin
    m_SignalLayer.Bitmap.Clear($00000000);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.ClearPosValueLayer();
begin
  if (Assigned(m_PosValueLayer)) then
  begin
    m_PosValueLayer.Bitmap.Clear($00000000);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.ClearLabelLayer();
begin
  if (Assigned(m_LabelLayer)) then
  begin
    m_LabelLayer.Bitmap.Clear($00000000);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.Draw(p_Bitmap: TBitmap32);
var
  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
begin
  try
    if (0 < m_ChartCollection.Count) then
    begin
      for f_Index := 0 to m_ChartCollection.Count - 1 do
      begin
        f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
        f_ChartBlock.Paint(p_Bitmap);

        f_ChartBlock.InitCaption();

        p_Bitmap.ResetClipRect;
        p_Bitmap.ClipRect := m_BoundRect;
      end;
      if m_Signal <> 0 then
      begin
        SignalTrace(m_SignalChartIndex, m_Signal, m_SignalStart, m_SignalEnd, m_SignalPosition);
      end;
    end
    else
    begin
      (*
        CMKAVChartControl(m_ChartControl).CreateVirualChart;
        for f_Index := 0 to m_ChartCollection.Count - 1 do
        begin
        f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
        f_ChartBlock.m_ColorSet := m_ColorSet;
        f_ChartBlock.Paint(p_Bitmap);

        p_Bitmap.ResetClipRect;
        p_Bitmap.ClipRect := m_BoundRect;
        end;
      *)
      p_Bitmap.Clear(m_ColorSet.m_Color[CMKColorSet.CHART_BACKGROUND_COLOR]);
    end;
  finally
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.RePaint();
begin
  try
    Clear();
    CMKAVChartControl(m_ChartControl).Invalidate;
  finally
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.SetChartDataSeries(p_ChartDataSeries: CMKStreamChartDataSeries);
var
  f_Index: Integer;
begin
  m_Signal := 0;
  m_ChartDataSeries := p_ChartDataSeries;
  for f_Index := 0 to m_ChartCollection.Count - 1 do
  begin
    CMKChartBlock(m_ChartCollection.Items[f_Index]).m_ChartDataSeries := m_ChartDataSeries;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.SetScale(p_Scale: Integer);
var
  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
begin
  m_Scale := p_Scale;
  for f_Index := 0 to m_ChartCollection.Count - 1 do
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
    if (f_ChartBlock.m_Name = g_IndicatorName[IND_PRICE_NAME]) then
      f_ChartBlock.SetScale(m_Scale)
    else
      f_ChartBlock.SetScale(0);
  end;
end;

// ---------------------------------------------------------------------------
function CMKChartBlockManager.GetMaxMin(): CMKMaxMin;
begin
  Result := CMKChartBlock(m_ChartCollection.Items[0]).m_MaxMin;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.SetXMaxMin(p_Value: Integer);
var
  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
begin
  m_XMaxMin := p_Value;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.SignalTrace(p_ChartIndex, p_Signal, p_Start, p_End, p_Position: Integer);
var
  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
begin
  m_SignalChartIndex := p_ChartIndex;
  m_Signal := p_Signal;
  m_SignalStart := p_Start;
  m_SignalEnd := p_End;
  m_SignalPosition := p_Position;

  ClearSignalLayer;

  if p_Signal = 0 then
    exit;
  if p_Start = -1 then
    exit;

  for f_Index := 0 to m_ChartCollection.Count - 1 do
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
    f_ChartBlock.DrawSignalTrace(p_Signal, p_Start, p_End);
  end;

end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.SignalTraceFromOuterChart(p_ChartIndex, p_Signal, p_Start, p_End, p_Position: Integer);
var
  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
  f_Signal, f_Start, f_End, f_Position: Integer;
begin
  ClearSignalLayer;
  if (p_ChartIndex >= 0) AND (p_ChartIndex < m_ChartCollection.Count) then
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[p_ChartIndex]);
    if Assigned(f_ChartBlock) then
    begin
      m_SignalPosition := p_Position;
      if f_ChartBlock.GetSignalRange(m_Signal, m_SignalStart, m_SignalEnd, m_SignalPosition) then
      begin
        ClearSignalLayer;
        for f_Index := 0 to m_ChartCollection.Count - 1 do
        begin
          f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
          f_ChartBlock.DrawSignalTrace(m_Signal, m_SignalStart, m_SignalEnd);
        end;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.ReEnlarge(p_Value: Integer);
var
  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
begin
  m_XMaxMin := p_Value;
  for f_Index := 0 to m_ChartCollection.Count - 1 do
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
    f_ChartBlock.ReEnlarge(p_Value);
  end;

  SetScrollBarPosition();

  RePaint();
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.FirstEnlarge(p_Paint: Boolean);
var
  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
begin
  for f_Index := 0 to m_ChartCollection.Count - 1 do
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
    f_ChartBlock.FirstEnlarge();
  end;

  SetScrollBarPosition();

  if (p_Paint) then
  begin
    RePaint();
  end;

end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.EnlargeValue(p_Paint: Boolean; p_Value: Integer);
var
  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
begin
  for f_Index := 0 to m_ChartCollection.Count - 1 do
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
    f_ChartBlock.EnlargeValue(p_Value);
  end;

  SetScrollBarPosition();

  if (p_Paint) then
  begin
    RePaint();
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.Enlarge(p_Rratio: Integer; p_Paint: Boolean = false);
var
  f_PriceChart: CMKChartBlock;
  f_Action: Boolean;
  f_MaxMin: CMKMaxMin;
  f_AbsMin, f_AbsMax, f_MaxMinMin, f_MaxMinMax: Double;
  f_XMinDate, f_XMaxDate: TDateTime;
  f_XMinOffset, f_XMaxOffset: Double;

  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
begin
  f_Action := false;
  f_PriceChart := CMKChartBlock(m_ChartCollection.Items[0]);
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
    for f_Index := 0 to m_ChartCollection.Count - 1 do
    begin
      f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
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

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.AllRange(p_SetScrollBarPropertis: Boolean = true);
var
  f_XMin, f_XMax: Double;
begin
  f_XMin := 0;
  RangeEnlarge(f_XMin, f_XMax, p_SetScrollBarPropertis);
end;

// ---------------------------------------------------------------------------
// 특정 X축의 영역에 해당하는 최대, 최소값을 계산한다.
procedure CMKChartBlockManager.RangeEnlarge(f_XMin: Double = -1; f_XMax: Double = -1; p_SetScrollBarPropertis: Boolean = true;
    p_Notify: Boolean = true);
var
  f_Index: Integer;
  f_SmallSize: Integer;
begin
  if (m_ChartCollection.Count > 0) then
  begin
    if (f_XMin = -1) then
      f_XMin := CMKChartBlock(m_ChartCollection.Items[0]).m_MaxMin.m_XMin;

    if (f_XMax = -1) then
      f_XMax := CMKChartBlock(m_ChartCollection.Items[0]).m_MaxMin.m_XMax;
  end;

  for f_Index := 0 to m_ChartCollection.Count - 1 do
  begin
    CMKChartBlock(m_ChartCollection.Items[f_Index]).RangeEnlarge(f_XMin, f_XMax, true);
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
  if Assigned(CMKAVChartControl(m_ChartControl).OnChange) then
    CMKAVChartControl(m_ChartControl).OnChange(m_ChartControl);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.SetScrollBar(p_ScrollBar: TScrollBar);
begin
  m_ScrollBar := p_ScrollBar;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.OnHScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
var
  f_ChartBlock: CMKChartBlock;
  f_XMin, f_XMax, f_Position, f_PageSize: Double;

  f_XDirection: Integer;
  f_XMinDate, f_XMaxDate: TDateTime;
  f_ChartData1: CMKChartData;
  f_ChartData0: CMKChartData;
  f_XMinOffset, f_XMaxOffset: Integer;
begin
  if (m_ScrollBar = NIL) then
    exit;

  if (m_ChartDataSeries = NIL) then
    exit;

  if (m_ChartCollection.Count = 0) then
    exit;

  if (ScrollPos > m_ScrollBar.Max - m_ScrollBar.PageSize) then
  begin
    ScrollPos := m_ScrollBar.Max - m_ScrollBar.PageSize + 1;
  end;

  f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[0]);
  f_XMin := ScrollPos;
  f_XMax := f_XMin + f_ChartBlock.m_XSize;
  if (f_XMin <> f_ChartBlock.m_MaxMin.m_XMin) then
    RangeEnlarge(f_XMin, f_XMax, false, true);

  if (f_XMin = 0) then
  begin

    f_ChartData0 := CMKChartData(m_ChartDataSeries.m_Items.Items[Math.floor(f_ChartBlock.m_MaxMin.m_XMin)]);
    f_ChartData1 := CMKChartData(m_ChartDataSeries.m_Items.Items[Math.floor(f_ChartBlock.m_MaxMin.m_XMax)]);

    if ((f_ChartData0 <> NIL) and (f_ChartData1 <> NIL)) then
    begin
      f_XMinDate := f_ChartData0.m_CloseDateTime;
      f_XMaxDate := f_ChartData1.m_CloseDateTime;
      f_XMinOffset := 0;
      f_XMaxOffset := 0;
      f_XDirection := 0;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.SetScrollBarPosition(p_Notify: Boolean = true);
var
  f_ChartBlock: CMKChartBlock;
  f_XMin, f_XMax: Integer;
  f_Position, f_PageSize: Integer;
  n: Integer;
begin
  if (m_ScrollBar = NIL) then
    exit;
  if (m_ChartDataSeries = NIL) then
    exit;
  if (m_ChartCollection.Count = 0) then
    exit;

  f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[0]);
  f_XMin := Round(f_ChartBlock.m_AbsMaxMin.m_XMin);
  f_XMax := Round(f_ChartBlock.m_AbsMaxMin.m_XMax + f_ChartBlock.m_PaddingRight + f_ChartBlock.m_XExtraGap);
  f_PageSize := Round(f_ChartBlock.m_XSize) + 1;
  f_Position := Round(f_ChartBlock.m_MaxMin.m_XMin);

  if ((f_Position = 0) and (0 >= Max(0, f_XMax - f_PageSize))) then
  begin
    m_ScrollBar.Enabled := false;
  end
  else
  begin
    m_ScrollBar.Enabled := true;
    m_ScrollBar.PageSize := 0;
    m_ScrollBar.SetParams(f_Position, f_XMin, Max(0, f_XMax));
    m_ScrollBar.PageSize := f_PageSize;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.OnMouseDown(p_X: Integer; p_Y: Integer);
var
  m_EventRect: TRect;
  f_ChartIndex, f_MouseChartIndex: Integer;
begin
  f_MouseChartIndex := -1;
  for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
  begin
    m_EventRect := TMKGlobal.Rect2(CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]).m_BoundRect.left,
        CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]).m_BoundRect.top,
        TMKGlobal.RectToWidth(CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]).m_BoundRect) - 50,
        TMKGlobal.RectToHeight(CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]).m_BoundRect));

    if (PtInRect(m_EventRect, Point(p_X, p_Y))) then
    begin
      f_MouseChartIndex := f_ChartIndex;
      break;
    end;
  end;

  if (f_MouseChartIndex >= 0) then
    CMKChartBlock(m_ChartCollection.Items[f_MouseChartIndex]).OnMouseDown(p_X, p_Y);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.OnMouseUp(p_X: Integer; p_Y: Integer);
var
  m_EventRect: TRect;
  f_CaptureMouse: Boolean;
  f_ChartIndex, f_MouseChartIndex: Integer;
begin
  f_CaptureMouse := false;

  f_MouseChartIndex := -1;
  for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
  begin
    if (CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]).m_CaptureMouse) then
    begin
      f_MouseChartIndex := f_ChartIndex;
      f_CaptureMouse := true;
      break;
    end;
  end;

  if (f_MouseChartIndex < 0) then
  begin
    for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
    begin
      m_EventRect := TMKGlobal.Rect2(CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]).m_BoundRect.left,
          CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]).m_BoundRect.top,
          TMKGlobal.RectToWidth(CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]).m_BoundRect) - 50,
          TMKGlobal.RectToHeight(CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]).m_BoundRect));

      if (PtInRect(m_EventRect, Point(p_X, p_Y))) then
      begin
        f_MouseChartIndex := f_ChartIndex;
        break;
      end;
    end;
  end;

  if (f_MouseChartIndex >= 0) then
    CMKChartBlock(m_ChartCollection.Items[f_MouseChartIndex]).OnMouseUp(p_X, p_Y);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.OnMouseMove(p_X: Integer; p_Y: Integer);
var
  m_EventRect: TRect;
  f_ChartIndex, f_MouseChartIndex: Integer;
  f_ChartBlock: CMKChartBlock;
begin
  try
    for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
    begin
      f_ChartBlock := m_ChartCollection.Items[f_ChartIndex];
      m_EventRect := TMKGlobal.Rect2(f_ChartBlock.m_BoundRect.left, f_ChartBlock.m_BoundRect.top,
          TMKGlobal.RectToWidth(f_ChartBlock.m_BoundRect) - 50, TMKGlobal.RectToHeight(f_ChartBlock.m_BoundRect));

      if (PtInRect(m_EventRect, Point(p_X, p_Y))) then
      begin
        f_ChartBlock.OnMouseMoveOnAnytime(p_X, p_Y);
        f_ChartBlock.OnMouseMoveSometime(p_X, p_Y);
      end;
    end;
  finally
  end;
end;

// ---------------------------------------------------------------------------
function CMKChartBlockManager.RequestPrevData(p_XDirection: Integer; p_XMinDate: TDateTime; p_XMaxDate: TDateTime;
    p_XMinOffset: Integer; p_XMaxOffset: Integer): Boolean;
begin
  Result := false;
end;

// ---------------------------------------------------------------------------
function CMKChartBlockManager.RequestNextData(p_XDirection: Integer; p_XMinDate: TDateTime; p_XMaxDate: TDateTime;
    p_XMinOffset: Integer; p_XMaxOffset: Integer): Boolean;
begin
  Result := false;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.DrawTraceCaption(p_ValueX: Integer);
var
  f_Index: Integer;
begin
  ClearLabelLayer;

  for f_Index := 0 to m_ChartCollection.Count - 1 do
  begin
    CMKChartBlock(m_ChartCollection.Items[f_Index]).DrawCaption(p_ValueX);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.TraceXYOnSometime(p_TRInfo: CMKPosInfo);
begin
  if (m_TraceVisible) then
    DrawTracePannel(p_TRInfo);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.DrawTraceDate(p_Index: Integer; p_ValueX: Double);
var
  f_pt: TPoint;
  m_EventRect: TRect;
  f_ChartIndex, f_MouseChartIndex: Integer;
  f_ChartBlock: CMKChartBlock;
  f_X, f_Y, f_Index: Integer;
  f_PosInfo: CMKPosInfo;
begin
  try
    if (m_TraceVisible) then
    begin
      ClearTraceLayer();
      for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
      begin
        f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]);
        f_ChartBlock.DrawTraceDate(p_ValueX);
      end;
      DrawTraceCaption(Math.floor(p_ValueX));

      if (m_ChartCollection.Count > 0) then
      begin
        f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[0]);
        f_PosInfo := CMKPosInfo.Create();
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

      if (p_Index >= 0) AND (p_Index < m_ChartCollection.Count) then
      begin
        f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[p_Index]);
        if Assigned(f_ChartBlock) then
        begin
          m_SignalPosition := floor(p_ValueX);
          if f_ChartBlock.GetSignalRange(m_Signal, m_SignalStart, m_SignalEnd, m_SignalPosition) then
          begin
            ClearSignalLayer;
            for f_Index := 0 to m_ChartCollection.Count - 1 do
            begin
              f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
              f_ChartBlock.DrawSignalTrace(m_Signal, m_SignalStart, m_SignalEnd);
            end;
          end;
        end;
      end;
    end;
  finally
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.TraceXYOnAnytime(p_TRInfo: CMKPosInfo);
var
  f_Index: Integer;
  f_ChartData: CMKChartData;
begin
  m_LastTRInfo.m_ChartIndex := p_TRInfo.m_ChartIndex;
  m_LastTRInfo.m_MX := p_TRInfo.m_MX;
  m_LastTRInfo.m_MY := p_TRInfo.m_MY;
  m_LastTRInfo.m_ValueX := p_TRInfo.m_ValueX;
  m_LastTRInfo.m_ValueY := p_TRInfo.m_ValueY;
  m_LastTRInfo.m_WindowX := p_TRInfo.m_WindowX;
  m_LastTRInfo.m_WindowY := p_TRInfo.m_WindowY;
  m_LastTRInfo.m_ActiveObjectIndex := p_TRInfo.m_ActiveObjectIndex;
  m_LastTRInfo.m_ActiveLineIndex := p_TRInfo.m_ActiveLineIndex;
  m_LastTRInfo.m_OverLine := p_TRInfo.m_OverLine;
  m_LastTRInfo.m_RealX := p_TRInfo.m_RealX;
  m_LastTRInfo.m_RealY := p_TRInfo.m_RealY;

  CMKAVChartControl(m_ChartControl).DrawTrace(Round(p_TRInfo.m_ValueX));
  if (m_TraceVisible) then
  begin
    ClearTraceLayer();
    for f_Index := 0 to m_ChartCollection.Count - 1 do
    begin
      CMKChartBlock(m_ChartCollection.Items[f_Index]).DrawTrace(p_TRInfo);
    end;
  end;

  if m_ChartDataSeries = nil then
    exit;
  if m_ChartDataSeries.m_Items.Count <= p_TRInfo.m_ValueX then
    exit;

  if Assigned(CMKAVChartControl(m_ChartControl).OnChartTraceChange) then
  begin
    f_ChartData := m_ChartDataSeries.m_Items[floor(p_TRInfo.m_ValueX)];
    CMKAVChartControl(m_ChartControl).OnChartTraceChange(p_TRInfo.m_ChartIndex, f_ChartData.m_CloseDateTime);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.TraceOnLastTime;
var
  f_Index: Integer;
  f_ChartData: CMKChartData;
  f_ChartBlock: CMKChartBlock;
begin
  if m_LastTRInfo.m_ChartIndex = -999 then
    exit;
  if m_LastTRInfo.m_ChartIndex < 0 then
    exit;
  if m_LastTRInfo.m_ChartIndex >= m_ChartCollection.Count then
    exit;

  f_ChartBlock := m_ChartCollection.Items[0];
  m_LastTRInfo.m_ValueX := Math.floor(f_ChartBlock.GetRealX(m_LastTRInfo.m_MX, f_ChartBlock.m_MaxMin));
  m_LastTRInfo.m_ValueY := f_ChartBlock.GetRealY(m_LastTRInfo.m_MY, f_ChartBlock.m_MaxMin);

  if (m_LastTRInfo.m_ValueX > f_ChartBlock.m_AbsMaxMin.m_XMax) then
    m_LastTRInfo.m_ValueX := f_ChartBlock.m_AbsMaxMin.m_XMax;

  m_LastTRInfo.m_WindowX := Math.floor(f_ChartBlock.GetScreenXCenter(m_LastTRInfo.m_ValueX, f_ChartBlock.m_MaxMin));
  m_LastTRInfo.m_WindowY := Math.floor(f_ChartBlock.GetScreenY(m_LastTRInfo.m_ValueY, f_ChartBlock.m_MaxMin));

  CMKAVChartControl(m_ChartControl).DrawTrace(Round(m_LastTRInfo.m_ValueX));
  if (m_TraceVisible) then
  begin
    ClearTraceLayer();
    for f_Index := 0 to m_ChartCollection.Count - 1 do
    begin
      CMKChartBlock(m_ChartCollection.Items[f_Index]).DrawTrace(m_LastTRInfo);
      CMKChartBlock(m_ChartCollection.Items[f_Index]).InitCaption();
    end;
  end;

  TraceXYOnSometime(m_LastTRInfo);
  DrawTraceCaption(Math.floor(m_LastTRInfo.m_ValueX));
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.SetXExtraGap(p_X: Integer);
var
  f_OldXExtraGap: Integer;
  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
  p_Action: Boolean;

  f_XMin, f_XMax: Integer;
begin
  f_OldXExtraGap := m_XExtraGap;
  m_XExtraGap := p_X;
  for f_Index := 0 to m_ChartCollection.Count - 1 do
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
    f_ChartBlock.SetXExtraGap(m_XExtraGap);
  end;

  p_Action := false;
  if ((CMKChartBlock(m_ChartCollection.Items[0]).m_AbsMaxMin.m_XMax + CMKChartBlock(m_ChartCollection.Items[0]).m_PaddingRight +
      f_OldXExtraGap) = CMKChartBlock(m_ChartCollection.Items[0]).m_MaxMin.m_XMax) then
    p_Action := true;

  if (p_Action) then
  begin

    f_XMax := Math.floor(CMKChartBlock(m_ChartCollection.Items[0]).m_MaxMin.m_XMax - f_OldXExtraGap + m_XExtraGap);
    f_XMin := Math.floor(CMKChartBlock(m_ChartCollection.Items[0]).m_MaxMin.m_XMin);
    if (f_XMax > Math.floor(CMKChartBlock(m_ChartCollection.Items[0]).m_AbsMaxMin.m_XMax +
        CMKChartBlock(m_ChartCollection.Items[0]).m_PaddingRight + CMKChartBlock(m_ChartCollection.Items[0]).m_XExtraGap)) then
      f_XMax := Math.floor(CMKChartBlock(m_ChartCollection.Items[0]).m_AbsMaxMin.m_XMax +
          CMKChartBlock(m_ChartCollection.Items[0]).m_PaddingRight + CMKChartBlock(m_ChartCollection.Items[0]).m_XExtraGap);

    RangeEnlarge(f_XMin, f_XMax, false);
    RePaint();
  end
  else
  begin
    SetScrollBarPosition();
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.ClearTrace();
begin
  ClearTraceLayer();
  ClearPosValueLayer();
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.SetVisibleXLabel(p_Value: Boolean);
var
  f_Index: Integer;
  f_ChartBlock: CMKChartBlock;
begin
  m_XLabel := p_Value;
  for f_Index := 0 to m_ChartCollection.Count - 1 do
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_Index]);
    if (f_Index = 0) then
      f_ChartBlock.m_VisibleXLabel := m_XLabel
    else
      f_ChartBlock.m_VisibleXLabel := false;
  end;
end;

// ---------------------------------------------------------------------------
function CMKChartBlockManager.GetVisibleXLabel(): Boolean;
begin
  Result := m_XLabel;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.SetTraceVisible(p_Value: Boolean; p_Paint: Boolean = false);
begin
  m_TraceVisible := p_Value;
  if (not m_TraceVisible) and (p_Paint) then
  begin
    ClearTraceLayer();
    ClearPosValueLayer();
  end;
end;

procedure CMKChartBlockManager.SetUseOPSPrice(AValue: Boolean);
begin
  m_UseOPSPrice := AValue;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.DrawPosValueFrame(p_X: Integer; p_Y: Integer; p_Width: Integer; p_Height: Integer; p_CX: Integer;
    p_CY: Integer; p_Direct: Integer);
var
  PenColor: TColor32;
  FillColor: TColor32;
begin
  if (m_PosValueLayer = NIL) then
    exit;

  PenColor := m_ColorSet.m_Color[CMKColorSet.TRACE_VALUE_LINE_COLOR];
  PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));
  FillColor := m_ColorSet.m_Color[CMKColorSet.TRACE_VALUE_FILLED_COLOR];
  FillColor := SetAlpha(FillColor, TMKGlobal.GetAlphaValue(100));

  m_PosValueLayer.Bitmap.FillRectTS(p_X, p_Y, p_X + p_Width, p_Y + p_Height, FillColor);
  m_PosValueLayer.Bitmap.FrameRectTS(p_X, p_Y, p_X + p_Width, p_Y + p_Height, PenColor);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.DrawTraceXValueFrame(p_X: Integer; p_Y: Integer; p_Width: Integer; p_Height: Integer);
var
  PenColor: TColor32;
  FillColor: TColor32;
begin
  if (m_PosValueLayer = NIL) then
    exit;

  PenColor := m_ColorSet.m_Color[CMKColorSet.TRACE_XY_LINE_COLOR];
  PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));
  FillColor := m_ColorSet.m_Color[CMKColorSet.TRACE_XY_FILLED_COLOR];
  FillColor := SetAlpha(FillColor, TMKGlobal.GetAlphaValue(100));

  m_PosValueLayer.Bitmap.FillRectTS(p_X, p_Y, p_X + p_Width, p_Y + p_Height, FillColor);
  m_PosValueLayer.Bitmap.FrameRectTS(p_X, p_Y, p_X + p_Width, p_Y + p_Height, PenColor);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.DrawTraceYValueFrame(p_X: Integer; p_Y: Integer; p_Width: Integer; p_Height: Integer);
var
  PenColor: TColor32;
  FillColor: TColor32;
begin
  if (m_PosValueLayer = NIL) then
    exit;

  PenColor := m_ColorSet.m_Color[CMKColorSet.TRACE_XY_LINE_COLOR];
  PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));
  FillColor := m_ColorSet.m_Color[CMKColorSet.TRACE_XY_FILLED_COLOR];
  FillColor := SetAlpha(FillColor, TMKGlobal.GetAlphaValue(100));

  m_PosValueLayer.Bitmap.FillRectTS(p_X, p_Y, p_X + p_Width, p_Y + p_Height, FillColor);
  m_PosValueLayer.Bitmap.FrameRectTS(p_X, p_Y, p_X + p_Width, p_Y + p_Height, PenColor);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.DrawTracePannel(p_TRInfo: CMKPosInfo);
var
  f_Index, f_LineIndex, f_LineCount: Integer;
  f_ValueArray: TList;
  p_X, p_Y, p_W, p_H: Integer;
  p_ChartData: CMKChartData;
  p_PosValue: CMKPosValue;
  f_Value: String;
  f_Year, f_month, f_day, f_hour, f_min, f_sec: Integer;
  p_Enabled: Boolean;
  f_ChartBlock: CMKChartBlock;

  f_YGridPrecision: Integer;
  f_Unit: Integer;

  f_YLabelWidth: Integer;

  p_CX, p_CY: Integer;
  p_Direct: Integer;

  f_TextWdith: Integer;
  f_TextHeight: Integer;
  f_AreaHeight: Integer;
  f_OffsetY: Integer;
  FontColor: TColor32;
  f_AxisWidth: Integer;
begin
  ClearPosValueLayer();

  // m_PosValueLayer.Bitmap.MasterAlpha := TMKGlobal.GetAlphaValue(90);

  if ((p_TRInfo.m_ValueX >= 0) and (p_TRInfo.m_ValueX < m_ChartDataSeries.m_Items.Count)) then
  begin
    p_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[Math.floor(p_TRInfo.m_ValueX)]);
    f_Year := p_ChartData.m_Year;
    f_month := p_ChartData.m_Month;
    f_day := p_ChartData.m_Day;
    f_hour := p_ChartData.m_Hour;
    f_min := p_ChartData.m_Min;
    f_sec := p_ChartData.m_Sec;
    p_Enabled := true;
  end
  else
  begin
    p_Enabled := false;
  end;

  m_PosValueLayer.Bitmap.Font.Name := CMKColorSet.NUMBER2_FONT_FAMILY;
  m_PosValueLayer.Bitmap.Font.Size := CMKColorSet.NUMBER2_FONT_SMALLSIZE2;
  m_PosValueLayer.Bitmap.Font.Style := [];

  FontColor := m_ColorSet.m_Color[CMKColorSet.TRACE_XY_TEXT_COLOR];
  FontColor := SetAlpha(FontColor, TMKGlobal.GetAlphaValue(100));

  if (p_Enabled) then
  begin
    f_Value := TMKGlobal.DateToYYYY_MM_DD(f_Year, f_month, f_day);
    if (9000 < m_ChartDataSeries.m_TimeFrame) then
    begin
      f_Value := f_Value + ' ' + TMKGlobal.TimeToHH_MM_SS(f_hour, f_min, f_sec);
    end
    else if (360 > m_ChartDataSeries.m_TimeFrame) then
    begin
      f_Value := f_Value + ' ' + TMKGlobal.TimeToHH_MM(f_hour, f_min);
    end;

    p_W := m_PosValueLayer.Bitmap.TextWidth(f_Value) + 8;
    p_H := CMKConst.CHART_DRAW_XLABEL_HEIGHT;
    p_X := Math.floor(p_TRInfo.m_WindowX - (p_W / 2));
    p_Y := CMKChartBlock(m_ChartCollection.Items[0]).m_AxisRect.top +
        RectHeight(CMKChartBlock(m_ChartCollection.Items[0]).m_AxisRect) + 1;

    // X축 좌표 정보 그린다.
    DrawTraceXValueFrame(p_X, p_Y - 1, p_W, p_H + 3);

    f_TextHeight := m_PosValueLayer.Bitmap.TextHeight(f_Value);
    m_PosValueLayer.Bitmap.RenderText((p_X + 4), (p_Y + Math.floor((p_H - f_TextHeight) / 2)) + 1, f_Value, 0, FontColor);
  end;

  if p_TRInfo.m_ChartIndex >= 0 then
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[p_TRInfo.m_ChartIndex]);
    f_YGridPrecision := f_ChartBlock.GetScreenYGridPrecision();
    f_Unit := f_ChartBlock.GetUnit();

    if (f_ChartBlock.m_YGridSize <> 0.0) then
    begin
      f_Value := TMKGlobal.NumberToString(p_TRInfo.m_ValueY / f_Unit, f_YGridPrecision);

      f_YLabelWidth := f_ChartBlock.m_AxisRightPadding + CMKConst.CHART_DRAW_YLABEL_WIDTH;
      p_W := m_PosValueLayer.Bitmap.TextWidth(f_Value) + 4;

      if (p_W < f_YLabelWidth) then
        p_W := f_YLabelWidth
      else
        p_W := p_W;

      f_TextHeight := m_PosValueLayer.Bitmap.TextHeight(f_Value);
      p_W := p_W;
      p_H := f_TextHeight + 3;
      p_X := m_BoundRect.right - f_YLabelWidth + 1;

      p_Y := Round(p_TRInfo.m_WindowY - (p_H / 2));
      if ((p_X + p_W) > m_BoundRect.right) then
        p_X := m_BoundRect.right - p_W;

      // Y축 좌표 정보 그린다.
      DrawTraceYValueFrame(p_X, p_Y, p_W, p_H);

      m_PosValueLayer.Bitmap.RenderText((p_X + p_W - m_PosValueLayer.Bitmap.TextWidth(f_Value) - 2),
          (p_TRInfo.m_WindowY - f_TextHeight div 2), f_Value, 0, FontColor);
    end;
  end;
  (*
    if (p_TRInfo.m_OverLine) then
    begin
    f_ValueArray := TList.Create();
    CMKChartBlock(m_ChartCollection.Items[p_TRInfo.m_ChartIndex]).GetPosValue(Math.Floor(p_TRInfo.m_ValueX), f_ValueArray);
    f_LineCount := f_ValueArray.Count;
    if (m_ChartDataSeries.m_TimeFrame < 360) then
    f_LineCount := f_LineCount + 2
    else
    f_LineCount := f_LineCount + 1;

    m_PosValueLayer.Bitmap.Font.Name := CMKColorSet.STRING_FONT_FAMILY;
    m_PosValueLayer.Bitmap.Font.Size := CMKColorSet.STRING_FONT_SMALLSIZE;
    m_PosValueLayer.Bitmap.Font.Style := [];

    f_OffsetY       := 2;
    f_TextHeight    := m_PosValueLayer.Bitmap.TextHeight('8');
    f_AreaHeight    := f_TextHeight;

    p_CX := p_TRInfo.m_RealX;
    p_CY := p_TRInfo.m_RealY;
    p_H := f_LineCount * f_AreaHeight + (f_OffsetY*(f_LineCount+1));
    p_W := 125;
    p_X := p_TRInfo.m_RealX - p_W - 15;
    p_Y := p_TRInfo.m_RealY + 15;
    p_Direct := 1;

    if (p_X < m_BoundRect.left) then
    begin
    p_X := p_TRInfo.m_RealX + 15;
    p_Direct := 2;
    end;

    if (p_Y + p_H > m_BoundRect.bottom) then
    begin
    p_Y := p_TRInfo.m_RealY - p_H - 15;
    p_Direct := p_Direct * 2;
    end;

    DrawPosValueFrame(p_X, p_Y, p_W, p_H, p_CX, p_CY, p_Direct);
    f_LineIndex := 0;

    FontColor := m_ColorSet.m_Color[CMKColorSet.TRACE_VALUE_TEXT_COLOR];
    FontColor := SetAlpha(FontColor, TMKGlobal.GetAlphaValue(100));

    p_Y := p_Y + f_OffsetY;
    m_PosValueLayer.Bitmap.RenderText((p_X + 2), p_Y, g_ChartText[CT_CAPTION_DATE], 0, FontColor);

    f_Value := TMKGlobal.DateToYYYY_MM_DD(f_Year, f_month, f_day);
    m_PosValueLayer.Bitmap.RenderText((p_X + 120 - m_PosValueLayer.Bitmap.TextWidth(f_Value)), p_Y, f_Value, 0, FontColor);

    Inc(f_LineIndex);

    if (m_ChartDataSeries.m_TimeFrame < 360) then
    begin
    p_Y := p_Y + f_TextHeight + f_OffsetY;
    m_PosValueLayer.Bitmap.RenderText((p_X + 2), p_Y, g_ChartText[CT_CAPTION_DATETIME], 0, FontColor);

    f_Value := TMKGlobal.TimeToHH_MM(f_hour, f_min);
    m_PosValueLayer.Bitmap.RenderText((p_X + 120 - m_PosValueLayer.Bitmap.TextWidth(f_Value)), p_Y, f_Value, 0, FontColor);

    Inc(f_LineIndex);
    end;

    for f_Index := 0 to f_ValueArray.Count - 1 do
    begin
    p_PosValue := CMKPosValue(f_ValueArray.Items[f_Index]);

    m_PosValueLayer.Bitmap.Font.Name := CMKColorSet.STRING_FONT_FAMILY;
    m_PosValueLayer.Bitmap.Font.Size := CMKColorSet.STRING_FONT_SMALLSIZE;
    m_PosValueLayer.Bitmap.Font.Style := [];

    FontColor := m_ColorSet.m_Color[CMKColorSet.TRACE_VALUE_TEXT_COLOR];
    FontColor := SetAlpha(FontColor, TMKGlobal.GetAlphaValue(100));

    p_Y := p_Y + f_TextHeight + f_OffsetY;
    m_PosValueLayer.Bitmap.RenderText((p_X + 2), p_Y, p_PosValue.m_Name, 0, FontColor);

    f_Value := TMKGlobal.NumberToString(p_PosValue.m_Value, p_PosValue.m_Precision);
    m_PosValueLayer.Bitmap.RenderText(
    (p_X + 120 - m_PosValueLayer.Bitmap.TextWidth(f_Value)),
    p_Y,
    f_Value,
    0,
    FontColor
    );

    Inc(f_LineIndex);
    end;

    while (f_ValueArray.Count > 0) do
    begin
    CMKPosValue(f_ValueArray.Items[0]).Free();
    f_ValueArray.Delete(0);
    end;
    f_ValueArray.Free();
    end;
  *)
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.OnMouseLeave();
begin
  ClearActiveLayer;
  // ClearSignalLayer;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.ReCalculator(var p_ChartDataSeries: CMKStreamChartDataSeries;
    var p_PriceArray: CMKLineValueSeries);
var
  f_ChartIndex, f_ObjectIndex: Integer;
  p_ValueArray: CMKLineValueSeries;

  f_ADX: Integer;
  f_ADX_NMA: Integer;
  f_PDI: Integer;
  f_MDI: Integer;
  f_PDMSUM: Integer;
  f_MDMSUM: Integer;
  f_TRSUM: Integer;
  f_PDM: Integer;
  f_MDM: Integer;
  f_TR: Integer;

  f_ChartBlock: CMKChartBlock;
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

  for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]);
    f_ChartBlock.SetChartDataSeries(p_ChartDataSeries);

    for f_ObjectIndex := 0 to f_ChartBlock.m_ObjectCollection.Count - 1 do
    begin
      p_ValueArray := CMKLineValueSeries(f_ChartBlock.m_ObjectCollection.Items[f_ObjectIndex]);
      if not p_ValueArray.m_TradeStrategy then
      begin

        case p_ValueArray.m_Type of

          CMKConst.LINESERIES_PRICE:
            begin
            end;
          CMKConst.LINESERIES_CLOSE:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_Close(m_ChartDataSeries);
            end;
          CMKConst.LINESERIES_MA:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_NAverage(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0);
              p_ValueArray.Indicator_NAverage(Math.floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 1);
              p_ValueArray.Indicator_NAverage(Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 2);
              p_ValueArray.Indicator_NAverage(Math.floor(p_ValueArray.m_Options[3]), p_PriceArray, 3, 3);
            end;
          CMKConst.LINESERIES_ILMOK:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_IMLine(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 1, 2, 3, 0);
            end;
          CMKConst.LINESERIES_BB:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_BBand(Math.floor(p_ValueArray.m_Options[0]), p_ValueArray.m_Options[1],
                  p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_ENVELOPE:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_Envelope(Math.floor(p_ValueArray.m_Options[0]), p_ValueArray.m_Options[1],
                  p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_SAR:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_SAR(p_ValueArray.m_Options[0], p_PriceArray, 1, 2, 3, 0);
            end;
          CMKConst.LINESERIES_VOLUME:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_Volume(m_ChartDataSeries);
            end;
          CMKConst.LINESERIES_MACD:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_MACD(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_ADX:
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
              p_ValueArray.Indicator_PMDI(Math.floor(p_ValueArray.m_Options[0]), p_ValueArray, f_PDM, f_PDI);
              p_ValueArray.Indicator_ADX(Math.floor(p_ValueArray.m_Options[1]), p_ValueArray, f_PDI, f_MDI, f_ADX);
              p_ValueArray.Indicator_NAverage(Math.floor(p_ValueArray.m_Options[2]), p_ValueArray, f_ADX, f_ADX_NMA);
            end;
          CMKConst.LINESERIES_DMI:
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
              p_ValueArray.Indicator_PMDI(Math.floor(p_ValueArray.m_Options[0]), p_ValueArray, f_PDM - 2, f_PDI - 2);
            end;
          CMKConst.LINESERIES_RSI:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_RSI(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_OBV:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_OBV(p_PriceArray, 3, p_PriceArray, 4, 0);
            end;
          CMKConst.LINESERIES_FASTSTC:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_FastSTC(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  p_PriceArray, 1, 2, 3, 0);
            end;
          CMKConst.LINESERIES_SLOWSTC:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_SlowSTC(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 1, 2, 3, 0);
            end;
          CMKConst.LINESERIES_SONAR:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_SONA(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_PMAO:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_PMAO(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_TRIX:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_TRIX(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_PSY:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_PSY(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_CCI:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_CCI(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 1, 2, 3, 0);
            end;
          CMKConst.LINESERIES_VR:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_VR(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, p_PriceArray, 4, 0);
            end;
          CMKConst.LINESERIES_WILLIAM:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_WilliamsR(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  p_PriceArray, 1, 2, 3, 0);
            end;
          CMKConst.LINESERIES_ROC:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_ROC(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_NET:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_NET(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_ATR:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_ATR(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 1, 2, 3, 0);
            end;
          CMKConst.LINESERIES_PRICE_AT_OPS:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_Close(m_ChartDataSeries);
            end;
          CMKConst.LINESERIES_OPS:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_OPS(p_ChartDataSeries);
            end;
          CMKConst.LINESERIES_OPSIGUK:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_OPS_IGUK(p_ChartDataSeries);
            end;
          CMKConst.LINESERIES_OPSIGUK2:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_OPS_IGUK2(Math.floor(p_ValueArray.m_Options[0]), p_ChartDataSeries);
            end;
          CMKConst.LINESERIES_OPSREL:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_OPS_REL(Math.floor(p_ValueArray.m_Options[0]), p_ChartDataSeries);
            end;
          CMKConst.LINESERIES_OPSSTDDEV:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_OPS_STD(Math.floor(p_ValueArray.m_Options[0]), p_ChartDataSeries);
            end;
          CMKConst.LINESERIES_PRICE_MA_CROSS_SIGNAL:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_Price_MA_CrossSignal(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_MA_CROSS_SIGNAL:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_MA_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_MACD_CROSS_SIGNAL:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_MACD_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_SSTC_CROSS_SIGNAL:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_SlowSTC_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 1, 2, 3, 0);
            end;
          CMKConst.LINESERIES_FSTC_CROSS_SIGNAL:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_FastSTC_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), p_PriceArray, 1, 2, 3, 0);
            end;
          CMKConst.LINESERIES_RSI_CROSS_SIGNAL:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_RSI_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_ADX_CROSS_SIGNAL:
            begin

              f_ADX := 1;
              f_ADX_NMA := 2;
              f_PDI := 3;
              f_MDI := 4;
              f_PDMSUM := 5;
              f_MDMSUM := 6;
              f_TRSUM := 7;
              f_PDM := 8;
              f_MDM := 9;
              f_TR := 10;

              p_ValueArray.Clear();
              p_ValueArray.Indicator_TrueRange(p_PriceArray, 1, 2, 3, f_TR);
              p_ValueArray.Indicator_PMDM(p_PriceArray, 1, 2, 3, f_PDM);
              p_ValueArray.Indicator_PMDI(Math.floor(p_ValueArray.m_Options[0]), p_ValueArray, f_PDM, f_PDI);
              p_ValueArray.Indicator_ADX(Math.floor(p_ValueArray.m_Options[1]), p_ValueArray, f_PDI, f_MDI, f_ADX);
              p_ValueArray.Indicator_NAverage(Math.floor(p_ValueArray.m_Options[2]), p_ValueArray, f_ADX, f_ADX_NMA);
              p_ValueArray.Indicator_CrossSignal(p_ValueArray, 1, 2, 0);
            end;
          CMKConst.LINESERIES_WILLIAMSR_CROSS_SIGNAL:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_WilliamsR_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), p_PriceArray, 1, 2, 3, 0);
            end;
          CMKConst.LINESERIES_SONA_CROSS_SIGNAL:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_SONA_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_TRIX_CROSS_SIGNAL:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_TRIX_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_NMA_TREND_SIGNAL:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_NMA_TrendSignal(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_WMA_TREND_SIGNAL:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_WMA_TrendSignal(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0);
            end;
          CMKConst.LINESERIES_XMA_TREND_SIGNAL:
            begin
              p_ValueArray.Clear();
              p_ValueArray.Indicator_XMA_TrendSignal(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0);
            end;
        end;
      end;

      p_ValueArray.GetLineMaxMin(0, p_ValueArray.m_Items.Count - 1);
      if ((f_ChartBlock.m_ChartIndex = 0) AND ((p_ValueArray.m_Type = CMKConst.LINESERIES_PRICE_AT_OPS) or
          (p_ValueArray.m_Type = CMKConst.LINESERIES_OPS) or (p_ValueArray.m_Type = CMKConst.LINESERIES_OPSIGUK) or
          (p_ValueArray.m_Type = CMKConst.LINESERIES_OPSIGUK2) or (p_ValueArray.m_Type = CMKConst.LINESERIES_OPSREL) or
          (p_ValueArray.m_Type = CMKConst.LINESERIES_OPSSTDDEV))) then
      begin

      end
      else if (p_ValueArray.m_Effect) then
      begin
        f_ChartBlock.m_AbsMaxMin.m_XMin := 0;
        f_ChartBlock.m_AbsMaxMin.m_XMax := p_ChartDataSeries.m_Items.Count - 1;
        f_ChartBlock.m_AbsMaxMin.m_YMin := p_ValueArray.m_MaxMinTable[0].m_YMin;
        f_ChartBlock.m_AbsMaxMin.m_YMax := p_ValueArray.m_MaxMinTable[0].m_YMax;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.UpdateCalculator(var p_ChartDataSeries: CMKStreamChartDataSeries;
    var p_PriceArray: CMKLineValueSeries; p_Range: Boolean);
var
  f_nChartIndex, f_nObjectIndex: Integer;
  p_ValueArray: CMKLineValueSeries;

  f_ADX: Integer;
  f_ADX_NMA: Integer;
  f_PDI: Integer;
  f_MDI: Integer;
  f_PDMSUM: Integer;
  f_MDMSUM: Integer;
  f_TRSUM: Integer;
  f_PDM: Integer;
  f_MDM: Integer;
  f_TR: Integer;

  f_Begin, f_End: Integer;

  f_ChartBlock: CMKChartBlock;
begin
  if not Assigned(p_PriceArray) then
    exit;
  if not Assigned(p_PriceArray.m_Items) then
    exit;
  if not Assigned(p_ChartDataSeries) then
    exit;
  if not Assigned(p_ChartDataSeries.m_Items) then
    exit;

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

  f_Begin := p_PriceArray.m_Items.Count - 1;
  f_End := p_ChartDataSeries.m_Items.Count;

  if m_UseOPSPrice then
  begin
    p_PriceArray.Indicator_OPS_Price(p_ChartDataSeries, f_Begin, f_End);
  end
  else
  begin
    p_PriceArray.Indicator_Price(p_ChartDataSeries, f_Begin, f_End);
  end;

  for f_nChartIndex := 0 to m_ChartCollection.Count - 1 do
  begin
    f_ChartBlock := CMKChartBlock(m_ChartCollection.Items[f_nChartIndex]);
    f_ChartBlock.SetChartDataSeries(p_ChartDataSeries);

    for f_nObjectIndex := 0 to f_ChartBlock.m_ObjectCollection.Count - 1 do
    begin
      p_ValueArray := CMKLineValueSeries(f_ChartBlock.m_ObjectCollection.Items[f_nObjectIndex]);
      if not p_ValueArray.m_TradeStrategy then
      begin

        case p_ValueArray.m_Type of

          CMKConst.LINESERIES_PRICE:
            begin
              // p_ValueArray.Clear();
              // p_ValueArray.Indicator_Price(m_ChartDataSeries);
            end;
          CMKConst.LINESERIES_CLOSE:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_Close(m_ChartDataSeries);
            end;
          CMKConst.LINESERIES_MA:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_NAverage(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0, f_Begin, f_End);
              p_ValueArray.Indicator_NAverage(Math.floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 1, f_Begin, f_End);
              p_ValueArray.Indicator_NAverage(Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 2, f_Begin, f_End);
              p_ValueArray.Indicator_NAverage(Math.floor(p_ValueArray.m_Options[3]), p_PriceArray, 3, 3, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_ILMOK:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_IMLine(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_BB:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_BBand(Math.floor(p_ValueArray.m_Options[0]), p_ValueArray.m_Options[1], p_PriceArray, 3, 0,
                  f_Begin, f_End);
            end;
          CMKConst.LINESERIES_ENVELOPE:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_Envelope(Math.floor(p_ValueArray.m_Options[0]), p_ValueArray.m_Options[1], p_PriceArray, 3,
                  0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_SAR:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_SAR(p_ValueArray.m_Options[0], p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_VOLUME:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_Volume(m_ChartDataSeries, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_MACD:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_MACD(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_ADX:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_TrueRange(p_PriceArray, 1, 2, 3, f_TR, f_Begin, f_End);
              p_ValueArray.Indicator_PMDM(p_PriceArray, 1, 2, 3, f_PDM, f_Begin, f_End);
              p_ValueArray.Indicator_PMDI(Math.floor(p_ValueArray.m_Options[0]), p_ValueArray, f_PDM, f_PDI, f_Begin, f_End);
              p_ValueArray.Indicator_ADX(Math.floor(p_ValueArray.m_Options[1]), p_ValueArray, f_PDI, f_MDI, f_ADX,
                  f_Begin, f_End);
              p_ValueArray.Indicator_NAverage(Math.floor(p_ValueArray.m_Options[2]), p_ValueArray, f_ADX, f_ADX_NMA,
                  f_Begin, f_End);
            end;
          CMKConst.LINESERIES_DMI:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_TrueRange(p_PriceArray, 1, 2, 3, f_TR - 2, f_Begin, f_End);
              p_ValueArray.Indicator_PMDM(p_PriceArray, 1, 2, 3, f_PDM - 2, f_Begin, f_End);
              p_ValueArray.Indicator_PMDI(Math.floor(p_ValueArray.m_Options[0]), p_ValueArray, f_PDM - 2, f_PDI - 2,
                  f_Begin, f_End);
            end;
          CMKConst.LINESERIES_RSI:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_RSI(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  p_PriceArray, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_OBV:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_OBV(p_PriceArray, 3, p_PriceArray, 4, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_FASTSTC:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_FastSTC(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_SLOWSTC:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_SlowSTC(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_SONAR:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_SONA(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_PMAO:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_PMAO(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  p_PriceArray, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_TRIX:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_TRIX(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  p_PriceArray, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_PSY:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_PSY(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_CCI:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_CCI(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_VR:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_VR(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, p_PriceArray, 4, 0,
                  f_Begin, f_End);
            end;
          CMKConst.LINESERIES_WILLIAM:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_WilliamsR(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_ROC:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_ROC(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_NET:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_NET(Math.floor(p_ValueArray.m_Options[0]), Math.floor(p_ValueArray.m_Options[1]),
                  Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_ATR:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_ATR(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_PRICE_AT_OPS:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_Close(m_ChartDataSeries);
            end;
          CMKConst.LINESERIES_OPS:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_OPS(m_ChartDataSeries, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_OPSIGUK:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_OPS_IGUK(m_ChartDataSeries, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_OPSIGUK2:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_OPS_IGUK2(Math.floor(p_ValueArray.m_Options[0]), m_ChartDataSeries, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_OPSREL:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_OPS_REL(Math.floor(p_ValueArray.m_Options[0]), m_ChartDataSeries, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_OPSSTDDEV:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_OPS_STD(Math.floor(p_ValueArray.m_Options[0]), m_ChartDataSeries, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_PRICE_MA_CROSS_SIGNAL:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_Price_MA_CrossSignal(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0,
                  f_Begin, f_End);
            end;
          CMKConst.LINESERIES_MA_CROSS_SIGNAL:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_MA_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_MACD_CROSS_SIGNAL:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_MACD_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0,
                  f_Begin, f_End);
            end;
          CMKConst.LINESERIES_SSTC_CROSS_SIGNAL:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_SlowSTC_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 1, 2, 3, 0,
                  f_Begin, f_End);
            end;
          CMKConst.LINESERIES_FSTC_CROSS_SIGNAL:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_FastSTC_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_RSI_CROSS_SIGNAL:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_RSI_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_ADX_CROSS_SIGNAL:
            begin
              f_ADX := 1;
              f_ADX_NMA := 2;
              f_PDI := 3;
              f_MDI := 4;
              f_PDMSUM := 5;
              f_MDMSUM := 6;
              f_TRSUM := 7;
              f_PDM := 8;
              f_MDM := 9;
              f_TR := 10;
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_TrueRange(p_PriceArray, 1, 2, 3, f_TR, f_Begin, f_End);
              p_ValueArray.Indicator_PMDM(p_PriceArray, 1, 2, 3, f_PDM, f_Begin, f_End);
              p_ValueArray.Indicator_PMDI(Math.floor(p_ValueArray.m_Options[0]), p_ValueArray, f_PDM, f_PDI, f_Begin, f_End);
              p_ValueArray.Indicator_ADX(Math.floor(p_ValueArray.m_Options[1]), p_ValueArray, f_PDI, f_MDI, f_ADX,
                  f_Begin, f_End);
              p_ValueArray.Indicator_NAverage(Math.floor(p_ValueArray.m_Options[2]), p_ValueArray, f_ADX, f_ADX_NMA,
                  f_Begin, f_End);
              p_ValueArray.Indicator_CrossSignal(p_ValueArray, 1, 2, 0, f_Begin, f_End);

            end;
          CMKConst.LINESERIES_WILLIAMSR_CROSS_SIGNAL:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_WilliamsR_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), p_PriceArray, 1, 2, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_SONA_CROSS_SIGNAL:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_SONA_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), Math.floor(p_ValueArray.m_Options[2]), p_PriceArray, 3, 0,
                  f_Begin, f_End);
            end;
          CMKConst.LINESERIES_TRIX_CROSS_SIGNAL:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_TRIX_CrossSignal(Math.floor(p_ValueArray.m_Options[0]),
                  Math.floor(p_ValueArray.m_Options[1]), p_PriceArray, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_NMA_TREND_SIGNAL:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_NMA_TrendSignal(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_WMA_TREND_SIGNAL:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_WMA_TrendSignal(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0, f_Begin, f_End);
            end;
          CMKConst.LINESERIES_XMA_TREND_SIGNAL:
            begin
              // p_ValueArray.Clear();
              p_ValueArray.Indicator_XMA_TrendSignal(Math.floor(p_ValueArray.m_Options[0]), p_PriceArray, 3, 0, f_Begin, f_End);
            end;

        end;
      end;

      if (p_Range) then
      begin
        p_ValueArray.GetLineMaxMin(0, p_ValueArray.m_Items.Count - 1);
        if ((f_ChartBlock.m_ChartIndex = 0) AND ((p_ValueArray.m_Type = CMKConst.LINESERIES_PRICE_AT_OPS) or
            (p_ValueArray.m_Type = CMKConst.LINESERIES_OPS) or (p_ValueArray.m_Type = CMKConst.LINESERIES_OPSIGUK) or
            (p_ValueArray.m_Type = CMKConst.LINESERIES_OPSIGUK2) or (p_ValueArray.m_Type = CMKConst.LINESERIES_OPSREL) or
            (p_ValueArray.m_Type = CMKConst.LINESERIES_OPSSTDDEV))) then
        begin

        end
        else if (p_ValueArray.m_Effect) then
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

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.OnPaintOverLayerManager(Sender: TObject; Buffer: TBitmap32);
var
  f_ChartIndex: Integer;
  f_ClipRect: TRect;
begin
  try
    for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
    begin
      f_ClipRect := Rect(m_BoundRect.left, m_BoundRect.top, CMKChartBlock(m_ChartCollection.Items[f_ChartIndex])
          .m_AxisRect.right - 1, m_BoundRect.bottom);
      Buffer.ResetClipRect;
      Buffer.ClipRect := f_ClipRect;

      CMKChartBlock(m_ChartCollection.Items[f_ChartIndex]).OnPaintOverLayer(Sender, Buffer);

      Buffer.ResetClipRect;
      Buffer.ClipRect := m_BoundRect;
    end;
  finally
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.EndDrawObject();
var
  f_ChartIndex: Integer;
begin
  for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
  begin
    CMKChartBlock(m_ChartCollection[f_ChartIndex]).EndDrawObject();
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlockManager.StartDrawObject(p_NobjectType: Integer);
var
  f_ChartIndex: Integer;
begin
  for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
  begin
    CMKChartBlock(m_ChartCollection[f_ChartIndex]).StartDrawObject(p_NobjectType);
  end;
end;

procedure CMKChartBlockManager.SetDrawObjectColor(p_Color: TColor32);
var
  f_ChartIndex: Integer;
begin
  for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
  begin
    CMKChartBlock(m_ChartCollection[f_ChartIndex]).SetDrawObjectColor(p_Color);
  end;
end;

procedure CMKChartBlockManager.StartDrawingCharObject(p_TextList: TStrings; p_font: TFont);
var
  f_ChartIndex: Integer;
begin
  for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
  begin
    CMKChartBlock(m_ChartCollection[f_ChartIndex]).StartDrawingCharObject(p_TextList, p_font);
  end;
end;

procedure CMKChartBlockManager.DrawLayOut();
var
  f_ChartIndex: Integer;
begin
  for f_ChartIndex := 0 to m_ChartCollection.Count - 1 do
  begin
    CMKChartBlock(m_ChartCollection[f_ChartIndex]).DrawLayOut();
  end;
end;

procedure CMKChartBlockManager.DrawObjectXDateToValue();
var
  f_ChartBlockIndex: Integer;
begin
  for f_ChartBlockIndex := 0 to m_ChartCollection.Count - 1 do
  begin
    CMKChartBlock(m_ChartCollection[f_ChartBlockIndex]).DrawObjectXDateToValue();
  end;
end;

procedure CMKChartBlockManager.DrawObjectXValueToDate();
var
  f_ChartBlockIndex: Integer;
begin
  for f_ChartBlockIndex := 0 to m_ChartCollection.Count - 1 do
  begin
    CMKChartBlock(m_ChartCollection[f_ChartBlockIndex]).DrawObjectXValueToDate();
  end;
end;

end.
