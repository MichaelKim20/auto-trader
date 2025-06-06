unit SDIMAIN;

interface

uses Winapi.Windows, System.Classes, Vcl.Graphics, Vcl.Forms, Vcl.Controls,
  Vcl.Menus, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.ImgList, Vcl.StdActns, Vcl.ActnList, Vcl.ToolWin, System.Actions,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, Vcl.Ribbon,
  Vcl.RibbonLunaStyleActnCtrls, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.CategoryButtons, Vcl.ButtonGroup;

type
  TSDIAppForm = class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    StatusBar: TStatusBar;
    ActionList1: TActionList;
    Action_2000: TAction;
    ActionAddBlock: TAction;
    Action_Exit: TAction;
    ActionDeleteBlock: TAction;
    Action_2030: TAction;
    Action_3001: TAction;
    Action_3002: TAction;
    Action_Load: TAction;
    Action_Save: TAction;
    Action_3003: TAction;
    ActionStartBlock: TAction;
    ActionStopBlock: TAction;
    Action_Close: TAction;
    ActionNextBlock: TAction;
    ActionChangeStandDate: TAction;
    ActionNextDate: TAction;
    ActionPrevDate: TAction;
    Action_Add: TAction;
    ActionExitCurrentSignal: TAction;
    Action_3004: TAction;
    Action_GoSite: TAction;
    ToolBar2: TToolBar;
    ToolButton7: TToolButton;
    ToolButton14: TToolButton;
    ToolButton8: TToolButton;
    ToolButton15: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton17: TToolButton;
    ToolButton13: TToolButton;
    ToolButton16: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ImageList1: TImageList;
    ImageListHot: TImageList;
    ImageListDisable: TImageList;
    ImageListNormal: TImageList;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    PageControl2: TPageControl;
    TabSheet10: TTabSheet;
    Panel20: TPanel;
    Panel21: TPanel;
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
    LabelACCOUNT_NAME: TLabel;
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
    Label109: TLabel;
    Label110: TLabel;
    Label112: TLabel;
    Label111: TLabel;
    ComboBoxORDER_TYPE: TComboBox;
    EditORDER_COUNT: TEdit;
    UpDownORDER_COUNT: TUpDown;
    EditSECOND_ORDER_DELAY_TIME: TEdit;
    UpDownSECOND_ORDER_DELAY_TIME: TUpDown;
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
    Label7: TLabel;
    Label8: TLabel;
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
    TabSheet11: TTabSheet;
    Panel22: TPanel;
    Panel23: TPanel;
    GroupBox11: TGroupBox;
    CheckBoxUSE_RISK_MAX_LOSS: TCheckBox;
    EditRISK_MAX_LOSS: TEdit;
    CheckBoxUSE_RISK_MAX_PROFIT: TCheckBox;
    EditRISK_MAX_PROFIT: TEdit;
    CheckBoxUSE_REALTIME_RISK_CHECK: TCheckBox;
    TabSheet12: TTabSheet;
    Panel25: TPanel;
    Panel28: TPanel;
    GroupBox5: TGroupBox;
    Label9: TLabel;
    Label11: TLabel;
    EditSendSignalName: TEdit;
    EditSendSignalFileName: TEdit;
    TabSheet15: TTabSheet;
    Panel29: TPanel;
    Panel31: TPanel;
    RadioGroupSIGNAL_MERGE_TYPE: TRadioGroup;
    GroupBox3: TGroupBox;
    Label_CP_S1: TLabel;
    Lable_CP_U1: TLabel;
    Label_CP_S2: TLabel;
    Lable_CP_U2: TLabel;
    Label_CP_S3: TLabel;
    Lable_CP_U3: TLabel;
    Lable_CP_U0: TLabel;
    Label_CP_S0: TLabel;
    Label_CP_S4: TLabel;
    Lable_CP_U4: TLabel;
    Label_CP_S5: TLabel;
    Lable_CP_U5: TLabel;
    Edit_CP_V0: TEdit;
    UpDown_CP_V0: TUpDown;
    CheckBoxUSE_CPTIMER: TCheckBox;
    Edit_CP_S1: TEdit;
    UpDown_CP_S1: TUpDown;
    ComboBox_CP_T1: TComboBox;
    Edit_CP_V1: TEdit;
    UpDown_CP_V1: TUpDown;
    CheckBox_CP_A1: TCheckBox;
    CheckBox_CP_A2: TCheckBox;
    ComboBox_CP_T2: TComboBox;
    Edit_CP_S2: TEdit;
    UpDown_CP_S2: TUpDown;
    Edit_CP_V2: TEdit;
    UpDown_CP_V2: TUpDown;
    CheckBox_CP_A3: TCheckBox;
    ComboBox_CP_T3: TComboBox;
    Edit_CP_S3: TEdit;
    UpDown_CP_S3: TUpDown;
    Edit_CP_V3: TEdit;
    UpDown_CP_V3: TUpDown;
    CheckBox_CP_A4: TCheckBox;
    ComboBox_CP_T4: TComboBox;
    Edit_CP_S4: TEdit;
    UpDown_CP_S4: TUpDown;
    Edit_CP_V4: TEdit;
    UpDown_CP_V4: TUpDown;
    CheckBox_CP_A5: TCheckBox;
    ComboBox_CP_T5: TComboBox;
    Edit_CP_S5: TEdit;
    UpDown_CP_S5: TUpDown;
    Edit_CP_V5: TEdit;
    UpDown_CP_V5: TUpDown;
    GroupBox27: TGroupBox;
    CheckBoxMergeMatchEveryBar: TCheckBox;
    EditMergeMatchCount: TEdit;
    UpDownMergeMatchCount: TUpDown;
    CheckBoxMMEBBeforFirstSignal: TCheckBox;
    CheckBoxChangeSystemValue: TCheckBox;
    TabSheet1: TTabSheet;
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
    Panel2: TPanel;
    PageControlOrder: TPageControl;
    TabSheet4: TTabSheet;
    Panel13: TPanel;
    ListViewOrder: TListView;
    TabSheet5: TTabSheet;
    Panel19: TPanel;
    ListViewTrade: TListView;
    TabSheet6: TTabSheet;
    Panel4: TPanel;
    ListViewPM: TListView;
    Panel5: TPanel;
    RadioButtonTotalView: TRadioButton;
    RadioButtonPartView: TRadioButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    IdTCPClient1: TIdTCPClient;
    ImageList2: TImageList;
    TabSheet8: TTabSheet;
    CategoryPanelGroup1: TCategoryPanelGroup;
    CategoryPanel2: TCategoryPanel;
    CategoryPanel1: TCategoryPanel;
    CategoryPanel3: TCategoryPanel;
    TabSheet13: TTabSheet;
    Shape1: TShape;
    ButtonGroup1: TButtonGroup;
    ScrollBox1: TScrollBox;
    ColorBox1: TColorBox;
    ColorListBox1: TColorListBox;
    ButtonedEdit1: TButtonedEdit;
    LabeledEdit1: TLabeledEdit;
    StaticText1: TStaticText;
    LinkLabel1: TLinkLabel;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure FileSave1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure Action_ExitExecute(Sender: TObject);
    procedure Action_LoadExecute(Sender: TObject);
    procedure Action_SaveExecute(Sender: TObject);
    procedure Action_CloseExecute(Sender: TObject);
    procedure Action_AddExecute(Sender: TObject);
    procedure Action_2000Execute(Sender: TObject);
    procedure Action_2030Execute(Sender: TObject);
    procedure Action_3001Execute(Sender: TObject);
    procedure Action_3002Execute(Sender: TObject);
    procedure Action_3003Execute(Sender: TObject);
    procedure Action_3004Execute(Sender: TObject);
    procedure ActionChangeStandDateExecute(Sender: TObject);
    procedure ActionNextDateExecute(Sender: TObject);
    procedure ActionPrevDateExecute(Sender: TObject);
    procedure ActionAddBlockExecute(Sender: TObject);
    procedure ActionDeleteBlockExecute(Sender: TObject);
    procedure ActionStartBlockExecute(Sender: TObject);
    procedure ActionStopBlockExecute(Sender: TObject);
    procedure ActionNextBlockExecute(Sender: TObject);
    procedure ActionExitCurrentSignalExecute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SDIAppForm: TSDIAppForm;

