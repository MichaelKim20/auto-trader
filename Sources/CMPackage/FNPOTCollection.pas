unit FNPOTCollection;

interface

uses
  Math, SysUtils, Classes, FNDataSet;

const
  MAX_POTHOUR = 5; // 거래 구역의 최대갯수 5

type

  /// /////////////////////////////////////////////////////////////////////////
  // 차트컴포넌트는 스트리밍 시세를 수신하여 차트데이터를 가공해야 한다.
  // 차트데이터를 가공하기 위해서는 기본적으로 영업시간에 대한 이해가 있어야 한다.
  // 이 영업시간에 필요한 항목들을 추출하여 만든 클래스가 바로 FNPOTItem이다
  CFNPOTItem = class(TObject)
  public
    m_Date: TDateTime; // 해당일의 영업시간의 정보를 가지고 있다.
    m_Country: Integer; // 국가번호
    m_Group: Integer; // 그룹번호
    m_Market: Integer; // 거래소번호
    m_Symbol: String;
    m_HourCount: Integer; // 거래구역의 갯수
    m_HoliDay: Integer; // 휴일여부, 휴일:1, 영업일:0
    m_TimeDiffrence: Double;

    // 각 거래구역의 시작시간을 담고 있는 배열이다. 총 5개의 갯수가 있다.
    m_Open: Array [0 .. MAX_POTHOUR - 1] of Integer;
    // 각 거래구역의 마감시간을 담고 있는 배열이다. 총 5개의 갯수가 있다.
    m_Close: Array [0 .. MAX_POTHOUR - 1] of Integer;
    // 각 거래구역의 마감시간에서 체결완료시까지 걸리는 시간을 담고 있는 배열이다. 총 5개의 갯수가 있다.
    m_Settlement: Array [0 .. MAX_POTHOUR - 1] of Integer;
    // 각 거래구역까지의 최대 바의 갯수를 가지고 있다. 이것을 계산한다.
    m_MaxIndex: Array [0 .. MAX_POTHOUR - 1] of Integer;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clone(p_Source: CFNPOTItem);
    procedure ArrayToData(p_Record: CFNRecord);

    class function TimeToNumber(p_Hour: Integer; p_Min: Integer; p_Sec: Integer): Double;
    class function NumberToHour(p_Time: Double): Integer;
    class function NumberToMin(p_Time: Double): Integer;
    class function NumberToSec(p_Time: Double): Integer;

  end;

  // CFNPOTItem를 배열의 구성요소로 가지고 있는 자료구조이다.
  CFNPOTCollection = class(TObject)
  public
    m_Items: TList; // 각 구성요소를 저장하는 배열

  public

    constructor Create;
    destructor Destroy; override;

  private

  public
    // m_Items의 메모리를 해제
    procedure Clear;

    // 데이타를 추가
    procedure Add(p_POTItem: CFNPOTItem);

    // 서치함수이다.참수와 일치한 데이타의 인덱스를 찾아서 리턴해준다.
    function Search(p_Date: TDateTime; p_Country: Integer; p_Group: Integer; p_Market: Integer; p_Symbol: String = ''): Integer;

    function Find(p_Date: TDateTime; p_Country, p_Group, p_Market: Integer; p_Symbol: String = ''): CFNPOTItem;

    // 시간, country,group,market에 의해 소팅준다.
    procedure Sort;

    // 메모리를 생성해서 복사, 깊은 복사를 진행한다.
    procedure Clone(p_Source: CFNPOTCollection);
  end;

implementation

uses FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNPOTItem.Create;
var
  f_Index: Integer;
begin
  inherited Create;

  m_HourCount := 0;
  m_HoliDay := 0;
  m_TimeDiffrence := 0;
  m_Symbol := '';

  for f_Index := 0 to MAX_POTHOUR - 1 do
  begin
    m_Open[f_Index] := 0;
    m_Close[f_Index] := 0;
    m_Settlement[f_Index] := 0;
    m_MaxIndex[f_Index] := 0;
  end;
end;

// ---------------------------------------------------------------------------
destructor CFNPOTItem.Destroy;
begin

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 복제한다.
procedure CFNPOTItem.Clone(p_Source: CFNPOTItem);
var
  f_Index: Integer;
