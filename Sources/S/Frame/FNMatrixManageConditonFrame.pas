unit FNMatrixManageConditonFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, MXBlockManager, FNDataDelivery, FNDataSet;

type
  TTMatrixBlockManageConditionFrame = class(TFrame)
    PageControlSummary: TPageControl;
    TabSheet1: TTabSheet;
    Panel6: TPanel;
    Panel7: TPanel;
    Bevel5: TBevel;
    GroupBox9: TGroupBox;
    Label42: TLabel;
    Label43: TLabel;
    Label46: TLabel;
    CheckBoxUseEnterA: TCheckBox;
    EditEnterAValue1: TEdit;
    GroupBox27: TGroupBox;
    CheckBoxUseEnterC1_1: TCheckBox;
    EditEnterC1_1Value1: TEdit;
    UpDownEnterC1_1Value1: TUpDown;
    CheckBoxUseEnterC1_2: TCheckBox;
    EditEnterC1_2Value1: TEdit;
    UpDownEnterC1_2Value1: TUpDown;
    CheckBoxUseEnterC1_3: TCheckBox;
    TabSheet2: TTabSheet;
    Panel4: TPanel;
    Panel14: TPanel;
    Bevel1: TBevel;
    GroupBox31: TGroupBox;
    Label116: TLabel;
    Label130: TLabel;
    CheckBox_PLC1: TCheckBox;
    GroupBox32: TGroupBox;
    Label120: TLabel;
    Label118: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Edit_PLC1_D1: TEdit;
    Edit_PLC1_D2: TEdit;
    Edit_PLC1_D3: TEdit;
    Edit_PLC1_V1: TEdit;
    Edit_PLC1_V2: TEdit;
    Edit_PLC1_V3: TEdit;
    CheckBox_PLC1_A3: TCheckBox;
    CheckBox_PLC1_A2: TCheckBox;
    CheckBox_PLC1_A1: TCheckBox;
    Edit_PLC1_D4: TEdit;
    CheckBox_PLC1_A4: TCheckBox;
    Edit_PLC1_V4: TEdit;
    Edit_PLC1_V6: TEdit;
    Edit_PLC1_V5: TEdit;
    CheckBox_PLC1_A6: TCheckBox;
    CheckBox_PLC1_A5: TCheckBox;
    Edit_PLC1_D6: TEdit;
    Edit_PLC1_D5: TEdit;
    GroupBox4: TGroupBox;
    Label20: TLabel;
    Label21: TLabel;
    CheckBoxUsePLC1Type3: TCheckBox;
    EditPLC1Type3: TEdit;
    GroupBox18: TGroupBox;
    Label35: TLabel;
    Label36: TLabel;
    Label32: TLabel;
    Label38: TLabel;
    Label60: TLabel;
    CheckBoxUsePLC1Type2: TCheckBox;
    EditPLC1Type2Value2: TEdit;
    EditPLC1Type2Value1: TEdit;
    GroupBox20: TGroupBox;
    Label86: TLabel;
    Label88: TLabel;
    Label96: TLabel;
    CheckBoxUsePLC1Type4: TCheckBox;
    CheckBoxUsePLC1Type4_1: TCheckBox;
    CheckBoxUsePLC1Type4_2: TCheckBox;
    CheckBoxUsePLC1Type4_3: TCheckBox;
    EditPLC1Type4Value1: TEdit;
    UpDownPLC1Type4Value1: TUpDown;
    UpDownPLC1Type4Value2: TUpDown;
    EditPLC1Type4Value2: TEdit;
    EditPLC1Type4Value3: TEdit;
    EditPLC1Type4Value4: TEdit;
    UpDownPLC1Type4Value4: TUpDown;
    EditPLC1Type4Value5: TEdit;
    GroupBox23: TGroupBox;
    CheckBoxUsePLC1TypeC_1: TCheckBox;
    EditPLC1TypeCValue1: TEdit;
    UpDownPLC1TypeCValue1: TUpDown;
    CheckBoxUsePLC1TypeC_2: TCheckBox;
    EditPLC1TypeCValue2: TEdit;
    UpDownPLC1TypeCValue2: TUpDown;
    CheckBoxUsePLC1TypeC_3: TCheckBox;
    TabSheet3: TTabSheet;
    Panel1: TPanel;
    Panel5: TPanel;
    Bevel4: TBevel;
    GroupBox3: TGroupBox;
    Label13: TLabel;
    CheckBoxUseReEnter1: TCheckBox;
    GroupBox7: TGroupBox;
    Label45: TLabel;
    Label16: TLabel;
    Label41: TLabel;
    CheckBoxUseReEnter2: TCheckBox;
    EditReEnter2Value1: TEdit;
    EditReEnter2Value2: TEdit;
    GroupBox8: TGroupBox;
    Label27: TLabel;
    Label29: TLabel;
    Label11: TLabel;
    Label30: TLabel;
    UpDownReEnter0Value2: TUpDown;
    EditReEnter0Value2: TEdit;
    EditReEnter0Value1: TEdit;
    UpDownReEnter0Value1: TUpDown;
    GroupBox12: TGroupBox;
    Label54: TLabel;
    Label55: TLabel;
    Label4: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label61: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    CheckBoxUseReEnter3: TCheckBox;
    EditReEnter3Value3: TEdit;
    EditReEnter3Value1: TEdit;
    EditReEnter3Value2: TEdit;
    EditReEnter3Value4: TEdit;
    GroupBox11: TGroupBox;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    CheckBoxUseReEnterA: TCheckBox;
    EditReEnterAValue1: TEdit;
    GroupBox15: TGroupBox;
    CheckBoxUseMA1ConsecutiveUp: TCheckBox;
    EditMA1ConsecutiveUpCount: TEdit;
    UpDownMA1ConsecutiveUpCount: TUpDown;
    CheckBoxUseMA2ConsecutiveUp: TCheckBox;
    EditMA2ConsecutiveUpCount: TEdit;
    UpDownMA2ConsecutiveUpCount: TUpDown;
    CheckBoxUseMA1AboveMA2: TCheckBox;
    GroupBox16: TGroupBox;
    Label53: TLabel;
    Label74: TLabel;
    Label44: TLabel;
    CheckBoxUseReEnter4: TCheckBox;
    EditReEnter4Value1: TEdit;
    EditReEnter4Value2: TEdit;
    GroupBox22: TGroupBox;
    CheckBoxUseReEnter5: TCheckBox;
    CheckBoxUseReEnter5_1: TCheckBox;
    EditReEnter5_1Value1: TEdit;
    UpDownReEnter5_1Value1: TUpDown;
    CheckBoxUseReEnter5_2: TCheckBox;
    CheckBoxUseReEnter5_3: TCheckBox;
    EditReEnter5_2Value1: TEdit;
    UpDownReEnter5_2Value1: TUpDown;
    GroupBox29: TGroupBox;
    Label99: TLabel;
    Label100: TLabel;
    Label102: TLabel;
    CheckBoxUseReEnter6: TCheckBox;
    EditReEnter6Value2: TEdit;
    EditReEnter6Value1: TEdit;
    UpDownReEnter6Value1: TUpDown;
    GroupBox30: TGroupBox;
    Label101: TLabel;
    Label105: TLabel;
    CheckBoxUseReEnterB: TCheckBox;
    EditReEnterBValue1: TEdit;
    EditReEnterBValue2: TEdit;
    TabSheet4: TTabSheet;
    Panel2: TPanel;
    Panel3: TPanel;
    Bevel3: TBevel;
    GroupBox2: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label34: TLabel;
    Label37: TLabel;
    Edit_PLC2_D1: TEdit;
    Edit_PLC2_D2: TEdit;
    Edit_PLC2_D3: TEdit;
    Edit_PLC2_V1: TEdit;
    Edit_PLC2_V2: TEdit;
    Edit_PLC2_V3: TEdit;
    CheckBox_PLC2_A3: TCheckBox;
    CheckBox_PLC2_A2: TCheckBox;
    CheckBox_PLC2_A1: TCheckBox;
    Edit_PLC2_D4: TEdit;
    CheckBox_PLC2_A4: TCheckBox;
    Edit_PLC2_V4: TEdit;
    Edit_PLC2_V6: TEdit;
    Edit_PLC2_V5: TEdit;
    CheckBox_PLC2_A6: TCheckBox;
    CheckBox_PLC2_A5: TCheckBox;
    Edit_PLC2_D6: TEdit;
    Edit_PLC2_D5: TEdit;
    CheckBox_PLC2: TCheckBox;
    GroupBox5: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    CheckBoxUsePLC2Type2: TCheckBox;
    EditPLC2Type2Value2: TEdit;
    EditPLC2Type2Value1: TEdit;
    GroupBox6: TGroupBox;
    Label6: TLabel;
    Label28: TLabel;
    Label31: TLabel;
    Label33: TLabel;
    CheckBoxUsePLC2Type3: TCheckBox;
    EditPLC2Type3: TEdit;
    EditReEnterValue3: TEdit;
    GroupBox24: TGroupBox;
    CheckBoxUsePLC2TypeC_1: TCheckBox;
    EditPLC2TypeCValue1: TEdit;
    UpDownPLC2TypeCValue1: TUpDown;
    CheckBoxUsePLC2TypeC_2: TCheckBox;
    EditPLC2TypeCValue2: TEdit;
    UpDownPLC2TypeCValue2: TUpDown;
    CheckBoxUsePLC2TypeC_3: TCheckBox;
    GroupBox21: TGroupBox;
    Label91: TLabel;
    Label12: TLabel;
    CheckBoxUsePLC2Type4: TCheckBox;
    CheckBoxUsePLC2Type4_1: TCheckBox;
    CheckBoxUsePLC2Type4_2: TCheckBox;
    CheckBoxUsePLC2Type4_3: TCheckBox;
    EditPLC2Type4Value1: TEdit;
    UpDownPLC2Type4Value1: TUpDown;
    UpDownPLC2Type4Value2: TUpDown;
    EditPLC2Type4Value2: TEdit;
    EditPLC2Type4Value3: TEdit;
    EditPLC2Type4Value4: TEdit;
    UpDownPLC2Type4Value4: TUpDown;
    EditPLC2Type4Value5: TEdit;
    TabSheet5: TTabSheet;
    Panel8: TPanel;
    Panel9: TPanel;
    GroupBox13: TGroupBox;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    CheckBoxUseLossTradeStop: TCheckBox;
    EditLossTradeStopValue1: TEdit;
    GroupBox14: TGroupBox;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    CheckBoxUseProfitTradeStop: TCheckBox;
    EditProfitTradeStopValue1: TEdit;
    TabSheet6: TTabSheet;
    Bevel2: TBevel;
    Panel13: TPanel;
    Panel15: TPanel;
    GroupBox19: TGroupBox;
    Label68: TLabel;
    Label69: TLabel;
    EditMA1Number: TEdit;
    UpDownMA1Number: TUpDown;
    EditMA2Number: TEdit;
    UpDownMA2Number: TUpDown;
    ComboBoxMAType: TComboBox;
    TabSheet7: TTabSheet;
    Panel10: TPanel;
    Panel11: TPanel;
    GroupBox17: TGroupBox;
    Label80: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label97: TLabel;
    ComboBoxASS_DATECOUNT4: TComboBox;
    EditASS_PERCENT_PROFITABLE: TEdit;
    EditASS_PROFIT_FACTOR: TEdit;
    EditASS_MAXDRAWDOWN: TEdit;
    ButtonRQ: TButton;
    ButtonApply: TButton;
    ComboBoxASS_TYPE: TComboBox;
    Panel12: TPanel;
    ListViewASSItem: TListView;
    TabSheet8: TTabSheet;
    Panel16: TPanel;
    Panel17: TPanel;
    GroupBox26: TGroupBox;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    EditCommission: TEdit;
    GroupBox33: TGroupBox;
    CheckBoxUseEnter2: TCheckBox;
    CheckBoxUseEnter2_1: TCheckBox;
    EditEnter2Value1: TEdit;
    UpDownEnter2Value1: TUpDown;
    CheckBoxUseEnter2_2: TCheckBox;
    CheckBoxUseEnter2_3: TCheckBox;
    EditEnter2Value2: TEdit;
    UpDownEnter2Value2: TUpDown;
    GroupBox25: TGroupBox;
    CheckBox_UsePrevData: TCheckBox;
    CheckBox_FS_PrevData: TCheckBox;
    GroupBox10: TGroupBox;
    Label48: TLabel;
    Label47: TLabel;
    Label49: TLabel;
    Label89: TLabel;
    CheckBoxUseEnterB: TCheckBox;
    EditEnterBValue1: TEdit;
    UpDownEnterBValue1: TUpDown;
    DateTimePickerEnterBValue1: TDateTimePicker;
    GroupBox34: TGroupBox;
    Panel20: TPanel;
    Panel21: TPanel;
    ListViewOPSSymbol: TListView;
    Panel22: TPanel;
    Label136: TLabel;
    ComboBoxSymbolPrevDataType: TComboBox;
    Panel23: TPanel;
    CheckBox_FS_PrevDataType: TCheckBox;
    GroupBox28: TGroupBox;
    Label98: TLabel;
    Label107: TLabel;
    EditPortfolioGroupName: TEdit;
    EditPortfolioName: TEdit;
    Label93: TLabel;
    GroupBox35: TGroupBox;
    Label14: TLabel;
    Label87: TLabel;
    Label90: TLabel;
    CheckBoxUsePLC2Type5: TCheckBox;
    CheckBoxUsePLC2Type5_1: TCheckBox;
    CheckBoxUsePLC2Type5_2: TCheckBox;
    CheckBoxUsePLC2Type5_3: TCheckBox;
    EditPLC2Type5Value1: TEdit;
    UpDownPLC2Type5Value1: TUpDown;
    UpDownPLC2Type5Value2: TUpDown;
    EditPLC2Type5Value2: TEdit;
    EditPLC2Type5Value3: TEdit;
    EditPLC2Type5Value4: TEdit;
    UpDownPLC2Type5Value4: TUpDown;
    EditPLC2Type5Value5: TEdit;
    GroupBox36: TGroupBox;
    Label92: TLabel;
    Label94: TLabel;
    Label111: TLabel;
    CheckBoxUseReEnterC: TCheckBox;
    EditReEnterCValue1: TEdit;
    EditReEnterCValue2: TEdit;
    CheckBoxUseEnter2_4: TCheckBox;
    EditEnter2Value4: TEdit;
    CheckBoxUseEnter2_6: TCheckBox;
    CheckBoxUseEnter2_7: TCheckBox;
    EditEnter2Value6: TEdit;
    EditEnter2Value7: TEdit;
    CheckBoxUseEnter2_5: TCheckBox;
    EditEnter2Value5: TEdit;
    GroupBox37: TGroupBox;
    Label109: TLabel;
    CheckBoxUseReEnterD: TCheckBox;
    Label108: TLabel;
    EditReEnterDValue1: TEdit;
    UpDownReEnterDValue1: TUpDown;
    EditReEnterDValue2: TEdit;
    EditReEnterDValue3: TEdit;
    Label113: TLabel;
    Bevel6: TBevel;
    Label110: TLabel;
    TabSheet9: TTabSheet;
    PanelCommand: TPanel;
    Panel19: TPanel;
    Button2: TButton;
    Button1: TButton;
    GroupBox38: TGroupBox;
    CheckBoxUseReverse: TCheckBox;
    Button3: TButton;
    Label95: TLabel;
    EditMA0Number: TEdit;
    UpDownMA0Number: TUpDown;
    CheckBoxUseEnterC1_0: TCheckBox;
    EditEnterC1_0Value1: TEdit;
    UpDownEnterC1_0Value1: TUpDown;
    CheckBoxUseEnterC1_5: TCheckBox;
    CheckBoxUseEnterC1_6: TCheckBox;
    EditEnterC1_6Value1: TEdit;
    EditEnterC1_5Value1: TEdit;
    CheckBoxUseEnterC1_4: TCheckBox;
    EditEnterC1_4Value1: TEdit;
    CheckBoxUseReEnterC3_4: TCheckBox;
    EditReEnterC3_4Value1: TEdit;
    CheckBoxUseReEnterC3_5: TCheckBox;
    EditReEnterC3_5Value1: TEdit;
    CheckBoxUseReEnterC3_6: TCheckBox;
    EditReEnterC3_6Value1: TEdit;

    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure OptionChange(Sender: TObject);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure EditEnterBValue1Change(Sender: TObject);
    procedure ButtonApplyClick(Sender: TObject);
    procedure ComboBoxSymbolPrevDataTypeChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    m_EnableControl:Boolean;
    m_EnableEvent:Boolean;
    m_Condition:CMXBlockManagerCondition;
    m_DataDelivery:CFNDataDelivery;
    m_IDataPackage:CFNDataPackage;
    m_ODataPackage:CFNDataPackage;
    m_ApplySymbolAndMA : TNotifyEvent;

    m_EditInRuntime : Boolean;


  public
    procedure OnFormCreate;
    procedure OnFormClose;
    procedure GetOption;
    procedure SetOption;

    procedure UpdateControl;
    procedure AttachCondition(ACondition:CMXBlockManagerCondition);
    function DetachCondition(AUpdate:Boolean=false):CMXBlockManagerCondition;
    procedure SetEnable(AValue:Boolean);

    procedure SetEditInRuntime(AValue:Boolean);
    function GetEditInRuntime:Boolean;
    procedure SetControlEnable;

  end;

