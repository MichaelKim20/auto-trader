unit COND_Exit_Frame;

interface

uses Windows, SysUtils, Classes, WinProcs, Graphics, Forms, Controls, StdCtrls, ExtCtrls, Math,
  ComCtrls, Buttons, MXTradeStrategy,  MXTradeStrategyOptionCollection, ActnList, Menus,
  MXTradeStrategyFrame;

type
  TExit_Frame = class(TTradeStrategyFrame)
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
    CheckBoxUSE_PROFITCUT: TCheckBox;
    GroupBox2: TGroupBox;
    CheckBoxUSE_TRAILINGSTOP: TCheckBox;
    GroupBox3: TGroupBox;
    CheckBoxUSE_LOSSCUT: TCheckBox;
    Panel1: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EditLOSSCUT_VALUE_1: TEdit;
    EditPROFITCUT_VALUE_1: TEdit;
    EditTRAILINGSTOP_VALUE_1: TEdit;
    EditTRAILINGSTOP_VALUE_2: TEdit;
    Panel5: TPanel;
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
    //  화면컨트롤에서 데이터를 가져온다.
    procedure GetControlData; override;

    //  화면컨트롤에 데이터를 설정한다.
    procedure SetControlData; override;

    //  화면컨트롤의 상태를 업데이터 한다.
    procedure UpdateControlData; override;


  protected
    //  옵션의 기본값을 만든다.
    procedure MakeDefaultOption(AOption : CMXTradeStrategyOption); override;

  public
    constructor Create(AOwner: TComponent) ; override;

  end;

implementation

{$R *.dfm}

uses FNGlobal, MXTSVariable, MXVariable, FNCMVariable, FNPOTCollection, MKTradeStrategyConst;

//-----------------------------------------------------------------------------
constructor TExit_Frame.Create(AOwner: TComponent) ;
var
    f_Index:Integer;
    f_Option : CMXTradeStrategyOption;
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
end;

//-----------------------------------------------------------------------------
//  화면컨트롤에서 데이터를 가져온다.
procedure TExit_Frame.GetControlData;
var
    f_Time:TTime;
begin
    inherited GetControlData;
    if not Assigned(m_Option) then exit;

    m_Option.SetBooleanValue('USE_LOSSCUT'          ,   CheckBoxUSE_LOSSCUT.Checked);
    m_Option.SetBooleanValue('USE_PROFITCUT'        ,   CheckBoxUSE_PROFITCUT.Checked);
    m_Option.SetBooleanValue('USE_TRAILINGSTOP'     ,   CheckBoxUSE_TRAILINGSTOP.Checked);

    m_Option.SetDoubleValue('LOSSCUT_VALUE_1'       ,   -abs(TFNGlobal.atof(EditLOSSCUT_VALUE_1.Text)));
    m_Option.SetDoubleValue('PROFITCUT_VALUE_1'     ,   abs(TFNGlobal.atof(EditPROFITCUT_VALUE_1.Text)));
    m_Option.SetDoubleValue('TRAILINGSTOP_VALUE_1'  ,   abs(TFNGlobal.atof(EditTRAILINGSTOP_VALUE_1.Text)));
    m_Option.SetDoubleValue('TRAILINGSTOP_VALUE_2'  ,   abs(TFNGlobal.atof(EditTRAILINGSTOP_VALUE_2.Text)));
end;

//-----------------------------------------------------------------------------
procedure TExit_Frame.MakeDefaultOption(AOption: CMXTradeStrategyOption);
begin
    AOption.SetStringValue ('CATEGORY'              ,   'CONDITION-EXIT');
    AOption.SetStringValue ('TYPE'                  ,   TSOPTION_VALUE_STAND);
    AOption.SetStringValue ('NAME'                  ,   TSOPTION_VALUE_STAND);

    m_Option.SetBooleanValue('USE_LOSSCUT'          ,   false);
    m_Option.SetBooleanValue('USE_PROFITCUT'        ,   false);
    m_Option.SetBooleanValue('USE_TRAILINGSTOP'     ,   false);

    m_Option.SetDoubleValue('LOSSCUT_VALUE_1'       ,   -0.3);
    m_Option.SetDoubleValue('PROFITCUT_VALUE_1'     ,   1.38);
    m_Option.SetDoubleValue('TRAILINGSTOP_VALUE_1'  ,   0.63);
    m_Option.SetDoubleValue('TRAILINGSTOP_VALUE_2'  ,   15);
