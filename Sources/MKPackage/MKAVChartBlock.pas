unit MKAVChartBlock;

interface

uses
  SysUtils, Classes, Types, Math, GR32, GR32_Polygons, Graphics,
  GR32_Layers,
  Dialogs,
  MKColorSet,
  MKStreamChartDataSeries,
  MKMaxMin, MKConst,
  MKLineValueSeries,
  MKChartData,
  MKLineValue,
  MKAVPosInfo,
  MKAVPosValue,
  MKAVDrawManager;

type

  PTLabelData = ^TLabelData;

  TLabelData = record
    nX: Integer;
    nY: Integer;
    nDx: Integer;
    nDy: Integer;
    strLabel: String;
    fontColor: TColor32;
  end;

  CMKChartBlock = class(TObject)
  private
    m_PrevRequestDate: TDateTime;

  public
    m_Name: String;
    m_ObjectCollection: TList;
    m_TradeStrategyCollection: TList;

    m_ChartBlockManager: TObject;
    m_ColorSet: CMKColorSet;
    m_ChartDataSeries: CMKStreamChartDataSeries;
    m_ChartIndex: Integer;
    m_VisibleXLabel: Boolean;
    m_VisibleYLabel: Boolean;
    m_VisibleXGrid: Boolean;
    m_VisibleYGrid: Boolean;
    m_YLabelType: Integer;

    m_XSize: Double;
    m_AbsMaxMin: CMKMaxMin;
    m_MaxMin: CMKMaxMin;
    m_BoundRect: TRect;
    m_AxisRect: TRect;
    m_XLabelRect: TRect;
    m_LegendRect: TRect;
    m_YGridSize: Double;
    m_PaddingTop: Integer;
    m_PaddingBottom: Integer;
    m_PaddingLeft: Integer;
    m_PaddingRight: Integer;
    m_Unit: Integer;
    m_Scale: Integer;

    m_OverLayer: TBitmapLayer;
    m_TraceLayer: TBitmapLayer;
    m_LabelLayer: TBitmapLayer;
    m_SignalLayer: TBitmapLayer;

    m_LabelArray: TList;

    m_CaptureMouse: Boolean;
    m_DragNewX: Integer;
    m_DragOldX: Integer;
    m_Moving: Boolean;

    m_OldX: Integer;
    m_NewX: Integer;
    m_OldY: Integer;
    m_NewY: Integer;
    m_XExtraGap: Integer;

    m_AxisRightPadding: Integer;
    m_DrawedOverLayer: Boolean;
    m_OverObject: Integer;
    m_OverLine: Integer;

    m_DrawManager: CMKAVDrawManager;
    m_DrawLayer: TBitmapLayer;

    m_DrawCaptionCount: Integer;

  protected
    m_YGridPrecision: Integer;
    m_LastLabelX: Integer;
    m_YLogDiffer: Double;
    m_YLogUnit: Integer;

  public
    constructor Create();
    destructor Destroy(); override;

    procedure Clear();
    procedure Paint(p_Bitmap: TBitmap32);
    function GetScreenX(p_RX: Double; p_MaxMin: CMKMaxMin): Integer;
    function GetScreenXCenter(p_RX: Double; p_MaxMin: CMKMaxMin): Integer;
    function GetScreenY(p_RY: Double; p_MaxMin: CMKMaxMin; p_Scale: Integer = -1): Integer;
    function GetRealX(p_IX: Double; p_MaxMin: CMKMaxMin): Double;
    function GetRealY(p_IY: Double; p_MaxMin: CMKMaxMin): Double;
    procedure SetBound(p_Left: Integer; p_Top: Integer; p_Right: Integer; p_Bottom: Integer);
    procedure LayOut();
    procedure RangeEnlarge(p_XMin: Double = -1; p_XMax: Double = -1; p_Enlarge: Boolean = false);
    procedure FirstEnlarge();
    procedure SetChartDataSeries(p_ChartDataSeries: CMKStreamChartDataSeries);

    procedure DrawAxis(p_Bitmap: TBitmap32);
    procedure DrawChartBoard(p_Bitmap: TBitmap32);
    procedure DrawChartBackground(p_Bitmap: TBitmap32);
    procedure DrawLineValueSeries_PriceLine(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries; p_ActiveLine: Integer = -1);
    procedure DrawLineValueSeries_VolumeLine(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries; p_ActiveLine: Integer = -1);
    procedure DrawLineValueSeries_NetLine(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries; p_ActiveLine: Integer = -1);
    procedure DrawLineValueSeries_Line(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries; p_ActiveLine: Integer = -1);
    procedure DrawLineValueSeries_IMLine(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries; p_ActiveLine: Integer = -1);
    procedure DrawLineValueSeries_BBLine(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries; p_ActiveLine: Integer = -1);
    procedure DrawLineValueSeries_SignalLine(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries; p_ActiveLine: Integer = -1);
    procedure DrawLineValueSeries_TradeStrategySignal(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries;
        p_ActiveLine: Integer = -1);

    procedure DrawLineValueSeries_OPSREL(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries; p_ActiveLine: Integer = -1);
    procedure DrawChart(p_Bitmap: TBitmap32);
    procedure DrawActiveChart(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries; p_ActiveLine: Integer);

    procedure DrawLineValues(p_Bitmap: TBitmap32);

    procedure CalculateYGridSize();
    procedure CalculatePadding();

    procedure AddObject(p_LineSeries: CMKLineValueSeries);
    function FindValueArray(p_Name: String): CMKLineValueSeries;
    procedure DeleteValueArray(p_Name: String);
    procedure ClearObject(AFree: Boolean = true);

    procedure ChangedLineMaxMin(p_LineSeries: CMKLineValueSeries);
    function GetYGridPrecision(): Integer;
    function GetUnit(): Integer;
    procedure SetScale(p_Scale: Integer);
    procedure DrawFillRectAngle(p_Bitmap: TBitmap32; p_Tick: Integer; p_LineColor: Integer; p_LineAlpha: Integer;
        p_FillColor: Integer; p_FillAlpha: Integer; p_X1: Integer; p_Y1: Integer; p_X2: Integer; p_Y2: Integer);

    procedure DrawYGrid(p_Bitmap: TBitmap32);
    procedure DrawYTicLabel(p_Bitmap: TBitmap32);
    procedure DrawXGrid(p_Bitmap: TBitmap32);
    procedure DrawXTicLabel(p_Bitmap: TBitmap32);
    procedure DrawLabelOnNormalMode(p_Bitmap: TBitmap32);
    procedure DrawLabel(p_Bitmap: TBitmap32);
    procedure DrawLastValue(p_Bitmap: TBitmap32);
    procedure DrawExitButton(p_Bitmap: TBitmap32);

    procedure Enlarge(p_Ratio: Integer);
    procedure EnlargeValue(p_Value: Integer);
    function GetEnlargeInfo(p_Ratio: Integer): CMKMaxMin;

    procedure OnMouseDown(p_X: Integer; p_Y: Integer);
    procedure OnMouseUp(p_X: Integer; p_Y: Integer);
    procedure OnMouseMoveOnAnytime(p_X: Integer; p_Y: Integer);
    procedure OnMouseMoveSometime(p_X: Integer; p_Y: Integer);
    procedure SetXExtraGap(p_X: Integer);
    function GetScreenYGridPrecision(): Integer;
    procedure ClearActiveLayer();
    procedure DrawTrace(p_TRInfo: CMKPosInfo);
    procedure GetPosValue(p_Index: Integer; Values: TList);
    function GetHitTestX1(p_PosX: Double; p_Width: Double): Double;
    function GetHitTestX2(p_PosX: Double; p_Width: Double): Double;
    function GetEnableTracePannel(f_PosInfo: CMKPosInfo): Boolean;

    procedure OnPaintOverLayer(Sender: TObject; Buffer: TBitmap32);

    procedure AllowDrawing();
    procedure EndDrawObject();
    procedure StartDrawObject(p_NobjectType: Integer);
    procedure SetDrawObjectColor(p_Color: TColor32);
    procedure StartDrawingCharObject(p_TextList: TStrings; p_font: TFont);
    procedure DrawLayOut();
    procedure DrawObjectXDateToValue();
    procedure DrawObjectXValueToDate();

    procedure InitCaption();
    procedure InitNormalCaption(p_Bitmap: TBitmap32);
    function GetTraceCaptionWidth(p_Bitmap: TBitmap32): Integer;
    procedure DrawCaption(p_Index: Integer);
    procedure DrawNormalCaption(p_Bitmap: TBitmap32; p_Index: Integer);
    procedure InsertCaption(p_X, p_Y, p_W, p_H: Integer; p_Value: String; p_FontColor: TColor);
    procedure ClearLabelArray();

    function OnEventMouseDown(p_X: Integer; p_Y: Integer): Boolean;
    function OnEventMouseUp(p_X: Integer; p_Y: Integer): Boolean;
    function OnEventMouseMove(p_X: Integer; p_Y: Integer): Boolean;

    procedure ReEnlarge(p_Value: Integer);
    procedure DrawTraceDate(p_ValueX: Double);
    procedure DrawSignalTrace(p_Signal: Integer; p_Start: Integer; p_End: Integer);
    function GetSignalRange(var p_Signal: Integer; var p_Start: Integer; var p_End: Integer; p_Position: Integer): Boolean;
  end;

implementation

uses
  MKGlobal, MKChartDefine,
  MKAVChartBlockManager;

// ---------------------------------------------------------------------------
constructor CMKChartBlock.Create();
begin
  inherited Create();

  m_ObjectCollection := TList.Create();
  m_TradeStrategyCollection := TList.Create();
  m_ChartIndex := 0;
  m_XSize := 0.0;
  m_PaddingTop := 18;
  m_PaddingBottom := 2;
  m_PaddingLeft := 0;
  m_PaddingRight := 3;
  m_YGridSize := 0;
  m_Unit := 1;

  m_YLabelType := 0;
  m_VisibleXLabel := true;
  m_VisibleYLabel := true;
  m_VisibleXGrid := true;
  m_VisibleYGrid := true;

  m_AbsMaxMin := CMKMaxMin.Create();
  m_MaxMin := CMKMaxMin.Create();
  m_YGridPrecision := 0;
  m_Scale := 0;

  m_XExtraGap := 0;
  m_DrawedOverLayer := false;
  m_OverObject := -1;
  m_OverLine := -1;
  m_AxisRightPadding := 0;

  m_DrawManager := NIL;

  m_TraceLayer := NIL;
  m_DrawLayer := NIL;
  m_LabelArray := TList.Create;

end;

// ---------------------------------------------------------------------------
destructor CMKChartBlock.Destroy();
begin
  if Assigned(m_ObjectCollection) then
  Begin
    m_ObjectCollection.Free();
    m_ObjectCollection := NIL;
  End;
  if Assigned(m_TradeStrategyCollection) then
  Begin
    m_TradeStrategyCollection.Free();
    m_TradeStrategyCollection := NIL;
  End;

  if Assigned(m_AbsMaxMin) then
  begin
    m_AbsMaxMin.Free();
    m_AbsMaxMin := NIL;
  end;

  if Assigned(m_MaxMin) then
  begin
    m_MaxMin.Free();
    m_MaxMin := NIL;
  end;

  if Assigned(m_DrawManager) then
  begin
    m_DrawManager.Free();
    m_DrawManager := NIL;
  end;

  if Assigned(m_LabelArray) then
  begin
    ClearLabelArray();

    m_LabelArray.Free;
    m_LabelArray := NIL;
  end;

  inherited Destroy();
end;

procedure CMKChartBlock.Clear();
begin
  if (m_DrawManager <> NIL) then
    m_DrawManager.Clear();

  ClearLabelArray();
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.Paint(p_Bitmap: TBitmap32);
begin
  if (m_ColorSet = NIL) then
    exit;

  try
    if (not Assigned(m_ChartDataSeries)) OR (m_ChartDataSeries.m_Items.Count <= 0) then
    begin
      DrawChartBoard(p_Bitmap);
      DrawChartBackground(p_Bitmap);
      DrawAxis(p_Bitmap);
      // DrawExitButton(p_Bitmap);
    end
    else
    begin
      CalculatePadding();
      CalculateYGridSize();

      DrawChartBoard(p_Bitmap);
      DrawChartBackground(p_Bitmap);
      DrawXGrid(p_Bitmap);

      DrawYGrid(p_Bitmap);

      p_Bitmap.ResetClipRect;
      p_Bitmap.ClipRect := m_AxisRect;

      DrawChart(p_Bitmap);
      DrawLineValues(p_Bitmap);

      p_Bitmap.ResetClipRect;
      p_Bitmap.ClipRect := m_BoundRect;

      DrawLabel(p_Bitmap);
      DrawAxis(p_Bitmap);
      DrawYTicLabel(p_Bitmap);
      DrawXTicLabel(p_Bitmap);

      // DrawLastValue(p_Bitmap);

      // DrawExitButton(p_Bitmap);

      if (m_DrawManager <> NIL) AND (m_ChartDataSeries <> NIL) then
        m_DrawManager.Paint();
    end;

  except
  end;

end;

// ---------------------------------------------------------------------------
function CMKChartBlock.GetScreenX(p_RX: Double; p_MaxMin: CMKMaxMin): Integer;
begin
  if (p_MaxMin.m_XMax = p_MaxMin.m_XMin) then
    Result := 0
  else
    Result := Math.floor(TMKGlobal.RectToWidth(m_AxisRect) * (p_RX - p_MaxMin.m_XMin) / (p_MaxMin.m_XMax - p_MaxMin.m_XMin + 1)
        + m_AxisRect.left);
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.GetScreenXCenter(p_RX: Double; p_MaxMin: CMKMaxMin): Integer;
begin
  if (p_MaxMin.m_XMax = p_MaxMin.m_XMin) then
    Result := 0
  else
    Result := GetScreenX(p_RX + 0.5, p_MaxMin);
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.GetScreenY(p_RY: Double; p_MaxMin: CMKMaxMin; p_Scale: Integer = -1): Integer;
var
  f_AxisHeight: Integer;
  f_LnY, f_LnYMax, f_LnYMin: Double;
  f_Value: Double;
begin
  if (not Assigned(m_ChartDataSeries)) OR (m_ChartDataSeries.m_Items.Count <= 0) then
  begin
    Result := 0;
    exit;
  end;
  try
    if (p_Scale = -1) then
      p_Scale := m_Scale;

    if (p_Scale = 1) then
    begin
      f_Value := m_YLogDiffer + p_RY;
      if (f_Value <= 0) then
        f_LnY := 0
      else
        f_LnY := Math.Log10(f_Value);

      f_Value := m_YLogDiffer + p_MaxMin.m_YMin;
      if (f_Value <= 0.0) then
        f_LnYMin := 0
      else
        f_LnYMin := Math.Log10(f_Value);

      f_Value := m_YLogDiffer + p_MaxMin.m_YMax;
      if (f_Value <= 0.0) then
        f_LnYMax := 0
      else
        f_LnYMax := Math.Log10(f_Value);

      if (f_LnYMin = f_LnYMax) then
      begin
        Result := 0;
        exit;
      end
      else
      begin
        f_AxisHeight := TMKGlobal.RectToHeight(m_AxisRect) - (m_PaddingTop + m_PaddingBottom);
        Result := Math.floor((m_AxisRect.bottom) - m_PaddingBottom - (f_AxisHeight) * (f_LnY - f_LnYMin) /
            (f_LnYMax - f_LnYMin));
        exit;
      end;
    end
    else
    begin
      if (p_MaxMin.m_YMax - p_MaxMin.m_YMin = 0.0) then
      begin
        Result := 0;
        exit;
      end
      else
      begin
        f_AxisHeight := TMKGlobal.RectToHeight(m_AxisRect) - (m_PaddingTop + m_PaddingBottom);
        Result := Math.floor((m_AxisRect.bottom) - m_PaddingBottom - (f_AxisHeight) * (p_RY - p_MaxMin.m_YMin) /
            (p_MaxMin.m_YMax - p_MaxMin.m_YMin));
        exit;
      end;
    end;
  except
    Result := 0;
  end;
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.GetRealX(p_IX: Double; p_MaxMin: CMKMaxMin): Double;
var
  f_DX: Double;
begin
  if (TMKGlobal.RectToWidth(m_AxisRect) = 0) then
    f_DX := 0
  else
    f_DX := (((p_IX - m_AxisRect.left) * (p_MaxMin.m_XMax - p_MaxMin.m_XMin + 1) / TMKGlobal.RectToWidth(m_AxisRect)) +
        p_MaxMin.m_XMin);

  if (f_DX < p_MaxMin.m_XMin) then
    f_DX := p_MaxMin.m_XMin;

  if (f_DX > p_MaxMin.m_XMax) then
    f_DX := p_MaxMin.m_XMax;

  Result := f_DX;
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.GetRealY(p_IY: Double; p_MaxMin: CMKMaxMin): Double;
var
  f_AxisHeight: Integer;
  f_DY: Double;
  f_LnY, f_LnYMax, f_LnYMin: Double;
  f_Value: Double;
begin
  if (m_Scale = 1) then
  begin

    f_Value := m_YLogDiffer + p_MaxMin.m_YMin;
    if (f_Value <= 0.0) then
      f_LnYMin := 0
    else
      f_LnYMin := Math.Log10(f_Value);

    f_Value := m_YLogDiffer + p_MaxMin.m_YMax;
    if (f_Value <= 0.0) then
      f_LnYMax := 0
    else
      f_LnYMax := Math.Log10(f_Value);

    f_AxisHeight := TMKGlobal.RectToHeight(m_AxisRect) - (m_PaddingTop + m_PaddingBottom);
    if (f_AxisHeight = 0) then
      f_DY := 0
    else
      f_DY := f_LnYMin + (m_AxisRect.bottom - m_PaddingBottom - p_IY) * (f_LnYMax - f_LnYMin) / (f_AxisHeight);

    if (f_DY < f_LnYMin) then
      f_DY := f_LnYMin;

    if (f_DY > f_LnYMax) then
      f_DY := f_LnYMax;

    f_DY := Power(10, f_DY) - m_YLogDiffer;

    Result := f_DY;
  end
  else
  begin
    f_AxisHeight := TMKGlobal.RectToHeight(m_AxisRect) - (m_PaddingTop + m_PaddingBottom);
    if (f_AxisHeight = 0) then
      f_DY := 0
    else
      f_DY := p_MaxMin.m_YMin + (m_AxisRect.bottom - m_PaddingBottom - p_IY) * (p_MaxMin.m_YMax - p_MaxMin.m_YMin) /
          (f_AxisHeight);

    if (f_DY < p_MaxMin.m_YMin) then
      f_DY := p_MaxMin.m_YMin;

    if (f_DY > p_MaxMin.m_YMax) then
      f_DY := p_MaxMin.m_YMax;

    Result := f_DY;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.SetBound(p_Left: Integer; p_Top: Integer; p_Right: Integer; p_Bottom: Integer);
begin
  m_BoundRect := TMKGlobal.Rect2(p_Left, p_Top, p_Right - p_Left + 1, p_Bottom - p_Top + 1);
  LayOut();
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.LayOut();
var
  f_YLabelWidth: Integer;
  f_X1: Integer;
  f_Y1: Integer;
  f_X2: Integer;
  f_Y2: Integer;
  f_AxisTop, f_AxisWidth, f_AxisHeight: Integer;
  f_W: Integer;
  f_H: Integer;
begin
  f_W := 9;
  f_H := 6;

  f_X1 := m_BoundRect.left;
  f_Y1 := m_BoundRect.Top;
  f_X2 := m_BoundRect.left + RectWidth(m_BoundRect);
  f_Y2 := m_BoundRect.Top + RectHeight(m_BoundRect);

  if (m_VisibleYLabel) then
    f_YLabelWidth := CMKConst.CHART_DRAW_YLABEL_WIDTH
  else
    f_YLabelWidth := 0;

  if (m_VisibleXLabel) then
  begin
    f_AxisTop := f_Y1;
    f_AxisHeight := f_Y2 - f_Y1 - CMKConst.CHART_DRAW_XLABEL_HEIGHT - 3;
    m_AxisRect := TMKGlobal.Rect2(f_X1 + f_YLabelWidth, f_Y1, f_X2 - f_X1 - f_YLabelWidth * 2 - 1, f_AxisHeight);

    m_XLabelRect := TMKGlobal.Rect2(f_X1 + f_YLabelWidth, f_Y1 + f_AxisHeight + 2, f_X2 - f_X1 - f_YLabelWidth * 2 - 1,
        CMKConst.CHART_DRAW_XLABEL_HEIGHT);

    // f_AxisWidth     := Round((TMKGlobal.RectToWidth(m_AxisRect)) / 12) * 12;
    // m_AxisRightPadding := TMKGlobal.RectToWidth(m_AxisRect) - f_AxisWidth + 1;
    // m_AxisRect.right := m_AxisRect.left + f_AxisWidth-1;
    m_AxisRightPadding := 0;
  end
  else
  begin
    f_AxisTop := f_Y1;
    f_AxisHeight := f_Y2 - f_AxisTop - 2;
    m_AxisRect := TMKGlobal.Rect2(f_X1 + f_YLabelWidth, f_AxisTop, f_X2 - f_X1 - f_YLabelWidth * 2 - 1, f_AxisHeight);
    // f_AxisWidth     := Round((TMKGlobal.RectToWidth(m_AxisRect)) / 12) * 12;
    // m_AxisRightPadding := TMKGlobal.RectToWidth(m_AxisRect) - f_AxisWidth + 1;
    // m_AxisRect.right := m_AxisRect.left + f_AxisWidth-1;
    m_AxisRightPadding := 0;
  end;
  m_LegendRect := TMKGlobal.Rect2(m_AxisRect.left, f_Y1 + 1, RectWidth(m_AxisRect) - 6, CMKConst.CHART_DRAW_XLABEL_HEIGHT);

end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.RangeEnlarge(p_XMin: Double = -1; p_XMax: Double = -1; p_Enlarge: Boolean = false);
var
  f_Line, f_Sx, f_Ex: Double;
  f_Object: Integer;
  f_Index: Integer;
  f_Size: Integer;
  f_LineSeries: CMKLineValueSeries;
  f_PriceValueArray: CMKLineValueSeries;
begin
  if (p_XMin = -1) then
    p_XMin := m_MaxMin.m_XMin;

  if (p_XMax = -1) then
    p_XMax := m_MaxMin.m_XMax;

  if (p_XMin = p_XMax) then
  begin
    m_XSize := Math.floor(TMKGlobal.RectToWidth(m_AxisRect) / 4);
    p_XMax := Math.floor(m_AbsMaxMin.m_XMax + m_PaddingRight + m_XExtraGap);
    p_XMin := Math.floor(p_XMax - m_XSize);
    m_XSize := Math.floor(p_XMax - p_XMin);
  end
  else
  begin
    p_XMax := Math.floor(p_XMax);
    p_XMin := Math.floor(p_XMin);
    m_XSize := Math.floor(p_XMax - p_XMin);
  end;

  if (p_XMin < Math.floor(m_AbsMaxMin.m_XMin)) then
    p_XMin := Math.floor(m_AbsMaxMin.m_XMin);

  if (p_XMin > Math.floor(m_AbsMaxMin.m_XMax)) then
    p_XMin := Math.floor(m_AbsMaxMin.m_XMax);

  if (p_XMax > Math.floor(m_AbsMaxMin.m_XMax + m_PaddingRight + m_XExtraGap)) then
    p_XMax := Math.floor(m_AbsMaxMin.m_XMax + m_PaddingRight + m_XExtraGap);

  m_XSize := Math.floor(p_XMax - p_XMin);

  f_Sx := p_XMin;
  f_Ex := p_XMax;
  m_MaxMin.m_YMax := -1.0E38;
  m_MaxMin.m_YMin := 1.0E38;
  m_MaxMin.m_XMin := p_XMin;
  m_MaxMin.m_XMax := p_XMax;
  f_Size := m_ObjectCollection.Count;

  for f_Object := 0 to f_Size - 1 do
  begin
    f_LineSeries := CMKLineValueSeries(m_ObjectCollection.Items[f_Object]);

    if (not f_LineSeries.m_Effect) then
      continue;

    f_LineSeries.GetLineMaxMin(Math.floor(f_Sx), Math.floor(f_Ex));

    if m_ChartIndex = 0 then
    begin
      if ((f_LineSeries.m_Type = CMKConst.LINESERIES_PRICE_AT_OPS) or (f_LineSeries.m_Type = CMKConst.LINESERIES_OPS) or
          (f_LineSeries.m_Type = CMKConst.LINESERIES_OPSIGUK) or (f_LineSeries.m_Type = CMKConst.LINESERIES_OPSIGUK2) or
          (f_LineSeries.m_Type = CMKConst.LINESERIES_OPSREL) or (f_LineSeries.m_Type = CMKConst.LINESERIES_OPSSTDDEV)) then
      begin
        continue;
      end;
    end;

    if (m_MaxMin.m_YMax < f_LineSeries.m_MaxMinTable[0].m_YMax) then
      m_MaxMin.m_YMax := f_LineSeries.m_MaxMinTable[0].m_YMax;

    if (m_MaxMin.m_YMin > f_LineSeries.m_MaxMinTable[0].m_YMin) then
      m_MaxMin.m_YMin := f_LineSeries.m_MaxMinTable[0].m_YMin;
  end;

  for f_Object := 0 to f_Size - 1 do
  begin
    f_LineSeries := CMKLineValueSeries(m_ObjectCollection.Items[f_Object]);
    if (not f_LineSeries.m_Effect) then
      continue;

    if m_ChartIndex = 0 then
    begin
      if ((f_LineSeries.m_Type = CMKConst.LINESERIES_PRICE_AT_OPS) or (f_LineSeries.m_Type = CMKConst.LINESERIES_OPS) or
          (f_LineSeries.m_Type = CMKConst.LINESERIES_OPSIGUK) or (f_LineSeries.m_Type = CMKConst.LINESERIES_OPSIGUK2) or
          (f_LineSeries.m_Type = CMKConst.LINESERIES_OPSREL) or (f_LineSeries.m_Type = CMKConst.LINESERIES_OPSSTDDEV)) then
      begin
        continue;
      end;
    end;

    f_LineSeries.m_MaxMinTable[0].m_YMax := m_MaxMin.m_YMax;
    f_LineSeries.m_MaxMinTable[0].m_YMin := m_MaxMin.m_YMin;
  end;

  m_YLogDiffer := 0;
