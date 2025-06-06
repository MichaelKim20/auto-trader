unit FNMatrixChartBlock;

interface

uses
  SysUtils, Classes, Types, Math, GR32, GR32_Polygons, Graphics, GR32_Layers,
  Dialogs,
  FNMatrixColorSet, MKStreamChartDataSeries, MKMaxMin, FNMatrixConst,
  FNMatrixLineValueSeries, MKChartData, MKLineValue,
  FNMatrixPosInfo, FNMatrixPosValue;

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

  CFNMatrixChartBlock = class(TObject)
  public
    m_ABSHeight: Integer;
    m_ABSYGridSize: Double;

    m_ChartBlockManager: TObject;
    m_ColorSet: CFNMatrixColorSet;
    m_ObjectArray: TList;
    m_ChartDataSeries: CMKStreamChartDataSeries;
    m_ChartIndex: Integer;

    m_Name: String;
    m_VisibleXLabel: Boolean;
    m_VisibleYLabel: Boolean;
    m_VisibleXGrid: Boolean;
    m_VisibleYGrid: Boolean;
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
    m_UnitType: Integer;
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

    m_DrawedOverLayer: Boolean;
    m_OverObject: Integer;
    m_OverLine: Integer;

    m_DrawCaptionCount: Integer;

  protected
    m_YGridPrecision: Integer;
    m_LastLabelX: Integer;
    m_YLogDiffer: Double;
    m_YLogUnit: Integer;
    m_DafaultBarWidth: Integer;
    m_DisplayTypeOfTrade: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Paint(p_Bitmap: TBitmap32);
    function GetScreenX(p_RX: Double; p_MaxMin: CMKMaxMin): Integer;
    function GetScreenXCenter(p_RX: Double; p_MaxMin: CMKMaxMin): Integer;
    function GetScreenY(p_RY: Double; p_MaxMin: CMKMaxMin; p_Scale: Integer = -1): Integer;
    function GetRealX(p_IX: Double; p_MaxMin: CMKMaxMin): Double;
    function GetRealY(p_IY: Double; p_MaxMin: CMKMaxMin): Double;
    procedure SetBound(p_Left: Integer; p_Top: Integer; p_Right: Integer; p_Bottom: Integer);
    procedure LayOut;
    procedure RangeEnlarge(p_XMin: Double = -1000000; p_XMax: Double = -1000000; p_Enlarge: Boolean = false);
    procedure FirstEnlarge;
    procedure FullEnlarge;
    procedure SetChartDataSeries(p_ChartDataSeries: CMKStreamChartDataSeries);

    procedure DrawAxis(p_Bitmap: TBitmap32);
    procedure DrawChartBoard(p_Bitmap: TBitmap32);
    procedure DrawChartBackground(p_Bitmap: TBitmap32);
    procedure DrawLineValueSeries_PriceLine(p_Bitmap: TBitmap32; p_LineSeries: CFNMatrixLineValueSeries; p_ActiveLine: Integer = -1);
    procedure DrawLineValueSeries_VolumeLine(p_Bitmap: TBitmap32; p_LineSeries: CFNMatrixLineValueSeries; p_ActiveLine: Integer = -1);
    procedure DrawLineValueSeries_Line(p_Bitmap: TBitmap32; p_LineSeries: CFNMatrixLineValueSeries; p_ActiveLine: Integer = -1);
    procedure DrawLineValueSeries_SignalLine(p_Bitmap: TBitmap32; p_LineSeries: CFNMatrixLineValueSeries; p_ActiveLine: Integer = -1);

    procedure DrawChart(p_Bitmap: TBitmap32);
    procedure DrawActiveChart(p_Bitmap: TBitmap32; p_LineSeries: CFNMatrixLineValueSeries; p_ActiveLine: Integer);

    procedure CalculateYGridSize;
    procedure CalculatePadding;

    function FindValueArray(p_Name: String): CFNMatrixLineValueSeries;
    procedure DeleteValueArray(p_Name: String);
    procedure ClearObject;

    procedure AddObject(p_LineSeries: CFNMatrixLineValueSeries);
    procedure ChangedLineMaxMin(p_LineSeries: CFNMatrixLineValueSeries);
    function GetYGridPrecision: Integer;
    function GetUnit: Integer;

    procedure SetScale(p_Scale: Integer);

    procedure DrawFillRectAngle(p_Bitmap: TBitmap32; p_Tick: Integer; p_LineColor: Integer; p_LineAlpha: Integer; p_FillColor: Integer; p_FillAlpha: Integer; p_X1: Integer; p_Y1: Integer;
      p_X2: Integer; p_Y2: Integer);

    procedure DrawYGrid(p_Bitmap: TBitmap32);
    procedure DrawYTicLabel(p_Bitmap: TBitmap32);
    procedure DrawXGrid(p_Bitmap: TBitmap32);
    procedure DrawXTicLabel(p_Bitmap: TBitmap32);
    procedure DrawLabel(p_Bitmap: TBitmap32);
    procedure DrawLastValue(p_Bitmap: TBitmap32);

    procedure Enlarge(p_Ratio: Integer);
    procedure EnlargeValue(p_Value: Integer);
    function GetEnlargeInfo(p_Ratio: Integer): CMKMaxMin;

    procedure OnMouseDown(p_X: Integer; p_Y: Integer);
    procedure OnMouseUp(p_X: Integer; p_Y: Integer);
    procedure OnMouseMoveOnAnytime(p_X: Integer; p_Y: Integer);
    procedure OnMouseMoveSometime(p_X: Integer; p_Y: Integer; p_Outer: Boolean = false);
    function GetScreenYGridPrecision: Integer;
    procedure ClearActiveLayer;
    procedure DrawTrace(p_TRInfo: CFNMatrixPosInfo);
    procedure DrawTrace2(p_ChartIndex: Integer; p_ValueX: Double; p_ValueY: Double);

    procedure GetPosValue(p_Index: Integer; Values: TList);
    function GetHitTestX1(p_PosX: Double; p_Width: Double): Double;
    function GetHitTestX2(p_PosX: Double; p_Width: Double): Double;
    function GetEnableTracePannel(p_PosInfo: CFNMatrixPosInfo): Boolean;

    procedure OnPaintOverLayer(Sender: TObject; Buffer: TBitmap32);

    procedure InitCaption;
    procedure InitNormalCaption(p_Bitmap: TBitmap32);
    function GetTraceCaptionWidth(p_Bitmap: TBitmap32): Integer;
    procedure DrawCaption(p_Index: Integer);
    procedure DrawNormalCaption(p_Bitmap: TBitmap32; p_Index: Integer);
    procedure InsertCaption(p_X, p_Y, p_W, p_H: Integer; p_Value: String; p_FontColor: TColor);
    procedure ClearLabelArray;

    procedure DrawSignalTrace(p_Signal: Integer; p_Start: Integer; p_End: Integer);
    procedure SetDisplayTypeOfTrade(p_Value: Integer);
  end;

implementation

uses
  FNGlobal, FNMatrixChartDefine, FNMatrixChartBlockManager;

// ---------------------------------------------------------------------------
constructor CFNMatrixChartBlock.Create;
begin
  inherited Create;
  m_DafaultBarWidth := 4;
  m_ABSHeight := 0;
  m_ABSYGridSize := 0;

  m_ObjectArray := TList.Create;
  m_ChartIndex := 0;
  m_XSize := 0.0;
  m_PaddingTop := 18;
  m_PaddingBottom := 2;
  m_PaddingLeft := 0;
  m_PaddingRight := 3;
  m_YGridSize := 0;
  m_Unit := 1;

  m_VisibleXLabel := true;
  m_VisibleYLabel := true;
  m_VisibleXGrid := true;
  m_VisibleYGrid := true;

  m_AbsMaxMin := CMKMaxMin.Create;
  m_MaxMin := CMKMaxMin.Create;
  m_YGridPrecision := 0;
  m_Scale := 0;

  m_DrawedOverLayer := false;
  m_OverObject := -1;
  m_OverLine := -1;

  m_TraceLayer := NIL;
  m_LabelArray := TList.Create;
  m_DisplayTypeOfTrade := 0;
end;

// ---------------------------------------------------------------------------
destructor CFNMatrixChartBlock.Destroy;
begin
  if Assigned(m_ObjectArray) then
  Begin
    m_ObjectArray.Free;
    m_ObjectArray := NIL;
  End;

  if Assigned(m_AbsMaxMin) then
  begin
    m_AbsMaxMin.Free;
    m_AbsMaxMin := NIL;
  end;

  if Assigned(m_MaxMin) then
  begin
    m_MaxMin.Free;
    m_MaxMin := NIL;
  end;

  if Assigned(m_LabelArray) then
  begin
    ClearLabelArray;

    m_LabelArray.Free;
    m_LabelArray := NIL;
  end;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.Clear;
begin
  ClearLabelArray;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.Paint(p_Bitmap: TBitmap32);
begin
  if (m_ColorSet = NIL) then
    exit;

  try
    if (not Assigned(m_ChartDataSeries)) OR (m_ChartDataSeries.m_Items.Count <= 0) then
    begin
      DrawChartBoard(p_Bitmap);
      DrawChartBackground(p_Bitmap);
      DrawAxis(p_Bitmap);
    end
    else
    begin
      CalculatePadding;
      CalculateYGridSize;

      DrawChartBoard(p_Bitmap);
      DrawChartBackground(p_Bitmap);
      DrawXGrid(p_Bitmap);

      DrawYGrid(p_Bitmap);

      p_Bitmap.ResetClipRect;
      p_Bitmap.ClipRect := m_AxisRect;

      DrawChart(p_Bitmap);

      p_Bitmap.ResetClipRect;
      p_Bitmap.ClipRect := m_BoundRect;

      DrawLabel(p_Bitmap);
      DrawAxis(p_Bitmap);
      DrawYTicLabel(p_Bitmap);
      DrawXTicLabel(p_Bitmap);

      DrawLastValue(p_Bitmap);
    end;
  except
  end;
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlock.GetScreenX(p_RX: Double; p_MaxMin: CMKMaxMin): Integer;
begin
  if (p_MaxMin.m_XMax = p_MaxMin.m_XMin) then
    Result := 0
  else
    Result := Math.floor(TFNGlobal.RectToWidth(m_AxisRect) * (p_RX - p_MaxMin.m_XMin) / (p_MaxMin.m_XMax - p_MaxMin.m_XMin + 1) + m_AxisRect.left);
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlock.GetScreenXCenter(p_RX: Double; p_MaxMin: CMKMaxMin): Integer;
begin
  if (p_MaxMin.m_XMax = p_MaxMin.m_XMin) then
    Result := 0
  else
    Result := GetScreenX(p_RX + 0.5, p_MaxMin);
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlock.GetScreenY(p_RY: Double; p_MaxMin: CMKMaxMin; p_Scale: Integer = -1): Integer;
var
  f_AxisHeight: Integer;
  f_LnY, f_LnYMax, f_LnYMin: Double;
  f_Value: Double;
  f_RHeight: Double;
  f_VHeight: Double;
begin
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
        f_AxisHeight := TFNGlobal.RectToHeight(m_AxisRect) - (m_PaddingTop + m_PaddingBottom);
        Result := Math.floor((m_AxisRect.bottom) - m_PaddingBottom - (f_AxisHeight) * (f_LnY - f_LnYMin) / (f_LnYMax - f_LnYMin));
        exit;
      end;
    end
    else
    begin
      f_AxisHeight := TFNGlobal.RectToHeight(m_AxisRect) - (m_PaddingTop + m_PaddingBottom);
      f_RHeight := p_RY - p_MaxMin.m_YMin;
      f_VHeight := p_MaxMin.m_YMax - p_MaxMin.m_YMin;
      if SameValue(f_VHeight, 0, 0.0001) then
      begin
        Result := 0;
        exit;
      end
      else
      begin
        try
          Result := Math.floor((m_AxisRect.bottom) - m_PaddingBottom - (f_AxisHeight) * (f_RHeight) / (f_VHeight));
        except
          Result := 0;
        end;
        exit;
      end;
    end;
  except
  end;
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlock.GetRealX(p_IX: Double; p_MaxMin: CMKMaxMin): Double;
var
  f_DX: Double;
