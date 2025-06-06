unit TSSaveOptionDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, Dialogs, MXTradeStrategyOptionCollection, ImgList,
  ActnList, System.Actions;

type
  TSaveOptionDlg = class(TForm)
    CancelBtn: TButton;
    ListViewOption: TListView;
    EditOptionName: TEdit;
    Label1: TLabel;
    ImageList1: TImageList;
    ActionList1: TActionList;
    ActionSaveAs: TAction;
    ActionDelete: TAction;
    ActionSave: TAction;
    ImageList2: TImageList;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure ListViewOptionData(Sender: TObject; Item: TListItem);
    procedure ListViewOptionSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ActionSaveAsUpdate(Sender: TObject);
    procedure ActionDeleteUpdate(Sender: TObject);
    procedure ActionSaveUpdate(Sender: TObject);
    procedure ActionSaveAsExecute(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);

  private
    m_Option: CMXTradeStrategyOption;
    m_OptionCollection: CMXTradeStrategyOptionCollection;
    m_SelectedOption: CMXTradeStrategyOption;

    procedure SetOption(AOption: CMXTradeStrategyOption);
    function GetOption: CMXTradeStrategyOption;

    procedure SetOptionCollection(AOptionCollection: CMXTradeStrategyOptionCollection);
    procedure ResetListViewOption;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Option: CMXTradeStrategyOption read GetOption write SetOption;
    property OptionCollection: CMXTradeStrategyOptionCollection read m_OptionCollection write SetOptionCollection;
  end;

var
  SaveOptionDlg: TSaveOptionDlg;

implementation

{$R *.dfm}

uses MXTSVariable, MKTradeStrategyConst;

// ---------------------------------------------------------------------------------------------------------------------
procedure TSaveOptionDlg.ActionDeleteExecute(Sender: TObject);
var
  f_SearchIndex: Integer;
begin
  f_SearchIndex := m_OptionCollection.m_Items.IndexOf(m_SelectedOption);
  if (f_SearchIndex >= 0) then
    m_OptionCollection.m_Items.Delete(f_SearchIndex);

  f_SearchIndex := g_StrategyOptionCollection.m_Items.IndexOf(m_SelectedOption);
  if (f_SearchIndex >= 0) then
    g_StrategyOptionCollection.m_Items.Delete(f_SearchIndex);
  (*
    f_SearchIndex := m_OptionCollection.Search(m_SelectedOption.GetStringValue(TSOPTION_KEY_CATEGORY), m_SelectedOption.GetStringValue(TSOPTION_KEY_NAME));
    if (f_SearchIndex >= 0) then m_OptionCollection.m_Items.Delete(f_SearchIndex);

    f_SearchIndex := g_StrategyOptionCollection.Search(m_SelectedOption.GetStringValue(TSOPTION_KEY_CATEGORY), m_SelectedOption.GetStringValue(TSOPTION_KEY_NAME));
    if (f_SearchIndex >= 0) then g_StrategyOptionCollection.m_Items.Delete(f_SearchIndex);
  *)
  m_SelectedOption.Free;
  m_SelectedOption := NIL;

  ResetListViewOption;
end;

// ---------------------------------------------------------------------------------------------------------------------
procedure TSaveOptionDlg.ActionDeleteUpdate(Sender: TObject);
begin
  if Assigned(m_SelectedOption) then
  begin
    // ActionDelete.Enabled := true;

    if (CompareText(m_SelectedOption.GetStringValue(TSOPTION_KEY_TYPE), TSOPTION_VALUE_STAND) = 0) or
        (CompareText(m_SelectedOption.GetStringValue(TSOPTION_KEY_TYPE), TSOPTION_VALUE_FAVORITE) = 0) then
    begin
      ActionDelete.Enabled := false;
    end
    else
    begin
      ActionDelete.Enabled := true;
    end;

  end
  else
  begin
    ActionDelete.Enabled := false;
  end;
end;

// ---------------------------------------------------------------------------------------------------------------------
procedure TSaveOptionDlg.ActionSaveAsExecute(Sender: TObject);
var
  f_Exist: Boolean;
  f_Option: CMXTradeStrategyOption;
  f_SearchIndex: Integer;
begin
  if EditOptionName.Text = '' then
  begin
    ShowMessage('저장할 조건의 이름을 입력해 주세요.');
    exit;
  end
  else if (EditOptionName.Text <> TSOPTION_VALUE_STAND) and (EditOptionName.Text <> TSOPTION_VALUE_FAVORITE) then
  begin
    m_OptionCollection.Sort();
    f_SearchIndex := m_OptionCollection.Search(m_Option.GetStringValue(TSOPTION_KEY_CATEGORY), EditOptionName.Text);
    if (f_SearchIndex >= 0) then
    begin
      f_Option := m_OptionCollection.m_Items[f_SearchIndex];
      f_Exist := true;
    end
    else
    begin
      f_Option := CMXTradeStrategyOption.Create;
      f_Exist := false;
    end;
    f_Option.Clone(m_SelectedOption);
    f_Option.SetStringValue(TSOPTION_KEY_TYPE, '');
    f_Option.SetStringValue(TSOPTION_KEY_NAME, EditOptionName.Text);

    if not f_Exist then
    begin
      m_OptionCollection.Add(f_Option);
      m_OptionCollection.Sort();

      g_StrategyOptionCollection.Add(f_Option);
      g_StrategyOptionCollection.Sort;

      ResetListViewOption;
    end;
  end;
