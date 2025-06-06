unit FNSystemItemViewFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, FNMatrixChartControlBase,
  FNMatrixChartControl,
  MXSystemManager, GR32_Image, FNTradeSystem, FNTrafficManager,
  FNMatrixMergeChartControl;

type
  TSystemItemViewFrame = class(TFrame)
    Panel2: TPanel;
    GridPanel1: TGridPanel;
    Panel1: TPanel;
    QSymbol: TPanel;
    Panel3: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel11: TPanel;
    ScrollBar1: TScrollBar;
    ListViewPM: TListView;
    ListViewTradeList: TListView;
    Panel10: TPanel;
    QSignal: TPanel;
    Panel5: TPanel;
    QTotalProfit: TPanel;
    TabSheet4: TTabSheet;
    Panel13: TPanel;
    ListViewValues: TListView;
    m_ChartControl: CFNMatrixChartControl;
    procedure ListViewPMData(Sender: TObject; Item: TListItem);
    procedure ListViewPMCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewTradeListData(Sender: TObject; Item: TListItem);
    procedure ListViewTradeListCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewValuesData(Sender: TObject; Item: TListItem);
    procedure ListViewValuesCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewValuesCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewPMCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewTradeListCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    m_SystemItem: CMXSystemItem;
    m_SignalArray: CFNSignalArray;
    m_TrafficManager: CFNTrafficManager;
    m_ValueCollection: Array [0 .. 2] of CFNPMValueCollection;
    procedure SetSystemItem(ASystemItem: CMXSystemItem);
    procedure ApplyLanguage;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure OnFormCreate;
    procedure OnFormClose;

    procedure DrawTrace(p_ChartIndex: Integer; p_ValueX: Double; p_ValueY: Double);

    procedure OnChanged(ASystemItem: CMXSystemItem);
    property SystemItem: CMXSystemItem read m_SystemItem write SetSystemItem;

    procedure Clear;
  end;

implementation

{$R *.dfm}

uses
  DateUtils, FNGlobal, MXOption, MKChartData, MKLineValue,
  MKStreamChartDataSeries, FNMatrixLineValueSeries, FNMatrixConst, FNCMVariable;

// ------------------------------------------------------------------------------------
procedure TSystemItemViewFrame.ApplyLanguage;
begin
  if (g_Language = 0) then
  begin
    Panel1.Caption := '종목';
    Panel10.Caption := '신호';
    Panel5.Caption := '수익';

    TabSheet1.Caption := '차트';
    TabSheet2.Caption := '성능분석';
    TabSheet3.Caption := '거래리스트';
    TabSheet4.Caption := '좌표정보';

    ListViewPM.Column[0].Caption := '필드명';
    ListViewPM.Column[1].Caption := '전체거래';
    ListViewPM.Column[2].Caption := '매수거래';
    ListViewPM.Column[3].Caption := '매도거래';

    ListViewTradeList.Column[0].Caption := '횟수';
    ListViewTradeList.Column[1].Caption := '유형';
    ListViewTradeList.Column[2].Caption := '진입가';
    ListViewTradeList.Column[3].Caption := '청산가';
    ListViewTradeList.Column[4].Caption := '수익';
    ListViewTradeList.Column[5].Caption := '누적수익';
    ListViewTradeList.Column[6].Caption := '진입시간';
    ListViewTradeList.Column[7].Caption := '청산시간';

    ListViewValues.Column[0].Caption := '시간';
    ListViewValues.Column[1].Caption := '신호';
    ListViewValues.Column[2].Caption := '선물';
    ListViewValues.Column[3].Caption := 'Matrix';
    ListViewValues.Column[4].Caption := '거래량';
    ListViewValues.Column[5].Caption := '누적수익';

  end
  else if (g_Language = 1) then
  begin
    Panel1.Caption := 'Symbol';
    Panel10.Caption := 'Signal';
    Panel5.Caption := 'Profit';

    TabSheet1.Caption := 'Chart';
    TabSheet2.Caption := 'Perfomance';
    TabSheet3.Caption := 'TradeList';
    TabSheet4.Caption := 'Trace';

    ListViewPM.Column[0].Caption := 'Field';
    ListViewPM.Column[1].Caption := 'Total Trade';
    ListViewPM.Column[2].Caption := 'Long Trade';
    ListViewPM.Column[3].Caption := 'Short Trade';

    ListViewTradeList.Column[0].Caption := 'Number ';
    ListViewTradeList.Column[1].Caption := 'Type';
    ListViewTradeList.Column[2].Caption := 'Entry Price';
    ListViewTradeList.Column[3].Caption := 'Exit price';
    ListViewTradeList.Column[4].Caption := 'Profit';
    ListViewTradeList.Column[5].Caption := 'Cumulative Profit';
    ListViewTradeList.Column[6].Caption := 'Entry time';
    ListViewTradeList.Column[7].Caption := 'Exit time';

    ListViewValues.Column[0].Caption := 'Time';
    ListViewValues.Column[1].Caption := 'Signal';
    ListViewValues.Column[2].Caption := 'Price';
    ListViewValues.Column[3].Caption := 'Matrix';
    ListViewValues.Column[4].Caption := 'Volumn';
    ListViewValues.Column[5].Caption := 'Cumulative Profit';
  end;
