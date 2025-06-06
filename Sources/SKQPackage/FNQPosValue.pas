unit FNQPosValue;

interface
uses
    SysUtils;

type

    CFNQPosValue = class(TObject)
    public
        m_Name      : String;
        m_Value     : Double;
        m_Effect    : Boolean;
        m_Color     : Integer;
        m_Precision : Integer;

    public
        constructor Create();
        destructor  Destroy(); override;

    end;

implementation
uses
    FNGlobal;

//---------------------------------------------------------------------------
constructor CFNQPosValue.Create();
begin
    inherited Create();

end;

//---------------------------------------------------------------------------
destructor CFNQPosValue.Destroy();
begin

    inherited Destroy();
end;

//---------------------------------------------------------------------------

end.
