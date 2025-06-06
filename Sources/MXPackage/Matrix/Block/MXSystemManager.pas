unit MXSystemManager;

interface

uses
  Math,
  SysUtils,
  Classes,
  ExtCtrls,
  SyncObjs,
  FNPOTCollection,
  FNDataSet,
  FNDataDelivery,
  FNQuotData,
  FNThread,
  FNTradeSystem,
  FNTrafficManager,
  FNVolumePriceArray,
  FNMatrixLineValueSeries,
  MKChartData,
  MXOption,
  MKStreamChartDataSeries,
  MXOrderManager,
  MXTradeStrategyOptionCollection,
  MXTradeStrategy;

const
  TVIEWINTERVAL = 2000;

type
  CFNIntegerArray = Array of Integer;
  CMXSystemItem = class;
  TMXSystemItemEvent = Procedure(ASystemItem: CMXSystemItem) of Object;

  CMXSystemItem = class(TObject)
  public
    m_Country: Integer; // 국가번호
    m_Group: Integer; // 그룹번호
    m_Market: Integer; // 거래소번호
    m_Symbol: String; // 종목코드
    m_Name: String; // 종목명
    m_TradeSymbol: String;
    m_TimeFrame: Integer;

    m_ChartDataSeries: CMKStreamChartDataSeries;
    m_DayChartDataSeries: CMKStreamChartDataSeries;
    m_PriceSeries: CFNMatrixLineValueSeries;
    m_SignalLineSeries: CFNMatrixLineValueSeries;

  public
    m_OPSQuotData: CFNQuotData;
    m_TotalProfit: Double;
    m_LastSignal: Integer;

    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    procedure Lock;
    procedure Unlock;

  private
    // 옵션
    m_Option: CMXOption;

    m_TSOption: CMXTradeStrategyOption;

    // 화면단과 연결할 때, 사용될 변경사항 플래그
    m_Updated: Boolean;

    // 메니저에서 사용될 변경사항 플래그
    m_ChangedData: Boolean;

    m_ReceivedQuery: Boolean;

    m_TimerWorking: Boolean;

    m_ChangedEvent: TMXSystemItemEvent;

    m_BackTestingMode: Boolean;

    m_AlphaTime: TDateTime;
    m_OpenDateTime: TDateTime;

    m_USE_STAND_DATE: Boolean;

    m_TickStep: Double;

  protected
    m_Start: Boolean;
    m_DataDelivery: CFNDataDelivery;

    m_Timer: TTimer;
    m_DataLock: TCriticalSection;

    m_TradeStrategy: CMXTradeStrategy;

    procedure OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
    procedure OnStream(AStreamRecord: CFNStreamRecord);

    procedure RequestChart;

    procedure Request;
    procedure Subscribe;

    procedure OnTimer(Sender: TObject);
    procedure Calculate(AddCount: Integer);
    procedure CalculateSignal(ABegin, AEnd: Integer);
    procedure CreateTradeStrategy;

  public
    property Option: CMXOption read m_Option write m_Option;
    property TSOption: CMXTradeStrategyOption read m_TSOption write m_TSOption;
    property ChangedData: Boolean read m_ChangedData write m_ChangedData;
    property ReceivedQuery: Boolean read m_ReceivedQuery write m_ReceivedQuery;
    property BackTestingMode: Boolean read m_BackTestingMode write m_BackTestingMode;

  public
    property OnChanged: TMXSystemItemEvent read m_ChangedEvent write m_ChangedEvent;

  end;

  CMXSystemManager = class;

  // ------------------------------------------------------------------------------------
  CMXSystemManagerThread = class(CFNThread)
  public
    m_Manager: CMXSystemManager;

  protected
    procedure DoWork; override;
    procedure SetManager(AManager: CMXSystemManager);

  end;

  TMXSystemManagerChangeEvent = Procedure(Sender: TObject) of Object;

  // ------------------------------------------------------------------------------------
  CMXSystemManager = class(TObject)
  private
    m_Thread: CMXSystemManagerThread;
    m_Option: CMXOption;
    m_BlockName: String;
    m_BlockKey: String;
    m_OrderManager: CMXOrderManager;
    m_Timer: TTimer;
    m_StopTimer: TTimer;

    m_Start: Boolean;
    m_SelectedItem: Integer;
    m_ReceivedQuery: Boolean;
    m_TimerWorking: Boolean;
    m_Updated: Boolean;
    m_IsDoStop: Boolean;

    m_IsDoneWork: Boolean;

    m_DataLock: TCriticalSection;
    m_LogCollection: CFNLogCollection;

    m_ChangedEvent: TMXSystemManagerChangeEvent;
    m_LogEvent: TFNLogNotifyEvent;
    m_DoneWorkEvent: TNotifyEvent;

  private
    m_StartIndex: Integer;
    m_CheckTimeBarCount: Integer;

    m_BackTestingMode: Boolean;
    m_AloneMode: Boolean;
    m_SleepMode: Boolean;

    m_TimeOfStarting: TDateTime;

    m_MaxProfitLossStop: Boolean;
    m_MaxProfitLossStopValue: Double;

    m_IsStopForLosscut: Boolean;

  private
    procedure SetOption(AOPSOption: CMXOption);
    procedure OnTimer(Sender: TObject);
    procedure OnStopTimer(Sender: TObject);
    procedure MergeSystem1;
    procedure MergeSystem2;
    procedure Clear;

  private
    m_POTItem: CFNPOTItem;

  private
    m_ChangedMergeSeries1: Boolean;
    m_Merge1Lock: TCriticalSection;

    m_ChangedMergeSeries2: Boolean;
    m_Merge2Lock: TCriticalSection;

    m_ChangedMergeSeries1FromStart: Boolean;

  public
    procedure SetMerge1Changed(AValue: Boolean);
    function GetMerge1Changed: Boolean;
    function GetMerge1ChangedAndClear: Boolean;

    procedure SetMerge2Changed(AValue: Boolean);
    function GetMerge2Changed: Boolean;
    function GetMerge2ChangedAndClear: Boolean;

    procedure SetMerge1ChangedFromStart(AValue: Boolean);
    function GetMerge1ChangedFromStart: Boolean;

    procedure DoLosscut;

  public
    m_Items: TList;
    m_ChartDataSeries: CMKStreamChartDataSeries;
    m_MergeSeries1: CFNMatrixLineValueSeries;
    m_MergeSeries2: CFNMatrixLineValueSeries;
    m_LastCalcIndex: Integer;

    m_SignalArray: CFNSignalArray;
    m_TotalProfit: Double;
    m_LastSignal: Integer;
    m_RealPrice: Double;

    constructor Create;
    destructor Destroy; override;
    procedure ApplyTSOCollection(ASOC: CMXTradeStrategyOptionCollection);

    procedure DoWork;
    procedure BackTestingDoWork;
    procedure NormalDoWork;

    procedure Start;
    procedure Stop;
    procedure StopDelay;

    procedure Lock;
    procedure Unlock;

    procedure WriteToXML(AStream: TStringStream);

    property Option: CMXOption read m_Option write SetOption;
    property BlockName: String read m_BlockName write m_BlockName;
    property BlockKey: String read m_BlockKey write m_BlockKey;
    property SelectedItem: Integer read m_SelectedItem;
    property State: Boolean read m_Start;
    property OrderManager: CMXOrderManager read m_OrderManager write m_OrderManager;
    property BackTestingMode: Boolean read m_BackTestingMode write m_BackTestingMode;
    property AloneMode: Boolean read m_AloneMode write m_AloneMode;
    property SleepMode: Boolean read m_SleepMode write m_SleepMode;

    procedure LockItem;
    procedure UnLockItem;

  private
    m_DoExitSignal: Boolean;

  public
    procedure ExitCurrentSignal;

  public
    property OnChanged: TMXSystemManagerChangeEvent read m_ChangedEvent write m_ChangedEvent;
    property OnDoneWork: TNotifyEvent read m_DoneWorkEvent write m_DoneWorkEvent;
    property OnLog: TFNLogNotifyEvent read m_LogEvent write m_LogEvent;
    property ExitSignal: Boolean read m_DoExitSignal;
    property IsLosscut: Boolean read m_IsStopForLosscut;

  end;

implementation

uses
  DateUtils, Dialogs,
  CommonTRMaker,
  FNSocketManager,
  FNGlobal,
  FNCMVariable,
  MXVariable,
  FNMatrixLineValueSeriesCreator,
  MKLineValue,
  FNMatrixConst,
  MKTradeSignalDefine,
  MXTradeStrategySTC_T1,
  MXTradeStrategySTC_T2,
  MXTradeStrategySTC_T3,
  MXTradeStrategySTC_N1,
  MXTradeStrategySTC_N2,
  MXTradeStrategyRSI_T1,
  MXTradeStrategyRSI_N1,
  MXTradeStrategyBB_T1,
  MXTradeStrategyDISPARITY_T1,
  MXTradeStrategyDISPARITY_N1,
  MXTradeStrategyBASELINE_T1,
  MXTradeStrategyBASELINE_T2,
  MXTradeStrategyBASELINE_N1,
  MXTradeStrategyIM_T1,
  MXTradeStrategyIM_T2,
  MXTradeStrategyIM_T3,
  MXTradeStrategyMOV_T1,
  MXTradeStrategyMOV_T2,
  MXTradeStrategyMOV_T3,
  MXTradeStrategyMOV_N1,
  MXTradeStrategyMOV_N2,
  MXTradeStrategyREL_T1,
  MKTradeStrategyConst;

{$REGION 'CMXSystemItem'}

{$REGION '생성 및 파괴'}
// ------------------------------------------------------------------------------------
constructor CMXSystemItem.Create;
begin
  m_BackTestingMode := false;
  m_ChangedData := false;
  m_TimerWorking := false;
  m_Updated := false;
  m_Start := false;
  m_TotalProfit := 0;
  m_LastSignal := 0;

  m_DataLock := TCriticalSection.Create;
  m_ChartDataSeries := CMKStreamChartDataSeries.Create();
  m_DayChartDataSeries := CMKStreamChartDataSeries.Create();
  m_PriceSeries := Creator_Price;
  m_SignalLineSeries := Creator_SignalLineSeries;

  m_TradeStrategy := CMXTradeStrategy.Create;

  m_DataDelivery := CFNDataDelivery.Create;
  m_DataDelivery.OnStreamEvent := OnStream; // 스트리밍 수신 이벤트 등록
  m_DataDelivery.OnReplyEvent := OnReply; // 조회성 데이터 수신 이벤트 등록

  m_OPSQuotData := CFNQuotData.Create;

  m_Timer := TTimer.Create(NIL);
  m_Timer.Enabled := false;
  m_Timer.OnTimer := OnTimer;
  m_Timer.Interval := TVIEWINTERVAL;

  m_AlphaTime := 0;
  m_OpenDateTime := 0;

  m_USE_STAND_DATE := false;
end;

// ------------------------------------------------------------------------------------
destructor CMXSystemItem.Destroy;
var
  f_Loop: Integer;
begin
  if Assigned(g_SocketManager) then
    g_SocketManager.UnSubscribeAll(m_DataDelivery);

  f_Loop := 0;
  while True do
  begin
    if f_Loop > 30 then
      break;
    if not m_TimerWorking then
      break;
    Sleep(10);
    Inc(f_Loop);
  end;

  if Assigned(m_Timer) then
  begin
    m_Timer.Enabled := false;
    m_Timer.Free;
    m_Timer := NIL;
  end;

  if Assigned(m_DataDelivery) then
  begin
    m_DataDelivery.Free;
    m_DataDelivery := NIL;
  end;

  if Assigned(m_DataLock) then
  begin
    m_DataLock.Free;
    m_DataLock := NIL;
  end;

  if Assigned(m_ChartDataSeries) then
  begin
    m_ChartDataSeries.Free;
    m_ChartDataSeries := NIL;
  end;

  if Assigned(m_DayChartDataSeries) then
  begin
    m_DayChartDataSeries.Free;
    m_DayChartDataSeries := NIL;
  end;

  if Assigned(m_PriceSeries) then
  begin
    m_PriceSeries.Free;
    m_PriceSeries := NIL;
  end;

  if Assigned(m_SignalLineSeries) then
  begin
    m_SignalLineSeries.Free;
    m_SignalLineSeries := NIL;
  end;

  if Assigned(m_OPSQuotData) then
  begin
    m_OPSQuotData.Free;
    m_OPSQuotData := NIL;
  end;

  if Assigned(m_TradeStrategy) then
  begin
    m_TradeStrategy.Free;
    m_TradeStrategy := NIL;
  end;

  inherited;
