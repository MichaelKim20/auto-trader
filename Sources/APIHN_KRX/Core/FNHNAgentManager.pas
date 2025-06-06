//**************************************************************************//
//  FileName        :   FNHNAgentManager.pas
//  Author          :   김무근 작성
//  Date            :   2014년 1월 10일
//  Description     :   하나대투 API를 통해, 시세와 주문을 구현하기 위한 클래스
//**************************************************************************//
{하나대투사 API를 통해, 시세와 주문을 구현하기 위한 클래스}
Unit FNHNAgentManager;

interface

uses
    Messages, WinProcs, SysUtils, Forms, ActiveX, WinTypes, Classes, SyncObjs, ExtCtrls,
    Contnrs, IniFiles, Math, FNDataSet, FNDataDelivery, Variants, FNAgentManager,
    IODataSet, FNQueue, FNIOHandler, WRAXLib_TLB, H5MGREXLib_TLB;

const
    RQDATA_ERROR        =   69; //      'E'
    RQDATA_MESSAGE      =   77; //      'M'
    RQDATA_RELEASE      =   82; //      'R'
    RQDATA_DATA         =   68; //      'D'

type
    ///<author>김무근</author>
    ///<version>1.0</version>
    ///<since>2014.01.10</since>
    ///<Comment>하나대투 API를 이용하여 필요한 기능을 확장한 클래스</Comment>
    CFNHNAgentManager = class(CFNAgentManager)
    public
        ///<Comment>생성자</Comment>
        Constructor Create(AQueryThreadCount:Integer = 1);

        ///<Comment>파괴자</Comment>
        Destructor Destroy; override;

        ///<Comment>증권사 API OCX를 등록한다.</Comment>
        procedure AssignAgent(p_Agent:TWRAX);

        ///<Comment>증권사 API OCX를 등록한다.</Comment>
        procedure AssignH5Agent(p_Agent:TH5MgrEx);

        ///<Comment>작업쓰레드가 진입하는 곳</Comment>
        procedure DoQueryWork(AThreadIndex:Integer); override;

        procedure DoCheckTimeout;

        ///<Comment>시세 실시간 스트리밍 데이터를 요청한다.</Comment>
        procedure SubscribeQuote(ADataDelivery:CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String); override;

        ///<Comment>시세 실시간 스트리밍 데이터를 해지한다.</Comment>
        procedure UnsubscribeQuote(ADataDelivery:CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String); override;

        ///<Comment>호가 실시간 스트리밍 데이터를 요청한다.</Comment>
        procedure SubscribeBidOffer(ADataDelivery:CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String); override;

        ///<Comment>호가 실시간 스트리밍 데이터를 해지한다.</Comment>
        procedure UnsubscribeBidOffer(ADataDelivery:CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String); override;

        ///<Comment>주문체결통보 실시간 스트리밍 데이터를 요청한다.</Comment>
        procedure SubscribeUserTrade(ADataDelivery:CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = ''); override;

        ///<Comment>주문체결통보 실시간 스트리밍 데이터를 요청한다.</Comment>
        procedure UnsubscribeUserTrade(ADataDelivery:CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = ''); override;

        procedure ReSubscribeAll; override;

    private
        ///<Comment>우리선물 연결  OCX</Comment>
        m_Agent:TWRAX;
        m_H5MgrEx: TH5MgrEx;
        m_AgentLock:TCriticalSection;

        procedure ProcessFMX(AType: Integer; pBytes: Integer; nBytes: Integer);
        procedure ProcessOrder(AType: Integer; pBytes: Integer; nBytes: Integer);
        procedure ProcessDeal(AType: Integer; pBytes: Integer; nBytes: Integer);

        procedure ParseDealData(AData:String; ARecord : CIORecord);

    private
        procedure SC_ACCOUNT_TR_0010(p_QueryData: CFNQueryData);

        ///<Comment>선물시세 조회 패킷을 만들어서 Agent에 전달한다.</Comment>
        procedure SC_QUOTE_TR_0210(p_QueryData:CFNQueryData);

        ///<Comment>선물주문 패킷을 만들어서 Agent에 전달한다.</Comment>
        procedure SC_ORDER_TR_0210(p_QueryData:CFNQueryData);

        ///<Comment>패킷중 에러코드와 메세지를 추가하는 부분</Comment>
        procedure WriteMessage(p_QueryData: CFNQueryData; sErrorCode, sMsg: WideString);

        ///<Comment>패킷중 에러코드와 메세지를 추가하는 부분</Comment>
        procedure WriteError(p_QueryData: CFNQueryData; sErrorCode:WideString);

        procedure MakeDefaultResponse(p_QueryData:CFNQueryData);

    {$REGION '주문을 순차적으로 하나씩 처리하기 위한 변수'}
    private
        m_OrderBusy : Boolean;
        m_OrderBusyTime : TDateTime;
        m_OrderLock : TCriticalSection;

        procedure SetOrderBusy(AValue:Boolean);
        function GetOrderBusy:Boolean;
        function GetOrderBusyTime:TDateTime;
    {$ENDREGION}

    {$REGION '우리선물 조회순번'}
    private
        m_RQIndex : Integer;
        m_RQLock : TCriticalSection;
        function GetRQIndex : Integer;
    {$ENDREGION}

    {$REGION '우리선물 실시간 등록을 위해 필요한 변수와 함수들'}
    private
          m_RegistRealTableLock : TCriticalSection;
        m_RegistRealTable : Array[0..MAX_MAPCOUNT-1] of THashedStringList;

        procedure SetSBID(AMapType: Integer; AKey: String; AValue: Integer);
        procedure ClearSBID(AMapType:Integer; AKey:String);
        function  GetSBID(AMapType:Integer; AKey:String):Integer;
    {$ENDREGION}

    {$REGION '우리선물 수신된 데이터를 분석하기 위한 객체'}
    private
        m_IOHandler_FZQ12010_OUT : CFNIOHandler;
        m_IODataSet_SB_FUT_EXEC : CIODataSet;

    private
        ///<Comment>각종 실시간 데이터의 구조를 분석할 때 사용한다.</Comment>
        m_DataStream : TMemoryStream;
        m_StringStream : TStringStream;
    {$ENDREGION}

    {$REGION '수신한 실시간데이터 전달을 위한 변수와 함수들'}
    private
        m_StreamDataQueue:CFNQueue;

          procedure StoreStreamData(p_Data:CFNStreamRecord);
          function RetrieveStreamData:CFNStreamRecord;
        procedure ClearStreamData;
        procedure DoStreamDataWork;
    {$ENDREGION}

    private
        procedure OnTimeout(p_QueryData:CFNQueryData);

    private
        procedure OnWRRecvData(ASender: TObject; DataType: Smallint; const TrCode: WideString; RqID: Smallint; DataSize: Integer; var szData: WideString);
        procedure OnWRRecvRealData(ASender: TObject; const TrCode: WideString; const KeyValue: WideString; RealID: Smallint; DataSize: Integer; const szData: WideString);
        procedure OnWRNetConnected(ASender: TObject);
        procedure OnWRNetDisconnected(ASender: TObject);

        procedure Process_SB_FUT_EXEC(AKeyValue: WideString; ARealID: Smallint; ADataStream : TMemoryStream);

        procedure OnH5Receive(ASender: TObject; type_: Integer; pBytes: Integer; nBytes: Integer);

    private
        m_NewTime:TDateTime;
        m_OldTime:TDateTime;

        m_NewTime2:TDateTime;
        m_OldTime2:TDateTime;

        m_RQTimer:TTimer;
        procedure OnTiemr(Sender: TObject);
    end;

    procedure H5_WriteInteger(ATarget:PAnsiChar; AValue: Integer; ASize: Integer);
    procedure H5_WriteDouble(ATarget:PAnsiChar; AValue: Double; ASize: Integer; APrecision: Integer);
    procedure H5_WriteString(ATarget:PAnsiChar; AValue: String; ASize: Integer);

    function H5_ReadInteger(AValue: PAnsiChar; ASize: Integer):Integer;
    function H5_ReadDouble(AValue: PAnsiChar; ASize: Integer; APrecision: Integer):Double;
    function H5_ReadString(AValue: PAnsiChar; ASize: Integer):String;
var
    g_PowerBasePath : String;

implementation

uses
    Dialogs, FNGlobal, FNGlobalVariable, WideStrUtils, CommonTRMaker, FNTradeSystem, FNCMVariable, MXVariable, WRIOMaker,
    FNAccountArray, FNAccountData, FNPOTCollection, DateUtils, H5MGREXLib_Const;

//---------------------------------------------------------------------------
procedure H5_WriteInteger(ATarget:PAnsiChar; AValue: Integer; ASize: Integer);
var
    f_Source:String;
    f_Index:Integer;
begin
    f_Source := Format('%*d', [ASize, AValue]);
    for f_Index := 1 to Length(f_Source) do
    begin
        if f_Source[f_Index] = ' ' then f_Source[f_Index] := '0'
        else if f_Source[f_Index] = '-' then continue
        else break;
    end;
    TFNGlobal.memcpy(ATarget, PAnsiChar(AnsiString(f_Source)), ASize);
end;

//---------------------------------------------------------------------------
procedure H5_WriteDouble(ATarget:PAnsiChar; AValue: Double; ASize: Integer; APrecision: Integer);
begin
    H5_WriteInteger(ATarget, Round(AValue * Power(10, APrecision)), ASize);
end;

//---------------------------------------------------------------------------
procedure H5_WriteString(ATarget:PAnsiChar; AValue: String; ASize: Integer);
var
    f_Source:String;
begin
    f_Source := Format ('%-*s', [ASize, AValue]);
    TFNGlobal.memcpy(ATarget, PAnsiChar(AnsiString(f_Source)), ASize);
end;

//---------------------------------------------------------------------------
function H5_ReadDouble(AValue: PAnsiChar; ASize: Integer; APrecision: Integer):Double;
var
    f_Source : String;
begin
    f_Source := H5_ReadString(AValue, ASize);
    Result := TFNGlobal.atof(f_Source) / Power(10, APrecision);
end;

//---------------------------------------------------------------------------
function H5_ReadInteger(AValue: PAnsiChar; ASize: Integer):Integer;
var
    f_Source : String;
begin
    f_Source := H5_ReadString(AValue, ASize);
    Result := TFNGlobal.atoi(f_Source);
end;

//---------------------------------------------------------------------------
function H5_ReadString(AValue: PAnsiChar; ASize: Integer):String;
var
    f_Buffer : PAnsiChar;
    f_Source : String;
begin
    f_Buffer := AllocMem(ASize + 1);
    FillChar(f_Buffer^, ASize + 1, $0);
    StrPLCopy(f_Buffer, AValue, ASize);
    Result := f_Buffer;
    FreeMem(f_Buffer);
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.AssignAgent(p_Agent: TWRAX);
begin
    if Assigned(m_Agent) then
    begin
        m_Agent.OnRecvData := NIL;
        m_Agent.OnRecvRealData := NIL;
        m_Agent.OnNetConnected := NIL;
        m_Agent.OnNetDisconnected := NIL;
    end;

    m_Agent := p_Agent;

    if Assigned(m_Agent) then
    begin
        m_Agent.OnRecvData := OnWRRecvData;
        m_Agent.OnRecvRealData := OnWRRecvRealData;
        m_Agent.OnNetConnected := OnWRNetConnected;
        m_Agent.OnNetDisconnected := OnWRNetDisconnected;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.AssignH5Agent(p_Agent: TH5MgrEx);