end;

// ------------------------------------------------------------------------------------
procedure TSystemItemViewFrame.OnFormCreate;
begin
  ApplyLanguage;
end;

// ------------------------------------------------------------------------------------
procedure TSystemItemViewFrame.OnFormClose;
begin
end;

// ------------------------------------------------------------------------------------
constructor TSystemItemViewFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_SignalArray := CFNSignalArray.Create;
  m_TrafficManager := CFNTrafficManager.Create;
  m_ValueCollection[0] := CFNPMValueCollection.Create;
  m_ValueCollection[1] := CFNPMValueCollection.Create;
  m_ValueCollection[2] := CFNPMValueCollection.Create;

  ApplyLanguage;
end;

// ------------------------------------------------------------------------------------
destructor TSystemItemViewFrame.Destroy;
begin
  m_SignalArray.Free;
  m_TrafficManager.Free;
  m_ValueCollection[0].Free;
  m_ValueCollection[1].Free;
  m_ValueCollection[2].Free;
  inherited;
end;

// ------------------------------------------------------------------------------------
procedure TSystemItemViewFrame.DrawTrace(p_ChartIndex: Integer; p_ValueX, p_ValueY: Double);
var
  f_Index: Integer;
  f_Count: Integer;
  f_ListIndex: Integer;
  f_SystemItemView: TSystemItemViewFrame;
  f_Item: TListItem;
begin
  m_ChartControl.DrawTrace(p_ChartIndex, p_ValueX, p_ValueY);
  f_Count := ListViewValues.Items.Count;

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
procedure TSystemItemViewFrame.ListViewPMCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
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

procedure TSystemItemViewFrame.ListViewPMCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f_Paper: TCanvas;
  f_ListView: TListView;

  f_Index: Integer;
  f_Value: CFNPMValueItem;
  f_ItemIndex: Integer;
begin
  f_ListView := TListView(Sender);

  f_Paper := f_ListView.Canvas;

  if ((Item.Index < 0) or (Item.Index >= m_ValueCollection[0].m_Items.Count)) then
    exit;

  if Item.Index mod 2 = 0 then
  begin
    Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
  end
  else
  begin
    Sender.Canvas.Brush.Color := RGB($F0, $F0, $F0);
  end;

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
procedure TSystemItemViewFrame.ListViewPMData(Sender: TObject; Item: TListItem);
var
  f_Index: Integer;
  f_Value: CFNPMValueItem;
  f_ItemIndex: Integer;