end;

procedure CMKChartBlock.ReEnlarge(p_Value: Integer);
var
  p_XMin: Double;
  p_XMax: Double;
  f_XMaxMin: Integer;
  f_Max: Double;
  f_Size: Double;
  f_Other: Double;
begin
  if (m_ObjectCollection.Count = 0) then
    exit;
  f_XMaxMin := CMKChartBlockManager(m_ChartBlockManager).m_XMaxMin;
  p_XMax := Math.floor(m_AbsMaxMin.m_XMax + m_PaddingRight + m_XExtraGap);
  p_XMin := Math.floor(p_XMax - f_XMaxMin - (m_PaddingRight + m_XExtraGap));

  f_Max := m_AbsMaxMin.m_XMax + m_PaddingRight + m_XExtraGap;
  if (p_XMax > f_Max) then
    p_XMax := f_Max;

  if (p_XMin < m_AbsMaxMin.m_XMin) then
  begin
    f_Size := m_AbsMaxMin.m_XMin - p_XMin;
    f_Other := 0;
    p_XMax := p_XMax + f_Size;
    if (p_XMax > f_Max) then
    begin
      f_Other := p_XMax - f_Max;
      p_XMax := f_Max;
    end;

    p_XMin := p_XMin + (f_Size - f_Other);
  end;

  RangeEnlarge(p_XMin, p_XMax, false);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.Enlarge(p_Ratio: Integer);
var
  p_XMin, p_XMax, f_XMaxMin: Double;
  f_Max: Double;

  f_Size: Double;
  f_Other: Double;
begin
  if (m_ObjectCollection.Count = 0) then
    exit;

  // 이전의 봉의 넓이를 저장한다.
  if (p_Ratio > 0) then
  begin
    f_XMaxMin := Math.floor((m_MaxMin.m_XMax - m_MaxMin.m_XMin) / 1.5);
    p_XMax := Math.floor(m_MaxMin.m_XMax);
    p_XMin := Math.floor(m_MaxMin.m_XMax - f_XMaxMin);
  end
  else if (p_Ratio < 0) then
  begin
    f_XMaxMin := Math.floor((m_MaxMin.m_XMax - m_MaxMin.m_XMin) * 1.5);
    p_XMax := Math.floor(m_MaxMin.m_XMax);
    p_XMin := Math.floor(m_MaxMin.m_XMax - f_XMaxMin);
  end
  else
  begin
    f_XMaxMin := Math.floor(TMKGlobal.RectToWidth(m_AxisRect) / 4);
    p_XMax := Math.floor(m_MaxMin.m_XMax);
    p_XMin := Math.floor(p_XMax - f_XMaxMin);
  end;

  f_Max := m_AbsMaxMin.m_XMax + m_PaddingRight + m_XExtraGap;
  if (p_XMax > f_Max) then
    p_XMax := f_Max;

  if (p_XMin < m_AbsMaxMin.m_XMin) then
  begin
    f_Size := m_AbsMaxMin.m_XMin - p_XMin;
    f_Other := 0;

    p_XMax := p_XMax + f_Size;
    if (p_XMax > f_Max) then
    begin
      f_Other := p_XMax - f_Max;
      p_XMax := f_Max;
    end;

    p_XMin := p_XMin + (f_Size - f_Other);
  end;

  RangeEnlarge(p_XMin, p_XMax, false);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.EnlargeValue(p_Value: Integer);
var
  p_XMin, p_XMax, f_XMaxMin: Double;
  f_Max: Double;

  f_Size: Double;
  f_Other: Double;
begin
  if (m_ObjectCollection.Count = 0) then
    exit;

  f_XMaxMin := Math.floor(TMKGlobal.RectToWidth(m_AxisRect) / p_Value);
  p_XMax := Math.floor(m_AbsMaxMin.m_XMax + m_PaddingRight + m_XExtraGap);
  p_XMin := Math.floor(p_XMax - f_XMaxMin);

  f_Max := m_AbsMaxMin.m_XMax + m_PaddingRight + m_XExtraGap;
  if (p_XMax > f_Max) then
    p_XMax := f_Max;

  if (p_XMin < m_AbsMaxMin.m_XMin) then
  begin
    f_Size := m_AbsMaxMin.m_XMin - p_XMin;
    f_Other := 0;
    p_XMax := p_XMax + f_Size;
    if (p_XMax > f_Max) then
    begin
      f_Other := p_XMax - f_Max;
      p_XMax := f_Max;
    end;

    p_XMin := p_XMin + (f_Size - f_Other);
  end;

  RangeEnlarge(p_XMin, p_XMax, false);
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.GetEnlargeInfo(p_Ratio: Integer): CMKMaxMin;
var
  p_XMin, p_XMax, f_XMaxMin: Double;
  f_MaxMin: CMKMaxMin;
  f_Max: Double;

  f_Size: Double;
  f_Other: Double;
begin
  if (p_Ratio > 0) then
  begin
    f_XMaxMin := Math.floor((m_MaxMin.m_XMax - m_MaxMin.m_XMin) / 1.5);
    p_XMax := Math.floor(m_MaxMin.m_XMax);
    p_XMin := Math.floor(m_MaxMin.m_XMax - f_XMaxMin);
  end
  else if (p_Ratio < 0) then
  begin
    f_XMaxMin := Math.floor((m_MaxMin.m_XMax - m_MaxMin.m_XMin) * 1.5);
    p_XMax := Math.floor(m_MaxMin.m_XMax);
    p_XMin := Math.floor(m_MaxMin.m_XMax - f_XMaxMin);
  end
  else
  begin
    f_XMaxMin := Math.floor(TMKGlobal.RectToWidth(m_AxisRect) / 4);
    p_XMax := Math.floor(m_MaxMin.m_XMax);
    p_XMin := Math.floor(p_XMax - f_XMaxMin);
  end;

  f_Max := m_AbsMaxMin.m_XMax + m_PaddingRight + m_XExtraGap;
  if (p_XMax > f_Max) then
    p_XMax := f_Max;

  if (p_XMin < m_AbsMaxMin.m_XMin) then
  begin
    f_Size := m_AbsMaxMin.m_XMin - p_XMin;
    f_Other := 0;
    p_XMax := p_XMax + f_Size;
    if (p_XMax > f_Max) then
    begin
      f_Other := p_XMax - f_Max;
      p_XMax := f_Max;
    end;

    p_XMin := p_XMin + (f_Size - f_Other);
  end;

  f_MaxMin := CMKMaxMin.Create();
  f_MaxMin.m_XMin := p_XMin;
  f_MaxMin.m_XMax := p_XMax;

  Result := f_MaxMin;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.FirstEnlarge();
var
  p_XMin: Double;
  p_XMax: Double;
  f_XMaxMin: Integer;
  f_Max: Double;
  f_Size: Double;
  f_Other: Double;
begin
  if (m_ObjectCollection.Count = 0) then
    exit;

  f_XMaxMin := CMKChartBlockManager(m_ChartBlockManager).m_XMaxMin;
  p_XMax := Math.floor(m_AbsMaxMin.m_XMax + m_PaddingRight + m_XExtraGap);
  p_XMin := Math.floor(p_XMax - f_XMaxMin - (m_PaddingRight + m_XExtraGap));

  f_Max := m_AbsMaxMin.m_XMax + m_PaddingRight + m_XExtraGap;
  if (p_XMax > f_Max) then
    p_XMax := f_Max;

  if (p_XMin < m_AbsMaxMin.m_XMin) then
  begin
    f_Size := m_AbsMaxMin.m_XMin - p_XMin;
    f_Other := 0;
    p_XMax := p_XMax + f_Size;
    if (p_XMax > f_Max) then
    begin
      f_Other := p_XMax - f_Max;
      p_XMax := f_Max;
    end;

    p_XMin := p_XMin + (f_Size - f_Other);
  end;

  RangeEnlarge(p_XMin, p_XMax, false);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.SetChartDataSeries(p_ChartDataSeries: CMKStreamChartDataSeries);
begin
  m_ChartDataSeries := p_ChartDataSeries;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawAxis(p_Bitmap: TBitmap32);
var
  PenColor: TColor32;
begin
  PenColor := m_ColorSet.m_Color[CMKColorSet.AXIS_COLOR];
  PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));
  p_Bitmap.PenColor := PenColor;

  // p_Bitmap.FrameRectTS(m_AxisRect.left, m_AxisRect.top, m_AxisRect.Right, m_AxisRect.Bottom, PenColor);
  // p_Bitmap.MoveTo(m_AxisRect.Left, m_AxisRect.Top);

  // 1번인경우에만 위쪽라인을 그린다.
  // if m_ChartIndex = 1 then
  // begin
  p_Bitmap.MoveTo(m_AxisRect.left, m_AxisRect.Top);
  p_Bitmap.LineToAS(m_AxisRect.Right, m_AxisRect.Top);
  p_Bitmap.LineToAS(m_AxisRect.Right, m_AxisRect.bottom);
  p_Bitmap.LineToAS(m_AxisRect.left, m_AxisRect.bottom);
  p_Bitmap.LineToAS(m_AxisRect.left, m_AxisRect.Top - 1);
  // end
  // else
  // begin
  // p_Bitmap.MoveTo(m_AxisRect.Right, m_AxisRect.Top);
  // p_Bitmap.LineToAS(m_AxisRect.Right, m_AxisRect.Bottom-1);
  // p_Bitmap.LineToAS(m_AxisRect.Left, m_AxisRect.Bottom-1);
  // p_Bitmap.LineToAS(m_AxisRect.Left, m_AxisRect.Top-1);
  // end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawChartBoard(p_Bitmap: TBitmap32);
var
  PenColor: TColor32;
  FillColor: TColor32;
begin
  PenColor := clBlack32;
  PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(0));

  FillColor := m_ColorSet.m_Color[CMKColorSet.CHART_BACKGROUND_COLOR];
  FillColor := SetAlpha(FillColor, TMKGlobal.GetAlphaValue(100));

  p_Bitmap.FillRectTS(m_BoundRect, FillColor);
  p_Bitmap.FrameRectTS(m_BoundRect, PenColor);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawChartBackground(p_Bitmap: TBitmap32);
var
  PenColor: TColor32;
  FillColor: TColor32;
begin
  PenColor := m_ColorSet.m_Color[CMKColorSet.CHART_COLOR];
  PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(0));

  FillColor := m_ColorSet.m_Color[CMKColorSet.CHART_COLOR];
  FillColor := SetAlpha(FillColor, TMKGlobal.GetAlphaValue(100));

  p_Bitmap.FillRectTS(m_AxisRect, FillColor);
  p_Bitmap.FrameRectTS(m_AxisRect, PenColor);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawLineValueSeries_PriceLine(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries;
    p_ActiveLine: Integer = -1);
var
  f_Index, f_Xc, f_X1, f_X2, f_Y1, f_Y2, f_YHigh, f_YLow: Integer;
  f_OpenPrice, f_HighPrice, f_LowPrice, f_ClosePrice, f_ClosePrice01: Double;
  f_OpenCloseWidth, f_HighLowWidth: Integer;
  f_Color1, f_Color2: Integer;
  f_Alpha: Integer;
  f_Sx, f_Ex: Integer;
  f_YOCLowest, f_YOCHeight: Integer;
  f_ChartType: Integer;

  f_Value: Double;

  f_FirstValue: Boolean;

  PenColor: TColor32;
  FillColor: TColor32;

  drRc: TRect;
begin
  if (p_LineSeries.m_LineCount < 4) then
    exit;

  f_ChartType := Math.floor(p_LineSeries.m_Options[0]);

  f_Sx := Math.floor(m_MaxMin.m_XMin) - m_PaddingLeft;
  f_Ex := Math.floor(m_MaxMin.m_XMax) + m_PaddingRight;
  if (f_Sx < m_AbsMaxMin.m_XMin) then
    f_Sx := Math.floor(m_AbsMaxMin.m_XMin);

  if (f_Ex > m_AbsMaxMin.m_XMax) then
    f_Ex := Math.floor(m_AbsMaxMin.m_XMax);

  f_OpenCloseWidth := Round((GetScreenX(m_MaxMin.m_XMax, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]) -
      GetScreenX(m_MaxMin.m_XMin, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]])) /
      (m_MaxMin.m_XMax - m_MaxMin.m_XMin + 1));
  if (f_OpenCloseWidth <= 3) then
    f_OpenCloseWidth := 3
  else if (f_OpenCloseWidth > 4) then
    Dec(f_OpenCloseWidth)
  else
    f_OpenCloseWidth := f_OpenCloseWidth;

  f_HighLowWidth := Math.floor(f_OpenCloseWidth / 5);
  if (f_HighLowWidth > 3) then
    f_HighLowWidth := 3
  else if (f_HighLowWidth <= 3) then
    f_HighLowWidth := 1
  else
    f_HighLowWidth := f_HighLowWidth;

  if ((f_HighLowWidth MOD 2) = 1) then
  begin
    if ((f_OpenCloseWidth MOD 2) = 0) then
      Dec(f_OpenCloseWidth);
  end
  else
  begin
    if ((f_OpenCloseWidth MOD 2) = 1) then
      Dec(f_OpenCloseWidth);
  end;

  if (f_ChartType = 0) then
  begin
    for f_Index := f_Sx to f_Ex do
    begin
      f_OpenPrice := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[0];
      f_HighPrice := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[1];
      f_LowPrice := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[2];
      f_ClosePrice := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[3];
      if (f_Index > 0) then
        f_ClosePrice01 := CMKLineValue(p_LineSeries.m_Items[f_Index - 1]).m_Value[3]
      else
        f_ClosePrice01 := f_OpenPrice;

      f_Y1 := GetScreenY(f_ClosePrice, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      f_Y2 := GetScreenY(f_OpenPrice, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      f_YHigh := GetScreenY(f_HighPrice, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      f_YLow := GetScreenY(f_LowPrice, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      f_Xc := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      f_X1 := f_Xc - Math.floor(f_OpenCloseWidth / 2);
      f_X2 := f_Xc - Math.floor(f_HighLowWidth / 2);

      if (f_Y2 = f_Y1) and (f_HighPrice <> f_LowPrice) then
        f_Y2 := f_Y2 + 1;

      if (f_Y1 > f_Y2) then
      begin
        f_YOCLowest := f_Y1;
        f_YOCHeight := f_Y2;
      end
      else
      begin
        f_YOCLowest := f_Y2;
        f_YOCHeight := f_Y1;
      end;

      if (f_ClosePrice > f_OpenPrice) then
      begin
        f_Color1 := m_ColorSet.m_Color[CMKColorSet.PRICE_UP_FILLED_COLOR];
        f_Color2 := m_ColorSet.m_Color[CMKColorSet.PRICE_UP_LINE_COLOR];
      end
      else if (f_ClosePrice < f_OpenPrice) then
      begin
        f_Color1 := m_ColorSet.m_Color[CMKColorSet.PRICE_DN_FILLED_COLOR];
        f_Color2 := m_ColorSet.m_Color[CMKColorSet.PRICE_DN_LINE_COLOR];
      end
      else if (f_ClosePrice >= f_ClosePrice01) then
      begin
        f_Color1 := m_ColorSet.m_Color[CMKColorSet.PRICE_UP_FILLED_COLOR];
        f_Color2 := m_ColorSet.m_Color[CMKColorSet.PRICE_UP_LINE_COLOR];
      end
      else
      begin
        f_Color1 := m_ColorSet.m_Color[CMKColorSet.PRICE_DN_FILLED_COLOR];
        f_Color2 := m_ColorSet.m_Color[CMKColorSet.PRICE_DN_LINE_COLOR];
      end;

      f_Alpha := m_ColorSet.m_Alpha[CMKColorSet.ALPHA_PRICE_LINE];
      if (p_ActiveLine >= 0) then
        f_Alpha := TMKGlobal.GetAlphaValue(100); // 1.0

      if (f_HighPrice = f_LowPrice) then
      begin
        PenColor := f_Color2;
        PenColor := SetAlpha(PenColor, f_Alpha);
        p_Bitmap.PenColor := PenColor;

        p_Bitmap.MoveTo(f_X1, f_YOCHeight);
        p_Bitmap.LineToAS(f_X1, f_YOCHeight);
        p_Bitmap.LineToAS(f_X1 + f_OpenCloseWidth, f_YOCLowest);
      end
      else
      begin
        {
          p_Layer.graphics.lineStyle(0, f_Color2, f_Alpha, true, "NONE");
          p_Layer.graphics.moveTo(f_X2, f_YHigh);

          p_Layer.graphics.beginFill(f_Color1, f_Alpha);
          p_Layer.graphics.drawRect(f_X2, f_YHigh, f_HighLowWidth-1, f_YOCHeight-f_YHigh);
          p_Layer.graphics.endFill();

          p_Layer.graphics.beginFill(f_Color1, f_Alpha);
          p_Layer.graphics.drawRect(f_X2, f_YOCLowest, f_HighLowWidth-1, f_YLow-f_YOCLowest);
          p_Layer.graphics.endFill();

          p_Layer.graphics.beginFill(f_Color1, f_Alpha);
          p_Layer.graphics.drawRect(f_X1, f_YOCHeight, f_OpenCloseWidth-1, f_YOCLowest-f_YOCHeight);
          p_Layer.graphics.endFill();
        }

        PenColor := f_Color2;
        PenColor := SetAlpha(PenColor, f_Alpha);

        FillColor := f_Color1;
        FillColor := SetAlpha(FillColor, f_Alpha);

        drRc := TMKGlobal.GetRectToRealRect(f_X2, f_YHigh, f_X2 + f_HighLowWidth, f_YHigh + f_YOCHeight - f_YHigh);
        p_Bitmap.FillRectTS(drRc, FillColor);
        p_Bitmap.FrameRectTS(drRc, PenColor);

        drRc := TMKGlobal.GetRectToRealRect(f_X2, f_YOCLowest, f_X2 + f_HighLowWidth, f_YOCLowest + f_YLow - f_YOCLowest);
        p_Bitmap.FillRectTS(drRc, FillColor);
        p_Bitmap.FrameRectTS(drRc, PenColor);

        drRc := TMKGlobal.GetRectToRealRect(f_X1, f_YOCHeight, f_X1 + f_OpenCloseWidth,
            f_YOCHeight + f_YOCLowest - f_YOCHeight);
        p_Bitmap.FillRectTS(drRc, FillColor);
        p_Bitmap.FrameRectTS(drRc, PenColor);
      end;
    end;
  end
  else if (f_ChartType = 1) then
  begin

    f_Color1 := m_ColorSet.m_Color[CMKColorSet.PRICE_COLOR];
    f_Alpha := m_ColorSet.m_Alpha[CMKColorSet.ALPHA_PRICE_LINE];
    if (p_ActiveLine >= 0) then
      f_Alpha := TMKGlobal.GetAlphaValue(100); // 1.0;

    for f_Index := f_Sx to f_Ex do
    begin
      f_OpenPrice := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[0];
      f_HighPrice := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[1];
      f_LowPrice := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[2];
      f_ClosePrice := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[3];

      f_Y1 := GetScreenY(f_ClosePrice, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      f_Y2 := GetScreenY(f_OpenPrice, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      f_YHigh := GetScreenY(f_HighPrice, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      f_YLow := GetScreenY(f_LowPrice, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      f_Xc := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      f_X1 := f_Xc - Math.floor(f_OpenCloseWidth / 2);
      f_X2 := f_Xc - Math.floor(f_HighLowWidth / 2);

      if (f_HighPrice = f_LowPrice) then
      begin
        PenColor := f_Color1;
        PenColor := SetAlpha(PenColor, f_Alpha);
        p_Bitmap.PenColor := PenColor;

        p_Bitmap.MoveTo(f_X1, f_Y2);
        p_Bitmap.LineToAS(f_X1, f_Y2);
        p_Bitmap.LineToAS(f_X1 + f_OpenCloseWidth, f_Y2);
      end
      else
      begin
        PenColor := f_Color1;
        PenColor := SetAlpha(PenColor, f_Alpha);

        FillColor := f_Color1;
        FillColor := SetAlpha(FillColor, f_Alpha);

        p_Bitmap.PenColor := PenColor;

        p_Bitmap.MoveTo(f_X1, f_Y2);
        p_Bitmap.LineToAS(f_X2, f_Y2);
        p_Bitmap.MoveTo(f_X2 + f_HighLowWidth - 1, f_Y1);
        p_Bitmap.LineToAS(f_X1 + f_OpenCloseWidth - 1, f_Y1);

        p_Bitmap.MoveTo(f_X2, f_YHigh);
        p_Bitmap.LineToAS(f_X2 + f_HighLowWidth - 1, f_YHigh);
        p_Bitmap.LineToAS(f_X2 + f_HighLowWidth - 1, f_YLow + 1);
        p_Bitmap.LineToAS(f_X2, f_YLow + 1);
        p_Bitmap.LineToAS(f_X2, f_YHigh);
      end;
    end;
  end
  else if (f_ChartType = 2) then
  begin
    f_Color1 := m_ColorSet.m_Color[CMKColorSet.PRICE_COLOR];
    f_Alpha := m_ColorSet.m_Alpha[CMKColorSet.ALPHA_PRICE_LINE];
    if (p_ActiveLine >= 0) then
      f_Alpha := TMKGlobal.GetAlphaValue(100); // 1.0;

    PenColor := f_Color1;
    PenColor := SetAlpha(PenColor, f_Alpha);
    p_Bitmap.PenColor := PenColor;

    f_FirstValue := true;
    f_X1 := 0;
    f_Y1 := 0;

    for f_Index := f_Sx to f_Ex do
    begin
      f_ClosePrice := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[3];
      f_X2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      f_Value := f_ClosePrice;

      f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      if (f_FirstValue) then
      begin
        p_Bitmap.MoveTo(f_X2, f_Y2 - 1);
        f_FirstValue := false;
      end
      else
        p_Bitmap.LineToAS(f_X2, f_Y2 - 1);

      f_X1 := f_X2;
      f_Y1 := f_Y2;
    end;

    f_FirstValue := true;
    f_X1 := 0;
    f_Y1 := 0;

    for f_Index := f_Sx to f_Ex do
    begin
      f_ClosePrice := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[3];
      f_X2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      f_Value := f_ClosePrice;

      f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      if (f_FirstValue) then
      begin
        p_Bitmap.MoveTo(f_X2, f_Y2);
        f_FirstValue := false;
      end
      else
        p_Bitmap.LineToAS(f_X2, f_Y2);

      f_X1 := f_X2;
      f_Y1 := f_Y2;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawLineValueSeries_VolumeLine(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries;
    p_ActiveLine: Integer = -1);
var
  f_Index, f_Xc, f_X1, f_X2, f_Y1, f_Y2: Integer;
  f_Sx, f_Ex: Integer;
  f_Color1, f_Color2: Integer;
  f_OpenCloseWidth, f_HighLowWidth: Integer;
  f_Alpha: Integer;
  f_LineColor: Integer;

  PenColor: TColor32;
  FillColor: TColor32;
begin
  if (p_LineSeries.m_LineCount < 1) then
    exit;

  f_Sx := Math.floor(m_MaxMin.m_XMin) - m_PaddingLeft;
  f_Ex := Math.floor(m_MaxMin.m_XMax) + m_PaddingRight;
  if (f_Sx < m_AbsMaxMin.m_XMin) then
    f_Sx := Math.floor(m_AbsMaxMin.m_XMin);

  if (f_Ex > m_AbsMaxMin.m_XMax - 1) then
    f_Ex := Math.floor(m_AbsMaxMin.m_XMax);

  f_OpenCloseWidth := Round((GetScreenX(m_MaxMin.m_XMax, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]) -
      GetScreenX(m_MaxMin.m_XMin, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]])) /
      (m_MaxMin.m_XMax - m_MaxMin.m_XMin + 1));
  if (f_OpenCloseWidth <= 0) then
    f_OpenCloseWidth := 1
  else if (f_OpenCloseWidth > 4) then
    Dec(f_OpenCloseWidth)
  else
    f_OpenCloseWidth := f_OpenCloseWidth;

  f_HighLowWidth := Math.floor(f_OpenCloseWidth / 5);
  if (f_HighLowWidth > 3) then
    f_HighLowWidth := 3
  else if (f_HighLowWidth <= 0) then
    f_HighLowWidth := 1
  else
    f_HighLowWidth := f_HighLowWidth;

  if ((f_HighLowWidth MOD 2) = 1) then
  begin
    if ((f_OpenCloseWidth MOD 2) = 0) then
      Dec(f_OpenCloseWidth);
  end
  else
  begin
    if ((f_OpenCloseWidth MOD 2) = 1) then
      Dec(f_OpenCloseWidth);
  end;

  for f_Index := f_Sx to f_Ex do
  begin
    f_Y1 := GetScreenY(0, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
    f_Y2 := GetScreenY(CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[0],
        p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
    f_Xc := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
    f_X1 := f_Xc - Math.floor(f_OpenCloseWidth / 2);
    f_X2 := f_X1 + f_OpenCloseWidth;
    if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[1] > 0) then
    begin
      f_Color1 := m_ColorSet.m_Color[CMKColorSet.VOLUME_FILLED_COLOR];
      f_Color2 := m_ColorSet.m_Color[CMKColorSet.VOLUME_LINE_COLOR];
    end
    else
    begin
      f_Color1 := m_ColorSet.m_Color[CMKColorSet.VOLUME_FILLED_COLOR];
      f_Color2 := m_ColorSet.m_Color[CMKColorSet.VOLUME_LINE_COLOR];
    end;

    f_Alpha := m_ColorSet.m_Alpha[CMKColorSet.ALPHA_VOLUME_LINE];

    if (p_ActiveLine >= 0) then
      f_Alpha := TMKGlobal.GetAlphaValue(100); // 1.0;

    PenColor := f_Color1;
    PenColor := SetAlpha(PenColor, f_Alpha);

    FillColor := f_Color1;
    FillColor := SetAlpha(FillColor, TMKGlobal.GetAlphaValue(100));

    p_Bitmap.FillRectTS(f_X1, f_Y2, f_X1 + (f_X2 - f_X1 - 1), f_Y2 + (f_Y1 - f_Y2 - 1), FillColor);
    p_Bitmap.FrameRectTS(f_X1, f_Y2, f_X1 + (f_X2 - f_X1), f_Y2 + (f_Y1 - f_Y2), PenColor);

    PenColor := f_Color2;
    PenColor := SetAlpha(PenColor, f_Alpha);
    p_Bitmap.PenColor := PenColor;

    p_Bitmap.MoveTo(f_X1, f_Y2);
    p_Bitmap.LineToAS(f_X1, f_Y1);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawLineValueSeries_NetLine(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries;
    p_ActiveLine: Integer = -1);
var
  f_Index, f_Xc, f_X1, f_X2, f_Y1, f_Y2: Integer;
  f_Line: Integer;
  f_Alpha: Integer;
  f_Sx, f_Ex: Integer;
  f_Color1, f_Color2, f_Color3: Integer;
  f_OpenCloseWidth, f_HighLowWidth: Integer;

  f_Value: Double;
  f_FirstValue: Boolean;

  PenColor: TColor32;
  FillColor: TColor32;

  H, S, V: Single;
begin
  if (p_LineSeries.m_LineCount < 1) then
    exit;

  f_Sx := Math.floor(m_MaxMin.m_XMin) - m_PaddingLeft;
  f_Ex := Math.floor(m_MaxMin.m_XMax) + m_PaddingRight;
  if (f_Sx < m_AbsMaxMin.m_XMin) then
    f_Sx := Math.floor(m_AbsMaxMin.m_XMin);

  if (f_Ex > m_AbsMaxMin.m_XMax) then
    f_Ex := Math.floor(m_AbsMaxMin.m_XMax);

  f_OpenCloseWidth := Math.floor((GetScreenX(m_MaxMin.m_XMax, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]) -
      GetScreenX(m_MaxMin.m_XMin, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]])) /
      (m_MaxMin.m_XMax - m_MaxMin.m_XMin + 1));
  if (f_OpenCloseWidth <= 0) then
    f_OpenCloseWidth := 1
  else if (f_OpenCloseWidth > 4) then
    Dec(f_OpenCloseWidth)
  else
    f_OpenCloseWidth := f_OpenCloseWidth;

  f_HighLowWidth := Math.floor(f_OpenCloseWidth / 5);
  if (f_HighLowWidth > 3) then
    f_HighLowWidth := 3
  else if (f_HighLowWidth <= 0) then
    f_HighLowWidth := 1
  else
    f_HighLowWidth := f_HighLowWidth;

  if ((f_HighLowWidth MOD 2) = 1) then
  begin
    if ((f_OpenCloseWidth MOD 2) = 0) then
      Dec(f_OpenCloseWidth);
  end
  else
  begin
    if ((f_OpenCloseWidth MOD 2) = 1) then
      Dec(f_OpenCloseWidth);
  end;

  f_X1 := 0;
  f_Y1 := 0;
  for f_Line := 0 to p_LineSeries.m_LineCount - 1 do
  begin
    if (not p_LineSeries.m_LineVisibles[f_Line]) then
      continue;

    if ((p_ActiveLine >= 0) and (p_ActiveLine <> f_Line)) then
      continue;

    f_Alpha := m_ColorSet.m_Alpha[p_LineSeries.m_LineAlphas[f_Line]];
    f_Color1 := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
    if (p_ActiveLine = f_Line) then
    begin
      RGBtoHSL(f_Color1, H, S, V);
      PenColor := HSLtoRGB(H, S * CMKColorSet.ACTIVE_FACTOR, V * CMKColorSet.ACTIVE_FACTOR);
    end;

    PenColor := f_Color1;
    PenColor := SetAlpha(PenColor, f_Alpha);
    p_Bitmap.PenColor := PenColor;

    f_FirstValue := true;
    for f_Index := f_Sx to f_Ex do
    begin
      if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
        continue;

      f_X2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
      f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

      f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
      if (f_FirstValue) then
      begin
        p_Bitmap.MoveTo(f_X2, f_Y2);
        f_FirstValue := false;
      end
      else
        p_Bitmap.LineToAS(f_X2, f_Y2);

      f_X1 := f_X2;
      f_Y1 := f_Y2;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawLineValueSeries_Line(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries;
    p_ActiveLine: Integer = -1);
var
  f_Index, f_Xc, f_X1, f_X2, f_Y1, f_Y2: Integer;
  f_Line: Integer;
  f_Sx, f_Ex: Integer;
  f_Color1, f_Color2: Integer;
  f_Alpha: Integer;
  f_LineColor: Integer;
  f_OpenCloseWidth, f_HighLowWidth: Integer;

  f_Value: Double;
  f_FirstValue: Boolean;

  PenColor: TColor32;
  FillColor: TColor32;

  drRc: TRect;
  f_Step: Integer;

  f_MaxMin: CMKMaxMin;
begin
  if (p_LineSeries.m_LineCount < 1) then
    exit;

  f_Sx := Math.floor(m_MaxMin.m_XMin) - m_PaddingLeft;
  f_Ex := Math.floor(m_MaxMin.m_XMax) + m_PaddingRight;
  if (f_Sx < m_AbsMaxMin.m_XMin) then
    f_Sx := Math.floor(m_AbsMaxMin.m_XMin);

  if (f_Ex > m_AbsMaxMin.m_XMax) then
    f_Ex := Math.floor(m_AbsMaxMin.m_XMax);

  f_OpenCloseWidth := Round((GetScreenX(m_MaxMin.m_XMax, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]) -
      GetScreenX(m_MaxMin.m_XMin, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]])) /
      (m_MaxMin.m_XMax - m_MaxMin.m_XMin + 1));

  if (f_OpenCloseWidth <= 0) then
  begin
    f_OpenCloseWidth := 1
  end
  else if (f_OpenCloseWidth > 4) then
  begin
    Dec(f_OpenCloseWidth)
  end
  else
  begin
    f_OpenCloseWidth := f_OpenCloseWidth;
  end;

  f_HighLowWidth := Math.floor(f_OpenCloseWidth / 5);
  if (f_HighLowWidth > 3) then
  begin
    f_HighLowWidth := 3
  end
  else if (f_HighLowWidth <= 0) then
  begin
    f_HighLowWidth := 1
  end
  else
  begin
    f_HighLowWidth := f_HighLowWidth;
  end;

  if ((f_HighLowWidth MOD 2) = 1) then
  begin
    if ((f_OpenCloseWidth MOD 2) = 0) then
      Dec(f_OpenCloseWidth);
  end
  else
  begin
    if ((f_OpenCloseWidth MOD 2) = 1) then
      Dec(f_OpenCloseWidth);
  end;

  f_X1 := 0;
  f_Y1 := 0;
  for f_Line := 0 to p_LineSeries.m_LineCount - 1 do
  begin
    if (not p_LineSeries.m_Effect) then
      continue;
    if (not p_LineSeries.m_LineVisibles[f_Line]) then
      continue;
    if ((p_ActiveLine >= 0) and (p_ActiveLine <> f_Line)) then
      continue;