implementation

{$R *.dfm}

uses Math, FNGlobal, DateUtils, FNCMVariable, MXSystemManager, MXOrderManager, FNPOTCollection, MXVariable;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.OnFormCreate;
begin

    m_EnableControl := true;
    m_EditInRuntime := false;
    PageControlSummary.ActivePageIndex := 0;
    SetOption;
    UpdateControl;

    if  (
            (CompareText(g_MatrixUserID, 'matrix') = 0) or
            (CompareText(g_MatrixUserID, 'dev') = 0)
        ) then
    begin

    end else
    begin
        PanelCommand.Visible := false;
    end;
end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.OnFormClose;
begin

end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.AttachCondition(ACondition: CMXBlockManagerCondition);
begin
    m_Condition := ACondition;

    if Assigned(m_Condition) then
    begin
        SetOption;
        UpdateControl;
    end;
end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.Button1Click(Sender: TObject);
begin
//
end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.ButtonApplyClick(Sender: TObject);
begin
    if Assigned(m_ApplySymbolAndMA) then m_ApplySymbolAndMA(Self);
end;


//------------------------------------------------------------------------------------
function TTMatrixBlockManageConditionFrame.DetachCondition(AUpdate: Boolean): CMXBlockManagerCondition;
begin
    Result := m_Condition;

    m_Condition := NIL;

    if AUpdate then
    begin
        SetEnable(false);
    end;
end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.ComboBoxSymbolPrevDataTypeChange(Sender: TObject);
begin
end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.EditEnterBValue1Change(Sender: TObject);
begin
    UpDownEnterBValue1.Position := TFNGlobal.atoi(EditEnterBValue1.Text);
end;

//------------------------------------------------------------------------------------
function TTMatrixBlockManageConditionFrame.GetEditInRuntime: Boolean;
begin
    result := m_EditInRuntime;
end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.SetEditInRuntime(AValue:Boolean);
begin
    m_EditInRuntime := AValue;
    SetControlEnable;