begin
  if (TFNGlobal.RectToWidth(m_AxisRect) = 0) then
    f_DX := 0
  else
    f_DX := (((p_IX - m_AxisRect.left) * (p_MaxMin.m_XMax - p_MaxMin.m_XMin + 1) / TFNGlobal.RectToWidth(m_AxisRect)) + p_MaxMin.m_XMin);

  if (f_DX < p_MaxMin.m_XMin) then
    f_DX := p_MaxMin.m_XMin;

  if (f_DX > p_MaxMin.m_XMax) then
    f_DX := p_MaxMin.m_XMax;

  Result := f_DX;
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlock.GetRealY(p_IY: Double; p_MaxMin: CMKMaxMin): Double;
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

    f_AxisHeight := TFNGlobal.RectToHeight(m_AxisRect) - (m_PaddingTop + m_PaddingBottom);
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
    f_AxisHeight := TFNGlobal.RectToHeight(m_AxisRect) - (m_PaddingTop + m_PaddingBottom);
    if (f_AxisHeight = 0) then
      f_DY := 0
    else
      f_DY := p_MaxMin.m_YMin + (m_AxisRect.bottom - m_PaddingBottom - p_IY) * (p_MaxMin.m_YMax - p_MaxMin.m_YMin) / (f_AxisHeight);

    if (f_DY < p_MaxMin.m_YMin) then
      f_DY := p_MaxMin.m_YMin;

    if (f_DY > p_MaxMin.m_YMax) then
      f_DY := p_MaxMin.m_YMax;

    Result := f_DY;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.SetBound(p_Left: Integer; p_Top: Integer; p_Right: Integer; p_Bottom: Integer);
begin
  m_BoundRect := TFNGlobal.Rect2(p_Left, p_Top, p_Right - p_Left, p_Bottom - p_Top);
  LayOut;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.LayOut;
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
  f_X2 := m_BoundRect.left + TFNGlobal.RectToWidth(m_BoundRect);
  f_Y2 := m_BoundRect.Top + TFNGlobal.RectToHeight(m_BoundRect);

  if (m_VisibleYLabel) then
    f_YLabelWidth := CFNMatrixConst.CHART_DRAW_YLABEL_WIDTH2
  else
    f_YLabelWidth := 0;

  m_LegendRect := TFNGlobal.Rect2(f_X1 + 1 + f_YLabelWidth, f_Y1 + 1, f_X2 - f_X1 - f_YLabelWidth * 2, CFNMatrixConst.CHART_DRAW_XLABEL_HEIGHT2);
  if (m_VisibleXLabel) then
  begin
    f_AxisTop := f_Y1;
    f_AxisHeight := f_Y2 - f_AxisTop - CFNMatrixConst.CHART_DRAW_XLABEL_HEIGHT2 - 2;
    m_AxisRect := TFNGlobal.Rect2(f_X1, f_AxisTop, f_X2 - f_X1 - f_YLabelWidth - 1, f_AxisHeight);
    m_XLabelRect := TFNGlobal.Rect2(f_X1, f_Y2 - CFNMatrixConst.CHART_DRAW_XLABEL_HEIGHT2, f_X2 - f_X1 - f_YLabelWidth, CFNMatrixConst.CHART_DRAW_XLABEL_HEIGHT2);
  end
  else
  begin
    f_AxisTop := f_Y1;
    f_AxisHeight := f_Y2 - f_AxisTop - 2;
    m_AxisRect := TFNGlobal.Rect2(f_X1, f_AxisTop, f_X2 - f_X1 - f_YLabelWidth - 1, f_AxisHeight);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.RangeEnlarge(p_XMin: Double = -1000000; p_XMax: Double = -1000000; p_Enlarge: Boolean = false);
var
  f_Line, f_Sx, f_Ex: Double;
  f_Object: Integer;
  f_Index: Integer;
  f_Size: Integer;
  f_LineSeries: CFNMatrixLineValueSeries;
  f_PriceValueArray: CFNMatrixLineValueSeries;
begin
  if (p_XMin = -1000000) then
    p_XMin := m_MaxMin.m_XMin;

  if (p_XMax = -1000000) then
    p_XMax := m_MaxMin.m_XMax;

  if (p_XMin = p_XMax) then
  begin
    m_XSize := Math.floor(TFNGlobal.RectToWidth(m_AxisRect) / m_DafaultBarWidth);
    p_XMax := Math.floor(m_AbsMaxMin.m_XMax + m_PaddingRight);
    p_XMin := Math.floor(p_XMax - m_XSize);
    m_XSize := Math.floor(p_XMax - p_XMin);
  end
  else
  begin
    p_XMax := Math.floor(p_XMax);
    p_XMin := Math.floor(p_XMin);
    m_XSize := Math.floor(p_XMax - p_XMin);
  end;

  if (p_XMax > Math.floor(m_AbsMaxMin.m_XMax + m_PaddingRight)) then
    p_XMax := Math.floor(m_AbsMaxMin.m_XMax + m_PaddingRight);

  m_XSize := Math.floor(p_XMax - p_XMin);

  f_Sx := p_XMin;
  f_Ex := p_XMax;
  m_MaxMin.m_YMax := -1.0E38;
  m_MaxMin.m_YMin := 1.0E38;
  m_MaxMin.m_XMin := p_XMin;
  m_MaxMin.m_XMax := p_XMax;
  f_Size := m_ObjectArray.Count;

  for f_Object := 0 to f_Size - 1 do
  begin
    f_LineSeries := CFNMatrixLineValueSeries(m_ObjectArray.Items[f_Object]);

    if (not f_LineSeries.m_Effect) then
      continue;

    f_LineSeries.GetLineMaxMin(Math.floor(f_Sx), Math.floor(f_Ex));

    if (m_MaxMin.m_YMax < f_LineSeries.m_MaxMinTable[0].m_YMax) then
      m_MaxMin.m_YMax := f_LineSeries.m_MaxMinTable[0].m_YMax;

    if (m_MaxMin.m_YMin > f_LineSeries.m_MaxMinTable[0].m_YMin) then
      m_MaxMin.m_YMin := f_LineSeries.m_MaxMinTable[0].m_YMin;
  end;

  for f_Object := 0 to f_Size - 1 do
  begin
    f_LineSeries := CFNMatrixLineValueSeries(m_ObjectArray.Items[f_Object]);
    if (not f_LineSeries.m_Effect) then
      continue;

    f_LineSeries.m_MaxMinTable[0].m_YMax := m_MaxMin.m_YMax;
    f_LineSeries.m_MaxMinTable[0].m_YMin := m_MaxMin.m_YMin;
  end;

  m_YLogDiffer := 0;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.Enlarge(p_Ratio: Integer);
var
  p_XMin, p_XMax, f_XMaxMin: Double;
  f_Max: Double;

  f_Size: Double;
  f_Other: Double;
begin
  if (m_ObjectArray.Count = 0) then
    exit;
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
    f_XMaxMin := Math.floor(TFNGlobal.RectToWidth(m_AxisRect) / m_DafaultBarWidth);
    p_XMax := Math.floor(m_MaxMin.m_XMax);
    p_XMin := Math.floor(p_XMax - f_XMaxMin);
  end;

  f_Max := m_AbsMaxMin.m_XMax + m_PaddingRight;
  if (p_XMax > f_Max) then
    p_XMax := f_Max;
  (*
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
  *)
  RangeEnlarge(p_XMin, p_XMax, false);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.EnlargeValue(p_Value: Integer);
var
  p_XMin, p_XMax, f_XMaxMin: Double;
  f_Max: Double;

  f_Size: Double;
  f_Other: Double;
begin
  if (m_ObjectArray.Count = 0) then
    exit;

  f_XMaxMin := Math.floor(TFNGlobal.RectToWidth(m_AxisRect) / p_Value);
  p_XMax := Math.floor(m_AbsMaxMin.m_XMax + m_PaddingRight);
  p_XMin := Math.floor(p_XMax - f_XMaxMin);

  f_Max := m_AbsMaxMin.m_XMax + m_PaddingRight;
  if (p_XMax > f_Max) then
    p_XMax := f_Max;

  (*
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
  *)
  RangeEnlarge(p_XMin, p_XMax, false);
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlock.GetEnlargeInfo(p_Ratio: Integer): CMKMaxMin;
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
    f_XMaxMin := Math.floor(TFNGlobal.RectToWidth(m_AxisRect) / m_DafaultBarWidth);
    p_XMax := Math.floor(m_MaxMin.m_XMax);
    p_XMin := Math.floor(p_XMax - f_XMaxMin);
  end;

  f_Max := m_AbsMaxMin.m_XMax + m_PaddingRight;
  if (p_XMax > f_Max) then
    p_XMax := f_Max;
  (*
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
  *)
  f_MaxMin := CMKMaxMin.Create;
  f_MaxMin.m_XMin := p_XMin;
  f_MaxMin.m_XMax := p_XMax;

  Result := f_MaxMin;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.FirstEnlarge;
var
  p_XMin: Double;
  p_XMax: Double;
  f_XMaxMin: Integer;
  f_Max: Double;
  f_Size: Double;
  f_Other: Double;
begin
  if (m_ObjectArray.Count = 0) then
    exit;

  f_XMaxMin := Math.floor(TFNGlobal.RectToWidth(m_AxisRect) / m_DafaultBarWidth);
  p_XMax := Math.floor(m_AbsMaxMin.m_XMax + m_PaddingRight);
  p_XMin := Math.floor(p_XMax - f_XMaxMin - (m_PaddingRight));

  f_Max := m_AbsMaxMin.m_XMax + m_PaddingRight;
  if (p_XMax > f_Max) then
    p_XMax := f_Max;

  RangeEnlarge(p_XMin, p_XMax, false);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.FullEnlarge;
var
  f_XMin: Double;
  f_XMax: Double;
begin
  if (m_ObjectArray.Count = 0) then
    exit;

  f_XMax := Math.floor(m_AbsMaxMin.m_XMax + m_PaddingRight);
  f_XMin := 0;

  if f_XMax - f_XMin > 2400 then
    f_XMin := f_XMax - 2400;

  RangeEnlarge(f_XMin, f_XMax, false);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.SetChartDataSeries(p_ChartDataSeries: CMKStreamChartDataSeries);
begin
  m_ChartDataSeries := p_ChartDataSeries;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.SetDisplayTypeOfTrade(p_Value: Integer);
begin
  m_DisplayTypeOfTrade := p_Value;
end;

// ---------------------------------------------------------------------------
// 축을 그린다.
procedure CFNMatrixChartBlock.DrawAxis(p_Bitmap: TBitmap32);
var
  PenColor: TColor32;
begin
  PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.AXIS_COLOR];
  PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));
  p_Bitmap.PenColor := PenColor;

  p_Bitmap.MoveTo(m_AxisRect.left, m_AxisRect.Top);
  p_Bitmap.LineToAS(m_AxisRect.Right, m_AxisRect.Top);
  p_Bitmap.LineToAS(m_AxisRect.Right, m_AxisRect.bottom - 1);
  p_Bitmap.LineToAS(m_AxisRect.left, m_AxisRect.bottom - 1);
  p_Bitmap.LineToAS(m_AxisRect.left, m_AxisRect.Top - 1);
end;

// ---------------------------------------------------------------------------
// 전체 배경을 그린다.
procedure CFNMatrixChartBlock.DrawChartBoard(p_Bitmap: TBitmap32);
var
  PenColor: TColor32;
  FillColor: TColor32;
