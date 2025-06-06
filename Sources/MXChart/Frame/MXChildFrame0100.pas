unit MXChildFrame0100;

interface

uses Windows, SysUtils, Classes, WinProcs, Graphics, Forms, Controls, StdCtrls, ExtCtrls, Math,
  ComCtrls, Buttons,
  ToolWin, GR32_Image, FNRegistry,
  ImgList,
  ActnList,
  MKChartDefine,
  Dialogs,
  GR32,
  TeCanvas,
  Grids,
  CategoryButtons,
  MKSetting,
  MKIndicatorValue,
  MKConst,
  MKAVChartControl,
  MKColorPanel,
  MKTradeSystemManager,
  MKPerformanceValueArray,
  MKSignalData,
  MKTradeData,
  OleCtrls,
  SHDocVw,
  FNChildFrameCustom,
  FNQuotData,
  FNQuotArray,
  FNDataSet,
  FNDataObject,
  FNMaterialCollection,
  FNSymbolCollection,
  FNCMVariable,
  TSSTC_T1_Frame,
  TSSTC_T2_Frame,
  TSSTC_T3_Frame,
  TSSTC_N1_Frame,
  TSRSI_T1_Frame,
  TSRSI_N1_Frame,
  TSBB_T1_Frame,
  TSDISPARITY_N1_Frame,
  TSDISPARITY_T1_Frame,
  MXTradeStrategyOptionCollection, 
  MXTradeStrategy,
  TSSTC_N2_Frame,
  COND_TradingHour_Frame,
  TSBASELINE_T2_Frame,
  TSBASELINE_T1_Frame,
  TSBASELINE_N1_Frame,
  TSIM_T1_Frame,
  TSIM_T2_Frame,
  TSIM_T3_Frame,
  TSMOV_N2_Frame,
  TSMOV_N1_Frame,
  TSMOV_T2_Frame,
  TSMKI_T1_Frame,
  TSMOV_T1_Frame, TSREL_T1_Frame, COND_Random_Frame, COND_Enter_Frame,
  Menus, COND_Exit_Frame, MXTradeStrategyFrame, COND_REINFORCE_Frame,
  TSMOV_T3_Frame;

