unit MKAVFibonacciRetracement;

interface

uses
  SysUtils, Types, Classes, Math, GR32, StdCtrls, Messages, Windows, GR32_Layers, Contnrs, ExtCtrls,
  MKStreamChartDataSeries, MKColorSet, MKConst, MKMaxMin, FNQueue, FNThread, SyncObjs,
  MKChartData, MKLineValueSeries,
  MKAVDrawingObject;

type
  /// /////////////////////////////////////////////////////////////////////////
  //
  CMKAVFibonacciRetracement = class(CMKAVDrawingObject)
  private
    m_X1Date: TDateTime;
    m_X2Date: TDateTime;
    m_X1: Double;
    m_Y1: Double;
    m_X2: Double;
    m_Y2: Double;
    m_OldX: Double;
    m_OldY: Double;
    m_NewX: Double;
    m_NewY: Double;
    m_Step: Integer;
    m_SelectType: Integer;
    m_FibonacciPercentArray: Array [0 .. 8] of Double;
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

    procedure DrawFibonacciRetracement(p_MC: TBitmap32);
    procedure ClearText();
  end;

implementation

uses
  MKGlobal, MKChartDefine, MKAVDrawManager, MKAVChartBlock;

/// //////////////////////////////////////////////////////////////////////////
// CMKAVVLine
// ---------------------------------------------------------------------------
constructor CMKAVFibonacciRetracement.Create();
begin
  inherited Create;

  m_Step := 0;
  m_SelectType := 0;
  m_FibonacciPercentArray[0] := 0;
  m_FibonacciPercentArray[1] := 23.6;
  m_FibonacciPercentArray[2] := 38.2;
  m_FibonacciPercentArray[3] := 50;
  m_FibonacciPercentArray[4] := 61.8;
  m_FibonacciPercentArray[5] := 100;
  m_FibonacciPercentArray[6] := 161.8;
  m_FibonacciPercentArray[7] := 261.8;
  m_FibonacciPercentArray[8] := 423.6;

  m_Hit := false;
end;

// ---------------------------------------------------------------------------
destructor CMKAVFibonacciRetracement.Destroy();
begin
  ClearText();

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CMKAVFibonacciRetracement.Clear();
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
procedure CMKAVFibonacciRetracement.ClearText;
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVFibonacciRetracement.XValueToDate;
begin
  if (m_X1 >= 0) then
    m_X1Date := GetDate(Math.Floor(m_X1));

  if (m_X2 >= 0) then
    m_X2Date := GetDate(Math.Floor(m_X2));
end;

// ---------------------------------------------------------------------------
procedure CMKAVFibonacciRetracement.XDateToValue;
begin
  m_X1 := GetIndex(m_X1Date);
  m_X2 := GetIndex(m_X2Date);
end;

procedure CMKAVFibonacciRetracement.DrawFibonacciRetracement(p_MC: TBitmap32);
var
  f_he: Double;
  f_sy: Double;
  f_Index5: Integer;
begin
  if (m_Y1 > m_Y2) then
  begin
    f_sy := m_Y1;
  end
  else
  begin
    f_sy := m_Y2;
  end;

  f_he := Abs(m_Y1 - m_Y2);
  for f_Index5 := 0 to Length(m_FibonacciPercentArray) - 1 do
  begin
    p_MC.MoveTo(GetScreenXCenter(m_X1), Math.Floor(GetScreenY(f_sy - f_he * m_FibonacciPercentArray[f_Index5] / 100)));
    p_MC.LineToAS(GetScreenXCenter(m_X2), Math.Floor(GetScreenY(f_sy - f_he * m_FibonacciPercentArray[f_Index5] / 100)));
  end;
end;

// ---------------------------------------------------------------------------
function CMKAVFibonacciRetracement.HitTest(p_X, p_Y: Integer): Boolean;
var
  f_LXMin: Double;
  f_LXMax: Double;
  f_LYMin: Double;
  f_LYMax: Double;
  f_LYLast: Double;

  f_DX1: Integer;
  f_DX2: Integer;
  f_DY1: Double;
  f_DY2: Double;
  f_X1: Integer;
  f_Y1: Double;
  f_X2: Integer;
  f_Y2: Double;

  f_Height: Double;
  f_IndPos: Double;
  f_Index5: Integer;