begin;
    if Assigned(m_H5MgrEx) then
    begin
        m_H5MgrEx.OnReceive := NIL;
    end;

    m_H5MgrEx := p_Agent;

    if Assigned(m_H5MgrEx) then
    begin
        m_H5MgrEx.OnReceive := OnH5Receive;
    end;
end;
//---------------------------------------------------------------------------
procedure CFNHNAgentManager.SubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
    f_SBID:Integer;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := MakeStreamSubscribeKey(ACountry, AGroup, AMarket, ASymbol);
    if m_STSubscribeTable[MAP_CURRENT].AddKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        f_SBID := m_Agent.RegistRealData('SB_FUT_EXEC', ASymbol);
        SetSBID(MAP_CURRENT, f_SubscribeKey, f_SBID);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.SubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
    f_SBID:Integer;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := MakeStreamSubscribeKey(ACountry, AGroup, AMarket, ASymbol);
    if m_STSubscribeTable[MAP_BIDOFFER].AddKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        f_SBID := m_Agent.RegistRealData('SB_FUT_HOGA', ASymbol);
        SetSBID(MAP_BIDOFFER, f_SubscribeKey, f_SBID);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.SubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = '');
begin
    if not Assigned(m_Agent) then exit;
    if m_STSubscribeTable[MAP_USERTRADE].AddKeyValue(AAccountNO, ADataDelivery) then
    begin
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.UnsubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
    f_SBID:Integer;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := MakeStreamSubscribeKey(ACountry, AGroup, AMarket, ASymbol);

    if m_STSubscribeTable[MAP_CURRENT].DeleteKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        f_SBID := GetSBID(MAP_CURRENT, f_SubscribeKey);
        if f_SBID <> -1 then m_Agent.UnregistRealData(f_SBID);
        ClearSBID(MAP_CURRENT, f_SubscribeKey);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.UnsubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
    f_SBID:Integer;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := MakeStreamSubscribeKey(ACountry, AGroup, AMarket, ASymbol);

    if m_STSubscribeTable[MAP_BIDOFFER].DeleteKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        f_SBID := GetSBID(MAP_BIDOFFER, f_SubscribeKey);
        if f_SBID <> -1 then m_Agent.UnregistRealData(f_SBID);
        ClearSBID(MAP_CURRENT, f_SubscribeKey);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.UnsubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = '');
begin
    if not Assigned(m_Agent) then exit;
    if m_STSubscribeTable[MAP_USERTRADE].DeleteKeyValue(AAccountNO, ADataDelivery) then
    begin
    end;
end;

{$REGION '주문동기화'}
//---------------------------------------------------------------------------
procedure CFNHNAgentManager.SetOrderBusy(AValue:Boolean);
begin
    m_OrderLock.Enter;
    try
        m_OrderBusy := AValue;
        if m_OrderBusy then m_OrderBusyTime := Now;
    finally

    end;
    m_OrderLock.Leave;
end;

//---------------------------------------------------------------------------
function CFNHNAgentManager.GetOrderBusy:Boolean;
var
    f_Value:Boolean;
begin
    m_OrderLock.Enter;
    try
        f_Value := m_OrderBusy;
    finally

    end;
    m_OrderLock.Leave;

    result := f_Value;
end;

//---------------------------------------------------------------------------
function CFNHNAgentManager.GetOrderBusyTime:TDateTime;
var
    f_Value:TDateTime;
begin
    m_OrderLock.Enter;
    try
        f_Value := m_OrderBusyTime;
    finally

    end;
    m_OrderLock.Leave;

    result := f_Value;
end;

//---------------------------------------------------------------------------
// 조회데이터의 전달할 CFNDelivery객체를 저장할 인덱스 m_RQSubscribeIndex를 가져온다. 이 후에 이값을 1 증가시킨다.
// 배열의 크기가 1024이므로 m_RQSubscribeIndex의 값이 1024보다 크거나 같으면 0으로 초기화 한다.
function CFNHNAgentManager.GetRQIndex : Integer;
begin
    m_RQLock.Enter;
    try
        Result := m_RQIndex;
        Inc(m_RQIndex);
        if TR_ORDER_END < m_RQIndex then m_RQIndex := TR_ORDER_START;
    finally
        m_RQLock.Leave;
    end;
end;
{$ENDREGION}

{$REGION '실시간데이터 전달을 위한 함수들'}
//---------------------------------------------------------------------------
procedure CFNHNAgentManager.StoreStreamData(p_Data: CFNStreamRecord);
begin
    if Assigned(p_Data) then
    begin
        m_StreamDataQueue.Store(p_Data);
    end;
end;

//---------------------------------------------------------------------------
function CFNHNAgentManager.RetrieveStreamData: CFNStreamRecord;
var
    f_Data:CFNStreamRecord;
begin
    f_Data := NIL;

    if Assigned(m_StreamDataQueue) then
    begin
        f_Data := CFNStreamRecord(m_StreamDataQueue.Retrieve);
    end;

    Result := f_Data;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.ClearStreamData;
var
    f_Data:CFNStreamRecord ;
begin
    while 0 < m_StreamDataQueue.GetCount do
    begin
        f_Data := CFNStreamRecord(m_StreamDataQueue.Retrieve);
        if Assigned(f_Data) then
        begin
            f_Data.Free;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.DoStreamDataWork;
var
    f_StreamData:CFNStreamRecord;
    f_SendStreamData:CFNStreamRecord;
    f_SubscribeKey : String;
    f_ObjectList : TObjectList;

    f_Loop: Integer;
    f_DataDelivery : CFNDataDelivery;
begin
    while true do
    begin
        f_StreamData := RetrieveStreamData;
        if f_StreamData = NIL then
        begin
            break;
        end else
        begin
            try
                if f_StreamData.GetPacketKey = 'QUOTE' then
                begin
                    f_SubscribeKey := MakeStreamSubscribeKey(
                        f_StreamData.GetIntegerValue('COUNTRY_NO'),
                        f_StreamData.GetIntegerValue('GROUP_NO'),
                        f_StreamData.GetIntegerValue('MARKET_NO'),
                        f_StreamData.GetStringValue ('SYMBOL')
                    );

                    m_STSubscribeTableLock.Enter;
                    try
                        f_ObjectList := m_STSubscribeTable[MAP_CURRENT].GetKey(f_SubscribeKey);
                    finally
                        m_STSubscribeTableLock.Leave;
                    end;

                    if Assigned(f_ObjectList) then
                    begin
                        for f_Loop := 0 to f_ObjectList.Count - 1 do
                        begin
                            f_DataDelivery := CFNDataDelivery(f_ObjectList.Items[f_Loop]);
                            if Assigned(f_DataDelivery) then
                            begin
                                f_StreamData.IncreaseReferenceCount;
                                try
                                    f_DataDelivery.DeliveryStream(f_StreamData);
                                except
                                    f_StreamData.DecreaseReferenceCount;
                                end;
                            end;
                        end;
                        SaveStreamRecord(f_StreamData);

                        f_ObjectList.Clear;
                        f_ObjectList.Free;
                        f_ObjectList := NIL;
                    end else
                    begin
                        f_StreamData.Free;
                        f_StreamData := NIL;
                    end;
                end else
                if
                    (f_StreamData.GetPacketKey = 'ORDER_RECEIVE') OR
                    (f_StreamData.GetPacketKey = 'ORDER_CONFIRM') OR
                    (f_StreamData.GetPacketKey = 'ORDER_TRADE') OR
                    (f_StreamData.GetPacketKey = 'ORDER_REJECT')
                then
                begin
                    f_SubscribeKey := f_StreamData.GetStringValue('ACCOUNT_NO');

                    m_STSubscribeTableLock.Enter;
                    try
                        f_ObjectList := m_STSubscribeTable[MAP_USERTRADE].GetKey(f_SubscribeKey);
                    finally
                        m_STSubscribeTableLock.Leave;
                    end;

                    if Assigned(f_ObjectList) then
                    begin
                        for f_Loop := 0 to f_ObjectList.Count - 1 do
                        begin
                            f_DataDelivery := CFNDataDelivery(f_ObjectList.Items[f_Loop]);
                            if Assigned(f_DataDelivery) then
                            begin
                                f_SendStreamData := CFNStreamRecord.Create;
                                f_SendStreamData.CloneStreamRecord(f_StreamData);
                                try
                                    f_DataDelivery.DeliveryStream(f_SendStreamData);
                                except
                                    f_SendStreamData.Free;
                                end;
                            end;
                        end;
                        f_StreamData.Free;
                        f_StreamData := NIL;

                        f_ObjectList.Clear;
                        f_ObjectList.Free;
                        f_ObjectList := NIL;
                    end else
                    begin
                        f_StreamData.Free;
                        f_StreamData := NIL;
                    end;
                end;
            finally

            end;
        end;
    end;
end;
{$ENDREGION}

//---------------------------------------------------------------------------
Constructor CFNHNAgentManager.Create(AQueryThreadCount:Integer = 1);
begin
    inherited Create(AQueryThreadCount);

    m_DataStream := TMemoryStream.Create;
    m_StringStream := TStringStream.Create;

    m_RegistRealTable[0] := THashedStringList.Create;
    m_RegistRealTable[1] := THashedStringList.Create;
    m_RegistRealTable[2] := THashedStringList.Create;

    m_RegistRealTableLock := TCriticalSection.Create;

    m_IODataSet_SB_FUT_EXEC := Make_SB_FUT_EXEC(NIL);
    m_IOHandler_FZQ12010_OUT := Make_FZQ12010_OUT(NIL);

    m_RQIndex := TR_ORDER_START;

    m_StreamDataQueue := CFNQueue.Create;

    m_OrderBusy := false;
    m_OrderLock := TCriticalSection.Create;

    m_AgentLock := TCriticalSection.Create;
    m_RQLock := TCriticalSection.Create;

    m_NewTime := Now;
    m_OldTime := m_NewTime;
    m_NewTime2 := Now;
    m_OldTime2 := m_NewTime;

    m_RQTimer := TTimer.Create(NIL);
    m_RQTimer.Enabled := true;
    m_RQTimer.OnTimer := OnTiemr;
    m_RQTimer.Interval := 10;
end;

//---------------------------------------------------------------------------
Destructor CFNHNAgentManager.Destroy;
begin
    m_DataStream.Free;
    m_StringStream.Free;

    if (m_RegistRealTable[0] <> NIL) then m_RegistRealTable[0].Free;
    m_RegistRealTable[0] := NIL;

    if (m_RegistRealTable[1] <> NIL) then m_RegistRealTable[1].Free;
    m_RegistRealTable[1] := NIL;

    if (m_RegistRealTable[2] <> NIL) then m_RegistRealTable[2].Free;
    m_RegistRealTable[2] := NIL;

    if (m_RegistRealTableLock <> NIL) then m_RegistRealTableLock.Free;
    m_RegistRealTableLock := NIL;

    m_IODataSet_SB_FUT_EXEC.Free;
    m_IOHandler_FZQ12010_OUT.Free;

    if Assigned(m_RQTimer) then
    begin
        m_RQTimer.OnTimer := NIL;
        m_RQTimer.Enabled := false;
        m_RQTimer.Free;
        m_RQTimer := NIL;
    end;

    ClearStreamData;
    if (m_StreamDataQueue <> NIL) then m_StreamDataQueue.Free;
    m_StreamDataQueue := NIL;

    m_AgentLock.Free;
    m_RQLock.Free;

    m_StreamDataQueue.Free;

    inherited Destroy;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.OnTiemr(Sender: TObject);
