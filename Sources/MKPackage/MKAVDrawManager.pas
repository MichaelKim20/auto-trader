unit MKAVDrawManager;

interface

uses
  SysUtils, Types, Classes, Math, GR32, StdCtrls, Messages, Windows, GR32_Layers, Contnrs, ExtCtrls,
  MKStreamChartDataSeries, MKColorSet, MKConst, MKMaxMin, FNThread, SyncObjs,
  MKChartData, MKLineValueSeries, Graphics,
  MKAVDrawingObject;

type
  CMKAVDrawManager = class(TObject)
  public const
    DRAW_OBJECT_COLOR: Integer = $00557095;

  private
    m_DrawObjectArray: TList;

    m_ParentLayer: TBitmapLayer;
    m_OverLayer: TBitmapLayer;
    m_DefaultLayer: TBitmapLayer;
    m_HitOnLayer: TBitmapLayer;

    m_ColorSet: CMKColorSet;
    m_DrawObjectType: Integer;
    m_DrawObject: CMKAVDrawingObject;
    m_DrawObjectColor: Integer;

    m_FX: Integer;
    m_FY: Integer;
    m_CharDiff: Integer;
    m_CharCount: Integer;

  public
    m_ChartBlock: TObject;

    constructor Create();
    destructor Destroy(); override;

    procedure SetLayer(p_Layer: TBitmapLayer);
    procedure Clear();
    procedure Paint();

    procedure AddObject(p_DrawObject: CMKAVDrawingObject);
    procedure DeleteObject(p_DrawObject: CMKAVDrawingObject);
    procedure DeleteObjectAll();
    procedure SetSelected(p_DrawObject: CMKAVDrawingObject);
    procedure SetDrawObjectColor(p_Color: Integer);
    procedure StartDrawObject(p_ObjectType: Integer);
    procedure StartDrawingCharObject(p_TextList: TStrings; p_font: TFont);
    procedure EndDrawObject();
    procedure CompleteDrawObject();
    procedure SetColorSet(p_ColorSet: CMKColorSet);

    function OnMouseDown(p_X: Integer; p_Y: Integer): Boolean;
    function OnMouseUp(p_X: Integer; p_Y: Integer): Boolean;
    function OnMouseMove(p_X: Integer; p_Y: Integer): Boolean;

    procedure XValueToDate();
    procedure XDateToValue();
    procedure LayOut();
    procedure OnPaintDrawLayer(Sender: TObject; Buffer: TBitmap32);
    procedure OnPaintHitOnLayer(Sender: TObject; Buffer: TBitmap32);
  end;

implementation

uses
  MKGlobal, MKChartDefine, MKAVChartBlockManager, MKAVChartBlock,
  MKAVDrawingChartObject, MKAVLine, MKAVVLine, MKAVHLine, MKAVCrossLine, MKAVRectangle,
  MKAVCircle, MKAVSplit, MKAVSpeedLine, MKAVGannFan, MKAVFibonacciRetracement, MKAVFibonacciTimeZone,
  MKAVAndrewsPitchFork;

// ---------------------------------------------------------------------------
constructor CMKAVDrawManager.Create();
begin
  inherited Create;

  m_DrawObjectArray := TList.Create();
  m_DrawObjectType := -1;
  m_FX := 100;
  m_FY := 100;
  m_CharCount := 0;
  m_CharDiff := 15;
  m_ColorSet := NIL;

  m_DrawObjectColor := DRAW_OBJECT_COLOR;
end;

// ---------------------------------------------------------------------------
destructor CMKAVDrawManager.Destroy();
begin
  DeleteObjectAll();
  Clear();

  if Assigned(m_DrawObjectArray) then
  begin
    m_DrawObjectArray.Free();
    m_DrawObjectArray := NIL;
  end;

  if Assigned(m_DefaultLayer) then
  begin
    m_DefaultLayer.OnPaint := NIL;
    m_DefaultLayer.Free;
    m_DefaultLayer := NIL;
  end;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.SetLayer(p_Layer: TBitmapLayer);
begin
  m_ParentLayer := p_Layer;

  if Assigned(m_DefaultLayer) then
  begin
    m_DefaultLayer.OnPaint := NIL;
    m_DefaultLayer.Free;
    m_DefaultLayer := NIL;
  end;

  m_DefaultLayer := TBitmapLayer.Create(m_ParentLayer.LayerCollection);
  m_DefaultLayer.Bitmap.DrawMode := dmBlend;
  m_DefaultLayer.OnPaint := OnPaintDrawLayer;

  LayOut();
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.Clear;
var
  f_Index: Integer;
  I: Integer;
