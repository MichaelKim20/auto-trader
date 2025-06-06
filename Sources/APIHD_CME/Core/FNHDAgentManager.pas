// **************************************************************************//
// FileName        :   FNHDAgentManager.pas
// Author          :   김무근 작성
// Date            :   2015년 08월 11일
// Description     :   현대선물사 해외API를 통해, 시세와 주문을 구현하기 위한 클래스
// **************************************************************************//
{ 현대선물사 API를 통해, 시세와 주문을 구현하기 위한 클래스 }
Unit FNHDAgentManager;

interface

uses
  VCL.ExtCtrls, VCL.Dialogs, Messages, WinProcs, SysUtils, VCL.Forms, ActiveX, WinTypes, Classes, SyncObjs,
  Contnrs, IniFiles, VarUtils, Variants, Math, FNDataSet, FNDataDelivery, FNIOHandler,
  FNAgentManager, HDFCommAgentLib_TLB, IODataSet, FNMaterialCollection, FNQueue, FNMultiMap;

type
  /// <author>김무근</author>
  /// <version>1.0</version>
  /// <since>2015.08.11</since>
  /// <Comment>현대선물 API를 이용하여 필요한 기능을 확장한 클래스</Comment>
  CFNHDAgentManager = class(CFNAgentManager)
  public
    /// <Comment>생성자</Comment>
    Constructor Create(AQueryThreadCount: Integer = 1);

    /// <Comment>파괴자</Comment>
    Destructor Destroy; override;

    procedure Initialize; override;
    procedure Finalize; override;
    procedure Resume; override;
    procedure Suspend; override;

    /// <Comment>증권사 API OCX를 등록한다.</Comment>
    procedure AssignAgent(p_Agent: THDFCommAgent);

    /// <Comment>메인 윈도우의 핸들을 등록한다.</Comment>
    procedure AssignHandle(p_Handle: HWND);

    /// <Comment>작업쓰레드가 진입하는 곳</Comment>
    procedure DoQueryWork(AThreadIndex: Integer); override;

    procedure DoCheckTimeout;

    /// <Comment>시세 실시간 스트리밍 데이터를 요청한다.</Comment>
    procedure SubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String); override;

    /// <Comment>시세 실시간 스트리밍 데이터를 해지한다.</Comment>
    procedure UnsubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String); override;

    /// <Comment>호가 실시간 스트리밍 데이터를 요청한다.</Comment>
    procedure SubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String); override;

    /// <Comment>호가 실시간 스트리밍 데이터를 해지한다.</Comment>
    procedure UnsubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String); override;

    /// <Comment>주문체결통보 실시간 스트리밍 데이터를 요청한다.</Comment>
    procedure SubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = ''); override;

    /// <Comment>주문체결통보 실시간 스트리밍 데이터를 요청한다.</Comment>
    procedure UnsubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = ''); override;

    procedure ReSubscribeAll; override;

  private
    m_RQIndex: Integer;
    m_RQLock: TCriticalSection;
    m_MaterialItem: CFNMaterialItem;

    function GetRQIndex: Integer;

    function GetMaterialData(ASymbol: String; var ACountry: Integer; var AGroup: Integer; var AMarket: Integer): CFNMaterialItem;
    procedure GetGategory(ASymbol: String; var ACountry: Integer; var AGroup: Integer; var AMarket: Integer);

  private
    /// <Comment>증권사 연결 OCX</Comment>
    m_Agent: THDFCommAgent;
    m_AgentLock: TCriticalSection;

    /// <Comment>메인 윈도우의 핸들</Comment>
    m_Handle: HWND;

    m_AccountDataSet: CFNDataSet;

    procedure SC_ACCOUNT_TR_0010(p_QueryData: CFNQueryData);

    /// <Comment>선물시세 조회 패킷을 만들어서 Agent에 전달한다.</Comment>
    procedure SC_QUOTE_TR_0210(p_QueryData: CFNQueryData);

    /// <Comment>선물주문 패킷을 만들어서 Agent에 전달한다.</Comment>
    procedure SC_ORDER_TR_0210(p_QueryData: CFNQueryData);

    procedure MakeDefaultResponse(p_QueryData: CFNQueryData);

    /// <Comment>패킷중 에러코드와 메세지를 추가하는 부분</Comment>
    procedure WriteMessage(p_QueryData: CFNQueryData; sErrorCode, sMsg: WideString);

    /// <Comment>패킷중 에러코드와 메세지를 추가하는 부분</Comment>
    procedure WriteError(p_QueryData: CFNQueryData; sErrorCode: WideString);

    procedure OnTimeout(p_QueryData: CFNQueryData);

  public
    procedure OnDataRecv(ASender: TObject; const sTrCode: WideString; nRqId: Integer);
    procedure OnGetMsgWithRqId(ASender: TObject; nRqId: Integer; const sCode: WideString; const sMsg: WideString);

    procedure OnGetBroadData(ASender: TObject; const sJongmokCode: WideString; nRealType: Integer);

  public
    property Handle: HWND read m_Handle write AssignHandle;

  private
    m_QueryTimer: TTimer;
    m_ProcTimer: TTimer;

    procedure OnQueryTimer(ASender: TObject);
    procedure OnProcTimer(ASender: TObject);

    procedure OnQuoteData(ASender: TObject; const sKey: WideString; nRealType: Integer);
    procedure OnTradeData(ASender: TObject; const sKey: WideString; nRealType: Integer);
    procedure DoCheckSocketStatus;

  end;

function WriteInteger(AValue: Integer; ASize: Integer): String;
function WriteDouble(AValue: Double; ASize: Integer; APrecision: Integer): String;
function WriteString(AValue: String; ASize: Integer): String;

function ReadString(ASource: String): String;
function ReadInteger(ASource: String): Integer;
function ReadDouble(ASource: String; APrecision: Integer): Double;

implementation

uses
  FNGlobal, FNGlobalVariable, WideStrUtils, CommonTRMaker, FNTradeSystem, HDIOMaker, FNCMVariable, MXVariable;

{$REGION '생성자와 파괴자'}

// ---------------------------------------------------------------------------
Constructor CFNHDAgentManager.Create(AQueryThreadCount: Integer = 1);
begin
  Initialize;

  m_QueryTimer := TTimer.Create(NIL);
  m_ProcTimer := TTimer.Create(NIL);

  m_QueryTimer.Enabled := false;
  m_QueryTimer.OnTimer := OnQueryTimer;
  m_QueryTimer.Interval := 10;

  m_ProcTimer.Enabled := false;
  m_ProcTimer.OnTimer := OnProcTimer;
  m_ProcTimer.Interval := 10;

  m_MaterialItem := NIL;
  m_RQIndex := 0;

  m_AgentLock := TCriticalSection.Create;
  m_RQLock := TCriticalSection.Create;

  m_QueryTimer.Enabled := true;
  m_ProcTimer.Enabled := true;

  m_AccountDataSet := CFNDataSet.Create;
end;

// ---------------------------------------------------------------------------
Destructor CFNHDAgentManager.Destroy;
begin
  m_AgentLock.Free;
  m_RQLock.Free;

  Stop;

  Finalize;

  if Assigned(m_QueryTimer) then
  begin
    m_QueryTimer.Free;
    m_QueryTimer := NIL;
  end;

  if Assigned(m_ProcTimer) then
  begin
    m_ProcTimer.Free;
    m_ProcTimer := NIL;
  end;

  m_AccountDataSet.Free;
end;
{$ENDREGION}

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.Initialize;
begin
  m_RecvQueue := CFNQueue.Create;
  m_SendQueue := CFNQueue.Create;

  m_QueryTableLock := TCriticalSection.Create;

  m_QueryTable := THashedStringList.Create;

  m_STSubscribeTable[0] := CFNMultiMap.Create; // 시세
  m_STSubscribeTable[0].SetAutoFree(false);

  m_STSubscribeTable[1] := CFNMultiMap.Create; // 호가
  m_STSubscribeTable[1].SetAutoFree(false);

  m_STSubscribeTable[2] := CFNMultiMap.Create; // 주문,체결통보
  m_STSubscribeTable[2].SetAutoFree(false);

  m_STRecordLock := TCriticalSection.Create;
  m_STRecordList := TObjectList.Create;

  m_STSubscribeTableLock := TCriticalSection.Create;

  m_State := AGENT_THREAD_STOP;
end;

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.Finalize;
begin
  ClearAll;

  if (m_RecvQueue <> NIL) then
    m_RecvQueue.Free;
  m_RecvQueue := NIL;

  if (m_SendQueue <> NIL) then
    m_SendQueue.Free;
  m_SendQueue := NIL;

  if (m_QueryTableLock <> NIL) then
    m_QueryTableLock.Free;
  m_QueryTableLock := NIL;

  if (m_QueryTable <> NIL) then
    m_QueryTable.Free;
  m_QueryTable := NIL;

  if (m_STSubscribeTable[0] <> NIL) then
    m_STSubscribeTable[0].Free;
  m_STSubscribeTable[0] := NIL;
  if (m_STSubscribeTable[1] <> NIL) then
    m_STSubscribeTable[1].Free;
  m_STSubscribeTable[1] := NIL;
  if (m_STSubscribeTable[2] <> NIL) then
    m_STSubscribeTable[2].Free;
  m_STSubscribeTable[2] := NIL;

  if (m_STRecordLock <> NIL) then
    m_STRecordLock.Free;
  m_STRecordLock := NIL;

  if (m_STRecordList <> NIL) then
    m_STRecordList.Free;
  m_STRecordList := NIL;

  if (m_STSubscribeTableLock <> NIL) then
    m_STSubscribeTableLock.Free;
  m_STSubscribeTableLock := NIL;

  m_State := AGENT_THREAD_STOP;
end;

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.OnQueryTimer(ASender: TObject);
begin
  if (m_State = AGENT_THREAD_START) then
  begin
    DoQueryWork(0);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.OnProcTimer(ASender: TObject);
begin
  if (m_State = AGENT_THREAD_START) then
  begin
    DoProcWork();
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.Resume;
begin

end;

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.Suspend;
begin

end;

{$REGION 'API Control의 설정'}

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.AssignAgent(p_Agent: THDFCommAgent);
begin
  m_Agent := p_Agent;

  if Assigned(m_Agent) then
  begin
    m_Agent.OnDataRecv := OnDataRecv;
    m_Agent.OnGetBroadData := OnGetBroadData;
    m_Agent.OnGetMsgWithRqId := OnGetMsgWithRqId;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.AssignHandle(p_Handle: HWND);
begin
  m_Handle := p_Handle;
end;
{$ENDREGION}
{$REGION '실시간 처리함수들'}

