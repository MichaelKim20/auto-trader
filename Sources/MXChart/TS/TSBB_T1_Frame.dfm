inherited BB_T1_Frame: TBB_T1_Frame
  Width = 198
  Height = 600
  ExplicitWidth = 198
  ExplicitHeight = 600
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 198
    Height = 600
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 2
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    TabOrder = 0
    object GroupBoxOptionManagement: TGroupBox
      Left = 2
      Top = 31
      Width = 194
      Height = 46
      Align = alTop
      Caption = #51200#51109#44284' '#51201#50857
      TabOrder = 0
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
    object Panel3: TPanel
      Left = 2
      Top = 77
      Width = 194
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
    end
    object GroupBoxMajorType: TGroupBox
      Left = 2
      Top = 84
      Width = 194
      Height = 46
      Align = alTop
      Caption = #44032#44201#51648#54364
      TabOrder = 2
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
      Width = 194
      Height = 22
      Align = alTop
      BevelKind = bkFlat
      BevelOuter = bvNone
      Caption = #48380#47536#51200#48180#46300' '#52628#49464
      Color = 10331807
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548
      Font.Style = [fsBold]
      Padding.Bottom = 5
      ParentBackground = False
      ParentFont = False
      TabOrder = 3
    end
    object Panel5: TPanel
      Left = 2
      Top = 24
      Width = 194
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 4
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 137
      Width = 194
      Height = 284
      Align = alTop
      Caption = #51312#44148
      TabOrder = 5
      object Label3: TLabel
        Left = 7
        Top = 21
        Width = 133
        Height = 13
        Caption = #44592#51456' '#48380#47536#51200#48180#46300#51032' '#49444#51221' :'
      end
      object Label1: TLabel
        Left = 7
        Top = 131
        Width = 169
        Height = 13
        Caption = '1. '#44592#51456'BB'#51032' '#48180#46300#54253#51060' P'#51060#54616#51068#46412
      end
      object Label5: TLabel
        Left = 7
        Top = 179
        Width = 169
        Height = 13
        Caption = '2. '#44592#51456'BB'#51032' '#48180#46300#54253#51060' P'#52488#44284#51068#46412
      end
      object Label4: TLabel
        Left = 7
        Top = 233
        Width = 160
        Height = 13
        BiDiMode = bdLeftToRight
        Caption = #48380#47536#51200#48180#46300#50752' '#48708#44368#54624' '#44032#44201#49440'  :'
        ParentBiDiMode = False
      end
      object Label2: TLabel
        Left = 7
        Top = 70
        Width = 150
        Height = 13
        Caption = #44592#51456' '#48380#47536#51200#48180#46300#51032' '#48180#46300#54253#51032
      end
      object Bevel2: TBevel
        Left = 12
        Top = 227
        Width = 170
        Height = 2
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
        Width = 116
        Height = 13
        Caption = #48516#44592#51216#51012' P'#46972#44256' '#54616#47732'..'
      end
      object EditLENGTH0: TEdit
        Left = 7
        Top = 40
        Width = 40
        Height = 21
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
        Height = 21
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
        Height = 21
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
        Height = 21
        Associate = EditSIGMA0
        Min = 1
        Max = 3
        Position = 2
        TabOrder = 3
        OnClick = UpDownClick
      end
      object EditLENGTH1: TEdit
        Left = 7
        Top = 149
        Width = 40
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 4
        Text = '180'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH1: TUpDown
        Left = 47
        Top = 149
        Width = 15
        Height = 21
        Associate = EditLENGTH1
        Min = 1
        Max = 1200
        Position = 180
        TabOrder = 5
        OnClick = UpDownClick
      end
      object EditSIGMA1: TEdit
        Left = 70
        Top = 149
        Width = 40
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 6
        Text = '2'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownSIGMA1: TUpDown
        Left = 110
        Top = 149
        Width = 15
        Height = 21
        Associate = EditSIGMA1
        Min = 1
        Max = 3
        Position = 2
        TabOrder = 7
        OnClick = UpDownClick
      end
      object EditLENGTH2: TEdit
        Left = 7
        Top = 197
        Width = 40
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 8
        Text = '180'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH2: TUpDown
        Left = 47
        Top = 197
        Width = 15
        Height = 21
        Associate = EditLENGTH2
        Min = 1
        Max = 1200
        Position = 180
        TabOrder = 9
        OnClick = UpDownClick
      end
      object EditSIGMA2: TEdit
        Left = 68
        Top = 196
        Width = 40
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 10
        Text = '1'
        OnChange = OptionChange
        OnKeyPress = EditKeyPress
      end
      object UpDownSIGMA2: TUpDown
        Left = 108
        Top = 196
        Width = 15
        Height = 21
        Associate = EditSIGMA2
        Min = 1
        Max = 3
        Position = 1
        TabOrder = 11
        OnClick = UpDownClick
      end
      object ComboBoxPRICEMETHOD: TComboBox
        Left = 7
        Top = 254
        Width = 148
        Height = 21
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ItemHeight = 13
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
        Left = 161
        Top = 254
        Width = 26
        Height = 21
        Caption = '...'
        TabOrder = 13
        OnClick = ButtonPRICEMETHODClick
      end
      object EditTHRESHOLD: TEdit
        Left = 7
        Top = 105
        Width = 40
        Height = 21
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
        Height = 21
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
      Top = 130
      Width = 194
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 6
    end
    object GroupBox1: TGroupBox
      Left = 2
      Top = 428
      Width = 194
      Height = 85
      Align = alTop
      Caption = #54728#50857#48276#50948
      TabOrder = 7
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
    object Panel6: TPanel
      Left = 2
      Top = 421
      Width = 194
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
