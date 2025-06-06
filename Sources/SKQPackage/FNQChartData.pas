unit FNQChartData;

interface

uses
    SysUtils;

type
    CFNQChartData = class(TObject)
    public
        m_OpenDateTime  	: TDateTime;
        m_CloseDateTime     : TDateTime;
        m_Year              : Integer;
        m_Month             : Integer;
        m_Day               : Integer;
        m_Hour              : Integer;
        m_Min               : Integer;
        m_Sec               : Integer;

        m_OpenPrice         : Double;
        m_HighPrice         : Double;
        m_LowPrice          : Double;
        m_ClosePrice        : Double;

        m_OpenOPS           : Double;
        m_HighOPS           : Double;
        m_LowOPS            : Double;
        m_CloseOPS          : Double;

        m_Volume            : Double;

        m_Key               : String;
        m_AskPrice          : Double;
        m_BidPrice          : Double;

        m_Virtual           : Boolean;

    public
        constructor Create();
        destructor  Destroy(); override;

        //복제한다
        procedure Clone(p_Source : CFNQChartData);
    end;

implementation
uses
    FNGlobal;

//---------------------------------------------------------------------------
constructor CFNQChartData.Create();
begin
    inherited Create();
    m_Virtual := false;
end;

//---------------------------------------------------------------------------
destructor CFNQChartData.Destroy();
begin

    inherited Destroy();
end;

//---------------------------------------------------------------------------
procedure CFNQChartData.Clone(p_Source: CFNQChartData);
begin
    m_OpenDateTime  := p_Source.m_OpenDateTime;
    m_CloseDateTime := p_Source.m_CloseDateTime;

    m_Year          := p_Source.m_Year;
    m_Month         := p_Source.m_Month;
    m_Day           := p_Source.m_Day;
    m_Hour          := p_Source.m_Hour;
    m_Min           := p_Source.m_Min;
    m_Sec           := p_Source.m_Sec;

    m_OpenPrice     := p_Source.m_OpenPrice;
    m_HighPrice     := p_Source.m_HighPrice;
    m_LowPrice      := p_Source.m_LowPrice;
    m_ClosePrice    := p_Source.m_ClosePrice;

    m_Volume        := p_Source.m_Volume;
    m_Key           := p_Source.m_Key;
    m_AskPrice      := p_Source.m_AskPrice;
    m_BidPrice      := p_Source.m_BidPrice;

    m_OpenOPS       := p_Source.m_OpenOPS;
    m_HighOPS       := p_Source.m_HighOPS;
    m_LowOPS        := p_Source.m_LowOPS;
    m_CloseOPS      := p_Source.m_CloseOPS;


    m_Virtual       := p_Source.m_Virtual;
end;
//---------------------------------------------------------------------------

end.
