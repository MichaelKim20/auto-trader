unit FNQChartDataManager;

interface

uses
    SysUtils,
    ExtCtrls,
    FNSocketManager,
    FNDataSet,
    FNQueue,
    FNDataDelivery,
    FNDataObject,
    FNQuotData,
    FNSymbolCollection,
    FNQRequestData;
type
    TFNDataPackageEvent = Procedure(p_Type:String; p_RequestData:CFNQRequestData; p_DataPackage:CFNDataPackage) of Object;
    TFNDataStreamEvent = Procedure(p_StreamRecord:CFNStreamRecord) of Object;


    CFNQChartDataManager = class(TObject)
    private
        m_SocketManager     : CFNSocketManager;
        m_DataDelivery      : CFNDataDelivery;
        m_RequestQueue      : CFNQueue;

        m_WorkTimer         : TTimer;

        m_RequestData       : CFNQRequestData;

        m_RQTime            : TDateTime;

	    m_OnDataPackageEvent : TFNDataPackageEvent;
	    m_OnDataStreamEvent : TFNDataStreamEvent;
    public
        constructor Create();
        destructor  Destroy(); override;

        procedure SetSocketManager(p_SocketManager:CFNSocketManager);
        procedure ClearRequestQueue();
        procedure PushRequestQueue(p_RequestData:CFNQRequestData);
        function PopRequestQueue() : CFNQRequestData;
        procedure Request_TR_AC_1000_Type0(p_Country:Integer; p_Group:Integer; p_Market:Integer; p_Symbol:String; p_Name:String; p_TimeFrame:Integer; p_Count:Integer;
            p_ClearDrawObject:Boolean;
            p_StandDate:TDateTime);
        procedure Request_TR_AC_1000_Type1(p_Country:Integer; p_Group:Integer; p_Market:Integer; p_Symbol:String; p_Name:String; p_TimeFrame:Integer; p_StartDate:TDateTime; p_EndDate:TDateTime; p_XDirection:Integer; p_XMinDate:TDateTime; p_XMaxDate:TDateTime; p_XMinOffset:Integer; p_XMaxOffset:Integer; p_ClearOldData:Boolean);
        procedure Request_TR_AC_1000_Type2(p_Country:Integer; p_Group:Integer; p_Market:Integer; p_Symbol:String; p_Name:String; p_TimeFrame:Integer; p_StartDate:TDateTime; p_Count:Integer; p_XDirection:Integer; p_XMinDate:TDateTime; p_XMaxDate:TDateTime; p_XMinOffset:Integer; p_XMaxOffset:Integer; p_ClearOldData:Boolean);
        procedure Request_TR_AC_1000_Type3(p_Country:Integer; p_Group:Integer; p_Market:Integer; p_Symbol:String; p_Name:String; p_TimeFrame:Integer; p_EndDate:TDateTime; p_Count:Integer; p_XDirection:Integer; p_XMinDate:TDateTime; p_XMaxDate:TDateTime; p_XMinOffset:Integer; p_XMaxOffset:Integer; p_ClearOldData:Boolean);

        procedure OnReply(ADataPackage:CFNDataPackage; var AutoFree:Boolean);
        procedure OnStream(AStreamRecord:CFNStreamRecord);

        property OnDataPackageEvent: TFNDataPackageEvent read m_OnDataPackageEvent write m_OnDataPackageEvent;
        property OnDataStreamEvent: TFNDataStreamEvent read m_OnDataStreamEvent write m_OnDataStreamEvent;

        function SubscribeQuote(ASymbolItem:CFNSymbolItem) : Boolean;
        procedure UnSubscribeQuote(ASymbolItem:CFNSymbolItem);

    protected
        Procedure WorkTimer(Sender:TObject);

    end;

implementation
uses
    FNGlobal;

