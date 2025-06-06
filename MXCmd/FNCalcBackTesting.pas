unit FNCalcBackTesting;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ImgList, ActnList,  StdCtrls, ComCtrls, ExtCtrls, ToolWin, MXBlock, FNTradeSystem, 
    FNTrafficManager, MXOption, MXSystemManager, MXOrderManager;

type
    //---------------------------------------------------------------------------
    CFNCalcBackTesting = class(TObject)
    private
        m_Block:CMXBlock;

        m_StandDate : TDateTime;
        m_StartDate : TDateTime;
        m_EndDate : TDateTime;
        m_AttachMode : Boolean;

        m_Doing : Boolean;

        m_TradeListFileName : String;
        m_DailyPerfomanceFileName : String;

        m_DailyPMValueCollection:CFNDailyPMValueCollection;

        m_OptionName:String;

        procedure SaveConfigData;

        procedure MakeTradeListFile;
        procedure SaveTradeList;

        procedure MakeDailyPerfomanceFile;
        procedure SaveDailyPerfomance;
        procedure ReadDailyReport;

        function GetOptionName:String;

    protected
        procedure OnLog(ASender: TObject; ADateTime:TDateTime; AType:Integer; AMessage, AClassName:String);
        procedure OnDoneWork1Day(Sender: TObject);

    public
        m_NextDay:Boolean;

        procedure DoStart1Day;
    public
        constructor Create;
        destructor Destroy; override;

        procedure SetBlockData(ABlockData:CMXBlockData);

        procedure Start;
        procedure Stop;

        property StartDate:TDateTime read m_StartDate write m_StartDate;
        property EndDate:TDateTime read m_EndDate write m_EndDate;
        property Doing:Boolean read m_Doing;
        property AttachMode:Boolean read m_AttachMode write m_AttachMode;
    end;

implementation

uses
    DateUtils, FNSocketManager, FNCMVariable, FNGlobal, FNSymbolCollection, FNPOTCollection,
    MKChartDataSeries, MKChartData, MXTradeStrategyOptionCollection, MKTradeStrategyConst;

//---------------------------------------------------------------------------
constructor CFNCalcBackTesting.Create;
begin
    inherited Create;

    m_Block := CMXBlock.Create;
    m_Block.Option.SetIntegerValue('SYSTEM_MODE'            , SYSTEM_MODE_SIMULATION);
    m_Block.Option.SetBooleanValue('USE_STAND_DATE'         , true);
    m_Block.Option.SetBooleanValue('USE_HISTORY_CHARTDATA'  , true);

    m_Block.SystemManager.BackTestingMode := true;
    //m_Block.SystemManager.AloneMode := true;

    m_DailyPMValueCollection := CFNDailyPMValueCollection.Create;
    m_AttachMode := false;

    m_Doing := false;
    m_NextDay := false;
end;

//---------------------------------------------------------------------------
destructor CFNCalcBackTesting.Destroy;
begin
    if m_Block.SystemManager.State then
    begin
        m_Block.SystemManager.Stop;
    end;

    if Assigned(m_Block) then
    begin
        m_Block.Free;
        m_Block := NIL;
    end;

    m_DailyPMValueCollection.Free;

    m_Doing := false;

    inherited;
end;

//------------------------------------------------------------------------------------
procedure CFNCalcBackTesting.Start;
var
    f_POTItem:CFNPOTItem;
begin
    if not Assigned(m_Block) then exit;
    if m_Block.SystemManager.State then exit;

    m_Doing := true;
    m_NextDay := false;

    m_DailyPMValueCollection.Clear;
    m_Block.Option.SetIntegerValue('SYSTEM_MODE'            , SYSTEM_MODE_SIMULATION);
    m_Block.Option.SetBooleanValue('USE_STAND_DATE'         , true);
    m_Block.Option.SetBooleanValue('USE_HISTORY_CHARTDATA'  , true);

    m_OptionName := GetOptionName;

    if Assigned(g_POTCollection) then
    begin
        f_POTItem :=
            g_POTCollection.Find(
                TFNGlobal.ServerNow,
                m_Block.Option.GetIntegerValue('COUNTRY_NO' ),
                m_Block.Option.GetIntegerValue('GROUP_NO'   ),
                m_Block.Option.GetIntegerValue('MARKET_NO'  ),
                m_Block.Option.GetStringValue ('SYMBOL'     ));

        if Assigned(f_POTItem) then
        begin
            m_Block.Option.m_POTItem.Clone(f_POTItem);
        end;
    end;

    m_StandDate := m_StartDate;

    SaveConfigData;
    MakeTradeListFile;
    MakeDailyPerfomanceFile;
    ReadDailyReport;

    DoStart1Day;
