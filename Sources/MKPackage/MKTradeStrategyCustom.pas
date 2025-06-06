unit MKTradeStrategyCustom;

interface

uses
  SysUtils, Math, Classes, MKChartData, MKChartDataSeries, MKLineValueSeries;

type

  /// 매매전략을 생성하고, 화면에 표시할때 필요한 최소한의 데이터와 파라메터,
  /// 그리고 결과를 담은 라인시리즈를 가지고 있는 클래스
  CMKTradeStrategyCustom = class(TObject)
  protected
    // 전략의 유형
    m_Category: String;

    // 전략명
    m_Name: String;

    // 차트데이터
    m_ChartDataSeries: CMKChartDataSeries;

    // 일간차트데이터
    m_DayChartDataSeries: CMKChartDataSeries;

    // 주가차트를 그리기 위해 만들어진 주가차트데이터
    m_PriceLineValueSeries: CMKLineValueSeries;

    // OPS2를 계산할 때 필요한 임시 데이터 영역
    m_OPS2LineValueSeries: CMKLineValueSeries;

    // 계산한 후 그 결과를 저장한 컬렉션
    m_LineCollection: TList;

    m_ChartBlockCount: Integer;

  public
    // 생성자
    constructor Create();

    // 파괴자
    destructor Destroy(); override;

    // 차트데이터를 설정한다
    procedure SetChartDataSeries(AChartDataSeries: CMKChartDataSeries; ADayChartDataSeries: CMKChartDataSeries);

    procedure Clear; virtual;

    // 계산을 시작한다.
    procedure Calculate(ARecalculation: Boolean); virtual;

    function GetStringOptionValue(AKey: String): String; virtual;
    function GetIntegerOptionValue(AKey: String): Integer; virtual;
    function GetDoubleOptionValue(AKey: String): Double; virtual;
    function GetBooleanOptionValue(AKey: String): Boolean; virtual;

    property ChartDataSeries: CMKChartDataSeries read m_ChartDataSeries;
    property DayChartDataSeries: CMKChartDataSeries read m_DayChartDataSeries;
    property PriceLineValueSeries: CMKLineValueSeries read m_PriceLineValueSeries;
    property ChartBlockCount: Integer read m_ChartBlockCount;
    property LineCollection: TList read m_LineCollection;
  end;

implementation

uses MKGlobal, MKConst, MKColorSet, MKTradeStrategyConst, MKLineValueSeriesCreator;

// ---------------------------------------------------------------------------
/// 생성자
constructor CMKTradeStrategyCustom.Create();
begin
  inherited Create();

  m_LineCollection := TList.Create;
  m_Name := '';
  m_ChartBlockCount := 0;

end;

// ---------------------------------------------------------------------------
/// 파괴자
destructor CMKTradeStrategyCustom.Destroy();
begin
  if (m_LineCollection <> NIL) then
  begin
    m_LineCollection.Free;
    m_LineCollection := NIL;
  end;
  inherited Destroy();
end;

// ---------------------------------------------------------------------------
/// 차트데이터를 설정한다
procedure CMKTradeStrategyCustom.SetChartDataSeries(AChartDataSeries: CMKChartDataSeries;
    ADayChartDataSeries: CMKChartDataSeries);
begin
  m_ChartDataSeries := AChartDataSeries;
  m_DayChartDataSeries := ADayChartDataSeries;
end;

// ---------------------------------------------------------------------------
procedure CMKTradeStrategyCustom.Clear;
begin

end;

// ---------------------------------------------------------------------------
// 계산을 시작한다.
procedure CMKTradeStrategyCustom.Calculate(ARecalculation: Boolean);
begin

end;

// ---------------------------------------------------------------------------
function CMKTradeStrategyCustom.GetStringOptionValue(AKey: String): String;
begin

end;

// ---------------------------------------------------------------------------
function CMKTradeStrategyCustom.GetIntegerOptionValue(AKey: String): Integer;
begin

end;

// ---------------------------------------------------------------------------
function CMKTradeStrategyCustom.GetDoubleOptionValue(AKey: String): Double;
begin

end;

// ---------------------------------------------------------------------------
function CMKTradeStrategyCustom.GetBooleanOptionValue(AKey: String): Boolean;
begin

end;

end.
