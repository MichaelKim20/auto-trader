//**************************************************************************//
//  FileName        :   FNWRAgentManager.pas
//  Author          :   김무근 작성
//  Date            :   2012년 7월 10일
//  Description     :   우리선물사 API를 통해, 시세와 주문을 구현하기 위한 클래스
//**************************************************************************//
{우리선물사 API를 통해, 시세와 주문을 구현하기 위한 클래스}
Unit FNWRAgentManager_KSFCME;

interface

uses
    Dialogs, Messages, WinProcs, SysUtils, Forms, ActiveX, WinTypes, Classes, SyncObjs,
    Contnrs, IniFiles, VarUtils, Variants, Math, FNDataSet, FNDataDelivery, FNIOHandler,
    FNAgentManager, WRAXLib_TLB, IODataSet;

const
    RQDATA_ERROR        =   69; //      'E'
    RQDATA_MESSAGE	    =   77; //		'M'
    RQDATA_RELEASE      =   82; //      'R'
    RQDATA_DATA			=   68; //      'D'


type
    ///<author>김무근</author>
    ///<version>1.0</version>
    ///<since>2012.07.10</since>
    ///<Comment>우리선물 API를 이용하여 필요한 기능을 확장한 클래스</Comment>
    CFNWRAgentManager_KSFCME = class(CFNAgentManager)
    public
        ///<Comment>생성자</Comment>
        Constructor Create(AQueryThreadCount:Integer = 1);

        ///<Comment>파괴자</Comment>
        Destructor Destroy; override;

        ///<Comment>증권사 API OCX를 등록한다.</Comment>
        procedure AssignAgent(p_Agent:TWRAX);

        ///<Comment>메인 윈도우의 핸들을 등록한다.</Comment>
        procedure AssignHandle(p_Handle:HWND);

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
        ///<Comment>증권사 연결 OCX</Comment>
        m_Agent     :   TWRAX;

        ///<Comment>메인 윈도우의 핸들</Comment>
        m_Handle    :   HWND;

        ///<Comment>각종 실시간 데이터의 구조를 분석할 때 사용한다.</Comment>
        m_DataStream : TMemoryStream;
        m_StringStream : TStringStream;

	    m_RegistRealTableLock : TCriticalSection;
        m_RegistRealTable : Array[0..MAX_MAPCOUNT-1] of THashedStringList;

        m_IOHandler_SC_ACCOUNT_TR_0010_OUT : CFNIOHandler;
        m_IOHandler_CKQ52010_OUT : CFNIOHandler;
        m_IOHandler_SC_ORDER_TR_0210_OUT : CFNIOHandler;

        m_IODataSet_SB_CME_FUT_EXEC : CIODataSet;
        m_IODataSet_SB_ORDER_EXEC : CIODataSet;

        procedure SC_ACCOUNT_TR_0010(p_QueryData: CFNQueryData);

        ///<Comment>선물시세 조회 패킷을 만들어서 Agent에 전달한다.</Comment>
        procedure SC_QUOTE_TR_0210(p_QueryData:CFNQueryData);

        ///<Comment>선물주문 패킷을 만들어서 Agent에 전달한다.</Comment>
        procedure SC_ORDER_TR_0210(p_QueryData:CFNQueryData);

        ///<Comment>선물종목 마스트를 처리한다.</Comment>
        procedure SC_CODE_TR_0030(p_QueryData:CFNQueryData);

        procedure MakeDefaultResponse(p_QueryData:CFNQueryData);

        ///<Comment>패킷중 에러코드와 메세지를 추가하는 부분</Comment>
        procedure WriteMessage(p_QueryData: CFNQueryData; sErrorCode, sMsg: WideString);

        ///<Comment>패킷중 에러코드와 메세지를 추가하는 부분</Comment>
        procedure WriteError(p_QueryData: CFNQueryData; sErrorCode:WideString);

        procedure SetSBID(AMapType: Integer; AKey: String; AValue: Integer);
        procedure ClearSBID(AMapType:Integer; AKey:String);
        function  GetSBID(AMapType:Integer; AKey:String):Integer;

        procedure OnRecvData(ASender: TObject; DataType: Smallint; const TrCode: WideString; RqID: Smallint; DataSize: Integer; var szData: WideString);
        procedure OnRecvRealData(ASender: TObject; const TrCode: WideString; const KeyValue: WideString; RealID: Smallint; DataSize: Integer; const szData: WideString);
        procedure OnNetConnected(ASender: TObject);
        procedure OnNetDisconnected(ASender: TObject);

        procedure Process_SB_ORDER_EXEC(AKeyValue: WideString; ARealID: Smallint; ADataStream : TMemoryStream);
        procedure Process_SB_CME_FUT_EXEC(AKeyValue: WideString; ARealID: Smallint; ADataStream : TMemoryStream);

        procedure OnTimeout(p_QueryData:CFNQueryData);

    public
        property Handle : HWND read m_Handle write AssignHandle;

    end;

implementation

uses
    FNGlobal, FNGlobalVariable, WideStrUtils, CommonTRMaker, FNTradeSystem, WRIOMaker, FNCommonVariable;

//---------------------------------------------------------------------------
procedure CFNWRAgentManager_KSFCME.AssignAgent(p_Agent: TWRAX);
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
        m_Agent.OnRecvData := OnRecvData;
        m_Agent.OnRecvRealData := OnRecvRealData;
        m_Agent.OnNetConnected := OnNetConnected;
        m_Agent.OnNetDisconnected := OnNetDisconnected;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNWRAgentManager_KSFCME.AssignHandle(p_Handle: HWND);
begin
    m_Handle := p_Handle;
end;

//---------------------------------------------------------------------------
Constructor CFNWRAgentManager_KSFCME.Create(AQueryThreadCount:Integer = 1);
begin
    inherited Create(AQueryThreadCount);

    m_DataStream := TMemoryStream.Create;
    m_StringStream := TStringStream.Create;

    m_RegistRealTable[0] := THashedStringList.Create;
    m_RegistRealTable[1] := THashedStringList.Create;
    m_RegistRealTable[2] := THashedStringList.Create;

    m_RegistRealTableLock := TCriticalSection.Create;


    m_IOHandler_SC_ACCOUNT_TR_0010_OUT := Make_BAQ18104_OUT(NIL);
    m_IOHandler_CKQ52010_OUT := Make_CKQ52010_OUT(NIL);
    m_IOHandler_SC_ORDER_TR_0210_OUT := Make_BTO3110X_OUT(NIL);

    m_IODataSet_SB_ORDER_EXEC := Make_SB_ORDER_EXEC(NIL);
    m_IODataSet_SB_CME_FUT_EXEC := Make_SB_CME_FUT_EXEC(NIL);
end;

//---------------------------------------------------------------------------
Destructor CFNWRAgentManager_KSFCME.Destroy;
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

    m_IOHandler_SC_ACCOUNT_TR_0010_OUT.Free;
    m_IOHandler_CKQ52010_OUT.Free;
    m_IOHandler_SC_ORDER_TR_0210_OUT.Free;

    m_IODataSet_SB_ORDER_EXEC.Free;
    m_IODataSet_SB_CME_FUT_EXEC.Free;

    inherited Destroy;