{$REGION '라인'}
    if (p_LineSeries.m_LineTypes[f_Line] = 0) then
    begin

      if (p_LineSeries.m_LineWidths[f_Line] > 0) then
      begin
        PenColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
        PenColor := SetAlpha(PenColor, m_ColorSet.m_Alpha[CMKColorSet.ALPHA_LIGHT_LINE]);
        p_Bitmap.Canvas.Pen.Width := p_LineSeries.m_LineWidths[f_Line];

        p_Bitmap.PenColor := PenColor;

        f_FirstValue := true;

        for f_Index := f_Sx to f_Ex do
        begin
          if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
            continue;

          if p_LineSeries.m_TradeStrategy then
          begin
            f_MaxMin := m_MaxMin;
          end
          else
          begin
            f_MaxMin := p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]];
          end;

          f_X2 := GetScreenXCenter(f_Index, f_MaxMin);

          f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];
          f_Y2 := GetScreenY(f_Value, f_MaxMin);

          if (f_FirstValue) then
          begin
            p_Bitmap.MoveTo(f_X2, f_Y2 - 1);
            f_FirstValue := false;
          end
          else
          begin
            p_Bitmap.LineToAS(f_X2, f_Y2 - 1);
          end;

          f_X1 := f_X2;
          f_Y1 := f_Y2;
        end;
      end;

      if (p_LineSeries.m_Type = CMKConst.LINESERIES_CLOSE) then
        f_Alpha := m_ColorSet.m_Alpha[CMKColorSet.ALPHA_PRICE_LINE]
      else if (p_LineSeries.m_Type = CMKConst.LINESERIES_MA) then
        f_Alpha := m_ColorSet.m_Alpha[CMKColorSet.ALPHA_MA_LINE]
      else
        f_Alpha := m_ColorSet.m_Alpha[p_LineSeries.m_LineAlphas[f_Line]];

      f_LineColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
      if (p_ActiveLine = f_Line) then
        f_Alpha := TMKGlobal.GetAlphaValue(100); // 1.0

      PenColor := f_LineColor;
      PenColor := SetAlpha(PenColor, f_Alpha);
      p_Bitmap.PenColor := PenColor;

      f_FirstValue := true;

      for f_Index := f_Sx to f_Ex do
      begin
        // :[]
        if f_Index > p_LineSeries.m_Items.Count then
        begin
          f_FirstValue := false;
          exit;
        end;

        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
          continue;

        if p_LineSeries.m_TradeStrategy then
        begin
          f_MaxMin := m_MaxMin;
        end
        else
        begin
          f_MaxMin := p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]];
        end;

        f_X2 := GetScreenXCenter(f_Index, f_MaxMin);
        f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

        f_Y2 := GetScreenY(f_Value, f_MaxMin);
        if (f_FirstValue) then
        begin
          p_Bitmap.MoveTo(f_X2, f_Y2 - 1);
          f_FirstValue := false;
        end
        else
        begin
          p_Bitmap.LineToAS(f_X2, f_Y2 - 1);
        end;

        f_X1 := f_X2;
        f_Y1 := f_Y2;
      end;
      f_FirstValue := true;

      for f_Index := f_Sx to f_Ex do
      begin
        // :[]
        if f_Index > p_LineSeries.m_Items.Count then
        begin
          f_FirstValue := false;
          exit;
        end;

        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
          continue;

        if p_LineSeries.m_TradeStrategy then
        begin
          f_MaxMin := m_MaxMin;
        end
        else
        begin
          f_MaxMin := p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]];
        end;

        f_X2 := GetScreenXCenter(f_Index, f_MaxMin);
        f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

        f_Y2 := GetScreenY(f_Value, f_MaxMin);
        if (f_FirstValue) then
        begin
          p_Bitmap.MoveTo(f_X2, f_Y2);
          f_FirstValue := false;
        end
        else
        begin
          p_Bitmap.LineToAS(f_X2, f_Y2);
        end;

        f_X1 := f_X2;
        f_Y1 := f_Y2;
      end;
    end
{$ENDREGION}
{$REGION '바'}
    else if (p_LineSeries.m_LineTypes[f_Line] = 1) then // 바
    begin
      for f_Index := f_Sx to f_Ex do
      begin
        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
          continue;

        if p_LineSeries.m_TradeStrategy then
        begin
          f_MaxMin := m_MaxMin;
        end
        else
        begin
          f_MaxMin := p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]];
        end;

        f_Xc := GetScreenXCenter(f_Index, f_MaxMin);
        f_X1 := f_Xc - Math.floor(f_OpenCloseWidth / 2);
        f_X2 := f_X1 + f_OpenCloseWidth;

        if (m_MaxMin.m_YMin < 0) then
          f_Y1 := GetScreenY(0, f_MaxMin)
        else
          f_Y1 := GetScreenY(m_MaxMin.m_YMin, f_MaxMin);

        f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

        f_Y2 := GetScreenY(f_Value, f_MaxMin);

        f_Alpha := m_ColorSet.m_Alpha[p_LineSeries.m_LineAlphas[f_Line]];
        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] > 0) then
        begin
          f_Color1 := m_ColorSet.m_Color[CMKColorSet.OSC_UP_FILLED_COLOR];
          f_Color2 := m_ColorSet.m_Color[CMKColorSet.OSC_UP_FILLED_COLOR];
        end
        else
        begin
          f_Color1 := m_ColorSet.m_Color[CMKColorSet.OSC_DN_FILLED_COLOR];
          f_Color2 := m_ColorSet.m_Color[CMKColorSet.OSC_DN_FILLED_COLOR];
        end;

        f_LineColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
        if (p_ActiveLine = f_Line) then
          f_Alpha := TMKGlobal.GetAlphaValue(100); // 1.0;

        PenColor := f_Color2;
        PenColor := SetAlpha(PenColor, f_Alpha);
        p_Bitmap.PenColor := PenColor;

        FillColor := f_Color1;
        FillColor := SetAlpha(FillColor, m_ColorSet.m_Alpha[p_LineSeries.m_LineAlphas[f_Line]]);

        p_Bitmap.MoveTo(f_X1, f_Y1);
        p_Bitmap.LineToAS(f_X2 - 1, f_Y1);
        p_Bitmap.LineToAS(f_X2 - 1, f_Y2);
        p_Bitmap.LineToAS(f_X1, f_Y2);
        p_Bitmap.LineToAS(f_X1, f_Y1);

        drRc := TMKGlobal.GetRectToRealRect(f_X1, f_Y1, f_X2 - 1, f_Y2);
        p_Bitmap.FillRectTS(drRc, FillColor);

      end;
    end
{$ENDREGION}
{$REGION '점'}
    else if (p_LineSeries.m_LineTypes[f_Line] = 2) then // 점
    begin
      f_Alpha := m_ColorSet.m_Alpha[p_LineSeries.m_LineAlphas[f_Line]];
      f_LineColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
      if (p_ActiveLine = f_Line) then
        f_Alpha := TMKGlobal.GetAlphaValue(100); // 1.0;

      PenColor := f_LineColor;
      PenColor := SetAlpha(PenColor, f_Alpha);
      p_Bitmap.PenColor := PenColor;

      if p_LineSeries.m_TradeStrategy then
      begin
        f_MaxMin := m_MaxMin;
      end
      else
      begin
        f_MaxMin := p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]];
      end;

      for f_Index := f_Sx to f_Ex do
      begin
        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
          continue;

        f_Xc := GetScreenXCenter(f_Index, f_MaxMin);
        f_X1 := f_Xc - Math.floor(f_OpenCloseWidth / 2);
        f_X2 := f_X1 + f_OpenCloseWidth;

        f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

        f_Y2 := GetScreenY(f_Value, f_MaxMin);

        FillColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
        FillColor := SetAlpha(FillColor, f_Alpha);

        p_Bitmap.MoveTo(f_X1, f_Y2 - 1);
        p_Bitmap.LineToAS(f_X2 - 1, f_Y2 - 1);
        p_Bitmap.LineToAS(f_X2 - 1, f_Y2 + 1);
        p_Bitmap.LineToAS(f_X1, f_Y2 + 1);
        p_Bitmap.LineToAS(f_X1, f_Y2 - 1);

        drRc := TMKGlobal.GetRectToRealRect(f_X1, f_Y2 - 1, f_X2 - 1, f_Y2 + 1);
        p_Bitmap.FillRectTS(drRc, FillColor);

      end;
    end;
{$ENDREGION}
  end;
end;

function CMKChartBlock.GetSignalRange(var p_Signal, p_Start, p_End: Integer; p_Position: Integer): Boolean;
var
  f_Index, f_Object, f_Line: Integer;
  f_ValueArray: CMKLineValueSeries;
  f_Enabled: Boolean;
  f_SIndex0, f_SIndex1, f_SIndex2: Integer;
  f_Signal: Integer;
  f_LineValue: CMKLineValue;
begin
  if m_ChartDataSeries = NIL then
  begin
    Result := false;
    exit;
  end;
  f_Enabled := false;
  if ((p_Position < 0) or (p_Position >= m_ChartDataSeries.m_Items.Count)) then
  begin
    Result := false;
    exit;
  end;

  for f_Object := 0 to m_ObjectCollection.Count - 1 do
  begin
    f_ValueArray := CMKLineValueSeries(m_ObjectCollection.Items[f_Object]);

    if f_ValueArray.m_Signal then
    begin
      f_SIndex0 := p_Position;
      if (f_SIndex0 >= 0) AND (f_SIndex0 < f_ValueArray.m_Items.Count) then
      begin
        f_LineValue := f_ValueArray.m_Items[f_SIndex0];
        if f_LineValue.m_Value[0] <> NOT_VALUE then
        begin
          f_Signal := floor(f_LineValue.m_Value[0]);

          if (f_Signal = 1) OR (f_Signal = -1) then
          begin
            f_SIndex1 := 0;
            for f_Index := f_SIndex0 downto 0 do
            begin
              f_LineValue := f_ValueArray.m_Items[f_Index];
              if f_Signal <> f_LineValue.m_Value[0] then
              begin
                f_SIndex1 := f_Index + 1;
                break;
              end;
            end;
            f_SIndex2 := f_ValueArray.m_Items.Count - 1;
            for f_Index := f_SIndex0 to f_ValueArray.m_Items.Count - 1 do
            begin
              f_LineValue := f_ValueArray.m_Items[f_Index];
              if f_Signal <> f_LineValue.m_Value[0] then
              begin
                f_SIndex2 := f_Index - 1;
                break;
              end;
            end;

            f_Enabled := true;
            p_Signal := f_Signal;
            p_Start := f_SIndex1;
            p_End := f_SIndex2;

          end
          else
          begin
            f_Enabled := false;
          end
        end
        else
        begin
          f_Enabled := false;
        end;
      end
      else
      begin
        f_Enabled := false;
      end;

      break;
    end;

    if (f_Enabled) then
      break;
  end;

  Result := f_Enabled;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawSignalTrace(p_Signal, p_Start, p_End: Integer);
var
  f_Index, f_Xc, f_X1, f_X2, f_Y1, f_Y2: Integer;
  f_Color1, f_Color2: Integer;
  PenColor, FillColor: TColor32;
  drRc: TRect;
begin
  if m_ChartIndex <> 0 then
    exit;

  f_X1 := GetScreenXCenter(p_Start, m_MaxMin);
  f_X2 := GetScreenXCenter(p_End, m_MaxMin);
  f_Y1 := Self.m_AxisRect.Top + m_PaddingTop;
  f_Y2 := Self.m_AxisRect.bottom;

  if (p_Signal > 0) then
  begin
    FillColor := m_ColorSet.m_Color[CMKColorSet.PRICE_UP_FILLED_COLOR];
    PenColor := m_ColorSet.m_Color[CMKColorSet.PRICE_UP_FILLED_COLOR];
  end
  else if (p_Signal < 0) then
  begin
    FillColor := m_ColorSet.m_Color[CMKColorSet.PRICE_DN_FILLED_COLOR];
    PenColor := m_ColorSet.m_Color[CMKColorSet.PRICE_DN_FILLED_COLOR];
  end
  else
  begin
    FillColor := m_ColorSet.m_Color[CMKColorSet.CHART_COLOR];
    PenColor := m_ColorSet.m_Color[CMKColorSet.GRID_COLOR];
  end;

  m_SignalLayer.Bitmap.ResetClipRect;
  m_SignalLayer.Bitmap.ClipRect := m_AxisRect;

  FillColor := SetAlpha(FillColor, TMKGlobal.GetAlphaValue(10));
  drRc := TMKGlobal.GetRectToRealRect(f_X1, f_Y1, f_X2, f_Y2);
  m_SignalLayer.Bitmap.FillRectTS(drRc, FillColor);

  PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(80));
  m_SignalLayer.Bitmap.PenColor := PenColor;

  m_SignalLayer.Bitmap.MoveTo(f_X1, f_Y1);
  m_SignalLayer.Bitmap.LineToAS(f_X1, f_Y2);

  m_SignalLayer.Bitmap.MoveTo(f_X2, f_Y1);
  m_SignalLayer.Bitmap.LineToAS(f_X2, f_Y2);

  m_SignalLayer.Bitmap.ResetClipRect;
  m_SignalLayer.Bitmap.ClipRect := m_BoundRect;
end;

procedure CMKChartBlock.DrawLineValueSeries_TradeStrategySignal(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries;
    p_ActiveLine: Integer = -1);
var
  f_Index, f_Xc, f_X1, f_X2, f_Y1, f_Y2, f_Step: Integer;
  f_Line: Integer;
  f_Sx, f_Ex: Integer;
  f_Color1, f_Color2: Integer;
  f_Alpha: Integer;
  f_LineColor: Integer;
  f_OpenCloseWidth, f_HighLowWidth: Integer;

  f_Value: Double;
  f_FirstValue: Boolean;

  PenColor: TColor32;
  FillColor: TColor32;

  drRc: TRect;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_LineValue2: CMKLineValue;

  f_SignalIndex: Integer;
begin
  if (p_LineSeries.m_LineCount < 1) then
    exit;

  f_Sx := Math.floor(m_MaxMin.m_XMin) - m_PaddingLeft;
  f_Ex := Math.floor(m_MaxMin.m_XMax) + m_PaddingRight;
  if (f_Sx < m_AbsMaxMin.m_XMin) then
    f_Sx := Math.floor(m_AbsMaxMin.m_XMin);

  if (f_Ex > m_AbsMaxMin.m_XMax) then
    f_Ex := Math.floor(m_AbsMaxMin.m_XMax);

  if (f_Ex > p_LineSeries.m_Items.Count - 1) then
    f_Ex := p_LineSeries.m_Items.Count - 1;

  f_OpenCloseWidth := Round((GetScreenX(m_MaxMin.m_XMax, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]) -
      GetScreenX(m_MaxMin.m_XMin, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]])) /
      (m_MaxMin.m_XMax - m_MaxMin.m_XMin + 1));
  if (f_OpenCloseWidth <= 0) then
    f_OpenCloseWidth := 1
  else if (f_OpenCloseWidth > 4) then
    Dec(f_OpenCloseWidth)
  else
    f_OpenCloseWidth := f_OpenCloseWidth;

  f_HighLowWidth := Math.floor(f_OpenCloseWidth / 5);
  if (f_HighLowWidth > 3) then
    f_HighLowWidth := 3
  else if (f_HighLowWidth <= 0) then
    f_HighLowWidth := 1
  else
    f_HighLowWidth := f_HighLowWidth;

  if ((f_HighLowWidth MOD 2) = 1) then
  begin
    if ((f_OpenCloseWidth MOD 2) = 0) then
      Dec(f_OpenCloseWidth);
  end
  else
  begin
    if ((f_OpenCloseWidth MOD 2) = 1) then
      Dec(f_OpenCloseWidth);
  end;

  f_X1 := 0;
  f_Y1 := 0;
  for f_Line := p_LineSeries.m_LineCount - 1 downto 0 do
  begin
    if (not p_LineSeries.m_Effect) then
      continue;
    if not p_LineSeries.m_LineVisibles[f_Line] then
      continue;
    if ((p_ActiveLine >= 0) and (p_ActiveLine <> f_Line)) then
      continue;

    if (p_LineSeries.m_LineTypes[f_Line] = 4) then
    begin

      for f_Index := f_Sx to f_Ex do
      begin
        f_LineValue0 := p_LineSeries.m_Items[f_Index];

        if (f_LineValue0.m_Value[f_Line] = NOT_VALUE) then
          continue;

        f_X1 := GetScreenXCenter(f_Index, m_MaxMin);
        f_X2 := GetScreenXCenter(f_Index + 1, m_MaxMin);
        f_Y1 := Self.m_AxisRect.Top + m_PaddingTop;
        f_Y2 := Self.m_AxisRect.bottom;

        f_Alpha := TMKGlobal.GetAlphaValue(10);

        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] > 0) then
        begin
          f_Color1 := m_ColorSet.m_Color[CMKColorSet.PRICE_UP_FILLED_COLOR];
        end
        else if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] < 0) then
        begin
          f_Color1 := m_ColorSet.m_Color[CMKColorSet.PRICE_DN_FILLED_COLOR];
        end
        else
        begin
          f_Color1 := m_ColorSet.m_Color[CMKColorSet.CHART_COLOR];
        end;

        FillColor := SetAlpha(f_Color1, f_Alpha);
        drRc := TMKGlobal.GetRectToRealRect(f_X1, f_Y1, f_X2, f_Y2);
        p_Bitmap.FillRectTS(drRc, FillColor);

        PenColor := SetAlpha(f_Color1, 100);

        p_Bitmap.PenColor := PenColor;

        if (f_Index > 0) then
        begin
          f_LineValue1 := p_LineSeries.m_Items[f_Index - 1];
          if (f_LineValue1.m_Value[f_Line] <> NOT_VALUE) then
          begin
            if (f_LineValue0.m_Value[f_Line] <> f_LineValue1.m_Value[f_Line]) then
            begin
              p_Bitmap.MoveTo(f_X1, f_Y1);
              p_Bitmap.LineToAS(f_X1, f_Y2);
            end;
          end;
        end;
      end;

      break;

    end;
  end;

  f_SignalIndex := 0;

  f_X1 := 0;
  f_Y1 := 0;
  for f_Line := 0 to p_LineSeries.m_LineCount - 1 do
  begin
    if (not p_LineSeries.m_Effect) then
      continue;
    if not p_LineSeries.m_LineVisibles[f_Line] then
      continue;
    if ((p_ActiveLine >= 0) and (p_ActiveLine <> f_Line)) then
      continue;

    if (p_LineSeries.m_LineTypes[f_Line] = 4) then
    begin
      Inc(f_SignalIndex);

      for f_Index := f_Sx to f_Ex do
      begin
        f_LineValue0 := p_LineSeries.m_Items[f_Index];

        if (f_LineValue0.m_Value[f_Line] = NOT_VALUE) then
          continue;

        f_X1 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
        f_X2 := GetScreenXCenter(f_Index + 1, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
        f_Y1 := Self.m_AxisRect.bottom - (f_SignalIndex) * 6 - 2;
        f_Y2 := Self.m_AxisRect.bottom - (f_SignalIndex - 1) * 6;

        f_Alpha := TMKGlobal.GetAlphaValue(80);
        if (f_LineValue0.m_Value[f_Line] > 0) then
        begin
          f_Color1 := m_ColorSet.m_Color[CMKColorSet.PRICE_UP_FILLED_COLOR];
        end
        else if (f_LineValue0.m_Value[f_Line] < 0) then
        begin
          f_Color1 := m_ColorSet.m_Color[CMKColorSet.PRICE_DN_FILLED_COLOR];
        end
        else
        begin
          f_Color1 := m_ColorSet.m_Color[CMKColorSet.CHART_COLOR];
          f_Alpha := TMKGlobal.GetAlphaValue(0);
        end;

        FillColor := SetAlpha(f_Color1, f_Alpha);

        drRc := TMKGlobal.GetRectToRealRect(f_X1, f_Y1, f_X2, f_Y2);
        p_Bitmap.FillRectTS(drRc, FillColor);
      end;
    end
  end;

  f_X1 := 0;
  f_Y1 := 0;
  for f_Line := 0 to p_LineSeries.m_LineCount - 1 do
  begin
    if (not p_LineSeries.m_Effect) then
      continue;
    if not p_LineSeries.m_LineVisibles[f_Line] then
      continue;
    if ((p_ActiveLine >= 0) and (p_ActiveLine <> f_Line)) then
      continue;

    // 라인
    if (p_LineSeries.m_LineTypes[f_Line] = 0) then
    begin

      if (p_LineSeries.m_Type = CMKConst.LINESERIES_CLOSE) then
        f_Alpha := m_ColorSet.m_Alpha[CMKColorSet.ALPHA_PRICE_LINE]
      else if (p_LineSeries.m_Type = CMKConst.LINESERIES_MA) then
        f_Alpha := m_ColorSet.m_Alpha[CMKColorSet.ALPHA_MA_LINE]
      else
        f_Alpha := m_ColorSet.m_Alpha[p_LineSeries.m_LineAlphas[f_Line]];

      f_LineColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
      if (p_ActiveLine = f_Line) then
        f_Alpha := TMKGlobal.GetAlphaValue(100);
      PenColor := f_LineColor;
      PenColor := SetAlpha(PenColor, f_Alpha);
      p_Bitmap.PenColor := PenColor;

      f_FirstValue := true;

      for f_Index := f_Sx to f_Ex do
      begin
        // :[]
        if f_Index > p_LineSeries.m_Items.Count then
        begin
          f_FirstValue := false;
          exit;
        end;

        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
          continue;

        f_X2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);

        f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

        f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
        if (f_FirstValue) then
        begin
          p_Bitmap.MoveTo(f_X2, f_Y2 - 1);
          f_FirstValue := false;
        end
        else
        begin
          p_Bitmap.LineToAS(f_X2, f_Y2 - 1);
        end;

        f_X1 := f_X2;
        f_Y1 := f_Y2;
      end;
      f_FirstValue := true;

      for f_Index := f_Sx to f_Ex do
      begin
        // :[]
        if f_Index > p_LineSeries.m_Items.Count then
        begin
          f_FirstValue := false;
          exit;
        end;

        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
          continue;

        f_X2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);

        f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

        f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
        if (f_FirstValue) then
        begin
          p_Bitmap.MoveTo(f_X2, f_Y2);
          f_FirstValue := false;
        end
        else
        begin
          p_Bitmap.LineToAS(f_X2, f_Y2);
        end;

        f_X1 := f_X2;
        f_Y1 := f_Y2;
      end;
    end
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawLineValueSeries_SignalLine(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries;
    p_ActiveLine: Integer);
