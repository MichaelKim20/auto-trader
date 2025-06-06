unit FNTradeSystem;

interface

uses
  Math, SysUtils, Classes, Graphics;

const
  { 매매신호의 유형정의 }
  SIGNAL_NONE = 0;
  SIGNAL_SELL_ENTER = 1; // 매도진입
  SIGNAL_SELL_EXIT = 2; // 매도청산
  SIGNAL_BUY_ENTER = 3; // 매수진입
  SIGNAL_BUY_EXIT = 4; // 매수청산

  ORDER_PRICE_MARKET = 0;
  ORDER_PRICE_CURRENT = 1;
  ORDER_PRICE_BIDOFFER = 2;

  ORDER_TYPE_BUY = 2;
  ORDER_TYPE_SELL = 1;
  ORDER_TYPE_NONE = 0;

  { 주문 및 체결 처리 상태 }
  PST_CREATE_ORDER = 0; // 주문생성
  PST_SEND_ORDER = 1; // 주문전달
  PST_RECEIVE_ORDER = 2; // 주문응답
  PST_RECEIPT_ORDER = 3; // 주문접수
  PST_CONFIRM_ORDER = 4; // 주문확인
  PST_TRADING = 5; // 체결진행
  PST_COMPLITE_TRADE = 6; // 체결완료
  PST_CHANGE_ORDER = 7;
  // 주문수정    -   해당 신호에 대한 주문이 변경됨, 다른 주문데이터가 추가되었습니다. 다른 수정주문이나 취소주문이 존재함
  PST_REJECT_ORDER = 8; // 주문거부    -

  PST_CANCEL_ORDER = 21; // 주문취소    -   주문이 취소됨
  PST_WAITE_ORDER = 22; // 주문대기
  PST_DELETE_ORDER = 23; // 주문삭제
  PST_ERROR_ORDER = 24; // 주문오류
  PST_FAIL_ORDER = 25; // 주문실패
  PST_REPAIR_ORDER = 26; // 오류복구

  { 주문컨테이너의 성격 }
  ODC_SIGNAL = 1; // 신호에 의한 주문
  ODC_ADJUST = 2; // 조정에 따른 주문

  { 주문데이터유형 }
  ODT_NONE = 0; //
  ODT_NEW = 1; // 신규주문
  ODT_AMENDED = 2; // 수정주문
  ODT_CANCEL = 3; // 취소주문

  MAX_TRY_COUNT = 10;
  MAX_DELAY_SECOND = 5;
  MAX_DELAY_SECOND2 = 3;
  MAX_DELAY_SECOND_ADJUST = 10;

type
  CFNSignalItem = class;
  CFNSignalCollection = class;

  CFNOrderItem = class;
  CFNOrderCollection = class;

  CFNTradeItem = class;
  CFNTradeCollection = class;

  CFNSignalData = class;
  CFNSignalArray = class;

  CFNAdjustItem = class;

  // ---------------------------------------------------------------------------
  CFNSignalData = class(TObject)
  public
    m_SystemNo: Integer;
    m_Index: Integer; // 바의 번호
    m_DateTime: TDateTime; // 날짜와시간
    m_Signal: Integer; // 매매신호
    m_Price: Double; // 매매신호 발생가격(수정주가)
    m_OPS: Double; //
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clone(p_Source: CFNSignalData);
  end;

  // ---------------------------------------------------------------------------
  CFNSignalArray = class(TObject)
  public
    m_Items: TList;

    m_Country: Integer; // 국가번호
    m_Group: Integer; // 그룹번호
    m_Market: Integer; // 거래소번호
    m_Symbol: String; // 주식의 심벌

  public
    constructor Create;
    destructor Destroy; override;

  public
    procedure Clear;
    procedure Clone(p_Source: CFNSignalArray);
    procedure Add(p_SignalData: CFNSignalData);

    function Search(p_Date: TDateTime): Integer;
    procedure Sort;

  end;

  // ---------------------------------------------------------------------------
  CFNSignalItem = class(TObject)
  public
    m_Enable: Boolean;
    m_CalcOrderPrice: Double;
    m_Transition: Integer;
    m_SystemNo: Integer; // 발생시스템번호
    m_SignalSequence: Integer; // 매매신호순번
    m_BarIndex: Integer; // 발생한 바의 순서
    m_DateTime: TDateTime; // 날짜와시간
    m_Signal: Integer; // 매매신호
    m_CorrectSignal: Integer; // 특별한 사용에 의해 주문 진행 중 변경된 매매신호
    m_Price: Double; // 매매신호 발생가격(수정주가)

    m_EnterCount: Integer; // 진입물량
    m_ExitCount: Integer; // 청산물량

    m_CountOfSendingOrder: Integer; // 주문전송횟수
    m_OrderSequence: Integer; // 주문순번
    m_OrderDataType: Integer; // 주문데이터유형 1:신규, 2:정정, 3:취소
    m_OrderDateTime: TDateTime; // 주문전송일시
    m_OrderPriceType: Integer; // 주문가격의 결정기준 0 : 시장가, 1:지정가(현재가), 2:호가;
    m_OrderPrice: Double; // 주문가격
    m_OrderVolume: Integer; // 주문수량
    m_OrgOrderVolume: Integer; // 원주문수량
    m_OrderType: Integer; // 1:매도 2:매수
    m_ConfirmDateTime: TDateTime; // 주문전송일시

    m_OrderNumber: String; // 주문번호
    m_OrgOrderNumber: String; // 원주문번호
    m_TradePrice: Double; // 체결가격
    m_TradeVolume: Integer; // 체결수량

    m_ConfirmTime: TDateTime;

    m_CanRetry: Boolean;
    m_RetryCount: Integer;
    m_RetryCountOfReject: Integer;
    m_RetryTime: TDateTime;
    m_DelaySecond: Integer;

    m_ProcessStep: Integer; // 주문 및 체결 처리 상태

    m_OrderCollection: CFNOrderCollection;
    m_TradeCollection: CFNTradeCollection;

    m_TradeValue: Double;
    m_TradePriceOfProfit: Double;
    m_TradeVolumeOfProfit: Integer;

    m_Profit: Double;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clone(ASource: CFNSignalItem);

    procedure SetStateAllOrder(AState: Integer);
    function SetStateLastOrder(AState: Integer): CFNOrderItem;

    function GetFirstOrderNumber: String;
    function GetOrgOrderNumber: String;
    function GetLastOrderNumber: String;

    procedure CalcTradeValue(ALastPrice: Double);

    procedure CalcTradeVolume;

    procedure WriteToXML(AStream: TStringStream);
  end;

  // ---------------------------------------------------------------------------
  CFNSignalCollection = class(TObject)
  public
    m_Items: TList;

    m_Country: Integer; // 국가번호
    m_Group: Integer; // 그룹번호
    m_Market: Integer; // 거래소번호
    m_Symbol: String; // 주식의 심벌

  public
    constructor Create;
    destructor Destroy; override;

  public
    procedure Clear;
    procedure Clone(ASource: CFNSignalCollection);
    procedure Add(ASignalItem: CFNSignalItem);

    function Search(ADate: TDateTime): Integer;
    procedure Sort;

    procedure WriteToXML(AStream: TStringStream; ANodeName: String);
  end;

  // ---------------------------------------------------------------------------
  CFNOrderItem = class(TObject)
  public
    m_SignalSequence: Integer; // 매매신호순번
    m_AdjustSequence: Integer; // 조정정보순번
    m_OrderSequence: Integer; // 주문순번

    m_OrderCollectionType: Integer; // 1:신호에 따른 주문,  2:조정에 따른 주문

    m_CountOfSendingOrder: Integer; // 주문전송횟수
    m_OrderDataType: Integer; // 주문데이터유형 1:신규, 2:정정, 3:취소

    m_OrderType: Integer; // 1:매도 2:매수
    m_OrderDateTime: TDateTime; // 주문전송일시
    m_OrderPrice: Double; // 주문가격
    m_OrderVolume: Integer; // 주문수량
    m_OrgOrderVolume: Integer; // 원주문수량

    m_OrderPriceType: Integer; // 주문가격의 결정기준 0 : 시장가, 1:지정가(현재가), 2:호가;

    m_OrderNumber: String; // 주문번호
    m_OrgOrderNumber: String; // 원주문번호

    m_TradePrice: Double; // 체결가격
    m_TradeVolume: Integer; // 체결수량

    m_ProcessStep: Integer; // 주문 및 체결 처리 상태

    m_SignalItem: CFNSignalItem;
    m_AdjustItem: CFNAdjustItem;

    m_MessageCode: String;
    m_MessageText: String;

    m_TradeCollection: CFNTradeCollection;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Clone(ASource: CFNOrderItem);
    procedure WriteToXML(AStream: TStringStream);
  end;

  // ---------------------------------------------------------------------------
  CFNOrderCollection = class(TObject)
  private
    m_AutoClear: Boolean;

  public
    m_Items: TList;

  public
    constructor Create(AAutoClear: Boolean = true);
    destructor Destroy; override;

  public
    procedure Clear;
    procedure Add(AOrderItem: CFNOrderItem);
    procedure DisableOrderBySignal(ASignalSequence: Integer);
    function FindByOrderNo(AOrderNo: String): CFNOrderItem;

    procedure Copy(ASource: CFNOrderCollection);
    procedure Clone(ASource: CFNOrderCollection);
    procedure WriteToXML(AStream: TStringStream; ANodeName: String);
  end;

  // ---------------------------------------------------------------------------
  CFNTradeItem = class(TObject)
  public
    m_SignalSequence: Integer; // 매매신호순번
    m_AdjustSequence: Integer; // 조정정보순번
    m_OrderSequence: Integer; // 주문순번
    m_TradeSequence: Integer; // 체결순번

    m_OrderType: Integer; // 1:매도 2:매수
    m_OrderPrice: Double; // 주문가격
    m_OrderVolume: Integer; // 주문수량

    m_TradeDateTime: TDateTime; // 체결일시
    m_TradePrice: Double; // 체결가격
    m_TradeVolume: Integer; // 체결량

    m_SignalItem: CFNSignalItem;
    m_OrderItem: CFNOrderItem;

    procedure Clone(ASource: CFNTradeItem);
    procedure WriteToXML(AStream: TStringStream);
  end;

  // ---------------------------------------------------------------------------
  CFNTradeCollection = class(TObject)
  private
    m_AutoClear: Boolean;

  public
    m_Items: TList;

  public
    constructor Create(AAutoClear: Boolean = true);
    destructor Destroy; override;

  public
    /// 내용을 지운다.///
    procedure Clear;
    procedure Add(ATradeItem: CFNTradeItem);

    /// 원본의 포인트를 복사해서 넣는다. ///
    procedure Copy(ASource: CFNTradeCollection);
    procedure Clone(ASource: CFNTradeCollection);

    procedure DeleteTradeItemByOrderSeq(AOrderSequence: Integer; AFree: Boolean);
    procedure DeleteTradeItemByAdjustSeq(AAdjustSequence: Integer; AFree: Boolean);
    procedure WriteToXML(AStream: TStringStream; ANodeName: String);
  end;
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  TFNLogNotifyEvent = Procedure(ASender: TObject; ADateTime: TDateTime; AType: Integer; AMessage, AClassName: String) of Object;

  // ---------------------------------------------------------------------------
  CFNLogItem = class(TObject)
  public
    m_BlockName: String;
    m_DateTime: TDateTime;
    m_Type: Integer;
    m_ClassName: String;
    m_Message: String;
    procedure WriteToXML(AStream: TStringStream);
  end;

  // ---------------------------------------------------------------------------
  CFNLogCollection = class(TObject)
  public
    m_Items: TList;

  public
    constructor Create;
    destructor Destroy; override;

  public
    procedure Clear;
    procedure Write(AType: Integer; AMessage, AClassName: String);
    procedure WriteToXML(AStream: TStringStream; ANodeName: String);
  end;

  // ---------------------------------------------------------------------------
  CFNAdjustItem = class(TObject)
  public
    m_AdjustSequence: Integer; // 조정정보순번
    m_SignalSequence: Integer; // 매매신호순번

    m_DateTime: TDateTime; // 날짜와시간
    m_AdjustType: Integer; // 1:매도 2:매수
    m_AdjustVolume: Integer; // 주문수량

    m_CountOfSendingOrder: Integer; // 주문전송횟수
    m_OrderSequence: Integer; // 주문순번
    m_OrderDataType: Integer; // 주문데이터유형 1:신규, 2:정정, 3:취소
    m_OrderDateTime: TDateTime; // 주문전송일시
    m_OrderPriceType: Integer; // 주문가격의 결정기준 0 : 시장가, 1:지정가(현재가), 2:호가;
    m_OrderPrice: Double; // 주문가격
    m_OrderVolume: Integer; // 주문수량
    m_OrderType: Integer; // 1:매도 2:매수
    m_ConfirmDateTime: TDateTime; // 주문전송일시

    m_OrderNumber: String; // 주문번호
    m_OrgOrderNumber: String; // 원주문번호
    m_TradePrice: Double; // 체결가격
    m_TradeVolume: Integer; // 체결수량

    m_ConfirmTime: TDateTime;

    m_CanRetry: Boolean;
    m_RetryCount: Integer;
    m_RetryCountOfReject: Integer;
    m_RetryTime: TDateTime;
    m_DelaySecond: Integer;

    m_ProcessStep: Integer; // 주문 및 체결 처리 상태

    m_OrderCollection: CFNOrderCollection;
    m_TradeCollection: CFNTradeCollection;

    m_TradeValue: Double;
    m_TradePriceOfProfit: Double;
    m_TradeVolumeOfProfit: Integer;

    m_Profit: Double;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clone(ASource: CFNAdjustItem);

    procedure SetStateLastOrder(AState: Integer);

    function GetLastOrderNumber: String;

    procedure CalcTradeVolume;
    procedure WriteToXML(AStream: TStringStream);
  end;

  // ---------------------------------------------------------------------------
  CFNAdjustCollection = class(TObject)
  public
    m_Items: TList;

  public
    constructor Create;
    destructor Destroy; override;

  public
    procedure Clear;
    procedure Clone(ASource: CFNAdjustCollection);
    procedure Add(AAdjustItem: CFNAdjustItem);

    function GetTotalPosition: Integer;
    function GetAdjustPositionOfSignal(ASignalSequence: Integer): Integer;

    procedure WriteToXML(AStream: TStringStream; ANodeName: String);
  end;

