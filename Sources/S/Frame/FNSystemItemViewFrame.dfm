object SystemItemViewFrame: TSystemItemViewFrame
  Left = 0
  Top = 0
  Width = 754
  Height = 384
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 754
    Height = 384
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 1
    ParentBackground = False
    TabOrder = 0
    object GridPanel1: TGridPanel
      AlignWithMargins = True
      Left = 1
      Top = 1
      Width = 752
      Height = 24
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      ColumnCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 50.000000000000000000
        end
        item
          Value = 33.333333333333340000
        end
        item
          SizeStyle = ssAbsolute
          Value = 50.000000000000000000
        end
        item
          Value = 33.333333333333340000
        end
        item
          SizeStyle = ssAbsolute
          Value = 50.000000000000000000
        end
        item
          Value = 33.333333333333310000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = Panel1
          Row = 0
        end
        item
          Column = 1
          Control = QSymbol
          Row = 0
        end
        item
          Column = 2
          Control = Panel10
          Row = 0
        end
        item
          Column = 3
          Control = QSignal
          Row = 0
        end
        item
          Column = 4
          Control = Panel5
          Row = 0
        end
        item
          Column = 5
          Control = QTotalProfit
          Row = 0
        end>
      ExpandStyle = emFixedSize
      Locked = True
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 50
        Height = 24
        Align = alClient
        BevelEdges = [beLeft, beTop, beBottom]
        BevelKind = bkFlat
        BevelOuter = bvNone
        Caption = #51333#47785
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
      end
      object QSymbol: TPanel
        Left = 50
        Top = 0
        Width = 200
        Height = 24
        Align = alClient
        Alignment = taRightJustify
        BevelEdges = [beLeft, beTop, beBottom]
        BevelKind = bkFlat
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 1
        StyleElements = [seClient, seBorder]
      end
      object Panel10: TPanel
        Left = 250
        Top = 0
        Width = 50
        Height = 24
        Align = alClient
        BevelEdges = [beLeft, beTop, beBottom]
        BevelKind = bkFlat
        BevelOuter = bvNone
        Caption = #49888#54840
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 2
      end
      object QSignal: TPanel
        Left = 300
        Top = 0
        Width = 200
        Height = 24
        Align = alClient
        Alignment = taRightJustify
        BevelEdges = [beLeft, beTop, beBottom]
        BevelKind = bkFlat
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 3
        StyleElements = [seClient, seBorder]
      end
      object Panel5: TPanel
        Left = 500
        Top = 0
        Width = 50
        Height = 24
        Align = alClient
        BevelEdges = [beLeft, beTop, beBottom]
        BevelKind = bkFlat
        BevelOuter = bvNone
        Caption = #49688#51061
        TabOrder = 4
      end
      object QTotalProfit: TPanel
        Left = 550
        Top = 0
        Width = 202
        Height = 24
        Align = alClient
        Alignment = taRightJustify
        BevelKind = bkFlat
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 5
        StyleElements = [seClient, seBorder]
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 25
      Width = 752
      Height = 358
      Align = alClient
      BevelEdges = [beLeft, beRight, beBottom]
      BevelOuter = bvNone
      Padding.Top = 2
      ParentBackground = False
      TabOrder = 1
      object PageControl1: TPageControl
        AlignWithMargins = True
        Left = 0
        Top = 3
        Width = 752
        Height = 355
        Margins.Left = 0
        Margins.Top = 1
        Margins.Right = 0
        Margins.Bottom = 0
        ActivePage = TabSheet1
        Align = alClient
        TabHeight = 26
        TabOrder = 0
        TabWidth = 80
        object TabSheet1: TTabSheet
          Caption = #52264#53944
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Panel7: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 742
            Height = 319
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 2
            Margins.Bottom = 0
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object ScrollBar1: TScrollBar
              Left = 0
              Top = 302
              Width = 742
              Height = 17
              Align = alBottom
              LargeChange = 30
              PageSize = 0
              TabOrder = 0
              TabStop = False
            end
            object m_ChartControl: CFNMatrixChartControl
              Left = 0
              Top = 0
              Width = 742
              Height = 302
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
              TabOrder = 1
              ScrollBar = ScrollBar1
            end
          end
        end
        object TabSheet2: TTabSheet
          Caption = #49457#45733#48516#49437
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Panel8: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 742
            Height = 319
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
              Width = 738
              Height = 315
              Align = alClient
              BorderStyle = bsNone
              Columns = <
                item
                  Caption = #54596#46300#47749
                  Width = 150
                end
                item
                  Alignment = taRightJustify
                  Caption = #51204#52404#44144#47000
                  Width = 80
                end
                item
                  Alignment = taRightJustify
                  Caption = #47588#49688#44144#47000
                  Width = 80
                end
                item
                  Alignment = taRightJustify
                  Caption = #47588#46020#44144#47000
                  Width = 80
                end>
              ColumnClick = False
              DoubleBuffered = True
              GridLines = True
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
        object TabSheet3: TTabSheet
          Caption = #44144#47000#47532#49828#53944
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Panel11: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 742
            Height = 319
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
              Width = 738
              Height = 315
              Align = alClient
              BorderStyle = bsNone
              Columns = <
                item
                  Caption = #54943#49688
                end
                item
                  Caption = #50976#54805
                end
                item
                  Alignment = taRightJustify
                  Caption = #51652#51077#44032
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = #52397#49328#44032
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = #49688#51061
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = #45572#51201#49688#51061
                  Width = 60
                end
                item
                  Caption = #51652#51077#49884#44036
                  Width = 70
                end
                item
                  Caption = #52397#49328#49884#44036
                  Width = 70
                end>
              ColumnClick = False
              DoubleBuffered = True
              GridLines = True
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
        object TabSheet4: TTabSheet
          Caption = #51340#54364#51221#48372
          ImageIndex = 3
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Panel13: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 742
            Height = 319
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
              Width = 738
              Height = 315
              Align = alClient
              BorderStyle = bsNone
              Columns = <
                item
                  Caption = #49884#44036
                  Width = 0
                end
                item
                  Caption = #49888#54840
                  Width = 80
                end
                item
                  Caption = #49440#47932
                  Width = 80
                end
                item
                  Caption = 'MATRIX'
                  Width = 80
                end
                item
                  Alignment = taRightJustify
                  Caption = #44144#47000#47049
                  Width = 70
                end
                item
                  Alignment = taRightJustify
                  Caption = #45572#51201#49688#51061
                  Width = 80
                end>
              ColumnClick = False
              DoubleBuffered = True
              GridLines = True
              OwnerData = True
              ReadOnly = True
              RowSelect = True
              ParentDoubleBuffered = False
              TabOrder = 0
              ViewStyle = vsReport
              OnCustomDrawItem = ListViewValuesCustomDrawItem
              OnCustomDrawSubItem = ListViewValuesCustomDrawSubItem
              OnData = ListViewValuesData
            end
          end
        end
      end
    end
  end
end
