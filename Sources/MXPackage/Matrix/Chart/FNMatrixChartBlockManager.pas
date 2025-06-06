unit FNMatrixChartBlockManager;

interface

uses
  SysUtils, Types, Classes, Math, GR32, StdCtrls, Messages, Windows,
  GR32_Layers, Contnrs, ExtCtrls,
  MKStreamChartDataSeries, FNMatrixColorSet, FNMatrixConst, MKMaxMin, FNQueue,
  FNThread, SyncObjs, Graphics,
  MKChartData, FNMatrixLineValueSeries,
  FNMatrixChartBlock, FNMatrixPosInfo, FNMatrixChartTraceEvent,
  FNMatrixPosValue;

type
  pTPoint = ^TPoint;

  CFNMatrixChartBlockManager = class(TObject)
  private
    m_ChartArray: TList;
    m_Scale: Integer;
    m_ChartControl: TObject;
    m_ColorSet: CFNMatrixColorSet;
    m_ColorSetIndex: Integer;

    m_ScrollBar: TScrollBar;
    m_ScrollEventEnable: Boolean;
    m_OverLayer: TBitmapLayer;
    m_TraceLayer: TBitmapLayer;
    m_PosValueLayer: TBitmapLayer;
    m_LabelLayer: TBitmapLayer;
    m_SignalLayer: TBitmapLayer;

    m_XExtraGap: Integer;

    m_TraceVisible: Boolean;
    m_XLabel: Boolean;

    m_State: Integer;
    m_RangeMinCount: Integer;

    m_UseOPSPrice: Boolean;
    m_UnitType: Integer;

    m_SignalChartIndex: Integer;
    m_Signal: Integer;
    m_SignalStart: Integer;
    m_SignalEnd: Integer;
    m_SignalPosition: Integer;
    m_LastTRInfo: CFNMatrixPosInfo;
    m_DisplayTypeOfTrade: Integer;

  public
    m_BoundRect: TRect;
    m_ChartDataSeries: CMKStreamChartDataSeries;
    m_ChartType: Integer;

    constructor Create;
    destructor Destroy; override;
    procedure SetUseOPSPrice(AValue: Boolean);
    procedure SetUnitType(AValue: Integer);

    procedure SetColorSetIndex(p_Value: Integer; p_Paint: Boolean = false);
    function GetColorSet: CFNMatrixColorSet;
    procedure SetChartControl(p_ChartControl: TObject);
    procedure SetBound(p_Left: Integer; p_Top: Integer; p_Width: Integer; p_Height: Integer);
    procedure OnResize(p_Left: Integer; p_Top: Integer; p_Width: Integer; p_Height: Integer; p_Paint: Boolean);
    procedure LayOut;
    function AddChart(p_Name: String): CFNMatrixChartBlock;
    function InsertChart(p_Name: String): CFNMatrixChartBlock;
    procedure DeleteChart(p_Name: String);
    procedure DeleteChartAll;
    procedure ClearChartAll;
    function FindChart(p_Name: String): CFNMatrixChartBlock;
    procedure Clear;
    procedure Draw(p_Bitmap: TBitmap32);
    procedure RePaint;
    procedure SetChartDataSeries(p_ChartDataSeries: CMKStreamChartDataSeries);
    procedure SetScale(p_Scale: Integer);
    function GetMaxMin: CMKMaxMin;
    procedure FirstEnlarge(p_Paint: Boolean);
    procedure FullEnlarge(p_Paint: Boolean);
    procedure RangeEnlarge(f_XMin: Double = -1000000; f_XMax: Double = -1000000; p_SetScrollBarPropertis: Boolean = true; p_Notify: Boolean = true);

    procedure EnlargeValue(p_Paint: Boolean; p_Value: Integer);
    procedure Enlarge(p_Rratio: Integer; p_Paint: Boolean = false);

    procedure SetScrollBar(p_ScrollBar: TScrollBar);
    procedure OnHScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure SetScrollBarPosition;

    procedure ClearTraceLayer;
    procedure ClearPosValueLayer;
    procedure ClearActiveLayer;
    procedure ClearLabelLayer;
    procedure ClearSignalLayer;

    procedure OnMouseDown(p_X: Integer; p_Y: Integer);
    procedure OnMouseUp(p_X: Integer; p_Y: Integer);
    procedure OnMouseMove(p_X: Integer; p_Y: Integer);
    procedure OnMouseLeave;

    procedure DrawTraceCaption(p_ValueX: Integer);

    procedure ClickPos(p_TRInfo: CFNMatrixPosInfo);
    procedure TraceXYOnSometime(p_TRInfo: CFNMatrixPosInfo);

    procedure TraceXYOnAnytime(p_TRInfo: CFNMatrixPosInfo);
    procedure SetXExtraGap(p_X: Integer);
    procedure ClearTrace;
    procedure SetTraceVisible(p_Value: Boolean; p_Paint: Boolean = false);

    procedure DrawPosValueFrame(p_X: Integer; p_Y: Integer; p_Width: Integer; p_Height: Integer; p_CX: Integer; p_CY: Integer; p_Direct: Integer);
    procedure DrawTraceXValueFrame(p_X: Integer; p_Y: Integer; p_Width: Integer; p_Height: Integer);
    procedure DrawTraceYValueFrame(p_X: Integer; p_Y: Integer; p_Width: Integer; p_Height: Integer);
    procedure DrawTracePannel(p_TRInfo: CFNMatrixPosInfo);

    procedure SetLayer;

    procedure SetVisibleXLabel(p_Value: Boolean);
    function GetVisibleXLabel(): Boolean;

    procedure OnPaintOverLayerManager(Sender: TObject; Buffer: TBitmap32);

    procedure DrawTrace(p_ChartIndex: Integer; p_ValueX, p_ValueY: Double);

    procedure TraceOnLastTime;

    procedure SetDisplayTypeOfTrade(p_Value: Integer);
  end;

