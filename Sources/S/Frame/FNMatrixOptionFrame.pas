unit FNMatrixOptionFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, FNAgentManager, FNDataDelivery,
  FNDataSet, CommonTRMaker,
  MXOption, MXBlock, pngimage,
  COND_Enter_Frame, COND_Exit_Frame, COND_Random_Frame, COND_TradingHour_Frame,
  COND_REINFORCE_Frame,
  TSREL_T1_Frame, TSMOV_N2_Frame, TSMOV_N1_Frame, TSMOV_T3_Frame,
  TSMOV_T2_Frame,
  TSMOV_T1_Frame, TSIM_T3_Frame, TSIM_T2_Frame, TSIM_T1_Frame,
  TSBASELINE_N1_Frame, TSBASELINE_T2_Frame,
  TSBASELINE_T1_Frame, TSDISPARITY_N1_Frame, TSDISPARITY_T1_Frame,
  TSBB_T1_Frame, TSRSI_N1_Frame, TSRSI_T1_Frame,
  TSSTC_N2_Frame, TSSTC_N1_Frame, TSSTC_T3_Frame, TSSTC_T2_Frame,
  MXTradeStrategyFrame, TSSTC_T1_Frame, Menus,

  MXTradeStrategyOptionCollection,
  MXTradeStrategy;

type
  TMatrixOptionFrame = class(TFrame)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    ComboBoxTradeStrategy: TComboBox;
    Panel11: TPanel;
    PageControlStrategyConfig: TPageControl;
    TabSheetCFG01: TTabSheet;
    TabSheetCFG02: TTabSheet;
    Panel2: TPanel;
    m_Random_Frame: TRandom_Frame;
    TabSheetCFG03: TTabSheet;
    Panel13: TPanel;
    m_EXIT_Frame: TExit_Frame;
    TabSheetCFG04: TTabSheet;
    Panel14: TPanel;
    m_ENTER_Frame: TENTER_Frame;
    Panel3: TPanel;
    Panel7: TPanel;
    GroupBox8: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    Label22: TLabel;
    EditTICK_COUNT: TEdit;
    EditTICK_STEP: TEdit;
    UpDownTICK_COUNT: TUpDown;
    RadioGroupSYSTEM_MODE: TRadioGroup;
    GroupBox6: TGroupBox;
    LabelACCOUNT_pw: TLabel;
    LabelACCOUNT_NO: TLabel;
    EditACCOUNT_PW: TEdit;
    ComboBoxACCOUNT_NO: TComboBox;
    GroupBox10: TGroupBox;
    Label18: TLabel;
    EditBLOCK_NAME: TEdit;
    GroupBox9: TGroupBox;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    ComboBoxTIMEFRAME: TComboBox;
    GroupBox1: TGroupBox;
    LabelSYMBOL: TLabel;
    Label6: TLabel;
    ComboBoxSYMBOL: TComboBox;
    EditORDER_SYMBOL: TEdit;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    ComboBoxORDER_TYPE: TComboBox;
    EditORDER_COUNT: TEdit;
    UpDownORDER_COUNT: TUpDown;
    GroupBox15: TGroupBox;
    DateTimePickerSTAND_DATE: TDateTimePicker;
    CheckBoxUSE_STAND_DATE: TCheckBox;
    GroupBox14: TGroupBox;
    CheckBoxACTION_ON_START: TCheckBox;
    CheckBoxNOTRADE_FIRST_SIGNAL: TCheckBox;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    DateTimePickerSTOP_TIME: TDateTimePicker;
    DateTimePickerSTART_TIME: TDateTimePicker;
    EditSTOP_OFFSET: TEdit;
    UpDownSTOP_OFFSET: TUpDown;
    UpDownSTART_OFFSET: TUpDown;
    EditSTART_OFFSET: TEdit;
    GroupBox7: TGroupBox;
    Label15: TLabel;
    Label19: TLabel;
    DateTimePickerREGULAR_STOP_TIME: TDateTimePicker;
    DateTimePickerREGULAR_START_TIME: TDateTimePicker;
    CheckBoxUSE_REGULAR_MARKET: TCheckBox;
    Panel5: TPanel;
    Panel6: TPanel;
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
    TabSheet160: TTabSheet;
    MOV_T1_Frame1: TMOV_T1_Frame;
    TabSheet170: TTabSheet;
    MOV_T2_Frame1: TMOV_T2_Frame;
    TabSheet180: TTabSheet;
    MOV_T3_Frame1: TMOV_T3_Frame;
    TabSheet190: TTabSheet;
    MOV_N1_Frame1: TMOV_N1_Frame;
    TabSheet200: TTabSheet;
    MOV_N2_Frame1: TMOV_N2_Frame;
    TabSheetX210: TTabSheet;
    REL_T1_Frame1: TREL_T1_Frame;
    TabSheet14: TTabSheet;
    m_REINFORCE_Frame: TREINFORCE_Frame;
    Panel15: TPanel;
    Panel16: TPanel;
    Label109: TLabel;
    Label110: TLabel;
    EditSECOND_ORDER_DELAY_TIME: TEdit;
    UpDownSECOND_ORDER_DELAY_TIME: TUpDown;
    Label112: TLabel;
    Label111: TLabel;
    LabelACCOUNT_NAME: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    PanelHide: TPanel;
    GroupBox12: TGroupBox;
    Label13: TLabel;
    EditGAB_INSERT_MIN: TEdit;
    UpDownGAB_INSERT_MIN: TUpDown;
    Panel21: TPanel;
    PanelClear: TPanel;
    GroupBox11: TGroupBox;
    CheckBoxUSE_RISK_MAX_LOSS: TCheckBox;
    EditRISK_MAX_LOSS: TEdit;
    CheckBoxUSE_RISK_MAX_PROFIT: TCheckBox;
    EditRISK_MAX_PROFIT: TEdit;
    CheckBoxUSE_REALTIME_RISK_CHECK: TCheckBox;
    CheckBoxUSER_GAB_PROCESS: TCheckBox;
    procedure RadioGroupSIGNAL_MERGE_TYPEClick(Sender: TObject);
    procedure OptionChange(Sender: TObject);

    procedure RadioGroupSYSTEM_MODEClick(Sender: TObject);
    procedure EditBLOCK_NAMEKeyPress(Sender: TObject; var Key: Char);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure ComboBoxSYMBOLChange(Sender: TObject);
    procedure ComboBoxTradeStrategyChange(Sender: TObject);
    procedure Panel3Click(Sender: TObject);

  private
    m_EnableControl: Boolean;
    m_EnableEvent: Boolean;
    m_Block: CMXBlock;

    m_OnChangedOption: TNotifyEvent;
    m_SelectedTradeStrategyOption: CMXTradeStrategyOption;

    m_TradeStrategyFrame: Array [0 .. 47] of TTradeStrategyFrame;
    m_TradeStrategyFrameCount: Integer;

    procedure OnChangedTradeStrategyOption(Sender: TObject);
    procedure OnChangedTradeStrategyReinforce(Sender: TObject);
    procedure OnChangedTradeStrategyOtherFrame(Sender: TObject);

  private
    m_TimeDiffrence: Double;
    procedure ApplyLanguage;
  public
    procedure OnFormCreate;
    procedure OnFormClose;

    // procedure CalculateTradingHour;
    // procedure CalculateMaterialItem;

    procedure GetOption;
    procedure SetOption;

    procedure ShowValue;
    procedure HideValue;
    procedure UpdateControl;

    procedure AttachBlock(ABlock: CMXBlock);
    function DetachBlock(AUpdate: Boolean = false): CMXBlock;

    procedure UpdateOnChangedBlock;

    procedure SetEnable(AValue: Boolean);

    procedure GetTradeStrategyOption;
    procedure SetTradeStrategyOption;

    procedure GetOtherTradeStrategyOption(AStrategyOption: CMXTradeStrategyOption);

    procedure DisplayTradeStrategy(AOption: CMXTradeStrategyOption);
    property OnChangedOption: TNotifyEvent read m_OnChangedOption write m_OnChangedOption;
  end;