var
    f_QueryData:CFNQueryData;
    f_OpenDateTime:TDateTime;
    f_CloseDateTime:TDateTime;
    f_Time1:TDateTime;
    f_Year,f_Month,f_Day,f_Hour,f_Min,f_Sec,f_MSec:Word;
begin
    m_RQTimer.Enabled := false;
    try
        m_NewTime := Now;

        m_OldTime := m_NewTime;

        DoStreamDataWork;

        f_QueryData := RetrieveSendData;

        if not Assigned(f_QueryData) then exit;

        if f_QueryData.m_ServiceID = 'SC_ACCOUNT' then
        begin
            //  계좌 마스트
            if (f_QueryData.m_TRCode = 'TR_0010') then
            begin
                SC_ACCOUNT_TR_0010(f_QueryData);
            end else
            begin
                WriteError(f_QueryData, 'M10001');
                StoreRecvData(f_QueryData);
            end;
            //Sleep(200);
        end else
        if f_QueryData.m_ServiceID = 'SC_QUOTE' then
        begin
            //  선물 시세
            if (f_QueryData.m_TRCode = 'TR_0210') then
            begin
                SC_QUOTE_TR_0210(f_QueryData);
            end else
            begin
                WriteError(f_QueryData, 'M10001');
                StoreRecvData(f_QueryData);
            end;
            //Sleep(1000);
        end else
        if f_QueryData.m_ServiceID = 'SC_ORDER' then
        begin
            //  선물 주문
            if (f_QueryData.m_TRCode = 'TR_0210') then
            begin
                (*
                while GetOrderBusy do
                begin
                    Sleep(100);
                    if ((Now - GetOrderBusyTime) * 86400000.0 > 5000) then
                    begin
                        SetOrderBusy(false);
                    end;
                end;
                *)
                SetOrderBusy(true);

                SC_ORDER_TR_0210(f_QueryData);
            end else
            begin
                WriteError(f_QueryData, 'M10001');
                StoreRecvData(f_QueryData);
            end;
            //Sleep(200);
        end else
        begin
            WriteError(f_QueryData, 'M10001');
            StoreRecvData(f_QueryData);
        end;

        DoCheckTimeout

    finally
        m_RQTimer.Enabled := true;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.DoQueryWork(AThreadIndex:Integer);
begin
    m_NewTime2 := Now;

    if (Trunc(m_NewTime2 * 86400) <> Trunc(m_OldTime2 * 86400)) then
    begin

    end;

    m_OldTime2 := m_NewTime2;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.DoCheckTimeout;
var
    f_Index:Integer;
    f_QueryData:CFNQueryData;
    f_CheckTime : TDateTime;
    f_Done : Boolean;
begin
    f_CheckTime := Now;
    f_QueryData := NIL;
    m_QueryTableLock.Enter;
    try
        f_Done := false;
        while not f_Done do
        begin
            f_Done := true;
            for f_Index := 0 to m_QueryTable.Count - 1 do
            begin
                f_QueryData := CFNQueryData(m_QueryTable.Objects[f_Index]);

                if (f_CheckTime - f_QueryData.m_DateTime) * 86400 > 5 then
                begin
                        LOG_WRITE(LOG_TYPE_INFO, 'CFNWRAgentManager',
                            '요청타임아웃처리; '    +
                            'ServiceID:'            +   f_QueryData.m_ServiceID + '; ' +
                            'TRCode:'               +   f_QueryData.m_TRCode + '; ' +
                            'Time"'                 +   IntToStr(Trunc((f_CheckTime - f_QueryData.m_DateTime) * 86400))
                            );
                    m_QueryTable.Delete(f_Index);
                    OnTimeout(f_QueryData);
                    f_Done := false;
                    break;
                end;
            end;
        end;
    finally
        m_QueryTableLock.Leave;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.WriteMessage(p_QueryData: CFNQueryData; sErrorCode, sMsg: WideString);
var
    rd : CFNRecord;
begin
    if sErrorCode = 'M00000' then
    begin
        p_QueryData.m_Response.SetMsgCode(sErrorCode);
        p_QueryData.m_Response.SetErrorCode('E00000');
        rd := CFNRecord.Create;
        rd.SetStringValue('MESSAGE_CODE', sErrorCode);
        rd.SetStringValue('MESSAGE', sMsg);
        p_QueryData.m_Response.m_MessageDataSet.RecordList.Add(rd);
    end else
    if sErrorCode = 'M99999' then
    begin
        p_QueryData.m_Response.SetMsgCode(sErrorCode);
        rd := CFNRecord.Create;
        rd.SetStringValue('MESSAGE_CODE', sErrorCode);
        rd.SetStringValue('MESSAGE', sMsg);
        p_QueryData.m_Response.m_MessageDataSet.RecordList.Add(rd);
    end else
    begin
        p_QueryData.m_Response.SetErrorCode(sErrorCode);
        rd := CFNRecord.Create;
        rd.SetStringValue('ERROR_CODE', sErrorCode);
        rd.SetStringValue('MESSAGE', sMsg);
        p_QueryData.m_Response.m_ErrorDataSet.RecordList.Add(rd);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.WriteError(p_QueryData: CFNQueryData; sErrorCode:WideString);
var
    rd : CFNRecord;
begin
    p_QueryData.m_Response.SetErrorCode(sErrorCode);
    rd := CFNRecord.Create;
    rd.SetStringValue('ERROR_CODE', sErrorCode);

    if sErrorCode = 'M10001' then
    begin
        rd.SetStringValue('MESSAGE', '해당 TR이 존재하지 않습니다.');
    end else if sErrorCode = 'M10002' then
    begin
        rd.SetStringValue('MESSAGE', '입력레코드가 존재하지 않습니다.');
    end else if sErrorCode = 'M10003' then
    begin
        rd.SetStringValue('MESSAGE', '입력데이터셋이 존재하지 않습니다.');
    end else if sErrorCode = 'M30001' then
    begin
        rd.SetStringValue('MESSAGE', '주문 전달에 오류가 발생했습니다.');
    end else if sErrorCode = 'M60001' then
    begin
        rd.SetStringValue('MESSAGE', '오류가 발생했습니다.');
    end;

    p_QueryData.m_Response.m_ErrorDataSet.RecordList.Add(rd);
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.SC_ORDER_TR_0210(p_QueryData: CFNQueryData);
var
    f_DataSet           :   CFNDataSet;
    f_Record            :   CFNRecord;
    f_AccountNo         :   String;
    f_Password          :   String;
    f_Symbol            :   String;
    f_OrderCommand      :   Integer;
    f_OrderVolume       :   Integer;
    f_OrderPrice        :   Double;
    f_nBuySell          :   Integer;
    f_nDataType         :   Integer;
    f_sPriceType        :   String;

    f_RQID              :   Integer;

    f_Buffer : Array [0..MAX_BUFFER-1] of AnsiChar;

    f_RQHead        :   TH5RQHead;
    f_pRQHead       :   pTH5RQHead;
    f_PIBOFODR      :   TPIBOFODR;
    f_pPIBOFODR     :   pTPIBOFODR;
    f_DataSize      :   Integer;

    f_ResultValue   :   Integer;
