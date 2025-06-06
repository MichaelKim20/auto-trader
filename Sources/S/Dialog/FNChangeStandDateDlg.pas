unit FNChangeStandDateDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls;

type
  TChangeStandDateDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    MonthCalendar: TMonthCalendar;
    ButtonCalc: TButton;
    procedure FormCreate(Sender: TObject);
  private
    procedure ApplyLanguage;
  public
    { Public declarations }
  end;

var
  ChangeStandDateDlg: TChangeStandDateDlg;

implementation

{$R *.dfm}

uses FNCMVariable;

// ---------------------------------------------------------------------------
procedure TChangeStandDateDlg.ApplyLanguage;
begin
  if (g_Language = 0) then
  begin
    Caption := '기준일을 변경';
    GroupBox1.Caption := '기준일';
    OKBtn.Caption := '확인';
    CancelBtn.Caption := '취소';
    ButtonCalc.Caption := '바로계산';
  end
  else if (g_Language = 1) then
  begin
    Caption := 'Changing base date';
    GroupBox1.Caption := 'Base date';
    OKBtn.Caption := 'OK';
    CancelBtn.Caption := 'Cancel';
    ButtonCalc.Caption := 'Calculate';
    Label1.Caption := '';
    Label2.Caption := '';
    Label3.Caption := '';
  end;
end;

procedure TChangeStandDateDlg.FormCreate(Sender: TObject);
begin
  MonthCalendar.Date := Trunc(Now);
  ApplyLanguage;
end;

end.