end;

//---------------------------------------------------------------------------
procedure CFNWRAgentManager_KSFCME.SetSBID(AMapType:Integer; AKey:String; AValue:Integer);
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
procedure CFNWRAgentManager_KSFCME.ClearSBID(AMapType:Integer; AKey:String);
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
function CFNWRAgentManager_KSFCME.GetSBID(AMapType:Integer; AKey:String):Integer;
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
//  선물 스트리밍 시세 등록
procedure CFNWRAgentManager_KSFCME.SubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
    f_SBID:Integer;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := MakeStreamSubscribeKey(ACountry, AGroup, AMarket, ASymbol);
    if m_STSubscribeTable[MAP_CURRENT].AddKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        if 0 = ACountry then
        begin
            if 2 = AGroup then
            begin
                if 0 = AMarket then
                begin
                    f_SBID := m_Agent.RegistRealData('SB_FUT_EXEC', ASymbol);
                    SetSBID(MAP_CURRENT, f_SubscribeKey, f_SBID);
                end else
                if 2 = AMarket then
                begin
                    f_SBID := m_Agent.RegistRealData('SB_CME_FUT_EXEC', ASymbol);
                    SetSBID(MAP_CURRENT, f_SubscribeKey, f_SBID);
                end;
            end else
            if 3 = AGroup then
            begin
                f_SBID := m_Agent.RegistRealData('SB_OPT_EXEC', ASymbol);
                SetSBID(MAP_CURRENT, f_SubscribeKey, f_SBID);
            end;
        end;
    end;
end;

//---------------------------------------------------------------------------
//  선물 스트리밍 호가 등록
procedure CFNWRAgentManager_KSFCME.SubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
    f_SBID:Integer;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := MakeStreamSubscribeKey(ACountry, AGroup, AMarket, ASymbol);
    if m_STSubscribeTable[MAP_BIDOFFER].AddKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        if 0 = ACountry then
        begin
            if 2 = AGroup then
            begin
                if 0 = AMarket then
                begin
                    f_SBID := m_Agent.RegistRealData('SB_FUT_HOGA', ASymbol);
                    SetSBID(MAP_BIDOFFER, f_SubscribeKey, f_SBID);
                end else
                if 2 = AMarket then
                begin
                    f_SBID := m_Agent.RegistRealData('SB_CME_FUT_HOGA', ASymbol);
                    SetSBID(MAP_CURRENT, f_SubscribeKey, f_SBID);
                end;
            end else
            if 3 = AGroup then
            begin
                f_SBID := m_Agent.RegistRealData('SB_OPT_HOGA' , ASymbol);
                SetSBID(MAP_BIDOFFER, f_SubscribeKey, f_SBID);
            end;
        end;
    end;
end;

//---------------------------------------------------------------------------
//  선물 스트리밍 체결통보 등록
procedure CFNWRAgentManager_KSFCME.SubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = '');
var
    f_SBID:Integer;
begin
    if not Assigned(m_Agent) then exit;
    if m_STSubscribeTable[MAP_USERTRADE].AddKeyValue(AUserID, ADataDelivery) then
    begin
        f_SBID := m_Agent.RegistRealData('SB_ORDER_EXEC', '');
        SetSBID(MAP_USERTRADE, AUserID, f_SBID);
    end;
end;

//---------------------------------------------------------------------------
//  선물 스트리밍 시세 등록 해지
procedure CFNWRAgentManager_KSFCME.UnsubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
    f_SBID:Integer;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := MakeStreamSubscribeKey(ACountry, AGroup, AMarket, ASymbol);

    if m_STSubscribeTable[MAP_CURRENT].DeleteKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        if 0 = ACountry then
        begin
            if 2 = AGroup then
            begin
                if 0 = AMarket then
                begin
                    f_SBID := GetSBID(MAP_CURRENT, f_SubscribeKey);
                    if f_SBID <> -1 then m_Agent.UnregistRealData(f_SBID);
                    ClearSBID(MAP_CURRENT, f_SubscribeKey);
                end else
                if 2 = AMarket then
                begin
                    f_SBID := GetSBID(MAP_CURRENT, f_SubscribeKey);
                    if f_SBID <> -1 then m_Agent.UnregistRealData(f_SBID);
                    ClearSBID(MAP_CURRENT, f_SubscribeKey);
                end;
            end else
            if 3 = AGroup then
            begin
                f_SBID := GetSBID(MAP_CURRENT, f_SubscribeKey);
                if f_SBID <> -1 then m_Agent.UnregistRealData(f_SBID);
                ClearSBID(MAP_CURRENT, f_SubscribeKey);
            end;
        end;
    end;
end;

//---------------------------------------------------------------------------
//  선물 스트리밍 호가 등록 해지
procedure CFNWRAgentManager_KSFCME.UnsubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
    f_SBID:Integer;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := MakeStreamSubscribeKey(ACountry, AGroup, AMarket, ASymbol);

    if m_STSubscribeTable[MAP_BIDOFFER].DeleteKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        if 0 = ACountry then
        begin
            if 2 = AGroup then
            begin
                if 0 = AMarket then
                begin
                    f_SBID := GetSBID(MAP_BIDOFFER, f_SubscribeKey);
                    if f_SBID <> -1 then m_Agent.UnregistRealData(f_SBID);
                    ClearSBID(MAP_CURRENT, f_SubscribeKey);
                end else
                if 2 = AMarket then
                begin
                    f_SBID := GetSBID(MAP_BIDOFFER, f_SubscribeKey);
                    if f_SBID <> -1 then m_Agent.UnregistRealData(f_SBID);
                    ClearSBID(MAP_CURRENT, f_SubscribeKey);
                end;
            end else
            if 3 = AGroup then
            begin
                f_SBID := GetSBID(MAP_BIDOFFER, f_SubscribeKey);
                if f_SBID <> -1 then m_Agent.UnregistRealData(f_SBID);
                ClearSBID(MAP_BIDOFFER, f_SubscribeKey);
            end;
        end;
    end;
end;

//---------------------------------------------------------------------------
//  선물 스트리밍 체결통보 등록 해지
procedure CFNWRAgentManager_KSFCME.UnsubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = '');
var
    f_SBID:Integer;
