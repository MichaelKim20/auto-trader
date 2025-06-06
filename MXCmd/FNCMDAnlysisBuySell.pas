unit FNCMDAnlysisBuySell;

interface

uses
    Windows, Math, SysUtils, Classes, ExtCtrls,
    SyncObjs, FNQueue, DB, DBTables, ADODB,
    FNThread, FNTradeSystem, FNTrafficManager, FNNAVAnalChartData, FNNAVAnalChartDataSeries, FNNAVAnalLineValueSeries;

type
    CFNNAVAnalPMData = class(TObject)
    public
        m_Date                      :   TDateTime;
        m_Price                     :   Double;
        m_Enabled                   :   Integer;
        m_Enabled2                  :   Integer;

        m_NetProfit                 :   Double;     // 순이익
        m_GrossProfit               :   Double;     // 총이익
        m_GrossLoss                 :   Double;     // 총손실
        m_NumberOfTrades            :   Integer;    // 전체거래수
        m_AvgDayOfTrades            :   Double;    // 일일평균거래수

        m_DayOfTrades               :   Integer;    // 전체거래일수
        m_DayOfTradable             :   Integer;    // 매매허용일수
        m_DayOfWinningTrades        :   Integer;    // 이익거래일수
        m_DayOfLosingTrades         :   Integer;    // 손실거래일수
        m_PercentProfitable         :   Double;     // 이익거래일수/전체거래일수

        m_LargestWinningTrade       :   Double;     // 최대 이익거래 금액
        m_LargestLosingTrade        :   Double;     // 최대 손실거래 금액

        m_AverageWinningTrade       :   Double;     // 평균 이익거래 금액
        m_AverageLosingTrade        :   Double;     // 평균 손실거래 금액

        m_RatioAvgWinAvgLoss        :   Double;     // 평균 이익거래 금액/평균 손실거래 금액
        m_AvgTrade                  :   Double;     // 순이익/전체거래일수
        m_MaxConsecWinners          :   Integer;    // 최대연속이익거래일수
        m_MaxConsecLosers           :   Integer;    // 최대연속손실거래일수

        m_AvgBarsWinners            :   Integer;    // 이익거래의 평균 일수
        m_AvgBarsLosers             :   Integer;    // 손실거래의 평균 일수
        m_MaxDrawdown               :   Double;     // 순이익의 최대삭감금액

        m_ProfitFactor              :   Double;     // 총이익/총손실

        m_SuccessRate               :   Double;     // 성공율

        constructor Create;
        procedure DefaultValue;
        procedure Clone(p_Source:CFNNAVAnalPMData);
    end;

    CFNNAVAnalOption = class(TObject)
    public
        m_UseMA1     :  Boolean     ;
        m_MA1Value1  :  Double      ;
        m_MA1Value2  :  Double      ;
        m_MA1Value3  :  Double      ;
        m_MA1Value4  :  Double      ;
        m_StandDate  :  TDateTime               ;

        constructor Create;
        procedure DefaultValue;
        procedure Clone(p_Source:CFNNAVAnalOption);
    end;

    //---------------------------------------------------------------------------
    CFNCMDAnlysisBuySell = class(TObject)
    private
        m_ChartDataSeries   :   CFNNAVAnalChartDataSeries;
        m_NAVSeries         :   CFNNAVAnalLineValueSeries;
        m_Query: TQuery;
        m_ADOQuery: TADOQuery;

        procedure ReadDailyReport;
        procedure AnalisysNAV(AStandDate:TDateTime);
        procedure AnalisysPM(AStandDate:TDateTime);
        procedure Process;
        procedure InsertDailyReport(AChartData:CFNNAVAnalChartData);
        procedure InsertPerformance(ATradeType:Integer; ACalcType:Integer; AStandDate:TDateTime; APMData:CFNNAVAnalPMData);

        procedure WriteDailyReport;

        procedure WritePerfomance(AStandDate:TDateTime);

    public
        m_StartDate     :   TDateTime;
        m_EndDate       :   TDateTime;
        m_InputFileName :   String;
        m_Symbol        :   String;
        m_MA            :   Integer;
        m_DType         :   Integer;

        m_DataSource    :   String;
        m_UserID        :   String;
        m_Password      :   String;

        m_CalcType      :   Integer;
        m_Option            : CFNNAVAnalOption;
        m_EnableEvent       : Boolean;
        m_PMData            : Array [0..5] of CFNNAVAnalPMData;
        m_PMValueCollection : Array [0..5] of CFNPMValueCollection;

        constructor Create;
        destructor Destroy; override;

        procedure Analysis;
    end;

implementation

uses
    DateUtils, Forms, FNSocketManager, FNCMVariable, FNSymbolCollection, FNGlobal, FNNAVAnalLineValue,
    FNNAVAnalLineValueSeriesCreator;

//------------------------------------------------------------------------------------
constructor CFNNAVAnalOption.Create;
begin
    DefaultValue;
end;

//------------------------------------------------------------------------------------
procedure CFNNAVAnalOption.DefaultValue;
begin
    m_UseMA1     := true;
    m_MA1Value1  := 30;
    m_MA1Value2  :=  3;
    m_MA1Value3  :=  3;
    m_MA1Value4  :=  -1;
    m_StandDate  := EncodeDate(2011, 01, 01);
end;

//------------------------------------------------------------------------------------
procedure CFNNAVAnalOption.Clone(p_Source: CFNNAVAnalOption);
begin
    m_MA1Value1  := p_Source.m_MA1Value1;
    m_MA1Value2  := p_Source.m_MA1Value2;
    m_MA1Value3  := p_Source.m_MA1Value3;
    m_MA1Value4  := p_Source.m_MA1Value4;
    m_StandDate  := p_Source.m_StandDate;
end;

//------------------------------------------------------------------------------------
constructor CFNNAVAnalPMData.Create;
begin
    DefaultValue;
end;
//------------------------------------------------------------------------------------
procedure CFNNAVAnalPMData.DefaultValue;
begin
    m_NetProfit                 :=  0;
    m_GrossProfit               :=  0;
    m_GrossLoss                 :=  0;
    m_NumberOfTrades            :=  0;

    m_AvgDayOfTrades            :=  0;

    m_DayOfTrades               :=  0;
    m_DayOfTradable             :=  0;
    m_DayOfWinningTrades        :=  0;
    m_DayOfLosingTrades         :=  0;
    m_PercentProfitable         :=  0;

    m_LargestWinningTrade       :=  0;
    m_LargestLosingTrade        :=  0;

    m_AverageWinningTrade       :=  0;
    m_AverageLosingTrade        :=  0;

    m_RatioAvgWinAvgLoss        :=  0;
    m_AvgTrade                  :=  0;
    m_MaxConsecWinners          :=  0;
    m_MaxConsecLosers           :=  0;

    m_AvgBarsWinners            :=  0;
    m_AvgBarsLosers             :=  0;
    m_MaxDrawdown               :=  0;

    m_ProfitFactor              :=  0;
    m_SuccessRate               :=  0;
end;

