// **************************************************************************//
// FileName        :   FNVirtualTradeManager.pas
// Author          :   김무근 작성
// Date            :   2012년 7월 10일
// Description     :
// **************************************************************************//
{ 교보증권사 API를 통해, 시세와 주문을 구현하기 위한 클래스 }
Unit FNVirtualTradeManager;

interface

uses
  Dialogs, Messages, WinProcs, SysUtils, Forms, ActiveX, WinTypes, Classes,
  SyncObjs, Contnrs, IniFiles, VarUtils, Variants, Math,
  FNDataSet, FNDataDelivery, FNThread,
  FNAgentManager, FNQuotData;

type
  CFNOrderData = class(TObject)
  public
    RQINDEX: Integer;

    SIGNAL_SEQ: Integer;
    ORDER_SEQ: Integer;
    USERID: String;
    ACCOUNT_NO: String;
    PASSWORD: String;
    SYMBOL: String;
    ORDER_COMMAND: Integer;
    ORDER_VOLUME: Integer;
    ORDER_PRICE: Double;
    CURRENT_PRICE: Double;
    PRICETYPE: String;
    CONDITION: Integer;
    ORG_ORDER_NO: String;

    STEP: Integer; // 0:Create, 1:접수(주문번호), 2:접수확인, 3:체결
    ORDER_NO: String;
    TRADE_VOLUME: Integer;
    TRADE_PRICE: Double;

    CREATETIME: TDateTime;
    CONFIRMTIME: TDateTime;
    DELAYSECOUND: Integer;

    constructor Create;
    destructor Destroy; override;
  end;

  CFNVirtualTradeManager = class;

  // ---------------------------------------------------------------------------
  CFNVirtualTradeThread = class(CFNThread)
  public
    m_Manager: CFNVirtualTradeManager;

  protected
    procedure StartWork; override;
    procedure DoWork; override;
    procedure EndWork; override;

    procedure SetManager(AManager: CFNVirtualTradeManager);
  end;

  CFNVirtualTradeManager = class(CFNAgentManager)
  public
    /// <Comment>생성자</Comment>
    Constructor Create(AUseQuote: Boolean = false; AUseAgent: Boolean = false);

    /// <Comment>파괴자</Comment>
    Destructor Destroy; override;

    /// <Comment>작업쓰레드가 진입하는 곳</Comment>
    procedure DoQueryWork(AThreadIndex: Integer); override;

    procedure StartTradeWork;
    procedure DoTradeWork;
    procedure EndTradeWork;

    /// <Comment>주문체결통보 실시간 스트리밍 데이터를 요청한다.</Comment>
    procedure SubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = ''); override;

    /// <Comment>주문체결통보 실시간 스트리밍 데이터를 요청한다.</Comment>
    procedure UnsubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = ''); override;

    procedure ClearOrder;

  private
    m_UseQuote: Boolean;
    m_UseAgent: Boolean;
    m_QuotLock: TCriticalSection;
    m_ES: CFNQuotData;
    m_NQ: CFNQuotData;
    m_6E: CFNQuotData;
    m_CL: CFNQuotData;
    m_GC: CFNQuotData;
    m_DataDelivery: CFNDataDelivery;
    m_ESTradable: Boolean;
    m_NQTradable: Boolean;
    m_6ETradable: Boolean;
    m_CLTradable: Boolean;
    m_GCTradable: Boolean;

    procedure OnStream(AStreamRecord: CFNStreamRecord);

  private
    m_RQIndex: Integer;
    m_OrderItems: TList;
    m_DataLock: TCriticalSection;
    m_OrderNo: Integer;
    m_TradeThread: CFNVirtualTradeThread;

    /// <Comment>각종 실시간 데이터의 구조를 분석할 때 사용한다.</Comment>
    m_DataStream: TMemoryStream;

    /// <Comment>선물주문 패킷을 만들어서 Agent에 전달한다.</Comment>
    procedure SC_ORDER_TR_0210(p_QueryData: CFNQueryData);

    /// <Comment>패킷중 에러코드와 메세지를 추가하는 부분</Comment>
    procedure WriteMessage(p_QueryData: CFNQueryData; sErrorCode, sMsg: WideString);

    /// <Comment>패킷중 에러코드와 메세지를 추가하는 부분</Comment>
    procedure WriteError(p_QueryData: CFNQueryData; sErrorCode: WideString);

  end;

{$ALIGN 1}

  /// 교보 증권 스트리밍 데이터의 해드
  pTREALDATA = ^TREALDATA;

  TREALDATA = record
    pMgBuffer: DWORD;
    szKeyCode: Array [0 .. 49] of AnsiChar;
    nRealType: Integer;
    nRealStructSize: Integer;
    pDataBuf: PByte;
    nPoolDataUse: Integer;
    nQueDataCount: Integer;
    nTotalCount: Integer;
    nCurIndex: Integer;
    nByteOrder: Integer;
    nSharedReal: Integer;
    pSharedRealBuf: PByte;
  end;
{$ALIGN 8}

const
  REAL_F40 = $AA; // (170)	신규주문접수, 정정주문접수, 취소주문접수

const
  REAL_F41 = $AB; // (171)	선물 : 신규주문확인

const
  REAL_F42 = $AC; // (172)   선물 : 주문체결 수신 *

const
  REAL_F43 = $AD; // (173)   선물 : 정정주문확인, 취소주문확인, 주문거부

implementation

uses
  FNGlobal, FNGlobalVariable, WideStrUtils, CommonTRMaker, FNCMVariable,
  FNTradeSystem, FNSymbolCollection, MXVariable;

// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
procedure CFNVirtualTradeThread.StartWork;
begin
  inherited StartWork;

  if Assigned(m_Manager) then
  begin
    m_Manager.StartTradeWork;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNVirtualTradeThread.EndWork;
begin
  if Assigned(m_Manager) then
  begin
    m_Manager.EndTradeWork;
  end;

  inherited EndWork;
end;

// ---------------------------------------------------------------------------
procedure CFNVirtualTradeThread.DoWork;
var
  f_State: Integer;
begin
  if Assigned(m_Manager) then
  begin
    f_State := m_Manager.GetState;
    if AGENT_THREAD_START = f_State then
    begin
      m_Working := True;

      m_Manager.DoTradeWork;
    end;
  end;

  m_Working := false;
end;

// ---------------------------------------------------------------------------
procedure CFNVirtualTradeThread.SetManager(AManager: CFNVirtualTradeManager);
begin
  m_Manager := AManager;
end;

// ---------------------------------------------------------------------------
Constructor CFNVirtualTradeManager.Create(AUseQuote: Boolean; AUseAgent: Boolean);
begin
  inherited Create;
  m_UseQuote := AUseQuote;
  m_UseAgent := AUseAgent;

  m_RQIndex := 0;
  m_OrderNo := 0;
  m_DataStream := TMemoryStream.Create;
  m_OrderItems := TList.Create;
  m_DataLock := TCriticalSection.Create;

  m_QuotLock := TCriticalSection.Create;
  m_ES := CFNQuotData.Create;
  m_NQ := CFNQuotData.Create;
  m_6E := CFNQuotData.Create;
  m_CL := CFNQuotData.Create;
  m_GC := CFNQuotData.Create;

  m_ESTradable := false;
  m_NQTradable := false;
  m_6ETradable := false;
  m_CLTradable := false;
  m_GCTradable := false;

  m_DataDelivery := CFNDataDelivery.Create;
  m_DataDelivery.OnStreamEvent := OnStream;

  m_TradeThread := CFNVirtualTradeThread.Create;
  m_TradeThread.SetSleepTime(50);
  m_TradeThread.SetManager(Self);
  m_TradeThread.Resume;

  Randomize;
end;

// ---------------------------------------------------------------------------
Destructor CFNVirtualTradeManager.Destroy;
var
  nTry: Integer;
begin
  if Assigned(m_TradeThread) then
  begin
    m_TradeThread.StopThread;
  end;

  nTry := 0;
  while Assigned(m_TradeThread) do
  begin
    if (not m_TradeThread.Finished) then
    begin
      m_TradeThread.StopThread;
      Inc(nTry);
      if (nTry > 20) then
      begin
        m_TradeThread.ExitThread;
        m_TradeThread.Free;
        m_TradeThread := NIL;
        break;
      end;
    end
    else
    begin
      m_TradeThread.Free;
      m_TradeThread := NIL;
      break;
    end;
    Sleep(10);
  end;

  ClearOrder;
  if Assigned(m_OrderItems) then
  begin
    m_OrderItems.Free;
    m_OrderItems := NIL;
  end;

  if Assigned(m_DataLock) then
  begin
    m_DataLock.Free;
    m_DataLock := NIL;
  end;

  m_DataStream.Free;

  m_DataDelivery.Free;
  m_QuotLock.Free;
  m_ES.Free;
  m_NQ.Free;
  m_6E.Free;
  m_CL.Free;
  m_GC.Free;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNVirtualTradeManager.ClearOrder;
