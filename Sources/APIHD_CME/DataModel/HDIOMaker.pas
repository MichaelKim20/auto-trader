// **************************************************************************//
// FileName        :   WROIOMaker.pas
// Author          :   김무근 작성
// Date            :   2012년 7월 10일
// Description     :   우리선물의 문자열로 된 데이터 레코드인 전문을 자료구조형태로 변형하는 클래스인 IODataSet의
// 필드정보를 담아 IODataSet의 객체를 리턴하는 함수들의 집합
// **************************************************************************//
unit HDIOMaker;

interface

uses IODataSet, FNIOHandler;

// 조회성 TR   -   주문
function Make_AO0401_IN(AIOHandler: CFNIOHandler; AIORecord: CFNIORecord): CFNIOHandler;
function Make_AO0402_IN(AIOHandler: CFNIOHandler; AIORecord: CFNIORecord): CFNIOHandler;
function Make_AO0403_IN(AIOHandler: CFNIOHandler; AIORecord: CFNIORecord): CFNIOHandler;

function Make_ACCOUNT_OUT(AIOHandler: CFNIOHandler): CFNIOHandler;

implementation

function Make_AO0401_IN(AIOHandler: CFNIOHandler; AIORecord: CFNIORecord): CFNIOHandler;
var
  f_IOHandler: CFNIOHandler;
  f_DataSet: CFNIODataSet;
begin
  if Assigned(AIOHandler) then
    f_IOHandler := AIOHandler
  else
    f_IOHandler := CFNIOHandler.Create;

  f_IOHandler.ClearAll;

  f_DataSet := CFNIODataSet.Create;
  f_DataSet.AddFieldInfo('계좌번호', 6, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('비밀번호', 8, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('종목코드', 32, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('매매구분', 1, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('주문유형', 1, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('체결조건', 1, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('주문가격', 15, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('주문수량', 10, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('전략구분', 1, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('지정가격', 15, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('IOC최소체결수량', 10, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('옵션행사여부', 1, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('주문유효일자', 8, 0, FNIOVALUE_TYPE_STRING);

  f_DataSet.RecordList.Add(AIORecord);

  f_IOHandler.m_DataSetList.Add(f_DataSet);

  Result := f_IOHandler;
end;

function Make_AO0402_IN(AIOHandler: CFNIOHandler; AIORecord: CFNIORecord): CFNIOHandler;
var
  f_IOHandler: CFNIOHandler;
  f_DataSet: CFNIODataSet;
begin
  if Assigned(AIOHandler) then
    f_IOHandler := AIOHandler
  else
    f_IOHandler := CFNIOHandler.Create;

  f_IOHandler.ClearAll;

  f_DataSet := CFNIODataSet.Create;
  f_DataSet.AddFieldInfo('계좌번호', 6, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('비밀번호', 8, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('종목코드', 32, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('주문유형', 1, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('체결조건', 1, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('주문가격', 15, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('주문수량', 10, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('주문번호', 10, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('전략구분', 1, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('지정가격', 15, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('IOC최소체결수량', 10, 0, FNIOVALUE_TYPE_STRING);

  f_DataSet.RecordList.Add(AIORecord);

  f_IOHandler.m_DataSetList.Add(f_DataSet);

  Result := f_IOHandler;
end;

function Make_AO0403_IN(AIOHandler: CFNIOHandler; AIORecord: CFNIORecord): CFNIOHandler;
var
  f_IOHandler: CFNIOHandler;
  f_DataSet: CFNIODataSet;
begin
  if Assigned(AIOHandler) then
    f_IOHandler := AIOHandler
  else
    f_IOHandler := CFNIOHandler.Create;

  f_IOHandler.ClearAll;

  f_DataSet := CFNIODataSet.Create;
  f_DataSet.AddFieldInfo('계좌번호', 6, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('비밀번호', 8, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('종목코드', 32, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('주문유형', 1, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('체결조건', 1, 0, FNIOVALUE_TYPE_STRING);

  f_DataSet.AddFieldInfo('주문가격', 15, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('주문수량', 10, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('주문번호', 10, 0, FNIOVALUE_TYPE_STRING);

  f_DataSet.AddFieldInfo('전략구분', 1, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('지정가격', 15, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('IOC최소체결수량', 10, 0, FNIOVALUE_TYPE_STRING);

  f_DataSet.RecordList.Add(AIORecord);

  f_IOHandler.m_DataSetList.Add(f_DataSet);

  Result := f_IOHandler;
end;

function Make_ACCOUNT_OUT(AIOHandler: CFNIOHandler): CFNIOHandler;
var
  f_IOHandler: CFNIOHandler;
  f_DataSet: CFNIODataSet;
begin
  if Assigned(AIOHandler) then
    f_IOHandler := AIOHandler
  else
    f_IOHandler := CFNIOHandler.Create;

  f_IOHandler.ClearAll;

  f_DataSet := CFNIODataSet.Create(0, 5);
  f_DataSet.AddFieldInfo('ACCOUNT_NO', 11, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('ACCOUNT_NAME', 30, 0, FNIOVALUE_TYPE_STRING);
  f_DataSet.AddFieldInfo('ACCOUNT_GB', 1, 0, FNIOVALUE_TYPE_STRING);

  f_IOHandler.m_DataSetList.Add(f_DataSet);

  Result := f_IOHandler;
end;

end.
