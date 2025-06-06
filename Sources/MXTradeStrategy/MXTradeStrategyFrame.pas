unit MXTradeStrategyFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  MXTradeStrategyOptionCollection, StdCtrls;

type
  TTradeStrategyFrame = class(TFrame)

  protected
    m_Category: String;
    m_Active: Boolean;
    m_Option: CMXTradeStrategyOption;
    m_ComboBoxOptionCollection: TComboBox;
    m_ChangedOption: TNotifyEvent;
    m_EnableEvent: Boolean;

    m_ReinforceFrame: TTradeStrategyFrame;

    m_OriginalOption: CMXTradeStrategyOption;

    // 사용자가 저장한 옵션을 가지고 있는 컬렉션
    m_OptionCollection: CMXTradeStrategyOptionCollection;

  protected
    // 외부에서 옵션객체를 설정한다.
    procedure AssignOption(AOption: CMXTradeStrategyOption); virtual;
    // 옵션객체를 가져간다.
    function GetOption: CMXTradeStrategyOption; virtual;

    // 활성화 상태를 설정한다.
    procedure SetActive(AValue: Boolean);

    // 활성화 상태가 변경되었을 때.
    procedure OnChangeActivity; virtual;

    // 옵션의 기본값을 만든다.
    procedure MakeDefaultOption(AOption: CMXTradeStrategyOption); virtual;

    // 화면컨트롤에서 데이터를 가져온다.
    procedure GetControlData; virtual;

    // 화면컨트롤에 데이터를 설정한다.
    procedure SetControlData; virtual;

    // 화면컨트롤의 상태를 업데이터 한다.
    procedure UpdateControlData; virtual;

    // 원래설정을 적용한다.
    procedure ApplyToOrignal;

    // 저장된 설정을 사용하기 위한 콤보박스를 초기화 한다.
    procedure InitComboBoxOptionCollection;

    // 선택된 이미 저장된 옵션을 화면과 데이터에 적용한다.
    procedure ApplyOptionCollection;

    // 저장된 옵션들을 관리한다.
    procedure ManagementOptionCollection;

    // 현재 설정을 자주사용에 저장한다.
    procedure AddFavorOptionCollection;

    procedure SetReinforceFrame(AReinforceFrame: TTradeStrategyFrame);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CopyOption(AOption: CMXTradeStrategyOption);
    procedure ExtraceOption(AOption: CMXTradeStrategyOption);

    procedure GetAllControlData;
    procedure SetAllControlData;

  public
    property Option: CMXTradeStrategyOption read GetOption write AssignOption;
    property ReinforceFrame: TTradeStrategyFrame read m_ReinforceFrame write SetReinforceFrame;

  published
    property Active: Boolean read m_Active write SetActive default false;
    property OnChangedOption: TNotifyEvent read m_ChangedOption write m_ChangedOption;

  end;

implementation

{$R *.dfm}

uses MXTSVariable, FNDataSet, TSSaveOptionDlg, MKTradeStrategyConst;

// -----------------------------------------------------------------------------
// 생성자
constructor TTradeStrategyFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_ReinforceFrame := NIL;
  m_Option := CMXTradeStrategyOption.Create;
  m_Active := true;

  m_OptionCollection := CMXTradeStrategyOptionCollection.Create;

  m_OriginalOption := NIL;
  m_Category := '';
  m_EnableEvent := true;
end;

// -----------------------------------------------------------------------------
// 파괴자
destructor TTradeStrategyFrame.Destroy;
begin
  if Assigned(m_Option) then
  begin
    m_Option.Free;
    m_Option := NIL;
  end;
  if Assigned(m_OptionCollection) then
  begin
    m_OptionCollection.Free;
    m_OptionCollection := NIL;
  end;
  inherited;
end;

// -----------------------------------------------------------------------------
// 활성화 상태가 변경되었을 때.
procedure TTradeStrategyFrame.OnChangeActivity;
begin
end;

// -----------------------------------------------------------------------------
// 활성화 상태를 설정한다.
procedure TTradeStrategyFrame.SetActive(AValue: Boolean);
begin
  if (m_Active <> AValue) then
  begin
    m_Active := AValue;
    if m_Active then
    begin
      g_StrategyOptionCollection.ExtractOnCategory(m_Category, m_OptionCollection);
    end;
    OnChangeActivity;
  end;
end;

// -----------------------------------------------------------------------------
// 외부에서 옵션객체를 설정한다.
procedure TTradeStrategyFrame.AssignOption(AOption: CMXTradeStrategyOption);
begin
  m_Option.CopyValue(AOption);
  m_OriginalOption := AOption;
  if Assigned(m_OriginalOption) then
  begin
    m_OriginalOption.ClearAll;
    m_OriginalOption.Clone(m_Option);
  end;
  SetControlData;

  if Assigned(m_ReinforceFrame) then
  begin
    m_ReinforceFrame.Option := AOption;
  end;
