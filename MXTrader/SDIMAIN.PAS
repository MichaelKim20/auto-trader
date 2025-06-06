unit SDIMAIN;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Messages, ComCtrls, ImgList, StdActns,
  ActnList, ToolWin, FNSocketManager, FNDataSet, AgentGlobalVariable,
  FNReceiveSensor, FNBlockContentFrame, FNBlockItemControl, FNTradeSystem,
  FNDefine,
  FNMatrixManageChartFrame, System.Actions;

type
  TMainForm = class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ActionList1: TActionList;
    ActionAddBlock: TAction;
    Action_Exit: TAction;
    ActionDeleteBlock: TAction;
    Action_3001: TAction;
    Action_3002: TAction;
    Action_Load: TAction;
    Action_Save: TAction;
    Action_3003: TAction;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    StatusBar: TStatusBar;
    PanelWorkSpace: TPanel;
    Splitter1: TSplitter;
    TimerDisplay: TTimer;
    ImageListDisable: TImageList;
    ImageListHot: TImageList;
    ImageListNormal: TImageList;
    ActionStartBlock: TAction;
    ActionStopBlock: TAction;
    Action_Close: TAction;
    ToolButton15: TToolButton;
    PanelRight: TPanel;
    Splitter2: TSplitter;
    PanelBottom: TPanel;
    PageControlLog: TPageControl;
    TabSheet3: TTabSheet;
    Panel3: TPanel;
    ListViewLog: TListView;
    TimerBolckUpdate: TTimer;
    PanelTop: TPanel;
    PanelLeft: TPanel;
    ActionNextBlock: TAction;
    TimerAutoRun: TTimer;
    PageControlSummary: TPageControl;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel2: TPanel;
    Panel5: TPanel;
    ListViewBlockItem: TListView;
    ToolBar2: TToolBar;
    ToolButton21: TToolButton;
    ToolButton12: TToolButton;
    ToolButton22: TToolButton;
    Panel8: TPanel;
    Panel30: TPanel;
    Panel10: TPanel;
    GridPanel2: TGridPanel;
    Panel7: TPanel;
    PanelODate2: TPanel;
    Panel11: TPanel;
    PanelOTime2: TPanel;
    Panel13: TPanel;
    PanelOQuote2: TPanel;
    Panel9: TPanel;
    SPositionGap: TPanel;
    GridPanel4: TGridPanel;
    Panel18: TPanel;
    Panel31: TPanel;
    Panel40: TPanel;
    PanelSDate: TPanel;
    PanelSTime: TPanel;
    PanelSQuote: TPanel;
    GridPanel1: TGridPanel;
    Panel12: TPanel;
    Panel43: TPanel;
    Panel47: TPanel;
    PanelODate: TPanel;
    PanelOTime: TPanel;
    PanelOQuote: TPanel;
    ActionChangeStandDate: TAction;
    ActionNextDate: TAction;
    ToolButton3: TToolButton;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    Panel29: TPanel;
    ToolButton10: TToolButton;
    ActionPrevDate: TAction;
    Action_Add: TAction;
    ToolButton14: TToolButton;
    Panel15: TPanel;
    ActionExitCurrentSignal: TAction;
    ReceiveSensor: CFNReceiveSensor;
    Panel27: TPanel;
    SProfitValue3: TPanel;
    Panel25: TPanel;
    SProfitValue2: TPanel;
    Panel45: TPanel;
    SSystemPosition: TPanel;
    Panel46: TPanel;
    STradePosition: TPanel;
    Panel24: TPanel;
    PanelSProfitValue2: TPanel;
    Panel20: TPanel;
    PanelSPosition: TPanel;
    Panel26: TPanel;
    PanelSTradeCount: TPanel;
    Panel28: TPanel;
    PanelSBuyPosition: TPanel;
    Panel44: TPanel;
    PanelSSellPosition: TPanel;
    Panel4: TPanel;
    Panel17: TPanel;
    PanelOProfitValue: TPanel;
    Panel33: TPanel;
    PanelOPosition: TPanel;
    Panel35: TPanel;
    PanelOTradeCount: TPanel;
    Panel37: TPanel;
    PanelOBuyPosition: TPanel;
    Panel39: TPanel;
    PanelOSellPosition: TPanel;
    ToolButton8: TToolButton;
    Action_GoSite: TAction;
    BlockContentFrame1: TBlockContentFrame;
    ToolButton13: TToolButton;
    ToolButton19: TToolButton;
    Action_3004: TAction;
    Action_3005: TAction;
    Panel6: TPanel;
    LabelBlockName: TLabel;
    ToolButton11: TToolButton;
    ToolButton16: TToolButton;
    procedure StatusBarResize(Sender: TObject);
    procedure TimerDisplayTimer(Sender: TObject);
    procedure Action_ExitExecute(Sender: TObject);
    procedure Action_LoadExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Action_LoadUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActionDeleteBlockUpdate(Sender: TObject);
    procedure ActionStopBlockUpdate(Sender: TObject);
    procedure ActionStartBlockUpdate(Sender: TObject);
    procedure ActionStartBlockExecute(Sender: TObject);
    procedure ActionStopBlockExecute(Sender: TObject);
    procedure ActionDeleteBlockExecute(Sender: TObject);
    procedure ActionAddBlockExecute(Sender: TObject);
    procedure Action_3001Update(Sender: TObject);
    procedure Action_3001Execute(Sender: TObject);
    procedure Action_3002Execute(Sender: TObject);
    procedure Action_3002Update(Sender: TObject);
    procedure Action_3003Execute(Sender: TObject);
    procedure Action_SaveExecute(Sender: TObject);
    procedure Action_CloseExecute(Sender: TObject);
    procedure Action_SaveUpdate(Sender: TObject);
    procedure Action_CloseUpdate(Sender: TObject);
    procedure Action_3003Update(Sender: TObject);
    procedure ListViewLogData(Sender: TObject; Item: TListItem);
    procedure ListViewLogCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewLogCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure OnOPSDisconnect(Sender: TObject);
    procedure OnSecDisconnect(Sender: TObject);
    procedure ListViewBlockItemData(Sender: TObject; Item: TListItem);
    procedure ListViewBlockItemSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ListViewBlockItemCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewBlockItemCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);

    procedure ActionNextBlockExecute(Sender: TObject);
    procedure TimerAutoRunTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ActionAddBlockUpdate(Sender: TObject);
    procedure ActionChangeStandDateExecute(Sender: TObject);
    procedure ActionNextDateExecute(Sender: TObject);
    procedure ActionChangeStandDateUpdate(Sender: TObject);
    procedure ActionNextDateUpdate(Sender: TObject);
    procedure ActionPrevDateExecute(Sender: TObject);
    procedure ActionPrevDateUpdate(Sender: TObject);
    procedure Action_AddExecute(Sender: TObject);
    procedure Action_AddUpdate(Sender: TObject);
    procedure ActionExitCurrentSignalUpdate(Sender: TObject);
    procedure ActionExitCurrentSignalExecute(Sender: TObject);
    procedure Action_GoSiteExecute(Sender: TObject);
    procedure ToolButtonMakeSendSignalNameClick(Sender: TObject);
    procedure Action_3004Execute(Sender: TObject);
    procedure Action_3004Update(Sender: TObject);

  private
    procedure OnSocketEvent(p_Event: Integer);
    procedure WMSocketEvent(var Message: TMessage); message WM_SOCKET_EVENT;

  private
    function IsAllStop: Boolean;
    function IsAllStart: Boolean;
    function IsExistBlockViewItem: Boolean;

  private
    procedure SaveMainWindow();
    procedure RestoreMainWindow();

  private
    m_Opened: Boolean;
    m_CondtionFileName: String;
    m_SecReConnecting: Boolean;

    procedure LoadFromFile(AFileName: String);
    procedure SaveToFile(AFileName: String);
    procedure AddFromFile(AFileName: String);

  private
    m_SelectedBlockItemControlIndex: Integer;
    m_SelectedBlockItemControl: TBlockItemControl;
    m_BlockViewCollection: TBlockItemControlCollection;

    procedure ClearListBlockItem;
    procedure DisplayListBlockItem;
    procedure DetachBlockContentFrame;

  private
    m_LogCollection: CFNLogCollection;

    procedure ClearLogInfo;
    procedure DisplayLogInfo;
    procedure OnLogEvent(ASender: TObject; ADateTime: TDateTime; AType: Integer; AMessage, AClassName: String);
    procedure OnUpdateEvent(Sender: TObject);
    procedure ClearSummaryInfo;

  protected

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  IniFiles, XMLIntf, xmldom, msxmldom, XMLDoc, IdHTTP, IdMultipartFormData,
  IdURI,
  FNRegistry, FNGlobalVariable, FNCMVariable, MXVariable, MXBlock,
  MXOrderManager,
  FNGlobal, Math, MXOption, FNPOTCollection, DateUtils, FNReLoginDlg,
  FNMatrixReConnectDlg,
  FNChangeStandDateDlg, FNMaterialCollection, UrlMon,
  TradeListUnit, FNAccountPWDlg;