begin
  for f_Index := 0 to m_DrawObjectArray.Count - 1 do
  begin
    CMKAVDrawingObject(m_DrawObjectArray.Items[f_Index]).Clear();
  end;

  if Assigned(m_DefaultLayer) then
  begin
    m_DefaultLayer.Bitmap.Clear($00000000);
  end;

end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.Paint;
var
  f_Index: Integer;
begin
  m_DefaultLayer.Update;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.AddObject(p_DrawObject: CMKAVDrawingObject);
begin
  p_DrawObject.m_Manager := Self;
  p_DrawObject.m_ChartBlock := m_ChartBlock;
  p_DrawObject.m_DefaultLayer := m_DefaultLayer;
  m_DrawObjectArray.Add(p_DrawObject);
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.DeleteObject(p_DrawObject: CMKAVDrawingObject);
var
  f_Index: Integer;
begin
  for f_Index := 0 to m_DrawObjectArray.Count - 1 do
  begin
    if (CMKAVDrawingObject(m_DrawObjectArray.Items[f_Index]) = p_DrawObject) then
    begin
      CMKAVDrawingObject(m_DrawObjectArray.Items[f_Index]).Free();

      m_DrawObjectArray.Delete(f_Index);
      break;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.DeleteObjectAll;
begin
  while (0 < m_DrawObjectArray.Count) do
  begin
    CMKAVDrawingObject(m_DrawObjectArray.Items[0]).Free();
    m_DrawObjectArray.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.SetSelected(p_DrawObject: CMKAVDrawingObject);
var
  f_Index: Integer;
  f_reDraw: Boolean;
  f_DrawObject: CMKAVDrawingObject;

begin
  f_reDraw := false;
  for f_Index := 0 to m_DrawObjectArray.Count - 1 do
  begin
    f_DrawObject := CMKAVDrawingObject(m_DrawObjectArray.Items[f_Index]);
    if (f_DrawObject = p_DrawObject) then
    begin
      if (f_DrawObject.m_Selected) then
        f_reDraw := true;

      f_DrawObject.m_Selected := true;
      // f_reDraw := true;
    end
    else
    begin
      if (f_DrawObject.m_Selected) then
        f_reDraw := true;

      f_DrawObject.m_Selected := false;
    end;
  end;

  if (f_reDraw) then
  begin
    Clear();
    Paint();
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.SetDrawObjectColor(p_Color: Integer);
begin
  m_DrawObjectColor := p_Color;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.StartDrawObject(p_ObjectType: Integer);
var
  f_Line: CMKAVLine;
  f_HLine: CMKAVHLine;
  f_VLine: CMKAVVLine;
  f_CrossLine: CMKAVCrossLine;
  f_Rectangle: CMKAVRectangle;
  f_Circle: CMKAVCircle;
  f_Split: CMKAVSplit;
  f_SpeedLine: CMKAVSpeedLine;
  f_GannFan: CMKAVGannFan;
  f_FibonacciRetracement: CMKAVFibonacciRetracement;
  f_FibonacciTimeZone: CMKAVFibonacciTimeZone;
  f_AndrewsPitchFork: CMKAVAndrewsPitchFork;

  f_ObjectIndex: Integer;
  f_Delete: Boolean;
