unit FNMatrixManageChartControl;

interface

uses
  SysUtils, Classes, Controls, GR32_Image, GR32, Types, Messages, Graphics,
  DateUtils,
  Dialogs, Math, StdCtrls, Windows, FNMatrixLineValueSeries,
  FNMatrixLineValueSeriesCreator,
  MKStreamChartDataSeries, FNDataSet, MKChartData, FNQueue, GR32_Layers,
  FNMatrixConst,
  MKMaxMin, FNMatrixColorSet, FNMatrixChartBlockManager, FNMatrixChartBlock,
  FNMatrixChartTraceEvent, MXBlockManager, FNMatrixChartControlBase;

type
  CFNMatrixManageChartControl = class(CFNMatrixChartControlBase)
  private
    m_MatrixBlockManager: CMXBlockManager;
    m_ChartBlockManager: CFNMatrixChartBlockManager;
    m_PriceChartBlock: CFNMatrixChartBlock;
    m_MatrixChartBlock: CFNMatrixChartBlock;

    m_Initialized: Boolean;
    m_ChartType: Integer;
    m_OnControlPaintStage: TPaintStageEvent;
    m_ScrollBar: TScrollBar;
    m_Scale: Integer;
    m_ValueX: Integer;

    m_DrawTraceChartIndex: Integer;
    m_DrawTraceValueX: Double;
    m_DrawTraceValueY: Double;

    procedure MyScrollMove(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);

    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure SetScrollBar(AScrollBar: TScrollBar);

  protected
    procedure MouseMoveHandler(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure MouseDownHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure MouseUpHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);

  public
    m_ChartDataSeries: CMKStreamChartDataSeries;
    m_PriceSeries: CFNMatrixLineValueSeries;
    m_MatrixSeries: CFNMatrixLineValueSeries;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Initialize;
    procedure Finalize;

    procedure Clear;

    function GetEnableChartControl: Boolean;

    procedure Update(p_ChangedDailyGap: Boolean);

    procedure OnResize(p_Left: Integer; p_Top: Integer; p_Width: Integer; p_Height: Integer; p_Paint: Boolean);
    procedure SetBound(p_Left: Integer; p_Top: Integer; p_Right: Integer; p_Bottom: Integer);
    procedure RepaintDraw(p_Bitmap: TBitmap32);

    procedure SetColorSetIndex(p_Value: Integer; p_Paint: Boolean = false);
    procedure SetScale(p_Value: Integer; p_Paint: Boolean = false);
    procedure SetTraceVisible(p_Value: Boolean; p_Paint: Boolean = false);
    procedure SetChartType(p_Type: Integer; p_Paint: Boolean = false);

    procedure OnZoomIn;
    procedure OnZoomOut;
    procedure OnZoomActual;
    procedure OnFullEnlarge;
    procedure DrawTrace(p_ChartIndex: Integer; p_ValueX: Double; p_ValueY: Double);

    procedure OnControlPaintStage(Sender: TObject; Buffer: TBitmap32; StageNum: Cardinal);

    procedure GetChartMaxMin(var p_Min, p_Max: Double);
    procedure OnHScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);

  public

  published
    property ScrollBar: TScrollBar read m_ScrollBar write SetScrollBar;
    property MatrixBlockManager: CMXBlockManager read m_MatrixBlockManager write m_MatrixBlockManager;

  end;

procedure Register;

implementation

uses FNGlobal, FNCMVariable, FNMatrixChartDefine;

// ---------------------------------------------------------------------------
procedure Register;
begin
  RegisterComponents('ATPackage', [CFNMatrixManageChartControl]);
end;

// ---------------------------------------------------------------------------
constructor CFNMatrixManageChartControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  m_ChartType := 2;
  m_Initialized := false;

  m_ScrollBar := NIL;
  m_ValueX := -1;

  m_OnControlPaintStage := OnControlPaintStage;

  m_DrawTraceChartIndex := -1;
  m_DrawTraceValueX := -1;
  m_DrawTraceValueY := -1;

  Initialize;
