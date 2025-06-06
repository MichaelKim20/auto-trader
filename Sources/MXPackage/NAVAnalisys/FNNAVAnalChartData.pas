unit FNNAVAnalChartData;

interface

uses
  SysUtils;

type
  // ---------------------------------------------------------------------------
  CFNNAVAnalChartData = class(TObject)
  public
    m_Date: TDateTime;

    m_Year: Integer;
    m_Month: Integer;
    m_Day: Integer;
    m_Hour: Integer;
    m_Min: Integer;
    m_Sec: Integer;

    m_TProfit: Double;
    m_BProfit: Double;
    m_SProfit: Double;

    m_TProfitSum: Double;
    m_BProfitSum: Double;
    m_SProfitSum: Double;

    m_TNumberOfTrades: Double;
    m_BNumberOfTrades: Double;
    m_SNumberOfTrades: Double;
    m_Price: Double;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clone(p_Source: CFNNAVAnalChartData);
  end;

implementation

uses FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNNAVAnalChartData.Create;
begin
  inherited Create;
end;

// ---------------------------------------------------------------------------
destructor CFNNAVAnalChartData.Destroy;
begin
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartData.Clone(p_Source: CFNNAVAnalChartData);
begin
  m_Date := p_Source.m_Date;

  m_Year := p_Source.m_Year;
  m_Month := p_Source.m_Month;
  m_Day := p_Source.m_Day;
  m_Hour := p_Source.m_Hour;
  m_Min := p_Source.m_Min;
  m_Sec := p_Source.m_Sec;

  m_TProfit := p_Source.m_TProfit;
  m_BProfit := p_Source.m_BProfit;
  m_SProfit := p_Source.m_SProfit;

  m_TProfitSum := p_Source.m_TProfitSum;
  m_BProfitSum := p_Source.m_BProfitSum;
  m_SProfitSum := p_Source.m_SProfitSum;

  m_TNumberOfTrades := p_Source.m_TNumberOfTrades;
  m_BNumberOfTrades := p_Source.m_BNumberOfTrades;
  m_SNumberOfTrades := p_Source.m_SNumberOfTrades;

  m_Price := p_Source.m_Price;
end;
// ---------------------------------------------------------------------------

end.
