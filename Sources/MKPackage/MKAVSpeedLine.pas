unit MKAVSpeedLine;

interface

uses
  SysUtils, Types, Classes, Math, GR32, StdCtrls, Messages, Windows, GR32_Layers, Contnrs, ExtCtrls,
  MKStreamChartDataSeries, MKColorSet, MKConst, MKMaxMin, FNQueue, FNThread, SyncObjs,
  MKChartData, MKLineValueSeries,
  MKAVDrawingObject;

type
  /// /////////////////////////////////////////////////////////////////////////
  //
  CMKAVSpeedLine = class(CMKAVDrawingObject)
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

    procedure DrawSpeedLine(p_MC: TBitmap32; per: Double);
    procedure ClearText();
  end;

implementation

uses
  MKGlobal, MKChartDefine, MKAVDrawManager, MKAVChartBlock;

/// //////////////////////////////////////////////////////////////////////////
// CMKAVVLine
// ---------------------------------------------------------------------------
constructor CMKAVSpeedLine.Create();
begin
  inherited Create;

  m_Step := 0;
  m_SelectType := 0;
  m_Hit := false;
end;

// ---------------------------------------------------------------------------
destructor CMKAVSpeedLine.Destroy();
begin
  ClearText();

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CMKAVSpeedLine.Clear();
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
procedure CMKAVSpeedLine.ClearText;
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVSpeedLine.XValueToDate;
begin
  if (m_X1 >= 0) then
    m_X1Date := GetDate(Math.Floor(m_X1));

  if (m_X2 >= 0) then
    m_X2Date := GetDate(Math.Floor(m_X2));
end;

// ---------------------------------------------------------------------------
procedure CMKAVSpeedLine.XDateToValue;
begin
  m_X1 := GetIndex(m_X1Date);
  m_X2 := GetIndex(m_X2Date);
end;

procedure CMKAVSpeedLine.DrawSpeedLine(p_MC: TBitmap32; per: Double);
var
  f_midX, f_midY: Integer;
  f_eX1, f_eX2: Double;
  f_eY1, f_eY2: Double;
  f_X1, f_X2: Double;
  f_Y1, f_Y2: Double;
  f_he: Double;
  f_slide: Double;
begin
  f_X1 := GetScreenXCenter(m_X1);
  f_X2 := GetScreenXCenter(m_X2);
  f_Y1 := GetScreenY(m_Y1);
  f_he := m_Y2 - m_Y1;
  f_Y2 := GetScreenY(m_Y2 - f_he * per);

  // f_slide := (f_Y2 - f_Y1) / (f_X2 - f_X1);
  if (0 <> (f_X2 - f_X1)) then
    f_slide := (f_Y2 - f_Y1) / (f_X2 - f_X1)
  else
    f_slide := (f_Y2 - f_Y1);

  if (f_X1 > f_X2) then
    f_eX1 := CMKChartBlock(m_ChartBlock).m_AxisRect.Left
  else
    f_eX1 := CMKChartBlock(m_ChartBlock).m_AxisRect.Left + TMKGlobal.RectToWidth(CMKChartBlock(m_ChartBlock).m_AxisRect);

  f_eY1 := f_slide * (f_eX1 - f_X1) + f_Y1;
  if (f_Y1 < f_Y2) then
    f_eY2 := CMKChartBlock(m_ChartBlock).m_AxisRect.Top + TMKGlobal.RectToHeight(CMKChartBlock(m_ChartBlock).m_AxisRect)
  else
    f_eY2 := CMKChartBlock(m_ChartBlock).m_AxisRect.Top;

  {
    //f_eX2 := ((f_eY2 - f_Y1) / f_slide) + f_X1;
    if (0 <> f_slide) then
    f_eX2 := ((f_eY2 - f_Y1) / f_slide) + f_X1
    else
    f_eX2 := f_X1;

    if (Abs(f_X1 - f_eX1) < Abs(f_X1 - f_eX2)) then
    begin
    f_X2 := f_eX1;
    f_Y2 := f_eY1;
    end
    else
    begin
    f_X2 := f_eX2;
    f_Y2 := f_eY2;
    end;
  }
  if (0 <> f_slide) then
  begin
    f_eX2 := ((f_eY2 - f_Y1) / f_slide) + f_X1;
    if (Abs(f_X1 - f_eX1) < Abs(f_X1 - f_eX2)) then
    begin
      f_X2 := f_eX1;
      f_Y2 := f_eY1;
    end
    else
    begin
      f_X2 := f_eX2;
      f_Y2 := f_eY2;
    end;
  end
  else
  begin
    f_X2 := f_eX1;
    f_Y2 := f_eY1;
  end;

  p_MC.MoveTo(Math.Floor(f_X1), Math.Floor(f_Y1));
  p_MC.LineToAS(Math.Floor(f_X2), Math.Floor(f_Y2));
