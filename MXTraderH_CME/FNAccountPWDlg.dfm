object AccountPWDlg: TAccountPWDlg
  Left = 0
  Top = 0
  Caption = #44228#51340#48708#48128#48264#54840
  ClientHeight = 133
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 10
    Top = 59
    Width = 82
    Height = 13
    Caption = #44228#51340#48708#48128#48264#54840' : '
  end
  object LabelACCOUNT_NO: TLabel
    Left = 10
    Top = 27
    Width = 55
    Height = 13
    Caption = #44228#51340#48264#54840' :'
  end
  object LabelACCOUNT_NAME: TLabel
    Left = 230
    Top = 27
    Width = 109
    Height = 12
    AutoSize = False
  end
  object Password: TEdit
    Left = 98
    Top = 52
    Width = 121
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 0
  end
  object OKBtn: TButton
    Left = 86
    Top = 94
    Width = 100
    Height = 25
    Caption = #54869#51064
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 230
    Top = 94
    Width = 100
    Height = 25
    Cancel = True
    Caption = #52712#49548
    ModalResult = 2
    TabOrder = 2
  end
  object ComboBoxACCOUNT_NO: TComboBox
    Left = 99
    Top = 24
    Width = 120
    Height = 21
    Style = csDropDownList
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 3
    OnChange = ComboBoxACCOUNT_NOChange
  end
end
