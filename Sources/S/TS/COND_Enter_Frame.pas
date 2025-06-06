unit COND_Enter_Frame;

interface

uses Windows, SysUtils, Classes, WinProcs, Graphics, Forms, Controls, StdCtrls,
  ExtCtrls, Math,
  ComCtrls, Buttons, MXTradeStrategy, MXTradeStrategyOptionCollection, ActnList,
  Menus,
  MXTradeStrategyFrame;

type
  TENTER_Frame = class(TTradeStrategyFrame)
    Panel9: TPanel;
    GroupBox1: TGroupBox;
    GroupBoxOptionManagement: TGroupBox;
    ComboBoxOptionCollection: TComboBox;
    ButtonPopupMenu: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    PopupMenuOption: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    CheckBoxUseMaxEnterCount: TCheckBox;
    EditMaxEnterCount: TEdit;
    UpDownMaxEnterCount: TUpDown;
    Label1: TLabel;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    CheckBoxUseEnterDelay: TCheckBox;
    EditDelayCount: TEdit;
    UpDownDelayCount: TUpDown;
    Panel4: TPanel;
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure EditChange(Sender: TObject);
    procedure OptionChange(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure ButtonPopupMenuClick(Sender: TObject);
    procedure ComboBoxOptionCollectionChange(Sender: TObject);

  private
    // 화면컨트롤에서 데이터를 가져온다.
    procedure GetControlData; override;

    // 화면컨트롤에 데이터를 설정한다.
    procedure SetControlData; override;

    // 화면컨트롤의 상태를 업데이터 한다.
    procedure UpdateControlData; override;

    procedure ApplyLanguage;

  protected
    // 외부에서 옵션객체를 설정한다.
    procedure AssignOption(AOption: CMXTradeStrategyOption); override;
    // 옵션의 기본값을 만든다.
    procedure MakeDefaultOption(AOption: CMXTradeStrategyOption); override;

  public
    constructor Create(AOwner: TComponent); override;

  end;

implementation

{$R *.dfm}

uses FNGlobal, MXTSVariable, MXVariable, FNCMVariable, FNPOTCollection,
  MKTradeStrategyConst;

procedure TENTER_Frame.ApplyLanguage;
begin
  if (g_Language = 0) then
  begin
    Panel4.Caption := '재진입';
    GroupBoxOptionManagement.Caption := '저장과 적용';
    GroupBox2.Caption := '재진입 필터';
    CheckBoxUseEnterDelay.Caption := '사용여부';

    Label3.Caption := '청산 후 ';
    Label5.Caption := '바 이내에 ';
    Label6.Caption := '재진입 금지';

    GroupBox1.Caption := '1일 진입 최대 횟수';
    CheckBoxUseMaxEnterCount.Caption := '사용여부';
    Label1.Caption := '회';
  end
  else
  begin
    Panel4.Caption := 'Re-entry';
    GroupBoxOptionManagement.Caption := 'Save && Apply';
    GroupBox2.Caption := 'Re-entry filter';
    CheckBoxUseEnterDelay.Caption := 'Use';

    Label3.Caption := ' ';
    Label5.Caption := 'no re-entry before xx bars after exit';
    Label6.Caption := ' ';

    GroupBox1.Caption := 'Max entry per day';
    CheckBoxUseMaxEnterCount.Caption := 'Use';
    Label1.Caption := '';
  end;
end;

// -----------------------------------------------------------------------------
constructor TENTER_Frame.Create(AOwner: TComponent);
var
  f_Index: Integer;
  f_Option: CMXTradeStrategyOption;
begin
  inherited Create(AOwner);
  m_ComboBoxOptionCollection := ComboBoxOptionCollection;

  MakeDefaultOption(m_Option);
  m_Category := m_Option.GetStringValue(TSOPTION_KEY_CATEGORY);

  g_StrategyOptionCollection.ExtractOnCategory(m_Category, m_OptionCollection);

  if (m_OptionCollection.m_Items.Count = 0) then
  begin
    f_Option := CMXTradeStrategyOption.Create;
    f_Option.Clone(m_Option);
    f_Option.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

    m_OptionCollection.Add(f_Option);
    m_OptionCollection.Sort;

    g_StrategyOptionCollection.Add(f_Option);
    g_StrategyOptionCollection.Sort;
  end;

  if m_OptionCollection.Search(m_Category, TSOPTION_VALUE_STAND) < 0 then
  begin
    f_Option := CMXTradeStrategyOption.Create;
    f_Option.Clone(m_Option);
    f_Option.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

    m_OptionCollection.Add(f_Option);
    m_OptionCollection.Sort;

    g_StrategyOptionCollection.Add(f_Option);
    g_StrategyOptionCollection.Sort;
  end;

  f_Index := m_OptionCollection.Search(m_Category, TSOPTION_VALUE_STAND);
  if f_Index >= 0 then
  begin
    f_Option := m_OptionCollection.m_Items[f_Index];
    m_Option.Clone(f_Option);
  end;

  SetControlData;

  InitComboBoxOptionCollection;

  ApplyLanguage;
end;

// -----------------------------------------------------------------------------
// 외부에서 옵션객체를 설정한다.
procedure TENTER_Frame.AssignOption(AOption: CMXTradeStrategyOption);
begin
  m_Option.CopyValue(AOption);
  m_OriginalOption := AOption;

  SetControlData;

  if Assigned(m_ReinforceFrame) then
  begin
    m_ReinforceFrame.Option := AOption;
  end;
end;

// 화면컨트롤에서 데이터를 가져온다.
// -----------------------------------------------------------------------------
procedure TENTER_Frame.GetControlData;
var
  f_Time: TTime;
begin
  inherited GetControlData;
  if not Assigned(m_Option) then
    exit;

  m_Option.SetBooleanValue('USE_ENTER_DELAY', CheckBoxUseEnterDelay.Checked);
  m_Option.SetIntegerValue('DELAY_COUNT', UpDownDelayCount.Position);

  m_Option.SetBooleanValue('USE_MAX_ENTER_COUNT', CheckBoxUseMaxEnterCount.Checked);
  m_Option.SetIntegerValue('MAX_ENTER_COUNT', UpDownMaxEnterCount.Position);
end;

// -----------------------------------------------------------------------------
procedure TENTER_Frame.MakeDefaultOption(AOption: CMXTradeStrategyOption);
begin
  AOption.SetStringValue('CATEGORY', 'CONDITION-ENTER');
  AOption.SetStringValue('TYPE', TSOPTION_VALUE_STAND);
  AOption.SetStringValue('NAME', TSOPTION_VALUE_STAND);

  m_Option.SetBooleanValue('USE_ENTER_DELAY', false);
  m_Option.SetIntegerValue('DELAY_COUNT', 5);

  m_Option.SetBooleanValue('USE_MAX_ENTER_COUNT', false);
  m_Option.SetIntegerValue('MAX_ENTER_COUNT', 5);
end;

// -----------------------------------------------------------------------------
procedure TENTER_Frame.N1Click(Sender: TObject);
begin
  ApplyOptionCollection;
end;

// -----------------------------------------------------------------------------
procedure TENTER_Frame.N2Click(Sender: TObject);
begin
  AddFavorOptionCollection;
end;

// -----------------------------------------------------------------------------
procedure TENTER_Frame.N3Click(Sender: TObject);
begin
  ManagementOptionCollection;
end;

// -----------------------------------------------------------------------------
procedure TENTER_Frame.SetControlData;
begin
  inherited SetControlData;

  if not Assigned(m_Option) then
    exit;

  m_EnableEvent := false;
  try
    CheckBoxUseEnterDelay.Checked := m_Option.GetBooleanValue('USE_ENTER_DELAY');
    UpDownDelayCount.Position := m_Option.GetIntegerValue('DELAY_COUNT');

    CheckBoxUseMaxEnterCount.Checked := m_Option.GetBooleanValue('USE_MAX_ENTER_COUNT');
    UpDownMaxEnterCount.Position := m_Option.GetIntegerValue('MAX_ENTER_COUNT');
  finally
    m_EnableEvent := true;
  end;
end;

// -----------------------------------------------------------------------------
procedure TENTER_Frame.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['0' .. '9', '-', #8, #9, #32, #3, #22, #$2E] then
  begin
  end
  else
  begin
    Key := #0;
  end;
end;

// -----------------------------------------------------------------------------
procedure TENTER_Frame.UpdateControlData;
begin
  SetControlData;
end;

// -----------------------------------------------------------------------------
procedure TENTER_Frame.UpDownClick(Sender: TObject; Button: TUDBtnType);
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
procedure TENTER_Frame.EditChange(Sender: TObject);
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
procedure TENTER_Frame.OptionChange(Sender: TObject);
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
procedure TENTER_Frame.ButtonPopupMenuClick(Sender: TObject);
var
  f_PT: TPoint;
begin
  f_PT := ComboBoxOptionCollection.ClientToScreen(Point(0, ComboBoxOptionCollection.Height + 2));
  PopupMenuOption.Popup(f_PT.x, f_PT.y);
end;

// -----------------------------------------------------------------------------
procedure TENTER_Frame.ComboBoxOptionCollectionChange(Sender: TObject);
begin
  ApplyOptionCollection;
end;

// -----------------------------------------------------------------------------
end.
