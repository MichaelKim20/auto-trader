inherited Exit_Frame: TExit_Frame
  Width = 600
  Height = 546
  ExplicitWidth = 600
  ExplicitHeight = 546
  object Panel9: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 546
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 2
    Padding.Top = 5
    Padding.Right = 2
    Padding.Bottom = 2
    ParentColor = True
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 2
      Top = 192
      Width = 596
      Height = 90
      Align = alTop
      Caption = #51060#51061#52397#49328
      TabOrder = 0
      object Label3: TLabel
        Left = 107
        Top = 51
        Width = 175
        Height = 13
        Caption = #51652#51077#44032#51032' X% '#51060#49345' '#51060#51061#51060' '#48156#49373#54624' '#46412
      end
      object Label4: TLabel
        Left = 16
        Top = 52
        Width = 16
        Height = 13
        Caption = 'X : '
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
        Left = 44
        Top = 48
        Width = 57
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 1
        OnChange = EditChange
      end
    end
    object GroupBoxOptionManagement: TGroupBox
      Left = 2
      Top = 38
      Width = 596
      Height = 50
      Align = alTop
      Caption = #51200#51109#44284' '#51201#50857
      TabOrder = 1
      object ComboBoxOptionCollection: TComboBox
        Left = 8
        Top = 20
        Width = 148
        Height = 21
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 0
        OnChange = ComboBoxOptionCollectionChange
      end
      object ButtonPopupMenu: TButton
        Left = 162
        Top = 19
        Width = 26
        Height = 26
        Caption = '...'
        TabOrder = 1
        OnClick = ButtonPopupMenuClick
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 399
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
    end
    object Panel3: TPanel
      Left = 2
      Top = 31
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 289
      Width = 596
      Height = 110
      Align = alTop
      Caption = 'Trailing Stop'
      TabOrder = 4
      object Label5: TLabel
        Left = 107
        Top = 54
        Width = 107
        Height = 13
        Caption = #47785#54364#44032' : '#51652#51077#44032#51032' X%'
      end
      object Label7: TLabel
        Left = 108
        Top = 75
        Width = 154
        Height = 13
        Caption = #52397#49328#44032#44201' : '#52572#45824#49688#51061#51032' Y% '#44048#49548
      end
      object Label6: TLabel
        Left = 16
        Top = 53
        Width = 16
        Height = 13
        Caption = 'X : '
      end
      object Label8: TLabel
        Left = 16
        Top = 76
        Width = 16
        Height = 13
        Caption = 'X : '
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
        Left = 44
        Top = 48
        Width = 57
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 1
        OnChange = EditChange
      end
      object EditTRAILINGSTOP_VALUE_2: TEdit
        Left = 44
        Top = 74
        Width = 57
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 2
        OnChange = EditChange
      end
    end
    object GroupBox3: TGroupBox
      Left = 2
      Top = 95
      Width = 596
      Height = 90
      Align = alTop
      Caption = #49552#51208#52397#49328
      TabOrder = 5
      object Label2: TLabel
        Left = 16
        Top = 53
        Width = 13
        Height = 13
        Caption = 'X :'
      end
      object Label1: TLabel
        Left = 107
        Top = 51
        Width = 179
        Height = 13
        Caption = #51652#51077#44032#51032' -X% '#51060#54616' '#49552#49892#51060' '#48156#49373#54624' '#46412
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
        Left = 44
        Top = 48
        Width = 57
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 1
        OnChange = EditChange
      end
    end
    object Panel1: TPanel
      Left = 2
      Top = 185
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 6
    end
    object Panel4: TPanel
      Left = 2
      Top = 88
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 7
    end
    object Panel5: TPanel
      Left = 2
      Top = 5
      Width = 596
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      Caption = #52397#49328
      Color = 14598235
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      Padding.Bottom = 5
      ParentBackground = False
      ParentFont = False
      TabOrder = 8
      StyleElements = []
    end
    object Panel6: TPanel
      Left = 2
      Top = 282
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 9
    end
  end
  object PopupMenuOption: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    Left = 506
    Top = 324
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
