Unit FNSocketManager;

interface

uses
  System.SysUtils, System.Types, System.Classes, System.Variants,
  System.UITypes, System.SyncObjs, IdComponent, IdTCPConnection, IdTCPClient,
  IdGlobal,
  WinProcs, WinTypes, IniFiles,
  Contnrs, FNThread, FNQueue, FNMultiMap, FNStreamPacketHandler,
  FNPacketHandler, FNFile,
  FNDataSet, FNDataDelivery;

const
  THREAD_STOP = 0;

const
  THREAD_START = 1;

const
  MAX_READ_BUFFER_SIZE = 4096;

const
  MAX_SUBSCRIBE_TABLE_SIZE = 1024;

const
  SOCKEVENT_CONNECT = 1;

const
  SOCKEVENT_RECEIVE = 2;

const
  SOCKEVENT_SEND = 3;

const
  SOCKEVENT_NORMALDISCONNECT = 4;

const
  SOCKEVENT_RELOGINDISCONNECT = 5;

const
  SOCKEVENT_ABNORMALDISCONNECT = 6;

const
  SOCKEVENT_DISCONNECT = 7;

type
  TFNSocketEvent = Procedure(p_Event: Integer) of Object;

  pTFNReceiveData = ^TFNReceiveData;

  TFNReceiveData = record
    m_Size: Integer;
    m_Data: PAnsiChar;
  end;

  CFNSocketManager = class;

  // ---------------------------------------------------------------------------
  CFNRecvThread = class(CFNThread)
  public
    m_Manager: CFNSocketManager;

  protected
    procedure StartWork; override;
    procedure DoWork; override;
    procedure EndWork; override;

    procedure SetManager(AManager: CFNSocketManager);
  end;

  // ---------------------------------------------------------------------------
  CFNSendThread = class(CFNThread)
  public
    m_Manager: CFNSocketManager;

  protected
    procedure StartWork; override;
    procedure DoWork; override;
    procedure EndWork; override;

    procedure SetManager(AManager: CFNSocketManager);
  end;

  // ---------------------------------------------------------------------------
  CFNProcThread = class(CFNThread)
  public
    m_Manager: CFNSocketManager;

  protected
    procedure StartWork; override;
    procedure DoWork; override;
    procedure EndWork; override;

    procedure SetManager(AManager: CFNSocketManager);
  end;

  // ---------------------------------------------------------------------------
  CFNSocketManager = class(TObject)
  private
    m_OnSocketEvent: TFNSocketEvent;
    m_EnableEvent: Boolean;

    // 수신을 담당하는 쓰레드로 소켓에서 읽어 데이터를 m_RecvQueue에 저장한다.
    m_RecvThread: CFNRecvThread;

    // 수신을 한 데이터를 처리하는 쓰레드이다 m_RectQueue에서 데이터를 꺼내서 패킷을 추출하고,
    // 해당화면으로 데이터를 전송한다.
    m_ProcThread: CFNProcThread;

    // 각 화면에서 필요한 데이터를 요청한 데이터는 m_SendQueue에 들어간다.
    // 이를 하나씩 꺼내서 서버에 요청한다.
    m_SendThread: CFNSendThread;

    // 소켓에서 받은 데이터를 저장하는 큐, 만약 큐가 없다면 화면처리가 지연되거나,
    // 서버에서 데이터가가 많을 때는 서버에서 전송하는 부분에 부담을 주어 서버가 불안정하게 될수 있다.
    // 따라서 서버의 부담을 줄이기 위해서 서버와 직접 연결된 소켓버퍼의 부담을 줄여준다.
    m_RecvQueue: CFNQueue;

    // 서버로 보내는 송신데이터를 저장하는 큐
    m_SendQueue: CFNQueue;

    /// Socket
    /// 클라이언트 소켓
    m_TCPClient: TIdTCPClient;
    m_SocketLock: TCriticalSection;

    // 서버의 아이피
    m_ServerIP: String;

    // 서버의 접속포트
    m_Port: Integer;

    m_ReceiveHeartBitTime: TDateTime;

    // 실행상태를 나타낸다. 1이면 동작상태이고, 0이면 정지상태이다.
    // 쓰레드에서 이 값을 보고 이 값이 0 이면 DoWork를 실행하지 않는다.
    m_State: Integer;

    // 수신한 데이터를 큐에서 꺼내서 분석을 한다. 분석은 의미있는 패킷을 잘라서 처리한다.
    // 이 때 자르고 남은 데이터가 발생한다. 이 데이터를 가지고 있는 구조체이다.
    m_ReceiveData: TFNReceiveData;

    // 수신한 데이터를 의미있는 패킷을 잘라서 처리한다. 이 때 하나의 패킷을 담기 위한 구조체이다.
    m_ExtractPacket: TFNReceiveData;

    // CFNStreamRecord는 스트리밍 데이터를 다수의 화면으로 전송하기 위해 필요하다.
    // 그러나 리소스의 낭비와 속도를 줄이기 위해, 하나의 CFNStreamRecord 객체를 사용하기를 원한다.
    // 하나의 객체를 사용할려면 이를 다 사용하고 메모리에서 해제시키는 방법을 찾아야 한다.
    // 여기서는  화면의 수만큼 참조카운트를 증가시키고, 화면처리후 참조카운트를 해당화면에서 하나씩 줄인다.
    // 이러한 객체는 물론 특별한 자료 구조에 넣어야 하는데, 그자료 구조가 바로 ObjectList인 이것이다.
    // 물론 주기적으로 이 자료구조에 들어 있는 해당요소의 참조카운트를 조사해서 그 참조카인트가 0인
    // 객체를 메모리에서 제거한다.
    // 이 작업을 하는 함수는 바로 TrucateUnusedStreamRecord 이다.
    m_STRecordList: TObjectList;

    // 각 화면에서 필요한 실시간데이터를 기록해 놓은 해쉬맵으로 현재는 배열로 구성되어 있고 그키는 3이다.
    // 첫번째는 시세, 두번째는 호가, 세번째는 뉴스를 위해 예약되어 있다.
    // 등록되는 키는 지수와 주식구분 필드값(0:지수,1:주식), 거래소구분필드값(0:상해, 1:심첨, 2:홍콩),
    // 심벌의 3개의 조합으로 키를 만들어서 사용한다.
    m_STSubscribeTable: Array [0 .. 2] of CFNMultiMap;

    // m_STSubscribeTable 를 접근할 때 동기화를 한다.
    m_STSubscribeTableLock: TCriticalSection;

    // m_RQSubscribeTable와 m_RQSubscribeIndex 을 접근할 때 동기화를 한다.
    m_RQSubscribeTableLock: TCriticalSection;

    // 수신한 스트리밍 데이터를 디코딩하기 위한 오브젝트
    m_STProcPacketHandler: CFNStreamPacketHandler;

    // 수신한 조회 데이터를 디코딩하기 위한 오브젝트
    m_PacketHandler: CFNPacketHandler;

    // 소켓에서 1차로 데이터를 받아오는 부분
    m_szReceiveData: Array [0 .. MAX_READ_BUFFER_SIZE] of AnsiChar;
    // 소켓에서 1차로 데이터를 받아올때 그 받아온 크기
    m_nReceiveByte: Integer;

    // 각화면에서 데이터를 서버에 요청한 후 에 그 번호에 해당하는 값을 통해 각 화면으로 데이터를 전송한다.
    // 각 배열의 각 요소는 CFNDataDelivery의 오브젝트가 들어 있고,
    // 이들 오브젝트는 각 화면들과 연결되어 있다. 나중에 데이터가 수신되면, 이곳에 있는 CFNDataDelivery의
    // 오브젝트를 참조해서 DeliveryReply를 호출해서 데이터를 전달한다.
    m_RQSubscribeTable: Array [0 .. MAX_SUBSCRIBE_TABLE_SIZE] of Pointer;

    // 현재 요청배열의 위치. 요청이 반복될 수 록 이 값은 1씩 증가한다.
    m_RQSubscribeIndex: Integer;

    m_RecoveryCount: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Initialize;
    procedure Finalize;
    procedure Resume;
    procedure Suspend;

    procedure ClearRequest(ADataDelivery: CFNDataDelivery);
    procedure DeleteRequest(ADataDelivery: CFNDataDelivery);

    // m_RecvThread 의 Protected 메소드 중하나인 StartWork()에서 이 함수를 호출한다.
    procedure StartRecvWork;

    // m_RecvThread 의 Protected 메소드 중하나인 DoWork()에서 이 함수를 호출한다.
    //
    //
    // 소켓의 접속상태를 확안한다. 소켓이 연결되어 있지 않으면 재접속을 시도한다.
    //
    // 소켓이 연결되었으면 m_TCPClient.ReceiveBuf을 호출한다.
    // m_TCPClient.ReceiveBuf을 호출할 때 파라메터로
    // m_TCPClient.ReceiveBuf(m_szReceiveData,  4096, 0)을 사용한다.
    //
    // m_TCPClient.ReceiveBuf를 호출한 후에 수신받은 데이터를 CFNReceiveData의 구조체로 포장한다.
    //
    // 이 구조체를 StoreRecvData 함수를 호출하여 m_RecvQueue에 저장한다.
    procedure DoRecvWork;

    // m_RecvThread 의 Protected 메소드 중하나인 EndWork()에서 이 함수를 호출한다.
    procedure EndRecvWork;

    // m_SendThread 의 Protected 메소드 중하나인 StartWork()에서 이 함수를 호출한다.
    procedure StartSendWork;

    // m_SendThread 의 Protected 메소드 중하나인 DoWork()에서 이 함수를 호출한다.
    procedure DoSendWork;

    // m_SendThread 의 Protected 메소드 중하나인 EndWork()에서 이 함수를 호출한다.
    procedure EndSendWork;

    // m_ProcThread 의 Protected 메소드 중하나인 StartWork()에서 이 함수를 호출한다.
    procedure StartProcWork;

    // m_ProcThread 의 Protected 메소드 중하나인 DoWork()에서 이 함수를 호출한다.
    procedure DoProcWork;

    // m_ProcThread 의 Protected 메소드 중하나인 EndWork()에서 이 함수를 호출한다.
    procedure EndProcWork;

    // m_Start의 값을 1로 설정한다.
    procedure Start;

    // m_Start의 값을 0으로 설정한다.
    procedure Stop;

    // m_Start의 값을 리턴한다.
    function GetState: Integer;

    // 소켓을 연결한다.
    procedure Connect;

    // 소켓의 연결을 종료한다.
    // 만약 연결이 되어 있다면 종료하기 전에 종료패킷을 전송한다.
    procedure Disconnect;
    procedure Disconnect2;

    // 소켓의 접속여부를 리턴한다.
    function GetConnected: Boolean;

    // RecvThread가 소켓에서 데이터를 읽는 중 소켓연결의 비정상적으로 종료됨을 감지하면 이 함수를 호출한다.
    // 이 함수에서는 다시 연결을 재시도 후 연결이 되면 RecorerySesstion()을 호출하여 스트리밍데이터를 재등록한다.
    procedure OnDisconnect;

    // 저장된 사용자아이디와 사용자패스워드를 이용하여 다시 로그인하고, 스트리밍 시세를 다시 등록한다.
    procedure RecoverySession;
    procedure RecoverySession2;

    // 소켓의 아이피와 포터를 설정한다.
    procedure SetServerProperty(AIP: String; APort: Integer);

    // 송수신에 관련된 모든 자료구조를 초기화하고, 변수들을 초기화 한다.
    procedure ClearAll;

    function ConvertStreamToReceiveData(AStream: TMemoryStream): pTFNReceiveData;

    // 버퍼를 전달하면 TFNReceiveData의 구조체에 담아서 리턴한다.
    function BufferToReceiveData(ABuffer: PAnsiChar; ASize: Integer): pTFNReceiveData;

    // 서로 다른 두개의 TFNReceiveData구조체안의 데이터를 하나에 붙여 넣느다.
    procedure ConcatenateRecvData(ASourceData: pTFNReceiveData; ATargetData: pTFNReceiveData);

    // ARecvPacketHandler에 들어 있는 ValueItem을 CFNStreamValue로 변환하여
    // CFNStreamRecord에 추가한다.
    // 이 때 CFNStreamRecord는 함수 안에서 새로 생성된다.
    function CreateStreamRecord(ARecvPacketHandler: CFNStreamPacketHandler): CFNStreamRecord;

    // 파라메터로 받은 AStreamRecord를 멤버변수인 m_STRecordList에 저장한다.
    procedure SaveStreamRecord(AStreamRecord: CFNStreamRecord);

    // m_STRecordList 에 저장되어있는 CFNStreamRecord 의 오브젝트 중
    // m_ReferenceCount의 수가 0인 것을 메모리에서 제거한다.
    // 이 메소드는 DoProcWork()의 마지막에 호출한다.
    procedure TrucateUnusedStreamRecord;

    // 조회성 데이터를 요청하기 위해 m_RQSubscribeTable 의 배열 인덱스
    // m_RQSubscribeIndex을 리턴한다.
    // 이때 m_RequestSubscribeIndex의 변수를 많은 쓰레드가 참조하므로 동기화를 해야한다.
    // 동기화는  m_RQSubscribeTableLock을 이용해서 한다.
    function GetRequestSubscribeIndex: Integer;

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
    function MakeStreamSubscribeKey(ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String): String;
    function GetStreamSubscribeKey(AKey: String; var ACountry: Integer; var AGroup: Integer; var AMarket: Integer;
        var ASymbol: String): Boolean;

    // 조회데이터의 전달할 CFNDelivery객체를 저장할 인덱스 m_RQSubscribeIndex를 가져온다. 이 후에 이값을 1 증가시킨다.
    // 배열의 크기가 1024이므로 m_RQSubscribeIndex의 값이 1024보다 크거나 같으면 0으로 초기화 한다.
    function GetRQSubscribeIndex: Integer;

    // m_RQSubscribeTable[AIndex]의 값을 ADataDelivery로 설정한다.
    procedure SetRQSubscribeObject(AIndex: Integer; ADataDelivery: CFNDataDelivery);

    // 조회성 데이터를 요청한다. ADataPackage의 해드중에 RequestID의 값을 m_RQSubscribeIndex의 값으로 설정한다.
    // m_RQSubscribeTable[m_RQSubscribeIndex]의 값을 ADataDelivery으로 설정한다.
    // 단위화면의 여러쓰레드가 동시해 접근할 수 있는 영역이다.
    // 따라서 이 메소드 에서는 멤버변수와 오브젝트의 사용을 피한다.
    // 만약 필히 접근해야 한다면 동기화를 하기 바란다.
    function Request(ADataDelivery: CFNDataDelivery; ADataPackage: CFNDataPackage): Boolean;

    // 스트리밍데이터 중 시세를 등록한다. 가장 첫번째 등록이면 서버에 등록을 요청한다.
    // MakeStreamSubscribeKey를 이용하여 키를 만들고 해당키의 오브젝트에 ADataDelivery을 등록한다.
    // 이 때 신규등록이면 서버에 등록패킷(SUBSCRIBE)를 전송한다.
    // 단위화면의 여러쓰레드가 동시해 접근할 수 있는 영역이다.
    // 따라서 이 메소드 에서는 멤버변수와 오브젝트의 사용을 피한다.
    // 만약 필히 접근해야 한다면 동기화를 하기 바란다.
    function SubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer;
        ASymbol: String): Boolean;

    // 스트리밍데이터 중 시세를 등록해지한다. 가장 마지막 등록해지이면 서버에 등록해지를 요청한다.
    // MakeStreamSubscribeKey를 이용하여 키를 만들고 해당키의 오브젝트에 ADataDelivery을 등록해지한다.
    // 이 때 마지막등록이면 서버에 등록해지패킷(SUBSCRIBE)를 전송한다.
    // 단위화면의 여러쓰레드가 동시해 접근할 수 있는 영역이다.
    // 따라서 이 메소드 에서는 멤버변수와 오브젝트의 사용을 피한다.
    // 만약 필히 접근해야 한다면 동기화를 하기 바란다.
    function UnSubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer;
        ASymbol: String): Boolean;

    // 스트리밍데이터 중 호가를 등록한다. 가장 첫번째 등록이면 서버에 등록을 요청한다.
    // MakeStreamSubscribeKey를 이용하여 키를 만들고 해당키의 오브젝트에 ADataDelivery을 등록한다.
    // 이 때 신규등록이면 서버에 등록패킷(SUBSCRIBE)를 전송한다.
    // 단위화면의 여러쓰레드가 동시해 접근할 수 있는 영역이다.
    // 따라서 이 메소드 에서는 멤버변수와 오브젝트의 사용을 피한다.
    // 만약 필히 접근해야 한다면 동기화를 하기 바란다.
    function SubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer;
        ASymbol: String): Boolean;

    // 스트리밍데이터 중 호가를 등록해지 한다. 가장 마지막 등록해지이면 서버에 등록해지를 요청한다.
    // MakeStreamSubscribeKey를 이용하여 키를 만들고 해당키의 오브젝트에 ADataDelivery을 등록해지한다.
    // 이 때 마지막등록이면 서버에 등록해지패킷(SUBSCRIBE)를 전송한다.
    // 단위화면의 여러쓰레드가 동시해 접근할 수 있는 영역이다.
    // 따라서 이 메소드 에서는 멤버변수와 오브젝트의 사용을 피한다.
    // 만약 필히 접근해야 한다면 동기화를 하기 바란다.
    function UnSubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer;
        ASymbol: String): Boolean;

    function SubscribeSignal(ADataDelivery: CFNDataDelivery; ASessionKey: String): Boolean;
    function UnSubscribeSignal(ADataDelivery: CFNDataDelivery; ASessionKey: String): Boolean;

    // 해당 클래스로 등록되어 있는 스트리밍데이터를 모두 해지한다.
    // 단위화면의 여러쓰레드가 동시해 접근할 수 있는 영역이다.
    // 따라서 이 메소드 에서는 멤버변수와 오브젝트의 사용을 피한다.
    // 만약 필히 접근해야 한다면 동기화를 하기 바란다.
    procedure UnSubscribeAll(ADataDelivery: CFNDataDelivery);

    procedure ReSubscribeAll;

    function SendDisconnectPacket: Boolean;

  private

    // 클라이언트 소켓인 m_TCPClient 에서 데이터를 읽어  버퍼에 복사한다.
    // 이때 읽은 바이트수를 리턴한다. 소켓이 연결되어 있지 않으면 -1을 리턴한다.
    function ReadBufferFromSocket(ABuffer: PAnsiChar; AMaxSize: Integer): Integer;

    // 클라이언트 소켓인 m_TCPClient 에서 데이터를 보낸다.
    function WriteBufferToSocket(ABuffer: PAnsiChar; ASize: Integer): Boolean;

    // 수신큐인 m_RecvQueue에 데이터를 저장한다.
    procedure StoreRecvData(AReceiveData: pTFNReceiveData);

    // 수신큐인 m_RecvQueue에서 데이터 꺼내 온다.
    function RetrieveRecvData: pTFNReceiveData;

    // 송신큐인 m_SendQueue 에 데이터를 저장한다.
    procedure StoreSendData(ASendData: pTFNReceiveData);

    // 송신큐인 m_SendQueue 에서 데이터를 꺼내온다.
    function RetrieveSendData: pTFNReceiveData;

    // 크기가 ASourceSize인 문자열 ASource에서 크기가  AFindSize 인 문자열 AFind을 찾는 함수이다.
    // 찾지 못하면 -1을 찾으면 찾았을 때 가장 처음 바이트의 위치이다.
    // 즉 0에서 ASourceSize-AFindSize 까지의 값을 가질 수 있다. -1은 못찾을 경우
    // var
    // g_Header : array [0..4] of char = ('B', 'O', 'P', #$0D, #$0A);
    // g_Footer : array [0..4] of char = ('E', 'O', 'P', #$0D, #$0A);
    //
    // g_HeaderSize : integer = 5;
    // g_FooterSize : integer = 5;
    function SearchHeader(ASource: PAnsiChar; AFind: PAnsiChar; ASourceSize: Integer; AFindSize: Integer): Integer;

    // 크기가 ASourceSize인 문자열 ASource에서 크기가  AFindSize 인 문자열 AFind을 찾는 함수이다.
    // 찾지 못하면 -1을 찾으면 찾았을 때 가장 마직막 바이트의 위치이다.
    // 즉 AFindSize에서 ASourceSize까지의 값을 가질 수 있다. -1은 못찾을 경우
    // var
    // g_Header : array [0..4] of char = ('B', 'O', 'P', #$0D, #$0A);
    // g_Footer : array [0..4] of char = ('E', 'O', 'P', #$0D, #$0A);
    //
    // g_HeaderSize : integer = 5;
    // g_FooterSize : integer = 5;
    function SearchFooter(ASource: PAnsiChar; AFind: PAnsiChar; ASourceSize: Integer; AFindSize: Integer): Integer;

    // AReceiveData에서 'BOP\r\n'로 시작해서 'EOP\r\n'으로 끝나는 데이터를 추출해서  AExtractedPacket에 담는다.
    // 해당하는 패킷이 존재하면 true를 리터하고, 존재하지 않으면 false를 리턴한다.
    // 패킷해드와 풋은 상수로 선언해서 사용한다.
    // var
    // g_Header : array [0..4] of char = ('B', 'O', 'P', #$0D, #$0A);
    // g_Footer : array [0..4] of char = ('E', 'O', 'P', #$0D, #$0A);
    //
    // g_HeaderSize : integer = 5;
    // g_FooterSize : integer = 5;
    function ExtractPacket(AReceiveData: pTFNReceiveData; AExtractedPacket: pTFNReceiveData): Boolean;

    // 추출된 데이터를 이용하여 분석한다.
    procedure ProcessPacket(AExtractedPacket: pTFNReceiveData);

    // 조회성데이터를 수신했을 때 호출된다.
    // 함수 내부에서는 조회성데이터를 CFNDataPackage를 이용해서 자료구조로 변환하다.
    procedure OnRecvRequestData(AReceiveData: pTFNReceiveData);

    // 스트리밍 데이터를 수신했을 때 호출된다. 함수 내부에서는 스트리밍데이터를 디코딩해서
    // 그 Packet Key의 값에 따라 OnRecvDisconnect(), OnRecvHeartBit(), OnRecvQuote(), OnRecvBidOffer()를 호출한다.
    procedure OnRecvStreamData(AReceiveData: pTFNReceiveData);

    // 스트리밍데이터중 Packet Key가 'DISCONNECT'인 경우 이 함수를 호출한다.
    procedure OnRecvDisconnect(ARecvPacketHandler: CFNStreamPacketHandler);

    // 스트리밍데이터중 Packet Key가 'HEARTBIT'인 경우 이 함수를 호출한다.
    // 함수 내부에서는 서버로 재전송한다.
    // 이때 수신한 패킷데이터중 Key 1에 해당하는 값이 'PING'일 때에만
    // Key 2의 값으로 'PONG'를 전달하면 된다.
    procedure OnRecvHeartBit(ARecvPacketHandler: CFNStreamPacketHandler);

    // 스트리밍데이터 중 Packet Key가 'QUOTE'인 경우 이 함수를 호출한다.
    // 이 함수 내부에서는 패킷의 모든 값을 하나 하나 CFNStreamValue으로 변환하고
    // CFNStreamRecord에 해당 키로 추가한다.
    // 이 CFNStreamRecord을 m_LookUpTable[0]에 등록된 화면으로 전달한다
    procedure OnRecvQuote(ARecvPacketHandler: CFNStreamPacketHandler);
    procedure OnRecvSignal(ARecvPacketHandler: CFNStreamPacketHandler);

    // 스트리밍데이터 중 Packet Key가 BIDASK'인 경우 이 함수를 호출한다.
    // 이 함수 내부에서는 패킷의 모든 값을 하나 하나 CFNStreamValue으로 변환하고
    // CFNStreamRecord에 해당 키로 추가한다.
    // 이 CFNStreamRecord을 m_LookUpTable[1]에 등록된 화면으로 전달한다
    procedure OnRecvBidOffer(ARecvPacketHandler: CFNStreamPacketHandler);

  private
    FStatus: TIdStatus;

    procedure OnSocketConnect(Sender: TObject);
    procedure OnSocketDisconnect(Sender: TObject);
    procedure SocketStatus(ASender: TObject; const aStatus: TIdStatus; const AStatusText: string);
    procedure SocketError(Sender: TObject; stError: String);

  public

    // 접속이 종료되었을 때, 서버에서 접속을 해지 했는지, 아니면 비정상적으로 해지했는지,
    // 아니면 사용자가 해지 했는지의 정보를 저장한다.
    // normal   : 정상적으로 종료되었음을 가르키고, 클라이언트에서 Disconnect를 호출할 경우
    // abnormal : 서버에서 일방적으로 종료되었을 경우, 인터넷의 불량으로 인한 연결
    // relogin  : 서버에서 동일 사용자 접속시 현재 연결이 종료된경우
    m_DisConnectState: String;
    property ServerIP: String read m_ServerIP write m_ServerIP;
    property OnSocketEvent: TFNSocketEvent read m_OnSocketEvent write m_OnSocketEvent;
    property EnableEvent: Boolean read m_EnableEvent write m_EnableEvent;
  end;

