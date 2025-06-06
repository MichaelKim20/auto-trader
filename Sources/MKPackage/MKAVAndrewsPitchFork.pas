unit MKAVAndrewsPitchFork;

interface

uses
  SysUtils, Types, Classes, Math, GR32, StdCtrls, Messages, Windows, GR32_Layers, Contnrs, ExtCtrls,
  MKStreamChartDataSeries, MKColorSet, MKConst, MKMaxMin, FNThread, SyncObjs,
  MKChartData, MKLineValueSeries,
  MKAVDrawingObject;

type
  /// /////////////////////////////////////////////////////////////////////////
  //
  CMKAVAndrewsPitchFork = class(CMKAVDrawingObject)
  private
    m_X1Date: TDateTime;
    m_X2Date: TDateTime;
    m_X3Date: TDateTime;
    m_X1: Double;
    m_X2: Double;
    m_X3: Double;
    m_Y1: Double;
    m_Y2: Double;
    m_Y3: Double;

    m_eX1: Double;
    m_eX2: Double;
    m_eX3: Double;
    m_eY1: Double;
    m_eY2: Double;
    m_eY3: Double;

    m_OldX: Double;
    m_NewX: Double;
    m_OldY: Double;
    m_NewY: Double;
    m_Step: Integer;
    m_SelectType: Integer;
    m_Hit: Boolean;
    m_StepDown: Boolean;

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

    procedure DrawXLine(p_Layer: TBitmap32; f_X1: Integer; f_Y1: Integer; f_X2: Integer; f_Y2: Integer);
    procedure DrawAndrewsPitchFork(p_Layer: TBitmap32);
    procedure PosPaint(p_Bitmap: TBitmap32);
    procedure ClearText();
  end;

implementation

uses
  MKGlobal, MKChartDefine, MKAVDrawManager, MKAVChartBlock;

/// //////////////////////////////////////////////////////////////////////////
// CMKAVVLine
// ---------------------------------------------------------------------------
constructor CMKAVAndrewsPitchFork.Create();
begin
  inherited Create;

  m_Step := 0;
  m_SelectType := 0;
  m_Hit := false;
  m_StepDown := false;
end;

// ---------------------------------------------------------------------------
destructor CMKAVAndrewsPitchFork.Destroy();
begin
  ClearText();

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CMKAVAndrewsPitchFork.Clear();
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
procedure CMKAVAndrewsPitchFork.ClearText;
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVAndrewsPitchFork.XValueToDate;
begin
  if (m_X1 >= 0) then
    m_X1Date := GetDate(Math.Floor(m_X1));

  if (m_X2 >= 0) then
    m_X2Date := GetDate(Math.Floor(m_X2));

  if (m_X3 >= 0) then
    m_X3Date := GetDate(Math.Floor(m_X3));
end;

// ---------------------------------------------------------------------------
procedure CMKAVAndrewsPitchFork.XDateToValue;
begin
  m_X1 := GetIndex(m_X1Date);
  m_X2 := GetIndex(m_X2Date);
  m_X3 := GetIndex(m_X3Date);
end;

procedure CMKAVAndrewsPitchFork.DrawXLine(p_Layer: TBitmap32; f_X1: Integer; f_Y1: Integer; f_X2: Integer; f_Y2: Integer);
begin
  p_Layer.MoveTo(f_X1, f_Y1);
  p_Layer.LineToAS(f_X2, f_Y2);
  p_Layer.MoveTo(f_X2, f_Y1);
  p_Layer.LineToAS(f_X1, f_Y2);
end;

procedure CMKAVAndrewsPitchFork.DrawAndrewsPitchFork(p_Layer: TBitmap32);
var
  f_midX, f_midY: Double;
  f_eX1, f_eX2: Double;
  f_eY1, f_eY2: Double;
  f_X1, f_X2, f_X3: Integer;
  f_Y1, f_Y2, f_Y3: Double;
  f_slide: Double;

  f_tempX, f_tempY: Double;