end;

{$ENDREGION}

{$REGION '데이터 트랜젝션'}
// ------------------------------------------------------------------------------------
procedure CMXSystemItem.Lock;
begin
  m_DataLock.Enter;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemItem.Unlock;
begin
  m_DataLock.Leave;
end;

{$ENDREGION}

{$REGION '내부 변경을 외부에 이벤트를 통해서 전달'}
// ------------------------------------------------------------------------------------
procedure CMXSystemItem.OnTimer(Sender: TObject);
begin
  m_Timer.Enabled := false;
  m_TimerWorking := True;
  try
    if m_Updated then
    begin
      if Assigned(m_ChangedEvent) then
      begin
        m_ChangedEvent(Self);
      end;
      m_Updated := false;
    end;
  finally

  end;
  m_TimerWorking := false;
  m_Timer.Enabled := m_Start;
end;

{$ENDREGION}

{$REGION '데이터 요청 및 수신'}
// ------------------------------------------------------------------------------------
procedure CMXSystemItem.OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
var
  f_DataSet: CFNDataSet;
  f_Record: CFNRecord;

  f_RecordIndex: Integer;
  f_RecordCount: Integer;
  f_FieldIndex: Integer;
  f_Index: Integer;
  IsInvalidData: Boolean;

  f_Success: Boolean;
  f_RecordList: TStringList;
  f_FieldList: TStringList;
  f_ChartData: CMKChartData;

  Year: Word;
  Month: Word;
  Day: Word;
  Hour: Word;
  Min: Word;
  Sec: Word;
  MilSec: Word;
  f_Factor: Double;
  f_Date: Double;
  f_StandDate: Integer;

  LInsertCount, LInsertMin: Integer;
begin
  if (ADataPackage.GetServiceID = 'SC_ADV_CHART') then
  begin
    if (ADataPackage.GetTRCode = 'TR_0120') then
    begin
      Lock;
      try
        if m_Start then
        begin
          if (ADataPackage.GetMsgCode <> 'M00000') then
          begin
            LOG_WRITE(LOG_TYPE_ERROR, 'CMXSystemItem', '차트데이터조회에서 오류가 발생하여, 3초후에 재시도 합니다.');
            Sleep(3000);
            RequestChart;
          end
          else
          begin
            m_ChartDataSeries.Clear;
            m_DayChartDataSeries.Clear;

{$REGION '...'}
            f_DataSet := ADataPackage.GetDataSet(DATASETID_OUT_01);
            if Assigned(f_DataSet) then
            begin
              if 0 < f_DataSet.RecordList.Count then
              begin
                f_Record := CFNRecord(f_DataSet.RecordList.Items[0]);
                if (m_Country = f_Record.GetIntegerValue('COUNTRY_NO')) and (m_Group = f_Record.GetIntegerValue('GROUP_NO')) and (m_Market = f_Record.GetIntegerValue('MARKET_NO')) and
                  (m_Symbol = f_Record.GetStringValue('SYMBOL')) then
                begin
                  m_ChartDataSeries.m_Country := m_Country;
                  m_ChartDataSeries.m_Group := m_Group;
                  m_ChartDataSeries.m_Market := m_Market;
                  m_ChartDataSeries.m_Symbol := m_Symbol;
                  m_ChartDataSeries.m_Name := m_Name;
                  m_ChartDataSeries.m_TimeFrame := m_TimeFrame;
                  m_ChartDataSeries.m_Precision := f_Record.GetNameToIntegerValue('PRECISION');

                  m_DayChartDataSeries.m_Country := m_Country;
                  m_DayChartDataSeries.m_Group := m_Group;
                  m_DayChartDataSeries.m_Market := m_Market;
                  m_DayChartDataSeries.m_Symbol := m_Symbol;
                  m_DayChartDataSeries.m_Name := m_Name;
                  m_DayChartDataSeries.m_TimeFrame := 360;
                  m_DayChartDataSeries.m_Precision := f_Record.GetNameToIntegerValue('PRECISION');

                  f_Success := True;
                end
                else
                begin
                  f_Success := false;
                end;
              end
              else
              begin
                f_Success := false;
              end;
            end
            else
            begin
              f_Success := false;
            end;
{$ENDREGION}
            if f_Success then
            begin
              f_RecordList := TStringList.Create();
              f_FieldList := TStringList.Create();

{$REGION '...'}
              try
                f_DataSet := ADataPackage.GetDataSet(DATASETID_OUT_02);
                if Assigned(f_DataSet) then
                begin

                  f_RecordCount := f_DataSet.RecordList.Count;

                  for f_Index := 0 to f_RecordCount - 1 do
                  begin
                    f_Record := CFNRecord(f_DataSet.RecordList.Items[f_Index]);

                    f_RecordList.Clear();
                    ExtractStrings(['|'], [], PChar(f_Record.GetNameToStringValue('ITEMS')), f_RecordList);

                    for f_RecordIndex := 0 to f_RecordList.Count - 1 do
                    begin

                      f_FieldList.Clear;
                      ExtractStrings([','], [], PChar(f_RecordList[f_RecordIndex]), f_FieldList);

                      IsInvalidData := false;
                      for f_FieldIndex := 0 to f_FieldList.Count - 1 do
                      begin
                        if Length(f_FieldList[f_FieldIndex]) > 20 then
                        begin
                          IsInvalidData := True;
                          break;
                        end;
                      end;

                      if IsInvalidData then
                        continue;
                      if f_FieldList.Count < 11 then
                        continue;

                      if CompareText(f_FieldList[0], '20000101000000') < 0 then
                      begin
                        continue;
                      end;
                      if CompareText(f_FieldList[1], '20000101000000') < 0 then
                      begin
                        continue;
                      end;

                      try
                        f_ChartData := CMKChartData.Create();

                        f_ChartData.m_OpenDateTime := TFNGlobal.StringToDateTime(f_FieldList[0]);
                        f_ChartData.m_CloseDateTime := TFNGlobal.StringToDateTime(f_FieldList[1]);
                        DecodeDateTime(f_ChartData.m_CloseDateTime, Year, Month, Day, Hour, Min, Sec, MilSec);

                        f_ChartData.m_Year := Year;
                        f_ChartData.m_Month := Month;
                        f_ChartData.m_Day := Day;
                        f_ChartData.m_Hour := Hour;
                        f_ChartData.m_Min := Min;
                        f_ChartData.m_Sec := Sec;

                        f_ChartData.m_OpenPrice := TFNGlobal.atof(f_FieldList[2]);
                        f_ChartData.m_HighPrice := TFNGlobal.atof(f_FieldList[3]);
                        f_ChartData.m_LowPrice := TFNGlobal.atof(f_FieldList[4]);
                        f_ChartData.m_ClosePrice := TFNGlobal.atof(f_FieldList[5]);

                        f_ChartData.m_OpenPrice := Round(f_ChartData.m_OpenPrice / m_TickStep) * m_TickStep;
                        f_ChartData.m_HighPrice := Round(f_ChartData.m_HighPrice / m_TickStep) * m_TickStep;
                        f_ChartData.m_LowPrice := Round(f_ChartData.m_LowPrice / m_TickStep) * m_TickStep;
                        f_ChartData.m_ClosePrice := Round(f_ChartData.m_ClosePrice / m_TickStep) * m_TickStep;

                        f_ChartData.m_OpenOPS := TFNGlobal.atof(f_FieldList[6]);
                        f_ChartData.m_HighOPS := TFNGlobal.atof(f_FieldList[7]);
                        f_ChartData.m_LowOPS := TFNGlobal.atof(f_FieldList[8]);
                        f_ChartData.m_CloseOPS := TFNGlobal.atof(f_FieldList[9]);

                        f_ChartData.m_Volume := TFNGlobal.atof(f_FieldList[10]);

                        if (f_ChartData.m_OpenOPS = 0) then
                          f_ChartData.m_OpenOPS := f_ChartData.m_CloseOPS;
                        if (f_ChartData.m_HighOPS = 0) then
                          f_ChartData.m_HighOPS := f_ChartData.m_CloseOPS;
                        if (f_ChartData.m_LowOPS = 0) then
                          f_ChartData.m_LowOPS := f_ChartData.m_CloseOPS;

                        if (f_ChartData.m_OpenPrice = 0) then
                          f_ChartData.m_OpenPrice := f_ChartData.m_ClosePrice;
                        if (f_ChartData.m_HighPrice = 0) then
                          f_ChartData.m_HighPrice := f_ChartData.m_ClosePrice;
                        if (f_ChartData.m_LowPrice = 0) then
                          f_ChartData.m_LowPrice := f_ChartData.m_ClosePrice;

                        m_ChartDataSeries.Add(f_ChartData);
                      finally
                      end;
                    end;
                  end;
                end;
              finally
              end;
{$ENDREGION}
{$REGION '...'}
              try
                f_DataSet := ADataPackage.GetDataSet(DATASETID_OUT_03);
                if Assigned(f_DataSet) then
                begin
                  f_RecordCount := f_DataSet.RecordList.Count;

                  for f_Index := 0 to f_RecordCount - 1 do
                  begin
                    f_Record := CFNRecord(f_DataSet.RecordList.Items[f_Index]);

                    f_RecordList.Clear();
                    ExtractStrings(['|'], [], PChar(f_Record.GetNameToStringValue('ITEMS')), f_RecordList);

                    for f_RecordIndex := 0 to f_RecordList.Count - 1 do
                    begin
                      f_FieldList.Clear;
                      ExtractStrings([','], [], PChar(f_RecordList[f_RecordIndex]), f_FieldList);

                      IsInvalidData := false;
                      for f_FieldIndex := 0 to f_FieldList.Count - 1 do
                      begin
                        if Length(f_FieldList[f_FieldIndex]) > 20 then
                        begin
                          IsInvalidData := True;
                          break;
                        end;
                      end;

                      if IsInvalidData then
                        continue;

                      f_ChartData := CMKChartData.Create();

                      f_ChartData.m_OpenDateTime := TFNGlobal.StringToDateTime(f_FieldList[0]);
                      f_ChartData.m_CloseDateTime := TFNGlobal.StringToDateTime(f_FieldList[1]);
                      DecodeDateTime(f_ChartData.m_CloseDateTime, Year, Month, Day, Hour, Min, Sec, MilSec);

                      f_ChartData.m_Year := Year;
                      f_ChartData.m_Month := Month;
                      f_ChartData.m_Day := Day;
                      f_ChartData.m_Hour := Hour;
                      f_ChartData.m_Min := Min;
                      f_ChartData.m_Sec := Sec;

                      f_ChartData.m_OpenPrice := TFNGlobal.atof(f_FieldList[2]);
                      f_ChartData.m_HighPrice := TFNGlobal.atof(f_FieldList[3]);
                      f_ChartData.m_LowPrice := TFNGlobal.atof(f_FieldList[4]);
                      f_ChartData.m_ClosePrice := TFNGlobal.atof(f_FieldList[5]);

                      f_ChartData.m_OpenPrice := Round(f_ChartData.m_OpenPrice / m_TickStep) * m_TickStep;
                      f_ChartData.m_HighPrice := Round(f_ChartData.m_HighPrice / m_TickStep) * m_TickStep;
                      f_ChartData.m_LowPrice := Round(f_ChartData.m_LowPrice / m_TickStep) * m_TickStep;
                      f_ChartData.m_ClosePrice := Round(f_ChartData.m_ClosePrice / m_TickStep) * m_TickStep;

                      f_ChartData.m_OpenOPS := TFNGlobal.atof(f_FieldList[6]);
                      f_ChartData.m_HighOPS := TFNGlobal.atof(f_FieldList[7]);
                      f_ChartData.m_LowOPS := TFNGlobal.atof(f_FieldList[8]);
                      f_ChartData.m_CloseOPS := TFNGlobal.atof(f_FieldList[9]);

                      f_ChartData.m_Volume := TFNGlobal.atof(f_FieldList[10]);

                      if (f_ChartData.m_OpenOPS = 0) then
                        f_ChartData.m_OpenOPS := f_ChartData.m_CloseOPS;
                      if (f_ChartData.m_HighOPS = 0) then
                        f_ChartData.m_HighOPS := f_ChartData.m_CloseOPS;
                      if (f_ChartData.m_LowOPS = 0) then
                        f_ChartData.m_LowOPS := f_ChartData.m_CloseOPS;

                      if (f_ChartData.m_OpenPrice = 0) then
                        f_ChartData.m_OpenPrice := f_ChartData.m_ClosePrice;
                      if (f_ChartData.m_HighPrice = 0) then
                        f_ChartData.m_HighPrice := f_ChartData.m_ClosePrice;
                      if (f_ChartData.m_LowPrice = 0) then
                        f_ChartData.m_LowPrice := f_ChartData.m_ClosePrice;

                      m_DayChartDataSeries.Add(f_ChartData);
                    end;
                  end;
                end;
              finally
              end;
{$ENDREGION}
            end;
            f_RecordList.Free;
            f_FieldList.Free;

            m_ChartDataSeries.RemoveVirtualData;

            if Assigned(m_TradeStrategy) then
            begin
              if m_TradeStrategy.GetBooleanOptionValue('USER_GAB_PROCESS') then
              begin
                LInsertMin := m_TradeStrategy.GetIntegerOptionValue('GAB_INSERT_MIN');

                if (9000 < m_TimeFrame) then
                begin
                  LInsertCount := Trunc((60 / (m_TimeFrame - 9000)) * LInsertMin);
                  m_ChartDataSeries.AddVirtualDataAtOpening(LInsertCount);
                end
                else if (360 > m_TimeFrame) then
                begin
                  LInsertCount := (LInsertMin) div m_TimeFrame;
                  m_ChartDataSeries.AddVirtualDataAtOpening(LInsertCount);
                end;
              end;
            end;

            m_ChartDataSeries.AdjustData;
            m_DayChartDataSeries.AdjustData;

            m_ChartDataSeries.ReadyStream;
            m_DayChartDataSeries.ReadyStream;

            Calculate(-1);
            m_Updated := True;
            m_ReceivedQuery := True;

            LOG_WRITE(LOG_TYPE_INFO, 'CMXSystemItem', '차트데이터 수신완료(' + m_Symbol + ')');
          end;
        end
        else
        begin

        end;
      finally
        Unlock;
      end;
    end;
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemItem.OnStream(AStreamRecord: CFNStreamRecord);
var
  f_AddCount: Integer;
  f_Factor: Double;
  f_Hour, f_Min, f_Sec, f_MSec: Word;
  f_Time: TDateTime;
  f_DValue: Double;