implementation

uses
  FNGlobal, FNMatrixChartControlBase, FNMatrixChartDefine;

// ---------------------------------------------------------------------------
constructor CFNMatrixChartBlockManager.Create;
begin
  inherited Create;

  m_ChartArray := TList.Create;
  m_ChartType := CFNMatrixConst.CHART_NORMAL;
  m_Scale := 1;
  m_ColorSet := CFNMatrixColorSet.Create;
  m_ColorSet.Initialize;
  SetColorSetIndex(0);

  m_XExtraGap := 0;
  m_TraceVisible := true;
  m_XLabel := true;
  m_ScrollEventEnable := true;
  m_LastTRInfo := CFNMatrixPosInfo.Create;
  m_LastTRInfo.m_ChartIndex := -999;
  m_DisplayTypeOfTrade := 0;
  m_UnitType := 0;
end;

// ---------------------------------------------------------------------------
destructor CFNMatrixChartBlockManager.Destroy;
begin
  if Assigned(m_ChartArray) then
  begin
    DeleteChartAll;

    m_ChartArray.Free;
    m_ChartArray := NIL;
  end;

  if Assigned(m_ColorSet) then
  begin
    m_ColorSet.Free;
    m_ColorSet := NIL;
  end;

  if Assigned(m_LastTRInfo) then
  begin
    m_LastTRInfo.Free;
    m_LastTRInfo := NIL;
  end;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.SetLayer;
begin
  m_OverLayer := TBitmapLayer.Create(CFNMatrixChartControlBase(m_ChartControl).Layers);
  m_OverLayer.Bitmap.DrawMode := dmBlend;
  m_OverLayer.OnPaint := OnPaintOverLayerManager;

  m_SignalLayer := TBitmapLayer.Create(CFNMatrixChartControlBase(m_ChartControl).Layers);
  m_SignalLayer.Bitmap.DrawMode := dmBlend;
  m_SignalLayer.Bitmap.CombineMode := cmMerge;

  m_TraceLayer := TBitmapLayer.Create(CFNMatrixChartControlBase(m_ChartControl).Layers);
  m_TraceLayer.Bitmap.DrawMode := dmBlend;

  m_PosValueLayer := TBitmapLayer.Create(CFNMatrixChartControlBase(m_ChartControl).Layers);
  m_PosValueLayer.Bitmap.DrawMode := dmBlend;

  m_LabelLayer := TBitmapLayer.Create(CFNMatrixChartControlBase(m_ChartControl).Layers);
  m_LabelLayer.Bitmap.DrawMode := dmBlend;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.SetColorSetIndex(p_Value: Integer; p_Paint: Boolean = false);
begin
  m_ColorSetIndex := p_Value;
  m_ColorSet.SetColorSetIndex(m_ColorSetIndex);
  if (p_Paint) then
  begin
    RePaint;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.SetDisplayTypeOfTrade(p_Value: Integer);
var
  f_Index: Integer;
  f_ChartBlock: CFNMatrixChartBlock;
begin
  m_DisplayTypeOfTrade := p_Value;

  for f_Index := 0 to m_ChartArray.Count - 1 do
  begin
    f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[f_Index]);
    f_ChartBlock.SetDisplayTypeOfTrade(m_DisplayTypeOfTrade);
  end;

end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlockManager.GetColorSet: CFNMatrixColorSet;
begin
  Result := m_ColorSet;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.SetChartControl(p_ChartControl: TObject);
begin
  m_ChartControl := p_ChartControl;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.SetBound(p_Left: Integer; p_Top: Integer; p_Width: Integer; p_Height: Integer);
begin
  m_BoundRect := TFNGlobal.Rect2(p_Left, p_Top, p_Width, p_Height);
  LayOut;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.OnResize(p_Left: Integer; p_Top: Integer; p_Width: Integer; p_Height: Integer; p_Paint: Boolean);
begin
  m_BoundRect := TFNGlobal.Rect2(p_Left, p_Top, p_Width, p_Height);
  if (p_Paint) then
  begin
    LayOut;
    SetScrollBarPosition;
    RePaint;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.LayOut;
var
  f_ChartBlock: CFNMatrixChartBlock;
  f_Left, f_Top, f_Right, f_Bottom: Integer;
  f_ChartIndex: Integer;
  f_SpaceRect: TRect;