implementation

uses About;

{$R *.dfm}

procedure TSDIAppForm.FileNew1Execute(Sender: TObject);
begin
  { Do nothing }
end;

procedure TSDIAppForm.FileOpen1Execute(Sender: TObject);
begin
  OpenDialog.Execute;
end;

procedure TSDIAppForm.FileSave1Execute(Sender: TObject);
begin
  SaveDialog.Execute;
end;

procedure TSDIAppForm.Action1Execute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.ActionAddBlockExecute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.ActionChangeStandDateExecute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.ActionDeleteBlockExecute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.ActionExitCurrentSignalExecute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.ActionNextBlockExecute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.ActionNextDateExecute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.ActionPrevDateExecute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.ActionStartBlockExecute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.ActionStopBlockExecute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.Action_2000Execute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.Action_2030Execute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.Action_3001Execute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.Action_3002Execute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.Action_3003Execute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.Action_3004Execute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.Action_AddExecute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.Action_CloseExecute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.Action_ExitExecute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.Action_LoadExecute(Sender: TObject);
begin
    IdTCPClient1.Host := '210.116.104.82';
    IdTCPClient1.Port := 7795;
    try
      IdTCPClient1.Connect;
    except
    end;
end;

procedure TSDIAppForm.Action_SaveExecute(Sender: TObject);
begin
//
end;

procedure TSDIAppForm.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure TSDIAppForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

end.
