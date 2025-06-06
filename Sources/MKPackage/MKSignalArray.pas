unit MKSignalArray;

interface

uses
  Math, Windows, SysUtils, Classes, MKSignalData, MKTradeSignalDefine;

type
  CMKSignalArray = class(TObject)
  public
    m_Items: TList;

    m_Country: Integer; // 국가번호
    m_Group: Integer; // 그룹번호
    m_Market: Integer; // 거래소번호
    m_Symbol: String; // 주식의 심벌

  public
    constructor Create();
    destructor Destroy(); override;

  public
    procedure Clear();
    procedure Clone(p_Source: CMKSignalArray);
    procedure Add(p_SignalData: CMKSignalData);

    function Search(p_Date: TDateTime): Integer;
    procedure Sort();

  end;

implementation

uses
  MKGlobal;

// ---------------------------------------------------------------------------
constructor CMKSignalArray.Create();
begin
  inherited Create();

  m_Items := TList.Create();
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CMKSignalArray.Destroy();
begin
  Clear();

  m_Items.Free();
  m_Items := NIL;

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
// 배열의 구성요소를 모두 삭제한다.
procedure CMKSignalArray.Clear();
begin
  while 0 < m_Items.Count do
  begin
    CMKSignalData(m_Items.Items[0]).Free();
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 하나를 추가한다.
procedure CMKSignalArray.Add(p_SignalData: CMKSignalData);
begin
  m_Items.Add(p_SignalData);
end;

// ---------------------------------------------------------------------------
// 해당값을 가지고 있는 요소를 찾아 그 인덱스를 리턴한다.
function CMKSignalArray.Search(p_Date: TDateTime): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_SignalData: CMKSignalData;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_SignalData := CMKSignalData(m_Items.Items[f_PosX]);

      f_Compare := p_Date - f_SignalData.m_DateTime;

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
function SignalData_Compare(Item1, Item2: Pointer): Integer;
var
  f_SignalData1: CMKSignalData;
  f_SignalData2: CMKSignalData;
  f_Compare: Double;
begin
  f_SignalData1 := CMKSignalData(Item1);
  f_SignalData2 := CMKSignalData(Item2);

  f_Compare := f_SignalData1.m_DateTime - f_SignalData2.m_DateTime;
  if f_Compare > 0 then
    f_Compare := 1
  else if f_Compare < 0 then
    f_Compare := -1
  else
    f_Compare := 0;

  Result := Trunc(f_Compare);
end;

// ---------------------------------------------------------------------------
// 비교함수를 이용하여 정렬한다.
procedure CMKSignalArray.Sort();
begin
  m_Items.Sort(@SignalData_Compare);
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하여 복제한다.
procedure CMKSignalArray.Clone(p_Source: CMKSignalArray);
var
  f_OldSignalData: CMKSignalData;
  f_NewSignalData: CMKSignalData;
  f_Index: Integer;
begin
  Clear();
  for f_Index := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_OldSignalData := CMKSignalData(p_Source.m_Items.Items[f_Index]);
    f_NewSignalData := CMKSignalData.Create();
    f_NewSignalData.Clone(f_OldSignalData);
    m_Items.Add(f_NewSignalData);
  end;
end;

end.
