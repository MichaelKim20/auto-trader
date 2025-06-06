unit MKStreamChartDataSeries;

interface

uses
  SysUtils, Math, DateUtils, MKChartData, MKChartDataSeries, FNQuotData, FNDataSet, FNPOTCollection;

type
  CMKStreamChartDataSeries = class(CMKChartDataSeries)
  public
    m_POTItem: CFNPOTItem; // 해당 주식의 당일의 거래시간정보가 저장된 객체
    m_CoreOfDay: Double; // 1일 기준으로 발생할 수 있는 바의 수.	1분 바의 경우 1440개 있다. 24*60
    m_ZeroIndex: Integer; // 당일의 데이터가 시작되는 지점의 배열순번
    m_OldMinIndex: Integer; // 이전 시세가 전달 받았을 때, 갱신한 배열순번
    m_NewMinIndex: Integer; // 새로운 시세가 전달 받았을 때, 갱신할 배열순번
    m_OldQuotDateTime: TDateTime; // 이전 시세의 거래 시간
    m_OldQuotTotalVolume: Double; // 이전 시세의 누적거래량

    // 외부에서 당일의 처음 시작위치를 재 계산하라는 의미로 그 값을 설정할 때 사용한다.
    // 기존 앞쪽에 새로운 차트데이터를 덧붙여 던지...
    m_DoFindZeroIndex: Boolean;

    // 스트리밍으로 받은 객체 CFNStreamRecord를  FNQuotData 객체에 변환해서 저장한다.
    // 이렇게 함으로써 맵의 반복적인 사용에 따른 오버 해드를 감소시키고, 소스의 가독성을 증가시킨다.
    m_QuotData: CFNQuotData;
    m_StreamQuotData: CFNQuotData;

    m_LastDateTimeOnChartBar: TDateTime; // 차트데이터의 마지막바에 기록된 날짜

  public
    constructor Create();
    destructor Destroy(); override;

    procedure SetPOTItem(p_POTItem: CFNPOTItem);
    function FindZeroIndex(p_Date: TDateTime): Integer;

    procedure FindZeroNextTime();
    procedure ReadyStream();

    function CloseTimeToIndex(p_Hour: Integer; p_Min: Integer; p_Sec: Integer): Integer;
    function IndexToCloseTime(p_Index: Integer): Double;
    function IndexToOpenTime(p_Index: Integer): Double;

    function GetOpenDateTime(p_CloseDateTime: Double; p_Factor: Integer): Double;

    function UpdateQuotData(p_QuotData: CFNQuotData): Integer;
    function UpdateQuotDataToMin(p_QuotData: CFNQuotData): Integer;
    function UpdateQuotDataToDay(p_QuotData: CFNQuotData): Integer;

    function UpdateStreamQuotData(p_StreamRecord: CFNStreamRecord): Integer;

    procedure AdjustData;
  end;

implementation

uses MKGlobal;

// ---------------------------------------------------------------------------
constructor CMKStreamChartDataSeries.Create();
begin
  inherited Create();
  m_POTItem := CFNPOTItem.Create();
  m_QuotData := CFNQuotData.Create();
  m_StreamQuotData := CFNQuotData.Create();

  m_ZeroIndex := 0;
  m_OldQuotTotalVolume := 0;
  m_OldQuotDateTime := 0;
  m_OldMinIndex := -1;
  m_NewMinIndex := -1;
  m_DoFindZeroIndex := FALSE;

  m_LastDateTimeOnChartBar := 0;
end;

// ---------------------------------------------------------------------------
destructor CMKStreamChartDataSeries.Destroy();
begin
  m_POTItem.Free;
  m_QuotData.Free;
  m_StreamQuotData.Free;

  inherited Destroy();
end;

// 당일의 거래시간 정보를 설정한다.
// ---------------------------------------------------------------------------
procedure CMKStreamChartDataSeries.SetPOTItem(p_POTItem: CFNPOTItem);
begin
  if Assigned(p_POTItem) then
    m_POTItem.Clone(p_POTItem);
end;

// ---------------------------------------------------------------------------
function CMKStreamChartDataSeries.UpdateQuotData(p_QuotData: CFNQuotData): Integer;
var
  f_AddCount: Integer;
  f_MarketData: CMKChartData;
  f_OldPrice: Double;
