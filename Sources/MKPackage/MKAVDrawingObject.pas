unit MKAVDrawingObject;

interface

uses
  SysUtils, Types, Classes, Math, GR32, StdCtrls, Messages, Windows, GR32_Layers, Contnrs, ExtCtrls,
  MKStreamChartDataSeries, MKColorSet, MKConst, MKMaxMin, FNThread, SyncObjs, Graphics,
  MKChartData, MKLineValueSeries;

type
  /// /////////////////////////////////////////////////////////////////////////
  //
  CMKAVDrawingObject = class(TObject)
  private
    m_Name: String;
    m_Type: Integer;
    m_LineWidth: Integer;
    m_DefaultFontColor: Integer;

  public const
    DOT_TRENDLINE = 1;
    DOT_VERTICALLINE = 2;
    DOT_HORIZONLINE = 3;
    DOT_CROSSLINE = 4;
    DOT_RECTANGLE = 5;
    DOT_CIRCLE = 6;
    DOT_SPLIT3 = 7;
    DOT_SPLIT4 = 8;
    DOT_GANNFAN = 9;
    DOT_FIBONACCITIMEZONE = 10;
    DOT_FIBONACCIRETRACEMENT = 11;
    DOT_ANDREWSPITCHFORK = 12;
    DOT_SPEEDLINE = 13;
    DOT_GANNGRID = 14;
    DOT_CHARINPUT = 15;
    DOT_ERASER = 99;
    DOT_DEFAULT = 0;

  public
    m_ChartBlock: TObject;

    m_OverLayer: TBitmapLayer;
    m_DefaultLayer: TBitmapLayer;
    m_HitOnLayer: TBitmapLayer;
    m_Manager: TObject;
    m_Selected: Boolean;
    m_Drawing: Boolean;
    m_SelectMaxMin: Integer;
    m_CaptureMouse: Boolean;
    m_LineColor: Integer;
    m_LineAlpha: Integer;
    m_Font: String;
    m_FontSize: Integer;
    m_FontColor: Integer;
    m_FontStyle: TFontStyles;

    constructor Create();
    destructor Destroy(); override;

    procedure Finalize(); Virtual;
    procedure Paint(); Virtual;
    procedure DrawDefaultLayer(p_Bitmap: TBitmap32); Virtual;
    procedure DrawHitOnLayer(p_Bitmap: TBitmap32); Virtual;

    procedure Clear(); Virtual;
    procedure XValueToDate(); Virtual;
    procedure XDateToValue(); Virtual;

    function GetScreenX(RX: Double): Integer;
    function GetScreenXCenter(RX: Double): Integer;
    function GetRealX(IX: Double): Integer;
    function GetScreenY(RY: Double): Double;
    function GetRealY(IY: Double): Double;
    function GetDate(p_Index: Integer): TDateTime;
    function GetIndex(p_Date: TDateTime): Integer;
    function GetMaxStringWidth(p_Bitmap: TBitmap32; p_List: TStringList): Integer;
    function GetMaxStringHeight(p_Bitmap: TBitmap32; p_List: TStringList): Integer;

    procedure DrawBox(p_Bitmap: TBitmap32; f_X1: Integer; f_Y1: Integer; f_X2: Integer; f_Y2: Integer; p_ISFill: Integer);
    procedure DrawText(p_Bitmap: TBitmap32; str: String; p_X1: Integer; p_Y1: Integer; xalign: Integer; yalign: Integer;
        nobox: Boolean = false; htmlText: Boolean = false);
    procedure DrawTextMulti(p_Bitmap: TBitmap32; p_StrList: TStringList; p_X1: Integer; p_Y1: Integer; xalign: Integer;
        yalign: Integer; nobox: Boolean = false; htmlText: Boolean = false);
    procedure SetColor(p_Color: Integer);

    function HitTest(p_X: Integer; p_Y: Integer): Boolean; Virtual;
    procedure OnMouseDown(p_X: Integer; p_Y: Integer); Virtual;
    procedure OnMouseUp(p_X: Integer; p_Y: Integer); Virtual;
    procedure OnMouseMove(p_X: Integer; p_Y: Integer); Virtual;

  end;

implementation

uses
  MKGlobal, MKChartDefine, MKAVDrawManager, MKAVChartBlock;

/// //////////////////////////////////////////////////////////////////////////
// CMKAVDrawingObject
// ---------------------------------------------------------------------------
constructor CMKAVDrawingObject.Create();
begin
  inherited Create;

  m_Name := '';
  m_Type := 0;
  m_Selected := false;
  m_LineColor := $0092B785; // 0x9285b7;
  m_LineWidth := 0;
  m_LineAlpha := TMKGlobal.GetAlphaValue(100);
  m_CaptureMouse := false;
  m_SelectMaxMin := 3;
  m_Font := CMKColorSet.NUMBER_FONT_FAMILY;
  m_FontSize := CMKColorSet.NUMBER_FONT_SMALLSIZE2;
  m_FontColor := $0092B785; // 0x9285b7;
  m_DefaultFontColor := $0092B785; // 0x9285b7;
  m_FontStyle := [];