var

  g_EnableStreamData: Boolean = false;

  // ---------------------------------------------------------------------------
implementation

uses FNGlobal, FNGlobalVariable, WideStrUtils, FNCMVariable;

// ---------------------------------------------------------------------------
// 쓰레드가 가장 먼저 실행메소드
procedure CFNRecvThread.StartWork;
begin
  inherited StartWork;

  if Assigned(m_Manager) then
  begin
    m_Manager.StartRecvWork;
  end;
end;

// ---------------------------------------------------------------------------
// 쓰레드가 가장 마지막에 실행하는 메소드
procedure CFNRecvThread.EndWork;
begin
  if Assigned(m_Manager) then
  begin
    m_Manager.EndRecvWork;
  end;

  inherited EndWork;
end;

// ---------------------------------------------------------------------------
// 쓰레드가 루프를 돌면서 실행하는 메소드
procedure CFNRecvThread.DoWork;
var
  f_State: Integer;
begin
  if Assigned(m_Manager) then
  begin
    f_State := m_Manager.GetState;
    if THREAD_START = f_State then
    begin
      m_Working := True;

      m_Manager.DoRecvWork;
    end;
  end;

  m_Working := false;
end;

// ---------------------------------------------------------------------------
// 소켓메니저를 설정한다.
procedure CFNRecvThread.SetManager(AManager: CFNSocketManager);
begin
  m_Manager := AManager;
end;

/// //////////////////////////////////////////////////////////////////////////
// ---------------------------------------------------------------------------
// 쓰레드가 가장 먼저 실행메소드
procedure CFNSendThread.StartWork;
begin
  inherited StartWork;

  if Assigned(m_Manager) then
  begin
    m_Manager.StartSendWork;
  end;
end;

// ---------------------------------------------------------------------------
// 쓰레드가 가장 마지막에 실행하는 메소드
procedure CFNSendThread.EndWork;
begin
  if Assigned(m_Manager) then
  begin
    m_Manager.EndSendWork;
  end;

  inherited EndWork;
end;

// ---------------------------------------------------------------------------
// 쓰레드가 루프를 돌면서 실행하는 메소드
procedure CFNSendThread.DoWork;
var
  f_State: Integer;
begin
  if Assigned(m_Manager) then
  begin
    f_State := m_Manager.GetState;
    if THREAD_START = f_State then
    begin
      m_Working := True;
      m_Manager.DoSendWork;
    end;
  end;

  m_Working := false;
end;

// ---------------------------------------------------------------------------
// 소켓메니저를 설정한다.
procedure CFNSendThread.SetManager(AManager: CFNSocketManager);
begin
  m_Manager := AManager;
end;

/// //////////////////////////////////////////////////////////////////////////
// ---------------------------------------------------------------------------
// 쓰레드가 가장 먼저 실행메소드
procedure CFNProcThread.StartWork;
begin
  inherited StartWork;

  if Assigned(m_Manager) then
  begin
    m_Manager.StartProcWork;
  end;
end;

// ---------------------------------------------------------------------------
// 쓰레드가 가장 마지막에 실행하는 메소드
procedure CFNProcThread.EndWork;
begin
  if Assigned(m_Manager) then
  begin
    m_Manager.EndProcWork;
  end;

  inherited EndWork;
end;

// ---------------------------------------------------------------------------
// 쓰레드가 루프를 돌면서 실행하는 메소드
procedure CFNProcThread.DoWork;
var
  f_State: Integer;
begin
  if Assigned(m_Manager) then
  begin
    f_State := m_Manager.GetState;
    if THREAD_START = f_State then
    begin
      m_Working := True;

      m_Manager.DoProcWork;
    end;
  end;

  m_Working := false;
end;

// ---------------------------------------------------------------------------
// 소켓메니저를 설정한다.
procedure CFNProcThread.SetManager(AManager: CFNSocketManager);
begin
  m_Manager := AManager;
end;