implementation

{$R *.dfm}

uses Math, FNGlobal, DateUtils, FNCMVariable, MXVariable, FNSymbolCollection,
  FNPOTCollection, FNAccountData, FNAccountArray,
  MXSystemManager, MXOrderManager, MKGlobal, FNMaterialCollection,

  MKTradeStrategyConst;

procedure TMatrixOptionFrame.ApplyLanguage;
begin
  if (g_Language = 0) then
  begin
    TabSheet1.Caption := '전략';
    TabSheet2.Caption := '매매조건';

    ComboBoxTradeStrategy.Clear;
    ComboBoxTradeStrategy.Items.Add('Stochastic 추세 1');
    ComboBoxTradeStrategy.Items.Add('Stochastic 추세 2');
    ComboBoxTradeStrategy.Items.Add('Stochastic 추세 3');
    ComboBoxTradeStrategy.Items.Add('Stochastic 비추세 1');
    ComboBoxTradeStrategy.Items.Add('Stochastic 비추세 2');
    ComboBoxTradeStrategy.Items.Add('RSI 추세');
    ComboBoxTradeStrategy.Items.Add('RSI 비추세');
    ComboBoxTradeStrategy.Items.Add('Bollinger Bands 추세');
    ComboBoxTradeStrategy.Items.Add('Disparity 추세');
    ComboBoxTradeStrategy.Items.Add('Disparity 비추세');
    ComboBoxTradeStrategy.Items.Add('BaseLine 추세1');
    ComboBoxTradeStrategy.Items.Add('BaseLine 추세2');
    ComboBoxTradeStrategy.Items.Add('BaseLine 비추세1');
    ComboBoxTradeStrategy.Items.Add('일목균형표 추세1');
    ComboBoxTradeStrategy.Items.Add('일목균형표 추세2');
    ComboBoxTradeStrategy.Items.Add('일목균형표 추세3');
    ComboBoxTradeStrategy.Items.Add('MOV 추세1');
    ComboBoxTradeStrategy.Items.Add('MOV 추세2');
    ComboBoxTradeStrategy.Items.Add('MOV 추세3');
    ComboBoxTradeStrategy.Items.Add('MOV 비추세1');
    ComboBoxTradeStrategy.Items.Add('MOV 비추세2');
    ComboBoxTradeStrategy.Items.Add('상관관계');

    TabSheetCFG01.Caption := '설정';
    TabSheetCFG02.Caption := '필터';
    TabSheetCFG03.Caption := '청산';
    TabSheetCFG04.Caption := '재진입';

    TabSheet13.Caption := '기본';
    TabSheet14.Caption := '보강';

    GroupBox6.Caption := '계좌정보';
    LabelACCOUNT_NO.Caption := '계좌번호 :';
    LabelACCOUNT_pw.Caption := '비밀번호 :';

    GroupBox1.Caption := '종목선택과 수량';
    LabelSYMBOL.Caption := '종목 코드 :';
    Label6.Caption := '주문 코드 :';

    GroupBox2.Caption := '주문가격';
    Label3.Caption := '주문가격';
    Label4.Caption := '주문수량';
    Label112.Caption := '초';

    GroupBox8.Caption := '추격주문';
    Label16.Caption := '틱 수  : ';
    Label17.Caption := '최소호가단위 :';

    GroupBox9.Caption := '타임프레임';
    Label1.Caption := '타임프레임 : ';

    ComboBoxTIMEFRAME.Clear;
    ComboBoxTIMEFRAME.Items.Add('10초');
    ComboBoxTIMEFRAME.Items.Add('20초');
    ComboBoxTIMEFRAME.Items.Add('30초');
    ComboBoxTIMEFRAME.Items.Add('50초');
    ComboBoxTIMEFRAME.Items.Add('1분');
    ComboBoxTIMEFRAME.Items.Add('2분');
    ComboBoxTIMEFRAME.Items.Add('3분');
    ComboBoxTIMEFRAME.Items.Add('5분');
    ComboBoxTIMEFRAME.Items.Add('10분');
    ComboBoxTIMEFRAME.Items.Add('15분');
    ComboBoxTIMEFRAME.Items.Add('20분');
    ComboBoxTIMEFRAME.Items.Add('30분');
    ComboBoxTIMEFRAME.Items.Add('60분');

    GroupBox10.Caption := '매매시스템 정보';
    Label18.Caption := '시스템 이름 (영문만 가능):';

    RadioGroupSYSTEM_MODE.Caption := '시스템 주문 모드';
    RadioGroupSYSTEM_MODE.Items.Clear;
    RadioGroupSYSTEM_MODE.Items.Add('내부테스트모드');
    RadioGroupSYSTEM_MODE.Items.Add('증권사 서버');

    GroupBox14.Caption := '매매규칙';
    CheckBoxACTION_ON_START.Caption := '시스템 시작과 동시에 현재 신호 매매하기';
    CheckBoxNOTRADE_FIRST_SIGNAL.Caption := '당일 처음신호 매매하지 않기';

    GroupBox4.Caption := '전산장';
    Label2.Caption := 'X :';
    Label5.Caption := 'Y :';
    Label7.Caption := '장시작 후  X분 경과 후';
    Label8.Caption := '장마감 전  Y분 이전';

    Label10.Caption := '시작 :';
    Label12.Caption := '마감 :';

    GroupBox4.Caption := '정규장';
    CheckBoxUSE_REGULAR_MARKET.Caption := '사용여부';
    Label15.Caption := '시작 :';
    Label19.Caption := '마감 :';

    GroupBox15.Caption := '기준 날짜(과거 백테스팅용 - 영업일)';
    CheckBoxUSE_STAND_DATE.Caption := '사용여부';

    GroupBox11.Caption := '일중 손실 및 이익이 설정치에 도달시 매매정지';
    CheckBoxUSE_RISK_MAX_LOSS.Caption := '손절정지($) :';
    CheckBoxUSE_RISK_MAX_PROFIT.Caption := '수익정지($) :';
    CheckBoxUSE_REALTIME_RISK_CHECK.Caption := '실시간 검사 (체크 하지 않으면, 각 바마다 검사)';

  end
  else if (g_Language = 1) then
  begin
    TabSheet1.Caption := 'Strategy';
    TabSheet2.Caption := 'Trading Condition';

    ComboBoxTradeStrategy.Clear;
    ComboBoxTradeStrategy.Items.Add('Stochastic trend 1');
    ComboBoxTradeStrategy.Items.Add('Stochastic trend 2');
    ComboBoxTradeStrategy.Items.Add('Stochastic trend 3');
    ComboBoxTradeStrategy.Items.Add('Stochastic counter 1');
    ComboBoxTradeStrategy.Items.Add('Stochastic counter 2');
    ComboBoxTradeStrategy.Items.Add('RSI trend');
    ComboBoxTradeStrategy.Items.Add('RSI counter');
    ComboBoxTradeStrategy.Items.Add('Bollinger Bands trend');
    ComboBoxTradeStrategy.Items.Add('Disparity trend');
    ComboBoxTradeStrategy.Items.Add('Disparity trend');
    ComboBoxTradeStrategy.Items.Add('BaseLine trend 1');
    ComboBoxTradeStrategy.Items.Add('BaseLine trend 2');
    ComboBoxTradeStrategy.Items.Add('BaseLine counter 1');
    ComboBoxTradeStrategy.Items.Add('ILMOK trend 1');
    ComboBoxTradeStrategy.Items.Add('ILMOK trend 2');
    ComboBoxTradeStrategy.Items.Add('ILMOK trend 3');
    ComboBoxTradeStrategy.Items.Add('MOV trend 1');
    ComboBoxTradeStrategy.Items.Add('MOV trend 2');
    ComboBoxTradeStrategy.Items.Add('MOV trend 3');
    ComboBoxTradeStrategy.Items.Add('MOV counter 1');
    ComboBoxTradeStrategy.Items.Add('MOV counter 2');
    ComboBoxTradeStrategy.Items.Add('Relative');

    TabSheetCFG01.Caption := 'Default';
    TabSheetCFG02.Caption := 'Filter';
    TabSheetCFG03.Caption := 'Exit trade';
    TabSheetCFG04.Caption := 'Re-Enter';

    TabSheet13.Caption := 'Basic';
    TabSheet14.Caption := 'Suppliment';

    GroupBox6.Caption := 'Account information';
    LabelACCOUNT_NO.Caption := 'Account  :';
    LabelACCOUNT_pw.Caption := 'Password :';

    GroupBox1.Caption := 'Product and order';
    LabelSYMBOL.Caption := 'Product code :';
    Label6.Caption := 'Order code :';

    GroupBox2.Caption := 'Order price';
    Label3.Caption := 'Order price';
    Label4.Caption := 'Quantity';
    Label112.Caption := 'Sec';

    GroupBox8.Caption := 'Catch up trade';
    Label16.Caption := 'Ticks  : ';
    Label17.Caption := 'minimum ticks :';

    Label109.Caption := '';
    Label110.Caption := '';
    Label111.Caption := '';

    GroupBox9.Caption := 'Time Frame';
    Label1.Caption := 'Time Frame : ';

    ComboBoxTIMEFRAME.Clear;
    ComboBoxTIMEFRAME.Items.Add('10 Sec');
    ComboBoxTIMEFRAME.Items.Add('20 Sec');
    ComboBoxTIMEFRAME.Items.Add('30 Sec');
    ComboBoxTIMEFRAME.Items.Add('50 Sec');
    ComboBoxTIMEFRAME.Items.Add('1 Min');
    ComboBoxTIMEFRAME.Items.Add('2 Min');
    ComboBoxTIMEFRAME.Items.Add('3 Min');
    ComboBoxTIMEFRAME.Items.Add('5 Min');
    ComboBoxTIMEFRAME.Items.Add('10 Min');
    ComboBoxTIMEFRAME.Items.Add('15 Min');
    ComboBoxTIMEFRAME.Items.Add('20 Min');
    ComboBoxTIMEFRAME.Items.Add('30 Min');
    ComboBoxTIMEFRAME.Items.Add('60 Min');

    GroupBox10.Caption := 'Infomation';
    Label18.Caption := 'Title :';

    RadioGroupSYSTEM_MODE.Caption := 'Order Mode';
    RadioGroupSYSTEM_MODE.Items.Clear;
    RadioGroupSYSTEM_MODE.Items.Add('Virtual');
    RadioGroupSYSTEM_MODE.Items.Add('Real');

    GroupBox14.Caption := 'Trading Condition';
    CheckBoxACTION_ON_START.Caption := 'Starting with the current trading system for signal';
    CheckBoxNOTRADE_FIRST_SIGNAL.Caption := 'Does not trading the first signal';

    GroupBox4.Caption := 'Overnight market';
    Label7.Caption := 'X minutes after opening';
    Label8.Caption := 'Y minutes before closing';

    Label10.Caption := 'Start :';
    Label12.Caption := 'End :';

    GroupBox7.Caption := 'Daytime regular market';

    CheckBoxUSE_REGULAR_MARKET.Caption := 'Use';
    Label15.Caption := 'Start :';
    Label19.Caption := 'End :';

    GroupBox15.Caption := 'Base date(for back testing xx market days)';
    CheckBoxUSE_STAND_DATE.Caption := 'Use';

    GroupBox11.Caption := 'Loss cut & profit take';
    CheckBoxUSE_RISK_MAX_LOSS.Caption := 'Loss cut($) :';
    CheckBoxUSE_RISK_MAX_PROFIT.Caption := 'Profit target($) :';
    CheckBoxUSE_REALTIME_RISK_CHECK.Caption := 'Realtime backtest(otherwise test with close price)';

    PanelHide.Align := alClient;
  end;