type
  TChildFrame0100 = class(TChildFrameCustom)
    ToolBarChartMenu: TToolBar;
    ToolButton2: TToolButton;
    m_btnTraceVisible: TToolButton;
    PanelChartSpace: TPanel;
    ImageList_HotTollbar: TImageList;
    ActionList1: TActionList;
    ZoomIN: TAction;
    ZoomOut: TAction;
    ZoomActual: TAction;
    Trace: TAction;
    PanelBody: TPanel;
    ColorDialog1: TColorDialog;
    ImageList2: TImageList;
    PanelChartOption: TPanel;
    ToolButton1: TToolButton;
    Action_Config: TAction;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    Action_OPSPrice: TAction;
    ComboBoxRQCount: TComboBox;
    Label1: TLabel;
    Action_ShowHideTradeRepot: TAction;
    ToolButton9: TToolButton;
    ToolButton8: TToolButton;
    Panel6: TPanel;
    CategoryPanelGroup1: TCategoryPanelGroup;
    CategoryPanel1: TCategoryPanel;
    RadioGroupChartType: TRadioGroup;
    RadioGroup_Trace: TRadioGroup;
    RadioGroup_OPSPrice: TRadioGroup;
    CategoryPanel2: TCategoryPanel;
    Label_OverlayOption1: TLabel;
    Label_OverlayOption2: TLabel;
    Label_OverlayOption3: TLabel;
    Label_OverlayOption4: TLabel;
    Button_OverlayDefault: TButton;
    CombolBox_SelectedOverlay: TComboBox;
    CheckBox_IM: TCheckBox;
    CheckBox_NET: TCheckBox;
    CheckBox_ENVELOP: TCheckBox;
    CheckBox_SAR: TCheckBox;
    CheckBox_BB: TCheckBox;
    CheckBox_MA: TCheckBox;
    CheckBox_MAMUL: TCheckBox;
    Edit_OverlayOption1: TEdit;
    Edit_OverlayOption2: TEdit;
    Edit_OverlayOption3: TEdit;
    Edit_OverlayOption4: TEdit;
    UpDown_OverlayOption1: TUpDown;
    UpDown_OverlayOption4: TUpDown;
    UpDown_OverlayOption2: TUpDown;
    UpDown_OverlayOption3: TUpDown;
    CheckBox_OPSOverlay: TCheckBox;
    CheckBox_OPSRELOverlay: TCheckBox;
    CheckBox_OPSIGUKOverlay: TCheckBox;
    CheckBox_OPSSTDDEVOverlay: TCheckBox;
    CheckBox_OPSIGUK2Overlay: TCheckBox;
    Panel_BugFixOverlay: TPanel;
    CategoryPanel3: TCategoryPanel;
    Label_IndicatorOption1: TLabel;
    Label_IndicatorOption2: TLabel;
    Label_IndicatorOption3: TLabel;
    Label_IndicatorOption4: TLabel;
    m_cbIndicatorVolume: TCheckBox;
    m_cbIndicatorSlowSTC: TCheckBox;
    m_cbIndicatorFastSTC: TCheckBox;
    m_cbIndicatorADX: TCheckBox;
    m_cbIndicatorSONAR: TCheckBox;
    m_cbIndicatorVR: TCheckBox;
    m_cbIndicatorPSY: TCheckBox;
    m_cbIndicatorWilliams: TCheckBox;
    m_cbIndicatorDMI: TCheckBox;
    m_cbIndicatorMACD: TCheckBox;
    m_cbIndicatorRSI: TCheckBox;
    m_cbIndicatorOBV: TCheckBox;
    m_cbIndicatorCCI: TCheckBox;
    m_cbIndicatorTRIX: TCheckBox;
    m_cbIndicatorPMAO: TCheckBox;
    m_cbIndicatorROC: TCheckBox;
    m_cbbIndicatorSelChart: TComboBox;
    Button_IndicatorDefault: TButton;
    Edit_IndicatorOption1: TEdit;
    UpDown_IndicatorOption1: TUpDown;
    Edit_IndicatorOption2: TEdit;
    UpDown_IndicatorOption2: TUpDown;
    Edit_IndicatorOption3: TEdit;
    UpDown_IndicatorOption3: TUpDown;
    Edit_IndicatorOption4: TEdit;
    UpDown_IndicatorOption4: TUpDown;
    m_cbOPS: TCheckBox;
    m_cbOPSREL: TCheckBox;
    m_cbOPSIGUK: TCheckBox;
    m_cbOPSIGUK2: TCheckBox;
    m_cbOPSSTD: TCheckBox;
    Panel_BufFixIndicator: TPanel;
    CategoryPanel4: TCategoryPanel;
    Label_SignalOption1: TLabel;
    Label_SignalOption2: TLabel;
    Label_SignalOption3: TLabel;
    Label_SignalOption4: TLabel;
    Button_SignalDefaultOption: TButton;
    CheckBox_ADXSignal: TCheckBox;
    CheckBox_FSTCSignal: TCheckBox;
    CheckBox_MACDSignal: TCheckBox;
    CheckBox_MASignal: TCheckBox;
    CheckBox_PMASignal: TCheckBox;
    CheckBox_RSISignal: TCheckBox;
    CheckBox_SONARSignal: TCheckBox;
    CheckBox_SSTCSignal: TCheckBox;
    CheckBox_TRIXSignal: TCheckBox;
    CheckBox_WilliamsSignal: TCheckBox;
    ComboBox_SelectedSignal: TComboBox;
    Edit_SignalOption1: TEdit;
    Edit_SignalOption2: TEdit;
    Edit_SignalOption3: TEdit;
    Edit_SignalOption4: TEdit;
    UpDown_SignalOption1: TUpDown;
    UpDown_SignalOption2: TUpDown;
    UpDown_SignalOption3: TUpDown;
    UpDown_SignalOption4: TUpDown;
    Panel_BugFix: TPanel;
    ImageList_NormalTollbar: TImageList;
    CheckBox_NMATrendSignal: TCheckBox;
    CheckBox_WMATrendSignal: TCheckBox;
    CheckBox_XMATrendSignal: TCheckBox;
    Button_SendSignalOption: TButton;
    Button_SendIndicatorOption: TButton;
    Button_SendOverlayOption: TButton;
    Bevel1: TBevel;
    ToolButton10: TToolButton;
    Action_Reset: TAction;
    ToolButton11: TToolButton;
    ComboBox_TimeFrame: TComboBox;
    Label2: TLabel;
    ActionList2: TActionList;
    DrawLine: TAction;
    DrawVLine: TAction;
    DrawHLine: TAction;
    DrawCLine: TAction;
    DrawRectangle: TAction;
    DrawCircle: TAction;
    DrawTirone: TAction;
    DrawQuadrant: TAction;
    DrawSpeedLine: TAction;
    DrawFFan: TAction;
    DrawFRetracement: TAction;
    DrawTimeZone: TAction;
    DrawAFP: TAction;
    DrawText: TAction;
    DrawEraser: TAction;
    DrawColor: TAction;
    CategoryPanel5: TCategoryPanel;
    m_gbTrendline: TGroupBox;
    ToolBar1: TToolBar;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton5: TSpeedButton;
    ToolBar2: TToolBar;
    m_btnDrawLine: TSpeedButton;
    SpeedButton1: TSpeedButton;
    m_btnDrawVLine: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton7: TSpeedButton;
    ToolBar3: TToolBar;
    SpeedButton2: TSpeedButton;
    PopupMenuReport: TPopupMenu;
    Action_SaveReport: TAction;
    Action_SaveTradeList: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    SaveDialog: TSaveDialog;
    ToolButton3: TToolButton;
    Action_Lock: TAction;
    PageControl2: TPageControl;
    TabSheet11: TTabSheet;
    TabSheet12: TTabSheet;
    Panel_ConfigSmall: TPanel;
    SpeedButton_ShowConfigPanel: TSpeedButton;
    Panel10: TPanel;
    SpeedButton_HideConfigPanel: TSpeedButton;
    ActionChangeStandDate: TAction;
    ActionNextDate: TAction;
    ActionPrevDate: TAction;
    ToolButton4: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    Panel2: TPanel;
    Splitter_Report: TSplitter;
    Panel4: TPanel;
    ColorPanel1: TColorPanel;
    ColorPanel2: TColorPanel;
    m_ChartTrace: TImgView32;
    ColorPanel3: TColorPanel;
    m_ChartCaption: TImgView32;
    ColorPanel4: TColorPanel;
    Panel1: TPanel;
    CMKAVChartControl1: CMKAVChartControl;
    ColorPanel5: TColorPanel;
    PanelScroll: TPanel;
    m_btnZoomActual: TSpeedButton;
    m_btnZoomIn: TSpeedButton;
    m_btnZoomOut: TSpeedButton;
    m_ScrollBar: TScrollBar;
    Panel_Report: TColorPanel;
    Panel_ReportSub: TPanel;
    PageControl_TradeReport: TPageControl;
    TabSheet1: TTabSheet;
    Panel5: TPanel;
    ListView_TradeList: TListView;
    ColorPanel7: TColorPanel;
    TabSheet2: TTabSheet;
    Memo_TradeReport: TMemo;
    ListView_Performance: TListView;
    ComboBox_SelectedSignal2: TComboBox;
    Panel3: TPanel;
    SpeedButton_HideReport: TSpeedButton;
    Panel7: TPanel;
    RadioGroup_TradeType: TRadioGroup;
    Panel_ReportSmallView: TPanel;
    SpeedButton_ShowReport: TSpeedButton;
    Panel88: TPanel;
    Panel9: TPanel;
    CheckBoxUseTradeStrategy: TCheckBox;
    ComboBoxTradeStrategy: TComboBox;
    Panel11: TPanel;
    PageControlStrategyConfig: TPageControl;
    TabSheetConfig: TTabSheet;
    PageControl3: TPageControl;
    TabSheet13: TTabSheet;
    PageControlStrategy: TPageControl;
    TabSheetX000: TTabSheet;
    STC_T1_Frame1: TSTC_T1_Frame;
    TabSheetX010: TTabSheet;
    STC_T2_Frame1: TSTC_T2_Frame;
    TabSheetX020: TTabSheet;
    STC_T3_Frame1: TSTC_T3_Frame;
    TabSheetX030: TTabSheet;
    STC_N1_Frame1: TSTC_N1_Frame;
    TabSheetX040: TTabSheet;
    STC_N2_Frame1: TSTC_N2_Frame;
    TabSheetX050: TTabSheet;
    RSI_T1_Frame1: TRSI_T1_Frame;
    TabSheetX060: TTabSheet;
    RSI_N1_Frame1: TRSI_N1_Frame;
    TabSheetX070: TTabSheet;
    BB_T1_Frame1: TBB_T1_Frame;
    TabSheetX080: TTabSheet;
    DISPARITY_T1_Frame1: TDISPARITY_T1_Frame;
    TabSheetX090: TTabSheet;
    DISPARITY_N1_Frame1: TDISPARITY_N1_Frame;
    TabSheetX100: TTabSheet;
    BASELINE_T1_Frame1: TBASELINE_T1_Frame;
    TabSheetX110: TTabSheet;
    BASELINE_T2_Frame1: TBASELINE_T2_Frame;
    TabSheetX120: TTabSheet;
    BASELINE_N1_Frame1: TBASELINE_N1_Frame;
    TabSheetX130: TTabSheet;
    IM_T1_Frame1: TIM_T1_Frame;
    TabSheetX140: TTabSheet;
    IM_T2_Frame1: TIM_T2_Frame;
    TabSheetX150: TTabSheet;
    IM_T3_Frame1: TIM_T3_Frame;
    TabSheet4: TTabSheet;
    MOV_T1_Frame1: TMOV_T1_Frame;
    TabSheet5: TTabSheet;
    MOV_T2_Frame1: TMOV_T2_Frame;
    TabSheet6: TTabSheet;
    MOV_T3_Frame1: TMOV_T3_Frame;
    TabSheet7: TTabSheet;
    MOV_N1_Frame1: TMOV_N1_Frame;
    TabSheet8: TTabSheet;
    MOV_N2_Frame1: TMOV_N2_Frame;
    TabSheetX160: TTabSheet;
    REL_T1_Frame1: TREL_T1_Frame;
    TabSheet14: TTabSheet;
    m_REINFORCE_Frame: TREINFORCE_Frame;
    TabSheetCFG02: TTabSheet;
    PageControl1: TPageControl;
    TabSheet3: TTabSheet;
    m_TradingHour_Frame: TTradingHour_Frame;
    TabSheet9: TTabSheet;
    m_Random_Frame: TRandom_Frame;
    TabSheetCFG03: TTabSheet;
    Panel13: TPanel;
    m_EXIT_Frame: TExit_Frame;
    TabSheetCFG04: TTabSheet;
    Panel14: TPanel;
    m_ENTER_Frame: TENTER_Frame;
    PanelScreenLock: TPanel;

    procedure RadioGroupChartTypeClick(Sender: TObject);
    procedure OnChangeOverlay(Sender: TObject);
    procedure OnChangeOverlayOption(Sender: TObject);
    procedure OnClickOverlayOptionDefault(Sender: TObject);
    procedure OnChangeIndicators(Sender: TObject);
    procedure OnChangeIndicatorOption(Sender: TObject);
    procedure OnClickTrace(Sender: TObject);
    procedure OnUpDownOverlayChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: SmallInt; Direction: TUpDownDirection);
    procedure OnUpDownIndicatorChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: SmallInt; Direction: TUpDownDirection);
    procedure CategoryPanel1Expand(Sender: TObject);

    procedure Action_ConfigExecute(Sender: TObject);
    procedure ZoomActualExecute(Sender: TObject);
    procedure ZoomOutExecute(Sender: TObject);
    procedure ZoomINExecute(Sender: TObject);
    procedure Action_OPSPriceExecute(Sender: TObject);

    procedure ComboBoxRQCountChange(Sender: TObject);
    procedure CheckBox_SignalClick(Sender: TObject);
    procedure ComboBox_SelectedSignalChange(Sender: TObject);
    procedure Button_SignalDefaultOptionClick(Sender: TObject);
    procedure UpDown_SignalOptionChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: SmallInt;
      Direction: TUpDownDirection);
    procedure Edit_IndicatorOptionChange(Sender: TObject);
    procedure Edit_OverlayOptionChange(Sender: TObject);
    procedure Edit_SignalOptionChange(Sender: TObject);
    procedure ListView_TradeListData(Sender: TObject; Item: TListItem);
    procedure CMKAVChartControl1Change(Sender: TObject);
    procedure RadioGroup_TradeTypeClick(Sender: TObject);
    procedure CategoryPanelGroup1Resize(Sender: TObject);
    procedure Action_ShowHideTradeRepotExecute(Sender: TObject);
    procedure Panel_ReportResize(Sender: TObject);
    procedure ListView_PerformanceData(Sender: TObject; Item: TListItem);
    procedure Button_IndicatorDefaultClick(Sender: TObject);
    procedure RadioGroup_TraceClick(Sender: TObject);
    procedure RadioGroup_OPSPriceClick(Sender: TObject);
    procedure SpeedButton_HideConfigPanelClick(Sender: TObject);
    procedure SpeedButton_ShowConfigPanelClick(Sender: TObject);
    procedure PanelChartOptionResize(Sender: TObject);
    procedure SpeedButton_HideReportClick(Sender: TObject);
    procedure SpeedButton_ShowReportClick(Sender: TObject);
    procedure ListView_TradeListSelectItem(Sender: TObject;
      Item: TListItem; Selected: Boolean);
    procedure ListView_TradeListCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure ListView_TradeListCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListView_PerformanceCustomDrawSubItem(
      Sender: TCustomListView; Item: TListItem; SubItem: Integer;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure Button_SendOverlayOptionClick(Sender: TObject);
    procedure Button_SendIndicatorOptionClick(Sender: TObject);
    procedure Button_SendSignalOptionClick(Sender: TObject);
    procedure Action_ResetExecute(Sender: TObject);
    procedure ComboBox_TimeFrameChange(Sender: TObject);

    procedure OnDrawObjectClick(Sender: TObject);
    procedure ComboBoxTradeStrategyChange(Sender: TObject);
    procedure CheckBoxUseStrategyClick(Sender: TObject);

    procedure DisplayTradeStrategy(AOption:CMXTradeStrategyOption);
    procedure Action_SaveReportExecute(Sender: TObject);
    procedure Action_SaveTradeListExecute(Sender: TObject);
    procedure Action_LockExecute(Sender: TObject);
    procedure ActionChangeStandDateExecute(Sender: TObject);
    procedure ActionNextDateExecute(Sender: TObject);
    procedure ActionPrevDateExecute(Sender: TObject);

  private
    m_bFirstActivate : Boolean;

    m_Registry                  : CFNRegistry;
    m_Setting                   : CMKSetting;
    m_ListenEvent               : Boolean;
    m_UseChangeEvent            : Boolean;
    m_SelectedSignalIdentity    : Integer;

    m_SelectedTradeStrategy : CMXTradeStrategy;

    m_TradeSystemManager:CMKTradeSystemManager;
    m_PerformanceValueArray : CMKPerformanceValueArray;

    m_RegSection:String;

    m_ReportPanelHeigh : Integer;

    procedure InitControl();

    procedure UpdateCTCtrl(p_Getting:Boolean);
    procedure UpdateOPSPrice(p_Getting: Boolean; p_Type: Integer=0);
    procedure UpdatePosValue(p_Getting:Boolean; p_Type:Integer=0);

    procedure UpdateOverlay(p_Getting:Boolean);
    procedure UpdateSelectedOverlayOption(p_Getting:Boolean);
    procedure UpdateSelectedOverlay(p_Getting:Boolean);

    procedure UpdateIndicator(p_Getting:Boolean);
    procedure UpdateSelectedIndicator(p_Getting:Boolean);
    procedure UpdateSelectedIndicatorOption(p_Getting:Boolean);

    procedure UpdateSignal(p_Getting:Boolean);
    procedure UpdateSelectedSignal(p_Getting:Boolean);
    procedure UpdateSelectedSignalOption(p_Getting:Boolean);

    procedure ApplyOverlay(p_Identity:Integer; p_Selected:Boolean);
    procedure AddOverlay(identity:Integer);
    procedure DeleteOverlay(identity:Integer);

    procedure AddIndicator(p_Identity:Integer);
    procedure DeleteIndicator(p_Identity:Integer);
    procedure ApplyIndicators(p_Identity:Integer; p_Selected:Boolean);
    procedure RequestChartData();

    procedure UpdateConfigPannel;
    procedure UpdateBuySellReportPannel;

    procedure ApplySignal(p_Identity: Integer; p_Selected: Boolean);
    procedure AddSignal(p_Identity:Integer);
    procedure DeleteSignal(p_Identity:Integer);

    procedure SetSelectedSignalIdentity(p_Value:Integer);
    procedure ScanSignal;
    procedure InitializeSetting00;
    procedure ApplySetting;

    procedure OnChangedTradeStrategyOption(Sender: TObject);
    procedure OnChangedTradeStrategyReinforce(Sender: TObject);
    procedure OnChangedTradingHour(Sender: TObject);
    procedure OnChangedGab(Sender: TObject);

  protected

    procedure ReceiveIndicatorSetting(p_IndicatorValue:CMKIndicatorValue); override;
    procedure OnChangeActivity; override;
    procedure InitializeListView_TradeList;
    procedure StartDrawingCharObject();
    procedure ApplySymbolInfoToTradeStrategyOption;

  public
    procedure OnFormCreate; override;
    procedure OnFormCloe; override;
    procedure OnFormActivate; override;
    procedure ChangedSelectedSymbolItem(); override;
    property RegSection:String read m_RegSection write m_RegSection;

  private
    m_VisibleTradeStrategy : Boolean;
    m_TradeStrategyFrame : Array [0..47] of TTradeStrategyFrame;
    m_TradeStrategyFrameCount:Integer;

  end;

implementation

uses
    DateUtils,
    MXVariable,
    MKAVDrawingObject,
    MKTextInputDlg,
    MKDefine,
    MKGlobal,
    MKTradeArray,
    MKTradeSignalDefine,
    MXTradeStrategySTC_T1,
    MXTradeStrategySTC_T2,
    MXTradeStrategySTC_T3,
    MXTradeStrategySTC_N1,
    MXTradeStrategySTC_N2,
    MXTradeStrategyRSI_T1,
    MXTradeStrategyRSI_N1,
    MXTradeStrategyBB_T1,
    MXTradeStrategyDISPARITY_T1,
    MXTradeStrategyDISPARITY_N1,
    MXTradeStrategyBASELINE_T1,
    MXTradeStrategyBASELINE_T2,
    MXTradeStrategyBASELINE_N1,
    MXTradeStrategyIM_T1,
    MXTradeStrategyIM_T2,
    MXTradeStrategyIM_T3,
    MXTradeStrategyMOV_T1,
    MXTradeStrategyMOV_T2,
    MXTradeStrategyMOV_T3,
    MXTradeStrategyMOV_N1,
    MXTradeStrategyMOV_N2,
    MXTradeStrategyREL_T1,
    MXChangeStandDateDlg,
    MKTradeStrategyConst;

const
    CATEGORY_PANEL_COUNT  =   5;
    CATEGORY_PANEL_HEAD_HEIGHT  =   22;
{$R *.dfm}

{$REGION '생성과 소멸'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.OnFormActivate;
begin
    inherited OnFormActivate;

    m_SelectedSymbolItem := CFNSymbolItem(SendMessage(Application.MainForm.Handle, WM_MAIN_PROCESS, WPARAM_GET_SELECTED_SYMBOL, 0));

    UpdateCTCtrl(false);

    UpdateOverlay(false);
    UpdateSelectedOverlay(false);
    UpdateSelectedOverlayOption(false);

    UpdateIndicator(false);
    UpdateSelectedIndicator(false);
    UpdateSelectedIndicatorOption(false);

    UpdateSignal(false);
    UpdateSelectedSignal(false);
    UpdateSelectedSignalOption(false);

    UpdatePosValue(false);
    UpdateOPSPrice(false);

    PageControlStrategyConfig.ActivePageIndex := 0;
    //PageControlStrategy.Align := alNone;
    PageControlStrategy.TabHeight := 1;
    PageControlStrategy.TabWidth := 1;

    PageControl2.ActivePageIndex := 0;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.OnFormCloe;
begin
    if Assigned(m_Setting) then
    begin
        m_Setting.SaveSetting();
        m_Setting.Free();
        m_Setting := NIL;
    end;

    if Assigned(m_Registry) then
    begin
        m_Registry.Free();
        m_Registry := NIL;
    end;

    if Assigned(m_SelectedTradeStrategy) then
    begin
        m_SelectedTradeStrategy.Free();
        m_SelectedTradeStrategy := NIL;
    end;

    m_TradeSystemManager.Free;
    m_PerformanceValueArray.Free;

    inherited OnFormCloe;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.OnFormCreate;
var
    f_Index:Integer;
begin
    inherited OnFormCreate;
    m_UseChangeEvent := FALSE;
    m_TradeSystemManager:= CMKTradeSystemManager.Create;
    m_PerformanceValueArray := CMKPerformanceValueArray.Create;

    m_RegSection := 'AVChart1_20131009';
    m_SelectedSignalIdentity := -1;

    InitControl();

    ComboBox_TimeFrame.ItemIndex := m_Setting.m_TimeFrameIndex;

    m_ReportPanelHeigh := Panel_Report.Height;
    Action_ShowHideTradeRepot.Checked := m_Setting.m_BuySellReport;
    UpdateBuySellReportPannel;

    Action_Config.Checked := m_Setting.m_ConfigVisible;
    UpdateConfigPannel;

    ComboBoxRQCount.ItemIndex := m_Setting.m_RequestCount;
    m_bFirstActivate := true;

    m_VisibleTradeStrategy := false;
    PageControlStrategyConfig.Visible := false;

    m_TradeStrategyFrameCount := 0;

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  STC_T1_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  STC_T2_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  STC_T3_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  STC_N1_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  STC_N2_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  RSI_T1_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  RSI_N1_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  BB_T1_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  DISPARITY_T1_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  DISPARITY_N1_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  BASELINE_T1_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  BASELINE_T2_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  BASELINE_N1_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  IM_T1_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  IM_T2_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  IM_T3_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  MOV_T1_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  MOV_T2_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  MOV_T3_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  MOV_N1_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  MOV_N2_Frame1;
    Inc(m_TradeStrategyFrameCount);

    m_TradeStrategyFrame[m_TradeStrategyFrameCount] :=  REL_T1_Frame1;
    Inc(m_TradeStrategyFrameCount);

    for f_Index := 0 to m_TradeStrategyFrameCount - 1 do
    begin
        m_TradeStrategyFrame[f_Index].OnChangedOption := OnChangedTradeStrategyOption;
    end;

    m_TradingHour_Frame.OnChangedOption := OnChangedTradingHour;
    m_Random_Frame.OnChangedOption := OnChangedTradingHour;
    m_ENTER_Frame.OnChangedOption := OnChangedTradingHour;
    m_EXIT_Frame.OnChangedOption := OnChangedTradingHour;
    m_REINFORCE_Frame.OnChangedOption := OnChangedTradeStrategyReinforce;

    m_TradingHour_Frame.OnChangedGabOption := OnChangedGab;

    m_UseChangeEvent := TRUE;
end;

procedure TChildFrame0100.OnChangeActivity;
begin

    UpdateCTCtrl(false);

    UpdateOverlay(false);
    UpdateSelectedOverlay(false);
    UpdateSelectedOverlayOption(false);

    UpdateIndicator(false);
    UpdateSelectedIndicator(false);
    UpdateSelectedIndicatorOption(false);

    UpdateSignal(false);
    UpdateSelectedSignal(false);
    UpdateSelectedSignalOption(false);

    UpdatePosValue(false);
    UpdateOPSPrice(false);
end;
{$ENDREGION}

{$REGION '오버라이딩'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.ReceiveIndicatorSetting(p_IndicatorValue: CMKIndicatorValue);
var
    f_OldValue: CMKIndicatorValue;
    f_Index:Integer;
begin
    if not Assigned(p_IndicatorValue) then exit;

    f_OldValue := m_Setting.m_Indicator[p_IndicatorValue.m_Value];
    for f_Index := 0 to f_OldValue.m_OptionCount-1 do f_OldValue.m_OptionValue[f_Index] := p_IndicatorValue.m_OptionValue[f_Index];
    if f_OldValue.m_ViewIndicator then
    begin
        UpdateSelectedOverlayOption(false);
        UpdateSelectedIndicatorOption(false);
        UpdateSelectedSignalOption(false);
        CMKAVChartControl1.ChangeChart(f_OldValue.m_Value);
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ChangedSelectedSymbolItem();
begin
    RequestChartData;
end;

{$ENDREGION}

{$REGION '설정값의 초기화와 적용'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.InitializeSetting00;
begin
    m_Setting.Clear;

    m_Setting.m_TimeFrameIndex := ComboBox_TimeFrame.ItemIndex;

    m_Setting.m_TraceVisible := true;
    m_Setting.m_RequestCount := 2;
    m_Setting.m_UseOPSPrice := false;
    m_Setting.m_BuySellReport := false;
    m_Setting.m_ConfigVisible := true;
    m_Setting.DeleteAll;
    m_Setting.AddO(CMKSetting.IND_OVERLAY_OPS);
    m_Setting.AddO(CMKSetting.IND_OVERLAY_OPSREL);

    CMKIndicatorValue(m_Setting.m_Indicator[CMKSetting.IND_OVERLAY_OPS]).m_ViewIndicator := true;
    CMKIndicatorValue(m_Setting.m_Indicator[CMKSetting.IND_OVERLAY_OPSREL]).m_ViewIndicator := true;

    m_Setting.AddI(CMKSetting.IND_VOLUME);
    CMKIndicatorValue(m_Setting.m_Indicator[CMKSetting.IND_VOLUME]).m_ViewIndicator := true;

    m_Setting.m_SelectedIndexO := 1;
    m_Setting.m_SelectedIdentityO := CMKSetting.IND_OVERLAY_OPSREL;
    m_Setting.m_SelectedIndexI := 0;
    m_Setting.m_SelectedIdentityI := CMKSetting.IND_VOLUME;
    m_Setting.m_SelectedIndexS := -1;
    m_Setting.m_SelectedIdentityS := -1;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ApplySetting;
begin
    Action_ShowHideTradeRepot.Checked := m_Setting.m_BuySellReport;
    UpdateBuySellReportPannel;

    Action_Config.Checked := m_Setting.m_ConfigVisible;
    UpdateConfigPannel;

    ComboBoxRQCount.ItemIndex := m_Setting.m_RequestCount;

    UpdateCTCtrl(false);

    UpdateOverlay(false);
    UpdateSelectedOverlay(false);
    UpdateSelectedOverlayOption(false);

    UpdateIndicator(false);
    UpdateSelectedIndicator(false);
    UpdateSelectedIndicatorOption(false);

    UpdateSignal(false);
    UpdateSelectedSignal(false);
    UpdateSelectedSignalOption(false);

    UpdatePosValue(false);
    UpdateOPSPrice(false);


    CMKAVChartControl1.SetChartType(m_Setting.m_ChartType, false);
    CMKAVChartControl1.SetScale(m_Setting.m_Scale, false);
    CMKAVChartControl1.SetXMaxMin((m_Setting.m_RequestCount+1) * 60);
    CMKAVChartControl1.SetTraceVisible(m_Setting.m_TraceVisible, false);
    CMKAVChartControl1.SetUseOPSPrice(m_Setting.m_UseOPSPrice);

    CMKAVChartControl1.ApplySetting;

    m_SelectedSignalIdentity := m_Setting.m_SelectedIdentityS;
    ScanSignal;
end;
{$ENDREGION}

{$REGION '데이터의 요청'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.RequestChartData;
begin
    if Assigned(m_SelectedSymbolItem) then
    begin
        if (0 < Length(m_SelectedSymbolItem.m_Symbol)) then
        begin
            m_Setting.m_Symbol := m_SelectedSymbolItem.m_Symbol;
            CMKAVChartControl1.SetRequestCount(9000);
            CMKAVChartControl1.SetSymbolItem(m_SelectedSymbolItem);
            CMKAVChartControl1.Clear;
            CMKAVChartControl1.Request_TR_AC_1000(true);

            m_TradingHour_Frame.SetSymbolItem(m_SelectedSymbolItem);

            ApplySymbolInfoToTradeStrategyOption;

        end;
    end;
end;
{$ENDREGION}

{$REGION '차트의 초기화'}
procedure TChildFrame0100.InitControl();
var
    f_Index       : Integer;
    ListColumn  : TListColumn;
begin

    //레지스트리
    m_Registry          := CFNRegistry.Create(Self);
    m_Registry.Company := g_CompanyName;
    m_Registry.ApplicationName := g_ApplicationName;

    //셋팅
    m_Setting := CMKSetting.Create();
    m_Setting.SetRegistry(m_Registry);
    m_Setting.SetRegSection(m_RegSection);
    m_Setting.ReadSetting();

    if g_FirstUseing then
    begin
        InitializeSetting00;
    end else
    begin
    end;

    m_ListenEvent := true;

    m_SelectedSignalIdentity := m_Setting.m_SelectedIdentityS;

    //차트컨트롤
    CMKAVChartControl1.Initialize();
    CMKAVChartControl1.SetSocketManager(m_SocketManager);
    CMKAVChartControl1.SetSetting(m_Setting);
    CMKAVChartControl1.SetScrollBar(m_ScrollBar);
    CMKAVChartControl1.SetChartCaption(m_ChartCaption);
    CMKAVChartControl1.SetChartTrace(m_ChartTrace);
    CMKAVChartControl1.SetTimeFrame(g_TimeFrame[m_Setting.m_TimeFrameIndex]);
    CMKAVChartControl1.SetColorSetIndex(m_Setting.m_ColorSetIndex, false);
    CMKAVChartControl1.SetChartType(m_Setting.m_ChartType, false);
    CMKAVChartControl1.SetScale(m_Setting.m_Scale, false);
    CMKAVChartControl1.SetXMaxMin((m_Setting.m_RequestCount+1) * 60);
    CMKAVChartControl1.SetTraceVisible(m_Setting.m_TraceVisible, false);
    CMKAVChartControl1.SetUseOPSPrice(m_Setting.m_UseOPSPrice);
    CMKAVChartControl1.CreateVirualChart;
end;

{$ENDREGION}

{$REGION '중앙의 차트'}

{$REGION '차트의 데이터변경시 발생한 이벤트'}
procedure TChildFrame0100.CMKAVChartControl1Change(Sender: TObject);
begin
    ScanSignal;
end;
{$ENDREGION}

{$REGION '차트의 확대축소'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.ZoomActualExecute(Sender: TObject);
begin
    CMKAVChartControl1.OnZoomActual();
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ZoomINExecute(Sender: TObject);
begin
    CMKAVChartControl1.OnZoomIn();
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ZoomOutExecute(Sender: TObject);
begin
    CMKAVChartControl1.OnZoomOut();
end;
{$ENDREGION}

{$ENDREGION}

{$REGION '상단 툴바명령어'}
{$REGION '타임프레임을 지정할 때'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.ComboBox_TimeFrameChange(Sender: TObject);
begin
    m_Setting.m_TimeFrameIndex := ComboBox_TimeFrame.ItemIndex;
    CMKAVChartControl1.SetTimeFrame(g_TimeFrame[m_Setting.m_TimeFrameIndex]);
    RequestChartData;
end;
{$ENDREGION}

{$REGION '한 화면에 그릴 바의 수을 지정할 때'}
procedure TChildFrame0100.ComboBoxRQCountChange(Sender: TObject);
begin
    m_Setting.m_RequestCount := ComboBoxRQCount.ItemIndex;
    CMKAVChartControl1.ReEnlarge((ComboBoxRQCount.ItemIndex+1) * 120);
end;
{$ENDREGION}

{$REGION '초기설정으로 변경될 때'}
procedure TChildFrame0100.Action_ResetExecute(Sender: TObject);
begin
    InitializeSetting00;
    ApplySetting;
end;
{$ENDREGION}

{$REGION '일반설정의 이벤트와 처리사항'}

{$REGION '주가와 OPS의 선택변경'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.Action_LockExecute(Sender: TObject);
begin
    PanelScreenLock.Visible := not PanelScreenLock.Visible;;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.Action_OPSPriceExecute(Sender: TObject);
var
    f_IndicatorValue : CMKIndicatorValue;
begin
    if (not m_ListenEvent) then exit;
    if not m_UseChangeEvent then exit;

    Action_OPSPrice.Checked := not Action_OPSPrice.Checked;

    UpdateOPSPrice(true,0);
    UpdateOPSPrice(false);

    CMKAVChartControl1.SetUseOPSPrice(m_Setting.m_UseOPSPrice);
    f_IndicatorValue := m_Setting.m_Indicator[m_Setting.IND_OVERLAY_OPS];
    if f_IndicatorValue.m_ViewIndicator then
    begin
        CMKAVChartControl1.DeleteChart(m_Setting.IND_OVERLAY_OPS, false);
        CMKAVChartControl1.AddChart(m_Setting.IND_OVERLAY_OPS, true)
    end;

    ScanSignal;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.RadioGroup_OPSPriceClick(Sender: TObject);
var
    f_IndicatorValue : CMKIndicatorValue;
begin
    if (not m_ListenEvent) then exit;
    if not m_UseChangeEvent then exit;

    UpdateOPSPrice(true, 1);
    UpdateOPSPrice(false);

    CMKAVChartControl1.SetUseOPSPrice(m_Setting.m_UseOPSPrice);
    f_IndicatorValue := m_Setting.m_Indicator[m_Setting.IND_OVERLAY_OPS];
    if f_IndicatorValue.m_ViewIndicator then
    begin
        CMKAVChartControl1.DeleteChart(m_Setting.IND_OVERLAY_OPS, false);
        CMKAVChartControl1.AddChart(m_Setting.IND_OVERLAY_OPS, true)
    end;

    ScanSignal;
end;
//---------------------------------------------------------------------------
procedure TChildFrame0100.UpdateOPSPrice(p_Getting:Boolean; p_Type:Integer=0);
begin
    if (p_Getting) then
    begin
        if p_Type = 0 then
        begin
            if (Action_OPSPrice.Checked = true) then
                m_Setting.m_UseOPSPrice := true
            else
                m_Setting.m_UseOPSPrice := false;
        end else
        begin
            if (RadioGroup_OPSPrice.ItemIndex = 0) then
                m_Setting.m_UseOPSPrice := false
            else
                m_Setting.m_UseOPSPrice := true;
        end;
    end
    else
    begin
        m_ListenEvent := false;
        if (m_Setting.m_UseOPSPrice = true) then
        begin
            Action_OPSPrice.Checked := true;
            RadioGroup_OPSPrice.ItemIndex := 1;
        end else
        begin
            Action_OPSPrice.Checked := false;
            RadioGroup_OPSPrice.ItemIndex := 0;
        end;

        m_ListenEvent := true;
    end;
end;
{$ENDREGION}

{$REGION '가격차트의 종류를 설정한다.'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.RadioGroupChartTypeClick(Sender: TObject);
begin
    UpdateCTCtrl(true);
    UpdateCTCtrl(false);
    CMKAVChartControl1.SetChartType(m_Setting.m_ChartType, true);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.UpdateCTCtrl(p_Getting:Boolean);
begin
    if (p_Getting) then
    begin

        if (RadioGroupChartType.ItemIndex = 0) then
            m_Setting.m_ChartType := 0
        else if (RadioGroupChartType.ItemIndex = 1) then
            m_Setting.m_ChartType := 1
        else if (RadioGroupChartType.ItemIndex = 2) then
            m_Setting.m_ChartType := 2;

    end else
    begin
        m_ListenEvent := false;

        if (m_Setting.m_ChartType = 0) then
        begin
            RadioGroupChartType.ItemIndex := 0;
        end
        else if (m_Setting.m_ChartType = 1) then
        begin
            RadioGroupChartType.ItemIndex := 1;
        end
        else if (m_Setting.m_ChartType = 2) then
        begin
            RadioGroupChartType.ItemIndex := 2;
        end;

        m_ListenEvent := true;
    end;
end;
{$ENDREGION}

{$REGION '마우스 움직일때 좌표의 선을 그릴지의 여부'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.OnClickTrace(Sender: TObject);
begin
    if (not m_ListenEvent) then exit;
    if not m_UseChangeEvent then exit;

    UpdatePosValue(true, 0);
    UpdatePosValue(false);

    CMKAVChartControl1.SetTraceVisible(m_Setting.m_TraceVisible, true);
end;
//---------------------------------------------------------------------------
procedure TChildFrame0100.RadioGroup_TraceClick(Sender: TObject);
begin
    if (not m_ListenEvent) then exit;
    if not m_UseChangeEvent then exit;

    UpdatePosValue(true, 1);
    UpdatePosValue(false);

    CMKAVChartControl1.SetTraceVisible(m_Setting.m_TraceVisible, true);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.UpdatePosValue(p_Getting:Boolean; p_Type:Integer=0);
begin
    if (p_Getting) then
    begin
        if p_Type = 0 then
        begin
            if (m_btnTraceVisible.Down = true) then
                m_Setting.m_TraceVisible := true
            else
                m_Setting.m_TraceVisible := false;
        end else
        begin
            if (RadioGroup_Trace.ItemIndex = 0) then
                m_Setting.m_TraceVisible := true
            else
                m_Setting.m_TraceVisible := false;
        end;
    end
    else
    begin
        m_ListenEvent := false;
        if (m_Setting.m_TraceVisible = true) then
        begin
            m_btnTraceVisible.Down := true;
            RadioGroup_Trace.ItemIndex := 0;
        end else
        begin
            m_btnTraceVisible.Down := false;
            RadioGroup_Trace.ItemIndex := 1;
        end;

        m_ListenEvent := true;
    end;
end;
{$ENDREGION}

{$ENDREGION}
{$ENDREGION}

{$REGION '오른쪽 설정'}

{$REGION '오버레이지표의 설정 '}

//---------------------------------------------------------------------------
procedure TChildFrame0100.ApplyOverlay(p_Identity:Integer; p_Selected:Boolean);
begin
    if (p_Identity < 0) then
        exit;

    UpdateOverlay(true);
    if (p_Selected) then
        AddOverlay(p_Identity)
    else
        DeleteOverlay(p_Identity);

    UpdateSelectedOverlay(false);
    UpdateSelectedOverlayOption(false);
    UpdateOverlay(false);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.AddOverlay(identity:Integer);
var
    nDeleteIdentity : Integer;
begin
    m_Setting.AddO(identity);
    if (m_Setting.GetIndCountO() >= CMKConst.MAX_OVERLAY_COUNT) then
    begin
        nDeleteIdentity := m_Setting.GetFirstValueO();
        CMKIndicatorValue(m_Setting.m_Indicator.Items[nDeleteIdentity]).m_ViewIndicator := false;
        m_Setting.DeleteO(nDeleteIdentity);
        CMKAVChartControl1.DeleteChart(nDeleteIdentity, false);
        UpdateOverlay(false);
    end;

    m_Setting.m_SelectedIndexO := m_Setting.m_SequenceO.Count - 1;
    m_Setting.m_SelectedIdentityO := identity;
    CMKIndicatorValue(m_Setting.m_Indicator.Items[identity]).m_ViewIndicator := true;
    CMKAVChartControl1.AddChart(identity);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.DeleteOverlay(identity:Integer);
var
    nFindIndex : Integer;
    nSelectedIndex : Integer;
begin
    nFindIndex := m_Setting.DeleteO(identity);
    if (nFindIndex >= 0) then
    begin
        if (m_Setting.m_SequenceO.Count > 0) then
        begin
            m_Setting.m_SelectedIndexO := m_Setting.m_SequenceO.Count - 1;
            m_Setting.m_SelectedIdentityO := PInteger(m_Setting.m_SequenceO[m_Setting.m_SelectedIndexO])^;
        end
        else
        begin
            m_Setting.m_SelectedIndexO := -1;
            m_Setting.m_SelectedIdentityO := -1;
        end;
    end;

    CMKIndicatorValue(m_Setting.m_Indicator.Items[identity]).m_ViewIndicator := false;
    CMKAVChartControl1.DeleteChart(identity);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.UpdateOverlay(p_Getting:Boolean);
begin
    if (p_Getting) then
    begin
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_MA]).m_ViewIndicator 		    := CheckBox_MA.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_NET]).m_ViewIndicator 			:= CheckBox_NET.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_ILMOK]).m_ViewIndicator 		:= CheckBox_IM.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_BB]).m_ViewIndicator 			:= CheckBox_BB.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_SAR]).m_ViewIndicator 			:= CheckBox_SAR.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_ENVELOP]).m_ViewIndicator 		:= CheckBox_ENVELOP.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_MAMULOVERLAY]).m_ViewIndicator	:= CheckBox_Mamul.Checked;

        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OVERLAY_OPS]).m_ViewIndicator	:= CheckBox_OPSOverlay.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OVERLAY_OPSREL]).m_ViewIndicator	:= CheckBox_OPSRELOverlay.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OVERLAY_OPSIGUK]).m_ViewIndicator	:= CheckBox_OPSIGUKOverlay.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OVERLAY_OPSIGUK2]).m_ViewIndicator	:= CheckBox_OPSIGUK2Overlay.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OVERLAY_OPSSTDDEV]).m_ViewIndicator	:= CheckBox_OPSSTDDEVOverlay.Checked;
    end
    else
    begin
        m_ListenEvent := false;

        CheckBox_MA.Checked       := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_MA]).m_ViewIndicator;
        CheckBox_NET.Checked      := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_NET]).m_ViewIndicator;
        CheckBox_IM.Checked       := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_ILMOK]).m_ViewIndicator;
        CheckBox_BB.Checked       := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_BB]).m_ViewIndicator;
        CheckBox_SAR.Checked      := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_SAR]).m_ViewIndicator;
        CheckBox_ENVELOP.Checked  := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_ENVELOP]).m_ViewIndicator;
        CheckBox_Mamul.Checked    := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_MAMULOVERLAY]).m_ViewIndicator;

        CheckBox_OPSOverlay.Checked    := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OVERLAY_OPS]).m_ViewIndicator;
        CheckBox_OPSRELOverlay.Checked    := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OVERLAY_OPSREL]).m_ViewIndicator;
        CheckBox_OPSIGUKOverlay.Checked    := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OVERLAY_OPSIGUK]).m_ViewIndicator;
        CheckBox_OPSIGUK2Overlay.Checked    := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OVERLAY_OPSIGUK2]).m_ViewIndicator;
        CheckBox_OPSSTDDEVOverlay.Checked    := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OVERLAY_OPSSTDDEV]).m_ViewIndicator;

        m_ListenEvent := true;
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.UpdateSelectedOverlay(p_Getting:Boolean);
var
    nIndex : Integer;
    nCount : Integer;
