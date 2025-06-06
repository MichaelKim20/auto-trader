inherited IM_T1_Frame: TIM_T1_Frame
  Width = 200
  Height = 600
  ExplicitWidth = 200
  ExplicitHeight = 600
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 200
    Height = 600
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 2
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    TabOrder = 0
    object Panel3: TPanel
      Left = 2
      Top = 77
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
    end
    object GroupBoxMajorType: TGroupBox
      Left = 2
      Top = 84
      Width = 196
      Height = 46
      Align = alTop
      Caption = #44032#44201#51648#54364
      TabOrder = 1
      object ComboBoxMajorType: TComboBox
        Left = 7
        Top = 18
        Width = 180
        Height = 21
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 0
        Text = 'OPS'
        OnChange = ComboBoxMajorTypeChange
        Items.Strings = (
          #44032#44201
          'OPS'
          'OPS2')
      end
    end
    object Panel4: TPanel
      Left = 2
      Top = 2
      Width = 196
      Height = 22
      Align = alTop
      BevelKind = bkFlat
      BevelOuter = bvNone
      Caption = #51068#47785' '#52628#49464'1'
      Color = 10331807
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548
      Font.Style = [fsBold]
      Padding.Bottom = 5
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
    end
    object Panel5: TPanel
      Left = 2
      Top = 24
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
    end
    object GroupBoxOptionManagement: TGroupBox
      Left = 2
      Top = 31
      Width = 196
      Height = 46
      Align = alTop
      Caption = #51200#51109#44284' '#51201#50857
      TabOrder = 4
      object ComboBoxOptionCollection: TComboBox
        Left = 7
        Top = 18
        Width = 148
        Height = 21
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ItemHeight = 13
        TabOrder = 0
        OnChange = ComboBoxOptionCollectionChange
      end
      object ButtonPopupMenu: TButton
        Left = 162
        Top = 18
        Width = 25
        Height = 20
        Caption = '...'
        PopupMenu = PopupMenuOption
        TabOrder = 1
        OnClick = ButtonPopupMenuClick
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 130
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 5
    end
    object GroupBox1: TGroupBox
      Left = 2
      Top = 137
      Width = 196
      Height = 80
      Align = alTop
      Caption = #51648#54364#51312#44148
      TabOrder = 6
      object Label4: TLabel
        Left = 7
        Top = 25
        Width = 94
        Height = 13
        Caption = #51068#47785#44512#54805#54364' '#49444#51221' :'
      end
      object EditLENGTH1: TEdit
        Left = 7
        Top = 45
        Width = 40
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 0
        Text = '1'
        OnChange = EditChange
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
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 2
        Text = '1'
        OnChange = EditChange
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
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 4
        Text = '1'
        OnChange = EditChange
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
    end
    object Panel6: TPanel
      Left = 2
      Top = 484
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 7
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 224
      Width = 196
      Height = 260
      Align = alTop
      Caption = #48320#46041#49457#51012' '#51060#50857#54620' '#52628#49464' '#54032#45800
      TabOrder = 8
      object Label1: TLabel
        Left = 48
        Top = 100
        Width = 19
        Height = 13
        Caption = 'V1 :'
      end
      object Label2: TLabel
        Left = 48
        Top = 145
        Width = 19
        Height = 13
        Caption = 'V2 :'
      end
      object Label3: TLabel
        Left = 48
        Top = 189
        Width = 19
        Height = 13
        Caption = 'V3 :'
      end
      object Label5: TLabel
        Left = 48
        Top = 233
        Width = 19
        Height = 13
        Caption = 'V4 :'
      end
      object Label6: TLabel
        Left = 7
        Top = 51
        Width = 97
        Height = 13
        BiDiMode = bdLeftToRight
        Caption = #44032#44201#51648#54364#51032' '#51333#47448' : '
        ParentBiDiMode = False
      end
      object RadioButtonM2: TRadioButton
        Left = 7
        Top = 122
        Width = 170
        Height = 17
        Caption = #51204#51068#48320#46041#54253#51060' V2 pt. '#51060#54616
        TabOrder = 0
        OnClick = OptionChange
      end
      object RadioButtonM1: TRadioButton
        Left = 7
        Top = 78
        Width = 170
        Height = 17
        Caption = #51204#51068#51060' '#51204#51204#51068#51032'  V1 '#48176#51060#54616
        TabOrder = 1
        OnClick = OptionChange
      end
      object RadioButtonM4: TRadioButton
        Left = 7
        Top = 211
        Width = 170
        Height = 17
        Caption = #51204#51068#48320#46041#47456#51060' V3 % '#51060#54616
        TabOrder = 2
        OnClick = OptionChange
      end
      object EditM1V1: TEdit
        Left = 73
        Top = 97
        Width = 80
        Height = 21
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
        OnKeyPress = EditKeyPress
      end
      object EditM2V1: TEdit
        Left = 73
        Top = 141
        Width = 80
        Height = 21
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 4
        OnKeyPress = EditKeyPress
      end
      object EditM4V1: TEdit
        Left = 73
        Top = 230
        Width = 80
        Height = 21
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 5
        OnKeyPress = EditKeyPress
      end
      object RadioButtonM3: TRadioButton
        Left = 7
        Top = 167
        Width = 170
        Height = 17
        Caption = #51204#51068#48320#46041#54253#51060' V3 '#54001' '#51060#54616
        TabOrder = 6
        OnClick = OptionChange
      end
      object EditM3V1: TEdit
        Left = 73
        Top = 186
        Width = 80
        Height = 21
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 7
        OnKeyPress = EditKeyPress
      end
      object CheckBoxUSE_SIDECONDITION: TCheckBox
        Left = 7
        Top = 25
        Width = 179
        Height = 17
        Caption = #49324#50857#50976#47924
        TabOrder = 8
        OnClick = OptionChange
      end
      object ComboBoxVALUE_TYPE: TComboBox
        Left = 107
        Top = 48
        Width = 79
        Height = 21
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ItemHeight = 13
        TabOrder = 9
        OnChange = OptionChange
        Items.Strings = (
          #44032#44201
          'OPS')
      end
    end
    object Panel7: TPanel
      Left = 2
      Top = 217
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 9
    end
    object GroupBox3: TGroupBox
      Left = 2
      Top = 491
      Width = 196
      Height = 85
      Align = alTop
      Caption = #54728#50857#48276#50948
      TabOrder = 10
      object Label7: TLabel
        Left = 7
        Top = 55
        Width = 12
        Height = 13
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
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 1
        Text = '1'
        OnExit = EditChange
        OnKeyPress = EditKeyPress
      end
      object ComboBoxTOLERANCE_UNIT: TComboBox
        Left = 105
        Top = 52
        Width = 81
        Height = 21
        Style = csDropDownList
        ImeName = 'Microsoft Office IME 2007'
        ItemHeight = 13
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
    Left = 78
    Top = 576
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
