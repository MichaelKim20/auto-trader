unit FNLoadItem;

interface

uses FNLoadController, FNSocketManager, FNDataDelivery, FNDataSet, IdHTTP,
  FNCMVariable, MXVariable;

type

  // -----------------------------------------------------------------------------
  CFNLoadItemSocket = class(CFNLoadItem)
  private

  public
    constructor Create;
    destructor Destroy; override;
    procedure Load; override;
  end;

  // -----------------------------------------------------------------------------
  CFNLoadItem_USER_0110 = class(CFNLoadItem)
  private
    m_DataDelivery: CFNDataDelivery;
    m_IDataPackage: CFNDataPackage;
    m_ODataPackage: CFNDataPackage;

    m_StartMessage: String;
    m_CompleteMessage: String;
    m_FaultMessage: String;

    procedure OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
    procedure Request;

  public
    m_PGM_CODE: String;
    m_USER_ID: String;
    m_PASSWORD: String;

    constructor Create;
    destructor Destroy; override;
    procedure Load; override;
  end;

  // -----------------------------------------------------------------------------
  CFNLoadItem_USER_0120 = class(CFNLoadItem)
  private
    m_DataDelivery: CFNDataDelivery;
    m_IDataPackage: CFNDataPackage;
    m_ODataPackage: CFNDataPackage;

    m_StartMessage: String;
    m_CompleteMessage: String;
    m_FaultMessage: String;

    procedure OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
    procedure Request;

  public
    m_PGM_CODE: String;
    m_USER_ID: String;
    m_PASSWORD: String;

    constructor Create;
    destructor Destroy; override;
    procedure Load; override;
  end;

  // -----------------------------------------------------------------------------
  CFNLoadItem_BASIC_0010 = class(CFNLoadItem)
  private
    m_DataDelivery: CFNDataDelivery;
    m_IDataPackage: CFNDataPackage;
    m_ODataPackage: CFNDataPackage;

    m_StartMessage: String;
    m_CompleteMessage: String;
    m_FaultMessage: String;

    procedure OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
    procedure Request;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Load; override;
  end;

  // -----------------------------------------------------------------------------
  CFNLoadItem_BASIC_0020 = class(CFNLoadItem)
  private
    m_DataDelivery: CFNDataDelivery;
    m_IDataPackage: CFNDataPackage;
    m_ODataPackage: CFNDataPackage;

    m_StartMessage: String;
    m_CompleteMessage: String;
    m_FaultMessage: String;

    procedure OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
    procedure Request;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Load; override;
  end;

  // -----------------------------------------------------------------------------
  CFNLoadItem_BASIC_0030 = class(CFNLoadItem)
  private
    m_DataDelivery: CFNDataDelivery;
    m_IDataPackage: CFNDataPackage;
    m_ODataPackage: CFNDataPackage;

    m_StartMessage: String;
    m_CompleteMessage: String;
    m_FaultMessage: String;

    procedure OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
    procedure Request;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Load; override;
  end;

  // -----------------------------------------------------------------------------
  CFNLoadItem_CODE_0010 = class(CFNLoadItem)
  private
    m_DataDelivery: CFNDataDelivery;
    m_IDataPackage: CFNDataPackage;
    m_ODataPackage: CFNDataPackage;

    m_StartMessage: String;
    m_CompleteMessage: String;
    m_FaultMessage: String;

    procedure OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
    procedure Request;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Load; override;
  end;

  // -----------------------------------------------------------------------------
  CFNLoadItem_ACCOUNT_0010 = class(CFNLoadItem)
  private
    m_DataDelivery: CFNDataDelivery;
    m_IDataPackage: CFNDataPackage;
    m_ODataPackage: CFNDataPackage;

    m_StartMessage: String;
    m_CompleteMessage: String;
    m_FaultMessage: String;

    procedure OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
    procedure Request;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Load; override;
  end;

  // -----------------------------------------------------------------------------

implementation