// ---------------------------------------------------------------------------
// 선물 스트리밍 시세 등록
procedure CFNHDAgentManager.SubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String);
var
  LSubscribeKey: String;
begin
  if not Assigned(m_Agent) then
    exit;
  LSubscribeKey := ASymbol;
  if m_STSubscribeTable[MAP_CURRENT].AddKeyValue(LSubscribeKey, ADataDelivery) then
  begin
    m_Agent.CommSetBroad(WriteString(ASymbol, 32), 84);
  end;
end;

// ---------------------------------------------------------------------------
// 선물 스트리밍 호가 등록
procedure CFNHDAgentManager.SubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String);
var
  LSubscribeKey: String;
begin
  if not Assigned(m_Agent) then
    exit;
  LSubscribeKey := ASymbol;
  if m_STSubscribeTable[MAP_BIDOFFER].AddKeyValue(LSubscribeKey, ADataDelivery) then
  begin
    m_Agent.CommSetBroad(WriteString(ASymbol, 32), 76);
  end;
end;

// ---------------------------------------------------------------------------
// 선물 스트리밍 체결통보 등록
procedure CFNHDAgentManager.SubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = '');
var
  LKey: String;
begin
  LKey := AUserID + ':' + AAccountNO;
  if not Assigned(m_Agent) then
    exit;
  if m_STSubscribeTable[MAP_USERTRADE].AddKeyValue(LKey, ADataDelivery) then
  begin
    m_Agent.CommSetJumunChe(AUserID, WriteString(AAccountNO, 11));
  end;
end;

// ---------------------------------------------------------------------------
// 선물 스트리밍 시세 등록 해지
procedure CFNHDAgentManager.UnsubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String);
var
  LSubscribeKey: String;
begin
  if not Assigned(m_Agent) then
    exit;
  LSubscribeKey := ASymbol;

  if m_STSubscribeTable[MAP_CURRENT].DeleteKeyValue(LSubscribeKey, ADataDelivery) then
  begin
    m_Agent.CommRemoveBroad(WriteString(ASymbol, 32), 84);
  end;
end;

// ---------------------------------------------------------------------------
// 선물 스트리밍 호가 등록 해지
procedure CFNHDAgentManager.UnsubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String);
var
  LSubscribeKey: String;
begin
  if not Assigned(m_Agent) then
    exit;
  LSubscribeKey := ASymbol;

  if m_STSubscribeTable[MAP_BIDOFFER].DeleteKeyValue(LSubscribeKey, ADataDelivery) then
  begin
    m_Agent.CommRemoveBroad(WriteString(ASymbol, 32), 76);
  end;
end;

// ---------------------------------------------------------------------------
// 선물 스트리밍 체결통보 등록 해지
procedure CFNHDAgentManager.UnsubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = '');
var
  LKey: String;
begin
  LKey := AUserID + ':' + AAccountNO;
  if not Assigned(m_Agent) then
    exit;
  if m_STSubscribeTable[MAP_USERTRADE].DeleteKeyValue(LKey, ADataDelivery) then
  begin
    m_Agent.CommRemoveJumunChe(AUserID, WriteString(AAccountNO, 11));
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.ReSubscribeAll;
var
  LKeyList: TStringList;
  LIndex: Integer;
  LKey: string;
  LSBID: Integer;

  LCountry: Integer;
  LGroup: Integer;
  LMarket: Integer;
  LSymbol: string;
  LFieldList: TStringList;
begin
  if Assigned(m_Agent) then
  begin
    m_Agent.OnDataRecv := OnDataRecv;
    m_Agent.OnGetBroadData := OnGetBroadData;
    m_Agent.OnGetMsgWithRqId := OnGetMsgWithRqId;
  end;

  LFieldList := TStringList.Create();
  try
    LKeyList := m_STSubscribeTable[MAP_CURRENT].GetAllKeys;
    if LKeyList <> NIL then
    begin
      for LIndex := 0 to LKeyList.Count - 1 do
      begin
        LKey := LKeyList[LIndex];
        m_Agent.CommSetBroad(WriteString(LKey, 32), 84);
      end;
      LKeyList.Free;
    end;

    LKeyList := m_STSubscribeTable[MAP_BIDOFFER].GetAllKeys;
    if LKeyList <> NIL then
    begin
      for LIndex := 0 to LKeyList.Count - 1 do
      begin
        LKey := LKeyList[LIndex];
        m_Agent.CommSetBroad(WriteString(LKey, 32), 76);
      end;
      LKeyList.Free;
    end;

    LKeyList := m_STSubscribeTable[MAP_USERTRADE].GetAllKeys;
    if LKeyList <> NIL then
    begin
      for LIndex := 0 to LKeyList.Count - 1 do
      begin
        LKey := LKeyList[LIndex];
        LFieldList.Clear;
        ExtractStrings([':'], [], PChar(LKey), LFieldList);
        m_Agent.CommSetJumunChe(LFieldList[0], WriteString(LFieldList[1], 11));
      end;
      LKeyList.Free;
    end;

  finally
    LFieldList.Free;
  end;
end;
{$ENDREGION}
{$REGION '조회 작업을 처리하기 위한 함수들'}

// ---------------------------------------------------------------------------
// 조회데이터의 전달할 CFNDelivery객체를 저장할 인덱스 m_RQSubscribeIndex를 가져온다. 이 후에 이값을 1 증가시킨다.
// 배열의 크기가 1024이므로 m_RQSubscribeIndex의 값이 1024보다 크거나 같으면 0으로 초기화 한다.
function CFNHDAgentManager.GetRQIndex: Integer;
begin
  m_RQLock.Enter;
  try
    Inc(m_RQIndex);
    if 11 < m_RQIndex then
      m_RQIndex := 0;
    Result := m_RQIndex;
  finally
    m_RQLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// Agent로 요청한 요청패킷을 하나 씩 꺼내 분석하여, 그 업무에 맞는 Agent내 함수를 이용하여 증권사로 요청을 한다.
procedure CFNHDAgentManager.DoQueryWork(AThreadIndex: Integer);
var
  LQueryData: CFNQueryData;
begin

  DoCheckTimeout;
  DoCheckSocketStatus;

  LQueryData := RetrieveSendData;
  if not Assigned(LQueryData) then
    exit;

  if LQueryData.m_ServiceID = 'SC_ACCOUNT' then
  begin
    // 계좌 마스트
    if (LQueryData.m_TRCode = 'TR_0010') then
    begin
      SC_ACCOUNT_TR_0010(LQueryData);
    end
    else
    begin
      WriteError(LQueryData, 'M10001');
      StoreRecvData(LQueryData);
    end;
    Sleep(100);
  end
  else if LQueryData.m_ServiceID = 'SC_QUOTE' then
  begin
    // 선물 시세
    if (LQueryData.m_TRCode = 'TR_0210') then
    begin
      SC_QUOTE_TR_0210(LQueryData);
    end
    else
    begin
      WriteError(LQueryData, 'M10001');
      StoreRecvData(LQueryData);
    end;
    Sleep(100);
  end
  else if LQueryData.m_ServiceID = 'SC_ORDER' then
  begin
    // 선물 주문
    if (LQueryData.m_TRCode = 'TR_0210') then
    begin
      SC_ORDER_TR_0210(LQueryData);
    end
    else
    begin
      WriteError(LQueryData, 'M10001');
      StoreRecvData(LQueryData);
    end;
    Sleep(100);
  end
  else
  begin
    WriteError(LQueryData, 'M10001');
    StoreRecvData(LQueryData);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.DoCheckTimeout;
var
  LIndex: Integer;
  LQueryData: CFNQueryData;
  LCheckTime: TDateTime;
  LDone: Boolean;
begin
  LCheckTime := Now;
  LQueryData := NIL;
  m_QueryTableLock.Enter;
  try
    LDone := false;
    while not LDone do
    begin
      LDone := true;
      for LIndex := 0 to m_QueryTable.Count - 1 do
      begin
        LQueryData := CFNQueryData(m_QueryTable.Objects[LIndex]);

        if (LCheckTime - LQueryData.m_DateTime) * 86400 > 5 then
        begin
          LOG_WRITE(LOG_TYPE_INFO, 'CFNHDAgentManager', '요청타임아웃처리; ' + 'ServiceID:' + LQueryData.m_ServiceID + '; ' + 'TRCode:' + LQueryData.m_TRCode + '; ' + 'Time"' + IntToStr(Trunc((LCheckTime - LQueryData.m_DateTime) * 86400)));
          m_QueryTable.Delete(LIndex);
          OnTimeout(LQueryData);
          LDone := false;
          break;
        end;
      end;
    end;
  finally
    m_QueryTableLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// 패킷중 에러코드와 메세지를 추가하는 부분
procedure CFNHDAgentManager.WriteMessage(p_QueryData: CFNQueryData; sErrorCode, sMsg: WideString);
var
  rd: CFNRecord;
begin
  if sErrorCode = 'M00000' then
  begin
    p_QueryData.m_Response.SetMsgCode(sErrorCode);
    p_QueryData.m_Response.SetErrorCode('E00000');
    rd := CFNRecord.Create;
    rd.SetStringValue('MESSAGE_CODE', sErrorCode);
    rd.SetStringValue('MESSAGE', sMsg);
    p_QueryData.m_Response.m_MessageDataSet.RecordList.Add(rd);
  end
  else if sErrorCode = 'M99999' then
  begin
    p_QueryData.m_Response.SetMsgCode(sErrorCode);
    rd := CFNRecord.Create;
    rd.SetStringValue('MESSAGE_CODE', sErrorCode);
    rd.SetStringValue('MESSAGE', sMsg);
    p_QueryData.m_Response.m_MessageDataSet.RecordList.Add(rd);
  end
  else
  begin
    p_QueryData.m_Response.SetErrorCode(sErrorCode);
    rd := CFNRecord.Create;
    rd.SetStringValue('ERROR_CODE', sErrorCode);
    rd.SetStringValue('MESSAGE', sMsg);
    p_QueryData.m_Response.m_ErrorDataSet.RecordList.Add(rd);
  end;
end;

// ---------------------------------------------------------------------------
// 패킷중 에러코드와 메세지를 추가하는 부분
procedure CFNHDAgentManager.WriteError(p_QueryData: CFNQueryData; sErrorCode: WideString);
var
  rd: CFNRecord;