end;

{$REGION '화면생성시 또는 파괴 될 때 '}

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.OnFormCreate;
var
  f_Index: Integer;
  f_SymbolItem: CFNSymbolItem;
  f_AccountData: CFNAccountData;
begin
  m_TimeDiffrence := 0;
  m_SelectedTradeStrategyOption := NIL;

  m_EnableControl := true;
  m_EnableEvent := true;

  PageControl1.ActivePageIndex := 0;

  PageControlStrategyConfig.ActivePageIndex := 0;
  PageControlStrategy.TabHeight := 1;
  PageControlStrategy.TabWidth := 1;

  SetOption;

{$REGION '종목심벌의 콤보박스를 설정한다 '}
  ComboBoxSYMBOL.Clear;
  for f_Index := 0 to g_SymbolCollection.m_Items.Count - 1 do
  begin
    f_SymbolItem := CFNSymbolItem(g_SymbolCollection.m_Items[f_Index]);
    ComboBoxSYMBOL.AddItem(f_SymbolItem.m_Symbol, f_SymbolItem);
  end;
  ComboBoxSYMBOL.ItemIndex := 0;
{$ENDREGION}
{$REGION '계좌번호의 콤보박스를 설정한다 '}
  ComboBoxACCOUNT_NO.Clear;
  for f_Index := 0 to g_AccountArray.m_Items.Count - 1 do
  begin
    f_AccountData := CFNAccountData(g_AccountArray.m_Items[f_Index]);
    ComboBoxACCOUNT_NO.AddItem(f_AccountData.m_AccountNo, f_AccountData);
  end;

  if g_AccountArray.m_Items.Count > 0 then
  begin
    ComboBoxACCOUNT_NO.ItemIndex := 0;
    LabelACCOUNT_NAME.Caption := CFNAccountData(g_AccountArray.m_Items[0]).m_AccountName;
  end;
{$ENDREGION}
  HideValue;

{$REGION '화면의 전략을 설정프레임을 배열화 한다'}
  m_TradeStrategyFrameCount := 0;

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := STC_T1_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := STC_T2_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := STC_T3_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := STC_N1_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := STC_N2_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := RSI_T1_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := RSI_N1_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := BB_T1_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := DISPARITY_T1_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := DISPARITY_N1_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := BASELINE_T1_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := BASELINE_T2_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := BASELINE_N1_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := IM_T1_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := IM_T2_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := IM_T3_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := MOV_T1_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := MOV_T2_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := MOV_T3_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := MOV_N1_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := MOV_N2_Frame1;
  Inc(m_TradeStrategyFrameCount);

  m_TradeStrategyFrame[m_TradeStrategyFrameCount] := REL_T1_Frame1;
  Inc(m_TradeStrategyFrameCount);

{$ENDREGION}
{$REGION '전략 설정 화면의 이벤트를 연결한다'}
  for f_Index := 0 to m_TradeStrategyFrameCount - 1 do
  begin
    m_TradeStrategyFrame[f_Index].OnChangedOption := OnChangedTradeStrategyOption;
  end;

  m_Random_Frame.OnChangedOption := OnChangedTradeStrategyOtherFrame;
  m_ENTER_Frame.OnChangedOption := OnChangedTradeStrategyOtherFrame;
  m_EXIT_Frame.OnChangedOption := OnChangedTradeStrategyOtherFrame;
  m_REINFORCE_Frame.OnChangedOption := OnChangedTradeStrategyReinforce;
{$ENDREGION}
  ApplyLanguage;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.OnFormClose;
begin

end;

{$ENDREGION}
{$REGION '매매블럭을 지정하거나 해지한다'}

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.AttachBlock(ABlock: CMXBlock);
var
  f_TSOption: CMXTradeStrategyOption;
begin
  m_Block := ABlock;

  if Assigned(m_Block) then
  begin
    if m_Block.Option.StrategyOptionCollection.m_Items.Count = 0 then
    begin
      f_TSOption := CMXTradeStrategyOption.Create;
      m_Block.Option.StrategyOptionCollection.Add(f_TSOption);
    end;
    m_SelectedTradeStrategyOption := m_Block.Option.StrategyOptionCollection.m_Items[0];
  end
  else
  begin
    m_SelectedTradeStrategyOption := NIL;
  end;

  SetOption;

  ShowValue();

