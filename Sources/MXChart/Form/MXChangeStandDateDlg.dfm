object ChangeStandDateDlg: TChangeStandDateDlg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = #44592#51456#51068#51012' '#48320#44221
  ClientHeight = 249
  ClientWidth = 531
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
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 418
    Top = 44
    Width = 75
    Height = 25
    Cancel = True
    Caption = #52712#49548
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 385
    Height = 225
    Caption = #44592#51456#51068
    TabOrder = 2
    object Panel1: TPanel
      Left = 86
      Top = 21
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
        Date = 41418.712462916660000000
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 0
        OnClick = MonthCalendarClick
        OnGetMonthInfo = MonthCalendarGetMonthInfo
      end
    end
    object DateTimePicker1: TDateTimePicker
      Left = 86
      Top = 190
      Width = 227
      Height = 20
      Date = 41572.718583622690000000
      Time = 41572.718583622690000000
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      TabOrder = 1
      OnChange = DateTimePicker1Change
    end
  end
end