//------------------------------------------------------------------------------------
procedure CFNNAVAnalPMData.Clone(p_Source: CFNNAVAnalPMData);
begin
    m_NetProfit                 :=  p_Source.m_NetProfit                 ;
    m_GrossProfit               :=  p_Source.m_GrossProfit               ;
    m_GrossLoss                 :=  p_Source.m_GrossLoss                 ;
    m_NumberOfTrades            :=  p_Source.m_NumberOfTrades            ;
    m_AvgDayOfTrades            :=  p_Source.m_AvgDayOfTrades            ;

    m_DayOfTrades               :=  p_Source.m_DayOfTrades               ;
    m_DayOfTradable             :=  p_Source.m_DayOfTradable             ;
    m_DayOfWinningTrades        :=  p_Source.m_DayOfWinningTrades        ;
    m_DayOfLosingTrades         :=  p_Source.m_DayOfLosingTrades         ;
    m_PercentProfitable         :=  p_Source.m_PercentProfitable         ;

    m_LargestWinningTrade       :=  p_Source.m_LargestWinningTrade       ;
    m_LargestLosingTrade        :=  p_Source.m_LargestLosingTrade        ;

    m_AverageWinningTrade       :=  p_Source.m_AverageWinningTrade       ;
    m_AverageLosingTrade        :=  p_Source.m_AverageLosingTrade        ;

    m_RatioAvgWinAvgLoss        :=  p_Source.m_RatioAvgWinAvgLoss        ;
    m_AvgTrade                  :=  p_Source.m_AvgTrade                  ;
    m_MaxConsecWinners          :=  p_Source.m_MaxConsecWinners          ;
    m_MaxConsecLosers           :=  p_Source.m_MaxConsecLosers           ;

    m_AvgBarsWinners            :=  p_Source.m_AvgBarsWinners            ;
    m_AvgBarsLosers             :=  p_Source.m_AvgBarsLosers             ;
    m_MaxDrawdown               :=  p_Source.m_MaxDrawdown               ;

    m_ProfitFactor              :=  p_Source.m_ProfitFactor              ;
    m_SuccessRate               :=  p_Source.m_SuccessRate               ;
end;

//---------------------------------------------------------------------------
procedure CFNCMDAnlysisBuySell.Analysis;
begin
    m_ADOQuery.ConnectionString := 'Provider=SQLOLEDB.1;Password=' + Trim(m_Password) + ';Persist Security Info=True;User ID=' + Trim(m_UserID) + ';Initial Catalog=OPS;Data Source=' + Trim(m_DataSource) + '';

    ReadDailyReport;
    WriteDailyReport;

    m_CalcType := 1;
    m_Option.m_MA1Value1 :=  9;
    Process;

    m_CalcType := 2;
    m_Option.m_MA1Value1 := 30;
    Process;

    m_CalcType := 3;
    m_Option.m_MA1Value1 := 50;
    Process;
end;

//---------------------------------------------------------------------------
procedure CFNCMDAnlysisBuySell.ReadDailyReport;
var
    F: TextFile;
    S: string;
    f_FileName: string;
    f_RecordList:TStringList;
    f_FieldList:TStringList;
    f_RecordIndex:Integer;

    f_Index:Integer;

    Year   :Word;
    Month  :Word;
    Day    :Word;
    f_ChartData:CFNNAVAnalChartData;

    f_Date:TDateTime;
begin
    m_ChartDataSeries.Clear;
    f_FileName := m_InputFileName;

    f_RecordList := TStringList.Create;
    f_FieldList := TStringList.Create;

    try
        f_RecordList.Clear;
        if FileExists(f_FileName) then
        begin
            AssignFile(F, f_FileName);
            Reset(F);
            while not eof(F) do
            begin
                Readln(F, S);
                f_RecordList.Add(S);
            end;
            CloseFile(F);
        end;

        for f_RecordIndex := 1 to f_RecordList.Count - 1 do
        begin
            f_FieldList.Clear;
            ExtractStrings([','], [], PChar(f_RecordList[f_RecordIndex]), f_FieldList);

            if f_FieldList.Count < 5 then continue;


            Year    := TFNGlobal.atoi(Copy(f_FieldList[0], 1, 4));
            Month   := TFNGlobal.atoi(Copy(f_FieldList[0], 6, 2));
            Day     := TFNGlobal.atoi(Copy(f_FieldList[0], 9, 2));
            f_Date := EncodeDate(Year, Month, Day);

            if f_Date <= m_EndDate then
            begin
                f_ChartData := CFNNAVAnalChartData.Create;
                f_ChartData.m_Date := f_Date;
                f_ChartData.m_TProfit := TFNGlobal.atof(f_FieldList[1]);
                f_ChartData.m_TProfitSum := TFNGlobal.atof(f_FieldList[2]);

                f_ChartData.m_BProfit := TFNGlobal.atof(f_FieldList[3]);
                f_ChartData.m_BProfitSum := TFNGlobal.atof(f_FieldList[4]);

                f_ChartData.m_SProfit := TFNGlobal.atof(f_FieldList[5]);
                f_ChartData.m_SProfitSum := TFNGlobal.atof(f_FieldList[6]);

                f_ChartData.m_TNumberOfTrades := TFNGlobal.atof(f_FieldList[7]);
                f_ChartData.m_BNumberOfTrades := TFNGlobal.atof(f_FieldList[8]);
                f_ChartData.m_SNumberOfTrades := TFNGlobal.atof(f_FieldList[9]);

                f_ChartData.m_Price := TFNGlobal.atof(f_FieldList[10]);

                m_ChartDataSeries.Add(f_ChartData);
            end;
        end;

    finally
        f_RecordList.Free;
        f_FieldList.Free;
    end;
end;

//------------------------------------------------------------------------------------
procedure CFNCMDAnlysisBuySell.Process;
var
    f_ValueIndex:Integer;
    f_ChartData:CFNNAVAnalChartData;
begin
    for f_ValueIndex := 0 to m_ChartDataSeries.m_Items.Count - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        if (CompareValue(m_StartDate,  f_ChartData.m_Date, 0.5) <= 0) and (CompareValue(f_ChartData.m_Date, m_EndDate, 0.5) <= 0) then
        begin
            AnalisysNAV(f_ChartData.m_Date);
            AnalisysPM(f_ChartData.m_Date);
            WritePerfomance(f_ChartData.m_Date);
        end;
    end;
end;

//------------------------------------------------------------------------------------
procedure CFNCMDAnlysisBuySell.WritePerfomance(AStandDate:TDateTime);
begin
    if m_CalcType = 1 then
    begin
        InsertPerformance(0, 0, AStandDate, m_PMData[0]);
        InsertPerformance(1, 0, AStandDate, m_PMData[1]);
        InsertPerformance(2, 0, AStandDate, m_PMData[2]);
    end;

    InsertPerformance(0, m_CalcType, AStandDate, m_PMData[3]);
    InsertPerformance(1, m_CalcType, AStandDate, m_PMData[4]);
    InsertPerformance(2, m_CalcType, AStandDate, m_PMData[5]);
end;

//------------------------------------------------------------------------------------
procedure CFNCMDAnlysisBuySell.WriteDailyReport;
var
    f_ValueIndex:Integer;
    f_ChartData:CFNNAVAnalChartData;
begin
    for f_ValueIndex := 0 to m_ChartDataSeries.m_Items.Count - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];

        if (CompareValue(m_StartDate,  f_ChartData.m_Date, 0.5) <= 0) and (CompareValue(f_ChartData.m_Date, m_EndDate, 0.5) <= 0) then
        begin
            InsertDailyReport(f_ChartData);
        end;
    end;
end;

//------------------------------------------------------------------------------------
procedure CFNCMDAnlysisBuySell.AnalisysNAV(AStandDate:TDateTime);
var
    f_ValueIndex:Integer;
    f_Size:Integer;
    f_ChartData:CFNNAVAnalChartData;
    f_LineValue0:CFNNAVAnalLineValue;
    f_LineValue1:CFNNAVAnalLineValue;
    f_LineValue2:CFNNAVAnalLineValue;

    f_Value:Double;

    f_THigh:Double;
    f_BHigh:Double;
    f_SHigh:Double;

    f_LineValueOrigin:CFNNAVAnalLineValue;

    f_TOrigin:Double;
    f_BOrigin:Double;
    f_SOrigin:Double;

    f_OriginIndex:Integer;
    f_EndIndex:Integer;
    f_TSum:Double;
    f_BSum:Double;
    f_SSum:Double;

    f_TempDate : TDateTime;
    f_Year, f_Month, f_Day:Word;
