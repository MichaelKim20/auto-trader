unit FNQuotArray;

interface

uses
  Math, Windows, SysUtils, Classes, FNQuotData;

const
  QUOTTYPE_REAL = 0;
  QUOTTYPE_VIRTUAL = 1;

type
  CFNQuotArray = class(TObject)
  public
    m_Items: TList; // 각 구성요소를 저장하는 배열
    m_Type: Integer;

  public
    constructor Create;
    destructor Destroy; override;

  public
    procedure Clear;
    procedure Clone(p_Source: CFNQuotArray);
    procedure CloneVirtual(p_Source: CFNQuotArray);
    // 아이템을 추가해준다.
    procedure Add(p_QuotData: CFNQuotData);

    // 각 속성에 따라 소팅하는 소팅함수
    procedure SortByDateTime;
    procedure SortBySymbol;
    procedure SortByName;
    procedure SortByOpenPrice; // 시가
    procedure SortByHighPrice; // 고가
    procedure SortByLowPrice; // 저가
    procedure SortByClosePrice; // 종가(현재가)
    procedure SortByTotalVolume; // 체결량
    procedure SortByOfferPrice; // 매도 호가
    procedure SortByBidPrice; // 매수 호가
    procedure SortByOfferVolume; // 매도 잔량
    procedure SortByBidVolume; // 매수 잔량
    procedure SortByChangeRate;
    // 서치함수 특정된 CFNQuotData를 m_Items에서 찾아준다.
    function Search(p_Country, p_Group, p_Market: Integer; p_Symbol: String): Integer;

  end;

implementation

uses FNGlobal;

// ---------------------------------------------------------------------------
function QuotData_CompareByDateTime(Item1, Item2: Pointer): Integer;
var
  f_QuotData1: CFNQuotData;
  f_QuotData2: CFNQuotData;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_QuotData1 := CFNQuotData(Item1);
  f_QuotData2 := CFNQuotData(Item2);

  if (f_QuotData1.m_DateTime < f_QuotData2.m_DateTime) then
  begin
    f_Compare := -1;
  end
  else if (f_QuotData1.m_DateTime > f_QuotData2.m_DateTime) then
  begin
    f_Compare := 1;
  end
  else
  begin
    f_Compare := 0;
  end;

  Result := f_Compare;
end;

// ---------------------------------------------------------------------------
function QuotData_CompareBySymbol(Item1, Item2: Pointer): Integer;
var
  f_QuotData1: CFNQuotData;
  f_QuotData2: CFNQuotData;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_QuotData1 := CFNQuotData(Item1);
  f_QuotData2 := CFNQuotData(Item2);

  if (0 = f_Compare) then
    f_Compare := f_QuotData1.m_Country - f_QuotData2.m_Country;

  if (0 = f_Compare) then
    f_Compare := f_QuotData1.m_Group - f_QuotData2.m_Group;

  if (0 = f_Compare) then
    f_Compare := f_QuotData1.m_Market - f_QuotData2.m_Market;

  if (0 = f_Compare) then
    f_Compare := AnsiCompareStr(f_QuotData1.m_Symbol, f_QuotData2.m_Symbol);

  Result := f_Compare;
end;

// ---------------------------------------------------------------------------
function QuotData_CompareByName(Item1, Item2: Pointer): Integer;
var
  f_QuotData1: CFNQuotData;
  f_QuotData2: CFNQuotData;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_QuotData1 := CFNQuotData(Item1);
  f_QuotData2 := CFNQuotData(Item2);

  if (0 = f_Compare) then
    f_Compare := f_QuotData1.m_Country - f_QuotData2.m_Country;

  if (0 = f_Compare) then
    f_Compare := f_QuotData1.m_Group - f_QuotData2.m_Group;

  if (0 = f_Compare) then
    f_Compare := f_QuotData1.m_Market - f_QuotData2.m_Market;

  if (0 = f_Compare) then
    f_Compare := AnsiCompareStr(f_QuotData1.m_Name, f_QuotData2.m_Name);

  Result := f_Compare;
end;

