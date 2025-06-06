unit FNSymbolCollection;

interface

uses
  Math, SysUtils, Classes, FNDataSet;

type

  /// /////////////////////////////////////////////////////////////////////////
  // 하나의 지수또는 주식의 고유한 정보를 가지고 있는 클래스이다.
  // 이 프로그램에서는 국가번호, 그룹번호, 거래소번호, 코드의 4개의 키를 이용하여 종목을 분류한다.
  // 어떤 주식또는 지수를 정의 하기 위해서는 이 4개의 키가 있어야 한다.
  /// /////////////////////////////////////////////////////////////////////////
  CFNSymbolItem = class(TObject)
  public
    m_Country: Integer; // 국가번호
    m_Group: Integer; // 그룹번호
    m_Market: Integer; // 거래소번호
    m_Symbol: String; // 종목코드
    m_Name: String; // 종목명

    m_SecSymbol: String;
    m_Contract: String;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clone(p_Source: CFNSymbolItem);
    procedure ArrayToData(p_Record: CFNRecord);
  end;

  /// /////////////////////////////////////////////////////////////////////////
  // CFNSymbolItem를 배열의 구성요소로 가지고 있는 자료구조이다.
  /// /////////////////////////////////////////////////////////////////////////
  CFNSymbolCollection = class(TObject)
  public
    // 각 구성요소를 저장하는 배열
    m_Items: TList;

  public
    constructor Create;
    destructor Destroy; override;

  private

  public
    // 메모리를 해제
    procedure Clear;

    procedure Add(p_SymbolItem: CFNSymbolItem);
    function Search(p_Country: Integer; p_Group: Integer; p_Market: Integer; p_Symbol: String): Integer;
    function Find(p_Country: Integer; p_Group: Integer; p_Market: Integer; p_Symbol: String): CFNSymbolItem;
    procedure Sort;
    procedure Clone(p_Source: CFNSymbolCollection);

    function GetOPSSymbol(AContract: String): String;
  end;

implementation

uses
  FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNSymbolItem.Create;
begin
  inherited Create;

end;

// ---------------------------------------------------------------------------
destructor CFNSymbolItem.Destroy;
begin

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 복제한다.
procedure CFNSymbolItem.Clone(p_Source: CFNSymbolItem);
begin
  if Assigned(p_Source) then
  begin
    m_Country := p_Source.m_Country;
    m_Group := p_Source.m_Group;
    m_Market := p_Source.m_Market;
    m_Symbol := p_Source.m_Symbol;
    m_Name := p_Source.m_Name;
    m_SecSymbol := p_Source.m_SecSymbol;
    m_Contract := p_Source.m_Contract;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNSymbolItem.ArrayToData(p_Record: CFNRecord);
begin
  m_Country := p_Record.GetIntegerValue('COUNTRY_NO');
  m_Group := p_Record.GetIntegerValue('GROUP_NO');
  m_Market := p_Record.GetIntegerValue('MARKET_NO');

  m_Symbol := p_Record.GetStringValue('SYMBOL');
  m_Name := p_Record.GetStringValue('NAME');

  m_SecSymbol := p_Record.GetStringValue('SEC_SYMBOL');
  m_Contract := p_Record.GetStringValue('CONTRACT');
end;

// ---------------------------------------------------------------------------
// 비교함수이다. 여기서는 국가번호, 그룹번호, 거래소번호순으로 오름차순이다.
function CFNSymbolItem_Compare(Item1, Item2: Pointer): Integer;
var
  f_SymbolItem1: CFNSymbolItem;
  f_SymbolItem2: CFNSymbolItem;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_SymbolItem1 := CFNSymbolItem(Item1);
  f_SymbolItem2 := CFNSymbolItem(Item2);

  if (0 = f_Compare) then
    f_Compare := f_SymbolItem1.m_Country - f_SymbolItem2.m_Country;
  if (0 = f_Compare) then
    f_Compare := f_SymbolItem1.m_Group - f_SymbolItem2.m_Group;
  if (0 = f_Compare) then
    f_Compare := f_SymbolItem1.m_Market - f_SymbolItem2.m_Market;
  if (0 = f_Compare) then
    f_Compare := CompareStr(f_SymbolItem1.m_Symbol, f_SymbolItem2.m_Symbol);

  if (0 < f_Compare) then
    Result := 1
  else if (0 > f_Compare) then
    Result := -1
  else
    Result := 0;
end;

// ---------------------------------------------------------------------------
constructor CFNSymbolCollection.Create;
begin
  inherited Create;

  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CFNSymbolCollection.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 배열의 구성요소를 모두 삭제한다.
