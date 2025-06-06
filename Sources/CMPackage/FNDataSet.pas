unit FNDataSet;

interface

uses
  XMLIntf, Contnrs, Dialogs, IniFiles, SysUtils, Variants, xmldom, msxmldom,
  XMLDoc,
  Forms, StrUtils, Math, SyncObjs, Classes, FNDataObject;

const
  COLTYPE_STRING = 'STRING';

const
  COLTYPE_DOUBLE = 'DECIMAL';

const
  COLTYPE_INTEGER = 'INTEGER';

const
  NODENAME_PACKET = 'datapackage';

const
  NODENAME_DATASET = 'dataset';

const
  NODENAME_COLINFO = 'fieldinfo';

const
  NODENAME_RECORD = 'record';

const
  DATASETID_HEAD = 'head';

const
  DATASETID_MSGHEAD = 'message';

const
  DATASETID_ERRORHEAD = 'error';

const
  DATASETID_IN_01 = 'input1';

const
  DATASETID_IN_02 = 'input2';

const
  DATASETID_IN_03 = 'input3';

const
  DATASETID_IN_04 = 'input4';

const
  DATASETID_IN_05 = 'input5';

const
  DATASETID_IN_06 = 'input6';

const
  DATASETID_IN_07 = 'input7';

const
  DATASETID_IN_08 = 'input8';

const
  DATASETID_IN_09 = 'input9';

const
  DATASETID_OUT_01 = 'output1';

const
  DATASETID_OUT_02 = 'output2';

const
  DATASETID_OUT_03 = 'output3';

const
  DATASETID_OUT_04 = 'output4';

const
  DATASETID_OUT_05 = 'output5';

const
  DATASETID_OUT_06 = 'output6';

const
  DATASETID_OUT_07 = 'output7';

const
  DATASETID_OUT_08 = 'output8';

const
  DATASETID_OUT_09 = 'output9';

  //
const
  RECORD_TYPE_INTEGER = 0;

const
  RECORD_TYPE_DOUBLE = 1;

const
  RECORD_TYPE_STRING = 2;

Type
  // ---------------------------------------------------------------------------
  // 레코드의 Cell 데이터
  CFNFieldValue = class
  protected
    m_Type: Integer;

    // 정수형 값을 저장한다.
    m_IntegerValue: Integer;
    // 실수형 값을 저장한다.
    m_DoubleValue: Double;
    // 문자열형 값을 저장한다.
    m_StringValue: String;
    // 변수의 소수점자리수를 저장한다.
    m_Precision: Integer;

  public

    Constructor Create;
    Destructor Destroy; override;

    procedure SetType(AType: Integer);
    function GetType: Integer;

    function GetIntegerValue: Integer;
    procedure SetIntegerValue(AValue: Integer);

    function GetDoubleValue: Double;
    procedure SetDoubleValue(AValue: Double; APrecision: Integer = 0);
    procedure SetDoubleValue2(AValue: Double);

    function GetStringValue: String;
    procedure SetStringValue(AValue: String);

    function GetPrecision: Integer;
    procedure SetPrecision(AValue: Integer);

    property DataType: Integer read GetType write SetType;
    property IntegerValue: Integer read GetIntegerValue write SetIntegerValue;
    property DoubleValue: Double read GetDoubleValue write SetDoubleValue2;
    property StringValue: String read GetStringValue write SetStringValue;
    property Precision: Integer read GetPrecision write SetPrecision;

  end;

  // ---------------------------------------------------------------------------
  // 필드 정보
  CFNFieldInfo = class(TObject)
  protected
    m_Name: String;
    m_Size: Integer;
    m_DataType: String;

  public
    Constructor Create;
    Destructor Destroy; override;

    property Name: String read m_Name write m_Name;
    property Size: Integer read m_Size write m_Size;
    property DataType: String read m_DataType write m_DataType;
  end;

  // ---------------------------------------------------------------------------
  // 레코드 Row 데이터
  CFNRecord = class(CFNDataObject)
  protected
    m_FieldValues: THashedStringList;

  public
    Constructor Create;
    Destructor Destroy; override;

    procedure ClearAll;

    // 값을 추가한다.
    procedure AddValueObject(AName: String; AValue: CFNFieldValue);

    // 키에 해당하는 값을 리턴한다.
    function GetValueObject(AName: String): CFNFieldValue;

    // 정수형 값을 설정한다.
    procedure AddIntegerValue(AName: String; AValue: Integer);
    procedure SetIntegerValue(AName: String; AValue: Integer);

    // 실수형 값을 설정한다.
    procedure AddDoubleValue(AName: String; AValue: Double; APrecision: Integer = 0);
    procedure SetDoubleValue(AName: String; AValue: Double; APrecision: Integer = 0);

    // 문자형 값을 설정한다.
    procedure AddStringValue(AName: String; AValue: String);
    procedure SetStringValue(AName: String; AValue: String);

    // 정수형 값을 설정한다.
    procedure AddBooleanValue(AName: String; AValue: Boolean);
    procedure SetBooleanValue(AName: String; AValue: Boolean);

    // 정수형 값을 리턴한다.
    function GetNameToIntegerValue(AName: String): Integer;
    function GetIndexToIntegerValue(AIndex: Integer): Integer;

    // 실수형 값을 리턴한다.
    function GetNameToDoubleValue(AName: String): Double;
    function GetIndexToDoubleValue(AIndex: Integer): Double;

    // 문자형 값을 리턴한다.
    function GetNameToStringValue(AName: String): String;
    function GetIndexToStringValue(AIndex: Integer): String;

    // 정수형 값을 리턴한다.
    function GetIntegerValue(AName: String): Integer;

    // 정수형 값을 리턴한다.
    function GetDoubleValue(AName: String): Double;

    // 문자형 값을 리턴한다.
    function GetStringValue(AName: String): String;

    // Boolean 값을 리턴한다.
    function GetBooleanValue(AName: String): Boolean;

    function GetPrecision(AName: String): Integer;
    procedure SetPrecision(AName: String; AValue: Integer);

    procedure CopyFieldValues(srcFieldValues: THashedStringList);
    procedure Clone(ASource: CFNRecord);

    property FieldValues: THashedStringList read m_FieldValues write m_FieldValues;
  end;

  /// /////////////////////////////////////////////////////////////////////////////////////////////
  CFNStreamRecord = class(CFNRecord)
  private
    // 패킷의 키
    m_Key: String;

    // 스트리밍의 특성상 하나의 서버에서 수신한 데이터를 여러 화면으로 동시에 전달해야 한다.
    // 그리고 각 화면에서는 이 패킷의 사용 종료시점을 예상할 수 없다.
    // 따라서 여러개의 복제본을 만들어야 한다. 그러면 메모리의 많은 소모가 예상되므로
    // 수신한 패킷을 분석해서 하나의 CFNStreamRecord만릉 생성하고 전달해야할 화면의 수만큼
    // m_ReletiveCount의 값을 설정한다. 각 화면에서는 이 오브젝트를 사용후 파기할 때 m_ReletiveCount의 값을 1감소 시킨다.
    // 따라서 m_ReletiveCount의 값이 0이 되었을 때 메모리에서 제거하는 방벙을 설정하면 화면의 수만큼 만들지 않고, 하나만 만들면 된다.
    // 그러나 m_ReletiveCount의 값을 1감소 시킬때 여러쓰레드에서 동시에 접근할 수 있어므로 이를 동기화한다.
    m_ReferenceCount: Integer;

    // m_ReferenceCount 를 변경하는 메소드 IncreaseReferenceCount와 DecreaseReferenceCount 에서 사용한다.
    m_ReferenceCountLock: TCriticalSection;
  public
    // 생성 메소드
    constructor Create;
    // 파괴메소드
    destructor Destroy; override;
    // 패킷의 키를 설정한다.
    procedure SetPacketKey(AKey: String);
    // 패킷의 키를 리턴한다.
    function GetPacketKey: String;
    // 참조카운트를 증가한다.
    procedure IncreaseReferenceCount;
    // 참조카운트를 감소한다.
    procedure DecreaseReferenceCount;
    // 참조카운트를 리턴한다.
    function GetReferenceCount: Integer;

    procedure CloneStreamRecord(ASource: CFNStreamRecord);

  end;

  // ---------------------------------------------------------------------------
  // 데이터 셋
  CFNDataSet = class(TObject)
  protected
    m_Name: String;
    m_FildInfo: THashedStringList;
    m_RecordList: TObjectList;

  public
    Constructor Create;
    Destructor Destroy; override;

    procedure ClearAll;
    procedure ClearFieldInfo;
    procedure ClearRecordList;

    function AddFieldInfo(AName: String; ASize: Integer; ADataType: String): CFNFieldInfo;
    function FindFieldInfo(AName: String): CFNFieldInfo;

    procedure ReadFromXML(AXMLNode: IXMLNode);
    procedure CloneRecord(var ARecordList: TList);

    function WriteToXML(): String;
    procedure Clone(ASource: CFNDataSet);

    property Name: String read m_Name write m_Name;
    property Field: THashedStringList read m_FildInfo write m_FildInfo;
    property RecordList: TObjectList read m_RecordList write m_RecordList;
  end;

  TFNServiceHead = record
    SERVICE_ID: String;
    TR_CODE: String;
    REQUEST_ID: String;
    USER_ID: String;
    MESSAGE_CODE: String;
  end;

  TFNServiceMessage = record
    CODE: String;
    CONTENT: String;
  end;

  // ---------------------------------------------------------------------------
  // 데이터 셋 패키지 클래스
  CFNDataPackage = class(CFNDataObject)
  public
    m_HeadDataSet: CFNDataSet;
    m_MessageDataSet: CFNDataSet;
    m_ErrorDataSet: CFNDataSet;
    m_DataList: THashedStringList;

  public
    Constructor Create;
    Destructor Destroy; override;

    procedure GetMessage(var p_Message: TFNServiceMessage);
    procedure GetErrorMessage(var p_Message: TFNServiceMessage);

    procedure ClearAll;
    procedure ClearDataList;

    // XML 데이터를 로드한다.
    function LoadXMLData(strXMLData: String): Boolean;
    // XML 파싱
    procedure PaserXML(XMLNode: IXMLNode);
    // DataSet 이름으로 CFNDataSet 오브젝트를 리턴한다.(head, message, error인경우 맴버변수 DataSet오브젝트리턴
    function GetDataSet(AName: String): CFNDataSet;

    procedure FillHead;
    procedure SetHeadValue(AKey: String; AValue: String);
    function GetHeadValue(AKey: String): String;

    // 해더설정
    procedure SetServiceID(AServiceID: String);
    procedure SetTRCode(ATRCode: String);
    procedure SetRequestID(ARequestID: String);
    procedure SetMsgCode(AMessageCode: String);
    procedure SetErrorCode(AErrorCode: String);
    procedure SetCompressedResponse(AValue: String);

    function GetServiceID: String;
    function GetTRCode: String;
    function GetRequestID: String;
    function GetMsgCode: String;
    function GetErrorCode: String;
    function GetCompressedResponse: String;

    function WriteToXML: String;

    property DataSetList: THashedStringList read m_DataList write m_DataList;

    procedure Clone(ASource: CFNDataPackage);

  end;

