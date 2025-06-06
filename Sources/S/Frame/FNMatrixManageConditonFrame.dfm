object TMatrixBlockManageConditionFrame: TTMatrixBlockManageConditionFrame
  Left = 0
  Top = 0
  Width = 1149
  Height = 655
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
  object PageControlSummary: TPageControl
    Left = 0
    Top = 0
    Width = 1149
    Height = 655
    ActivePage = TabSheet5
    Align = alClient
    TabHeight = 26
    TabOrder = 0
    TabWidth = 120
    object TabSheet1: TTabSheet
      Caption = #52488#44592#49884#51089' '#51312#44148
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 1141
        Height = 619
        Align = alClient
        BevelOuter = bvNone
        Color = 11167334
        Padding.Left = 1
        Padding.Top = 3
        Padding.Right = 1
        Padding.Bottom = 1
        ParentBackground = False
        TabOrder = 0
        object Panel7: TPanel
          Left = 1
          Top = 3
          Width = 1139
          Height = 615
          Align = alClient
          BevelKind = bkFlat
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object Bevel5: TBevel
            Left = 715
            Top = 21
            Width = 2
            Height = 376
          end
          object GroupBox9: TGroupBox
            Left = 5
            Top = 15
            Width = 345
            Height = 84
            Caption = #52488#44592#49884#51089#51312#44148' 1'
            TabOrder = 0
            object Label42: TLabel
              Left = 20
              Top = 53
              Width = 36
              Height = 12
              Caption = #49688#51061#51060
            end
            object Label43: TLabel
              Left = 219
              Top = 135
              Width = 4
              Height = 12
            end
            object Label46: TLabel
              Left = 145
              Top = 52
              Width = 168
              Height = 12
              Caption = #47564#50896#48372#45796' '#53364#44221#50864#50640#47564' '#49884#51089#54620#45796'.'
            end
            object CheckBoxUseEnterA: TCheckBox
              Left = 10
              Top = 25
              Width = 68
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditEnterAValue1: TEdit
              Left = 84
              Top = 48
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '30'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox27: TGroupBox
            Left = 723
            Top = 15
            Width = 345
            Height = 357
            Caption = #44277#53685#51312#44148' 1 - '#52488#44592#51652#51077#51312#44148'1'#50640#49436#47564' '#49324#50857
            TabOrder = 1
            object CheckBoxUseEnterC1_1: TCheckBox
              Left = 10
              Top = 53
              Width = 319
              Height = 17
              Caption = 'MA1 '#51060' '#50672#49549'                    '#54924' '#49345#49849#51068' '#44221#50864
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditEnterC1_1Value1: TEdit
              Left = 103
              Top = 50
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownEnterC1_1Value1: TUpDown
              Left = 153
              Top = 50
              Width = 15
              Height = 20
              Associate = EditEnterC1_1Value1
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 2
              OnClick = UpDownClick
            end
            object CheckBoxUseEnterC1_2: TCheckBox
              Left = 10
              Top = 81
              Width = 307
              Height = 17
              Caption = 'MA2 '#51060' '#50672#49549'                    '#54924' '#49345#49849#51068' '#44221#50864
              TabOrder = 3
              OnClick = OptionChange
            end
            object EditEnterC1_2Value1: TEdit
              Left = 103
              Top = 78
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 4
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownEnterC1_2Value1: TUpDown
              Left = 153
              Top = 78
              Width = 15
              Height = 20
              Associate = EditEnterC1_2Value1
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 5
              OnClick = UpDownClick
            end
            object CheckBoxUseEnterC1_3: TCheckBox
              Left = 10
              Top = 107
              Width = 319
              Height = 17
              Caption = 'MA1 > MA2 '#51068' '#44221#50864
              TabOrder = 6
              OnClick = OptionChange
            end
            object CheckBoxUseEnterC1_0: TCheckBox
              Left = 11
              Top = 26
              Width = 319
              Height = 17
              Caption = 'MA0 '#51060' '#50672#49549'                    '#54924' '#49345#49849#51068' '#44221#50864
              TabOrder = 7
              OnClick = OptionChange
            end
            object EditEnterC1_0Value1: TEdit
              Left = 103
              Top = 22
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 8
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownEnterC1_0Value1: TUpDown
              Left = 153
              Top = 22
              Width = 15
              Height = 20
              Associate = EditEnterC1_0Value1
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 9
              OnClick = UpDownClick
            end
            object CheckBoxUseEnterC1_5: TCheckBox
              Left = 10
              Top = 168
              Width = 321
              Height = 17
              Caption = 'MA1'#51060' '#52572#44540' 60'#52488' '#46041#50504'                '#47564#50896' '#51060#49345' '#49345#49849
              TabOrder = 10
              OnClick = OptionChange
            end
            object CheckBoxUseEnterC1_6: TCheckBox
              Left = 10
              Top = 196
              Width = 321
              Height = 17
              Caption = 'MA2'#51060' '#52572#44540' 60'#52488' '#46041#50504'                '#47564#50896' '#51060#49345' '#49345#49849
              TabOrder = 11
              OnClick = OptionChange
            end
            object EditEnterC1_6Value1: TEdit
              Left = 153
              Top = 194
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 12
              Text = '5'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditEnterC1_5Value1: TEdit
              Left = 153
              Top = 165
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 13
              Text = '15'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object CheckBoxUseEnterC1_4: TCheckBox
              Left = 10
              Top = 139
              Width = 321
              Height = 17
              Caption = 'MA0'#51060' '#52572#44540' 60'#52488' '#46041#50504'                '#47564#50896' '#51060#49345' '#49345#49849
              TabOrder = 14
              OnClick = OptionChange
            end
            object EditEnterC1_4Value1: TEdit
              Left = 153
              Top = 136
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 15
              Text = '15'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox33: TGroupBox
            Left = 5
            Top = 110
            Width = 345
            Height = 287
            Caption = #52488#44592#49884#51089#51312#44148' 2'
            TabOrder = 2
            object CheckBoxUseEnter2: TCheckBox
              Left = 10
              Top = 25
              Width = 299
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object CheckBoxUseEnter2_1: TCheckBox
              Left = 20
              Top = 53
              Width = 319
              Height = 17
              Caption = 'MA1 '#51060' '#50672#49549'                    '#54924' '#49345#49849#51068' '#44221#50864
              TabOrder = 1
              OnClick = OptionChange
            end
            object EditEnter2Value1: TEdit
              Left = 115
              Top = 51
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 2
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownEnter2Value1: TUpDown
              Left = 165
              Top = 51
              Width = 15
              Height = 20
              Associate = EditEnter2Value1
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 3
              OnClick = UpDownClick
            end
            object CheckBoxUseEnter2_2: TCheckBox
              Left = 20
              Top = 78
              Width = 321
              Height = 17
              Caption = 'MA2 '#51060' '#50672#49549'                    '#54924' '#49345#49849#51068' '#44221#50864
              TabOrder = 4
              OnClick = OptionChange
            end
            object CheckBoxUseEnter2_3: TCheckBox
              Left = 20
              Top = 106
              Width = 321
              Height = 17
              Caption = 'MA1 > MA2 '#51068' '#44221#50864
              TabOrder = 5
              OnClick = OptionChange
            end
            object EditEnter2Value2: TEdit
              Left = 115
              Top = 78
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 6
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownEnter2Value2: TUpDown
              Left = 165
              Top = 78
              Width = 15
              Height = 20
              Associate = EditEnter2Value2
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 7
              OnClick = UpDownClick
            end
            object CheckBoxUseEnter2_4: TCheckBox
              Left = 20
              Top = 147
              Width = 321
              Height = 17
              Caption = #49688#51061#51060'                 '#47564#50896#48372#45796' '#51089#51012' '#44221#50864
              TabOrder = 8
              OnClick = OptionChange
            end
            object EditEnter2Value4: TEdit
              Left = 78
              Top = 144
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 9
              Text = '200'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object CheckBoxUseEnter2_6: TCheckBox
              Left = 21
              Top = 214
              Width = 321
              Height = 17
              Caption = 'MA1'#51060' '#52572#44540' 60'#52488' '#46041#50504'                '#47564#50896' '#51060#49345' '#49345#49849
              TabOrder = 10
              OnClick = OptionChange
            end
            object CheckBoxUseEnter2_7: TCheckBox
              Left = 21
              Top = 245
              Width = 321
              Height = 17
              Caption = 'MA2'#51060' '#52572#44540' 60'#52488' '#46041#50504'                '#47564#50896' '#51060#49345' '#49345#49849
              TabOrder = 11
              OnClick = OptionChange
            end
            object EditEnter2Value6: TEdit
              Left = 164
              Top = 211
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 12
              Text = '15'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditEnter2Value7: TEdit
              Left = 164
              Top = 243
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 13
              Text = '5'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object CheckBoxUseEnter2_5: TCheckBox
              Left = 20
              Top = 177
              Width = 321
              Height = 17
              Caption = #49688#51061#51060'                 '#47564#50896#48372#45796' '#53364' '#44221#50864
              TabOrder = 14
              OnClick = OptionChange
            end
            object EditEnter2Value5: TEdit
              Left = 78
              Top = 174
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 15
              Text = '-200'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #52488#44592#49884#51089#51032' '#51221#51648#51312#44148
      ImageIndex = 1
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 1141
        Height = 619
        Align = alClient
        BevelOuter = bvNone
        Color = 6710886
        Padding.Left = 1
        Padding.Top = 3
        Padding.Right = 1
        Padding.Bottom = 1
        ParentBackground = False
        TabOrder = 0
        object Panel14: TPanel
          Left = 1
          Top = 3
          Width = 1139
          Height = 615
          Align = alClient
          BevelKind = bkFlat
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object Bevel1: TBevel
            Left = 715
            Top = 21
            Width = 2
            Height = 366
          end
          object GroupBox31: TGroupBox
            Left = 5
            Top = 15
            Width = 345
            Height = 372
            Caption = #47588#47588' '#51068#49884#51221#51648' '#51312#44148' 1'
            TabOrder = 0
            object Label116: TLabel
              Left = 20
              Top = 75
              Width = 250
              Height = 12
              Caption = #52572#45824' '#49688#51061#51032' D % '#51060#49345' '#44048#49548#54616#47732' '#47588#47588#51221#51648#54620#45796'.'
            end
            object Label130: TLabel
              Left = 20
              Top = 50
              Width = 236
              Height = 12
              Caption = #49688#51061#51032' '#47784#46304' '#54633#44228#50640' '#46384#47480' '#52572#45824#46300#47196#45796#50868' '#49444#51221
              Font.Charset = HANGEUL_CHARSET
              Font.Color = clNavy
              Font.Height = -12
              Font.Name = #44404#47548
              Font.Style = []
              ParentFont = False
            end
            object CheckBox_PLC1: TCheckBox
              Left = 10
              Top = 25
              Width = 74
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object GroupBox32: TGroupBox
              Left = 20
              Top = 100
              Width = 307
              Height = 250
              TabOrder = 1
              object Label120: TLabel
                Left = 20
                Top = 16
                Width = 86
                Height = 12
                Caption = #49688#51061#51032' '#54633'('#47564#50896')'
              end
              object Label118: TLabel
                Left = 213
                Top = 16
                Width = 8
                Height = 12
                Caption = 'D'
              end
              object Label1: TLabel
                Left = 246
                Top = 137
                Width = 10
                Height = 12
                Caption = '%'
              end
              object Label2: TLabel
                Left = 246
                Top = 167
                Width = 10
                Height = 12
                Caption = '%'
              end
              object Label3: TLabel
                Left = 246
                Top = 193
                Width = 10
                Height = 12
                Caption = '%'
              end
              object Label5: TLabel
                Left = 246
                Top = 112
                Width = 10
                Height = 12
                Caption = '%'
              end
              object Label39: TLabel
                Left = 246
                Top = 58
                Width = 10
                Height = 12
                Caption = '%'
              end
              object Label40: TLabel
                Left = 246
                Top = 83
                Width = 10
                Height = 12
                Caption = '%'
              end
              object Edit_PLC1_D1: TEdit
                Left = 190
                Top = 190
                Width = 50
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 16
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC1_D2: TEdit
                Left = 190
                Top = 162
                Width = 50
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 15
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC1_D3: TEdit
                Left = 190
                Top = 134
                Width = 50
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 17
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC1_V1: TEdit
                Left = 20
                Top = 192
                Width = 60
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 5
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC1_V2: TEdit
                Left = 20
                Top = 164
                Width = 60
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 4
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC1_V3: TEdit
                Left = 20
                Top = 132
                Width = 60
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 3
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object CheckBox_PLC1_A3: TCheckBox
                Left = 125
                Top = 136
                Width = 41
                Height = 17
                Caption = #51060#49345
                TabOrder = 9
                OnClick = OptionChange
              end
              object CheckBox_PLC1_A2: TCheckBox
                Left = 125
                Top = 164
                Width = 41
                Height = 17
                Caption = #51060#49345
                TabOrder = 10
                OnClick = OptionChange
              end
              object CheckBox_PLC1_A1: TCheckBox
                Left = 125
                Top = 192
                Width = 41
                Height = 17
                Caption = #51060#49345
                TabOrder = 11
                OnClick = OptionChange
              end
              object Edit_PLC1_D4: TEdit
                Left = 190
                Top = 106
                Width = 50
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 14
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object CheckBox_PLC1_A4: TCheckBox
                Left = 125
                Top = 107
                Width = 41
                Height = 17
                Caption = #51060#49345
                TabOrder = 8
                OnClick = OptionChange
              end
              object Edit_PLC1_V4: TEdit
                Left = 20
                Top = 105
                Width = 60
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 2
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC1_V6: TEdit
                Left = 20
                Top = 51
                Width = 60
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 0
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC1_V5: TEdit
                Left = 20
                Top = 78
                Width = 60
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 1
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object CheckBox_PLC1_A6: TCheckBox
                Left = 125
                Top = 53
                Width = 41
                Height = 17
                Caption = #51060#49345
                TabOrder = 6
                OnClick = OptionChange
              end
              object CheckBox_PLC1_A5: TCheckBox
                Left = 125
                Top = 82
                Width = 41
                Height = 17
                Caption = #51060#49345
                TabOrder = 7
                OnClick = OptionChange
              end
              object Edit_PLC1_D6: TEdit
                Left = 190
                Top = 52
                Width = 50
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 12
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC1_D5: TEdit
                Left = 190
                Top = 80
                Width = 50
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 13
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
            end
          end
          object GroupBox4: TGroupBox
            Left = 360
            Top = 137
            Width = 345
            Height = 87
            Caption = #47588#47588' '#51068#49884#51221#51648' '#51312#44148' 3'
            TabOrder = 2
            object Label20: TLabel
              Left = 145
              Top = 53
              Width = 196
              Height = 12
              Caption = #47564#50896' '#51060#54616#47196' '#45236#47140#44032#47732' '#47588#47588#51221#51648#54620#45796'.'
            end
            object Label21: TLabel
              Left = 20
              Top = 53
              Width = 40
              Height = 12
              Caption = #49688#51061#51060' '
            end
            object CheckBoxUsePLC1Type3: TCheckBox
              Left = 10
              Top = 25
              Width = 70
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditPLC1Type3: TEdit
              Left = 79
              Top = 50
              Width = 60
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '-80'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox18: TGroupBox
            Left = 360
            Top = 15
            Width = 345
            Height = 110
            Caption = #47588#47588' '#51068#49884#51221#51648' '#51312#44148' 2'
            TabOrder = 1
            object Label35: TLabel
              Left = 20
              Top = 53
              Width = 64
              Height = 12
              Caption = #52572#45824#49688#51061#51060' '
            end
            object Label36: TLabel
              Left = 219
              Top = 135
              Width = 4
              Height = 12
            end
            object Label32: TLabel
              Left = 145
              Top = 51
              Width = 172
              Height = 12
              Caption = #47564#50896#50640' '#47803#48120#52824#44256' '#49552#49892#51012' '#48380' '#44221#50864
            end
            object Label38: TLabel
              Left = 145
              Top = 80
              Width = 196
              Height = 12
              Caption = #47564#50896' '#51060#54616#47196' '#45236#47140#44032#47732' '#47588#47588#51221#51648#54620#45796'.'
            end
            object Label60: TLabel
              Left = 20
              Top = 80
              Width = 36
              Height = 12
              Caption = #49688#51061#51060
            end
            object CheckBoxUsePLC1Type2: TCheckBox
              Left = 10
              Top = 25
              Width = 68
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditPLC1Type2Value2: TEdit
              Left = 84
              Top = 76
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 2
              Text = '-50'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditPLC1Type2Value1: TEdit
              Left = 84
              Top = 48
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '30'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox20: TGroupBox
            Left = 360
            Top = 237
            Width = 345
            Height = 208
            Caption = #47588#47588' '#51068#49884#51221#51648' '#51312#44148' 4'
            TabOrder = 3
            object Label86: TLabel
              Left = 10
              Top = 132
              Width = 264
              Height = 12
              Caption = #44288#47532#51204' '#49688#51061#51060'                '#47564#50896' '#51060#49345#51068' '#44221#50864' '#46608#45716','
            end
            object Label88: TLabel
              Left = 10
              Top = 184
              Width = 272
              Height = 12
              Caption = #51109' '#49884#51089' '#49884#44036#50640#49436'                 '#48516' '#54980' '#48512#53552' '#51201#50857#54620#45796'.'
            end
            object Label96: TLabel
              Left = 10
              Top = 156
              Width = 300
              Height = 12
              Caption = #44288#47532#51204' '#49688#51061#51060'                '#47564#50896' '#51060#54616#51068' '#44221#50864#47564' '#51201#50857#54620#45796'.'
            end
            object CheckBoxUsePLC1Type4: TCheckBox
              Left = 10
              Top = 25
              Width = 70
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object CheckBoxUsePLC1Type4_1: TCheckBox
              Left = 10
              Top = 52
              Width = 319
              Height = 17
              Caption = 'MA1 '#51060' '#50672#49549'                    '#54924' '#54616#46973#51068' '#44221#50864
              TabOrder = 1
              OnClick = OptionChange
            end
            object CheckBoxUsePLC1Type4_2: TCheckBox
              Left = 10
              Top = 77
              Width = 307
              Height = 17
              Caption = 'MA2 '#51060' '#50672#49549'                    '#54924' '#54616#46973#51068' '#44221#50864
              TabOrder = 2
              OnClick = OptionChange
            end
            object CheckBoxUsePLC1Type4_3: TCheckBox
              Left = 10
              Top = 103
              Width = 240
              Height = 17
              Caption = 'MA1 < MA2 '#51068' '#44221#50864
              TabOrder = 3
              OnClick = OptionChange
            end
            object EditPLC1Type4Value1: TEdit
              Left = 103
              Top = 49
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 4
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownPLC1Type4Value1: TUpDown
              Left = 153
              Top = 49
              Width = 15
              Height = 20
              Associate = EditPLC1Type4Value1
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 5
              OnClick = UpDownClick
            end
            object UpDownPLC1Type4Value2: TUpDown
              Left = 153
              Top = 75
              Width = 15
              Height = 20
              Associate = EditPLC1Type4Value2
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 6
              OnClick = UpDownClick
            end
            object EditPLC1Type4Value2: TEdit
              Left = 103
              Top = 75
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 7
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditPLC1Type4Value3: TEdit
              Left = 90
              Top = 127
              Width = 50
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 8
              Text = '500'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditPLC1Type4Value4: TEdit
              Left = 110
              Top = 179
              Width = 40
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 9
              Text = '3'
              OnChange = OptionChange
            end
            object UpDownPLC1Type4Value4: TUpDown
              Left = 150
              Top = 179
              Width = 15
              Height = 20
              Associate = EditPLC1Type4Value4
              Min = 1
              Max = 300
              Position = 3
              TabOrder = 10
              OnClick = UpDownClick
            end
            object EditPLC1Type4Value5: TEdit
              Left = 90
              Top = 152
              Width = 50
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 11
              Text = '-500'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox23: TGroupBox
            Left = 725
            Top = 15
            Width = 345
            Height = 118
            Caption = #47588#47588' '#51068#49884#51221#51648' '#51312#44148' 1'#51032' '#44277#53685#51312#44148
            TabOrder = 4
            object CheckBoxUsePLC1TypeC_1: TCheckBox
              Left = 10
              Top = 30
              Width = 319
              Height = 17
              Caption = 'MA1 '#51060' '#50672#49549'                    '#54924' '#54616#46973#51068' '#44221#50864
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditPLC1TypeCValue1: TEdit
              Left = 103
              Top = 27
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownPLC1TypeCValue1: TUpDown
              Left = 153
              Top = 27
              Width = 15
              Height = 20
              Associate = EditPLC1TypeCValue1
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 2
              OnClick = UpDownClick
            end
            object CheckBoxUsePLC1TypeC_2: TCheckBox
              Left = 10
              Top = 58
              Width = 307
              Height = 17
              Caption = 'MA2 '#51060' '#50672#49549'                    '#54924' '#54616#46973#51068' '#44221#50864
              TabOrder = 3
              OnClick = OptionChange
            end
            object EditPLC1TypeCValue2: TEdit
              Left = 103
              Top = 55
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 4
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownPLC1TypeCValue2: TUpDown
              Left = 153
              Top = 55
              Width = 15
              Height = 20
              Associate = EditPLC1TypeCValue2
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 5
              OnClick = UpDownClick
            end
            object CheckBoxUsePLC1TypeC_3: TCheckBox
              Left = 10
              Top = 84
              Width = 240
              Height = 17
              Caption = 'MA1 < MA2 '#51068' '#44221#50864
              TabOrder = 6
              OnClick = OptionChange
            end
          end
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #51116#49884#51089' '#51312#44148
      ImageIndex = 2
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1141
        Height = 619
        Align = alClient
        BevelOuter = bvNone
        Color = 6710954
        Padding.Left = 1
        Padding.Top = 3
        Padding.Right = 1
        Padding.Bottom = 1
        ParentBackground = False
        TabOrder = 0
        object Panel5: TPanel
          Left = 1
          Top = 3
          Width = 1139
          Height = 615
          Align = alClient
          BevelKind = bkFlat
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object Bevel4: TBevel
            Left = 716
            Top = 21
            Width = 2
            Height = 370
          end
          object Bevel6: TBevel
            Left = 15
            Top = 395
            Width = 700
            Height = 2
          end
          object GroupBox3: TGroupBox
            Left = 5
            Top = 15
            Width = 345
            Height = 86
            Caption = #51116#49884#51089#51312#44148' 1'
            TabOrder = 0
            object Label13: TLabel
              Left = 18
              Top = 57
              Width = 196
              Height = 12
              Caption = #51060#51204' '#52572#44256#49688#51061#51012' '#46028#54028#49884' '#51116#49884#51089#54620#45796'.'
            end
            object CheckBoxUseReEnter1: TCheckBox
              Left = 10
              Top = 25
              Width = 74
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
          end
          object GroupBox7: TGroupBox
            Left = 5
            Top = 107
            Width = 345
            Height = 85
            Caption = #51116#49884#51089#51312#44148' 2'
            TabOrder = 1
            object Label45: TLabel
              Left = 140
              Top = 28
              Width = 74
              Height = 12
              Caption = '0 '#51452#48320#51032' '#44552#50529
            end
            object Label16: TLabel
              Left = 86
              Top = 54
              Width = 40
              Height = 12
              Caption = #47564#50896#44284' '
            end
            object Label41: TLabel
              Left = 199
              Top = 54
              Width = 120
              Height = 12
              Caption = #47564#50896' '#49324#51060#51068' '#46412' '#51116#49884#51089
            end
            object CheckBoxUseReEnter2: TCheckBox
              Left = 10
              Top = 25
              Width = 74
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditReEnter2Value1: TEdit
              Left = 20
              Top = 50
              Width = 60
              Height = 20
              Alignment = taRightJustify
              ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
              TabOrder = 1
              Text = '15'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditReEnter2Value2: TEdit
              Left = 132
              Top = 50
              Width = 60
              Height = 20
              Alignment = taRightJustify
              ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
              TabOrder = 2
              Text = '30'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox8: TGroupBox
            Left = 725
            Top = 15
            Width = 345
            Height = 78
            Caption = #44277#53685#51312#44148' 1 - '#51068#48152
            TabOrder = 3
            object Label27: TLabel
              Left = 20
              Top = 55
              Width = 96
              Height = 12
              Caption = #51060#51204' '#47588#47588' '#51221#51648#54980' '
            end
            object Label29: TLabel
              Left = 198
              Top = 55
              Width = 96
              Height = 12
              Caption = #48516' '#51648#45212' '#54980#50640' '#44032#45733
            end
            object Label11: TLabel
              Left = 20
              Top = 27
              Width = 48
              Height = 12
              Caption = #52572#45824#54943#49688
            end
            object Label30: TLabel
              Left = 151
              Top = 27
              Width = 12
              Height = 12
              Caption = #54924
            end
            object UpDownReEnter0Value2: TUpDown
              Left = 177
              Top = 51
              Width = 15
              Height = 20
              Associate = EditReEnter0Value2
              Min = 1
              Max = 600
              Position = 1
              TabOrder = 3
              OnClick = UpDownClick
            end
            object EditReEnter0Value2: TEdit
              Left = 127
              Top = 51
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 2
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditReEnter0Value1: TEdit
              Left = 81
              Top = 23
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 0
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownReEnter0Value1: TUpDown
              Left = 131
              Top = 23
              Width = 15
              Height = 20
              Associate = EditReEnter0Value1
              Min = 1
              Max = 5
              Position = 1
              TabOrder = 1
              OnClick = UpDownClick
            end
          end
          object GroupBox12: TGroupBox
            Left = 5
            Top = 203
            Width = 345
            Height = 185
            Caption = #51116#49884#51089#51312#44148' 3'
            TabOrder = 2
            object Label54: TLabel
              Left = 20
              Top = 51
              Width = 224
              Height = 12
              Caption = '#1. '#52572#51200#49688#51061#50640#49436' '#52572#44256#49688#51061#44284' '#52572#51200#49688#51061#51032' '
            end
            object Label55: TLabel
              Left = 108
              Top = 77
              Width = 26
              Height = 12
              Caption = '% '#50752
            end
            object Label4: TLabel
              Left = 206
              Top = 77
              Width = 126
              Height = 12
              Caption = '%  '#51032' '#49324#51060#51068' '#46412' '#51116#49884#51089
            end
            object Label56: TLabel
              Left = 20
              Top = 190
              Width = 224
              Height = 12
              Caption = #8251' '#52572#44256#49688#51061#51008' '#51060#51204' '#51204#52404' '#44592#44036#51473#51032' '#52572#44256#52824
            end
            object Label57: TLabel
              Left = 21
              Top = 208
              Width = 284
              Height = 12
              Caption = #8251' '#52572#51200#49688#51061#51008' '#51060#51204' '#47588#47588#44396#50669' '#51333#47308' '#54980' '#52572#51200#52824' '#51077#45768#45796'.'
            end
            object Label58: TLabel
              Left = 20
              Top = 108
              Width = 188
              Height = 12
              Caption = '#2. '#52572#44256#49688#51061#44284' '#52572#51200#49688#51061#51032' '#52264#51060#44032' '
            end
            object Label59: TLabel
              Left = 40
              Top = 129
              Width = 144
              Height = 12
              Caption = #48372#45796' '#51089#51004#47732' '#54728#50857#54616#51648' '#50506#51020
            end
            object Label61: TLabel
              Left = 282
              Top = 109
              Width = 24
              Height = 12
              Caption = #47564#50896
            end
            object Label70: TLabel
              Left = 20
              Top = 156
              Width = 84
              Height = 12
              Caption = '#3. '#45572#51201#49688#51061#51060' '
            end
            object Label71: TLabel
              Left = 173
              Top = 155
              Width = 132
              Height = 12
              Caption = #47564#50896#48372#45796' '#53356#47732' '#51201#50857#54620#45796'.'
            end
            object Label72: TLabel
              Left = 20
              Top = 226
              Width = 170
              Height = 12
              Caption = #8251' #2'#48264' '#51312#44148' '#48120#49324#50857#49884' 0'#51012' '#51077#47141
            end
            object Label73: TLabel
              Left = 21
              Top = 244
              Width = 272
              Height = 12
              Caption = #8251' #3'#48264' '#51312#44148' '#48120#49324#50857#49884' '#50500#51452' '#51089#51008#49688#47484' '#51077#47141' (-1000)'
            end
            object CheckBoxUseReEnter3: TCheckBox
              Left = 10
              Top = 25
              Width = 74
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditReEnter3Value3: TEdit
              Left = 216
              Top = 105
              Width = 60
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '90'
              OnClick = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditReEnter3Value1: TEdit
              Left = 42
              Top = 73
              Width = 60
              Height = 20
              Alignment = taRightJustify
              ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
              TabOrder = 2
              Text = '15'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditReEnter3Value2: TEdit
              Left = 140
              Top = 72
              Width = 65
              Height = 20
              Alignment = taRightJustify
              ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
              TabOrder = 3
              Text = '30'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditReEnter3Value4: TEdit
              Left = 107
              Top = 151
              Width = 60
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 4
              Text = '-200'
              OnClick = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox11: TGroupBox
            Left = 725
            Top = 103
            Width = 345
            Height = 82
            Caption = #44277#53685#51312#44148' 2 - '#49688#51061#54869#51064#54980' '#51652#51077
            TabOrder = 4
            object Label50: TLabel
              Left = 20
              Top = 53
              Width = 40
              Height = 12
              Caption = #49688#51061#51060' '
            end
            object Label51: TLabel
              Left = 219
              Top = 135
              Width = 4
              Height = 12
            end
            object Label52: TLabel
              Left = 145
              Top = 52
              Width = 140
              Height = 12
              Caption = #47564#50896#48372#45796' '#53364#44221#50864#50640#47564' '#44032#45733
            end
            object CheckBoxUseReEnterA: TCheckBox
              Left = 10
              Top = 25
              Width = 68
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditReEnterAValue1: TEdit
              Left = 84
              Top = 48
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '7.5'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox15: TGroupBox
            Left = 724
            Top = 194
            Width = 345
            Height = 211
            Caption = #44277#53685#51312#44148' 3 - '#49688#51061#51060#46041#54217#44512#49440#51012' '#49324#50857
            TabOrder = 5
            object CheckBoxUseMA1ConsecutiveUp: TCheckBox
              Left = 10
              Top = 31
              Width = 319
              Height = 17
              Caption = 'MA1 '#51060' '#50672#49549'                    '#54924' '#49345#49849#51068' '#44221#50864
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditMA1ConsecutiveUpCount: TEdit
              Left = 103
              Top = 29
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownMA1ConsecutiveUpCount: TUpDown
              Left = 153
              Top = 29
              Width = 15
              Height = 20
              Associate = EditMA1ConsecutiveUpCount
              Min = 1
              Max = 15
              Position = 1
              TabOrder = 2
              OnClick = UpDownClick
            end
            object CheckBoxUseMA2ConsecutiveUp: TCheckBox
              Left = 10
              Top = 57
              Width = 307
              Height = 17
              Caption = 'MA2 '#51060' '#50672#49549'                    '#54924' '#49345#49849#51068' '#44221#50864
              TabOrder = 3
              OnClick = OptionChange
            end
            object EditMA2ConsecutiveUpCount: TEdit
              Left = 103
              Top = 55
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 4
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownMA2ConsecutiveUpCount: TUpDown
              Left = 153
              Top = 55
              Width = 15
              Height = 20
              Associate = EditMA2ConsecutiveUpCount
              Min = 1
              Max = 15
              Position = 1
              TabOrder = 5
              OnClick = UpDownClick
            end
            object CheckBoxUseMA1AboveMA2: TCheckBox
              Left = 10
              Top = 84
              Width = 240
              Height = 17
              Caption = 'MA1 > MA2 '#51068' '#44221#50864
              TabOrder = 6
              OnClick = OptionChange
            end
            object CheckBoxUseReEnterC3_4: TCheckBox
              Left = 10
              Top = 111
              Width = 321
              Height = 17
              Caption = 'MA0'#51060' '#52572#44540' 60'#52488' '#46041#50504'                '#47564#50896' '#51060#49345' '#49345#49849
              TabOrder = 7
              OnClick = OptionChange
            end
            object EditReEnterC3_4Value1: TEdit
              Left = 153
              Top = 108
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 8
              Text = '15'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object CheckBoxUseReEnterC3_5: TCheckBox
              Left = 10
              Top = 140
              Width = 321
              Height = 17
              Caption = 'MA1'#51060' '#52572#44540' 60'#52488' '#46041#50504'                '#47564#50896' '#51060#49345' '#49345#49849
              TabOrder = 9
              OnClick = OptionChange
            end
            object EditReEnterC3_5Value1: TEdit
              Left = 153
              Top = 137
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 10
              Text = '15'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object CheckBoxUseReEnterC3_6: TCheckBox
              Left = 10
              Top = 166
              Width = 321
              Height = 17
              Caption = 'MA2'#51060' '#52572#44540' 60'#52488' '#46041#50504'                '#47564#50896' '#51060#49345' '#49345#49849
              TabOrder = 11
              OnClick = OptionChange
            end
            object EditReEnterC3_6Value1: TEdit
              Left = 153
              Top = 163
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 12
              Text = '5'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox16: TGroupBox
            Left = 360
            Top = 15
            Width = 345
            Height = 98
            Caption = #51116#49884#51089#51312#44148' 4'
            TabOrder = 6
            object Label53: TLabel
              Left = 20
              Top = 50
              Width = 76
              Height = 12
              Caption = #52572#51200#49688#51061#48372#45796' '
            end
            object Label74: TLabel
              Left = 171
              Top = 72
              Width = 120
              Height = 12
              Caption = #47564#50896' '#49324#51060#51068' '#46412' '#51116#49884#51089
            end
            object Label44: TLabel
              Left = 86
              Top = 73
              Width = 9
              Height = 12
              Caption = '~'
            end
            object CheckBoxUseReEnter4: TCheckBox
              Left = 10
              Top = 25
              Width = 247
              Height = 17
              Caption = #49324#50857#50668#48512'('#44277#53685#51312#44148' 2'#45716' '#51228#50808')'
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditReEnter4Value1: TEdit
              Left = 20
              Top = 68
              Width = 60
              Height = 20
              Alignment = taRightJustify
              ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
              TabOrder = 1
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditReEnter4Value2: TEdit
              Left = 102
              Top = 68
              Width = 60
              Height = 20
              Alignment = taRightJustify
              ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
              TabOrder = 2
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox22: TGroupBox
            Left = 360
            Top = 119
            Width = 345
            Height = 142
            Caption = #51116#49884#51089#51312#44148' 5'
            TabOrder = 7
            object CheckBoxUseReEnter5: TCheckBox
              Left = 10
              Top = 25
              Width = 299
              Height = 17
              Caption = #49324#50857#50668#48512'('#44277#53685#51312#44148' 3'#45716' '#51228#50808')'
              TabOrder = 0
              OnClick = OptionChange
            end
            object CheckBoxUseReEnter5_1: TCheckBox
              Left = 10
              Top = 59
              Width = 319
              Height = 17
              Caption = 'MA1 '#51060' '#50672#49549'                    '#54924' '#49345#49849#51068' '#44221#50864
              TabOrder = 1
              OnClick = OptionChange
            end
            object EditReEnter5_1Value1: TEdit
              Left = 105
              Top = 57
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 2
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownReEnter5_1Value1: TUpDown
              Left = 155
              Top = 57
              Width = 15
              Height = 20
              Associate = EditReEnter5_1Value1
              Min = 1
              Max = 15
              Position = 1
              TabOrder = 3
              OnClick = UpDownClick
            end
            object CheckBoxUseReEnter5_2: TCheckBox
              Left = 10
              Top = 86
              Width = 321
              Height = 17
              Caption = 'MA2 '#51060' '#50672#49549'                    '#54924' '#49345#49849#51068' '#44221#50864
              TabOrder = 4
              OnClick = OptionChange
            end
            object CheckBoxUseReEnter5_3: TCheckBox
              Left = 10
              Top = 116
              Width = 321
              Height = 17
              Caption = 'MA1 > MA2 '#51068' '#44221#50864
              TabOrder = 5
              OnClick = OptionChange
            end
            object EditReEnter5_2Value1: TEdit
              Left = 105
              Top = 86
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 6
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownReEnter5_2Value1: TUpDown
              Left = 155
              Top = 86
              Width = 15
              Height = 20
              Associate = EditReEnter5_2Value1
              Min = 1
              Max = 15
              Position = 1
              TabOrder = 7
              OnClick = UpDownClick
            end
          end
          object GroupBox29: TGroupBox
            Left = 360
            Top = 273
            Width = 345
            Height = 116
            Caption = #51116#49884#51089#51312#44148' 6'
            TabOrder = 8
            object Label99: TLabel
              Left = 20
              Top = 56
              Width = 28
              Height = 12
              Caption = #52572#44540' '
            end
            object Label100: TLabel
              Left = 88
              Top = 90
              Width = 184
              Height = 12
              Caption = #47564#50896' '#51060#49345' '#49345#49849#54664#51012' '#44221#50864#50640' '#51116#49884#51089
            end
            object Label102: TLabel
              Left = 126
              Top = 56
              Width = 120
              Height = 12
              Caption = #48516' '#46041#50504#51032' '#52572#51200#51216#50640#49436' '
            end
            object CheckBoxUseReEnter6: TCheckBox
              Left = 10
              Top = 25
              Width = 253
              Height = 17
              Caption = #49324#50857#50668#48512'('#44277#53685#51312#44148' 2'#45716' '#51228#50808')'
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditReEnter6Value2: TEdit
              Left = 20
              Top = 86
              Width = 60
              Height = 20
              Alignment = taRightJustify
              ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
              TabOrder = 1
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditReEnter6Value1: TEdit
              Left = 55
              Top = 52
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 2
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownReEnter6Value1: TUpDown
              Left = 105
              Top = 52
              Width = 15
              Height = 20
              Associate = EditReEnter6Value1
              Min = 1
              Max = 600
              Position = 1
              TabOrder = 3
              OnClick = UpDownClick
            end
          end
          object GroupBox30: TGroupBox
            Left = 729
            Top = 429
            Width = 345
            Height = 110
            Caption = #44277#53685#51312#44148' 4 -  '#51228#54620#51312#44148
            TabOrder = 9
            object Label101: TLabel
              Left = 18
              Top = 52
              Width = 192
              Height = 12
              Caption = #49688#51061#51060'                  '#47564#50896' '#48372#45796' '#51089#44256','
            end
            object Label105: TLabel
              Left = 18
              Top = 79
              Width = 232
              Height = 12
              Caption = #49688#51061#51060'                  '#47564#50896' '#48372#45796' '#53364' '#46412#47564' '#44032#45733
            end
            object CheckBoxUseReEnterB: TCheckBox
              Left = 10
              Top = 25
              Width = 68
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditReEnterBValue1: TEdit
              Left = 62
              Top = 48
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '300'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditReEnterBValue2: TEdit
              Left = 62
              Top = 74
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 2
              Text = '-500'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox36: TGroupBox
            Left = 5
            Top = 403
            Width = 345
            Height = 110
            Caption = #44277#53685#51312#44148' 5 -  '#51228#54620#51312#44148
            TabOrder = 10
            object Label92: TLabel
              Left = 20
              Top = 53
              Width = 228
              Height = 12
              Caption = #49688#51061#51060'                 '#47564#50896' '#51060#49345#51068' '#44221#50864' '#46608#45716','
            end
            object Label94: TLabel
              Left = 219
              Top = 135
              Width = 4
              Height = 12
            end
            object Label111: TLabel
              Left = 20
              Top = 79
              Width = 196
              Height = 12
              Caption = #49688#51061#51060'                 '#47564#50896' '#51060#54616#51068' '#44221#50864
            end
            object CheckBoxUseReEnterC: TCheckBox
              Left = 8
              Top = 25
              Width = 68
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditReEnterCValue1: TEdit
              Left = 62
              Top = 48
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '300'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditReEnterCValue2: TEdit
              Left = 62
              Top = 74
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 2
              Text = '-500'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox37: TGroupBox
            Left = 360
            Top = 403
            Width = 345
            Height = 136
            Caption = #44277#53685#51312#44148' 6 -  '#51228#54620#51312#44148
            TabOrder = 11
            object Label109: TLabel
              Left = 219
              Top = 135
              Width = 4
              Height = 12
            end
            object Label108: TLabel
              Left = 20
              Top = 52
              Width = 298
              Height = 12
              Caption = #52572#44540'                     '#48516' '#46041#50504#51032' '#52572#51200#49688#51061#51012' P0 '#46972#44256' '#54616#47732
            end
            object Label113: TLabel
              Left = 20
              Top = 108
              Width = 250
              Height = 12
              Caption = #49688#51061#51060' P0 '#48372#45796'                   '#47564#50896' '#51060#54616#51068' '#44221#50864
            end
            object Label110: TLabel
              Left = 20
              Top = 81
              Width = 238
              Height = 12
              Caption = #49688#51061#51060' P0 '#48372#45796'                   '#47564#50896' '#51060#49345#51060#44256','
            end
            object CheckBoxUseReEnterD: TCheckBox
              Left = 10
              Top = 25
              Width = 68
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditReEnterDValue1: TEdit
              Left = 55
              Top = 48
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownReEnterDValue1: TUpDown
              Left = 105
              Top = 48
              Width = 15
              Height = 20
              Associate = EditReEnterDValue1
              Min = 1
              Max = 600
              Position = 1
              TabOrder = 2
              OnClick = UpDownClick
            end
            object EditReEnterDValue2: TEdit
              Left = 113
              Top = 76
              Width = 60
              Height = 20
              Alignment = taRightJustify
              ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
              TabOrder = 3
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditReEnterDValue3: TEdit
              Left = 113
              Top = 102
              Width = 60
              Height = 20
              Alignment = taRightJustify
              ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
              TabOrder = 4
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #51116#49884#51089#51032' '#51221#51648#51312#44148
      ImageIndex = 3
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 1141
        Height = 619
        Align = alClient
        BevelOuter = bvNone
        Color = 436906
        Padding.Left = 1
        Padding.Top = 3
        Padding.Right = 1
        Padding.Bottom = 1
        ParentBackground = False
        TabOrder = 0
        object Panel3: TPanel
          Left = 1
          Top = 3
          Width = 1139
          Height = 615
          Align = alClient
          BevelKind = bkFlat
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object Bevel3: TBevel
            Left = 715
            Top = 21
            Width = 2
            Height = 424
          end
          object GroupBox2: TGroupBox
            Left = 5
            Top = 15
            Width = 345
            Height = 372
            Caption = #47588#47588' '#51068#49884#51221#51648' '#51312#44148' 1'
            TabOrder = 0
            object Label18: TLabel
              Left = 20
              Top = 50
              Width = 236
              Height = 12
              Caption = #49688#51061#51032' '#47784#46304' '#54633#44228#50640' '#46384#47480' '#52572#45824#46300#47196#45796#50868' '#49444#51221
              Font.Charset = HANGEUL_CHARSET
              Font.Color = clNavy
              Font.Height = -12
              Font.Name = #44404#47548
              Font.Style = []
              ParentFont = False
            end
            object Label19: TLabel
              Left = 20
              Top = 75
              Width = 250
              Height = 12
              Caption = #52572#45824' '#49688#51061#51032' D % '#51060#49345' '#44048#49548#54616#47732' '#47588#47588#51221#51648#54620#45796'.'
            end
            object GroupBox1: TGroupBox
              Left = 20
              Top = 100
              Width = 307
              Height = 250
              TabOrder = 1
              object Label7: TLabel
                Left = 20
                Top = 16
                Width = 86
                Height = 12
                Caption = #49688#51061#51032' '#54633'('#47564#50896')'
              end
              object Label8: TLabel
                Left = 213
                Top = 16
                Width = 8
                Height = 12
                Caption = 'D'
              end
              object Label9: TLabel
                Left = 246
                Top = 137
                Width = 10
                Height = 12
                Caption = '%'
              end
              object Label10: TLabel
                Left = 246
                Top = 167
                Width = 10
                Height = 12
                Caption = '%'
              end
              object Label15: TLabel
                Left = 246
                Top = 193
                Width = 10
                Height = 12
                Caption = '%'
              end
              object Label17: TLabel
                Left = 246
                Top = 112
                Width = 10
                Height = 12
                Caption = '%'
              end
              object Label34: TLabel
                Left = 246
                Top = 58
                Width = 10
                Height = 12
                Caption = '%'
              end
              object Label37: TLabel
                Left = 246
                Top = 83
                Width = 10
                Height = 12
                Caption = '%'
              end
              object Edit_PLC2_D1: TEdit
                Left = 190
                Top = 190
                Width = 50
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 17
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC2_D2: TEdit
                Left = 190
                Top = 162
                Width = 50
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 14
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC2_D3: TEdit
                Left = 190
                Top = 134
                Width = 50
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 11
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC2_V1: TEdit
                Left = 20
                Top = 192
                Width = 60
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 15
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC2_V2: TEdit
                Left = 20
                Top = 164
                Width = 60
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 12
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC2_V3: TEdit
                Left = 20
                Top = 132
                Width = 60
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 9
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object CheckBox_PLC2_A3: TCheckBox
                Left = 125
                Top = 136
                Width = 41
                Height = 17
                Caption = #51060#49345
                TabOrder = 10
                OnClick = OptionChange
              end
              object CheckBox_PLC2_A2: TCheckBox
                Left = 125
                Top = 164
                Width = 41
                Height = 17
                Caption = #51060#49345
                TabOrder = 13
                OnClick = OptionChange
              end
              object CheckBox_PLC2_A1: TCheckBox
                Left = 125
                Top = 192
                Width = 41
                Height = 17
                Caption = #51060#49345
                TabOrder = 16
                OnClick = OptionChange
              end
              object Edit_PLC2_D4: TEdit
                Left = 190
                Top = 106
                Width = 50
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 8
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object CheckBox_PLC2_A4: TCheckBox
                Left = 125
                Top = 107
                Width = 41
                Height = 17
                Caption = #51060#49345
                TabOrder = 7
                OnClick = OptionChange
              end
              object Edit_PLC2_V4: TEdit
                Left = 20
                Top = 105
                Width = 60
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 6
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC2_V6: TEdit
                Left = 20
                Top = 51
                Width = 60
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 0
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC2_V5: TEdit
                Left = 20
                Top = 78
                Width = 60
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 3
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object CheckBox_PLC2_A6: TCheckBox
                Left = 125
                Top = 53
                Width = 41
                Height = 17
                Caption = #51060#49345
                TabOrder = 1
                OnClick = OptionChange
              end
              object CheckBox_PLC2_A5: TCheckBox
                Left = 125
                Top = 82
                Width = 41
                Height = 17
                Caption = #51060#49345
                TabOrder = 4
                OnClick = OptionChange
              end
              object Edit_PLC2_D6: TEdit
                Left = 190
                Top = 52
                Width = 50
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 2
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
              object Edit_PLC2_D5: TEdit
                Left = 190
                Top = 80
                Width = 50
                Height = 20
                Alignment = taRightJustify
                ImeName = 'Microsoft Office IME 2007'
                TabOrder = 5
                OnChange = OptionChange
                OnKeyPress = EditKeyPress
              end
            end
            object CheckBox_PLC2: TCheckBox
              Left = 10
              Top = 25
              Width = 74
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
          end
          object GroupBox5: TGroupBox
            Left = 360
            Top = 15
            Width = 345
            Height = 110
            Caption = #47588#47588' '#51068#49884#51221#51648' '#51312#44148' 2'
            TabOrder = 1
            object Label22: TLabel
              Left = 20
              Top = 53
              Width = 64
              Height = 12
              Caption = #52572#45824#49688#51061#51060' '
            end
            object Label23: TLabel
              Left = 219
              Top = 135
              Width = 4
              Height = 12
            end
            object Label24: TLabel
              Left = 145
              Top = 52
              Width = 172
              Height = 12
              Caption = #47564#50896#50640' '#47803#48120#52824#44256' '#49552#49892#51012' '#48380' '#44221#50864
            end
            object Label25: TLabel
              Left = 145
              Top = 80
              Width = 196
              Height = 12
              Caption = #47564#50896' '#51060#54616#47196' '#45236#47140#44032#47732' '#47588#47588#51221#51648#54620#45796'.'
            end
            object Label26: TLabel
              Left = 20
              Top = 80
              Width = 36
              Height = 12
              Caption = #49688#51061#51060
            end
            object CheckBoxUsePLC2Type2: TCheckBox
              Left = 10
              Top = 25
              Width = 68
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditPLC2Type2Value2: TEdit
              Left = 84
              Top = 76
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 2
              Text = '-50'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditPLC2Type2Value1: TEdit
              Left = 84
              Top = 48
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '30'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox6: TGroupBox
            Left = 360
            Top = 137
            Width = 345
            Height = 87
            Caption = #47588#47588' '#51068#49884#51221#51648' '#51312#44148' 3'
            TabOrder = 2
            object Label6: TLabel
              Left = 145
              Top = 53
              Width = 196
              Height = 12
              Caption = #47564#50896' '#51060#54616#47196' '#45236#47140#44032#47732' '#47588#47588#51221#51648#54620#45796'.'
            end
            object Label28: TLabel
              Left = 20
              Top = 53
              Width = 40
              Height = 12
              Caption = #49688#51061#51060' '
            end
            object Label31: TLabel
              Left = 20
              Top = 186
              Width = 80
              Height = 12
              Caption = #44288#47532#51204' '#49688#51061#51060' '
            end
            object Label33: TLabel
              Left = 181
              Top = 186
              Width = 200
              Height = 12
              Caption = #47564#50896' '#48372#45796' '#51089#51012' '#44221#50864#50640#47564' '#51116#51652#51077#54620#45796'.'
            end
            object CheckBoxUsePLC2Type3: TCheckBox
              Left = 10
              Top = 25
              Width = 70
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditPLC2Type3: TEdit
              Left = 79
              Top = 50
              Width = 60
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '-80'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditReEnterValue3: TEdit
              Left = 115
              Top = 182
              Width = 60
              Height = 20
              ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
              TabOrder = 2
            end
          end
          object GroupBox24: TGroupBox
            Left = 725
            Top = 15
            Width = 345
            Height = 120
            Caption = #47588#47588' '#51068#49884#51221#51648' '#51312#44148' 1'#51032' '#44277#53685#51312#44148
            TabOrder = 3
            object CheckBoxUsePLC2TypeC_1: TCheckBox
              Left = 10
              Top = 30
              Width = 319
              Height = 17
              Caption = 'MA1 '#51060' '#50672#49549'                    '#54924' '#54616#46973#51068' '#44221#50864
              TabOrder = 0
            end
            object EditPLC2TypeCValue1: TEdit
              Left = 103
              Top = 28
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '1'
            end
            object UpDownPLC2TypeCValue1: TUpDown
              Left = 153
              Top = 28
              Width = 15
              Height = 20
              Associate = EditPLC2TypeCValue1
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 2
            end
            object CheckBoxUsePLC2TypeC_2: TCheckBox
              Left = 10
              Top = 58
              Width = 307
              Height = 17
              Caption = 'MA2 '#51060' '#50672#49549'                    '#54924' '#54616#46973#51068' '#44221#50864
              TabOrder = 3
            end
            object EditPLC2TypeCValue2: TEdit
              Left = 103
              Top = 56
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 4
              Text = '1'
            end
            object UpDownPLC2TypeCValue2: TUpDown
              Left = 153
              Top = 56
              Width = 15
              Height = 20
              Associate = EditPLC2TypeCValue2
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 5
            end
            object CheckBoxUsePLC2TypeC_3: TCheckBox
              Left = 10
              Top = 84
              Width = 240
              Height = 17
              Caption = 'MA1 < MA2 '#51068' '#44221#50864
              TabOrder = 6
            end
          end
          object GroupBox21: TGroupBox
            Left = 360
            Top = 237
            Width = 345
            Height = 212
            Caption = #47588#47588' '#51068#49884#51221#51648' '#51312#44148' 4'
            TabOrder = 4
            object Label91: TLabel
              Left = 10
              Top = 130
              Width = 264
              Height = 12
              Caption = #44288#47532#51204' '#49688#51061#51060'                '#47564#50896' '#51060#49345#51068' '#44221#50864' '#46608#45716','
            end
            object Label12: TLabel
              Left = 10
              Top = 156
              Width = 300
              Height = 12
              Caption = #44288#47532#51204' '#49688#51061#51060'                '#47564#50896' '#51060#54616#51068' '#44221#50864#47564' '#51201#50857#54620#45796'.'
            end
            object Label93: TLabel
              Left = 9
              Top = 184
              Width = 272
              Height = 12
              Caption = #51109' '#49884#51089' '#49884#44036#50640#49436'                 '#48516' '#54980' '#48512#53552' '#51201#50857#54620#45796'.'
            end
            object CheckBoxUsePLC2Type4: TCheckBox
              Left = 10
              Top = 25
              Width = 70
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object CheckBoxUsePLC2Type4_1: TCheckBox
              Left = 10
              Top = 52
              Width = 319
              Height = 17
              Caption = 'MA1 '#51060' '#50672#49549'                    '#54924' '#54616#46973#51068' '#44221#50864
              TabOrder = 1
            end
            object CheckBoxUsePLC2Type4_2: TCheckBox
              Left = 10
              Top = 77
              Width = 307
              Height = 17
              Caption = 'MA2 '#51060' '#50672#49549'                    '#54924' '#54616#46973#51068' '#44221#50864
              TabOrder = 2
            end
            object CheckBoxUsePLC2Type4_3: TCheckBox
              Left = 10
              Top = 103
              Width = 240
              Height = 17
              Caption = 'MA1 < MA2 '#51068' '#44221#50864
              TabOrder = 3
            end
            object EditPLC2Type4Value1: TEdit
              Left = 103
              Top = 49
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 4
              Text = '1'
            end
            object UpDownPLC2Type4Value1: TUpDown
              Left = 153
              Top = 49
              Width = 15
              Height = 20
              Associate = EditPLC2Type4Value1
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 5
            end
            object UpDownPLC2Type4Value2: TUpDown
              Left = 153
              Top = 75
              Width = 15
              Height = 20
              Associate = EditPLC2Type4Value2
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 6
            end
            object EditPLC2Type4Value2: TEdit
              Left = 103
              Top = 75
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 7
              Text = '1'
            end
            object EditPLC2Type4Value3: TEdit
              Left = 90
              Top = 125
              Width = 50
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 8
              Text = '500'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditPLC2Type4Value4: TEdit
              Left = 111
              Top = 179
              Width = 40
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 9
              Text = '3'
              OnChange = OptionChange
            end
            object UpDownPLC2Type4Value4: TUpDown
              Left = 151
              Top = 179
              Width = 15
              Height = 20
              Associate = EditPLC2Type4Value4
              Min = 1
              Max = 300
              Position = 3
              TabOrder = 10
              OnClick = UpDownClick
            end
            object EditPLC2Type4Value5: TEdit
              Left = 90
              Top = 152
              Width = 50
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 11
              Text = '-500'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox35: TGroupBox
            Left = 724
            Top = 237
            Width = 345
            Height = 212
            Caption = #47588#47588' '#51068#49884#51221#51648' '#51312#44148' 5'
            TabOrder = 5
            object Label14: TLabel
              Left = 10
              Top = 130
              Width = 264
              Height = 12
              Caption = #44396#50669#45236' '#49688#51061#51060'                '#47564#50896' '#51060#49345#51068' '#44221#50864' '#46608#45716','
            end
            object Label87: TLabel
              Left = 10
              Top = 156
              Width = 300
              Height = 12
              Caption = #44396#50669#45236' '#49688#51061#51060'                '#47564#50896' '#51060#54616#51068' '#44221#50864#47564' '#51201#50857#54620#45796'.'
            end
            object Label90: TLabel
              Left = 9
              Top = 184
              Width = 272
              Height = 12
              Caption = #51109' '#49884#51089' '#49884#44036#50640#49436'                 '#48516' '#54980' '#48512#53552' '#51201#50857#54620#45796'.'
            end
            object CheckBoxUsePLC2Type5: TCheckBox
              Left = 10
              Top = 25
              Width = 70
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
            end
            object CheckBoxUsePLC2Type5_1: TCheckBox
              Left = 10
              Top = 52
              Width = 319
              Height = 17
              Caption = 'MA1 '#51060' '#50672#49549'                    '#54924' '#54616#46973#51068' '#44221#50864
              TabOrder = 1
            end
            object CheckBoxUsePLC2Type5_2: TCheckBox
              Left = 10
              Top = 75
              Width = 307
              Height = 17
              Caption = 'MA2 '#51060' '#50672#49549'                    '#54924' '#54616#46973#51068' '#44221#50864
              TabOrder = 2
            end
            object CheckBoxUsePLC2Type5_3: TCheckBox
              Left = 10
              Top = 97
              Width = 240
              Height = 17
              Caption = 'MA1 < MA2 '#51068' '#44221#50864
              TabOrder = 3
            end
            object EditPLC2Type5Value1: TEdit
              Left = 107
              Top = 49
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 4
              Text = '1'
            end
            object UpDownPLC2Type5Value1: TUpDown
              Left = 157
              Top = 49
              Width = 15
              Height = 20
              Associate = EditPLC2Type5Value1
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 5
            end
            object UpDownPLC2Type5Value2: TUpDown
              Left = 157
              Top = 73
              Width = 15
              Height = 20
              Associate = EditPLC2Type5Value2
              Min = 1
              Max = 150
              Position = 1
              TabOrder = 6
            end
            object EditPLC2Type5Value2: TEdit
              Left = 107
              Top = 73
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 7
              Text = '1'
            end
            object EditPLC2Type5Value3: TEdit
              Left = 90
              Top = 125
              Width = 50
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 8
              Text = '500'
            end
            object EditPLC2Type5Value4: TEdit
              Left = 111
              Top = 179
              Width = 40
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 9
              Text = '3'
            end
            object UpDownPLC2Type5Value4: TUpDown
              Left = 151
              Top = 179
              Width = 15
              Height = 20
              Associate = EditPLC2Type5Value4
              Min = 1
              Max = 300
              Position = 3
              TabOrder = 10
            end
            object EditPLC2Type5Value5: TEdit
              Left = 90
              Top = 152
              Width = 50
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 11
              Text = '-500'
            end
          end
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = #51204#52404' '#47196#49828#52983' '#54620#46020
      ImageIndex = 4
      object Panel8: TPanel
        Left = 0
        Top = 0
        Width = 1141
        Height = 619
        Align = alClient
        BevelOuter = bvNone
        Color = 5592405
        Padding.Left = 1
        Padding.Top = 3
        Padding.Right = 1
        Padding.Bottom = 1
        ParentBackground = False
        TabOrder = 0
        object Panel9: TPanel
          Left = 1
          Top = 3
          Width = 1139
          Height = 615
          Align = alClient
          BevelKind = bkFlat
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object GroupBox13: TGroupBox
            Left = 5
            Top = 15
            Width = 345
            Height = 88
            Caption = #49552#49892#51221#51648
            TabOrder = 0
            object Label62: TLabel
              Left = 20
              Top = 53
              Width = 60
              Height = 12
              Caption = #52572#45824#49552#49892#51060
            end
            object Label63: TLabel
              Left = 219
              Top = 135
              Width = 4
              Height = 12
            end
            object Label64: TLabel
              Left = 145
              Top = 52
              Width = 156
              Height = 12
              Caption = #47564#50896#48372#45796' '#51089#51012' '#44221#50864' '#47588#47588#51473#51648
            end
            object CheckBoxUseLossTradeStop: TCheckBox
              Left = 10
              Top = 25
              Width = 68
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditLossTradeStopValue1: TEdit
              Left = 84
              Top = 48
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '-200'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox14: TGroupBox
            Left = 5
            Top = 120
            Width = 345
            Height = 88
            Caption = #49688#51061#51221#51648
            TabOrder = 1
            object Label65: TLabel
              Left = 20
              Top = 53
              Width = 60
              Height = 12
              Caption = #52572#45824#51060#51061#51060
            end
            object Label66: TLabel
              Left = 219
              Top = 135
              Width = 4
              Height = 12
            end
            object Label67: TLabel
              Left = 145
              Top = 52
              Width = 144
              Height = 12
              Caption = #47564#50896#48372#45796' '#53364' '#44221#50864' '#47588#47588#51473#51648
            end
            object CheckBoxUseProfitTradeStop: TCheckBox
              Left = 10
              Top = 25
              Width = 68
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditProfitTradeStopValue1: TEdit
              Left = 84
              Top = 48
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '1000'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = #49688#51061' '#51060#54217' '#51312#44148
      ImageIndex = 5
      object Bevel2: TBevel
        Left = 714
        Top = 20
        Width = 2
        Height = 366
      end
      object Panel13: TPanel
        Left = 0
        Top = 0
        Width = 1141
        Height = 619
        Align = alClient
        BevelOuter = bvNone
        Color = 8061051
        Padding.Left = 1
        Padding.Top = 3
        Padding.Right = 1
        Padding.Bottom = 1
        ParentBackground = False
        TabOrder = 0
        object Panel15: TPanel
          Left = 1
          Top = 3
          Width = 1139
          Height = 615
          Align = alClient
          BevelKind = bkFlat
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object GroupBox19: TGroupBox
            Left = 5
            Top = 15
            Width = 345
            Height = 228
            Caption = #49688#51061#51060#46041#54217#44512#49440' '#49444#51221
            TabOrder = 0
            object Label68: TLabel
              Left = 13
              Top = 63
              Width = 93
              Height = 12
              Caption = 'MA1 '#51032' '#44228#49328#51452#44592
            end
            object Label69: TLabel
              Left = 13
              Top = 94
              Width = 93
              Height = 12
              Caption = 'MA2 '#51032' '#44228#49328#51452#44592
            end
            object Label95: TLabel
              Left = 13
              Top = 31
              Width = 93
              Height = 12
              Caption = 'MA0 '#51032' '#44228#49328#51452#44592
            end
            object EditMA1Number: TEdit
              Left = 114
              Top = 60
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 0
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownMA1Number: TUpDown
              Left = 164
              Top = 60
              Width = 15
              Height = 20
              Associate = EditMA1Number
              Min = 1
              Max = 1200
              Position = 1
              TabOrder = 1
              OnClick = UpDownClick
            end
            object EditMA2Number: TEdit
              Left = 114
              Top = 91
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 2
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownMA2Number: TUpDown
              Left = 164
              Top = 91
              Width = 15
              Height = 20
              Associate = EditMA2Number
              Min = 1
              Max = 1200
              Position = 1
              TabOrder = 3
              OnClick = UpDownClick
            end
            object ComboBoxMAType: TComboBox
              Left = 13
              Top = 122
              Width = 169
              Height = 20
              Style = csDropDownList
              ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
              ItemHeight = 12
              ItemIndex = 0
              TabOrder = 4
              Text = #45800#49692' '#51060#46041#54217#44512
              Items.Strings = (
                #45800#49692' '#51060#46041#54217#44512
                #44032#51473' '#51060#46041#54217#44512
                #51648#49688' '#51060#46041#54217#44512)
            end
            object EditMA0Number: TEdit
              Left = 114
              Top = 28
              Width = 50
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 5
              Text = '1'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownMA0Number: TUpDown
              Left = 164
              Top = 28
              Width = 15
              Height = 20
              Associate = EditMA0Number
              Min = 1
              Max = 1200
              Position = 1
              TabOrder = 6
              OnClick = UpDownClick
            end
          end
        end
      end
    end
    object TabSheet7: TTabSheet
      Caption = #51333#47785' '#51088#46041#49440#51221
      ImageIndex = 6
      object Panel10: TPanel
        Left = 0
        Top = 0
        Width = 1141
        Height = 619
        Align = alClient
        BevelOuter = bvNone
        Color = 8061051
        Padding.Left = 1
        Padding.Top = 3
        Padding.Right = 1
        Padding.Bottom = 1
        ParentBackground = False
        TabOrder = 0
        object Panel11: TPanel
          Left = 1
          Top = 3
          Width = 1139
          Height = 615
          Align = alClient
          BevelKind = bkFlat
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object GroupBox17: TGroupBox
            Left = 5
            Top = 15
            Width = 700
            Height = 118
            Caption = #51077#47141#51312#44148
            TabOrder = 0
            object Label80: TLabel
              Left = 219
              Top = 135
              Width = 4
              Height = 12
            end
            object Label75: TLabel
              Left = 20
              Top = 32
              Width = 60
              Height = 12
              Caption = #44592#44036#49440#53469' : '
            end
            object Label76: TLabel
              Left = 266
              Top = 33
              Width = 36
              Height = 12
              Caption = #49849#50984' : '
            end
            object Label77: TLabel
              Left = 20
              Top = 64
              Width = 71
              Height = 12
              Caption = 'Profit factor :'
            end
            object Label78: TLabel
              Left = 266
              Top = 63
              Width = 39
              Height = 12
              Caption = 'MDD : '
            end
            object Label79: TLabel
              Left = 398
              Top = 32
              Width = 24
              Height = 12
              Caption = #51060#49345
            end
            object Label81: TLabel
              Left = 185
              Top = 62
              Width = 24
              Height = 12
              Caption = #51060#49345
            end
            object Label82: TLabel
              Left = 398
              Top = 63
              Width = 24
              Height = 12
              Caption = #51060#54616
            end
            object Label97: TLabel
              Left = 20
              Top = 93
              Width = 104
              Height = 12
              Caption = #49884#48044#47112#51060#49496' '#44396#49457'  : '
            end
            object ComboBoxASS_DATECOUNT4: TComboBox
              Left = 95
              Top = 29
              Width = 80
              Height = 20
              Style = csDropDownList
              ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
              ItemHeight = 12
              TabOrder = 0
              Items.Strings = (
                '15'#51068
                '30'#51068
                '60'#51068
                '120'#51068
                '180'#51068)
            end
            object EditASS_PERCENT_PROFITABLE: TEdit
              Left = 308
              Top = 29
              Width = 80
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '30'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditASS_PROFIT_FACTOR: TEdit
              Left = 95
              Top = 59
              Width = 80
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 2
              Text = '30'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object EditASS_MAXDRAWDOWN: TEdit
              Left = 308
              Top = 59
              Width = 80
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 3
              Text = '30'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object ButtonRQ: TButton
              Left = 480
              Top = 24
              Width = 200
              Height = 25
              Caption = #50836#52397
              TabOrder = 4
            end
            object ButtonApply: TButton
              Left = 480
              Top = 60
              Width = 200
              Height = 25
              Caption = #44060#48324#51312#44148#50640' '#51333#47785#44284' '#51060#54217' '#51201#50857
              TabOrder = 5
              OnClick = ButtonApplyClick
            end
            object ComboBoxASS_TYPE: TComboBox
              Left = 130
              Top = 88
              Width = 187
              Height = 20
              Style = csDropDownList
              ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
              ItemHeight = 12
              TabOrder = 6
              Items.Strings = (
                #52572#44256#49688#51061'('#51204#51068#45936#51060#53552#49324#50857#54632')'
                #47564#51109#51068#52824'('#51204#51068#45936#51060#53552#49324#50857#54632')'
                #52572#44256#49688#51061'('#51204#51068#45936#51060#53552#49324#50857#50504#54632')')
            end
          end
          object Panel12: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 141
            Width = 700
            Height = 323
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            BevelKind = bkFlat
            BevelOuter = bvNone
            TabOrder = 1
            object ListViewASSItem: TListView
              Left = 0
              Top = 0
              Width = 696
              Height = 319
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              Columns = <
                item
                  Caption = #49692#48264
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = 'RA'
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = 'RB'
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = 'RB'#51452#44592
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = 'RANK'
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = #49688#51061
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = #49849#50984
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = 'P.F.'
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = 'MDD'
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = #51333#47785
                  Width = 100
                end>
              ColumnClick = False
              DoubleBuffered = True
              GridLines = True
              OwnerData = True
              ReadOnly = True
              RowSelect = True
              ParentDoubleBuffered = False
              ShowWorkAreas = True
              TabOrder = 0
              ViewStyle = vsReport
            end
          end
        end
      end
    end
    object TabSheet8: TTabSheet
      Caption = #44592#53440' '#49444#51221
      ImageIndex = 7
      object Panel16: TPanel
        Left = 0
        Top = 0
        Width = 1141
        Height = 619
        Align = alClient
        BevelOuter = bvNone
        Color = 8061051
        Padding.Left = 1
        Padding.Top = 3
        Padding.Right = 1
        Padding.Bottom = 1
        ParentBackground = False
        TabOrder = 0
        object Panel17: TPanel
          Left = 1
          Top = 3
          Width = 1139
          Height = 615
          Align = alClient
          BevelKind = bkFlat
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object GroupBox26: TGroupBox
            Left = 711
            Top = 15
            Width = 345
            Height = 84
            Caption = #47588#47588' '#49345#54889' '#48516#49437#50857
            TabOrder = 0
            object Label83: TLabel
              Left = 15
              Top = 39
              Width = 48
              Height = 12
              Caption = #49688#49688#47308' : '
            end
            object Label84: TLabel
              Left = 219
              Top = 135
              Width = 4
              Height = 12
            end
            object Label85: TLabel
              Left = 132
              Top = 40
              Width = 10
              Height = 12
              Caption = '%'
            end
            object EditCommission: TEdit
              Left = 69
              Top = 36
              Width = 55
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 0
              Text = '0.01'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
          end
          object GroupBox25: TGroupBox
            Left = 5
            Top = 146
            Width = 345
            Height = 95
            Caption = #51204#51068' '#52264#53944#45936#51060#53552#49324#50857' '#50976#47924' '#44053#51228#49444#51221
            TabOrder = 1
            object CheckBox_UsePrevData: TCheckBox
              Left = 20
              Top = 50
              Width = 224
              Height = 17
              Caption = #51204#51068' '#50689#50629#51068' '#45936#51060#53552' '#49324#50857#54616#44592
              TabOrder = 0
              OnClick = OptionChange
            end
            object CheckBox_FS_PrevData: TCheckBox
              Left = 10
              Top = 25
              Width = 68
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 1
              OnClick = OptionChange
            end
          end
          object GroupBox10: TGroupBox
            Left = 5
            Top = 15
            Width = 345
            Height = 118
            Caption = #47588#47588#49884#51089#49884#44036' '#44053#51228#49444#51221
            TabOrder = 2
            object Label48: TLabel
              Left = 219
              Top = 135
              Width = 4
              Height = 12
            end
            object Label47: TLabel
              Left = 20
              Top = 56
              Width = 96
              Height = 12
              Caption = #51109' '#49884#51089' '#49884#44036#50640#49436' '
            end
            object Label49: TLabel
              Left = 191
              Top = 57
              Width = 112
              Height = 12
              Caption = #48516' '#54980' '#48512#53552' '#47588#47588' '#49884#51089
            end
            object Label89: TLabel
              Left = 20
              Top = 88
              Width = 32
              Height = 12
              Caption = #49884#51089' :'
            end
            object CheckBoxUseEnterB: TCheckBox
              Left = 10
              Top = 25
              Width = 68
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditEnterBValue1: TEdit
              Left = 118
              Top = 54
              Width = 50
              Height = 20
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '3'
              OnChange = OptionChange
              OnKeyPress = EditKeyPress
            end
            object UpDownEnterBValue1: TUpDown
              Left = 168
              Top = 54
              Width = 15
              Height = 20
              Associate = EditEnterBValue1
              Min = 1
              Max = 300
              Position = 3
              TabOrder = 2
              OnClick = UpDownClick
            end
            object DateTimePickerEnterBValue1: TDateTimePicker
              Left = 58
              Top = 84
              Width = 100
              Height = 20
              Date = 41114.430841481480000000
              Time = 41114.430841481480000000
              Enabled = False
              ImeName = 'Microsoft Office IME 2007'
              Kind = dtkTime
              TabOrder = 3
            end
          end
          object GroupBox34: TGroupBox
            Left = 360
            Top = 15
            Width = 345
            Height = 292
            Caption = #51333#47785#48324#51204#51068' '#52264#53944#45936#51060#53552#50976#54805' '#44053#51228#49444#51221
            TabOrder = 3
            object Panel20: TPanel
              Left = 2
              Top = 14
              Width = 341
              Height = 276
              Align = alClient
              BevelOuter = bvNone
              Padding.Left = 5
              Padding.Top = 5
              Padding.Right = 5
              Padding.Bottom = 5
              TabOrder = 0
              object Panel21: TPanel
                Left = 5
                Top = 36
                Width = 331
                Height = 235
                Align = alClient
                BevelKind = bkTile
                BevelOuter = bvNone
                BorderWidth = 1
                Ctl3D = True
                ParentCtl3D = False
                TabOrder = 0
                object ListViewOPSSymbol: TListView
                  Left = 1
                  Top = 1
                  Width = 325
                  Height = 192
                  Align = alClient
                  BevelOuter = bvNone
                  BorderStyle = bsNone
                  Columns = <
                    item
                      Caption = #51333#47785#53076#46300
                      Width = 90
                    end
                    item
                      Caption = #51204#51068#45936#51060#53440' '#50976#54805
                      Width = 120
                    end>
                  ColumnClick = False
                  Ctl3D = False
                  GridLines = True
                  ReadOnly = True
                  RowSelect = True
                  TabOrder = 0
                  ViewStyle = vsReport
                end
                object Panel22: TPanel
                  Left = 1
                  Top = 193
                  Width = 325
                  Height = 37
                  Align = alBottom
                  BevelKind = bkFlat
                  BevelOuter = bvNone
                  Ctl3D = True
                  ParentCtl3D = False
                  TabOrder = 1
                  object Label136: TLabel
                    Left = 10
                    Top = 12
                    Width = 104
                    Height = 12
                    Caption = #51204#51068' '#45936#51060#53552' '#52376#47532' : '
                  end
                  object ComboBoxSymbolPrevDataType: TComboBox
                    Left = 120
                    Top = 7
                    Width = 133
                    Height = 20
                    Style = csDropDownList
                    ImeName = 'Microsoft Office IME 2007'
                    ItemHeight = 12
                    ItemIndex = 0
                    TabOrder = 0
                    Text = #45817#51068' '#49884#44032#47196' '#45824#52824
                    OnChange = ComboBoxSymbolPrevDataTypeChange
                    Items.Strings = (
                      #45817#51068' '#49884#44032#47196' '#45824#52824
                      #50896' '#45936#51060#53552#47484' '#49324#50857)
                  end
                end
              end
              object Panel23: TPanel
                Left = 5
                Top = 5
                Width = 331
                Height = 31
                Align = alTop
                BevelEdges = [beLeft, beTop, beRight]
                BevelOuter = bvNone
                Ctl3D = True
                ParentCtl3D = False
                TabOrder = 1
                object CheckBox_FS_PrevDataType: TCheckBox
                  Left = 10
                  Top = 6
                  Width = 68
                  Height = 17
                  Caption = #49324#50857#50668#48512
                  TabOrder = 0
                  OnClick = OptionChange
                end
              end
            end
          end
          object GroupBox28: TGroupBox
            Left = 711
            Top = 105
            Width = 345
            Height = 140
            Caption = #54252#53944#54260#47532#50724' '#44288#47532#51221#48372
            TabOrder = 4
            object Label98: TLabel
              Left = 15
              Top = 53
              Width = 124
              Height = 12
              Caption = #54252#53664#54260#47532#50724' '#44536#47353#51060#47492' : '
            end
            object Label107: TLabel
              Left = 15
              Top = 83
              Width = 100
              Height = 12
              Caption = #54252#53664#54260#47532#50724' '#51060#47492' : '
            end
            object EditPortfolioGroupName: TEdit
              Left = 145
              Top = 50
              Width = 185
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              MaxLength = 32
              TabOrder = 0
            end
            object EditPortfolioName: TEdit
              Left = 145
              Top = 80
              Width = 185
              Height = 20
              ImeName = 'Microsoft Office IME 2007'
              MaxLength = 32
              TabOrder = 1
            end
          end
          object GroupBox38: TGroupBox
            Left = 5
            Top = 254
            Width = 345
            Height = 53
            Caption = #47532#48260#49828#47588#47588
            TabOrder = 5
            object CheckBoxUseReverse: TCheckBox
              Left = 10
              Top = 25
              Width = 68
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 0
              OnClick = OptionChange
            end
          end
        end
      end
    end
    object TabSheet9: TTabSheet
      Caption = '---'
      ImageIndex = 8
      object PanelCommand: TPanel
        Left = 0
        Top = 0
        Width = 1141
        Height = 619
        Align = alClient
        BevelOuter = bvNone
        Color = 8061051
        Padding.Left = 1
        Padding.Top = 3
        Padding.Right = 1
        Padding.Bottom = 1
        ParentBackground = False
        TabOrder = 0
        object Panel19: TPanel
          Left = 1
          Top = 3
          Width = 1139
          Height = 615
          Align = alClient
          BevelKind = bkFlat
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object Button2: TButton
            Left = 20
            Top = 51
            Width = 120
            Height = 25
            Caption = #51221#51648
            TabOrder = 0
          end
          object Button1: TButton
            Left = 20
            Top = 20
            Width = 120
            Height = 25
            Caption = #51652#51077
            TabOrder = 1
          end
          object Button3: TButton
            Left = 20
            Top = 93
            Width = 120
            Height = 25
            Caption = #48152#45824#47588#47588
            TabOrder = 2
          end
        end
      end
    end
  end
end