/// //////////////////////////////////////////////////////////////////////////
// ---------------------------------------------------------------------------
// 생성자
constructor CFNSocketManager.Create;
begin
  inherited Create;

  m_EnableEvent := True;
  m_RecoveryCount := 0;

  m_ReceiveHeartBitTime := Now;

  Initialize;

  m_RecvThread := CFNRecvThread.Create;
  m_SendThread := CFNSendThread.Create;
  m_ProcThread := CFNProcThread.Create;

  m_RecvThread.SetSleepTime(10);
  m_SendThread.SetSleepTime(10);
  m_ProcThread.SetSleepTime(10);

  m_RecvThread.SetManager(Self);
  m_SendThread.SetManager(Self);
  m_ProcThread.SetManager(Self);

  m_DisConnectState := 'abnormal';
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CFNSocketManager.Destroy;
var
  nTry: Integer;
begin
  Stop;
  Disconnect;

  // m_RecvThread
  if Assigned(m_RecvThread) then
  begin
    // m_RecvThread.SetManager(NIL);
    m_RecvThread.StopThread;
  end;
  nTry := 0;
  while Assigned(m_RecvThread) do
  begin
    if (not m_RecvThread.Finished) then
    begin
      m_RecvThread.StopThread;
      Inc(nTry);
      if (nTry > 50) then
      begin
        m_RecvThread.ExitThread;
        m_RecvThread.Free;
        m_RecvThread := NIL;
        break;
      end;
    end
    else
    begin
      m_RecvThread.Free;
      m_RecvThread := NIL;
      break;
    end;
    Sleep(100);
  end;

  // m_SendThread
  if Assigned(m_SendThread) then
  begin
    // m_SendThread.SetManager(NIL);
    m_SendThread.StopThread;
  end;
  nTry := 0;
  while Assigned(m_SendThread) do
  begin
    if (not m_SendThread.Finished) then
    begin
      m_SendThread.StopThread;
      Inc(nTry);
      if (nTry > 50) then
      begin
        m_SendThread.ExitThread;
        m_SendThread.Free;
        m_SendThread := NIL;
        break;
      end;
    end
    else
    begin
      m_SendThread.Free;
      m_SendThread := NIL;
      break;
    end;
    Sleep(100);
  end;

  // m_ProcThread
  if Assigned(m_ProcThread) then
  begin
    // m_ProcThread.SetManager(NIL);
    m_ProcThread.StopThread;
  end;
  nTry := 0;
  while Assigned(m_ProcThread) do
  begin
    if (not m_ProcThread.Finished) then
    begin
      m_ProcThread.StopThread;
      Inc(nTry);
      if (nTry > 50) then
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
    Sleep(100);
  end;

  Finalize;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 내부 변수및 오브젝트를 생성한다.
procedure CFNSocketManager.Initialize;
begin
  m_SocketLock := TCriticalSection.Create;
  m_TCPClient := TIdTCPClient.Create(NIL);
  m_TCPClient.ReadTimeout := 50;
  m_RecvQueue := CFNQueue.Create;
  m_SendQueue := CFNQueue.Create;

  m_STSubscribeTable[0] := CFNMultiMap.Create; // 시세
  m_STSubscribeTable[0].SetAutoFree(false);

  m_STSubscribeTable[1] := CFNMultiMap.Create; // 호가
  m_STSubscribeTable[1].SetAutoFree(false);

  m_STSubscribeTable[2] := CFNMultiMap.Create; // 신호
  m_STSubscribeTable[2].SetAutoFree(false);

  m_STRecordList := TObjectList.Create;

  m_STSubscribeTableLock := TCriticalSection.Create;
  m_RQSubscribeTableLock := TCriticalSection.Create;

  m_STProcPacketHandler := CFNStreamPacketHandler.Create;
  m_PacketHandler := CFNPacketHandler.Create;

  // 변수들 초기화
  m_State := THREAD_STOP;
  m_nReceiveByte := 0;
  m_RQSubscribeIndex := 0;

  m_TCPClient.OnConnected := OnSocketConnect;
  m_TCPClient.OnDisconnected := OnSocketDisconnect;
  m_TCPClient.OnStatus := SocketStatus;
end;

// ---------------------------------------------------------------------------
// 내부 변수및 오브젝트를 파괴한다.
procedure CFNSocketManager.Finalize;
begin
  ClearAll;

  if Assigned(m_RecvQueue) then
  begin
    FreeAndNil(m_RecvQueue);
    m_RecvQueue := NIL;
  end;

  if Assigned(m_SendQueue) then
  begin
    FreeAndNil(m_SendQueue);
    m_SendQueue := NIL;
  end;

  m_STSubscribeTableLock.Enter;
  try
    if Assigned(m_STSubscribeTable[0]) then
    begin
      FreeAndNil(m_STSubscribeTable[0]);
      m_STSubscribeTable[0] := NIL;
    end;
    if Assigned(m_STSubscribeTable[1]) then
    begin
      FreeAndNil(m_STSubscribeTable[1]);
      m_STSubscribeTable[1] := NIL;
    end;
    if Assigned(m_STSubscribeTable[2]) then
    begin
      FreeAndNil(m_STSubscribeTable[2]);
      m_STSubscribeTable[2] := NIL;
    end;
  finally
    m_STSubscribeTableLock.Leave;
  end;

  if Assigned(m_STRecordList) then
  begin
    FreeAndNil(m_STRecordList);
    m_STRecordList := NIL;
  end;

  if Assigned(m_STSubscribeTableLock) then
  begin
    FreeAndNil(m_STSubscribeTableLock);
    m_STSubscribeTableLock := NIL;
  end;

  if Assigned(m_RQSubscribeTableLock) then
  begin
    FreeAndNil(m_RQSubscribeTableLock);
    m_RQSubscribeTableLock := NIL;
  end;

  if Assigned(m_STProcPacketHandler) then
  begin
    FreeAndNil(m_STProcPacketHandler);
    m_STProcPacketHandler := NIL;
  end;

  if Assigned(m_PacketHandler) then
  begin
    FreeAndNil(m_PacketHandler);
    m_PacketHandler := NIL;
  end;

  m_SocketLock.Enter;
  try
    if Assigned(m_TCPClient) then
    begin
      FreeAndNil(m_TCPClient);
      m_TCPClient := NIL;
    end;
  finally
    m_SocketLock.Leave;
  end;

  if Assigned(m_SocketLock) then
  begin
    FreeAndNil(m_SocketLock);
    m_SocketLock := NIL;
  end;

  m_State := THREAD_STOP;
  m_nReceiveByte := 0;
  m_RQSubscribeIndex := 0;
end;

// ---------------------------------------------------------------------------
// 내부의 모든 쓰레드를 시작한다.
procedure CFNSocketManager.Resume;
begin
  if Assigned(m_RecvThread) then
    m_RecvThread.Resume;

  if Assigned(m_SendThread) then
    m_SendThread.Resume;

  if Assigned(m_ProcThread) then
    m_ProcThread.Resume;
end;

// ---------------------------------------------------------------------------
// 내부의 모든 쓰레드를 잠시 멈춘다.
procedure CFNSocketManager.Suspend;
begin
  if not m_RecvThread.Suspended then
    m_RecvThread.Suspend;

  if not m_SendThread.Suspended then
    m_SendThread.Suspend;

  if not m_ProcThread.Suspended then
    m_ProcThread.Suspend;
end;

// ---------------------------------------------------------------------------
// m_RecvThread 의 Protected 메소드 중하나인 StartWork()에서 이 함수를 호출한다.
procedure CFNSocketManager.StartRecvWork;
begin

end;

// ---------------------------------------------------------------------------
// m_RecvThread 의 Protected 메소드 중하나인 DoWork()에서 이 함수를 호출한다.
//
//
// 소켓의 접속상태를 확안한다. 소켓이 연결되어 있지 않으면 재접속을 시도한다.
//
// 소켓이 연결되었으면 m_TCPClient.ReceiveBuf을 호출한다.
// m_TCPClient.ReceiveBuf을 호출할 때 파라메터로
// m_TCPClient.ReceiveBuf(m_szReceiveData,  4096, 0)을 사용한다.
//
// m_TCPClient.ReceiveBuf를 호출한 후에 수신받은 데이터를 CFNReceiveData의 구조체로 포장한다.
//
// 이 구조체를 StoreRecvData 함수를 호출하여 m_RecvQueue에 저장한다.
procedure CFNSocketManager.DoRecvWork;
var
  f_ReceiveByte: Integer;
  f_pReceiveData: pTFNReceiveData;
begin
  m_SocketLock.Enter;
  try
    // 2. 소켓 연결상태를 확인한다.
    if Assigned(m_TCPClient) and m_TCPClient.Connected then
    begin
      try
        // 3. 소켓 읽는다.
        // f_ReceiveByte := m_TCPClient.ReceiveBuf(m_szReceiveData, MAX_READ_BUFFER_SIZE, 0);
        f_ReceiveByte := ReadBufferFromSocket(m_szReceiveData, MAX_READ_BUFFER_SIZE);
        if (0 < f_ReceiveByte) then
        begin
          // 4. 소켓에서 읽은 데이터를 pTFNReceiveData 구조체로 새로 생성한다.
          f_pReceiveData := BufferToReceiveData(m_szReceiveData, f_ReceiveByte);
          if Assigned(f_pReceiveData) then
          begin
            // 5. pTFNReceiveData 포인터를 m_RecvQueue 넣는다.
            StoreRecvData(f_pReceiveData);
          end;
        end
        else
        begin
          // 소켓연결이 끈겼는경우
          // OnDisconnect;

        end;
      except
        // 예외처리
        // LOG_ERROR(['CFNSocketManager.DoRecvWork - 수신큐 스레드 오류']);
      end;
    end;
  finally
    m_SocketLock.Leave;
  end;

  if m_ReceiveHeartBitTime <> 0 then
  begin
    if (Now - m_ReceiveHeartBitTime) * 86400 > 60 then
    begin
      Disconnect();
      m_DisConnectState := 'abnormal';
      m_ReceiveHeartBitTime := Now + 30.0 / 86400.0;
      OnSocketDisconnect(Self);
    end;
  end;
end;

// ---------------------------------------------------------------------------
// m_RecvThread` 의 Protected 메소드 중하나인 EndWork()에서 이 함수를 호출한다.
procedure CFNSocketManager.EndRecvWork;
begin

end;

// ---------------------------------------------------------------------------
// m_SendThread 의 Protected 메소드 중하나인 StartWork()에서 이 함수를 호출한다.
procedure CFNSocketManager.StartSendWork;
begin

end;

// ---------------------------------------------------------------------------
// m_SendThread 의 Protected 메소드 중하나인 DoWork()에서 이 함수를 호출한다.
procedure CFNSocketManager.DoSendWork;
var
  f_pSendData: pTFNReceiveData;
begin
  m_SocketLock.Enter;
  try
    // 1. 소켓 연결상태를 확인한다.
    if Assigned(m_TCPClient) and m_TCPClient.Connected then
    begin
      f_pSendData := NIL;
      try
        // 2. m_SendQueue 에서 pTFNReceiveData 하나 꺼낸다.
        f_pSendData := pTFNReceiveData(m_SendQueue.Retrieve);
        if Assigned(f_pSendData) then
        begin

          // 3. m_SendQueue 에서 꺼낸 pTFNReceiveData 를 전송한다.
          WriteBufferToSocket(f_pSendData^.m_Data, f_pSendData^.m_Size);

          // 4. 전송한뒤  pTFNReceiveData 포인터는 삭제해준다.
          if Assigned(f_pSendData) then
          begin
            if 0 < f_pSendData^.m_Size then
            begin
              FreeMem(f_pSendData^.m_Data);
              f_pSendData^.m_Size := 0;
            end;
            Dispose(f_pSendData);
            f_pSendData := NIL;
          end;

          // 데이터를 송신했다고 이벤트를 발생한다.
          if m_EnableEvent then
            if (Assigned(m_OnSocketEvent)) then
              m_OnSocketEvent(SOCKEVENT_SEND);

        end;
      except
        // LOG_ERROR(['CFNSocketManager.DoSendWork - 송신큐 스레드 오류']);

        if Assigned(f_pSendData) then
          Dispose(f_pSendData);
      end;
    end;
  finally
    m_SocketLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// m_SendThread 의 Protected 메소드 중하나인 EndWork()에서 이 함수를 호출한다.
procedure CFNSocketManager.EndSendWork;
begin

end;

// ---------------------------------------------------------------------------
// m_ProcThread 의 Protected 메소드 중하나인 StartWork()에서 이 함수를 호출한다.
procedure CFNSocketManager.StartProcWork;
begin

end;

// ---------------------------------------------------------------------------
// m_ProcThread 의 Protected 메소드 중하나인 DoWork()에서 이 함수를 호출한다.
procedure CFNSocketManager.DoProcWork;
var
  f_pReceiveData: pTFNReceiveData;

  f_list: TList;
  f_listIdx: Integer;
begin
  m_SocketLock.Enter;
  try
    if Assigned(m_TCPClient) and m_TCPClient.Connected then
    begin
      // 1. 리시브 큐에서 꺼낸다.
      f_list := TList.Create;
      m_RecvQueue.ManyRetrieve(f_list, m_RecvQueue.GetCount);
      for f_listIdx := 0 to f_list.Count - 1 do
      begin
        f_pReceiveData := pTFNReceiveData(f_list.Items[f_listIdx]);
        if Assigned(f_pReceiveData) then
        begin

          // 2. 패킷 결합
          ConcatenateRecvData(f_pReceiveData, @m_ReceiveData);

          // 3. 패킷 추출
          ReallocMem(m_ExtractPacket.m_Data, 0);
          m_ExtractPacket.m_Data := NIL;
          m_ExtractPacket.m_Size := 0;
          while (ExtractPacket(@m_ReceiveData, @m_ExtractPacket)) do
          begin

            // 4. 실제 처리
            ProcessPacket(@m_ExtractPacket);

          end;

          // 5. 전송한뒤  pTFNReceiveData 포인터는 삭제해준다.
          if Assigned(f_pReceiveData) then
          begin
            if (Assigned(f_pReceiveData^.m_Data)) and (0 < f_pReceiveData^.m_Size) then
            begin
              FreeMem(f_pReceiveData^.m_Data);
              f_pReceiveData^.m_Size := 0;
            end;

            Dispose(f_pReceiveData);
          end;

          // 6.
          TrucateUnusedStreamRecord;
        end;
      end;

      f_list.Free;
    end;
  finally
    m_SocketLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// m_ProcThread 의 Protected 메소드 중하나인 EndWork()에서 이 함수를 호출한다.
procedure CFNSocketManager.EndProcWork;
begin

end;

// ---------------------------------------------------------------------------
// m_State의 값을 1로 설정한다.
procedure CFNSocketManager.Start;
begin
  m_State := THREAD_START;
end;

