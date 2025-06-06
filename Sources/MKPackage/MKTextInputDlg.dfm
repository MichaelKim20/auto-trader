object TextInputDlg: TTextInputDlg
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #52264#53944#50640' '#51077#47141#54624' '#47928#51088
  ClientHeight = 166
  ClientWidth = 307
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 17
  object m_TextInput: TMemo
    Left = 8
    Top = 8
    Width = 291
    Height = 82
    ImeName = 'Microsoft Office IME 2007'
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object m_btnOk: TButton
    Left = 125
    Top = 132
    Width = 75
    Height = 25
    Caption = #54869#51064
    ModalResult = 1
    TabOrder = 1
  end
  object m_btnCancel: TButton
    Left = 212
    Top = 132
    Width = 75
    Height = 25
    Cancel = True
    Caption = #52712#49548
    ModalResult = 2
    TabOrder = 2
  end
  object ToolBar1: TToolBar
    Left = 8
    Top = 100
    Width = 291
    Height = 25
    Align = alNone
    ButtonWidth = 28
    TabOrder = 3
    object m_cbbFontColor: TColorBox
      Left = 0
      Top = 0
      Width = 105
      Height = 22
      ParentColor = True
      TabOrder = 0
      OnChange = m_cbbFontColorChange
    end
    object m_cbFontSize: TComboBox
      Left = 105
      Top = 0
      Width = 54
      Height = 25
      Style = csDropDownList
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 1
      OnChange = m_cbFontSizeChange
    end
    object ToolButton1: TToolButton
      Left = 159
      Top = 0
      Width = 33
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
    object m_btnBold: TButton
      Left = 192
      Top = 0
      Width = 32
      Height = 22
      Caption = 'B'
      TabOrder = 2
      OnClick = m_btnBoldClick
    end
    object m_btnItalic: TButton
      Left = 224
      Top = 0
      Width = 32
      Height = 22
      Caption = 'I'
      TabOrder = 3
      OnClick = m_btnItalicClick
    end
    object m_btnUnderline: TButton
      Left = 256
      Top = 0
      Width = 32
      Height = 22
      Caption = 'U'
      TabOrder = 4
      OnClick = m_btnUnderlineClick
    end
  end
end
