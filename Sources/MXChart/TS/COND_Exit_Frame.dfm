inherited Exit_Frame: TExit_Frame
  Width = 200
  Height = 600
  ExplicitWidth = 200
  ExplicitHeight = 600
  object Panel9: TPanel
    Left = 0
    Top = 0
    Width = 200
    Height = 600
    Align = alClient
    BevelOuter = bvNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548
    Font.Style = []
    Padding.Left = 2
    Padding.Top = 5
    Padding.Right = 2
    Padding.Bottom = 2
    ParentFont = False
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 2
      Top = 184
      Width = 196
      Height = 90
      Align = alTop
      Caption = #51060#51061#52397#49328
      TabOrder = 0
      object Label3: TLabel
        Left = 16
        Top = 57
        Width = 58
        Height = 12
        Caption = #51652#51077#44032#51032' +'
      end
      object Label4: TLabel
        Left = 143
        Top = 57
        Width = 10
        Height = 12
        Caption = '%'
      end
      object CheckBoxUSE_PROFITCUT: TCheckBox
        Left = 10
        Top = 25
        Width = 120
        Height = 17
        Caption = #49324#50857#50668#48512
        TabOrder = 0
        OnClick = OptionChange
      end
      object EditPROFITCUT_VALUE_1: TEdit
        Left = 80
        Top = 53
        Width = 57
        Height = 20
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 1
        OnChange = EditChange
      end
    end
    object GroupBoxOptionManagement: TGroupBox
      Left = 2
      Top = 34
      Width = 196
      Height = 46
      Align = alTop
      Caption = #51200#51109#44284' '#51201#50857
      TabOrder = 1
      object ComboBoxOptionCollection: TComboBox
        Left = 8
        Top = 20
        Width = 148
        Height = 20
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ItemHeight = 12
        TabOrder = 0
        OnChange = ComboBoxOptionCollectionChange
      end
      object ButtonPopupMenu: TButton
        Left = 162
        Top = 18
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 1
        OnClick = ButtonPopupMenuClick
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 274
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
    end
    object Panel3: TPanel
      Left = 2
      Top = 27
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 281
      Width = 196
      Height = 110
      Align = alTop
      Caption = 'Trailing Stop'
      TabOrder = 4
      object Label5: TLabel
        Left = 16
        Top = 57
        Width = 52
        Height = 12
        Caption = #51652#51077#44032#51032' '
      end
      object Label6: TLabel
        Left = 143
        Top = 57
        Width = 38
        Height = 12
        Caption = '% '#47785#54364
      end
      object Label7: TLabel
        Left = 16
        Top = 80
        Width = 60
        Height = 12
        Caption = #52572#45824#49688#51061#51032
      end
      object Label8: TLabel
        Left = 143
        Top = 80
        Width = 38
        Height = 12
        Caption = '% '#44048#49548
      end
      object CheckBoxUSE_TRAILINGSTOP: TCheckBox
        Left = 10
        Top = 25
        Width = 120
        Height = 17
        Caption = #49324#50857#50668#48512
        TabOrder = 0
        OnClick = OptionChange
      end
      object EditTRAILINGSTOP_VALUE_1: TEdit
        Left = 81
        Top = 52
        Width = 57
        Height = 20
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 1
        OnChange = EditChange
      end
      object EditTRAILINGSTOP_VALUE_2: TEdit
        Left = 81
        Top = 75
        Width = 57
        Height = 20
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 2
        OnChange = EditChange
      end
    end
    object GroupBox3: TGroupBox
      Left = 2
      Top = 87
      Width = 196
      Height = 90
      Align = alTop
      Caption = #49552#51208#52397#49328
      TabOrder = 5
      object Label1: TLabel
        Left = 16
        Top = 57
        Width = 58
        Height = 12
        Caption = #51652#51077#44032#51032' -'
      end
      object Label2: TLabel
        Left = 143
        Top = 57
        Width = 10
        Height = 12
        Caption = '%'
      end
      object CheckBoxUSE_LOSSCUT: TCheckBox
        Left = 10
        Top = 25
        Width = 120
        Height = 17
        Caption = #49324#50857#50668#48512
        TabOrder = 0
        OnClick = OptionChange
      end
      object EditLOSSCUT_VALUE_1: TEdit
        Left = 80
        Top = 53
        Width = 57
        Height = 20
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 1
        OnChange = EditChange
      end
    end
    object Panel1: TPanel
      Left = 2
      Top = 177
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 6
    end
    object Panel4: TPanel
      Left = 2
      Top = 80
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 7
    end
    object Panel5: TPanel
      Left = 2
      Top = 5
      Width = 196
      Height = 22
      Align = alTop
      BevelKind = bkFlat
      BevelOuter = bvNone
      Caption = #52397#49328
      Color = 14336188
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548
      Font.Style = [fsBold]
      Padding.Bottom = 5
      ParentBackground = False
      ParentFont = False
      TabOrder = 8
    end
  end
  object PopupMenuOption: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    Left = 98
    Top = 524
    object N1: TMenuItem
      Caption = #54788#51116' '#49444#51221#50640' '#51201#50857
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #51088#51452#49324#50857#51004#47196' '#51200#51109
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #44288#47532#52285' '#48372#44592
      OnClick = N3Click
    end
  end
end
