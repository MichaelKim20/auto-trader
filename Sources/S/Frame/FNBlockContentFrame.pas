unit FNBlockContentFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FNMatrixChartFrame, StdCtrls, ComCtrls, ExtCtrls,
  FNMatrixOptionFrame,
  ToolWin, ImgList, ActnList, FNDataDelivery, FNDataSet, CommonTRMaker,
  MXBlock, MXSystemManager, MXOrderManager, FNTradeSystem, FNTrafficManager,
  FNMaterialCollection,
  FNMatrixSumaryOptionFrame, System.Actions;

const
  CATEGORY_PANEL_COUNT = 4;
  CATEGORY_PANEL_HEAD_HEIGHT = 25;

type
  TBlockContentFrame = class(TFrame)
    ImageListNormal: TImageList;
    ImageList1: TImageList;
    ImageList4: TImageList;
    ActionList1: TActionList;
    Action_1001: TAction;
    Action_1002: TAction;
    Action_1003: TAction;
    Action_1004: TAction;
    Action_0003: TAction;
    Action_0004: TAction;
    Action_0006: TAction;
    Action_0007: TAction;
    PanelFrame01: TPanel;
    PanelTrade: TPanel;
    Panel27: TPanel;
    Splitter3: TSplitter;
    Panel26: TPanel;
    PageControlSignal: TPageControl;
    TabSheet7: TTabSheet;
    Panel30: TPanel;
    ListViewSignal: TListView;
    TabSheet9: TTabSheet;
    Panel6: TPanel;
    ListViewAdjust: TListView;
    Panel24: TPanel;
    Splitter4: TSplitter;
    Panel32: TPanel;
    PageControlLog: TPageControl;
    TabSheet3: TTabSheet;
    Panel3: TPanel;
    ListViewLog: TListView;
    Panel1: TPanel;
    PageControlOrder: TPageControl;
    TabSheet4: TTabSheet;
    Panel13: TPanel;
    ListViewOrder: TListView;
    TabSheet5: TTabSheet;
    Panel19: TPanel;
    ListViewTrade: TListView;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    ListViewPM: TListView;
    Panel5: TPanel;
    RadioButtonTotalView: TRadioButton;
    RadioButtonPartView: TRadioButton;
    PanelChart: TPanel;
    PanelSumary: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet10: TTabSheet;
    Panel4: TPanel;
    Panel8: TPanel;
    Panel10: TPanel;
    PanelCondition: TPanel;
    ToolBar3: TToolBar;
    ToolButton30: TToolButton;
    ToolButton33: TToolButton;
    ToolButton34: TToolButton;
    ToolButton35: TToolButton;
    ToolButton36: TToolButton;
    ToolButton5: TToolButton;
    ToolButton11: TToolButton;
    PageControl2: TPageControl;
    TabSheet11: TTabSheet;
    Panel7: TPanel;

    procedure ListViewOrderData(Sender: TObject; Item: TListItem);
    procedure ListViewTradeData(Sender: TObject; Item: TListItem);
    procedure ListViewSignalCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewOrderCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewSignalCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewOrderCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewTradeCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewTradeCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewLogData(Sender: TObject; Item: TListItem);
    procedure ListViewLogCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewLogCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewPMData(Sender: TObject; Item: TListItem);
    procedure ListViewPMCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewSignalSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ListViewPMCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewAdjustCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewAdjustData(Sender: TObject; Item: TListItem);
    procedure ListViewAdjustCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure RadioButtonTotalViewClick(Sender: TObject);
    procedure ListViewSignalData(Sender: TObject; Item: TListItem);
    procedure Action_1001Execute(Sender: TObject);
    procedure Action_1001Update(Sender: TObject);
    procedure Action_1002Execute(Sender: TObject);
    procedure Action_1002Update(Sender: TObject);
    procedure Action_1003Execute(Sender: TObject);
    procedure Action_1003Update(Sender: TObject);
    procedure Action_1004Execute(Sender: TObject);
    procedure Action_1004Update(Sender: TObject);

  private
    m_Block: CMXBlock;
    m_BlockItemControl: TObject;

    m_EnableEvent: Boolean;

    m_SignalCollection: CFNSignalCollection;
    m_OrderCollection: CFNOrderCollection;
    m_TradeCollection: CFNTradeCollection;

    m_AdjustCollection: CFNAdjustCollection;

    m_TotalView: Boolean;

    m_ViewOrderCollection: CFNOrderCollection;
    m_ViewTradeCollection: CFNTradeCollection;

    m_SelectedSignalSequence: Integer;

    m_TrafficManager: CFNTrafficManager;
    m_ValueCollection: Array [0 .. 2] of CFNPMValueCollection;

    m_OnOptionChanged: TNotifyEvent;

    procedure SetBlockItemControl(ABlockItemControl: TObject);
    procedure SetViewOrderCollection;
    procedure ApplyLanguage;

  protected
    procedure OnChangedOptionEvent(Sender: TObject);

  public
    MatrixSumaryOptionFrame1: TMatrixSumaryOptionFrame;
    MatrixOptionFrame1: TMatrixOptionFrame;
    MatrixChartFrame1: TMatrixChartFrame;

    procedure Clear;

    procedure ClearOrderManagerInfo;
    procedure DisplayOrderManagerInfo;

    procedure ClearOrderManagerProfit;
    procedure DisplayOrderManagerProfit;

    procedure ClearLogInfo;
    procedure DisplayLogInfo;

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure OnFormCreate;
    procedure OnFormClose;

    property Block: CMXBlock read m_Block;
    property BlockItemControl: TObject read m_BlockItemControl write SetBlockItemControl;

    property OnOptionChanged: TNotifyEvent read m_OnOptionChanged write m_OnOptionChanged;

  end;

implementation

{$R *.dfm}

uses FNGlobal, DateUtils, Math, FNCMVariable, FNSymbolCollection,
  FNPOTCollection, FNBlockItemControl;

{ TBlockContentFrame }

// ------------------------------------------------------------------------------------
constructor TBlockContentFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

// ------------------------------------------------------------------------------------
destructor TBlockContentFrame.Destroy;
begin
  inherited;
end;