{$R *.dfm}
{$REGION 'Form 이벤트'}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  OPDATA_COLLECTION_URL := 'http://210.116.104.82/OP/Collect.aspx';
  STATIONDATA_COLLECTION_URL := 'http://210.116.104.82/OP/Station.aspx';

  m_SecReConnecting := false;

  PageControlSummary.ActivePageIndex := 0;
  PanelBottom.Height := 1;

  m_SelectedBlockItemControl := NIL;
  m_SelectedBlockItemControlIndex := -1;

  m_BlockViewCollection := TBlockItemControlCollection.Create;
  m_LogCollection := CFNLogCollection.Create;
  m_Opened := false;

  if g_AutoRun then
  begin
    Caption := g_ApplicationName + ' - ' + g_AutoRunConfig.m_MainWindowTitle;
    Application.Title := g_AutoRunConfig.m_MainWindowTitle + ' - ' + g_ApplicationName;
  end
  else
  begin
    Caption := g_ApplicationName;
    Application.Title := g_ApplicationName;
  end;

  BlockContentFrame1.OnFormCreate;
  BlockContentFrame1.MatrixSumaryOptionFrame1.AttachCondition(m_BlockViewCollection.SummaryOption);

  RestoreMainWindow();

  ReceiveSensor.Start;

  g_AgentManager.OnDisconnect := OnSecDisconnect;
  if g_UseStreamData and Assigned(g_SocketManager) then
  begin
    g_SocketManager.OnSocketEvent := OnSocketEvent;
  end;

  TimerAutoRun.Enabled := g_AutoRun;

  StatusBar.Panels[1].Text := g_Version + ' ' + g_BuilderDate;
  StatusBar.Panels[2].Text := g_MatrixUserID + ' / ' + g_SecUserID;

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TimerBolckUpdate.Enabled := false;

  SaveMainWindow();
  ReceiveSensor.Stop;
  BlockContentFrame1.OnFormClose;

  if Assigned(m_BlockViewCollection) then
  begin
    m_BlockViewCollection.RemoveAll;
    m_BlockViewCollection.Free;
    m_BlockViewCollection := NIL;
  end;
  if Assigned(m_LogCollection) then
  begin
    m_LogCollection.Free;
    m_LogCollection := NIL;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if IsAllStop then
  begin
    CanClose := true;
  end
  else
  begin
    CanClose := false;
    Dialogs.MessageDlg('시스템이 가동 중입니다. "전체매매종료"를 한 후 프로그램을 종료해 주십시오.', mtInformation, [mbOk], 0, mbOk);
  end;
end;

{$ENDREGION}
{$REGION 'Action 이벤트'}

// ------------------------------------------------------------------------------------
procedure TMainForm.ToolButtonMakeSendSignalNameClick(Sender: TObject);
begin
end;

{$REGION 'Action_Load'}

// ------------------------------------------------------------------------------------
procedure TMainForm.Action_LoadExecute(Sender: TObject);
begin
  if IsAllStop then
  begin
    if not IsExistBlockViewItem then
    begin
      if OpenDialog.FileName = '' then
        OpenDialog.FileName := '*.xml';
      if OpenDialog.Execute then
      begin
        if ExtractFileExt(OpenDialog.FileName) = '' then
        begin
          OpenDialog.FileName := OpenDialog.FileName + '.xml';
        end;

        DetachBlockContentFrame;
        BlockContentFrame1.BlockItemControl := NIL;

        m_SelectedBlockItemControl := NIL;
        m_SelectedBlockItemControlIndex := -1;

        LoadFromFile(OpenDialog.FileName);

        if m_BlockViewCollection.m_Items.Count > 0 then
        begin
          m_SelectedBlockItemControl := m_BlockViewCollection.m_Items[0];
          m_SelectedBlockItemControlIndex := 0;
          m_SelectedBlockItemControl.BlockContentFrame := BlockContentFrame1;
        end;
        LabelBlockName.Caption := 'Block Item : ' + '';

        DisplayListBlockItem;
        BlockContentFrame1.MatrixSumaryOptionFrame1.SetOption;

        ClearSummaryInfo;

        m_Opened := true;
        m_CondtionFileName := ExtractFileName(OpenDialog.FileName);

        if g_AutoRunConfig.m_MainWindowTitle <> '' then
        begin
          Caption := g_ApplicationName + ' - ' + g_AutoRunConfig.m_MainWindowTitle + ' [' + m_CondtionFileName + ']';
          Application.Title := g_AutoRunConfig.m_MainWindowTitle + ' - ' + g_ApplicationName + ' [' + m_CondtionFileName + ']';
        end
        else
        begin
          Caption := g_ApplicationName + ' [' + m_CondtionFileName + ']';
          Application.Title := g_ApplicationName + ' [' + m_CondtionFileName + ']';
        end;
      end;
    end
    else
    begin
      Dialogs.MessageDlg('여러개의 매매블럭이 동시에 새롭게 열리기 때문에 지금 열려진 블럭은 닫고 실행하여야 새로운 블럭을 일제히 열었을 때 혼란을 피할 수 있습니다.', mtInformation, [mbOk], 0, mbOk);
    end;
  end
  else
  begin
    Dialogs.MessageDlg('시스템이 가동 중입니다. "전체매매종료"를 한 후 사용하세요 ', mtInformation, [mbOk], 0, mbOk);
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMainForm.Action_LoadUpdate(Sender: TObject);
begin
  if not m_Opened then
    Action_Load.Enabled := true
  else
    Action_Load.Enabled := false;
end;
{$ENDREGION}
{$REGION 'Action_Add'}

procedure TMainForm.Action_AddExecute(Sender: TObject);
begin
  if IsAllStop then
  begin
    if OpenDialog.FileName = '' then
      OpenDialog.FileName := '*.xml';
    if OpenDialog.Execute then
    begin
      if ExtractFileExt(OpenDialog.FileName) = '' then
      begin
        OpenDialog.FileName := OpenDialog.FileName + '.xml';
      end;

      DetachBlockContentFrame;
      BlockContentFrame1.BlockItemControl := NIL;

      m_SelectedBlockItemControl := NIL;
      m_SelectedBlockItemControlIndex := -1;

      AddFromFile(OpenDialog.FileName);

      if m_BlockViewCollection.m_Items.Count > 0 then
      begin
        m_SelectedBlockItemControl := m_BlockViewCollection.m_Items[0];
        m_SelectedBlockItemControlIndex := 0;
        m_SelectedBlockItemControl.BlockContentFrame := BlockContentFrame1;
      end;
      LabelBlockName.Caption := '매매블럭명 : ' + '';

      DisplayListBlockItem;
      BlockContentFrame1.MatrixSumaryOptionFrame1.SetOption;
      ClearSummaryInfo;

      m_Opened := true;
      m_CondtionFileName := ExtractFileName(OpenDialog.FileName);

      if g_AutoRunConfig.m_MainWindowTitle <> '' then
      begin
        Caption := g_ApplicationName + ' - ' + g_AutoRunConfig.m_MainWindowTitle + ' [' + m_CondtionFileName + ']';
        Application.Title := g_AutoRunConfig.m_MainWindowTitle + ' - ' + g_ApplicationName + ' [' + m_CondtionFileName + ']';
      end
      else
      begin
        Caption := g_ApplicationName + ' [' + m_CondtionFileName + ']';
        Application.Title := g_ApplicationName + ' [' + m_CondtionFileName + ']';
      end;
    end;
  end
  else
  begin
    Dialogs.MessageDlg('시스템이 가동 중입니다. "전체매매종료"를 한 후 사용하세요 ', mtInformation, [mbOk], 0, mbOk);
  end;

end;

// ------------------------------------------------------------------------------------
procedure TMainForm.Action_AddUpdate(Sender: TObject);
begin
  if m_Opened and IsAllStop then
    Action_Add.Enabled := true
  else
    Action_Add.Enabled := false;
end;
{$ENDREGION}
{$REGION 'Action_Save'}