begin
    if (p_Getting) then
    begin
        if (CombolBox_SelectedOverlay.ItemIndex >= 0) then
        begin
            m_Setting.m_SelectedIndexO := CombolBox_SelectedOverlay.ItemIndex;
            m_Setting.m_SelectedIdentityO := PInteger(m_Setting.m_SequenceO[m_Setting.m_SelectedIndexO])^;
        end
        else
        begin
            m_Setting.m_SelectedIndexO := -1;
            m_Setting.m_SelectedIdentityO := -1;
        end;
    end
    else
    begin
        m_ListenEvent := false;

        if (m_Setting.m_SelectedIndexO >= 0) then
        begin
            m_Setting.m_SelectedIdentityO := PInteger(m_Setting.m_SequenceO[m_Setting.m_SelectedIndexO])^;

            CombolBox_SelectedOverlay.Clear;
            nCount := m_Setting.m_SequenceO.Count;
            for nIndex := 0 to nCount - 1 do
            begin
                CombolBox_SelectedOverlay.Items.Add(CMKIndicatorValue(m_Setting.m_Indicator.Items[PInteger(m_Setting.m_SequenceO[nIndex])^]).m_Name);
            end;

            CombolBox_SelectedOverlay.ItemIndex := m_Setting.m_SelectedIndexO;
        end
        else
        begin
            m_Setting.m_SelectedIdentityO := -1;
            m_Setting.m_SelectedIndexO := -1;
            CombolBox_SelectedOverlay.ItemIndex := -1;
        end;

        m_ListenEvent := true;
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.UpdateSelectedOverlayOption(p_Getting:Boolean);
var
    nIndex : Integer;
    nSelectedIdentity : Integer;
    nY : Integer;
    nCount : Integer;
    nFactor : Integer;
begin
    if (p_Getting) then
    begin
        if (m_Setting.m_SelectedIdentityO >= 0) then
        begin
            nIndex := m_Setting.m_SelectedIdentityO;
            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionCount >= 1) then
                CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionValue[0] :=
                UpDown_OverlayOption1.Position / CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionFactor[0];

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionCount >= 2) then
                CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionValue[1] :=
                UpDown_OverlayOption2.Position / CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionFactor[1];

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionCount >= 3) then
                CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionValue[2] :=
                UpDown_OverlayOption3.Position / CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionFactor[2];

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionCount >= 4) then
                CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionValue[3] :=
                UpDown_OverlayOption4.Position / CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionFactor[3];
        end;
    end
    else
    begin

        m_ListenEvent := false;

        Label_OverlayOption1.Caption := '';
        Label_OverlayOption2.Caption := '';
        Label_OverlayOption3.Caption := '';
        Label_OverlayOption4.Caption := '';

        nSelectedIdentity := m_Setting.m_SelectedIdentityO;
        if (nSelectedIdentity >= 0) then
        begin
            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount = 0) then
            begin
                Button_OverlayDefault.Visible := false;
                Button_SendOverlayOption.Visible := false;
            end else
            begin
                Button_OverlayDefault.Visible := true;
                Button_SendOverlayOption.Visible := true;
            end;

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount >= 1) then
            begin
                Edit_OverlayOption1.Visible := true;
                Label_OverlayOption1.Caption := CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionLabel[0];

                UpDown_OverlayOption1.Visible := true;
                UpDown_OverlayOption1.Min := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMinimum[0]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[0]);
                UpDown_OverlayOption1.Max := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMaximum[0]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[0]);
                UpDown_OverlayOption1.Increment := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionStepSize[0]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[0]);
                UpDown_OverlayOption1.Position := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionValue[0]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[0]);
            end
            else
            begin
                UpDown_OverlayOption1.Visible := false;
                Edit_OverlayOption1.visible := false;
            end;

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount >= 2) then
            begin
                Edit_OverlayOption2.visible := true;
                Label_OverlayOption2.Caption := CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionLabel[1];

                UpDown_OverlayOption2.Visible := true;
                UpDown_OverlayOption2.Min := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMinimum[1]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[1]);
                UpDown_OverlayOption2.Max := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMaximum[1]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[1]);
                UpDown_OverlayOption2.Increment := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionStepSize[1]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[1]);
                UpDown_OverlayOption2.Position := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionValue[1]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[1]);
            end
            else
            begin
                UpDown_OverlayOption2.Visible := false;
                Edit_OverlayOption2.visible := false;
            end;

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount >= 3) then
            begin
                Edit_OverlayOption3.visible := true;
                Label_OverlayOption3.Caption := CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionLabel[2];

                UpDown_OverlayOption3.Visible := true;
                UpDown_OverlayOption3.Min := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMinimum[2]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[2]);
                UpDown_OverlayOption3.Max := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMaximum[2]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[2]);
                UpDown_OverlayOption3.Increment := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionStepSize[2]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[2]);
                UpDown_OverlayOption3.Position := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionValue[2]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[2]);
            end
            else
            begin
                UpDown_OverlayOption3.Visible := false;
                Edit_OverlayOption3.visible := false;
            end;

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount >= 4) then
            begin
                Edit_OverlayOption4.visible := true;
                Label_OverlayOption4.Caption := CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionLabel[3];

                UpDown_OverlayOption4.Visible := true;
                UpDown_OverlayOption4.Min := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMinimum[3]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[3]);
                UpDown_OverlayOption4.Max := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMaximum[3]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[3]);
                UpDown_OverlayOption4.Increment := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionStepSize[3]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[3]);
                UpDown_OverlayOption4.Position := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionValue[3]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[3]);
            end
            else
            begin
                UpDown_OverlayOption4.Visible := false;
                Edit_OverlayOption4.visible := false;
            end;
        end
        else
        begin
            CombolBox_SelectedOverlay.Clear;

            Button_OverlayDefault.visible := false;
            Button_SendOverlayOption.Visible := false;

            Edit_OverlayOption1.visible := false;
            UpDown_OverlayOption1.Visible := false;

            Edit_OverlayOption2.visible := false;
            UpDown_OverlayOption2.Visible := false;

            Edit_OverlayOption3.visible := false;
            UpDown_OverlayOption3.Visible := false;

            Edit_OverlayOption4.visible := false;
            UpDown_OverlayOption4.Visible := false;
        end;
        Panel_BugFixOverlay.Visible := TRUE;
        Panel_BugFixOverlay.Repaint;
        Panel_BugFixOverlay.Visible := false;

        //CategoryPanel2.Visible := false;
        //CategoryPanel2.Visible := true;

        m_ListenEvent := true;
    end;
end;


//---------------------------------------------------------------------------
procedure TChildFrame0100.Button_SendOverlayOptionClick(Sender: TObject);
var
    f_Identity : Integer;
    f_IndicatorValue:CMKIndicatorValue;
begin
    if not m_ListenEvent then exit;

    f_Identity := m_Setting.m_SelectedIdentityO;
    if (f_Identity >= 0) then
    begin
        f_IndicatorValue := m_Setting.m_Indicator.Items[f_Identity];
        SendMessage(Application.MainForm.Handle, WM_MAIN_PROCESS, WPARAM_INDICATOR_SETTING, LParam(Pointer(f_IndicatorValue)));
    end;