uses
  Classes, SysUtils, FNPOTCollection, FNMaterialCollection,
  FNAccountData, CommonTRMaker, FNGlobal, FNConditionData, FNSymbolCollection,
  FNGlobalVariable;

// -----------------------------------------------------------------------------
constructor CFNLoadItemSocket.Create;
begin
  inherited Create;
  m_WorkName := '서버로 접속';
  if (g_Language = 1) then
  begin
    m_WorkName := 'Connect to server';
  end;
  m_StopOnFault := true;
end;

// -----------------------------------------------------------------------------
destructor CFNLoadItemSocket.Destroy;
begin

  inherited;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItemSocket.Load;
begin
  if (g_Language = 0) then
  begin
    m_Message := '서버로의 접속을 시작합니다.';
    OnLoadStart;

    // g_SocketManager.Disconnect;
    Sleep(100);
    g_SocketManager.SetServerProperty(g_StreamServerIP, g_StreamServerPort);
    g_SocketManager.Connect;
    Sleep(100);
    if g_SocketManager.GetConnected then
    begin
      m_Message := '서버 접속을 완료하였습니다.';
      OnLoadComplete;
    end
    else
    begin
      m_Message := '서버 접속을 실패하였습니다.';
      OnLoadFault;
    end;
  end
  else
  begin
    m_Message := 'Connection';
    OnLoadStart;

    g_SocketManager.Disconnect;
    Sleep(100);
    g_SocketManager.SetServerProperty(g_StreamServerIP, g_StreamServerPort);
    g_SocketManager.Connect;
    Sleep(100);
    if g_SocketManager.GetConnected then
    begin
      m_Message := 'Success Connection';
      OnLoadComplete;
    end
    else
    begin
      m_Message := 'Failur Connection';
      OnLoadFault;
    end;
  end;
end;

// -----------------------------------------------------------------------------
constructor CFNLoadItem_USER_0110.Create;
begin
  inherited Create;
  m_WorkName := '로그인';
  m_StopOnFault := true;

  m_DataDelivery := CFNDataDelivery.Create;
  m_DataDelivery.OnReplyEvent := OnReply;

  m_IDataPackage := CFNDataPackage.Create;
  m_ODataPackage := CFNDataPackage.Create;

  m_StartMessage := '로그인을 시작합니다.';
  m_CompleteMessage := '로그인을 완료하였습니다.';
  m_FaultMessage := '로그인을 실패하였습니다.';
end;

// -----------------------------------------------------------------------------
destructor CFNLoadItem_USER_0110.Destroy;
begin
  if Assigned(m_DataDelivery) then
  begin
    m_DataDelivery.Free;
    m_DataDelivery := NIL;
  end;
  m_IDataPackage.Free;
  m_ODataPackage.Free;
  inherited;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_USER_0110.Load;
begin
  m_Message := m_StartMessage;
  OnLoadStart;

  if (g_SocketManager.GetConnected) then
  begin
    Request;
  end
  else
  begin
    m_Message := '서버와 연결이 되어 있지 않습니다.';
    OnLoadFault;
  end;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_USER_0110.Request;
var
  f_Record: CFNRecord;
begin
  f_Record := CFNRecord.Create;
  f_Record.SetStringValue('USER_ID', m_USER_ID);
  f_Record.SetStringValue('PASSWORD', m_PASSWORD);
  f_Record.SetStringValue('PGM_CODE', m_PGM_CODE);

  Make_SC_USER_TR_0110_IN(m_IDataPackage, f_Record);

  g_SocketManager.Request(m_DataDelivery, m_IDataPackage);
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_USER_0110.OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
var
  f_Record: CFNRecord;
  f_Index: Integer;
  f_DataSet1: CFNDataSet;
  f_Result: Integer;
  f_Success: Boolean;
