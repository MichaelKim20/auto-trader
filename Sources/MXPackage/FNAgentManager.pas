// **************************************************************************//
// FileName        :   FNAgentManager.pas
// Author          :   김무근 작성
// Date            :   2012년 7월 10일
// Description     :   증권사 API를 통해, 시세와 주문을 구현하기 위한 기초 클래스
// **************************************************************************//
Unit FNAgentManager;

interface

uses
  Dialogs, WinProcs, SysUtils, Forms, ActiveX, WinTypes, Classes,
  SyncObjs, Contnrs, IniFiles,
  FNDataObject, FNMultiMap, FNThread, FNQueue, FNDataSet, FNDataDelivery;

const
  AGENT_THREAD_STOP = 0;

const
  AGENT_THREAD_START = 1;

const
  MAX_MAPCOUNT = 3;

const
  MAP_CURRENT = 0;

const
  MAP_BIDOFFER = 1;

const
  MAP_USERTRADE = 2;

type
  CFNQueryData = class(TObject)
  public
    m_ServiceID: String;
    m_TRCode: String;
    m_RequestID: String;
    m_DateTime: TDateTime;
    m_SendDateTime: TDateTime;

    m_DataDelivery: CFNDataDelivery;

    m_Request: CFNDataPackage;
    m_Response: CFNDataPackage;

    m_Dispatch: IDispatch;

    constructor Create;
    destructor Destroy; override;
  end;

  // ---------------------------------------------------------------------------
  CFNAgentManager = class;

  // ---------------------------------------------------------------------------
  CFNQueryThread = class(CFNThread)
  public
    m_Manager: CFNAgentManager;

  protected
    procedure StartWork; override;
    procedure DoWork; override;
    procedure EndWork; override;

    procedure SetManager(AManager: CFNAgentManager);
  end;

  // ---------------------------------------------------------------------------
  CFNProcThread = class(CFNThread)
  public
    m_Manager: CFNAgentManager;

  protected
    procedure StartWork; override;
    procedure DoWork; override;
    procedure EndWork; override;

    procedure SetManager(AManager: CFNAgentManager);
  end;

  // ---------------------------------------------------------------------------
  /// <author>김무근</author>
  /// <version>1.0</version>
  /// <since>2012.07.10</since>
  /// <Comment>증권 API를 이용하여 필요한 기능을 확장한 클래스</Comment>
  CFNAgentManager = class(TObject)
  public
    m_Status: Boolean;

    /// <Comment>생성자</Comment>
    Constructor Create(AQueryThreadCount: Integer = 1);

    /// <Comment>파괴자</Comment>
    Destructor Destroy; override;

    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure Resume; virtual;
    procedure Suspend; virtual;

    procedure StartQueryWork; virtual;
    procedure DoQueryWork(AThreadIndex: Integer); virtual;
    procedure EndQueryWork; virtual;

    procedure StartProcWork; virtual;
    procedure DoProcWork; virtual;
    procedure EndProcWork; virtual;

    procedure Start;
    procedure Stop;
    function GetState: Integer;

    procedure ClearAll;

    procedure SetRQTable(ARQId: String; AQueryData: CFNQueryData);
    function GetRQTable(ARQId: String): CFNQueryData;
    procedure ClearRQTable(ARQId: String);
    function FindRQTableByIDispatch(ADispatch: IDispatch): CFNQueryData;

    function Request(ADataDelivery: CFNDataDelivery; ADataPackage: CFNDataPackage): Boolean; virtual;

    /// <Comment>시세 실시간 스트리밍 데이터를 요청한다.</Comment>
    procedure SubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String); virtual;

    /// <Comment>시세 실시간 스트리밍 데이터를 해지한다.</Comment>
    procedure UnsubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String); virtual;

    /// <Comment>호가 실시간 스트리밍 데이터를 요청한다.</Comment>
    procedure SubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String); virtual;

    /// <Comment>호가 실시간 스트리밍 데이터를 해지한다.</Comment>
    procedure UnsubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String); virtual;

    /// <Comment>주문체결통보 실시간 스트리밍 데이터를 요청한다.</Comment>
    procedure SubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = ''); virtual;

    /// <Comment>주문체결통보 실시간 스트리밍 데이터를 요청한다.</Comment>
    procedure UnsubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = ''); virtual;

    /// <Comment>
    /// 해당 클래스로 등록되어 있는 스트리밍데이터를 모두 해지한다.
    /// 단위화면의 여러쓰레드가 동시해 접근할 수 있는 영역이다.
    /// 따라서 이 메소드 에서는 멤버변수와 오브젝트의 사용을 피한다.
    /// 만약 필히 접근해야 한다면 동기화를 하기 바란다.
    /// </Comment>
    procedure UnSubscribeAll(ADataDelivery: CFNDataDelivery); virtual;

    procedure Disconnect; virtual;

    procedure ReSubscribeAll; virtual;

  protected

    m_DisconnectEvent: TNotifyEvent;

  public
    property OnDisconnect: TNotifyEvent read m_DisconnectEvent write m_DisconnectEvent;

  private
    procedure CreateQueryThread(AQueryThreadCount: Integer = 1);
    procedure DestroyQueryThread;

  protected
    m_QueryThreadCollection: TList;

    m_ProcThread: CFNProcThread;

    m_RecvQueue: CFNQueue;
    m_SendQueue: CFNQueue;

    m_State: Integer;
    m_QueryTableLock: TCriticalSection;
    m_QueryTable: THashedStringList;

    /// <Comment>
    /// CFNStreamRecord는 스트리밍 데이터를 다수의 화면으로 전송하기 위해 필요하다.
    /// 그러나 리소스의 낭비와 속도를 줄이기 위해, 하나의 CFNStreamRecord 객체를 사용하기를 원한다.
    /// 하나의 객체를 사용할려면 이를 다 사용하고 메모리에서 해제시키는 방법을 찾아야 한다.
    /// 여기서는  화면의 수만큼 참조카운트를 증가시키고, 화면처리후 참조카운트를 해당화면에서 하나씩 줄인다.
    /// 이러한 객체는 물론 특별한 자료 구조에 넣어야 하는데, 그 자료 구조가 바로 ObjectList인 이것이다.
    /// 물론 주기적으로 이 자료구조에 들어 있는 해당요소의 참조카운트를 조사해서 그 참조카인트가 0인
    /// 객체를 메모리에서 제거한다.
    /// 이 작업을 하는 함수는 바로 TrucateUnusedStreamRecord 이다.
    /// </Comment>
    m_STRecordLock: TCriticalSection;
    m_STRecordList: TObjectList;

    /// <Comment>
    /// 각 화면에서 필요한 실시간데이터를 기록해 놓은 해쉬맵으로 현재는 배열로 구성되어 있고 그키는 3이다.
    /// 첫번째는 시세, 두번째는 호가, 세번째는 뉴스를 위해 예약되어 있다.
    /// 심벌의 3개의 조합으로 키를 만들어서 사용한다.
    /// </Comment>
    m_STSubscribeTable: Array [0 .. MAX_MAPCOUNT - 1] of CFNMultiMap;

    /// <Comment>
    /// m_STSubscribeTable 를 접근할 때 동기화를 한다.
    /// </Comment>
    m_STSubscribeTableLock: TCriticalSection;

    procedure StoreRecvData(p_QueryData: CFNQueryData);
    function RetrieveRecvData: CFNQueryData;

    procedure StoreSendData(p_QueryData: CFNQueryData);
    function RetrieveSendData: CFNQueryData;

    /// <Comment>
    /// 파라메터로 받은 AStreamRecord를 멤버변수인 m_STRecordList에 저장한다.
    /// </Comment>
    procedure SaveStreamRecord(AStreamRecord: CFNStreamRecord);

    /// <Comment>
    /// m_STRecordList 에 저장되어있는 CFNStreamRecord 의 오브젝트 중
    /// m_ReferenceCount의 수가 0인 것을 메모리에서 제거한다.
    /// 이 메소드는 DoProcWork()의 마지막에 호출한다.
    /// </Comment>
    procedure TrucateUnusedStreamRecord;

    /// <Comment>
    /// var f_szSource:String := "";
    /// if (ACountry > 9) f_szSource := f_szSource + "C" +IntToStr(ACountry);
    /// else f_szSource := f_szSource +  "C0" + IntToStr(p_Country);
    /// if (AGroup > 9) f_szSource := f_szSource +  "G" + IntToStr(AGroup);
    /// else f_szSource := f_szSource +  "G0" + IntToStr(AGroup);
    /// if (AMarket > 9) f_szSource := f_szSource +  "M" + IntToStr(AMarket);
    /// else f_szSource := f_szSource +  "M0" + IntToStr(AMarket);
    /// f_szSource := f_szSource +  ASymbol;
    /// C00G01M00005940
    /// return f_szSource;
    /// </Comment>
    function MakeStreamSubscribeKey(ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String): String;
    function GetStreamSubscribeKey(AKey: String; var ACountry: Integer; var AGroup: Integer; var AMarket: Integer; var ASymbol: String): Boolean;
  end;

  // ---------------------------------------------------------------------------