begin
  while 0 < m_OrderItems.Count do
  begin
    CFNOrderData(m_OrderItems.Items[0]).Free;
    m_OrderItems.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 선물 스트리밍 체결통보 등록
procedure CFNVirtualTradeManager.SubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = '');
begin
  if m_STSubscribeTable[MAP_USERTRADE].AddKeyValue(AUserID, ADataDelivery) then
  begin

  end;
end;

// ---------------------------------------------------------------------------
// 선물 스트리밍 체결통보 등록 해지
procedure CFNVirtualTradeManager.UnsubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = '');
begin
  if m_STSubscribeTable[MAP_USERTRADE].DeleteKeyValue(AUserID, ADataDelivery) then
  begin

  end;
end;

// ---------------------------------------------------------------------------
// Agent로 요청한 요청패킷을 하나 씩 꺼내 분석하여, 그 업무에 맞는 Agent내 함수를 이용하여 증권사로 요청을 한다.
procedure CFNVirtualTradeManager.DoQueryWork(AThreadIndex: Integer);
var
  f_QueryData: CFNQueryData;
begin
  f_QueryData := RetrieveSendData;
  if not Assigned(f_QueryData) then
    exit;

  if f_QueryData.m_ServiceID = 'SC_ORDER' then
  begin
    // 선물 주문
    if (f_QueryData.m_TRCode = 'TR_0210') then
    begin
      SC_ORDER_TR_0210(f_QueryData);
    end
    else
    begin
      WriteError(f_QueryData, 'M10001');
      StoreRecvData(f_QueryData);
    end;
  end
  else
  begin
    WriteError(f_QueryData, 'M10001');
    StoreRecvData(f_QueryData);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNVirtualTradeManager.OnStream(AStreamRecord: CFNStreamRecord);
var
  LSymbol: String;
  LTotalVolume: Double;
begin
  if AStreamRecord.GetPacketKey = 'QUOTE' then
  begin

    m_QuotLock.Enter;
    try
      LSymbol := AStreamRecord.GetStringValue('SYMBOL');
      LTotalVolume := AStreamRecord.GetDoubleValue('TOTAL_VOLUME');
      if (LSymbol = 'CME003_FN') or (Copy(LSymbol, 0, 2) = 'ES') then
      begin
        if m_ES.m_TotalVolume < LTotalVolume then
        begin
          m_ESTradable := True;
        end;
        m_ES.ArrayToData(AStreamRecord);
      end
      else if (LSymbol = 'CME004_FN') or (Copy(LSymbol, 0, 2) = 'NQ') then
      begin
        if m_NQ.m_TotalVolume < LTotalVolume then
        begin
          m_NQTradable := True;
        end;
        m_NQ.ArrayToData(AStreamRecord);
      end
      else if (LSymbol = '6E_FN') or (Copy(LSymbol, 0, 2) = '6E') then
      begin
        if m_6E.m_TotalVolume < LTotalVolume then
        begin
          m_6ETradable := True;
        end;
        m_6E.ArrayToData(AStreamRecord);
      end
      else if (LSymbol = 'WTI001_FN') or (Copy(LSymbol, 0, 2) = 'CL') then
      begin
        if m_CL.m_TotalVolume < LTotalVolume then
        begin
          m_CLTradable := True;
        end;
        m_CL.ArrayToData(AStreamRecord);
      end
      else if (LSymbol = 'WTI004_FN') or (Copy(LSymbol, 0, 2) = 'GC') then
      begin
        if m_GC.m_TotalVolume < LTotalVolume then
        begin
          m_GCTradable := True;
        end;
        m_GC.ArrayToData(AStreamRecord);
      end;

    finally
      m_QuotLock.Leave;
    end;
  end;
  AStreamRecord.DecreaseReferenceCount;
end;

// ---------------------------------------------------------------------------
procedure CFNVirtualTradeManager.StartTradeWork;
var
  f_SymbolItem: CFNSymbolItem;
begin
  if not m_UseQuote then
    exit;
  if not Assigned(g_SocketManager) then
    exit;
  if not Assigned(g_SymbolCollection) then
    exit;

  f_SymbolItem := g_SymbolCollection.Find(2, 2, 0, 'CME003_FN');
  if Assigned(f_SymbolItem) then
  begin
    if m_UseAgent then
    begin
      g_AgentManager.SubscribeQuote(m_DataDelivery, f_SymbolItem.m_Country, f_SymbolItem.m_Group, f_SymbolItem.m_Market, f_SymbolItem.m_SecSymbol + f_SymbolItem.m_Contract);
    end
    else
    begin
      g_SocketManager.SubscribeQuote(m_DataDelivery, f_SymbolItem.m_Country, f_SymbolItem.m_Group, f_SymbolItem.m_Market, f_SymbolItem.m_Symbol);
    end;
  end;

  f_SymbolItem := g_SymbolCollection.Find(2, 2, 0, 'CME004_FN');
  if Assigned(f_SymbolItem) then
  begin
    if m_UseAgent then
    begin
      g_AgentManager.SubscribeQuote(m_DataDelivery, f_SymbolItem.m_Country, f_SymbolItem.m_Group, f_SymbolItem.m_Market, f_SymbolItem.m_SecSymbol + f_SymbolItem.m_Contract);
    end
    else
    begin
      g_SocketManager.SubscribeQuote(m_DataDelivery, f_SymbolItem.m_Country, f_SymbolItem.m_Group, f_SymbolItem.m_Market, f_SymbolItem.m_Symbol);
    end;
  end;

  f_SymbolItem := g_SymbolCollection.Find(2, 3, 0, '6E_FN');
  if Assigned(f_SymbolItem) then
  begin
    if m_UseAgent then
    begin
      g_AgentManager.SubscribeQuote(m_DataDelivery, f_SymbolItem.m_Country, f_SymbolItem.m_Group, f_SymbolItem.m_Market, f_SymbolItem.m_SecSymbol + f_SymbolItem.m_Contract);
    end
    else
    begin
      g_SocketManager.SubscribeQuote(m_DataDelivery, f_SymbolItem.m_Country, f_SymbolItem.m_Group, f_SymbolItem.m_Market, f_SymbolItem.m_Symbol);
    end;
  end;

  f_SymbolItem := g_SymbolCollection.Find(2, 4, 0, 'WTI001_FN');
  if Assigned(f_SymbolItem) then
  begin
    if m_UseAgent then
    begin
      g_AgentManager.SubscribeQuote(m_DataDelivery, f_SymbolItem.m_Country, f_SymbolItem.m_Group, f_SymbolItem.m_Market, f_SymbolItem.m_SecSymbol + f_SymbolItem.m_Contract);
    end
    else
    begin
      g_SocketManager.SubscribeQuote(m_DataDelivery, f_SymbolItem.m_Country, f_SymbolItem.m_Group, f_SymbolItem.m_Market, f_SymbolItem.m_Symbol);
    end;
  end;

  f_SymbolItem := g_SymbolCollection.Find(2, 4, 0, 'WTI004_FN');
  if Assigned(f_SymbolItem) then
  begin
    if m_UseAgent then
    begin
      g_AgentManager.SubscribeQuote(m_DataDelivery, f_SymbolItem.m_Country, f_SymbolItem.m_Group, f_SymbolItem.m_Market, f_SymbolItem.m_SecSymbol + f_SymbolItem.m_Contract);
    end
    else
    begin
      g_SocketManager.SubscribeQuote(m_DataDelivery, f_SymbolItem.m_Country, f_SymbolItem.m_Group, f_SymbolItem.m_Market, f_SymbolItem.m_Symbol);
    end;
  end;

end;

// ---------------------------------------------------------------------------
procedure CFNVirtualTradeManager.DoTradeWork;
var
  f_OrderData: CFNOrderData;
  f_Index: Integer;
  f_ObjectList: TObjectList;
  f_StreamRecord: CFNStreamRecord;
  f_SendStreamRecord: CFNStreamRecord;
  f_Loop: Integer;
  f_DataDelivery: CFNDataDelivery;
  f_Tradable: Boolean;
  f_QuotData: CFNQuotData;