end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.EditKeyPress(Sender: TObject; var Key: Char);
begin
    if Key in ['0'..'9', '-', #8, #9, #32, #3, #22, #$2E] then // 0~9, -, Tab, BS, Space, Ctrl+C, Ctrl+V ?? ???
    begin
    end else
    begin
        Key := #0;
    end;
end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
    if not Assigned(m_Condition) then exit;
    if not m_EnableEvent then exit;
    GetOption;
    UpdateControl;
end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.OptionChange(Sender: TObject);
begin
    if not Assigned(m_Condition) then exit;
    if not m_EnableEvent then exit;
    GetOption;
    UpdateControl;
end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.SetEnable(AValue: Boolean);
begin
    m_EnableControl := AValue;

    SetControlEnable;
end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.SetOption;
begin
    if not Assigned(m_Condition) then exit;

    m_EnableEvent := false;

    EditPortfolioGroupName.Text := m_Condition.m_PortfolioGroupName;
    EditPortfolioName.Text      := m_Condition.m_PortfolioName;

    CheckBox_PLC1.Checked := m_Condition.m_UsePLC1;

    Edit_PLC1_V1.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC1_V[0], 1);
    Edit_PLC1_V2.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC1_V[1], 1);
    Edit_PLC1_V3.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC1_V[2], 1);
    Edit_PLC1_V4.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC1_V[3], 1);
    Edit_PLC1_V5.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC1_V[4], 1);
    Edit_PLC1_V6.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC1_V[5], 1);

    Edit_PLC1_D1.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC1_D[0], 1);
    Edit_PLC1_D2.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC1_D[1], 1);
    Edit_PLC1_D3.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC1_D[2], 1);
    Edit_PLC1_D4.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC1_D[3], 1);
    Edit_PLC1_D5.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC1_D[4], 1);
    Edit_PLC1_D6.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC1_D[5], 1);

    CheckBox_PLC1_A1.Checked := m_Condition.m_PLC1_A[0];
    CheckBox_PLC1_A2.Checked := m_Condition.m_PLC1_A[1];
    CheckBox_PLC1_A3.Checked := m_Condition.m_PLC1_A[2];
    CheckBox_PLC1_A4.Checked := m_Condition.m_PLC1_A[3];
    CheckBox_PLC1_A5.Checked := m_Condition.m_PLC1_A[4];
    CheckBox_PLC1_A6.Checked := m_Condition.m_PLC1_A[5];

    CheckBoxUsePLC1Type2.Checked  := m_Condition.m_UsePLC1Type2;
    EditPLC1Type2Value1.Text      := TFNGlobal.WriteNumberF(m_Condition.m_PLC1Type2Value1, 1);
    EditPLC1Type2Value2.Text      := TFNGlobal.WriteNumberF(m_Condition.m_PLC1Type2Value2, 1);

    CheckBoxUsePLC1Type3.Checked  := m_Condition.m_UsePLC1Type3;
    EditPLC1Type3.Text            := TFNGlobal.WriteNumberF(m_Condition.m_PLC1Type3, 1);

    CheckBoxUseReEnter1.Checked   := m_Condition.m_UseReEnter1;

    CheckBoxUseReEnter2.Checked   := m_Condition.m_UseReEnter2;
    EditReEnter2Value1.Text       := TFNGlobal.WriteNumberF(m_Condition.m_ReEnter2Value1, 1);
    EditReEnter2Value2.Text       := TFNGlobal.WriteNumberF(m_Condition.m_ReEnter2Value2, 1);

    UpDownReEnter0Value1.Position := Trunc(m_Condition.m_ReEnter0Value1);
    UpDownReEnter0Value2.Position := Trunc(m_Condition.m_ReEnter0Value2);

    CheckBox_PLC2.Checked := m_Condition.m_UsePLC2;

    Edit_PLC2_V1.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC2_V[0], 1);
    Edit_PLC2_V2.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC2_V[1], 1);
    Edit_PLC2_V3.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC2_V[2], 1);
    Edit_PLC2_V4.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC2_V[3], 1);
    Edit_PLC2_V5.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC2_V[4], 1);
    Edit_PLC2_V6.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC2_V[5], 1);

    Edit_PLC2_D1.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC2_D[0], 1);
    Edit_PLC2_D2.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC2_D[1], 1);
    Edit_PLC2_D3.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC2_D[2], 1);
    Edit_PLC2_D4.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC2_D[3], 1);
    Edit_PLC2_D5.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC2_D[4], 1);
    Edit_PLC2_D6.Text :=  TFNGlobal.WriteNumberF(m_Condition.m_PLC2_D[5], 1);

    CheckBox_PLC2_A1.Checked := m_Condition.m_PLC2_A[0];
    CheckBox_PLC2_A2.Checked := m_Condition.m_PLC2_A[1];
    CheckBox_PLC2_A3.Checked := m_Condition.m_PLC2_A[2];
    CheckBox_PLC2_A4.Checked := m_Condition.m_PLC2_A[3];
    CheckBox_PLC2_A5.Checked := m_Condition.m_PLC2_A[4];
    CheckBox_PLC2_A6.Checked := m_Condition.m_PLC2_A[5];

    CheckBoxUsePLC2Type2.Checked    := m_Condition.m_UsePLC2Type2;
    EditPLC2Type2Value1.Text        := TFNGlobal.WriteNumberF(m_Condition.m_PLC2Type2Value1, 1);
    EditPLC2Type2Value2.Text        := TFNGlobal.WriteNumberF(m_Condition.m_PLC2Type2Value2, 1);

    CheckBoxUsePLC2Type3.Checked    := m_Condition.m_UsePLC2Type3;
    EditPLC2Type3.Text              := TFNGlobal.WriteNumberF(m_Condition.m_PLC2Type3, 1);

    CheckBoxUseEnterA.Checked       := m_Condition.m_UseEnterA;
    EditEnterAValue1.Text           := TFNGlobal.WriteNumberF(m_Condition.m_EnterAValue1, 1);

    CheckBoxUseEnter2.Checked       := m_Condition.m_UseEnter2;
    CheckBoxUseEnter2_1.Checked     := m_Condition.m_UseEnter2_1;
    CheckBoxUseEnter2_2.Checked     := m_Condition.m_UseEnter2_2;
    CheckBoxUseEnter2_3.Checked     := m_Condition.m_UseEnter2_3;
    CheckBoxUseEnter2_4.Checked     := m_Condition.m_UseEnter2_4;
    CheckBoxUseEnter2_5.Checked     := m_Condition.m_UseEnter2_5;
    CheckBoxUseEnter2_6.Checked     := m_Condition.m_UseEnter2_6;
    CheckBoxUseEnter2_7.Checked     := m_Condition.m_UseEnter2_7;


    UpDownEnter2Value1.Position     := Trunc(m_Condition.m_Enter2Value1);
    UpDownEnter2Value2.Position     := Trunc(m_Condition.m_Enter2Value2);
    EditEnter2Value4.Text           := TFNGlobal.WriteNumberF(m_Condition.m_Enter2Value4, 1);
    EditEnter2Value5.Text           := TFNGlobal.WriteNumberF(m_Condition.m_Enter2Value5, 1);
    EditEnter2Value6.Text           := TFNGlobal.WriteNumberF(m_Condition.m_Enter2Value6, 1);
    EditEnter2Value7.Text           := TFNGlobal.WriteNumberF(m_Condition.m_Enter2Value7, 1);

    CheckBoxUseEnterB.Checked := m_Condition.m_UseEnterB;
    UpDownEnterBValue1.Position := Trunc(m_Condition.m_EnterBValue1);
    //DateTimePickerEnterBValue1.Enabled := AValue;

    CheckBoxUseReEnter3.Checked := m_Condition.m_UseReEnter3;
    EditReEnter3Value1.Text := TFNGlobal.WriteNumberF(m_Condition.m_ReEnter3Value1, 1);
    EditReEnter3Value2.Text := TFNGlobal.WriteNumberF(m_Condition.m_ReEnter3Value2, 1);
    EditReEnter3Value3.Text := TFNGlobal.WriteNumberF(m_Condition.m_ReEnter3Value3, 1);
    EditReEnter3Value4.Text := TFNGlobal.WriteNumberF(m_Condition.m_ReEnter3Value4, 1);

    CheckBoxUseReEnter4.Checked := m_Condition.m_UseReEnter4;
    EditReEnter4Value1.Text := TFNGlobal.WriteNumberF(m_Condition.m_ReEnter4Value1, 1);
    EditReEnter4Value2.Text := TFNGlobal.WriteNumberF(m_Condition.m_ReEnter4Value2, 1);

    CheckBoxUseEnterC1_0.Checked        := m_Condition.m_UseEnterTypeC1_0;
    UpDownEnterC1_0Value1.Position       := Trunc(m_Condition.m_EnterTypeC1_0Value1);

    CheckBoxUseEnterC1_1.Checked        := m_Condition.m_UseEnterTypeC1_1;
    UpDownEnterC1_1Value1.Position       := Trunc(m_Condition.m_EnterTypeC1_1Value1);
    CheckBoxUseEnterC1_2.Checked        := m_Condition.m_UseEnterTypeC1_2;
    UpDownEnterC1_2Value1.Position       := Trunc(m_Condition.m_EnterTypeC1_2Value1);
    CheckBoxUseEnterC1_3.Checked        := m_Condition.m_UseEnterTypeC1_3;

    CheckBoxUseEnterC1_4.Checked        := m_Condition.m_UseEnterTypeC1_4;
    EditEnterC1_4Value1.Text := TFNGlobal.WriteNumberF(m_Condition.m_EnterTypeC1_4Value1, 1);
    CheckBoxUseEnterC1_5.Checked        := m_Condition.m_UseEnterTypeC1_5;
    EditEnterC1_5Value1.Text := TFNGlobal.WriteNumberF(m_Condition.m_EnterTypeC1_5Value1, 1);
    CheckBoxUseEnterC1_6.Checked        := m_Condition.m_UseEnterTypeC1_6;
    EditEnterC1_6Value1.Text := TFNGlobal.WriteNumberF(m_Condition.m_EnterTypeC1_6Value1, 1);

    CheckBoxUseReEnter5.Checked         := m_Condition.m_UseReEnter5;
    CheckBoxUseReEnter5_1.Checked       := m_Condition.m_UseReEnter5_1;
    UpDownReEnter5_1Value1.Position     := Trunc(m_Condition.m_ReEnter5_1Value1);
    CheckBoxUseReEnter5_2.Checked       := m_Condition.m_UseReEnter5_2;
    UpDownReEnter5_2Value1.Position     := Trunc(m_Condition.m_ReEnter5_2Value1);
    CheckBoxUseReEnter5_3.Checked       := m_Condition.m_UseReEnter5_3;

    CheckBoxUseReEnter6.Checked := m_Condition.m_UseReEnter6;
    UpDownReEnter6Value1.Position := Trunc(m_Condition.m_ReEnter6Value1);
    EditReEnter6Value2.Text := TFNGlobal.WriteNumberF(m_Condition.m_ReEnter6Value2, 1);


    CheckBoxUseReEnterA.Checked         := m_Condition.m_UseReEnterA;
    EditReEnterAValue1.Text             := TFNGlobal.WriteNumberF(m_Condition.m_ReEnterAValue1, 1);

    CheckBoxUseReEnterB.Checked         := m_Condition.m_UseReEnterB;
    EditReEnterBValue1.Text             := TFNGlobal.WriteNumberF(m_Condition.m_ReEnterBValue1, 1);
    EditReEnterBValue2.Text             := TFNGlobal.WriteNumberF(m_Condition.m_ReEnterBValue2, 1);


    CheckBoxUseReEnterC.Checked         := m_Condition.m_UseReEnterC;
    EditReEnterCValue1.Text             := TFNGlobal.WriteNumberF(m_Condition.m_ReEnterCValue1, 1);
    EditReEnterCValue2.Text             := TFNGlobal.WriteNumberF(m_Condition.m_ReEnterCValue2, 1);


    CheckBoxUseReEnterD.Checked         := m_Condition.m_UseReEnterD;
    UpDownReEnterDValue1.Position       := Trunc(m_Condition.m_ReEnterDValue1);
    EditReEnterDValue2.Text             := TFNGlobal.WriteNumberF(m_Condition.m_ReEnterDValue2, 1);
    EditReEnterDValue3.Text             := TFNGlobal.WriteNumberF(m_Condition.m_ReEnterDValue3, 1);



    CheckBoxUseLossTradeStop.Checked    := m_Condition.m_UseLossTradeStop;
    EditLossTradeStopValue1.Text        := TFNGlobal.WriteNumberF(m_Condition.m_LossTradeStopValue1, 1);

    CheckBoxUseProfitTradeStop.Checked   := m_Condition.m_UseProfitTradeStop;
    EditProfitTradeStopValue1.Text       := TFNGlobal.WriteNumberF(m_Condition.m_ProfitTradeStopValue1, 1);

    CheckBoxUseMA1ConsecutiveUp.Checked  := m_Condition.m_UseMA1ConsecutiveUp;
    UpDownMA1ConsecutiveUpCount.Position := m_Condition.m_MA1ConsecutiveUpCount;
    CheckBoxUseMA2ConsecutiveUp.Checked  := m_Condition.m_UseMA2ConsecutiveUp;
    UpDownMA2ConsecutiveUpCount.Position := m_Condition.m_MA2ConsecutiveUpCount;
    CheckBoxUseMA1AboveMA2.Checked       := m_Condition.m_UseMA1AboveMA2;

    CheckBoxUseReEnterC3_4.Checked        := m_Condition.m_UseReEnterTypeC3_4;
    EditReEnterC3_4Value1.Text            := TFNGlobal.WriteNumberF(m_Condition.m_ReEnterTypeC3_4Value1, 1);
    CheckBoxUseReEnterC3_5.Checked        := m_Condition.m_UseReEnterTypeC3_5;
    EditReEnterC3_5Value1.Text            := TFNGlobal.WriteNumberF(m_Condition.m_ReEnterTypeC3_5Value1, 1);
    CheckBoxUseReEnterC3_6.Checked        := m_Condition.m_UseReEnterTypeC3_6;
    EditReEnterC3_6Value1.Text            := TFNGlobal.WriteNumberF(m_Condition.m_ReEnterTypeC3_6Value1, 1);

    ComboBoxMAType.ItemIndex             := m_Condition.m_MAType;
    UpDownMA0Number.Position             := m_Condition.m_MA0Number;
    UpDownMA1Number.Position             := m_Condition.m_MA1Number;
    UpDownMA2Number.Position             := m_Condition.m_MA2Number;

    CheckBoxUsePLC1Type4.Checked         := m_Condition.m_UsePLC1Type4;
    CheckBoxUsePLC1Type4_1.Checked       := m_Condition.m_UsePLC1Type4_1;
    UpDownPLC1Type4Value1.Position       := Trunc(m_Condition.m_PLC1Type4_1Value1);
    CheckBoxUsePLC1Type4_2.Checked       := m_Condition.m_UsePLC1Type4_2;
    UpDownPLC1Type4Value2.Position       := Trunc(m_Condition.m_PLC1Type4_2Value1);
    CheckBoxUsePLC1Type4_3.Checked       := m_Condition.m_UsePLC1Type4_3;

    EditPLC1Type4Value3.Text             := TFNGlobal.WriteNumberF(m_Condition.m_PLC1Type4Value3, 1);
    UpDownPLC1Type4Value4.Position       := Trunc(m_Condition.m_PLC1Type4Value4);
    EditPLC1Type4Value5.Text             := TFNGlobal.WriteNumberF(m_Condition.m_PLC1Type4Value5, 1);

    CheckBoxUsePLC2Type4.Checked         := m_Condition.m_UsePLC2Type4;
    CheckBoxUsePLC2Type4_1.Checked       := m_Condition.m_UsePLC2Type4_1;
    UpDownPLC2Type4Value1.Position       := Trunc(m_Condition.m_PLC2Type4_1Value1);
    CheckBoxUsePLC2Type4_2.Checked       := m_Condition.m_UsePLC2Type4_2;
    UpDownPLC2Type4Value2.Position       := Trunc(m_Condition.m_PLC2Type4_2Value1);
    CheckBoxUsePLC2Type4_3.Checked       := m_Condition.m_UsePLC2Type4_3;

    EditPLC2Type4Value3.Text             := TFNGlobal.WriteNumberF(m_Condition.m_PLC2Type4Value3, 1);
    UpDownPLC2Type4Value4.Position       := Trunc(m_Condition.m_PLC2Type4Value4);
    EditPLC2Type4Value5.Text             := TFNGlobal.WriteNumberF(m_Condition.m_PLC2Type4Value5, 1);

    CheckBoxUsePLC2Type5.Checked         := m_Condition.m_UsePLC2Type5;
    CheckBoxUsePLC2Type5_1.Checked       := m_Condition.m_UsePLC2Type5_1;
    UpDownPLC2Type5Value1.Position       := Trunc(m_Condition.m_PLC2Type5_1Value1);
    CheckBoxUsePLC2Type5_2.Checked       := m_Condition.m_UsePLC2Type5_2;
    UpDownPLC2Type5Value2.Position       := Trunc(m_Condition.m_PLC2Type5_2Value1);
    CheckBoxUsePLC2Type5_3.Checked       := m_Condition.m_UsePLC2Type5_3;

    EditPLC2Type5Value3.Text             := TFNGlobal.WriteNumberF(m_Condition.m_PLC2Type5Value3, 1);
    UpDownPLC2Type5Value4.Position       := Trunc(m_Condition.m_PLC2Type5Value4);
    EditPLC2Type5Value5.Text             := TFNGlobal.WriteNumberF(m_Condition.m_PLC2Type5Value5, 1);


    CheckBoxUsePLC1TypeC_1.Checked       := m_Condition.m_UsePLC1TypeC_1;
    UpDownPLC1TypeCValue1.Position       := Trunc(m_Condition.m_PLC1TypeC_1Value1);
    CheckBoxUsePLC1TypeC_2.Checked       := m_Condition.m_UsePLC1TypeC_2;
    UpDownPLC1TypeCValue2.Position       := Trunc(m_Condition.m_PLC1TypeC_2Value1);
    CheckBoxUsePLC1TypeC_3.Checked       := m_Condition.m_UsePLC1TypeC_3;

    CheckBoxUsePLC2TypeC_1.Checked       := m_Condition.m_UsePLC2TypeC_1;
    UpDownPLC2TypeCValue1.Position       := Trunc(m_Condition.m_PLC2TypeC_1Value1);
    CheckBoxUsePLC2TypeC_2.Checked       := m_Condition.m_UsePLC2TypeC_2;
    UpDownPLC2TypeCValue2.Position       := Trunc(m_Condition.m_PLC2TypeC_2Value1);
    CheckBoxUsePLC2TypeC_3.Checked       := m_Condition.m_UsePLC2TypeC_3;


    if (m_Condition.m_ASS_DATECOUNT4 = 15) then ComboBoxASS_DATECOUNT4.ItemIndex := 0
    else if (m_Condition.m_ASS_DATECOUNT4 = 30) then ComboBoxASS_DATECOUNT4.ItemIndex := 1
    else if (m_Condition.m_ASS_DATECOUNT4 = 60) then ComboBoxASS_DATECOUNT4.ItemIndex := 2
    else if (m_Condition.m_ASS_DATECOUNT4 = 120) then ComboBoxASS_DATECOUNT4.ItemIndex := 3
    else if (m_Condition.m_ASS_DATECOUNT4 = 180) then ComboBoxASS_DATECOUNT4.ItemIndex := 4
    else ComboBoxASS_DATECOUNT4.ItemIndex := 1;

    EditASS_PERCENT_PROFITABLE.Text := TFNGlobal.WriteNumberF(m_Condition.m_ASS_PERCENT_PROFITABLE, 2);
    EditASS_PROFIT_FACTOR.Text      := TFNGlobal.WriteNumberF(m_Condition.m_ASS_PROFIT_FACTOR, 2);
    EditASS_MAXDRAWDOWN.Text        := TFNGlobal.WriteNumberF(m_Condition.m_ASS_MAXDRAWDOWN, 2);
    ComboBoxASS_TYPE.ItemIndex := m_Condition.m_ASS_TYPE;

    CheckBox_FS_PrevData.Checked            := m_Condition.m_FS_PrevData;
    CheckBox_UsePrevData.Checked            := m_Condition.m_UsePrevData;

    CheckBoxUseReverse.Checked            := m_Condition.m_Reverse;


    EditCommission.Text                     := TFNGlobal.WriteNumberF(m_Condition.m_Commission, 3);

    CheckBox_FS_PrevDataType.Checked            := m_Condition.m_FS_PrevDataType;

    m_EnableEvent := true;
