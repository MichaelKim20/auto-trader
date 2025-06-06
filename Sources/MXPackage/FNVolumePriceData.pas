unit FNVolumePriceData;

interface

type
  CFNVolumePriceData = class(TObject)
  public
    m_DateTime: TDateTime; // 체결날짜
    m_Price: Double; // 체결가
    m_Volume: Double; // 체결량

  public
    constructor Create();
    destructor Destroy(); override;
    procedure Clone(p_Source: CFNVolumePriceData);

  end;

implementation

// ---------------------------------------------------------------------------
constructor CFNVolumePriceData.Create();
begin
  inherited Create();
  m_Price := 0;
  m_Volume := 0;
end;

// ---------------------------------------------------------------------------
destructor CFNVolumePriceData.Destroy();
begin

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
// 내용을 복제한다.
procedure CFNVolumePriceData.Clone(p_Source: CFNVolumePriceData);
begin
  m_DateTime := p_Source.m_DateTime;
  m_Price := p_Source.m_Price;
  m_Volume := p_Source.m_Volume;
end;

end.