begin
  if Assigned(p_Source) then
  begin

    m_Date := p_Source.m_Date;
    m_Country := p_Source.m_Country;
    m_Group := p_Source.m_Group;
    m_Market := p_Source.m_Market;
    m_Symbol := p_Source.m_Symbol;
    m_HourCount := p_Source.m_HourCount;
    m_HoliDay := p_Source.m_HoliDay;
    m_TimeDiffrence := p_Source.m_TimeDiffrence;

    for f_Index := 0 to MAX_POTHOUR - 1 do
    begin
      m_Open[f_Index] := p_Source.m_Open[f_Index];
      m_Close[f_Index] := p_Source.m_Close[f_Index];
      m_Settlement[f_Index] := p_Source.m_Settlement[f_Index];
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNPOTItem.ArrayToData(p_Record: CFNRecord);
var
  f_Year, f_Month, f_Day: Integer;
  f_DateString: String;
  Buffer: String;
begin
  f_DateString := p_Record.GetStringValue('DATE');
  f_Year := TFNGlobal.atoi(Copy(f_DateString, 1, 4));
  f_Month := TFNGlobal.atoi(Copy(f_DateString, 5, 2));
  f_Day := TFNGlobal.atoi(Copy(f_DateString, 7, 2));
  m_Date := EncodeDate(f_Year, f_Month, f_Day);
  m_Country := p_Record.GetIntegerValue('COUNTRY_NO');
  m_Group := p_Record.GetIntegerValue('GROUP_NO');
  m_Market := p_Record.GetIntegerValue('MARKET_NO');
  m_Symbol := p_Record.GetStringValue('KEY');
  m_HoliDay := p_Record.GetIntegerValue('HOLIDAY');
  m_HourCount := p_Record.GetIntegerValue('HOURCOUNT');
  m_TimeDiffrence := p_Record.GetIntegerValue('TIME_DIFFRENCE') / 1440.0;

  // 각 문자열의 시간을 초단위의 정수로 변환한다.
  // 오전 9시 30분일 경우, 9*3600+30*60 이라는 초가 된다.

  Buffer := p_Record.GetStringValue('OPEN1');
  m_Open[0] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;
  Buffer := p_Record.GetStringValue('CLOSE1');
  m_Close[0] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;
  Buffer := p_Record.GetStringValue('SETTLEMENT1');
  m_Settlement[0] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;

  Buffer := p_Record.GetStringValue('OPEN2');
  m_Open[1] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;
  Buffer := p_Record.GetStringValue('CLOSE2');
  m_Close[1] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;
  Buffer := p_Record.GetStringValue('SETTLEMENT2');
  m_Settlement[1] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;

  Buffer := p_Record.GetStringValue('OPEN3');
  m_Open[2] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;
  Buffer := p_Record.GetStringValue('CLOSE3');
  m_Close[2] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;
  Buffer := p_Record.GetStringValue('SETTLEMENT3');
  m_Settlement[2] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;

  Buffer := p_Record.GetStringValue('OPEN4');
  m_Open[3] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;
  Buffer := p_Record.GetStringValue('CLOSE4');
  m_Close[3] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;
  Buffer := p_Record.GetStringValue('SETTLEMENT4');
  m_Settlement[3] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;

  Buffer := p_Record.GetStringValue('OPEN5');
  m_Open[4] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;
  Buffer := p_Record.GetStringValue('CLOSE5');
  m_Close[4] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;
  Buffer := p_Record.GetStringValue('SETTLEMENT5');
  m_Settlement[4] := TFNGlobal.atoi(Copy(Buffer, 1, 2)) * 3600 + TFNGlobal.atoi(Copy(Buffer, 3, 2)) * 60;

end;

// ---------------------------------------------------------------------------
// 초단위의 숫자를 시간으로 변환한다.
class function CFNPOTItem.NumberToHour(p_Time: Double): Integer;
begin
  Result := Math.floor(p_Time / 3600);
end;

// ---------------------------------------------------------------------------
// 초단위의 숫자를 분으로 변환한다.
class function CFNPOTItem.NumberToMin(p_Time: Double): Integer;
var
  f_MinCount: Integer;
begin
  f_MinCount := Math.floor(p_Time / 60);

  Result := Math.floor(f_MinCount mod 60);
end;

// ---------------------------------------------------------------------------
// 초단위의 숫자를 초로 변환한다.
class function CFNPOTItem.NumberToSec(p_Time: Double): Integer;
begin
  Result := Math.floor(Trunc(p_Time) mod 60);
end;

// ---------------------------------------------------------------------------
// 시,분,초를 초단위의 숫자로 변환한다.
class function CFNPOTItem.TimeToNumber(p_Hour, p_Min, p_Sec: Integer): Double;
begin
  Result := p_Hour * 3600.0 + p_Min * 60.0 + p_Sec;
end;

