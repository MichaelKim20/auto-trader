unit FNVPSummaryData;

interface

uses
  Graphics;

type
  CFNVPSummaryData = class(TObject)
  public
    // 반드시 필요함
    m_Enable: Boolean;
    // 반드시 필요함
    m_DayIndex: Integer; // 당일 포함 몇일 전인지?
    // 반드시 필요함
    m_Direction: Integer; // 전인지 후인지? 0:전, 1:후
    // 반드시 필요함
    m_Color: TColor;

    m_StartDateTime: TDateTime; // 시작날짜
    m_EndDateTime: TDateTime; // 마감날짜
    m_ClosePrice: Double;

    m_TotalVolume: Double; // 전체 거래량
    m_AvgVolume: Double; // 평균 거래량

    m_TotalVolumePrice: Double; // 전체 거래대금
    m_AvgVolumePrice: Double; // 평균 거래대금

    m_AvgPrice: Double; // 평균체결가(전체 거래대금 / 전체거래량)

    m_BeginIndex: Integer; // 통계를 시작한 일자의 일련번호
    m_EndIndex: Integer; // 통계를 마감한 일자의 일련번호

    m_MaxPrice: Double; // 최고가격
    m_MinPrice: Double; // 최저가격

    m_MaxAverage: Double; // 최고거래량이동평균선
    m_MinAverage: Double; // 최고거래량이동평균선

    m_MaxVolume: Double; // 최고거래량
    m_MinVolume: Double; // 최저거래량

    m_PriceInMaxVolume: Double; // 최고거래량 일 때의 가격
    m_PriceInMinVolume: Double; // 최저거래량 일 때의 가격

    m_IndexInMaxVolume: Integer; // 최고거래량 일 때의 인덱스

    m_VolumeRatio: Double; // 전체 구간의 합계 중 해당 기간의 거래량 비율
    m_VolumePriceRatio: Double; // 전체 구간의 합계 중 해당 기간의 거래대금 비율

  public
    constructor Create();
    destructor Destroy(); override;
    procedure Clone(p_Source: CFNVPSummaryData);

  end;

implementation

constructor CFNVPSummaryData.Create();
begin
  inherited Create();

  m_Enable := false;
  m_DayIndex := 0;
  m_Direction := 0;
  m_Color := 0;
  m_StartDateTime := 0;
  m_EndDateTime := 0;
  m_ClosePrice := 0;

  m_TotalVolume := 0;
  m_AvgVolume := 0;

  m_TotalVolumePrice := 0;
  m_AvgVolumePrice := 0;

  m_AvgPrice := 0;

  m_BeginIndex := 0;
  m_EndIndex := 0;

  m_MaxPrice := 0;
  m_MinPrice := 0;

  m_MaxAverage := 0;
  m_MinAverage := 0;

  m_MaxVolume := 0;
  m_MinVolume := 0;

  m_PriceInMaxVolume := 0;
  m_PriceInMinVolume := 0;

  m_IndexInMaxVolume := 0;

  m_VolumeRatio := 0;
  m_VolumePriceRatio := 0;
end;

// ---------------------------------------------------------------------------
destructor CFNVPSummaryData.Destroy();
begin

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
procedure CFNVPSummaryData.Clone(p_Source: CFNVPSummaryData);
begin
  m_Enable := p_Source.m_Enable;
  m_DayIndex := p_Source.m_DayIndex;
  m_Direction := p_Source.m_Direction;
  m_Color := p_Source.m_Color;
  m_StartDateTime := p_Source.m_StartDateTime;
  m_EndDateTime := p_Source.m_EndDateTime;
  m_ClosePrice := p_Source.m_ClosePrice;

  m_TotalVolume := p_Source.m_TotalVolume;
  m_AvgVolume := p_Source.m_AvgVolume;

  m_TotalVolumePrice := p_Source.m_TotalVolumePrice;
  m_AvgVolumePrice := p_Source.m_AvgVolumePrice;

  m_AvgPrice := p_Source.m_AvgPrice;

  m_BeginIndex := p_Source.m_BeginIndex;
  m_EndIndex := p_Source.m_EndIndex;

  m_MaxPrice := p_Source.m_MaxPrice;
  m_MinPrice := p_Source.m_MinPrice;

  m_MaxAverage := p_Source.m_MaxAverage;
  m_MinAverage := p_Source.m_MinAverage;

  m_MaxVolume := p_Source.m_MaxVolume;
  m_MinVolume := p_Source.m_MinVolume;

  m_PriceInMaxVolume := p_Source.m_PriceInMaxVolume;
  m_PriceInMinVolume := p_Source.m_PriceInMinVolume;

  m_IndexInMaxVolume := p_Source.m_IndexInMaxVolume;

  m_VolumeRatio := p_Source.m_VolumeRatio;
  m_VolumePriceRatio := p_Source.m_VolumePriceRatio;
end;

end.
