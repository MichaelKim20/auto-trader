unit FNMatrixChartFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, GR32_Image, FNMatrixChartControlBase,
  FNMatrixMergeChartControl,
  StdCtrls, ComCtrls,
  MXBlock,
  MXOption,
  MXSystemManager,
  FNSystemItemViewFrame, FNTradeSystem,
  FNTrafficManager, FNMatrixLineValueSeries, FNRegistry;

type
  TMatrixChartFrame = class(TFrame)
    Panel2: TPanel;
    Splitter2: TSplitter;
    Panel2_bottom: TPanel;
    Panel1_top: TPanel;
    Panel3_chart: TPanel;
    ScrollBar1: TScrollBar;
    Panel2_grid: TPanel;
    GridPanel1: TGridPanel;
    Panel6: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel14: TPanel;
    ListViewPM: TListView;
    TabSheet4: TTabSheet;
    Panel13: TPanel;
    ListViewValues: TListView;
    Panel12: TPanel;
    ListViewTradeList: TListView;
    Panel10: TPanel;
    MergeChartControl: CFNMatrixMergeChartControl;
    QDate: TPanel;
    Panel8: TPanel;
    QTime: TPanel;
    Panel11: TPanel;
    QLastPrice: TPanel;
    Panel7: TPanel;
    QSignal: TPanel;
    Panel9: TPanel;
    QTotalProfit: TPanel;
    procedure MergeChartControlChartTraceChange(p_Index: Integer; p_ValueX, p_ValueY: Double);
    procedure ListViewValuesData(Sender: TObject; Item: TListItem);
    procedure ListViewPMData(Sender: TObject; Item: TListItem);
    procedure ListViewPMCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewTradeListData(Sender: TObject; Item: TListItem);
    procedure ListViewTradeListCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure Splitter2Moved(Sender: TObject);
    procedure ListViewValuesCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewValuesCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewTradeListCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewPMCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);

    procedure Button1Click(Sender: TObject);
    procedure MergeChartControlClickPos(p_Index: Integer; p_ValueX, p_ValueY: Double);
    procedure Panel1_topClick(Sender: TObject);

  private
    m_Enabled: Boolean;
    m_Block: CMXBlock;
    m_TrafficManager: CFNTrafficManager;
    m_ValueCollection: Array [0 .. 2] of CFNPMValueCollection;

    procedure OnChartTraceChange(p_Index: Integer; p_ValueX, p_ValueY: Double);
    procedure OnChangedSystemManager(Sender: TObject);
    procedure ApplyLanguage;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure OnFormCreate;
    procedure OnFormClose;

    procedure AttachBlock(ABlock: CMXBlock);
    function DetachBlock: CMXBlock;
    procedure UpdateOnChangedBlock;

    procedure ClearSystemManagerInfo;
    procedure DisplaySystemManagerInfo;

    procedure ZoomIn;
    procedure ZoomOut;
    procedure ZoomActual;
    procedure FullEnlarge;

    procedure EnableChart;
    procedure DiableChart;

    property EnabledChart: Boolean read m_Enabled;

    procedure RefreshChart;

  end;

implementation

uses FNGlobal, DateUtils, Math, MKStreamChartDataSeries, MKChartData,
  MKLineValue, FNMatrixMainForm,
  FNCMVariable, FNSymbolCollection, FNMaterialCollection, FNMatrixConst;

{$R *.dfm}

