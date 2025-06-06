unit FNQChartTraceEvent;

interface
uses
    SysUtils;

type

    CFNQChartTraceEvent = class(TObject)
    public
         m_Enabled       : Boolean;
        m_Year          : Integer;
        m_Month         : Integer;
        m_Day           : Integer;
        m_Hour          : Integer;
        m_Min           : Integer;
        m_TimeFrame     : Integer;
        m_OpenPrice     : Double;
        m_HighPrice     : Double;
        m_LowPrice      : Double;
        m_ClosePrice    : Double;
        m_ChangePrice   : Double;
        m_ChangeRate    : Double;
        m_Volume        : Double;
        m_Precision     : Integer;

    public
        constructor Create();
        destructor  Destroy(); override;

    end;

implementation
uses
    FNGlobal;

//---------------------------------------------------------------------------
constructor CFNQChartTraceEvent.Create();
begin
    inherited Create();

end;

//---------------------------------------------------------------------------
destructor CFNQChartTraceEvent.Destroy();
begin

    inherited Destroy();
end;

//---------------------------------------------------------------------------

end.
