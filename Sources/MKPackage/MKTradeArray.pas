unit MKTradeArray;

interface

uses
  Math, Windows, SysUtils, Classes, MKTradeData, MKTradeSignalDefine,
  MKPerformanceValueArray;

type
  CMKTradeArray = class(TObject)
  public
    m_Items: TList;

    m_Country: Integer; // 국가번호
    m_Group: Integer; // 그룹번호
    m_Market: Integer; // 거래소번호
    m_Symbol: String; // 주식의 심벌

    m_NetProfit: Double; // 순이익
    m_GrossProfit: Double; // 총이익
    m_GrossLoss: Double; // 총손실
    m_NumberOfTrades: Integer; // 전체거래수
    m_NumberOfWinningTrades: Integer; // 이익거래수
    m_NumberOfLosingTrades: Integer; // 손실거래수
    m_PercentProfitable: Double; // 이익거래수/손실거래수
    m_LargestWinningTrade: Double; // 최대 이익거래 금액
    m_LargestLosingTrade: Double; // 최대 손실거래 금액
    m_AverageWinningTrade: Double; // 평균 이익거래 금액
    m_AverageLosingTrade: Double; // 평균 손실거래 금액
    m_RatioAvgWinAvgLoss: Double; // 평균 이익거래 금액/평균 손실거래 금액
    m_AvgTrade: Double; // 순이익/전체거래수
    m_MaxConsecWinners: Integer; // 최대연속이익거래수
    m_MaxConsecLosers: Integer; // 최대연속손실거래수
    m_AvgBarsWinners: Integer; // 이익거래의 평균 바수
    m_AvgBarsLosers: Integer; // 손실거래의 평균 바수
    m_MaxDrawdown: Double; // 순이익의 최대삭감금액
    m_AccountSizeRequired: Double; // 필요한 거래금액
    m_ProfitFactor: Double; // 총이익/총손실
    m_ReturnAccount: Double; // 결과
    m_ProfitRatio: Double; // 수익율

  public
    constructor Create();
    destructor Destroy(); override;
  private

  public
    procedure Clear();
    procedure Clone(p_Source: CMKTradeArray);
    procedure Add(p_TradeData: CMKTradeData);

    function Search(p_Date: TDateTime): Integer;
    procedure Sort();

    procedure MakePerformance;
    procedure WriteReport(p_StringArray: TStrings);
    procedure WritePrformance(p_ValueArray: CMKPerformanceValueArray);

  end;

implementation

uses
  MKGlobal;

// ---------------------------------------------------------------------------
constructor CMKTradeArray.Create();
begin
  inherited Create();

  m_Items := TList.Create();
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CMKTradeArray.Destroy();
begin
  Clear();

  m_Items.Free();
  m_Items := NIL;

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
// 배열의 구성요소를 모두 삭제한다.
procedure CMKTradeArray.Clear();
begin
  while 0 < m_Items.Count do
  begin
    CMKTradeData(m_Items.Items[0]).Free();
    m_Items.Delete(0);
  end;

  m_NetProfit := 0;
  m_GrossProfit := 0;
  m_GrossLoss := 0;
  m_NumberOfTrades := 0;
  m_NumberOfWinningTrades := 0;
  m_NumberOfLosingTrades := 0;
  m_PercentProfitable := 0;
  m_LargestWinningTrade := 0;
  m_LargestLosingTrade := 0;
  m_AverageWinningTrade := 0;
  m_AverageLosingTrade := 0;
  m_RatioAvgWinAvgLoss := 0;
  m_AvgTrade := 0;
  m_MaxConsecWinners := 0;
  m_MaxConsecLosers := 0;
  m_AvgBarsWinners := 0;
  m_AvgBarsLosers := 0;
  m_MaxDrawdown := 0;
  m_AccountSizeRequired := 0;
  m_ProfitFactor := 0;
  m_ReturnAccount := 0;
  m_ProfitRatio := 0;
end;

// ---------------------------------------------------------------------------
// 하나를 추가한다.
procedure CMKTradeArray.Add(p_TradeData: CMKTradeData);
begin
  m_Items.Add(p_TradeData);
end;