begin
    f_OriginIndex := m_ChartDataSeries.Search(m_Option.m_StandDate, true);
    if f_OriginIndex <= 0 then f_OriginIndex := Trunc(m_Option.m_MA1Value1);

    f_EndIndex := m_ChartDataSeries.Search(AStandDate, true);

    if f_EndIndex >= 0 then
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_EndIndex];
        if AStandDate < f_ChartData.m_Date then
        begin
            f_EndIndex := f_EndIndex - 1;
        end;
    end;

    f_TempDate := AStandDate - 70;
    DecodeDate(f_TempDate, f_Year, f_Month, f_Day);
    f_TempDate := EncodeDate(f_Year, f_Month, 1);
    f_OriginIndex := m_ChartDataSeries.Search(f_TempDate, true);
    if f_OriginIndex < 1 then f_OriginIndex := 1;

    f_OriginIndex := f_EndIndex - 50;
    if f_OriginIndex < 1 then f_OriginIndex := 1;

    f_Size := f_EndIndex + 1;

    m_NAVSeries.Clear;
    m_NAVSeries.SetLengthSeries(f_Size);
    f_TSum := 0;
    f_BSum := 0;
    f_SSum := 0;
    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        f_TSum := f_TSum + f_ChartData.m_TProfit;
        f_BSum := f_BSum + f_ChartData.m_BProfit;
        f_SSum := f_SSum + f_ChartData.m_SProfit;

        f_LineValue0.m_Value[NAV_TPROFIT    ] := f_TSum;
        f_LineValue0.m_Value[NAV_BPROFIT    ] := f_BSum;
        f_LineValue0.m_Value[NAV_SPROFIT    ] := f_SSum;

        f_LineValue0.m_Value[NAV_TPROFIT2   ] := 0;

        f_LineValue0.m_Value[NAV_BPROFIT_MA1] := 0;
        f_LineValue0.m_Value[NAV_BPROFIT_MA2] := 0;
        f_LineValue0.m_Value[NAV_BPROFIT_MA3] := 0;
        f_LineValue0.m_Value[NAV_BPROFIT2   ] := 0;

        f_LineValue0.m_Value[NAV_SPROFIT_MA1] := 0;
        f_LineValue0.m_Value[NAV_SPROFIT_MA2] := 0;
        f_LineValue0.m_Value[NAV_SPROFIT_MA3] := 0;
        f_LineValue0.m_Value[NAV_SPROFIT2   ] := 0;
    end;

    if m_Option.m_UseMA1 then
    begin
        m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA1Value1), 6, m_NAVSeries, NAV_BPROFIT    , NAV_BPROFIT_MA1, 0, f_Size);
        m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA1Value2), 6, m_NAVSeries, NAV_BPROFIT_MA1, NAV_BPROFIT_MA2, 0, f_Size);
        m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA1Value3), 6, m_NAVSeries, NAV_BPROFIT_MA2, NAV_BPROFIT_MA3, 0, f_Size);

        m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA1Value1), 6, m_NAVSeries, NAV_SPROFIT    , NAV_SPROFIT_MA1, 0, f_Size);
        m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA1Value2), 6, m_NAVSeries, NAV_SPROFIT_MA1, NAV_SPROFIT_MA2, 0, f_Size);
        m_NAVSeries.Indicator_WAverage3( Trunc(m_Option.m_MA1Value3), 6, m_NAVSeries, NAV_SPROFIT_MA2, NAV_SPROFIT_MA3, 0, f_Size);

        for f_ValueIndex := 0 to f_Size - 1 do
        begin
            f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];
            if f_ValueIndex < f_OriginIndex then
            begin
                f_LineValue0.m_Value[NAV_TPROFIT    ] := 0;
                f_LineValue0.m_Value[NAV_TPROFIT2   ] := 0;

                f_LineValue0.m_Value[NAV_BPROFIT    ] := 0;
                f_LineValue0.m_Value[NAV_BPROFIT_MA1] := 0;
                f_LineValue0.m_Value[NAV_BPROFIT_MA2] := 0;
                f_LineValue0.m_Value[NAV_BPROFIT_MA3] := 0;
                f_LineValue0.m_Value[NAV_BPROFIT2   ] := 0;

                f_LineValue0.m_Value[NAV_SPROFIT    ] := 0;
                f_LineValue0.m_Value[NAV_SPROFIT_MA1] := 0;
                f_LineValue0.m_Value[NAV_SPROFIT_MA2] := 0;
                f_LineValue0.m_Value[NAV_SPROFIT_MA3] := 0;
                f_LineValue0.m_Value[NAV_SPROFIT2   ] := 0;
            end;
        end;

        for f_ValueIndex := 0 to f_Size - 1 do
        begin
            f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

            if f_ValueIndex > 1 then
            begin
                f_LineValue1 := m_NAVSeries.m_Items[f_ValueIndex-1];
                f_LineValue2 := m_NAVSeries.m_Items[f_ValueIndex-2];

                f_Value := (f_LineValue1.m_Value[NAV_BPROFIT_MA3] - f_LineValue2.m_Value[NAV_BPROFIT_MA3]) * 100.0;
                if f_Value >= m_Option.m_MA1Value4 then
                begin
                    f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] := 1;
                end else
                begin
                    f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] := 0;
                end;

                f_Value := (f_LineValue1.m_Value[NAV_SPROFIT_MA3] - f_LineValue2.m_Value[NAV_SPROFIT_MA3]) * 100.0;
                if f_Value >= m_Option.m_MA1Value4 then
                begin
                    f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] := 1;
                end else
                begin
                    f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] := 0;
                end;

            end else
            begin
                f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] := 1;
                f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] := 1;
            end;
        end;
        for f_ValueIndex := 0 to f_Size - 1 do
        begin
            f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

            if f_ValueIndex > 1 then
            begin
                f_LineValue1 := m_NAVSeries.m_Items[f_ValueIndex-1];

                f_Value := (f_LineValue0.m_Value[NAV_BPROFIT_MA3] - f_LineValue1.m_Value[NAV_BPROFIT_MA3]) * 100.0;
                if f_Value >= m_Option.m_MA1Value4 then
                begin
                    f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE2] := 1;
                end else
                begin
                    f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE2] := 0;
                end;

                f_Value := (f_LineValue0.m_Value[NAV_SPROFIT_MA3] - f_LineValue1.m_Value[NAV_SPROFIT_MA3]) * 100.0;
                if f_Value >= m_Option.m_MA1Value4 then
                begin
                    f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE2] := 1;
                end else
                begin
                    f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE2] := 0;
                end;

            end else
            begin
                f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE2] := 1;
                f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE2] := 1;
            end;
        end;


        for f_ValueIndex := 0 to f_Size - 1 do
        begin
            f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];
            if f_ValueIndex < f_OriginIndex  then
            begin
                f_LineValueOrigin := m_NAVSeries.m_Items[f_ValueIndex];
            end else
            begin
                f_LineValue0.m_Value[NAV_TPROFIT    ] := f_LineValue0.m_Value[NAV_TPROFIT    ] - f_LineValueOrigin.m_Value[NAV_TPROFIT    ];
                f_LineValue0.m_Value[NAV_TPROFIT2   ] := f_LineValue0.m_Value[NAV_TPROFIT2   ] - f_LineValueOrigin.m_Value[NAV_TPROFIT2   ];

                f_LineValue0.m_Value[NAV_BPROFIT    ] := f_LineValue0.m_Value[NAV_BPROFIT    ] - f_LineValueOrigin.m_Value[NAV_BPROFIT    ];
                f_LineValue0.m_Value[NAV_BPROFIT_MA1] := f_LineValue0.m_Value[NAV_BPROFIT_MA1] - f_LineValueOrigin.m_Value[NAV_BPROFIT_MA1];
                f_LineValue0.m_Value[NAV_BPROFIT_MA2] := f_LineValue0.m_Value[NAV_BPROFIT_MA2] - f_LineValueOrigin.m_Value[NAV_BPROFIT_MA2];
                f_LineValue0.m_Value[NAV_BPROFIT_MA3] := f_LineValue0.m_Value[NAV_BPROFIT_MA3] - f_LineValueOrigin.m_Value[NAV_BPROFIT_MA3];
                f_LineValue0.m_Value[NAV_BPROFIT2   ] := f_LineValue0.m_Value[NAV_BPROFIT2   ] - f_LineValueOrigin.m_Value[NAV_BPROFIT2   ];

                f_LineValue0.m_Value[NAV_SPROFIT    ] := f_LineValue0.m_Value[NAV_SPROFIT    ] - f_LineValueOrigin.m_Value[NAV_SPROFIT    ];
                f_LineValue0.m_Value[NAV_SPROFIT_MA1] := f_LineValue0.m_Value[NAV_SPROFIT_MA1] - f_LineValueOrigin.m_Value[NAV_SPROFIT_MA1];
                f_LineValue0.m_Value[NAV_SPROFIT_MA2] := f_LineValue0.m_Value[NAV_SPROFIT_MA2] - f_LineValueOrigin.m_Value[NAV_SPROFIT_MA2];
                f_LineValue0.m_Value[NAV_SPROFIT_MA3] := f_LineValue0.m_Value[NAV_SPROFIT_MA3] - f_LineValueOrigin.m_Value[NAV_SPROFIT_MA3];
                f_LineValue0.m_Value[NAV_SPROFIT2   ] := f_LineValue0.m_Value[NAV_SPROFIT2   ] - f_LineValueOrigin.m_Value[NAV_SPROFIT2   ];
            end;
        end;



    end else
    begin

        for f_ValueIndex := 0 to f_Size - 1 do
        begin
            f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];
            f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] := 1;
            f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] := 1;
            f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE2] := 1;
            f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE2] := 1;
        end;

    end;




    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_ValueIndex >= f_OriginIndex then
        begin
            if f_ValueIndex > 1 then
            begin
                f_LineValue1 := m_NAVSeries.m_Items[f_ValueIndex-1];
                f_LineValue2 := m_NAVSeries.m_Items[f_ValueIndex-2];

                if f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] = 1 then
                begin
                    f_LineValue0.m_Value[NAV_BPROFIT2] := f_LineValue1.m_Value[NAV_BPROFIT2] + f_ChartData.m_BProfit;
                end else
                begin
                    f_LineValue0.m_Value[NAV_BPROFIT2] := f_LineValue1.m_Value[NAV_BPROFIT2];
                end;

                if f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] = 1 then
                begin
                    f_LineValue0.m_Value[NAV_SPROFIT2] := f_LineValue1.m_Value[NAV_SPROFIT2] + f_ChartData.m_SProfit;
                end else
                begin
                    f_LineValue0.m_Value[NAV_SPROFIT2] := f_LineValue1.m_Value[NAV_SPROFIT2];
                end;
            end else
            begin
                f_LineValue0.m_Value[NAV_BPROFIT2] := f_LineValue0.m_Value[NAV_BPROFIT];
                f_LineValue0.m_Value[NAV_SPROFIT2] := f_LineValue0.m_Value[NAV_SPROFIT];
            end;
        end else
        begin
            f_LineValue0.m_Value[NAV_BPROFIT2] := f_LineValue0.m_Value[NAV_BPROFIT];
            f_LineValue0.m_Value[NAV_SPROFIT2] := f_LineValue0.m_Value[NAV_SPROFIT];
        end;

        f_LineValue0.m_Value[NAV_TPROFIT2] := f_LineValue0.m_Value[NAV_BPROFIT2] + f_LineValue0.m_Value[NAV_SPROFIT2];
    end;

    f_THigh := 0;
    f_BHigh := 0;
    f_SHigh := 0;
    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_LineValue0.m_Value[NAV_TPROFIT] > f_THigh then f_THigh := f_LineValue0.m_Value[NAV_TPROFIT];
        if f_LineValue0.m_Value[NAV_BPROFIT] > f_BHigh then f_BHigh := f_LineValue0.m_Value[NAV_BPROFIT];
        if f_LineValue0.m_Value[NAV_SPROFIT] > f_SHigh then f_SHigh := f_LineValue0.m_Value[NAV_SPROFIT];
        f_LineValue0.m_Value[NAV_TDRAWDOWN1] := f_LineValue0.m_Value[NAV_TPROFIT] - f_THigh;
        f_LineValue0.m_Value[NAV_BDRAWDOWN1] := f_LineValue0.m_Value[NAV_BPROFIT] - f_BHigh;
        f_LineValue0.m_Value[NAV_SDRAWDOWN1] := f_LineValue0.m_Value[NAV_SPROFIT] - f_SHigh;
    end;

    f_THigh := 0;
    f_BHigh := 0;
    f_SHigh := 0;
    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_LineValue0.m_Value[NAV_TPROFIT2] > f_THigh then f_THigh := f_LineValue0.m_Value[NAV_TPROFIT2];
        if f_LineValue0.m_Value[NAV_BPROFIT2] > f_BHigh then f_BHigh := f_LineValue0.m_Value[NAV_BPROFIT2];
        if f_LineValue0.m_Value[NAV_SPROFIT2] > f_SHigh then f_SHigh := f_LineValue0.m_Value[NAV_SPROFIT2];
        f_LineValue0.m_Value[NAV_TDRAWDOWN2] := f_LineValue0.m_Value[NAV_TPROFIT2] - f_THigh;
        f_LineValue0.m_Value[NAV_BDRAWDOWN2] := f_LineValue0.m_Value[NAV_BPROFIT2] - f_BHigh;
        f_LineValue0.m_Value[NAV_SDRAWDOWN2] := f_LineValue0.m_Value[NAV_SPROFIT2] - f_SHigh;
    end;
