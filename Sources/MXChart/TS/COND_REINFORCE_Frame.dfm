inherited REINFORCE_Frame: TREINFORCE_Frame
  Width = 200
  Height = 625
  ExplicitWidth = 200
  ExplicitHeight = 625
  object Panel9: TPanel
    Left = 0
    Top = 0
    Width = 200
    Height = 625
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
    object Panel2: TPanel
      Left = 2
      Top = 454
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
    end
    object Panel3: TPanel
      Left = 2
      Top = 520
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
    end
    object Panel1: TPanel
      Left = 2
      Top = 27
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
    end
    object GroupBox1: TGroupBox
      Left = 2
      Top = 34
      Width = 196
      Height = 257
      Align = alTop
      Caption = #48372#44053#51312#44148'1-'#44592#51456#49440
      TabOrder = 3
      object Label2: TLabel
        Left = 7
        Top = 50
        Width = 88
        Height = 12
        BiDiMode = bdLeftToRight
        Caption = #44592#51456#49440#51032' '#51333#47448' : '
        ParentBiDiMode = False
      end
      object Label4: TLabel
        Left = 7
        Top = 103
        Width = 140
        Height = 12
        BiDiMode = bdLeftToRight
        Caption = #44592#51456#49440#44284' '#48708#44368#54624' '#44032#44201#49440'  :'
        ParentBiDiMode = False
      end
      object Label1: TLabel
        Left = 7
        Top = 77
        Width = 100
        Height = 12
        BiDiMode = bdLeftToRight
        Caption = #44032#44201#51648#54364#51032' '#51333#47448' : '
        ParentBiDiMode = False
      end
      object ComboBoxRF1_STD_VALUE: TComboBox
        Left = 107
        Top = 45
        Width = 80
        Height = 20
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ItemHeight = 12
        ItemIndex = 0
        TabOrder = 0
        Text = #51204#51068#51333#44032
        OnChange = OptionChange
        Items.Strings = (
          #51204#51068#51333#44032
          #45817#51068#49884#44032)
      end
      object ButtonRF1_PRICEMETHOD: TButton
        Left = 161
        Top = 124
        Width = 26
        Height = 21
        Caption = '...'
        TabOrder = 1
        OnClick = ButtonRF1_PRICEMETHODClick
      end
      object ComboBoxRF1_PRICEMETHOD: TComboBox
        Left = 7
        Top = 124
        Width = 148
        Height = 20
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ItemHeight = 12
        ItemIndex = 3
        TabOrder = 2
        Text = #48380#47004#51200#48180#46300#51032' '#49345#54616#54620#49440
        OnChange = OptionChange
        Items.Strings = (
          #51333#44032
          #44256#44032'.'#51200#44032
          '('#44256#44032'+'#51200#44032')/2'
          #48380#47004#51200#48180#46300#51032' '#49345#54616#54620#49440)
      end
      object CheckBoxRF1_USE_CONDITION: TCheckBox
        Left = 7
        Top = 25
        Width = 179
        Height = 17
        Caption = #49324#50857#50976#47924
        TabOrder = 3
        OnClick = OptionChange
      end
      object ComboBoxRF1_VALUE_TYPE: TComboBox
        Left = 107
        Top = 71
        Width = 79
        Height = 20
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ItemHeight = 12
        TabOrder = 4
        OnChange = OptionChange
        Items.Strings = (
          #44032#44201
          'OPS')
      end
      object GroupBox4: TGroupBox
        Left = 5
        Top = 155
        Width = 187
        Height = 91
        Caption = #54728#50857#48276#50948
        TabOrder = 5
        object Label3: TLabel
          Left = 7
          Top = 55
          Width = 12
          Height = 12
          Caption = '+-'
        end
        object CheckBoxRF1_USE_TOLERANCE: TCheckBox
          Left = 7
          Top = 25
          Width = 174
          Height = 17
          Caption = #49324#50857#50976#47924
          TabOrder = 0
          OnClick = OptionChange
        end
        object EditRF1_TOLERANCE: TEdit
          Left = 25
          Top = 52
          Width = 65
          Height = 20
          ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
          TabOrder = 1
          Text = '300'
          OnKeyPress = EditKeyPress
        end
        object ComboBoxRF1_TOLERANCE_UNIT: TComboBox
          Left = 100
          Top = 52
          Width = 81
          Height = 20
          Style = csDropDownList
          ImeName = 'Microsoft Office IME 2007'
          ItemHeight = 12
          TabOrder = 2
          OnChange = OptionChange
          Items.Strings = (
            #54140#49468#53944
            #51208#45824#44050)
        end
      end
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 461
      Width = 196
      Height = 59
      Align = alTop
      Caption = #48708#52628#49464#51204#47029#49884' '#48152#45824#47588#47588
      TabOrder = 4
      object CheckBoxRF3_USE_CONDITION: TCheckBox
        Left = 7
        Top = 25
        Width = 186
        Height = 17
        Caption = #49324#50857#50976#47924
        TabOrder = 0
        OnClick = OptionChange
      end
    end
    object GroupBox3: TGroupBox
      Left = 2
      Top = 298
      Width = 196
      Height = 156
      Align = alTop
      Caption = #48372#44053#51312#44148'2-'#51068#44036#52628#49464#51204#54872
      Padding.Left = 3
      Padding.Right = 3
      TabOrder = 5
      object Label12: TLabel
        Left = 7
        Top = 50
        Width = 100
        Height = 12
        BiDiMode = bdLeftToRight
        Caption = #44032#44201#51648#54364#51032' '#51333#47448' : '
        ParentBiDiMode = False
      end
      object Label7: TLabel
        Left = 7
        Top = 75
        Width = 96
        Height = 12
        Caption = #51060#46041#54217#44512#49440' '#49444#51221' :'
      end
      object Label8: TLabel
        Left = 7
        Top = 103
        Width = 80
        Height = 12
        Caption = #49548#49688#51216#51088#47551#49688' :'
      end
      object Label9: TLabel
        Left = 7
        Top = 131
        Width = 96
        Height = 12
        Caption = #51060#46041#54217#44512#49440' '#51333#47448' :'
      end
      object CheckBoxRF2_USE_CONDITION: TCheckBox
        Left = 7
        Top = 25
        Width = 186
        Height = 17
        Caption = #49324#50857#50976#47924
        TabOrder = 0
        OnClick = OptionChange
      end
      object ComboBoxRF2_VALUE_TYPE: TComboBox
        Left = 107
        Top = 45
        Width = 79
        Height = 20
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ItemHeight = 12
        TabOrder = 1
        OnChange = OptionChange
        Items.Strings = (
          #44032#44201
          'OPS')
      end
      object EditRF2_LENGTH: TEdit
        Left = 131
        Top = 71
        Width = 40
        Height = 20
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 2
        Text = '1'
        OnChange = EditChange
      end
      object UpDownRF2_LENGTH: TUpDown
        Left = 171
        Top = 71
        Width = 15
        Height = 20
        Associate = EditRF2_LENGTH
        Min = 1
        Max = 1200
        Position = 1
        TabOrder = 3
        OnClick = UpDownClick
      end
      object UpDownRF2_PRECISION: TUpDown
        Left = 171
        Top = 98
        Width = 15
        Height = 20
        Associate = EditRF2_PRECISION
        Min = 1
        Max = 1200
        Position = 1
        TabOrder = 4
        OnClick = UpDownClick
      end
      object EditRF2_PRECISION: TEdit
        Left = 131
        Top = 98
        Width = 40
        Height = 20
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 5
        Text = '1'
        OnChange = EditChange
      end
      object ComboBoxRF2_AVERAGE_TYPE: TComboBox
        Left = 131
        Top = 125
        Width = 56
        Height = 20
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        ItemHeight = 12
        ItemIndex = 1
        TabOrder = 6
        Text = #44032#51473
        OnChange = OptionChange
        Items.Strings = (
          #45800#49692
          #44032#51473
          #51648#49688)
      end
    end
    object Panel4: TPanel
      Left = 2
      Top = 291
      Width = 196
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 6
    end
    object Panel5: TPanel
      Left = 2
      Top = 5
      Width = 196
      Height = 22
      Align = alTop
      BevelKind = bkFlat
      BevelOuter = bvNone
      Caption = #48372#44053#51312#44148
      Color = 12692930
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #44404#47548
      Font.Style = [fsBold]
      Padding.Bottom = 5
      ParentBackground = False
      ParentFont = False
      TabOrder = 7
    end
  end
end
