//**************************************************************************//
//  FileName        :   WRIOMaker.pas
//  Author          :   김무근 작성
//  Date            :   2012년 7월 10일
//  Description     :   우리선물의 문자열로 된 데이터 레코드인 전문을 자료구조형태로 변형하는 클래스인 IODataSet의
//                      필드정보를 담아 IODataSet의 객체를 리턴하는 함수들의 집합
//**************************************************************************//
unit WRIOMaker;

interface

uses IODataSet, FNIOHandler;

//  조회성 TR   -   딜러의 계좌정보
function Make_BAQ18104_IN(AIOHandler:CFNIOHandler; AIORecord:CFNIORecord):CFNIOHandler;
function Make_BAQ18104_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;

//  조회성 TR   -   주문체결내역 조회
function Make_ATQ39120_IN(AIOHandler:CFNIOHandler; AIORecord:CFNIORecord):CFNIOHandler;
function Make_ATQ39120_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;


//  조회성 TR   -   공통 시세 정보
function Make_FZQ12010_IN(AIOHandler:CFNIOHandler; AIORecord:CFNIORecord):CFNIOHandler;
function Make_FZQ12010_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;


function Make_CKQ52010_IN(AIOHandler:CFNIOHandler; AIORecord:CFNIORecord):CFNIOHandler;
function Make_CKQ52010_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;

//  조회성 TR   -   주문에 대한 응답
function Make_BTO3110X_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;

//  실시간 TR   -   선물 실시간 시세
function Make_SB_FUT_EXEC(ADataSet:CIODataSet) : CIODataSet;

//  실시간 TR   -   주문 / 체결 실시간 통보
function Make_SB_ORDER_EXEC(ADataSet:CIODataSet) : CIODataSet;

//  실시간 TR   -   선물 실시간 시세
function Make_SB_CME_FUT_EXEC(ADataSet:CIODataSet) : CIODataSet;

implementation

//---------------------------------------------------------------------------
function Make_BAQ18104_IN(AIOHandler:CFNIOHandler; AIORecord:CFNIORecord):CFNIOHandler;
var
    f_IOHandler:CFNIOHandler;
    f_DataSet:CFNIODataSet;