procedure TBlockContentFrame.ApplyLanguage;
begin
  if (g_Language = 0) then
  begin
    Action_0003.Caption := '매매결과저장';
    Action_0004.Caption := '다음 날 이동';
    Action_0006.Caption := '신호내역저장';
    Action_0007.Caption := '데이터저장';
    Action_1001.Caption := '확대';
    Action_1002.Caption := '축소';
    Action_1003.Caption := '원래크기';
    Action_1004.Caption := '전체보기';

    TabSheet7.Caption := '신호리스트';
    TabSheet9.Caption := '포지션조정';
    TabSheet4.Caption := '주문리스트';
    TabSheet5.Caption := '체결리스트';
    TabSheet2.Caption := '성능분석';
    TabSheet3.Caption := '로그리스트';
    RadioButtonTotalView.Caption := '전체 리스트 보기';
    RadioButtonPartView.Caption := '선택된 신호의 리스트 보기';

    ListViewSignal.Column[0].Caption := '순번';
    ListViewSignal.Column[1].Caption := '발생시간';
    ListViewSignal.Column[2].Caption := '신호';
    ListViewSignal.Column[3].Caption := '가격';
    ListViewSignal.Column[4].Caption := '시스템';
    ListViewSignal.Column[5].Caption := '주문번호';
    ListViewSignal.Column[6].Caption := '주문횟수';
    ListViewSignal.Column[7].Caption := '주문시간';
    ListViewSignal.Column[8].Caption := '주문종류';
    ListViewSignal.Column[9].Caption := '가격방식';
    ListViewSignal.Column[10].Caption := '주문가격';
    ListViewSignal.Column[11].Caption := '주문수량';
    ListViewSignal.Column[12].Caption := '주문번호';
    ListViewSignal.Column[13].Caption := '체결가격';
    ListViewSignal.Column[14].Caption := '체결수량';
    ListViewSignal.Column[15].Caption := '수익';
    ListViewSignal.Column[16].Caption := '주문유형';
    ListViewSignal.Column[17].Caption := '진행단계';

    ListViewAdjust.Column[0].Caption := '순번';
    ListViewAdjust.Column[1].Caption := '신호순번';
    ListViewAdjust.Column[2].Caption := '발생시간';
    ListViewAdjust.Column[3].Caption := '주문순번';
    ListViewAdjust.Column[4].Caption := '주문횟수';
    ListViewAdjust.Column[5].Caption := '주문시간';
    ListViewAdjust.Column[6].Caption := '주문종류';
    ListViewAdjust.Column[7].Caption := '가격방식';
    ListViewAdjust.Column[8].Caption := '주문가격';
    ListViewAdjust.Column[9].Caption := '주문수량';
    ListViewAdjust.Column[10].Caption := '주문번호';
    ListViewAdjust.Column[11].Caption := '체결가격';
    ListViewAdjust.Column[12].Caption := '체결수량';
    ListViewAdjust.Column[13].Caption := '주문유형';
    ListViewAdjust.Column[14].Caption := '진행단계';

    ListViewOrder.Column[0].Caption := '주문번호';
    ListViewOrder.Column[1].Caption := '신호순번';
    ListViewOrder.Column[2].Caption := '주문유형';
    ListViewOrder.Column[3].Caption := '주문시간';
    ListViewOrder.Column[4].Caption := '주문종류';
    ListViewOrder.Column[5].Caption := '가격방식';
    ListViewOrder.Column[6].Caption := '주문가격';
    ListViewOrder.Column[7].Caption := '주문수량';
    ListViewOrder.Column[8].Caption := '주문번호';
    ListViewOrder.Column[9].Caption := '원주문번호';
    ListViewOrder.Column[10].Caption := '진행상태';
    ListViewOrder.Column[11].Caption := '메세지코드';
    ListViewOrder.Column[12].Caption := '메세지내용';

    ListViewTrade.Column[0].Caption := '체결순번';
    ListViewTrade.Column[1].Caption := '주문순번';
    ListViewTrade.Column[2].Caption := '신호순번';
    ListViewTrade.Column[3].Caption := '체결종류';
    ListViewTrade.Column[4].Caption := '체결가';
    ListViewTrade.Column[5].Caption := '체결량';
    ListViewTrade.Column[6].Caption := '주문가';
    ListViewTrade.Column[7].Caption := '주문량';
    ListViewTrade.Column[8].Caption := '주문번호';

    ListViewPM.Column[0].Caption := '성능분석명';
    ListViewPM.Column[1].Caption := '전체거래';
    ListViewPM.Column[2].Caption := '매수거래';
    ListViewPM.Column[3].Caption := '매도거래';

    ListViewLog.Column[0].Caption := '발생시간';
    ListViewLog.Column[1].Caption := '유형';
    ListViewLog.Column[2].Caption := '내용';

  end
  else if (g_Language = 1) then
  begin

    Action_0003.Caption := 'Save';
    Action_0004.Caption := 'Next Date';
    Action_0006.Caption := 'Save Signal';
    Action_0007.Caption := 'Save Data';
    Action_1001.Caption := 'Zoom in';
    Action_1002.Caption := 'Zoom out';
    Action_1003.Caption := 'Actual Size';
    Action_1004.Caption := 'View Full Data';

    PageControlSignal.TabWidth := 0;

    TabSheet7.Caption := 'Signal List';
    TabSheet9.Caption := 'Position Adjustment';
    TabSheet4.Caption := 'Order';
    TabSheet5.Caption := 'Execution';
    TabSheet2.Caption := 'Performance';
    TabSheet3.Caption := 'Log';
    RadioButtonTotalView.Caption := 'All list';
    RadioButtonPartView.Caption := 'List of selected signal';

    ListViewSignal.Column[0].Caption := 'Seq';
    ListViewSignal.Column[1].Caption := 'Time';
    ListViewSignal.Column[2].Caption := 'Signal';
    ListViewSignal.Column[3].Caption := 'Price';
    ListViewSignal.Column[4].Caption := 'System';
    ListViewSignal.Column[5].Caption := 'OrderSeq';
    ListViewSignal.Column[6].Caption := 'Number of Order';
    ListViewSignal.Column[7].Caption := 'Order Time';
    ListViewSignal.Column[8].Caption := 'Order Category';
    ListViewSignal.Column[9].Caption := 'Price System';
    ListViewSignal.Column[10].Caption := 'Order Price';
    ListViewSignal.Column[11].Caption := 'Order Quantity';
    ListViewSignal.Column[12].Caption := 'OrderNo';
    ListViewSignal.Column[13].Caption := 'Executed Price';
    ListViewSignal.Column[14].Caption := 'Executed Quantity';
    ListViewSignal.Column[15].Caption := 'Profit';
    ListViewSignal.Column[16].Caption := 'Order Type';
    ListViewSignal.Column[17].Caption := 'Progress';

    ListViewSignal.Column[0].Width := 50;
    ListViewSignal.Column[1].Width := 70;
    ListViewSignal.Column[2].Width := 70;
    ListViewSignal.Column[3].Width := 70;
    ListViewSignal.Column[4].Width := 50;
    ListViewSignal.Column[5].Width := Length(ListViewSignal.Column[5].Caption) * 10;
    ListViewSignal.Column[6].Width := Length(ListViewSignal.Column[6].Caption) * 10;
    ListViewSignal.Column[7].Width := Length(ListViewSignal.Column[7].Caption) * 10;
    ListViewSignal.Column[8].Width := Length(ListViewSignal.Column[8].Caption) * 10;
    ListViewSignal.Column[9].Width := Length(ListViewSignal.Column[9].Caption) * 10;
    ListViewSignal.Column[10].Width := Length(ListViewSignal.Column[10].Caption) * 10;
    ListViewSignal.Column[11].Width := Length(ListViewSignal.Column[11].Caption) * 10;
    ListViewSignal.Column[12].Width := Length(ListViewSignal.Column[12].Caption) * 10;
    ListViewSignal.Column[13].Width := Length(ListViewSignal.Column[13].Caption) * 10;
    ListViewSignal.Column[14].Width := Length(ListViewSignal.Column[14].Caption) * 10;
    ListViewSignal.Column[15].Width := Length(ListViewSignal.Column[15].Caption) * 10;
    ListViewSignal.Column[16].Width := Length(ListViewSignal.Column[16].Caption) * 10;
    ListViewSignal.Column[17].Width := Length(ListViewSignal.Column[17].Caption) * 10;

    ListViewAdjust.Column[0].Caption := 'Seq';
    ListViewAdjust.Column[1].Caption := 'SignalSeq';
    ListViewAdjust.Column[2].Caption := 'Time';
    ListViewAdjust.Column[3].Caption := 'OrderSeq';
    ListViewAdjust.Column[4].Caption := 'Number of Order';
    ListViewAdjust.Column[5].Caption := 'Order Time';
    ListViewAdjust.Column[6].Caption := 'Order Category';
    ListViewAdjust.Column[7].Caption := 'Price System';
    ListViewAdjust.Column[8].Caption := 'Order Price';
    ListViewAdjust.Column[9].Caption := 'Order Quantity';
    ListViewAdjust.Column[10].Caption := 'OrderNo';
    ListViewAdjust.Column[11].Caption := 'Executed Price';
    ListViewAdjust.Column[12].Caption := 'Executed Quantity';
    ListViewAdjust.Column[13].Caption := 'Order Type';
    ListViewAdjust.Column[14].Caption := 'Progress';

    ListViewAdjust.Column[0].Width := 100;
    ListViewAdjust.Column[1].Width := 100;
    ListViewAdjust.Column[2].Width := 70;
    ListViewAdjust.Column[3].Width := Length(ListViewAdjust.Column[3].Caption) * 10;
    ListViewAdjust.Column[4].Width := Length(ListViewAdjust.Column[4].Caption) * 10;
    ListViewAdjust.Column[5].Width := Length(ListViewAdjust.Column[5].Caption) * 10;
    ListViewAdjust.Column[6].Width := Length(ListViewAdjust.Column[6].Caption) * 10;
    ListViewAdjust.Column[7].Width := Length(ListViewAdjust.Column[7].Caption) * 10;
    ListViewAdjust.Column[8].Width := Length(ListViewAdjust.Column[8].Caption) * 10;
    ListViewAdjust.Column[9].Width := Length(ListViewAdjust.Column[9].Caption) * 10;
    ListViewAdjust.Column[10].Width := Length(ListViewAdjust.Column[10].Caption) * 10;
    ListViewAdjust.Column[11].Width := Length(ListViewAdjust.Column[11].Caption) * 10;
    ListViewAdjust.Column[12].Width := Length(ListViewAdjust.Column[12].Caption) * 10;
    ListViewAdjust.Column[13].Width := Length(ListViewAdjust.Column[13].Caption) * 10;
    ListViewAdjust.Column[14].Width := Length(ListViewAdjust.Column[14].Caption) * 10;

    ListViewOrder.Column[0].Caption := 'OrderSeq';
    ListViewOrder.Column[1].Caption := 'SignalSeq';
    ListViewOrder.Column[2].Caption := 'Order Type';
    ListViewOrder.Column[3].Caption := 'Order Time';
    ListViewOrder.Column[4].Caption := 'Order Category';
    ListViewOrder.Column[5].Caption := 'Price System';
    ListViewOrder.Column[6].Caption := 'Order Price';
    ListViewOrder.Column[7].Caption := 'Order Quantity';
    ListViewOrder.Column[8].Caption := 'OrderNo';
    ListViewOrder.Column[9].Caption := 'OrgOrderNo';
    ListViewOrder.Column[10].Caption := 'Progress';
    ListViewOrder.Column[11].Caption := 'MsgCode';
    ListViewOrder.Column[12].Caption := 'Msg';

    ListViewOrder.Column[0].Width := Length(ListViewOrder.Column[0].Caption) * 10;
    ListViewOrder.Column[1].Width := Length(ListViewOrder.Column[1].Caption) * 10;
    ListViewOrder.Column[2].Width := Length(ListViewOrder.Column[2].Caption) * 10;
    ListViewOrder.Column[3].Width := Length(ListViewOrder.Column[3].Caption) * 10;
    ListViewOrder.Column[4].Width := Length(ListViewOrder.Column[4].Caption) * 10;
    ListViewOrder.Column[5].Width := Length(ListViewOrder.Column[5].Caption) * 10;
    ListViewOrder.Column[6].Width := Length(ListViewOrder.Column[6].Caption) * 10;
    ListViewOrder.Column[7].Width := Length(ListViewOrder.Column[7].Caption) * 10;
    ListViewOrder.Column[8].Width := Length(ListViewOrder.Column[8].Caption) * 10;
    ListViewOrder.Column[9].Width := Length(ListViewOrder.Column[9].Caption) * 10;
    ListViewOrder.Column[10].Width := Length(ListViewOrder.Column[10].Caption) * 10;
    ListViewOrder.Column[11].Width := Length(ListViewOrder.Column[11].Caption) * 10;
    ListViewOrder.Column[12].Width := Length(ListViewOrder.Column[12].Caption) * 10;

    ListViewTrade.Column[0].Caption := 'FillSeq';
    ListViewTrade.Column[1].Caption := 'OrderSeq';
    ListViewTrade.Column[2].Caption := 'SignalSeq';
    ListViewTrade.Column[3].Caption := 'Order Category';
    ListViewTrade.Column[4].Caption := 'Executed Price';
    ListViewTrade.Column[5].Caption := 'Executed Quantity';
    ListViewTrade.Column[6].Caption := 'Order Price';
    ListViewTrade.Column[7].Caption := 'Order Quantity';
    ListViewTrade.Column[8].Caption := 'OrderNo';

    ListViewTrade.Column[0].Width := Length(ListViewTrade.Column[0].Caption) * 10;
    ListViewTrade.Column[1].Width := Length(ListViewTrade.Column[1].Caption) * 10;
    ListViewTrade.Column[2].Width := Length(ListViewTrade.Column[2].Caption) * 10;
    ListViewTrade.Column[3].Width := Length(ListViewTrade.Column[3].Caption) * 10;
    ListViewTrade.Column[4].Width := Length(ListViewTrade.Column[4].Caption) * 10;
    ListViewTrade.Column[5].Width := Length(ListViewTrade.Column[5].Caption) * 10;
    ListViewTrade.Column[6].Width := Length(ListViewTrade.Column[6].Caption) * 10;
    ListViewTrade.Column[7].Width := Length(ListViewTrade.Column[7].Caption) * 10;
    ListViewTrade.Column[8].Width := Length(ListViewTrade.Column[8].Caption) * 10;

    ListViewPM.Column[0].Caption := 'Field';
    ListViewPM.Column[1].Caption := 'Total Trade';
    ListViewPM.Column[2].Caption := 'Long Trade';
    ListViewPM.Column[3].Caption := 'Short Trade';

    ListViewLog.Column[0].Caption := 'Time';
    ListViewLog.Column[1].Caption := 'Type';
    ListViewLog.Column[2].Caption := 'Message';

  end;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.OnFormCreate;