// ---------------------------------------------------------------------------
// m_State의 값을 0으로 설정한다.
procedure CFNSocketManager.Stop;
begin
  m_State := THREAD_STOP;
end;

// ---------------------------------------------------------------------------
// m_State의 값을 리턴한다.
function CFNSocketManager.GetState: Integer;
begin
  Result := m_State;
end;

// ---------------------------------------------------------------------------
// 소켓을 연결한다.
procedure CFNSocketManager.Connect;
begin
  m_SocketLock.Enter;
  try
    if Assigned(m_TCPClient) and not m_TCPClient.Connected then
    begin
      m_TCPClient.Host := m_ServerIP;
      m_TCPClient.Port := m_Port;
      try
        m_TCPClient.Connect;
      except
      end;
    end;
  finally
    m_SocketLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// 소켓의 연결을 종료한다.
// 만약 연결이 되어 있다면 종료하기 전에 종료패킷을 전송한다.
procedure CFNSocketManager.Disconnect;
var
  f_PacketHandler: CFNPacketHandler;
  f_StreamPacketHandler: CFNStreamPacketHandler;
  f_pSendData: pTFNReceiveData;
begin
  m_SocketLock.Enter;
  try
    if Assigned(m_TCPClient) and m_TCPClient.Connected then
    begin
      // 사용자가 접속해지를 했을 당시 비정상적으로 설정되어 있을 경우에만
      // 사용자가 접속을 해지했다고 볼 수 있다.
      // 아니면 이미 사용자가 접속해지를 선택하기 전에 서버에서 다른이유로 접속을 해지했을 경우
      // 를 제외시키기 위한 방법이다.
      if (AnsiCompareText(m_DisConnectState, 'abnormal') = 0) then
      begin
        m_DisConnectState := 'normal';
      end;
      f_PacketHandler := CFNPacketHandler.Create;
      f_PacketHandler.SetPacketType('0');
      f_PacketHandler.SetCompress(false);
      f_PacketHandler.SetEncryption(false);

      // =========================
      // 종료 패킷보내는루틴 필요하다.
      f_StreamPacketHandler := CFNStreamPacketHandler.Create;
      f_StreamPacketHandler.ClearAll;
      f_StreamPacketHandler.SetPacketKey('DISCONNECT');
      f_StreamPacketHandler.AddValueItem_AnsiChar('1', 'DISCONNECT');
      f_StreamPacketHandler.EncodeFrameData;

      f_PacketHandler.Write(f_StreamPacketHandler.m_Stream.m_Data^, f_StreamPacketHandler.m_Stream.GetFileSize);

      // 5. 스트리밍 패킷을 pTFNReceiveData 데이터로 변경
      f_pSendData := ConvertStreamToReceiveData(f_PacketHandler.m_EncodeStream);

      // 6. m_SendQueue에 저장
      StoreSendData(f_pSendData);

      // 7. 사용한 데이터는 삭제
      f_StreamPacketHandler.ClearAll;
      f_StreamPacketHandler.Free;

      f_PacketHandler.Clear;
      f_PacketHandler.Free;

      // =========================
      Sleep(100);
      m_TCPClient.Disconnect;

    end;
  finally
    m_SocketLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// 소켓의 연결을 종료한다.
// 만약 연결이 되어 있다면 종료하기 전에 종료패킷을 전송한다.
procedure CFNSocketManager.Disconnect2;
var
  f_PacketHandler: CFNPacketHandler;
  f_StreamPacketHandler: CFNStreamPacketHandler;
  f_pSendData: pTFNReceiveData;
begin
  m_SocketLock.Enter;
  try
    if Assigned(m_TCPClient) and m_TCPClient.Connected then
    begin
      m_TCPClient.Disconnect;
    end;
  finally
    m_SocketLock.Leave;
  end;
end;
// ---------------------------------------------------------------------------
// 소켓의 접속여부를 리턴한다.
function CFNSocketManager.GetConnected: Boolean;
begin
  Result := false;
  m_SocketLock.Enter;
  try
    if Assigned(m_TCPClient) then
    begin
      Result := m_TCPClient.Connected;
    end;
  finally
    m_SocketLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// RecvThread가 소켓에서 데이터를 읽는 중 소켓연결의 비정상적으로 종료됨을 감지하면 이 함수를 호출한다.
// 이 함수에서는 다시 연결을 재시도 후 연결이 되면 RecorerySesstion()을 호출하여 스트리밍데이터를 재등록한다.
/// /////////////////////////////////////////////////////////////////////////////
// 김무근-재연결을 하지 않음// 메인에 접속이 비정상으로 종료되었다고 이벤트 보냄
// 추후 재연결을 메인에서 처리하도록 한다.
procedure CFNSocketManager.OnDisconnect;
begin
  m_SocketLock.Enter;
  try
    if Assigned(m_TCPClient) then
    begin
      m_TCPClient.Disconnect;
    end;
  finally
    m_SocketLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// 저장된 사용자아이디와 사용자패스워드를 이용하여 다시 로그인하고, 스트리밍 시세를 다시 등록한다.
procedure CFNSocketManager.RecoverySession;
var
  f_Index: Integer;
  f_OnSocketEvent: TFNSocketEvent;
begin
  if m_RecoveryCount >= 256 then
    exit;

  m_SocketLock.Enter;
  try

    f_OnSocketEvent := m_OnSocketEvent;
    m_OnSocketEvent := NIL;
    m_TCPClient.OnDisconnected := NIL;

    try
      m_TCPClient.Disconnect;
      m_TCPClient.Host := m_ServerIP;
      m_TCPClient.Port := m_Port;
      try
        m_TCPClient.Connect;
        Sleep(1000);
      except
      end;

      if (m_TCPClient.Connected) then
      begin
        ReSubscribeAll;
      end;

    finally
      m_OnSocketEvent := f_OnSocketEvent;
      m_TCPClient.OnDisconnected := OnSocketDisconnect;
    end;

  finally
    m_SocketLock.Leave;
  end;

  Inc(m_RecoveryCount);
end;

procedure CFNSocketManager.RecoverySession2;
var
  f_Index: Integer;
  f_OnSocketEvent: TFNSocketEvent;
begin

  m_SocketLock.Enter;
  try

    f_OnSocketEvent := m_OnSocketEvent;
    m_OnSocketEvent := NIL;
    m_TCPClient.OnDisconnected := NIL;

    try
      m_TCPClient.Disconnect;
      m_TCPClient.Host := m_ServerIP;
      m_TCPClient.Port := m_Port;

      try
        m_TCPClient.Connect;
        Sleep(1000);
      except
      end;

      if (m_TCPClient.Connected) then
      begin
        ReSubscribeAll;
      end;

    finally
      m_OnSocketEvent := f_OnSocketEvent;
      m_TCPClient.OnDisconnected := OnSocketDisconnect;
    end;
  finally
    m_SocketLock.Leave;
  end;

end;

// ---------------------------------------------------------------------------
// 소켓의 아이피와 포터를 설정한다.
procedure CFNSocketManager.SetServerProperty(AIP: String; APort: Integer);
begin
  m_ServerIP := AIP;
  m_Port := APort;
end;

// ---------------------------------------------------------------------------
// 송수신에 관련된 모든 자료구조를 초기화하고, 변수들을 초기화 한다.
procedure CFNSocketManager.ClearAll;
var
  pQueueData: pTFNReceiveData;
begin
  if (NIL <> m_ReceiveData.m_Data) and (0 < m_ReceiveData.m_Size) then
  begin
    ReallocMem(m_ReceiveData.m_Data, 0);
    m_ReceiveData.m_Data := NIL;
    m_ReceiveData.m_Size := 0;
  end;

  if (NIL <> m_ExtractPacket.m_Data) and (0 < m_ExtractPacket.m_Size) then
  begin
    ReallocMem(m_ExtractPacket.m_Data, 0);
    m_ExtractPacket.m_Data := NIL;
    m_ExtractPacket.m_Size := 0;
  end;

  // m_RecvQueue.Clear;
  while 0 < m_RecvQueue.GetCount do
  begin
    pQueueData := pTFNReceiveData(m_RecvQueue.Retrieve);
    if Assigned(pQueueData) then
    begin
      if 0 < pQueueData^.m_Size then
      begin
        FreeMem(pQueueData^.m_Data);
        pQueueData^.m_Size := 0;
      end;
      Dispose(pQueueData);
    end;
  end;

  // m_SendQueue.Clear;
  while 0 < m_SendQueue.GetCount do
  begin
    pQueueData := pTFNReceiveData(m_SendQueue.Retrieve);
    if Assigned(pQueueData) then
    begin
      if 0 < pQueueData^.m_Size then
      begin
        FreeMem(pQueueData^.m_Data);
        pQueueData^.m_Size := 0;
      end;
      Dispose(pQueueData);
    end;
  end;

  m_STSubscribeTableLock.Enter;
  try
    m_STSubscribeTable[0].Clear(True);
    m_STSubscribeTable[1].Clear(True);
    m_STSubscribeTable[2].Clear(True);
  finally
    m_STSubscribeTableLock.Leave;
  end;

  // m_STRecordList.Clear;
end;

// ---------------------------------------------------------------------------
// 레코드 TFNReceiveData를 하나 생성한다.
// 메모리크기가 APacket의 GetFileSize()인 메모리를 활당한다.
// APacket에 들어 있는 내용을 모두 새로 활당한 메모리에 복사한다.
// TFNReceiveData의 m_Data를 신규로 활당한 메모리의 포인터로 설정하고,
// m_Size를 APacket의 GetFileSize()로 설정한다.
function CFNSocketManager.ConvertStreamToReceiveData(AStream: TMemoryStream): pTFNReceiveData;
var
  f_RecvData: pTFNReceiveData;
begin
  f_RecvData := NIL;

  try
    if Assigned(AStream) then
    begin
      New(f_RecvData);
      f_RecvData^.m_Data := NIL;
      f_RecvData^.m_Size := 0;

      ReallocMem(f_RecvData^.m_Data, AStream.Size);
      TFNGlobal.memcpy(f_RecvData^.m_Data, AStream.Memory, AStream.Size);
      f_RecvData^.m_Size := AStream.Size;
    end;
  except
    // LOG_ERROR(['CFNSocketManager.ConvertMFileToReceiveData - 오류']);

    if Assigned(f_RecvData) then
    begin
      if 0 < f_RecvData^.m_Size then
      begin
        FreeMem(f_RecvData^.m_Data);
        f_RecvData^.m_Size := 0;
      end;

      Dispose(f_RecvData);
    end;
  end;

  Result := f_RecvData;
end;

// ---------------------------------------------------------------------------
// 버퍼를 전달하면 TFNReceiveData의 구조체에 담아서 리턴한다.
function CFNSocketManager.BufferToReceiveData(ABuffer: PAnsiChar; ASize: Integer): pTFNReceiveData;
var
  f_RecvData: pTFNReceiveData;
begin

  try
    // {
    New(f_RecvData);
    f_RecvData^.m_Data := NIL;
    f_RecvData^.m_Size := 0;

    ReallocMem(f_RecvData^.m_Data, ASize);
    TFNGlobal.memcpy(f_RecvData^.m_Data, ABuffer, ASize);
    f_RecvData^.m_Size := ASize;
  except
    // LOG_ERROR(['CFNSocketManager.BufferToReceiveData - 오류']);
    {
      if Assigned(f_RecvData) then
      begin
      if 0 < f_RecvData^.m_Size then
      begin
      FreeMem(f_RecvData^.m_Data);
      f_RecvData^.m_Size := 0;
      end;

      Dispose(f_RecvData);
      end;
    }
    f_RecvData := NIL;
  end;

  Result := f_RecvData;
end;

// ---------------------------------------------------------------------------
// 서로 다른 두개의 TFNReceiveData구조체안의 데이터를 하나에 붙여 넣느다.
procedure CFNSocketManager.ConcatenateRecvData(ASourceData: pTFNReceiveData; ATargetData: pTFNReceiveData);
begin
  if Assigned(ASourceData) and (0 < ASourceData^.m_Size) then
  begin
    ReallocMem(ATargetData^.m_Data, ATargetData^.m_Size + ASourceData^.m_Size);
    TFNGlobal.memcpy(ATargetData^.m_Data + ATargetData^.m_Size, ASourceData^.m_Data, ASourceData^.m_Size);
    ATargetData^.m_Size := ATargetData^.m_Size + ASourceData^.m_Size;
  end;
end;

// ---------------------------------------------------------------------------
// ARecvPacketHandler에 들어 있는 ValueItem을 CFNStreamValue로 변환하여
// CFNStreamRecord에 추가한다.
// 이 때 CFNStreamRecord는 함수 안에서 새로 생성된다.
function CFNSocketManager.CreateStreamRecord(ARecvPacketHandler: CFNStreamPacketHandler): CFNStreamRecord;
var
  nItemIdx: Integer;
  nItemCount: Integer;
  pValueItem: pCFNStreamValueItem;
  f_StreamValue: CFNFieldValue;
  f_StreamRecord: CFNStreamRecord;
begin
  f_StreamRecord := CFNStreamRecord.Create;
  f_StreamRecord.SetPacketKey(String(ARecvPacketHandler.GetPacketKey));

  nItemCount := ARecvPacketHandler.GetValueCount;
  for nItemIdx := 0 to nItemCount - 1 do
  begin
    pValueItem := ARecvPacketHandler.GetValueItemByIndex(nItemIdx);
    if Assigned(pValueItem) then
    begin
      f_StreamValue := CFNFieldValue.Create;

      if SPVT_STR = pValueItem^.m_nValueType then
      begin
        f_StreamValue.SetStringValue(String(ARecvPacketHandler.GetValueByIndex_PAnsiChar(nItemIdx)));
      end
      else if SPVT_I4 = pValueItem^.m_nValueType then
      begin
        f_StreamValue.SetIntegerValue(ARecvPacketHandler.GetValueByIndex_Int(nItemIdx));
      end
      else if SPVT_F8 = pValueItem^.m_nValueType then
      begin
        f_StreamValue.SetDoubleValue(ARecvPacketHandler.GetValueByIndex_Float(nItemIdx), pValueItem^.m_nValuePrecision);
      end;

      f_StreamValue.SetType(pValueItem^.m_nValueType);
      f_StreamRecord.AddValueObject(Trim(String(pValueItem^.m_nKey)), f_StreamValue);
    end;
  end;

  Result := f_StreamRecord;
end;

// ---------------------------------------------------------------------------
// 파라메터로 받은 AStreamRecord를 멤버변수인 m_STRecordList에 저장한다.
procedure CFNSocketManager.SaveStreamRecord(AStreamRecord: CFNStreamRecord);
begin
  if Assigned(m_STRecordList) then
  begin
    m_STRecordList.Add(AStreamRecord);
  end;
