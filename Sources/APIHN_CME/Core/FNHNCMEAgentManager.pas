//**************************************************************************//
//  FileName        :   FNHNCMEAgentManager.pas
//  Author          :   김무근 작성
//  Date            :   2014년 1월 10일
//  Description     :   하나대투 API를 통해, 시세와 주문을 구현하기 위한 클래스
//**************************************************************************//
{하나대투사 API를 통해, 시세와 주문을 구현하기 위한 클래스}
Unit FNHNCMEAgentManager;

interface

uses
    Messages, WinProcs, SysUtils, Forms, ActiveX, WinTypes, Classes, SyncObjs, ExtCtrls,
    Contnrs, IniFiles, Math, FNDataSet, FNDataDelivery, Variants, FNAgentManager,
    IODataSet, FNQueue, FNIOHandler, COMMOCXLib_TLB, H5MGREXLib_TLB, FNMaterialCollection;

type
    ///<author>김무근</author>
    ///<version>1.0</version>
    ///<since>2014.01.10</since>
    ///<Comment>하나대투 API를 이용하여 필요한 기능을 확장한 클래스</Comment>
    CFNHNCMEAgentManager = class(CFNAgentManager)
    public
        ///<Comment>생성자</Comment>
        Constructor Create(AQueryThreadCount:Integer = 1);

        ///<Comment>파괴자</Comment>
        Destructor Destroy; override;

        ///<Comment>증권사 API OCX를 등록한다.</Comment>
        procedure AssignAgent(p_Agent:TCommOCX);

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
        m_Agent:TCommOCX;
        m_H5MgrEx: TH5MgrEx;
        m_AgentLock:TCriticalSection;
        m_MaterialItem  :   CFNMaterialItem;

        procedure ProcessFMX(AType: Integer; pBytes: Integer; nBytes: Integer);
        procedure ProcessOrder(AType: Integer; pBytes: Integer; nBytes: Integer);
        procedure ProcessDeal(AType: Integer; pBytes: Integer; nBytes: Integer);
        procedure ProcessAccountVT(AType: Integer; pBytes: Integer; nBytes: Integer);
        procedure ProcessAccountRT(AType: Integer; pBytes: Integer; nBytes: Integer);

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


    {$REGION '우리선물 조회순번'}
    private
        m_RQIndex : Integer;
        m_RQLock : TCriticalSection;
        function GetRQIndex : Integer;
    {$ENDREGION}

    {$REGION '우리선물 수신된 데이터를 분석하기 위한 객체'}
    private
        m_IOHandler_HCQ01120_OUT : CFNIOHandler;
        m_IODataSet_RDM_OSTS1       : CIODataSet;

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

        function    GetMaterialData(ASymbol:String; var ACountry : Integer; var AGroup : Integer; var AMarket : Integer):CFNMaterialItem;
        procedure   GetGategory(ASymbol:String; var ACountry : Integer; var AGroup : Integer; var AMarket : Integer);

    private
        procedure OnWRRecvData(ASender: TObject; const szTrCode: WideString; nRqID: Smallint; nDataLen: Smallint; var szData: WideString);
        procedure OnWRRecvMSG(ASender: TObject; const cFlag: WideString; const szMsg: WideString);
        procedure OnWRRecvRealData(ASender: TObject; nKey: Smallint; nDataLen: Smallint; const szData: WideString);
        procedure OnWRSocketStatus(ASender: TObject; nStatus: Smallint);

        procedure Process_RDM_OSTS1(ADataStream : TMemoryStream);

        procedure OnH5Receive(ASender: TObject; type_: Integer; pBytes: Integer; nBytes: Integer);

    private
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
    Dialogs, FNGlobal, FNGlobalVariable, WideStrUtils, CommonTRMaker, FNTradeSystem,
    FNAccountArray, FNAccountData, DateUtils, H5MGREXLib_Const, WROIOMaker, FNCMVariable, MXVariable,
    HNIOMaker;

{$REGION '각 종 함수들'}
//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.GetGategory(ASymbol:String; var ACountry : Integer; var AGroup : Integer; var AMarket : Integer);
var
    f_Key : String;
begin
    f_Key := Copy(ASymbol, 1, 2);
    if SameText(f_Key, 'ES') OR SameText(f_Key, 'NQ') OR SameText(f_Key, 'YM') then
    begin
        ACountry    :=  2;
        AGroup      :=  2;
        AMarket     :=  0;
    end else
    if SameText(f_Key, '6E') OR SameText(f_Key, '6J') OR SameText(f_Key, '6B') then
    begin
        ACountry    :=  2;
        AGroup      :=  3;
        AMarket     :=  0;
    end else
    if SameText(f_Key, 'GC') OR SameText(f_Key, 'CL') then
    begin
        ACountry    :=  2;
        AGroup      :=  4;
        AMarket     :=  0;
    end else
    if SameText(f_Key, 'ZN') then
    begin
        ACountry    :=  2;
        AGroup      :=  5;
        AMarket     :=  0;
    end else
    begin
        ACountry    :=  2;
        AGroup      :=  2;
        AMarket     :=  0;
    end;
end;

//---------------------------------------------------------------------------
function CFNHNCMEAgentManager.GetMaterialData(ASymbol:String; var ACountry : Integer; var AGroup : Integer; var AMarket : Integer):CFNMaterialItem;
var
    f_MaterialItem : CFNMaterialItem;
    f_Key : String;
begin
    f_Key := Copy(ASymbol, 1, 2);
    if SameText(f_Key, 'ES') OR SameText(f_Key, 'NQ') OR SameText(f_Key, 'YM') then
    begin
        ACountry    :=  2;
        AGroup      :=  2;
        AMarket     :=  0;
    end else
    if SameText(f_Key, '6E') OR SameText(f_Key, '6J') OR SameText(f_Key, '6B') then
    begin
        ACountry    :=  2;
        AGroup      :=  3;
        AMarket     :=  0;
    end else
    if SameText(f_Key, 'GC') OR SameText(f_Key, 'CL') then
    begin
        ACountry    :=  2;
        AGroup      :=  4;
        AMarket     :=  0;
    end else
    if SameText(f_Key, 'ZN') then
    begin
        ACountry    :=  2;
        AGroup      :=  5;
        AMarket     :=  0;
    end;

    f_MaterialItem := NIL;
    if Assigned(g_MaterialCollection) then
    begin
        f_MaterialItem := g_MaterialCollection.Find(ACountry, AGroup, AMarket, g_SymbolCollection.GetOPSSymbol(ASymbol));
    end;

    Result := f_MaterialItem;
end;


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

{$ENDREGION}

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.AssignAgent(p_Agent: TCommOCX);
begin
    if Assigned(m_Agent) then
    begin
        m_Agent.OnORecvData := NIL;
        m_Agent.OnORecvMsg := NIL;
        m_Agent.OnORecvRealData := NIL;
        m_Agent.OnOSocketStatus := NIL;
    end;

    m_Agent := p_Agent;

    if Assigned(m_Agent) then
    begin
        m_Agent.OnORecvData := OnWRRecvData;
        m_Agent.OnORecvMsg := OnWRRecvMsg;
        m_Agent.OnORecvRealData := OnWRRecvRealData;
        m_Agent.OnOSocketStatus := OnWRSocketStatus;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.AssignH5Agent(p_Agent: TH5MgrEx);
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
procedure CFNHNCMEAgentManager.SubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := ASymbol;
    if m_STSubscribeTable[MAP_CURRENT].AddKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        m_Agent.OCommSetBrodReal(17, ASymbol);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.SubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
    f_SBID:Integer;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := ASymbol;
    if m_STSubscribeTable[MAP_BIDOFFER].AddKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        m_Agent.OCommSetBrodReal(20, ASymbol);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.SubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = '');
begin
    if not Assigned(m_Agent) then exit;
    if m_STSubscribeTable[MAP_USERTRADE].AddKeyValue(AAccountNO, ADataDelivery) then
    begin
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.UnsubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
    f_SBID:Integer;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := ASymbol;
    if m_STSubscribeTable[MAP_CURRENT].DeleteKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        m_Agent.ORemoveBrodReal(17, ASymbol);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.UnsubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
    f_SBID:Integer;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := ASymbol;
    if m_STSubscribeTable[MAP_BIDOFFER].DeleteKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        m_Agent.ORemoveBrodReal(20, ASymbol);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.UnsubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = '');
begin
    if not Assigned(m_Agent) then exit;
    if m_STSubscribeTable[MAP_USERTRADE].DeleteKeyValue(AAccountNO, ADataDelivery) then
    begin
    end;
end;

