unit FNMatrixChartDataSeries;

interface
uses
    SysUtils, Classes, Math, DateUtils, FNMatrixChartData, FNPOTCollection, FNQuotData, FNDataSet;

const
    MAX_TICK_GAP    =   0.1618;

type
//---------------------------------------------------------------------------
    CFNMatrixChartDataSeries = class(TObject)
    public
        m_Items     : TList;
        m_TimeFrame : Integer;
        m_Precision : Integer;

        m_Country   : Integer;
        m_Group     : Integer;
        m_Market    : Integer;
        m_Symbol    : String;
        m_Name      : String;

        m_POTData           : CFNPOTItem;       // 해당 주식의 당일의 거래시간정보가 저장된 객체
        m_CoreOfDay         : Double;           // 1일 기준으로 발생할 수 있는 바의 수.	1분 바의 경우 1440개 있다. 24*60
        m_ZeroIndex         : Integer;          // 당일의 데이터가 시작되는 지점의 배열순번
        m_OldMinIndex       : Integer;          // 이전 시세가 전달 받았을 때, 갱신한 배열순번
        m_NewMinIndex       : Integer;          // 새로운 시세가 전달 받았을 때, 갱신할 배열순번
        m_OldQuotDateTime   : TDateTime;        // 이전 시세의 거래 시간
        m_OldQuotTotalVolume: Double;           // 이전 시세의 누적거래량

        m_OffsetIndex       :   Integer;

        // 외부에서 당일의 처음 시작위치를 재 계산하라는 의미로 그 값을 설정할 때 사용한다.
        // 기존 앞쪽에 새로운 차트데이터를 덧붙여 던지...
        m_DoFindZeroIndex   : Boolean;

        // 스트리밍으로 받은 객체 CFNStreamRecord를  FNQuotData 객체에 변환해서 저장한다.
        // 이렇게 함으로써 맵의 반복적인 사용에 따른 오버 해드를 감소시키고, 소스의 가독성을 증가시킨다.
        m_QuotData          : CFNQuotData;

        m_LastDateTimeOnChartBar : TDateTime;   //  차트데이터의 마지막바에 기록된 날짜


        m_TickDataFactor : Double;
        m_UsesFix : Boolean;

    public
        constructor Create;
        destructor  Destroy; override;

        procedure Clear;
        function SearchByClose(p_TimeDate:TDateTime; p_Nearest:Boolean) : Integer;

        procedure Add(p_MarketData:CFNMatrixChartData);
        procedure Clone(p_Source:CFNMatrixChartDataSeries);
        procedure Update(p_Source: CFNMatrixChartDataSeries);

        procedure SetPOTData(p_POTData:CFNPOTItem);
        function FindZeroIndex(p_Date:TDateTime) : Integer;

        procedure FindZeroNextTime();
        procedure ReadyStream();
        function CloseTimeToIndex(p_Hour:Integer; p_Min:Integer; p_Sec:Integer) : Integer;
        function IndexToCloseTime(p_Index:Integer) : Double;
        function IndexToOpenTime(p_Index:Integer) : Double;

        function GetOpenDateTime(p_CloseDateTime:Double; p_Factor:Integer) : Double;

        function UpdateQuotData(p_QuotData:CFNQuotData; var p_ChangeDailyGap:Boolean; p_DeleteGap:Boolean) : Integer;
        function UpdateQuotDataToMin(p_QuotData:CFNQuotData; var p_ChangeDailyGap:Boolean) : Integer;

        procedure CalcDailyGapFactor(p_DeleteGap:Boolean);
        procedure Fix;
    end;

implementation

uses FNGlobal;

//---------------------------------------------------------------------------
constructor CFNMatrixChartDataSeries.Create;
begin
    inherited Create;

    m_UsesFix                   := false;
    m_TickDataFactor            := 0;

    m_Items                     := TList.Create;
    m_Precision                 := 0;
    m_TimeFrame                 := 360;

    m_POTData                   := CFNPOTItem.Create();
    m_QuotData                  := CFNQuotData.Create();
    m_ZeroIndex                 := 0;
    m_OldQuotTotalVolume        := 0;
    m_OldQuotDateTime           := 0;
    m_OldMinIndex 		        := -1;
    m_NewMinIndex 		        := -1;
    m_DoFindZeroIndex 	        := FALSE;

    m_LastDateTimeOnChartBar    := 0;
    m_OffsetIndex               := 0;
end;

destructor CFNMatrixChartDataSeries.Destroy;
begin
    Clear;

    m_Items.Free;
    m_Items := NIL;

    m_POTData.Free();
    m_QuotData.Free();
    inherited Destroy;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixChartDataSeries.CalcDailyGapFactor(p_DeleteGap:Boolean);
var
    f_MarketData0:CFNMatrixChartData;
    f_MarketData1:CFNMatrixChartData;
    f_Index:Integer;

    f_QuarkFactor:Double;
    f_RealFactor:Double;
