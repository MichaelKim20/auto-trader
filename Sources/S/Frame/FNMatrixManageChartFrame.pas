unit FNMatrixManageChartFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, GR32_Image, FNMatrixChartControlBase,
  StdCtrls, ComCtrls, MXOption, MXBlock, FNTradeSystem,
  MXSystemManager, FNTrafficManager, FNMatrixLineValueSeries, FNRegistry,
  FNMatrixManageChartControl, MXBlockManager, ActnList, ImgList,
  ToolWin, Buttons, FNMatrixConst, System.Actions;

type
  TMatrixManageChartFrame = class(TFrame)
    Panel2: TPanel;
    SplitterNavigator: TSplitter;
    PanelNavigator: TPanel;
    PanelContent: TPanel;
    Panel4: TPanel;
    ScrollBar1: TScrollBar;
    PageControl1: TPageControl;
    TabSheet4: TTabSheet;
    Panel13: TPanel;
    ListViewValues: TListView;
    Panel10: TPanel;
    MatrixManageChartControl: CFNMatrixManageChartControl;
    ToolBar3: TToolBar;
    ToolButton30: TToolButton;
    ToolButton33: TToolButton;
    ToolButton34: TToolButton;
    ToolButton35: TToolButton;
    ToolButton36: TToolButton;
    ToolButton11: TToolButton;
    ToolButton7: TToolButton;
    ImageListMatrixChart: TImageList;
    ActionListMatrixChart: TActionList;
    Action_1001: TAction;
    Action_1002: TAction;
    Action_1003: TAction;
    Action_1004: TAction;
    Action_2001: TAction;
    PanelSmallView: TPanel;
    SpeedButton1: TSpeedButton;
    Action_2002: TAction;
    PanelToolBar: TPanel;
    Image2: TImage;
    SpeedButton2: TSpeedButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;

    procedure MatrixManageChartControlChartTraceChange(p_Index: Integer; p_ValueX, p_ValueY: Double);

    procedure ListViewValuesData(Sender: TObject; Item: TListItem);

    procedure SplitterNavigatorMoved(Sender: TObject);

    procedure ListViewValuesCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);

    procedure ListViewValuesCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure Action_1001Execute(Sender: TObject);
    procedure Action_1002Execute(Sender: TObject);
    procedure Action_1003Execute(Sender: TObject);
    procedure Action_1004Execute(Sender: TObject);
    procedure MatrixManageChartControlClickPos(p_Index: Integer; p_ValueX, p_ValueY: Double);
    procedure Action_2001Execute(Sender: TObject);
    procedure Action_2002Execute(Sender: TObject);

  private
    m_MatrixBlockManager: CMXBlockManager;

    procedure OnUpdateChart(Sender: TObject);

  private
    m_NavigatorWidth: Integer;
    m_NavigatorVisible: Boolean;

  public

    procedure OnFormCreate;
    procedure OnFormClose;

    procedure AttachBlockManager(ABlockManager: CMXBlockManager);
    function DetachBlockManager: CMXBlockManager;

    procedure UpdateOnChangedBlockManager;

    procedure Clear;
    procedure Display;

    procedure ZoomIn;
    procedure ZoomOut;
    procedure ZoomActual;
    procedure FullEnlarge;
  end;

implementation

uses FNGlobal, DateUtils, FNCMVariable, FNSymbolCollection, Math,
  MKStreamChartDataSeries, MKChartData,
  MKLineValue, FNMatrixMainForm;

{$R *.dfm}

procedure TMatrixManageChartFrame.Action_1001Execute(Sender: TObject);
begin
  MatrixManageChartControl.OnZoomIn;
end;

procedure TMatrixManageChartFrame.Action_1002Execute(Sender: TObject);
begin
  MatrixManageChartControl.OnZoomOut;

end;

procedure TMatrixManageChartFrame.Action_1003Execute(Sender: TObject);
begin
  MatrixManageChartControl.OnZoomActual;
end;

procedure TMatrixManageChartFrame.Action_1004Execute(Sender: TObject);
begin
  MatrixManageChartControl.OnFullEnlarge;
end;