procedure TMatrixChartFrame.ApplyLanguage;
begin
  if (g_Language = 0) then
  begin
    TabSheet1.Caption := '신호리스트';
    TabSheet2.Caption := '성능분석';
    TabSheet4.Caption := '좌표정보';

    ListViewTradeList.Column[0].Caption := '횟수';
    ListViewTradeList.Column[1].Caption := '유형';
    ListViewTradeList.Column[2].Caption := '진입가격';
    ListViewTradeList.Column[3].Caption := '청산가격';
    ListViewTradeList.Column[4].Caption := '수익';
    ListViewTradeList.Column[5].Caption := '누적수익';
    ListViewTradeList.Column[6].Caption := '진입시간';
    ListViewTradeList.Column[7].Caption := '청산시간';

    ListViewPM.Column[0].Caption := '성능분석명';
    ListViewPM.Column[1].Caption := '전체거래';
    ListViewPM.Column[2].Caption := '매수거래';
    ListViewPM.Column[3].Caption := '매도거래';

    ListViewValues.Columns[0].Caption := '시간';
    ListViewValues.Columns[1].Caption := '시스템';
    ListViewValues.Columns[2].Caption := '신호';
    ListViewValues.Columns[3].Caption := '가격';
    ListViewValues.Columns[4].Caption := '거래량';

    Panel6.Caption := '날짜';
    Panel8.Caption := '시간';
    Panel11.Caption := '시세';
    Panel7.Caption := '신호상태';
    Panel9.Caption := ' 누적수익';
  end
  else if (g_Language = 1) then
  begin
    TabSheet1.Caption := 'Signal';
    TabSheet2.Caption := 'Perfomance';
    TabSheet4.Caption := 'Trace';

    ListViewTradeList.Column[0].Caption := 'No';
    ListViewTradeList.Column[1].Caption := 'Type';
    ListViewTradeList.Column[2].Caption := 'Enter Price';
    ListViewTradeList.Column[3].Caption := 'Exit Price';
    ListViewTradeList.Column[4].Caption := 'Profit';
    ListViewTradeList.Column[5].Caption := 'Cumulative revenue';
    ListViewTradeList.Column[6].Caption := 'Enter Time';
    ListViewTradeList.Column[7].Caption := 'Exit Time';

    ListViewPM.Column[0].Caption := 'Field';
    ListViewPM.Column[1].Caption := 'Total Trade';
    ListViewPM.Column[2].Caption := 'Long Trade';
    ListViewPM.Column[3].Caption := 'Short Trade';

    ListViewValues.Columns[0].Caption := 'Time';
    ListViewValues.Columns[1].Caption := 'System';
    ListViewValues.Columns[2].Caption := 'Signal';
    ListViewValues.Columns[3].Caption := 'Price';
    ListViewValues.Columns[4].Caption := 'Volume';

    Panel6.Caption := 'Date';
    Panel8.Caption := 'Time';
    Panel11.Caption := 'Price';
    Panel7.Caption := 'Signal';
    Panel9.Caption := ' Cumulative';
  end;

end;

// ------------------------------------------------------------------------------------
constructor TMatrixChartFrame.Create(AOwner: TComponent);
begin
  inherited;

  m_TrafficManager := CFNTrafficManager.Create;
  m_ValueCollection[0] := CFNPMValueCollection.Create;
  m_ValueCollection[1] := CFNPMValueCollection.Create;
  m_ValueCollection[2] := CFNPMValueCollection.Create;
end;

// ------------------------------------------------------------------------------------
destructor TMatrixChartFrame.Destroy;
begin
  m_TrafficManager.Free;
  m_ValueCollection[0].Free;
  m_ValueCollection[1].Free;
  m_ValueCollection[2].Free;
  inherited;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.AttachBlock(ABlock: CMXBlock);
begin
  m_Block := ABlock;

  if Assigned(m_Block) then
  begin
    MergeChartControl.SystemManager := m_Block.SystemManager;
    m_Block.SystemManager.OnChanged := OnChangedSystemManager;
  end;
end;

// ------------------------------------------------------------------------------------
function TMatrixChartFrame.DetachBlock: CMXBlock;
begin
  if Assigned(m_Block) then
  begin
    MergeChartControl.SystemManager := NIL;
    m_Block.SystemManager.OnChanged := NIL;
  end;

  result := m_Block;

  m_Block := NIL;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.UpdateOnChangedBlock;
begin
  MergeChartControl.Clear;
  if Assigned(m_Block) then
  begin
    OnChangedSystemManager(m_Block.SystemManager);
  end
  else
  begin
    ClearSystemManagerInfo;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.OnFormCreate;
begin
  PageControl1.ActivePageIndex := 0;
  m_Enabled := true;

  // LoadSettingInfomation;

  // MergeChartControl.SetVisibleFinalProfit(CheckBoxFinalProfit.Checked);

  // MergeChartControl.SetVisibleProfitOAvgBuy1(CheckBoxProfitOAvgBuy1.Checked);
  // MergeChartControl.SetVisibleProfitOAvgSell1(CheckBoxProfitOAvgSell1.Checked);

  // MergeChartControl.SetVisibleProfitOAvgBuy2(CheckBoxProfitOAvgBuy2.Checked);
  // MergeChartControl.SetVisibleProfitOAvgSell2(CheckBoxProfitOAvgSell2.Checked);

  // MergeChartControl.SetVisibleProfitOBuy(CheckBoxProfitOBuy.Checked);
  // MergeChartControl.SetVisibleProfitOSell(CheckBoxProfitOSell.Checked);

  ApplyLanguage;