begin
  m_ODataPackage.Clone(ADataPackage);
  if m_ODataPackage.GetServiceID = 'SC_USER' then
  begin
    if m_ODataPackage.GetTRCode = 'TR_0110' then
    begin
      if (m_ODataPackage.GetMsgCode <> 'M00000') then
      begin
        m_Message := m_FaultMessage;
        LOG_WRITE(LOG_TYPE_ERROR, 'CFNLoadItem_USER_0010.OnReply', m_Message);
        OnLoadFault;
      end
      else
      begin
        g_SessionKey := '';
        f_Result := ST_ERROR_CHECK_MEMBER;
        f_DataSet1 := m_ODataPackage.GetDataSet(DATASETID_OUT_01);
        if Assigned(f_DataSet1) and (0 < f_DataSet1.RecordList.Count) then
        begin
          for f_Index := 0 to f_DataSet1.RecordList.Count - 1 do
          begin
            f_Record := CFNRecord(f_DataSet1.RecordList.Items[f_Index]);

            g_SessionKey := f_Record.GetStringValue('SESSION_KEY');
            f_Result := f_Record.GetIntegerValue('RESULT');

          end;
          f_Success := false;
          m_Message := m_CompleteMessage;
          case (f_Result) of
            LOGIN_Success:
              begin
                m_Message := '로그인에 성공하였습니다.';
                f_Success := true;
              end;
            LOGIN_SystemError:
              begin
                m_Message := '시스템오류로 인해 로그인하지 못하였습니다.';
                f_Success := false;
              end;
            LOGIN_NoneUserName:
              begin
                m_Message := '아이디를 입력하지 않았습니다.';
                f_Success := false;
              end;
            LOGIN_NonePassWord:
              begin
                m_Message := '비밀번호를 입력하지 않았습니다.';
                f_Success := false;
              end;
            LOGIN_AlreadLogin:
              begin
                m_Message := '이미 로그인 하였습니다.';
                f_Success := false;
              end;
            LOGIN_InvalidUserName:
              begin
                m_Message := '사용자가 존재하지 않습니다.';
                f_Success := false;
              end;
            LOGIN_InvalidPassWord:
              begin
                m_Message := '비밀번호 오류입니다.';
                f_Success := false;
              end;
            ST_NOT_MEMBER_OR_PASSWORD:
              begin
                m_Message := '사용자가 존재하지 않습니다.';
                f_Success := false;
              end;
            ST_ERROR_CHECK_MEMBER:
              begin
                m_Message := '오류로 인해 로그인하지 못하였습니다.';
                f_Success := false;
              end;
          else
            begin
              m_Message := m_FaultMessage;
              f_Success := false;
            end;
          end;
          if f_Success then
            OnLoadComplete
          else
            OnLoadFault;
        end
        else
        begin
          m_Message := m_FaultMessage;
          LOG_WRITE(LOG_TYPE_ERROR, 'CFNLoadItem_USER_0010.OnReply', m_Message);
          OnLoadFault;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
constructor CFNLoadItem_USER_0120.Create;
begin
  inherited Create;
  m_WorkName := '로그인';
  m_StopOnFault := true;

  m_DataDelivery := CFNDataDelivery.Create;
  m_DataDelivery.OnReplyEvent := OnReply;

  m_IDataPackage := CFNDataPackage.Create;
  m_ODataPackage := CFNDataPackage.Create;

  m_StartMessage := '로그인을 시작합니다.';
  m_CompleteMessage := '로그인을 완료하였습니다.';
  m_FaultMessage := '로그인을 실패하였습니다.';
end;

// -----------------------------------------------------------------------------
destructor CFNLoadItem_USER_0120.Destroy;
begin
  if Assigned(m_DataDelivery) then
  begin
    m_DataDelivery.Free;
    m_DataDelivery := NIL;
  end;
  m_IDataPackage.Free;
  m_ODataPackage.Free;
  inherited;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_USER_0120.Load;
begin
  m_Message := m_StartMessage;
  OnLoadStart;

  if (g_SocketManager.GetConnected) then
  begin
    Request;
  end
  else
  begin
    m_Message := '서버와 연결이 되어 있지 않습니다.';
    OnLoadFault;
  end;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_USER_0120.Request;
var
  f_Record: CFNRecord;