begin
    if not Assigned(m_Agent) then exit;
    if m_STSubscribeTable[MAP_USERTRADE].DeleteKeyValue(AUserID, ADataDelivery) then
    begin
        f_SBID := GetSBID(MAP_USERTRADE, AUserID);
        if f_SBID <> -1 then m_Agent.UnregistRealData(f_SBID);
        ClearSBID(MAP_USERTRADE, AUserID);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNWRAgentManager_KSFCME.ReSubscribeAll;
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
    if Assigned(m_Agent) then
    begin
        m_Agent.OnRecvData := OnRecvData;
        m_Agent.OnRecvRealData := OnRecvRealData;
        m_Agent.OnNetConnected := OnNetConnected;
        m_Agent.OnNetDisconnected := OnNetDisconnected;
    end;

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

        f_KeyList := m_STSubscribeTable[MAP_USERTRADE].GetAllKeys;
        if f_KeyList <> NIL then
        begin
            for f_Index := 0 to f_KeyList.Count - 1 do
            begin
                f_Key := f_KeyList[f_Index];

                f_SBID := m_Agent.RegistRealData('SB_ORDER_EXEC', '');
                SetSBID(MAP_USERTRADE, f_Key, f_SBID);
            end;
            f_KeyList.Free;
        end;

    finally
    end;
end;

//---------------------------------------------------------------------------
//  Agent로 요청한 요청패킷을 하나 씩 꺼내 분석하여, 그 업무에 맞는 Agent내 함수를 이용하여 증권사로 요청을 한다.
procedure CFNWRAgentManager_KSFCME.DoQueryWork(AThreadIndex:Integer);
var
    f_QueryData:CFNQueryData;
begin
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
        Sleep(200);
    end else
    if f_QueryData.m_ServiceID = 'SC_CODE' then
    begin
        //  선물 마스트
        if (f_QueryData.m_TRCode = 'TR_0030') then
        begin
            SC_CODE_TR_0030(f_QueryData);
        end else
        begin
            WriteError(f_QueryData, 'M10001');
            StoreRecvData(f_QueryData);
        end;
        Sleep(200);
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
        Sleep(200);
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
        Sleep(100);
    end else
    begin
        WriteError(f_QueryData, 'M10001');
        StoreRecvData(f_QueryData);
    end;
    DoCheckTimeout;
end;

//---------------------------------------------------------------------------
procedure CFNWRAgentManager_KSFCME.DoCheckTimeout;
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
                            '요청타임아웃처리; ' +
                            'ServiceID:'           +   f_QueryData.m_ServiceID + '; ' +
                            'TRCode:'             +   f_QueryData.m_TRCode + '; '
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
//  패킷중 에러코드와 메세지를 추가하는 부분
procedure CFNWRAgentManager_KSFCME.WriteMessage(p_QueryData: CFNQueryData; sErrorCode, sMsg: WideString);
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
//  패킷중 에러코드와 메세지를 추가하는 부분
procedure CFNWRAgentManager_KSFCME.WriteError(p_QueryData: CFNQueryData; sErrorCode:WideString);
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
//  선물주문 패킷을 만들어서 Agent에 전달한다.
procedure CFNWRAgentManager_KSFCME.SC_ORDER_TR_0210(p_QueryData: CFNQueryData);
var
    f_DataSet           :   CFNDataSet;
    f_Record            :   CFNRecord;
    f_AccountNo         :   String;
    f_Password          :   String;
    f_Symbol            :   String;
    f_OrderCommand      :   Integer;
    f_OrderVolume       :   Integer;
    f_OrderPrice        :   Double;
    f_nBuySell:Integer;
    f_nDataType:Integer;
    f_nPriceType:Integer;
    f_sPriceType:String;