{$REGION '주문동기화'}
//---------------------------------------------------------------------------
// 조회데이터의 전달할 CFNDelivery객체를 저장할 인덱스 m_RQSubscribeIndex를 가져온다. 이 후에 이값을 1 증가시킨다.
// 배열의 크기가 1024이므로 m_RQSubscribeIndex의 값이 1024보다 크거나 같으면 0으로 초기화 한다.
function CFNHNCMEAgentManager.GetRQIndex : Integer;
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
procedure CFNHNCMEAgentManager.StoreStreamData(p_Data: CFNStreamRecord);
begin
    if Assigned(p_Data) then
    begin
        m_StreamDataQueue.Store(p_Data);
    end;
end;

//---------------------------------------------------------------------------
function CFNHNCMEAgentManager.RetrieveStreamData: CFNStreamRecord;
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
procedure CFNHNCMEAgentManager.ClearStreamData;
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
procedure CFNHNCMEAgentManager.DoStreamDataWork;
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

                    f_SubscribeKey := f_StreamData.GetStringValue ('SYMBOL');

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
Constructor CFNHNCMEAgentManager.Create(AQueryThreadCount:Integer = 1);
begin
    inherited Create(AQueryThreadCount);

    m_MaterialItem := NIL;
    m_DataStream := TMemoryStream.Create;
    m_StringStream := TStringStream.Create;

    m_IOHandler_HCQ01120_OUT := Make_HCQ01120_OUT(NIL);
    m_IODataSet_RDM_OSTS1 := Make_RDM_OSTS1(NIL);

    m_RQIndex := TR_ORDER_START;

    m_StreamDataQueue := CFNQueue.Create;

    m_AgentLock := TCriticalSection.Create;
    m_RQLock := TCriticalSection.Create;

    m_RQTimer := TTimer.Create(NIL);
    m_RQTimer.Enabled := true;
    m_RQTimer.OnTimer := OnTiemr;
    m_RQTimer.Interval := 10;
end;

//---------------------------------------------------------------------------
Destructor CFNHNCMEAgentManager.Destroy;
begin
    m_DataStream.Free;
    m_StringStream.Free;
    m_DataStream := NIL;
    m_StringStream := NIL;


    m_IOHandler_HCQ01120_OUT.Free;
    m_IODataSet_RDM_OSTS1.Free;
    m_IODataSet_RDM_OSTS1 := NIL;

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
procedure CFNHNCMEAgentManager.OnTiemr(Sender: TObject);
var
    f_QueryData:CFNQueryData;
    f_OpenDateTime:TDateTime;
    f_CloseDateTime:TDateTime;
    f_Time1:TDateTime;
    f_Year,f_Month,f_Day,f_Hour,f_Min,f_Sec,f_MSec:Word;
begin
    m_RQTimer.Enabled := false;
    try

        f_QueryData := RetrieveSendData;

        if Assigned(f_QueryData) then
        begin

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
            end else
            if f_QueryData.m_ServiceID = 'SC_ORDER' then
            begin
                //  선물 주문
                if (f_QueryData.m_TRCode = 'TR_0210') then
                begin
                    SC_ORDER_TR_0210(f_QueryData);
                end else
                begin
                    WriteError(f_QueryData, 'M10001');
                    StoreRecvData(f_QueryData);
                end;
            end else
            begin
                WriteError(f_QueryData, 'M10001');
                StoreRecvData(f_QueryData);
            end;
        end;

        DoCheckTimeout;

    finally
        m_RQTimer.Enabled := true;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.DoQueryWork(AThreadIndex:Integer);
begin
    DoStreamDataWork;
end;

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.DoCheckTimeout;
var
    f_Index:Integer;
    f_QueryData:CFNQueryData;
    f_CheckTime : TDateTime;
    f_Done : Boolean;
    f_Diff : TDateTime;
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

                f_Diff := (f_CheckTime - f_QueryData.m_DateTime) * 86500;
                if f_Diff > 5 then
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
procedure CFNHNCMEAgentManager.WriteMessage(p_QueryData: CFNQueryData; sErrorCode, sMsg: WideString);
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
procedure CFNHNCMEAgentManager.WriteError(p_QueryData: CFNQueryData; sErrorCode:WideString);
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
procedure CFNHNCMEAgentManager.SC_ORDER_TR_0210(p_QueryData: CFNQueryData);
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

    f_Key               :   Integer;
    f_RQID              :   Integer;

    f_Buffer : Array [0..MAX_BUFFER-1] of AnsiChar;

    f_RQHead        :   TH5RQHead;
    f_pRQHead       :   pTH5RQHead;
    f_PIBOFODR      :   TPIBOFODR;
    f_pPIBOFODR     :   pTPIBOFODR;
    f_DataSize      :   Integer;

    f_SendData      :   AnsiString;

    f_ResultValue   :   Integer;

    f_ACC1, f_ACC2, f_ACC3:String;
    f_EPW:String;

    f_UserData  : String;
