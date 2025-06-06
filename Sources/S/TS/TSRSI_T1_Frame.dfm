inherited RSI_T1_Frame: TRSI_T1_Frame
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
      Top = 149
      Width = 596
      Height = 103
      Align = alTop
      Caption = #51312#44148
      TabOrder = 0
      object Label3: TLabel
        Left = 7
        Top = 25
        Width = 84
        Height = 17
        Caption = 'RSI '#44592#44036#49444#51221' :'
      end
      object Label4: TLabel
        Left = 7
        Top = 50
        Width = 78
        Height = 17
        Caption = #52488#44284' '#47588#49688#44428' :'
      end
      object Label5: TLabel
        Left = 7
        Top = 75
        Width = 78
        Height = 17
        Caption = #52488#44284' '#47588#46020#44428' :'
      end
      object EditLENGTH1: TEdit
        Left = 107
        Top = 22
        Width = 65
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 0
        Text = '1'
        OnChange = EditChange
        OnKeyPress = EditKeyPress
      end
      object UpDownLENGTH1: TUpDown
        Left = 172
        Top = 22
        Width = 15
        Height = 25
        Associate = EditLENGTH1
        Min = 1
        Max = 1200
        Position = 1
        TabOrder = 1
        OnClick = UpDownClick
      end
      object EditUP: TEdit
        Left = 107
        Top = 47
        Width = 65
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 2
        Text = '1'
        OnChange = EditChange
        OnKeyPress = EditKeyPress
      end
      object EditDN: TEdit
        Left = 107
        Top = 72
        Width = 65
        Height = 25
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 3
        Text = '1'
        OnChange = EditChange
        OnKeyPress = EditKeyPress
      end
      object UpDownUP: TUpDown
        Left = 172
        Top = 47
        Width = 15
        Height = 25
        Associate = EditUP
        Position = 1
        TabOrder = 4
        OnClick = UpDownClick
      end
      object UpDownDN: TUpDown
        Left = 172
        Top = 72
        Width = 15
        Height = 25
        Associate = EditDN
        Position = 1
        TabOrder = 5
        OnClick = UpDownClick
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
      Caption = 'RSI '#52628#49464
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
      TabOrder = 6
    end
    object GroupBox1: TGroupBox
      Left = 2
      Top = 259
      Width = 596
      Height = 85
      Align = alTop
      Caption = #54728#50857#48276#50948
      TabOrder = 7
      object Label1: TLabel
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
        OnClick = EditChange
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
        OnClick = EditChange
        Items.Strings = (
          #54140#49468#53944
          #51208#45824#44050)
      end
    end
    object Panel6: TPanel
      Left = 2
      Top = 252
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
    Left = 94
    Top = 458
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