begin

  m_DataLock.Enter;
  try
    for f_Index := 0 to m_OrderItems.Count - 1 do
    begin
      f_OrderData := CFNOrderData(m_OrderItems.Items[f_Index]);
      if Assigned(f_OrderData) then
      begin
        // 주문 접수
        if (f_OrderData.STEP = 1) or (f_OrderData.STEP = 11) or (f_OrderData.STEP = 21) then
        begin
          Inc(f_OrderData.STEP);

          m_STSubscribeTableLock.Enter;
          try
            f_ObjectList := m_STSubscribeTable[MAP_USERTRADE].GetKey(f_OrderData.USERID);
          finally
            m_STSubscribeTableLock.Leave;
          end;

          if Assigned(f_ObjectList) then
          begin
            f_StreamRecord := CFNStreamRecord.Create;
            f_StreamRecord.SetPacketKey('ORDER_RECEIVE');

            f_StreamRecord.SetStringValue('USERID', f_OrderData.USERID);
            f_StreamRecord.SetStringValue('ACCOUNT_NO', f_OrderData.ACCOUNT_NO);
            f_StreamRecord.SetStringValue('SYMBOL', f_OrderData.SYMBOL);

            if ((f_OrderData.STEP div 10) = 0) then
            begin
              f_StreamRecord.SetIntegerValue('ORDER_DATATYPE', ODT_NEW);
            end
            else if ((f_OrderData.STEP div 10) = 1) then
            begin
              f_StreamRecord.SetIntegerValue('ORDER_DATATYPE', ODT_AMENDED);
            end
            else
            begin
              f_StreamRecord.SetIntegerValue('ORDER_DATATYPE', ODT_CANCEL);
            end;

            f_StreamRecord.SetIntegerValue('ORDER_COMMAND', f_OrderData.ORDER_COMMAND);
            f_StreamRecord.SetIntegerValue('ORDER_VOLUME', f_OrderData.ORDER_VOLUME);

            f_StreamRecord.SetDoubleValue('ORDER_PRICE', f_OrderData.ORDER_PRICE);
            f_StreamRecord.SetStringValue('PRICETYPE', f_OrderData.PRICETYPE);

            f_StreamRecord.SetIntegerValue('CONDITION', f_OrderData.CONDITION);
            f_StreamRecord.SetStringValue('ORDER_NO', f_OrderData.ORDER_NO);
            f_StreamRecord.SetStringValue('ORG_ORDER_NO', f_OrderData.ORG_ORDER_NO);

            f_StreamRecord.SetIntegerValue('ACCEPT', 0);
            f_StreamRecord.SetDoubleValue('RECEIVE_TIME', Now);

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
          end;

        end
        else

          // 주문 확인
          if (f_OrderData.STEP = 2) or (f_OrderData.STEP = 12) or (f_OrderData.STEP = 22) then
          begin
            if Math.Floor((Now - f_OrderData.CREATETIME) * 86400) > 1 then
            begin

              Inc(f_OrderData.STEP);
              f_OrderData.CONFIRMTIME := Now;

              m_STSubscribeTableLock.Enter;
              try
                f_ObjectList := m_STSubscribeTable[MAP_USERTRADE].GetKey(f_OrderData.USERID);
              finally
                m_STSubscribeTableLock.Leave;
              end;

              if Assigned(f_ObjectList) then
              begin
                f_StreamRecord := CFNStreamRecord.Create;
                f_StreamRecord.SetPacketKey('ORDER_CONFIRM');

                f_StreamRecord.SetStringValue('USERID', f_OrderData.USERID);
                f_StreamRecord.SetStringValue('ACCOUNT_NO', f_OrderData.ACCOUNT_NO);
                f_StreamRecord.SetStringValue('SYMBOL', f_OrderData.SYMBOL);

                if ((f_OrderData.STEP div 10) = 0) then
                begin
                  f_StreamRecord.SetIntegerValue('ORDER_DATATYPE', ODT_NEW);
                end
                else if ((f_OrderData.STEP div 10) = 1) then
                begin
                  f_StreamRecord.SetIntegerValue('ORDER_DATATYPE', ODT_AMENDED);
                end
                else
                begin
                  f_StreamRecord.SetIntegerValue('ORDER_DATATYPE', ODT_CANCEL);
                end;

                f_StreamRecord.SetIntegerValue('ORDER_COMMAND', f_OrderData.ORDER_COMMAND);
                f_StreamRecord.SetIntegerValue('ORDER_VOLUME', f_OrderData.ORDER_VOLUME);

                f_StreamRecord.SetDoubleValue('ORDER_PRICE', f_OrderData.ORDER_PRICE);
                f_StreamRecord.SetStringValue('PRICETYPE', f_OrderData.PRICETYPE);

                f_StreamRecord.SetIntegerValue('CONDITION', f_OrderData.CONDITION);
                f_StreamRecord.SetStringValue('ORDER_NO', f_OrderData.ORDER_NO);
                f_StreamRecord.SetStringValue('ORG_ORDER_NO', f_OrderData.ORG_ORDER_NO);

                f_StreamRecord.SetIntegerValue('ACCEPT', 0);
                f_StreamRecord.SetDoubleValue('RECEIVE_TIME', Now);

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
              end;
            end;

          end
          else

            // 주문 체결
            if (f_OrderData.STEP = 3) or (f_OrderData.STEP = 13) then
            begin
              if not m_UseQuote then
              begin

