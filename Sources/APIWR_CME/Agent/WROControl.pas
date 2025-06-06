unit WROControl;

interface

uses
  Windows, SysUtils, Classes, Controls, Messages, FNFile;

const
    WM_RECEIVE_DATA         =   WM_USER + 600;
    WM_RECEIVE_MSG          =   WM_USER + 612;
    WM_RECEIVE_REAL_DATA    =   WM_USER + 613;
    WM_SOCKET_STATUS        =   WM_USER + 622;

    RQNAME_LEN              =   20;
    TRCODE_LEN              =   20;
    TRNAME_LEN              =   8;
type
    TWROSocketStatusEvent = Procedure(ASender: TObject; ASatus:Integer) of Object;
    TWRORecvDataEvent = Procedure(ASender: TObject; ATrCode: String; ARQID: Integer; ALength: Integer; AData: String; ADataPointer:Pointer) of object;
    TWRORecvMsgEvent = Procedure(ASender: TObject; AFlag: String; AMsg: String) of object;
    TWRORecvRealDataEvent = Procedure(ASender: TObject; AKey: Integer; ALength: Integer; AData: AnsiString; ADataPointer:Pointer) of object;

    pWROReplyData = ^TWROReplyData;
    TWROReplyData = record
        MinorID     :   Byte;
        KeyValue    :   Byte;
        RQName      :   Array [0..RQNAME_LEN+TRNAME_LEN+2-1] of Char;
        TranRecord  :   Array [0..30] of Char;
        Nexttp      :   Char;
        DataSize    :   LongInt;
        lpData      :   PAnsiChar;
    end;

    pWROReplyMessage = ^TWROReplyMessage;
    TWROReplyMessage = record
        ErrorFlag : Byte;
        lpMessage : PAnsiChar;
    end;

    TWROControl = class(TWinControl)
    protected
        m_Connected : Boolean;

    public
        constructor Create(AOwner:TComponent); override;

        function RegisterHWD : Boolean;

        // 서버연결 관련
        function CommLogin(AUserID:AnsiString; AUserPW:AnsiString; ACertPW:AnsiString) : Integer;

        //
        procedure CommTerminate(ASocketClose:Boolean = true);

        // 조회요청 함수
        function RequestData(const ATRCode:AnsiString; AData:PAnsiChar; ADataSize:Integer;
                    ATimeOut:Integer = 30;
                    AEncrypt:Boolean=false;
                    ACompress:Boolean=false;
                    ADownLoad:Boolean=false;
                    AProgressType:Integer=-1;
                    AWaitCursor:Boolean=false;
                    AMinorID:Byte=1) : Byte;

        function GetMasterFileFromServer: Byte;

	    // 실시간 등록
        function CommSetBroadReal(ARealGubun:Byte; AKey:AnsiString) : Boolean;

	    // 리얼 부분키 해제
        function CommRemoveBroadReal(ARealGubun:Byte; AKey:AnsiString) : Boolean;




        // 신규주문 : 화면핸들, 계좌번호, 계좌비밀번호,
        //            종목코드,매수/도(1,2),주문유형(일반1, STOP2),체결형태(2지정가,1시장가,STOP-Market,STOP-Limit)
        //            주문수량,주문가격(호가대로),Stop조건가격
        function SendNewOrder (
                    AAccountNO:AnsiString;
                    AAccountPW:AnsiString;
                    ASymbol:AnsiString;
                    ABuySell:Integer;
                    AOrderType:Integer;
                    AFillType:Integer;
                    AOrderQty:Integer;
                    AOrderPx:AnsiString;
                    AStopOrderPx:AnsiString;
                    ACustID:Integer=0) : AnsiString;


        // 정정주문 : 화면핸들, 계좌번호, 계좌비밀번호,
        //            종목코드, 정정가격(마스크 씌운 값으로),원주문번호
        function SendModiOrder(
                    AAccountNO:AnsiString;
                    AAccountPW:AnsiString;
                    ASymbol:AnsiString;
                    AModiOrderPx:AnsiString;
                    AOrgOrdNm:AnsiString;
                    ACustID:Integer=0) : AnsiString;


        // 취소주문 : 화면핸들, 계좌번호, 계좌비밀번호,
        //            종목코드, 원주문번호
        function SendCancelOrder(
                    AAccountNO:AnsiString;
                    AAccountPW:AnsiString;
                    ASymbol:AnsiString;
                    AOrgOrdNm:AnsiString;
                    ACustID:Integer=0) : AnsiString;

        // 우리선물 시세에 마스킹 씌워 주는 함수
        function ChangePriceStrToLong(ASymbol:AnsiString) : LongInt;

        // 진법 품목의 시세(마스킹이 씌워져 있지 않은 상태)를 10진법 값으로 변환해 주는 함수
        function ChangePriceToDecimal(
                    ASymbol:AnsiString;
                    APrice:LongInt) : Double;

        // 10진법 값을 마스킹 없는 long으로 계산함
        function ChangePriceDecToLong(
                    ASymbol:AnsiString;
                    APrice:Double) : LongInt;

    protected
        function ConvertStrToInt(AString:String):Integer;
        function ConvertStrToDouble(AString:String):double;

        function ReadDouble(AValue: PAnsiChar; ASize: Integer; APrecision: Integer):Double;
        function ReadInteger(AValue: PAnsiChar; ASize: Integer):Integer;
        function ReadString(AValue: PAnsiChar; ASize: Integer):String;

    private
        m_OnSocketStatusEvent   : TWROSocketStatusEvent;
        m_OnRecvDataEvent   : TWRORecvDataEvent;
        m_OnRecvMsgEvent   : TWRORecvMsgEvent;
        m_OnRecvRealDataEvent   : TWRORecvRealDataEvent;

        procedure WMReceiveData(var Message: TMessage); message WM_RECEIVE_DATA;
        procedure WMRecvMsg(var Message: TMessage); message WM_RECEIVE_MSG;
        procedure WMReceiveRealData(var Message: TMessage); message WM_RECEIVE_REAL_DATA;
        procedure WMSocketStatus(var Message: TMessage); message WM_SOCKET_STATUS;

    published
        property Connected               : Boolean                 read m_Connected ;
        property OnOSocketStatus : TWROSocketStatusEvent read m_OnSocketStatusEvent write m_OnSocketStatusEvent;
        property OnORecvData : TWRORecvDataEvent read m_OnRecvDataEvent write m_OnRecvDataEvent;
        property OnORecvMsg : TWRORecvMsgEvent read m_OnRecvMsgEvent write m_OnRecvMsgEvent;
        property OnORecvRealData : TWRORecvRealDataEvent read m_OnRecvRealDataEvent write m_OnRecvRealDataEvent;

    end;