begin
  if ((m_X1 <= 0) or (m_X2 <= 0) or (m_X3 <= 0)) then
    exit;

  f_X1 := GetScreenXCenter(m_X1);
  f_X2 := GetScreenXCenter(m_X2);
  f_X3 := GetScreenXCenter(m_X3);
  f_Y1 := GetScreenY(m_Y1);
  f_Y2 := GetScreenY(m_Y2);
  f_Y3 := GetScreenY(m_Y3);
  f_midX := (m_X2 + m_X3) / 2;
  f_midY := (m_Y2 + m_Y3) / 2;

  f_tempX := GetScreenXCenter(f_midX);
  f_tempY := GetScreenY(f_midY);

  if (0 <> f_tempX - f_X1) then
    f_slide := (f_tempY - f_Y1) / (f_tempX - f_X1)
  else
    f_slide := f_X1;

  if (m_X1 > f_midX) then
    f_eX1 := CMKChartBlock(m_ChartBlock).m_AxisRect.Left
  else
    f_eX1 := CMKChartBlock(m_ChartBlock).m_AxisRect.Left + TMKGlobal.RectToWidth(CMKChartBlock(m_ChartBlock).m_AxisRect);

  f_eY1 := f_slide * (f_eX1 - f_X1) + f_Y1;
  if (m_Y1 > f_midY) then
    f_eY2 := CMKChartBlock(m_ChartBlock).m_AxisRect.Top + TMKGlobal.RectToHeight(CMKChartBlock(m_ChartBlock).m_AxisRect)
  else
    f_eY2 := CMKChartBlock(m_ChartBlock).m_AxisRect.Top;

  if (0 <> f_slide) then
  begin
    f_eX2 := ((f_eY2 - f_Y1) / f_slide) + f_X1;
    if (Abs(f_X1 - f_eX1) < Abs(f_X1 - f_eX2)) then
    begin
      m_eX1 := f_eX1;
      m_eY1 := f_eY1;
      m_eX2 := f_eX1;
      m_eY2 := f_slide * (f_eX1 - f_X2) + f_Y2;
      m_eX3 := f_eX1;
      m_eY3 := f_slide * (f_eX1 - f_X3) + f_Y3;
    end
    else
    begin
      m_eX1 := f_eX2;
      m_eY1 := f_eY2;
      m_eX2 := ((f_eY2 - f_Y2) / f_slide) + f_X2;
      m_eY2 := f_eY2;
      m_eX3 := ((f_eY2 - f_Y3) / f_slide) + f_X3;
      m_eY3 := f_eY2;
    end;
  end
  else
  begin
    m_eX1 := f_eX1;
    m_eY1 := f_eY1;
    m_eX2 := f_eX1;
    m_eY2 := f_slide * (f_eX1 - f_X2) + f_Y2;
    m_eX3 := f_eX1;
    m_eY3 := f_slide * (f_eX1 - f_X3) + f_Y3;
  end;

  p_Layer.MoveTo(Math.Floor(f_X1), Math.Floor(f_Y1));
  p_Layer.LineToAS(Math.Floor(m_eX1), Math.Floor(m_eY1));
  p_Layer.MoveTo(Math.Floor(f_X2), Math.Floor(f_Y2));
  p_Layer.LineToAS(Math.Floor(m_eX2), Math.Floor(m_eY2));
  p_Layer.MoveTo(Math.Floor(f_X3), Math.Floor(f_Y3));
  p_Layer.LineToAS(Math.Floor(m_eX3), Math.Floor(m_eY3));
end;

procedure CMKAVAndrewsPitchFork.PosPaint(p_Bitmap: TBitmap32);
var
  f_X1, f_X2, f_X3: Integer;
  f_Y1, f_Y2, f_Y3: Integer;
  f_PenColor: TColor32;
begin
  f_X1 := GetScreenXCenter(m_X1);
  f_X2 := GetScreenXCenter(m_X2);
  f_X3 := GetScreenXCenter(m_X3);
  f_Y1 := Math.Floor(GetScreenY(m_Y1));
  f_Y2 := Math.Floor(GetScreenY(m_Y2));
  f_Y3 := Math.Floor(GetScreenY(m_Y3));
  if (m_Step >= 1) then
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);
    p_Bitmap.PenColor := f_PenColor;
    DrawXLine(p_Bitmap, f_X1 - m_SelectMaxMin, f_Y1 - m_SelectMaxMin, f_X1 + m_SelectMaxMin, f_Y1 + m_SelectMaxMin);
  end;

  if (m_Step >= 2) then
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);
    p_Bitmap.PenColor := f_PenColor;
    DrawXLine(p_Bitmap, f_X2 - m_SelectMaxMin, f_Y2 - m_SelectMaxMin, f_X2 + m_SelectMaxMin, f_Y2 + m_SelectMaxMin);
  end;

  if (m_Step = 3) then
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);
    p_Bitmap.PenColor := f_PenColor;
    DrawXLine(p_Bitmap, f_X3 - m_SelectMaxMin, f_Y3 - m_SelectMaxMin, f_X3 + m_SelectMaxMin, f_Y3 + m_SelectMaxMin);
  end;
