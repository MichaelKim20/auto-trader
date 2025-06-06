inherited ENTER_Frame: TENTER_Frame
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
      Top = 214
      Width = 596
      Height = 89
      Align = alTop
      Caption = '1'#51068' '#51652#51077' '#52572#45824' '#54943#49688
      TabOrder = 0
      object Label1: TLabel
        Left = 67
        Top = 55
        Width = 11
        Height = 13
        Caption = #54924
      end
      object CheckBoxUseMaxEnterCount: TCheckBox
        Left = 10
        Top = 25
        Width = 120
        Height = 17
        Caption = #49324#50857#50668#48512
        TabOrder = 0
        OnClick = OptionChange
      end
      object EditMaxEnterCount: TEdit
        Left = 10
        Top = 52
        Width = 36
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 1
        Text = '1'
        OnChange = EditChange
        OnKeyPress = EditKeyPress
      end
      object UpDownMaxEnterCount: TUpDown
        Left = 46
        Top = 52
        Width = 15
        Height = 21
        Associate = EditMaxEnterCount
        Position = 1
        TabOrder = 2
        OnClick = UpDownClick
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
    object Panel1: TPanel
      Left = 2
      Top = 207
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 4
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 95
      Width = 596
      Height = 112
      Align = alTop
      Caption = #51116#51652#51077' '#54596#53552
      TabOrder = 5
      object Label3: TLabel
        Left = 10
        Top = 55
        Width = 39
        Height = 13
        Caption = #52397#49328' '#54980' '
      end
      object Label5: TLabel
        Left = 117
        Top = 55
        Width = 50
        Height = 13
        Caption = #48148' '#51060#45236#50640' '
      end
      object Label6: TLabel
        Left = 10
        Top = 85
        Width = 58
        Height = 13
        Caption = #51116#51652#51077' '#44552#51648
      end
      object CheckBoxUseEnterDelay: TCheckBox
        Left = 10
        Top = 25
        Width = 120
        Height = 17
        Caption = #49324#50857#50668#48512
        TabOrder = 0
        OnClick = OptionChange
      end
      object EditDelayCount: TEdit
        Left = 60
        Top = 51
        Width = 36
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 1
        Text = '1'
        OnChange = EditChange
        OnKeyPress = EditKeyPress
      end
      object UpDownDelayCount: TUpDown
        Left = 96
        Top = 51
        Width = 15
        Height = 21
        Associate = EditDelayCount
        Position = 1
        TabOrder = 2
        OnClick = UpDownClick
      end
    end
    object Panel4: TPanel
      Left = 2
      Top = 5
      Width = 596
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      Caption = #51116#51652#51077
      Color = 14598235
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      Padding.Bottom = 5
      ParentBackground = False
      ParentFont = False
      TabOrder = 6
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
