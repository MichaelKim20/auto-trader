unit FNCMDSort;

interface

uses
    Windows, Math, SysUtils, Classes, ExtCtrls,
    SyncObjs, FNQueue, DB, DBTables, ADODB,
    FNThread, FNTradeSystem, FNTrafficManager, FNNAVAnalChartData, FNNAVAnalChartDataSeries, FNNAVAnalLineValueSeries;

type
    //---------------------------------------------------------------------------
    CFNCMDSort = class(TObject)
    private
        m_ChartDataSeries   :   CFNNAVAnalChartDataSeries;
        m_NAVSeries         :   CFNNAVAnalLineValueSeries;

        procedure ReadDailyReport;
        procedure WriteDailyReport;


    public
        m_InputFileName :   String;
        m_OutFileName :   String;

        constructor Create;
        destructor Destroy; override;

        procedure Analysis;
    end;

implementation

uses
    DateUtils, Forms, FNSocketManager, FNCMVariable, FNSymbolCollection, FNGlobal, FNNAVAnalLineValue,
    FNNAVAnalLineValueSeriesCreator;

//---------------------------------------------------------------------------
constructor CFNCMDSort.Create;
var
    f_Index:Integer;
begin
    inherited Create;
    m_ChartDataSeries := CFNNAVAnalChartDataSeries.Create;
    m_NAVSeries := Creator_NAV;

end;

//---------------------------------------------------------------------------
destructor CFNCMDSort.Destroy;
var
    f_Index:Integer;
begin
    m_ChartDataSeries.Free;
    m_NAVSeries.Free;


    inherited;
end;

//---------------------------------------------------------------------------
procedure CFNCMDSort.Analysis;
begin
    ReadDailyReport;
    WriteDailyReport;
end;

//---------------------------------------------------------------------------
procedure CFNCMDSort.ReadDailyReport;
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

            f_ChartData := CFNNAVAnalChartData.Create;

            f_ChartData.m_Date := f_Date;

            f_ChartData.m_TProfit           := TFNGlobal.atof(f_FieldList[1]);
            f_ChartData.m_TProfitSum        := TFNGlobal.atof(f_FieldList[2]);

            f_ChartData.m_BProfit           := TFNGlobal.atof(f_FieldList[3]);
            f_ChartData.m_BProfitSum        := TFNGlobal.atof(f_FieldList[4]);

            f_ChartData.m_SProfit           := TFNGlobal.atof(f_FieldList[5]);
            f_ChartData.m_SProfitSum        := TFNGlobal.atof(f_FieldList[6]);

            f_ChartData.m_TNumberOfTrades   := TFNGlobal.atof(f_FieldList[7]);
            f_ChartData.m_BNumberOfTrades   := TFNGlobal.atof(f_FieldList[8]);
            f_ChartData.m_SNumberOfTrades   := TFNGlobal.atof(f_FieldList[9]);

            f_ChartData.m_Price             := TFNGlobal.atof(f_FieldList[10]);

            m_ChartDataSeries.Add(f_ChartData);
        end;

    finally
        f_RecordList.Free;
        f_FieldList.Free;
    end;
end;

//------------------------------------------------------------------------------------
procedure CFNCMDSort.WriteDailyReport;
var
    f_ValueIndex:Integer;
    f_ChartData:CFNNAVAnalChartData;
    f_TProfitSum, f_BProfitSum, f_SProfitSum : Double;

    f_TrafficManager:CFNTrafficManager;
    f_TrafficCollection : CFNTrafficCollection;
    f_Mode:Word;
    f_FileStream:TFileStream;
    f_TimeString:String;
    f_DesEncoding:TEncoding;
    f_ByteOrderMark:TBytes;
    f_Buffer:TBytes;
    f_ItemIndex:integer;
    f_TrafficItem : CFNTrafficItem;
    f_Line:String;
begin

    f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;

    f_FileStream  := TFileStream.Create(m_OutFileName, f_Mode);
    if Assigned(f_FileStream) then
    begin
        f_DesEncoding   := TEncoding.UTF8;
        f_ByteOrderMark := f_DesEncoding.GetPreamble;
        if (f_FileStream.Size <= 0) then
        begin
            f_FileStream.Size := 0;
            f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
        end;

        f_Line := '날짜,전체거래의 이익,전체거래의 이익 누적,매수거래의 이익,매수거래의 이익 누적,매도거래의 이익,매도거래의 이익누적,전체거래의 거래횟수,매수거래의 거래횟수,매도거래의 거래횟수,가격'+ #$D#$A;
        f_Buffer := f_DesEncoding.GetBytes(f_Line);
        f_FileStream.Seek(0, FILE_END);
        f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

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

            f_Line :=
                DateToStr(f_ChartData.m_Date) + ',' +
                Format('%.5f', [f_ChartData.m_TProfit]) + ',' +
                Format('%.5f', [f_ChartData.m_TProfitSum]) + ',' +
                Format('%.5f', [f_ChartData.m_BProfit]) + ',' +
                Format('%.5f', [f_ChartData.m_BProfitSum]) + ',' +
                Format('%.5f', [f_ChartData.m_SProfit]) + ',' +
                Format('%.5f', [f_ChartData.m_SProfitSum]) + ',' +
                Format('%.2f', [f_ChartData.m_TNumberOfTrades]) + ',' +
                Format('%.2f', [f_ChartData.m_BNumberOfTrades]) + ',' +
                Format('%.2f', [f_ChartData.m_SNumberOfTrades]) + ',' +
                Format('%.5f', [f_ChartData.m_Price]) + #$D#$A;

            f_Buffer := f_DesEncoding.GetBytes(f_Line);
            f_FileStream.Seek(0, FILE_END);
            f_FileStream.Write(f_Buffer[0], Length(f_Buffer));
        end;

        f_FileStream.Free;
        f_FileStream := NIL;
    end;
end;



//---------------------------------------------------------------------------
end.