end;

procedure TChildFrame0100.Edit_OverlayOptionChange(Sender: TObject);
var
    nOverlay:Integer;
begin
    if not m_ListenEvent then exit;

    if not m_UseChangeEvent then exit;

    nOverlay := m_Setting.m_SelectedIdentityO;
    UpdateSelectedOverlayOption(true);
    UpdateSelectedOverlayOption(false);
    CMKAVChartControl1.ChangeChart(nOverlay);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.OnClickOverlayOptionDefault(Sender: TObject);
var
    nOverlay : Integer;
begin
    if not m_ListenEvent then exit;

    nOverlay := m_Setting.m_SelectedIdentityO;
    if (nOverlay >= 0) then
    begin
        CMKIndicatorValue(m_Setting.m_Indicator.Items[nOverlay]).SetDefaultValue();
        UpdateSelectedOverlayOption(false);
        CMKAVChartControl1.ChangeChart(nOverlay);
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.OnChangeOverlay(Sender: TObject);
var
    nSelectIndicator : Integer;
begin
    if (not m_ListenEvent) then exit;
    if not m_UseChangeEvent then exit;

    if (TCheckBox(Sender) = CheckBox_MA) then
        nSelectIndicator := CMKSetting.IND_MA
    else if (TCheckBox(Sender) = CheckBox_IM) then
        nSelectIndicator := CMKSetting.IND_ILMOK
    else if (TCheckBox(Sender) = CheckBox_BB) then
        nSelectIndicator := CMKSetting.IND_BB
    else if (TCheckBox(Sender) = CheckBox_SAR) then
        nSelectIndicator := CMKSetting.IND_SAR
    else if (TCheckBox(Sender) = CheckBox_ENVELOP) then
        nSelectIndicator := CMKSetting.IND_ENVELOP
    else if (TCheckBox(Sender) = CheckBox_Net) then
        nSelectIndicator := CMKSetting.IND_NET
    else if (TCheckBox(Sender) = CheckBox_Mamul) then
        nSelectIndicator := CMKSetting.IND_MAMULOVERLAY

    else if (TCheckBox(Sender) = CheckBox_OPSOverlay) then
        nSelectIndicator := CMKSetting.IND_OVERLAY_OPS
    else if (TCheckBox(Sender) = CheckBox_OPSRELOverlay) then
        nSelectIndicator := CMKSetting.IND_OVERLAY_OPSREL
    else if (TCheckBox(Sender) = CheckBox_OPSIGUKOverlay) then
        nSelectIndicator := CMKSetting.IND_OVERLAY_OPSIGUK
    else if (TCheckBox(Sender) = CheckBox_OPSIGUK2Overlay) then
        nSelectIndicator := CMKSetting.IND_OVERLAY_OPSIGUK2
    else if (TCheckBox(Sender) = CheckBox_OPSSTDDEVOverlay) then
        nSelectIndicator := CMKSetting.IND_OVERLAY_OPSSTDDEV
    else
        nSelectIndicator := -1;

    ApplyOverlay(nSelectIndicator, TCheckBox(Sender).Checked);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.OnChangeOverlayOption(Sender: TObject);
var
    nOverlay : Integer;
begin
    if not m_ListenEvent then exit;
    if not m_UseChangeEvent then exit;

    if (TComboBox(Sender) = CombolBox_SelectedOverlay) then
    begin
        m_Setting.m_SelectedIndexO := CombolBox_SelectedOverlay.ItemIndex;
        UpdateSelectedOverlay(false);
        UpdateSelectedOverlayOption(false);
        //m_Setting.SaveSetting();
    end
    else if ( (TEdit(Sender) = Edit_OverlayOption1)
            or (TEdit(Sender) = Edit_OverlayOption2)
            or (TEdit(Sender) = Edit_OverlayOption3)
            or (TEdit(Sender) = Edit_OverlayOption4)

            or (TUpDown(Sender) = UpDown_OverlayOption1)
            or (TUpDown(Sender) = UpDown_OverlayOption2)
            or (TUpDown(Sender) = UpDown_OverlayOption3)
            or (TUpDown(Sender) = UpDown_OverlayOption4)) then
    begin
        nOverlay := m_Setting.m_SelectedIdentityO;
        UpdateSelectedOverlayOption(true);
        UpdateSelectedOverlayOption(false);
        CMKAVChartControl1.ChangeChart(nOverlay);
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.OnUpDownOverlayChangingEx(Sender: TObject; var AllowChange: Boolean;
  NewValue: SmallInt; Direction: TUpDownDirection);
var
    nOverlay : Integer;
    nIndex : Integer;
begin
    if not m_ListenEvent then exit;
    if not m_UseChangeEvent then exit;

    if  (
            (TUpDown(Sender) = UpDown_OverlayOption1) OR
            (TUpDown(Sender) = UpDown_OverlayOption2) OR
            (TUpDown(Sender) = UpDown_OverlayOption3) OR
            (TUpDown(Sender) = UpDown_OverlayOption4)
        )
    then
    begin
        nOverlay := m_Setting.m_SelectedIdentityO;
        nIndex := TUpDown(Sender).Tag;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[nOverlay]).m_OptionValue[nIndex] :=
                NewValue / CMKIndicatorValue(m_Setting.m_Indicator.Items[nOverlay]).m_OptionFactor[nIndex];

        if CMKIndicatorValue(m_Setting.m_Indicator.Items[nOverlay]).m_OptionValue[nIndex] < CMKIndicatorValue(m_Setting.m_Indicator.Items[nOverlay]).m_OptionMinimum[nIndex] then
            CMKIndicatorValue(m_Setting.m_Indicator.Items[nOverlay]).m_OptionValue[nIndex] := CMKIndicatorValue(m_Setting.m_Indicator.Items[nOverlay]).m_OptionMinimum[nIndex];

        if CMKIndicatorValue(m_Setting.m_Indicator.Items[nOverlay]).m_OptionValue[nIndex] > CMKIndicatorValue(m_Setting.m_Indicator.Items[nOverlay]).m_OptionMaximum[nIndex] then
            CMKIndicatorValue(m_Setting.m_Indicator.Items[nOverlay]).m_OptionValue[nIndex] := CMKIndicatorValue(m_Setting.m_Indicator.Items[nOverlay]).m_OptionMaximum[nIndex];

        UpdateSelectedOverlayOption(false);
        CMKAVChartControl1.ChangeChart(nOverlay);
        AllowChange := false;
    end;
end;

{$ENDREGION}

{$REGION '보조지표의 설정 '}
//---------------------------------------------------------------------------
//보조지표의 아이디와 선택상태에 따라 실제 보조지표를 추가 삭제를 담당한다.
procedure TChildFrame0100.ApplyIndicators(p_Identity:Integer; p_Selected:Boolean);
begin
    if (p_Identity < 0) then exit;;

    UpdateIndicator(true);

    if (p_Selected) then
        AddIndicator(p_Identity)
    else
        DeleteIndicator(p_Identity);

    UpdateSelectedIndicator(false);
    UpdateSelectedIndicatorOption(false);

    UpdateIndicator(false);
end;

//---------------------------------------------------------------------------
//보조지표를 추가한다.
procedure TChildFrame0100.AddIndicator(p_Identity:Integer);
var
    nDeleteIdentity : Integer;
begin
    m_Setting.AddI(p_Identity);
    if (m_Setting.GetIndCountI() >= CMKConst.MAX_INDICATOR_COUNT) then
    begin
        nDeleteIdentity := m_Setting.GetFirstValueI();
        CMKIndicatorValue(m_Setting.m_Indicator.Items[nDeleteIdentity]).m_ViewIndicator := false;
        m_Setting.DeleteI(nDeleteIdentity);
        CMKAVChartControl1.DeleteChart(nDeleteIdentity, false);
        UpdateIndicator(false);
    end;

    m_Setting.m_SelectedIndexI := m_Setting.m_SequenceI.Count - 1;
    m_Setting.m_SelectedIdentityI := p_Identity;
    CMKIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_ViewIndicator := true;
    CMKAVChartControl1.AddChart(p_Identity);
end;

//---------------------------------------------------------------------------
//보조지표를 삭제한다.
procedure TChildFrame0100.DeleteIndicator(p_Identity:Integer);
var
    nFindIndex : Integer;
    nSelectedIndex : Integer;
begin
    nFindIndex := m_Setting.DeleteI(p_Identity);
    if (nFindIndex >= 0) then
    begin
        if (m_Setting.m_SequenceI.Count > 0) then
        begin
            m_Setting.m_SelectedIndexI := m_Setting.m_SequenceI.Count - 1;
            m_Setting.m_SelectedIdentityI := PInteger(m_Setting.m_SequenceI[m_Setting.m_SelectedIndexI])^;
        end
        else
        begin
            m_Setting.m_SelectedIndexI := -1;
            m_Setting.m_SelectedIdentityI := -1;
        end;
    end;

    CMKIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_ViewIndicator := false;
    CMKAVChartControl1.DeleteChart(p_Identity);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.UpdateIndicator(p_Getting:Boolean);
begin
    if (p_Getting) then
    begin
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_VOLUME]).m_ViewIndicator   := m_cbIndicatorVolume.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_MACD]).m_ViewIndicator     := m_cbIndicatorMACD.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_ADX]).m_ViewIndicator      := m_cbIndicatorADX.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_DMI]).m_ViewIndicator      := m_cbIndicatorDMI.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_RSI]).m_ViewIndicator      := m_cbIndicatorRSI.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OBV]).m_ViewIndicator      := m_cbIndicatorOBV.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_FASTSTC]).m_ViewIndicator  := m_cbIndicatorFastSTC.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_SLOWSTC]).m_ViewIndicator  := m_cbIndicatorSlowSTC.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_SONAR]).m_ViewIndicator    := m_cbIndicatorSONAR.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_PMAO]).m_ViewIndicator     := m_cbIndicatorPMAO.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_TRIX]).m_ViewIndicator     := m_cbIndicatorTRIX.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_PSY]).m_ViewIndicator      := m_cbIndicatorPSY.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_CCI]).m_ViewIndicator      := m_cbIndicatorCCI.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_VR]).m_ViewIndicator       := m_cbIndicatorVR.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_WILLIAM]).m_ViewIndicator  := m_cbIndicatorWilliams.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_ROC]).m_ViewIndicator      := m_cbIndicatorROC.Checked;

        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OPS]).m_ViewIndicator      := m_cbOPS.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OPSIGUK]).m_ViewIndicator  := m_cbOPSIGUK.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OPSIGUK2]).m_ViewIndicator := m_cbOPSIGUK2.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OPSSTDDEV]).m_ViewIndicator:= m_cbOPSSTD.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OPSREL]).m_ViewIndicator   := m_cbOPSREL.Checked;
    end
    else
    begin
        m_ListenEvent := false;
        m_cbIndicatorVolume.Checked     := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_VOLUME]).m_ViewIndicator;
        m_cbIndicatorMACD.Checked       := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_MACD]).m_ViewIndicator;
        m_cbIndicatorADX.Checked        := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_ADX]).m_ViewIndicator;
        m_cbIndicatorDMI.Checked        := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_DMI]).m_ViewIndicator;
        m_cbIndicatorRSI.Checked        := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_RSI]).m_ViewIndicator;
        m_cbIndicatorOBV.Checked        := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OBV]).m_ViewIndicator;
        m_cbIndicatorFastSTC.Checked    := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_FASTSTC]).m_ViewIndicator;
        m_cbIndicatorSlowSTC.Checked    := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_SLOWSTC]).m_ViewIndicator;
        m_cbIndicatorSONAR.Checked      := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_SONAR]).m_ViewIndicator;
        m_cbIndicatorPMAO.Checked       := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_PMAO]).m_ViewIndicator;
        m_cbIndicatorTRIX.Checked       := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_TRIX]).m_ViewIndicator;
        m_cbIndicatorPSY.Checked        := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_PSY]).m_ViewIndicator;
        m_cbIndicatorCCI.Checked        := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_CCI]).m_ViewIndicator;
        m_cbIndicatorVR.Checked         := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_VR]).m_ViewIndicator;
        m_cbIndicatorWilliams.Checked   := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_WILLIAM]).m_ViewIndicator;
        m_cbIndicatorROC.Checked        := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_ROC]).m_ViewIndicator;

        m_cbOPS.Checked                 := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OPS]).m_ViewIndicator;
        m_cbOPSIGUK.Checked             := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OPSIGUK]).m_ViewIndicator;
        m_cbOPSIGUK2.Checked            := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OPSIGUK2]).m_ViewIndicator;
        m_cbOPSSTD.Checked              := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OPSSTDDEV]).m_ViewIndicator;
        m_cbOPSREL.Checked              := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_OPSREL]).m_ViewIndicator;

        m_ListenEvent := true;
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.UpdateSelectedIndicator(p_Getting:Boolean);
var
    nIndex : Integer;
    nCount : Integer;
begin
    if (p_Getting) then
    begin
        if (m_cbbIndicatorSelChart.ItemIndex >= 0) then
        begin
            m_Setting.m_SelectedIndexI := m_cbbIndicatorSelChart.ItemIndex;
            m_Setting.m_SelectedIdentityI := PInteger(m_Setting.m_SequenceI[m_Setting.m_SelectedIndexI])^;
        end
        else
        begin
            m_Setting.m_SelectedIndexI := -1;
            m_Setting.m_SelectedIdentityI := -1;
        end;
    end
    else
    begin
        m_ListenEvent := false;
        if (m_Setting.m_SelectedIdentityI >= 0) then
        begin
            m_Setting.m_SelectedIdentityI := PInteger(m_Setting.m_SequenceI[m_Setting.m_SelectedIndexI])^;

            m_cbbIndicatorSelChart.Clear;
            nCount := m_Setting.m_SequenceI.Count;
            for nIndex := 0 to nCount - 1 do
            begin
                m_cbbIndicatorSelChart.Items.Add(CMKIndicatorValue(m_Setting.m_Indicator.Items[PInteger(m_Setting.m_SequenceI[nIndex])^]).m_Name);
            end;
            m_cbbIndicatorSelChart.ItemIndex := m_Setting.m_SelectedIndexI;

        end
        else
        begin
            m_Setting.m_SelectedIdentityI := -1;
            m_Setting.m_SelectedIndexI := -1;
            m_cbbIndicatorSelChart.ItemIndex := -1;
        end;
        m_ListenEvent := true;
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.UpdateSelectedIndicatorOption(p_Getting:Boolean);
var
    nIndex : Integer;
    nSelectedIdentity : Integer;
    nCount : Integer;
begin
    if (p_Getting) then
    begin
        if (m_Setting.m_SelectedIdentityI >= 0) then
        begin
            nIndex := m_Setting.m_SelectedIdentityI;

            nIndex := m_Setting.m_SelectedIdentityI;
            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionCount >= 1) then
                CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionValue[0] :=
                UpDown_IndicatorOption1.Position / CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionFactor[0];

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionCount >= 2) then
                CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionValue[1] :=
                UpDown_IndicatorOption2.Position / CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionFactor[1];

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionCount >= 3) then
                CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionValue[2] :=
                UpDown_IndicatorOption3.Position / CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionFactor[2];

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionCount >= 4) then
                CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionValue[3] :=
                UpDown_IndicatorOption4.Position / CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionFactor[3];
        end;
    end
    else
    begin
        m_ListenEvent := false;

        Label_IndicatorOption1.Caption := '';
        Label_IndicatorOption2.Caption := '';
        Label_IndicatorOption3.Caption := '';
        Label_IndicatorOption4.Caption := '';

        nSelectedIdentity := m_Setting.m_SelectedIdentityI;
        if (nSelectedIdentity >= 0) then
        begin
            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount = 0) then
            begin
                Button_IndicatorDefault.Visible := false;
                Button_SendIndicatorOption.Visible := false;
            end else
            begin
                Button_IndicatorDefault.Visible := true;
                Button_SendIndicatorOption.Visible := true;
            end;

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount >= 1) then
            begin
                Edit_IndicatorOption1.Visible := true;
                Label_IndicatorOption1.Caption := CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionLabel[0];

                UpDown_IndicatorOption1.Visible := true;
                UpDown_IndicatorOption1.Min := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMinimum[0]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[0]);
                UpDown_IndicatorOption1.Max := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMaximum[0]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[0]);
                UpDown_IndicatorOption1.Increment := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionStepSize[0]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[0]);
                UpDown_IndicatorOption1.Position:= Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionValue[0]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[0]);
            end
            else
            begin
                UpDown_IndicatorOption1.Visible := false;
                Edit_IndicatorOption1.visible := false;
            end;

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount >= 2) then
            begin
                Edit_IndicatorOption2.visible := true;
                Label_IndicatorOption2.Caption := CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionLabel[1];

                UpDown_IndicatorOption2.Visible := true;
                UpDown_IndicatorOption2.Min := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMinimum[1]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[1]);
                UpDown_IndicatorOption2.Max := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMaximum[1]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[1]);
                UpDown_IndicatorOption2.Increment := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionStepSize[1]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[1]);
                UpDown_IndicatorOption2.Position:= Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionValue[1]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[1]);
            end
            else
            begin
                UpDown_IndicatorOption2.Visible := false;
                Edit_IndicatorOption2.visible := false;
            end;

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount >= 3) then
            begin
                Edit_IndicatorOption3.visible := true;
                Label_IndicatorOption3.Caption := CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionLabel[2];

                UpDown_IndicatorOption3.Visible := true;
                UpDown_IndicatorOption3.Min := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMinimum[2]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[2]);
                UpDown_IndicatorOption3.Max := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMaximum[2]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[2]);
                UpDown_IndicatorOption3.Increment := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionStepSize[2]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[2]);
                UpDown_IndicatorOption3.Position:= Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionValue[2]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[2]);
            end
            else
            begin
                UpDown_IndicatorOption3.Visible := false;
                Edit_IndicatorOption3.visible := false;
            end;

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount >= 4) then
            begin
                Edit_IndicatorOption4.visible := true;
                Label_IndicatorOption4.Caption := CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionLabel[3];

                UpDown_IndicatorOption4.Visible := true;
                UpDown_IndicatorOption4.Min := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMinimum[3]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[3]);
                UpDown_IndicatorOption4.Max := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMaximum[3]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[3]);
                UpDown_IndicatorOption4.Increment := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionStepSize[3]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[3]);
                UpDown_IndicatorOption4.Position:= Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionValue[3]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[3]);
            end
            else
            begin
                UpDown_IndicatorOption4.Visible := false;
                Edit_IndicatorOption4.visible := false;
            end;
        end
        else
        begin
            m_cbbIndicatorSelChart.Clear;

            Button_IndicatorDefault.visible := false;
            Button_SendIndicatorOption.Visible := false;

            Edit_IndicatorOption1.visible := false;
            UpDown_IndicatorOption1.Visible := false;

            Edit_IndicatorOption2.visible := false;
            UpDown_IndicatorOption2.Visible := false;

            Edit_IndicatorOption3.visible := false;
            UpDown_IndicatorOption3.Visible := false;

            Edit_IndicatorOption4.visible := false;
            UpDown_IndicatorOption4.Visible := false;
        end;
        //CategoryPanel3.Visible := false;
        //CategoryPanel3.Visible := true;
        Panel_BufFixIndicator.Visible := TRUE;
        Panel_BufFixIndicator.Repaint;
        Panel_BufFixIndicator.Visible := false;

        m_ListenEvent := true;
    end;