begin
  PenColor := clBlack32;
  PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(0));

  FillColor := m_ColorSet.m_Color[CFNMatrixColorSet.CHART_BACKGROUND_COLOR];

  FillColor := SetAlpha(FillColor, TFNGlobal.GetAlphaValue(100));

  p_Bitmap.FillRectTS(m_BoundRect, FillColor);
  p_Bitmap.FrameRectTS(m_BoundRect, PenColor);
end;

// ---------------------------------------------------------------------------
// 축안쪽의 배경을 그린다.
procedure CFNMatrixChartBlock.DrawChartBackground(p_Bitmap: TBitmap32);
var
  PenColor: TColor32;
  FillColor: TColor32;
begin
  PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.CHART_COLOR];
  PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(0));

  FillColor := m_ColorSet.m_Color[CFNMatrixColorSet.CHART_COLOR];
  FillColor := SetAlpha(FillColor, TFNGlobal.GetAlphaValue(100));

  p_Bitmap.FillRectTS(m_AxisRect, FillColor);
  p_Bitmap.FrameRectTS(m_AxisRect, PenColor);
end;

// ---------------------------------------------------------------------------
// 가격라인시리즈를 그린다.
procedure CFNMatrixChartBlock.DrawLineValueSeries_PriceLine(p_Bitmap: TBitmap32; p_LineSeries: CFNMatrixLineValueSeries; p_ActiveLine: Integer = -1);
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

  if (f_Ex > p_LineSeries.m_Items.Count - 1) then
    f_Ex := p_LineSeries.m_Items.Count - 1;

  f_OpenCloseWidth := Round((GetScreenX(m_MaxMin.m_XMax, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]) - GetScreenX(m_MaxMin.m_XMin,
    p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]])) / (m_MaxMin.m_XMax - m_MaxMin.m_XMin + 1));

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

  // 갠들 차트
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
        f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_UP_FILLED_COLOR];
        f_Color2 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_UP_LINE_COLOR];
      end
      else if (f_ClosePrice < f_OpenPrice) then
      begin
        f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_DN_FILLED_COLOR];
        f_Color2 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_DN_LINE_COLOR];
      end
      else if (f_ClosePrice >= f_ClosePrice01) then
      begin
        f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_UP_FILLED_COLOR];
        f_Color2 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_UP_LINE_COLOR];
      end
      else
      begin
        f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_DN_FILLED_COLOR];
        f_Color2 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_DN_LINE_COLOR];
      end;

      f_Alpha := m_ColorSet.m_Alpha[CFNMatrixColorSet.ALPHA_PRICE_LINE];
      if (p_ActiveLine >= 0) then
        f_Alpha := TFNGlobal.GetAlphaValue(100);
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

        PenColor := f_Color2;
        PenColor := SetAlpha(PenColor, f_Alpha);

        FillColor := f_Color1;
        FillColor := SetAlpha(FillColor, f_Alpha);

        drRc := TFNGlobal.GetRectToRealRect(f_X2, f_YHigh, f_X2 + f_HighLowWidth, f_YHigh + f_YOCHeight - f_YHigh);
        p_Bitmap.FillRectTS(drRc, FillColor);
        p_Bitmap.FrameRectTS(drRc, PenColor);

        drRc := TFNGlobal.GetRectToRealRect(f_X2, f_YOCLowest, f_X2 + f_HighLowWidth, f_YOCLowest + f_YLow - f_YOCLowest);
        p_Bitmap.FillRectTS(drRc, FillColor);
        p_Bitmap.FrameRectTS(drRc, PenColor);

        drRc := TFNGlobal.GetRectToRealRect(f_X1, f_YOCHeight, f_X1 + f_OpenCloseWidth, f_YOCHeight + f_YOCLowest - f_YOCHeight);
        p_Bitmap.FillRectTS(drRc, FillColor);
        p_Bitmap.FrameRectTS(drRc, PenColor);
      end;
    end;
  end
  else if (f_ChartType = 1) then // 바차트
  begin

    f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_COLOR];
    f_Alpha := m_ColorSet.m_Alpha[CFNMatrixColorSet.ALPHA_PRICE_LINE];
    if (p_ActiveLine >= 0) then
      f_Alpha := TFNGlobal.GetAlphaValue(100); // 1.0;

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
  else if (f_ChartType = 2) then // 선차트
  begin
    f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_COLOR];
    f_Alpha := m_ColorSet.m_Alpha[CFNMatrixColorSet.ALPHA_PRICE_LINE];
    if (p_ActiveLine >= 0) then
      f_Alpha := TFNGlobal.GetAlphaValue(100); // 1.0;

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
procedure CFNMatrixChartBlock.DrawLineValueSeries_VolumeLine(p_Bitmap: TBitmap32; p_LineSeries: CFNMatrixLineValueSeries; p_ActiveLine: Integer = -1);
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

  if (f_Ex > p_LineSeries.m_Items.Count - 1) then
    f_Ex := p_LineSeries.m_Items.Count - 1;

  f_OpenCloseWidth := Round((GetScreenX(m_MaxMin.m_XMax, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]) - GetScreenX(m_MaxMin.m_XMin,
    p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]])) / (m_MaxMin.m_XMax - m_MaxMin.m_XMin + 1));
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
    f_Y2 := GetScreenY(CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[0], p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
    f_Xc := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
    f_X1 := f_Xc - Math.floor(f_OpenCloseWidth / 2);
    f_X2 := f_X1 + f_OpenCloseWidth;

    f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.VOLUME_FILLED_COLOR];
    f_Color2 := m_ColorSet.m_Color[CFNMatrixColorSet.VOLUME_LINE_COLOR];

    f_Alpha := m_ColorSet.m_Alpha[CFNMatrixColorSet.ALPHA_VOLUME_LINE];

    if (p_ActiveLine >= 0) then
      f_Alpha := TFNGlobal.GetAlphaValue(100); // 1.0;

    PenColor := f_Color1;
    PenColor := SetAlpha(PenColor, f_Alpha);

    FillColor := f_Color1;
    FillColor := SetAlpha(FillColor, TFNGlobal.GetAlphaValue(100));

    p_Bitmap.FillRectTS(f_X1, f_Y2, f_X1 + (f_X2 - f_X1 - 1), f_Y2 + (f_Y1 - f_Y2 - 1), FillColor);
    p_Bitmap.FrameRectTS(f_X1, f_Y2, f_X1 + (f_X2 - f_X1), f_Y2 + (f_Y1 - f_Y2), PenColor);

    PenColor := f_Color2;
    PenColor := SetAlpha(PenColor, f_Alpha);
    p_Bitmap.PenColor := PenColor;

    p_Bitmap.MoveTo(f_X1, f_Y2);
    p_Bitmap.LineToAS(f_X1, f_Y1);
  end;

  for f_Index := f_Sx to f_Ex do
  begin
    f_Y1 := GetScreenY(0, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
    f_Y2 := GetScreenY(CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[0], p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
    f_Xc := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
    f_X1 := f_Xc - Math.floor(f_OpenCloseWidth / 2);
    f_X2 := f_X1 + f_OpenCloseWidth;

    if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[0] >= 1000) then
    begin

      f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_UP_FILLED_COLOR];
      f_Color2 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_UP_LINE_COLOR];

      f_Alpha := m_ColorSet.m_Alpha[CFNMatrixColorSet.ALPHA_VOLUME_LINE];

      if (p_ActiveLine >= 0) then
        f_Alpha := TFNGlobal.GetAlphaValue(100); // 1.0;

      PenColor := f_Color1;
      PenColor := SetAlpha(PenColor, f_Alpha);

      FillColor := f_Color1;
      FillColor := SetAlpha(FillColor, TFNGlobal.GetAlphaValue(100));

      p_Bitmap.FillRectTS(f_X1, f_Y2, f_X1 + (f_X2 - f_X1 - 1 + 2), f_Y2 + (f_Y1 - f_Y2 - 1), FillColor);
      p_Bitmap.FrameRectTS(f_X1, f_Y2, f_X1 + (f_X2 - f_X1 + 2), f_Y2 + (f_Y1 - f_Y2), PenColor);

      PenColor := f_Color2;
      PenColor := SetAlpha(PenColor, f_Alpha);
      p_Bitmap.PenColor := PenColor;
    end;
  end;

  for f_Index := f_Sx to f_Ex do
  begin
    f_Y1 := GetScreenY(0, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
    f_Y2 := GetScreenY(CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[0], p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
    f_Xc := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
    f_X1 := f_Xc - Math.floor(f_OpenCloseWidth / 2);
    f_X2 := f_X1 + f_OpenCloseWidth;

    if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[0] >= 618) and (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[0] < 1000) then
    begin

      f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_DN_FILLED_COLOR];
      f_Color2 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_DN_LINE_COLOR];

      f_Alpha := m_ColorSet.m_Alpha[CFNMatrixColorSet.ALPHA_VOLUME_LINE];

      if (p_ActiveLine >= 0) then
        f_Alpha := TFNGlobal.GetAlphaValue(100); // 1.0;

      PenColor := f_Color1;
      PenColor := SetAlpha(PenColor, f_Alpha);

      FillColor := f_Color1;
      FillColor := SetAlpha(FillColor, TFNGlobal.GetAlphaValue(100));

      p_Bitmap.FillRectTS(f_X1, f_Y2, f_X1 + (f_X2 - f_X1 - 1 + 2), f_Y2 + (f_Y1 - f_Y2 - 1), FillColor);
      p_Bitmap.FrameRectTS(f_X1, f_Y2, f_X1 + (f_X2 - f_X1 + 2), f_Y2 + (f_Y1 - f_Y2), PenColor);

      PenColor := f_Color2;
      PenColor := SetAlpha(PenColor, f_Alpha);
      p_Bitmap.PenColor := PenColor;
    end;
  end;

end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.DrawLineValueSeries_SignalLine(p_Bitmap: TBitmap32; p_LineSeries: CFNMatrixLineValueSeries; p_ActiveLine: Integer);
var
  f_Index, f_Xc, f_X1, f_X2, f_Y1, f_Y2, f_Step: Integer;
  f_Line: Integer;
  f_Sx, f_Ex: Integer;
  f_Color1, f_Color2: Integer;
  f_Alpha: Integer;
  f_LineColor: Integer;
  f_OpenCloseWidth, f_HighLowWidth: Integer;

  f_Value: Double;
  f_OrginValue: Double;
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

  f_OpenCloseWidth := Round((GetScreenX(m_MaxMin.m_XMax, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]) - GetScreenX(m_MaxMin.m_XMin,
    p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]])) / (m_MaxMin.m_XMax - m_MaxMin.m_XMin + 1));
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

        f_Alpha := TFNGlobal.GetAlphaValue(10);

        if ((m_DisplayTypeOfTrade = 0) or (m_DisplayTypeOfTrade = 1)) AND (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] > 0) then
        begin
          f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_UP_FILLED_COLOR];
        end
        else if ((m_DisplayTypeOfTrade = 0) or (m_DisplayTypeOfTrade = 2)) AND (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] < 0) then
        begin
          f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_DN_FILLED_COLOR];
        end
        else
        begin
          f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.CHART_COLOR];
        end;

        FillColor := SetAlpha(f_Color1, f_Alpha);
        drRc := TFNGlobal.GetRectToRealRect(f_X1, f_Y1, f_X2, f_Y2);
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

        f_Alpha := TFNGlobal.GetAlphaValue(80);
        if ((m_DisplayTypeOfTrade = 0) or (m_DisplayTypeOfTrade = 1)) AND (f_LineValue0.m_Value[f_Line] > 0) then
        begin
          f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_UP_FILLED_COLOR];
        end
        else if ((m_DisplayTypeOfTrade = 0) or (m_DisplayTypeOfTrade = 2)) AND (f_LineValue0.m_Value[f_Line] < 0) then
        begin
          f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_DN_FILLED_COLOR];
        end
        else
        begin
          f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.CHART_COLOR];
          f_Alpha := TFNGlobal.GetAlphaValue(0);
        end;

        FillColor := SetAlpha(f_Color1, f_Alpha);

        drRc := TFNGlobal.GetRectToRealRect(f_X1, f_Y1, f_X2, f_Y2);
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

      if (p_LineSeries.m_Type = CFNMatrixConst.LINESERIES_CLOSE) then
        f_Alpha := m_ColorSet.m_Alpha[CFNMatrixColorSet.ALPHA_PRICE_LINE]
      else if (p_LineSeries.m_Type = CFNMatrixConst.LINESERIES_MA) then
        f_Alpha := m_ColorSet.m_Alpha[CFNMatrixColorSet.ALPHA_MA_LINE]
      else
        f_Alpha := m_ColorSet.m_Alpha[p_LineSeries.m_LineAlphas[f_Line]];

      f_LineColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
      if (p_ActiveLine = f_Line) then
        f_Alpha := TFNGlobal.GetAlphaValue(100);
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
  if p_LineSeries.m_Type = CFNMatrixConst.LINESERIES_MATRIX then
  begin
    PenColor := $003030E0;
    PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(85));
    p_Bitmap.PenColor := PenColor;
    f_Y1 := GetScreenY(0, p_LineSeries.m_MaxMinTable[0]);
    f_Y2 := GetScreenY(0, p_LineSeries.m_MaxMinTable[0]);
    f_X1 := m_AxisRect.left;
    f_X2 := m_AxisRect.Right;
    p_Bitmap.MoveTo(f_X1, f_Y1);
    p_Bitmap.LineToAS(f_X2, f_Y2);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.DrawLineValueSeries_Line(p_Bitmap: TBitmap32; p_LineSeries: CFNMatrixLineValueSeries; p_ActiveLine: Integer = -1);
