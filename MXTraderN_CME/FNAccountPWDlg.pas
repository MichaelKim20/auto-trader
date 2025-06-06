unit FNAccountPWDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TAccountPWDlg = class(TForm)
    Label2: TLabel;
    Password: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    LabelACCOUNT_NO: TLabel;
    ComboBoxACCOUNT_NO: TComboBox;
    LabelACCOUNT_NAME: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxACCOUNT_NOChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AccountPWDlg: TAccountPWDlg;

implementation

{$R *.dfm}

uses FNCMVariable, MXVariable, FNAccountData, FNAccountArray, FNSymbolCollection;

procedure TAccountPWDlg.ComboBoxACCOUNT_NOChange(Sender: TObject);
begin
    {$REGION '계좌정보'}
    if ComboBoxACCOUNT_NO.Items.Count > 0 then
    begin
        if (ComboBoxACCOUNT_NO.ItemIndex >= 0) and (ComboBoxACCOUNT_NO.ItemIndex < g_AccountArray.m_Items.Count) then
        begin
            LabelACCOUNT_NAME.Caption := CFNAccountData(g_AccountArray.m_Items[ComboBoxACCOUNT_NO.ItemIndex]).m_AccountName;
        end;

    end;
    {$ENDREGION}
end;

procedure TAccountPWDlg.FormCreate(Sender: TObject);
var
    LSymbolItem : CFNSymbolItem;
    LAccountData : CFNAccountData;
    LIndex : Integer;
begin

    {$REGION '계좌번호의 콤보박스를 설정한다 '}
    ComboBoxACCOUNT_NO.Clear;
    for LIndex := 0 to g_AccountArray.m_Items.Count-1 do
    begin
        LAccountData := CFNAccountData(g_AccountArray.m_Items[LIndex]);
        ComboBoxACCOUNT_NO.AddItem(LAccountData.m_AccountNo, LAccountData);
    end;

    if g_AccountArray.m_Items.Count > 0 then
    begin
        ComboBoxACCOUNT_NO.ItemIndex := 0;
        LabelACCOUNT_NAME.Caption := CFNAccountData(g_AccountArray.m_Items[0]).m_AccountName;
    end;
    {$ENDREGION}

end;

end.