var
  f_Index, f_Xc, f_X1, f_X2, f_Y1, f_Y2, f_Step: Integer;
  f_Line: Integer;
  f_Sx, f_Ex: Integer;
  f_Color1, f_Color2: Integer;
  f_Alpha: Integer;
  f_LineColor: Integer;
  f_OpenCloseWidth, f_HighLowWidth: Integer;

  f_Value: Double;
  f_FirstValue: Boolean;

  PenColor: TColor32;
  FillColor: TColor32;

  drRc: TRect;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_LineValue2: CMKLineValue;
begin
  if (p_LineSeries.m_LineCount < 1) then
    exit;

  f_Sx := Math.floor(m_MaxMin.m_XMin) - m_PaddingLeft;
  f_Ex := Math.floor(m_MaxMin.m_XMax) + m_PaddingRight;
  if (f_Sx < m_AbsMaxMin.m_XMin) then
    f_Sx := Math.floor(m_AbsMaxMin.m_XMin);

  if (f_Ex > m_AbsMaxMin.m_XMax) then
    f_Ex := Math.floor(m_AbsMaxMin.m_XMax);

  f_OpenCloseWidth := Round((GetScreenX(m_MaxMin.m_XMax, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]) -
      GetScreenX(m_MaxMin.m_XMin, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]])) /
      (m_MaxMin.m_XMax - m_MaxMin.m_XMin + 1));
  if (f_OpenCloseWidth <= 0) then
    f_OpenCloseWidth := 1
  else if (f_OpenCloseWidth > 4) then
    Dec(f_OpenCloseWidth)
  else
    f_OpenCloseWidth := f_OpenCloseWidth;

  f_HighLowWidth := Math.floor(f_OpenCloseWidth / 5);
  if (f_HighLowWidth > 3) then
    f_HighLowWidth := 3
  else if (f_HighLowWidth <= 0) then
    f_HighLowWidth := 1
  else
    f_HighLowWidth := f_HighLowWidth;

  if ((f_HighLowWidth MOD 2) = 1) then
  begin
    if ((f_OpenCloseWidth MOD 2) = 0) then
      Dec(f_OpenCloseWidth);
  end
  else
  begin
    if ((f_OpenCloseWidth MOD 2) = 1) then
      Dec(f_OpenCloseWidth);
  end;

  f_X1 := 0;
  f_Y1 := 0;
  for f_Line := 0 to p_LineSeries.m_LineCount - 1 do
  begin
    if (not p_LineSeries.m_Effect) then
      continue;
    if (not p_LineSeries.m_LineVisibles[f_Line]) AND (f_Line > 0) then
      continue;
    if ((p_ActiveLine >= 0) and (p_ActiveLine <> f_Line)) then
      continue;

    if (p_LineSeries.m_LineTypes[f_Line] = 0) then
    begin
      if (p_LineSeries.m_Type = CMKConst.LINESERIES_CLOSE) then
        f_Alpha := m_ColorSet.m_Alpha[CMKColorSet.ALPHA_PRICE_LINE]
      else if (p_LineSeries.m_Type = CMKConst.LINESERIES_MA) then
        f_Alpha := m_ColorSet.m_Alpha[CMKColorSet.ALPHA_MA_LINE]
      else
        f_Alpha := m_ColorSet.m_Alpha[p_LineSeries.m_LineAlphas[f_Line]];

      f_LineColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
      if (p_ActiveLine = f_Line) then
        f_Alpha := TMKGlobal.GetAlphaValue(100); // 1.0

      PenColor := f_LineColor;
      PenColor := SetAlpha(PenColor, f_Alpha);
      p_Bitmap.PenColor := PenColor;

      f_FirstValue := true;

      for f_Index := f_Sx to f_Ex do
      begin
        // :[]
        if f_Index > p_LineSeries.m_Items.Count then
        begin
          f_FirstValue := false;
          exit;
        end;

        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
          continue;

        f_X2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
        f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

        f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
        if (f_FirstValue) then
        begin
          p_Bitmap.MoveTo(f_X2, f_Y2 - 1);
          f_FirstValue := false;
        end
        else
        begin
          p_Bitmap.LineToAS(f_X2, f_Y2 - 1);
        end;

        f_X1 := f_X2;
        f_Y1 := f_Y2;
      end;
      f_FirstValue := true;

      for f_Index := f_Sx to f_Ex do
      begin
        // :[]
        if f_Index > p_LineSeries.m_Items.Count then
        begin
          f_FirstValue := false;
          exit;
        end;

        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
          continue;

        f_X2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
        f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

        f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
        if (f_FirstValue) then
        begin
          p_Bitmap.MoveTo(f_X2, f_Y2);
          f_FirstValue := false;
        end
        else
        begin
          p_Bitmap.LineToAS(f_X2, f_Y2);
        end;

        f_X1 := f_X2;
        f_Y1 := f_Y2;
      end;
    end
    else if (p_LineSeries.m_LineTypes[f_Line] = 4) then
    begin
      for f_Index := f_Sx to f_Ex do
      begin
        f_LineValue0 := p_LineSeries.m_Items[f_Index];

        if (f_LineValue0.m_Value[f_Line] = NOT_VALUE) then
          continue;

        f_X1 := GetScreenXCenter(f_Index, m_MaxMin);
        f_X2 := GetScreenXCenter(f_Index + 1, m_MaxMin);
        f_Y1 := Self.m_AxisRect.Top + m_PaddingTop;
        f_Y2 := Self.m_AxisRect.bottom;

        f_Alpha := TMKGlobal.GetAlphaValue(10);
        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] > 0) then
        begin
          f_Color1 := m_ColorSet.m_Color[CMKColorSet.PRICE_UP_FILLED_COLOR];
        end
        else if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] < 0) then
        begin
          f_Color1 := m_ColorSet.m_Color[CMKColorSet.PRICE_DN_FILLED_COLOR];
        end
        else
        begin
          f_Color1 := m_ColorSet.m_Color[CMKColorSet.CHART_COLOR];
        end;

        FillColor := f_Color1;
        FillColor := SetAlpha(FillColor, f_Alpha);
        drRc := TMKGlobal.GetRectToRealRect(f_X1, f_Y1, f_X2, f_Y2);
        p_Bitmap.FillRectTS(drRc, FillColor);

        PenColor := SetAlpha(f_Color1, 80);

        p_Bitmap.PenColor := PenColor;

        if (f_Index > 0) then
        begin
          f_LineValue1 := p_LineSeries.m_Items[f_Index - 1];
          if (f_LineValue1.m_Value[f_Line] <> NOT_VALUE) then
          begin
            if (f_LineValue0.m_Value[f_Line] <> f_LineValue1.m_Value[f_Line]) then
            begin
              p_Bitmap.MoveTo(f_X1, f_Y1);
              p_Bitmap.LineToAS(f_X1, f_Y2);
            end;
          end;
        end;

        // p_Bitmap.MoveTo(f_X2, f_Y1);
        // p_Bitmap.LineToAS(f_X2, f_Y2);

      end;

      for f_Index := f_Sx to f_Ex do
      begin
        f_LineValue0 := p_LineSeries.m_Items[f_Index];

        if (f_LineValue0.m_Value[f_Line] = NOT_VALUE) then
          continue;

        f_X1 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
        f_X2 := GetScreenXCenter(f_Index + 1, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
        f_Y1 := Self.m_AxisRect.bottom - 5;
        f_Y2 := Self.m_AxisRect.bottom;

        f_Alpha := TMKGlobal.GetAlphaValue(90);
        if (f_LineValue0.m_Value[f_Line] > 0) then
        begin
          f_Color1 := m_ColorSet.m_Color[CMKColorSet.PRICE_UP_FILLED_COLOR];
        end
        else if (f_LineValue0.m_Value[f_Line] < 0) then
        begin
          f_Color1 := m_ColorSet.m_Color[CMKColorSet.PRICE_DN_FILLED_COLOR];
        end
        else
        begin
          f_Color1 := m_ColorSet.m_Color[CMKColorSet.CHART_COLOR];
        end;

        FillColor := f_Color1;
        FillColor := SetAlpha(FillColor, f_Alpha);

        drRc := TMKGlobal.GetRectToRealRect(f_X1, f_Y1, f_X2, f_Y2);
        p_Bitmap.FillRectTS(drRc, FillColor);
      end;
    end

  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawLineValueSeries_OPSREL(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries;
    p_ActiveLine: Integer);
var
  f_Index, f_Xc, f_X1, f_X2, f_Y1, f_Y2, f_Step: Integer;
  f_Line: Integer;
  f_Sx, f_Ex: Integer;
  f_Color1, f_Color2: Integer;
  f_Alpha: Integer;
  f_LineColor: Integer;
  f_OpenCloseWidth, f_HighLowWidth: Integer;

  f_Value: Double;
  f_FirstValue: Boolean;

  PenColor: TColor32;
  FillColor: TColor32;

  drRc: TRect;

  f_Size: Integer;

begin
  if (p_LineSeries.m_LineCount < 1) then
    exit;

  f_Sx := Math.floor(m_MaxMin.m_XMin) - m_PaddingLeft;
  f_Ex := Math.floor(m_MaxMin.m_XMax) + m_PaddingRight;
  if (f_Sx < m_AbsMaxMin.m_XMin) then
    f_Sx := Math.floor(m_AbsMaxMin.m_XMin);

  if (f_Ex > m_AbsMaxMin.m_XMax) then
    f_Ex := Math.floor(m_AbsMaxMin.m_XMax);

  f_OpenCloseWidth := Round((GetScreenX(m_MaxMin.m_XMax, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]) -
      GetScreenX(m_MaxMin.m_XMin, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]])) /
      (m_MaxMin.m_XMax - m_MaxMin.m_XMin + 1));
  if (f_OpenCloseWidth <= 0) then
    f_OpenCloseWidth := 1
  else if (f_OpenCloseWidth > 4) then
    Dec(f_OpenCloseWidth)
  else
    f_OpenCloseWidth := f_OpenCloseWidth;

  f_HighLowWidth := Math.floor(f_OpenCloseWidth / 5);
  if (f_HighLowWidth > 3) then
    f_HighLowWidth := 3
  else if (f_HighLowWidth <= 0) then
    f_HighLowWidth := 1
  else
    f_HighLowWidth := f_HighLowWidth;

  if ((f_HighLowWidth MOD 2) = 1) then
  begin
    if ((f_OpenCloseWidth MOD 2) = 0) then
      Dec(f_OpenCloseWidth);
  end
  else
  begin
    if ((f_OpenCloseWidth MOD 2) = 1) then
      Dec(f_OpenCloseWidth);
  end;

  f_X1 := 0;
  f_Y1 := 0;
  for f_Line := 0 to p_LineSeries.m_LineCount - 1 do
  begin
    if (not p_LineSeries.m_Effect) then
      continue;

    if (not p_LineSeries.m_LineVisibles[f_Line]) then
      continue;

    if ((p_ActiveLine >= 0) and (p_ActiveLine <> f_Line)) then
      continue;

{$IFDEF CAST}
    for f_Step := 0 to 2 do
    begin
      f_Alpha := TMKGlobal.GetAlphaValue(100);

      f_LineColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
      if (p_ActiveLine = f_Line) then
        f_Alpha := TMKGlobal.GetAlphaValue(100); // 1.0

      PenColor := f_LineColor;
      PenColor := SetAlpha(PenColor, f_Alpha);
      p_Bitmap.PenColor := PenColor;

      f_FirstValue := true;

      for f_Index := f_Sx to f_Ex do
      begin
        // :[]
        if f_Index > p_LineSeries.m_Items.Count then
        begin
          f_FirstValue := false;
          exit;
        end;

        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
          continue;

        f_X2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
        f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

        f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
        if (f_FirstValue) then
        begin
          p_Bitmap.MoveTo(f_X2, f_Y2 + f_Step - 1);
          f_FirstValue := false;
        end
        else
        begin
          p_Bitmap.LineToAS(f_X2, f_Y2 + f_Step - 1);
        end;

        f_X1 := f_X2;
        f_Y1 := f_Y2;
      end;
    end;

{$ENDIF}
    f_Alpha := m_ColorSet.m_Alpha[p_LineSeries.m_LineAlphas[f_Line]];

    f_LineColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
    if (p_ActiveLine = f_Line) then
      f_Alpha := TMKGlobal.GetAlphaValue(100); // 1.0

{$IFDEF CAST}
    f_Alpha := TMKGlobal.GetAlphaValue(100);
{$ENDIF}
    PenColor := f_LineColor;
    PenColor := SetAlpha(PenColor, f_Alpha);
    p_Bitmap.PenColor := PenColor;

    f_FirstValue := true;

    for f_Index := f_Sx to f_Ex do
    begin
      // :[]
      if f_Index > p_LineSeries.m_Items.Count then
      begin
        f_FirstValue := false;
        exit;
      end;

      if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
        continue;

      f_X2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
      f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

      f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
      if (f_FirstValue) then
      begin
        p_Bitmap.MoveTo(f_X2, f_Y2 - 1);
        f_FirstValue := false;
      end
      else
      begin
        p_Bitmap.LineToAS(f_X2, f_Y2 - 1);
      end;

      f_X1 := f_X2;
      f_Y1 := f_Y2;
    end;
    f_FirstValue := true;

    for f_Index := f_Sx to f_Ex do
    begin
      // :[]
      if f_Index > p_LineSeries.m_Items.Count then
      begin
        f_FirstValue := false;
        exit;
      end;

      if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
        continue;

      f_X2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
      f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

      f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
      if (f_FirstValue) then
      begin
        p_Bitmap.MoveTo(f_X2, f_Y2);
        f_FirstValue := false;
      end
      else
      begin
        p_Bitmap.LineToAS(f_X2, f_Y2);
      end;

      f_X1 := f_X2;
      f_Y1 := f_Y2;
    end;

    for f_Index := f_Sx to f_Ex do
    begin
      // :[]
      if f_Index < 0 then
      begin
        continue;
      end;

      if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
        continue;
      if (CMKLineValue(p_LineSeries.m_Items[f_Index - 1]).m_Value[f_Line] = NOT_VALUE) then
        continue;

      f_X2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
      f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];
      f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);

      if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] > 81.618) then
      begin
        if CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] >= CMKLineValue(p_LineSeries.m_Items[f_Index - 1])
            .m_Value[f_Line] then
        begin
          PenColor := $000000FF;
          PenColor := SetAlpha(PenColor, f_Alpha);
          p_Bitmap.PenColor := PenColor;

          p_Bitmap.MoveTo(f_X2 - 2, f_Y2 - 1);
          p_Bitmap.LineToAS(f_X2 - 1, f_Y2 - 2);
          p_Bitmap.LineToAS(f_X2 + 1, f_Y2 - 2);
          p_Bitmap.LineToAS(f_X2 + 2, f_Y2 - 1);
          p_Bitmap.LineToAS(f_X2 + 2, f_Y2 + 1);
          p_Bitmap.LineToAS(f_X2 + 1, f_Y2 + 2);

          p_Bitmap.LineToAS(f_X2 - 1, f_Y2 + 2);
          p_Bitmap.LineToAS(f_X2 - 2, f_Y2 + 1);
          p_Bitmap.LineToAS(f_X2 - 2, f_Y2 - 1);
        end;
      end
      else
      begin
        if CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] <= CMKLineValue(p_LineSeries.m_Items[f_Index - 1])
            .m_Value[f_Line] then
        begin
          PenColor := $00FF0000;
          PenColor := SetAlpha(PenColor, f_Alpha);
          p_Bitmap.PenColor := PenColor;

          p_Bitmap.MoveTo(f_X2 - 2, f_Y2 - 1);
          p_Bitmap.LineToAS(f_X2 - 1, f_Y2 - 2);
          p_Bitmap.LineToAS(f_X2 + 1, f_Y2 - 2);
          p_Bitmap.LineToAS(f_X2 + 2, f_Y2 - 1);
          p_Bitmap.LineToAS(f_X2 + 2, f_Y2 + 1);
          p_Bitmap.LineToAS(f_X2 + 1, f_Y2 + 2);

          p_Bitmap.LineToAS(f_X2 - 1, f_Y2 + 2);
          p_Bitmap.LineToAS(f_X2 - 2, f_Y2 + 1);
          p_Bitmap.LineToAS(f_X2 - 2, f_Y2 - 1);
        end;
      end;

      f_X1 := f_X2;
      f_Y1 := f_Y2;
    end;

  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawLineValueSeries_IMLine(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries;
    p_ActiveLine: Integer = -1);
var
  f_Index, f_X1, f_X2, f_Y1, f_Y2, f_Step: Integer;
  f_Line: Integer;
  f_Sx, f_Ex: Integer;
  f_SxArr: Array of Integer;
  f_ExArr: Array of Integer;
  f_Alpha: Integer;
  f_LineColor: Integer;
  f_Value: Double;
  f_bFirstValue: Boolean;

  f_px0, f_px1, f_px2, f_px3: Integer;
  f_MW_0, f_MW_1, f_MW_2, f_MW_3: Integer;
  f_XValue, f_Y0Value, f_Y1Value: Integer;

  PenColor: TColor32;
  FillColor: TColor32;

  nPolygonPtArray: Array of TFixedPoint;
  bDraw: Boolean;
begin
  if (p_LineSeries.m_LineCount < 1) then
    exit;

  SetLength(f_SxArr, 5);
  SetLength(f_ExArr, 5);
  f_Sx := Math.floor(m_MaxMin.m_XMin) - m_PaddingLeft;
  f_Ex := Math.floor(m_MaxMin.m_XMax) + m_PaddingRight;
  if (f_Sx < m_AbsMaxMin.m_XMin) then
    f_Sx := Math.floor(m_AbsMaxMin.m_XMin);

  if (f_Ex > m_AbsMaxMin.m_XMax + m_XExtraGap) then
    f_Ex := Math.floor(m_AbsMaxMin.m_XMax + m_XExtraGap);

  f_bFirstValue := true;
  f_X1 := 0;
  f_Y1 := 0;

  if (p_ActiveLine = -1) then
  begin

    for f_Index := f_Sx to f_Ex do
    begin
      if ((CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[2] = NOT_VALUE) or
          (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[3] = NOT_VALUE)) then
        continue;

      f_px2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[0]);
      f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[2];

      f_MW_2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[0]);
      f_px3 := f_px2;
      f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[3];

      f_MW_3 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[0]);
      if (not f_bFirstValue) then
      begin
        if ((f_MW_3 - f_MW_2) * (f_MW_0 - f_MW_1) > 0) then
        begin

          if (f_MW_2 > f_MW_3) then
          begin
            PenColor := m_ColorSet.m_Color[CMKColorSet.IMCLOUDE_UP_FILLED_COLOR];
            PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(0));

            FillColor := m_ColorSet.m_Color[CMKColorSet.IMCLOUDE_UP_FILLED_COLOR];
            FillColor := SetAlpha(FillColor, m_ColorSet.m_Alpha[CMKColorSet.ALPHA_IMCLOUDE_UP_FILLED]);

            p_Bitmap.PenColor := FillColor;
            p_Bitmap.MoveTo(f_px0, f_MW_0);
            p_Bitmap.LineToAS(f_px1, f_MW_1);
            p_Bitmap.LineToAS(f_px2, f_MW_2);
            p_Bitmap.LineToAS(f_px3, f_MW_3);
            p_Bitmap.LineToAS(f_px0, f_MW_0);
          end
          else
          begin
            PenColor := m_ColorSet.m_Color[CMKColorSet.IMCLOUDE_DN_FILLED_COLOR];
            PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(0));

            FillColor := m_ColorSet.m_Color[CMKColorSet.IMCLOUDE_DN_FILLED_COLOR];
            FillColor := SetAlpha(FillColor, m_ColorSet.m_Alpha[CMKColorSet.ALPHA_IMCLOUDE_DN_FILLED]);

            p_Bitmap.PenColor := FillColor;
            p_Bitmap.MoveTo(f_px0, f_MW_0);
            p_Bitmap.LineToAS(f_px1, f_MW_1);
            p_Bitmap.LineToAS(f_px2, f_MW_2);
            p_Bitmap.LineToAS(f_px3, f_MW_3);
            p_Bitmap.LineToAS(f_px0, f_MW_0);
          end;
        end;
      end;

      f_bFirstValue := false;
      f_px1 := f_px2;
      f_MW_1 := f_MW_2;
      f_px0 := f_px3;
      f_MW_0 := f_MW_3;
    end;
  end;

  for f_Line := 0 to p_LineSeries.m_LineCount - 1 do
  begin
    if (not p_LineSeries.m_LineVisibles[f_Line]) then
      continue;

    if ((p_ActiveLine >= 0) and (p_ActiveLine <> f_Line)) then
      continue;

{$IFDEF CAST}
    for f_Step := 0 to 2 do
    begin

      f_Alpha := TMKGlobal.GetAlphaValue(100);
      f_LineColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];

      PenColor := f_LineColor;
      PenColor := SetAlpha(PenColor, f_Alpha);
      p_Bitmap.PenColor := PenColor;

      f_bFirstValue := true;
      for f_Index := f_Sx to f_Ex do
      begin
        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
          continue;

        f_X2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
        f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

        f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
        if (f_bFirstValue) then
        begin
          p_Bitmap.MoveTo(f_X2, f_Y2 + f_Step - 1);
          f_bFirstValue := false;
        end
        else
        begin
          p_Bitmap.LineToAS(f_X2, f_Y2 + f_Step - 1);
        end;

        f_X1 := f_X2;
        f_Y1 := f_Y2;
      end;
    end;

{$ENDIF}
    f_Alpha := m_ColorSet.m_Alpha[p_LineSeries.m_LineAlphas[f_Line]];
    f_LineColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
    if (p_ActiveLine = f_Line) then
      f_Alpha := TMKGlobal.GetAlphaValue(100); // 1.0;

{$IFDEF CAST}
    f_Alpha := TMKGlobal.GetAlphaValue(100);
{$ENDIF}
    PenColor := f_LineColor;
    PenColor := SetAlpha(PenColor, f_Alpha);
    p_Bitmap.PenColor := PenColor;

    f_bFirstValue := true;
    for f_Index := f_Sx to f_Ex do
    begin
      if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
        continue;

      f_X2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
      f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

      f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
      if (f_bFirstValue) then
      begin
        p_Bitmap.MoveTo(f_X2, f_Y2);
        f_bFirstValue := false;
      end
      else
      begin
        p_Bitmap.LineToAS(f_X2, f_Y2);
      end;

      f_X1 := f_X2;
      f_Y1 := f_Y2;
    end;
  end;
