unit COND_TradingHour_Frame;

interface

uses Windows, SysUtils, Classes, WinProcs, Graphics, Forms, Controls, StdCtrls,
  ExtCtrls, Math,
  ComCtrls, Buttons, MXTradeStrategy, MXTradeStrategyOptionCollection, ActnList,
  Menus,
  MXTradeStrategyFrame, FNSymbolCollection;

type
  TTradingHour_Frame = class(TTradeStrategyFrame)
    Panel9: TPanel;
    GroupBox5: TGroupBox;
    Label89: TLabel;
    Label90: TLabel;
    DateTimePickerREGULAR_STOP_TIME: TDateTimePicker;
    DateTimePickerREGULAR_START_TIME: TDateTimePicker;
    CheckBoxUSE_REGULAR_MARKET: TCheckBox;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    DateTimePickerSTOP_TIME: TDateTimePicker;
    DateTimePickerSTART_TIME: TDateTimePicker;
    EditSTOP_OFFSET: TEdit;
    UpDownSTOP_OFFSET: TUpDown;
    UpDownSTART_OFFSET: TUpDown;
    EditSTART_OFFSET: TEdit;
    Panel1: TPanel;
    GroupBoxOptionManagement: TGroupBox;
    ComboBoxOptionCollection: TComboBox;
    ButtonPopupMenu: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    PopupMenuOption: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Panel4: TPanel;
    Panel5: TPanel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    CheckBoxUSER_GAB_PROCESS: TCheckBox;
    EditGAB_INSERT_MIN: TEdit;
    UpDownGAB_INSERT_MIN: TUpDown;
    Label2: TLabel;
    Label3: TLabel;
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure EditChange(Sender: TObject);
    procedure OptionChange(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure ButtonPopupMenuClick(Sender: TObject);
    procedure ComboBoxOptionCollectionChange(Sender: TObject);
    procedure CheckBoxUSER_GAB_PROCESSClick(Sender: TObject);
    procedure EditGAB_INSERT_MINChange(Sender: TObject);
    procedure UpDownGAB_INSERT_MINChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: SmallInt; Direction: TUpDownDirection);
    procedure UpDownGAB_INSERT_MINClick(Sender: TObject; Button: TUDBtnType);

  private
    m_SymbolItem: CFNSymbolItem;
    m_ChangedGabOption: TNotifyEvent;

    // 화면컨트롤에서 데이터를 가져온다.
    procedure GetControlData; override;

    // 화면컨트롤에 데이터를 설정한다.
    procedure SetControlData; override;

    // 화면컨트롤의 상태를 업데이터 한다.
    procedure UpdateControlData; override;

    procedure CalculateTradingHour;

    procedure ApplyLanguage;

  protected
    // 옵션의 기본값을 만든다.
    procedure MakeDefaultOption(AOption: CMXTradeStrategyOption); override;

  public
    constructor Create(AOwner: TComponent); override;

    procedure SetSymbolItem(ASymbolItem: CFNSymbolItem);
    property OnChangedGabOption: TNotifyEvent read m_ChangedGabOption write m_ChangedGabOption;

  end;

implementation

{$R *.dfm}

uses FNGlobal, MXTSVariable, MXVariable, FNCMVariable, FNPOTCollection,
  MKTradeStrategyConst;

