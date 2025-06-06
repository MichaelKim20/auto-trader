inherited Random_Frame: TRandom_Frame
  Width = 600
  Height = 400
  ExplicitWidth = 600
  ExplicitHeight = 400
  object Panel9: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 400
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 2
    Padding.Top = 5
    Padding.Right = 2
    Padding.Bottom = 2
    ParentColor = True
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 2
      Top = 95
      Width = 596
      Height = 303
      Align = alClient
      Caption = #47004#45924
      TabOrder = 0
      object CheckBoxUSE_RANDOM_TRADE: TCheckBox
        Left = 10
        Top = 25
        Width = 120
        Height = 17
        Caption = #49324#50857#50668#48512
        TabOrder = 0
        OnClick = OptionChange
      end
      object RadioButtonRANDOM_CASE1: TRadioButton
        Left = 10
        Top = 56
        Width = 177
        Height = 17
        Caption = #51652#51077#54869#47456' 1/2 '#51060#49345
        TabOrder = 1
        OnClick = OptionChange
      end
      object RadioButtonRANDOM_CASE2: TRadioButton
        Left = 10
        Top = 88
        Width = 177
        Height = 17
        Caption = #51652#51077#54869#47456' 2/3 '#51060#49345
        TabOrder = 2
        OnClick = OptionChange
      end
    end
    object GroupBoxOptionManagement: TGroupBox
      Left = 2
      Top = 38
      Width = 596
      Height = 50
      Align = alTop
      Caption = #51200#51109#44284' '#51201#50857
      TabOrder = 1
      object ComboBoxOptionCollection: TComboBox
        Left = 8
        Top = 20
        Width = 148
        Height = 21
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 0
        OnChange = ComboBoxOptionCollectionChange
      end
      object ButtonPopupMenu: TButton
        Left = 162
        Top = 19
        Width = 26
        Height = 26
        Caption = '...'
        TabOrder = 1
        OnClick = ButtonPopupMenuClick
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 88
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
    end
    object Panel3: TPanel
      Left = 2
      Top = 31
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
    end
    object Panel4: TPanel
      Left = 2
      Top = 5
      Width = 596
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      Caption = #47004#45924
      Color = 14598235
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      Padding.Bottom = 5
      ParentBackground = False
      ParentFont = False
      TabOrder = 4
      StyleElements = []
    end
  end
  object PopupMenuOption: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    Left = 42
    Top = 444
    object N1: TMenuItem
      Caption = #54788#51116' '#49444#51221#50640' '#51201#50857
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #51088#51452#49324#50857#51004#47196' '#51200#51109
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #44288#47532#52285' '#48372#44592
      OnClick = N3Click
    end
  end
end