{$REGION '각 종 상수의 텍스트'}

function GetSignalColor(ASignal: Integer): TColor;
function GetRawSignalText(ASignal: Integer): String;
function GetSignalText(ASignal: Integer): String;
function GetSimpleSignalText(ASignal: Integer): String;
function GetOrderTypeText(AValue: Integer): String;
function GetOrderPriceTypeText(AValue: Integer): String;
function GetOrderDataTypeText(AValue: Integer): String;
function GetOrderProcessStepText(AValue: Integer): String;
{$ENDREGION}

implementation

uses WinProcs, FNGlobal, FNCMVariable;

{$REGION '각 종 상수의 텍스트'}

function GetSignalColor(ASignal: Integer): TColor;
begin
  if (g_Language = 0) then
  begin
    if ASignal = SIGNAL_BUY_ENTER then
    begin
      Result := RGB($F0, 0, 0);
    end
    else if ASignal = SIGNAL_SELL_ENTER then
    begin
      Result := RGB(0, 0, $F0);
    end
    else
    begin
      Result := RGB(0, 0, 0);
    end;
  end
  else
  begin
    if ASignal = SIGNAL_BUY_ENTER then
    begin
      Result := RGB(0, 0, $F0);
    end
    else if ASignal = SIGNAL_SELL_ENTER then
    begin
      Result := RGB($F0, 0, 0);
    end
    else
    begin
      Result := RGB(0, 0, 0);
    end;
  end;
end;

function GetRawSignalText(ASignal: Integer): String;
begin
  if (g_Language = 0) then
  begin
    if (ASignal = 1) then
    begin
      Result := '매수';
    end
    else if (ASignal = -1) then
    begin
      Result := '매도';
    end
    else if (ASignal = 0) then
    begin
      Result := '중립';
    end
    else
    begin
      Result := '';
    end;
  end
  else
  begin
    if (ASignal = 1) then
    begin
      Result := 'Buy';
    end
    else if (ASignal = -1) then
    begin
      Result := 'Sell';
    end
    else if (ASignal = 0) then
    begin
      Result := '  ';
    end
    else
    begin
      Result := '';
    end;
  end;
end;

function GetSignalText(ASignal: Integer): String;
begin
  if (g_Language = 0) then
  begin
    if (ASignal = SIGNAL_BUY_ENTER) then
    begin
      Result := '매수진입';
    end
    else if (ASignal = SIGNAL_SELL_ENTER) then
    begin
      Result := '매도진입';
    end
    else if (ASignal = SIGNAL_BUY_EXIT) then
    begin
      Result := '매수청산';
    end
    else if (ASignal = SIGNAL_SELL_EXIT) then
    begin
      Result := '매도청산';
    end
    else
    begin
      Result := '';
    end;
  end
  else
  begin
    if (ASignal = SIGNAL_BUY_ENTER) then
    begin
      Result := 'Buy Enter';
    end
    else if (ASignal = SIGNAL_SELL_ENTER) then
    begin
      Result := 'Sell Enter';
    end
    else if (ASignal = SIGNAL_BUY_EXIT) then
    begin
      Result := 'Buy Exit';
    end
    else if (ASignal = SIGNAL_SELL_EXIT) then
    begin
      Result := 'Sell Exit';
    end
    else
    begin
      Result := '';
    end;
  end;
end;

function GetSimpleSignalText(ASignal: Integer): String;
begin
  if (g_Language = 0) then
  begin
    if (ASignal = SIGNAL_BUY_ENTER) then
    begin
      Result := '매수';
    end
    else if (ASignal = SIGNAL_SELL_ENTER) then
    begin
      Result := '매도';
    end
    else
    begin
      Result := '중립';
    end;
  end
  else
  begin
    if (ASignal = SIGNAL_BUY_ENTER) then
    begin
      Result := 'Buy';
    end
    else if (ASignal = SIGNAL_SELL_ENTER) then
    begin
      Result := 'Sell';
    end
    else
    begin
      Result := '  ';
    end;
  end;
end;

