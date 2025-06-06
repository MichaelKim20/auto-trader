unit TSDISPARITY_N1_Frame;

interface

uses Windows, SysUtils, Classes, WinProcs, Graphics, Forms, Controls, StdCtrls, ExtCtrls, Math,
  ComCtrls, Buttons, MXTradeStrategy, MXTradeStrategyFrame, MXTradeStrategyOptionCollection, ActnList, Menus;

type
  TDISPARITY_N1_Frame = class(TTradeStrategyFrame)
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    EditLENGTH1: TEdit;
    UpDownLENGTH1: TUpDown;
    Panel2: TPanel;
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
    Label1: TLabel;
    EditUP1: TEdit;
    Label2: TLabel;
    EditDN1: TEdit;
    Panel6: TPanel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditLENGTH2: TEdit;
    UpDownLENGTH2: TUpDown;
    EditUP2: TEdit;
    EditDN2: TEdit;
    procedure ComboBoxMajorTypeChange(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure EditChange(Sender: TObject);
    procedure ButtonApplyTSOptionClick(Sender: TObject);
    procedure ButtonOptionManagementClick(Sender: TObject);
    procedure ButtonFavorClick(Sender: TObject);
    procedure ComboBoxOptionCollectionChange(Sender: TObject);
    procedure ButtonPopupMenuClick(Sender: TObject);

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

constructor TDISPARITY_N1_Frame.Create(AOwner: TComponent) ;
begin
    inherited Create(AOwner);
    m_ComboBoxOptionCollection := ComboBoxOptionCollection;
    CMXTradeStrategyOption.Default_DISPARITY_N1(m_Option);
    m_Category := m_Option.GetStringValue('CATEGORY');
    g_StrategyOptionCollection.ExtractOnCategory(m_Category, m_OptionCollection);

    SetControlData;

    InitComboBoxOptionCollection;
end;

procedure TDISPARITY_N1_Frame.MakeDefaultOption(AOption: CMXTradeStrategyOption);
begin
    CMXTradeStrategyOption.Default_DISPARITY_N1(AOption);
end;

//  화면컨트롤에서 데이터를 가져온다.
procedure TDISPARITY_N1_Frame.GetControlData;
begin
    inherited GetControlData;

    if not Assigned(m_Option) then exit;

    m_Option.SetIntegerValue(TSOPTION_KEY_MAJORVALUE, ComboBoxMajorType.ItemIndex);
    m_Option.SetIntegerValue('LENGTH1', UpDownLENGTH1.Position);
    m_Option.SetDoubleValue('UP1', TFNGlobal.atof(EditUP1.Text));
    m_Option.SetDoubleValue('DN1', TFNGlobal.atof(EditDN1.Text));

    m_Option.SetIntegerValue('LENGTH2', UpDownLENGTH2.Position);
    m_Option.SetDoubleValue('UP2', TFNGlobal.atof(EditUP2.Text));
    m_Option.SetDoubleValue('DN2', TFNGlobal.atof(EditDN2.Text));
end;

procedure TDISPARITY_N1_Frame.SetControlData;
begin
    inherited SetControlData;

    if not Assigned(m_Option) then exit;

    m_EnableEvent := false;
    try
        ComboBoxMajorType.ItemIndex := m_Option.GetIntegerValue(TSOPTION_KEY_MAJORVALUE);
        UpDownLENGTH1.Position := m_Option.GetIntegerValue('LENGTH1');
        EditUP1.Text := FloatToStr(m_Option.GetDoubleValue('UP1'));
        EditDN1.Text := FloatToStr(m_Option.GetDoubleValue('DN1'));

        UpDownLENGTH2.Position := m_Option.GetIntegerValue('LENGTH2');
        EditUP2.Text := FloatToStr(m_Option.GetDoubleValue('UP2'));
        EditDN2.Text := FloatToStr(m_Option.GetDoubleValue('DN2'));
    finally
        m_EnableEvent := true;
    end;
end;

procedure TDISPARITY_N1_Frame.ButtonApplyTSOptionClick(Sender: TObject);
begin
    ApplyOptionCollection;
end;

procedure TDISPARITY_N1_Frame.ButtonFavorClick(Sender: TObject);
begin
    AddFavorOptionCollection;
end;


procedure TDISPARITY_N1_Frame.ButtonOptionManagementClick(Sender: TObject);
begin
    ManagementOptionCollection;
end;

procedure TDISPARITY_N1_Frame.ButtonPopupMenuClick(Sender: TObject);
var
    f_PT:TPoint;
begin
    f_PT := ComboBoxOptionCollection.ClientToScreen(Point(0, ComboBoxOptionCollection.Height+2));
    PopupMenuOption.Popup(f_PT.x, f_PT.y);
end;

procedure TDISPARITY_N1_Frame.ComboBoxMajorTypeChange(Sender: TObject);
begin
    if not Assigned(m_Option) then exit;
    if not m_EnableEvent then exit;

    GetControlData;
    UpdateControlData;
    ApplyToOrignal;

    if Assigned(m_ChangedOption) then m_ChangedOption(Self);
end;

procedure TDISPARITY_N1_Frame.ComboBoxOptionCollectionChange(Sender: TObject);
begin
    ApplyOptionCollection;
end;

procedure TDISPARITY_N1_Frame.EditKeyPress(Sender: TObject; var Key: Char);
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

procedure TDISPARITY_N1_Frame.UpdateControlData;
begin
    SetControlData;
end;

procedure TDISPARITY_N1_Frame.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
    if not Assigned(m_Option) then exit;
    if not m_EnableEvent then exit;

    GetControlData;
    UpdateControlData;
    ApplyToOrignal;

    if Assigned(m_ChangedOption) then m_ChangedOption(Self);
end;

procedure TDISPARITY_N1_Frame.EditChange(Sender: TObject);
begin
    if not Assigned(m_Option) then exit;
    if not m_EnableEvent then exit;

    GetControlData;
    //UpdateControlData;
    ApplyToOrignal;

    if Assigned(m_ChangedOption) then m_ChangedOption(Self);
end;

end.





