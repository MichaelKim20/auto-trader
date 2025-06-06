object MatrixChartFrame: TMatrixChartFrame
  Left = 0
  Top = 0
  Width = 1154
  Height = 595
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1154
    Height = 595
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Splitter2: TSplitter
      Left = 0
      Top = 390
      Width = 1154
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      Color = clBtnFace
      MinSize = 120
      ParentColor = False
      OnMoved = Splitter2Moved
      ExplicitTop = 550
      ExplicitWidth = 42
    end
    object Panel2_bottom: TPanel
      Left = 0
      Top = 395
      Width = 1154
      Height = 200
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object PageControl1: TPageControl
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 1154
        Height = 200
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        ActivePage = TabSheet1
        Align = alClient
        DoubleBuffered = True
        MultiLine = True
        ParentDoubleBuffered = False
        TabOrder = 0
        TabStop = False
        TabWidth = 80
        object TabSheet1: TTabSheet
          Caption = #49888#54840#47532#49828#53944
          ImageIndex = -1
          object Panel12: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 1144
            Height = 168
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 2
            Margins.Bottom = 0
            Align = alClient
            BevelKind = bkFlat
            BevelOuter = bvNone
            TabOrder = 0
            object ListViewTradeList: TListView
              Left = 0
              Top = 0
              Width = 1140
              Height = 164
              Align = alClient
              BorderStyle = bsNone
              Columns = <
                item
                  Caption = #54943#49688
                  Width = 60
                end
                item
                  Caption = #50976#54805
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = #51652#51077#44032#44201
                  Width = 100
                end
                item
                  Alignment = taRightJustify
                  Caption = #52397#49328#44032#44201
                  Width = 100
                end
                item
                  Alignment = taRightJustify
                  Caption = #49688#51061
                  Width = 100
                end
                item
                  Alignment = taRightJustify
                  Caption = #45572#51201#49688#51061
                  Width = 100
                end
                item
                  Caption = #51652#51077#49884#44036
                  Width = 100
                end
                item
                  Caption = #52397#49328#49884#44036
                  Width = 100
                end>
              ColumnClick = False
              DoubleBuffered = False
              GridLines = True
              StyleElements = []
              OwnerData = True
              ReadOnly = True
              RowSelect = True
              ParentDoubleBuffered = False
              TabOrder = 0
              ViewStyle = vsReport
              OnCustomDrawItem = ListViewTradeListCustomDrawItem
              OnCustomDrawSubItem = ListViewTradeListCustomDrawSubItem
              OnData = ListViewTradeListData
            end
          end
        end
        object TabSheet2: TTabSheet
          Caption = #49457#45733#48516#49437
          ImageIndex = -1
          object Panel14: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 1144
            Height = 168
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 2
            Margins.Bottom = 0
            Align = alClient
            BevelKind = bkFlat
            BevelOuter = bvNone
            TabOrder = 0
            object ListViewPM: TListView
              Left = 0
              Top = 0
              Width = 1140
              Height = 164
              Align = alClient
              BorderStyle = bsNone
              Columns = <
                item
                  Caption = #49457#45733#48516#49437#47749
                  Width = 140
                end
                item
                  Alignment = taRightJustify
                  Caption = #51204#52404#44144#47000
                  Width = 120
                end
                item
                  Alignment = taRightJustify
                  Caption = #47588#49688#44144#47000
                  Width = 120
                end
                item
                  Alignment = taRightJustify
                  Caption = #47588#46020#44144#47000
                  Width = 120
                end>
              ColumnClick = False
              DoubleBuffered = False
              GridLines = True
              StyleElements = []
              OwnerData = True
              ReadOnly = True
              RowSelect = True
              ParentDoubleBuffered = False
              TabOrder = 0
              ViewStyle = vsReport
              OnCustomDrawItem = ListViewPMCustomDrawItem
              OnCustomDrawSubItem = ListViewPMCustomDrawSubItem
              OnData = ListViewPMData
            end
          end
        end
        object TabSheet4: TTabSheet
          Caption = #51340#54364#51221#48372
          ImageIndex = 3
          object Panel13: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 1144
            Height = 168
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 2
            Margins.Bottom = 0
            Align = alClient
            BevelKind = bkFlat
            BevelOuter = bvNone
            TabOrder = 0
            object ListViewValues: TListView
              Left = 0
              Top = 0
              Width = 1140
              Height = 164
              Align = alClient
              BorderStyle = bsNone
              Columns = <
                item
                  Caption = #49884#44036
                  Width = 90
                end
                item
                  Caption = #49884#49828#53596
                  Width = 90
                end
                item
                  Caption = #49888#54840
                  Width = 90
                end
                item
                  Alignment = taRightJustify
                  Caption = #44032#44201
                  Width = 90
                end
                item
                  Alignment = taRightJustify
                  Caption = #44144#47000#47049
                  Width = 90
                end>
              ColumnClick = False
              DoubleBuffered = False
              GridLines = True
              StyleElements = []
              OwnerData = True
              ReadOnly = True
              RowSelect = True
              ParentDoubleBuffered = False
              TabOrder = 0
              TabStop = False
              ViewStyle = vsReport
              OnCustomDrawItem = ListViewValuesCustomDrawItem
              OnCustomDrawSubItem = ListViewValuesCustomDrawSubItem
              OnData = ListViewValuesData
            end
          end
        end
      end
    end
    object Panel1_top: TPanel
      Left = 0
      Top = 0
      Width = 1154
      Height = 390
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Panel2_grid: TPanel
        Left = 0
        Top = 0
        Width = 1154
        Height = 26
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object GridPanel1: TGridPanel
          Left = 0
          Top = 0
          Width = 1154
          Height = 26
          Align = alClient
          BevelOuter = bvNone
          ColumnCollection = <
            item
              Value = 9.999999775966220000
            end
            item
              Value = 9.999999775966222000
            end
            item
              Value = 9.999999775966222000
            end
            item
              Value = 9.999999775966225000
            end
            item
              Value = 9.999999775966227000
            end
            item
              Value = 9.999999775966227000
            end
            item
              Value = 9.999999775966234000
            end
            item
              Value = 9.999999775966236000
            end
            item
              Value = 9.999999989105138000
            end
            item
              Value = 10.000001803165060000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = Panel6
              Row = 0
            end
            item
              Column = 1
              Control = QDate
              Row = 0
            end
            item
              Column = 2
              Control = Panel8
              Row = 0
            end
            item
              Column = 3
              Control = QTime
              Row = 0
            end
            item
              Column = 4
              Control = Panel11
              Row = 0
            end
            item
              Column = 5
              Control = QLastPrice
              Row = 0
            end
            item
              Column = 6
              Control = Panel7
              Row = 0
            end
            item
              Column = 7
              Control = QSignal
              Row = 0
            end
            item
              Column = 8
              Control = Panel9
              Row = 0
            end
            item
              Column = 9
              Control = QTotalProfit
              Row = 0
            end>
          RowCollection = <
            item
              Value = 100.000000000000000000
            end>
          TabOrder = 0
          object Panel6: TPanel
            Left = 0
            Top = 0
            Width = 115
            Height = 26
            Align = alClient
            BevelKind = bkFlat
            BevelOuter = bvNone
            Caption = #45216#51676
            Ctl3D = True
            ParentBackground = False
            ParentCtl3D = False
            TabOrder = 0
          end
          object QDate: TPanel
            Left = 115
            Top = 0
            Width = 115
            Height = 26
            Align = alClient
            Alignment = taRightJustify
            BevelKind = bkFlat
            BevelOuter = bvNone
            Color = clWindow
            Ctl3D = True
            ParentBackground = False
            ParentCtl3D = False
            TabOrder = 1
            StyleElements = [seClient, seBorder]
          end
          object Panel8: TPanel
            Left = 230
            Top = 0
            Width = 115
            Height = 26
            Align = alClient
            BevelKind = bkFlat
            BevelOuter = bvNone
            Caption = #49884#44036
            Ctl3D = True
            ParentBackground = False
            ParentCtl3D = False
            TabOrder = 2
          end
          object QTime: TPanel
            Left = 345
            Top = 0
            Width = 115
            Height = 26
            Align = alClient
            Alignment = taRightJustify
            BevelKind = bkFlat
            BevelOuter = bvNone
            Color = clWindow
            Ctl3D = True
            ParentBackground = False
            ParentCtl3D = False
            TabOrder = 3
            StyleElements = [seClient, seBorder]
          end
          object Panel11: TPanel
            Left = 460
            Top = 0
            Width = 115
            Height = 26
            Align = alClient
            BevelKind = bkFlat
            BevelOuter = bvNone
            Caption = #49884#49464
            Ctl3D = True
            ParentBackground = False
            ParentCtl3D = False
            TabOrder = 4
          end
          object QLastPrice: TPanel
            Left = 575
            Top = 0
            Width = 115
            Height = 26
            Align = alClient
            Alignment = taRightJustify
            BevelKind = bkFlat
            BevelOuter = bvNone
            Color = clWindow
            Ctl3D = True
            ParentBackground = False
            ParentCtl3D = False
            TabOrder = 5
            StyleElements = [seClient, seBorder]
          end
          object Panel7: TPanel
            Left = 690
            Top = 0
            Width = 115
            Height = 26
            Align = alClient
            BevelKind = bkFlat
            BevelOuter = bvNone
            Caption = #49888#54840#49345#53468
            Ctl3D = True
            ParentBackground = False
            ParentCtl3D = False
            TabOrder = 6
          end
          object QSignal: TPanel
            Left = 805
            Top = 0
            Width = 115
            Height = 26
            Align = alClient
            Alignment = taRightJustify
            BevelKind = bkFlat
            BevelOuter = bvNone
            Color = clWindow
            Ctl3D = True
            ParentBackground = False
            ParentCtl3D = False
            TabOrder = 7
            StyleElements = [seClient, seBorder]
          end
          object Panel9: TPanel
            Left = 920
            Top = 0
            Width = 115
            Height = 26
            Align = alClient
            BevelKind = bkFlat
            BevelOuter = bvNone
            Caption = ' '#45572#51201#49688#51061
            Ctl3D = True
            ParentBackground = False
            ParentCtl3D = False
            TabOrder = 8
          end
          object QTotalProfit: TPanel
            Left = 1035
            Top = 0
            Width = 119
            Height = 26
            Align = alClient
            Alignment = taRightJustify
            BevelKind = bkFlat
            BevelOuter = bvNone
            Color = clWindow
            Ctl3D = True
            ParentBackground = False
            ParentCtl3D = False
            TabOrder = 9
            StyleElements = [seClient, seBorder]
          end
        end
      end
      object Panel3_chart: TPanel
        Left = 0
        Top = 26
        Width = 1154
        Height = 364
        Align = alClient
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 1
        object ScrollBar1: TScrollBar
          Left = 0
          Top = 347
          Width = 1154
          Height = 17
          Align = alBottom
          Ctl3D = False
          LargeChange = 30
          PageSize = 0
          ParentCtl3D = False
          TabOrder = 0
          TabStop = False
        end
        object Panel10: TPanel
          Left = 0
          Top = 0
          Width = 1154
          Height = 347
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          BevelKind = bkTile
          BevelOuter = bvNone
          TabOrder = 1
          object MergeChartControl: CFNMatrixMergeChartControl
            Left = 0
            Top = 0
            Width = 1150
            Height = 343
            Align = alClient
            Bitmap.ResamplerClassName = 'TNearestResampler'
            BitmapAlign = baCustom
            RepaintMode = rmOptimizer
            Scale = 1.000000000000000000
            ScaleMode = smScale
            ScrollBars.ShowHandleGrip = True
            ScrollBars.Style = rbsDefault
            ScrollBars.Size = 17
            ScrollBars.Visibility = svHidden
            OverSize = 0
            TabOrder = 0
            OnChartTraceChange = MergeChartControlChartTraceChange
            OnClickPos = MergeChartControlClickPos
            ScrollBar = ScrollBar1
            LightVersion = False
          end
        end
      end
    end
  end
end
