unit FNNAVAnalChartTraceEvent;

interface

uses
  SysUtils;

type

  CFNNAVAnalChartTraceEvent = class(TObject)
  public
    m_Enabled: Boolean;
    m_Year: Integer;
    m_Month: Integer;
    m_Day: Integer;
    m_Hour: Integer;
    m_Min: Integer;

    m_Value: Double;
  public
    constructor Create;
    destructor Destroy; override;

  end;

implementation

uses
  FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNNAVAnalChartTraceEvent.Create;
begin
  inherited Create;

end;

// ---------------------------------------------------------------------------
destructor CFNNAVAnalChartTraceEvent.Destroy;
begin

  inherited Destroy;
end;

// ---------------------------------------------------------------------------

end.