// ------------------------------------------------------------------------------------
procedure TMainForm.Action_SaveExecute(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    if ExtractFileExt(SaveDialog.FileName) = '' then
    begin
      SaveDialog.FileName := SaveDialog.FileName + '.xml';
    end;

    BlockContentFrame1.MatrixSumaryOptionFrame1.GetOption;

    SaveToFile(SaveDialog.FileName);

    m_Opened := true;
    m_CondtionFileName := ExtractFileName(SaveDialog.FileName);

    if g_AutoRunConfig.m_MainWindowTitle <> '' then
    begin
      Caption := g_ApplicationName + ' - ' + g_AutoRunConfig.m_MainWindowTitle + ' [' + m_CondtionFileName + ']';
      Application.Title := g_AutoRunConfig.m_MainWindowTitle + ' - ' + g_ApplicationName + ' [' + m_CondtionFileName + ']';
    end
    else
    begin
      Caption := g_ApplicationName + ' [' + m_CondtionFileName + ']';
      Application.Title := g_ApplicationName + ' [' + m_CondtionFileName + ']';
    end;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMainForm.Action_SaveUpdate(Sender: TObject);
begin
  if (m_Opened) or (m_BlockViewCollection.m_Items.Count > 0) then
    Action_Save.Enabled := true
  else
    Action_Save.Enabled := false;
end;
{$ENDREGION}
{$REGION 'Action_Close 매매조건닫기'}

// ------------------------------------------------------------------------------------
procedure TMainForm.Action_CloseExecute(Sender: TObject);
begin
  if IsAllStop then
  begin
    m_LogCollection.Clear;
    DisplayLogInfo;

    DetachBlockContentFrame;
    BlockContentFrame1.BlockItemControl := NIL;

    m_BlockViewCollection.RemoveAll;

    m_SelectedBlockItemControl := NIL;
    m_SelectedBlockItemControlIndex := -1;

    DisplayListBlockItem;
    ClearSummaryInfo;
    LabelBlockName.Caption := '매매블럭명 : ' + '';

    m_Opened := false;
    m_CondtionFileName := '';
    Caption := g_ApplicationName;
  end
  else
  begin
    Dialogs.MessageDlg('지금 실행되고 있는 매매의 안전한 종료를 위해, 일단은 모든 매매시스템을 종료 한 후에 다시 실행하여 주세요.', mtInformation, [mbOk], 0, mbOk);
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMainForm.Action_CloseUpdate(Sender: TObject);
begin
  if (m_Opened) or (m_BlockViewCollection.m_Items.Count > 0) then
    Action_Close.Enabled := true
  else
    Action_Close.Enabled := false;
end;

{$ENDREGION}
{$REGION 'Action_3001 전체 매매시작'}

procedure TMainForm.Action_3001Execute(Sender: TObject);
var
  f_ControlIndex: Integer;
  f_BlockItemView: TBlockItemControl;
begin
  ClearSummaryInfo;

  BlockContentFrame1.MatrixSumaryOptionFrame1.GetOption;
  BlockContentFrame1.MatrixOptionFrame1.GetOption;
  m_BlockViewCollection.Prepare;

  m_BlockViewCollection.SummaryOption.SetIntegerValue ('SYSTEM_MODE', 0);


  BlockContentFrame1.MatrixSumaryOptionFrame1.SetOption;
  BlockContentFrame1.MatrixOptionFrame1.SetOption;

  for f_ControlIndex := 0 to m_BlockViewCollection.m_Items.Count - 1 do
  begin
    f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[f_ControlIndex]);
    f_BlockItemView.ActionStart;
  end;
  BlockContentFrame1.MatrixSumaryOptionFrame1.GetOption;
  BlockContentFrame1.MatrixSumaryOptionFrame1.SetEnable(false);
end;

procedure TMainForm.Action_3001Update(Sender: TObject);
begin
  if IsExistBlockViewItem then
  begin
    if IsAllStart then
    begin
      Action_3001.Enabled := false;
    end
    else
    begin
      Action_3001.Enabled := true;
    end;
  end
  else
  begin
    Action_3001.Enabled := false;
  end;
end;

{$ENDREGION}
{$REGION 'Action_3002 전체 매매종료'}

procedure TMainForm.Action_3002Execute(Sender: TObject);
var
  f_ControlIndex: Integer;
  f_BlockItemView: TBlockItemControl;
begin
  if (Dialogs.MessageDlg('시스템이 가동 중입니다. 정말로 매매를 중지하시겠습니까?', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes) then
  begin
    for f_ControlIndex := 0 to m_BlockViewCollection.m_Items.Count - 1 do
    begin
      f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[f_ControlIndex]);
      f_BlockItemView.ActionStop;
    end;

    BlockContentFrame1.MatrixSumaryOptionFrame1.SetEnable(true);
  end;
end;

procedure TMainForm.Action_3002Update(Sender: TObject);
begin
  if IsExistBlockViewItem then
  begin
    if IsAllStop then
    begin
      Action_3002.Enabled := false;
    end
    else
    begin
      Action_3002.Enabled := true;
    end;
  end
  else
  begin
    Action_3002.Enabled := false;
  end;
end;
{$ENDREGION}
{$REGION 'Action_3003 전체 매매결과저장'}

procedure TMainForm.Action_3003Execute(Sender: TObject);
var
  f_ControlIndex: Integer;
  f_BlockItemView: TBlockItemControl;
  f_TradeData: String;
  f_TradeListDlg: TTradeListDlg;
begin
  f_TradeData := '';
  for f_ControlIndex := 0 to m_BlockViewCollection.m_Items.Count - 1 do
  begin
    f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[f_ControlIndex]);
    f_TradeData := f_TradeData + f_BlockItemView.GetTradeList;
  end;

  f_TradeListDlg := TTradeListDlg.Create(Application);

  f_TradeListDlg.Memo1.Lines.Add(f_TradeData);
  f_TradeListDlg.ShowModal();

  f_TradeListDlg.Free;
end;

procedure TMainForm.Action_3003Update(Sender: TObject);
begin
  if m_Opened then
    Action_3003.Enabled := true
  else
    Action_3003.Enabled := false;
end;

procedure TMainForm.Action_3004Execute(Sender: TObject);
var
  NO, PW: String;
  f_ControlIndex: Integer;
  f_BlockItemView: TBlockItemControl;
begin
  AccountPWDlg := TAccountPWDlg.Create(Self);

  if (AccountPWDlg.ShowModal = mrOK) then
  begin
    NO := AccountPWDlg.ComboBoxACCOUNT_NO.Text;
    PW := AccountPWDlg.Password.Text;

    for f_ControlIndex := 0 to m_BlockViewCollection.m_Items.Count - 1 do
    begin
      f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[f_ControlIndex]);

      if (f_BlockItemView.BlockContentFrame <> NIL) then
        f_BlockItemView.BlockContentFrame.MatrixOptionFrame1.GetOption;
      f_BlockItemView.Block.Option.SetStringValue('ACCOUNT_NO', NO);
      f_BlockItemView.Block.Option.SetStringValue('ACCOUNT_PW', PW);
      f_BlockItemView.Block.Option.SetIntegerValue('SYSTEM_MODE', SYSTEM_MODE_REAL);
      if (f_BlockItemView.BlockContentFrame <> NIL) then
        f_BlockItemView.BlockContentFrame.MatrixOptionFrame1.SetOption;
    end;
  end;

  AccountPWDlg.Free;
end;

procedure TMainForm.Action_3004Update(Sender: TObject);
begin
  if IsExistBlockViewItem then
  begin
    if IsAllStart then
    begin
      Action_3004.Enabled := false;
    end
    else
    begin
      Action_3004.Enabled := true;
    end;
  end
  else
  begin
    Action_3004.Enabled := false;
  end;
end;

{$ENDREGION}
{$REGION 'ActionAddBlock'}

procedure TMainForm.ActionAddBlockExecute(Sender: TObject);
var
  f_BlockItemView: TBlockItemControl;
  f_ControlIndex: Integer;
begin
  f_BlockItemView := TBlockItemControl.Create;
  m_BlockViewCollection.Add(f_BlockItemView);

  f_BlockItemView.OnLog := OnLogEvent;
  f_BlockItemView.OnUpdate := OnUpdateEvent;

  m_BlockViewCollection.Sort;

  m_SelectedBlockItemControlIndex := m_BlockViewCollection.m_Items.IndexOf(f_BlockItemView);
  m_SelectedBlockItemControl := TBlockItemControl(m_BlockViewCollection.m_Items[m_SelectedBlockItemControlIndex]);
  m_SelectedBlockItemControl.BlockContentFrame := BlockContentFrame1;

  DisplayListBlockItem;

  if not m_Opened then
    m_Opened := true;

end;

procedure TMainForm.ActionAddBlockUpdate(Sender: TObject);
begin
  if IsAllStop then
  begin
    ActionAddBlock.Enabled := true
  end
  else
  begin
    ActionAddBlock.Enabled := false
  end;
end;