begin
  p_QueryData.m_Response.SetErrorCode(sErrorCode);
  rd := CFNRecord.Create;
  rd.SetStringValue('ERROR_CODE', sErrorCode);

  if sErrorCode = 'M10001' then
  begin
    rd.SetStringValue('MESSAGE', '해당 TR이 존재하지 않습니다.');
  end
  else if sErrorCode = 'M10002' then
  begin
    rd.SetStringValue('MESSAGE', '입력레코드가 존재하지 않습니다.');
  end
  else if sErrorCode = 'M10003' then
  begin
    rd.SetStringValue('MESSAGE', '입력데이터셋이 존재하지 않습니다.');
  end
  else if sErrorCode = 'M30001' then
  begin
    rd.SetStringValue('MESSAGE', '주문 전달에 오류가 발생했습니다.');
  end
  else if sErrorCode = 'M60001' then
  begin
    rd.SetStringValue('MESSAGE', '오류가 발생했습니다.');
  end
  else if sErrorCode = 'M90001' then
  begin
    rd.SetStringValue('MESSAGE', '응답시간이 초과되었습니다.');
  end;

  p_QueryData.m_Response.m_ErrorDataSet.RecordList.Add(rd);
end;

// ---------------------------------------------------------------------------
// 선물주문 패킷을 만들어서 Agent에 전달한다.
procedure CFNHDAgentManager.SC_ORDER_TR_0210(p_QueryData: CFNQueryData);
var
  LDataSet: CFNDataSet;
  LRecord: CFNRecord;
  LAccountNo: String;
  LPassword: String;
  LSymbol: String;
  LOrderCommand: Integer;
  LOrderVolume: Integer;
  LOrderPrice: Double;
  LnBuySell: Integer;
  LDataType: Integer;
  LPriceType: String;

  LHDBuySell: String;
  LHDPriceType: String;
  LHDOrderPrice: String;

  LORG_ORDER_NO: String;
  LIValue: Integer;
  LRQID: Integer;
  LRValue: Integer;
  LSRValue: String;

  LMaterialItem: CFNMaterialItem;
  LPrecesion: Integer;
  LCountry: Integer;
  LGroup: Integer;
  LMarket: Integer;

  LIORecord: CFNIORecord;
  LIOHandler: CFNIOHandler;
  LSendStream: TStringStream;
  LDataString: String;
  LDataSize: Integer;
begin
  try
    LDataSet := p_QueryData.m_Request.GetDataSet(DATASETID_IN_01);
    if Assigned(LDataSet) then
    begin
      if (0 < LDataSet.RecordList.Count) then
      begin
        LRecord := CFNRecord(LDataSet.RecordList.Items[0]);
        LAccountNo := LRecord.GetStringValue('ACCOUNT_NO'); // 계좌번호
        LPassword := LRecord.GetStringValue('PASSWORD'); // 계좌비번
        LSymbol := LRecord.GetStringValue('SYMBOL'); // 종목코드

        LMaterialItem := GetMaterialData(LSymbol, LCountry, LGroup, LMarket);
        if Assigned(LMaterialItem) then
        begin
          LPrecesion := LMaterialItem.m_Precision;
        end
        else
        begin
          LPrecesion := 2;
        end;

        LOrderCommand := LRecord.GetIntegerValue('ORDER_COMMAND'); // 1 : 매도, 2 : 매수, 3 : 정정, 4 : 취소
        LOrderVolume := LRecord.GetIntegerValue('ORDER_VOLUME'); // 주문량
        LOrderPrice := LRecord.GetDoubleValue('ORDER_PRICE'); // 주문가격
        LPriceType := LRecord.GetStringValue('PRICETYPE'); // '01' : 지정가, '02' : 시장가

        LOG_WRITE(LOG_TYPE_INFO, 'CFNHDAgentManager', '주문전송; ' + '사용자:' + LRecord.GetStringValue('USERID') + '; ' + '계좌:' + LRecord.GetStringValue('ACCOUNT_NO') + '; ' + '종목:' + LRecord.GetStringValue('SYMBOL') + '; ' + '주문데이터유형:' + IntToStr(LRecord.GetIntegerValue('DATATYPE')) + '; ' + '매매구분:' + LRecord.GetStringValue('ORDER_COMMAND') + '; ' + '주문량:' + IntToStr(LRecord.GetIntegerValue('ORDER_VOLUME')) + '; ' + '주문가:' + TFNGlobal.WriteNumber(LRecord.GetDoubleValue('ORDER_PRICE'), 2) + '; ' + '주문번호:' +
          LRecord.GetStringValue('ORDER_NO') + '; ' + '원주문번호:' + LRecord.GetStringValue('ORG_ORDER_NO') + '; ' + '블록명:' + LRecord.GetStringValue('BLOCK_NAME') + '; ' + '신호순번:' + LRecord.GetStringValue('SIGNAL_SEQ'));

        // '01' : 지정가, '02' : 시장가
        if (LPriceType = '01') then
        begin
          LHDPriceType := '1'; // (1:지정가 2:시장가 3:STOP 4:STOP-LIMIT)
          LHDOrderPrice := WriteDouble(LOrderPrice, 15, LPrecesion)
        end
        else if (LPriceType = '02') then
        begin
          LHDPriceType := '2'; // (1:지정가 2:시장가 3:STOP 4:STOP-LIMIT)
          LHDOrderPrice := ' ';
        end
        else
        begin
          LHDPriceType := '1';
          LHDOrderPrice := WriteDouble(LOrderPrice, 15, LPrecesion)
        end;

        LDataType := LRecord.GetIntegerValue('DATATYPE'); // 1 : 신규, 2 : 정정, 3 : 취소
        LHDBuySell := LRecord.GetStringValue('BUYSELL'); // 1 : BUY, 2 : SELL

        m_AgentLock.Enter;
        try
          LSRValue := '-1';

          LSendStream := TStringStream.Create;
          LIORecord := CFNIORecord.Create;

          if (LOrderCommand = 1) or (LOrderCommand = 2) then
          begin
            LIORecord.SetStringValue('계좌번호', LAccountNo);
            LIORecord.SetStringValue('비밀번호', LPassword);
            LIORecord.SetStringValue('종목코드', LSymbol);
            LIORecord.SetStringValue('매매구분', LHDBuySell);
            LIORecord.SetStringValue('주문유형', LHDPriceType);
            LIORecord.SetStringValue('체결조건', '0');
            LIORecord.SetStringValue('주문가격', LHDOrderPrice);
            LIORecord.SetStringValue('주문수량', WriteInteger(LOrderVolume, 10));
            LIOHandler := Make_AO0401_IN(NIL, LIORecord);
            LIOHandler.EncodeData(LSendStream);
            LIOHandler.Free;

            LSendStream.Position := 0;
            LDataSize := LSendStream.Size;
            LDataString := LSendStream.ReadString(LDataSize);

            LRValue := m_Agent.CommJumunSvr('g12003.AO0401%', LDataString);

          end
          else if (LOrderCommand = 3) then
          begin
            LORG_ORDER_NO := LRecord.GetStringValue('ORG_ORDER_NO');
            LIORecord.SetStringValue('계좌번호', LAccountNo);
            LIORecord.SetStringValue('비밀번호', LPassword);
            LIORecord.SetStringValue('종목코드', LSymbol);
            LIORecord.SetStringValue('주문유형', LHDPriceType);
            LIORecord.SetStringValue('체결조건', '0');
            LIORecord.SetStringValue('주문가격', LHDOrderPrice);
            LIORecord.SetStringValue('주문수량', WriteInteger(LOrderVolume, 10));
            LIORecord.SetStringValue('주문번호', LORG_ORDER_NO);
            LIOHandler := Make_AO0402_IN(NIL, LIORecord);
            LIOHandler.EncodeData(LSendStream);
            LIOHandler.Free;

            LSendStream.Position := 0;
            LDataSize := LSendStream.Size;
            LDataString := LSendStream.ReadString(LDataSize);

            LRValue := m_Agent.CommJumunSvr('g12003.AO0402%', LDataString);
          end
          else if (LOrderCommand = 4) then
          begin
            LORG_ORDER_NO := LRecord.GetStringValue('ORG_ORDER_NO');
            LIORecord.SetStringValue('계좌번호', LAccountNo);
            LIORecord.SetStringValue('비밀번호', LPassword);
            LIORecord.SetStringValue('종목코드', LSymbol);
            LIORecord.SetStringValue('주문유형', LHDPriceType);
            LIORecord.SetStringValue('체결조건', '0');
            LIORecord.SetStringValue('주문가격', LHDOrderPrice);
            LIORecord.SetStringValue('주문수량', WriteInteger(LOrderVolume, 10));
            LIORecord.SetStringValue('주문번호', LORG_ORDER_NO);
            LIOHandler := Make_AO0403_IN(NIL, LIORecord);
            LIOHandler.EncodeData(LSendStream);
            LIOHandler.Free;

            LSendStream.Position := 0;
            LDataSize := LSendStream.Size;
            LDataString := LSendStream.ReadString(LDataSize);

            LRValue := m_Agent.CommJumunSvr('g12003.AO0403%', LDataString);
          end;

          if 0 <= LRValue then
          begin
            LRQID := LRValue;

            p_QueryData.m_RequestID := IntToStr(LRQID);
            p_QueryData.m_DateTime := Now;
            p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
            p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);
            SetRQTable(p_QueryData.m_RequestID, p_QueryData);
            p_QueryData := NIL;
          end
          else
          begin
            MakeDefaultResponse(p_QueryData);
            WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
            StoreRecvData(p_QueryData);
            p_QueryData := NIL;
          end;
          LSendStream.Free;
        finally
          m_AgentLock.Leave;
        end;
      end
      else
      begin
        WriteMessage(p_QueryData, 'M99999', '오류가 발생했습니다.');
        WriteError(p_QueryData, 'M10002');
        StoreRecvData(p_QueryData);
        p_QueryData := NIL;
      end;
    end
    else
    begin
      WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
      WriteError(p_QueryData, 'M10003');
      StoreRecvData(p_QueryData);
      p_QueryData := NIL;
    end;
  finally
    if p_QueryData <> NIL then
      p_QueryData.Free;
  end;
end;

// ---------------------------------------------------------------------------
// 선물시세 조회 패킷을 만들어서 Agent에 전달한다.
procedure CFNHDAgentManager.SC_QUOTE_TR_0210(p_QueryData: CFNQueryData);
var
  LInDataSet: CFNDataSet;
  LInRecord: CFNRecord;
  LSymbol: WideString;
  LIORecord: CFNIORecord;
  LIOHandler: CFNIOHandler;
  LRQID: short;
  LDataString: String;
  LRValue: Integer;
  LFIDString: String;
  LBuffer: Array [0 .. 256] of AnsiChar;
