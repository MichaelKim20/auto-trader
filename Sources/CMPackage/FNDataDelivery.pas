unit FNDataDelivery;

interface

uses
  ExtCtrls, Contnrs, SysUtils, StrUtils, Classes, SyncObjs,
  FNDataSet, FNQueue, FNDataObject;

type
  /// //////////////////////////////////////////////////////////////////////
  TFNReplyEvent = Procedure(ADataPackage: CFNDataPackage; var AutoFree: Boolean) of Object;
  TFNStreamEvent = Procedure(AStreamRecord: CFNStreamRecord) of Object;

  CFNDataDelivery = class(TObject)
  private
    // 조회 데이터 수신시 실행할 이벤트 함수의 포인터이다.
    m_OnReplyEvent: TFNReplyEvent;
    // 스트리밍 데이터 수신시 실행할 이벤트 함수의 포인터이다.
    m_OnStreamEvent: TFNStreamEvent;
    m_OnTimeoutEvent: TFNReplyEvent;

    m_ReceiveQueue: CFNQueue;
    m_ReceiveTimer: TTimer;

    m_UseTimer: Boolean;

    procedure StoreRecvData(ADataObject: CFNDataObject);
    function RetrieveRecvData(): CFNDataObject;
    function ManyRetrieveRecvData(var AList: TList; AMaxCnt: Integer): Boolean;

    procedure OnReceived(AList: TList);
    procedure OnReceiveTimer(Sender: TObject);

    procedure SetUseTimer(AValue: Boolean);
    function GetUseTimer: Boolean;

  public
    // 생성 메소드
    constructor Create;
    // 파괴 메소드
    destructor Destroy; override;

    procedure DeliveryReply(ADataPackage: CFNDataPackage);
    procedure DeliveryTimeout(ADataPackage: CFNDataPackage);
    procedure DeliveryStream(AStreamRecord: CFNStreamRecord);

    property UseTimer: Boolean read GetUseTimer write SetUseTimer;
    property OnReplyEvent: TFNReplyEvent read m_OnReplyEvent write m_OnReplyEvent;
    property OnStreamEvent: TFNStreamEvent read m_OnStreamEvent write m_OnStreamEvent;
    property OnTimeoutEvent: TFNReplyEvent read m_OnTimeoutEvent write m_OnTimeoutEvent;
  end;

implementation

// uses
// FNSocketManager;

/// //////////////////////////////////////////////////////////////////////////
// ---------------------------------------------------------------------------
constructor CFNDataDelivery.Create;
begin
  inherited Create;

  m_UseTimer := false;
  m_ReceiveTimer := NIL;

  m_ReceiveQueue := CFNQueue.Create();
  m_ReceiveQueue.SetAutoFree(false);
end;

// ---------------------------------------------------------------------------
destructor CFNDataDelivery.Destroy;
var
  f_DataObject: CFNDataObject;
  f_Type: TDeliveryType;
begin
  m_OnReplyEvent := NIL;
  m_OnStreamEvent := NIL;

  if Assigned(m_ReceiveTimer) then
  begin
    m_ReceiveTimer.Enabled := false;
    m_ReceiveTimer.Free;
  end;

  if Assigned(m_ReceiveQueue) then
  begin
    while 0 < m_ReceiveQueue.GetCount do
    begin
      f_DataObject := RetrieveRecvData;
      if Assigned(f_DataObject) then
      begin
        f_Type := f_DataObject.DeliveryType;
        if dvtQuery = f_Type then
        begin
          CFNDataPackage(f_DataObject).Free;
        end
        else if dvtStream = f_Type then
        begin
          CFNStreamRecord(f_DataObject).DecreaseReferenceCount();
        end
        else
        begin
        end;
      end;
    end;

    m_ReceiveQueue.Free();
  end;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNDataDelivery.SetUseTimer(AValue: Boolean);
begin
  if (AValue) then
  begin
    if Assigned(m_ReceiveTimer) then
    begin
      m_ReceiveTimer.Enabled := false;
      m_ReceiveTimer.Free;
      m_ReceiveTimer := NIL;
    end;

    m_ReceiveTimer := TTimer.Create(NIL);
    m_ReceiveTimer.OnTimer := OnReceiveTimer;
    m_ReceiveTimer.Interval := 300;
    m_ReceiveTimer.Enabled := true;
  end
  else
  begin
    if Assigned(m_ReceiveTimer) then
    begin
      m_ReceiveTimer.Enabled := false;
      m_ReceiveTimer.Free;
      m_ReceiveTimer := NIL;
    end;
  end;

  m_UseTimer := AValue;
end;

// ---------------------------------------------------------------------------
function CFNDataDelivery.GetUseTimer: Boolean;
begin
  Result := m_UseTimer;
end;

// ---------------------------------------------------------------------------
procedure CFNDataDelivery.StoreRecvData(ADataObject: CFNDataObject);
begin
  if Assigned(m_ReceiveQueue) then
  begin
    m_ReceiveQueue.Store(ADataObject);
  end;
end;

// ---------------------------------------------------------------------------
function CFNDataDelivery.RetrieveRecvData(): CFNDataObject;
begin
  if Assigned(m_ReceiveQueue) then
  begin
    Result := m_ReceiveQueue.Retrieve();
  end
  else
  begin
    Result := NIL;
  end;