begin
  if ((Item.Index < 0) or (Item.Index >= m_ValueCollection[0].m_Items.Count)) then
    exit;

  f_ItemIndex := Item.Index;
  f_Value := m_ValueCollection[0].m_Items[f_ItemIndex];
  Item.Data := f_Value;

  if f_Value = NIL then
    exit;

  Item.Caption := f_Value.m_Name;
  for f_Index := 0 to 2 do
  begin
    f_Value := m_ValueCollection[f_Index].m_Items[f_ItemIndex];
    Item.SubItems.Add(Format('%.*n', [f_Value.m_Precision, f_Value.m_Value]) + f_Value.m_Unit);
  end;
end;

// ------------------------------------------------------------------------------------
procedure TSystemItemViewFrame.ListViewTradeListCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
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

procedure TSystemItemViewFrame.ListViewTradeListCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  Paper: TCanvas;
  f_ListView: TListView;
  f_TrafficItem: CFNTrafficItem;
begin
  f_ListView := TListView(Sender);

  Paper := f_ListView.Canvas;
  f_TrafficItem := Item.Data;

  if Item.Index mod 2 = 0 then
  begin
    Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
  end
  else
  begin
    Sender.Canvas.Brush.Color := RGB($F0, $F0, $F0);
  end;

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
    else

        if (SubItem = 4) then
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
    else

        if (SubItem = 5) then
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
procedure TSystemItemViewFrame.ListViewTradeListData(Sender: TObject; Item: TListItem);
var
  f_TrafficItem: CFNTrafficItem;
  nItemIndex: Integer;
  f_Precision: Integer;
  f_TrafficCollection: CFNTrafficCollection;
begin
  f_TrafficCollection := m_TrafficManager.m_AllTrafficCollection;
  if ((Item.Index < 0) or (Item.Index >= f_TrafficCollection.m_Items.Count)) then
    exit;
  try
    nItemIndex := f_TrafficCollection.m_Items.Count - Item.Index - 1;

    f_TrafficItem := f_TrafficCollection.m_Items[nItemIndex];

    if f_TrafficItem = NIL then
      exit;

    Item.Caption := IntToStr(nItemIndex + 1);

    Item.SubItems.Add(GetSimpleSignalText(f_TrafficItem.m_Signal));

    f_Precision := 2;

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

// ------------------------------------------------------------------------------------
procedure TSystemItemViewFrame.ListViewValuesCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
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
procedure TSystemItemViewFrame.ListViewValuesCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
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
procedure TSystemItemViewFrame.ListViewValuesData(Sender: TObject; Item: TListItem);
var
  f_ChartDataSeries: CMKStreamChartDataSeries;
  f_ChartData: CMKChartData;
  f_ItemIndex: Integer;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
begin
  if (m_ChartControl = NIL) then
    exit;

  if (m_ChartControl.m_ChartDataSeries = NIL) then
    exit;
  if (m_ChartControl.m_SignalLineSeries = NIL) then
    exit;

  f_ChartDataSeries := m_ChartControl.m_ChartDataSeries;

  if ((Item.Index < 0) or (Item.Index >= f_ChartDataSeries.m_Items.Count)) then
    exit;

  try
    f_ItemIndex := f_ChartDataSeries.m_Items.Count - Item.Index - 1;
    f_ChartData := f_ChartDataSeries.m_Items[f_ItemIndex];
    f_LineValue0 := m_ChartControl.m_SignalLineSeries.m_Items.Items[f_ItemIndex];

    if (f_ItemIndex > 0) then
    begin
      f_LineValue1 := m_ChartControl.m_SignalLineSeries.m_Items.Items[f_ItemIndex - 1];
    end
    else
    begin
      f_LineValue1 := f_LineValue0;
    end;

    if f_ChartData = NIL then
      exit;
    if f_LineValue0 = NIL then
      exit;
    if f_LineValue1 = NIL then
      exit;

    Item.Caption := TFNGlobal.DateTimeToStr6(f_ChartData.m_CloseDateTime);

    Item.SubItems.Add(GetRawSignalText(Trunc(f_LineValue0.m_Value[M_X_SIGNAL])));

    Item.SubItems.Add(TFNGlobal.WriteNumber(f_ChartData.m_ClosePrice, 2));
    Item.SubItems.Add(TFNGlobal.WriteNumber(f_ChartData.m_CloseOPS, 6));
    Item.SubItems.Add(TFNGlobal.WriteNumber(f_ChartData.m_Volume, 0));
    Item.SubItems.Add(TFNGlobal.WriteNumber(f_LineValue0.m_Value[M_X_SIGNAL_TP], 2));

    Item.Data := f_ChartData;
  except

  end;