end;

// ---------------------------------------------------------------------------
destructor CFNMatrixManageChartControl.Destroy;
begin
  Finalize;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.Initialize;
begin
  m_ChartDataSeries := CMKStreamChartDataSeries.Create;

  m_ChartBlockManager := CFNMatrixChartBlockManager.Create;
  m_ChartBlockManager.SetChartControl(Self);
  m_ChartBlockManager.SetLayer;
  m_ChartBlockManager.SetUnitType(1);

  m_PriceSeries := Creator_Price;
  m_MatrixSeries := Creator_MatrixSeries;

  SetColorSetIndex(CFNMatrixConst.COLOR_SET_WHITE, false);
  SetScale(0, false);

  m_Initialized := true;

  // 컨트롤 배경 Draw 속성 설정
  with PaintStages[0]^ do
  begin
    if Stage = PST_CLEAR_BACKGND then
    begin
      Stage := PST_CUSTOM;
    end;
  end;

  // 배경 Draw 이벤트 함수 등록
  OnPaintStage := m_OnControlPaintStage;
  RepaintMode := rmOptimizer;

  // Mouse Event
  Self.OnMouseMove := MouseMoveHandler;
  Self.OnMouseDown := MouseDownHandler;
  // Self.OnMouseLeave := MouseLeaveHandler;

  OnResize(0, 0, Width, Height, true);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.Finalize;
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

  if Assigned(m_MatrixSeries) then
  begin
    m_MatrixSeries.Free;
    m_MatrixSeries := NIL;
  end;

  if Assigned(m_ChartBlockManager) then
  begin
    m_ChartBlockManager.Free;
    m_ChartBlockManager := NIL;
  end;
  m_Initialized := false;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.Clear;
begin
  m_ChartDataSeries.Clear;
  if m_PriceSeries <> NIL then
    m_PriceSeries.Clear;
  if m_MatrixSeries <> NIL then
    m_MatrixSeries.Clear;

  m_ChartBlockManager.ClearChartAll;
  m_ChartBlockManager.RePaint;

  m_PriceSeries := NIL;
  m_MatrixSeries := NIL;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.WMSize(var Message: TWMSize);
begin
  if (m_Initialized) then
    OnResize(0, 0, Width, Height, true);

  Self.Resize;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.SetColorSetIndex(p_Value: Integer; p_Paint: Boolean = false);
begin
  m_ChartBlockManager.SetColorSetIndex(p_Value, p_Paint);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.SetBound(p_Left: Integer; p_Top: Integer; p_Right: Integer; p_Bottom: Integer);
begin
  m_ChartBlockManager.SetBound(p_Left, p_Top, p_Right, p_Bottom);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.OnResize(p_Left: Integer; p_Top: Integer; p_Width: Integer; p_Height: Integer; p_Paint: Boolean);
begin
  m_ChartBlockManager.OnResize(p_Left, p_Top, p_Width, p_Height, p_Paint);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.RepaintDraw(p_Bitmap: TBitmap32);
begin
  m_ChartBlockManager.Clear;
  m_ChartBlockManager.Draw(p_Bitmap);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.Update(p_ChangedDailyGap: Boolean);
var
  nIndex: Integer;
  f_AddCount: Integer;
  f_Range: CMKMaxMin;
  f_Begin, f_End: Integer;