begin
  (*
  if (m_Items.Count > 0) then
  begin
    f_MarketData := m_Items[m_Items.Count - 1];
    f_OldPrice := f_MarketData.m_ClosePrice;

    if f_OldPrice <> 0 then
    begin
      if abs((p_QuotData.m_ClosePrice - f_OldPrice) * 100.0 / f_OldPrice) > 15.0 then
      begin
        Result := -1;
        exit;
      end;
    end;
  end;
  *)
  m_QuotData.Clone(p_QuotData);

  if (m_OldQuotDateTime <> 0) then
  begin
    if (m_OldQuotDateTime > m_QuotData.m_DateTime) then
    begin
      Result := -1;
      exit;
    end;

    if m_OldQuotTotalVolume = 0 then
    begin
      m_QuotData.m_Volume := 0;
    end
    else
    begin
      m_QuotData.m_Volume := m_QuotData.m_TotalVolume - m_OldQuotTotalVolume;
      if m_QuotData.m_Volume < 0 then
      begin
        m_QuotData.m_Volume := 0;
      end;
    end;
  end;

  // 초간데이터 일 경우
  if (m_TimeFrame >= 9000) then
  begin
    f_AddCount := UpdateQuotDataToMin(m_QuotData)
  end
  // 분간데이터 일 경우
  else if (m_TimeFrame < 360) then
  begin
    f_AddCount := UpdateQuotDataToMin(m_QuotData)
  end
  // 일간데이터 일 경우
  else if (m_TimeFrame = 360) then
  begin
    f_AddCount := UpdateQuotDataToDay(m_QuotData)
  end
  else
  begin
    f_AddCount := -1;
  end;

  m_OldQuotTotalVolume := m_QuotData.m_TotalVolume;
  m_OldQuotDateTime := m_QuotData.m_DateTime;
  m_LastDateTimeOnChartBar := m_QuotData.m_DateTime;

  Result := f_AddCount;
end;

// ---------------------------------------------------------------------------
// 분간차트데이터에 추가/갱신 한다. 리턴값은 신규로 추가된 바의 수이다
function CMKStreamChartDataSeries.UpdateQuotDataToMin(p_QuotData: CFNQuotData): Integer;
var
  f_Time: Double;
  f_Index: Integer;
  m_OldMinIndexOnToday: Integer;
  f_MarketData: CMKChartData;
  f_MarketData1: CMKChartData;
  f_MarketData0: CMKChartData;
  f_NewMarketData: CMKChartData;
  f_AddCount: Integer;
  arrDateTime: Array [0 .. 3] of Word;
  f_Value1, f_Value2: Double;

  LPrevDate: TDateTime;
  LPrevOPS: Double;
  LPrevPrice: Double;
  LAddGapVirtual: Boolean;
  LCount: Integer;
begin
  f_AddCount := 0;

  // 이전에 받은 스트리밍 시세가 존재 하지 않고, 현재 시세가 가장 처음에 전달 받은 스트리밍 데이터 일 경우
  // 이 경우 당일의 가장 첫번째 데이터가 전체중에 몇번째 인지 계산한다.
  if (m_OldQuotDateTime = 0) then
  begin
    m_ZeroIndex := FindZeroIndex(p_QuotData.m_DateTime);
  end
  else

    // 이전에 받은 스트리밍 시세와 현재 받은 스트리밍 시세의 날짜가 다를 경우
    // 이 경우 당일의 가장 첫번째 데이터가 전체중에 몇번째 인지 계산한다.
    if (not SameDate(m_OldQuotDateTime, p_QuotData.m_DateTime)) then // 년/월/일 비교
    begin
      m_ZeroIndex := FindZeroIndex(p_QuotData.m_DateTime);
    end
    else

      // 혹시 외부에서  함수 F_FindZeroNextTime를 호출하여 m_DoFindZeroIndex의 값을 true로 설정하였을 때
      // 이 경우 당일의 가장 첫번째 데이터가 전체중에 몇번째 인지 계산한다.
      if (m_DoFindZeroIndex) then
      begin
        m_ZeroIndex := FindZeroIndex(p_QuotData.m_DateTime);
        m_DoFindZeroIndex := FALSE;
      end
      else
      begin
        f_AddCount := 0;
      end;

  // 이전의 1분바의 위치를 계산한다.
  m_OldMinIndex := m_Items.Count - 1;

  // 새로운 시세를 업데이터 할 바의 인덱스를 찾는다.
  DecodeTime(p_QuotData.m_DateTime, arrDateTime[0], arrDateTime[1], arrDateTime[2], arrDateTime[3]); // 시, 분, 초
  m_NewMinIndex := CloseTimeToIndex(arrDateTime[0], arrDateTime[1], arrDateTime[2]);

  if (m_NewMinIndex < 0) then
  begin
    Result := -1;
    exit;
  end;

  m_NewMinIndex := m_ZeroIndex + m_NewMinIndex;
  m_OldMinIndexOnToday := m_OldMinIndex - m_ZeroIndex;

  if (m_OldMinIndex >= m_ZeroIndex) and (m_OldMinIndex < m_Items.Count) then
  begin
    f_MarketData := CMKChartData(m_Items.Items[m_OldMinIndex]);
    f_Time := IndexToCloseTime(m_OldMinIndex - m_ZeroIndex);
    f_MarketData.m_Year := p_QuotData.m_Year;
    f_MarketData.m_Month := p_QuotData.m_Month;
    f_MarketData.m_Day := p_QuotData.m_Day;
    f_MarketData.m_Hour := CFNPOTItem.NumberToHour(f_Time);
    f_MarketData.m_Min := CFNPOTItem.NumberToMin(f_Time);
    f_MarketData.m_Sec := CFNPOTItem.NumberToSec(f_Time);

    f_MarketData.m_CloseDateTime := EncodeDateTime(f_MarketData.m_Year, f_MarketData.m_Month, f_MarketData.m_Day,
        f_MarketData.m_Hour, f_MarketData.m_Min, f_MarketData.m_Sec, 0);
  end;

  // 이전 바와 지금 바의 위치가 다를 경우
  if (m_NewMinIndex > m_OldMinIndex) then
  begin