end;

// ------------------------------------------------------------------------------------
function TMatrixOptionFrame.DetachBlock(AUpdate: Boolean = false): CMXBlock;
begin
  result := m_Block;

  m_Block := NIL;

  if AUpdate then
  begin
    HideValue;
    SetEnable(false);
  end;
end;

{$ENDREGION}
{$REGION '화면의 값을 보이거나 안보이게 한다'}

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.HideValue;
begin
  PanelClear.Align := alClient;
  PanelClear.Visible := true;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.ShowValue;
begin
  PanelClear.Align := alNone;
  PanelClear.Visible := false;
end;
{$ENDREGION}

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.SetEnable(AValue: Boolean);
begin
  if AValue then
  begin
    ShowValue;
  end;
  m_EnableControl := AValue;

{$REGION '계좌정보'}
  LabelACCOUNT_NO.Enabled := AValue;
  ComboBoxACCOUNT_NO.Enabled := AValue;
  LabelACCOUNT_pw.Enabled := AValue;
  EditACCOUNT_PW.Enabled := AValue;
  LabelACCOUNT_NAME.Enabled := AValue;
{$ENDREGION}
{$REGION '종목정보'}
  LabelSYMBOL.Enabled := AValue;
  ComboBoxSYMBOL.Enabled := AValue;
{$ENDREGION}
{$REGION '주문가격'}
  Label5.Enabled := AValue;
  ComboBoxORDER_TYPE.Enabled := AValue;
  Label4.Enabled := AValue;
  EditORDER_COUNT.Enabled := AValue;
  UpDownORDER_COUNT.Enabled := AValue;

  EditSECOND_ORDER_DELAY_TIME.Enabled := AValue;
  UpDownSECOND_ORDER_DELAY_TIME.Enabled := AValue;
{$ENDREGION}
{$REGION '매매시간'}
  Label2.Enabled := AValue;
  EditSTART_OFFSET.Enabled := AValue;
  UpDownSTART_OFFSET.Enabled := AValue;

  Label5.Enabled := AValue;
  EditSTOP_OFFSET.Enabled := AValue;
  UpDownSTOP_OFFSET.Enabled := AValue;

  Label10.Enabled := AValue;
  DateTimePickerSTART_TIME.Enabled := AValue;

  Label12.Enabled := AValue;
  DateTimePickerSTOP_TIME.Enabled := AValue;

  CheckBoxUSE_REGULAR_MARKET.Enabled := AValue;

  Label15.Enabled := AValue;
  DateTimePickerREGULAR_START_TIME.Enabled := AValue;

  Label19.Enabled := AValue;
  DateTimePickerREGULAR_STOP_TIME.Enabled := AValue;
{$ENDREGION}
{$REGION '매매시스템이름'}
  Label18.Enabled := AValue;
  EditBLOCK_NAME.Enabled := AValue;
{$ENDREGION}
{$REGION '월물과 타임프레임'}
  Label1.Enabled := AValue;
  ComboBoxTIMEFRAME.Enabled := AValue;
{$ENDREGION}
{$REGION '추격주문'}
  Label16.Enabled := AValue;
  EditTICK_COUNT.Enabled := AValue;
  UpDownTICK_COUNT.Enabled := AValue;
  Label17.Enabled := AValue;
  EditTICK_STEP.Enabled := AValue;
  Label22.Enabled := AValue;
{$ENDREGION}
{$REGION '시스템 주문 모드'}
  RadioGroupSYSTEM_MODE.Enabled := AValue;
{$ENDREGION}
{$REGION '매매규칙'}
  CheckBoxACTION_ON_START.Enabled := AValue;
  CheckBoxNOTRADE_FIRST_SIGNAL.Enabled := AValue;
{$ENDREGION}
{$REGION '손실 및 이익 정지'}
  CheckBoxUSE_RISK_MAX_LOSS.Enabled := AValue;
  EditRISK_MAX_LOSS.Enabled := AValue;

  CheckBoxUSE_RISK_MAX_PROFIT.Enabled := AValue;
  EditRISK_MAX_PROFIT.Enabled := AValue;

  CheckBoxUSE_REALTIME_RISK_CHECK.Enabled := AValue;
{$ENDREGION}
  ComboBoxTradeStrategy.Enabled := AValue;
  PageControl3.Enabled := AValue;
  PageControlStrategyConfig.Enabled := AValue;

  if m_EnableControl then
    UpdateControl;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.GetOption;
var
  f_SymbolItem: CFNSymbolItem;
  f_AccountData: CFNAccountData;
  f_POTData: CFNPOTItem;
  f_OpenDateTime: TDateTime;
  f_CloseDateTime: TDateTime;
  f_Time: TDateTime;
begin
  if not Assigned(m_Block) then
    exit;

{$REGION '계좌정보'}
  if ComboBoxACCOUNT_NO.ItemIndex >= 0 then
  begin
    f_AccountData := g_AccountArray.m_Items[ComboBoxACCOUNT_NO.ItemIndex];
    m_Block.Option.SetStringValue('ACCOUNT_NO', f_AccountData.m_AccountNo);
  end
  else
  begin
    m_Block.Option.SetStringValue('ACCOUNT_NO', '');
  end;
  m_Block.Option.SetStringValue('ACCOUNT_PW', EditACCOUNT_PW.Text);
{$ENDREGION}
{$REGION '종목정보'}
  if ComboBoxSYMBOL.ItemIndex >= 0 then
  begin
    f_SymbolItem := CFNSymbolItem(g_SymbolCollection.m_Items[ComboBoxSYMBOL.ItemIndex]);
    m_Block.Option.SetIntegerValue('COUNTRY_NO', f_SymbolItem.m_Country);
    m_Block.Option.SetIntegerValue('GROUP_NO', f_SymbolItem.m_Group);
    m_Block.Option.SetIntegerValue('MARKET_NO', f_SymbolItem.m_Market);
    m_Block.Option.SetStringValue('SYMBOL', f_SymbolItem.m_Symbol);
    m_Block.Option.SetStringValue('SEC_SYMBOL', f_SymbolItem.m_SecSymbol);
    m_Block.Option.SetStringValue('CONTRACT', f_SymbolItem.m_Contract);
    m_Block.Option.SetStringValue('TRADESYMBOL', f_SymbolItem.m_SecSymbol + f_SymbolItem.m_Contract);
  end;
{$ENDREGION}
{$REGION '주문가격'}
  m_Block.Option.SetIntegerValue('ORDER_PRICETYPE', ComboBoxORDER_TYPE.ItemIndex);
  m_Block.Option.SetIntegerValue('ORDER_COUNT', UpDownORDER_COUNT.Position);

  m_Block.Option.SetIntegerValue('SECOND_ORDER_DELAY_TIME', UpDownSECOND_ORDER_DELAY_TIME.Position);

