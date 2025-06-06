unit FNConditionData;

interface

uses
  Math, SysUtils;

type
  CFNConditionData = class(TObject)
  public
    m_PortfolioCount: Integer;
    m_URL: String;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clone(p_Source: CFNConditionData);
  end;

implementation

uses
  FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNConditionData.Create;
begin
  inherited Create;
end;

// ---------------------------------------------------------------------------
destructor CFNConditionData.Destroy;
begin
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNConditionData.Clone(p_Source: CFNConditionData);
begin
  if Assigned(p_Source) then
  begin
    m_PortfolioCount := p_Source.m_PortfolioCount;
    m_URL := p_Source.m_URL;
  end;
end;

end.
