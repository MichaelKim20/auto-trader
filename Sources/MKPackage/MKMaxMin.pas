unit MKMaxMin;

interface

uses
  SysUtils;

type

  CMKMaxMin = class(TObject)
  public
    m_XMin: Double;
    m_XMax: Double;
    m_YMin: Double;
    m_YMax: Double;
    m_YMinIndex: Integer;
    m_YMaxIndex: Integer;

  public
    constructor Create();
    destructor Destroy(); override;

  end;

implementation

uses
  MKGlobal;

// ---------------------------------------------------------------------------
constructor CMKMaxMin.Create();
begin
  inherited Create();

  m_XMin := 0.0;
  m_XMax := 0.0;
  m_YMin := 0.0;
  m_YMax := 0.0;
  m_YMinIndex := 0;
  m_YMaxIndex := 0;
end;

// ---------------------------------------------------------------------------
destructor CMKMaxMin.Destroy();
begin

  inherited Destroy();
end;

// ---------------------------------------------------------------------------

end.
