unit FNNAVAnalChartControl;

interface

uses
  SysUtils, Classes, Controls, GR32_Image, GR32, Types, Messages, Graphics,
  DateUtils, Dialogs, Math,
  StdCtrls, Windows,
  FNNAVAnalLineValueSeries, FNNAVAnalLineValueSeriesCreator,
  FNNAVAnalChartDataSeries,
  FNDataSet, FNNAVAnalChartData, FNQueue,
  GR32_Layers, FNNAVAnalConst, FNNAVAnalMaxMin, FNNAVAnalColorSet,
  FNNAVAnalChartBlockManager, FNNAVAnalChartBlock,
  FNNAVAnalChartTraceEvent, FNNAVAnalChartControlBase, FNNAVAnalLineValue;

type
  CFNNAVAnalChartControl = class(CFNNAVAnalChartControlBase)
  private
    m_ChartBlockManager: CFNNAVAnalChartBlockManager;
    m_NAVChartBlock: CFNNAVAnalChartBlock;

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
    m_ChartDataSeries: CFNNAVAnalChartDataSeries;
    m_NAVSeries: CFNNAVAnalLineValueSeries;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Initialize;
    procedure Finalize;

    procedure Clear;

    function GetEnableChartControl: Boolean;

    procedure SetChartDataSeries(p_ChartDataSeries: CFNNAVAnalChartDataSeries; p_NAVSeries: CFNNAVAnalLineValueSeries);

    procedure OnResize(p_Left: Integer; p_Top: Integer; p_Width: Integer; p_Height: Integer; p_Paint: Boolean);
    procedure SetBound(p_Left: Integer; p_Top: Integer; p_Right: Integer; p_Bottom: Integer);
    procedure RepaintDraw(p_Bitmap: TBitmap32);

    procedure SetColorSetIndex(p_Value: Integer; p_Paint: Boolean = false);
    procedure SetScale(p_Value: Integer; p_Paint: Boolean = false);
    procedure SetTraceVisible(p_Value: Boolean; p_Paint: Boolean = false);

    procedure OnZoomIn;
    procedure OnZoomOut;
    procedure OnZoomActual;
    procedure OnFullEnlarge;
    procedure DrawTrace(p_ChartIndex: Integer; p_ValueX: Double; p_ValueY: Double);

    procedure OnControlPaintStage(Sender: TObject; Buffer: TBitmap32; StageNum: Cardinal);

    procedure GetChartMaxMin(var p_Min, p_Max: Double);
    procedure OnHScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);

  private

    m_VisibleDrawDown2: Boolean;

  public
    procedure SetVisibleDrawDown2(p_Value: Boolean);

  published
    property ScrollBar: TScrollBar read m_ScrollBar write SetScrollBar;

  end;

procedure Register;

implementation

uses
  FNGlobal, FNGlobalVariable, FNNAVAnalChartDefine;

procedure Register;
begin
  RegisterComponents('ATPackage', [CFNNAVAnalChartControl]);
end;

// ---------------------------------------------------------------------------
constructor CFNNAVAnalChartControl.Create(AOwner: TComponent);
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
destructor CFNNAVAnalChartControl.Destroy;
begin
  Finalize;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.Initialize;
begin
  m_ChartDataSeries := CFNNAVAnalChartDataSeries.Create;

  m_ChartBlockManager := CFNNAVAnalChartBlockManager.Create;
  m_ChartBlockManager.SetChartControl(Self);
  m_ChartBlockManager.SetLayer;

  m_NAVSeries := Creator_NAV;

  SetColorSetIndex(CFNNAVAnalConst.COLOR_SET_WHITE, false);
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
procedure CFNNAVAnalChartControl.Finalize;
begin
  m_ChartBlockManager.ClearChartAll;

  if Assigned(m_ChartDataSeries) then
  begin
    m_ChartDataSeries.Free;
    m_ChartDataSeries := NIL;
  end;

  if Assigned(m_NAVSeries) then
  begin
    m_NAVSeries := NIL;
  end;

  if Assigned(m_ChartBlockManager) then
  begin
    m_ChartBlockManager.Free;
    m_ChartBlockManager := NIL;
  end;
  m_Initialized := false;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.Clear;