implementation

uses
  FNGlobal, FNGlobalVariable, WideStrUtils;

// ---------------------------------------------------------------------------
procedure CFNQueryThread.StartWork;
begin
  inherited StartWork;

  CoInitialize(NIL);

  if Assigned(m_Manager) then
  begin
    m_Manager.StartQueryWork;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNQueryThread.EndWork;
begin
  if Assigned(m_Manager) then
  begin
    m_Manager.EndQueryWork;
  end;

  CoUninitialize();
  inherited EndWork;
end;

// ---------------------------------------------------------------------------
procedure CFNQueryThread.DoWork;
var
  f_State: Integer;
begin
  if Assigned(m_Manager) then
  begin
    f_State := m_Manager.GetState;
    if AGENT_THREAD_START = f_State then
    begin
      m_Working := True;

      m_Manager.DoQueryWork(m_ThreadIndex);
    end;
  end;

  m_Working := FALSE;
end;

// ---------------------------------------------------------------------------
procedure CFNQueryThread.SetManager(AManager: CFNAgentManager);
begin
  m_Manager := AManager;
end;

// ---------------------------------------------------------------------------
procedure CFNProcThread.StartWork;
begin
  inherited StartWork;

  CoInitialize(NIL);

  if Assigned(m_Manager) then
  begin
    m_Manager.StartProcWork;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNProcThread.EndWork;
