unit MKAVCrossLine;

interface

uses
  SysUtils, Types, Classes, Math, GR32, StdCtrls, Messages, Windows, GR32_Layers, Contnrs, ExtCtrls,
  MKStreamChartDataSeries, MKColorSet, MKConst, MKMaxMin, FNQueue, FNThread, SyncObjs,
  MKChartData, MKLineValueSeries,
  MKAVDrawingObject;

type
  /// /////////////////////////////////////////////////////////////////////////
  //
  CMKAVCrossLine = class(CMKAVDrawingObject)
  private
    m_XDate: TDateTime;
    m_X: Double;
    m_Y: Double;
    m_OldX: Double;
    m_OldY: Double;
    m_NewX: Double;
    m_NewY: Double;
    m_Step: Integer;
    m_Hit: Boolean;

  public

    constructor Create();
    destructor Destroy(); override;

    procedure XValueToDate(); override;
    procedure XDateToValue(); override;
    procedure DrawDefaultLayer(p_Bitmap: TBitmap32); override;
    procedure Clear(); override;

    function HitTest(p_X: Integer; p_Y: Integer): Boolean; override;
    procedure OnMouseDown(p_X: Integer; p_Y: Integer); override;
    procedure OnMouseUp(p_X: Integer; p_Y: Integer); override;
    procedure OnMouseMove(p_X: Integer; p_Y: Integer); override;

    procedure ClearText();
  end;

implementation

uses
  MKGlobal, MKChartDefine, MKAVDrawManager, MKAVChartBlock;

/// //////////////////////////////////////////////////////////////////////////
// CMKAVVLine
// ---------------------------------------------------------------------------
constructor CMKAVCrossLine.Create();
begin
  inherited Create;

  m_Step := 0;
  m_Hit := false;
end;

// ---------------------------------------------------------------------------
destructor CMKAVCrossLine.Destroy();
begin
  ClearText();

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CMKAVCrossLine.Clear();
begin
  ClearText();
  if (m_Drawing) then
  begin
    if (m_Selected) then
    begin

    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVCrossLine.ClearText;
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVCrossLine.XValueToDate;
begin
  if (m_X >= 0) then
    m_XDate := GetDate(Math.Floor(m_X));
end;

// ---------------------------------------------------------------------------
procedure CMKAVCrossLine.XDateToValue;
begin
  m_X := GetIndex(m_XDate);
end;

// ---------------------------------------------------------------------------
function CMKAVCrossLine.HitTest(p_X, p_Y: Integer): Boolean;
var
  f_DX1: Integer;
  f_DX2: Integer;
  f_DY1: Double;
  f_DY2: Double;
begin
  f_DX1 := GetRealX(p_X - m_SelectMaxMin);
  f_DX2 := GetRealX(p_X + m_SelectMaxMin);
  f_DY1 := GetRealY(p_Y + m_SelectMaxMin);
  f_DY2 := GetRealY(p_Y - m_SelectMaxMin);
  m_Hit := false;

  if ((f_DX1 <= m_X) and (m_X <= f_DX2) or (f_DY1 <= m_Y) and (m_Y <= f_DY2)) then
  begin
    m_Hit := true;
  end;

  Result := m_Hit;
end;

