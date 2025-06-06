object ChangeStandDateDlg: TChangeStandDateDlg
  Left = 227
  Top = 108
  ActiveControl = ButtonCalc
  BorderStyle = bsDialog
  Caption = #44592#51456#51068#51012' '#48320#44221
  ClientHeight = 312
  ClientWidth = 541
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #44404#47548
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object OKBtn: TButton
    Left = 418
    Top = 13
    Width = 75
    Height = 25
    Caption = #54869#51064
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 418
    Top = 44
    Width = 75
    Height = 25
    Cancel = True
    Caption = #52712#49548
    ModalResult = 2
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 385
    Height = 287
    Caption = #44592#51456#51068
    TabOrder = 3
    object Label1: TLabel
      Left = 18
      Top = 219
      Width = 140
      Height = 12
      Caption = #51060' '#44050#51012' '#48320#44221#54616#47732' '#46041#49884#50640', '
    end
    object Label2: TLabel
      Left = 18
      Top = 239
      Width = 196
      Height = 12
      Caption = #45236#48512#53580#49828#53944' '#47784#46300#47196' '#51088#46041' '#48320#44221#46121#45768#45796'.'
    end
    object Label3: TLabel
      Left = 18
      Top = 262
      Width = 224
      Height = 12
      Caption = #46384#46972#49436' '#49892#51204' '#47588#47588#51201#50857#49884' '#51452#51032#47484' '#50836#54633#45768#45796'.'
    end
    object Panel1: TPanel
      Left = 86
      Top = 31
      Width = 227
      Height = 157
      BevelKind = bkFlat
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object MonthCalendar: TMonthCalendar
        Left = 0
        Top = 0
        Width = 223
        Height = 153
        Align = alClient
        Date = 41418.012696574070000000
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 0
      end
    end
  end
  object ButtonCalc: TButton
    Left = 418
    Top = 85
    Width = 75
    Height = 25
    Caption = #48148#47196#44228#49328
    Default = True
    ModalResult = 6
    TabOrder = 0
  end
end