begin
  if not Assigned(m_MatrixBlockManager) then
    exit;

  if p_ChangedDailyGap then
  begin
    f_Range := m_ChartBlockManager.GetMaxMin();
    f_AddCount := m_MatrixBlockManager.m_ChartDataSeries.m_Items.Count - m_ChartDataSeries.m_Items.Count;
    if f_AddCount < 0 then
      f_AddCount := 0;

    if m_PriceSeries <> nil then
      m_PriceSeries.Clear;
    if m_MatrixSeries <> nil then
      m_MatrixSeries.Clear;
    if m_ChartDataSeries <> nil then
      m_ChartDataSeries.Clear;

    m_MatrixBlockManager.Lock;
    try
      m_ChartDataSeries.Update(m_MatrixBlockManager.m_ChartDataSeries);
    finally
      m_MatrixBlockManager.Unlock;
    end;

    m_ChartBlockManager.SetChartDataSeries(m_ChartDataSeries);

    if (m_ChartDataSeries.m_Items.Count > 0) then
    begin
      if m_PriceSeries = nil then
        m_PriceSeries := Creator_Price;

      if m_MatrixSeries = nil then
      begin
        m_MatrixSeries := Creator_MatrixSeries;
      end;

      m_MatrixBlockManager.Lock;
      try
        m_MatrixSeries.Update(m_MatrixBlockManager.m_MatrixSeries);
        m_MatrixSeries.m_ChartDataSeries := m_ChartDataSeries;
      finally
        m_MatrixBlockManager.Unlock;
      end;

      f_Begin := m_PriceSeries.m_Items.Count - 1;
      f_End := m_ChartDataSeries.m_Items.Count;

      m_PriceSeries.Indicator_RealPrice(m_ChartDataSeries, f_Begin, f_End);
      m_PriceSeries.GetLineMaxMin(0, m_PriceSeries.m_Items.Count - 1);
      m_PriceChartBlock.m_AbsMaxMin.m_XMin := 0;
      m_PriceChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
      m_PriceChartBlock.m_AbsMaxMin.m_YMin := m_PriceSeries.m_MaxMinTable[0].m_YMin;
      m_PriceChartBlock.m_AbsMaxMin.m_YMax := m_PriceSeries.m_MaxMinTable[0].m_YMax;

      m_MatrixSeries.GetLineMaxMin(0, m_MatrixSeries.m_Items.Count - 1);
      m_MatrixChartBlock.m_AbsMaxMin.m_XMin := 0;
      m_MatrixChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
      m_MatrixChartBlock.m_AbsMaxMin.m_YMin := m_MatrixSeries.m_MaxMinTable[0].m_YMin;
      m_MatrixChartBlock.m_AbsMaxMin.m_YMax := m_MatrixSeries.m_MaxMinTable[0].m_YMax;

      m_ChartBlockManager.RangeEnlarge(f_Range.m_XMin + f_AddCount, f_Range.m_XMax + f_AddCount);
      m_ChartBlockManager.RePaint;
      m_ChartBlockManager.TraceOnLastTime;
    end
    else
    begin
      m_ChartDataSeries.Clear;
      m_ChartBlockManager.DeleteChartAll;
      m_ChartBlockManager.RePaint;
      m_PriceSeries := NIL;
      m_MatrixSeries := NIL;
    end;
  end
  else
  begin
    if m_ChartDataSeries.m_Items.Count = 0 then
    begin
      m_MatrixBlockManager.Lock;
      try
        m_ChartDataSeries.Update(m_MatrixBlockManager.m_ChartDataSeries);
      finally
        m_MatrixBlockManager.Unlock;
      end;

      m_ChartBlockManager.SetChartDataSeries(m_ChartDataSeries);
      if (m_ChartDataSeries.m_Items.Count > 0) then
      begin
        m_ChartBlockManager.DeleteChartAll;
        m_ChartBlockManager.Clear;

        m_PriceSeries := Creator_Price;
        m_MatrixSeries := Creator_MatrixSeries;

        m_MatrixBlockManager.Lock;
        try
          m_MatrixSeries.Update(m_MatrixBlockManager.m_MatrixSeries);
          m_MatrixSeries.m_ChartDataSeries := m_ChartDataSeries;
        finally
          m_MatrixBlockManager.Unlock;
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

        m_MatrixChartBlock := m_ChartBlockManager.AddChart(m_MatrixSeries.m_FullName);
        m_MatrixChartBlock.AddObject(m_MatrixSeries);
        m_MatrixSeries.GetLineMaxMin(0, m_MatrixSeries.m_Items.Count - 1);
        m_MatrixChartBlock.m_AbsMaxMin.m_XMin := 0;
        m_MatrixChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
        m_MatrixChartBlock.m_AbsMaxMin.m_YMin := m_MatrixSeries.m_MaxMinTable[0].m_YMin;
        m_MatrixChartBlock.m_AbsMaxMin.m_YMax := m_MatrixSeries.m_MaxMinTable[0].m_YMax;

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
        m_MatrixSeries := NIL;
      end;
    end
    else
    begin
      f_Range := m_ChartBlockManager.GetMaxMin();
      f_AddCount := m_MatrixBlockManager.m_ChartDataSeries.m_Items.Count - m_ChartDataSeries.m_Items.Count;
      if f_AddCount < 0 then
        f_AddCount := 0;

      m_MatrixBlockManager.Lock;
      try
        m_ChartDataSeries.Update(m_MatrixBlockManager.m_ChartDataSeries);
      finally
        m_MatrixBlockManager.Unlock;
      end;

      m_ChartBlockManager.SetChartDataSeries(m_ChartDataSeries);

      if (m_ChartDataSeries.m_Items.Count > 0) then
      begin
        if m_PriceSeries = nil then
          m_PriceSeries := Creator_Price;
        if m_MatrixSeries = nil then
        begin
          m_MatrixSeries := Creator_MatrixSeries;
        end;

        m_MatrixBlockManager.Lock;
        try
          m_MatrixSeries.Update(m_MatrixBlockManager.m_MatrixSeries);
          m_MatrixSeries.m_ChartDataSeries := m_ChartDataSeries;
        finally
          m_MatrixBlockManager.Unlock;
        end;

        f_Begin := m_PriceSeries.m_Items.Count - 1;
        f_End := m_ChartDataSeries.m_Items.Count;
        m_PriceSeries.Indicator_RealPrice(m_ChartDataSeries, f_Begin, f_End);
        m_PriceSeries.GetLineMaxMin(0, m_PriceSeries.m_Items.Count - 1);
        m_PriceChartBlock.m_AbsMaxMin.m_XMin := 0;
        m_PriceChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
        m_PriceChartBlock.m_AbsMaxMin.m_YMin := m_PriceSeries.m_MaxMinTable[0].m_YMin;
        m_PriceChartBlock.m_AbsMaxMin.m_YMax := m_PriceSeries.m_MaxMinTable[0].m_YMax;

        m_MatrixSeries.GetLineMaxMin(0, m_MatrixSeries.m_Items.Count - 1);
        m_MatrixChartBlock.m_AbsMaxMin.m_XMin := 0;
        m_MatrixChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
        m_MatrixChartBlock.m_AbsMaxMin.m_YMin := m_MatrixSeries.m_MaxMinTable[0].m_YMin;
        m_MatrixChartBlock.m_AbsMaxMin.m_YMax := m_MatrixSeries.m_MaxMinTable[0].m_YMax;

        m_ChartBlockManager.RangeEnlarge(f_Range.m_XMin + f_AddCount, f_Range.m_XMax + f_AddCount);
        m_ChartBlockManager.RePaint;
        m_ChartBlockManager.TraceOnLastTime;
      end
      else
      begin
        m_ChartDataSeries.Clear;
        m_ChartBlockManager.DeleteChartAll;
        m_ChartBlockManager.RePaint;
        m_PriceSeries := NIL;
        m_MatrixSeries := NIL;
      end;
    end;
  end;

  m_ValueX := -1;
  if m_DrawTraceValueX >= 0 then
  begin
    // DrawTrace(m_DrawTraceChartIndex, m_DrawTraceValueX, m_DrawTraceValueY);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.SetChartType(p_Type: Integer; p_Paint: Boolean = false);
