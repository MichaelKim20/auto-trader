//**************************************************************************//
//  FileName        :   FNWROAgentManager.pas
//  Author          :   김무근 작성
//  Date            :   2013년 12월 24일
//  Description     :   우리선물사 해외API를 통해, 시세와 주문을 구현하기 위한 클래스
//**************************************************************************//
{우리선물사 API를 통해, 시세와 주문을 구현하기 위한 클래스}
Unit FNWROAgentManager;

interface

uses
    Dialogs, Messages, WinProcs, SysUtils, Forms, ActiveX, WinTypes, Classes, SyncObjs,
    Contnrs, IniFiles, VarUtils, Variants, Math, FNDataSet, FNDataDelivery, FNIOHandler,
    FNAgentManager, COMMOCXLib_TLB, IODataSet, FNMaterialCollection;

type
    ///<author>김무근</author>
    ///<version>1.0</version>
    ///<since>2012.07.10</since>
    ///<Comment>우리선물 API를 이용하여 필요한 기능을 확장한 클래스</Comment>
    CFNWROAgentManager = class(CFNAgentManager)
    public
        ///<Comment>생성자</Comment>
        Constructor Create(AQueryThreadCount:Integer = 1);

        ///<Comment>파괴자</Comment>
        Destructor Destroy; override;

        ///<Comment>증권사 API OCX를 등록한다.</Comment>
        procedure AssignAgent(p_Agent:TCommOCX);

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
        m_RQIndex       :   Integer;
        m_RQLock        :   TCriticalSection;
        m_MaterialItem  :   CFNMaterialItem;

        function    GetRQIndex : Integer;
        function    WriteInteger(AValue, ASize: Integer; APrecision: Integer):String;

        function    GetMaterialData(ASymbol:String; var ACountry : Integer; var AGroup : Integer; var AMarket : Integer):CFNMaterialItem;
        procedure   GetGategory(ASymbol:String; var ACountry : Integer; var AGroup : Integer; var AMarket : Integer);

    private
        ///<Comment>증권사 연결 OCX</Comment>
        m_Agent     :   TCommOCX;
	    m_AgentLock :   TCriticalSection;

        ///<Comment>메인 윈도우의 핸들</Comment>
        m_Handle    :   HWND;

        ///<Comment>각종 실시간 데이터의 구조를 분석할 때 사용한다.</Comment>
        m_DataStream    : TMemoryStream;
        m_StringStream  : TStringStream;

        m_IOHandler_HCQ01120_OUT    : CFNIOHandler;
        m_IOHandler_ORD_OUT         : CFNIOHandler;

        m_IODataSet_RDM_OSTS1       : CIODataSet;
        m_IODataSet_RDM_EXEC        : CIODataSet;

        procedure SC_ACCOUNT_TR_0010(p_QueryData: CFNQueryData);

        ///<Comment>선물시세 조회 패킷을 만들어서 Agent에 전달한다.</Comment>
        procedure SC_QUOTE_TR_0210(p_QueryData:CFNQueryData);

        ///<Comment>선물주문 패킷을 만들어서 Agent에 전달한다.</Comment>
        procedure SC_ORDER_TR_0210(p_QueryData:CFNQueryData);

        procedure MakeDefaultResponse(p_QueryData:CFNQueryData);

        ///<Comment>패킷중 에러코드와 메세지를 추가하는 부분</Comment>
        procedure WriteMessage(p_QueryData: CFNQueryData; sErrorCode, sMsg: WideString);

        ///<Comment>패킷중 에러코드와 메세지를 추가하는 부분</Comment>
        procedure WriteError(p_QueryData: CFNQueryData; sErrorCode:WideString);

        procedure OnRecvData(ASender: TObject; const szTrCode: WideString; nRqID: Smallint; nDataLen: Smallint; var szData: WideString);
        procedure OnRecvMSG(ASender: TObject; const cFlag: WideString; const szMsg: WideString);
        procedure OnRecvRealData(ASender: TObject; nKey: Smallint; nDataLen: Smallint; const szData: WideString);
        procedure OnSocketStatus(ASender: TObject; nStatus: Smallint);

        procedure Process_RDM_OSTS1(ADataStream : TMemoryStream);
        procedure Process_RDM_EXEC(ADataStream : TMemoryStream);

        procedure OnTimeout(p_QueryData:CFNQueryData);

    public
        property Handle : HWND read m_Handle write AssignHandle;

    end;

implementation

uses
    FNGlobal, FNGlobalVariable, WideStrUtils, CommonTRMaker, FNTradeSystem, WROIOMaker, FNCMVariable, MXVariable;

{$REGION '생성자와 파괴자'}
//---------------------------------------------------------------------------
Constructor CFNWROAgentManager.Create(AQueryThreadCount:Integer = 1);
begin
    inherited Create(AQueryThreadCount);
    m_MaterialItem := NIL;
    m_RQIndex := 0;
    m_AgentLock := TCriticalSection.Create;
    m_RQLock := TCriticalSection.Create;

    m_DataStream := TMemoryStream.Create;
    m_StringStream := TStringStream.Create;

    m_IOHandler_HCQ01120_OUT := Make_HCQ01120_OUT(NIL);
    m_IOHandler_ORD_OUT := Make_ORD_OUT(NIL);
    m_IODataSet_RDM_OSTS1 := Make_RDM_OSTS1(NIL);
    m_IODataSet_RDM_EXEC := Make_RDM_EXEC(NIL);
end;

//---------------------------------------------------------------------------
Destructor CFNWROAgentManager.Destroy;
begin
    m_AgentLock.Free;
    m_RQLock.Free;

    m_DataStream.Free;
    m_StringStream.Free;

    m_IOHandler_HCQ01120_OUT.Free;
    m_IOHandler_HCQ01120_OUT := NIL;

    m_IOHandler_ORD_OUT.Free;
    m_IOHandler_ORD_OUT := NIL;

    m_IODataSet_RDM_OSTS1.Free;
    m_IODataSet_RDM_OSTS1 := NIL;

    m_IODataSet_RDM_EXEC.Free;
    m_IODataSet_RDM_EXEC := NIL;

    inherited Destroy;
end;
{$ENDREGION}

{$REGION 'API Control의 설정'}
//---------------------------------------------------------------------------
procedure CFNWROAgentManager.AssignAgent(p_Agent: TCommOCX);
begin
    m_Agent := p_Agent;

    if Assigned(m_Agent) then
    begin
        m_Agent.OnORecvData := OnRecvData;
        m_Agent.OnORecvMsg := OnRecvMsg;
        m_Agent.OnORecvRealData := OnRecvRealData;
        m_Agent.OnOSocketStatus := OnSocketStatus;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNWROAgentManager.AssignHandle(p_Handle: HWND);
begin
    m_Handle := p_Handle;
end;
{$ENDREGION}

{$REGION '실시간 처리함수들'}
//---------------------------------------------------------------------------
//  선물 스트리밍 시세 등록
procedure CFNWROAgentManager.SubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
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
//  선물 스트리밍 호가 등록
procedure CFNWROAgentManager.SubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := ASymbol;
    if m_STSubscribeTable[MAP_BIDOFFER].AddKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        m_Agent.OCommSetBrodReal(20, ASymbol);
    end;