begin
  case p_ObjectType of
    CMKAVDrawingObject.DOT_TRENDLINE:
      begin
        f_Line := CMKAVLine.Create();
        f_Line.SetColor(m_DrawObjectColor);
        f_Line.m_Drawing := true;
        AddObject(f_Line);
        m_DrawObject := f_Line;
        m_DrawObjectType := p_ObjectType;
      end;
    CMKAVDrawingObject.DOT_VERTICALLINE:
      begin
        f_VLine := CMKAVVLine.Create();
        f_VLine.SetColor(m_DrawObjectColor);
        f_VLine.m_Drawing := true;
        AddObject(f_VLine);
        m_DrawObject := f_VLine;
        m_DrawObjectType := p_ObjectType;
      end;
    CMKAVDrawingObject.DOT_HORIZONLINE:
      begin
        f_HLine := CMKAVHLine.Create();
        f_HLine.SetColor(m_DrawObjectColor);
        f_HLine.m_Drawing := true;
        AddObject(f_HLine);
        m_DrawObject := f_HLine;
        m_DrawObjectType := p_ObjectType;
      end;
    CMKAVDrawingObject.DOT_CROSSLINE:
      begin
        f_CrossLine := CMKAVCrossLine.Create();
        f_CrossLine.SetColor(m_DrawObjectColor);
        f_CrossLine.m_Drawing := true;
        AddObject(f_CrossLine);
        m_DrawObject := f_CrossLine;
        m_DrawObjectType := p_ObjectType;
      end;
    CMKAVDrawingObject.DOT_RECTANGLE:
      begin
        f_Rectangle := CMKAVRectangle.Create();
        f_Rectangle.SetColor(m_DrawObjectColor);
        f_Rectangle.m_Drawing := true;
        AddObject(f_Rectangle);
        m_DrawObject := f_Rectangle;
        m_DrawObjectType := p_ObjectType;
      end;
    CMKAVDrawingObject.DOT_CIRCLE:
      begin
        f_Circle := CMKAVCircle.Create();
        f_Circle.SetColor(m_DrawObjectColor);
        f_Circle.m_Drawing := true;
        AddObject(f_Circle);
        m_DrawObject := f_Circle;
        m_DrawObjectType := p_ObjectType;
      end;
    CMKAVDrawingObject.DOT_SPLIT3:
      begin
        f_Split := CMKAVSplit.Create();
        f_Split.SetColor(m_DrawObjectColor);
        f_Split.m_Drawing := true;
        f_Split.m_SplitCount := 3;
        AddObject(f_Split);
        m_DrawObject := f_Split;
        m_DrawObjectType := p_ObjectType;
      end;
    CMKAVDrawingObject.DOT_SPLIT4:
      begin
        f_Split := CMKAVSplit.Create();
        f_Split.SetColor(m_DrawObjectColor);
        f_Split.m_Drawing := true;
        f_Split.m_SplitCount := 4;
        AddObject(f_Split);
        m_DrawObject := f_Split;
        m_DrawObjectType := p_ObjectType;
      end;
    CMKAVDrawingObject.DOT_SPEEDLINE:
      begin
        f_SpeedLine := CMKAVSpeedLine.Create();
        f_SpeedLine.SetColor(m_DrawObjectColor);
        f_SpeedLine.m_Drawing := true;
        AddObject(f_SpeedLine);
        m_DrawObject := f_SpeedLine;
        m_DrawObjectType := p_ObjectType;
      end;
    CMKAVDrawingObject.DOT_GANNFAN:
      begin
        f_GannFan := CMKAVGannFan.Create();
        f_GannFan.SetColor(m_DrawObjectColor);
        f_GannFan.m_Drawing := true;
        AddObject(f_GannFan);
        m_DrawObject := f_GannFan;
        m_DrawObjectType := p_ObjectType;
      end;
    CMKAVDrawingObject.DOT_FIBONACCIRETRACEMENT:
      begin
        f_FibonacciRetracement := CMKAVFibonacciRetracement.Create();
        f_FibonacciRetracement.SetColor(m_DrawObjectColor);
        f_FibonacciRetracement.m_Drawing := true;
        AddObject(f_FibonacciRetracement);
        m_DrawObject := f_FibonacciRetracement;
        m_DrawObjectType := p_ObjectType;
      end;
    CMKAVDrawingObject.DOT_FIBONACCITIMEZONE:
      begin
        f_FibonacciTimeZone := CMKAVFibonacciTimeZone.Create();
        f_FibonacciTimeZone.SetColor(m_DrawObjectColor);
        f_FibonacciTimeZone.m_Drawing := true;
        AddObject(f_FibonacciTimeZone);
        m_DrawObject := f_FibonacciTimeZone;
        m_DrawObjectType := p_ObjectType;
      end;
    CMKAVDrawingObject.DOT_ANDREWSPITCHFORK:
      begin
        f_AndrewsPitchFork := CMKAVAndrewsPitchFork.Create();
        f_AndrewsPitchFork.SetColor(m_DrawObjectColor);
        f_AndrewsPitchFork.m_Drawing := true;
        AddObject(f_AndrewsPitchFork);
        m_DrawObject := f_AndrewsPitchFork;
        m_DrawObjectType := p_ObjectType;
      end;
    (*
      MW_DrawingObject.DOT_GANNGRID :
      begin
      f_Object = new MW_GannGrid();
      f_Object.F_SetColor(m_DrawObjectColor);
      f_Object.m_Drawing = true;
      F_AddObject(f_Object);
      m_DrawObject = f_Object;
      m_DrawObjectType = p_ObjectType;
      break;
      end;
    *)

    CMKAVDrawingObject.DOT_ERASER:
      begin
        if (m_DrawObjectArray.Count >= 1) then
        begin
          f_Delete := false;
          f_ObjectIndex := m_DrawObjectArray.Count - 1;
          while (f_ObjectIndex >= 0) do
          begin
            if (CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).m_Selected) then
            begin
              CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).Free();
              m_DrawObjectArray.Delete(f_ObjectIndex);
              f_Delete := true;
              break;
            end;

            Dec(f_ObjectIndex);
          end;

          if (not f_Delete) then
          begin
            CMKAVDrawingObject(m_DrawObjectArray.Items[m_DrawObjectArray.Count - 1]).Free();
            m_DrawObjectArray.Delete(m_DrawObjectArray.Count - 1);
          end;
        end;
        Clear();
        Paint();
      end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.StartDrawingCharObject(p_TextList: TStrings; p_font: TFont);