begin
  f_Record := CFNRecord.Create;
  f_Record.SetStringValue('USER_ID', m_USER_ID);
  f_Record.SetStringValue('PASSWORD', m_PASSWORD);
  f_Record.SetStringValue('PGM_CODE', m_PGM_CODE);
  f_Record.SetStringValue('SESSION_KEY', g_SessionKey);
  f_Record.SetStringValue('TRADESESSION_KEY', g_TradeSessionKey);
  f_Record.SetStringValue('LEADER_SESSION', g_LeaderTradeSessionKey);

  Make_SC_USER_TR_0120_IN(m_IDataPackage, f_Record);

  g_SocketManager.Request(m_DataDelivery, m_IDataPackage);
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_USER_0120.OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
var
  f_Record: CFNRecord;
  f_Index: Integer;
  f_DataSet1: CFNDataSet;
  f_Result: Integer;
  f_Success: Boolean;
begin
  m_ODataPackage.Clone(ADataPackage);
  if m_ODataPackage.GetServiceID = 'SC_USER' then
  begin
    if m_ODataPackage.GetTRCode = 'TR_0120' then
    begin
      if (m_ODataPackage.GetMsgCode <> 'M00000') then
      begin
        m_Message := m_FaultMessage;
        LOG_WRITE(LOG_TYPE_ERROR, 'CFNLoadItem_USER_00120.OnReply', m_Message);
        OnLoadFault;
      end
      else
      begin
        f_Result := ST_ERROR_CHECK_MEMBER;
        f_DataSet1 := m_ODataPackage.GetDataSet(DATASETID_OUT_01);
        if Assigned(f_DataSet1) and (0 < f_DataSet1.RecordList.Count) then
        begin
          for f_Index := 0 to f_DataSet1.RecordList.Count - 1 do
          begin
            f_Record := CFNRecord(f_DataSet1.RecordList.Items[f_Index]);

            f_Result := f_Record.GetIntegerValue('RESULT');

          end;
          f_Success := false;
          m_Message := m_CompleteMessage;
          case (f_Result) of
            LOGIN_Success:
              begin
                m_Message := '로그인에 성공하였습니다.';
                f_Success := true;
              end;
            LOGIN_SystemError:
              begin
                m_Message := '시스템오류로 인해 로그인하지 못하였습니다.';
                f_Success := false;
              end;
            LOGIN_NoneUserName:
              begin
                m_Message := '아이디를 입력하지 않았습니다.';
                f_Success := false;
              end;
            LOGIN_NonePassWord:
              begin
                m_Message := '비밀번호를 입력하지 않았습니다.';
                f_Success := false;
              end;
            LOGIN_AlreadLogin:
              begin
                m_Message := '이미 로그인 하였습니다.';
                f_Success := false;
              end;
            LOGIN_InvalidUserName:
              begin
                m_Message := '사용자가 존재하지 않습니다.';
                f_Success := false;
              end;
            LOGIN_InvalidPassWord:
              begin
                m_Message := '비밀번호 오류입니다.';
                f_Success := false;
              end;
            ST_NOT_MEMBER_OR_PASSWORD:
              begin
                m_Message := '사용자가 존재하지 않습니다.';
                f_Success := false;
              end;
            ST_ERROR_CHECK_MEMBER:
              begin
                m_Message := '오류로 인해 로그인하지 못하였습니다.';
                f_Success := false;
              end;
          else
            begin
              m_Message := m_FaultMessage;
              f_Success := false;
            end;
          end;
          if f_Success then
            OnLoadComplete
          else
            OnLoadFault;
        end
        else
        begin
          m_Message := m_FaultMessage;
          LOG_WRITE(LOG_TYPE_ERROR, 'CFNLoadItem_USER_0010.OnReply', m_Message);
          OnLoadFault;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