begin
    try
        f_DataSet := p_QueryData.m_Request.GetDataSet(DATASETID_IN_01);
        if Assigned(f_DataSet) then
        begin
            if (0 < f_DataSet.RecordList.Count) then
            begin
                f_Record := CFNRecord(f_DataSet.RecordList.Items[0]);
                f_AccountNo     := f_Record.GetStringValue ('ACCOUNT_NO');          //  계좌번호
                f_Password      := f_Record.GetStringValue ('PASSWORD');            //  계좌비번
                f_Symbol        := f_Record.GetStringValue ('SYMBOL');              //  종목코드
                f_OrderCommand  := f_Record.GetIntegerValue('ORDER_COMMAND');       //  1 : 매도, 2 : 매수, 3 : 정정, 4 : 취소
                f_OrderVolume   := f_Record.GetIntegerValue('ORDER_VOLUME');        //  주문량
                f_OrderPrice    := f_Record.GetDoubleValue ('ORDER_PRICE');         //  주문가격

                f_sPriceType    := f_Record.GetStringValue('PRICETYPE');            //  '01' : 지정가, '02' : 시장가

                if (f_sPriceType = '01') then
                begin
                    f_nPriceType := 1;  //(지정가:1, 시장가:2, 조건부지정가:3, 최유리지정가:4)
                end else
                if (f_sPriceType = '02') then
                begin
                    f_nPriceType := 2;  //(지정가:1, 시장가:2, 조건부지정가:3, 최유리지정가:4)
                end else
                begin
                    f_nPriceType    := atoi(f_sPriceType);
                end;

                f_nDataType     := f_Record.GetIntegerValue('DATATYPE');            //  1 : 신규, 2 : 정정, 3 : 취소
                f_nBuySell      := f_Record.GetIntegerValue('BUYSELL');             //  1 : BUY, 2 : SELL

                if (f_OrderCommand = 1) or (f_OrderCommand = 2) then
                begin
                (*
                function SendCMENewOrder(
                        const szAccNum: WideString;
                        const szPassword: WideString;
                        const szCode: WideString;
                        nBuySell: Smallint;
                        nFillType: Smallint;
                        nOrderQty: Smallint;
                        dOrderPx: Double;
                        nCustOrderKey: Smallint): WideString;
                *)
                    p_QueryData.m_RequestID :=
                        m_Agent.SendCMENewOrder(
                            f_AccountNo,
                            f_Password,
                            f_Symbol,
                            f_nBuySell,
                            1,
                            f_OrderVolume,
                            f_OrderPrice,
                            1
                        );
                end else
                if (f_OrderCommand = 3) then
                begin

                    (*
                        function SendCMEModiOrder(
                            const szAccNum: WideString;
                            const szPassword: WideString;
                            const szCode: WideString;
                            nBuySell: Smallint;
                            dOrderPx: Double;
                            const szOriOrdNum: WideString;
                            nCustOrderKey: Smallint): WideString;
                    *)

                    p_QueryData.m_RequestID :=
                        m_Agent.SendCMEModiOrder(
                            f_AccountNo,
                            f_Password,
                            f_Symbol,
                            f_nBuySell,
                            f_OrderPrice,
                            f_Record.GetStringValue('ORG_ORDER_NO'), 1);
                end else
                if (f_OrderCommand = 4) then
                begin
                    (*
                    function SendCMECancelOrder(
                        const szAccNum: WideString;
                        const szPassword: WideString;
                        const szCode: WideString;
                        nBuySell: Smallint;
                        const szOriOrdNum: WideString;
                        nCustOrderKey: Smallint): WideString;
                    *)

                    p_QueryData.m_RequestID :=
                        m_Agent.SendCMECancelOrder(
                            f_AccountNo,
                            f_Password,
                            f_Symbol,
                            f_nBuySell,
                            f_Record.GetStringValue('ORG_ORDER_NO'), 1);
                end;

                if p_QueryData.m_RequestID <> '-1' then
                begin
                    p_QueryData.m_DateTime := Now;
                    p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
                    p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);
                    SetRQTable(p_QueryData.m_RequestID, p_QueryData);
                    p_QueryData := NIL;

                    LOG_WRITE(LOG_TYPE_INFO, 'CFNWRAgentManager_KSFCME',
                    '주문전송; ' +
                    '사용자:'           +   f_Record.GetStringValue('USERID')               + '; ' +
                    '계좌:'             +   f_Record.GetStringValue('ACCOUNT_NO')           + '; ' +
                    '종목:'             +   f_Record.GetStringValue('SYMBOL')               + '; ' +
                    '주문데이터유형:'   +   IntToStr(f_Record.GetIntegerValue('DATATYPE'))  + '; ' +
                    '매매구분:'         +   f_Record.GetStringValue('ORDER_COMMAND')        + '; ' +
                    '주문량:'           +   IntToStr(f_Record.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                    '주문가:'           +   WriteNumber(f_Record.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                    '주문번호:'         +   f_Record.GetStringValue('ORDER_NO')             + '; ' +
                    '원주문번호:'       +   f_Record.GetStringValue('ORG_ORDER_NO')         + '; ' +
                    '블록명:'           +   f_Record.GetStringValue('BLOCK_NAME')           + '; ' +
                    '신호순번:'         +   f_Record.GetStringValue('SIGNAL_SEQ')
                    );
                end else
                begin

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
//  선물시세 조회 패킷을 만들어서 Agent에 전달한다.
procedure CFNWRAgentManager_KSFCME.SC_QUOTE_TR_0210(p_QueryData: CFNQueryData);
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
                    f_IOHandler := Make_CKQ52010_IN(NIL, f_IORecord);
                    f_IOHandler.EncodeData(f_SendStream);
                    f_IOHandler.Free;
                    //

                    f_SendStream.Position := 0;
                    f_DataSize := f_SendStream.Size;
                    f_DataString := f_SendStream.ReadString(f_DataSize);

                    f_RQID := m_Agent.RequestData('CKQ52010', f_DataSize, f_DataString, 1, 0, 60);

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
//---------------------------------------------------------------------------
procedure CFNWRAgentManager_KSFCME.SC_ACCOUNT_TR_0010(p_QueryData: CFNQueryData);
var
    f_OutDataSet:CFNDataSet;
    f_OutRecord:CFNRecord;
    f_AccountIndex:Integer;
    f_AccountNumber:WideString;
    f_AccountName:WideString;
    f_AccountSerial:String;
    f_AccountCode:String;

    f_AccountCount:Integer;
begin
    Make_SC_ACCOUNT_TR_0010_OUT(p_QueryData.m_Response);
    f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);

    f_AccountCount := m_Agent.GetAccountInfCount;

    try
        for f_AccountIndex := 0 to f_AccountCount - 1 do
        begin
            m_Agent.GetAccountInf(f_AccountIndex, f_AccountNumber, f_AccountName);
            f_AccountSerial := '';
            f_AccountCode := '5A';

            f_OutRecord := CFNRecord.Create;
            f_OutRecord.SetStringValue('ACCOUNT_NO', f_AccountNumber);
            f_OutRecord.SetStringValue('ACCOUNT_NAME', f_AccountName);
            f_OutRecord.SetStringValue('SERIAL_NO', f_AccountSerial);
            f_OutRecord.SetStringValue('CODE', f_AccountCode);
            f_OutDataSet.RecordList.Add(f_OutRecord);
        end;
        WriteMessage(p_QueryData, 'M00000', '정상처리 되었습니다.');
    except
        on E: Exception do
        begin
            WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
            p_QueryData.m_Response.SetErrorCode('M30001');
            f_OutRecord := CFNRecord.Create;
            f_OutRecord.SetStringValue('ERROR_CODE', 'M30001');
            f_OutRecord.SetStringValue('MESSAGE', E.Message);
            p_QueryData.m_Response.m_ErrorDataSet.RecordList.Add(f_OutRecord);
        end;
    end;

    StoreRecvData(p_QueryData);
end;

//---------------------------------------------------------------------------
procedure CFNWRAgentManager_KSFCME.SC_CODE_TR_0030(p_QueryData: CFNQueryData);
var
    F: TextFile;
    S: string;
    f_Symbol:String;
    f_Name:String;
    f_OutDataSet:CFNDataSet;
    f_OutRecord:CFNRecord;
    f_RecordList:TStringList;
    f_FieldList:TStringList;
    f_RecordIndex:Integer;
    f_TempPath:String;
begin
    Make_SC_CODE_TR_0030_OUT(p_QueryData.m_Response);
    f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);

    f_RecordList := TStringList.Create;
    f_FieldList := TStringList.Create;

    try
        f_TempPath := ExtractFilePath(ParamStr(0));
        AssignFile(F, f_TempPath + '\' +  'master.dat');
        Reset(F);
        while not eof(F) do
        begin
            Readln(F, S);
            f_RecordList.Add(S);
        end;
        CloseFile(F);

        for f_RecordIndex := 0 to f_RecordList.Count - 1 do
        begin
            f_FieldList.Clear;
            ExtractStrings([','], [], PChar(f_RecordList[f_RecordIndex]), f_FieldList);
            if f_FieldList.Count < 10 then continue;

            f_Symbol := Trim(f_FieldList[6]);
            f_Name := Trim(f_FieldList[8]);
            if Copy(f_Symbol,  1,  3) <> '101' then continue;

            f_OutRecord := CFNRecord.Create;
            f_OutRecord.SetIntegerValue ('COUNTRY_NO', g_DefaultCountry );
            f_OutRecord.SetIntegerValue ('GROUP_NO'  , g_DefaultGroup   );
            f_OutRecord.SetIntegerValue ('MARKET_NO' , g_DefaultMarket  );
            f_OutRecord.SetStringValue  ('SYMBOL'    , f_Symbol);
            f_OutRecord.SetStringValue  ('NAME'      , f_Name);
            f_OutDataSet.RecordList.Add (f_OutRecord);
        end;
        WriteMessage(p_QueryData, 'M00000', '정상처리 되었습니다.');
    except
        on E: Exception do
        begin
            WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
            p_QueryData.m_Response.SetErrorCode('M30001');
            f_OutRecord := CFNRecord.Create;
            f_OutRecord.SetStringValue('ERROR_CODE', 'M30001');
            f_OutRecord.SetStringValue('MESSAGE', E.Message);
            p_QueryData.m_Response.m_ErrorDataSet.RecordList.Add(f_OutRecord);
        end;
    end;

    f_RecordList.Free;
    f_FieldList.Free;

    StoreRecvData(p_QueryData);
end;

//---------------------------------------------------------------------------
procedure CFNWRAgentManager_KSFCME.MakeDefaultResponse(p_QueryData:CFNQueryData);
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
                        f_OutRecord.SetIntegerValue('COUNTRY_NO'        , f_InRecord.GetIntegerValue('COUNTRY_NO'));
                        f_OutRecord.SetIntegerValue('GROUP_NO'          , f_InRecord.GetIntegerValue('GROUP_NO'));
                        f_OutRecord.SetIntegerValue('MARKET_NO'         , f_InRecord.GetIntegerValue('MARKET_NO'));
                        f_OutRecord.SetStringValue('SYMBOL'             , f_InRecord.GetStringValue('SYMBOL'));
                    end;
                end;
            end;
            {$ENDREGION}
        except
        end;
    end else
    {$ENDREGION}

    {$REGION '코드조회'}
    if (p_QueryData.m_ServiceID = 'SC_CODE') and (p_QueryData.m_TRCode = 'TR_0030') then
    begin
        try
            f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
            if f_OutDataSet = NIL then
            begin
                Make_SC_CODE_TR_0030_OUT(p_QueryData.m_Response);
            end;
        except
        end;
    end;
    {$ENDREGION}
end;

procedure CFNWRAgentManager_KSFCME.OnTimeout(p_QueryData:CFNQueryData);
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
procedure CFNWRAgentManager_KSFCME.OnRecvData(
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
begin
    f_QueryData := GetRQTable(IntToStr(RqID));
    if not Assigned(f_QueryData) then exit;

    {$REGION '계좌조회'}
    if (f_QueryData.m_ServiceID = 'SC_ACCOUNT') and (f_QueryData.m_TRCode = 'TR_0010') then
    begin
        try
            if DataType = RQDATA_DATA then
            begin
                MakeDefaultResponse(f_QueryData);
                f_OutDataSet := f_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
                f_DataStream := TStringStream.Create;
                try
                    f_DataStream.WriteString(szData);
                    m_IOHandler_SC_ACCOUNT_TR_0010_OUT.ClearData;
                    m_IOHandler_SC_ACCOUNT_TR_0010_OUT.SetSourceData(f_DataStream);

                    if m_IOHandler_SC_ACCOUNT_TR_0010_OUT.m_DataSetList.Count > 0 then
                    begin
                        f_IODataSet := m_IOHandler_SC_ACCOUNT_TR_0010_OUT.m_DataSetList.Items[0] as CFNIODataSet;
                        f_RecordSize := f_IODataSet.GetRecordSize;

                        if f_RecordSize <> 0 then
                        begin
                            f_FixedCount := DataSize div f_RecordSize;
                        end else
                        begin
                            f_FixedCount := 1;
                        end;
                        f_IODataSet.FixedRecordCount := f_FixedCount;
                    end;

                    m_IOHandler_SC_ACCOUNT_TR_0010_OUT.DecodeData;

                    if m_IOHandler_SC_ACCOUNT_TR_0010_OUT.m_DataSetList.Count > 0 then
                    begin
                        f_IODataSet := m_IOHandler_SC_ACCOUNT_TR_0010_OUT.m_DataSetList.Items[0] as CFNIODataSet;
                        for f_RecordIndex := 0 to f_IODataSet.RecordList.Count - 1 do
                        begin
                            f_IORecord := f_IODataSet.RecordList.Items[f_RecordIndex] as CFNIORecord;
                            f_OutRecord := CFNRecord.Create;
                            f_OutRecord.SetStringValue('ACCOUNT_NO', f_IORecord.GetStringValue('BRKACCNO'));
                            f_OutRecord.SetStringValue('SERIAL_NO', '');
                            f_OutRecord.SetStringValue('ACCOUNT_NAME', f_IORecord.GetStringValue('BRKACCNM'));
                            f_OutRecord.SetStringValue('CODE', '5A');
                            f_OutDataSet.RecordList.Add(f_OutRecord);
                        end;
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
                WriteMessage(f_QueryData, 'M00000', szData);
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
    end else
    {$ENDREGION}

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

                    m_IOHandler_CKQ52010_OUT.ClearData;
                    m_IOHandler_CKQ52010_OUT.SetSourceData(f_DataStream);
                    m_IOHandler_CKQ52010_OUT.DecodeData;

                    f_IORecord := NIL;
                    if m_IOHandler_CKQ52010_OUT.m_DataSetList.Count > 0 then
                    begin
                        f_IODataSet := m_IOHandler_CKQ52010_OUT.m_DataSetList.Items[0] as CFNIODataSet;
                        if f_IODataSet.RecordList.Count > 0 then
                        begin
                            f_IORecord := f_IODataSet.RecordList.Items[0] as CFNIORecord;
                        end;
                    end;

                    if f_IORecord <> NIL then
                    begin
                        f_OutRecord.SetIntegerValue('COUNTRY_NO', 0);
                        f_OutRecord.SetIntegerValue('GROUP_NO'  , 2);
                        f_OutRecord.SetIntegerValue('MARKET_NO' , 2);
                        f_OutRecord.SetStringValue('SYMBOL', f_IORecord.GetStringValue('SYMBOL'));
                        f_OutRecord.SetStringValue('NAME', f_IORecord.GetStringValue('NAME'));
                        f_OutRecord.SetStringValue('DATE', DateToString_YYYYMMDD(Now + g_DateTimeDiff));
                        f_OutRecord.SetStringValue('TIME', TimeToString_HHMMSS(Now + g_DateTimeDiff));
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
    end else
    {$ENDREGION}

    {$REGION '선물주문'}
    if (f_QueryData.m_ServiceID = 'SC_ORDER') and (f_QueryData.m_TRCode = 'TR_0210') then
    begin
        try        
            if DataType = RQDATA_DATA then
            begin
                MakeDefaultResponse(f_QueryData);
                f_OutDataSet := f_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
                f_OutRecord := f_OutDataSet.RecordList.Items[0] as CFNRecord;

                f_DataStream := TStringStream.Create;
                try
                
                    {$REGION '응답패킷을 분석한다'}
                    f_DataStream.WriteString(szData);
                    m_IOHandler_SC_ORDER_TR_0210_OUT.ClearData;
                    m_IOHandler_SC_ORDER_TR_0210_OUT.SetSourceData(f_DataStream);
                    m_IOHandler_SC_ORDER_TR_0210_OUT.DecodeData;                        
                    {$ENDREGION}
                                         
                    {$REGION '첫번째 레크드를 찾는다'}
                    f_IORecord := NIL;
                    if m_IOHandler_SC_ORDER_TR_0210_OUT.m_DataSetList.Count > 0 then
                    begin
                        f_IODataSet := m_IOHandler_SC_ORDER_TR_0210_OUT.m_DataSetList.Items[0] as CFNIODataSet;
                        if f_IODataSet.RecordList.Count > 0 then
                        begin
                            f_IORecord := f_IODataSet.RecordList.Items[0] as CFNIORecord;
                        end;
                    end;                             
                    {$ENDREGION}
                    
                    {$REGION '주문번호를 추출한다'}
                    if f_IORecord <> NIL then
                    begin
                        f_OrderNo := f_IORecord.GetStringValue('ORDER_NO');
                        if atoi(f_OrderNo) = 0 then
                        begin
                            f_OrderNo := '';
                        end else
                        begin
                            f_OrderNo := IntToStr(atoi(f_OrderNo));
                        end;

                        f_MessageCode := f_IORecord.GetStringValue('MESSAGE_CODE');
                        f_MessageCode := 'M' + f_MessageCode;
                        f_OutRecord.SetStringValue('ORDER_NO', f_OrderNo);
                        f_OutRecord.SetStringValue('MESSAGE_CODE', f_MessageCode);

                        if f_OrderNo <> '' then
                        begin
                            LOG_WRITE(LOG_TYPE_INFO, 'CFNWRAgentManager_KSFCME',
                            '주문응답; ' +
                            '사용자:'           +   f_OutRecord.GetStringValue('USERID')               + '; ' +
                            '계좌:'             +   f_OutRecord.GetStringValue('ACCOUNT_NO')           + '; ' +
                            '종목:'             +   f_OutRecord.GetStringValue('SYMBOL')               + '; ' +
                            '주문데이터유형:'   +   IntToStr(f_OutRecord.GetIntegerValue('DATATYPE'))  + '; ' +
                            '매매구분:'         +   f_OutRecord.GetStringValue('ORDER_COMMAND')        + '; ' +
                            '주문량:'           +   IntToStr(f_OutRecord.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                            '주문가:'           +   WriteNumber(f_OutRecord.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                            '주문번호:'         +   f_OutRecord.GetStringValue('ORDER_NO')             + '; ' +
                            '원주문번호:'       +   f_OutRecord.GetStringValue('ORG_ORDER_NO')         + '; ' +
                            '블록명:'           +   f_OutRecord.GetStringValue('BLOCK_NAME')           + '; ' +
                            '신호순번:'         +   f_OutRecord.GetStringValue('SIGNAL_SEQ')
                            );
                        end else
                        begin
                            LOG_WRITE(LOG_TYPE_ERROR, 'CFNWRAgentManager_KSFCME',
                            '주문응답오류; ' +
                            '사용자:'           +   f_OutRecord.GetStringValue('USERID')               + '; ' +
                            '계좌:'             +   f_OutRecord.GetStringValue('ACCOUNT_NO')           + '; ' +
                            '종목:'             +   f_OutRecord.GetStringValue('SYMBOL')               + '; ' +
                            '주문데이터유형:'   +   IntToStr(f_OutRecord.GetIntegerValue('DATATYPE'))  + '; ' +
                            '매매구분:'         +   f_OutRecord.GetStringValue('ORDER_COMMAND')        + '; ' +
                            '주문량:'           +   IntToStr(f_OutRecord.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                            '주문가:'           +   WriteNumber(f_OutRecord.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                            '주문번호:'         +   f_OutRecord.GetStringValue('ORDER_NO')             + '; ' +
                            '원주문번호:'       +   f_OutRecord.GetStringValue('ORG_ORDER_NO')         + '; ' +
                            '블록명:'           +   f_OutRecord.GetStringValue('BLOCK_NAME')           + '; ' +
                            '신호순번:'         +   f_OutRecord.GetStringValue('SIGNAL_SEQ')
                            );
                        end;
                    end else
                    begin
                        f_OutRecord.SetStringValue('ORDER_NO', '');
                        LOG_WRITE(LOG_TYPE_ERROR, 'CFNWRAgentManager_KSFCME',
                        '주문응답오류; ' +
                        '사용자:'           +   f_OutRecord.GetStringValue('USERID')               + '; ' +
                        '계좌:'             +   f_OutRecord.GetStringValue('ACCOUNT_NO')           + '; ' +
                        '종목:'             +   f_OutRecord.GetStringValue('SYMBOL')               + '; ' +
                        '주문데이터유형:'   +   IntToStr(f_OutRecord.GetIntegerValue('DATATYPE'))  + '; ' +
                        '매매구분:'         +   f_OutRecord.GetStringValue('ORDER_COMMAND')        + '; ' +
                        '주문량:'           +   IntToStr(f_OutRecord.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                        '주문가:'           +   WriteNumber(f_OutRecord.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                        '주문번호:'         +   f_OutRecord.GetStringValue('ORDER_NO')             + '; ' +
                        '원주문번호:'       +   f_OutRecord.GetStringValue('ORG_ORDER_NO')         + '; ' +
                        '블록명:'           +   f_OutRecord.GetStringValue('BLOCK_NAME')           + '; ' +
                        '신호순번:'         +   f_OutRecord.GetStringValue('SIGNAL_SEQ')
                        );
                    end;
                finally
                    f_DataStream.Free;
                end;                                     
                {$ENDREGION}
                
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
                f_OutDataSet := f_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
                f_OutRecord := f_OutDataSet.RecordList.Items[0] as CFNRecord;

                if f_OutRecord <> NIL then
                begin
                    f_MessageCode := f_OutRecord.GetStringValue('MESSAGE_CODE');
                end else
                begin
                    if '정상처리 되었습니다.' = szData then
                    begin
                        f_MessageCode := 'M00000';
                    end else
                    begin
                        f_MessageCode := 'M60001';
                    end;                      
                end;
                WriteMessage(f_QueryData, f_MessageCode,  szData);
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
procedure CFNWRAgentManager_KSFCME.OnRecvRealData(ASender: TObject; const TrCode, KeyValue: WideString; RealID: Smallint; DataSize: Integer; const szData: WideString);
begin
    m_StringStream.Clear;
    m_StringStream.WriteString(szData);

    m_DataStream.Clear;
    m_StringStream.SaveToStream(m_DataStream);
    m_DataStream.Position := 0;

    if TrCode = 'SB_ORDER_EXEC'  then
    begin
        Process_SB_ORDER_EXEC(KeyValue, RealID, m_DataStream);
    end else

    if TrCode = 'SB_CME_FUT_EXEC'  then
    begin
        Process_SB_CME_FUT_EXEC(KeyValue, RealID, m_DataStream);
    end else

    if TrCode = 'SB_CME_ORDER_EXEC'  then
    begin
        Process_SB_ORDER_EXEC(KeyValue, RealID, m_DataStream);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNWRAgentManager_KSFCME.Process_SB_ORDER_EXEC(AKeyValue: WideString; ARealID: Smallint; ADataStream : TMemoryStream);
var
    f_StreamRecord:CFNStreamRecord;
    f_StreamRecord2:CFNStreamRecord;
    f_SendStreamRecord:CFNStreamRecord;
    f_Record:CIORecord;

    f_SubscribeKey : String;
    f_ObjectList : TObjectList;

    f_Loop: Integer;
    f_DataDelivery : CFNDataDelivery;

    f_DATADIV, f_ORDDIV : String;
    f_NValue:Integer;
    f_DValue:Double;
    f_SValue:String;
begin
    ADataStream.Position := 0;
    try
        m_IODataSet_SB_ORDER_EXEC.ClearRecordList;
        m_IODataSet_SB_ORDER_EXEC.DecodeData(ADataStream, 1);
    except
        on E: Exception do
        LOG_WRITE(LOG_TYPE_ERROR, 'CFNWRAgentManager_KSFCME', '패킷분석 실패');
    end;

    if (m_IODataSet_SB_ORDER_EXEC.RecordList.Count > 0) then
    begin    
        try
            f_Record := CIORecord(m_IODataSet_SB_ORDER_EXEC.RecordList.Items[0]);
            f_DATADIV := f_Record.GetStringValue('DATADIV');
            f_ORDDIV := f_Record.GetStringValue('ORDDIV');

            f_StreamRecord := NIL;
            f_StreamRecord2 := NIL;

            {$REGION '거래소접수'}
            if ('12' = f_DATADIV) then
            begin
                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('ORDER_RECEIVE');
                f_StreamRecord.SetStringValue('USERID'      , f_Record.GetStringValue('ORDERUSERID'));
                f_StreamRecord.SetStringValue('ACCOUNT_NO'  , f_Record.GetStringValue('BRKGACNTNO'));

                f_SValue := f_Record.GetStringValue('SERIES');
                f_StreamRecord.SetStringValue('SYMBOL'      , f_SValue);

                if ('1' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_NEW)
                else if ('2' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED)
                else if ('3' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);

                f_SValue := f_Record.GetStringValue('TRDDIV');
                if (Copy(f_SValue, 1, 1) = '2') then f_NValue := 1
                else if (Copy(f_SValue, 1, 1) = '1')  then f_NValue := 2
                else f_NValue := 0;

                f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_SValue := f_Record.GetStringValue('ORDQTY');
                f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , atoi(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDPX');
                f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , atof(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDNO');
                f_StreamRecord.SetStringValue('ORDER_NO'        , f_SValue);

                f_SValue := f_Record.GetStringValue('ORGNORDNO');
                f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , f_SValue);
                //  거부사유코드
                f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , f_Record.GetStringValue('REJCD'));

                f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNWRAgentManager_KSFCME',
                '주문접수; ' +
                '사용자:'           +   f_StreamRecord.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))  + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))        + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')             + '; ' +
                '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')         + '; '
                );

                f_StreamRecord2 := CFNStreamRecord.Create;
                f_StreamRecord2.SetPacketKey('ORDER_CONFIRM');
                f_StreamRecord2.SetStringValue('USERID'      , f_Record.GetStringValue('ORDERUSERID'));
                f_StreamRecord2.SetStringValue('ACCOUNT_NO'  , f_Record.GetStringValue('BRKGACNTNO'));

                f_SValue := f_Record.GetStringValue('SERIES');
                f_StreamRecord2.SetStringValue('SYMBOL'      , f_SValue);

                if ('1' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_NEW)
                else if ('2' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED)
                else if ('3' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);

                f_SValue := f_Record.GetStringValue('TRDDIV');
                if (Copy(f_SValue, 1, 1) = '2') then f_NValue := 1
                else if (Copy(f_SValue, 1, 1) = '1')  then f_NValue := 2
                else f_NValue := 0;

                f_StreamRecord2.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_SValue := f_Record.GetStringValue('ORDQTY');
                f_StreamRecord2.SetIntegerValue('ORDER_VOLUME'   , atoi(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDPX');
                f_StreamRecord2.SetDoubleValue('ORDER_PRICE'     , atof(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDNO');
                f_StreamRecord2.SetStringValue('ORDER_NO'        , f_SValue);

                f_SValue := f_Record.GetStringValue('ORGNORDNO');
                f_StreamRecord2.SetStringValue('ORG_ORDER_NO'    , f_SValue);
                //  거부사유코드
                f_StreamRecord2.SetStringValue('ASPR_RJCT_RSCD'  , f_Record.GetStringValue('REJCD'));

                f_StreamRecord2.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord2.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNWRAgentManager_KSFCME',
                '주문확인; ' +
                '사용자:'           +   f_StreamRecord2.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_StreamRecord2.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_StreamRecord2.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_DATATYPE'))  + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_COMMAND'))        + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   WriteNumber(f_StreamRecord2.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                '주문번호:'         +   f_StreamRecord2.GetStringValue('ORDER_NO')             + '; ' +
                '원주문번호:'       +   f_StreamRecord2.GetStringValue('ORG_ORDER_NO')         + '; '
                );

            end else
            {$ENDREGION}

            {$REGION '거래소확인'}
            if ('13' = f_DATADIV) then
            begin
                //  우리선물에서는 주문확인 데이터가 별도로 수신되지 않아,
                //  '주문접수' 데이터가 들어오면 '주문확인'데이터도 같이 전달한다.
            end else
            {$ENDREGION}

            {$REGION '거래소체결'}
            if ('14' = f_DATADIV) then
            begin
                f_SValue := f_Record.GetStringValue('EXECQTY1');
                f_NValue := atoi(f_SValue);
                if f_NValue > 0 then
                begin

                    f_StreamRecord := CFNStreamRecord.Create;
                    f_StreamRecord.SetPacketKey('ORDER_TRADE');

                    f_StreamRecord.SetStringValue('USERID'      , f_Record.GetStringValue('ORDERUSERID'));
                    f_StreamRecord.SetStringValue('ACCOUNT_NO'  , f_Record.GetStringValue('BRKGACNTNO'));

                    f_SValue := f_Record.GetStringValue('SERIES');
                    f_StreamRecord.SetStringValue('SYMBOL'      , f_SValue);

                    if ('1' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_NEW)
                    else if ('2' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED)
                    else if ('3' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);

                    f_SValue := f_Record.GetStringValue('TRDDIV');
                    if (Copy(f_SValue, 1, 1) = '2') then f_NValue := 1
                    else if (Copy(f_SValue, 1, 1) = '1')  then f_NValue := 2
                    else f_NValue := 0;

                    f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                    f_SValue := f_Record.GetStringValue('ORDQTY');
                    f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , atoi(f_SValue));

                    f_SValue := f_Record.GetStringValue('ORDPX');
                    f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , atof(f_SValue));

                    f_NValue := 0;
                    f_StreamRecord.SetIntegerValue('TRADE_VOLUME_TYPE'   , f_NValue);

                    f_SValue := f_Record.GetStringValue('EXECQTY1');
                    f_NValue := atoi(f_SValue);
                    f_StreamRecord.SetIntegerValue('TRADE_VOLUME'   , f_NValue);

                    f_SValue := f_Record.GetStringValue('EXECPX1');
                    f_DValue := atof(f_SValue);
                    f_StreamRecord.SetDoubleValue('TRADE_PRICE'     , f_DValue);

                    f_SValue := f_Record.GetStringValue('ORDNO');
                    f_StreamRecord.SetStringValue('ORDER_NO'        , f_SValue);

                    f_SValue := f_Record.GetStringValue('ORGNORDNO');
                    f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , f_SValue);

                    //  거부사유코드
                    f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , f_Record.GetStringValue('REJCD'));

                    f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                    f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                    LOG_WRITE(LOG_TYPE_INFO, 'CFNWRAgentManager_KSFCME',
                    '주문체결; ' +
                    '사용자:'           +   f_StreamRecord.GetStringValue('USERID')               + '; ' +
                    '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')           + '; ' +
                    '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')               + '; ' +
                    '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))  + '; ' +
                    '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))        + '; ' +
                    '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                    '주문가:'           +   WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                    '체결량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('TRADE_VOLUME'))+ '; ' +
                    '체결가:'           +   WriteNumber(f_StreamRecord.GetDoubleValue('TRADE_PRICE'), 2)+ '; ' +
                    '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')             + '; ' +
                    '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')         + '; '
                    );
                end;
            end else
            {$ENDREGION}

            {$REGION '거래소거부'}
            if ('19' = f_DATADIV) then
            begin
                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('ORDER_REJECT');

                f_StreamRecord.SetStringValue('USERID'      , f_Record.GetStringValue('ORDERUSERID'));
                f_StreamRecord.SetStringValue('ACCOUNT_NO'  , f_Record.GetStringValue('BRKGACNTNO'));

                f_SValue := f_Record.GetStringValue('SERIES');
                f_StreamRecord.SetStringValue('SYMBOL'      , f_SValue);

                if ('1' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_NEW)
                else if ('2' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED)
                else if ('3' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);

                f_SValue := f_Record.GetStringValue('TRDDIV');
                if (Copy(f_SValue, 1, 1) = '2') then f_NValue := 1
                else if (Copy(f_SValue, 1, 1) = '1')  then f_NValue := 2
                else f_NValue := 0;

                f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_SValue := f_Record.GetStringValue('ORDQTY');
                f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , atoi(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDPX');
                f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , atof(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDNO');
                f_StreamRecord.SetStringValue('ORDER_NO'        , f_SValue);

                f_SValue := f_Record.GetStringValue('ORGNORDNO');
                f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , f_SValue);
                //  거부사유코드
                f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , f_Record.GetStringValue('REJCD'));

                f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_ERROR, 'CFNWRAgentManager_KSFCME',
                '주문거부; ' +
                '사용자:'           +   f_StreamRecord.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))  + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))        + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')             + '; ' +
                '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')         + '; ' +
                '거부사유:'         +   f_StreamRecord.GetStringValue('ASPR_RJCT_RSCD')       + '; '
                );
            end;
            {$ENDREGION}

            {$REGION '전달'}
            if Assigned(f_StreamRecord) then
            begin
                f_SubscribeKey := f_StreamRecord.GetStringValue('USERID');

                m_STSubscribeTableLock.Enter;
                try
                    f_ObjectList := m_STSubscribeTable[MAP_USERTRADE].GetKey(f_SubscribeKey);
                finally
                    m_STSubscribeTableLock.Leave;
                end;

                if Assigned(f_ObjectList) then
                begin
                    try
                        for f_Loop := 0 to f_ObjectList.Count - 1 do
                        begin
                            f_DataDelivery := CFNDataDelivery(f_ObjectList.Items[f_Loop]);
                            if Assigned(f_DataDelivery) then
                            begin
                                f_SendStreamRecord := CFNStreamRecord.Create;
                                f_SendStreamRecord.CloneStreamRecord(f_StreamRecord);
                                try
                                    f_DataDelivery.DeliveryStream(f_SendStreamRecord);
                                except
                                    f_SendStreamRecord.Free;
                                end;
                            end;
                        end;
                    except
                    end;
                    SaveStreamRecord(f_StreamRecord);

                    f_ObjectList.Clear;
                    f_ObjectList.Free;
                    f_ObjectList := NIL;
                end else
                begin
                    f_StreamRecord.Free;
                    f_StreamRecord := NIL;
                end;
            end;
            {$ENDREGION}

            {$REGION '전달'}
            if Assigned(f_StreamRecord2) then
            begin
                f_SubscribeKey := f_StreamRecord2.GetStringValue('USERID');

                m_STSubscribeTableLock.Enter;
                try
                    f_ObjectList := m_STSubscribeTable[MAP_USERTRADE].GetKey(f_SubscribeKey);
                finally
                    m_STSubscribeTableLock.Leave;
                end;

                if Assigned(f_ObjectList) then
                begin
                    try
                        for f_Loop := 0 to f_ObjectList.Count - 1 do
                        begin
                            f_DataDelivery := CFNDataDelivery(f_ObjectList.Items[f_Loop]);
                            if Assigned(f_DataDelivery) then
                            begin
                                f_SendStreamRecord := CFNStreamRecord.Create;
                                f_SendStreamRecord.CloneStreamRecord(f_StreamRecord2);
                                try
                                    f_DataDelivery.DeliveryStream(f_SendStreamRecord);
                                except
                                    f_SendStreamRecord.Free;
                                end;
                            end;
                        end;
                    except
                    end;
                    SaveStreamRecord(f_StreamRecord2);

                    f_ObjectList.Clear;
                    f_ObjectList.Free;
                    f_ObjectList := NIL;
                end else
                begin
                    f_StreamRecord2.Free;
                    f_StreamRecord2 := NIL;
                end;
            end;
            {$ENDREGION}

        except
        end;

    end;