begin
  if (m_ChartArray.Count = 0) then
    exit;

  f_SpaceRect := TFNGlobal.Rect2(m_BoundRect.left, m_BoundRect.top, TFNGlobal.RectToWidth(m_BoundRect), TFNGlobal.RectToHeight(m_BoundRect));

  if (m_ChartArray.Count = 1) then
  begin
    f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[0]);
    f_ChartBlock.SetBound(f_SpaceRect.left, f_SpaceRect.top, f_SpaceRect.right, f_SpaceRect.bottom);
  end
  else
  begin
    f_Left := f_SpaceRect.left;
    f_Top := f_SpaceRect.top;
    f_Right := f_SpaceRect.right;
    f_Bottom := f_SpaceRect.top + Round(8.0 / (12.0 + 2 * (m_ChartArray.Count - 1)) * TFNGlobal.RectToHeight(f_SpaceRect));
    f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[0]);
    f_ChartBlock.SetBound(f_Left, f_Top, f_Right, f_Bottom);
    f_SpaceRect.top := f_Bottom;

    for f_ChartIndex := 1 to m_ChartArray.Count - 1 do
    begin
      f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]);

      f_Top := f_Bottom;
      if (f_ChartIndex = m_ChartArray.Count - 1) then
      begin
        f_Bottom := f_SpaceRect.bottom - CFNMatrixConst.CHART_INTERHEIGHT
      end
      else
      begin
        if f_ChartBlock.m_ABSHeight <> 0 then
        begin
          f_Bottom := f_Top + f_ChartBlock.m_ABSHeight - CFNMatrixConst.CHART_INTERHEIGHT;
        end
        else
        begin
          f_Bottom := f_Top + Round(TFNGlobal.RectToHeight(f_SpaceRect) / (m_ChartArray.Count - 1)) - CFNMatrixConst.CHART_INTERHEIGHT;
        end;
      end;

      f_ChartBlock.SetBound(f_Left, f_Top, f_Right, f_Bottom);

      f_Bottom := f_Bottom + CFNMatrixConst.CHART_INTERHEIGHT;
    end;
  end;

  m_TraceLayer.Location := FloatRect(m_BoundRect.left, m_BoundRect.top, m_BoundRect.right, m_BoundRect.bottom);
  m_TraceLayer.Bitmap.SetSize(TFNGlobal.RectToWidth(m_BoundRect), TFNGlobal.RectToHeight(m_BoundRect));

  f_SpaceRect := Rect(m_BoundRect.left, m_BoundRect.top, m_BoundRect.right, m_BoundRect.bottom);
  f_SpaceRect.right := f_ChartBlock.m_AxisRect.right;
  m_OverLayer.Location := FloatRect(f_SpaceRect.left, f_SpaceRect.top, f_SpaceRect.right, f_SpaceRect.bottom);
  m_OverLayer.Bitmap.SetSize(TFNGlobal.RectToWidth(f_SpaceRect), TFNGlobal.RectToHeight(f_SpaceRect));

  m_SignalLayer.Location := FloatRect(f_SpaceRect.left, f_SpaceRect.top, f_SpaceRect.right, f_SpaceRect.bottom);
  m_SignalLayer.Bitmap.SetSize(TFNGlobal.RectToWidth(f_SpaceRect), TFNGlobal.RectToHeight(f_SpaceRect));

  m_PosValueLayer.Location := FloatRect(m_BoundRect.left, m_BoundRect.top, m_BoundRect.right, m_BoundRect.bottom);
  m_PosValueLayer.Bitmap.SetSize(TFNGlobal.RectToWidth(m_BoundRect), TFNGlobal.RectToHeight(m_BoundRect));

  // 캡션
  m_LabelLayer.Location := FloatRect(m_BoundRect.left, m_BoundRect.top, m_BoundRect.right, m_BoundRect.bottom);
  m_LabelLayer.Bitmap.SetSize(TFNGlobal.RectToWidth(m_BoundRect), TFNGlobal.RectToHeight(m_BoundRect));
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlockManager.AddChart(p_Name: String): CFNMatrixChartBlock;
var
  f_ChartBlock: CFNMatrixChartBlock;
  f_ChartIndex: Integer;
begin
  f_ChartBlock := CFNMatrixChartBlock.Create;

  f_ChartBlock.m_ChartBlockManager := Self;
  f_ChartBlock.m_Name := p_Name;

  f_ChartBlock.m_TraceLayer := m_TraceLayer;
  f_ChartBlock.m_OverLayer := m_OverLayer;
  f_ChartBlock.m_LabelLayer := m_LabelLayer;
  f_ChartBlock.m_SignalLayer := m_SignalLayer;

  f_ChartBlock.m_ChartIndex := m_ChartArray.Count;
  f_ChartBlock.SetChartDataSeries(m_ChartDataSeries);
  f_ChartBlock.m_ColorSet := m_ColorSet;
  f_ChartBlock.m_UnitType := m_UnitType;

  if (f_ChartBlock.m_Name = g_IndicatorName[IND_PRICE_NAME]) then
    f_ChartBlock.SetScale(m_Scale)
  else
    f_ChartBlock.SetScale(0);

  f_ChartBlock.SetDisplayTypeOfTrade(m_DisplayTypeOfTrade);
  m_ChartArray.Add(f_ChartBlock);
  for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
  begin
    CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_ChartIndex := f_ChartIndex;
  end;

  Result := f_ChartBlock;
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlockManager.InsertChart(p_Name: String): CFNMatrixChartBlock;
var
  f_ChartBlock: CFNMatrixChartBlock;
  f_ChartIndex: Integer;
begin
  f_ChartBlock := CFNMatrixChartBlock.Create;

  f_ChartBlock.m_ChartBlockManager := Self;
  f_ChartBlock.m_Name := p_Name;

  f_ChartBlock.m_TraceLayer := m_TraceLayer;
  f_ChartBlock.m_OverLayer := m_OverLayer;
  f_ChartBlock.m_LabelLayer := m_LabelLayer;
  f_ChartBlock.m_SignalLayer := m_SignalLayer;

  f_ChartBlock.m_ChartIndex := m_ChartArray.Count;
  f_ChartBlock.SetChartDataSeries(m_ChartDataSeries);
  f_ChartBlock.m_ColorSet := m_ColorSet;
  f_ChartBlock.m_UnitType := m_UnitType;

  if (f_ChartBlock.m_Name = g_IndicatorName[IND_PRICE_NAME]) then
    f_ChartBlock.SetScale(m_Scale)
  else
    f_ChartBlock.SetScale(0);

  f_ChartBlock.SetDisplayTypeOfTrade(m_DisplayTypeOfTrade);

  if (m_ChartArray.Count > 0) then
    m_ChartArray.Insert(m_ChartArray.Count - 1, f_ChartBlock)
  else
    m_ChartArray.Add(f_ChartBlock);

  for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
  begin
    CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_ChartIndex := f_ChartIndex;
  end;

  Result := f_ChartBlock;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.DeleteChart(p_Name: String);
var
  f_Index: Integer;
  f_ChartIndex: Integer;
  f_ChartBlock: CFNMatrixChartBlock;
  f_FindChart: CFNMatrixChartBlock;