end;

// ---------------------------------------------------------------------------
function CMKAVSpeedLine.HitTest(p_X, p_Y: Integer): Boolean;
var
  f_LXMin: Double;
  f_LXMax: Double;
  f_LYMin: Double;
  f_LYMax: Double;

  f_DX1: Integer;
  f_DX2: Integer;
  f_DY1: Double;
  f_DY2: Double;
  f_X1: Integer;
  f_X2: Integer;
  f_Y1: Double;
  f_Y2: Double;
  f_TY1: Double;
  f_TY2: Double;
  f_TYMin: Double;
  f_TYMax: Double;
begin
  m_Hit := false;

  f_X1 := GetScreenXCenter(m_X1);
  f_X2 := GetScreenXCenter(m_X2);
  f_Y1 := GetScreenY(m_Y1);
  f_Y2 := GetScreenY(m_Y2);
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
    if (0 <> (m_X2 - m_X1)) then
    begin
      f_TY1 := ((m_Y2 - m_Y1) / (m_X2 - m_X1)) * (f_DX1 - m_X1) + m_Y1;
      f_TY2 := ((m_Y2 - m_Y1) / (m_X2 - m_X1)) * (f_DX2 - m_X1) + m_Y1;
    end
    else
    begin
      f_TY1 := m_Y1;
      f_TY2 := m_Y2;
    end;

    if (f_TY1 > f_TY2) then
      f_TYMin := f_TY2
    else
      f_TYMin := f_TY1;

    if (f_TY1 > f_TY2) then
      f_TYMax := f_TY1
    else
      f_TYMax := f_TY2;

    if (((f_DY2 >= f_TYMin) and (f_DY2 <= f_TYMax)) or ((f_TYMax >= f_DY1) and (f_TYMax <= f_DY2))) then
    begin
      m_Hit := true;

      if ((f_X1 - m_SelectMaxMin < p_X) and (p_X < f_X1 + m_SelectMaxMin) and (f_Y1 - m_SelectMaxMin < p_Y) and
          (p_Y < f_Y1 + m_SelectMaxMin)) then
        m_SelectType := 1
      else if ((f_X2 - m_SelectMaxMin < p_X) and (p_X < f_X2 + m_SelectMaxMin) and (f_Y2 - m_SelectMaxMin < p_Y) and
          (p_Y < f_Y2 + m_SelectMaxMin)) then
        m_SelectType := 2
      else
        m_SelectType := 0;
    end;
  end;

  Result := m_Hit;
end;