{$REGION '갭처리를 위한 허수바를 넣어 준다.'}
    if (m_IsGapVirtualData and (m_GapVirtualCount > 0)) then
    begin
      LAddGapVirtual := FALSE;
      if (m_OldMinIndex < 0) then
      begin
        LPrevDate := Trunc(p_QuotData.m_DateTime) - 1;
        LPrevOPS := p_QuotData.m_CloseOPS;
        LPrevPrice := p_QuotData.m_ClosePrice;
        LAddGapVirtual := true;
      end
      else
      begin
        f_MarketData1 := CMKChartData(m_Items.Items[m_OldMinIndex]);
        if (not SameDate(f_MarketData1.m_CloseDateTime, p_QuotData.m_DateTime)) then
        begin
          LPrevDate := f_MarketData1.m_CloseDateTime;
          LPrevOPS := p_QuotData.m_CloseOPS;
          LPrevPrice := p_QuotData.m_ClosePrice;
          LAddGapVirtual := true;
        end;
      end;

      if LAddGapVirtual then
      begin

        for LCount := 0 to m_GapVirtualCount - 1 do
        begin
          f_NewMarketData := CMKChartData.Create();
          f_NewMarketData.Clone(f_MarketData0);

          f_NewMarketData.m_Virtual := true;

          f_NewMarketData.m_OpenDateTime := LPrevDate;
          f_NewMarketData.m_CloseDateTime := LPrevDate;

          f_NewMarketData.m_OpenPrice := LPrevPrice;
          f_NewMarketData.m_HighPrice := LPrevPrice;
          f_NewMarketData.m_LowPrice := LPrevPrice;
          f_NewMarketData.m_ClosePrice := LPrevPrice;

          f_NewMarketData.m_OpenOPS := LPrevOPS;
          f_NewMarketData.m_HighOPS := LPrevOPS;
          f_NewMarketData.m_LowOPS := LPrevOPS;
          f_NewMarketData.m_CloseOPS := LPrevOPS;

          f_NewMarketData.m_Volume := 0;

          m_Items.Insert(f_Index, f_NewMarketData);

          Inc(f_Index);
        end;

        m_ZeroIndex := FindZeroIndex(p_QuotData.m_DateTime);

        m_OldMinIndex := m_Items.Count - 1;

        // 새로운 시세를 업데이터 할 바의 인덱스를 찾는다.
        DecodeTime(p_QuotData.m_DateTime, arrDateTime[0], arrDateTime[1], arrDateTime[2], arrDateTime[3]); // 시, 분, 초
        m_NewMinIndex := CloseTimeToIndex(arrDateTime[0], arrDateTime[1], arrDateTime[2]);

        m_NewMinIndex := m_ZeroIndex + m_NewMinIndex;
        m_OldMinIndexOnToday := m_OldMinIndex - m_ZeroIndex;
      end;
    end;