// ---------------------------------------------------------------------------
// 해당값을 가지고 있는 요소를 찾아 그 인덱스를 리턴한다.
function CMKTradeArray.Search(p_Date: TDateTime): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_TradeData: CMKTradeData;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_TradeData := CMKTradeData(m_Items.Items[f_PosX]);

      f_Compare := p_Date - f_TradeData.m_DateTime;

      if (0 > f_Compare) then
        f_PosR := f_PosX - 1
      else
        f_PosL := f_PosX + 1;
    until (not((f_Compare <> 0) and (f_PosL <= f_PosR)));

    if (0 = f_Compare) then
      Result := f_PosX
    else
      Result := -1;
  end
  else
  begin
    Result := -1;
  end;
end;

// ---------------------------------------------------------------------------
function TradeData_Compare(Item1, Item2: Pointer): Integer;
var
  f_TradeData1: CMKTradeData;
  f_TradeData2: CMKTradeData;
  f_Compare: Double;
begin
  f_TradeData1 := CMKTradeData(Item1);
  f_TradeData2 := CMKTradeData(Item2);

  f_Compare := f_TradeData1.m_DateTime - f_TradeData2.m_DateTime;
  if f_Compare > 0 then
    f_Compare := 1
  else if f_Compare < 0 then
    f_Compare := -1
  else
    f_Compare := 0;

  Result := Trunc(f_Compare);
end;

// ---------------------------------------------------------------------------
// 비교함수를 이용하여 정렬한다.
procedure CMKTradeArray.Sort();
begin
  m_Items.Sort(@TradeData_Compare);
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하여 복제한다.
procedure CMKTradeArray.Clone(p_Source: CMKTradeArray);
var
  f_OldTradeData: CMKTradeData;
  f_NewTradeData: CMKTradeData;
  f_Index: Integer;
begin
  Clear();
  for f_Index := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_OldTradeData := CMKTradeData(p_Source.m_Items.Items[f_Index]);
    f_NewTradeData := CMKTradeData.Create();
    f_NewTradeData.Clone(f_OldTradeData);
    m_Items.Add(f_NewTradeData);
  end;
end;

procedure CMKTradeArray.MakePerformance;
var
  f_TradeData: CMKTradeData;
  f_Index: Integer;
  f_Profit: Double;
  f_ConsecWinners: Integer;
  f_ConsecLosers: Integer;
  f_TotalDaysWinners: Integer;
  f_TotalDaysLosers: Integer;
  f_Cumulative: Double;
  f_MaxCumulative: Double;
  f_Drawdown: Double;

  f_SumProfitRatio: Double;
  f_SumPrice: Double;