end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.Button_IndicatorDefaultClick(Sender: TObject);
var
    nIndicator : Integer;
begin
    if not m_ListenEvent then exit;
    nIndicator := m_Setting.m_SelectedIdentityI;
    if (nIndicator >= 0) then
    begin
        CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndicator]).SetDefaultValue();
        UpdateSelectedIndicatorOption(false);
        //m_Setting.SaveSetting();
        CMKAVChartControl1.ChangeChart(nIndicator);
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.Button_SendIndicatorOptionClick(Sender: TObject);
var
    f_Identity : Integer;
    f_IndicatorValue:CMKIndicatorValue;
begin
    if not m_ListenEvent then exit;

    f_Identity := m_Setting.m_SelectedIdentityI;
    if (f_Identity >= 0) then
    begin
        f_IndicatorValue := m_Setting.m_Indicator.Items[f_Identity];
        SendMessage(Application.MainForm.Handle, WM_MAIN_PROCESS, WPARAM_INDICATOR_SETTING, LParam(Pointer(f_IndicatorValue)));
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.Edit_IndicatorOptionChange(Sender: TObject);
var
    nIndicator : Integer;
begin
    if not m_ListenEvent then exit;
    if not m_UseChangeEvent then exit;

    nIndicator := m_Setting.m_SelectedIdentityI;
    UpdateSelectedIndicatorOption(true);
    UpdateSelectedIndicatorOption(false);
    CMKAVChartControl1.ChangeChart(nIndicator);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.OnChangeIndicators(Sender: TObject);
var
    nSelectIndicator : Integer;
begin
    if (not m_ListenEvent) then exit;
    if not m_UseChangeEvent then exit;

    if (TCheckBox(Sender) = m_cbIndicatorVolume) then
        nSelectIndicator := CMKSetting.IND_VOLUME
    else if (TCheckBox(Sender) = m_cbIndicatorSlowSTC) then
        nSelectIndicator := CMKSetting.IND_SLOWSTC
    else if (TCheckBox(Sender) = m_cbIndicatorFastSTC) then
        nSelectIndicator := CMKSetting.IND_FASTSTC
    else if (TCheckBox(Sender) = m_cbIndicatorADX) then
        nSelectIndicator := CMKSetting.IND_ADX
    else if (TCheckBox(Sender) = m_cbIndicatorSONAR) then
        nSelectIndicator := CMKSetting.IND_SONAR
    else if (TCheckBox(Sender) = m_cbIndicatorVR) then
        nSelectIndicator := CMKSetting.IND_VR
    else if (TCheckBox(Sender) = m_cbIndicatorPSY) then
        nSelectIndicator := CMKSetting.IND_PSY
    else if (TCheckBox(Sender) = m_cbIndicatorWilliams) then
        nSelectIndicator := CMKSetting.IND_WILLIAM
    else if (TCheckBox(Sender) = m_cbIndicatorMACD) then
        nSelectIndicator := CMKSetting.IND_MACD
    else if (TCheckBox(Sender) = m_cbIndicatorRSI) then
        nSelectIndicator := CMKSetting.IND_RSI
    else if (TCheckBox(Sender) = m_cbIndicatorOBV) then
        nSelectIndicator := CMKSetting.IND_OBV
    else if (TCheckBox(Sender) = m_cbIndicatorCCI) then
        nSelectIndicator := CMKSetting.IND_CCI
    else if (TCheckBox(Sender) = m_cbIndicatorTRIX) then
        nSelectIndicator := CMKSetting.IND_TRIX
    else if (TCheckBox(Sender) = m_cbIndicatorPMAO) then
        nSelectIndicator := CMKSetting.IND_PMAO
    else if (TCheckBox(Sender) = m_cbIndicatorROC) then
        nSelectIndicator := CMKSetting.IND_ROC
    else if (TCheckBox(Sender) = m_cbIndicatorDMI) then
        nSelectIndicator := CMKSetting.IND_DMI
    else if (TCheckBox(Sender) = m_cbOPS) then
        nSelectIndicator := CMKSetting.IND_OPS
    else if (TCheckBox(Sender) = m_cbOPSREL) then
        nSelectIndicator := CMKSetting.IND_OPSREL
    else if (TCheckBox(Sender) = m_cbOPSIGUK) then
        nSelectIndicator := CMKSetting.IND_OPSIGUK
    else if (TCheckBox(Sender) = m_cbOPSIGUK2) then
        nSelectIndicator := CMKSetting.IND_OPSIGUK2
    else if (TCheckBox(Sender) = m_cbOPSSTD) then
        nSelectIndicator := CMKSetting.IND_OPSSTDDEV
    else
        nSelectIndicator := -1;

    ApplyIndicators(nSelectIndicator, TCheckBox(Sender).Checked);
end;

//---------------------------------------------------------------------------
//보조지표의 옵션값이 변경되었을 처리하는 함수이다.
procedure TChildFrame0100.OnChangeIndicatorOption(Sender: TObject);
var
    nIndicator : Integer;
    f_ComboBox  :   TComboBox;
begin
    if not m_ListenEvent then exit;
    if not m_UseChangeEvent then exit;

    f_ComboBox := TComboBox(Sender);

    m_Setting.m_SelectedIndexI := f_ComboBox.ItemIndex;
    UpdateSelectedIndicator(false);
    UpdateSelectedIndicatorOption(false);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.OnUpDownIndicatorChangingEx(Sender: TObject; var AllowChange: Boolean;
  NewValue: SmallInt; Direction: TUpDownDirection);
var
    nIndicator : Integer;
    nIndex : Integer;
begin
    if not m_ListenEvent then exit;
    if not m_UseChangeEvent then exit;

    if  (
            (TUpDown(Sender) = UpDown_IndicatorOption1) OR
            (TUpDown(Sender) = UpDown_IndicatorOption2) OR
            (TUpDown(Sender) = UpDown_IndicatorOption3) OR
            (TUpDown(Sender) = UpDown_IndicatorOption4)
        )
    then
    begin
        nIndicator := m_Setting.m_SelectedIdentityI;
        nIndex := TUpDown(Sender).Tag;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndicator]).m_OptionValue[nIndex] :=
                NewValue / CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndicator]).m_OptionFactor[nIndex];

        if CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndicator]).m_OptionValue[nIndex] < CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndicator]).m_OptionMinimum[nIndex] then
            CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndicator]).m_OptionValue[nIndex] := CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndicator]).m_OptionMinimum[nIndex];

        if CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndicator]).m_OptionValue[nIndex] > CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndicator]).m_OptionMaximum[nIndex] then
            CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndicator]).m_OptionValue[nIndex] := CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndicator]).m_OptionMaximum[nIndex];

        UpdateSelectedIndicatorOption(false);
        CMKAVChartControl1.ChangeChart(nIndicator);
        AllowChange := false;
    end;
end;

{$ENDREGION}



{$REGION '신호의 설정'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.SetSelectedSignalIdentity(p_Value: Integer);
begin
    if not CheckBoxUseTradeStrategy.Checked then
    begin
        if (m_SelectedSignalIdentity <> p_Value) then
        begin
            m_SelectedSignalIdentity := p_Value;
            m_TradeSystemManager.m_SignalArray.Clear;
            if (m_SelectedSignalIdentity >= 0) AND (m_SelectedSignalIdentity < m_Setting.m_Indicator.Count) then
            begin
                CMKAVChartControl1.ScranSignal(m_SelectedSignalIdentity, m_TradeSystemManager.m_SignalArray);
                m_TradeSystemManager.MakeTradeList;
                InitializeListView_TradeList;
            end else
            begin
                m_TradeSystemManager.Clear;
                InitializeListView_TradeList;
            end;
        end;
    end else
    begin
        if (m_SelectedSignalIdentity <> p_Value) then
        begin
            m_SelectedSignalIdentity := p_Value;
            m_TradeSystemManager.m_SignalArray.Clear;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ScanSignal;
begin
    if not CheckBoxUseTradeStrategy.Checked then
    begin
        m_TradeSystemManager.m_SignalArray.Clear;
        if (m_SelectedSignalIdentity >= 0) AND (m_SelectedSignalIdentity < m_Setting.m_Indicator.Count) then
        begin
            CMKAVChartControl1.ScranSignal(m_SelectedSignalIdentity, m_TradeSystemManager.m_SignalArray);
            m_TradeSystemManager.MakeTradeList;
            InitializeListView_TradeList;
        end else
        begin
            m_TradeSystemManager.Clear;
            InitializeListView_TradeList;
        end;
    end else
    begin
        m_TradeSystemManager.m_SignalArray.Clear;

        if Assigned(m_SelectedTradeStrategy) then
        begin
            m_SelectedTradeStrategy.ScanSignal(m_TradeSystemManager.m_SignalArray);
            m_TradeSystemManager.MakeTradeList;
            InitializeListView_TradeList;
        end else
        begin
            m_TradeSystemManager.Clear;
            InitializeListView_TradeList;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ApplySignal(p_Identity:Integer; p_Selected:Boolean);
begin
    if (p_Identity < 0) then exit;;

    UpdateSignal(true);

    if (p_Selected) then AddSignal(p_Identity)
    else DeleteSignal(p_Identity);

    UpdateSelectedSignal(false);
    UpdateSelectedSignalOption(false);

    UpdateSignal(false);

    SetSelectedSignalIdentity(m_Setting.m_SelectedIdentityS);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.AddSignal(p_Identity: Integer);
var
    nDeleteIdentity : Integer;
begin
    m_Setting.AddS(p_Identity);
    if (m_Setting.GetIndCountS() >= CMKConst.MAX_SIGNAL_COUNT) then
    begin
        nDeleteIdentity := m_Setting.GetFirstValueS();
        CMKIndicatorValue(m_Setting.m_Indicator.Items[nDeleteIdentity]).m_ViewIndicator := false;
        m_Setting.DeleteS(nDeleteIdentity);
        CMKAVChartControl1.DeleteChart(nDeleteIdentity, false);
        UpdateSignal(false);
    end;

    m_Setting.m_SelectedIndexS := m_Setting.m_SequenceS.Count - 1;
    m_Setting.m_SelectedIdentityS := p_Identity;
    CMKIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_ViewIndicator := true;
    CMKAVChartControl1.AddChart(p_Identity);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.DeleteSignal(p_Identity: Integer);
var
    nFindIndex : Integer;
    nSelectedIndex : Integer;
begin
    nFindIndex := m_Setting.DeleteS(p_Identity);
    if (nFindIndex >= 0) then
    begin
        if (m_Setting.m_SequenceS.Count > 0) then
        begin
            m_Setting.m_SelectedIndexS := m_Setting.m_SequenceS.Count - 1;
            m_Setting.m_SelectedIdentityS := PInteger(m_Setting.m_SequenceS[m_Setting.m_SelectedIndexS])^;
        end
        else
        begin
            m_Setting.m_SelectedIndexS := -1;
            m_Setting.m_SelectedIdentityS := -1;
        end;
    end;

    CMKIndicatorValue(m_Setting.m_Indicator.Items[p_Identity]).m_ViewIndicator := false;
    CMKAVChartControl1.DeleteChart(p_Identity);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.CheckBox_SignalClick(Sender: TObject);
var
    nSelectSignal : Integer;
begin
    if (not m_ListenEvent) then exit;
    if not m_UseChangeEvent then exit;

    if (TCheckBox(Sender) = CheckBox_PMASignal) then
        nSelectSignal := CMKSetting.IND_PRICE_MA_CROSS_SIGNAL
    else
    if (TCheckBox(Sender) = CheckBox_MASignal) then
        nSelectSignal := CMKSetting.IND_MA_CROSS_SIGNAL
    else
    if (TCheckBox(Sender) = CheckBox_MACDSignal) then
        nSelectSignal := CMKSetting.IND_MACD_CROSS_SIGNAL
    else
    if (TCheckBox(Sender) = CheckBox_SSTCSignal) then
        nSelectSignal := CMKSetting.IND_SSTC_CROSS_SIGNAL
    else
    if (TCheckBox(Sender) = CheckBox_FSTCSignal) then
        nSelectSignal := CMKSetting.IND_FSTC_CROSS_SIGNAL
    else
    if (TCheckBox(Sender) = CheckBox_RSISignal) then
        nSelectSignal := CMKSetting.IND_RSI_CROSS_SIGNAL
    else
    if (TCheckBox(Sender) = CheckBox_ADXSignal) then
        nSelectSignal := CMKSetting.IND_ADX_CROSS_SIGNAL
    else
    if (TCheckBox(Sender) = CheckBox_WilliamsSignal) then
        nSelectSignal := CMKSetting.IND_WILLIAM_CROSS_SIGNAL
    else
    if (TCheckBox(Sender) = CheckBox_SONARSignal) then
        nSelectSignal := CMKSetting.IND_SONAR_CROSS_SIGNAL
    else
    if (TCheckBox(Sender) = CheckBox_TRIXSignal) then
        nSelectSignal := CMKSetting.IND_TRIX_CROSS_SIGNAL
    else
    if (TCheckBox(Sender) = CheckBox_NMATrendSignal) then
        nSelectSignal := CMKSetting.IND_NMA_TREND_SIGNAL
    else
    if (TCheckBox(Sender) = CheckBox_WMATrendSignal) then
        nSelectSignal := CMKSetting.IND_WMA_TREND_SIGNAL
    else
    if (TCheckBox(Sender) = CheckBox_XMATrendSignal) then
        nSelectSignal := CMKSetting.IND_XMA_TREND_SIGNAL
    else
        nSelectSignal := -1;

    ApplySignal(nSelectSignal, TCheckBox(Sender).Checked);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.Button_SendSignalOptionClick(Sender: TObject);
var
    f_Identity : Integer;
    f_IndicatorValue:CMKIndicatorValue;
begin
    if not m_ListenEvent then exit;

    f_Identity := m_Setting.m_SelectedIdentityS;
    if (f_Identity >= 0) then
    begin
        f_IndicatorValue := m_Setting.m_Indicator.Items[f_Identity];
        SendMessage(Application.MainForm.Handle, WM_MAIN_PROCESS, WPARAM_INDICATOR_SETTING, LParam(Pointer(f_IndicatorValue)));
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.Button_SignalDefaultOptionClick(Sender: TObject);
var
    nSignal : Integer;
begin
    if not m_ListenEvent then exit;

    nSignal := m_Setting.m_SelectedIdentityS;
    if (nSignal >= 0) then
    begin
        CMKIndicatorValue(m_Setting.m_Indicator.Items[nSignal]).SetDefaultValue();
        UpdateSelectedSignalOption(false);
        CMKAVChartControl1.ChangeChart(nSignal);
        ScanSignal;
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.Edit_SignalOptionChange(Sender: TObject);
var
    nSignal : Integer;
begin
    if not m_ListenEvent then exit;
    if not m_UseChangeEvent then exit;

    nSignal := m_Setting.m_SelectedIdentityS;
    UpdateSelectedSignalOption(true);
    UpdateSelectedSignalOption(false);
    CMKAVChartControl1.ChangeChart(nSignal);
    ScanSignal;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.UpdateSelectedSignal(p_Getting: Boolean);
var
    nIndex : Integer;
    nCount : Integer;
begin
    if (p_Getting) then
    begin
        if (ComboBox_SelectedSignal.ItemIndex >= 0) then
        begin
            m_Setting.m_SelectedIndexS := ComboBox_SelectedSignal.ItemIndex;
            m_Setting.m_SelectedIdentityS := PInteger(m_Setting.m_SequenceS[m_Setting.m_SelectedIndexS])^;
        end else
        begin
            m_Setting.m_SelectedIndexS := -1;
            m_Setting.m_SelectedIdentityS := -1;
        end;
    end
    else
    begin
        m_ListenEvent := false;

        if (m_Setting.m_SelectedIdentityS >= 0) AND (m_Setting.m_SelectedIndexS < m_Setting.m_SequenceS.Count) then
        begin

            m_Setting.m_SelectedIdentityS := PInteger(m_Setting.m_SequenceS[m_Setting.m_SelectedIndexS])^;

            ComboBox_SelectedSignal.Clear;
            nCount := m_Setting.m_SequenceS.Count;
            for nIndex := 0 to nCount - 1 do
            begin
                ComboBox_SelectedSignal.Items.Add(CMKIndicatorValue(m_Setting.m_Indicator.Items[PInteger(m_Setting.m_SequenceS[nIndex])^]).m_Name);
            end;
            ComboBox_SelectedSignal.ItemIndex := m_Setting.m_SelectedIndexS;


            ComboBox_SelectedSignal2.Clear;
            nCount := m_Setting.m_SequenceS.Count;
            for nIndex := 0 to nCount - 1 do
            begin
                ComboBox_SelectedSignal2.Items.Add(CMKIndicatorValue(m_Setting.m_Indicator.Items[PInteger(m_Setting.m_SequenceS[nIndex])^]).m_Name);
            end;
            ComboBox_SelectedSignal2.ItemIndex := m_Setting.m_SelectedIndexS;

        end else
        begin
            m_Setting.m_SelectedIdentityS := -1;
            m_Setting.m_SelectedIndexS := -1;
            ComboBox_SelectedSignal.ItemIndex := -1;
            ComboBox_SelectedSignal2.ItemIndex := -1;
        end;
        m_ListenEvent := true;

    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.UpdateSelectedSignalOption(p_Getting: Boolean);
var
    nIndex : Integer;
    nSelectedIdentity : Integer;
    nCount : Integer;
begin
    if (p_Getting) then
    begin
        if (m_Setting.m_SelectedIdentityS >= 0) then
        begin
            nIndex := m_Setting.m_SelectedIdentityS;

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionCount >= 1) then
                CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionValue[0] :=
                UpDown_SignalOption1.Position / CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionFactor[0];

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionCount >= 2) then
                CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionValue[1] :=
                UpDown_SignalOption2.Position / CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionFactor[1];

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionCount >= 3) then
                CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionValue[2] :=
                UpDown_SignalOption3.Position / CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionFactor[2];

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionCount >= 4) then
                CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionValue[3] :=
                UpDown_SignalOption4.Position / CMKIndicatorValue(m_Setting.m_Indicator.Items[nIndex]).m_OptionFactor[3];
        end;
    end
    else
    begin
        m_ListenEvent := false;

        Label_SignalOption1.Caption := '';
        Label_SignalOption2.Caption := '';
        Label_SignalOption3.Caption := '';
        Label_SignalOption4.Caption := '';


        nSelectedIdentity := m_Setting.m_SelectedIdentityS;
        if (nSelectedIdentity >= 0) then
        begin
            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount = 0) then
            begin
                Button_SignalDefaultOption.Visible := false;
                Button_SendSignalOption.Visible := false;
            end else
            begin
                Button_SignalDefaultOption.Visible := true;
                Button_SendSignalOption.Visible := true;
            end;

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount >= 1) then
            begin
                Edit_SignalOption1.Visible := true;
                Label_SignalOption1.Caption := CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionLabel[0];

                UpDown_SignalOption1.Visible := true;
                UpDown_SignalOption1.Min := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMinimum[0]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[0]);
                UpDown_SignalOption1.Max := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMaximum[0]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[0]);
                UpDown_SignalOption1.Increment := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionStepSize[0]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[0]);
                UpDown_SignalOption1.Position := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionValue[0]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[0]);
            end
            else
            begin
                UpDown_SignalOption1.Visible := false;
                Edit_SignalOption1.visible := false;
            end;

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount >= 2) then
            begin
                Edit_SignalOption2.visible := true;
                Label_SignalOption2.Caption := CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionLabel[1];

                UpDown_SignalOption2.Visible := true;
                UpDown_SignalOption2.Min := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMinimum[1]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[1]);
                UpDown_SignalOption2.Max := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMaximum[1]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[1]);
                UpDown_SignalOption2.Increment := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionStepSize[1]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[1]);
                UpDown_SignalOption2.Position := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionValue[1]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[1]);
            end
            else
            begin
                UpDown_SignalOption2.Visible := false;
                Edit_SignalOption2.visible := false;
            end;

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount >= 3) then
            begin
                Edit_SignalOption3.visible := true;
                Label_SignalOption3.Caption := CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionLabel[2];

                UpDown_SignalOption3.Visible := true;
                UpDown_SignalOption3.Min := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMinimum[2]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[2]);
                UpDown_SignalOption3.Max := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMaximum[2]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[2]);
                UpDown_SignalOption3.Increment := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionStepSize[2]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[2]);
                UpDown_SignalOption3.Position := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionValue[2]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[2]);
            end
            else
            begin
                UpDown_SignalOption3.Visible := false;
                Edit_SignalOption3.visible := false;
            end;

            if (CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionCount >= 4) then
            begin
                Edit_SignalOption4.visible := true;
                Label_SignalOption4.Caption := CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionLabel[3];

                UpDown_SignalOption4.Visible := true;
                UpDown_SignalOption4.Min := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMinimum[3]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[3]);
                UpDown_SignalOption4.Max := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionMaximum[3]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[3]);
                UpDown_SignalOption4.Increment := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionStepSize[3]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[3]);
                UpDown_SignalOption4.Position := Math.Floor(CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionValue[3]*CMKIndicatorValue(m_Setting.m_Indicator.Items[nSelectedIdentity]).m_OptionFactor[3]);
            end
            else
            begin
                UpDown_SignalOption4.Visible := false;
                Edit_SignalOption4.visible := false;
            end;
        end
        else
        begin
            ComboBox_SelectedSignal.Clear;
            ComboBox_SelectedSignal2.Clear;

            Button_SignalDefaultOption.visible := false;
            Button_SendSignalOption.Visible := false;

            Edit_SignalOption1.visible := false;
            UpDown_SignalOption1.Visible := false;

            Edit_SignalOption2.visible := false;
            UpDown_SignalOption2.Visible := false;

            Edit_SignalOption3.visible := false;
            UpDown_SignalOption3.Visible := false;

            Edit_SignalOption4.visible := false;
            UpDown_SignalOption4.Visible := false;
        end;
        //CategoryPanel4.Visible := false;
        //CategoryPanel4.Visible := true;

        Panel_BugFix.Visible := TRUE;
        Panel_BugFix.Repaint;
        Panel_BugFix.Visible := false;
        m_ListenEvent := true;

    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.UpdateSignal(p_Getting: Boolean);