begin
  try
    LInDataSet := p_QueryData.m_Request.GetDataSet(DATASETID_IN_01);
    if Assigned(LInDataSet) then
    begin
      if (0 < LInDataSet.RecordList.Count) then
      begin
        try
          LInRecord := CFNRecord(LInDataSet.RecordList.Items[0]);
          LSymbol := LInRecord.GetStringValue('SYMBOL');

          LDataString := WriteString(LSymbol, 32);

          m_AgentLock.Enter;
          try
            LFIDString := '';
            LFIDString := LFIDString + '000';
            LFIDString := LFIDString + '001';
            LFIDString := LFIDString + '002';
            LFIDString := LFIDString + '003';
            LFIDString := LFIDString + '004';
            LFIDString := LFIDString + '007';
            LFIDString := LFIDString + '008';
            LFIDString := LFIDString + '009';
            LFIDString := LFIDString + '017';
            LFIDString := LFIDString + '022';
            LFIDString := LFIDString + '023';
            LFIDString := LFIDString + '024';
            LFIDString := LFIDString + '028';

            LRValue := m_Agent.CommFIDRqData('o51000', LDataString, LFIDString, Length(LDataString), '');

            if 0 <= LRValue then
            begin
              LRQID := LRValue;
              p_QueryData.m_RequestID := IntToStr(LRQID);
              p_QueryData.m_DateTime := Now;
              p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
              p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);
              SetRQTable(p_QueryData.m_RequestID, p_QueryData);
            end
            else
            begin
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
        end;
        p_QueryData := NIL;
      end
      else
      begin
        WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
        WriteError(p_QueryData, 'M10002');
        StoreRecvData(p_QueryData);
        p_QueryData := NIL;
        // 응답패킷에 에러를 리턴하여 예외처리 해야 됨
      end;
    end
    else
    begin
      WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
      WriteError(p_QueryData, 'M10003');
      StoreRecvData(p_QueryData);
      p_QueryData := NIL;
      // 응답패킷에 에러를 리턴하여 예외처리 해야 됨
    end;
  finally
    if p_QueryData <> NIL then
      p_QueryData.Free;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.SC_ACCOUNT_TR_0010(p_QueryData: CFNQueryData);
var
  F: TextFile;
  S: string;
  Line: String;
  LAccountNo: String;
  LAccountName: String;
  LOutDataSet: CFNDataSet;
  LOutRecord: CFNRecord;
  LSuccess: Boolean;
  LFieldList: TStringList;

  LWSValue: String;
  nRepeatCnt: Integer;
  LIndex: Integer;

  LSCount: String;
  f_DataStream: TStringStream;
  f_IOHandler: CFNIOHandler;
  f_IODataSet: CFNIODataSet;
  f_IORecord: CFNIORecord;
begin

  Make_SC_ACCOUNT_TR_0010_OUT(p_QueryData.m_Response);
  LOutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);

  LSuccess := true;
  try
    LWSValue := m_Agent.CommGetAccInfo();

    f_DataStream := TStringStream.Create;
    f_DataStream.WriteString(LWSValue);
    f_DataStream.WriteString('   ');

    f_IOHandler := Make_ACCOUNT_OUT(NIL);

    f_IOHandler.SetSourceData(f_DataStream);
    f_IOHandler.DecodeData;

    f_IORecord := NIL;
    if f_IOHandler.m_DataSetList.Count > 0 then
    begin
      f_IODataSet := f_IOHandler.m_DataSetList.Items[0] as CFNIODataSet;

      for LIndex := 0 to f_IODataSet.RecordList.Count - 1 do
      begin
        f_IORecord := f_IODataSet.RecordList.Items[LIndex] as CFNIORecord;

        LWSValue := f_IORecord.GetStringValue('ACCOUNT_GB');
        if ('1' = LWSValue) then
        begin
          LOutRecord := CFNRecord.Create;

          LWSValue := f_IORecord.GetStringValue('ACCOUNT_NO');
          LOutRecord.SetStringValue('ACCOUNT_NO', LWSValue);

          LWSValue := f_IORecord.GetStringValue('ACCOUNT_NAME');
          LOutRecord.SetStringValue('ACCOUNT_NAME', LWSValue);

          LOutDataSet.RecordList.Add(LOutRecord);
        end;
      end;

      if (LOutDataSet.RecordList.Count > 0) then
      begin
        LSuccess := true;
      end
      else
      begin
        LSuccess := false;
      end;

    end
    else
    begin
      LSuccess := false;
    end;
    f_IOHandler.Free;
    f_DataStream.Free;

  finally

  end;

  if LSuccess then
  begin
    WriteMessage(p_QueryData, 'M00000', '정상처리 되었습니다.');
  end
  else
  begin
    WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
    WriteError(p_QueryData, 'M20001');
  end;

  StoreRecvData(p_QueryData);
end;

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.MakeDefaultResponse(p_QueryData: CFNQueryData);
var
  LOutDataSet: CFNDataSet;
  LOutRecord: CFNRecord;
  LInDataSet: CFNDataSet;
  LInRecord: CFNRecord;
  LFirstValue: Boolean;
begin
  if not Assigned(p_QueryData) then
    exit;

{$REGION '선물주문'}
  if (p_QueryData.m_ServiceID = 'SC_ORDER') and (p_QueryData.m_TRCode = 'TR_0210') then
  begin
    try
      LOutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
      if not Assigned(LOutDataSet) then
      begin
        Make_SC_ORDER_TR_0210_OUT(p_QueryData.m_Response);
        LOutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
      end;

      if LOutDataSet.RecordList.Count <= 0 then
      begin
        LOutRecord := CFNRecord.Create;
        LOutDataSet.RecordList.Add(LOutRecord);
        LFirstValue := true;
      end
      else
      begin
        LFirstValue := false;
      end;

      LOutRecord := LOutDataSet.RecordList.Items[0] as CFNRecord;

{$REGION '입력된 값을 이용하여 응답내용을 설정한다'}
      LInDataSet := p_QueryData.m_Request.GetDataSet(DATASETID_IN_01);
      if Assigned(LInDataSet) then
      begin
        if LInDataSet.RecordList.Count > 0 then
        begin
          LInRecord := CFNRecord(LInDataSet.RecordList.Items[0]);
        end
        else
        begin
          LInRecord := NIL;
        end;
      end
      else
      begin
        LInRecord := NIL;
      end;

      if Assigned(LOutRecord) then
      begin
        if LInRecord <> NIL then
        begin
          LOutRecord.SetIntegerValue('COLLECTION_TYPE', LInRecord.GetIntegerValue('COLLECTION_TYPE'));
          LOutRecord.SetStringValue('BLOCK_NAME', LInRecord.GetStringValue('BLOCK_NAME'));
          LOutRecord.SetStringValue('BLOCK_KEY', LInRecord.GetStringValue('BLOCK_KEY'));
          LOutRecord.SetIntegerValue('SIGNAL_SEQ', LInRecord.GetIntegerValue('SIGNAL_SEQ'));
          LOutRecord.SetIntegerValue('ORDER_SEQ', LInRecord.GetIntegerValue('ORDER_SEQ'));
          LOutRecord.SetStringValue('USERID', LInRecord.GetStringValue('USERID'));

          LOutRecord.SetStringValue('ACCOUNT_NO', LInRecord.GetStringValue('ACCOUNT_NO'));
          LOutRecord.SetStringValue('SYMBOL', LInRecord.GetStringValue('SYMBOL'));

          LOutRecord.SetIntegerValue('DATATYPE', LInRecord.GetIntegerValue('DATATYPE'));
          LOutRecord.SetIntegerValue('BUYSELL', LInRecord.GetIntegerValue('BUYSELL'));

          LOutRecord.SetIntegerValue('ORDER_COMMAND', LInRecord.GetIntegerValue('ORDER_COMMAND'));
          LOutRecord.SetIntegerValue('ORDER_VOLUME', LInRecord.GetIntegerValue('ORDER_VOLUME'));

          LOutRecord.SetDoubleValue('ORDER_PRICE', LInRecord.GetDoubleValue('ORDER_PRICE'));
          LOutRecord.SetStringValue('PRICETYPE', LInRecord.GetStringValue('PRICETYPE'));

          LOutRecord.SetIntegerValue('CONDITION', LInRecord.GetIntegerValue('CONDITION'));
          LOutRecord.SetStringValue('ORG_ORDER_NO', LInRecord.GetStringValue('ORG_ORDER_NO'));

          if LFirstValue then
          begin
            LOutRecord.SetStringValue('ORDER_NO', '');
          end;
        end;
      end;
{$ENDREGION}
    except
    end;
  end
  else
{$ENDREGION}
{$REGION '시세조회'}
    if (p_QueryData.m_ServiceID = 'SC_QUOTE') and (p_QueryData.m_TRCode = 'TR_0210') then
    begin
      try
        LOutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
        if not Assigned(LOutDataSet) then
        begin
          Make_SC_QUOTE_TR_0210_OUT(p_QueryData.m_Response);
          LOutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
        end;

        if LOutDataSet.RecordList.Count <= 0 then
        begin
          LOutRecord := CFNRecord.Create;
          LOutDataSet.RecordList.Add(LOutRecord);
          LFirstValue := true;
        end
        else
        begin
          LFirstValue := false;
        end;

        LOutRecord := LOutDataSet.RecordList.Items[0] as CFNRecord;

{$REGION '입력된 값을 이용하여 응답내용을 설정한다'}
        LInDataSet := p_QueryData.m_Request.GetDataSet(DATASETID_IN_01);
        if Assigned(LInDataSet) then
        begin
          if LInDataSet.RecordList.Count > 0 then
          begin
            LInRecord := CFNRecord(LInDataSet.RecordList.Items[0]);
          end
          else
          begin
            LInRecord := NIL;
          end;
        end
        else
        begin
          LInRecord := NIL;
        end;

        if Assigned(LOutRecord) then
        begin
          if LInRecord <> NIL then
          begin
            if LFirstValue then
            begin
              LOutRecord.SetIntegerValue('COUNTRY_NO', LInRecord.GetIntegerValue('COUNTRY_NO'));
              LOutRecord.SetIntegerValue('GROUP_NO', LInRecord.GetIntegerValue('GROUP_NO'));
              LOutRecord.SetIntegerValue('MARKET_NO', LInRecord.GetIntegerValue('MARKET_NO'));
              LOutRecord.SetStringValue('SYMBOL', LInRecord.GetStringValue('SYMBOL'));
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

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.OnTimeout(p_QueryData: CFNQueryData);
var
  LQueryData: CFNQueryData;
  LOutDataSet: CFNDataSet;
  LOutRecord: CFNRecord;