begin
  m_EnableEvent := true;

  m_Block := NIL;

  m_SignalCollection := CFNSignalCollection.Create;
  m_OrderCollection := CFNOrderCollection.Create;
  m_TradeCollection := CFNTradeCollection.Create;
  m_TrafficManager := CFNTrafficManager.Create;

  m_AdjustCollection := CFNAdjustCollection.Create;

  m_ValueCollection[0] := CFNPMValueCollection.Create;
  m_ValueCollection[1] := CFNPMValueCollection.Create;
  m_ValueCollection[2] := CFNPMValueCollection.Create;

  PageControlSignal.ActivePageIndex := 0;

  // PageControl1.ActivePageIndex := 0;
  PageControlOrder.ActivePageIndex := 0;

  MatrixOptionFrame1 := TMatrixOptionFrame.Create(Owner);
  MatrixOptionFrame1.Parent := PanelCondition;
  MatrixOptionFrame1.Align := alClient;

  if Assigned(m_Block) then
    MatrixOptionFrame1.AttachBlock(m_Block);
  MatrixOptionFrame1.OnChangedOption := OnChangedOptionEvent;
  MatrixOptionFrame1.OnFormCreate;

  MatrixSumaryOptionFrame1 := TMatrixSumaryOptionFrame.Create(Owner);
  MatrixSumaryOptionFrame1.Parent := PanelSumary;
  MatrixSumaryOptionFrame1.Align := alClient;

  MatrixSumaryOptionFrame1.OnFormCreate;

  MatrixChartFrame1 := TMatrixChartFrame.Create(Owner);
  MatrixChartFrame1.Parent := PanelChart;
  MatrixChartFrame1.Align := alClient;
  if Assigned(m_Block) then
    MatrixChartFrame1.AttachBlock(m_Block);
  MatrixChartFrame1.OnFormCreate;

  m_TotalView := true;
  m_SelectedSignalSequence := -1;
  SetViewOrderCollection;

  m_EnableEvent := false;
  if m_TotalView then
  begin
    RadioButtonTotalView.Checked := true;
  end
  else
  begin
    RadioButtonPartView.Checked := true;
  end;
  m_EnableEvent := true;

  ApplyLanguage;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.OnFormClose;
