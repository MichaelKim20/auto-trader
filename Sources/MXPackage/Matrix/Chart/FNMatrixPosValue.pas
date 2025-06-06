unit FNMatrixPosValue;

interface

uses
  SysUtils;

type

  CFNMatrixPosValue = class(TObject)
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
constructor CFNMatrixPosValue.Create;
begin
  inherited Create;

end;

// ---------------------------------------------------------------------------
destructor CFNMatrixPosValue.Destroy;
begin

  inherited Destroy;
end;

// ---------------------------------------------------------------------------

end.