procedure TMainForm.ActionChangeStandDateExecute(Sender: TObject);
var
  f_ControlIndex: Integer;
  f_BlockItemView: TBlockItemControl;
  f_OpenDateTime: TDateTime;
  f_CloseDateTime: TDateTime;
  f_ModalResult: Integer;
begin

  ChangeStandDateDlg := TChangeStandDateDlg.Create(Application);
  f_ModalResult := ChangeStandDateDlg.ShowModal;

  if ((f_ModalResult = mrOK) OR (f_ModalResult = mrYes)) then
  begin
    for f_ControlIndex := 0 to m_BlockViewCollection.m_Items.Count - 1 do
    begin
      f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[f_ControlIndex]);
      f_BlockItemView.Block.Option.SetBooleanValue('USE_STAND_DATE', true);
      f_BlockItemView.Block.Option.SetIntegerValue('SYSTEM_MODE', SYSTEM_MODE_SIMULATION);
      f_BlockItemView.Block.Option.SetIntegerValue('HISTORY_DATE', Trunc(ChangeStandDateDlg.MonthCalendar.Date));
      f_BlockItemView.Block.Option.SetIntegerValue('STAND_DATE', Trunc(ChangeStandDateDlg.MonthCalendar.Date));

      if (f_BlockItemView = m_SelectedBlockItemControl) then
      begin
        BlockContentFrame1.MatrixOptionFrame1.SetOption;
      end;
    end;
  end;
  ChangeStandDateDlg.Free;
  ChangeStandDateDlg := NIL;

  PageControlSummary.ActivePageIndex := 1;

  if (f_ModalResult = mrYes) then
  begin
    Action_3001Execute(Self);
  end;
end;

procedure TMainForm.ActionChangeStandDateUpdate(Sender: TObject);
begin
  if IsExistBlockViewItem then
  begin
    if IsAllStop then
    begin
      ActionChangeStandDate.Enabled := true;
    end
    else
    begin
      ActionChangeStandDate.Enabled := false;
    end;
  end
  else
  begin
    ActionChangeStandDate.Enabled := false;
  end;
end;

procedure TMainForm.ActionNextDateExecute(Sender: TObject);
var
  f_ControlIndex: Integer;
  f_BlockItemView: TBlockItemControl;
  f_OpenDateTime: TDateTime;
  f_CloseDateTime: TDateTime;
  f_StandDate: TDateTime;
begin
  if m_BlockViewCollection.m_Items.Count <= 0 then
    exit;

  f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[0]);

  f_StandDate := f_BlockItemView.Block.Option.GetIntegerValue('STAND_DATE');

  f_StandDate := f_StandDate + 1;

  if (DayOfWeek(f_StandDate) = 7) then
    f_StandDate := f_StandDate + 1;
  if (DayOfWeek(f_StandDate) = 1) then
    f_StandDate := f_StandDate + 1;

  for f_ControlIndex := 0 to m_BlockViewCollection.m_Items.Count - 1 do
  begin
    f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[f_ControlIndex]);
    f_BlockItemView.Block.Option.SetBooleanValue('USE_STAND_DATE', true);
    f_BlockItemView.Block.Option.SetIntegerValue('SYSTEM_MODE', SYSTEM_MODE_SIMULATION);
    f_BlockItemView.Block.Option.SetIntegerValue('HISTORY_DATE', Trunc(f_StandDate));
    f_BlockItemView.Block.Option.SetIntegerValue('STAND_DATE', Trunc(f_StandDate));

    if (f_BlockItemView = m_SelectedBlockItemControl) then
    begin
      BlockContentFrame1.MatrixOptionFrame1.SetOption;
    end;
  end;

  Action_3001Execute(Self);

end;

procedure TMainForm.ActionNextDateUpdate(Sender: TObject);
begin
  if IsExistBlockViewItem then
  begin
    if IsAllStop then
    begin
      ActionNextDate.Enabled := true;
    end
    else
    begin
      ActionNextDate.Enabled := false;
    end;
  end
  else
  begin
    ActionNextDate.Enabled := false;
  end;
end;

procedure TMainForm.ActionPrevDateExecute(Sender: TObject);
var
  f_ControlIndex: Integer;
  f_BlockItemView: TBlockItemControl;
  f_OpenDateTime: TDateTime;
  f_CloseDateTime: TDateTime;
  f_StandDate: TDateTime;
begin
  if m_BlockViewCollection.m_Items.Count <= 0 then
    exit;

  f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[0]);

  f_StandDate := f_BlockItemView.Block.Option.GetIntegerValue('STAND_DATE');

  f_StandDate := f_StandDate - 1;

  if (DayOfWeek(f_StandDate) = 1) then
    f_StandDate := f_StandDate - 1;
  if (DayOfWeek(f_StandDate) = 7) then
    f_StandDate := f_StandDate - 1;

  for f_ControlIndex := 0 to m_BlockViewCollection.m_Items.Count - 1 do
  begin
    f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[f_ControlIndex]);
    f_BlockItemView.Block.Option.SetBooleanValue('USE_STAND_DATE', true);
    f_BlockItemView.Block.Option.SetIntegerValue('SYSTEM_MODE', SYSTEM_MODE_SIMULATION);
    f_BlockItemView.Block.Option.SetIntegerValue('HISTORY_DATE', Trunc(f_StandDate));
    f_BlockItemView.Block.Option.SetIntegerValue('STAND_DATE', Trunc(f_StandDate));

    if (f_BlockItemView = m_SelectedBlockItemControl) then
    begin
      BlockContentFrame1.MatrixOptionFrame1.SetOption;
    end;
  end;

  Action_3001Execute(Self);

end;

procedure TMainForm.ActionPrevDateUpdate(Sender: TObject);
begin
  if IsExistBlockViewItem then
  begin
    if IsAllStop then
    begin
      ActionPrevDate.Enabled := true;
    end
    else
    begin
      ActionPrevDate.Enabled := false;
    end;
  end
  else
  begin
    ActionPrevDate.Enabled := false;
  end;
end;

{$ENDREGION}
{$REGION 'ActionDeleteBlock'}

// ------------------------------------------------------------------------------------
procedure TMainForm.ActionDeleteBlockExecute(Sender: TObject);
var
  f_CanDelete: Boolean;
  f_ControlIndex: Integer;
  f_BlockItemView: TBlockItemControl;
begin
  if Assigned(m_SelectedBlockItemControl) then
  begin
    if (m_SelectedBlockItemControl.Block.OrderManager.State <> PROCESS_STATE_ENDED_WORK) then
    begin
      Dialogs.MessageDlg('시스템이 가동 중입니다. "전체매매종료"를 한 후 프로그램을 종료해 주십시오.', mtInformation, [mbOk], 0, mbOk);
      f_CanDelete := false;
    end
    else
    begin
      f_CanDelete := true;
    end;

    if (f_CanDelete) then
    begin
      m_SelectedBlockItemControlIndex := m_BlockViewCollection.m_Items.IndexOf(m_SelectedBlockItemControl);

      DetachBlockContentFrame;
      BlockContentFrame1.BlockItemControl := NIL;

      m_BlockViewCollection.Delete(m_SelectedBlockItemControl);

      if m_SelectedBlockItemControlIndex >= m_BlockViewCollection.m_Items.Count then
      begin
        m_SelectedBlockItemControlIndex := m_SelectedBlockItemControlIndex - 1;
      end;

      if m_SelectedBlockItemControlIndex >= 0 then
      begin
        m_SelectedBlockItemControl := TBlockItemControl(m_BlockViewCollection.m_Items[m_SelectedBlockItemControlIndex]);
        m_SelectedBlockItemControl.BlockContentFrame := BlockContentFrame1;
      end
      else
      begin
        m_SelectedBlockItemControl := NIL;
      end;

      DisplayListBlockItem;

    end;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMainForm.ActionDeleteBlockUpdate(Sender: TObject);
begin
  if Assigned(m_SelectedBlockItemControl) then
  begin
    if IsAllStop then
    begin
      ActionDeleteBlock.Enabled := true
    end
    else
    begin
      ActionDeleteBlock.Enabled := false
    end;
  end
  else
  begin
    ActionDeleteBlock.Enabled := false;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMainForm.ActionNextBlockExecute(Sender: TObject);