begin
    if (p_Getting) then
    begin
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_PRICE_MA_CROSS_SIGNAL]).m_ViewIndicator        := CheckBox_PMASignal.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_MA_CROSS_SIGNAL      ]).m_ViewIndicator        := CheckBox_MASignal.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_MACD_CROSS_SIGNAL    ]).m_ViewIndicator        := CheckBox_MACDSignal.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_SSTC_CROSS_SIGNAL    ]).m_ViewIndicator        := CheckBox_SSTCSignal.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_FSTC_CROSS_SIGNAL    ]).m_ViewIndicator        := CheckBox_FSTCSignal.Checked;

        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_RSI_CROSS_SIGNAL     ]).m_ViewIndicator        := CheckBox_RSISignal.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_ADX_CROSS_SIGNAL     ]).m_ViewIndicator        := CheckBox_ADXSignal.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_WILLIAM_CROSS_SIGNAL ]).m_ViewIndicator        := CheckBox_WilliamsSignal.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_SONAR_CROSS_SIGNAL   ]).m_ViewIndicator        := CheckBox_SONARSignal.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_TRIX_CROSS_SIGNAL    ]).m_ViewIndicator        := CheckBox_TRIXSignal.Checked;

        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_NMA_TREND_SIGNAL      ]).m_ViewIndicator        := CheckBox_NMATrendSignal.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_WMA_TREND_SIGNAL      ]).m_ViewIndicator        := CheckBox_WMATrendSignal.Checked;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_XMA_TREND_SIGNAL      ]).m_ViewIndicator        := CheckBox_XMATrendSignal.Checked;

    end
    else
    begin
        m_ListenEvent := false;
        CheckBox_PMASignal.Checked      := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_PRICE_MA_CROSS_SIGNAL]).m_ViewIndicator;
        CheckBox_MASignal.Checked       := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_MA_CROSS_SIGNAL      ]).m_ViewIndicator;
        CheckBox_MACDSignal.Checked     := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_MACD_CROSS_SIGNAL    ]).m_ViewIndicator;
        CheckBox_SSTCSignal.Checked     := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_SSTC_CROSS_SIGNAL    ]).m_ViewIndicator;
        CheckBox_FSTCSignal.Checked     := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_FSTC_CROSS_SIGNAL    ]).m_ViewIndicator;

        CheckBox_RSISignal.Checked      := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_RSI_CROSS_SIGNAL    ]).m_ViewIndicator;
        CheckBox_ADXSignal.Checked      := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_ADX_CROSS_SIGNAL    ]).m_ViewIndicator;
        CheckBox_WilliamsSignal.Checked := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_WILLIAM_CROSS_SIGNAL]).m_ViewIndicator;
        CheckBox_SONARSignal.Checked    := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_SONAR_CROSS_SIGNAL  ]).m_ViewIndicator;
        CheckBox_TRIXSignal.Checked     := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_TRIX_CROSS_SIGNAL   ]).m_ViewIndicator;

        CheckBox_NMATrendSignal.Checked  := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_NMA_TREND_SIGNAL     ]).m_ViewIndicator;
        CheckBox_WMATrendSignal.Checked  := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_WMA_TREND_SIGNAL     ]).m_ViewIndicator;
        CheckBox_XMATrendSignal.Checked  := CMKIndicatorValue(m_Setting.m_Indicator.Items[CMKSetting.IND_XMA_TREND_SIGNAL     ]).m_ViewIndicator;

        m_ListenEvent := true;
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.UpDown_SignalOptionChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: SmallInt; Direction: TUpDownDirection);
var
    nSignal : Integer;
    nIndex : Integer;
begin
    if not m_ListenEvent then exit;
    if not m_UseChangeEvent then exit;

    if  (
            (TUpDown(Sender) = UpDown_SignalOption1) or
            (TUpDown(Sender) = UpDown_SignalOption2) or
            (TUpDown(Sender) = UpDown_SignalOption3) or
            (TUpDown(Sender) = UpDown_SignalOption4)
        )
    then
    begin

        nSignal := m_Setting.m_SelectedIdentityS;
        nIndex := TUpDown(Sender).Tag;
        CMKIndicatorValue(m_Setting.m_Indicator.Items[nSignal]).m_OptionValue[nIndex] :=
                NewValue / CMKIndicatorValue(m_Setting.m_Indicator.Items[nSignal]).m_OptionFactor[nIndex];

        if CMKIndicatorValue(m_Setting.m_Indicator.Items[nSignal]).m_OptionValue[nIndex] <
            CMKIndicatorValue(m_Setting.m_Indicator.Items[nSignal]).m_OptionMinimum[nIndex] then
            CMKIndicatorValue(m_Setting.m_Indicator.Items[nSignal]).m_OptionValue[nIndex] :=
            CMKIndicatorValue(m_Setting.m_Indicator.Items[nSignal]).m_OptionMinimum[nIndex];

        if CMKIndicatorValue(m_Setting.m_Indicator.Items[nSignal]).m_OptionValue[nIndex] >
        CMKIndicatorValue(m_Setting.m_Indicator.Items[nSignal]).m_OptionMaximum[nIndex] then
            CMKIndicatorValue(m_Setting.m_Indicator.Items[nSignal]).m_OptionValue[nIndex] :=
            CMKIndicatorValue(m_Setting.m_Indicator.Items[nSignal]).m_OptionMaximum[nIndex];

        UpdateSelectedSignalOption(false);
        CMKAVChartControl1.ChangeChart(nSignal);
        ScanSignal;
        AllowChange := false;
    end;
end;

{$ENDREGION}