begin
  m_ProfitRatio := 0;
  m_GrossProfit := 0;
  m_GrossLoss := 0;

  m_NumberOfTrades := 0;
  m_NumberOfWinningTrades := 0;
  m_NumberOfLosingTrades := 0;

  m_LargestWinningTrade := 0;
  m_LargestLosingTrade := 0;

  m_MaxConsecWinners := 0;
  m_MaxConsecLosers := 0;

  m_MaxDrawdown := 0;

  f_TotalDaysWinners := 0;
  f_TotalDaysLosers := 0;

  f_ConsecWinners := 0;
  f_ConsecLosers := 0;

  f_Cumulative := 0;
  f_MaxCumulative := 0;

  f_SumProfitRatio := 0;
  f_SumPrice := 0;

  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_TradeData := m_Items[f_Index];

    if (f_TradeData.m_Signal = SIGNAL_BUYENTER) then
    begin
      f_Profit := f_TradeData.m_ExitPrice - f_TradeData.m_EnterPrice;
    end
    else if (f_TradeData.m_Signal = SIGNAL_SELLENTER) then
    begin
      f_Profit := f_TradeData.m_EnterPrice - f_TradeData.m_ExitPrice;
    end;

    if (f_Profit > 0) then
    begin
      m_GrossProfit := m_GrossProfit + f_Profit;
      Inc(m_NumberOfWinningTrades);
      if (f_Profit > m_LargestWinningTrade) then
        m_LargestWinningTrade := f_Profit;
      Inc(f_ConsecWinners);
      if (f_ConsecWinners > m_MaxConsecWinners) then
        m_MaxConsecWinners := f_ConsecWinners;
      f_TotalDaysWinners := f_TotalDaysWinners + (f_TradeData.m_ExitIndex - f_TradeData.m_EnterIndex + 1);

      f_ConsecLosers := 0;
    end
    else if (f_Profit < 0) then
    begin
      m_GrossLoss := m_GrossLoss + f_Profit;
      Inc(m_NumberOfLosingTrades);
      if (f_Profit < m_LargestLosingTrade) then
        m_LargestLosingTrade := f_Profit;
      Inc(f_ConsecLosers);
      if (f_ConsecLosers > m_MaxConsecLosers) then
        m_MaxConsecLosers := f_ConsecLosers;
      f_TotalDaysLosers := f_TotalDaysLosers + (f_TradeData.m_ExitIndex - f_TradeData.m_EnterIndex + 1);

      f_ConsecWinners := 0;
    end;

    f_Cumulative := m_GrossProfit + m_GrossLoss;

    f_Drawdown := f_Cumulative - f_MaxCumulative;

    // 최대 순이익 삭감액 계산
    if (f_Drawdown < m_MaxDrawdown) then
    begin
      m_MaxDrawdown := f_Drawdown;
    end;

    if (f_Cumulative > f_MaxCumulative) then
      f_MaxCumulative := f_Cumulative;

    f_SumPrice := f_SumPrice + f_TradeData.m_EnterPrice;
    f_TradeData.m_Profit := f_Profit;
    f_TradeData.m_Cumulative := m_GrossProfit + m_GrossLoss;
    f_TradeData.m_ProfitRatio := f_TradeData.m_Profit * 100.0 / f_TradeData.m_EnterPrice;
    f_SumProfitRatio := f_SumProfitRatio + f_TradeData.m_ProfitRatio;
    f_TradeData.m_SumProfitRatio := f_SumProfitRatio;
    Inc(m_NumberOfTrades);

    f_TradeData.m_AvgProfitRatio := f_TradeData.m_Cumulative * 100.0 / (f_SumPrice / m_NumberOfTrades);
    m_ProfitRatio := f_TradeData.m_AvgProfitRatio;
  end;

  m_NetProfit := m_GrossProfit + m_GrossLoss;

  if (m_NumberOfTrades <> 0) then
  begin
    m_PercentProfitable := (m_NumberOfWinningTrades / m_NumberOfTrades) * 100.0;
    m_AvgTrade := m_NetProfit / m_NumberOfTrades;
  end
  else
  begin
    m_PercentProfitable := 0;
    m_AvgTrade := 0;
  end;

  if (m_NumberOfWinningTrades <> 0) then
  begin
    m_AverageWinningTrade := m_GrossProfit / m_NumberOfWinningTrades;
    m_AvgBarsWinners := Round(f_TotalDaysWinners / m_NumberOfWinningTrades);
  end
  else
  begin
    m_AverageWinningTrade := 0;
    m_AvgBarsWinners := 0;
  end;

  if (m_NumberOfLosingTrades <> 0) then
  begin
    m_AverageLosingTrade := m_GrossLoss / m_NumberOfLosingTrades;
    m_AvgBarsLosers := Round(f_TotalDaysLosers / m_NumberOfLosingTrades);
  end
  else
  begin
    m_AverageLosingTrade := 0;
    m_AvgBarsWinners := 0;
  end;

  if (m_AverageLosingTrade <> 0) then
  begin
    m_RatioAvgWinAvgLoss := abs(m_AverageWinningTrade / m_AverageLosingTrade);
  end
  else
  begin
    m_RatioAvgWinAvgLoss := 0;
  end;

  if (m_GrossLoss <> 0) then
  begin
    m_ProfitFactor := abs(m_GrossProfit / m_GrossLoss);
  end
  else
  begin
    m_ProfitFactor := 0;
  end;

  m_AccountSizeRequired := abs(m_MaxDrawdown);

  if (m_AccountSizeRequired <> 0) then
  begin
    m_ReturnAccount := (m_NetProfit / m_AccountSizeRequired) * 100.0;
  end
  else
  begin
    m_ReturnAccount := 0;
  end;
end;

procedure CMKTradeArray.WritePrformance(p_ValueArray: CMKPerformanceValueArray);
var
  f_Value: CMKPerformanceValue;