begin
  LQueryData := p_QueryData;

  try
    MakeDefaultResponse(LQueryData);
    WriteMessage(LQueryData, 'M90001', '응답시간이 초과되었습니다.');
    if LQueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
    begin
      WriteMessage(LQueryData, 'M99999', '비정상 처리되었습니다.');
    end
    else
    begin
      WriteMessage(LQueryData, 'M00000', '정상처리 되었습니다.');
    end;
    StoreRecvData(LQueryData);
  except
    on E: Exception do
    begin
      WriteMessage(LQueryData, 'M99999', '비정상 처리되었습니다.');
      LQueryData.m_Response.SetErrorCode('M30001');
      LOutRecord := CFNRecord.Create;
      LOutRecord.SetStringValue('ERROR_CODE', 'M30001');
      LOutRecord.SetStringValue('MESSAGE', E.Message);
      LQueryData.m_Response.m_ErrorDataSet.RecordList.Add(LOutRecord);
      StoreRecvData(LQueryData);
    end;
  end;
end;
{$ENDREGION}
{$REGION '소켓의 접속이상'}

procedure CFNHDAgentManager.DoCheckSocketStatus;
var
  LResult: Integer;
begin
  LResult := m_Agent.CommGetConnectState;
  if (LResult <> 1) then
  begin
    if Assigned(m_DisconnectEvent) then
    begin
      LOG_WRITE(LOG_TYPE_ERROR, 'CFNHDAgentManager', '통신이 종료되었습니다.');
      m_DisconnectEvent(Self);
    end;
  end;
end;
{$ENDREGION}
{$REGION '조회 작업의 응답'}

// ------------------------------------------------------------------------------------------------------------------------------------------------------
procedure CFNHDAgentManager.OnDataRecv(ASender: TObject; const sTrCode: WideString; nRqId: Integer);
var
  LQueryData: CFNQueryData;
  LOutDataSet: CFNDataSet;
  LOutRecord: CFNRecord;
  LInDataSet: CFNDataSet;
  LInRecord: CFNRecord;
  LOrderNo: String;
  LMessageCode, LMessageText: String;

  LChange: Double;
  LSign: Integer;
  LCountry: Integer;
  LGroup: Integer;
  LMarket: Integer;

  LSValue: String;
  LNValue: Integer;
  LDValue: Double;

  LSymbol: String;
  LDateTime, LTimeDiffrence: Double;
  LMaterialItem: CFNMaterialItem;
  LFactor: Double;
  LPrecision: Integer;

  LWSValue: String;

  LSCount: String;
  f_DataStream: TStringStream;
  f_IOHandler: CFNIOHandler;
  f_IODataSet: CFNIODataSet;
  f_IORecord: CFNIORecord;
begin

  LQueryData := GetRQTable(IntToStr(nRqId));
  if not Assigned(LQueryData) then
    exit;

{$REGION '시세조회'}
  if (LQueryData.m_ServiceID = 'SC_QUOTE') and (LQueryData.m_TRCode = 'TR_0210') then
  begin
    try
      MakeDefaultResponse(LQueryData);
      LOutDataSet := LQueryData.m_Response.GetDataSet(DATASETID_OUT_01);

      LInDataSet := LQueryData.m_Request.GetDataSet(DATASETID_IN_01);
      if Assigned(LInDataSet) then
      begin
        if LInDataSet.RecordList.Count > 0 then
        begin
          LInRecord := CFNRecord(LInDataSet.RecordList.Items[0]);
        end
        else
        begin
          LInRecord := NIL;
        end;
      end
      else
      begin
        LInRecord := NIL;
      end;

      LOutRecord := LOutDataSet.RecordList.Items[0] as CFNRecord;
      try
        LSymbol := ReadString(m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '종목코드'));

        LOutRecord.SetIntegerValue('COUNTRY_NO', LInRecord.GetIntegerValue('COUNTRY_NO'));
        LOutRecord.SetIntegerValue('GROUP_NO', LInRecord.GetIntegerValue('GROUP_NO'));
        LOutRecord.SetIntegerValue('MARKET_NO', LInRecord.GetIntegerValue('MARKET_NO'));

        LWSValue := ReadString(m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '종목코드'));
        LOutRecord.SetStringValue('SYMBOL', LWSValue);

        LWSValue := ReadString(m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '한글종목명'));
        LOutRecord.SetStringValue('NAME', LWSValue);

        LFactor := 1;
        LTimeDiffrence := 0;
        LPrecision := 0;
        if Assigned(g_MaterialCollection) then
        begin
          LMaterialItem := g_MaterialCollection.Find(LOutRecord.GetIntegerValue('COUNTRY_NO'), LOutRecord.GetIntegerValue('GROUP_NO'), LOutRecord.GetIntegerValue('MARKET_NO'), g_SymbolCollection.GetOPSSymbol(LSymbol));

          if Assigned(LMaterialItem) then
          begin
            LTimeDiffrence := LMaterialItem.m_TimeDiffrence;
            LFactor := Power(10, LMaterialItem.m_Precision);
            LPrecision := LMaterialItem.m_Precision;
          end;
        end;

        LDateTime := TFNGlobal.ServerNow + LTimeDiffrence;
        LOutRecord.SetStringValue('DATE', TFNGlobal.DateToString_YYYYMMDD(LDateTime));
        LOutRecord.SetStringValue('TIME', TFNGlobal.TimeToString_HHMMSS(LDateTime));

        LDValue := ReadDouble(m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '현재가'), LPrecision);
        LOutRecord.SetDoubleValue('CLOSE_PRICE', LDValue);

        LWSValue := ReadString(m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '전일대비구분'));
        if LWSValue = '-' then
        begin
          LSign := -1
        end
        else
        begin
          LSign := 1
        end;

        LDValue := ReadDouble(m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '전일대비'), LPrecision);
        LOutRecord.SetDoubleValue('CHANGE', LDValue);

        LDValue := ReadDouble(m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '시가'), LPrecision);
        LOutRecord.SetDoubleValue('OPEN_PRICE', LDValue);

        LDValue := ReadDouble(m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '고가'), LPrecision);
        LOutRecord.SetDoubleValue('HIGH_PRICE', LDValue);

        LDValue := ReadDouble(m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '저가'), LPrecision);
        LOutRecord.SetDoubleValue('LOW_PRICE', LDValue);

        LDValue := ReadDouble(m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '누적거래량'), LPrecision);
        LOutRecord.SetDoubleValue('TOTAL_VOLUME', LDValue);

        LDValue := ReadDouble(m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '매도호가'), LPrecision);
        LOutRecord.SetDoubleValue('BEST_OFFER_PRICE', LDValue);

        LDValue := ReadDouble(m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '매수호가'), LPrecision);
        LOutRecord.SetDoubleValue('BEST_BID_PRICE', LDValue);

        LOutRecord.SetDoubleValue('PREV_CLOSE', LOutRecord.GetDoubleValue('CLOSE_PRICE') - LOutRecord.GetDoubleValue('CHANGE'));

      finally
      end;
      WriteMessage(LQueryData, 'M00000', '정상처리 되었습니다.');
      ClearRQTable(IntToStr(nRqId));
      StoreRecvData(LQueryData);

    except
      on E: Exception do
      begin
        WriteMessage(LQueryData, 'M99999', '비정상 처리되었습니다.');
        LQueryData.m_Response.SetErrorCode('M30001');
        LOutRecord := CFNRecord.Create;
        LOutRecord.SetStringValue('ERROR_CODE', 'M30001');
        LOutRecord.SetStringValue('MESSAGE', E.Message);
        LQueryData.m_Response.m_ErrorDataSet.RecordList.Add(LOutRecord);
        ClearRQTable(IntToStr(nRqId));
        StoreRecvData(LQueryData);
      end;
    end;
  end
  else
{$ENDREGION}
{$REGION '선물주문'}
    if (LQueryData.m_ServiceID = 'SC_ORDER') and (LQueryData.m_TRCode = 'TR_0210') then
    begin
      try
        MakeDefaultResponse(LQueryData);
        LOutDataSet := LQueryData.m_Response.GetDataSet(DATASETID_OUT_01);
        LOutRecord := LOutDataSet.RecordList.Items[0] as CFNRecord;

        try
{$REGION '주문번호를 추출한다'}
          LOrderNo := m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '주문번호');

          LMessageCode := m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '처리코드');
          LMessageText := m_Agent.CommGetData(sTrCode, -1, 'OutRec1', 0, '처리메시지');

          LOutRecord.SetStringValue('ORDER_NO', LOrderNo);
          LOutRecord.SetStringValue('MESSAGE_CODE', LMessageCode);
          LOutRecord.SetStringValue('MESSAGE_TEXT', LMessageText);

          if LMessageCode = '00000' then
            LMessageCode := 'M00000';
          if LMessageCode = '75001' then
            LMessageCode := 'M00000';

          if (Pos('오류', LMessageText) > 0) OR (Pos('실패', LMessageText) > 0) OR (Pos('잠시후에 사용하', LMessageText) > 0) then
          begin
            if LMessageCode = 'M00000' then
              LMessageCode := 'E10000';
          end;

          WriteMessage(LQueryData, LMessageCode, LMessageText);

          if LQueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
          begin
            WriteMessage(LQueryData, 'M99999', '비정상 처리되었습니다.');
          end
          else
          begin
            if LQueryData.m_Response.GetMsgCode = '' then
            begin
              WriteMessage(LQueryData, 'M00000', '정상처리 되었습니다.');
            end;
          end;
          if LOrderNo <> '' then
          begin
            LOG_WRITE(LOG_TYPE_INFO, 'CFNHDAgentManager', '주문응답; ' + '사용자:' + LOutRecord.GetStringValue('USERID') + '; ' + '계좌:' + LOutRecord.GetStringValue('ACCOUNT_NO') + '; ' + '종목:' + LOutRecord.GetStringValue('SYMBOL') + '; ' + '주문데이터유형:' + IntToStr(LOutRecord.GetIntegerValue('DATATYPE')) + '; ' + '매매구분:' + LOutRecord.GetStringValue('ORDER_COMMAND') + '; ' + '주문량:' + IntToStr(LOutRecord.GetIntegerValue('ORDER_VOLUME')) + '; ' + '주문가:' + TFNGlobal.WriteNumber(LOutRecord.GetDoubleValue('ORDER_PRICE'), 2)
              + '; ' + '주문번호:' + LOutRecord.GetStringValue('ORDER_NO') + '; ' + '원주문번호:' + LOutRecord.GetStringValue('ORG_ORDER_NO') + '; ' + '블록명:' + LOutRecord.GetStringValue('BLOCK_NAME') + '; ' + '신호순번:' + LOutRecord.GetStringValue('SIGNAL_SEQ'));
          end
          else
          begin
            LOG_WRITE(LOG_TYPE_ERROR, 'CFNHDAgentManager', '주문응답오류; ' + '사용자:' + LOutRecord.GetStringValue('USERID') + '; ' + '계좌:' + LOutRecord.GetStringValue('ACCOUNT_NO') + '; ' + '종목:' + LOutRecord.GetStringValue('SYMBOL') + '; ' + '주문데이터유형:' + IntToStr(LOutRecord.GetIntegerValue('DATATYPE')) + '; ' + '매매구분:' + LOutRecord.GetStringValue('ORDER_COMMAND') + '; ' + '주문량:' + IntToStr(LOutRecord.GetIntegerValue('ORDER_VOLUME')) + '; ' + '주문가:' + TFNGlobal.WriteNumber(LOutRecord.GetDoubleValue('ORDER_PRICE'),
              2) + '; ' + '주문번호:' + LOutRecord.GetStringValue('ORDER_NO') + '; ' + '원주문번호:' + LOutRecord.GetStringValue('ORG_ORDER_NO') + '; ' + '블록명:' + LOutRecord.GetStringValue('BLOCK_NAME') + '; ' + '신호순번:' + LOutRecord.GetStringValue('SIGNAL_SEQ'));
          end;