// ---------------------------------------------------------------------------
// 비교함수이다. 여기서는 국가번호, 그룹번호, 거래소번호순으로 오름차순이다.
function CMP_CFNPOTItem(Item1, Item2: Pointer): Integer;
var
  f_POTItem1: CFNPOTItem;
  f_POTItem2: CFNPOTItem;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_POTItem1 := CFNPOTItem(Item1);
  f_POTItem2 := CFNPOTItem(Item2);

  if (0 = f_Compare) then
    f_Compare := Trunc(f_POTItem1.m_Date) - Trunc(f_POTItem2.m_Date);
  if (0 = f_Compare) then
    f_Compare := f_POTItem1.m_Country - f_POTItem2.m_Country;
  if (0 = f_Compare) then
    f_Compare := f_POTItem1.m_Group - f_POTItem2.m_Group;
  if (0 = f_Compare) then
    f_Compare := f_POTItem1.m_Market - f_POTItem2.m_Market;
  if (0 = f_Compare) then
    f_Compare := CompareStr(f_POTItem1.m_Symbol, f_POTItem2.m_Symbol);

  if (0 < f_Compare) then
    Result := 1
  else if (0 > f_Compare) then
    Result := -1
  else
    Result := 0;
end;

// ---------------------------------------------------------------------------
constructor CFNPOTCollection.Create;
begin
  inherited Create;

  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CFNPOTCollection.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 배열의 구성요소를 모두 삭제한다.
procedure CFNPOTCollection.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNPOTItem(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 하나를 추가한다.
procedure CFNPOTCollection.Add(p_POTItem: CFNPOTItem);
begin
  m_Items.Add(p_POTItem);
end;

// ---------------------------------------------------------------------------
// 해당값을 가지고 있는 요소를 찾아 그 인덱스를 리턴한다.
function CFNPOTCollection.Search(p_Date: TDateTime; p_Country, p_Group, p_Market: Integer; p_Symbol: String = ''): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_POTItem: CFNPOTItem;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_POTItem := CFNPOTItem(m_Items.Items[f_PosX]);

      f_Compare := Trunc(p_Date) - Trunc(f_POTItem.m_Date);

      if (0 = f_Compare) then
        f_Compare := p_Country - f_POTItem.m_Country;
      if (0 = f_Compare) then
        f_Compare := p_Group - f_POTItem.m_Group;
      if (0 = f_Compare) then
        f_Compare := p_Market - f_POTItem.m_Market;
      if p_Symbol <> '' then
      begin
        if (0 = f_Compare) then
          f_Compare := CompareStr(p_Symbol, f_POTItem.m_Symbol);
      end;

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
function CFNPOTCollection.Find(p_Date: TDateTime; p_Country, p_Group, p_Market: Integer; p_Symbol: String = ''): CFNPOTItem;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_POTItem: CFNPOTItem;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_POTItem := CFNPOTItem(m_Items.Items[f_PosX]);

      f_Compare := Trunc(p_Date) - Trunc(f_POTItem.m_Date);

      if (0 = f_Compare) then
        f_Compare := p_Country - f_POTItem.m_Country;

      if (0 = f_Compare) then
        f_Compare := p_Group - f_POTItem.m_Group;

      if (0 = f_Compare) then
        f_Compare := p_Market - f_POTItem.m_Market;

      if p_Symbol <> '' then
      begin
        if (0 = f_Compare) then
          f_Compare := CompareStr(p_Symbol, f_POTItem.m_Symbol);
      end;

      if (0 > f_Compare) then
        f_PosR := f_PosX - 1
      else
        f_PosL := f_PosX + 1;
    until (not((f_Compare <> 0) and (f_PosL <= f_PosR)));

    if (0 = f_Compare) then
      Result := f_POTItem
    else
      Result := NIL;
  end
  else
  begin
    Result := NIL;
  end;
end;

// ---------------------------------------------------------------------------
// 비교함수를 이용하여 정렬한다.
procedure CFNPOTCollection.Sort;
begin
  m_Items.Sort(@CMP_CFNPOTItem);
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하여 복제한다.
procedure CFNPOTCollection.Clone(p_Source: CFNPOTCollection);
var
  f_OldPOTItem: CFNPOTItem;
  f_NewPOTItem: CFNPOTItem;
  f_Index: Integer;
begin
  Clear;

  for f_Index := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_OldPOTItem := CFNPOTItem(p_Source.m_Items.Items[f_Index]);
    f_NewPOTItem := CFNPOTItem.Create;
    f_NewPOTItem.Clone(f_OldPOTItem);
    m_Items.Add(f_NewPOTItem);
  end;
end;

end.
