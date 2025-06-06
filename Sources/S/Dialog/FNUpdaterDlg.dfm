object UpdaterDlg: TUpdaterDlg
  Left = 0
  Top = 0
  Anchors = [akLeft, akTop, akRight, akBottom]
  BorderStyle = bsDialog
  Caption = #54532#47196#44536#47016' '#50629#44536#47112#51060#46300
  ClientHeight = 152
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Gulim'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poNone
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 12
  object m_lbTitle: TLabel
    Left = 20
    Top = 21
    Width = 216
    Height = 12
    Caption = #54532#47196#44536#47016#51012' '#49444#52824#47484' '#50948#54644' '#51456#48708#47484' '#54633#45768#45796'. '
  end
  object m_lbStatus: TLabel
    Left = 20
    Top = 41
    Width = 288
    Height = 12
    Caption = #49444#52824#54532#47196#44536#47016#51012' '#47784#46160' '#45796#50868' '#48155#51004#47732' '#49444#52824#47484' '#49884#51089#54633#45768#45796'.'
  end
  object ProgressBar1: TProgressBar
    Left = 20
    Top = 67
    Width = 366
    Height = 24
    TabOrder = 0
  end
  object m_btnRefresh: TButton
    Left = 127
    Top = 109
    Width = 100
    Height = 26
    Caption = #51116#49884#46020
    TabOrder = 1
    OnClick = m_btnRefreshClick
  end
  object m_btnExit: TButton
    Left = 265
    Top = 108
    Width = 100
    Height = 26
    Caption = #45803#44592
    TabOrder = 2
    OnClick = m_btnExitClick
  end
end
