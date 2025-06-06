unit MKAVGannFan;

interface

uses
  SysUtils, Types, Classes, Math, GR32, StdCtrls, Messages, Windows, GR32_Layers, Contnrs, ExtCtrls,
  MKStreamChartDataSeries, MKColorSet, MKConst, MKMaxMin, FNQueue, FNThread, SyncObjs,
  MKChartData, MKLineValueSeries,
  MKAVDrawingObject;

type
  /// /////////////////////////////////////////////////////////////////////////
  //
  CMKAVGannFan = class(CMKAVDrawingObject)
  private
    m_X1Date: TDateTime;
    m_X: Double;
    m_Y: Double;
    m_OldX: Double;
    m_OldY: Double;
    m_NewX: Double;
    m_NewY: Double;
    m_Step: Integer;
    m_GannAngleArray: Array [0 .. 8] of Double;
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

    procedure DrawAngleLine(p_MC: TBitmap32; angle: Double; cx: Integer; cy: Integer);
    procedure ClearText();
  end;

implementation

uses
  MKGlobal, MKChartDefine, MKAVDrawManager, MKAVChartBlock;

/// //////////////////////////////////////////////////////////////////////////
// CMKAVVLine
// ---------------------------------------------------------------------------
constructor CMKAVGannFan.Create();
begin
  inherited Create;

  m_Step := 0;
  m_GannAngleArray[0] := 82.5;
  m_GannAngleArray[1] := 75;
  m_GannAngleArray[2] := 71.25;
  m_GannAngleArray[3] := 63.75;
  m_GannAngleArray[4] := 45;
  m_GannAngleArray[5] := 26.25;
  m_GannAngleArray[6] := 18.75;
  m_GannAngleArray[7] := 15;
  m_GannAngleArray[8] := 7.5;

  m_Hit := false;
end;

// ---------------------------------------------------------------------------
destructor CMKAVGannFan.Destroy();
begin
  ClearText();

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CMKAVGannFan.Clear();
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
procedure CMKAVGannFan.ClearText;
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVGannFan.XValueToDate;
begin
  if (m_X >= 0) then
    m_X1Date := GetDate(Math.Floor(m_X));
end;

// ---------------------------------------------------------------------------
procedure CMKAVGannFan.XDateToValue;
begin
  m_X := GetIndex(m_X1Date);
end;

procedure CMKAVGannFan.DrawAngleLine(p_MC: TBitmap32; angle: Double; cx: Integer; cy: Integer);
var
  f_ex: Integer;
  f_ey: Integer;
  f_wi: Integer;
  f_he: Integer;
  f_radian: Double;
begin
  f_radian := PI * angle / 180;
  f_wi := CMKChartBlock(m_ChartBlock).m_AxisRect.Left + TMKGlobal.RectToWidth(CMKChartBlock(m_ChartBlock).m_AxisRect) - cx;
  f_he := cy - CMKChartBlock(m_ChartBlock).m_AxisRect.Top;

  if (f_wi < (f_he / Math.tan(f_radian))) then
  begin
    f_ex := Math.Floor(cx + f_wi);
    f_ey := Math.Floor(cy - f_wi * Math.tan(f_radian));
  end
  else
  begin
    f_ex := Math.Floor(cx + f_he / Math.tan(f_radian));
    f_ey := Math.Floor(cy - f_he);
  end;

  p_MC.MoveTo(cx, cy);
  p_MC.LineToAS(f_ex, f_ey);
end;

// ---------------------------------------------------------------------------
function CMKAVGannFan.HitTest(p_X, p_Y: Integer): Boolean;
var
  f_DX1: Integer;
  f_DX2: Integer;
  f_DY1: Double;
  f_DY2: Double;
begin
  m_Hit := false;

  f_DX1 := GetRealX(p_X - m_SelectMaxMin);
  f_DX2 := GetRealX(p_X + m_SelectMaxMin);
  f_DY1 := GetRealY(p_Y + m_SelectMaxMin);
  f_DY2 := GetRealY(p_Y - m_SelectMaxMin);

  if ((f_DX1 <= m_X) and (m_X <= f_DX2) and (f_DY1 <= m_Y) and (m_Y <= f_DY2)) then
  begin
    m_Hit := true;
  end;

  Result := m_Hit;
end;

// ---------------------------------------------------------------------------
procedure CMKAVGannFan.OnMouseDown(p_X, p_Y: Integer);
begin
  if (m_Drawing) then
  begin
    m_X := GetRealX(p_X);
    m_Y := GetRealY(p_Y);

    if (m_X < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
      m_X := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin;
    if (m_X > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
      m_X := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax;

    m_OldX := m_X;
    m_OldY := m_Y;
    CMKAVDrawManager(m_Manager).SetSelected(Self);

    m_Step := 1;
    XValueToDate();
  end
  else
  begin
    m_CaptureMouse := true;
    m_OldX := GetRealX(p_X);
    m_OldY := GetRealY(p_Y);
    CMKAVDrawManager(m_Manager).SetSelected(Self);
  end;
  m_DefaultLayer.Update();
end;

// ---------------------------------------------------------------------------
procedure CMKAVGannFan.OnMouseUp(p_X, p_Y: Integer);
begin
  if (m_Drawing) then
  begin
    m_X := GetRealX(p_X);
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
procedure CMKAVGannFan.OnMouseMove(p_X, p_Y: Integer);
begin
  if (m_Drawing and (m_Step = 1)) then
  begin
    m_X := GetRealX(p_X);
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
      m_NewX := GetRealX(p_X);
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
procedure CMKAVGannFan.DrawDefaultLayer(p_Bitmap: TBitmap32);
var
  f_X: Integer;
  f_Y: Integer;
  f_Label: String;
  f_ChartData: CMKChartData;

  f_Index: Integer;
  f_PenColor: TColor32;
begin
  if CMKChartBlock(m_ChartBlock).m_ChartDataSeries = NIL then
    exit;
  if (m_X <= 0) then
    exit;

  p_Bitmap.Font.Name := m_Font;
  p_Bitmap.Font.Size := m_FontSize;
  p_Bitmap.Font.Style := [];
  p_Bitmap.Font.Color := m_FontColor;

  f_X := GetScreenXCenter(m_X);
  f_Y := Math.Floor(GetScreenY(m_Y));

  if (m_Selected) then
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);
    p_Bitmap.PenColor := f_PenColor;

    for f_Index := 0 to Length(m_GannAngleArray) - 1 do
    begin
      DrawAngleLine(p_Bitmap, m_GannAngleArray[f_Index], f_X, f_Y);
    end;

    DrawBox(p_Bitmap, f_X - m_SelectMaxMin, f_Y - m_SelectMaxMin, f_X + m_SelectMaxMin, f_Y + m_SelectMaxMin, 1);

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
    f_Label := f_Label + ' ' + TMKGlobal.NumberToString(m_Y, 2);
    DrawText(p_Bitmap, f_Label, f_X, f_Y, 0, 0);
  end
  else
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);
    p_Bitmap.PenColor := f_PenColor;

    for f_Index := 0 to Length(m_GannAngleArray) - 1 do
    begin
      DrawAngleLine(p_Bitmap, m_GannAngleArray[f_Index], f_X, f_Y);
    end;

    if (m_Hit) then
    begin
      DrawBox(p_Bitmap, f_X - m_SelectMaxMin, f_Y - m_SelectMaxMin, f_X + m_SelectMaxMin, f_Y + m_SelectMaxMin, 0);
    end;
  end;
end;

end.