begin
  if Assigned(m_Manager) then
  begin
    m_Manager.EndProcWork;
  end;

  CoUninitialize();
  inherited EndWork;
end;

// ---------------------------------------------------------------------------
procedure CFNProcThread.DoWork;
var
  f_State: Integer;
begin
  if Assigned(m_Manager) then
  begin
    f_State := m_Manager.GetState;
    if AGENT_THREAD_START = f_State then
    begin
      m_Working := True;

      m_Manager.DoProcWork;
    end;
  end;

  m_Working := FALSE;
end;

// ---------------------------------------------------------------------------
procedure CFNProcThread.SetManager(AManager: CFNAgentManager);
begin
  m_Manager := AManager;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.CreateQueryThread(AQueryThreadCount: Integer = 1);
var
  f_QueryThread: CFNQueryThread;
  f_Index: Integer;
begin
  for f_Index := 0 to AQueryThreadCount - 1 do
  begin
    f_QueryThread := CFNQueryThread.Create;
    f_QueryThread.SetSleepTime(10);
    f_QueryThread.SetManager(Self);
    f_QueryThread.SetThreadIndex(f_Index);

    m_QueryThreadCollection.Add(f_QueryThread);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.DestroyQueryThread;
var
  f_QueryThread: CFNQueryThread;
  f_Index: Integer;
  nTry: Integer;
begin
  for f_Index := 0 to m_QueryThreadCollection.Count - 1 do
  begin
    f_QueryThread := m_QueryThreadCollection.Items[f_Index];

    if Assigned(f_QueryThread) then
    begin
      f_QueryThread.StopThread;
    end;

    nTry := 0;
    while Assigned(f_QueryThread) do
    begin
      if (not f_QueryThread.Finished) then
      begin
        f_QueryThread.StopThread;
        Inc(nTry);
        if (nTry > 20) then
        begin
          f_QueryThread.ExitThread;
          f_QueryThread.Free;
          break;
        end;
      end
      else
      begin
        f_QueryThread.Free;
        break;
      end;
      Sleep(10);
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.Disconnect;
begin

end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.ReSubscribeAll;
begin

end;

// ---------------------------------------------------------------------------
Constructor CFNAgentManager.Create(AQueryThreadCount: Integer = 1);
var
  f_QueryThreadCount: Integer;
begin
  inherited Create;

  f_QueryThreadCount := AQueryThreadCount;
  if f_QueryThreadCount < 1 then
    f_QueryThreadCount := 1;

  Initialize;

