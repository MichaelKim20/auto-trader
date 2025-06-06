unit MKTradeData;

interface

uses
  MKTradeSignalDefine, MKSignalData;

type

  /// /////////////////////////////////////////////////////////////////////////
  //
  CMKTradeData = class(TObject)
  public
    m_Index: Integer; // 바의 번호
    m_DateTime: TDateTime; // 날짜와시간
    m_Signal: Integer; // 매매신호
    m_Price: Double; // 매매신호 발생가격(수정주가)
    m_OPS: Double; //

    m_EnterIndex: Integer; // 바의 번호
    m_EnterDateTime: TDateTime; // 날짜와시간
    m_EnterPrice: Double; // 매매신호 발생가격(수정주가)
    m_EnterOPS: Double; //

    m_ExitIndex: Integer; // 바의 번호
    m_ExitDateTime: TDateTime; // 날짜와시간
    m_ExitPrice: Double; // 매매신호 발생가격(수정주가)
    m_ExitOPS: Double; //

    m_HighestDateTime: TDateTime; // 거래 기간 중 최고 가격의 날짜와 시간
    m_HighestPrice: Double; // 거래 기간 중 최고 가격

    m_LowestDateTime: TDateTime; // 거래 기간 중 최저 가격의 날짜와 시간
    m_LowestPrice: Double; // 거래 기간 중 최저 가격

    m_Profit: Double; // 수익
    m_ProfitRatio: Double; // 수익률
    m_Cumulative: Double; // 누적수익
    m_SumProfitRatio: Double; // 수익률
    m_AvgProfitRatio: Double; // 수익률
    m_DrawDown: Double;
  private

  public
    constructor Create();
    destructor Destroy(); override;

    procedure Clone(p_Source: CMKTradeData);
    procedure CopyEnter(p_Source: CMKSignalData);
    procedure CopyExit(p_Source: CMKSignalData);
  end;

implementation

// ---------------------------------------------------------------------------
constructor CMKTradeData.Create();
begin
  inherited Create();
end;

// ---------------------------------------------------------------------------
destructor CMKTradeData.Destroy();
begin

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
procedure CMKTradeData.Clone(p_Source: CMKTradeData);
begin
  m_DateTime := p_Source.m_DateTime;
  m_Signal := p_Source.m_Signal;
  m_Price := p_Source.m_Price;
  m_OPS := p_Source.m_OPS;
end;

// ---------------------------------------------------------------------------
procedure CMKTradeData.CopyEnter(p_Source: CMKSignalData);
begin
  m_EnterIndex := p_Source.m_Index;
  m_EnterDateTime := p_Source.m_DateTime;
  m_EnterPrice := p_Source.m_Price;
  m_EnterOPS := p_Source.m_OPS;

  m_Signal := p_Source.m_Signal;
end;

// ---------------------------------------------------------------------------
procedure CMKTradeData.CopyExit(p_Source: CMKSignalData);
begin
  m_ExitIndex := p_Source.m_Index;
  m_ExitDateTime := p_Source.m_DateTime;
  m_ExitPrice := p_Source.m_Price;
  m_ExitOPS := p_Source.m_OPS;
end;

end.