{$ENDREGION}
{$REGION '이전 바와 현재 바사이에 허수 바를 생성하여 넣어 준다.'}
    for f_Index := m_OldMinIndex + 1 to m_NewMinIndex - 1 do
    begin
      f_MarketData := CMKChartData.Create();
      f_MarketData.m_Year := p_QuotData.m_Year;
      f_MarketData.m_Month := p_QuotData.m_Month;
      f_MarketData.m_Day := p_QuotData.m_Day;

      f_Time := IndexToOpenTime(f_Index - m_ZeroIndex);
      f_MarketData.m_OpenDateTime := EncodeDateTime(p_QuotData.m_Year, p_QuotData.m_Month, p_QuotData.m_Day,
          CFNPOTItem.NumberToHour(f_Time), CFNPOTItem.NumberToMin(f_Time), CFNPOTItem.NumberToSec(f_Time), 0);

      f_Time := IndexToCloseTime(f_Index - m_ZeroIndex);
      f_MarketData.m_CloseDateTime := EncodeDateTime(p_QuotData.m_Year, p_QuotData.m_Month, p_QuotData.m_Day,
          CFNPOTItem.NumberToHour(f_Time), CFNPOTItem.NumberToMin(f_Time), CFNPOTItem.NumberToSec(f_Time), 0);

      f_MarketData.m_Hour := CFNPOTItem.NumberToHour(f_Time);
      f_MarketData.m_Min := CFNPOTItem.NumberToMin(f_Time);
      f_MarketData.m_Sec := CFNPOTItem.NumberToSec(f_Time);

      if ((m_OldMinIndexOnToday >= 0) and (f_Index > 0)) then
      begin
        f_MarketData.m_OpenOPS := CMKChartData(m_Items.Items[f_Index - 1]).m_CloseOPS;
        f_MarketData.m_HighOPS := f_MarketData.m_OpenOPS;
        f_MarketData.m_LowOPS := f_MarketData.m_OpenOPS;
        f_MarketData.m_CloseOPS := f_MarketData.m_OpenOPS;

        f_MarketData.m_OpenPrice := CMKChartData(m_Items.Items[f_Index - 1]).m_ClosePrice;
        f_MarketData.m_HighPrice := f_MarketData.m_OpenPrice;
        f_MarketData.m_LowPrice := f_MarketData.m_OpenPrice;
        f_MarketData.m_ClosePrice := f_MarketData.m_OpenPrice;

        f_MarketData.m_Volume := 0;
      end
      else
      begin
        f_MarketData.m_OpenOPS := p_QuotData.m_CloseOPS;
        f_MarketData.m_HighOPS := f_MarketData.m_OpenOPS;
        f_MarketData.m_LowOPS := f_MarketData.m_OpenOPS;
        f_MarketData.m_CloseOPS := f_MarketData.m_OpenOPS;

        f_MarketData.m_OpenPrice := p_QuotData.m_ClosePrice;
        f_MarketData.m_HighPrice := f_MarketData.m_OpenPrice;
        f_MarketData.m_LowPrice := f_MarketData.m_OpenPrice;
        f_MarketData.m_ClosePrice := f_MarketData.m_OpenPrice;

        f_MarketData.m_Volume := 0;
      end;

      m_Items.Add(f_MarketData);
      Inc(f_AddCount);
    end;
{$ENDREGION}
{$REGION '신규 바를 생성하여 넣어 준다.'}
    f_MarketData := CMKChartData.Create();
    f_MarketData.m_Year := p_QuotData.m_Year;
    f_MarketData.m_Month := p_QuotData.m_Month;
    f_MarketData.m_Day := p_QuotData.m_Day;
    f_MarketData.m_Hour := p_QuotData.m_Hour;
    f_MarketData.m_Min := p_QuotData.m_Min;
    f_MarketData.m_Sec := p_QuotData.m_Sec;

    f_Time := IndexToOpenTime(m_NewMinIndex - m_ZeroIndex);
    f_MarketData.m_OpenDateTime := EncodeDateTime(p_QuotData.m_Year, p_QuotData.m_Month, p_QuotData.m_Day,
        CFNPOTItem.NumberToHour(f_Time), CFNPOTItem.NumberToMin(f_Time), CFNPOTItem.NumberToSec(f_Time), 0);

    f_MarketData.m_CloseDateTime := p_QuotData.m_DateTime;

    f_MarketData.m_OpenOPS := p_QuotData.m_CloseOPS;
    f_MarketData.m_CloseOPS := p_QuotData.m_CloseOPS;
    f_MarketData.m_HighOPS := p_QuotData.m_CloseOPS;
    f_MarketData.m_LowOPS := p_QuotData.m_CloseOPS;

    if f_MarketData.m_HighOPS < f_MarketData.m_OpenOPS then
      f_MarketData.m_HighOPS := f_MarketData.m_OpenOPS;
    if f_MarketData.m_LowOPS > f_MarketData.m_OpenOPS then
      f_MarketData.m_LowOPS := f_MarketData.m_OpenOPS;

    f_MarketData.m_OpenPrice := p_QuotData.m_ClosePrice;
    f_MarketData.m_ClosePrice := p_QuotData.m_ClosePrice;
    f_MarketData.m_HighPrice := p_QuotData.m_ClosePrice;
    f_MarketData.m_LowPrice := p_QuotData.m_ClosePrice;

    if f_MarketData.m_HighPrice < f_MarketData.m_OpenPrice then
      f_MarketData.m_HighPrice := f_MarketData.m_OpenPrice;
    if f_MarketData.m_LowPrice > f_MarketData.m_OpenPrice then
      f_MarketData.m_LowPrice := f_MarketData.m_OpenPrice;

    f_MarketData.m_Volume := p_QuotData.m_Volume;

    f_MarketData.m_OpenDateTime := GetOpenDateTime(f_MarketData.m_OpenDateTime, 0);

    m_Items.Add(f_MarketData);

    Inc(f_AddCount);
{$ENDREGION}
  end
  else if (m_NewMinIndex = m_OldMinIndex) then
  begin
{$REGION '이전 바와 지금 바의 위치가 같을 경우, 저가와 고가를 계산하고, 누적거래량을 합산한다.'}
    f_MarketData := CMKChartData(m_Items.Items[m_NewMinIndex]);
    f_MarketData.m_Year := p_QuotData.m_Year;
    f_MarketData.m_Month := p_QuotData.m_Month;
    f_MarketData.m_Day := p_QuotData.m_Day;
    f_MarketData.m_Hour := p_QuotData.m_Hour;
    f_MarketData.m_Min := p_QuotData.m_Min;
    f_MarketData.m_Sec := p_QuotData.m_Sec;

    f_MarketData.m_CloseDateTime := p_QuotData.m_DateTime;

    if (f_MarketData.m_HighOPS < p_QuotData.m_CloseOPS) then
      f_MarketData.m_HighOPS := p_QuotData.m_CloseOPS;
    if (f_MarketData.m_LowOPS > p_QuotData.m_CloseOPS) then
      f_MarketData.m_LowOPS := p_QuotData.m_CloseOPS;

    f_MarketData.m_CloseOPS := p_QuotData.m_CloseOPS;

    if (f_MarketData.m_HighPrice < p_QuotData.m_ClosePrice) then
      f_MarketData.m_HighPrice := p_QuotData.m_ClosePrice;
    if (f_MarketData.m_LowPrice > p_QuotData.m_ClosePrice) then
      f_MarketData.m_LowPrice := p_QuotData.m_ClosePrice;

    f_MarketData.m_ClosePrice := p_QuotData.m_ClosePrice;

    f_MarketData.m_Volume := f_MarketData.m_Volume + p_QuotData.m_Volume;

    f_AddCount := 0;
{$ENDREGION}
  end
  else
  begin
    f_AddCount := 0;
  end;

  Result := f_AddCount;