constructor CFNLoadItem_BASIC_0010.Create;
begin
  inherited Create;
  m_WorkName := '시장 운영시간 정보';
  m_StopOnFault := true;

  m_DataDelivery := CFNDataDelivery.Create;
  m_DataDelivery.OnReplyEvent := OnReply; // 조회성 데이터 수신 이벤트 등록

  m_IDataPackage := CFNDataPackage.Create;
  m_ODataPackage := CFNDataPackage.Create;

  m_StartMessage := '운영시간정보의 로딩을 시작합니다.';
  m_CompleteMessage := '운영시간정보의 로딩을 완료하였습니다.';
  m_FaultMessage := '운영시간정보의 로딩을 실패하였습니다.';
end;

// -----------------------------------------------------------------------------
destructor CFNLoadItem_BASIC_0010.Destroy;
begin
  if Assigned(m_DataDelivery) then
  begin
    m_DataDelivery.Free;
    m_DataDelivery := NIL;
  end;
  m_IDataPackage.Free;
  m_ODataPackage.Free;
  inherited;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_BASIC_0010.Load;
begin
  m_Message := m_StartMessage;
  OnLoadStart;

  if (g_SocketManager.GetConnected) then
  begin
    Request;
  end
  else
  begin
    m_Message := m_FaultMessage;
    OnLoadFault;
  end;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_BASIC_0010.Request;
var
  f_Record: CFNRecord;
begin
  f_Record := CFNRecord.Create;
  f_Record.SetStringValue('NONE', 'NONE');

  Make_SC_BASIC_TR_0010_IN(m_IDataPackage, f_Record);

  g_SocketManager.Request(m_DataDelivery, m_IDataPackage);
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_BASIC_0010.OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
var
  f_Record: CFNRecord;
  f_Index: Integer;
  f_DataSet1: CFNDataSet;
  f_POTItem: CFNPOTItem;
begin
  m_ODataPackage.Clone(ADataPackage);
  if m_ODataPackage.GetServiceID = 'SC_BASIC' then
  begin
    if m_ODataPackage.GetTRCode = 'TR_0010' then
    begin
      if (m_ODataPackage.GetMsgCode <> 'M00000') then
      begin
        m_Message := m_FaultMessage;
        LOG_WRITE(LOG_TYPE_ERROR, 'CFNLoadItem_BASIC_0010.OnReply', m_Message);
        OnLoadFault;
      end
      else
      begin
        g_POTCollection.Clear;
        f_DataSet1 := m_ODataPackage.GetDataSet(DATASETID_OUT_01);
        if Assigned(f_DataSet1) and (0 < f_DataSet1.RecordList.Count) then
        begin
          for f_Index := 0 to f_DataSet1.RecordList.Count - 1 do
          begin
            f_Record := CFNRecord(f_DataSet1.RecordList.Items[f_Index]);

            f_POTItem := CFNPOTItem.Create;
            f_POTItem.ArrayToData(f_Record);

            g_POTCollection.Add(f_POTItem);
          end;
          g_POTCollection.Sort;
          m_Message := m_CompleteMessage;
          OnLoadComplete;
        end
        else
        begin
          m_Message := m_FaultMessage;
          LOG_WRITE(LOG_TYPE_ERROR, 'CFNLoadItem_BASIC_0010.OnReply', m_Message);
          OnLoadFault;
        end;
      end;
    end;
  end;
end;

{ CFNLoadItem_BASIC_0020 }
// -----------------------------------------------------------------------------
constructor CFNLoadItem_BASIC_0020.Create;
begin
  inherited Create;
  m_WorkName := '시장기본정보';
  m_StopOnFault := true;

  m_DataDelivery := CFNDataDelivery.Create;
  m_DataDelivery.OnReplyEvent := OnReply;

  m_IDataPackage := CFNDataPackage.Create;
  m_ODataPackage := CFNDataPackage.Create;

  m_StartMessage := '시장기본정보의 로딩을 시작합니다.';
  m_CompleteMessage := '시장기본정보의 로딩을 완료하였습니다.';
  m_FaultMessage := '시장기본정보의 로딩을 실패하였습니다.';
end;