begin
  if (m_Country = AStreamRecord.GetIntegerValue('COUNTRY_NO')) and (m_Group = AStreamRecord.GetIntegerValue('GROUP_NO')) and (m_Market = AStreamRecord.GetIntegerValue('MARKET_NO')) and
    (m_Symbol = AStreamRecord.GetStringValue('SYMBOL')) then
  begin
    Lock;
    try
      if not m_USE_STAND_DATE then
      begin
        f_DValue := AStreamRecord.GetNameToDoubleValue('OPEN_PRICE');
        f_DValue := Round(f_DValue / m_TickStep) * m_TickStep;
        AStreamRecord.SetDoubleValue('OPEN_PRICE', f_DValue);

        f_DValue := AStreamRecord.GetNameToDoubleValue('HIGH_PRICE');
        f_DValue := Round(f_DValue / m_TickStep) * m_TickStep;
        AStreamRecord.SetDoubleValue('HIGH_PRICE', f_DValue);

        f_DValue := AStreamRecord.GetNameToDoubleValue('LOW_PRICE');
        f_DValue := Round(f_DValue / m_TickStep) * m_TickStep;
        AStreamRecord.SetDoubleValue('LOW_PRICE', f_DValue);

        f_DValue := AStreamRecord.GetNameToDoubleValue('CLOSE_PRICE');
        f_DValue := Round(f_DValue / m_TickStep) * m_TickStep;
        AStreamRecord.SetDoubleValue('CLOSE_PRICE', f_DValue);

        f_DValue := AStreamRecord.GetNameToDoubleValue('BEST_OFFER_PRICE');
        f_DValue := Round(f_DValue / m_TickStep) * m_TickStep;
        AStreamRecord.SetDoubleValue('BEST_OFFER_PRICE', f_DValue);

        f_DValue := AStreamRecord.GetNameToDoubleValue('BEST_BID_PRICE');
        f_DValue := Round(f_DValue / m_TickStep) * m_TickStep;
        AStreamRecord.SetDoubleValue('BEST_BID_PRICE', f_DValue);

        m_OPSQuotData.OPSStreamDataToData(AStreamRecord);

        DecodeTime(m_OPSQuotData.m_DateTime, f_Hour, f_Min, f_Sec, f_MSec);
        f_Time := EncodeTime(f_Hour, f_Min, f_Sec, 0);
        if (f_Time >= m_AlphaTime) then
        begin
          f_AddCount := m_ChartDataSeries.UpdateStreamQuotData(AStreamRecord);
          m_DayChartDataSeries.UpdateStreamQuotData(AStreamRecord);

          Calculate(f_AddCount);

          m_Updated := True;
          m_ChangedData := True;
        end;
      end;
    finally
      Unlock;
    end;
  end;
  AStreamRecord.DecreaseReferenceCount;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemItem.Request;
begin
  RequestChart;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemItem.RequestChart;
var
  f_Record: CFNRecord;
  f_DataSet: CFNDataSet;
  f_DataPackage: CFNDataPackage;

  f_DataCount: Integer;
  f_SDate: String;
