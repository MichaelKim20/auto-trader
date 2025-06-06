unit FNNAVAnalPosValue;

interface

uses
  SysUtils;

type

  CFNNAVAnalPosValue = class(TObject)
  public
    m_Name: String;
    m_Value: Double;
    m_Effect: Boolean;
    m_Color: Integer;
    m_Precision: Integer;

  public
    constructor Create;
    destructor Destroy; override;

  end;

implementation

uses
  FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNNAVAnalPosValue.Create;
begin
  inherited Create;

end;

// ---------------------------------------------------------------------------
destructor CFNNAVAnalPosValue.Destroy;
begin

  inherited Destroy;
end;

// ---------------------------------------------------------------------------

end.