begin
  if (m_BlockViewCollection.m_Items.Count > 0) then
  begin
    if m_SelectedBlockItemControl = NIL then
    begin
      m_SelectedBlockItemControl := m_BlockViewCollection.m_Items[0];
      m_SelectedBlockItemControlIndex := 0;
    end
    else
    begin
      m_SelectedBlockItemControlIndex := m_BlockViewCollection.m_Items.IndexOf(m_SelectedBlockItemControl);
      Inc(m_SelectedBlockItemControlIndex);

      if m_SelectedBlockItemControlIndex >= m_BlockViewCollection.m_Items.Count then
      begin
        m_SelectedBlockItemControlIndex := 0;
      end;

      if m_SelectedBlockItemControlIndex < m_BlockViewCollection.m_Items.Count then
      begin
        m_SelectedBlockItemControl := m_BlockViewCollection.m_Items[m_SelectedBlockItemControlIndex];
      end
      else
      begin
        m_SelectedBlockItemControl := NIL;
      end;

      if Assigned(m_SelectedBlockItemControl) then
      begin

        ListViewBlockItem.ItemIndex := m_SelectedBlockItemControlIndex;
        ListViewBlockItem.SetFocus;
        ListViewBlockItem.Repaint;

        DetachBlockContentFrame;
        m_SelectedBlockItemControl.BlockContentFrame := BlockContentFrame1;

      end;

    end;

  end;
end;

{$ENDREGION}
{$REGION 'ActionStartBlock'}

// ------------------------------------------------------------------------------------
procedure TMainForm.ActionStartBlockExecute(Sender: TObject);
begin
  if Assigned(m_SelectedBlockItemControl) then
  begin
    m_SelectedBlockItemControl.ActionStart;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMainForm.ActionStartBlockUpdate(Sender: TObject);
begin

  if Assigned(m_SelectedBlockItemControl) then
  begin
    if m_SelectedBlockItemControl.ActionCanStart then
    begin
      ActionStartBlock.Enabled := true;
    end
    else
    begin
      ActionStartBlock.Enabled := false;
    end;
  end
  else
  begin
    ActionStartBlock.Enabled := false;
  end;
end;
{$ENDREGION}
{$REGION 'ActionStopBlock'}

procedure TMainForm.ActionStopBlockExecute(Sender: TObject);
begin
  if Assigned(m_SelectedBlockItemControl) then
  begin
    m_SelectedBlockItemControl.DoLosscut;
  end;
end;

procedure TMainForm.ActionStopBlockUpdate(Sender: TObject);
begin
  if Assigned(m_SelectedBlockItemControl) then
  begin
    if m_SelectedBlockItemControl.ActionCanStop then
    begin
      ActionStopBlock.Enabled := true;
    end
    else
    begin
      ActionStopBlock.Enabled := false;
    end;
  end
  else
  begin
    ActionStopBlock.Enabled := false;
  end;
end;
{$ENDREGION}
{$REGION 'Action_Exit 프로그램 종료'}

procedure TMainForm.Action_ExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.Action_GoSiteExecute(Sender: TObject);
begin
  // TFNGlobal.GotoURL('http://210.116.104.82/SP/SP1000.aspx');
  HlinkNavigateString(nil, 'http://210.116.104.82/SP/SP1000.aspx');
end;

{$ENDREGION}
{$REGION 'ActionExitCurrentSignal'}

procedure TMainForm.ActionExitCurrentSignalExecute(Sender: TObject);
var
  f_ControlIndex: Integer;
  f_BlockItemView: TBlockItemControl;
begin
  for f_ControlIndex := 0 to m_BlockViewCollection.m_Items.Count - 1 do
  begin
    f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[f_ControlIndex]);
    f_BlockItemView.DoExitCurrentSignal;
  end;
end;

procedure TMainForm.ActionExitCurrentSignalUpdate(Sender: TObject);
begin
  if IsExistBlockViewItem then
  begin
    if IsAllStop then
    begin
      ActionExitCurrentSignal.Enabled := false;
    end
    else
    begin
      ActionExitCurrentSignal.Enabled := true;
    end;
  end
  else
  begin
    ActionExitCurrentSignal.Enabled := false;
  end;
end;
{$ENDREGION}
{$ENDREGION}
{$REGION 'BlockItem의 현재상태 파악'}

function TMainForm.IsAllStop: Boolean;
var
  f_BlockItemView: TBlockItemControl;
  f_ControlIndex: Integer;
begin
  Result := true;
  for f_ControlIndex := 0 to m_BlockViewCollection.m_Items.Count - 1 do
  begin
    f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[f_ControlIndex]);
    if (f_BlockItemView.m_State <> PROCESS_STATE_ENDED_WORK) then
    begin
      Result := false;
      break;
    end;
  end;
end;

function TMainForm.IsAllStart: Boolean;
var
  f_BlockItemView: TBlockItemControl;
  f_ControlIndex: Integer;
begin
  Result := true;
  for f_ControlIndex := 0 to m_BlockViewCollection.m_Items.Count - 1 do
  begin
    f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[f_ControlIndex]);
    if (f_BlockItemView.m_State <> PROCESS_STATE_DOING_WORK) then
    begin
      Result := false;
      break;
    end;
  end;
end;

function TMainForm.IsExistBlockViewItem: Boolean;
begin
  if m_BlockViewCollection.m_Items.Count > 0 then
  begin
    Result := true;
  end
  else
  begin
    Result := false;
  end;
end;
{$ENDREGION}
{$REGION '설정파일의 입출력'}

procedure TMainForm.LoadFromFile(AFileName: String);
var
  f_Stream: TStringStream;
  f_XMLDocument: TXMLDocument;
  f_XMLNode: IXMLNode;
  f_ChildNode: IXMLNode;
  f_Loop: Integer;
  f_BlockItemView: TBlockItemControl;
  f_ControlIndex: Integer;
begin
  m_BlockViewCollection.RemoveAll;

  f_Stream := TStringStream.Create('', TEncoding.UTF8, true);
  f_Stream.LoadFromFile(AFileName);
  f_Stream.Position := 0;

  f_XMLDocument := TXMLDocument.Create(Application);
  try
    f_XMLDocument.LoadFromXML(f_Stream.ReadString(f_Stream.Size));

    f_XMLNode := f_XMLDocument.DocumentElement;

    if AnsiCompareText('BlockCollection', f_XMLNode.NodeName) = 0 then
    begin
      for f_Loop := 0 to f_XMLNode.ChildNodes.Count - 1 do
      begin
        f_ChildNode := f_XMLNode.ChildNodes[f_Loop];
        if AnsiCompareText('BLOCK', f_ChildNode.NodeName) = 0 then
        begin
          f_BlockItemView := TBlockItemControl.Create;
          f_BlockItemView.Block.Read(f_ChildNode);

          if g_AutoRun and (g_AutoRunConfig.m_AccountNo <> '') then
          begin
            f_BlockItemView.Block.Option.SetStringValue('ACCOUNT_NO', g_AutoRunConfig.m_AccountNo);
            f_BlockItemView.Block.Option.SetStringValue('ACCOUNT_PW', g_AutoRunConfig.m_AccountPw);
          end;

          if g_AutoRun then
          begin
            if CompareText(g_AutoRunConfig.m_TradeMode, 'REAL') = 0 then
            begin
              f_BlockItemView.Block.Option.SetIntegerValue('SYSTEM_MODE', SYSTEM_MODE_REAL);
            end;
            if CompareText(g_AutoRunConfig.m_TradeMode, 'VT') = 0 then
            begin
              f_BlockItemView.Block.Option.SetIntegerValue('SYSTEM_MODE', SYSTEM_MODE_REAL);
            end;
          end;

          m_BlockViewCollection.Add(f_BlockItemView);
          f_BlockItemView.OnLog := OnLogEvent;
          f_BlockItemView.OnUpdate := OnUpdateEvent;

        end
        else if AnsiCompareText('Summary', f_ChildNode.NodeName) = 0 then
        begin
          m_BlockViewCollection.SummaryOption.Read(f_ChildNode);
        end;
      end;
    end;

    if g_AutoRun then
    begin
      TMXGlobal.SendEMail(g_AutoRunConfig.m_EMail, g_AutoRunConfig.m_MainWindowTitle, '[정보] 프로그램과 운용전략 자동시작을 정상적으로 처리하였습니다.');
    end;
  finally
    if Assigned(f_XMLDocument) then
      f_XMLDocument.Free;
    f_Stream.Free;
  end;

  m_BlockViewCollection.Sort;
end;

procedure TMainForm.AddFromFile(AFileName: String);
var
  f_Stream: TStringStream;
  f_XMLDocument: TXMLDocument;
  f_XMLNode: IXMLNode;
  f_ChildNode: IXMLNode;
  f_Loop: Integer;
  f_BlockItemView: TBlockItemControl;
  f_ControlIndex: Integer;