begin
    for f_Index := 0 to m_Items.Count - 1 do
    begin
        f_MarketData0 := CFNMatrixChartData(m_Items.Items[f_Index]);

        f_MarketData0.m_QuarkFactor := 0;
        f_MarketData0.m_RealFactor := 0;
    end;

    if (p_DeleteGap) then
    begin
        f_QuarkFactor := 0;
        f_RealFactor := 0;
        for f_Index :=  m_Items.Count-1 downto  1 do
        begin
            f_MarketData1 := m_Items[f_Index-1];
            f_MarketData0 := m_Items[f_Index-0];
            if (not SameDate(f_MarketData1.m_OpenDateTime, f_MarketData0.m_OpenDateTime)) then
            begin
                f_QuarkFactor := f_QuarkFactor + (f_MarketData0.m_CloseQuarkPrice - f_MarketData1.m_CloseQuarkPrice);
                f_RealFactor := f_RealFactor + (f_MarketData0.m_CloseRealPrice - f_MarketData1.m_CloseRealPrice);
            end;
            f_MarketData1.m_QuarkFactor := f_QuarkFactor;
            f_MarketData1.m_RealFactor := f_RealFactor;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixChartDataSeries.Clear;
begin
    while 0 < m_Items.Count  do
    begin
        CFNMatrixChartData(m_Items.Items[0]).Free;
        m_Items.Delete(0);
    end;
end;

