unit FNNAVData;

interface

uses
  SysUtils;

type

  // ---------------------------------------------------------------------------
  CFNNAVData = class(TObject)
  public
    m_Signal: Integer; // 매매신호
    m_Closed: Boolean; // 청산이 되었나
    m_Sequence: Integer;
    m_EnterDateTime: TDateTime;
    m_ExitDateTime: TDateTime;
    m_Asset: Double;
    m_AssetAvg: Double;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clone(p_Source: CFNNAVData);
  end;
  // ---------------------------------------------------------------------------

implementation

uses FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNNAVData.Create;
begin
  inherited Create;
end;

// ---------------------------------------------------------------------------
destructor CFNNAVData.Destroy;
begin
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVData.Clone(p_Source: CFNNAVData);
begin
  m_Signal := p_Source.m_Signal;
  m_Closed := p_Source.m_Closed;
  m_Sequence := p_Source.m_Sequence;
  m_EnterDateTime := p_Source.m_EnterDateTime;
  m_ExitDateTime := p_Source.m_ExitDateTime;
  m_Asset := p_Source.m_Asset;
  m_AssetAvg := p_Source.m_AssetAvg;
end;
// ---------------------------------------------------------------------------

end.