{$REGION '시세를 사용하지 않을 때.'}
                if Math.Floor((Now - f_OrderData.CONFIRMTIME) * 86400) > f_OrderData.DELAYSECOUND then
                begin
                  f_OrderData.CREATETIME := Now;
                  f_OrderData.CONFIRMTIME := 0;

                  Inc(f_OrderData.STEP);
                  f_OrderData.TRADE_PRICE := f_OrderData.ORDER_PRICE;
                  f_OrderData.TRADE_VOLUME := f_OrderData.ORDER_VOLUME;

                  if f_OrderData.TRADE_PRICE = 0 then
                  begin
                    f_OrderData.TRADE_PRICE := f_OrderData.CURRENT_PRICE;
                  end;

                  m_STSubscribeTableLock.Enter;
                  try
                    f_ObjectList := m_STSubscribeTable[MAP_USERTRADE].GetKey(f_OrderData.USERID);
                  finally
                    m_STSubscribeTableLock.Leave;
                  end;

                  if Assigned(f_ObjectList) then
                  begin
                    f_StreamRecord := CFNStreamRecord.Create;
                    f_StreamRecord.SetPacketKey('ORDER_TRADE');

                    f_StreamRecord.SetStringValue('USERID', f_OrderData.USERID);
                    f_StreamRecord.SetStringValue('ACCOUNT_NO', f_OrderData.ACCOUNT_NO);
                    f_StreamRecord.SetStringValue('SYMBOL', f_OrderData.SYMBOL);

                    if ((f_OrderData.STEP div 10) = 0) then
                    begin
                      f_StreamRecord.SetIntegerValue('ORDER_DATATYPE', ODT_NEW);
                    end
                    else if ((f_OrderData.STEP div 10) = 1) then
                    begin
                      f_StreamRecord.SetIntegerValue('ORDER_DATATYPE', ODT_AMENDED);
                    end
                    else
                    begin
                      f_StreamRecord.SetIntegerValue('ORDER_DATATYPE', ODT_CANCEL);
                    end;

                    f_StreamRecord.SetIntegerValue('ORDER_COMMAND', f_OrderData.ORDER_COMMAND);
                    f_StreamRecord.SetIntegerValue('ORDER_VOLUME', f_OrderData.ORDER_VOLUME);

                    f_StreamRecord.SetDoubleValue('ORDER_PRICE', f_OrderData.ORDER_PRICE);
                    f_StreamRecord.SetStringValue('PRICETYPE', f_OrderData.PRICETYPE);

                    f_StreamRecord.SetIntegerValue('CONDITION', f_OrderData.CONDITION);
                    f_StreamRecord.SetStringValue('ORDER_NO', f_OrderData.ORDER_NO);
                    f_StreamRecord.SetStringValue('ORG_ORDER_NO', f_OrderData.ORG_ORDER_NO);

                    f_StreamRecord.SetIntegerValue('TRADE_VOLUME_TYPE', 0);
                    f_StreamRecord.SetIntegerValue('TRADE_VOLUME', f_OrderData.TRADE_VOLUME);
                    f_StreamRecord.SetDoubleValue('TRADE_PRICE', f_OrderData.TRADE_PRICE);

                    f_StreamRecord.SetIntegerValue('ACCEPT', 0);
                    f_StreamRecord.SetDoubleValue('RECEIVE_TIME', Now);
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
                  end;
                end;
{$ENDREGION}
              end
              else
              begin
                m_QuotLock.Enter;
                try
{$REGION '시세를 사용할 때.'}
                  f_Tradable := false;
                  f_QuotData := NIL;
                  if Copy(f_OrderData.SYMBOL, 0, 2) = 'ES' then
                  begin
                    f_Tradable := m_ESTradable;
                    f_QuotData := m_ES;
                  end
                  else if Copy(f_OrderData.SYMBOL, 0, 2) = 'NQ' then
                  begin
                    f_Tradable := m_NQTradable;
                    f_QuotData := m_NQ;
                  end
                  else if Copy(f_OrderData.SYMBOL, 0, 2) = '6E' then
                  begin
                    f_Tradable := m_6ETradable;
                    f_QuotData := m_6E;
                  end
                  else if Copy(f_OrderData.SYMBOL, 0, 2) = 'CL' then
                  begin
                    f_Tradable := m_CLTradable;
                    f_QuotData := m_CL;
                  end
                  else if Copy(f_OrderData.SYMBOL, 0, 2) = 'GC' then
                  begin
                    f_Tradable := m_GCTradable;
                    f_QuotData := m_GC;
                  end;

                  if (f_Tradable) and ((f_OrderData.ORDER_PRICE = 0) or (f_OrderData.ORDER_PRICE = f_QuotData.m_ClosePrice)) then
                  begin
                    f_OrderData.CREATETIME := Now;
                    f_OrderData.CONFIRMTIME := 0;

                    Inc(f_OrderData.STEP);
                    f_OrderData.TRADE_PRICE := f_OrderData.ORDER_PRICE;
                    f_OrderData.TRADE_VOLUME := f_OrderData.ORDER_VOLUME;

                    f_OrderData.TRADE_PRICE := f_QuotData.m_ClosePrice;

                    m_STSubscribeTableLock.Enter;
                    try
                      f_ObjectList := m_STSubscribeTable[MAP_USERTRADE].GetKey(f_OrderData.USERID);
                    finally
                      m_STSubscribeTableLock.Leave;
                    end;

                    if Assigned(f_ObjectList) then
                    begin
                      f_StreamRecord := CFNStreamRecord.Create;
                      f_StreamRecord.SetPacketKey('ORDER_TRADE');

                      f_StreamRecord.SetStringValue('USERID', f_OrderData.USERID);
                      f_StreamRecord.SetStringValue('ACCOUNT_NO', f_OrderData.ACCOUNT_NO);
                      f_StreamRecord.SetStringValue('SYMBOL', f_OrderData.SYMBOL);

                      if ((f_OrderData.STEP div 10) = 0) then
                      begin
                        f_StreamRecord.SetIntegerValue('ORDER_DATATYPE', ODT_NEW);
                      end
                      else if ((f_OrderData.STEP div 10) = 1) then
                      begin
                        f_StreamRecord.SetIntegerValue('ORDER_DATATYPE', ODT_AMENDED);
                      end
                      else
                      begin
                        f_StreamRecord.SetIntegerValue('ORDER_DATATYPE', ODT_CANCEL);
                      end;

                      f_StreamRecord.SetIntegerValue('ORDER_COMMAND', f_OrderData.ORDER_COMMAND);
                      f_StreamRecord.SetIntegerValue('ORDER_VOLUME', f_OrderData.ORDER_VOLUME);

                      f_StreamRecord.SetDoubleValue('ORDER_PRICE', f_OrderData.ORDER_PRICE);
                      f_StreamRecord.SetStringValue('PRICETYPE', f_OrderData.PRICETYPE);

                      f_StreamRecord.SetIntegerValue('CONDITION', f_OrderData.CONDITION);
                      f_StreamRecord.SetStringValue('ORDER_NO', f_OrderData.ORDER_NO);
                      f_StreamRecord.SetStringValue('ORG_ORDER_NO', f_OrderData.ORG_ORDER_NO);

                      f_StreamRecord.SetIntegerValue('TRADE_VOLUME_TYPE', 0);
                      f_StreamRecord.SetIntegerValue('TRADE_VOLUME', f_OrderData.TRADE_VOLUME);
                      f_StreamRecord.SetDoubleValue('TRADE_PRICE', f_OrderData.TRADE_PRICE);

                      f_StreamRecord.SetIntegerValue('ACCEPT', 0);
                      f_StreamRecord.SetDoubleValue('RECEIVE_TIME', Now);
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
                    end;
                  end;
{$ENDREGION}
                finally
                  m_QuotLock.Leave;
                end;
              end;
            end;
      end;
    end;
  finally
    m_DataLock.Leave;
  end;
  (*
    m_QuotLock.Enter;
    try
    m_ESTradable:= false;
    m_NQTradable:= false;
    m_6ETradable:= false;
    m_CLTradable:= false;
    m_GCTradable:= false;
    finally
    m_QuotLock.Leave;
    end;
  *)
end;

// ---------------------------------------------------------------------------
procedure CFNVirtualTradeManager.EndTradeWork;
begin
  if not Assigned(g_SocketManager) then
    exit;
  if m_UseAgent then
  begin
    g_AgentManager.UnsubscribeAll(m_DataDelivery);
  end
  else
  begin
    g_SocketManager.UnsubscribeAll(m_DataDelivery);
  end;
end;

// ---------------------------------------------------------------------------
// 패킷중 에러코드와 메세지를 추가하는 부분
procedure CFNVirtualTradeManager.WriteMessage(p_QueryData: CFNQueryData; sErrorCode, sMsg: WideString);
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
procedure CFNVirtualTradeManager.WriteError(p_QueryData: CFNQueryData; sErrorCode: WideString);
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
  else if sErrorCode = 'M20001' then
  begin
    rd.SetStringValue('MESSAGE', '마스트 파일을 읽을 수 없습니다. 교보증권 HTS를 한 번 실행해 주십시요.');
  end;

  p_QueryData.m_Response.m_ErrorDataSet.RecordList.Add(rd);
end;

// ---------------------------------------------------------------------------
// 선물주문 패킷을 만들어서 Agent에 전달한다.
procedure CFNVirtualTradeManager.SC_ORDER_TR_0210(p_QueryData: CFNQueryData);
var
  f_InDataSet: CFNDataSet;
  f_InRecord: CFNRecord;

  f_OutDataSet: CFNDataSet;
  f_OutRecord: CFNRecord;
  f_Symbol: WideString;
  f_OrderData: CFNOrderData;
  f_FindOrderData: CFNOrderData;
  f_OrderCommand: Integer;
  f_OrgOrderNo: String;
  f_Index: Integer;
  f_OrderError: Boolean;
  f_DelayTime: Integer;
begin
  // f_DelayTime := Random(18) + 12;

  f_DelayTime := Random(18) + 12;
  f_DelayTime := 1;

  if (Random(500) < 350) then
  begin
    f_OrderError := false;
  end
  else
  begin
    f_OrderError := True;
  end;
  f_OrderError := false;
  f_Symbol := '';

  m_DataLock.Enter;

  try
    f_InDataSet := p_QueryData.m_Request.GetDataSet(DATASETID_IN_01);
    if Assigned(f_InDataSet) then
    begin
      if (0 < f_InDataSet.RecordList.Count) then
      begin
        f_InRecord := CFNRecord(f_InDataSet.RecordList.Items[0]);
        f_OrderCommand := f_InRecord.GetIntegerValue('ORDER_COMMAND');
        f_OrgOrderNo := f_InRecord.GetStringValue('ORG_ORDER_NO');