end;


// ---------------------------------------------------------------------------

procedure CMKChartBlock.DrawLineValueSeries_BBLine(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries;
    p_ActiveLine: Integer = -1);
var
  f_Index, f_X1, f_X2, f_Y1, f_Y2: Integer;
  f_Line: Integer;
  f_Sx, f_Ex: Integer;
  f_px0, f_px1, f_px2, f_px3: Integer;
  f_MW_0, f_MW_1, f_MW_2, f_MW_3: Integer;
  f_XValue, f_Y0Value, f_Y1Value: Integer;
  f_Value: Double;
  f_FirstValue: Boolean;

  PenColor: TColor32;
  FillColor: TColor32;

  nPolygonPtArray: Array of TFixedPoint;
begin
  f_FirstValue := true;

  if (p_LineSeries.m_LineCount < 1) then
    exit;

  f_Sx := Math.floor(m_MaxMin.m_XMin) - m_PaddingLeft;
  f_Ex := Math.floor(m_MaxMin.m_XMax) + m_PaddingRight;
  if (f_Sx < m_AbsMaxMin.m_XMin) then
    f_Sx := Math.floor(m_AbsMaxMin.m_XMin);

  if (f_Ex > m_AbsMaxMin.m_XMax) then
    f_Ex := Math.floor(m_AbsMaxMin.m_XMax);

  f_X1 := 0;
  f_Y1 := 0;
  if (p_ActiveLine = -1) then
  begin

    // =========================================================================================
    for f_Index := f_Sx to f_Ex do
    begin
      if ((CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[0] = NOT_VALUE) or
          (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[1] = NOT_VALUE)) then
        continue;

      f_px2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[0]);
      f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[0];

      f_MW_2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      f_px3 := f_px2;
      f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[1];

      f_MW_3 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
      if (not f_FirstValue) then
      begin
        PenColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[2]];
        PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(0));

        FillColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[2]];
        FillColor := SetAlpha(FillColor, m_ColorSet.m_Alpha[CMKColorSet.ALPHA_BAND_FILLED]);

        p_Bitmap.PenColor := FillColor;
        p_Bitmap.MoveTo(f_px0, f_MW_0);
        p_Bitmap.LineToAS(f_px1, f_MW_1);
        p_Bitmap.LineToAS(f_px2, f_MW_2);
        p_Bitmap.LineToAS(f_px3, f_MW_3);
        p_Bitmap.LineToAS(f_px0, f_MW_0);
      end;

      f_FirstValue := false;
      f_px1 := f_px2;
      f_MW_1 := f_MW_2;
      f_px0 := f_px3;
      f_MW_0 := f_MW_3;
    end;
  end;

  for f_Line := 0 to p_LineSeries.m_LineCount - 1 do
  begin
    if (not p_LineSeries.m_LineVisibles[f_Line]) then
      continue;

    if ((p_ActiveLine >= 0) and (p_ActiveLine <> f_Line)) then
      continue;

    if (p_ActiveLine = f_Line) then
    begin
      PenColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
      PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));
    end
    else
    begin
      PenColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
      PenColor := SetAlpha(PenColor, m_ColorSet.m_Alpha[p_LineSeries.m_LineAlphas[f_Line]]);
    end;
    p_Bitmap.PenColor := PenColor;

    f_FirstValue := true;
    for f_Index := f_Sx to f_Ex do
    begin
      if ((CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE)) then
        continue;

      f_X2 := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
      f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

      f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);
      if (f_FirstValue) then
      begin
        p_Bitmap.MoveTo(f_X2, f_Y2);
        f_FirstValue := false;
      end
      else
      begin
        p_Bitmap.LineToAS(f_X2, f_Y2);
      end;

      f_X1 := f_X2;
      f_Y1 := f_Y2;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.CalculatePadding();
var
  f_Index: Integer;
  p_LineSeries: CMKLineValueSeries;
begin
  for f_Index := 0 to m_ObjectCollection.Count - 1 do
  begin
    p_LineSeries := CMKLineValueSeries(m_ObjectCollection.Items[f_Index]);
    if (p_LineSeries.m_Type = CMKConst.LINESERIES_PRICE) then
    begin
      m_PaddingTop := 18;
      m_PaddingBottom := 2;
    end
    else if (p_LineSeries.m_Type = CMKConst.LINESERIES_VOLUME) then
    begin
      m_PaddingTop := 18;
      m_PaddingBottom := 0;
    end
    else
    begin
      m_PaddingTop := 18;
      m_PaddingBottom := 2;
    end;

    if p_LineSeries.m_Signal then
    begin
      m_PaddingTop := 18;
      m_PaddingBottom := 10;
    end;
    if p_LineSeries.m_TradeStrategySignal then
    begin
      m_PaddingTop := 18;
      m_PaddingBottom := 10;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawChart(p_Bitmap: TBitmap32);
var
  f_Index: Integer;
  p_LineSeries: CMKLineValueSeries;
begin
  for f_Index := 0 to m_ObjectCollection.Count - 1 do
  begin

    p_LineSeries := CMKLineValueSeries(m_ObjectCollection.Items[f_Index]);

    if not Assigned(p_LineSeries) then
      continue;

    try
      if (p_LineSeries.m_Items.Count <= 0) then
        continue;

      if (p_LineSeries.m_TradeStrategySignal) then
      begin
        DrawLineValueSeries_TradeStrategySignal(p_Bitmap, p_LineSeries, -1);
      end
      else if (p_LineSeries.m_Signal) then
      begin
        DrawLineValueSeries_SignalLine(p_Bitmap, p_LineSeries, -1);
      end
      else if (p_LineSeries.m_Type = CMKConst.LINESERIES_PRICE) then
        DrawLineValueSeries_PriceLine(p_Bitmap, p_LineSeries, -1)
      else if (p_LineSeries.m_Type = CMKConst.LINESERIES_VOLUME) then
        DrawLineValueSeries_VolumeLine(p_Bitmap, p_LineSeries, -1)
      else if (p_LineSeries.m_Type = CMKConst.LINESERIES_ILMOK) then
        DrawLineValueSeries_IMLine(p_Bitmap, p_LineSeries, -1)
      else if ((p_LineSeries.m_Type = CMKConst.LINESERIES_BB) or (p_LineSeries.m_Type = CMKConst.LINESERIES_ENVELOPE)) then
        DrawLineValueSeries_BBLine(p_Bitmap, p_LineSeries, -1)
      else if (p_LineSeries.m_Type = CMKConst.LINESERIES_NET) then
        DrawLineValueSeries_NetLine(p_Bitmap, p_LineSeries, -1)
      else if (p_LineSeries.m_Type = CMKConst.LINESERIES_OPSREL) then
        DrawLineValueSeries_OPSREL(p_Bitmap, p_LineSeries, -1)
      else
        DrawLineValueSeries_Line(p_Bitmap, p_LineSeries, -1);
    finally

    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawActiveChart(p_Bitmap: TBitmap32; p_LineSeries: CMKLineValueSeries; p_ActiveLine: Integer);
var
  f_Index: Integer;
begin
  if (p_LineSeries.m_Items.Count <= 0) then
    exit;

  if (p_LineSeries.m_TradeStrategySignal) then
  begin
    DrawLineValueSeries_TradeStrategySignal(p_Bitmap, p_LineSeries, -1);
  end
  else if (p_LineSeries.m_Signal) then
  begin
    DrawLineValueSeries_SignalLine(p_Bitmap, p_LineSeries, p_ActiveLine);
  end
  else if (p_LineSeries.m_Type = CMKConst.LINESERIES_PRICE) then
    DrawLineValueSeries_PriceLine(p_Bitmap, p_LineSeries, p_ActiveLine)
  else if (p_LineSeries.m_Type = CMKConst.LINESERIES_VOLUME) then
    DrawLineValueSeries_VolumeLine(p_Bitmap, p_LineSeries, p_ActiveLine)
  else if (p_LineSeries.m_Type = CMKConst.LINESERIES_ILMOK) then
    DrawLineValueSeries_IMLine(p_Bitmap, p_LineSeries, p_ActiveLine)
  else if ((p_LineSeries.m_Type = CMKConst.LINESERIES_BB) or (p_LineSeries.m_Type = CMKConst.LINESERIES_ENVELOPE)) then
    DrawLineValueSeries_BBLine(p_Bitmap, p_LineSeries, p_ActiveLine)
  else if (p_LineSeries.m_Type = CMKConst.LINESERIES_NET) then
    DrawLineValueSeries_NetLine(p_Bitmap, p_LineSeries, p_ActiveLine)
  else
    DrawLineValueSeries_Line(p_Bitmap, p_LineSeries, p_ActiveLine);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawLineValues(p_Bitmap: TBitmap32);
var
  f_Index: Integer;
  f_LineSeries: CMKLineValueSeries;
  PenColor: TColor32;
  f_ValueIndex: Integer;
  f_Y: Integer;
begin
  for f_Index := 0 to m_ObjectCollection.Count - 1 do
  begin
    f_LineSeries := CMKLineValueSeries(m_ObjectCollection.Items[f_Index]);
    if not Assigned(f_LineSeries) then
      continue;

    for f_ValueIndex := 0 to f_LineSeries.m_ValueCount - 1 do
    begin
      if (f_LineSeries.m_ValueEnables[f_ValueIndex]) then
      begin
        PenColor := m_ColorSet.m_Color[f_LineSeries.m_ValueColors[f_ValueIndex]];
        PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(80));
        p_Bitmap.PenColor := PenColor;

        f_Y := GetScreenY(f_LineSeries.m_Values[f_ValueIndex], f_LineSeries.m_MaxMinTable[f_LineSeries.m_LineMaxMinIndexs[0]]);

        p_Bitmap.MoveTo(m_AxisRect.left, f_Y);
        p_Bitmap.LineToAS(m_AxisRect.Right, f_Y);
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.CalculateYGridSize();
var
  f_YMaxMin, f_YGridSize, f_tmp: Double;
  f_Value: Integer;
  f_Y0, f_Y1, f_Index: Integer;
begin
  f_YMaxMin := (m_MaxMin.m_YMax - m_MaxMin.m_YMin);

  if ((m_MaxMin.m_YMax = NOT_VALUE) or (m_MaxMin.m_YMin = NOT_VALUE) or (m_MaxMin.m_YMax = MIN_VALUE) or
      (m_MaxMin.m_YMin = MAX_VALUE)) then
  begin
    exit;
  end;

  if (f_YMaxMin > 1) then
  begin
    f_YGridSize := 1;
    while ((f_YMaxMin / f_YGridSize) > 10) do
    begin
      f_YGridSize := f_YGridSize * 10.0;
    end;

    if (f_YGridSize = 0) then
      f_Value := 0
    else
      f_Value := Math.floor(f_YMaxMin / f_YGridSize);
  end
  else if (f_YMaxMin = 0) then
  begin
    f_YGridSize := 0;
  end
  else
  begin
    f_YGridSize := 1;
    while ((f_YMaxMin * 1000 / f_YGridSize) > 10) do
    begin
      f_YGridSize := f_YGridSize * 10.0;
    end;

    if (f_YGridSize = 0) then
      f_Value := 0
    else
      f_Value := Math.floor(f_YMaxMin / f_YGridSize);

    f_YGridSize := (f_YGridSize / 1000.0);
    f_Value := 0;
  end;

  case f_Value of
    0:
      f_YGridSize := f_YGridSize / 1.5;
    1:
      f_YGridSize := f_YGridSize / 5.0;
    2:
      f_YGridSize := f_YGridSize / 4.0;
    3:
      f_YGridSize := f_YGridSize / 3.0;
    4:
      ;
    5:
      ;
    6:
      f_YGridSize := f_YGridSize;
    7:
      f_YGridSize := f_YGridSize;
    8:
      f_YGridSize := f_YGridSize * 2.0;
    9:
      f_YGridSize := f_YGridSize * 2.0;
    10:
      f_YGridSize := f_YGridSize * 2.0;
  end;

  f_Y0 := GetScreenY(0, m_MaxMin, 0);
  f_tmp := f_YGridSize;
  for f_Index := 0 to 10 - 1 do
  begin
    f_Y1 := GetScreenY(f_YGridSize, m_MaxMin, 0);
    if (Abs(f_Y1 - f_Y0) >= CMKConst.CHART_DRAW_XLABEL_HEIGHT) then
      break;

    f_YGridSize := f_YGridSize + f_tmp;
  end;

  m_YGridSize := f_YGridSize;
  if (f_YGridSize > 50000000) then
    m_Unit := 1000000
  else if (f_YGridSize > 5000) then
    m_Unit := 1000
  else
    m_Unit := 1;

  if m_ChartIndex = 0 then
    m_Unit := 1;

end;

// ---------------------------------------------------------------------------
function CMKChartBlock.FindValueArray(p_Name: String): CMKLineValueSeries;
var
  f_Object: Integer;
  p_LineSeries: CMKLineValueSeries;
  f_FindValueArray: CMKLineValueSeries;
begin
  f_FindValueArray := NIL;
  for f_Object := 0 to m_ObjectCollection.Count - 1 do
  begin
    p_LineSeries := CMKLineValueSeries(m_ObjectCollection.Items[f_Object]);
    if (p_LineSeries.m_Name = p_Name) then
    begin
      f_FindValueArray := p_LineSeries;
      break;
    end;
  end;

  Result := f_FindValueArray;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DeleteValueArray(p_Name: String);
var
  f_Object: Integer;
  p_LineSeries: CMKLineValueSeries;
begin
  for f_Object := 0 to m_ObjectCollection.Count - 1 do
  begin
    p_LineSeries := CMKLineValueSeries(m_ObjectCollection.Items[f_Object]);
    if (p_LineSeries.m_Name = p_Name) then
    begin
      p_LineSeries.Clear();
      p_LineSeries.Free();
      m_ObjectCollection.Delete(f_Object);
      break;
    end;
  end;

end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.ClearObject(AFree: Boolean = true);
var
  f_Object: Integer;
  p_LineSeries: CMKLineValueSeries;
begin

  try
    if (m_DrawManager <> NIL) then
      m_DrawManager.Clear();

    while (m_ObjectCollection.Count > 0) do
    begin
      if AFree then
      begin
        p_LineSeries := CMKLineValueSeries(m_ObjectCollection.Items[0]);
        if (not p_LineSeries.m_TradeStrategy) then
        begin
          p_LineSeries.Clear();
          p_LineSeries.Free();
        end;
      end;

      m_ObjectCollection.Delete(0);
    end;

  finally
  end;

end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.AddObject(p_LineSeries: CMKLineValueSeries);
begin
  if (p_LineSeries.m_Type = CMKConst.LINESERIES_PRICE) then
  begin
    m_PaddingTop := 18;
    m_PaddingBottom := 24;
  end
  else if (p_LineSeries.m_Type = CMKConst.LINESERIES_VOLUME) then
  begin
    m_PaddingBottom := 0;
  end
  else
  begin
    m_PaddingBottom := m_PaddingBottom;
  end;

  m_ObjectCollection.Add(p_LineSeries);

  p_LineSeries.GetLineMaxMin(0, p_LineSeries.m_Items.Count - 1);
  if ((m_ChartIndex = 0) AND ((p_LineSeries.m_Type = CMKConst.LINESERIES_PRICE_AT_OPS) or
      (p_LineSeries.m_Type = CMKConst.LINESERIES_OPS) or (p_LineSeries.m_Type = CMKConst.LINESERIES_OPSIGUK) or
      (p_LineSeries.m_Type = CMKConst.LINESERIES_OPSIGUK2) or (p_LineSeries.m_Type = CMKConst.LINESERIES_OPSREL) or
      (p_LineSeries.m_Type = CMKConst.LINESERIES_OPSSTDDEV))) then
  begin

  end
  else if (p_LineSeries.m_Effect) then
  begin
    m_AbsMaxMin.m_XMin := 0;
    m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
    m_AbsMaxMin.m_YMin := p_LineSeries.m_MaxMinTable[0].m_YMin;
    m_AbsMaxMin.m_YMax := p_LineSeries.m_MaxMinTable[0].m_YMax;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.ChangedLineMaxMin(p_LineSeries: CMKLineValueSeries);
begin

  p_LineSeries.GetLineMaxMin(0, p_LineSeries.m_Items.Count - 1);
  if ((m_ChartIndex = 0) AND ((p_LineSeries.m_Type = CMKConst.LINESERIES_PRICE_AT_OPS) or
      (p_LineSeries.m_Type = CMKConst.LINESERIES_OPS) or (p_LineSeries.m_Type = CMKConst.LINESERIES_OPSIGUK) or
      (p_LineSeries.m_Type = CMKConst.LINESERIES_OPSIGUK2) or (p_LineSeries.m_Type = CMKConst.LINESERIES_OPSREL) or
      (p_LineSeries.m_Type = CMKConst.LINESERIES_OPSSTDDEV))) then
  begin

  end
  else if (p_LineSeries.m_Effect) then
  begin
    m_AbsMaxMin.m_XMin := 0;
    m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
    m_AbsMaxMin.m_YMin := p_LineSeries.m_MaxMinTable[0].m_YMin;
    m_AbsMaxMin.m_YMax := p_LineSeries.m_MaxMinTable[0].m_YMax;
  end;
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.GetYGridPrecision(): Integer;
begin
  Result := m_YGridPrecision;
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.GetUnit(): Integer;
begin
  Result := m_Unit;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.SetScale(p_Scale: Integer);
begin
  m_Scale := p_Scale;
end;

procedure CMKChartBlock.DrawFillRectAngle(p_Bitmap: TBitmap32; p_Tick: Integer; p_LineColor: Integer; p_LineAlpha: Integer;
    p_FillColor: Integer; p_FillAlpha: Integer; p_X1: Integer; p_Y1: Integer; p_X2: Integer; p_Y2: Integer);
var
  PenColor: TColor32;
  FillColor: TColor32;
begin
  PenColor := p_LineColor;
  PenColor := SetAlpha(PenColor, p_LineAlpha);

  FillColor := p_FillColor;
  FillColor := SetAlpha(FillColor, p_FillAlpha);

  p_Bitmap.FillRectTS(p_X1, p_Y1, p_X2 + 1, p_Y2 + 1, FillColor);
  p_Bitmap.FrameRectTS(p_X1, p_Y1, p_X2 + 1, p_Y2 + 1, PenColor);
end;

procedure CMKChartBlock.DrawYGrid(p_Bitmap: TBitmap32);
var
  f_GridPosition: Double;
  f_iy: Integer;
  LnColor: TColor32;
begin
  if (m_VisibleYGrid) then
  begin
    LnColor := m_ColorSet.m_Color[CMKColorSet.GRID_COLOR];
    LnColor := SetAlpha(LnColor, TMKGlobal.GetAlphaValue(100));
    p_Bitmap.PenColor := LnColor;

    if (m_YGridSize <> 0.0) then
    begin
      f_GridPosition := m_YGridSize;
      while (f_GridPosition < m_MaxMin.m_YMax) do
      begin
        if (f_GridPosition > m_MaxMin.m_YMin) then
        begin
          f_iy := GetScreenY(f_GridPosition, m_MaxMin);
          p_Bitmap.MoveTo(m_AxisRect.left, f_iy);
          p_Bitmap.LineToAS(m_AxisRect.left + TMKGlobal.RectToWidth(m_AxisRect), f_iy);
        end;
        f_GridPosition := f_GridPosition + m_YGridSize;
      end;

      f_GridPosition := 0;
      while (f_GridPosition > m_MaxMin.m_YMin) do
      begin
        if (f_GridPosition < m_MaxMin.m_YMax) then
        begin
          f_iy := GetScreenY(f_GridPosition, m_MaxMin);
          p_Bitmap.MoveTo(m_AxisRect.left, f_iy);
          p_Bitmap.LineToAS(m_AxisRect.left + TMKGlobal.RectToWidth(m_AxisRect), f_iy);
        end;
        f_GridPosition := f_GridPosition - m_YGridSize;
      end;
    end;
  end;
end;

procedure CMKChartBlock.DrawYTicLabel(p_Bitmap: TBitmap32);
var
  f_GridPosition: Double;
  f_iy, f_CharHeight: Integer;
  f_TicLabel: String;
  f_FormatStr: String;
  f_dYTicLable1, f_ddYTicLable2, f_ddYTicLable3: Integer;
  f_Precision1: Integer;
  f_Precision2: Integer;
  f_dMulti: Double;

  f_TextWidth, f_TextHeight: Integer;
  f_x, f_Y, f_X2, f_Y2: Integer;
  PenColor: TColor32;
  FillColor: TColor32;

  f_Unit: String;

  f_Index: Integer;
  f_LineSeries: CMKLineValueSeries;
  f_RightTickLabelCount: Integer;
  f_Value: Double;
  f_FontColor: TColor32;