begin
  f_Stream := TStringStream.Create('', TEncoding.UTF8, true);
  f_Stream.LoadFromFile(AFileName);
  f_Stream.Position := 0;

  f_XMLDocument := TXMLDocument.Create(Application);
  try
    f_XMLDocument.LoadFromXML(f_Stream.ReadString(f_Stream.Size));
    f_XMLNode := f_XMLDocument.DocumentElement;
    if AnsiCompareText('BlockCollection', f_XMLNode.NodeName) = 0 then
    begin
      for f_Loop := 0 to f_XMLNode.ChildNodes.Count - 1 do
      begin
        f_ChildNode := f_XMLNode.ChildNodes[f_Loop];
        if AnsiCompareText('Block', f_ChildNode.NodeName) = 0 then
        begin
          f_BlockItemView := TBlockItemControl.Create;
          f_BlockItemView.Block.Read(f_ChildNode);

          if g_AutoRun and (g_AutoRunConfig.m_AccountNo <> '') then
          begin
            f_BlockItemView.Block.Option.SetStringValue('ACCOUNT_NO', g_AutoRunConfig.m_AccountNo);
            f_BlockItemView.Block.Option.SetStringValue('ACCOUNT_PW', g_AutoRunConfig.m_AccountPw);
          end;

          m_BlockViewCollection.Add(f_BlockItemView);
          f_BlockItemView.OnLog := OnLogEvent;
          f_BlockItemView.OnUpdate := OnUpdateEvent;

        end;
      end;
    end;

  finally
    if Assigned(f_XMLDocument) then
      f_XMLDocument.Free;
    f_Stream.Free;
  end;

  m_BlockViewCollection.Sort;
end;

procedure TMainForm.SaveToFile(AFileName: String);
var
  f_BlockItemView: TBlockItemControl;
  f_ControlIndex: Integer;
  f_Stream: TStringStream;
begin
  f_Stream := TStringStream.Create('', TEncoding.UTF8, true);
  f_Stream.WriteString('<BlockCollection>' + #$0A);

  for f_ControlIndex := 0 to m_BlockViewCollection.m_Items.Count - 1 do
  begin
    f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[f_ControlIndex]);
    f_BlockItemView.GetOption;
    f_Stream.WriteString(f_BlockItemView.Block.Write);
  end;
  f_Stream.WriteString(m_BlockViewCollection.SummaryOption.Write);
  f_Stream.WriteString('</BlockCollection>' + #$0A);
  f_Stream.SaveToFile(AFileName);
  f_Stream.Free;
end;

{$ENDREGION}
{$REGION 'BlockItemControl 표시'}

procedure TMainForm.ClearListBlockItem;
begin
  if not Assigned(m_BlockViewCollection) then
    exit;

  ListViewBlockItem.Items.Count := 0;
end;

procedure TMainForm.DetachBlockContentFrame;
var
  f_BlockItemView: TBlockItemControl;
  f_ControlIndex: Integer;
begin
  for f_ControlIndex := 0 to m_BlockViewCollection.m_Items.Count - 1 do
  begin
    f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[f_ControlIndex]);
    f_BlockItemView.BlockContentFrame := NIL;
  end;
end;

procedure TMainForm.DisplayListBlockItem;
begin
  if not Assigned(m_BlockViewCollection) then
    exit;

  try
    if m_SelectedBlockItemControl <> NIL then
    begin
      m_SelectedBlockItemControlIndex := m_BlockViewCollection.m_Items.IndexOf(m_SelectedBlockItemControl);
    end
    else
    begin
      m_SelectedBlockItemControlIndex := -1;
    end;

    ListViewBlockItem.Items.Count := m_BlockViewCollection.m_Items.Count;

    ListViewBlockItem.ItemIndex := m_SelectedBlockItemControlIndex;
    ListViewBlockItem.SetFocus;
    ListViewBlockItem.Repaint;

  except
  end;

end;

procedure TMainForm.ListViewBlockItemCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Index mod 2 = 0 then
  begin
    Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
  end
  else
  begin
    Sender.Canvas.Brush.Color := RGB($F0, $F0, $F0);
  end;
  DefaultDraw := true;
end;

procedure TMainForm.ListViewBlockItemCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f_BlockItemControl: TBlockItemControl;
  f_Signal: Integer;
begin
  if Item.Index mod 2 = 0 then
  begin
    Sender.Canvas.Brush.Color := RGB($FF, $FF, $FF);
  end
  else
  begin
    Sender.Canvas.Brush.Color := RGB($F0, $F0, $F0);
  end;
  try
    f_BlockItemControl := Item.Data;

    if (SubItem = 1) then
    begin
      f_Signal := f_BlockItemControl.m_SystemSignal;
      if (f_Signal = SIGNAL_BUY_ENTER) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_Signal = SIGNAL_SELL_ENTER) then
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $FF);
      end
      else
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $00);
      end;
    end
    else if (SubItem = 2) then
    begin
      f_Signal := f_BlockItemControl.m_OrderSignal;
      if (f_Signal = SIGNAL_BUY_ENTER) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_Signal = SIGNAL_SELL_ENTER) then
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $FF);
      end
      else
      begin
        Sender.Canvas.Font.Color := RGB($00, $00, $00);
      end;
    end
    else if (SubItem = 3) then
    begin
      if (f_BlockItemControl.m_SRealProfit > 0) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_BlockItemControl.m_SRealProfit < 0) then
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
      if (f_BlockItemControl.m_OProfit > 0) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_BlockItemControl.m_OProfit < 0) then
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
      if (f_BlockItemControl.m_SPosition > 0) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_BlockItemControl.m_SPosition < 0) then
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
      if (f_BlockItemControl.m_OPosition > 0) then
      begin
        Sender.Canvas.Font.Color := RGB($FF, $00, $00);
      end
      else if (f_BlockItemControl.m_OPosition < 0) then
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

  except
  end;
  DefaultDraw := true;
end;

procedure TMainForm.ListViewBlockItemData(Sender: TObject; Item: TListItem);
var
  f_ItemIndex: Integer;
  f_BlockItemControl: TBlockItemControl;
  f_NoTradeCount: Integer;
begin
  if not Assigned(m_BlockViewCollection) then
    exit;

  if ((Item.Index < 0) or (Item.Index >= m_BlockViewCollection.m_Items.Count)) then
    exit;
  f_ItemIndex := Item.Index;
  f_BlockItemControl := m_BlockViewCollection.m_Items[f_ItemIndex];
  Item.Caption := f_BlockItemControl.m_BlockName;

  Item.SubItems.Add(GetSimpleSignalText(f_BlockItemControl.m_SystemSignal));

  if f_BlockItemControl.m_OrderSignal <> SIGNAL_NONE then
  begin
    Item.SubItems.Add(GetSignalText(f_BlockItemControl.m_OrderSignal));
  end
  else
  begin
    Item.SubItems.Add('');
  end;

  Item.SubItems.Add(TFNGlobal.WriteNumber(f_BlockItemControl.m_SRealProfit_Currency, 2));
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_BlockItemControl.m_OProfit_Currency, 2));

  Item.SubItems.Add(TFNGlobal.WriteNumber(f_BlockItemControl.m_SPosition, 0));
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_BlockItemControl.m_OPosition, 0));
  f_NoTradeCount := abs(f_BlockItemControl.m_SPosition - f_BlockItemControl.m_OPosition);
  Item.SubItems.Add(TFNGlobal.WriteNumber(f_NoTradeCount, 0));

  Item.SubItems.Add(f_BlockItemControl.m_TradeSymbol);
  Item.SubItems.Add(f_BlockItemControl.m_AccountNo);

  if (f_BlockItemControl.m_State = PROCESS_STATE_ENDED_WORK) or (f_BlockItemControl.Block.SystemManager.IsLosscut) then
  begin
    Item.ImageIndex := 3;
  end
  else
  begin
    Item.ImageIndex := 2;
  end;

  Item.Data := f_BlockItemControl;

  if m_SelectedBlockItemControl = f_BlockItemControl then
  begin
    Item.Selected := true;
  end
  else
  begin
    Item.Selected := false;
  end;
end;

procedure TMainForm.ListViewBlockItemSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  f_BlockItemControl: TBlockItemControl;
begin
  if not Assigned(m_BlockViewCollection) then
    exit;
  if Selected then
  begin
    DetachBlockContentFrame;
    m_SelectedBlockItemControl := Item.Data;
    m_SelectedBlockItemControlIndex := m_BlockViewCollection.m_Items.IndexOf(m_SelectedBlockItemControl);
    m_SelectedBlockItemControl.BlockContentFrame := BlockContentFrame1;

    LabelBlockName.Caption := 'Block Item : ' + m_SelectedBlockItemControl.m_BlockName;
  end
  else
  begin
    if Assigned(Item) then
    begin
      f_BlockItemControl := Item.Data;
      if Assigned(f_BlockItemControl) then
      begin
        if (f_BlockItemControl.m_State = PROCESS_STATE_ENDED_WORK) then
        begin
          f_BlockItemControl.GetOption;
        end;
      end;
      LabelBlockName.Caption := 'Block Item : ' + '';
    end;
  end;