// -----------------------------------------------------------------------------
destructor CFNLoadItem_BASIC_0020.Destroy;
begin
  if Assigned(m_DataDelivery) then
  begin
    m_DataDelivery.Free;
    m_DataDelivery := NIL;
  end;
  m_IDataPackage.Free;
  m_ODataPackage.Free;
  inherited;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_BASIC_0020.Load;
begin
  m_Message := m_StartMessage;
  OnLoadStart;

  if (g_SocketManager.GetConnected) then
  begin
    Request;
  end
  else
  begin
    m_Message := m_FaultMessage;
    OnLoadFault;
  end;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_BASIC_0020.Request;
var
  f_Record: CFNRecord;
begin
  f_Record := CFNRecord.Create;
  f_Record.SetStringValue('NONE', 'NONE');

  Make_SC_BASIC_TR_0020_IN(m_IDataPackage, f_Record);

  g_SocketManager.Request(m_DataDelivery, m_IDataPackage);
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_BASIC_0020.OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
var
  f_Record: CFNRecord;
  f_Index: Integer;
  f_DataSet1: CFNDataSet;
  f_DataSet2: CFNDataSet;
  f_MaterialItem: CFNMaterialItem;
begin
  m_ODataPackage.Clone(ADataPackage);
  if m_ODataPackage.GetServiceID = 'SC_BASIC' then
  begin
    if m_ODataPackage.GetTRCode = 'TR_0020' then
    begin
      if (m_ODataPackage.GetMsgCode <> 'M00000') then
      begin
        m_Message := m_FaultMessage;
        LOG_WRITE(LOG_TYPE_ERROR, 'CFNLoadItem_BASIC_0020.OnReply', m_Message);
        OnLoadFault;
      end
      else
      begin
        g_MaterialCollection.Clear;
        f_DataSet1 := m_ODataPackage.GetDataSet(DATASETID_OUT_01);
        if Assigned(f_DataSet1) and (0 < f_DataSet1.RecordList.Count) then
        begin
          for f_Index := 0 to f_DataSet1.RecordList.Count - 1 do
          begin
            f_Record := CFNRecord(f_DataSet1.RecordList.Items[f_Index]);

            f_MaterialItem := CFNMaterialItem.Create;
            f_MaterialItem.ArrayToData(f_Record);

            g_MaterialCollection.Add(f_MaterialItem);
          end;
          m_Message := m_CompleteMessage;
          OnLoadComplete;
        end
        else
        begin
          m_Message := m_FaultMessage;
          LOG_WRITE(LOG_TYPE_ERROR, 'CFNLoadItem_BASIC_0020.OnReply', m_Message);
          OnLoadFault;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
constructor CFNLoadItem_BASIC_0030.Create;
begin
  inherited Create;
  m_WorkName := '시장기본정보';
  m_StopOnFault := true;

  m_DataDelivery := CFNDataDelivery.Create;
  m_DataDelivery.OnReplyEvent := OnReply;

  m_IDataPackage := CFNDataPackage.Create;
  m_ODataPackage := CFNDataPackage.Create;

  m_StartMessage := '시장기본정보의 로딩을 시작합니다.';
  m_CompleteMessage := '시장기본정보의 로딩을 완료하였습니다.';
  m_FaultMessage := '시장기본정보의 로딩을 실패하였습니다.';
end;

// -----------------------------------------------------------------------------
destructor CFNLoadItem_BASIC_0030.Destroy;
begin
  if Assigned(m_DataDelivery) then
  begin
    m_DataDelivery.Free;
    m_DataDelivery := NIL;
  end;
  m_IDataPackage.Free;
  m_ODataPackage.Free;
  inherited;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_BASIC_0030.Load;
begin
  m_Message := m_StartMessage;
  OnLoadStart;

  if (g_SocketManager.GetConnected) then
  begin
    Request;
  end
  else
  begin
    m_Message := m_FaultMessage;
    OnLoadFault;
  end;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_BASIC_0030.Request;
var
  f_Record: CFNRecord;