procedure TTradingHour_Frame.ApplyLanguage;
begin
  if (g_Language = 0) then
  begin
    Panel4.Caption := '거래시간';
    GroupBoxOptionManagement.Caption := '저장과 적용';

    GroupBox1.Caption := '전산장';

    GroupBox5.Caption := '정규장';

    GroupBox2.Caption := '갭처리';

    Label2.Caption := '장시작 후  X분 경과 후';
    Label3.Caption := '장마감 전  Y분 이전';
    Label6.Caption := '시작:';
    Label7.Caption := '마감:';

    CheckBoxUSE_REGULAR_MARKET.Caption := '사용여부';
    Label89.Caption := '시작:';
    Label90.Caption := '마감:';

    CheckBoxUSER_GAB_PROCESS.Caption := '사용여부';
    Label1.Caption := '추가할 시간 (분) :';
  end
  else
  begin
    Panel4.Caption := 'Trading Hour';
    GroupBoxOptionManagement.Caption := 'Save && Apply';

    GroupBox1.Caption := 'Overnight market';

    GroupBox5.Caption := 'Daytime regular market';

    GroupBox2.Caption := 'Gab';

    Label2.Caption := 'X minutes after opening';
    Label3.Caption := 'Y minutes before closing';
    Label6.Caption := 'Start:';
    Label7.Caption := 'End:';

    CheckBoxUSE_REGULAR_MARKET.Caption := 'Use';
    Label89.Caption := 'Start:';
    Label90.Caption := 'End:';

    CheckBoxUSER_GAB_PROCESS.Caption := 'Use';
    Label1.Caption := 'Minutes of addition :';
  end;
end;

// -----------------------------------------------------------------------------
constructor TTradingHour_Frame.Create(AOwner: TComponent);
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
// 화면컨트롤에서 데이터를 가져온다.
procedure TTradingHour_Frame.GetControlData;
var
  f_Time: TTime;
begin
  inherited GetControlData;
  if not Assigned(m_Option) then
    exit;

  m_Option.SetIntegerValue('START_OFFSET', UpDownSTART_OFFSET.Position);
  m_Option.SetIntegerValue('STOP_OFFSET', UpDownSTOP_OFFSET.Position);

  m_Option.SetBooleanValue('USE_REGULAR_MARKET', CheckBoxUSE_REGULAR_MARKET.Checked);

  f_Time := DateTimePickerREGULAR_START_TIME.Time - Math.Floor(DateTimePickerREGULAR_START_TIME.Time);
  m_Option.SetIntegerValue('REGULAR_START_TIME', Trunc(f_Time * 86400000 + 0.5));

  f_Time := DateTimePickerREGULAR_STOP_TIME.Time - Math.Floor(DateTimePickerREGULAR_STOP_TIME.Time);
  m_Option.SetIntegerValue('REGULAR_STOP_TIME', Trunc(f_Time * 86400000 + 0.5));

  m_Option.SetBooleanValue('USER_GAB_PROCESS', CheckBoxUSER_GAB_PROCESS.Checked);
  m_Option.SetIntegerValue('GAB_INSERT_MIN', UpDownGAB_INSERT_MIN.Position);

  CalculateTradingHour;

  DateTimePickerSTART_TIME.Time := m_Option.GetIntegerValue('START_TIME') / 86400000.0;
  DateTimePickerSTOP_TIME.Time := m_Option.GetIntegerValue('STOP_TIME') / 86400000.0;
end;

// -----------------------------------------------------------------------------
procedure TTradingHour_Frame.MakeDefaultOption(AOption: CMXTradeStrategyOption);
begin
  AOption.SetStringValue('CATEGORY', 'CONDITION-TRADINGHOUR');
  AOption.SetStringValue('TYPE', TSOPTION_VALUE_STAND);
  AOption.SetStringValue('NAME', TSOPTION_VALUE_STAND);

  AOption.SetIntegerValue('START_OFFSET', 3);
  AOption.SetIntegerValue('STOP_OFFSET', 2);

{$IFDEF QUARK}
  AOption.SetBooleanValue('USE_REGULAR_MARKET', false);
{$ENDIF}
{$IFNDEF QUARK}
  AOption.SetBooleanValue('USE_REGULAR_MARKET', true);
{$ENDIF}
  AOption.SetIntegerValue('REGULAR_START_TIME', Trunc(EncodeTime(15, 30, 0, 0) * 86400000 + 0.5));
  AOption.SetIntegerValue('REGULAR_STOP_TIME', Trunc(EncodeTime(22, 00, 0, 0) * 86400000 + 0.5));

