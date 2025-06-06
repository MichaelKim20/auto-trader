unit FNAccountArray;

interface

uses
  Math, SysUtils, Classes, FNAccountData;

type
  /// /////////////////////////////////////////////////////////////////////////
  // CFNAccountData를 배열의 구성요소로 가지고 있는 자료구조이다.
  CFNAccountArray = class(TObject)
  public
    m_Items: TList;

  public
    constructor Create;
    destructor Destroy; override;

  public

    // m_Items자료구조 메모리를 해제한다.
    procedure Clear;
    // CFNAccountData를 하나 추가해준다.
    procedure Add(p_AccountData: CFNAccountData);
    // 파라메터로 전달받은 데이타를 복사해둔다.
    procedure Clone(p_Source: CFNAccountArray);

    function SearchIndexBySequence(ASequence: Integer): CFNAccountData;
    function SearchSequenceByAccountNo(AAccountNo: String): Integer;
  end;

implementation

uses
  FNGlobal;

// ---------------------------------------------------------------------------
// 생성자
constructor CFNAccountArray.Create;
begin
  inherited Create;

  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CFNAccountArray.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 배열의 구성요소를 모두 삭제한다.
procedure CFNAccountArray.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNAccountData(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 하나의 종목을 추가한다.
procedure CFNAccountArray.Add(p_AccountData: CFNAccountData);
begin
  m_Items.Add(p_AccountData);
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하여 복제한다.
procedure CFNAccountArray.Clone(p_Source: CFNAccountArray);
var
  f_OldAccountData: CFNAccountData;
  f_NewAccountData: CFNAccountData;
  f_Index: Integer;
begin
  Clear;

  for f_Index := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_OldAccountData := CFNAccountData(p_Source.m_Items.Items[f_Index]);
    f_NewAccountData := CFNAccountData.Create;
    f_NewAccountData.Clone(f_OldAccountData);
    m_Items.Add(f_NewAccountData);
  end;
end;

// ---------------------------------------------------------------------------
function CFNAccountArray.SearchIndexBySequence(ASequence: Integer): CFNAccountData;
var
  f_AccountData: CFNAccountData;
  f_Index: Integer;
begin
  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_AccountData := CFNAccountData(m_Items.Items[f_Index]);
    if f_AccountData.m_Sequence = ASequence then
    begin
      Result := f_AccountData;
      exit;
    end;
  end;
  Result := NIL;
end;

function CFNAccountArray.SearchSequenceByAccountNo(AAccountNo: String): Integer;
var
  f_AccountData: CFNAccountData;
  f_Index: Integer;
begin
  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_AccountData := CFNAccountData(m_Items.Items[f_Index]);
    if f_AccountData.m_AccountNo = AAccountNo then
    begin
      Result := f_Index;
      exit;
    end;
  end;
  Result := -1;
end;

end.