function QuotData_CompareByOpenPrice(Item1, Item2: Pointer): Integer;
var
  f_QuotData1: CFNQuotData;
  f_QuotData2: CFNQuotData;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_QuotData1 := CFNQuotData(Item1);
  f_QuotData2 := CFNQuotData(Item2);

  if (0 = f_Compare) then
  begin
    if (f_QuotData1.m_OpenPrice > f_QuotData2.m_OpenPrice) then
    begin
      f_Compare := -1;
    end
    else if (f_QuotData1.m_OpenPrice < f_QuotData2.m_OpenPrice) then
    begin
      f_Compare := 1;
    end
    else
    begin
      f_Compare := 0;
    end;
  end;
  Result := f_Compare;
end;

function QuotData_CompareByHighPrice(Item1, Item2: Pointer): Integer;
var
  f_QuotData1: CFNQuotData;
  f_QuotData2: CFNQuotData;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_QuotData1 := CFNQuotData(Item1);
  f_QuotData2 := CFNQuotData(Item2);

  if (0 = f_Compare) then
  begin
    if (f_QuotData1.m_HighPrice > f_QuotData2.m_HighPrice) then
    begin
      f_Compare := -1;
    end
    else if (f_QuotData1.m_HighPrice < f_QuotData2.m_HighPrice) then
    begin
      f_Compare := 1;
    end
    else
    begin
      f_Compare := 0;
    end;
  end;
  Result := f_Compare;
end;

function QuotData_CompareByLowPrice(Item1, Item2: Pointer): Integer;
var
  f_QuotData1: CFNQuotData;
  f_QuotData2: CFNQuotData;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_QuotData1 := CFNQuotData(Item1);
  f_QuotData2 := CFNQuotData(Item2);

  if (0 = f_Compare) then
  begin
    if (f_QuotData1.m_LowPrice > f_QuotData2.m_LowPrice) then
    begin
      f_Compare := -1;
    end
    else if (f_QuotData1.m_LowPrice < f_QuotData2.m_LowPrice) then
    begin
      f_Compare := 1;
    end
    else
    begin
      f_Compare := 0;
    end;
  end;
  Result := f_Compare;
end;

function QuotData_CompareByClosePrice(Item1, Item2: Pointer): Integer;
var
  f_QuotData1: CFNQuotData;
  f_QuotData2: CFNQuotData;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_QuotData1 := CFNQuotData(Item1);
  f_QuotData2 := CFNQuotData(Item2);

  if (0 = f_Compare) then
  begin
    if (f_QuotData1.m_ClosePrice > f_QuotData2.m_ClosePrice) then
    begin
      f_Compare := -1;
    end
    else if (f_QuotData1.m_ClosePrice < f_QuotData2.m_ClosePrice) then
    begin
      f_Compare := 1;
    end
    else
    begin
      f_Compare := 0;
    end;
  end;
  Result := f_Compare;
end;

function QuotData_CompareByTotalVolume(Item1, Item2: Pointer): Integer;
var
  f_QuotData1: CFNQuotData;
  f_QuotData2: CFNQuotData;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_QuotData1 := CFNQuotData(Item1);
  f_QuotData2 := CFNQuotData(Item2);

  if (0 = f_Compare) then
  begin
    if (f_QuotData1.m_TotalVolume > f_QuotData2.m_TotalVolume) then
    begin
      f_Compare := -1;
    end
    else if (f_QuotData1.m_TotalVolume < f_QuotData2.m_TotalVolume) then
    begin
      f_Compare := 1;
    end
    else
    begin
      f_Compare := 0;
    end;
  end;
  Result := f_Compare;
end;

function QuotData_CompareByOfferPrice(Item1, Item2: Pointer): Integer;
var
  f_QuotData1: CFNQuotData;
  f_QuotData2: CFNQuotData;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_QuotData1 := CFNQuotData(Item1);
  f_QuotData2 := CFNQuotData(Item2);

  if (0 = f_Compare) then
  begin
    if (f_QuotData1.m_OfferPrice > f_QuotData2.m_OfferPrice) then
    begin
      f_Compare := -1;
    end
    else if (f_QuotData1.m_OfferPrice < f_QuotData2.m_OfferPrice) then
    begin
      f_Compare := 1;
    end
    else
    begin
      f_Compare := 0;
    end;
  end;
  Result := f_Compare;
