unit TSSTC_T3_Frame;

interface

uses Windows, SysUtils, Classes, WinProcs, Graphics, Forms, Controls, StdCtrls,
  ExtCtrls, Math,
  ComCtrls, Buttons, MXTradeStrategy, MXTradeStrategyFrame,
  MXTradeStrategyOptionCollection, ActnList, Menus;

type
  TSTC_T3_Frame = class(TTradeStrategyFrame)
    Panel1: TPanel;
    Panel3: TPanel;
    GroupBoxMajorType: TGroupBox;
    ComboBoxMajorType: TComboBox;
    Panel4: TPanel;
    Panel5: TPanel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    EditLENGTH1: TEdit;
    UpDownLENGTH1: TUpDown;
    EditLENGTH2: TEdit;
    UpDownLENGTH2: TUpDown;
    EditLENGTH3: TEdit;
    UpDownLENGTH3: TUpDown;
    Panel6: TPanel;
    Label1: TLabel;
    EditLENGTH4: TEdit;
    UpDownLENGTH4: TUpDown;
    EditLENGTH5: TEdit;
    UpDownLENGTH5: TUpDown;
    EditLENGTH6: TEdit;
    UpDownLENGTH6: TUpDown;
    PopupMenuOption: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    GroupBoxOptionManagement: TGroupBox;
    ComboBoxOptionCollection: TComboBox;
    ButtonPopupMenu: TButton;
    Label2: TLabel;
    Label5: TLabel;
    EditDN: TEdit;
    EditUP: TEdit;
    UpDownUP: TUpDown;
    UpDownDN: TUpDown;
    Panel7: TPanel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    CheckBoxUSE_TOLERANCE: TCheckBox;
    EditTOLERANCE: TEdit;
    ComboBoxTOLERANCE_UNIT: TComboBox;
    procedure ComboBoxMajorTypeChange(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure OptionChange(Sender: TObject);
    procedure ButtonApplyTSOptionClick(Sender: TObject);
    procedure ButtonOptionManagementClick(Sender: TObject);
    procedure ButtonFavorClick(Sender: TObject);
    procedure ComboBoxOptionCollectionChange(Sender: TObject);
    procedure ButtonPopupMenuClick(Sender: TObject);

  private

    // 화면컨트롤에서 데이터를 가져온다.
    procedure GetControlData; override;

    // 화면컨트롤에 데이터를 설정한다.
    procedure SetControlData; override;

    // 화면컨트롤의 상태를 업데이터 한다.
    procedure UpdateControlData; override;

  protected

    // 옵션의 기본값을 만든다.
    procedure MakeDefaultOption(AOption: CMXTradeStrategyOption); override;
    procedure ApplyLanguage;

  public
    constructor Create(AOwner: TComponent); override;

  end;

implementation

{$R *.dfm}

uses FNGlobal, FNCMVariable, MXTSVariable, MKTradeStrategyConst;

procedure TSTC_T3_Frame.ApplyLanguage;
begin
  if (g_Language = 0) then
  begin
    Panel4.Caption := 'Stochastic 추세 2';
    GroupBoxOptionManagement.Caption := '저장과 적용';
    GroupBoxMajorType.Caption := '가격지표';
    ComboBoxMajorType.Items.Clear;
    ComboBoxMajorType.Items.Add('가격');
    ComboBoxMajorType.Items.Add('MATRIX');
    ComboBoxMajorType.Items.Add('MATRIX2');

    GroupBox2.Caption := '단순조건';
    Label3.Caption := 'Stochastic 설정 :';
    Label2.Caption := '초과 매수권 :';
    Label5.Caption := '초과 매도권 :';

    Label1.Caption := 'Stochastic 2 설정 :';

    GroupBox1.Caption := '허용범위';
    CheckBoxUSE_TOLERANCE.Caption := '사용유무';
    ComboBoxTOLERANCE_UNIT.Items.Clear;
    ComboBoxTOLERANCE_UNIT.Items.Add('퍼센트');
    ComboBoxTOLERANCE_UNIT.Items.Add('절대값');

  end
  else
  begin
    Panel4.Caption := 'Stochastic Trend 2';
    GroupBoxOptionManagement.Caption := 'Save && Apply';
    GroupBoxMajorType.Caption := 'Price condition';
    ComboBoxMajorType.Items.Clear;
    ComboBoxMajorType.Items.Add('Price');
    ComboBoxMajorType.Items.Add('MATRIX');
    ComboBoxMajorType.Items.Add('MATRIX2');

    GroupBox2.Caption := 'Conditoin';
    Label3.Caption := 'Stochastic :';

    Label3.Caption := 'Stochastic 1 :';
    Label2.Caption := 'P1 :';
    Label5.Caption := 'P2 :';

    Label1.Caption := 'Stochastic 2 :';

    GroupBox1.Caption := 'Tolerance';
    CheckBoxUSE_TOLERANCE.Caption := 'Use';
    ComboBoxTOLERANCE_UNIT.Items.Clear;
    ComboBoxTOLERANCE_UNIT.Items.Add('percent');
    ComboBoxTOLERANCE_UNIT.Items.Add('absolute');
  end;
end;

constructor TSTC_T3_Frame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_ComboBoxOptionCollection := ComboBoxOptionCollection;
  CMXTradeStrategyOption.Default_STC_T3(m_Option);
  m_Category := m_Option.GetStringValue('CATEGORY');
  g_StrategyOptionCollection.ExtractOnCategory(m_Category, m_OptionCollection);

  SetControlData;

  InitComboBoxOptionCollection;
  ApplyLanguage;
end;

procedure TSTC_T3_Frame.MakeDefaultOption(AOption: CMXTradeStrategyOption);
begin
  CMXTradeStrategyOption.Default_STC_T3(AOption);
end;

// 화면컨트롤에서 데이터를 가져온다.
procedure TSTC_T3_Frame.GetControlData;
begin
  inherited GetControlData;

  if not Assigned(m_Option) then
    exit;

  m_Option.SetIntegerValue(TSOPTION_KEY_MAJORVALUE, ComboBoxMajorType.ItemIndex);
  m_Option.SetIntegerValue('LENGTH1', UpDownLENGTH1.Position);
  m_Option.SetIntegerValue('LENGTH2', UpDownLENGTH2.Position);
  m_Option.SetIntegerValue('LENGTH3', UpDownLENGTH3.Position);
  m_Option.SetIntegerValue('LENGTH4', UpDownLENGTH4.Position);
  m_Option.SetIntegerValue('LENGTH5', UpDownLENGTH5.Position);
  m_Option.SetIntegerValue('LENGTH6', UpDownLENGTH6.Position);
  m_Option.SetDoubleValue('UP', UpDownUP.Position);
  m_Option.SetDoubleValue('DN', UpDownDN.Position);

  m_Option.SetBooleanValue('USE_TOLERANCE', CheckBoxUSE_TOLERANCE.Checked);
  m_Option.SetDoubleValue('TOLERANCE', TFNGlobal.atof(EditTOLERANCE.Text));
  m_Option.SetIntegerValue('TOLERANCE_UNIT', ComboBoxTOLERANCE_UNIT.ItemIndex);
end;

procedure TSTC_T3_Frame.SetControlData;
begin
  inherited SetControlData;

  if not Assigned(m_Option) then
    exit;
  m_EnableEvent := false;
  try
    ComboBoxMajorType.ItemIndex := m_Option.GetIntegerValue(TSOPTION_KEY_MAJORVALUE);
    UpDownLENGTH1.Position := m_Option.GetIntegerValue('LENGTH1');
    UpDownLENGTH2.Position := m_Option.GetIntegerValue('LENGTH2');
    UpDownLENGTH3.Position := m_Option.GetIntegerValue('LENGTH3');
    UpDownLENGTH4.Position := m_Option.GetIntegerValue('LENGTH4');
    UpDownLENGTH5.Position := m_Option.GetIntegerValue('LENGTH5');
    UpDownLENGTH6.Position := m_Option.GetIntegerValue('LENGTH6');
    UpDownUP.Position := Trunc(m_Option.GetDoubleValue('UP'));
    UpDownDN.Position := Trunc(m_Option.GetDoubleValue('DN'));

    CheckBoxUSE_TOLERANCE.Checked := m_Option.GetBooleanValue('USE_TOLERANCE');
    EditTOLERANCE.Text := TFNGlobal.WriteNumber(m_Option.GetDoubleValue('TOLERANCE'), 3);
    ComboBoxTOLERANCE_UNIT.ItemIndex := m_Option.GetIntegerValue('TOLERANCE_UNIT');
  finally
    m_EnableEvent := true;
  end;
end;

procedure TSTC_T3_Frame.ButtonApplyTSOptionClick(Sender: TObject);
begin
  ApplyOptionCollection;
end;

procedure TSTC_T3_Frame.ButtonFavorClick(Sender: TObject);
begin
  AddFavorOptionCollection;
end;

procedure TSTC_T3_Frame.ButtonOptionManagementClick(Sender: TObject);
begin
  ManagementOptionCollection;
end;

procedure TSTC_T3_Frame.ButtonPopupMenuClick(Sender: TObject);
var
  f_PT: TPoint;
begin
  f_PT := ComboBoxOptionCollection.ClientToScreen(Point(0, ComboBoxOptionCollection.Height + 2));
  PopupMenuOption.Popup(f_PT.x, f_PT.y);
end;

procedure TSTC_T3_Frame.ComboBoxMajorTypeChange(Sender: TObject);
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

procedure TSTC_T3_Frame.ComboBoxOptionCollectionChange(Sender: TObject);
begin
  ApplyOptionCollection;
end;

procedure TSTC_T3_Frame.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in [#$D] then
  begin
    OptionChange(Sender);
    exit;
  end;

  if Key in ['0' .. '9', '-', #8, #9, #32, #3, #22, #$2E] then
  // 0~9, -, Tab, BS, Space, Ctrl+C, Ctrl+V
  begin
  end
  else
  begin
    Key := #0;
  end;
end;

procedure TSTC_T3_Frame.UpdateControlData;
begin
  SetControlData;
end;

procedure TSTC_T3_Frame.UpDownClick(Sender: TObject; Button: TUDBtnType);
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

procedure TSTC_T3_Frame.OptionChange(Sender: TObject);
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

end.