begin
  f_FindChart := NIL;
  for f_Index := 0 to m_ChartArray.Count - 1 do
  begin
    f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[f_Index]);
    if (f_ChartBlock.m_Name = p_Name) then
    begin
      f_FindChart := f_ChartBlock;
      f_FindChart.ClearObject;
      f_FindChart.Free;
      m_ChartArray.Delete(f_Index);
      break;
    end;
  end;

  for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
  begin
    CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_ChartIndex := f_ChartIndex;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.DeleteChartAll;
var
  f_ChartBlock: CFNMatrixChartBlock;
begin
  while (0 < m_ChartArray.Count) do
  begin
    f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[0]);
    f_ChartBlock.ClearObject;
    f_ChartBlock.Free;

    m_ChartArray.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.ClearChartAll;
var
  f_Index: Integer;
  f_ChartBlock: CFNMatrixChartBlock;
begin
  for f_Index := 0 to m_ChartArray.Count - 1 do
  begin
    f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[f_Index]);
    f_ChartBlock.ClearObject;
    f_ChartBlock.m_ChartIndex := f_Index;
    f_ChartBlock.SetChartDataSeries(NIL);
    f_ChartBlock.m_ColorSet := m_ColorSet;
  end;

end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlockManager.FindChart(p_Name: String): CFNMatrixChartBlock;
var
  f_Index: Integer;
  f_ChartBlock: CFNMatrixChartBlock;
  f_FindChart: CFNMatrixChartBlock;
begin
  f_FindChart := NIL;

  for f_Index := 0 to m_ChartArray.Count - 1 do
  begin
    f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[f_Index]);
    if (f_ChartBlock.m_Name = p_Name) then
    begin
      f_FindChart := f_ChartBlock;
      break;
    end;
  end;

  Result := f_FindChart;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.Clear;
var
  f_Index: Integer;
  f_ChartBlock: CFNMatrixChartBlock;
begin
  ClearTraceLayer;
  ClearPosValueLayer;
  ClearLabelLayer;
  ClearSignalLayer;

  for f_Index := 0 to m_ChartArray.Count - 1 do
  begin
    f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[f_Index]);
    f_ChartBlock.Clear;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.ClearTraceLayer;
begin
  if (Assigned(m_TraceLayer)) then
  begin
    m_TraceLayer.Bitmap.Clear($00000000);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.ClearActiveLayer;
begin
  if (Assigned(m_OverLayer)) then
  begin
    m_OverLayer.Bitmap.Clear($00000000);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.ClearPosValueLayer;
begin
  if (Assigned(m_PosValueLayer)) then
  begin
    m_PosValueLayer.Bitmap.Clear($00000000);
  end;
end;

procedure CFNMatrixChartBlockManager.ClearLabelLayer;
begin
  if (Assigned(m_LabelLayer)) then
  begin
    m_LabelLayer.Bitmap.Clear($00000000);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.ClearSignalLayer;
begin
  if (Assigned(m_SignalLayer)) then
  begin
    m_SignalLayer.Bitmap.Clear($00000000);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.Draw(p_Bitmap: TBitmap32);
var
  f_Index: Integer;
  f_ChartBlock: CFNMatrixChartBlock;
begin
  try
    if (0 < m_ChartArray.Count) then
    begin
      for f_Index := 0 to m_ChartArray.Count - 1 do
      begin
        f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[f_Index]);
        f_ChartBlock.Paint(p_Bitmap);

        f_ChartBlock.InitCaption;

        p_Bitmap.ResetClipRect;
        p_Bitmap.ClipRect := m_BoundRect;
      end;
    end
    else
    begin
      p_Bitmap.Clear(m_ColorSet.m_Color[CFNMatrixColorSet.CHART_BACKGROUND_COLOR]);
    end;
  finally
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.RePaint;
begin
  try
    Clear;
    CFNMatrixChartControlBase(m_ChartControl).Invalidate;
  finally
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.SetChartDataSeries(p_ChartDataSeries: CMKStreamChartDataSeries);
var
  f_Index: Integer;
begin
  m_ChartDataSeries := p_ChartDataSeries;
  for f_Index := 0 to m_ChartArray.Count - 1 do
  begin
    CFNMatrixChartBlock(m_ChartArray.Items[f_Index]).m_ChartDataSeries := m_ChartDataSeries;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.SetScale(p_Scale: Integer);
var
  f_Index: Integer;
  f_ChartBlock: CFNMatrixChartBlock;
begin
  m_Scale := p_Scale;
  for f_Index := 0 to m_ChartArray.Count - 1 do
  begin
    f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[f_Index]);
    if (f_ChartBlock.m_Name = g_IndicatorName[IND_PRICE_NAME]) then
      f_ChartBlock.SetScale(m_Scale)
    else
      f_ChartBlock.SetScale(0);
  end;
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlockManager.GetMaxMin: CMKMaxMin;
begin
  Result := CFNMatrixChartBlock(m_ChartArray.Items[0]).m_MaxMin;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.FirstEnlarge(p_Paint: Boolean);
var
  f_Index: Integer;
  f_ChartBlock: CFNMatrixChartBlock;
begin
  for f_Index := 0 to m_ChartArray.Count - 1 do
  begin
    f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[f_Index]);
    f_ChartBlock.FirstEnlarge;
  end;

  SetScrollBarPosition;

  if (p_Paint) then
  begin
    RePaint;
  end;

end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.FullEnlarge(p_Paint: Boolean);
var
  f_Index: Integer;
  f_ChartBlock: CFNMatrixChartBlock;
begin
  for f_Index := 0 to m_ChartArray.Count - 1 do
  begin
    f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[f_Index]);
    f_ChartBlock.FullEnlarge;
  end;

  SetScrollBarPosition;

  if (p_Paint) then
  begin
    RePaint;
  end;

end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.EnlargeValue(p_Paint: Boolean; p_Value: Integer);
var
  f_Index: Integer;
  f_ChartBlock: CFNMatrixChartBlock;