end;

// -----------------------------------------------------------------------------
// 옵션객체를 가져간다.
function TTradeStrategyFrame.GetOption: CMXTradeStrategyOption;
begin
  result := m_Option;
end;

// -----------------------------------------------------------------------------
// 화면컨트롤에서 데이터를 가져온다.
procedure TTradeStrategyFrame.GetControlData;
begin
  if Assigned(m_ReinforceFrame) then
  begin
    m_ReinforceFrame.GetControlData;
    if Assigned(m_Option) then
      m_ReinforceFrame.ExtraceOption(m_Option);
  end;
end;

// -----------------------------------------------------------------------------
// 화면컨트롤에 데이터를 설정한다.
procedure TTradeStrategyFrame.SetControlData;
begin
  if Assigned(m_ReinforceFrame) then
  begin
    if Assigned(m_Option) then
      m_ReinforceFrame.Option := m_Option;
  end;
end;

// -----------------------------------------------------------------------------
procedure TTradeStrategyFrame.SetReinforceFrame(AReinforceFrame: TTradeStrategyFrame);
begin
  m_ReinforceFrame := AReinforceFrame;
  if Assigned(m_ReinforceFrame) then
  begin
    if Assigned(m_Option) then
      m_ReinforceFrame.Option := m_Option;
    // m_ReinforceFrame.ExtraceOption(m_Option);
  end;
end;

// -----------------------------------------------------------------------------
// 화면컨트롤의 상태를 업데이터 한다.
procedure TTradeStrategyFrame.UpdateControlData;
begin

end;

// -----------------------------------------------------------------------------
// 원래설정에 적용한다.
procedure TTradeStrategyFrame.ApplyToOrignal;
begin
  if Assigned(m_OriginalOption) then
  begin
    m_OriginalOption.Clone(m_Option);
    m_OriginalOption.SendChangedEvent;
  end;
end;

// -----------------------------------------------------------------------------
// 저장된 설정을 사용하기 위한 콤보박스를 초기화 한다.
procedure TTradeStrategyFrame.InitComboBoxOptionCollection;
var
  f_Index: Integer;
  f_Option: CMXTradeStrategyOption;
begin
  if not Assigned(m_ComboBoxOptionCollection) then
    exit;

  m_EnableEvent := false;
  try
    m_ComboBoxOptionCollection.Clear;

    for f_Index := 0 to m_OptionCollection.m_Items.Count - 1 do
    begin
      f_Option := m_OptionCollection.m_Items[f_Index];
      m_ComboBoxOptionCollection.Items.Add(f_Option.GetStringValue(TSOPTION_KEY_NAME));
    end;

    m_ComboBoxOptionCollection.ItemIndex := 0;
  finally
    m_EnableEvent := true;
  end;
end;

// -----------------------------------------------------------------------------
// 옵션의 기본값을 만든다.
procedure TTradeStrategyFrame.MakeDefaultOption(AOption: CMXTradeStrategyOption);
begin

end;

// -----------------------------------------------------------------------------
// 저장된 옵션들을 관리한다.
procedure TTradeStrategyFrame.ManagementOptionCollection;
begin
  if Assigned(m_ReinforceFrame) then
  begin
    m_ReinforceFrame.ExtraceOption(m_Option);
  end;

  SaveOptionDlg := TSaveOptionDlg.Create(Self);
  SaveOptionDlg.OptionCollection := m_OptionCollection;
  SaveOptionDlg.Option := m_Option;
  SaveOptionDlg.ShowModal;

  InitComboBoxOptionCollection;

  SaveOptionDlg.Free;
  SaveOptionDlg := NIL;
end;

// -----------------------------------------------------------------------------
// 선택된 이미 저장된 옵션을 화면과 데이터에 적용한다.
procedure TTradeStrategyFrame.ApplyOptionCollection;
var
  m_ItemIndex: Integer;
  f_Option: CMXTradeStrategyOption;
begin
  if not Assigned(m_ComboBoxOptionCollection) then
    exit;
  if not Assigned(m_Option) then
    exit;

  m_EnableEvent := false;
  m_ItemIndex := m_ComboBoxOptionCollection.ItemIndex;
  if (m_ItemIndex >= 0) and (m_ItemIndex < m_OptionCollection.m_Items.Count) then
  begin
    f_Option := m_OptionCollection.m_Items[m_ItemIndex];
    m_Option.CopyValue(f_Option);
  end;
  UpdateControlData;
  ApplyToOrignal;

  if Assigned(m_ReinforceFrame) then
  begin
    m_ReinforceFrame.Option := m_Option;
  end;

  if Assigned(m_ChangedOption) then
    m_ChangedOption(Self);