begin
  if 9000 <= m_TimeFrame then
  begin
    f_DataCount := 9000;
  end
  else if 1 >= m_TimeFrame then
  begin
    f_DataCount := 1600;
  end
  else if 2 >= m_TimeFrame then
  begin
    f_DataCount := 800;
  end
  else if 5 >= m_TimeFrame then
  begin
    f_DataCount := 600;
  end
  else if 10 >= m_TimeFrame then
  begin
    f_DataCount := 600;
  end
  else if 30 >= m_TimeFrame then
  begin
    f_DataCount := 600;
  end
  else if 60 >= m_TimeFrame then
  begin
    f_DataCount := 300;
  end
  else
  begin
    f_DataCount := 300;
  end;

  f_Record := CFNRecord.Create();
  f_Record.AddDoubleValue('COUNTRY_NO', m_Country);
  f_Record.AddDoubleValue('GROUP_NO', m_Group);
  f_Record.AddDoubleValue('MARKET_NO', m_Market);
  f_Record.AddStringValue('SYMBOL', m_Symbol);
  f_Record.AddIntegerValue('TIMEFRAME', m_TimeFrame);
  f_SDate := TFNGlobal.DateToString_YYYYMMDD(m_Option.GetIntegerValue('STAND_DATE'));
  f_Record.AddStringValue('STAND_DATE', f_SDate);

  f_Record.AddStringValue('RQ_TYPE', '0');
  f_Record.AddDoubleValue('COUNT', f_DataCount);
  f_Record.AddStringValue('START_DATETIME', '00000000000000');
  f_Record.AddStringValue('END_DATETIME', '00000000000000');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('COUNTRY_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('GROUP_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('MARKET_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('SYMBOL', 16, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('TIMEFRAME', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('STAND_DATE', 8, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('RQ_TYPE', 1, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('COUNT', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('START_DATETIME', 14, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('END_DATETIME', 14, COLTYPE_STRING);
  f_DataSet.RecordList.Add(f_Record);

  f_DataPackage := CFNDataPackage.Create;
  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_ADV_CHART');
  f_DataPackage.SetTRCode('TR_0120');

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  if Assigned(g_SocketManager) then
    g_SocketManager.Request(m_DataDelivery, f_DataPackage);

  f_DataPackage.Free;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemItem.Subscribe;
begin
  if Assigned(g_SocketManager) then
    g_SocketManager.SubscribeQuote(m_DataDelivery, m_Country, m_Group, m_Market, m_Symbol);
end;

{$ENDREGION}

{$REGION '시작 및 정지'}

{$REGION '매매전략 모듈적재'}
// ------------------------------------------------------------------------------------
procedure CMXSystemItem.CreateTradeStrategy;
begin
  if Assigned(m_TradeStrategy) then
  begin
    m_TradeStrategy.Free;
    m_TradeStrategy := NIL;
  end;

  if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'STC-T1' then
  begin
    m_TradeStrategy := CMXTradeStrategySTC_T1.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'STC-T2' then
  begin
    m_TradeStrategy := CMXTradeStrategySTC_T2.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'STC-T3' then
  begin
    m_TradeStrategy := CMXTradeStrategySTC_T3.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'STC-N1' then
  begin
    m_TradeStrategy := CMXTradeStrategySTC_N1.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'STC-N2' then
  begin
    m_TradeStrategy := CMXTradeStrategySTC_N2.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'RSI-T1' then
  begin
    m_TradeStrategy := CMXTradeStrategyRSI_T1.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'RSI-N1' then
  begin
    m_TradeStrategy := CMXTradeStrategyRSI_N1.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'BB-T1' then
  begin
    m_TradeStrategy := CMXTradeStrategyBB_T1.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'DISPARITY-T1' then
  begin
    m_TradeStrategy := CMXTradeStrategyDISPARITY_T1.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'DISPARITY-N1' then
  begin
    m_TradeStrategy := CMXTradeStrategyDISPARITY_N1.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'BASELINE-T1' then
  begin
    m_TradeStrategy := CMXTradeStrategyBASELINE_T1.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'BASELINE-T2' then
  begin
    m_TradeStrategy := CMXTradeStrategyBASELINE_T2.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'BASELINE-N1' then
  begin
    m_TradeStrategy := CMXTradeStrategyBASELINE_N1.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'IM-T1' then
  begin
    m_TradeStrategy := CMXTradeStrategyIM_T1.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'IM-T2' then
  begin
    m_TradeStrategy := CMXTradeStrategyIM_T2.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'IM-T3' then
  begin
    m_TradeStrategy := CMXTradeStrategyIM_T3.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'MOV-T1' then
  begin
    m_TradeStrategy := CMXTradeStrategyMOV_T1.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'MOV-T2' then
  begin
    m_TradeStrategy := CMXTradeStrategyMOV_T2.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'MOV-T3' then
  begin
    m_TradeStrategy := CMXTradeStrategyMOV_T3.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'MOV-N1' then
  begin
    m_TradeStrategy := CMXTradeStrategyMOV_N1.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'MOV-N2' then
  begin
    m_TradeStrategy := CMXTradeStrategyMOV_N2.Create;
  end
  else if m_TSOption.GetStringValue(TSOPTION_KEY_CATEGORY) = 'REL-T1' then
  begin
    m_TradeStrategy := CMXTradeStrategyREL_T1.Create;
  end
  else
  begin
    m_TradeStrategy := NIL;
  end;

  if Assigned(m_TradeStrategy) then
  begin
    m_TradeStrategy.Option := m_TSOption;
    m_TradeStrategy.SetChartDataSeries(m_ChartDataSeries, m_DayChartDataSeries);
  end;
end;

{$ENDREGION}

// ------------------------------------------------------------------------------------
procedure CMXSystemItem.Start;
var
  f_Loop: Integer;
  f_POTItem: CFNPOTItem;
  f_DType: Integer;
begin
  if m_Start then
    exit;

  Lock;
  try
    m_Updated := false;
    m_ReceivedQuery := false;

    m_TickStep := m_Option.GetDoubleValue('TICK_STEP');
    m_USE_STAND_DATE := m_Option.GetBooleanValue('USE_STAND_DATE');

    f_Loop := 0;
    while True do
    begin
      if f_Loop > 30 then
        break;
      if not m_TimerWorking then
        break;
      Sleep(10);
      Inc(f_Loop);
    end;

    m_ChartDataSeries.Clear;
    m_ChartDataSeries.m_Country := m_Country;
    m_ChartDataSeries.m_Group := m_Group;
    m_ChartDataSeries.m_Market := m_Market;
    m_ChartDataSeries.m_Symbol := m_Symbol;
    m_ChartDataSeries.m_TimeFrame := m_TimeFrame;

    m_DayChartDataSeries.Clear;


    m_PriceSeries.Clear;
    m_SignalLineSeries.Clear;

    m_ChangedData := false;

    m_TimerWorking := false;
    m_Updated := false;
    m_TotalProfit := 0;
    m_LastSignal := 0;
    m_ReceivedQuery := false;

    m_OpenDateTime := g_DefaultOpenTime;
    if Assigned(g_POTCollection) then
    begin
      f_POTItem := g_POTCollection.Find(m_Option.GetVirtualExchangeDateTime, m_Country, m_Group, m_Market, m_Symbol);
      if Assigned(f_POTItem) then
      begin
        m_ChartDataSeries.SetPOTItem(f_POTItem);

        m_OpenDateTime := EncodeTime(f_POTItem.NumberToHour(f_POTItem.m_Open[0]), f_POTItem.NumberToMin(f_POTItem.m_Open[0]), 0, 0);
      end;
    end;
    m_AlphaTime := m_OpenDateTime + EncodeTime(0, 0, 5, 0);

    CreateTradeStrategy;
    m_ChartDataSeries.ReadyStream;
    Request;
    m_Start := True;

    m_Timer.Enabled := True;

  finally
    Unlock;
  end;

end;

// ------------------------------------------------------------------------------------
procedure CMXSystemItem.Stop;
var
  f_Loop: Integer;
begin
  if not m_Start then
    exit;

  Lock;
  try
    m_Updated := false;
    m_Start := false;

    f_Loop := 0;
    while True do
    begin
      if f_Loop > 30 then
        break;
      if not m_TimerWorking then
        break;
      Sleep(10);
      Inc(f_Loop);
    end;

    if Assigned(g_SocketManager) then
      g_SocketManager.UnsubscribeQuote(m_DataDelivery, m_Country, m_Group, m_Market, m_Symbol);

    m_Start := false;
    m_Timer.Enabled := false;
    m_ChangedData := false;
    m_TimerWorking := false;
    m_Updated := false;
    m_ReceivedQuery := false;

    if Assigned(m_TradeStrategy) then
    begin
      m_TradeStrategy.Free;
      m_TradeStrategy := NIL;
    end;
  finally
    Unlock;
  end;
end;

{$ENDREGION}

{$REGION '신호계산'}
// ------------------------------------------------------------------------------------
procedure CMXSystemItem.Calculate(AddCount: Integer);
var
  f_Begin, f_End: Integer;
  f_LineValue0: CMKLineValue;
begin
  if not Assigned(m_TradeStrategy) then
    exit;
  if not Assigned(m_ChartDataSeries) then
    exit;
  if not Assigned(m_PriceSeries) then
    exit;
  if not Assigned(m_SignalLineSeries) then
    exit;

  if (AddCount < 0) then
  begin
    f_Begin := 0;
    f_End := m_ChartDataSeries.m_Items.Count;

    m_TradeStrategy.Calculate(True);
    m_PriceSeries.Indicator_OPSPrice(m_ChartDataSeries, f_Begin, f_End);

    CalculateSignal(f_Begin, f_End);
  end
  else
  begin
    f_Begin := m_PriceSeries.m_Items.Count - 1;
    f_End := m_ChartDataSeries.m_Items.Count;

    m_TradeStrategy.Calculate(false);
    m_PriceSeries.Indicator_OPSPrice(m_ChartDataSeries, f_Begin, f_End);

    CalculateSignal(f_Begin, f_End);
  end;

  if m_SignalLineSeries.m_Items.Count > 0 then
  begin
    f_LineValue0 := CMKLineValue(m_SignalLineSeries.m_Items.Items[m_SignalLineSeries.m_Items.Count - 1]);
    m_TotalProfit := f_LineValue0.m_Value[M_X_SIGNAL_TP];

    if (f_LineValue0.m_Value[M_X_SIGNAL] = NOT_VALUE) then
    begin
      m_LastSignal := 0;
    end
    else
    begin
      m_LastSignal := Trunc(f_LineValue0.m_Value[M_X_SIGNAL]);
    end;
  end
  else
  begin
    m_TotalProfit := 0;
    m_LastSignal := 0;
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemItem.CalculateSignal(ABegin, AEnd: Integer);
var
  f_Index: Integer;
  f_ValueIndex: Integer;
  f_TSLineValueSeries: CFNMatrixLineValueSeries;

  f_TSLineValue: CMKLineValue;
  f_SNLineValue: CMKLineValue;
  f_ChartData: CMKChartData;
  f_StartTime, f_StopTime, f_Time: TDateTime;
  f_Hour, f_Min, f_Sec, f_MSec: Word;
begin
  if not Assigned(m_TradeStrategy) then
    exit;
  if m_TradeStrategy.LineCollection.Count <= 0 then
    exit;

  m_SignalLineSeries.SetLengthSeries(m_PriceSeries.m_Items.Count);

  if (ABegin = -1) then
    ABegin := 0;
  if (AEnd = -1) then
    AEnd := m_ChartDataSeries.m_Items.Count;
  if (AEnd > m_ChartDataSeries.m_Items.Count) then
    AEnd := m_ChartDataSeries.m_Items.Count;

  if (ABegin > m_SignalLineSeries.m_Items.Count - 1) then
    ABegin := m_SignalLineSeries.m_Items.Count - 1;
  if (ABegin < 0) then
    ABegin := 0;

  f_TSLineValueSeries := m_TradeStrategy.LineCollection[m_TradeStrategy.LineCollection.Count - 1];

{$REGION '거래시간을 계산한다.'}
  if m_Option.GetBooleanValue('USE_REGULAR_MARKET') then
  begin
    f_StartTime := m_Option.GetIntegerValue('STAND_DATE') + Math.Max(m_Option.GetIntegerValue('START_TIME') / 86400000.0, m_Option.GetIntegerValue('REGULAR_START_TIME') / 86400000.0);
    f_StopTime := m_Option.GetIntegerValue('STAND_DATE') + Math.Min(m_Option.GetIntegerValue('STOP_TIME') / 86400000.0, m_Option.GetIntegerValue('REGULAR_STOP_TIME') / 86400000.0);
  end
  else
  begin
    f_StartTime := m_Option.GetIntegerValue('STAND_DATE') + m_Option.GetIntegerValue('START_TIME') / 86400000.0;
    f_StopTime := m_Option.GetIntegerValue('STAND_DATE') + m_Option.GetIntegerValue('STOP_TIME') / 86400000.0;
  end;

  DecodeTime(f_StartTime, f_Hour, f_Min, f_Sec, f_MSec);
  f_StartTime := EncodeTime(f_Hour, f_Min, 0, 0);

  DecodeTime(f_StopTime, f_Hour, f_Min, f_Sec, f_MSec);
  f_StopTime := EncodeTime(f_Hour, f_Min, 0, 0);
{$ENDREGION}
  for f_ValueIndex := ABegin to AEnd - 1 do
  begin
    f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
    f_TSLineValue := f_TSLineValueSeries.m_Items[f_ValueIndex];
    f_SNLineValue := m_SignalLineSeries.m_Items[f_ValueIndex];

    f_SNLineValue.m_Value[M_X_SIGNAL] := f_TSLineValue.m_Value[TS_SIGNAL_IDX_FINAL];
    f_SNLineValue.m_Value[M_X_REALPRICE] := f_ChartData.m_ClosePrice;
  end;

{$REGION '지정한 거래시간외의 시간대는 매매를 하지 않도록 한다.'}
  for f_ValueIndex := ABegin to AEnd - 1 do
  begin
    f_ChartData := m_ChartDataSeries.m_Items[f_ValueIndex];
    f_TSLineValue := f_TSLineValueSeries.m_Items[f_ValueIndex];
    f_SNLineValue := m_SignalLineSeries.m_Items[f_ValueIndex];

    DecodeTime(f_ChartData.m_CloseDateTime, f_Hour, f_Min, f_Sec, f_MSec);
    f_Time := EncodeTime(f_Hour, f_Min, 0, 0);

    if (f_StartTime <= f_Time) and (f_Time <= f_StopTime) then
    begin
      f_SNLineValue.m_Value[M_X_SIGNAL] := f_SNLineValue.m_Value[M_X_SIGNAL];
    end
    else
    begin
      f_SNLineValue.m_Value[M_X_SIGNAL] := 0;
    end;
  end;
{$ENDREGION}
  m_SignalLineSeries.Calc_TotalProfit(m_SignalLineSeries, M_X_SIGNAL, M_X_REALPRICE, M_X_SIGNAL_TP, ABegin, AEnd);
end;

{$ENDREGION}

// ------------------------------------------------------------------------------------
{$ENDREGION}

{$REGION 'CMXSystemManagerThread'}

// ------------------------------------------------------------------------------------
// 쓰레드가 루프를 돌면서 실행하는 메소소드
procedure CMXSystemManagerThread.DoWork;
begin
  if Assigned(m_Manager) then
  begin
    if m_Manager.State then
    begin
      m_Working := True;
      m_Manager.DoWork;
    end;
  end;

  m_Working := false;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManagerThread.SetManager(AManager: CMXSystemManager);
begin
  m_Manager := AManager;
end;
{$ENDREGION}

{$REGION 'CMXSystemManager'}

// ------------------------------------------------------------------------------------
constructor CMXSystemManager.Create;
begin
  m_DoExitSignal := false;

  m_MaxProfitLossStop := false;

  m_BackTestingMode := false;
  m_AloneMode := True;
  m_SleepMode := false;

  m_LogCollection := CFNLogCollection.Create;

  m_POTItem := CFNPOTItem.Create;

  m_ReceivedQuery := false;
  m_Updated := false;
  m_TimerWorking := false;
  m_Start := false;
  m_SelectedItem := -1;
  m_IsDoStop := false;

  m_Option := CMXOption.Create;

  m_Items := TList.Create;

  m_ChartDataSeries := CMKStreamChartDataSeries.Create;
  m_MergeSeries1 := FNMatrixLineValueSeriesCreator.Creator_MergeSeries;
  m_MergeSeries2 := CFNMatrixLineValueSeries.Create('Merge2', CFNMatrixConst.LINESERIES_WMA_TREND_SIGNAL, 1, 0, 0, 0);
  m_LastCalcIndex := 0;
  m_ChangedMergeSeries2 := false;
  m_SignalArray := CFNSignalArray.Create;

  m_DataLock := TCriticalSection.Create;
  m_Merge1Lock := TCriticalSection.Create;
  m_Merge2Lock := TCriticalSection.Create;

  m_Timer := TTimer.Create(NIL);
  m_Timer.Enabled := false;
  m_Timer.OnTimer := OnTimer;
  m_Timer.Interval := TVIEWINTERVAL;
  m_Timer.Enabled := True;

  m_StopTimer := TTimer.Create(NIL);
  m_StopTimer.Enabled := false;
  m_StopTimer.OnTimer := OnStopTimer;
  m_StopTimer.Interval := 3000;

  m_Thread := CMXSystemManagerThread.Create;
  m_Thread.SetSleepTime(100);
  m_Thread.SetManager(Self);
  m_Thread.Resume;
end;

// ------------------------------------------------------------------------------------
destructor CMXSystemManager.Destroy;
var
  nTry: Integer;
  f_Loop: Integer;
begin
  Stop;

  m_ChartDataSeries.Clear;
  m_MergeSeries1.Clear;
  m_SignalArray.Clear;

  while True do
  begin
    if f_Loop > 30 then
      break;
    if not m_TimerWorking then
      break;
    Sleep(10);
  end;

  if Assigned(m_Thread) then
  begin
    m_Thread.StopThread;
  end;

  nTry := 0;
  while Assigned(m_Thread) do
  begin
    if (not m_Thread.Finished) then
    begin
      m_Thread.StopThread;
      Inc(nTry);
      if (nTry > 50) then
      begin
        m_Thread.ExitThread;
        m_Thread.Free;
        m_Thread := NIL;
        break;
      end;
    end
    else
    begin
      m_Thread.Free;
      m_Thread := NIL;
      break;
    end;
    Sleep(100);
  end;

  if Assigned(m_Timer) then
  begin
    m_Timer.Enabled := false;
    m_Timer.Free;
    m_Timer := NIL;
  end;

  if Assigned(m_StopTimer) then
  begin
    m_StopTimer.Enabled := false;
    m_StopTimer.Free;
    m_StopTimer := NIL;
  end;

  Clear;

  if Assigned(m_Items) then
  begin
    m_Items.Free;
    m_Items := NIL;
  end;

  if Assigned(m_Option) then
  begin
    m_Option.Free;
    m_Option := NIL;
  end;

  if Assigned(m_ChartDataSeries) then
  begin
    m_ChartDataSeries.Free;
    m_ChartDataSeries := NIL;
  end;

  if Assigned(m_MergeSeries1) then
  begin
    m_MergeSeries1.Free;
    m_MergeSeries1 := NIL;
  end;

  if Assigned(m_MergeSeries2) then
  begin
    m_MergeSeries2.Free;
    m_MergeSeries2 := NIL;
  end;

  if Assigned(m_SignalArray) then
  begin
    m_SignalArray.Free;
    m_SignalArray := NIL;
  end;

  if Assigned(m_DataLock) then
  begin
    m_DataLock.Free;
    m_DataLock := NIL;
  end;

  if Assigned(m_Merge1Lock) then
  begin
    m_Merge1Lock.Free;
    m_Merge1Lock := NIL;
  end;

  if Assigned(m_Merge2Lock) then
  begin
    m_Merge2Lock.Free;
    m_Merge2Lock := NIL;
  end;

  if Assigned(m_LogCollection) then
  begin
    m_LogCollection.Free;
    m_LogCollection := NIL;
  end;

  inherited;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.SetMerge1Changed(AValue: Boolean);
begin
  m_Merge1Lock.Enter;
  try
    m_ChangedMergeSeries1 := AValue;
  finally
    m_Merge1Lock.Leave;
  end;
end;

// ------------------------------------------------------------------------------------
function CMXSystemManager.GetMerge1Changed: Boolean;
begin
  m_Merge1Lock.Enter;
  try
    Result := m_ChangedMergeSeries1;
  finally
    m_Merge1Lock.Leave;
  end;
end;

// ------------------------------------------------------------------------------------
function CMXSystemManager.GetMerge1ChangedAndClear: Boolean;
begin
  m_Merge1Lock.Enter;
  try
    Result := m_ChangedMergeSeries1;
    m_ChangedMergeSeries1 := false;
  finally
    m_Merge1Lock.Leave;
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.SetMerge1ChangedFromStart(AValue: Boolean);
begin
  m_Merge1Lock.Enter;
  try
    m_ChangedMergeSeries1FromStart := AValue;
  finally
    m_Merge1Lock.Leave;
  end;
end;

// ------------------------------------------------------------------------------------
function CMXSystemManager.GetMerge1ChangedFromStart: Boolean;
begin
  m_Merge1Lock.Enter;
  try
    Result := m_ChangedMergeSeries1FromStart;
  finally
    m_Merge1Lock.Leave;
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.SetMerge2Changed(AValue: Boolean);
begin
  m_Merge2Lock.Enter;
  try
    m_ChangedMergeSeries2 := AValue;
  finally
    m_Merge2Lock.Leave;
  end;
end;

// ------------------------------------------------------------------------------------
function CMXSystemManager.GetMerge2Changed: Boolean;
begin
  m_Merge2Lock.Enter;
  try
    Result := m_ChangedMergeSeries2;
  finally
    m_Merge2Lock.Leave;
  end;
end;

// ------------------------------------------------------------------------------------
function CMXSystemManager.GetMerge2ChangedAndClear: Boolean;
begin
  m_Merge2Lock.Enter;
  try
    Result := m_ChangedMergeSeries2;
    m_ChangedMergeSeries2 := false;
  finally
    m_Merge2Lock.Leave;
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.Lock;
begin
  m_DataLock.Enter;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.Unlock;
begin
  m_DataLock.Leave;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.WriteToXML(AStream: TStringStream);
begin
  AStream.WriteString('<SystemManager>' + #$0A);
  AStream.WriteString('<m_Start>' + TFNGlobal.BoolToString(m_Start) + '</m_Start>' + #$0A);
  AStream.WriteString('</SystemManager>' + #$0A);
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.Clear;
var
  f_SystemItem: CMXSystemItem;
begin
  Lock;
  try
    while 0 < m_Items.Count do
    begin
      f_SystemItem := CMXSystemItem(m_Items.Items[0]);
      if Assigned(f_SystemItem) then
      begin
        f_SystemItem.Free;
      end;
      m_Items.Delete(0);
    end;
  finally
    Unlock;
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.SetOption(AOPSOption: CMXOption);
begin
  Lock;
  try
    m_Option.Clone(AOPSOption);
  finally
    Unlock;
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.ApplyTSOCollection(ASOC: CMXTradeStrategyOptionCollection);
var
  f_Index: Integer;
  f_TSOption: CMXTradeStrategyOption;
  f_SystemItem: CMXSystemItem;
begin
  Clear;
  for f_Index := 0 to ASOC.m_Items.Count - 1 do
  begin
    f_TSOption := CMXTradeStrategyOption(ASOC.m_Items.Items[f_Index]);

    f_SystemItem := CMXSystemItem.Create;
    f_SystemItem.Option := m_Option;
    f_SystemItem.TSOption := f_TSOption;
    f_SystemItem.m_Country := m_Option.GetIntegerValue('COUNTRY_NO');
    f_SystemItem.m_Group := m_Option.GetIntegerValue('GROUP_NO');
    f_SystemItem.m_Market := m_Option.GetIntegerValue('MARKET_NO');
    f_SystemItem.m_Symbol := m_Option.GetStringValue('SYMBOL');
    f_SystemItem.m_Name := '';
    f_SystemItem.m_TradeSymbol := m_Option.GetStringValue('TRADESYMBOL');
    f_SystemItem.m_TimeFrame := m_Option.GetIntegerValue('TIMEFRAME');
    f_SystemItem.BackTestingMode := m_BackTestingMode;
    m_Items.Add(f_SystemItem);
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.ExitCurrentSignal;
begin
  if not m_Start then
    exit;

  m_DoExitSignal := True;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.Start;
var
  f_Index: Integer;
  f_SystemItem: CMXSystemItem;
  f_Loop: Integer;
  f_POTItem: CFNPOTItem;
  f_PointValue: Double;
begin
  if m_Start then
    exit;

  m_LogCollection.Write(LOG_TYPE_INFO, '신호생성을 시작합니다.', 'CMXSystemManager');
  Lock;
  try
    m_MaxProfitLossStop := false;

    if Assigned(g_POTCollection) then
    begin
      f_POTItem := g_POTCollection.Find(m_Option.GetVirtualExchangeDateTime, m_Option.GetIntegerValue('COUNTRY_NO'), m_Option.GetIntegerValue('GROUP_NO'), m_Option.GetIntegerValue('MARKET_NO'),
        m_Option.GetStringValue('SYMBOL'));

      if Assigned(f_POTItem) then
      begin
        m_POTItem.Clone(f_POTItem);
      end;
    end;

    f_PointValue := m_Option.GetDoubleValue('POINT_VALUE');
    m_Option.SetDoubleValue('RISK_MAX_LOSS_POINT', m_Option.GetDoubleValue('RISK_MAX_LOSS') / f_PointValue);
    m_Option.SetDoubleValue('RISK_MAX_PROFIT_POINT', m_Option.GetDoubleValue('RISK_MAX_PROFIT') / f_PointValue);

    m_TimeOfStarting := Now;
    m_DoExitSignal := false;
    m_IsDoStop := false;
    m_Updated := false;
    m_IsDoneWork := false;
    m_IsStopForLosscut := false;

    f_Loop := 0;
    while True do
    begin
      if f_Loop > 30 then
        break;
      if not m_TimerWorking then
        break;
      Sleep(10);
      Inc(f_Loop);
    end;

    m_TotalProfit := 0;
    m_LastSignal := 0;
    m_RealPrice := 0;

    m_ChartDataSeries.Clear;
    m_MergeSeries1.Clear;
    m_MergeSeries2.Clear;
    m_LastCalcIndex := 0;
    m_ChangedMergeSeries1FromStart := false;
    m_ChangedMergeSeries1 := false;
    m_ChangedMergeSeries2 := false;

    m_SignalArray.Clear;
    m_SelectedItem := -1;
    m_ReceivedQuery := false;

    for f_Index := 0 to m_Items.Count - 1 do
    begin
      f_SystemItem := CMXSystemItem(m_Items[f_Index]);
      f_SystemItem.Start;
    end;

    m_Start := True;
    m_Timer.Enabled := True;
  finally
    Unlock;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMXSystemManager.StopDelay;
begin
  m_IsDoStop := True;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.Stop;
var
  f_Index: Integer;
  f_SystemItem: CMXSystemItem;
  f_Loop: Integer;
begin
  if not m_Start then
    exit;

  m_LogCollection.Write(LOG_TYPE_INFO, '신호생성을 종료합니다.', 'CMXSystemManager');

  Lock;
  try
    m_DoExitSignal := false;
    m_Updated := false;
    m_IsDoneWork := false;
    m_Start := false;
    m_IsStopForLosscut := false;

    m_LogCollection.Write(LOG_TYPE_INFO, '타이머작업을 정지하는 동안 대기 합니다.', 'CMXSystemManager');

    f_Loop := 0;
    while True do
    begin
      if f_Loop > 30 then
        break;
      if not m_TimerWorking then
        break;
      Sleep(10);
      Inc(f_Loop);
    end;

    m_LogCollection.Write(LOG_TYPE_INFO, '신호생성을 위한 개별아이템을 정지합니다.', 'CMXSystemManager');

    for f_Index := 0 to m_Items.Count - 1 do
    begin
      f_SystemItem := CMXSystemItem(m_Items[f_Index]);
      f_SystemItem.Stop;
    end;

    m_Start := false;

    m_ChangedMergeSeries1 := false;
    m_ChangedMergeSeries2 := false;

    m_ReceivedQuery := false;
  finally
    Unlock;
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.LockItem;
var
  f_ItemIndex: Integer;
  f_SystemItem: CMXSystemItem;
begin
{$REGION '각 아이템의 락을 건다'}
  for f_ItemIndex := 0 to m_Items.Count - 1 do
  begin
    f_SystemItem := CMXSystemItem(m_Items[f_ItemIndex]);
    f_SystemItem.Lock;
  end;
{$ENDREGION}
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.UnLockItem;
var
  f_ItemIndex: Integer;
  f_SystemItem: CMXSystemItem;
begin
{$REGION '각 아이템의 락을 건다'}
  for f_ItemIndex := 0 to m_Items.Count - 1 do
  begin
    f_SystemItem := CMXSystemItem(m_Items[f_ItemIndex]);
    f_SystemItem.Unlock;
  end;
{$ENDREGION}
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.DoLosscut;
begin
  Lock;
  try
    if not m_IsStopForLosscut then
    begin
      m_IsStopForLosscut := True;
      m_LogCollection.Write(LOG_TYPE_INFO, '해당 블럭의 매매를 중지합니다.', 'CMXSystemManager');
    end;
  finally
    Unlock;
  end;

end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.DoWork;
begin
  if BackTestingMode then
  begin
    BackTestingDoWork;
  end
  else
  begin
    NormalDoWork;
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.BackTestingDoWork;
var
  f_ChangedData: Boolean;
  f_ItemIndex, f_Index: Integer;
  f_SystemItem: CMXSystemItem;

  f_StartTime: TDateTime;
  f_StopTime: TDateTime;
begin

  if m_IsDoStop then
  begin
    try
      Stop;
    finally
      m_IsDoStop := false;
    end;
    exit;
  end;

  if m_IsDoneWork then
    exit;

  try
{$REGION '모든 아이템의 차트데이터가 로딩이 완료 되지 않았다면'}
    if (not m_ReceivedQuery) then
    begin
      m_ReceivedQuery := True;
      for f_Index := 0 to m_Items.Count - 1 do
      begin
        f_SystemItem := CMXSystemItem(m_Items[f_Index]);
        if (not f_SystemItem.ReceivedQuery) then
        begin
          m_ReceivedQuery := false;
          break;
        end;
      end;

    end;
{$ENDREGION}
{$REGION '모든 아이템의 차트데이터가 로딩이 완료 되었다면'}
    if m_ReceivedQuery then
    begin

      LockItem;
      Lock;
      try
        MergeSystem1;
        m_Updated := True;
      finally
        Unlock;
        UnLockItem;
      end;

      if not m_AloneMode then
      begin
        if GetMerge2ChangedAndClear then
        begin
          Lock;
          try
            MergeSystem2;
            m_Updated := True;
          finally
            Unlock;
          end;

          exit;
        end;
      end
      else
      begin
        Lock;
        try
          MergeSystem2;
          m_Updated := True;
        finally
          Unlock;
        end;
      end;

      Lock;
      try
        if (m_MergeSeries1.m_Items.Count = m_LastCalcIndex) then
        begin
          m_IsDoneWork := True;
          if SleepMode and Assigned(m_DoneWorkEvent) then
          begin
            m_DoneWorkEvent(Self);
            m_IsDoneWork := false;
          end;
        end;
      finally
        Unlock;
      end;

    end;
{$ENDREGION}
  finally
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.NormalDoWork;
var
  f_ChangedData: Boolean;
  f_ItemIndex, f_Index: Integer;
  f_SystemItem: CMXSystemItem;

  f_StartTime: TDateTime;
  f_StopTime: TDateTime;
begin
  if m_IsDoStop then
  begin
    try
      Stop;
    finally
      m_IsDoStop := false;
    end;
    exit;
  end;

  if m_IsDoneWork then
    exit;

  try
{$REGION '모든 아이템의 차트데이터가 로딩이 완료 되지 않았다면'}
    if (not m_ReceivedQuery) then
    begin
      m_ReceivedQuery := True;
      for f_Index := 0 to m_Items.Count - 1 do
      begin
        f_SystemItem := CMXSystemItem(m_Items[f_Index]);
        if (not f_SystemItem.ReceivedQuery) then
        begin
          m_ReceivedQuery := false;
          break;
        end;
      end;

      if m_ReceivedQuery then
      begin
        if not BackTestingMode then
        begin
          LOG_WRITE(LOG_TYPE_INFO, 'CMXSystemManager', '최초 조회 데이터로딩이 완료되고, 처음으로 계산에 들어 갑니다.');
        end;
        LockItem;
        Lock;
        try
          MergeSystem1; // 맨 처음으로 가동함을 지시한다.
          m_Updated := True;
        finally
          Unlock;
          UnLockItem;
        end;

        if not BackTestingMode then
        begin
          LOG_WRITE(LOG_TYPE_INFO, 'CMXSystemManager', '실시간 데이터를 등록한다.');
        end;

        for f_ItemIndex := 0 to m_Items.Count - 1 do
        begin
          f_SystemItem := CMXSystemItem(m_Items[f_ItemIndex]);
          f_SystemItem.Subscribe;
          f_SystemItem.ChangedData := false;
        end;

      end;
    end
    else
{$ENDREGION}
{$REGION '모든 아이템의 차트데이터가 로딩이 완료 되었다면'}
    begin

      f_ChangedData := false;
{$REGION '각 변경유무를 체크한다'}
      for f_Index := 0 to m_Items.Count - 1 do
      begin
        f_SystemItem := CMXSystemItem(m_Items[f_Index]);
        if (f_SystemItem.ChangedData) then
        begin
          f_ChangedData := True;
          break;
        end;
      end;
{$ENDREGION}
      if f_ChangedData then
      begin
        LockItem;
        Lock;
        try
          MergeSystem1;
          m_Updated := True;
        finally
          Unlock;
          UnLockItem;
        end;

        for f_ItemIndex := 0 to m_Items.Count - 1 do
        begin
          f_SystemItem := CMXSystemItem(m_Items[f_ItemIndex]);
          f_SystemItem.ChangedData := false;
        end;

        exit;
      end;

      if not m_AloneMode then
      begin
        if GetMerge2ChangedAndClear then
        begin
          Lock;
          try
            MergeSystem2;
            m_Updated := True;
          finally
            Unlock;
          end;

          exit;
        end;
      end
      else
      begin
        Lock;
        try
          MergeSystem2;
          m_Updated := True;
        finally
          Unlock;
        end;
      end;

      Lock;
      try
        // 과거 데이터를 계산한다면...
        if Option.GetBooleanValue('USE_STAND_DATE') then
        begin
          if (m_MergeSeries1.m_Items.Count > 0) and (m_MergeSeries1.m_Items.Count = m_LastCalcIndex) then
          begin
            m_IsDoneWork := True;
          end;
        end;

        if BackTestingMode then
        begin
          if (m_MergeSeries1.m_Items.Count > 0) and (m_MergeSeries1.m_Items.Count = m_LastCalcIndex) then
          begin
            m_IsDoneWork := True;
            if SleepMode and Assigned(m_DoneWorkEvent) then
            begin
              m_DoneWorkEvent(Self);
              m_IsDoneWork := false;
            end;
          end;
        end;

      finally
        Unlock;
      end;

      if (((m_Option.GetIntegerValue('SYSTEM_MODE') = SYSTEM_MODE_REAL) and (not m_IsDoneWork)) OR ((m_Option.GetIntegerValue('SYSTEM_MODE') = SYSTEM_MODE_SIMULATION) and (not m_IsDoneWork))) then
      begin
        if (m_MergeSeries1.m_Items.Count > 0) and (m_MergeSeries1.m_Items.Count = m_LastCalcIndex) then
        begin
          f_StartTime := m_Option.GetIntegerValue('STAND_DATE') + m_Option.GetIntegerValue('START_TIME') / 86400000.0;
          f_StopTime := m_Option.GetIntegerValue('STAND_DATE') + m_Option.GetIntegerValue('STOP_TIME') / 86400000.0;
          if (f_StopTime + (30.0 / 86400.0) <= m_Option.GetVirtualExchangeDateTime) then
          begin
            m_LogCollection.Write(LOG_TYPE_INFO, '매매시간이 종료되어 매매를 중지합니다.', 'CMXSystemManager');
            m_IsDoneWork := True;
          end;
        end;
      end;

    end;
{$ENDREGION}
  finally
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.OnTimer(Sender: TObject);
var
  f_Index: Integer;
  f_LogItem: CFNLogItem;
begin
  m_Timer.Enabled := false;
  m_TimerWorking := True;

  try
    if Assigned(m_LogEvent) then
    begin
      for f_Index := 0 to m_LogCollection.m_Items.Count - 1 do
      begin
        f_LogItem := m_LogCollection.m_Items.Items[f_Index];
        m_LogEvent(Self, f_LogItem.m_DateTime, f_LogItem.m_Type, f_LogItem.m_Message, f_LogItem.m_ClassName);
      end;
      m_LogCollection.Clear;
    end
    else
    begin
      m_LogCollection.Clear;
    end;
  finally
  end;

  if m_Start then
  begin
    try
      if m_Updated then
      begin
        if Assigned(m_ChangedEvent) then
        begin
          m_ChangedEvent(Self);
          m_Updated := false;
        end;
      end;
    finally
    end;

    try
      if m_Start and m_IsDoneWork then
      begin
        if Assigned(m_DoneWorkEvent) then
        begin

          if BackTestingMode then
          begin
            m_DoneWorkEvent(Self);
            m_TimerWorking := false;
            m_Timer.Enabled := True;
            exit;
          end
          else

            // 시작하자 마자 데이터의 매매시간종료등에 의해 매매종료할 시간을 감지했다면, 잠깐 기다렸다가 한다.
            if ((Now - m_TimeOfStarting) < (20.0 / 86400.0)) then
            begin
              m_StopTimer.Enabled := True;
              m_TimerWorking := false;
              m_Timer.Enabled := True;
              exit;
            end
            else
            begin
              m_DoneWorkEvent(Self);
              m_TimerWorking := false;
              m_Timer.Enabled := True;
              exit;
            end;
        end;
      end;
    finally
    end;
  end;

  m_Timer.Enabled := True;
  m_TimerWorking := false;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.OnStopTimer(Sender: TObject);
begin
  m_StopTimer.Enabled := false;
  try
    m_DoneWorkEvent(Self);
  finally
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.MergeSystem1;
var
  f_ItemIndex: Integer;
  f_ValueIndex: Integer;
  f_SystemItem: CMXSystemItem;
  f_LineValue: CMKLineValue;
  f_SrcLineValue: CMKLineValue;
  f_Begin, f_End, f_Begin2: Integer;

  f_Signal: Integer;

  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_LineValue2: CMKLineValue;

  f_RealPrice: Double;
  f_OldMarketData, f_NewMarketData, f_ChartData: CMKChartData;

  f_StartTime, f_StopTime, f_Time: TDateTime;
  f_Year, f_Month, f_Day: Word;
  f_Hour, f_Min, f_Sec, f_MSec: Word;

  f_RealTimeLowestProfit: Double;
  f_TickStep: Double;
begin
  f_TickStep := m_Option.GetDoubleValue('TICK_STEP');
  if m_Items.Count = 0 then
    exit;

{$REGION '거래시간을 계산한다.'}
  if m_Option.GetBooleanValue('USE_REGULAR_MARKET') then
  begin
    f_StartTime := m_Option.GetIntegerValue('STAND_DATE') + Math.Max(m_Option.GetIntegerValue('START_TIME') / 86400000.0, m_Option.GetIntegerValue('REGULAR_START_TIME') / 86400000.0);
    f_StopTime := m_Option.GetIntegerValue('STAND_DATE') + Math.Min(m_Option.GetIntegerValue('STOP_TIME') / 86400000.0, m_Option.GetIntegerValue('REGULAR_STOP_TIME') / 86400000.0);
  end
  else
  begin
    f_StartTime := m_Option.GetIntegerValue('STAND_DATE') + m_Option.GetIntegerValue('START_TIME') / 86400000.0;
    f_StopTime := m_Option.GetIntegerValue('STAND_DATE') + m_Option.GetIntegerValue('STOP_TIME') / 86400000.0;
  end;

  DecodeDateTime(f_StartTime, f_Year, f_Month, f_Day, f_Hour, f_Min, f_Sec, f_MSec);
  f_StartTime := EncodeDateTime(f_Year, f_Month, f_Day, f_Hour, f_Min, 0, 0);

  DecodeDateTime(f_StopTime, f_Year, f_Month, f_Day, f_Hour, f_Min, f_Sec, f_MSec);
  f_StopTime := EncodeDateTime(f_Year, f_Month, f_Day, f_Hour, f_Min, 0, 0);
{$ENDREGION}
{$REGION '계산할 시작점을 찾는다. 이전에 작업한 마지막 부분이다'}
  f_Begin := m_MergeSeries1.m_Items.Count - 1;
  if f_Begin < 0 then
    f_Begin := 0;
{$ENDREGION}
{$REGION '계산할 마지막지점을 찾는다. 모든 시스템중 가장 적은 바를 가지고 있는 시스템의 바의 갯수'}
  f_End := -1;
  for f_ItemIndex := 0 to m_Items.Count - 1 do
  begin
    f_SystemItem := CMXSystemItem(m_Items[f_ItemIndex]);
    if f_End < 0 then
      f_End := f_SystemItem.m_SignalLineSeries.m_Items.Count
    else if f_End > f_SystemItem.m_SignalLineSeries.m_Items.Count then
      f_End := f_SystemItem.m_SignalLineSeries.m_Items.Count;
  end;
  if f_End <= 0 then
    exit;
{$ENDREGION}
{$REGION '보조지표의 길이를 설정한다'}
  m_MergeSeries1.SetLengthSeries(f_End);
{$ENDREGION}
{$REGION '차트데이터를 업데이터 한다'}
  f_SystemItem := CMXSystemItem(m_Items[0]);
  try
    m_ChartDataSeries.m_Country := f_SystemItem.m_ChartDataSeries.m_Country;
    m_ChartDataSeries.m_Group := f_SystemItem.m_ChartDataSeries.m_Group;
    m_ChartDataSeries.m_Market := f_SystemItem.m_ChartDataSeries.m_Market;
    m_ChartDataSeries.m_Symbol := f_SystemItem.m_ChartDataSeries.m_Symbol;
    m_ChartDataSeries.m_Name := f_SystemItem.m_ChartDataSeries.m_Name;
    m_ChartDataSeries.m_TimeFrame := f_SystemItem.m_ChartDataSeries.m_TimeFrame;
    m_ChartDataSeries.m_Precision := f_SystemItem.m_ChartDataSeries.m_Precision;

    for f_ValueIndex := f_Begin to f_End - 1 do
    begin
      if f_ValueIndex < 0 then
        continue;

      f_OldMarketData := CMKChartData(f_SystemItem.m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
      if (f_ValueIndex < m_ChartDataSeries.m_Items.Count) then
      begin
        f_NewMarketData := m_ChartDataSeries.m_Items[f_ValueIndex];

        // f_OpenQuarkPrice    := f_NewMarketData.m_OpenOPS    ;
        // f_OpenRealPrice     := f_NewMarketData.m_OpenPrice  ;

        f_NewMarketData.Clone(f_OldMarketData);

        // f_NewMarketData.m_OpenOPS   := f_OpenQuarkPrice;
        // f_NewMarketData.m_OpenPrice := f_OpenRealPrice;
      end
      else
      begin
        f_NewMarketData := CMKChartData.Create;
        f_NewMarketData.Clone(f_OldMarketData);
        m_ChartDataSeries.m_Items.Add(f_NewMarketData);
      end;
    end;

    if f_Begin = 0 then
    begin
      m_ChartDataSeries.m_ZeroIndex := m_ChartDataSeries.FindZeroIndex(Trunc(Option.GetIntegerValue('STAND_DATE')));
    end;

  finally
  end;
{$ENDREGION}
{$REGION '업데이터 한다'}
  for f_ValueIndex := f_Begin to f_End - 1 do
  begin
    if f_ValueIndex < 0 then
      continue;
    f_LineValue0 := m_MergeSeries1.m_Items.Items[f_ValueIndex];
    f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
    f_LineValue0.m_Value[M_MERGE_LINE_HIGHPRICE] := f_ChartData.m_HighPrice;
    f_LineValue0.m_Value[M_MERGE_LINE_LOWPRICE] := f_ChartData.m_LowPrice;
    f_LineValue0.m_Value[M_MERGE_LINE_REALPRICE] := f_ChartData.m_ClosePrice;
    f_LineValue0.m_Value[M_MERGE_LINE_VOLUME] := f_ChartData.m_Volume;
  end;
{$ENDREGION}
{$REGION '매매신호를 합친다'}
  try
    m_SelectedItem := 0;
    for f_ValueIndex := f_Begin to f_End - 1 do
    begin
      f_SystemItem := CMXSystemItem(m_Items[m_SelectedItem]);
      f_SrcLineValue := f_SystemItem.m_SignalLineSeries.m_Items[f_ValueIndex];

      f_Signal := Trunc(f_SrcLineValue.m_Value[M_X_SIGNAL]);
      f_RealPrice := f_SrcLineValue.m_Value[M_X_REALPRICE];

      f_LineValue := m_MergeSeries1.m_Items.Items[f_ValueIndex];
      f_LineValue.m_Value[M_MERGE_LINE_SYSTEMNO] := m_SelectedItem;
      f_LineValue.m_Value[M_MERGE_LINE_REALPRICE] := f_RealPrice;
      f_LineValue.m_Value[M_MERGE_LINE_SIGNAL1] := f_Signal;
    end;
  except
  end;
{$ENDREGION}
{$REGION '지정한 거래시간외의 시간대는 매매를 하지 않도록 한다.'}
  for f_ValueIndex := f_Begin to f_End - 1 do
  begin
    f_LineValue := m_MergeSeries1.m_Items.Items[f_ValueIndex];
    f_ChartData := CMKChartData(m_ChartDataSeries.m_Items[f_ValueIndex]);

    DecodeDateTime(f_ChartData.m_CloseDateTime, f_Year, f_Month, f_Day, f_Hour, f_Min, f_Sec, f_MSec);
    f_Time := EncodeDateTime(f_Year, f_Month, f_Day, f_Hour, f_Min, 0, 0);

    if (f_StartTime <= f_Time) and (f_Time <= f_StopTime) then
    begin
      f_LineValue.m_Value[M_MERGE_LINE_SIGNAL1] := f_LineValue.m_Value[M_MERGE_LINE_SIGNAL1];
    end
    else
    begin
      f_LineValue.m_Value[M_MERGE_LINE_SIGNAL1] := 0;
    end;
  end;
{$ENDREGION}
{$REGION '1차 신호의 누적수익율을 계산한다'}
  m_MergeSeries1.Calc_TotalProfit(m_MergeSeries1, M_MERGE_LINE_SIGNAL1, M_MERGE_LINE_REALPRICE, M_MERGE_LINE_PROFIT1, f_Begin, f_End);
  m_MergeSeries1.Calc_TotalProfit(m_MergeSeries1, M_MERGE_LINE_SIGNAL1, M_MERGE_LINE_HIGHPRICE, M_MERGE_LINE_PROFIT1_H, f_Begin, f_End);
  m_MergeSeries1.Calc_TotalProfit(m_MergeSeries1, M_MERGE_LINE_SIGNAL1, M_MERGE_LINE_LOWPRICE, M_MERGE_LINE_PROFIT1_L, f_Begin, f_End);
{$ENDREGION}
{$REGION '전체 거래의 리스크관리를 체크한다'}
  for f_ValueIndex := f_Begin to f_End - 1 do
  begin
    f_LineValue0 := m_MergeSeries1.m_Items.Items[f_ValueIndex];
    f_ChartData := CMKChartData(m_ChartDataSeries.m_Items[f_ValueIndex]);

    if 1 <= f_ValueIndex then
    begin
      f_LineValue1 := m_MergeSeries1.m_Items.Items[f_ValueIndex - 1];

      if (f_LineValue1.m_Value[M_MERGE_LINE_SIGNAL2] <> f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL2]) then
      begin
        m_DoExitSignal := false;
      end;

      // 이전 바에서 이미 정지되었을 경우
      if ((1 = f_LineValue1.m_Value[M_MERGE_LINE_PROFIT1_STOP]) or (m_MaxProfitLossStop)) then
      begin

        f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_STOP] := 1.0;
        f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL2] := 0;

      end
      else
      // 이전 바에서 정지가 안되었을 경우(정상일 경우)
      begin
        f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_STOP] := f_LineValue1.m_Value[M_MERGE_LINE_PROFIT1_STOP];
        f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL2] := f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL1];