begin
  for f_Index := 0 to m_ChartArray.Count - 1 do
  begin
    f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[f_Index]);
    f_ChartBlock.EnlargeValue(p_Value);
  end;

  SetScrollBarPosition;

  if (p_Paint) then
  begin
    RePaint;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.Enlarge(p_Rratio: Integer; p_Paint: Boolean = false);
var
  f_PriceChart: CFNMatrixChartBlock;
  f_Index: Integer;
  f_ChartBlock: CFNMatrixChartBlock;
begin
  f_PriceChart := CFNMatrixChartBlock(m_ChartArray.Items[0]);
  if (f_PriceChart = NIL) then
    exit;

  if ((p_Rratio > 0) and (f_PriceChart.m_MaxMin.m_XMax - f_PriceChart.m_MaxMin.m_XMin <= 10)) then
    exit;

  for f_Index := 0 to m_ChartArray.Count - 1 do
  begin
    f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[f_Index]);
    f_ChartBlock.Enlarge(p_Rratio);
  end;

  SetScrollBarPosition;
  if (p_Paint) then
  begin
    RePaint;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.RangeEnlarge(f_XMin: Double = -1000000; f_XMax: Double = -1000000; p_SetScrollBarPropertis: Boolean = true; p_Notify: Boolean = true);
var
  f_Index: Integer;
  f_SmallSize: Integer;
begin
  if (m_ChartArray.Count > 0) then
  begin
    if (f_XMin = -1000000) then
      f_XMin := CFNMatrixChartBlock(m_ChartArray.Items[0]).m_MaxMin.m_XMin;

    if (f_XMax = -1000000) then
      f_XMax := CFNMatrixChartBlock(m_ChartArray.Items[0]).m_MaxMin.m_XMax;
  end;

  for f_Index := 0 to m_ChartArray.Count - 1 do
  begin
    CFNMatrixChartBlock(m_ChartArray.Items[f_Index]).RangeEnlarge(f_XMin, f_XMax, true);
  end;

  if (p_SetScrollBarPropertis) then
  begin
    SetScrollBarPosition;
    f_SmallSize := Math.floor((f_XMax - f_XMin) / 7.0);
    if (f_SmallSize = 0) then
      f_SmallSize := 1;

    if Assigned(m_ScrollBar) then
    begin
      m_ScrollBar.SmallChange := f_SmallSize;
      m_ScrollBar.LargeChange := f_SmallSize;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.SetScrollBar(p_ScrollBar: TScrollBar);
begin
  m_ScrollBar := p_ScrollBar;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.OnHScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
var
  f_ChartBlock: CFNMatrixChartBlock;
  f_XMin, f_XMax, f_Position, f_PageSize: Double;

  f_XDirection: Integer;
  f_XMinDate, f_XMaxDate: TDateTime;
  f_ChartData1: CMKChartData;
  f_ChartData0: CMKChartData;
  f_XMinOffset, f_XMaxOffset: Integer;
begin
  if not m_ScrollEventEnable then
    exit;

  if (m_ScrollBar = NIL) then
    exit;

  if (m_ChartDataSeries = NIL) then
    exit;

  if (m_ChartArray.Count = 0) then
    exit;

  if (ScrollPos > m_ScrollBar.Max - m_ScrollBar.PageSize) then
  begin
    ScrollPos := m_ScrollBar.Max - m_ScrollBar.PageSize + 1;
  end;

  f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[0]);
  f_XMin := ScrollPos;
  f_XMax := f_XMin + f_ChartBlock.m_XSize;
  if (f_XMin <> f_ChartBlock.m_MaxMin.m_XMin) then
    RangeEnlarge(f_XMin, f_XMax, false, true);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.SetScrollBarPosition;
var
  f_ChartBlock: CFNMatrixChartBlock;
  f_XMin, f_XMax: Integer;
  f_Position, f_PageSize: Integer;
begin
  if (m_ScrollBar = NIL) then
    exit;
  if (m_ChartDataSeries = NIL) then
    exit;
  if (m_ChartArray.Count = 0) then
    exit;

  f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[0]);
  f_XMin := Round(f_ChartBlock.m_AbsMaxMin.m_XMin);
  f_XMax := Round(f_ChartBlock.m_AbsMaxMin.m_XMax + f_ChartBlock.m_PaddingRight);
  f_PageSize := Round(f_ChartBlock.m_XSize) + 1;
  f_Position := Round(f_ChartBlock.m_MaxMin.m_XMin);

  if (f_Position < 0) or ((f_Position = 0) and (0 >= Max(0, f_XMax - f_PageSize))) then
  begin
    m_ScrollBar.Enabled := false;
  end
  else
  begin
    m_ScrollEventEnable := false;
    m_ScrollBar.Enabled := true;
    m_ScrollBar.PageSize := 0;
    m_ScrollBar.SetParams(f_Position, f_XMin, Max(0, f_XMax));
    m_ScrollBar.PageSize := f_PageSize;
    m_ScrollEventEnable := true;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.OnMouseDown(p_X: Integer; p_Y: Integer);
var
  m_EventRect: TRect;
  f_ChartIndex, f_MouseChartIndex: Integer;
begin
  f_MouseChartIndex := -1;
  for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
  begin
    m_EventRect := TFNGlobal.Rect2(CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect.left, CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect.top,
      TFNGlobal.RectToWidth(CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect) - 50, TFNGlobal.RectToHeight(CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect));

    if (PtInRect(m_EventRect, Point(p_X, p_Y))) then
    begin
      f_MouseChartIndex := f_ChartIndex;
      break;
    end;
  end;

  if (f_MouseChartIndex >= 0) then
    CFNMatrixChartBlock(m_ChartArray.Items[f_MouseChartIndex]).OnMouseDown(p_X, p_Y);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.OnMouseUp(p_X: Integer; p_Y: Integer);
var
  m_EventRect: TRect;
  f_CaptureMouse: Boolean;
  f_ChartIndex, f_MouseChartIndex: Integer;