implementation

/// //////////////////////////////////////////////////////////////////////////
// ---------------------------------------------------------------------------
Constructor CFNFieldValue.Create;
begin
  inherited Create;

  m_Type := RECORD_TYPE_STRING;
  m_IntegerValue := 0;
  m_DoubleValue := 0;
  m_StringValue := '';

  m_Precision := 0;
end;

// ---------------------------------------------------------------------------
Destructor CFNFieldValue.Destroy;
begin
  inherited;
end;

// ---------------------------------------------------------------------------
// Integer Set
procedure CFNFieldValue.SetIntegerValue(AValue: Integer);
begin
  m_Type := RECORD_TYPE_INTEGER;
  m_IntegerValue := AValue;
  m_DoubleValue := AValue;
  m_StringValue := IntToStr(AValue);
end;

// ---------------------------------------------------------------------------
// Double Set
procedure CFNFieldValue.SetPrecision(AValue: Integer);
begin
  m_Precision := AValue;
end;

// ---------------------------------------------------------------------------
procedure CFNFieldValue.SetType(AType: Integer);
begin
  m_Type := AType;
end;

// ---------------------------------------------------------------------------
procedure CFNFieldValue.SetDoubleValue(AValue: Double; APrecision: Integer);
begin
  m_Type := RECORD_TYPE_DOUBLE;
  m_IntegerValue := floor(AValue);
  m_DoubleValue := AValue;
  m_StringValue := FloatToStr(AValue);
  m_Precision := APrecision;
end;

// ---------------------------------------------------------------------------
procedure CFNFieldValue.SetDoubleValue2(AValue: Double);
begin
  m_Type := RECORD_TYPE_DOUBLE;
  m_IntegerValue := floor(AValue);
  m_DoubleValue := AValue;
  m_StringValue := FloatToStr(AValue);
end;

// ---------------------------------------------------------------------------
// String Set
procedure CFNFieldValue.SetStringValue(AValue: String);
begin
  m_Type := RECORD_TYPE_STRING;
  m_IntegerValue := 0;
  m_DoubleValue := 0;
  m_StringValue := AValue;
end;

// ---------------------------------------------------------------------------
// Integer Get
function CFNFieldValue.GetIntegerValue: Integer;
begin
  Result := m_IntegerValue;
