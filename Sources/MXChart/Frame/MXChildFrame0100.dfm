inherited ChildFrame0100: TChildFrame0100
  Width = 1129
  Height = 694
  Font.Charset = ANSI_CHARSET
  Font.Height = -12
  Font.Name = #44404#47548
  ParentColor = False
  ParentCtl3D = False
  ParentFont = False
  ExplicitWidth = 1129
  ExplicitHeight = 694
  object PanelBody: TPanel
    Left = 0
    Top = 26
    Width = 1129
    Height = 668
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object PanelChartSpace: TPanel
      Left = 0
      Top = 0
      Width = 899
      Height = 668
      Align = alClient
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 0
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 899
        Height = 668
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Splitter_Report: TSplitter
          Left = 0
          Top = 517
          Width = 899
          Height = 3
          Cursor = crVSplit
          Align = alBottom
          ExplicitLeft = -8
          ExplicitTop = 363
          ExplicitWidth = 810
        end
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 899
          Height = 517
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object ColorPanel1: TColorPanel
            Left = 0
            Top = 0
            Width = 899
            Height = 498
            Align = alClient
            BevelOuter = bvNone
            Padding.Left = 1
            Padding.Right = 1
            Padding.Bottom = 1
            TabOrder = 0
            object ColorPanel2: TColorPanel
              Left = 1
              Top = 20
              Width = 897
              Height = 20
              Align = alTop
              BevelOuter = bvNone
              Padding.Top = 1
              TabOrder = 0
              object m_ChartTrace: TImgView32
                Left = 0
                Top = 1
                Width = 897
                Height = 19
                Align = alClient
                Bitmap.ResamplerClassName = 'TNearestResampler'
                BitmapAlign = baCustom
                Color = clWhite
                ParentColor = False
                RepaintMode = rmOptimizer
                Scale = 1.000000000000000000
                ScaleMode = smScale
                ScrollBars.ShowHandleGrip = True
                ScrollBars.Style = rbsDefault
                ScrollBars.Visibility = svHidden
                OverSize = 0
                TabOrder = 0
              end
            end
            object ColorPanel3: TColorPanel
              Left = 1
              Top = 0
              Width = 897
              Height = 20
              Align = alTop
              BevelOuter = bvNone
              Padding.Top = 1
              TabOrder = 1
              object m_ChartCaption: TImgView32
                Left = 0
                Top = 1
                Width = 897
                Height = 19
                Align = alClient
                Bitmap.ResamplerClassName = 'TNearestResampler'
                BitmapAlign = baCustom
                Color = clWhite
                ParentColor = False
                RepaintMode = rmOptimizer
                Scale = 1.000000000000000000
                ScaleMode = smScale
                ScrollBars.ShowHandleGrip = True
                ScrollBars.Style = rbsDefault
                ScrollBars.Visibility = svHidden
                OverSize = 0
                TabOrder = 0
              end
            end
            object ColorPanel4: TColorPanel
              Left = 1
              Top = 40
              Width = 897
              Height = 457
              Align = alClient
              BevelOuter = bvNone
              Padding.Top = 1
              TabOrder = 2
              object Panel1: TPanel
                Left = 0
                Top = 1
                Width = 897
                Height = 456
                Align = alClient
                BevelOuter = bvNone
                ParentBackground = False
                ParentColor = True
                TabOrder = 0
                object CMKAVChartControl1: CMKAVChartControl
                  Left = 0
                  Top = 0
                  Width = 897
                  Height = 456
                  Align = alClient
                  Bitmap.ResamplerClassName = 'TNearestResampler'
                  BitmapAlign = baCustom
                  Color = clWhite
                  ParentColor = False
                  Scale = 1.000000000000000000
                  ScaleMode = smScale
                  ScrollBars.ShowHandleGrip = True
                  ScrollBars.Style = rbsDefault
                  ScrollBars.Visibility = svHidden
                  OverSize = 0
                  TabOrder = 0
                  OnChange = CMKAVChartControl1Change
                end
              end
            end
          end
          object ColorPanel5: TColorPanel
            Left = 0
            Top = 498
            Width = 899
            Height = 19
            Align = alBottom
            BevelOuter = bvNone
            Padding.Left = 1
            Padding.Right = 1
            Padding.Bottom = 1
            TabOrder = 1
            object PanelScroll: TPanel
              Left = 1
              Top = 0
              Width = 897
              Height = 18
              Align = alClient
              BevelOuter = bvNone
              ParentBackground = False
              TabOrder = 0
              object m_btnZoomActual: TSpeedButton
                Left = 874
                Top = 0
                Width = 23
                Height = 18
                Action = ZoomActual
                Align = alRight
                ExplicitLeft = 261
                ExplicitTop = 273
                ExplicitHeight = 22
              end
              object m_btnZoomIn: TSpeedButton
                Left = 828
                Top = 0
                Width = 23
                Height = 18
                Action = ZoomIN
                Align = alRight
                ExplicitLeft = 209
                ExplicitTop = 273
                ExplicitHeight = 22
              end
              object m_btnZoomOut: TSpeedButton
                Left = 851
                Top = 0
                Width = 23
                Height = 18
                Action = ZoomOut
                Align = alRight
                ExplicitLeft = 621
                ExplicitTop = 4
              end
              object m_ScrollBar: TScrollBar
                Left = 0
                Top = 0
                Width = 828
                Height = 18
                Align = alClient
                PageSize = 0
                TabOrder = 0
                TabStop = False
              end
            end
          end
        end
        object Panel_Report: TColorPanel
          Left = 0
          Top = 520
          Width = 899
          Height = 148
          Align = alBottom
          BevelOuter = bvNone
          Padding.Top = 1
          Padding.Right = 1
          TabOrder = 1
          OnResize = Panel_ReportResize
          object Panel_ReportSub: TPanel
            Left = 0
            Top = 1
            Width = 898
            Height = 147
            Align = alClient
            BevelOuter = bvNone
            Color = 14473424
            Padding.Top = 2
            Padding.Right = 1
            ParentBackground = False
            TabOrder = 0
            DesignSize = (
              898
              147)
            object PageControl_TradeReport: TPageControl
              Left = 0
              Top = 2
              Width = 897
              Height = 145
              ActivePage = TabSheet1
              Align = alClient
              MultiLine = True
              TabHeight = 22
              TabOrder = 0
              TabWidth = 100
              object TabSheet1: TTabSheet
                Caption = #47588#47588#45236#50669
                object Panel5: TPanel
                  Left = 0
                  Top = 0
                  Width = 889
                  Height = 113
                  Align = alClient
                  BevelOuter = bvNone
                  ParentColor = True
                  TabOrder = 0
                  object ListView_TradeList: TListView
                    Left = 0
                    Top = 0
                    Width = 889
                    Height = 113
                    Align = alClient
                    BorderStyle = bsNone
                    Columns = <
                      item
                        Caption = #54943#49688
                        Width = 36
                      end
                      item
                        Caption = #50976#54805
                        Width = 40
                      end
                      item
                        Caption = #51652#51077#51068#51088
                        Width = 120
                      end
                      item
                        Caption = #52397#49328#51068#51088
                        Tag = 1
                        Width = 120
                      end
                      item
                        Alignment = taRightJustify
                        Caption = #49688#51061
                        Tag = 4
                        Width = 65
                      end
                      item
                        Alignment = taRightJustify
                        Caption = #49688#51061#50984
                        Width = 65
                      end
                      item
                        Alignment = taRightJustify
                        Caption = #45572#51201#49688#51061
                        Width = 70
                      end
                      item
                        Alignment = taRightJustify
                        Caption = #54217#44512#49688#51061#50984
                        Width = 75
                      end
                      item
                        Alignment = taRightJustify
                        Caption = #51652#51077#44032#44201
                        Tag = 2
                        Width = 70
                      end
                      item
                        Alignment = taRightJustify
                        Caption = #52397#49328#44032#44201
                        Tag = 3
                        Width = 70
                      end>
                    Ctl3D = False
                    Font.Charset = HANGEUL_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -11
                    Font.Name = 'Gulim'
                    Font.Style = []
                    FlatScrollBars = True
                    GridLines = True
                    OwnerData = True
                    ReadOnly = True
                    RowSelect = True
                    ParentFont = False
                    PopupMenu = PopupMenuReport
                    TabOrder = 0
                    ViewStyle = vsReport
                    OnCustomDrawItem = ListView_TradeListCustomDrawItem
                    OnCustomDrawSubItem = ListView_TradeListCustomDrawSubItem
                    OnData = ListView_TradeListData
                    OnSelectItem = ListView_TradeListSelectItem
                  end
                end
                object ColorPanel7: TColorPanel
                  Left = 416
                  Top = -240
                  Width = 185
                  Height = 41
                  BevelOuter = bvNone
                  TabOrder = 1
                end
              end
              object TabSheet2: TTabSheet
                Caption = #47588#47588#48516#49437
                ImageIndex = 1
                object Memo_TradeReport: TMemo
                  Left = 344
                  Top = 16
                  Width = 384
                  Height = 166
                  BorderStyle = bsNone
                  Font.Charset = HANGEUL_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = #44404#47548#52404
                  Font.Style = []
                  ImeName = 'Microsoft Office IME 2007'
                  ParentFont = False
                  TabOrder = 0
                  WordWrap = False
                end
                object ListView_Performance: TListView
                  Left = 0
                  Top = 0
                  Width = 889
                  Height = 113
                  Align = alClient
                  BorderStyle = bsNone
                  Columns = <
                    item
                      Caption = #49457#45733#48516#49437#51060#47492
                      Width = 200
                    end
                    item
                      Alignment = taRightJustify
                      Caption = #44050
                      Width = 120
                    end>
                  Ctl3D = False
                  Font.Charset = HANGEUL_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'Gulim'
                  Font.Style = []
                  FlatScrollBars = True
                  GridLines = True
                  OwnerData = True
                  ReadOnly = True
                  RowSelect = True
                  ParentFont = False
                  PopupMenu = PopupMenuReport
                  TabOrder = 1
                  ViewStyle = vsReport
                  OnCustomDrawSubItem = ListView_PerformanceCustomDrawSubItem
                  OnData = ListView_PerformanceData
                end
              end
            end
            object ComboBox_SelectedSignal2: TComboBox
              Left = 425
              Top = 2
              Width = 194
              Height = 20
              Style = csDropDownList
              Anchors = [akTop, akRight]
              ImeName = 'Microsoft Office IME 2007'
              ItemHeight = 12
              TabOrder = 1
              OnChange = ComboBox_SelectedSignalChange
            end
            object Panel3: TPanel
              Left = 627
              Top = 1
              Width = 270
              Height = 24
              Anchors = [akTop, akRight]
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 2
              object SpeedButton_HideReport: TSpeedButton
                Left = 248
                Top = 2
                Width = 18
                Height = 18
                Glyph.Data = {
                  AE000000424DAE00000000000000360000002800000007000000050000000100
                  18000000000078000000120B0000120B00000000000000000000F0F0F0F0F0F0
                  E1E1E15B5B5BDCDCDCF0F0F0F0F0F0000000F0F0F0E3E3E36262626363635858
                  58DDDDDDF0F0F0000000E4E4E47171716E6E6E7575756565655A5A5ADBDBDB00
                  00007E7E7E7C7C7C7E7E7E7B7B7B7676766767677474740000007F7F7F7B7B7B
                  7676767070706B6B6B656565646464000000}
                OnClick = SpeedButton_HideReportClick
              end
              object Panel7: TPanel
                Left = 0
                Top = 0
                Width = 240
                Height = 24
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 0
                DesignSize = (
                  240
                  24)
                object RadioGroup_TradeType: TRadioGroup
                  Tag = -1
                  Left = -2
                  Top = -13
                  Width = 244
                  Height = 40
                  Anchors = [akLeft, akTop, akRight, akBottom]
                  Columns = 3
                  ItemIndex = 2
                  Items.Strings = (
                    #47588#49688#44144#47000
                    #47588#46020#44144#47000
                    #51204#52404#44144#47000)
                  TabOrder = 0
                  OnClick = RadioGroup_TradeTypeClick
                end
              end
            end
          end
          object Panel_ReportSmallView: TPanel
            Left = 381
            Top = 72
            Width = 185
            Height = 41
            BevelOuter = bvNone
            Color = 14473424
            ParentBackground = False
            TabOrder = 1
            Visible = False
            OnClick = SpeedButton_ShowReportClick
            DesignSize = (
              185
              41)
            object SpeedButton_ShowReport: TSpeedButton
              Left = 142
              Top = 0
              Width = 32
              Height = 11
              Anchors = [akTop, akRight]
              Glyph.Data = {
                AE000000424DAE00000000000000360000002800000007000000050000000100
                18000000000078000000120B0000120B00000000000000000000646464656565
                6B6B6B7070707676767B7B7B7F7F7F0000007474746767677676767B7B7B7E7E
                7E7C7C7C7E7E7E000000DBDBDB5A5A5A6565657575756E6E6E717171E4E4E400
                0000F0F0F0DDDDDD585858636363626262E3E3E3F0F0F0000000F0F0F0F0F0F0
                DCDCDC5B5B5BE1E1E1F0F0F0F0F0F0000000}
              OnClick = SpeedButton_ShowReportClick
            end
          end
        end
      end
    end
    object PanelChartOption: TPanel
      Left = 899
      Top = 0
      Width = 230
      Height = 668
      Align = alRight
      BevelOuter = bvNone
      Ctl3D = True
      Padding.Left = 2
      Padding.Right = 2
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 1
      OnResize = PanelChartOptionResize
      DesignSize = (
        230
        668)
      object PageControl2: TPageControl
        Left = 2
        Top = 0
        Width = 226
        Height = 668
        ActivePage = TabSheet11
        Align = alClient
        TabHeight = 24
        TabOrder = 0
        object TabSheet11: TTabSheet
          Caption = #47588#47588#51204#47029
          ImageIndex = 1
          object Panel88: TPanel
            Left = 0
            Top = 0
            Width = 218
            Height = 634
            Align = alClient
            BevelOuter = bvNone
            Ctl3D = True
            ParentBackground = False
            ParentCtl3D = False
            TabOrder = 0
            DesignSize = (
              218
              634)
            object Panel9: TPanel
              Left = 0
              Top = 0
              Width = 218
              Height = 43
              Align = alTop
              BevelOuter = bvNone
              Padding.Left = 5
              Padding.Top = 5
              Padding.Right = 5
              Padding.Bottom = 5
              ParentBackground = False
              TabOrder = 0
              object CheckBoxUseTradeStrategy: TCheckBox
                Left = 11
                Top = 2
                Width = 120
                Height = 17
                Caption = #49324#50857#50668#48512
                TabOrder = 0
                OnClick = CheckBoxUseStrategyClick
              end
              object ComboBoxTradeStrategy: TComboBox
                Left = 11
                Top = 17
                Width = 190
                Height = 20
                Style = csDropDownList
                DropDownCount = 32
                Enabled = False
                ImeName = 'Microsoft Office IME 2007'
                ItemHeight = 12
                TabOrder = 1
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
              Top = 43
              Width = 218
              Height = 591
              Align = alClient
              BevelOuter = bvNone
              ParentBackground = False
              TabOrder = 1
              object PageControlStrategyConfig: TPageControl
                Left = 0
                Top = 0
                Width = 218
                Height = 591
                ActivePage = TabSheetConfig
                Align = alClient
                TabOrder = 0
                object TabSheetConfig: TTabSheet
                  Caption = #49444#51221
                  object PageControl3: TPageControl
                    Left = 0
                    Top = 0
                    Width = 210
                    Height = 564
                    ActivePage = TabSheet13
                    Align = alClient
                    TabOrder = 0
                    object TabSheet13: TTabSheet
                      Caption = #44592#48376
                      object PageControlStrategy: TPageControl
                        Left = 0
                        Top = 0
                        Width = 202
                        Height = 537
                        ActivePage = TabSheet4
                        Align = alClient
                        TabOrder = 0
                        TabPosition = tpBottom
                        TabWidth = 10
                        object TabSheetX000: TTabSheet
                          inline STC_T1_Frame1: TSTC_T1_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label3: TLabel
                                  Width = 95
                                  Height = 12
                                  ExplicitWidth = 95
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH3: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH3: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label4: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheetX010: TTabSheet
                          ImageIndex = 2
                          inline STC_T2_Frame1: TSTC_T2_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label3: TLabel
                                  Width = 95
                                  Height = 12
                                  ExplicitWidth = 95
                                  ExplicitHeight = 12
                                end
                                inherited Label1: TLabel
                                  Width = 72
                                  Height = 12
                                  ExplicitWidth = 72
                                  ExplicitHeight = 12
                                end
                                inherited Label5: TLabel
                                  Width = 72
                                  Height = 12
                                  ExplicitWidth = 72
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH3: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH3: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditDN: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditUP: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownUP: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownDN: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label4: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                            end
                          end
                        end
                        object TabSheetX020: TTabSheet
                          ImageIndex = 4
                          inline STC_T3_Frame1: TSTC_T3_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label3: TLabel
                                  Width = 105
                                  Height = 12
                                  ExplicitWidth = 105
                                  ExplicitHeight = 12
                                end
                                inherited Label1: TLabel
                                  Width = 105
                                  Height = 12
                                  ExplicitWidth = 105
                                  ExplicitHeight = 12
                                end
                                inherited Label2: TLabel
                                  Width = 72
                                  Height = 12
                                  ExplicitWidth = 72
                                  ExplicitHeight = 12
                                end
                                inherited Label5: TLabel
                                  Width = 72
                                  Height = 12
                                  ExplicitWidth = 72
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH3: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH3: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH4: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH4: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH5: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH5: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH6: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH6: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditDN: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditUP: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownUP: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownDN: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label4: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheetX030: TTabSheet
                          ImageIndex = 3
                          inline STC_N1_Frame1: TSTC_N1_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label3: TLabel
                                  Width = 95
                                  Height = 12
                                  ExplicitWidth = 95
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH3: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH3: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label4: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheetX040: TTabSheet
                          ImageIndex = 9
                          inline STC_N2_Frame1: TSTC_N2_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label3: TLabel
                                  Width = 95
                                  Height = 12
                                  ExplicitWidth = 95
                                  ExplicitHeight = 12
                                end
                                inherited Label1: TLabel
                                  Width = 72
                                  Height = 12
                                  ExplicitWidth = 72
                                  ExplicitHeight = 12
                                end
                                inherited Label5: TLabel
                                  Width = 72
                                  Height = 12
                                  ExplicitWidth = 72
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH3: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH3: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditDN: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditUP: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownUP: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownDN: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label4: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheetX050: TTabSheet
                          ImageIndex = 4
                          inline RSI_T1_Frame1: TRSI_T1_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label3: TLabel
                                  Width = 79
                                  Height = 12
                                  ExplicitWidth = 79
                                  ExplicitHeight = 12
                                end
                                inherited Label4: TLabel
                                  Width = 72
                                  Height = 12
                                  ExplicitWidth = 72
                                  ExplicitHeight = 12
                                end
                                inherited Label5: TLabel
                                  Width = 72
                                  Height = 12
                                  ExplicitWidth = 72
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditUP: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditDN: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownUP: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownDN: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label1: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                            end
                          end
                        end
                        object TabSheetX060: TTabSheet
                          ImageIndex = 5
                          inline RSI_N1_Frame1: TRSI_N1_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label3: TLabel
                                  Width = 79
                                  Height = 12
                                  ExplicitWidth = 79
                                  ExplicitHeight = 12
                                end
                                inherited Label4: TLabel
                                  Width = 72
                                  Height = 12
                                  ExplicitWidth = 72
                                  ExplicitHeight = 12
                                end
                                inherited Label5: TLabel
                                  Width = 72
                                  Height = 12
                                  ExplicitWidth = 72
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditUP: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditDN: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownUP: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownDN: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox3: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label7: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheetX070: TTabSheet
                          ImageIndex = 6
                          inline BB_T1_Frame1: TBB_T1_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label3: TLabel
                                  Width = 136
                                  Height = 12
                                  ExplicitWidth = 136
                                  ExplicitHeight = 12
                                end
                                inherited Label1: TLabel
                                  Width = 178
                                  Height = 12
                                  ExplicitWidth = 178
                                  ExplicitHeight = 12
                                end
                                inherited Label5: TLabel
                                  Width = 178
                                  Height = 12
                                  ExplicitWidth = 178
                                  ExplicitHeight = 12
                                end
                                inherited Label4: TLabel
                                  Width = 164
                                  Height = 12
                                  ExplicitWidth = 164
                                  ExplicitHeight = 12
                                end
                                inherited Label2: TLabel
                                  Width = 152
                                  Height = 12
                                  ExplicitWidth = 152
                                  ExplicitHeight = 12
                                end
                                inherited Label6: TLabel
                                  Width = 120
                                  Height = 12
                                  ExplicitWidth = 120
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH0: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH0: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditSIGMA0: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownSIGMA0: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditSIGMA1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownSIGMA1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditSIGMA2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownSIGMA2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxPRICEMETHOD: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                                inherited EditTHRESHOLD: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownTHRESHOLD: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label7: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                            end
                          end
                        end
                        object TabSheetX080: TTabSheet
                          ImageIndex = 7
                          inline DISPARITY_T1_Frame1: TDISPARITY_T1_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                Height = 373
                                ExplicitWidth = 190
                                ExplicitHeight = 373
                                inherited Label3: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited Label4: TLabel
                                  Width = 138
                                  Height = 12
                                  ExplicitWidth = 138
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheetX090: TTabSheet
                          ImageIndex = 8
                          inline DISPARITY_N1_Frame1: TDISPARITY_N1_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label3: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited Label1: TLabel
                                  Width = 48
                                  Height = 12
                                  ExplicitWidth = 48
                                  ExplicitHeight = 12
                                end
                                inherited Label2: TLabel
                                  Width = 48
                                  Height = 12
                                  ExplicitWidth = 48
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditUP1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditDN1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                Height = 264
                                ExplicitWidth = 190
                                ExplicitHeight = 264
                                inherited Label4: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited Label5: TLabel
                                  Width = 48
                                  Height = 12
                                  ExplicitWidth = 48
                                  ExplicitHeight = 12
                                end
                                inherited Label6: TLabel
                                  Width = 48
                                  Height = 12
                                  ExplicitWidth = 48
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditUP2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditDN2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheetX100: TTabSheet
                          ImageIndex = 10
                          inline BASELINE_T1_Frame1: TBASELINE_T1_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label4: TLabel
                                  Width = 140
                                  Height = 12
                                  ExplicitWidth = 140
                                  ExplicitHeight = 12
                                end
                                inherited ComboBoxPRICEMETHOD: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox3: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label7: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                Height = 201
                                ExplicitWidth = 190
                                ExplicitHeight = 201
                              end
                            end
                          end
                        end
                        object TabSheetX110: TTabSheet
                          ImageIndex = 11
                          inline BASELINE_T2_Frame1: TBASELINE_T2_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label4: TLabel
                                  Width = 140
                                  Height = 12
                                  ExplicitWidth = 140
                                  ExplicitHeight = 12
                                end
                                inherited ComboBoxPRICEMETHOD: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox3: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label7: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheetX120: TTabSheet
                          ImageIndex = 12
                          inline BASELINE_N1_Frame1: TBASELINE_N1_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label1: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited Label2: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited Label3: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited EditM1V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditM2V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditM3V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label4: TLabel
                                  Width = 140
                                  Height = 12
                                  ExplicitWidth = 140
                                  ExplicitHeight = 12
                                end
                                inherited ComboBoxPRICEMETHOD: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox3: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label7: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheetX130: TTabSheet
                          ImageIndex = 13
                          inline IM_T1_Frame1: TIM_T1_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label4: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH3: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH3: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label1: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited Label2: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited Label3: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited Label5: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited Label6: TLabel
                                  Width = 100
                                  Height = 12
                                  ExplicitWidth = 100
                                  ExplicitHeight = 12
                                end
                                inherited EditM1V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditM2V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditM4V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditM3V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxVALUE_TYPE: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox3: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label7: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheetX140: TTabSheet
                          ImageIndex = 14
                          inline IM_T2_Frame1: TIM_T2_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label4: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH3: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH3: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label6: TLabel
                                  Width = 100
                                  Height = 12
                                  ExplicitWidth = 100
                                  ExplicitHeight = 12
                                end
                                inherited Label1: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited Label2: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited Label3: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited Label5: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited ComboBoxVALUE_TYPE: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                                inherited EditM1V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditM2V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditM4V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditM3V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox3: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label7: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheetX150: TTabSheet
                          ImageIndex = 15
                          inline IM_T3_Frame1: TIM_T3_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label4: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH3: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH3: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label6: TLabel
                                  Width = 100
                                  Height = 12
                                  ExplicitWidth = 100
                                  ExplicitHeight = 12
                                end
                                inherited Label1: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited Label2: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited Label3: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited Label5: TLabel
                                  Width = 22
                                  Height = 12
                                  ExplicitWidth = 22
                                  ExplicitHeight = 12
                                end
                                inherited ComboBoxVALUE_TYPE: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                                inherited EditM1V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditM2V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditM4V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditM3V1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox3: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label7: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheet4: TTabSheet
                          ImageIndex = 16
                          inline MOV_T1_Frame1: TMOV_T1_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label1: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited Label9: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxAVERAGE_TYPE: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox3: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label7: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheet5: TTabSheet
                          ImageIndex = 17
                          inline MOV_T2_Frame1: TMOV_T2_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label4: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited Label9: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH3: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH3: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxAVERAGE_TYPE: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox3: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label7: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheet6: TTabSheet
                          ImageIndex = 18
                          inline MOV_T3_Frame1: TMOV_T3_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitTop = 274
                                ExplicitWidth = 190
                              end
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label1: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited Label9: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited Label8: TLabel
                                  Width = 80
                                  Height = 12
                                  ExplicitWidth = 80
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxAVERAGE_TYPE: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitTop = 267
                                ExplicitWidth = 190
                              end
                            end
                          end
                        end
                        object TabSheet7: TTabSheet
                          ImageIndex = 19
                          inline MOV_N1_Frame1: TMOV_N1_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label4: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited Label9: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH3: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH3: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxAVERAGE_TYPE: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox3: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label7: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheet8: TTabSheet
                          ImageIndex = 20
                          inline MOV_N2_Frame1: TMOV_N2_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox1: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label4: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited Label9: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH2: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH2: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditLENGTH3: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH3: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxAVERAGE_TYPE: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel6: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel7: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBox3: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited Label7: TLabel
                                  Height = 12
                                  ExplicitHeight = 12
                                end
                                inherited EditTOLERANCE: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                            end
                          end
                        end
                        object TabSheetX160: TTabSheet
                          ImageIndex = 21
                          inline REL_T1_Frame1: TREL_T1_Frame
                            Left = 0
                            Top = 0
                            Width = 194
                            Height = 512
                            Align = alClient
                            TabOrder = 0
                            ExplicitWidth = 194
                            ExplicitHeight = 512
                            inherited Panel1: TPanel
                              Width = 194
                              Height = 512
                              ExplicitWidth = 194
                              ExplicitHeight = 512
                              inherited GroupBox2: TGroupBox
                                Width = 190
                                Height = 373
                                ExplicitWidth = 190
                                ExplicitHeight = 373
                                inherited Label3: TLabel
                                  Width = 96
                                  Height = 12
                                  ExplicitWidth = 96
                                  ExplicitHeight = 12
                                end
                                inherited Label1: TLabel
                                  Width = 48
                                  Height = 12
                                  ExplicitWidth = 48
                                  ExplicitHeight = 12
                                end
                                inherited Label2: TLabel
                                  Width = 48
                                  Height = 12
                                  ExplicitWidth = 48
                                  ExplicitHeight = 12
                                end
                                inherited Label4: TLabel
                                  Width = 56
                                  Height = 12
                                  ExplicitWidth = 56
                                  ExplicitHeight = 12
                                end
                                inherited EditLENGTH1: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited UpDownLENGTH1: TUpDown
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditUP: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited EditDN: TEdit
                                  Height = 20
                                  ExplicitHeight = 20
                                end
                                inherited ComboBoxMETHOD: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel2: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel3: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxMajorType: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxMajorType: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
                              end
                              inherited Panel4: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited Panel5: TPanel
                                Width = 190
                                ExplicitWidth = 190
                              end
                              inherited GroupBoxOptionManagement: TGroupBox
                                Width = 190
                                ExplicitWidth = 190
                                inherited ComboBoxOptionCollection: TComboBox
                                  Height = 20
                                  ItemHeight = 12
                                  ExplicitHeight = 20
                                end
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
                        Width = 202
                        Height = 537
                        Align = alClient
                        TabOrder = 0
                        ExplicitWidth = 202
                        ExplicitHeight = 537
                        inherited Panel9: TPanel
                          Width = 202
                          Height = 537
                          ExplicitWidth = 202
                          ExplicitHeight = 537
                          inherited Panel2: TPanel
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited Panel3: TPanel
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited Panel1: TPanel
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited GroupBox1: TGroupBox
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited GroupBox2: TGroupBox
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited GroupBox3: TGroupBox
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited Panel4: TPanel
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited Panel5: TPanel
                            Width = 198
                            ExplicitWidth = 198
                          end
                        end
                      end
                    end
                  end
                end
                object TabSheetCFG02: TTabSheet
                  Caption = #54596#53552
                  ImageIndex = 1
                  object PageControl1: TPageControl
                    Left = 0
                    Top = 0
                    Width = 210
                    Height = 564
                    ActivePage = TabSheet3
                    Align = alClient
                    TabHeight = 24
                    TabOrder = 0
                    TabPosition = tpBottom
                    object TabSheet3: TTabSheet
                      Caption = #49884#44036
                      inline m_TradingHour_Frame: TTradingHour_Frame
                        Left = 0
                        Top = 0
                        Width = 202
                        Height = 532
                        Align = alClient
                        TabOrder = 0
                        ExplicitWidth = 202
                        ExplicitHeight = 532
                        inherited Panel9: TPanel
                          Width = 202
                          Height = 532
                          ExplicitWidth = 202
                          ExplicitHeight = 532
                          inherited GroupBox5: TGroupBox
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited GroupBox1: TGroupBox
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited Panel1: TPanel
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited GroupBoxOptionManagement: TGroupBox
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited Panel2: TPanel
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited Panel3: TPanel
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited Panel4: TPanel
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited Panel5: TPanel
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited GroupBox2: TGroupBox
                            Width = 198
                            ExplicitWidth = 198
                          end
                        end
                      end
                    end
                    object TabSheet9: TTabSheet
                      Caption = #47004#45924
                      ImageIndex = 1
                      inline m_Random_Frame: TRandom_Frame
                        Left = 0
                        Top = 0
                        Width = 202
                        Height = 532
                        Align = alClient
                        TabOrder = 0
                        ExplicitWidth = 202
                        ExplicitHeight = 532
                        inherited Panel9: TPanel
                          Width = 202
                          Height = 532
                          ExplicitWidth = 202
                          ExplicitHeight = 532
                          inherited GroupBox1: TGroupBox
                            Width = 198
                            Height = 446
                            ExplicitWidth = 198
                            ExplicitHeight = 446
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
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited Panel2: TPanel
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited Panel3: TPanel
                            Width = 198
                            ExplicitWidth = 198
                          end
                          inherited Panel4: TPanel
                            Width = 198
                            ExplicitWidth = 198
                          end
                        end
                      end
                    end
                  end
                end
                object TabSheetCFG03: TTabSheet
                  Caption = #52397#49328
                  ImageIndex = 3
                  object Panel13: TPanel
                    Left = 0
                    Top = 0
                    Width = 210
                    Height = 564
                    Align = alClient
                    Padding.Left = 3
                    Padding.Right = 3
                    Padding.Bottom = 2
                    TabOrder = 0
                    inline m_EXIT_Frame: TExit_Frame
                      Left = 4
                      Top = 1
                      Width = 202
                      Height = 560
                      Align = alClient
                      TabOrder = 0
                      ExplicitLeft = 4
                      ExplicitTop = 1
                      ExplicitWidth = 202
                      ExplicitHeight = 560
                      inherited Panel9: TPanel
                        Width = 202
                        Height = 560
                        ExplicitWidth = 202
                        ExplicitHeight = 560
                        inherited GroupBox1: TGroupBox
                          Width = 198
                          ExplicitWidth = 198
                        end
                        inherited GroupBoxOptionManagement: TGroupBox
                          Width = 198
                          ExplicitWidth = 198
                        end
                        inherited Panel2: TPanel
                          Width = 198
                          ExplicitWidth = 198
                        end
                        inherited Panel3: TPanel
                          Width = 198
                          ExplicitWidth = 198
                        end
                        inherited GroupBox2: TGroupBox
                          Width = 198
                          ExplicitWidth = 198
                        end
                        inherited GroupBox3: TGroupBox
                          Width = 198
                          ExplicitWidth = 198
                        end
                        inherited Panel1: TPanel
                          Width = 198
                          ExplicitWidth = 198
                        end
                        inherited Panel4: TPanel
                          Width = 198
                          ExplicitWidth = 198
                        end
                        inherited Panel5: TPanel
                          Width = 198
                          ExplicitWidth = 198
                        end
                      end
                    end
                  end
                end
                object TabSheetCFG04: TTabSheet
                  Caption = #51116#51652#51077
                  ImageIndex = 3
                  object Panel14: TPanel
                    Left = 0
                    Top = 0
                    Width = 210
                    Height = 564
                    Align = alClient
                    Padding.Left = 3
                    Padding.Right = 3
                    Padding.Bottom = 2
                    TabOrder = 0
                    inline m_ENTER_Frame: TENTER_Frame
                      Left = 4
                      Top = 1
                      Width = 202
                      Height = 560
                      Align = alClient
                      TabOrder = 0
                      ExplicitLeft = 4
                      ExplicitTop = 1
                      ExplicitWidth = 202
                      ExplicitHeight = 560
                      inherited Panel9: TPanel
                        Width = 202
                        Height = 560
                        ExplicitWidth = 202
                        ExplicitHeight = 560
                        inherited GroupBox1: TGroupBox
                          Width = 198
                          Height = 352
                          Align = alClient
                          ExplicitWidth = 198
                          ExplicitHeight = 352
                        end
                        inherited GroupBoxOptionManagement: TGroupBox
                          Width = 198
                          ExplicitWidth = 198
                        end
                        inherited Panel2: TPanel
                          Width = 198
                          ExplicitWidth = 198
                        end
                        inherited Panel3: TPanel
                          Width = 198
                          ExplicitWidth = 198
                        end
                        inherited Panel1: TPanel
                          Width = 198
                          ExplicitWidth = 198
                        end
                        inherited GroupBox2: TGroupBox
                          Width = 198
                          ExplicitWidth = 198
                        end
                        inherited Panel4: TPanel
                          Width = 198
                          ExplicitWidth = 198
                        end
                      end
                    end
                  end
                end
              end
            end
            object PanelScreenLock: TPanel
              Left = 178
              Top = 410
              Width = 35
              Height = 243
              Anchors = [akLeft, akTop, akRight, akBottom]
              BevelOuter = bvNone
              Color = clGray
              ParentBackground = False
              TabOrder = 2
              Visible = False
            end
          end
        end
        object TabSheet12: TTabSheet
          Caption = #52264#53944#49444#51221
          ImageIndex = 2
          object Panel6: TPanel
            Left = 0
            Top = 0
            Width = 218
            Height = 634
            Align = alClient
            BevelOuter = bvNone
            Padding.Top = 5
            ParentBackground = False
            TabOrder = 0
            object CategoryPanelGroup1: TCategoryPanelGroup
              Left = 0
              Top = 5
              Width = 218
              Height = 629
              VertScrollBar.Tracking = True
              VertScrollBar.Visible = False
              Align = alClient
              Color = clBtnFace
              Ctl3D = True
              HeaderFont.Charset = DEFAULT_CHARSET
              HeaderFont.Color = clWindowText
              HeaderFont.Height = -12
              HeaderFont.Name = 'Default'
              HeaderFont.Style = []
              HeaderHeight = 20
              ParentCtl3D = False
              TabOrder = 0
              OnResize = CategoryPanelGroup1Resize
              object CategoryPanel1: TCategoryPanel
                Top = 0
                Height = 500
                Caption = #51068#48152#49444#51221
                TabOrder = 0
                OnExpand = CategoryPanel1Expand
                object RadioGroupChartType: TRadioGroup
                  Left = 8
                  Top = 12
                  Width = 165
                  Height = 85
                  Caption = #51452#44032' '#52264#53944#51032' '#51333#47448
                  ItemIndex = 0
                  Items.Strings = (
                    #52884#46308' '#52264#53944
                    #46972#51064' '#52264#53944
                    #48148' '#52264#53944)
                  TabOrder = 0
                  OnClick = RadioGroupChartTypeClick
                end
                object RadioGroup_Trace: TRadioGroup
                  Left = 8
                  Top = 108
                  Width = 165
                  Height = 61
                  Caption = #51340#54364#51221#48372
                  ItemIndex = 0
                  Items.Strings = (
                    #48372#44592
                    #49704#44592#44592)
                  TabOrder = 1
                  OnClick = RadioGroup_TraceClick
                end
                object RadioGroup_OPSPrice: TRadioGroup
                  Left = 8
                  Top = 180
                  Width = 165
                  Height = 61
                  Caption = #50724#47700#44032' '#51201#50857
                  ItemIndex = 0
                  Items.Strings = (
                    #51452#44032#47196' '#48372#44592
                    #51452#44032' '#45824#49888' '#50724#47700#44032#47196' '#48372#44592)
                  TabOrder = 2
                  OnClick = RadioGroup_OPSPriceClick
                end
              end
              object CategoryPanel2: TCategoryPanel
                Tag = 1
                Top = 500
                Height = 26
                Caption = #50724#48260#47112#51060
                Collapsed = True
                TabOrder = 1
                OnExpand = CategoryPanel1Expand
                ExpandedHeight = 500
                object Label_OverlayOption1: TLabel
                  Left = 10
                  Top = 328
                  Width = 30
                  Height = 12
                  Caption = #50741#49496'1'
                end
                object Label_OverlayOption2: TLabel
                  Left = 10
                  Top = 354
                  Width = 30
                  Height = 12
                  Caption = #50741#49496'2'
                end
                object Label_OverlayOption3: TLabel
                  Left = 10
                  Top = 381
                  Width = 30
                  Height = 12
                  Caption = #50741#49496'3'
                end
                object Label_OverlayOption4: TLabel
                  Left = 10
                  Top = 408
                  Width = 30
                  Height = 12
                  Caption = #50741#49496'4'
                end
                object Button_OverlayDefault: TButton
                  Left = 10
                  Top = 292
                  Width = 65
                  Height = 25
                  Caption = #44592#48376#44050
                  TabOrder = 0
                  OnClick = OnClickOverlayOptionDefault
                end
                object CombolBox_SelectedOverlay: TComboBox
                  Left = 10
                  Top = 265
                  Width = 165
                  Height = 20
                  Style = csDropDownList
                  ImeName = 'Microsoft Office IME 2007'
                  ItemHeight = 12
                  TabOrder = 1
                  OnChange = OnChangeOverlayOption
                end
                object CheckBox_IM: TCheckBox
                  Left = 10
                  Top = 30
                  Width = 171
                  Height = 17
                  Caption = #51068#47785#44512#54805#54364
                  TabOrder = 2
                  OnClick = OnChangeOverlay
                end
                object CheckBox_NET: TCheckBox
                  Left = 10
                  Top = 110
                  Width = 171
                  Height = 17
                  Caption = #44536#47932#52264#53944
                  TabOrder = 3
                  OnClick = OnChangeOverlay
                end
                object CheckBox_ENVELOP: TCheckBox
                  Left = 10
                  Top = 90
                  Width = 171
                  Height = 17
                  Caption = 'Envelop'
                  TabOrder = 4
                  OnClick = OnChangeOverlay
                end
                object CheckBox_SAR: TCheckBox
                  Left = 10
                  Top = 70
                  Width = 171
                  Height = 17
                  Caption = 'Parabolic SAR'
                  TabOrder = 5
                  OnClick = OnChangeOverlay
                end
                object CheckBox_BB: TCheckBox
                  Left = 10
                  Top = 50
                  Width = 171
                  Height = 17
                  Caption = #48380#47536#51200#48180#46300
                  TabOrder = 6
                  OnClick = OnChangeOverlay
                end
                object CheckBox_MA: TCheckBox
                  Left = 10
                  Top = 10
                  Width = 171
                  Height = 17
                  Caption = #51060#46041#54217#44512#49440
                  TabOrder = 7
                  OnClick = OnChangeOverlay
                end
                object CheckBox_MAMUL: TCheckBox
                  Left = 10
                  Top = 130
                  Width = 171
                  Height = 17
                  Caption = #47588#47932#45824
                  TabOrder = 8
                  Visible = False
                  OnClick = OnChangeOverlay
                end
                object Edit_OverlayOption1: TEdit
                  Left = 106
                  Top = 325
                  Width = 52
                  Height = 20
                  ImeName = 'Microsoft Office IME 2007'
                  NumbersOnly = True
                  TabOrder = 9
                  Text = '0'
                  OnChange = Edit_OverlayOptionChange
                end
                object Edit_OverlayOption2: TEdit
                  Left = 106
                  Top = 351
                  Width = 52
                  Height = 20
                  ImeName = 'Microsoft Office IME 2007'
                  NumbersOnly = True
                  TabOrder = 10
                  Text = '0'
                  OnChange = Edit_OverlayOptionChange
                end
                object Edit_OverlayOption3: TEdit
                  Left = 106
                  Top = 378
                  Width = 52
                  Height = 20
                  ImeName = 'Microsoft Office IME 2007'
                  NumbersOnly = True
                  TabOrder = 11
                  Text = '0'
                  OnChange = Edit_OverlayOptionChange
                end
                object Edit_OverlayOption4: TEdit
                  Left = 106
                  Top = 403
                  Width = 52
                  Height = 20
                  ImeName = 'Microsoft Office IME 2007'
                  NumbersOnly = True
                  TabOrder = 12
                  Text = '0'
                  OnChange = Edit_OverlayOptionChange
                end
                object UpDown_OverlayOption1: TUpDown
                  Left = 158
                  Top = 325
                  Width = 16
                  Height = 20
                  Associate = Edit_OverlayOption1
                  Increment = 5
                  TabOrder = 13
                  OnChangingEx = OnUpDownOverlayChangingEx
                end
                object UpDown_OverlayOption4: TUpDown
                  Tag = 3
                  Left = 158
                  Top = 403
                  Width = 16
                  Height = 20
                  Associate = Edit_OverlayOption4
                  TabOrder = 14
                  OnChangingEx = OnUpDownOverlayChangingEx
                end
                object UpDown_OverlayOption2: TUpDown
                  Tag = 1
                  Left = 158
                  Top = 351
                  Width = 16
                  Height = 20
                  Associate = Edit_OverlayOption2
                  TabOrder = 15
                  OnChangingEx = OnUpDownOverlayChangingEx
                end
                object UpDown_OverlayOption3: TUpDown
                  Tag = 2
                  Left = 158
                  Top = 378
                  Width = 16
                  Height = 20
                  Associate = Edit_OverlayOption3
                  TabOrder = 16
                  OnChangingEx = OnUpDownOverlayChangingEx
                end
                object CheckBox_OPSOverlay: TCheckBox
                  Left = 10
                  Top = 150
                  Width = 159
                  Height = 17
                  Caption = #50724#47700#44032
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = 'Default'
                  Font.Style = [fsBold]
                  ParentFont = False
                  TabOrder = 17
                  OnClick = OnChangeOverlay
                end
                object CheckBox_OPSRELOverlay: TCheckBox
                  Left = 10
                  Top = 190
                  Width = 120
                  Height = 17
                  Caption = #50724#47700#44032' '#49345#44288#52264#53944
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = 'Default'
                  Font.Style = [fsBold]
                  ParentFont = False
                  TabOrder = 18
                  OnClick = OnChangeOverlay
                end
                object CheckBox_OPSIGUKOverlay: TCheckBox
                  Left = 10
                  Top = 210
                  Width = 120
                  Height = 17
                  Caption = #50724#47700#44032' '#51060#44201#50984
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = 'Default'
                  Font.Style = [fsBold]
                  ParentFont = False
                  TabOrder = 19
                  OnClick = OnChangeOverlay
                end
                object CheckBox_OPSSTDDEVOverlay: TCheckBox
                  Left = 10
                  Top = 230
                  Width = 120
                  Height = 17
                  Caption = #50724#47700#44032' '#54364#51456#54200#52264
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = 'Default'
                  Font.Style = [fsBold]
                  ParentFont = False
                  TabOrder = 20
                  OnClick = OnChangeOverlay
                end
                object CheckBox_OPSIGUK2Overlay: TCheckBox
                  Left = 10
                  Top = 170
                  Width = 120
                  Height = 17
                  Caption = #50724#47700#44032'2'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = 'Default'
                  Font.Style = [fsBold]
                  ParentFont = False
                  TabOrder = 21
                  OnClick = OnChangeOverlay
                end
                object Panel_BugFixOverlay: TPanel
                  Left = 5
                  Top = 324
                  Width = 73
                  Height = 105
                  BevelOuter = bvNone
                  ParentBackground = False
                  TabOrder = 22
                  Visible = False
                end
                object Button_SendOverlayOption: TButton
                  Left = 80
                  Top = 292
                  Width = 95
                  Height = 25
                  Caption = #45796#47480#52285#50640' '#51201#50857
                  TabOrder = 23
                  OnClick = Button_SendOverlayOptionClick
                end
              end
              object CategoryPanel3: TCategoryPanel
                Tag = 2
                Top = 526
                Height = 26
                Caption = #48372#51312#51648#54364
                Collapsed = True
                TabOrder = 2
                OnExpand = CategoryPanel1Expand
                ExpandedHeight = 500
                object Label_IndicatorOption1: TLabel
                  Left = 10
                  Top = 342
                  Width = 30
                  Height = 12
                  Caption = #50741#49496'1'
                end
                object Label_IndicatorOption2: TLabel
                  Left = 10
                  Top = 369
                  Width = 30
                  Height = 12
                  Caption = #50741#49496'2'
                end
                object Label_IndicatorOption3: TLabel
                  Left = 10
                  Top = 396
                  Width = 30
                  Height = 12
                  Caption = #50741#49496'3'
                end
                object Label_IndicatorOption4: TLabel
                  Left = 10
                  Top = 423
                  Width = 30
                  Height = 12
                  Caption = #50741#49496'4'
                end
                object m_cbIndicatorVolume: TCheckBox
                  Left = 10
                  Top = 10
                  Width = 90
                  Height = 17
                  Caption = #44144#47000#47049
                  TabOrder = 0
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorSlowSTC: TCheckBox
                  Left = 10
                  Top = 30
                  Width = 90
                  Height = 17
                  Caption = 'Slow STC'
                  TabOrder = 1
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorFastSTC: TCheckBox
                  Left = 10
                  Top = 50
                  Width = 90
                  Height = 17
                  Caption = 'Fast STC'
                  TabOrder = 2
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorADX: TCheckBox
                  Left = 10
                  Top = 70
                  Width = 90
                  Height = 17
                  Caption = 'ADX'
                  TabOrder = 3
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorSONAR: TCheckBox
                  Left = 10
                  Top = 90
                  Width = 90
                  Height = 17
                  Caption = 'SONAR'
                  TabOrder = 4
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorVR: TCheckBox
                  Left = 10
                  Top = 110
                  Width = 90
                  Height = 17
                  Caption = 'VR'
                  TabOrder = 5
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorPSY: TCheckBox
                  Left = 10
                  Top = 130
                  Width = 90
                  Height = 17
                  Caption = #53804#51088#49900#47532#49440
                  TabOrder = 6
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorWilliams: TCheckBox
                  Left = 10
                  Top = 150
                  Width = 90
                  Height = 17
                  Caption = 'Williams %R'
                  TabOrder = 7
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorDMI: TCheckBox
                  Left = 114
                  Top = 150
                  Width = 110
                  Height = 17
                  Caption = 'DMI'
                  TabOrder = 8
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorMACD: TCheckBox
                  Left = 114
                  Top = 10
                  Width = 110
                  Height = 17
                  Caption = 'MACD'
                  TabOrder = 9
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorRSI: TCheckBox
                  Left = 114
                  Top = 30
                  Width = 110
                  Height = 17
                  Caption = 'RSI'
                  TabOrder = 10
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorOBV: TCheckBox
                  Left = 114
                  Top = 50
                  Width = 110
                  Height = 17
                  Caption = 'OBV'
                  TabOrder = 11
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorCCI: TCheckBox
                  Left = 114
                  Top = 70
                  Width = 110
                  Height = 17
                  Caption = 'CCI'
                  TabOrder = 12
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorTRIX: TCheckBox
                  Left = 114
                  Top = 90
                  Width = 110
                  Height = 17
                  Caption = 'TRIX'
                  TabOrder = 13
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorPMAO: TCheckBox
                  Left = 114
                  Top = 110
                  Width = 110
                  Height = 17
                  Caption = 'PMAO'
                  TabOrder = 14
                  OnClick = OnChangeIndicators
                end
                object m_cbIndicatorROC: TCheckBox
                  Left = 114
                  Top = 130
                  Width = 110
                  Height = 17
                  Caption = 'ROC'
                  TabOrder = 15
                  OnClick = OnChangeIndicators
                end
                object m_cbbIndicatorSelChart: TComboBox
                  Left = 10
                  Top = 280
                  Width = 165
                  Height = 20
                  Style = csDropDownList
                  ImeName = 'Microsoft Office IME 2007'
                  ItemHeight = 12
                  TabOrder = 16
                  OnChange = OnChangeIndicatorOption
                end
                object Button_IndicatorDefault: TButton
                  Left = 10
                  Top = 307
                  Width = 65
                  Height = 25
                  Caption = #44592#48376#44050
                  TabOrder = 17
                  OnClick = Button_IndicatorDefaultClick
                end
                object Edit_IndicatorOption1: TEdit
                  Left = 106
                  Top = 339
                  Width = 52
                  Height = 20
                  ImeName = 'Microsoft Office IME 2007'
                  NumbersOnly = True
                  TabOrder = 18
                  Text = '0'
                  OnChange = Edit_IndicatorOptionChange
                end
                object UpDown_IndicatorOption1: TUpDown
                  Left = 158
                  Top = 339
                  Width = 16
                  Height = 20
                  Associate = Edit_IndicatorOption1
                  TabOrder = 19
                  OnChangingEx = OnUpDownIndicatorChangingEx
                end
                object Edit_IndicatorOption2: TEdit
                  Left = 106
                  Top = 366
                  Width = 52
                  Height = 20
                  ImeName = 'Microsoft Office IME 2007'
                  NumbersOnly = True
                  TabOrder = 20
                  Text = '0'
                  OnChange = Edit_IndicatorOptionChange
                end
                object UpDown_IndicatorOption2: TUpDown
                  Tag = 1
                  Left = 158
                  Top = 366
                  Width = 16
                  Height = 20
                  Associate = Edit_IndicatorOption2
                  TabOrder = 21
                  OnChangingEx = OnUpDownIndicatorChangingEx
                end
                object Edit_IndicatorOption3: TEdit
                  Left = 106
                  Top = 394
                  Width = 52
                  Height = 20
                  ImeName = 'Microsoft Office IME 2007'
                  NumbersOnly = True
                  TabOrder = 22
                  Text = '0'
                  OnChange = Edit_IndicatorOptionChange
                end
                object UpDown_IndicatorOption3: TUpDown
                  Tag = 2
                  Left = 158
                  Top = 394
                  Width = 16
                  Height = 20
                  Associate = Edit_IndicatorOption3
                  TabOrder = 23
                  OnChangingEx = OnUpDownIndicatorChangingEx
                end
                object Edit_IndicatorOption4: TEdit
                  Left = 106
                  Top = 421
                  Width = 52
                  Height = 20
                  ImeName = 'Microsoft Office IME 2007'
                  NumbersOnly = True
                  TabOrder = 24
                  Text = '0'
                  OnChange = Edit_IndicatorOptionChange
                end
                object UpDown_IndicatorOption4: TUpDown
                  Tag = 3
                  Left = 158
                  Top = 421
                  Width = 16
                  Height = 20
                  Associate = Edit_IndicatorOption4
                  TabOrder = 25
                  OnChangingEx = OnUpDownIndicatorChangingEx
                end
                object m_cbOPS: TCheckBox
                  Left = 10
                  Top = 170
                  Width = 120
                  Height = 17
                  Caption = #50724#47700#44032
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = 'Default'
                  Font.Style = [fsBold]
                  ParentFont = False
                  TabOrder = 26
                  OnClick = OnChangeIndicators
                end
                object m_cbOPSREL: TCheckBox
                  Left = 10
                  Top = 210
                  Width = 120
                  Height = 17
                  Caption = #50724#47700#44032' '#49345#44288#52264#53944
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = 'Default'
                  Font.Style = [fsBold]
                  ParentFont = False
                  TabOrder = 27
                  OnClick = OnChangeIndicators
                end
                object m_cbOPSIGUK: TCheckBox
                  Left = 10
                  Top = 230
                  Width = 120
                  Height = 17
                  Caption = #50724#47700#44032' '#51060#44201#50984
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = 'Default'
                  Font.Style = [fsBold]
                  ParentFont = False
                  TabOrder = 28
                  OnClick = OnChangeIndicators
                end
                object m_cbOPSIGUK2: TCheckBox
                  Left = 10
                  Top = 190
                  Width = 120
                  Height = 17
                  Caption = #50724#47700#44032'2'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = 'Default'
                  Font.Style = [fsBold]
                  ParentFont = False
                  TabOrder = 29
                  OnClick = OnChangeIndicators
                end
                object m_cbOPSSTD: TCheckBox
                  Left = 10
                  Top = 250
                  Width = 120
                  Height = 17
                  Caption = #50724#47700#44032' '#54364#51456#54200#52264
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = 'Default'
                  Font.Style = [fsBold]
                  ParentFont = False
                  TabOrder = 30
                  OnClick = OnChangeIndicators
                end
                object Panel_BufFixIndicator: TPanel
                  Left = 2
                  Top = 335
                  Width = 73
                  Height = 105
                  BevelOuter = bvNone
                  ParentBackground = False
                  TabOrder = 31
                  Visible = False
                end
                object Button_SendIndicatorOption: TButton
                  Left = 80
                  Top = 307
                  Width = 95
                  Height = 25
                  Caption = #45796#47480#52285#50640' '#51201#50857
                  TabOrder = 32
                  OnClick = Button_SendIndicatorOptionClick
                end
              end
              object CategoryPanel4: TCategoryPanel
                Tag = 3
                Top = 552
                Height = 26
                Caption = #47588#47588#49884#48044#47112#51060#49496
                Collapsed = True
                TabOrder = 3
                OnExpand = CategoryPanel1Expand
                ExpandedHeight = 500
                object Label_SignalOption1: TLabel
                  Left = 10
                  Top = 360
                  Width = 30
                  Height = 12
                  Caption = #50741#49496'1'
                end
                object Label_SignalOption2: TLabel
                  Left = 10
                  Top = 386
                  Width = 30
                  Height = 12
                  Caption = #50741#49496'2'
                end
                object Label_SignalOption3: TLabel
                  Left = 10
                  Top = 413
                  Width = 30
                  Height = 12
                  Caption = #50741#49496'3'
                end
                object Label_SignalOption4: TLabel
                  Left = 10
                  Top = 440
                  Width = 30
                  Height = 12
                  Caption = #50741#49496'4'
                end
                object Bevel1: TBevel
                  Left = 10
                  Top = 215
                  Width = 165
                  Height = 3
                end
                object Button_SignalDefaultOption: TButton
                  Left = 10
                  Top = 324
                  Width = 65
                  Height = 25
                  Caption = #44592#48376#44050
                  TabOrder = 0
                  OnClick = Button_SignalDefaultOptionClick
                end
                object CheckBox_ADXSignal: TCheckBox
                  Left = 10
                  Top = 130
                  Width = 150
                  Height = 17
                  Caption = 'ADX '#46028#54028
                  TabOrder = 1
                  OnClick = CheckBox_SignalClick
                end
                object CheckBox_FSTCSignal: TCheckBox
                  Left = 10
                  Top = 90
                  Width = 150
                  Height = 17
                  Caption = 'Fast STC '#46028#54028
                  TabOrder = 2
                  OnClick = CheckBox_SignalClick
                end
                object CheckBox_MACDSignal: TCheckBox
                  Left = 10
                  Top = 50
                  Width = 150
                  Height = 17
                  Caption = 'MACD '#46028#54028
                  TabOrder = 3
                  OnClick = CheckBox_SignalClick
                end
                object CheckBox_MASignal: TCheckBox
                  Left = 10
                  Top = 30
                  Width = 150
                  Height = 17
                  Caption = #51060#54217' '#46028#54028
                  TabOrder = 4
                  OnClick = CheckBox_SignalClick
                end
                object CheckBox_PMASignal: TCheckBox
                  Left = 10
                  Top = 10
                  Width = 150
                  Height = 17
                  Caption = #51452#44032'('#50724#47700#44032'):'#51060#54217' '#46028#54028
                  TabOrder = 5
                  OnClick = CheckBox_SignalClick
                end
                object CheckBox_RSISignal: TCheckBox
                  Left = 10
                  Top = 110
                  Width = 150
                  Height = 17
                  Caption = 'RSI '#46028#54028
                  TabOrder = 6
                  OnClick = CheckBox_SignalClick
                end
                object CheckBox_SONARSignal: TCheckBox
                  Left = 10
                  Top = 170
                  Width = 150
                  Height = 17
                  Caption = 'SONAR '#46028#54028
                  TabOrder = 7
                  OnClick = CheckBox_SignalClick
                end
                object CheckBox_SSTCSignal: TCheckBox
                  Left = 10
                  Top = 70
                  Width = 150
                  Height = 17
                  Caption = 'Slow STC '#46028#54028
                  TabOrder = 8
                  OnClick = CheckBox_SignalClick
                end
                object CheckBox_TRIXSignal: TCheckBox
                  Left = 10
                  Top = 190
                  Width = 150
                  Height = 17
                  Caption = 'TRIX '#46028#54028
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 9
                  OnClick = CheckBox_SignalClick
                end
                object CheckBox_WilliamsSignal: TCheckBox
                  Left = 10
                  Top = 150
                  Width = 150
                  Height = 17
                  Caption = 'Williams'#39' %R '#46028#54028
                  TabOrder = 10
                  OnClick = CheckBox_SignalClick
                end
                object ComboBox_SelectedSignal: TComboBox
                  Left = 10
                  Top = 297
                  Width = 165
                  Height = 20
                  Style = csDropDownList
                  ImeName = 'Microsoft Office IME 2007'
                  ItemHeight = 12
                  TabOrder = 11
                  OnChange = ComboBox_SelectedSignalChange
                end
                object Edit_SignalOption1: TEdit
                  Left = 106
                  Top = 357
                  Width = 52
                  Height = 20
                  ImeName = 'Microsoft Office IME 2007'
                  NumbersOnly = True
                  TabOrder = 12
                  Text = '0'
                  OnChange = Edit_SignalOptionChange
                end
                object Edit_SignalOption2: TEdit
                  Left = 106
                  Top = 384
                  Width = 52
                  Height = 20
                  ImeName = 'Microsoft Office IME 2007'
                  NumbersOnly = True
                  TabOrder = 13
                  Text = '0'
                  OnChange = Edit_SignalOptionChange
                end
                object Edit_SignalOption3: TEdit
                  Left = 106
                  Top = 410
                  Width = 52
                  Height = 20
                  ImeName = 'Microsoft Office IME 2007'
                  NumbersOnly = True
                  TabOrder = 14
                  Text = '0'
                  OnChange = Edit_SignalOptionChange
                end
                object Edit_SignalOption4: TEdit
                  Left = 106
                  Top = 437
                  Width = 52
                  Height = 20
                  ImeName = 'Microsoft Office IME 2007'
                  NumbersOnly = True
                  TabOrder = 15
                  Text = '0'
                  OnChange = Edit_SignalOptionChange
                end
                object UpDown_SignalOption1: TUpDown
                  Left = 158
                  Top = 357
                  Width = 16
                  Height = 20
                  Associate = Edit_SignalOption1
                  Increment = 5
                  TabOrder = 16
                  OnChangingEx = UpDown_SignalOptionChangingEx
                end
                object UpDown_SignalOption2: TUpDown
                  Tag = 1
                  Left = 158
                  Top = 384
                  Width = 16
                  Height = 20
                  Associate = Edit_SignalOption2
                  TabOrder = 17
                  OnChangingEx = UpDown_SignalOptionChangingEx
                end
                object UpDown_SignalOption3: TUpDown
                  Tag = 2
                  Left = 158
                  Top = 410
                  Width = 16
                  Height = 20
                  Associate = Edit_SignalOption3
                  TabOrder = 18
                  OnChangingEx = UpDown_SignalOptionChangingEx
                end
                object UpDown_SignalOption4: TUpDown
                  Tag = 3
                  Left = 158
                  Top = 437
                  Width = 16
                  Height = 20
                  Associate = Edit_SignalOption4
                  TabOrder = 19
                  OnChangingEx = UpDown_SignalOptionChangingEx
                end
                object Panel_BugFix: TPanel
                  Left = 0
                  Top = 356
                  Width = 81
                  Height = 105
                  BevelOuter = bvNone
                  ParentBackground = False
                  ParentColor = True
                  TabOrder = 20
                  Visible = False
                end
                object CheckBox_NMATrendSignal: TCheckBox
                  Left = 10
                  Top = 225
                  Width = 150
                  Height = 17
                  Caption = #45800#49692' '#51060#54217#49440' '#52628#49464#51204#54872
                  TabOrder = 21
                  OnClick = CheckBox_SignalClick
                end
                object CheckBox_WMATrendSignal: TCheckBox
                  Left = 10
                  Top = 246
                  Width = 150
                  Height = 17
                  Caption = #44032#51473' '#51060#54217#49440' '#52628#49464#51204#54872
                  TabOrder = 22
                  OnClick = CheckBox_SignalClick
                end
                object CheckBox_XMATrendSignal: TCheckBox
                  Left = 10
                  Top = 266
                  Width = 150
                  Height = 17
                  Caption = #51648#49688' '#51060#54217#49440' '#52628#49464#51204#54872
                  TabOrder = 23
                  OnClick = CheckBox_SignalClick
                end
                object Button_SendSignalOption: TButton
                  Left = 80
                  Top = 324
                  Width = 95
                  Height = 25
                  Caption = #45796#47480#52285#50640' '#51201#50857
                  TabOrder = 24
                  OnClick = Button_SendSignalOptionClick
                end
              end
              object CategoryPanel5: TCategoryPanel
                Tag = 4
                Top = 578
                Height = 26
                Caption = #52628#49464#49440
                Collapsed = True
                TabOrder = 4
                OnExpand = CategoryPanel1Expand
                object m_gbTrendline: TGroupBox
                  Left = 3
                  Top = 11
                  Width = 171
                  Height = 158
                  Caption = #52628#49464#49440
                  TabOrder = 0
                  object ToolBar1: TToolBar
                    Left = 5
                    Top = 54
                    Width = 163
                    Height = 22
                    Align = alCustom
                    AutoSize = True
                    Caption = 'ToolBar1'
                    TabOrder = 0
                    object SpeedButton8: TSpeedButton
                      Left = 0
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawQuadrant
                    end
                    object SpeedButton9: TSpeedButton
                      Left = 23
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawSpeedLine
                    end
                    object SpeedButton10: TSpeedButton
                      Left = 46
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawFFan
                    end
                    object SpeedButton11: TSpeedButton
                      Left = 69
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawFRetracement
                    end
                    object SpeedButton12: TSpeedButton
                      Left = 92
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawTimeZone
                    end
                    object SpeedButton13: TSpeedButton
                      Left = 115
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawAFP
                    end
                    object SpeedButton5: TSpeedButton
                      Left = 138
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawText
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = clWindowText
                      Font.Height = -11
                      Font.Name = 'Tahoma'
                      Font.Style = []
                      ParentFont = False
                    end
                  end
                  object ToolBar2: TToolBar
                    Left = 5
                    Top = 26
                    Width = 163
                    Height = 22
                    Align = alCustom
                    Caption = 'ToolBar2'
                    TabOrder = 1
                    object m_btnDrawLine: TSpeedButton
                      Left = 0
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawLine
                    end
                    object SpeedButton1: TSpeedButton
                      Left = 23
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawHLine
                    end
                    object m_btnDrawVLine: TSpeedButton
                      Left = 46
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawVLine
                    end
                    object SpeedButton6: TSpeedButton
                      Left = 69
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawCLine
                    end
                    object SpeedButton3: TSpeedButton
                      Left = 92
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawRectangle
                    end
                    object SpeedButton4: TSpeedButton
                      Left = 115
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawCircle
                    end
                    object SpeedButton7: TSpeedButton
                      Left = 138
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawTirone
                    end
                  end
                  object ToolBar3: TToolBar
                    Left = 5
                    Top = 82
                    Width = 163
                    Height = 23
                    Align = alCustom
                    Caption = 'ToolBar3'
                    Images = ImageList_NormalTollbar
                    TabOrder = 2
                    object SpeedButton2: TSpeedButton
                      Left = 0
                      Top = 0
                      Width = 23
                      Height = 22
                      Action = DrawEraser
                    end
                  end
                end
              end
            end
          end
        end
      end
      object Panel_ConfigSmall: TPanel
        Left = 177
        Top = 404
        Width = 16
        Height = 89
        BevelOuter = bvNone
        Color = 14473424
        ParentBackground = False
        TabOrder = 1
        Visible = False
        OnClick = SpeedButton_ShowConfigPanelClick
        object SpeedButton_ShowConfigPanel: TSpeedButton
          Left = 0
          Top = 24
          Width = 11
          Height = 32
          Glyph.Data = {
            A6000000424DA600000000000000360000002800000005000000070000000100
            18000000000070000000120B0000120B00000000000000000000F0F0F0F0F0F0
            DBDBDB74747464646400F0F0F0DDDDDD5A5A5A67676765656500DCDCDC585858
            6565657676766B6B6B005B5B5B6363637575757B7B7B70707000E1E1E1626262
            6E6E6E7E7E7E76767600F0F0F0E3E3E37171717C7C7C7B7B7B00F0F0F0F0F0F0
            E4E4E47E7E7E7F7F7F00}
          Margin = 0
          OnClick = SpeedButton_ShowConfigPanelClick
        end
      end
      object Panel10: TPanel
        Left = 194
        Top = 4
        Width = 33
        Height = 20
        Anchors = [akTop, akRight]
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 2
        object SpeedButton_HideConfigPanel: TSpeedButton
          Left = 10
          Top = 0
          Width = 18
          Height = 18
          Glyph.Data = {
            A6000000424DA600000000000000360000002800000005000000070000000100
            18000000000070000000120B0000120B000000000000000000007F7F7F7E7E7E
            E4E4E4F0F0F0F0F0F0007B7B7B7C7C7C717171E3E3E3F0F0F0007676767E7E7E
            6E6E6E626262E1E1E1007070707B7B7B7575756363635B5B5B006B6B6B767676
            656565585858DCDCDC006565656767675A5A5ADDDDDDF0F0F000646464747474
            DBDBDBF0F0F0F0F0F000}
          OnClick = SpeedButton_HideConfigPanelClick
        end
      end
    end
  end
  object ToolBarChartMenu: TToolBar
    Left = 0
    Top = 0
    Width = 1129
    Height = 26
    BorderWidth = 1
    ButtonWidth = 115
    Caption = #52264#53944#47700#45684
    DrawingStyle = dsGradient
    HotImages = ImageList_HotTollbar
    Images = ImageList_NormalTollbar
    Indent = 20
    List = True
    ShowCaptions = True
    TabOrder = 1
    Transparent = True
    Wrapable = False
    object ToolButton7: TToolButton
      Left = 20
      Top = 0
      Width = 8
      Style = tbsSeparator
    end
    object ToolButton5: TToolButton
      Left = 28
      Top = 0
      Action = Action_OPSPrice
      AutoSize = True
      Style = tbsCheck
    end
    object ToolButton2: TToolButton
      Left = 123
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object m_btnTraceVisible: TToolButton
      Left = 131
      Top = 0
      Action = Trace
      AutoSize = True
      Caption = #51340#54364#51221#48372
      Style = tbsCheck
    end
    object ToolButton6: TToolButton
      Left = 210
      Top = 0
      Width = 8
      Caption = 'ToolButton6'
      ImageIndex = 6
      Style = tbsSeparator
    end
    object ToolButton9: TToolButton
      Left = 218
      Top = 0
      Action = Action_ShowHideTradeRepot
      AutoSize = True
      Style = tbsCheck
    end
    object ToolButton8: TToolButton
      Left = 337
      Top = 0
      Width = 8
      Caption = 'ToolButton8'
      ImageIndex = 5
      Style = tbsSeparator
    end
    object ToolButton1: TToolButton
      Left = 345
      Top = 0
      Action = Action_Config
      AutoSize = True
      Style = tbsCheck
    end
    object Label2: TLabel
      Left = 424
      Top = 0
      Width = 80
      Height = 22
      Caption = '   '#53440#51076#54532#47112#51076': '
      Layout = tlCenter
    end
    object ComboBox_TimeFrame: TComboBox
      Left = 504
      Top = 0
      Width = 74
      Height = 20
      Style = csDropDownList
      ImeName = 'Microsoft Office IME 2007'
      ItemHeight = 12
      ItemIndex = 7
      TabOrder = 1
      Text = '5'#48516
      OnChange = ComboBox_TimeFrameChange
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
        '60'#48516
        #51068#44036)
    end
    object Label1: TLabel
      Left = 578
      Top = 0
      Width = 60
      Height = 22
      Caption = '   '#48148#51032' '#49688': '
      Layout = tlCenter
    end
    object ComboBoxRQCount: TComboBox
      Left = 638
      Top = 0
      Width = 74
      Height = 20
      Style = csDropDownList
      ImeName = 'Microsoft Office IME 2007'
      ItemHeight = 12
      TabOrder = 0
      OnChange = ComboBoxRQCountChange
      Items.Strings = (
        '120'
        '240'
        '360'
        '480'
        '600'
        '720'
        '840'
        '960'
        '1080'
        '1200'
        '1320'
        '1440'
        '1560'
        '1680'
        '1800'
        '1920'
        '2040'
        '2160'
        '2280'
        '2400'
        '2520'
        '2640'
        '2760'
        '2880'
        '3000'
        '3120'
        '3240'
        '3360'
        '3480'
        '3600'
        '3720'
        '3840'
        '3960'
        '4080'
        '4200'
        '4320'
        '4440'
        '4560'
        '4680'
        '4800'
        '4920'
        '5040'
        '5160'
        '5280'
        '5400'
        '5520'
        '5640'
        '5760'
        '5880'
        '6000'
        '6120'
        '6240'
        '6360'
        '6480'
        '6600'
        '6720'
        '6840'
        '6960'
        '7080'
        '7200'
        '7320'
        '7440'
        '7560'
        '7680'
        '7800'
        '7920'
        '8040'
        '8160'
        '8280'
        '8400'
        '8520'
        '8640')
    end
    object ToolButton11: TToolButton
      Left = 712
      Top = 0
      Width = 8
      Caption = 'ToolButton11'
      ImageIndex = 11
      Style = tbsSeparator
    end
    object ToolButton10: TToolButton
      Left = 720
      Top = 0
      Action = Action_Reset
      AutoSize = True
    end
    object ToolButton3: TToolButton
      Left = 799
      Top = 0
      Action = Action_Lock
      AutoSize = True
      Caption = #54868#47732#51104#44552
    end
    object ToolButton14: TToolButton
      Left = 878
      Top = 0
      Width = 8
      Caption = 'ToolButton14'
      ImageIndex = 12
      Style = tbsSeparator
    end
    object ToolButton4: TToolButton
      Left = 886
      Top = 0
      Action = ActionChangeStandDate
      AutoSize = True
    end
    object ToolButton12: TToolButton
      Left = 981
      Top = 0
      Action = ActionPrevDate
      AutoSize = True
    end
    object ToolButton13: TToolButton
      Left = 1064
      Top = 0
      Action = ActionNextDate
      AutoSize = True
    end
  end
  object ImageList_HotTollbar: TImageList
    Left = 152
    Top = 280
    Bitmap = {
      494C01010E001000040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009F9F9F00919191009191
      9100919191009191910091919100919191009191910091919100919191009191
      910091919100697A89004A789F00416F96000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000095959500BFBFBF00C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C4C4
      C4008E9EAE005F8DB6008CB1D40045749F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F3D1BB00E9AF
      85000000000000000000000000000000000000000000BCBCBC00EFEFEF00FBFB
      FB00FCFCFC00FCFCFC00FCFCFC00ECE9E600D3C4B800C7AC9400CDAF9600C9A8
      8D00AB998E0096B1CB005A89B500ADBDCD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0CEB500E8A97D00EAAB
      80000000000000000000000000000000000000000000C9C9C900FBFBFB00FBFB
      FB00FBFBFB00FBFBFB00FBFBFB00C7B7A900E2CDBC00F5E0CC00F7E0C700F8E2
      CB00F3D1B300A7998F0094A5B500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000ECC4A600E8B08700EFC8AD00E6A7
      79000000000000000000000000000000000000000000C9C9C900FCFCFC00FBFB
      FB00FBFBFB00FBFBFB00AEAEAE00C9AC9400F3E3D400F4DAC100F3D8BD00F3D8
      BD00F8E3CC00C4A48B00CBCBCB00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E6B38D00E3A47500EDC2A300EEC7A800E2A0
      6E000000000000000000000000000000000000000000C9C9C900FCFCFC00FBFB
      FB00FBFBFB00FBFBFB00AEAEAE00C8A98D00F8EADC00F4DDC600F4DCC400F3D8
      BD00F8E2CD00CCAD9300C7C7C700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DFA47700DD976100E9BB9900E8B79200ECC1A100E197
      62000000000000000000000000000000000000000000C9C9C900FCFCFC00FBFB
      FB00FCFCFC00FCFCFC00AEAEAE00CAAE9500F2E3D500F6E0CA00F5DEC600F5DE
      C500F7E5D200C5AA9400C8C8C800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CC743400D6884B00E4B18A00E3AB8100E3AA8000EABB9900DB8E
      53000000000000000000000000000000000000000000C9C9C900FCFCFC00FCFC
      FC00FCFCFC00CBCBCB00AFAFAF00C1B5A700DDC3AB00F4E6DA00F8ECDF00F2DD
      C900E3C9B200C2B2A400C8C8C800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D78A5E00D37F4300E2AB8100E0A47700E0A37400E7B59000D684
      43000000000000000000000000000000000000000000C9C9C900FCFCFC00FCFC
      FC00FCFCFC00F5F5F500CBCBCB00ECEDED00B6AA9C00BFAE9700C9AB8F00CDAF
      9500BEAB9800F4F7F800C9C9C900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D58B6300D07A3F00E1A97C00DFA17200E4AF8700D277
      35000000000000000000000000000000000000000000C9C9C900FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FBFBFB00000000000000
      0000FFFFFF00FCFCFC00C9C9C900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D38B6500D0773D00E0A67900E1A87E00CD6E
      230000000000000000000000000000000000000000000000DC001313F3003B3B
      E9003333E8002D2DE7002828E3002323E1001E1EDF001B1BDD001717DC001414
      DB001111DC000404ED000000DC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D58C6B00CF743C00DFA37500C962
      1A0000000000000000000000000000000000000000000000DC000F0FEB002828
      BD001C1C98001F1FBC001E1EDD001B1BDF001616DE001212D7000D0DB5000808
      92000606B4000101E6000000DC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D38A6C00CC713B00C459
      180000000000000000000000000000000000000000000000DC000B0BDA00A1A1
      AE00E0E0E0009F9FAE001414CE001212E1000E0EE1000909CC009E9EAE00E0E0
      E0009E9EAE000000D7000000DC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D38C7000C04E
      160000000000000000000000000000000000000000000000DC000707D200C4C4
      D600E3E3E300C4C4D5000303D0000202ED000202ED000101CF00C5C5D600E3E3
      E300C4C4D6000000CF000000DC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000DC000000C700B5B5
      CB00E6E6E600B3B3C9000000C7000000DC000000DC000000C700B8B8CE00E6E6
      E600B6B6CD000000C7000000DC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000A6A6A600BCBCBC0000000000000000000000000000000000C9C9C900AFAF
      AF00C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BEC3D2008693
      BA009EA5BD00C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300D8D8D8000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D0EC
      F700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F4F4F400E6E6E6002C4BA500355D
      AF002142AB00DCDCDC00D8D8D800D4D4D400D2D2D200D1D1D100D3D3D300D1D1
      D100CBCBCB00CDCDCD00C7C7C700C3C3C3000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004CBA
      E3003AB0DF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F000CECECE00C4C6CA00C0C6
      CC002143AC00FDFDFD00FBFBFB00F8F8F800F4F4F400EDEDED00D5D5D500E9E9
      E900FFFFFF00FFFFFF00FFFFFF00C3C3C3000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F5FB
      FD002DAEDF002BABDE0089CFEC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C04E1600D38C700000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F4F4F400DDDDDD006379B300618F
      BF002246AE00FAFAFA00FAFAFA00F6F6F600F3F3F300EEEEEE00F3F3F300CACA
      CA00E6E6E600FBFBFB00FCFCFC00C3C3C3000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000053BEE5004FBCE7004CBAE60035ADDE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C4591800CC713B00D38A6C00000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F000CECECE00C4C6CA00C0C6
      CC002249AE00FAFAFA00FAFAFA00F8F8F800F4F4F400F1F1F100FBFBFB00F2F2
      F200CACACA00E6E6E600FCFCFC00C3C3C3000000000000000000000000000000
      00000000000000000000000000000A822A00037B1E00DEEEE100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002BAFDF0084D3F20055BDE7002EAADE0083CCEB00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C9621A00DFA37500CF743C00D58C6B000000000000000000000000000000
      000000000000000000000000000000000000F4F4F400DDDDDD00647CB3006392
      C100234BAF00F9F9F900F9F9F900F9F9F900F6F6F600F3F3F300FAFAFA00FAFA
      FA00F2F2F200C9C9C900E8E8E800C3C3C3000000000000000000000000000000
      00000000000000000000000000000B88330043A15F001B893700D8EBDC000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000061C5E80070CCEE0083D2F2007ECEF1004AB6E40030AADD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CD6E2300E1A87E00E0A67900D0773D00D38B650000000000000000000000
      000000000000000000000000000000000000F0F0F000CECECE00C4C6CA00C0C6
      CD00234EB100FAFAFA00F9F9F900F8F8F80000000000F6F6F600FAFAFA00FAFA
      FA00FAFAFA00F2F2F200D1D1D100C1C1C1000000000000000000000000002297
      52001C914A00168F4400108B3C003A9F5E0080C1960046A3620018893400D5E9
      D9000000000000000000000000000000000044C6E8003CC2E7003BBFE60039BD
      E50037BAE40035B8E30086D7F3002FB6EB004ABCEC0080CEF10051B9E6002CA8
      DD0078C6E8000000000000000000000000000000000000000000000000000000
      0000D2773500E4AF8700DFA17200E1A97C00D07A3F00D58B6300000000000000
      000000000000000000000000000000000000F4F4F400DDDDDD00657FB5006494
      C2002451B200FAFAFA00F8F8F800E09F7300DD9D7100DC9A6E00DA996B00D998
      6A00D4936A00EAEAEA00ECECEC00C3C3C300000000000000000000000000299B
      5B0090CAA9008DC8A5008AC6A10088C59E006AB6850082C2970048A566001588
      3300CFE6D4000000000000000000000000004BC9EA0075DAF20093E6F80091E3
      F7008DE0F6008ADCF5008ADBF50088D7F40084D3F2007FCFF1007CCCF0007AC9
      EF0048B4E3002CA7DB0000000000000000000000000000000000000000000000
      0000D6844300E7B59000E0A37400E0A47700E2AB8100D37F4300D78A5E000000
      000000000000000000000000000000000000F0F0F000CECECE00C4C6CA00C0C7
      CD002552B200FBFBFB00FAFAFA00F8F8F800F8F8F800F8F8F80000000000F3F3
      F300F2F2F200F0F0F000EEEEEE00C6C6C600000000000000000000000000319F
      630094CDAD006FBA8E006BB8890066B6850061B3800067B5820083C298003CA0
      5C0003812800000000000000000000000000D5F3FA004FCDEC0098E9F9004AD5
      F30045CFF10040CAF00038C2EE0089D9F4002FB4E10032B3E10031B0E0002FAE
      DF002DABDD002BA8DC0036ABDD00000000000000000000000000000000000000
      0000DB8E5300EABB9900E3AA8000E3AB8100E4B18A00D6884B00CC7434000000
      000000000000000000000000000000000000F4F4F400DDDDDD006682B5006596
      C3002555B400FAFAFA00FAFAFA00E0A27600E0A07600E0A07400DF9E7300DC9C
      7200DC9B6F00F2F2F200F6F6F600C3C3C30000000000000000000000000037A3
      6B0096CEB00094CDAD0091CBAA0090CBA80074BC90008AC7A10046A568000988
      3700F0F8F3000000000000000000000000000000000043C9EA0080E1F5008EE6
      F80043D2F3003FCDF10039C7EF008CDCF50058C6EA00A0DDF100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E1976200ECC1A100E8B79200E9BB9900DD976100DFA47700000000000000
      000000000000000000000000000000000000F0F0F000CECECE00C4C6CA00C0C7
      CD002656B500F9F9F900F9F9F900E1A37800EAC0A300EAC0A200EABFA100EABE
      A000DF9E7100F4F4F40000000000C3C3C3000000000000000000000000003DA5
      6F0039A46E0035A26800319E620055AF7C0091CBAA004FAB740019904600F4FA
      F6000000000000000000000000000000000000000000BFEDF8005BD4EF0099EA
      F90047D6F40042D0F2003DCBF0006ED5F3007FD7F3004AC0E700C3E9F6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E2A06E00EEC7A800EDC2A300E3A47500E6B38D0000000000000000000000
      000000000000000000000000000000000000F4F4F400DDDDDD006783B7006699
      C4002659B700F8F8F800F8F8F800E1A57A00E1A37800E1A37700E0A27600E0A0
      7600E0A07400F4F4F400FAFAFA00C3C3C3000000000000000000000000000000
      000000000000000000000000000039A369005AB3810028985700F7FBF9000000
      000000000000000000000000000000000000000000000000000042CBEA0093E9
      F90072E1F70045D4F30041CEF2003CC9F0008ADCF50070D0EF003DBBE4000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E6A77900EFC8AD00E8B08700ECC4A6000000000000000000000000000000
      000000000000000000000000000000000000F0F0F000CECECE00C4C7CA00C0C7
      CD00265BB7000000000000000000000000000000000000000000F5F5F500F5F5
      F500F5F5F500F3F3F300FAFAFA00C3C3C3000000000000000000000000000000
      00000000000000000000000000003FA77100319F6500F8FCF900000000000000
      00000000000000000000000000000000000000000000000000009CE5F50064D9
      F1009AEBFA0048D8F40044D3F3003FCEF1003AC8F0008CDCF50062CBED0033B9
      E300000000000000000000000000000000000000000000000000000000000000
      0000EAAB8000E8A97D00F0CEB500000000000000000000000000000000000000
      000000000000000000000000000000000000F4F4F400DDDDDD006787B900679A
      C500275EB80000000000000000000000000000000000F5F5F500F4F4F400F4F4
      F400F4F4F400F2F2F200FBFBFB00C3C3C3000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000041CC
      EB009AEDFA0099EBF90097E8F90094E5F80091E2F7008EDFF6008BDBF50056C7
      EB003BBBE4000000000000000000000000000000000000000000000000000000
      0000E9AF8500F3D1BB0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F000CECECE00C4C7CA00C1C7
      CD00275FB800FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00C3C3C3000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000086E0
      F3003FCCEB003ECBEA003CC9E9003BC7E9003AC4E80038C2E70036C0E60035BD
      E50033BBE40049C0E60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000ECECEC00648BC2004978
      BE002861BA00C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300D8D8D8000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005199FF002981FF00217D
      FF0063A3FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000065A7FF0061A4FF0097C2FF0094C0
      FF005198FF0065A3FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004995FF00A0C7FF0083B7FF007FB4
      FF0097C2FF005399FF0067A4FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000539DFF00A4CBFF008BBCFF0077B0
      FF0080B5FF0098C3FF00569CFF006BA7FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C5CEB8001CAB4A001CAB4A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000D9739000D973900AECBAB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A1CAFF0079B3FF00A5CCFF008DBD
      FF0079B2FF0083B6FF0099C3FF00589CFF006CA9FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C5CFB9001CAB4A0054E86F001CAB4A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000BAD3F0071DC83000D973900ADCAAA0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007472F9007270F70000000000000000000000
      00000000000000000000000000000000000000000000A3CBFF007BB4FF00A6CC
      FF008EBEFF007CB3FF0085B8FF009BC5FF00599EFF0070ABFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C5CFB90023A34C0051E36A0054E86F001CAB4A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000BAD3F003BC54E0071DC83000D973900ACC9A900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007D7BF900A8A8FE008989FB007270EE00000000000000
      0000000000000000000000000000000000000000000000000000A5CBFF007CB6
      FF00A8CEFF0090BFFF008BBDFF00A0C8FF0061A4FF0061A0FB00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C5D0B90023A34C0046D45C004BDC640051E36A000CAE40000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000CAE40003FCD54003BC64D0078DD8A0007933500ACC9A8000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007776FA00D4D4FF007575FE004141F4008B8BF8006F6DE2000000
      000000000000000000000000000000000000000000000000000000000000A7CD
      FF007EB7FF00A9CEFF00A8CDFF0070ACFF005F9AEE008C8C8C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6D1BA0025AA4F003BC64D0040CC540045D55C004BDC64000CAE40000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000BAD3F0046D55C0040CC54003BC64E0078DD8A000D973900C7D2
      BB00000000000000000000000000000000000000000000000000000000000000
      00007777FC00C7C7FF00D4D4FF006464FE004545F0004747F4008A8AEB006461
      E000000000000000000000000000000000000000000000000000000000000000
      0000A7CEFF0081B7FF007CB4FF006FA7F200D2D2D200B5B5B500898989008989
      89008787870097979700C8C8C800000000000000000000000000000000000000
      0000C7D2BB000D97390078DD8A003BC64E0040CC540046D55C000BAD3F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000CAE40004BDC640045D55C0040CC54003BC64D0025AA4F00C6D1
      BA00000000000000000000000000000000000000000000000000000000007F80
      FD00B1B1FF00E7E7FF00CFCFFF005B5BFE004A4AEC004B4BEF004848EF008686
      DD006461DF000000000000000000000000000000000000000000000000000000
      000000000000A9CFFF0084B6F70094949400C7C7C700CCCCCC00C7C7C700C6C6
      C600C3C3C300C0C0C00089898900C8C8C8000000000000000000000000000000
      000000000000ACC9A8000793350078DD8A003BC64D003FCD54000CAE40000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000CAE400051E36A004BDC640046D45C0023A34C00C5D0B9000000
      00000000000000000000000000000000000000000000000000008689FE00A5A5
      FF00E1E1FF00FFFFFF00C1C1FF005454FD004B4BE6004A4AE9004A4AF1004242
      DE008585D7006664DE0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000093939300D4D4D400C8C8C800BCBC
      BC00BABABA00C2C2C200C4C4C400999999000000000000000000000000000000
      00000000000000000000ACC9A9000D97390071DC83003BC54E000BAD3F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001CAB4A0054E86F0051E36A0023A34C00C5CFB900000000000000
      000000000000000000000000000000000000000000009B9DFF00B3B3FF00ABAB
      FF00D5D5FF00D0D0FF00ADADFF007575FD006868E3006464E6006363EE005C5C
      EB004D4DCD008888D800716FDB00000000000000000000000000000000000000
      00000000000000000000000000000000000097979700DDDDDD00C5C5C500AAAA
      AA00A8A8A800ACACAC00D7D7D700898989000000000000000000000000000000
      0000000000000000000000000000ADCAAA000D97390071DC83000BAD3F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001CAB4A0054E86F001CAB4A00C5CFB90000000000000000000000
      000000000000000000000000000000000000000000007A7EFE00B8B9FF00C6C6
      FF00D1D1FF00DBDBFF00D6D6FF00BFC0FD00A5A5EC00A2A2EE00A0A0F2009A99
      EF009090E3007F7EE3004B46F400000000000000000000000000000000000000
      0000000000000000000000000000000000009A9A9A00E4E4E400CFCFCF00ACAC
      AC00000000008E8E8E008C8C8C008C8C8C000000000000000000000000000000
      000000000000000000000000000000000000AECBAB000D9739000D9739000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001CAB4A001CAB4A00C5CEB8000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007E82FE007C80
      FE007C80FE007A7DFD00777AFD007476FC007072FB006C6DFA006767F9006362
      F8005E5DF7005C59F70000000000000000000000000000000000000000000000
      000000000000000000000000000000000000ABABAB00E2E2E200E7E7E700B9B9
      B900939393000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D4D4D4009F9F9F00E4E4E400EEEE
      EE00969696000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D4D4D400ACACAC009D9D
      9D009B9B9B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DEDE
      DF00CBD2D8000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DEDE
      DF00CBD2D8000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DEDE
      DF00CBD2D8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DCDDDE005A8B
      B10022679D00729AB70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DCDDDE005A8B
      B10022679D00729AB70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DCDDDE005A8B
      B10022679D00729AB70000000000000000000000000000000000000000000000
      000000000000C8A49E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DCDDDF006592B800558D
      BC0089B5DD00185F970000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DCDDDF006592B800558D
      BC0089B5DD00185F970000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DCDDDF006592B800558D
      BC0089B5DD00185F970000000000000000000000000000000000000000000000
      000000000000C8A49E00000000000000000000000000B3827B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDEDF00719AC0006497C5009DC1
      E4006699C7002E6FA20000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDEDF00719AC0006497C5009DC1
      E4006699C7002E6FA20000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDEDF00719AC0006497C5009DC1
      E4006699C7002E6FA20000000000000000000000000000000000000000000000
      000000000000C8A49E00000000000000000000000000B3827B00B3827B000000
      0000000000000000000000000000000000000000000000000000E0E0DF00DCC2
      AD00D7AF8F00D3A58000D0A17C00CFA38100AA9D950075A2CC00ABCBE80076A4
      CE003E79AC00C4CED70000000000000000000000000000000000E0E0DF00DCC2
      AD00D7AF8F00D3A58000D0A17C00CFA38100AA9D950075A2CC00ABCBE80076A4
      CE003E79AC00C4CED70000000000000000000000000000000000E0E0DF00DCC2
      AD00D7AF8F00D3A58000D0A17C00CFA38100AA9D950075A2CC00ABCBE80076A4
      CE003E79AC00C4CED70000000000000000000000000000000000000000000000
      000000000000C8A49F00000000000000000000000000B3827B00DCC4C000B382
      7B000000000000000000000000000000000000000000E0E0DF00E1C2A800E8C9
      AE00F5E1CD00F7E5D300F7E5D100F3DDC800DFBA9C003D7F3E002C7331002B6F
      3B00C6D0D90000000000000000000000000000000000E0E0DF00E1C2A800E8C9
      AE00F5E1CD00F7E5D300F7E5D100F3DDC800DFBA9C00C7A8910086AED5004D85
      B800C6D0D90000000000000000000000000000000000E0E0DF00E1C2A800E8C9
      AE00F5E1CD00F7E5D300F7E5D100F3DDC800DFBA9C00C7A8910086AED5004D85
      B800C6D0D9000000000000000000000000000000000000000000000000000000
      000000000000C8A49F00000000000000000000000000B3837B00EBDCD900EBDC
      D900B3837B00B3837B00B3837B000000000000000000E5CFBB00EDD0B700F8E8
      D900F5DEC800F3D8BD00F3D6BB00F4DBC200F7E4D2003986400054A970002E75
      33000000000000000000000000000000000000000000E5CFBB00EDD0B700F8E8
      D900F5DEC800F3D8BD00F3D6BB00F4DBC200F7E4D200DFBB9D009F969400C9D2
      DA000000000000000000000000000000000000000000E5CFBB00EDD0B700F8E8
      D900F5DEC800F3D8BD00F3D6BB00F4DBC200F7E4D200DFBB9D009F969400C9D2
      DA00000000000000000000000000000000000000000000000000000000000000
      000000000000C8A59F00000000000000000000000000B3837C00F2E7E500F2E7
      E500F2E7E500B3837C00000000000000000000000000EBCBAE00F7E7D700F6E1
      CC00F4DBC200F4DAC000F3D8BD0061A86200489A500051A0620060B27E004493
      53002F78350030743500000000000000000000000000EBCBAE00F7E7D700F6E1
      CC00F4DBC200F4DAC000F3D8BD007371F3005654F7004845F4003A35F1002E26
      EE00231AEC002217EA00000000000000000000000000EBCBAE00F7E7D700F6E1
      CC00F4DBC200F4DAC000F3D8BD00F3D7BB00F4DBC200F3DEC900CFA585000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A59F00000000000000000000000000B3837C00FBF5F400FDF9
      F900B3837C0000000000000000000000000000000000F0CEAE00F9ECDF00F5DF
      C800F5DDC600F4DCC300F4DAC10056AD5F0079C49C0073BF94006CBA8C0065B6
      84005EB07B00317B3700000000000000000000000000F0CEAE00F9ECDF00F5DF
      C800F5DDC600F4DCC300F4DAC1006D6FFC0095A7F20091A1F0008D9BED008793
      EB00828CE800231AEC00000000000000000000000000F0CEAE00F9ECDF00F5DF
      C800F5DDC600F4DCC300F4DAC100F3D9BE00F3D7BD00F8E6D300D3A580000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A59F00000000000000000000000000B3837C00FFFBFB00B383
      7C000000000000000000000000000000000000000000F4D3B400F9EDE100F6E1
      CC00F5DFC900F5DEC700F4DCC40069BB6E0058B0610064B5780078C39A0058A7
      69003F8E4600448C4B00000000000000000000000000F4D3B400F9EDE100F6E1
      CC00F5DFC900F5DEC700F4DCC4007E80F9006D6FFC006263FA005654F7004845
      F4003A35F1003A32ED00000000000000000000000000F4D3B400F9EDE100F6E1
      CC00F5DFC900F5DEC700F4DCC400F4DBC200F4DAC000F8E7D600D7AA87000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A59F00000000000000000000000000B3847C00B3847C000000
      00000000000000000000000000000000000000000000F4D8BD00F9EBDE00F7E7
      D600F6E1CC00F5E0CA00F5DEC800F5DDC500F6E1CB0059B3630082CAA7004EA2
      56000000000000000000000000000000000000000000F4D8BD00F9EBDE00F7E7
      D600F6E1CC00F5E0CA00F5DEC800F5DDC500F6E1CB00F5E2D000DCB595000000
      00000000000000000000000000000000000000000000F4D8BD00F9EBDE00F7E7
      D600F6E1CC00F5E0CA00F5DEC800F5DDC500F6E1CB00F5E2D000DCB595000000
      00000000000000000000000000000000000000000000C8A5A000C8A5A000C8A5
      A000C8A5A000C8A5A000C8A5A000C8A5A000C8A5A000B3847D00000000000000
      00000000000000000000000000000000000000000000EFDDCB00F8E2CC00FAEE
      E300F7E7D600F6E2CE00F6E1CB00F6E3D000F9EADD0069BD70005BB565005AAF
      63000000000000000000000000000000000000000000EFDDCB00F8E2CC00FAEE
      E300F7E7D600F6E2CE00F6E1CB00F6E3D000F9EADD00ECCFB500DFC7B2000000
      00000000000000000000000000000000000000000000EFDDCB00F8E2CC00FAEE
      E300F7E7D600F6E2CE00F6E1CB00F6E3D000F9EADD00ECCFB500DFC7B2000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A5A00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F4DCC600F9E2
      CD00FAECDE00F9EEE200F9EDE200F8E9DA00F0D5BD00E5C8AF00E0E0DF000000
      0000000000000000000000000000000000000000000000000000F4DCC600F9E2
      CD00FAECDE00F9EEE200F9EDE200F8E9DA00F0D5BD00E5C8AF00E0E0DF000000
      0000000000000000000000000000000000000000000000000000F4DCC600F9E2
      CD00FAECDE00F9EEE200F9EDE200F8E9DA00F0D5BD00E5C8AF00E0E0DF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A5A00000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFDE
      CC00F6DABF00F6D6B800F4D3B400EFD1B400E8D4C10000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFDE
      CC00F6DABF00F6D6B800F4D3B400EFD1B400E8D4C10000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFDE
      CC00F6DABF00F6D6B800F4D3B400EFD1B400E8D4C10000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF00FFFF800000000000FFFF800000000000
      FFCF800000000000FF8F800100000000FF0F800100000000FE0F800100000000
      FC0F800100000000F80F800100000000F80F800100000000FC0F803100000000
      FE0F800100000000FF0F800100000000FF8F800100000000FFCF800100000000
      FFFF800100000000FFFFE3C700000000C000FFFFEFFFFFFF0000FFFFE7FFFFFF
      0000FFFFE1FFF3FF0000FFFFF0FFF1FF0000FE3FF83FF0FF0000FE1FF81FF07F
      0080E00F0007F03F0000E0070003F01F0020E0070001F01F0000E007803FF03F
      0002E00F801FF07F0000FE1FC01FF0FF07C0FE3FC00FF1FF0780FFFFE007F3FF
      0000FFFFE003FFFF8000FFFFFFFFFFFF87FFFFFFFFFFFFFF03FFFFFFFFFFFFFF
      01FFFFFFFFFFFFFF00FFFF1FF8FFFFFF007FFE1FF87FFE7F803FFC1FF83FFC3F
      C03FF81FF81FF81FE03FF01FF80FF00FF001F01FF80FE007F800F81FF81FC003
      FF00FC1FF83F8001FF00FE1FF87F8001FF08FF1FF8FFC003FF07FFFFFFFFFFFF
      FF07FFFFFFFFFFFFFF87FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7FFE7FFE7FFFF
      FFC3FFC3FFC3FBFFFF83FF83FF83FBBFFF03FF03FF03FB9FC003C003C003FB8F
      800780078007FB81800F800F800FFB8380038003801FFB8780038003801FFB8F
      80038003801FFB9F800F801F801F803F800F801F801FFBFFC01FC01FC01FFBFF
      E07FE07FE07FFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ActionList1: TActionList
    Images = ImageList_NormalTollbar
    Left = 192
    Top = 208
    object ZoomIN: TAction
      Category = 'ZOOM'
      ImageIndex = 0
      OnExecute = ZoomINExecute
    end
    object ZoomOut: TAction
      Category = 'ZOOM'
      ImageIndex = 1
      OnExecute = ZoomOutExecute
    end
    object ZoomActual: TAction
      Category = 'ZOOM'
      ImageIndex = 2
      OnExecute = ZoomActualExecute
    end
    object Trace: TAction
      Category = 'ZOOM'
      ImageIndex = 3
      OnExecute = OnClickTrace
    end
    object Action_Config: TAction
      Caption = #52320#53944#49444#51221
      Checked = True
      ImageIndex = 4
      OnExecute = Action_ConfigExecute
    end
    object Action_OPSPrice: TAction
      Category = 'OMEGA'
      Caption = #50724#47700#44032' '#51201#50857
      ImageIndex = 7
      OnExecute = Action_OPSPriceExecute
    end
    object Action_ShowHideTradeRepot: TAction
      Caption = #49884#48044#47112#51060#49496' '#44208#44284
      ImageIndex = 8
      OnExecute = Action_ShowHideTradeRepotExecute
    end
    object Action_Reset: TAction
      Caption = #52488#44592#49444#51221
      ImageIndex = 10
      OnExecute = Action_ResetExecute
    end
    object Action_SaveReport: TAction
      Category = 'REPORT'
      Caption = #47588#47588#44208#44284' '#51200#51109
      OnExecute = Action_SaveReportExecute
    end
    object Action_SaveTradeList: TAction
      Category = 'REPORT'
      Caption = #44144#47000#45236#50669' '#51200#51109
      OnExecute = Action_SaveTradeListExecute
    end
    object Action_Lock: TAction
      Caption = #46973
      ImageIndex = 9
      OnExecute = Action_LockExecute
    end
    object ActionChangeStandDate: TAction
      Category = 'BackTesting'
      Caption = #44592#51456#51068' '#48320#44221
      ImageIndex = 13
      OnExecute = ActionChangeStandDateExecute
    end
    object ActionNextDate: TAction
      Category = 'BackTesting'
      Caption = #45796#51020' '#45216#51676
      ImageIndex = 11
      OnExecute = ActionNextDateExecute
    end
    object ActionPrevDate: TAction
      Category = 'BackTesting'
      Caption = #51060#51204' '#45216#51676
      ImageIndex = 12
      OnExecute = ActionPrevDateExecute
    end
  end
  object ColorDialog1: TColorDialog
    Left = 152
    Top = 336
  end
  object ImageList2: TImageList
    Left = 456
    Top = 280
    Bitmap = {
      494C01010F001100040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A0A0A000A0A0A000A0A0A000A0A0A000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000E0FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A000A0A0A00000000000000000000000
      00000000000000000000000000000000000000000000A0A0A000A0A0A000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000E0FFA0A0A0FF0000E0FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A000A0A0A00000000000000000000000
      00000000000000000000000000000000000000000000A0A0A000000000000000
      000000000000000000000000000000000000A0A0A000A0A0A000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A0FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A000A0A0A00000000000000000000000
      00000000000000000000000000000000000000000000A0A0A000000000000000
      000000000000000000000000000000000000A0A0A00000000000A0A0A0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A0FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A000A0A0A00000000000000000000000
      00000000000000000000000000000000000000000000A0A0A000A0A0A000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A0000000000000000000A0A0
      A000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A0FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A000A0A0A00000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A0000000
      00000000000000000000000000000000000000000000A0A0A000000000000000
      0000A0A0A0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A0FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A000A0A0A00000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A000000000000000000000000000000000000000000000000000A0A0A0000000
      000000000000A0A0A00000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A0FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A000A0A0A00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A0A0A000000000000000000000000000000000000000000000000000A0A0
      A0000000000000000000A0A0A000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A0FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A000A0A0A00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A0A0A00000000000000000000000000000000000000000000000
      0000A0A0A00000000000A0A0A000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A0FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A000000000000000000000000000A0A0A000A0A0A00000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000000000000000
      00000000000000000000A0A0A000000000000000000000000000000000000000
      000000000000A0A0A000A0A0A000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A0FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A000A0A0A0000000000000000000A0A0A000A0A0A0000000000000000000A0A0
      A000A0A0A0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A000A0A0A000A0A0A000A0A0A000A0A0
      A000A0A0A000A0A0A00000000000000000000000000000000000000000000000
      000000000000000000000000E0FFA0A0A0FF0000E0FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0
      A000A0A0A0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000E0FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000E000A0A0
      A000A0A0A0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0
      A000A0A0A0000000E00000000000000000000000000000000000A0A0A000A0A0
      A000000000000000E0000000000000000000A0A0A00000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000E0E0E0000000
      000000000000000000000000000000000000A0A0A00000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A0000000
      E00000000000A0A0A000A0A0A000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000E0000000000000000000000000000000000000000000A0A0A000A0A0
      A000000000000000E0000000000000000000A0A0A00000000000000000000000
      0000A0A0A000000000000000000000000000000000000000000000000000A0A0
      A0000000000000000000000000000000000000000000A0A0A000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A0000000
      00000000E0000000000000000000A0A0A000A0A0A00000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A0000000
      E000A0A0A000A0A0A00000000000000000000000000000000000A0A0A000A0A0
      A000000000000000E0000000000000000000A0A0A00000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000A0A0A0000000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A000000000000000E000000000000000000000000000A0A0A000A0A0A0000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000E0000000
      0000000000000000000000000000000000000000000000000000A0A0A000A0A0
      A000000000000000E0000000000000000000A0A0A00000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000000000000000
      000000000000A0A0A0000000000000000000000000000000000000000000A0A0
      A00000000000000000000000000000000000000000000000000000000000A0A0
      A00000000000000000000000E00000000000000000000000000000000000A0A0
      A000A0A0A0000000000000000000000000000000000000000000A0A0A000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A0000000E000A0A0A000A0A0
      A000A0A0A000A0A0A00000000000000000000000000000000000A0A0A000A0A0
      A000000000000000E0000000000000000000A0A0A00000000000000000000000
      0000A0A0A00000000000000000000000000000000000000000000000E0000000
      00000000000000000000A0A0A000000000000000000000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000000000000000
      0000A0A0A00000000000000000000000E0000000000000000000000000000000
      000000000000A0A0A00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000E00000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A000A0A0
      A000000000000000E0000000000000000000A0A0A00000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000000000000000
      E000000000000000000000000000A0A0A0000000000000000000000000000000
      000000000000A0A0A00000000000000000000000000000000000000000000000
      0000A0A0A0000000000000000000000000000000E00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000E0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A000A0A0
      A000000000000000E0000000000000000000A0A0A00000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000000000000000
      00000000E000000000000000000000000000A0A0A00000000000000000000000
      0000000000000000000000000000000000000000000000000000E5B0A4000000
      000000000000000000000000000000000000000000000000E000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000E000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A000A0A0
      A000000000000000E0000000000000000000A0A0A00000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000000000000000
      0000000000000000E000000000000000000000000000A0A0A000000000000000
      0000000000000000000000000000000000000000000000000000E5B0A4000000
      00000000000000000000000000000000000000000000000000000000E0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000E00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A000A0A0
      A000000000000000E0000000000000000000A0A0A00000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000000000000000
      000000000000000000000000E000000000000000000000000000A0A0A0000000
      0000000000000000000000000000000000000000000000000000E5B0A400E5B0
      A400E5B0A400E5B0A40000000000000000000000000000000000000000000000
      E000000000000000000000000000000000000000000000000000000000000000
      00000000E0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A000A0A0
      A000000000000000E0000000000000000000A0A0A00000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000E000000000000000000000000000A0A0
      A000000000000000000000000000000000000000000000000000E5B0A4000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000E0000000000000000000000000000000000000000000000000000000
      E000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A000A0A0
      A000000000000000E0000000000000000000A0A0A00000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000E00000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000E5B0A400E5B0
      A400E5B0A400E5B0A40000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000E000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0
      A000A0A0A000A0A0A00000000000000000000000000000000000A0A0A000A0A0
      A000000000000000E0000000000000000000A0A0A00000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000E000000000000000
      000000000000A0A0A00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A0A0A000A0A0A000A0A0A000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A0000000000000000000A0A0A0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000101010001010100010101000101
      0100010101000101010001010100010101000101010001010100010101000101
      0100010101000101010001010100010101000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000E000A0A0
      A000A0A0A0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A0A0A000A0A0A000A0A0A00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A000A0A0A000A0A0A000A0A0A000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A0A0A000A0A0A000000000000000000000000000A0A0A000A0A0A0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A00000000000A0A0A00000000000A0A0A000A0A0A00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000A0A0A0000000
      0000000000000000000000000000000000000000000000000000E5B0A400E5B0
      A400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E5B0A4000000000000000000A0A0A00000000000A0A0A000A0A0A0000000
      0000A0A0A000A0A0A00000000000A0A0A0000000000000000000000000000000
      0000A0A0A00000000000A0A0A0000000000000000000A0A0A000A0A0A0000000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A00000000000000000000000000000000000000000000000000000000000A0A0
      A0000000000000000000000000000000000000000000E5B0A400000000000000
      0000E5B0A4000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E5B0A4000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A0A0A0000000000000000000A0A0A000000000000000000000000000A0A0
      A000A0A0A000000000000000000000000000000000000000000000000000A0A0
      A00000000000000000000000000000000000000000000000000000000000A0A0
      A000000000000000000000000000000000000000000000000000000000000000
      0000E5B0A40000000000A0A0A000A0A0A00000000000A0A0A000A0A0A0000000
      0000A0A0A000A0A0A00000000000A0A0A00000000000E5B0A400E5B0A400E5B0
      A400E5B0A400E5B0A40000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A0A0A0000000000000000000A0A0A00000000000000000000000
      0000000000000000E0000000000000000000000000000000000000000000A0A0
      A00000000000000000000000000000000000000000000000000000000000A0A0
      A000000000000000000000000000000000000000000000000000E5B0A400E5B0
      A400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E5B0A400000000000000
      0000E5B0A4000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E5B0A400E5B0
      A400E5B0A40000000000A0A0A0000000000000000000A0A0A000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000A0A0A0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E5B0A4000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E5B0A4000000
      0000E5B0A4000000000000000000A0A0A00000000000A0A0A000A0A0A0000000
      0000A0A0A000A0A0A00000000000A0A0A0000000000000000000000000000000
      000000000000E5B0A400A0A0A000000000000000000000000000A0A0A0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A0A0A000A0A0A000000000000000000000000000A0A0A000A0A0A0000000
      00000000000000000000000000000000000000000000E5B0A400000000000000
      0000E5B0A4000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E5B0
      A400E5B0A4000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E5B0
      A400E5B0A4000000000000000000A0A0A000000000000000000000000000A0A0
      A000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A0A0A000A0A0A000A0A0A00000000000000000000000
      0000000000000000000000000000000000000000000000000000E5B0A400E5B0
      A400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E5B0A4000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E5B0A4000000
      000000000000000000000000000000000000A0A0A00000000000000000000000
      0000A0A0A0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E5B0
      A400E5B0A400E5B0A4000000000000000000A0A0A00000000000000000000000
      000000000000A0A0A00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A0A0A000A0A0A000A0A0A000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000E7FF0000
      E0FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000E0FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000E0FFA0A0
      A0FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000E0FFA0A0A0FF0000
      E0FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A0A0A0FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A0FF0000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0
      A000000000000000000000000000000000000000000000000000000000000000
      000000000000A0A0A0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      E0FF000000000000000000000000000000000000000000000000A0A0A0FF0000
      00000000E0FF000000000000000000000000000000000000000000000000A0A0
      A00000000000000000000000000000000000000000000000000000000000A0A0
      A000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A0A0A0FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000E0FFA0A0
      A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0
      A0FFA0A0A0FF0000E0FF0000000000000000000000000000000000000000A0A0
      A00000000000000000000000000000000000000000000000000000000000A0A0
      A000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A0A0A0FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      E0FF000000000000000000000000000000000000000000000000000000000000
      00000000E0FF0000000000000000000000000000000000000000000000000000
      E0FF000000000000000000000000000000000000000000000000A0A0A0FF0000
      00000000E0FF000000000000000000000000000000000000000000000000A0A0
      A00000000000000000000000000000000000000000000000000000000000A0A0
      A000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A0A0A0FF00000000000000000000
      00000000000000000000000000000000000000000000000000000000E0FFA0A0
      A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0A0FFA0A0
      A0FFA0A0A0FF0000E0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A0FF0000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A00000000000000000000000000000000000000000000000000000000000A0A0
      A000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A0A0A0FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      E0FF000000000000000000000000000000000000000000000000000000000000
      00000000E0FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A0FF0000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A00000000000000000000000000000000000000000000000000000000000A0A0
      A000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A0FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A0FF0000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A00000000000000000000000000000000000000000000000000000000000A0A0
      A000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A0FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A0A0FF0000
      000000000000000000000000000000000000000000000000000000000000A0A0
      A00000000000000000000000000000000000000000000000000000000000A0A0
      A000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A0A0A0FF0000E0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000E0FFA0A0A0FF0000
      E0FF00000000000000000000000000000000000000000000000000000000A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0
      A000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000E0FF0000E0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000E0FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object ImageList_NormalTollbar: TImageList
    Left = 304
    Top = 272
    Bitmap = {
      494C01010E001000040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009F9F9F00919191009191
      9100919191009191910091919100919191009191910091919100919191009191
      910091919100697A89004A789F00416F96000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000095959500BFBFBF00C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C4C4
      C4008E9EAE005F8DB6008CB1D40045749F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F3D1BB00E9AF
      85000000000000000000000000000000000000000000BCBCBC00EFEFEF00FBFB
      FB00FCFCFC00FCFCFC00FCFCFC00ECE9E600D3C4B800C7AC9400CDAF9600C9A8
      8D00AB998E0096B1CB005A89B500ADBDCD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0CEB500E8A97D00EAAB
      80000000000000000000000000000000000000000000C9C9C900FBFBFB00FBFB
      FB00FBFBFB00FBFBFB00FBFBFB00C7B7A900E2CDBC00F5E0CC00F7E0C700F8E2
      CB00F3D1B300A7998F0094A5B500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000ECC4A600E8B08700EFC8AD00E6A7
      79000000000000000000000000000000000000000000C9C9C900FCFCFC00FBFB
      FB00FBFBFB00FBFBFB00AEAEAE00C9AC9400F3E3D400F4DAC100F3D8BD00F3D8
      BD00F8E3CC00C4A48B00CBCBCB00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E6B38D00E3A47500EDC2A300EEC7A800E2A0
      6E000000000000000000000000000000000000000000C9C9C900FCFCFC00FBFB
      FB00FBFBFB00FBFBFB00AEAEAE00C8A98D00F8EADC00F4DDC600F4DCC400F3D8
      BD00F8E2CD00CCAD9300C7C7C700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DFA47700DD976100E9BB9900E8B79200ECC1A100E197
      62000000000000000000000000000000000000000000C9C9C900FCFCFC00FBFB
      FB00FCFCFC00FCFCFC00AEAEAE00CAAE9500F2E3D500F6E0CA00F5DEC600F5DE
      C500F7E5D200C5AA9400C8C8C800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CC743400D6884B00E4B18A00E3AB8100E3AA8000EABB9900DB8E
      53000000000000000000000000000000000000000000C9C9C900FCFCFC00FCFC
      FC00FCFCFC00CBCBCB00AFAFAF00C1B5A700DDC3AB00F4E6DA00F8ECDF00F2DD
      C900E3C9B200C2B2A400C8C8C800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D78A5E00D37F4300E2AB8100E0A47700E0A37400E7B59000D684
      43000000000000000000000000000000000000000000C9C9C900FCFCFC00FCFC
      FC00FCFCFC00F5F5F500CBCBCB00ECEDED00B6AA9C00BFAE9700C9AB8F00CDAF
      9500BEAB9800F4F7F800C9C9C900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D58B6300D07A3F00E1A97C00DFA17200E4AF8700D277
      35000000000000000000000000000000000000000000C9C9C900FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FBFBFB00000000000000
      0000FFFFFF00FCFCFC00C9C9C900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D38B6500D0773D00E0A67900E1A87E00CD6E
      230000000000000000000000000000000000000000000000DC001313F3003B3B
      E9003333E8002D2DE7002828E3002323E1001E1EDF001B1BDD001717DC001414
      DB001111DC000404ED000000DC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D58C6B00CF743C00DFA37500C962
      1A0000000000000000000000000000000000000000000000DC000F0FEB002828
      BD001C1C98001F1FBC001E1EDD001B1BDF001616DE001212D7000D0DB5000808
      92000606B4000101E6000000DC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D38A6C00CC713B00C459
      180000000000000000000000000000000000000000000000DC000B0BDA00A1A1
      AE00E0E0E0009F9FAE001414CE001212E1000E0EE1000909CC009E9EAE00E0E0
      E0009E9EAE000000D7000000DC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D38C7000C04E
      160000000000000000000000000000000000000000000000DC000707D200C4C4
      D600E3E3E300C4C4D5000303D0000202ED000202ED000101CF00C5C5D600E3E3
      E300C4C4D6000000CF000000DC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000DC000000C700B5B5
      CB00E6E6E600B3B3C9000000C7000000DC000000DC000000C700B8B8CE00E6E6
      E600B6B6CD000000C7000000DC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000A6A6A600BCBCBC0000000000000000000000000000000000C9C9C900AFAF
      AF00C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B9BBBF00878B
      9700999BA200B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9
      B900B8B8B800B9B9B900B9B9B900D0D0D0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D9EC
      F300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F1F1F100E1E1E100454E6A00525E
      7600414B6B00D5D5D500D0D0D000CCCCCC00CACACA00C9C9C900CBCBCB00C9C9
      C900C1C1C100C4C4C400BDBDBD00B9B9B9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006BB7
      D4005AAECE00F5FBFD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EDEDED00C6C6C600BCBDBE00BABC
      BE00424C6C00FCFCFC00FAFAFA00F7F7F700F2F2F200EAEAEA00CDCDCD00E4E4
      E400FFFFFF00FFFFFF00FFFFFF00B9B9B9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F5FB
      FD0051ABCD004FA8CC009DCDE200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C04E1600D38C700000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F1F1F100D6D6D6006D7385007987
      9600444E6E00F9F9F900F9F9F900F5F5F500F0F0F000EBEBEB00F0F0F000C0C0
      C000E1E1E100FAFAFA00FBFBFB00B9B9B9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000072BCD7006DB9D7006BB8D60057ABCE00EBF7FC0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C4591800CC713B00D38A6C00000000000000000000000000000000000000
      000000000000000000000000000000000000EDEDED00C5C5C500BCBCBD00BABC
      BE0044506E00F9F9F900F9F9F900F7F7F700F2F2F200EEEEEE00FAFAFA00EFEF
      EF00C0C0C000E1E1E100FBFBFB00B9B9B9000000000000000000000000000000
      000000000000000000000000000042664C003C604400E2E7E300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000050ACCE009AD1E70072BAD80051A7CC0097CAE000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C9621A00DFA37500CF743C00D58C6B000000000000000000000000000000
      000000000000000000000000000000000000F1F1F100D6D6D6006F7687007C8A
      990046527000F8F8F800F8F8F800F8F8F800F5F5F500F1F1F100F9F9F900F9F9
      F900EFEFEF00BFBFBF00E3E3E300B9B9B9000000000000000000000000000000
      0000000000000000000000000000476D53006A8673004C6D5400DDE3DE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007DC3DB0089CAE10099D0E60094CCE40068B4D40052A8CB00EBF7
      FC00000000000000000000000000000000000000000000000000000000000000
      0000CD6E2300E1A87E00E0A67900D0773D00D38B650000000000000000000000
      000000000000000000000000000000000000EDEDED00C5C5C500BCBCBD00BBBD
      BF0047547100F9F9F900F8F8F800F7F7F70000000000F4F4F400F9F9F900F9F9
      F900F9F9F900EFEFEF00C9C9C900B7B7B700000000000000000000000000587C
      6700527660004F745D004B7058006684710099ADA0006D8976004B6D5300DBE1
      DC000000000000000000000000000000000067C2DB0061BFD90060BCD7005EBA
      D6005BB7D4005AB5D3009CD5E80056B4D9006ABADB0095CCE4006EB6D6004FA5
      CA008DC4DC000000000000000000000000000000000000000000000000000000
      0000D2773500E4AF8700DFA17200E1A97C00D07A3F00D58B6300000000000000
      000000000000000000000000000000000000F1F1F100D6D6D60072798A007E8C
      9A0048567300F9F9F900F7F7F700A28E8100A08C7F009D897C009B887A009B87
      790096827600E6E6E600E9E9E900B9B9B9000000000000000000000000005E80
      6D00A6B8AE00A4B6AB00A1B3A8009FB1A60089A091009AAEA100708C7900496C
      5200D5DCD7000000000000000000000000006EC7DD0091D7E800AAE4F000A8E1
      EF00A4DEED00A1DAEB00A0D9EB009ED5E9009AD1E70095CDE50092CAE30090C7
      E10066B1D2004EA5CA00E0F2FA00000000000000000000000000000000000000
      0000D6844300E7B59000E0A37400E0A47700E2AB8100D37F4300D78A5E000000
      000000000000000000000000000000000000EDEDED00C5C5C500BCBDBE00BCBE
      C00049577400FAFAFA00F9F9F900F7F7F700F7F7F700F7F7F70000000000F0F0
      F000EFEFEF00EDEDED00EBEBEB00BCBCBC000000000000000000000000006485
      7300ABBCB3008EA497008AA29300879F9000839B8C00869E8F009BAEA2006785
      71003F654A00000000000000000000000000D5F3FA0072CAE000AEE7F20071D2
      E7006CCDE40067C8E2005FC0DE009FD7EA0054B1D00056B1D00054AECF0053AC
      CE0050A9CB004FA6CA0057A8CC00000000000000000000000000000000000000
      0000DB8E5300EABB9900E3AA8000E3AB8100E4B18A00D6884B00CC7434000000
      000000000000000000000000000000000000F1F1F100D7D7D700737C8B00808E
      9C004B597600F9F9F900F9F9F900A5928500A38F8300A38F8200A18D80009F8B
      7F009E8A7D00EFEFEF00F4F4F400B9B9B900000000000000000000000000698A
      7900ADBEB500ABBCB300A7B9AF00A7B9AE0091A69900A2B4A9006E8B7900466C
      5400F3F5F4000000000000000000000000000000000069C7DD009BDFED00A6E4
      F0006CD0E70067CBE40061C5E100A2DAEB0076C3DC00B1DCEA00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E1976200ECC1A100E8B79200E9BB9900DD976100DFA47700000000000000
      000000000000000000000000000000000000EDEDED00C5C5C500BCBDBE00BCBE
      C0004C5A7700F8F8F800F8F8F800A5928500BFB3AA00BFB3AA00BFB2A900BEB1
      A800A08D7F00F2F2F20000000000B9B9B9000000000000000000000000006C8C
      7C006B8B7B0068897700638472007C978800A8BAB0007793820051755E00F6F8
      F7000000000000000000000000000000000000000000CCECF4007DD1E400AFE8
      F2006FD3E8006ACEE50065C8E2008BD3E80097D5E8006BBDD800CDE8F1000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E2A06E00EEC7A800EDC2A300E3A47500E6B38D0000000000000000000000
      000000000000000000000000000000000000F2F2F200D7D7D700747C8C008191
      9E004E5D7A00F7F7F700F7F7F700A7958800A5928500A5928500A4918400A390
      8300A38F8200F1F1F100F9F9F900B9B9B9000000000000000000000000000000
      00000000000000000000000000006A8A7800819C8D005C7D6A00F8FAF9000000
      000000000000000000000000000000000000000000000000000067C8DE00ABE7
      F20091DFEE006DD1E70069CCE50064C7E200A1DAEB008BCEE30060B8D500E2F5
      FB00000000000000000000000000000000000000000000000000000000000000
      0000E6A77900EFC8AD00E8B08700ECC4A6000000000000000000000000000000
      000000000000000000000000000000000000EDEDED00C6C6C600BCBDBE00BBBD
      BF004E5E7A000000000000000000000000000000000000000000F3F3F300F3F3
      F300F3F3F300F1F1F100F9F9F900B9B9B9000000000000000000000000000000
      00000000000000000000000000006E8E7E0064857400F9FAF900000000000000
      0000000000000000000000000000000000000000000000000000B1E3EF0085D6
      E700B1E9F40071D5E9006CD0E70068CCE40062C6E200A2DAEB007FC8E00059B6
      D300000000000000000000000000000000000000000000000000000000000000
      0000EAAB8000E8A97D00F0CEB500000000000000000000000000000000000000
      000000000000000000000000000000000000F2F2F200D7D7D70076808F008392
      9F004F607B0000000000000000000000000000000000F3F3F300F2F2F200F1F1
      F100F2F2F200EFEFEF00FAFAFA00B9B9B9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000068C9
      DF00B1EBF400B0E9F300AEE6F200ABE3F000A7E0EF00A4DDED00A1D9EB0075C4
      DD005EB8D5000000000000000000000000000000000000000000000000000000
      0000E9AF8500F3D1BB0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EDEDED00C5C5C500BCBDBE00BCBE
      C00050617C00FBFBFB00FBFBFB00FBFBFB00FBFBFB00FBFBFB00FBFBFB00FCFC
      FC00FBFBFB00FBFBFB00FBFBFB00B9B9B9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009FDE
      EC0066C9DE0065C8DD0064C6DC0062C4DC0061C1DA005FBFD9005DBDD8005BBA
      D60059B8D5006ABED80000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E9E9E9007A8596006675
      8A0052637E00B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9
      B900B9B9B900B9B9B900B9B9B900D0D0D0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008A9FBE00728DB3006E8A
      B20095A8C4000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000097AAC50095A9C400B6C3D500B3C1
      D4008A9FBE0095A8C40000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000859CBC00BCC8D900A9B9CF00A6B6
      CD00B6C3D5008BA0BF0096A9C400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008CA3C000BFCBDB00AEBDD100A2B3
      CB00A7B7CD00B7C4D6008CA2BF0099ABC6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BEC1BA00638E7100638E70000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000517A5E00507A5D00B2BBB1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BECADA00A4B5CC00C0CCDB00B0BE
      D200A4B5CC00A8B7CD00B7C4D6008DA2BF009AACC60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BFC2BB00638E7000A1CDA900638E70000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005E8F6E00A3C4A900517A5E00B0B9B00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008383AC008181AA0000000000000000000000
      00000000000000000000000000000000000000000000BFCBDB00A5B6CD00C1CC
      DB00B0BFD200A4B5CC00ABBAD000B9C6D7008EA3C0009DAEC800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BFC2BB0060866C009CC8A300A0CDA800638E70000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005E8F6E007EA88400A3C4A900517A5E00AFB8AF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008A89AF00AEAEC8009393B6007F7EA400000000000000
      0000000000000000000000000000000000000000000000000000C0CBDB00A6B7
      CD00C3CEDD00B2C0D300AFBED200BCC8D90095A9C40091A4C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BFC3BC0060866C008DB7930094C09C009CC8A3005F906F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005F906F0085B08B007FA98400A7C5AC004C765A00AFB8AE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008686AE00D5D5E2008686B000626298009494B50079789B000000
      000000000000000000000000000000000000000000000000000000000000C1CC
      DB00A7B8CE00C3CEDD00C2CDDC009DAFC8008A9BB5007D7D7D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C4BD00658D72007EA8830084AF8A008DB8940094C09C005F906F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005E8F6E008DB8940085AF8B007FA98400A7C5AC00517A5E00C2C5
      BE00000000000000000000000000000000000000000000000000000000000000
      00008787AF00C9C9DA00D5D5E2007A7AA9006363970066669A009090AE00706F
      9500000000000000000000000000000000000000000000000000000000000000
      0000C2CEDD00A8B8CE00A5B6CD0097A8BE00CACACA00A8A8A8007A7A7A007A7A
      7A007777770088888800BEBEBE00000000000000000000000000000000000000
      0000C1C5BE00517A5E00A7C5AC007FA9840084AF8A008DB894005E8F6E000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005F906F0094C09C008DB8940085AF8B007EA88300658D7200C0C4
      BD00000000000000000000000000000000000000000000000000000000008D8D
      B300B5B5CD00E7E7EE00D0D0DE007575A6006565960066669800656597008989
      A300706F95000000000000000000000000000000000000000000000000000000
      000000000000C3CEDD00A7B6CA0085858500BDBDBD00C3C3C300BDBDBD00BCBC
      BC00B9B9B900B6B6B60079797900BEBEBE000000000000000000000000000000
      000000000000AFB8AE004B765900A7C6AD007EA8830085B08B005F906F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005F906F009CC8A30094C09C008DB7930060876D00BFC2BB000000
      00000000000000000000000000000000000000000000000000009495B800ABAB
      C600E2E2EB00FFFFFF00C3C3D6007070A3006363920064649400666698005C5C
      8B008787A0007171950000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400CCCCCC00BEBEBE00B0B0
      B000AEAEAE00B8B8B800BABABA008A8A8A000000000000000000000000000000
      00000000000000000000B0B9AF00517A5E00A4C4A9007EA884005E8F6E000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000638E7000A1CDA9009CC8A30060876D00BFC2BB00000000000000
      00000000000000000000000000000000000000000000A4A5C200B7B7CE00B1B1
      CA00D6D6E200D1D1E000B2B2CB008686AF0075759A0073739B0074749E007070
      9B005D5D84008989A20078779800000000000000000000000000000000000000
      00000000000000000000000000000000000088888800D6D6D600BBBBBB009D9D
      9D009B9B9B009F9F9F00CFCFCF007A7A7A000000000000000000000000000000
      0000000000000000000000000000B0B9B000507A5D00A3C4A9005E8F6E000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000638E7000A1CDA900638E7000BFC2BB0000000000000000000000
      000000000000000000000000000000000000000000008B8CB300BCBCD200C8C8
      D900D2D2E000DCDCE700D7D7E300C2C2D500A6A6BC00A4A4BB00A4A4BD009D9D
      B7009393AC008585A30067659A00000000000000000000000000000000000000
      0000000000000000000000000000000000008B8B8B00DFDFDF00C6C6C6009F9F
      9F00000000007F7F7F007D7D7D007D7D7D000000000000000000000000000000
      000000000000000000000000000000000000B2BBB100517A5E00517A5E000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000638E7000638E7000BDC0B9000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008E8FB5008D8E
      B4008D8EB4008B8CB2008889B1008586AF008283AC007F7FAA007B7BA7007777
      A4007473A2007271A10000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009E9E9E00DCDCDC00E2E2E200ADAD
      AD00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CCCCCC0091919100DFDFDF00EBEB
      EB00878787000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CCCCCC009F9F9F008F8F
      8F008D8D8D000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D8D8
      D800C8CACC000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D8D8
      D800C8CACC000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D8D8
      D800C8CACC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6D7D7007281
      8D004A5F70008390980000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6D7D7007281
      8C004B6070008390980000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6D6D6007281
      8D004B6070008390980000000000000000000000000000000000000000000000
      000000000000A297950000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6D7D7007B8894007485
      9400A1AFBB0043596A0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6D7D7007B8994007485
      9300A2AFBB0043596A0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6D7D7007B8894007485
      9400A2AFBB0043596A0000000000000000000000000000000000000000000000
      000000000000A297950000000000000000000000000083747200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D7D8D80085919C00808F9D00B1BB
      C60082919F005467770000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D7D8D80085919C00808F9D00B1BC
      C70082919F005467770000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D7D8D80085929D0081909E00B1BB
      C60082919F005467770000000000000000000000000000000000000000000000
      000000000000A297950000000000000000000000000083747200827371000000
      0000000000000000000000000000000000000000000000000000DADAD900BDB5
      AF00ACA09600A29489009E908400A0938900928E8C008D9BA800BCC6CF008E9C
      A90060718100C3C6C90000000000000000000000000000000000DADAD900BDB5
      AF00AB9F9500A29489009E908500A0928800928E8B008D9BA800BCC5CE008E9C
      A90060718100C3C6C90000000000000000000000000000000000DADAD900BDB5
      AE00AB9F9500A29489009E908500A0928800928E8B008D9AA700BCC6CF008E9C
      A90060718100C3C6C90000000000000000000000000000000000000000000000
      000000000000A297960000000000000000000000000083747200C1BAB9008374
      72000000000000000000000000000000000000000000DADAD900BEB5AD00C6BC
      B400DFD9D300E3DDD800E3DDD700DBD4CE00B7ABA20052665200445A46004358
      4800C6C9CC0000000000000000000000000000000000DADAD900BDB4AC00C6BC
      B400DFD9D300E3DDD800E3DDD700DBD4CE00B7ACA300A19891009BA7B3006D7E
      8D00C5C8CB0000000000000000000000000000000000DADAD900BEB5AD00C6BC
      B400DFD9D300E3DED900E2DDD700DBD4CE00B7ACA300A29992009BA7B3006C7D
      8D00C5C8CB000000000000000000000000000000000000000000000000000000
      000000000000A297960000000000000000000000000083747200DAD6D500DAD6
      D5008475730084757300847573000000000000000000CAC4BE00CDC4BD00E6E1
      DC00DCD5CE00D5CDC500D4CCC300D9D1CA00E2DCD700546B560076907F00465C
      48000000000000000000000000000000000000000000CAC4BE00CEC5BD00E6E1
      DC00DCD5CE00D6CEC500D4CCC300D9D1CA00E3DDD800B7ACA3008A878700C8CB
      CD000000000000000000000000000000000000000000CAC4BE00CEC5BD00E6E1
      DC00DCD5CE00D6CEC500D4CBC300D8D1C900E2DCD700B8ADA4008A878700C8CA
      CD00000000000000000000000000000000000000000000000000000000000000
      000000000000A298960000000000000000000000000084757300E6E3E200E5E2
      E200E6E3E20083747200000000000000000000000000C8BEB600E5E0DB00DFD9
      D200D9D1CA00D7D0C800D6CEC500798E7900667F68006F877400829A8B006179
      6600495F4B00465B4800000000000000000000000000C8BEB600E5E0DB00DFD9
      D200D8D1C900D8D0C800D6CEC5008080A7006F6FA000656499005C5B93005553
      8F00504D8C004F4B8B00000000000000000000000000C8BEB600E5E0DB00DED8
      D200D9D1CA00D8D0C800D5CDC500D4CCC300D8D1C900DBD5CF00A1948B000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A398970000000000000000000000000084757300F5F3F300FAF8
      F8008374720000000000000000000000000000000000CCC1B800EAE6E200DDD6
      CF00DAD3CC00D9D2CB00D7D0C80078927B0099B0A40093AA9D008CA49600879F
      9000809888004B614D00000000000000000000000000CCC2B800EAE6E200DDD6
      CF00DAD3CC00D9D2CA00D8D0C9008181AC00A4A9C0009EA3BB009A9EB7009497
      B2008D90AC00504D8C00000000000000000000000000CCC1B800EAE6E200DDD6
      CF00DBD4CD00D9D2CB00D7D0C800D6CFC600D5CDC500E4DED900A29489000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A398970000000000000000000000000084757300FCFAFA008475
      73000000000000000000000000000000000000000000D1C7BE00ECE8E400DFD9
      D200DDD6CF00DCD5CE00D9D2CB0089A28B007B957E00849D8A0098AFA200768E
      7B005C735E005C725F00000000000000000000000000D1C7BE00ECE8E400DED8
      D200DDD6CF00DCD5CE00D9D2CB008B8CB0008181AC007879A6006F6FA0006564
      99005D5B94005A589000000000000000000000000000D1C7BE00ECE8E400DFD9
      D200DDD6CF00DCD5CE00D9D2CB00D9D1CA00D8D0C800E5E0DB00A89A8F000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A398970000000000000000000000000084757300847573000000
      00000000000000000000000000000000000000000000D6CEC500E9E5E100E5E0
      DB00DFD9D200DDD7D000DCD5CE00DAD3CC00DFD9D2007D988000A1B7AD006D87
      70000000000000000000000000000000000000000000D6CEC500EAE5E100E4DF
      DA00DFD9D200DED8D100DCD5CE00DBD4CD00DFD9D200DFDAD400B2A69D000000
      00000000000000000000000000000000000000000000D5CDC500E9E5E100E4DF
      DA00DFD9D200DDD7D000DCD5CE00DBD4CD00DFD9D200E0DAD500B1A69C000000
      00000000000000000000000000000000000000000000A3989700A3989700A398
      9700A3989700A3989700A3989700A2989600A398970084767400000000000000
      00000000000000000000000000000000000000000000D9D4CE00E0DAD300EDE9
      E600E5E0DB00E0DAD400DFD9D200E1DBD600E8E4E0008BA48D007F9A82007B94
      7E000000000000000000000000000000000000000000D9D4CE00E0DAD300EDE9
      E600E5E0DB00E0DAD400DED8D100E1DBD600E8E4E000CCC3BB00C2BAB4000000
      00000000000000000000000000000000000000000000DAD5CF00E0D9D200EDE9
      E600E4DFDA00E0DAD400DFD9D200E1DBD600E8E4E000CCC3BB00C2BBB5000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A298960000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DAD3CC00E1DA
      D300EBE6E200ECE8E500ECE8E500E7E3DE00D2CAC300C4BBB400DADAD9000000
      0000000000000000000000000000000000000000000000000000DAD3CC00E1DA
      D300EBE6E200ECE9E500ECE8E500E7E3DE00D2CAC300C4BBB400DADAD9000000
      0000000000000000000000000000000000000000000000000000D9D2CC00E1DA
      D300EAE6E100ECE8E500ECE8E500E7E3DE00D3CBC300C4BBB400DADAD9000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A398970000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DAD5
      CF00D8D0C700D4CBC200D1C7BE00CEC5BC00D0CAC40000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DAD5
      CF00D9D0C800D4CBC200D1C7BE00CEC5BC00D0CAC40000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DBD6
      D000D8D0C700D4CBC200D1C7BE00CEC5BC00D0CAC40000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF00FFFF800000000000FFFF800000000000
      FFCF800000000000FF8F800100000000FF0F800100000000FE0F800100000000
      FC0F800100000000F80F800100000000F80F800100000000FC0F803100000000
      FE0F800100000000FF0F800100000000FF8F800100000000FFCF800100000000
      FFFF800100000000FFFFE3C700000000C000FFFFEFFFFFFF0000FFFFE3FFFFFF
      0000FFFFE1FFF3FF0000FFFFF07FF1FF0000FE3FF83FF0FF0000FE1FF80FF07F
      0080E00F0007F03F0000E0070001F01F0020E0070001F01F0000E007803FF03F
      0002E00F801FF07F0000FE1FC00FF0FF07C0FE3FC00FF1FF0780FFFFE007F3FF
      0000FFFFE003FFFF8000FFFFFFFFFFFF87FFFFFFFFFFFFFF03FFFFFFFFFFFFFF
      01FFFFFFFFFFFFFF00FFFF1FF8FFFFFF007FFE1FF87FFE7F803FFC1FF83FFC3F
      C03FF81FF81FF81FE03FF01FF80FF00FF001F01FF80FE007F800F81FF81FC003
      FF00FC1FF83F8001FF00FE1FF87F8001FF08FF1FF8FFC003FF07FFFFFFFFFFFF
      FF07FFFFFFFFFFFFFF87FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7FFE7FFE7FFFF
      FFC3FFC3FFC3FBFFFF83FF83FF83FBBFFF03FF03FF03FB9FC003C003C003FB8F
      800780078007FB81800F800F800FFB8380038003801FFB8780038003801FFB8F
      80038003801FFB9F800F801F801F803F800F801F801FFBFFC01FC01FC01FFBFF
      E07FE07FE07FFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ActionList2: TActionList
    Images = ImageList2
    Left = 232
    Top = 338
    object DrawLine: TAction
      ImageIndex = 0
      OnExecute = OnDrawObjectClick
    end
    object DrawVLine: TAction
      ImageIndex = 14
      OnExecute = OnDrawObjectClick
    end
    object DrawHLine: TAction
      ImageIndex = 1
      OnExecute = OnDrawObjectClick
    end
    object DrawCLine: TAction
      ImageIndex = 2
      OnExecute = OnDrawObjectClick
    end
    object DrawRectangle: TAction
      ImageIndex = 3
      OnExecute = OnDrawObjectClick
    end
    object DrawCircle: TAction
      ImageIndex = 4
      OnExecute = OnDrawObjectClick
    end
    object DrawTirone: TAction
      ImageIndex = 5
      OnExecute = OnDrawObjectClick
    end
    object DrawQuadrant: TAction
      ImageIndex = 6
      OnExecute = OnDrawObjectClick
    end
    object DrawSpeedLine: TAction
      ImageIndex = 7
      OnExecute = OnDrawObjectClick
    end
    object DrawFFan: TAction
      ImageIndex = 8
      OnExecute = OnDrawObjectClick
    end
    object DrawFRetracement: TAction
      ImageIndex = 9
      OnExecute = OnDrawObjectClick
    end
    object DrawTimeZone: TAction
      ImageIndex = 10
      OnExecute = OnDrawObjectClick
    end
    object DrawAFP: TAction
      ImageIndex = 11
      OnExecute = OnDrawObjectClick
    end
    object DrawText: TAction
      ImageIndex = 12
      OnExecute = OnDrawObjectClick
    end
    object DrawEraser: TAction
      ImageIndex = 13
      OnExecute = OnDrawObjectClick
    end
    object DrawColor: TAction
      OnExecute = OnDrawObjectClick
    end
  end
  object PopupMenuReport: TPopupMenu
    AutoHotkeys = maManual
    Left = 252
    Top = 598
    object N2: TMenuItem
      Action = Action_SaveTradeList
    end
    object N1: TMenuItem
      Action = Action_SaveReport
    end
  end
  object SaveDialog: TSaveDialog
    Filter = 'csv|*.csv'
    Left = 288
    Top = 208
  end
end