end;

function CMKStreamChartDataSeries.UpdateQuotDataToDay(p_QuotData: CFNQuotData): Integer;
var
  f_Index: Integer;
  f_FindIndex: Integer;
  f_MarketData: CMKChartData;
begin
  f_FindIndex := SearchDayByClose(p_QuotData.m_DateTime, true);

  if (f_FindIndex < 0) then
  begin

    f_MarketData := CMKChartData.Create();

    f_MarketData.m_Year := p_QuotData.m_Year;
    f_MarketData.m_Month := p_QuotData.m_Month;
    f_MarketData.m_Day := p_QuotData.m_Day;
    f_MarketData.m_Hour := p_QuotData.m_Hour;
    f_MarketData.m_Min := p_QuotData.m_Min;
    f_MarketData.m_Sec := p_QuotData.m_Sec;

    f_MarketData.m_OpenDateTime := p_QuotData.m_DateTime;
    f_MarketData.m_CloseDateTime := p_QuotData.m_DateTime;

    f_MarketData.m_OpenPrice := p_QuotData.m_OpenPrice;
    f_MarketData.m_ClosePrice := p_QuotData.m_ClosePrice;
    f_MarketData.m_HighPrice := p_QuotData.m_HighPrice;
    f_MarketData.m_LowPrice := p_QuotData.m_LowPrice;

    f_MarketData.m_OpenOPS := p_QuotData.m_OpenOPS;
    f_MarketData.m_CloseOPS := p_QuotData.m_CloseOPS;
    f_MarketData.m_HighOPS := p_QuotData.m_HighOPS;
    f_MarketData.m_LowOPS := p_QuotData.m_LowOPS;

    f_MarketData.m_Volume := p_QuotData.m_TotalVolume;

    m_Items.Add(f_MarketData);

    Result := 1;
  end
  else
  begin

    f_MarketData := m_Items[f_FindIndex];
    f_MarketData.m_Year := p_QuotData.m_Year;
    f_MarketData.m_Month := p_QuotData.m_Month;
    f_MarketData.m_Day := p_QuotData.m_Day;
    f_MarketData.m_Hour := p_QuotData.m_Hour;
    f_MarketData.m_Min := p_QuotData.m_Min;
    f_MarketData.m_Sec := p_QuotData.m_Sec;

    f_MarketData.m_CloseDateTime := p_QuotData.m_DateTime;

    if (f_MarketData.m_HighOPS < p_QuotData.m_CloseOPS) then
      f_MarketData.m_HighOPS := p_QuotData.m_CloseOPS;
    if (f_MarketData.m_LowOPS > p_QuotData.m_CloseOPS) then
      f_MarketData.m_LowOPS := p_QuotData.m_CloseOPS;

    f_MarketData.m_CloseOPS := p_QuotData.m_CloseOPS;

    if (f_MarketData.m_HighPrice < p_QuotData.m_ClosePrice) then
      f_MarketData.m_HighPrice := p_QuotData.m_ClosePrice;
    if (f_MarketData.m_LowPrice > p_QuotData.m_ClosePrice) then
      f_MarketData.m_LowPrice := p_QuotData.m_ClosePrice;

    f_MarketData.m_ClosePrice := p_QuotData.m_ClosePrice;

    f_MarketData.m_Volume := f_MarketData.m_Volume + p_QuotData.m_Volume;

    Result := 0;
  end;
end;

// ---------------------------------------------------------------------------
function CMKStreamChartDataSeries.UpdateStreamQuotData(p_StreamRecord: CFNStreamRecord): Integer;
begin
  m_StreamQuotData.OPSStreamDataToData(p_StreamRecord);
  Result := UpdateQuotData(m_StreamQuotData);
end;

// ---------------------------------------------------------------------------
// 당일의 시작위치를 찾는다.
function CMKStreamChartDataSeries.FindZeroIndex(p_Date: TDateTime): Integer;
var
  f_MarketData: CMKChartData;
  f_Index: Integer;
  f_ZeroIndex: Integer;
  arrDateTime: array [0 .. 4] of Word;
  m_OldMinIndexOnToday: Integer;
  m_NewMinIndexOnToday: Integer;