end;

// ---------------------------------------------------------------------------
destructor CMKAVDrawingObject.Destroy();
begin

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingObject.Clear;
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingObject.Finalize;
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingObject.OnMouseDown(p_X, p_Y: Integer);
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingObject.OnMouseMove(p_X, p_Y: Integer);
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingObject.OnMouseUp(p_X, p_Y: Integer);
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingObject.Paint();
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingObject.DrawDefaultLayer(p_Bitmap: TBitmap32);
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingObject.DrawHitOnLayer(p_Bitmap: TBitmap32);
begin

end;

// ---------------------------------------------------------------------------
function CMKAVDrawingObject.HitTest(p_X: Integer; p_Y: Integer): Boolean;
begin
  Result := false;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingObject.XDateToValue;
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingObject.XValueToDate;
begin

end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingObject.SetColor(p_Color: Integer);
begin
  m_LineColor := p_Color;
  m_FontColor := p_Color;
  m_DefaultFontColor := p_Color;
end;

// ---------------------------------------------------------------------------
function CMKAVDrawingObject.GetDate(p_Index: Integer): TDateTime;
var
  f_ChartData: CMKChartData;
begin
  f_ChartData := CMKChartData(CMKChartBlock(m_ChartBlock).m_ChartDataSeries.m_Items.Items[p_Index]);

  if (f_ChartData <> NIL) then
    Result := f_ChartData.m_CloseDateTime
  else
    Result := 0;
end;

// ---------------------------------------------------------------------------
function CMKAVDrawingObject.GetIndex(p_Date: TDateTime): Integer;
var
  f_SearchIndex: Integer;
begin
  f_SearchIndex := CMKChartBlock(m_ChartBlock).m_ChartDataSeries.SearchByClose2(p_Date, true);
  Result := f_SearchIndex;
end;

// ---------------------------------------------------------------------------
function CMKAVDrawingObject.GetRealX(IX: Double): Integer;
begin
  Result := Math.floor(CMKChartBlock(m_ChartBlock).GetRealX(IX, CMKChartBlock(m_ChartBlock).m_MaxMin));
end;

// ---------------------------------------------------------------------------
function CMKAVDrawingObject.GetRealY(IY: Double): Double;
var
  f_OrginValue: Double;
begin
  Result := CMKChartBlock(m_ChartBlock).GetRealY(IY, CMKChartBlock(m_ChartBlock).m_MaxMin)

end;

// ---------------------------------------------------------------------------
function CMKAVDrawingObject.GetScreenX(RX: Double): Integer;
begin
  Result := Math.floor(CMKChartBlock(m_ChartBlock).GetScreenX(RX, CMKChartBlock(m_ChartBlock).m_MaxMin));
end;

// ---------------------------------------------------------------------------
function CMKAVDrawingObject.GetScreenXCenter(RX: Double): Integer;
begin
  Result := Math.floor(CMKChartBlock(m_ChartBlock).GetScreenXCenter(RX, CMKChartBlock(m_ChartBlock).m_MaxMin));
end;

// ---------------------------------------------------------------------------
function CMKAVDrawingObject.GetScreenY(RY: Double): Double;
var
  f_OrginValue: Double;
begin
  Result := CMKChartBlock(m_ChartBlock).GetScreenY(RY, CMKChartBlock(m_ChartBlock).m_MaxMin)

end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingObject.DrawBox(p_Bitmap: TBitmap32; f_X1: Integer; f_Y1: Integer; f_X2: Integer; f_Y2: Integer;
    p_ISFill: Integer);
var
  f_PenColor: TColor32;
begin
  f_PenColor := m_LineColor;
  f_PenColor := SetAlpha(f_PenColor, m_LineAlpha);

  p_Bitmap.PenColor := f_PenColor;
  p_Bitmap.MoveTo(f_X1, f_Y1);
  p_Bitmap.LineToAS(f_X2, f_Y1);
  p_Bitmap.LineToAS(f_X2, f_Y2);
  p_Bitmap.LineToAS(f_X1, f_Y2);
  p_Bitmap.LineToAS(f_X1, f_Y1);

  if (0 < p_ISFill) then
  begin
    f_PenColor := SetAlpha(f_PenColor, TMKGlobal.GetAlphaValue(100));
    p_Bitmap.FillRectTS(f_X1, f_Y1, f_X2, f_Y2, f_PenColor);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingObject.DrawText(p_Bitmap: TBitmap32; str: String; p_X1: Integer; p_Y1: Integer; xalign: Integer;
    yalign: Integer; nobox: Boolean = false; htmlText: Boolean = false);
var
  f_wi: Integer;

  f_Offset: Integer;
  f_TextWidth: Integer;
  f_TextHeight: Integer;

  f_PenColor: TColor32;
  f_X1, f_Y1: Integer;
  f_X2, f_Y2: Integer;