end;

//------------------------------------------------------------------------------------
procedure CFNCalcBackTesting.Stop;
begin
    m_StandDate := m_EndDate + 1;
    m_Block.SystemManager.StopDelay;
    m_NextDay := false;
end;

//------------------------------------------------------------------------------------
procedure CFNCalcBackTesting.DoStart1Day;
begin
    m_NextDay := false;

    OnLog(Self, Now, LOG_TYPE_INFO, '[ ' + m_Block.BlockName + '_' +  IntToStr(m_Block.Option.GetIntegerValue('TIMEFRAME')) + ' ] 계산을 시작합니다.' + DateToStr(m_StandDate), '');

    m_Block.Option.SetBooleanValue('USE_STAND_DATE'         , true);
    m_Block.Option.SetBooleanValue('USE_HISTORY_CHARTDATA'  , true);
    m_Block.Option.SetIntegerValue('STAND_DATE'             , Trunc(m_StandDate));

    m_Block.SystemManager.Option := m_Block.Option;
    m_Block.SystemManager.BlockName := m_Block.BlockName;
    m_Block.SystemManager.BlockKey := m_Block.BlockKey;
    m_Block.SystemManager.BackTestingMode := true;
    m_Block.SystemManager.AloneMode := true;
    m_Block.SystemManager.SleepMode := true;
    m_Block.SystemManager.OrderManager := NIL;

    m_Block.SystemManager.ApplyTSOCollection(m_Block.SystemManager.Option.StrategyOptionCollection);
    m_Block.SystemManager.OnDoneWork := OnDoneWork1Day;
    m_Block.SystemManager.OnLog := OnLog;

    m_Block.SystemManager.Start;
end;

//------------------------------------------------------------------------------------
function GetBooeanOX(AValue:Boolean):String;
begin
    if AValue then Result := 'O' else Result := 'X';
end;
(*
//------------------------------------------------------------------------------------
function CFNCalcBackTesting.GetOptionName:String;
var
    f_FieldValue:String;
    f_ResultValue:String;
begin
    result := '';
    if not Assigned(m_Block) then exit;

    f_ResultValue := '';

    f_FieldValue := 'S=' + m_Block.BlockName;
    f_ResultValue := f_ResultValue + f_FieldValue;

    result := f_ResultValue;
end;
*)

//------------------------------------------------------------------------------------
function CFNCalcBackTesting.GetOptionName:String;
var
    f_FieldValue:String;
    f_ResultValue:String;  
    f_Option : CMXTradeStrategyOption;
begin
    result := '';
    if not Assigned(m_Block) then exit;

    f_ResultValue := '';

    f_FieldValue := 'S=' + m_Block.Option.GetStringValue('SYMBOL');
    f_ResultValue := f_ResultValue + f_FieldValue + '&';

    f_FieldValue := 'T=' + IntToStr(m_Block.Option.GetIntegerValue('TIMEFRAME'));
    f_ResultValue := f_ResultValue + f_FieldValue + '&';

    if m_Block.Option.StrategyOptionCollection.m_Items.Count > 0 then
    begin
        f_Option := m_Block.Option.StrategyOptionCollection.m_Items[0]; 
        f_FieldValue := 'C=' + f_Option.GetStringValue(TSOPTION_KEY_CATEGORY); 
        f_ResultValue := f_ResultValue + f_FieldValue + '&';
    end;
    

    result := f_ResultValue;
end;

//------------------------------------------------------------------------------------
procedure CFNCalcBackTesting.SetBlockData(ABlockData: CMXBlockData);
begin

    m_Block.BlockName := ABlockData.BlockName;
    m_Block.BlockKey := ABlockData.BlockKey;
    m_Block.Option.Clone(ABlockData.Option);
end;

//------------------------------------------------------------------------------------
procedure CFNCalcBackTesting.OnDoneWork1Day(Sender: TObject);
var
    f_ChartDataSeries:CMKChartDataSeries ;
    f_Index:integer;
    f_ChartData:CMKChartData;
    f_CountOfSameDate:Integer;
    f_DataCount, f_TimeFrame : Integer;
