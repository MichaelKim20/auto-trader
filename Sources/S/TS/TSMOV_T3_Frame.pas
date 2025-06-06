unit TSMOV_T3_Frame;

interface

uses Windows, SysUtils, Classes, WinProcs, Graphics, Forms, Controls, StdCtrls,
  ExtCtrls, Math,
  ComCtrls, Buttons, MXTradeStrategy, MXTradeStrategyFrame,
  MXTradeStrategyOptionCollection, ActnList, Menus;

type
  TMOV_T3_Frame = class(TTradeStrategyFrame)
    Panel1: TPanel;
    Panel3: TPanel;
    GroupBoxMajorType: TGroupBox;
    ComboBoxMajorType: TComboBox;
    Panel4: TPanel;
    Panel5: TPanel;
    PopupMenuOption: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    GroupBoxOptionManagement: TGroupBox;
    ComboBoxOptionCollection: TComboBox;
    ButtonPopupMenu: TButton;
    Panel2: TPanel;
    Panel6: TPanel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    EditLENGTH1: TEdit;
    UpDownLENGTH1: TUpDown;
    Panel7: TPanel;
    Label9: TLabel;
    ComboBoxAVERAGE_TYPE: TComboBox;
    Label8: TLabel;
    EditRF2_PRECISION: TEdit;
    UpDownPRECISION: TUpDown;
    procedure ComboBoxMajorTypeChange(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure EditChange(Sender: TObject);
    procedure ButtonApplyTSOptionClick(Sender: TObject);
    procedure ButtonOptionManagementClick(Sender: TObject);
    procedure ButtonFavorClick(Sender: TObject);
    procedure ComboBoxOptionCollectionChange(Sender: TObject);
    procedure ButtonPopupMenuClick(Sender: TObject);
    procedure OptionChange(Sender: TObject);

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

  public
    constructor Create(AOwner: TComponent); override;

  end;

implementation

{$R *.dfm}

uses FNGlobal, MXTSVariable, MKTradeStrategyConst;

constructor TMOV_T3_Frame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_ComboBoxOptionCollection := ComboBoxOptionCollection;
  CMXTradeStrategyOption.Default_MOV_T3_O1(m_Option);
  m_Category := m_Option.GetStringValue(TSOPTION_KEY_CATEGORY);
  g_StrategyOptionCollection.ExtractOnCategory(m_Category, m_OptionCollection);

  SetControlData;

  InitComboBoxOptionCollection;
end;

procedure TMOV_T3_Frame.MakeDefaultOption(AOption: CMXTradeStrategyOption);
begin
  CMXTradeStrategyOption.Default_MOV_T3_O1(AOption);
end;

// 화면컨트롤에서 데이터를 가져온다.
procedure TMOV_T3_Frame.GetControlData;
begin
  inherited GetControlData;

  if not Assigned(m_Option) then
    exit;

  m_Option.SetIntegerValue(TSOPTION_KEY_MAJORVALUE, ComboBoxMajorType.ItemIndex);
  m_Option.SetIntegerValue('LENGTH1', UpDownLENGTH1.Position);
  m_Option.SetIntegerValue('PRECISION', UpDownPRECISION.Position);
  m_Option.SetIntegerValue('AVERAGE_TYPE', ComboBoxAVERAGE_TYPE.ItemIndex);
end;

procedure TMOV_T3_Frame.SetControlData;
var
  f_NValue: Integer;
begin
  inherited SetControlData;

  if not Assigned(m_Option) then
    exit;
  m_EnableEvent := false;
  try
    ComboBoxMajorType.ItemIndex := m_Option.GetIntegerValue(TSOPTION_KEY_MAJORVALUE);
    UpDownLENGTH1.Position := m_Option.GetIntegerValue('LENGTH1');
    UpDownPRECISION.Position := m_Option.GetIntegerValue('PRECISION');
    ComboBoxAVERAGE_TYPE.ItemIndex := m_Option.GetIntegerValue('AVERAGE_TYPE');
  finally
    m_EnableEvent := true;
  end;
end;

procedure TMOV_T3_Frame.ButtonApplyTSOptionClick(Sender: TObject);
begin
  ApplyOptionCollection;
end;

procedure TMOV_T3_Frame.ButtonFavorClick(Sender: TObject);
begin
  AddFavorOptionCollection;
end;

procedure TMOV_T3_Frame.ButtonOptionManagementClick(Sender: TObject);
begin
  ManagementOptionCollection;
end;

procedure TMOV_T3_Frame.ButtonPopupMenuClick(Sender: TObject);
var
  f_PT: TPoint;
begin
  f_PT := ComboBoxOptionCollection.ClientToScreen(Point(0, ComboBoxOptionCollection.Height + 2));
  PopupMenuOption.Popup(f_PT.x, f_PT.y);
end;

procedure TMOV_T3_Frame.ComboBoxMajorTypeChange(Sender: TObject);
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

procedure TMOV_T3_Frame.ComboBoxOptionCollectionChange(Sender: TObject);
begin
  ApplyOptionCollection;
end;

procedure TMOV_T3_Frame.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in [#$D] then
  begin
    EditChange(Sender);
    exit;
  end;

  if Key in ['0' .. '9', '-', #8, #9, #32, #3, #22, #$2E] then
  // 0~9, -, Tab, BS, Space, Ctrl+C, Ctrl+V ?? ???
  begin
  end
  else
  begin
    Key := #0;
  end;
end;

procedure TMOV_T3_Frame.UpdateControlData;
begin
  SetControlData;
end;

procedure TMOV_T3_Frame.UpDownClick(Sender: TObject; Button: TUDBtnType);
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

procedure TMOV_T3_Frame.EditChange(Sender: TObject);
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

procedure TMOV_T3_Frame.OptionChange(Sender: TObject);
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

end.