var
  f_ChartBlock: CFNMatrixChartBlock;
  f_ValueArray: CFNMatrixLineValueSeries;
  f_PriceArray: CFNMatrixLineValueSeries;
begin
  if (p_Type = 0) then
    m_ChartType := 0
  else if (p_Type = 1) then
    m_ChartType := 2
  else if (p_Type = 2) then
    m_ChartType := 1;

  if (not GetEnableChartControl) then
    exit;

  if ((p_Type >= 0) and (p_Type <= 2)) then
  begin
    m_ChartBlockManager.Clear;
    m_ChartBlockManager.m_ChartType := CFNMatrixConst.CHART_NORMAL;
    f_ChartBlock := m_ChartBlockManager.FindChart(g_IndicatorName[IND_PRICE_NAME]);
    if (f_ChartBlock <> NIL) then
    begin
      if (m_PriceSeries <> NIL) then
        m_PriceSeries.m_Options[0] := m_ChartType;
      if (m_PriceSeries <> NIL) then
        f_ChartBlock.ChangedLineMaxMin(m_PriceSeries);
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

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.OnControlPaintStage(Sender: TObject; Buffer: TBitmap32; StageNum: Cardinal);
begin
  m_ChartBlockManager.Draw(Buffer);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.SetScrollBar(AScrollBar: TScrollBar);