end;

// -----------------------------------------------------------------------------
// 현재 설정을 자주사용에 저장한다.
procedure TTradeStrategyFrame.AddFavorOptionCollection;
var
  m_SearchIndex: Integer;
  f_Option: CMXTradeStrategyOption;
begin
  if Assigned(m_ReinforceFrame) then
  begin
    m_ReinforceFrame.ExtraceOption(m_Option);
  end;

  m_SearchIndex := m_OptionCollection.Search(m_Category, TSOPTION_VALUE_FAVORITE);
  if (m_SearchIndex >= 0) then
  begin
    f_Option := m_OptionCollection.m_Items[m_SearchIndex];
    f_Option.Clone(m_Option);
    f_Option.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_FAVORITE);
    f_Option.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_FAVORITE);
  end
  else
  begin
    f_Option := CMXTradeStrategyOption.Create;
    f_Option.Clone(m_Option);
    f_Option.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_FAVORITE);
    f_Option.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_FAVORITE);

    m_OptionCollection.Add(f_Option);
    m_OptionCollection.Sort;

    g_StrategyOptionCollection.Add(f_Option);
    g_StrategyOptionCollection.Sort;

    InitComboBoxOptionCollection;
  end;

  m_SearchIndex := m_OptionCollection.Search(m_Category, TSOPTION_VALUE_FAVORITE);
  if (m_SearchIndex >= 0) then
  begin
    m_EnableEvent := false;
    try
      m_ComboBoxOptionCollection.ItemIndex := m_SearchIndex;
    finally
      m_EnableEvent := true;
    end;
  end;
end;

// -----------------------------------------------------------------------------
procedure TTradeStrategyFrame.CopyOption(AOption: CMXTradeStrategyOption);
var
  f_Key: String;
  f_Index: Integer;
  f_FieldValue: CFNFieldValue;
begin
  if Assigned(m_ReinforceFrame) then
  begin
    m_ReinforceFrame.ExtraceOption(m_Option);
  end;

  for f_Index := 0 to m_Option.FieldValues.Count - 1 do
  begin
    f_Key := m_Option.FieldValues.Strings[f_Index];
    f_FieldValue := CFNFieldValue(m_Option.FieldValues.Objects[f_Index]);

    if CompareText(f_Key, TSOPTION_KEY_NAME) = 0 then
      continue;
    if CompareText(f_Key, TSOPTION_KEY_TYPE) = 0 then
      continue;
    if CompareText(f_Key, TSOPTION_KEY_CATEGORY) = 0 then
      continue;

    if (RECORD_TYPE_DOUBLE = f_FieldValue.DataType) then
    begin
      AOption.SetDoubleValue(f_Key, m_Option.GetDoubleValue(f_Key));
    end
    else if (RECORD_TYPE_INTEGER = f_FieldValue.DataType) then
    begin
      AOption.SetIntegerValue(f_Key, m_Option.GetIntegerValue(f_Key));
    end
    else
    begin
      AOption.SetStringValue(f_Key, m_Option.GetStringValue(f_Key));
    end;
  end;
end;

// -----------------------------------------------------------------------------
procedure TTradeStrategyFrame.ExtraceOption(AOption: CMXTradeStrategyOption);
var
  f_Key: String;
  f_Index: Integer;
  f_FieldValue: CFNFieldValue;
begin
  if Assigned(m_ReinforceFrame) then
  begin
    m_ReinforceFrame.ExtraceOption(m_Option);
  end;

  for f_Index := 0 to m_Option.FieldValues.Count - 1 do
  begin
    f_Key := m_Option.FieldValues.Strings[f_Index];
    f_FieldValue := CFNFieldValue(m_Option.FieldValues.Objects[f_Index]);

    if (RECORD_TYPE_DOUBLE = f_FieldValue.DataType) then
    begin
      AOption.SetDoubleValue(f_Key, m_Option.GetDoubleValue(f_Key));
    end
    else if (RECORD_TYPE_INTEGER = f_FieldValue.DataType) then
    begin
      AOption.SetIntegerValue(f_Key, m_Option.GetIntegerValue(f_Key));
    end
    else
    begin
      AOption.SetStringValue(f_Key, m_Option.GetStringValue(f_Key));
    end;
  end;
end;

// -----------------------------------------------------------------------------
procedure TTradeStrategyFrame.GetAllControlData;
begin
  GetControlData;
end;

// -----------------------------------------------------------------------------
procedure TTradeStrategyFrame.SetAllControlData;
begin
  if Assigned(m_ReinforceFrame) then
  begin
    m_ReinforceFrame.Option := m_Option;
  end;
  SetControlData;
end;

end.