procedure TMatrixManageChartFrame.Action_2001Execute(Sender: TObject);
begin
  if m_NavigatorWidth < 120 then
  begin
    m_NavigatorWidth := 520;
  end;

  PanelToolBar.Visible := true;
  PanelSmallView.Visible := false;
  SplitterNavigator.Visible := true;
  PanelNavigator.Width := m_NavigatorWidth;
  SplitterNavigator.Left := PanelContent.Left + PanelContent.Width + 1;
  PanelNavigator.Left := PanelContent.Left + PanelContent.Width + SplitterNavigator.Width + 1;
  m_NavigatorVisible := true;
  Self.Realign;
  PanelContent.Realign;
end;

procedure TMatrixManageChartFrame.Action_2002Execute(Sender: TObject);
begin
  m_NavigatorWidth := PanelNavigator.Width;
  PanelNavigator.Width := 11;

  PanelToolBar.Visible := false;

  SplitterNavigator.Visible := false;
  PanelSmallView.Visible := true;
  PanelSmallView.Left := 0;
  PanelSmallView.Top := 0;
  PanelSmallView.Width := PanelNavigator.Width;
  PanelSmallView.Height := PanelNavigator.Height;
  m_NavigatorVisible := false;
  Self.Realign;
  PanelContent.Realign;
end;

procedure TMatrixManageChartFrame.AttachBlockManager(ABlockManager: CMXBlockManager);
begin
  m_MatrixBlockManager := ABlockManager;

  if Assigned(m_MatrixBlockManager) then
  begin
    MatrixManageChartControl.MatrixBlockManager := m_MatrixBlockManager;
    m_MatrixBlockManager.OnUpdateChart := OnUpdateChart;
  end;
end;

function TMatrixManageChartFrame.DetachBlockManager: CMXBlockManager;
begin
  if Assigned(m_MatrixBlockManager) then
  begin
    MatrixManageChartControl.Clear;
    MatrixManageChartControl.MatrixBlockManager := NIL;
    m_MatrixBlockManager.OnUpdateChart := NIL;
  end;

  result := m_MatrixBlockManager;

  m_MatrixBlockManager := NIL;
end;

procedure TMatrixManageChartFrame.UpdateOnChangedBlockManager;
begin
  MatrixManageChartControl.Clear;
  if Assigned(m_MatrixBlockManager) then
  begin
    OnUpdateChart(m_MatrixBlockManager);
  end
  else
  begin
    Clear;
  end;
end;

procedure TMatrixManageChartFrame.OnFormCreate;
begin
  PageControl1.ActivePageIndex := 0;

  m_NavigatorWidth := 540;
  m_NavigatorVisible := true;

  PanelNavigator.Width := m_NavigatorWidth;

  if not m_NavigatorVisible then
  begin
    Action_2002Execute(Self);
  end;
  (*
    if SameText(g_OPSUserName, 'dev') or SameText(g_OPSUserName, 'matrix') then
    begin

    end else
    begin
    ToolButton1.Visible := false;
    ToolButton2.Visible := false;
    end;
  *)
end;

procedure TMatrixManageChartFrame.OnFormClose;
begin
  MatrixManageChartControl.Clear;
  MatrixManageChartControl.MatrixBlockManager := NIL;
  m_MatrixBlockManager.OnUpdateChart := NIL;
  m_MatrixBlockManager := NIL;
end;

procedure TMatrixManageChartFrame.SplitterNavigatorMoved(Sender: TObject);
begin
  if PanelNavigator.Width < 120 then
  begin
    Action_2002Execute(Sender);
    // m_NavigatorWidth := 200;
  end;
end;

procedure TMatrixManageChartFrame.ZoomIn;
begin
  MatrixManageChartControl.OnZoomIn;
end;

procedure TMatrixManageChartFrame.ZoomOut;
begin
  MatrixManageChartControl.OnZoomOut;
end;

procedure TMatrixManageChartFrame.ZoomActual;
begin
  MatrixManageChartControl.OnZoomActual;
end;

procedure TMatrixManageChartFrame.FullEnlarge;
begin
  MatrixManageChartControl.OnFullEnlarge;
end;