var
  f_Index, f_Xc, f_X1, f_X2, f_Y1, f_Y2, f_Step: Integer;
  f_Line: Integer;
  f_Sx, f_Ex: Integer;
  f_Color1, f_Color2: Integer;
  f_Alpha: Integer;
  f_LineColor: Integer;
  f_OpenCloseWidth, f_HighLowWidth: Integer;

  f_Value: Double;
  f_OrginValue: Double;
  f_FirstValue: Boolean;

  PenColor: TColor32;
  FillColor: TColor32;

  drRc: TRect;
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

  f_OpenCloseWidth := Round((GetScreenX(m_MaxMin.m_XMax, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]) - GetScreenX(m_MaxMin.m_XMin,
    p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]])) / (m_MaxMin.m_XMax - m_MaxMin.m_XMin + 1));
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

    // 라인
    if (p_LineSeries.m_LineTypes[f_Line] = 0) then
    begin

      if (p_LineSeries.m_LineWidths[f_Line] > 0) then
      begin
        PenColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
        PenColor := SetAlpha(PenColor, m_ColorSet.m_Alpha[CFNMatrixColorSet.ALPHA_LIGHT_LINE]);
        p_Bitmap.Canvas.Pen.Width := p_LineSeries.m_LineWidths[f_Line];

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
          begin
            p_Bitmap.LineToAS(f_X2, f_Y2);
          end;

          f_X1 := f_X2;
          f_Y1 := f_Y2;
        end;
      end;

      if (p_LineSeries.m_Type = CFNMatrixConst.LINESERIES_CLOSE) then
        f_Alpha := m_ColorSet.m_Alpha[CFNMatrixColorSet.ALPHA_PRICE_LINE]
      else if (p_LineSeries.m_Type = CFNMatrixConst.LINESERIES_MA) then
        f_Alpha := m_ColorSet.m_Alpha[CFNMatrixColorSet.ALPHA_MA_LINE]
      else
        f_Alpha := m_ColorSet.m_Alpha[p_LineSeries.m_LineAlphas[f_Line]];

      f_LineColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
      if (p_ActiveLine = f_Line) then
        f_Alpha := TFNGlobal.GetAlphaValue(100);

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
    else if (p_LineSeries.m_LineTypes[f_Line] = 1) then // 바
    begin
      for f_Index := f_Sx to f_Ex do
      begin
        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
          continue;

        f_Xc := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
        f_X1 := f_Xc - Math.floor(f_OpenCloseWidth / 2);
        f_X2 := f_X1 + f_OpenCloseWidth;

        if (m_MaxMin.m_YMin < 0) then
          f_Y1 := GetScreenY(0, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]])
        else
          f_Y1 := GetScreenY(p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]].m_YMin, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);

        f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

        f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);

        f_Alpha := m_ColorSet.m_Alpha[p_LineSeries.m_LineAlphas[f_Line]];
        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] > 0) then
        begin
          f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.OSC_UP_FILLED_COLOR];
          f_Color2 := m_ColorSet.m_Color[CFNMatrixColorSet.OSC_UP_FILLED_COLOR];
        end
        else
        begin
          f_Color1 := m_ColorSet.m_Color[CFNMatrixColorSet.OSC_DN_FILLED_COLOR];
          f_Color2 := m_ColorSet.m_Color[CFNMatrixColorSet.OSC_DN_FILLED_COLOR];
        end;

        f_LineColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
        if (p_ActiveLine = f_Line) then
          f_Alpha := TFNGlobal.GetAlphaValue(100);

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

        drRc := TFNGlobal.GetRectToRealRect(f_X1, f_Y1, f_X2 - 1, f_Y2);
        p_Bitmap.FillRectTS(drRc, FillColor);

      end;
    end
    else if (p_LineSeries.m_LineTypes[f_Line] = 2) then // 점
    begin
      f_Alpha := m_ColorSet.m_Alpha[p_LineSeries.m_LineAlphas[f_Line]];
      f_LineColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
      if (p_ActiveLine = f_Line) then
        f_Alpha := TFNGlobal.GetAlphaValue(100);

      PenColor := f_LineColor;
      PenColor := SetAlpha(PenColor, f_Alpha);
      p_Bitmap.PenColor := PenColor;

      for f_Index := f_Sx to f_Ex do
      begin
        if (CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line] = NOT_VALUE) then
          continue;

        f_Xc := GetScreenXCenter(f_Index, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[0]]);
        f_X1 := f_Xc - Math.floor(f_OpenCloseWidth / 2);
        f_X2 := f_X1 + f_OpenCloseWidth;
        f_Value := CMKLineValue(p_LineSeries.m_Items[f_Index]).m_Value[f_Line];

        f_Y2 := GetScreenY(f_Value, p_LineSeries.m_MaxMinTable[p_LineSeries.m_LineMaxMinIndexs[f_Line]]);

        FillColor := m_ColorSet.m_Color[p_LineSeries.m_LineColors[f_Line]];
        FillColor := SetAlpha(FillColor, f_Alpha);

        p_Bitmap.MoveTo(f_X1, f_Y2 - 1);
        p_Bitmap.LineToAS(f_X2 - 1, f_Y2 - 1);
        p_Bitmap.LineToAS(f_X2 - 1, f_Y2 + 1);
        p_Bitmap.LineToAS(f_X1, f_Y2 + 1);
        p_Bitmap.LineToAS(f_X1, f_Y2 - 1);

        drRc := TFNGlobal.GetRectToRealRect(f_X1, f_Y2 - 1, f_X2 - 1, f_Y2 + 1);
        p_Bitmap.FillRectTS(drRc, FillColor);

      end;
    end;
  end;

end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.CalculatePadding;
var
  f_Index: Integer;
  p_LineSeries: CFNMatrixLineValueSeries;
begin
  for f_Index := 0 to m_ObjectArray.Count - 1 do
  begin
    p_LineSeries := CFNMatrixLineValueSeries(m_ObjectArray.Items[f_Index]);
    if (p_LineSeries.m_Type = CFNMatrixConst.LINESERIES_PRICE) then
    begin
      m_PaddingTop := 18;
      m_PaddingBottom := 2;
    end
    else if (p_LineSeries.m_Type = CFNMatrixConst.LINESERIES_VOLUME) then
    begin
      m_PaddingTop := 18;
      m_PaddingBottom := 0;
    end;

    if p_LineSeries.m_Signal then
    begin
      m_PaddingTop := 18;
      m_PaddingBottom := 2;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.DrawChart(p_Bitmap: TBitmap32);
var
  f_Index: Integer;
  p_LineSeries: CFNMatrixLineValueSeries;
begin

  for f_Index := 0 to m_ObjectArray.Count - 1 do
  begin

    p_LineSeries := CFNMatrixLineValueSeries(m_ObjectArray.Items[f_Index]);
    if (p_LineSeries.m_Items.Count <= 0) then
      continue;

    if (p_LineSeries.m_Signal) then
    begin
      DrawLineValueSeries_SignalLine(p_Bitmap, p_LineSeries, -1);
    end
    else if (p_LineSeries.m_Type = CFNMatrixConst.LINESERIES_PRICE) then
      DrawLineValueSeries_PriceLine(p_Bitmap, p_LineSeries, -1)
    else if (p_LineSeries.m_Type = CFNMatrixConst.LINESERIES_VOLUME) then
      DrawLineValueSeries_VolumeLine(p_Bitmap, p_LineSeries, -1)
    else
      DrawLineValueSeries_Line(p_Bitmap, p_LineSeries, -1);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.DrawActiveChart(p_Bitmap: TBitmap32; p_LineSeries: CFNMatrixLineValueSeries; p_ActiveLine: Integer);
var
  f_Index: Integer;
begin
  if (p_LineSeries.m_Items.Count <= 0) then
    exit;

  if (p_LineSeries.m_Signal) then
  begin
    DrawLineValueSeries_SignalLine(p_Bitmap, p_LineSeries, p_ActiveLine);
  end
  else if (p_LineSeries.m_Type = CFNMatrixConst.LINESERIES_PRICE) then
    DrawLineValueSeries_PriceLine(p_Bitmap, p_LineSeries, p_ActiveLine)
  else if (p_LineSeries.m_Type = CFNMatrixConst.LINESERIES_VOLUME) then
    DrawLineValueSeries_VolumeLine(p_Bitmap, p_LineSeries, p_ActiveLine)
  else
    DrawLineValueSeries_Line(p_Bitmap, p_LineSeries, p_ActiveLine);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.CalculateYGridSize;
var
  f_YMaxMin, f_YGridSize, f_tmp: Double;
  f_Value: Integer;
  f_Y0, f_Y1, f_Index: Integer;
begin
  if (m_ABSYGridSize <> 0) then
  begin

    m_Unit := 1;
    m_YGridSize := m_ABSYGridSize;
    exit;
  end;

  f_YMaxMin := (m_MaxMin.m_YMax - m_MaxMin.m_YMin);

  if ((m_MaxMin.m_YMax = NOT_VALUE) or (m_MaxMin.m_YMin = NOT_VALUE) or (m_MaxMin.m_YMax = MIN_VALUE) or (m_MaxMin.m_YMin = MAX_VALUE)) then
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
      f_YGridSize := f_YGridSize / 1.0;
    1:
      f_YGridSize := f_YGridSize / 3.0;
    2:
      f_YGridSize := f_YGridSize / 3.0;
    3:
      f_YGridSize := f_YGridSize / 1.0;
    4:
      ;
    5:
      ;
    6:
      f_YGridSize := f_YGridSize * 2.0;
    7:
      f_YGridSize := f_YGridSize * 2.0;
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
    if (Abs(f_Y1 - f_Y0) >= CFNMatrixConst.CHART_DRAW_XLABEL_HEIGHT2) then
      break;

    f_YGridSize := f_YGridSize + f_tmp;
  end;

  m_YGridSize := f_YGridSize;
  if 0 = m_UnitType then
  begin
    if (f_YGridSize > 50000000) then
      m_Unit := 1000000
    else if (f_YGridSize > 5000) then
      m_Unit := 1000
    else
      m_Unit := 1;
  end
  else
  begin
    if (f_YGridSize > 500000000) then
      m_Unit := 10000000
    else if (f_YGridSize > 50000) then
      m_Unit := 10000
    else
      m_Unit := 1;
  end;

  if m_ChartIndex = 0 then
    m_Unit := 1;