end;

// ---------------------------------------------------------------------------
function CMKAVAndrewsPitchFork.HitTest(p_X, p_Y: Integer): Boolean;
var
  f_TY1: Integer;
  f_TY2: Integer;
  f_TYMin: Double;
  f_TYMax: Double;
  f_X1: Integer;
  f_X2: Integer;
  f_X3: Integer;
  f_Y1: Double;
  f_Y2: Double;
  f_Y3: Double;

  f_DX1: Integer;
  f_DX2: Integer;
  f_DY1: Double;
  f_DY2: Double;

  f_diffX2: Integer;
  f_diffX3: Integer;
  f_diffY2: Double;
  f_diffY3: Double;

  f_eX1, f_eY1: Integer;
  f_slide: Double;
begin
  m_Hit := false;

  f_X1 := GetScreenXCenter(m_X1);
  f_X2 := GetScreenXCenter(m_X2);
  f_X3 := GetScreenXCenter(m_X3);
  f_Y1 := GetScreenY(m_Y1);
  f_Y2 := GetScreenY(m_Y2);
  f_Y3 := GetScreenY(m_Y3);

  f_DX1 := GetRealX(p_X - m_SelectMaxMin);
  f_DX2 := GetRealX(p_X + m_SelectMaxMin);
  f_DY1 := GetRealY(p_Y + m_SelectMaxMin);
  f_DY2 := GetRealY(p_Y - m_SelectMaxMin);

  f_diffX2 := f_X2 - f_X1;
  f_diffY2 := f_Y2 - f_Y1;
  f_diffX3 := f_X3 - f_X1;
  f_diffY3 := f_Y3 - f_Y1;

  if (0 <> (m_eX1 - f_X1)) then
    f_slide := (m_eY1 - f_Y1) / (m_eX1 - f_X1)
  else
    f_slide := 0;

  if (f_slide <> 0) then
  begin
    f_TY1 := Math.Floor(f_slide * (p_X - m_SelectMaxMin - f_X1) + f_Y1);
    f_TY2 := Math.Floor(f_slide * (p_X + m_SelectMaxMin - f_X1) + f_Y1);
  end
  else
  begin
    f_TY1 := Math.Floor(m_eY1 - m_SelectMaxMin);
    f_TY2 := Math.Floor(m_eY1 + m_SelectMaxMin);
  end;

  if (f_TY1 > f_TY2) then
    f_TYMin := f_TY2
  else
    f_TYMin := f_TY1;

  if (f_TY1 > f_TY2) then
    f_TYMax := f_TY1
  else
    f_TYMax := f_TY2;

  // if (((p_Y - m_SelectMaxMin >= f_TYMin) and (p_Y - m_SelectMaxMin <= f_TYMax)) or ((f_TYMax >= p_Y + m_SelectMaxMin) and (f_TYMax <= p_Y - m_SelectMaxMin))) then
  if (((p_Y - m_SelectMaxMin >= f_TYMin) and (p_Y - m_SelectMaxMin <= f_TYMax)) or
      ((f_TYMax >= p_Y + m_SelectMaxMin) and (f_TYMax <= p_Y - m_SelectMaxMin))) then
    m_Hit := true;

  f_TY1 := Math.Floor(f_slide * (p_X - m_SelectMaxMin - f_X2) + f_Y2);
  f_TY2 := Math.Floor(f_slide * (p_X + m_SelectMaxMin - f_X2) + f_Y2);

  if (f_TY1 > f_TY2) then
    f_TYMin := f_TY2
  else
    f_TYMin := f_TY1;

  if (f_TY1 > f_TY2) then
    f_TYMax := f_TY1
  else
    f_TYMax := f_TY2;

  if (((p_Y - m_SelectMaxMin >= f_TYMin) and (p_Y - m_SelectMaxMin <= f_TYMax)) or
      ((f_TYMax >= p_Y + m_SelectMaxMin) and (f_TYMax <= p_Y - m_SelectMaxMin))) then
    m_Hit := true;

  f_TY1 := Math.Floor(f_slide * (p_X - m_SelectMaxMin - f_X3) + f_Y3);
  f_TY2 := Math.Floor(f_slide * (p_X + m_SelectMaxMin - f_X3) + f_Y3);
  if (f_TY1 > f_TY2) then
    f_TYMin := f_TY2
  else
    f_TYMin := f_TY1;

  if (f_TY1 > f_TY2) then
    f_TYMax := f_TY1
  else
    f_TYMax := f_TY2;

  if (((p_Y - m_SelectMaxMin >= f_TYMin) and (p_Y - m_SelectMaxMin <= f_TYMax)) or
      ((f_TYMax >= p_Y + m_SelectMaxMin) and (f_TYMax <= p_Y - m_SelectMaxMin))) then
    m_Hit := true;

  if (m_Hit = true) then
  begin
    {
      f_PenColor := m_LineColor;
      f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);
      p_Bitmap.PenColor := f_PenColor;

      F_DrawBox(m_HitOnLayer, f_X1 - m_SelectMaxMin, f_Y1 - m_SelectMaxMin, f_X1 + m_SelectMaxMin, f_Y1 + m_SelectMaxMin, 0);
      F_DrawBox(m_HitOnLayer, f_X2 - m_SelectMaxMin, f_Y2 - m_SelectMaxMin, f_X2 + m_SelectMaxMin, f_Y2 + m_SelectMaxMin, 0);
      F_DrawBox(m_HitOnLayer, f_X3 - m_SelectMaxMin, f_Y3 - m_SelectMaxMin, f_X3 + m_SelectMaxMin, f_Y3 + m_SelectMaxMin, 0);
    }
    if ((f_X1 - m_SelectMaxMin < p_X) and (p_X < f_X1 + m_SelectMaxMin) and (f_Y1 - m_SelectMaxMin < p_Y) and
        (p_Y < f_Y1 + m_SelectMaxMin)) then
      m_SelectType := 1
    else if ((f_X2 - m_SelectMaxMin < p_X) and (p_X < f_X2 + m_SelectMaxMin) and (f_Y2 - m_SelectMaxMin < p_Y) and
        (p_Y < f_Y2 + m_SelectMaxMin)) then
      m_SelectType := 2
    else if ((f_X3 - m_SelectMaxMin < p_X) and (p_X < f_X3 + m_SelectMaxMin) and (f_Y3 - m_SelectMaxMin < p_Y) and
        (p_Y < f_Y3 + m_SelectMaxMin)) then
      m_SelectType := 3
    else
      m_SelectType := 0;
  end;

  Result := m_Hit;