procedure Register;

implementation

uses Math, WROUnit;

procedure Register;
begin
  RegisterComponents('TradeAPI', [TWROControl]);
end;

//---------------------------------------------------------------------------
function TWROControl.RegisterHWD : Boolean;
var
    f_ReturnValue : Integer;
begin
    f_ReturnValue := WROUnit.RegisterHWD(Handle);
    if f_ReturnValue = 1 then Result := true else Result := false;
end;

//---------------------------------------------------------------------------
function TWROControl.CommLogin(AUserID:AnsiString; AUserPW:AnsiString; ACertPW:AnsiString) : Integer;
var
    f_ReturnValue : Integer;
begin
    f_ReturnValue := WROUnit.CommLogin(PAnsiChar(AUserID), PAnsiChar(AUserPW), PAnsiChar(ACertPW)) ;
    Result := f_ReturnValue;
    if f_ReturnValue = 0 then m_Connected := true else m_Connected := false;
end;

//---------------------------------------------------------------------------
procedure TWROControl.CommTerminate(ASocketClose:Boolean = true);
var
    f_Value:Integer;
begin
    if ASocketClose then f_Value := 1 else f_Value := 0;
    WROUnit.CommTerminate(f_Value);
    m_Connected := false;
end;

// 조회요청 함수
//---------------------------------------------------------------------------
function TWROControl.RequestData(
    const ATRCode:AnsiString;
    AData:PAnsiChar;
    ADataSize:Integer;
    ATimeOut:Integer = 30;
    AEncrypt:Boolean=false;
    ACompress:Boolean=false;
    ADownLoad:Boolean=false;
    AProgressType:Integer=-1;
    AWaitCursor:Boolean=false;
    AMinorID:Byte=1) : Byte;
var
    f_Encrypt:Integer;
    f_Compress:Integer;
    f_DownLoad:Integer;
    f_WaitCursor:Integer;
begin
    if AEncrypt then f_Encrypt := 1 else f_Encrypt := 0;
    if ACompress then f_Compress := 1 else f_Compress := 0;
    if ADownLoad then f_DownLoad := 1 else f_DownLoad := 0;
    if AWaitCursor then f_WaitCursor := 1 else f_WaitCursor := 0;
   (*
    Result := WROUnit.RequestData
    (
        Handle, PAnsiChar(ATRCode), AData, ADataSize, ATimeOut,
        f_Encrypt,
        f_Compress,
        f_DownLoad,
        AProgressType,
        f_WaitCursor,
        AMinorID
    );
    *)