begin
  m_Hit := false;

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
  f_Y1 := GetScreenY(f_LYMax);
  f_Y2 := GetScreenY(f_LYMin);
  f_DX1 := GetRealX(p_X - m_SelectMaxMin);
  f_DX2 := GetRealX(p_X + m_SelectMaxMin);
  f_DY1 := GetRealY(p_Y + m_SelectMaxMin);
  f_DY2 := GetRealY(p_Y - m_SelectMaxMin);
  f_Height := Abs(m_Y1 - m_Y2);
  f_LYLast := f_LYMax - f_Height * m_FibonacciPercentArray[Length(m_FibonacciPercentArray) - 1] / 100;

  if ((f_DX2 >= f_LXMin) and (f_DX1 <= f_LXMax) and (f_DY2 >= f_LYLast) and (f_DY1 <= f_LYMax)) then
  begin
    for f_Index5 := 0 to Length(m_FibonacciPercentArray) - 1 do
    begin
      f_IndPos := f_Height * m_FibonacciPercentArray[f_Index5] / 100;
      if ((f_DY1 <= (f_LYMax - f_IndPos)) and ((f_LYMax - f_IndPos) <= f_DY2)) then
      begin
        m_Hit := true;
        break;
      end;
    end;

    if (m_Hit = true) then
    begin
      if ((f_X1 - m_SelectMaxMin < p_X) and (p_X < f_X1 + m_SelectMaxMin) and (f_Y1 - m_SelectMaxMin < p_Y) and
          (p_Y < f_Y1 + m_SelectMaxMin)) then
      begin
        if (m_X1 < m_X2) then
          m_SelectType := 1
        else
          m_SelectType := 2;
      end
      else if ((f_X2 - m_SelectMaxMin < p_X) and (p_X < f_X2 + m_SelectMaxMin) and (f_Y2 - m_SelectMaxMin < p_Y) and
          (p_Y < f_Y2 + m_SelectMaxMin)) then
      begin
        if (m_X1 < m_X2) then
          m_SelectType := 2
        else
          m_SelectType := 1;
      end
      else
      begin
        m_SelectType := 0;
      end;
    end;
  end;

  Result := m_Hit;
end;

// ---------------------------------------------------------------------------
procedure CMKAVFibonacciRetracement.OnMouseDown(p_X, p_Y: Integer);
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
procedure CMKAVFibonacciRetracement.OnMouseUp(p_X, p_Y: Integer);
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
procedure CMKAVFibonacciRetracement.OnMouseMove(p_X, p_Y: Integer);
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
procedure CMKAVFibonacciRetracement.DrawDefaultLayer(p_Bitmap: TBitmap32);
var
  f_X1, f_X2: Integer;
  f_Y1, f_Y2: Integer;
  f_Label: String;
  f_ChartData: CMKChartData;

  f_LXMin: Double;
  f_LXMax: Double;
  f_LYMin: Double;
  f_LYMax: Double;

  f_PenColor: TColor32;
begin
  if CMKChartBlock(m_ChartBlock).m_ChartDataSeries = NIL then
    exit;
  if ((m_X1 <= 0) or (m_X2 <= 0)) then
    exit;

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

    DrawFibonacciRetracement(p_Bitmap);
    DrawBox(p_Bitmap, f_X1 - m_SelectMaxMin, f_Y1 - m_SelectMaxMin, f_X1 + m_SelectMaxMin, f_Y1 + m_SelectMaxMin, 1);
    DrawBox(p_Bitmap, f_X2 - m_SelectMaxMin, f_Y2 - m_SelectMaxMin, f_X2 + m_SelectMaxMin, f_Y2 + m_SelectMaxMin, 1);

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

    DrawFibonacciRetracement(p_Bitmap);

    if m_Hit then
    begin
      DrawBox(p_Bitmap, f_X1 - m_SelectMaxMin, f_Y1 - m_SelectMaxMin, f_X1 + m_SelectMaxMin, f_Y1 + m_SelectMaxMin, 0);
      DrawBox(p_Bitmap, f_X2 - m_SelectMaxMin, f_Y2 - m_SelectMaxMin, f_X2 + m_SelectMaxMin, f_Y2 + m_SelectMaxMin, 0);
    end;
  end;
end;

end.