end;

//---------------------------------------------------------------------------
procedure CFNWRAgentManager_KSFCME.Process_SB_CME_FUT_EXEC(AKeyValue: WideString; ARealID: Smallint; ADataStream : TMemoryStream);
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
        m_IODataSet_SB_CME_FUT_EXEC.ClearRecordList;
        m_IODataSet_SB_CME_FUT_EXEC.DecodeData(ADataStream, 1);
    except
        (*
        on E: Exception do
        LOG_ERROR(
        [
            'CFNWRAgentManager_KSFCME.Process_SB_FUT_EXEC; 패킷분석 실패 ',
            E.Message
        ]);
        *)
    end;

    if (m_IODataSet_SB_CME_FUT_EXEC.RecordList.Count > 0) then
    begin
        try
            f_Record := CIORecord(m_IODataSet_SB_CME_FUT_EXEC.RecordList.Items[0]);

            f_SubscribeKey := MakeStreamSubscribeKey(0, 2, 2, f_Record.GetStringValue('SYMBOL'));

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
                f_StreamRecord.SetIntegerValue('GROUP_NO'       , 2);
                f_StreamRecord.SetIntegerValue('MARKET_NO'      , 2);

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
procedure CFNWRAgentManager_KSFCME.OnNetConnected(ASender: TObject);
begin
end;

//---------------------------------------------------------------------------
procedure CFNWRAgentManager_KSFCME.OnNetDisconnected(ASender: TObject);
begin
    LOG_WRITE(LOG_TYPE_ERROR, 'CFNWRAgentManager_KSFCME', '통신이 종료되었습니다.');
    if Assigned(m_DisconnectEvent) then
    begin
        m_DisconnectEvent(Self);
    end;
end;
//---------------------------------------------------------------------------

end.