end;

// ---------------------------------------------------------------------------
// m_STRecordList 에 저장되어있는 CFNStreamRecord 의 오브젝트 중
// m_ReferenceCount의 수가 0인 것을 메모리에서 제거한다.
// 이 메소드는 DoProcWork()의 마지막에 호출한다.
procedure CFNSocketManager.TrucateUnusedStreamRecord;
var
  objSTRecord: CFNStreamRecord;
  nRecordCnt: Integer;
  nRecordIdx: Integer;
begin
  if Assigned(m_STRecordList) then
  begin
    nRecordCnt := m_STRecordList.Count;
    nRecordIdx := 0;

    while 0 < nRecordCnt do
    begin
      objSTRecord := CFNStreamRecord(m_STRecordList.Items[nRecordIdx]);
      if Assigned(objSTRecord) then
      begin
        if 0 = objSTRecord.GetReferenceCount then
        begin
          m_STRecordList.Delete(nRecordIdx);
          nRecordIdx := nRecordIdx - 1;
        end;
      end;

      nRecordIdx := nRecordIdx + 1;
      nRecordCnt := nRecordCnt - 1;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// 조회성 데이터를 요청하기 위해 m_RQSubscribeTable 의 배열 인덱스
// m_RQSubscribeIndex을 리턴한다.
// 이때 m_RequestSubscribeIndex의 변수를 많은 쓰레드가 참조하므로 동기화를 해야한다.
// 동기화는  m_RQSubscribeTableLock을 이용해서 한다.
function CFNSocketManager.GetRequestSubscribeIndex: Integer;
begin
  m_RQSubscribeTableLock.Enter;
  try
    Result := m_RQSubscribeIndex;
  finally
    m_RQSubscribeTableLock.Leave;
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
function CFNSocketManager.MakeStreamSubscribeKey(ACountry: Integer; AGroup: Integer; AMarket: Integer; ASymbol: String): String;
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
function CFNSocketManager.GetStreamSubscribeKey(AKey: String; var ACountry: Integer; var AGroup: Integer; var AMarket: Integer;
    var ASymbol: String): Boolean;
begin
  Result := false;
  try
    if 9 < Length(AKey) then
    begin
      ACountry := TFNGlobal.atoi(Copy(AKey, 2, 2));
      AGroup := TFNGlobal.atoi(Copy(AKey, 5, 2));
      AMarket := TFNGlobal.atoi(Copy(AKey, 8, 2));
      ASymbol := Copy(AKey, 10, Length(AKey) - (10 - 1));
    end;
  except
    // LOG_ERROR(['CFNSocketManager.GetStreamSubscribeKey - 오류']);
    Result := false;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNSocketManager.ClearRequest(ADataDelivery: CFNDataDelivery);
var
  f_Index: Integer;
begin
  m_RQSubscribeTableLock.Enter;
  try
    for f_Index := 0 to MAX_SUBSCRIBE_TABLE_SIZE do
    begin
      if (m_RQSubscribeTable[f_Index] = ADataDelivery) then
        m_RQSubscribeTable[f_Index] := NIL;
    end;
  finally
    m_RQSubscribeTableLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNSocketManager.DeleteRequest(ADataDelivery: CFNDataDelivery);
var
  f_Index: Integer;
begin
  m_RQSubscribeTableLock.Enter;
  try
    for f_Index := 0 to MAX_SUBSCRIBE_TABLE_SIZE do
    begin
      if (m_RQSubscribeTable[f_Index] = ADataDelivery) then
        m_RQSubscribeTable[f_Index] := NIL;
    end;
  finally
    m_RQSubscribeTableLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// 조회데이터의 전달할 CFNDelivery객체를 저장할 인덱스 m_RQSubscribeIndex를 가져온다. 이 후에 이값을 1 증가시킨다.
// 배열의 크기가 1024이므로 m_RQSubscribeIndex의 값이 1024보다 크거나 같으면 0으로 초기화 한다.
function CFNSocketManager.GetRQSubscribeIndex: Integer;
begin
  m_RQSubscribeTableLock.Enter;

  try
    Inc(m_RQSubscribeIndex);

    if MAX_SUBSCRIBE_TABLE_SIZE < m_RQSubscribeIndex then
      m_RQSubscribeIndex := 0;

    Result := m_RQSubscribeIndex;

  finally
    m_RQSubscribeTableLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// m_RQSubscribeTable[AIndex]의 값을 ADataDelivery로 설정한다.
procedure CFNSocketManager.SetRQSubscribeObject(AIndex: Integer; ADataDelivery: CFNDataDelivery);
begin
  m_RQSubscribeTableLock.Enter;

  try
    if (0 <= AIndex) and (MAX_SUBSCRIBE_TABLE_SIZE >= AIndex) then
    begin
      m_RQSubscribeTable[AIndex] := ADataDelivery;
    end;
  finally
    m_RQSubscribeTableLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// 조회성 데이터를 요청한다. ADataPackage의 해드중에 RequestID의 값을 m_RQSubscribeIndex의 값으로 설정한다.
// m_RQSubscribeTable[m_RQSubscribeIndex]의 값을 ADataDelivery으로 설정한다.
// 단위화면의 여러쓰레드가 동시해 접근할 수 있는 영역이다.
// 따라서 이 메소드 에서는 멤버변수와 오브젝트의 사용을 피한다.
// 만약 필히 접근해야 한다면 동기화를 하기 바란다.
function CFNSocketManager.Request(ADataDelivery: CFNDataDelivery; ADataPackage: CFNDataPackage): Boolean;
var
  f_RQIndex: Integer;
  f_strBuff: String;

  f_PacketHandler: CFNPacketHandler;
  f_pSendData: pTFNReceiveData;
  f_WChar: PWideChar;
  f_WLength: Integer;

  f_MChar: PAnsiChar;
  f_MLength: Integer;
begin
  Result := false;

  if Assigned(ADataPackage) then
  begin
    // 1. Request Table 등록
    f_RQIndex := GetRQSubscribeIndex;
    SetRQSubscribeObject(f_RQIndex, ADataDelivery);

    // 2. XML 데이터 파싱
    ADataPackage.SetRequestID(IntToStr(f_RQIndex));
    f_strBuff := ADataPackage.WriteToXML;
    f_WLength := Length(f_strBuff) * 2 + 1;

    f_WChar := AllocMem(f_WLength);
    StringToWideChar(f_strBuff, f_WChar, f_WLength);

    f_MLength := f_WLength;
    f_MChar := AllocMem(f_MLength);
    f_WLength := WStrLen(f_WChar);
    WideCharToMultiByte(CODEPAGE, WC_COMPOSITECHECK, f_WChar, f_WLength, f_MChar, f_MLength, NIL, NIL);

    // 3. 패킷핸들러 생성하여 바디데이터 설정
    f_PacketHandler := CFNPacketHandler.Create;
    f_PacketHandler.SetPacketType('1');
    f_PacketHandler.SetCompress(false);
    f_PacketHandler.SetEncryption(false);
    f_PacketHandler.Write(f_MChar^, StrLen(f_MChar));
    f_PacketHandler.EncodeData;

    // 5. 스트리밍 패킷을 pTFNReceiveData 데이터로 변경
    f_pSendData := ConvertStreamToReceiveData(f_PacketHandler.m_EncodeStream);

    // 6. m_SendQueue에 저장
    StoreSendData(f_pSendData);

    // 7. 사용한 데이터는 삭제
    f_PacketHandler.Clear;
    f_PacketHandler.Free;

    FreeMem(f_WChar);
    FreeMem(f_MChar);

    Result := True;
  end;
end;

// ---------------------------------------------------------------------------
// 스트리밍데이터 중 시세를 등록한다. 가장 첫번째 등록이면 서버에 등록을 요청한다.
// MakeStreamSubscribeKey를 이용하여 키를 만들고 해당키의 오브젝트에 ADataDelivery을 등록한다.
// 이 때 신규등록이면 서버에 등록패킷(SUBSCRIBE)를 전송한다.
// 단위화면의 여러쓰레드가 동시해 접근할 수 있는 영역이다.
// 따라서 이 메소드 에서는 멤버변수와 오브젝트의 사용을 피한다.
// 만약 필히 접근해야 한다면 동기화를 하기 바란다.
function CFNSocketManager.SubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer;
    ASymbol: String): Boolean;
var
  f_szKey: String;
  f_bFirst: Boolean;
  f_PacketHandler: CFNPacketHandler;
  f_StreamPacketHandler: CFNStreamPacketHandler;
  f_pSendData: pTFNReceiveData;
begin
  Result := false;

  // 1. 패킷 키 생성
  f_szKey := MakeStreamSubscribeKey(ACountry, AGroup, AMarket, ASymbol);
  if 0 < Length(f_szKey) then
  begin
    // 2. 시세테이블에 등록
    m_STSubscribeTableLock.Enter;
    try
      f_bFirst := m_STSubscribeTable[0].AddKeyValue(f_szKey, ADataDelivery);
    finally
      m_STSubscribeTableLock.Leave;
    end;

    if f_bFirst then
    begin
      // 3. 패킷핸들러 생성하여 바디데이터 설정
      f_PacketHandler := CFNPacketHandler.Create;
      f_PacketHandler.SetPacketType('0');
      f_PacketHandler.SetCompress(false);
      f_PacketHandler.SetEncryption(false);

      // 3. 패킷핸들러 생성하여 바디데이터 설정
      f_StreamPacketHandler := CFNStreamPacketHandler.Create;
      f_StreamPacketHandler.ClearAll;
      f_StreamPacketHandler.SetPacketKey('SUBSCRIBE');
      f_StreamPacketHandler.AddValueItem_Char('SYMBOL', PChar(ASymbol));
      // 주식 또는 지수의 심벌
      f_StreamPacketHandler.AddValueItem_Int('COUNTRY_NO', ACountry);
      // 0:한국, 1:중국, 2:일본
      f_StreamPacketHandler.AddValueItem_Int('GROUP_NO', AGroup); // 0:지수, 1주식
      f_StreamPacketHandler.AddValueItem_Int('MARKEY_NO', AMarket);
      // 0:상해, 1:심천, 2:홍콩
      f_StreamPacketHandler.AddValueItem_Int('TYPE', 0); // 0:시세, 1:호가, 2:뉴스
      f_StreamPacketHandler.AddValueItem_Int('COMMAND', 0); // 0:등록, 1:취소
      f_StreamPacketHandler.EncodeFrameData;

      f_PacketHandler.Write(f_StreamPacketHandler.m_Stream.m_Data^, f_StreamPacketHandler.m_Stream.GetFileSize);
      f_PacketHandler.EncodeData;

      // 5. 스트리밍 패킷을 pTFNReceiveData 데이터로 변경
      f_pSendData := ConvertStreamToReceiveData(f_PacketHandler.m_EncodeStream);

      // 6. m_SendQueue에 저장
      StoreSendData(f_pSendData);

      // 7. 사용한 데이터는 삭제
      f_StreamPacketHandler.ClearAll;
      f_StreamPacketHandler.Free;

      f_PacketHandler.Free;
    end;

    Result := True;
  end;
end;

// ---------------------------------------------------------------------------
// 스트리밍데이터 중 시세를 등록해지한다. 가장 마지막 등록해지이면 서버에 등록해지를 요청한다.
// MakeStreamSubscribeKey를 이용하여 키를 만들고 해당키의 오브젝트에 ADataDelivery을 등록해지한다.
// 이 때 마지막등록이면 서버에 등록해지패킷(SUBSCRIBE)를 전송한다.
// 단위화면의 여러쓰레드가 동시해 접근할 수 있는 영역이다.
// 따라서 이 메소드 에서는 멤버변수와 오브젝트의 사용을 피한다.
// 만약 필히 접근해야 한다면 동기화를 하기 바란다.
function CFNSocketManager.UnSubscribeQuote(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer; AMarket: Integer;
    ASymbol: String): Boolean;
var
  f_szKey: String;
  f_bLast: Boolean;
  f_PacketHandler: CFNPacketHandler;
  f_StreamPacketHandler: CFNStreamPacketHandler;
  f_pSendData: pTFNReceiveData;
begin
  Result := false;

  // 1. 패킷 키 생성
  f_szKey := MakeStreamSubscribeKey(ACountry, AGroup, AMarket, ASymbol);
  if 0 < Length(f_szKey) then
  begin
    // 2. 시세테이블에 등록
    m_STSubscribeTableLock.Enter;
    try
      f_bLast := m_STSubscribeTable[0].DeleteKeyValue(f_szKey, ADataDelivery);
    finally
      m_STSubscribeTableLock.Leave;
    end;

    if f_bLast then
    begin
      // 3. 패킷핸들러 생성하여 바디데이터 설정
      f_PacketHandler := CFNPacketHandler.Create;
      f_PacketHandler.SetPacketType('0');
      f_PacketHandler.SetCompress(false);
      f_PacketHandler.SetEncryption(false);

      // 3. 패킷핸들러 생성하여 바디데이터 설정
      f_StreamPacketHandler := CFNStreamPacketHandler.Create;
      f_StreamPacketHandler.ClearAll;
      f_StreamPacketHandler.SetPacketKey('SUBSCRIBE');
      f_StreamPacketHandler.AddValueItem_Char('SYMBOL', PChar(ASymbol));
      // 주식 또는 지수의 심벌
      f_StreamPacketHandler.AddValueItem_Int('COUNTRY_NO', ACountry);
      // 0:한국, 1:중국, 2:일본
      f_StreamPacketHandler.AddValueItem_Int('GROUP_NO', AGroup); // 0:지수, 1주식
      f_StreamPacketHandler.AddValueItem_Int('MARKEY_NO', AMarket);
      // 0:상해, 1:심천, 2:홍콩
      f_StreamPacketHandler.AddValueItem_Int('TYPE', 0); // 0:시세, 1:호가, 2:뉴스
      f_StreamPacketHandler.AddValueItem_Int('COMMAND', 1); // 0:등록, 1:취소
      f_StreamPacketHandler.EncodeFrameData;

      f_PacketHandler.Write(f_StreamPacketHandler.m_Stream.m_Data^, f_StreamPacketHandler.m_Stream.GetFileSize);
      f_PacketHandler.EncodeData;

      // 5. 스트리밍 패킷을 pTFNReceiveData 데이터로 변경
      f_pSendData := ConvertStreamToReceiveData(f_PacketHandler.m_EncodeStream);

      // 6. m_SendQueue에 저장
      StoreSendData(f_pSendData);

      // 7. 사용한 데이터는 삭제
      f_StreamPacketHandler.ClearAll;
      f_StreamPacketHandler.Free;

      f_PacketHandler.Free;
    end;

    Result := True;
  end;
end;

