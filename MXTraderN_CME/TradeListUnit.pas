unit TradeListUnit;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs;

type
  TTradeListDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Memo1: TMemo;
    Button1: TButton;
    SaveDialog: TSaveDialog;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TradeListDlg: TTradeListDlg;

implementation

{$R *.dfm}

procedure TTradeListDlg.Button1Click(Sender: TObject);
var
    f_ControlIndex:Integer;
    f_Stream:TStringStream;
begin
    if SaveDialog.Execute then
    begin
        if ExtractFileExt(SaveDialog.FileName) = '' then
        begin
            SaveDialog.FileName := SaveDialog.FileName + '.csv';
        end;
        f_Stream := TStringStream.Create('', TEncoding.UTF8, true);

        Memo1.Lines.SaveToStream(f_Stream);
        f_Stream.SaveToFile(SaveDialog.FileName);
        f_Stream.Free;
    end;
end;

end.