begin
  p_Bitmap.Font.Name := m_Font;
  p_Bitmap.Font.Size := m_FontSize;
  p_Bitmap.Font.Style := m_FontStyle;
  p_Bitmap.Font.Color := m_FontColor;

  f_Offset := 2;
  f_TextWidth := p_Bitmap.TextWidth(str);
  f_TextHeight := p_Bitmap.TextHeight(str);

  if (xalign = 1) then
    f_X1 := f_X1 - f_TextWidth;

  if (yalign = 1) then
    f_Y1 := f_Y1 - f_TextHeight;

  f_PenColor := m_FontColor;
  f_PenColor := SetAlpha(f_PenColor, TMKGlobal.GetAlphaValue(100));

  f_X1 := p_X1 + f_Offset;
  f_Y1 := p_Y1 + f_Offset;
  p_Bitmap.RenderText(f_X1, f_Y1, str, 0, f_PenColor);

  if (not nobox) then
  begin
    f_X1 := p_X1;
    f_Y1 := p_Y1;
    f_X2 := f_Offset + p_X1 + f_TextWidth;
    f_Y2 := f_Offset + p_Y1 + f_TextHeight + f_Offset;
    DrawBox(p_Bitmap, f_X1, f_Y1, f_X2, f_Y2, 0);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawingObject.DrawTextMulti(p_Bitmap: TBitmap32; p_StrList: TStringList; p_X1: Integer; p_Y1: Integer;
    xalign: Integer; yalign: Integer; nobox: Boolean = false; htmlText: Boolean = false);
var
  f_wi: Integer;

  f_Offset: Integer;
  f_TextWidth: Integer;
  f_TextHeight: Integer;

  f_PenColor: TColor32;
  f_X1, f_Y1: Integer;
  f_X2, f_Y2: Integer;

  f_MaxTitleWidth: Integer;
  f_MaxTitleHeight: Integer;
  f_LineCnt: Integer;
  I: Integer;
begin
  p_Bitmap.Font.Name := m_Font;
  p_Bitmap.Font.Size := m_FontSize;
  p_Bitmap.Font.Style := m_FontStyle;
  p_Bitmap.Font.Color := m_FontColor;

  f_LineCnt := p_StrList.Count;

  f_MaxTitleWidth := GetMaxStringWidth(p_Bitmap, p_StrList);
  f_MaxTitleHeight := GetMaxStringHeight(p_Bitmap, p_StrList);

  for I := 0 to p_StrList.Count - 1 do
  begin
    f_Offset := 2;
    f_TextWidth := p_Bitmap.TextWidth(p_StrList[I]);
    f_TextHeight := p_Bitmap.TextHeight(p_StrList[I]);

    if (xalign = 1) then
      f_X1 := f_X1 - f_TextWidth;

    if (yalign = 1) then
      f_Y1 := f_Y1 - f_TextHeight;

    f_PenColor := m_FontColor;
    f_PenColor := SetAlpha(f_PenColor, TMKGlobal.GetAlphaValue(100));

    f_X1 := p_X1 + f_Offset;
    f_Y1 := p_Y1 + f_Offset + (f_TextHeight * I);
    p_Bitmap.RenderText(f_X1, f_Y1, p_StrList[I], 0, f_PenColor);
  end;

  if (not nobox) then
  begin
    f_X1 := p_X1;
    f_Y1 := p_Y1;
    f_X2 := f_Offset + p_X1 + f_MaxTitleWidth + f_Offset;
    f_Y2 := f_Offset + p_Y1 + f_MaxTitleHeight;
    DrawBox(p_Bitmap, f_X1, f_Y1, f_X2, f_Y2, 0);
  end;
end;

// ---------------------------------------------------------------------------
function CMKAVDrawingObject.GetMaxStringWidth(p_Bitmap: TBitmap32; p_List: TStringList): Integer;
var
  f_TitleWidth: Integer;
  f_MaxTitleWidth: Integer;
  f_Index: Integer;
begin
  f_MaxTitleWidth := 0;
  for f_Index := 0 to p_List.Count - 1 do
  begin
    f_TitleWidth := p_Bitmap.TextWidth(p_List[f_Index]);
    if (f_MaxTitleWidth < f_TitleWidth) then
    begin
      f_MaxTitleWidth := f_TitleWidth;
    end;
  end;

  Result := f_MaxTitleWidth;
end;

// ---------------------------------------------------------------------------
function CMKAVDrawingObject.GetMaxStringHeight(p_Bitmap: TBitmap32; p_List: TStringList): Integer;
var
  f_Offset: Integer;
  f_TitleHeight: Integer;
  f_MaxTitleHeight: Integer;
begin
  Result := 0;

  if (0 < p_List.Count) then
  begin
    f_TitleHeight := p_Bitmap.TextHeight(p_List[0]);
    f_MaxTitleHeight := (f_TitleHeight * p_List.Count);

    Result := f_MaxTitleHeight;
  end;
end;

end.