begin
  p_ValueArray.Clear;

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '수익율';
  f_Value.m_Value := m_ProfitRatio;
  f_Value.m_Precision := 1;
  f_Value.m_Unit := '%';
  f_Value.m_SignColor := true;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '순이익';
  f_Value.m_Value := m_NetProfit;
  f_Value.m_Precision := -1;
  f_Value.m_SignColor := true;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '전체거래수';
  f_Value.m_Value := m_NumberOfTrades;
  f_Value.m_Precision := 0;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '총이익/총손실';
  f_Value.m_Value := m_ProfitFactor;
  f_Value.m_Precision := 2;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '총이익';
  f_Value.m_Value := m_GrossProfit;
  f_Value.m_Precision := -1;
  f_Value.m_SignColor := true;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '총손실';
  f_Value.m_Value := m_GrossLoss;
  f_Value.m_Precision := -1;
  f_Value.m_SignColor := true;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '이익거래수/전체거래수';
  f_Value.m_Value := m_PercentProfitable;
  f_Value.m_Precision := 2;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '이익거래수';
  f_Value.m_Value := m_NumberOfWinningTrades;
  f_Value.m_Precision := 0;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '손실거래수';
  f_Value.m_Value := m_NumberOfLosingTrades;
  f_Value.m_Precision := 0;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '평균이익거래금액';
  f_Value.m_Value := m_AverageWinningTrade;
  f_Value.m_Precision := -1;
  f_Value.m_SignColor := true;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '평균손실거래금액';
  f_Value.m_Value := m_AverageLosingTrade;
  f_Value.m_Precision := -1;
  f_Value.m_SignColor := true;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '순이익/전체거래수';
  f_Value.m_Value := m_AvgTrade;
  f_Value.m_Precision := 2;
  f_Value.m_SignColor := true;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '평균이익거래금액/평균손실거래금액 ';
  f_Value.m_Value := m_RatioAvgWinAvgLoss;
  f_Value.m_Precision := 2;
  f_Value.m_SignColor := true;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '최대연속이익거래수';
  f_Value.m_Value := m_MaxConsecWinners;
  f_Value.m_Precision := 0;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '최대연속손실거래수';
  f_Value.m_Value := m_MaxConsecLosers;
  f_Value.m_Precision := 0;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '이익거래의 평균 바수';
  f_Value.m_Value := m_AvgBarsWinners;
  f_Value.m_Precision := 0;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '손실거래의 평균 바수';
  f_Value.m_Value := m_AvgBarsLosers;
  f_Value.m_Precision := 0;
  p_ValueArray.Add(f_Value);

  f_Value := CMKPerformanceValue.Create;
  f_Value.m_Name := '순이익최대삭감금액';
  f_Value.m_Value := m_MaxDrawdown;
  f_Value.m_Precision := -1;
  f_Value.m_SignColor := true;
  p_ValueArray.Add(f_Value);

end;

procedure CMKTradeArray.WriteReport(p_StringArray: TStrings);
begin
  p_StringArray.Clear;
  p_StringArray.Add(Format('  순이익                          %12.2f       ', [m_NetProfit]) +
      Format('  총이익/총손실                   %12.2f       ', [m_ProfitFactor]));
  p_StringArray.Add(Format('  총이익                          %12.2f       ', [m_GrossProfit]) +
      Format('  총손실                          %12.2f       ', [m_GrossLoss]));
  p_StringArray.Add(Format('  전체거래수                      %12d       ', [m_NumberOfTrades]) +
      Format('  이익거래수/전체거래수           %12.2f%%     ', [m_PercentProfitable]));
  p_StringArray.Add(Format('  이익거래수                      %12d       ', [m_NumberOfWinningTrades]) +
      Format('  손실거래수                      %12d         ', [m_NumberOfLosingTrades]));
  p_StringArray.Add(Format('  최대이익거래금액                %12.2f       ', [m_LargestWinningTrade]) +
      Format('  최대손실거래금액                %12.2f       ', [m_LargestLosingTrade]));
  p_StringArray.Add(Format('  평균이익거래금액                %12.2f       ', [m_AverageWinningTrade]) +
      Format('  평균손실거래금액                %12.2f       ', [m_AverageLosingTrade]));
  p_StringArray.Add(Format('  순이익/전체거래수               %12.2f       ', [m_AvgTrade]) + Format('  평균이익거래금액/평균손실거래금액       %3.2f',
      [m_RatioAvgWinAvgLoss]));
  p_StringArray.Add(Format('  최대연속이익거래수              %12d       ', [m_MaxConsecWinners]) +
      Format('  최대연속손실거래수              %12d         ', [m_MaxConsecLosers]));
  p_StringArray.Add(Format('  이익거래의 평균 바수            %12d       ', [m_AvgBarsWinners]) +
      Format('  손실거래의 평균 바수            %12d         ', [m_AvgBarsLosers]));
  p_StringArray.Add(Format('  순이익최대삭감금액              %12.2f       ', [m_MaxDrawdown]));

  // p_StringArray.Add(Format('  필요한 거래금액                 %12.2f       ', [m_AccountSizeRequired]));
  // p_StringArray.Add(Format('  결과                            %12.2f       ', [m_ReturnAccount]));
end;

end.