begin
    FillChar(f_Buffer, MAX_BUFFER, $20);
    f_pRQHead   := pTH5RQHead(Addr(f_Buffer[0]));

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

                f_ACC1 := Copy(f_AccountNo, 1, 8);
                f_ACC2 := Copy(f_AccountNo, 9, 2);
                f_ACC3 := f_ACC1 + '-' + f_ACC2;

                LOG_WRITE(LOG_TYPE_INFO, 'CFNHNCMEAgentManager',
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
                    f_RQID := GetRQIndex;
                    f_Key := TR_GFNEWORDER;
                    f_pRQHead.key[0] := AnsiChar(f_Key);
                    f_pRQHead.stat[0] := AnsiChar(US_CA or US_ENC);
                    f_pRQHead.bizH[0] := '1';
                    H5_WriteInteger(f_pRQHead.bizK , f_RQID, 6);
                    //TFNGlobal.memcpy(f_pRQHead.bizK, '@00003', 6);
                    TFNGlobal.memcpy(f_pRQHead.trx_Name, 'gibotuxq', sizeof(f_pRQHead.trx_Name));
                    TFNGlobal.memcpy(f_pRQHead.svc_Name, 'FHD03110_U', sizeof(f_pRQHead.svc_Name));
                    f_pRQHead.job_cod[0] := '1';
                end else
                if (f_OrderCommand = 3) then
                begin
                    f_RQID := GetRQIndex;
                    f_Key := TR_GFJJORDER;
                    f_pRQHead.key[0] := AnsiChar(f_Key);
                    f_pRQHead.stat[0] := AnsiChar(US_CA or US_ENC);
                    f_pRQHead.bizH[0] := '1';
                    H5_WriteInteger(f_pRQHead.bizK , f_RQID, 6);
                    //TFNGlobal.memcpy(f_pRQHead.bizK, '@00003', 6);
                    TFNGlobal.memcpy(f_pRQHead.trx_Name, 'gibotuxq', sizeof(f_pRQHead.trx_Name));
                    TFNGlobal.memcpy(f_pRQHead.svc_Name, 'FHD03111_U', sizeof(f_pRQHead.svc_Name));
                    f_pRQHead.job_cod[0] := '1';
                end else
                begin
                    f_RQID := GetRQIndex;
                    f_Key := TR_GFCSORDER;
                    f_pRQHead.key[0] := AnsiChar(f_Key);
                    f_pRQHead.stat[0] := AnsiChar(US_CA or US_ENC);
                    f_pRQHead.bizH[0] := '1';
                    H5_WriteInteger(f_pRQHead.bizK , f_RQID, 6);
                    //TFNGlobal.memcpy(f_pRQHead.bizK, '@00003', 6);
                    TFNGlobal.memcpy(f_pRQHead.trx_Name, 'gibotuxq', sizeof(f_pRQHead.trx_Name));
                    TFNGlobal.memcpy(f_pRQHead.svc_Name, 'FHD03112_U', sizeof(f_pRQHead.svc_Name));
                    f_pRQHead.job_cod[0] := '1';
                end;

                if (f_OrderCommand = 1) or (f_OrderCommand = 2) then
                begin
                    f_SendData := '';

                    //  계좌번호
                    f_SendData := f_SendData + f_ACC1 + #$09;

                    //  계좌상품
                    f_SendData := f_SendData + f_ACC2 + #$09;

                    //  비밀번호
                    f_EPW := m_H5MgrEx.GetEncript(f_Password, f_AccountNo, 1);
                    if Length(f_EPW) > 4 then f_EPW := Copy(f_EPW, 1, 4);
                    f_SendData := f_SendData + f_EPW + #$09;

                    //  종목코드
                    f_SendData := f_SendData + f_Symbol + #$09;

                    //  매도매수 구분
                    if 1 = f_nBuySell then
                    begin
                        f_SendData := f_SendData + 'B' + #$09;
                    end else
                    begin
                        f_SendData := f_SendData + 'S' + #$09;
                    end;

                    //  가격조건
                    if '01' = f_sPriceType then
                    begin
                        f_SendData := f_SendData + '1' + #$09;
                    end else
                    begin
                        f_SendData := f_SendData + '2' + #$09;
                    end;

                    //  주문가격
                    f_SendData := f_SendData + FloatToStr(f_OrderPrice) + #$09;

                    //  주문수량
                    f_SendData := f_SendData + IntToStr(f_OrderVolume) + #$09;

                    //  stop order 지정가격
                    f_SendData := f_SendData + '' + #$09;

                    //  조작구분    일반주문
                    f_SendData := f_SendData + 'C' + #$09;

                    StrPCopy(Addr(f_Buffer[sizeof(TH5RQHead)]), f_SendData);
                    f_DataSize := sizeof(TH5RQHead) + Length(f_SendData);

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
                if (f_OrderCommand = 3) then
                begin
                    f_SendData := '';

                    //  주문번호
                    f_SendData := f_SendData + f_Record.GetStringValue('ORG_ORDER_NO') + #$09;

                    //  계좌번호
                    f_SendData := f_SendData + f_ACC1 + #$09;

                    //  계좌상품
                    f_SendData := f_SendData + f_ACC2 + #$09;

                    //  비밀번호
                    f_EPW := m_H5MgrEx.GetEncript(f_Password, f_AccountNo, 0);
                    if Length(f_EPW) > 4 then f_EPW := Copy(f_EPW, 1, 4);
                    f_SendData := f_SendData + f_EPW + #$09;

                    //  종목코드
                    f_SendData := f_SendData + f_Symbol + #$09;

                    //  가격조건
                    if '01' = f_sPriceType then
                    begin
                        f_SendData := f_SendData + '1' + #$09;
                    end else
                    begin
                        f_SendData := f_SendData + '2' + #$09;
                    end;

                    //  주문가격
                    f_SendData := f_SendData + FloatToStr(f_OrderPrice) + #$09;

                    //  주문수량
                    f_SendData := f_SendData + IntToStr(f_OrderVolume) + #$09;

                    //  stop order 지정가격
                    f_SendData := f_SendData + '' + #$09;

                    //  잔량
                    f_SendData := f_SendData + 'Y' + #$09;

                    StrPCopy(Addr(f_Buffer[sizeof(TH5RQHead)]), f_SendData);
                    f_DataSize := sizeof(TH5RQHead) + Length(f_SendData);

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
                if (f_OrderCommand = 4) then
                begin
                    f_SendData := '';

                    //  주문번호
                    f_SendData := f_SendData + f_Record.GetStringValue('ORG_ORDER_NO') + #$09;

                    //  계좌번호
                    f_SendData := f_SendData + f_ACC1 + #$09;

                    //  계좌상품
                    f_SendData := f_SendData + f_ACC2 + #$09;

                    //  비밀번호
                    f_EPW := m_H5MgrEx.GetEncript(f_Password, f_AccountNo, 0);
                    if Length(f_EPW) > 4 then f_EPW := Copy(f_EPW, 1, 4);
                    f_SendData := f_SendData + f_EPW + #$09;

                    //  종목코드
                    f_SendData := f_SendData + f_Symbol + #$09;

                    //  주문수량
                    f_SendData := f_SendData + IntToStr(f_OrderVolume) + #$09;

                    //  잔량
                    f_SendData := f_SendData + 'Y' + #$09;

                    StrPCopy(Addr(f_Buffer[sizeof(TH5RQHead)]), f_SendData);
                    f_DataSize := sizeof(TH5RQHead) + Length(f_SendData);

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
procedure CFNHNCMEAgentManager.SC_QUOTE_TR_0210(p_QueryData: CFNQueryData);
var
    f_InDataSet:CFNDataSet;
    f_InRecord:CFNRecord;
    f_Symbol:String;
    f_IORecord:CFNIORecord;
    f_IOHandler:CFNIOHandler;
    f_SendStream:TStringStream;
    f_RQID:short;
    f_DataString:String;
    f_DataSize:Integer;
    f_RValue:Integer;
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
                    f_IOHandler := Make_HCQ01120_IN(NIL, f_IORecord);
                    f_IOHandler.EncodeData(f_SendStream);
                    f_IOHandler.Free;

                    f_SendStream.Position := 0;
                    f_DataSize := f_SendStream.Size;
                    f_DataString := f_SendStream.ReadString(f_DataSize);

                    m_AgentLock.Enter;
                    try
                        f_RQID := GetRQIndex();
                        p_QueryData.m_RequestID := IntToStr(f_RQID);
                        p_QueryData.m_DateTime := Now;
                        p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
                        p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);
                        SetRQTable(p_QueryData.m_RequestID, p_QueryData);
                        f_RValue := m_Agent.ORequestData('HCQ01120', f_DataString, f_DataSize, 60, 0);
                        if 0 = f_RValue then
                        begin
                        end else
                        begin
                            ClearRQTable(p_QueryData.m_RequestID);
                            MakeDefaultResponse(p_QueryData);
                            WriteMessage(p_QueryData, 'M99999', '요청시 오류가 발생했습니다.');
                            WriteError(p_QueryData, 'M60001');
                            StoreRecvData(p_QueryData);
                            p_QueryData := NIL;
                        end;

                    finally
                        m_AgentLock.Leave;
                    end;

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

(*
//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.SC_ACCOUNT_TR_0010(p_QueryData: CFNQueryData);
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

*)

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.SC_ACCOUNT_TR_0010(p_QueryData: CFNQueryData);
var
    F: TextFile;
    S: string;
    f_AccountNo:String;
    f_AccountName:String;
    f_OutDataSet:CFNDataSet;
    f_OutRecord:CFNRecord;
    f_Success:Boolean;
    f_FieldList:TStringList;

    LIOHandler : CFNIOHandler;
    LHeadRecord, LDataRecord:CFNIORecord;
    LSendStream:TMemoryStream;
    LDataSize : Integer;
    LDataString : WideString;
    LBuffer: TBytes;
begin
    try
        if (g_SecTradeMode = SEC_TRADE_MODE_TEST) then
        begin
            LHeadRecord := CFNIORecord.Create;
            LHeadRecord.SetByteValue('KEY', TR_VGFACC);
            LHeadRecord.SetByteValue('STAT', US_ENC);
            LHeadRecord.SetStringValue('BIZH', '1');
            LHeadRecord.SetStringValue('BIZK', '@00001');
            LHeadRecord.SetStringValue('TRX_NAME', 'GIBOTUXQ');
            LHeadRecord.SetStringValue('SVC_NAME', 'FHD81000_Q');
            LHeadRecord.SetStringValue('JOB_CODE', '1');

            LDataRecord := CFNIORecord.Create;
            LDataRecord.SetStringValue('USID', g_SecUserID+#$09);

            LSendStream := TMemoryStream.Create;
            try
                LIOHandler := Make_ACCOUNT_IN2(NIL, LHeadRecord, LDataRecord);
                LIOHandler.EncodeDataToByte(LSendStream);
                LIOHandler.Free;

                LSendStream.Position := 0;
                LDataSize := LSendStream.Size;

                SetLength(LBuffer, LDataSize+1);
                LSendStream.ReadBuffer(Pointer(LBuffer)^, LDataSize);

                LBuffer[LDataSize] := $00;

                p_QueryData.m_RequestID := IntToStr(TR_VGFACC);
                p_QueryData.m_DateTime := Now;
                p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
                p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);
                SetRQTable(p_QueryData.m_RequestID, p_QueryData);

                m_AgentLock.Enter;
                try
                    m_H5MgrEx.HFCommand(hf_QUERYTR, Integer(Addr(LBuffer[0])), LDataSize);
                finally
                    m_AgentLock.Leave;
                end;

                p_QueryData := NIL;


            finally
                LSendStream.Free;
            end;
        end else
        begin
            LHeadRecord := CFNIORecord.Create;
            LHeadRecord.SetByteValue('KEY', TR_ACCLIST);
            LHeadRecord.SetByteValue('STAT', US_PASS);
            LHeadRecord.SetStringValue('TRX_NAME', 'PIIOACCN');

            LDataRecord := CFNIORecord.Create;
            LDataRecord.SetStringValue('FUNC', 'Q');
            LDataRecord.SetStringValue('USID', g_SecUserID);

            LSendStream := TMemoryStream.Create;
            try
                LIOHandler := Make_ACCOUNT_IN(NIL, LHeadRecord, LDataRecord);
                LIOHandler.EncodeDataToByte(LSendStream);
                LIOHandler.Free;

                LSendStream.Position := 0;
                LDataSize := LSendStream.Size;

                SetLength(LBuffer, LDataSize+1);
                LSendStream.ReadBuffer(Pointer(LBuffer)^, LDataSize);

                LBuffer[LDataSize] := $00;

                p_QueryData.m_RequestID := IntToStr(TR_ACCLIST);
                p_QueryData.m_DateTime := Now;
                p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
                p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);
                SetRQTable(p_QueryData.m_RequestID, p_QueryData);

                m_AgentLock.Enter;
                try
                    m_H5MgrEx.HFCommand(hf_QUERYTR, Integer(Addr(LBuffer[0])), LDataSize);
                finally
                    m_AgentLock.Leave;
                end;

                p_QueryData := NIL;


            finally
                LSendStream.Free;
            end;
        end;
    finally
        if p_QueryData <> NIL then p_QueryData.Free;
    end;