end;

procedure TMatrixChartFrame.Panel1_topClick(Sender: TObject);
begin

end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.OnFormClose;
begin
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.Splitter2Moved(Sender: TObject);
begin

end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.ZoomIn;
var
  f_Index: Integer;
  f_SystemItemView: TSystemItemViewFrame;
begin
  MergeChartControl.OnZoomIn;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.ZoomOut;
var
  f_Index: Integer;
  f_SystemItemView: TSystemItemViewFrame;
begin
  MergeChartControl.OnZoomOut;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.ZoomActual;
var
  f_Index: Integer;
  f_SystemItemView: TSystemItemViewFrame;
begin
  MergeChartControl.OnZoomActual;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.FullEnlarge;
var
  f_Index: Integer;
  f_SystemItemView: TSystemItemViewFrame;
begin
  MergeChartControl.OnFullEnlarge;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.ListViewValuesCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
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

procedure TMatrixChartFrame.ListViewValuesCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
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

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.ListViewValuesData(Sender: TObject; Item: TListItem);
var
  f_ChartDataSeries: CMKStreamChartDataSeries;
  f_ChartData: CMKChartData;
  nItemIndex: Integer;
  f_LineValue: CMKLineValue;
  f_Precision: Integer;
  f_MaterialItem: CFNMaterialItem;
begin

  f_Precision := 2;
  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(m_Block.Option.GetIntegerValue('COUNTRY_NO'), m_Block.Option.GetIntegerValue('GROUP_NO'), m_Block.Option.GetIntegerValue('MARKET_NO'), g_SymbolCollection.GetOPSSymbol(m_Block.Option.GetStringValue('SYMBOL')));

    if Assigned(f_MaterialItem) then
    begin
      f_Precision := f_MaterialItem.m_Precision;
    end;
  end;

  if (MergeChartControl = NIL) then
    exit;

  if (MergeChartControl.m_ChartDataSeries = NIL) then
    exit;
  f_ChartDataSeries := MergeChartControl.m_ChartDataSeries;

  if ((Item.Index < 0) or (Item.Index >= f_ChartDataSeries.m_Items.Count)) then
    exit;

  try
    nItemIndex := f_ChartDataSeries.m_Items.Count - Item.Index - 1;
    f_ChartData := f_ChartDataSeries.m_Items[nItemIndex];
    f_LineValue := MergeChartControl.m_MergeSeries1.m_Items.Items[nItemIndex];

    if f_ChartData = NIL then
      exit;
    if f_LineValue = NIL then
      exit;

    Item.Caption := TFNGlobal.DateTimeToStr6(f_ChartData.m_CloseDateTime);
    Item.SubItems.Add(TFNGlobal.WriteNumber(f_LineValue.m_Value[M_MERGE_LINE_SYSTEMNO], 0));

    Item.SubItems.Add(GetRawSignalText(Floor(f_LineValue.m_Value[M_MERGE_LINE_SIGNAL1])));

    Item.SubItems.Add(TFNGlobal.WriteNumber(f_LineValue.m_Value[M_MERGE_LINE_REALPRICE], f_Precision));
    Item.SubItems.Add(TFNGlobal.WriteNumber(f_LineValue.m_Value[M_MERGE_LINE_VOLUME], 0));

    Item.Data := f_ChartData;
  except

  end;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.ClearSystemManagerInfo;
var
  f_Index: Integer;
  f_SystemItemView: TSystemItemViewFrame;
begin
  MergeChartControl.Clear;

  QDate.Caption := '';
  QTime.Caption := '';
  QLastPrice.Caption := '';
  QTotalProfit.Caption := '';
  QSignal.Caption := '';

  ListViewPM.Items.Count := 0;
  ListViewPM.Invalidate;

  ListViewTradeList.Items.Count := 0;
  ListViewTradeList.Invalidate;

  ListViewValues.Items.Count := 0;
  ListViewValues.Invalidate;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.DisplaySystemManagerInfo;
var
  f_ItemIndex: Integer;
  f_ChartData: CMKChartData;
  f_Count: Integer;
  f_Precision: Integer;
  f_MaterialItem: CFNMaterialItem;