{$REGION '최대 이익 초과시 매매 정지 기능을 사용하면'}
        if m_Option.GetBooleanValue('USE_RISK_MAX_PROFIT') then
        begin
          // 실기간 체크
          if m_Option.GetBooleanValue('USE_REALTIME_RISK_CHECK') then
          begin
            // 스탑이 되지 않았다면. 혹시 스탑조건이 된것이 아인지 검사한다.
            if (0 = f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_STOP]) then
            begin
              if ((m_Option.GetDoubleValue('RISK_MAX_PROFIT_POINT') <= f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1])
                // or
                // (m_Option.GetDoubleValue('RISK_MAX_PROFIT_POINT') <= f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_H]) or
                // (m_Option.GetDoubleValue('RISK_MAX_PROFIT_POINT') <= f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_L])
                ) then
              begin
                f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_STOP] := 1.0;

                m_LogCollection.Write(LOG_TYPE_INFO, '리스크관리 (' + IntToStr(f_ValueIndex) + ') 당일의 최대이익이 [일일최대이익]보다 크기 때문에 매매를 중지합니다.', 'CMXSystemManager');

                m_MaxProfitLossStop := True;
              end;
            end;
          end
          else
          // 매 바마다 체크
          begin
            // 스탑이 되지 않았다면. 혹시 스탑조건이 된것이 아인지 검사한다.
            if (0 = f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_STOP]) then
            begin
              if (m_Option.GetDoubleValue('RISK_MAX_PROFIT_POINT') <= f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1]) then
              begin
                f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_STOP] := 1.0;

                m_LogCollection.Write(LOG_TYPE_INFO, '리스크관리 (' + IntToStr(f_ValueIndex) + ') 당일의 최대이익이 [일일최대이익]보다 크기 때문에 매매를 중지합니다.', 'CMXSystemManager');

                m_MaxProfitLossStop := True;
              end;
            end;
          end;
        end;
{$ENDREGION}
{$REGION '최소 이익 미만시 매매 정지 기능을 사용하면'}
        if m_Option.GetBooleanValue('USE_RISK_MAX_LOSS') then
        begin
          // 실기간 체크
          if m_Option.GetBooleanValue('USE_REALTIME_RISK_CHECK') then
          begin

            f_RealTimeLowestProfit := f_LineValue1.m_Value[M_MERGE_LINE_PROFIT1];
            if f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL2] > 0 then
            begin
              f_RealTimeLowestProfit := f_RealTimeLowestProfit + (f_LineValue0.m_Value[M_MERGE_LINE_LOWPRICE] - f_LineValue1.m_Value[M_MERGE_LINE_REALPRICE]);
            end
            else if f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL2] < 0 then
            begin
              f_RealTimeLowestProfit := f_RealTimeLowestProfit + (f_LineValue1.m_Value[M_MERGE_LINE_REALPRICE] - f_LineValue0.m_Value[M_MERGE_LINE_HIGHPRICE]);
            end
            else
            begin
              f_RealTimeLowestProfit := f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1];
            end;

            // 스탑이 되지 않았다면. 혹시 스탑조건이 된것이 아인지 검사한다.
            if (0 = f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_STOP]) then
            begin
              if (m_Option.GetDoubleValue('RISK_MAX_LOSS_POINT') >= f_RealTimeLowestProfit) then
              begin
                f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_STOP] := 1.0;
                m_LogCollection.Write(LOG_TYPE_INFO, '리스크관리 (' + IntToStr(f_ValueIndex) + ') 당일의 최대손실이 [일일최대손실]보다 작기 때문에 매매를 중지합니다.', 'CMXSystemManager');
                m_MaxProfitLossStop := True;

                (*
                  if f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL2] > 0 then
                  begin
                  m_MaxProfitLossStopValue := f_LineValue1.m_Value[M_MERGE_LINE_REALPRICE] + (m_Option.GetDoubleValue('RISK_MAX_LOSS_POINT') - f_LineValue1.m_Value[M_MERGE_LINE_PROFIT1]);
                  end else
                  if f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL2] < 0 then
                  begin
                  m_MaxProfitLossStopValue := f_LineValue1.m_Value[M_MERGE_LINE_REALPRICE] - (m_Option.GetDoubleValue('RISK_MAX_LOSS_POINT') - f_LineValue1.m_Value[M_MERGE_LINE_PROFIT1]);
                  end else
                  begin
                  m_MaxProfitLossStopValue := f_LineValue0.m_Value[M_MERGE_LINE_REALPRICE]
                  end;
                  if BackTestingMode then
                  begin
                  f_ChartData.m_ClosePrice := m_MaxProfitLossStopValue;
                  f_ChartData.m_ClosePrice := Round(f_ChartData.m_ClosePrice * f_TickStep) / f_TickStep;
                  end;
                *)
              end;
            end;
          end
          else
          // 매 바마다 체크
          begin
            // 스탑이 되지 않았다면. 혹시 스탑조건이 된것이 아인지 검사한다.
            if (0 = f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_STOP]) then
            begin
              if (m_Option.GetDoubleValue('RISK_MAX_LOSS_POINT') >= f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1]) then
              begin
                f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_STOP] := 1.0;
                m_LogCollection.Write(LOG_TYPE_INFO, '리스크관리 (' + IntToStr(f_ValueIndex) + ') 당일의 최대손실이 [일일최대손실]보다 작기 때문에 매매를 중지합니다.', 'CMXSystemManager');
                m_MaxProfitLossStop := True;
                // m_MaxProfitLossStopValue := f_LineValue0.m_Value[M_MERGE_LINE_REALPRICE];
              end;
            end;
          end;
        end;
{$ENDREGION}
        // 최대 손실 또는 이익을 매매가 정지되면, 신호를 중립으로 변경한다.
        if (0 <> f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_STOP]) then
        begin
          f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL2] := 0;
        end;

        if m_DoExitSignal then
          f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL2] := 0;
      end;

    end
    else
    begin
      f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_STOP] := 0;
      f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL2] := f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL1];
    end;

    if m_IsStopForLosscut then
    begin
      f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL2] := 0;
      f_LineValue0.m_Value[M_MERGE_LINE_PROFIT1_STOP] := 1.0;
    end;

  end;
{$ENDREGION}
  SetMerge1Changed(True);
  SetMerge1ChangedFromStart(True);
