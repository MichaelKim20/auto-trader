object MatrixSumaryOptionFrame: TMatrixSumaryOptionFrame
  Left = 0
  Top = 0
  Width = 1149
  Height = 655
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object PageControlSummary: TPageControl
    Left = 0
    Top = 0
    Width = 1149
    Height = 655
    ActivePage = TabSheet1
    Align = alClient
    TabHeight = 26
    TabOrder = 0
    TabWidth = 120
    object TabSheet1: TTabSheet
      Caption = #49444#51221
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 1141
        Height = 619
        Align = alClient
        BevelOuter = bvNone
        Padding.Top = 5
        ParentBackground = False
        TabOrder = 0
        object GroupBox13: TGroupBox
          Left = 370
          Top = 15
          Width = 345
          Height = 88
          Caption = #49552#49892#51221#51648
          TabOrder = 0
          object Label62: TLabel
            Left = 20
            Top = 53
            Width = 75
            Height = 17
            Caption = #52572#45824#49552#49892'($) :'
          end
          object CheckBoxUseLossTradeStop: TCheckBox
            Left = 10
            Top = 25
            Width = 79
            Height = 17
            Caption = #49324#50857#50668#48512
            TabOrder = 0
            OnClick = OptionChange
          end
          object EditLossTradeStopValue1: TEdit
            Left = 116
            Top = 49
            Width = 55
            Height = 25
            Alignment = taRightJustify
            ImeName = 'Microsoft Office IME 2007'
            TabOrder = 1
            Text = '-200'
            OnChange = OptionChange
            OnKeyPress = EditKeyPress
          end
        end
        object GroupBox6: TGroupBox
          Left = 15
          Top = 15
          Width = 345
          Height = 90
          Caption = #44228#51340#51221#48372
          TabOrder = 1
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
        object RadioGroupSYSTEM_MODE: TRadioGroup
          Left = 15
          Top = 117
          Width = 345
          Height = 50
          Caption = #49884#49828#53596' '#51452#47928' '#47784#46300
          Columns = 2
          Items.Strings = (
            #45236#48512#53580#49828#53944#47784#46300
            #51613#44428#49324' '#49436#48260)
          TabOrder = 2
          Visible = False
          OnClick = OptionChange
        end
      end
    end
  end
end