end;

//-----------------------------------------------------------------------------
procedure TExit_Frame.N1Click(Sender: TObject);
begin
    ApplyOptionCollection;
end;

//-----------------------------------------------------------------------------
procedure TExit_Frame.N2Click(Sender: TObject);
begin
    AddFavorOptionCollection;
end;

//-----------------------------------------------------------------------------
procedure TExit_Frame.N3Click(Sender: TObject);
begin
    ManagementOptionCollection;
end;

//-----------------------------------------------------------------------------
procedure TExit_Frame.SetControlData;
begin
    inherited SetControlData;

    if not Assigned(m_Option) then exit;

    m_EnableEvent := false;
    try
        CheckBoxUSE_LOSSCUT.Checked         :=  m_Option.GetBooleanValue('USE_LOSSCUT');
        CheckBoxUSE_PROFITCUT.Checked       :=  m_Option.GetBooleanValue('USE_PROFITCUT');
        CheckBoxUSE_TRAILINGSTOP.Checked    :=  m_Option.GetBooleanValue('USE_TRAILINGSTOP');

        EditLOSSCUT_VALUE_1.Text            :=  FloatToStr(abs(m_Option.GetDoubleValue('LOSSCUT_VALUE_1')));
        EditPROFITCUT_VALUE_1.Text          :=  FloatToStr(abs(m_Option.GetDoubleValue('PROFITCUT_VALUE_1')));
        EditTRAILINGSTOP_VALUE_1.Text       :=  FloatToStr(abs(m_Option.GetDoubleValue('TRAILINGSTOP_VALUE_1')));
        EditTRAILINGSTOP_VALUE_2.Text       :=  FloatToStr(abs(m_Option.GetDoubleValue('TRAILINGSTOP_VALUE_2')));
    finally
        m_EnableEvent := true;
    end;
end;

//-----------------------------------------------------------------------------
procedure TExit_Frame.EditKeyPress(Sender: TObject; var Key: Char);
begin
    if Key in ['0'..'9', '-', #8, #9, #32, #3, #22, #$2E] then
    begin
    end else
    begin
        Key := #0;
    end;
end;

//-----------------------------------------------------------------------------
procedure TExit_Frame.UpdateControlData;
begin
    SetControlData;
end;

//-----------------------------------------------------------------------------
procedure TExit_Frame.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
    if not Assigned(m_Option) then exit;
    if not m_EnableEvent then exit;

    GetControlData;
    UpdateControlData;
    ApplyToOrignal;

    if Assigned(m_ChangedOption) then m_ChangedOption(Self);
end;

//-----------------------------------------------------------------------------
procedure TExit_Frame.EditChange(Sender: TObject);
begin
    if not Assigned(m_Option) then exit;
    if not m_EnableEvent then exit;

    GetControlData;
    //UpdateControlData;
    ApplyToOrignal;

    if Assigned(m_ChangedOption) then m_ChangedOption(Self);
end;

//-----------------------------------------------------------------------------
procedure TExit_Frame.OptionChange(Sender: TObject);
begin
    if not Assigned(m_Option) then exit;
    if not m_EnableEvent then exit;

    GetControlData;
    UpdateControlData;
    ApplyToOrignal;

    if Assigned(m_ChangedOption) then m_ChangedOption(Self);
end;

//-----------------------------------------------------------------------------
procedure TExit_Frame.ButtonPopupMenuClick(Sender: TObject);
var
    f_PT:TPoint;
begin
    f_PT := ComboBoxOptionCollection.ClientToScreen(Point(0, ComboBoxOptionCollection.Height+2));
    PopupMenuOption.Popup(f_PT.x, f_PT.y);
end;

//-----------------------------------------------------------------------------
procedure TExit_Frame.ComboBoxOptionCollectionChange(Sender: TObject);
begin
    ApplyOptionCollection;
end;

//-----------------------------------------------------------------------------
end.





