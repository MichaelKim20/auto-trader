object SelPriceLineDlg: TSelPriceLineDlg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = #44032#44201#51012' '#45824#52404
  ClientHeight = 420
  ClientWidth = 597
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 17
  object Label9: TLabel
    Left = 13
    Top = 21
    Width = 628
    Height = 17
    Caption = #44592#51456#49440#46608#45716' '#48372#51312#51648#54364#50752' '#44032#44201#49440#51032' '#48708#44368#54616#45716' '#44275#50640#49436'.. '#45800#49692#44032#44201#51060' '#50500#45208#46972' '#45796#47480' '#51648#54364#47484' '#49324#50857#54624' '#49688' '#51080#46020#47197' '#54620#45796'.'
  end
  object OKBtn: TButton
    Left = 334
    Top = 385
    Width = 100
    Height = 25
    Caption = #54869#51064
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 462
    Top = 385
    Width = 100
    Height = 25
    Cancel = True
    Caption = #52712#49548
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 9
    Top = 49
    Width = 580
    Height = 320
    TabOrder = 2
    object Bevel1: TBevel
      Left = 0
      Top = 80
      Width = 580
      Height = 2
      Shape = bsFrame
    end
    object Label1: TLabel
      Left = 48
      Top = 52
      Width = 91
      Height = 17
      Caption = #51060#54217#49328#52636#44592#44036' : '
    end
    object Label2: TLabel
      Left = 48
      Top = 127
      Width = 91
      Height = 17
      Caption = #51060#54217#49328#52636#44592#44036' : '
    end
    object Label3: TLabel
      Left = 48
      Top = 209
      Width = 91
      Height = 17
      Caption = #51060#54217#49328#52636#44592#44036' : '
    end
    object Label4: TLabel
      Left = 256
      Top = 52
      Width = 78
      Height = 17
      Caption = #51060#54217#51032' '#51333#47448' :'
    end
    object Label5: TLabel
      Left = 256
      Top = 127
      Width = 78
      Height = 17
      Caption = #51060#54217#51032' '#51333#47448' :'
    end
    object Label6: TLabel
      Left = 256
      Top = 209
      Width = 78
      Height = 17
      Caption = #51060#54217#51032' '#51333#47448' :'
    end
    object Label7: TLabel
      Left = 48
      Top = 288
      Width = 65
      Height = 17
      Caption = #49328#52636#44592#44036' : '
    end
    object Label8: TLabel
      Left = 256
      Top = 288
      Width = 226
      Height = 17
      Caption = #49345#54616#54620#49440#51032' '#50948#52824'('#54364#51456#54200#52264#51032' '#47751#48176#49688') : '
    end
    object Bevel2: TBevel
      Left = 0
      Top = 160
      Width = 580
      Height = 2
      Shape = bsFrame
    end
    object Bevel3: TBevel
      Left = 0
      Top = 240
      Width = 580
      Height = 2
      Shape = bsFrame
    end
    object RadioButtonPRICEMETHOD0: TRadioButton
      Left = 30
      Top = 21
      Width = 200
      Height = 17
      Caption = #51333#44032#47484' '#49324#50857
      TabOrder = 0
    end
    object RadioButtonPRICEMETHOD1: TRadioButton
      Left = 30
      Top = 98
      Width = 200
      Height = 17
      Caption = #44256#44032#50752' '#51200#44032#47484#49324#50857
      TabOrder = 1
    end
    object RadioButtonPRICEMETHOD2: TRadioButton
      Left = 30
      Top = 178
      Width = 200
      Height = 17
      Caption = '('#44256#44032' + '#51200#44032')/2 '#47484' '#49324#50857
      TabOrder = 2
    end
    object RadioButtonPRICEMETHOD3: TRadioButton
      Left = 30
      Top = 258
      Width = 200
      Height = 17
      Caption = #48380#47536#51200#48180#46300#51032' '#49345#54616#54620#49440#51012' '#49324#50857
      TabOrder = 3
    end
    object EditPM1_V1: TEdit
      Left = 138
      Top = 49
      Width = 65
      Height = 25
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      TabOrder = 4
      Text = '1'
    end
    object UpDownPM1_V1: TUpDown
      Left = 203
      Top = 49
      Width = 15
      Height = 25
      Associate = EditPM1_V1
      Min = 1
      Max = 1200
      Position = 1
      TabOrder = 5
    end
    object EditPM2_V1: TEdit
      Left = 138
      Top = 125
      Width = 65
      Height = 25
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      TabOrder = 6
      Text = '1'
    end
    object UpDownPM2_V1: TUpDown
      Left = 203
      Top = 125
      Width = 15
      Height = 25
      Associate = EditPM2_V1
      Min = 1
      Max = 1200
      Position = 1
      TabOrder = 7
    end
    object EditPM3_V1: TEdit
      Left = 138
      Top = 206
      Width = 65
      Height = 25
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      TabOrder = 8
      Text = '1'
    end
    object UpDownPM3_V1: TUpDown
      Left = 203
      Top = 206
      Width = 15
      Height = 25
      Associate = EditPM3_V1
      Min = 1
      Max = 1200
      Position = 1
      TabOrder = 9
    end
    object ComboBoxPM1_V2: TComboBox
      Left = 334
      Top = 49
      Width = 145
      Height = 25
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      ItemIndex = 0
      TabOrder = 10
      Text = #45800#49692#51060#46041#54217#44512#49440
      Items.Strings = (
        #45800#49692#51060#46041#54217#44512#49440
        #44032#51473#51060#46041#54217#44512#49440
        #51648#49688#51060#46041#54217#44512#49440)
    end
    object ComboBoxPM2_V2: TComboBox
      Left = 334
      Top = 125
      Width = 145
      Height = 25
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      ItemIndex = 0
      TabOrder = 11
      Text = #45800#49692#51060#46041#54217#44512#49440
      Items.Strings = (
        #45800#49692#51060#46041#54217#44512#49440
        #44032#51473#51060#46041#54217#44512#49440
        #51648#49688#51060#46041#54217#44512#49440)
    end
    object ComboBoxPM3_V2: TComboBox
      Left = 334
      Top = 206
      Width = 145
      Height = 25
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      ItemIndex = 0
      TabOrder = 12
      Text = #45800#49692#51060#46041#54217#44512#49440
      Items.Strings = (
        #45800#49692#51060#46041#54217#44512#49440
        #44032#51473#51060#46041#54217#44512#49440
        #51648#49688#51060#46041#54217#44512#49440)
    end
    object EditPM4_V1: TEdit
      Left = 138
      Top = 285
      Width = 65
      Height = 25
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      TabOrder = 13
      Text = '1'
    end
    object UpDownPM4_V1: TUpDown
      Left = 203
      Top = 285
      Width = 15
      Height = 25
      Associate = EditPM4_V1
      Min = 1
      Max = 1200
      Position = 1
      TabOrder = 14
    end
    object EditPM4_V2: TEdit
      Left = 472
      Top = 285
      Width = 65
      Height = 25
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      TabOrder = 15
      Text = '2'
    end
    object UpDownPM4_V2: TUpDown
      Left = 537
      Top = 285
      Width = 15
      Height = 25
      Associate = EditPM4_V2
      Min = 2
      Max = 5
      Position = 2
      TabOrder = 16
    end
  end
end
