object ASSLoadDlg: TASSLoadDlg
  Left = 0
  Top = 0
  Caption = #51088#46041#51333#47785#49440#51221#50857' '#44592#52488#45936#51060#53552#47196#46377
  ClientHeight = 57
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #44404#47548
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 0
    Top = 22
    Width = 511
    Height = 12
    Alignment = taCenter
    AutoSize = False
    Caption = #54252#53664#54260#47532#50724' '#51088#46041#54868#50640' '#50640' '#49324#50857#54624' '#44592#48376#51221#48372#47484' '#47196#46377#54633#45768#45796'.'
  end
  object TimerAutoRun: TTimer
    Enabled = False
    OnTimer = TimerAutoRunTimer
    Left = 466
    Top = 14
  end
end