{$IFDEF QUARK}
  AOption.SetBooleanValue('USER_GAB_PROCESS', true);
{$ENDIF}
{$IFNDEF QUARK}
  AOption.SetBooleanValue('USER_GAB_PROCESS', false);
{$ENDIF}
  AOption.SetIntegerValue('GAB_INSERT_MIN', 180);

  CalculateTradingHour;
end;

// -----------------------------------------------------------------------------
procedure TTradingHour_Frame.N1Click(Sender: TObject);
begin
  ApplyOptionCollection;
end;

// -----------------------------------------------------------------------------
procedure TTradingHour_Frame.N2Click(Sender: TObject);
begin
  AddFavorOptionCollection;
end;

// -----------------------------------------------------------------------------
procedure TTradingHour_Frame.N3Click(Sender: TObject);
begin
  ManagementOptionCollection;
end;

// -----------------------------------------------------------------------------
procedure TTradingHour_Frame.SetControlData;
begin
  inherited SetControlData;

  if not Assigned(m_Option) then
    exit;

  m_EnableEvent := false;
  try
    UpDownSTART_OFFSET.Position := m_Option.GetIntegerValue('START_OFFSET');
    UpDownSTOP_OFFSET.Position := m_Option.GetIntegerValue('STOP_OFFSET');
    CheckBoxUSE_REGULAR_MARKET.Checked := m_Option.GetBooleanValue('USE_REGULAR_MARKET');
    DateTimePickerREGULAR_START_TIME.Time := m_Option.GetIntegerValue('REGULAR_START_TIME') / 86400000.0;
    DateTimePickerREGULAR_STOP_TIME.Time := m_Option.GetIntegerValue('REGULAR_STOP_TIME') / 86400000.0;

    CheckBoxUSER_GAB_PROCESS.Checked := m_Option.GetBooleanValue('USER_GAB_PROCESS');
    UpDownGAB_INSERT_MIN.Position := m_Option.GetIntegerValue('GAB_INSERT_MIN');

    CalculateTradingHour;

    DateTimePickerSTART_TIME.Time := m_Option.GetIntegerValue('START_TIME') / 86400000.0;
    DateTimePickerSTOP_TIME.Time := m_Option.GetIntegerValue('STOP_TIME') / 86400000.0;
  finally
    m_EnableEvent := true;
  end;
end;

procedure TTradingHour_Frame.SetSymbolItem(ASymbolItem: CFNSymbolItem);
begin
  if m_SymbolItem = ASymbolItem then
    exit;

  m_SymbolItem := ASymbolItem;

  CalculateTradingHour;
  UpdateControlData;
  ApplyToOrignal;
  if Assigned(m_ChangedOption) then
    m_ChangedOption(Self);
end;

// -----------------------------------------------------------------------------
procedure TTradingHour_Frame.EditKeyPress(Sender: TObject; var Key: Char);
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

// -----------------------------------------------------------------------------
procedure TTradingHour_Frame.UpdateControlData;
begin
  if m_Option.GetBooleanValue('USE_REGULAR_MARKET') then
  begin
    DateTimePickerREGULAR_START_TIME.Enabled := true;
    DateTimePickerREGULAR_STOP_TIME.Enabled := true;
  end
  else
  begin
    DateTimePickerREGULAR_START_TIME.Enabled := false;
    DateTimePickerREGULAR_STOP_TIME.Enabled := false;
  end;
  SetControlData;
end;

// -----------------------------------------------------------------------------
procedure TTradingHour_Frame.UpDownClick(Sender: TObject; Button: TUDBtnType);
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

procedure TTradingHour_Frame.UpDownGAB_INSERT_MINChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: SmallInt; Direction: TUpDownDirection);
begin

end;

