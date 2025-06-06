inherited DISPARITY_T1_Frame: TDISPARITY_T1_Frame
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
    object GroupBox2: TGroupBox
      Left = 2
      Top = 137
      Width = 196
      Height = 461
      Align = alClient
      Caption = #51312#44148
      TabOrder = 0
      object Label3: TLabel
        Left = 7
        Top = 25
        Width = 94
        Height = 13
        Caption = #51060#46041#54217#44512#49440' '#44592#44036' :'
      end
      object Label4: TLabel
        Left = 7
        Top = 82
        Width = 134
        Height = 13
        Caption = #52572#44256'/'#52572#51200#51216#51032' '#44160#52636#44592#44036' :'
      end
      object EditLENGTH1: TEdit
        Left = 7
        Top = 47
        Width = 65
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 0
        Text = '1'
        OnChange = EditChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH1: TUpDown
        Left = 72
        Top = 47
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
        Left = 7
        Top = 101
        Width = 65
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 2
        Text = '1'
        OnChange = EditChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH2: TUpDown
        Left = 72
        Top = 101
        Width = 15
        Height = 21
        Associate = EditLENGTH2
        Position = 1
        TabOrder = 3
        OnClick = UpDownClick
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 130
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
    end
    object Panel3: TPanel
      Left = 2
      Top = 77
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
    end
    object GroupBoxMajorType: TGroupBox
      Left = 2
      Top = 84
      Width = 196
      Height = 46
      Align = alTop
      Caption = #44032#44201#51648#54364
      TabOrder = 3
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
      Caption = 'Disparity '#52628#49464
      Color = 10331807
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548
      Font.Style = [fsBold]
      Padding.Bottom = 5
      ParentBackground = False
      ParentFont = False
      TabOrder = 4
    end
    object Panel5: TPanel
      Left = 2
      Top = 24
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 5
    end
    object GroupBoxOptionManagement: TGroupBox
      Left = 2
      Top = 31
      Width = 196
      Height = 46
      Align = alTop
      Caption = #51200#51109#44284' '#51201#50857
      TabOrder = 6
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
