object LoginDlg: TLoginDlg
  Left = 476
  Top = 347
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 285
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #44404#47548
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PrintScale = poNone
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 243
    Width = 554
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Label6: TLabel
      Left = 18
      Top = 15
      Width = 43
      Height = 12
      Caption = 'Version'
    end
    object LabelVersion: TLabel
      Left = 70
      Top = 15
      Width = 16
      Height = 12
      Caption = '2.0'
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 554
    Height = 243
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 554
      Height = 243
      Align = alClient
      BevelOuter = bvNone
      Padding.Left = 5
      Padding.Top = 5
      Padding.Right = 5
      Padding.Bottom = 5
      TabOrder = 0
      object Panel6: TPanel
        Left = 5
        Top = 5
        Width = 544
        Height = 233
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 544
          Height = 30
          Align = alTop
          Alignment = taLeftJustify
          BevelKind = bkTile
          BevelOuter = bvNone
          Padding.Left = 5
          Padding.Top = 5
          Padding.Right = 5
          Padding.Bottom = 5
          TabOrder = 0
          object LabelWorkName: TLabel
            Left = 5
            Top = 5
            Width = 530
            Height = 16
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = #44404#47548
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitWidth = 5
            ExplicitHeight = 13
          end
        end
        object MemoMessage: TMemo
          Left = 0
          Top = 30
          Width = 544
          Height = 203
          Align = alClient
          BevelKind = bkTile
          BorderStyle = bsNone
          Color = clBtnFace
          ImeName = 'Microsoft Office IME 2007'
          ReadOnly = True
          TabOrder = 1
        end
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 308
    Top = 236
  end
end