begin
  f_Precision1 := 0;
  f_Precision2 := 0;
  f_dMulti := 0.0;

  p_Bitmap.Font.Name := 'Tahoma';
  p_Bitmap.Font.Size := 8;
  p_Bitmap.Font.Style := [];
  p_Bitmap.Font.Color := m_ColorSet.m_Color[CMKColorSet.YTICK_LABEL_COLOR];

  if (m_ChartIndex = 0) then
  begin
    if (m_Scale = 1) then
      f_TicLabel := g_ChartText[CT_LOG]
    else
      f_TicLabel := g_ChartText[CT_LINEAR];

    f_x := m_BoundRect.Right - p_Bitmap.TextWidth(f_TicLabel) - 4 - CMKConst.CHART_DRAW_YBOUNDARY_OFFSET;
    f_Y := m_LegendRect.Top;
    p_Bitmap.Textout(f_x, f_Y, f_TicLabel);
  end;

  p_Bitmap.Font.Name := CMKColorSet.NUMBER2_FONT_FAMILY;
  p_Bitmap.Font.Size := CMKColorSet.NUMBER2_FONT_SMALLSIZE2;
  p_Bitmap.Font.Style := [];
  p_Bitmap.Font.Color := m_ColorSet.m_Color[CMKColorSet.YTICK_LABEL_COLOR];

  if (m_VisibleYLabel) then
  begin
    PenColor := m_ColorSet.m_Color[CMKColorSet.AXIS_COLOR];
    PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));
    p_Bitmap.PenColor := PenColor;

    if 0 >= m_YGridSize then
      exit;

    while (true) do
    begin
      f_dMulti := Power(10, f_Precision1);
      f_dYTicLable1 := Math.floor((m_YGridSize * 1 * f_dMulti) / m_Unit);
      f_ddYTicLable2 := Math.floor((m_YGridSize * 2 * f_dMulti) / m_Unit);
      f_ddYTicLable3 := Math.floor((m_YGridSize * 3 * f_dMulti) / m_Unit);
      if ((f_dYTicLable1 <> f_ddYTicLable2) and (f_ddYTicLable2 <> f_ddYTicLable3)) then
        break;
      Inc(f_Precision1);
    end;

    f_dMulti := Power(10, f_Precision1) / m_Unit;
    if f_dMulti = 0 then
      f_dMulti := 1;
    f_dYTicLable1 := Math.floor((m_YGridSize * 1) * f_dMulti / f_dMulti);
    if ((m_YGridSize * 1) <> f_dYTicLable1) then
      f_Precision2 := 1;

    f_ddYTicLable2 := Math.floor((m_YGridSize * 2) * f_dMulti / f_dMulti);
    if ((m_YGridSize * 2) <> f_ddYTicLable2) then
      f_Precision2 := 1;

    m_YGridPrecision := f_Precision1 + f_Precision2;
    if m_ChartIndex = 0 then
    begin
      if m_YGridPrecision < m_ChartDataSeries.m_Precision then
        m_YGridPrecision := m_ChartDataSeries.m_Precision;
    end;
    if (m_YGridSize <> 0.0) then
    begin
      f_GridPosition := m_YGridSize;
      while (f_GridPosition < m_MaxMin.m_YMax) do
      begin
        if (f_GridPosition > m_MaxMin.m_YMin) then
        begin
          f_iy := GetScreenY(f_GridPosition, m_MaxMin);

          p_Bitmap.MoveTo(m_AxisRect.Right, f_iy);
          p_Bitmap.LineToAS(m_AxisRect.Right + 6, f_iy);

          p_Bitmap.MoveTo(m_AxisRect.left, f_iy);
          p_Bitmap.LineToAS(m_AxisRect.left - 6, f_iy);

          f_TicLabel := TMKGlobal.NumberToString(f_GridPosition / m_Unit, m_YGridPrecision);

          f_x := m_BoundRect.Right - p_Bitmap.TextWidth(f_TicLabel) - CMKConst.CHART_DRAW_YBOUNDARY_OFFSET - 2;
          f_Y := Math.floor(GetScreenY(f_GridPosition, m_MaxMin) - p_Bitmap.TextHeight(f_TicLabel) / 2);
          p_Bitmap.Textout(f_x, f_Y, f_TicLabel);
        end;

        f_GridPosition := f_GridPosition + m_YGridSize;
      end;

      f_GridPosition := 0;
      while (f_GridPosition > m_MaxMin.m_YMin) do
      begin
        if (f_GridPosition < m_MaxMin.m_YMax) then
        begin
          f_iy := GetScreenY(f_GridPosition, m_MaxMin);
          p_Bitmap.PenColor := PenColor;
          p_Bitmap.MoveTo(m_AxisRect.Right, f_iy);
          p_Bitmap.LineToAS(m_AxisRect.Right + 6, f_iy);

          p_Bitmap.MoveTo(m_AxisRect.left, f_iy);
          p_Bitmap.LineToAS(m_AxisRect.left - 6, f_iy);

          f_TicLabel := TMKGlobal.NumberToString(f_GridPosition / m_Unit, m_YGridPrecision);

          f_x := m_BoundRect.Right - p_Bitmap.TextWidth(f_TicLabel) - CMKConst.CHART_DRAW_YBOUNDARY_OFFSET - 2;
          f_Y := Math.floor(GetScreenY(f_GridPosition, m_MaxMin) - p_Bitmap.TextHeight(f_TicLabel) / 2);
          p_Bitmap.Textout(f_x, f_Y, f_TicLabel);
        end;

        f_GridPosition := f_GridPosition - m_YGridSize;
      end;
    end;

    if m_ChartIndex = 0 then
    begin
      f_RightTickLabelCount := 0;
      for f_Index := 0 to m_ObjectCollection.Count - 1 do
      begin
        f_LineSeries := CMKLineValueSeries(m_ObjectCollection.Items[f_Index]);

        if (f_LineSeries.m_Items.Count <= 0) then
          continue;
        if f_LineSeries.m_MaxMinTable[0].m_YMax <= f_LineSeries.m_MaxMinTable[0].m_YMin then
          continue;

        if ((f_LineSeries.m_Type = CMKConst.LINESERIES_PRICE_AT_OPS) or (f_LineSeries.m_Type = CMKConst.LINESERIES_OPS) OR
            (f_LineSeries.m_Type = CMKConst.LINESERIES_OPSIGUK) OR (f_LineSeries.m_Type = CMKConst.LINESERIES_OPSIGUK2) OR
            (f_LineSeries.m_Type = CMKConst.LINESERIES_OPSREL) OR (f_LineSeries.m_Type = CMKConst.LINESERIES_OPSSTDDEV)) then
        begin

          f_FontColor := m_ColorSet.m_Color[f_LineSeries.m_LineColors[0]];
          f_FontColor := SetAlpha(f_FontColor, TMKGlobal.GetAlphaValue(100));

          if (m_YGridSize <> 0.0) then
          begin
            f_GridPosition := m_YGridSize;
            while (f_GridPosition < m_MaxMin.m_YMax) do
            begin
              if (f_GridPosition > m_MaxMin.m_YMin) then
              begin
                f_iy := GetScreenY(f_GridPosition, m_MaxMin);
                f_Value := GetRealY(f_iy, f_LineSeries.m_MaxMinTable[0]);

                if (f_LineSeries.m_Type = CMKConst.LINESERIES_OPS) OR (f_LineSeries.m_Type = CMKConst.LINESERIES_PRICE_AT_OPS)
                then
                begin
                  f_TicLabel := TMKGlobal.NumberToString(f_Value, m_YGridPrecision);
                end
                else
                begin
                  f_TicLabel := TMKGlobal.NumberToString(f_Value, f_LineSeries.m_Precision);
                end;

                f_x := m_AxisRect.left - p_Bitmap.TextWidth(f_TicLabel) - 4 - CMKConst.CHART_DRAW_YBOUNDARY_OFFSET;

                if f_RightTickLabelCount = 0 then
                begin
                  f_Y := f_iy - p_Bitmap.TextHeight(f_TicLabel);
                end
                else
                begin
                  f_Y := f_iy;
                end;
                p_Bitmap.RenderText(f_x, f_Y, f_TicLabel, 0, f_FontColor);
              end;

              f_GridPosition := f_GridPosition + m_YGridSize;
            end;

            f_GridPosition := 0;
            while (f_GridPosition > m_MaxMin.m_YMin) do
            begin
              if (f_GridPosition < m_MaxMin.m_YMax) then
              begin
                f_iy := GetScreenY(f_GridPosition, m_MaxMin);
                f_Value := GetRealY(f_iy, f_LineSeries.m_MaxMinTable[0]);

                if (f_LineSeries.m_Type = CMKConst.LINESERIES_OPS) OR (f_LineSeries.m_Type = CMKConst.LINESERIES_PRICE_AT_OPS)
                then
                begin
                  f_TicLabel := TMKGlobal.NumberToString(f_Value, m_YGridPrecision);
                end
                else
                begin
                  f_TicLabel := TMKGlobal.NumberToString(f_Value, f_LineSeries.m_Precision);
                end;

                f_x := m_AxisRect.left - p_Bitmap.TextWidth(f_TicLabel) - CMKConst.CHART_DRAW_YBOUNDARY_OFFSET;

                if f_RightTickLabelCount = 0 then
                begin
                  f_Y := f_iy - p_Bitmap.TextHeight(f_TicLabel);
                end
                else
                begin
                  f_Y := f_iy;
                end;
                p_Bitmap.RenderText(f_x, f_Y, f_TicLabel, 0, f_FontColor);
              end;

              f_GridPosition := f_GridPosition - m_YGridSize;
            end;
          end;

          f_RightTickLabelCount := f_RightTickLabelCount + 1;
          if (f_RightTickLabelCount >= 2) then
            break;
        end;
      end;
    end;

    if (m_Unit <> 1) then
    begin
      if (m_Unit = 1000000) then
        f_Unit := '*1,000,000'
      else if (m_Unit = 1000) then
        f_Unit := '*1,000'
      else
        f_Unit := '';

      p_Bitmap.Font.Name := CMKColorSet.NUMBER2_FONT_FAMILY;
      p_Bitmap.Font.Size := CMKColorSet.NUMBER2_FONT_SMALLSIZE2;
      p_Bitmap.Font.Style := [];
      p_Bitmap.Font.Color := m_ColorSet.m_Color[CMKColorSet.UNIT_TEXT_COLOR];

      PenColor := m_ColorSet.m_Color[CMKColorSet.UNIT_LINE_COLOR];
      PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));

      FillColor := m_ColorSet.m_Color[CMKColorSet.UNIT_FILLED_COLOR];
      FillColor := SetAlpha(FillColor, TMKGlobal.GetAlphaValue(100));

      f_TextWidth := p_Bitmap.TextWidth(f_Unit) + 2;
      f_TextHeight := p_Bitmap.TextHeight(f_Unit);
      f_x := m_AxisRect.Right + 1;
      f_Y := m_AxisRect.Top;
      f_X2 := f_x + m_BoundRect.Right - (m_AxisRect.Right) - CMKConst.CHART_DRAW_YBOUNDARY_OFFSET - 1;
      f_Y2 := f_Y + 15;
      p_Bitmap.FillRectTS(f_x, f_Y, f_X2, f_Y2, FillColor);
      p_Bitmap.FrameRectTS(f_x, f_Y, f_X2, f_Y2, PenColor);
      p_Bitmap.Textout(f_x + ((f_X2 - f_x) - f_TextWidth), Math.floor(f_Y + (((f_Y2 - f_Y) - f_TextHeight) / 2)), f_Unit);
    end;
  end;
end;

procedure CMKChartBlock.DrawLastValue(p_Bitmap: TBitmap32);
var
  f_GridPosition: Double;
  f_ix, f_iy, f_CharHeight: Integer;
  f_TicLabel: String;
  f_FormatStr: String;
  f_dYTicLable1, f_ddYTicLable2, f_ddYTicLable3: Integer;
  f_Precision1: Integer;
  f_Precision2: Integer;
  f_dMulti: Double;

  f_TextWidth, f_TextHeight, f_LineHeight: Integer;
  f_PaddingTop, f_PaddingBottom: Integer;
  PenColor: TColor32;
  FillColor: TColor32;

  f_Unit: String;

  f_Index: Integer;
  f_LineSeries: CMKLineValueSeries;
  f_RightTickLabelCount: Integer;
  f_Value: Double;
  f_FontColor: TColor32;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_X1, f_X2, f_Y1, f_Y2: Integer;
  f_XIndex0, f_XIndex1: Integer;
begin

  f_PaddingTop := 2;
  f_PaddingBottom := 2;

  if m_ChartIndex = 0 then
  begin
    p_Bitmap.Font.Name := CMKColorSet.NUMBER2_FONT_FAMILY;
    p_Bitmap.Font.Size := CMKColorSet.NUMBER2_FONT_SMALLSIZE2;
    p_Bitmap.Font.Style := [];
    p_Bitmap.Font.Color := m_ColorSet.m_Color[CMKColorSet.YTICK_LABEL_COLOR];

    for f_Index := 0 to m_ObjectCollection.Count - 1 do
    begin
      f_LineSeries := CMKLineValueSeries(m_ObjectCollection.Items[f_Index]);
      if (f_LineSeries.m_Items.Count <= 0) then
        continue;

      if (f_LineSeries.m_Type = CMKConst.LINESERIES_PRICE) then
      begin
        if f_LineSeries.m_Items.Count > 0 then
        begin
          f_XIndex0 := f_LineSeries.m_Items.Count - 1;
          f_XIndex1 := f_LineSeries.m_Items.Count - 2;
          f_LineValue0 := f_LineSeries.m_Items[f_XIndex0];
          f_TicLabel := TMKGlobal.NumberToString(f_LineValue0.m_Value[3], f_LineSeries.m_Precision);
          f_TextWidth := p_Bitmap.TextWidth(f_TicLabel);
          f_TextHeight := p_Bitmap.TextHeight(f_TicLabel);
          f_LineHeight := f_TextHeight;

          f_iy := GetScreenY(f_LineValue0.m_Value[3], f_LineSeries.m_MaxMinTable[0]);

          PenColor := m_ColorSet.m_Color[CMKColorSet.TRACE_XY_LINE_COLOR];
          PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));

          FillColor := m_ColorSet.m_Color[CMKColorSet.UNIT_FILLED_COLOR];
          FillColor := SetAlpha(FillColor, TMKGlobal.GetAlphaValue(100));

          f_X1 := m_AxisRect.Right;
          f_X2 := m_BoundRect.Right + 1;
          f_Y1 := f_iy - f_TextHeight div 2 - f_PaddingTop;
          f_Y2 := f_Y1 + f_LineHeight * 3 + f_PaddingTop + f_PaddingBottom;
          f_iy := f_Y1 + f_PaddingTop;

          p_Bitmap.FillRectTS(f_X1, f_Y1, f_X2, f_Y2, FillColor);
          p_Bitmap.FrameRectTS(f_X1, f_Y1, f_X2, f_Y2, PenColor);

          f_FontColor := m_ColorSet.m_Color[CMKColorSet.YTICK_LABEL_COLOR];
          f_FontColor := SetAlpha(f_FontColor, TMKGlobal.GetAlphaValue(100));
          f_ix := m_BoundRect.Right - f_TextWidth - CMKConst.CHART_DRAW_YBOUNDARY_OFFSET;
          p_Bitmap.RenderText(f_ix, f_iy, f_TicLabel, 0, f_FontColor);

          if f_XIndex1 >= 0 then
          begin
            f_LineValue1 := f_LineSeries.m_Items[f_XIndex1];
            f_Value := f_LineValue0.m_Value[3] - f_LineValue1.m_Value[3];

            if f_Value > 0 then
            begin
              f_FontColor := m_ColorSet.m_Color[CMKColorSet.TEXT_UP_LINE];
            end
            else if f_Value < 0 then
            begin
              f_FontColor := m_ColorSet.m_Color[CMKColorSet.TEXT_DN_LINE];
            end
            else
            begin
              f_FontColor := m_ColorSet.m_Color[CMKColorSet.YTICK_LABEL_COLOR];
            end;
            f_FontColor := SetAlpha(f_FontColor, TMKGlobal.GetAlphaValue(100));

            f_TicLabel := TMKGlobal.NumberToString(f_Value, f_LineSeries.m_Precision);
            f_TextWidth := p_Bitmap.TextWidth(f_TicLabel);

            f_ix := m_BoundRect.Right - f_TextWidth - CMKConst.CHART_DRAW_YBOUNDARY_OFFSET;
            f_iy := f_iy + f_LineHeight;
            p_Bitmap.RenderText(f_ix, f_iy, f_TicLabel, 0, f_FontColor);

            if f_LineValue1.m_Value[3] <> 0 then
            begin
              f_Value := (f_LineValue0.m_Value[3] - f_LineValue1.m_Value[3]) * 100.0 / f_LineValue1.m_Value[3];
            end
            else
            begin
              f_Value := 0.0;
            end;
            f_TicLabel := TMKGlobal.NumberToString(f_Value, 2) + '%';
            f_TextWidth := p_Bitmap.TextWidth(f_TicLabel);

            f_ix := m_BoundRect.Right - f_TextWidth - CMKConst.CHART_DRAW_YBOUNDARY_OFFSET;
            f_iy := f_iy + f_LineHeight;
            p_Bitmap.RenderText(f_ix, f_iy, f_TicLabel, 0, f_FontColor);

          end;
        end;
      end;
    end;
  end;
end;

procedure CMKChartBlock.DrawExitButton(p_Bitmap: TBitmap32);
var
  PenColor: TColor32;
  FillColor: TColor32;
  f_X1, f_X2, f_Y1, f_Y2: Integer;
begin
  if Self.m_ChartIndex < 1 then
    exit;

  PenColor := m_ColorSet.m_Color[CMKColorSet.TRACE_XY_LINE_COLOR];
  PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(80));

  FillColor := m_ColorSet.m_Color[CMKColorSet.UNIT_FILLED_COLOR];
  FillColor := SetAlpha(FillColor, TMKGlobal.GetAlphaValue(80));

  f_X1 := m_AxisRect.Right - 10 - 2;
  f_X2 := f_X1 + 9;
  f_Y1 := m_AxisRect.Top + 5;
  f_Y2 := f_Y1 + 9;

  p_Bitmap.FillRectTS(f_X1, f_Y1, f_X2, f_Y2, FillColor);
  p_Bitmap.FrameRectTS(f_X1, f_Y1, f_X2 + 1, f_Y2 + 1, PenColor);

  p_Bitmap.MoveTo(f_X1, f_Y1);
  p_Bitmap.LineToAS(f_X2, f_Y2);

  p_Bitmap.MoveTo(f_X2, f_Y1);
  p_Bitmap.LineToAS(f_X1, f_Y2);

end;

procedure CMKChartBlock.DrawXGrid(p_Bitmap: TBitmap32);
var
  f_Index, f_ix: Integer;
  f_Draw, f_FirstValue: Boolean;
  f_Sx, f_Ex: Integer;
  f_OldYear, f_NewYear: Integer;
  f_OldMonth, f_NewMonth: Integer;
  f_OldDay, f_NewDay: Integer;
  f_OldWeek, f_NewWeek: Integer;
  f_OldHour, f_NewHour: Integer;
  f_OldMin, f_NewMin: Integer;
  f_OldSec, f_NewSec: Integer;
  f_Date0, f_Date1: Integer;
  f_MaxMin: Integer;
  f_ValueArray: CMKLineValueSeries;

  PenColor: TColor32;
begin
  if (m_VisibleXGrid) then
  begin
    if (m_ChartDataSeries.m_TimeFrame < 9000) then
    begin
      f_Sx := Math.floor(m_MaxMin.m_XMin);
      f_Ex := Math.floor(m_MaxMin.m_XMax);
      if (f_Sx < m_AbsMaxMin.m_XMin) then
        f_Sx := Math.floor(m_AbsMaxMin.m_XMin);

      if (f_Ex > m_AbsMaxMin.m_XMax) then
        f_Ex := Math.floor(m_AbsMaxMin.m_XMax);

      f_MaxMin := 1;
      if (m_ChartDataSeries.m_Items[f_Sx] = NIL) then
        exit;

      f_Date1 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Sx]).m_CloseDateTime);

      f_Index := f_Sx;
      while ((f_Index <= f_Ex) and (f_Index < m_ChartDataSeries.m_Items.Count)) do
      begin
        f_Date0 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_CloseDateTime);
        if (f_Date1 <> f_Date0) then
          Inc(f_MaxMin);

        f_Date1 := f_Date0;

        Inc(f_Index);
      end;

      if (m_ChartDataSeries.m_TimeFrame = 1000) then
        f_MaxMin := f_MaxMin * 5
      else if (m_ChartDataSeries.m_TimeFrame = 2000) then
        f_MaxMin := f_MaxMin * 20
      else if (m_ChartDataSeries.m_TimeFrame = 3000) then
        f_MaxMin := f_MaxMin * 60
      else if (m_ChartDataSeries.m_TimeFrame = 4000) then
        f_MaxMin := f_MaxMin * 240
      else
        f_MaxMin := f_MaxMin;

      PenColor := m_ColorSet.m_Color[CMKColorSet.GRID_COLOR];
      PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));
      p_Bitmap.PenColor := PenColor;

      f_OldYear := 0;
      f_OldMonth := 0;
      f_OldDay := 0;
      f_OldWeek := -1;
      f_OldHour := 0;
      f_OldMin := 0;
      f_FirstValue := true;

      f_Index := f_Sx;
      while ((f_Index <= f_Ex) and (f_Index < m_ChartDataSeries.m_Items.Count)) do
      begin
        f_Draw := false;
        f_NewYear := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Year;
        f_NewMonth := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Month;
        f_NewDay := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Day;
        f_NewWeek := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_CloseDateTime);
        f_NewWeek := Math.floor((f_NewWeek + 5) / 7);
        f_NewHour := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Hour;
        f_NewMin := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Min;
        if (f_MaxMin <= 2) then
        begin
          if (f_OldHour <> f_NewHour) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 3) then
        begin
          if (f_OldDay <> f_NewDay) then
            f_Draw := true;

          if (Math.floor(f_OldHour / 12) <> Math.floor(f_NewHour / 12)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 4) then
        begin
          if (f_OldDay <> f_NewDay) then
            f_Draw := true;

          if (Math.floor(f_OldHour / 12) <> Math.floor(f_NewHour / 12)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 10) then
        begin
          if (f_OldDay <> f_NewDay) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 90) then
        begin
          if (f_OldWeek <> f_NewWeek) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 300) then
        begin
          // 1년
          if (f_OldMonth <> f_NewMonth) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 600) then
        begin
          // 2년
          if (Math.floor((f_OldMonth - 1) / 2) <> Math.floor((f_NewMonth - 1) / 2)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 900) then
        begin
          // 3년
          if (Math.floor((f_OldMonth - 1) / 3) <> Math.floor((f_NewMonth - 1) / 3)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 1500) then
        begin
          // 5년
          if (Math.floor((f_OldMonth - 1) / 6) <> Math.floor((f_NewMonth - 1) / 6)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 6000) then
        begin
          // 20년
          if (f_OldYear <> f_NewYear) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 18000) then
        begin
          // 60년
          if (Math.floor(f_OldYear / 5) <> Math.floor(f_NewYear / 5)) then
            f_Draw := true;
        end
        else
        begin
          if (Math.floor(f_OldYear / 10) <> Math.floor(f_NewYear / 10)) then
            f_Draw := true;
        end;

        if ((not f_FirstValue) and (f_Draw)) then
        begin
          f_ix := GetScreenXCenter(f_Index, m_MaxMin);

          p_Bitmap.MoveTo(f_ix, m_AxisRect.Top);
          p_Bitmap.LineToAS(f_ix, m_AxisRect.bottom);
        end;

        if (f_FirstValue) then
          f_FirstValue := false;

        f_OldYear := f_NewYear;
        f_OldMonth := f_NewMonth;
        f_OldDay := f_NewDay;
        f_OldWeek := f_NewWeek;
        f_OldHour := f_NewHour;
        f_OldMin := f_NewMin;

        Inc(f_Index);
      end;
    end
    else
    begin
      f_Sx := Math.floor(m_MaxMin.m_XMin);
      f_Ex := Math.floor(m_MaxMin.m_XMax);
      if (f_Sx < m_AbsMaxMin.m_XMin) then
        f_Sx := Math.floor(m_AbsMaxMin.m_XMin);

      if (f_Ex > m_AbsMaxMin.m_XMax) then
        f_Ex := Math.floor(m_AbsMaxMin.m_XMax);

      f_MaxMin := 1;
      if (m_ChartDataSeries.m_Items[f_Sx] = NIL) then
        exit;

      f_Date1 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Sx]).m_CloseDateTime * 86400);

      f_Index := f_Sx;
      while ((f_Index <= f_Ex) and (f_Index < m_ChartDataSeries.m_Items.Count)) do
      begin
        f_Date0 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_CloseDateTime * 86400);
        if (f_Date1 <> f_Date0) then
          Inc(f_MaxMin);

        f_Date1 := f_Date0;

        Inc(f_Index);
      end;

      f_MaxMin := f_MaxMin * (m_ChartDataSeries.m_TimeFrame - 9000);

      PenColor := m_ColorSet.m_Color[CMKColorSet.GRID_COLOR];
      PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));
      p_Bitmap.PenColor := PenColor;

      f_OldYear := 0;
      f_OldMonth := 0;
      f_OldDay := 0;
      f_OldWeek := -1;
      f_OldHour := 0;
      f_OldMin := 0;
      f_OldSec := 0;
      f_FirstValue := true;

      f_Index := f_Sx;
      while ((f_Index <= f_Ex) and (f_Index < m_ChartDataSeries.m_Items.Count)) do
      begin
        f_Draw := false;
        f_NewYear := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Year;
        f_NewMonth := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Month;
        f_NewDay := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Day;
        f_NewWeek := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_CloseDateTime);
        f_NewWeek := Math.floor((f_NewWeek + 5) / 7);
        f_NewHour := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Hour;
        f_NewMin := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Min;
        f_NewSec := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Sec;

        if (f_MaxMin <= 60) then
        begin
          if (Math.floor(f_OldSec / 10) <> Math.floor(f_NewSec / 10)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 150) then
        begin
          if (Math.floor(f_OldSec / 20) <> Math.floor(f_NewSec / 20)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 240) then
        begin
          if (Math.floor(f_OldSec / 30) <> Math.floor(f_NewSec / 30)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 480) then
        begin
          if (Math.floor(f_OldMin / 1) <> Math.floor(f_NewMin / 1)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 520) then
        begin
          if (Math.floor(f_OldMin / 2) <> Math.floor(f_NewMin / 2)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 800) then
        begin
          if (Math.floor(f_OldMin / 3) <> Math.floor(f_NewMin / 3)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 1600) then
        begin
          if (Math.floor(f_OldMin / 5) <> Math.floor(f_NewMin / 5)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 3200) then
        begin
          if (Math.floor(f_OldMin / 10) <> Math.floor(f_NewMin / 10)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 6400) then
        begin
          if (Math.floor(f_OldMin / 20) <> Math.floor(f_NewMin / 20)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 12000) then
        begin
          if (Math.floor(f_OldMin / 30) <> Math.floor(f_NewMin / 30)) then
            f_Draw := true;
        end
        else
        begin
          if (Math.floor(f_OldHour / 1) <> Math.floor(f_NewHour / 1)) then
            f_Draw := true;
        end;

        if ((not f_FirstValue) and (f_Draw)) then
        begin
          f_ix := GetScreenXCenter(f_Index, m_MaxMin);

          p_Bitmap.MoveTo(f_ix, m_AxisRect.Top);
          p_Bitmap.LineToAS(f_ix, m_AxisRect.bottom);
        end;

        if (f_FirstValue) then
          f_FirstValue := false;

        f_OldYear := f_NewYear;
        f_OldMonth := f_NewMonth;
        f_OldDay := f_NewDay;
        f_OldWeek := f_NewWeek;
        f_OldHour := f_NewHour;
        f_OldMin := f_NewMin;
        f_OldSec := f_NewSec;

        Inc(f_Index);
      end;
    end;
  end;
end;

procedure CMKChartBlock.DrawXTicLabel(p_Bitmap: TBitmap32);
var
  f_Index, f_ix, f_iy, f_Type: Integer;
  f_Draw, f_FirstValue: Boolean;
  f_Sx, f_Ex: Integer;
  f_OldYear, f_NewYear: Integer;
  f_OldMonth, f_NewMonth: Integer;
  f_OldDay, f_NewDay: Integer;
  f_OldWeek, f_NewWeek: Integer;
  f_OldHour, f_NewHour: Integer;
  f_OldMin, f_NewMin: Integer;
  f_OldSec, f_NewSec: Integer;
  f_Date0, f_Date1: Integer;
  f_MaxMin: Integer;
  f_TicLabel: String;
  f_OldPosition: Integer;
  f_MarketIndex: Integer;
  f_ValueArray: CMKLineValueSeries;
  f_Year, f_Month, f_Day, f_Hour, f_Min: Integer;

  f_TextWidth: Integer;
  f_x, f_Y, f_X2, f_Y2: Integer;