begin
  Clear;

  MatrixOptionFrame1.OnFormClose;
  MatrixChartFrame1.OnFormClose;
  MatrixSumaryOptionFrame1.OnFormClose;

  m_Block := NIL;
  if Assigned(m_SignalCollection) then
  begin
    m_SignalCollection.Free;
    m_SignalCollection := NIL;
  end;

  if Assigned(m_OrderCollection) then
  begin
    m_OrderCollection.Free;
    m_OrderCollection := NIL;
  end;

  if Assigned(m_TradeCollection) then
  begin
    m_TradeCollection.Free;
    m_TradeCollection := NIL;
  end;

  if Assigned(m_AdjustCollection) then
  begin
    m_AdjustCollection.Free;
    m_AdjustCollection := NIL;
  end;

  m_TrafficManager.Free;
  m_ValueCollection[0].Free;
  m_ValueCollection[1].Free;
  m_ValueCollection[2].Free;

end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.OnChangedOptionEvent(Sender: TObject);
begin
  if Assigned(m_OnOptionChanged) then
    m_OnOptionChanged(Sender);
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.Action_1001Execute(Sender: TObject);
begin
  if not Assigned(m_Block) then
    exit;

  MatrixChartFrame1.ZoomIn;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.Action_1001Update(Sender: TObject);
begin
  if Assigned(m_Block) then
  begin
    TAction(Sender).Enabled := true;
  end
  else
  begin
    TAction(Sender).Enabled := false;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.Action_1002Execute(Sender: TObject);
begin
  if not Assigned(m_Block) then
    exit;

  MatrixChartFrame1.ZoomOut;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.Action_1002Update(Sender: TObject);
begin
  if Assigned(m_Block) then
  begin
    TAction(Sender).Enabled := true;
  end
  else
  begin
    TAction(Sender).Enabled := false;
  end;
end;

procedure TBlockContentFrame.Clear;
begin
  ClearOrderManagerInfo;
  ClearOrderManagerProfit;
  ClearLogInfo;

  MatrixChartFrame1.ClearSystemManagerInfo;

  m_SelectedSignalSequence := -1;
  SetViewOrderCollection;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ClearLogInfo;
begin
  ListViewLog.Items.Count := 0;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ClearOrderManagerInfo;
begin
  ListViewSignal.Items.Count := 0;
  ListViewOrder.Items.Count := 0;
  ListViewTrade.Items.Count := 0;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ClearOrderManagerProfit;
begin
  ListViewPM.Items.Count := 0;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.DisplayLogInfo;
begin
  if not Assigned(m_Block) then
    exit;

  try
    ListViewLog.Items.Count := m_Block.LogCollection.m_Items.Count;
    ListViewLog.Repaint;
  except
  end;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.DisplayOrderManagerInfo;
begin
  if not Assigned(m_Block) then
    exit;

  m_Block.OrderManager.CopyAllCollection(m_SignalCollection, m_OrderCollection, m_TradeCollection);
  m_Block.OrderManager.CopyAdjustCollection(m_AdjustCollection);

  try
    ListViewSignal.Items.Count := m_SignalCollection.m_Items.Count;
    ListViewSignal.Repaint;

    SetViewOrderCollection;

    if m_TotalView then
    begin
      ListViewOrder.Items.Count := m_ViewOrderCollection.m_Items.Count;
      ListViewOrder.Repaint;

      ListViewTrade.Items.Count := m_ViewTradeCollection.m_Items.Count;
      ListViewTrade.Repaint;
    end;
  except
  end;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.DisplayOrderManagerProfit;
var
  f_ClosePrice: Double;
begin
  if not Assigned(m_Block) then
    exit;

  try
    f_ClosePrice := m_Block.SystemManager.m_RealPrice;
    m_TrafficManager.MakeTradeListBySignalCollection(m_SignalCollection, f_ClosePrice);

    m_TrafficManager.m_AllTrafficCollection.WritePrformance(m_ValueCollection[0]);
    m_TrafficManager.m_LongTrafficCollection.WritePrformance(m_ValueCollection[1]);
    m_TrafficManager.m_ShortTrafficCollection.WritePrformance(m_ValueCollection[2]);

    ListViewPM.Items.Count := m_ValueCollection[0].m_Items.Count;
    ListViewPM.Repaint;
  except
  end;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.SetBlockItemControl(ABlockItemControl: TObject);