end;

procedure TMainForm.ClearSummaryInfo;
begin
  SProfitValue2.Caption := ' ';
  SProfitValue3.Caption := ' ';
  SSystemPosition.Caption := ' ';
  STradePosition.Caption := ' ';
  SPositionGap.Caption := ' ';
  PanelSDate.Caption := ' ';
  PanelSTime.Caption := ' ';
  PanelSQuote.Caption := ' ';

  PanelSProfitValue2.Caption := ' ';
  PanelSPosition.Caption := ' ';
  PanelSTradeCount.Caption := ' ';
  PanelSBuyPosition.Caption := ' ';
  PanelSSellPosition.Caption := ' ';
  PanelODate.Caption := ' ';
  PanelOTime.Caption := ' ';
  PanelODate2.Caption := ' ';
  PanelOTime2.Caption := ' ';

  PanelOProfitValue.Caption := ' ';
  PanelOPosition.Caption := ' ';
  PanelOTradeCount.Caption := ' ';
  PanelOBuyPosition.Caption := ' ';
  PanelOSellPosition.Caption := ' ';
end;

procedure TMainForm.OnUpdateEvent(Sender: TObject);
begin
  m_BlockViewCollection.Summary;

  SProfitValue3.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_SRealProfit_Currency, 2) + ' ';
  SProfitValue2.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_OProfit_Currency, 2) + ' ';
  SSystemPosition.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_SPosition, 0) + ' ';
  STradePosition.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_OPosition, 0) + ' ';
  SPositionGap.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_PositionGap, 0) + ' ';

  SProfitValue3.Font.Color := TFNGlobal.GetTextColor(0, m_BlockViewCollection.m_SRealProfit_Currency);
  SProfitValue2.Font.Color := TFNGlobal.GetTextColor(0, m_BlockViewCollection.m_OProfit_Currency);
  SSystemPosition.Font.Color := TFNGlobal.GetTextColor(0, m_BlockViewCollection.m_SPosition);
  STradePosition.Font.Color := TFNGlobal.GetTextColor(0, m_BlockViewCollection.m_OPosition);

  if m_BlockViewCollection.m_SDateTime <> 0 then
  begin
    PanelSDate.Caption := DateToStr(m_BlockViewCollection.m_SDateTime) + ' ';
    PanelSTime.Caption := TFNGlobal.DateTimeToStr6(m_BlockViewCollection.m_SDateTime) + ' ';
  end
  else
  begin
    PanelSDate.Caption := ' ';
    PanelSTime.Caption := ' ';
  end;

  if m_BlockViewCollection.m_SQuote <> 0 then
  begin
    PanelSQuote.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_SQuote, 2) + ' ';
  end
  else
  begin
    PanelSQuote.Caption := ' ';
  end;
  PanelSProfitValue2.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_SRealProfit_Currency, 2) + ' ';
  PanelSPosition.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_SPosition, 0) + ' ';
  PanelSTradeCount.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_STradeCount, 0) + ' ';
  PanelSBuyPosition.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_SBuyPosition, 0) + ' ';
  PanelSSellPosition.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_SSellPosition, 0) + ' ';

  // PanelSCommission.Font.Color   := TFNGlobal.GetTextColor(0, m_BlockViewCollection.m_SCommission);
  PanelSProfitValue2.Font.Color := TFNGlobal.GetTextColor(0, m_BlockViewCollection.m_SRealProfit_Currency);
  PanelSPosition.Font.Color := TFNGlobal.GetTextColor(0, m_BlockViewCollection.m_SPosition);

  PanelSBuyPosition.Font.Color := TFNGlobal.GetTextColor(0, m_BlockViewCollection.m_SBuyPosition);
  PanelSSellPosition.Font.Color := TFNGlobal.GetTextColor(0, m_BlockViewCollection.m_SSellPosition);

  if m_BlockViewCollection.m_ODateTime <> 0 then
  begin
    PanelODate.Caption := DateToStr(m_BlockViewCollection.m_ODateTime) + ' ';
    PanelOTime.Caption := TFNGlobal.DateTimeToStr6(m_BlockViewCollection.m_ODateTime) + ' ';
    PanelODate2.Caption := DateToStr(m_BlockViewCollection.m_ODateTime) + ' ';
    PanelOTime2.Caption := TFNGlobal.DateTimeToStr6(m_BlockViewCollection.m_ODateTime) + ' ';
  end
  else
  begin
    PanelODate.Caption := ' ';
    PanelOTime.Caption := ' ';
    PanelODate2.Caption := ' ';
    PanelOTime2.Caption := ' ';
  end;

  if m_BlockViewCollection.m_OQuote <> 0 then
  begin
    PanelOQuote.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_OQuote, 2) + ' ';
    PanelOQuote2.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_OQuote, 2) + ' ';
  end
  else
  begin
    PanelOQuote.Caption := ' ';
    PanelOQuote2.Caption := ' ';
  end;
  PanelOProfitValue.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_OProfit_Currency, 2) + ' ';
  PanelOPosition.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_OPosition, 0) + ' ';
  PanelOTradeCount.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_OTradeCount, 0) + ' ';
  PanelOBuyPosition.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_OBuyPosition, 0) + ' ';
  PanelOSellPosition.Caption := TFNGlobal.WriteNumber(m_BlockViewCollection.m_OSellPosition, 0) + ' ';

  PanelOProfitValue.Font.Color := TFNGlobal.GetTextColor(0, m_BlockViewCollection.m_OProfit_Currency);
  PanelOPosition.Font.Color := TFNGlobal.GetTextColor(0, m_BlockViewCollection.m_OPosition);

  PanelOBuyPosition.Font.Color := TFNGlobal.GetTextColor(0, m_BlockViewCollection.m_OBuyPosition);
  PanelOSellPosition.Font.Color := TFNGlobal.GetTextColor(0, m_BlockViewCollection.m_OSellPosition);

  ListViewBlockItem.Repaint;

  if m_BlockViewCollection.SummaryOption.GetBooleanValue('USELOSSTRADESTOP') then
  begin
    if (m_BlockViewCollection.m_SRealProfit_Currency < m_BlockViewCollection.SummaryOption.GetDoubleValue('LOSSTRADESTOP')) then
    begin
      m_BlockViewCollection.DoLosscut;
    end;
  end;

end;

{$ENDREGION}
{$REGION '메인 화면의 상태(최대,최소,일반), 크기, 위치를 저장하고 복원하는 부분'}

// ------------------------------------------------------------------------------
// 메인 화면의 상태(최대,최소,일반), 크기, 위치를 저장하는 부분
procedure TMainForm.SaveMainWindow();
var
  f_Registry: CFNRegistry;
  f_WindowState: Integer;
begin
  f_Registry := CFNRegistry.Create(Self);
  f_Registry.Company := g_CompanyName;
  f_Registry.ApplicationName := g_ApplicationName;

  if (WindowState = wsNormal) then
    f_WindowState := 0
  else if (WindowState = wsMinimized) then
    f_WindowState := 1
  else
    f_WindowState := 2;
  f_Registry.WriteInteger('MainWindow', 'WindowState', f_WindowState);

  if (WindowState = wsNormal) then
  begin
    f_Registry.WriteInteger('MainWindow', 'WindowLeft', Left);
    f_Registry.WriteInteger('MainWindow', 'WindowTop', Top);
    f_Registry.WriteInteger('MainWindow', 'WindowWidth', Width);
    f_Registry.WriteInteger('MainWindow', 'WindowHeight', Height);
  end;
end;

// ------------------------------------------------------------------------------
// 메인 화면의 상태(최대,최소,일반), 크기, 위치를 복원하는 부분
procedure TMainForm.RestoreMainWindow();
var
  f_Registry: CFNRegistry;
  f_WindowState: Integer;
  f_Left, f_Top, f_Width, f_Height: Integer;
var
  f_Screen_X: Integer;
  f_Screen_Y: Integer;
begin
  f_Screen_X := Windows.GetSystemMetrics(SM_CXSCREEN);
  f_Screen_Y := Windows.GetSystemMetrics(SM_CYSCREEN);

  f_Registry := CFNRegistry.Create(Self);
  f_Registry.Company := g_CompanyName;
  f_Registry.ApplicationName := g_ApplicationName;

  f_WindowState := f_Registry.ReadInteger('MainWindow', 'WindowState', 0);
  f_Left := f_Registry.ReadInteger('MainWindow', 'WindowLeft', -1);
  f_Top := f_Registry.ReadInteger('MainWindow', 'WindowTop', -1);
  f_Width := f_Registry.ReadInteger('MainWindow', 'WindowWidth', -1);
  f_Height := f_Registry.ReadInteger('MainWindow', 'WindowHeight', -1);

  if ((f_Left > 0) and (f_Top > 0) and (f_Width > 0) and (f_Height > 0) and (f_Left < f_Screen_X) and (f_Top < f_Screen_Y)) then
  begin
    Self.SetBounds(f_Left, f_Top, f_Width, f_Height);
  end;

  if (f_WindowState = 0) then
    WindowState := wsNormal
  else if (f_WindowState = 1) then
    WindowState := wsMinimized
  else
    WindowState := wsMaximized;

  f_Registry.Free;