begin
  if not Assigned(m_Block) then
    exit;

  f_Precision := 2;
  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(m_Block.Option.GetIntegerValue('COUNTRY_NO'), m_Block.Option.GetIntegerValue('GROUP_NO'), m_Block.Option.GetIntegerValue('MARKET_NO'), g_SymbolCollection.GetOPSSymbol(m_Block.Option.GetStringValue('SYMBOL')));

    if Assigned(f_MaterialItem) then
    begin
      f_Precision := f_MaterialItem.m_Precision;
    end;
  end;

  f_Count := MergeChartControl.m_ChartDataSeries.m_Items.Count;
  if f_Count > 0 then
  begin
    f_ChartData := MergeChartControl.m_ChartDataSeries.m_Items[f_Count - 1];
    QDate.Caption := DateToStr(f_ChartData.m_CloseDateTime) + ' ';
    QTime.Caption := TFNGlobal.DateTimeToStr6(f_ChartData.m_CloseDateTime) + ' ';
  end
  else
  begin
    QDate.Caption := DateToStr(m_Block.Option.GetIntegerValue('STAND_DATE')) + ' ';
    QTime.Caption := ' ';
  end;

  QLastPrice.Caption := TFNGlobal.WriteNumber(m_Block.SystemManager.m_RealPrice, f_Precision) + ' ';

  QSignal.Caption := GetRawSignalText(m_Block.SystemManager.m_LastSignal) + ' ';
  QSignal.Font.Color := TFNGlobal.GetTextColor(0, m_Block.SystemManager.m_LastSignal);

  QTotalProfit.Caption := TFNGlobal.WriteNumber(m_Block.SystemManager.m_TotalProfit, f_Precision) + ' ';
  QTotalProfit.Font.Color := TFNGlobal.GetTextColor(0, m_Block.SystemManager.m_TotalProfit);

  ListViewValues.Items.Count := MergeChartControl.m_ChartDataSeries.m_Items.Count;
  ListViewValues.Invalidate;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.EnableChart;
begin
  MergeChartControl.SystemManager := m_Block.SystemManager;
  m_Block.SystemManager.OnChanged := OnChangedSystemManager;

  Panel2.Visible := true;

  m_Enabled := true;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.DiableChart;
begin
  MergeChartControl.SystemManager := NIL;
  m_Block.SystemManager.OnChanged := NIL;

  Panel2.Visible := false;

  m_Enabled := false;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.Button1Click(Sender: TObject);
begin
  // SaveSettingInfomation;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.MergeChartControlChartTraceChange(p_Index: Integer; p_ValueX, p_ValueY: Double);
var
  f_Index: Integer;
  f_Count: Integer;
  f_ListIndex: Integer;
  f_SystemItemView: TSystemItemViewFrame;
  f_Item: TListItem;
begin
  MergeChartControl.DrawTrace(p_Index, p_ValueX, p_ValueY);
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.MergeChartControlClickPos(p_Index: Integer; p_ValueX, p_ValueY: Double);
var
  f_Index: Integer;
  f_Count: Integer;
  f_ListIndex: Integer;
  f_SystemItemView: TSystemItemViewFrame;
  f_Item: TListItem;
begin
  if not Assigned(m_Block) then
    exit;
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
procedure TMatrixChartFrame.OnChartTraceChange(p_Index: Integer; p_ValueX, p_ValueY: Double);
var
  f_Index: Integer;
  f_Count: Integer;
  f_ListIndex: Integer;
  f_SystemItemView: TSystemItemViewFrame;
  f_Item: TListItem;
begin
  if not Assigned(m_Block) then
    exit;
  MergeChartControl.DrawTrace(p_Index, p_ValueX, p_ValueY);
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.RefreshChart;
begin
  OnChangedSystemManager(Self);
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.OnChangedSystemManager(Sender: TObject);
var
  f_Value: CFNPMValueItem;
  f_Profit: Double;
  f_Precision: Integer;
  f_MaterialItem: CFNMaterialItem;