// -----------------------------------------------------------------------------
procedure TTradingHour_Frame.EditChange(Sender: TObject);
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
procedure TTradingHour_Frame.OptionChange(Sender: TObject);
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
procedure TTradingHour_Frame.ButtonPopupMenuClick(Sender: TObject);
var
  f_PT: TPoint;
begin
  f_PT := ComboBoxOptionCollection.ClientToScreen(Point(0, ComboBoxOptionCollection.Height + 2));
  PopupMenuOption.Popup(f_PT.x, f_PT.y);
end;

// -----------------------------------------------------------------------------
procedure TTradingHour_Frame.CalculateTradingHour;
var
  f_Time: TTime;
  f_OpenDateTime: TDateTime;
  f_CloseDateTime: TDateTime;
  f_POTItem: CFNPOTItem;
begin
  f_OpenDateTime := g_DefaultOpenTime;
  f_CloseDateTime := g_DefaultCloseTime;
  if Assigned(g_POTCollection) then
  begin
    f_POTItem := NIL;

    if Assigned(m_SymbolItem) then
    begin
      f_POTItem := g_POTCollection.Find(TFNGlobal.ServerNow, m_SymbolItem.m_Country, m_SymbolItem.m_Group, m_SymbolItem.m_Market, m_SymbolItem.m_Symbol);
    end;

    if not Assigned(f_POTItem) then
    begin
      f_POTItem := g_POTCollection.Find(TFNGlobal.ServerNow, g_DefaultCountry, g_DefaultGroup, g_DefaultMarket, g_DefaultSymbol);
    end;

    if Assigned(f_POTItem) then
    begin
      f_OpenDateTime := EncodeTime(f_POTItem.NumberToHour(f_POTItem.m_Open[0]), f_POTItem.NumberToMin(f_POTItem.m_Open[0]), 0, 0);
      f_CloseDateTime := EncodeTime(f_POTItem.NumberToHour(f_POTItem.m_Close[f_POTItem.m_HourCount - 1]), f_POTItem.NumberToMin(f_POTItem.m_Close[f_POTItem.m_HourCount - 1]), 0, 0);
    end;
  end;

  f_Time := f_OpenDateTime + m_Option.GetIntegerValue('START_OFFSET') / 1440.0;
  Option.SetIntegerValue('START_TIME', Trunc(f_Time * 86400000 + 0.5));

  f_Time := f_CloseDateTime - m_Option.GetIntegerValue('STOP_OFFSET') / 1440.0;
  Option.SetIntegerValue('STOP_TIME', Trunc(f_Time * 86400000 + 0.5));
end;

procedure TTradingHour_Frame.CheckBoxUSER_GAB_PROCESSClick(Sender: TObject);
begin
  if not Assigned(m_Option) then
    exit;
  if not m_EnableEvent then
    exit;

  GetControlData;
  UpdateControlData;
  ApplyToOrignal;

  if Assigned(m_ChangedGabOption) then
    m_ChangedGabOption(Self);
end;

procedure TTradingHour_Frame.EditGAB_INSERT_MINChange(Sender: TObject);
begin
  if not Assigned(m_Option) then
    exit;
  if not m_EnableEvent then
    exit;

  GetControlData;
  // UpdateControlData;
  ApplyToOrignal;

  if Assigned(m_ChangedGabOption) then
    m_ChangedGabOption(Self);
end;

procedure TTradingHour_Frame.UpDownGAB_INSERT_MINClick(Sender: TObject; Button: TUDBtnType);
begin
  if not Assigned(m_Option) then
    exit;
  if not m_EnableEvent then
    exit;

  GetControlData;
  UpdateControlData;
  ApplyToOrignal;

  if Assigned(m_ChangedGabOption) then
    m_ChangedGabOption(Self);

end;

// -----------------------------------------------------------------------------
procedure TTradingHour_Frame.ComboBoxOptionCollectionChange(Sender: TObject);
begin
  ApplyOptionCollection;
end;

// -----------------------------------------------------------------------------
end.