end;

// ---------------------------------------------------------------------------
// Double Get
function CFNFieldValue.GetPrecision: Integer;
begin
  Result := m_Precision;
end;

function CFNFieldValue.GetType: Integer;
begin
  Result := m_Type;
end;

// ---------------------------------------------------------------------------
// Double Get
function CFNFieldValue.GetDoubleValue: Double;
begin
  Result := m_DoubleValue;
end;

// ---------------------------------------------------------------------------
// String Get
function CFNFieldValue.GetStringValue: String;
begin
  Result := m_StringValue;
end;

/// //////////////////////////////////////////////////////////////////////////
// ---------------------------------------------------------------------------
Constructor CFNFieldInfo.Create;
begin
  inherited Create;
  m_Name := '';
  m_Size := 0;
  m_DataType := '';
end;

// ---------------------------------------------------------------------------
Destructor CFNFieldInfo.Destroy;
begin
  inherited;
end;

// ---------------------------------------------------------------------------
Constructor CFNRecord.Create;
begin
  inherited Create;

  m_FieldValues := THashedStringList.Create;
end;

// ---------------------------------------------------------------------------
Destructor CFNRecord.Destroy;
begin
  ClearAll;
  m_FieldValues.Free;

  inherited;
end;

// ---------------------------------------------------------------------------
// 레코드 데이터 전체 삭제한다.
procedure CFNRecord.ClearAll;
begin
  while 0 < m_FieldValues.Count do
  begin
    CFNFieldValue(m_FieldValues.Objects[0]).Free;
    m_FieldValues.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 값을 추가한다.
procedure CFNRecord.AddValueObject(AName: String; AValue: CFNFieldValue);
begin
  m_FieldValues.AddObject(AName, AValue);
end;

// ---------------------------------------------------------------------------
// 키에 해당하는 값을 리턴한다.
function CFNRecord.GetValueObject(AName: String): CFNFieldValue;
var
  f_Index: Integer;
  f_FieldValue: CFNFieldValue;
begin
  f_FieldValue := NIL;

  if 0 < Length(AName) then
  begin
    f_Index := m_FieldValues.IndexOf(AName);
    if 0 <= f_Index then
    begin
      f_FieldValue := CFNFieldValue(m_FieldValues.Objects[f_Index]);
    end;
  end;
  Result := f_FieldValue;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(Integer)
procedure CFNRecord.AddIntegerValue(AName: String; AValue: Integer);
var
  f_FieldValue: CFNFieldValue;
begin
  if 0 < Length(AName) then
  begin
    f_FieldValue := CFNFieldValue.Create;
    f_FieldValue.SetIntegerValue(AValue);
    m_FieldValues.AddObject(AName, f_FieldValue);
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(Double)
procedure CFNRecord.AddDoubleValue(AName: String; AValue: Double; APrecision: Integer);
var
  f_FieldValue: CFNFieldValue;
begin
  if 0 < Length(AName) then
  begin
    f_FieldValue := CFNFieldValue.Create;
    f_FieldValue.SetDoubleValue(AValue, APrecision);
    m_FieldValues.AddObject(AName, f_FieldValue);
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(String)
procedure CFNRecord.AddStringValue(AName: String; AValue: String);
var
  f_FieldValue: CFNFieldValue;
begin
  if 0 < Length(AName) then
  begin
    f_FieldValue := CFNFieldValue.Create;
    f_FieldValue.SetStringValue(AValue);
    m_FieldValues.AddObject(AName, f_FieldValue);
  end;
end;

// ------------------------------------------------------------------------
procedure CFNRecord.SetIntegerValue(AName: String; AValue: Integer);
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if 0 <= AIndex then
    begin
      CFNFieldValue(m_FieldValues.Objects[AIndex]).SetIntegerValue(AValue);
    end
    else
    begin
      AddIntegerValue(AName, AValue);
    end;
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(Double)
procedure CFNRecord.SetDoubleValue(AName: String; AValue: Double; APrecision: Integer);
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if 0 <= AIndex then
    begin
      CFNFieldValue(m_FieldValues.Objects[AIndex]).SetDoubleValue(AValue, APrecision);
    end
    else
    begin
      AddDoubleValue(AName, AValue, APrecision);
    end;
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(String)
procedure CFNRecord.SetStringValue(AName: String; AValue: String);
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if 0 <= AIndex then
    begin
      CFNFieldValue(m_FieldValues.Objects[AIndex]).SetStringValue(AValue);
    end
    else
    begin
      AddStringValue(AName, AValue);
    end;
  end;
end;

procedure CFNRecord.AddBooleanValue(AName: String; AValue: Boolean);
begin
  if AValue then
    AddIntegerValue(AName, 1)
  else
    AddIntegerValue(AName, 0);
end;

procedure CFNRecord.SetBooleanValue(AName: String; AValue: Boolean);
begin
  if AValue then
    SetIntegerValue(AName, 1)
  else
    SetIntegerValue(AName, 0);
end;

// ------------------------------------------------------------------------
// FieldValues의 필드 명으로 해당 레코드의 Cell value 값을 리턴한다.(Integer)
function CFNRecord.GetNameToIntegerValue(AName: String): Integer;
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
    begin
      Result := CFNFieldValue(m_FieldValues.Objects[AIndex]).GetIntegerValue;
    end
    else
    begin
      Result := 0;
    end;
  end
  else
  begin
    Result := 0;
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 인덱스로 해당 레코드의 Cell value 값을 리턴한다.(Integer)
function CFNRecord.GetIndexToIntegerValue(AIndex: Integer): Integer;
begin
  if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
  begin
    Result := CFNFieldValue(m_FieldValues.Objects[AIndex]).GetIntegerValue;
  end
  else
  begin
    Result := 0;
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 필드 명으로 해당 레코드의 Cell value 값을 리턴한다.(Double)
function CFNRecord.GetNameToDoubleValue(AName: String): Double;
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
    begin
      Result := CFNFieldValue(m_FieldValues.Objects[AIndex]).GetDoubleValue;
    end
    else
    begin
      Result := 0;
    end;
  end
  else
  begin
    Result := 0;
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 인덱스로 해당 레코드의 Cell value 값을 리턴한다.(Double)

function CFNRecord.GetIndexToDoubleValue(AIndex: Integer): Double;
begin
  if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
  begin
    Result := CFNFieldValue(m_FieldValues.Objects[AIndex]).GetDoubleValue;
  end
  else
  begin
    Result := 0;
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 필드 명으로 해당 레코드의 Cell value 값을 리턴한다.
function CFNRecord.GetNameToStringValue(AName: String): String;
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
    begin
      Result := CFNFieldValue(m_FieldValues.Objects[AIndex]).GetStringValue;
    end
    else
    begin
      Result := '';
    end;
  end
  else
  begin
    Result := '';
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 인덱스로 해당 레코드의 Cell value 값을 리턴한다.(String)
function CFNRecord.GetIndexToStringValue(AIndex: Integer): String;
begin
  if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
  begin
    Result := CFNFieldValue(m_FieldValues.Objects[AIndex]).GetStringValue;
  end
  else
  begin
    Result := '';
  end;