begin
    FillChar(f_Buffer, MAX_BUFFER, $20);
    f_pRQHead   := pTH5RQHead(Addr(f_Buffer[0]));
    f_pPIBOFODR := pTPIBOFODR(Addr(f_Buffer[sizeof(TH5RQHead)]));
    f_DataSize := sizeof(TH5RQHead) + sizeof(TPIBOFODR);

    f_RQID := GetRQIndex;
    f_pRQHead.key[0] := AnsiChar(f_RQID);
    f_pRQHead.stat[0] := AnsiChar(US_CA or US_ENC);
    f_pRQHead.bizH[0] := '1';
    TFNGlobal.memcpy(f_pRQHead.bizK, '@00004', 6);
    TFNGlobal.memcpy(f_pRQHead.trx_Name, 'pibofodr', sizeof(f_pRQHead.trx_Name));

    try
        f_DataSet := p_QueryData.m_Request.GetDataSet(DATASETID_IN_01);
        if Assigned(f_DataSet) then
        begin
            if (0 < f_DataSet.RecordList.Count) then
            begin
                f_Record := CFNRecord(f_DataSet.RecordList.Items[0]);
                f_AccountNo     := f_Record.GetStringValue  ('ACCOUNT_NO');             //  계좌번호
                f_Password      := f_Record.GetStringValue  ('PASSWORD');               //  계좌비번
                f_Symbol        := f_Record.GetStringValue  ('SYMBOL');                 //  종목코드
                f_OrderCommand  := f_Record.GetIntegerValue ('ORDER_COMMAND');          //  1 : 매도, 2 : 매수, 3 : 정정, 4 : 취소
                f_OrderVolume   := f_Record.GetIntegerValue ('ORDER_VOLUME');           //  주문량
                f_OrderPrice    := f_Record.GetDoubleValue  ('ORDER_PRICE');            //  주문가격
                f_sPriceType    := f_Record.GetStringValue  ('PRICETYPE');              //  '01' : 지정가, '02' : 시장가
                f_nDataType     := f_Record.GetIntegerValue ('DATATYPE');               //  1 : 신규, 2 : 정정, 3 : 취소
                f_nBuySell      := f_Record.GetIntegerValue ('BUYSELL');                //  1 : BUY, 2 : SELL

                LOG_WRITE(LOG_TYPE_INFO, 'CFNHNAgentManager',
                '주문전송; ' +
                '사용자:'           +   f_Record.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_Record.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_Record.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_Record.GetIntegerValue('DATATYPE'))  + '; ' +
                '매매구분:'         +   f_Record.GetStringValue('ORDER_COMMAND')        + '; ' +
                '주문량:'           +   IntToStr(f_Record.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_Record.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                '주문번호:'         +   f_Record.GetStringValue('ORDER_NO')             + '; ' +
                '원주문번호:'       +   f_Record.GetStringValue('ORG_ORDER_NO')         + '; ' +
                '블록명:'           +   f_Record.GetStringValue('BLOCK_NAME')           + '; ' +
                '신호순번:'         +   f_Record.GetStringValue('SIGNAL_SEQ')
                );

                if (f_OrderCommand = 1) or (f_OrderCommand = 2) then
                begin
                    //  주문유형
                    H5_WriteInteger(f_pPIBOFODR.rcnt, 1, sizeof(f_pPIBOFODR.rcnt));

                    //  주문유형
                    H5_WriteString (f_pPIBOFODR.odgb, '2', sizeof(f_pPIBOFODR.odgb));

                    //  시장구분
                    H5_WriteString (f_pPIBOFODR.mkgb, '1', sizeof(f_pPIBOFODR.mkgb));

                    //  매매구분
                    H5_WriteString (f_pPIBOFODR.mmgb, IntToStr(f_OrderCommand), sizeof(f_pPIBOFODR.mmgb));

                    //  계좌번호
                    H5_WriteString (f_pPIBOFODR.acno, f_AccountNo, sizeof(f_pPIBOFODR.acno));

                    //  비밀번호
                    H5_WriteString (f_pPIBOFODR.pswd, m_H5MgrEx.GetEncript(f_Password, f_AccountNo, 0), sizeof(f_pPIBOFODR.pswd));

                    //  원주문번호	정정/취소 주문시 (예약주문 취소시 취소주문번호)
                    //H5_WriteInteger (f_pPIBOFODR.ogno, atoi(f_Record.GetStringValue('ORG_ORDER_NO')), sizeof(f_pPIBOFODR.ogno));

                    //  종목코드	단축코드 * 장내채권시 표준코드
                    H5_WriteString (f_pPIBOFODR.code, f_Symbol, sizeof(f_pPIBOFODR.code));

                    //  주문수량
                    H5_WriteInteger(f_pPIBOFODR.jqty, f_OrderVolume, sizeof(f_pPIBOFODR.jqty));

                    //  주문단가	선물옵션의 경우 100배수 처리 [ex] 112.13  -> 11213
                    H5_WriteDouble (f_pPIBOFODR.jprc, f_OrderPrice, sizeof(f_pPIBOFODR.jprc), 2);

                    //  호가구분    00: 지정가 03: 시장가
                    if f_sPriceType = '01' then
                    begin
                        H5_WriteString(f_pPIBOFODR.hogb, '00', sizeof(f_pPIBOFODR.hogb));
                    end else
                    begin
                        H5_WriteString(f_pPIBOFODR.hogb, '03', sizeof(f_pPIBOFODR.hogb));
                    end;

                    p_QueryData.m_RequestID := IntToStr(f_RQID);

                    p_QueryData.m_DateTime := Now;
                    p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
                    p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);
                    SetRQTable(p_QueryData.m_RequestID, p_QueryData);

                    m_AgentLock.Enter;
                    try
		                f_ResultValue := m_H5MgrEx.HFCommand(hf_QUERYTR, Integer(Addr(f_Buffer[0])), f_DataSize);
                    finally
                        m_AgentLock.Leave;
                    end;

                end else
                if (f_OrderCommand = 3) or (f_OrderCommand = 4) then
                begin

                    //  주문유형
                    H5_WriteInteger(f_pPIBOFODR.rcnt, 1, sizeof(f_pPIBOFODR.rcnt));

                    //  주문유형
                    H5_WriteString (f_pPIBOFODR.odgb, '2', sizeof(f_pPIBOFODR.odgb));

                    //  시장구분
                    H5_WriteString (f_pPIBOFODR.mkgb, '1', sizeof(f_pPIBOFODR.mkgb));

                    //  매매구분
                    H5_WriteString (f_pPIBOFODR.mmgb, IntToStr(f_OrderCommand), sizeof(f_pPIBOFODR.mmgb));

                    //  계좌번호
                    H5_WriteString (f_pPIBOFODR.acno, f_AccountNo, sizeof(f_pPIBOFODR.acno));

                    //  비밀번호
                    H5_WriteString (f_pPIBOFODR.pswd, m_H5MgrEx.GetEncript(f_Password, f_AccountNo, 0), sizeof(f_pPIBOFODR.pswd));

                    //  원주문번호	정정/취소 주문시 (예약주문 취소시 취소주문번호)
                    H5_WriteInteger (f_pPIBOFODR.ogno, TFNGlobal.atoi(f_Record.GetStringValue('ORG_ORDER_NO')), sizeof(f_pPIBOFODR.ogno));

                    //  종목코드	단축코드 * 장내채권시 표준코드
                    H5_WriteString (f_pPIBOFODR.code, f_Symbol, sizeof(f_pPIBOFODR.code));

                    //  주문수량
                    H5_WriteInteger(f_pPIBOFODR.jqty, f_OrderVolume, sizeof(f_pPIBOFODR.jqty));

                    //  주문단가	선물옵션의 경우 100배수 처리 [ex] 112.13  -> 11213
                    H5_WriteDouble (f_pPIBOFODR.jprc, f_OrderPrice, sizeof(f_pPIBOFODR.jprc), 2);

                    //  호가구분    00: 지정가 03: 시장가
                    if f_sPriceType = '01' then
                    begin
                        H5_WriteString(f_pPIBOFODR.hogb, '00', sizeof(f_pPIBOFODR.hogb));
                    end else
                    begin
                        H5_WriteString(f_pPIBOFODR.hogb, '03', sizeof(f_pPIBOFODR.hogb));
                    end;

                    //    정정취소	1: 일부 2: 전부
                    H5_WriteString(f_pPIBOFODR.mdgb, '1', sizeof(f_pPIBOFODR.mdgb));

                    p_QueryData.m_RequestID := IntToStr(f_RQID);
                    p_QueryData.m_DateTime := Now;
                    p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
                    p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);
                    SetRQTable(p_QueryData.m_RequestID, p_QueryData);

                    m_AgentLock.Enter;
                    try
		                f_ResultValue := m_H5MgrEx.HFCommand(hf_QUERYTR, Integer(Addr(f_Buffer[0])), f_DataSize);
                    finally
                        m_AgentLock.Leave;
                    end;
                end;

                if 0 = f_ResultValue then
                begin
                    p_QueryData := NIL;
                end else
                begin
                    ClearRQTable(p_QueryData.m_RequestID);
                    MakeDefaultResponse(p_QueryData);

                    WriteMessage(p_QueryData, 'M99999', '주문전송시 오류가 발생했습니다.');
                    WriteError(p_QueryData, 'M30001');
                    StoreRecvData(p_QueryData);
                    p_QueryData := NIL;
                end;
            end else
            begin
                WriteMessage(p_QueryData, 'M99999', '오류가 발생했습니다.');
                WriteError(p_QueryData, 'M10002');
                StoreRecvData(p_QueryData);
                p_QueryData := NIL;
            end;
        end else
        begin
            WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
            WriteError(p_QueryData, 'M10003');
            StoreRecvData(p_QueryData);
            p_QueryData := NIL;
        end;
    finally
        if p_QueryData <> NIL then p_QueryData.Free;
    end;

end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.SC_QUOTE_TR_0210(p_QueryData: CFNQueryData);
var
    f_InDataSet:CFNDataSet;
    f_InRecord:CFNRecord;
    f_Symbol:String;
    f_IORecord:CFNIORecord;
    f_IOHandler:CFNIOHandler;
    f_SendStream:TStringStream;
    f_RQID:Integer;
    f_DataString:String;
    f_DataSize:Integer;
begin
    try
        f_InDataSet := p_QueryData.m_Request.GetDataSet(DATASETID_IN_01);
        if Assigned(f_InDataSet) then
        begin
            if (0 < f_InDataSet.RecordList.Count) then
            begin
                f_SendStream := TStringStream.Create;
                try
                    f_InRecord  := CFNRecord(f_InDataSet.RecordList.Items[0]);
                    f_Symbol    := f_InRecord.GetStringValue('SYMBOL');

                    f_IORecord := CFNIORecord.Create;
                    f_IORecord.SetStringValue('SYMBOL', f_Symbol);
                    f_IOHandler := Make_FZQ12010_IN(NIL, f_IORecord);
                    f_IOHandler.EncodeData(f_SendStream);
                    f_IOHandler.Free;
                    //

                    f_SendStream.Position := 0;
                    f_DataSize := f_SendStream.Size;
                    f_DataString := f_SendStream.ReadString(f_DataSize);

                    f_RQID := m_Agent.RequestData('FZQ12010', f_DataSize, f_DataString, 1, 0, 60);

                    p_QueryData.m_RequestID := IntToStr(f_RQID);
                    p_QueryData.m_DateTime := Now;

                    p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
                    p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);
                    SetRQTable(p_QueryData.m_RequestID, p_QueryData);
                finally
                    f_SendStream.Free;
                end;
                p_QueryData := NIL;
            end else
            begin
                WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
                WriteError(p_QueryData, 'M10002');
                StoreRecvData(p_QueryData);
                p_QueryData := NIL;
                //  응답패킷에 에러를 리턴하여 예외처리 해야 됨
            end;
        end else
        begin
            WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
            WriteError(p_QueryData, 'M10003');
            StoreRecvData(p_QueryData);
            p_QueryData := NIL;
            //  응답패킷에 에러를 리턴하여 예외처리 해야 됨
        end;
    finally
        if p_QueryData <> NIL then p_QueryData.Free;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.SC_ACCOUNT_TR_0010(p_QueryData: CFNQueryData);
var
    F: TextFile;
    S: string;
    f_AccountNo:String;
    f_AccountName:String;
    f_OutDataSet:CFNDataSet;
    f_OutRecord:CFNRecord;
    f_Success:Boolean;
    f_FieldList:TStringList;
begin
    Make_SC_ACCOUNT_TR_0010_OUT(p_QueryData.m_Response);
    f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);

    f_FieldList := TStringList.Create();
    f_Success := true;
    try
        AssignFile(F, ExtractFilePath(ParamStr(0)) + 'account.dat');
        Reset(F);
        while not eof(F) do
        begin
            Readln(F, S);
            f_FieldList.Clear;
            ExtractStrings([':'], [], PChar(S), f_FieldList);

            if f_FieldList.Count >= 2 then
            begin
                f_AccountNo     := Trim(f_FieldList[0]);
                f_AccountName   := Trim(f_FieldList[1]);
            end else
            begin
                f_AccountNo     := Trim(f_FieldList[0]);
                f_AccountName   := '';
            end;
            f_OutRecord := CFNRecord.Create;
            f_OutRecord.SetStringValue('ACCOUNT_NO'     , f_AccountNo  );
            f_OutRecord.SetStringValue('ACCOUNT_NAME'   , f_AccountName);
            f_OutRecord.SetStringValue('SERIAL_NO'      , '');
            f_OutRecord.SetStringValue('CODE'           , '5A');
            f_OutDataSet.RecordList.Add(f_OutRecord);
        end;
        CloseFile(F);
    except
        f_Success := false;
    end;
    f_FieldList.Free;

    if f_Success then
    begin
        WriteMessage(p_QueryData, 'M00000', '정상처리 되었습니다.');
    end else
    begin
        WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
        WriteError(p_QueryData, 'M20001');
    end;

    StoreRecvData(p_QueryData);
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.MakeDefaultResponse(p_QueryData:CFNQueryData);
var
    f_OutDataSet : CFNDataSet;
    f_OutRecord : CFNRecord;
    f_InDataSet : CFNDataSet;
    f_InRecord : CFNRecord;
    f_FirstValue:Boolean;
