unit COND_REINFORCE_Frame;

interface

uses Windows, SysUtils, Classes, WinProcs, Graphics, Forms, Controls, StdCtrls,
  ExtCtrls, Math,
  ComCtrls, Buttons, MXTradeStrategy, MXTradeStrategyOptionCollection, ActnList,
  Menus,
  MXTradeStrategyFrame;

type
  TREINFORCE_Frame = class(TTradeStrategyFrame)
    Panel9: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    ComboBoxRF1_STD_VALUE: TComboBox;
    ButtonRF1_PRICEMETHOD: TButton;
    ComboBoxRF1_PRICEMETHOD: TComboBox;
    CheckBoxRF1_USE_CONDITION: TCheckBox;
    ComboBoxRF1_VALUE_TYPE: TComboBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    CheckBoxRF2_USE_CONDITION: TCheckBox;
    Panel4: TPanel;
    Label12: TLabel;
    ComboBoxRF2_VALUE_TYPE: TComboBox;
    Label7: TLabel;
    EditRF2_LENGTH: TEdit;
    UpDownRF2_LENGTH: TUpDown;
    UpDownRF2_PRECISION: TUpDown;
    EditRF2_PRECISION: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    ComboBoxRF2_AVERAGE_TYPE: TComboBox;
    Panel5: TPanel;
    CheckBoxRF3_USE_CONDITION: TCheckBox;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    CheckBoxRF1_USE_TOLERANCE: TCheckBox;
    EditRF1_TOLERANCE: TEdit;
    ComboBoxRF1_TOLERANCE_UNIT: TComboBox;
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure EditChange(Sender: TObject);
    procedure OptionChange(Sender: TObject);
    procedure ButtonRF1_PRICEMETHODClick(Sender: TObject);
  private
    // 화면컨트롤에서 데이터를 가져온다.
    procedure GetControlData; override;

    // 화면컨트롤에 데이터를 설정한다.
    procedure SetControlData; override;

    // 화면컨트롤의 상태를 업데이터 한다.
    procedure UpdateControlData; override;

  protected
    // 외부에서 옵션객체를 설정한다.
    procedure AssignOption(AOption: CMXTradeStrategyOption); override;
    // 옵션객체를 가져간다.
    function GetOption: CMXTradeStrategyOption; override;
    // 옵션의 기본값을 만든다.
    procedure MakeDefaultOption(AOption: CMXTradeStrategyOption); override;

    procedure ApplyLanguage;

  public
    constructor Create(AOwner: TComponent); override;

  end;

implementation

{$R *.dfm}

uses
  FNGlobal, MXTSVariable, MXVariable, FNCMVariable,
  FNPOTCollection, MKTradeStrategyConst, TSSelPriceLineDlg;

// -----------------------------------------------------------------------------
procedure TREINFORCE_Frame.ButtonRF1_PRICEMETHODClick(Sender: TObject);
begin
  if not Assigned(m_Option) then
    exit;

  SelPriceLineDlg := TSelPriceLineDlg.Create(Self);
  SelPriceLineDlg.Prefix := 'RF1_';
  SelPriceLineDlg.Option := m_Option;

  if SelPriceLineDlg.ShowModal = mrOK then
  begin
    m_Option.Clone(SelPriceLineDlg.Option);
    UpdateControlData;
    if Assigned(m_ChangedOption) then
      m_ChangedOption(Self);
  end;

  SelPriceLineDlg.Free;
  SelPriceLineDlg := NIL;
end;