begin
    if Assigned(AIOHandler) then f_IOHandler := AIOHandler
    else f_IOHandler := CFNIOHandler.Create;

    f_IOHandler.ClearAll;

    f_DataSet := CFNIODataSet.Create;
    f_DataSet.AddFieldInfo('SYSDIV', 1, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('USERID', 8, 0, FNIOVALUE_TYPE_STRING);

    f_DataSet.RecordList.Add(AIORecord);

    f_IOHandler.m_DataSetList.Add(f_DataSet);

    Result := f_IOHandler;
end;
//---------------------------------------------------------------------------
function Make_BAQ18104_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;
var
    f_IOHandler:CFNIOHandler;
    f_DataSet:CFNIODataSet;
begin
    if Assigned(AIOHandler) then f_IOHandler := AIOHandler
    else f_IOHandler := CFNIOHandler.Create;

    f_IOHandler.ClearAll;

    f_DataSet := CFNIODataSet.Create(1, 0);
    f_DataSet.AddFieldInfo('BRKACCNO'       ,  6, 0, FNIOVALUE_TYPE_STRING);   // 위탁계좌번호
    f_DataSet.AddFieldInfo('BRKACCNM'       , 40, 0, FNIOVALUE_TYPE_STRING);   // 위탁계좌명
    f_DataSet.AddFieldInfo('PSWD'           ,  8, 0, FNIOVALUE_TYPE_STRING);   // 비밀번호
    f_DataSet.AddFieldInfo('BRCHNO'         ,  3, 0, FNIOVALUE_TYPE_STRING);   // 지점번호
    f_DataSet.AddFieldInfo('CMSSRATE'       , 10, 0, FNIOVALUE_TYPE_STRING);   // 수수료율
    f_DataSet.AddFieldInfo('DEALERNO'       ,  3, 0, FNIOVALUE_TYPE_STRING);   // 딜러번호
    f_DataSet.AddFieldInfo('DEALERNM'       , 30, 0, FNIOVALUE_TYPE_STRING);   // 딜러명

    f_IOHandler.m_DataSetList.Add(f_DataSet);

    Result := f_IOHandler;
end;

//---------------------------------------------------------------------------
//  조회성 TR   -   주문체결내역 조회
function Make_ATQ39120_IN(AIOHandler:CFNIOHandler; AIORecord:CFNIORecord):CFNIOHandler;
var
    f_IOHandler:CFNIOHandler;
    f_DataSet:CFNIODataSet;
begin
    if Assigned(AIOHandler) then f_IOHandler := AIOHandler
    else f_IOHandler := CFNIOHandler.Create;

    f_IOHandler.ClearAll;

    f_DataSet := CFNIODataSet.Create(1, 0);
    f_DataSet.AddFieldInfo('TRDDT'      , 8, 0, FNIOVALUE_TYPE_STRING);     //  주문일자
    f_DataSet.AddFieldInfo('BRKGACNTNO' , 6, 0, FNIOVALUE_TYPE_STRING);     //  위탁계좌번호
    f_DataSet.AddFieldInfo('PSWD'       , 8, 0, FNIOVALUE_TYPE_STRING);     //  비밀번호
    f_DataSet.AddFieldInfo('SERIES'     ,32, 0, FNIOVALUE_TYPE_STRING);     //  종목코드
    f_DataSet.AddFieldInfo('TRDDIV'     , 1, 0, FNIOVALUE_TYPE_STRING);     //  매매구분
    f_DataSet.AddFieldInfo('ORDFRM'     , 1, 0, FNIOVALUE_TYPE_STRING);     //  주문형태
    f_DataSet.AddFieldInfo('ORDSTTS'    , 1, 0, FNIOVALUE_TYPE_STRING);     //  주문상태
    f_DataSet.AddFieldInfo('CMDTCD'     , 2, 0, FNIOVALUE_TYPE_STRING);     //  거래대상코드; 00 : 전체
    f_DataSet.AddFieldInfo('GODDIV'     , 1, 0, FNIOVALUE_TYPE_STRING);     //  상품구분; 0 : 전체; 1 : 선물; 2 : 옵션; 3 : CALL옵션; 4 : PUT 옵션; 5 : 정형복합
    f_DataSet.AddFieldInfo('MEDDIV'     , 1, 0, FNIOVALUE_TYPE_STRING);     //  매체구분; SPACE:전체; B:BOS; E:엑셀주문; F:FRONT; G:영문HTS; H:HTS; W:WTS; Z:FIX; X:Xpert; T:TS; R:외부고객시스템; C:클라이언트API; S:서버API
    f_DataSet.AddFieldInfo('QRYCOND'    , 1, 0, FNIOVALUE_TYPE_STRING);     //  조회조건 1:단말 2:계좌 3:관리 4:팀
    f_DataSet.AddFieldInfo('ORDNO'      , 7, 0, FNIOVALUE_TYPE_STRING);     //  주문번호
    f_DataSet.AddFieldInfo('PLRACNTDIV' , 1, 0, FNIOVALUE_TYPE_STRING);     //  복수계좌구분 Y : 복수계좌 보기
    f_DataSet.AddFieldInfo('DEALERNO'   , 3, 0, FNIOVALUE_TYPE_STRING);     //  펀드번호 000: 전체

    f_DataSet.RecordList.Add(AIORecord);

    f_IOHandler.m_DataSetList.Add(f_DataSet);

    Result := f_IOHandler;
end;
//---------------------------------------------------------------------------
//  조회성 TR   -   주문체결내역 조회
function Make_ATQ39120_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;
var
    f_IOHandler:CFNIOHandler;
    f_DataSet1:CFNIODataSet;
    f_DataSet2:CFNIODataSet;
begin
    if Assigned(AIOHandler) then f_IOHandler := AIOHandler
    else f_IOHandler := CFNIOHandler.Create;

    f_IOHandler.ClearAll;

    f_DataSet1 := CFNIODataSet.Create(1, 0);
    f_DataSet1.AddFieldInfo('CNT'           ,  3, 0, FNIOVALUE_TYPE_INTEGER);   //  건수
    f_DataSet1.AddFieldInfo('BRKGACNTNO'    ,  6, 0, FNIOVALUE_TYPE_STRING);    //  위탁계좌번호 KEY
    f_DataSet1.AddFieldInfo('ORDNO'         ,  7, 0, FNIOVALUE_TYPE_STRING);    //  주문번호 KEY
    f_IOHandler.m_DataSetList.Add(f_DataSet1);

    f_DataSet2 := CFNIODataSet.Create(1, 0);
    f_DataSet2.AddFieldInfo('BRKGACNTNO'    ,  6, 0, FNIOVALUE_TYPE_STRING);    //  위탁계좌번호
    f_DataSet2.AddFieldInfo('BRKGACNTNM'    , 40, 0, FNIOVALUE_TYPE_STRING);    //  계좌명
    f_DataSet2.AddFieldInfo('BRCHNO'        ,  3, 0, FNIOVALUE_TYPE_STRING);    //  지점번호
    f_DataSet2.AddFieldInfo('ORDNO'         ,  7, 0, FNIOVALUE_TYPE_STRING);    //  주문번호
    f_DataSet2.AddFieldInfo('ORGNORDNO'     ,  7, 0, FNIOVALUE_TYPE_STRING);    //  원주문번호
    f_DataSet2.AddFieldInfo('PAORDNO'       ,  7, 0, FNIOVALUE_TYPE_STRING);    //  모주문번호
    f_DataSet2.AddFieldInfo('COMBODIV'      ,  1, 0, FNIOVALUE_TYPE_STRING);    //  정형복합구분
    f_DataSet2.AddFieldInfo('CMDTCD'        ,  2, 0, FNIOVALUE_TYPE_STRING);    //  거래대상코드
    f_DataSet2.AddFieldInfo('INSTGRPCD'     ,  3, 0, FNIOVALUE_TYPE_STRING);    //  파생상품구분코드
    f_DataSet2.AddFieldInfo('SERIES'        , 32, 0, FNIOVALUE_TYPE_STRING);    //  종목코드 (거래소)
    f_DataSet2.AddFieldInfo('OURSERIES'     , 32, 0, FNIOVALUE_TYPE_STRING);    //  종목코드 (당사)
    f_DataSet2.AddFieldInfo('ENOURSERIES'   , 32, 0, FNIOVALUE_TYPE_STRING);    //  종목코드 (영문)
    f_DataSet2.AddFieldInfo('KORSERIESNM'   , 80, 0, FNIOVALUE_TYPE_STRING);    //  한글종목명
    f_DataSet2.AddFieldInfo('ENGSERIESNM'   , 80, 0, FNIOVALUE_TYPE_STRING);    //  영문종목명

    f_DataSet2.AddFieldInfo('ORDDIV'        ,  1, 0, FNIOVALUE_TYPE_STRING);    //  주문구분
    f_DataSet2.AddFieldInfo('TRDDIV'        ,  1, 0, FNIOVALUE_TYPE_STRING);    //  매매구분
    f_DataSet2.AddFieldInfo('MEDDIV'        ,  1, 0, FNIOVALUE_TYPE_STRING);    //  매체구분

    f_DataSet2.AddFieldInfo('ORDQTY'        ,  8, 0, FNIOVALUE_TYPE_INTEGER);   //  주문수량
    f_DataSet2.AddFieldInfo('ORDPX'         , 12, 2, FNIOVALUE_TYPE_DOUBLE);    //  주문가격

    f_DataSet2.AddFieldInfo('EXECQTY'       ,  8, 0, FNIOVALUE_TYPE_INTEGER);   //  체결수량
    f_DataSet2.AddFieldInfo('EXECPX'        , 12, 2, FNIOVALUE_TYPE_DOUBLE);    //  체결가격
    f_DataSet2.AddFieldInfo('EXECAMT'       , 15, 2, FNIOVALUE_TYPE_DOUBLE);    //  체결금액
    f_DataSet2.AddFieldInfo('RMTQTY'        ,  8, 0, FNIOVALUE_TYPE_INTEGER);   //  잔량
    f_DataSet2.AddFieldInfo('CRRTQTY'       ,  8, 0, FNIOVALUE_TYPE_INTEGER);   //  정정수량
    f_DataSet2.AddFieldInfo('CXLQTY'        ,  8, 0, FNIOVALUE_TYPE_INTEGER);   //  취소수량

	f_DataSet2.AddFieldInfo('ORDTYP'        ,  1, 0, FNIOVALUE_TYPE_STRING);    //   주문유형
    f_DataSet2.AddFieldInfo('EXECQTYDIV'    ,  1, 0, FNIOVALUE_TYPE_STRING);    //   체결수량구분
    f_DataSet2.AddFieldInfo('ORDFRM'        ,  1, 0, FNIOVALUE_TYPE_STRING);    //   주문형태
    f_DataSet2.AddFieldInfo('ORDSTTS'       ,  1, 0, FNIOVALUE_TYPE_STRING);    //   처리상태
	f_DataSet2.AddFieldInfo('ORDSTTSNM'     , 20, 0, FNIOVALUE_TYPE_STRING);    //   처리상태명
    f_DataSet2.AddFieldInfo('EXACPTTIME'    ,  8, 0, FNIOVALUE_TYPE_STRING);    //   거래소접수시각
    f_DataSet2.AddFieldInfo('ORDINPUTIP'    , 15, 0, FNIOVALUE_TYPE_STRING);    //   주문전송IP
    f_DataSet2.AddFieldInfo('REJCD'         , 10, 0, FNIOVALUE_TYPE_STRING);    //   거부코드
    f_DataSet2.AddFieldInfo('STGNM'         , 30, 0, FNIOVALUE_TYPE_STRING);    //   전략명
	f_DataSet2.AddFieldInfo('DEALERNO'		,  3, 0, FNIOVALUE_TYPE_STRING);    //   딜러번호
	f_DataSet2.AddFieldInfo('USERNM'        , 20, 0, FNIOVALUE_TYPE_STRING);    //   사용자명

    f_IOHandler.m_DataSetList.Add(f_DataSet2);

    Result := f_IOHandler;
end;

//---------------------------------------------------------------------------
//  조회성 TR   -   공통 시세 정보
function Make_FZQ12010_IN(AIOHandler:CFNIOHandler; AIORecord:CFNIORecord):CFNIOHandler;
var
    f_IOHandler:CFNIOHandler;
    f_DataSet:CFNIODataSet;
begin
    if Assigned(AIOHandler) then f_IOHandler := AIOHandler
    else f_IOHandler := CFNIOHandler.Create;

    f_IOHandler.ClearAll;

    f_DataSet := CFNIODataSet.Create;
    f_DataSet.AddFieldInfo('SYMBOL', 32, 0, FNIOVALUE_TYPE_STRING);

    f_DataSet.RecordList.Add(AIORecord);

    f_IOHandler.m_DataSetList.Add(f_DataSet);

    Result := f_IOHandler;
end;
//---------------------------------------------------------------------------
//  조회성 TR   -   공통 시세 정보
function Make_FZQ12010_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;
var
    f_IOHandler:CFNIOHandler;
    f_DataSet:CFNIODataSet;
begin
    if Assigned(AIOHandler) then f_IOHandler := AIOHandler
    else f_IOHandler := CFNIOHandler.Create;

    f_IOHandler.ClearAll;

    f_DataSet := CFNIODataSet.Create(1, 0);
    f_DataSet.AddFieldInfo('CHANGE_SIGN'            ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('SYMBOL_EX'              , 32, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('SYMBOL'                 , 32, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('SYMBOL_ENG'             , 32, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('NAME'                   , 30, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('NAME_ENG'               , 30, 0, FNIOVALUE_TYPE_STRING);

    f_DataSet.AddFieldInfo('CLOSE_PRICE'            , 16, 2, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('STAND_PRICE'            , 16, 2, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('CHANGE'                 , 16, 2, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('CHANGERATE'             , 16, 2, FNIOVALUE_TYPE_DOUBLE);

    f_DataSet.AddFieldInfo('BEST_OFFER_PRICE'       , 16, 2, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('BEST_BID_PRICE'         , 16, 2, FNIOVALUE_TYPE_DOUBLE);

    f_DataSet.AddFieldInfo('TOTAL_VOLUME'           , 10, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('PREV_TOTAL_VOLUME'      , 10, 0, FNIOVALUE_TYPE_DOUBLE);

    f_DataSet.AddFieldInfo('TOTAL_VALUE'            , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('PREV_TOTAL_VALUE'       , 16, 0, FNIOVALUE_TYPE_DOUBLE);

    f_DataSet.AddFieldInfo('OPEN_VOLUME'            , 10, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('OPEN_VOLUME_SIGN'       ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('OPEN_VOLUME_CHANGE'     , 10, 0, FNIOVALUE_TYPE_DOUBLE);

    f_DataSet.AddFieldInfo('NOPEN_VOLUME'           , 10, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('NOPEN_VOLUME_SIGN'      ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('NOPEN_VOLUME_CHANGE'    , 10, 0, FNIOVALUE_TYPE_DOUBLE);


    f_DataSet.AddFieldInfo('VHIGH_PRICE'            , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('VHIGH_DATE'             ,  8, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('VLOW_PRICE'             , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('VLOW_DATE'              ,  8, 0, FNIOVALUE_TYPE_STRING);

    f_DataSet.AddFieldInfo('MAX_PRICE'              , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('MIN_PRICE'              , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('OPEN_PRICE'             , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('HIGH_PRICE'             , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('LOW_PRICE'              , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('PREV_CLOSE'             , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('DATE'                   ,  8, 0, FNIOVALUE_TYPE_STRING);

    f_IOHandler.m_DataSetList.Add(f_DataSet);

    Result := f_IOHandler;
end;

//---------------------------------------------------------------------------
//  조회성 TR   -   공통 시세 정보
function Make_CKQ52010_IN(AIOHandler:CFNIOHandler; AIORecord:CFNIORecord):CFNIOHandler;
var
    f_IOHandler:CFNIOHandler;
    f_DataSet:CFNIODataSet;
begin
    if Assigned(AIOHandler) then f_IOHandler := AIOHandler
    else f_IOHandler := CFNIOHandler.Create;

    f_IOHandler.ClearAll;

    f_DataSet := CFNIODataSet.Create;
    f_DataSet.AddFieldInfo('SYMBOL', 32, 0, FNIOVALUE_TYPE_STRING);

    f_DataSet.RecordList.Add(AIORecord);

    f_IOHandler.m_DataSetList.Add(f_DataSet);

    Result := f_IOHandler;
end;
//---------------------------------------------------------------------------
//  조회성 TR   -   공통 시세 정보
function Make_CKQ52010_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;
var
    f_IOHandler:CFNIOHandler;
    f_DataSet:CFNIODataSet;
begin
    if Assigned(AIOHandler) then f_IOHandler := AIOHandler
    else f_IOHandler := CFNIOHandler.Create;

    f_IOHandler.ClearAll;

    f_DataSet := CFNIODataSet.Create(1, 0);
    f_DataSet.AddFieldInfo('CHANGE_SIGN'            ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('SYMBOL_EX'              , 32, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('SYMBOL'                 , 32, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('SYMBOL_ENG'             , 32, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('NAME'                   , 30, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('NAME_ENG'               , 30, 0, FNIOVALUE_TYPE_STRING);

    f_DataSet.AddFieldInfo('CLOSE_PRICE'            , 16, 2, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('STAND_PRICE'            , 16, 2, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('CHANGE'                 , 16, 2, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('CHANGERATE'             , 16, 2, FNIOVALUE_TYPE_DOUBLE);

    f_DataSet.AddFieldInfo('BEST_OFFER_PRICE'       , 16, 2, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('BEST_BID_PRICE'         , 16, 2, FNIOVALUE_TYPE_DOUBLE);

    f_DataSet.AddFieldInfo('TOTAL_VOLUME'           , 10, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('PREV_TOTAL_VOLUME'      , 10, 0, FNIOVALUE_TYPE_DOUBLE);

    f_DataSet.AddFieldInfo('TOTAL_VALUE'            , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('PREV_TOTAL_VALUE'       , 16, 0, FNIOVALUE_TYPE_DOUBLE);

    f_DataSet.AddFieldInfo('OPEN_VOLUME'            , 10, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('OPEN_VOLUME_SIGN'       ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('OPEN_VOLUME_CHANGE'     , 10, 0, FNIOVALUE_TYPE_DOUBLE);

    f_DataSet.AddFieldInfo('VHIGH_PRICE'            , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('VHIGH_DATE'             ,  8, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('VLOW_PRICE'             , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('VLOW_DATE'              ,  8, 0, FNIOVALUE_TYPE_STRING);

    f_DataSet.AddFieldInfo('MAX_PRICE'              , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('MIN_PRICE'              , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('OPEN_PRICE'             , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('HIGH_PRICE'             , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('LOW_PRICE'              , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('PREV_CLOSE'             , 16, 0, FNIOVALUE_TYPE_DOUBLE);
    f_DataSet.AddFieldInfo('DATE'                   ,  8, 0, FNIOVALUE_TYPE_STRING);

    f_IOHandler.m_DataSetList.Add(f_DataSet);

    Result := f_IOHandler;
end;
//---------------------------------------------------------------------------
//  조회성 TR   -   주문에 대한 응답
function Make_BTO3110X_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;
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
    f_DataSet.AddFieldInfo('ORDER_NO'               ,  7, 0, FNIOVALUE_TYPE_STRING);    //  주문번호
    f_DataSet.AddFieldInfo('CLIENT_DEF'             ,  7, 0, FNIOVALUE_TYPE_STRING);    //  고객지정번호

    f_IOHandler.m_DataSetList.Add(f_DataSet);

    Result := f_IOHandler;
end;
//---------------------------------------------------------------------------
//  실시간 TR - 선물/스프레드 체결 시세
function Make_SB_FUT_EXEC(ADataSet:CIODataSet) : CIODataSet;
var
    f_DataSet:CIODataSet;
begin
    if Assigned(ADataSet) then f_DataSet := ADataSet
    else f_DataSet := CIODataSet.Create;

    f_DataSet.ClearAll;
    f_DataSet.AddFieldInfo('DGUBUN'             ,  4,  0, IOVALUE_TYPE_STRING);     //  TR 단축코드         //  선물:F1C0     스프레드:F1C0
    f_DataSet.AddFieldInfo('SYMBOL'             , 32,  0, IOVALUE_TYPE_STRING);     //  종목코드
    f_DataSet.AddFieldInfo('TIME'               ,  8,  0, IOVALUE_TYPE_STRING);     //  처리시간
    f_DataSet.AddFieldInfo('CLOSE_PRICE'        , 10,  2, IOVALUE_TYPE_DOUBLE);     //  현재가
    f_DataSet.AddFieldInfo('NEARMONAGREEPX'     ,  9,  0, IOVALUE_TYPE_STRING);     //  근월물 의제약정가격
    f_DataSet.AddFieldInfo('FARMONAGREEPX'      ,  9,  0, IOVALUE_TYPE_STRING);     //  원월물의제약정가격

    f_DataSet.AddFieldInfo('OPEN_PRICE'         , 10,  2, IOVALUE_TYPE_DOUBLE);     //  시가
    f_DataSet.AddFieldInfo('HIGH_PRICE'         , 10,  2, IOVALUE_TYPE_DOUBLE);     //  고가
    f_DataSet.AddFieldInfo('LOW_PRICE'          , 10,  2, IOVALUE_TYPE_DOUBLE);     //  저가
    f_DataSet.AddFieldInfo('TOTAL_VOLUME'       ,  7,  0, IOVALUE_TYPE_DOUBLE);     //  누적체결수량
    f_DataSet.AddFieldInfo('TOTAL_VALUE'        , 12,  2, IOVALUE_TYPE_DOUBLE);     //  누적거래대금        //  단위:천원
    f_DataSet.AddFieldInfo('NEARMONEXECQTY'     ,  7,  0, IOVALUE_TYPE_STRING);     //  근월물체결수량
    f_DataSet.AddFieldInfo('NEARMONEXECAMT'     , 12,  2, IOVALUE_TYPE_STRING);     //  근원물체결대금      //  단위:천원
    f_DataSet.AddFieldInfo('FARMONEXECQTY'      ,  7,  0, IOVALUE_TYPE_STRING);     //  원월물체결수량
    f_DataSet.AddFieldInfo('FARMONEXECAMT'      , 12,  2, IOVALUE_TYPE_STRING);     //  원원물체결대금      //  단위:천원
    f_DataSet.AddFieldInfo('BLOCKTRADEQTY'      ,  7,  0, IOVALUE_TYPE_STRING);     //  협의대량체결수량
    f_DataSet.AddFieldInfo('BLOCKTRADEAMT'      , 12,  2, IOVALUE_TYPE_STRING);     //  협의대량체결대금    //  단위:천원
    f_DataSet.AddFieldInfo('SIGN'               ,  1,  0, IOVALUE_TYPE_STRING);     //  전일대비구분
    f_DataSet.AddFieldInfo('CHANGE'             ,  9,  2, IOVALUE_TYPE_DOUBLE);     //  전일대비
    f_DataSet.AddFieldInfo('VOLUME'             ,  6,  0, IOVALUE_TYPE_DOUBLE);     //  건별체결수량
    f_DataSet.AddFieldInfo('BEST_OFFER_PRICE'   , 10,  2, IOVALUE_TYPE_DOUBLE);     //  매도우선호가
    f_DataSet.AddFieldInfo('BEST_BID_PRICE'     , 10,  2, IOVALUE_TYPE_DOUBLE);     //  매수우선호가
    f_DataSet.AddFieldInfo('CHANGERATE'         ,  6,  2, IOVALUE_TYPE_DOUBLE);     //  등락율

    Result := f_DataSet;
end;

//---------------------------------------------------------------------------
//  실시간 TR - 선물/스프레드 체결 시세
function Make_SB_CME_FUT_EXEC(ADataSet:CIODataSet) : CIODataSet;
var
    f_DataSet:CIODataSet;
begin
    if Assigned(ADataSet) then f_DataSet := ADataSet
    else f_DataSet := CIODataSet.Create;

    f_DataSet.ClearAll;
    f_DataSet.AddFieldInfo('DGUBUN'             ,  4,  0, IOVALUE_TYPE_STRING);     //  TR 단축코드         //  선물: G1C0
    f_DataSet.AddFieldInfo('SYMBOL'             , 32,  0, IOVALUE_TYPE_STRING);     //  종목코드
    f_DataSet.AddFieldInfo('TIME'               ,  8,  0, IOVALUE_TYPE_STRING);     //  처리시간
    f_DataSet.AddFieldInfo('CLOSE_PRICE'        , 10,  2, IOVALUE_TYPE_DOUBLE);     //  현재가
    f_DataSet.AddFieldInfo('OPEN_PRICE'         , 10,  2, IOVALUE_TYPE_DOUBLE);     //  시가
    f_DataSet.AddFieldInfo('HIGH_PRICE'         , 10,  2, IOVALUE_TYPE_DOUBLE);     //  고가
    f_DataSet.AddFieldInfo('LOW_PRICE'          , 10,  2, IOVALUE_TYPE_DOUBLE);     //  저가
    f_DataSet.AddFieldInfo('TOTAL_VOLUME'       ,  7,  0, IOVALUE_TYPE_DOUBLE);     //  누적체결수량
    f_DataSet.AddFieldInfo('TOTAL_VALUE'        , 12,  2, IOVALUE_TYPE_DOUBLE);     //  누적거래대금        //  단위:천원
    f_DataSet.AddFieldInfo('SIGN'               ,  1,  0, IOVALUE_TYPE_STRING);     //  전일대비구분
    f_DataSet.AddFieldInfo('CHANGE'             ,  9,  2, IOVALUE_TYPE_DOUBLE);     //  전일대비
    f_DataSet.AddFieldInfo('VOLUME'             ,  6,  0, IOVALUE_TYPE_DOUBLE);     //  건별체결수량
    f_DataSet.AddFieldInfo('BEST_OFFER_PRICE'   , 10,  2, IOVALUE_TYPE_DOUBLE);     //  매도우선호가
    f_DataSet.AddFieldInfo('BEST_BID_PRICE'     , 10,  2, IOVALUE_TYPE_DOUBLE);     //  매수우선호가
    f_DataSet.AddFieldInfo('CHANGERATE'         ,  6,  2, IOVALUE_TYPE_DOUBLE);     //  등락율
    f_DataSet.AddFieldInfo('OPEN_VOLUME'        , 10,  0, IOVALUE_TYPE_DOUBLE);     //  미결제 약정

    Result := f_DataSet;
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

end.

