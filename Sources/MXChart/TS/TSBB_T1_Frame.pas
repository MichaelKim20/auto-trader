unit TSBB_T1_Frame;

interface

uses Windows, SysUtils, Classes, WinProcs, Graphics, Forms, Controls, StdCtrls, ExtCtrls, Math,
  ComCtrls, Buttons, MXTradeStrategy, MXTradeStrategyFrame, MXTradeStrategyOptionCollection, ActnList, Menus;

type
  TBB_T1_Frame = class(TTradeStrategyFrame)
    Panel1: TPanel;
    GroupBoxOptionManagement: TGroupBox;
    ComboBoxOptionCollection: TComboBox;
    Panel3: TPanel;
    GroupBoxMajorType: TGroupBox;
    ComboBoxMajorType: TComboBox;
    Panel4: TPanel;
    Panel5: TPanel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    EditLENGTH0: TEdit;
    UpDownLENGTH0: TUpDown;
    EditSIGMA0: TEdit;
    UpDownSIGMA0: TUpDown;
    Label1: TLabel;
    EditLENGTH1: TEdit;
    UpDownLENGTH1: TUpDown;
    EditSIGMA1: TEdit;
    UpDownSIGMA1: TUpDown;
    Label5: TLabel;
    EditLENGTH2: TEdit;
    UpDownLENGTH2: TUpDown;
    EditSIGMA2: TEdit;
    UpDownSIGMA2: TUpDown;
    Label4: TLabel;
    ComboBoxPRICEMETHOD: TComboBox;
    ButtonPRICEMETHOD: TButton;
    EditTHRESHOLD: TEdit;
    UpDownTHRESHOLD: TUpDown;
    Label2: TLabel;
    Bevel2: TBevel;
    Bevel1: TBevel;
    PopupMenuOption: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ButtonPopupMenu: TButton;
    Label6: TLabel;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    CheckBoxUSE_TOLERANCE: TCheckBox;
    EditTOLERANCE: TEdit;
    ComboBoxTOLERANCE_UNIT: TComboBox;
    Panel6: TPanel;
    procedure ComboBoxMajorTypeChange(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure OptionChange(Sender: TObject);
    procedure ButtonApplyTSOptionClick(Sender: TObject);
    procedure ButtonOptionManagementClick(Sender: TObject);
    procedure ButtonFavorClick(Sender: TObject);
    procedure ComboBoxOptionCollectionChange(Sender: TObject);
    procedure ButtonPopupMenuClick(Sender: TObject);
    procedure ButtonPRICEMETHODClick(Sender: TObject);

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

uses FNGlobal, MXTSVariable, TSSelPriceLineDlg, MKTradeStrategyConst;

//---------------------------------------------------------------------------
constructor TBB_T1_Frame.Create(AOwner: TComponent) ;
begin
    inherited Create(AOwner);
    m_ComboBoxOptionCollection := ComboBoxOptionCollection;
    CMXTradeStrategyOption.Default_BB_T1(m_Option);
    m_Category := m_Option.GetStringValue('CATEGORY');
    g_StrategyOptionCollection.ExtractOnCategory(m_Category, m_OptionCollection);

    SetControlData;

    InitComboBoxOptionCollection;
end;

//---------------------------------------------------------------------------
procedure TBB_T1_Frame.MakeDefaultOption(AOption: CMXTradeStrategyOption);
begin
    CMXTradeStrategyOption.Default_BB_T1(AOption);
end;

//---------------------------------------------------------------------------
//  화면컨트롤에서 데이터를 가져온다.
procedure TBB_T1_Frame.GetControlData;
begin
    inherited GetControlData;

    if not Assigned(m_Option) then exit;

    m_Option.SetIntegerValue(TSOPTION_KEY_MAJORVALUE, ComboBoxMajorType.ItemIndex);
    m_Option.SetIntegerValue('LENGTH0', UpDownLENGTH0.Position);
    m_Option.SetDoubleValue('SIGMA0', UpDownSIGMA0.Position);
    m_Option.SetIntegerValue('LENGTH1', UpDownLENGTH1.Position);
    m_Option.SetDoubleValue('SIGMA1', UpDownSIGMA1.Position);
    m_Option.SetIntegerValue('LENGTH2', UpDownLENGTH2.Position);
    m_Option.SetDoubleValue('SIGMA2', UpDownSIGMA2.Position);
    m_Option.SetDoubleValue('THRESHOLD', UpDownTHRESHOLD.Position);
    m_Option.SetIntegerValue('PRICEMETHOD', ComboBoxPRICEMETHOD.ItemIndex);

    m_Option.SetBooleanValue('USE_TOLERANCE', CheckBoxUSE_TOLERANCE.Checked);
    m_Option.SetDoubleValue ('TOLERANCE', TFNGlobal.atof(EditTOLERANCE.Text));
    m_Option.SetIntegerValue('TOLERANCE_UNIT', ComboBoxTOLERANCE_UNIT.ItemIndex);
end;


procedure TBB_T1_Frame.SetControlData;
begin
    inherited SetControlData;

    if not Assigned(m_Option) then exit;

    m_EnableEvent := false;
    try
        ComboBoxMajorType.ItemIndex := m_Option.GetIntegerValue(TSOPTION_KEY_MAJORVALUE);
        UpDownLENGTH0.Position := m_Option.GetIntegerValue('LENGTH0');
        UpDownSIGMA0.Position := Trunc(m_Option.GetDoubleValue('SIGMA0'));
        UpDownLENGTH1.Position := m_Option.GetIntegerValue('LENGTH1');
        UpDownSIGMA1.Position := Trunc(m_Option.GetDoubleValue('SIGMA1'));
        UpDownLENGTH2.Position := m_Option.GetIntegerValue('LENGTH2');
        UpDownSIGMA2.Position := Trunc(m_Option.GetDoubleValue('SIGMA2'));

        UpDownTHRESHOLD.Position := Trunc(m_Option.GetDoubleValue('THRESHOLD'));

        ComboBoxPRICEMETHOD.ItemIndex := m_Option.GetIntegerValue('PRICEMETHOD');

        CheckBoxUSE_TOLERANCE.Checked := m_Option.GetBooleanValue('USE_TOLERANCE');
        EditTOLERANCE.Text := TFNGlobal.WriteNumber(m_Option.GetDoubleValue('TOLERANCE'), 3);
        ComboBoxTOLERANCE_UNIT.ItemIndex := m_Option.GetIntegerValue('TOLERANCE_UNIT');
    finally
        m_EnableEvent := true;
    end;
end;

//---------------------------------------------------------------------------
procedure TBB_T1_Frame.ButtonPRICEMETHODClick(Sender: TObject);
begin
    if not Assigned(m_Option) then exit;

    SelPriceLineDlg := TSelPriceLineDlg.Create(Self);
    SelPriceLineDlg.Option := m_Option;

    if SelPriceLineDlg.ShowModal = mrOK then
    begin
        m_Option.Clone(SelPriceLineDlg.Option);
        UpdateControlData;
        if Assigned(m_ChangedOption) then m_ChangedOption(Self);
    end;
    SelPriceLineDlg.Free;
    SelPriceLineDlg := NIL;
end;

//---------------------------------------------------------------------------
procedure TBB_T1_Frame.ButtonApplyTSOptionClick(Sender: TObject);
begin
    ApplyOptionCollection;
end;

//---------------------------------------------------------------------------
procedure TBB_T1_Frame.ButtonFavorClick(Sender: TObject);
begin
    AddFavorOptionCollection;
end;


//---------------------------------------------------------------------------
procedure TBB_T1_Frame.ButtonOptionManagementClick(Sender: TObject);
begin
    ManagementOptionCollection;
end;

//---------------------------------------------------------------------------
procedure TBB_T1_Frame.ButtonPopupMenuClick(Sender: TObject);
var
    f_PT:TPoint;
begin
    f_PT := ComboBoxOptionCollection.ClientToScreen(Point(0, ComboBoxOptionCollection.Height+2));
    PopupMenuOption.Popup(f_PT.x, f_PT.y);
end;

//---------------------------------------------------------------------------
procedure TBB_T1_Frame.ComboBoxMajorTypeChange(Sender: TObject);
begin
    if not Assigned(m_Option) then exit;
    if not m_EnableEvent then exit;

    GetControlData;
    UpdateControlData;
    ApplyToOrignal;

    if Assigned(m_ChangedOption) then m_ChangedOption(Self);
end;

//---------------------------------------------------------------------------
procedure TBB_T1_Frame.ComboBoxOptionCollectionChange(Sender: TObject);
begin
    ApplyOptionCollection;
end;

//---------------------------------------------------------------------------
procedure TBB_T1_Frame.EditKeyPress(Sender: TObject; var Key: Char);
begin
    if Key in [#$D] then
    begin
        OptionChange(Sender);
        exit;
    end;

    if Key in ['0'..'9', '-', #8, #9, #32, #3, #22, #$2E] then // 0~9, -, Tab, BS, Space, Ctrl+C, Ctrl+V ?? ???
    begin
    end else
    begin
        Key := #0;
    end;
end;

//---------------------------------------------------------------------------
procedure TBB_T1_Frame.UpdateControlData;
begin
    SetControlData;
end;

//---------------------------------------------------------------------------
procedure TBB_T1_Frame.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
    if not Assigned(m_Option) then exit;
    if not m_EnableEvent then exit;

    GetControlData;
    UpdateControlData;
    ApplyToOrignal;

    if Assigned(m_ChangedOption) then m_ChangedOption(Self);
end;

//---------------------------------------------------------------------------
procedure TBB_T1_Frame.OptionChange(Sender: TObject);
begin
    if not Assigned(m_Option) then exit;
    if not m_EnableEvent then exit;

    GetControlData;
    //UpdateControlData;
    ApplyToOrignal;

    if Assigned(m_ChangedOption) then m_ChangedOption(Self);
end;

end.