end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlock.FindValueArray(p_Name: String): CFNMatrixLineValueSeries;
var
  f_Object: Integer;
  p_LineSeries: CFNMatrixLineValueSeries;
  f_FindValueArray: CFNMatrixLineValueSeries;
begin
  f_FindValueArray := NIL;
  for f_Object := 0 to m_ObjectArray.Count - 1 do
  begin
    p_LineSeries := CFNMatrixLineValueSeries(m_ObjectArray.Items[f_Object]);
    if (p_LineSeries.m_Name = p_Name) then
    begin
      f_FindValueArray := p_LineSeries;
      break;
    end;
  end;

  Result := f_FindValueArray;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.DeleteValueArray(p_Name: String);
var
  f_Object: Integer;
  p_LineSeries: CFNMatrixLineValueSeries;
begin
  for f_Object := 0 to m_ObjectArray.Count - 1 do
  begin
    p_LineSeries := CFNMatrixLineValueSeries(m_ObjectArray.Items[f_Object]);
    if (p_LineSeries.m_Name = p_Name) then
    begin
      p_LineSeries.Clear;
      p_LineSeries.Free;
      m_ObjectArray.Delete(f_Object);
      break;
    end;
  end;

end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.ClearObject;
var
  f_Object: Integer;
  p_LineSeries: CFNMatrixLineValueSeries;
begin
  try
    while (m_ObjectArray.Count > 0) do
    begin
      p_LineSeries := CFNMatrixLineValueSeries(m_ObjectArray.Items[0]);
      p_LineSeries.Clear;
      p_LineSeries.Free;

      m_ObjectArray.Delete(0);
    end;

  finally
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.AddObject(p_LineSeries: CFNMatrixLineValueSeries);
begin
  if (p_LineSeries.m_Type = CFNMatrixConst.LINESERIES_PRICE) then
  begin
    m_PaddingTop := 18;
    m_PaddingBottom := 24;
  end
  else if (p_LineSeries.m_Type = CFNMatrixConst.LINESERIES_VOLUME) then
  begin
    m_PaddingBottom := 0;
  end
  else
  begin
    m_PaddingBottom := m_PaddingBottom;
  end;

  m_ObjectArray.Add(p_LineSeries);

  p_LineSeries.GetLineMaxMin(0, p_LineSeries.m_Items.Count - 1);

  if (p_LineSeries.m_Effect) then
  begin
    m_AbsMaxMin.m_XMin := 0;
    m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
    m_AbsMaxMin.m_YMin := p_LineSeries.m_MaxMinTable[0].m_YMin;
    m_AbsMaxMin.m_YMax := p_LineSeries.m_MaxMinTable[0].m_YMax;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.ChangedLineMaxMin(p_LineSeries: CFNMatrixLineValueSeries);
begin
  p_LineSeries.GetLineMaxMin(0, p_LineSeries.m_Items.Count - 1);

  if (p_LineSeries.m_Effect) then
  begin
    m_AbsMaxMin.m_XMin := 0;
    m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
    m_AbsMaxMin.m_YMin := p_LineSeries.m_MaxMinTable[0].m_YMin;
    m_AbsMaxMin.m_YMax := p_LineSeries.m_MaxMinTable[0].m_YMax;
  end;
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlock.GetYGridPrecision: Integer;
begin
  Result := m_YGridPrecision;
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlock.GetUnit: Integer;
begin
  Result := m_Unit;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.SetScale(p_Scale: Integer);
begin
  m_Scale := p_Scale;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.DrawFillRectAngle(p_Bitmap: TBitmap32; p_Tick: Integer; p_LineColor: Integer; p_LineAlpha: Integer; p_FillColor: Integer; p_FillAlpha: Integer; p_X1: Integer;
  p_Y1: Integer; p_X2: Integer; p_Y2: Integer);
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

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.DrawYGrid(p_Bitmap: TBitmap32);
var
  f_GridPosition: Double;
  f_iy: Integer;
  LnColor: TColor32;
begin
  if (m_VisibleYGrid) then
  begin
    LnColor := m_ColorSet.m_Color[CFNMatrixColorSet.GRID_COLOR];
    LnColor := SetAlpha(LnColor, TFNGlobal.GetAlphaValue(100));
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
          p_Bitmap.LineToAS(m_AxisRect.left + TFNGlobal.RectToWidth(m_AxisRect), f_iy);
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
          p_Bitmap.LineToAS(m_AxisRect.left + TFNGlobal.RectToWidth(m_AxisRect), f_iy);
        end;
        f_GridPosition := f_GridPosition - m_YGridSize;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.DrawYTicLabel(p_Bitmap: TBitmap32);
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
  f_x, f_y, f_X2, f_Y2: Integer;
  PenColor: TColor32;
  FillColor: TColor32;

  f_Unit: String;

  f_Index: Integer;
  f_LineSeries: CFNMatrixLineValueSeries;
  f_RightTickLabelCount: Integer;
  f_Value: Double;
  f_FontColor: TColor32;
begin
  f_Precision1 := 0;
  f_Precision2 := 0;
  f_dMulti := 0.0;

  p_Bitmap.Font.Name := CFNMatrixColorSet.NUMBER2_FONT_FAMILY;
  p_Bitmap.Font.Size := CFNMatrixColorSet.NUMBER2_FONT_SMALLSIZE2;
  p_Bitmap.Font.Style := [];
  p_Bitmap.Font.Color := m_ColorSet.m_Color[CFNMatrixColorSet.YTICK_LABEL_COLOR];

  if (m_VisibleYLabel) then
  begin
    PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.AXIS_COLOR];
    PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));
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

          f_TicLabel := TFNGlobal.NumberToString(f_GridPosition / m_Unit, m_YGridPrecision);

          f_x := m_BoundRect.Right - p_Bitmap.TextWidth(f_TicLabel) - CFNMatrixConst.CHART_DRAW_YBOUNDARY_OFFSET2;
          f_y := Math.floor(GetScreenY(f_GridPosition, m_MaxMin) - p_Bitmap.TextHeight(f_TicLabel) / 2 + 2);
          p_Bitmap.Textout(f_x, f_y, f_TicLabel);
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

          f_TicLabel := TFNGlobal.NumberToString(f_GridPosition / m_Unit, m_YGridPrecision);

          f_x := m_BoundRect.Right - p_Bitmap.TextWidth(f_TicLabel) - CFNMatrixConst.CHART_DRAW_YBOUNDARY_OFFSET2;
          f_y := Math.floor(GetScreenY(f_GridPosition, m_MaxMin) - p_Bitmap.TextHeight(f_TicLabel) / 2 + 2);
          p_Bitmap.Textout(f_x, f_y, f_TicLabel);
        end;

        f_GridPosition := f_GridPosition - m_YGridSize;
      end;
    end;

    if (m_Unit <> 1) then
    begin
      if (m_Unit = 10000000) then
        f_Unit := '*10,000,000'
      else if (m_Unit = 1000000) then
        f_Unit := '*1,000,000'
      else if (m_Unit = 10000) then
        f_Unit := '*10,000'
      else if (m_Unit = 1000) then
        f_Unit := '*1,000'
      else
        f_Unit := '';

      p_Bitmap.Font.Name := CFNMatrixColorSet.NUMBER2_FONT_FAMILY;
      p_Bitmap.Font.Size := CFNMatrixColorSet.NUMBER2_FONT_SMALLSIZE2;
      p_Bitmap.Font.Style := [];
      p_Bitmap.Font.Color := m_ColorSet.m_Color[CFNMatrixColorSet.UNIT_TEXT_COLOR];

      PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.UNIT_LINE_COLOR];
      PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));

      FillColor := m_ColorSet.m_Color[CFNMatrixColorSet.UNIT_FILLED_COLOR];
      FillColor := SetAlpha(FillColor, TFNGlobal.GetAlphaValue(100));

      f_TextWidth := p_Bitmap.TextWidth(f_Unit) + 2;
      f_TextHeight := p_Bitmap.TextHeight(f_Unit);
      f_x := m_AxisRect.Right;
      f_y := m_AxisRect.Top;
      f_X2 := f_x + m_BoundRect.Right - (m_AxisRect.Right) - CFNMatrixConst.CHART_DRAW_YBOUNDARY_OFFSET2;
      f_Y2 := f_y + 15;
      p_Bitmap.FillRectTS(f_x, f_y, f_X2, f_Y2, FillColor);
      p_Bitmap.FrameRectTS(f_x, f_y, f_X2, f_Y2, PenColor);
      p_Bitmap.Textout(f_x + ((f_X2 - f_x) - f_TextWidth), Math.floor(f_y + (((f_Y2 - f_y) - f_TextHeight) / 2)), f_Unit);
    end;
  end;
end;

procedure CFNMatrixChartBlock.DrawLastValue(p_Bitmap: TBitmap32);
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
  f_LineIndex: Integer;
  f_LastValueLineIndex: Integer;
  f_LineSeries: CFNMatrixLineValueSeries;
  f_RightTickLabelCount: Integer;
  f_Value: Double;
  f_FontColor: TColor32;
  f_LineValue0: CMKLineValue;
  f_X1, f_X2, f_Y1, f_Y2: Integer;
  f_XIndex0: Integer;
begin
  f_PaddingTop := 2;
  f_PaddingBottom := 2;

  p_Bitmap.Font.Name := CFNMatrixColorSet.NUMBER2_FONT_FAMILY;
  p_Bitmap.Font.Size := CFNMatrixColorSet.NUMBER2_FONT_SMALLSIZE2;
  p_Bitmap.Font.Style := [];
  p_Bitmap.Font.Color := m_ColorSet.m_Color[CFNMatrixColorSet.YTICK_LABEL_COLOR];

  for f_Index := 0 to m_ObjectArray.Count - 1 do
  begin
    f_LineSeries := CFNMatrixLineValueSeries(m_ObjectArray.Items[f_Index]);
    if (f_LineSeries.m_Items.Count <= 0) then
      continue;

    if f_LineSeries.m_LastValueVisible then
    begin
      f_XIndex0 := f_LineSeries.m_Items.Count - 1;
      f_LineValue0 := f_LineSeries.m_Items[f_XIndex0];

      f_TicLabel := '';
      f_LastValueLineIndex := -1;
      for f_LineIndex := 0 to f_LineSeries.m_LineCount - 1 do
      begin
        if f_LineSeries.m_LineLastValueVisibles[f_LineIndex] then
        begin
          f_TicLabel := TFNGlobal.NumberToString((f_LineValue0.m_Value[f_LineIndex] / m_Unit), f_LineSeries.m_Precision);
          f_LastValueLineIndex := f_LineIndex;
          break;
        end;
      end;

      if f_LastValueLineIndex >= 0 then
      begin
        f_TextWidth := p_Bitmap.TextWidth(f_TicLabel);
        f_TextHeight := p_Bitmap.TextHeight(f_TicLabel);
        f_LineHeight := f_TextHeight;

        f_iy := GetScreenY(f_LineValue0.m_Value[f_LastValueLineIndex], f_LineSeries.m_MaxMinTable[0]);

        PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.TRACE_XY_LINE_COLOR];
        PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));

        FillColor := $00EEEECC;
        FillColor := SetAlpha(FillColor, TFNGlobal.GetAlphaValue(100));

        f_X1 := m_AxisRect.Right;
        f_X2 := m_BoundRect.Right;
        f_Y1 := f_iy - f_TextHeight div 2 - f_PaddingTop;
        f_Y2 := f_Y1 + f_LineHeight * 1 + f_PaddingTop + f_PaddingBottom;
        f_iy := f_Y1 + f_PaddingTop;

        p_Bitmap.FillRectTS(f_X1, f_Y1, f_X2, f_Y2, FillColor);
        p_Bitmap.FrameRectTS(f_X1, f_Y1, f_X2, f_Y2, PenColor);

        f_FontColor := m_ColorSet.m_Color[CFNMatrixColorSet.TRACE_XY_TEXT_COLOR];
        f_FontColor := SetAlpha(f_FontColor, TFNGlobal.GetAlphaValue(100));
        f_ix := m_BoundRect.Right - f_TextWidth - CFNMatrixConst.CHART_DRAW_YBOUNDARY_OFFSET - 1;
        p_Bitmap.RenderText(f_ix, f_iy, f_TicLabel, 0, f_FontColor);
      end;
    end;
  end;