//---------------------------------------------------------------------------
constructor CFNQChartDataManager.Create();
begin
    inherited Create();

    m_DataDelivery := CFNDataDelivery.Create();
    m_DataDelivery.UseTimer := true;
    m_DataDelivery.OnReplyEvent := OnReply;
    m_DataDelivery.OnStreamEvent := OnStream;
    m_DataDelivery.OnTimeoutEvent := nil;

    m_RequestQueue := CFNQueue.Create();
    m_RequestQueue.SetAutoFree(FALSE);


    m_WorkTimer := TTimer.Create(NIL);
    m_WorkTimer.OnTimer  := WorkTimer;
    m_WorkTimer.Interval := 10;
end;

//---------------------------------------------------------------------------
destructor CFNQChartDataManager.Destroy();
begin
    if Assigned(m_WorkTimer) then
    begin
        m_WorkTimer.Enabled := FALSE;
        m_WorkTimer.Free();
        m_WorkTimer := NIL;
    end;

    if Assigned(m_RequestQueue) then
    begin
        ClearRequestQueue();
        m_RequestQueue.Free();
        m_RequestQueue := NIL;
    end;

    if Assigned(m_RequestData) then
    begin
        m_RequestData.Free();
        m_RequestData := NIL;
    end;

    m_DataDelivery.Free;
    m_DataDelivery := NIL;

    inherited Destroy();
end;

//---------------------------------------------------------------------------
procedure CFNQChartDataManager.ClearRequestQueue();
begin
    if Assigned(m_RequestQueue) then
    begin
        while (m_RequestQueue.GetCount() > 0) do
        begin
            CFNQRequestData(m_RequestQueue.Retrieve()).Free();
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartDataManager.PushRequestQueue(p_RequestData:CFNQRequestData);
begin
    if Assigned(m_RequestQueue) then
    begin
        m_RequestQueue.Store(p_RequestData);
    end;
end;

//---------------------------------------------------------------------------
function CFNQChartDataManager.PopRequestQueue() : CFNQRequestData;
begin
    if (m_RequestQueue.GetCount() > 0) then
    begin
		Result := m_RequestQueue.Retrieve();
    end
    else
        Result := NIL;
end;

//---------------------------------------------------------------------------
procedure CFNQChartDataManager.OnReply(ADataPackage:CFNDataPackage; var AutoFree:Boolean);
var
    f_SvcID : String;
begin
    if not Assigned(m_RequestData) then exit;
    try
        f_SvcID := ADataPackage.GetServiceID;
        if ('SC_ADV_CHART' = f_SvcID) then
        begin
            if not m_RequestData.m_Cancel then m_OnDataPackageEvent('', m_RequestData, ADataPackage);

            if Assigned(m_RequestData) then
            begin
                m_RequestData.Free();
                m_RequestData := NIL;
            end;
        end;
    except
        if Assigned(m_RequestData) then
        begin
            m_RequestData.Free();
            m_RequestData := NIL;
        end;
    end;
end;

//---------------------------------------------------------------------------
Procedure CFNQChartDataManager.WorkTimer(Sender:TObject);
var
    f_NewRequestData    : CFNQRequestData;
    f_OldRequestData    : CFNQRequestData;
begin
    try
		if (m_RequestData = NIL) then
        begin
            f_OldRequestData := PopRequestQueue();
            if (f_OldRequestData <> NIl) then
            begin
                while (true) do
                begin
                    f_NewRequestData := PopRequestQueue();
                    if (f_NewRequestData = NIL) then
                    begin
                        m_RequestData := f_OldRequestData;
                        break;
                    end;

                    if (f_OldRequestData <> NIL) then
                    begin
                        f_OldRequestData.Free();
                        f_OldRequestData := NIL;
                    end;

                    f_OldRequestData := f_NewRequestData;
                end;
                if (m_RequestData <> NIL) then
                begin
                    m_RQTime := Now;
                    m_SocketManager.Request(m_DataDelivery, m_RequestData.m_DataPackage);
                end;
            end;
        end else
        begin
            if ((Now-m_RQTime) * 86400 > 60) then
            begin
                m_SocketManager.DeleteRequest(m_DataDelivery);
                m_RequestData.Free;
                m_RequestData := NIL;
            end;
        end;
    except
    end;

