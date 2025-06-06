// **************************************************************************//
// FileName        :   CommonTRMaker.pas
// Author          :   김무근 작성
// Date            :   2012년 7월 10일
// Description     :   모든 증권사에 공통으로 사용할 수 있도록 화면처리에 필요한 TR을 새롭게 정리하였다.
// 이 TR들의 필드정보를 담아 CFNDataPackage 객체를 리턴하는 함수들의 집합
// 이 TR에 해당하는 내용은 각 증권사의 통신을 담당하는 클래스에서 분석되고, 각각의 API를
// 이용하여 구현한다.
// **************************************************************************//
unit CommonTRMaker;

interface

uses
  FNDataSet;

function Make_SC_BASIC_TR_0010_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_BASIC_TR_0010_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;

function Make_SC_BASIC_TR_0020_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_BASIC_TR_0020_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;

function Make_SC_BASIC_TR_0030_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_BASIC_TR_0030_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;

function Make_SC_QUOTE_TR_0010_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_QUOTE_TR_0010_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;

function Make_SC_QUOTE_TR_0110_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_QUOTE_TR_0110_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;

function Make_SC_CODE_TR_0010_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_CODE_TR_0010_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;

function Make_SC_ACCOUNT_TR_0010_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_ACCOUNT_TR_0010_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;

function Make_SC_ORDER_TR_0010_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_ORDER_TR_0010_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;

function Make_SC_USER_TR_0010_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_USER_TR_0010_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;

function Make_SC_USER_TR_0110_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_USER_TR_0110_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;

function Make_SC_USER_TR_0120_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_USER_TR_0120_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;

// 선물시세를 조회한다.
function Make_SC_QUOTE_TR_0210_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_QUOTE_TR_0210_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;

// 선물의 주문을 전달한다.
function Make_SC_ORDER_TR_0210_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_ORDER_TR_0210_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;

function Make_SC_TRADE_TR_0100_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_TRADE_TR_0110_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_TRADE_TR_0200_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_TRADE_TR_0300_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_TRADE_TR_0310_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_TRADE_TR_0400_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
function Make_SC_TRADE_TR_0500_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;

implementation

