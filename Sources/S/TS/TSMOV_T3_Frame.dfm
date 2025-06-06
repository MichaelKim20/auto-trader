inherited MOV_T3_Frame: TMOV_T3_Frame
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
      Width = 596
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      Caption = 'MOV '#52628#49464'3'
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
    object GroupBoxOptionManagement: TGroupBox
      Left = 2
      Top = 35
      Width = 596
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
    object Panel2: TPanel
      Left = 2
      Top = 142
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 5
      ExplicitTop = 134
    end
    object Panel6: TPanel
      Left = 2
      Top = 286
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 6
      ExplicitTop = 278
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 149
      Width = 596
      Height = 130
      Align = alTop
      Caption = #51648#54364#51312#44148
      TabOrder = 7
      ExplicitTop = 141
      object Label1: TLabel
        Left = 7
        Top = 25
        Width = 104
        Height = 17
        Caption = #51060#46041#54217#44512#49440' '#49444#51221' :'
      end
      object Label9: TLabel
        Left = 7
        Top = 103
        Width = 104
        Height = 17
        Caption = #51060#46041#54217#44512#49440' '#51333#47448' :'
      end
      object Label8: TLabel
        Left = 7
        Top = 78
        Width = 86
        Height = 17
        Caption = #49548#49688#51216#51088#47551#49688' :'
      end
      object EditLENGTH1: TEdit
        Left = 7
        Top = 45
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
      object ComboBoxAVERAGE_TYPE: TComboBox
        Left = 132
        Top = 100
        Width = 56
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ItemIndex = 1
        TabOrder = 2
        Text = #44032#51473
        OnChange = OptionChange
        Items.Strings = (
          #45800#49692
          #44032#51473
          #51648#49688)
      end
      object EditRF2_PRECISION: TEdit
        Left = 132
        Top = 73
        Width = 40
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 3
        Text = '1'
        OnChange = EditChange
      end
      object UpDownPRECISION: TUpDown
        Left = 172
        Top = 73
        Width = 15
        Height = 21
        Associate = EditRF2_PRECISION
        Min = 1
        Max = 1200
        Position = 1
        TabOrder = 4
        OnClick = UpDownClick
      end
    end
    object Panel7: TPanel
      Left = 2
      Top = 279
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 8
      ExplicitTop = 271
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