//---------------------------------------------------------------------------
function CFNMatrixChartDataSeries.SearchByClose(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
var
    f_PosX          : Integer;
    f_PosL          : Integer;
    f_PosR          : Integer;
    f_RecordCount   : Integer;
    f_Compare       : Double;
    f_MarketData    : CFNMatrixChartData;
begin
    f_RecordCount   := m_Items.Count;
    if (0 < f_RecordCount) then
    begin
        f_PosL := 0;
        f_PosR := f_RecordCount - 1;

        repeat
            f_PosX          := Math.floor((f_PosL + f_PosR) / 2);
            f_MarketData    := CFNMatrixChartData(m_Items.Items[f_PosX]);
            f_Compare       := p_TimeDate - f_MarketData.m_OpenDateTime;
            if (0 > f_Compare) then
                f_PosR := f_PosX - 1
            else
                f_PosL := f_PosX + 1;
        until (not ((f_Compare <> 0) and (f_PosL <= f_PosR)));

        if (0 = f_Compare) then
            Result := f_PosX
        else if (p_Nearest) then
            if (f_PosL >= f_RecordCount) then
                Result := -1
            else
                Result := f_PosL
        else
            Result := -1;

    end else
    begin
        Result := -1;
    end;
end;
//---------------------------------------------------------------------------
procedure CFNMatrixChartDataSeries.Add(p_MarketData: CFNMatrixChartData);
var
    f_SearchIndex   : Integer;
begin
    //데이터가 하나라도 존재하면
    if (0 < m_Items.Count) then
    begin
        //만약 추가할 데이터의 날짜가 가장앞쪽의 데이터 보다 작다면 가장앞에 넣는다.
        if (p_MarketData.m_OpenDateTime < CFNMatrixChartData(m_Items.Items[0]).m_OpenDateTime) then
        begin
            m_Items.Insert(0, p_MarketData);
        end else
        begin
            //만약 추가할 데이터의 날짜가 가장 앞쪽의 데이터 보다 크다면 가장뒤에 넣는다.
            if (p_MarketData.m_OpenDateTime > CFNMatrixChartData(m_Items.Items[m_Items.Count - 1]).m_OpenDateTime) then
            begin
                m_Items.Add(p_MarketData);
            end else
            begin
                //추가할 위치를 찾아서 그 위치 바로 뒤에 넣는다.
                f_SearchIndex := SearchByClose(p_MarketData.m_OpenDateTime, TRUE);
                if (f_SearchIndex >= 0) then
                begin
                    if (p_MarketData.m_OpenDateTime = CFNMatrixChartData(m_Items.Items[f_SearchIndex]).m_OpenDateTime) then
                    begin
                        CFNMatrixChartData(m_Items.Items[f_SearchIndex]).Free;
                        m_Items.Items[f_SearchIndex] := p_MarketData
                    end
                    else
                        m_Items.Insert(f_SearchIndex, p_MarketData);
                end;
            end;
        end;
    end else
    begin
        //데이터가 없다면 그냥 추가한다.
        m_Items.Add(p_MarketData);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixChartDataSeries.Clone(p_Source: CFNMatrixChartDataSeries);
var
    f_OldMarketData : CFNMatrixChartData;
    f_NewMarketData : CFNMatrixChartData;
    f_Index         : Integer;
begin
    Clear;
    if (p_Source <> NIL) then
    begin
        m_Country       := p_Source.m_Country;
        m_Group         := p_Source.m_Group;
        m_Market        := p_Source.m_Market;
        m_Symbol        := p_Source.m_Symbol;
        m_Name          := p_Source.m_Name;
        m_TimeFrame     := p_Source.m_TimeFrame;
        m_Precision     := p_Source.m_Precision;

        for f_Index := 0 to p_Source.m_Items.Count - 1 do
        begin
            f_OldMarketData := CFNMatrixChartData(p_Source.m_Items.Items[f_Index]);
            f_NewMarketData := CFNMatrixChartData.Create;
            f_NewMarketData.Clone(f_OldMarketData);
            m_Items.Add(f_NewMarketData);
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixChartDataSeries.Fix;
var
    f_MarketData0, f_MarketData1: CFNMatrixChartData;
    f_Index      : Integer;

    f_Factor     : Double;
    f_Value1      : Double;
    f_Value2      : Double;
begin
    if m_UsesFix then
    begin
        f_Factor := 0;
        for f_Index := 0 to m_Items.Count - 1 do
        begin
            if (f_Index > 0) then
            begin
                f_MarketData0 := CFNMatrixChartData(m_Items.Items[f_Index  ]);
                f_MarketData1 := CFNMatrixChartData(m_Items.Items[f_Index-1]);

                if (Trunc(f_MarketData1.m_OpenDateTime) <> Trunc(f_MarketData0.m_OpenDateTime)) then
                begin
                    f_Factor := 0;
                    continue;
                end;

                f_Value1 := f_MarketData0.m_OpenQuarkPrice - f_Factor - f_MarketData1.m_OpenQuarkPrice;
                f_Value2 := (f_Value1 / f_MarketData1.m_OpenQuarkPrice) * 100.0;

                if (abs(f_Value2) > MAX_TICK_GAP) then
                begin
                    f_Factor := f_Factor + (f_MarketData0.m_OpenQuarkPrice - f_Factor - f_MarketData1.m_OpenQuarkPrice);
                end;

                f_MarketData0.m_OpenQuarkPrice  := f_MarketData0.m_OpenQuarkPrice  - f_Factor;
                f_MarketData0.m_HighQuarkPrice  := f_MarketData0.m_HighQuarkPrice  - f_Factor;
                f_MarketData0.m_LowQuarkPrice   := f_MarketData0.m_LowQuarkPrice   - f_Factor;
                f_MarketData0.m_CloseQuarkPrice := f_MarketData0.m_CloseQuarkPrice - f_Factor;

            end;
        end;
        m_TickDataFactor := f_Factor;
    end else
    begin
        m_TickDataFactor := 0;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixChartDataSeries.Update(p_Source: CFNMatrixChartDataSeries);
var
    f_OldMarketData : CFNMatrixChartData;
    f_NewMarketData : CFNMatrixChartData;
    f_Index         : Integer;
    f_Begin, f_End : Integer;
begin

    if m_Items.Count > 0 then
    begin
        if (p_Source <> NIL) then
        begin
            f_Begin := m_Items.Count-1;
            if f_Begin < 0 then f_Begin := 0;
            f_End := p_Source.m_Items.Count;

            for f_Index := f_Begin to f_End - 1 do
            begin
                f_OldMarketData := CFNMatrixChartData(p_Source.m_Items.Items[f_Index]);
                if (f_Index < m_Items.Count) then
                begin
                    f_NewMarketData := m_Items[f_Index];
                    f_NewMarketData.Clone(f_OldMarketData);
                end else
                begin
                    f_NewMarketData := CFNMatrixChartData.Create;
                    f_NewMarketData.Clone(f_OldMarketData);
                    m_Items.Add(f_NewMarketData);
                end;
            end;
        end;
    end else
    begin
        Clone(p_Source);
    end;
end;

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//당일의 거래시간 정보를 설정한다.
procedure CFNMatrixChartDataSeries.SetPOTData(p_POTData: CFNPOTItem);
begin
    if Assigned(p_POTData) then m_POTData.Clone(p_POTData);
end;

//---------------------------------------------------------------------------
function CFNMatrixChartDataSeries.UpdateQuotData(p_QuotData: CFNQuotData; var p_ChangeDailyGap:Boolean; p_DeleteGap:Boolean): Integer;
var
    f_AddCount  : Integer;
begin

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
        end else
        begin
            m_QuotData.m_Volume := m_QuotData.m_TotalVolume - m_OldQuotTotalVolume;
            if m_QuotData.m_Volume < 0 then
            begin
                m_QuotData.m_Volume := 0;
            end;
        end;
    end;

    //	틱차트에서 사용하는 틱데이터 일 경우
    if (m_TimeFrame >= 9000) then
        f_AddCount := UpdateQuotDataToMin(m_QuotData, p_ChangeDailyGap)
    else if (m_TimeFrame < 360) then        //	분간데이터 일 경우
        f_AddCount := UpdateQuotDataToMin(m_QuotData, p_ChangeDailyGap)
    else
        f_AddCount := -1;

    if (m_LastDateTimeOnChartBar <> 0) AND (not SameDate(m_LastDateTimeOnChartBar, m_QuotData.m_DateTime)) then
    begin
        CalcDailyGapFactor(p_DeleteGap);
        if p_DeleteGap then p_ChangeDailyGap := true
        else p_ChangeDailyGap := false;
    end;

    m_OldQuotTotalVolume := m_QuotData.m_TotalVolume;
    m_OldQuotDateTime := m_QuotData.m_DateTime;
    m_LastDateTimeOnChartBar := m_QuotData.m_DateTime;

    Result := f_AddCount;
end;

//---------------------------------------------------------------------------
//분간차트데이터에 추가/갱신 한다. 리턴값은 신규로 추가된 바의 수이다
function CFNMatrixChartDataSeries.UpdateQuotDataToMin(p_QuotData: CFNQuotData; var p_ChangeDailyGap:Boolean): Integer;
var
    f_Time                  : Double;
    f_Index                 : Integer;
    //m_NewMinIndexOnToday    : Integer;
    m_OldMinIndexOnToday    : Integer;
    f_MarketData            : CFNMatrixChartData;
    f_MarketData1           : CFNMatrixChartData;
    f_AddCount              : Integer;
    arrDateTime             : Array [0..3] of Word;
    f_Value1, f_Value2      : Double;
begin
    f_AddCount := 0;

	//	이전에 받은 스트리밍 시세가 존재 하지 않고, 현재 시세가 가장 처음에 전달 받은 스트리밍 데이터 일 경우
	//	이 경우 당일의 가장 첫번째 데이터가 전체중에 몇번째 인지 계산한다.
    if (m_OldQuotDateTime = 0) then
    begin
        m_ZeroIndex := FindZeroIndex(p_QuotData.m_DateTime);
    end else

	//	이전에 받은 스트리밍 시세와 현재 받은 스트리밍 시세의 날짜가 다를 경우
    //	이 경우 당일의 가장 첫번째 데이터가 전체중에 몇번째 인지 계산한다.
    if (not SameDate(m_OldQuotDateTime, p_QuotData.m_DateTime)) then       //   년/월/일 비교
    begin
        m_ZeroIndex := FindZeroIndex(p_QuotData.m_DateTime);
    end else

    //	혹시 외부에서  함수 F_FindZeroNextTime를 호출하여 m_DoFindZeroIndex의 값을 true로 설정하였을 때
    //	이 경우 당일의 가장 첫번째 데이터가 전체중에 몇번째 인지 계산한다.
    if (m_DoFindZeroIndex) then
    begin
        m_ZeroIndex := FindZeroIndex(p_QuotData.m_DateTime);
        m_DoFindZeroIndex := FALSE;
    end else
    begin
        f_AddCount := 0;
    end;

    //	이전의 1분바의 위치를 계산한다.
    m_OldMinIndex := m_Items.Count-1;

    //	새로운 시세를 업데이터 할 바의 인덱스를 찾는다.
    DecodeTime(p_QuotData.m_DateTime, arrDateTime[0], arrDateTime[1], arrDateTime[2], arrDateTime[3]);       //시, 분, 초
    m_NewMinIndex := CloseTimeToIndex(arrDateTime[0], arrDateTime[1], arrDateTime[2]) - m_OffsetIndex;

    if (m_NewMinIndex < 0) then
    begin
        Result := -1;
        exit;
    end;

    m_NewMinIndex           := m_ZeroIndex + m_NewMinIndex;
    m_OldMinIndexOnToday    := m_OldMinIndex - m_ZeroIndex;

    //	이전 바와 지금 바의 위치가 다를 경우
    if (m_NewMinIndex > m_OldMinIndex) then
    begin
        //	이전 바와 현재 바사이에 허수 바를 생성하여 넣어 준다.
        for f_Index := m_OldMinIndex+1 to m_NewMinIndex - 1 do
        begin
            f_MarketData            := CFNMatrixChartData.Create();
            f_Time                  := IndexToOpenTime(f_Index-m_ZeroIndex+m_OffsetIndex);
            f_MarketData.m_Year     := p_QuotData.m_Year;
            f_MarketData.m_Month    := p_QuotData.m_Month;
            f_MarketData.m_Day      := p_QuotData.m_Day;
            f_MarketData.m_Hour     := CFNPOTItem.NumberToHour(f_Time);
            f_MarketData.m_Min      := CFNPOTItem.NumberToMin(f_Time);
            f_MarketData.m_Sec      := CFNPOTItem.NumberToSec(f_Time);
            f_MarketData.m_OpenDateTime := EncodeDateTime(f_MarketData.m_Year, f_MarketData.m_Month, f_MarketData.m_Day, f_MarketData.m_Hour, f_MarketData.m_Min, f_MarketData.m_Sec, 0);

            if ((m_OldMinIndexOnToday >= 0) and (f_Index > 0)) then
            begin
                f_MarketData.m_OpenQuarkPrice   := CFNMatrixChartData(m_Items.Items[f_Index-1]).m_CloseQuarkPrice;
                f_MarketData.m_HighQuarkPrice   := f_MarketData.m_OpenQuarkPrice;
                f_MarketData.m_LowQuarkPrice    := f_MarketData.m_OpenQuarkPrice;
                f_MarketData.m_CloseQuarkPrice  := f_MarketData.m_OpenQuarkPrice;

                f_MarketData.m_OpenRealPrice    := CFNMatrixChartData(m_Items.Items[f_Index-1]).m_CloseRealPrice;
                f_MarketData.m_HighRealPrice    := f_MarketData.m_OpenRealPrice;
                f_MarketData.m_LowRealPrice     := f_MarketData.m_OpenRealPrice;
                f_MarketData.m_CloseRealPrice   := f_MarketData.m_OpenRealPrice;
                f_MarketData.m_Volume           := 0;
            end else
            begin
                f_MarketData.m_OpenQuarkPrice   := p_QuotData.m_ClosePrice;
                f_MarketData.m_HighQuarkPrice   := f_MarketData.m_OpenQuarkPrice;
                f_MarketData.m_LowQuarkPrice    := f_MarketData.m_OpenQuarkPrice;
                f_MarketData.m_CloseQuarkPrice  := f_MarketData.m_OpenQuarkPrice;

                f_MarketData.m_OpenRealPrice    := p_QuotData.m_RealPrice;
                f_MarketData.m_HighRealPrice    := f_MarketData.m_OpenRealPrice;
                f_MarketData.m_LowRealPrice     := f_MarketData.m_OpenRealPrice;
                f_MarketData.m_CloseRealPrice   := f_MarketData.m_OpenRealPrice;
                f_MarketData.m_Volume           := 0;
            end;

            m_Items.Add(f_MarketData);
            Inc(f_AddCount);
        end;

        f_MarketData                    := CFNMatrixChartData.Create();
        f_MarketData.m_Year             := p_QuotData.m_Year;
        f_MarketData.m_Month            := p_QuotData.m_Month;
        f_MarketData.m_Day              := p_QuotData.m_Day;
        f_MarketData.m_Hour             := p_QuotData.m_Hour;
        f_MarketData.m_Min              := p_QuotData.m_Min;
        f_MarketData.m_Sec              := p_QuotData.m_Sec;

        f_MarketData.m_OpenDateTime     := p_QuotData.m_DateTime;

        f_MarketData.m_OpenQuarkPrice   := p_QuotData.m_ClosePrice;
        f_MarketData.m_CloseQuarkPrice  := p_QuotData.m_ClosePrice;
        f_MarketData.m_HighQuarkPrice   := p_QuotData.m_ClosePrice;
        f_MarketData.m_LowQuarkPrice    := p_QuotData.m_ClosePrice;

        if f_MarketData.m_HighQuarkPrice < f_MarketData.m_OpenQuarkPrice then f_MarketData.m_HighQuarkPrice := f_MarketData.m_OpenQuarkPrice;
        if f_MarketData.m_LowQuarkPrice  > f_MarketData.m_OpenQuarkPrice then f_MarketData.m_LowQuarkPrice  := f_MarketData.m_OpenQuarkPrice;

        f_MarketData.m_OpenRealPrice    := p_QuotData.m_RealPrice;
        f_MarketData.m_CloseRealPrice   := p_QuotData.m_RealPrice;
        f_MarketData.m_HighRealPrice    := p_QuotData.m_RealPrice;
        f_MarketData.m_LowRealPrice     := p_QuotData.m_RealPrice;

        if f_MarketData.m_HighRealPrice < f_MarketData.m_OpenRealPrice then f_MarketData.m_HighRealPrice := f_MarketData.m_OpenRealPrice;
        if f_MarketData.m_LowRealPrice  > f_MarketData.m_OpenRealPrice then f_MarketData.m_LowRealPrice  := f_MarketData.m_OpenRealPrice;

        f_MarketData.m_Volume           := p_QuotData.m_Volume;

        f_MarketData.m_OpenDateTime     := GetOpenDateTime(f_MarketData.m_OpenDateTime, 0);

        if m_UsesFix then
        begin
            if (m_NewMinIndex > 0) and (m_NewMinIndex > m_ZeroIndex) then
            begin
                f_MarketData1 := CFNMatrixChartData(m_Items.Items[m_NewMinIndex-1]);
            end else
            begin
                f_MarketData1 := NIL;
            end;

            if Assigned(f_MarketData1) then
            begin
                f_Value1 := f_MarketData.m_OpenQuarkPrice - m_TickDataFactor - f_MarketData1.m_OpenQuarkPrice;
                f_Value2 := (f_Value1 / f_MarketData1.m_OpenQuarkPrice) * 100.0;

                if (abs(f_Value2) > MAX_TICK_GAP) then
                begin
                    m_TickDataFactor := m_TickDataFactor + (f_MarketData.m_OpenQuarkPrice - m_TickDataFactor - f_MarketData1.m_OpenQuarkPrice);
                    f_MarketData.m_OpenQuarkPrice  := f_MarketData.m_OpenQuarkPrice  - m_TickDataFactor;
                    f_MarketData.m_CloseQuarkPrice  := f_MarketData.m_CloseQuarkPrice  - m_TickDataFactor;
                    f_MarketData.m_HighQuarkPrice  := f_MarketData.m_HighQuarkPrice  - m_TickDataFactor;
                    f_MarketData.m_LowQuarkPrice  := f_MarketData.m_LowQuarkPrice  - m_TickDataFactor;
                end;
            end;
        end;

        m_Items.Add(f_MarketData);

        Inc(f_AddCount);

    end else
    if (m_NewMinIndex = m_OldMinIndex) then
    begin
        //	이전 바와 지금 바의 위치가 같을 경우
        //	저가와 고가를 계산하고, 누적거래량을 합산한다.
        f_MarketData         := CFNMatrixChartData(m_Items.Items[m_NewMinIndex]);
        f_MarketData.m_Year  := p_QuotData.m_Year;
        f_MarketData.m_Month := p_QuotData.m_Month;
        f_MarketData.m_Day   := p_QuotData.m_Day;
        f_MarketData.m_Hour  := p_QuotData.m_Hour;
        f_MarketData.m_Min   := p_QuotData.m_Min;
        f_MarketData.m_Sec   := p_QuotData.m_Sec;

        if (f_MarketData.m_HighQuarkPrice < p_QuotData.m_ClosePrice) then f_MarketData.m_HighQuarkPrice := p_QuotData.m_ClosePrice  - m_TickDataFactor;
        if (f_MarketData.m_LowQuarkPrice  > p_QuotData.m_ClosePrice) then f_MarketData.m_LowQuarkPrice := p_QuotData.m_ClosePrice  - m_TickDataFactor;
        f_MarketData.m_CloseQuarkPrice    := p_QuotData.m_ClosePrice  - m_TickDataFactor;

        if (f_MarketData.m_HighRealPrice < p_QuotData.m_RealPrice) then f_MarketData.m_HighRealPrice := p_QuotData.m_RealPrice;
        if (f_MarketData.m_LowRealPrice  > p_QuotData.m_RealPrice) then f_MarketData.m_LowRealPrice  := p_QuotData.m_RealPrice;
        f_MarketData.m_CloseRealPrice    := p_QuotData.m_RealPrice;
        f_MarketData.m_Volume       := f_MarketData.m_Volume + p_QuotData.m_Volume;
        f_AddCount                  := 0;
    end else
    begin
        f_AddCount := 0;
    end;

    Result := f_AddCount;
end;

//---------------------------------------------------------------------------
//당일의 시작위치를 찾는다.
function CFNMatrixChartDataSeries.FindZeroIndex(p_Date: TDateTime): Integer;
var
    f_MarketData    : CFNMatrixChartData;
    f_Index         : Integer;
    f_ZeroIndex     : Integer;
    arrDateTime     : array [0..4] of Word;
    m_OldMinIndexOnToday:Integer;
    m_NewMinIndexOnToday:Integer;
begin
    f_ZeroIndex := -1;

    f_Index := m_Items.Count-1;
    while (f_Index >= 0) do
    begin
        f_MarketData := CFNMatrixChartData(m_Items.Items[f_Index]);
        if (not SameDate(f_MarketData.m_OpenDateTime, p_Date)) then        //년/월/일 비교
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
            f_MarketData    := CFNMatrixChartData(m_Items.Items[0]);

            DecodeTime(f_MarketData.m_OpenDateTime, arrDateTime[0], arrDateTime[1], arrDateTime[2], arrDateTime[3]);
            f_ZeroIndex     := CloseTimeToIndex(arrDateTime[0], arrDateTime[1], arrDateTime[2]-1);
            if (f_ZeroIndex > 0) then f_ZeroIndex := 0;
            f_ZeroIndex := f_ZeroIndex * (-1);

        end;
    end;

    if (f_ZeroIndex = -1) then
    begin
        f_ZeroIndex := 0;
    end;

    //  가장마지막바의 날짜를 기록한다.
    //  이유는 실시간으로 업데이터 되는 시세의 날짜와 비교하여, 새로운 날짜의 데이터인가를 판별하기 위함
    //  새로운 날짜의 데이터이면 데일리갭을 보정해 주기 위함

    if m_Items.Count > 0 then
    begin
        f_MarketData := CFNMatrixChartData(m_Items.Items[m_Items.Count-1]);
        m_LastDateTimeOnChartBar := Trunc(f_MarketData.m_OpenDateTime);

        if m_LastDateTimeOnChartBar = Trunc(Now) then
        begin
            if f_ZeroIndex >= 0 then
            begin
                DecodeTime(f_MarketData.m_OpenDateTime, arrDateTime[0], arrDateTime[1], arrDateTime[2], arrDateTime[3]);       //시, 분, 초
                m_NewMinIndexOnToday := CloseTimeToIndex(arrDateTime[0], arrDateTime[1], arrDateTime[2]);

                m_OldMinIndex := m_Items.Count-1;
                m_OldMinIndexOnToday  := m_OldMinIndex - m_ZeroIndex;

                m_OffsetIndex := m_NewMinIndexOnToday - m_OldMinIndexOnToday;
                m_OffsetIndex := 0;
            end else
            begin
                m_OffsetIndex := 0;
            end;
        end else
        begin
            m_OffsetIndex := 0;
        end;
    end else
    begin
        m_LastDateTimeOnChartBar := 0;
        m_OffsetIndex := 0;
    end;

    Result := f_ZeroIndex;
end;

//---------------------------------------------------------------------------
//시세가 업데이터 될때 F_FindZeroIndex를 상용하여 당일의 최초 바의 인덱스값을 구하도록 한다.
procedure CFNMatrixChartDataSeries.FindZeroNextTime;
begin
    m_DoFindZeroIndex := TRUE;
end;

//---------------------------------------------------------------------------
//스트리밍 데이터를 요청하기 전에 미리 계산해 두고 준비해 두어야 하는 작업을 한다.
//이러한 작업은
//각 시간대 별로 얼마의 차트의 바의 수가 존재 하는 지를 계산한다.
//중국의 경우는 거래시간이 2개가 있다, 오전 2시간 오후 2시간, 1분바의 경우에 오전에 120개, 오후에 120가 존재하며
//오전시간대의 m_MaxIndex는 120 이고
//오후시간대의 m_MaxIndex는 240 이다.
procedure CFNMatrixChartDataSeries.ReadyStream;
var
    f_TradingHour   : Double;
	f_HourIndex     : Integer;
begin

    //	일중데이터 일 경우
    if (m_TimeFrame >= 9000) then
    begin
        m_CoreOfDay := (86400.0 / (m_TimeFrame-9000));
    end else
    if (m_TimeFrame < 360) then
    begin
        m_CoreOfDay := (86400.0 / (m_TimeFrame * 60));        //1분바 이면 1440
    end else
    begin
        m_CoreOfDay := 0;
    end;

    f_TradingHour := 0;
    for f_HourIndex := 0 to m_POTData.m_HourCount - 1 do
    begin
        f_TradingHour := f_TradingHour + (m_POTData.m_Close[f_HourIndex] - m_POTData.m_Open[f_HourIndex]);
        m_POTData.m_MaxIndex[f_HourIndex] :=  Math.floor((f_TradingHour * m_CoreOfDay) / 86400.0);
    end;

    //  전 시세의 누적 거래량을 0으로 초기화 한다.
    m_OldQuotTotalVolume := 0;

    //  이전 시세의 시간을 null로 초기화 한다.
    m_OldQuotDateTime := 0;
    m_DoFindZeroIndex := false;
    m_LastDateTimeOnChartBar := 0;

    Fix;
end;

//---------------------------------------------------------------------------
//시간을 하루중의 몇 번째 바의 인덱인지 계산한다. 이때 이 시간은 분바의 마감시간이다.
function CFNMatrixChartDataSeries.CloseTimeToIndex(p_Hour, p_Min, p_Sec: Integer): Integer;
var
    f_HourIndex     : Integer;
    f_Index         : Integer;
    f_MaxIndex      : Integer;
    f_TradingHour   : Double;
    f_Time          : Double;
begin
    //	일중데이터 일 경우
    if (m_TimeFrame >= 9000) then
    begin
        m_CoreOfDay := (86400.0 / (m_TimeFrame-9000));
    end else
    if (m_TimeFrame < 360) then
    begin
        m_CoreOfDay := (86400.0 / (m_TimeFrame * 60));        //1분바 이면 1440
    end else
    begin
        m_CoreOfDay := 0;
    end;

    f_Time          := CFNPOTItem.TimeToNumber(p_Hour, p_Min, p_Sec);
    f_TradingHour   := 0;
    f_MaxIndex      := 0;

    for f_HourIndex := 0 to m_POTData.m_HourCount - 1 do
    begin
        f_MaxIndex := m_POTData.m_MaxIndex[f_HourIndex];
        if (f_Time > m_POTData.m_Close[f_HourIndex]) then
        begin
            f_TradingHour := f_TradingHour + (m_POTData.m_Close[f_HourIndex] - m_POTData.m_Open[f_HourIndex]);
            if (f_HourIndex+1 = m_POTData.m_HourCount) then
                break
            else if (f_Time < m_POTData.m_Open[f_HourIndex+1]) then
                break
            else
                Continue;
        end else
        begin
            f_TradingHour := f_TradingHour + (f_Time - m_POTData.m_Open[f_HourIndex]);
            break;
        end;
    end;

    f_Index := Math.floor((f_TradingHour * m_CoreOfDay)/86400.0);
    if (f_Index >= f_MaxIndex) then f_Index := f_MaxIndex-1;

    Result := f_Index;
end;

//---------------------------------------------------------------------------
//해당 인덱스의 마감 시간을 계산한다.
function CFNMatrixChartDataSeries.IndexToCloseTime(p_Index: Integer): Double;
var
    f_OpenTime      : Double;
    f_FindTime      : Double;
    f_Zero          : Integer;
    f_HourIndex     : Integer;
    f_Done          : Boolean;
    f_OldMaxIndex   : Integer;
    f_NewMaxIndex   : Integer;
begin
    f_Done := FALSE;
    //	일중데이터 일 경우
    if (m_TimeFrame >= 9000) then
    begin
        m_CoreOfDay := (86400.0 / (m_TimeFrame-9000));
    end else
    if (m_TimeFrame < 360) then
    begin
        m_CoreOfDay := (86400.0 / (m_TimeFrame * 60));        //1분바 이면 1440
    end else
    begin
        m_CoreOfDay := 0;
    end;

    f_OpenTime      := 0;
    f_FindTime      := 0;
    f_Zero          := 0;
    f_OldMaxIndex   := 0;
    f_NewMaxIndex   := 0;

    for f_HourIndex := 0 to m_POTData.m_HourCount - 1 do
    begin
        f_NewMaxIndex := m_POTData.m_MaxIndex[f_HourIndex];
        if (p_Index < 0) then
        begin
            f_FindTime  := m_POTData.m_Open[f_HourIndex] + 86400.0 / m_CoreOfDay;
            f_Done      := TRUE;
            break;
        end
        else if ((f_OldMaxIndex <= p_Index) and (p_Index < f_NewMaxIndex)) then
        begin
            f_OpenTime  := m_POTData.m_Open[f_HourIndex];
            f_Zero      := f_OldMaxIndex;
            f_FindTime  := f_OpenTime + (p_Index-f_Zero+1) * 86400.0 / m_CoreOfDay;
            f_Done      := TRUE;
            break;
        end else
        begin
            f_Done := FALSE;
        end;

        f_Zero          := f_OldMaxIndex;
        f_OpenTime      := m_POTData.m_Open[f_HourIndex];
        f_OldMaxIndex   := f_NewMaxIndex;
    end;

    if (not f_Done) then
        f_FindTime := f_OpenTime + ((f_NewMaxIndex-1)-f_Zero+1) * 86400.0 / m_CoreOfDay;

    Result := f_FindTime;
end;

//---------------------------------------------------------------------------
function CFNMatrixChartDataSeries.GetOpenDateTime(p_CloseDateTime:Double; p_Factor:Integer) : Double;
var

    Year            : Word;
    Month           : Word;
    Day             : Word;
    Hour            : Word;
    Min             : Word;
    Sec             : Word;
    MilSec          : Word;
    f_CloseIndex    : Integer;
    f_Alpha         : Double;
begin
    //  초데이터 일 경우
    if (m_TimeFrame >= 9000) then
    begin
        f_Alpha := (m_TimeFrame - 9000) / 86400.0
    end else
    //  분데이터 일 경우
    if (m_TimeFrame < 360) then
    begin
        f_Alpha := (m_TimeFrame * 60) / 86400.0
    end else
    begin
        DecodeDate(p_CloseDateTime, Year, Month, Day);
        Result := EncodeDate(Year, Month, Day) + m_POTData.m_Open[0];
        exit;
    end;

    DecodeDateTime(p_CloseDateTime, Year, Month, Day, Hour, Min, Sec, MilSec);
    f_CloseIndex := CloseTimeToIndex(Hour, Min, Sec-p_Factor);
    Result :=
    EncodeDateTime(
        Year,
        Month,
        Day,
        CFNPOTItem.NumberToHour(IndexToCloseTime(f_CloseIndex)),
        CFNPOTItem.NumberToMin(IndexToCloseTime(f_CloseIndex)),
        CFNPOTItem.NumberToSec(IndexToCloseTime(f_CloseIndex)), 0) - f_Alpha;
end;

//---------------------------------------------------------------------------
//해당 인덱스의 시작 시간을 계산한다.
function CFNMatrixChartDataSeries.IndexToOpenTime(p_Index: Integer): Double;
var
    f_OpenTime      : Double;
    f_FindTime      : Double;
    f_Zero          : Integer;
    f_HourIndex     : Integer;
    f_Done          : Boolean;
    f_OldMaxIndex   : Integer;
    f_NewMaxIndex   : Integer;
begin
    f_Done := FALSE;

    //  초데이터 일 경우
    if (m_TimeFrame >= 9000) then
    begin
        m_CoreOfDay := (86400.0 / (m_TimeFrame-9000));
    end else
    //  분데이터 일 경우
    if (m_TimeFrame < 360) then
    begin
        m_CoreOfDay := (86400.0 / (m_TimeFrame * 60));
    end else
    begin
        m_CoreOfDay := 0;
    end;

    f_OpenTime      := 0;
    f_FindTime      := 0;
    f_Zero          := 0;
    f_OldMaxIndex   := 0;
    f_NewMaxIndex   := 0;

    for f_HourIndex := 0 to m_POTData.m_HourCount - 1 do
    begin
        f_NewMaxIndex := m_POTData.m_MaxIndex[f_HourIndex];
        if (p_Index < 0) then
        begin
            f_FindTime  := m_POTData.m_Open[f_HourIndex];
            f_Done      := TRUE;
            break;
        end
        else if ((f_OldMaxIndex <= p_Index) and (p_Index < f_NewMaxIndex)) then
        begin
            f_OpenTime  := m_POTData.m_Open[f_HourIndex];
            f_Zero      := f_OldMaxIndex;
            f_FindTime  := f_OpenTime + (p_Index-f_Zero) * 86400.0 / m_CoreOfDay;
            f_Done      := TRUE;
            break;
        end else
        begin
            f_Done      := FALSE;
        end;

        f_Zero          := f_OldMaxIndex;
        f_OpenTime      := m_POTData.m_Open[f_HourIndex];
        f_OldMaxIndex   := f_NewMaxIndex;
    end;

    if (not f_Done) then f_FindTime := f_OpenTime + ((f_NewMaxIndex-1)-f_Zero) * 86400.0 / m_CoreOfDay;

    Result := f_FindTime;
end;

end.
