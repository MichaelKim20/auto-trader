unit MKAVRectangle;

interface

uses
  SysUtils, Types, Classes, Math, GR32, StdCtrls, Messages, Windows, GR32_Layers, Contnrs, ExtCtrls,
  MKStreamChartDataSeries, MKColorSet, MKConst, MKMaxMin, FNQueue, FNThread, SyncObjs,
  MKChartData, MKLineValueSeries,
  MKAVDrawingObject;

type
  /// /////////////////////////////////////////////////////////////////////////
  //
  CMKAVRectangle = class(CMKAVDrawingObject)
  private
    m_X1Date: TDateTime;
    m_X2Date: TDateTime;
    m_X1: Double;
    m_X2: Double;
    m_Y1: Double;
    m_Y2: Double;
    m_OldX: Double;
    m_OldY: Double;
    m_NewX: Double;
    m_NewY: Double;
    m_Step: Integer;
    m_SelectType: Integer;
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
constructor CMKAVRectangle.Create();
begin
  inherited Create;

  m_Step := 0;
  m_SelectType := 0;
  m_Hit := false;
end;

// ---------------------------------------------------------------------------
destructor CMKAVRectangle.Destroy();
begin
  ClearText();

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CMKAVRectangle.Clear();
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
procedure CMKAVRectangle.ClearText;
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVRectangle.XValueToDate;
begin
  if (m_X1 >= 0) then
    m_X1Date := GetDate(Math.Floor(m_X1));

  if (m_X2 >= 0) then
    m_X2Date := GetDate(Math.Floor(m_X2));
end;

// ---------------------------------------------------------------------------
procedure CMKAVRectangle.XDateToValue;
begin
  m_X1 := GetIndex(m_X1Date);
  m_X2 := GetIndex(m_X2Date);
end;

// ---------------------------------------------------------------------------
function CMKAVRectangle.HitTest(p_X, p_Y: Integer): Boolean;
var
  f_LXMin: Double;
  f_LXMax: Double;
  f_LYMin: Double;
  f_LYMax: Double;

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

  if (m_X1 > m_X2) then
    f_LXMin := m_X2
  else
    f_LXMin := m_X1;

  if (m_X1 > m_X2) then
    f_LXMax := m_X1
  else
    f_LXMax := m_X2;

  if (m_Y1 > m_Y2) then
    f_LYMin := m_Y2
  else
    f_LYMin := m_Y1;

  if (m_Y1 > m_Y2) then
    f_LYMax := m_Y1
  else
    f_LYMax := m_Y2;

  if ((f_DX2 >= f_LXMin) and (f_DX1 <= f_LXMax) and (f_DY2 >= f_LYMin) and (f_DY1 <= f_LYMax)) then
  begin
    if (((((f_DX1 <= f_LXMin) and (f_LXMin <= f_DX2)) or ((f_DX1 <= f_LXMax) and (f_LXMax <= f_DX2))) and
        ((f_DY2 >= f_LYMin) and (f_DY1 <= f_LYMax))) or
        ((((f_DY1 <= f_LYMin) and (f_LYMin <= f_DY2)) or ((f_DY1 <= f_LYMax) and (f_LYMax <= f_DY2))) and
        ((f_DX2 >= f_LXMin) and (f_DX1 <= f_LXMax)))) then
    begin
      m_Hit := true;

      if ((f_DX1 <= m_X1) and (m_X1 <= f_DX2) and (f_DY1 <= m_Y1) and (m_Y1 <= f_DY2)) then
        m_SelectType := 1
      else if ((f_DX1 <= m_X2) and (m_X2 <= f_DX2) and (f_DY1 <= m_Y1) and (m_Y1 <= f_DY2)) then
        m_SelectType := 2
      else if ((f_DX1 <= m_X2) and (m_X2 <= f_DX2) and (f_DY1 <= m_Y2) and (m_Y2 <= f_DY2)) then
        m_SelectType := 3
      else if ((f_DX1 <= m_X1) and (m_X1 <= f_DX2) and (f_DY1 <= m_Y2) and (m_Y2 <= f_DY2)) then
        m_SelectType := 4
      else
        m_SelectType := 0;
    end;
  end;

  Result := m_Hit;
end;