end;

// ------------------------------------------------------------------------
function CFNRecord.GetIntegerValue(AName: String): Integer;
begin
  Result := GetNameToIntegerValue(AName);
end;

// ------------------------------------------------------------------------
function CFNRecord.GetBooleanValue(AName: String): Boolean;
var
  f_Value: Integer;
begin
  f_Value := GetNameToIntegerValue(AName);
  if f_Value = 1 then
    Result := true
  else
    Result := false;
end;

// ------------------------------------------------------------------------
function CFNRecord.GetDoubleValue(AName: String): Double;
begin
  Result := GetNameToDoubleValue(AName);
end;

// ------------------------------------------------------------------------
function CFNRecord.GetStringValue(AName: String): String;
begin
  Result := GetNameToStringValue(AName);
end;

// ------------------------------------------------------------------------
function CFNRecord.GetPrecision(AName: String): Integer;
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
    begin
      Result := CFNFieldValue(m_FieldValues.Objects[AIndex]).GetPrecision;
    end
    else
    begin
      Result := 0;
    end;
  end
  else
  begin
    Result := 0;
  end;
end;

// ------------------------------------------------------------------------
procedure CFNRecord.SetPrecision(AName: String; AValue: Integer);
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if 0 <= AIndex then
    begin
      CFNFieldValue(m_FieldValues.Objects[AIndex]).SetPrecision(AValue);
    end;
  end;
end;

// ------------------------------------------------------------------------
procedure CFNRecord.Clone(ASource: CFNRecord);
var
  f_Loop: Integer;

  f_SrcFieldValue: CFNFieldValue;
  f_TagFieldValue: CFNFieldValue;
begin
  ClearAll;

  for f_Loop := 0 to ASource.FieldValues.Count - 1 do
  begin
    f_SrcFieldValue := CFNFieldValue(ASource.FieldValues.Objects[f_Loop]);

    f_TagFieldValue := CFNFieldValue.Create;
    if (RECORD_TYPE_DOUBLE = f_SrcFieldValue.m_Type) then
    begin
      f_TagFieldValue.SetDoubleValue(f_SrcFieldValue.GetDoubleValue);
    end
    else if (RECORD_TYPE_INTEGER = f_SrcFieldValue.m_Type) then
    begin
      f_TagFieldValue.SetIntegerValue(f_SrcFieldValue.GetIntegerValue);
    end
    else
    begin
      f_TagFieldValue.SetStringValue(f_SrcFieldValue.GetStringValue);
    end;

    m_FieldValues.AddObject(ASource.FieldValues.Strings[f_Loop], f_TagFieldValue);
  end;
end;

// ------------------------------------------------------------------------
// Row의 FieldValues의 내용을 복사한다.
procedure CFNRecord.CopyFieldValues(srcFieldValues: THashedStringList);
var
  nLoop: Integer;

  f_FieldValue: CFNFieldValue;
  newStrObj: CFNFieldValue;
begin
  ClearAll;

  for nLoop := 0 to srcFieldValues.Count - 1 do
  begin
    f_FieldValue := CFNFieldValue(srcFieldValues.Objects[nLoop]);

    newStrObj := CFNFieldValue.Create;
    if (RECORD_TYPE_DOUBLE = f_FieldValue.m_Type) then
    begin
      newStrObj.SetDoubleValue(f_FieldValue.GetDoubleValue);
    end
    else if (RECORD_TYPE_INTEGER = f_FieldValue.m_Type) then
    begin
      newStrObj.SetIntegerValue(f_FieldValue.GetIntegerValue);
    end
    else
    begin
      newStrObj.SetStringValue(f_FieldValue.GetStringValue);
    end;

    m_FieldValues.AddObject(srcFieldValues.Strings[nLoop], newStrObj);
  end;
end;

// ---------------------------------------------------------------------------
Constructor CFNDataSet.Create;
begin
  inherited Create;
  m_Name := '';
  m_FildInfo := THashedStringList.Create;
  m_RecordList := TObjectList.Create;
end;

// ---------------------------------------------------------------------------
Destructor CFNDataSet.Destroy;
begin
  m_Name := '';
  ClearAll;
  m_FildInfo.Free;
  m_RecordList.Free;

  inherited;
end;

// ---------------------------------------------------------------------------
// 데이터셋의 필드, 레코드 내용을 전체 삭제한다.
procedure CFNDataSet.ClearAll;
begin
  // Field
  ClearFieldInfo;

  // Record
  ClearRecordList;
end;

// ---------------------------------------------------------------------------
// 데이터셋의 필드 정보를 모두 삭제한다.
procedure CFNDataSet.ClearFieldInfo;
begin
  // Field
  while 0 < m_FildInfo.Count do
  begin
    CFNFieldInfo(m_FildInfo.Objects[0]).Free;
    m_FildInfo.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 데이터셋의 레코드 정보를 모두 삭제한다.
procedure CFNDataSet.ClearRecordList;
begin
  while 0 < m_RecordList.Count do
  begin
    // CFNRecord(m_RecordList.Items[0]).Destroy;
    m_RecordList.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 데이터셋의 필드를 추가한다.
function CFNDataSet.AddFieldInfo(AName: String; ASize: Integer; ADataType: String): CFNFieldInfo;
var
  fieldInfo: CFNFieldInfo;
begin
  fieldInfo := FindFieldInfo(AName);
  if NIL = fieldInfo then
  begin
    fieldInfo := CFNFieldInfo.Create;
    fieldInfo.Name := AName;
    fieldInfo.Size := ASize;
    fieldInfo.DataType := ADataType;
    m_FildInfo.AddObject(fieldInfo.Name, fieldInfo);
  end
  else
  begin
    fieldInfo.Name := AName;
    fieldInfo.Size := ASize;
    fieldInfo.DataType := ADataType;
  end;

  Result := fieldInfo;
end;

// ---------------------------------------------------------------------------
// 필드명으로 필드 상세정보를 리턴한다.
function CFNDataSet.FindFieldInfo(AName: String): CFNFieldInfo;
var
  fieldInfo: CFNFieldInfo;
  AIndex: Integer;
begin
  fieldInfo := NIL;

  if 0 < Length(AName) then
  begin
    AIndex := m_FildInfo.IndexOf(AName);
    if 0 <= AIndex then
    begin
      fieldInfo := CFNFieldInfo(m_FildInfo.Objects[AIndex]);
    end;
  end;

  Result := fieldInfo;