begin
  if not Assigned(m_Block) then
    exit;

  f_Precision := 2;
  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(m_Block.Option.GetIntegerValue('COUNTRY_NO'), m_Block.Option.GetIntegerValue('GROUP_NO'), m_Block.Option.GetIntegerValue('MARKET_NO'), g_SymbolCollection.GetOPSSymbol(m_Block.Option.GetStringValue('SYMBOL')));

    if Assigned(f_MaterialItem) then
    begin
      f_Precision := f_MaterialItem.m_Precision;
    end;
  end;

  MergeChartControl.Update();
  DisplaySystemManagerInfo;

  m_Block.SystemManager.Lock;
  try
    m_TrafficManager.MakeTradeListBySignalArray(m_Block.SystemManager.m_SignalArray, m_Block.SystemManager.m_RealPrice);
  finally
    m_Block.SystemManager.UnLock;
  end;

  m_TrafficManager.m_AllTrafficCollection.WritePrformance(m_ValueCollection[0]);
  m_TrafficManager.m_LongTrafficCollection.WritePrformance(m_ValueCollection[1]);
  m_TrafficManager.m_ShortTrafficCollection.WritePrformance(m_ValueCollection[2]);

  ListViewPM.Items.Count := 0;
  ListViewPM.Items.Count := m_ValueCollection[0].m_Items.Count;

  ListViewTradeList.Items.Count := 0;

  ListViewTradeList.Items.Count := m_TrafficManager.m_AllTrafficCollection.m_Items.Count;
  f_Value := m_ValueCollection[0].m_Items[1];
  f_Profit := f_Value.m_Value;

  QTotalProfit.Caption := TFNGlobal.WriteNumber(f_Profit, f_Precision) + ' ';
  QTotalProfit.Font.Color := TFNGlobal.GetTextColor(0, f_Profit);
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.ListViewPMCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Index mod 2 = 0 then
  begin
    Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
  end
  else
  begin
    Sender.Canvas.Brush.Color := RGB($F0, $F0, $F0);
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.ListViewPMCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f_Paper: TCanvas;
  f_ListView: TListView;

  f_Index: Integer;
  f_Value: CFNPMValueItem;
  f_ItemIndex: Integer;
begin
  if Item.Index mod 2 = 0 then
  begin
    Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
  end
  else
  begin
    Sender.Canvas.Brush.Color := RGB($F0, $F0, $F0);
  end;

  f_ListView := TListView(Sender);

  f_Paper := f_ListView.Canvas;

  if ((Item.Index < 0) or (Item.Index >= m_ValueCollection[0].m_Items.Count)) then
    exit;
  if (SubItem >= 1) then
  begin
    f_ItemIndex := Item.Index;
    f_Value := m_ValueCollection[SubItem - 1].m_Items[f_ItemIndex];
    Item.Data := f_Value;

    if Assigned(f_Value) AND f_Value.m_SignColor then
    begin
      if (f_Value.m_Value > 0) then
      begin
        f_Paper.Font.Color := clWhite;
        f_Paper.Font.Color := RGB($EE, $00, $00);
      end
      else if (f_Value.m_Value < 0) then
      begin
        f_Paper.Font.Color := clWhite;
        f_Paper.Font.Color := RGB($00, $00, $EE);
      end
      else
      begin
        f_Paper.Font.Color := clWhite;
        f_Paper.Font.Color := RGB($00, $00, $00);
      end;
    end;
  end;

end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.ListViewPMData(Sender: TObject; Item: TListItem);
var
  f_Index: Integer;
  f_Value: CFNPMValueItem;
  f_ItemIndex: Integer;
  f_DefPrecision: Integer;
  f_Precision: Integer;

  f_MaterialItem: CFNMaterialItem;
begin
  if ((Item.Index < 0) or (Item.Index >= m_ValueCollection[0].m_Items.Count)) then
    exit;

  f_DefPrecision := 2;
  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(m_Block.Option.GetIntegerValue('COUNTRY_NO'), m_Block.Option.GetIntegerValue('GROUP_NO'), m_Block.Option.GetIntegerValue('MARKET_NO'), g_SymbolCollection.GetOPSSymbol(m_Block.Option.GetStringValue('SYMBOL')));

    if Assigned(f_MaterialItem) then
    begin
      f_DefPrecision := f_MaterialItem.m_Precision;
    end;
  end;

  f_ItemIndex := Item.Index;
  f_Value := m_ValueCollection[0].m_Items[f_ItemIndex];
  Item.Data := f_Value;

  if f_Value = NIL then
    exit;

  Item.Caption := f_Value.m_Name;
  for f_Index := 0 to 2 do
  begin
    f_Precision := f_Value.m_Precision;
    if (f_Precision = -1) then f_Precision := f_DefPrecision;

    f_Value := m_ValueCollection[f_Index].m_Items[f_ItemIndex];
    Item.SubItems.Add(Format('%.*n', [f_Precision, f_Value.m_Value]) + f_Value.m_Unit);
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.ListViewTradeListCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Index mod 2 = 0 then
  begin
    Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
  end
  else
  begin
    Sender.Canvas.Brush.Color := RGB($F0, $F0, $F0);
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.ListViewTradeListCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  Paper: TCanvas;
  f_ListView: TListView;
  f_TrafficItem: CFNTrafficItem;
