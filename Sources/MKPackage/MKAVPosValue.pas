unit MKAVPosValue;

interface

uses
  SysUtils;

type

  CMKPosValue = class(TObject)
  public
    m_Name: String;
    m_Value: Double;
    m_Effect: Boolean;
    m_Color: Integer;
    m_Precision: Integer;

  public
    constructor Create();
    destructor Destroy(); override;

  end;

implementation

uses
  MKGlobal;

// ---------------------------------------------------------------------------
constructor CMKPosValue.Create();
begin
  inherited Create();

end;

// ---------------------------------------------------------------------------
destructor CMKPosValue.Destroy();
begin

  inherited Destroy();
end;

// ---------------------------------------------------------------------------

end.