end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.GetOption;
begin
    if not Assigned(m_Condition) then exit;

    m_Condition.ConditionLock.Enter;

    try

        m_Condition.m_PortfolioGroupName := EditPortfolioGroupName.Text;
        m_Condition.m_PortfolioName := EditPortfolioName.Text;

        m_Condition.m_UsePLC1 := CheckBox_PLC1.Checked;

        m_Condition.m_PLC1_V[0] := TFNGlobal.atof(Edit_PLC1_V1.Text);
        m_Condition.m_PLC1_V[1] := TFNGlobal.atof(Edit_PLC1_V2.Text);
        m_Condition.m_PLC1_V[2] := TFNGlobal.atof(Edit_PLC1_V3.Text);
        m_Condition.m_PLC1_V[3] := TFNGlobal.atof(Edit_PLC1_V4.Text);
        m_Condition.m_PLC1_V[4] := TFNGlobal.atof(Edit_PLC1_V5.Text);
        m_Condition.m_PLC1_V[5] := TFNGlobal.atof(Edit_PLC1_V6.Text);

        m_Condition.m_PLC1_D[0] := TFNGlobal.atof(Edit_PLC1_D1.Text);
        m_Condition.m_PLC1_D[1] := TFNGlobal.atof(Edit_PLC1_D2.Text);
        m_Condition.m_PLC1_D[2] := TFNGlobal.atof(Edit_PLC1_D3.Text);
        m_Condition.m_PLC1_D[3] := TFNGlobal.atof(Edit_PLC1_D4.Text);
        m_Condition.m_PLC1_D[4] := TFNGlobal.atof(Edit_PLC1_D5.Text);
        m_Condition.m_PLC1_D[5] := TFNGlobal.atof(Edit_PLC1_D6.Text);

        m_Condition.m_PLC1_A[0] := CheckBox_PLC1_A1.Checked;
        m_Condition.m_PLC1_A[1] := CheckBox_PLC1_A2.Checked;
        m_Condition.m_PLC1_A[2] := CheckBox_PLC1_A3.Checked;
        m_Condition.m_PLC1_A[3] := CheckBox_PLC1_A4.Checked;
        m_Condition.m_PLC1_A[4] := CheckBox_PLC1_A5.Checked;
        m_Condition.m_PLC1_A[5] := CheckBox_PLC1_A6.Checked;

        m_Condition.m_UsePLC1Type2          := CheckBoxUsePLC1Type2.Checked;
        m_Condition.m_PLC1Type2Value1       := TFNGlobal.atof(EditPLC1Type2Value1.Text);
        m_Condition.m_PLC1Type2Value2       := TFNGlobal.atof(EditPLC1Type2Value2.Text);

        m_Condition.m_UsePLC1Type3          := CheckBoxUsePLC1Type3.Checked;
        m_Condition.m_PLC1Type3             := -abs(TFNGlobal.atof(EditPLC1Type3.Text));

        m_Condition.m_UseReEnter1           := CheckBoxUseReEnter1.Checked;

        m_Condition.m_UseReEnter2           := CheckBoxUseReEnter2.Checked;
        m_Condition.m_ReEnter2Value1        := TFNGlobal.atof(EditReEnter2Value1.Text);
        m_Condition.m_ReEnter2Value2        := TFNGlobal.atof(EditReEnter2Value2.Text);

        m_Condition.m_ReEnter0Value1        := UpDownReEnter0Value1.Position;
        m_Condition.m_ReEnter0Value2        := UpDownReEnter0Value2.Position;

        m_Condition.m_UsePLC2   := CheckBox_PLC2.Checked;

        m_Condition.m_PLC2_V[0] := TFNGlobal.atof(Edit_PLC2_V1.Text);
        m_Condition.m_PLC2_V[1] := TFNGlobal.atof(Edit_PLC2_V2.Text);
        m_Condition.m_PLC2_V[2] := TFNGlobal.atof(Edit_PLC2_V3.Text);
        m_Condition.m_PLC2_V[3] := TFNGlobal.atof(Edit_PLC2_V4.Text);
        m_Condition.m_PLC2_V[4] := TFNGlobal.atof(Edit_PLC2_V5.Text);
        m_Condition.m_PLC2_V[5] := TFNGlobal.atof(Edit_PLC2_V6.Text);

        m_Condition.m_PLC2_D[0] := TFNGlobal.atof(Edit_PLC2_D1.Text);
        m_Condition.m_PLC2_D[1] := TFNGlobal.atof(Edit_PLC2_D2.Text);
        m_Condition.m_PLC2_D[2] := TFNGlobal.atof(Edit_PLC2_D3.Text);
        m_Condition.m_PLC2_D[3] := TFNGlobal.atof(Edit_PLC2_D4.Text);
        m_Condition.m_PLC2_D[4] := TFNGlobal.atof(Edit_PLC2_D5.Text);
        m_Condition.m_PLC2_D[5] := TFNGlobal.atof(Edit_PLC2_D6.Text);

        m_Condition.m_PLC2_A[0] := CheckBox_PLC2_A1.Checked;
        m_Condition.m_PLC2_A[1] := CheckBox_PLC2_A2.Checked;
        m_Condition.m_PLC2_A[2] := CheckBox_PLC2_A3.Checked;
        m_Condition.m_PLC2_A[3] := CheckBox_PLC2_A4.Checked;
        m_Condition.m_PLC2_A[4] := CheckBox_PLC2_A5.Checked;
        m_Condition.m_PLC2_A[5] := CheckBox_PLC2_A6.Checked;

        m_Condition.m_UsePLC2Type2      := CheckBoxUsePLC2Type2.Checked;
        m_Condition.m_PLC2Type2Value1   := TFNGlobal.atof(EditPLC2Type2Value1.Text);
        m_Condition.m_PLC2Type2Value2   := TFNGlobal.atof(EditPLC2Type2Value2.Text);

        m_Condition.m_UsePLC2Type3      := CheckBoxUsePLC2Type3.Checked;
        m_Condition.m_PLC2Type3         := -abs(TFNGlobal.atof(EditPLC2Type3.Text));

        m_Condition.m_UseEnterA         := CheckBoxUseEnterA.Checked;
        m_Condition.m_EnterAValue1      := TFNGlobal.atof(EditEnterAValue1.Text);

        m_Condition.m_UseEnter2             := CheckBoxUseEnter2.Checked;
        m_Condition.m_UseEnter2_1           := CheckBoxUseEnter2_1.Checked;
        m_Condition.m_UseEnter2_2           := CheckBoxUseEnter2_2.Checked;
        m_Condition.m_UseEnter2_3           := CheckBoxUseEnter2_3.Checked;
        m_Condition.m_UseEnter2_4           := CheckBoxUseEnter2_4.Checked;
        m_Condition.m_UseEnter2_5           := CheckBoxUseEnter2_5.Checked;
        m_Condition.m_UseEnter2_6           := CheckBoxUseEnter2_6.Checked;
        m_Condition.m_UseEnter2_7           := CheckBoxUseEnter2_7.Checked;

        m_Condition.m_Enter2Value1          := UpDownEnter2Value1.Position;
        m_Condition.m_Enter2Value2          := UpDownEnter2Value2.Position;
        m_Condition.m_Enter2Value4          := TFNGlobal.atof(EditEnter2Value4.Text);
        m_Condition.m_Enter2Value5          := TFNGlobal.atof(EditEnter2Value5.Text);
        m_Condition.m_Enter2Value6          := TFNGlobal.atof(EditEnter2Value6.Text);
        m_Condition.m_Enter2Value7          := TFNGlobal.atof(EditEnter2Value7.Text);

        m_Condition.m_UseEnterB             := CheckBoxUseEnterB.Checked;
        m_Condition.m_EnterBValue1          := UpDownEnterBValue1.Position;

        m_Condition.m_UseReEnter3           := CheckBoxUseReEnter3.Checked;
        m_Condition.m_ReEnter3Value1        := TFNGlobal.atof(EditReEnter3Value1.Text);
        m_Condition.m_ReEnter3Value2        := TFNGlobal.atof(EditReEnter3Value2.Text);
        m_Condition.m_ReEnter3Value3        := abs(TFNGlobal.atof(EditReEnter3Value3.Text));
        m_Condition.m_ReEnter3Value4        := TFNGlobal.atof(EditReEnter3Value4.Text);

        m_Condition.m_UseReEnter4           := CheckBoxUseReEnter4.Checked;
        m_Condition.m_ReEnter4Value1        := TFNGlobal.atof(EditReEnter4Value1.Text);
        m_Condition.m_ReEnter4Value2        := TFNGlobal.atof(EditReEnter4Value2.Text);

        m_Condition.m_UseReEnter6           := CheckBoxUseReEnter6.Checked;
        m_Condition.m_ReEnter6Value1        := UpDownReEnter6Value1.Position;
        m_Condition.m_ReEnter6Value2        := TFNGlobal.atof(EditReEnter6Value2.Text);

        m_Condition.m_UseEnterTypeC1_0      := CheckBoxUseEnterC1_0.Checked;
        m_Condition.m_EnterTypeC1_0Value1   := UpDownEnterC1_0Value1.Position;
        m_Condition.m_UseEnterTypeC1_1      := CheckBoxUseEnterC1_1.Checked;
        m_Condition.m_EnterTypeC1_1Value1   := UpDownEnterC1_1Value1.Position;
        m_Condition.m_UseEnterTypeC1_2      := CheckBoxUseEnterC1_2.Checked;
        m_Condition.m_EnterTypeC1_2Value1   := UpDownEnterC1_2Value1.Position;
        m_Condition.m_UseEnterTypeC1_3      := CheckBoxUseEnterC1_3.Checked;


        m_Condition.m_UseEnterTypeC1_4      :=  CheckBoxUseEnterC1_4.Checked;
        m_Condition.m_EnterTypeC1_4Value1   :=  TFNGlobal.atof(EditEnterC1_4Value1.Text);

        m_Condition.m_UseEnterTypeC1_5      :=  CheckBoxUseEnterC1_5.Checked;
        m_Condition.m_EnterTypeC1_5Value1   :=  TFNGlobal.atof(EditEnterC1_5Value1.Text);

        m_Condition.m_UseEnterTypeC1_5      :=  CheckBoxUseEnterC1_6.Checked;
        m_Condition.m_EnterTypeC1_5Value1   :=  TFNGlobal.atof(EditEnterC1_6Value1.Text);

        m_Condition.m_UseReEnter5           := CheckBoxUseReEnter5.Checked;
        m_Condition.m_UseReEnter5_1         := CheckBoxUseReEnter5_1.Checked;
        m_Condition.m_ReEnter5_1Value1      := UpDownReEnter5_1Value1.Position;
        m_Condition.m_UseReEnter5_2         := CheckBoxUseReEnter5_2.Checked;
        m_Condition.m_ReEnter5_2Value1      := UpDownReEnter5_2Value1.Position;
        m_Condition.m_UseReEnter5_3         := CheckBoxUseReEnter5_3.Checked;

        m_Condition.m_UseReEnterA           := CheckBoxUseReEnterA.Checked;
        m_Condition.m_ReEnterAValue1        := TFNGlobal.atof(EditReEnterAValue1.Text);

        m_Condition.m_UseReEnterB           := CheckBoxUseReEnterB.Checked;
        m_Condition.m_ReEnterBValue1        := TFNGlobal.atof(EditReEnterBValue1.Text);
        m_Condition.m_ReEnterBValue2        := TFNGlobal.atof(EditReEnterBValue2.Text);

        m_Condition.m_UseReEnterC           := CheckBoxUseReEnterC.Checked;
        m_Condition.m_ReEnterCValue1        := TFNGlobal.atof(EditReEnterCValue1.Text);
        m_Condition.m_ReEnterCValue2        := TFNGlobal.atof(EditReEnterCValue2.Text);

        m_Condition.m_UseReEnterD           := CheckBoxUseReEnterD.Checked;
        m_Condition.m_ReEnterDValue1        := UpDownReEnterDValue1.Position;
        m_Condition.m_ReEnterDValue2        := TFNGlobal.atof(EditReEnterDValue2.Text);
        m_Condition.m_ReEnterDValue3        := TFNGlobal.atof(EditReEnterDValue3.Text);


        m_Condition.m_UseLossTradeStop      := CheckBoxUseLossTradeStop.Checked;
        m_Condition.m_LossTradeStopValue1   := -abs(TFNGlobal.atof(EditLossTradeStopValue1.Text));

        m_Condition.m_UseProfitTradeStop    :=  CheckBoxUseProfitTradeStop.Checked;
        m_Condition.m_ProfitTradeStopValue1 :=  abs(TFNGlobal.atof(EditProfitTradeStopValue1.Text));

        m_Condition.m_UseMA1ConsecutiveUp   :=  CheckBoxUseMA1ConsecutiveUp.Checked;
        m_Condition.m_MA1ConsecutiveUpCount :=  UpDownMA1ConsecutiveUpCount.Position;

        m_Condition.m_UseMA2ConsecutiveUp   :=  CheckBoxUseMA2ConsecutiveUp.Checked;
        m_Condition.m_MA2ConsecutiveUpCount :=  UpDownMA2ConsecutiveUpCount.Position;

        m_Condition.m_UseMA1AboveMA2        :=  CheckBoxUseMA1AboveMA2.Checked;

        m_Condition.m_UseReEnterTypeC3_4    :=  CheckBoxUseReEnterC3_4.Checked;
        m_Condition.m_ReEnterTypeC3_4Value1 :=  TFNGlobal.atof(EditReEnterC3_4Value1.Text);

        m_Condition.m_UseReEnterTypeC3_5    :=  CheckBoxUseReEnterC3_5.Checked;
        m_Condition.m_ReEnterTypeC3_5Value1 :=  TFNGlobal.atof(EditReEnterC3_5Value1.Text);

        m_Condition.m_UseReEnterTypeC3_6    :=  CheckBoxUseReEnterC3_6.Checked;
        m_Condition.m_ReEnterTypeC3_6Value1 :=  TFNGlobal.atof(EditReEnterC3_6Value1.Text);


        m_Condition.m_MAType                :=  ComboBoxMAType.ItemIndex;
        m_Condition.m_MA0Number             :=  UpDownMA0Number.Position;
        m_Condition.m_MA1Number             :=  UpDownMA1Number.Position;
        m_Condition.m_MA2Number             :=  UpDownMA2Number.Position;

        m_Condition.m_UsePLC1Type4          :=  CheckBoxUsePLC1Type4.Checked  ;
        m_Condition.m_UsePLC1Type4_1        :=  CheckBoxUsePLC1Type4_1.Checked;
        m_Condition.m_PLC1Type4_1Value1     :=  UpDownPLC1Type4Value1.Position;
        m_Condition.m_UsePLC1Type4_2        :=  CheckBoxUsePLC1Type4_2.Checked;
        m_Condition.m_PLC1Type4_2Value1     :=  UpDownPLC1Type4Value2.Position;
        m_Condition.m_UsePLC1Type4_3        :=  CheckBoxUsePLC1Type4_3.Checked;

        m_Condition.m_PLC1Type4Value3       :=  TFNGlobal.atof(EditPLC1Type4Value3.Text);
        m_Condition.m_PLC1Type4Value4       :=  UpDownPLC1Type4Value4.Position;
        m_Condition.m_PLC1Type4Value5       :=  TFNGlobal.atof(EditPLC1Type4Value5.Text);

        m_Condition.m_UsePLC2Type4          :=  CheckBoxUsePLC2Type4.Checked  ;
        m_Condition.m_UsePLC2Type4_1        :=  CheckBoxUsePLC2Type4_1.Checked;
        m_Condition.m_PLC2Type4_1Value1     :=  UpDownPLC2Type4Value1.Position;
        m_Condition.m_UsePLC2Type4_2        :=  CheckBoxUsePLC2Type4_2.Checked;
        m_Condition.m_PLC2Type4_2Value1     :=  UpDownPLC2Type4Value2.Position;
        m_Condition.m_UsePLC2Type4_3        :=  CheckBoxUsePLC2Type4_3.Checked;

        m_Condition.m_PLC2Type4Value3       :=  TFNGlobal.atof(EditPLC2Type4Value3.Text);
        m_Condition.m_PLC2Type4Value4       :=  UpDownPLC2Type4Value4.Position;
        m_Condition.m_PLC2Type4Value5       :=  TFNGlobal.atof(EditPLC2Type4Value5.Text);


        m_Condition.m_UsePLC2Type5          :=  CheckBoxUsePLC2Type5.Checked  ;
        m_Condition.m_UsePLC2Type5_1        :=  CheckBoxUsePLC2Type5_1.Checked;
        m_Condition.m_PLC2Type5_1Value1     :=  UpDownPLC2Type5Value1.Position;
        m_Condition.m_UsePLC2Type5_2        :=  CheckBoxUsePLC2Type5_2.Checked;
        m_Condition.m_PLC2Type5_2Value1     :=  UpDownPLC2Type5Value2.Position;
        m_Condition.m_UsePLC2Type5_3        :=  CheckBoxUsePLC2Type5_3.Checked;

        m_Condition.m_PLC2Type5Value3       :=  TFNGlobal.atof(EditPLC2Type5Value3.Text);
        m_Condition.m_PLC2Type5Value4       :=  UpDownPLC2Type5Value4.Position;
        m_Condition.m_PLC2Type5Value5       :=  TFNGlobal.atof(EditPLC2Type5Value5.Text);


        m_Condition.m_UsePLC1TypeC_1        :=  CheckBoxUsePLC1TypeC_1.Checked;
        m_Condition.m_PLC1TypeC_1Value1     :=  UpDownPLC1TypeCValue1.Position;
        m_Condition.m_UsePLC1TypeC_2        :=  CheckBoxUsePLC1TypeC_2.Checked;
        m_Condition.m_PLC1TypeC_2Value1     :=  UpDownPLC1TypeCValue2.Position;
        m_Condition.m_UsePLC1TypeC_3        :=  CheckBoxUsePLC1TypeC_3.Checked;

        m_Condition.m_UsePLC2TypeC_1        :=  CheckBoxUsePLC2TypeC_1.Checked;
        m_Condition.m_PLC2TypeC_1Value1     :=  UpDownPLC2TypeCValue1.Position;
        m_Condition.m_UsePLC2TypeC_2        :=  CheckBoxUsePLC2TypeC_2.Checked;
        m_Condition.m_PLC2TypeC_2Value1     :=  UpDownPLC2TypeCValue2.Position;
        m_Condition.m_UsePLC2TypeC_3        :=  CheckBoxUsePLC2TypeC_3.Checked;

        if (ComboBoxASS_DATECOUNT4.ItemIndex = 0) then m_Condition.m_ASS_DATECOUNT4 := 15
        else if (ComboBoxASS_DATECOUNT4.ItemIndex = 1) then m_Condition.m_ASS_DATECOUNT4 := 30
        else if (ComboBoxASS_DATECOUNT4.ItemIndex = 2) then m_Condition.m_ASS_DATECOUNT4 := 60
        else if (ComboBoxASS_DATECOUNT4.ItemIndex = 3) then m_Condition.m_ASS_DATECOUNT4 := 120
        else if (ComboBoxASS_DATECOUNT4.ItemIndex = 4) then m_Condition.m_ASS_DATECOUNT4 := 180;

        m_Condition.m_ASS_PERCENT_PROFITABLE    := TFNGlobal.atof(EditASS_PERCENT_PROFITABLE.Text);
        m_Condition.m_ASS_PROFIT_FACTOR         := TFNGlobal.atof(EditASS_PROFIT_FACTOR.Text);
        m_Condition.m_ASS_MAXDRAWDOWN           := TFNGlobal.atof(EditASS_MAXDRAWDOWN.Text);
        m_Condition.m_ASS_TYPE                  := ComboBoxASS_TYPE.ItemIndex;

        m_Condition.m_FS_PrevData               :=  CheckBox_FS_PrevData.Checked;
        m_Condition.m_UsePrevData               :=  CheckBox_UsePrevData.Checked;

        m_Condition.m_Reverse                   :=  CheckBoxUseReverse.Checked;

        m_Condition.m_FS_PrevDataType           :=  CheckBox_FS_PrevDataType.Checked;

        m_Condition.m_Commission                :=  TFNGlobal.atof(EditCommission.Text);

    finally
        m_Condition.ConditionLock.Leave;
    end;