end;
{$ENDREGION}
{$REGION 'ListViewLog의 표시'}

procedure TMainForm.OnLogEvent(ASender: TObject; ADateTime: TDateTime; AType: Integer; AMessage, AClassName: String);
var
  f_LogItem: CFNLogItem;
  f_BlockItemView: TBlockItemControl;
begin
  if not Assigned(ASender) then
    exit;

  if not(ASender is TBlockItemControl) then
    exit;

  f_BlockItemView := TBlockItemControl(ASender);

  f_LogItem := CFNLogItem.Create;

  f_LogItem.m_BlockName := f_BlockItemView.Block.BlockName;
  f_LogItem.m_DateTime := ADateTime;
  f_LogItem.m_Type := AType;
  f_LogItem.m_Message := AMessage;
  f_LogItem.m_ClassName := AClassName;

  m_LogCollection.m_Items.Insert(0, f_LogItem);

  DisplayLogInfo;
end;

procedure TMainForm.ClearLogInfo;
begin
  if not Assigned(m_LogCollection) then
    exit;

  ListViewLog.Items.Count := 0;
end;

procedure TMainForm.DisplayLogInfo;
begin
  if not Assigned(m_LogCollection) then
    exit;

  try
    ListViewLog.Items.Count := m_LogCollection.m_Items.Count;
    ListViewLog.Repaint;
  except
  end;
end;

procedure TMainForm.ListViewLogCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
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

procedure TMainForm.ListViewLogCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
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

procedure TMainForm.ListViewLogData(Sender: TObject; Item: TListItem);
var
  nItemIndex: Integer;
  f_LogItem: CFNLogItem;
begin
  if not Assigned(m_LogCollection) then
    exit;

  if ((Item.Index < 0) or (Item.Index >= m_LogCollection.m_Items.Count)) then
    exit;
  nItemIndex := Item.Index;
  f_LogItem := m_LogCollection.m_Items[nItemIndex];

  Item.Caption := f_LogItem.m_BlockName;
  Item.SubItems.Add(TFNGlobal.DateTimeToStr6(f_LogItem.m_DateTime));
  Item.SubItems.Add(GetLogTypeText(f_LogItem.m_Type));
  Item.SubItems.Add(f_LogItem.m_Message);
  Item.SubItems.Add(f_LogItem.m_ClassName);
  Item.Data := f_LogItem;
end;
{$ENDREGION}
{$REGION '통신 재연결'}

// ------------------------------------------------------------------------------------
procedure TMainForm.OnSocketEvent(p_Event: Integer);
begin
  PostMessage(Handle, WM_SOCKET_EVENT, p_Event, 0);
end;

// ------------------------------------------------------------------------------------
procedure TMainForm.WMSocketEvent(var Message: TMessage);
begin
  if (Message.WParam = SOCKEVENT_ABNORMALDISCONNECT) or (Message.WParam = SOCKEVENT_NORMALDISCONNECT) then
  begin
    OnOPSDisconnect(Self)
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMainForm.OnOPSDisconnect(Sender: TObject);
begin
  // {$IFNDEF DEBUG}
  if g_SocketManager.GetConnected then
    exit;
  g_SocketManager.EnableEvent := false;
  try
    if not Assigned(MatrixReConnectDlg) then
    begin
      LOG_WRITE(LOG_TYPE_INFO, 'TMainForm', '시그널데이터 통신연결이 원활하지 않아 재연결을 시도합니다.');
      g_SocketManager.OnSocketEvent := NIL;
      g_SocketManager.Disconnect;
      MatrixReConnectDlg := TMatrixReConnectDlg.Create(Application);
      MatrixReConnectDlg.ShowModal();
      MatrixReConnectDlg.Free;
      MatrixReConnectDlg := NIL;
      g_SocketManager.OnSocketEvent := OnSocketEvent;
      LOG_WRITE(LOG_TYPE_INFO, 'TMainForm', '시그널데이터 통신이 재연결 되었습니다.');
    end;
  finally
    g_SocketManager.EnableEvent := true;
  end;
  // {$ENDIF}
end;

// ------------------------------------------------------------------------------------
procedure TMainForm.OnSecDisconnect(Sender: TObject);
begin
  // {$IFNDEF DEBUG}
  if not m_SecReConnecting then
  begin
    m_SecReConnecting := true;
    if not Assigned(ReLoginDlg) then
    begin
      ReLoginDlg := TReLoginDlg.Create(Application);
    end;

    if Sender = ReceiveSensor then
    begin
      LOG_WRITE(LOG_TYPE_INFO, 'TMainForm', '증권사와의 통신연결이 원활하지 않아 재연결을 시도합니다.');
    end;

    ReLoginDlg.ShowModal();
    g_AgentManager.ReSubscribeAll;
    LOG_WRITE(LOG_TYPE_INFO, 'TMainForm', '증권사와 통신이 재연결 되었습니다.');
    m_SecReConnecting := false;
  end;
  // {$ENDIF}
end;
{$ENDREGION}

procedure TMainForm.TimerAutoRunTimer(Sender: TObject);
var
  f_ControlIndex: Integer;
  f_BlockItemView: TBlockItemControl;
begin
  TimerAutoRun.Enabled := false;

  if g_AutoRun and (g_AutoRunConfig.m_ConfigFileName <> '') then
  begin
    LoadFromFile(g_AutoRunConfig.m_ConfigFileName);
    if m_BlockViewCollection.m_Items.Count > 0 then
    begin
      m_SelectedBlockItemControl := m_BlockViewCollection.m_Items[0];
      m_SelectedBlockItemControlIndex := 0;
      m_SelectedBlockItemControl.BlockContentFrame := BlockContentFrame1;
    end;

    DisplayListBlockItem;
    BlockContentFrame1.MatrixSumaryOptionFrame1.SetOption;
    BlockContentFrame1.MatrixSumaryOptionFrame1.SetEnable(false);

    ClearSummaryInfo;

    m_Opened := true;
    m_CondtionFileName := ExtractFileName(g_AutoRunConfig.m_ConfigFileName);

    m_BlockViewCollection.Prepare;
    for f_ControlIndex := 0 to m_BlockViewCollection.m_Items.Count - 1 do
    begin
      f_BlockItemView := TBlockItemControl(m_BlockViewCollection.m_Items[f_ControlIndex]);
      f_BlockItemView.ActionStart;
      Sleep(500);
    end;

  end;

  if g_AutoRunConfig.m_MainWindowTitle <> '' then
  begin
    Caption := g_ApplicationName + ' - ' + g_AutoRunConfig.m_MainWindowTitle + ' [' + m_CondtionFileName + ']';
  end
  else
  begin
    Caption := g_ApplicationName + ' [' + m_CondtionFileName + ']';
  end;

  g_AutoRun := false;
end;

procedure TMainForm.StatusBarResize(Sender: TObject);
begin
  StatusBar.Panels[0].Width := StatusBar.Width - 660 - 20 * 3;
end;

procedure TMainForm.TimerDisplayTimer(Sender: TObject);
var
  f_Time1: TDateTime;
  f_CloseDateTime: TDateTime;
  f_Year, f_Month, f_Day, f_Hour, f_Min, f_Sec, f_MSec: Word;
  f_TimeDiffrence1: Double;
  f_TimeDiffrence2: Double;
  f_MaterialItem: CFNMaterialItem;
begin
  f_TimeDiffrence1 := 0;
  f_TimeDiffrence2 := 0;

  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(2, 2, 0, 'CME003_FN');

    f_TimeDiffrence1 := 0;
    if Assigned(f_MaterialItem) then
    begin
      f_TimeDiffrence1 := f_MaterialItem.m_TimeDiffrence;
      f_TimeDiffrence2 := f_MaterialItem.m_TimeDiffrence2;
    end;
  end;

  StatusBar.Panels[3].Text := TFNGlobal.DateTimeToStr6(TFNGlobal.ServerNow);
  StatusBar.Panels[4].Text := TFNGlobal.DateTimeToStr6(TFNGlobal.ServerNow + f_TimeDiffrence1);
  StatusBar.Panels[5].Text := TFNGlobal.DateTimeToStr6(TFNGlobal.ServerNow + f_TimeDiffrence2);
end;

end.