end;

// ---------------------------------------------------------------------------
// XML 데이터를 읽어서 Record 데이터를 추가한다.
procedure CFNDataSet.ReadFromXML(AXMLNode: IXMLNode);
var
  nLoop1: Integer;
  nLoop2: Integer;
  childNode1: IXMLNode;

  recordNode: IXMLNode;
  pRecord: CFNRecord;
  AValue: String;

  findField: CFNFieldInfo;

  f_RecordNodeName: String;
begin
  if NODENAME_DATASET = AXMLNode.NodeName then
  begin
    m_Name := AXMLNode.Attributes['id'];
    if 0 < Length(m_Name) then
    begin
      for nLoop1 := 0 to AXMLNode.ChildNodes.Count - 1 do
      begin
        childNode1 := AXMLNode.ChildNodes[nLoop1];
        if NODENAME_COLINFO = childNode1.NodeName then
        begin
          AddFieldInfo(childNode1.Attributes['id'], childNode1.Attributes['size'], childNode1.Attributes['type']);
        end
        else if NODENAME_RECORD = childNode1.NodeName then
        begin
          pRecord := CFNRecord.Create;

          for nLoop2 := 0 to childNode1.ChildNodes.Count - 1 do
          begin
            recordNode := childNode1.ChildNodes[nLoop2];
            if (NIL = recordNode) then
              continue;
            f_RecordNodeName := Trim(recordNode.NodeName);

            if (0 < Length(f_RecordNodeName)) then
            begin
              findField := FindFieldInfo(recordNode.NodeName);
              if NIL <> findField then
              begin
                if COLTYPE_STRING = findField.m_DataType then
                begin
                  AValue := VarToStr(recordNode.NodeValue);
                  pRecord.AddStringValue(recordNode.NodeName, AValue);
                end
                else if COLTYPE_DOUBLE = findField.m_DataType then
                begin
                  AValue := VarToStr(recordNode.NodeValue);
                  pRecord.AddDoubleValue(recordNode.NodeName, StrToFloat(AValue));
                end
                else if COLTYPE_INTEGER = findField.m_DataType then
                begin
                  AValue := VarToStr(recordNode.NodeValue);
                  pRecord.AddIntegerValue(recordNode.NodeName, StrToInt(AValue));
                end;
              end;
            end;
          end;

          m_RecordList.Add(pRecord);
        end;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// 레코드 데이터를 TList로 복사한다.
procedure CFNDataSet.CloneRecord(var ARecordList: TList);
var
  nLoop1: Integer;

  srcRecord: CFNRecord;
  newRecord: CFNRecord;
begin
  while 0 < ARecordList.Count do
  begin
    CFNRecord(ARecordList.Items[0]).Destroy;
    ARecordList.Delete(0);
  end;

  for nLoop1 := 0 to m_RecordList.Count - 1 do
  begin
    srcRecord := CFNRecord(m_RecordList.Items[nLoop1]);

    newRecord := CFNRecord.Create;
    newRecord.CopyFieldValues(srcRecord.FieldValues);

    ARecordList.Add(newRecord);
  end;

end;

// ---------------------------------------------------------------------------
function CFNDataSet.WriteToXML(): String;
var
  f_szXMLString: String;
  f_nIndex: Integer;
  f_nRecordIndex: Integer;
  f_nFieldInfoIndex: Integer;
  f_FieldInfo: CFNFieldInfo;
  f_Record: CFNRecord;
  f_RecordCell: CFNFieldValue;
begin
  f_szXMLString := #9 + '<' + NODENAME_DATASET + ' id="' + m_Name + '">' + #$0A;

  for f_nIndex := 0 to m_FildInfo.Count - 1 do
  begin
    f_FieldInfo := CFNFieldInfo(m_FildInfo.Objects[f_nIndex]);
    if Assigned(f_FieldInfo) then
    begin
      f_szXMLString := f_szXMLString + #9#9 + '<' + NODENAME_COLINFO + ' id="' + f_FieldInfo.Name + '" size="' + IntToStr(f_FieldInfo.Size) + '" type="' + f_FieldInfo.DataType + '"/>' + #$0A;
    end;
  end;

  for f_nRecordIndex := 0 to m_RecordList.Count - 1 do
  begin
    f_szXMLString := f_szXMLString + #9#9 + '<' + NODENAME_RECORD + '>' + #$0A;

    f_Record := CFNRecord(m_RecordList.Items[f_nRecordIndex]);
    for f_nFieldInfoIndex := 0 to m_FildInfo.Count - 1 do
    begin
      f_FieldInfo := CFNFieldInfo(m_FildInfo.Objects[f_nFieldInfoIndex]);
      if Assigned(f_FieldInfo) then
      begin
        f_RecordCell := CFNFieldValue(f_Record.m_FieldValues.Objects[f_nFieldInfoIndex]);
        if Assigned(f_RecordCell) then
        begin
          if COLTYPE_DOUBLE = f_FieldInfo.DataType then
          begin
            if Assigned(f_RecordCell) then
            begin
              f_szXMLString := f_szXMLString + #9#9#9 + '<' + f_FieldInfo.Name + '>' + FloatToStr(f_RecordCell.GetDoubleValue) + '</' + f_FieldInfo.Name + '>' + #$0A;
            end
            else
            begin
              f_szXMLString := f_szXMLString + #9#9#9 + '<' + f_FieldInfo.Name + '>' + '0</' + f_FieldInfo.Name + '>' + #$0A;
            end;
          end
          else if COLTYPE_INTEGER = f_FieldInfo.DataType then
          begin
            if Assigned(f_RecordCell) then
            begin
              f_szXMLString := f_szXMLString + #9#9#9 + '<' + f_FieldInfo.Name + '>' + FloatToStr(f_RecordCell.GetIntegerValue) + '</' + f_FieldInfo.Name + '>' + #$0A;
            end
            else
            begin
              f_szXMLString := f_szXMLString + #9#9#9 + '<' + f_FieldInfo.Name + '>' + '0</' + f_FieldInfo.Name + '>' + #$0A;
            end;
          end
          else
          begin
            if Assigned(f_RecordCell) and (0 < Length(f_RecordCell.GetStringValue)) then
            begin
              f_szXMLString := f_szXMLString + #9#9#9 + '<' + f_FieldInfo.Name + '>' + '<![CDATA[' + f_RecordCell.GetStringValue + ']]>' + '</' + f_FieldInfo.Name + '>' + #$0A;
            end
            else
            begin
              f_szXMLString := f_szXMLString + #9#9#9 + '<' + f_FieldInfo.Name + '>' + '</' + f_FieldInfo.Name + '>' + #$0A;
            end;
          end;
        end;
      end;
    end;

    f_szXMLString := f_szXMLString + #9#9 + '</' + NODENAME_RECORD + '>' + #$0A;
  end;
  f_szXMLString := f_szXMLString + #9 + '</' + NODENAME_DATASET + '>' + #$0A;

  Result := f_szXMLString;