end;

//---------------------------------------------------------------------------
function TWROControl.GetMasterFileFromServer: Byte;
begin
    //Result := WROUnit.GetMasterFileFromServer;
end;

// 실시간 등록
//---------------------------------------------------------------------------
function TWROControl.CommSetBroadReal(ARealGubun:Byte; AKey:AnsiString) : Boolean;
var
    f_ReturnValue : Integer;
begin
    //f_ReturnValue := WROUnit.CommSetBroad_Real(Handle, ARealGubun, PAnsiChar(AKey));
    if f_ReturnValue = 1 then Result := true else Result := false;
end;

// 리얼 부분키 해제
//---------------------------------------------------------------------------
function TWROControl.CommRemoveBroadReal(ARealGubun:Byte; AKey:AnsiString) : Boolean;
var
    f_ReturnValue : Integer;
begin
    //f_ReturnValue := WROUnit.CommRemoveBroad_Real(Handle, ARealGubun, PAnsiChar(AKey));
    if f_ReturnValue = 1 then Result := true else Result := false;
end;

// 신규주문 : 화면핸들, 계좌번호, 계좌비밀번호,
//            종목코드,매수/도(1,2),주문유형(일반1, STOP2),체결형태(2지정가,1시장가,STOP-Market,STOP-Limit)
//            주문수량,주문가격(호가대로),Stop조건가격
//---------------------------------------------------------------------------
function TWROControl.SendNewOrder (
            AAccountNO:AnsiString;
            AAccountPW:AnsiString;
            ASymbol:AnsiString;
            ABuySell:Integer;
            AOrderType:Integer;
            AFillType:Integer;
            AOrderQty:Integer;
            AOrderPx:AnsiString;
            AStopOrderPx:AnsiString;
            ACustID:Integer=0) : AnsiString;
begin
    (*
    Result :=
    WROUnit.SendNewOrder (
                Handle,
                PAnsiChar(AAccountNO),
                PAnsiChar(AAccountPW),
                PAnsiChar(ASymbol),
                ABuySell,
                AOrderType,
                AFillType,
                AOrderQty,
                PAnsiChar(AOrderPx),
                PAnsiChar(AStopOrderPx),
                ACustID);
    *)
end;

procedure TWROControl.WMReceiveData(var Message: TMessage);
var
    f_ReplyData:pWROReplyData;
    f_TrCode: AnsiString;
    f_RQID:Integer;
    f_DataLen:Integer;
    f_Data:String;
begin
    (*
	f_ReplyData := pWROReplyData(Message.LParam);
	if f_ReplyData = NIL then exit;

    if not Assigned(m_OnRecvDataEvent) then exit;

    f_TrCode := AnsiString(PAnsiChar(Message.WParam));
    f_RQID := f_ReplyData.MinorID;
    f_DataLen := f_ReplyData.DataSize;
    f_Data :=  AnsiString(f_ReplyData.lpData);

    m_OnRecvDataEvent(Self, f_TrCode, f_RQID, f_DataLen, f_Data, f_ReplyData.lpData);
    *)
end;

procedure TWROControl.WMRecvMsg(var Message: TMessage);
var
    f_ReplyMessage:pWROReplyMessage;
    f_Flag: AnsiString;
    f_MSG:AnsiString;
begin
	f_ReplyMessage := pWROReplyMessage(Message.LParam);
	if f_ReplyMessage = NIL then exit;

    if not Assigned(m_OnRecvMsgEvent) then exit;

    f_Flag := Format('%c', [Char(f_ReplyMessage.ErrorFlag)]);
    f_MSG :=  AnsiString(f_ReplyMessage.lpMessage);

    m_OnRecvMsgEvent(Self, f_Flag, f_MSG);
end;

procedure TWROControl.WMReceiveRealData(var Message: TMessage);
var
    f_Key:Integer;
begin
    if not Assigned(m_OnRecvRealDataEvent) then exit;

    f_Key := Integer(Message.WParam);

    m_OnRecvRealDataEvent(Self, f_Key, 0, AnsiString(Message.LParam), Pointer(Message.LParam));
end;


procedure TWROControl.WMSocketStatus(var Message: TMessage);
var
    f_Status:Integer;