// ---------------------------------------------------------------------------
function CFNSocketManager.SubscribeSignal(ADataDelivery: CFNDataDelivery; ASessionKey: String): Boolean;
begin
  m_STSubscribeTableLock.Enter;
  try
    m_STSubscribeTable[2].AddKeyValue(ASessionKey, ADataDelivery);
  finally
    m_STSubscribeTableLock.Leave;
  end;

  Result := True;
end;

// ---------------------------------------------------------------------------
function CFNSocketManager.UnSubscribeSignal(ADataDelivery: CFNDataDelivery; ASessionKey: String): Boolean;
begin
  m_STSubscribeTableLock.Enter;
  try
    m_STSubscribeTable[2].DeleteKeyValue(ASessionKey, ADataDelivery);
  finally
    m_STSubscribeTableLock.Leave;
  end;

  Result := True;

end;
// ---------------------------------------------------------------------------
// 스트리밍데이터 중 호가를 등록한다. 가장 첫번째 등록이면 서버에 등록을 요청한다.
// MakeStreamSubscribeKey를 이용하여 키를 만들고 해당키의 오브젝트에 ADataDelivery을 등록한다.
// 이 때 신규등록이면 서버에 등록패킷(SUBSCRIBE)를 전송한다.
// 단위화면의 여러쓰레드가 동시해 접근할 수 있는 영역이다.
// 따라서 이 메소드 에서는 멤버변수와 오브젝트의 사용을 피한다.
// 만약 필히 접근해야 한다면 동기화를 하기 바란다.
function CFNSocketManager.SubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer;
    AMarket: Integer; ASymbol: String): Boolean;
var
  f_szKey: String;
  f_bFirst: Boolean;
  f_PacketHandler: CFNPacketHandler;
  f_StreamPacketHandler: CFNStreamPacketHandler;
  f_pSendData: pTFNReceiveData;
begin
  Result := false;

  // 1. 패킷 키 생성
  f_szKey := MakeStreamSubscribeKey(ACountry, AGroup, AMarket, ASymbol);
  if 0 < Length(f_szKey) then
  begin
    // 2. 시세테이블에 등록
    m_STSubscribeTableLock.Enter;
    try
      f_bFirst := m_STSubscribeTable[1].AddKeyValue(f_szKey, ADataDelivery);
    finally
      m_STSubscribeTableLock.Leave;
    end;

    if f_bFirst then
    begin
      // 3. 패킷핸들러 생성하여 바디데이터 설정
      f_PacketHandler := CFNPacketHandler.Create;
      f_PacketHandler.SetPacketType('0');
      f_PacketHandler.SetCompress(false);
      f_PacketHandler.SetEncryption(false);

      // 3. 패킷핸들러 생성하여 바디데이터 설정
      f_StreamPacketHandler := CFNStreamPacketHandler.Create;
      f_StreamPacketHandler.ClearAll;
      f_StreamPacketHandler.SetPacketKey('SUBSCRIBE');
      f_StreamPacketHandler.AddValueItem_Char('SYMBOL', PChar(ASymbol));
      // 주식 또는 지수의 심벌
      f_StreamPacketHandler.AddValueItem_Int('COUNTRY_NO', ACountry);
      // 0:한국, 1:중국, 2:일본
      f_StreamPacketHandler.AddValueItem_Int('GROUP_NO', AGroup); // 0:지수, 1주식
      f_StreamPacketHandler.AddValueItem_Int('MARKEY_NO', AMarket);
      // 0:상해, 1:심천, 2:홍콩
      f_StreamPacketHandler.AddValueItem_Int('TYPE', 1); // 0:시세, 1:호가, 2:뉴스
      f_StreamPacketHandler.AddValueItem_Int('COMMAND', 0); // 0:등록, 1:취소
      f_StreamPacketHandler.EncodeFrameData;

      f_PacketHandler.Write(f_StreamPacketHandler.m_Stream.m_Data^, f_StreamPacketHandler.m_Stream.GetFileSize);
      f_PacketHandler.EncodeData;

      // 5. 스트리밍 패킷을 pTFNReceiveData 데이터로 변경
      f_pSendData := ConvertStreamToReceiveData(f_PacketHandler.m_EncodeStream);

      // 6. m_SendQueue에 저장
      StoreSendData(f_pSendData);

      // 7. 사용한 데이터는 삭제
      f_StreamPacketHandler.ClearAll;
      f_StreamPacketHandler.Free;

      f_PacketHandler.Free;
    end;

    Result := True;
  end;
end;

// ---------------------------------------------------------------------------
// 스트리밍데이터 중 호가를 등록해지 한다. 가장 마지막 등록해지이면 서버에 등록해지를 요청한다.
// MakeStreamSubscribeKey를 이용하여 키를 만들고 해당키의 오브젝트에 ADataDelivery을 등록해지한다.
// 이 때 마지막등록이면 서버에 등록해지패킷(SUBSCRIBE)를 전송한다.
// 단위화면의 여러쓰레드가 동시해 접근할 수 있는 영역이다.
// 따라서 이 메소드 에서는 멤버변수와 오브젝트의 사용을 피한다.
// 만약 필히 접근해야 한다면 동기화를 하기 바란다.
function CFNSocketManager.UnSubscribeBidOffer(ADataDelivery: CFNDataDelivery; ACountry: Integer; AGroup: Integer;
    AMarket: Integer; ASymbol: String): Boolean;
var
  f_szKey: String;
  f_bLast: Boolean;
  f_PacketHandler: CFNPacketHandler;
  f_StreamPacketHandler: CFNStreamPacketHandler;
  f_pSendData: pTFNReceiveData;
begin
  Result := false;

  // 1. 패킷 키 생성
  f_szKey := MakeStreamSubscribeKey(ACountry, AGroup, AMarket, ASymbol);
  if 0 < Length(f_szKey) then
  begin
    // 2. 시세테이블에 등록
    m_STSubscribeTableLock.Enter;
    try
      f_bLast := m_STSubscribeTable[1].DeleteKeyValue(f_szKey, ADataDelivery);
    finally
      m_STSubscribeTableLock.Leave;
    end;

    if f_bLast then
    begin
      // 3. 패킷핸들러 생성하여 바디데이터 설정
      f_PacketHandler := CFNPacketHandler.Create;
      f_PacketHandler.SetPacketType('0');
      f_PacketHandler.SetCompress(false);
      f_PacketHandler.SetEncryption(false);

      // 3. 패킷핸들러 생성하여 바디데이터 설정
      f_StreamPacketHandler := CFNStreamPacketHandler.Create;
      f_StreamPacketHandler.ClearAll;
      f_StreamPacketHandler.SetPacketKey('SUBSCRIBE');
      f_StreamPacketHandler.AddValueItem_Char('SYMBOL', PChar(ASymbol));
      // 주식 또는 지수의 심벌
      f_StreamPacketHandler.AddValueItem_Int('COUNTRY_NO', ACountry);
      // 0:한국, 1:중국, 2:일본
      f_StreamPacketHandler.AddValueItem_Int('GROUP_NO', AGroup); // 0:지수, 1주식
      f_StreamPacketHandler.AddValueItem_Int('MARKEY_NO', AMarket);
      // 0:상해, 1:심천, 2:홍콩
      f_StreamPacketHandler.AddValueItem_Int('TYPE', 1); // 0:시세, 1:호가, 2:뉴스
      f_StreamPacketHandler.AddValueItem_Int('COMMAND', 1); // 0:등록, 1:취소
      f_StreamPacketHandler.EncodeFrameData;

      f_PacketHandler.Write(f_StreamPacketHandler.m_Stream.m_Data^, f_StreamPacketHandler.m_Stream.GetFileSize);
      f_PacketHandler.EncodeData;

      // 5. 스트리밍 패킷을 pTFNReceiveData 데이터로 변경
      f_pSendData := ConvertStreamToReceiveData(f_PacketHandler.m_EncodeStream);

      // 6. m_SendQueue에 저장
      StoreSendData(f_pSendData);

      // 7. 사용한 데이터는 삭제
      f_StreamPacketHandler.ClearAll;
      f_StreamPacketHandler.Free;

      f_PacketHandler.Free;
    end;

    Result := True;
  end;
end;

function CFNSocketManager.SendDisconnectPacket: Boolean;
var
  f_szKey: String;
  f_bLast: Boolean;
  f_PacketHandler: CFNPacketHandler;
  f_StreamPacketHandler: CFNStreamPacketHandler;
  f_pSendData: pTFNReceiveData;
begin
  Result := false;

  // 3. 패킷핸들러 생성하여 바디데이터 설정
  f_PacketHandler := CFNPacketHandler.Create;
  f_PacketHandler.SetPacketType('0');
  f_PacketHandler.SetCompress(false);
  f_PacketHandler.SetEncryption(false);

  // 3. 패킷핸들러 생성하여 바디데이터 설정
  f_StreamPacketHandler := CFNStreamPacketHandler.Create;
  f_StreamPacketHandler.ClearAll;
  f_StreamPacketHandler.SetPacketKey('DISCONNECT');
  f_StreamPacketHandler.EncodeFrameData;

  f_PacketHandler.Write(f_StreamPacketHandler.m_Stream.m_Data^, f_StreamPacketHandler.m_Stream.GetFileSize);
  f_PacketHandler.EncodeData;

  // 5. 스트리밍 패킷을 pTFNReceiveData 데이터로 변경
  f_pSendData := ConvertStreamToReceiveData(f_PacketHandler.m_EncodeStream);

  // 6. m_SendQueue에 저장
  StoreSendData(f_pSendData);

  // 7. 사용한 데이터는 삭제
  f_StreamPacketHandler.ClearAll;
  f_StreamPacketHandler.Free;

  f_PacketHandler.Free;

  Result := True;
end;

// ---------------------------------------------------------------------------
// 해당 클래스로 등록되어 있는 스트리밍데이터를 모두 해지한다.
// 단위화면의 여러쓰레드가 동시해 접근할 수 있는 영역이다.
// 따라서 이 메소드 에서는 멤버변수와 오브젝트의 사용을 피한다.
// 만약 필히 접근해야 한다면 동기화를 하기 바란다.
procedure CFNSocketManager.UnSubscribeAll(ADataDelivery: CFNDataDelivery);
var
  f_HashedStringList: THashedStringList;
  f_ObjectList: TObjectList;
  f_Index: Integer;
  f_Key: string;

  f_Country: Integer;
  f_Group: Integer;
  f_Market: Integer;
  f_Symbol: string;
begin
  m_STSubscribeTableLock.Enter;
  try
    try
      f_HashedStringList := m_STSubscribeTable[0].GetValue(ADataDelivery);
      if Assigned(f_HashedStringList) then
      begin
        while 0 < f_HashedStringList.Count do
        begin
          f_ObjectList := TObjectList(f_HashedStringList.Objects[0]);
          if Assigned(f_ObjectList) then
          begin
            f_Index := f_HashedStringList.IndexOfObject(f_ObjectList);
            if 0 <= f_Index then
            begin
              f_Key := f_HashedStringList.Strings[f_Index];
              GetStreamSubscribeKey(f_Key, f_Country, f_Group, f_Market, f_Symbol);

              if (1 = f_ObjectList.Count) then
              begin
                UnSubscribeQuote(ADataDelivery, f_Country, f_Group, f_Market, f_Symbol);
              end
              else
              begin
                m_STSubscribeTable[0].DeleteKeyValue(f_Key, ADataDelivery)
              end;
            end;
          end;

          f_HashedStringList.Delete(0);
        end;

        f_HashedStringList.Free;
      end;
    except
    end;

    try
      f_HashedStringList := m_STSubscribeTable[1].GetValue(ADataDelivery);
      if Assigned(f_HashedStringList) then
      begin
        while 0 < f_HashedStringList.Count do
        begin
          f_ObjectList := TObjectList(f_HashedStringList.Objects[0]);
          if Assigned(f_ObjectList) then
          begin
            f_Index := f_HashedStringList.IndexOfObject(f_ObjectList);
            if 0 <= f_Index then
            begin
              f_Key := f_HashedStringList.Strings[f_Index];
              GetStreamSubscribeKey(f_Key, f_Country, f_Group, f_Market, f_Symbol);

              if (1 = f_ObjectList.Count) then
              begin
                UnSubscribeQuote(ADataDelivery, f_Country, f_Group, f_Market, f_Symbol);
              end
              else
              begin
                m_STSubscribeTable[1].DeleteKeyValue(f_Key, ADataDelivery)
              end;
            end;
          end;

          f_HashedStringList.Delete(0);
        end;

        f_HashedStringList.Free;
      end;
    except
    end;

    try
      f_HashedStringList := m_STSubscribeTable[2].GetValue(ADataDelivery);
      if Assigned(f_HashedStringList) then
      begin
        while 0 < f_HashedStringList.Count do
        begin
          f_ObjectList := TObjectList(f_HashedStringList.Objects[0]);
          if Assigned(f_ObjectList) then
          begin
            f_Index := f_HashedStringList.IndexOfObject(f_ObjectList);
            if 0 <= f_Index then
            begin
              f_Key := f_HashedStringList.Strings[f_Index];

              if (1 = f_ObjectList.Count) then
              begin
                UnSubscribeQuote(ADataDelivery, 0, 0, 0, f_Key);
              end
              else
              begin
                m_STSubscribeTable[2].DeleteKeyValue(f_Key, ADataDelivery)
              end;
            end;
          end;

          f_HashedStringList.Delete(0);
        end;

        f_HashedStringList.Free;
      end;
    except
    end;

  finally
    m_STSubscribeTableLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNSocketManager.ReSubscribeAll;
var
  f_KeyList: TStringList;
  f_Index: Integer;
  f_Key: string;

  f_Country: Integer;
  f_Group: Integer;
  f_Market: Integer;
  f_Symbol: string;
  f_PacketHandler: CFNPacketHandler;
  f_StreamPacketHandler: CFNStreamPacketHandler;
  f_pSendData: pTFNReceiveData;
