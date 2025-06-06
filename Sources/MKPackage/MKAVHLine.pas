unit MKAVHLine;

interface

uses
  SysUtils, Types, Classes, Math, GR32, StdCtrls, Messages, Windows, GR32_Layers, Contnrs, ExtCtrls,
  MKStreamChartDataSeries, MKColorSet, MKConst, MKMaxMin, FNQueue, FNThread, SyncObjs,
  MKChartData, MKLineValueSeries,
  MKAVDrawingObject;

type
  /// /////////////////////////////////////////////////////////////////////////
  //
  CMKAVHLine = class(CMKAVDrawingObject)
  private
    m_Y: Double;
    m_OldY: Double;
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
constructor CMKAVHLine.Create();
begin
  inherited Create;

  m_Step := 0;
  m_Hit := false;
end;

// ---------------------------------------------------------------------------
destructor CMKAVHLine.Destroy();
begin
  ClearText();

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CMKAVHLine.Clear();
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
procedure CMKAVHLine.ClearText;
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVHLine.XValueToDate;
begin
end;

// ---------------------------------------------------------------------------
procedure CMKAVHLine.XDateToValue;
begin
end;

// ---------------------------------------------------------------------------
function CMKAVHLine.HitTest(p_X, p_Y: Integer): Boolean;
var
  f_DY1: Double;
  f_DY2: Double;
begin
  f_DY1 := GetRealY(p_Y + m_SelectMaxMin);
  f_DY2 := GetRealY(p_Y - m_SelectMaxMin);
  m_Hit := false;

  if ((f_DY1 <= m_Y) and (m_Y <= f_DY2)) then
  begin
    m_Hit := true;
  end;

  Result := m_Hit;
end;

// ---------------------------------------------------------------------------
procedure CMKAVHLine.OnMouseDown(p_X, p_Y: Integer);
begin
  if (m_Drawing) then
  begin
    m_Y := GetRealY(p_Y);
    m_OldY := GetRealY(p_Y);
    CMKAVDrawManager(m_Manager).SetSelected(Self);

    m_Step := 1;
    XValueToDate();
  end
  else
  begin
    m_CaptureMouse := true;
    m_OldY := GetRealY(p_Y);
    CMKAVDrawManager(m_Manager).SetSelected(Self);
  end;
  m_DefaultLayer.Update();
end;

// ---------------------------------------------------------------------------
procedure CMKAVHLine.OnMouseUp(p_X, p_Y: Integer);
begin
  if (m_Drawing) then
  begin
    m_Y := GetRealY(p_Y);
    m_Drawing := false;
    CMKAVDrawManager(m_Manager).CompleteDrawObject();
    m_Step := 2;
    XValueToDate();
  end;

  m_CaptureMouse := false;
end;

// ---------------------------------------------------------------------------
procedure CMKAVHLine.OnMouseMove(p_X, p_Y: Integer);
begin
  if (m_Drawing and (m_Step = 1)) then
  begin
    m_Y := GetRealY(p_Y);

    XValueToDate();
  end
  else
  begin
    if (m_CaptureMouse and m_Selected) then
    begin
      m_NewY := GetRealY(p_Y);
      m_Y := m_Y + (m_NewY - m_OldY);
      m_OldY := m_NewY;

      XValueToDate();
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVHLine.DrawDefaultLayer(p_Bitmap: TBitmap32);
var
  f_Y: Integer;
  f_X1, f_X2: Integer;
  f_IndPos: Integer;
  f_Label: String;
  f_ChartData: CMKChartData;

  f_Width: Integer;
  f_PenColor: TColor32;
begin
  if CMKChartBlock(m_ChartBlock).m_ChartDataSeries = NIL then
    exit;
  p_Bitmap.Font.Name := m_Font;
  p_Bitmap.Font.Size := m_FontSize;
  p_Bitmap.Font.Style := [];
  p_Bitmap.Font.Color := m_FontColor;

  f_Width := TMKGlobal.RectToWidth(CMKChartBlock(m_ChartBlock).m_AxisRect);

  f_Y := Math.Floor(GetScreenY(m_Y));
  f_X1 := CMKChartBlock(m_ChartBlock).m_AxisRect.Left;
  f_X2 := CMKChartBlock(m_ChartBlock).m_AxisRect.Left + f_Width;

  if (m_Selected) then
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);

    p_Bitmap.PenColor := f_PenColor;
    p_Bitmap.MoveTo(f_X1, f_Y);
    p_Bitmap.LineToAS(f_X2, f_Y);

    f_IndPos := Math.Floor(CMKChartBlock(m_ChartBlock).m_AxisRect.Top + f_Width / 3);
    DrawBox(p_Bitmap, f_IndPos - m_SelectMaxMin, f_Y - m_SelectMaxMin, f_IndPos + m_SelectMaxMin, f_Y + m_SelectMaxMin, 1);

    f_IndPos := Math.Floor(CMKChartBlock(m_ChartBlock).m_AxisRect.Top + f_Width * 2 / 3);
    DrawBox(p_Bitmap, f_IndPos - m_SelectMaxMin, f_Y - m_SelectMaxMin, f_IndPos + m_SelectMaxMin, f_Y + m_SelectMaxMin, 1);

    f_Label := TMKGlobal.NumberToString(m_Y, 2);

    f_X2 := f_X2 - (p_Bitmap.TextWidth(f_Label) + 3);
    DrawText(p_Bitmap, f_Label, f_X2, f_Y + 2, 1, 0);
  end
  else
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);

    p_Bitmap.PenColor := f_PenColor;
    p_Bitmap.MoveTo(f_X1, f_Y);
    p_Bitmap.LineToAS(f_X2, f_Y);

    if (m_Hit) then
    begin
      f_IndPos := Math.Floor(CMKChartBlock(m_ChartBlock).m_AxisRect.Top + f_Width / 3);
      DrawBox(p_Bitmap, f_IndPos - m_SelectMaxMin, f_Y - m_SelectMaxMin, f_IndPos + m_SelectMaxMin, f_Y + m_SelectMaxMin, 0);
      f_IndPos := Math.Floor(CMKChartBlock(m_ChartBlock).m_AxisRect.Top + f_Width * 2 / 3);
      DrawBox(p_Bitmap, f_IndPos - m_SelectMaxMin, f_Y - m_SelectMaxMin, f_IndPos + m_SelectMaxMin, f_Y + m_SelectMaxMin, 0);
    end;
  end;
end;

end.