end;

procedure CFNMatrixChartBlock.DrawXGrid(p_Bitmap: TBitmap32);
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
  f_Date0, f_Date1: Double;
  f_MaxMin: Integer;
  f_ValueArray: CFNMatrixLineValueSeries;

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

      f_Date1 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Sx]).m_OpenDateTime);

      f_Index := f_Sx;
      while ((f_Index <= f_Ex) and (f_Index < m_ChartDataSeries.m_Items.Count)) do
      begin
        f_Date0 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_OpenDateTime);
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

      PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.GRID_COLOR];
      PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));
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
        f_NewWeek := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_OpenDateTime);
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

      f_Date1 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Sx]).m_OpenDateTime * 86400);

      f_Index := f_Sx;
      while ((f_Index <= f_Ex) and (f_Index < m_ChartDataSeries.m_Items.Count)) do
      begin
        f_Date0 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_OpenDateTime * 86400);
        if (f_Date1 <> f_Date0) then
          Inc(f_MaxMin);

        f_Date1 := f_Date0;

        Inc(f_Index);
      end;

      f_MaxMin := f_MaxMin * (m_ChartDataSeries.m_TimeFrame - 9000);

      PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.GRID_COLOR];
      PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));
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
        f_NewWeek := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_OpenDateTime);
        f_NewWeek := Math.floor((f_NewWeek + 5) / 7);
        f_NewHour := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Hour;
        f_NewMin := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Min;
        f_NewSec := CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_Sec;

        if (f_MaxMin <= 60) then
        begin
          if (Math.floor(f_OldSec / 5) <> Math.floor(f_NewSec / 5)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 120) then
        begin
          if (Math.floor(f_OldSec / 10) <> Math.floor(f_NewSec / 10)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 240) then
        begin
          if (Math.floor(f_OldSec / 20) <> Math.floor(f_NewSec / 20)) then
            f_Draw := true;
        end
        else if (f_MaxMin <= 320) then
        begin
          // if (Math.floor(f_OldSec/30) <> Math.floor(f_NewSec/30)) then f_Draw := true;
          if (Math.floor(f_OldMin / 1) <> Math.floor(f_NewMin / 1)) then
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

procedure CFNMatrixChartBlock.DrawXTicLabel(p_Bitmap: TBitmap32);
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
  f_Date0, f_Date1: Double;
  f_MaxMin: Integer;
  f_TicLabel: String;
  f_OldPosition: Integer;
  f_MarketIndex: Integer;
  f_ValueArray: CFNMatrixLineValueSeries;
  f_Year, f_Month, f_Day, f_Hour, f_Min: Integer;

  f_TextWidth: Integer;
  f_x, f_y, f_X2, f_Y2: Integer;
begin
  f_OldPosition := m_AxisRect.left;

  p_Bitmap.Font.Name := CFNMatrixColorSet.NUMBER2_FONT_FAMILY;
  p_Bitmap.Font.Size := CFNMatrixColorSet.NUMBER2_FONT_SMALLSIZE2;
  p_Bitmap.Font.Style := [];
  p_Bitmap.Font.Color := m_ColorSet.m_Color[CFNMatrixColorSet.XTICK_LABEL_COLOR];

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
      f_Date1 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Sx]).m_OpenDateTime);

      f_Index := f_Sx;
      while ((f_Index <= f_Ex) and (f_Index < m_ChartDataSeries.m_Items.Count)) do
      begin
        f_Date0 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_OpenDateTime);
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
        f_NewWeek := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_OpenDateTime);
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
              f_TicLabel := TFNGlobal.DateToMM_DD(f_NewMonth, f_NewDay)
            else
              f_TicLabel := TFNGlobal.TimeToHH_MM(f_NewHour, f_NewMin);
          end
          else if (f_Type = 1) then
          begin
            f_TicLabel := TFNGlobal.DateToYY_MM_DD(TFNGlobal.atoi(Copy(IntToStr(f_NewYear), 3, 2)), f_NewMonth);
          end
          else
          begin
            f_TicLabel := TFNGlobal.DateToYY_MM_DD(TFNGlobal.atoi(Copy(IntToStr(f_NewYear), 3, 2)));
          end;

          f_TextWidth := p_Bitmap.TextWidth(f_TicLabel);
          if ((f_OldPosition = m_AxisRect.left) or (f_OldPosition + f_TextWidth * 1.5 < f_ix)) then
          begin
            f_x := Math.floor(f_ix - f_TextWidth / 2);
            f_y := f_iy - 1;
            f_OldPosition := f_ix;
            p_Bitmap.Textout(f_x, f_y + 2, f_TicLabel);
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
      f_Date1 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Sx]).m_OpenDateTime * 86400);

      f_Index := f_Sx;
      while ((f_Index <= f_Ex) and (f_Index < m_ChartDataSeries.m_Items.Count)) do
      begin
        f_Date0 := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_OpenDateTime * 86400);
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
        f_NewWeek := Math.floor(CMKChartData(m_ChartDataSeries.m_Items[f_Index]).m_OpenDateTime);
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
            f_TicLabel := TFNGlobal.TimeToHH_MM_SS(f_NewHour, f_NewMin, f_NewSec);
          end
          else if (f_Type = 1) then
          begin
            f_TicLabel := TFNGlobal.TimeToHH_MM(f_NewHour, f_NewMin);
          end
          else
          begin
            f_TicLabel := TFNGlobal.TimeToHH_MM(f_NewHour, f_NewMin);
          end;

          f_TextWidth := p_Bitmap.TextWidth(f_TicLabel);
          if ((f_OldPosition = m_AxisRect.left) or (f_OldPosition + f_TextWidth * 1.5 < f_ix)) then
          begin
            f_x := Math.floor(f_ix - f_TextWidth / 2);
            f_y := f_iy - 1;
            f_OldPosition := f_ix;
            p_Bitmap.Textout(f_x, f_y + 2, f_TicLabel);
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

// ---------------------------------------------------------------------------
// 비교모드가 아닐 경우 차트의 좌측 상단에 레이블을 그린다.
procedure CFNMatrixChartBlock.DrawLabel(p_Bitmap: TBitmap32);
var
  f_Index, f_Line, f_Option, f_TextWidth, f_TextHeight: Integer;
  f_CtrlHeight, f_RectHeight: Integer;
  f_ValueArray: CFNMatrixLineValueSeries;
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

  p_Bitmap.Font.Name := CFNMatrixColorSet.NUMBER2_FONT_FAMILY;
  p_Bitmap.Font.Size := CFNMatrixColorSet.NUMBER2_FONT_SMALLSIZE2;
  p_Bitmap.Font.Style := [];
  p_Bitmap.Font.Color := m_ColorSet.m_Color[CFNMatrixColorSet.CAPTION_FIELDNAME_TEXT_COLOR];

  f_CtrlHeight := TFNGlobal.RectToHeight(m_LegendRect) + 2; // 전체 높이
  f_TextWidth := p_Bitmap.TextWidth('8'); // 텍스트 너비
  f_TextHeight := p_Bitmap.TextHeight('8'); // 텍스트 높이
  f_RectHeight := f_TextHeight - 4; // 사각형 높이는 폰트높이에서 4뺀크기
  f_LineX := m_LegendRect.left + 6; // X좌표
  f_LineY := m_LegendRect.Top + Math.floor((f_CtrlHeight - f_TextHeight) / 2);
  // Y 좌표

  f_LableX1 := m_LegendRect.left + 2;
  f_LableY1 := m_LegendRect.Top + 2;
  f_LableY2 := m_LegendRect.Top + 2 + 15;
  for f_Index := 0 to m_ObjectArray.Count - 1 do
  begin
    f_ValueArray := CFNMatrixLineValueSeries(m_ObjectArray.Items[f_Index]);
    if (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_COMPARECLOSE) then
      continue;

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
        f_LineColor := m_ColorSet.m_Color[CFNMatrixColorSet.VOLUME_FILLED_COLOR];
        f_Alpha := m_ColorSet.m_Alpha[CFNMatrixColorSet.ALPHA_VOLUME_LINE];
      end
      else
      begin
        f_LineColor := f_LineColor;
        f_Alpha := f_Alpha;
      end;

      if (f_ValueArray.m_LineTypes[f_Line] = 0) then
      begin
        DrawFillRectAngle(p_Bitmap, 0, f_LineColor, TFNGlobal.GetAlphaValue(100), f_LineColor, f_Alpha, f_X1, f_Y1, f_X2, f_Y2);
      end
      else if (f_ValueArray.m_LineTypes[f_Line] = 1) then
      begin
        DrawFillRectAngle(p_Bitmap, 0, m_ColorSet.m_Color[CFNMatrixColorSet.OSC_UP_FILLED_COLOR], TFNGlobal.GetAlphaValue(100), m_ColorSet.m_Color[CFNMatrixColorSet.OSC_UP_FILLED_COLOR],
          m_ColorSet.m_Alpha[CFNMatrixColorSet.ALPHA_OSC_LINE], f_X1, f_Y1, f_X2, f_Y1 + 4);
        DrawFillRectAngle(p_Bitmap, 0, m_ColorSet.m_Color[CFNMatrixColorSet.OSC_DN_FILLED_COLOR], TFNGlobal.GetAlphaValue(100), m_ColorSet.m_Color[CFNMatrixColorSet.OSC_DN_FILLED_COLOR],
          m_ColorSet.m_Alpha[CFNMatrixColorSet.ALPHA_OSC_LINE], f_X1, f_Y1 + 4, f_X2, f_Y2);
      end
      else if (f_ValueArray.m_LineTypes[f_Line] = 2) then
      begin
        DrawFillRectAngle(p_Bitmap, 0, f_LineColor, TFNGlobal.GetAlphaValue(100), f_LineColor, f_Alpha, f_X1, f_Y1, f_X2, f_Y2);
      end
      else if (f_ValueArray.m_LineTypes[f_Line] = 3) then
      begin
        DrawFillRectAngle(p_Bitmap, 0, f_LineColor, TFNGlobal.GetAlphaValue(100), f_LineColor, f_Alpha, f_X1, f_Y1, f_X2, f_Y2);
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
procedure CFNMatrixChartBlock.OnMouseDown(p_X: Integer; p_Y: Integer);
begin
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.OnMouseUp(p_X: Integer; p_Y: Integer);
var
  p_PosInfo: CFNMatrixPosInfo;
