object SKMXQuotItemFrame: TSKMXQuotItemFrame
  Left = 0
  Top = 0
  Width = 468
  Height = 26
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #44404#47548
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object GP1: TPanel
    Left = 0
    Top = 0
    Width = 468
    Height = 26
    Align = alClient
    BevelOuter = bvNone
    Caption = 'GP1'
    TabOrder = 0
    object P1: TGridPanel
      Left = 0
      Top = 0
      Width = 468
      Height = 26
      Align = alClient
      BevelOuter = bvNone
      Caption = 'P1'
      ColumnCollection = <
        item
          Value = 69.996712150262520000
        end
        item
          Value = 30.003287849737470000
        end>
      ControlCollection = <
        item
          Column = -1
          Row = -1
        end
        item
          Column = -1
          Row = 0
        end
        item
          Column = 0
          Control = P2
          Row = 0
        end
        item
          Column = 1
          Control = P3
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 0
      object P2: TPanel
        Left = 0
        Top = 0
        Width = 265
        Height = 30
        Align = alClient
        BevelOuter = bvNone
        Caption = 'P2'
        Padding.Left = 5
        Padding.Top = 6
        Padding.Right = 5
        TabOrder = 0
        ExplicitWidth = 327
        ExplicitHeight = 26
        object Label_NAME: TLabel
          Left = 5
          Top = 6
          Width = 4
          Height = 12
          Align = alClient
        end
      end
      object P3: TPanel
        Left = 265
        Top = 0
        Width = 115
        Height = 30
        Align = alClient
        BevelOuter = bvNone
        Caption = 'P3'
        Padding.Left = 5
        Padding.Top = 6
        Padding.Right = 5
        TabOrder = 1
        ExplicitLeft = 327
        ExplicitWidth = 141
        ExplicitHeight = 26
        object Label_CLOSEPRICE: TLabel
          Left = 132
          Top = 6
          Width = 4
          Height = 12
          Align = alClient
          Alignment = taRightJustify
        end
      end
    end
  end
end