begin
  if m_BlockItemControl <> ABlockItemControl then
  begin
    m_BlockItemControl := ABlockItemControl;
    if Assigned(m_BlockItemControl) then
    begin
      m_Block := TBlockItemControl(m_BlockItemControl).Block;
    end
    else
    begin
      m_Block := NIL;
    end;

    Clear;

    if Assigned(m_Block) then
    begin
      MatrixOptionFrame1.DetachBlock(false);
      MatrixOptionFrame1.AttachBlock(m_Block);
      MatrixOptionFrame1.UpdateOnChangedBlock;

      MatrixChartFrame1.DetachBlock;
      MatrixChartFrame1.AttachBlock(m_Block);
      MatrixChartFrame1.UpdateOnChangedBlock;

    end
    else
    begin
      MatrixOptionFrame1.DetachBlock(true);
      MatrixOptionFrame1.UpdateOnChangedBlock;

      MatrixChartFrame1.DetachBlock;
      MatrixChartFrame1.UpdateOnChangedBlock;
    end;

    DisplayLogInfo;
    DisplayOrderManagerInfo;
    DisplayOrderManagerProfit;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.SetViewOrderCollection;
var
  f_SignalItem: CFNSignalItem;
  f_ViewOrderCollection: CFNOrderCollection;
  f_ViewTradeCollection: CFNTradeCollection;
begin
  f_ViewOrderCollection := m_ViewOrderCollection;
  f_ViewTradeCollection := m_ViewTradeCollection;

  if Not m_TotalView then
  begin
    if m_SelectedSignalSequence >= 0 then
    begin
      f_SignalItem := m_SignalCollection.m_Items[m_SelectedSignalSequence];
      f_ViewOrderCollection := f_SignalItem.m_OrderCollection;
      f_ViewTradeCollection := f_SignalItem.m_TradeCollection;
    end
    else
    begin
      f_ViewOrderCollection := NIL;
      f_ViewTradeCollection := NIL;
    end;
  end
  else
  begin
    f_ViewOrderCollection := m_OrderCollection;
    f_ViewTradeCollection := m_TradeCollection;
  end;

  if f_ViewOrderCollection <> m_ViewOrderCollection then
  begin
    m_ViewOrderCollection := f_ViewOrderCollection;
    if m_ViewOrderCollection <> NIL then
    begin
      ListViewOrder.Items.Count := m_ViewOrderCollection.m_Items.Count;
      ListViewOrder.Repaint;
    end
    else
    begin
      ListViewOrder.Items.Count := 0;
      ListViewOrder.Repaint;
    end;
  end;

  if f_ViewTradeCollection <> m_ViewTradeCollection then
  begin
    m_ViewTradeCollection := f_ViewTradeCollection;
    if m_ViewTradeCollection <> NIL then
    begin
      ListViewTrade.Items.Count := m_ViewTradeCollection.m_Items.Count;
      ListViewTrade.Repaint;
    end
    else
    begin
      ListViewTrade.Items.Count := 0;
      ListViewTrade.Repaint;
    end;
  end;

  ListViewAdjust.Items.Count := m_AdjustCollection.m_Items.Count;
  ListViewAdjust.Repaint;
end;

{$REGION 'ListViewTrade'}

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewTradeCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  DefaultDraw := true;
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
procedure TBlockContentFrame.ListViewTradeCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f_TradeItem: CFNTradeItem;
begin
  if m_ViewTradeCollection = NIL then
    exit;

  f_TradeItem := Item.Data;

  if Item.Index mod 2 = 0 then
  begin
    Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
  end
  else
  begin
    Sender.Canvas.Brush.Color := RGB($F0, $F0, $F0);
  end;

  if (SubItem = 3) then
  begin
    if (f_TradeItem.m_OrderType = ORDER_TYPE_BUY) then
    begin
      Sender.Canvas.Font.Color := RGB($FF, $00, $00);
    end
    else if (f_TradeItem.m_OrderType = ORDER_TYPE_SELL) then
    begin
      Sender.Canvas.Font.Color := RGB($00, $00, $FF);
    end
    else
    begin
      Sender.Canvas.Font.Color := RGB($00, $00, $00);
    end;
  end
  else
  begin
    Sender.Canvas.Font.Color := RGB($00, $00, $00);
  end;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewTradeData(Sender: TObject; Item: TListItem);
var
  nItemIndex: Integer;
  f_TradeItem: CFNTradeItem;
  f_MaterialItem: CFNMaterialItem;
  f_Precesion: Integer;
begin
  if m_ViewTradeCollection = NIL then
    exit;
  if ((Item.Index < 0) or (Item.Index >= m_ViewTradeCollection.m_Items.Count)) then
    exit;

  f_Precesion := 2;
  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(m_Block.Option.GetIntegerValue('COUNTRY_NO'), m_Block.Option.GetIntegerValue('GROUP_NO'), m_Block.Option.GetIntegerValue('MARKET_NO'), g_SymbolCollection.GetOPSSymbol(m_Block.Option.GetStringValue('SYMBOL')));

    if Assigned(f_MaterialItem) then
    begin
      f_Precesion := f_MaterialItem.m_Precision;
    end;
  end;

  nItemIndex := m_ViewTradeCollection.m_Items.Count - Item.Index - 1;
  f_TradeItem := m_ViewTradeCollection.m_Items[nItemIndex];

  Item.Caption := TFNGlobal.WriteNumber(f_TradeItem.m_TradeSequence, 0);
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_TradeItem.m_OrderSequence, 0));
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_TradeItem.m_SignalSequence, 0));
  Item.SubItems.Add(GetOrderTypeText(f_TradeItem.m_OrderType));
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_TradeItem.m_TradePrice, f_Precesion));
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_TradeItem.m_TradeVolume, 0));
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_TradeItem.m_OrderPrice, f_Precesion));
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_TradeItem.m_OrderVolume, 0));
  if f_TradeItem.m_OrderItem <> NIL then
  begin
    Item.SubItems.Add(f_TradeItem.m_OrderItem.m_OrderNumber);
  end
  else
  begin
    Item.SubItems.Add('');
  end;
  Item.Data := f_TradeItem;

end;
{$ENDREGION}
{$REGION 'ListViewLog'}

procedure TBlockContentFrame.ListViewLogCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f_LogItem: CFNLogItem;
begin
  f_LogItem := Item.Data;
  try
    if (f_LogItem.m_Type = LOG_TYPE_ERROR) then
    begin
      Sender.Canvas.Brush.Color := RGB($80, $00, $00);
      Sender.Canvas.Font.Color := RGB($FF, $FF, $00);
    end
    else if (f_LogItem.m_Type = LOG_TYPE_WARNNING) then
    begin
      Sender.Canvas.Brush.Color := RGB($80, $80, $00);
      Sender.Canvas.Font.Color := RGB($FF, $FF, $FF);
    end
    else
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
      Sender.Canvas.Font.Color := RGB($00, $00, $00);
    end;
  except
  end;
  DefaultDraw := true;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewLogCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f_LogItem: CFNLogItem;