function GetOrderTypeText(AValue: Integer): String;
begin
  if (g_Language = 0) then
  begin
    if AValue = ORDER_TYPE_BUY then
    begin
      Result := '매수';
    end
    else if AValue = ORDER_TYPE_SELL then
    begin
      Result := '매도';
    end
    else
    begin
      Result := '';
    end;
  end
  else
  begin
    if AValue = ORDER_TYPE_BUY then
    begin
      Result := 'Buy';
    end
    else if AValue = ORDER_TYPE_SELL then
    begin
      Result := 'Sell';
    end
    else
    begin
      Result := '';
    end;
  end;
end;

function GetOrderPriceTypeText(AValue: Integer): String;
begin
  if (g_Language = 0) then
  begin
    if AValue = ORDER_PRICE_MARKET then
    begin
      Result := '시장가';
    end
    else if AValue = ORDER_PRICE_CURRENT then
    begin
      Result := '지정현재가';
    end
    else if AValue = ORDER_PRICE_BIDOFFER then
    begin
      Result := '지정호가';
    end
    else
    begin
      Result := '';
    end;
  end
  else
  begin
    if AValue = ORDER_PRICE_MARKET then
    begin
      Result := 'Market';
    end
    else if AValue = ORDER_PRICE_CURRENT then
    begin
      Result := 'Limit1';
    end
    else if AValue = ORDER_PRICE_BIDOFFER then
    begin
      Result := 'Limit2';
    end
    else
    begin
      Result := '';
    end;
  end;
end;

function GetOrderDataTypeText(AValue: Integer): String;
begin
  if (g_Language = 0) then
  begin
    if AValue = ODT_NEW then
    begin
      Result := '신규';
    end
    else if AValue = ODT_AMENDED then
    begin
      Result := '수정';
    end
    else if AValue = ODT_CANCEL then
    begin
      Result := '취소';
    end
    else
    begin
      Result := '';
    end;
  end
  else
  begin
    if AValue = ODT_NEW then
    begin
      Result := 'New';
    end
    else if AValue = ODT_AMENDED then
    begin
      Result := 'Amend';
    end
    else if AValue = ODT_CANCEL then
    begin
      Result := 'Withdraw';
    end
    else
    begin
      Result := '';
    end;
  end;
end;

function GetOrderProcessStepText(AValue: Integer): String;
begin
  if (g_Language = 0) then
  begin
    if AValue = PST_CREATE_ORDER then
    begin
      Result := '주문생성';
    end
    else if AValue = PST_SEND_ORDER then
    begin
      Result := '주문전달';
    end
    else if AValue = PST_RECEIVE_ORDER then
    begin
      Result := '주문응답';
    end
    else if AValue = PST_RECEIPT_ORDER then
    begin
      Result := '주문접수';
    end
    else if AValue = PST_CONFIRM_ORDER then
    begin
      Result := '주문확인';
    end
    else if AValue = PST_TRADING then
    begin
      Result := '체결진행';
    end
    else if AValue = PST_COMPLITE_TRADE then
    begin
      Result := '체결완료';
    end
    else if AValue = PST_CHANGE_ORDER then
    begin
      Result := '주문정정';
    end
    else if AValue = PST_REJECT_ORDER then
    begin
      Result := '주문거부';
    end
    else if AValue = PST_CANCEL_ORDER then
    begin
      Result := '주문취소';
    end
    else if AValue = PST_WAITE_ORDER then
    begin
      Result := '주문대기';
    end
    else if AValue = PST_DELETE_ORDER then
    begin
      Result := '주문삭제';
    end
    else if AValue = PST_ERROR_ORDER then
    begin
      Result := '주문오류';
    end
    else if AValue = PST_FAIL_ORDER then
    begin
      Result := '주문실패';
    end
    else if AValue = PST_REPAIR_ORDER then
    begin
      Result := '오류복구';
    end
    else
    begin
      Result := '';
    end;
  end
  else
  begin
    if AValue = PST_CREATE_ORDER then
    begin
      Result := 'Create';
    end
    else if AValue = PST_SEND_ORDER then
    begin
      Result := 'Send';
    end
    else if AValue = PST_RECEIVE_ORDER then
    begin
      Result := 'Receive';
    end
    else if AValue = PST_RECEIPT_ORDER then
    begin
      Result := 'Receipt';
    end
    else if AValue = PST_CONFIRM_ORDER then
    begin
      Result := 'Confirm';
    end
    else if AValue = PST_TRADING then
    begin
      Result := 'Trading';
    end
    else if AValue = PST_COMPLITE_TRADE then
    begin
      Result := 'CompliteTrade';
    end
    else if AValue = PST_CHANGE_ORDER then
    begin
      Result := 'ChangeOrder';
    end
    else if AValue = PST_REJECT_ORDER then
    begin
      Result := 'Reject';
    end
    else if AValue = PST_CANCEL_ORDER then
    begin
      Result := 'Withdraw';
    end
    else if AValue = PST_WAITE_ORDER then
    begin
      Result := 'Waite';
    end
    else if AValue = PST_DELETE_ORDER then
    begin
      Result := 'Delete';
    end
    else if AValue = PST_ERROR_ORDER then
    begin
      Result := 'Error';
    end
    else if AValue = PST_FAIL_ORDER then
    begin
      Result := 'Fail';
    end
    else if AValue = PST_REPAIR_ORDER then
    begin
      Result := 'Repair';
    end
    else
    begin
      Result := '';
    end;
  end;
end;
{$ENDREGION}
{$REGION 'CFNSignalData'}

// ---------------------------------------------------------------------------
constructor CFNSignalData.Create;
begin
  inherited Create;
end;

// ---------------------------------------------------------------------------
destructor CFNSignalData.Destroy;
begin

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNSignalData.Clone(p_Source: CFNSignalData);
begin
  m_SystemNo := p_Source.m_SystemNo;
  m_Index := p_Source.m_Index;
  m_DateTime := p_Source.m_DateTime;
  m_Signal := p_Source.m_Signal;
  m_Price := p_Source.m_Price;
  m_OPS := p_Source.m_OPS;
end;
{$ENDREGION}
{$REGION 'CFNSignalArray'}

// ---------------------------------------------------------------------------
constructor CFNSignalArray.Create;
begin
  inherited Create;

  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CFNSignalArray.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 배열의 구성요소를 모두 삭제한다.
