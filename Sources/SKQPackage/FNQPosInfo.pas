unit FNQPosInfo;

interface
uses
    SysUtils;

type

    CFNQPosInfo = class(TObject)
    public
        m_ChartIndex        : Integer;
        m_MX                : Integer;
        m_MY                : Integer;
        m_ValueX            : Double;
        m_ValueY            : Double;
        m_WindowX           : Integer;
        m_WindowY           : Integer;
        m_ActiveObjectIndex : Integer;
        m_ActiveLineIndex   : Integer;
        m_OverLine          : Boolean;
        m_RealX             : Integer;
        m_RealY             : Integer;

    public
        constructor Create();
        destructor  Destroy(); override;

    end;

implementation
uses
    FNGlobal;

//---------------------------------------------------------------------------
constructor CFNQPosInfo.Create();
begin
    inherited Create();

end;

//---------------------------------------------------------------------------
destructor CFNQPosInfo.Destroy();
begin

    inherited Destroy();
end;

//---------------------------------------------------------------------------

end.