begin
  f_CaptureMouse := false;

  f_MouseChartIndex := -1;
  for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
  begin
    if (CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_CaptureMouse) then
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
      m_EventRect := TFNGlobal.Rect2(CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect.left, CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect.top,
        TFNGlobal.RectToWidth(CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect) - 50, TFNGlobal.RectToHeight(CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect));

      if (PtInRect(m_EventRect, Point(p_X, p_Y))) then
      begin
        f_MouseChartIndex := f_ChartIndex;
        break;
      end;
    end;
  end;

  if (f_MouseChartIndex >= 0) then
    CFNMatrixChartBlock(m_ChartArray.Items[f_MouseChartIndex]).OnMouseUp(p_X, p_Y);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.OnMouseMove(p_X: Integer; p_Y: Integer);
var
  f_pt: TPoint;
  m_EventRect: TRect;
  f_ChartIndex, f_MouseChartIndex: Integer;
begin
  try
    if (m_TraceVisible) then
    begin
      m_EventRect := Rect(0, 0, 10, 10);
      for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
      begin
        m_EventRect := TFNGlobal.Rect2(CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect.left, CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect.top,
          TFNGlobal.RectToWidth(CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect) - 50, TFNGlobal.RectToHeight(CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_BoundRect));

        if (PtInRect(m_EventRect, Point(p_X, p_Y))) then
        begin
          CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).OnMouseMoveOnAnytime(p_X, p_Y);
          CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).OnMouseMoveSometime(p_X, p_Y);
        end;
      end;
    end;
  except
    on E: Exception do
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.DrawTraceCaption(p_ValueX: Integer);
var
  f_Index: Integer;
begin
  ClearLabelLayer;

  for f_Index := 0 to m_ChartArray.Count - 1 do
  begin
    CFNMatrixChartBlock(m_ChartArray.Items[f_Index]).DrawCaption(p_ValueX);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.TraceXYOnSometime(p_TRInfo: CFNMatrixPosInfo);
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

  if (m_TraceVisible) then
    DrawTracePannel(p_TRInfo);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.ClickPos(p_TRInfo: CFNMatrixPosInfo);
var
  f_Index: Integer;
  f_ChartData: CMKChartData;
begin
  if m_ChartDataSeries = nil then
    exit;
  if m_ChartDataSeries.m_Items.Count <= p_TRInfo.m_ValueX then
    exit;

  if Assigned(CFNMatrixChartControlBase(m_ChartControl).OnClickPos) then
  begin
    CFNMatrixChartControlBase(m_ChartControl).OnClickPos(p_TRInfo.m_ChartIndex, p_TRInfo.m_ValueX, p_TRInfo.m_ValueY);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.TraceXYOnAnytime(p_TRInfo: CFNMatrixPosInfo);
var
  f_Index: Integer;
  f_ChartData: CMKChartData;
begin
  if m_ChartDataSeries = nil then
    exit;
  if m_ChartDataSeries.m_Items.Count <= p_TRInfo.m_ValueX then
    exit;

  if Assigned(CFNMatrixChartControlBase(m_ChartControl).OnChartTraceChange) then
  begin
    CFNMatrixChartControlBase(m_ChartControl).OnChartTraceChange(p_TRInfo.m_ChartIndex, p_TRInfo.m_ValueX, p_TRInfo.m_ValueY);
  end;
end;

procedure CFNMatrixChartBlockManager.DrawTrace(p_ChartIndex: Integer; p_ValueX: Double; p_ValueY: Double);
var
  f_pt: TPoint;
  m_EventRect: TRect;
  f_ChartIndex, f_MouseChartIndex: Integer;
  f_ChartBlock: CFNMatrixChartBlock;
  f_X, f_Y: Integer;
  f_Index: Integer;
  f_ValueY: Double;
begin
  m_LastTRInfo.m_ChartIndex := p_ChartIndex;
  m_LastTRInfo.m_ValueX := p_ValueX;
  m_LastTRInfo.m_ValueY := p_ValueY;

  if (m_LastTRInfo.m_ChartIndex >= 0) and (m_LastTRInfo.m_ChartIndex < m_ChartArray.Count) then
  begin
    f_ChartBlock := m_ChartArray.Items[m_LastTRInfo.m_ChartIndex];
    if f_ChartBlock <> NIL then
    begin
      m_LastTRInfo.m_MX := f_ChartBlock.GetScreenX(m_LastTRInfo.m_ValueX, f_ChartBlock.m_MaxMin);
      m_LastTRInfo.m_MY := f_ChartBlock.GetScreenY(m_LastTRInfo.m_ValueY, f_ChartBlock.m_MaxMin);
    end
    else
    begin
      exit;
    end;
  end
  else
  begin
    exit;
  end;

  try
    if (m_TraceVisible) then
    begin
      ClearTraceLayer();
      ClearPosValueLayer();
      ClearSignalLayer;
      for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
      begin
        f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]);

        f_ValueY := p_ValueY;
        if f_ValueY > f_ChartBlock.m_MaxMin.m_YMax then
          f_ValueY := f_ChartBlock.m_MaxMin.m_YMax;
        if f_ValueY < f_ChartBlock.m_MaxMin.m_YMin then
          f_ValueY := f_ChartBlock.m_MaxMin.m_YMin;

        f_ChartBlock.DrawTrace2(p_ChartIndex, p_ValueX, f_ValueY);

        if f_ChartIndex = p_ChartIndex then
        begin

          f_X := f_ChartBlock.GetScreenXCenter(p_ValueX, f_ChartBlock.m_MaxMin);
          f_Y := f_ChartBlock.GetScreenY(f_ValueY, f_ChartBlock.m_MaxMin);

          m_EventRect := TFNGlobal.Rect2(f_ChartBlock.m_BoundRect.left, f_ChartBlock.m_BoundRect.top, TFNGlobal.RectToWidth(f_ChartBlock.m_BoundRect) - 50,
            TFNGlobal.RectToHeight(f_ChartBlock.m_BoundRect));

          f_ChartBlock.OnMouseMoveSometime(f_X, f_Y, true);
        end;
      end;
    end;
  except
    on E: Exception do
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.TraceOnLastTime;
var
  f_Index: Integer;
  f_ChartData: CMKChartData;
  f_ChartBlock: CFNMatrixChartBlock;
