unit FNCMDDailyReport;

interface

uses
    Windows, Math, SysUtils, Classes, ExtCtrls,
    SyncObjs, FNQueue, DB, DBTables, ADODB,
    FNThread, FNTradeSystem, FNTrafficManager, FNNAVAnalChartData, FNNAVAnalChartDataSeries, FNNAVAnalLineValueSeries;

type
    //---------------------------------------------------------------------------
    CFNCMDDailyReport = class(TObject)
    private
        m_ChartDataSeries   :   CFNNAVAnalChartDataSeries;
        m_NAVSeries         :   CFNNAVAnalLineValueSeries;
        m_Query             :   TQuery      ;
        m_ADOQuery          :   TADOQuery   ;

        procedure ReadDailyReport;
        procedure WriteDailyReport;

        procedure InsertDailyReport(AChartData:CFNNAVAnalChartData);

    public
        m_StartDate     :   TDateTime;
        m_EndDate       :   TDateTime;
        m_InputFileName :   String;
        m_Condition     :   String;
        m_TimeFrame     :   Integer;
        m_Unit          :   Double;

        m_DataSource    :   String;
        m_UserID        :   String;
        m_Password      :   String;
        m_StoredProcedure :   String;

        constructor Create;
        destructor Destroy; override;

        procedure Analysis;
    end;

implementation

uses
    DateUtils, Forms, FNSocketManager, FNCMVariable, FNSymbolCollection, FNGlobal, FNNAVAnalLineValue,
    FNNAVAnalLineValueSeriesCreator;

//---------------------------------------------------------------------------
constructor CFNCMDDailyReport.Create;
var
    f_Index:Integer;
begin
    inherited Create;
    m_ChartDataSeries := CFNNAVAnalChartDataSeries.Create;
    m_NAVSeries := Creator_NAV;

    m_ADOQuery:= TADOQuery.Create(NIL);

    m_StoredProcedure := 'SR..INSERT_DAILY_REPORT';
end;

//---------------------------------------------------------------------------
destructor CFNCMDDailyReport.Destroy;
var
    f_Index:Integer;
begin
    m_ChartDataSeries.Free;
    m_NAVSeries.Free;

    m_ADOQuery.Active := false;
    m_ADOQuery.Free;

    inherited;
end;

//---------------------------------------------------------------------------
procedure CFNCMDDailyReport.Analysis;
begin
    m_ADOQuery.ConnectionString := 'Provider=SQLOLEDB.1;Password=' + Trim(m_Password) + ';Persist Security Info=True;User ID=' + Trim(m_UserID) + ';Initial Catalog=MATRIX_OS;Data Source=' + Trim(m_DataSource) + '';

    ReadDailyReport;
    WriteDailyReport;
end;

//---------------------------------------------------------------------------
procedure CFNCMDDailyReport.ReadDailyReport;
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
    f_FileName := Trim(m_InputFileName);

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

                f_ChartData.m_TProfit           := TFNGlobal.atof(f_FieldList[1]) * m_Unit;
                f_ChartData.m_TProfitSum        := TFNGlobal.atof(f_FieldList[2]) * m_Unit;

                f_ChartData.m_BProfit           := TFNGlobal.atof(f_FieldList[3]) * m_Unit;
                f_ChartData.m_BProfitSum        := TFNGlobal.atof(f_FieldList[4]) * m_Unit;

                f_ChartData.m_SProfit           := TFNGlobal.atof(f_FieldList[5]) * m_Unit;
                f_ChartData.m_SProfitSum        := TFNGlobal.atof(f_FieldList[6]) * m_Unit;

                f_ChartData.m_TNumberOfTrades   := TFNGlobal.atof(f_FieldList[7]);
                f_ChartData.m_BNumberOfTrades   := TFNGlobal.atof(f_FieldList[8]);
                f_ChartData.m_SNumberOfTrades   := TFNGlobal.atof(f_FieldList[9]);

                f_ChartData.m_Price             := TFNGlobal.atof(f_FieldList[10]);

                m_ChartDataSeries.Add(f_ChartData);
            end;
        end;

    finally
        f_RecordList.Free;
        f_FieldList.Free;
    end;
end;

//------------------------------------------------------------------------------------
procedure CFNCMDDailyReport.WriteDailyReport;
var
    f_ValueIndex:Integer;
    f_ChartData:CFNNAVAnalChartData;
    f_TProfitSum, f_BProfitSum, f_SProfitSum : Double;
begin
    f_TProfitSum := 0;
    f_BProfitSum := 0;
    f_SProfitSum := 0;

    for f_ValueIndex := 0 to m_ChartDataSeries.m_Items.Count - 1 do
    begin
        f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
        f_TProfitSum := f_TProfitSum + f_ChartData.m_TProfit;
        f_BProfitSum := f_BProfitSum + f_ChartData.m_BProfit;
        f_SProfitSum := f_SProfitSum + f_ChartData.m_SProfit;

        f_ChartData.m_TProfitSum := f_TProfitSum;
        f_ChartData.m_BProfitSum := f_BProfitSum;
        f_ChartData.m_SProfitSum := f_SProfitSum;

        if (CompareValue(m_StartDate,  f_ChartData.m_Date, 0.5) <= 0) and (CompareValue(f_ChartData.m_Date, m_EndDate, 0.5) <= 0) then
        begin
            InsertDailyReport(f_ChartData);
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNCMDDailyReport.InsertDailyReport( AChartData: CFNNAVAnalChartData);
var
    f_SQLString:String;
begin
    f_SQLString := 'EXEC ' + m_StoredProcedure + ' ' +
    '''' + m_Condition + ''', ' +
    IntToStr(m_TimeFrame) + ', ' +
    '''' + TFNGlobal.DateToString_YYYYMMDD(AChartData.m_Date) + ''', ' +
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
end.

