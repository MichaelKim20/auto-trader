//**************************************************************************//
//  FileName        :   HNIOMaker.pas
//  Author          :   김무근 작성
//  Date            :   2012년 7월 10일
//  Description     :   하나대투의 문자열로 된 데이터 레코드인 전문을 자료구조형태로 변형하는 클래스인 IODataSet의
//                      필드정보를 담아 IODataSet의 객체를 리턴하는 함수들의 집합
//**************************************************************************//
unit HNIOMaker;

interface

uses IODataSet, FNIOHandler;

//  조회성 TR   -   공통 시세 정보
function Make_ACCOUNT_IN(AIOHandler:CFNIOHandler; AHeadRecord:CFNIORecord; ARecord:CFNIORecord):CFNIOHandler;
function Make_ACCOUNT_IN2(AIOHandler:CFNIOHandler; AHeadRecord:CFNIORecord; ARecord:CFNIORecord):CFNIOHandler;

function Make_ACCOUNT_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;

implementation

//---------------------------------------------------------------------------
//  조회성 TR   -   해외선물 시세 정보
function Make_ACCOUNT_IN(AIOHandler:CFNIOHandler; AHeadRecord:CFNIORecord; ARecord:CFNIORecord):CFNIOHandler;
var
    f_IOHandler:CFNIOHandler;
    f_HeadDataSet:CFNIODataSet;
    f_DataSet:CFNIODataSet;
begin
    if Assigned(AIOHandler) then f_IOHandler := AIOHandler
    else f_IOHandler := CFNIOHandler.Create;

    f_IOHandler.ClearAll;

    f_HeadDataSet := CFNIODataSet.Create;
    f_HeadDataSet.AddFieldInfo('KEY'        ,  1, 0, FNIOVALUE_TYPE_BYTE);
    f_HeadDataSet.AddFieldInfo('STAT'       ,  1, 0, FNIOVALUE_TYPE_BYTE);
    f_HeadDataSet.AddFieldInfo('BIZH'       ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.AddFieldInfo('BIZK'       ,  6, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.AddFieldInfo('TRX_NAME'   ,  8, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.AddFieldInfo('SVC_NAME'   , 10, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.AddFieldInfo('JOB_CODE'   ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.AddFieldInfo('MAX_ROW'    ,  3, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.AddFieldInfo('NEXT_KEY'   , 50, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.AddFieldInfo('CONTF'      ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.RecordList.Add(AHeadRecord);
    f_IOHandler.m_DataSetList.Add(f_HeadDataSet);

    f_DataSet := CFNIODataSet.Create;
    f_DataSet.AddFieldInfo('FUNC'       ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.AddFieldInfo('USID'       , 12, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.RecordList.Add(ARecord);
    f_IOHandler.m_DataSetList.Add(f_DataSet);

    Result := f_IOHandler;
end;
//---------------------------------------------------------------------------
//  조회성 TR   -   해외선물 시세 정보
function Make_ACCOUNT_IN2(AIOHandler:CFNIOHandler; AHeadRecord:CFNIORecord; ARecord:CFNIORecord):CFNIOHandler;
var
    f_IOHandler:CFNIOHandler;
    f_HeadDataSet:CFNIODataSet;
    f_DataSet:CFNIODataSet;
begin
    if Assigned(AIOHandler) then f_IOHandler := AIOHandler
    else f_IOHandler := CFNIOHandler.Create;

    f_IOHandler.ClearAll;

    f_HeadDataSet := CFNIODataSet.Create;
    f_HeadDataSet.AddFieldInfo('KEY'        ,  1, 0, FNIOVALUE_TYPE_BYTE);
    f_HeadDataSet.AddFieldInfo('STAT'       ,  1, 0, FNIOVALUE_TYPE_BYTE);
    f_HeadDataSet.AddFieldInfo('BIZH'       ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.AddFieldInfo('BIZK'       ,  6, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.AddFieldInfo('TRX_NAME'   ,  8, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.AddFieldInfo('SVC_NAME'   , 10, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.AddFieldInfo('JOB_CODE'   ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.AddFieldInfo('MAX_ROW'    ,  3, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.AddFieldInfo('NEXT_KEY'   , 50, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.AddFieldInfo('CONTF'      ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_HeadDataSet.RecordList.Add(AHeadRecord);
    f_IOHandler.m_DataSetList.Add(f_HeadDataSet);

    f_DataSet := CFNIODataSet.Create;
    f_DataSet.AddFieldInfo('USID'       , 9, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet.RecordList.Add(ARecord);
    f_IOHandler.m_DataSetList.Add(f_DataSet);

    Result := f_IOHandler;
end;


//---------------------------------------------------------------------------
//  조회성 TR   -   해외선물 시세 정보
function Make_ACCOUNT_OUT(AIOHandler:CFNIOHandler):CFNIOHandler;
var
    f_IOHandler:CFNIOHandler;
    f_DataSet1:CFNIODataSet;
    f_DataSet2:CFNIODataSet;
begin
    if Assigned(AIOHandler) then f_IOHandler := AIOHandler
    else f_IOHandler := CFNIOHandler.Create;

    f_IOHandler.ClearAll;

    f_DataSet1 := CFNIODataSet.Create;
    f_DataSet1.AddFieldInfo('FUNC'              ,  1, 0, FNIOVALUE_TYPE_BYTE);
    f_DataSet1.AddFieldInfo('USID'              , 12, 0, FNIOVALUE_TYPE_BYTE);
    f_DataSet1.AddFieldInfo('ERROR_CODE'        ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet1.AddFieldInfo('ERROR_TEXT'        , 80, 0, FNIOVALUE_TYPE_STRING);
    f_IOHandler.m_DataSetList.Add(f_DataSet1);

    f_DataSet2 := CFNIODataSet.Create(0, 4);
    f_DataSet2.AddFieldInfo('ACCOUNT_NO'        , 10, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet2.AddFieldInfo('ACCOUNT_NAME'      , 20, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet2.AddFieldInfo('ACCOUNT_SEQ'       ,  2, 0, FNIOVALUE_TYPE_STRING);
    f_DataSet2.AddFieldInfo('ACCOUNT_PWCH'      ,  1, 0, FNIOVALUE_TYPE_STRING);
    f_IOHandler.m_DataSetList.Add(f_DataSet2);

    Result := f_IOHandler;
end;
end.