end;

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.MakeDefaultResponse(p_QueryData:CFNQueryData);
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
                        f_OutRecord.SetIntegerValue('GROUP_NO'          , 2);
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
procedure CFNHNCMEAgentManager.OnTimeout(p_QueryData:CFNQueryData);
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

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.ReSubscribeAll;
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

    try

        f_KeyList := m_STSubscribeTable[MAP_CURRENT].GetAllKeys;
        if f_KeyList <> NIL then
        begin
            for f_Index := 0 to f_KeyList.Count - 1 do
            begin
                f_Key := f_KeyList[f_Index];
                m_Agent.OCommSetBrodReal(17, f_Key);
            end;
            f_KeyList.Free;
        end;

        f_KeyList := m_STSubscribeTable[MAP_BIDOFFER].GetAllKeys;
        if f_KeyList <> NIL then
        begin
            for f_Index := 0 to f_KeyList.Count - 1 do
            begin
                f_Key := f_KeyList[f_Index];
                m_Agent.OCommSetBrodReal(20, f_Key);
            end;
            f_KeyList.Free;
        end;

    finally
    end;
end;

{$ENDREGION}

{$REGION '우리선물에서 시세의 조회및 실시간을 처리하는 이벤트'}
//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.OnWRRecvData(ASender: TObject; const szTrCode: WideString; nRqID: Smallint; nDataLen: Smallint; var szData: WideString);
var
    f_QueryData:CFNQueryData;
    f_OutDataSet : CFNDataSet;
    f_OutRecord : CFNRecord;
    f_InDataSet : CFNDataSet;
    f_InRecord : CFNRecord;
    f_OrderNo:String;
    f_MessageCode:String;
    f_DataStream : TStringStream;
    f_IODataSet : CFNIODataSet;
    f_IORecord : CFNIORecord;
    f_FixedCount:Integer;
    f_RecordSize:Integer;
    f_RecordIndex:Integer;

    f_Change:Double;
    f_Sign:Integer;
    f_Country:Integer;
    f_Group:Integer;
    f_Market:Integer;

    f_Symbol:String;
    f_IValue:Integer;
    f_DateTime, f_TimeDiffrence:Double;
    f_MaterialItem:CFNMaterialItem;
    f_Factor:Double;
begin
    f_QueryData := GetRQTable(IntToStr(nRqID));
    if not Assigned(f_QueryData) then exit;

    {$REGION '시세조회'}
    if (f_QueryData.m_ServiceID = 'SC_QUOTE') and (f_QueryData.m_TRCode = 'TR_0210') then
    begin
        try
            MakeDefaultResponse(f_QueryData);
            f_OutDataSet := f_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);

            f_InDataSet := f_QueryData.m_Request.GetDataSet(DATASETID_IN_01);
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

            f_OutRecord := f_OutDataSet.RecordList.Items[0] as CFNRecord;
            f_DataStream := TStringStream.Create;
            try
                f_DataStream.WriteString(szData);

                m_IOHandler_HCQ01120_OUT.ClearData;
                m_IOHandler_HCQ01120_OUT.SetSourceData(f_DataStream);
                m_IOHandler_HCQ01120_OUT.DecodeData;

                f_IORecord := NIL;
                if m_IOHandler_HCQ01120_OUT.m_DataSetList.Count > 0 then
                begin
                    f_IODataSet := m_IOHandler_HCQ01120_OUT.m_DataSetList.Items[0] as CFNIODataSet;
                    if f_IODataSet.RecordList.Count > 0 then
                    begin
                        f_IORecord := f_IODataSet.RecordList.Items[0] as CFNIORecord;
                    end;
                end;

                if f_IORecord <> NIL then
                begin
                    f_Symbol := Trim(f_IORecord.GetStringValue ('SYMBOL'));

                    f_OutRecord.SetIntegerValue('COUNTRY_NO', f_InRecord.GetIntegerValue('COUNTRY_NO'   ));
                    f_OutRecord.SetIntegerValue('GROUP_NO'  , f_InRecord.GetIntegerValue('GROUP_NO'     ));
                    f_OutRecord.SetIntegerValue('MARKET_NO' , f_InRecord.GetIntegerValue('MARKET_NO'    ));
                    f_OutRecord.SetStringValue ('SYMBOL'    , f_IORecord.GetStringValue ('SYMBOL'       ));
                    f_OutRecord.SetStringValue ('NAME'      , f_IORecord.GetStringValue ('NAME'         ));

                    f_Factor := 1;
                    f_TimeDiffrence := 0;
                    if Assigned(g_MaterialCollection) then
                    begin
                        f_MaterialItem :=
                            g_MaterialCollection.Find(
                                f_OutRecord.GetIntegerValue('COUNTRY_NO' ),
                                f_OutRecord.GetIntegerValue('GROUP_NO'   ),
                                f_OutRecord.GetIntegerValue('MARKET_NO'  ),
                                g_SymbolCollection.GetOPSSymbol(f_Symbol));

                        if Assigned(f_MaterialItem) then
                        begin
                            f_TimeDiffrence := f_MaterialItem.m_TimeDiffrence;
                            f_Factor := Power(10, f_MaterialItem.m_Precision);
                        end;
                    end;

                    f_DateTime := TFNGlobal.ServerNow + f_TimeDiffrence;
                    f_OutRecord.SetStringValue ('DATE'          ,   TFNGlobal.DateToString_YYYYMMDD (f_DateTime));
                    f_OutRecord.SetStringValue ('TIME'          ,   TFNGlobal.TimeToString_HHMMSS   (f_DateTime));
                    f_OutRecord.SetDoubleValue ('CLOSE_PRICE'   ,   f_IORecord.GetIntegerValue('CLOSE_PRICE') / f_Factor);
                    if f_IORecord.GetStringValue('CHANGE_SIGN') = '-' then
                    begin
                        f_Sign := -1
                    end else
                    begin
                        f_Sign :=  1
                    end;
                    f_Change := f_Sign * f_IORecord.GetIntegerValue('CHANGE') / f_Factor;
                    f_OutRecord.SetDoubleValue('CHANGE'          , f_Change);
                    f_OutRecord.SetDoubleValue('CHANGERATE'      , f_IORecord.GetDoubleValue ('CHANGERATE'      ));
                    f_OutRecord.SetDoubleValue('OPEN_PRICE'      , f_IORecord.GetIntegerValue('OPEN_PRICE'      ) / f_Factor);
                    f_OutRecord.SetDoubleValue('HIGH_PRICE'      , f_IORecord.GetIntegerValue('HIGH_PRICE'      ) / f_Factor);
                    f_OutRecord.SetDoubleValue('LOW_PRICE'       , f_IORecord.GetIntegerValue('LOW_PRICE'       ) / f_Factor);
                    f_OutRecord.SetDoubleValue('TOTAL_VOLUME'    , f_IORecord.GetDoubleValue ('TOTAL_VOLUME'    ));
                    f_OutRecord.SetDoubleValue('BEST_OFFER_PRICE', f_IORecord.GetIntegerValue('BEST_OFFER_PRICE') / f_Factor);
                    f_OutRecord.SetDoubleValue('BEST_BID_PRICE'  , f_IORecord.GetIntegerValue('BEST_BID_PRICE'  ) / f_Factor);
                    f_OutRecord.SetDoubleValue('PREV_CLOSE'      , f_OutRecord.GetDoubleValue('CLOSE_PRICE'     ) - f_OutRecord.GetDoubleValue('CHANGE'));
                end;

            finally
                f_DataStream.Free;
            end;

            WriteMessage(f_QueryData, 'M00000', '정상처리 되었습니다.');
            ClearRQTable(IntToStr(nRqID));
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
                ClearRQTable(IntToStr(nRqID));
                StoreRecvData(f_QueryData);
            end;
        end;
    end;
    {$ENDREGION}

end;

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.OnWRRecvMSG(ASender: TObject; const cFlag: WideString; const szMsg: WideString);
var
    f_QueryData:CFNQueryData;

    f_RQID:Integer;
    f_FieldList:TStringList;

    f_MessageCode:String;
    f_MessageText:String;