end;

// ------------------------------------------------------------------------------------
procedure CMXSystemManager.MergeSystem2;
var
  f_FirstTime: Boolean;
  f_ValueIndex: Integer;

  f_Begin, f_End: Integer;

  f_Signal: Integer;

  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_LineValue2: CMKLineValue;

  f_OldSinalCount: Integer;
  f_SignalData: CFNSignalData;
  f_NSignalData: CFNSignalData;

  f_ChartData: CMKChartData;

  f_DoneWork: Boolean;
  f_StartTime: TDateTime;
  f_StopTime: TDateTime;
  f_Year, f_Month, f_Day: Word;
  f_Hour, f_Min, f_Sec, f_MSec: Word;
  f_ZeroIndex: Integer;
begin
  f_FirstTime := false;

{$REGION '거래시간을 계산한다.'}
  if m_Option.GetBooleanValue('USE_REGULAR_MARKET') then
  begin
    f_StartTime := m_Option.GetIntegerValue('STAND_DATE') + Math.Max(m_Option.GetIntegerValue('START_TIME') / 86400000.0, m_Option.GetIntegerValue('REGULAR_START_TIME') / 86400000.0);
    f_StopTime := m_Option.GetIntegerValue('STAND_DATE') + Math.Min(m_Option.GetIntegerValue('STOP_TIME') / 86400000.0, m_Option.GetIntegerValue('REGULAR_STOP_TIME') / 86400000.0);
  end
  else
  begin
    f_StartTime := m_Option.GetIntegerValue('STAND_DATE') + m_Option.GetIntegerValue('START_TIME') / 86400000.0;
    f_StopTime := m_Option.GetIntegerValue('STAND_DATE') + m_Option.GetIntegerValue('STOP_TIME') / 86400000.0;
  end;

  DecodeDateTime(f_StartTime, f_Year, f_Month, f_Day, f_Hour, f_Min, f_Sec, f_MSec);
  f_StartTime := EncodeDateTime(f_Year, f_Month, f_Day, f_Hour, f_Min, 0, 0);

  DecodeDateTime(f_StopTime, f_Year, f_Month, f_Day, f_Hour, f_Min, f_Sec, f_MSec);
  f_StopTime := EncodeDateTime(f_Year, f_Month, f_Day, f_Hour, f_Min, 0, 0);
{$ENDREGION}
  f_DoneWork := false;