begin
  m_ScrollBar := AScrollBar;
  if m_ScrollBar = NIL then
    exit;

  m_ScrollBar.LargeChange := 30;
  m_ScrollBar.SmallChange := 1;
  m_ScrollBar.PageSize := 0;

  m_ScrollBar.OnScroll := OnHScroll;

  m_ChartBlockManager.SetScrollBar(m_ScrollBar);
end;

// ---------------------------------------------------------------------------
function CFNMatrixManageChartControl.GetEnableChartControl: Boolean;
begin
  Result := (m_ChartDataSeries.m_Items.Count > 0);
end;

// ---------------------------------------------------------------------------
// 스크롤 이벤트
procedure CFNMatrixManageChartControl.OnHScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if (GetEnableChartControl) then
    MyScrollMove(Sender, ScrollCode, ScrollPos);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.MyScrollMove(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
var
  f_OldPoint: Integer;
  f_NewPoint: Integer;
  f_NowPoint: Integer;
begin
  m_ChartBlockManager.OnHScroll(Sender, ScrollCode, ScrollPos);
  m_ChartBlockManager.RePaint;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.OnZoomIn;
begin
  if (GetEnableChartControl) then
    m_ChartBlockManager.Enlarge(1, true);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.OnZoomOut;
begin
  if (GetEnableChartControl) then
    m_ChartBlockManager.Enlarge(-1, true);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.OnZoomActual;
begin
  if (GetEnableChartControl) then
    m_ChartBlockManager.Enlarge(0, true);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.OnFullEnlarge;
begin
  if (GetEnableChartControl) then
    m_ChartBlockManager.FullEnlarge(true);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.MouseMoveHandler(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  if (GetEnableChartControl) then
  begin
    m_ChartBlockManager.OnMouseMove(X, Y);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.MouseDownHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  if (GetEnableChartControl) then
  begin
    m_ChartBlockManager.OnMouseDown(X, Y);
    Self.OnMouseUp := MouseUpHandler;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.MouseUpHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  if (GetEnableChartControl) then
  begin
    m_ChartBlockManager.OnMouseUp(X, Y);
    Self.OnMouseUp := NIL;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.SetScale(p_Value: Integer; p_Paint: Boolean = false);
begin
  m_Scale := p_Value;
  m_ChartBlockManager.SetScale(m_Scale);
  if (p_Paint) then
  begin
    m_ChartBlockManager.RePaint;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.SetTraceVisible(p_Value: Boolean; p_Paint: Boolean = false);
begin
  m_ChartBlockManager.SetTraceVisible(p_Value, p_Paint);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.DrawTrace(p_ChartIndex: Integer; p_ValueX: Double; p_ValueY: Double);
begin
  m_ValueX := Round(p_ValueX);
  m_DrawTraceChartIndex := p_ChartIndex;
  m_DrawTraceValueX := p_ValueX;
  m_DrawTraceValueY := p_ValueY;
  m_ChartBlockManager.DrawTrace(p_ChartIndex, p_ValueX, p_ValueY);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixManageChartControl.GetChartMaxMin(var p_Min, p_Max: Double);
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
