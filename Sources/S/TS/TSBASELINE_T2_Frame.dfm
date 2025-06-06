inherited BASELINE_T2_Frame: TBASELINE_T2_Frame
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
    object GroupBox2: TGroupBox
      Left = 2
      Top = 145
      Width = 596
      Height = 80
      Align = alTop
      Caption = #51312#44148
      TabOrder = 0
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
        Top = 46
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
        Top = 46
        Width = 26
        Height = 26
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
      TabOrder = 1
    end
    object Panel3: TPanel
      Left = 2
      Top = 85
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
    end
    object GroupBoxMajorType: TGroupBox
      Left = 2
      Top = 92
      Width = 596
      Height = 46
      Align = alTop
      Caption = #44032#44201#51648#54364
      TabOrder = 3
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
      Caption = 'BaseLine '#52628#49464'2'
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
    object Panel5: TPanel
      Left = 2
      Top = 28
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 5
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
      Top = 225
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 7
    end
    object GroupBox3: TGroupBox
      Left = 2
      Top = 232
      Width = 596
      Height = 85
      Align = alTop
      Caption = #54728#50857#48276#50948
      TabOrder = 8
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
        Items.Strings = (
          #54140#49468#53944
          #51208#45824#44050)
      end
    end
  end
  object PopupMenuOption: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    Left = 18
    Top = 394
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
