//**************************************************************************//
//  FileName        :   WROIOMaker.pas
//  Author          :   김무근 작성
//  Date            :   2012년 7월 10일
//  Description     :   우리선물의 문자열로 된 데이터 레코드인 전문을 자료구조형태로 변형하는 클래스인 IODataSet의
//                      필드정보를 담아 IODataSet의 객체를 리턴하는 함수들의 집합
//**************************************************************************//
unit WROIOMaker;

interface

uses IODataSet, FNIOHandler;

//  조회성 TR   -   공통 시세 정보
function Make_HCQ01120_IN(AIOHandler:CFNIOHandler; AIORecord:CFNIORecord):CFNIOHandler;
function Make_HCQ01120_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;


//  조회성 TR   -   주문에 대한 응답
function Make_ORD_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;

//  실시간 TR   -   주문 / 체결 실시간 통보
function Make_SB_ORDER_EXEC(ADataSet:CIODataSet) : CIODataSet;

function Make_RDM_OSTS1(ADataSet:CIODataSet) : CIODataSet;
function Make_RDM_EXEC(ADataSet:CIODataSet) : CIODataSet;

implementation

//---------------------------------------------------------------------------
//  조회성 TR   -   해외선물 시세 정보
function Make_HCQ01120_IN(AIOHandler:CFNIOHandler; AIORecord:CFNIORecord):CFNIOHandler;
var
    f_IOHandler:CFNIOHandler;
    f_DataSet:CFNIODataSet;
begin
    if Assigned(AIOHandler) then f_IOHandler := AIOHandler
    else f_IOHandler := CFNIOHandler.Create;

    f_IOHandler.ClearAll;

    f_DataSet := CFNIODataSet.Create;
    f_DataSet.AddFieldInfo('SYMBOL', 10, 0, FNIOVALUE_TYPE_STRING);

    f_DataSet.RecordList.Add(AIORecord);

    f_IOHandler.m_DataSetList.Add(f_DataSet);

    Result := f_IOHandler;
end;
//---------------------------------------------------------------------------
//  조회성 TR   -   해외선물 시세 정보
function Make_HCQ01120_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;
var
    f_IOHandler:CFNIOHandler;
    f_DataSet:CFNIODataSet;