procedure CFNSignalArray.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNSignalData(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 하나를 추가한다.
procedure CFNSignalArray.Add(p_SignalData: CFNSignalData);
begin
  m_Items.Add(p_SignalData);
end;

// ---------------------------------------------------------------------------
// 해당값을 가지고 있는 요소를 찾아 그 인덱스를 리턴한다.
function CFNSignalArray.Search(p_Date: TDateTime): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_SignalData: CFNSignalData;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_SignalData := CFNSignalData(m_Items.Items[f_PosX]);

      f_Compare := p_Date - f_SignalData.m_DateTime;

      if (0 > f_Compare) then
        f_PosR := f_PosX - 1
      else
        f_PosL := f_PosX + 1;
    until (not((f_Compare <> 0) and (f_PosL <= f_PosR)));

    if (0 = f_Compare) then
      Result := f_PosX
    else
      Result := -1;
  end
  else
  begin
    Result := -1;
  end;
end;

// ---------------------------------------------------------------------------
function SignalData_Compare(Item1, Item2: Pointer): Integer;
var
  f_SignalData1: CFNSignalData;
  f_SignalData2: CFNSignalData;
  f_Compare: Double;
begin
  f_SignalData1 := CFNSignalData(Item1);
  f_SignalData2 := CFNSignalData(Item2);

  f_Compare := f_SignalData1.m_DateTime - f_SignalData2.m_DateTime;
  if f_Compare > 0 then
    f_Compare := 1
  else if f_Compare < 0 then
    f_Compare := -1
  else
    f_Compare := 0;

  Result := Trunc(f_Compare);
end;

// ---------------------------------------------------------------------------
// 비교함수를 이용하여 정렬한다.
procedure CFNSignalArray.Sort;
begin
  m_Items.Sort(@SignalData_Compare);
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하여 복제한다.
procedure CFNSignalArray.Clone(p_Source: CFNSignalArray);
var
  f_OldSignalData: CFNSignalData;
  f_NewSignalData: CFNSignalData;
  f_Index: Integer;
begin
  Clear;
  for f_Index := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_OldSignalData := CFNSignalData(p_Source.m_Items.Items[f_Index]);
    f_NewSignalData := CFNSignalData.Create;
    f_NewSignalData.Clone(f_OldSignalData);
    m_Items.Add(f_NewSignalData);
  end;
end;
{$ENDREGION}
{$REGION 'CFNSignalItem'}

// ---------------------------------------------------------------------------
constructor CFNSignalItem.Create;
begin
  inherited Create;
  m_OrderCollection := CFNOrderCollection.Create(false);
  m_TradeCollection := CFNTradeCollection.Create(false);

  m_Transition := 0;
  m_Enable := true;
  m_OrderPriceType := 0;
  m_OrderDateTime := 0;
  m_ProcessStep := 0;
  m_OrderPrice := 0;
  m_OrderVolume := 0;
  m_OrderType := 0;
  m_EnterCount := 0;
  m_ExitCount := 0;

  m_RetryCount := 0;
  m_RetryCountOfReject := 0;
  m_RetryTime := 0;
  m_DelaySecond := MAX_DELAY_SECOND;

  m_TradeValue := 0;
  m_TradePriceOfProfit := 0;
  m_TradeVolumeOfProfit := 0;
  m_Profit := 0;
end;

// ---------------------------------------------------------------------------
destructor CFNSignalItem.Destroy;
begin
  if Assigned(m_OrderCollection) then
  begin
    m_OrderCollection.Free;
    m_OrderCollection := NIL;
  end;
  if Assigned(m_TradeCollection) then
  begin
    m_TradeCollection.Free;
    m_TradeCollection := NIL;
  end;
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
function CFNSignalItem.GetFirstOrderNumber: String;
var
  f_OrderItem: CFNOrderItem;
  f_Index: Integer;
begin
  Result := '';
  for f_Index := 0 to m_OrderCollection.m_Items.Count - 1 do
  begin
    f_OrderItem := m_OrderCollection.m_Items.Items[f_Index];
    if f_OrderItem.m_ProcessStep = PST_REJECT_ORDER then
      continue;
    if f_OrderItem.m_ProcessStep = PST_ERROR_ORDER then
      continue;
    if f_OrderItem.m_ProcessStep = PST_FAIL_ORDER then
      continue;

    if f_OrderItem.m_OrderNumber <> '' then
    begin
      Result := f_OrderItem.m_OrderNumber;
      break;
    end;
  end;
end;

// ---------------------------------------------------------------------------
function CFNSignalItem.GetOrgOrderNumber: String;
var
  f_OrderItem: CFNOrderItem;
  f_Index: Integer;
begin
  Result := '';
  for f_Index := m_OrderCollection.m_Items.Count - 1 downto 0 do
  begin
    f_OrderItem := m_OrderCollection.m_Items.Items[f_Index];
    if f_OrderItem.m_ProcessStep = PST_REJECT_ORDER then
      continue;
    if f_OrderItem.m_ProcessStep = PST_ERROR_ORDER then
      continue;
    if f_OrderItem.m_ProcessStep = PST_FAIL_ORDER then
      continue;

    if f_OrderItem.m_OrgOrderNumber <> '' then
    begin
      Result := f_OrderItem.m_OrgOrderNumber;
      break;
    end;
  end;
end;

// ---------------------------------------------------------------------------
function CFNSignalItem.GetLastOrderNumber: String;
var
  f_OrderItem: CFNOrderItem;
  f_Index: Integer;
begin
  Result := '';
  for f_Index := m_OrderCollection.m_Items.Count - 1 downto 0 do
  begin
    f_OrderItem := m_OrderCollection.m_Items.Items[f_Index];
    if f_OrderItem.m_ProcessStep = PST_REJECT_ORDER then
      continue;
    if f_OrderItem.m_ProcessStep = PST_ERROR_ORDER then
      continue;
    if f_OrderItem.m_ProcessStep = PST_FAIL_ORDER then
      continue;

    if f_OrderItem.m_OrderNumber <> '' then
    begin
      Result := f_OrderItem.m_OrderNumber;
      break;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNSignalItem.SetStateAllOrder(AState: Integer);
var
  f_OrderItem: CFNOrderItem;
  f_Index: Integer;
begin
  for f_Index := 0 to m_OrderCollection.m_Items.Count - 1 do
  begin
    f_OrderItem := m_OrderCollection.m_Items.Items[f_Index];
    f_OrderItem.m_ProcessStep := AState;
  end;
end;

// ---------------------------------------------------------------------------
function CFNSignalItem.SetStateLastOrder(AState: Integer): CFNOrderItem;
var
  f_OrderItem: CFNOrderItem;
begin
  if m_OrderCollection.m_Items.Count > 0 then
  begin
    f_OrderItem := m_OrderCollection.m_Items.Items[m_OrderCollection.m_Items.Count - 1];
    f_OrderItem.m_ProcessStep := AState;
    Result := f_OrderItem;
  end
  else
  begin
    Result := NIL;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNSignalItem.WriteToXML(AStream: TStringStream);
begin
  AStream.WriteString('<SignalItem>' + #$0A);

  AStream.WriteString('<m_Enable>' + TFNGlobal.BoolToString(m_Enable) + '</m_Enable>' + #$0A);
  AStream.WriteString('<m_CalcOrderPrice>' + FloatToStr(m_CalcOrderPrice) + '</m_CalcOrderPrice>' + #$0A);
  AStream.WriteString('<m_Transition>' + IntToStr(m_Transition) + '</m_Transition>' + #$0A);
  AStream.WriteString('<m_SystemNo>' + IntToStr(m_SystemNo) + '</m_SystemNo>' + #$0A);
  AStream.WriteString('<m_SignalSequence>' + IntToStr(m_SignalSequence) + '</m_SignalSequence>' + #$0A);
  AStream.WriteString('<m_BarIndex>' + IntToStr(m_BarIndex) + '</m_BarIndex>' + #$0A);
  AStream.WriteString('<m_DateTime>' + TFNGlobal.DateTimeToString(m_DateTime, 'YYYYMMDDHHMMSS') + '</m_DateTime>' + #$0A);
  AStream.WriteString('<m_Signal>' + IntToStr(m_Signal) + '</m_Signal>' + #$0A);
  AStream.WriteString('<m_CorrectSignal>' + IntToStr(m_CorrectSignal) + '</m_CorrectSignal>' + #$0A);
  AStream.WriteString('<m_Price>' + FloatToStr(m_Price) + '</m_Price>' + #$0A);
  AStream.WriteString('<m_ConfirmDateTime>' + TFNGlobal.DateTimeToString(m_ConfirmDateTime, 'YYYYMMDDHHMMSS') + '</m_ConfirmDateTime>' + #$0A);

  AStream.WriteString('<m_EnterCount>' + IntToStr(m_EnterCount) + '</m_EnterCount>' + #$0A);
  AStream.WriteString('<m_ExitCount>' + IntToStr(m_ExitCount) + '</m_ExitCount>' + #$0A);
  AStream.WriteString('<m_CountOfSendingOrder>' + IntToStr(m_CountOfSendingOrder) + '</m_CountOfSendingOrder>' + #$0A);
  AStream.WriteString('<m_OrderSequence>' + IntToStr(m_OrderSequence) + '</m_OrderSequence>' + #$0A);
  AStream.WriteString('<m_OrderDataType>' + IntToStr(m_OrderDataType) + '</m_OrderDataType>' + #$0A);

  AStream.WriteString('<m_OrderDateTime>' + TFNGlobal.DateTimeToString(m_OrderDateTime, 'YYYYMMDDHHMMSS') + '</m_OrderDateTime>' + #$0A);
  AStream.WriteString('<m_OrderPriceType>' + IntToStr(m_OrderPriceType) + '</m_OrderPriceType>' + #$0A);
  AStream.WriteString('<m_OrderPrice>' + FloatToStr(m_OrderPrice) + '</m_OrderPrice>' + #$0A);
  AStream.WriteString('<m_OrderVolume>' + IntToStr(m_OrderVolume) + '</m_OrderVolume>' + #$0A);
  AStream.WriteString('<m_OrderType>' + IntToStr(m_OrderType) + '</m_OrderType>' + #$0A);

  AStream.WriteString('<m_OrderNumber>' + m_OrderNumber + '</m_OrderNumber>' + #$0A);
  AStream.WriteString('<m_OrgOrderNumber>' + m_OrgOrderNumber + '</m_OrgOrderNumber>' + #$0A);

  AStream.WriteString('<m_TradePrice>' + FloatToStr(m_TradePrice) + '</m_TradePrice>' + #$0A);
  AStream.WriteString('<m_TradeVolume>' + IntToStr(m_TradeVolume) + '</m_TradeVolume>' + #$0A);
  AStream.WriteString('<m_ConfirmTime>' + TFNGlobal.DateTimeToString(m_ConfirmTime, 'YYYYMMDDHHMMSS') + '</m_ConfirmTime>' + #$0A);

  AStream.WriteString('<m_CanRetry>' + TFNGlobal.BoolToString(m_CanRetry) + '</m_CanRetry>' + #$0A);
  AStream.WriteString('<m_RetryCount>' + IntToStr(m_RetryCount) + '</m_RetryCount>' + #$0A);
  AStream.WriteString('<m_RetryCountOfReject>' + IntToStr(m_RetryCountOfReject) + '</m_RetryCountOfReject>' + #$0A);
  AStream.WriteString('<m_RetryTime>' + TFNGlobal.DateTimeToString(m_RetryTime, 'YYYYMMDDHHMMSS') + '</m_RetryTime>' + #$0A);
  AStream.WriteString('<m_DelaySecond>' + IntToStr(m_DelaySecond) + '</m_DelaySecond>' + #$0A);
  AStream.WriteString('<m_ProcessStep>' + IntToStr(m_ProcessStep) + '</m_ProcessStep>' + #$0A);

  AStream.WriteString('<m_TradeValue>' + FloatToStr(m_TradeValue) + '</m_TradeValue>' + #$0A);
  AStream.WriteString('<m_TradePriceOfProfit>' + FloatToStr(m_TradePriceOfProfit) + '</m_TradePriceOfProfit>' + #$0A);
  AStream.WriteString('<m_TradeVolumeOfProfit>' + IntToStr(m_TradeVolumeOfProfit) + '</m_TradeVolumeOfProfit>' + #$0A);
  AStream.WriteString('<m_Profit>' + FloatToStr(m_Profit) + '</m_Profit>' + #$0A);

  AStream.WriteString('</SignalItem>' + #$0A);
end;

procedure CFNSignalItem.CalcTradeVolume;
var
  f_Index: Integer;
  f_TradeItem: CFNTradeItem;
  f_TVal: Double;
begin
  m_TradeVolume := 0;
  f_TVal := 0;
  for f_Index := 0 to m_TradeCollection.m_Items.Count - 1 do
  begin
    f_TradeItem := m_TradeCollection.m_Items.Items[f_Index];
    m_TradeVolume := m_TradeVolume + f_TradeItem.m_TradeVolume;
    f_TVal := f_TVal + f_TradeItem.m_TradePrice * f_TradeItem.m_TradeVolume;
    m_TradePrice := f_TVal / m_TradeVolume;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNSignalItem.CalcTradeValue(ALastPrice: Double);
var
  f_Index: Integer;
  f_TradeItem: CFNTradeItem;
begin
  m_TradeValue := 0;
  m_TradePriceOfProfit := 0;
  m_TradeVolumeOfProfit := 0;

  if m_ProcessStep = PST_WAITE_ORDER then
    exit;
  if m_ProcessStep = PST_DELETE_ORDER then
    exit;

  if m_OrderVolume = 0 then
    exit;

  for f_Index := 0 to m_TradeCollection.m_Items.Count - 1 do
  begin
    f_TradeItem := m_TradeCollection.m_Items.Items[f_Index];
    m_TradeValue := m_TradeValue + f_TradeItem.m_TradePrice * f_TradeItem.m_TradeVolume;
    m_TradeVolumeOfProfit := m_TradeVolumeOfProfit + f_TradeItem.m_TradeVolume;
  end;

  // 신호가 취소 되지 않았을 경우는 아직 미체결로 남은 주문량에 대한 체결금액을 집계한다.
  if m_ProcessStep <> PST_CANCEL_ORDER then
  begin
    if m_TradeVolume < m_OrderVolume then
    begin
      if m_OrderPrice <> 0 then
      begin
        m_TradeValue := m_TradeValue + m_OrderPrice * (m_OrderVolume - m_TradeVolume);
      end
      else
      begin
        m_TradeValue := m_TradeValue + ALastPrice * (m_OrderVolume - m_TradeVolume);
      end;
      m_TradeVolumeOfProfit := m_OrderVolume;
    end;
  end;

  if m_TradeVolumeOfProfit <> 0 then
  begin
    m_TradePriceOfProfit := m_TradeValue / m_TradeVolumeOfProfit;
  end
  else
  begin
    m_TradePriceOfProfit := 0;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNSignalItem.Clone(ASource: CFNSignalItem);
begin
  m_CalcOrderPrice := ASource.m_CalcOrderPrice;
  m_Transition := ASource.m_Transition;
  m_Enable := ASource.m_Enable;
  m_SystemNo := ASource.m_SystemNo;
  m_SignalSequence := ASource.m_SignalSequence;
  m_DateTime := ASource.m_DateTime;
  m_Signal := ASource.m_Signal;
  m_CorrectSignal := ASource.m_CorrectSignal;
  m_Price := ASource.m_Price;
  m_EnterCount := ASource.m_EnterCount;
  m_ExitCount := ASource.m_ExitCount;
  m_CountOfSendingOrder := ASource.m_CountOfSendingOrder;
  m_OrderSequence := ASource.m_OrderSequence;
  m_OrderDataType := ASource.m_OrderDataType;
  m_OrderDateTime := ASource.m_OrderDateTime;
  m_ConfirmDateTime := ASource.m_ConfirmDateTime;
  m_OrderPriceType := ASource.m_OrderPriceType;
  m_OrderPrice := ASource.m_OrderPrice;
  m_OrderVolume := ASource.m_OrderVolume;

  m_OrgOrderVolume := ASource.m_OrgOrderVolume;
  m_OrderType := ASource.m_OrderType;
  m_OrderNumber := ASource.m_OrderNumber;
  m_OrgOrderNumber := ASource.m_OrgOrderNumber;
  m_TradePrice := ASource.m_TradePrice;
  m_TradeVolume := ASource.m_TradeVolume;
  m_ProcessStep := ASource.m_ProcessStep;

  m_ConfirmTime := ASource.m_ConfirmTime;
  m_CanRetry := ASource.m_CanRetry;
  m_RetryCount := ASource.m_RetryCount;
  m_RetryCountOfReject := ASource.m_RetryCountOfReject;
  m_RetryTime := ASource.m_RetryTime;
  m_DelaySecond := ASource.m_DelaySecond;
  m_TradeValue := ASource.m_TradeValue;
  m_TradePriceOfProfit := ASource.m_TradePriceOfProfit;
  m_TradeVolumeOfProfit := ASource.m_TradeVolumeOfProfit;
  m_Profit := ASource.m_Profit;

end;
{$ENDREGION}
{$REGION 'CFNSignalCollection'}

// ---------------------------------------------------------------------------
constructor CFNSignalCollection.Create;
begin
  inherited Create;

  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CFNSignalCollection.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 배열의 구성요소를 모두 삭제한다.
procedure CFNSignalCollection.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNSignalItem(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 하나를 추가한다.
procedure CFNSignalCollection.Add(ASignalItem: CFNSignalItem);
begin
  m_Items.Add(ASignalItem);
end;

// ---------------------------------------------------------------------------
// 해당값을 가지고 있는 요소를 찾아 그 인덱스를 리턴한다.
function CFNSignalCollection.Search(ADate: TDateTime): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_SignalItem: CFNSignalItem;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_SignalItem := CFNSignalItem(m_Items.Items[f_PosX]);

      f_Compare := ADate - f_SignalItem.m_DateTime;

      if (0 > f_Compare) then
        f_PosR := f_PosX - 1
      else
        f_PosL := f_PosX + 1;
    until (not((f_Compare <> 0) and (f_PosL <= f_PosR)));

    if (0 = f_Compare) then
      Result := f_PosX
    else
      Result := -1;
  end
  else
  begin
    Result := -1;
  end;
end;

// ---------------------------------------------------------------------------
function SignalItem_Compare(Item1, Item2: Pointer): Integer;
var
  f_SignalItem1: CFNSignalItem;
  f_SignalItem2: CFNSignalItem;
  f_Compare: Double;
begin
  f_SignalItem1 := CFNSignalItem(Item1);
  f_SignalItem2 := CFNSignalItem(Item2);

  f_Compare := f_SignalItem1.m_DateTime - f_SignalItem2.m_DateTime;
  if f_Compare > 0 then
    f_Compare := 1
  else if f_Compare < 0 then
    f_Compare := -1
  else
    f_Compare := 0;

  Result := Trunc(f_Compare);
end;

// ---------------------------------------------------------------------------
// 비교함수를 이용하여 정렬한다.
procedure CFNSignalCollection.Sort;
begin
  m_Items.Sort(@SignalItem_Compare);
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하여 복제한다.
procedure CFNSignalCollection.Clone(ASource: CFNSignalCollection);
var
  f_OldSignalItem: CFNSignalItem;
  f_NewSignalItem: CFNSignalItem;
  f_Index: Integer;
begin
  Clear;
  for f_Index := 0 to ASource.m_Items.Count - 1 do
  begin
    f_OldSignalItem := CFNSignalItem(ASource.m_Items.Items[f_Index]);
    f_NewSignalItem := CFNSignalItem.Create;
    f_NewSignalItem.Clone(f_OldSignalItem);
    m_Items.Add(f_NewSignalItem);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNSignalCollection.WriteToXML(AStream: TStringStream; ANodeName: String);
var
  f_SignalItem: CFNSignalItem;
  f_Index: Integer;
begin
  AStream.WriteString('<' + ANodeName + '>' + #$0A);
  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_SignalItem := CFNSignalItem(m_Items.Items[f_Index]);
    f_SignalItem.WriteToXML(AStream);
  end;
  AStream.WriteString('</' + ANodeName + '>' + #$0A);
end;
{$ENDREGION}
{$REGION 'CFNOrderItem'}

// ---------------------------------------------------------------------------
constructor CFNOrderItem.Create;
begin
  inherited Create;

  m_TradeCollection := CFNTradeCollection.Create(false);
end;

// ---------------------------------------------------------------------------
destructor CFNOrderItem.Destroy;
begin
  if Assigned(m_TradeCollection) then
  begin
    m_TradeCollection.Free;
    m_TradeCollection := NIL;
  end;

  inherited;
end;

// ---------------------------------------------------------------------------
procedure CFNOrderItem.Clone(ASource: CFNOrderItem);
begin
  m_SignalSequence := ASource.m_SignalSequence;
  m_AdjustSequence := ASource.m_AdjustSequence;
  m_OrderSequence := ASource.m_OrderSequence;
  m_CountOfSendingOrder := ASource.m_CountOfSendingOrder;
  m_OrderDataType := ASource.m_OrderDataType;
  m_OrderType := ASource.m_OrderType;
  m_OrderDateTime := ASource.m_OrderDateTime;
  m_OrderPrice := ASource.m_OrderPrice;
  m_OrderVolume := ASource.m_OrderVolume;
  m_OrgOrderVolume := ASource.m_OrgOrderVolume;
  m_OrderPriceType := ASource.m_OrderPriceType;
  m_OrderNumber := ASource.m_OrderNumber;
  m_OrgOrderNumber := ASource.m_OrgOrderNumber;
  m_TradePrice := ASource.m_TradePrice;
  m_TradeVolume := ASource.m_TradeVolume;
  m_ProcessStep := ASource.m_ProcessStep;
  m_SignalItem := NIL;
  m_MessageCode := ASource.m_MessageCode;
  m_MessageText := ASource.m_MessageText;
end;

// ---------------------------------------------------------------------------
procedure CFNOrderItem.WriteToXML(AStream: TStringStream);
begin
  AStream.WriteString('<OrderItem>' + #$0A);
  AStream.WriteString('<m_SignalSequence>' + IntToStr(m_SignalSequence) + '</m_SignalSequence>' + #$0A);
  AStream.WriteString('<m_AdjustSequence>' + IntToStr(m_AdjustSequence) + '</m_AdjustSequence>' + #$0A);
  AStream.WriteString('<m_OrderSequence>' + IntToStr(m_OrderSequence) + '</m_OrderSequence>' + #$0A);
  AStream.WriteString('<m_OrderCollectionType>' + IntToStr(m_OrderCollectionType) + '</m_OrderCollectionType>' + #$0A);
  AStream.WriteString('<m_CountOfSendingOrder>' + IntToStr(m_CountOfSendingOrder) + '</m_CountOfSendingOrder>' + #$0A);
  AStream.WriteString('<m_OrderDataType>' + IntToStr(m_OrderDataType) + '</m_OrderDataType>' + #$0A);
  AStream.WriteString('<m_OrderType>' + IntToStr(m_OrderType) + '</m_OrderType>' + #$0A);
  AStream.WriteString('<m_OrderDateTime>' + TFNGlobal.DateTimeToString(m_OrderDateTime, 'YYYYMMDDHHMMSS') + '</m_OrderDateTime>' + #$0A);
  AStream.WriteString('<m_OrderPrice>' + FloatToStr(m_OrderPrice) + '</m_OrderPrice>' + #$0A);
  AStream.WriteString('<m_OrderVolume>' + IntToStr(m_OrderVolume) + '</m_OrderVolume>' + #$0A);
  AStream.WriteString('<m_OrderPriceType>' + IntToStr(m_OrderPriceType) + '</m_OrderPriceType>' + #$0A);
  AStream.WriteString('<m_OrderNumber>' + m_OrderNumber + '</m_OrderNumber>' + #$0A);
  AStream.WriteString('<m_OrderNumber>' + m_OrgOrderNumber + '</m_OrderNumber>' + #$0A);
  AStream.WriteString('<m_TradePrice>' + FloatToStr(m_TradePrice) + '</m_TradePrice>' + #$0A);
  AStream.WriteString('<m_TradeVolume>' + IntToStr(m_TradeVolume) + '</m_TradeVolume>' + #$0A);
  AStream.WriteString('<m_ProcessStep>' + IntToStr(m_ProcessStep) + '</m_ProcessStep>' + #$0A);
  AStream.WriteString('<m_MessageCode>' + m_MessageCode + '</m_MessageCode>' + #$0A);
  AStream.WriteString('<m_MessageText>' + m_MessageText + '</m_MessageText>' + #$0A);
  AStream.WriteString('</OrderItem>' + #$0A);
end;
{$ENDREGION}
{$REGION 'CFNOrderCollection'}

constructor CFNOrderCollection.Create(AAutoClear: Boolean = true);
begin
  inherited Create;

  m_Items := TList.Create;
  m_AutoClear := AAutoClear;
end;

destructor CFNOrderCollection.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited;
end;

procedure CFNOrderCollection.Add(AOrderItem: CFNOrderItem);
begin
  m_Items.Add(AOrderItem);
end;

procedure CFNOrderCollection.Clear;
begin
  while 0 < m_Items.Count do
  begin
    if m_AutoClear then
      CFNOrderItem(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNOrderCollection.DisableOrderBySignal(ASignalSequence: Integer);
var
  f_OrderItem: CFNOrderItem;
  f_Index: Integer;
begin
  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_OrderItem := CFNOrderItem(m_Items.Items[f_Index]);
    if (ASignalSequence = f_OrderItem.m_SignalSequence) then
    begin
      f_OrderItem.m_ProcessStep := PST_CHANGE_ORDER;
    end;
  end;
end;

// ---------------------------------------------------------------------------
function CFNOrderCollection.FindByOrderNo(AOrderNo: String): CFNOrderItem;
var
  f_OrderItem: CFNOrderItem;
  f_Index: Integer;
begin
  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_OrderItem := CFNOrderItem(m_Items.Items[f_Index]);
    if f_OrderItem.m_OrderNumber = AOrderNo then
    begin
      Result := f_OrderItem;
      exit;
    end;
  end;
  Result := NIL;
end;

// ---------------------------------------------------------------------------
procedure CFNOrderCollection.WriteToXML(AStream: TStringStream; ANodeName: String);
var
  f_OrderItem: CFNOrderItem;
  f_Index: Integer;
begin
  AStream.WriteString('<' + ANodeName + '>' + #$0A);
  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_OrderItem := CFNOrderItem(m_Items.Items[f_Index]);
    f_OrderItem.WriteToXML(AStream);
  end;
  AStream.WriteString('</' + ANodeName + '>' + #$0A);
end;

// ---------------------------------------------------------------------------
procedure CFNOrderCollection.Copy(ASource: CFNOrderCollection);
var
  f_OrderItem: CFNOrderItem;
  f_Index: Integer;
begin
  Clear;
  m_AutoClear := false;
  for f_Index := 0 to ASource.m_Items.Count - 1 do
  begin
    f_OrderItem := CFNOrderItem(ASource.m_Items.Items[f_Index]);
    m_Items.Add(f_OrderItem);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNOrderCollection.Clone(ASource: CFNOrderCollection);
var
  f_SrcOrderItem: CFNOrderItem;
  f_TagOrderItem: CFNOrderItem;
  f_Index: Integer;
begin
  Clear;
  m_AutoClear := true;
  for f_Index := 0 to ASource.m_Items.Count - 1 do
  begin
    f_SrcOrderItem := CFNOrderItem(ASource.m_Items.Items[f_Index]);
    f_TagOrderItem := CFNOrderItem.Create;
    f_TagOrderItem.Clone(f_SrcOrderItem);
    m_Items.Add(f_TagOrderItem);
  end;
end;
{$ENDREGION}
{$REGION 'CFNTradeItem'}

procedure CFNTradeItem.Clone(ASource: CFNTradeItem);
begin
  m_SignalSequence := ASource.m_SignalSequence;
  m_AdjustSequence := ASource.m_AdjustSequence;
  m_OrderSequence := ASource.m_OrderSequence;
  m_TradeSequence := ASource.m_TradeSequence;
  m_OrderType := ASource.m_OrderType;
  m_OrderPrice := ASource.m_OrderPrice;
  m_OrderVolume := ASource.m_OrderVolume;
  m_TradePrice := ASource.m_TradePrice;
  m_TradeVolume := ASource.m_TradeVolume;
  m_SignalItem := NIL;
  m_OrderItem := NIL;
end;
{$ENDREGION}
{$REGION 'CFNTradeCollection'}

constructor CFNTradeCollection.Create(AAutoClear: Boolean = true);
begin
  inherited Create;

  m_Items := TList.Create;
  m_AutoClear := AAutoClear;
end;

// ---------------------------------------------------------------------------
destructor CFNTradeCollection.Destroy;
begin
  Clear;
  m_Items.Free;
  m_Items := NIL;
  inherited;
end;

// ---------------------------------------------------------------------------
procedure CFNTradeCollection.WriteToXML(AStream: TStringStream; ANodeName: String);
var
  f_TradeItem: CFNTradeItem;
  f_Index: Integer;
begin
  AStream.WriteString('<' + ANodeName + '>' + #$0A);
  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_TradeItem := CFNTradeItem(m_Items.Items[f_Index]);
    f_TradeItem.WriteToXML(AStream);
  end;
  AStream.WriteString('</' + ANodeName + '>' + #$0A);
end;

// ---------------------------------------------------------------------------
procedure CFNTradeCollection.Clear;
begin
  while 0 < m_Items.Count do
  begin
    if m_AutoClear then
      CFNTradeItem(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
  inherited;
end;

// ---------------------------------------------------------------------------
procedure CFNTradeCollection.Add(ATradeItem: CFNTradeItem);
begin
  m_Items.Add(ATradeItem);
end;

// ---------------------------------------------------------------------------
procedure CFNTradeCollection.Copy(ASource: CFNTradeCollection);
var
  f_TradeItem: CFNTradeItem;
  f_Index: Integer;
begin
  Clear;
  m_AutoClear := false;
  for f_Index := 0 to ASource.m_Items.Count - 1 do
  begin
    f_TradeItem := CFNTradeItem(ASource.m_Items.Items[f_Index]);
    m_Items.Add(f_TradeItem);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNTradeCollection.Clone(ASource: CFNTradeCollection);
var
  f_SrcTradeItem: CFNTradeItem;
  f_TagTradeItem: CFNTradeItem;
  f_Index: Integer;
begin
  Clear;
  m_AutoClear := true;
  for f_Index := 0 to ASource.m_Items.Count - 1 do
  begin
    f_SrcTradeItem := CFNTradeItem(ASource.m_Items.Items[f_Index]);
    f_TagTradeItem := CFNTradeItem.Create;
    f_TagTradeItem.Clone(f_SrcTradeItem);
    m_Items.Add(f_TagTradeItem);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNTradeCollection.DeleteTradeItemByOrderSeq(AOrderSequence: Integer; AFree: Boolean);
var
  f_TradeItem: CFNTradeItem;
  f_Index: Integer;
  f_Done: Boolean;
begin
  f_Done := false;
  while (not f_Done) do
  begin
    f_Done := true;
    for f_Index := 0 to m_Items.Count - 1 do
    begin
      f_TradeItem := CFNTradeItem(m_Items.Items[f_Index]);
      if f_TradeItem.m_OrderSequence = AOrderSequence then
      begin
        m_Items.Delete(f_Index);
        if AFree then
        begin
          f_TradeItem.Free;
        end;
        f_Done := false;
        break;
      end;
    end;

  end;
end;

procedure CFNTradeCollection.DeleteTradeItemByAdjustSeq(AAdjustSequence: Integer; AFree: Boolean);
var
  f_TradeItem: CFNTradeItem;
  f_Index: Integer;
  f_Done: Boolean;
begin
  f_Done := false;
  while (not f_Done) do
  begin
    f_Done := true;
    for f_Index := 0 to m_Items.Count - 1 do
    begin
      f_TradeItem := CFNTradeItem(m_Items.Items[f_Index]);
      if f_TradeItem.m_AdjustSequence = AAdjustSequence then
      begin
        m_Items.Delete(f_Index);
        if AFree then
        begin
          f_TradeItem.Free;
        end;
        f_Done := false;
        break;
      end;
    end;

  end;
end;

{$ENDREGION}
{$REGION 'CFNLogCollection'}

// ---------------------------------------------------------------------------
constructor CFNLogCollection.Create;
begin
  inherited Create;

  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
destructor CFNLogCollection.Destroy;
begin
  Clear;
  m_Items.Free;
  m_Items := NIL;
  inherited;
end;

// ---------------------------------------------------------------------------
procedure CFNLogCollection.Write(AType: Integer; AMessage, AClassName: String);
var
  f_LogItem: CFNLogItem;
begin
  f_LogItem := CFNLogItem.Create;

  f_LogItem.m_DateTime := TFNGlobal.ServerNow;
  f_LogItem.m_Type := AType;
  f_LogItem.m_Message := AMessage;
  f_LogItem.m_ClassName := AClassName;

  m_Items.Add(f_LogItem);
end;

procedure CFNLogCollection.WriteToXML(AStream: TStringStream; ANodeName: String);
var
  f_LogItem: CFNLogItem;
  f_Index: Integer;
begin
  AStream.WriteString('<' + ANodeName + '>' + #$0A);
  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_LogItem := CFNLogItem(m_Items.Items[f_Index]);
    f_LogItem.WriteToXML(AStream);
  end;
  AStream.WriteString('</' + ANodeName + '>' + #$0A);
end;

// ---------------------------------------------------------------------------
procedure CFNLogCollection.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNLogItem(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
  inherited;
end;

// ---------------------------------------------------------------------------
{$ENDREGION}
{$REGION 'CFNAdjustItem'}

// ---------------------------------------------------------------------------
constructor CFNAdjustItem.Create;
begin
  inherited Create;
  m_OrderCollection := CFNOrderCollection.Create(false);
  m_TradeCollection := CFNTradeCollection.Create(false);

  m_OrderPriceType := 0;
  m_OrderDateTime := 0;
  m_ProcessStep := 0;
  m_OrderPrice := 0;
  m_OrderVolume := 0;
  m_OrderType := 0;

  m_RetryCount := 0;
  m_RetryCountOfReject := 0;
  m_RetryTime := 0;
  m_DelaySecond := MAX_DELAY_SECOND;

  m_TradeValue := 0;
  m_TradePriceOfProfit := 0;
  m_TradeVolumeOfProfit := 0;
  m_Profit := 0;
end;

// ---------------------------------------------------------------------------
destructor CFNAdjustItem.Destroy;
begin

  if Assigned(m_OrderCollection) then
  begin
    m_OrderCollection.Free;
    m_OrderCollection := NIL;
  end;
  if Assigned(m_TradeCollection) then
  begin
    m_TradeCollection.Free;
    m_TradeCollection := NIL;
  end;
  inherited;
end;

// ---------------------------------------------------------------------------
procedure CFNAdjustItem.Clone(ASource: CFNAdjustItem);
begin
  m_AdjustSequence := ASource.m_AdjustSequence;
  m_SignalSequence := ASource.m_SignalSequence;

  m_DateTime := ASource.m_DateTime;
  m_AdjustType := ASource.m_AdjustType;
  m_AdjustVolume := ASource.m_AdjustVolume;

  m_CountOfSendingOrder := ASource.m_CountOfSendingOrder;
  m_OrderSequence := ASource.m_OrderSequence;
  m_OrderDataType := ASource.m_OrderDataType;
  m_OrderDateTime := ASource.m_OrderDateTime;
  m_OrderPriceType := ASource.m_OrderPriceType;
  m_OrderPrice := ASource.m_OrderPrice;
  m_OrderVolume := ASource.m_OrderVolume;
  m_OrderType := ASource.m_OrderType;
  m_OrderNumber := ASource.m_OrderNumber;
  m_OrgOrderNumber := ASource.m_OrgOrderNumber;
  m_TradePrice := ASource.m_TradePrice;
  m_TradeVolume := ASource.m_TradeVolume;
  m_ProcessStep := ASource.m_ProcessStep;

  m_ConfirmTime := ASource.m_ConfirmTime;
  m_CanRetry := ASource.m_CanRetry;
  m_RetryCount := ASource.m_RetryCount;
  m_RetryCountOfReject := ASource.m_RetryCountOfReject;
  m_RetryTime := ASource.m_RetryTime;
  m_DelaySecond := ASource.m_DelaySecond;
  m_TradeValue := ASource.m_TradeValue;
  m_TradePriceOfProfit := ASource.m_TradePriceOfProfit;
  m_TradeVolumeOfProfit := ASource.m_TradeVolumeOfProfit;
  m_Profit := ASource.m_Profit;
end;

// ---------------------------------------------------------------------------
procedure CFNAdjustItem.SetStateLastOrder(AState: Integer);
var
  f_OrderItem: CFNOrderItem;
begin
  if m_OrderCollection.m_Items.Count > 0 then
  begin
    f_OrderItem := m_OrderCollection.m_Items.Items[m_OrderCollection.m_Items.Count - 1];
    f_OrderItem.m_ProcessStep := AState;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNAdjustItem.WriteToXML(AStream: TStringStream);
begin
  AStream.WriteString('<AdjustItem>' + #$0A);

  AStream.WriteString('<m_AdjustSequence>' + IntToStr(m_AdjustSequence) + '</m_AdjustSequence>' + #$0A);
  AStream.WriteString('<m_SignalSequence>' + IntToStr(m_SignalSequence) + '</m_SignalSequence>' + #$0A);
  AStream.WriteString('<m_DateTime>' + TFNGlobal.DateTimeToString(m_DateTime, 'YYYYMMDDHHMMSS') + '</m_DateTime>' + #$0A);
  AStream.WriteString('<m_AdjustType>' + IntToStr(m_AdjustType) + '</m_AdjustType>' + #$0A);
  AStream.WriteString('<m_AdjustVolume>' + IntToStr(m_AdjustVolume) + '</m_AdjustVolume>' + #$0A);

  AStream.WriteString('<m_CountOfSendingOrder>' + IntToStr(m_CountOfSendingOrder) + '</m_CountOfSendingOrder>' + #$0A);
  AStream.WriteString('<m_OrderSequence>' + IntToStr(m_OrderSequence) + '</m_OrderSequence>' + #$0A);
  AStream.WriteString('<m_OrderDataType>' + IntToStr(m_OrderDataType) + '</m_OrderDataType>' + #$0A);
  AStream.WriteString('<m_OrderDateTime>' + TFNGlobal.DateTimeToString(m_OrderDateTime, 'YYYYMMDDHHMMSS') + '</m_OrderDateTime>' + #$0A);
  AStream.WriteString('<m_OrderPriceType>' + IntToStr(m_OrderPriceType) + '</m_OrderPriceType>' + #$0A);
  AStream.WriteString('<m_OrderPrice>' + FloatToStr(m_OrderPrice) + '</m_OrderPrice>' + #$0A);
  AStream.WriteString('<m_OrderVolume>' + IntToStr(m_OrderVolume) + '</m_OrderVolume>' + #$0A);
  AStream.WriteString('<m_OrderType>' + IntToStr(m_OrderType) + '</m_OrderType>' + #$0A);
  AStream.WriteString('<m_ConfirmDateTime>' + TFNGlobal.DateTimeToString(m_ConfirmDateTime, 'YYYYMMDDHHMMSS') + '</m_ConfirmDateTime>' + #$0A);

  AStream.WriteString('<m_OrderNumber>' + m_OrderNumber + '</m_OrderNumber>' + #$0A);
  AStream.WriteString('<m_OrgOrderNumber>' + m_OrgOrderNumber + '</m_OrgOrderNumber>' + #$0A);

  AStream.WriteString('<m_TradePrice>' + FloatToStr(m_TradePrice) + '</m_TradePrice>' + #$0A);
  AStream.WriteString('<m_TradeVolume>' + IntToStr(m_TradeVolume) + '</m_TradeVolume>' + #$0A);
  AStream.WriteString('<m_ConfirmTime>' + TFNGlobal.DateTimeToString(m_ConfirmTime, 'YYYYMMDDHHMMSS') + '</m_ConfirmTime>' + #$0A);

  AStream.WriteString('<m_CanRetry>' + TFNGlobal.BoolToString(m_CanRetry) + '</m_CanRetry>' + #$0A);
  AStream.WriteString('<m_RetryCount>' + IntToStr(m_RetryCount) + '</m_RetryCount>' + #$0A);
  AStream.WriteString('<m_RetryCountOfReject>' + IntToStr(m_RetryCountOfReject) + '</m_RetryCountOfReject>' + #$0A);
  AStream.WriteString('<m_RetryTime>' + TFNGlobal.DateTimeToString(m_RetryTime, 'YYYYMMDDHHMMSS') + '</m_RetryTime>' + #$0A);
  AStream.WriteString('<m_DelaySecond>' + IntToStr(m_DelaySecond) + '</m_DelaySecond>' + #$0A);
  AStream.WriteString('<m_ProcessStep>' + IntToStr(m_ProcessStep) + '</m_ProcessStep>' + #$0A);

  AStream.WriteString('<m_TradeValue>' + FloatToStr(m_TradeValue) + '</m_TradeValue>' + #$0A);
  AStream.WriteString('<m_TradePriceOfProfit>' + FloatToStr(m_TradePriceOfProfit) + '</m_TradePriceOfProfit>' + #$0A);
  AStream.WriteString('<m_TradeVolumeOfProfit>' + IntToStr(m_TradeVolumeOfProfit) + '</m_TradeVolumeOfProfit>' + #$0A);
  AStream.WriteString('<m_Profit>' + FloatToStr(m_Profit) + '</m_Profit>' + #$0A);

  AStream.WriteString('</AdjustItem>' + #$0A);

end;

// ---------------------------------------------------------------------------
function CFNAdjustItem.GetLastOrderNumber: String;
var
  f_OrderItem: CFNOrderItem;
  f_Index: Integer;
begin
  Result := '';
  for f_Index := m_OrderCollection.m_Items.Count - 1 downto 0 do
  begin
    f_OrderItem := m_OrderCollection.m_Items.Items[f_Index];
    if f_OrderItem.m_ProcessStep = PST_REJECT_ORDER then
      continue;
    if f_OrderItem.m_ProcessStep = PST_ERROR_ORDER then
      continue;
    if f_OrderItem.m_ProcessStep = PST_FAIL_ORDER then
      continue;

    if f_OrderItem.m_OrderNumber <> '' then
    begin
      Result := f_OrderItem.m_OrderNumber;
      break;
    end;
  end;
end;

procedure CFNAdjustItem.CalcTradeVolume;
var
  f_Index: Integer;
  f_TradeItem: CFNTradeItem;
  f_TVal: Double;
begin
  m_TradeVolume := 0;
  f_TVal := 0;
  for f_Index := 0 to m_TradeCollection.m_Items.Count - 1 do
  begin
    f_TradeItem := m_TradeCollection.m_Items.Items[f_Index];
    m_TradeVolume := m_TradeVolume + f_TradeItem.m_TradeVolume;
    f_TVal := f_TVal + f_TradeItem.m_TradePrice * f_TradeItem.m_TradeVolume;
    m_TradePrice := f_TVal / m_TradeVolume;
  end;
end;
{$ENDREGION}
{$REGION 'CFNAdjustCollection'}

// ---------------------------------------------------------------------------
constructor CFNAdjustCollection.Create;
begin
  inherited Create;

  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
destructor CFNAdjustCollection.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 하나를 추가한다.
procedure CFNAdjustCollection.Add(AAdjustItem: CFNAdjustItem);
begin
  m_Items.Add(AAdjustItem);
end;

// ---------------------------------------------------------------------------
procedure CFNAdjustCollection.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNAdjustItem(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNAdjustCollection.Clone(ASource: CFNAdjustCollection);
var
  f_OldAdjustItem: CFNAdjustItem;
  f_NewAdjustItem: CFNAdjustItem;
  f_Index: Integer;
begin
  Clear;
  for f_Index := 0 to ASource.m_Items.Count - 1 do
  begin
    f_OldAdjustItem := CFNAdjustItem(ASource.m_Items.Items[f_Index]);
    f_NewAdjustItem := CFNAdjustItem.Create;
    f_NewAdjustItem.Clone(f_OldAdjustItem);
    m_Items.Add(f_NewAdjustItem);
  end;
end;

// ---------------------------------------------------------------------------
function CFNAdjustCollection.GetTotalPosition: Integer;
var
  f_AdjustItem: CFNAdjustItem;
  f_Index: Integer;
  f_Sign: Integer;
  f_Position: Integer;
begin

  f_Position := 0;
  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_AdjustItem := CFNAdjustItem(m_Items.Items[f_Index]);

    if f_AdjustItem.m_AdjustType = ORDER_TYPE_BUY then
    begin
      f_Sign := 1;
    end
    else
    begin
      f_Sign := -1;
    end;
    f_Position := f_Position + f_Sign * f_AdjustItem.m_AdjustVolume;

  end;

  Result := f_Position;
end;

procedure CFNAdjustCollection.WriteToXML(AStream: TStringStream; ANodeName: String);
var
  f_AdjustItem: CFNAdjustItem;
  f_Index: Integer;
begin
  AStream.WriteString('<' + ANodeName + '>' + #$0A);
  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_AdjustItem := CFNAdjustItem(m_Items.Items[f_Index]);
    f_AdjustItem.WriteToXML(AStream);
  end;
  AStream.WriteString('</' + ANodeName + '>' + #$0A);
end;

// ---------------------------------------------------------------------------
function CFNAdjustCollection.GetAdjustPositionOfSignal(ASignalSequence: Integer): Integer;
var
  f_AdjustItem: CFNAdjustItem;
  f_Index: Integer;
  f_Sign: Integer;
  f_Position: Integer;
begin

  f_Position := 0;
  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_AdjustItem := CFNAdjustItem(m_Items.Items[f_Index]);

    if f_AdjustItem.m_SignalSequence = ASignalSequence then
    begin

      if f_AdjustItem.m_AdjustType = ORDER_TYPE_BUY then
      begin
        f_Sign := 1;
      end
      else
      begin
        f_Sign := -1;
      end;

      f_Position := f_Position + f_Sign * f_AdjustItem.m_AdjustVolume;

    end;

  end;

  Result := f_Position;
end;

{$ENDREGION}

procedure CFNTradeItem.WriteToXML(AStream: TStringStream);
begin
  AStream.WriteString('<TradeItem>' + #$0A);
  AStream.WriteString('<m_SignalSequence>' + IntToStr(m_SignalSequence) + '</m_SignalSequence>' + #$0A);
  AStream.WriteString('<m_AdjustSequence>' + IntToStr(m_AdjustSequence) + '</m_AdjustSequence>' + #$0A);
  AStream.WriteString('<m_OrderSequence>' + IntToStr(m_OrderSequence) + '</m_OrderSequence>' + #$0A);
  AStream.WriteString('<m_TradeSequence>' + IntToStr(m_TradeSequence) + '</m_TradeSequence>' + #$0A);

  AStream.WriteString('<m_OrderType>' + IntToStr(m_OrderType) + '</m_OrderType>' + #$0A);
  AStream.WriteString('<m_OrderPrice>' + FloatToStr(m_OrderPrice) + '</m_OrderPrice>' + #$0A);
  AStream.WriteString('<m_OrderVolume>' + IntToStr(m_OrderVolume) + '</m_OrderVolume>' + #$0A);

  AStream.WriteString('<m_TradePrice>' + FloatToStr(m_TradePrice) + '</m_TradePrice>' + #$0A);
  AStream.WriteString('<m_TradeVolume>' + IntToStr(m_TradeVolume) + '</m_TradeVolume>' + #$0A);

  AStream.WriteString('</TradeItem>' + #$0A);
end;

{ CFNLogItem }

procedure CFNLogItem.WriteToXML(AStream: TStringStream);
begin
  AStream.WriteString('<LogItem>' + #$0A);

  AStream.WriteString('<m_BlockName>' + m_BlockName + '</m_BlockName>' + #$0A);
  AStream.WriteString('<m_DateTime>' + TFNGlobal.DateTimeToString(m_DateTime, 'YYYYMMDDHHMMSS') + '</m_DateTime>' + #$0A);
  AStream.WriteString('<m_Type>' + IntToStr(m_Type) + '</m_Type>' + #$0A);
  AStream.WriteString('<m_ClassName>' + m_ClassName + '</m_ClassName>' + #$0A);
  AStream.WriteString('<m_Message>' + m_Message + '</m_Message>' + #$0A);

  AStream.WriteString('</LogItem>' + #$0A);
end;

end.