begin
  if (m_ObjectArray.Count = 0) then
    exit;

  if ((p_X >= m_AxisRect.left) and (p_X <= m_AxisRect.Right)) then
  begin
    p_PosInfo := CFNMatrixPosInfo.Create;
    p_PosInfo.m_ChartIndex := m_ChartIndex;
    p_PosInfo.m_MX := p_X;
    p_PosInfo.m_MY := p_Y;
    p_PosInfo.m_ValueX := Math.floor(GetRealX(p_X, m_MaxMin));
    p_PosInfo.m_ValueY := GetRealY(p_Y, m_MaxMin);

    if (p_PosInfo.m_ValueX > m_AbsMaxMin.m_XMax) then
      p_PosInfo.m_ValueX := m_AbsMaxMin.m_XMax;

    p_PosInfo.m_WindowX := Math.floor(GetScreenXCenter(p_PosInfo.m_ValueX, m_MaxMin));
    p_PosInfo.m_WindowY := Math.floor(GetScreenY(p_PosInfo.m_ValueY, m_MaxMin));
    CFNMatrixChartBlockManager(m_ChartBlockManager).ClickPos(p_PosInfo);

    p_PosInfo.Free;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.OnMouseMoveOnAnytime(p_X: Integer; p_Y: Integer);
var
  p_PosInfo: CFNMatrixPosInfo;
begin
  if (m_ObjectArray.Count = 0) then
    exit;

  if ((p_X >= m_AxisRect.left) and (p_X <= m_AxisRect.Right)) then
  begin
    p_PosInfo := CFNMatrixPosInfo.Create;
    p_PosInfo.m_ChartIndex := m_ChartIndex;
    p_PosInfo.m_MX := p_X;
    p_PosInfo.m_MY := p_Y;
    p_PosInfo.m_ValueX := Math.floor(GetRealX(p_X, m_MaxMin));
    p_PosInfo.m_ValueY := GetRealY(p_Y, m_MaxMin);

    if (p_PosInfo.m_ValueX > m_AbsMaxMin.m_XMax) then
      p_PosInfo.m_ValueX := m_AbsMaxMin.m_XMax;

    p_PosInfo.m_WindowX := Math.floor(GetScreenXCenter(p_PosInfo.m_ValueX, m_MaxMin));
    p_PosInfo.m_WindowY := Math.floor(GetScreenY(p_PosInfo.m_ValueY, m_MaxMin));
    CFNMatrixChartBlockManager(m_ChartBlockManager).TraceXYOnAnytime(p_PosInfo);

    p_PosInfo.Free;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.OnMouseMoveSometime(p_X: Integer; p_Y: Integer; p_Outer: Boolean);
var
  p_PosInfo: CFNMatrixPosInfo;

  f_Direction: Integer;
  f_XMinDate, f_XMaxDate: TDateTime;
  f_XMinOffset, f_XMaxOffset: Integer;
  f_Action: Boolean;
begin

  if (m_ObjectArray.Count = 0) then
    exit;

  f_Action := false;
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
          p_PosInfo := CFNMatrixPosInfo.Create;
          p_PosInfo.m_ChartIndex := m_ChartIndex;
          p_PosInfo.m_MX := p_X;
          p_PosInfo.m_MY := p_Y;
          p_PosInfo.m_ValueX := Math.floor(GetRealX(p_X, m_MaxMin));
          p_PosInfo.m_ValueY := GetRealY(p_Y, m_MaxMin);
          if (p_PosInfo.m_ValueX > m_AbsMaxMin.m_XMax) then
            p_PosInfo.m_ValueX := m_AbsMaxMin.m_XMax;

          p_PosInfo.m_WindowX := Math.floor(GetScreenXCenter(p_PosInfo.m_ValueX, m_MaxMin));
          p_PosInfo.m_WindowY := Math.floor(GetScreenY(p_PosInfo.m_ValueY, m_MaxMin));
          if not p_Outer then
          begin
            GetEnableTracePannel(p_PosInfo);
            if (m_ChartIndex > 0) then
              CFNMatrixChartBlockManager(m_ChartBlockManager).DrawTrace(m_ChartIndex, p_PosInfo.m_ValueX, p_PosInfo.m_ValueY);
          end
          else
          begin
          end;

          CFNMatrixChartBlockManager(m_ChartBlockManager).TraceXYOnSometime(p_PosInfo);
          CFNMatrixChartBlockManager(m_ChartBlockManager).DrawTraceCaption(Math.floor(p_PosInfo.m_ValueX));

          p_PosInfo.Free;
        end;
      end;
    finally
    end;

  end;
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlock.GetScreenYGridPrecision: Integer;
begin
  Result := m_YGridPrecision;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.ClearActiveLayer;
begin
  if (m_DrawedOverLayer) then
  begin
    m_OverLayer.Bitmap.Clear($00000000);

    m_DrawedOverLayer := false;
  end;
end;

// ---------------------------------------------------------------------------
// 십자선을 그린다.
procedure CFNMatrixChartBlock.DrawTrace(p_TRInfo: CFNMatrixPosInfo);
var
  PenColor: TColor32;
begin
  PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.TRACE_FILLED_COLOR];
  PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));

  m_TraceLayer.Bitmap.PenColor := PenColor;
  m_TraceLayer.Bitmap.MoveTo(p_TRInfo.m_WindowX, m_AxisRect.Top);
  m_TraceLayer.Bitmap.LineToAS(p_TRInfo.m_WindowX, m_AxisRect.bottom);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.DrawTrace2(p_ChartIndex: Integer; p_ValueX: Double; p_ValueY: Double);
var
  PenColor: TColor32;
  f_WindowX, f_WindowY: Integer;
begin
  if p_ValueY = NOT_VALUE then
    exit;

  PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.TRACE_FILLED_COLOR];
  PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));
  f_WindowX := Math.floor(GetScreenXCenter(p_ValueX, m_MaxMin));
  f_WindowY := Math.floor(GetScreenY(p_ValueY, m_MaxMin));

  m_TraceLayer.Bitmap.PenColor := PenColor;

  if (f_WindowX >= m_AxisRect.left) AND (f_WindowX <= m_AxisRect.Right) then
  begin
    m_TraceLayer.Bitmap.MoveTo(f_WindowX, m_AxisRect.Top);
    m_TraceLayer.Bitmap.LineToAS(f_WindowX, m_AxisRect.bottom);
  end;

  if (p_ChartIndex = m_ChartIndex) then
  begin
    m_TraceLayer.Bitmap.MoveTo(m_AxisRect.left, f_WindowY);
    m_TraceLayer.Bitmap.LineToAS(m_AxisRect.Right, f_WindowY);
  end;

end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.GetPosValue(p_Index: Integer; Values: TList);
var
  f_PosValue: CFNMatrixPosValue;
  p_ValueArray: CFNMatrixLineValueSeries;
begin
  if ((p_Index < 0) or (p_Index >= m_ChartDataSeries.m_Items.Count)) then
    exit;

  if ((m_OverObject < 0) or (m_OverObject >= m_ObjectArray.Count)) then
    exit;

  p_ValueArray := m_ObjectArray[m_OverObject];
  if ((m_OverLine < 0) or (m_OverLine >= p_ValueArray.m_LineCount)) then
    exit;

  if (p_ValueArray.m_LineVisibles[m_OverLine]) then
  begin
    f_PosValue := CFNMatrixPosValue.Create;
    if (p_ValueArray.m_Type = CFNMatrixConst.LINESERIES_MA) then
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
function CFNMatrixChartBlock.GetHitTestX1(p_PosX: Double; p_Width: Double): Double;
begin
  Result := GetRealX(p_PosX - p_Width, m_MaxMin);
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlock.GetHitTestX2(p_PosX: Double; p_Width: Double): Double;
begin
  Result := GetRealX(p_PosX + p_Width, m_MaxMin);
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlock.GetEnableTracePannel(p_PosInfo: CFNMatrixPosInfo): Boolean;
var
  f_Index, f_Object, f_Line: Integer;
  f_ValueArray: CFNMatrixLineValueSeries;
  f_Y0, f_Y1, f_Y2, f_OpenCloseWidth: Integer;
  f_DX1, f_DX2: Integer;
  f_DY1, f_DY2: Double;
  f_DXSize: Integer;
  f_Enabled: Boolean;
  f_Origin: Integer;
  f_Value: Integer;
  f_OrginValue: Double;
  f_Hi, f_Low: Double;
  f_OriginChartData: CMKChartData;

  f_SIndex0, f_SIndex1, f_SIndex2: Integer;
  f_Signal: Integer;
  f_SignalEnter: Boolean;

  f_LineValue: CMKLineValue;

  f_x: Double;
  f_y: Double;
begin
  f_Enabled := false;
  f_SignalEnter := false;

  if ((p_PosInfo.m_ValueX < 0) or (p_PosInfo.m_ValueX >= m_ChartDataSeries.m_Items.Count)) then
  begin
    Result := false;
    exit;
  end;

  f_Hi := 0;
  f_Low := 0;
  f_OpenCloseWidth := Math.floor((GetScreenX(m_MaxMin.m_XMax, m_MaxMin) - GetScreenX(m_MaxMin.m_XMin, m_MaxMin)) / (m_MaxMin.m_XMax - m_MaxMin.m_XMin + 1));
  if (f_OpenCloseWidth <= 2) then
    f_OpenCloseWidth := 2;

  f_DX1 := Math.floor(GetHitTestX1(p_PosInfo.m_WindowX, 2));
  f_DX2 := Math.floor(GetHitTestX2(p_PosInfo.m_WindowX, 2));
  f_DXSize := Math.floor(f_DX2 - f_DX1 + 1);
  for f_Object := 0 to m_ObjectArray.Count - 1 do
  begin
    f_ValueArray := CFNMatrixLineValueSeries(m_ObjectArray.Items[f_Object]);

    f_Origin := Math.floor(m_MaxMin.m_XMin);
    if (f_Origin < f_ValueArray.m_StartIndex) then
      f_Origin := f_ValueArray.m_StartIndex;

    if (f_Origin >= f_ValueArray.m_Items.Count) then
      f_Origin := f_ValueArray.m_Items.Count - 1;
    (*
      f_OriginChartData := CMKChartData(f_ValueArray.m_ChartDataSeries.m_Items[f_Origin]);
      if (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_COMPARECLOSE) then
      f_OrginValue := CMKLineValue(f_ValueArray.m_Items[f_Origin]).m_Value[0]
      else
      f_OrginValue := f_OriginChartData.m_CloseOPS;
    *)
    if (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_PRICE) then
    begin
      f_ValueArray.HiLoPrice(f_DXSize, f_ValueArray, CFNMatrixConst.PRICE_HIGH, CFNMatrixConst.PRICE_LOW, f_DX2, f_Hi, f_Low);
      f_DY1 := f_Hi;
      f_DY2 := f_Low;

      if (NOT_VALUE <> f_DY1) and (NOT_VALUE <> f_DY2) then
      begin
        f_Y1 := GetScreenY(f_DY1, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[0]]);
        f_Y2 := GetScreenY(f_DY2, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[0]]);
        if ((f_Y1 - 1 <= p_PosInfo.m_WindowY) and (p_PosInfo.m_WindowY <= f_Y2 + 1)) then
        begin
          f_Enabled := true;
          m_OverObject := f_Object;
          m_OverLine := CFNMatrixConst.PRICE_CLOSE;
          break;
        end;
      end;
    end
    else if (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_VOLUME) then
    begin
      f_DY1 := f_ValueArray.HighestPrice(f_DXSize, f_ValueArray, 0, f_DX2);
      f_DY2 := 0;
      f_Y1 := GetScreenY(f_DY1, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[0]]);
      f_Y2 := GetScreenY(f_DY2, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[0]]);
      if ((f_Y1 - 1 < p_PosInfo.m_WindowY) and (p_PosInfo.m_WindowY < f_Y2)) then
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
              if ((f_Y1 - 1 <= p_PosInfo.m_WindowY) and (p_PosInfo.m_WindowY <= f_Y2 + 1)) then
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
              if (((f_Y1 - 1 <= p_PosInfo.m_WindowY) and (p_PosInfo.m_WindowY <= f_Y0 + 1)) or ((f_Y0 - 1 <= p_PosInfo.m_WindowY) and (p_PosInfo.m_WindowY <= f_Y2 + 1))) then
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
            f_Enabled := not f_Enabled;
          end;
        end;
      end;
    end;

    if (f_Enabled) then
      break;
  end;

  if (f_Enabled) then
  begin
    if (not m_CaptureMouse) and (not m_DrawedOverLayer) then
    begin
      m_OverLayer.Update;
      m_DrawedOverLayer := true;
    end;

    f_ValueArray := CFNMatrixLineValueSeries(m_ObjectArray.Items[m_OverObject]);
    f_x := Math.floor(p_PosInfo.m_ValueX);
    f_y := CMKLineValue(f_ValueArray.m_Items[Math.floor(f_x)]).m_Value[m_OverLine];

    p_PosInfo.m_RealX := GetScreenXCenter(f_x, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[m_OverLine]]);
    p_PosInfo.m_RealY := GetScreenY(f_y, f_ValueArray.m_MaxMinTable[f_ValueArray.m_LineMaxMinIndexs[m_OverLine]]);
  end
  else
  begin
    ClearActiveLayer;
  end;

  if not f_SignalEnter then
  begin
    CFNMatrixChartBlockManager(m_ChartBlockManager).ClearSignalLayer;
  end;

  p_PosInfo.m_OverLine := f_Enabled;
  p_PosInfo.m_ActiveObjectIndex := m_OverObject;
  p_PosInfo.m_ActiveLineIndex := m_OverLine;

  Result := f_Enabled;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.OnPaintOverLayer(Sender: TObject; Buffer: TBitmap32);