begin
    if not Assigned(m_Block) then exit;

    m_Block.SystemManager.Stop;
    OnLog(Self, Now, LOG_TYPE_INFO, '[ ' + m_Block.BlockName + '_' +  IntToStr(m_Block.Option.GetIntegerValue('TIMEFRAME')) + ' ] 계산을 완료하였습니다.' + DateToStr(m_StandDate), '');

    Sleep(2000);

    try
        f_CountOfSameDate := 0;
        f_ChartDataSeries := m_Block.SystemManager.m_ChartDataSeries;
        for f_Index := f_ChartDataSeries.m_Items.Count - 1 downto 0 do
        begin
            f_ChartData := f_ChartDataSeries.m_Items[f_Index];

            if SameDate(f_ChartData.m_OpenDateTime, m_StandDate) then
            begin
                Inc(f_CountOfSameDate);
            end else
            begin
                break;
            end;
        end;
    finally
    end;

    f_TimeFrame := m_Block.Option.GetIntegerValue('TIMEFRAME');
    if 9000 <= f_TimeFrame then
    begin
        f_DataCount := 9000 div 3;
    end else
    if 1 >= f_TimeFrame then
    begin
        f_DataCount := 1600 div 3;
    end else
    if 2 >= f_TimeFrame then
    begin
        f_DataCount :=  800 div 3;
    end else
    if 5 >= f_TimeFrame then
    begin
        f_DataCount :=  600 div 3;
    end else
    begin
        f_DataCount := 10;
    end;

    try
        if f_CountOfSameDate > f_DataCount then
        begin
            SaveTradeList;
            SaveDailyPerfomance;
        end else
        begin
            OnLog(Self, Now, LOG_TYPE_INFO, '[ ' + m_Block.BlockName + '_' +  IntToStr(m_Block.Option.GetIntegerValue('TIMEFRAME')) + ' ] 휴일이라 판단되어 출력을 하지 않았습니다.' + DateToStr(m_StandDate), '');
        end;
    finally
    end;

    m_StandDate := m_StandDate + 1;
    if (DayOfWeek(m_StandDate) = 7) then m_StandDate := m_StandDate + 1;
    if (DayOfWeek(m_StandDate) = 1) then m_StandDate := m_StandDate + 1;

    if m_StandDate <= m_EndDate then
    begin
        m_NextDay := true;
    end else
    begin
        m_Doing := false;
        OnLog(Self, Now, LOG_TYPE_INFO, '[ ' + m_Block.BlockName +  '_' + IntToStr(m_Block.Option.GetIntegerValue('TIMEFRAME')) + ' ] 모든 계산을 완료하였습니다.', '');
        m_Block.SystemManager.StopDelay;
    end;
end;

//------------------------------------------------------------------------------------
procedure CFNCalcBackTesting.OnLog(ASender: TObject; ADateTime:TDateTime; AType:Integer; AMessage, AClassName:String);
begin
    WriteLn(AMessage);
end;

//------------------------------------------------------------------------------------
procedure CFNCalcBackTesting.SaveConfigData;
var
    f_FileName:String;
    f_FilePath:String;
    f_Stream:TStringStream;