begin
  if Item.Index mod 2 = 0 then
  begin
    Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
  end
  else
  begin
    Sender.Canvas.Brush.Color := RGB($F0, $F0, $F0);
  end;
  f_ListView := TListView(Sender);

  Paper := f_ListView.Canvas;
  f_TrafficItem := Item.Data;

  if Assigned(f_TrafficItem) then
  begin
    if (SubItem = 1) then
    begin
      if f_TrafficItem.m_Signal = SIGNAL_SELL_ENTER then
      begin
        Paper.Font.Color := clWhite;
        Paper.Font.Color := RGB($00, $00, $EE);
      end
      else if f_TrafficItem.m_Signal = SIGNAL_BUY_ENTER then
      begin
        Paper.Font.Color := clWhite;
        Paper.Font.Color := RGB($EE, $00, $00);
      end;
    end
    else if (SubItem = 4) then
    begin
      if (f_TrafficItem.m_Profit > 0) then
      begin
        Paper.Font.Color := clWhite;
        Paper.Font.Color := RGB($EE, $00, $00);
      end
      else if (f_TrafficItem.m_Profit < 0) then
      begin
        Paper.Font.Color := clWhite;
        Paper.Font.Color := RGB($00, $00, $EE);
      end
      else
      begin
        Paper.Font.Color := clWhite;
        Paper.Font.Color := RGB($00, $00, $00);
      end;
    end
    else if (SubItem = 5) then
    begin
      if (f_TrafficItem.m_Cumulative > 0) then
      begin
        Paper.Font.Color := clWhite;
        Paper.Font.Color := RGB($EE, $00, $00);
      end
      else if (f_TrafficItem.m_Cumulative < 0) then
      begin
        Paper.Font.Color := clWhite;
        Paper.Font.Color := RGB($00, $00, $EE);
      end
      else
      begin
        Paper.Font.Color := clWhite;
        Paper.Font.Color := RGB($00, $00, $00);
      end;
    end
    else
    begin
      Paper.Font.Color := clWhite;
      Paper.Font.Color := clBlack;
    end;
  end;
  DefaultDraw := true;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixChartFrame.ListViewTradeListData(Sender: TObject; Item: TListItem);
var
  f_TrafficItem: CFNTrafficItem;
  nItemIndex: Integer;
  f_TrafficCollection: CFNTrafficCollection;
  f_MaterialItem: CFNMaterialItem;
  f_Precision: Integer;
begin
  f_Precision := 2;
  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(m_Block.Option.GetIntegerValue('COUNTRY_NO'), m_Block.Option.GetIntegerValue('GROUP_NO'), m_Block.Option.GetIntegerValue('MARKET_NO'), g_SymbolCollection.GetOPSSymbol(m_Block.Option.GetStringValue('SYMBOL')));

    if Assigned(f_MaterialItem) then
    begin
      f_Precision := f_MaterialItem.m_Precision;
    end;
  end;

  f_TrafficCollection := m_TrafficManager.m_AllTrafficCollection;

  if ((Item.Index < 0) or (Item.Index >= f_TrafficCollection.m_Items.Count)) then
    exit;

  try
    nItemIndex := f_TrafficCollection.m_Items.Count - Item.Index - 1;

    f_TrafficItem := f_TrafficCollection.m_Items[nItemIndex];

    if f_TrafficItem = NIL then
      exit;

    Item.Caption := IntToStr(nItemIndex + 1);

    if f_TrafficItem.m_Signal = SIGNAL_SELL_ENTER then
    begin
      Item.SubItems.Add('매도');
    end
    else if f_TrafficItem.m_Signal = SIGNAL_BUY_ENTER then
    begin
      Item.SubItems.Add('매수');
    end;

    Item.SubItems.Add(Format('%.*n', [f_Precision, f_TrafficItem.m_EnterPrice]));
    Item.SubItems.Add(Format('%.*n', [f_Precision, f_TrafficItem.m_ExitPrice]));

    Item.SubItems.Add(Format('%.*n', [f_Precision, f_TrafficItem.m_Profit]));
    Item.SubItems.Add(Format('%.*n', [f_Precision, f_TrafficItem.m_Cumulative]));

    Item.SubItems.Add(TFNGlobal.DateTimeToStr6(f_TrafficItem.m_EnterDateTime));
    Item.SubItems.Add(TFNGlobal.DateTimeToStr6(f_TrafficItem.m_ExitDateTime));

    Item.Data := f_TrafficItem;
  except
  end;
end;

end.