{$REGION '계산할 시작점을 찾는다. 이전에 작업한 마지막 부분이다'}
  f_Begin := m_LastCalcIndex - 1;
  if f_Begin < 0 then
    f_Begin := 0;
{$ENDREGION}
  if 0 = f_Begin then
    f_FirstTime := True;

{$REGION '계산할 마지막지점을 찾는다. 모든 시스템중 가장 적은 바를 가지고 있는 시스템의 바의 갯수'}
  if m_AloneMode then
  begin
    f_End := m_MergeSeries1.m_Items.Count;
  end
  else
  begin
    f_End := m_MergeSeries2.m_Items.Count;
    if f_End > m_MergeSeries1.m_Items.Count then
      f_End := m_MergeSeries1.m_Items.Count;
  end;
  if f_End <= 0 then
    exit;
{$ENDREGION}
{$REGION '새로운 바가 추가 되었을 때 만 계산한다'}
  if f_Begin < f_End then
  begin
{$REGION '지정한 거래시간외의 시간대는 매매를 하지 않도록 한다.'}
    for f_ValueIndex := f_Begin to f_End - 1 do
    begin
      f_ChartData := CMKChartData(m_ChartDataSeries.m_Items[f_ValueIndex]);

      // 설정한 마감시간 이후에 매매시스템이 자동종료하기 위한 절차
      if (f_StopTime <= f_ChartData.m_CloseDateTime) then
      begin
        f_DoneWork := True;
      end;

    end;
{$ENDREGION}
{$REGION '계산결과를 적용한다'}
    if m_AloneMode then
    begin
      for f_ValueIndex := f_Begin to f_End - 1 do
      begin
        f_LineValue0 := m_MergeSeries1.m_Items.Items[f_ValueIndex];
        f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL3] := f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL2];
      end;
    end
    else
    begin
      f_ZeroIndex := m_ChartDataSeries.m_ZeroIndex;
      for f_ValueIndex := f_Begin to f_End - 1 do
      begin
        f_LineValue0 := m_MergeSeries1.m_Items.Items[f_ValueIndex];
        f_LineValue2 := m_MergeSeries2.m_Items.Items[f_ValueIndex];

        f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL3] := f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL2];

        if f_LineValue2.m_Value[0] <> 1 then
        begin
          f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL3] := 0;
        end;
      end;
    end;
{$ENDREGION}
  end;
{$ENDREGION}
{$REGION '3차 신호의 누적수익율을 계산한다'}
  m_MergeSeries1.Calc_TotalProfit(m_MergeSeries1, M_MERGE_LINE_SIGNAL3, M_MERGE_LINE_REALPRICE, M_MERGE_LINE_PROFIT3, f_Begin, f_End);
{$ENDREGION}
{$REGION '최근 결과를 맴버변수에 저장한다'}
  if m_MergeSeries1.m_Items.Count > 0 then
  begin
    f_LineValue0 := CMKLineValue(m_MergeSeries1.m_Items.Items[m_MergeSeries1.m_Items.Count - 1]);
    m_TotalProfit := f_LineValue0.m_Value[M_MERGE_LINE_PROFIT3];
    m_LastSignal := Trunc(f_LineValue0.m_Value[M_MERGE_LINE_SIGNAL3]);
    m_RealPrice := f_LineValue0.m_Value[M_MERGE_LINE_REALPRICE];
  end
  else
  begin
    m_TotalProfit := 0;
    m_LastSignal := 0;
    m_RealPrice := 0;
  end;
{$ENDREGION}
{$REGION '신호를 스캔한다'}
  f_OldSinalCount := m_SignalArray.m_Items.Count;

  if (not m_MaxProfitLossStop) and (not m_IsStopForLosscut) then
  begin
    m_MergeSeries1.ScanSignalAtTrade(m_ChartDataSeries, m_SignalArray, 0, M_MERGE_LINE_SIGNAL3, f_Begin, f_End - 1);

    if f_FirstTime then
    begin
      if (m_Option.GetBooleanValue('ACTION_ON_START')) and Assigned(m_OrderManager) and (m_SignalArray.m_Items.Count > 0) then
      begin
        f_SignalData := m_SignalArray.m_Items.Items[m_SignalArray.m_Items.Count - 1];
        if (f_SignalData.m_Signal = SIGNAL_SELL_ENTER) or (f_SignalData.m_Signal = SIGNAL_BUY_ENTER) then
        begin
          if not Option.GetBooleanValue('USE_STAND_DATE') then
            m_OrderManager.StoreNewSignal(f_SignalData);
        end;
      end;
    end
    else
    begin
      if f_OldSinalCount <> m_SignalArray.m_Items.Count then
      begin
        for f_ValueIndex := f_OldSinalCount to m_SignalArray.m_Items.Count - 1 do
        begin
          if Assigned(m_OrderManager) then
            m_OrderManager.StoreNewSignal(m_SignalArray.m_Items.Items[f_ValueIndex]);
        end;
      end;
    end;
  end
  else
  begin
    m_MergeSeries1.ScanSignalAtTrade(m_ChartDataSeries, m_SignalArray, 0, M_MERGE_LINE_SIGNAL3, f_Begin, f_End);
    if m_SignalArray.m_Items.Count > 0 then
    begin
      f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[m_ChartDataSeries.m_Items.Count - 1]);
      f_SignalData := m_SignalArray.m_Items.Items[m_SignalArray.m_Items.Count - 1];

      if (f_SignalData.m_Signal = SIGNAL_SELL_ENTER) then
      begin
        f_NSignalData := CFNSignalData.Create;
        f_NSignalData.m_SystemNo := 0;
        f_NSignalData.m_Index := 0;
        f_NSignalData.m_DateTime := f_ChartData.m_CloseDateTime;
        f_NSignalData.m_Signal := SIGNAL_SELL_EXIT;
        f_NSignalData.m_Price := f_ChartData.m_ClosePrice;
        f_NSignalData.m_OPS := f_ChartData.m_CloseOPS;
        m_SignalArray.Add(f_NSignalData);
      end
      else if (f_SignalData.m_Signal = SIGNAL_BUY_ENTER) then
      begin
        f_NSignalData := CFNSignalData.Create;
        f_NSignalData.m_SystemNo := 0;
        f_NSignalData.m_Index := 0;
        f_NSignalData.m_DateTime := f_ChartData.m_CloseDateTime;
        f_NSignalData.m_Signal := SIGNAL_BUY_EXIT;
        f_NSignalData.m_Price := f_ChartData.m_ClosePrice;
        f_NSignalData.m_OPS := f_ChartData.m_CloseOPS;
        m_SignalArray.Add(f_NSignalData);
      end;
    end;

    if f_OldSinalCount <> m_SignalArray.m_Items.Count then
    begin
      for f_ValueIndex := f_OldSinalCount to m_SignalArray.m_Items.Count - 1 do
      begin
        f_SignalData := m_SignalArray.m_Items.Items[f_ValueIndex];

        if (m_IsStopForLosscut) then
        begin
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[m_ChartDataSeries.m_Items.Count - 1]);

          f_SignalData.m_Price := f_ChartData.m_ClosePrice;
          f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
        end;

        if Assigned(m_OrderManager) then
          m_OrderManager.StoreNewSignal(f_SignalData);
      end;
    end;
  end;

{$ENDREGION}
  if f_DoneWork then
  begin
    if not BackTestingMode then
    begin
      m_LogCollection.Write(LOG_TYPE_INFO, '매매시간이 종료되어 매매를 중지합니다.', 'CMXSystemManager');
    end;
    m_IsDoneWork := True;
  end;
  m_LastCalcIndex := f_End;
  m_Updated := True;
end;

{$ENDREGION}

end.