begin
  f_OldPosition := m_AxisRect.left;

  p_Bitmap.Font.Name := CMKColorSet.NUMBER2_FONT_FAMILY;
  p_Bitmap.Font.Size := CMKColorSet.NUMBER2_FONT_SMALLSIZE2;
  p_Bitmap.Font.Style := [];
  p_Bitmap.Font.Color := m_ColorSet.m_Color[CMKColorSet.XTICK_LABEL_COLOR];

  if (m_VisibleXLabel) then
  begin
    if (m_ChartDataSeries.m_TimeFrame < 9000) then
    begin
      f_iy := m_XLabelRect.Top;
      f_Sx := Math.floor(m_MaxMin.m_XMin);
      f_Ex := Math.floor(m_MaxMin.m_XMax);
      if (f_Sx < m_AbsMaxMin.m_XMin) then
        f_Sx := Math.floor(m_AbsMaxMin.m_XMin);

      if (f_Ex > m_AbsMaxMin.m_XMax) then
        f_Ex := Math.floor(m_AbsMaxMin.m_XMax);

      f_MaxMin := 1;
      f_Date1 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Sx]).m_CloseDateTime);

      f_Index := f_Sx;
      while ((f_Index <= f_Ex) and (f_Index < m_ChartDataSeries.m_Items.Count)) do
      begin
        f_Date0 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_CloseDateTime);
        if (f_Date1 <> f_Date0) then
          Inc(f_MaxMin);

        f_Date1 := f_Date0;
        Inc(f_Index);
      end;

      if (m_ChartDataSeries.m_TimeFrame = 1000) then
        f_MaxMin := f_MaxMin * 5
      else if (m_ChartDataSeries.m_TimeFrame = 2000) then
        f_MaxMin := f_MaxMin * 20
      else if (m_ChartDataSeries.m_TimeFrame = 3000) then
        f_MaxMin := f_MaxMin * 60
      else if (m_ChartDataSeries.m_TimeFrame = 4000) then
        f_MaxMin := f_MaxMin * 240
      else
        f_MaxMin := f_MaxMin;

      f_OldYear := 0;
      f_OldMonth := 0;
      f_OldDay := 0;
      f_OldWeek := -1;
      f_OldHour := 0;
      f_OldMin := 0;
      f_FirstValue := true;

      if (f_MaxMin <= 90) then
        f_Type := 0
      else
        f_Type := 1;

      f_Index := f_Sx;
      while ((f_Index <= f_Ex) and (f_Index < m_ChartDataSeries.m_Items.Count)) do
      begin
        f_Draw := false;
        f_NewYear := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Year;
        f_NewMonth := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Month;
        f_NewDay := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Day;
        f_NewWeek := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_CloseDateTime);
        f_NewWeek := Math.floor((f_NewWeek + 5) / 7);
        f_NewHour := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Hour;
        f_NewMin := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Min;
        if (f_MaxMin <= 2) then
        begin
          if (f_OldHour <> f_NewHour) then
            f_Draw := true;

          f_Type := 0;
        end
        else if (f_MaxMin <= 3) then
        begin
          if (f_OldDay <> f_NewDay) then
            f_Draw := true;

          if (Math.floor(f_OldHour / 12) <> Math.floor(f_NewHour / 12)) then
            f_Draw := true;

          f_Type := 0;
        end
        else if (f_MaxMin <= 4) then
        begin
          if (f_OldDay <> f_NewDay) then
            f_Draw := true;

          if (Math.floor(f_OldHour / 12) <> Math.floor(f_NewHour / 12)) then
            f_Draw := true;

          f_Type := 0;
        end
        else if (f_MaxMin <= 10) then
        begin
          if (f_OldDay <> f_NewDay) then
            f_Draw := true;

          f_Type := 0;
        end
        else if (f_MaxMin <= 90) then
        begin
          if (f_OldWeek <> f_NewWeek) then
            f_Draw := true;

          f_Type := 0;
        end
        else if (f_MaxMin <= 300) then
        begin
          // 1년
          if (f_OldMonth <> f_NewMonth) then
            f_Draw := true;

          f_Type := 1;
        end
        else if (f_MaxMin <= 600) then
        begin
          // 2년
          if (Math.floor((f_OldMonth - 1) / 2) <> Math.floor((f_NewMonth - 1) / 2)) then
            f_Draw := true;

          f_Type := 1;
        end
        else if (f_MaxMin <= 900) then
        begin
          // 3년
          if (Math.floor((f_OldMonth - 1) / 3) <> Math.floor((f_NewMonth - 1) / 3)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 1500) then
        begin
          // 5년
          if (Math.floor((f_OldMonth - 1) / 6) <> Math.floor((f_NewMonth - 1) / 6)) then
            f_Draw := true;

          f_Type := 1;
        end
        else if (f_MaxMin <= 6000) then
        begin
          // 20년
          if (f_OldYear <> f_NewYear) then
            f_Draw := true;

          f_Type := 2;
        end
        else if (f_MaxMin <= 18000) then
        begin
          // 60년
          if (Math.floor(f_OldYear / 5) <> Math.floor(f_NewYear / 5)) then
            f_Draw := true;

          f_Type := 2;
        end
        else
        begin
          if (Math.floor(f_OldYear / 10) <> Math.floor(f_NewYear / 10)) then
            f_Draw := true;

          f_Type := 2;
        end;

        if ((not f_FirstValue) and (f_Draw)) then
        begin
          f_ix := GetScreenXCenter(f_Index, m_MaxMin);

          if (f_Type = 0) then
          begin
            if (f_NewDay <> f_OldDay) then
              f_TicLabel := TMKGlobal.DateToMM_DD(f_NewMonth, f_NewDay)
            else
              f_TicLabel := TMKGlobal.TimeToHH_MM(f_NewHour, f_NewMin);
          end
          else if (f_Type = 1) then
          begin
            f_TicLabel := TMKGlobal.DateToYY_MM_DD(TMKGlobal.atoi(Copy(IntToStr(f_NewYear), 3, 2)), f_NewMonth);
          end
          else
          begin
            f_TicLabel := TMKGlobal.DateToYY_MM_DD(TMKGlobal.atoi(Copy(IntToStr(f_NewYear), 3, 2)));
          end;

          f_TextWidth := p_Bitmap.TextWidth(f_TicLabel);
          if ((f_OldPosition = m_AxisRect.left) or (f_OldPosition + f_TextWidth * 1.5 < f_ix)) then
          begin
            f_x := Math.floor(f_ix - f_TextWidth / 2);
            f_Y := f_iy - 1;
            f_OldPosition := f_ix;
            p_Bitmap.Textout(f_x, f_Y + 2, f_TicLabel);
          end;
        end;

        if (f_FirstValue) then
          f_FirstValue := false;

        f_OldYear := f_NewYear;
        f_OldMonth := f_NewMonth;
        f_OldDay := f_NewDay;
        f_OldWeek := f_NewWeek;
        f_OldHour := f_NewHour;
        f_OldMin := f_NewMin;

        Inc(f_Index);
      end;
    end
    else
    begin
      f_iy := m_XLabelRect.Top;
      f_Sx := Math.floor(m_MaxMin.m_XMin);
      f_Ex := Math.floor(m_MaxMin.m_XMax);
      if (f_Sx < m_AbsMaxMin.m_XMin) then
        f_Sx := Math.floor(m_AbsMaxMin.m_XMin);
      if (f_Ex > m_AbsMaxMin.m_XMax) then
        f_Ex := Math.floor(m_AbsMaxMin.m_XMax);

      f_MaxMin := 1;
      f_Date1 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Sx]).m_CloseDateTime * 86400);

      f_Index := f_Sx;
      while ((f_Index <= f_Ex) and (f_Index < m_ChartDataSeries.m_Items.Count)) do
      begin
        f_Date0 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_CloseDateTime * 86400);
        if (f_Date1 <> f_Date0) then
          Inc(f_MaxMin);

        f_Date1 := f_Date0;

        Inc(f_Index);
      end;

      f_MaxMin := f_MaxMin * (m_ChartDataSeries.m_TimeFrame - 9000);

      f_OldYear := 0;
      f_OldMonth := 0;
      f_OldDay := 0;
      f_OldWeek := -1;
      f_OldHour := 0;
      f_OldMin := 0;
      f_OldSec := 0;
      f_FirstValue := true;

      f_Index := f_Sx;
      while ((f_Index <= f_Ex) and (f_Index < m_ChartDataSeries.m_Items.Count)) do
      begin
        f_Draw := false;
        f_NewYear := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Year;
        f_NewMonth := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Month;
        f_NewDay := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Day;
        f_NewWeek := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_CloseDateTime);
        f_NewWeek := Math.floor((f_NewWeek + 5) / 7);
        f_NewHour := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Hour;
        f_NewMin := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Min;
        f_NewSec := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Sec;

        if (f_MaxMin <= 60) then
        begin
          if (Math.floor(f_OldSec / 10) <> Math.floor(f_NewSec / 10)) then
            f_Draw := true;
          f_Type := 0;
        end
        else if (f_MaxMin <= 150) then
        begin
          if (Math.floor(f_OldSec / 20) <> Math.floor(f_NewSec / 20)) then
            f_Draw := true;
          f_Type := 0;
        end
        else if (f_MaxMin <= 240) then
        begin
          if (Math.floor(f_OldSec / 30) <> Math.floor(f_NewSec / 30)) then
            f_Draw := true;
          f_Type := 0;
        end
        else if (f_MaxMin <= 480) then
        begin
          if (Math.floor(f_OldMin / 1) <> Math.floor(f_NewMin / 1)) then
            f_Draw := true;
          f_Type := 1;
        end
        else if (f_MaxMin <= 520) then
        begin
          if (Math.floor(f_OldMin / 2) <> Math.floor(f_NewMin / 2)) then
            f_Draw := true;
          f_Type := 1;
        end
        else if (f_MaxMin <= 800) then
        begin
          if (Math.floor(f_OldMin / 3) <> Math.floor(f_NewMin / 3)) then
            f_Draw := true;
          f_Type := 1;
        end
        else if (f_MaxMin <= 1600) then
        begin
          if (Math.floor(f_OldMin / 5) <> Math.floor(f_NewMin / 5)) then
            f_Draw := true;
          f_Type := 1;
        end
        else if (f_MaxMin <= 3200) then
        begin
          if (Math.floor(f_OldMin / 10) <> Math.floor(f_NewMin / 10)) then
            f_Draw := true;
          f_Type := 1;
        end
        else if (f_MaxMin <= 6400) then
        begin
          if (Math.floor(f_OldMin / 20) <> Math.floor(f_NewMin / 20)) then
            f_Draw := true;
          f_Type := 1;
        end
        else if (f_MaxMin <= 12000) then
        begin
          if (Math.floor(f_OldMin / 30) <> Math.floor(f_NewMin / 30)) then
            f_Draw := true;
          f_Type := 1;
        end
        else
        begin
          if (Math.floor(f_OldHour / 1) <> Math.floor(f_NewHour / 1)) then
            f_Draw := true;
          f_Type := 2;
        end;

        if ((not f_FirstValue) and (f_Draw)) then
        begin
          f_ix := GetScreenXCenter(f_Index, m_MaxMin);

          if (f_Type = 0) then
          begin
            f_TicLabel := TMKGlobal.TimeToHH_MM_SS(f_NewHour, f_NewMin, f_NewSec);
          end
          else if (f_Type = 1) then
          begin
            f_TicLabel := TMKGlobal.TimeToHH_MM(f_NewHour, f_NewMin);
          end
          else
          begin
            f_TicLabel := TMKGlobal.TimeToHH_MM(f_NewHour, f_NewMin);
          end;

          f_TextWidth := p_Bitmap.TextWidth(f_TicLabel);
          if ((f_OldPosition = m_AxisRect.left) or (f_OldPosition + f_TextWidth * 1.5 < f_ix)) then
          begin
            f_x := Math.floor(f_ix - f_TextWidth / 2);
            f_Y := f_iy - 1;
            f_OldPosition := f_ix;
            p_Bitmap.Textout(f_x, f_Y + 2, f_TicLabel);
          end;
        end;

        if (f_FirstValue) then
          f_FirstValue := false;

        f_OldYear := f_NewYear;
        f_OldMonth := f_NewMonth;
        f_OldDay := f_NewDay;
        f_OldWeek := f_NewWeek;
        f_OldHour := f_NewHour;
        f_OldMin := f_NewMin;
        f_OldSec := f_NewSec;

        Inc(f_Index);
      end;
    end;
  end;
end;

procedure CMKChartBlock.DrawLabelOnNormalMode(p_Bitmap: TBitmap32);
var
  f_Index, f_Line, f_Option, f_TextWidth, f_TextHeight: Integer;
  f_CtrlHeight, f_RectHeight: Integer;
  f_ValueArray: CMKLineValueSeries;
  f_FirstValue: Boolean;
  f_X1, f_X2, f_Y1, f_Y2: Integer;
  f_LineX, f_LineY: Integer;
  f_Label: String;
  f_Alpha: Integer;
  f_LineColor: Integer;
  f_ActiveColor: Integer;
  f_LableX1, f_LableX2, f_LableY1, f_LableY2: Integer;
  f_VisibleCount: Integer;

  PenColor: TColor32;
begin
  f_VisibleCount := 0;

  p_Bitmap.Font.Name := CMKColorSet.NUMBER2_FONT_FAMILY;
  p_Bitmap.Font.Size := CMKColorSet.NUMBER2_FONT_SMALLSIZE2;
  p_Bitmap.Font.Style := [];
  p_Bitmap.Font.Color := m_ColorSet.m_Color[CMKColorSet.CAPTION_FIELDNAME_TEXT_COLOR];

  f_CtrlHeight := TMKGlobal.RectToHeight(m_LegendRect); // 전체 높이
  f_TextWidth := p_Bitmap.TextWidth('8'); // 텍스트 너비
  f_TextHeight := p_Bitmap.TextHeight('8'); // 텍스트 높이
  f_RectHeight := f_TextHeight - 4; // 사각형 높이는 폰트높이에서 4뺀크기
  f_LineX := m_LegendRect.left + 7; // X좌표
  f_LineY := m_LegendRect.Top + Math.floor((f_CtrlHeight - f_TextHeight) / 2) + 2; // Y 좌표

  f_LableX1 := m_LegendRect.left + 2;
  f_LableY1 := m_LegendRect.Top + 2;
  f_LableY2 := m_LegendRect.Top + 2 + 15;
  for f_Index := 0 to m_ObjectCollection.Count - 1 do
  begin
    f_ValueArray := CMKLineValueSeries(m_ObjectCollection.Items[f_Index]);

    if (not f_ValueArray.m_ViewLabel) then
      continue;

    f_Label := f_ValueArray.m_Name;

    f_VisibleCount := 0;
    for f_Line := 0 to f_ValueArray.m_LineCount - 1 do
    begin
      if (not f_ValueArray.m_LineVisibles[f_Line]) then
        continue;

      if (not f_ValueArray.m_LineLabelVisibles[f_Line]) then
        continue;

      Inc(f_VisibleCount);
    end;

    if (f_VisibleCount > 1) then
      f_Label := f_Label + '  '
    else
      f_Label := f_Label + ' ';

    f_FirstValue := true;
    for f_Line := 0 to f_ValueArray.m_LineCount - 1 do
    begin
      if (not f_ValueArray.m_LineVisibles[f_Line]) then
        continue;

      if (not f_ValueArray.m_LineLabelVisibles[f_Line]) then
        continue;

      if (not f_FirstValue) then
        f_Label := f_Label + '  ';

      f_TextWidth := p_Bitmap.TextWidth(f_Label);
      f_TextHeight := p_Bitmap.TextHeight(f_Label);
      f_X1 := f_TextWidth + f_LineX;
      f_Y1 := f_LineY + Math.floor((f_TextHeight - f_RectHeight) / 2) - 1;
      f_X2 := f_X1 + 5;
      f_Y2 := f_Y1 + f_RectHeight;

      if (f_ValueArray.m_LineTypes[f_Line] = 0) then
      begin
        f_LineColor := m_ColorSet.m_Color[f_ValueArray.m_LineColors[f_Line]];
        f_Alpha := m_ColorSet.m_Alpha[f_ValueArray.m_LineAlphas[f_Line]];
      end
      else if (f_ValueArray.m_LineTypes[f_Line] = 1) then
      begin
        f_LineColor := $00808080;
        f_Alpha := m_ColorSet.m_Alpha[f_ValueArray.m_LineAlphas[f_Line]];
      end
      else if (f_ValueArray.m_LineTypes[f_Line] = 2) then
      begin
        f_LineColor := m_ColorSet.m_Color[f_ValueArray.m_LineColors[f_Line]];
        f_Alpha := m_ColorSet.m_Alpha[f_ValueArray.m_LineAlphas[f_Line]];
      end
      else if (f_ValueArray.m_LineTypes[f_Line] = 3) then
      begin
        f_LineColor := m_ColorSet.m_Color[CMKColorSet.VOLUME_FILLED_COLOR];
        f_Alpha := m_ColorSet.m_Alpha[CMKColorSet.ALPHA_VOLUME_LINE];
      end
      else
      begin
        f_LineColor := f_LineColor;
        f_Alpha := f_Alpha;
      end;

      if (f_ValueArray.m_LineTypes[f_Line] = 0) then
      begin
        DrawFillRectAngle(p_Bitmap, 0, f_LineColor, TMKGlobal.GetAlphaValue(100), f_LineColor, f_Alpha, f_X1, f_Y1, f_X2, f_Y2);
      end
      else if (f_ValueArray.m_LineTypes[f_Line] = 1) then
      begin
        DrawFillRectAngle(p_Bitmap, 0, m_ColorSet.m_Color[CMKColorSet.OSC_UP_FILLED_COLOR], TMKGlobal.GetAlphaValue(100),
            m_ColorSet.m_Color[CMKColorSet.OSC_UP_FILLED_COLOR], m_ColorSet.m_Alpha[CMKColorSet.ALPHA_OSC_LINE], f_X1, f_Y1,
            f_X2, f_Y1 + 4);
        DrawFillRectAngle(p_Bitmap, 0, m_ColorSet.m_Color[CMKColorSet.OSC_DN_FILLED_COLOR], TMKGlobal.GetAlphaValue(100),
            m_ColorSet.m_Color[CMKColorSet.OSC_DN_FILLED_COLOR], m_ColorSet.m_Alpha[CMKColorSet.ALPHA_OSC_LINE], f_X1, f_Y1 + 4,
            f_X2, f_Y2);
      end
      else if (f_ValueArray.m_LineTypes[f_Line] = 2) then
      begin
        DrawFillRectAngle(p_Bitmap, 0, f_LineColor, TMKGlobal.GetAlphaValue(100), f_LineColor, f_Alpha, f_X1, f_Y1, f_X2, f_Y2);
      end
      else if (f_ValueArray.m_LineTypes[f_Line] = 3) then
      begin
        DrawFillRectAngle(p_Bitmap, 0, f_LineColor, TMKGlobal.GetAlphaValue(100), f_LineColor, f_Alpha, f_X1, f_Y1, f_X2, f_Y2);
      end
      else
        p_Bitmap := p_Bitmap;

      if (f_ValueArray.m_LineLabelNameVisibles[f_Line]) then
        f_Label := f_Label + '  ' + f_ValueArray.m_LineNames[f_Line]
      else
        f_Label := f_Label + '  ';

      f_FirstValue := false;
    end;

    f_FirstValue := true;
    for f_Option := 0 to f_ValueArray.m_OptionCount - 1 do
    begin
      if (f_FirstValue) then
        f_Label := f_Label + ' ('
      else
        f_Label := f_Label + ',';

      f_Label := f_Label + FloatToStr(f_ValueArray.m_Options[f_Option]);
      f_FirstValue := false;
    end;

    if (not f_FirstValue) then
      f_Label := f_Label + ')';

    f_TextWidth := p_Bitmap.TextWidth(f_Label);
    p_Bitmap.Textout(f_LineX, f_LineY, f_Label);

    if (f_Line < f_ValueArray.m_LineCount - 1) then
      f_LineX := f_LineX + f_TextWidth + 5
    else
    begin
      if ((f_VisibleCount > 1) or (f_ValueArray.m_OptionCount > 0)) then
        f_LineX := f_LineX + f_TextWidth + 5
      else
        f_LineX := f_LineX + f_TextWidth + 2;
    end;

    f_LableX2 := f_LineX;

    f_LableX1 := f_LableX2 + 5;
    f_LineX := f_LableX1 + 3;
  end;

  m_LastLabelX := f_LineX;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawLabel(p_Bitmap: TBitmap32);
begin
  DrawLabelOnNormalMode(p_Bitmap);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.OnMouseDown(p_X: Integer; p_Y: Integer);
var
  f_Action: Boolean;
begin
  if (m_ObjectCollection.Count = 0) then
    exit;

  f_Action := false;
  f_Action := OnEventMouseDown(p_X, p_Y);
  if (not f_Action) then
  begin
    m_DragNewX := Math.floor(p_X);
    m_DragOldX := Math.floor(p_X);
    m_CaptureMouse := true;
    m_Moving := true;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.OnMouseUp(p_X: Integer; p_Y: Integer);
var
  f_Action: Boolean;
begin
  f_Action := false;
  f_Action := OnEventMouseUp(p_X, p_Y);
  if (not f_Action) then
  begin
    m_CaptureMouse := false;
    m_Moving := false;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.OnMouseMoveOnAnytime(p_X: Integer; p_Y: Integer);
var
  f_PosInfo: CMKPosInfo;
begin
  if (m_ObjectCollection.Count = 0) then
    exit;

  if ((p_X >= m_AxisRect.left) and (p_X <= m_AxisRect.Right)) then
  begin
    f_PosInfo := CMKPosInfo.Create;
    f_PosInfo.m_ChartIndex := m_ChartIndex;
    f_PosInfo.m_MX := p_X;
    f_PosInfo.m_MY := p_Y;
    f_PosInfo.m_ValueX := Math.floor(GetRealX(p_X, m_MaxMin));
    f_PosInfo.m_ValueY := GetRealY(p_Y, m_MaxMin);

    if (f_PosInfo.m_ValueX > m_AbsMaxMin.m_XMax) then
      f_PosInfo.m_ValueX := m_AbsMaxMin.m_XMax;

    f_PosInfo.m_WindowX := Math.floor(GetScreenXCenter(f_PosInfo.m_ValueX, m_MaxMin));
    f_PosInfo.m_WindowY := Math.floor(GetScreenY(f_PosInfo.m_ValueY, m_MaxMin));
    CMKChartBlockManager(m_ChartBlockManager).TraceXYOnAnytime(f_PosInfo);

    f_PosInfo.Free();
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.OnMouseMoveSometime(p_X: Integer; p_Y: Integer);
var
  f_PosInfo: CMKPosInfo;

  f_Direction: Integer;
  f_XMinDate, f_XMaxDate: TDateTime;
  f_XMinOffset, f_XMaxOffset: Integer;
  f_Action: Boolean;
begin

  if (m_ObjectCollection.Count = 0) then
    exit;

  f_Action := false;
  f_Action := OnEventMouseMove(p_X, p_Y);
  if (not f_Action) then
  begin
    m_NewX := Math.floor(p_X);
    m_NewY := Math.floor(p_Y);
    if ((m_OldX = m_NewX) and (m_OldY = m_NewY)) then
      exit;

    m_OldX := m_NewX;
    m_OldY := m_NewY;

    try
      if (m_ChartBlockManager <> NIL) then
      begin
        if ((p_X >= m_AxisRect.left) and (p_X <= m_AxisRect.Right)) then
        begin
          f_PosInfo := CMKPosInfo.Create();
          f_PosInfo.m_ChartIndex := m_ChartIndex;
          f_PosInfo.m_MX := p_X;
          f_PosInfo.m_MY := p_Y;
          f_PosInfo.m_ValueX := Math.floor(GetRealX(p_X, m_MaxMin));
          f_PosInfo.m_ValueY := GetRealY(p_Y, m_MaxMin);
          if (f_PosInfo.m_ValueX > m_AbsMaxMin.m_XMax) then
            f_PosInfo.m_ValueX := m_AbsMaxMin.m_XMax;

          f_PosInfo.m_WindowX := Math.floor(GetScreenXCenter(f_PosInfo.m_ValueX, m_MaxMin));
          f_PosInfo.m_WindowY := Math.floor(GetScreenY(f_PosInfo.m_ValueY, m_MaxMin));
          GetEnableTracePannel(f_PosInfo);
          CMKChartBlockManager(m_ChartBlockManager).TraceXYOnSometime(f_PosInfo);
          CMKChartBlockManager(m_ChartBlockManager).DrawTraceCaption(Math.floor(f_PosInfo.m_ValueX));

          f_PosInfo.Free();
        end;
      end;
    finally
    end;
    if (m_Moving) then
    begin
      ClearActiveLayer();

      m_DragNewX := Math.floor(p_X);
      f_Action := false;

      if (m_DragOldX <> m_DragNewX) then
      begin
        f_Direction := Math.floor(GetRealX(m_DragNewX, m_MaxMin)) - Math.floor(GetRealX(m_DragOldX, m_MaxMin));
        if (f_Direction <> 0) then
        begin
          if (m_MaxMin.m_XMin < 0) then
            f_XMinOffset := Math.floor(m_MaxMin.m_XMin)
          else
            f_XMinOffset := 0;

          if (m_MaxMin.m_XMax > m_AbsMaxMin.m_XMax) then
            f_XMaxOffset := Math.floor(m_MaxMin.m_XMax - m_AbsMaxMin.m_XMax)
          else
            f_XMaxOffset := 0;

          f_XMinDate := CMKChartData(m_ChartDataSeries.m_Items[Math.floor(m_MaxMin.m_XMin - f_XMinOffset)]).m_CloseDateTime;
          f_XMaxDate := CMKChartData(m_ChartDataSeries.m_Items[Math.floor(m_MaxMin.m_XMax - f_XMaxOffset)]).m_CloseDateTime;
          if (not f_Action) then
          begin
            if (m_MaxMin.m_XMax - f_Direction > Math.floor(m_AbsMaxMin.m_XMax + m_PaddingRight + m_XExtraGap)) then
            begin
              f_Action := CMKChartBlockManager(m_ChartBlockManager).RequestNextData(f_Direction, f_XMinDate, f_XMaxDate,
                  f_XMinOffset, f_XMaxOffset);
              if (not f_Action) then
                f_Direction := Math.floor(m_MaxMin.m_XMax - (m_AbsMaxMin.m_XMax + m_PaddingRight + m_XExtraGap));
            end;
          end;

          if (not f_Action) then
          begin
            if (m_MaxMin.m_XMin - f_Direction < m_AbsMaxMin.m_XMin) then
            begin
              if (m_PrevRequestDate <> f_XMinDate) then
                f_Action := CMKChartBlockManager(m_ChartBlockManager).RequestPrevData(f_Direction, f_XMinDate, f_XMaxDate,
                    f_XMinOffset, f_XMaxOffset);

              m_PrevRequestDate := f_XMinDate;
              if (not f_Action) then
                f_Direction := Math.floor(m_MaxMin.m_XMin);
            end;
          end;

          if (not f_Action) then
          begin
            CMKChartBlockManager(m_ChartBlockManager).RangeEnlarge(m_MaxMin.m_XMin - f_Direction,
                m_MaxMin.m_XMax - f_Direction, true);
            CMKChartBlockManager(m_ChartBlockManager).RePaint();
          end;
        end;
      end;

      m_DragOldX := m_DragNewX;
    end;

  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.SetXExtraGap(p_X: Integer);
begin
  m_XExtraGap := p_X;
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.GetScreenYGridPrecision(): Integer;
begin
  Result := m_YGridPrecision;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.ClearActiveLayer();
begin
  if (m_DrawedOverLayer) then
  begin
    m_OverLayer.Bitmap.Clear($00000000);

    m_DrawedOverLayer := false;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawTraceDate(p_ValueX: Double);