end;

// ---------------------------------------------------------------------------
procedure CFNDataSet.Clone(ASource: CFNDataSet);
var
  f_nRecordIndex: Integer;
  f_nFieldInfoIndex: Integer;
  f_OldFieldInfo: CFNFieldInfo;
  f_OldRecord: CFNRecord;
  f_NewRecord: CFNRecord;
  // f_OldRecordCell : CFNFieldValue;
begin
  ClearAll;

  m_Name := ASource.m_Name;

  for f_nFieldInfoIndex := 0 to ASource.m_FildInfo.Count - 1 do
  begin
    f_OldFieldInfo := CFNFieldInfo(ASource.m_FildInfo.Objects[f_nFieldInfoIndex]);
    if Assigned(f_OldFieldInfo) then
    begin
      AddFieldInfo(f_OldFieldInfo.Name, f_OldFieldInfo.Size, f_OldFieldInfo.DataType);
    end;
  end;

  for f_nRecordIndex := 0 to ASource.m_RecordList.Count - 1 do
  begin
    f_OldRecord := CFNRecord(ASource.m_RecordList.Items[f_nRecordIndex]);
    f_NewRecord := CFNRecord.Create;
    f_NewRecord.CopyFieldValues(f_OldRecord.FieldValues);
    (*
      for f_nFieldInfoIndex := 0 to ASource.m_FildInfo.Count - 1 do
      begin
      f_OldFieldInfo := CFNFieldInfo(ASource.m_FildInfo.Objects[f_nFieldInfoIndex]);
      if Assigned(f_OldFieldInfo) then
      begin
      f_OldRecordCell := CFNFieldValue(f_OldRecord.m_FieldValues.Objects[f_nFieldInfoIndex]);
      if Assigned(f_OldRecordCell) then
      begin
      if COLTYPE_DOUBLE = f_OldFieldInfo.DataType then
      begin
      if Assigned(f_OldRecordCell) then
      begin
      f_NewRecord.AddDoubleValue(f_OldFieldInfo.Name, f_OldRecordCell.GetDoubleValue);
      end else
      begin
      f_NewRecord.AddDoubleValue(f_OldFieldInfo.Name, 0);
      end;
      end else
      if COLTYPE_INTEGER = f_OldFieldInfo.DataType then
      begin
      if Assigned(f_OldRecordCell) then
      begin
      f_NewRecord.AddIntegerValue(f_OldFieldInfo.Name, f_OldRecordCell.GetIntegerValue);
      end else
      begin
      f_NewRecord.AddIntegerValue(f_OldFieldInfo.Name, 0);
      end;
      end else
      begin
      if Assigned(f_OldRecordCell) and (0 < Length(f_OldRecordCell.GetStringValue)) then
      begin
      f_NewRecord.AddStringValue(f_OldFieldInfo.Name, f_OldRecordCell.GetStringValue);
      end else
      begin
      f_NewRecord.AddStringValue(f_OldFieldInfo.Name, '');
      end;
      end;
      end;
      end;
      end;
    *)
    m_RecordList.Add(f_NewRecord);
  end;
end;

// ---------------------------------------------------------------------------
Constructor CFNDataPackage.Create;
begin
  inherited Create;

  DeliveryType := dvtQuery;

  m_HeadDataSet := CFNDataSet.Create;
  m_MessageDataSet := CFNDataSet.Create;
  m_ErrorDataSet := CFNDataSet.Create;

  m_HeadDataSet.Name := DATASETID_HEAD;
  m_MessageDataSet.Name := DATASETID_MSGHEAD;
  m_ErrorDataSet.Name := DATASETID_ERRORHEAD;

  m_DataList := THashedStringList.Create;
end;

// ---------------------------------------------------------------------------
Destructor CFNDataPackage.Destroy;
begin
  ClearAll;

  m_HeadDataSet.Free;
  m_MessageDataSet.Free;
  m_ErrorDataSet.Destroy;
  m_DataList.Free;

  inherited;
end;

// ---------------------------------------------------------------------------
// 레코드 (해더, 메세지, 에러, 레코드 데이터)를 모두 지운다..
procedure CFNDataPackage.ClearAll;
begin
  m_HeadDataSet.ClearAll;
  m_MessageDataSet.ClearAll;
  m_ErrorDataSet.ClearAll;
  ClearDataList;
end;

// ---------------------------------------------------------------------------
// 레코드 데이터를 모두 지운다..
procedure CFNDataPackage.ClearDataList;
begin
  while 0 < m_DataList.Count do
  begin
    CFNDataSet(m_DataList.Objects[0]).Destroy;
    m_DataList.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// HTTP로 수신한 데이터를 로드한다.
function CFNDataPackage.LoadXMLData(strXMLData: String): Boolean;
var
  XMLDocument1: TXMLDocument;
begin
  Result := false;
  if (0 < Length(strXMLData)) then
  begin
    try
      if (0 < PosEx('</' + NODENAME_PACKET + '>', strXMLData, Length(strXMLData) - 20)) then
      begin
        XMLDocument1 := TXMLDocument.Create(Application);
        XMLDocument1.LoadFromXML(strXMLData);
        // XMLDocument1.Encoding := 'euc-kr';

        // XML Parser
        PaserXML(XMLDocument1.DocumentElement);

        XMLDocument1.Free;
        Result := true;
      end;
    except
      Result := false;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// HTTP로 수신한 데이터를 XML 파싱하여 DataSet에넣는다.
procedure CFNDataPackage.PaserXML(XMLNode: IXMLNode);
var
  strDataSetId: String;
  nLoop1: Integer; // Field Loop
  childNode1: IXMLNode; // Field Node
  pDs: CFNDataSet;
begin

  if NODENAME_PACKET = XMLNode.NodeName then
  begin
    for nLoop1 := 0 to XMLNode.ChildNodes.Count - 1 do
    begin
      childNode1 := XMLNode.ChildNodes[nLoop1];

      if NODENAME_DATASET = childNode1.NodeName then
      begin
        strDataSetId := childNode1.Attributes['id'];

        if 0 < Length(strDataSetId) then
        begin
          if DATASETID_HEAD = strDataSetId then
            m_HeadDataSet.ReadFromXML(childNode1)
          else if DATASETID_MSGHEAD = strDataSetId then
            m_MessageDataSet.ReadFromXML(childNode1)
          else if DATASETID_ERRORHEAD = strDataSetId then
            m_ErrorDataSet.ReadFromXML(childNode1)
          else
          begin
            pDs := CFNDataSet.Create;
            pDs.ReadFromXML(childNode1);
            m_DataList.AddObject(pDs.Name, pDs);
          end;
        end;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// 데이터셋 명으로 DataSet 을 리턴한다.
