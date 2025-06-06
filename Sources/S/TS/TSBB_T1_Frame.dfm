inherited BB_T1_Frame: TBB_T1_Frame
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
    object GroupBoxOptionManagement: TGroupBox
      Left = 2
      Top = 35
      Width = 596
      Height = 50
      Align = alTop
      Caption = #51200#51109#44284' '#51201#50857
      TabOrder = 0
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
        Width = 25
        Height = 26
        Caption = '...'
        PopupMenu = PopupMenuOption
        TabOrder = 1
        OnClick = ButtonPopupMenuClick
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
      Height = 50
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
      Caption = #48380#47536#51200#48180#46300' '#52628#49464
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
    object GroupBox2: TGroupBox
      Left = 2
      Top = 149
      Width = 596
      Height = 136
      Align = alTop
      Caption = #51312#44148
      TabOrder = 5
      object Label3: TLabel
        Left = 7
        Top = 21
        Width = 148
        Height = 17
        Caption = #44592#51456' '#48380#47536#51200#48180#46300#51032' '#49444#51221' :'
      end
      object Label1: TLabel
        Left = 188
        Top = 21
        Width = 191
        Height = 17
        Caption = '1. '#44592#51456'BB'#51032' '#48180#46300#54253#51060' P'#51060#54616#51068#46412
      end
      object Label5: TLabel
        Left = 188
        Top = 69
        Width = 191
        Height = 17
        Caption = '2. '#44592#51456'BB'#51032' '#48180#46300#54253#51060' P'#52488#44284#51068#46412
      end
      object Label4: TLabel
        Left = 389
        Top = 21
        Width = 179
        Height = 17
        BiDiMode = bdLeftToRight
        Caption = #48380#47536#51200#48180#46300#50752' '#48708#44368#54624' '#44032#44201#49440'  :'
        ParentBiDiMode = False
      end
      object Label2: TLabel
        Left = 7
        Top = 70
        Width = 166
        Height = 17
        Caption = #44592#51456' '#48380#47536#51200#48180#46300#51032' '#48180#46300#54253#51032
      end
      object Bevel1: TBevel
        Left = 7
        Top = 133
        Width = 170
        Height = 0
      end
      object Label6: TLabel
        Left = 7
        Top = 86
        Width = 127
        Height = 17
        Caption = #48516#44592#51216#51012' P'#46972#44256' '#54616#47732'..'
      end
      object EditLENGTH0: TEdit
        Left = 7
        Top = 40
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 0
        Text = '180'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH0: TUpDown
        Left = 47
        Top = 40
        Width = 15
        Height = 25
        Associate = EditLENGTH0
        Min = 1
        Max = 1200
        Position = 180
        TabOrder = 1
        OnClick = UpDownClick
      end
      object EditSIGMA0: TEdit
        Left = 70
        Top = 41
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 2
        Text = '2'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownSIGMA0: TUpDown
        Left = 110
        Top = 41
        Width = 15
        Height = 25
        Associate = EditSIGMA0
        Min = 1
        Max = 3
        Position = 2
        TabOrder = 3
        OnClick = UpDownClick
      end
      object EditLENGTH1: TEdit
        Left = 188
        Top = 39
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 4
        Text = '180'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH1: TUpDown
        Left = 228
        Top = 39
        Width = 15
        Height = 25
        Associate = EditLENGTH1
        Min = 1
        Max = 1200
        Position = 180
        TabOrder = 5
        OnClick = UpDownClick
      end
      object EditSIGMA1: TEdit
        Left = 251
        Top = 39
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 6
        Text = '2'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownSIGMA1: TUpDown
        Left = 291
        Top = 39
        Width = 15
        Height = 25
        Associate = EditSIGMA1
        Min = 1
        Max = 3
        Position = 2
        TabOrder = 7
        OnClick = UpDownClick
      end
      object EditLENGTH2: TEdit
        Left = 188
        Top = 87
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 8
        Text = '180'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH2: TUpDown
        Left = 228
        Top = 87
        Width = 15
        Height = 25
        Associate = EditLENGTH2
        Min = 1
        Max = 1200
        Position = 180
        TabOrder = 9
        OnClick = UpDownClick
      end
      object EditSIGMA2: TEdit
        Left = 249
        Top = 86
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 10
        Text = '1'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownSIGMA2: TUpDown
        Left = 289
        Top = 86
        Width = 15
        Height = 25
        Associate = EditSIGMA2
        Min = 1
        Max = 3
        Position = 1
        TabOrder = 11
        OnClick = UpDownClick
      end
      object ComboBoxPRICEMETHOD: TComboBox
        Left = 389
        Top = 40
        Width = 148
        Height = 25
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ItemIndex = 3
        TabOrder = 12
        Text = #48380#47004#51200#48180#46300#51032' '#49345#54616#54620#49440
        OnChange = OptionChange
        Items.Strings = (
          #51333#44032
          #44256#44032'.'#51200#44032
          '('#44256#44032'+'#51200#44032')/2'
          #48380#47004#51200#48180#46300#51032' '#49345#54616#54620#49440)
      end
      object ButtonPRICEMETHOD: TButton
        Left = 543
        Top = 40
        Width = 26
        Height = 26
        Caption = '...'
        TabOrder = 13
        OnClick = ButtonPRICEMETHODClick
      end
      object EditTHRESHOLD: TEdit
        Left = 7
        Top = 105
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 14
        Text = '10'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownTHRESHOLD: TUpDown
        Left = 47
        Top = 105
        Width = 15
        Height = 25
        Associate = EditTHRESHOLD
        Min = 1
        Max = 2000
        Position = 10
        TabOrder = 15
        OnClick = UpDownClick
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 142
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 6
    end
    object GroupBox1: TGroupBox
      Left = 2
      Top = 292
      Width = 596
      Height = 85
      Align = alTop
      Caption = #54728#50857#48276#50948
      TabOrder = 7
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
    object Panel6: TPanel
      Left = 2
      Top = 285
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 8
    end
  end
  object PopupMenuOption: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    Left = 128
    Top = 536
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