begin
  f_Record := CFNRecord.Create;
  f_Record.SetStringValue('NONE', 'NONE');

  Make_SC_BASIC_TR_0030_IN(m_IDataPackage, f_Record);

  g_SocketManager.Request(m_DataDelivery, m_IDataPackage);
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_BASIC_0030.OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
var
  f_Record: CFNRecord;
  f_Index: Integer;
  f_DataSet1: CFNDataSet;
  f_DataSet2: CFNDataSet;
  f_Value: String;
  f_ServerDateTime: TDateTime;
begin
  m_ODataPackage.Clone(ADataPackage);
  if m_ODataPackage.GetServiceID = 'SC_BASIC' then
  begin
    if m_ODataPackage.GetTRCode = 'TR_0030' then
    begin
      if (m_ODataPackage.GetMsgCode <> 'M00000') then
      begin
        m_Message := m_FaultMessage;
        LOG_WRITE(LOG_TYPE_ERROR, 'CFNLoadItem_BASIC_0030.OnReply', m_Message);
        OnLoadFault;
      end
      else
      begin
        f_DataSet1 := m_ODataPackage.GetDataSet(DATASETID_OUT_01);
        if Assigned(f_DataSet1) and (0 < f_DataSet1.RecordList.Count) then
        begin
          f_Record := CFNRecord(f_DataSet1.RecordList.Items[0]);
          f_Value := f_Record.GetStringValue('DATETIME');
          f_ServerDateTime := TFNGlobal.StringToDateTime(f_Value);
          g_DateTimeDiff := f_ServerDateTime - Now;
          m_Message := m_CompleteMessage;
          OnLoadComplete;
        end
        else
        begin
          m_Message := m_FaultMessage;
          LOG_WRITE(LOG_TYPE_ERROR, 'CFNLoadItem_BASIC_0030.OnReply', m_Message);
          OnLoadFault;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
constructor CFNLoadItem_CODE_0010.Create;
begin
  inherited Create;
  m_WorkName := '선물 종목코드';
  m_StopOnFault := true;

  m_DataDelivery := CFNDataDelivery.Create;
  m_DataDelivery.OnReplyEvent := OnReply;

  m_IDataPackage := CFNDataPackage.Create;
  m_ODataPackage := CFNDataPackage.Create;

  m_StartMessage := '선물 종목코드의 로딩을 시작합니다.';
  m_CompleteMessage := '선물 종목코드의 로딩을 완료하였습니다.';
  m_FaultMessage := '선물 종목코드의 로딩을 실패하였습니다.';
end;

// -----------------------------------------------------------------------------
destructor CFNLoadItem_CODE_0010.Destroy;
begin
  if Assigned(m_DataDelivery) then
  begin
    m_DataDelivery.Free;
    m_DataDelivery := NIL;
  end;
  m_IDataPackage.Free;
  m_ODataPackage.Free;
  inherited;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_CODE_0010.Load;
begin
  m_Message := m_StartMessage;
  OnLoadStart;

  if (g_SocketManager.GetConnected) then
  begin
    Request;
  end
  else
  begin
    m_Message := m_FaultMessage;
    OnLoadFault;
  end;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_CODE_0010.Request;
var
  f_Record: CFNRecord;
begin
  f_Record := CFNRecord.Create;
  f_Record.SetStringValue('BROKER_CODE', 'SS');
  f_Record.SetStringValue('PGM_CODE', g_PGMCode);

  Make_SC_CODE_TR_0010_IN(m_IDataPackage, f_Record);

  g_SocketManager.Request(m_DataDelivery, m_IDataPackage);
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_CODE_0010.OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
var
  f_Record: CFNRecord;
  f_Index: Integer;
  f_DataSet1: CFNDataSet;
  f_DataSet2: CFNDataSet;
  f_SymbolItem: CFNSymbolItem;