function CFNDataPackage.GetDataSet(AName: String): CFNDataSet;
var
  AIndex: Integer;
  ds: CFNDataSet;
begin
  ds := NIL;
  if 0 < Length(AName) then
  begin
    if DATASETID_HEAD = AName then
      ds := m_HeadDataSet
    else if DATASETID_MSGHEAD = AName then
      ds := m_MessageDataSet
    else if DATASETID_ERRORHEAD = AName then
      ds := m_ErrorDataSet
    else
    begin
      AIndex := m_DataList.IndexOf(AName);
      if (0 <= AIndex) then
        ds := CFNDataSet(m_DataList.Objects[AIndex])
    end;
  end;
  Result := ds;
end;

// ---------------------------------------------------------------------------
// 데이터셋의 해더 데이터를 셋팅한다.
procedure CFNDataPackage.FillHead;
var
  recordData: CFNRecord;
begin
  m_HeadDataSet.ClearAll;
  m_HeadDataSet.AddFieldInfo('SERVICE_ID', 14, COLTYPE_STRING);
  // 서비스코드			클라이언트에서 설정하는 서비스코드 			08.11.21 성훈 수정
  m_HeadDataSet.AddFieldInfo('TR_CODE', 12, COLTYPE_STRING);
  // 거래코드			클라이언트에서 설정하는 거래코드
  m_HeadDataSet.AddFieldInfo('REQUEST_ID', 5, COLTYPE_STRING);
  // 요청아이디			클라이언트에서 요청할 때 설정하는 값
  m_HeadDataSet.AddFieldInfo('USER_ID', 8, COLTYPE_STRING);
  // 사용자아이디			클라이언트에서 요청할 때 사용자 아이디 		08.11.21 성훈 수정
  m_HeadDataSet.AddFieldInfo('COMPRESSED_RESPONSE', 6, COLTYPE_STRING);
  m_HeadDataSet.AddFieldInfo('MESSAGE_CODE', 6, COLTYPE_STRING); // 처리결과코드
  m_HeadDataSet.AddFieldInfo('ERROR_CODE', 6, COLTYPE_STRING); // 에러코드

  if (0 = m_HeadDataSet.RecordList.Count) then
  begin
    recordData := CFNRecord.Create;
    recordData.AddStringValue('SERVICE_ID', '');
    recordData.AddStringValue('TR_CODE', '');
    recordData.AddStringValue('REQUEST_ID', '');
    recordData.AddStringValue('USER_ID', '');
    recordData.AddStringValue('COMPRESSED_RESPONSE', '1');
    recordData.AddStringValue('MESSAGE_CODE', '');
    recordData.AddStringValue('ERROR_CODE', '');

    m_HeadDataSet.RecordList.Add(recordData);
  end;

  m_MessageDataSet.ClearAll;
  m_MessageDataSet.AddFieldInfo('MESSAGE_CODE', 6, COLTYPE_STRING);
  m_MessageDataSet.AddFieldInfo('MESSAGE', 256, COLTYPE_STRING);
end;

// ---------------------------------------------------------------------------
// 해더에 해당키값으로 벨류를 넣는다.
procedure CFNDataPackage.SetHeadValue(AKey: String; AValue: String);
var
  recordData: CFNRecord;
begin
  recordData := NIL;
  if 0 < m_HeadDataSet.RecordList.Count then
    recordData := CFNRecord(m_HeadDataSet.RecordList.Items[0]);

  if NIL = recordData then
  begin
    FillHead;
    recordData := CFNRecord(m_HeadDataSet.RecordList.Items[0]);
    recordData.SetStringValue(AKey, AValue);
  end
  else
  begin
    recordData.SetStringValue(AKey, AValue);
  end;
end;

// ---------------------------------------------------------------------------
// 해더에 해당키값으로 벨류를 리턴한다.
function CFNDataPackage.GetHeadValue(AKey: String): String;
var
  recordData: CFNRecord;
begin
  recordData := NIL;

  if 0 < m_HeadDataSet.RecordList.Count then
    recordData := CFNRecord(m_HeadDataSet.RecordList.Items[0]);

  if NIL = recordData then
    Result := ''
  else
    Result := recordData.GetNameToStringValue(AKey);
end;

// ---------------------------------------------------------------------------
// 해더의 Service ID세팅
procedure CFNDataPackage.SetServiceID(AServiceID: String);
begin
  SetHeadValue('SERVICE_ID', AServiceID);
end;

// ---------------------------------------------------------------------------
// 해더의 TR Code 세팅
procedure CFNDataPackage.SetTRCode(ATRCode: String);
begin
  SetHeadValue('TR_CODE', ATRCode);
end;

// ---------------------------------------------------------------------------
// 해더의 Request ID 세팅
procedure CFNDataPackage.SetRequestID(ARequestID: String);
begin
  SetHeadValue('REQUEST_ID', ARequestID);
end;

// ---------------------------------------------------------------------------
// 해더의 COMPRESSED_RESPONSE 세팅
procedure CFNDataPackage.SetCompressedResponse(AValue: String);
begin
  SetHeadValue('COMPRESSED_RESPONSE', AValue);
end;

// ---------------------------------------------------------------------------
// 해더의 Message Code 세팅
procedure CFNDataPackage.SetMsgCode(AMessageCode: String);
begin
  SetHeadValue('MESSAGE_CODE', AMessageCode);
end;

// ---------------------------------------------------------------------------
// 해더의 Error Code 세팅
procedure CFNDataPackage.SetErrorCode(AErrorCode: String);
begin
  SetHeadValue('ERROR_CODE', AErrorCode);
end;

// ---------------------------------------------------------------------------
// 해더의 Service ID 리턴
function CFNDataPackage.GetServiceID: String;
begin
  Result := GetHeadValue('SERVICE_ID');
end;

// ---------------------------------------------------------------------------
// 해더의 TR Code 리턴
function CFNDataPackage.GetTRCode: String;
begin
  Result := GetHeadValue('TR_CODE');
end;

// ---------------------------------------------------------------------------
// 해더의 Request ID리턴
function CFNDataPackage.GetRequestID: String;
begin
  Result := GetHeadValue('REQUEST_ID');
end;

// ---------------------------------------------------------------------------
// 해더의 COMPRESSED_RESPONSE 리턴
function CFNDataPackage.GetCompressedResponse: String;
begin
  Result := GetHeadValue('COMPRESSED_RESPONSE');
end;