end;

function QuotData_CompareByBidPrice(Item1, Item2: Pointer): Integer;
var
  f_QuotData1: CFNQuotData;
  f_QuotData2: CFNQuotData;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_QuotData1 := CFNQuotData(Item1);
  f_QuotData2 := CFNQuotData(Item2);

  if (0 = f_Compare) then
  begin
    if (f_QuotData1.m_BidPrice > f_QuotData2.m_BidPrice) then
    begin
      f_Compare := -1;
    end
    else if (f_QuotData1.m_BidPrice < f_QuotData2.m_BidPrice) then
    begin
      f_Compare := 1;
    end
    else
    begin
      f_Compare := 0;
    end;
  end;
  Result := f_Compare;
end;

function QuotData_CompareByOfferVolume(Item1, Item2: Pointer): Integer;
var
  f_QuotData1: CFNQuotData;
  f_QuotData2: CFNQuotData;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_QuotData1 := CFNQuotData(Item1);
  f_QuotData2 := CFNQuotData(Item2);

  if (0 = f_Compare) then
  begin
    if (f_QuotData1.m_OfferVolume > f_QuotData2.m_OfferVolume) then
    begin
      f_Compare := -1;
    end
    else if (f_QuotData1.m_OfferVolume < f_QuotData2.m_OfferVolume) then
    begin
      f_Compare := 1;
    end
    else
    begin
      f_Compare := 0;
    end;
  end;
  Result := f_Compare;
end;

function QuotData_CompareByBidVolume(Item1, Item2: Pointer): Integer;
var
  f_QuotData1: CFNQuotData;
  f_QuotData2: CFNQuotData;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_QuotData1 := CFNQuotData(Item1);
  f_QuotData2 := CFNQuotData(Item2);

  if (0 = f_Compare) then
  begin
    if (f_QuotData1.m_BidVolume > f_QuotData2.m_BidVolume) then
    begin
      f_Compare := -1;
    end
    else if (f_QuotData1.m_BidVolume < f_QuotData2.m_BidVolume) then
    begin
      f_Compare := 1;
    end
    else
    begin
      f_Compare := 0;
    end;
  end;
  Result := f_Compare;
end;

// ---------------------------------------------------------------------------

function QuotData_CompareByChangeRate(Item1, Item2: Pointer): Integer;
var
  f_QuotData1: CFNQuotData;
  f_QuotData2: CFNQuotData;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_QuotData1 := CFNQuotData(Item1);
  f_QuotData2 := CFNQuotData(Item2);

  if (0 = f_Compare) then
  begin
    if (f_QuotData1.m_ChangeRate > f_QuotData2.m_ChangeRate) then
    begin
      f_Compare := -1;
    end
    else if (f_QuotData1.m_ChangeRate < f_QuotData2.m_ChangeRate) then
    begin
      f_Compare := 1;
    end
    else
    begin
      f_Compare := 0;
    end;
  end;
  Result := f_Compare;
end;

// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
constructor CFNQuotArray.Create;
begin
  inherited Create;
  m_Type := QUOTTYPE_REAL;

  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CFNQuotArray.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 배열의 구성요소를 모두 삭제한다.