begin
    f_FilePath := ExtractFilePath(ParamStr(0)) + 'BackTesting\';
    if not DirectoryExists(f_FilePath) then
    begin
        CreateDir(f_FilePath);
    end;
    f_FilePath := ExtractFilePath(ParamStr(0)) + 'BackTesting\Config\';
    if not DirectoryExists(f_FilePath) then
    begin
        CreateDir(f_FilePath);
    end;

    f_FileName := f_FilePath + m_Block.BlockName + '&' + m_OptionName + '.xml';

    f_Stream := TStringStream.Create;
    f_Stream.WriteString('<BlockCollection>' + #$0A);
    f_Stream.WriteString(m_Block.Write);
    f_Stream.WriteString('</BlockCollection>' + #$0A);

    f_Stream.SaveToFile(f_FileName);
    f_Stream.Free;
end;

//------------------------------------------------------------------------------------
procedure CFNCalcBackTesting.MakeDailyPerfomanceFile;
var
    f_FileName:String;
    f_FilePath:String;
    f_Mode:Word;
    f_FileStream:TFileStream;
    f_DesEncoding:TEncoding;
    f_ByteOrderMark:TBytes;
    f_Line:String;
    f_Buffer:TBytes;
begin
    f_FilePath := ExtractFilePath(ParamStr(0)) + 'BackTesting\';
    if not DirectoryExists(f_FilePath) then
    begin
        CreateDir(f_FilePath);
    end;
    f_FilePath := ExtractFilePath(ParamStr(0)) + 'BackTesting\DailyPerfomance\';
    if not DirectoryExists(f_FilePath) then
    begin
        CreateDir(f_FilePath);
    end;

    m_DailyPerfomanceFileName := f_FilePath + m_Block.BlockName + '&' + m_OptionName  + '.csv';

    if AttachMode then
    begin
        if Not FileExists(m_DailyPerfomanceFileName) then
        begin
            f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
            f_FileStream  := TFileStream.Create(m_DailyPerfomanceFileName, f_Mode);
            if Assigned(f_FileStream) then
            begin
                if (f_FileStream.Size <= 0) then
                begin
                    f_DesEncoding   := TEncoding.UTF8;
                    f_ByteOrderMark := f_DesEncoding.GetPreamble;

                    f_FileStream.Size := 0;
                    f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
                end;
            end;

            f_Line := '날짜,전체거래의 이익,전체거래의 이익 누적,매수거래의 이익,매수거래의 이익 누적,매도거래의 이익,매도거래의 이익누적,전체거래의 거래횟수,매수거래의 거래횟수,매도거래의 거래횟수,가격'+ #$D#$A;

            f_Buffer := f_DesEncoding.GetBytes(f_Line);
            f_FileStream.Seek(0, FILE_END);
            f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

            f_FileStream.Free;
            f_FileStream := NIL;
        end;
    end else
    begin
        f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
        f_FileStream  := TFileStream.Create(m_DailyPerfomanceFileName, f_Mode);
        if Assigned(f_FileStream) then
        begin
            if (f_FileStream.Size <= 0) then
            begin
                f_DesEncoding   := TEncoding.UTF8;
                f_ByteOrderMark := f_DesEncoding.GetPreamble;

                f_FileStream.Size := 0;
                f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
            end;
        end;

        f_Line := '날짜,전체거래의 이익,전체거래의 이익 누적,매수거래의 이익,매수거래의 이익 누적,매도거래의 이익,매도거래의 이익누적,전체거래의 거래횟수,매수거래의 거래횟수,매도거래의 거래횟수,가격'+ #$D#$A;

        f_Buffer := f_DesEncoding.GetBytes(f_Line);
        f_FileStream.Seek(0, FILE_END);
        f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

        f_FileStream.Free;
        f_FileStream := NIL;
    end;
end;

//------------------------------------------------------------------------------------
procedure CFNCalcBackTesting.MakeTradeListFile;
var
    f_FileName:String;
    f_FilePath:String;
    f_Mode:Word;
    f_FileStream:TFileStream;
    f_DesEncoding:TEncoding;
    f_ByteOrderMark:TBytes;
    f_Line:String;
    f_Buffer:TBytes;
begin
    f_FilePath := ExtractFilePath(ParamStr(0)) + 'BackTesting\';
    if not DirectoryExists(f_FilePath) then
    begin
        CreateDir(f_FilePath);
    end;

    f_FilePath := ExtractFilePath(ParamStr(0)) + 'BackTesting\TradeList\';
    if not DirectoryExists(f_FilePath) then
    begin
        CreateDir(f_FilePath);
    end;

    m_TradeListFileName := f_FilePath + m_Block.BlockName + '&' + m_OptionName + '.csv';

    if AttachMode then
    begin
        if Not FileExists(m_TradeListFileName) then
        begin
            f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
            f_FileStream  := TFileStream.Create(m_TradeListFileName, f_Mode);
            if Assigned(f_FileStream) then
            begin
                if (f_FileStream.Size <= 0) then
                begin
                    f_DesEncoding   := TEncoding.UTF8;
                    f_ByteOrderMark := f_DesEncoding.GetPreamble;

                    f_FileStream.Size := 0;
                    f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
                end;
            end;

            f_Line := '순번,신호종류,진입시간,청산시간,진입가격,청산가격,수익'+ #$D#$A;

            f_Buffer := f_DesEncoding.GetBytes(f_Line);
            f_FileStream.Seek(0, FILE_END);
            f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

            f_FileStream.Free;
            f_FileStream := NIL;
        end;
    end else
    begin
        f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
        f_FileStream  := TFileStream.Create(m_TradeListFileName, f_Mode);
        if Assigned(f_FileStream) then
        begin
            if (f_FileStream.Size <= 0) then
            begin
                f_DesEncoding   := TEncoding.UTF8;
                f_ByteOrderMark := f_DesEncoding.GetPreamble;

                f_FileStream.Size := 0;
                f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
            end;
        end;

        f_Line := '순번,신호종류,진입시간,청산시간,진입가격,청산가격,수익'+ #$D#$A;

        f_Buffer := f_DesEncoding.GetBytes(f_Line);
        f_FileStream.Seek(0, FILE_END);
        f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

        f_FileStream.Free;
        f_FileStream := NIL;

    end;
end;

//------------------------------------------------------------------------------------
procedure CFNCalcBackTesting.ReadDailyReport;
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
    f_DailyPMValueItem:CFNDailyPMValueItem;
    f_PMItem:CFNDailyPMValueItem;

    f_SumPMItem:CFNDailyPMValueItem;
    f_AvgPMItem:CFNDailyPMValueItem;

    f_TProfitSum : Double;
    f_BProfitSum : Double;
    f_SProfitSum : Double;

    f_Date:TDateTime;
    f_PointValue:Double;
begin
    f_PointValue := m_Block.Option.GetDoubleValue('POINT_VALUE');

    f_FileName := m_DailyPerfomanceFileName;

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

        m_DailyPMValueCollection.Clear;
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
                f_DailyPMValueItem := CFNDailyPMValueItem.Create;

                f_DailyPMValueItem.m_Date := f_Date;

                f_DailyPMValueItem.m_TProfit := TFNGlobal.atof(f_FieldList[1]) / f_PointValue;
                f_DailyPMValueItem.m_TProfitSum := TFNGlobal.atof(f_FieldList[2]) / f_PointValue;

                f_DailyPMValueItem.m_BProfit := TFNGlobal.atof(f_FieldList[3]) / f_PointValue;
                f_DailyPMValueItem.m_BProfitSum := TFNGlobal.atof(f_FieldList[4]) / f_PointValue;

                f_DailyPMValueItem.m_SProfit := TFNGlobal.atof(f_FieldList[5]) / f_PointValue;
                f_DailyPMValueItem.m_SProfitSum := TFNGlobal.atof(f_FieldList[6]) / f_PointValue;

                f_DailyPMValueItem.m_TNumberOfTrades := TFNGlobal.atof(f_FieldList[7]);
                f_DailyPMValueItem.m_BNumberOfTrades := TFNGlobal.atof(f_FieldList[8]);
                f_DailyPMValueItem.m_SNumberOfTrades := TFNGlobal.atof(f_FieldList[9]);

                f_DailyPMValueItem.m_Price := TFNGlobal.atof(f_FieldList[10]);

                m_DailyPMValueCollection.Add2(f_DailyPMValueItem);
            end;
        end;

    finally
        f_RecordList.Free;
        f_FieldList.Free;
    end;

    try
        f_TProfitSum := 0;
        f_BProfitSum := 0;
        f_SProfitSum := 0;


        f_SumPMItem := CFNDailyPMValueItem.Create;
        f_SumPMItem.m_Date := 1;

        f_SumPMItem.m_TProfit := 0;
        f_SumPMItem.m_TNumberOfTrades := 0;

        f_SumPMItem.m_BProfit := 0;
        f_SumPMItem.m_BNumberOfTrades := 0;

        f_SumPMItem.m_SProfit := 0;
        f_SumPMItem.m_SNumberOfTrades := 0;

        f_SumPMItem.m_Price := 0;

        for f_Index := 0 to m_DailyPMValueCollection.m_Items.Count - 1 do
        begin
            f_PMItem := m_DailyPMValueCollection.m_Items[f_Index];

            f_SumPMItem.m_TProfit := f_SumPMItem.m_TProfit + f_PMItem.m_TProfit;
            f_SumPMItem.m_BProfit := f_SumPMItem.m_BProfit + f_PMItem.m_BProfit;
            f_SumPMItem.m_SProfit := f_SumPMItem.m_SProfit + f_PMItem.m_SProfit;

            f_SumPMItem.m_TProfitSum := 0;
            f_SumPMItem.m_BProfitSum := 0;
            f_SumPMItem.m_SProfitSum := 0;

            f_SumPMItem.m_TNumberOfTrades := f_SumPMItem.m_TNumberOfTrades + f_PMItem.m_TNumberOfTrades;
            f_SumPMItem.m_BNumberOfTrades := f_SumPMItem.m_BNumberOfTrades + f_PMItem.m_BNumberOfTrades;
            f_SumPMItem.m_SNumberOfTrades := f_SumPMItem.m_SNumberOfTrades + f_PMItem.m_SNumberOfTrades;

            f_TProfitSum := f_TProfitSum + f_PMItem.m_TProfit;
            f_BProfitSum := f_BProfitSum + f_PMItem.m_BProfit;
            f_SProfitSum := f_SProfitSum + f_PMItem.m_SProfit;

            f_PMItem.m_TProfitSum := f_TProfitSum;
            f_PMItem.m_BProfitSum := f_BProfitSum;
            f_PMItem.m_SProfitSum := f_SProfitSum;
        end;

        f_AvgPMItem := CFNDailyPMValueItem.Create;
        f_AvgPMItem.m_Date := 2;

        if m_DailyPMValueCollection.m_Items.Count > 0 then
        begin
            f_AvgPMItem.m_TProfit := f_SumPMItem.m_TProfit / m_DailyPMValueCollection.m_Items.Count;
            f_AvgPMItem.m_BProfit := f_SumPMItem.m_BProfit / m_DailyPMValueCollection.m_Items.Count;
            f_AvgPMItem.m_SProfit := f_SumPMItem.m_SProfit / m_DailyPMValueCollection.m_Items.Count;

            f_AvgPMItem.m_TProfitSum := 0;
            f_AvgPMItem.m_BProfitSum := 0;
            f_AvgPMItem.m_SProfitSum := 0;

            f_AvgPMItem.m_TNumberOfTrades := f_SumPMItem.m_TNumberOfTrades / m_DailyPMValueCollection.m_Items.Count;
            f_AvgPMItem.m_BNumberOfTrades := f_SumPMItem.m_BNumberOfTrades / m_DailyPMValueCollection.m_Items.Count;
            f_AvgPMItem.m_SNumberOfTrades := f_SumPMItem.m_SNumberOfTrades / m_DailyPMValueCollection.m_Items.Count;

            f_AvgPMItem.m_Price := 0;
        end else
        begin
            f_AvgPMItem.m_TProfit := 0;
            f_AvgPMItem.m_BProfit := 0;
            f_AvgPMItem.m_SProfit := 0;

            f_AvgPMItem.m_TProfitSum := 0;
            f_AvgPMItem.m_BProfitSum := 0;
            f_AvgPMItem.m_SProfitSum := 0;

            f_AvgPMItem.m_TNumberOfTrades := 0;
            f_AvgPMItem.m_BNumberOfTrades := 0;
            f_AvgPMItem.m_SNumberOfTrades := 0;

            f_AvgPMItem.m_Price := 0;
        end;

        m_DailyPMValueCollection.Add(f_SumPMItem);
        m_DailyPMValueCollection.Add(f_AvgPMItem);

    finally

    end;
end;
//------------------------------------------------------------------------------------
procedure CFNCalcBackTesting.SaveDailyPerfomance;
var
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
    f_DailyPMValueItem:CFNDailyPMValueItem;
    f_PMItem:CFNDailyPMValueItem;

    f_SumPMItem:CFNDailyPMValueItem;
    f_AvgPMItem:CFNDailyPMValueItem;

    f_Index:Integer;

    f_TProfitSum : Double;
    f_BProfitSum : Double;
    f_SProfitSum : Double;

    f_PointValue:Double;
begin
    f_PointValue := m_Block.Option.GetDoubleValue('POINT_VALUE');

    try
        if m_DailyPMValueCollection.m_Items.Count > 0 then
        begin
            CFNDailyPMValueItem(m_DailyPMValueCollection.m_Items.Items[m_DailyPMValueCollection.m_Items.Count-1]).Free;
            m_DailyPMValueCollection.m_Items.Delete(m_DailyPMValueCollection.m_Items.Count-1);
        end;

        if m_DailyPMValueCollection.m_Items.Count > 0 then
        begin
            CFNDailyPMValueItem(m_DailyPMValueCollection.m_Items.Items[m_DailyPMValueCollection.m_Items.Count-1]).Free;
            m_DailyPMValueCollection.m_Items.Delete(m_DailyPMValueCollection.m_Items.Count-1);
        end;

        f_TrafficManager := CFNTrafficManager.Create;

        f_TrafficManager.MakeTradeListOfBacktesting(
            m_Block.Option,
            m_Block.SystemManager.m_SignalArray,
            m_Block.SystemManager.m_RealPrice
        );

        f_TrafficCollection := f_TrafficManager.m_AllTrafficCollection;

        f_DailyPMValueItem := CFNDailyPMValueItem.Create;
        f_DailyPMValueItem.m_Date := m_StandDate;

        f_DailyPMValueItem.m_TProfit := f_TrafficManager.m_AllTrafficCollection.m_NetProfit;
        f_DailyPMValueItem.m_TNumberOfTrades := f_TrafficManager.m_AllTrafficCollection.m_NumberOfTrades;

        f_DailyPMValueItem.m_BProfit := f_TrafficManager.m_LongTrafficCollection.m_NetProfit;
        f_DailyPMValueItem.m_BNumberOfTrades := f_TrafficManager.m_LongTrafficCollection.m_NumberOfTrades;

        f_DailyPMValueItem.m_SProfit := f_TrafficManager.m_ShortTrafficCollection.m_NetProfit;
        f_DailyPMValueItem.m_SNumberOfTrades := f_TrafficManager.m_ShortTrafficCollection.m_NumberOfTrades;

        f_DailyPMValueItem.m_Price := m_Block.SystemManager.m_RealPrice;

        m_DailyPMValueCollection.Add(f_DailyPMValueItem);

        f_TProfitSum := 0;
        f_BProfitSum := 0;
        f_SProfitSum := 0;


        f_SumPMItem := CFNDailyPMValueItem.Create;
        f_SumPMItem.m_Date := 1;

        f_SumPMItem.m_TProfit := 0;
        f_SumPMItem.m_TNumberOfTrades := 0;

        f_SumPMItem.m_BProfit := 0;
        f_SumPMItem.m_BNumberOfTrades := 0;

        f_SumPMItem.m_SProfit := 0;
        f_SumPMItem.m_SNumberOfTrades := 0;

        f_SumPMItem.m_Price := 0;

        for f_Index := 0 to m_DailyPMValueCollection.m_Items.Count - 1 do
        begin
            f_PMItem := m_DailyPMValueCollection.m_Items[f_Index];

            f_SumPMItem.m_TProfit := f_SumPMItem.m_TProfit + f_PMItem.m_TProfit;
            f_SumPMItem.m_BProfit := f_SumPMItem.m_BProfit + f_PMItem.m_BProfit;
            f_SumPMItem.m_SProfit := f_SumPMItem.m_SProfit + f_PMItem.m_SProfit;

            f_SumPMItem.m_TProfitSum := 0;
            f_SumPMItem.m_BProfitSum := 0;
            f_SumPMItem.m_SProfitSum := 0;

            f_SumPMItem.m_TNumberOfTrades := f_SumPMItem.m_TNumberOfTrades + f_PMItem.m_TNumberOfTrades;
            f_SumPMItem.m_BNumberOfTrades := f_SumPMItem.m_BNumberOfTrades + f_PMItem.m_BNumberOfTrades;
            f_SumPMItem.m_SNumberOfTrades := f_SumPMItem.m_SNumberOfTrades + f_PMItem.m_SNumberOfTrades;

            f_TProfitSum := f_TProfitSum + f_PMItem.m_TProfit;
            f_BProfitSum := f_BProfitSum + f_PMItem.m_BProfit;
            f_SProfitSum := f_SProfitSum + f_PMItem.m_SProfit;

            f_PMItem.m_TProfitSum := f_TProfitSum;
            f_PMItem.m_BProfitSum := f_BProfitSum;
            f_PMItem.m_SProfitSum := f_SProfitSum;
        end;

        f_AvgPMItem := CFNDailyPMValueItem.Create;
        f_AvgPMItem.m_Date := 2;

        if m_DailyPMValueCollection.m_Items.Count > 0 then
        begin
            f_AvgPMItem.m_TProfit := f_SumPMItem.m_TProfit / m_DailyPMValueCollection.m_Items.Count;
            f_AvgPMItem.m_BProfit := f_SumPMItem.m_BProfit / m_DailyPMValueCollection.m_Items.Count;
            f_AvgPMItem.m_SProfit := f_SumPMItem.m_SProfit / m_DailyPMValueCollection.m_Items.Count;

            f_AvgPMItem.m_TProfitSum := 0;
            f_AvgPMItem.m_BProfitSum := 0;
            f_AvgPMItem.m_SProfitSum := 0;

            f_AvgPMItem.m_TNumberOfTrades := f_SumPMItem.m_TNumberOfTrades / m_DailyPMValueCollection.m_Items.Count;
            f_AvgPMItem.m_BNumberOfTrades := f_SumPMItem.m_BNumberOfTrades / m_DailyPMValueCollection.m_Items.Count;
            f_AvgPMItem.m_SNumberOfTrades := f_SumPMItem.m_SNumberOfTrades / m_DailyPMValueCollection.m_Items.Count;

            f_AvgPMItem.m_Price := 0;
        end else
        begin
            f_AvgPMItem.m_TProfit := 0;
            f_AvgPMItem.m_BProfit := 0;
            f_AvgPMItem.m_SProfit := 0;

            f_AvgPMItem.m_TProfitSum := 0;
            f_AvgPMItem.m_BProfitSum := 0;
            f_AvgPMItem.m_SProfitSum := 0;

            f_AvgPMItem.m_TNumberOfTrades := 0;
            f_AvgPMItem.m_BNumberOfTrades := 0;
            f_AvgPMItem.m_SNumberOfTrades := 0;

            f_AvgPMItem.m_Price := 0;
        end;

        m_DailyPMValueCollection.Add(f_SumPMItem);
        m_DailyPMValueCollection.Add(f_AvgPMItem);

        if FileExists(m_DailyPerfomanceFileName) then
        begin
            f_Mode := fmOpenReadWrite or fmShareDenyWrite;
        end else
        begin
            f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
        end;

        f_FileStream  := TFileStream.Create(m_DailyPerfomanceFileName, f_Mode);
        if Assigned(f_FileStream) then
        begin
            f_DesEncoding   := TEncoding.UTF8;
            f_ByteOrderMark := f_DesEncoding.GetPreamble;
            if (f_FileStream.Size <= 0) then
            begin
                f_FileStream.Size := 0;
                f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
            end;

            f_Line :=
                DateToStr(f_DailyPMValueItem.m_Date) + ',' +
                Format('%.5f', [f_DailyPMValueItem.m_TProfit * f_PointValue]) + ',' +
                Format('%.5f', [f_DailyPMValueItem.m_TProfitSum * f_PointValue]) + ',' +
                Format('%.5f', [f_DailyPMValueItem.m_BProfit * f_PointValue]) + ',' +
                Format('%.5f', [f_DailyPMValueItem.m_BProfitSum * f_PointValue]) + ',' +
                Format('%.5f', [f_DailyPMValueItem.m_SProfit * f_PointValue]) + ',' +
                Format('%.5f', [f_DailyPMValueItem.m_SProfitSum * f_PointValue]) + ',' +
                Format('%.2f', [f_DailyPMValueItem.m_TNumberOfTrades]) + ',' +
                Format('%.2f', [f_DailyPMValueItem.m_BNumberOfTrades]) + ',' +
                Format('%.2f', [f_DailyPMValueItem.m_SNumberOfTrades]) + ',' +
                Format('%.6f', [f_DailyPMValueItem.m_Price]) + #$D#$A;

            f_Buffer := f_DesEncoding.GetBytes(f_Line);
            f_FileStream.Seek(0, FILE_END);
            f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

            f_FileStream.Free;
            f_FileStream := NIL;
        end;

    finally
        if Assigned(f_TrafficManager) then f_TrafficManager.Free;
    end;
end;

//------------------------------------------------------------------------------------
procedure CFNCalcBackTesting.SaveTradeList;
var
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
    try
        f_TrafficManager := CFNTrafficManager.Create;
        f_TrafficManager.MakeTradeListOfBacktesting(m_Block.Option, m_Block.SystemManager.m_SignalArray, m_Block.SystemManager.m_RealPrice);

        f_TrafficCollection := f_TrafficManager.m_AllTrafficCollection;

        if FileExists(m_TradeListFileName) then
        begin
            f_Mode := fmOpenReadWrite or fmShareDenyWrite;
        end else
        begin
            f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
        end;

        f_FileStream  := TFileStream.Create(m_TradeListFileName, f_Mode);
        if Assigned(f_FileStream) then
        begin
            f_DesEncoding   := TEncoding.UTF8;
            f_ByteOrderMark := f_DesEncoding.GetPreamble;
            if (f_FileStream.Size <= 0) then
            begin
                f_FileStream.Size := 0;
                f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
            end;

            for f_ItemIndex := 0 to f_TrafficCollection.m_Items.Count-1 do
            begin
                f_TrafficItem := f_TrafficCollection.m_Items[f_ItemIndex];
                if not f_TrafficItem.m_Enable then continue;
                f_Line :=
                    Format('%d', [f_ItemIndex]) + ',' +
                    GetSignalText(f_TrafficItem.m_Signal) + ',' +
                    TFNGlobal.DateTimeToStr4(f_TrafficItem.m_EnterDateTime) + ',' +
                    TFNGlobal.DateTimeToStr4(f_TrafficItem.m_ExitDateTime) + ',' +
                    Format('%.6f', [f_TrafficItem.m_EnterPrice]) + ',' +
                    Format('%.6f', [f_TrafficItem.m_ExitPrice]) + ',' +
                    Format('%.6f', [f_TrafficItem.m_Profit]) + #$D#$A;
                f_Buffer := f_DesEncoding.GetBytes(f_Line);
                f_FileStream.Seek(0, FILE_END);
                f_FileStream.Write(f_Buffer[0], Length(f_Buffer));
            end;

            f_FileStream.Free;
            f_FileStream := NIL;
        end;

    finally
        if Assigned(f_TrafficManager) then f_TrafficManager.Free;
    end;
end;


end.