begin
	f_Status := Message.WParam;

	if (f_Status = 0) then m_Connected := false;

    if Assigned(m_OnSocketStatusEvent) then
    begin
        m_OnSocketStatusEvent(Self, f_Status);
    end;
end;

// 정정주문 : 화면핸들, 계좌번호, 계좌비밀번호,
//            종목코드, 정정가격(마스크 씌운 값으로),원주문번호
function TWROControl.SendModiOrder(
            AAccountNO:AnsiString;
            AAccountPW:AnsiString;
            ASymbol:AnsiString;
            AModiOrderPx:AnsiString;
            AOrgOrdNm:AnsiString;
            ACustID:Integer=0) : AnsiString;

begin
    (*
    Result :=
    WROUnit.SendModiOrder (
                Handle,
                PAnsiChar(AAccountNO),
                PAnsiChar(AAccountPW),
                PAnsiChar(ASymbol),
                PAnsiChar(AModiOrderPx),
                PAnsiChar(AOrgOrdNm),
                ACustID);
    *)
end;

// 취소주문 : 화면핸들, 계좌번호, 계좌비밀번호,
//            종목코드, 원주문번호
function TWROControl.SendCancelOrder(
            AAccountNO:AnsiString;
            AAccountPW:AnsiString;
            ASymbol:AnsiString;
            AOrgOrdNm:AnsiString;
            ACustID:Integer=0) : AnsiString;
begin
    (*
    Result :=
    WROUnit.SendCancelOrder (
                Handle,
                PAnsiChar(AAccountNO),
                PAnsiChar(AAccountPW),
                PAnsiChar(ASymbol),
                PAnsiChar(AOrgOrdNm),
                ACustID);
    *)
end;

// 우리선물 시세에 마스킹 씌워 주는 함수
function TWROControl.ChangePriceStrToLong(ASymbol:AnsiString) : LongInt;
begin
    //Result := WROUnit.ChangePriceStrToLong(PAnsiChar(ASymbol));
end;

// 진법 품목의 시세(마스킹이 씌워져 있지 않은 상태)를 10진법 값으로 변환해 주는 함수
function TWROControl.ChangePriceToDecimal(ASymbol:AnsiString; APrice:LongInt) : Double;
begin
    //Result := WROUnit.ChangePriceToDecimal(PAnsiChar(ASymbol), APrice);
end;

// 10진법 값을 마스킹 없는 long으로 계산함
function TWROControl.ChangePriceDecToLong(ASymbol:AnsiString; APrice:Double) : LongInt;
begin
    //Result := WROUnit.ChangePriceDecToLong(PAnsiChar(ASymbol), APrice);
end;







//---------------------------------------------------------------------------
function TWROControl.ConvertStrToInt(AString:String):Integer;
var
    f_String:String;
begin
    f_String := Trim(AString);
    if f_String = '' then
    begin
        result := 0;
        exit;
    end;
    try
        result := StrToInt(f_String);
    except
        result := 0;
    end;
end;

constructor TWROControl.Create(AOwner: TComponent);
begin
    inherited;
    //RegisterHWD;
end;

//---------------------------------------------------------------------------
function TWROControl.ConvertStrToDouble(AString:String):double;
var
    f_String:String;
begin
    f_String := Trim(AString);
    if f_String = '' then
    begin
        result := 0;
        exit;
    end;
    try
        result := StrToFloat(f_String);
    except
        result := 0;
    end;
end;
//---------------------------------------------------------------------------
function TWROControl.ReadDouble(AValue: PAnsiChar; ASize: Integer; APrecision: Integer):Double;
var
    f_Source : String;
begin
    f_Source := ReadString(AValue, ASize);
    Result := ConvertStrToDouble(f_Source) / Power(10, APrecision);
end;

//---------------------------------------------------------------------------
function TWROControl.ReadInteger(AValue: PAnsiChar; ASize: Integer):Integer;
var
    f_Source : String;
begin
    f_Source := ReadString(AValue, ASize);
    Result := ConvertStrToInt(f_Source);
end;

//---------------------------------------------------------------------------
function TWROControl.ReadString(AValue: PAnsiChar; ASize: Integer):String;
var
    f_Buffer : PAnsiChar;
begin
    f_Buffer := AllocMem(ASize + 1);
    FillChar(f_Buffer^, ASize + 1, $0);
    StrPLCopy(f_Buffer, AValue, ASize);
    Result := String(f_Buffer);
    FreeMem(f_Buffer);
end;

end.