begin

  f_PacketHandler := CFNPacketHandler.Create;
  f_StreamPacketHandler := CFNStreamPacketHandler.Create;

  try
    f_KeyList := m_STSubscribeTable[0].GetAllKeys;
    if f_KeyList <> NIL then
    begin
      for f_Index := 0 to f_KeyList.Count - 1 do
      begin
        f_Key := f_KeyList[f_Index];
        GetStreamSubscribeKey(f_Key, f_Country, f_Group, f_Market, f_Symbol);
        // 3. 패킷핸들러 생성하여 바디데이터 설정
        f_PacketHandler.Clear;
        f_PacketHandler.SetPacketType('0');
        f_PacketHandler.SetCompress(false);
        f_PacketHandler.SetEncryption(false);

        // 3. 패킷핸들러 생성하여 바디데이터 설정
        f_StreamPacketHandler.ClearAll;
        f_StreamPacketHandler.SetPacketKey('SUBSCRIBE');
        f_StreamPacketHandler.AddValueItem_Char('SYMBOL', PChar(f_Symbol));
        // 주식 또는 지수의 심벌
        f_StreamPacketHandler.AddValueItem_Int('COUNTRY_NO', f_Country);
        // 0:한국, 1:중국, 2:일본
        f_StreamPacketHandler.AddValueItem_Int('GROUP_NO', f_Group);
        // 0:지수, 1주식
        f_StreamPacketHandler.AddValueItem_Int('MARKEY_NO', f_Market);
        // 0:상해, 1:심천, 2:홍콩
        f_StreamPacketHandler.AddValueItem_Int('TYPE', 0); // 0:시세, 1:호가, 2:뉴스
        f_StreamPacketHandler.AddValueItem_Int('COMMAND', 0); // 0:등록, 1:취소
        f_StreamPacketHandler.EncodeFrameData;

        f_PacketHandler.Write(f_StreamPacketHandler.m_Stream.m_Data^, f_StreamPacketHandler.m_Stream.GetFileSize);
        f_PacketHandler.EncodeData;

        // 5. 스트리밍 패킷을 pTFNReceiveData 데이터로 변경
        f_pSendData := ConvertStreamToReceiveData(f_PacketHandler.m_EncodeStream);

        // 6. m_SendQueue에 저장
        StoreSendData(f_pSendData);

      end;
      f_KeyList.Free;
    end;

    f_KeyList := m_STSubscribeTable[1].GetAllKeys;
    if f_KeyList <> NIL then
    begin
      for f_Index := 0 to f_KeyList.Count - 1 do
      begin
        f_Key := f_KeyList[f_Index];
        GetStreamSubscribeKey(f_Key, f_Country, f_Group, f_Market, f_Symbol);
        // 3. 패킷핸들러 생성하여 바디데이터 설정
        f_PacketHandler.Clear;
        f_PacketHandler.SetPacketType('0');
        f_PacketHandler.SetCompress(false);
        f_PacketHandler.SetEncryption(false);

        // 3. 패킷핸들러 생성하여 바디데이터 설정
        f_StreamPacketHandler.ClearAll;
        f_StreamPacketHandler.SetPacketKey('SUBSCRIBE');
        f_StreamPacketHandler.AddValueItem_Char('SYMBOL', PChar(f_Symbol));
        // 주식 또는 지수의 심벌
        f_StreamPacketHandler.AddValueItem_Int('COUNTRY_NO', f_Country);
        // 0:한국, 1:중국, 2:일본
        f_StreamPacketHandler.AddValueItem_Int('GROUP_NO', f_Group);
        // 0:지수, 1주식
        f_StreamPacketHandler.AddValueItem_Int('MARKEY_NO', f_Market);
        // 0:상해, 1:심천, 2:홍콩
        f_StreamPacketHandler.AddValueItem_Int('TYPE', 1); // 0:시세, 1:호가, 2:뉴스
        f_StreamPacketHandler.AddValueItem_Int('COMMAND', 0); // 0:등록, 1:취소
        f_StreamPacketHandler.EncodeFrameData;

        f_PacketHandler.Write(f_StreamPacketHandler.m_Stream.m_Data^, f_StreamPacketHandler.m_Stream.GetFileSize);
        f_PacketHandler.EncodeData;

        // 5. 스트리밍 패킷을 pTFNReceiveData 데이터로 변경
        f_pSendData := ConvertStreamToReceiveData(f_PacketHandler.m_EncodeStream);

        // 6. m_SendQueue에 저장
        StoreSendData(f_pSendData);

      end;
      f_KeyList.Free;
    end;

  finally
    f_StreamPacketHandler.Free;
    f_PacketHandler.Free;
  end;
end;

// ---------------------------------------------------------------------------
// 클라이언트 소켓인 m_TCPClient 에서 데이터를 읽어  버퍼에 복사한다.
// 이때 읽은 바이트수를 리턴한다. 소켓이 연결되어 있지 않으면 -1을 리턴한다.
function CFNSocketManager.ReadBufferFromSocket(ABuffer: PAnsiChar; AMaxSize: Integer): Integer;
var
  LInputBufferSize: Integer;
  LBuffer: TIdBytes;
begin
  if (not Assigned(m_TCPClient)) then
  begin
    Result := -1;
    exit;
  end;

  m_SocketLock.Enter;
  try
    if (not m_TCPClient.Connected) then
    begin
      Result := -1;
      exit;
    end;
    LInputBufferSize := m_TCPClient.IOHandler.InputBuffer.Size;
    if (LInputBufferSize > 0) then
    begin
      if (LInputBufferSize < AMaxSize) then
      begin
        m_nReceiveByte := LInputBufferSize;
      end
      else
      begin
        m_nReceiveByte := AMaxSize;
      end;

      m_TCPClient.IOHandler.ReadBytes(LBuffer, m_nReceiveByte);

      // System.Move(LBuffer, (ABuffer[0]), m_nReceiveByte);
      TFNGlobal.memcpy(@ABuffer[0], @LBuffer[0], m_nReceiveByte);

    end
    else
    begin
      m_nReceiveByte := 0;
    end;

  finally
    SetLength(LBuffer, 0);
    m_SocketLock.Leave;
  end;
  Result := m_nReceiveByte;
end;

// ---------------------------------------------------------------------------
// 클라이언트 소켓인 m_TCPClient 에서 데이터를 보낸다.
function CFNSocketManager.WriteBufferToSocket(ABuffer: PAnsiChar; ASize: Integer): Boolean;
begin
  if not Assigned(m_TCPClient) then
  begin
    Result := false;
    exit;
  end;

  Result := True;
  m_SocketLock.Enter;
  try
    m_TCPClient.IOHandler.WriteBufferOpen;
    m_TCPClient.IOHandler.Write(TIdBytes(ABuffer), ASize);
    m_TCPClient.IOHandler.WriteBufferFlush;
    Result := True;
  finally
    m_TCPClient.IOHandler.WriteBufferClose;
    m_SocketLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// 수신큐인 m_RecvQueue에 데이터를 저장한다.
procedure CFNSocketManager.StoreRecvData(AReceiveData: pTFNReceiveData);
begin
  if Assigned(AReceiveData) then
  begin
    m_RecvQueue.Store(AReceiveData);
  end;
end;

// ---------------------------------------------------------------------------
// 수신큐인 m_RecvQueue에서 데이터 꺼내 온다.
function CFNSocketManager.RetrieveRecvData: pTFNReceiveData;
var
  pRecvData: pTFNReceiveData;
begin
  pRecvData := NIL;

  if Assigned(m_RecvQueue) then
  begin
    pRecvData := pTFNReceiveData(m_RecvQueue.Retrieve);
  end;

  Result := pRecvData;
end;

// ---------------------------------------------------------------------------
// 송신큐인 m_SendQueue 에 데이터를 저장한다.
procedure CFNSocketManager.StoreSendData(ASendData: pTFNReceiveData);
begin
  if Assigned(ASendData) then
  begin
    m_SendQueue.Store(ASendData);
  end;
end;

// ---------------------------------------------------------------------------
// 송신큐인 m_SendQueue 에서 데이터를 꺼내온다.
function CFNSocketManager.RetrieveSendData: pTFNReceiveData;
var
  pSendData: pTFNReceiveData;
begin
  pSendData := NIL;

  if Assigned(m_SendQueue) then
  begin
    pSendData := pTFNReceiveData(m_SendQueue.Retrieve);
  end;

  Result := pSendData;
end;

// ---------------------------------------------------------------------------
// 크기가 ASourceSize인 문자열 ASource에서 크기가  AFindSize 인 문자열 AFind을 찾는 함수이다.
// 찾지 못하면 -1을 찾으면 찾았을 때 가장 처음 바이트의 위치이다.
// 즉 0에서 ASourceSize-AFindSize 까지의 값을 가질 수 있다. -1은 못찾을 경우
// var
// g_Header : array [0..4] of char = ('B', 'O', 'P', #$0D, #$0A);
// g_Footer : array [0..4] of char = ('E', 'O', 'P', #$0D, #$0A);
//
// g_HeaderSize : integer = 5;
// g_FooterSize : integer = 5;
function CFNSocketManager.SearchHeader(ASource: PAnsiChar; AFind: PAnsiChar; ASourceSize: Integer; AFindSize: Integer): Integer;
var
  nIndex, nLast: Integer;
begin
  Result := -1;
  nLast := ASourceSize - AFindSize + 1;
  for nIndex := 0 to nLast - 1 do
  begin
    if CompareMem(ASource + nIndex, AFind, AFindSize) then
    begin
      Result := nIndex;
      break;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// 크기가 ASourceSize인 문자열 ASource에서 크기가  AFindSize 인 문자열 AFind을 찾는 함수이다.
// 찾지 못하면 -1을 찾으면 찾았을 때 가장 마직막 바이트의 위치이다.
// 즉 AFindSize에서 ASourceSize까지의 값을 가질 수 있다. -1은 못찾을 경우
// var
// g_Header : array [0..4] of char = ('B', 'O', 'P', #$0D, #$0A);
// g_Footer : array [0..4] of char = ('E', 'O', 'P', #$0D, #$0A);
//
// g_HeaderSize : integer = 5;
// g_FooterSize : integer = 5;
function CFNSocketManager.SearchFooter(ASource: PAnsiChar; AFind: PAnsiChar; ASourceSize: Integer; AFindSize: Integer): Integer;
var
  nIndex, nLast: Integer;
begin
  Result := -1;
  nLast := ASourceSize - AFindSize + 1;
  for nIndex := 0 to nLast - 1 do
  begin
    if CompareMem(ASource + nIndex, AFind, AFindSize) then
    begin
      Result := nIndex + AFindSize;
      break;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// AReceiveData에서 'BOP\r\n'로 시작해서 'EOP\r\n'으로 끝나는 데이터를 추출해서  AExtractedPacket에 담는다.
// 해당하는 패킷이 존재하면 true를 리터하고, 존재하지 않으면 false를 리턴한다.
// 패킷해드와 풋은 상수로 선언해서 사용한다.
// var
// g_Header : array [0..4] of char = ('B', 'O', 'P', #$0D, #$0A);
// g_Footer : array [0..4] of char = ('E', 'O', 'P', #$0D, #$0A);
//
// g_HeaderSize : integer = 5;
// g_FooterSize : integer = 5;
function CFNSocketManager.ExtractPacket(AReceiveData: pTFNReceiveData; AExtractedPacket: pTFNReceiveData): Boolean;
var
  nHeaderIndex, nFooterIndex: Integer;
  pData: PAnsiChar;
begin
  try
    if ((AReceiveData^.m_Data = NIL) or (AReceiveData^.m_Size = 0)) then
    begin

      if (AReceiveData^.m_Data <> NIL) then
        ReallocMem(AReceiveData^.m_Data, 0);

      AReceiveData^.m_Data := NIL;
      AReceiveData^.m_Size := 0;
      nFooterIndex := -1;

    end
    else
    begin
      nFooterIndex := SearchFooter(AReceiveData^.m_Data, g_Footer, AReceiveData^.m_Size, g_FooterSize);
    end;

    if (nFooterIndex >= 0) then
    begin

      nHeaderIndex := SearchHeader(AReceiveData^.m_Data, g_Header, nFooterIndex, g_HeaderSize);
      if (nHeaderIndex >= 0) then
      begin

        AExtractedPacket^.m_Size := (nFooterIndex - nHeaderIndex);
        if (AExtractedPacket^.m_Size > 0) then
        begin

          ReallocMem(AExtractedPacket^.m_Data, AExtractedPacket^.m_Size);
          TFNGlobal.memcpy(AExtractedPacket^.m_Data, AReceiveData^.m_Data + nHeaderIndex, AExtractedPacket^.m_Size);

        end
        else
        begin

          AExtractedPacket^.m_Size := 0;
          if (AExtractedPacket^.m_Data <> NIL) then
            ReallocMem(AExtractedPacket^.m_Data, 0);

          AExtractedPacket^.m_Data := NIL;

        end;
      end
      else
      begin

        AExtractedPacket^.m_Size := 0;
        if (AExtractedPacket^.m_Data <> NIL) then
          ReallocMem(AExtractedPacket^.m_Data, 0);

        AExtractedPacket^.m_Data := NIL;

      end;

      if (AReceiveData^.m_Size = nFooterIndex) then
      begin

        AReceiveData^.m_Size := 0;
        ReallocMem(AReceiveData^.m_Data, 0);
        AReceiveData^.m_Data := NIL;

      end
      else
      begin

        pData := NIL;
        ReallocMem(pData, AReceiveData^.m_Size - nFooterIndex);
        TFNGlobal.memcpy(pData, AReceiveData^.m_Data + nFooterIndex, AReceiveData^.m_Size - nFooterIndex);
        AReceiveData^.m_Size := AReceiveData^.m_Size - nFooterIndex;
        ReallocMem(AReceiveData^.m_Data, 0);
        AReceiveData^.m_Data := pData;

      end;

      if (nHeaderIndex < 0) then
        Result := false
      else
        Result := True;

    end
    else
    begin
      Result := false;
    end;
  except

    Result := false;
  end;
end;

// ---------------------------------------------------------------------------
// 추출된 데이터를 이용하여 분석한다.
procedure CFNSocketManager.ProcessPacket(AExtractedPacket: pTFNReceiveData);
var
  cType: AnsiChar;
begin
  if Assigned(AExtractedPacket) and (0 < AExtractedPacket^.m_Size) then
  begin
    cType := '0';
    TFNGlobal.memcpy(@cType, AExtractedPacket^.m_Data + 5, sizeof(cType));

    // 2009.08.21 김무근
    // 데이터를 수신했다고 이벤트를 발생한다.
    if m_EnableEvent then
      if (Assigned(m_OnSocketEvent)) then
        m_OnSocketEvent(SOCKEVENT_RECEIVE);

    if '0' = cType then
    begin
      // 스트리밍 데이터
      OnRecvStreamData(AExtractedPacket);

    end
    else if '1' = cType then
    begin
      // 조회성 데이터
      OnRecvRequestData(AExtractedPacket);

    end
    else
    begin
      // 알수없음

    end;
  end
  else
  begin

  end;
end;

// ---------------------------------------------------------------------------
// 조회성데이터를 수신했을 때 호출된다.
// 함수 내부에서는 조회성데이터를 CFNDataPackage를 이용해서 자료구조로 변환하다.
procedure CFNSocketManager.OnRecvRequestData(AReceiveData: pTFNReceiveData);
var
  f_DataPackage: CFNDataPackage;
  f_RequestID: String;
  f_DataDelivery: CFNDataDelivery;
  f_WChar: PWideChar;
  f_WLength: Integer;
  f_String: String;