begin
    f_FieldList := TStringList.Create();
    try
        f_FieldList.Clear;
        ExtractStrings([':'], [], PChar(szMsg), f_FieldList);

        if f_FieldList.Count >= 2 then
        begin
            f_RQID := TFNGlobal.atoi(f_FieldList[0]);
        end else
        begin
            f_RQID := 0;
        end;
    finally
        f_FieldList.Free;
    end;


    f_QueryData := GetRQTable(IntToStr(f_RQID));
    if not Assigned(f_QueryData) then exit;

    if SameText(cFlag, 'M') then
    begin
        MakeDefaultResponse(f_QueryData);

        f_MessageCode := 'M00000';
        f_MessageText := szMsg;

        if f_MessageCode = '00000' then f_MessageCode := 'M00000';
        if f_MessageCode = '00010' then f_MessageCode := 'M00000';

        if
            (Pos('오류', f_MessageText) > 0) OR
            (Pos('실패', f_MessageText) > 0) OR
            (Pos('잠시후에 사용하', f_MessageText) > 0)
            then
        begin
            if f_MessageCode = 'M00000' then  f_MessageCode := 'E10000';
        end;

        WriteMessage(f_QueryData, f_MessageCode, f_MessageText);

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

    end else
    begin

        MakeDefaultResponse(f_QueryData);

        WriteMessage(f_QueryData, 'M60001', szMsg);
        if f_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
        begin
            WriteMessage(f_QueryData, 'M99999', '비정상 처리되었습니다.');
        end else
        begin
            WriteMessage(f_QueryData, 'M00000', '정상처리 되었습니다.');
        end;

        ClearRQTable(IntToStr(f_RQID));
        StoreRecvData(f_QueryData);

    end;
end;

{$ENDREGION}

{$REGION '실시간 데이터 수신'}
//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.OnWRRecvRealData(ASender: TObject; nKey: Smallint; nDataLen: Smallint; const szData: WideString);
begin
    if m_StringStream = NIL then exit;
    if m_DataStream = NIL then exit;

    m_StringStream.Clear;
    m_StringStream.WriteString(szData);

    m_DataStream.Clear;
    m_StringStream.SaveToStream(m_DataStream);
    m_DataStream.Position := 0;

    //  시세
    if 17 = nKey then
    begin
        Process_RDM_OSTS1(m_DataStream);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.Process_RDM_OSTS1(ADataStream : TMemoryStream);
var
    f_StreamRecord:CFNStreamRecord;
    f_Record:CIORecord;

    f_Sign:Integer;
    f_Change:Double;

    f_Symbol:String;
    f_DateTime, f_TimeDiffrence:Double;
    f_MaterialItem:CFNMaterialItem;
    f_Factor:Double;

    f_Country, f_Group, f_Market:Integer;
begin
    if m_IODataSet_RDM_OSTS1 = NIL then exit;

    try
        ADataStream.Position := 0;
        m_IODataSet_RDM_OSTS1.ClearRecordList;
        m_IODataSet_RDM_OSTS1.DecodeData(ADataStream, 1);
    except
    end;

    if (m_IODataSet_RDM_OSTS1.RecordList.Count > 0) then
    begin
        try
            f_Record := CIORecord(m_IODataSet_RDM_OSTS1.RecordList.Items[0]);

            f_StreamRecord := CFNStreamRecord.Create;
            f_StreamRecord.SetPacketKey('QUOTE');

            f_Symbol := f_Record.GetStringValue ('SYMBOL');
            GetGategory(f_Symbol, f_Country, f_Group, f_Market);

            f_StreamRecord.SetIntegerValue('COUNTRY_NO'     , f_Country);
            f_StreamRecord.SetIntegerValue('GROUP_NO'       , f_Group);
            f_StreamRecord.SetIntegerValue('MARKET_NO'      , f_Market);

            f_Factor := 1;
            f_TimeDiffrence := 0;
            if
                Assigned(m_MaterialItem) and
                (m_MaterialItem.m_Country   = f_Country ) and
                (m_MaterialItem.m_Group     = f_Group   ) and
                (m_MaterialItem.m_Market    = f_Market  ) and
                (m_MaterialItem.m_Key    = g_SymbolCollection.GetOPSSymbol(f_Symbol))
            then begin
                f_TimeDiffrence := m_MaterialItem.m_TimeDiffrence;
                f_Factor := Power(10, m_MaterialItem.m_Precision);
            end else
            begin
                if Assigned(g_MaterialCollection) then
                begin
                    m_MaterialItem :=
                        g_MaterialCollection.Find(
                            f_Country,
                            f_Group,
                            f_Market,
                            g_SymbolCollection.GetOPSSymbol(f_Symbol));

                    if Assigned(m_MaterialItem) then
                    begin
                        f_TimeDiffrence := m_MaterialItem.m_TimeDiffrence;
                        f_Factor := Power(10, m_MaterialItem.m_Precision);
                    end;
                end;
            end;

            f_StreamRecord.SetStringValue('SYMBOL'          , f_Record.GetStringValue('SYMBOL'          ));

            f_DateTime := TFNGlobal.ServerNow + f_TimeDiffrence;
            f_StreamRecord.SetStringValue ('DATE'           , TFNGlobal.DateToString_YYYYMMDD(f_DateTime));
            f_StreamRecord.SetStringValue ('TIME'           , TFNGlobal.TimeToString_HHMMSS(f_DateTime));
            f_StreamRecord.SetStringValue('SIGN'            , f_Record.GetStringValue('SIGN'            ));

            if f_Record.GetStringValue('SIGN') = '-' then
            begin
                f_Sign := -1;
            end else
            begin
                f_Sign := 1;
            end;

            f_Change := f_Sign * f_Record.GetIntegerValue('CHANGE') / f_Factor;

            f_StreamRecord.SetDoubleValue('PREV_CLOSE'      , f_Record.GetIntegerValue('CLOSE_PRICE'     ) / f_Factor - f_Change, 2);
            f_StreamRecord.SetDoubleValue('CLOSE_PRICE'     , f_Record.GetIntegerValue('CLOSE_PRICE'     ) / f_Factor, 2);
            f_StreamRecord.SetDoubleValue('CHANGE'          , f_Change, 2);
            f_StreamRecord.SetDoubleValue('CHANGERATE'      , f_Record.GetDoubleValue ('CHANGERATE'      ), 2);
            f_StreamRecord.SetDoubleValue('BEST_OFFER_PRICE', f_Record.GetIntegerValue('BEST_OFFER_PRICE') / f_Factor, 2);
            f_StreamRecord.SetDoubleValue('BEST_BID_PRICE'  , f_Record.GetIntegerValue('BEST_BID_PRICE'  ) / f_Factor, 2);

            f_StreamRecord.SetDoubleValue('OPEN_PRICE'      , f_Record.GetIntegerValue('OPEN_PRICE'      ) / f_Factor, 2);
            f_StreamRecord.SetDoubleValue('HIGH_PRICE'      , f_Record.GetIntegerValue('HIGH_PRICE'      ) / f_Factor, 2);
            f_StreamRecord.SetDoubleValue('LOW_PRICE'       , f_Record.GetIntegerValue('LOW_PRICE'       ) / f_Factor, 2);

            f_StreamRecord.SetDoubleValue('VOLUME'          , f_Record.GetDoubleValue ('VOLUME'          ), 0);
            f_StreamRecord.SetDoubleValue('TOTAL_VOLUME'    , f_Record.GetDoubleValue ('TOTAL_VOLUME'    ), 0);
            f_StreamRecord.SetDoubleValue('TOTAL_VALUE'     , f_Record.GetDoubleValue ('TOTAL_VALUE'     ), 0);
            f_StreamRecord.SetDoubleValue('OPEN_VOLUME'     , f_Record.GetDoubleValue ('OPEN_VOLUME'     ), 0);

            StoreStreamData(f_StreamRecord);
            f_StreamRecord := NIL;

        except
        end;
    end;
end;
{$ENDREGION}

{$REGION '소켓의 접속이상'}
//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.OnWRSocketStatus(ASender: TObject; nStatus: Smallint);
begin
    if 0 = nStatus then
    begin
        LOG_WRITE(LOG_TYPE_ERROR, 'CFNHNCMEAgentManager', '우리선물의 통신이 종료되었습니다.');
        if Assigned(m_DisconnectEvent) then
        begin
            m_DisconnectEvent(Self);
        end;
    end;
end;
{$ENDREGION}

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.OnH5Receive(ASender: TObject; type_: Integer; pBytes: Integer; nBytes: Integer);
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
procedure CFNHNCMEAgentManager.ProcessFMX(AType: Integer; pBytes: Integer; nBytes: Integer);
var
    f_RQID:Integer;    
    LongWord  : LongRec;