// ---------------------------------------------------------------------------
procedure CMKAVCrossLine.OnMouseDown(p_X, p_Y: Integer);
begin
  if (m_Drawing) then
  begin
    m_X := Round(GetRealX(p_X));
    if (m_X < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
      m_X := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin;
    if (m_X > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
      m_X := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax;

    m_OldX := m_X;
    m_Y := GetRealY(p_Y);
    m_OldY := m_Y;
    CMKAVDrawManager(m_Manager).SetSelected(Self);

    m_Step := 1;
    XValueToDate();
  end
  else
  begin
    m_CaptureMouse := true;
    m_OldX := Round(GetRealX(p_X));
    m_OldY := GetRealY(p_Y);
    CMKAVDrawManager(m_Manager).SetSelected(Self);
  end;
  m_DefaultLayer.Update();
end;

// ---------------------------------------------------------------------------
procedure CMKAVCrossLine.OnMouseUp(p_X, p_Y: Integer);
begin
  if (m_Drawing) then
  begin
    m_X := Round(GetRealX(p_X));
    m_Y := GetRealY(p_Y);

    if (m_X < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
      m_X := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin;
    if (m_X > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
      m_X := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax;

    m_Drawing := false;
    CMKAVDrawManager(m_Manager).CompleteDrawObject();
    m_Step := 2;
    XValueToDate();
  end;

  m_CaptureMouse := false;
end;

// ---------------------------------------------------------------------------
procedure CMKAVCrossLine.OnMouseMove(p_X, p_Y: Integer);
begin
  if (m_Drawing and (m_Step = 1)) then
  begin
    m_X := Round(GetRealX(p_X));
    m_Y := GetRealY(p_Y);

    if (m_X < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
      m_X := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin;
    if (m_X > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
      m_X := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax;

    XValueToDate();
  end
  else
  begin
    if (m_CaptureMouse and m_Selected) then
    begin
      m_NewX := Round(GetRealX(p_X));
      m_NewY := GetRealY(p_Y);

      if (m_X + (m_NewX - m_OldX) < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
        exit;
      if (m_X + (m_NewX - m_OldX) > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
        exit;

      m_X := m_X + (m_NewX - m_OldX);
      m_Y := m_Y + (m_NewY - m_OldY);
      m_OldX := m_NewX;
      m_OldY := m_NewY;

      XValueToDate();
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVCrossLine.DrawDefaultLayer(p_Bitmap: TBitmap32);
var
  f_X, f_Y: Integer;
  f_X1, f_X2: Integer;
  f_Y1, f_Y2: Integer;
  f_Label: String;
  f_ChartData: CMKChartData;

  f_Width: Integer;
  f_Height: Integer;
  f_PenColor: TColor32;
begin
  if CMKChartBlock(m_ChartBlock).m_ChartDataSeries = NIL then
    exit;
  if (m_X < 0) then
    exit;

  p_Bitmap.Font.Name := m_Font;
  p_Bitmap.Font.Size := m_FontSize;
  p_Bitmap.Font.Style := [];
  p_Bitmap.Font.Color := m_FontColor;

  f_Width := TMKGlobal.RectToWidth(CMKChartBlock(m_ChartBlock).m_AxisRect);
  f_Height := TMKGlobal.RectToHeight(CMKChartBlock(m_ChartBlock).m_AxisRect);

  f_X := GetScreenXCenter(m_X);
  f_Y := Math.Floor(GetScreenY(m_Y));
  f_X1 := CMKChartBlock(m_ChartBlock).m_AxisRect.Left;
  f_X2 := CMKChartBlock(m_ChartBlock).m_AxisRect.Left + f_Width;
  f_Y1 := CMKChartBlock(m_ChartBlock).m_AxisRect.Top;
  f_Y2 := CMKChartBlock(m_ChartBlock).m_AxisRect.Top + f_Height;

  if (m_Selected) then
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);

    p_Bitmap.PenColor := f_PenColor;
    p_Bitmap.MoveTo(f_X, f_Y1);
    p_Bitmap.LineToAS(f_X, f_Y2);
    p_Bitmap.MoveTo(f_X1, f_Y);
    p_Bitmap.LineToAS(f_X2, f_Y);

    DrawBox(p_Bitmap, f_X - m_SelectMaxMin, f_Y - m_SelectMaxMin, f_X + m_SelectMaxMin, f_Y + m_SelectMaxMin, 1);
    if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_Items.Count > Round(m_X)) then
    begin
      f_ChartData := CMKChartData(CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_Items.Items[Round(m_X)]);
      f_Label := TMKGlobal.DateToYYYY_MM_DD(f_ChartData.m_Year, f_ChartData.m_Month, f_ChartData.m_Day);
      if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_TimeFrame < 360) then
      begin
        f_Label := f_Label + ' ' + TMKGlobal.TimeToHH_MM(f_ChartData.m_Hour, f_ChartData.m_Min);
      end
      else if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_TimeFrame > 9000) then
      begin
        f_Label := f_Label + ' ' + TMKGlobal.TimeToHH_MM_SS(f_ChartData.m_Hour, f_ChartData.m_Min, f_ChartData.m_Sec);
      end;
      f_Y2 := f_Y2 - (p_Bitmap.TextHeight(f_Label) + 6);
      DrawText(p_Bitmap, f_Label, f_X + 2, f_Y2, 0, 1);
    end;

    f_Label := TMKGlobal.NumberToString(m_Y, 2);
    f_X2 := f_X2 - (p_Bitmap.TextWidth(f_Label) + 3);
    DrawText(p_Bitmap, f_Label, f_X2, f_Y + 2, 1, 0);
  end
  else
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);

    p_Bitmap.PenColor := f_PenColor;
    p_Bitmap.MoveTo(f_X, f_Y1);
    p_Bitmap.LineToAS(f_X, f_Y2);
    p_Bitmap.MoveTo(f_X1, f_Y);
    p_Bitmap.LineToAS(f_X2, f_Y);

    if m_Hit then
    begin
      DrawBox(p_Bitmap, f_X - m_SelectMaxMin, f_Y - m_SelectMaxMin, f_X + m_SelectMaxMin, f_Y + m_SelectMaxMin, 0);
    end;
  end;
end;

end.
