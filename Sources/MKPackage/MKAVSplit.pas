unit MKAVSplit;

interface

uses
  SysUtils, Types, Classes, Math, GR32, StdCtrls, Messages, Windows, GR32_Layers, Contnrs, ExtCtrls,
  MKStreamChartDataSeries, MKColorSet, MKConst, MKMaxMin, FNQueue, FNThread, SyncObjs,
  MKChartData, MKLineValueSeries,
  MKAVDrawingObject;

type
  /// /////////////////////////////////////////////////////////////////////////
  //
  CMKAVSplit = class(CMKAVDrawingObject)
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
    m_SplitCount: Integer;

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

    procedure GetPriceMaxMin();
    procedure ClearText();
  end;

implementation

uses
  MKGlobal, MKChartDefine, MKAVDrawManager, MKAVChartBlock;

/// //////////////////////////////////////////////////////////////////////////
// CMKAVVLine
// ---------------------------------------------------------------------------
constructor CMKAVSplit.Create();
begin
  inherited Create;

  m_Step := 0;
  m_SelectType := 0;
  m_SplitCount := 1;
  m_Hit := false;
end;

// ---------------------------------------------------------------------------
destructor CMKAVSplit.Destroy();
begin
  ClearText();

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CMKAVSplit.Clear();
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
procedure CMKAVSplit.ClearText;
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVSplit.XValueToDate;
begin
  if (m_X1 >= 0) then
    m_X1Date := GetDate(Math.Floor(m_X1));

  if (m_X2 >= 0) then
    m_X2Date := GetDate(Math.Floor(m_X2));
end;

// ---------------------------------------------------------------------------
procedure CMKAVSplit.XDateToValue;
begin
  m_X1 := GetIndex(m_X1Date);
  m_X2 := GetIndex(m_X2Date);
end;

procedure CMKAVSplit.GetPriceMaxMin();
var
  f_LXMin: Integer;
  f_LXMax: Integer;
  f_SearchArray: CMKLineValueSeries;
begin
  if (m_X1 > m_X2) then
    f_LXMin := Math.Floor(m_X2)
  else
    f_LXMin := Math.Floor(m_X1);

  if (m_X1 > m_X2) then
    f_LXMax := Math.Floor(m_X1)
  else
    f_LXMax := Math.Floor(m_X2);

  f_SearchArray := CMKChartBlock(m_ChartBlock).FindValueArray(g_IndicatorName[IND_PRICE_NAME]);
  m_Y1 := f_SearchArray.HighestPrice(f_LXMax - f_LXMin + 1, f_SearchArray, 1, f_LXMax);
  m_Y2 := f_SearchArray.LowestPrice(f_LXMax - f_LXMin + 1, f_SearchArray, 2, f_LXMax);
end;

// ---------------------------------------------------------------------------
function CMKAVSplit.HitTest(p_X, p_Y: Integer): Boolean;
var
  f_LXMin: Double;
  f_LXMax: Double;
  f_LYMin: Double;
  f_LYMax: Double;

  f_DX1: Integer;
  f_DX2: Integer;
  f_DY1: Double;
  f_DY2: Double;
  f_IndPos: Double;
  f_X1: Integer;
  f_X2: Integer;
  f_Y1: Double;
  f_Y2: Double;

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

  GetPriceMaxMin();

  if (m_Y1 > m_Y2) then
    f_LYMin := m_Y2
  else
    f_LYMin := m_Y1;

  if (m_Y1 > m_Y2) then
    f_LYMax := m_Y1
  else
    f_LYMax := m_Y2;

  f_IndPos := (f_LYMax - f_LYMin) / m_SplitCount;
  f_X1 := GetScreenXCenter(f_LXMin);
  f_X2 := GetScreenXCenter(f_LXMax);
  f_Y1 := Math.Floor(GetScreenY(f_LYMax));
  f_Y2 := Math.Floor(GetScreenY(f_LYMin));
  f_DX1 := GetRealX(p_X - m_SelectMaxMin);
  f_DX2 := GetRealX(p_X + m_SelectMaxMin);
  f_DY1 := GetRealY(p_Y + m_SelectMaxMin);
  f_DY2 := GetRealY(p_Y - m_SelectMaxMin);

  if ((f_DX2 >= f_LXMin) and (f_DX1 <= f_LXMax) and (f_DY2 >= f_LYMin) and (f_DY1 <= f_LYMax)) then
  begin
    for f_Index5 := 0 to m_SplitCount do
    begin
      if ((f_DY1 <= (f_LYMax - f_IndPos * f_Index5)) and ((f_LYMax - f_IndPos * f_Index5) <= f_DY2)) then
      begin
        m_Hit := true;
        break;
      end;
    end;

    if (m_Hit) then
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
        m_SelectType := 0;
    end;
  end;

  Result := m_Hit;
end;

