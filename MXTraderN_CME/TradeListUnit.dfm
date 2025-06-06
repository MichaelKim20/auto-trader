object TradeListDlg: TTradeListDlg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'TradeList'
  ClientHeight = 436
  ClientWidth = 641
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 625
    Height = 376
    Shape = bsFrame
  end
  object OKBtn: TButton
    Left = 469
    Top = 405
    Width = 75
    Height = 25
    Caption = #54869#51064
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 554
    Top = 405
    Width = 75
    Height = 25
    Cancel = True
    Caption = #52712#49548
    ModalResult = 2
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 625
    Height = 391
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = 'Microsoft Office IME 2007'
    ParentFont = False
    TabOrder = 2
  end
  object Button1: TButton
    Left = 382
    Top = 405
    Width = 75
    Height = 25
    Caption = #51200#51109#54616#44592
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = Button1Click
  end
  object SaveDialog: TSaveDialog
    Filter = 'csv files (*.csv)|*.csv'
    Left = 362
    Top = 304
  end
end