// ---------------------------------------------------------------------------
procedure CFNDataPackage.GetMessage(var p_Message: TFNServiceMessage);
begin
  if m_MessageDataSet.m_RecordList.Count > 0 then
  begin
    p_Message.CODE := CFNRecord(m_MessageDataSet.RecordList.Items[m_MessageDataSet.m_RecordList.Count - 1]).GetNameToStringValue('MESSAGE_CODE');
    p_Message.CONTENT := CFNRecord(m_MessageDataSet.RecordList.Items[m_MessageDataSet.m_RecordList.Count - 1]).GetNameToStringValue('MESSAGE');
  end
  else
  begin
    p_Message.CODE := '';
    p_Message.CONTENT := '';
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNDataPackage.GetErrorMessage(var p_Message: TFNServiceMessage);
begin
  if m_ErrorDataSet.m_RecordList.Count > 0 then
  begin
    p_Message.CODE := CFNRecord(m_ErrorDataSet.RecordList.Items[m_ErrorDataSet.m_RecordList.Count - 1]).GetNameToStringValue('ERROR_CODE');
    p_Message.CONTENT := CFNRecord(m_ErrorDataSet.RecordList.Items[m_ErrorDataSet.m_RecordList.Count - 1]).GetNameToStringValue('MESSAGE');
  end
  else
  begin
    p_Message.CODE := '';
    p_Message.CONTENT := '';
  end;
end;

// ---------------------------------------------------------------------------
// 해더의 Message Code 리턴
function CFNDataPackage.GetMsgCode: String;
begin
  Result := GetHeadValue('MESSAGE_CODE');
end;

// ---------------------------------------------------------------------------
// 해더의 Error Code 리턴
function CFNDataPackage.GetErrorCode: String;
begin
  Result := GetHeadValue('ERROR_CODE');
end;

// ---------------------------------------------------------------------------
function CFNDataPackage.WriteToXML: String;
var
  f_szXMLString: String;
  f_DataSet: CFNDataSet;
  f_nIndex: Integer;

  nLoop: Integer;
begin
  f_szXMLString := '<' + NODENAME_PACKET + '>' + #$0A;

  f_szXMLString := f_szXMLString + m_HeadDataSet.WriteToXML;

  for nLoop := 0 to 256 - 1 do
  begin
    f_nIndex := m_DataList.IndexOf('input' + IntToStr(nLoop));
    f_DataSet := NIL;
    if (0 <= f_nIndex) then
      f_DataSet := CFNDataSet(m_DataList.Objects[f_nIndex]);

    if Assigned(f_DataSet) then
    begin
      f_szXMLString := f_szXMLString + f_DataSet.WriteToXML;
    end;
  end;

  for nLoop := 0 to 256 - 1 do
  begin
    f_nIndex := m_DataList.IndexOf('output' + IntToStr(nLoop));
    f_DataSet := NIL;
    if (0 <= f_nIndex) then
      f_DataSet := CFNDataSet(m_DataList.Objects[f_nIndex]);

    if Assigned(f_DataSet) then
    begin
      f_szXMLString := f_szXMLString + f_DataSet.WriteToXML;
    end;
  end;

  if (0 < m_MessageDataSet.RecordList.Count) then
    f_szXMLString := f_szXMLString + m_MessageDataSet.WriteToXML;

  if (0 < m_ErrorDataSet.RecordList.Count) then
    f_szXMLString := f_szXMLString + m_ErrorDataSet.WriteToXML;

  f_szXMLString := f_szXMLString + '</' + NODENAME_PACKET + '>' + #$0A;

  Result := f_szXMLString;
end;

// ---------------------------------------------------------------------------
procedure CFNDataPackage.Clone(ASource: CFNDataPackage);
var
  f_DataSet: CFNDataSet;
  f_NewDataSet: CFNDataSet;
  f_nIndex: Integer;
  nLoop: Integer;
begin
  ClearAll;

  m_HeadDataSet.Clone(ASource.m_HeadDataSet);
  m_MessageDataSet.Clone(ASource.m_MessageDataSet);

  for nLoop := 0 to 256 - 1 do
  begin
    f_nIndex := ASource.m_DataList.IndexOf('input' + IntToStr(nLoop));
    f_DataSet := NIL;
    if (0 <= f_nIndex) then
      f_DataSet := CFNDataSet(ASource.m_DataList.Objects[f_nIndex]);

    if Assigned(f_DataSet) then
    begin
      f_NewDataSet := CFNDataSet.Create;
      f_NewDataSet.Clone(f_DataSet);
      m_DataList.AddObject(f_NewDataSet.Name, f_NewDataSet);
    end;
  end;

  for nLoop := 0 to 256 - 1 do
  begin
    f_nIndex := ASource.m_DataList.IndexOf('output' + IntToStr(nLoop));
    f_DataSet := NIL;
    if (0 <= f_nIndex) then
      f_DataSet := CFNDataSet(ASource.m_DataList.Objects[f_nIndex]);

    if Assigned(f_DataSet) then
    begin
      f_NewDataSet := CFNDataSet.Create;
      f_NewDataSet.Clone(f_DataSet);
      m_DataList.AddObject(f_NewDataSet.Name, f_NewDataSet);
    end;
  end;
end;

// ---------------------------------------------------------------------------
{ CFNStreamRecord }
procedure CFNStreamRecord.CloneStreamRecord(ASource: CFNStreamRecord);
begin
  Clone(ASource);
  m_Key := ASource.m_Key;
end;

// ---------------------------------------------------------------------------
constructor CFNStreamRecord.Create;
begin
  inherited Create;

  DeliveryType := dvtStream;

  m_Key := '';
  m_ReferenceCount := 0;
  m_ReferenceCountLock := TCriticalSection.Create;
end;

// ---------------------------------------------------------------------------
destructor CFNStreamRecord.Destroy;
begin
  m_ReferenceCount := 0;
  m_ReferenceCountLock.Free;
  inherited;
end;

// ---------------------------------------------------------------------------
procedure CFNStreamRecord.SetPacketKey(AKey: String);
begin
  m_Key := AKey;
end;

// ---------------------------------------------------------------------------
function CFNStreamRecord.GetPacketKey: String;
begin
  Result := m_Key;
end;

// ---------------------------------------------------------------------------
procedure CFNStreamRecord.DecreaseReferenceCount;
begin
  m_ReferenceCountLock.Enter;
  try
    Dec(m_ReferenceCount);
  finally
    m_ReferenceCountLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNStreamRecord.IncreaseReferenceCount;
begin
  m_ReferenceCountLock.Enter;
  try
    Inc(m_ReferenceCount);
  finally
    m_ReferenceCountLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
function CFNStreamRecord.GetReferenceCount: Integer;
begin
  m_ReferenceCountLock.Enter;
  try
    Result := m_ReferenceCount;
  finally
    m_ReferenceCountLock.Leave;
  end;
end;

end.
