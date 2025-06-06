object ReLoginDlg: TReLoginDlg
  Left = 476
  Top = 347
  BorderIcons = []
  BorderStyle = bsDialog
  ClientHeight = 65
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PrintScale = poNone
  OnClose = FormClose
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object Label1: TLabel
    Left = 140
    Top = 24
    Width = 130
    Height = 17
    Caption = #51116#51217#49549#51012' '#49884#46020' '#54633#45768#45796'.'
  end
  object TimerAutoRun: TTimer
    Enabled = False
    OnTimer = TimerAutoRunTimer
    Left = 328
    Top = 16
  end
end