// ---------------------------------------------------------------------------
procedure CMKAVSpeedLine.OnMouseDown(p_X, p_Y: Integer);
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
procedure CMKAVSpeedLine.OnMouseUp(p_X, p_Y: Integer);
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
procedure CMKAVSpeedLine.OnMouseMove(p_X, p_Y: Integer);
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
procedure CMKAVSpeedLine.DrawDefaultLayer(p_Bitmap: TBitmap32);
var
  f_X1, f_X2: Integer;
  f_Y1, f_Y2: Integer;
  f_he: Double;
  f_Label: String;
  f_ChartData: CMKChartData;

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

  f_X1 := GetScreenXCenter(m_X1);
  f_X2 := GetScreenXCenter(m_X2);
  f_Y1 := Math.Floor(GetScreenY(m_Y1));
  f_Y2 := Math.Floor(GetScreenY(m_Y2));
  f_he := m_Y2 - m_Y1;

  if (m_Selected) then
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);
    p_Bitmap.PenColor := f_PenColor;

    p_Bitmap.MoveTo(f_X1, f_Y1);
    p_Bitmap.LineToAS(f_X2, f_Y2);

    if (f_X1 <> f_X2) and (f_Y1 <> f_Y2) then
    begin
      DrawSpeedLine(p_Bitmap, 1 / 3);
      DrawSpeedLine(p_Bitmap, 2 / 3);
    end;

    DrawBox(p_Bitmap, f_X1 - m_SelectMaxMin, f_Y1 - m_SelectMaxMin, f_X1 + m_SelectMaxMin, f_Y1 + m_SelectMaxMin, 1);
    DrawBox(p_Bitmap, f_X2 - m_SelectMaxMin, f_Y2 - m_SelectMaxMin, f_X2 + m_SelectMaxMin, f_Y2 + m_SelectMaxMin, 1);

    if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_Items.Count > Round(m_X1)) then
    begin
      f_ChartData := CMKChartData(CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_Items.Items[Round(m_X1)]);
      f_Label := TMKGlobal.DateToYYYY_MM_DD(f_ChartData.m_Year, f_ChartData.m_Month, f_ChartData.m_Day);
      if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_TimeFrame < 360) then
      begin
        f_Label := f_Label + ' ' + TMKGlobal.TimeToHH_MM(f_ChartData.m_Hour, f_ChartData.m_Min);
      end
      else if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_TimeFrame > 9000) then
      begin
        f_Label := f_Label + ' ' + TMKGlobal.TimeToHH_MM_SS(f_ChartData.m_Hour, f_ChartData.m_Min, f_ChartData.m_Sec);
      end;
      f_Label := f_Label + ' ' + TMKGlobal.NumberToString(m_Y1, 2);
      DrawText(p_Bitmap, f_Label, f_X1, f_Y1, 0, 0);
    end;

    if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_Items.Count > Round(m_X2)) then
    begin
      f_ChartData := CMKChartData(CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_Items.Items[Round(m_X2)]);
      f_Label := TMKGlobal.DateToYYYY_MM_DD(f_ChartData.m_Year, f_ChartData.m_Month, f_ChartData.m_Day);
      if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_TimeFrame < 360) then
      begin
        f_Label := f_Label + ' ' + TMKGlobal.TimeToHH_MM(f_ChartData.m_Hour, f_ChartData.m_Min);
      end
      else if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_TimeFrame > 9000) then
      begin
        f_Label := f_Label + ' ' + TMKGlobal.TimeToHH_MM_SS(f_ChartData.m_Hour, f_ChartData.m_Min, f_ChartData.m_Sec);
      end;
      f_Label := f_Label + ' ' + TMKGlobal.NumberToString(m_Y2, 2);
      DrawText(p_Bitmap, f_Label, f_X2, f_Y2, 0, 0);
    end;
  end
  else
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);
    p_Bitmap.PenColor := f_PenColor;

    p_Bitmap.MoveTo(f_X1, f_Y1);
    p_Bitmap.LineToAS(f_X2, f_Y2);

    if (f_X1 <> f_X2) and (f_Y1 <> f_Y2) then
    begin
      DrawSpeedLine(p_Bitmap, 1 / 3);
      DrawSpeedLine(p_Bitmap, 2 / 3);
    end;

    if (m_Hit) then
    begin
      DrawBox(p_Bitmap, f_X1 - m_SelectMaxMin, f_Y1 - m_SelectMaxMin, f_X1 + m_SelectMaxMin, f_Y1 + m_SelectMaxMin, 0);
      DrawBox(p_Bitmap, f_X2 - m_SelectMaxMin, f_Y2 - m_SelectMaxMin, f_X2 + m_SelectMaxMin, f_Y2 + m_SelectMaxMin, 0);
    end;
  end;
end;

end.