begin
  f_ZeroIndex := -1;

  f_Index := m_Items.Count - 1;
  while (f_Index >= 0) do
  begin
    f_MarketData := CMKChartData(m_Items.Items[f_Index]);
    if (not SameDate(f_MarketData.m_OpenDateTime, p_Date)) then // 년/월/일 비교
    begin
      f_ZeroIndex := f_Index + 1;
      break;
    end;

    Dec(f_Index);
  end;

  if (f_ZeroIndex = -1) then
  begin
    if (0 < m_Items.Count) then
    begin
      f_MarketData := CMKChartData(m_Items.Items[0]);

      DecodeTime(f_MarketData.m_OpenDateTime, arrDateTime[0], arrDateTime[1], arrDateTime[2], arrDateTime[3]);
      f_ZeroIndex := CloseTimeToIndex(arrDateTime[0], arrDateTime[1], arrDateTime[2] - 1);
      if (f_ZeroIndex > 0) then
        f_ZeroIndex := 0;
      f_ZeroIndex := f_ZeroIndex * (-1);

    end;
  end;

  if (f_ZeroIndex = -1) then
  begin
    f_ZeroIndex := 0;
  end;

  // 가장마지막바의 날짜를 기록한다.
  // 이유는 실시간으로 업데이터 되는 시세의 날짜와 비교하여, 새로운 날짜의 데이터인가를 판별하기 위함
  // 새로운 날짜의 데이터이면 데일리갭을 보정해 주기 위함

  if m_Items.Count > 0 then
  begin
    f_MarketData := CMKChartData(m_Items.Items[m_Items.Count - 1]);
    m_LastDateTimeOnChartBar := Trunc(f_MarketData.m_OpenDateTime);

    if m_LastDateTimeOnChartBar = Trunc(Now) then
    begin
      if f_ZeroIndex >= 0 then
      begin
        DecodeTime(f_MarketData.m_OpenDateTime, arrDateTime[0], arrDateTime[1], arrDateTime[2], arrDateTime[3]); // 시, 분, 초
        m_NewMinIndexOnToday := CloseTimeToIndex(arrDateTime[0], arrDateTime[1], arrDateTime[2]);

        m_OldMinIndex := m_Items.Count - 1;
        m_OldMinIndexOnToday := m_OldMinIndex - m_ZeroIndex;

      end
      else
      begin
      end;
    end
    else
    begin
    end;
  end
  else
  begin
    m_LastDateTimeOnChartBar := 0;
  end;

  Result := f_ZeroIndex;
end;

// ---------------------------------------------------------------------------
// 시세가 업데이터 될때 F_FindZeroIndex를 상용하여 당일의 최초 바의 인덱스값을 구하도록 한다.
procedure CMKStreamChartDataSeries.FindZeroNextTime;
begin
  m_DoFindZeroIndex := true;
end;

// ---------------------------------------------------------------------------
// 스트리밍 데이터를 요청하기 전에 미리 계산해 두고 준비해 두어야 하는 작업을 한다.
// 이러한 작업은
// 각 시간대 별로 얼마의 차트의 바의 수가 존재 하는 지를 계산한다.
// 중국의 경우는 거래시간이 2개가 있다, 오전 2시간 오후 2시간, 1분바의 경우에 오전에 120개, 오후에 120가 존재하며
// 오전시간대의 m_MaxIndex는 120 이고
// 오후시간대의 m_MaxIndex는 240 이다.
procedure CMKStreamChartDataSeries.ReadyStream;
var
  f_TradingHour: Double;
  f_HourIndex: Integer;
begin

  // 일중데이터 일 경우
  if (m_TimeFrame >= 9000) then
  begin
    m_CoreOfDay := (86400.0 / (m_TimeFrame - 9000));
  end
  else if (m_TimeFrame < 360) then
  begin
    m_CoreOfDay := (86400.0 / (m_TimeFrame * 60)); // 1분바 이면 1440
  end
  else
  begin
    m_CoreOfDay := 0;
  end;

  f_TradingHour := 0;
  for f_HourIndex := 0 to m_POTItem.m_HourCount - 1 do
  begin
    f_TradingHour := f_TradingHour + (m_POTItem.m_Close[f_HourIndex] - m_POTItem.m_Open[f_HourIndex]);
    m_POTItem.m_MaxIndex[f_HourIndex] := Math.floor((f_TradingHour * m_CoreOfDay) / 86400.0);
  end;

  // 전 시세의 누적 거래량을 0으로 초기화 한다.
  m_OldQuotTotalVolume := 0;

  // 이전 시세의 시간을 null로 초기화 한다.
  m_OldQuotDateTime := 0;
  m_DoFindZeroIndex := FALSE;
  m_LastDateTimeOnChartBar := 0;

end;

// ---------------------------------------------------------------------------
// 시간을 하루중의 몇 번째 바의 인덱인지 계산한다. 이때 이 시간은 분바의 마감시간이다.
procedure CMKStreamChartDataSeries.AdjustData;
var
  f_OldMarketData: CMKChartData;
  f_NewMarketData: CMKChartData;
  f_Index: Integer;