procedure CFNSymbolCollection.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNSymbolItem(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 하나를 추가한다.
procedure CFNSymbolCollection.Add(p_SymbolItem: CFNSymbolItem);
begin
  m_Items.Add(p_SymbolItem);
end;

// ---------------------------------------------------------------------------
// 해당값을 가지고 있는 요소를 찾아 그 인덱스를 리턴한다.
function CFNSymbolCollection.Search(p_Country, p_Group, p_Market: Integer; p_Symbol: String): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_SymbolItem: CFNSymbolItem;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_SymbolItem := CFNSymbolItem(m_Items.Items[f_PosX]);

      f_Compare := p_Country - f_SymbolItem.m_Country;
      if (0 = f_Compare) then
        f_Compare := p_Group - f_SymbolItem.m_Group;
      if (0 = f_Compare) then
        f_Compare := p_Market - f_SymbolItem.m_Market;
      if (0 = f_Compare) then
        f_Compare := CompareStr(p_Symbol, f_SymbolItem.m_Symbol);
      if (0 > f_Compare) then
        f_PosR := f_PosX - 1
      else
        f_PosL := f_PosX + 1;
    until (not((f_Compare <> 0) and (f_PosL <= f_PosR)));

    if (0 = f_Compare) then
      Result := f_PosX
    else
      Result := -1;
  end
  else
  begin
    Result := -1;
  end;
end;

// ---------------------------------------------------------------------------
// 해당값을 가지고 있는 요소를 찾아 그 객체를 리턴한다.
function CFNSymbolCollection.Find(p_Country, p_Group, p_Market: Integer; p_Symbol: String): CFNSymbolItem;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_SymbolItem: CFNSymbolItem;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_SymbolItem := CFNSymbolItem(m_Items.Items[f_PosX]);
      f_Compare := p_Country - f_SymbolItem.m_Country;
      if (0 = f_Compare) then
        f_Compare := p_Group - f_SymbolItem.m_Group;
      if (0 = f_Compare) then
        f_Compare := p_Market - f_SymbolItem.m_Market;
      if (0 = f_Compare) then
        f_Compare := CompareStr(p_Symbol, f_SymbolItem.m_Symbol);
      if (0 > f_Compare) then
        f_PosR := f_PosX - 1
      else
        f_PosL := f_PosX + 1;
    until (not((f_Compare <> 0) and (f_PosL <= f_PosR)));

    if (0 = f_Compare) then
      Result := f_SymbolItem
    else
      Result := NIL;
  end
  else
  begin
    Result := NIL;
  end;
end;

// ---------------------------------------------------------------------------
function CFNSymbolCollection.GetOPSSymbol(AContract: String): String;
var
  f_Key: String;
begin
  f_Key := Copy(AContract, 1, 2);
  if f_Key = 'ES' then
  begin
    Result := 'CME003_FN';
  end
  else if f_Key = 'NQ' then
  begin
    Result := 'CME004_FN';
  end
  else if f_Key = 'YM' then
  begin
    Result := 'DJIF_FN';
  end
  else if f_Key = '6E' then
  begin
    Result := '6E_FN';
  end
  else if f_Key = '6J' then
  begin
    Result := '6E_FN';
  end
  else if f_Key = '6B' then
  begin
    Result := '6B_FN';
  end
  else if f_Key = '6S' then
  begin
    Result := '6S_FN';
  end
  else if f_Key = 'CL' then
  begin
    Result := 'WTI001_FN';
  end
  else if f_Key = 'GC' then
  begin
    Result := 'WTI004_FN';
  end
  else if f_Key = 'ZN' then
  begin
    Result := 'QUS_FN';
  end
  else
  begin
    Result := '';
  end;
end;

// ---------------------------------------------------------------------------
// 비교함수를 이용하여 정렬한다.
procedure CFNSymbolCollection.Sort;
begin
  m_Items.Sort(@CFNSymbolItem_Compare);
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하여 복제한다.
procedure CFNSymbolCollection.Clone(p_Source: CFNSymbolCollection);
var
  f_OldSymbolItem: CFNSymbolItem;
  f_NewSymbolItem: CFNSymbolItem;
  f_Index: Integer;
begin
  Clear;

  for f_Index := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_OldSymbolItem := CFNSymbolItem(p_Source.m_Items.Items[f_Index]);
    f_NewSymbolItem := CFNSymbolItem.Create;
    f_NewSymbolItem.Clone(f_OldSymbolItem);
    m_Items.Add(f_NewSymbolItem);
  end;
end;

end.
