unit TSSelPriceLineDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, MXTradeStrategyOptionCollection;

type
    TSelPriceLineDlg = class(TForm)
        OKBtn: TButton;
        CancelBtn: TButton;
        Label9: TLabel;
        GroupBox1: TGroupBox;
        Bevel1: TBevel;
        RadioButtonPRICEMETHOD0: TRadioButton;
        RadioButtonPRICEMETHOD1: TRadioButton;
        RadioButtonPRICEMETHOD2: TRadioButton;
        RadioButtonPRICEMETHOD3: TRadioButton;
        Label1: TLabel;
        EditPM1_V1: TEdit;
        UpDownPM1_V1: TUpDown;
        Label2: TLabel;
        EditPM2_V1: TEdit;
        UpDownPM2_V1: TUpDown;
        Label3: TLabel;
        EditPM3_V1: TEdit;
        UpDownPM3_V1: TUpDown;
        Label4: TLabel;
        ComboBoxPM1_V2: TComboBox;
        Label5: TLabel;
        ComboBoxPM2_V2: TComboBox;
        Label6: TLabel;
        ComboBoxPM3_V2: TComboBox;
        Label7: TLabel;
        EditPM4_V1: TEdit;
        UpDownPM4_V1: TUpDown;
        Label8: TLabel;
        EditPM4_V2: TEdit;
        UpDownPM4_V2: TUpDown;
        Bevel2: TBevel;
        Bevel3: TBevel;
        procedure OKBtnClick(Sender: TObject);
  private
        m_Option : CMXTradeStrategyOption;
        m_Prefix : String;

        procedure GetControlData;
        procedure SetControlData;
        procedure AssignOption(AOption:CMXTradeStrategyOption);
        function GetOption:CMXTradeStrategyOption;
  public
        constructor Create(AOwner: TComponent) ; override;
        destructor Destroy; override;

        property Option : CMXTradeStrategyOption read GetOption write AssignOption;
        property Prefix : String read m_Prefix write m_Prefix;
  end;

var
    SelPriceLineDlg: TSelPriceLineDlg;

implementation

{$R *.dfm}

constructor TSelPriceLineDlg.Create(AOwner: TComponent) ;
begin
    inherited Create(AOwner) ;
    m_Prefix := '';
    m_Option := CMXTradeStrategyOption.Create;
end;

destructor TSelPriceLineDlg.Destroy;
begin
    if Assigned(m_Option) then
    begin
        m_Option.Free;
        m_Option := NIL;
    end;

    inherited;
end;

procedure TSelPriceLineDlg.GetControlData;
var
    f_NValue:Integer;
begin
    if RadioButtonPRICEMETHOD0.Checked then
    begin
        f_NValue := 0;
    end else
    if RadioButtonPRICEMETHOD1.Checked then
    begin
        f_NValue := 1;
    end else
    if RadioButtonPRICEMETHOD2.Checked then
    begin
        f_NValue := 2;
    end else
    if RadioButtonPRICEMETHOD3.Checked then
    begin
        f_NValue := 3;
    end;
    m_Option.SetIntegerValue(m_Prefix + 'PRICEMETHOD', f_NValue);

    m_Option.SetIntegerValue(m_Prefix + 'PM1_V1', UpDownPM1_V1.Position);
    m_Option.SetIntegerValue(m_Prefix + 'PM2_V1', UpDownPM2_V1.Position);
    m_Option.SetIntegerValue(m_Prefix + 'PM3_V1', UpDownPM3_V1.Position);
    m_Option.SetIntegerValue(m_Prefix + 'PM4_V1', UpDownPM4_V1.Position);


    m_Option.SetIntegerValue(m_Prefix + 'PM1_V2', ComboBoxPM1_V2.ItemIndex);
    m_Option.SetIntegerValue(m_Prefix + 'PM2_V2', ComboBoxPM2_V2.ItemIndex);
    m_Option.SetIntegerValue(m_Prefix + 'PM3_V2', ComboBoxPM3_V2.ItemIndex);
    m_Option.SetDoubleValue (m_Prefix + 'PM4_V2', UpDownPM4_V2.Position);

end;

procedure TSelPriceLineDlg.SetControlData;
var
    f_NValue:Integer;
begin
    f_NValue := m_Option.GetIntegerValue(m_Prefix + 'PRICEMETHOD');
    if 0 = f_NValue then
    begin
        RadioButtonPRICEMETHOD0.Checked := true;
    end else
    if 1 = f_NValue then
    begin
        RadioButtonPRICEMETHOD1.Checked := true;
    end else
    if 2 = f_NValue then
    begin
        RadioButtonPRICEMETHOD2.Checked := true;
    end else
    if 3 = f_NValue then
    begin
        RadioButtonPRICEMETHOD3.Checked := true;
    end;

    UpDownPM1_V1.Position := m_Option.GetIntegerValue(m_Prefix + 'PM1_V1');
    UpDownPM2_V1.Position := m_Option.GetIntegerValue(m_Prefix + 'PM2_V1');
    UpDownPM3_V1.Position := m_Option.GetIntegerValue(m_Prefix + 'PM3_V1');
    UpDownPM4_V1.Position := m_Option.GetIntegerValue(m_Prefix + 'PM4_V1');

    ComboBoxPM1_V2.ItemIndex := m_Option.GetIntegerValue(m_Prefix + 'PM1_V2');
    ComboBoxPM2_V2.ItemIndex := m_Option.GetIntegerValue(m_Prefix + 'PM2_V2');
    ComboBoxPM3_V2.ItemIndex := m_Option.GetIntegerValue(m_Prefix + 'PM3_V2');
    UpDownPM4_V2.Position := Trunc(m_Option.GetDoubleValue(m_Prefix + 'PM4_V2'));
end;

procedure TSelPriceLineDlg.AssignOption(AOption: CMXTradeStrategyOption);
begin
    m_Option.ClearAll;
    m_Option.Clone(AOption);
    SetControlData;
end;

function TSelPriceLineDlg.GetOption: CMXTradeStrategyOption;
begin
    result := m_Option;
end;
procedure TSelPriceLineDlg.OKBtnClick(Sender: TObject);
begin
    GetControlData;
end;

end.