{$ENDREGION}
        finally
        end;

        ClearRQTable(IntToStr(nRqId));
        StoreRecvData(LQueryData);
      except
        on E: Exception do
        begin
          WriteMessage(LQueryData, 'M99999', '비정상 처리되었습니다.');
          LQueryData.m_Response.SetErrorCode('M30001');
          LOutRecord := CFNRecord.Create;
          LOutRecord.SetStringValue('ERROR_CODE', 'M30001');
          LOutRecord.SetStringValue('MESSAGE', E.Message);
          LQueryData.m_Response.m_ErrorDataSet.RecordList.Add(LOutRecord);
          ClearRQTable(IntToStr(nRqId));
          StoreRecvData(LQueryData);
        end;
      end;
    end;
{$ENDREGION}
end;

// ------------------------------------------------------------------------------------------------------------------------------------------------------
procedure CFNHDAgentManager.OnGetMsgWithRqId(ASender: TObject; nRqId: Integer; const sCode: WideString; const sMsg: WideString);
var
  LQueryData: CFNQueryData;

  LMessageCode: String;
  LMessageText: String;
begin
  LQueryData := GetRQTable(IntToStr(nRqId));
  if not Assigned(LQueryData) then
    exit;

  MakeDefaultResponse(LQueryData);

  LMessageCode := sCode;
  LMessageText := sMsg;

  if LMessageCode = '00000' then
    LMessageCode := 'M00000';

  if (Pos('오류', LMessageText) > 0) OR (Pos('실패', LMessageText) > 0) OR (Pos('잠시후에 사용하', LMessageText) > 0) then
  begin
    if LMessageCode = 'M00000' then
      LMessageCode := 'E10000';
  end;

  WriteMessage(LQueryData, LMessageCode, LMessageText);

  if LQueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
  begin
    WriteMessage(LQueryData, 'M99999', '비정상 처리되었습니다.');
  end
  else
  begin
    if LQueryData.m_Response.GetMsgCode = '' then
    begin
      WriteMessage(LQueryData, 'M00000', '정상처리 되었습니다.');
    end;
  end;
end;
{$ENDREGION}
{$REGION '실시간 데이터 수신'}

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.OnGetBroadData(ASender: TObject; const sJongmokCode: WideString; nRealType: Integer);
begin

  if (84 = nRealType) then
  begin
    OnQuoteData(ASender, sJongmokCode, nRealType);
  end
  else

    if (196 = nRealType) or (189 = nRealType) then
  begin
    OnTradeData(ASender, sJongmokCode, nRealType);
  end;
end;

{$REGION '실시간 시세 수신'}

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.OnQuoteData(ASender: TObject; const sKey: WideString; nRealType: Integer);
var
  LStreamRecord1: CFNStreamRecord;

  LSubscribeKey: String;
  LObjectList: TObjectList;

  LLoop: Integer;
  LDataDelivery: CFNDataDelivery;

  LSign: Integer;
  LChange: Double;

  LSValue: String;
  LNValue: Integer;
  LDValue: Double;
  LDateTime, LTimeDiffrence: Double;
  LMaterialItem: CFNMaterialItem;
  LFactor: Double;

  LSymbol: String;
  LCountry, LGroup, LMarket: Integer;
  LSignString: String;
  LPrecision : Integer;
  LShortSymbol:String;
begin
  try
    LSubscribeKey := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '종목코드'));

    LShortSymbol := Copy(LSubscribeKey, 1, 2);

    if LShortSymbol = 'ES' then
    begin
        LPrecision := 2;
        LFactor := Power(10, LPrecision);
    end else
    if LShortSymbol = 'NQ' then
    begin
        LPrecision := 2;
        LFactor := Power(10, LPrecision);
    end else
    if LShortSymbol = '6E' then
    begin
        LPrecision := 4;
        LFactor := Power(10, LPrecision);
    end else
    if LShortSymbol = 'CL' then
    begin
        LPrecision := 2;
        LFactor := Power(10, LPrecision);
    end else
    if LShortSymbol = 'GC' then
    begin
        LPrecision := 1;
        LFactor := Power(10, LPrecision);
    end else
    begin
        exit;
    end;

    m_STSubscribeTableLock.Enter;
    try
      LObjectList := m_STSubscribeTable[MAP_CURRENT].GetKey(LSubscribeKey);
    finally
      m_STSubscribeTableLock.Leave;
    end;

    if Assigned(LObjectList) then
    begin
      LStreamRecord1 := CFNStreamRecord.Create;
      LStreamRecord1.SetPacketKey('QUOTE');

      LSymbol := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '종목코드'));
      GetGategory(LSymbol, LCountry, LGroup, LMarket);

      LStreamRecord1.SetIntegerValue('COUNTRY_NO', LCountry);
      LStreamRecord1.SetIntegerValue('GROUP_NO', LGroup);
      LStreamRecord1.SetIntegerValue('MARKET_NO', LMarket);

      LTimeDiffrence := 0;
      if Assigned(m_MaterialItem) and (m_MaterialItem.m_Country = LCountry) and (m_MaterialItem.m_Group = LGroup) and (m_MaterialItem.m_Market = LMarket) and (m_MaterialItem.m_Key = g_SymbolCollection.GetOPSSymbol(LSymbol)) then
      begin
        LTimeDiffrence := m_MaterialItem.m_TimeDiffrence;
      end
      else
      begin
        if Assigned(g_MaterialCollection) then
        begin
          m_MaterialItem := g_MaterialCollection.Find(LCountry, LGroup, LMarket, g_SymbolCollection.GetOPSSymbol(LSymbol));

          if Assigned(m_MaterialItem) then
          begin
            LTimeDiffrence := m_MaterialItem.m_TimeDiffrence;
          end;
        end;
      end;

      LStreamRecord1.SetStringValue('SYMBOL', LSymbol);

      LDateTime := TFNGlobal.ServerNow + LTimeDiffrence;
      LStreamRecord1.SetStringValue('DATE', TFNGlobal.DateToString_YYYYMMDD(LDateTime));
      LStreamRecord1.SetStringValue('TIME', TFNGlobal.TimeToString_HHMMSS(LDateTime));

      LSignString := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '전일대비구분'));
      LStreamRecord1.SetStringValue('SIGN', LSignString);

      if LSignString = '-' then
      begin
        LSign := -1;
      end
      else
      begin
        LSign := 1;
      end;

      LChange := LSign * ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '전일대비'), LPrecision);

      LDValue := ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '체결가'), LPrecision);
      LStreamRecord1.SetDoubleValue('PREV_CLOSE', LDValue - LChange, LPrecision);

      LDValue := ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '체결가'), LPrecision);
      LStreamRecord1.SetDoubleValue('CLOSE_PRICE', LDValue, LPrecision);

      LStreamRecord1.SetDoubleValue('CHANGE', LChange, LPrecision);

      LDValue := ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '전일대비등락율'), 0);
      LStreamRecord1.SetDoubleValue('CHANGERATE', LDValue, 2);

      LDValue := ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '매도호가'), LPrecision);
      LStreamRecord1.SetDoubleValue('BEST_OFFER_PRICE', LDValue, LPrecision);

      LDValue := ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '매수호가'), LPrecision);
      LStreamRecord1.SetDoubleValue('BEST_BID_PRICE', LDValue, LPrecision);

      LDValue := ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '시가'), LPrecision);
      LStreamRecord1.SetDoubleValue('OPEN_PRICE', LDValue, LPrecision);

      LDValue := ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '고가'), LPrecision);
      LStreamRecord1.SetDoubleValue('HIGH_PRICE', LDValue, LPrecision);

      LDValue := ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '저가'), LPrecision);
      LStreamRecord1.SetDoubleValue('LOW_PRICE', LDValue, LPrecision);

      LDValue := ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '누적거래량'), 0);
      LStreamRecord1.SetDoubleValue('TOTAL_VOLUME', LDValue, 0);

      LDValue := ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '누적거래대금'), 0);
      LStreamRecord1.SetDoubleValue('TOTAL_VALUE', LDValue, 0);
      LStreamRecord1.SetDoubleValue('OPEN_VOLUME', 0, 0);

      try
        for LLoop := 0 to LObjectList.Count - 1 do
        begin
          LDataDelivery := CFNDataDelivery(LObjectList.Items[LLoop]);
          if Assigned(LDataDelivery) then
          begin
            LStreamRecord1.IncreaseReferenceCount;
            try
              LDataDelivery.DeliveryStream(LStreamRecord1);
            except
              LStreamRecord1.DecreaseReferenceCount;
            end;
          end;
        end;
      except
      end;

      SaveStreamRecord(LStreamRecord1);

      LObjectList.Clear;
      LObjectList.Free;
      LObjectList := NIL;
    end;
  except
  end;
end;
{$ENDREGION}
{$REGION '실시간 주문 및 체결 통보 수신'}

// --------------------------------------------------------------------------------------------------------------------
procedure CFNHDAgentManager.OnTradeData(ASender: TObject; const sKey: WideString; nRealType: Integer);
var
  LStreamRecord1: CFNStreamRecord;
  LStreamRecord2: CFNStreamRecord;
  LSendStreamRecord: CFNStreamRecord;
  LRecord: CIORecord;

  LSubscribeKey: String;
  LObjectList: TObjectList;

  LLoop: Integer;
  LDataDelivery: CFNDataDelivery;

  LDATADIV, LORDDIV: String;
  LNValue: Integer;
  LDValue: Double;
  LSValue: String;
  LSymbol: String;
  LMaterialItem: CFNMaterialItem;
  LFactor: Double;
  LPrecision: Integer;

  LCountry, LGroup, LMarket: Integer;