begin
  m_ChartDataSeries.Clear;
  if (m_NAVSeries <> NIL) then
    m_NAVSeries.Clear;

  m_ChartBlockManager.ClearChartAll;
  m_ChartBlockManager.RePaint;
  m_NAVSeries := NIL;

end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.WMSize(var Message: TWMSize);
begin
  if (m_Initialized) then
    OnResize(0, 0, Width, Height, true);

  Self.Resize;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.SetColorSetIndex(p_Value: Integer; p_Paint: Boolean = false);
begin
  m_ChartBlockManager.SetColorSetIndex(p_Value, p_Paint);
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.SetBound(p_Left: Integer; p_Top: Integer; p_Right: Integer; p_Bottom: Integer);
begin
  m_ChartBlockManager.SetBound(p_Left, p_Top, p_Right, p_Bottom);
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.OnResize(p_Left: Integer; p_Top: Integer; p_Width: Integer; p_Height: Integer; p_Paint: Boolean);
begin
  m_ChartBlockManager.OnResize(p_Left, p_Top, p_Width, p_Height, p_Paint);
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.RepaintDraw(p_Bitmap: TBitmap32);
begin
  m_ChartBlockManager.Clear;
  m_ChartBlockManager.Draw(p_Bitmap);
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.SetChartDataSeries(p_ChartDataSeries: CFNNAVAnalChartDataSeries; p_NAVSeries: CFNNAVAnalLineValueSeries);
var
  f_LineSeries: CFNNAVAnalLineValueSeries;
  f_ChartBlock: CFNNAVAnalChartBlock;
  f_ValueIndex: Integer;
  f_TagValue: CFNNAVAnalLineValue;
  f_SrcValue: CFNNAVAnalLineValue;