// ---------------------------------------------------------------------------
function Make_SC_USER_TR_0010_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_USER');
  f_DataPackage.SetTRCode('TR_0010');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('USER_ID', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('PASSWORD', 120, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('PGM_CODE', 2, COLTYPE_STRING);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_USER_TR_0010_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_USER');
  f_DataPackage.SetTRCode('TR_0010');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('SESSION_KEY', 64, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('RESULT', 32, COLTYPE_INTEGER);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_USER_TR_0110_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_USER');
  f_DataPackage.SetTRCode('TR_0110');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('USER_ID', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('PASSWORD', 120, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('PGM_CODE', 2, COLTYPE_STRING);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_USER_TR_0110_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_USER');
  f_DataPackage.SetTRCode('TR_0110');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('SESSION_KEY', 64, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('RESULT', 32, COLTYPE_INTEGER);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_USER_TR_0120_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_USER');
  f_DataPackage.SetTRCode('TR_0120');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('USER_ID', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('PASSWORD', 120, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('PGM_CODE', 2, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SESSION_KEY', 64, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('TRADESESSION_KEY', 64, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('LEADER_SESSION', 64, COLTYPE_STRING);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_USER_TR_0120_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_USER');
  f_DataPackage.SetTRCode('TR_0120');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('SESSION_KEY', 64, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('RESULT', 32, COLTYPE_INTEGER);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_BASIC_TR_0010_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_BASIC');
  f_DataPackage.SetTRCode('TR_0010');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('NONE', 12, COLTYPE_STRING);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_BASIC_TR_0010_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_BASIC');
  f_DataPackage.SetTRCode('TR_0010');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;

  f_DataSet.AddFieldInfo('DATE', 12, COLTYPE_STRING);

  f_DataSet.AddFieldInfo('COUNTRY_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('GROUP_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('MARKET_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('SYMBOL', 32, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('HOLYDAY', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('HOURCOUNT', 32, COLTYPE_INTEGER);

  f_DataSet.AddFieldInfo('OPEN1', 4, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('CLOSE1', 4, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SETTLEMENT1', 4, COLTYPE_STRING);

  f_DataSet.AddFieldInfo('OPEN2', 4, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('CLOSE2', 4, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SETTLEMENT2', 4, COLTYPE_STRING);

  f_DataSet.AddFieldInfo('OPEN3', 4, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('CLOSE3', 4, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SETTLEMENT3', 4, COLTYPE_STRING);

  f_DataSet.AddFieldInfo('OPEN4', 4, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('CLOSE4', 4, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SETTLEMENT4', 4, COLTYPE_STRING);

  f_DataSet.AddFieldInfo('OPEN5', 4, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('CLOSE5', 4, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SETTLEMENT5', 4, COLTYPE_STRING);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_BASIC_TR_0020_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_BASIC');
  f_DataPackage.SetTRCode('TR_0020');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('NONE', 12, COLTYPE_STRING);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_BASIC_TR_0020_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_BASIC');
  f_DataPackage.SetTRCode('TR_0020');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('COUNTRY_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('GROUP_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('MARKET_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('MATERIAL_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('PRECISION', 32, COLTYPE_INTEGER);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_BASIC_TR_0030_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_BASIC');
  f_DataPackage.SetTRCode('TR_0030');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('NONE', 12, COLTYPE_STRING);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_BASIC_TR_0030_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_BASIC');
  f_DataPackage.SetTRCode('TR_0030');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('DATETIME', 32, COLTYPE_STRING);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_ACCOUNT_TR_0010_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_ACCOUNT');
  f_DataPackage.SetTRCode('TR_0010');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('NONE', 12, COLTYPE_STRING);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_ACCOUNT_TR_0010_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_ACCOUNT');
  f_DataPackage.SetTRCode('TR_0010');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('ACCOUNT_NO', 20, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SERIAL_NO', 60, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('ACCOUNT_NAME', 60, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('CODE', 20, COLTYPE_STRING);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
//
function Make_SC_CODE_TR_0010_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_CODE');
  f_DataPackage.SetTRCode('TR_0010');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('BROKER_CODE', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('PGM_CODE', 12, COLTYPE_STRING);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
//
function Make_SC_CODE_TR_0010_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_CODE');
  f_DataPackage.SetTRCode('TR_0010');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('COUNTRY_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('GROUP_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('MARKET_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('SYMBOL', 16, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('NAME', 60, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SEC_SYMBOL', 16, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('CONTRACT', 16, COLTYPE_STRING);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
// OPS선물시세를 조회에 필요한 입력문
function Make_SC_QUOTE_TR_0010_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_QUOTE');
  f_DataPackage.SetTRCode('TR_0010');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('SYMBOL', 16 + 1, COLTYPE_STRING);
  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
// OPS선물시세를 조회후 받게될 출력문
function Make_SC_QUOTE_TR_0010_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_QUOTE');
  f_DataPackage.SetTRCode('TR_0010');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('COUNTRY_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('GROUP_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('MARKET_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('SYMBOL', 16, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('NAME', 60, COLTYPE_STRING);

  f_DataSet.AddFieldInfo('DATE', 8, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('TIME', 6, COLTYPE_STRING);

  f_DataSet.AddFieldInfo('OPEN_PRICE', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('HIGH_PRICE', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('LOW_PRICE', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('CLOSE_PRICE', 32, COLTYPE_DOUBLE);

  f_DataSet.AddFieldInfo('OPEN_OPS', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('HIGH_OPS', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('LOW_OPS', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('CLOSE_OPS', 32, COLTYPE_DOUBLE);

  f_DataSet.AddFieldInfo('VOLUME', 32, COLTYPE_DOUBLE);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
//
function Make_SC_QUOTE_TR_0110_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_QUOTE');
  f_DataPackage.SetTRCode('TR_0110');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('COUNTRY_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('GROUP_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('MARKET_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('SYMBOL', 12, COLTYPE_STRING);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
//
function Make_SC_QUOTE_TR_0110_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_QUOTE');
  f_DataPackage.SetTRCode('TR_0110');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('COUNTRY_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('GROUP_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('MARKET_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('SYMBOL', 12, COLTYPE_STRING);

  f_DataSet.AddFieldInfo('DATE', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('TIME', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('PREV_CLOSE', 32, COLTYPE_DOUBLE);

  f_DataSet.AddFieldInfo('CLOSE_PRICE', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('CHANGE', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('CHANGERATE', 32, COLTYPE_DOUBLE);

  f_DataSet.AddFieldInfo('TOTAL_VOLUME', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('TOTAL_VALUE', 32, COLTYPE_DOUBLE);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
// 선물주문을 전달할 때 필요한 입력문
function Make_SC_ORDER_TR_0010_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_ORDER');
  f_DataPackage.SetTRCode('TR_0010');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('COLLECTION_TYPE', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('BLOCK_NAME', 256, COLTYPE_STRING); // 블록이름
  f_DataSet.AddFieldInfo('BLOCK_KEY', 256, COLTYPE_STRING); // 블록키
  f_DataSet.AddFieldInfo('SIGNAL_SEQ', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('ORDER_SEQ', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('USERID', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('ACCOUNT_NO', 12, COLTYPE_STRING); // 계좌번호
  f_DataSet.AddFieldInfo('PASSWORD', 12, COLTYPE_STRING); // 비밀번호
  f_DataSet.AddFieldInfo('SYMBOL', 12, COLTYPE_STRING); // 종목코드
  f_DataSet.AddFieldInfo('DATATYPE', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('ORDER_COMMAND', 32, COLTYPE_INTEGER);
  // 매매구분 코드. 1:매도, 2:매수, 3:정정, 4:취소
  f_DataSet.AddFieldInfo('BUYSELL', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('ORDER_VOLUME', 32, COLTYPE_INTEGER); // 주문수량
  f_DataSet.AddFieldInfo('ORDER_PRICE', 32, COLTYPE_DOUBLE); // 주문가격
  f_DataSet.AddFieldInfo('CURRENT_PRICE', 32, COLTYPE_DOUBLE); // 현재가격

  f_DataSet.AddFieldInfo('PRICETYPE', 32, COLTYPE_STRING);
  // 주문구문 코드. "01”:지정가, “02”:시장가, “03”:조건부지정가, “04”:최유리지정가
  f_DataSet.AddFieldInfo('CONDITION', 32, COLTYPE_INTEGER);
  // 주문조건구분. 0:일반, 1:IOC, 2:FOK
  f_DataSet.AddFieldInfo('ORG_ORDER_NO', 12, COLTYPE_STRING); // 원주문번호

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
// 선물주문을 전달한 후 받게 될 출력문
function Make_SC_ORDER_TR_0010_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_ORDER');
  f_DataPackage.SetTRCode('TR_0010');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('COLLECTION_TYPE', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('SCREEN_NAME', 256, COLTYPE_STRING); // 화면이름
  f_DataSet.AddFieldInfo('SIGNAL_SEQ', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('ORDER_SEQ', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('USERID', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('ACCOUNT_NO', 12, COLTYPE_STRING); // 계좌번호
  f_DataSet.AddFieldInfo('SYMBOL', 12, COLTYPE_STRING); // 종목코드

  f_DataSet.AddFieldInfo('DATATYPE', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('ORDER_COMMAND', 32, COLTYPE_INTEGER);
  // 매매구분 코드. 1:매도, 2:매수, 3:정정, 4:취소
  f_DataSet.AddFieldInfo('BUYSELL', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('ORDER_VOLUME', 32, COLTYPE_INTEGER); // 주문수량

  f_DataSet.AddFieldInfo('ORDER_PRICE', 32, COLTYPE_DOUBLE); // 주문가격
  f_DataSet.AddFieldInfo('PRICETYPE', 32, COLTYPE_STRING); //

  f_DataSet.AddFieldInfo('CONDITION', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('ORDER_NO', 12, COLTYPE_STRING); // 주문번호
  f_DataSet.AddFieldInfo('ORG_ORDER_NO', 12, COLTYPE_STRING); // 원주문번호

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
// 선물시세를 조회에 필요한 입력문
function Make_SC_QUOTE_TR_0210_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_QUOTE');
  f_DataPackage.SetTRCode('TR_0210');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('COUNTRY_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('GROUP_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('MARKET_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('SYMBOL', 12, COLTYPE_STRING);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
// 선물시세를 조회후 받게될 출력문
function Make_SC_QUOTE_TR_0210_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_QUOTE');
  f_DataPackage.SetTRCode('TR_0210');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('COUNTRY_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('GROUP_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('MARKET_NO', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('SYMBOL', 12, COLTYPE_STRING);

  f_DataSet.AddFieldInfo('TIME', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('PREV_CLOSE', 32, COLTYPE_DOUBLE);

  f_DataSet.AddFieldInfo('CLOSE_PRICE', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('CHANGE', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('CHANGERATE', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('BEST_OFFER_PRICE', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('BEST_BID_PRICE', 32, COLTYPE_DOUBLE);

  f_DataSet.AddFieldInfo('OPEN_PRICE', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('HIGH_PRICE', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('LOW_PRICE', 32, COLTYPE_DOUBLE);

  f_DataSet.AddFieldInfo('VOLUME', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('TOTAL_VOLUME', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('TOTAL_VALUE', 32, COLTYPE_DOUBLE);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
// 선물주문을 전달할 때 필요한 입력문
function Make_SC_ORDER_TR_0210_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_ORDER');
  f_DataPackage.SetTRCode('TR_0210');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('COLLECTION_TYPE', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('BLOCK_NAME', 256, COLTYPE_STRING); // 블록이름
  f_DataSet.AddFieldInfo('BLOCK_KEY', 256, COLTYPE_STRING); // 블록키
  f_DataSet.AddFieldInfo('SIGNAL_SEQ', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('ORDER_SEQ', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('USERID', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('ACCOUNT_NO', 12, COLTYPE_STRING); // 계좌번호
  f_DataSet.AddFieldInfo('PASSWORD', 12, COLTYPE_STRING); // 비밀번호
  f_DataSet.AddFieldInfo('SYMBOL', 12, COLTYPE_STRING); // 종목코드
  f_DataSet.AddFieldInfo('DATATYPE', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('ORDER_COMMAND', 32, COLTYPE_INTEGER);
  // 매매구분 코드. 1:매도, 2:매수, 3:정정, 4:취소
  f_DataSet.AddFieldInfo('BUYSELL', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('ORDER_VOLUME', 32, COLTYPE_INTEGER); // 주문수량
  f_DataSet.AddFieldInfo('ORDER_PRICE', 32, COLTYPE_DOUBLE); // 주문가격
  f_DataSet.AddFieldInfo('CURRENT_PRICE', 32, COLTYPE_DOUBLE); // 현재가격

  f_DataSet.AddFieldInfo('PRICETYPE', 32, COLTYPE_STRING);
  // 주문구문 코드. "01”:지정가, “02”:시장가, “03”:조건부지정가, “04”:최유리지정가
  f_DataSet.AddFieldInfo('CONDITION', 32, COLTYPE_INTEGER);
  // 주문조건구분. 0:일반, 1:IOC, 2:FOK
  f_DataSet.AddFieldInfo('ORG_ORDER_NO', 12, COLTYPE_STRING); // 원주문번호

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
// 선물주문을 전달한 후 받게 될 출력문
function Make_SC_ORDER_TR_0210_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_ORDER');
  f_DataPackage.SetTRCode('TR_0210');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('COLLECTION_TYPE', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('SCREEN_NAME', 256, COLTYPE_STRING); // 화면이름
  f_DataSet.AddFieldInfo('SIGNAL_SEQ', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('ORDER_SEQ', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('USERID', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('ACCOUNT_NO', 12, COLTYPE_STRING); // 계좌번호
  f_DataSet.AddFieldInfo('SYMBOL', 12, COLTYPE_STRING); // 종목코드

  f_DataSet.AddFieldInfo('DATATYPE', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('ORDER_COMMAND', 32, COLTYPE_INTEGER);
  // 매매구분 코드. 1:매도, 2:매수, 3:정정, 4:취소
  f_DataSet.AddFieldInfo('BUYSELL', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('ORDER_VOLUME', 32, COLTYPE_INTEGER); // 주문수량

  f_DataSet.AddFieldInfo('ORDER_PRICE', 32, COLTYPE_DOUBLE); // 주문가격
  f_DataSet.AddFieldInfo('PRICETYPE', 32, COLTYPE_STRING); //

  f_DataSet.AddFieldInfo('CONDITION', 32, COLTYPE_INTEGER); //
  f_DataSet.AddFieldInfo('ORDER_NO', 12, COLTYPE_STRING); // 주문번호
  f_DataSet.AddFieldInfo('ORG_ORDER_NO', 12, COLTYPE_STRING); // 원주문번호

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_TRADE_TR_0100_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_TRADE');
  f_DataPackage.SetTRCode('TR_0100');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('LEADER_SESSION', 64, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('USER_ID', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('ACTION_DATE', 8, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('ACTION_TIME', 6, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('MODE', 8, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('DESCRIPTION', 1024, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('PRICE', 32, COLTYPE_DOUBLE);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_TRADE_TR_0110_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_TRADE');
  f_DataPackage.SetTRCode('TR_0110');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('TRADESESSION_KEY', 64, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('LEADER_SESSION', 64, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('USER_ID', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('ACTION_DATE', 8, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('ACTION_TIME', 6, COLTYPE_STRING);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_TRADE_TR_0200_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_TRADE');
  f_DataPackage.SetTRCode('TR_0200');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('TRADESESSION_KEY', 64, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('BLOCK_NAME', 32, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SIGNAL_ID', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('SIGNAL_DATE', 8, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SIGNAL_TIME', 6, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SYMBOL', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SIGNAL', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('PRICE', 32, COLTYPE_DOUBLE);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_TRADE_TR_0200_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_TRADE');
  f_DataPackage.SetTRCode('TR_0200');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('NONE', 12 + 1, COLTYPE_STRING);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_TRADE_TR_0300_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_TRADE');
  f_DataPackage.SetTRCode('TR_0300');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('TRADESESSION_KEY', 64, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('BLOCK_NAME', 32, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SIGNAL_ID', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('ORDER_ID', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('ORDER_DATE', 8, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('ORDER_TIME', 6, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('ACCOUNT', 32, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SYMBOL', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('ORDER_TYPE', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('BUYSELL', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('ORDER_PRICE', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('ORDER_VOLUME', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('STATUS', 32, COLTYPE_INTEGER);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_TRADE_TR_0310_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_TRADE');
  f_DataPackage.SetTRCode('TR_0310');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('TRADESESSION_KEY', 64, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('BLOCK_NAME', 32, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SIGNAL_ID', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('ORDER_ID', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('STATUS', 32, COLTYPE_INTEGER);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_TRADE_TR_0300_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_TRADE');
  f_DataPackage.SetTRCode('TR_0300');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('NONE', 12 + 1, COLTYPE_STRING);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_TRADE_TR_0400_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_TRADE');
  f_DataPackage.SetTRCode('TR_0400');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('TRADESESSION_KEY', 64, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('BLOCK_NAME', 32, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SIGNAL_ID', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('ORDER_ID', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('TRADE_ID', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('TRADE_DATE', 8, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('TRADE_TIME', 6, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('ACCOUNT', 32, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SYMBOL', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('TRADE_PRICE', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('TRADE_VOLUME', 32, COLTYPE_INTEGER);

  f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_TRADE_TR_0400_OUT(ADataPackage: CFNDataPackage): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_TRADE');
  f_DataPackage.SetTRCode('TR_0400');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_OUT_01;
  f_DataSet.AddFieldInfo('NONE', 12, COLTYPE_STRING);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
function Make_SC_TRADE_TR_0500_IN(ADataPackage: CFNDataPackage; ARecord: CFNRecord): CFNDataPackage;
var
  f_DataPackage: CFNDataPackage;
  f_DataSet: CFNDataSet;
begin
  if Assigned(ADataPackage) then
    f_DataPackage := ADataPackage
  else
    f_DataPackage := CFNDataPackage.Create;

  f_DataPackage.ClearAll;
  f_DataPackage.FillHead;
  f_DataPackage.SetServiceID('SC_TRADE');
  f_DataPackage.SetTRCode('TR_0500');

  f_DataSet := CFNDataSet.Create;
  f_DataSet.Name := DATASETID_IN_01;
  f_DataSet.AddFieldInfo('TRADESESSION_KEY', 64, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('BLOCK_NAME', 32, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('STAND_DATE', 8, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('STAND_TIME', 6, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('SYMBOL', 12, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('ACCOUNT', 32, COLTYPE_STRING);
  f_DataSet.AddFieldInfo('REAL_PROFIT', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('SYSTEM_PROFIT', 32, COLTYPE_DOUBLE);
  f_DataSet.AddFieldInfo('REAL_POSITION', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('SYSTEM_POSITION', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('ORDER_COUNT', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('TRADE_COUNT', 32, COLTYPE_INTEGER);
  f_DataSet.AddFieldInfo('PRICE', 32, COLTYPE_DOUBLE);
  if Assigned(ARecord) then
    f_DataSet.RecordList.Add(ARecord);

  f_DataPackage.DataSetList.AddObject(f_DataSet.Name, f_DataSet);

  Result := f_DataPackage;
end;

// ---------------------------------------------------------------------------
end.
