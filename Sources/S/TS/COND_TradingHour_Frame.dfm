inherited TradingHour_Frame: TTradingHour_Frame
  Width = 600
  Height = 400
  Font.Charset = ANSI_CHARSET
  Font.Height = -13
  Font.Name = #47569#51008' '#44256#46357
  ParentFont = False
  ExplicitWidth = 600
  ExplicitHeight = 400
  object Panel9: TPanel
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
    ParentColor = True
    TabOrder = 0
    object GroupBox5: TGroupBox
      Left = 2
      Top = 178
      Width = 596
      Height = 106
      Align = alTop
      Caption = #51221#44508#51109
      TabOrder = 0
      object Label89: TLabel
        Left = 10
        Top = 46
        Width = 34
        Height = 17
        Caption = #49884#51089' :'
      end
      object Label90: TLabel
        Left = 10
        Top = 73
        Width = 34
        Height = 17
        Caption = #47560#44048' :'
      end
      object DateTimePickerREGULAR_STOP_TIME: TDateTimePicker
        Left = 57
        Top = 66
        Width = 100
        Height = 25
        Date = 41114.430841481480000000
        Format = 'HH:mm:ss'
        Time = 41114.430841481480000000
        ImeName = 'Microsoft Office IME 2007'
        Kind = dtkTime
        TabOrder = 1
        OnChange = OptionChange
      end
      object DateTimePickerREGULAR_START_TIME: TDateTimePicker
        Left = 57
        Top = 43
        Width = 100
        Height = 25
        Date = 41114.430841481480000000
        Format = 'HH:mm:ss'
        Time = 41114.430841481480000000
        ImeName = 'Microsoft Office IME 2007'
        Kind = dtkTime
        TabOrder = 0
        OnChange = OptionChange
      end
      object CheckBoxUSE_REGULAR_MARKET: TCheckBox
        Left = 10
        Top = 20
        Width = 120
        Height = 17
        Caption = #49324#50857#50668#48512
        TabOrder = 2
        OnClick = OptionChange
      end
    end
    object GroupBox1: TGroupBox
      Left = 2
      Top = 92
      Width = 596
      Height = 79
      Align = alTop
      Caption = #51204#49328#51109
      TabOrder = 1
      object Label4: TLabel
        Left = 10
        Top = 27
        Width = 16
        Height = 17
        Caption = 'X :'
      end
      object Label5: TLabel
        Left = 10
        Top = 49
        Width = 15
        Height = 17
        Caption = 'Y :'
      end
      object Label6: TLabel
        Left = 268
        Top = 25
        Width = 34
        Height = 17
        Caption = #49884#51089' :'
      end
      object Label7: TLabel
        Left = 268
        Top = 50
        Width = 34
        Height = 17
        Caption = #47560#44048' :'
      end
      object Label2: TLabel
        Left = 93
        Top = 27
        Width = 137
        Height = 17
        Caption = #51109#49884#51089' '#54980'  X'#48516' '#44221#44284' '#54980
      end
      object Label3: TLabel
        Left = 93
        Top = 48
        Width = 118
        Height = 17
        Caption = #51109#47560#44048' '#51204'  Y'#48516' '#51060#51204
      end
      object DateTimePickerSTOP_TIME: TDateTimePicker
        Left = 315
        Top = 45
        Width = 100
        Height = 25
        Date = 41114.430841481480000000
        Format = 'HH:mm:ss'
        Time = 41114.430841481480000000
        Enabled = False
        ImeName = 'Microsoft Office IME 2007'
        Kind = dtkTime
        TabOrder = 1
      end
      object DateTimePickerSTART_TIME: TDateTimePicker
        Left = 315
        Top = 21
        Width = 100
        Height = 25
        Date = 41114.430841481480000000
        Format = 'HH:mm:ss'
        Time = 41114.430841481480000000
        Enabled = False
        ImeName = 'Microsoft Office IME 2007'
        Kind = dtkTime
        TabOrder = 0
      end
      object EditSTOP_OFFSET: TEdit
        Left = 32
        Top = 45
        Width = 40
        Height = 25
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
        Text = '2'
        OnChange = EditChange
        OnKeyPress = EditKeyPress
      end
      object UpDownSTOP_OFFSET: TUpDown
        Left = 72
        Top = 45
        Width = 15
        Height = 25
        Associate = EditSTOP_OFFSET
        Min = 2
        Max = 600
        Position = 2
        TabOrder = 3
        OnClick = UpDownClick
      end
      object UpDownSTART_OFFSET: TUpDown
        Left = 72
        Top = 22
        Width = 15
        Height = 25
        Associate = EditSTART_OFFSET
        Min = 1
        Max = 300
        Position = 3
        TabOrder = 4
        OnClick = UpDownClick
      end
      object EditSTART_OFFSET: TEdit
        Left = 32
        Top = 22
        Width = 40
        Height = 25
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 5
        Text = '3'
        OnChange = EditChange
        OnKeyPress = EditKeyPress
      end
    end
    object Panel1: TPanel
      Left = 2
      Top = 171
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
    end
    object GroupBoxOptionManagement: TGroupBox
      Left = 2
      Top = 35
      Width = 596
      Height = 50
      Align = alTop
      Caption = #51200#51109#44284' '#51201#50857
      TabOrder = 3
      object ComboBoxOptionCollection: TComboBox
        Left = 8
        Top = 20
        Width = 148
        Height = 25
        Style = csDropDownList
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 0
        OnChange = ComboBoxOptionCollectionChange
      end
      object ButtonPopupMenu: TButton
        Left = 162
        Top = 20
        Width = 26
        Height = 26
        Caption = '...'
        TabOrder = 1
        OnClick = ButtonPopupMenuClick
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 85
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 4
    end
    object Panel3: TPanel
      Left = 2
      Top = 28
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 5
    end
    object Panel4: TPanel
      Left = 2
      Top = 2
      Width = 596
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      Caption = #44144#47000#49884#44036
      Color = 14598235
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      Padding.Bottom = 5
      ParentBackground = False
      ParentFont = False
      TabOrder = 6
      StyleElements = []
    end
    object Panel5: TPanel
      Left = 2
      Top = 284
      Width = 596
      Height = 7
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 7
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 291
      Width = 596
      Height = 106
      Align = alTop
      Caption = #44077#52376#47532
      TabOrder = 8
      object Label1: TLabel
        Left = 10
        Top = 47
        Width = 104
        Height = 17
        Caption = #52628#44032#54624' '#49884#44036' ('#48516') :'
      end
      object CheckBoxUSER_GAB_PROCESS: TCheckBox
        Left = 10
        Top = 20
        Width = 120
        Height = 17
        Caption = #49324#50857#50668#48512
        TabOrder = 0
        OnClick = CheckBoxUSER_GAB_PROCESSClick
      end
      object EditGAB_INSERT_MIN: TEdit
        Left = 121
        Top = 43
        Width = 40
        Height = 25
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
        Text = '3'
        OnChange = EditGAB_INSERT_MINChange
        OnKeyPress = EditKeyPress
      end
      object UpDownGAB_INSERT_MIN: TUpDown
        Left = 161
        Top = 43
        Width = 15
        Height = 25
        Associate = EditGAB_INSERT_MIN
        Min = 1
        Max = 14400
        Position = 3
        TabOrder = 2
        OnClick = UpDownGAB_INSERT_MINClick
      end
    end
  end
  object PopupMenuOption: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    Left = 42
    Top = 444
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