begin
  m_ChartDataSeries.Clear;
  m_ChartDataSeries.Clone(p_ChartDataSeries);

  m_ChartBlockManager.m_ChartDataSeries := m_ChartDataSeries;

  m_ChartBlockManager.DeleteChartAll;
  m_ChartBlockManager.Clear;

  f_ChartBlock := m_ChartBlockManager.AddChart('수익곡선');
  f_ChartBlock.SetChartDataSeries(m_ChartDataSeries);

  f_LineSeries := Creator_NAV;
  f_LineSeries.Update(p_NAVSeries);
  f_LineSeries.m_ChartDataSeries := m_ChartDataSeries;
  f_LineSeries.GetLineMaxMin(0, f_LineSeries.m_Items.Count - 1);
  f_LineSeries.m_Precision := 2;

  f_ChartBlock.m_AbsMaxMin.m_XMin := 0;
  f_ChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
  f_ChartBlock.m_AbsMaxMin.m_YMin := f_LineSeries.m_MaxMinTable[0].m_YMin;
  f_ChartBlock.m_AbsMaxMin.m_YMax := f_LineSeries.m_MaxMinTable[0].m_YMax;

  f_ChartBlock.AddObject(f_LineSeries);

  f_ChartBlock := m_ChartBlockManager.AddChart('전체 DrawDown');
  f_ChartBlock.SetChartDataSeries(m_ChartDataSeries);

  f_LineSeries := Creator_DrawDown;
  // f_LineSeries.Update(p_NAVSeries);
  f_LineSeries.SetLengthSeries(p_NAVSeries.m_Items.Count);

  for f_ValueIndex := 0 to p_NAVSeries.m_Items.Count - 1 do
  begin
    f_SrcValue := p_NAVSeries.m_Items[f_ValueIndex];
    f_TagValue := f_LineSeries.m_Items[f_ValueIndex];

    f_TagValue.m_Value[0] := f_SrcValue.m_Value[NAV_TDRAWDOWN1];
    f_TagValue.m_Value[1] := f_SrcValue.m_Value[NAV_TDRAWDOWN2];
    f_TagValue.m_Value[2] := f_SrcValue.m_Value[NAV_TDRAWDOWN1MA3];

  end;
  f_LineSeries.m_Effect := true;

  f_LineSeries.m_ChartDataSeries := m_ChartDataSeries;
  f_LineSeries.GetLineMaxMin(0, f_LineSeries.m_Items.Count - 1);
  f_LineSeries.m_Precision := 2;

  f_ChartBlock.m_AbsMaxMin.m_XMin := 0;
  f_ChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
  f_ChartBlock.m_AbsMaxMin.m_YMin := f_LineSeries.m_MaxMinTable[0].m_YMin;
  f_ChartBlock.m_AbsMaxMin.m_YMax := f_LineSeries.m_MaxMinTable[0].m_YMax;

  f_ChartBlock.AddObject(f_LineSeries);

  f_ChartBlock := m_ChartBlockManager.AddChart('매수 DrawDown');
  f_ChartBlock.SetChartDataSeries(m_ChartDataSeries);

  f_LineSeries := Creator_DrawDown;
  // f_LineSeries.Update(p_NAVSeries);
  f_LineSeries.SetLengthSeries(p_NAVSeries.m_Items.Count);

  for f_ValueIndex := 0 to p_NAVSeries.m_Items.Count - 1 do
  begin
    f_SrcValue := p_NAVSeries.m_Items[f_ValueIndex];
    f_TagValue := f_LineSeries.m_Items[f_ValueIndex];

    f_TagValue.m_Value[0] := f_SrcValue.m_Value[NAV_BDRAWDOWN1];
    f_TagValue.m_Value[1] := f_SrcValue.m_Value[NAV_BDRAWDOWN2];
    f_TagValue.m_Value[2] := f_SrcValue.m_Value[NAV_BDRAWDOWN1MA3];

  end;
  f_LineSeries.m_Effect := true;

  f_LineSeries.m_ChartDataSeries := m_ChartDataSeries;
  f_LineSeries.GetLineMaxMin(0, f_LineSeries.m_Items.Count - 1);
  f_LineSeries.m_Precision := 2;

  f_ChartBlock.m_AbsMaxMin.m_XMin := 0;
  f_ChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
  f_ChartBlock.m_AbsMaxMin.m_YMin := f_LineSeries.m_MaxMinTable[0].m_YMin;
  f_ChartBlock.m_AbsMaxMin.m_YMax := f_LineSeries.m_MaxMinTable[0].m_YMax;

  f_ChartBlock.AddObject(f_LineSeries);

  f_ChartBlock := m_ChartBlockManager.AddChart('매도 DrawDown');
  f_ChartBlock.SetChartDataSeries(m_ChartDataSeries);

  f_LineSeries := Creator_DrawDown;
  // f_LineSeries.Update(p_NAVSeries);
  f_LineSeries.SetLengthSeries(p_NAVSeries.m_Items.Count);

  for f_ValueIndex := 0 to p_NAVSeries.m_Items.Count - 1 do
  begin
    f_SrcValue := p_NAVSeries.m_Items[f_ValueIndex];
    f_TagValue := f_LineSeries.m_Items[f_ValueIndex];

    f_TagValue.m_Value[0] := f_SrcValue.m_Value[NAV_SDRAWDOWN1];
    f_TagValue.m_Value[1] := f_SrcValue.m_Value[NAV_SDRAWDOWN2];
    f_TagValue.m_Value[2] := f_SrcValue.m_Value[NAV_SDRAWDOWN1MA3];

  end;
  f_LineSeries.m_Effect := true;

  f_LineSeries.m_ChartDataSeries := m_ChartDataSeries;
  f_LineSeries.GetLineMaxMin(0, f_LineSeries.m_Items.Count - 1);
  f_LineSeries.m_Precision := 2;

  f_ChartBlock.m_AbsMaxMin.m_XMin := 0;
  f_ChartBlock.m_AbsMaxMin.m_XMax := m_ChartDataSeries.m_Items.Count - 1;
  f_ChartBlock.m_AbsMaxMin.m_YMin := f_LineSeries.m_MaxMinTable[0].m_YMin;
  f_ChartBlock.m_AbsMaxMin.m_YMax := f_LineSeries.m_MaxMinTable[0].m_YMax;

  f_ChartBlock.AddObject(f_LineSeries);

  m_ChartBlockManager.SetVisibleXLabel(true);
  m_ChartBlockManager.LayOut;
  m_ChartBlockManager.FullEnlarge(false);

  m_ChartBlockManager.RePaint;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.OnControlPaintStage(Sender: TObject; Buffer: TBitmap32; StageNum: Cardinal);