procedure TREINFORCE_Frame.ApplyLanguage;
begin
  if (g_Language = 0) then
  begin
    Panel5.Caption := '보강조건';
    GroupBox1.Caption := '보강조건1-기준선';
    GroupBox3.Caption := '보강조건2-일간추세전환';
    GroupBox2.Caption := '비추세전략시 반대매매';
    GroupBox4.Caption := '허용범위';

    CheckBoxRF1_USE_CONDITION.Caption := '사용여부';
    Label2.Caption := '기준선의 종류';
    Label4.Caption := '기준선과 비교할 가격선  :';
    Label1.Caption := '가격지표의 종류 : ';

    ComboBoxRF1_STD_VALUE.Items.Clear;
    ComboBoxRF1_STD_VALUE.Items.Add('전일종가');
    ComboBoxRF1_STD_VALUE.Items.Add('당일시가');

    ComboBoxRF1_PRICEMETHOD.Items.Clear;
    ComboBoxRF1_PRICEMETHOD.Items.Add('종가');
    ComboBoxRF1_PRICEMETHOD.Items.Add('고가.저가');
    ComboBoxRF1_PRICEMETHOD.Items.Add('(고가+저가)/2');
    ComboBoxRF1_PRICEMETHOD.Items.Add('볼랜저밴드의 상하한선');

    CheckBoxRF2_USE_CONDITION.Caption := '사용유무';
    Label12.Caption := '가격지표의 종류 : ';
    ComboBoxRF2_VALUE_TYPE.Clear;
    ComboBoxRF2_VALUE_TYPE.Items.Add('가격');
    ComboBoxRF2_VALUE_TYPE.Items.Add('MATRIX');

    Label8.Caption := '소수점자릿수 :';
    Label7.Caption := '이동평균선 설정 :';
    Label9.Caption := '이동평균선 종류 :';
    ComboBoxRF2_AVERAGE_TYPE.Items.Clear;
    ComboBoxRF2_AVERAGE_TYPE.Items.Add('단순');
    ComboBoxRF2_AVERAGE_TYPE.Items.Add('가중');
    ComboBoxRF2_AVERAGE_TYPE.Items.Add('지수');

    CheckBoxRF3_USE_CONDITION.Caption := '사용여부';
  end
  else
  begin
    Panel5.Caption := 'Suppliment';
    GroupBox1.Caption := 'Base line';
    GroupBox3.Caption := 'Daily trend reverse';
    GroupBox2.Caption := 'Clearing trade when counter trend';
    GroupBox4.Caption := 'Tolerance';

    CheckBoxRF1_USE_CONDITION.Caption := 'Use';
    Label2.Caption := 'Baseline base';
    Label4.Caption := 'Price for baseline  : ';
    Label1.Caption := 'Price base : ';

    ComboBoxRF1_STD_VALUE.Items.Clear;
    ComboBoxRF1_STD_VALUE.Items.Add('Yesterday close');
    ComboBoxRF1_STD_VALUE.Items.Add('Today''s open');

    ComboBoxRF1_PRICEMETHOD.Items.Clear;
    ComboBoxRF1_PRICEMETHOD.Items.Add('Close');
    ComboBoxRF1_PRICEMETHOD.Items.Add('High,Low');
    ComboBoxRF1_PRICEMETHOD.Items.Add('(High+Low)/2');
    ComboBoxRF1_PRICEMETHOD.Items.Add('high/low of Bollinger band');

    CheckBoxRF2_USE_CONDITION.Caption := 'Use';
    Label12.Caption := 'Price base : ';
    ComboBoxRF2_VALUE_TYPE.Clear;
    ComboBoxRF2_VALUE_TYPE.Items.Add('Price');
    ComboBoxRF2_VALUE_TYPE.Items.Add('MATRIX');

    Label8.Caption := 'digit :';
    Label7.Caption := 'moving average set :';
    Label9.Caption := 'kind of moving average :';
    ComboBoxRF2_AVERAGE_TYPE.Items.Clear;
    ComboBoxRF2_AVERAGE_TYPE.Items.Add('Simple');
    ComboBoxRF2_AVERAGE_TYPE.Items.Add('Weight');
    ComboBoxRF2_AVERAGE_TYPE.Items.Add('Exponential');

    CheckBoxRF3_USE_CONDITION.Caption := 'Use';
    CheckBoxRF1_USE_TOLERANCE.Caption := 'Use';
    ComboBoxRF1_TOLERANCE_UNIT.Items.Clear;
    ComboBoxRF1_TOLERANCE_UNIT.Items.Add('percent');
    ComboBoxRF1_TOLERANCE_UNIT.Items.Add('absolute');
  end;
end;

// -----------------------------------------------------------------------------
constructor TREINFORCE_Frame.Create(AOwner: TComponent);
var
  f_Index: Integer;
  f_Option: CMXTradeStrategyOption;
begin
  inherited Create(AOwner);

  MakeDefaultOption(m_Option);

  SetControlData;

  ApplyLanguage;
end;

// 화면컨트롤에서 데이터를 가져온다.
// -----------------------------------------------------------------------------
procedure TREINFORCE_Frame.GetControlData;
var
  f_Time: TTime;
begin
  inherited GetControlData;

  if not Assigned(m_Option) then
    exit;

  m_Option.SetBooleanValue('RF1_USE_CONDITION', CheckBoxRF1_USE_CONDITION.Checked);
  m_Option.SetIntegerValue('RF1_STD_VALUE', ComboBoxRF1_STD_VALUE.ItemIndex);
  m_Option.SetIntegerValue('RF1_VALUE_TYPE', ComboBoxRF1_VALUE_TYPE.ItemIndex);
  m_Option.SetIntegerValue('RF1_PRICEMETHOD', ComboBoxRF1_PRICEMETHOD.ItemIndex);

  m_Option.SetBooleanValue('RF1_USE_TOLERANCE', CheckBoxRF1_USE_TOLERANCE.Checked);
  m_Option.SetDoubleValue('RF1_TOLERANCE', TFNGlobal.atof(EditRF1_TOLERANCE.Text));
  m_Option.SetIntegerValue('RF1_TOLERANCE_UNIT', ComboBoxRF1_TOLERANCE_UNIT.ItemIndex);

  m_Option.SetBooleanValue('RF2_USE_CONDITION', CheckBoxRF2_USE_CONDITION.Checked);
  m_Option.SetIntegerValue('RF2_VALUE_TYPE', ComboBoxRF2_VALUE_TYPE.ItemIndex);
  m_Option.SetIntegerValue('RF2_LENGTH', UpDownRF2_LENGTH.Position);
  m_Option.SetIntegerValue('RF2_PRECISION', UpDownRF2_PRECISION.Position);
  m_Option.SetIntegerValue('RF2_AVERAGE_TYPE', ComboBoxRF2_AVERAGE_TYPE.ItemIndex);

  m_Option.SetBooleanValue('RF3_USE_CONDITION', CheckBoxRF3_USE_CONDITION.Checked);
