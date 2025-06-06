inherited BASELINE_N1_Frame: TBASELINE_N1_Frame
  Width = 600
  Height = 430
  Font.Charset = ANSI_CHARSET
  Font.Height = -13
  Font.Name = #47569#51008' '#44256#46357
  ParentFont = False
  ExplicitWidth = 600
  ExplicitHeight = 430
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 430
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 2
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 2
      Top = 145
      Width = 596
      Height = 82
      Align = alTop
      Caption = #48320#46041#49457#51012' '#51060#50857#54620' '#48708#52628#49464' '#54032#45800
      TabOrder = 0
      object Label1: TLabel
        Left = 48
        Top = 50
        Width = 23
        Height = 17
        Caption = 'V1 :'
      end
      object Label2: TLabel
        Left = 234
        Top = 53
        Width = 23
        Height = 17
        Caption = 'V2 :'
      end
      object Label3: TLabel
        Left = 440
        Top = 52
        Width = 23
        Height = 17
        Caption = 'V3 :'
      end
      object RadioButtonM2: TRadioButton
        Left = 193
        Top = 25
        Width = 170
        Height = 17
        Caption = #51204#51068#48320#46041#54253#51060' V2 pt. '#51060#49345
        TabOrder = 0
        OnClick = OptionChange
      end
      object RadioButtonM1: TRadioButton
        Left = 7
        Top = 25
        Width = 170
        Height = 17
        Caption = #51204#51068#51060' '#51204#51204#51068#51032'  V1 '#48176#51060#49345
        TabOrder = 1
        OnClick = OptionChange
      end
      object RadioButtonM3: TRadioButton
        Left = 399
        Top = 25
        Width = 170
        Height = 17
        Caption = #51204#51068#48320#46041#47456#51060' V3 % '#51060#49345
        TabOrder = 2
        OnClick = OptionChange
      end
      object EditM1V1: TEdit
        Left = 73
        Top = 48
        Width = 80
        Height = 25
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
        OnKeyPress = EditKeyPress
      end
      object EditM2V1: TEdit
        Left = 257
        Top = 48
        Width = 80
        Height = 25
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 4
        OnKeyPress = EditKeyPress
      end
      object EditM3V1: TEdit
        Left = 465
        Top = 49
        Width = 80
        Height = 25
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 5
        OnKeyPress = EditKeyPress
      end
    end
    object Panel3: TPanel
      Left = 2
      Top = 85
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
    end
    object GroupBoxMajorType: TGroupBox
      Left = 2
      Top = 92
      Width = 596
      Height = 46
      Align = alTop
      Caption = #44032#44201#51648#54364
      TabOrder = 2
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
      Caption = 'BaseLine '#48708#52628#49464'1'
      Color = 14598235
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      Padding.Bottom = 5
      ParentBackground = False
      ParentFont = False
      TabOrder = 3
      StyleElements = []
    end
    object Panel5: TPanel
      Left = 2
      Top = 28
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 4
    end
    object GroupBoxOptionManagement: TGroupBox
      Left = 2
      Top = 35
      Width = 596
      Height = 50
      Align = alTop
      Caption = #51200#51109#44284' '#51201#50857
      TabOrder = 5
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
    object GroupBox1: TGroupBox
      Left = 2
      Top = 234
      Width = 596
      Height = 75
      Align = alTop
      TabOrder = 6
      object Label4: TLabel
        Left = 7
        Top = 25
        Width = 153
        Height = 17
        BiDiMode = bdLeftToRight
        Caption = #44592#51456#49440#44284' '#48708#44368#54624' '#44032#44201#49440'  :'
        ParentBiDiMode = False
      end
      object ComboBoxPRICEMETHOD: TComboBox
        Left = 7
        Top = 44
        Width = 148
        Height = 25
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ItemIndex = 0
        TabOrder = 0
        Text = #51333#44032
        OnChange = OptionChange
        Items.Strings = (
          #51333#44032
          #44256#44032'.'#51200#44032
          '('#44256#44032'+'#51200#44032')/2'
          #48380#47004#51200#48180#46300#51032' '#49345#54616#54620#49440)
      end
      object ButtonPRICEMETHOD: TButton
        Left = 161
        Top = 44
        Width = 26
        Height = 21
        Caption = '...'
        TabOrder = 1
        OnClick = ButtonPRICEMETHODClick
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 138
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 7
    end
    object Panel6: TPanel
      Left = 2
      Top = 227
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 8
    end
    object Panel7: TPanel
      Left = 2
      Top = 309
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 9
    end
    object GroupBox3: TGroupBox
      Left = 2
      Top = 316
      Width = 596
      Height = 85
      Align = alTop
      Caption = #54728#50857#48276#50948
      TabOrder = 10
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
    Left = 60
    Top = 538
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
