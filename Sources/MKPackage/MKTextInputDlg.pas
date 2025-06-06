unit MKTextInputDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, ToolWin;

type
  TTextInputDlg = class(TForm)
    m_TextInput: TMemo;
    m_cbbFontColor: TColorBox;
    m_cbFontSize: TComboBox;
    m_btnOk: TButton;
    m_btnCancel: TButton;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    m_btnBold: TButton;
    m_btnItalic: TButton;
    m_btnUnderline: TButton;
    procedure m_cbbFontColorChange(Sender: TObject);
    procedure m_cbFontSizeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure m_btnBoldClick(Sender: TObject);
    procedure m_btnItalicClick(Sender: TObject);
    procedure m_btnUnderlineClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_Font: TFont;
  public
    { Public declarations }
    function GetFontStyle(): TFont;
  end;

var
  TextInputDlg: TTextInputDlg;

implementation

uses
  MKGlobal;

{$R *.dfm}

procedure TTextInputDlg.FormCreate(Sender: TObject);
begin
  m_cbFontSize.Clear;
  m_cbFontSize.Items.Add('9');
  m_cbFontSize.Items.Add('10');
  m_cbFontSize.Items.Add('11');
  m_cbFontSize.Items.Add('12');
  m_cbFontSize.Items.Add('13');
  m_cbFontSize.Items.Add('14');
  m_cbFontSize.Items.Add('15');
  m_cbFontSize.Items.Add('16');
  m_cbFontSize.Items.Add('17');
  m_cbFontSize.Items.Add('18');
  m_cbFontSize.Items.Add('19');
  m_cbFontSize.Items.Add('20');
  m_cbFontSize.Items.Add('25');
  m_cbFontSize.Items.Add('30');
  m_cbFontSize.ItemIndex := 0;

  m_TextInput.Text := '';

  m_TextInput.Font.Color := m_cbbFontColor.Selected;
  m_Font := TFont.Create();

  m_Font.Color := m_cbbFontColor.Selected;
end;

procedure TTextInputDlg.FormDestroy(Sender: TObject);
begin
  m_Font.Free();
end;

procedure TTextInputDlg.m_btnBoldClick(Sender: TObject);
begin
  if (fsBold In m_Font.Style) then
    m_Font.Style := m_Font.Style - [fsBold]
  else
    m_Font.Style := m_Font.Style + [fsBold];

  m_TextInput.Font := m_Font;
end;

procedure TTextInputDlg.m_btnItalicClick(Sender: TObject);
begin
  if (fsItalic In m_Font.Style) then
    m_Font.Style := m_Font.Style - [fsItalic]
  else
    m_Font.Style := m_Font.Style + [fsItalic];

  m_TextInput.Font := m_Font;
end;

procedure TTextInputDlg.m_btnUnderlineClick(Sender: TObject);
begin
  if (fsUnderline In m_Font.Style) then
    m_Font.Style := m_Font.Style - [fsUnderline]
  else
    m_Font.Style := m_Font.Style + [fsUnderline];

  m_TextInput.Font := m_Font;
end;

procedure TTextInputDlg.m_cbbFontColorChange(Sender: TObject);
begin
  m_Font.Color := m_cbbFontColor.Selected;

  m_TextInput.Font := m_Font;
end;

procedure TTextInputDlg.m_cbFontSizeChange(Sender: TObject);
begin
  m_Font.Size := TMKGlobal.atoi(m_cbFontSize.Text);

  m_TextInput.Font := m_Font;
end;

function TTextInputDlg.GetFontStyle(): TFont;
begin
  Result := m_Font;
end;

end.
