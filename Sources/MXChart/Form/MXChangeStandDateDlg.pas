unit MXChangeStandDateDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls;

type
  TChangeStandDateDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    MonthCalendar: TMonthCalendar;
    DateTimePicker1: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure MonthCalendarGetMonthInfo(Sender: TObject; Month: Cardinal;
      var MonthBoldInfo: Cardinal);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure MonthCalendarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChangeStandDateDlg: TChangeStandDateDlg;

implementation

{$R *.dfm}

procedure TChangeStandDateDlg.DateTimePicker1Change(Sender: TObject);
begin
    MonthCalendar.Date := DateTimePicker1.DateTime;
end;

procedure TChangeStandDateDlg.FormCreate(Sender: TObject);
begin
    MonthCalendar.Date := Trunc(Now);
end;

procedure TChangeStandDateDlg.MonthCalendarClick(Sender: TObject);
begin
    DateTimePicker1.DateTime := MonthCalendar.Date;
end;

procedure TChangeStandDateDlg.MonthCalendarGetMonthInfo(Sender: TObject;
  Month: Cardinal; var MonthBoldInfo: Cardinal);
begin
    DateTimePicker1.DateTime := MonthCalendar.Date;
end;

end.