begin
  LStreamRecord1 := NIL;
  LStreamRecord2 := NIL;

  if (196 = nRealType) then
  begin
    LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '처리구분'));
    if ('0' = LSValue) then
    begin
      LStreamRecord1 := CFNStreamRecord.Create;
      LStreamRecord1.SetPacketKey('ORDER_RECEIVE');

      LSValue := g_SecUserID;
      LStreamRecord1.SetStringValue('USERID', LSValue);

      LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '계좌번호'));
      LStreamRecord1.SetStringValue('ACCOUNT_NO', LSValue);

      LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '종목코드'));
      LStreamRecord1.SetStringValue('SYMBOL', LSValue);

      LMaterialItem := GetMaterialData(LSValue, LCountry, LGroup, LMarket);
      if Assigned(LMaterialItem) then
      begin
        LFactor := Power(10, LMaterialItem.m_Precision);
        LPrecision := LMaterialItem.m_Precision;
      end
      else
      begin
        LFactor := 1;
        LPrecision := 0;
      end;

      LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문구분'));

      if ('1' = LSValue) then
        LStreamRecord1.SetIntegerValue('ORDER_DATATYPE', ODT_NEW)
      else if ('2' = LSValue) then
        LStreamRecord1.SetIntegerValue('ORDER_DATATYPE', ODT_AMENDED)
      else if ('3' = LSValue) then
        LStreamRecord1.SetIntegerValue('ORDER_DATATYPE', ODT_CANCEL);

      LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '매매구분'));

      if (LSValue = '1') then
        LNValue := 2 // 매수
      else if (LSValue = '2') then
        LNValue := 1 // 매도
      else
        LNValue := 0;

      LStreamRecord1.SetIntegerValue('ORDER_COMMAND', LNValue);

      LStreamRecord1.SetIntegerValue('ORDER_VOLUME', ReadInteger(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문수량')));

      LStreamRecord1.SetDoubleValue('ORDER_PRICE', ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문가격'), LPrecision));

      LStreamRecord1.SetStringValue('ORDER_NO', ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문번호')));

      LStreamRecord1.SetStringValue('ORG_ORDER_NO', '');
      // 거부사유코드
      LStreamRecord1.SetStringValue('ASPR_RJCT_RSCD', ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, 'errcd')));

      LStreamRecord1.SetIntegerValue('ACCEPT', 0);
      LStreamRecord1.SetDoubleValue('RECEIVE_TIME', Now);

      LOG_WRITE(LOG_TYPE_INFO, 'CFNHDAgentManager', '신규주문접수; ' + '사용자:' + LStreamRecord1.GetStringValue('USERID') + '; ' + '계좌:' + LStreamRecord1.GetStringValue('ACCOUNT_NO') + '; ' + '종목:' + LStreamRecord1.GetStringValue('SYMBOL') + '; ' + '주문데이터유형:' + IntToStr(LStreamRecord1.GetIntegerValue('ORDER_DATATYPE')) + '; ' + '매매구분:' + IntToStr(LStreamRecord1.GetIntegerValue('ORDER_COMMAND')) + '; ' + '주문량:' + IntToStr(LStreamRecord1.GetIntegerValue('ORDER_VOLUME')) + '; ' + '주문가:' +
        TFNGlobal.WriteNumber(LStreamRecord1.GetDoubleValue('ORDER_PRICE'), LPrecision) + '; ' + '주문번호:' + LStreamRecord1.GetStringValue('ORDER_NO') + '; ' + '원주문번호:' + LStreamRecord1.GetStringValue('ORG_ORDER_NO') + '; ');

      LStreamRecord2 := CFNStreamRecord.Create;
      LStreamRecord2.SetPacketKey('ORDER_CONFIRM');

      LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, 'uid'));
      LStreamRecord2.SetStringValue('USERID', LSValue);

      LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '계좌번호'));
      LStreamRecord2.SetStringValue('ACCOUNT_NO', LSValue);

      LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '종목코드'));
      LStreamRecord2.SetStringValue('SYMBOL', LSValue);

      LMaterialItem := GetMaterialData(LSValue, LCountry, LGroup, LMarket);
      if Assigned(LMaterialItem) then
      begin
        LFactor := Power(10, LMaterialItem.m_Precision);
        LPrecision := LMaterialItem.m_Precision;
      end
      else
      begin
        LFactor := 1;
        LPrecision := 0;
      end;

      LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문구분'));

      if ('1' = LSValue) then
        LStreamRecord2.SetIntegerValue('ORDER_DATATYPE', ODT_NEW)
      else if ('2' = LSValue) then
        LStreamRecord2.SetIntegerValue('ORDER_DATATYPE', ODT_AMENDED)
      else if ('3' = LSValue) then
        LStreamRecord2.SetIntegerValue('ORDER_DATATYPE', ODT_CANCEL);

      LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '매매구분'));

      if (LSValue = '1') then
        LNValue := 2 // 매수
      else if (LSValue = '2') then
        LNValue := 1 // 매도
      else
        LNValue := 0;

      LStreamRecord2.SetIntegerValue('ORDER_COMMAND', LNValue);

      LStreamRecord2.SetIntegerValue('ORDER_VOLUME', ReadInteger(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문수량')));

      LStreamRecord2.SetDoubleValue('ORDER_PRICE', ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문가격'), LPrecision));

      LStreamRecord2.SetStringValue('ORDER_NO', ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문번호')));

      LStreamRecord2.SetStringValue('ORG_ORDER_NO', '');
      // 거부사유코드
      LStreamRecord2.SetStringValue('ASPR_RJCT_RSCD', ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, 'errcd')));

      LStreamRecord2.SetIntegerValue('ACCEPT', 0);
      LStreamRecord2.SetDoubleValue('RECEIVE_TIME', Now);

      LOG_WRITE(LOG_TYPE_INFO, 'CFNHDAgentManager', '신규주문확인; ' + '사용자:' + LStreamRecord2.GetStringValue('USERID') + '; ' + '계좌:' + LStreamRecord2.GetStringValue('ACCOUNT_NO') + '; ' + '종목:' + LStreamRecord2.GetStringValue('SYMBOL') + '; ' + '주문데이터유형:' + IntToStr(LStreamRecord2.GetIntegerValue('ORDER_DATATYPE')) + '; ' + '매매구분:' + IntToStr(LStreamRecord2.GetIntegerValue('ORDER_COMMAND')) + '; ' + '주문량:' + IntToStr(LStreamRecord2.GetIntegerValue('ORDER_VOLUME')) + '; ' + '주문가:' +
        TFNGlobal.WriteNumber(LStreamRecord2.GetDoubleValue('ORDER_PRICE'), 2) + '; ' + '주문번호:' + LStreamRecord2.GetStringValue('ORDER_NO') + '; ' + '원주문번호:' + LStreamRecord2.GetStringValue('ORG_ORDER_NO') + '; ');
    end
    else
    begin

      LStreamRecord1 := CFNStreamRecord.Create;
      LStreamRecord1.SetPacketKey('ORDER_REJECT');

      LSValue := g_SecUserID;
      LStreamRecord1.SetStringValue('USERID', LSValue);

      LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '계좌번호'));
      LStreamRecord1.SetStringValue('ACCOUNT_NO', LSValue);

      LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '종목코드'));
      LStreamRecord1.SetStringValue('SYMBOL', LSValue);

      LMaterialItem := GetMaterialData(LSValue, LCountry, LGroup, LMarket);
      if Assigned(LMaterialItem) then
      begin
        LFactor := Power(10, LMaterialItem.m_Precision);
        LPrecision := LMaterialItem.m_Precision;
      end
      else
      begin
        LFactor := 1;
        LPrecision := 0;
      end;

      LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문구분'));

      if ('1' = LSValue) then
        LStreamRecord1.SetIntegerValue('ORDER_DATATYPE', ODT_NEW)
      else if ('2' = LSValue) then
        LStreamRecord1.SetIntegerValue('ORDER_DATATYPE', ODT_AMENDED)
      else if ('3' = LSValue) then
        LStreamRecord1.SetIntegerValue('ORDER_DATATYPE', ODT_CANCEL);

      LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '매매구분'));

      if (LSValue = '1') then
        LNValue := 2 // 매수
      else if (LSValue = '2') then
        LNValue := 1 // 매도
      else
        LNValue := 0;

      LStreamRecord1.SetIntegerValue('ORDER_COMMAND', LNValue);

      LStreamRecord1.SetIntegerValue('ORDER_VOLUME', ReadInteger(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문수량')));

      LStreamRecord1.SetDoubleValue('ORDER_PRICE', ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문가격'), LPrecision));

      LStreamRecord1.SetStringValue('ORDER_NO', ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문번호')));

      LStreamRecord1.SetStringValue('ORG_ORDER_NO', '');
      // 거부사유코드
      LStreamRecord1.SetStringValue('ASPR_RJCT_RSCD', ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, 'errcd')));

      LStreamRecord1.SetIntegerValue('ACCEPT', 0);
      LStreamRecord1.SetDoubleValue('RECEIVE_TIME', Now);

      LOG_WRITE(LOG_TYPE_ERROR, 'CFNHDAgentManager', '주문거부; ' + '사용자:' + LStreamRecord1.GetStringValue('USERID') + '; ' + '계좌:' + LStreamRecord1.GetStringValue('ACCOUNT_NO') + '; ' + '종목:' + LStreamRecord1.GetStringValue('SYMBOL') + '; ' + '주문데이터유형:' + IntToStr(LStreamRecord1.GetIntegerValue('ORDER_DATATYPE')) + '; ' + '매매구분:' + IntToStr(LStreamRecord1.GetIntegerValue('ORDER_COMMAND')) + '; ' + '주문량:' + IntToStr(LStreamRecord1.GetIntegerValue('ORDER_VOLUME')) + '; ' + '주문가:' +
        TFNGlobal.WriteNumber(LStreamRecord1.GetDoubleValue('ORDER_PRICE'), 2) + '; ' + '주문번호:' + LStreamRecord1.GetStringValue('ORDER_NO') + '; ' + '원주문번호:' + LStreamRecord1.GetStringValue('ORG_ORDER_NO') + '; ' + '거부사유:' + LStreamRecord1.GetStringValue('ASPR_RJCT_RSCD') + '; ');
    end;

  end
  else if (189 = nRealType) then
  begin

    LStreamRecord1 := CFNStreamRecord.Create;
    LStreamRecord1.SetPacketKey('ORDER_TRADE');

    LSValue := g_SecUserID;
    LStreamRecord1.SetStringValue('USERID', LSValue);

    LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '계좌번호'));
    LStreamRecord1.SetStringValue('ACCOUNT_NO', LSValue);

    LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '종목'));
    LStreamRecord1.SetStringValue('SYMBOL', LSValue);

    LMaterialItem := GetMaterialData(LSValue, LCountry, LGroup, LMarket);
    if Assigned(LMaterialItem) then
    begin
      LFactor := Power(10, LMaterialItem.m_Precision);
      LPrecision := LMaterialItem.m_Precision;
    end
    else
    begin
      LFactor := 1;
      LPrecision := 0;
    end;

    LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문유형'));

    if ('1' = LSValue) then
      LStreamRecord1.SetIntegerValue('ORDER_DATATYPE', ODT_NEW)
    else if ('2' = LSValue) then
      LStreamRecord1.SetIntegerValue('ORDER_DATATYPE', ODT_AMENDED)
    else if ('3' = LSValue) then
      LStreamRecord1.SetIntegerValue('ORDER_DATATYPE', ODT_CANCEL);

    LSValue := ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '매매구분'));

    if (LSValue = '1') then
      LNValue := 2 // 매수
    else if (LSValue = '2') then
      LNValue := 1 // 매도
    else
      LNValue := 0;

    LStreamRecord1.SetIntegerValue('ORDER_COMMAND', LNValue);

    LStreamRecord1.SetIntegerValue('ORDER_VOLUME', ReadInteger(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문수량')));

    LStreamRecord1.SetDoubleValue('ORDER_PRICE', ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문가격'), LPrecision));

    LNValue := 0;
    LStreamRecord1.SetIntegerValue('TRADE_VOLUME_TYPE', LNValue);

    LStreamRecord1.SetIntegerValue('TRADE_VOLUME', ReadInteger(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '체결수량')));

    LStreamRecord1.SetDoubleValue('TRADE_PRICE', ReadDouble(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '체결가격'), 0));

    LStreamRecord1.SetStringValue('ORDER_NO', ReadString(m_Agent.CommGetData(sKey, nRealType, 'OutRec1', 0, '주문번호')));

    LStreamRecord1.SetStringValue('ORG_ORDER_NO', '');

    LStreamRecord1.SetStringValue('ASPR_RJCT_RSCD', '');

    LStreamRecord1.SetIntegerValue('ACCEPT', 0);
    LStreamRecord1.SetDoubleValue('RECEIVE_TIME', Now);

    LOG_WRITE(LOG_TYPE_INFO, 'CFNHDAgentManager', '주문체결; ' + '사용자:' + LStreamRecord1.GetStringValue('USERID') + '; ' + '계좌:' + LStreamRecord1.GetStringValue('ACCOUNT_NO') + '; ' + '종목:' + LStreamRecord1.GetStringValue('SYMBOL') + '; ' + '주문데이터유형:' + IntToStr(LStreamRecord1.GetIntegerValue('ORDER_DATATYPE')) + '; ' + '매매구분:' + IntToStr(LStreamRecord1.GetIntegerValue('ORDER_COMMAND')) + '; ' + '주문량:' + IntToStr(LStreamRecord1.GetIntegerValue('ORDER_VOLUME')) + '; ' + '주문가:' +
      TFNGlobal.WriteNumber(LStreamRecord1.GetDoubleValue('ORDER_PRICE'), 2) + '; ' + '체결량:' + IntToStr(LStreamRecord1.GetIntegerValue('TRADE_VOLUME')) + '; ' + '체결가:' + TFNGlobal.WriteNumber(LStreamRecord1.GetDoubleValue('TRADE_PRICE'), 2) + '; ' + '주문번호:' + LStreamRecord1.GetStringValue('ORDER_NO') + '; ' + '원주문번호:' + LStreamRecord1.GetStringValue('ORG_ORDER_NO') + '; ');
  end;

{$REGION '전달'}
  if Assigned(LStreamRecord1) then
  begin
    LSubscribeKey := LStreamRecord1.GetStringValue('USERID') + ':' + LStreamRecord1.GetStringValue('ACCOUNT_NO');

    m_STSubscribeTableLock.Enter;
    try
      LObjectList := m_STSubscribeTable[MAP_USERTRADE].GetKey(LSubscribeKey);
    finally
      m_STSubscribeTableLock.Leave;
    end;

    if Assigned(LObjectList) then
    begin
      try
        for LLoop := 0 to LObjectList.Count - 1 do
        begin
          LDataDelivery := CFNDataDelivery(LObjectList.Items[LLoop]);
          if Assigned(LDataDelivery) then
          begin
            LSendStreamRecord := CFNStreamRecord.Create;
            LSendStreamRecord.CloneStreamRecord(LStreamRecord1);
            try
              LDataDelivery.DeliveryStream(LSendStreamRecord);
            except
              LSendStreamRecord.Free;
            end;
          end;
        end;
      except
      end;
      SaveStreamRecord(LStreamRecord1);

      LObjectList.Clear;
      LObjectList.Free;
      LObjectList := NIL;
    end
    else
    begin
      LStreamRecord1.Free;
      LStreamRecord1 := NIL;
    end;
  end;
{$ENDREGION}
{$REGION '전달'}
  if Assigned(LStreamRecord2) then
  begin
    LSubscribeKey := LStreamRecord2.GetStringValue('USERID') + ':' + LStreamRecord2.GetStringValue('ACCOUNT_NO');

    m_STSubscribeTableLock.Enter;
    try
      LObjectList := m_STSubscribeTable[MAP_USERTRADE].GetKey(LSubscribeKey);
    finally
      m_STSubscribeTableLock.Leave;
    end;

    if Assigned(LObjectList) then
    begin
      try
        for LLoop := 0 to LObjectList.Count - 1 do
        begin
          LDataDelivery := CFNDataDelivery(LObjectList.Items[LLoop]);
          if Assigned(LDataDelivery) then
          begin
            LSendStreamRecord := CFNStreamRecord.Create;
            LSendStreamRecord.CloneStreamRecord(LStreamRecord2);
            try
              LDataDelivery.DeliveryStream(LSendStreamRecord);
            except
              LSendStreamRecord.Free;
            end;
          end;
        end;
      except
      end;
      SaveStreamRecord(LStreamRecord2);

      LObjectList.Clear;
      LObjectList.Free;
      LObjectList := NIL;
    end
    else
    begin
      LStreamRecord2.Free;
      LStreamRecord2 := NIL;
    end;
  end;
{$ENDREGION}
end;

{$ENDREGION}
{$ENDREGION}
{$REGION '각 종 함수들'}

// ---------------------------------------------------------------------------
procedure CFNHDAgentManager.GetGategory(ASymbol: String; var ACountry: Integer; var AGroup: Integer; var AMarket: Integer);
var
  LKey: String;
begin
  LKey := Copy(ASymbol, 1, 2);
  if SameText(LKey, 'ES') OR SameText(LKey, 'NQ') OR SameText(LKey, 'YM') then
  begin
    ACountry := 2;
    AGroup := 2;
    AMarket := 0;
  end
  else if SameText(LKey, '6E') OR SameText(LKey, '6J') OR SameText(LKey, '6B') then
  begin
    ACountry := 2;
    AGroup := 3;
    AMarket := 0;
  end
  else if SameText(LKey, 'GC') OR SameText(LKey, 'CL') then
  begin
    ACountry := 2;
    AGroup := 4;
    AMarket := 0;
  end
  else if SameText(LKey, 'ZN') then
  begin
    ACountry := 2;
    AGroup := 5;
    AMarket := 0;
  end
  else
  begin
    ACountry := 2;
    AGroup := 2;
    AMarket := 0;
  end;
end;

// ---------------------------------------------------------------------------
function CFNHDAgentManager.GetMaterialData(ASymbol: String; var ACountry: Integer; var AGroup: Integer; var AMarket: Integer): CFNMaterialItem;
var
  LMaterialItem: CFNMaterialItem;
  LKey: String;
begin
  LKey := Copy(ASymbol, 1, 2);
  if SameText(LKey, 'ES') OR SameText(LKey, 'NQ') OR SameText(LKey, 'YM') then
  begin
    ACountry := 2;
    AGroup := 2;
    AMarket := 0;
  end
  else if SameText(LKey, '6E') OR SameText(LKey, '6J') OR SameText(LKey, '6B') then
  begin
    ACountry := 2;
    AGroup := 3;
    AMarket := 0;
  end
  else if SameText(LKey, 'GC') OR SameText(LKey, 'CL') then
  begin
    ACountry := 2;
    AGroup := 4;
    AMarket := 0;
  end
  else if SameText(LKey, 'ZN') then
  begin
    ACountry := 2;
    AGroup := 5;
    AMarket := 0;
  end;

  LMaterialItem := NIL;
  if Assigned(g_MaterialCollection) then
  begin
    LMaterialItem := g_MaterialCollection.Find(ACountry, AGroup, AMarket, g_SymbolCollection.GetOPSSymbol(ASymbol));
  end;

  Result := LMaterialItem;
end;

// ---------------------------------------------------------------------------
function WriteInteger(AValue: Integer; ASize: Integer): String;
var
  LSource: String;
  LIndex: Integer;
begin
  LSource := Format('%-*d', [ASize, AValue]);
  (*
    for LIndex := 1 to Length(LSource) do
    begin
    if LSource[LIndex] = ' ' then LSource[LIndex] := '0'
    else if LSource[LIndex] = '-' then continue
    else break;
    end;
  *)
  Result := LSource;
end;

// ---------------------------------------------------------------------------
function WriteDouble(AValue: Double; ASize: Integer; APrecision: Integer): String;
begin
  Result := WriteInteger(Round(AValue * Power(10, APrecision)), ASize);
end;

// ---------------------------------------------------------------------------
function WriteString(AValue: String; ASize: Integer): String;
begin
  Result := Format('%-*s', [ASize, AValue]);
end;

// ---------------------------------------------------------------------------
function ReadString(ASource: String): String;
var
  LIndex: Integer;
  LSource: String;
begin
  LSource := ASource;
  for LIndex := 0 to Length(LSource) - 1 do
  begin
    if (Copy(LSource, LIndex, 1) < #$20) then
    begin
      LSource := Copy(LSource, 0, LIndex);
      break;
    end;
  end;

  Result := Trim(LSource);
end;

// ---------------------------------------------------------------------------
function ReadInteger(ASource: String): Integer;
begin
  Result := TFNGlobal.atoi(ReadString(ASource));
end;

// ---------------------------------------------------------------------------
function ReadDouble(ASource: String; APrecision: Integer): Double;
begin
  Result := TFNGlobal.atof(ReadString(ASource)) / Power(10, APrecision);
end;

{$ENDREGION}

end.