var
  f_DrawingCharObject: CMKAVDrawingChartObject;
begin
  f_DrawingCharObject := CMKAVDrawingChartObject.Create();
  f_DrawingCharObject.m_Drawing := false;

  f_DrawingCharObject.m_LineColor := m_DrawObjectColor;
  f_DrawingCharObject.m_FontColor := Color32(p_font.Color);
  f_DrawingCharObject.m_FontSize := p_font.Size;
  f_DrawingCharObject.m_FontStyle := p_font.Style;
  f_DrawingCharObject.SetStringList(p_TextList);

  Inc(m_CharCount);
  if (m_CharCount > 100) then
    m_CharCount := 0;

  AddObject(f_DrawingCharObject);
  m_DrawObject := f_DrawingCharObject;
  m_DrawObjectType := CMKAVDrawingObject.DOT_CHARINPUT;
  f_DrawingCharObject.SetPosition(m_FX + ((m_CharCount MOD 10) + Math.floor(m_CharCount DIV 10)) * m_CharDiff,
      m_FY + (m_CharCount MOD 10) * m_CharDiff);
  f_DrawingCharObject.XValueToDate();
  CompleteDrawObject();

  Clear();
  Paint();
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.CompleteDrawObject;
begin
  m_DrawObjectType := -1;
  m_DrawObject := NIL;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.SetColorSet(p_ColorSet: CMKColorSet);
begin
  m_ColorSet := p_ColorSet;
  SetDrawObjectColor(m_ColorSet.m_Color[CMKColorSet.DRAW_OBJECT_DEFAULT_COLOR]);
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.EndDrawObject;
var
  f_ObjectIndex: Integer;
  f_Delete: Boolean;
begin
  f_Delete := false;

  f_ObjectIndex := m_DrawObjectArray.Count - 1;
  while (f_ObjectIndex >= 0) do
  begin
    if (CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).m_Drawing) then
    begin
      CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).Free();

      m_DrawObjectArray.Delete(f_ObjectIndex);
      f_Delete := true;
    end;

    Dec(f_ObjectIndex);
  end;

  m_DrawObjectType := -1;
  m_DrawObject := NIL;
  if (f_Delete) then
  begin
    Clear();
    Paint();
  end;
end;

// ---------------------------------------------------------------------------
function CMKAVDrawManager.OnMouseDown(p_X, p_Y: Integer): Boolean;
var
  f_Action: Boolean;
  f_ObjectIndex: Integer;
  f_reDraw: Boolean;
begin
  f_Action := false;

  if (m_DrawObjectArray <> NIL) then
  begin
    if (m_DrawObjectType >= 1) then
    begin
      m_DrawObject.OnMouseDown(p_X, p_Y);
      Result := true;
      exit;
    end;

    f_reDraw := false;

    f_ObjectIndex := m_DrawObjectArray.Count - 1;
    while (f_ObjectIndex >= 0) do
    begin
      if (CMKAVDrawingObject(m_DrawObjectArray[f_ObjectIndex]).HitTest(p_X, p_Y)) then
      begin
        CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).OnMouseDown(p_X, p_Y);
        f_Action := true;
        break;
      end;

      Dec(f_ObjectIndex);
    end;

    if (not f_Action) then
    begin
      f_reDraw := false;

      f_ObjectIndex := m_DrawObjectArray.Count - 1;
      while (f_ObjectIndex >= 0) do
      begin
        if (CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).m_Selected) then
          f_reDraw := true;

        CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).m_Selected := false;
        CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).m_CaptureMouse := false;

        Dec(f_ObjectIndex);
      end;

      if (f_reDraw) then
      begin
        Clear();
        Paint();
      end;
    end;
  end;

  Result := f_Action;
end;

// ---------------------------------------------------------------------------
function CMKAVDrawManager.OnMouseMove(p_X, p_Y: Integer): Boolean;
var
  f_Action: Boolean;
  f_ObjectIndex: Integer;