begin
  f_LogItem := Item.Data;
  try
    if (f_LogItem.m_Type = LOG_TYPE_ERROR) then
    begin
      Sender.Canvas.Brush.Color := RGB($80, $00, $00);
      Sender.Canvas.Font.Color := RGB($FF, $FF, $00);
    end
    else if (f_LogItem.m_Type = LOG_TYPE_WARNNING) then
    begin
      Sender.Canvas.Brush.Color := RGB($80, $80, $00);
      Sender.Canvas.Font.Color := RGB($FF, $FF, $FF);
    end
    else
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
      Sender.Canvas.Font.Color := RGB($00, $00, $00);
    end;
  except
  end;
  DefaultDraw := true;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewLogData(Sender: TObject; Item: TListItem);
var
  nItemIndex: Integer;
  f_LogItem: CFNLogItem;
begin
  if not Assigned(m_Block) then
    exit;

  if ((Item.Index < 0) or (Item.Index >= m_Block.LogCollection.m_Items.Count)) then
    exit;
  nItemIndex := Item.Index;
  f_LogItem := m_Block.LogCollection.m_Items[nItemIndex];

  Item.Caption := TFNGlobal.DateTimeToStr6(f_LogItem.m_DateTime);
  Item.SubItems.Add(GetLogTypeText(f_LogItem.m_Type));
  Item.SubItems.Add(f_LogItem.m_Message);
  Item.SubItems.Add(f_LogItem.m_ClassName);
  Item.Data := f_LogItem;
end;
{$ENDREGION}
{$REGION 'ListViewOrder'}

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewOrderCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f_OrderItem: CFNOrderItem;
begin
  if m_ViewOrderCollection = NIL then
    exit;
  f_OrderItem := Item.Data;
  try
    if (f_OrderItem.m_ProcessStep = PST_COMPLITE_TRADE) then
    begin
      Sender.Canvas.Brush.Color := RGB($CC, $FF, $CC);
    end
    else if (f_OrderItem.m_ProcessStep = PST_CHANGE_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($DD, $DD, $DD);
    end
    else if (f_OrderItem.m_ProcessStep = PST_REJECT_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $DD, $DD);
    end
    else if (f_OrderItem.m_ProcessStep = PST_CANCEL_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($BB, $BB, $BB);
    end
    else if (f_OrderItem.m_ProcessStep = PST_DELETE_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($BB, $BB, $BB);
    end
    else if (f_OrderItem.m_ProcessStep = PST_ERROR_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $AA, $AA);
    end
    else
    begin
      Sender.Canvas.Brush.Color := RGB($EE, $FF, $EE);
    end;
  except
  end;

  DefaultDraw := true;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewOrderCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f_OrderItem: CFNOrderItem;
begin
  if m_ViewOrderCollection = NIL then
    exit;
  f_OrderItem := Item.Data;

  try
    if (SubItem = 4) then
    begin
      if (f_OrderItem.m_OrderType = ORDER_TYPE_BUY) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_OrderItem.m_OrderType = ORDER_TYPE_SELL) then
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $FF);
      end
      else
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $00);
      end;
    end
    else
    begin
      Sender.Canvas.Font.Color := RGB($00, $00, $00);
    end;

    if (f_OrderItem.m_ProcessStep = PST_COMPLITE_TRADE) then
    begin
      Sender.Canvas.Brush.Color := RGB($CC, $FF, $CC);
    end
    else if (f_OrderItem.m_ProcessStep = PST_CHANGE_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($DD, $DD, $DD);
    end
    else if (f_OrderItem.m_ProcessStep = PST_REJECT_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $DD, $DD);
    end
    else if (f_OrderItem.m_ProcessStep = PST_CANCEL_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($BB, $BB, $BB);
    end
    else if (f_OrderItem.m_ProcessStep = PST_DELETE_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($BB, $BB, $BB);
    end
    else if (f_OrderItem.m_ProcessStep = PST_ERROR_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $AA, $AA);
    end
    else
    begin
      Sender.Canvas.Brush.Color := RGB($EE, $FF, $EE);
    end;
  except
  end;

  DefaultDraw := true;

end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewOrderData(Sender: TObject; Item: TListItem);
var
  nItemIndex: Integer;
  f_OrderItem: CFNOrderItem;
  f_MaterialItem: CFNMaterialItem;
  f_Precesion: Integer;
begin
  if m_ViewOrderCollection = NIL then
    exit;
  if ((Item.Index < 0) or (Item.Index >= m_ViewOrderCollection.m_Items.Count)) then
    exit;

  f_Precesion := 2;
  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(m_Block.Option.GetIntegerValue('COUNTRY_NO'), m_Block.Option.GetIntegerValue('GROUP_NO'), m_Block.Option.GetIntegerValue('MARKET_NO'), g_SymbolCollection.GetOPSSymbol(m_Block.Option.GetStringValue('SYMBOL')));

    if Assigned(f_MaterialItem) then
    begin
      f_Precesion := f_MaterialItem.m_Precision;
    end;
  end;

  nItemIndex := m_ViewOrderCollection.m_Items.Count - Item.Index - 1;
  f_OrderItem := m_ViewOrderCollection.m_Items[nItemIndex];

  Item.Caption := TFNGlobal.WriteNumber(f_OrderItem.m_OrderSequence, 0);
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_OrderItem.m_SignalSequence, 0));
  Item.SubItems.Add(GetOrderDataTypeText(f_OrderItem.m_OrderDataType));
  Item.SubItems.Add(TFNGlobal.DateTimeToStr6(f_OrderItem.m_OrderDateTime));
  Item.SubItems.Add(GetOrderTypeText(f_OrderItem.m_OrderType));
  Item.SubItems.Add(GetOrderPriceTypeText(f_OrderItem.m_OrderPriceType));
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_OrderItem.m_OrderPrice, f_Precesion));
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_OrderItem.m_OrderVolume, 0));
  Item.SubItems.Add(f_OrderItem.m_OrderNumber);
  Item.SubItems.Add(f_OrderItem.m_OrgOrderNumber);
  Item.SubItems.Add(GetOrderProcessStepText(f_OrderItem.m_ProcessStep));
  Item.SubItems.Add(f_OrderItem.m_MessageCode);
  Item.SubItems.Add(f_OrderItem.m_MessageText);
  Item.Data := f_OrderItem;
end;
{$ENDREGION}
{$REGION 'ListViewPM'}

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewPMCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
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
procedure TBlockContentFrame.ListViewPMCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f_Paper: TCanvas;
  f_ListView: TListView;
  f_Index: Integer;
  f_Value: CFNPMValueItem;
  f_ItemIndex: Integer;