{$ENDREGION}
{$REGION '매매시간'}
  m_Block.Option.SetIntegerValue('START_OFFSET', UpDownSTART_OFFSET.Position);
  m_Block.Option.SetIntegerValue('STOP_OFFSET', UpDownSTOP_OFFSET.Position);

  m_Block.Option.SetBooleanValue('USE_REGULAR_MARKET', CheckBoxUSE_REGULAR_MARKET.Checked);

  f_Time := DateTimePickerREGULAR_START_TIME.Time - Math.Floor(DateTimePickerREGULAR_START_TIME.Time);
  m_Block.Option.SetIntegerValue('REGULAR_START_TIME', Trunc(f_Time * 86400000 + 0.5));

  f_Time := DateTimePickerREGULAR_STOP_TIME.Time - Math.Floor(DateTimePickerREGULAR_STOP_TIME.Time);
  m_Block.Option.SetIntegerValue('REGULAR_STOP_TIME', Trunc(f_Time * 86400000 + 0.5));

  m_Block.CalculateTradingHour;

  DateTimePickerSTART_TIME.Time := m_Block.Option.GetIntegerValue('START_TIME') / 86400000.0;
  DateTimePickerSTOP_TIME.Time := m_Block.Option.GetIntegerValue('STOP_TIME') / 86400000.0;
{$ENDREGION}
{$REGION '갭처리'}
  m_Block.Option.SetBooleanValue('USER_GAB_PROCESS', CheckBoxUSER_GAB_PROCESS.Checked);
  m_Block.Option.SetIntegerValue('GAB_INSERT_MIN', UpDownGAB_INSERT_MIN.Position);
{$ENDREGION}
{$REGION '매매시스템이름'}
  m_Block.BlockName := EditBLOCK_NAME.Text;
{$ENDREGION}
{$REGION '월물과 타임프레임'}
  m_Block.Option.SetIntegerValue('TIMEFRAME', m_Block.Option.IndexToTimeFrame(ComboBoxTIMEFRAME.ItemIndex));
{$ENDREGION}
{$REGION '추격주문'}
  m_Block.Option.SetIntegerValue('TICK_COUNT', UpDownTICK_COUNT.Position);

  m_Block.CalculateMaterialItem;

  m_Block.Option.SetDoubleValue('TICK_STEP', TFNGlobal.atof(EditTICK_STEP.Text));
{$ENDREGION}
{$REGION '시스템 주문 모드'}
  m_Block.Option.SetIntegerValue('SYSTEM_MODE', RadioGroupSYSTEM_MODE.ItemIndex);
{$ENDREGION}
{$REGION '매매규칙'}
  m_Block.Option.SetBooleanValue('ACTION_ON_START', CheckBoxACTION_ON_START.Checked);
  m_Block.Option.SetBooleanValue('NOTRADE_FIRST_SIGNAL', CheckBoxNOTRADE_FIRST_SIGNAL.Checked);
{$ENDREGION}
{$REGION '기준일'}
  m_Block.Option.SetBooleanValue('USE_STAND_DATE', CheckBoxUSE_STAND_DATE.Checked);
  m_Block.Option.SetIntegerValue('STAND_DATE', Trunc(DateTimePickerSTAND_DATE.DateTime));
{$ENDREGION}
{$REGION '손실 및 이익 정지'}
  m_Block.Option.SetBooleanValue('USE_RISK_MAX_LOSS', CheckBoxUSE_RISK_MAX_LOSS.Checked);
  m_Block.Option.SetDoubleValue('RISK_MAX_LOSS', TFNGlobal.atof(EditRISK_MAX_LOSS.Text));

  m_Block.Option.SetBooleanValue('USE_RISK_MAX_PROFIT', CheckBoxUSE_RISK_MAX_PROFIT.Checked);
  m_Block.Option.SetDoubleValue('RISK_MAX_PROFIT', TFNGlobal.atof(EditRISK_MAX_PROFIT.Text));

  m_Block.Option.SetBooleanValue('USE_REALTIME_RISK_CHECK', CheckBoxUSE_REALTIME_RISK_CHECK.Checked);
{$ENDREGION}
{$REGION '신호전송'}
  GetTradeStrategyOption;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.SetOption;
var
  f_Index: Integer;
  f_Key: String;
begin
  if not Assigned(m_Block) then
    exit;

  m_EnableEvent := false;

  try

{$REGION '계좌정보'}
    if ComboBoxACCOUNT_NO.Items.Count > 0 then
    begin
      if m_Block.Option.GetStringValue('ACCOUNT_NO') = '' then
      begin
        ComboBoxACCOUNT_NO.ItemIndex := 0;
      end
      else
      begin
        for f_Index := 0 to ComboBoxACCOUNT_NO.Items.Count - 1 do
        begin
          if ComboBoxACCOUNT_NO.Items[f_Index] = m_Block.Option.GetStringValue('ACCOUNT_NO') then
          begin
            ComboBoxACCOUNT_NO.ItemIndex := f_Index;
            LabelACCOUNT_NAME.Caption := CFNAccountData(g_AccountArray.m_Items[f_Index]).m_AccountName;
            break;
          end;
        end;
      end;
    end;

    EditACCOUNT_PW.Text := m_Block.Option.GetStringValue('ACCOUNT_PW');
{$ENDREGION}
{$REGION '종목정보'}
    if ComboBoxSYMBOL.Items.Count > 0 then
    begin
      f_Key := m_Block.Option.GetStringValue('SYMBOL');
      // ShowMessage(f_Key);
      if f_Key = '' then
      begin
        ComboBoxSYMBOL.ItemIndex := 0;
      end
      else
      begin
        for f_Index := 0 to ComboBoxSYMBOL.Items.Count - 1 do
        begin
          if ComboBoxSYMBOL.Items[f_Index] = f_Key then
          begin
            ComboBoxSYMBOL.ItemIndex := f_Index;
            break;
          end;
        end;
      end;

      EditORDER_SYMBOL.Text := m_Block.Option.GetStringValue('SEC_SYMBOL') + m_Block.Option.GetStringValue('CONTRACT');
    end;
{$ENDREGION}
{$REGION '주문가격'}
    ComboBoxORDER_TYPE.ItemIndex := m_Block.Option.GetIntegerValue('ORDER_PRICETYPE');
    UpDownORDER_COUNT.Position := m_Block.Option.GetIntegerValue('ORDER_COUNT');
    UpDownSECOND_ORDER_DELAY_TIME.Position := m_Block.Option.GetIntegerValue('SECOND_ORDER_DELAY_TIME');

