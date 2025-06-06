inherited MKI_T1_Frame: TMKI_T1_Frame
  Width = 517
  Height = 469
  Font.Charset = ANSI_CHARSET
  Font.Height = -13
  Font.Name = #47569#51008' '#44256#46357
  ParentFont = False
  ExplicitWidth = 517
  ExplicitHeight = 469
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 517
    Height = 469
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 2
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    TabOrder = 0
    object Panel2: TPanel
      Left = 2
      Top = 229
      Width = 513
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitTop = 221
    end
    object Panel3: TPanel
      Left = 2
      Top = 85
      Width = 513
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitTop = 81
    end
    object GroupBoxMajorType: TGroupBox
      Left = 2
      Top = 92
      Width = 513
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
      Width = 513
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      Caption = 'MKI '#52628#49464' 1'
      Color = 12024371
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
      Width = 513
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 4
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 149
      Width = 513
      Height = 80
      Align = alTop
      Caption = #51312#44148
      TabOrder = 5
      ExplicitTop = 141
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
    end
    object Panel6: TPanel
      Left = 2
      Top = 142
      Width = 513
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 6
      ExplicitTop = 134
    end
    object GroupBoxOptionManagement: TGroupBox
      Left = 2
      Top = 35
      Width = 513
      Height = 50
      Align = alTop
      Caption = #51200#51109#44284' '#51201#50857
      TabOrder = 7
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
  end
  object PopupMenuOption: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    Left = 330
    Top = 250
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