begin
    if not Assigned(p_QueryData) then exit;

    {$REGION '선물주문'}
    if (p_QueryData.m_ServiceID = 'SC_ORDER') and (p_QueryData.m_TRCode = 'TR_0210') then
    begin
        try
            f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
            if not Assigned(f_OutDataSet) then
            begin
                Make_SC_ORDER_TR_0210_OUT(p_QueryData.m_Response);
                f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
            end;

            if f_OutDataSet.RecordList.Count <= 0 then
            begin
                f_OutRecord := CFNRecord.Create;
                f_OutDataSet.RecordList.Add(f_OutRecord);
                f_FirstValue := true;
            end else
            begin
                f_FirstValue := false;
            end;

            f_OutRecord := f_OutDataSet.RecordList.Items[0] as CFNRecord;

            {$REGION '입력된 값을 이용하여 응답내용을 설정한다'}
            f_InDataSet := p_QueryData.m_Request.GetDataSet(DATASETID_IN_01);
            if Assigned(f_InDataSet) then
            begin
                if f_InDataSet.RecordList.Count > 0 then
                begin
                    f_InRecord := CFNRecord(f_InDataSet.RecordList.Items[0]);
                end else
                begin
                    f_InRecord := NIL;
                end;
            end else
            begin
                f_InRecord := NIL;
            end;

            if Assigned(f_OutRecord) then
            begin
                if f_InRecord <> NIL then
                begin
                    f_OutRecord.SetIntegerValue('COLLECTION_TYPE'   , f_InRecord.GetIntegerValue('COLLECTION_TYPE'));
                    f_OutRecord.SetStringValue ('BLOCK_NAME'        , f_InRecord.GetStringValue ('BLOCK_NAME'));
                    f_OutRecord.SetStringValue ('BLOCK_KEY'         , f_InRecord.GetStringValue ('BLOCK_KEY'));
                    f_OutRecord.SetIntegerValue('SIGNAL_SEQ'        , f_InRecord.GetIntegerValue('SIGNAL_SEQ'));
                    f_OutRecord.SetIntegerValue('ORDER_SEQ'         , f_InRecord.GetIntegerValue('ORDER_SEQ'));
                    f_OutRecord.SetStringValue ('USERID'            , f_InRecord.GetStringValue ('USERID'));

                    f_OutRecord.SetStringValue ('ACCOUNT_NO'        , f_InRecord.GetStringValue ('ACCOUNT_NO'));
                    f_OutRecord.SetStringValue ('SYMBOL'            , f_InRecord.GetStringValue ('SYMBOL'));

                    f_OutRecord.SetIntegerValue('DATATYPE'          , f_InRecord.GetIntegerValue('DATATYPE'));
                    f_OutRecord.SetIntegerValue('BUYSELL'           , f_InRecord.GetIntegerValue('BUYSELL'));

                    f_OutRecord.SetIntegerValue('ORDER_COMMAND'     , f_InRecord.GetIntegerValue('ORDER_COMMAND'));
                    f_OutRecord.SetIntegerValue('ORDER_VOLUME'      , f_InRecord.GetIntegerValue('ORDER_VOLUME'));

                    f_OutRecord.SetDoubleValue ('ORDER_PRICE'       , f_InRecord.GetDoubleValue ('ORDER_PRICE'));
                    f_OutRecord.SetStringValue ('PRICETYPE'         , f_InRecord.GetStringValue ('PRICETYPE'));

                    f_OutRecord.SetIntegerValue('CONDITION'         , f_InRecord.GetIntegerValue('CONDITION'));
                    f_OutRecord.SetStringValue ('ORG_ORDER_NO'      , f_InRecord.GetStringValue ('ORG_ORDER_NO'));

                    if f_FirstValue then
                    begin
                        f_OutRecord.SetStringValue ('ORDER_NO'      , '');
                    end;
                end;
            end;
            {$ENDREGION}

        except
        end;
    end else
    {$ENDREGION}

    {$REGION '시세조회'}
    if (p_QueryData.m_ServiceID = 'SC_QUOTE') and (p_QueryData.m_TRCode = 'TR_0210') then
    begin
        try
            f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
            if not Assigned(f_OutDataSet) then
            begin
                Make_SC_QUOTE_TR_0210_OUT(p_QueryData.m_Response);
                f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
            end;

            if f_OutDataSet.RecordList.Count <= 0 then
            begin
                f_OutRecord := CFNRecord.Create;
                f_OutDataSet.RecordList.Add(f_OutRecord);
                f_FirstValue := true;
            end else
            begin
                f_FirstValue := false;
            end;

            f_OutRecord := f_OutDataSet.RecordList.Items[0] as CFNRecord;

            {$REGION '입력된 값을 이용하여 응답내용을 설정한다'}
            f_InDataSet := p_QueryData.m_Request.GetDataSet(DATASETID_IN_01);
            if Assigned(f_InDataSet) then
            begin
                if f_InDataSet.RecordList.Count > 0 then
                begin
                    f_InRecord := CFNRecord(f_InDataSet.RecordList.Items[0]);
                end else
                begin
                    f_InRecord := NIL;
                end;
            end else
            begin
                f_InRecord := NIL;
            end;

            if Assigned(f_OutRecord) then
            begin
                if f_InRecord <> NIL then
                begin
                    if f_FirstValue then
                    begin
                        f_OutRecord.SetIntegerValue('COUNTRY_NO'        , 0);
                        f_OutRecord.SetIntegerValue('GROUP_NO'          , 4);
                        f_OutRecord.SetIntegerValue('MARKET_NO'         , 0);
                        f_OutRecord.SetStringValue('SYMBOL'             , f_InRecord.GetStringValue('SYMBOL'));
                    end;
                end;
            end;
            {$ENDREGION}
        except
        end;
    end else
    {$ENDREGION}

    {$REGION '계좌조회'}
    if (p_QueryData.m_ServiceID = 'SC_ACCOUNT') and (p_QueryData.m_TRCode = 'TR_0010') then
    begin
        try
            f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
            if f_OutDataSet = NIL then
            begin
                Make_SC_ACCOUNT_TR_0010_OUT(p_QueryData.m_Response);
            end;
        except
        end;
    end;
    {$ENDREGION}
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.OnTimeout(p_QueryData:CFNQueryData);
var
    f_QueryData:CFNQueryData;
    f_OutDataSet : CFNDataSet;
    f_OutRecord : CFNRecord;
begin
    f_QueryData := p_QueryData;

    try
        MakeDefaultResponse(f_QueryData);
        WriteMessage(f_QueryData, 'M90001', '응답시간이 초과되었습니다.');
        if f_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
        begin
            WriteMessage(f_QueryData, 'M99999', '비정상 처리되었습니다.');
        end else
        begin
            WriteMessage(f_QueryData, 'M00000', '정상처리 되었습니다.');
        end;
        StoreRecvData(f_QueryData);
    except
        on E: Exception do
        begin
            WriteMessage(f_QueryData, 'M99999', '비정상 처리되었습니다.');
            f_QueryData.m_Response.SetErrorCode('M30001');
            f_OutRecord := CFNRecord.Create;
            f_OutRecord.SetStringValue('ERROR_CODE', 'M30001');
            f_OutRecord.SetStringValue('MESSAGE', E.Message);
            f_QueryData.m_Response.m_ErrorDataSet.RecordList.Add(f_OutRecord);
            StoreRecvData(f_QueryData);
        end;
    end;
end;

{$REGION '우리선물에서 실시간 시세의 등록 및 취소를 처리하는 함수'}
//---------------------------------------------------------------------------
procedure CFNHNAgentManager.SetSBID(AMapType:Integer; AKey:String; AValue:Integer);
var
    f_FieldValue:CFNFieldValue;
begin
    m_RegistRealTableLock.Enter;
    try
        f_FieldValue := CFNFieldValue.Create;
        f_FieldValue.SetIntegerValue(AValue);
        m_RegistRealTable[AMapType].AddObject(AKey, f_FieldValue);
    finally
        m_RegistRealTableLock.Leave;
    end;
end;


//---------------------------------------------------------------------------
procedure CFNHNAgentManager.ClearSBID(AMapType:Integer; AKey:String);
var
    f_Index:Integer;
    f_Value:CFNFieldValue;
begin
    m_RegistRealTableLock.Enter;
    try
        f_Index := m_RegistRealTable[AMapType].IndexOf(AKey);
        if (f_Index >= 0) then
        begin
            f_Value := CFNFieldValue(m_RegistRealTable[AMapType].Objects[f_Index]);
            if Assigned(f_Value) then f_Value.Free;
            m_RegistRealTable[AMapType].Delete(f_Index);
        end;
    finally
        m_RegistRealTableLock.Leave;
    end;
end;

//---------------------------------------------------------------------------
function CFNHNAgentManager.GetSBID(AMapType:Integer; AKey:String):Integer;
var
    f_Index:Integer;
    f_Value:CFNFieldValue;
begin
    f_Value := NIL;
    m_RegistRealTableLock.Enter;
    try
        f_Index := m_QueryTable.IndexOf(AKey);
        if (f_Index >= 0) then
        begin
            f_Value := CFNFieldValue(m_RegistRealTable[AMapType].Objects[f_Index]);
        end;
    finally
        m_RegistRealTableLock.Leave;
    end;

    if (f_Value <> NIL) then
    begin
        Result := f_Value.GetIntegerValue;
    end else
    begin
        Result := -1;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.ReSubscribeAll;
var

    f_KeyList : TStringList;
    f_Index : Integer;
    f_Key : string;
    f_SBID:Integer;

    f_Country : Integer;
    f_Group : Integer;
    f_Market : Integer;
    f_Symbol : string;
begin
    m_RegistRealTable[MAP_CURRENT].Clear;
    m_RegistRealTable[MAP_BIDOFFER].Clear;
    m_RegistRealTable[MAP_USERTRADE].Clear;
    try

        f_KeyList := m_STSubscribeTable[MAP_CURRENT].GetAllKeys;
        if f_KeyList <> NIL then
        begin
            for f_Index := 0 to f_KeyList.Count - 1 do
            begin
                f_Key := f_KeyList[f_Index];
                GetStreamSubscribeKey(f_Key, f_Country, f_Group, f_Market, f_Symbol);

                if 0 = f_Country then
                begin
                    if 2 = f_Group then
                    begin
                        if 0 = f_Market then
                        begin
                            f_SBID := m_Agent.RegistRealData('SB_FUT_EXEC', f_Symbol);
                            SetSBID(MAP_CURRENT, f_Key, f_SBID);
                        end else
                        if 2 = f_Market then
                        begin
                            f_SBID := m_Agent.RegistRealData('SB_CME_FUT_EXEC', f_Symbol);
                            SetSBID(MAP_CURRENT, f_Key, f_SBID);
                        end;
                    end else
                    if 3 = f_Group then
                    begin
                        f_SBID := m_Agent.RegistRealData('SB_OPT_EXEC', f_Symbol);
                        SetSBID(MAP_CURRENT, f_Key, f_SBID);
                    end;
                end;
            end;
            f_KeyList.Free;
        end;

        f_KeyList := m_STSubscribeTable[MAP_BIDOFFER].GetAllKeys;
        if f_KeyList <> NIL then
        begin
            for f_Index := 0 to f_KeyList.Count - 1 do
            begin
                f_Key := f_KeyList[f_Index];
                GetStreamSubscribeKey(f_Key, f_Country, f_Group, f_Market, f_Symbol);

                if 0 = f_Country then
                begin
                    if 2 = f_Group then
                    begin
                        if 0 = f_Market then
                        begin
                            f_SBID := m_Agent.RegistRealData('SB_FUT_HOGA', f_Symbol);
                            SetSBID(MAP_CURRENT, f_Key, f_SBID);
                        end else
                        if 2 = f_Market then
                        begin
                            f_SBID := m_Agent.RegistRealData('SB_CME_FUT_HOGA', f_Symbol);
                            SetSBID(MAP_CURRENT, f_Key, f_SBID);
                        end;
                    end else
                    if 3 = f_Group then
                    begin
                        f_SBID := m_Agent.RegistRealData('SB_OPT_HOGA', f_Symbol);
                        SetSBID(MAP_CURRENT, f_Key, f_SBID);
                    end;
                end;
            end;
            f_KeyList.Free;
        end;

    finally
    end;