end;

// ------------------------------------------------------------------------------------
procedure TSystemItemViewFrame.Clear;
begin
  QTotalProfit.Caption := '';
  QSignal.Caption := '';

  m_ChartControl.Clear;
  ListViewPM.Items.Count := 0;
  ListViewPM.Repaint;
  ListViewTradeList.Items.Count := 0;
  ListViewTradeList.Repaint;
  ListViewValues.Items.Count := 0;
  ListViewValues.Repaint;
end;

// ------------------------------------------------------------------------------------
procedure TSystemItemViewFrame.OnChanged(ASystemItem: CMXSystemItem);
var
  f_Begin, f_End: Integer;
  f_ChartData: CMKChartData;
begin
  if Assigned(ASystemItem) then
  begin
    QTotalProfit.Caption := TFNGlobal.WriteNumber(ASystemItem.m_TotalProfit, 2) + ' ';
    QTotalProfit.Font.Color := TFNGlobal.GetTextColor(0, ASystemItem.m_TotalProfit);

    QSignal.Caption := GetRawSignalText(ASystemItem.m_LastSignal) + ' ';

    QSignal.Font.Color := TFNGlobal.GetTextColor(0, ASystemItem.m_LastSignal);

    m_ChartControl.SystemItem := ASystemItem;
    m_ChartControl.SetChartDataSeries(ASystemItem.m_ChartDataSeries);

    ASystemItem.Lock;
    try
      f_Begin := 0;
      f_End := ASystemItem.m_ChartDataSeries.m_Items.Count;
      m_SignalArray.Clear;
      if f_End > 0 then
      begin
        f_ChartData := ASystemItem.m_ChartDataSeries.m_Items[ASystemItem.m_ChartDataSeries.m_Items.Count - 1];
        ASystemItem.m_SignalLineSeries.ScanSignalAtTrade(ASystemItem.m_ChartDataSeries, m_SignalArray, 0, M_X_SIGNAL, f_Begin, f_End);
        m_TrafficManager.MakeTradeListBySignalArray(m_SignalArray, f_ChartData.m_ClosePrice);
      end;
    finally
      ASystemItem.UnLock;
    end;

    m_TrafficManager.m_AllTrafficCollection.WritePrformance(m_ValueCollection[0]);
    m_TrafficManager.m_LongTrafficCollection.WritePrformance(m_ValueCollection[1]);
    m_TrafficManager.m_ShortTrafficCollection.WritePrformance(m_ValueCollection[2]);

    // ListViewPM.Items.Count := 0;
    ListViewPM.Items.Count := m_ValueCollection[0].m_Items.Count;
    ListViewPM.Repaint;

    // ListViewTradeList.Items.Count := 0;
    ListViewTradeList.Items.Count := m_TrafficManager.m_AllTrafficCollection.m_Items.Count;
    ListViewTradeList.Repaint;

    // ListViewValues.Items.Count := 0;
    ListViewValues.Items.Count := ASystemItem.m_ChartDataSeries.m_Items.Count;
    ListViewValues.Repaint;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TSystemItemViewFrame.SetSystemItem(ASystemItem: CMXSystemItem);
begin
  m_SystemItem := ASystemItem;

  if Assigned(m_SystemItem) then
  begin
    QSymbol.Caption := m_SystemItem.m_TradeSymbol + ' ';
  end;
end;

// ------------------------------------------------------------------------------------
end.