begin
  m_ODataPackage.Clone(ADataPackage);
  if m_ODataPackage.GetServiceID = 'SC_CODE' then
  begin
    if m_ODataPackage.GetTRCode = 'TR_0010' then
    begin
      if (m_ODataPackage.GetMsgCode <> 'M00000') then
      begin
        m_Message := m_FaultMessage;
        OnLoadFault;
      end
      else
      begin
        g_SymbolCollection.Clear;
        f_DataSet1 := m_ODataPackage.GetDataSet(DATASETID_OUT_01);
        if Assigned(f_DataSet1) and (0 < f_DataSet1.RecordList.Count) then
        begin
          for f_Index := 0 to f_DataSet1.RecordList.Count - 1 do
          begin
            f_Record := CFNRecord(f_DataSet1.RecordList.Items[f_Index]);

            f_SymbolItem := CFNSymbolItem.Create;
            f_SymbolItem.ArrayToData(f_Record);

            g_SymbolCollection.Add(f_SymbolItem);
          end;
          m_Message := m_CompleteMessage;
          OnLoadComplete;
        end
        else
        begin
          m_Message := m_FaultMessage;
          LOG_WRITE(LOG_TYPE_ERROR, 'CFNLoadItem_CODE_2010.OnReply', m_Message);
          OnLoadFault;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
constructor CFNLoadItem_ACCOUNT_0010.Create;
begin
  inherited Create;
  m_WorkName := '계좌번호';
  m_StopOnFault := true;

  m_DataDelivery := CFNDataDelivery.Create;
  m_DataDelivery.OnReplyEvent := OnReply;

  m_IDataPackage := CFNDataPackage.Create;
  m_ODataPackage := CFNDataPackage.Create;

  m_StartMessage := '계좌정보의 로딩을 시작합니다.';
  m_CompleteMessage := '계좌정보의 로딩을 완료하였습니다.';
  m_FaultMessage := '계좌정보의 로딩을 실패하였습니다.';
end;

// -----------------------------------------------------------------------------
destructor CFNLoadItem_ACCOUNT_0010.Destroy;
begin
  if Assigned(m_DataDelivery) then
  begin
    m_DataDelivery.Free;
    m_DataDelivery := NIL;
  end;
  m_IDataPackage.Free;
  m_ODataPackage.Free;
  inherited;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_ACCOUNT_0010.Load;
begin
  m_Message := m_StartMessage;
  OnLoadStart;

  Request;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_ACCOUNT_0010.Request;
var
  f_Record: CFNRecord;
begin
  f_Record := CFNRecord.Create;
  f_Record.SetStringValue('NONE', 'NONE');

  Make_SC_ACCOUNT_TR_0010_IN(m_IDataPackage, f_Record);

  g_SocketManager.Request(m_DataDelivery, m_IDataPackage);
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem_ACCOUNT_0010.OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
var
  f_Record: CFNRecord;
  f_Index: Integer;
  f_DataSet1: CFNDataSet;
  f_AccountData: CFNAccountData;
begin
  m_ODataPackage.Clone(ADataPackage);
  if m_ODataPackage.GetServiceID = 'SC_ACCOUNT' then
  begin
    if m_ODataPackage.GetTRCode = 'TR_0010' then
    begin
      if (m_ODataPackage.GetMsgCode <> 'M00000') then
      begin
        m_Message := m_FaultMessage;
        OnLoadFault;
      end
      else
      begin
        g_AccountArray.Clear;
        f_DataSet1 := m_ODataPackage.GetDataSet(DATASETID_OUT_01);
        if Assigned(f_DataSet1) and (0 < f_DataSet1.RecordList.Count) then
        begin
          for f_Index := 0 to f_DataSet1.RecordList.Count - 1 do
          begin
            f_Record := CFNRecord(f_DataSet1.RecordList.Items[f_Index]);

            f_AccountData := CFNAccountData.Create;
            f_AccountData.ArrayToData(f_Record);

            g_AccountArray.Add(f_AccountData);
          end;
          m_Message := m_CompleteMessage;
          OnLoadComplete;
        end
        else
        begin
          m_Message := m_CompleteMessage;
          OnLoadComplete;
        end;
      end;
    end;
  end;
end;

end.
