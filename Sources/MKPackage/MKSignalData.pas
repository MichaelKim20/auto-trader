unit MKSignalData;

interface

uses
  MKTradeSignalDefine;

type

  /// /////////////////////////////////////////////////////////////////////////
  //
  CMKSignalData = class(TObject)
  public
    m_SystemNo: Integer;
    m_Index: Integer; // 바의 번호
    m_DateTime: TDateTime; // 날짜와시간
    m_Signal: Integer; // 매매신호
    m_Price: Double; // 매매신호 발생가격(수정주가)
    m_OPS: Double; //

  public
    constructor Create();
    destructor Destroy(); override;

    procedure Clone(p_Source: CMKSignalData);
  end;

implementation

// ---------------------------------------------------------------------------
constructor CMKSignalData.Create();
begin
  inherited Create();
end;

// ---------------------------------------------------------------------------
destructor CMKSignalData.Destroy();
begin

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
procedure CMKSignalData.Clone(p_Source: CMKSignalData);
begin
  m_Index := p_Source.m_Index;
  m_DateTime := p_Source.m_DateTime;
  m_Signal := p_Source.m_Signal;
  m_Price := p_Source.m_Price;
  m_OPS := p_Source.m_OPS;
end;

end.