begin
  m_ChartBlockManager.Draw(Buffer);
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.SetScrollBar(AScrollBar: TScrollBar);
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
function CFNNAVAnalChartControl.GetEnableChartControl: Boolean;
begin
  Result := (m_ChartDataSeries.m_Items.Count > 0);
end;

// ---------------------------------------------------------------------------
// 스크롤 이벤트
procedure CFNNAVAnalChartControl.OnHScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if (GetEnableChartControl) then
    MyScrollMove(Sender, ScrollCode, ScrollPos);
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.MyScrollMove(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
var
  f_OldPoint: Integer;
  f_NewPoint: Integer;
  f_NowPoint: Integer;
begin
  m_ChartBlockManager.OnHScroll(Sender, ScrollCode, ScrollPos);
  m_ChartBlockManager.RePaint;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.OnZoomIn;
begin
  if (GetEnableChartControl) then
    m_ChartBlockManager.Enlarge(1, true);
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.OnZoomOut;
begin
  if (GetEnableChartControl) then
    m_ChartBlockManager.Enlarge(-1, true);
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.OnZoomActual;
begin
  if (GetEnableChartControl) then
    m_ChartBlockManager.Enlarge(0, true);
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.OnFullEnlarge;
begin
  if (GetEnableChartControl) then
    m_ChartBlockManager.FullEnlarge(true);
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.MouseMoveHandler(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  if (GetEnableChartControl) then
  begin
    m_ChartBlockManager.OnMouseMove(X, Y);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.MouseDownHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  if (GetEnableChartControl) then
  begin
    m_ChartBlockManager.OnMouseDown(X, Y);
    Self.OnMouseUp := MouseUpHandler;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.MouseUpHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  if (GetEnableChartControl) then
  begin
    m_ChartBlockManager.OnMouseUp(X, Y);
    Self.OnMouseUp := NIL;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.SetScale(p_Value: Integer; p_Paint: Boolean = false);
begin
  m_Scale := p_Value;
  m_ChartBlockManager.SetScale(m_Scale);
  if (p_Paint) then
  begin
    m_ChartBlockManager.RePaint;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.SetTraceVisible(p_Value: Boolean; p_Paint: Boolean = false);
begin
  m_ChartBlockManager.SetTraceVisible(p_Value, p_Paint);
end;

procedure CFNNAVAnalChartControl.SetVisibleDrawDown2(p_Value: Boolean);
begin
  m_VisibleDrawDown2 := p_Value;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.DrawTrace(p_ChartIndex: Integer; p_ValueX: Double; p_ValueY: Double);
begin
  m_ValueX := Round(p_ValueX);
  m_DrawTraceChartIndex := p_ChartIndex;
  m_DrawTraceValueX := p_ValueX;
  m_DrawTraceValueY := p_ValueY;
  m_ChartBlockManager.DrawTrace(p_ChartIndex, p_ValueX, p_ValueY);
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartControl.GetChartMaxMin(var p_Min, p_Max: Double);
begin
  if Assigned(m_NAVChartBlock) then
  begin
    if (m_NAVChartBlock.m_MaxMin.m_YMin < m_NAVChartBlock.m_MaxMin.m_YMax) then
    begin
      p_Min := m_NAVChartBlock.m_MaxMin.m_YMin;
      p_Max := m_NAVChartBlock.m_MaxMin.m_YMax;
    end;
  end;
end;

end.