begin
  f_Index := m_Items.Count - 1;
  for f_Index := 1 to m_Items.Count - 1 do
  begin
    f_OldMarketData := m_Items.Items[f_Index - 1];
    f_NewMarketData := m_Items.Items[f_Index];

    if f_OldMarketData.m_ClosePrice = 0 then
      continue;

    if abs((f_NewMarketData.m_ClosePrice - f_OldMarketData.m_ClosePrice) * 100.0 / f_OldMarketData.m_ClosePrice) > 15.0 then
    begin
      if abs((f_NewMarketData.m_OpenPrice - f_OldMarketData.m_ClosePrice) * 100.0 / f_OldMarketData.m_ClosePrice) > 15.0 then
      begin
        f_NewMarketData.m_OpenPrice := f_OldMarketData.m_ClosePrice;
        f_NewMarketData.m_ClosePrice := f_OldMarketData.m_ClosePrice;
      end
      else
      begin
        f_NewMarketData.m_ClosePrice := f_NewMarketData.m_OpenPrice;
      end;
    end;

    if abs((f_NewMarketData.m_OpenPrice - f_OldMarketData.m_ClosePrice) * 100.0 / f_OldMarketData.m_ClosePrice) > 15.0 then
    begin
      f_NewMarketData.m_OpenPrice := f_OldMarketData.m_ClosePrice;
    end;

    if abs((f_NewMarketData.m_HighPrice - f_OldMarketData.m_ClosePrice) * 100.0 / f_OldMarketData.m_ClosePrice) > 15.0 then
    begin
      f_NewMarketData.m_HighPrice := f_NewMarketData.m_ClosePrice;
    end;

    if abs((f_NewMarketData.m_LowPrice - f_OldMarketData.m_ClosePrice) * 100.0 / f_OldMarketData.m_ClosePrice) > 15.0 then
    begin
      f_NewMarketData.m_LowPrice := f_NewMarketData.m_ClosePrice;
    end;

    if (f_NewMarketData.m_HighPrice < f_NewMarketData.m_OpenPrice) then
    begin
      f_NewMarketData.m_HighPrice := f_NewMarketData.m_OpenPrice;
    end;
    if (f_NewMarketData.m_HighPrice < f_NewMarketData.m_ClosePrice) then
    begin
      f_NewMarketData.m_HighPrice := f_NewMarketData.m_ClosePrice;
    end;

    if (f_NewMarketData.m_LowPrice > f_NewMarketData.m_OpenPrice) then
    begin
      f_NewMarketData.m_LowPrice := f_NewMarketData.m_OpenPrice;
    end;
    if (f_NewMarketData.m_LowPrice > f_NewMarketData.m_ClosePrice) then
    begin
      f_NewMarketData.m_LowPrice := f_NewMarketData.m_ClosePrice;
    end;
  end;
end;

// ---------------------------------------------------------------------------
function CMKStreamChartDataSeries.CloseTimeToIndex(p_Hour, p_Min, p_Sec: Integer): Integer;
var
  f_HourIndex: Integer;
  f_Index: Integer;
  f_MaxIndex: Integer;
  f_TradingHour: Double;
  f_Time: Double;
begin
  // 일중데이터 일 경우
  if (m_TimeFrame >= 9000) then
  begin
    m_CoreOfDay := (86400.0 / (m_TimeFrame - 9000));
  end
  else if (m_TimeFrame < 360) then
  begin
    m_CoreOfDay := (86400.0 / (m_TimeFrame * 60)); // 1분바 이면 1440
  end
  else
  begin
    m_CoreOfDay := 0;
  end;

  f_Time := CFNPOTItem.TimeToNumber(p_Hour, p_Min, p_Sec);
  f_TradingHour := 0;
  f_MaxIndex := 0;

  for f_HourIndex := 0 to m_POTItem.m_HourCount - 1 do
  begin
    f_MaxIndex := m_POTItem.m_MaxIndex[f_HourIndex];
    if (f_Time > m_POTItem.m_Close[f_HourIndex]) then
    begin
      f_TradingHour := f_TradingHour + (m_POTItem.m_Close[f_HourIndex] - m_POTItem.m_Open[f_HourIndex]);
      if (f_HourIndex + 1 = m_POTItem.m_HourCount) then
        break
      else if (f_Time < m_POTItem.m_Open[f_HourIndex + 1]) then
        break
      else
        continue;
    end
    else
    begin
      f_TradingHour := f_TradingHour + (f_Time - m_POTItem.m_Open[f_HourIndex]);
      break;
    end;
  end;

  f_Index := Math.floor((f_TradingHour * m_CoreOfDay) / 86400.0);
  if (f_Index >= f_MaxIndex) then
    f_Index := f_MaxIndex - 1;

  Result := f_Index;
end;

// ---------------------------------------------------------------------------
// 해당 인덱스의 마감 시간을 계산한다.
function CMKStreamChartDataSeries.IndexToCloseTime(p_Index: Integer): Double;
var
  f_OpenTime: Double;
  f_FindTime: Double;
  f_Zero: Integer;
  f_HourIndex: Integer;
  f_Done: Boolean;
  f_OldMaxIndex: Integer;
  f_NewMaxIndex: Integer;