end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.UpdateControl;
var
    f_POTItem:CFNPOTItem;
    f_OpenDateTime : TDateTime;
    f_CloseDateTime : TDateTime;

    f_EnableControl : Boolean;
begin
    if not Assigned(m_Condition) then exit;

        m_EnableEvent := false;
        f_EnableControl := m_EnableControl;


        if m_Condition.m_UseEnterA then
        begin
            EditEnterAValue1.Enabled := f_EnableControl;
            Label42.Enabled := f_EnableControl;
            Label46.Enabled := f_EnableControl;
        end else
        begin
            EditEnterAValue1.Enabled := false;
            Label42.Enabled := false;
            Label46.Enabled := false;
        end;

        if m_Condition.m_UseEnter2 then
        begin
            CheckBoxUseEnter2_1.Enabled := f_EnableControl;
            CheckBoxUseEnter2_2.Enabled := f_EnableControl;
            CheckBoxUseEnter2_3.Enabled := f_EnableControl;
            CheckBoxUseEnter2_4.Enabled := f_EnableControl;
            CheckBoxUseEnter2_5.Enabled := f_EnableControl;
            CheckBoxUseEnter2_6.Enabled := f_EnableControl;
            CheckBoxUseEnter2_7.Enabled := f_EnableControl;

            UpDownEnter2Value1.Enabled := f_EnableControl;
            UpDownEnter2Value2.Enabled := f_EnableControl;

            EditEnter2Value1.Enabled := f_EnableControl;
            EditEnter2Value2.Enabled := f_EnableControl;
            EditEnter2Value4.Enabled := f_EnableControl;
            EditEnter2Value5.Enabled := f_EnableControl;
            EditEnter2Value6.Enabled := f_EnableControl;
            EditEnter2Value7.Enabled := f_EnableControl;
        end else
        begin
            CheckBoxUseEnter2_1.Enabled := false;
            CheckBoxUseEnter2_2.Enabled := false;
            CheckBoxUseEnter2_3.Enabled := false;
            CheckBoxUseEnter2_4.Enabled := false;
            CheckBoxUseEnter2_5.Enabled := false;
            CheckBoxUseEnter2_6.Enabled := false;
            CheckBoxUseEnter2_7.Enabled := false;

            UpDownEnter2Value1.Enabled := false;
            UpDownEnter2Value2.Enabled := false;

            EditEnter2Value1.Enabled := false;
            EditEnter2Value2.Enabled := false;
            EditEnter2Value4.Enabled := false;
            EditEnter2Value5.Enabled := false;
            EditEnter2Value6.Enabled := false;
            EditEnter2Value7.Enabled := false;
        end;

        if m_Condition.m_UseEnterB then
        begin
            EditEnterBValue1.Enabled := f_EnableControl;
            UpDownEnterBValue1.Enabled := f_EnableControl;

            Label47.Enabled := f_EnableControl;
            Label49.Enabled := f_EnableControl;
            Label89.Enabled := f_EnableControl;
        end else
        begin
            EditEnterBValue1.Enabled := false;
            UpDownEnterBValue1.Enabled := false;

            Label47.Enabled := false;
            Label49.Enabled := false;
            Label89.Enabled := false;
        end;

        f_OpenDateTime  := g_DefaultOpenTime;
        f_CloseDateTime := g_DefaultCloseTime;
        if Assigned(g_POTCollection) then
        begin
            f_POTItem := g_POTCollection.Find(
                TFNGlobal.ServerNow,
                g_DefaultCountry, g_DefaultGroup, g_DefaultMarket, g_DefaultSymbol);
            if Assigned(f_POTItem) then
            begin
                f_OpenDateTime := EncodeTime(
                    f_POTItem.NumberToHour  (f_POTItem.m_Open[0]),
                    f_POTItem.NumberToMin   (f_POTItem.m_Open[0]),
                    0,
                    0
                );
                f_CloseDateTime := EncodeTime(
                    f_POTItem.NumberToHour  (f_POTItem.m_Close[f_POTItem.m_HourCount-1]),
                    f_POTItem.NumberToMin   (f_POTItem.m_Close[f_POTItem.m_HourCount-1]),
                    0,
                    0
                );
            end;
        end;
        m_Condition.m_EnterBValue2 := f_OpenDateTime + m_Condition.m_EnterBValue1 / 1440.0;
        DateTimePickerEnterBValue1.Time := m_Condition.m_EnterBValue2;

        if not f_EnableControl then
        begin
            f_EnableControl := m_EditInRuntime;
        end;


    try
        if m_Condition.m_UsePLC1 then
        begin
            Edit_PLC1_V1.Enabled := f_EnableControl;
            Edit_PLC1_V2.Enabled := f_EnableControl;
            Edit_PLC1_V3.Enabled := f_EnableControl;
            Edit_PLC1_V4.Enabled := f_EnableControl;
            Edit_PLC1_V5.Enabled := f_EnableControl;
            Edit_PLC1_V6.Enabled := f_EnableControl;

            Edit_PLC1_D1.Enabled := f_EnableControl;
            Edit_PLC1_D2.Enabled := f_EnableControl;
            Edit_PLC1_D3.Enabled := f_EnableControl;
            Edit_PLC1_D4.Enabled := f_EnableControl;
            Edit_PLC1_D5.Enabled := f_EnableControl;
            Edit_PLC1_D6.Enabled := f_EnableControl;

            CheckBox_PLC1_A1.Enabled := f_EnableControl;
            CheckBox_PLC1_A2.Enabled := f_EnableControl;
            CheckBox_PLC1_A3.Enabled := f_EnableControl;
            CheckBox_PLC1_A4.Enabled := f_EnableControl;
            CheckBox_PLC1_A5.Enabled := f_EnableControl;
            CheckBox_PLC1_A6.Enabled := f_EnableControl;

            Label1.Enabled := f_EnableControl;
            Label2.Enabled := f_EnableControl;
            Label3.Enabled := f_EnableControl;
            Label5.Enabled := f_EnableControl;
            Label39.Enabled := f_EnableControl;
            Label40.Enabled := f_EnableControl;

            if (Not m_Condition.m_PLC1_A[0]) then
            begin
                Edit_PLC1_D1.Enabled := false;
            end;

            if (Not m_Condition.m_PLC1_A[1]) then
            begin
                Edit_PLC1_D2.Enabled := false;
            end;

            if (Not m_Condition.m_PLC1_A[2]) then
            begin
                Edit_PLC1_D3.Enabled := false;
            end;

            if (Not m_Condition.m_PLC1_A[3]) then
            begin
                Edit_PLC1_D4.Enabled := false;
            end;

            if (Not m_Condition.m_PLC1_A[4]) then
            begin
                Edit_PLC1_D5.Enabled := false;
            end;

            if (Not m_Condition.m_PLC1_A[5]) then
            begin
                Edit_PLC1_D6.Enabled := false;
            end;

        end else
        begin
            Edit_PLC1_V1.Enabled := false;
            Edit_PLC1_V2.Enabled := false;
            Edit_PLC1_V3.Enabled := false;
            Edit_PLC1_V4.Enabled := false;
            Edit_PLC1_V5.Enabled := false;
            Edit_PLC1_V6.Enabled := false;

            Edit_PLC1_D1.Enabled := false;
            Edit_PLC1_D2.Enabled := false;
            Edit_PLC1_D3.Enabled := false;
            Edit_PLC1_D4.Enabled := false;
            Edit_PLC1_D5.Enabled := false;
            Edit_PLC1_D6.Enabled := false;

            CheckBox_PLC1_A1.Enabled := false;
            CheckBox_PLC1_A2.Enabled := false;
            CheckBox_PLC1_A3.Enabled := false;
            CheckBox_PLC1_A4.Enabled := false;
            CheckBox_PLC1_A5.Enabled := false;
            CheckBox_PLC1_A6.Enabled := false;

            Label1.Enabled := false;
            Label2.Enabled := false;
            Label3.Enabled := false;
            Label5.Enabled := false;
            Label39.Enabled := false;
            Label40.Enabled := false;

        end;

        if m_Condition.m_UsePLC1Type2 then
        begin
            EditPLC1Type2Value1.Enabled := f_EnableControl;
            EditPLC1Type2Value2.Enabled := f_EnableControl;
            Label35.Enabled := f_EnableControl;
            Label32.Enabled := f_EnableControl;
            Label60.Enabled := f_EnableControl;
            Label38.Enabled := f_EnableControl;
        end else
        begin
            EditPLC1Type2Value1.Enabled := false;
            EditPLC1Type2Value2.Enabled := false;
            Label35.Enabled := false;
            Label32.Enabled := false;
            Label60.Enabled := false;
            Label38.Enabled := false;
        end;

        if m_Condition.m_UsePLC1Type3 then
        begin
            EditPLC1Type3.Enabled := f_EnableControl;
            Label21.Enabled := f_EnableControl;
            Label20.Enabled := f_EnableControl;
        end else
        begin
            EditPLC1Type3.Enabled := false;
            Label21.Enabled := false;
            Label20.Enabled := false;
        end;

        if m_Condition.m_UseReEnter1 then
        begin
            Label13.Enabled := f_EnableControl;
        end else
        begin
            Label13.Enabled := false;
        end;

        if m_Condition.m_UseReEnter2 then
        begin
            EditReEnter2Value1.Enabled := f_EnableControl;
            EditReEnter2Value2.Enabled := f_EnableControl;
            Label45.Enabled := f_EnableControl;
            Label16.Enabled := f_EnableControl;
            Label41.Enabled := f_EnableControl;
        end else
        begin
            EditReEnter2Value1.Enabled := false;
            EditReEnter2Value2.Enabled := false;
            Label45.Enabled := false;
            Label16.Enabled := false;
            Label41.Enabled := false;
        end;

        if m_Condition.m_UsePLC2 then
        begin
            Edit_PLC2_V1.Enabled := f_EnableControl;
            Edit_PLC2_V2.Enabled := f_EnableControl;
            Edit_PLC2_V3.Enabled := f_EnableControl;
            Edit_PLC2_V4.Enabled := f_EnableControl;
            Edit_PLC2_V5.Enabled := f_EnableControl;
            Edit_PLC2_V6.Enabled := f_EnableControl;

            Edit_PLC2_D1.Enabled := f_EnableControl;
            Edit_PLC2_D2.Enabled := f_EnableControl;
            Edit_PLC2_D3.Enabled := f_EnableControl;
            Edit_PLC2_D4.Enabled := f_EnableControl;
            Edit_PLC2_D5.Enabled := f_EnableControl;
            Edit_PLC2_D6.Enabled := f_EnableControl;

            CheckBox_PLC2_A1.Enabled := f_EnableControl;
            CheckBox_PLC2_A2.Enabled := f_EnableControl;
            CheckBox_PLC2_A3.Enabled := f_EnableControl;
            CheckBox_PLC2_A4.Enabled := f_EnableControl;
            CheckBox_PLC2_A5.Enabled := f_EnableControl;
            CheckBox_PLC2_A6.Enabled := f_EnableControl;

            Label17.Enabled := f_EnableControl;
            Label9.Enabled := f_EnableControl;
            Label10.Enabled := f_EnableControl;
            Label15.Enabled := f_EnableControl;
            Label34.Enabled := f_EnableControl;
            Label37.Enabled := f_EnableControl;

            if (Not m_Condition.m_PLC2_A[0]) then
            begin
                Edit_PLC2_D1.Enabled := false;
            end;

            if (Not m_Condition.m_PLC2_A[1]) then
            begin
                Edit_PLC2_D2.Enabled := false;
            end;

            if (Not m_Condition.m_PLC2_A[2]) then
            begin
                Edit_PLC2_D3.Enabled := false;
            end;

            if (Not m_Condition.m_PLC2_A[3]) then
            begin
                Edit_PLC2_D4.Enabled := false;
            end;

            if (Not m_Condition.m_PLC2_A[4]) then
            begin
                Edit_PLC2_D5.Enabled := false;
            end;

            if (Not m_Condition.m_PLC2_A[5]) then
            begin
                Edit_PLC2_D6.Enabled := false;
            end;

        end else
        begin
            Edit_PLC2_V1.Enabled := false;
            Edit_PLC2_V2.Enabled := false;
            Edit_PLC2_V3.Enabled := false;
            Edit_PLC2_V4.Enabled := false;
            Edit_PLC2_V5.Enabled := false;
            Edit_PLC2_V6.Enabled := false;

            Edit_PLC2_D1.Enabled := false;
            Edit_PLC2_D2.Enabled := false;
            Edit_PLC2_D3.Enabled := false;
            Edit_PLC2_D4.Enabled := false;
            Edit_PLC2_D5.Enabled := false;
            Edit_PLC2_D6.Enabled := false;

            CheckBox_PLC2_A1.Enabled := false;
            CheckBox_PLC2_A2.Enabled := false;
            CheckBox_PLC2_A3.Enabled := false;
            CheckBox_PLC2_A4.Enabled := false;
            CheckBox_PLC2_A5.Enabled := false;
            CheckBox_PLC2_A6.Enabled := false;

            Label17.Enabled := false;
            Label9.Enabled := false;
            Label10.Enabled := false;
            Label15.Enabled := false;
            Label34.Enabled := false;
            Label37.Enabled := false;
        end;

        if m_Condition.m_UsePLC2Type2 then
        begin
            EditPLC2Type2Value1.Enabled := f_EnableControl;
            EditPLC2Type2Value2.Enabled := f_EnableControl;
            Label22.Enabled := f_EnableControl;
            Label24.Enabled := f_EnableControl;
            Label25.Enabled := f_EnableControl;
            Label26.Enabled := f_EnableControl;
        end else
        begin
            EditPLC2Type2Value1.Enabled := false;
            EditPLC2Type2Value2.Enabled := false;
            Label22.Enabled := false;
            Label24.Enabled := false;
            Label25.Enabled := false;
            Label26.Enabled := false;
        end;

        if m_Condition.m_UsePLC2Type3 then
        begin
            EditPLC2Type3.Enabled := f_EnableControl;
            Label28.Enabled := f_EnableControl;
            Label6.Enabled := f_EnableControl;
        end else
        begin
            EditPLC2Type3.Enabled := false;
            Label28.Enabled := false;
            Label6.Enabled := false;
        end;


        if m_Condition.m_UseReEnter3 then
        begin
            EditReEnter3Value1.Enabled := f_EnableControl;
            EditReEnter3Value2.Enabled := f_EnableControl;
            EditReEnter3Value3.Enabled := f_EnableControl;
            EditReEnter3Value4.Enabled := f_EnableControl;
            Label54.Enabled := f_EnableControl;
            Label55.Enabled := f_EnableControl;
            Label4.Enabled := f_EnableControl;

            Label58.Enabled := f_EnableControl;
            Label61.Enabled := f_EnableControl;
            Label59.Enabled := f_EnableControl;
            Label70.Enabled := f_EnableControl;
            Label71.Enabled := f_EnableControl;
        end else
        begin
            EditReEnter3Value1.Enabled := false;
            EditReEnter3Value2.Enabled := false;
            EditReEnter3Value3.Enabled := false;
            EditReEnter3Value4.Enabled := false;
            Label54.Enabled := false;
            Label55.Enabled := false;
            Label4.Enabled := false;

            Label58.Enabled := false;
            Label61.Enabled := false;
            Label59.Enabled := false;
            Label70.Enabled := false;
            Label71.Enabled := false;
        end;

        if m_Condition.m_UseReEnter4 then
        begin
            EditReEnter4Value1.Enabled := f_EnableControl;
            EditReEnter4Value2.Enabled := f_EnableControl;
            Label44.Enabled := f_EnableControl;
            Label53.Enabled := f_EnableControl;
            Label74.Enabled := f_EnableControl;
        end else
        begin
            EditReEnter4Value1.Enabled := false;
            EditReEnter4Value2.Enabled := false;
            Label44.Enabled := false;
            Label53.Enabled := false;
            Label74.Enabled := false;
        end;

        if m_Condition.m_UseReEnter6 then
        begin
            EditReEnter6Value1.Enabled := f_EnableControl;
            EditReEnter6Value2.Enabled := f_EnableControl;
            UpDownReEnter6Value1.Enabled := f_EnableControl;
            Label99.Enabled := f_EnableControl;
            Label102.Enabled := f_EnableControl;
            Label100.Enabled := f_EnableControl;
        end else
        begin
            EditReEnter6Value1.Enabled := false;
            EditReEnter6Value2.Enabled := false;
            UpDownReEnter6Value1.Enabled := false;
            Label99.Enabled := false;
            Label102.Enabled := false;
            Label100.Enabled := false;
        end;


        if m_Condition.m_UseReEnterA then
        begin
            EditReEnterAValue1.Enabled := f_EnableControl;
            Label50.Enabled := f_EnableControl;
            Label52.Enabled := f_EnableControl;
        end else
        begin
            EditReEnterAValue1.Enabled := false;
            Label50.Enabled := false;
            Label52.Enabled := false;
        end;

        if m_Condition.m_UseReEnterB then
        begin
            EditReEnterBValue1.Enabled := f_EnableControl;
            EditReEnterBValue2.Enabled := f_EnableControl;
            Label101.Enabled := f_EnableControl;
            Label105.Enabled := f_EnableControl;
        end else
        begin
            EditReEnterBValue1.Enabled := false;
            EditReEnterBValue2.Enabled := false;
            Label101.Enabled := false;
            Label105.Enabled := false;
        end;

        if m_Condition.m_UseReEnterC then
        begin
            EditReEnterCValue1.Enabled := f_EnableControl;
            EditReEnterCValue2.Enabled := f_EnableControl;
            Label92.Enabled := f_EnableControl;
            Label111.Enabled := f_EnableControl;
        end else
        begin
            EditReEnterCValue1.Enabled := false;
            EditReEnterCValue2.Enabled := false;
            Label92.Enabled := false;
            Label111.Enabled := false;
        end;

        if m_Condition.m_UseReEnterD then
        begin
            UpDownReEnterDValue1.Enabled := f_EnableControl;
            EditReEnterDValue1.Enabled := f_EnableControl;
            EditReEnterDValue2.Enabled := f_EnableControl;
            EditReEnterDValue3.Enabled := f_EnableControl;
            Label108.Enabled := f_EnableControl;
            Label110.Enabled := f_EnableControl;
            Label113.Enabled := f_EnableControl;
        end else
        begin
            UpDownReEnterDValue1.Enabled := false;
            EditReEnterDValue1.Enabled := false;
            EditReEnterDValue2.Enabled := false;
            EditReEnterDValue3.Enabled := false;
            Label108.Enabled := false;
            Label110.Enabled := false;
            Label113.Enabled := false;
        end;

        if m_Condition.m_UseLossTradeStop then
        begin
            EditLossTradeStopValue1.Enabled := f_EnableControl;
            Label62.Enabled := f_EnableControl;
            Label64.Enabled := f_EnableControl;
        end else
        begin
            EditLossTradeStopValue1.Enabled := false;
            Label62.Enabled := false;
            Label64.Enabled := false;
        end;

        if m_Condition.m_UseProfitTradeStop then
        begin
            EditProfitTradeStopValue1.Enabled := f_EnableControl;
            Label65.Enabled := f_EnableControl;
            Label67.Enabled := f_EnableControl;
        end else
        begin
            EditProfitTradeStopValue1.Enabled := false;
            Label65.Enabled := false;
            Label67.Enabled := false;
        end;

        if m_Condition.m_UseMA1ConsecutiveUp then
        begin
            EditMA1ConsecutiveUpCount.Enabled := f_EnableControl;
            UpDownMA1ConsecutiveUpCount.Enabled := f_EnableControl;
        end else
        begin
            EditMA1ConsecutiveUpCount.Enabled := false;
            UpDownMA1ConsecutiveUpCount.Enabled := false;
        end;

        if m_Condition.m_UseMA2ConsecutiveUp then
        begin
            EditMA2ConsecutiveUpCount.Enabled := f_EnableControl;
            UpDownMA2ConsecutiveUpCount.Enabled := f_EnableControl;
        end else
        begin
            EditMA2ConsecutiveUpCount.Enabled := false;
            UpDownMA2ConsecutiveUpCount.Enabled := false;
        end;


        if m_Condition.m_UsePLC1Type4 then
        begin
            CheckBoxUsePLC1Type4_1.Enabled := f_EnableControl;
            EditPLC1Type4Value1.Enabled := f_EnableControl;
            UpDownPLC1Type4Value1.Enabled := f_EnableControl;
            CheckBoxUsePLC1Type4_2.Enabled := f_EnableControl;
            EditPLC1Type4Value2.Enabled := f_EnableControl;
            UpDownPLC1Type4Value2.Enabled := f_EnableControl;
            CheckBoxUsePLC1Type4_3.Enabled := f_EnableControl;
            EditPLC1Type4Value3.Enabled := f_EnableControl;
            EditPLC1Type4Value4.Enabled := f_EnableControl;
            UpDownPLC1Type4Value4.Enabled := f_EnableControl;
            EditPLC1Type4Value5.Enabled := f_EnableControl;
            Label86.Enabled := f_EnableControl;
            Label88.Enabled := f_EnableControl;
            Label96.Enabled := f_EnableControl;
        end else
        begin
            CheckBoxUsePLC1Type4_1.Enabled := false;
            EditPLC1Type4Value1.Enabled := false;
            UpDownPLC1Type4Value1.Enabled := false;
            CheckBoxUsePLC1Type4_2.Enabled := false;
            EditPLC1Type4Value2.Enabled := false;
            UpDownPLC1Type4Value2.Enabled := false;
            CheckBoxUsePLC1Type4_3.Enabled := false;
            EditPLC1Type4Value3.Enabled := false;
            EditPLC1Type4Value4.Enabled := false;
            UpDownPLC1Type4Value4.Enabled := false;
            EditPLC1Type4Value5.Enabled := false;
            Label86.Enabled := false;
            Label88.Enabled := false;
            Label96.Enabled := false;
        end;


        if m_Condition.m_UsePLC2Type4 then
        begin
            CheckBoxUsePLC2Type4_1.Enabled := f_EnableControl;
            EditPLC2Type4Value1.Enabled := f_EnableControl;
            UpDownPLC2Type4Value1.Enabled := f_EnableControl;
            CheckBoxUsePLC2Type4_2.Enabled := f_EnableControl;
            EditPLC2Type4Value2.Enabled := f_EnableControl;
            UpDownPLC2Type4Value2.Enabled := f_EnableControl;
            CheckBoxUsePLC2Type4_3.Enabled := f_EnableControl;
            EditPLC2Type4Value3.Enabled := f_EnableControl;
            EditPLC2Type4Value4.Enabled := f_EnableControl;
            EditPLC2Type4Value5.Enabled := f_EnableControl;
            UpDownPLC2Type4Value4.Enabled := f_EnableControl;
            Label91.Enabled := f_EnableControl;
            Label93.Enabled := f_EnableControl;
            Label12.Enabled := f_EnableControl;
        end else
        begin
            CheckBoxUsePLC2Type4_1.Enabled := false;
            EditPLC2Type4Value1.Enabled := false;
            UpDownPLC2Type4Value1.Enabled := false;
            CheckBoxUsePLC2Type4_2.Enabled := false;
            EditPLC2Type4Value2.Enabled := false;
            UpDownPLC2Type4Value2.Enabled := false;
            CheckBoxUsePLC2Type4_3.Enabled := false;
            EditPLC2Type4Value3.Enabled := false;
            EditPLC2Type4Value4.Enabled := false;
            UpDownPLC2Type4Value4.Enabled := false;
            EditPLC2Type4Value5.Enabled := false;
            Label91.Enabled := false;
            Label93.Enabled := false;
            Label12.Enabled := false;
        end;


        if m_Condition.m_UsePLC2Type5 then
        begin
            CheckBoxUsePLC2Type5_1.Enabled := f_EnableControl;
            EditPLC2Type5Value1.Enabled := f_EnableControl;
            UpDownPLC2Type5Value1.Enabled := f_EnableControl;
            CheckBoxUsePLC2Type5_2.Enabled := f_EnableControl;
            EditPLC2Type5Value2.Enabled := f_EnableControl;
            UpDownPLC2Type5Value2.Enabled := f_EnableControl;
            CheckBoxUsePLC2Type5_3.Enabled := f_EnableControl;
            EditPLC2Type5Value3.Enabled := f_EnableControl;
            EditPLC2Type5Value4.Enabled := f_EnableControl;
            EditPLC2Type5Value5.Enabled := f_EnableControl;
            UpDownPLC2Type5Value4.Enabled := f_EnableControl;
            Label14.Enabled := f_EnableControl;
            Label87.Enabled := f_EnableControl;
            Label90.Enabled := f_EnableControl;
        end else
        begin
            CheckBoxUsePLC2Type5_1.Enabled := false;
            EditPLC2Type5Value1.Enabled := false;
            UpDownPLC2Type5Value1.Enabled := false;
            CheckBoxUsePLC2Type5_2.Enabled := false;
            EditPLC2Type5Value2.Enabled := false;
            UpDownPLC2Type5Value2.Enabled := false;
            CheckBoxUsePLC2Type5_3.Enabled := false;
            EditPLC2Type5Value3.Enabled := false;
            EditPLC2Type5Value4.Enabled := false;
            UpDownPLC2Type5Value4.Enabled := false;
            EditPLC2Type5Value5.Enabled := false;
            Label14.Enabled := false;
            Label87.Enabled := false;
            Label90.Enabled := false;
        end;

        if m_Condition.m_UsePLC1TypeC_1 then
        begin
            EditPLC1TypeCValue1.Enabled := f_EnableControl;
            UpDownPLC1TypeCValue1.Enabled := f_EnableControl;
        end else
        begin
            EditPLC1TypeCValue1.Enabled := false;
            UpDownPLC1TypeCValue1.Enabled := false;
        end;

        if m_Condition.m_UsePLC1TypeC_2 then
        begin
            EditPLC1TypeCValue2.Enabled := f_EnableControl;
            UpDownPLC1TypeCValue2.Enabled := f_EnableControl;
        end else
        begin
            EditPLC1TypeCValue2.Enabled := false;
            UpDownPLC1TypeCValue2.Enabled := false;
        end;

        if m_Condition.m_UsePLC2TypeC_1 then
        begin
            EditPLC2TypeCValue1.Enabled := f_EnableControl;
            UpDownPLC2TypeCValue1.Enabled := f_EnableControl;
        end else
        begin
            EditPLC2TypeCValue1.Enabled := false;
            UpDownPLC2TypeCValue1.Enabled := false;
        end;

        if m_Condition.m_UsePLC2TypeC_2 then
        begin
            EditPLC2TypeCValue2.Enabled := f_EnableControl;
            UpDownPLC2TypeCValue2.Enabled := f_EnableControl;
        end else
        begin
            EditPLC2TypeCValue2.Enabled := false;
            UpDownPLC2TypeCValue2.Enabled := false;
        end;


        if m_Condition.m_UseReEnter5 then
        begin
            CheckBoxUseReEnter5_1.Enabled := f_EnableControl;
            EditReEnter5_1Value1.Enabled := f_EnableControl;
            UpDownReEnter5_1Value1.Enabled := f_EnableControl;
            CheckBoxUseReEnter5_2.Enabled := f_EnableControl;
            EditReEnter5_2Value1.Enabled := f_EnableControl;
            UpDownReEnter5_2Value1.Enabled := f_EnableControl;
            CheckBoxUseReEnter5_3.Enabled := f_EnableControl;
        end else
        begin
            CheckBoxUseReEnter5_1.Enabled := false;
            EditReEnter5_1Value1.Enabled := false;
            UpDownReEnter5_1Value1.Enabled := false;
            CheckBoxUseReEnter5_2.Enabled := false;
            EditReEnter5_2Value1.Enabled := false;
            UpDownReEnter5_2Value1.Enabled := false;
            CheckBoxUseReEnter5_3.Enabled := false;
        end;

        if m_Condition.m_FS_PrevData then
        begin
            CheckBox_UsePrevData.Enabled := f_EnableControl;
        end else
        begin
            CheckBox_UsePrevData.Enabled := false;
        end;

        if m_Condition.m_UseEnterTypeC1_0 then
        begin
            EditEnterC1_0Value1.Enabled := f_EnableControl;
            UpDownEnterC1_0Value1.Enabled := f_EnableControl;
        end else
        begin
            EditEnterC1_0Value1.Enabled := false;
            UpDownEnterC1_0Value1.Enabled := false;
        end;


        if m_Condition.m_UseEnterTypeC1_1 then
        begin
            EditEnterC1_1Value1.Enabled := f_EnableControl;
            UpDownEnterC1_1Value1.Enabled := f_EnableControl;
        end else
        begin
            EditEnterC1_1Value1.Enabled := false;
            UpDownEnterC1_1Value1.Enabled := false;
        end;

        if m_Condition.m_UseEnterTypeC1_2 then
        begin
            EditEnterC1_2Value1.Enabled := f_EnableControl;
            UpDownEnterC1_2Value1.Enabled := f_EnableControl;
        end else
        begin
            EditEnterC1_2Value1.Enabled := false;
            UpDownEnterC1_2Value1.Enabled := false;
        end;


        if m_Condition.m_FS_PrevDataType then
        begin
            ListViewOPSSymbol.Enabled := f_EnableControl;
            ComboBoxSymbolPrevDataType.Enabled := f_EnableControl;
            Label136.Enabled := f_EnableControl;
        end else
        begin
            ListViewOPSSymbol.Enabled := false;
            ComboBoxSymbolPrevDataType.Enabled := false;
            Label136.Enabled := false;
        end;




    finally
        m_EnableEvent := true;
    end;