end;

//---------------------------------------------------------------------------
procedure CFNQChartDataManager.Request_TR_AC_1000_Type0(
p_Country:Integer;
p_Group:Integer;
p_Market:Integer;
p_Symbol:String;
p_Name:String;
p_TimeFrame:Integer;
p_Count:Integer;
p_ClearDrawObject:Boolean;
p_StandDate:TDateTime);
var
    f_RequestData   : CFNQRequestData;
    f_Record              : CFNRecord;
    f_DataSet:CFNDataSet;
begin
    if Assigned(m_RequestData) then m_RequestData.m_Cancel := true;
    //m_DataDelivery.ClearRequest;
    ClearRequestQueue;

    //m_RequestData.Free;
    //m_RequestData := NIL;

    if ( Assigned(m_DataDelivery) and (0 < Length(p_Symbol)) and (0 < p_TimeFrame) ) then
    begin
        f_RequestData := CFNQRequestData.Create();
        f_RequestData.m_Country             := p_Country;
        f_RequestData.m_Group               := p_Group;
        f_RequestData.m_Market              := p_Market;
		f_RequestData.m_Symbol 				:= p_Symbol;
		f_RequestData.m_Name 				:= p_Name;
		f_RequestData.m_TimeFrame 			:= p_TimeFrame;
		f_RequestData.m_State 				:= CFNQRequestData.RQ_MAIN_NEW;
		f_RequestData.m_ClearDrawObject 	:= p_ClearDrawObject;
		f_RequestData.m_RequestType 		:= 0;

        f_Record := CFNRecord.Create();

        f_Record.AddDoubleValue('COUNTRY_NO', p_Country);
        f_Record.AddDoubleValue('GROUP_NO', p_Group);
        f_Record.AddDoubleValue('MARKET_NO', p_Market);
        f_Record.AddStringValue('SYMBOL', p_Symbol);
        f_Record.AddIntegerValue('TIMEFRAME', p_TimeFrame);
        f_Record.AddStringValue('STAND_DATE', TFNGlobal.DateToString_YYYYMMDD(p_StandDate) );
        f_Record.AddStringValue('RQ_TYPE', '0');
        f_Record.AddDoubleValue('COUNT', p_Count);
        f_Record.AddStringValue('START_DATETIME', '00000000000000');
        f_Record.AddStringValue('END_DATETIME', '00000000000000');

        f_RequestData.m_DataPackage.ClearAll;
        f_RequestData.m_DataPackage.FillHead;
        f_RequestData.m_DataPackage.SetServiceID('SC_ADV_CHART');
        f_RequestData.m_DataPackage.SetTRCode('TR_0110');

        f_DataSet := CFNDataSet.Create;
        f_DataSet.Name := DATASETID_IN_01;
        f_DataSet.AddFieldInfo('COUNTRY_NO'         , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('GROUP_NO'           , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('MARKET_NO'          , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('SYMBOL'             , 16, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('TIMEFRAME'          , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('STAND_DATE'         ,  8, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('RQ_TYPE'            ,  1, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('COUNT'              , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('START_DATETIME'     , 14, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('END_DATETIME'       , 14, COLTYPE_STRING);
        f_DataSet.RecordList.Add(f_Record);
        f_RequestData.m_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

        PushRequestQueue(f_RequestData);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartDataManager.Request_TR_AC_1000_Type1(p_Country:Integer; p_Group:Integer; p_Market:Integer; p_Symbol:String; p_Name:String; p_TimeFrame:Integer; p_StartDate:TDateTime; p_EndDate:TDateTime;
    p_XDirection:Integer; p_XMinDate:TDateTime; p_XMaxDate:TDateTime; p_XMinOffset:Integer; p_XMaxOffset:Integer; p_ClearOldData:Boolean);
var
    f_RequestData   : CFNQRequestData;
    f_Record              : CFNRecord;
    f_DataSet:CFNDataSet;
begin
    if (Assigned(m_DataDelivery)) then
    begin
        f_RequestData := CFNQRequestData.Create();
        f_RequestData.m_Country             := p_Country;
        f_RequestData.m_Group               := p_Group;
        f_RequestData.m_Market              := p_Market;
		f_RequestData.m_Symbol 				:= p_Symbol;
		f_RequestData.m_Name 				:= p_Name;
		f_RequestData.m_TimeFrame 			:= p_TimeFrame;
		f_RequestData.m_State 				:= CFNQRequestData.RQ_MAIN_ADD;
		f_RequestData.m_XMaxDate            := p_XMaxDate;
		f_RequestData.m_XMinDate            := p_XMinDate;
		f_RequestData.m_XMaxOffset          := p_XMaxOffset;
		f_RequestData.m_XMinOffset          := p_XMinOffset;
		f_RequestData.m_XDirection          := p_XDirection;
		f_RequestData.m_ClearOldData        := p_ClearOldData;
		f_RequestData.m_RequestType         := 1;

        f_Record := CFNRecord.Create();

        f_Record.AddDoubleValue('COUNTRY_NO', p_Country);
        f_Record.AddDoubleValue('GROUP_NO', p_Group);
        f_Record.AddDoubleValue('MARKET_NO', p_Market);
        f_Record.AddStringValue('SYMBOL', p_Symbol);
        f_Record.AddIntegerValue('TIMEFRAME', p_TimeFrame);
        f_Record.AddStringValue('STAND_DATE', TFNGlobal.DateToString_YYYYMMDD(Now) );
        f_Record.AddStringValue('RQ_TYPE', '1');
        f_Record.AddDoubleValue('COUNT', 0);
        f_Record.AddStringValue('START_DATETIME', TFNGlobal.DateTimeToString(p_StartDate, 'YYYYMMDDHHMMSS'));
        f_Record.AddStringValue('END_DATETIME'  , TFNGlobal.DateTimeToString(p_EndDate, 'YYYYMMDDHHMMSS'));

        f_RequestData.m_DataPackage.ClearAll;
        f_RequestData.m_DataPackage.FillHead;
        f_RequestData.m_DataPackage.SetServiceID('SC_ADV_CHART');
        f_RequestData.m_DataPackage.SetTRCode('TR_0010');

        f_DataSet := CFNDataSet.Create;
        f_DataSet.Name := DATASETID_IN_01;
        f_DataSet.AddFieldInfo('COUNTRY_NO'         , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('GROUP_NO'           , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('MARKET_NO'          , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('SYMBOL'             , 16, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('TIMEFRAME'          , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('STAND_DATE'         ,  8, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('RQ_TYPE'            ,  1, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('COUNT'              , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('START_DATETIME'     , 14, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('END_DATETIME'       , 14, COLTYPE_STRING);
        f_DataSet.RecordList.Add(f_Record);
        f_RequestData.m_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

        PushRequestQueue(f_RequestData);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartDataManager.Request_TR_AC_1000_Type2(p_Country:Integer; p_Group:Integer; p_Market:Integer; p_Symbol:String; p_Name:String; p_TimeFrame:Integer; p_StartDate:TDateTime; p_Count:Integer;
    p_XDirection:Integer; p_XMinDate:TDateTime; p_XMaxDate:TDateTime; p_XMinOffset:Integer; p_XMaxOffset:Integer; p_ClearOldData:Boolean);
var
    f_RequestData   : CFNQRequestData;
    f_Record              : CFNRecord;
    f_DataSet:CFNDataSet;
begin
    if (Assigned(m_DataDelivery)) then
    begin
        f_RequestData := CFNQRequestData.Create();
        f_RequestData.m_Country             := p_Country;
        f_RequestData.m_Group               := p_Group;
        f_RequestData.m_Market              := p_Market;
		f_RequestData.m_Symbol 				:= p_Symbol;
		f_RequestData.m_Name 				:= p_Name;
		f_RequestData.m_TimeFrame 			:= p_TimeFrame;
		f_RequestData.m_State 				:= CFNQRequestData.RQ_MAIN_ADD;
		f_RequestData.m_XMaxDate            := p_XMaxDate;
		f_RequestData.m_XMinDate            := p_XMinDate;
		f_RequestData.m_XMaxOffset          := p_XMaxOffset;
		f_RequestData.m_XMinOffset          := p_XMinOffset;
		f_RequestData.m_XDirection          := p_XDirection;
		f_RequestData.m_ClearOldData        := p_ClearOldData;
		f_RequestData.m_RequestType         := 2;

        f_Record := CFNRecord.Create();

        f_Record.AddDoubleValue('COUNTRY_NO', p_Country);
        f_Record.AddDoubleValue('GROUP_NO', p_Group);
        f_Record.AddDoubleValue('MARKET_NO', p_Market);
        f_Record.AddStringValue('SYMBOL', p_Symbol);
        f_Record.AddIntegerValue('TIMEFRAME', p_TimeFrame);
        f_Record.AddStringValue('STAND_DATE', TFNGlobal.DateToString_YYYYMMDD(Now) );
        f_Record.AddStringValue('RQ_TYPE', '2');
        f_Record.AddDoubleValue('COUNT', p_Count);
        f_Record.AddStringValue('START_DATETIME', TFNGlobal.DateTimeToString(p_StartDate, 'YYYYMMDDHHMMSS'));
        f_Record.AddStringValue('END_DATETIME'  , '000000000000');

        f_RequestData.m_DataPackage.ClearAll;
        f_RequestData.m_DataPackage.FillHead;
        f_RequestData.m_DataPackage.SetServiceID('SC_ADV_CHART');
        f_RequestData.m_DataPackage.SetTRCode('TR_0010');

        f_DataSet := CFNDataSet.Create;
        f_DataSet.Name := DATASETID_IN_01;
        f_DataSet.AddFieldInfo('COUNTRY_NO'         , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('GROUP_NO'           , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('MARKET_NO'          , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('SYMBOL'             , 16, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('TIMEFRAME'          , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('STAND_DATE'         ,  8, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('RQ_TYPE'            ,  1, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('COUNT'              , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('START_DATETIME'     , 14, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('END_DATETIME'       , 14, COLTYPE_STRING);
        f_DataSet.RecordList.Add(f_Record);
        f_RequestData.m_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

        //요청 큐에넣는다.
        PushRequestQueue(f_RequestData);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartDataManager.Request_TR_AC_1000_Type3(p_Country:Integer; p_Group:Integer; p_Market:Integer; p_Symbol:String; p_Name:String; p_TimeFrame:Integer; p_EndDate:TDateTime; p_Count:Integer;
    p_XDirection:Integer; p_XMinDate:TDateTime; p_XMaxDate:TDateTime; p_XMinOffset:Integer; p_XMaxOffset:Integer; p_ClearOldData:Boolean);
var
    f_RequestData   : CFNQRequestData;
    f_Record              : CFNRecord;
    f_DataSet:CFNDataSet;
begin
    if (Assigned(m_DataDelivery)) then
    begin
        f_RequestData := CFNQRequestData.Create();
        f_RequestData.m_Country             := p_Country;
        f_RequestData.m_Group               := p_Group;
        f_RequestData.m_Market              := p_Market;
		f_RequestData.m_Symbol 				:= p_Symbol;
		f_RequestData.m_Name 				:= p_Name;
		f_RequestData.m_TimeFrame 			:= p_TimeFrame;
		f_RequestData.m_State 				:= CFNQRequestData.RQ_MAIN_ADD;
		f_RequestData.m_XMaxDate            := p_XMaxDate;
		f_RequestData.m_XMinDate            := p_XMinDate;
		f_RequestData.m_XMaxOffset          := p_XMaxOffset;
		f_RequestData.m_XMinOffset          := p_XMinOffset;
		f_RequestData.m_XDirection          := p_XDirection;
		f_RequestData.m_ClearOldData        := p_ClearOldData;
		f_RequestData.m_RequestType         := 3;

        f_Record := CFNRecord.Create();

        f_Record.AddDoubleValue('COUNTRY_NO', p_Country);
        f_Record.AddDoubleValue('GROUP_NO', p_Group);
        f_Record.AddDoubleValue('MARKET_NO', p_Market);
        f_Record.AddStringValue('SYMBOL', p_Symbol);
        f_Record.AddIntegerValue('TIMEFRAME', p_TimeFrame);
        f_Record.AddStringValue('STAND_DATE', TFNGlobal.DateToString_YYYYMMDD(Now) );
        f_Record.AddStringValue('RQ_TYPE', '3');
        f_Record.AddDoubleValue('COUNT', p_Count);
        f_Record.AddStringValue('START_DATETIME', '000000000000');
        f_Record.AddStringValue('END_DATETIME'  , TFNGlobal.DateTimeToString(p_EndDate, 'YYYYMMDDHHMMSS'));

        f_RequestData.m_DataPackage.ClearAll;
        f_RequestData.m_DataPackage.FillHead;
        f_RequestData.m_DataPackage.SetServiceID('SC_ADV_CHART');
        f_RequestData.m_DataPackage.SetTRCode('TR_0010');

        f_DataSet := CFNDataSet.Create;
        f_DataSet.Name := DATASETID_IN_01;
        f_DataSet.AddFieldInfo('COUNTRY_NO'         , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('GROUP_NO'           , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('MARKET_NO'          , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('SYMBOL'             , 16, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('TIMEFRAME'          , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('STAND_DATE'         ,  8, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('RQ_TYPE'            ,  1, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('COUNT'              , 32, COLTYPE_INTEGER);
        f_DataSet.AddFieldInfo('START_DATETIME'     , 14, COLTYPE_STRING);
        f_DataSet.AddFieldInfo('END_DATETIME'       , 14, COLTYPE_STRING);
        f_DataSet.RecordList.Add(f_Record);
        f_RequestData.m_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

        PushRequestQueue(f_RequestData);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNQChartDataManager.SetSocketManager(p_SocketManager:CFNSocketManager);
begin
    m_SocketManager := p_SocketManager;
end;

//---------------------------------------------------------------------------
function CFNQChartDataManager.SubscribeQuote(ASymbolItem:CFNSymbolItem): Boolean;
begin
    Result := false;

    if (Assigned(m_DataDelivery)) then
    begin
        if ( (0 <= ASymbolItem.m_Country)
            and (0 <= ASymbolItem.m_Group)
            and (0 <= ASymbolItem.m_Market)
            and (0 < Length(ASymbolItem.m_Symbol)) ) then
        begin
            m_SocketManager.SubscribeQuote(m_DataDelivery, ASymbolItem.m_Country, ASymbolItem.m_Group, ASymbolItem.m_Market, ASymbolItem.m_Symbol);
            Result := true;
        end;
    end;

end;

procedure CFNQChartDataManager.UnSubscribeQuote(ASymbolItem:CFNSymbolItem);
begin
    if (Assigned(m_DataDelivery)) then
    begin
        if ( (0 <= ASymbolItem.m_Country)
            and (0 <= ASymbolItem.m_Group)
            and (0 <= ASymbolItem.m_Market)
            and (0 < Length(ASymbolItem.m_Symbol)) ) then
        begin
            m_SocketManager.UnSubscribeQuote(m_DataDelivery, ASymbolItem.m_Country, ASymbolItem.m_Group, ASymbolItem.m_Market, ASymbolItem.m_Symbol);
        end;
    end;
end;

procedure CFNQChartDataManager.OnStream(AStreamRecord: CFNStreamRecord);
begin
    if Assigned(m_OnDataStreamEvent) then m_OnDataStreamEvent(AStreamRecord);
end;

end.