begin
  try
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
  except

  end;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewPMData(Sender: TObject; Item: TListItem);
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

  f_ItemIndex := Item.Index;
  f_Value := m_ValueCollection[0].m_Items[f_ItemIndex];
  Item.Data := f_Value;

  if f_Value = NIL then
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

  Item.Caption := f_Value.m_Name;
  for f_Index := 0 to 2 do
  begin
    f_Precision := f_Value.m_Precision;
    if (f_Precision = -1) then f_Precision := f_DefPrecision;
    f_Value := m_ValueCollection[f_Index].m_Items[f_ItemIndex];
    Item.SubItems.Add(Format('%.*n', [f_Precision, f_Value.m_Value]) + f_Value.m_Unit);
  end;
end;
{$ENDREGION}
{$REGION 'ListViewAdjust'}

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewAdjustCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f_AdjustItem: CFNAdjustItem;
begin
  try
    f_AdjustItem := Item.Data;

    if (f_AdjustItem.m_ProcessStep = PST_COMPLITE_TRADE) then
    begin
      Sender.Canvas.Brush.Color := RGB($CC, $FF, $CC);
    end
    else if (f_AdjustItem.m_ProcessStep = PST_CHANGE_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($DD, $DD, $DD);
    end
    else if (f_AdjustItem.m_ProcessStep = PST_REJECT_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $DD, $DD);
    end
    else if (f_AdjustItem.m_ProcessStep = PST_CANCEL_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($BB, $BB, $BB);
    end
    else if (f_AdjustItem.m_ProcessStep = PST_DELETE_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($BB, $BB, $BB);
    end
    else if (f_AdjustItem.m_ProcessStep = PST_ERROR_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $AA, $AA);
    end
    else
    begin
      Sender.Canvas.Brush.Color := RGB($EE, $FF, $EE);
    end;

  except

  end;

  DefaultDraw := true;
end;

procedure TBlockContentFrame.ListViewAdjustCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f_AdjustItem: CFNAdjustItem;
begin
  try
    f_AdjustItem := Item.Data;

    if (SubItem = 6) then
    begin
      if (f_AdjustItem.m_OrderType = ORDER_TYPE_BUY) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_AdjustItem.m_OrderType = ORDER_TYPE_SELL) then
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $FF);
      end
      else
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $00);
      end;
    end
    else
    begin
      Sender.Canvas.Font.Color := RGB($00, $00, $00);
    end;

    if (f_AdjustItem.m_ProcessStep = PST_COMPLITE_TRADE) then
    begin
      Sender.Canvas.Brush.Color := RGB($CC, $FF, $CC);
    end
    else if (f_AdjustItem.m_ProcessStep = PST_CHANGE_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($DD, $DD, $DD);
    end
    else if (f_AdjustItem.m_ProcessStep = PST_REJECT_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $DD, $DD);
    end
    else if (f_AdjustItem.m_ProcessStep = PST_CANCEL_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($BB, $BB, $BB);
    end
    else if (f_AdjustItem.m_ProcessStep = PST_DELETE_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($BB, $BB, $BB);
    end
    else if (f_AdjustItem.m_ProcessStep = PST_ERROR_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $AA, $AA);
    end
    else
    begin
      Sender.Canvas.Brush.Color := RGB($EE, $FF, $EE);
    end;
  except
  end;
  DefaultDraw := true;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewAdjustData(Sender: TObject; Item: TListItem);
var
  nItemIndex: Integer;
  f_AdjustItem: CFNAdjustItem;
  f_MaterialItem: CFNMaterialItem;
  f_Precesion: Integer;
begin
  if ((Item.Index < 0) or (Item.Index >= m_AdjustCollection.m_Items.Count)) then
    exit;
  nItemIndex := m_AdjustCollection.m_Items.Count - Item.Index - 1;

  f_Precesion := 2;
  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(m_Block.Option.GetIntegerValue('COUNTRY_NO'), m_Block.Option.GetIntegerValue('GROUP_NO'), m_Block.Option.GetIntegerValue('MARKET_NO'), g_SymbolCollection.GetOPSSymbol(m_Block.Option.GetStringValue('SYMBOL')));

    if Assigned(f_MaterialItem) then
    begin
      f_Precesion := f_MaterialItem.m_Precision;
    end;
  end;

  f_AdjustItem := m_AdjustCollection.m_Items[nItemIndex];

  Item.Caption := Format('%d', [f_AdjustItem.m_AdjustSequence]);
  Item.SubItems.Add(Format('%d', [f_AdjustItem.m_SignalSequence]));
  Item.SubItems.Add(TFNGlobal.DateTimeToStr6(f_AdjustItem.m_DateTime));
  Item.SubItems.Add(Format('%d', [f_AdjustItem.m_OrderSequence]));
  Item.SubItems.Add(Format('%d', [f_AdjustItem.m_CountOfSendingOrder]));

  Item.SubItems.Add(TFNGlobal.DateTimeToStr6(f_AdjustItem.m_OrderDateTime));
  Item.SubItems.Add(GetOrderTypeText(f_AdjustItem.m_OrderType));
  Item.SubItems.Add(GetOrderPriceTypeText(f_AdjustItem.m_OrderPriceType));
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_AdjustItem.m_OrderPrice, f_Precesion));
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_AdjustItem.m_OrderVolume, 0));
  Item.SubItems.Add(f_AdjustItem.m_OrderNumber);

  Item.SubItems.Add(TFNGlobal.WriteNumber(f_AdjustItem.m_TradePrice, f_Precesion));
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_AdjustItem.m_TradeVolume, 0));

  Item.SubItems.Add(GetOrderDataTypeText(f_AdjustItem.m_OrderDataType));
  Item.SubItems.Add(GetOrderProcessStepText(f_AdjustItem.m_ProcessStep));

  Item.Data := f_AdjustItem;
