object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'LavenderSystemD'
  ClientHeight = 61
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #44404#47548
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 292
    Height = 12
    Alignment = taCenter
    AutoSize = False
    Caption = #54532#47196#44536#47016#51012' '#49436#48260#50640#49436' '#45796#50868#48155#50500' '#49892#54665#54633#45768#45796'.'
    WordWrap = True
  end
  object TimerStep: TTimer
    Enabled = False
    OnTimer = TimerStepTimer
    Left = 376
    Top = 40
  end
end