end;

//------------------------------------------------------------------------------------
procedure CFNCMDAnlysisBuySell.AnalisysPM(AStandDate:TDateTime);
var
    f_ValueIndex:Integer;
    f_Size:Integer;

    f_ChartData:CFNNAVAnalChartData;
    f_LineValue0:CFNNAVAnalLineValue;
    f_LineValue1:CFNNAVAnalLineValue;
    f_LineValue2:CFNNAVAnalLineValue;

    f_Value:Double;
    f_Profit:Double;
    f_HighProfit:Double;
    f_SumProfit:Double;
    f_Drawdown:Double;
    f_Tradable:Boolean;
    f_TradeCount:Integer;

    f_THigh:Double;
    f_BHigh:Double;
    f_SHigh:Double;

    f_LineValueOrigin:CFNNAVAnalLineValue;

    f_TOrigin:Double;
    f_BOrigin:Double;
    f_SOrigin:Double;
    f_PMData:CFNNAVAnalPMData;

    f_ConsecWinners:Integer;
    f_ConsecLosers:Integer;
    f_OriginIndex:Integer;
    f_EndIndex:Integer;

    f_TempDate : TDateTime;
    f_Year, f_Month, f_Day:Word;
begin
    f_OriginIndex := m_ChartDataSeries.Search(m_Option.m_StandDate, true);
    if f_OriginIndex <= 0 then f_OriginIndex := Trunc(m_Option.m_MA1Value1);

    f_EndIndex := m_ChartDataSeries.Search(AStandDate, true);

    if f_EndIndex >= 0 then
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_EndIndex];
        if AStandDate < f_ChartData.m_Date then
        begin
            f_EndIndex := f_EndIndex - 1;
        end;
    end;

    f_TempDate := AStandDate - 70;
    DecodeDate(f_TempDate, f_Year, f_Month, f_Day);
    f_TempDate := EncodeDate(f_Year, f_Month, 1);
    f_OriginIndex := m_ChartDataSeries.Search(f_TempDate, true);
    if f_OriginIndex < 1then f_OriginIndex := 1;

    f_OriginIndex := f_EndIndex - 50;
    if f_OriginIndex < 1 then f_OriginIndex := 1;

    f_Size := f_EndIndex + 1;

    {$REGION '1차 신호의 전체거래'}
    f_PMData := m_PMData[0];
    f_PMData.DefaultValue;
    f_HighProfit := 0;

    f_ConsecWinners:=0;
    f_ConsecLosers:=0;
    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_ValueIndex = f_Size - 1  then
        begin
            f_PMData.m_Date                      := f_ChartData.m_Date ;
            f_PMData.m_Price                     := f_ChartData.m_Price;
            f_PMData.m_Enabled                   := 1;
        end;

        if f_ValueIndex >= f_OriginIndex then
        begin
            f_Profit := f_ChartData.m_TProfit;
            f_Tradable := true;
            f_TradeCount := Trunc(f_ChartData.m_TNumberOfTrades);
            Inc(f_PMData.m_DayOfTrades);
            if f_Tradable then
            begin
                if f_Profit > 0 then
                begin
                    f_PMData.m_GrossProfit := f_PMData.m_GrossProfit + f_Profit;
                    Inc(f_PMData.m_DayOfWinningTrades);
                    if (f_PMData.m_LargestWinningTrade < f_Profit) then f_PMData.m_LargestWinningTrade := f_Profit;
                    Inc(f_ConsecWinners);
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecLosers := 0;
                end else
                if f_Profit < 0 then
                begin
                    f_PMData.m_GrossLoss := f_PMData.m_GrossLoss + f_Profit;
                    Inc(f_PMData.m_DayOfLosingTrades);
                    if (f_PMData.m_LargestLosingTrade > f_Profit) then f_PMData.m_LargestLosingTrade := f_Profit;
                    Inc(f_ConsecLosers);
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    f_ConsecWinners := 0;
                end else
                begin
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecWinners := 0;
                    f_ConsecLosers := 0;
                end;

                Inc(f_PMData.m_NumberOfTrades, f_TradeCount);
                Inc(f_PMData.m_DayOfTradable);

                f_SumProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;
                if f_HighProfit < f_SumProfit then f_HighProfit := f_SumProfit;
                f_Drawdown := f_SumProfit - f_HighProfit;
                if f_PMData.m_MaxDrawdown > f_Drawdown then f_PMData.m_MaxDrawdown := f_Drawdown;
            end;
        end;
    end;
    f_PMData.m_NetProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgDayOfTrades := f_PMData.m_NumberOfTrades / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgDayOfTrades := 0;
    end;

    if f_PMData.m_DayOfWinningTrades <> 0 then
    begin
        f_PMData.m_AverageWinningTrade := f_PMData.m_GrossProfit / f_PMData.m_DayOfWinningTrades;
    end else
    begin
        f_PMData.m_AverageWinningTrade := 0;
    end;

    if f_PMData.m_DayOfLosingTrades <> 0 then
    begin
        f_PMData.m_AverageLosingTrade := f_PMData.m_GrossLoss / f_PMData.m_DayOfLosingTrades;
    end else
    begin
        f_PMData.m_AverageLosingTrade := 0;
    end;

    if f_PMData.m_AverageLosingTrade <> 0 then
    begin
        f_PMData.m_RatioAvgWinAvgLoss := abs(f_PMData.m_AverageWinningTrade / f_PMData.m_AverageLosingTrade);
    end else
    begin
        f_PMData.m_RatioAvgWinAvgLoss := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_PercentProfitable := (f_PMData.m_DayOfWinningTrades / f_PMData.m_DayOfTradable)*100.0;
    end else
    begin
        f_PMData.m_PercentProfitable := 0;
    end;

    if f_PMData.m_GrossProfit <> 0 then
    begin
        f_PMData.m_SuccessRate := (f_PMData.m_NetProfit / f_PMData.m_GrossProfit)*100.0;
    end else
    begin
        f_PMData.m_SuccessRate := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgTrade := f_PMData.m_NetProfit / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgTrade := 0;
    end;

    if f_PMData.m_GrossLoss <> 0 then
    begin
        f_PMData.m_ProfitFactor := abs(f_PMData.m_GrossProfit / f_PMData.m_GrossLoss);
    end else
    begin
        f_PMData.m_ProfitFactor := 0;
    end;
    {$ENDREGION}

    {$REGION '1차 신호의 매수거래'}
    f_PMData := m_PMData[1];
    f_PMData.DefaultValue;
    f_HighProfit := 0;

    f_ConsecWinners:=0;
    f_ConsecLosers:=0;

    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_ValueIndex = f_Size - 1  then
        begin
            f_PMData.m_Date                      := f_ChartData.m_Date ;
            f_PMData.m_Price                     := f_ChartData.m_Price;
            f_PMData.m_Enabled                   := 1;
        end;
        if f_ValueIndex >= f_OriginIndex then
        begin
            f_Profit := f_ChartData.m_BProfit;
            f_Tradable := true;
            f_TradeCount := Trunc(f_ChartData.m_BNumberOfTrades);
            Inc(f_PMData.m_DayOfTrades);
            if f_Tradable then
            begin
                if f_Profit > 0 then
                begin
                    f_PMData.m_GrossProfit := f_PMData.m_GrossProfit + f_Profit;
                    Inc(f_PMData.m_DayOfWinningTrades);
                    if (f_PMData.m_LargestWinningTrade < f_Profit) then f_PMData.m_LargestWinningTrade := f_Profit;
                    Inc(f_ConsecWinners);
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecLosers := 0;
                end else
                if f_Profit < 0 then
                begin
                    f_PMData.m_GrossLoss := f_PMData.m_GrossLoss + f_Profit;
                    Inc(f_PMData.m_DayOfLosingTrades);
                    if (f_PMData.m_LargestLosingTrade > f_Profit) then f_PMData.m_LargestLosingTrade := f_Profit;
                    Inc(f_ConsecLosers);
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    f_ConsecWinners := 0;
                end else
                begin
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecWinners := 0;
                    f_ConsecLosers := 0;
                end;

                Inc(f_PMData.m_NumberOfTrades, f_TradeCount);
                Inc(f_PMData.m_DayOfTradable);

                f_SumProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;
                if f_HighProfit < f_SumProfit then f_HighProfit := f_SumProfit;
                f_Drawdown := f_SumProfit - f_HighProfit;
                if f_PMData.m_MaxDrawdown > f_Drawdown then f_PMData.m_MaxDrawdown := f_Drawdown;
            end;
        end;
    end;
    f_PMData.m_NetProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgDayOfTrades := f_PMData.m_NumberOfTrades / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgDayOfTrades := 0;
    end;

    if f_PMData.m_DayOfWinningTrades <> 0 then
    begin
        f_PMData.m_AverageWinningTrade := f_PMData.m_GrossProfit / f_PMData.m_DayOfWinningTrades;
    end else
    begin
        f_PMData.m_AverageWinningTrade := 0;
    end;

    if f_PMData.m_DayOfLosingTrades <> 0 then
    begin
        f_PMData.m_AverageLosingTrade := f_PMData.m_GrossLoss / f_PMData.m_DayOfLosingTrades;
    end else
    begin
        f_PMData.m_AverageLosingTrade := 0;
    end;

    if f_PMData.m_AverageLosingTrade <> 0 then
    begin
        f_PMData.m_RatioAvgWinAvgLoss := abs(f_PMData.m_AverageWinningTrade / f_PMData.m_AverageLosingTrade);
    end else
    begin
        f_PMData.m_RatioAvgWinAvgLoss := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_PercentProfitable := (f_PMData.m_DayOfWinningTrades / f_PMData.m_DayOfTradable)*100.0;
    end else
    begin
        f_PMData.m_PercentProfitable := 0;
    end;

    if f_PMData.m_GrossProfit <> 0 then
    begin
        f_PMData.m_SuccessRate := (f_PMData.m_NetProfit / f_PMData.m_GrossProfit)*100.0;
    end else
    begin
        f_PMData.m_SuccessRate := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgTrade := f_PMData.m_NetProfit / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgTrade := 0;
    end;

    if f_PMData.m_GrossLoss <> 0 then
    begin
        f_PMData.m_ProfitFactor := abs(f_PMData.m_GrossProfit / f_PMData.m_GrossLoss);
    end else
    begin
        f_PMData.m_ProfitFactor := 0;
    end;
    {$ENDREGION}

    {$REGION '1차 신호의 매도거래'}
    f_PMData := m_PMData[2];
    f_PMData.DefaultValue;
    f_HighProfit := 0;

    f_ConsecWinners:=0;
    f_ConsecLosers:=0;

    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_ValueIndex = f_Size - 1  then
        begin
            f_PMData.m_Date                      := f_ChartData.m_Date ;
            f_PMData.m_Price                     := f_ChartData.m_Price;
            f_PMData.m_Enabled                   := 1;
        end;
        if f_ValueIndex >= f_OriginIndex then
        begin
            f_Profit := f_ChartData.m_SProfit;
            f_Tradable := true;
            f_TradeCount := Trunc(f_ChartData.m_SNumberOfTrades);
            Inc(f_PMData.m_DayOfTrades);
            if f_Tradable then
            begin
                if f_Profit > 0 then
                begin
                    f_PMData.m_GrossProfit := f_PMData.m_GrossProfit + f_Profit;
                    Inc(f_PMData.m_DayOfWinningTrades);
                    if (f_PMData.m_LargestWinningTrade < f_Profit) then f_PMData.m_LargestWinningTrade := f_Profit;
                    Inc(f_ConsecWinners);
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecLosers := 0;
                end else
                if f_Profit < 0 then
                begin
                    f_PMData.m_GrossLoss := f_PMData.m_GrossLoss + f_Profit;
                    Inc(f_PMData.m_DayOfLosingTrades);
                    if (f_PMData.m_LargestLosingTrade > f_Profit) then f_PMData.m_LargestLosingTrade := f_Profit;
                    Inc(f_ConsecLosers);
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    f_ConsecWinners := 0;
                end else
                begin
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecWinners := 0;
                    f_ConsecLosers := 0;
                end;

                Inc(f_PMData.m_NumberOfTrades, f_TradeCount);
                Inc(f_PMData.m_DayOfTradable);

                f_SumProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;
                if f_HighProfit < f_SumProfit then f_HighProfit := f_SumProfit;
                f_Drawdown := f_SumProfit - f_HighProfit;
                if f_PMData.m_MaxDrawdown > f_Drawdown then f_PMData.m_MaxDrawdown := f_Drawdown;
            end;
        end;
    end;
    f_PMData.m_NetProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgDayOfTrades := f_PMData.m_NumberOfTrades / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgDayOfTrades := 0;
    end;

    if f_PMData.m_DayOfWinningTrades <> 0 then
    begin
        f_PMData.m_AverageWinningTrade := f_PMData.m_GrossProfit / f_PMData.m_DayOfWinningTrades;
    end else
    begin
        f_PMData.m_AverageWinningTrade := 0;
    end;

    if f_PMData.m_DayOfLosingTrades <> 0 then
    begin
        f_PMData.m_AverageLosingTrade := f_PMData.m_GrossLoss / f_PMData.m_DayOfLosingTrades;
    end else
    begin
        f_PMData.m_AverageLosingTrade := 0;
    end;

    if f_PMData.m_AverageLosingTrade <> 0 then
    begin
        f_PMData.m_RatioAvgWinAvgLoss := abs(f_PMData.m_AverageWinningTrade / f_PMData.m_AverageLosingTrade);
    end else
    begin
        f_PMData.m_RatioAvgWinAvgLoss := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_PercentProfitable := (f_PMData.m_DayOfWinningTrades / f_PMData.m_DayOfTradable)*100.0;
    end else
    begin
        f_PMData.m_PercentProfitable := 0;
    end;

    if f_PMData.m_GrossProfit <> 0 then
    begin
        f_PMData.m_SuccessRate := (f_PMData.m_NetProfit / f_PMData.m_GrossProfit)*100.0;
    end else
    begin
        f_PMData.m_SuccessRate := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgTrade := f_PMData.m_NetProfit / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgTrade := 0;
    end;

    if f_PMData.m_GrossLoss <> 0 then
    begin
        f_PMData.m_ProfitFactor := abs(f_PMData.m_GrossProfit / f_PMData.m_GrossLoss);
    end else
    begin
        f_PMData.m_ProfitFactor := 0;
    end;
    {$ENDREGION}

    {$REGION '2차 신호의 전체거래'}
    f_PMData := m_PMData[3];
    f_PMData.DefaultValue;
    f_HighProfit := 0;

    f_ConsecWinners:=0;
    f_ConsecLosers:=0;

    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_ValueIndex = f_Size - 1  then
        begin
            f_PMData.m_Date                      := f_ChartData.m_Date ;
            f_PMData.m_Price                     := f_ChartData.m_Price;
            f_PMData.m_Enabled                   := 1;
        end;

        if f_ValueIndex >= f_OriginIndex then
        begin
            f_Profit := f_ChartData.m_TProfit;
            f_Tradable := (f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] = 1) OR (f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] = 1);

            f_TradeCount := 0;
            if f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] = 1 then f_TradeCount := f_TradeCount + Trunc(f_ChartData.m_BNumberOfTrades);
            if f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] = 1 then f_TradeCount := f_TradeCount + Trunc(f_ChartData.m_SNumberOfTrades);


            Inc(f_PMData.m_DayOfTrades);
            if f_Tradable then
            begin
                if f_Profit > 0 then
                begin
                    f_PMData.m_GrossProfit := f_PMData.m_GrossProfit + f_Profit;
                    Inc(f_PMData.m_DayOfWinningTrades);
                    if (f_PMData.m_LargestWinningTrade < f_Profit) then f_PMData.m_LargestWinningTrade := f_Profit;
                    Inc(f_ConsecWinners);
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecLosers := 0;
                end else
                if f_Profit < 0 then
                begin
                    f_PMData.m_GrossLoss := f_PMData.m_GrossLoss + f_Profit;
                    Inc(f_PMData.m_DayOfLosingTrades);
                    if (f_PMData.m_LargestLosingTrade > f_Profit) then f_PMData.m_LargestLosingTrade := f_Profit;
                    Inc(f_ConsecLosers);
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    f_ConsecWinners := 0;
                end else
                begin
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecWinners := 0;
                    f_ConsecLosers := 0;
                end;

                Inc(f_PMData.m_NumberOfTrades, f_TradeCount);
                Inc(f_PMData.m_DayOfTradable);

                f_SumProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;
                if f_HighProfit < f_SumProfit then f_HighProfit := f_SumProfit;
                f_Drawdown := f_SumProfit - f_HighProfit;
                if f_PMData.m_MaxDrawdown > f_Drawdown then f_PMData.m_MaxDrawdown := f_Drawdown;
            end;
        end;
    end;
    f_PMData.m_NetProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgDayOfTrades := f_PMData.m_NumberOfTrades / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgDayOfTrades := 0;
    end;

    if f_PMData.m_DayOfWinningTrades <> 0 then
    begin
        f_PMData.m_AverageWinningTrade := f_PMData.m_GrossProfit / f_PMData.m_DayOfWinningTrades;
    end else
    begin
        f_PMData.m_AverageWinningTrade := 0;
    end;

    if f_PMData.m_DayOfLosingTrades <> 0 then
    begin
        f_PMData.m_AverageLosingTrade := f_PMData.m_GrossLoss / f_PMData.m_DayOfLosingTrades;
    end else
    begin
        f_PMData.m_AverageLosingTrade := 0;
    end;

    if f_PMData.m_AverageLosingTrade <> 0 then
    begin
        f_PMData.m_RatioAvgWinAvgLoss := abs(f_PMData.m_AverageWinningTrade / f_PMData.m_AverageLosingTrade);
    end else
    begin
        f_PMData.m_RatioAvgWinAvgLoss := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_PercentProfitable := (f_PMData.m_DayOfWinningTrades / f_PMData.m_DayOfTradable)*100.0;
    end else
    begin
        f_PMData.m_PercentProfitable := 0;
    end;

    if f_PMData.m_GrossProfit <> 0 then
    begin
        f_PMData.m_SuccessRate := (f_PMData.m_NetProfit / f_PMData.m_GrossProfit)*100.0;
    end else
    begin
        f_PMData.m_SuccessRate := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgTrade := f_PMData.m_NetProfit / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgTrade := 0;
    end;

    if f_PMData.m_GrossLoss <> 0 then
    begin
        f_PMData.m_ProfitFactor := abs(f_PMData.m_GrossProfit / f_PMData.m_GrossLoss);
    end else
    begin
        f_PMData.m_ProfitFactor := 0;
    end;
    {$ENDREGION}

    {$REGION '2차 신호의 매수거래'}
    f_PMData := m_PMData[4];
    f_PMData.DefaultValue;
    f_HighProfit := 0;

    f_ConsecWinners:=0;
    f_ConsecLosers:=0;

    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_ValueIndex = f_Size - 1  then
        begin
            f_PMData.m_Date     := f_ChartData.m_Date ;
            f_PMData.m_Price    := f_ChartData.m_Price;
            f_PMData.m_Enabled  := Trunc(f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE]);
            f_PMData.m_Enabled2 := Trunc(f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE2]);
        end;

        if f_ValueIndex >= f_OriginIndex then
        begin
            f_Profit := f_ChartData.m_BProfit;
            f_Tradable := (f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] = 1);

            f_TradeCount := 0;
            if f_LineValue0.m_Value[NAV_BPROFIT_ENAVLE] = 1 then f_TradeCount := f_TradeCount + Trunc(f_ChartData.m_BNumberOfTrades);

            Inc(f_PMData.m_DayOfTrades);
            if f_Tradable then
            begin
                if f_Profit > 0 then
                begin
                    f_PMData.m_GrossProfit := f_PMData.m_GrossProfit + f_Profit;
                    Inc(f_PMData.m_DayOfWinningTrades);
                    if (f_PMData.m_LargestWinningTrade < f_Profit) then f_PMData.m_LargestWinningTrade := f_Profit;
                    Inc(f_ConsecWinners);
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecLosers := 0;
                end else
                if f_Profit < 0 then
                begin
                    f_PMData.m_GrossLoss := f_PMData.m_GrossLoss + f_Profit;
                    Inc(f_PMData.m_DayOfLosingTrades);
                    if (f_PMData.m_LargestLosingTrade > f_Profit) then f_PMData.m_LargestLosingTrade := f_Profit;
                    Inc(f_ConsecLosers);
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    f_ConsecWinners := 0;
                end else
                begin
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecWinners := 0;
                    f_ConsecLosers := 0;
                end;

                Inc(f_PMData.m_NumberOfTrades, f_TradeCount);
                Inc(f_PMData.m_DayOfTradable);

                f_SumProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;
                if f_HighProfit < f_SumProfit then f_HighProfit := f_SumProfit;
                f_Drawdown := f_SumProfit - f_HighProfit;
                if f_PMData.m_MaxDrawdown > f_Drawdown then f_PMData.m_MaxDrawdown := f_Drawdown;
            end;
        end;
    end;
    f_PMData.m_NetProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgDayOfTrades := f_PMData.m_NumberOfTrades / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgDayOfTrades := 0;
    end;

    if f_PMData.m_DayOfWinningTrades <> 0 then
    begin
        f_PMData.m_AverageWinningTrade := f_PMData.m_GrossProfit / f_PMData.m_DayOfWinningTrades;
    end else
    begin
        f_PMData.m_AverageWinningTrade := 0;
    end;

    if f_PMData.m_DayOfLosingTrades <> 0 then
    begin
        f_PMData.m_AverageLosingTrade := f_PMData.m_GrossLoss / f_PMData.m_DayOfLosingTrades;
    end else
    begin
        f_PMData.m_AverageLosingTrade := 0;
    end;

    if f_PMData.m_AverageLosingTrade <> 0 then
    begin
        f_PMData.m_RatioAvgWinAvgLoss := abs(f_PMData.m_AverageWinningTrade / f_PMData.m_AverageLosingTrade);
    end else
    begin
        f_PMData.m_RatioAvgWinAvgLoss := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_PercentProfitable := (f_PMData.m_DayOfWinningTrades / f_PMData.m_DayOfTradable)*100.0;
    end else
    begin
        f_PMData.m_PercentProfitable := 0;
    end;

    if f_PMData.m_GrossProfit <> 0 then
    begin
        f_PMData.m_SuccessRate := (f_PMData.m_NetProfit / f_PMData.m_GrossProfit)*100.0;
    end else
    begin
        f_PMData.m_SuccessRate := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgTrade := f_PMData.m_NetProfit / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgTrade := 0;
    end;

    if f_PMData.m_GrossLoss <> 0 then
    begin
        f_PMData.m_ProfitFactor := abs(f_PMData.m_GrossProfit / f_PMData.m_GrossLoss);
    end else
    begin
        f_PMData.m_ProfitFactor := 0;
    end;
    {$ENDREGION}

    {$REGION '2차 신호의 매도거래'}
    f_PMData := m_PMData[5];
    f_PMData.DefaultValue;
    f_HighProfit := 0;

    f_ConsecWinners:=0;
    f_ConsecLosers:=0;

    for f_ValueIndex := 0 to f_Size - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_LineValue0 := m_NAVSeries.m_Items[f_ValueIndex];

        if f_ValueIndex = f_Size - 1  then
        begin
            f_PMData.m_Date                      := f_ChartData.m_Date ;
            f_PMData.m_Price                     := f_ChartData.m_Price;
            f_PMData.m_Enabled                   := Trunc(f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE]);
            f_PMData.m_Enabled2                  := Trunc(f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE2]);
        end;

        if f_ValueIndex >= f_OriginIndex then
        begin
            f_Profit := f_ChartData.m_SProfit;
            f_Tradable := (f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] = 1);

            f_TradeCount := 0;
            if f_LineValue0.m_Value[NAV_SPROFIT_ENAVLE] = 1 then f_TradeCount := f_TradeCount + Trunc(f_ChartData.m_SNumberOfTrades);

            Inc(f_PMData.m_DayOfTrades);
            if f_Tradable then
            begin
                if f_Profit > 0 then
                begin
                    f_PMData.m_GrossProfit := f_PMData.m_GrossProfit + f_Profit;
                    Inc(f_PMData.m_DayOfWinningTrades);
                    if (f_PMData.m_LargestWinningTrade < f_Profit) then f_PMData.m_LargestWinningTrade := f_Profit;
                    Inc(f_ConsecWinners);
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecLosers := 0;
                end else
                if f_Profit < 0 then
                begin
                    f_PMData.m_GrossLoss := f_PMData.m_GrossLoss + f_Profit;
                    Inc(f_PMData.m_DayOfLosingTrades);
                    if (f_PMData.m_LargestLosingTrade > f_Profit) then f_PMData.m_LargestLosingTrade := f_Profit;
                    Inc(f_ConsecLosers);
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    f_ConsecWinners := 0;
                end else
                begin
                    if f_PMData.m_MaxConsecWinners < f_ConsecWinners then f_PMData.m_MaxConsecWinners := f_ConsecWinners;
                    if f_PMData.m_MaxConsecLosers < f_ConsecLosers then f_PMData.m_MaxConsecLosers := f_ConsecLosers;
                    f_ConsecWinners := 0;
                    f_ConsecLosers := 0;
                end;

                Inc(f_PMData.m_NumberOfTrades, f_TradeCount);
                Inc(f_PMData.m_DayOfTradable);

                f_SumProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;
                if f_HighProfit < f_SumProfit then f_HighProfit := f_SumProfit;
                f_Drawdown := f_SumProfit - f_HighProfit;
                if f_PMData.m_MaxDrawdown > f_Drawdown then f_PMData.m_MaxDrawdown := f_Drawdown;
            end;
        end;
    end;
    f_PMData.m_NetProfit := f_PMData.m_GrossProfit + f_PMData.m_GrossLoss;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgDayOfTrades := f_PMData.m_NumberOfTrades / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgDayOfTrades := 0;
    end;

    if f_PMData.m_DayOfWinningTrades <> 0 then
    begin
        f_PMData.m_AverageWinningTrade := f_PMData.m_GrossProfit / f_PMData.m_DayOfWinningTrades;
    end else
    begin
        f_PMData.m_AverageWinningTrade := 0;
    end;

    if f_PMData.m_DayOfLosingTrades <> 0 then
    begin
        f_PMData.m_AverageLosingTrade := f_PMData.m_GrossLoss / f_PMData.m_DayOfLosingTrades;
    end else
    begin
        f_PMData.m_AverageLosingTrade := 0;
    end;

    if f_PMData.m_AverageLosingTrade <> 0 then
    begin
        f_PMData.m_RatioAvgWinAvgLoss := abs(f_PMData.m_AverageWinningTrade / f_PMData.m_AverageLosingTrade);
    end else
    begin
        f_PMData.m_RatioAvgWinAvgLoss := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_PercentProfitable := (f_PMData.m_DayOfWinningTrades / f_PMData.m_DayOfTradable)*100.0;
    end else
    begin
        f_PMData.m_PercentProfitable := 0;
    end;

    if f_PMData.m_GrossProfit <> 0 then
    begin
        f_PMData.m_SuccessRate := (f_PMData.m_NetProfit / f_PMData.m_GrossProfit)*100.0;
    end else
    begin
        f_PMData.m_SuccessRate := 0;
    end;

    if f_PMData.m_DayOfTradable <> 0 then
    begin
        f_PMData.m_AvgTrade := f_PMData.m_NetProfit / f_PMData.m_DayOfTradable;
    end else
    begin
        f_PMData.m_AvgTrade := 0;
    end;

    if f_PMData.m_GrossLoss <> 0 then
    begin
        f_PMData.m_ProfitFactor := abs(f_PMData.m_GrossProfit / f_PMData.m_GrossLoss);
    end else
    begin
        f_PMData.m_ProfitFactor := 0;
    end;
    {$ENDREGION}

