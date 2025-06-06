unit TSSTC_N2_Frame;

interface

uses Windows, SysUtils, Classes, WinProcs, Graphics, Forms, Controls, StdCtrls, ExtCtrls, Math,
  ComCtrls, Buttons, MXTradeStrategy, MXTradeStrategyFrame, MXTradeStrategyOptionCollection, ActnList, Menus;

type
  TSTC_N2_Frame = class(TTradeStrategyFrame)
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
    PopupMenuOption: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    GroupBoxOptionManagement: TGroupBox;
    ComboBoxOptionCollection: TComboBox;
    ButtonPopupMenu: TButton;
    Label1: TLabel;
    Label5: TLabel;
    EditDN: TEdit;
    EditUP: TEdit;
    UpDownUP: TUpDown;
    UpDownDN: TUpDown;
    CheckBoxUSE_DEFAULT_EXIT_CONDITON: TCheckBox;
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
    procedure EditChange(Sender: TObject);

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

uses FNGlobal, MXTSVariable, MKTradeStrategyConst;

constructor TSTC_N2_Frame.Create(AOwner: TComponent) ;
begin
    inherited Create(AOwner);
    m_ComboBoxOptionCollection := ComboBoxOptionCollection;
    CMXTradeStrategyOption.Default_STC_N2(m_Option);
    m_Category := m_Option.GetStringValue('CATEGORY');
    g_StrategyOptionCollection.ExtractOnCategory(m_Category, m_OptionCollection);

    SetControlData;

    InitComboBoxOptionCollection;
end;

procedure TSTC_N2_Frame.MakeDefaultOption(AOption: CMXTradeStrategyOption);
begin
    CMXTradeStrategyOption.Default_STC_N2(AOption);
end;

//  화면컨트롤에서 데이터를 가져온다.
procedure TSTC_N2_Frame.GetControlData;
begin
    inherited GetControlData;

    if not Assigned(m_Option) then exit;

    m_Option.SetIntegerValue(TSOPTION_KEY_MAJORVALUE, ComboBoxMajorType.ItemIndex);
    m_Option.SetIntegerValue('LENGTH1', UpDownLENGTH1.Position);
    m_Option.SetIntegerValue('LENGTH2', UpDownLENGTH2.Position);
    m_Option.SetIntegerValue('LENGTH3', UpDownLENGTH3.Position);
    m_Option.SetDoubleValue('UP', UpDownUP.Position);
    m_Option.SetDoubleValue('DN', UpDownDN.Position);

    m_Option.SetBooleanValue('USE_DEFAULT_EXIT_CONDITON' ,    CheckBoxUSE_DEFAULT_EXIT_CONDITON.Checked);

    m_Option.SetBooleanValue('USE_TOLERANCE', CheckBoxUSE_TOLERANCE.Checked);
    m_Option.SetDoubleValue ('TOLERANCE', TFNGlobal.atof(EditTOLERANCE.Text));
    m_Option.SetIntegerValue('TOLERANCE_UNIT', ComboBoxTOLERANCE_UNIT.ItemIndex);

end;

procedure TSTC_N2_Frame.SetControlData;
begin
    inherited SetControlData;

    if not Assigned(m_Option) then exit;

    m_EnableEvent := false;
    try
        ComboBoxMajorType.ItemIndex := m_Option.GetIntegerValue(TSOPTION_KEY_MAJORVALUE);
        UpDownLENGTH1.Position := m_Option.GetIntegerValue('LENGTH1');
        UpDownLENGTH2.Position := m_Option.GetIntegerValue('LENGTH2');
        UpDownLENGTH3.Position := m_Option.GetIntegerValue('LENGTH3');
        UpDownUP.Position := Trunc(m_Option.GetDoubleValue('UP'));
        UpDownDN.Position := Trunc(m_Option.GetDoubleValue('DN'));
        CheckBoxUSE_DEFAULT_EXIT_CONDITON.Checked := m_Option.GetBooleanValue('USE_DEFAULT_EXIT_CONDITON');

        CheckBoxUSE_TOLERANCE.Checked := m_Option.GetBooleanValue('USE_TOLERANCE');
        EditTOLERANCE.Text := TFNGlobal.WriteNumber(m_Option.GetDoubleValue('TOLERANCE'), 3);
        ComboBoxTOLERANCE_UNIT.ItemIndex := m_Option.GetIntegerValue('TOLERANCE_UNIT');
    finally
        m_EnableEvent := true;
    end;
end;

procedure TSTC_N2_Frame.ButtonApplyTSOptionClick(Sender: TObject);
begin
    ApplyOptionCollection;
end;

procedure TSTC_N2_Frame.ButtonFavorClick(Sender: TObject);
begin
    AddFavorOptionCollection;
end;


procedure TSTC_N2_Frame.ButtonOptionManagementClick(Sender: TObject);
begin
    ManagementOptionCollection;
end;

procedure TSTC_N2_Frame.ButtonPopupMenuClick(Sender: TObject);
var
    f_PT:TPoint;
begin
    f_PT := ComboBoxOptionCollection.ClientToScreen(Point(0, ComboBoxOptionCollection.Height+2));
    PopupMenuOption.Popup(f_PT.x, f_PT.y);
end;

procedure TSTC_N2_Frame.ComboBoxMajorTypeChange(Sender: TObject);
begin
    if not Assigned(m_Option) then exit;
    if not m_EnableEvent then exit;

    GetControlData;
    UpdateControlData;
    ApplyToOrignal;

    if Assigned(m_ChangedOption) then m_ChangedOption(Self);
end;

procedure TSTC_N2_Frame.ComboBoxOptionCollectionChange(Sender: TObject);
begin
    ApplyOptionCollection;
end;

procedure TSTC_N2_Frame.EditKeyPress(Sender: TObject; var Key: Char);
begin
    if Key in  [#$D] then
    begin
        EditChange(Sender);
        exit;
    end;

    if Key in ['0'..'9', '-', #8, #9, #32, #3, #22, #$2E] then // 0~9, -, Tab, BS, Space, Ctrl+C, Ctrl+V ?? ???
    begin
    end else
    begin
        Key := #0;
    end;
end;

procedure TSTC_N2_Frame.EditChange(Sender: TObject);
begin
    if not Assigned(m_Option) then exit;
    if not m_EnableEvent then exit;

    GetControlData;
    //UpdateControlData;
    ApplyToOrignal;

    if Assigned(m_ChangedOption) then m_ChangedOption(Self);
end;

procedure TSTC_N2_Frame.UpdateControlData;
begin
    SetControlData;
end;

procedure TSTC_N2_Frame.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
    if not Assigned(m_Option) then exit;
    if not m_EnableEvent then exit;

    GetControlData;
    UpdateControlData;
    ApplyToOrignal;

    if Assigned(m_ChangedOption) then m_ChangedOption(Self);
end;

procedure TSTC_N2_Frame.OptionChange(Sender: TObject);
begin
    if not Assigned(m_Option) then exit;
    if not m_EnableEvent then exit;

    GetControlData;
    UpdateControlData;
    ApplyToOrignal;

    if Assigned(m_ChangedOption) then m_ChangedOption(Self);
end;

end.