end;

{$ENDREGION}

{$REGION '우리선물에서 시세의 조회및 실시간을 처리하는 이벤트'}
//---------------------------------------------------------------------------
procedure CFNHNAgentManager.OnWRRecvData(
    ASender: TObject;
    DataType: Smallint;
    const TrCode: WideString;
    RqID: Smallint;
    DataSize: Integer;
    var szData: WideString);
var
    f_QueryData:CFNQueryData;
    f_OutDataSet : CFNDataSet;
    f_OutRecord : CFNRecord;
    f_InDataSet : CFNDataSet;
    f_InRecord : CFNRecord;

    f_DataStream : TStringStream;
    f_IODataSet : CFNIODataSet;
    f_IORecord : CFNIORecord;

    f_Change:Double;
    f_Sign:Integer;
begin
    f_QueryData := GetRQTable(IntToStr(RqID));
    if not Assigned(f_QueryData) then exit;

    {$REGION '시세조회'}
    if (f_QueryData.m_ServiceID = 'SC_QUOTE') and (f_QueryData.m_TRCode = 'TR_0210') then
    begin
        try
            if DataType = RQDATA_DATA then
            begin
                MakeDefaultResponse(f_QueryData);
                f_OutDataSet := f_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
                f_OutRecord := f_OutDataSet.RecordList.Items[0] as CFNRecord;

                f_DataStream := TStringStream.Create;
                try
                    f_DataStream.WriteString(szData);

                    m_IOHandler_FZQ12010_OUT.ClearData;
                    m_IOHandler_FZQ12010_OUT.SetSourceData(f_DataStream);
                    m_IOHandler_FZQ12010_OUT.DecodeData;

                    f_IORecord := NIL;
                    if m_IOHandler_FZQ12010_OUT.m_DataSetList.Count > 0 then
                    begin
                        f_IODataSet := m_IOHandler_FZQ12010_OUT.m_DataSetList.Items[0] as CFNIODataSet;
                        if f_IODataSet.RecordList.Count > 0 then
                        begin
                            f_IORecord := f_IODataSet.RecordList.Items[0] as CFNIORecord;
                        end;
                    end;

                    if f_IORecord <> NIL then
                    begin
                        f_OutRecord.SetIntegerValue('COUNTRY_NO', 0);
                        f_OutRecord.SetIntegerValue('GROUP_NO'  , 4);
                        f_OutRecord.SetIntegerValue('MARKET_NO' , 0);

                        f_OutRecord.SetStringValue('SYMBOL', f_IORecord.GetStringValue('SYMBOL'));
                        f_OutRecord.SetStringValue('NAME', f_IORecord.GetStringValue('NAME'));
                        f_OutRecord.SetStringValue('DATE', TFNGlobal.DateToString_YYYYMMDD(Now + g_DateTimeDiff));
                        f_OutRecord.SetStringValue('TIME', TFNGlobal.TimeToString_HHMMSS(Now + g_DateTimeDiff));
                        f_OutRecord.SetDoubleValue('PREV_CLOSE', f_IORecord.GetDoubleValue('PREV_CLOSE'));
                        f_OutRecord.SetDoubleValue('CLOSE_PRICE', f_IORecord.GetDoubleValue('CLOSE_PRICE'));

                        if f_IORecord.GetStringValue('CHANGE_SIGN') = '-' then
                        begin
                            f_Sign := -1
                        end else
                        begin
                            f_Sign :=  1
                        end;

                        f_Change := f_Sign * f_IORecord.GetDoubleValue('CHANGE');
                        f_OutRecord.SetDoubleValue('CHANGE', f_Change);
                        f_OutRecord.SetDoubleValue('CHANGERATE', f_IORecord.GetDoubleValue('CHANGERATE'));
                        f_OutRecord.SetDoubleValue('OPEN_PRICE', f_IORecord.GetDoubleValue('OPEN_PRICE'));
                        f_OutRecord.SetDoubleValue('HIGH_PRICE', f_IORecord.GetDoubleValue('HIGH_PRICE'));
                        f_OutRecord.SetDoubleValue('LOW_PRICE', f_IORecord.GetDoubleValue('LOW_PRICE'));
                        f_OutRecord.SetDoubleValue('TOTAL_VOLUME', f_IORecord.GetDoubleValue('TOTAL_VOLUME'));
                        f_OutRecord.SetDoubleValue('TOTAL_VALUE', f_IORecord.GetDoubleValue('TOTAL_VALUE'));
                        f_OutRecord.SetDoubleValue('BEST_OFFER_PRICE', f_IORecord.GetDoubleValue('BEST_OFFER_PRICE'));
                        f_OutRecord.SetDoubleValue('BEST_BID_PRICE', f_IORecord.GetDoubleValue('BEST_BID_PRICE'));
                    end;
                finally
                    f_DataStream.Free;
                end;
            end else
            if DataType = RQDATA_ERROR then
            begin
                MakeDefaultResponse(f_QueryData);
                WriteMessage(f_QueryData, 'M60001', szData);
                if f_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
                begin
                    WriteMessage(f_QueryData, 'M99999', '비정상 처리되었습니다.');
                end else
                begin
                    WriteMessage(f_QueryData, 'M00000', '정상처리 되었습니다.');
                end;
                ClearRQTable(IntToStr(RqID));
                StoreRecvData(f_QueryData);
            end else
            if DataType = RQDATA_MESSAGE then
            begin
                MakeDefaultResponse(f_QueryData);
                WriteMessage(f_QueryData, 'M60001', szData);
            end else
            if DataType = RQDATA_RELEASE then
            begin
                MakeDefaultResponse(f_QueryData);
                if f_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
                begin
                    WriteMessage(f_QueryData, 'M99999', '비정상 처리되었습니다.');
                end else
                begin
                    WriteMessage(f_QueryData, 'M00000', '정상처리 되었습니다.');
                end;
                ClearRQTable(IntToStr(RqID));
                StoreRecvData(f_QueryData);
            end;
        except
            on E: Exception do
            begin
                WriteMessage(f_QueryData, 'M99999', '비정상 처리되었습니다.');
                f_QueryData.m_Response.SetErrorCode('M30001');
                f_OutRecord := CFNRecord.Create;
                f_OutRecord.SetStringValue('ERROR_CODE', 'M30001');
                f_OutRecord.SetStringValue('MESSAGE', E.Message);
                f_QueryData.m_Response.m_ErrorDataSet.RecordList.Add(f_OutRecord);
                ClearRQTable(IntToStr(RqID));
                StoreRecvData(f_QueryData);
            end;
        end;
    end;
    {$ENDREGION}
end;


{$REGION '실시간 데이터 수신'}
//---------------------------------------------------------------------------
procedure CFNHNAgentManager.OnWRRecvRealData(ASender: TObject; const TrCode, KeyValue: WideString; RealID: Smallint; DataSize: Integer; const szData: WideString);
begin
    m_StringStream.Clear;
    m_StringStream.WriteString(szData);

    m_DataStream.Clear;
    m_StringStream.SaveToStream(m_DataStream);
    m_DataStream.Position := 0;

    if TrCode = 'SB_FUT_EXEC'  then
    begin
        Process_SB_FUT_EXEC(KeyValue, RealID, m_DataStream);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.Process_SB_FUT_EXEC(AKeyValue: WideString; ARealID: Smallint; ADataStream : TMemoryStream);
var
    f_StreamRecord:CFNStreamRecord;
    f_Record:CIORecord;

    f_SubscribeKey : String;
    f_ObjectList : TObjectList;

    f_Loop: Integer;
    f_DataDelivery : CFNDataDelivery;

    f_Sign:Integer;
    f_Change:Double;
begin
    try
        ADataStream.Position := 0;
        m_IODataSet_SB_FUT_EXEC.ClearRecordList;
        m_IODataSet_SB_FUT_EXEC.DecodeData(ADataStream, 1);
    except
    end;

    if (m_IODataSet_SB_FUT_EXEC.RecordList.Count > 0) then
    begin
        try
            f_Record := CIORecord(m_IODataSet_SB_FUT_EXEC.RecordList.Items[0]);

            f_SubscribeKey := MakeStreamSubscribeKey(0, 2, 0, f_Record.GetStringValue('SYMBOL'));

            m_STSubscribeTableLock.Enter;
            try
                f_ObjectList := m_STSubscribeTable[MAP_CURRENT].GetKey(f_SubscribeKey);
            finally
                m_STSubscribeTableLock.Leave;
            end;

            if Assigned(f_ObjectList) then
            begin
                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('QUOTE');

                f_StreamRecord.SetIntegerValue('COUNTRY_NO'     , 0);
                f_StreamRecord.SetIntegerValue('GROUP_NO'       , 4);
                f_StreamRecord.SetIntegerValue('MARKET_NO'      , 0);

                f_StreamRecord.SetStringValue('SYMBOL'          , f_Record.GetStringValue('SYMBOL'          ));
                f_StreamRecord.SetStringValue('TIME'            , f_Record.GetStringValue('TIME'            ));
                f_StreamRecord.SetStringValue('SIGN'            , f_Record.GetStringValue('SIGN'            ));

                if f_Record.GetStringValue('SIGN') = '-' then
                begin
                    f_Sign := -1;
                end else
                begin
                    f_Sign := 1;
                end;

                f_Change := f_Sign * f_Record.GetDoubleValue('CHANGE');

                f_StreamRecord.SetDoubleValue('PREV_CLOSE'      , f_Record.GetDoubleValue('CLOSE_PRICE'     ) - f_Change, 2);
                f_StreamRecord.SetDoubleValue('CLOSE_PRICE'     , f_Record.GetDoubleValue('CLOSE_PRICE'     ), 2);
                f_StreamRecord.SetDoubleValue('CHANGE'          , f_Change, 2);
                f_StreamRecord.SetDoubleValue('CHANGERATE'      , f_Record.GetDoubleValue('CHANGERATE'      ), 2);
                f_StreamRecord.SetDoubleValue('BEST_OFFER_PRICE', f_Record.GetDoubleValue('BEST_OFFER_PRICE'), 2);
                f_StreamRecord.SetDoubleValue('BEST_BID_PRICE'  , f_Record.GetDoubleValue('BEST_BID_PRICE'  ), 2);

                f_StreamRecord.SetDoubleValue('OPEN_PRICE'      , f_Record.GetDoubleValue('OPEN_PRICE'      ), 2);
                f_StreamRecord.SetDoubleValue('HIGH_PRICE'      , f_Record.GetDoubleValue('HIGH_PRICE'      ), 2);
                f_StreamRecord.SetDoubleValue('LOW_PRICE'       , f_Record.GetDoubleValue('LOW_PRICE'       ), 2);

                f_StreamRecord.SetDoubleValue('VOLUME'          , f_Record.GetDoubleValue('VOLUME'          ), 0);
                f_StreamRecord.SetDoubleValue('TOTAL_VOLUME'    , f_Record.GetDoubleValue('TOTAL_VOLUME'    ), 0);
                f_StreamRecord.SetDoubleValue('TOTAL_VALUE'     , f_Record.GetDoubleValue('TOTAL_VALUE'     ), 0);
                f_StreamRecord.SetDoubleValue('OPEN_VOLUME'     , f_Record.GetDoubleValue('OPEN_VOLUME'     ), 0);

                try
                    for f_Loop := 0 to f_ObjectList.Count - 1 do
                    begin
                        f_DataDelivery := CFNDataDelivery(f_ObjectList.Items[f_Loop]);
                        if Assigned(f_DataDelivery) then
                        begin
                            f_StreamRecord.IncreaseReferenceCount;
                            try
                                f_DataDelivery.DeliveryStream(f_StreamRecord);
                            except
                                f_StreamRecord.DecreaseReferenceCount;
                            end;
                        end;
                    end;
                except
                end;
                SaveStreamRecord(f_StreamRecord);

                f_ObjectList.Clear;
                f_ObjectList.Free;
                f_ObjectList := NIL;
            end;
        except
        end;
    end;
