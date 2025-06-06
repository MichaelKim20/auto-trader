unit SKMXChildFrame01;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ComCtrls, ToolWin, ExtCtrls, QuotItemUnit,
    FNSymbolCollection, FNTickerItem;

type
  TSKMXFrame01 = class(TFrame)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel4: TPanel;
    CheckBox0: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox1: TCheckBox;
    Panel5: TPanel;
    ComboBox_TimeFrame: TComboBox;
    CFNTickerItem1: CFNTickerItem;
    GridPanel1: TGridPanel;
    Panel6: TPanel;
    CFNTickerItem2: CFNTickerItem;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure CheckBox1Click(Sender: TObject);
  private
    m_SymbolCollection : CFNSymbolCollection;
    m_SubSymbolIndex : Integer;
    m_EventEnable:Boolean;
    m_MainSymbolItem : CFNSymbolItem;

    procedure UpdateSubSymbolCheckBox;
    procedure ApplyMainSymbol;
    procedure ApplySubSymbol;

  public
    procedure OnFormCreate;
    procedure OnFormClose;
    procedure OnFormActivate;

  end;

implementation

uses
    FNCMVariable;


{$R *.dfm}

//-------------------------------------------------------------------------------------------------
procedure TSKMXFrame01.OnFormCreate;
var
    f_SymbolItem : CFNSymbolItem;
begin
    m_MainSymbolItem    := CFNSymbolItem.Create;
    m_SymbolCollection  := CFNSymbolCollection.Create;

    f_SymbolItem := CFNSymbolItem.Create;
    f_SymbolItem.m_Country := 0;
    f_SymbolItem.m_Group   := 6;
    f_SymbolItem.m_Market  := 0;
    f_SymbolItem.m_Symbol  := 'KS11_WI';
    f_SymbolItem.m_Name    := 'SK Q 코스피';
    m_SymbolCollection.Add(f_SymbolItem);

    f_SymbolItem := CFNSymbolItem.Create;
    f_SymbolItem.m_Country := 12;
    f_SymbolItem.m_Group   := 6;
    f_SymbolItem.m_Market  := 0;
    f_SymbolItem.m_Symbol  := 'HSI_WI';
    f_SymbolItem.m_Name    := 'SK Q 항셍';
    m_SymbolCollection.Add(f_SymbolItem);

    f_SymbolItem := CFNSymbolItem.Create;
    f_SymbolItem.m_Country := 10;
    f_SymbolItem.m_Group   := 6;
    f_SymbolItem.m_Market  := 0;
    f_SymbolItem.m_Symbol  := 'N225_WI';
    f_SymbolItem.m_Name    := 'SK Q 니케이';
    m_SymbolCollection.Add(f_SymbolItem);

    f_SymbolItem := CFNSymbolItem.Create;
    f_SymbolItem.m_Country := 11;
    f_SymbolItem.m_Group   := 6;
    f_SymbolItem.m_Market  := 0;
    f_SymbolItem.m_Symbol  := 'CSI300_WI';
    f_SymbolItem.m_Name    := 'SK Q 상해';
    m_SymbolCollection.Add(f_SymbolItem);


    m_SubSymbolIndex := 0;
    m_EventEnable := true;

    CFNTickerItem1.SocketManager := g_SocketManager;
    CFNTickerItem2.SocketManager := g_SocketManager;

    UpdateSubSymbolCheckBox;
    ApplyMainSymbol;
    ApplySubSymbol;
end;

//-------------------------------------------------------------------------------------------------
procedure TSKMXFrame01.OnFormClose;
begin
    m_SymbolCollection.Free;
end;

//-------------------------------------------------------------------------------------------------
procedure TSKMXFrame01.OnFormActivate;
begin
end;

//-------------------------------------------------------------------------------------------------
procedure TSKMXFrame01.UpdateSubSymbolCheckBox;
begin
    m_EventEnable := false;
    if m_SubSymbolIndex = 0 then
    begin
        CheckBox0.Checked := true;
        CheckBox1.Checked := false;
        CheckBox2.Checked := false;
        CheckBox3.Checked := false;
    end else
    if m_SubSymbolIndex = 1 then
    begin
        CheckBox0.Checked := false;
        CheckBox1.Checked := true;
        CheckBox2.Checked := false;
        CheckBox3.Checked := false;
    end else
    if m_SubSymbolIndex = 2 then
    begin
        CheckBox0.Checked := false;
        CheckBox1.Checked := false;
        CheckBox2.Checked := true;
        CheckBox3.Checked := false;
    end else
    begin
        CheckBox0.Checked := false;
        CheckBox1.Checked := false;
        CheckBox2.Checked := false;
        CheckBox3.Checked := true;
    end;
    m_EventEnable := true;
end;


//-------------------------------------------------------------------------------------------------
procedure TSKMXFrame01.CheckBox1Click(Sender: TObject);
begin
    if not m_EventEnable then exit;
    m_SubSymbolIndex :=  TCheckBox(Sender).Tag;

    UpdateSubSymbolCheckBox;

    ApplySubSymbol;
end;

//-------------------------------------------------------------------------------------------------
procedure TSKMXFrame01.ApplyMainSymbol;
begin
    m_MainSymbolItem.m_Country := 0;
    m_MainSymbolItem.m_Group   := 4;
    m_MainSymbolItem.m_Market  := 0;
    m_MainSymbolItem.m_Symbol  := 'KS1012_WI';
    m_MainSymbolItem.m_Name    := '코스피선물';

    CFNTickerItem2.SetSymbolItem(m_MainSymbolItem);
end;

//-------------------------------------------------------------------------------------------------
procedure TSKMXFrame01.ApplySubSymbol;
var
    f_SymbolItem : CFNSymbolItem;
begin
    f_SymbolItem := m_SymbolCollection.m_Items[m_SubSymbolIndex];

    CFNTickerItem1.SetSymbolItem(f_SymbolItem);
end;

//-------------------------------------------------------------------------------------------------
end.