begin
  f_Done := FALSE;
  // 일중데이터 일 경우
  if (m_TimeFrame >= 9000) then
  begin
    m_CoreOfDay := (86400.0 / (m_TimeFrame - 9000));
  end
  else if (m_TimeFrame < 360) then
  begin
    m_CoreOfDay := (86400.0 / (m_TimeFrame * 60)); // 1분바 이면 1440
  end
  else
  begin
    m_CoreOfDay := 0;
  end;

  f_OpenTime := 0;
  f_FindTime := 0;
  f_Zero := 0;
  f_OldMaxIndex := 0;
  f_NewMaxIndex := 0;

  for f_HourIndex := 0 to m_POTItem.m_HourCount - 1 do
  begin
    f_NewMaxIndex := m_POTItem.m_MaxIndex[f_HourIndex];
    if (p_Index < 0) then
    begin
      f_FindTime := m_POTItem.m_Open[f_HourIndex] + 86400.0 / m_CoreOfDay;
      f_Done := true;
      break;
    end
    else if ((f_OldMaxIndex <= p_Index) and (p_Index < f_NewMaxIndex)) then
    begin
      f_OpenTime := m_POTItem.m_Open[f_HourIndex];
      f_Zero := f_OldMaxIndex;
      f_FindTime := f_OpenTime + (p_Index - f_Zero + 1) * 86400.0 / m_CoreOfDay;
      f_Done := true;
      break;
    end
    else
    begin
      f_Done := FALSE;
    end;

    f_Zero := f_OldMaxIndex;
    f_OpenTime := m_POTItem.m_Open[f_HourIndex];
    f_OldMaxIndex := f_NewMaxIndex;
  end;

  if (not f_Done) then
    f_FindTime := f_OpenTime + ((f_NewMaxIndex - 1) - f_Zero + 1) * 86400.0 / m_CoreOfDay;

  Result := f_FindTime;
end;

// ---------------------------------------------------------------------------
function CMKStreamChartDataSeries.GetOpenDateTime(p_CloseDateTime: Double; p_Factor: Integer): Double;
var

  Year: Word;
  Month: Word;
  Day: Word;
  Hour: Word;
  Min: Word;
  Sec: Word;
  MilSec: Word;
  f_CloseIndex: Integer;
  f_Alpha: Double;
begin
  // 초데이터 일 경우
  if (m_TimeFrame >= 9000) then
  begin
    f_Alpha := (m_TimeFrame - 9000) / 86400.0
  end
  else
    // 분데이터 일 경우
    if (m_TimeFrame < 360) then
    begin
      f_Alpha := (m_TimeFrame * 60) / 86400.0
    end
    else
    begin
      DecodeDate(p_CloseDateTime, Year, Month, Day);
      Result := EncodeDate(Year, Month, Day) + m_POTItem.m_Open[0];
      exit;
    end;

  DecodeDateTime(p_CloseDateTime, Year, Month, Day, Hour, Min, Sec, MilSec);
  f_CloseIndex := CloseTimeToIndex(Hour, Min, Sec - p_Factor);
  Result := EncodeDateTime(Year, Month, Day, CFNPOTItem.NumberToHour(IndexToCloseTime(f_CloseIndex)),
      CFNPOTItem.NumberToMin(IndexToCloseTime(f_CloseIndex)), CFNPOTItem.NumberToSec(IndexToCloseTime(f_CloseIndex)), 0)
      - f_Alpha;
end;

// ---------------------------------------------------------------------------
// 해당 인덱스의 시작 시간을 계산한다.
function CMKStreamChartDataSeries.IndexToOpenTime(p_Index: Integer): Double;
var
  f_OpenTime: Double;
  f_FindTime: Double;
  f_Zero: Integer;
  f_HourIndex: Integer;
  f_Done: Boolean;
  f_OldMaxIndex: Integer;
  f_NewMaxIndex: Integer;
begin
  f_Done := FALSE;

  // 초데이터 일 경우
  if (m_TimeFrame >= 9000) then
  begin
    m_CoreOfDay := (86400.0 / (m_TimeFrame - 9000));
  end
  else
    // 분데이터 일 경우
    if (m_TimeFrame < 360) then
    begin
      m_CoreOfDay := (86400.0 / (m_TimeFrame * 60));
    end
    else
    begin
      m_CoreOfDay := 0;
    end;

  f_OpenTime := 0;
  f_FindTime := 0;
  f_Zero := 0;
  f_OldMaxIndex := 0;
  f_NewMaxIndex := 0;

  for f_HourIndex := 0 to m_POTItem.m_HourCount - 1 do
  begin
    f_NewMaxIndex := m_POTItem.m_MaxIndex[f_HourIndex];
    if (p_Index < 0) then
    begin
      f_FindTime := m_POTItem.m_Open[f_HourIndex];
      f_Done := true;
      break;
    end
    else if ((f_OldMaxIndex <= p_Index) and (p_Index < f_NewMaxIndex)) then
    begin
      f_OpenTime := m_POTItem.m_Open[f_HourIndex];
      f_Zero := f_OldMaxIndex;
      f_FindTime := f_OpenTime + (p_Index - f_Zero) * 86400.0 / m_CoreOfDay;
      f_Done := true;
      break;
    end
    else
    begin
      f_Done := FALSE;
    end;

    f_Zero := f_OldMaxIndex;
    f_OpenTime := m_POTItem.m_Open[f_HourIndex];
    f_OldMaxIndex := f_NewMaxIndex;
  end;

  if (not f_Done) then
    f_FindTime := f_OpenTime + ((f_NewMaxIndex - 1) - f_Zero) * 86400.0 / m_CoreOfDay;

  Result := f_FindTime;
end;

end.
