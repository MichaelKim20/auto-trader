inherited IM_T3_Frame: TIM_T3_Frame
  Width = 610
  Height = 414
  Font.Charset = ANSI_CHARSET
  Font.Height = -13
  Font.Name = #47569#51008' '#44256#46357
  ParentFont = False
  ExplicitWidth = 610
  ExplicitHeight = 414
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 610
    Height = 414
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
      Width = 606
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
    end
    object GroupBoxMajorType: TGroupBox
      Left = 2
      Top = 92
      Width = 606
      Height = 50
      Align = alTop
      Caption = #44032#44201#51648#54364
      TabOrder = 1
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
      Width = 606
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      Caption = #51068#47785' '#52628#49464'3'
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
      Width = 606
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
    end
    object GroupBoxOptionManagement: TGroupBox
      Left = 2
      Top = 35
      Width = 606
      Height = 50
      Align = alTop
      Caption = #51200#51109#44284' '#51201#50857
      TabOrder = 4
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
        Left = 161
        Top = 18
        Width = 25
        Height = 26
        Caption = '...'
        PopupMenu = PopupMenuOption
        TabOrder = 1
        OnClick = ButtonPopupMenuClick
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 409
      Width = 606
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 5
    end
    object Panel6: TPanel
      Left = 2
      Top = 142
      Width = 606
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 6
    end
    object GroupBox1: TGroupBox
      Left = 2
      Top = 149
      Width = 606
      Height = 48
      Align = alTop
      Caption = #51648#54364#51312#44148
      TabOrder = 7
      object EditLENGTH1: TEdit
        Left = 7
        Top = 18
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 0
        Text = '1'
        OnChange = EditChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH1: TUpDown
        Left = 47
        Top = 18
        Width = 15
        Height = 25
        Associate = EditLENGTH1
        Min = 1
        Max = 1200
        Position = 1
        TabOrder = 1
        OnClick = UpDownClick
      end
      object EditLENGTH2: TEdit
        Left = 70
        Top = 18
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 2
        Text = '1'
        OnChange = EditChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH2: TUpDown
        Left = 110
        Top = 18
        Width = 15
        Height = 25
        Associate = EditLENGTH2
        Min = 1
        Max = 1200
        Position = 1
        TabOrder = 3
        OnClick = UpDownClick
      end
      object EditLENGTH3: TEdit
        Left = 131
        Top = 18
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 4
        Text = '1'
        OnChange = EditChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH3: TUpDown
        Left = 171
        Top = 18
        Width = 15
        Height = 25
        Associate = EditLENGTH3
        Min = 1
        Max = 1200
        Position = 1
        TabOrder = 5
        OnClick = UpDownClick
      end
    end
    object Panel7: TPanel
      Left = 2
      Top = 197
      Width = 606
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 8
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 204
      Width = 606
      Height = 113
      Align = alTop
      Caption = #48320#46041#49457#51012' '#51060#50857#54620' '#52628#49464' '#54032#45800
      TabOrder = 9
      object Label1: TLabel
        Left = 198
        Top = 52
        Width = 23
        Height = 17
        Caption = 'V1 :'
      end
      object Label2: TLabel
        Left = 480
        Top = 52
        Width = 23
        Height = 17
        Caption = 'V2 :'
      end
      object Label3: TLabel
        Left = 198
        Top = 80
        Width = 23
        Height = 17
        Caption = 'V3 :'
      end
      object Label5: TLabel
        Left = 480
        Top = 79
        Width = 23
        Height = 17
        Caption = 'V4 :'
      end
      object Label6: TLabel
        Left = 198
        Top = 25
        Width = 109
        Height = 17
        BiDiMode = bdLeftToRight
        Caption = #44032#44201#51648#54364#51032' '#51333#47448' : '
        ParentBiDiMode = False
      end
      object RadioButtonM2: TRadioButton
        Left = 309
        Top = 52
        Width = 170
        Height = 17
        Caption = #51204#51068#48320#46041#54253#51060' V2 pt. '#51060#54616
        TabOrder = 0
        OnClick = OptionChange
      end
      object RadioButtonM1: TRadioButton
        Left = 20
        Top = 52
        Width = 170
        Height = 17
        Caption = #51204#51068#51060' '#51204#51204#51068#51032'  V1 '#48176#51060#54616
        TabOrder = 1
        OnClick = OptionChange
      end
      object RadioButtonM4: TRadioButton
        Left = 309
        Top = 80
        Width = 170
        Height = 17
        Caption = #51204#51068#48320#46041#47456#51060' V3 % '#51060#54616
        TabOrder = 2
        OnClick = OptionChange
      end
      object EditM1V1: TEdit
        Left = 223
        Top = 50
        Width = 80
        Height = 25
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
        OnKeyPress = EditKeyPress
      end
      object EditM2V1: TEdit
        Left = 505
        Top = 50
        Width = 80
        Height = 25
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 4
        OnKeyPress = EditKeyPress
      end
      object EditM4V1: TEdit
        Left = 505
        Top = 77
        Width = 80
        Height = 25
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 5
        OnKeyPress = EditKeyPress
      end
      object RadioButtonM3: TRadioButton
        Left = 20
        Top = 80
        Width = 170
        Height = 17
        Caption = #51204#51068#48320#46041#54253#51060' V3 '#54001' '#51060#54616
        TabOrder = 6
        OnClick = OptionChange
      end
      object EditM3V1: TEdit
        Left = 223
        Top = 77
        Width = 80
        Height = 25
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
        Left = 307
        Top = 20
        Width = 79
        Height = 25
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 9
        OnChange = OptionChange
        Items.Strings = (
          #44032#44201
          'MATRIX')
      end
    end
    object Panel8: TPanel
      Left = 2
      Top = 317
      Width = 606
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 10
    end
    object GroupBox3: TGroupBox
      Left = 2
      Top = 324
      Width = 606
      Height = 85
      Align = alTop
      Caption = #54728#50857#48276#50948
      TabOrder = 11
      object Label7: TLabel
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
        OnExit = EditChange
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
    Left = 76
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