{$ENDREGION}
{$REGION '매매시간'}
    UpDownSTART_OFFSET.Position := m_Block.Option.GetIntegerValue('START_OFFSET');
    UpDownSTOP_OFFSET.Position := m_Block.Option.GetIntegerValue('STOP_OFFSET');
    CheckBoxUSE_REGULAR_MARKET.Checked := m_Block.Option.GetBooleanValue('USE_REGULAR_MARKET');
    DateTimePickerREGULAR_START_TIME.Time := m_Block.Option.GetIntegerValue('REGULAR_START_TIME') / 86400000.0;
    DateTimePickerREGULAR_STOP_TIME.Time := m_Block.Option.GetIntegerValue('REGULAR_STOP_TIME') / 86400000.0;

    m_Block.CalculateTradingHour;

    DateTimePickerSTART_TIME.Time := m_Block.Option.GetIntegerValue('START_TIME') / 86400000.0;
    DateTimePickerSTOP_TIME.Time := m_Block.Option.GetIntegerValue('STOP_TIME') / 86400000.0;
{$ENDREGION}
{$REGION '갭처리'}
    CheckBoxUSER_GAB_PROCESS.Checked := m_Block.Option.GetBooleanValue('USER_GAB_PROCESS');
    UpDownGAB_INSERT_MIN.Position := m_Block.Option.GetIntegerValue('GAB_INSERT_MIN');
{$ENDREGION}
{$REGION '매매시스템이름'}
    EditBLOCK_NAME.Text := m_Block.BlockName;
{$ENDREGION}
{$REGION '월물과 타임프레임'}
    ComboBoxTIMEFRAME.ItemIndex := m_Block.Option.TimeFrameToIndex(m_Block.Option.GetIntegerValue('TIMEFRAME'));
{$ENDREGION}
{$REGION '추격주문'}
    UpDownTICK_COUNT.Position := m_Block.Option.GetIntegerValue('TICK_COUNT');
    m_Block.CalculateMaterialItem;
    EditTICK_STEP.Text := TFNGlobal.WriteNumber(m_Block.Option.GetDoubleValue('TICK_STEP'), 6);
{$ENDREGION}
{$REGION '시스템 주문 모드'}
    RadioGroupSYSTEM_MODE.ItemIndex := m_Block.Option.GetIntegerValue('SYSTEM_MODE');
{$ENDREGION}
{$REGION '매매규칙'}
    CheckBoxACTION_ON_START.Checked := m_Block.Option.GetBooleanValue('ACTION_ON_START');
    CheckBoxNOTRADE_FIRST_SIGNAL.Checked := m_Block.Option.GetBooleanValue('NOTRADE_FIRST_SIGNAL');
{$ENDREGION}
{$REGION '기준일'}
    CheckBoxUSE_STAND_DATE.Checked := m_Block.Option.GetBooleanValue('USE_STAND_DATE');
    if m_Block.Option.GetBooleanValue('USE_STAND_DATE') then
    begin
      DateTimePickerSTAND_DATE.DateTime := m_Block.Option.GetIntegerValue('STAND_DATE');
    end
    else
    begin
      DateTimePickerSTAND_DATE.DateTime := TFNGlobal.ServerNow + m_Block.Option.GetDoubleValue('TIME_DIFFRENCE');
    end;
{$ENDREGION}
{$REGION '손실 및 이익 정지'}
    CheckBoxUSE_RISK_MAX_LOSS.Checked := m_Block.Option.GetBooleanValue('USE_RISK_MAX_LOSS');
    EditRISK_MAX_LOSS.Text := FloatToStr(m_Block.Option.GetDoubleValue('RISK_MAX_LOSS'));

    CheckBoxUSE_RISK_MAX_PROFIT.Checked := m_Block.Option.GetBooleanValue('USE_RISK_MAX_PROFIT');
    EditRISK_MAX_PROFIT.Text := FloatToStr(m_Block.Option.GetDoubleValue('RISK_MAX_PROFIT'));

    CheckBoxUSE_REALTIME_RISK_CHECK.Checked := m_Block.Option.GetBooleanValue('USE_REALTIME_RISK_CHECK');
{$ENDREGION}
{$REGION '매매전략'}
    if Assigned(m_SelectedTradeStrategyOption) then
    begin
      f_Key := m_SelectedTradeStrategyOption.GetStringValue(TSOPTION_KEY_CATEGORY);
      if f_Key = 'STC-T1' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 0;
      end
      else if f_Key = 'STC-T2' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 1;
      end
      else if f_Key = 'STC-T3' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 2;
      end
      else if f_Key = 'STC-N1' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 3;
      end
      else if f_Key = 'STC-N2' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 4;
      end
      else if f_Key = 'RSI-T1' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 5;
      end
      else if f_Key = 'RSI-N1' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 6;
      end
      else if f_Key = 'BB-T1' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 7;
      end
      else if f_Key = 'DISPARITY-T1' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 8;
      end
      else if f_Key = 'DISPARITY-N1' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 9;
      end
      else if f_Key = 'BASELINE-T1' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 10;
      end
      else if f_Key = 'BASELINE-T2' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 11;
      end
      else if f_Key = 'BASELINE-N1' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 12;
      end
      else if f_Key = 'IM-T1' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 13;
      end
      else if f_Key = 'IM-T2' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 14;
      end
      else if f_Key = 'IM-T3' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 15;
      end
      else if f_Key = 'MOV-T1' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 16;
      end
      else if f_Key = 'MOV-T2' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 17;
      end
      else if f_Key = 'MOV-T3' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 18;
      end
      else if f_Key = 'MOV-N1' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 19;
      end
      else if f_Key = 'MOV-N2' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 20;
      end
      else if f_Key = 'REL-T1' then
      begin
        ComboBoxTradeStrategy.ItemIndex := 21;
      end
      else
      begin
        ComboBoxTradeStrategy.ItemIndex := 0;
      end;
      SetTradeStrategyOption;
      PageControlStrategy.ActivePageIndex := ComboBoxTradeStrategy.ItemIndex;
    end;
{$ENDREGION}
  finally
    m_EnableEvent := true;
  end;

  UpdateControl;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.UpdateControl;
var
  f_Index: Integer;
begin
  if not Assigned(m_Block) then
    exit;

  m_EnableEvent := false;
  try

{$REGION '계좌정보'}
    if ComboBoxACCOUNT_NO.Items.Count > 0 then
    begin
      if (ComboBoxACCOUNT_NO.ItemIndex >= 0) and (ComboBoxACCOUNT_NO.ItemIndex < g_AccountArray.m_Items.Count) then
      begin
        LabelACCOUNT_NAME.Caption := CFNAccountData(g_AccountArray.m_Items[ComboBoxACCOUNT_NO.ItemIndex]).m_AccountName;
      end;

    end;
{$ENDREGION}
{$REGION '시스템 주문 모드'}
    if m_Block.Option.GetIntegerValue('SYSTEM_MODE') = SYSTEM_MODE_REAL then
    begin
      if (m_Block.Option.GetBooleanValue('USE_STAND_DATE')) then
      begin
        m_Block.Option.SetBooleanValue('USE_STAND_DATE', false);
        m_Block.Option.SetIntegerValue('STAND_DATE', Trunc(TFNGlobal.ServerNow));
        CheckBoxUSE_STAND_DATE.Checked := m_Block.Option.GetBooleanValue('USE_STAND_DATE');
        DateTimePickerSTAND_DATE.DateTime := m_Block.Option.GetIntegerValue('STAND_DATE');
      end;
    end;
{$ENDREGION}
{$REGION '기준일'}
    if (m_Block.Option.GetBooleanValue('USE_STAND_DATE')) then
    begin
      DateTimePickerSTAND_DATE.Enabled := m_EnableControl;
    end
    else
    begin
      DateTimePickerSTAND_DATE.Enabled := false;
    end;
{$ENDREGION}
    if (m_Block.Option.GetIntegerValue('ORDER_PRICETYPE') = 5) or (m_Block.Option.GetIntegerValue('ORDER_PRICETYPE') = 6) then
    begin
      Label109.Enabled := m_EnableControl;
      Label110.Enabled := m_EnableControl;
      Label111.Enabled := m_EnableControl;
      EditSECOND_ORDER_DELAY_TIME.Enabled := m_EnableControl;
      UpDownSECOND_ORDER_DELAY_TIME.Enabled := m_EnableControl;
      Label112.Enabled := m_EnableControl;
    end
    else
    begin
      Label109.Enabled := false;
      Label110.Enabled := false;
      Label111.Enabled := false;
      EditSECOND_ORDER_DELAY_TIME.Enabled := false;
      UpDownSECOND_ORDER_DELAY_TIME.Enabled := false;
      Label112.Enabled := false;
    end;

{$REGION '손실정지'}
    if (m_Block.Option.GetBooleanValue('USE_RISK_MAX_LOSS')) then
    begin
      EditRISK_MAX_LOSS.Enabled := m_EnableControl;
    end
    else
    begin
      EditRISK_MAX_LOSS.Enabled := false;
    end;
{$ENDREGION}
{$REGION '이익정지'}
    if (m_Block.Option.GetBooleanValue('USE_RISK_MAX_PROFIT')) then
    begin
      EditRISK_MAX_PROFIT.Enabled := m_EnableControl;
    end
    else
    begin
      EditRISK_MAX_PROFIT.Enabled := false;
    end;
{$ENDREGION}
  finally
    m_EnableEvent := true;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.UpdateOnChangedBlock;
var
  f_Index: Integer;
  f_SymbolItem: CFNSymbolItem;
  f_AccountData: CFNAccountData;