{$REGION 'CFNQueryThread을 생성한다'}
  CreateQueryThread(f_QueryThreadCount);
{$ENDREGION}
{$REGION 'CFNProcThread을 생성한다'}
  m_ProcThread := CFNProcThread.Create;
  m_ProcThread.SetSleepTime(10);
  m_ProcThread.SetManager(Self);
{$ENDREGION}
end;

// ---------------------------------------------------------------------------
Destructor CFNAgentManager.Destroy;
var
  nTry: Integer;
begin
  Stop;

{$REGION 'CFNQueryThread을 제거한다'}
  DestroyQueryThread;
{$ENDREGION}
{$REGION 'CFNProcThread을 제거한다'}
  if Assigned(m_ProcThread) then
  begin
    m_ProcThread.StopThread;
  end;

  nTry := 0;
  while Assigned(m_ProcThread) do
  begin
    if (not m_ProcThread.Finished) then
    begin
      m_ProcThread.StopThread;
      Inc(nTry);
      if (nTry > 20) then
      begin
        m_ProcThread.ExitThread;
        m_ProcThread.Free;
        m_ProcThread := NIL;
        break;
      end;
    end
    else
    begin
      m_ProcThread.Free;
      m_ProcThread := NIL;
      break;
    end;
    Sleep(10);
  end;
{$ENDREGION}
  Finalize;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.Initialize;
begin
  m_QueryThreadCollection := TList.Create;

  m_RecvQueue := CFNQueue.Create;
  m_SendQueue := CFNQueue.Create;

  m_QueryTableLock := TCriticalSection.Create;

  m_QueryTable := THashedStringList.Create;

  m_STSubscribeTable[0] := CFNMultiMap.Create; // 시세
  m_STSubscribeTable[0].SetAutoFree(FALSE);

  m_STSubscribeTable[1] := CFNMultiMap.Create; // 호가
  m_STSubscribeTable[1].SetAutoFree(FALSE);

  m_STSubscribeTable[2] := CFNMultiMap.Create; // 주문,체결통보
  m_STSubscribeTable[2].SetAutoFree(FALSE);

  m_STRecordLock := TCriticalSection.Create;
  m_STRecordList := TObjectList.Create;

  m_STSubscribeTableLock := TCriticalSection.Create;

  m_State := AGENT_THREAD_STOP;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.Finalize;
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

  if (m_QueryThreadCollection <> NIL) then
    m_QueryThreadCollection.Free;
  m_QueryThreadCollection := NIL;

  m_State := AGENT_THREAD_STOP;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.Resume;
var
  f_QueryThread: CFNQueryThread;
  f_Index: Integer;
begin
  for f_Index := 0 to m_QueryThreadCollection.Count - 1 do
  begin
    f_QueryThread := m_QueryThreadCollection.Items[f_Index];
    if Assigned(f_QueryThread) then
      f_QueryThread.Resume;
  end;
  if Assigned(m_ProcThread) then
    m_ProcThread.Resume;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.Suspend;
var
  f_QueryThread: CFNQueryThread;
  f_Index: Integer;
begin
  for f_Index := 0 to m_QueryThreadCollection.Count - 1 do
  begin
    f_QueryThread := m_QueryThreadCollection.Items[f_Index];
    if Assigned(f_QueryThread) then
      f_QueryThread.Suspend;
  end;
  if not m_ProcThread.Suspended then
    m_ProcThread.Suspend;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.SubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String);
begin
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.SubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String);
begin
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.SubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = '');
begin
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.UnsubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String);
begin
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.UnsubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String);
begin
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.UnsubscribeUserTrade(ADataDelivery: CFNDataDelivery; AUserID: String; AAccountNO: String = ''; AAccountPW: String = '');
begin
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.UnSubscribeAll(ADataDelivery: CFNDataDelivery);
var
  list: THashedStringList;
  objList: TObjectList;
  nIdx: Integer;
  strKey: string;

  nCountry: Integer;
  nGroup: Integer;
  nMarket: Integer;
  strSymbol: string;