end;
{$ENDREGION}
{$REGION 'ListViewSignal'}

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewSignalCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f_SignalItem: CFNSignalItem;
begin
  try
    f_SignalItem := Item.Data;

    if (f_SignalItem.m_ProcessStep = PST_COMPLITE_TRADE) then
    begin
      Sender.Canvas.Brush.Color := RGB($CC, $FF, $CC);
    end
    else if (f_SignalItem.m_ProcessStep = PST_CHANGE_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($DD, $DD, $DD);
    end
    else if (f_SignalItem.m_ProcessStep = PST_REJECT_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $DD, $DD);
    end
    else if (f_SignalItem.m_ProcessStep = PST_CANCEL_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($BB, $BB, $BB);
    end
    else if (f_SignalItem.m_ProcessStep = PST_DELETE_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($BB, $BB, $BB);
    end
    else if (f_SignalItem.m_ProcessStep = PST_ERROR_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $AA, $AA);
    end
    else
    begin
      Sender.Canvas.Brush.Color := RGB($EE, $FF, $EE);
    end;

  except

  end;

  DefaultDraw := true;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewSignalCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f_SignalItem: CFNSignalItem;
begin
  try
    f_SignalItem := Item.Data;

    if (SubItem = 2) then
    begin
      if (f_SignalItem.m_Signal = SIGNAL_BUY_ENTER) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_SignalItem.m_Signal = SIGNAL_SELL_ENTER) then
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
      if (f_SignalItem.m_OrderType = ORDER_TYPE_BUY) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_SignalItem.m_OrderType = ORDER_TYPE_SELL) then
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $FF);
      end
      else
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $00);
      end;
    end
    else if (SubItem = 15) then
    begin
      if (f_SignalItem.m_Profit > 0) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_SignalItem.m_Profit < 0) then
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $FF);
      end
      else
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $00);
      end;
    end
    else
    begin
      Sender.Canvas.Font.Color := RGB($00, $00, $00);
    end;

    if (f_SignalItem.m_ProcessStep = PST_COMPLITE_TRADE) then
    begin
      Sender.Canvas.Brush.Color := RGB($CC, $FF, $CC);
    end
    else if (f_SignalItem.m_ProcessStep = PST_CHANGE_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($DD, $DD, $DD);
    end
    else if (f_SignalItem.m_ProcessStep = PST_REJECT_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $DD, $DD);
    end
    else if (f_SignalItem.m_ProcessStep = PST_CANCEL_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($BB, $BB, $BB);
    end
    else if (f_SignalItem.m_ProcessStep = PST_DELETE_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($BB, $BB, $BB);
    end
    else if (f_SignalItem.m_ProcessStep = PST_ERROR_ORDER) then
    begin
      Sender.Canvas.Brush.Color := RGB($FF, $AA, $AA);
    end
    else
    begin
      Sender.Canvas.Brush.Color := RGB($EE, $FF, $EE);
    end;
  except
  end;
  DefaultDraw := true;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewSignalData(Sender: TObject; Item: TListItem);
var
  nItemIndex: Integer;
  f_SignalItem: CFNSignalItem;
  f_MaterialItem: CFNMaterialItem;
  f_Precesion: Integer;
begin
  if ((Item.Index < 0) or (Item.Index >= m_SignalCollection.m_Items.Count)) then
    exit;

  nItemIndex := m_SignalCollection.m_Items.Count - Item.Index - 1;
  f_SignalItem := m_SignalCollection.m_Items[nItemIndex];

  f_Precesion := 2;
  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(m_Block.Option.GetIntegerValue('COUNTRY_NO'), m_Block.Option.GetIntegerValue('GROUP_NO'), m_Block.Option.GetIntegerValue('MARKET_NO'), g_SymbolCollection.GetOPSSymbol(m_Block.Option.GetStringValue('SYMBOL')));

    if Assigned(f_MaterialItem) then
    begin
      f_Precesion := f_MaterialItem.m_Precision;
    end;
  end;

  Item.Caption := Format('%d', [f_SignalItem.m_SignalSequence]);
  Item.SubItems.Add(TFNGlobal.DateTimeToStr6(f_SignalItem.m_DateTime));
  Item.SubItems.Add(GetSignalText(f_SignalItem.m_Signal));
  Item.SubItems.Add(Format('%.*n', [f_Precesion, f_SignalItem.m_Price]));
  Item.SubItems.Add(Format('%d', [f_SignalItem.m_SystemNo]));

  Item.SubItems.Add(Format('%d', [f_SignalItem.m_OrderSequence]));
  Item.SubItems.Add(Format('%d', [f_SignalItem.m_CountOfSendingOrder]));

  Item.SubItems.Add(TFNGlobal.DateTimeToStr6(f_SignalItem.m_OrderDateTime));
  Item.SubItems.Add(GetOrderTypeText(f_SignalItem.m_OrderType));
  Item.SubItems.Add(GetOrderPriceTypeText(f_SignalItem.m_OrderPriceType));
  Item.SubItems.Add(Format('%.*n', [f_Precesion, f_SignalItem.m_OrderPrice]));
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_SignalItem.m_OrderVolume, 0));
  Item.SubItems.Add(f_SignalItem.m_OrderNumber);

  Item.SubItems.Add(Format('%.*n', [f_Precesion, f_SignalItem.m_TradePrice]));
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_SignalItem.m_TradeVolume, 0));

  if (f_SignalItem.m_ProcessStep = PST_CANCEL_ORDER) or (f_SignalItem.m_ProcessStep = PST_WAITE_ORDER) or (f_SignalItem.m_ProcessStep = PST_DELETE_ORDER) then
  begin
    Item.SubItems.Add('');
  end
  else
  begin
    if (f_SignalItem.m_CorrectSignal = SIGNAL_SELL_EXIT) or (f_SignalItem.m_CorrectSignal = SIGNAL_BUY_EXIT) then
    begin
      Item.SubItems.Add(TFNGlobal.WriteNumber(f_SignalItem.m_Profit, 2));
    end
    else
    begin
      Item.SubItems.Add('');
    end;
  end;

  Item.SubItems.Add(GetOrderDataTypeText(f_SignalItem.m_OrderDataType));
  Item.SubItems.Add(GetOrderProcessStepText(f_SignalItem.m_ProcessStep));

  Item.Data := f_SignalItem;
end;
{$ENDREGION}

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.RadioButtonTotalViewClick(Sender: TObject);
var
  f_RadioButton: TRadioButton;
begin
  if not m_EnableEvent then
    exit;

  f_RadioButton := TRadioButton(Sender);

  if f_RadioButton.Tag = 0 then
  begin
    m_TotalView := true;
  end
  else
  begin
    m_TotalView := false;
  end;
  SetViewOrderCollection;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.ListViewSignalSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  f_SignalItem: CFNSignalItem;
begin
  if Selected then
  begin
    f_SignalItem := Item.Data;
    if f_SignalItem <> NIL then
    begin
      m_SelectedSignalSequence := f_SignalItem.m_SignalSequence;
    end
    else
    begin
      m_SelectedSignalSequence := -1;
    end;
  end
  else
  begin
    m_SelectedSignalSequence := -1;
  end;
  SetViewOrderCollection;
end;

{$ENDREGION}

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.Action_1003Execute(Sender: TObject);
begin
  if not Assigned(m_Block) then
    exit;

  MatrixChartFrame1.ZoomActual;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.Action_1003Update(Sender: TObject);
begin
  if Assigned(m_Block) then
  begin
    TAction(Sender).Enabled := true;
  end
  else
  begin
    TAction(Sender).Enabled := false;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.Action_1004Execute(Sender: TObject);
begin
  if not Assigned(m_Block) then
    exit;

  MatrixChartFrame1.FullEnlarge;
end;

// ------------------------------------------------------------------------------------
procedure TBlockContentFrame.Action_1004Update(Sender: TObject);
begin
  if Assigned(m_Block) then
  begin
    if (MatrixChartFrame1.EnabledChart) then
    begin
      TAction(Sender).Enabled := true;
    end
    else
    begin
      TAction(Sender).Enabled := false;
    end;
  end
  else
  begin
    TAction(Sender).Enabled := false;
  end;
end;

// ------------------------------------------------------------------------------------
end.