begin
    if Assigned(AIOHandler) then f_IOHandler := AIOHandler
    else f_IOHandler := CFNIOHandler.Create;

    f_IOHandler.ClearAll;

    f_DataSet := CFNIODataSet.Create(1, 0);
    f_DataSet.AddFieldInfo('SYMBOL'                 , 10, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('NAME'                   , 50, 0, FNIOVALUE_TYPE_STRING);

    f_DataSet.AddFieldInfo('CLOSE_PRICE'            , 10, 2, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('CHANGE_SIGN'            ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('CHANGE'                 , 10, 2, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('CHANGERATE'             , 10, 2, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('PREVCHANGE_SIGN'        ,  1, 0, FNIOVALUE_TYPE_STRING);

    f_DataSet.AddFieldInfo('OPEN_PRICE'             , 10, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('HIGH_PRICE'             , 10, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('LOW_PRICE'              , 10, 0, FNIOVALUE_TYPE_DOUBLE);

    f_DataSet.AddFieldInfo('VHIGH_PRICE'            , 10, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('VHIGH_DATE'             ,  8, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('VLOW_PRICE'             , 10, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('VLOW_DATE'              ,  8, 0, FNIOVALUE_TYPE_STRING);

    f_DataSet.AddFieldInfo('DATE'                   ,  8, 0, FNIOVALUE_TYPE_STRING);

    f_DataSet.AddFieldInfo('UP_VOLUME'              , 10, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('DN_VOLUME'              , 10, 0, FNIOVALUE_TYPE_DOUBLE);

    f_DataSet.AddFieldInfo('TOTAL_VOLUME'           , 10, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('LASTTRADINGDATE'        ,  8, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('JS_PRICE'               , 10, 2, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('JS_DAY'                 ,  8, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('JS_DAYCOUNT'            ,  5, 0, FNIOVALUE_TYPE_INTEGER);

    f_DataSet.AddFieldInfo('BEST_OFFER_PRICE'       , 10, 2, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('BEST_BID_PRICE'         , 10, 2, FNIOVALUE_TYPE_DOUBLE);

    f_IOHandler.m_DataSetList.Add(f_DataSet);

    Result := f_IOHandler;
end;

//---------------------------------------------------------------------------
//  조회성 TR   -   주문에 대한 응답
function Make_ORD_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;
var
    f_IOHandler:CFNIOHandler;
    f_DataSet:CFNIODataSet;
begin
    if Assigned(AIOHandler) then f_IOHandler := AIOHandler
    else f_IOHandler := CFNIOHandler.Create;

    f_IOHandler.ClearAll;

    f_DataSet := CFNIODataSet.Create(1, 0);
    f_DataSet.AddFieldInfo('COUNT'                  ,  3, 0, FNIOVALUE_TYPE_INTEGER);   //  주문갯수
    f_DataSet.AddFieldInfo('MESSAGE_CODE'           ,  5, 0, FNIOVALUE_TYPE_STRING);    //  메시지 코드
    f_DataSet.AddFieldInfo('ORDER_NO'               ,  5, 0, FNIOVALUE_TYPE_STRING);    //  주문번호
    f_DataSet.AddFieldInfo('CLIENT_DEF'             ,  5, 0, FNIOVALUE_TYPE_STRING);    //  고객지정번호

    f_IOHandler.m_DataSetList.Add(f_DataSet);

    Result := f_IOHandler;
end;

//---------------------------------------------------------------------------
//  실시간 TR   -   주문 / 체결 실시간 통보
function Make_SB_ORDER_EXEC(ADataSet:CIODataSet) : CIODataSet;
var
    f_DataSet:CIODataSet;
begin
    if Assigned(ADataSet) then f_DataSet := ADataSet
    else f_DataSet := CIODataSet.Create;

    f_DataSet.ClearAll;

    //  【PUSH DATA 공통】
    f_DataSet.AddFieldInfo('USERID'             , 16,  0, IOVALUE_TYPE_STRING);     //  사용자 ID
    f_DataSet.AddFieldInfo('ORDERUSERID'        ,  8,  0, IOVALUE_TYPE_STRING);     //  주문사용자 ID
    f_DataSet.AddFieldInfo('USERNAME'           , 20,  0, IOVALUE_TYPE_STRING);     //  사용자명
    f_DataSet.AddFieldInfo('IPADDRESS'          , 15,  2, IOVALUE_TYPE_STRING);     //  주문입력 IP
    f_DataSet.AddFieldInfo('REALDATA_GB'        ,  1,  0, IOVALUE_TYPE_STRING);     //  실시간 데이터 구분      //  1;단말용, 2:단말외(팀, 관리, 계좌), 3:복수계좌, A:대외계
    f_DataSet.AddFieldInfo('ORDER_METHODE'      ,  1,  0, IOVALUE_TYPE_STRING);     //  주문유형                //  1:계좌주문체결, 2:그룹주문체결, 3:복수계좌주문(체결), 4:복수게좌주문(잔고), 5:STOP, 6:FIX주문, 7:FIX예약주문, 8:일반예약주문, A:업무용 메시지, B:은행계좌명 조회
    f_DataSet.AddFieldInfo('DISPLAY_GB1'        ,  1,  0, IOVALUE_TYPE_STRING);     //  DISPLAY 구분            //  0:Default, 1:Modal
    f_DataSet.AddFieldInfo('DISPLAY_GB2'        ,  1,  0, IOVALUE_TYPE_STRING);     //  DISPLAY 구분2           //  0:Default, 1:PopUp
    f_DataSet.AddFieldInfo('DISPLAY_GB3'        ,  1,  0, IOVALUE_TYPE_STRING);     //  DISPLAY 구분3           //  0:Default, 1:Ticker
    f_DataSet.AddFieldInfo('MED_DIV'            ,  1,  0, IOVALUE_TYPE_STRING);     //  매체구분                //  C:Client API
    f_DataSet.AddFieldInfo('FILLER1'            ,  2,  0, IOVALUE_TYPE_STRING);     //  Filler

    //  【주문체결 내역】
    f_DataSet.AddFieldInfo('DATADIV'            ,  2,  0, IOVALUE_TYPE_STRING);     //  데이터 구분             //  12:거래소접수, 13:확인, 14:체결, 15:원주문데이타변경, 19:거부
    f_DataSet.AddFieldInfo('BRKGACNTNO'         ,  6,  0, IOVALUE_TYPE_STRING);     //  계좌번호
    f_DataSet.AddFieldInfo('ACNTNM'             , 30,  0, IOVALUE_TYPE_STRING);     //  계좌명
    f_DataSet.AddFieldInfo('COMBODIV'           ,  1,  0, IOVALUE_TYPE_STRING);     //  정형복합구분            //  1:일반, 2:정형복합, 3:비정형복합
    f_DataSet.AddFieldInfo('BRACHNO'            ,  3,  0, IOVALUE_TYPE_STRING);     //  지점번호
    f_DataSet.AddFieldInfo('ORDNO'              ,  7,  0, IOVALUE_TYPE_STRING);     //  주문번호
    f_DataSet.AddFieldInfo('OCOSEQNO'           ,  8,  0, IOVALUE_TYPE_STRING);     //  OCO SEQNO
    f_DataSet.AddFieldInfo('SERIES'             , 10,  0, IOVALUE_TYPE_STRING);     //  종목코드 (거래소)
    f_DataSet.AddFieldInfo('ORDDIV'             ,  1,  0, IOVALUE_TYPE_STRING);     //  주문구분                //  1:정상, 2:정정, 3:취소
    f_DataSet.AddFieldInfo('ORDTYP'             ,  1,  0, IOVALUE_TYPE_STRING);     //  주문유형                //  1:지정가, 2:시장가, 3:시간외, 4:최유리지정가
    f_DataSet.AddFieldInfo('EXECQTYDIV'         ,  1,  0, IOVALUE_TYPE_STRING);     //  체결수량구분            //  1:FAS, 2:FOK, 3:FAK
    f_DataSet.AddFieldInfo('DEALDIV'            ,  1,  0, IOVALUE_TYPE_STRING);     //  거래유형                //  1: 차익, 2:헤지, 3:기타
    f_DataSet.AddFieldInfo('TRDDIV'             ,  1,  0, IOVALUE_TYPE_STRING);     //  매매구분                //  1: 매수, 2:매도
    f_DataSet.AddFieldInfo('ORDPX'              , 10,  0, IOVALUE_TYPE_STRING);     //  주문가격
    f_DataSet.AddFieldInfo('ORDQTY'             ,  5,  0, IOVALUE_TYPE_STRING);     //  주문수량
    f_DataSet.AddFieldInfo('EXECPX'             , 10,  0, IOVALUE_TYPE_STRING);     //  체결가격
    f_DataSet.AddFieldInfo('EXECQTY'            ,  5,  0, IOVALUE_TYPE_STRING);     //  체결수량
    f_DataSet.AddFieldInfo('EXECAMT'            , 13,  0, IOVALUE_TYPE_STRING);     //  체결금액
    f_DataSet.AddFieldInfo('CNFMQTY'            ,  5,  0, IOVALUE_TYPE_STRING);     //  취소확인수량            //  취소주문에 대한 확인 수량
    f_DataSet.AddFieldInfo('CRRTQTY'            ,  5,  0, IOVALUE_TYPE_STRING);     //  정정수량
    f_DataSet.AddFieldInfo('CXLQTY'             ,  5,  0, IOVALUE_TYPE_STRING);     //  취소수량
    f_DataSet.AddFieldInfo('REMNANT'            ,  5,  0, IOVALUE_TYPE_STRING);     //  잔량
    f_DataSet.AddFieldInfo('PAORDNO'            ,  7,  0, IOVALUE_TYPE_STRING);     //  모주문번호
    f_DataSet.AddFieldInfo('ORGNORDNO'          ,  7,  0, IOVALUE_TYPE_STRING);     //  원주문번호
    f_DataSet.AddFieldInfo('ORDFRM'             ,  1,  0, IOVALUE_TYPE_STRING);     //  주문형태                //  1:일반주문, 2:STOP주문, 3:SCALE주문, 4:반복주문, 5:복수주문 6:OCO주문, 7:대기주문
    f_DataSet.AddFieldInfo('GRPID'              ,  3,  0, IOVALUE_TYPE_STRING);     //  그룹ID
    f_DataSet.AddFieldInfo('GRPNM'              , 20,  0, IOVALUE_TYPE_STRING);     //  그룹명                  //  복수계좌명
    f_DataSet.AddFieldInfo('REJCD'              , 10,  0, IOVALUE_TYPE_STRING);     //  거래소접수코드          //  거부코드
    f_DataSet.AddFieldInfo('ORDSTTS'            ,  1,  0, IOVALUE_TYPE_STRING);     //  처리코드                //  1:접수전, 2:접수, 3:확인, 4:체결, 5:전량 미체결, 9:거부
    f_DataSet.AddFieldInfo('ORDSTTSNM'          , 14,  0, IOVALUE_TYPE_STRING);     //  주문상태명              //  접수전, 미체결, 일부체결, 체결, 전량미체결, 거부
    f_DataSet.AddFieldInfo('ORDINPUTTIME'       ,  8,  0, IOVALUE_TYPE_STRING);     //  주문입력시간

    //  【상세체결 내역】
    f_DataSet.AddFieldInfo('EXECNO'             ,  9,  0, IOVALUE_TYPE_STRING);     //  체결번호
    f_DataSet.AddFieldInfo('EXECSERIES'         , 10,  0, IOVALUE_TYPE_STRING);     //  체결종목코드(거래)
    f_DataSet.AddFieldInfo('EXECTRDDIV'         ,  1,  0, IOVALUE_TYPE_STRING);     //  체결매매구분            //  1:매수, 2:매도
    f_DataSet.AddFieldInfo('EXECTIME'           ,  8,  0, IOVALUE_TYPE_STRING);     //  체결시간
    f_DataSet.AddFieldInfo('EXECPX1'            , 10,  0, IOVALUE_TYPE_STRING);     //  체결가격
    f_DataSet.AddFieldInfo('EXECQTY1'           ,  8,  0, IOVALUE_TYPE_STRING);     //  체결수량
    f_DataSet.AddFieldInfo('EXECAMT1'           , 13,  0, IOVALUE_TYPE_STRING);     //  체결금액

    Result := f_DataSet;
end;

//---------------------------------------------------------------------------
//  실시간 TR - 선물/스프레드 체결 시세
function Make_RDM_OSTS1(ADataSet:CIODataSet) : CIODataSet;
var
    f_DataSet:CIODataSet;
begin
    if Assigned(ADataSet) then f_DataSet := ADataSet
    else f_DataSet := CIODataSet.Create;

    f_DataSet.ClearAll;
    f_DataSet.AddFieldInfo('DGUBUN'             ,  4,  0, IOVALUE_TYPE_STRING);     //  Data 구분: 'CAS1'
    f_DataSet.AddFieldInfo('SYMBOL'             , 10,  0, IOVALUE_TYPE_STRING);     //  종목코드
    f_DataSet.AddFieldInfo('TIME'               ,  6,  0, IOVALUE_TYPE_STRING);     //  처리시간

    f_DataSet.AddFieldInfo('OPEN_PRICE'         , 10,  2, IOVALUE_TYPE_DOUBLE);     //  시가
    f_DataSet.AddFieldInfo('HIGH_PRICE'         , 10,  2, IOVALUE_TYPE_DOUBLE);     //  고가
    f_DataSet.AddFieldInfo('LOW_PRICE'          , 10,  2, IOVALUE_TYPE_DOUBLE);     //  저가
    f_DataSet.AddFieldInfo('CLOSE_PRICE'        , 10,  2, IOVALUE_TYPE_DOUBLE);     //  체결가
    f_DataSet.AddFieldInfo('SIGN'               ,  1,  0, IOVALUE_TYPE_STRING);     //  전일대비구분
    f_DataSet.AddFieldInfo('CHANGE'             , 10,  2, IOVALUE_TYPE_DOUBLE);     //  전일대비

    f_DataSet.AddFieldInfo('CHANGERATE'         ,  6,  2, IOVALUE_TYPE_DOUBLE);     //  등락율

    f_DataSet.AddFieldInfo('PREVSIGN'           ,  1,  0, IOVALUE_TYPE_STRING);     //  전일대비구분
    f_DataSet.AddFieldInfo('VOLUME'             ,  6,  0, IOVALUE_TYPE_DOUBLE);     //  건별체결수량

    f_DataSet.AddFieldInfo('CHGUBUL'            ,  1,  0, IOVALUE_TYPE_STRING);     //  체결구분('+':매수 '-':매도)

    f_DataSet.AddFieldInfo('TOTAL_VOLUME'       , 10,  0, IOVALUE_TYPE_DOUBLE);     //  누적체결수량
    f_DataSet.AddFieldInfo('TOTAL_VALUE'        , 12,  2, IOVALUE_TYPE_DOUBLE);     //  누적거래대금

    f_DataSet.AddFieldInfo('UP_VOLUME'          , 10,  0, IOVALUE_TYPE_DOUBLE);     //  상승거래량
    f_DataSet.AddFieldInfo('DN_VOLUME'          , 10,  0, IOVALUE_TYPE_DOUBLE);     //  하락거래량

    f_DataSet.AddFieldInfo('UP_COUNT'           ,  6,  0, IOVALUE_TYPE_INTEGER);    //  상승건수
    f_DataSet.AddFieldInfo('DN_COUNT'           ,  6,  0, IOVALUE_TYPE_INTEGER);    //  하락건수

    f_DataSet.AddFieldInfo('BEST_OFFER_PRICE'   , 10,  2, IOVALUE_TYPE_DOUBLE);     //  매도우선호가
    f_DataSet.AddFieldInfo('BEST_BID_PRICE'     , 10,  2, IOVALUE_TYPE_DOUBLE);     //  매수우선호가

    f_DataSet.AddFieldInfo('MDHOREM'            ,  8,  0, IOVALUE_TYPE_STRING);     //
    f_DataSet.AddFieldInfo('MSHOREM'            ,  8,  0, IOVALUE_TYPE_STRING);     //

    f_DataSet.AddFieldInfo('SEQNO'              ,  8,  0, IOVALUE_TYPE_STRING);     //

    f_DataSet.AddFieldInfo('CLOSE_PRICE_D'      , 15,  2, IOVALUE_TYPE_STRING);     //
    f_DataSet.AddFieldInfo('DATE'               ,  8,  0, IOVALUE_TYPE_STRING);     //  영업일

    f_DataSet.AddFieldInfo('SYMBOL2'            , 10,  0, IOVALUE_TYPE_STRING);     //  종목코드
    f_DataSet.AddFieldInfo('TIME2'              ,  6,  0, IOVALUE_TYPE_STRING);     //  처리시간



    Result := f_DataSet;
end;

//---------------------------------------------------------------------------
//  실시간 TR   -   주문 / 체결 실시간 통보
function Make_RDM_EXEC(ADataSet:CIODataSet) : CIODataSet;
var
    f_DataSet:CIODataSet;
begin
    if Assigned(ADataSet) then f_DataSet := ADataSet
    else f_DataSet := CIODataSet.Create;

    f_DataSet.ClearAll;

    //  【PUSH DATA 공통】
    f_DataSet.AddFieldInfo('USERID'             ,  8,  0, IOVALUE_TYPE_STRING);     //  사용자 ID
    f_DataSet.AddFieldInfo('ORDERUSERID'        ,  8,  0, IOVALUE_TYPE_STRING);     //  주문사용자 ID
    f_DataSet.AddFieldInfo('USERNAME'           , 40,  0, IOVALUE_TYPE_STRING);     //  사용자명
    f_DataSet.AddFieldInfo('IPADDRESS'          , 15,  0, IOVALUE_TYPE_STRING);     //  주문입력 IP
    f_DataSet.AddFieldInfo('ORDTEAMCD'          ,  3,  0, IOVALUE_TYPE_STRING);     //  주문입력 팀 코드
    f_DataSet.AddFieldInfo('ORDPARTCD'          ,  3,  0, IOVALUE_TYPE_STRING);     //  주문입력 파트 코드
    f_DataSet.AddFieldInfo('pushpktdiv'         ,  1,  0, IOVALUE_TYPE_STRING);     //  PUSH 패킷 유형
    f_DataSet.AddFieldInfo('MED_DIV'            ,  1,  0, IOVALUE_TYPE_STRING);     //  매체구분
    f_DataSet.AddFieldInfo('FILLER1'            ,  5,  0, IOVALUE_TYPE_STRING);     //  예비영역

    //  【주문체결 내역】
    f_DataSet.AddFieldInfo('DATADIV'            ,  2,  0, IOVALUE_TYPE_STRING);     //  데이터 구분             12:주문접수, 13:정정확인, 14:체결, 15:원주문데이타변경, 16:취소확인, 19:거부
    f_DataSet.AddFieldInfo('BRKGACNTNO'         , 10,  0, IOVALUE_TYPE_STRING);     //  계좌번호
    f_DataSet.AddFieldInfo('ACNTNM'             , 40,  0, IOVALUE_TYPE_STRING);     //  계좌명
    f_DataSet.AddFieldInfo('COMMDCD'            ,  5,  0, IOVALUE_TYPE_STRING);     //  거래대상코드
    f_DataSet.AddFieldInfo('ORDNO'              ,  5,  0, IOVALUE_TYPE_STRING);     //  주문번호
    f_DataSet.AddFieldInfo('SERIES'             , 30,  0, IOVALUE_TYPE_STRING);     //  종목코드
    f_DataSet.AddFieldInfo('SERIESNM'           , 50,  0, IOVALUE_TYPE_STRING);     //  종목명
    f_DataSet.AddFieldInfo('CURRENCYCD'         ,  3,  0, IOVALUE_TYPE_STRING);     //  통화코드                KRW:원화, EUR:유로, JPY:엔화, USD:달러
    f_DataSet.AddFieldInfo('ORDDIV'             ,  2,  0, IOVALUE_TYPE_STRING);     //  주문구분                //  11:신규매수, 12:신규매도, 21:정정매수, 22:정정매도, 31:취소매수, 32:취소매도
    f_DataSet.AddFieldInfo('ORDTYP'             ,  1,  0, IOVALUE_TYPE_STRING);     //  주문유형                //  1:시장가, 2:지장가, 3:Stop-Market, 4: STOP-LIMIT  f_DataSet.AddFieldInfo('EXECQTYDIV'         ,  1,  0, IOV2ALUE_TYPE_STRING);    //  체결수량구분            //  1:FAS, 2:FOK, 3:FAK
    f_DataSet.AddFieldInfo('DEALDIV'            ,  1,  0, IOVALUE_TYPE_STRING);     //  거래유형                //  1: 차익, 2:헤지, 3:기타

    f_DataSet.AddFieldInfo('ORDPX'              , 12,  0, IOVALUE_TYPE_STRING);     //  주문가격
    f_DataSet.AddFieldInfo('ORDQTY'             ,  8,  0, IOVALUE_TYPE_STRING);     //  주문수량
    f_DataSet.AddFieldInfo('EXECPX'             , 12,  0, IOVALUE_TYPE_STRING);     //  체결평균가격
    f_DataSet.AddFieldInfo('EXECQTY'            ,  8,  0, IOVALUE_TYPE_STRING);     //  체결평균가격
    f_DataSet.AddFieldInfo('STOPPX'             , 12,  0, IOVALUE_TYPE_STRING);     //  스탑가격
    f_DataSet.AddFieldInfo('CNFMQTY_W'          ,  8,  0, IOVALUE_TYPE_STRING);     //  취소확인수량            //  취소주문에 대한 확인 수량
    f_DataSet.AddFieldInfo('CNFMQTY_M'          ,  8,  0, IOVALUE_TYPE_STRING);     //  정정확인수량
    f_DataSet.AddFieldInfo('REMNANT'            ,  8,  0, IOVALUE_TYPE_STRING);     //  잔량
    f_DataSet.AddFieldInfo('PAORDNO'            ,  5,  0, IOVALUE_TYPE_STRING);     //  모주문번호
    f_DataSet.AddFieldInfo('ORGNORDNO'          ,  5,  0, IOVALUE_TYPE_STRING);     //  원주문번호
    f_DataSet.AddFieldInfo('GRPID'              ,  3,  0, IOVALUE_TYPE_STRING);     //  그룹ID
    f_DataSet.AddFieldInfo('GRPNM'              , 30,  0, IOVALUE_TYPE_STRING);     //  그룹명                  //  복수계좌명
    f_DataSet.AddFieldInfo('REJCDMSG'           ,100,  0, IOVALUE_TYPE_STRING);     //  거부코드메시지

    f_DataSet.AddFieldInfo('ORDSTTS'            ,  1,  0, IOVALUE_TYPE_STRING);     //  처리코드                //  0:접수전, 1:체결전, 2:부분체결, 3:완료, 4:거부
    f_DataSet.AddFieldInfo('ORDSTTSNM'          , 20,  0, IOVALUE_TYPE_STRING);     //  주문상태명
    f_DataSet.AddFieldInfo('ORDINPUTTIME'       ,  8,  0, IOVALUE_TYPE_STRING);     //  주문입력시간
    f_DataSet.AddFieldInfo('ORDINPUTTIMEKO'     ,  8,  0, IOVALUE_TYPE_STRING);     //  한국주문입력시간
    f_DataSet.AddFieldInfo('BIZDATE'            ,  8,  0, IOVALUE_TYPE_STRING);     //  시스템영업일자
    f_DataSet.AddFieldInfo('BIZDATEKO'          ,  8,  0, IOVALUE_TYPE_STRING);     //  한국시스템영업일자
    f_DataSet.AddFieldInfo('TTTTTTT'            ,  5,  0, IOVALUE_TYPE_STRING);     //  체결거래대상코드

    //  【상세체결 내역】
    f_DataSet.AddFieldInfo('EXECNO'             , 15,  0, IOVALUE_TYPE_STRING);     //  체결번호
    f_DataSet.AddFieldInfo('EXECSERIES'         , 30,  0, IOVALUE_TYPE_STRING);     //  체결종목코드(거래)
    f_DataSet.AddFieldInfo('EXECSERIESNM'       , 50,  0, IOVALUE_TYPE_STRING);     //  종목명
    f_DataSet.AddFieldInfo('EXECTRDDIV'         ,  1,  0, IOVALUE_TYPE_STRING);     //  체결매매구분            //  1:매수, 2:매도
    f_DataSet.AddFieldInfo('EXECTIME'           ,  8,  0, IOVALUE_TYPE_STRING);     //  체결시간
    f_DataSet.AddFieldInfo('EXECTIMEKO'         ,  8,  0, IOVALUE_TYPE_STRING);     //  체결시간
    f_DataSet.AddFieldInfo('EXECPX1'            , 12,  0, IOVALUE_TYPE_STRING);     //  체결가격
    f_DataSet.AddFieldInfo('EXECQTY1'           ,  8,  0, IOVALUE_TYPE_STRING);     //  체결수량
    f_DataSet.AddFieldInfo('EXECAMT1'           , 19,  0, IOVALUE_TYPE_STRING);     //  체결금액
    f_DataSet.AddFieldInfo('EXECGB'             ,  1,  0, IOVALUE_TYPE_STRING);     //  구분(매입매수)

    //  【잔고 내역】
    f_DataSet.AddFieldInfo('NOEXECCT'           ,  8,  0, IOVALUE_TYPE_STRING);     //  미결제수량
    f_DataSet.AddFieldInfo('CANZEROPOSCT'       ,  8,  0, IOVALUE_TYPE_STRING);     //  청산가능수량


    Result := f_DataSet;
end;

end.