begin

  m_STSubscribeTableLock.Enter;
  try
    try
      // 시세
      list := m_STSubscribeTable[MAP_CURRENT].GetValue(ADataDelivery);
      if Assigned(list) then
      begin
        while 0 < list.Count do
        begin
          objList := TObjectList(list.Objects[0]);
          if Assigned(objList) then
          begin
            nIdx := list.IndexOfObject(objList);
            if 0 <= nIdx then
            begin
              strKey := list.Strings[nIdx];
              GetStreamSubscribeKey(strKey, nCountry, nGroup, nMarket, strSymbol);

              if (1 = objList.Count) then
              begin
                UnsubscribeQuote(ADataDelivery, nCountry, nGroup, nMarket, strSymbol);
              end
              else
              begin
                m_STSubscribeTable[MAP_CURRENT].DeleteKeyValue(strKey, ADataDelivery)
              end;
            end;
          end;

          list.Delete(0);
        end;

        list.Free;
      end;
    except
      // LOG_ERROR(['CFNSocketManager.UnSubscribeAll - 시세 ']);
    end;

    try
      // 호가
      list := m_STSubscribeTable[MAP_BIDOFFER].GetValue(ADataDelivery);
      if Assigned(list) then
      begin
        while 0 < list.Count do
        begin
          objList := TObjectList(list.Objects[0]);
          if Assigned(objList) then
          begin
            nIdx := list.IndexOfObject(objList);
            if 0 <= nIdx then
            begin
              strKey := list.Strings[nIdx];
              GetStreamSubscribeKey(strKey, nCountry, nGroup, nMarket, strSymbol);

              if (1 = objList.Count) then
              begin
                UnsubscribeBidOffer(ADataDelivery, nCountry, nGroup, nMarket, strSymbol);
              end
              else
              begin
                m_STSubscribeTable[MAP_BIDOFFER].DeleteKeyValue(strKey, ADataDelivery)
              end;
            end;
          end;

          list.Delete(0);
        end;

        list.Free;
      end;
    except
      // LOG_ERROR(['CFNSocketManager.UnSubscribeAll - 호가 ']);
    end;

    try
      // 주문,체결통보
      list := m_STSubscribeTable[MAP_USERTRADE].GetValue(ADataDelivery);
      if Assigned(list) then
      begin
        while 0 < list.Count do
        begin
          objList := TObjectList(list.Objects[0]);
          if Assigned(objList) then
          begin
            nIdx := list.IndexOfObject(objList);
            if 0 <= nIdx then
            begin
              strKey := list.Strings[nIdx];

              if (1 = objList.Count) then
              begin
                UnsubscribeUserTrade(ADataDelivery, strKey);
              end
              else
              begin
                m_STSubscribeTable[MAP_USERTRADE].DeleteKeyValue(strKey, ADataDelivery)
              end;
            end;
          end;

          list.Delete(0);
        end;

        list.Free;
      end;
    except
      // LOG_ERROR(['CFNSocketManager.UnSubscribeAll - 주문체결통보 ']);
    end;

  finally
    m_STSubscribeTableLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.StartQueryWork;
begin

end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.DoQueryWork(AThreadIndex: Integer);
var
  f_QueryData: CFNQueryData;
begin
  f_QueryData := RetrieveSendData;
  if not Assigned(f_QueryData) then
    exit;

  f_QueryData.Free;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.EndQueryWork;
begin

end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.StartProcWork;
begin

end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.DoProcWork;
var
  f_QueryData: CFNQueryData;
  f_List: TList;
  f_Index: Integer;
begin
  f_List := TList.Create;
  m_RecvQueue.ManyRetrieve(f_List, m_RecvQueue.GetCount);
  for f_Index := 0 to f_List.Count - 1 do
  begin
    f_QueryData := CFNQueryData(f_List.Items[f_Index]);
    if Assigned(f_QueryData) then
    begin
      try
        f_QueryData.m_DataDelivery.DeliveryReply(f_QueryData.m_Response);
        f_QueryData.m_Response := NIL;
      finally
        f_QueryData.Free;
      end;
    end;

  end;
  f_List.Free;

  TrucateUnusedStreamRecord;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.EndProcWork;
begin

end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.Start;
begin
  m_State := AGENT_THREAD_START;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.Stop;
begin
  m_State := AGENT_THREAD_STOP;
end;

// ---------------------------------------------------------------------------
function CFNAgentManager.GetState: Integer;
begin
  Result := m_State;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.ClearAll;
var
  f_QueryData: CFNQueryData;
begin
  while 0 < m_RecvQueue.GetCount do
  begin
    f_QueryData := CFNQueryData(m_RecvQueue.Retrieve);
    if Assigned(f_QueryData) then
    begin
      f_QueryData.Free;
    end;
  end;

  while 0 < m_SendQueue.GetCount do
  begin
    f_QueryData := CFNQueryData(m_SendQueue.Retrieve);
    if Assigned(f_QueryData) then
    begin
      f_QueryData.Free;
    end;
  end;