begin
  if m_LastTRInfo.m_ChartIndex = -999 then
    exit;
  if m_LastTRInfo.m_ChartIndex < 0 then
    exit;
  if m_LastTRInfo.m_ChartIndex >= m_ChartArray.Count then
    exit;
  if m_ChartArray.Count <= 0 then
    exit;

  if (m_LastTRInfo.m_ChartIndex >= 0) and (m_LastTRInfo.m_ChartIndex < m_ChartArray.Count) then
  begin
    f_ChartBlock := m_ChartArray.Items[m_LastTRInfo.m_ChartIndex];
    if f_ChartBlock <> NIL then
    begin
      m_LastTRInfo.m_ValueX := Math.floor(f_ChartBlock.GetRealX(m_LastTRInfo.m_MX, f_ChartBlock.m_MaxMin));
      m_LastTRInfo.m_ValueY := f_ChartBlock.GetRealY(m_LastTRInfo.m_MY, f_ChartBlock.m_MaxMin);

      if (m_LastTRInfo.m_ValueX > f_ChartBlock.m_AbsMaxMin.m_XMax) then
        m_LastTRInfo.m_ValueX := f_ChartBlock.m_AbsMaxMin.m_XMax;

      m_LastTRInfo.m_WindowX := Math.floor(f_ChartBlock.GetScreenXCenter(m_LastTRInfo.m_ValueX, f_ChartBlock.m_MaxMin));
      m_LastTRInfo.m_WindowY := Math.floor(f_ChartBlock.GetScreenY(m_LastTRInfo.m_ValueY, f_ChartBlock.m_MaxMin));

    end
    else
    begin
      exit;
    end;
  end
  else
  begin
    exit;
  end;

  try
    if (m_TraceVisible) then
    begin
      ClearTraceLayer;
      for f_Index := 0 to m_ChartArray.Count - 1 do
      begin
        CFNMatrixChartBlock(m_ChartArray.Items[f_Index]).DrawTrace(m_LastTRInfo);
        CFNMatrixChartBlock(m_ChartArray.Items[f_Index]).InitCaption;
      end;
    end;

    TraceXYOnSometime(m_LastTRInfo);
    DrawTraceCaption(Math.floor(m_LastTRInfo.m_ValueX));
  except
    on E: Exception do

  end;

end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.SetXExtraGap(p_X: Integer);
begin

end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.ClearTrace;
begin
  ClearTraceLayer;
  ClearPosValueLayer;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.SetVisibleXLabel(p_Value: Boolean);
var
  f_Index: Integer;
  f_ChartBlock: CFNMatrixChartBlock;
begin
  m_XLabel := p_Value;
  for f_Index := 0 to m_ChartArray.Count - 1 do
  begin
    f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[f_Index]);
    if (f_Index = 0) then
      f_ChartBlock.m_VisibleXLabel := m_XLabel
    else
      f_ChartBlock.m_VisibleXLabel := false;
  end;
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlockManager.GetVisibleXLabel(): Boolean;
begin
  Result := m_XLabel;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.SetTraceVisible(p_Value: Boolean; p_Paint: Boolean = false);
begin
  m_TraceVisible := p_Value;
  if (not m_TraceVisible) and (p_Paint) then
  begin
    ClearTraceLayer;
    ClearPosValueLayer;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.SetUnitType(AValue: Integer);
begin
  m_UnitType := AValue;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.SetUseOPSPrice(AValue: Boolean);
begin
  m_UseOPSPrice := AValue;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.DrawPosValueFrame(p_X: Integer; p_Y: Integer; p_Width: Integer; p_Height: Integer; p_CX: Integer; p_CY: Integer; p_Direct: Integer);
var
  PenColor: TColor32;
  FillColor: TColor32;
begin
  if (m_PosValueLayer = NIL) then
    exit;

  PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.TRACE_VALUE_LINE_COLOR];
  PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));
  FillColor := m_ColorSet.m_Color[CFNMatrixColorSet.TRACE_VALUE_FILLED_COLOR];
  FillColor := SetAlpha(FillColor, TFNGlobal.GetAlphaValue(100));

  m_PosValueLayer.Bitmap.FillRectTS(p_X, p_Y, p_X + p_Width, p_Y + p_Height, FillColor);
  m_PosValueLayer.Bitmap.FrameRectTS(p_X, p_Y, p_X + p_Width, p_Y + p_Height, PenColor);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.DrawTraceXValueFrame(p_X: Integer; p_Y: Integer; p_Width: Integer; p_Height: Integer);
var
  PenColor: TColor32;
  FillColor: TColor32;
begin
  if (m_PosValueLayer = NIL) then
    exit;

  PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.TRACE_XY_LINE_COLOR];
  PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));
  FillColor := m_ColorSet.m_Color[CFNMatrixColorSet.TRACE_XY_FILLED_COLOR];
  FillColor := SetAlpha(FillColor, TFNGlobal.GetAlphaValue(100));

  m_PosValueLayer.Bitmap.FillRectTS(p_X, p_Y, p_X + p_Width, p_Y + p_Height, FillColor);
  m_PosValueLayer.Bitmap.FrameRectTS(p_X, p_Y, p_X + p_Width, p_Y + p_Height, PenColor);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.DrawTraceYValueFrame(p_X: Integer; p_Y: Integer; p_Width: Integer; p_Height: Integer);
var
  PenColor: TColor32;
  FillColor: TColor32;