end;

{$ENDREGION}

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.OnWRNetConnected(ASender: TObject);
begin

end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.OnWRNetDisconnected(ASender: TObject);
begin
    if Assigned(m_DisconnectEvent) then
    begin
        m_DisconnectEvent(Self);
    end;
end;
//---------------------------------------------------------------------------
{$ENDREGION}

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.OnH5Receive(ASender: TObject; type_: Integer; pBytes: Integer; nBytes: Integer);
begin
    case type_ of
        FEV_CLOSE :
        begin
            LOG_WRITE(LOG_TYPE_ERROR, 'CFNHNCMEAgentManager', '하나대투의 통신이 종료되었습니다.');
            if Assigned(m_DisconnectEvent) then
            begin
                m_DisconnectEvent(Self);
            end;
        end;

        FEV_AXIS:
        begin
            //  실시간 체결
            if noticePAN = LOWORD(pBytes) then
            begin
                ProcessDeal(type_, pBytes, nBytes);
            end;
        end;

        FEV_ERROR:
        begin
            if pBytes <> 0 then
            begin
                LOG_WRITE(LOG_TYPE_ERROR, 'CFNHNCMEAgentManager', Format('FEV_ERROR[%s]', [AnsiChar(nBytes)]));
            end;
        end;

        FEV_FMX:
        begin
            ProcessFMX(type_, pBytes, nBytes);
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.ProcessFMX(AType: Integer; pBytes: Integer; nBytes: Integer);
var
    LongWord  : LongRec;
    f_RQID:Integer;
begin
    LongWord := LongRec(pBytes);
    f_RQID   := LongWord.Lo;
    if (TR_ORDER_START <= f_RQID) and (f_RQID <= TR_ORDER_END) then
    begin
		ProcessOrder(AType, pBytes, nBytes);
		exit;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.ProcessOrder(AType: Integer; pBytes: Integer; nBytes: Integer);
var
    LongWord:LongRec;
    f_RQID:Integer;
    f_ReceiveData:PAnsiChar;
    f_ReceiveSize:Integer;
    f_Data:PAnsiChar;
    f_DataSize:Integer;
    f_pTH5RPHead:pTH5RPHead;

    f_pTPIBOFODR_OUT:pTPIBOFODR_OUT;
    f_MessageCode:String;
    f_MessageText:String;

    f_QueryData:CFNQueryData;
    f_OutDataSet : CFNDataSet;
    f_OutRecord : CFNRecord;
    f_InDataSet : CFNDataSet;
    f_InRecord : CFNRecord;
    f_OrderNo:String;

    f_RecordIndex:Integer;
    f_RecordCount:Integer;
begin
    SetOrderBusy(false);

    LongWord      := LongRec(pBytes);
    f_RQID        := LongWord.Lo;
    f_ReceiveSize := LongWord.Hi;

    f_QueryData := GetRQTable(IntToStr(f_RQID));
    if not Assigned(f_QueryData) then exit;

    f_ReceiveData   := PAnsiChar(nBytes);

    f_pTH5RPHead :=  pTH5RPHead(f_ReceiveData);

    f_Data := PAnsiChar(f_ReceiveData + sizeof(TH5RPHead));
    f_DataSize := f_ReceiveSize - sizeof(TH5RPHead);

    f_MessageCode := H5_ReadString(f_pTH5RPHead.ecode, sizeof(f_pTH5RPHead.ecode));

    if not SameText(f_MessageCode, '000000') then
    begin
        f_MessageText := H5_ReadString(f_pTH5RPHead.msg, sizeof(f_pTH5RPHead.msg));
        WriteMessage(f_QueryData, f_MessageCode, f_MessageText);
        WriteMessage(f_QueryData, 'M99999', '비정상 처리되었습니다.');

        ClearRQTable(IntToStr(f_RQID));
        StoreRecvData(f_QueryData);
    end else
    begin
        try
            MakeDefaultResponse(f_QueryData);
            f_OutDataSet := f_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
            f_OutRecord := f_OutDataSet.RecordList.Items[0] as CFNRecord;

            {$REGION '주문번호를 추출한다'}
            f_pTPIBOFODR_OUT := pTPIBOFODR_OUT(f_Data);
            f_OrderNo := Trim(H5_ReadString(f_pTPIBOFODR_OUT.jmno, sizeof(f_pTPIBOFODR_OUT.jmno)));
            f_OrderNo := IntToStr(TFNGlobal.atoi(f_OrderNo));

            f_OutRecord.SetStringValue('ORDER_NO', f_OrderNo);

            if (f_OrderNo <> '') AND (f_OrderNo <> '0') then
            begin
                LOG_WRITE(LOG_TYPE_INFO, 'CFNHNAgentManager',
                '주문응답; ' +
                '사용자:'           +   f_OutRecord.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_OutRecord.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_OutRecord.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_OutRecord.GetIntegerValue('DATATYPE'))  + '; ' +
                '매매구분:'         +   f_OutRecord.GetStringValue('ORDER_COMMAND')        + '; ' +
                '주문량:'           +   IntToStr(f_OutRecord.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_OutRecord.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                '주문번호:'         +   f_OutRecord.GetStringValue('ORDER_NO')             + '; ' +
                '원주문번호:'       +   f_OutRecord.GetStringValue('ORG_ORDER_NO')         + '; ' +
                '블록명:'           +   f_OutRecord.GetStringValue('BLOCK_NAME')           + '; ' +
                '신호순번:'         +   f_OutRecord.GetStringValue('SIGNAL_SEQ')
                );
            end else
            begin
                LOG_WRITE(LOG_TYPE_ERROR, 'CFNHNAgentManager',
                '주문응답오류; ' +
                '사용자:'           +   f_OutRecord.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_OutRecord.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_OutRecord.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_OutRecord.GetIntegerValue('DATATYPE'))  + '; ' +
                '매매구분:'         +   f_OutRecord.GetStringValue('ORDER_COMMAND')        + '; ' +
                '주문량:'           +   IntToStr(f_OutRecord.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_OutRecord.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                '주문번호:'         +   f_OutRecord.GetStringValue('ORDER_NO')             + '; ' +
                '원주문번호:'       +   f_OutRecord.GetStringValue('ORG_ORDER_NO')         + '; ' +
                '블록명:'           +   f_OutRecord.GetStringValue('BLOCK_NAME')           + '; ' +
                '신호순번:'         +   f_OutRecord.GetStringValue('SIGNAL_SEQ')
                );
            end;
            f_MessageCode := 'M00000';
            f_MessageText := H5_ReadString(f_pTPIBOFODR_OUT.omsg, sizeof(f_pTPIBOFODR_OUT.omsg));
            WriteMessage(f_QueryData, f_MessageCode, f_MessageText);
            {$ENDREGION}

            if f_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
            begin
                WriteMessage(f_QueryData, 'M99999', '비정상 처리되었습니다.');
            end else
            begin
                if f_QueryData.m_Response.GetMsgCode = '' then
                begin
                    WriteMessage(f_QueryData, 'M00000', '정상처리 되었습니다.');
                end;
            end;
            ClearRQTable(IntToStr(f_RQID));
            StoreRecvData(f_QueryData);
        except
            on E: Exception do
            begin
                WriteMessage(f_QueryData, 'M99999', '비정상 처리되었습니다.');
                f_QueryData.m_Response.SetErrorCode('M30001');
                f_OutRecord := CFNRecord.Create;
                f_OutRecord.SetStringValue('ERROR_CODE', 'M30001');
                f_OutRecord.SetStringValue('MESSAGE', E.Message);
                f_QueryData.m_Response.m_ErrorDataSet.RecordList.Add(f_OutRecord);
                ClearRQTable(IntToStr(f_RQID));
                StoreRecvData(f_QueryData);
            end;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.ParseDealData(AData:String; ARecord : CIORecord);
var
    f_LineList:TStringList;
    f_ValueList:TStringList;
    f_LineIndex:Integer;
    f_ValueIndex:Integer;
    f_Key:String;
    f_SValue:String;
