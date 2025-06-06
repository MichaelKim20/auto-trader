unit FNMatrixChartData;

interface
uses
    SysUtils;

type
//---------------------------------------------------------------------------
    CFNMatrixChartData = class(TObject)
    public
        m_OpenDateTime      : TDateTime;

        m_Year              : Integer;
        m_Month             : Integer;
        m_Day               : Integer;
        m_Hour              : Integer;
        m_Min               : Integer;
        m_Sec               : Integer;

        m_OpenQuarkPrice    : Double;
        m_HighQuarkPrice    : Double;
        m_LowQuarkPrice     : Double;
        m_CloseQuarkPrice   : Double;
        m_QuarkFactor       : Double;

        m_OpenRealPrice     : Double;
        m_HighRealPrice     : Double;
        m_LowRealPrice      : Double;
        m_CloseRealPrice    : Double;
        m_RealFactor        : Double;

        m_Volume            : Double;

    private
        function GetOpenQuarkPrice  :   Double;
        function GetHighQuarkPrice  :   Double;
        function GetLowQuarkPrice   :   Double;
        function GetCloseQuarkPrice :   Double;

        function GetOpenRealPrice   :   Double;
        function GetHighRealPrice   :   Double;
        function GetLowRealPrice    :   Double;
        function GetCloseRealPrice  :   Double;

    public
        constructor Create;
        destructor  Destroy; override;

        procedure Clone(p_Source : CFNMatrixChartData);

        property OpenQuarkPrice : Double read GetOpenQuarkPrice;
        property HighQuarkPrice : Double read GetHighQuarkPrice;
        property LowQuarkPrice : Double read GetLowQuarkPrice;
        property CloseQuarkPrice : Double read GetCloseQuarkPrice;

        property OpenRealPrice : Double read GetOpenRealPrice;
        property HighRealPrice : Double read GetHighRealPrice;
        property LowRealPrice : Double read GetLowRealPrice;
        property CloseRealPrice : Double read GetCloseRealPrice;
    end;

implementation

uses FNGlobal;

//---------------------------------------------------------------------------
constructor CFNMatrixChartData.Create;
begin
    inherited Create;
    m_QuarkFactor := 0;
    m_RealFactor := 0;
end;
//---------------------------------------------------------------------------
destructor CFNMatrixChartData.Destroy;
begin
    inherited Destroy;
end;
//---------------------------------------------------------------------------
function CFNMatrixChartData.GetOpenQuarkPrice: Double;
begin
    Result := m_OpenQuarkPrice + m_QuarkFactor;
end;
//---------------------------------------------------------------------------
function CFNMatrixChartData.GetHighQuarkPrice: Double;
begin
    Result := m_HighQuarkPrice + m_QuarkFactor;
end;
//---------------------------------------------------------------------------
function CFNMatrixChartData.GetLowQuarkPrice: Double;
begin
    Result := m_LowQuarkPrice + m_QuarkFactor;
end;
//---------------------------------------------------------------------------
function CFNMatrixChartData.GetCloseQuarkPrice: Double;
begin
    Result := m_CloseQuarkPrice + m_QuarkFactor;
end;
//---------------------------------------------------------------------------
function CFNMatrixChartData.GetOpenRealPrice: Double;
begin
    Result := m_OpenRealPrice + m_RealFactor;
end;
//---------------------------------------------------------------------------
function CFNMatrixChartData.GetHighRealPrice: Double;
begin
    Result := m_HighRealPrice + m_RealFactor;
end;
//---------------------------------------------------------------------------
function CFNMatrixChartData.GetLowRealPrice: Double;
begin
    Result := m_LowRealPrice + m_RealFactor;
end;
//---------------------------------------------------------------------------
function CFNMatrixChartData.GetCloseRealPrice: Double;
begin
    Result := m_CloseRealPrice + m_RealFactor;
end;
//---------------------------------------------------------------------------
procedure CFNMatrixChartData.Clone(p_Source: CFNMatrixChartData);
begin
    m_OpenDateTime      := p_Source.m_OpenDateTime;

    m_Year              := p_Source.m_Year;
    m_Month             := p_Source.m_Month;
    m_Day               := p_Source.m_Day;
    m_Hour              := p_Source.m_Hour;
    m_Min               := p_Source.m_Min;
    m_Sec               := p_Source.m_Sec;

    m_OpenQuarkPrice    := p_Source.m_OpenQuarkPrice;
    m_HighQuarkPrice    := p_Source.m_HighQuarkPrice;
    m_LowQuarkPrice     := p_Source.m_LowQuarkPrice;
    m_CloseQuarkPrice   := p_Source.m_CloseQuarkPrice;

    m_OpenRealPrice     := p_Source.m_OpenRealPrice;
    m_HighRealPrice     := p_Source.m_HighRealPrice;
    m_LowRealPrice      := p_Source.m_LowRealPrice;
    m_CloseRealPrice    := p_Source.m_CloseRealPrice;

    m_Volume            := p_Source.m_Volume;

    m_QuarkFactor       := p_Source.m_QuarkFactor;
    m_RealFactor        := p_Source.m_RealFactor;

end;
//---------------------------------------------------------------------------

end.