procedure TMatrixManageChartFrame.ListViewValuesCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Selected then
  begin
    if Sender.Focused then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
    end
    else
    begin
      Sender.Canvas.Brush.Color := RGB($D0, $E0, $FF);
    end;
    Sender.Canvas.Font.Color := RGB($00, $00, $80);
  end
  else
  begin
    if Item.Index mod 2 = 0 then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
    end
    else
    begin
      Sender.Canvas.Brush.Color := RGB($F0, $F0, $F0);
    end;
    Sender.Canvas.Font.Color := RGB($00, $00, $00);
  end;

  DefaultDraw := true;
end;

procedure TMatrixManageChartFrame.ListViewValuesCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f_LineValue: CMKLineValue;
begin
  if Item.Selected then
  begin
    if Sender.Focused then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
    end
    else
    begin
      Sender.Canvas.Brush.Color := RGB($D0, $E0, $FF);
    end;
    Sender.Canvas.Font.Color := RGB($00, $00, $80);
  end
  else
  begin
    if Item.Index mod 2 = 0 then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
    end
    else
    begin
      Sender.Canvas.Brush.Color := RGB($F0, $F0, $F0);
    end;
    Sender.Canvas.Font.Color := RGB($00, $00, $00);
  end;

  try
    f_LineValue := Item.Data;

    if (SubItem = 3) then
    begin
      if (f_LineValue.m_Value[M_MATRIX_LINE_VALUE] > 0) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_LineValue.m_Value[M_MATRIX_LINE_VALUE] < 0) then
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $FF);
      end
      else
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $00);
      end;
    end
    else if (SubItem = 4) then
    begin
      if (f_LineValue.m_Value[M_MATRIX_LINE_FINALVALUE] > 0) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_LineValue.m_Value[M_MATRIX_LINE_FINALVALUE] < 0) then
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $FF);
      end
      else
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $00);
      end;
    end
    else if (SubItem = 5) then
    begin
      if (f_LineValue.m_Value[M_MATRIX_LINE_TR_MAXVALUE] > 0) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_LineValue.m_Value[M_MATRIX_LINE_TR_MAXVALUE] < 0) then
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $FF);
      end
      else
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $00);
      end;
    end
    else if (SubItem = 6) then
    begin
      if (f_LineValue.m_Value[M_MATRIX_LINE_MAXVALUE] > 0) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_LineValue.m_Value[M_MATRIX_LINE_MAXVALUE] < 0) then
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $FF);
      end
      else
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $00);
      end;
    end
    else if (SubItem = 7) then
    begin
      if (f_LineValue.m_Value[M_MATRIX_LINE_TR_VALUE] > 0) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_LineValue.m_Value[M_MATRIX_LINE_TR_VALUE] < 0) then
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $FF);
      end
      else
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $00);
      end;
    end
    else if (SubItem = 8) then
    begin
      if (f_LineValue.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE] > 0) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_LineValue.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE] < 0) then
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $FF);
      end
      else
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $00);
      end;
    end
    else if (SubItem = 9) then
    begin
      if (1 = f_LineValue.m_Value[M_MATRIX_LINE_CANTRADE01]) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $00);
      end;
    end
    else
    begin

    end;

  except
  end;
  DefaultDraw := true;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixManageChartFrame.ListViewValuesData(Sender: TObject; Item: TListItem);
var
  f_ChartDataSeries: CMKStreamChartDataSeries;
  f_ChartData: CMKChartData;
  nItemIndex: Integer;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
