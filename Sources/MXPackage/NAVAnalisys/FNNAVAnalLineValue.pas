unit FNNAVAnalLineValue;

interface

uses
  SysUtils,
  FNNAVAnalConst;

type
  CFNNAVAnalLineValue = class(TObject)
  protected
    m_Size: Integer;

  public
    m_Value: Array of Double;

    constructor Create(p_Size: Integer);
    destructor Destroy; override;

    procedure SetSize(ASize: Integer);
  end;

implementation

uses
  FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNNAVAnalLineValue.Create(p_Size: Integer);
var
  i: Integer;
begin
  inherited Create;

  m_Value := NIL;
  m_Size := p_Size;
  SetLength(m_Value, m_Size);

  for i := 0 to m_Size - 1 do
  begin
    m_Value[i] := NOT_VALUE;
  end;
end;

// ---------------------------------------------------------------------------
destructor CFNNAVAnalLineValue.Destroy;
begin
  m_Value := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalLineValue.SetSize(ASize: Integer);
begin
  m_Size := ASize;
  SetLength(m_Value, m_Size);
end;

// ---------------------------------------------------------------------------

end.