end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.SetRQTable(ARQId: String; AQueryData: CFNQueryData);
begin
  m_QueryTableLock.Enter;
  try
    m_QueryTable.AddObject(ARQId, AQueryData);
  finally
    m_QueryTableLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
function CFNAgentManager.GetRQTable(ARQId: String): CFNQueryData;
var
  f_Index: Integer;
  f_QueryData: CFNQueryData;
begin
  f_QueryData := NIL;
  m_QueryTableLock.Enter;
  try
    f_Index := m_QueryTable.IndexOf(ARQId);
    if (f_Index >= 0) then
    begin
      f_QueryData := CFNQueryData(m_QueryTable.Objects[f_Index]);
    end;
  finally
    m_QueryTableLock.Leave;
  end;

  Result := f_QueryData;
end;

// ---------------------------------------------------------------------------
function CFNAgentManager.FindRQTableByIDispatch(ADispatch: IDispatch): CFNQueryData;
var
  f_Index: Integer;
  f_QueryData: CFNQueryData;
begin
  Result := NIL;
  m_QueryTableLock.Enter;
  try
    for f_Index := 0 to m_QueryTable.Count - 1 do
    begin
      f_QueryData := CFNQueryData(m_QueryTable.Objects[f_Index]);
      if f_QueryData.m_Dispatch = ADispatch then
      begin
        Result := f_QueryData;
        break;
      end;
    end;
  finally
    m_QueryTableLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.ClearRQTable(ARQId: String);
var
  f_Index: Integer;
begin
  m_QueryTableLock.Enter;

  try
    f_Index := m_QueryTable.IndexOf(ARQId);
    if (f_Index >= 0) then
    begin
      m_QueryTable.Delete(f_Index);
    end;
  finally
    m_QueryTableLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
function CFNAgentManager.Request(ADataDelivery: CFNDataDelivery; ADataPackage: CFNDataPackage): Boolean;
var
  f_QueryData: CFNQueryData;
begin
  Result := FALSE;

  if Assigned(ADataPackage) then
  begin
    f_QueryData := NIL;
    try
      f_QueryData := CFNQueryData.Create;
      f_QueryData.m_ServiceID := ADataPackage.GetServiceID;
      f_QueryData.m_TRCode := ADataPackage.GetTRCode;

      f_QueryData.m_DataDelivery := ADataDelivery;
      f_QueryData.m_Request.Clone(ADataPackage);

      f_QueryData.m_Response.FillHead;
      f_QueryData.m_Response.SetServiceID(f_QueryData.m_ServiceID);
      f_QueryData.m_Response.SetTRCode(f_QueryData.m_TRCode);

      StoreSendData(f_QueryData);
      f_QueryData := NIL;

      Result := True;
    finally
      if (f_QueryData <> NIL) then
        f_QueryData.Free;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.StoreRecvData(p_QueryData: CFNQueryData);
begin
  if Assigned(p_QueryData) then
  begin
    m_RecvQueue.Store(p_QueryData);
  end;
end;

// ---------------------------------------------------------------------------
function CFNAgentManager.RetrieveRecvData: CFNQueryData;
var
  f_QueryData: CFNQueryData;
begin
  f_QueryData := NIL;

  if Assigned(m_RecvQueue) then
  begin
    f_QueryData := CFNQueryData(m_RecvQueue.Retrieve);
  end;

  Result := f_QueryData;
end;

// ---------------------------------------------------------------------------
procedure CFNAgentManager.StoreSendData(p_QueryData: CFNQueryData);
begin
  if Assigned(p_QueryData) then
  begin
    m_SendQueue.Store(p_QueryData);
  end;
end;

// ---------------------------------------------------------------------------
function CFNAgentManager.RetrieveSendData: CFNQueryData;
var
  f_QueryData: CFNQueryData;
begin
  f_QueryData := NIL;

  if Assigned(m_SendQueue) then
  begin
    f_QueryData := CFNQueryData(m_SendQueue.Retrieve);
  end;

  Result := f_QueryData;
end;