end;

//---------------------------------------------------------------------------
//  선물 스트리밍 체결통보 등록
procedure CFNWROAgentManager.SubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = '');
begin
    if not Assigned(m_Agent) then exit;
    if m_STSubscribeTable[MAP_USERTRADE].AddKeyValue(AUserID, ADataDelivery) then
    begin
        m_Agent.OCommSetBrodReal(97, AUserID);
    end;
end;

//---------------------------------------------------------------------------
//  선물 스트리밍 시세 등록 해지
procedure CFNWROAgentManager.UnsubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := ASymbol;

    if m_STSubscribeTable[MAP_CURRENT].DeleteKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        m_Agent.ORemoveBrodReal(17, ASymbol);
    end;
end;

//---------------------------------------------------------------------------
//  선물 스트리밍 호가 등록 해지
procedure CFNWROAgentManager.UnsubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry:Integer; AGroup:Integer; AMarket:Integer; ASymbol: String);
var
    f_SubscribeKey : String;
begin
    if not Assigned(m_Agent) then exit;
    f_SubscribeKey := ASymbol;

    if m_STSubscribeTable[MAP_BIDOFFER].DeleteKeyValue(f_SubscribeKey, ADataDelivery) then
    begin
        m_Agent.ORemoveBrodReal(20, ASymbol);
    end;
end;

//---------------------------------------------------------------------------
//  선물 스트리밍 체결통보 등록 해지
procedure CFNWROAgentManager.UnsubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = '');
begin
    if not Assigned(m_Agent) then exit;
    if m_STSubscribeTable[MAP_USERTRADE].DeleteKeyValue(AUserID, ADataDelivery) then
    begin
        m_Agent.ORemoveBrodReal(97, AUserID);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNWROAgentManager.ReSubscribeAll;
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
        m_Agent.OnORecvData := OnRecvData;
        m_Agent.OnORecvMsg := OnRecvMsg;
        m_Agent.OnORecvRealData := OnRecvRealData;
        m_Agent.OnOSocketStatus := OnSocketStatus;
    end;

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

        f_KeyList := m_STSubscribeTable[MAP_USERTRADE].GetAllKeys;
        if f_KeyList <> NIL then
        begin
            for f_Index := 0 to f_KeyList.Count - 1 do
            begin
                f_Key := f_KeyList[f_Index];
                m_Agent.OCommSetBrodReal(97, f_Key);
            end;
            f_KeyList.Free;
        end;

    finally
    end;
end;

{$ENDREGION}

{$REGION '조회 작업을 처리하기 위한 함수들'}
//---------------------------------------------------------------------------
// 조회데이터의 전달할 CFNDelivery객체를 저장할 인덱스 m_RQSubscribeIndex를 가져온다. 이 후에 이값을 1 증가시킨다.
// 배열의 크기가 1024이므로 m_RQSubscribeIndex의 값이 1024보다 크거나 같으면 0으로 초기화 한다.
function CFNWROAgentManager.GetRQIndex : Integer;
begin
    m_RQLock.Enter;
    try
        Inc(m_RQIndex);
        if 11 < m_RQIndex then m_RQIndex := 0;
        Result := m_RQIndex;
    finally
        m_RQLock.Leave;
    end;
end;

//---------------------------------------------------------------------------
//  Agent로 요청한 요청패킷을 하나 씩 꺼내 분석하여, 그 업무에 맞는 Agent내 함수를 이용하여 증권사로 요청을 한다.
procedure CFNWROAgentManager.DoQueryWork(AThreadIndex:Integer);
var
    f_QueryData:CFNQueryData;
begin
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
            Sleep(500);
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
            Sleep(500);
        end else
        begin
            WriteError(f_QueryData, 'M10001');
            StoreRecvData(f_QueryData);
        end;
    end;
    DoCheckTimeout;
end;

