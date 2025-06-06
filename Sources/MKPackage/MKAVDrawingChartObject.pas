unit MKAVDrawingChartObject;

interface

uses
  SysUtils, Types, Classes, Math, GR32, StdCtrls, Messages, Windows, GR32_Layers, Contnrs, ExtCtrls,
  MKStreamChartDataSeries, MKColorSet, MKConst, MKMaxMin, FNQueue, FNThread, SyncObjs,
  MKChartData, MKLineValueSeries,
  MKAVDrawingObject;

type
  /// /////////////////////////////////////////////////////////////////////////
  //
  CMKAVDrawingChartObject = class(CMKAVDrawingObject)
  private
    m_XDate: TDateTime;
    m_X: Double;
    m_Y: Double;
    m_Width: Integer;
    m_Height: Integer;
    m_OldX: Double;
    m_OldY: Double;
    m_NewX: Double;
    m_NewY: Double;
    m_Hit: Boolean;
  public
    m_TextList: TStringList;

    constructor Create();
    destructor Destroy(); override;

    procedure XValueToDate(); override;
    procedure XDateToValue(); override;
    procedure Paint(); override;
    procedure DrawDefaultLayer(p_Bitmap: TBitmap32); override;
    procedure Clear(); override;

    function HitTest(p_X: Integer; p_Y: Integer): Boolean; override;
    procedure OnMouseDown(p_X: Integer; p_Y: Integer); override;
    procedure OnMouseUp(p_X: Integer; p_Y: Integer); override;
    procedure OnMouseMove(p_X: Integer; p_Y: Integer); override;

    procedure ClearText();
    procedure SetPosition(p_X: Integer; p_Y: Integer);
    procedure SetStringList(p_Strings: TStrings);

  end;

implementation

uses
  MKGlobal, MKChartDefine, MKAVDrawManager, MKAVChartBlock;

/// //////////////////////////////////////////////////////////////////////////
// CMKAVDrawingChartObject
// ---------------------------------------------------------------------------
constructor CMKAVDrawingChartObject.Create();
begin
  inherited Create;

  m_TextList := TStringList.Create();
  m_Hit := false;
end;

// ---------------------------------------------------------------------------
destructor CMKAVDrawingChartObject.Destroy();
begin
  ClearText();

  m_TextList.Free();

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingChartObject.Clear;
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
procedure CMKAVDrawingChartObject.ClearText;
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingChartObject.XDateToValue;
begin
  m_X := GetIndex(m_XDate);
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingChartObject.XValueToDate;
begin
  if (m_X >= 0) then
    m_XDate := GetDate(Math.Floor(m_X));
end;

// ---------------------------------------------------------------------------
function CMKAVDrawingChartObject.HitTest(p_X, p_Y: Integer): Boolean;
var
  f_DX1, f_DX2: Integer;
  f_DY1, f_DY2: Double;
  f_X: Integer;
  f_Y: Double;
  f_TempFontColor: Integer;
  f_LXMin, f_LXMax: Double;
  f_LYMin, f_LYMax: Double;
begin
  m_Hit := false;

  f_X := GetScreenXCenter(m_X);
  f_Y := GetScreenY(m_Y);
  f_DX1 := GetRealX(p_X - m_SelectMaxMin);
  f_DX2 := GetRealX(p_X + m_SelectMaxMin);
  f_DY1 := GetRealY(p_Y + m_SelectMaxMin);
  f_DY2 := GetRealY(p_Y - m_SelectMaxMin);
  f_LXMin := m_X;
  f_LXMax := GetRealX(f_X + m_Width);
  f_LYMin := GetRealY(f_Y + m_Height);
  f_LYMax := m_Y;

  if ((f_DX2 >= f_LXMin) and (f_DX1 <= f_LXMax) and (f_DY2 >= f_LYMin) and (f_DY1 <= f_LYMax)) then
  begin
    m_Hit := true;
  end
  else
  begin
  end;

  Result := m_Hit;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingChartObject.OnMouseDown(p_X, p_Y: Integer);
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
procedure CMKAVDrawingChartObject.OnMouseUp(p_X, p_Y: Integer);
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

    XValueToDate();
  end;

  m_CaptureMouse := false;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingChartObject.OnMouseMove(p_X, p_Y: Integer);
begin
  if (m_Drawing) then
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
procedure CMKAVDrawingChartObject.Paint;
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingChartObject.DrawDefaultLayer(p_Bitmap: TBitmap32);
var
  f_X: Integer;
  f_Y: Integer;
  f_Label: String;
begin
  if CMKChartBlock(m_ChartBlock).m_ChartDataSeries = NIL then
    exit;
  if ((m_X < 0)) then
    exit;

  p_Bitmap.Font.Name := m_Font;
  p_Bitmap.Font.Size := m_FontSize;
  p_Bitmap.Font.Style := m_FontStyle;
  p_Bitmap.Font.Color := m_FontColor;

  m_Width := GetMaxStringWidth(p_Bitmap, m_TextList); // p_Bitmap.TextWidth(m_Text);
  m_Height := GetMaxStringHeight(p_Bitmap, m_TextList); // p_Bitmap.TextHeight(m_Text);

  f_X := GetScreenXCenter(m_X);
  f_Y := Math.Floor(GetScreenY(m_Y));
  if (m_Selected) then
  begin
    DrawTextMulti(p_Bitmap, m_TextList, f_X, f_Y, 0, 0, false, true);
  end
  else
  begin
    if (m_Hit) then
    begin
      DrawTextMulti(p_Bitmap, m_TextList, f_X, f_Y, 0, 0, false, true);
    end
    else
    begin
      DrawTextMulti(p_Bitmap, m_TextList, f_X, f_Y, 0, 0, true, true);
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingChartObject.SetPosition(p_X, p_Y: Integer);
begin
  m_X := GetRealX(p_X);
  m_Y := GetRealY(p_Y);
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingChartObject.SetStringList(p_Strings: TStrings);
var
  I: Integer;
begin
  m_TextList.Clear;
  for I := 0 to p_Strings.Count - 1 do
  begin
    m_TextList.Add(p_Strings[I]);
  end;
end;

end.