begin
  if not Assigned(m_Block) then
    exit;

  ComboBoxSYMBOL.Clear;
  for f_Index := 0 to g_SymbolCollection.m_Items.Count - 1 do
  begin
    f_SymbolItem := CFNSymbolItem(g_SymbolCollection.m_Items[f_Index]);
    ComboBoxSYMBOL.AddItem(f_SymbolItem.m_Symbol, f_SymbolItem);
  end;
  ComboBoxSYMBOL.ItemIndex := 0;

  SetOption;

  if m_Block.OrderManager.State <> PROCESS_STATE_ENDED_WORK then
  begin
    SetEnable(false);
  end
  else
  begin
    SetEnable(true);
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.EditBLOCK_NAMEKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['0' .. '9', 'a' .. 'z', 'A' .. 'Z', '-', '_', #8, #9, #32, #22, #$2E] then // 0~9, -, Tab, BS, Space, Ctrl+C, Ctrl+V ?? ???
  begin
  end
  else
  begin
    Key := #0;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.RadioGroupSIGNAL_MERGE_TYPEClick(Sender: TObject);
begin
  if not Assigned(m_Block) then
    exit;
  if not m_EnableEvent then
    exit;
  GetOption;
  UpdateControl;
  if Assigned(m_OnChangedOption) then
    m_OnChangedOption(Self);
end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.RadioGroupSYSTEM_MODEClick(Sender: TObject);
begin
  if not Assigned(m_Block) then
    exit;
  if not m_EnableEvent then
    exit;

  GetOption;
  UpdateControl;
  if Assigned(m_OnChangedOption) then
    m_OnChangedOption(Self);
end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.ComboBoxSYMBOLChange(Sender: TObject);
begin
  if not Assigned(m_Block) then
    exit;
  if not m_EnableEvent then
    exit;

  GetOption;

  m_Block.CalculateTradingHour;
  m_Block.CalculateMaterialItem;

  SetOption;

  UpdateControl;
  if Assigned(m_OnChangedOption) then
    m_OnChangedOption(Self);
end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.OptionChange(Sender: TObject);
begin
  if not Assigned(m_Block) then
    exit;
  if not m_EnableEvent then
    exit;

  GetOption;
  UpdateControl;
  if Assigned(m_OnChangedOption) then
    m_OnChangedOption(Self);
end;

procedure TMatrixOptionFrame.Panel3Click(Sender: TObject);
begin

end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  if not Assigned(m_Block) then
    exit;
  if not m_EnableEvent then
    exit;

  GetOption;
  UpdateControl;
  if Assigned(m_OnChangedOption) then
    m_OnChangedOption(Self);
end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.ComboBoxTradeStrategyChange(Sender: TObject);
begin
  if (not m_EnableEvent) then
    exit;

  if (ComboBoxTradeStrategy.ItemIndex < 0) then
    exit;
  if (ComboBoxTradeStrategy.ItemIndex >= m_TradeStrategyFrameCount) then
    exit;

  PageControlStrategy.ActivePageIndex := ComboBoxTradeStrategy.ItemIndex;

  GetTradeStrategyOption;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.GetTradeStrategyOption;
var
  f_Frame: TTradeStrategyFrame;
  f_FrameOptionCategory: String;
  f_Index: Integer;
begin
  // ShowMessage('IN-GetTradeStrategyOption' + ' --- ' + m_SelectedTradeStrategyOption.GetStringValue(TSOPTION_KEY_CATEGORY));

  f_Frame := m_TradeStrategyFrame[ComboBoxTradeStrategy.ItemIndex];
  if Assigned(m_SelectedTradeStrategyOption) then
  begin
    f_FrameOptionCategory := f_Frame.Option.GetStringValue(TSOPTION_KEY_CATEGORY);
    // if m_SelectedTradeStrategyOption.GetStringValue(TSOPTION_KEY_CATEGORY) <> f_FrameOptionCategory then
    // begin
    m_SelectedTradeStrategyOption.Clone(f_Frame.Option);
    m_Random_Frame.CopyOption(m_SelectedTradeStrategyOption);
    m_ENTER_Frame.CopyOption(m_SelectedTradeStrategyOption);
    m_EXIT_Frame.CopyOption(m_SelectedTradeStrategyOption);
    GetOtherTradeStrategyOption(m_SelectedTradeStrategyOption);
    for f_Index := 0 to m_TradeStrategyFrameCount - 1 do
    begin
      m_TradeStrategyFrame[f_Index].ReinforceFrame := NIL;
    end;
    f_Frame.ReinforceFrame := m_REINFORCE_Frame;
    f_Frame.SetAllControlData;
    f_Frame.Refresh;
    DisplayTradeStrategy(f_Frame.Option);
    // end;
  end
  else
  begin
    DisplayTradeStrategy(f_Frame.Option);
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixOptionFrame.SetTradeStrategyOption;
var
  f_Frame: TTradeStrategyFrame;
  f_FrameOptionCategory: String;
  f_Index: Integer;
begin
  // ShowMessage('IN-SetTradeStrategyOption' + ' --- ' + m_SelectedTradeStrategyOption.GetStringValue(TSOPTION_KEY_CATEGORY));

  f_Frame := m_TradeStrategyFrame[ComboBoxTradeStrategy.ItemIndex];
  f_FrameOptionCategory := f_Frame.Option.GetStringValue(TSOPTION_KEY_CATEGORY);
  if Assigned(m_SelectedTradeStrategyOption) then
  begin
    if m_SelectedTradeStrategyOption.GetStringValue(TSOPTION_KEY_CATEGORY) = '' then
    begin
      m_SelectedTradeStrategyOption.Clone(f_Frame.Option);
      // m_Random_Frame.Option.Clone(m_SelectedTradeStrategyOption);
      // m_ENTER_Frame.Option.Clone(m_SelectedTradeStrategyOption);
      // m_EXIT_Frame.Option.Clone(m_SelectedTradeStrategyOption);

      m_Random_Frame.Option := m_SelectedTradeStrategyOption;
      m_ENTER_Frame.Option := m_SelectedTradeStrategyOption;
      m_EXIT_Frame.Option := m_SelectedTradeStrategyOption;

      GetOtherTradeStrategyOption(m_SelectedTradeStrategyOption);
      for f_Index := 0 to m_TradeStrategyFrameCount - 1 do
      begin
        m_TradeStrategyFrame[f_Index].ReinforceFrame := NIL;
      end;
      f_Frame.ReinforceFrame := m_REINFORCE_Frame;
      f_Frame.SetAllControlData;
      f_Frame.Refresh;
      (*
        m_Random_Frame.SetAllControlData;
        m_Random_Frame.Refresh;
        m_ENTER_Frame.SetAllControlData;
        m_ENTER_Frame.Refresh;
        m_EXIT_Frame.SetAllControlData;
        m_EXIT_Frame.Refresh;
      *)
    end
    else if m_SelectedTradeStrategyOption.GetStringValue(TSOPTION_KEY_CATEGORY) = f_FrameOptionCategory then
    begin
      f_Frame.Option.Clone(m_SelectedTradeStrategyOption);
      // m_Random_Frame.Option.Clone(m_SelectedTradeStrategyOption);
      // m_ENTER_Frame.Option.Clone(m_SelectedTradeStrategyOption);
      // m_EXIT_Frame.Option.Clone(m_SelectedTradeStrategyOption);

      m_Random_Frame.Option := m_SelectedTradeStrategyOption;
      m_ENTER_Frame.Option := m_SelectedTradeStrategyOption;
      m_EXIT_Frame.Option := m_SelectedTradeStrategyOption;

      // GetOtherTradeStrategyOption(m_SelectedTradeStrategyOption);
      for f_Index := 0 to m_TradeStrategyFrameCount - 1 do
      begin
        m_TradeStrategyFrame[f_Index].ReinforceFrame := NIL;
      end;
      f_Frame.ReinforceFrame := m_REINFORCE_Frame;
      f_Frame.SetAllControlData;
      f_Frame.Refresh;
      (*
        m_Random_Frame.SetAllControlData;
        m_Random_Frame.Refresh;
        m_ENTER_Frame.SetAllControlData;
        m_ENTER_Frame.Refresh;
        m_EXIT_Frame.SetAllControlData;
        m_EXIT_Frame.Refresh;
      *)
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure TMatrixOptionFrame.GetOtherTradeStrategyOption(AStrategyOption: CMXTradeStrategyOption);
var
  f_SymbolItem: CFNSymbolItem;
  f_Time: TTime;
  f_OpenDateTime: TDateTime;
  f_CloseDateTime: TDateTime;
  f_POTItem: CFNPOTItem;
  f_MaterialItem: CFNMaterialItem;
  f_TimeDifference: Double;
begin
  if not Assigned(AStrategyOption) then
    exit;

{$REGION '종목정보'}
  if ComboBoxSYMBOL.ItemIndex >= 0 then
  begin
    f_SymbolItem := CFNSymbolItem(g_SymbolCollection.m_Items[ComboBoxSYMBOL.ItemIndex]);
    AStrategyOption.SetIntegerValue('COUNTRY_NO', f_SymbolItem.m_Country);
    AStrategyOption.SetIntegerValue('GROUP_NO', f_SymbolItem.m_Group);
    AStrategyOption.SetIntegerValue('MARKET_NO', f_SymbolItem.m_Market);
    AStrategyOption.SetStringValue('SYMBOL', f_SymbolItem.m_Symbol);
    AStrategyOption.SetStringValue('SEC_SYMBOL', f_SymbolItem.m_SecSymbol);
    AStrategyOption.SetStringValue('CONTRACT', f_SymbolItem.m_Contract);
    AStrategyOption.SetStringValue('TRADESYMBOL', f_SymbolItem.m_SecSymbol + f_SymbolItem.m_Contract);
  end;
{$ENDREGION}
{$REGION '매매시간'}
  AStrategyOption.SetIntegerValue('START_OFFSET', UpDownSTART_OFFSET.Position);
  AStrategyOption.SetIntegerValue('STOP_OFFSET', UpDownSTOP_OFFSET.Position);

  AStrategyOption.SetBooleanValue('USE_REGULAR_MARKET', CheckBoxUSE_REGULAR_MARKET.Checked);

  f_Time := DateTimePickerREGULAR_START_TIME.Time - Math.Floor(DateTimePickerREGULAR_START_TIME.Time);
  AStrategyOption.SetIntegerValue('REGULAR_START_TIME', Trunc(f_Time * 86400000 + 0.5));

  f_Time := DateTimePickerREGULAR_STOP_TIME.Time - Math.Floor(DateTimePickerREGULAR_STOP_TIME.Time);
  AStrategyOption.SetIntegerValue('REGULAR_STOP_TIME', Trunc(f_Time * 86400000 + 0.5));

  f_TimeDifference := 0;
  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(m_Block.Option.GetIntegerValue('COUNTRY_NO'), m_Block.Option.GetIntegerValue('GROUP_NO'), m_Block.Option.GetIntegerValue('MARKET_NO'), m_Block.Option.GetStringValue('SYMBOL'));

    if Assigned(f_MaterialItem) then
    begin
      f_TimeDifference := f_MaterialItem.m_TimeDiffrence
    end;
  end;

  f_OpenDateTime := g_DefaultOpenTime;
  f_CloseDateTime := g_DefaultCloseTime;
  if Assigned(g_POTCollection) then
  begin
    f_POTItem := g_POTCollection.Find(TFNGlobal.ServerNow + f_TimeDifference, m_Block.Option.GetIntegerValue('COUNTRY_NO'), m_Block.Option.GetIntegerValue('GROUP_NO'), m_Block.Option.GetIntegerValue('MARKET_NO'), m_Block.Option.GetStringValue('SYMBOL'));

    if not Assigned(f_POTItem) then
    begin
      f_POTItem := g_POTCollection.Find(TFNGlobal.ServerNow + f_TimeDifference, g_DefaultCountry, g_DefaultGroup, g_DefaultMarket, g_DefaultSymbol);
    end;

    if Assigned(f_POTItem) then
    begin
      f_OpenDateTime := EncodeTime(f_POTItem.NumberToHour(f_POTItem.m_Open[0]), f_POTItem.NumberToMin(f_POTItem.m_Open[0]), 0, 0);
      f_CloseDateTime := EncodeTime(f_POTItem.NumberToHour(f_POTItem.m_Close[f_POTItem.m_HourCount - 1]), f_POTItem.NumberToMin(f_POTItem.m_Close[f_POTItem.m_HourCount - 1]), 0, 0);
    end;
  end;

  f_Time := f_OpenDateTime + AStrategyOption.GetIntegerValue('START_OFFSET') / 1440.0;
  AStrategyOption.SetIntegerValue('START_TIME', Trunc(f_Time * 86400000 + 0.5));

  f_Time := f_CloseDateTime - AStrategyOption.GetIntegerValue('STOP_OFFSET') / 1440.0;
  AStrategyOption.SetIntegerValue('STOP_TIME', Trunc(f_Time * 86400000 + 0.5));

{$ENDREGION}
{$REGION '갭처리'}
  AStrategyOption.SetBooleanValue('USER_GAB_PROCESS', CheckBoxUSER_GAB_PROCESS.Checked);
  AStrategyOption.SetIntegerValue('GAB_INSERT_MIN', UpDownGAB_INSERT_MIN.Position);
{$ENDREGION}
end;

{$REGION '전략설정화면에 대한 이벤트'}

// ---------------------------------------------------------------------------
procedure TMatrixOptionFrame.OnChangedTradeStrategyOption(Sender: TObject);
var
  f_Index: Integer;
  f_Frame: TTradeStrategyFrame;
  f_FrameOptionCategory: String;
begin
  if not Assigned(m_SelectedTradeStrategyOption) then
    exit;

  f_Frame := TTradeStrategyFrame(Sender);

  f_Frame.GetAllControlData;
  f_Frame.SetAllControlData;

  f_FrameOptionCategory := f_Frame.Option.GetStringValue(TSOPTION_KEY_CATEGORY);
  if m_SelectedTradeStrategyOption.GetStringValue(TSOPTION_KEY_CATEGORY) = f_FrameOptionCategory then
  begin
    m_SelectedTradeStrategyOption.Clone(f_Frame.Option);
    m_Random_Frame.CopyOption(m_SelectedTradeStrategyOption);
    m_ENTER_Frame.CopyOption(m_SelectedTradeStrategyOption);
    m_EXIT_Frame.CopyOption(m_SelectedTradeStrategyOption);
  end;
end;

// ---------------------------------------------------------------------------
procedure TMatrixOptionFrame.OnChangedTradeStrategyReinforce(Sender: TObject);
var
  f_Frame: TTradeStrategyFrame;
  f_FrameOptionCategory: String;
begin
  if not Assigned(m_SelectedTradeStrategyOption) then
    exit;
  if ComboBoxTradeStrategy.ItemIndex < 0 then
    exit;
  if ComboBoxTradeStrategy.ItemIndex >= m_TradeStrategyFrameCount then
    exit;

  f_Frame := m_TradeStrategyFrame[ComboBoxTradeStrategy.ItemIndex];
  if not Assigned(f_Frame) then
    exit;

  f_Frame.GetAllControlData;
  f_Frame.SetAllControlData;

  f_FrameOptionCategory := f_Frame.Option.GetStringValue(TSOPTION_KEY_CATEGORY);
  if m_SelectedTradeStrategyOption.GetStringValue(TSOPTION_KEY_CATEGORY) = f_FrameOptionCategory then
  begin
    m_SelectedTradeStrategyOption.Clone(f_Frame.Option);
    m_Random_Frame.CopyOption(m_SelectedTradeStrategyOption);
    m_ENTER_Frame.CopyOption(m_SelectedTradeStrategyOption);
    m_EXIT_Frame.CopyOption(m_SelectedTradeStrategyOption);
  end;
end;

// ---------------------------------------------------------------------------
procedure TMatrixOptionFrame.OnChangedTradeStrategyOtherFrame(Sender: TObject);
begin
  if not Assigned(m_SelectedTradeStrategyOption) then
    exit;

  m_Random_Frame.CopyOption(m_SelectedTradeStrategyOption);
  m_ENTER_Frame.CopyOption(m_SelectedTradeStrategyOption);
  m_EXIT_Frame.CopyOption(m_SelectedTradeStrategyOption);
end;

// ---------------------------------------------------------------------------
procedure TMatrixOptionFrame.DisplayTradeStrategy(AOption: CMXTradeStrategyOption);
var
  f_OldSelectedTradeStrategy: CMXTradeStrategy;
begin

end;

{$ENDREGION}

end.