var
  PenColor: TColor32;
  f_WindowX: Integer;
begin
  PenColor := m_ColorSet.m_Color[CMKColorSet.TRACE_FILLED_COLOR];
  PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));
  f_WindowX := Math.floor(GetScreenXCenter(p_ValueX, m_MaxMin));

  m_TraceLayer.Bitmap.PenColor := PenColor;

  if (f_WindowX >= m_AxisRect.left) AND (f_WindowX <= m_AxisRect.Right) then
  begin
    m_TraceLayer.Bitmap.MoveTo(f_WindowX, m_AxisRect.Top);
    m_TraceLayer.Bitmap.LineToAS(f_WindowX, m_AxisRect.bottom);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawTrace(p_TRInfo: CMKPosInfo);
var
  PenColor: TColor32;
begin
  PenColor := m_ColorSet.m_Color[CMKColorSet.TRACE_FILLED_COLOR];
  PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));

  m_TraceLayer.Bitmap.PenColor := PenColor;
  m_TraceLayer.Bitmap.MoveTo(p_TRInfo.m_WindowX, m_AxisRect.Top);
  m_TraceLayer.Bitmap.LineToAS(p_TRInfo.m_WindowX, m_AxisRect.bottom);
  if (p_TRInfo.m_ChartIndex = m_ChartIndex) then
  begin
    m_TraceLayer.Bitmap.MoveTo(m_AxisRect.left, p_TRInfo.m_WindowY);
    m_TraceLayer.Bitmap.LineToAS(m_AxisRect.Right, p_TRInfo.m_WindowY);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.GetPosValue(p_Index: Integer; Values: TList);
var
  f_PosValue: CMKPosValue;
  p_ValueArray: CMKLineValueSeries;
begin
  if ((p_Index < 0) or (p_Index >= m_ChartDataSeries.m_Items.Count)) then
    exit;

  if ((m_OverObject < 0) or (m_OverObject >= m_ObjectCollection.Count)) then
    exit;

  p_ValueArray := m_ObjectCollection[m_OverObject];
  if ((m_OverLine < 0) or (m_OverLine >= p_ValueArray.m_LineCount)) then
    exit;

  if (p_ValueArray.m_LineVisibles[m_OverLine]) then
  begin
    f_PosValue := CMKPosValue.Create;
    if (p_ValueArray.m_Type = CMKConst.LINESERIES_MA) then
      f_PosValue.m_Name := FloatToStr(p_ValueArray.m_Options[m_OverLine]) + g_ChartText[CT_CAPTION_DAY_LINE] // '일선'
    else
    begin
      f_PosValue.m_Name := p_ValueArray.m_LineNames[m_OverLine];
      if (f_PosValue.m_Name = '') then
        f_PosValue.m_Name := p_ValueArray.m_Name;
    end;

    if (CMKLineValue(p_ValueArray.m_Items[p_Index]).m_Value[m_OverLine] <> NOT_VALUE) then
      f_PosValue.m_Value := CMKLineValue(p_ValueArray.m_Items[p_Index]).m_Value[m_OverLine]
    else
      f_PosValue.m_Value := 0;

    if (CMKLineValue(p_ValueArray.m_Items[p_Index]).m_Value[m_OverLine] <> NOT_VALUE) then
      f_PosValue.m_Effect := true
    else
      f_PosValue.m_Effect := false;

    f_PosValue.m_Color := p_ValueArray.m_LineColors[m_OverLine];
    f_PosValue.m_Precision := p_ValueArray.m_Precision;
    Values.Add(f_PosValue);
  end;
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.GetHitTestX1(p_PosX: Double; p_Width: Double): Double;
begin
  Result := GetRealX(p_PosX - p_Width, m_MaxMin);
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.GetHitTestX2(p_PosX: Double; p_Width: Double): Double;
begin
  Result := GetRealX(p_PosX + p_Width, m_MaxMin);
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.GetEnableTracePannel(f_PosInfo: CMKPosInfo): Boolean;
var
  f_Index, f_Object, f_Line: Integer;
  f_ValueArray: CMKLineValueSeries;
  f_Y0, f_Y1, f_Y2, f_OpenCloseWidth: Integer;
  f_DX1, f_DX2: Integer;
  f_DY1, f_DY2: Double;
  f_DXSize: Integer;
  f_Enabled: Boolean;
  f_Value: Integer;
  f_Hi, f_Low: Double;
  f_SIndex0, f_SIndex1, f_SIndex2: Integer;
  f_Signal: Integer;
  f_SignalEnter: Boolean;

  f_LineValue: CMKLineValue;

  f_x: Double;
  f_Y: Double;

begin
  f_Enabled := false;
  f_SignalEnter := false;
  if ((f_PosInfo.m_ValueX < 0) or (f_PosInfo.m_ValueX >= m_ChartDataSeries.m_Items.Count)) then
  begin
    Result := false;
    exit;
  end;

  f_Hi := 0;
  f_Low := 0;
  f_OpenCloseWidth := Math.floor((GetScreenX(m_MaxMin.m_XMax, m_MaxMin) - GetScreenX(m_MaxMin.m_XMin, m_MaxMin)) /
      (m_MaxMin.m_XMax - m_MaxMin.m_XMin + 1));
  if (f_OpenCloseWidth <= 2) then
    f_OpenCloseWidth := 2;

  f_DX1 := Math.floor(GetHitTestX1(f_PosInfo.m_WindowX, 2));
  f_DX2 := Math.floor(GetHitTestX2(f_PosInfo.m_WindowX, 2));
  f_DXSize := Math.floor(f_DX2 - f_DX1 + 1);
  for f_Object := 0 to m_ObjectCollection.Count - 1 do
  begin
    f_ValueArray := CMKLineValueSeries(m_ObjectCollection.Items[f_Object]);
    if (f_ValueArray.m_Type = CMKConst.LINESERIES_PRICE) then
    begin
      f_ValueArray.HiLoPrice(f_DXSize, f_ValueArray, CMKConst.PRICE_HIGH, CMKConst.PRICE_LOW, f_DX2, f_Hi, f_Low);
      f_DY1 := f_Hi;
      f_DY2 := f_Low;

      if (NOT_VALUE <> f_DY1) and (NOT_VALUE <> f_DY2) then
      begin
        f_Y1 := GetScreenY(f_DY1, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[0]]);
        f_Y2 := GetScreenY(f_DY2, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[0]]);
        if ((f_Y1 - 1 <= f_PosInfo.m_WindowY) and (f_PosInfo.m_WindowY <= f_Y2 + 1)) then
        begin
          f_Enabled := true;
          m_OverObject := f_Object;
          m_OverLine := CMKConst.PRICE_CLOSE;
          break;
        end;
      end;
    end
    else if (f_ValueArray.m_Type = CMKConst.LINESERIES_VOLUME) then
    begin
      f_DY1 := f_ValueArray.HighestPrice(f_DXSize, f_ValueArray, 0, f_DX2);
      f_DY2 := 0;
      f_Y1 := GetScreenY(f_DY1, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[0]]);
      f_Y2 := GetScreenY(f_DY2, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[0]]);
      if ((f_Y1 - 1 < f_PosInfo.m_WindowY) and (f_PosInfo.m_WindowY < f_Y2)) then
      begin
        f_Enabled := true;
        m_OverObject := f_Object;
        m_OverLine := 0;
        break;
      end;
    end
    else
    begin
      for f_Line := 0 to f_ValueArray.m_LineCount - 1 do
      begin
        if (f_ValueArray.m_LineVisibles[f_Line]) then
        begin
          if ((f_ValueArray.m_LineTypes[f_Line] = 0) or (f_ValueArray.m_LineTypes[f_Line] = 2)) then
          begin
            f_ValueArray.HiLoPrice(f_DXSize, f_ValueArray, f_Line, f_Line, f_DX2, f_Hi, f_Low);
            f_DY1 := f_Hi;
            f_DY2 := f_Low;

            if (NOT_VALUE <> f_DY1) and (NOT_VALUE <> f_DY2) then
            begin
              f_Y1 := GetScreenY(f_DY1, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[f_Line]]);
              f_Y2 := GetScreenY(f_DY2, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[f_Line]]);
              if ((f_Y1 - 1 <= f_PosInfo.m_WindowY) and (f_PosInfo.m_WindowY <= f_Y2 + 1)) then
              begin
                f_Enabled := true;
                m_OverObject := f_Object;
                m_OverLine := f_Line;
                break;
              end;
            end;
          end
          else if (f_ValueArray.m_LineTypes[f_Line] = 1) then
          begin
            f_ValueArray.HiLoPrice(f_DXSize, f_ValueArray, f_Line, f_Line, f_DX2, f_Hi, f_Low);
            f_DY1 := f_Hi;
            f_DY2 := f_Low;

            if (NOT_VALUE <> f_DY1) and (NOT_VALUE <> f_DY2) then
            begin
              f_Y1 := GetScreenY(f_DY1, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[f_Line]]);
              f_Y2 := GetScreenY(f_DY2, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[f_Line]]);
              f_Y0 := GetScreenY(0, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[f_Line]]);
              if (((f_Y1 - 1 <= f_PosInfo.m_WindowY) and (f_PosInfo.m_WindowY <= f_Y0 + 1)) or
                  ((f_Y0 - 1 <= f_PosInfo.m_WindowY) and (f_PosInfo.m_WindowY <= f_Y2 + 1))) then
              begin
                f_Enabled := true;
                m_OverObject := f_Object;
                m_OverLine := f_Line;
                break;
              end;
            end;
          end
          else
          begin
            f_Enabled := not f_Enabled;
            // f_Enabled := not f_Enabled;
          end;
        end;
      end;
    end;

    if f_ValueArray.m_Signal then
    begin
      f_SignalEnter := true;
      f_SIndex0 := floor(f_PosInfo.m_ValueX);
      if (f_SIndex0 >= 0) AND (f_SIndex0 < f_ValueArray.m_Items.Count) then
      begin
        f_LineValue := f_ValueArray.m_Items[f_SIndex0];
        if f_LineValue.m_Value[0] <> NOT_VALUE then
        begin
          f_Signal := floor(f_LineValue.m_Value[0]);

          if (f_Signal = 1) OR (f_Signal = -1) then
          begin
            f_SIndex1 := 0;
            for f_Index := f_SIndex0 downto 0 do
            begin
              f_LineValue := f_ValueArray.m_Items[f_Index];
              if f_Signal <> f_LineValue.m_Value[0] then
              begin
                f_SIndex1 := f_Index + 1;
                break;
              end;
            end;
            f_SIndex2 := f_ValueArray.m_Items.Count - 1;
            for f_Index := f_SIndex0 to f_ValueArray.m_Items.Count - 1 do
            begin
              f_LineValue := f_ValueArray.m_Items[f_Index];
              if f_Signal <> f_LineValue.m_Value[0] then
              begin
                f_SIndex2 := f_Index - 1;
                break;
              end;
            end;

            CMKChartBlockManager(m_ChartBlockManager).SignalTrace(m_ChartIndex, f_Signal, f_SIndex1, f_SIndex2, f_SIndex0);

          end
          else
          begin
            CMKChartBlockManager(m_ChartBlockManager).ClearSignalLayer;
          end
        end
        else
        begin
          CMKChartBlockManager(m_ChartBlockManager).ClearSignalLayer;
        end;
      end
      else
      begin
        CMKChartBlockManager(m_ChartBlockManager).ClearSignalLayer;
      end;
    end;

    if (f_Enabled) then
      break;
  end;

  if (f_Enabled) and (m_OverObject >= 0) then
  begin
    if (not m_CaptureMouse) and (not m_DrawedOverLayer) then
    begin
      m_OverLayer.Update;
      m_DrawedOverLayer := true;
    end;

    f_ValueArray := CMKLineValueSeries(m_ObjectCollection.Items[m_OverObject]);
    f_x := Math.floor(f_PosInfo.m_ValueX);

    f_Y := CMKLineValue(f_ValueArray.m_Items[Math.floor(f_x)]).m_Value[m_OverLine];

    f_PosInfo.m_RealX := GetScreenXCenter(f_x, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[m_OverLine]]);
    f_PosInfo.m_RealY := GetScreenY(f_Y, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[m_OverLine]]);
  end
  else
  begin
    ClearActiveLayer();
  end;

  if not f_SignalEnter then
  begin
    CMKChartBlockManager(m_ChartBlockManager).ClearSignalLayer;
  end;

  f_PosInfo.m_OverLine := f_Enabled;
  f_PosInfo.m_ActiveObjectIndex := m_OverObject;
  f_PosInfo.m_ActiveLineIndex := m_OverLine;

  Result := f_Enabled;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.OnPaintOverLayer(Sender: TObject; Buffer: TBitmap32);
begin
  if (not m_CaptureMouse) and (m_DrawedOverLayer) then
  begin
    if (0 <= m_OverObject) and (m_OverObject < m_ObjectCollection.Count) then
    begin
      DrawActiveChart(Buffer, m_ObjectCollection[m_OverObject], m_OverLine);
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.AllowDrawing();
begin
  if Assigned(m_DrawManager) then
  begin
    m_DrawManager.Clear;
    m_DrawManager.Free;
    m_DrawManager := NIL;
  end;

  m_DrawManager := CMKAVDrawManager.Create();
  m_DrawManager.m_ChartBlock := Self;
  m_DrawManager.SetColorSet(m_ColorSet);
  m_DrawManager.SetLayer(m_DrawLayer);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.EndDrawObject();
begin
  if (m_DrawManager <> NIL) then
  begin
    m_DrawManager.EndDrawObject();
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.StartDrawObject(p_NobjectType: Integer);
begin
  if (m_DrawManager <> NIL) then
  begin
    m_DrawManager.StartDrawObject(p_NobjectType);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.SetDrawObjectColor(p_Color: TColor32);
begin
  if (m_DrawManager <> NIL) then
  begin
    m_DrawManager.SetDrawObjectColor(p_Color);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.StartDrawingCharObject(p_TextList: TStrings; p_font: TFont);
begin
  if (m_DrawManager <> NIL) then
  begin
    m_DrawManager.StartDrawingCharObject(p_TextList, p_font);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawLayOut();
begin
  if (m_DrawManager <> NIL) then
  begin
    m_DrawManager.LayOut();
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawObjectXDateToValue();
begin
  if (m_DrawManager <> NIL) then
    m_DrawManager.XDateToValue();
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawObjectXValueToDate();
begin
  if (m_DrawManager <> NIL) then
    m_DrawManager.XValueToDate();
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.GetTraceCaptionWidth(p_Bitmap: TBitmap32): Integer;
var
  f_Index: Integer;
  f_ValueArray: CMKLineValueSeries;
  f_LineX: Integer;
  f_LineY: Integer;
  f_FieldWidth: Integer;
  f_FieldHeight: Integer;
  f_LineCount: Integer;
  f_Label: String;
  PenColor: TColor32;
  f_Ymin, f_Ymax: Double;
  f_Value: Double;
  f_Width: Integer;
begin
  m_DrawCaptionCount := -1;
  f_Width := 0;
  f_LineX := 0;

  for f_Index := 0 to m_ObjectCollection.Count - 1 do
  begin
    f_ValueArray := m_ObjectCollection.Items[f_Index];
    if (f_ValueArray.m_Type = CMKConst.LINESERIES_PRICE) or (f_ValueArray.m_Type = CMKConst.LINESERIES_NET) then
    begin
      continue;
    end;

    for f_LineCount := 0 to f_ValueArray.m_LineCount - 1 do
    begin
      if (f_ValueArray.m_LineVisibles[f_LineCount]) and (f_ValueArray.m_LineLabelVisibles[f_LineCount]) and
          (f_ValueArray.m_LinePosValueVisibles[f_LineCount]) then
      begin
        // Title
        p_Bitmap.Font.Name := CMKColorSet.NUMBER2_FONT_FAMILY;
        p_Bitmap.Font.Size := CMKColorSet.NUMBER2_FONT_SMALLSIZE2;
        p_Bitmap.Font.Style := [];
        PenColor := m_ColorSet.m_Color[CMKColorSet.CAPTION_FIELDNAME_TEXT_COLOR];
        PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));

        if (f_ValueArray.m_Type = CMKConst.LINESERIES_MA) then
          f_Label := FloatToStr(f_ValueArray.m_Options[f_LineCount]) + 'MA:'
        else
          f_Label := f_ValueArray.m_LineNames[f_LineCount] + ':';

        f_FieldWidth := p_Bitmap.TextWidth(f_Label);
        f_FieldHeight := p_Bitmap.TextHeight(f_Label);
        f_LineX := f_LineX + (f_FieldWidth + 2);

        // Value
        p_Bitmap.Font.Name := CMKColorSet.NUMBER2_FONT_FAMILY;
        p_Bitmap.Font.Size := CMKColorSet.NUMBER2_FONT_SMALLSIZE2;
        p_Bitmap.Font.Style := [];
        PenColor := m_ColorSet.m_Color[f_ValueArray.m_LineColors[f_LineCount]];
        PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));
        f_Ymin := Abs(f_ValueArray.m_MaxMinTable[0].m_YMin);
        f_Ymax := f_ValueArray.m_MaxMinTable[0].m_YMax;
        if (f_Ymin > f_Ymax) then
          f_Ymax := f_Ymin;

        f_Label := TMKGlobal.NumberToString(f_Ymax * -1, f_ValueArray.m_Precision);

        f_FieldWidth := p_Bitmap.TextWidth(f_Label);
        f_FieldHeight := p_Bitmap.TextHeight(f_Label);

        f_LineX := f_LineX + (f_FieldWidth + 2);
      end;
    end;

    if (f_LineX + m_LastLabelX + 2 >= m_LegendRect.Right) then
    begin
      break;
    end;

    f_Width := f_LineX;
    m_DrawCaptionCount := f_Index;
  end;

  Inc(m_DrawCaptionCount);
  Result := f_Width + 6;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawCaption(p_Index: Integer);
begin
  if (p_Index < 0) then
    exit;
  if (0 < m_LabelArray.Count) then
  begin
    try
      DrawNormalCaption(m_LabelLayer.Bitmap, p_Index);
    finally

    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.DrawNormalCaption(p_Bitmap: TBitmap32; p_Index: Integer);
var
  f_Index: Integer;
  f_ValueArray: CMKLineValueSeries;
  f_LineX: Integer;
  f_LineY: Integer;
  f_FieldWidth: Integer;
  f_LineCount: Integer;
  f_Label: String;
  PenColor: TColor32;
  f_Ymin, f_Ymax: Double;
  f_Value: Double;
  f_ArrayCount: Integer;

  f_LabelData: PTLabelData;
begin
  f_LineX := m_LegendRect.Right - GetTraceCaptionWidth(p_Bitmap) - 12;
  f_LineY := m_LegendRect.Top + 4;

  f_ArrayCount := 0;

  for f_Index := 0 to m_ObjectCollection.Count - 1 do
  begin
    f_ValueArray := m_ObjectCollection.Items[f_Index];
    if (f_ValueArray.m_Type = CMKConst.LINESERIES_PRICE) or (f_ValueArray.m_Type = CMKConst.LINESERIES_NET) then
    begin
      continue;
    end;

    if (f_Index < m_DrawCaptionCount) then
    begin
      for f_LineCount := 0 to f_ValueArray.m_LineCount - 1 do
      begin
        if (f_ValueArray.m_LineVisibles[f_LineCount]) and (f_ValueArray.m_LineLabelVisibles[f_LineCount]) and
            (f_ValueArray.m_LinePosValueVisibles[f_LineCount]) then
        begin

          try
            if (CMKLineValue(f_ValueArray.m_Items[p_Index]).m_Value[f_LineCount] = NOT_VALUE) then
              f_Label := ' '
            else
            begin
              f_Value := CMKLineValue(f_ValueArray.m_Items[p_Index]).m_Value[f_LineCount];
              f_Label := TMKGlobal.NumberToString(f_Value, f_ValueArray.m_Precision);
            end;
          except
            f_Value := 0;
            f_Label := ' ';
          end;

          if f_ArrayCount < m_LabelArray.Count then
          begin
            f_LabelData := m_LabelArray.Items[f_ArrayCount];
            p_Bitmap.RenderText(f_LabelData^.nX, f_LabelData^.nY, f_LabelData^.strLabel, 0, f_LabelData^.fontColor);

            Inc(f_ArrayCount);
          end;

          if f_ArrayCount < m_LabelArray.Count then
          begin
            f_LabelData := m_LabelArray.Items[f_ArrayCount];
            f_LabelData^.strLabel := f_Label;
            p_Bitmap.RenderText(f_LabelData^.nX, f_LabelData^.nY, f_LabelData^.strLabel, 0, f_LabelData^.fontColor);
            Inc(f_ArrayCount);
          end;
        end;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.InsertCaption(p_X, p_Y, p_W, p_H: Integer; p_Value: String; p_FontColor: TColor);
var
  f_LabelData: PTLabelData;
begin
  New(f_LabelData);
  f_LabelData^.nX := p_X;
  f_LabelData^.nY := p_Y;
  f_LabelData^.nDx := p_W;
  f_LabelData^.nDy := p_H;
  f_LabelData^.strLabel := p_Value;
  f_LabelData^.fontColor := p_FontColor;

  m_LabelArray.Add(f_LabelData);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.ClearLabelArray();
var
  f_LabelData: PTLabelData;
begin
  while (0 < m_LabelArray.Count) do
  begin
    f_LabelData := PTLabelData(m_LabelArray.Items[0]);
    Dispose(f_LabelData);
    f_LabelData := NIL;

    m_LabelArray.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.InitCaption();
begin
  ClearLabelArray();

  InitNormalCaption(m_LabelLayer.Bitmap);
end;

// ---------------------------------------------------------------------------
procedure CMKChartBlock.InitNormalCaption(p_Bitmap: TBitmap32);
var
  f_Index: Integer;
  f_ValueArray: CMKLineValueSeries;
  f_LineX: Integer;
  f_LineY: Integer;
  f_FieldWidth: Integer;
  f_FieldHeight: Integer;
  f_LineCount: Integer;
  f_Label: String;
  PenColor: TColor32;
  f_Ymin, f_Ymax: Double;
  f_Value: Double;
begin
  f_LineX := m_LegendRect.Right - GetTraceCaptionWidth(p_Bitmap);
  f_LineY := m_LegendRect.Top + 4;

  for f_Index := 0 to m_ObjectCollection.Count - 1 do
  begin
    f_ValueArray := m_ObjectCollection.Items[f_Index];
    if (f_ValueArray.m_Type = CMKConst.LINESERIES_PRICE) or (f_ValueArray.m_Type = CMKConst.LINESERIES_NET) then
    begin
      continue;
    end;

    if (f_Index < m_DrawCaptionCount) then
    begin
      for f_LineCount := 0 to f_ValueArray.m_LineCount - 1 do
      begin
        if (f_ValueArray.m_LineVisibles[f_LineCount]) and (f_ValueArray.m_LineLabelVisibles[f_LineCount]) and
            (f_ValueArray.m_LinePosValueVisibles[f_LineCount]) then
        begin
          // Title
          p_Bitmap.Font.Name := CMKColorSet.NUMBER2_FONT_FAMILY;
          p_Bitmap.Font.Size := CMKColorSet.NUMBER2_FONT_SMALLSIZE2;
          p_Bitmap.Font.Style := [];
          PenColor := m_ColorSet.m_Color[CMKColorSet.CAPTION_FIELDNAME_TEXT_COLOR];
          PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));

          if (f_ValueArray.m_Type = CMKConst.LINESERIES_MA) then
            f_Label := FloatToStr(f_ValueArray.m_Options[f_LineCount]) + 'MA:'
          else
            f_Label := f_ValueArray.m_LineNames[f_LineCount] + ':';

          f_FieldWidth := p_Bitmap.TextWidth(f_Label);
          f_FieldHeight := p_Bitmap.TextHeight(f_Label);

          p_Bitmap.RenderText(f_LineX, f_LineY, f_Label, 0, PenColor);
          InsertCaption(f_LineX, f_LineY, f_FieldWidth, f_FieldHeight, f_Label, PenColor);
          f_LineX := f_LineX + (f_FieldWidth + 2);

          // Value
          p_Bitmap.Font.Name := CMKColorSet.NUMBER2_FONT_FAMILY;
          p_Bitmap.Font.Size := CMKColorSet.NUMBER2_FONT_SMALLSIZE2;
          p_Bitmap.Font.Style := [];
          PenColor := m_ColorSet.m_Color[f_ValueArray.m_LineColors[f_LineCount]];
          PenColor := SetAlpha(PenColor, TMKGlobal.GetAlphaValue(100));
          f_Ymin := Abs(f_ValueArray.m_MaxMinTable[0].m_YMin);
          f_Ymax := f_ValueArray.m_MaxMinTable[0].m_YMax;
          if (f_Ymin > f_Ymax) then
            f_Ymax := f_Ymin;

          f_Label := TMKGlobal.NumberToString(f_Ymax * -1, f_ValueArray.m_Precision);

          f_FieldWidth := p_Bitmap.TextWidth(f_Label);
          f_FieldHeight := p_Bitmap.TextHeight(f_Label);
          InsertCaption(f_LineX, f_LineY, f_FieldWidth, f_FieldHeight, f_Label, PenColor);
          f_LineX := f_LineX + (f_FieldWidth + 2);
        end;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.OnEventMouseDown(p_X: Integer; p_Y: Integer): Boolean;
begin
  if (m_DrawManager <> NIL) then
    Result := m_DrawManager.OnMouseDown(p_X, p_Y)
  else
    Result := false;
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.OnEventMouseUp(p_X: Integer; p_Y: Integer): Boolean;
begin
  if (m_DrawManager <> NIL) then
    Result := m_DrawManager.OnMouseUp(p_X, p_Y)
  else
    Result := false;
end;

// ---------------------------------------------------------------------------
function CMKChartBlock.OnEventMouseMove(p_X: Integer; p_Y: Integer): Boolean;
begin
  if (m_DrawManager <> NIL) then
    Result := m_DrawManager.OnMouseMove(p_X, p_Y)
  else
    Result := false;
end;

end.