begin
  f_Action := false;

  if (m_DrawObjectArray <> NIL) then
  begin
    m_DefaultLayer.Bitmap.Clear($00000000);

    if (m_DrawObjectType >= 1) then
    begin
      m_DrawObject.OnMouseMove(p_X, p_Y);
      Result := true;
      exit;
    end;

    f_ObjectIndex := m_DrawObjectArray.Count - 1;
    f_Action := false;

    while (f_ObjectIndex >= 0) do
    begin
      if (CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).m_CaptureMouse) then
      begin
        CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).OnMouseMove(p_X, p_Y);
        f_Action := true;
        break;
      end;

      Dec(f_ObjectIndex);
    end;

    if (not f_Action) then
    begin
      f_ObjectIndex := m_DrawObjectArray.Count - 1;
      while (f_ObjectIndex >= 0) do
      begin
        if (CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).HitTest(p_X, p_Y)) then
        begin
          CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).OnMouseMove(p_X, p_Y);
          f_Action := true;
          break;
        end;

        Dec(f_ObjectIndex);
      end;
    end;
  end;

  Result := f_Action;
end;

// ---------------------------------------------------------------------------
function CMKAVDrawManager.OnMouseUp(p_X, p_Y: Integer): Boolean;
var
  f_Action: Boolean;
  f_ObjectIndex: Integer;
begin
  f_Action := false;

  if (m_DrawObjectArray <> NIL) then
  begin
    if (m_DrawObjectType >= 1) then
    begin
      m_DrawObject.OnMouseUp(p_X, p_Y);
      Result := true;
      exit;
    end;

    f_ObjectIndex := m_DrawObjectArray.Count - 1;
    while (f_ObjectIndex >= 0) do
    begin
      if (CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).m_CaptureMouse) then
      begin
        CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).OnMouseUp(p_X, p_Y);
        f_Action := true;
        break;
      end;

      Dec(f_ObjectIndex);
    end;
  end;

  Result := f_Action;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.XDateToValue;
var
  f_ObjectIndex: Integer;
begin
  f_ObjectIndex := m_DrawObjectArray.Count - 1;
  while (f_ObjectIndex >= 0) do
  begin
    CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).XDateToValue();

    Dec(f_ObjectIndex);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.XValueToDate;
var
  f_ObjectIndex: Integer;
begin
  f_ObjectIndex := m_DrawObjectArray.Count - 1;
  while (f_ObjectIndex >= 0) do
  begin
    CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).XValueToDate();

    Dec(f_ObjectIndex);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.OnPaintDrawLayer(Sender: TObject; Buffer: TBitmap32);
var
  f_ObjectIndex: Integer;
  f_ClipRect: TRect;
begin
  if (m_DrawObjectArray <> NIL) then
  begin
    for f_ObjectIndex := 0 to m_DrawObjectArray.Count - 1 do
    begin
      f_ClipRect := Rect(CMKChartBlock(m_ChartBlock).m_AxisRect.Left, CMKChartBlock(m_ChartBlock).m_AxisRect.Top,
          CMKChartBlock(m_ChartBlock).m_AxisRect.Right, CMKChartBlock(m_ChartBlock).m_AxisRect.Bottom - 1);
      Buffer.ResetClipRect;
      Buffer.ClipRect := f_ClipRect;

      CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).DrawDefaultLayer(Buffer);

      Buffer.ResetClipRect;
      Buffer.ClipRect := f_ClipRect;
    end;
  end;
end;

procedure CMKAVDrawManager.OnPaintHitOnLayer(Sender: TObject; Buffer: TBitmap32);
var
  f_ObjectIndex: Integer;
  f_ClipRect: TRect;
begin
  for f_ObjectIndex := 0 to m_DrawObjectArray.Count - 1 do
  begin
    f_ClipRect := Rect(CMKChartBlock(m_ChartBlock).m_AxisRect.Left, CMKChartBlock(m_ChartBlock).m_AxisRect.Top,
        CMKChartBlock(m_ChartBlock).m_AxisRect.Right, CMKChartBlock(m_ChartBlock).m_AxisRect.Bottom - 1);
    Buffer.ResetClipRect;
    Buffer.ClipRect := f_ClipRect;

    CMKAVDrawingObject(m_DrawObjectArray.Items[f_ObjectIndex]).DrawHitOnLayer(Buffer);

    Buffer.ResetClipRect;
    Buffer.ClipRect := f_ClipRect;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKAVDrawManager.LayOut();
begin
  m_DefaultLayer.Location := m_ParentLayer.Location;
  m_DefaultLayer.Bitmap.SetSize(m_ParentLayer.Bitmap.Width, m_ParentLayer.Bitmap.Height);

end;

end.