end;

//------------------------------------------------------------------------------------
procedure TTMatrixBlockManageConditionFrame.SetControlEnable;
var
    f_Value:Boolean;
begin
    f_Value := m_EnableControl;

    EditPortfolioGroupName.Enabled := f_Value;
    EditPortfolioName.Enabled := f_Value;

    CheckBoxUseEnterA.Enabled := f_Value;
    EditEnterAValue1.Enabled := f_Value;
    CheckBoxUseEnterB.Enabled := f_Value;
    EditEnterBValue1.Enabled := f_Value;
    UpDownEnterBValue1.Enabled := f_Value;

    CheckBoxUseReverse.Enabled            := f_Value;

    CheckBox_FS_PrevData.Enabled            := f_Value;
    CheckBox_UsePrevData.Enabled            := f_Value;

    EditMA1Number.Enabled                   := f_Value;
    UpDownMA1Number.Enabled                 := f_Value;

    EditMA2Number.Enabled                   := f_Value;
    UpDownMA2Number.Enabled                 := f_Value;

    ComboBoxMAType.Enabled                  := f_Value;

    ComboBoxASS_DATECOUNT4.Enabled          := f_Value;
    EditASS_PERCENT_PROFITABLE.Enabled      := f_Value;
    EditASS_PROFIT_FACTOR.Enabled           := f_Value;
    EditASS_MAXDRAWDOWN.Enabled             := f_Value;
    ButtonRQ.Enabled                        := f_Value;
    ButtonApply.Enabled                     := f_Value;
    ComboBoxASS_TYPE.Enabled                := f_Value;

    ListViewASSItem.Enabled                 := f_Value;

    EditCommission.Enabled                  := f_Value;

    CheckBox_FS_PrevDataType.Enabled        := f_Value;
    ListViewOPSSymbol.Enabled               := f_Value;
    ComboBoxSymbolPrevDataType.Enabled      := f_Value;

    if not f_Value then
    begin
        f_Value := m_EditInRuntime;
    end;

    CheckBoxUseEnter2.Enabled := f_Value;
    CheckBoxUseEnter2_1.Enabled := f_Value;
    CheckBoxUseEnter2_2.Enabled := f_Value;
    CheckBoxUseEnter2_3.Enabled := f_Value;
    CheckBoxUseEnter2_4.Enabled := f_Value;
    CheckBoxUseEnter2_5.Enabled := f_Value;
    CheckBoxUseEnter2_6.Enabled := f_Value;
    CheckBoxUseEnter2_7.Enabled := f_Value;
    UpDownEnter2Value1.Enabled := f_Value;
    UpDownEnter2Value2.Enabled := f_Value;
    EditEnter2Value1.Enabled := f_Value;
    EditEnter2Value2.Enabled := f_Value;
    EditEnter2Value4.Enabled := f_Value;
    EditEnter2Value5.Enabled := f_Value;
    EditEnter2Value6.Enabled := f_Value;
    EditEnter2Value7.Enabled := f_Value;

    CheckBoxUseReEnter3.Enabled := f_Value;
    EditReEnter3Value1.Enabled := f_Value;
    EditReEnter3Value2.Enabled := f_Value;
    EditReEnter3Value3.Enabled := f_Value;
    EditReEnter3Value4.Enabled := f_Value;

    CheckBoxUseReEnter4.Enabled := f_Value;
    EditReEnter4Value1.Enabled := f_Value;
    EditReEnter4Value2.Enabled := f_Value;

    CheckBoxUseReEnter6.Enabled := f_Value;
    EditReEnter6Value1.Enabled := f_Value;
    UpDownReEnter6Value1.Enabled := f_Value;
    EditReEnter6Value2.Enabled := f_Value;

    CheckBoxUseReEnterA.Enabled := f_Value;
    EditReEnterAValue1.Enabled := f_Value;

    CheckBoxUseReEnterB.Enabled := f_Value;
    EditReEnterBValue1.Enabled := f_Value;
    EditReEnterBValue2.Enabled := f_Value;

    CheckBoxUseReEnterC.Enabled := f_Value;
    EditReEnterCValue1.Enabled := f_Value;
    EditReEnterCValue2.Enabled := f_Value;

    CheckBoxUseReEnterD.Enabled := f_Value;
    UpDownReEnterDValue1.Enabled := f_Value;
    EditReEnterDValue1.Enabled := f_Value;
    EditReEnterDValue2.Enabled := f_Value;
    EditReEnterDValue3.Enabled := f_Value;

    CheckBox_PLC1.Enabled := f_Value;

    Edit_PLC1_V1.Enabled := f_Value;
    Edit_PLC1_V2.Enabled := f_Value;
    Edit_PLC1_V3.Enabled := f_Value;
    Edit_PLC1_V4.Enabled := f_Value;
    Edit_PLC1_V5.Enabled := f_Value;
    Edit_PLC1_V6.Enabled := f_Value;

    Edit_PLC1_D1.Enabled := f_Value;
    Edit_PLC1_D2.Enabled := f_Value;
    Edit_PLC1_D3.Enabled := f_Value;
    Edit_PLC1_D4.Enabled := f_Value;
    Edit_PLC1_D5.Enabled := f_Value;
    Edit_PLC1_D6.Enabled := f_Value;

    CheckBox_PLC1_A1.Enabled := f_Value;
    CheckBox_PLC1_A2.Enabled := f_Value;
    CheckBox_PLC1_A3.Enabled := f_Value;
    CheckBox_PLC1_A4.Enabled := f_Value;
    CheckBox_PLC1_A5.Enabled := f_Value;
    CheckBox_PLC1_A6.Enabled := f_Value;

    Label1.Enabled := f_Value;
    Label2.Enabled := f_Value;
    Label3.Enabled := f_Value;
    Label5.Enabled := f_Value;
    Label39.Enabled := f_Value;
    Label40.Enabled := f_Value;

    CheckBoxUsePLC1Type2.Enabled    := f_Value;
    EditPLC1Type2Value1.Enabled     := f_Value;
    EditPLC1Type2Value2.Enabled     := f_Value;

    CheckBoxUsePLC1Type3.Enabled    := f_Value;
    EditPLC1Type3.Enabled           := f_Value;

    CheckBoxUseReEnter1.Enabled     := f_Value;

    CheckBoxUseReEnter2.Enabled     := f_Value;
    EditReEnter2Value1.Enabled      := f_Value;
    EditReEnter2Value2.Enabled      := f_Value;

    EditReEnter0Value1.Enabled      := f_Value;
    UpDownReEnter0Value1.Enabled    := f_Value;
    EditReEnter0Value2.Enabled      := f_Value;
    UpDownReEnter0Value2.Enabled    := f_Value;

    CheckBox_PLC2.Enabled := f_Value;

    Edit_PLC2_V1.Enabled := f_Value;
    Edit_PLC2_V2.Enabled := f_Value;
    Edit_PLC2_V3.Enabled := f_Value;
    Edit_PLC2_V4.Enabled := f_Value;
    Edit_PLC2_V5.Enabled := f_Value;
    Edit_PLC2_V6.Enabled := f_Value;

    Edit_PLC2_D1.Enabled := f_Value;
    Edit_PLC2_D2.Enabled := f_Value;
    Edit_PLC2_D3.Enabled := f_Value;
    Edit_PLC2_D4.Enabled := f_Value;
    Edit_PLC2_D5.Enabled := f_Value;
    Edit_PLC2_D6.Enabled := f_Value;

    CheckBox_PLC2_A1.Enabled := f_Value;
    CheckBox_PLC2_A2.Enabled := f_Value;
    CheckBox_PLC2_A3.Enabled := f_Value;
    CheckBox_PLC2_A4.Enabled := f_Value;
    CheckBox_PLC2_A5.Enabled := f_Value;
    CheckBox_PLC2_A6.Enabled := f_Value;

    Label17.Enabled     := f_Value;
    Label9.Enabled      := f_Value;
    Label10.Enabled     := f_Value;
    Label15.Enabled     := f_Value;
    Label37.Enabled     := f_Value;
    Label34.Enabled     := f_Value;

    CheckBoxUsePLC2Type2.Enabled            := f_Value;
    EditPLC2Type2Value1.Enabled             := f_Value;
    EditPLC2Type2Value2.Enabled             := f_Value;

    CheckBoxUsePLC2Type3.Enabled            := f_Value;
    EditPLC2Type3.Enabled                   := f_Value;

    CheckBoxUseLossTradeStop.Enabled        := f_Value;
    EditLossTradeStopValue1.Enabled         := f_Value;

    CheckBoxUseProfitTradeStop.Enabled      := f_Value;
    EditProfitTradeStopValue1.Enabled       := f_Value;

    CheckBoxUseMA1ConsecutiveUp.Enabled     := f_Value;
    EditMA1ConsecutiveUpCount.Enabled       := f_Value;
    UpDownMA1ConsecutiveUpCount.Enabled     := f_Value;

    CheckBoxUseMA2ConsecutiveUp.Enabled     := f_Value;
    EditMA2ConsecutiveUpCount.Enabled       := f_Value;
    UpDownMA2ConsecutiveUpCount.Enabled     := f_Value;

    CheckBoxUseMA1AboveMA2.Enabled          := f_Value;
    CheckBoxUseReEnterC3_4.Enabled          := f_Value;
    CheckBoxUseReEnterC3_5.Enabled          := f_Value;
    CheckBoxUseReEnterC3_6.Enabled          := f_Value;
    EditReEnterC3_4Value1.Enabled          := f_Value;
    EditReEnterC3_5Value1.Enabled          := f_Value;
    EditReEnterC3_6Value1.Enabled          := f_Value;

    CheckBoxUsePLC1Type4.Enabled            := f_Value;
    CheckBoxUsePLC1Type4_1.Enabled          := f_Value;
    EditPLC1Type4Value1.Enabled             := f_Value;
    UpDownPLC1Type4Value1.Enabled           := f_Value;
    CheckBoxUsePLC1Type4_2.Enabled          := f_Value;
    EditPLC1Type4Value2.Enabled             := f_Value;
    UpDownPLC1Type4Value2.Enabled           := f_Value;
    CheckBoxUsePLC1Type4_3.Enabled          := f_Value;

    EditPLC1Type4Value3.Enabled             := f_Value;
    EditPLC1Type4Value4.Enabled             := f_Value;
    UpDownPLC1Type4Value4.Enabled           := f_Value;
    EditPLC1Type4Value5.Enabled             := f_Value;

    CheckBoxUsePLC2Type4.Enabled            := f_Value;
    CheckBoxUsePLC2Type4_1.Enabled          := f_Value;
    EditPLC2Type4Value1.Enabled             := f_Value;
    UpDownPLC2Type4Value1.Enabled           := f_Value;
    CheckBoxUsePLC2Type4_2.Enabled          := f_Value;
    EditPLC2Type4Value2.Enabled             := f_Value;
    UpDownPLC2Type4Value2.Enabled           := f_Value;
    CheckBoxUsePLC2Type4_3.Enabled          := f_Value;

    CheckBoxUsePLC2Type5.Enabled            := f_Value;
    CheckBoxUsePLC2Type5_1.Enabled          := f_Value;
    EditPLC2Type5Value1.Enabled             := f_Value;
    UpDownPLC2Type5Value1.Enabled           := f_Value;
    CheckBoxUsePLC2Type5_2.Enabled          := f_Value;
    EditPLC2Type5Value2.Enabled             := f_Value;
    UpDownPLC2Type5Value2.Enabled           := f_Value;
    CheckBoxUsePLC2Type5_3.Enabled          := f_Value;


    EditPLC2Type4Value3.Enabled             := f_Value;
    EditPLC2Type4Value4.Enabled             := f_Value;
    UpDownPLC2Type4Value4.Enabled           := f_Value;
    EditPLC2Type4Value5.Enabled             := f_Value;

    CheckBoxUsePLC1TypeC_1.Enabled          := f_Value;
    EditPLC1TypeCValue1.Enabled             := f_Value;
    UpDownPLC1TypeCValue1.Enabled           := f_Value;
    CheckBoxUsePLC1TypeC_2.Enabled          := f_Value;
    EditPLC1TypeCValue2.Enabled             := f_Value;
    UpDownPLC1TypeCValue2.Enabled           := f_Value;
    CheckBoxUsePLC1TypeC_3.Enabled          := f_Value;

    CheckBoxUsePLC2TypeC_1.Enabled          := f_Value;
    EditPLC2TypeCValue1.Enabled             := f_Value;
    UpDownPLC2TypeCValue1.Enabled           := f_Value;
    CheckBoxUsePLC2TypeC_2.Enabled          := f_Value;
    EditPLC2TypeCValue2.Enabled             := f_Value;
    UpDownPLC2TypeCValue2.Enabled           := f_Value;
    CheckBoxUsePLC2TypeC_3.Enabled          := f_Value;

    CheckBoxUseReEnter5.Enabled             := f_Value;
    CheckBoxUseReEnter5_1.Enabled           := f_Value;
    EditReEnter5_1Value1.Enabled            := f_Value;
    UpDownReEnter5_1Value1.Enabled          := f_Value;
    CheckBoxUseReEnter5_2.Enabled           := f_Value;
    EditReEnter5_2Value1.Enabled            := f_Value;
    UpDownReEnter5_2Value1.Enabled          := f_Value;
    CheckBoxUseReEnter5_3.Enabled           := f_Value;


    CheckBoxUseEnterC1_0.Enabled            := f_Value;
    EditEnterC1_0Value1.Enabled             := f_Value;
    CheckBoxUseEnterC1_1.Enabled            := f_Value;
    EditEnterC1_1Value1.Enabled             := f_Value;
    UpDownEnterC1_1Value1.Enabled           := f_Value;
    CheckBoxUseEnterC1_2.Enabled            := f_Value;
    EditEnterC1_2Value1.Enabled             := f_Value;
    UpDownEnterC1_2Value1.Enabled           := f_Value;
    CheckBoxUseEnterC1_3.Enabled            := f_Value;

    CheckBoxUseEnterC1_4.Enabled           := f_Value;
    EditEnterC1_4Value1.Enabled            := f_Value;
    CheckBoxUseEnterC1_5.Enabled           := f_Value;
    EditEnterC1_5Value1.Enabled            := f_Value;
    CheckBoxUseEnterC1_6.Enabled           := f_Value;
    EditEnterC1_6Value1.Enabled            := f_Value;

    if m_EnableControl then UpdateControl;
end;

end.