{$REGION '취소주문'}
        if (4 = f_OrderCommand) then
        begin
          if (not f_OrderError) then
          begin
            f_FindOrderData := NIL;
            for f_Index := 0 to m_OrderItems.Count - 1 do
            begin
              f_OrderData := CFNOrderData(m_OrderItems.Items[f_Index]);
              if Assigned(f_OrderData) and (f_OrderData.ORDER_NO = f_OrgOrderNo) then
              begin
                f_FindOrderData := f_OrderData;
                break;
              end;
            end;
            if Assigned(f_FindOrderData) then
            begin

              // 이미 체결된 주문... 오류를 반환
              if (f_FindOrderData.STEP = 4) or (f_FindOrderData.STEP = 14) or (f_FindOrderData.STEP = 23) then
              begin
                Inc(m_RQIndex);
                if (m_RQIndex > 10240) then
                  m_RQIndex := 0;

                p_QueryData.m_RequestID := IntToStr(m_RQIndex);
                p_QueryData.m_DateTime := Now;

                p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
                p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);

                Make_SC_ORDER_TR_0210_OUT(p_QueryData.m_Response);
                f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
                f_OutRecord := CFNRecord.Create;

                f_OutRecord.SetIntegerValue('COLLECTION_TYPE', f_InRecord.GetIntegerValue('COLLECTION_TYPE'));
                f_OutRecord.SetIntegerValue('SIGNAL_SEQ', f_InRecord.GetIntegerValue('SIGNAL_SEQ'));
                f_OutRecord.SetIntegerValue('ORDER_SEQ', f_InRecord.GetIntegerValue('ORDER_SEQ'));
                f_OutRecord.SetStringValue('USERID', f_InRecord.GetStringValue('USERID'));
                f_OutRecord.SetStringValue('ACCOUNT_NO', f_InRecord.GetStringValue('ACCOUNT_NO'));
                f_OutRecord.SetStringValue('SYMBOL', f_InRecord.GetStringValue('SYMBOL'));
                f_OutRecord.SetIntegerValue('ORDER_COMMAND', f_InRecord.GetIntegerValue('ORDER_COMMAND'));
                f_OutRecord.SetIntegerValue('ORDER_VOLUME', f_InRecord.GetIntegerValue('ORDER_VOLUME'));
                f_OutRecord.SetDoubleValue('ORDER_PRICE', f_InRecord.GetDoubleValue('ORDER_PRICE'));
                f_OutRecord.SetStringValue('PRICETYPE', f_InRecord.GetStringValue('PRICETYPE'));
                f_OutRecord.SetIntegerValue('CONDITION', f_InRecord.GetIntegerValue('CONDITION'));
                f_OutRecord.SetStringValue('ORDER_NO', f_InRecord.GetStringValue('ORDER_NO'));
                f_OutRecord.SetStringValue('ORG_ORDER_NO', f_InRecord.GetStringValue('ORG_ORDER_NO'));

                f_OutDataSet.RecordList.Add(f_OutRecord);

                WriteMessage(p_QueryData, 'I10001', '이미 체결이 완료되었습니다.');

                if p_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
                begin
                  WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
                end;
                StoreRecvData(p_QueryData);

              end
              else
              begin
                Inc(m_RQIndex);
                if (m_RQIndex > 10240) then
                  m_RQIndex := 0;

                f_FindOrderData.STEP := 20;

                f_FindOrderData.SIGNAL_SEQ := f_InRecord.GetIntegerValue('SIGNAL_SEQ');
                f_FindOrderData.ORDER_SEQ := f_InRecord.GetIntegerValue('ORDER_SEQ');
                f_FindOrderData.ORG_ORDER_NO := f_InRecord.GetStringValue('ORG_ORDER_NO');
                f_FindOrderData.ORDER_NO := '';
                f_FindOrderData.TRADE_VOLUME := 0;
                f_FindOrderData.TRADE_PRICE := 0;
                f_FindOrderData.CREATETIME := Now;
                f_FindOrderData.CONFIRMTIME := 0;
                f_FindOrderData.DELAYSECOUND := f_DelayTime;

                p_QueryData.m_RequestID := IntToStr(m_RQIndex);
                p_QueryData.m_DateTime := Now;

                p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
                p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);

                f_FindOrderData.STEP := 21;
                Inc(m_OrderNo);
                f_FindOrderData.ORDER_NO := IntToStr(m_OrderNo);

                Make_SC_ORDER_TR_0210_OUT(p_QueryData.m_Response);
                f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
                f_OutRecord := CFNRecord.Create;

                f_OutRecord.SetIntegerValue('COLLECTION_TYPE', f_InRecord.GetIntegerValue('COLLECTION_TYPE'));
                f_OutRecord.SetIntegerValue('SIGNAL_SEQ', f_FindOrderData.SIGNAL_SEQ);
                f_OutRecord.SetIntegerValue('ORDER_SEQ', f_FindOrderData.ORDER_SEQ);
                f_OutRecord.SetStringValue('USERID', f_FindOrderData.USERID);
                f_OutRecord.SetStringValue('ACCOUNT_NO', f_InRecord.GetStringValue('ACCOUNT_NO'));
                f_OutRecord.SetStringValue('SYMBOL', f_InRecord.GetStringValue('SYMBOL'));
                f_OutRecord.SetIntegerValue('ORDER_COMMAND', f_InRecord.GetIntegerValue('ORDER_COMMAND'));
                f_OutRecord.SetIntegerValue('ORDER_VOLUME', f_InRecord.GetIntegerValue('ORDER_VOLUME'));
                f_OutRecord.SetDoubleValue('ORDER_PRICE', f_InRecord.GetDoubleValue('ORDER_PRICE'));
                f_OutRecord.SetStringValue('PRICETYPE', f_InRecord.GetStringValue('PRICETYPE'));
                f_OutRecord.SetIntegerValue('CONDITION', f_InRecord.GetIntegerValue('CONDITION'));
                f_OutRecord.SetStringValue('ORDER_NO', f_FindOrderData.ORDER_NO);
                f_OutRecord.SetStringValue('ORG_ORDER_NO', f_FindOrderData.ORG_ORDER_NO);

                f_OutDataSet.RecordList.Add(f_OutRecord);

                WriteMessage(p_QueryData, 'M00000', '정상 처리되었습니다.');

                if p_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
                begin
                  WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
                end;
                StoreRecvData(p_QueryData);
              end;
            end
            else
            begin
              Inc(m_RQIndex);
              if (m_RQIndex > 10240) then
                m_RQIndex := 0;

              p_QueryData.m_RequestID := IntToStr(m_RQIndex);
              p_QueryData.m_DateTime := Now;

              p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
              p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);

              Make_SC_ORDER_TR_0210_OUT(p_QueryData.m_Response);
              f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
              f_OutRecord := CFNRecord.Create;

              f_OutRecord.SetIntegerValue('COLLECTION_TYPE', f_InRecord.GetIntegerValue('COLLECTION_TYPE'));
              f_OutRecord.SetIntegerValue('SIGNAL_SEQ', f_InRecord.GetIntegerValue('SIGNAL_SEQ'));
              f_OutRecord.SetIntegerValue('ORDER_SEQ', f_InRecord.GetIntegerValue('ORDER_SEQ'));
              f_OutRecord.SetStringValue('USERID', f_InRecord.GetStringValue('USERID'));

              f_OutRecord.SetStringValue('ACCOUNT_NO', f_InRecord.GetStringValue('ACCOUNT_NO'));
              f_OutRecord.SetStringValue('SYMBOL', f_InRecord.GetStringValue('SYMBOL'));
              f_OutRecord.SetIntegerValue('ORDER_COMMAND', f_InRecord.GetIntegerValue('ORDER_COMMAND'));
              f_OutRecord.SetIntegerValue('ORDER_VOLUME', f_InRecord.GetIntegerValue('ORDER_VOLUME'));
              f_OutRecord.SetDoubleValue('ORDER_PRICE', f_InRecord.GetDoubleValue('ORDER_PRICE'));
              f_OutRecord.SetStringValue('PRICETYPE', f_InRecord.GetStringValue('PRICETYPE'));
              f_OutRecord.SetIntegerValue('CONDITION', f_InRecord.GetIntegerValue('CONDITION'));

              f_OutRecord.SetStringValue('ORDER_NO', '');
              f_OutRecord.SetStringValue('ORG_ORDER_NO', f_InRecord.GetStringValue('ORG_ORDER_NO'));

              f_OutDataSet.RecordList.Add(f_OutRecord);

              WriteMessage(p_QueryData, 'I10003', '취소주문에 오류가 발생했습니다.');

              if p_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
              begin
                WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
              end;

              StoreRecvData(p_QueryData);
            end;
          end
          else
          begin
            Inc(m_RQIndex);
            if (m_RQIndex > 10240) then
              m_RQIndex := 0;

            p_QueryData.m_RequestID := IntToStr(m_RQIndex);
            p_QueryData.m_DateTime := Now;

            p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
            p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);

            Make_SC_ORDER_TR_0210_OUT(p_QueryData.m_Response);
            f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
            f_OutRecord := CFNRecord.Create;

            f_OutRecord.SetIntegerValue('COLLECTION_TYPE', f_InRecord.GetIntegerValue('COLLECTION_TYPE'));
            f_OutRecord.SetIntegerValue('SIGNAL_SEQ', f_InRecord.GetIntegerValue('SIGNAL_SEQ'));
            f_OutRecord.SetIntegerValue('ORDER_SEQ', f_InRecord.GetIntegerValue('ORDER_SEQ'));
            f_OutRecord.SetStringValue('USERID', f_InRecord.GetStringValue('USERID'));

            f_OutRecord.SetStringValue('ACCOUNT_NO', f_InRecord.GetStringValue('ACCOUNT_NO'));
            f_OutRecord.SetStringValue('SYMBOL', f_InRecord.GetStringValue('SYMBOL'));
            f_OutRecord.SetIntegerValue('ORDER_COMMAND', f_InRecord.GetIntegerValue('ORDER_COMMAND'));
            f_OutRecord.SetIntegerValue('ORDER_VOLUME', f_InRecord.GetIntegerValue('ORDER_VOLUME'));
            f_OutRecord.SetDoubleValue('ORDER_PRICE', f_InRecord.GetDoubleValue('ORDER_PRICE'));
            f_OutRecord.SetStringValue('PRICETYPE', f_InRecord.GetStringValue('PRICETYPE'));
            f_OutRecord.SetIntegerValue('CONDITION', f_InRecord.GetIntegerValue('CONDITION'));

            f_OutRecord.SetStringValue('ORDER_NO', '');
            f_OutRecord.SetStringValue('ORG_ORDER_NO', f_InRecord.GetStringValue('ORG_ORDER_NO'));

            f_OutDataSet.RecordList.Add(f_OutRecord);

            WriteMessage(p_QueryData, 'I10003', '취소주문에 오류가 발생했습니다.');

            if p_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
            begin
              WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
            end;

            StoreRecvData(p_QueryData);

          end;
        end
        else
{$ENDREGION}
{$REGION '수정주문'}
          if (3 = f_OrderCommand) then
          begin
            if (not f_OrderError) then
            begin
              f_FindOrderData := NIL;

              for f_Index := 0 to m_OrderItems.Count - 1 do
              begin
                f_OrderData := CFNOrderData(m_OrderItems.Items[f_Index]);
                if Assigned(f_OrderData) and (f_OrderData.ORDER_NO = f_OrgOrderNo) then
                begin
                  f_FindOrderData := f_OrderData;
                  break;
                end;
              end;

              if Assigned(f_FindOrderData) then
              begin

                // 이미 체결된 주문... 오류를 반환
                // (*
                if (f_FindOrderData.STEP = 4) or (f_FindOrderData.STEP = 14) or (f_FindOrderData.STEP = 23) then
                begin
                  Inc(m_RQIndex);
                  if (m_RQIndex > 10240) then
                    m_RQIndex := 0;

                  p_QueryData.m_RequestID := IntToStr(m_RQIndex);
                  p_QueryData.m_DateTime := Now;

                  p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
                  p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);

                  Make_SC_ORDER_TR_0210_OUT(p_QueryData.m_Response);
                  f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
                  f_OutRecord := CFNRecord.Create;

                  f_OutRecord.SetIntegerValue('COLLECTION_TYPE', f_InRecord.GetIntegerValue('COLLECTION_TYPE'));
                  f_OutRecord.SetIntegerValue('SIGNAL_SEQ', f_FindOrderData.SIGNAL_SEQ);
                  f_OutRecord.SetIntegerValue('ORDER_SEQ', f_FindOrderData.ORDER_SEQ);
                  f_OutRecord.SetStringValue('USERID', f_FindOrderData.USERID);
                  f_OutRecord.SetStringValue('ACCOUNT_NO', f_InRecord.GetStringValue('ACCOUNT_NO'));
                  f_OutRecord.SetStringValue('SYMBOL', f_InRecord.GetStringValue('SYMBOL'));
                  f_OutRecord.SetIntegerValue('ORDER_COMMAND', f_InRecord.GetIntegerValue('ORDER_COMMAND'));
                  f_OutRecord.SetIntegerValue('ORDER_VOLUME', f_InRecord.GetIntegerValue('ORDER_VOLUME'));
                  f_OutRecord.SetDoubleValue('ORDER_PRICE', f_InRecord.GetDoubleValue('ORDER_PRICE'));
                  f_OutRecord.SetStringValue('PRICETYPE', f_InRecord.GetStringValue('PRICETYPE'));
                  f_OutRecord.SetIntegerValue('CONDITION', f_InRecord.GetIntegerValue('CONDITION'));
                  f_OutRecord.SetStringValue('ORDER_NO', f_InRecord.GetStringValue('ORDER_NO'));
                  f_OutRecord.SetStringValue('ORG_ORDER_NO', f_InRecord.GetStringValue('ORG_ORDER_NO'));

                  f_OutDataSet.RecordList.Add(f_OutRecord);

                  WriteMessage(p_QueryData, 'I10001', '이미 체결이 완료되었습니다.');

                  if p_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
                  begin
                    WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
                  end;
                  StoreRecvData(p_QueryData);

                end
                else
                begin
                  Inc(m_RQIndex);
                  if (m_RQIndex > 10240) then
                    m_RQIndex := 0;

                  f_FindOrderData.STEP := 10;
                  f_FindOrderData.SIGNAL_SEQ := f_InRecord.GetIntegerValue('SIGNAL_SEQ');
                  f_FindOrderData.ORDER_SEQ := f_InRecord.GetIntegerValue('ORDER_SEQ');
                  f_FindOrderData.ORDER_VOLUME := f_InRecord.GetIntegerValue('ORDER_VOLUME');
                  f_FindOrderData.ORDER_PRICE := f_InRecord.GetDoubleValue('ORDER_PRICE');
                  f_FindOrderData.CURRENT_PRICE := f_InRecord.GetDoubleValue('CURRENT_PRICE');
                  f_FindOrderData.PRICETYPE := f_InRecord.GetStringValue('PRICETYPE');
                  f_FindOrderData.CONDITION := f_InRecord.GetIntegerValue('CONDITION');
                  f_FindOrderData.ORG_ORDER_NO := f_InRecord.GetStringValue('ORG_ORDER_NO');
                  f_FindOrderData.ORDER_NO := '';
                  f_FindOrderData.TRADE_VOLUME := 0;
                  f_FindOrderData.TRADE_PRICE := 0;
                  f_FindOrderData.CREATETIME := Now;
                  f_FindOrderData.CONFIRMTIME := 0;
                  f_FindOrderData.DELAYSECOUND := f_DelayTime;

                  p_QueryData.m_RequestID := IntToStr(m_RQIndex);
                  p_QueryData.m_DateTime := Now;

                  p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
                  p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);

                  f_FindOrderData.STEP := 11;
                  Inc(m_OrderNo);
                  f_FindOrderData.ORDER_NO := IntToStr(m_OrderNo);

                  Make_SC_ORDER_TR_0210_OUT(p_QueryData.m_Response);
                  f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
                  f_OutRecord := CFNRecord.Create;

                  f_OutRecord.SetIntegerValue('COLLECTION_TYPE', f_InRecord.GetIntegerValue('COLLECTION_TYPE'));
                  f_OutRecord.SetIntegerValue('SIGNAL_SEQ', f_FindOrderData.SIGNAL_SEQ);
                  f_OutRecord.SetIntegerValue('ORDER_SEQ', f_FindOrderData.ORDER_SEQ);
                  f_OutRecord.SetStringValue('USERID', f_FindOrderData.USERID);
                  f_OutRecord.SetStringValue('ACCOUNT_NO', f_InRecord.GetStringValue('ACCOUNT_NO'));
                  f_OutRecord.SetStringValue('SYMBOL', f_InRecord.GetStringValue('SYMBOL'));
                  f_OutRecord.SetIntegerValue('ORDER_COMMAND', f_InRecord.GetIntegerValue('ORDER_COMMAND'));
                  f_OutRecord.SetIntegerValue('ORDER_VOLUME', f_InRecord.GetIntegerValue('ORDER_VOLUME'));
                  f_OutRecord.SetDoubleValue('ORDER_PRICE', f_InRecord.GetDoubleValue('ORDER_PRICE'));
                  f_OutRecord.SetStringValue('PRICETYPE', f_InRecord.GetStringValue('PRICETYPE'));
                  f_OutRecord.SetIntegerValue('CONDITION', f_InRecord.GetIntegerValue('CONDITION'));
                  f_OutRecord.SetStringValue('ORDER_NO', f_FindOrderData.ORDER_NO);
                  f_OutRecord.SetStringValue('ORG_ORDER_NO', f_FindOrderData.ORG_ORDER_NO);

                  f_OutDataSet.RecordList.Add(f_OutRecord);

                  WriteMessage(p_QueryData, 'M00000', '정상 처리되었습니다.');

                  if p_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
                  begin
                    WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
                  end;
                  StoreRecvData(p_QueryData);
                end;
                // *)
                (*
                  Inc(m_RQIndex );
                  if (m_RQIndex > 10240) then m_RQIndex := 0;

                  f_FindOrderData := CFNOrderData.Create;
                  f_FindOrderData.STEP            := 10;
                  f_FindOrderData.RQINDEX         := m_RQIndex;
                  f_FindOrderData.SIGNAL_SEQ      := f_InRecord.GetIntegerValue('SIGNAL_SEQ');
                  f_FindOrderData.ORDER_SEQ       := f_InRecord.GetIntegerValue('ORDER_SEQ');
                  f_FindOrderData.USERID          := f_InRecord.GetStringValue('USERID');
                  f_FindOrderData.ACCOUNT_NO      := f_InRecord.GetStringValue('ACCOUNT_NO');
                  f_FindOrderData.PASSWORD        := f_InRecord.GetStringValue('PASSWORD');
                  f_FindOrderData.SYMBOL          := f_InRecord.GetStringValue('SYMBOL');
                  f_FindOrderData.ORDER_COMMAND   := f_InRecord.GetIntegerValue('ORDER_COMMAND');
                  f_FindOrderData.ORDER_VOLUME    := f_InRecord.GetIntegerValue('ORDER_VOLUME');
                  f_FindOrderData.ORDER_PRICE     := f_InRecord.GetDoubleValue('ORDER_PRICE');
                  f_FindOrderData.CURRENT_PRICE   := f_InRecord.GetDoubleValue('CURRENT_PRICE');
                  f_FindOrderData.PRICETYPE       := f_InRecord.GetStringValue('PRICETYPE');
                  f_FindOrderData.CONDITION       := f_InRecord.GetIntegerValue('CONDITION');
                  f_FindOrderData.ORG_ORDER_NO    := f_InRecord.GetStringValue('ORG_ORDER_NO');
                  f_FindOrderData.ORDER_NO        := '';
                  f_FindOrderData.TRADE_VOLUME    := 0;
                  f_FindOrderData.TRADE_PRICE     := 0;
                  f_FindOrderData.CREATETIME      := Now;
                  f_FindOrderData.CONFIRMTIME     := 0;
                  f_FindOrderData.DELAYSECOUND    := f_DelayTime;

                  p_QueryData.m_RequestID := IntToStr(m_RQIndex);
                  p_QueryData.m_DateTime := Now;

                  p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
                  p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);

                  f_FindOrderData.STEP := 11;
                  Inc(m_OrderNo);
                  f_FindOrderData.ORDER_NO := IntToStr(m_OrderNo);

                  Make_SC_ORDER_TR_0210_OUT(p_QueryData.m_Response);
                  f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
                  f_OutRecord := CFNRecord.Create;

                  f_OutRecord.SetIntegerValue('COLLECTION_TYPE'   , f_InRecord.GetIntegerValue('COLLECTION_TYPE'));
                  f_OutRecord.SetIntegerValue('SIGNAL_SEQ'     , f_FindOrderData.SIGNAL_SEQ);
                  f_OutRecord.SetIntegerValue('ORDER_SEQ'      , f_FindOrderData.ORDER_SEQ);
                  f_OutRecord.SetStringValue('USERID'          , f_FindOrderData.USERID);
                  f_OutRecord.SetStringValue('ACCOUNT_NO'      , f_InRecord.GetStringValue('ACCOUNT_NO'));
                  f_OutRecord.SetStringValue('SYMBOL'          , f_InRecord.GetStringValue('SYMBOL'));
                  f_OutRecord.SetIntegerValue('ORDER_COMMAND'  , f_InRecord.GetIntegerValue('ORDER_COMMAND'));
                  f_OutRecord.SetIntegerValue('ORDER_VOLUME'   , f_InRecord.GetIntegerValue('ORDER_VOLUME'));
                  f_OutRecord.SetDoubleValue('ORDER_PRICE'     , f_InRecord.GetDoubleValue('ORDER_PRICE'));
                  f_OutRecord.SetStringValue('PRICETYPE'       , f_InRecord.GetStringValue('PRICETYPE'));
                  f_OutRecord.SetIntegerValue('CONDITION'      , f_InRecord.GetIntegerValue('CONDITION'));
                  f_OutRecord.SetStringValue('ORDER_NO'        , f_FindOrderData.ORDER_NO);
                  f_OutRecord.SetStringValue('ORG_ORDER_NO'    , f_FindOrderData.ORG_ORDER_NO);

                  f_OutDataSet.RecordList.Add(f_OutRecord);

                  WriteMessage(p_QueryData, 'M00000', '정상 처리되었습니다.');

                  if p_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
                  begin
                  WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
                  end;
                  StoreRecvData(p_QueryData);
                  m_OrderItems.Add(f_FindOrderData)
                *)
              end
              else
              begin

                Inc(m_RQIndex);
                if (m_RQIndex > 10240) then
                  m_RQIndex := 0;

                p_QueryData.m_RequestID := IntToStr(m_RQIndex);
                p_QueryData.m_DateTime := Now;

                p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
                p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);

                Make_SC_ORDER_TR_0210_OUT(p_QueryData.m_Response);
                f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
                f_OutRecord := CFNRecord.Create;

                f_OutRecord.SetIntegerValue('COLLECTION_TYPE', f_InRecord.GetIntegerValue('COLLECTION_TYPE'));
                f_OutRecord.SetIntegerValue('SIGNAL_SEQ', f_InRecord.GetIntegerValue('SIGNAL_SEQ'));
                f_OutRecord.SetIntegerValue('ORDER_SEQ', f_InRecord.GetIntegerValue('ORDER_SEQ'));
                f_OutRecord.SetStringValue('USERID', f_InRecord.GetStringValue('USERID'));

                f_OutRecord.SetStringValue('ACCOUNT_NO', f_InRecord.GetStringValue('ACCOUNT_NO'));
                f_OutRecord.SetStringValue('SYMBOL', f_InRecord.GetStringValue('SYMBOL'));
                f_OutRecord.SetIntegerValue('ORDER_COMMAND', f_InRecord.GetIntegerValue('ORDER_COMMAND'));
                f_OutRecord.SetIntegerValue('ORDER_VOLUME', f_InRecord.GetIntegerValue('ORDER_VOLUME'));
                f_OutRecord.SetDoubleValue('ORDER_PRICE', f_InRecord.GetDoubleValue('ORDER_PRICE'));
                f_OutRecord.SetStringValue('PRICETYPE', f_InRecord.GetStringValue('PRICETYPE'));
                f_OutRecord.SetIntegerValue('CONDITION', f_InRecord.GetIntegerValue('CONDITION'));

                f_OutRecord.SetStringValue('ORDER_NO', '');
                f_OutRecord.SetStringValue('ORG_ORDER_NO', f_InRecord.GetStringValue('ORG_ORDER_NO'));

                f_OutDataSet.RecordList.Add(f_OutRecord);

                WriteMessage(p_QueryData, 'I10003', '수정주문에 오류가 발생했습니다.');

                if p_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
                begin
                  WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
                end;

                StoreRecvData(p_QueryData);
              end;
            end
            else
            begin
              Inc(m_RQIndex);
              if (m_RQIndex > 10240) then
                m_RQIndex := 0;

              p_QueryData.m_RequestID := IntToStr(m_RQIndex);
              p_QueryData.m_DateTime := Now;

              p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
              p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);

              Make_SC_ORDER_TR_0210_OUT(p_QueryData.m_Response);
              f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
              f_OutRecord := CFNRecord.Create;

              f_OutRecord.SetIntegerValue('COLLECTION_TYPE', f_InRecord.GetIntegerValue('COLLECTION_TYPE'));
              f_OutRecord.SetIntegerValue('SIGNAL_SEQ', f_InRecord.GetIntegerValue('SIGNAL_SEQ'));
              f_OutRecord.SetIntegerValue('ORDER_SEQ', f_InRecord.GetIntegerValue('ORDER_SEQ'));
              f_OutRecord.SetStringValue('USERID', f_InRecord.GetStringValue('USERID'));

              f_OutRecord.SetStringValue('ACCOUNT_NO', f_InRecord.GetStringValue('ACCOUNT_NO'));
              f_OutRecord.SetStringValue('SYMBOL', f_InRecord.GetStringValue('SYMBOL'));
              f_OutRecord.SetIntegerValue('ORDER_COMMAND', f_InRecord.GetIntegerValue('ORDER_COMMAND'));
              f_OutRecord.SetIntegerValue('ORDER_VOLUME', f_InRecord.GetIntegerValue('ORDER_VOLUME'));
              f_OutRecord.SetDoubleValue('ORDER_PRICE', f_InRecord.GetDoubleValue('ORDER_PRICE'));
              f_OutRecord.SetStringValue('PRICETYPE', f_InRecord.GetStringValue('PRICETYPE'));
              f_OutRecord.SetIntegerValue('CONDITION', f_InRecord.GetIntegerValue('CONDITION'));

              f_OutRecord.SetStringValue('ORDER_NO', '');
              f_OutRecord.SetStringValue('ORG_ORDER_NO', f_InRecord.GetStringValue('ORG_ORDER_NO'));

              f_OutDataSet.RecordList.Add(f_OutRecord);

              WriteMessage(p_QueryData, 'I10003', '수정주문에 오류가 발생했습니다.');

              if p_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
              begin
                WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
              end;

              StoreRecvData(p_QueryData);

            end;
          end
          else
{$ENDREGION}
{$REGION '신규주문'}
          begin
            if (not f_OrderError) then
            begin
              Inc(m_RQIndex);
              if (m_RQIndex > 10240) then
                m_RQIndex := 0;

              f_OrderData := CFNOrderData.Create;
              f_OrderData.STEP := 0;
              f_OrderData.RQINDEX := m_RQIndex;
              f_OrderData.SIGNAL_SEQ := f_InRecord.GetIntegerValue('SIGNAL_SEQ');
              f_OrderData.ORDER_SEQ := f_InRecord.GetIntegerValue('ORDER_SEQ');
              f_OrderData.USERID := f_InRecord.GetStringValue('USERID');
              f_OrderData.ACCOUNT_NO := f_InRecord.GetStringValue('ACCOUNT_NO');
              f_OrderData.PASSWORD := f_InRecord.GetStringValue('PASSWORD');
              f_OrderData.SYMBOL := f_InRecord.GetStringValue('SYMBOL');
              f_OrderData.ORDER_COMMAND := f_InRecord.GetIntegerValue('ORDER_COMMAND');
              f_OrderData.ORDER_VOLUME := f_InRecord.GetIntegerValue('ORDER_VOLUME');
              f_OrderData.ORDER_PRICE := f_InRecord.GetDoubleValue('ORDER_PRICE');
              f_OrderData.CURRENT_PRICE := f_InRecord.GetDoubleValue('CURRENT_PRICE');
              f_OrderData.PRICETYPE := f_InRecord.GetStringValue('PRICETYPE');
              f_OrderData.CONDITION := f_InRecord.GetIntegerValue('CONDITION');
              f_OrderData.ORG_ORDER_NO := f_InRecord.GetStringValue('ORG_ORDER_NO');
              f_OrderData.ORDER_NO := '';
              f_OrderData.TRADE_VOLUME := 0;
              f_OrderData.TRADE_PRICE := 0;
              f_OrderData.CREATETIME := Now;
              f_OrderData.CONFIRMTIME := 0;
              f_OrderData.DELAYSECOUND := f_DelayTime;

              p_QueryData.m_RequestID := IntToStr(m_RQIndex);
              p_QueryData.m_DateTime := Now;

              p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
              p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);

              f_OrderData.STEP := 1;
              Inc(m_OrderNo);
              f_OrderData.ORDER_NO := IntToStr(m_OrderNo);

              Make_SC_ORDER_TR_0210_OUT(p_QueryData.m_Response);
              f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
              f_OutRecord := CFNRecord.Create;

              f_OutRecord.SetIntegerValue('COLLECTION_TYPE', f_InRecord.GetIntegerValue('COLLECTION_TYPE'));
              f_OutRecord.SetIntegerValue('SIGNAL_SEQ', f_OrderData.SIGNAL_SEQ);
              f_OutRecord.SetIntegerValue('ORDER_SEQ', f_OrderData.ORDER_SEQ);
              f_OutRecord.SetStringValue('USERID', f_OrderData.USERID);
              f_OutRecord.SetStringValue('ACCOUNT_NO', f_OrderData.ACCOUNT_NO);
              f_OutRecord.SetStringValue('SYMBOL', f_OrderData.SYMBOL);
              f_OutRecord.SetIntegerValue('ORDER_COMMAND', f_OrderData.ORDER_COMMAND);
              f_OutRecord.SetIntegerValue('ORDER_VOLUME', f_OrderData.ORDER_VOLUME);
              f_OutRecord.SetDoubleValue('ORDER_PRICE', f_OrderData.ORDER_PRICE);
              f_OutRecord.SetStringValue('PRICETYPE', f_OrderData.PRICETYPE);
              f_OutRecord.SetIntegerValue('CONDITION', f_OrderData.CONDITION);
              f_OutRecord.SetStringValue('ORDER_NO', f_OrderData.ORDER_NO);
              f_OutRecord.SetStringValue('ORG_ORDER_NO', f_OrderData.ORG_ORDER_NO);

              f_OutDataSet.RecordList.Add(f_OutRecord);

              WriteMessage(p_QueryData, 'M00000', '정상 처리되었습니다.');

              if p_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
              begin
                WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
              end;

              StoreRecvData(p_QueryData);
              m_OrderItems.Add(f_OrderData)

            end
            else
            begin
              Inc(m_RQIndex);
              if (m_RQIndex > 10240) then
                m_RQIndex := 0;

              p_QueryData.m_RequestID := IntToStr(m_RQIndex);
              p_QueryData.m_DateTime := Now;

              p_QueryData.m_Request.SetRequestID(p_QueryData.m_RequestID);
              p_QueryData.m_Response.SetRequestID(p_QueryData.m_RequestID);

              Make_SC_ORDER_TR_0210_OUT(p_QueryData.m_Response);
              f_OutDataSet := p_QueryData.m_Response.GetDataSet(DATASETID_OUT_01);
              f_OutRecord := CFNRecord.Create;

              f_OutRecord.SetIntegerValue('COLLECTION_TYPE', f_InRecord.GetIntegerValue('COLLECTION_TYPE'));
              f_OutRecord.SetIntegerValue('SIGNAL_SEQ', f_InRecord.GetIntegerValue('SIGNAL_SEQ'));
              f_OutRecord.SetIntegerValue('ORDER_SEQ', f_InRecord.GetIntegerValue('ORDER_SEQ'));
              f_OutRecord.SetStringValue('USERID', f_InRecord.GetStringValue('USERID'));

              f_OutRecord.SetStringValue('ACCOUNT_NO', f_InRecord.GetStringValue('ACCOUNT_NO'));
              f_OutRecord.SetStringValue('SYMBOL', f_InRecord.GetStringValue('SYMBOL'));
              f_OutRecord.SetIntegerValue('ORDER_COMMAND', f_InRecord.GetIntegerValue('ORDER_COMMAND'));
              f_OutRecord.SetIntegerValue('ORDER_VOLUME', f_InRecord.GetIntegerValue('ORDER_VOLUME'));
              f_OutRecord.SetDoubleValue('ORDER_PRICE', f_InRecord.GetDoubleValue('ORDER_PRICE'));
              f_OutRecord.SetStringValue('PRICETYPE', f_InRecord.GetStringValue('PRICETYPE'));
              f_OutRecord.SetIntegerValue('CONDITION', f_InRecord.GetIntegerValue('CONDITION'));

              f_OutRecord.SetStringValue('ORDER_NO', '');
              f_OutRecord.SetStringValue('ORG_ORDER_NO', f_InRecord.GetStringValue('ORG_ORDER_NO'));

              f_OutDataSet.RecordList.Add(f_OutRecord);

              WriteMessage(p_QueryData, 'I10002', '잔고가 부족합니다.');

              if p_QueryData.m_Response.m_ErrorDataSet.RecordList.Count > 0 then
              begin
                WriteMessage(p_QueryData, 'M99999', '비정상 처리되었습니다.');
              end;

              StoreRecvData(p_QueryData);

            end;
          end;
{$ENDREGION}
        p_QueryData := NIL;
      end
      else
      begin
        WriteMessage(p_QueryData, 'M99999', '오류가 발생했습니다.');
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
    m_DataLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
{ CFNOrderData }

constructor CFNOrderData.Create;
begin

end;

destructor CFNOrderData.Destroy;
begin

  inherited;
end;

end.