procedure CFNQuotArray.Clear;
begin
  while 0 < m_Items.Count do
  begin
    if (m_Type = QUOTTYPE_REAL) then
      CFNQuotData(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 하나를 추가한다.
procedure CFNQuotArray.Add(p_QuotData: CFNQuotData);
begin
  m_Items.Add(p_QuotData);
end;

// ---------------------------------------------------------------------------
// 해당값을 가지고 있는 요소를 찾아 그 인덱스를 리턴한다.
function CFNQuotArray.Search(p_Country, p_Group, p_Market: Integer; p_Symbol: String): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_QuotData: CFNQuotData;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_QuotData := CFNQuotData(m_Items.Items[f_PosX]);

      f_Compare := p_Country - f_QuotData.m_Country;

      if (0 = f_Compare) then
        f_Compare := p_Group - f_QuotData.m_Group;
      if (0 = f_Compare) then
        f_Compare := p_Market - f_QuotData.m_Market;

      if (0 = f_Compare) then
        f_Compare := AnsiCompareStr(p_Symbol, f_QuotData.m_Symbol);

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
procedure CFNQuotArray.SortByDateTime;
begin
  m_Items.Sort(@QuotData_CompareByDateTime);
end;

// ---------------------------------------------------------------------------
// 비교함수를 이용하여 정렬한다.
procedure CFNQuotArray.SortBySymbol;
begin
  m_Items.Sort(@QuotData_CompareBySymbol);
end;

// ---------------------------------------------------------------------------
// 비교함수를 이용하여 정렬한다.
procedure CFNQuotArray.SortByName;
begin
  m_Items.Sort(@QuotData_CompareByName);
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하여 복제한다.
procedure CFNQuotArray.Clone(p_Source: CFNQuotArray);
var
  f_OldQuotData: CFNQuotData;
  f_NewQuotData: CFNQuotData;
  f_Index: Integer;
begin
  Clear;

  m_Type := QUOTTYPE_REAL;
  for f_Index := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_OldQuotData := CFNQuotData(p_Source.m_Items.Items[f_Index]);
    f_NewQuotData := CFNQuotData.Create;
    f_NewQuotData.Clone(f_OldQuotData);
    m_Items.Add(f_NewQuotData);
  end;
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하지 않고 참조 포인터만 전달하여 복제한다.
// 이것은 정렬의 인덱스로 사용하기 위함이다.
procedure CFNQuotArray.CloneVirtual(p_Source: CFNQuotArray);
var
  f_OldQuotData: CFNQuotData;
  f_Index: Integer;
begin
  Clear;

  m_Type := QUOTTYPE_VIRTUAL;
  for f_Index := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_OldQuotData := CFNQuotData(p_Source.m_Items.Items[f_Index]);
    m_Items.Add(f_OldQuotData);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNQuotArray.SortByOpenPrice; // 시가
begin
  m_Items.Sort(@QuotData_CompareByOpenPrice);
end;

// ---------------------------------------------------------------------------
procedure CFNQuotArray.SortByHighPrice; // 고가
begin
  m_Items.Sort(@QuotData_CompareByHighPrice);
end;

// ---------------------------------------------------------------------------
procedure CFNQuotArray.SortByLowPrice; // 저가
begin
  m_Items.Sort(@QuotData_CompareByLowPrice);
end;

// ---------------------------------------------------------------------------
procedure CFNQuotArray.SortByClosePrice; // 종가(현재가)
begin
  m_Items.Sort(@QuotData_CompareByClosePrice);
end;

// ---------------------------------------------------------------------------
procedure CFNQuotArray.SortByTotalVolume; // 체결량
begin
  m_Items.Sort(@QuotData_CompareByTotalVolume);
end;

// ---------------------------------------------------------------------------
procedure CFNQuotArray.SortByOfferPrice; // 매도 호가
begin
  m_Items.Sort(@QuotData_CompareByOfferPrice);
end;

// ---------------------------------------------------------------------------
procedure CFNQuotArray.SortByBidPrice; // 매수 호가
begin
  m_Items.Sort(@QuotData_CompareByBidPrice);
end;

// ---------------------------------------------------------------------------
procedure CFNQuotArray.SortByOfferVolume; // 매도 잔량
begin
  m_Items.Sort(@QuotData_CompareByOfferVolume);
end;

// ---------------------------------------------------------------------------
procedure CFNQuotArray.SortByBidVolume; // 매수 잔량
begin
  m_Items.Sort(@QuotData_CompareByBidVolume);
end;

// ---------------------------------------------------------------------------
procedure CFNQuotArray.SortByChangeRate; // 매수 잔량
begin
  m_Items.Sort(@QuotData_CompareByChangeRate);
end;

// ---------------------------------------------------------------------------

end.