end;

//---------------------------------------------------------------------------
constructor CFNCMDAnlysisBuySell.Create;
var
    f_Index:Integer;
begin
    inherited Create;
    m_ChartDataSeries := CFNNAVAnalChartDataSeries.Create;
    m_NAVSeries := Creator_NAV;
    m_Option := CFNNAVAnalOption.Create;
    m_EnableEvent := false;

    for f_Index := 0 to 5 do
    begin
        m_PMData[f_Index] := CFNNAVAnalPMData.Create;
        m_PMValueCollection[f_Index] := CFNPMValueCollection.Create;
    end;

    m_ADOQuery:= TADOQuery.Create(NIL);
end;

//---------------------------------------------------------------------------
destructor CFNCMDAnlysisBuySell.Destroy;
var
    f_Index:Integer;
begin
    m_ChartDataSeries.Free;
    m_NAVSeries.Free;
    m_Option.Free;

    for f_Index := 0 to 5 do
    begin
        m_PMData[f_Index].Free;
        m_PMValueCollection[f_Index].Free;
    end;
    m_ADOQuery.Active := false;
    m_ADOQuery.Free;

    inherited;
end;

//---------------------------------------------------------------------------
procedure CFNCMDAnlysisBuySell.InsertDailyReport( AChartData: CFNNAVAnalChartData);
var
    f_SQLString:String;