begin
  if (m_PosValueLayer = NIL) then
    exit;

  PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.TRACE_XY_LINE_COLOR];
  PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));
  FillColor := m_ColorSet.m_Color[CFNMatrixColorSet.TRACE_XY_FILLED_COLOR];
  FillColor := SetAlpha(FillColor, TFNGlobal.GetAlphaValue(100));

  m_PosValueLayer.Bitmap.FillRectTS(p_X, p_Y, p_X + p_Width, p_Y + p_Height, FillColor);
  m_PosValueLayer.Bitmap.FrameRectTS(p_X, p_Y, p_X + p_Width, p_Y + p_Height, PenColor);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.DrawTracePannel(p_TRInfo: CFNMatrixPosInfo);
var
  f_Index, f_LineIndex, f_LineCount: Integer;
  f_ValueArray: TList;
  p_X, p_Y, p_W, p_H: Integer;
  p_ChartData: CMKChartData;
  p_PosValue: CFNMatrixPosValue;
  f_Value: String;
  f_Year, f_month, f_day, f_hour, f_min, f_sec: Integer;
  p_Enabled: Boolean;
  f_ChartBlock: CFNMatrixChartBlock;

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

  ClearPosValueLayer;

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

  m_PosValueLayer.Bitmap.Font.Name := CFNMatrixColorSet.NUMBER2_FONT_FAMILY;
  m_PosValueLayer.Bitmap.Font.Size := CFNMatrixColorSet.NUMBER2_FONT_SMALLSIZE2;
  m_PosValueLayer.Bitmap.Font.Style := [];

  FontColor := m_ColorSet.m_Color[CFNMatrixColorSet.TRACE_XY_TEXT_COLOR];
  FontColor := SetAlpha(FontColor, TFNGlobal.GetAlphaValue(100));

  if (p_Enabled) then
  begin
    f_Value := TFNGlobal.DateToYYYY_MM_DD(f_Year, f_month, f_day);
    if (9000 < m_ChartDataSeries.m_TimeFrame) then
    begin
      f_Value := f_Value + ' ' + TFNGlobal.TimeToHH_MM_SS(f_hour, f_min, f_sec);
    end
    else if (360 > m_ChartDataSeries.m_TimeFrame) then
    begin
      f_Value := f_Value + ' ' + TFNGlobal.TimeToHH_MM(f_hour, f_min);
    end;

    p_W := m_PosValueLayer.Bitmap.TextWidth(f_Value) + 8;
    p_H := CFNMatrixConst.CHART_DRAW_XLABEL_HEIGHT;
    p_X := Math.floor(p_TRInfo.m_WindowX - (p_W / 2));
    p_Y := CFNMatrixChartBlock(m_ChartArray.Items[0]).m_AxisRect.top + RectHeight(CFNMatrixChartBlock(m_ChartArray.Items[0]).m_AxisRect);

    // X축 좌표 정보 그린다.
    DrawTraceXValueFrame(p_X, p_Y - 1, p_W, p_H + 4);

    f_TextHeight := m_PosValueLayer.Bitmap.TextHeight(f_Value);
    m_PosValueLayer.Bitmap.RenderText((p_X + 4), (p_Y + Math.floor((p_H - f_TextHeight) / 2)) + 1, f_Value, 0, FontColor);

    if p_TRInfo.m_ChartIndex >= 0 then
    begin
      f_ChartBlock := CFNMatrixChartBlock(m_ChartArray.Items[p_TRInfo.m_ChartIndex]);
      f_YGridPrecision := f_ChartBlock.GetScreenYGridPrecision();
      f_Unit := f_ChartBlock.GetUnit();

      if (f_ChartBlock.m_YGridSize <> 0.0) then
      begin

        f_Value := TFNGlobal.NumberToString(p_TRInfo.m_ValueY / f_Unit, f_YGridPrecision);

        f_YLabelWidth := f_ChartBlock.m_PaddingRight + CFNMatrixConst.CHART_DRAW_YLABEL_WIDTH - 2;
        p_W := m_PosValueLayer.Bitmap.TextWidth(f_Value) + 4;

        if (p_W < f_YLabelWidth) then
          p_W := f_YLabelWidth
        else
          p_W := p_W;

        f_TextHeight := m_PosValueLayer.Bitmap.TextHeight(f_Value);
        p_W := p_W;
        p_H := f_TextHeight + 3;
        p_X := m_BoundRect.right - f_YLabelWidth;

        p_Y := Round(p_TRInfo.m_WindowY - (p_H / 2));
        if ((p_X + p_W) > m_BoundRect.right) then
          p_X := m_BoundRect.right - p_W;

        // Y축 좌표 정보 그린다.
        DrawTraceYValueFrame(p_X, p_Y, p_W, p_H);

        m_PosValueLayer.Bitmap.RenderText((p_X + p_W - m_PosValueLayer.Bitmap.TextWidth(f_Value) - 2), (p_TRInfo.m_WindowY - f_TextHeight div 2), f_Value, 0, FontColor);
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlockManager.OnMouseLeave;
begin
  ClearActiveLayer;
end;

procedure CFNMatrixChartBlockManager.OnPaintOverLayerManager(Sender: TObject; Buffer: TBitmap32);
var
  f_ChartIndex: Integer;
  f_ClipRect: TRect;
begin
  try
    for f_ChartIndex := 0 to m_ChartArray.Count - 1 do
    begin
      f_ClipRect := Rect(m_BoundRect.left, m_BoundRect.top, CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).m_AxisRect.right - 1, m_BoundRect.bottom);
      Buffer.ResetClipRect;
      Buffer.ClipRect := f_ClipRect;

      CFNMatrixChartBlock(m_ChartArray.Items[f_ChartIndex]).OnPaintOverLayer(Sender, Buffer);

      Buffer.ResetClipRect;
      Buffer.ClipRect := m_BoundRect;
    end;
  finally
  end;
end;

end.