begin
  if Assigned(AReceiveData) and Assigned(AReceiveData^.m_Data) then
  begin
    m_PacketHandler.Clear;
    if m_PacketHandler.DecodeData(AReceiveData^.m_Data^, AReceiveData^.m_Size) then
    begin
      f_WLength := m_PacketHandler.m_SourceStream.Size * 2 + 1;
      f_WChar := AllocMem(f_WLength);
      MultiByteToWideChar(CODEPAGE, MB_PRECOMPOSED, m_PacketHandler.m_SourceStream.Memory, m_PacketHandler.m_SourceStream.Size,
          f_WChar, f_WLength);
      f_String := WideCharToString(f_WChar);
      FreeMem(f_WChar);

      f_DataPackage := CFNDataPackage.Create;

      if f_DataPackage.LoadXMLData(f_String) then
      begin
        f_RequestID := f_DataPackage.GetRequestID;
        if 0 < Length(f_RequestID) then
        begin
          f_DataDelivery := m_RQSubscribeTable[TFNGlobal.atoi(f_RequestID)];
          if Assigned(f_DataDelivery) then
          begin
            f_DataDelivery.DeliveryReply(f_DataPackage);
          end
          else
          begin
            f_DataPackage.Free;
          end;
        end
        else
        begin
          f_DataPackage.Free;
        end;
      end
      else
      begin
        f_DataPackage.Free;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// 스트리밍 데이터를 수신했을 때 호출된다. 함수 내부에서는 스트리밍데이터를 디코딩해서
// 그 Packet Key의 값에 따라 OnRecvDisconnect(), OnRecvHeartBit(), OnRecvQuote(), OnRecvBidOffer()를 호출한다.
procedure CFNSocketManager.OnRecvStreamData(AReceiveData: pTFNReceiveData);
var
  strPacketKey: String;
begin
  if Assigned(AReceiveData) and Assigned(AReceiveData^.m_Data) then
  begin
    m_PacketHandler.Clear;
    if m_PacketHandler.DecodeData(AReceiveData^.m_Data^, AReceiveData^.m_Size) then
    begin
      m_STProcPacketHandler.ClearAll;
      m_STProcPacketHandler.DecodeFrameData(m_PacketHandler.m_SourceStream.Memory, m_PacketHandler.m_SourceStream.Size, false);

      strPacketKey := String(m_STProcPacketHandler.GetPacketKey);
      if (AnsiCompareText(strPacketKey, 'HEARTBIT') = 0) then
      begin
        OnRecvHeartBit(m_STProcPacketHandler);
      end
      else if (AnsiCompareText(strPacketKey, 'DISCONNECT') = 0) then
      begin
        OnRecvDisconnect(m_STProcPacketHandler);
      end
      else if (AnsiCompareText(strPacketKey, 'SUBSCRIBE') = 0) then
      begin
      end
      else if (AnsiCompareText(strPacketKey, 'QUOTE') = 0) then
      begin
        if g_LibraryAllow then
          OnRecvQuote(m_STProcPacketHandler);
      end
      else if (AnsiCompareText(strPacketKey, 'SIGNAL') = 0) then
      begin
        if g_LibraryAllow then
          OnRecvSignal(m_STProcPacketHandler);
      end
      else if (AnsiCompareText(strPacketKey, 'BIDOFFER') = 0) then
      begin
        if g_LibraryAllow then
          OnRecvBidOffer(m_STProcPacketHandler);
      end
      else
      begin
        // 알수없는 Packet Key
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// 스트리밍데이터중 Packet Key가 'DISCONNECT'인 경우 이 함수를 호출한다.
procedure CFNSocketManager.OnRecvDisconnect(ARecvPacketHandler: CFNStreamPacketHandler);
var
  f_Value1: String;
  f_Value2: String;
begin
  if Assigned(m_TCPClient) then
  begin
    m_SocketLock.Enter;
    try
      if m_TCPClient.Connected then
      begin
        m_TCPClient.Disconnect;
      end;
    finally
      m_SocketLock.Leave;
    end;

    // 2009.08.21 김무근
    // 접속이 종료 되었다고 이벤트를 발생한다.
    if m_EnableEvent then
      if (Assigned(m_OnSocketEvent)) then
      begin
        f_Value1 := ARecvPacketHandler.GetValueByKey_PChar('1');
        f_Value2 := ARecvPacketHandler.GetValueByKey_PChar('2');
        // 일반적인 경우의 접속해지 통보
        if (AnsiCompareText(f_Value2, 'NOMAL') = 0) then
        begin
          m_DisConnectState := 'normal';
          m_OnSocketEvent(SOCKEVENT_NORMALDISCONNECT);
        end
        else
          // 다른 컴퓨터에서 재로그인 결과로 인한 접속을 해지한다는 통보
          if (AnsiCompareText(f_Value2, 'RELOGIN') = 0) then
          begin
            m_DisConnectState := 'relogin';
            m_OnSocketEvent(SOCKEVENT_RELOGINDISCONNECT);
          end;
      end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNSocketManager.OnSocketConnect(Sender: TObject);
begin
  m_DisConnectState := 'abnormal';
  m_ReceiveHeartBitTime := Now;
  if m_EnableEvent then
    if (Assigned(m_OnSocketEvent)) then
    begin
      m_OnSocketEvent(SOCKEVENT_CONNECT);
    end;
end;

// ---------------------------------------------------------------------------
procedure CFNSocketManager.OnSocketDisconnect(Sender: TObject);
begin
  if not m_EnableEvent then
    exit;

  if (AnsiCompareText(m_DisConnectState, 'abnormal') = 0) then
  begin
    if m_EnableEvent then
      if (Assigned(m_OnSocketEvent)) then
      begin
        m_OnSocketEvent(SOCKEVENT_ABNORMALDISCONNECT);
      end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNSocketManager.SocketStatus(ASender: TObject; const aStatus: TIdStatus; const AStatusText: string);
begin
  FStatus := aStatus;

end;

// ---------------------------------------------------------------------------
procedure CFNSocketManager.SocketError(Sender: TObject; stError: String);
begin
end;

// ---------------------------------------------------------------------------
// 스트리밍데이터중 Packet Key가 'HEARTBIT'인 경우 이 함수를 호출한다.
// 함수 내부에서는 서버로 재전송한다.
// 이때 수신한 패킷데이터중 Key 1에 해당하는 값이 'PING'일 때에만
// Key 2의 값으로 'PONG'를 전달하면 된다.
procedure CFNSocketManager.OnRecvHeartBit(ARecvPacketHandler: CFNStreamPacketHandler);
var
  strRecvData: String;
  f_PacketHandler: CFNPacketHandler;
  f_pSendData: pTFNReceiveData;
begin
  // LOG_WRITE(LOG_TYPE_INFO, 'OnRecvHeartBit', 'HeartBit');

  m_ReceiveHeartBitTime := Now;

  strRecvData := ARecvPacketHandler.GetValueByKey_PChar('1'); // key = 1 번인것
  if (AnsiCompareText(strRecvData, 'PING') = 0) then
  begin
    ARecvPacketHandler.ClearAll;
    ARecvPacketHandler.SetPacketKey('HEARTBIT');
    ARecvPacketHandler.AddValueItem_AnsiChar('2', 'PONG');

    if ARecvPacketHandler.EncodeFrameData then
    begin
      // 3. 패킷핸들러 생성하여 바디데이터 설정
      f_PacketHandler := CFNPacketHandler.Create;
      f_PacketHandler.SetPacketType('0');
      f_PacketHandler.SetCompress(false);
      f_PacketHandler.SetEncryption(false);

      f_PacketHandler.Write(ARecvPacketHandler.m_Stream.m_Data^, ARecvPacketHandler.m_Stream.GetFileSize);
      f_PacketHandler.EncodeData;

      // 5. 스트리밍 패킷을 pTFNReceiveData 데이터로 변경
      f_pSendData := ConvertStreamToReceiveData(f_PacketHandler.m_EncodeStream);

      // 6. m_SendQueue에 저장
      if Assigned(f_pSendData) then
      begin
        StoreSendData(f_pSendData);
        ARecvPacketHandler.ClearAll;
      end;

      f_PacketHandler.Free;

    end;
  end;
end;

// ---------------------------------------------------------------------------
// 스트리밍데이터 중 Packet Key가 'QUOTE'인 경우 이 함수를 호출한다.
// 이 함수 내부에서는 패킷의 모든 값을 하나 하나 CFNStreamValue으로 변환하고
// CFNStreamRecord에 해당 키로 추가한다.
// 이 CFNStreamRecord을 m_LookUpTable[0]에 등록된 화면으로 전달한다
procedure CFNSocketManager.OnRecvQuote(ARecvPacketHandler: CFNStreamPacketHandler);
var
  ACountry: Integer;
  AGroup: Integer;
  AMarket: Integer;
  ASymbol: String;
  f_szKey: String;

  f_ObjectList: TObjectList;
  f_StreamRecord: CFNStreamRecord;
  nLoop: Integer;

  f_DataDelivery: CFNDataDelivery;
begin
  // if not g_EnableStreamData then exit;

  ACountry := ARecvPacketHandler.GetValueByKey_Int('COUNTRY_NO');
  // 국가(0:한국, 1:중국)
  AGroup := ARecvPacketHandler.GetValueByKey_Int('GROUP_NO'); // 주식구분(0:지수,1:주식)
  AMarket := ARecvPacketHandler.GetValueByKey_Int('MARKET_NO');
  // 거래소(0:상해, 1:심첨, 2:홍콩)
  ASymbol := ARecvPacketHandler.GetValueByKey_PChar('SYMBOL'); // 주식 또는 지수의 심벌

  f_szKey := MakeStreamSubscribeKey(ACountry, AGroup, AMarket, ASymbol);

  m_STSubscribeTableLock.Enter;
  try
    f_ObjectList := m_STSubscribeTable[0].GetKey(f_szKey);
  finally
    m_STSubscribeTableLock.Leave;
  end;

  if Assigned(f_ObjectList) then
  begin
    f_StreamRecord := CreateStreamRecord(ARecvPacketHandler);
    if Assigned(f_StreamRecord) then
    begin
      try
        for nLoop := 0 to f_ObjectList.Count - 1 do
        begin
          f_DataDelivery := CFNDataDelivery(f_ObjectList.Items[nLoop]);
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
    end;

    f_ObjectList.Clear;
    f_ObjectList.Free;
  end
  else
  begin
    // 등록 취소 요청한다.
    // UnSubscribeQuote(NIL, ACountry, AGroup, AMarket, ASymbol);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNSocketManager.OnRecvSignal(ARecvPacketHandler: CFNStreamPacketHandler);
var
  LSessionKey: String;

  f_ObjectList: TObjectList;
  f_StreamRecord: CFNStreamRecord;
  nLoop: Integer;

  f_DataDelivery: CFNDataDelivery;
begin
  LSessionKey := ARecvPacketHandler.GetValueByKey_PChar('TRADESESSION_KEY'); // 주식 또는 지수의 심벌

  m_STSubscribeTableLock.Enter;
  try
    f_ObjectList := m_STSubscribeTable[2].GetKey(LSessionKey);
  finally
    m_STSubscribeTableLock.Leave;
  end;

  if Assigned(f_ObjectList) then
  begin
    f_StreamRecord := CreateStreamRecord(ARecvPacketHandler);
    if Assigned(f_StreamRecord) then
    begin
      try
        for nLoop := 0 to f_ObjectList.Count - 1 do
        begin
          f_DataDelivery := CFNDataDelivery(f_ObjectList.Items[nLoop]);
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
    end;

    f_ObjectList.Clear;
    f_ObjectList.Free;
  end
  else
  begin
    // 등록 취소 요청한다.
    // UnSubscribeQuote(NIL, ACountry, AGroup, AMarket, ASymbol);
  end;
end;

// ---------------------------------------------------------------------------
// 스트리밍데이터 중 Packet Key가 BIDASK'인 경우 이 함수를 호출한다.
// 이 함수 내부에서는 패킷의 모든 값을 하나 하나 CFNStreamValue으로 변환하고
// CFNStreamRecord에 해당 키로 추가한다.
// 이 CFNStreamRecord을 m_LookUpTable[1]에 등록된 화면으로 전달한다
procedure CFNSocketManager.OnRecvBidOffer(ARecvPacketHandler: CFNStreamPacketHandler);
var
  ACountry: Integer;
  AGroup: Integer;
  AMarket: Integer;
  ASymbol: String;
  f_szKey: String;

  f_ObjectList: TObjectList;
  f_StreamRecord: CFNStreamRecord;
  nLoop: Integer;

  f_DataDelivery: CFNDataDelivery;
  f_bSucc: Boolean;
begin
  ACountry := ARecvPacketHandler.GetValueByKey_Int('COUNTRY_NO');
  // 국가(0:한국, 1:중국)
  AGroup := ARecvPacketHandler.GetValueByKey_Int('GROUP_NO'); // 주식구분(0:지수,1:주식)
  AMarket := ARecvPacketHandler.GetValueByKey_Int('MARKET_NO');
  // 거래소(0:상해, 1:심첨, 2:홍콩)
  ASymbol := ARecvPacketHandler.GetValueByKey_PChar('SYMBOL'); // 주식 또는 지수의 심벌

  f_szKey := MakeStreamSubscribeKey(ACountry, AGroup, AMarket, ASymbol);

  m_STSubscribeTableLock.Enter;
  try
    f_ObjectList := m_STSubscribeTable[1].GetKey(f_szKey);
  finally
    m_STSubscribeTableLock.Leave;
  end;

  if Assigned(f_ObjectList) then
  begin

    f_StreamRecord := CreateStreamRecord(ARecvPacketHandler);

    if Assigned(f_StreamRecord) then
    begin
      try

        for nLoop := 0 to f_ObjectList.Count - 1 do
        begin

          f_DataDelivery := CFNDataDelivery(f_ObjectList.Items[nLoop]);
          if Assigned(f_DataDelivery) then
          begin
            f_bSucc := True;
            try
              f_DataDelivery.DeliveryStream(f_StreamRecord);
            except
              f_bSucc := false;
            end;

            if f_bSucc then
              f_StreamRecord.IncreaseReferenceCount;
          end;
        end;

      except
      end;

      SaveStreamRecord(f_StreamRecord);
    end;

    f_ObjectList.Clear;
    f_ObjectList.Free;
  end
  else
  begin
    // 등록 취소 요청한다.
    UnSubscribeBidOffer(NIL, ACountry, AGroup, AMarket, ASymbol);
  end;
end;

end.
