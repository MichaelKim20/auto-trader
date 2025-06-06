unit FNQRequestData;

interface
uses
    SysUtils,
    FNDataSet;

type

    CFNQRequestData = class(TObject)
    public
    const
        RQ_MAIN_NEW     = 0;
        RQ_COMP_NEW     = 1;
        RQ_MAIN_ADD     = 2;
        RQ_COMP_ADD     = 3;

    public
        m_Country           : Integer;
        m_Group             : Integer;
        m_Market            : Integer;
        m_Symbol            : String;
        m_Name              : String;
        m_TimeFrame         : Integer;
        m_State             : Integer;
        m_StartDate         : TDateTime;
        m_EndDate           : TDateTime;
        m_XMinDate          : TDateTime;
        m_XMaxDate          : TDateTime;
        m_XMinOffset        : Integer;
        m_XMaxOffset        : Integer;
        m_XDirection        : Integer;
        m_RequestType       : Integer;
        m_ClearDrawObject   : Boolean;
        m_ClearOldData      : Boolean;
        m_DataPackage       : CFNDataPackage;
        m_Cancel            : Boolean;

    public
        constructor Create();
        destructor  Destroy(); override;

    end;

implementation
uses
    FNGlobal;

//---------------------------------------------------------------------------
constructor CFNQRequestData.Create();
begin
    inherited Create();

    m_Symbol        := '';
    m_TimeFrame     := 360;
    m_State         := RQ_MAIN_NEW;
    m_ClearOldData  := false;
    m_ClearDrawObject := false;
    m_DataPackage   := NIL;
    m_DataPackage   := CFNDataPackage.Create();
    m_Cancel        := false;
end;

//---------------------------------------------------------------------------
destructor CFNQRequestData.Destroy();
begin
    m_DataPackage.Free();

    inherited Destroy();
end;

//---------------------------------------------------------------------------

end.