begin
    f_SQLString := 'EXEC INSERT_DAILY_REPORT ' +
    '''' + TFNGlobal.DateToString_YYYYMMDD(AChartData.m_Date) + ''', ' +
    '''' + m_Symbol + ''', ' +
    IntToStr(m_MA) + ', ' +
    IntToStr(m_DType) + ', ' +
    FloatToStr(AChartData.m_TProfit) + ', ' +
    FloatToStr(AChartData.m_BProfit) + ', ' +
    FloatToStr(AChartData.m_SProfit) + ', ' +
    FloatToStr(AChartData.m_TProfitSum) + ', ' +
    FloatToStr(AChartData.m_BProfitSum) + ', ' +
    FloatToStr(AChartData.m_SProfitSum) + ', ' +
    IntToStr(Trunc(AChartData.m_TNumberOfTrades)) + ', ' +
    IntToStr(Trunc(AChartData.m_BNumberOfTrades)) + ', ' +
    IntToStr(Trunc(AChartData.m_SNumberOfTrades)) + ', ' +
    FloatToStr(AChartData.m_Price);

    m_ADOQuery.SQL.Clear;
    m_ADOQuery.SQL.Add(f_SQLString);
    m_ADOQuery.ExecSQL;
end;

//---------------------------------------------------------------------------
procedure CFNCMDAnlysisBuySell.InsertPerformance(ATradeType:Integer; ACalcType:Integer; AStandDate:TDateTime;  APMData: CFNNAVAnalPMData);
var
    f_SQLString:String;