begin
  if (not m_CaptureMouse) and (m_DrawedOverLayer) then
  begin
    if (0 <= m_OverObject) and (m_OverObject < m_ObjectArray.Count) then
    begin
      DrawActiveChart(Buffer, m_ObjectArray[m_OverObject], m_OverLine);
    end;
  end;
end;

// ---------------------------------------------------------------------------
function CFNMatrixChartBlock.GetTraceCaptionWidth(p_Bitmap: TBitmap32): Integer;
var
  f_Index: Integer;
  f_ValueArray: CFNMatrixLineValueSeries;
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

  for f_Index := 0 to m_ObjectArray.Count - 1 do
  begin
    f_ValueArray := m_ObjectArray.Items[f_Index];
    if (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_PRICE) or (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_COMPARECLOSE) or (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_NET) then
    begin
      continue;
    end;

    for f_LineCount := 0 to f_ValueArray.m_LineCount - 1 do
    begin
      if (f_ValueArray.m_LineVisibles[f_LineCount]) and (f_ValueArray.m_LineLabelVisibles[f_LineCount]) and (f_ValueArray.m_LinePosValueVisibles[f_LineCount]) then
      begin
        // Title
        p_Bitmap.Font.Name := CFNMatrixColorSet.NUMBER2_FONT_FAMILY;
        p_Bitmap.Font.Size := CFNMatrixColorSet.NUMBER2_FONT_SMALLSIZE2;
        p_Bitmap.Font.Style := [];
        PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.CAPTION_FIELDNAME_TEXT_COLOR];
        PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));

        if (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_MA) then
          f_Label := FloatToStr(f_ValueArray.m_Options[f_LineCount]) + 'MA:'
        else
          f_Label := f_ValueArray.m_LineNames[f_LineCount] + ':';

        f_FieldWidth := p_Bitmap.TextWidth(f_Label);
        f_FieldHeight := p_Bitmap.TextHeight(f_Label);
        f_LineX := f_LineX + (f_FieldWidth + 2);

        // Value
        p_Bitmap.Font.Name := CFNMatrixColorSet.NUMBER2_FONT_FAMILY;
        p_Bitmap.Font.Size := CFNMatrixColorSet.NUMBER2_FONT_SMALLSIZE2;
        p_Bitmap.Font.Style := [];
        PenColor := m_ColorSet.m_Color[f_ValueArray.m_LineColors[f_LineCount]];
        PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));
        f_Ymin := Abs(f_ValueArray.m_MaxMinTable[0].m_YMin);
        f_Ymax := f_ValueArray.m_MaxMinTable[0].m_YMax;
        if (f_Ymin > f_Ymax) then
          f_Ymax := f_Ymin;

        f_Label := TFNGlobal.NumberToString(f_Ymax * -1, f_ValueArray.m_Precision);

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
procedure CFNMatrixChartBlock.DrawCaption(p_Index: Integer);
begin
  if (0 < m_LabelArray.Count) AND (p_Index >= 0) then
  begin
    DrawNormalCaption(m_LabelLayer.Bitmap, p_Index);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.DrawNormalCaption(p_Bitmap: TBitmap32; p_Index: Integer);
var
  f_Index: Integer;
  f_ValueArray: CFNMatrixLineValueSeries;
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
  f_LineX := m_LegendRect.Right - GetTraceCaptionWidth(p_Bitmap);
  f_LineY := m_LegendRect.Top + 4;

  f_ArrayCount := 0;

  for f_Index := 0 to m_ObjectArray.Count - 1 do
  begin
    f_ValueArray := m_ObjectArray.Items[f_Index];
    if (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_PRICE) or (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_COMPARECLOSE) or (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_NET) then
    begin
      continue;
    end;

    if (f_Index < m_DrawCaptionCount) then
    begin
      for f_LineCount := 0 to f_ValueArray.m_LineCount - 1 do
      begin
        if (f_ValueArray.m_LineVisibles[f_LineCount]) AND (f_ValueArray.m_LineLabelVisibles[f_LineCount]) AND (f_ValueArray.m_LinePosValueVisibles[f_LineCount]) then
        begin

          if (p_Index >= f_ValueArray.m_Items.Count) then
            continue;
          try
            if (CMKLineValue(f_ValueArray.m_Items[p_Index]).m_Value[f_LineCount] = NOT_VALUE) then
              f_Label := ' '
            else
            begin
              f_Value := CMKLineValue(f_ValueArray.m_Items[p_Index]).m_Value[f_LineCount];
              f_Label := TFNGlobal.NumberToString(f_Value / m_Unit, f_ValueArray.m_Precision);
            end;
          except
            f_Value := 0;
            f_Label := ' ';
          end;

          f_LabelData := m_LabelArray.Items[f_ArrayCount];
          p_Bitmap.RenderText(f_LabelData^.nX, f_LabelData^.nY, f_LabelData^.strLabel, 0, f_LabelData^.fontColor);

          Inc(f_ArrayCount);
          f_LabelData := m_LabelArray.Items[f_ArrayCount];
          f_LabelData^.strLabel := f_Label;
          p_Bitmap.RenderText(f_LabelData^.nX, f_LabelData^.nY, f_LabelData^.strLabel, 0, f_LabelData^.fontColor);
          Inc(f_ArrayCount);
        end;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.DrawSignalTrace(p_Signal, p_Start, p_End: Integer);
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
    FillColor := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_UP_FILLED_COLOR];
    PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_UP_FILLED_COLOR];
  end
  else if (p_Signal < 0) then
  begin
    FillColor := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_DN_FILLED_COLOR];
    PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.PRICE_DN_FILLED_COLOR];
  end
  else
  begin
    FillColor := m_ColorSet.m_Color[CFNMatrixColorSet.CHART_COLOR];
    PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.GRID_COLOR];
  end;

  m_SignalLayer.Bitmap.ResetClipRect;
  m_SignalLayer.Bitmap.ClipRect := m_AxisRect;

  FillColor := SetAlpha(FillColor, TFNGlobal.GetAlphaValue(10));
  drRc := TFNGlobal.GetRectToRealRect(f_X1, f_Y1, f_X2, f_Y2);
  m_SignalLayer.Bitmap.FillRectTS(drRc, FillColor);

  PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(80));
  m_SignalLayer.Bitmap.PenColor := PenColor;

  m_SignalLayer.Bitmap.MoveTo(f_X1, f_Y1);
  m_SignalLayer.Bitmap.LineToAS(f_X1, f_Y2);

  m_SignalLayer.Bitmap.MoveTo(f_X2, f_Y1);
  m_SignalLayer.Bitmap.LineToAS(f_X2, f_Y2);

  m_SignalLayer.Bitmap.ResetClipRect;
  m_SignalLayer.Bitmap.ClipRect := m_BoundRect;

end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.InsertCaption(p_X, p_Y, p_W, p_H: Integer; p_Value: String; p_FontColor: TColor);
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
procedure CFNMatrixChartBlock.ClearLabelArray;
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
procedure CFNMatrixChartBlock.InitCaption;
begin
  ClearLabelArray;

  InitNormalCaption(m_LabelLayer.Bitmap);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixChartBlock.InitNormalCaption(p_Bitmap: TBitmap32);
var
  f_Index: Integer;
  f_ValueArray: CFNMatrixLineValueSeries;
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
  f_LineY := m_LegendRect.Top + 2;

  for f_Index := 0 to m_ObjectArray.Count - 1 do
  begin
    f_ValueArray := m_ObjectArray.Items[f_Index];
    if (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_PRICE) or (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_COMPARECLOSE) or (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_NET) then
    begin
      continue;
    end;

    if (f_Index < m_DrawCaptionCount) then
    begin
      for f_LineCount := 0 to f_ValueArray.m_LineCount - 1 do
      begin
        if (f_ValueArray.m_LineVisibles[f_LineCount]) and (f_ValueArray.m_LineLabelVisibles[f_LineCount]) and (f_ValueArray.m_LinePosValueVisibles[f_LineCount]) then
        begin
          // Title
          p_Bitmap.Font.Name := CFNMatrixColorSet.NUMBER2_FONT_FAMILY;
          p_Bitmap.Font.Size := CFNMatrixColorSet.NUMBER2_FONT_SMALLSIZE2;
          p_Bitmap.Font.Style := [];
          PenColor := m_ColorSet.m_Color[CFNMatrixColorSet.CAPTION_FIELDNAME_TEXT_COLOR];
          PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));

          if (f_ValueArray.m_Type = CFNMatrixConst.LINESERIES_MA) then
            f_Label := FloatToStr(f_ValueArray.m_Options[f_LineCount]) + 'MA:'
          else
            f_Label := f_ValueArray.m_LineNames[f_LineCount] + ':';

          f_FieldWidth := p_Bitmap.TextWidth(f_Label);
          f_FieldHeight := p_Bitmap.TextHeight(f_Label);

          p_Bitmap.RenderText(f_LineX, f_LineY, f_Label, 0, PenColor);

          InsertCaption(f_LineX, f_LineY, f_FieldWidth, f_FieldHeight, f_Label, PenColor);

          f_LineX := f_LineX + (f_FieldWidth + 2);

          // Value
          p_Bitmap.Font.Name := CFNMatrixColorSet.NUMBER2_FONT_FAMILY;
          p_Bitmap.Font.Size := CFNMatrixColorSet.NUMBER2_FONT_SMALLSIZE2;
          p_Bitmap.Font.Style := [];
          PenColor := m_ColorSet.m_Color[f_ValueArray.m_LineColors[f_LineCount]];
          PenColor := SetAlpha(PenColor, TFNGlobal.GetAlphaValue(100));
          f_Ymin := Abs(f_ValueArray.m_MaxMinTable[0].m_YMin);
          f_Ymax := f_ValueArray.m_MaxMinTable[0].m_YMax;
          if (f_Ymin > f_Ymax) then
            f_Ymax := f_Ymin;

          f_Label := TFNGlobal.NumberToString(f_Ymax * -1, f_ValueArray.m_Precision);

          f_FieldWidth := p_Bitmap.TextWidth(f_Label);
          f_FieldHeight := p_Bitmap.TextHeight(f_Label);

          InsertCaption(f_LineX, f_LineY, f_FieldWidth, f_FieldHeight, f_Label, PenColor);

          f_LineX := f_LineX + (f_FieldWidth + 2);
        end;
      end;
    end;
  end;
end;

end.
