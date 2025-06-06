unit COND_Random_Frame;

interface

uses Windows, SysUtils, Classes, WinProcs, Graphics, Forms, Controls, StdCtrls,
  ExtCtrls, Math,
  ComCtrls, Buttons, MXTradeStrategy, MXTradeStrategyOptionCollection, ActnList,
  Menus,
  MXTradeStrategyFrame;

type
  TRandom_Frame = class(TTradeStrategyFrame)
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
    CheckBoxUSE_RANDOM_TRADE: TCheckBox;
    RadioButtonRANDOM_CASE1: TRadioButton;
    RadioButtonRANDOM_CASE2: TRadioButton;
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

  protected
    // 외부에서 옵션객체를 설정한다.
    procedure AssignOption(AOption: CMXTradeStrategyOption); override;
    // 옵션의 기본값을 만든다.
    procedure MakeDefaultOption(AOption: CMXTradeStrategyOption); override;

    procedure ApplyLanguage;

  public
    constructor Create(AOwner: TComponent); override;

  end;

implementation

{$R *.dfm}

uses FNGlobal, MXTSVariable, MXVariable, FNCMVariable, FNPOTCollection,
  MKTradeStrategyConst;

procedure TRandom_Frame.ApplyLanguage;
begin
  if (g_Language = 0) then
  begin
    Panel4.Caption := '랜덤';
    GroupBoxOptionManagement.Caption := '저장과 적용';
    GroupBox1.Caption := '랜덤';
    CheckBoxUSE_RANDOM_TRADE.Caption := '사용여부';
    RadioButtonRANDOM_CASE1.Caption := '진입확률 1/2 이상';
    RadioButtonRANDOM_CASE2.Caption := '진입확률 2/3 이상';
  end
  else
  begin
    Panel4.Caption := 'Random';
    GroupBoxOptionManagement.Caption := 'Save && Apply';
    GroupBox1.Caption := 'Random';
    CheckBoxUSE_RANDOM_TRADE.Caption := 'Use';
    RadioButtonRANDOM_CASE1.Caption := 'Entry chance over 1/2';
    RadioButtonRANDOM_CASE2.Caption := 'Entry chance over 2/3';

  end;
end;

// -----------------------------------------------------------------------------
constructor TRandom_Frame.Create(AOwner: TComponent);
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
procedure TRandom_Frame.AssignOption(AOption: CMXTradeStrategyOption);
begin
  m_Option.CopyValue(AOption);
  m_OriginalOption := AOption;

  SetControlData;

  if Assigned(m_ReinforceFrame) then
  begin
    m_ReinforceFrame.Option := AOption;
  end;
end;

// -----------------------------------------------------------------------------
// 화면컨트롤에서 데이터를 가져온다.
procedure TRandom_Frame.GetControlData;
var
  f_Time: TTime;
begin
  inherited GetControlData;

  if not Assigned(m_Option) then
    exit;

  m_Option.SetBooleanValue('USE_RANDOM_TRADE', CheckBoxUSE_RANDOM_TRADE.Checked);
  if RadioButtonRANDOM_CASE1.Checked then
  begin
    m_Option.SetIntegerValue('RANDOM_CASE', 0);
  end
  else
  begin
    m_Option.SetIntegerValue('RANDOM_CASE', 1);
  end;
end;

// -----------------------------------------------------------------------------
procedure TRandom_Frame.MakeDefaultOption(AOption: CMXTradeStrategyOption);
begin
  AOption.SetStringValue('CATEGORY', 'CONDITION-RANDOM');
  AOption.SetStringValue('TYPE', TSOPTION_VALUE_STAND);
  AOption.SetStringValue('NAME', TSOPTION_VALUE_STAND);

  AOption.SetBooleanValue('USE_RANDOM_TRADE', false);
  AOption.SetIntegerValue('RANDOM_CASE', 0);
end;

// -----------------------------------------------------------------------------
procedure TRandom_Frame.N1Click(Sender: TObject);
begin
  ApplyOptionCollection;
end;

// -----------------------------------------------------------------------------
procedure TRandom_Frame.N2Click(Sender: TObject);
begin
  AddFavorOptionCollection;
end;

// -----------------------------------------------------------------------------
procedure TRandom_Frame.N3Click(Sender: TObject);
begin
  ManagementOptionCollection;
end;

// -----------------------------------------------------------------------------
procedure TRandom_Frame.SetControlData;
begin
  inherited SetControlData;

  if not Assigned(m_Option) then
    exit;
  m_EnableEvent := false;
  try
    CheckBoxUSE_RANDOM_TRADE.Checked := m_Option.GetBooleanValue('USE_RANDOM_TRADE');
    if m_Option.GetIntegerValue('RANDOM_CASE') = 0 then
    begin
      RadioButtonRANDOM_CASE1.Checked := true;
    end
    else
    begin
      RadioButtonRANDOM_CASE2.Checked := true;
    end;
  finally
    m_EnableEvent := true;
  end;
end;

// -----------------------------------------------------------------------------
procedure TRandom_Frame.EditKeyPress(Sender: TObject; var Key: Char);
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
procedure TRandom_Frame.UpdateControlData;
begin
  SetControlData;
end;

// -----------------------------------------------------------------------------
procedure TRandom_Frame.UpDownClick(Sender: TObject; Button: TUDBtnType);
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
procedure TRandom_Frame.EditChange(Sender: TObject);
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
procedure TRandom_Frame.OptionChange(Sender: TObject);
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
procedure TRandom_Frame.ButtonPopupMenuClick(Sender: TObject);
var
  f_PT: TPoint;
begin
  f_PT := ComboBoxOptionCollection.ClientToScreen(Point(0, ComboBoxOptionCollection.Height + 2));
  PopupMenuOption.Popup(f_PT.x, f_PT.y);
end;

// -----------------------------------------------------------------------------
procedure TRandom_Frame.ComboBoxOptionCollectionChange(Sender: TObject);
begin
  ApplyOptionCollection;
end;

// -----------------------------------------------------------------------------
end.