begin
  if (MatrixManageChartControl = NIL) then
    exit;

  if (MatrixManageChartControl.m_ChartDataSeries = NIL) then
    exit;
  f_ChartDataSeries := MatrixManageChartControl.m_ChartDataSeries;

  if ((Item.Index < 0) or (Item.Index >= f_ChartDataSeries.m_Items.Count)) then
    exit;

  try
    nItemIndex := f_ChartDataSeries.m_Items.Count - Item.Index - 1;
    f_ChartData := f_ChartDataSeries.m_Items[nItemIndex];
    f_LineValue0 := MatrixManageChartControl.m_MatrixSeries.m_Items.Items[nItemIndex];

    if f_ChartData = NIL then
      exit;
    if f_LineValue0 = NIL then
      exit;

    Item.Caption := TFNGlobal.WriteNumber(nItemIndex, 0);
    Item.SubItems.Add(TFNGlobal.DateTimeToStr6(f_ChartData.m_OpenDateTime));
    Item.SubItems.Add(TFNGlobal.WriteNumberF(f_LineValue0.m_Value[M_MATRIX_LINE_REALPRICE], 2));
    Item.SubItems.Add(TFNGlobal.WriteNumberF(f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] / 10000.0, 0));
    Item.SubItems.Add(TFNGlobal.WriteNumberF(f_LineValue0.m_Value[M_MATRIX_LINE_FINALVALUE] / 10000.0, 0));
    Item.SubItems.Add(TFNGlobal.WriteNumberF(f_LineValue0.m_Value[M_MATRIX_LINE_MAXVALUE] / 10000.0, 0));
    Item.SubItems.Add(TFNGlobal.WriteNumberF(f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] / 10000.0, 0));
    Item.SubItems.Add(TFNGlobal.WriteNumberF(f_LineValue0.m_Value[M_MATRIX_LINE_TR_VALUE] / 10000.0, 0));
    Item.SubItems.Add(TFNGlobal.WriteNumberF(f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE] / 10000.0, 0));

    if 1 = f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01] then
    begin
      Item.SubItems.Add('O');
    end
    else
    begin
      Item.SubItems.Add('X');
    end;

    if nItemIndex > 0 then
    begin
      f_LineValue1 := MatrixManageChartControl.m_MatrixSeries.m_Items.Items[nItemIndex - 1];
      Item.SubItems.Add(TFNGlobal.WriteNumberF((f_LineValue0.m_Value[M_MATRIX_LINE_VALUE_MA1] - f_LineValue1.m_Value[M_MATRIX_LINE_VALUE_MA1]) / 10000.0, 4));
      Item.SubItems.Add(TFNGlobal.WriteNumberF((f_LineValue0.m_Value[M_MATRIX_LINE_VALUE_MA2] - f_LineValue1.m_Value[M_MATRIX_LINE_VALUE_MA2]) / 10000.0, 4));
      Item.SubItems.Add(TFNGlobal.WriteNumberF(f_LineValue0.m_Value[M_MATRIX_LINE_VALUE_MA1], 0));

    end
    else
    begin
      Item.SubItems.Add('');
      Item.SubItems.Add('');
      Item.SubItems.Add('');
    end;
    Item.Data := f_LineValue0;
  except

  end;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixManageChartFrame.Clear;
begin
  MatrixManageChartControl.Clear;

  ListViewValues.Items.Count := 0;
  ListViewValues.Invalidate;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixManageChartFrame.Display;
var
  f_ItemIndex: Integer;
  f_ChartData: CMKChartData;
  f_Count: Integer;
begin
  if not Assigned(m_MatrixBlockManager) then
    exit;

  ListViewValues.Items.Count := MatrixManageChartControl.m_ChartDataSeries.m_Items.Count;
  ListViewValues.Invalidate;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixManageChartFrame.MatrixManageChartControlChartTraceChange(p_Index: Integer; p_ValueX, p_ValueY: Double);
var
  f_Index: Integer;
  f_Count: Integer;
  f_ListIndex: Integer;
  f_Item: TListItem;
begin
  MatrixManageChartControl.DrawTrace(p_Index, p_ValueX, p_ValueY);
end;

procedure TMatrixManageChartFrame.MatrixManageChartControlClickPos(p_Index: Integer; p_ValueX, p_ValueY: Double);
var
  f_Index: Integer;
  f_Count: Integer;
  f_ListIndex: Integer;
  f_Item: TListItem;
begin
  f_Count := ListViewValues.Items.Count;

  if f_Count <= 0 then
    exit;

  f_Index := Trunc(p_ValueX);
  if f_Index < 0 then
    f_Index := 0;
  if f_Index > f_Count then
    f_Index := f_Count - 1;
  f_ListIndex := f_Count - 1 - f_Index;

  ListViewValues.ItemIndex := f_ListIndex;
  f_Item := ListViewValues.Items[f_ListIndex];
  f_Item.Selected := true;
  f_Item.Focused := true;
  f_Item.MakeVisible(false);
end;

// ------------------------------------------------------------------------------------
procedure TMatrixManageChartFrame.OnUpdateChart(Sender: TObject);
begin
  if not Assigned(m_MatrixBlockManager) then
    exit;

  MatrixManageChartControl.Update(false);
  Display;
end;

end.