//---------------------------------------------------------------------------
procedure CFNWROAgentManager.DoCheckTimeout;
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
                        LOG_WRITE(LOG_TYPE_INFO, 'CFNWROAgentManager',
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
//  패킷중 에러코드와 메세지를 추가하는 부분
procedure CFNWROAgentManager.WriteMessage(p_QueryData: CFNQueryData; sErrorCode, sMsg: WideString);
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
procedure CFNWROAgentManager.WriteError(p_QueryData: CFNQueryData; sErrorCode:WideString);
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
    end else if sErrorCode = 'M90001' then
    begin
        rd.SetStringValue('MESSAGE', '응답시간이 초과되었습니다.');
    end;

    p_QueryData.m_Response.m_ErrorDataSet.RecordList.Add(rd);
end;

//---------------------------------------------------------------------------
//  선물주문 패킷을 만들어서 Agent에 전달한다.
procedure CFNWROAgentManager.SC_ORDER_TR_0210(p_QueryData: CFNQueryData);
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
    f_SOrderPrice:String;

    f_ORG_ORDER_NO:String;
    f_IValue:Integer;
    f_RQID:Integer;
    f_RValue:Integer;
    f_SRValue:String;
    f_FieldList:TStringList;
    f_MaterialItem : CFNMaterialItem;
    f_Precesion:Integer;
    f_Country:Integer;
    f_Group:Integer;
    f_Market:Integer;

    f_RQString, f_MessageText:String;
begin
    try
        f_DataSet := p_QueryData.m_Request.GetDataSet(DATASETID_IN_01);
        if Assigned(f_DataSet) then
        begin
            if (0 < f_DataSet.RecordList.Count) then
            begin
                f_Record := CFNRecord(f_DataSet.RecordList.Items[0]);
                f_AccountNo     := f_Record.GetStringValue ('ACCOUNT_NO'    );      //  계좌번호
                f_Password      := f_Record.GetStringValue ('PASSWORD'      );      //  계좌비번
                f_Symbol        := f_Record.GetStringValue ('SYMBOL'        );      //  종목코드

                f_MaterialItem := GetMaterialData(f_Symbol, f_Country, f_Group, f_Market);
                if Assigned(f_MaterialItem) then
                begin
                    f_Precesion := f_MaterialItem.m_Precision;
                end else
                begin
                    f_Precesion := 2;
                end;

                f_OrderCommand  := f_Record.GetIntegerValue ('ORDER_COMMAND' );      //  1 : 매도, 2 : 매수, 3 : 정정, 4 : 취소
                f_OrderVolume   := f_Record.GetIntegerValue ('ORDER_VOLUME'  );      //  주문량
                f_OrderPrice    := f_Record.GetDoubleValue  ('ORDER_PRICE'   );      //  주문가격
                f_SOrderPrice   := TFNGlobal.FloatToString(f_OrderPrice, f_Precesion);
                f_sPriceType    := f_Record.GetStringValue  ('PRICETYPE');            //  '01' : 지정가, '02' : 시장가

                LOG_WRITE(LOG_TYPE_INFO, 'CFNWROAgentManager',
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

                if (f_sPriceType = '01') then
                begin
                    f_nPriceType := 2;  //  (시장가 : 1, 지정가 : 2, STOP-Market : 3, STOP-Limit : 4)
                end else
                if (f_sPriceType = '02') then
                begin
                    f_nPriceType := 1;  //  (시장가 : 1, 지정가 : 2, STOP-Market : 3, STOP-Limit : 4)
                    f_SOrderPrice   := '';
                end else
                begin
                    f_nPriceType    := TFNGlobal.atoi(f_sPriceType);
                end;

                f_nDataType     := f_Record.GetIntegerValue('DATATYPE');            //  1 : 신규, 2 : 정정, 3 : 취소
                f_nBuySell      := f_Record.GetIntegerValue('BUYSELL');             //  1 : BUY, 2 : SELL

                m_AgentLock.Enter;
                try
                    f_SRValue := '-1';
                    if (f_OrderCommand = 1) or (f_OrderCommand = 2) then
                    begin
                        f_SRValue := m_Agent.OSendNewOrder(f_AccountNo, f_Password, f_Symbol, f_nBuySell, f_nPriceType, f_OrderVolume, f_SOrderPrice, '', 1) ;
                    end else
                    if (f_OrderCommand = 3) then
                    begin
                        f_IValue := TFNGlobal.atoi(f_Record.GetStringValue('ORG_ORDER_NO'));
                        f_ORG_ORDER_NO := WriteInteger(f_IValue, 5 , 0);
                        f_SRValue := m_Agent.OSendModiOrder(f_AccountNo, f_Password, f_Symbol, f_SOrderPrice, f_ORG_ORDER_NO, 1);
                    end else
                    if (f_OrderCommand = 4) then
                    begin
                        f_IValue := TFNGlobal.atoi(f_Record.GetStringValue('ORG_ORDER_NO'));
                        f_ORG_ORDER_NO := WriteInteger(f_IValue, 5 , 0);
                        f_SRValue := m_Agent.OSendCancelOrder(f_AccountNo, f_Password, f_Symbol, f_ORG_ORDER_NO, 1);
                    end;

                    f_RQString := '0';
                    f_MessageText := '';
                    f_FieldList := TStringList.Create();
                    try
                        ExtractStrings([':'], [], PChar(f_SRValue), f_FieldList);

                        if f_FieldList.Count >= 2 then
                        begin
                            f_RQString := f_FieldList[0];
                            f_MessageText := f_FieldList[1];
                        end else
                        begin
                            f_RQString := f_FieldList[0];
                            f_MessageText := '';
                        end;
                    finally
                        f_FieldList.Free;
                    end;

                    if '-1' <> f_RQString then
                    begin
                        f_RQID := TFNGlobal.atoi(f_RQString);

                        p_QueryData.m_RequestID := IntToStr(f_RQID);
                        p_QueryData.m_DateTime := Now;
                        p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
                        p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);
                        SetRQTable(p_QueryData.m_RequestID, p_QueryData);
                        p_QueryData := NIL;
                    end else
                    begin
                        MakeDefaultResponse(p_QueryData);
                        WriteMessage(p_QueryData, 'M30001', f_MessageText);
                        WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
                        StoreRecvData(p_QueryData);
                        p_QueryData := NIL;
                    end;

                finally
                    m_AgentLock.Leave;
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
procedure CFNWROAgentManager.SC_QUOTE_TR_0210(p_QueryData: CFNQueryData);
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

//---------------------------------------------------------------------------
procedure CFNWROAgentManager.SC_ACCOUNT_TR_0010(p_QueryData: CFNQueryData);
var
    F: TextFile;
    S: string;
    Line:String;
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
            Line := Trim(S);
            if Copy(Line, 1, 1) = ';' then continue;

            f_FieldList.Clear;
            ExtractStrings([':'], [], PChar(Line), f_FieldList);

            if f_FieldList.Count >= 2 then
            begin
                f_AccountNo     := Trim(f_FieldList[0]);
                f_AccountNo := stringreplace(f_AccountNo,' ','',[rfReplaceAll]);
                f_AccountNo := stringreplace(f_AccountNo,'-','',[rfReplaceAll]);
                f_AccountName   := Trim(f_FieldList[1]);
            end else
            begin
                f_AccountNo     := Trim(f_FieldList[0]);
                f_AccountNo := stringreplace(f_AccountNo,' ','',[rfReplaceAll]);
                f_AccountNo := stringreplace(f_AccountNo,'-','',[rfReplaceAll]);
                f_AccountName   := '';
            end;
            f_OutRecord := CFNRecord.Create;
            f_OutRecord.SetStringValue('ACCOUNT_NO'     , f_AccountNo  );
            f_OutRecord.SetStringValue('ACCOUNT_NAME'   , f_AccountName);
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
procedure CFNWROAgentManager.MakeDefaultResponse(p_QueryData:CFNQueryData);
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
    end;
    {$ENDREGION}
end;

{$ENDREGION}

{$REGION '조회 작업의 응답이 누락 될때'}
//---------------------------------------------------------------------------
procedure CFNWROAgentManager.OnTimeout(p_QueryData:CFNQueryData);
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
{$ENDREGION}

{$REGION '조회 작업의 응답'}
//---------------------------------------------------------------------------
procedure CFNWROAgentManager.OnRecvData(ASender: TObject; const szTrCode: WideString; nRqID: Smallint; nDataLen: Smallint; var szData: WideString);
var
    f_QueryData:CFNQueryData;
    f_OutDataSet : CFNDataSet;
    f_OutRecord : CFNRecord;
    f_InDataSet : CFNDataSet;
    f_InRecord : CFNRecord;
    f_OrderNo:String;
    f_MessageCode:String;
    f_MessageText:String;
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

    f_SValue:String;
    f_NValue:Integer;
    f_DValue:Double;

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

                    f_OutRecord.SetIntegerValue('COUNTRY_NO', f_InRecord.GetIntegerValue('COUNTRY_NO'));
                    f_OutRecord.SetIntegerValue('GROUP_NO'  , f_InRecord.GetIntegerValue('GROUP_NO' ));
                    f_OutRecord.SetIntegerValue('MARKET_NO' , f_InRecord.GetIntegerValue('MARKET_NO'));
                    f_OutRecord.SetStringValue ('SYMBOL'    , f_IORecord.GetStringValue ('SYMBOL'));
                    f_OutRecord.SetStringValue ('NAME'      , f_IORecord.GetStringValue ('NAME'));

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
                    f_OutRecord.SetStringValue ('DATE'           , TFNGlobal.DateToString_YYYYMMDD(f_DateTime));
                    f_OutRecord.SetStringValue ('TIME'           , TFNGlobal.TimeToString_HHMMSS(f_DateTime));

                    f_NValue := f_IORecord.GetIntegerValue('CLOSE_PRICE');
                    f_DValue := f_NValue / f_Factor;
                    f_OutRecord.SetDoubleValue ('CLOSE_PRICE'       , f_DValue);

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

                    f_NValue := f_IORecord.GetIntegerValue('OPEN_PRICE');
                    f_DValue := f_NValue / f_Factor;
                    f_OutRecord.SetDoubleValue('OPEN_PRICE'      , f_DValue);

                    f_NValue := f_IORecord.GetIntegerValue('HIGH_PRICE');
                    f_DValue := f_NValue / f_Factor;
                    f_OutRecord.SetDoubleValue('HIGH_PRICE'      , f_DValue);

                    f_NValue := f_IORecord.GetIntegerValue('LOW_PRICE');
                    f_DValue := f_NValue / f_Factor;
                    f_OutRecord.SetDoubleValue('LOW_PRICE'       , f_DValue);

                    f_OutRecord.SetDoubleValue('TOTAL_VOLUME'    , f_IORecord.GetDoubleValue ('TOTAL_VOLUME'    ));

                    f_NValue := f_IORecord.GetIntegerValue('BEST_OFFER_PRICE');
                    f_DValue := f_NValue / f_Factor;
                    f_OutRecord.SetDoubleValue('BEST_OFFER_PRICE', f_DValue);

                    f_NValue := f_IORecord.GetIntegerValue('BEST_BID_PRICE');
                    f_DValue := f_NValue / f_Factor;
                    f_OutRecord.SetDoubleValue('BEST_BID_PRICE'  , f_DValue);

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
    end else
    {$ENDREGION}

    {$REGION '선물주문'}
    if (f_QueryData.m_ServiceID = 'SC_ORDER') and (f_QueryData.m_TRCode = 'TR_0210') then
    begin
        try
            MakeDefaultResponse(f_QueryData);
            f_OutDataSet := f_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
            f_OutRecord := f_OutDataSet.RecordList.Items[0] as CFNRecord;

            f_DataStream := TStringStream.Create;
            try

                {$REGION '응답패킷을 분석한다'}
                f_DataStream.WriteString(szData);
                m_IOHandler_ORD_OUT.ClearData;
                m_IOHandler_ORD_OUT.SetSourceData(f_DataStream);
                m_IOHandler_ORD_OUT.DecodeData;
                {$ENDREGION}

                {$REGION '첫번째 레크드를 찾는다'}
                f_IORecord := NIL;
                if m_IOHandler_ORD_OUT.m_DataSetList.Count > 0 then
                begin
                    f_IODataSet := m_IOHandler_ORD_OUT.m_DataSetList.Items[0] as CFNIODataSet;
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
                    if TFNGlobal.atoi(f_OrderNo) = 0 then
                    begin
                        f_OrderNo := '';
                    end else
                    begin
                        f_OrderNo := IntToStr(TFNGlobal.atoi(f_OrderNo));
                    end;

                    f_MessageCode := f_IORecord.GetStringValue('MESSAGE_CODE');

                    if f_MessageCode = '0' then
                    begin
                        f_MessageCode := '00000';
                        f_MessageText := '정상적으로 처리되었습니다.';
                    end else
                    begin
                        f_MessageText := '비정상 처리되었습니다.';
                    end;

                    f_MessageCode := 'M' + f_MessageCode;
                    f_OutRecord.SetStringValue('ORDER_NO', f_OrderNo);
                    f_OutRecord.SetStringValue('MESSAGE_CODE', f_MessageCode);

                    WriteMessage(f_QueryData, f_MessageCode, f_MessageText);

                    if f_OrderNo <> '' then
                    begin
                        LOG_WRITE(LOG_TYPE_INFO, 'CFNWROAgentManager',
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
                        LOG_WRITE(LOG_TYPE_ERROR, 'CFNWROAgentManager',
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

                end else
                begin
                    f_OutRecord.SetStringValue('ORDER_NO', '');
                    LOG_WRITE(LOG_TYPE_ERROR, 'CFNWROAgentManager',
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
                {$ENDREGION}

            finally
                f_DataStream.Free;
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
                ClearRQTable(IntToStr(nRqID));
                StoreRecvData(f_QueryData);
            end;
        end;
    end;
    {$ENDREGION}
end;

//---------------------------------------------------------------------------
procedure CFNWROAgentManager.OnRecvMSG(ASender: TObject; const cFlag: WideString; const szMsg: WideString);
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
procedure CFNWROAgentManager.OnRecvRealData(ASender: TObject; nKey: Smallint; nDataLen: Smallint; const szData: WideString);
begin
    m_StringStream.Clear;
    m_StringStream.WriteString(szData);

    m_DataStream.Clear;
    m_StringStream.SaveToStream(m_DataStream);
    m_DataStream.Position := 0;

    //  시세
    if 17 = nKey then
    begin
        Process_RDM_OSTS1(m_DataStream);
    end

    //  주문체결통보
    else if 97 = nKey then
    begin
        Process_RDM_EXEC(m_DataStream);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNWROAgentManager.Process_RDM_OSTS1(ADataStream : TMemoryStream);
var
    f_StreamRecord:CFNStreamRecord;
    f_Record:CIORecord;

    f_SubscribeKey : String;
    f_ObjectList : TObjectList;

    f_Loop: Integer;
    f_DataDelivery : CFNDataDelivery;

    f_Sign:Integer;
    f_Change:Double;

    f_SValue:String;
    f_NValue:Integer;
    f_DValue:Double;
    f_Symbol:String;
    f_DateTime, f_TimeDiffrence:Double;
    f_MaterialItem:CFNMaterialItem;
    f_Factor:Double;

    f_Country, f_Group, f_Market:Integer;
begin
    if not Assigned(m_IODataSet_RDM_OSTS1) then exit;

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

            f_SubscribeKey := f_Record.GetStringValue('SYMBOL');

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
                f_NValue := f_Record.GetIntegerValue('CLOSE_PRICE'     );
                f_DValue := f_NValue / f_Factor;
                f_StreamRecord.SetDoubleValue('PREV_CLOSE'      , f_DValue - f_Change, 2);

                f_NValue := f_Record.GetIntegerValue('CLOSE_PRICE'     );
                f_DValue := f_NValue / f_Factor;
                f_StreamRecord.SetDoubleValue('CLOSE_PRICE'     , f_DValue, 2);

                f_StreamRecord.SetDoubleValue('CHANGE'          , f_Change, 2);


                f_StreamRecord.SetDoubleValue('CHANGERATE'      , f_Record.GetDoubleValue ('CHANGERATE'      ), 2);

                f_NValue := f_Record.GetIntegerValue('BEST_OFFER_PRICE'     );
                f_DValue := f_NValue / f_Factor;
                f_StreamRecord.SetDoubleValue('BEST_OFFER_PRICE', f_DValue, 2);

                f_NValue := f_Record.GetIntegerValue('BEST_BID_PRICE'     );
                f_DValue := f_NValue / f_Factor;
                f_StreamRecord.SetDoubleValue('BEST_BID_PRICE'  , f_DValue, 2);

                f_NValue := f_Record.GetIntegerValue('OPEN_PRICE'     );
                f_DValue := f_NValue / f_Factor;
                f_StreamRecord.SetDoubleValue('OPEN_PRICE'      , f_DValue, 2);

                f_NValue := f_Record.GetIntegerValue('HIGH_PRICE'     );
                f_DValue := f_NValue / f_Factor;
                f_StreamRecord.SetDoubleValue('HIGH_PRICE'      , f_DValue, 2);

                f_NValue := f_Record.GetIntegerValue('LOW_PRICE'     );
                f_DValue := f_NValue / f_Factor;
                f_StreamRecord.SetDoubleValue('LOW_PRICE'       , f_DValue, 2);

                f_StreamRecord.SetDoubleValue('VOLUME'          , f_Record.GetDoubleValue ('VOLUME'          ), 0);
                f_StreamRecord.SetDoubleValue('TOTAL_VOLUME'    , f_Record.GetDoubleValue ('TOTAL_VOLUME'    ), 0);
                f_StreamRecord.SetDoubleValue('TOTAL_VALUE'     , f_Record.GetDoubleValue ('TOTAL_VALUE'     ), 0);
                f_StreamRecord.SetDoubleValue('OPEN_VOLUME'     , f_Record.GetDoubleValue ('OPEN_VOLUME'     ), 0);

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

//---------------------------------------------------------------------------
procedure CFNWROAgentManager.Process_RDM_EXEC(ADataStream : TMemoryStream);
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
    f_Symbol:String;
    f_MaterialItem : CFNMaterialItem;
    f_Factor : Double;

    f_Country, f_Group, f_Market:Integer;
begin
    if not Assigned(m_IODataSet_RDM_EXEC) then exit;

    ADataStream.Position := 0;
    try
        m_IODataSet_RDM_EXEC.ClearRecordList;
        m_IODataSet_RDM_EXEC.DecodeData(ADataStream, 1);
    except
        on E: Exception do
        LOG_WRITE(LOG_TYPE_ERROR, 'CFNWROAgentManager', '패킷분석 실패');
    end;

    if (m_IODataSet_RDM_EXEC.RecordList.Count > 0) then
    begin
        try
            f_Record    := CIORecord(m_IODataSet_RDM_EXEC.RecordList.Items[0]);
            f_DATADIV   := f_Record.GetStringValue('DATADIV');
            f_ORDDIV    := f_Record.GetStringValue('ORDDIV');

            f_StreamRecord := NIL;
            f_StreamRecord2 := NIL;

            {$REGION '거래소접수'}
            if ('12' = f_DATADIV) then
            begin
                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('ORDER_RECEIVE');
                f_StreamRecord.SetStringValue('USERID'      , f_Record.GetStringValue('ORDERUSERID'));
                f_StreamRecord.SetStringValue('ACCOUNT_NO'  , f_Record.GetStringValue('BRKGACNTNO'));

                f_Symbol := Trim(f_Record.GetStringValue('SERIES'));
                f_StreamRecord.SetStringValue('SYMBOL'      , f_Symbol);

                f_MaterialItem := GetMaterialData(f_Symbol, f_Country, f_Group, f_Market);
                if Assigned(f_MaterialItem) then
                begin
                    f_Factor := Power(10, f_MaterialItem.m_Precision);
                end else
                begin
                    f_Factor := 1;
                end;

                if ('11' = f_ORDDIV) or ('12' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_NEW)
                else if ('21' = f_ORDDIV) or ('22' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED)
                else if ('31' = f_ORDDIV) or ('32' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);

                f_SValue := Copy(f_ORDDIV, 2, 1);
                if (f_SValue = '2') then f_NValue := 1
                else if (f_SValue = '1')  then f_NValue := 2
                else f_NValue := 0;

                f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_SValue := f_Record.GetStringValue('ORDQTY');
                f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , TFNGlobal.atoi(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDPX');
                f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , TFNGlobal.atoi(f_SValue) / f_Factor);

                f_SValue := f_Record.GetStringValue('ORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord.SetStringValue('ORDER_NO'        , f_SValue);

                f_SValue := f_Record.GetStringValue('ORGNORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , f_SValue);
                //  거부사유코드
                f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , f_Record.GetStringValue('REJCDMSG'));

                f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNWROAgentManager',
                '신규주문접수; ' +
                '사용자:'           +   f_StreamRecord.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))  + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))        + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')             + '; ' +
                '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')         + '; '
                );

                f_StreamRecord2 := CFNStreamRecord.Create;
                f_StreamRecord2.SetPacketKey('ORDER_CONFIRM');
                f_StreamRecord2.SetStringValue('USERID'      , f_Record.GetStringValue('ORDERUSERID'));
                f_StreamRecord2.SetStringValue('ACCOUNT_NO'  , f_Record.GetStringValue('BRKGACNTNO'));

                f_Symbol := Trim(f_Record.GetStringValue('SERIES'));
                f_StreamRecord2.SetStringValue('SYMBOL'      , f_Symbol);

                f_MaterialItem := GetMaterialData(f_Symbol, f_Country, f_Group, f_Market);
                if Assigned(f_MaterialItem) then
                begin
                    f_Factor := Power(10, f_MaterialItem.m_Precision);
                end else
                begin
                    f_Factor := 1;
                end;

                if ('11' = f_ORDDIV) or ('12' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_NEW)
                else if ('21' = f_ORDDIV) or ('22' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED)
                else if ('31' = f_ORDDIV) or ('32' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);

                f_SValue := Copy(f_ORDDIV, 2, 1);
                if (f_SValue = '2') then f_NValue := 1
                else if (f_SValue = '1')  then f_NValue := 2
                else f_NValue := 0;

                f_StreamRecord2.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_SValue := f_Record.GetStringValue('ORDQTY');
                f_StreamRecord2.SetIntegerValue('ORDER_VOLUME'   , TFNGlobal.atoi(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDPX');
                f_StreamRecord2.SetDoubleValue('ORDER_PRICE'     , TFNGlobal.atoi(f_SValue) / f_Factor);

                f_SValue := f_Record.GetStringValue('ORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord2.SetStringValue('ORDER_NO'        , f_SValue);

                f_SValue := f_Record.GetStringValue('ORGNORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord2.SetStringValue('ORG_ORDER_NO'    , f_SValue);
                //  거부사유코드
                f_StreamRecord2.SetStringValue('ASPR_RJCT_RSCD'  , f_Record.GetStringValue('REJCDMSG'));

                f_StreamRecord2.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord2.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNWROAgentManager',
                '신규주문확인; ' +
                '사용자:'           +   f_StreamRecord2.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_StreamRecord2.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_StreamRecord2.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_DATATYPE'))  + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_COMMAND'))        + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord2.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                '주문번호:'         +   f_StreamRecord2.GetStringValue('ORDER_NO')             + '; ' +
                '원주문번호:'       +   f_StreamRecord2.GetStringValue('ORG_ORDER_NO')         + '; '
                );

            end else
            {$ENDREGION}

            {$REGION '정정확인'}
            if ('13' = f_DATADIV) then
            begin

                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('ORDER_RECEIVE');
                f_StreamRecord.SetStringValue('USERID'          , f_Record.GetStringValue('ORDERUSERID'));
                f_StreamRecord.SetStringValue('ACCOUNT_NO'      , f_Record.GetStringValue('BRKGACNTNO'));

                f_Symbol := Trim(f_Record.GetStringValue('SERIES'));
                f_StreamRecord.SetStringValue('SYMBOL'          , f_Symbol);

                f_MaterialItem := GetMaterialData(f_Symbol, f_Country, f_Group, f_Market);
                if Assigned(f_MaterialItem) then
                begin
                    f_Factor := Power(10, f_MaterialItem.m_Precision);
                end else
                begin
                    f_Factor := 1;
                end;

                if ('11' = f_ORDDIV) or ('12' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_NEW)
                else if ('21' = f_ORDDIV) or ('22' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED)
                else if ('31' = f_ORDDIV) or ('32' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);
                f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED);
                f_SValue := Copy(f_ORDDIV, 2, 1);
                if (f_SValue = '2') then f_NValue := 1
                else if (f_SValue = '1')  then f_NValue := 2
                else f_NValue := 0;

                f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_SValue := f_Record.GetStringValue('ORDQTY');
                f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , TFNGlobal.atoi(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDPX');
                f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , TFNGlobal.atoi(f_SValue) / f_Factor);

                f_SValue := f_Record.GetStringValue('ORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord.SetStringValue('ORDER_NO'        , f_SValue);

                f_SValue := f_Record.GetStringValue('ORGNORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , f_SValue);
                //  거부사유코드
                f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , f_Record.GetStringValue('REJCDMSG'));

                f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNWROAgentManager',
                '정정주문접수; ' +
                '사용자:'           +   f_StreamRecord.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))  + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))        + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')             + '; ' +
                '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')         + '; '
                );


                f_StreamRecord2 := CFNStreamRecord.Create;
                f_StreamRecord2.SetPacketKey('ORDER_CONFIRM');
                f_StreamRecord2.SetStringValue('USERID'      , f_Record.GetStringValue('ORDERUSERID'));
                f_StreamRecord2.SetStringValue('ACCOUNT_NO'  , f_Record.GetStringValue('BRKGACNTNO'));

                f_Symbol := Trim(f_Record.GetStringValue('SERIES'));
                f_StreamRecord2.SetStringValue('SYMBOL'      , f_Symbol);

                f_MaterialItem := GetMaterialData(f_Symbol, f_Country, f_Group, f_Market);
                if Assigned(f_MaterialItem) then
                begin
                    f_Factor := Power(10, f_MaterialItem.m_Precision);
                end else
                begin
                    f_Factor := 1;
                end;

                if ('11' = f_ORDDIV) or ('12' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_NEW)
                else if ('21' = f_ORDDIV) or ('22' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED)
                else if ('31' = f_ORDDIV) or ('32' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);
                f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED);

                f_SValue := Copy(f_ORDDIV, 2, 1);
                if (f_SValue = '2') then f_NValue := 1
                else if (f_SValue = '1')  then f_NValue := 2
                else f_NValue := 0;

                f_StreamRecord2.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_SValue := f_Record.GetStringValue('ORDQTY');
                f_StreamRecord2.SetIntegerValue('ORDER_VOLUME'   , TFNGlobal.atoi(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDPX');
                f_StreamRecord2.SetDoubleValue('ORDER_PRICE'     , TFNGlobal.atoi(f_SValue) / f_Factor);

                f_SValue := f_Record.GetStringValue('ORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord2.SetStringValue('ORDER_NO'        , f_SValue);

                f_SValue := f_Record.GetStringValue('ORGNORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord2.SetStringValue('ORG_ORDER_NO'    , f_SValue);
                //  거부사유코드
                f_StreamRecord2.SetStringValue('ASPR_RJCT_RSCD'  , f_Record.GetStringValue('REJCDMSG'));

                f_StreamRecord2.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord2.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNWROAgentManager',
                '신규주문확인; ' +
                '사용자:'           +   f_StreamRecord2.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_StreamRecord2.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_StreamRecord2.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_DATATYPE'))  + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_COMMAND'))        + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord2.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                '주문번호:'         +   f_StreamRecord2.GetStringValue('ORDER_NO')             + '; ' +
                '원주문번호:'       +   f_StreamRecord2.GetStringValue('ORG_ORDER_NO')         + '; '
                );

            end else
            {$ENDREGION}

            {$REGION '거래소체결'}
            if ('14' = f_DATADIV) then
            begin
                f_SValue := f_Record.GetStringValue('EXECQTY1');
                f_NValue := TFNGlobal.atoi(f_SValue);
                if f_NValue > 0 then
                begin

                    f_StreamRecord := CFNStreamRecord.Create;
                    f_StreamRecord.SetPacketKey('ORDER_TRADE');

                    f_StreamRecord.SetStringValue('USERID'      , f_Record.GetStringValue('ORDERUSERID'));
                    f_StreamRecord.SetStringValue('ACCOUNT_NO'  , f_Record.GetStringValue('BRKGACNTNO'));

                    f_Symbol := Trim(f_Record.GetStringValue('SERIES'));
                    f_StreamRecord.SetStringValue('SYMBOL'      , f_Symbol);

                    f_MaterialItem := GetMaterialData(f_Symbol, f_Country, f_Group, f_Market);
                    if Assigned(f_MaterialItem) then
                    begin
                        f_Factor := Power(10, f_MaterialItem.m_Precision);
                    end else
                    begin
                        f_Factor := 1;
                    end;

                    if ('11' = f_ORDDIV) or ('12' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_NEW)
                    else if ('21' = f_ORDDIV) or ('22' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED)
                    else if ('31' = f_ORDDIV) or ('32' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);


                    f_SValue := Copy(f_ORDDIV, 2, 1);
                    if (f_SValue = '2') then f_NValue := 1
                    else if (f_SValue = '1')  then f_NValue := 2
                    else f_NValue := 0;

                    f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                    f_SValue := f_Record.GetStringValue('ORDQTY');
                    f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , TFNGlobal.atoi(f_SValue));

                    f_SValue := f_Record.GetStringValue('ORDPX');
                    f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , TFNGlobal.atoi(f_SValue) / f_Factor);

                    f_NValue := 0;
                    f_StreamRecord.SetIntegerValue('TRADE_VOLUME_TYPE'   , f_NValue);

                    f_SValue := f_Record.GetStringValue('EXECQTY1');
                    f_NValue := TFNGlobal.atoi(f_SValue);
                    f_StreamRecord.SetIntegerValue('TRADE_VOLUME'   , f_NValue);

                    f_SValue := f_Record.GetStringValue('EXECPX1');
                    f_DValue := TFNGlobal.atoi(f_SValue) / f_Factor;
                    f_StreamRecord.SetDoubleValue('TRADE_PRICE'     , f_DValue);

                    f_SValue := f_Record.GetStringValue('ORDNO');
                    f_NValue := TFNGlobal.atoi(f_SValue);
                    f_SValue := IntToStr(f_NValue);
                    f_StreamRecord.SetStringValue('ORDER_NO'        , f_SValue);

                    f_SValue := f_Record.GetStringValue('ORGNORDNO');
                    f_NValue := TFNGlobal.atoi(f_SValue);
                    f_SValue := IntToStr(f_NValue);
                    f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , f_SValue);

                    //  거부사유코드
                    f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , f_Record.GetStringValue('REJCDMSG'));

                    f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                    f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                    LOG_WRITE(LOG_TYPE_INFO, 'CFNWROAgentManager',
                    '주문체결; ' +
                    '사용자:'           +   f_StreamRecord.GetStringValue('USERID')               + '; ' +
                    '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')           + '; ' +
                    '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')               + '; ' +
                    '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))  + '; ' +
                    '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))        + '; ' +
                    '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                    '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                    '체결량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('TRADE_VOLUME'))+ '; ' +
                    '체결가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('TRADE_PRICE'), 2)+ '; ' +
                    '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')             + '; ' +
                    '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')         + '; '
                    );
                end;
            end else
            {$ENDREGION}

            {$REGION '원주문데이타변경'}
            if ('15' = f_DATADIV) then
            begin

                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('ORDER_RECEIVE');
                f_StreamRecord.SetIntegerValue('CHANGE_ORIGIN_ORDER'      , 1);
                f_StreamRecord.SetStringValue('USERID'      , f_Record.GetStringValue('ORDERUSERID'));
                f_StreamRecord.SetStringValue('ACCOUNT_NO'  , f_Record.GetStringValue('BRKGACNTNO'));

                f_Symbol := Trim(f_Record.GetStringValue('SERIES'));
                f_StreamRecord.SetStringValue('SYMBOL'      , f_Symbol);

                f_MaterialItem := GetMaterialData(f_Symbol, f_Country, f_Group, f_Market);
                if Assigned(f_MaterialItem) then
                begin
                    f_Factor := Power(10, f_MaterialItem.m_Precision);
                end else
                begin
                    f_Factor := 1;
                end;

                if ('11' = f_ORDDIV) or ('12' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_NEW)
                else if ('21' = f_ORDDIV) or ('22' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED)
                else if ('31' = f_ORDDIV) or ('32' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);

                f_SValue := Copy(f_ORDDIV, 2, 1);
                if (f_SValue = '2') then f_NValue := 1
                else if (f_SValue = '1')  then f_NValue := 2
                else f_NValue := 0;

                f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_SValue := f_Record.GetStringValue('ORDQTY');
                f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , TFNGlobal.atoi(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDPX');
                f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , TFNGlobal.atoi(f_SValue) / f_Factor);

                f_SValue := f_Record.GetStringValue('ORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord.SetStringValue('ORDER_NO'        , f_SValue);

                f_SValue := f_Record.GetStringValue('ORGNORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , f_SValue);
                //  거부사유코드
                f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , f_Record.GetStringValue('REJCDMSG'));

                f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNWROAgentManager',
                '취소주문접수; ' +
                '사용자:'           +   f_StreamRecord.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))  + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))        + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')             + '; ' +
                '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')         + '; '
                );

                f_StreamRecord2 := CFNStreamRecord.Create;
                f_StreamRecord2.SetPacketKey('ORDER_CONFIRM');
                f_StreamRecord2.SetIntegerValue('CHANGE_ORIGIN_ORDER'      , 1);

                f_StreamRecord2.SetStringValue('USERID'      , f_Record.GetStringValue('ORDERUSERID'));
                f_StreamRecord2.SetStringValue('ACCOUNT_NO'  , f_Record.GetStringValue('BRKGACNTNO'));

                f_Symbol := Trim(f_Record.GetStringValue('SERIES'));
                f_StreamRecord2.SetStringValue('SYMBOL'      , f_Symbol);

                if ('11' = f_ORDDIV) or ('12' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_NEW)
                else if ('21' = f_ORDDIV) or ('22' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED)
                else if ('31' = f_ORDDIV) or ('32' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);

                f_SValue := Copy(f_ORDDIV, 2, 1);
                if (f_SValue = '2') then f_NValue := 1
                else if (f_SValue = '1')  then f_NValue := 2
                else f_NValue := 0;

                f_StreamRecord2.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_SValue := f_Record.GetStringValue('ORDQTY');
                f_StreamRecord2.SetIntegerValue('ORDER_VOLUME'   , TFNGlobal.atoi(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDPX');
                f_StreamRecord2.SetDoubleValue('ORDER_PRICE'     , TFNGlobal.atoi(f_SValue) / f_Factor);

                f_SValue := f_Record.GetStringValue('ORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord2.SetStringValue('ORDER_NO'        , f_SValue);

                f_SValue := f_Record.GetStringValue('ORGNORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord2.SetStringValue('ORG_ORDER_NO'    , f_SValue);
                //  거부사유코드
                f_StreamRecord2.SetStringValue('ASPR_RJCT_RSCD'  , f_Record.GetStringValue('REJCDMSG'));

                f_StreamRecord2.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord2.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNWROAgentManager',
                '취소주문확인; ' +
                '사용자:'           +   f_StreamRecord2.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_StreamRecord2.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_StreamRecord2.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_DATATYPE'))  + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_COMMAND'))        + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord2.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                '주문번호:'         +   f_StreamRecord2.GetStringValue('ORDER_NO')             + '; ' +
                '원주문번호:'       +   f_StreamRecord2.GetStringValue('ORG_ORDER_NO')         + '; '
                );

            end else
            {$ENDREGION}

            {$REGION '취소확인'}
            if ('16' = f_DATADIV) then
            begin

                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('ORDER_RECEIVE');
                f_StreamRecord.SetStringValue('USERID'      , f_Record.GetStringValue('ORDERUSERID'));
                f_StreamRecord.SetStringValue('ACCOUNT_NO'  , f_Record.GetStringValue('BRKGACNTNO'));

                f_Symbol := Trim(f_Record.GetStringValue('SERIES'));
                f_StreamRecord.SetStringValue('SYMBOL'      , f_Symbol);

                f_MaterialItem := GetMaterialData(f_Symbol, f_Country, f_Group, f_Market);
                if Assigned(f_MaterialItem) then
                begin
                    f_Factor := Power(10, f_MaterialItem.m_Precision);
                end else
                begin
                    f_Factor := 1;
                end;

                (*
                if ('11' = f_ORDDIV) or ('12' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_NEW)
                else if ('21' = f_ORDDIV) or ('22' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED)
                else if ('31' = f_ORDDIV) or ('32' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);
                *)
                f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);

                f_SValue := Copy(f_ORDDIV, 2, 1);
                if (f_SValue = '2') then f_NValue := 1
                else if (f_SValue = '1')  then f_NValue := 2
                else f_NValue := 0;

                f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_SValue := f_Record.GetStringValue('ORDQTY');
                f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , TFNGlobal.atoi(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDPX');
                f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , TFNGlobal.atoi(f_SValue) / f_Factor);

                f_SValue := f_Record.GetStringValue('ORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord.SetStringValue('ORDER_NO'        , f_SValue);

                f_SValue := f_Record.GetStringValue('ORGNORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , f_SValue);
                //  거부사유코드
                f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , f_Record.GetStringValue('REJCDMSG'));

                f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNWROAgentManager',
                '취소주문접수; ' +
                '사용자:'           +   f_StreamRecord.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))  + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))        + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                '주문번호:'         +   f_StreamRecord.GetStringValue('ORDER_NO')             + '; ' +
                '원주문번호:'       +   f_StreamRecord.GetStringValue('ORG_ORDER_NO')         + '; '
                );

                f_StreamRecord2 := CFNStreamRecord.Create;
                f_StreamRecord2.SetPacketKey('ORDER_CONFIRM');
                f_StreamRecord2.SetStringValue('USERID'      , f_Record.GetStringValue('ORDERUSERID'));
                f_StreamRecord2.SetStringValue('ACCOUNT_NO'  , f_Record.GetStringValue('BRKGACNTNO'));

                f_Symbol := Trim(f_Record.GetStringValue('SERIES'));
                f_StreamRecord2.SetStringValue('SYMBOL'      , f_Symbol);

                (*
                if ('11' = f_ORDDIV) or ('12' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_NEW)
                else if ('21' = f_ORDDIV) or ('22' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED)
                else if ('31' = f_ORDDIV) or ('32' = f_ORDDIV) then f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);
                *)
                f_StreamRecord2.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);

                f_SValue := Copy(f_ORDDIV, 2, 1);
                if (f_SValue = '2') then f_NValue := 1
                else if (f_SValue = '1')  then f_NValue := 2
                else f_NValue := 0;

                f_StreamRecord2.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_SValue := f_Record.GetStringValue('ORDQTY');
                f_StreamRecord2.SetIntegerValue('ORDER_VOLUME'   , TFNGlobal.atoi(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDPX');
                f_StreamRecord2.SetDoubleValue('ORDER_PRICE'     , TFNGlobal.atoi(f_SValue) / f_Factor);

                f_SValue := f_Record.GetStringValue('ORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord2.SetStringValue('ORDER_NO'        , f_SValue);

                f_SValue := f_Record.GetStringValue('ORGNORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord2.SetStringValue('ORG_ORDER_NO'    , f_SValue);
                //  거부사유코드
                f_StreamRecord2.SetStringValue('ASPR_RJCT_RSCD'  , f_Record.GetStringValue('REJCDMSG'));

                f_StreamRecord2.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord2.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_INFO, 'CFNWROAgentManager',
                '취소주문확인; ' +
                '사용자:'           +   f_StreamRecord2.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_StreamRecord2.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_StreamRecord2.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_DATATYPE'))  + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_COMMAND'))        + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord2.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord2.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
                '주문번호:'         +   f_StreamRecord2.GetStringValue('ORDER_NO')             + '; ' +
                '원주문번호:'       +   f_StreamRecord2.GetStringValue('ORG_ORDER_NO')         + '; '
                );

            end else
            {$ENDREGION}

            {$REGION '거래소거부'}
            if ('19' = f_DATADIV) then
            begin
                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('ORDER_REJECT');

                f_StreamRecord.SetStringValue('USERID'      , f_Record.GetStringValue('ORDERUSERID'));
                f_StreamRecord.SetStringValue('ACCOUNT_NO'  , f_Record.GetStringValue('BRKGACNTNO'));

                f_Symbol := Trim(f_Record.GetStringValue('SERIES'));
                f_StreamRecord.SetStringValue('SYMBOL'      , f_Symbol);

                f_MaterialItem := GetMaterialData(f_Symbol, f_Country, f_Group, f_Market);
                if Assigned(f_MaterialItem) then
                begin
                    f_Factor := Power(10, f_MaterialItem.m_Precision);
                end else
                begin
                    f_Factor := 1;
                end;

                if ('11' = f_ORDDIV) or ('12' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_NEW)
                else if ('21' = f_ORDDIV) or ('22' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_AMENDED)
                else if ('31' = f_ORDDIV) or ('32' = f_ORDDIV) then f_StreamRecord.SetIntegerValue('ORDER_DATATYPE' , ODT_CANCEL);

                f_SValue := Copy(f_ORDDIV, 2, 1);
                if (f_SValue = '2') then f_NValue := 1
                else if (f_SValue = '1')  then f_NValue := 2
                else f_NValue := 0;

                f_StreamRecord.SetIntegerValue('ORDER_COMMAND'  , f_NValue);

                f_SValue := f_Record.GetStringValue('ORDQTY');
                f_StreamRecord.SetIntegerValue('ORDER_VOLUME'   , TFNGlobal.atoi(f_SValue));

                f_SValue := f_Record.GetStringValue('ORDPX');
                f_StreamRecord.SetDoubleValue('ORDER_PRICE'     , TFNGlobal.atoi(f_SValue) / f_Factor);

                f_SValue := f_Record.GetStringValue('ORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord.SetStringValue('ORDER_NO'        , f_SValue);

                f_SValue := f_Record.GetStringValue('ORGNORDNO');
                f_NValue := TFNGlobal.atoi(f_SValue);
                f_SValue := IntToStr(f_NValue);
                f_StreamRecord.SetStringValue('ORG_ORDER_NO'    , f_SValue);
                //  거부사유코드
                f_StreamRecord.SetStringValue('ASPR_RJCT_RSCD'  , f_Record.GetStringValue('REJCDMSG'));

                f_StreamRecord.SetIntegerValue('ACCEPT'         , 0);
                f_StreamRecord.SetDoubleValue('RECEIVE_TIME'    , Now);

                LOG_WRITE(LOG_TYPE_ERROR, 'CFNWROAgentManager',
                '주문거부; ' +
                '사용자:'           +   f_StreamRecord.GetStringValue('USERID')               + '; ' +
                '계좌:'             +   f_StreamRecord.GetStringValue('ACCOUNT_NO')           + '; ' +
                '종목:'             +   f_StreamRecord.GetStringValue('SYMBOL')               + '; ' +
                '주문데이터유형:'   +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_DATATYPE'))  + '; ' +
                '매매구분:'         +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_COMMAND'))        + '; ' +
                '주문량:'           +   IntToStr(f_StreamRecord.GetIntegerValue('ORDER_VOLUME'))+ '; ' +
                '주문가:'           +   TFNGlobal.WriteNumber(f_StreamRecord.GetDoubleValue('ORDER_PRICE'), 2)+ '; ' +
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

{$ENDREGION}

{$REGION '소켓의 접속이상'}
//---------------------------------------------------------------------------
procedure CFNWROAgentManager.OnSocketStatus(ASender: TObject; nStatus: Smallint);
begin
    if 0 = nStatus then
    begin
        LOG_WRITE(LOG_TYPE_ERROR, 'CFNWROAgentManager', '통신이 종료되었습니다.');
        if Assigned(m_DisconnectEvent) then
        begin
            m_DisconnectEvent(Self);
        end;
    end;
end;
{$ENDREGION}

{$REGION '각 종 함수들'}
//---------------------------------------------------------------------------
procedure CFNWROAgentManager.GetGategory(ASymbol:String; var ACountry : Integer; var AGroup : Integer; var AMarket : Integer);
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
function CFNWROAgentManager.GetMaterialData(ASymbol:String; var ACountry : Integer; var AGroup : Integer; var AMarket : Integer):CFNMaterialItem;
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
function CFNWROAgentManager.WriteInteger(AValue, ASize: Integer; APrecision: Integer):String;
var
    f_Source:String;
    f_Index:Integer;
begin
    f_Source := Format('%*d', [ASize, AValue]);
    for f_Index := 1 to Length(f_Source) do
    begin
        if f_Source[f_Index] = ' ' then f_Source[f_Index] := '0'
        else break;
    end;
    Result := f_Source;
end;

{$ENDREGION}

end.