begin
    f_SQLString := 'EXEC INSERT_PERFORMANCE ' +
    '''' + TFNGlobal.DateToString_YYYYMMDD(APMData.m_Date) + ''', ' +
    '''' + m_Symbol + ''', ' +
    IntToStr(m_MA) + ', ' +
    IntToStr(m_DType) + ', ' +
    IntToStr(ATradeType) + ', ' +
    IntToStr(ACalcType) + ', ' +
    IntToStr(APMData.m_Enabled) + ', ' +
    IntToStr(APMData.m_Enabled2) + ', ' +

    FloatToStr(APMData.m_NetProfit) + ', ' +
    FloatToStr(APMData.m_GrossProfit) + ', ' +
    FloatToStr(APMData.m_GrossLoss) + ', ' +
    IntToStr(APMData.m_NumberOfTrades) + ', ' +
    FloatToStr(APMData.m_AvgDayOfTrades) + ', ' +
    IntToStr(APMData.m_DayOfTrades) + ', ' +
    IntToStr(APMData.m_DayOfTradable) + ', ' +
    IntToStr(APMData.m_DayOfWinningTrades) + ', ' +
    IntToStr(APMData.m_DayOfLosingTrades) + ', ' +
    FloatToStr(APMData.m_PercentProfitable) + ', ' +
    FloatToStr(APMData.m_LargestWinningTrade) + ', ' +
    FloatToStr(APMData.m_LargestLosingTrade) + ', ' +
    FloatToStr(APMData.m_AverageWinningTrade) + ', ' +
    FloatToStr(APMData.m_AverageLosingTrade) + ', ' +
    FloatToStr(APMData.m_RatioAvgWinAvgLoss) + ', ' +
    FloatToStr(APMData.m_AvgTrade) + ', ' +
    IntToStr(APMData.m_MaxConsecWinners) + ', ' +
    IntToStr(APMData.m_MaxConsecLosers) + ', ' +
    FloatToStr(APMData.m_MaxDrawdown) + ', ' +
    FloatToStr(APMData.m_ProfitFactor) + ', ' +
    FloatToStr(APMData.m_SuccessRate) + ', ' +
    FloatToStr(APMData.m_Price);

    m_ADOQuery.SQL.Clear;
    m_ADOQuery.SQL.Add(f_SQLString);
    m_ADOQuery.ExecSQL;

end;

//---------------------------------------------------------------------------
end.

