object AgentDlg: TAgentDlg
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'AgentDlg'
  ClientHeight = 76
  ClientWidth = 94
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object CommOCX1: TCommOCX
    Left = 24
    Top = 8
    Width = 100
    Height = 50
    TabOrder = 0
    ControlData = {04000200560A00002B05000000000000}
  end
  object H5MgrEx1: TH5MgrEx
    Left = 8
    Top = 32
    Width = 100
    Height = 50
    TabOrder = 1
    ControlData = {00000100560A00002B05000000000000}
  end
end