// ---------------------------------------------------------------------------
// 파라메터로 받은 AStreamRecord를 멤버변수인 m_STRecordList에 저장한다.
procedure CFNAgentManager.SaveStreamRecord(AStreamRecord: CFNStreamRecord);
begin
  if Assigned(m_STRecordList) then
  begin
    m_STRecordLock.Enter;
    try
      m_STRecordList.Add(AStreamRecord);
    finally
      m_STRecordLock.Leave;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// m_STRecordList 에 저장되어있는 CFNStreamRecord 의 오브젝트 중
// m_ReferenceCount의 수가 0인 것을 메모리에서 제거한다.
// 이 메소드는 DoProcWork()의 마지막에 호출한다.
procedure CFNAgentManager.TrucateUnusedStreamRecord;
var
  objSTRecord: CFNStreamRecord;

  nRecordCnt: Integer;
  nRecordIdx: Integer;
begin
  if Assigned(m_STRecordList) then
  begin
    m_STRecordLock.Enter;
    try
      nRecordCnt := m_STRecordList.Count;
      nRecordIdx := 0;

      while 0 < nRecordCnt do
      begin
        objSTRecord := CFNStreamRecord(m_STRecordList.Items[nRecordIdx]);
        if Assigned(objSTRecord) then
        begin
          if 0 >= objSTRecord.GetReferenceCount then
          begin
            // objSTRecord.Free;
            m_STRecordList.Delete(nRecordIdx);
            nRecordIdx := nRecordIdx - 1;
          end;
        end;

        nRecordIdx := nRecordIdx + 1;
        nRecordCnt := nRecordCnt - 1;
      end;
    finally
      m_STRecordLock.Leave;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// var f_szSource:String := "";
// if (ACountry > 9) f_szSource := f_szSource + "C" +IntToStr(ACountry);
// else f_szSource := f_szSource +  "C0" + IntToStr(p_Country);
// if (AGroup > 9) f_szSource := f_szSource +  "G" + IntToStr(AGroup);
// else f_szSource := f_szSource +  "G0" + IntToStr(AGroup);
// if (AMarket > 9) f_szSource := f_szSource +  "M" + IntToStr(AMarket);
// else f_szSource := f_szSource +  "M0" + IntToStr(AMarket);
// f_szSource := f_szSource +  ASymbol;
// //C00G01M00005940
// return f_szSource;
function CFNAgentManager.MakeStreamSubscribeKey(ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String): String;
var
  f_szSource: String;
begin
  f_szSource := '';

  if (ACountry > 9) then
    f_szSource := f_szSource + 'C' + IntToStr(ACountry)
  else
    f_szSource := f_szSource + 'C0' + IntToStr(ACountry);

  if (AGroup > 9) then
    f_szSource := f_szSource + 'G' + IntToStr(AGroup)
  else
    f_szSource := f_szSource + 'G0' + IntToStr(AGroup);

  if (AMarket > 9) then
    f_szSource := f_szSource + 'M' + IntToStr(AMarket)
  else
    f_szSource := f_szSource + 'M0' + IntToStr(AMarket);

  f_szSource := f_szSource + ASymbol;

  Result := f_szSource;
end;

// ---------------------------------------------------------------------------
function CFNAgentManager.GetStreamSubscribeKey(AKey: String; var ACountry: Integer; var AGroup: Integer; var AMarket: Integer; var ASymbol: String): Boolean;
begin
  Result := FALSE;
  try
    if 9 < Length(AKey) then
    begin
      ACountry := strToInt(Copy(AKey, 2, 2)); //
      AGroup := TFNGlobal.atoi(Copy(AKey, 5, 2)); //
      AMarket := TFNGlobal.atoi(Copy(AKey, 8, 2)); //
      ASymbol := Copy(AKey, 10, Length(AKey) - (10 - 1)); //
    end;
  except
    // LOG_ERROR(['CFNSocketManager.GetStreamSubscribeKey - 오류']);
    Result := FALSE;
  end;
end;

// ---------------------------------------------------------------------------
constructor CFNQueryData.Create;
begin
  inherited Create;

  m_ServiceID := '';
  m_TRCode := '';
  m_RequestID := '';
  m_Request := CFNDataPackage.Create;
  m_Response := CFNDataPackage.Create;
  m_DateTime := Now;
  m_SendDateTime := Now;
  m_Dispatch := NIL;
end;

// ---------------------------------------------------------------------------
destructor CFNQueryData.Destroy;
begin
  if (m_Request <> NIL) then
    m_Request.Free;
  m_Request := NIL;
  if (m_Response <> NIL) then
    m_Response.Free;
  m_Response := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
end.