begin
    ARecord.ClearAll;

    f_LineList  := TStringList.Create;
    f_ValueList := TStringList.Create;

    try
        ExtractStrings([#$0D], [], PChar(AData), f_LineList);
        for f_LineIndex := 0 to f_LineList.Count - 1 do
        begin
            f_SValue := Trim(f_LineList[f_LineIndex]);
            if Length(f_SValue) = 0 then continue;

            f_ValueList.Clear;
            ExtractStrings([#$09], [], PChar(f_SValue), f_ValueList);

            f_ValueIndex := 0;
            while f_ValueIndex < f_ValueList.Count do
            begin
                f_Key := f_ValueList[f_ValueIndex];
                f_ValueIndex := f_ValueIndex + 1;

                if f_ValueIndex < f_ValueList.Count then
                begin
                    f_SValue := f_ValueList[f_ValueIndex];
                end else
                begin
                    f_SValue := '';
                end;
                f_ValueIndex := f_ValueIndex + 1;

                ARecord.AddStringValue(f_Key, f_SValue);
            end;
        end;
    finally
        f_LineList.Free;
        f_ValueList.Free;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNAgentManager.ProcessDeal(AType: Integer; pBytes: Integer; nBytes: Integer);
var
    f_StreamRecord:CFNStreamRecord;

    f_SubscribeKey : String;

    f_NValue:Integer;
    f_DValue:Double;
    f_SValue:String;
    f_DataType:Integer;

    f_Buffer:PAnsiChar;
    f_Record : CIORecord;
    f_DataGB:String;
    f_PushKey:String;
    f_ReceiveData:PAnsiChar;
    f_ReceiveSize:Integer;
    LongWord  : LongRec;
    f_KEY, f_Pos:Integer;
begin
    f_Record    := CIORecord.Create;
    try
        f_Buffer := NIL;
        LongWord      := LongRec(pBytes);
        f_KEY         := LongWord.Lo;
        f_ReceiveSize := LongWord.Hi;
        f_ReceiveData := PAnsiChar(nBytes);
        f_ReceiveSize := StrLen(f_ReceiveData);

        ReallocMem(f_Buffer, f_ReceiveSize+1);
        TFNGlobal.memset(f_Buffer, $0, f_ReceiveSize+1);
        TFNGlobal.memcpy(f_Buffer, f_ReceiveData, f_ReceiveSize);
        ParseDealData(f_Buffer, f_Record);
        FreeMem(f_Buffer);

        f_StreamRecord := NIL;
        f_DataGB := f_Record.GetStringValue('988');

        if (Pos('접수', f_DataGB) > 0) and (Pos('확인', f_DataGB) <= 0) then
        begin

            {$REGION '거래소접수'}
            try
                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('ORDER_RECEIVE');

                f_PushKey := Trim(f_Record.GetStringValue('901'));

                f_StreamRecord.SetStringValue('USERID'      , Trim(f_Record.GetStringValue('902')));
                f_StreamRecord.SetStringValue('ACCOUNT_NO'  , Trim(f_Record.GetStringValue('901')));
                f_StreamRecord.SetStringValue('SYMBOL'      , Trim(f_Record.GetStringValue('907')));

                if (Pos('정정접수', f_DataGB) > 0) then
                begin
                    f_DataType := ODT_AMENDED;
                end else
                if (Pos('취소접수', f_DataGB) > 0) then
                begin
                    f_DataType := ODT_CANCEL;
                end else
                begin
                    f_DataType := ODT_NEW;
                end;
                f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , f_DataType);

                f_SValue := Trim(f_Record.GetStringValue('912'));
                if (f_SValue = '매도') then f_NValue := 1              //  매도
                else if (f_SValue = '매수')  then f_NValue := 2        //  매수
                else f_NValue := 0;
                if f_DataType = ODT_AMENDED then f_NValue := 3
                else if f_DataType = ODT_CANCEL then f_NValue := 4;
                f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_NValue := StrToInt(f_Record.GetStringValue('909'));
                f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , f_NValue);

                f_DValue := StrToFloat(f_Record.GetStringValue('910')) / 100.0;
                f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , f_DValue);

                f_SValue := Trim(f_Record.GetStringValue('904'));
                f_StreamRecord.SetStringValue('ORDER_NO'        , IntToStr(TFNGlobal.atoi(f_SValue)));

                f_SValue := Trim(f_Record.GetStringValue('905'));
                f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , IntToStr(TFNGlobal.atoi(f_SValue)));

                f_SValue := Trim(f_Record.GetStringValue('975'));
                f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , '');

                f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNHMCAgentManager',
                '주문접수; '        +
                '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')                     + '; ' +
                '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')                         + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))      + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))       + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))        + '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)    + '; ' +
                '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')                       + '; ' +
                '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')                   + '; '
                );

                StoreStreamData(f_StreamRecord);
                f_StreamRecord := NIL;

            finally
                if f_StreamRecord <> NIL then f_StreamRecord.Free;
            end;
            {$ENDREGION}

            {$REGION '거래소확인'}
            try
                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('ORDER_CONFIRM');

                f_PushKey := Trim(f_Record.GetStringValue('901'));

                f_StreamRecord.SetStringValue('USERID'      , Trim(f_Record.GetStringValue('902')));
                f_StreamRecord.SetStringValue('ACCOUNT_NO'  , Trim(f_Record.GetStringValue('901')));
                f_StreamRecord.SetStringValue('SYMBOL'      , Trim(f_Record.GetStringValue('907')));

                if (Pos('정정', f_DataGB) > 0) then
                begin
                    f_DataType := ODT_AMENDED;
                end else
                if (Pos('취소', f_DataGB) > 0) then
                begin
                    f_DataType := ODT_CANCEL;
                end else
                begin
                    f_DataType := ODT_NEW;
                end;
                f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , f_DataType);

                f_SValue := Trim(f_Record.GetStringValue('912'));
                if (f_SValue = '매도') then f_NValue := 1              //  매도
                else if (f_SValue = '매수')  then f_NValue := 2        //  매수
                else f_NValue := 0;
                if f_DataType = ODT_AMENDED then f_NValue := 3
                else if f_DataType = ODT_CANCEL then f_NValue := 4;
                f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_NValue := StrToInt(f_Record.GetStringValue('909'));
                f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , f_NValue);

                f_DValue := StrToFloat(f_Record.GetStringValue('910')) / 100.0;
                f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , f_DValue);

                f_SValue := Trim(f_Record.GetStringValue('904'));
                f_StreamRecord.SetStringValue('ORDER_NO'        , IntToStr(TFNGlobal.atoi(f_SValue)));

                f_SValue := Trim(f_Record.GetStringValue('905'));
                f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , IntToStr(TFNGlobal.atoi(f_SValue)));

                f_SValue := Trim(f_Record.GetStringValue('975'));
                f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , '');

                f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNHMCAgentManager',
                '주문접수; '        +
                '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')                     + '; ' +
                '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')                         + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))      + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))       + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))        + '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)    + '; ' +
                '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')                       + '; ' +
                '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')                   + '; '
                );

                StoreStreamData(f_StreamRecord);
                f_StreamRecord := NIL;

            finally
                if f_StreamRecord <> NIL then f_StreamRecord.Free;
            end;
            {$ENDREGION}

        end else
        if (Pos('접수확인', f_DataGB) > 0) or (Pos('정정', f_DataGB) > 0) or (Pos('취소', f_DataGB) > 0) then
        begin

            {$REGION '거래소확인'}
            (*
            try
                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('ORDER_CONFIRM');

                f_PushKey := Trim(f_Record.GetStringValue('901'));

                f_StreamRecord.SetStringValue('USERID'      , Trim(f_Record.GetStringValue('902')));
                f_StreamRecord.SetStringValue('ACCOUNT_NO'  , Trim(f_Record.GetStringValue('901')));
                f_StreamRecord.SetStringValue('SYMBOL'      , Trim(f_Record.GetStringValue('907')));

                if (Pos('정정', f_DataGB) > 0) then
                begin
                    f_DataType := ODT_AMENDED;
                end else
                if (Pos('취소', f_DataGB) > 0) then
                begin
                    f_DataType := ODT_CANCEL;
                end else
                begin
                    f_DataType := ODT_NEW;
                end;
                f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , f_DataType);

                f_SValue := Trim(f_Record.GetStringValue('912'));
                if (f_SValue = '매도') then f_NValue := 1              //  매도
                else if (f_SValue = '매수')  then f_NValue := 2        //  매수
                else f_NValue := 0;
                if f_DataType = ODT_AMENDED then f_NValue := 3
                else if f_DataType = ODT_CANCEL then f_NValue := 4;
                f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_NValue := StrToInt(f_Record.GetStringValue('909'));
                f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , f_NValue);

                f_DValue := StrToFloat(f_Record.GetStringValue('910')) / 100.0;
                f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , f_DValue);

                f_SValue := Trim(f_Record.GetStringValue('904'));
                f_StreamRecord.SetStringValue('ORDER_NO'        , IntToStr(atoi(f_SValue)));

                f_SValue := Trim(f_Record.GetStringValue('905'));
                f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , IntToStr(atoi(f_SValue)));

                f_SValue := Trim(f_Record.GetStringValue('975'));
                f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , '');

                f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNHMCAgentManager',
                '주문접수; '        +
                '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')                     + '; ' +
                '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')                         + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))      + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))       + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))        + '; ' +
                '주문가:'           +   WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)    + '; ' +
                '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')                       + '; ' +
                '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')                   + '; '
                );

                StoreStreamData(f_StreamRecord);
                f_StreamRecord := NIL;

            finally
                if f_StreamRecord <> NIL then f_StreamRecord.Free;
            end;
            *)
            {$ENDREGION}

        end else
        if (Pos('체결', f_DataGB) > 0) then
        begin

            {$REGION '주문체결'}
            try
                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('ORDER_TRADE');

                f_PushKey := Trim(f_Record.GetStringValue('901'));

                f_StreamRecord.SetStringValue('USERID'      , Trim(f_Record.GetStringValue('902')));
                f_StreamRecord.SetStringValue('ACCOUNT_NO'  , Trim(f_Record.GetStringValue('901')));
                f_StreamRecord.SetStringValue('SYMBOL'      , Trim(f_Record.GetStringValue('907')));

                f_SValue := Trim(f_Record.GetStringValue('912'));
                if (f_SValue = '매도') then f_NValue := 1              //  매도
                else if (f_SValue = '매수')  then f_NValue := 2        //  매수
                else f_NValue := 0;

                f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_NValue := StrToInt(f_Record.GetStringValue('909'));
                f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , f_NValue);

                f_DValue := StrToFloat(f_Record.GetStringValue('910')) / 100.0;
                f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , f_DValue);

                f_SValue := Trim(f_Record.GetStringValue('931'));
                f_NValue := StrToInt(f_SValue);
                f_StreamRecord.SetIntegerValue('TRADE_VOLUME'   , f_NValue);

                f_SValue := Trim(f_Record.GetStringValue('916'));
                f_DValue := StrToFloat(f_SValue) / 100.0;
                f_StreamRecord.SetDoubleValue('TRADE_PRICE'     , f_DValue);

                f_NValue := 0;
                f_StreamRecord.SetIntegerValue('TRADE_VOLUME_TYPE'   , f_NValue);

                f_SValue := Trim(f_Record.GetStringValue('904'));
                f_StreamRecord.SetStringValue('ORDER_NO'        , IntToStr(TFNGlobal.atoi(f_SValue)));

                f_SValue := Trim(f_Record.GetStringValue('905'));
                f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , IntToStr(TFNGlobal.atoi(f_SValue)));

                f_SValue := Trim(f_Record.GetStringValue('975'));
                f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , '');

                f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNHMCAgentManager',
                '주문접수; '        +
                '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')                     + '; ' +
                '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')                         + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))      + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))       + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))        + '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)    + '; ' +
                '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')                       + '; ' +
                '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')                   + '; '
                );

                StoreStreamData(f_StreamRecord);
                f_StreamRecord := NIL;

            finally
                if f_StreamRecord <> NIL then f_StreamRecord.Free;
            end;
            {$ENDREGION}

        end else
        if (Pos('오류', f_DataGB) > 0) or (Pos('거부', f_DataGB) > 0) then
        begin

            {$REGION '주문오류 주문거부'}
            try
                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('ORDER_REJECT');

                f_PushKey := Trim(f_Record.GetStringValue('901'));

                f_StreamRecord.SetStringValue('USERID'      , Trim(f_Record.GetStringValue('902')));
                f_StreamRecord.SetStringValue('ACCOUNT_NO'  , Trim(f_Record.GetStringValue('901')));
                f_StreamRecord.SetStringValue('SYMBOL'      , Trim(f_Record.GetStringValue('907')));

                f_SValue := Trim(f_Record.GetStringValue('912'));
                if (f_SValue = '매도') then f_NValue := 1              //  매도
                else if (f_SValue = '매수')  then f_NValue := 2        //  매수
                else f_NValue := 0;

                f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_NValue := StrToInt(f_Record.GetStringValue('909'));
                f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , f_NValue);

                f_DValue := StrToFloat(f_Record.GetStringValue('910')) / 100.0;
                f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , f_DValue);

                f_SValue := Trim(f_Record.GetStringValue('904'));
                f_StreamRecord.SetStringValue('ORDER_NO'        , IntToStr(TFNGlobal.atoi(f_SValue)));

                f_SValue := Trim(f_Record.GetStringValue('905'));
                f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , IntToStr(TFNGlobal.atoi(f_SValue)));

                f_SValue := Trim(f_Record.GetStringValue('975'));
                f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , f_SValue);

                f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNHMCAgentManager',
                '주문접수; '        +
                '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')                     + '; ' +
                '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')                         + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))      + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))       + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))        + '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)    + '; ' +
                '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')                       + '; ' +
                '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')                   + '; '
                );

                StoreStreamData(f_StreamRecord);
                f_StreamRecord := NIL;

            finally
                if f_StreamRecord <> NIL then f_StreamRecord.Free;
            end;
            {$ENDREGION}

        end;

    finally
        f_Record.Free;
    end;
end;

end.