end;

// ---------------------------------------------------------------------------
procedure CMKAVAndrewsPitchFork.OnMouseDown(p_X, p_Y: Integer);
begin
  if (m_Drawing) then
  begin
    Inc(m_Step);
    if (m_Step = 1) then
    begin
      m_X1 := GetRealX(p_X);
      m_Y1 := GetRealY(p_Y);
      if (m_X1 < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
        m_X1 := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin;
      if (m_X1 > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
        m_X1 := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax;
    end
    else if (m_Step = 2) then
    begin
      m_X2 := GetRealX(p_X);
      m_Y2 := GetRealY(p_Y);
      if (m_X2 < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
        m_X2 := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin;
      if (m_X2 > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
        m_X2 := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax;
    end
    else if (m_Step = 3) then
    begin
      m_X3 := GetRealX(p_X);
      m_Y3 := GetRealY(p_Y);
      if (m_X3 < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
        m_X3 := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin;
      if (m_X3 > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
        m_X3 := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax;
    end;

    m_OldX := GetRealX(p_X);
    m_OldY := GetRealY(p_Y);
    CMKAVDrawManager(m_Manager).SetSelected(Self);

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
procedure CMKAVAndrewsPitchFork.OnMouseUp(p_X, p_Y: Integer);
begin
  if (m_Drawing) then
  begin
    if (m_Step >= 3) then
    begin
      m_Drawing := false;
      CMKAVDrawManager(m_Manager).CompleteDrawObject();
      m_Step := 0;
    end;

    XValueToDate();
  end;

  m_CaptureMouse := false;
  m_SelectType := 0;
end;

// ---------------------------------------------------------------------------
procedure CMKAVAndrewsPitchFork.OnMouseMove(p_X, p_Y: Integer);
begin
  if (m_Drawing) then
  begin

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
      else if (m_SelectType = 3) then
      begin
        if (m_X3 + (m_NewX - m_OldX) < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
          exit;
        if (m_X3 + (m_NewX - m_OldX) > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
          exit;
        m_X3 := m_X3 + (m_NewX - m_OldX);
        m_Y3 := m_Y3 + (m_NewY - m_OldY);
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
        if (m_X3 + (m_NewX - m_OldX) < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
          exit;
        if (m_X3 + (m_NewX - m_OldX) > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
          exit;

        m_X1 := m_X1 + (m_NewX - m_OldX);
        m_X2 := m_X2 + (m_NewX - m_OldX);
        m_X3 := m_X3 + (m_NewX - m_OldX);
        m_Y1 := m_Y1 + (m_NewY - m_OldY);
        m_Y2 := m_Y2 + (m_NewY - m_OldY);
        m_Y3 := m_Y3 + (m_NewY - m_OldY);
      end;

      m_OldX := m_NewX;
      m_OldY := m_NewY;

      XValueToDate();
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVAndrewsPitchFork.DrawDefaultLayer(p_Bitmap: TBitmap32);
var
  f_X1, f_X2, f_X3: Integer;
  f_Y1, f_Y2, f_Y3: Integer;
  f_Label: String;
  f_ChartData: CMKChartData;

  f_PenColor: TColor32;
begin
  if CMKChartBlock(m_ChartBlock).m_ChartDataSeries = NIL then
    exit;
  if ((m_X1 < 0) or (m_X2 < 0) or (m_X3 < 0)) then
    exit;

  f_X1 := GetScreenXCenter(m_X1);
  f_X2 := GetScreenXCenter(m_X2);
  f_X3 := GetScreenXCenter(m_X3);
  f_Y1 := Math.Floor(GetScreenY(m_Y1));
  f_Y2 := Math.Floor(GetScreenY(m_Y2));
  f_Y3 := Math.Floor(GetScreenY(m_Y3));

  if (m_Step = 0) then
  begin
    if (m_Selected) then
    begin
      f_PenColor := m_LineColor;
      f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);
      p_Bitmap.PenColor := f_PenColor;

      DrawAndrewsPitchFork(p_Bitmap);
      DrawBox(p_Bitmap, f_X1 - m_SelectMaxMin, f_Y1 - m_SelectMaxMin, f_X1 + m_SelectMaxMin, f_Y1 + m_SelectMaxMin, 1);
      DrawBox(p_Bitmap, f_X2 - m_SelectMaxMin, f_Y2 - m_SelectMaxMin, f_X2 + m_SelectMaxMin, f_Y2 + m_SelectMaxMin, 1);
      DrawBox(p_Bitmap, f_X3 - m_SelectMaxMin, f_Y3 - m_SelectMaxMin, f_X3 + m_SelectMaxMin, f_Y3 + m_SelectMaxMin, 1);

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

      if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_Items.Count > Round(m_X3)) then
      begin
        f_ChartData := CMKChartData(CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_Items.Items[Round(m_X3)]);
        f_Label := TMKGlobal.DateToYYYY_MM_DD(f_ChartData.m_Year, f_ChartData.m_Month, f_ChartData.m_Day);
        if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_TimeFrame < 360) then
        begin
          f_Label := f_Label + ' ' + TMKGlobal.TimeToHH_MM(f_ChartData.m_Hour, f_ChartData.m_Min);
        end
        else if (CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_TimeFrame > 9000) then
        begin
          f_Label := f_Label + ' ' + TMKGlobal.TimeToHH_MM_SS(f_ChartData.m_Hour, f_ChartData.m_Min, f_ChartData.m_Sec);
        end;
        f_Label := f_Label + ' ' + TMKGlobal.NumberToString(m_Y3, 2);
        DrawText(p_Bitmap, f_Label, f_X3, f_Y3, 0, 0);
      end;
    end
    else
    begin
      f_PenColor := m_LineColor;
      f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);
      p_Bitmap.PenColor := f_PenColor;

      DrawAndrewsPitchFork(p_Bitmap);

      if (m_Hit) then
      begin
        DrawBox(p_Bitmap, f_X1 - m_SelectMaxMin, f_Y1 - m_SelectMaxMin, f_X1 + m_SelectMaxMin, f_Y1 + m_SelectMaxMin, 0);
        DrawBox(p_Bitmap, f_X2 - m_SelectMaxMin, f_Y2 - m_SelectMaxMin, f_X2 + m_SelectMaxMin, f_Y2 + m_SelectMaxMin, 0);
        DrawBox(p_Bitmap, f_X3 - m_SelectMaxMin, f_Y3 - m_SelectMaxMin, f_X3 + m_SelectMaxMin, f_Y3 + m_SelectMaxMin, 0);
      end;
    end;
  end
  else
  begin
    PosPaint(p_Bitmap);
  end;
  // }
end;

end.
