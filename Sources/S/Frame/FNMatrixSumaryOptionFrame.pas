unit FNMatrixSumaryOptionFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, MXSumaryOption, FNDataDelivery,
  FNDataSet;

type
  TMatrixSumaryOptionFrame = class(TFrame)
    PageControlSummary: TPageControl;
    TabSheet1: TTabSheet;
    Panel7: TPanel;
    GroupBox13: TGroupBox;
    Label62: TLabel;
    CheckBoxUseLossTradeStop: TCheckBox;
    EditLossTradeStopValue1: TEdit;
    GroupBox6: TGroupBox;
    LabelACCOUNT_pw: TLabel;
    LabelACCOUNT_NO: TLabel;
    LabelACCOUNT_NAME: TLabel;
    EditACCOUNT_PW: TEdit;
    ComboBoxACCOUNT_NO: TComboBox;
    RadioGroupSYSTEM_MODE: TRadioGroup;

    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure OptionChange(Sender: TObject);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);

  private
    m_EnableControl: Boolean;
    m_EnableEvent: Boolean;
    m_Condition: CMXSumaryOption;

    procedure ApplyLanguage;

  public
    procedure OnFormCreate;
    procedure OnFormClose;

    procedure GetOption;
    procedure SetOption;

    procedure UpdateControl;
    procedure AttachCondition(ACondition: CMXSumaryOption);
    function DetachCondition(AUpdate: Boolean = false): CMXSumaryOption;

    procedure SetEnable(AValue: Boolean);

    procedure SetControlEnable;

  end;

implementation

{$R *.dfm}

uses Math, FNGlobal, DateUtils, FNCMVariable, MXSystemManager, MXOrderManager,
  FNPOTCollection, MXVariable,
  FNAccountData, FNAccountArray;

// ------------------------------------------------------------------------------------
procedure TMatrixSumaryOptionFrame.ApplyLanguage;
begin
  if (g_Language = 0) then
  begin
    TabSheet1.Caption := '설정';
    GroupBox13.Caption := '손실정지';
    CheckBoxUseLossTradeStop.Caption := '사용여부';
    Label62.Caption := '최대손실($) :'
  end
  else if (g_Language = 1) then
  begin
    TabSheet1.Caption := 'Conditon';
    GroupBox13.Caption := 'Loss cut';
    CheckBoxUseLossTradeStop.Caption := 'Use';
    Label62.Caption := 'Max Loss($) :'
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixSumaryOptionFrame.OnFormCreate;
begin
  m_EnableControl := true;

  PageControlSummary.ActivePageIndex := 0;
  SetOption;
  UpdateControl;
  ApplyLanguage;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixSumaryOptionFrame.OnFormClose;
begin

end;

// ------------------------------------------------------------------------------------
procedure TMatrixSumaryOptionFrame.AttachCondition(ACondition: CMXSumaryOption);
begin
  m_Condition := ACondition;

  if Assigned(m_Condition) then
  begin
    SetOption;
    UpdateControl;
  end;
end;

// ------------------------------------------------------------------------------------
function TMatrixSumaryOptionFrame.DetachCondition(AUpdate: Boolean): CMXSumaryOption;
begin
  Result := m_Condition;

  m_Condition := NIL;

  if AUpdate then
  begin
    SetEnable(false);
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixSumaryOptionFrame.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['0' .. '9', '-', #8, #9, #32, #3, #22, #$2E] then
  // 0~9, -, Tab, BS, Space, Ctrl+C, Ctrl+V ?? ???
  begin
  end
  else
  begin
    Key := #0;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixSumaryOptionFrame.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  if not Assigned(m_Condition) then
    exit;
  if not m_EnableEvent then
    exit;
  GetOption;
  UpdateControl;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixSumaryOptionFrame.OptionChange(Sender: TObject);
begin
  if not Assigned(m_Condition) then
    exit;
  if not m_EnableEvent then
    exit;
  GetOption;
  UpdateControl;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixSumaryOptionFrame.SetEnable(AValue: Boolean);
begin
  m_EnableControl := AValue;

  SetControlEnable;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixSumaryOptionFrame.SetOption;
var
  LIndex: Integer;
  LAccountData: CFNAccountData;
begin
  if not Assigned(m_Condition) then
    exit;

  m_EnableEvent := false;

  CheckBoxUseLossTradeStop.Checked := m_Condition.GetBooleanValue('USELOSSTRADESTOP');
  EditLossTradeStopValue1.Text := TFNGlobal.WriteNumberF(m_Condition.GetDoubleValue('LOSSTRADESTOP'), 1);

{$REGION '계좌번호의 콤보박스를 설정한다 '}
  ComboBoxACCOUNT_NO.Clear;
  for LIndex := 0 to g_AccountArray.m_Items.Count - 1 do
  begin
    LAccountData := CFNAccountData(g_AccountArray.m_Items[LIndex]);
    ComboBoxACCOUNT_NO.AddItem(LAccountData.m_AccountNo, LAccountData);
  end;

  if g_AccountArray.m_Items.Count > 0 then
  begin
    ComboBoxACCOUNT_NO.ItemIndex := 0;
    LabelACCOUNT_NAME.Caption := CFNAccountData(g_AccountArray.m_Items[0]).m_AccountName;
  end;
{$ENDREGION}
  RadioGroupSYSTEM_MODE.ItemIndex := m_Condition.GetIntegerValue('SYSTEM_MODE');

  m_EnableEvent := true;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixSumaryOptionFrame.GetOption;
var
  LIndex: Integer;
  LAccountData: CFNAccountData;
begin
  if not Assigned(m_Condition) then
    exit;

  try
    m_Condition.SetBooleanValue('USELOSSTRADESTOP', CheckBoxUseLossTradeStop.Checked);
    m_Condition.SetDoubleValue('LOSSTRADESTOP', TFNGlobal.atof(EditLossTradeStopValue1.Text));

{$REGION '계좌정보'}
    if ComboBoxACCOUNT_NO.ItemIndex >= 0 then
    begin
      LAccountData := g_AccountArray.m_Items[ComboBoxACCOUNT_NO.ItemIndex];
      m_Condition.SetStringValue('ACCOUNT_NO', LAccountData.m_AccountNo);
    end
    else
    begin
      m_Condition.SetStringValue('ACCOUNT_NO', '');
    end;

    m_Condition.SetStringValue('ACCOUNT_PW', EditACCOUNT_PW.Text);

{$ENDREGION}
    m_Condition.SetIntegerValue('SYSTEM_MODE', RadioGroupSYSTEM_MODE.ItemIndex);

  finally
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixSumaryOptionFrame.UpdateControl;
var
  f_OpenDateTime: TDateTime;
  f_CloseDateTime: TDateTime;

  f_EnableControl: Boolean;
begin
  if not Assigned(m_Condition) then
    exit;
end;

// ------------------------------------------------------------------------------------
procedure TMatrixSumaryOptionFrame.SetControlEnable;
var
  f_Value: Boolean;
begin
  f_Value := m_EnableControl;

  CheckBoxUseLossTradeStop.Enabled := f_Value;
  EditLossTradeStopValue1.Enabled := f_Value;

  if m_EnableControl then
    UpdateControl;
end;

end.