end;

// ---------------------------------------------------------------------------
function CFNDataDelivery.ManyRetrieveRecvData(var AList: TList; AMaxCnt: Integer): Boolean;
begin
  Result := false;
  if Assigned(m_ReceiveQueue) then
  begin
    m_ReceiveQueue.ManyRetrieve(AList, AMaxCnt);
    if Assigned(AList) then
    begin
      if (0 < AList.Count) then
      begin
        Result := true;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// 조회데이터에 대한 응답으로 메인에서 이 함수를 통해 데이터를 전송하면 이 함수 내부에서 이벤트를 발생하여 각 화면에 그 내용을 전달할 수 있도록 한다.
// 이벤트의 원형은 TFNReplyEvent = Procedure((ADataPackage: CFNDataPackage) of Object; 이다.
// property OnReplyEvent(): (): TFNReplyEvent read m_OnReplyEvent write m_OnReplyEvent;
// 이 프라퍼티를 추가하여 외부에서 등록을 할 수 있도록한다.
procedure CFNDataDelivery.DeliveryReply(ADataPackage: CFNDataPackage);
var
  f_Free: Boolean;
begin
  if not Assigned(ADataPackage) then
    exit;

  if (m_UseTimer) then
  begin
    StoreRecvData(ADataPackage);
    f_Free := false;
  end
  else
  begin
    f_Free := true;
    try
      if (Assigned(m_OnReplyEvent)) then
        m_OnReplyEvent(ADataPackage, f_Free);
    finally
      if f_Free then
        ADataPackage.Free;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNDataDelivery.DeliveryTimeout(ADataPackage: CFNDataPackage);
var
  f_Free: Boolean;
begin
  if not Assigned(ADataPackage) then
    exit;

  if (m_UseTimer) then
  begin
    StoreRecvData(ADataPackage);
    f_Free := false;
  end
  else
  begin
    f_Free := true;
    if (Assigned(m_OnTimeoutEvent)) then
      m_OnTimeoutEvent(ADataPackage, f_Free);
    if f_Free then
      ADataPackage.Free;
  end;
end;

// ---------------------------------------------------------------------------
// 스트리밍데이터를 전달하기 위한 함수로써, 메인에서 이 함수를 통해 데이터를 전송하면 이 함수 내부에서 이벤트를 발생하여 각 화면에 그 내용을 전달할 수 있도록 한다.
// 이벤트의 원형은 TFNStreamEvent = Procedure(AStreamRecord: CFNStreamRecord) of Object; 이다.
// property OnStreamEvent(): (): TFNStreamEvent read m_OnStreamEvent write m_OnStreamEvent;
// 이 프라퍼티를 추가하여 외부에서 등록을 할 수 있도록한다.
procedure CFNDataDelivery.DeliveryStream(AStreamRecord: CFNStreamRecord);
begin
  if not Assigned(AStreamRecord) then
    exit;

  if (m_UseTimer) then
  begin
    StoreRecvData(AStreamRecord);
  end
  else
  begin
    if (Assigned(m_OnStreamEvent)) then
      m_OnStreamEvent(AStreamRecord);
  end;
end;

// ---------------------------------------------------------------------------
Procedure CFNDataDelivery.OnReceiveTimer(Sender: TObject);
var
  f_DataObject: CFNDataObject;
  f_Type: TDeliveryType;
  f_List: TList;
begin
  if not m_UseTimer then
    exit;
  try
    f_List := TList.Create();
    if ManyRetrieveRecvData(f_List, 1) then
    begin
      try
        OnReceived(f_List);
      finally

      end;

      while 0 < f_List.Count do
      begin
        f_DataObject := CFNDataObject(f_List.Items[0]);
        if Assigned(f_DataObject) then
        begin
          f_Type := f_DataObject.DeliveryType;
          if dvtQuery = f_Type then
          begin
            CFNDataPackage(f_DataObject).Free;
          end
          else if dvtStream = f_Type then
          begin
            CFNStreamRecord(f_DataObject).DecreaseReferenceCount();
          end
          else
          begin
          end;
        end;
        f_List.Delete(0);
      end;
    end;

    f_List.Free();
  except
    f_List.Free();
  end;
end;

// ---------------------------------------------------------------------------
Procedure CFNDataDelivery.OnReceived(AList: TList);
var
  f_DataObject: CFNDataObject;
  f_Type: TDeliveryType;
  f_Index: Integer;
  f_Free: Boolean;
begin
  for f_Index := 0 to AList.Count - 1 do
  begin
    f_DataObject := CFNDataObject(AList.Items[f_Index]);
    if Assigned(f_DataObject) then
    begin
      f_Type := f_DataObject.DeliveryType;
      if dvtQuery = f_Type then
      begin
        f_Free := true;
        if (Assigned(m_OnReplyEvent)) then
          m_OnReplyEvent(CFNDataPackage(f_DataObject), f_Free);
        if f_Free then
        begin
          CFNDataPackage(f_DataObject).Free;
          AList.Items[f_Index] := NIL;
        end;
      end
      else if dvtStream = f_Type then
      begin
        if Assigned(m_OnStreamEvent) then
          m_OnStreamEvent(CFNStreamRecord(f_DataObject));
      end
      else
      begin
      end;
    end;
  end;
end;
// ---------------------------------------------------------------------------

end.