end;

// -----------------------------------------------------------------------------
procedure TREINFORCE_Frame.MakeDefaultOption(AOption: CMXTradeStrategyOption);
begin
  CMXTradeStrategyOption.Default_Reinforce1(AOption);
  CMXTradeStrategyOption.Default_Reinforce2(AOption);
  CMXTradeStrategyOption.Default_Reinforce3(AOption);
end;

// -----------------------------------------------------------------------------
procedure TREINFORCE_Frame.SetControlData;
begin
  inherited SetControlData;

  if not Assigned(m_Option) then
    exit;

  m_EnableEvent := false;
  try
    CheckBoxRF1_USE_CONDITION.Checked := m_Option.GetBooleanValue('RF1_USE_CONDITION');
    ComboBoxRF1_STD_VALUE.ItemIndex := m_Option.GetIntegerValue('RF1_STD_VALUE');
    ComboBoxRF1_VALUE_TYPE.ItemIndex := m_Option.GetIntegerValue('RF1_VALUE_TYPE');
    ComboBoxRF1_PRICEMETHOD.ItemIndex := m_Option.GetIntegerValue('RF1_PRICEMETHOD');

    CheckBoxRF1_USE_TOLERANCE.Checked := m_Option.GetBooleanValue('RF1_USE_TOLERANCE');
    EditRF1_TOLERANCE.Text := TFNGlobal.WriteNumber(m_Option.GetDoubleValue('RF1_TOLERANCE'), 3);
    ComboBoxRF1_TOLERANCE_UNIT.ItemIndex := m_Option.GetIntegerValue('RF1_TOLERANCE_UNIT');

    CheckBoxRF2_USE_CONDITION.Checked := m_Option.GetBooleanValue('RF2_USE_CONDITION');
    ComboBoxRF2_VALUE_TYPE.ItemIndex := m_Option.GetIntegerValue('RF2_VALUE_TYPE');
    UpDownRF2_LENGTH.Position := m_Option.GetIntegerValue('RF2_LENGTH');
    UpDownRF2_PRECISION.Position := m_Option.GetIntegerValue('RF2_PRECISION');
    ComboBoxRF2_AVERAGE_TYPE.ItemIndex := m_Option.GetIntegerValue('RF2_AVERAGE_TYPE');

    CheckBoxRF3_USE_CONDITION.Checked := m_Option.GetBooleanValue('RF3_USE_CONDITION');
  finally
    m_EnableEvent := true;
  end;
end;

// -----------------------------------------------------------------------------
procedure TREINFORCE_Frame.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in [#$D] then
  begin
    EditChange(Sender);
    exit;
  end;

  if Key in ['0' .. '9', '-', #8, #9, #32, #3, #22, #$2E] then
  begin
  end
  else
  begin
    Key := #0;
  end;
end;

// -----------------------------------------------------------------------------
procedure TREINFORCE_Frame.UpdateControlData;
begin
  SetControlData;
end;

// -----------------------------------------------------------------------------
procedure TREINFORCE_Frame.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  if not Assigned(m_Option) then
    exit;
  if not m_EnableEvent then
    exit;

  GetControlData;
  UpdateControlData;
  ApplyToOrignal;

  if Assigned(m_ChangedOption) then
    m_ChangedOption(Self);
end;

// -----------------------------------------------------------------------------
procedure TREINFORCE_Frame.EditChange(Sender: TObject);
begin
  if not Assigned(m_Option) then
    exit;
  if not m_EnableEvent then
    exit;

  GetControlData;
  // UpdateControlData;
  ApplyToOrignal;

  if Assigned(m_ChangedOption) then
    m_ChangedOption(Self);
end;

// -----------------------------------------------------------------------------
procedure TREINFORCE_Frame.OptionChange(Sender: TObject);
begin
  if not Assigned(m_Option) then
    exit;
  if not m_EnableEvent then
    exit;

  GetControlData;
  UpdateControlData;
  ApplyToOrignal;

  if Assigned(m_ChangedOption) then
    m_ChangedOption(Self);
end;

// -----------------------------------------------------------------------------
// 외부에서 옵션객체를 설정한다.
procedure TREINFORCE_Frame.AssignOption(AOption: CMXTradeStrategyOption);
begin
  m_Option.CopyValue(AOption);
  SetControlData;
end;

// -----------------------------------------------------------------------------
// 옵션객체를 가져간다.
function TREINFORCE_Frame.GetOption: CMXTradeStrategyOption;
begin
  result := m_Option;
end;

end.
