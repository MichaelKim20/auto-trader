object SKMXFrame01: TSKMXFrame01
  Left = 0
  Top = 0
  Width = 765
  Height = 528
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #44404#47548
  Font.Style = []
  ParentBackground = False
  ParentColor = False
  ParentFont = False
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 765
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    Color = 8355711
    Padding.Left = 10
    Padding.Right = 10
    ParentBackground = False
    TabOrder = 0
    object CheckBox0: TCheckBox
      Left = 10
      Top = 0
      Width = 120
      Height = 26
      TabStop = False
      Align = alLeft
      Caption = 'SK Q('#53076#49828#54588')'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object CheckBox3: TCheckBox
      Tag = 3
      Left = 370
      Top = 0
      Width = 120
      Height = 26
      TabStop = False
      Align = alLeft
      Caption = 'SK Q '#49345#54644
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Tag = 2
      Left = 250
      Top = 0
      Width = 120
      Height = 26
      TabStop = False
      Align = alLeft
      Caption = 'SK Q '#45768#52992#51060
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = CheckBox1Click
    end
    object CheckBox1: TCheckBox
      Tag = 1
      Left = 130
      Top = 0
      Width = 120
      Height = 26
      TabStop = False
      Align = alLeft
      Caption = 'SK Q '#54637#49485
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = CheckBox1Click
    end
    object ComboBox_TimeFrame: TComboBox
      Left = 610
      Top = 2
      Width = 59
      Height = 20
      Style = csDropDownList
      ImeName = 'Microsoft Office IME 2007'
      ItemHeight = 12
      TabOrder = 4
      TabStop = False
      Items.Strings = (
        '10'#52488
        '20'#52488
        '30'#52488
        '50'#52488
        '1'#48516
        '2'#48516
        '3'#48516
        '5'#48516
        '10'#48516
        '15'#48516
        '20'#48516
        '30'#48516)
    end
    object RadioButton1: TRadioButton
      Left = 490
      Top = 0
      Width = 60
      Height = 26
      Align = alLeft
      Caption = #52884#46308
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = #44404#47548
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object RadioButton2: TRadioButton
      Left = 550
      Top = 0
      Width = 60
      Height = 26
      Align = alLeft
      Caption = #49440
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = #44404#47548
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 58
    Width = 765
    Height = 412
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    ExplicitLeft = -3
    ExplicitTop = 57
  end
  object Panel4: TPanel
    Left = 0
    Top = 26
    Width = 765
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    Padding.Left = 3
    Padding.Top = 3
    Padding.Right = 3
    Padding.Bottom = 3
    TabOrder = 2
    object GridPanel1: TGridPanel
      Left = 3
      Top = 3
      Width = 759
      Height = 26
      Align = alClient
      BevelOuter = bvNone
      Caption = 'GridPanel1'
      ColumnCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 3.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = CFNTickerItem1
          Row = 0
        end
        item
          Column = 1
          Control = Panel6
          Row = 0
        end
        item
          Column = 2
          Control = CFNTickerItem2
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 0
      DesignSize = (
        759
        26)
      object CFNTickerItem1: CFNTickerItem
        Left = 0
        Top = 0
        Width = 378
        Height = 26
        Align = alClient
        BgFrameWidth = 1
        BgColor = clBtnFace
        BgFrameColor = 9474192
        MajorType = 0
      end
      object Panel6: TPanel
        Left = 378
        Top = 0
        Width = 3
        Height = 26
        Anchors = []
        BevelOuter = bvNone
        TabOrder = 1
      end
      object CFNTickerItem2: CFNTickerItem
        Left = 381
        Top = 0
        Width = 378
        Height = 26
        Align = alClient
        BgFrameWidth = 1
        BgColor = clBtnFace
        BgFrameColor = 9474192
        MajorType = 0
      end
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 470
    Width = 765
    Height = 58
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    Padding.Left = 5
    Padding.Top = 5
    Padding.Right = 5
    Padding.Bottom = 5
    ParentBackground = False
    TabOrder = 3
    object Panel3: TPanel
      Left = 5
      Top = 5
      Width = 755
      Height = 48
      Align = alClient
      BevelKind = bkFlat
      BevelOuter = bvNone
      Padding.Left = 15
      Padding.Top = 5
      Padding.Right = 15
      Padding.Bottom = 5
      TabOrder = 0
      object Label1: TLabel
        Left = 15
        Top = 25
        Width = 721
        Height = 20
        Align = alTop
        AutoSize = False
        Caption = '    '#51060#50857#54616#49884#44592' '#48148#46989#45768#45796'. '
        ExplicitLeft = 6
        ExplicitTop = 19
        ExplicitWidth = 753
      end
      object Label2: TLabel
        Left = 15
        Top = 5
        Width = 721
        Height = 20
        Align = alTop
        AutoSize = False
        Caption = 
          #8251' '#50948' '#52264#53944' '#53076#49828#54588#49440#47932' '#50808#51032' SK Q'#52264#53944#45716' '#48324#46020#47196' '#49884#49828#53596' '#49345#44288#48516#49437#51012' '#53685#54616#50668' '#47564#46304' '#48372#51312#52264#53944#47196#50024' '#53804#51088' '#51648#54364' '#54876#50857#51032' '#52280#44256 +
          #50857#51004#47196#47564' '
        ExplicitLeft = 6
        ExplicitTop = 6
        ExplicitWidth = 753
      end
    end
  end
end