begin  
    LongWord := LongRec(pBytes);
    f_RQID := LongWord.Lo;
    if (TR_GFNEWORDER = f_RQID) or (TR_GFJJORDER = f_RQID) or (TR_GFCSORDER = f_RQID) then
    begin
		ProcessOrder(AType, pBytes, nBytes);
    end else
    if (TR_ACCLIST = f_RQID) then
    begin
        ProcessAccountRT(AType, pBytes, nBytes);
    end else
    if (TR_VGFACC = f_RQID) then
    begin
        ProcessAccountVT(AType, pBytes, nBytes);
    end;

end;

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.ProcessAccountVT(AType: Integer; pBytes: Integer; nBytes: Integer);
var
    f_RQID:Integer;
    f_Key:Integer;
    f_ReceiveData:PAnsiChar;
    f_ReceiveSize:Integer;

    f_Data:PAnsiChar;
    f_DataSize:Integer;

    f_pTH5RPHead:pTH5RPHead;

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
    LongWord:LongRec;
    f_ReceiveBuffer : Array [0..15] of AnsiChar;
    f_Value : String;
    LValue : String;
    f_LineList:TStringList;
    f_FieldList:TStringList;
    LStringStrem : TStringStream;
    LLineIndex : Integer;
begin
    LongWord := LongRec(pBytes);
    f_Key := LongWord.Lo;
    f_ReceiveData   := PAnsiChar(nBytes);
    f_ReceiveSize   := LongWord.Hi;

    f_pTH5RPHead :=  pTH5RPHead(f_ReceiveData);

    f_RQID := TR_VGFACC;

    f_QueryData := GetRQTable(IntToStr(f_RQID));
    if not Assigned(f_QueryData) then exit;

    f_MessageCode := H5_ReadString(f_pTH5RPHead.ecode, sizeof(f_pTH5RPHead.ecode));

    if not SameText(f_MessageCode, '000000') then
    begin
        f_MessageText := Trim(H5_ReadString(f_pTH5RPHead.msg, sizeof(f_pTH5RPHead.msg)));
        WriteMessage(f_QueryData, f_MessageCode, f_MessageText);
        WriteMessage(f_QueryData, 'M99999', '비정상 처리되었습니다.');

        ClearRQTable(IntToStr(f_RQID));
        StoreRecvData(f_QueryData);
    end else
    begin
        f_LineList := TStringList.Create();
        f_FieldList := TStringList.Create();
        LStringStrem := TStringStream.Create;
        try
            f_Data := PAnsiChar(f_ReceiveData + sizeof(TH5RPHead));
            f_DataSize := f_ReceiveSize - sizeof(TH5RPHead);

            LStringStrem.Write(f_Data^, f_DataSize);

            MakeDefaultResponse(f_QueryData);
            f_OutDataSet := f_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);

            LStringStrem.Position := 0;
            f_Value := LStringStrem.ReadString(f_DataSize);
            f_LineList.Clear;
            ExtractStrings([#$A], [], PChar(f_Value), f_LineList);
            for LLineIndex := 0 to f_LineList.Count - 1 do
            begin
                f_FieldList.Clear;
                ExtractStrings([#$09], [], PChar(f_LineList[LLineIndex]), f_FieldList);

                if f_FieldList.Count >= 2 then
                begin
                    LValue := f_FieldList[0];
                    if (Copy(LValue, 9, 2) = '22') then
                    begin
                        f_OutRecord := CFNRecord.Create;
                        f_OutRecord.SetStringValue('ACCOUNT_NO'     , f_FieldList[0]);
                        f_OutRecord.SetStringValue('ACCOUNT_NAME'   , f_FieldList[1]);
                        f_OutRecord.SetStringValue('SERIAL_NO'      , '');
                        f_OutRecord.SetStringValue('CODE'           , '5A');
                        f_OutDataSet.RecordList.Add(f_OutRecord);
                    end;
                end;
            end;

            f_MessageCode := 'M00000';
            f_MessageText := Trim(H5_ReadString(f_pTH5RPHead.msg, sizeof(f_pTH5RPHead.msg)));
            WriteMessage(f_QueryData, f_MessageCode, f_MessageText);

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
        f_FieldList.Free;
        f_LineList.Free;
        LStringStrem.Free;
    end;
end;


//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.ProcessAccountRT(AType: Integer; pBytes: Integer; nBytes: Integer);
var
    f_RQID:Integer;
    f_Key:Integer;
    f_ReceiveData:PAnsiChar;
    f_ReceiveSize:Integer;

    f_Data:PAnsiChar;
    f_DataSize:Integer;

    f_pTH5RPHead:pTH5RPHead;

    f_MessageCode:String;
    f_MessageText:String;

    f_QueryData:CFNQueryData;
    f_OutDataSet : CFNDataSet;
    f_OutRecord : CFNRecord;

    LongWord:LongRec;
    LStringStrem : TStringStream;
    LIOHandler : CFNIOHandler;
    LIODataSet : CFNIODataSet;
    LIORecord : CFNIORecord;
    LRecordIndex:Integer;
    LValue : String;
begin
    LongWord := LongRec(pBytes);
    f_Key := LongWord.Lo;
    f_ReceiveData   := PAnsiChar(nBytes);
    f_ReceiveSize   := LongWord.Hi;

    f_pTH5RPHead :=  pTH5RPHead(f_ReceiveData);

    f_RQID := TR_ACCLIST;

    f_QueryData := GetRQTable(IntToStr(f_RQID));
    if not Assigned(f_QueryData) then exit;

    LStringStrem := TStringStream.Create;
    LIOHandler := Make_ACCOUNT_OUT(NIL);
    try
        LStringStrem.Write(f_ReceiveData^, f_ReceiveSize);

        MakeDefaultResponse(f_QueryData);
        f_OutDataSet := f_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);

        LStringStrem.Position := 0;
        LIOHandler.SetSourceData(LStringStrem);
        if (LIOHandler.DecodeData) then
        begin
            if LIOHandler.m_DataSetList.Count > 1 then
            begin
                f_MessageCode := '';
                f_MessageText := '';

                LIODataSet := LIOHandler.m_DataSetList.Items[0] as CFNIODataSet;
                if LIODataSet.RecordList.Count > 0 then
                begin
                    LIORecord := LIODataSet.RecordList.Items[0] as CFNIORecord;
                    f_MessageCode := LIORecord.GetStringValue('ERROR_CODE');
                    f_MessageText := LIORecord.GetStringValue('ERROR_TEXT');
                end;

                if not SameText(f_MessageCode, '0') then
                begin
                    WriteMessage(f_QueryData, f_MessageCode, f_MessageText);
                    WriteMessage(f_QueryData, 'M99999', '비정상 처리되었습니다.');

                    ClearRQTable(IntToStr(f_RQID));
                    StoreRecvData(f_QueryData);
                end else
                begin
                    LIODataSet := LIOHandler.m_DataSetList.Items[1] as CFNIODataSet;
                    for LRecordIndex := 0 to LIODataSet.RecordList.Count - 1 do
                    begin
                        LIORecord := LIODataSet.RecordList.Items[LRecordIndex] as CFNIORecord;

                        LValue := LIORecord.GetStringValue('ACCOUNT_NO');
                        if (Copy(LValue, 9, 2) = '22') then
                        begin
                            f_OutRecord := CFNRecord.Create;
                            f_OutRecord.SetStringValue('ACCOUNT_NO'     , LIORecord.GetStringValue('ACCOUNT_NO'));
                            f_OutRecord.SetStringValue('ACCOUNT_NAME'   , LIORecord.GetStringValue('ACCOUNT_NAME'));
                            f_OutRecord.SetStringValue('SERIAL_NO'      , '');
                            f_OutRecord.SetStringValue('CODE'           , '5A');
                            f_OutDataSet.RecordList.Add(f_OutRecord);
                        end;
                    end;

                    f_MessageCode := 'M00000';
                    WriteMessage(f_QueryData, f_MessageCode, f_MessageText);

                    ClearRQTable(IntToStr(f_RQID));
                    StoreRecvData(f_QueryData);
                end;
            end else
            begin
                WriteMessage(f_QueryData, 'M99999', '비정상 처리되었습니다.');
                f_QueryData.m_Response.SetErrorCode('M30001');
                f_OutRecord := CFNRecord.Create;
                f_OutRecord.SetStringValue('ERROR_CODE', 'M30001');
                f_OutRecord.SetStringValue('MESSAGE', '비정상 처리되었습니다.');
                f_QueryData.m_Response.m_ErrorDataSet.RecordList.Add(f_OutRecord);
                ClearRQTable(IntToStr(f_RQID));
                StoreRecvData(f_QueryData);
            end;
        end else
        begin
            WriteMessage(f_QueryData, 'M99999', '비정상 처리되었습니다.');
            f_QueryData.m_Response.SetErrorCode('M30001');
            f_OutRecord := CFNRecord.Create;
            f_OutRecord.SetStringValue('ERROR_CODE', 'M30001');
            f_OutRecord.SetStringValue('MESSAGE', '비정상 처리되었습니다.');
            f_QueryData.m_Response.m_ErrorDataSet.RecordList.Add(f_OutRecord);
            ClearRQTable(IntToStr(f_RQID));
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
            ClearRQTable(IntToStr(f_RQID));
            StoreRecvData(f_QueryData);
        end;
    end;
    LStringStrem.Free;
    LIOHandler.Free;
end;

//---------------------------------------------------------------------------
procedure CFNHNCMEAgentManager.ProcessOrder(AType: Integer; pBytes: Integer; nBytes: Integer);
var
    f_RQID:Integer;
    f_Key:Integer;
    f_ReceiveData:PAnsiChar;
    f_ReceiveSize:Integer;

    f_Data:PAnsiChar;
    f_DataSize:Integer;

    f_pTH5RPHead:pTH5RPHead;

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
    LongWord:LongRec;
    f_ReceiveBuffer : Array [0..15] of AnsiChar;
begin
    LongWord := LongRec(pBytes);
    f_Key := LongWord.Lo;

    f_ReceiveData   := PAnsiChar(nBytes); 
    f_ReceiveSize   := LongWord.Hi;

    f_pTH5RPHead :=  pTH5RPHead(f_ReceiveData);

    f_RQID := H5_ReadInteger(f_pTH5RPHead.apik, 6);

    f_QueryData := GetRQTable(IntToStr(f_RQID));
    if not Assigned(f_QueryData) then exit;

    f_MessageCode := H5_ReadString(f_pTH5RPHead.ecode, sizeof(f_pTH5RPHead.ecode));

    if not SameText(f_MessageCode, '000000') then
    begin
        f_MessageText := Trim(H5_ReadString(f_pTH5RPHead.msg, sizeof(f_pTH5RPHead.msg)));
        WriteMessage(f_QueryData, f_MessageCode, f_MessageText);
        WriteMessage(f_QueryData, 'M99999', '비정상 처리되었습니다.');

        ClearRQTable(IntToStr(f_RQID));
        StoreRecvData(f_QueryData);
    end else
    begin
        try
            f_Data := PAnsiChar(f_ReceiveData + sizeof(TH5RPHead));
            f_DataSize := f_ReceiveSize - sizeof(TH5RPHead);

            MakeDefaultResponse(f_QueryData);
            f_OutDataSet := f_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
            f_OutRecord := f_OutDataSet.RecordList.Items[0] as CFNRecord;

            {$REGION '주문번호를 추출한다'}
            TFNGlobal.memset(f_ReceiveBuffer, 0, 15);
            TFNGlobal.memcpy(f_ReceiveBuffer, f_Data, 14);
            f_OrderNo := Trim(f_ReceiveBuffer);

            f_OutRecord.SetStringValue('ORDER_NO', f_OrderNo);

            if (f_OrderNo <> '') AND (f_OrderNo <> '0') then
            begin
                LOG_WRITE(LOG_TYPE_INFO, 'CFNHNCMEAgentManager',
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
                LOG_WRITE(LOG_TYPE_ERROR, 'CFNHNCMEAgentManager',
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
            f_MessageText := Trim(H5_ReadString(f_pTH5RPHead.msg, sizeof(f_pTH5RPHead.msg)));
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
procedure CFNHNCMEAgentManager.ParseDealData(AData:String; ARecord : CIORecord);
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
procedure CFNHNCMEAgentManager.ProcessDeal(AType: Integer; pBytes: Integer; nBytes: Integer);
var
    f_StreamRecord:CFNStreamRecord;
    f_SubscribeKey : String;

    f_NValue:Integer;
    f_DValue:Double;
    f_SValue:String;
    f_ORDR_TP:String;
    f_ACPT_TP:String;

    f_DataType:Integer;

    f_Buffer:PAnsiChar;
    f_Record : CIORecord;
    f_PushKey:String;       
    LongWord  : LongRec; 
    f_ReceiveData:PAnsiChar;
    f_ReceiveSize:Integer;
    f_KEY, f_Pos:Integer;
begin
    f_Record    := CIORecord.Create;
    try                            
        f_Buffer := NIL;
        
        LongWord := LongRec(pBytes);
        f_KEY         :=  LongWord.Lo; 
        f_ReceiveSize := LongWord.Hi;
        f_ReceiveData := PAnsiChar(nBytes);
        f_ReceiveSize := StrLen(f_ReceiveData);

        ReallocMem(f_Buffer, f_ReceiveSize+1);
        TFNGlobal.memset(f_Buffer, $0, f_ReceiveSize+1);
        TFNGlobal.memcpy(f_Buffer, f_ReceiveData, f_ReceiveSize);
        ParseDealData(f_Buffer, f_Record);   
        FreeMem(f_Buffer);

        f_StreamRecord := NIL;
        f_ORDR_TP := Trim(f_Record.GetStringValue('943'));
        f_ACPT_TP := Trim(f_Record.GetStringValue('905'));

        if (f_ORDR_TP = 'T') then
        begin

            {$REGION '주문체결'}
            try
                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('ORDER_TRADE');

                f_PushKey := Trim(f_Record.GetStringValue('904')) + Trim(f_Record.GetStringValue('902'));
                f_StreamRecord.SetStringValue('USERID'      , Trim(f_Record.GetStringValue('978')));
                f_StreamRecord.SetStringValue('ACCOUNT_NO'  , Trim(f_Record.GetStringValue('904')) + Trim(f_Record.GetStringValue('902')));
                f_StreamRecord.SetStringValue('SYMBOL'      , Trim(f_Record.GetStringValue('925')));

                f_SValue := Trim(f_Record.GetStringValue('908'));
                if (f_SValue = 'S') then f_NValue := 1              //  매도
                else if (f_SValue = 'B')  then f_NValue := 2        //  매수
                else f_NValue := 0;
                if f_DataType = ODT_AMENDED then f_NValue := 3
                else if f_DataType = ODT_CANCEL then f_NValue := 4;
                f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_SValue := Trim(f_Record.GetStringValue('941'));
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , f_NValue);

                f_SValue := Trim(f_Record.GetStringValue('940'));
                f_DValue := TFNGlobal.atof(f_SValue);
                f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , f_DValue);

                f_SValue := Trim(f_Record.GetStringValue('971'));
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_StreamRecord.SetIntegerValue('TRADE_VOLUME'   , f_NValue);

                f_SValue := Trim(f_Record.GetStringValue('970'));
                f_DValue := TFNGlobal.atof(f_SValue);
                f_StreamRecord.SetDoubleValue('TRADE_PRICE'     , f_DValue);

                f_SValue := Trim(f_Record.GetStringValue('939'));
                //f_SValue := Copy(f_SValue, 9, 6);
                //f_SValue := IntToStr(TFNGlobal.atoi(f_SValue));
                f_StreamRecord.SetStringValue('ORDER_NO'        , f_SValue);

                f_SValue := Trim(f_Record.GetStringValue('944'));
                //f_SValue := Copy(f_SValue, 9, 6);
                //f_SValue := IntToStr(TFNGlobal.atoi(f_SValue));
                f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , f_SValue);

                f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , '');

                f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNHMCAgentManager',
                '주문접수; '        +
                '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')                             + '; ' +
                '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')                                 + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))              + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))               + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))                + '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)  + '; ' +
                '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')                               + '; ' +
                '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')                           + '; '
                );

                StoreStreamData(f_StreamRecord);
                f_StreamRecord := NIL;

            finally
                if f_StreamRecord <> NIL then f_StreamRecord.Free;
            end;
            {$ENDREGION}

        end else
        begin
            if ('6' = f_ACPT_TP) then
            begin

                {$REGION '거래소접수'}
                try
                    f_StreamRecord := CFNStreamRecord.Create;
                    f_StreamRecord.SetPacketKey('ORDER_RECEIVE');

                    f_PushKey := Trim(f_Record.GetStringValue('904')) + Trim(f_Record.GetStringValue('902'));
                    f_StreamRecord.SetStringValue('USERID'      , Trim(f_Record.GetStringValue('978')));
                    f_StreamRecord.SetStringValue('ACCOUNT_NO'  , Trim(f_Record.GetStringValue('904')) + Trim(f_Record.GetStringValue('902')));
                    f_StreamRecord.SetStringValue('SYMBOL'      , Trim(f_Record.GetStringValue('925')));

                    f_SValue := Trim(f_Record.GetStringValue('943'));
                    if (f_SValue = 'M') then
                    begin
                        f_DataType := ODT_AMENDED;
                    end else
                    if (f_SValue = 'C') then
                    begin
                        f_DataType := ODT_CANCEL;
                    end else
                    begin
                        f_DataType := ODT_NEW;
                    end;
                    f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , f_DataType);

                    f_SValue := Trim(f_Record.GetStringValue('908'));
                    if (f_SValue = 'S') then f_NValue := 1              //  매도
                    else if (f_SValue = 'B')  then f_NValue := 2        //  매수
                    else f_NValue := 0;
                    if f_DataType = ODT_AMENDED then f_NValue := 3
                    else if f_DataType = ODT_CANCEL then f_NValue := 4;
                    f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                    f_SValue := Trim(f_Record.GetStringValue('941'));
                    f_NValue := TFNGlobal.atoi(f_SValue);
                    f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , f_NValue);

                    f_SValue := Trim(f_Record.GetStringValue('940'));
                    f_DValue := TFNGlobal.atof(f_SValue);
                    f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , f_DValue);

                    f_SValue := Trim(f_Record.GetStringValue('939'));
                    //f_SValue := Copy(f_SValue, 9, 6);
                    //f_SValue := IntToStr(TFNGlobal.atoi(f_SValue));
                    f_StreamRecord.SetStringValue('ORDER_NO'        , f_SValue);

                    f_SValue := Trim(f_Record.GetStringValue('944'));
                    //f_SValue := Copy(f_SValue, 9, 6);
                    //f_SValue := IntToStr(TFNGlobal.atoi(f_SValue));
                    f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , f_SValue);

                    f_SValue := '';
                    f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , '');

                    f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                    f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                    LOG_WRITE(LOG_TYPE_INFO, 'CFNHMCAgentManager',
                    '주문접수; '        +
                    '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')                             + '; ' +
                    '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')                                 + '; ' +
                    '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))              + '; ' +
                    '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))               + '; ' +
                    '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))                + '; ' +
                    '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)  + '; ' +
                    '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')                               + '; ' +
                    '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')                           + '; '
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

                    f_PushKey := Trim(f_Record.GetStringValue('904')) + Trim(f_Record.GetStringValue('902'));
                    f_StreamRecord.SetStringValue('USERID'      , Trim(f_Record.GetStringValue('978')));
                    f_StreamRecord.SetStringValue('ACCOUNT_NO'  , Trim(f_Record.GetStringValue('904')) + Trim(f_Record.GetStringValue('902')));
                    f_StreamRecord.SetStringValue('SYMBOL'      , Trim(f_Record.GetStringValue('925')));

                    f_SValue := Trim(f_Record.GetStringValue('943'));
                    if (f_SValue = 'M') then
                    begin
                        f_DataType := ODT_AMENDED;
                    end else
                    if (f_SValue = 'C') then
                    begin
                        f_DataType := ODT_CANCEL;
                    end else
                    begin
                        f_DataType := ODT_NEW;
                    end;
                    f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , f_DataType);

                    f_SValue := Trim(f_Record.GetStringValue('908'));
                    if (f_SValue = 'S') then f_NValue := 1              //  매도
                    else if (f_SValue = 'B')  then f_NValue := 2        //  매수
                    else f_NValue := 0;
                    if f_DataType = ODT_AMENDED then f_NValue := 3
                    else if f_DataType = ODT_CANCEL then f_NValue := 4;
                    f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                    f_SValue := Trim(f_Record.GetStringValue('941'));
                    f_NValue := TFNGlobal.atoi(f_SValue);
                    f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , f_NValue);

                    f_SValue := Trim(f_Record.GetStringValue('940'));
                    f_DValue := TFNGlobal.atof(f_SValue);
                    f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , f_DValue);

                    f_SValue := Trim(f_Record.GetStringValue('939'));
                    //f_SValue := Copy(f_SValue, 9, 6);
                    //f_SValue := IntToStr(TFNGlobal.atoi(f_SValue));
                    f_StreamRecord.SetStringValue('ORDER_NO'        , f_SValue);

                    f_SValue := Trim(f_Record.GetStringValue('944'));
                    //f_SValue := Copy(f_SValue, 9, 6);
                    //f_SValue := IntToStr(TFNGlobal.atoi(f_SValue));
                    f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , f_SValue);

                    f_SValue := '';
                    f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , '');

                    f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                    f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                    LOG_WRITE(LOG_TYPE_INFO, 'CFNHMCAgentManager',
                    '주문접수; '        +
                    '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')                             + '; ' +
                    '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')                                 + '; ' +
                    '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))              + '; ' +
                    '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))               + '; ' +
                    '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))                + '; ' +
                    '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)  + '; ' +
                    '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')                               + '; ' +
                    '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')                           + '; '
                    );

                    StoreStreamData(f_StreamRecord);
                    f_StreamRecord := NIL;

                finally
                    if f_StreamRecord <> NIL then f_StreamRecord.Free;
                end;
                {$ENDREGION}

            end else
            if ('7' = f_ACPT_TP) or ('8' = f_ACPT_TP) then
            begin

                {$REGION '주문오류 주문거부'}
                try
                    f_StreamRecord := CFNStreamRecord.Create;
                    f_StreamRecord.SetPacketKey('ORDER_REJECT');

                    f_PushKey := Trim(f_Record.GetStringValue('904')) + Trim(f_Record.GetStringValue('902'));
                    f_StreamRecord.SetStringValue('USERID'      , Trim(f_Record.GetStringValue('978')));
                    f_StreamRecord.SetStringValue('ACCOUNT_NO'  , Trim(f_Record.GetStringValue('904')) + Trim(f_Record.GetStringValue('902')));
                    f_StreamRecord.SetStringValue('SYMBOL'      , Trim(f_Record.GetStringValue('925')));

                    f_SValue := Trim(f_Record.GetStringValue('943'));
                    if (f_SValue = 'M') then
                    begin
                        f_DataType := ODT_AMENDED;
                    end else
                    if (f_SValue = 'C') then
                    begin
                        f_DataType := ODT_CANCEL;
                    end else
                    begin
                        f_DataType := ODT_NEW;
                    end;
                    f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , f_DataType);

                    f_SValue := Trim(f_Record.GetStringValue('908'));
                    if (f_SValue = 'S') then f_NValue := 1              //  매도
                    else if (f_SValue = 'B')  then f_NValue := 2        //  매수
                    else f_NValue := 0;
                    if f_DataType = ODT_AMENDED then f_NValue := 3
                    else if f_DataType = ODT_CANCEL then f_NValue := 4;
                    f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                    f_SValue := Trim(f_Record.GetStringValue('941'));
                    f_NValue := TFNGlobal.atoi(f_SValue);
                    f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , f_NValue);

                    f_SValue := Trim(f_Record.GetStringValue('940'));
                    f_DValue := TFNGlobal.atof(f_SValue);
                    f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , f_DValue);

                    f_SValue := Trim(f_Record.GetStringValue('939'));
                    //f_SValue := Copy(f_SValue, 9, 6);
                    //f_SValue := IntToStr(TFNGlobal.atoi(f_SValue));
                    f_StreamRecord.SetStringValue('ORDER_NO'        , f_SValue);

                    f_SValue := Trim(f_Record.GetStringValue('944'));
                    //f_SValue := Copy(f_SValue, 9, 6);
                    //f_SValue := IntToStr(TFNGlobal.atoi(f_SValue));
                    f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , f_SValue);

                    f_SValue := '';
                    f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , '거부');

                    f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                    f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                    LOG_WRITE(LOG_TYPE_INFO, 'CFNHMCAgentManager',
                    '주문접수; '        +
                    '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')                             + '; ' +
                    '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')                                 + '; ' +
                    '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))              + '; ' +
                    '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))               + '; ' +
                    '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))                + '; ' +
                    '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)  + '; ' +
                    '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')                               + '; ' +
                    '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')                           + '; '
                    );

                    LOG_WRITE(LOG_TYPE_INFO, 'CFNHMCAgentManager',
                    '주문접수; '        +
                    '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')                             + '; ' +
                    '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')                                 + '; ' +
                    '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))              + '; ' +
                    '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))               + '; ' +
                    '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))                + '; ' +
                    '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)  + '; ' +
                    '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')                               + '; ' +
                    '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')                           + '; '
                    );

                    StoreStreamData(f_StreamRecord);
                    f_StreamRecord := NIL;

                finally
                    if f_StreamRecord <> NIL then f_StreamRecord.Free;
                end;
                {$ENDREGION}

            end;
        end;
    finally
        f_Record.Free;
    end;
end;

end.