{$REGION '설정창의 레이아웃'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.CategoryPanel1Expand(Sender: TObject);
var
    f_CategoryPanel:TCategoryPanel;
begin
    inherited;
    f_CategoryPanel := TCategoryPanel(Sender);
    f_CategoryPanel.Height := CategoryPanelGroup1.Height - CATEGORY_PANEL_COUNT * CATEGORY_PANEL_HEAD_HEIGHT;
    case f_CategoryPanel.Tag of
        0 :
            begin
                //CategoryPanel1.Collapsed := true;
                CategoryPanel2.Collapsed := true;
                CategoryPanel3.Collapsed := true;
                CategoryPanel4.Collapsed := true;
                CategoryPanel5.Collapsed := true;
            end;
        1 :
            begin
                CategoryPanel1.Collapsed := true;
                //CategoryPanel2.Collapsed := true;
                CategoryPanel3.Collapsed := true;
                CategoryPanel4.Collapsed := true;
                CategoryPanel5.Collapsed := true;
            end;
        2 :
            begin
                CategoryPanel1.Collapsed := true;
                CategoryPanel2.Collapsed := true;
                //CategoryPanel3.Collapsed := true;
                CategoryPanel4.Collapsed := true;
                CategoryPanel5.Collapsed := true;
            end;
        3 :
            begin
                CategoryPanel1.Collapsed := true;
                CategoryPanel2.Collapsed := true;
                CategoryPanel3.Collapsed := true;
                //CategoryPanel4.Collapsed := true;
                CategoryPanel5.Collapsed := true;
            end;
        4 :
            begin
                CategoryPanel1.Collapsed := true;
                CategoryPanel2.Collapsed := true;
                CategoryPanel3.Collapsed := true;
                CategoryPanel4.Collapsed := true;
                //CategoryPanel5.Collapsed := true;
            end;
    end;

end;

procedure TChildFrame0100.CategoryPanelGroup1Resize(Sender: TObject);
begin
    if not CategoryPanel1.Collapsed then CategoryPanel1.Height := CategoryPanelGroup1.Height - CATEGORY_PANEL_COUNT * CATEGORY_PANEL_HEAD_HEIGHT;
    if not CategoryPanel2.Collapsed then CategoryPanel2.Height := CategoryPanelGroup1.Height - CATEGORY_PANEL_COUNT * CATEGORY_PANEL_HEAD_HEIGHT;
    if not CategoryPanel3.Collapsed then CategoryPanel3.Height := CategoryPanelGroup1.Height - CATEGORY_PANEL_COUNT * CATEGORY_PANEL_HEAD_HEIGHT;
    if not CategoryPanel4.Collapsed then CategoryPanel4.Height := CategoryPanelGroup1.Height - CATEGORY_PANEL_COUNT * CATEGORY_PANEL_HEAD_HEIGHT;
    if not CategoryPanel5.Collapsed then CategoryPanel5.Height := CategoryPanelGroup1.Height - CATEGORY_PANEL_COUNT * CATEGORY_PANEL_HEAD_HEIGHT;
end;

{$ENDREGION}

{$REGION '설정창의 초기화'}

//---------------------------------------------------------------------------
procedure TChildFrame0100.UpdateConfigPannel;

begin
    if m_Setting.m_ConfigVisible then
    begin
        PanelChartOption.Width := 230;
        SpeedButton_HideConfigPanel.Visible := true;
        Panel_ConfigSmall.Visible := false;

        UpdateCTCtrl(false);

        UpdateOverlay(false);
        UpdateSelectedOverlay(false);
        UpdateSelectedOverlayOption(false);

        UpdateIndicator(false);
        UpdateSelectedIndicator(false);
        UpdateSelectedIndicatorOption(false);

        UpdateSignal(false);
        UpdateSelectedSignal(false);
        UpdateSelectedSignalOption(false);

        UpdatePosValue(false);

    end else
    begin
        PanelChartOption.Width := 11;

        SpeedButton_HideConfigPanel.Visible := false;

        Panel_ConfigSmall.Left := 0;
        Panel_ConfigSmall.Top := 0;
        Panel_ConfigSmall.Width := PanelChartOption.Width;
        Panel_ConfigSmall.Height := PanelChartOption.Height;
        Panel_ConfigSmall.Visible := true;

    end;
end;
{$ENDREGION}

{$REGION '우측 설정의 레이아웃'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.PanelChartOptionResize(Sender: TObject);
begin
    Panel_ConfigSmall.Left := 0;
    Panel_ConfigSmall.Top := 0;
    Panel_ConfigSmall.Width := PanelChartOption.Width;
    Panel_ConfigSmall.Height := PanelChartOption.Height;
end;


//---------------------------------------------------------------------------
procedure TChildFrame0100.SpeedButton_HideConfigPanelClick(Sender: TObject);
begin
    Action_Config.Checked := false;

    m_Setting.m_ConfigVisible := Action_Config.Checked;

    UpdateConfigPannel;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.SpeedButton_ShowConfigPanelClick(Sender: TObject);
begin
    Action_Config.Checked := true;
    m_Setting.m_ConfigVisible := Action_Config.Checked;

    UpdateConfigPannel;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ActionChangeStandDateExecute(Sender: TObject);
var
    f_ModalResult:Integer;
    f_Date:TDateTime;
begin
    ChangeStandDateDlg := TChangeStandDateDlg.Create(Application);
    f_ModalResult := ChangeStandDateDlg.ShowModal;

    if ((f_ModalResult = mrOK) OR (f_ModalResult = mrYES)) then
    begin
        f_Date := Trunc(ChangeStandDateDlg.MonthCalendar.Date);
        if (f_Date <= Trunc(Now)) then CMKAVChartControl1.SetStandDate(f_Date);
    end;
    ChangeStandDateDlg.Free;
    ChangeStandDateDlg := NIL;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ActionNextDateExecute(Sender: TObject);
var
    f_Date:TDateTime;
    f_TimeFrame : Integer;
    f_DayCount:Integer;
begin
    f_TimeFrame := g_TimeFrame[m_Setting.m_TimeFrameIndex];

    if (f_TimeFrame >= 9000) then
    begin
        f_DayCount := 1;
    end else
    if (f_TimeFrame <=  1) then
    begin
        f_DayCount := 3;
    end else
    if (f_TimeFrame <=  2) then
    begin
        f_DayCount := 5;
    end else
    if (f_TimeFrame <=  3) then
    begin
        f_DayCount := 10;
    end else
    if (f_TimeFrame <=  5) then
    begin
        f_DayCount := 20;
    end else
    if (f_TimeFrame <= 10) then
    begin
        f_DayCount := 40;
    end else
    if (f_TimeFrame <= 15) then
    begin
        f_DayCount := 60;
    end else
    if (f_TimeFrame <= 20) then
    begin
        f_DayCount := 90;
    end else
    if (f_TimeFrame <= 30) then
    begin
        f_DayCount := 100;
    end else
    if (f_TimeFrame <= 60) then
    begin
        f_DayCount := 200;
    end else
    if (f_TimeFrame <= 360) then
    begin
        f_DayCount := 300;
    end;

    f_Date := CMKAVChartControl1.GetStandDate();

    if (f_Date = 0) then f_Date := Now;
    f_Date := f_Date +  f_DayCount;

    if (f_Date <= Trunc(Now)) then CMKAVChartControl1.SetStandDate(f_Date);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ActionPrevDateExecute(Sender: TObject);
var
    f_Date:TDateTime;
    f_TimeFrame : Integer;
    f_DayCount:Integer;
begin
    f_TimeFrame := g_TimeFrame[m_Setting.m_TimeFrameIndex];

    if (f_TimeFrame >= 9000) then
    begin
        f_DayCount := 1;
    end else
    if (f_TimeFrame <=  1) then
    begin
        f_DayCount := 3;
    end else
    if (f_TimeFrame <=  2) then
    begin
        f_DayCount := 5;
    end else
    if (f_TimeFrame <=  3) then
    begin
        f_DayCount := 10;
    end else
    if (f_TimeFrame <=  5) then
    begin
        f_DayCount := 20;
    end else
    if (f_TimeFrame <= 10) then
    begin
        f_DayCount := 40;
    end else
    if (f_TimeFrame <= 15) then
    begin
        f_DayCount := 60;
    end else
    if (f_TimeFrame <= 20) then
    begin
        f_DayCount := 90;
    end else
    if (f_TimeFrame <= 30) then
    begin
        f_DayCount := 100;
    end else
    if (f_TimeFrame <= 60) then
    begin
        f_DayCount := 200;
    end else
    if (f_TimeFrame <= 360) then
    begin
        f_DayCount := 300;
    end;

    f_Date := CMKAVChartControl1.GetStandDate();

    if (f_Date = 0) then f_Date := Now;
    f_Date := f_Date - f_DayCount;

    if (f_Date <= Trunc(Now)) then CMKAVChartControl1.SetStandDate(f_Date);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.Action_ConfigExecute(Sender: TObject);
begin
    Action_Config.Checked := not Action_Config.Checked;

    m_Setting.m_ConfigVisible := Action_Config.Checked;

    UpdateConfigPannel;
end;
{$ENDREGION}

{$ENDREGION}

{$REGION '하단 리포트'}

{$REGION '하단 리포트의 설정변경'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.ComboBox_SelectedSignalChange(Sender: TObject);
var
    nIndicator : Integer;
    f_ComboBox:TComboBox;
begin
    if not m_ListenEvent then exit;
    if not m_UseChangeEvent then exit;

    f_ComboBox := TComboBox(Sender);

    m_Setting.m_SelectedIndexS := f_ComboBox.ItemIndex;
    UpdateSelectedSignal(false);
    UpdateSelectedSignalOption(false);
    SetSelectedSignalIdentity(m_Setting.m_SelectedIdentityS);
end;

procedure TChildFrame0100.RadioGroup_TradeTypeClick(Sender: TObject);
begin
    InitializeListView_TradeList;
end;
{$ENDREGION}

{$REGION '하단 리포트 데이터 출력'}
procedure TChildFrame0100.ListView_PerformanceCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
var
    Paper : TCanvas;
    pListView : TListView;
    f_Value : CMKPerformanceValue;
begin
    pListView := TListView(Sender);

    Paper := pListView.Canvas;
    f_Value := Item.Data;

    if Assigned(f_Value) AND f_Value.m_SignColor then
    begin
        if (SubItem = 1) then
        begin
            if (f_Value.m_Value > 0) then
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($EE,$00,$00);
            end else
            if (f_Value.m_Value < 0) then
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($00,$00,$EE);
            end else
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($00,$00,$00);
            end;
        end;
    end;
    DefaultDraw := TRUE;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.Action_SaveReportExecute(Sender: TObject);
var
    f_Index : Integer;
    f_Precision:Integer;
    f_Value : CMKPerformanceValue;
    f_MaterialItem : CFNMaterialItem;
    f_Stream:TStringStream;
begin
    if SaveDialog.Execute then
    begin
        if ExtractFileExt(SaveDialog.FileName) = '' then
        begin
            SaveDialog.FileName := SaveDialog.FileName + '.csv';
        end;

        f_Stream := TStringStream.Create;
        for f_Index := 0 to m_PerformanceValueArray.m_Items.Count - 1 do
        begin
            f_Value := m_PerformanceValueArray.m_Items[f_Index];
            if f_Value = NIL then continue;

            if f_Value.m_Precision = -1 then
            begin
                f_Precision := 2;
                if Assigned(g_MaterialCollection) then
                begin
                    f_MaterialItem := g_MaterialCollection.Find(m_SelectedSymbolItem.m_Country, m_SelectedSymbolItem.m_Group, m_SelectedSymbolItem.m_Market, m_SelectedSymbolItem.m_Symbol);
                    if Assigned(f_MaterialItem) then
                    begin
                        f_Precision := f_MaterialItem.m_Precision;
                    end;
                end;
            end else
            begin
                f_Precision := f_Value.m_Precision;
            end;
            f_Stream.WriteString(Format('%s, %.*n', [f_Value.m_Name, f_Precision, f_Value.m_Value]) + f_Value.m_Unit + #$0A);
        end;

        f_Stream.SaveToFile(SaveDialog.FileName);
        f_Stream.Free;
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.Action_SaveTradeListExecute(Sender: TObject);
var
    f_Index : Integer;
    f_Precision:Integer;
    f_TradeData : CMKTradeData;
    f_MaterialItem : CFNMaterialItem;
    f_TradeArray : CMKTradeArray;
    f_Stream:TStringStream;
begin
    if SaveDialog.Execute then
    begin
        if ExtractFileExt(SaveDialog.FileName) = '' then
        begin
            SaveDialog.FileName := SaveDialog.FileName + '.csv';
        end;

        f_Precision := 2;
        if Assigned(g_MaterialCollection) then
        begin
            f_MaterialItem := g_MaterialCollection.Find(m_SelectedSymbolItem.m_Country, m_SelectedSymbolItem.m_Group, m_SelectedSymbolItem.m_Market, m_SelectedSymbolItem.m_Symbol);
            if Assigned(f_MaterialItem) then
            begin
                f_Precision := f_MaterialItem.m_Precision;
            end;
        end;

        f_Stream := TStringStream.Create;

        if RadioGroup_TradeType.ItemIndex = 0 then f_TradeArray := m_TradeSystemManager.m_LongTradeArray
        else if RadioGroup_TradeType.ItemIndex = 1 then f_TradeArray := m_TradeSystemManager.m_ShortTradeArray
        else f_TradeArray := m_TradeSystemManager.m_AllTradeArray;

        for f_Index := 0 to f_TradeArray.m_Items.Count - 1 do
        begin
            f_TradeData := f_TradeArray.m_Items[f_Index];
            if f_TradeData = NIL then continue;

            f_Stream.WriteString(IntToStr(f_Index+1) + ',');

            if f_TradeData.m_Signal = SIGNAL_SELLENTER then
            begin
                f_Stream.WriteString('SELL' + ',');
            end else
            if f_TradeData.m_Signal = SIGNAL_BUYENTER then
            begin
                f_Stream.WriteString('BUY' + ',');
            end;

            if g_TimeFrame[m_Setting.m_TimeFrameIndex] > 9000 then
            begin
                f_Stream.WriteString(TMKGlobal.DateTimeToStr32(f_TradeData.m_EnterDateTime) + ',');
                f_Stream.WriteString(TMKGlobal.DateTimeToStr32(f_TradeData.m_ExitDateTime) + ',');
            end else
            if g_TimeFrame[m_Setting.m_TimeFrameIndex] < 360 then
            begin
                f_Stream.WriteString(TMKGlobal.DateTimeToStr31(f_TradeData.m_EnterDateTime) + ',');
                f_Stream.WriteString(TMKGlobal.DateTimeToStr31(f_TradeData.m_ExitDateTime) + ',');
            end else
            begin
                f_Stream.WriteString(TMKGlobal.DateTimeToStr31(f_TradeData.m_EnterDateTime) + ',');
                f_Stream.WriteString(TMKGlobal.DateTimeToStr31(f_TradeData.m_ExitDateTime) + ',');
            end;

            f_Stream.WriteString(Format('%.*n,'    , [f_Precision, f_TradeData.m_Profit]));
            f_Stream.WriteString(Format('%.*n%%,'  , [1, f_TradeData.m_ProfitRatio]));

            f_Stream.WriteString(Format('%.*n,'    , [f_Precision, f_TradeData.m_Cumulative]));
            f_Stream.WriteString(Format('%.*n%%,'  , [1, f_TradeData.m_AvgProfitRatio]));

            f_Stream.WriteString(Format('%.*n,'    , [f_Precision, f_TradeData.m_EnterPrice]));
            f_Stream.WriteString(Format('%.*n'     , [f_Precision, f_TradeData.m_ExitPrice]));
            f_Stream.WriteString(#$0A);
        end;

        f_Stream.SaveToFile(SaveDialog.FileName);
        f_Stream.Free;
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ListView_PerformanceData(Sender: TObject; Item: TListItem);
var
    f_Value : CMKPerformanceValue;
    nItemIndex : Integer;
    f_Precision:Integer;
    f_MaterialItem : CFNMaterialItem;
begin
    if ((Item.Index < 0) or (Item.Index >= m_PerformanceValueArray.m_Items.Count)) then exit;
    try
        nItemIndex := Item.Index ;
        f_Value := m_PerformanceValueArray.m_Items[nItemIndex];
        if f_Value = NIL then exit;

        if f_Value.m_Precision = -1 then
        begin
            f_Precision := 2;
            if Assigned(g_MaterialCollection) then
            begin
                f_MaterialItem := g_MaterialCollection.Find(m_SelectedSymbolItem.m_Country, m_SelectedSymbolItem.m_Group, m_SelectedSymbolItem.m_Market, m_SelectedSymbolItem.m_Symbol);
                if Assigned(f_MaterialItem) then
                begin
                    f_Precision := f_MaterialItem.m_Precision;
                end;
            end;
        end else
        begin
            f_Precision := f_Value.m_Precision;
        end;

        Item.Caption := f_Value.m_Name;
        Item.SubItems.Add(Format('%.*n', [f_Precision, f_Value.m_Value]) + f_Value.m_Unit);
        Item.Data := f_Value;
    except
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.InitializeListView_TradeList;
var
    nCount : Integer;
    f_TradeArray : CMKTradeArray;
begin
    if RadioGroup_TradeType.ItemIndex = 0 then f_TradeArray := m_TradeSystemManager.m_LongTradeArray
    else if RadioGroup_TradeType.ItemIndex = 1 then f_TradeArray := m_TradeSystemManager.m_ShortTradeArray
    else f_TradeArray := m_TradeSystemManager.m_AllTradeArray;

    f_TradeArray.WriteReport(Memo_TradeReport.Lines);
    f_TradeArray.WritePrformance(m_PerformanceValueArray);

    ListView_Performance.Items.Count := 0;
    ListView_Performance.Items.Count := m_PerformanceValueArray.m_Items.Count;

    if Assigned(f_TradeArray) then
    begin
        nCount := f_TradeArray.m_Items.Count;
        ListView_TradeList.Items.Count := 0;
        ListView_TradeList.Items.Count := nCount;
        ListView_TradeList.Repaint;
    end else
    begin
        ListView_TradeList.Items.Count := 0;
        ListView_TradeList.Repaint;
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ListView_TradeListCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
    DefaultDraw := true;

end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ListView_TradeListCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
var
    Paper : TCanvas;
    pListView : TListView;
    f_TradeData : CMKTradeData;
begin
    pListView := TListView(Sender);

    Paper := pListView.Canvas;
    f_TradeData := Item.Data;

    if Assigned(f_TradeData) then
    begin
        if (SubItem = 4) then
        begin
            if (f_TradeData.m_Profit > 0) then
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($EE,$00,$00);
            end else
            if (f_TradeData.m_Profit < 0) then
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($00,$00,$EE);
            end else
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($00,$00,$00);
            end;
        end else
        if (SubItem = 5) then
        begin
            if (f_TradeData.m_ProfitRatio > 0) then
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($EE,$00,$00);
            end else
            if (f_TradeData.m_ProfitRatio < 0) then
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($00,$00,$EE);
            end else
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($00,$00,$00);
            end;
        end else
        if (SubItem = 6) then
        begin
            if (f_TradeData.m_Cumulative > 0) then
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($EE,$00,$00);
            end else
            if (f_TradeData.m_Cumulative < 0) then
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($00,$00,$EE);
            end else
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($00,$00,$00);
            end;
        end else
        if (SubItem = 7) then
        begin
            if (f_TradeData.m_AvgProfitRatio > 0) then
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($EE,$00,$00);
            end else
            if (f_TradeData.m_AvgProfitRatio < 0) then
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($00,$00,$EE);
            end else
            begin
                Paper.Font.Color := clWhite;
                Paper.Font.Color := RGB($00,$00,$00);
            end;
        end else
        begin
            Paper.Font.Color := clWhite;
            Paper.Font.Color := clBlack;
        end;
    end;
    DefaultDraw := TRUE;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ListView_TradeListData(Sender: TObject; Item: TListItem);
var
    f_TradeData : CMKTradeData;
    nItemIndex : Integer;
    f_MaterialItem : CFNMaterialItem;
    f_Precision:Integer;
    f_TradeArray : CMKTradeArray;
begin
    if not Assigned(m_SelectedSymbolItem) then exit;

    if RadioGroup_TradeType.ItemIndex = 0 then f_TradeArray := m_TradeSystemManager.m_LongTradeArray
    else if RadioGroup_TradeType.ItemIndex = 1 then f_TradeArray := m_TradeSystemManager.m_ShortTradeArray
    else f_TradeArray := m_TradeSystemManager.m_AllTradeArray;

    if ((Item.Index < 0) or (Item.Index >= f_TradeArray.m_Items.Count)) then exit;
    try
        nItemIndex := f_TradeArray.m_Items.Count - Item.Index - 1;

        f_TradeData := f_TradeArray.m_Items[nItemIndex];

        if f_TradeData = NIL then exit;

        Item.Caption := IntToStr(nItemIndex+1);

        if f_TradeData.m_Signal = SIGNAL_SELLENTER then
        begin
            Item.SubItems.Add('매도');
        end else
        if f_TradeData.m_Signal = SIGNAL_BUYENTER then
        begin
            Item.SubItems.Add('매수');
        end;

        if g_TimeFrame[m_Setting.m_TimeFrameIndex] > 9000 then
        begin
            Item.SubItems.Add(TMKGlobal.DateTimeToStr32(f_TradeData.m_EnterDateTime));
            Item.SubItems.Add(TMKGlobal.DateTimeToStr32(f_TradeData.m_ExitDateTime));
        end else
        if g_TimeFrame[m_Setting.m_TimeFrameIndex] < 360 then
        begin
            Item.SubItems.Add(TMKGlobal.DateTimeToStr31(f_TradeData.m_EnterDateTime));
            Item.SubItems.Add(TMKGlobal.DateTimeToStr31(f_TradeData.m_ExitDateTime));
        end else
        begin
            Item.SubItems.Add(TMKGlobal.DateTimeToStr31(f_TradeData.m_EnterDateTime));
            Item.SubItems.Add(TMKGlobal.DateTimeToStr31(f_TradeData.m_ExitDateTime));
        end;

        f_Precision := 2;
        if Assigned(g_MaterialCollection) then
        begin
            f_MaterialItem := g_MaterialCollection.Find(m_SelectedSymbolItem.m_Country, m_SelectedSymbolItem.m_Group, m_SelectedSymbolItem.m_Market, m_SelectedSymbolItem.m_Symbol);
            if Assigned(f_MaterialItem) then
            begin
                f_Precision := f_MaterialItem.m_Precision;
            end;
        end;

        Item.SubItems.Add(Format('%.*n', [f_Precision, f_TradeData.m_Profit]));
        Item.SubItems.Add(Format('%.*n%%', [1, f_TradeData.m_ProfitRatio]));

        Item.SubItems.Add(Format('%.*n', [f_Precision, f_TradeData.m_Cumulative]));
        Item.SubItems.Add(Format('%.*n%%', [1, f_TradeData.m_AvgProfitRatio]));

        Item.SubItems.Add(Format('%.*n', [f_Precision, f_TradeData.m_EnterPrice]));
        Item.SubItems.Add(Format('%.*n', [f_Precision, f_TradeData.m_ExitPrice]));

        Item.Data := f_TradeData;
    except
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ListView_TradeListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
    f_TradeData : CMKTradeData;
begin
    if Selected then
    begin
        f_TradeData := Item.Data;
        if f_TradeData.m_Signal = SIGNAL_SELLENTER then CMKAVChartControl1.SignalTrace(0, -1, f_TradeData.m_EnterDateTime, f_TradeData.m_ExitDateTime)
        else CMKAVChartControl1.SignalTrace(0, 1, f_TradeData.m_EnterDateTime, f_TradeData.m_ExitDateTime);
    end;
end;
{$ENDREGION}

{$REGION '하단시스템 리포트의 레이아웃'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.UpdateBuySellReportPannel;
begin
    if m_Setting.m_BuySellReport then
    begin
        Panel_Report.Height := m_ReportPanelHeigh;
        SpeedButton_HideReport.Visible := true;
        Panel_ReportSmallView.Visible := false;
        Splitter_Report.Visible := true;
        //Splitter_Report.Top := Panel_Report.Top;
        Panel_Report.Top := Splitter_Report.Top + Splitter_Report.Height + 1;
    end else
    begin
        SpeedButton_HideReport.Visible := false;
        if (Panel_Report.Height <> 11) then m_ReportPanelHeigh := Panel_Report.Height;
        Panel_Report.Height := 11;

        Panel_ReportSmallView.Left := 0;
        Panel_ReportSmallView.Top := 0;
        Panel_ReportSmallView.Width := Panel_Report.Width;
        Panel_ReportSmallView.Height := Panel_Report.Height;
        Panel_ReportSmallView.Visible := true;

        Splitter_Report.Visible := false;
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.Panel_ReportResize(Sender: TObject);
begin
    Panel_ReportSmallView.Left := 0;
    Panel_ReportSmallView.Top := 0;
    Panel_ReportSmallView.Width := Panel_Report.Width;
    Panel_ReportSmallView.Height := Panel_Report.Height;

    if Panel_Report.Width < 700 then
    begin
        ComboBox_SelectedSignal2.Visible := false;
    end else
    begin
        ComboBox_SelectedSignal2.Visible := true;
    end;
end;


procedure TChildFrame0100.Action_ShowHideTradeRepotExecute(Sender: TObject);
begin
    Action_ShowHideTradeRepot.Checked := not Action_ShowHideTradeRepot.Checked;
    m_Setting.m_BuySellReport := Action_ShowHideTradeRepot.Checked;
    UpdateBuySellReportPannel;
    if m_Setting.m_BuySellReport then
    begin
        Action_Config.Checked := true;
        m_Setting.m_ConfigVisible := true;
        UpdateConfigPannel;
        CategoryPanel1.Collapsed := true;
        CategoryPanel2.Collapsed := true;
        CategoryPanel3.Collapsed := true;
        CategoryPanel4.Collapsed := false;
        CategoryPanel5.Collapsed := true;
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.SpeedButton_HideReportClick(Sender: TObject);
begin
    m_ReportPanelHeigh := Panel_Report.Height;
    Panel_Report.Height := 11;

    SpeedButton_HideReport.Visible := false;

    Panel_ReportSmallView.Left := 0;
    Panel_ReportSmallView.Top := 0;
    Panel_ReportSmallView.Width := Panel_Report.Width;
    Panel_ReportSmallView.Height := Panel_Report.Height;
    Panel_ReportSmallView.Visible := true;

    Splitter_Report.Visible := false;
    Action_ShowHideTradeRepot.Checked := FALSE;
    m_Setting.m_BuySellReport := FALSE;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.SpeedButton_ShowReportClick(Sender: TObject);
begin
    Panel_Report.Height := m_ReportPanelHeigh;
    SpeedButton_HideReport.Visible := true;
    Panel_ReportSmallView.Visible := false;
    Splitter_Report.Visible := true;
    //Splitter_Report.Top := Panel_Report.Top;
    Panel_Report.Top := Splitter_Report.Top + Splitter_Report.Height + 1;

    Action_ShowHideTradeRepot.Checked := true;
    m_Setting.m_BuySellReport := true;
end;
{$ENDREGION}

{$ENDREGION}

{$REGION '추세선'}
procedure TChildFrame0100.OnDrawObjectClick(Sender: TObject);
begin
    if (TAction(Sender) = DrawLine) then
    begin
        CMKAVChartControl1.EndDrawObject();
        CMKAVChartControl1.StartDrawObject(CMKAVDrawingObject.DOT_TRENDLINE);
    end
    else if (TAction(Sender) = DrawHLine) then
    begin
        CMKAVChartControl1.EndDrawObject();
        CMKAVChartControl1.StartDrawObject(CMKAVDrawingObject.DOT_HORIZONLINE);
    end
    else if (TAction(Sender) = DrawVLine) then
    begin
        CMKAVChartControl1.EndDrawObject();
        CMKAVChartControl1.StartDrawObject(CMKAVDrawingObject.DOT_VERTICALLINE);
    end
    else if (TAction(Sender) = DrawCLine) then
    begin
        CMKAVChartControl1.EndDrawObject();
        CMKAVChartControl1.StartDrawObject(CMKAVDrawingObject.DOT_CROSSLINE);
    end
    else if (TAction(Sender) = DrawRectangle) then
    begin
        CMKAVChartControl1.EndDrawObject();
        CMKAVChartControl1.StartDrawObject(CMKAVDrawingObject.DOT_RECTANGLE);
    end
    else if (TAction(Sender) = DrawCircle) then
    begin
        CMKAVChartControl1.EndDrawObject();
        CMKAVChartControl1.StartDrawObject(CMKAVDrawingObject.DOT_CIRCLE);
    end
    else if (TAction(Sender) = DrawTirone) then
    begin
        CMKAVChartControl1.EndDrawObject();
        CMKAVChartControl1.StartDrawObject(CMKAVDrawingObject.DOT_SPLIT3);
    end
    else if (TAction(Sender) = DrawQuadrant) then
    begin
        CMKAVChartControl1.EndDrawObject();
        CMKAVChartControl1.StartDrawObject(CMKAVDrawingObject.DOT_SPLIT4);
    end
    else if (TAction(Sender) = DrawSpeedLine) then
    begin
        CMKAVChartControl1.EndDrawObject();
        CMKAVChartControl1.StartDrawObject(CMKAVDrawingObject.DOT_SPEEDLINE);
    end
    else if (TAction(Sender) = DrawFFan) then
    begin
        CMKAVChartControl1.EndDrawObject();
        CMKAVChartControl1.StartDrawObject(CMKAVDrawingObject.DOT_GANNFAN);
    end
    else if (TAction(Sender) = DrawFRetracement) then
    begin
        CMKAVChartControl1.EndDrawObject();
        CMKAVChartControl1.StartDrawObject(CMKAVDrawingObject.DOT_FIBONACCIRETRACEMENT);
    end
    else if (TAction(Sender) = DrawTimeZone) then
    begin
        CMKAVChartControl1.EndDrawObject();
        CMKAVChartControl1.StartDrawObject(CMKAVDrawingObject.DOT_FIBONACCITIMEZONE);
    end
    else if (TAction(Sender) = DrawAFP) then
    begin
        CMKAVChartControl1.EndDrawObject();
        CMKAVChartControl1.StartDrawObject(CMKAVDrawingObject.DOT_ANDREWSPITCHFORK);
    end
    else if (TAction(Sender) = DrawEraser) then
    begin
        CMKAVChartControl1.EndDrawObject();
        CMKAVChartControl1.StartDrawObject(CMKAVDrawingObject.DOT_ERASER);
    end
    else if (TAction(Sender) = DrawText) then
    begin
        StartDrawingCharObject();
    end
    else if (TAction(Sender) = DrawColor) then
    begin
        //CMKAVChartControl1.SetDrawObjectColor(Color32(m_btnColor.SymbolColor));
    end
    else
    begin

    end;
end;

procedure TChildFrame0100.StartDrawingCharObject();
var
    dlg : TTextInputDlg;
    f_Text : String;
    f_font : TFont;
    f_Result : Integer;
begin
    dlg := TTextInputDlg.Create(Self);

    f_Result := dlg.ShowModal();
    if (f_Result = mrOk) then
    begin
        f_Text := dlg.m_TextInput.Text;
        f_font := dlg.GetFontStyle();

        if (0 < dlg.m_TextInput.Lines.Count) then
        begin
            CMKAVChartControl1.EndDrawObject();
            CMKAVChartControl1.StartDrawingCharObject(dlg.m_TextInput.Lines, f_font);
        end;
    end;

    dlg.Free();
end;

{$ENDREGION}

{$REGION '매매전략'}
//---------------------------------------------------------------------------
procedure TChildFrame0100.ComboBoxTradeStrategyChange(Sender: TObject);
var
    f_Frame:TTradeStrategyFrame;
    f_FrameOptionCategory:String;
    f_Index:Integer;
begin
    if (not m_ListenEvent) then exit;
    if not m_UseChangeEvent then exit;
    if (ComboBoxTradeStrategy.ItemIndex < 0) then exit;
    if (ComboBoxTradeStrategy.ItemIndex >= m_TradeStrategyFrameCount) then exit;

    PageControlStrategy.ActivePageIndex := ComboBoxTradeStrategy.ItemIndex;
    f_Frame := m_TradeStrategyFrame[ComboBoxTradeStrategy.ItemIndex];

    if Assigned(m_SelectedTradeStrategy) then
    begin
        f_FrameOptionCategory := f_Frame.Option.GetStringValue(TSOPTION_KEY_CATEGORY);
        if m_SelectedTradeStrategy.Option.GetStringValue(TSOPTION_KEY_CATEGORY) <> f_FrameOptionCategory then
        begin
            for f_Index := 0 to m_TradeStrategyFrameCount - 1 do
            begin
                m_TradeStrategyFrame[f_Index].ReinforceFrame := NIL;
            end;
            f_Frame.ReinforceFrame := m_REINFORCE_Frame;
            f_Frame.SetAllControlData;
            DisplayTradeStrategy(f_Frame.Option);
        end;
    end else
    begin
        DisplayTradeStrategy(f_Frame.Option);
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.CheckBoxUseStrategyClick(Sender: TObject);
var
    f_Index : Integer;
begin
    if (not m_ListenEvent) then exit;
    if not m_UseChangeEvent then exit;
    if ComboBoxTradeStrategy.Items.Count = 0 then exit;

    m_ListenEvent := false;
    try
        if CheckBoxUseTradeStrategy.Checked then
        begin
            m_VisibleTradeStrategy := true;
            ComboBoxTradeStrategy.Enabled := true;
            if (ComboBoxTradeStrategy.ItemIndex < 0) then
            begin
                ComboBoxTradeStrategy.ItemIndex := 0;
            end;
            PageControlStrategy.ActivePageIndex := ComboBoxTradeStrategy.ItemIndex;
            PageControlStrategyConfig.Visible := true;

            for f_Index := 0 to m_TradeStrategyFrameCount - 1 do
            begin
                m_TradeStrategyFrame[f_Index].ReinforceFrame := NIL;
            end;

            m_TradeStrategyFrame[ComboBoxTradeStrategy.ItemIndex].ReinforceFrame := m_REINFORCE_Frame;
            m_TradeStrategyFrame[ComboBoxTradeStrategy.ItemIndex].SetAllControlData;

            DisplayTradeStrategy(m_TradeStrategyFrame[ComboBoxTradeStrategy.ItemIndex].Option);
        end else
        begin
            m_VisibleTradeStrategy := false;
            ComboBoxTradeStrategy.Enabled := false;
            PageControlStrategyConfig.Visible := false;
            CMKAVChartControl1.DeleteTradeStrategy();
            if Assigned(m_SelectedTradeStrategy) then
            begin
                m_SelectedTradeStrategy.Free;
                m_SelectedTradeStrategy := NIL;
            end;
        end;
    finally
        m_ListenEvent := true;
    end;

    ScanSignal;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.OnChangedTradeStrategyOption(Sender: TObject);
var
    f_Index : Integer;
    f_Frame:TTradeStrategyFrame;
    f_FrameOptionCategory:String;
begin
    if not Assigned(m_SelectedTradeStrategy) then exit;

    f_Frame := TTradeStrategyFrame(Sender);

    f_Frame.GetAllControlData;
    f_Frame.SetAllControlData;

    f_FrameOptionCategory := f_Frame.Option.GetStringValue(TSOPTION_KEY_CATEGORY);
    if m_SelectedTradeStrategy.Option.GetStringValue(TSOPTION_KEY_CATEGORY) = f_FrameOptionCategory then
    begin
        m_SelectedTradeStrategy.Option := f_Frame.Option;
        m_TradingHour_Frame.CopyOption(m_SelectedTradeStrategy.Option);
        m_Random_Frame.CopyOption(m_SelectedTradeStrategy.Option);
        m_ENTER_Frame.CopyOption(m_SelectedTradeStrategy.Option);
        m_EXIT_Frame.CopyOption(m_SelectedTradeStrategy.Option);
        ApplySymbolInfoToTradeStrategyOption;
        CMKAVChartControl1.ChangeTradeStrategy(m_SelectedTradeStrategy);
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.OnChangedTradeStrategyReinforce(Sender: TObject);
var
    f_Frame:TTradeStrategyFrame;
    f_FrameOptionCategory:String;
begin
    if not Assigned(m_SelectedTradeStrategy) then exit;
    if ComboBoxTradeStrategy.ItemIndex < 0 then exit;
    if ComboBoxTradeStrategy.ItemIndex >= m_TradeStrategyFrameCount then exit;

    f_Frame := m_TradeStrategyFrame[ComboBoxTradeStrategy.ItemIndex];
    if not Assigned(f_Frame) then exit;

    f_Frame.GetAllControlData;
    f_Frame.SetAllControlData;

    f_FrameOptionCategory := f_Frame.Option.GetStringValue(TSOPTION_KEY_CATEGORY);
    if m_SelectedTradeStrategy.Option.GetStringValue(TSOPTION_KEY_CATEGORY) = f_FrameOptionCategory then
    begin
        m_SelectedTradeStrategy.Option := f_Frame.Option;
        m_TradingHour_Frame.CopyOption(m_SelectedTradeStrategy.Option);
        m_Random_Frame.CopyOption(m_SelectedTradeStrategy.Option);
        m_ENTER_Frame.CopyOption(m_SelectedTradeStrategy.Option);
        m_EXIT_Frame.CopyOption(m_SelectedTradeStrategy.Option);
        ApplySymbolInfoToTradeStrategyOption;
        CMKAVChartControl1.ChangeTradeStrategy(m_SelectedTradeStrategy);
    end;
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.OnChangedGab(Sender: TObject);
begin
    if not Assigned(m_SelectedTradeStrategy) then exit;

    m_TradingHour_Frame.CopyOption(m_SelectedTradeStrategy.Option);

    m_TradingHour_Frame.CopyOption(m_SelectedTradeStrategy.Option);
    m_Random_Frame.CopyOption(m_SelectedTradeStrategy.Option);
    m_ENTER_Frame.CopyOption(m_SelectedTradeStrategy.Option);
    m_EXIT_Frame.CopyOption(m_SelectedTradeStrategy.Option);
    ApplySymbolInfoToTradeStrategyOption;
    CMKAVChartControl1.ChangedGabProcess(m_SelectedTradeStrategy);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.OnChangedTradingHour(Sender: TObject);
begin
    if not Assigned(m_SelectedTradeStrategy) then exit;

    m_TradingHour_Frame.CopyOption(m_SelectedTradeStrategy.Option);
    m_Random_Frame.CopyOption(m_SelectedTradeStrategy.Option);
    m_ENTER_Frame.CopyOption(m_SelectedTradeStrategy.Option);
    m_EXIT_Frame.CopyOption(m_SelectedTradeStrategy.Option);
    ApplySymbolInfoToTradeStrategyOption;
    CMKAVChartControl1.ChangeTradeStrategy(m_SelectedTradeStrategy);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.ApplySymbolInfoToTradeStrategyOption;
begin
    if not Assigned(m_SelectedTradeStrategy) then exit;

    if not Assigned(m_SelectedSymbolItem) then exit;

    m_SelectedTradeStrategy.Option.SetIntegerValue('COUNTRY_NO', m_SelectedSymbolItem.m_Country);
    m_SelectedTradeStrategy.Option.SetIntegerValue('GROUP_NO'  , m_SelectedSymbolItem.m_Group);
    m_SelectedTradeStrategy.Option.SetIntegerValue('MARKET_NO' , m_SelectedSymbolItem.m_Market);
    m_SelectedTradeStrategy.Option.SetStringValue('SYMBOL'     , m_SelectedSymbolItem.m_Symbol);
    m_SelectedTradeStrategy.Option.SetStringValue('SEC_SYMBOL' , m_SelectedSymbolItem.m_SecSymbol);
    m_SelectedTradeStrategy.Option.SetStringValue('CONTRACT'   , m_SelectedSymbolItem.m_Contract);
end;

//---------------------------------------------------------------------------
procedure TChildFrame0100.DisplayTradeStrategy(AOption: CMXTradeStrategyOption);
var
    f_OldSelectedTradeStrategy : CMXTradeStrategy;
begin
    if Assigned(m_SelectedTradeStrategy) then
    begin
        if m_SelectedTradeStrategy.Option.GetStringValue(TSOPTION_KEY_CATEGORY) = AOption.GetStringValue(TSOPTION_KEY_CATEGORY) then
        begin
            exit;
        end;
    end;

    f_OldSelectedTradeStrategy := m_SelectedTradeStrategy;
    m_SelectedTradeStrategy := NIL;

    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'STC-T1' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategySTC_T1.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'STC-T2' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategySTC_T2.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'STC-T3' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategySTC_T3.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'STC-N1' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategySTC_N1.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'STC-N2' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategySTC_N2.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'RSI-T1' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyRSI_T1.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'RSI-N1' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyRSI_N1.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'BB-T1' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyBB_T1.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'DISPARITY-T1' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyDISPARITY_T1.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'DISPARITY-N1' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyDISPARITY_N1.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'BASELINE-T1' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyBASELINE_T1.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'BASELINE-T2' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyBASELINE_T2.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'BASELINE-N1' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyBASELINE_N1.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'IM-T1' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyIM_T1.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'IM-T2' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyIM_T2.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'IM-T3' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyIM_T3.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'MOV-T1' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyMOV_T1.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'MOV-T2' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyMOV_T2.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'MOV-T3' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyMOV_T3.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'MOV-N1' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyMOV_N1.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'MOV-N2' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyMOV_N2.Create;
    end else
    if AOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'REL-T1' then
    begin
        m_SelectedTradeStrategy := CMXTradeStrategyREL_T1.Create;
    end else
    begin
        m_SelectedTradeStrategy := NIL;
    end;

    if Assigned(m_SelectedTradeStrategy) then
    begin
        m_SelectedTradeStrategy.Option := AOption;
        m_TradingHour_Frame.CopyOption(m_SelectedTradeStrategy.Option);
        m_Random_Frame.CopyOption(m_SelectedTradeStrategy.Option);
        m_ENTER_Frame.CopyOption(m_SelectedTradeStrategy.Option);
        m_EXIT_Frame.CopyOption(m_SelectedTradeStrategy.Option);

        ApplySymbolInfoToTradeStrategyOption;
        CMKAVChartControl1.AddTradeStrategy(m_SelectedTradeStrategy);
    end;

    if Assigned(f_OldSelectedTradeStrategy) then
    begin
        f_OldSelectedTradeStrategy.Free;
        f_OldSelectedTradeStrategy := NIL;
    end;
end;
{$ENDREGION}

end.





