object MatrixOptionFrame: TMatrixOptionFrame
  Left = 0
  Top = 0
  Width = 1149
  Height = 681
  Margins.Bottom = 10
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1149
    Height = 681
    ActivePage = TabSheet1
    Align = alClient
    TabHeight = 26
    TabOrder = 0
    TabWidth = 120
    object TabSheet1: TTabSheet
      Caption = #51204#47029
      ImageIndex = 2
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1141
        Height = 645
        Align = alClient
        BevelOuter = bvNone
        Color = 6076508
        Padding.Left = 5
        Padding.Top = 5
        Padding.Right = 5
        Padding.Bottom = 5
        ParentBackground = False
        TabOrder = 0
        StyleElements = []
        object Panel8: TPanel
          Left = 5
          Top = 5
          Width = 1131
          Height = 635
          Align = alClient
          BevelOuter = bvNone
          Ctl3D = True
          ParentBackground = False
          ParentCtl3D = False
          TabOrder = 0
          object Panel9: TPanel
            Left = 0
            Top = 0
            Width = 1131
            Height = 45
            Align = alTop
            BevelOuter = bvNone
            Padding.Left = 5
            Padding.Top = 5
            Padding.Right = 5
            Padding.Bottom = 5
            ParentBackground = False
            TabOrder = 0
            object ComboBoxTradeStrategy: TComboBox
              Left = 2
              Top = 6
              Width = 359
              Height = 29
              Style = csDropDownList
              Ctl3D = True
              DropDownCount = 32
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = #47569#51008' '#44256#46357
              Font.Style = []
              ImeName = 'Microsoft Office IME 2007'
              ItemIndex = 0
              ParentCtl3D = False
              ParentFont = False
              TabOrder = 0
              Text = 'Stochastic '#52628#49464' 1'
              OnChange = ComboBoxTradeStrategyChange
              Items.Strings = (
                'Stochastic '#52628#49464' 1'
                'Stochastic '#52628#49464' 2'
                'Stochastic '#52628#49464' 3'
                'Stochastic '#48708#52628#49464' 1'
                'Stochastic '#48708#52628#49464' 2'
                'RSI '#52628#49464
                'RSI '#48708#52628#49464
                'Bollinger Bands '#52628#49464
                'Disparity '#52628#49464
                'Disparity '#48708#52628#49464
                'BaseLine '#52628#49464'1'
                'BaseLine '#52628#49464'2'
                'BaseLine '#48708#52628#49464'1'
                #51068#47785#44512#54805#54364' '#52628#49464'1'
                #51068#47785#44512#54805#54364' '#52628#49464'2'
                #51068#47785#44512#54805#54364' '#52628#49464'3'
                'MOV '#52628#49464'1'
                'MOV '#52628#49464'2'
                'MOV '#52628#49464'3'
                'MOV '#48708#52628#49464'1'
                'MOV '#48708#52628#49464'2'
                #49345#44288#44288#44228)
            end
          end
          object Panel11: TPanel
            Left = 0
            Top = 45
            Width = 1131
            Height = 590
            Align = alClient
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 1
            object PageControlStrategyConfig: TPageControl
              Left = 0
              Top = 0
              Width = 1131
              Height = 590
              ActivePage = TabSheetCFG01
              Align = alClient
              TabHeight = 26
              TabOrder = 0
              TabWidth = 90
              object TabSheetCFG01: TTabSheet
                Caption = #49444#51221
                object Panel6: TPanel
                  Left = 0
                  Top = 0
                  Width = 1123
                  Height = 554
                  Align = alClient
                  BevelOuter = bvNone
                  Color = 14598235
                  Padding.Left = 5
                  Padding.Top = 5
                  Padding.Right = 5
                  Padding.Bottom = 5
                  ParentBackground = False
                  TabOrder = 0
                  StyleElements = []
                  object Panel21: TPanel
                    Left = 5
                    Top = 5
                    Width = 1113
                    Height = 544
                    Align = alClient
                    BevelOuter = bvNone
                    Padding.Left = 5
                    Padding.Top = 5
                    Padding.Right = 5
                    Padding.Bottom = 5
                    ParentBackground = False
                    TabOrder = 0
                    object PageControl3: TPageControl
                      Left = 5
                      Top = 5
                      Width = 1103
                      Height = 534
                      ActivePage = TabSheet13
                      Align = alClient
                      TabHeight = 26
                      TabOrder = 0
                      TabWidth = 90
                      object TabSheet13: TTabSheet
                        Caption = #44592#48376
                        object PageControlStrategy: TPageControl
                          Left = 0
                          Top = 0
                          Width = 1095
                          Height = 498
                          ActivePage = TabSheetX000
                          Align = alClient
                          TabOrder = 0
                          TabPosition = tpBottom
                          TabWidth = 10
                          OnChange = ComboBoxTradeStrategyChange
                          object TabSheetX000: TTabSheet
                            inline STC_T1_Frame1: TSTC_T1_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheetX010: TTabSheet
                            ImageIndex = 2
                            inline STC_T2_Frame1: TSTC_T2_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                              inherited PopupMenuOption: TPopupMenu
                                Left = 258
                                Top = 244
                              end
                            end
                          end
                          object TabSheetX020: TTabSheet
                            ImageIndex = 4
                            inline STC_T3_Frame1: TSTC_T3_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitTop = 85
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitTop = 92
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitTop = 145
                                  ExplicitWidth = 1083
                                  inherited UpDownLENGTH1: TUpDown
                                    Height = 25
                                    ExplicitHeight = 25
                                  end
                                  inherited UpDownLENGTH2: TUpDown
                                    Height = 25
                                    ExplicitHeight = 25
                                  end
                                  inherited UpDownLENGTH3: TUpDown
                                    Height = 25
                                    ExplicitHeight = 25
                                  end
                                  inherited UpDownLENGTH4: TUpDown
                                    Height = 25
                                    ExplicitHeight = 25
                                  end
                                  inherited UpDownLENGTH5: TUpDown
                                    Height = 25
                                    ExplicitHeight = 25
                                  end
                                  inherited UpDownLENGTH6: TUpDown
                                    Height = 25
                                    ExplicitHeight = 25
                                  end
                                  inherited UpDownUP: TUpDown
                                    Height = 25
                                    ExplicitHeight = 25
                                  end
                                  inherited UpDownDN: TUpDown
                                    Height = 25
                                    ExplicitHeight = 25
                                  end
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitTop = 138
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitTop = 281
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  ExplicitTop = 288
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheetX030: TTabSheet
                            ImageIndex = 3
                            inline STC_N1_Frame1: TSTC_N1_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheetX040: TTabSheet
                            ImageIndex = 9
                            inline STC_N2_Frame1: TSTC_N2_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheetX050: TTabSheet
                            ImageIndex = 4
                            inline RSI_T1_Frame1: TRSI_T1_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheetX060: TTabSheet
                            ImageIndex = 5
                            inline RSI_N1_Frame1: TRSI_N1_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox3: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheetX070: TTabSheet
                            ImageIndex = 6
                            inline BB_T1_Frame1: TBB_T1_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheetX080: TTabSheet
                            ImageIndex = 7
                            inline DISPARITY_T1_Frame1: TDISPARITY_T1_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  Height = 317
                                  ExplicitWidth = 1083
                                  ExplicitHeight = 317
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheetX090: TTabSheet
                            ImageIndex = 8
                            inline DISPARITY_N1_Frame1: TDISPARITY_N1_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  Height = 205
                                  ExplicitWidth = 1083
                                  ExplicitHeight = 205
                                end
                              end
                            end
                          end
                          object TabSheetX100: TTabSheet
                            ImageIndex = 10
                            inline BASELINE_T1_Frame1: TBASELINE_T1_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox3: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  Height = 149
                                  ExplicitWidth = 1083
                                  ExplicitHeight = 149
                                end
                              end
                            end
                          end
                          object TabSheetX110: TTabSheet
                            ImageIndex = 11
                            inline BASELINE_T2_Frame1: TBASELINE_T2_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox3: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheetX120: TTabSheet
                            ImageIndex = 12
                            inline BASELINE_N1_Frame1: TBASELINE_N1_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox3: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheetX130: TTabSheet
                            ImageIndex = 13
                            inline IM_T1_Frame1: TIM_T1_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox3: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheetX140: TTabSheet
                            ImageIndex = 14
                            inline IM_T2_Frame1: TIM_T2_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox3: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheetX150: TTabSheet
                            ImageIndex = 15
                            inline IM_T3_Frame1: TIM_T3_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel8: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox3: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheet160: TTabSheet
                            ImageIndex = 16
                            inline MOV_T1_Frame1: TMOV_T1_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox3: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheet170: TTabSheet
                            ImageIndex = 17
                            inline MOV_T2_Frame1: TMOV_T2_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitTop = 85
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitTop = 142
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  ExplicitTop = 149
                                  ExplicitWidth = 1083
                                  inherited UpDownLENGTH1: TUpDown
                                    Height = 25
                                    ExplicitHeight = 25
                                  end
                                  inherited UpDownLENGTH2: TUpDown
                                    Height = 25
                                    ExplicitHeight = 25
                                  end
                                  inherited UpDownLENGTH3: TUpDown
                                    Height = 25
                                    ExplicitHeight = 25
                                  end
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitTop = 351
                                  ExplicitWidth = 1083
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitTop = 259
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox3: TGroupBox
                                  Width = 1083
                                  ExplicitTop = 266
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheet180: TTabSheet
                            ImageIndex = 18
                            inline MOV_T3_Frame1: TMOV_T3_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitTop = 85
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitTop = 142
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitTop = 286
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  ExplicitTop = 149
                                  ExplicitWidth = 1083
                                  inherited UpDownLENGTH1: TUpDown
                                    Height = 25
                                    ExplicitHeight = 25
                                  end
                                  inherited UpDownPRECISION: TUpDown
                                    Height = 25
                                    ExplicitHeight = 25
                                  end
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitTop = 279
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheet190: TTabSheet
                            ImageIndex = 19
                            inline MOV_N1_Frame1: TMOV_N1_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox3: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheet200: TTabSheet
                            ImageIndex = 20
                            inline MOV_N2_Frame1: TMOV_N2_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox1: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel6: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel7: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBox3: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                          object TabSheetX210: TTabSheet
                            ImageIndex = 21
                            inline REL_T1_Frame1: TREL_T1_Frame
                              Left = 0
                              Top = 0
                              Width = 1087
                              Height = 468
                              Align = alClient
                              Font.Charset = ANSI_CHARSET
                              Font.Color = clWindowText
                              Font.Height = -13
                              Font.Name = #47569#51008' '#44256#46357
                              Font.Style = []
                              ParentFont = False
                              TabOrder = 0
                              ExplicitWidth = 1087
                              ExplicitHeight = 468
                              inherited Panel1: TPanel
                                Width = 1087
                                Height = 468
                                ExplicitWidth = 1087
                                ExplicitHeight = 468
                                inherited GroupBox2: TGroupBox
                                  Width = 1083
                                  Height = 317
                                  ExplicitWidth = 1083
                                  ExplicitHeight = 317
                                end
                                inherited Panel2: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel3: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxMajorType: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel4: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited Panel5: TPanel
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                                inherited GroupBoxOptionManagement: TGroupBox
                                  Width = 1083
                                  ExplicitWidth = 1083
                                end
                              end
                            end
                          end
                        end
                      end
                      object TabSheet14: TTabSheet
                        Caption = #48372#44053
                        ImageIndex = 1
                        inline m_REINFORCE_Frame: TREINFORCE_Frame
                          Left = 0
                          Top = 0
                          Width = 1095
                          Height = 498
                          Align = alClient
                          Font.Charset = ANSI_CHARSET
                          Font.Color = clWindowText
                          Font.Height = -13
                          Font.Name = #47569#51008' '#44256#46357
                          Font.Style = []
                          ParentFont = False
                          TabOrder = 0
                          ExplicitWidth = 1095
                          ExplicitHeight = 498
                          inherited Panel9: TPanel
                            Width = 1095
                            Height = 498
                            ExplicitWidth = 1095
                            ExplicitHeight = 498
                            inherited Panel2: TPanel
                              Width = 1083
                              ExplicitWidth = 1083
                            end
                            inherited Panel3: TPanel
                              Width = 1083
                              ExplicitWidth = 1083
                            end
                            inherited GroupBox1: TGroupBox
                              Width = 1083
                              ExplicitWidth = 1083
                              inherited Label2: TLabel
                                Width = 96
                                Height = 17
                                ExplicitWidth = 96
                                ExplicitHeight = 17
                              end
                              inherited Label4: TLabel
                                Width = 153
                                Height = 17
                                ExplicitWidth = 153
                                ExplicitHeight = 17
                              end
                              inherited Label1: TLabel
                                Width = 109
                                Height = 17
                                ExplicitWidth = 109
                                ExplicitHeight = 17
                              end
                              inherited ComboBoxRF1_STD_VALUE: TComboBox
                                Height = 25
                                ExplicitHeight = 25
                              end
                              inherited ComboBoxRF1_PRICEMETHOD: TComboBox
                                Height = 25
                                ExplicitHeight = 25
                              end
                              inherited ComboBoxRF1_VALUE_TYPE: TComboBox
                                Height = 25
                                ExplicitHeight = 25
                              end
                              inherited GroupBox4: TGroupBox
                                inherited Label3: TLabel
                                  Width = 14
                                  Height = 17
                                  ExplicitWidth = 14
                                  ExplicitHeight = 17
                                end
                                inherited EditRF1_TOLERANCE: TEdit
                                  Height = 25
                                  ExplicitHeight = 25
                                end
                                inherited ComboBoxRF1_TOLERANCE_UNIT: TComboBox
                                  Height = 25
                                  ExplicitHeight = 25
                                end
                              end
                            end
                            inherited GroupBox2: TGroupBox
                              Width = 1083
                              ExplicitWidth = 1083
                            end
                            inherited GroupBox3: TGroupBox
                              Width = 1083
                              ExplicitWidth = 1083
                              inherited Label12: TLabel
                                Width = 109
                                Height = 17
                                ExplicitWidth = 109
                                ExplicitHeight = 17
                              end
                              inherited Label7: TLabel
                                Width = 104
                                Height = 17
                                ExplicitWidth = 104
                                ExplicitHeight = 17
                              end
                              inherited Label8: TLabel
                                Width = 86
                                Height = 17
                                ExplicitWidth = 86
                                ExplicitHeight = 17
                              end
                              inherited Label9: TLabel
                                Width = 104
                                Height = 17
                                ExplicitWidth = 104
                                ExplicitHeight = 17
                              end
                              inherited ComboBoxRF2_VALUE_TYPE: TComboBox
                                Height = 25
                                ExplicitHeight = 25
                              end
                              inherited EditRF2_LENGTH: TEdit
                                Height = 25
                                ExplicitHeight = 25
                              end
                              inherited UpDownRF2_LENGTH: TUpDown
                                Height = 25
                                ExplicitHeight = 25
                              end
                              inherited UpDownRF2_PRECISION: TUpDown
                                Height = 25
                                ExplicitHeight = 25
                              end
                              inherited EditRF2_PRECISION: TEdit
                                Height = 25
                                ExplicitHeight = 25
                              end
                              inherited ComboBoxRF2_AVERAGE_TYPE: TComboBox
                                Height = 25
                                ExplicitHeight = 25
                              end
                            end
                            inherited Panel4: TPanel
                              Width = 1083
                              ExplicitWidth = 1083
                            end
                            inherited Panel5: TPanel
                              Width = 1083
                              ExplicitWidth = 1083
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
              object TabSheetCFG02: TTabSheet
                Caption = #54596#53552
                ImageIndex = 1
                object Panel5: TPanel
                  Left = 0
                  Top = 0
                  Width = 1123
                  Height = 554
                  Align = alClient
                  BevelOuter = bvNone
                  Caption = 'Panel5'
                  Color = 14598235
                  Padding.Left = 5
                  Padding.Top = 5
                  Padding.Right = 5
                  Padding.Bottom = 5
                  ParentBackground = False
                  TabOrder = 0
                  StyleElements = []
                  object Panel2: TPanel
                    Left = 5
                    Top = 5
                    Width = 1113
                    Height = 544
                    Align = alClient
                    BevelOuter = bvNone
                    Padding.Left = 3
                    Padding.Right = 3
                    Padding.Bottom = 2
                    ParentBackground = False
                    TabOrder = 0
                    inline m_Random_Frame: TRandom_Frame
                      Left = 3
                      Top = 0
                      Width = 1107
                      Height = 542
                      Align = alClient
                      TabOrder = 0
                      ExplicitLeft = 3
                      ExplicitWidth = 1107
                      ExplicitHeight = 542
                      inherited Panel9: TPanel
                        Width = 1107
                        Height = 542
                        ExplicitWidth = 1107
                        ExplicitHeight = 542
                        inherited GroupBox1: TGroupBox
                          Width = 1103
                          Height = 445
                          ExplicitWidth = 1103
                          ExplicitHeight = 445
                          inherited RadioButtonRANDOM_CASE1: TRadioButton
                            Top = 55
                            ExplicitTop = 55
                          end
                          inherited RadioButtonRANDOM_CASE2: TRadioButton
                            Top = 79
                            ExplicitTop = 79
                          end
                        end
                        inherited GroupBoxOptionManagement: TGroupBox
                          Width = 1103
                          ExplicitWidth = 1103
                          inherited ComboBoxOptionCollection: TComboBox
                            Height = 25
                            ExplicitHeight = 25
                          end
                        end
                        inherited Panel2: TPanel
                          Width = 1103
                          ExplicitWidth = 1103
                        end
                        inherited Panel3: TPanel
                          Width = 1103
                          ExplicitWidth = 1103
                        end
                        inherited Panel4: TPanel
                          Width = 1103
                          ExplicitWidth = 1103
                        end
                      end
                    end
                  end
                end
              end
              object TabSheetCFG03: TTabSheet
                Caption = #52397#49328
                ImageIndex = 3
                object Panel15: TPanel
                  Left = 0
                  Top = 0
                  Width = 1123
                  Height = 554
                  Align = alClient
                  BevelOuter = bvNone
                  Caption = 'Panel5'
                  Color = 14598235
                  Padding.Left = 5
                  Padding.Top = 5
                  Padding.Right = 5
                  Padding.Bottom = 5
                  ParentBackground = False
                  TabOrder = 0
                  StyleElements = []
                  object Panel13: TPanel
                    Left = 5
                    Top = 5
                    Width = 1113
                    Height = 544
                    Align = alClient
                    BevelOuter = bvNone
                    Padding.Left = 3
                    Padding.Right = 3
                    Padding.Bottom = 2
                    ParentBackground = False
                    TabOrder = 0
                    inline m_EXIT_Frame: TExit_Frame
                      Left = 3
                      Top = 0
                      Width = 1107
                      Height = 542
                      Align = alClient
                      TabOrder = 0
                      ExplicitLeft = 3
                      ExplicitWidth = 1107
                      ExplicitHeight = 542
                      inherited Panel9: TPanel
                        Width = 1107
                        Height = 542
                        ExplicitWidth = 1107
                        ExplicitHeight = 542
                        inherited GroupBox1: TGroupBox
                          Width = 1103
                          ExplicitWidth = 1103
                          inherited Label3: TLabel
                            Width = 213
                            Height = 17
                            ExplicitWidth = 213
                            ExplicitHeight = 17
                          end
                          inherited Label4: TLabel
                            Width = 21
                            Height = 17
                            ExplicitWidth = 21
                            ExplicitHeight = 17
                          end
                          inherited EditPROFITCUT_VALUE_1: TEdit
                            Height = 25
                            ExplicitHeight = 25
                          end
                        end
                        inherited GroupBoxOptionManagement: TGroupBox
                          Width = 1103
                          ExplicitWidth = 1103
                          inherited ComboBoxOptionCollection: TComboBox
                            Height = 25
                            ExplicitHeight = 25
                          end
                        end
                        inherited Panel2: TPanel
                          Width = 1103
                          ExplicitWidth = 1103
                        end
                        inherited Panel3: TPanel
                          Width = 1103
                          ExplicitWidth = 1103
                        end
                        inherited GroupBox2: TGroupBox
                          Width = 1103
                          ExplicitWidth = 1103
                          inherited Label5: TLabel
                            Width = 128
                            Height = 17
                            ExplicitWidth = 128
                            ExplicitHeight = 17
                          end
                          inherited Label7: TLabel
                            Width = 184
                            Height = 17
                            ExplicitWidth = 184
                            ExplicitHeight = 17
                          end
                          inherited Label6: TLabel
                            Width = 21
                            Height = 17
                            ExplicitWidth = 21
                            ExplicitHeight = 17
                          end
                          inherited Label8: TLabel
                            Width = 21
                            Height = 17
                            ExplicitWidth = 21
                            ExplicitHeight = 17
                          end
                          inherited EditTRAILINGSTOP_VALUE_1: TEdit
                            Height = 25
                            ExplicitHeight = 25
                          end
                          inherited EditTRAILINGSTOP_VALUE_2: TEdit
                            Height = 25
                            ExplicitHeight = 25
                          end
                        end
                        inherited GroupBox3: TGroupBox
                          Width = 1103
                          ExplicitWidth = 1103
                          inherited Label2: TLabel
                            Width = 16
                            Height = 17
                            ExplicitWidth = 16
                            ExplicitHeight = 17
                          end
                          inherited Label1: TLabel
                            Width = 218
                            Height = 17
                            ExplicitWidth = 218
                            ExplicitHeight = 17
                          end
                          inherited EditLOSSCUT_VALUE_1: TEdit
                            Height = 25
                            ExplicitHeight = 25
                          end
                        end
                        inherited Panel1: TPanel
                          Width = 1103
                          ExplicitWidth = 1103
                        end
                        inherited Panel4: TPanel
                          Width = 1103
                          ExplicitWidth = 1103
                        end
                        inherited Panel5: TPanel
                          Width = 1103
                          ExplicitWidth = 1103
                        end
                        inherited Panel6: TPanel
                          Width = 1103
                          ExplicitWidth = 1103
                        end
                      end
                    end
                  end
                end
              end
              object TabSheetCFG04: TTabSheet
                Caption = #51116#51652#51077
                ImageIndex = 3
                object Panel16: TPanel
                  Left = 0
                  Top = 0
                  Width = 1123
                  Height = 554
                  Align = alClient
                  BevelOuter = bvNone
                  Color = 14598235
                  Padding.Left = 5
                  Padding.Top = 5
                  Padding.Right = 5
                  Padding.Bottom = 5
                  ParentBackground = False
                  TabOrder = 0
                  StyleElements = []
                  object Panel14: TPanel
                    Left = 5
                    Top = 5
                    Width = 1113
                    Height = 544
                    Align = alClient
                    BevelOuter = bvNone
                    Padding.Left = 3
                    Padding.Right = 3
                    Padding.Bottom = 2
                    ParentBackground = False
                    TabOrder = 0
                    inline m_ENTER_Frame: TENTER_Frame
                      Left = 3
                      Top = 0
                      Width = 1107
                      Height = 542
                      Align = alClient
                      Font.Charset = ANSI_CHARSET
                      Font.Color = clWindowText
                      Font.Height = -13
                      Font.Name = #47569#51008' '#44256#46357
                      Font.Style = []
                      ParentFont = False
                      TabOrder = 0
                      ExplicitLeft = 3
                      ExplicitWidth = 1107
                      ExplicitHeight = 542
                      inherited Panel9: TPanel
                        Width = 1107
                        Height = 542
                        ExplicitWidth = 1107
                        ExplicitHeight = 542
                        inherited GroupBox1: TGroupBox
                          Width = 1103
                          Height = 326
                          Align = alClient
                          ExplicitWidth = 1103
                          ExplicitHeight = 326
                          inherited Label1: TLabel
                            Width = 13
                            Height = 17
                            ExplicitWidth = 13
                            ExplicitHeight = 17
                          end
                          inherited EditMaxEnterCount: TEdit
                            Height = 25
                            ExplicitHeight = 25
                          end
                          inherited UpDownMaxEnterCount: TUpDown
                            Height = 25
                            ExplicitHeight = 25
                          end
                        end
                        inherited GroupBoxOptionManagement: TGroupBox
                          Width = 1103
                          ExplicitWidth = 1103
                          inherited ComboBoxOptionCollection: TComboBox
                            Height = 25
                            ExplicitHeight = 25
                          end
                        end
                        inherited Panel2: TPanel
                          Width = 1103
                          ExplicitWidth = 1103
                        end
                        inherited Panel3: TPanel
                          Width = 1103
                          ExplicitWidth = 1103
                        end
                        inherited Panel1: TPanel
                          Width = 1103
                          ExplicitWidth = 1103
                        end
                        inherited GroupBox2: TGroupBox
                          Width = 1103
                          ExplicitWidth = 1103
                          inherited Label3: TLabel
                            Width = 49
                            Height = 17
                            ExplicitWidth = 49
                            ExplicitHeight = 17
                          end
                          inherited Label5: TLabel
                            Width = 62
                            Height = 17
                            ExplicitWidth = 62
                            ExplicitHeight = 17
                          end
                          inherited Label6: TLabel
                            Width = 70
                            Height = 17
                            ExplicitWidth = 70
                            ExplicitHeight = 17
                          end
                          inherited EditDelayCount: TEdit
                            Height = 25
                            ExplicitHeight = 25
                          end
                          inherited UpDownDelayCount: TUpDown
                            Height = 25
                            ExplicitHeight = 25
                          end
                        end
                        inherited Panel4: TPanel
                          Width = 1103
                          ExplicitWidth = 1103
                        end
                      end
                    end
                  end
                end
              end
            end
            object PanelHide: TPanel
              Left = 912
              Top = 9
              Width = 135
              Height = 15
              BevelOuter = bvNone
              TabOrder = 1
            end
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #47588#47588#51312#44148
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 1141
        Height = 645
        Align = alClient
        BevelOuter = bvNone
        Color = 6076508
        Padding.Left = 5
        Padding.Top = 5
        Padding.Right = 5
        Padding.Bottom = 5
        ParentBackground = False
        TabOrder = 0
        StyleElements = []
        OnClick = Panel3Click
        object Panel7: TPanel
          Left = 5
          Top = 5
          Width = 1131
          Height = 635
          Align = alClient
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object GroupBox8: TGroupBox
            Left = 9
            Top = 285
            Width = 345
            Height = 55
            Caption = #52628#44201#51452#47928
            TabOrder = 0
            object Label16: TLabel
              Left = 10
              Top = 25
              Width = 49
              Height = 17
              Caption = #54001' '#49688'  : '
            end
            object Label17: TLabel
              Left = 154
              Top = 25
              Width = 86
              Height = 17
              Caption = #52572#49548#54840#44032#45800#50948' :'
            end
            object Label22: TLabel
              Left = 312
              Top = 24
              Width = 15
              Height = 17
              Caption = 'pt.'
            end
            object EditTICK_COUNT: TEdit
              Left = 60
              Top = 21
              Width = 40
              Height = 25
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 0
              Text = '5'
              OnClick = OptionChange
            end
            object EditTICK_STEP: TEdit
              Left = 240
              Top = 21
              Width = 70
              Height = 25
              Color = clBtnFace
              ImeName = 'Microsoft Office IME 2007'
              ReadOnly = True
              TabOrder = 2
              Text = '0.05'
            end
            object UpDownTICK_COUNT: TUpDown
              Left = 100
              Top = 21
              Width = 15
              Height = 25
              Associate = EditTICK_COUNT
              Min = 1
              Max = 5
              Position = 5
              TabOrder = 1
              OnClick = UpDownClick
            end
          end
          object RadioGroupSYSTEM_MODE: TRadioGroup
            Left = 714
            Top = 165
            Width = 345
            Height = 50
            Caption = #49884#49828#53596' '#51452#47928' '#47784#46300
            Columns = 2
            Items.Strings = (
              #45236#48512#53580#49828#53944#47784#46300
              #51613#44428#49324' '#49436#48260)
            TabOrder = 1
            Visible = False
            OnClick = RadioGroupSYSTEM_MODEClick
          end
          object GroupBox6: TGroupBox
            Left = 711
            Top = 323
            Width = 345
            Height = 90
            Caption = #44228#51340#51221#48372
            TabOrder = 2
            Visible = False
            object LabelACCOUNT_pw: TLabel
              Left = 10
              Top = 54
              Width = 60
              Height = 17
              Caption = #48708#48128#48264#54840' :'
            end
            object LabelACCOUNT_NO: TLabel
              Left = 10
              Top = 26
              Width = 60
              Height = 17
              Caption = #44228#51340#48264#54840' :'
            end
            object LabelACCOUNT_NAME: TLabel
              Left = 226
              Top = 23
              Width = 109
              Height = 19
              AutoSize = False
            end
            object EditACCOUNT_PW: TEdit
              Left = 100
              Top = 49
              Width = 120
              Height = 25
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              OnChange = OptionChange
            end
            object ComboBoxACCOUNT_NO: TComboBox
              Left = 100
              Top = 19
              Width = 120
              Height = 25
              Style = csDropDownList
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 0
              OnChange = OptionChange
            end
          end
          object GroupBox10: TGroupBox
            Left = 360
            Top = 15
            Width = 345
            Height = 55
            Caption = #47588#47588#49884#49828#53596' '#51221#48372
            TabOrder = 3
            object Label18: TLabel
              Left = 10
              Top = 23
              Width = 156
              Height = 17
              Caption = #49884#49828#53596' '#51060#47492' ('#50689#47928#47564' '#44032#45733'):'
            end
            object EditBLOCK_NAME: TEdit
              Left = 168
              Top = 19
              Width = 167
              Height = 25
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 0
              OnChange = OptionChange
              OnKeyPress = EditBLOCK_NAMEKeyPress
            end
          end
          object GroupBox9: TGroupBox
            Left = 9
            Top = 358
            Width = 345
            Height = 55
            Caption = #53440#51076#54532#47112#51076
            TabOrder = 4
            object Label1: TLabel
              Left = 9
              Top = 26
              Width = 78
              Height = 17
              Caption = #53440#51076#54532#47112#51076' : '
            end
            object RadioButton1: TRadioButton
              Left = 304
              Top = -16
              Width = 113
              Height = 17
              Caption = 'RadioButton1'
              TabOrder = 0
            end
            object ComboBoxTIMEFRAME: TComboBox
              Left = 87
              Top = 22
              Width = 74
              Height = 25
              Style = csDropDownList
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              OnChange = OptionChange
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
                '30'#48516
                '60'#48516)
            end
          end
          object GroupBox1: TGroupBox
            Left = 9
            Top = 15
            Width = 345
            Height = 83
            Caption = #51333#47785#49440#53469#44284' '#49688#47049
            TabOrder = 5
            object LabelSYMBOL: TLabel
              Left = 10
              Top = 26
              Width = 65
              Height = 17
              Caption = #51333#47785' '#53076#46300' :'
            end
            object Label6: TLabel
              Left = 10
              Top = 57
              Width = 65
              Height = 17
              Caption = #51452#47928' '#53076#46300' :'
            end
            object ComboBoxSYMBOL: TComboBox
              Left = 100
              Top = 22
              Width = 120
              Height = 25
              Style = csDropDownList
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 0
              OnChange = ComboBoxSYMBOLChange
            end
            object EditORDER_SYMBOL: TEdit
              Left = 100
              Top = 54
              Width = 120
              Height = 25
              Color = clBtnFace
              ImeName = 'Microsoft Office IME 2007'
              ReadOnly = True
              TabOrder = 1
              Text = '1'
            end
          end
          object GroupBox2: TGroupBox
            Left = 9
            Top = 113
            Width = 345
            Height = 158
            Caption = #51452#47928#44032#44201
            TabOrder = 6
            object Label3: TLabel
              Left = 10
              Top = 27
              Width = 65
              Height = 17
              Caption = #51452#47928' '#44032#44201' :'
            end
            object Label4: TLabel
              Left = 211
              Top = 27
              Width = 65
              Height = 17
              Caption = #51452#47928' '#49688#47049' :'
            end
            object Label109: TLabel
              Left = 10
              Top = 60
              Width = 327
              Height = 17
              Caption = #51201#51221#44032#47484' '#49324#50857#54624' '#44221#50864',  '#47751' '#52488#46244#50640' '#51088#46041#51221#51221#51452#47928#48156#49373' '#46120'.'
            end
            object Label110: TLabel
              Left = 10
              Top = 81
              Width = 324
              Height = 17
              Caption = #47751#52488#47196' '#49444#51221#54624#44620#50836'?  (0'#51060#47732' '#49884#44036#50640' '#46384#47480' '#51088#46041#51221#51221#50630#51020')'
            end
            object Label112: TLabel
              Left = 66
              Top = 105
              Width = 13
              Height = 17
              Caption = #52488
            end
            object Label111: TLabel
              Left = 10
              Top = 127
              Width = 301
              Height = 17
              Caption = #46608#54620' '#44032#44201#48320#46041#51004#47196'  '#48520#47532#54616#44172' '#51652#54665#46104#47732' '#52628#44201#54633#45768#45796'.'
            end
            object ComboBoxORDER_TYPE: TComboBox
              Left = 79
              Top = 24
              Width = 120
              Height = 25
              Style = csDropDownList
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 0
              OnChange = OptionChange
              Items.Strings = (
                #51648#51221#44032' : '#51648#51221#44032
                #49884#51109#44032' : '#49884#51109#44032
                '1'#54840#44032' : 1'#54840#44032
                #51648#51221#44032' : 1'#54840#44032
                #51648#51221#44032' : '#49884#51109#44032
                #52572#51201#44032' : 1'#54840#44032
                #52572#51201#44032' : '#52572#51201#44032)
            end
            object EditORDER_COUNT: TEdit
              Left = 280
              Top = 24
              Width = 35
              Height = 25
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '1'
              OnChange = OptionChange
            end
            object UpDownORDER_COUNT: TUpDown
              Left = 315
              Top = 24
              Width = 15
              Height = 25
              Associate = EditORDER_COUNT
              Min = 1
              Max = 50
              Position = 1
              TabOrder = 2
              OnClick = UpDownClick
            end
            object EditSECOND_ORDER_DELAY_TIME: TEdit
              Left = 10
              Top = 101
              Width = 35
              Height = 25
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 3
              Text = '5'
              OnChange = OptionChange
            end
            object UpDownSECOND_ORDER_DELAY_TIME: TUpDown
              Left = 45
              Top = 101
              Width = 15
              Height = 25
              Associate = EditSECOND_ORDER_DELAY_TIME
              Max = 10
              Position = 5
              TabOrder = 4
              OnClick = UpDownClick
            end
          end
          object GroupBox15: TGroupBox
            Left = 714
            Top = 15
            Width = 345
            Height = 60
            Caption = #44592#51456' '#45216#51676'('#44284#44144' '#48177#53580#49828#54021#50857' - '#50689#50629#51068')'
            TabOrder = 7
            Visible = False
            object DateTimePickerSTAND_DATE: TDateTimePicker
              Left = 88
              Top = 25
              Width = 100
              Height = 25
              Date = 41114.430841481480000000
              Time = 41114.430841481480000000
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 0
              OnChange = OptionChange
            end
            object CheckBoxUSE_STAND_DATE: TCheckBox
              Left = 10
              Top = 26
              Width = 75
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 1
              OnClick = OptionChange
            end
          end
          object GroupBox14: TGroupBox
            Left = 714
            Top = 81
            Width = 345
            Height = 76
            Caption = #47588#47588#44508#52825
            TabOrder = 8
            Visible = False
            object CheckBoxACTION_ON_START: TCheckBox
              Left = 10
              Top = 25
              Width = 319
              Height = 17
              Caption = #49884#49828#53596' '#49884#51089#44284' '#46041#49884#50640' '#54788#51116' '#49888#54840' '#47588#47588#54616#44592
              TabOrder = 0
              OnClick = OptionChange
            end
            object CheckBoxNOTRADE_FIRST_SIGNAL: TCheckBox
              Left = 10
              Top = 49
              Width = 195
              Height = 17
              Caption = #45817#51068' '#52376#51020#49888#54840' '#47588#47588#54616#51648' '#50506#44592
              TabOrder = 1
              OnClick = OptionChange
            end
          end
          object GroupBox4: TGroupBox
            Left = 360
            Top = 78
            Width = 345
            Height = 126
            Caption = #51204#49328#51109
            TabOrder = 9
            object Label2: TLabel
              Left = 10
              Top = 24
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
            object Label10: TLabel
              Left = 10
              Top = 75
              Width = 34
              Height = 17
              Caption = #49884#51089' :'
            end
            object Label12: TLabel
              Left = 10
              Top = 100
              Width = 34
              Height = 17
              Caption = #47560#44048' :'
            end
            object Label7: TLabel
              Left = 118
              Top = 26
              Width = 137
              Height = 17
              Caption = #51109#49884#51089' '#54980'  X'#48516' '#44221#44284' '#54980
            end
            object Label8: TLabel
              Left = 118
              Top = 49
              Width = 118
              Height = 17
              Caption = #51109#47560#44048' '#51204'  Y'#48516' '#51060#51204
            end
            object DateTimePickerSTOP_TIME: TDateTimePicker
              Left = 57
              Top = 95
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
              Left = 57
              Top = 71
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
              Left = 57
              Top = 45
              Width = 40
              Height = 25
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 2
              Text = '2'
            end
            object UpDownSTOP_OFFSET: TUpDown
              Left = 97
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
              Left = 97
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
              Left = 57
              Top = 22
              Width = 40
              Height = 25
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 5
              Text = '3'
            end
          end
          object GroupBox7: TGroupBox
            Left = 360
            Top = 219
            Width = 345
            Height = 106
            Caption = #51221#44508#51109
            TabOrder = 10
            object Label15: TLabel
              Left = 10
              Top = 46
              Width = 34
              Height = 17
              Caption = #49884#51089' :'
            end
            object Label19: TLabel
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
          object GroupBox12: TGroupBox
            Left = 714
            Top = 230
            Width = 345
            Height = 80
            Caption = #44077#52376#47532
            TabOrder = 11
            Visible = False
            object Label13: TLabel
              Left = 10
              Top = 47
              Width = 104
              Height = 17
              Caption = #52628#44032#54624' '#49884#44036' ('#48516') :'
            end
            object EditGAB_INSERT_MIN: TEdit
              Left = 121
              Top = 43
              Width = 40
              Height = 25
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 0
              Text = '3'
            end
            object UpDownGAB_INSERT_MIN: TUpDown
              Left = 161
              Top = 43
              Width = 16
              Height = 25
              Associate = EditGAB_INSERT_MIN
              Min = 1
              Max = 14400
              Position = 3
              TabOrder = 1
            end
            object CheckBoxUSER_GAB_PROCESS: TCheckBox
              Left = 12
              Top = 24
              Width = 120
              Height = 17
              Caption = #49324#50857#50668#48512
              TabOrder = 2
            end
          end
          object GroupBox11: TGroupBox
            Left = 360
            Top = 346
            Width = 345
            Height = 130
            Caption = #51068#51473' '#49552#49892' '#48143' '#51060#51061#51060' '#49444#51221#52824#50640' '#46020#45804#49884' '#47588#47588#51221#51648
            TabOrder = 12
            object CheckBoxUSE_RISK_MAX_LOSS: TCheckBox
              Left = 10
              Top = 26
              Width = 103
              Height = 17
              Caption = #49552#51208#51221#51648'($) :'
              TabOrder = 0
              OnClick = OptionChange
            end
            object EditRISK_MAX_LOSS: TEdit
              Left = 111
              Top = 23
              Width = 60
              Height = 25
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 1
              Text = '-80'
              OnChange = OptionChange
            end
            object CheckBoxUSE_RISK_MAX_PROFIT: TCheckBox
              Left = 10
              Top = 58
              Width = 103
              Height = 17
              Caption = #49688#51061#51221#51648'($) :'
              TabOrder = 2
              OnClick = OptionChange
            end
            object EditRISK_MAX_PROFIT: TEdit
              Left = 111
              Top = 55
              Width = 60
              Height = 25
              Alignment = taRightJustify
              ImeName = 'Microsoft Office IME 2007'
              TabOrder = 3
              Text = '300'
              OnChange = OptionChange
            end
            object CheckBoxUSE_REALTIME_RISK_CHECK: TCheckBox
              Left = 10
              Top = 93
              Width = 323
              Height = 17
              Caption = #49892#49884#44036' '#44160#49324' ('#52404#53356' '#54616#51648' '#50506#51004#47732', '#44033' '#48148#47560#45796' '#44160#49324')'
              TabOrder = 4
              OnClick = OptionChange
            end
          end
        end
      end
    end
  end
  object PanelClear: TPanel
    Left = 889
    Top = 498
    Width = 185
    Height = 41
    BevelOuter = bvNone
    TabOrder = 1
  end
end
