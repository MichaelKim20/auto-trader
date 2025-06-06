unit FNDataArray;

interface

type
  pTPointerArray = array of Pointer;

  (*
    가변배열로써 메모리상에 연속적으로 포인터(번지)가 저장된다.
    이 때 그 크기가 자동으로 증가되며, 또한 FNQuickSort를 이용하여 고속으로 소팅을 할 수 있다.
  *)
  CFNDataArray = class(TObject)
  private
    m_AllocSize: Integer;
    m_AddSize: Integer;

  protected
    m_Count: Integer;
    procedure FinalArray; virtual;
  public
    m_Items: pTPointerArray;

    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    procedure Add(AItem: Pointer);
    function GetCount: Integer;

    procedure SetAddSize(AAddSize: Integer);
    function GetAddSize: Integer;
  end;

implementation

// ---------------------------------------------------------------------------
constructor CFNDataArray.Create;
begin
  inherited Create;
  m_AllocSize := 0;
  m_AddSize := 100;
  m_Count := 0;
  m_Items := NIL;
  Clear;
end;

// ---------------------------------------------------------------------------
destructor CFNDataArray.Destroy;
begin
  FinalArray;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNDataArray.FinalArray;
begin
  if (m_Items <> NIL) then
  begin
    SetLength(m_Items, 0);
    m_Items := NIL;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNDataArray.Clear;
begin
  FinalArray;
  m_AllocSize := 0;
  m_Count := 0;
end;

// ---------------------------------------------------------------------------
procedure CFNDataArray.Add(AItem: Pointer);
begin
  if (m_Count >= m_AllocSize) then
  begin
    m_AllocSize := m_AllocSize + m_AddSize;
    SetLength(m_Items, m_AllocSize);
  end;
  m_Items[m_Count] := AItem;
  Inc(m_Count);
end;

// ---------------------------------------------------------------------------
function CFNDataArray.GetCount: Integer;
begin
  result := m_Count;
end;

// ---------------------------------------------------------------------------
procedure CFNDataArray.SetAddSize(AAddSize: Integer);
begin
  m_AddSize := AAddSize;
end;

// ---------------------------------------------------------------------------
function CFNDataArray.GetAddSize: Integer;
begin
  result := m_AddSize;
end;
// ---------------------------------------------------------------------------

end.