end;

// ---------------------------------------------------------------------------------------------------------------------
procedure TSaveOptionDlg.ActionSaveAsUpdate(Sender: TObject);
begin
  if Assigned(m_SelectedOption) then
  begin
    ActionSaveAs.Enabled := true;
  end
  else
  begin
    ActionSaveAs.Enabled := false;
  end;
end;

// ---------------------------------------------------------------------------------------------------------------------
procedure TSaveOptionDlg.ActionSaveExecute(Sender: TObject);
var
  f_Option: CMXTradeStrategyOption;
  f_SearchIndex: Integer;
  f_Exist: Boolean;
begin
  if EditOptionName.Text = '' then
  begin
    ShowMessage('저장할 조건의 이름을 입력해 주세요.');
    exit;
  end
  else if (EditOptionName.Text <> TSOPTION_VALUE_STAND) and (EditOptionName.Text <> TSOPTION_VALUE_FAVORITE) then
  begin
    m_OptionCollection.Sort();
    f_SearchIndex := m_OptionCollection.Search(m_Option.GetStringValue(TSOPTION_KEY_CATEGORY), EditOptionName.Text);
    if (f_SearchIndex >= 0) then
    begin
      f_Option := m_OptionCollection.m_Items[f_SearchIndex];
      f_Exist := true;
    end
    else
    begin
      f_Option := CMXTradeStrategyOption.Create;
      f_Exist := false;
    end;
    f_Option.Clone(m_Option);
    f_Option.SetStringValue(TSOPTION_KEY_TYPE, '');
    f_Option.SetStringValue(TSOPTION_KEY_NAME, EditOptionName.Text);

    if not f_Exist then
    begin
      m_OptionCollection.Add(f_Option);
      m_OptionCollection.Sort();

      g_StrategyOptionCollection.Add(f_Option);
      g_StrategyOptionCollection.Sort;

      ResetListViewOption;
    end;
  end;
end;

// ---------------------------------------------------------------------------------------------------------------------
procedure TSaveOptionDlg.ActionSaveUpdate(Sender: TObject);
begin
  if Assigned(m_Option) then
  begin
    ActionSave.Enabled := true;
  end
  else
  begin
    ActionSave.Enabled := false;
  end;
end;

// ---------------------------------------------------------------------------------------------------------------------
constructor TSaveOptionDlg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_Option := CMXTradeStrategyOption.Create;
end;

// ---------------------------------------------------------------------------------------------------------------------
destructor TSaveOptionDlg.Destroy;
begin
  if Assigned(m_Option) then
  begin
    m_Option.Free;
    m_Option := NIL;
  end;

  inherited;
end;

// ---------------------------------------------------------------------------------------------------------------------
procedure TSaveOptionDlg.SetOption(AOption: CMXTradeStrategyOption);
begin
  m_Option.ClearAll;
  m_Option.Clone(AOption);
end;

// ---------------------------------------------------------------------------------------------------------------------
function TSaveOptionDlg.GetOption: CMXTradeStrategyOption;
begin
  result := m_Option;
end;

// ---------------------------------------------------------------------------------------------------------------------
procedure TSaveOptionDlg.ListViewOptionData(Sender: TObject; Item: TListItem);
var
  f_Name: String;
  f_Type: String;
  f_Option: CMXTradeStrategyOption;
begin
  if ((Item.Index < 0) or (Item.Index >= m_OptionCollection.m_Items.Count)) then
    exit;
  try
    f_Option := m_OptionCollection.m_Items[Item.Index];
    f_Name := f_Option.GetStringValue(TSOPTION_KEY_NAME);
    f_Type := f_Option.GetStringValue(TSOPTION_KEY_TYPE);

    Item.Caption := f_Name;

    if CompareText(f_Type, TSOPTION_VALUE_STAND) = 0 then
    begin
      Item.ImageIndex := 0;
    end
    else if CompareText(f_Type, TSOPTION_VALUE_FAVORITE) = 0 then
    begin
      Item.ImageIndex := 1;
    end
    else
    begin
      Item.ImageIndex := 2;
    end;

    Item.Data := f_Option;
  except
  end;
end;

// ---------------------------------------------------------------------------------------------------------------------
procedure TSaveOptionDlg.ListViewOptionSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  f_Name: String;
  f_Type: String;
begin
  if Selected then
  begin
    m_SelectedOption := Item.Data;
    f_Name := m_SelectedOption.GetStringValue(TSOPTION_KEY_NAME);
    f_Type := m_SelectedOption.GetStringValue(TSOPTION_KEY_TYPE);
    if (f_Type <> TSOPTION_VALUE_STAND) and (f_Type <> TSOPTION_VALUE_FAVORITE) then
    begin
      EditOptionName.Text := f_Name;
    end
    else
    begin
      EditOptionName.Text := '';
    end;
  end
  else
  begin
    m_SelectedOption := NIL;
  end;
end;

// ---------------------------------------------------------------------------------------------------------------------
procedure TSaveOptionDlg.SetOptionCollection(AOptionCollection: CMXTradeStrategyOptionCollection);
begin
  m_OptionCollection := AOptionCollection;

  ResetListViewOption;
end;

// ---------------------------------------------------------------------------------------------------------------------
procedure TSaveOptionDlg.ResetListViewOption;
begin
  ListViewOption.Items.Count := 0;
  ListViewOption.Items.Count := m_OptionCollection.m_Items.Count;

  ListViewOption.Refresh;
end;

end.