// ---------------------------------------------------------------------------
procedure CMKAVSplit.OnMouseDown(p_X, p_Y: Integer);
begin
  if (m_Drawing) then
  begin
    m_X1 := Round(GetRealX(p_X));
    if (m_X1 < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
      m_X1 := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin;
    if (m_X1 > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
      m_X1 := CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax;

    m_X2 := m_X1;
    m_OldX := m_X1;
    CMKAVDrawManager(m_Manager).SetSelected(Self);

    m_Step := 1;
    XValueToDate();
  end
  else
  begin
    m_CaptureMouse := true;
    m_OldX := GetRealX(p_X);
    CMKAVDrawManager(m_Manager).SetSelected(Self);
  end;
  m_DefaultLayer.Update();
end;

// ---------------------------------------------------------------------------
procedure CMKAVSplit.OnMouseUp(p_X, p_Y: Integer);
begin
  if (m_Drawing) then
  begin
    m_X2 := Round(GetRealX(p_X));
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
procedure CMKAVSplit.OnMouseMove(p_X, p_Y: Integer);
begin
  if (m_Drawing and (m_Step = 1)) then
  begin
    m_X2 := Round(GetRealX(p_X));
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
      if (m_SelectType = 1) then
      begin
        if (m_X1 + (m_NewX - m_OldX) < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
          exit;
        if (m_X1 + (m_NewX - m_OldX) > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
          exit;

        m_X1 := m_X1 + Round(m_NewX - m_OldX);
      end
      else if (m_SelectType = 2) then
      begin
        if (m_X2 + (m_NewX - m_OldX) < CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMin) then
          exit;
        if (m_X2 + (m_NewX - m_OldX) > CMKChartBlock(m_ChartBlock).m_AbsMaxMin.m_XMax) then
          exit;

        m_X2 := m_X2 + Round(m_NewX - m_OldX);
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

        m_X1 := m_X1 + Round(m_NewX - m_OldX);
        m_X2 := m_X2 + Round(m_NewX - m_OldX);
      end;

      m_OldX := m_NewX;

      XValueToDate();
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVSplit.DrawDefaultLayer(p_Bitmap: TBitmap32);
var
  f_X1, f_X2: Integer;
  f_Y1, f_Y2: Double;
  f_Label: String;
  f_ChartData: CMKChartData;
  f_LXMin: Double;
  f_LXMax: Double;
  f_LYMin: Double;
  f_LYMax: Double;
  f_IndPos: Double;
  f_Index5: Integer;
  f_Index6: Integer;

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

  f_X1 := GetScreenXCenter(f_LXMin);
  f_X2 := GetScreenXCenter(f_LXMax);

  if (m_Selected) then
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);
    p_Bitmap.PenColor := f_PenColor;

    GetPriceMaxMin();
    f_Y1 := GetScreenY(m_Y1);
    f_Y2 := GetScreenY(m_Y2);
    f_IndPos := (f_Y2 - f_Y1) / m_SplitCount;

    for f_Index5 := 0 to m_SplitCount do
    begin
      p_Bitmap.MoveTo(f_X1, Math.Floor(f_Y1 + f_IndPos * f_Index5));
      p_Bitmap.LineToAS(f_X2, Math.Floor(f_Y1 + f_IndPos * f_Index5));
    end;

    DrawBox(p_Bitmap, f_X1 - m_SelectMaxMin, Math.Floor(f_Y1 - m_SelectMaxMin), f_X1 + m_SelectMaxMin,
        Math.Floor(f_Y1 + m_SelectMaxMin), 1);
    DrawBox(p_Bitmap, f_X2 - m_SelectMaxMin, Math.Floor(f_Y2 - m_SelectMaxMin), f_X2 + m_SelectMaxMin,
        Math.Floor(f_Y2 + m_SelectMaxMin), 1);
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
      f_Label := f_Label + ' ' + TMKGlobal.NumberToString(m_Y1, 2);
      DrawText(p_Bitmap, f_Label, f_X1, Math.Floor(f_Y1), 1, 1);
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
      f_Label := f_Label + ' ' + TMKGlobal.NumberToString(m_Y2, 2);
      DrawText(p_Bitmap, f_Label, f_X2, Math.Floor(f_Y2), 0, 0);
    end;
  end
  else
  begin
    f_PenColor := m_LineColor;
    f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);
    p_Bitmap.PenColor := f_PenColor;

    GetPriceMaxMin();
    f_Y1 := GetScreenY(m_Y1);
    f_Y2 := GetScreenY(m_Y2);
    f_IndPos := (f_Y2 - f_Y1) / m_SplitCount;
    for f_Index6 := 0 to m_SplitCount do
    begin
      p_Bitmap.MoveTo(f_X1, Math.Floor(f_Y1 + f_IndPos * f_Index6));
      p_Bitmap.LineToAS(f_X2, Math.Floor(f_Y1 + f_IndPos * f_Index6));
    end;

    if m_Hit then
    begin
      DrawBox(p_Bitmap, f_X1 - m_SelectMaxMin, Math.Floor(f_Y1 - m_SelectMaxMin), f_X1 + m_SelectMaxMin,
          Math.Floor(f_Y1 + m_SelectMaxMin), 0);
      DrawBox(p_Bitmap, f_X2 - m_SelectMaxMin, Math.Floor(f_Y2 - m_SelectMaxMin), f_X2 + m_SelectMaxMin,
          Math.Floor(f_Y2 + m_SelectMaxMin), 0);
    end;
  end;
end;

end.