// ---------------------------------------------------------------------------
procedure CMKAVRectangle.OnMouseDown(p_X, p_Y: Integer);
begin
  if (m_Drawing) then
  begin
    m_X1 := GetRealX(p_X);
    m_Y1 := GetRealY(p_Y);

    if (m_X1 < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
      m_X1 := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin;
    if (m_X1 > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
      m_X1 := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax;

    m_X2 := m_X1;
    m_Y2 := m_Y1;
    m_OldX := m_X1;
    m_OldY := m_Y1;
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
procedure CMKAVRectangle.OnMouseUp(p_X, p_Y: Integer);
begin
  if (m_Drawing) then
  begin
    m_X2 := GetRealX(p_X);
    m_Y2 := GetRealY(p_Y);

    if (m_X2 < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
      m_X2 := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin;
    if (m_X2 > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
      m_X2 := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax;

    m_Drawing := false;
    CMKAVDrawManager(m_Manager).CompleteDrawObject();
    m_Step := 2;
    XValueToDate();
  end;

  m_CaptureMouse := false;
  m_SelectType := 0;
end;

// ---------------------------------------------------------------------------
procedure CMKAVRectangle.OnMouseMove(p_X, p_Y: Integer);
begin
  if (m_Drawing and (m_Step = 1)) then
  begin
    m_X2 := GetRealX(p_X);
    m_Y2 := GetRealY(p_Y);

    if (m_X2 < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
      m_X2 := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin;
    if (m_X2 > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
      m_X2 := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax;

    XValueToDate();
  end
  else
  begin
    if (m_CaptureMouse and m_Selected) then
    begin
      m_NewX := GetRealX(p_X);
      m_NewY := GetRealY(p_Y);

      if (m_SelectType = 1) then
      begin
        if (m_X1 + (m_NewX - m_OldX) < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
          exit;
        if (m_X1 + (m_NewX - m_OldX) > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
          exit;
        m_X1 := m_X1 + (m_NewX - m_OldX);
        m_Y1 := m_Y1 + (m_NewY - m_OldY);
      end
      else if (m_SelectType = 2) then
      begin
        if (m_X2 + (m_NewX - m_OldX) < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
          exit;
        if (m_X2 + (m_NewX - m_OldX) > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
          exit;
        m_X2 := m_X2 + (m_NewX - m_OldX);
        m_Y1 := m_Y1 + (m_NewY - m_OldY);
      end
      else if (m_SelectType = 3) then
      begin
        if (m_X2 + (m_NewX - m_OldX) < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
          exit;
        if (m_X2 + (m_NewX - m_OldX) > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
          exit;
        m_X2 := m_X2 + (m_NewX - m_OldX);
        m_Y2 := m_Y2 + (m_NewY - m_OldY);
      end
      else if (m_SelectType = 4) then
      begin
        if (m_X1 + (m_NewX - m_OldX) < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
          exit;
        if (m_X1 + (m_NewX - m_OldX) > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
          exit;
        m_X1 := m_X1 + (m_NewX - m_OldX);
        m_Y2 := m_Y2 + (m_NewY - m_OldY);
      end
      else
      begin
        if (m_X1 + (m_NewX - m_OldX) < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
          exit;
        if (m_X1 + (m_NewX - m_OldX) > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
          exit;
        if (m_X2 + (m_NewX - m_OldX) < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
          exit;
        if (m_X2 + (m_NewX - m_OldX) > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
          exit;

        m_X1 := m_X1 + (m_NewX - m_OldX);
        m_X2 := m_X2 + (m_NewX - m_OldX);
        m_Y1 := m_Y1 + (m_NewY - m_OldY);
        m_Y2 := m_Y2 + (m_NewY - m_OldY);
      end;

      m_OldX := m_NewX;
      m_OldY := m_NewY;

      XValueToDate();
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVRectangle.DrawDefaultLayer(p_Bitmap: TBitmap32);
var
  f_X1, f_X2: Integer;
  f_Y1, f_Y2: Integer;
  f_Label: String;
  f_ChartData: CMKChartData;
  f_LXMin: Double;
  f_LXMax: Double;
  f_LYMin: Double;
  f_LYMax: Double;

  f_Width: Integer;
  f_Height: Integer;
  f_PenColor: TColor32;
begin
  if CMKChartBlock(m_ChartBlock).m_ChartDataSeries = NIL then
    exit;
  if ((m_X1 < 0) or (m_X2 < 0)) then
    exit;

  p_Bitmap.Font.Name := m_Font;
  p_Bitmap.Font.Size := m_FontSize;
  p_Bitmap.Font.Style := [];
  p_Bitmap.Font.Color := m_FontColor;

  if (m_X1 > m_X2) then
    f_LXMin := m_X2
  else
    f_LXMin := m_X1;

  if (m_X1 > m_X2) then
    f_LXMax := m_X1
  else
    f_LXMax := m_X2;

  if (m_Y1 > m_Y2) then
    f_LYMin := m_Y2
  else
    f_LYMin := m_Y1;

  if (m_Y1 > m_Y2) then
    f_LYMax := m_Y1
  else
    f_LYMax := m_Y2;

  f_X1 := GetScreenXCenter(f_LXMin);
  f_X2 := GetScreenXCenter(f_LXMax);
  f_Y1 := Math.Floor(GetScreenY(f_LYMax));
  f_Y2 := Math.Floor(GetScreenY(f_LYMin));

  if (m_Selected) then
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);

    p_Bitmap.PenColor := f_PenColor;
    p_Bitmap.MoveTo(f_X1, f_Y1);
    p_Bitmap.LineToAS(f_X2, f_Y1);
    p_Bitmap.LineToAS(f_X2, f_Y2);
    p_Bitmap.LineToAS(f_X1, f_Y2);
    p_Bitmap.LineToAS(f_X1, f_Y1);

    DrawBox(p_Bitmap, f_X1 - m_SelectMaxMin, f_Y1 - m_SelectMaxMin, f_X1 + m_SelectMaxMin, f_Y1 + m_SelectMaxMin, 1);
    DrawBox(p_Bitmap, f_X2 - m_SelectMaxMin, f_Y1 - m_SelectMaxMin, f_X2 + m_SelectMaxMin, f_Y1 + m_SelectMaxMin, 1);
    DrawBox(p_Bitmap, f_X2 - m_SelectMaxMin, f_Y2 - m_SelectMaxMin, f_X2 + m_SelectMaxMin, f_Y2 + m_SelectMaxMin, 1);
    DrawBox(p_Bitmap, f_X1 - m_SelectMaxMin, f_Y2 - m_SelectMaxMin, f_X1 + m_SelectMaxMin, f_Y2 + m_SelectMaxMin, 1);
    if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_Items.Count > Round(f_LXMin)) then
    begin
      f_ChartData := CMKChartData(CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_Items.Items[Round(f_LXMin)]);
      f_Label := TMKGlobal.DateToYYYY_MM_DD(f_ChartData.m_Year, f_ChartData.m_Month, f_ChartData.m_Day);
      if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_TimeFrame < 360) then
      begin
        f_Label := f_Label + ' ' + TMKGlobal.TimeToHH_MM(f_ChartData.m_Hour, f_ChartData.m_Min);
      end
      else if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_TimeFrame > 9000) then
      begin
        f_Label := f_Label + ' ' + TMKGlobal.TimeToHH_MM_SS(f_ChartData.m_Hour, f_ChartData.m_Min, f_ChartData.m_Sec);
      end;
      f_Label := f_Label + ' ' + TMKGlobal.NumberToString(f_LYMax, 2);
      DrawText(p_Bitmap, f_Label, f_X1, f_Y1, 1, 1);
    end;

    if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_Items.Count > Round(f_LXMax)) then
    begin
      f_ChartData := CMKChartData(CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_Items.Items[Round(f_LXMax)]);
      f_Label := TMKGlobal.DateToYYYY_MM_DD(f_ChartData.m_Year, f_ChartData.m_Month, f_ChartData.m_Day);
      if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_TimeFrame < 360) then
      begin
        f_Label := f_Label + ' ' + TMKGlobal.TimeToHH_MM(f_ChartData.m_Hour, f_ChartData.m_Min);
      end
      else if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_TimeFrame > 9000) then
      begin
        f_Label := f_Label + ' ' + TMKGlobal.TimeToHH_MM_SS(f_ChartData.m_Hour, f_ChartData.m_Min, f_ChartData.m_Sec);
      end;
      f_Label := f_Label + ' ' + TMKGlobal.NumberToString(f_LYMin, 2);
      DrawText(p_Bitmap, f_Label, f_X2, f_Y2, 0, 0);
    end;
  end
  else
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);

    p_Bitmap.PenColor := f_PenColor;
    p_Bitmap.MoveTo(f_X1, f_Y1);
    p_Bitmap.LineToAS(f_X2, f_Y1);
    p_Bitmap.LineToAS(f_X2, f_Y2);
    p_Bitmap.LineToAS(f_X1, f_Y2);
    p_Bitmap.LineToAS(f_X1, f_Y1);

    if m_Hit then
    begin
      DrawBox(p_Bitmap, f_X1 - m_SelectMaxMin, f_Y1 - m_SelectMaxMin, f_X1 + m_SelectMaxMin, f_Y1 + m_SelectMaxMin, 0);
      DrawBox(p_Bitmap, f_X2 - m_SelectMaxMin, f_Y1 - m_SelectMaxMin, f_X2 + m_SelectMaxMin, f_Y1 + m_SelectMaxMin, 0);
      DrawBox(p_Bitmap, f_X2 - m_SelectMaxMin, f_Y2 - m_SelectMaxMin, f_X2 + m_SelectMaxMin, f_Y2 + m_SelectMaxMin, 0);
      DrawBox(p_Bitmap, f_X1 - m_SelectMaxMin, f_Y2 - m_SelectMaxMin, f_X1 + m_SelectMaxMin, f_Y2 + m_SelectMaxMin, 0);
    end;
  end;
end;

end.
