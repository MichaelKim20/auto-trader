object TradeListDlg: TTradeListDlg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = #47588#47588#45236#50669
  ClientHeight = 436
  ClientWidth = 641
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 641
    Height = 396
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 8
    Padding.Top = 8
    Padding.Right = 8
    Padding.Bottom = 8
    TabOrder = 0
    ExplicitHeight = 358
    object Memo1: TMemo
      Left = 8
      Top = 8
      Width = 625
      Height = 380
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ImeName = 'Microsoft Office IME 2007'
      ParentFont = False
      TabOrder = 0
      ExplicitLeft = 6
      ExplicitTop = 6
      ExplicitWidth = 629
      ExplicitHeight = 346
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 396
    Width = 641
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 386
    object Button1: TButton
      Left = 326
      Top = 7
      Width = 75
      Height = 25
      Caption = #51200#51109#54616#44592
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = Button1Click
    end
    object OKBtn: TButton
      Left = 430
      Top = 7
      Width = 75
      Height = 25
      Caption = #54869#51064
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
    object CancelBtn: TButton
      Left = 526
      Top = 7
      Width = 75
      Height = 25
      Cancel = True
      Caption = #52712#49548
      ModalResult = 2
      TabOrder = 2
    end
  end
  object SaveDialog: TSaveDialog
    Filter = 'csv files (*.csv)|*.csv'
    Left = 362
    Top = 304
  end
end
