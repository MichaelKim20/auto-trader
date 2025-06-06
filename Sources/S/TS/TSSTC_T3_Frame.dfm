inherited STC_T3_Frame: TSTC_T3_Frame
  Width = 600
  Height = 400
  Font.Charset = ANSI_CHARSET
  Font.Height = -13
  Font.Name = #47569#51008' '#44256#46357
  ParentFont = False
  ExplicitWidth = 600
  ExplicitHeight = 400
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 400
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 2
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    TabOrder = 0
    object Panel3: TPanel
      Left = 2
      Top = 85
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitTop = 81
    end
    object GroupBoxMajorType: TGroupBox
      Left = 2
      Top = 92
      Width = 596
      Height = 46
      Align = alTop
      Caption = #44032#44201#51648#54364
      TabOrder = 1
      ExplicitTop = 88
      object ComboBoxMajorType: TComboBox
        Left = 7
        Top = 18
        Width = 180
        Height = 25
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ItemIndex = 1
        TabOrder = 0
        Text = 'MATRIX'
        OnChange = ComboBoxMajorTypeChange
        Items.Strings = (
          #44032#44201
          'MATRIX'
          'MATRIX2')
      end
    end
    object Panel4: TPanel
      Left = 2
      Top = 2
      Width = 596
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Stochastic '#52628#49464' 3'
      Color = 14598235
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      Padding.Bottom = 5
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      StyleElements = []
    end
    object Panel5: TPanel
      Left = 2
      Top = 28
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 145
      Width = 596
      Height = 136
      Align = alTop
      Caption = #51473#52393#51312#44148
      TabOrder = 4
      ExplicitTop = 141
      object Label3: TLabel
        Left = 7
        Top = 25
        Width = 110
        Height = 17
        Caption = 'Stochastic 1 '#49444#51221' :'
      end
      object Label1: TLabel
        Left = 241
        Top = 25
        Width = 110
        Height = 17
        Caption = 'Stochastic 2 '#49444#51221' :'
      end
      object Label2: TLabel
        Left = 7
        Top = 84
        Width = 78
        Height = 17
        Caption = #52488#44284' '#47588#49688#44428' :'
      end
      object Label5: TLabel
        Left = 7
        Top = 109
        Width = 78
        Height = 17
        Caption = #52488#44284' '#47588#46020#44428' :'
      end
      object EditLENGTH1: TEdit
        Left = 7
        Top = 45
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 0
        Text = '1'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH1: TUpDown
        Left = 47
        Top = 45
        Width = 15
        Height = 21
        Associate = EditLENGTH1
        Min = 1
        Max = 1200
        Position = 1
        TabOrder = 1
        OnClick = UpDownClick
      end
      object EditLENGTH2: TEdit
        Left = 70
        Top = 45
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 2
        Text = '1'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH2: TUpDown
        Left = 110
        Top = 45
        Width = 15
        Height = 21
        Associate = EditLENGTH2
        Min = 1
        Max = 1200
        Position = 1
        TabOrder = 3
        OnClick = UpDownClick
      end
      object EditLENGTH3: TEdit
        Left = 131
        Top = 45
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 4
        Text = '1'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH3: TUpDown
        Left = 171
        Top = 45
        Width = 15
        Height = 21
        Associate = EditLENGTH3
        Min = 1
        Max = 1200
        Position = 1
        TabOrder = 5
        OnClick = UpDownClick
      end
      object EditLENGTH4: TEdit
        Left = 241
        Top = 45
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 6
        Text = '1'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH4: TUpDown
        Left = 281
        Top = 45
        Width = 15
        Height = 21
        Associate = EditLENGTH4
        Min = 1
        Max = 1200
        Position = 1
        TabOrder = 7
        OnClick = UpDownClick
      end
      object EditLENGTH5: TEdit
        Left = 304
        Top = 45
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 8
        Text = '1'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH5: TUpDown
        Left = 344
        Top = 45
        Width = 15
        Height = 21
        Associate = EditLENGTH5
        Min = 1
        Max = 1200
        Position = 1
        TabOrder = 9
        OnClick = UpDownClick
      end
      object EditLENGTH6: TEdit
        Left = 365
        Top = 45
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 10
        Text = '1'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH6: TUpDown
        Left = 405
        Top = 45
        Width = 15
        Height = 21
        Associate = EditLENGTH6
        Min = 1
        Max = 1200
        Position = 1
        TabOrder = 11
        OnClick = UpDownClick
      end
      object EditDN: TEdit
        Left = 131
        Top = 106
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 12
        Text = '1'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object EditUP: TEdit
        Left = 131
        Top = 79
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 13
        Text = '1'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownUP: TUpDown
        Left = 171
        Top = 79
        Width = 15
        Height = 21
        Associate = EditUP
        Position = 1
        TabOrder = 14
        OnClick = UpDownClick
      end
      object UpDownDN: TUpDown
        Left = 171
        Top = 106
        Width = 15
        Height = 21
        Associate = EditDN
        Position = 1
        TabOrder = 15
        OnClick = UpDownClick
      end
    end
    object Panel6: TPanel
      Left = 2
      Top = 138
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 5
      ExplicitTop = 134
    end
    object GroupBoxOptionManagement: TGroupBox
      Left = 2
      Top = 35
      Width = 596
      Height = 50
      Align = alTop
      Caption = #51200#51109#44284' '#51201#50857
      TabOrder = 6
      object ComboBoxOptionCollection: TComboBox
        Left = 7
        Top = 18
        Width = 148
        Height = 25
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 0
        OnChange = ComboBoxOptionCollectionChange
      end
      object ButtonPopupMenu: TButton
        Left = 162
        Top = 18
        Width = 26
        Height = 26
        Caption = '...'
        PopupMenu = PopupMenuOption
        TabOrder = 1
        OnClick = ButtonPopupMenuClick
      end
    end
    object Panel7: TPanel
      Left = 2
      Top = 281
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 7
      ExplicitTop = 277
    end
    object GroupBox1: TGroupBox
      Left = 2
      Top = 288
      Width = 596
      Height = 85
      Align = alTop
      Caption = #54728#50857#48276#50948
      TabOrder = 8
      ExplicitTop = 284
      object Label4: TLabel
        Left = 7
        Top = 55
        Width = 14
        Height = 17
        Caption = '+-'
      end
      object CheckBoxUSE_TOLERANCE: TCheckBox
        Left = 7
        Top = 25
        Width = 179
        Height = 17
        Caption = #49324#50857#50976#47924
        TabOrder = 0
        OnClick = OptionChange
      end
      object EditTOLERANCE: TEdit
        Left = 25
        Top = 52
        Width = 53
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 1
        Text = '1'
        OnKeyPress = EditKeyPress
      end
      object ComboBoxTOLERANCE_UNIT: TComboBox
        Left = 105
        Top = 52
        Width = 81
        Height = 25
        Style = csDropDownList
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
        OnChange = OptionChange
        Items.Strings = (
          #54140#49468#53944
          #51208#45824#44050)
      end
    end
  end
  object PopupMenuOption: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    Left = 410
    Top = 282
    object N1: TMenuItem
      Caption = #54788#51116' '#49444#51221#50640' '#51201#50857
      OnClick = ButtonApplyTSOptionClick
    end
    object N2: TMenuItem
      Caption = #51088#51452#49324#50857#51004#47196' '#51200#51109
      OnClick = ButtonFavorClick
    end
    object N3: TMenuItem
      Caption = #44288#47532#52285' '#48372#44592
      OnClick = ButtonOptionManagementClick
    end
  end
end
