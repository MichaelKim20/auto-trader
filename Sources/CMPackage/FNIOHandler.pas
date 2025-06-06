unit FNIOHandler;

interface

uses
  Contnrs, Dialogs, IniFiles, SysUtils, StrUtils, Math, Classes;

const
  FNIOVALUE_TYPE_INTEGER = 0;

const
  FNIOVALUE_TYPE_DOUBLE = 1;

const
  FNIOVALUE_TYPE_STRING = 2;

const
  FNIOVALUE_TYPE_BYTE = 3;

type
  CFNDynamicByteArray = Array of Byte;

  // ---------------------------------------------------------------------------
  CFNIOHead = class(TObject)
  public
    m_TrCode: String;
    m_MessageCode: String;
    m_MessageText: String;
  end;

  // ---------------------------------------------------------------------------
  // 레코드의 Cell 데이터
  CFNIOValue = class(TObject)
  protected
    m_Type: Integer;
    m_StringValue: String;
    m_DoubleValue: Double;
    m_IntegerValue: Integer;
    m_ByteValue: Byte;

    // 변수의 소수점자리수를 저장한다.
    m_Precision: Integer;

  public
    Constructor Create;
    Destructor Destroy; override;

    procedure SetType(AType: Integer);
    function GetType: Integer;

    function GetPrecision: Integer;
    procedure SetPrecision(AValue: Integer);

    procedure SetStringValue(AValue: String);
    function GetStringValue: String;

    procedure SetDoubleValue(AValue: Double);
    function GetDoubleValue: Double;

    procedure SetIntegerValue(AValue: Integer);
    function GetIntegerValue: Integer;

    procedure SetByteValue(AValue: Byte);
    function GetByteValue: Byte;

    property DataType: Integer read GetType write SetType;
    property IntegerValue: Integer read GetIntegerValue write SetIntegerValue;
    property DoubleValue: Double read GetDoubleValue write SetDoubleValue;
    property StringValue: String read GetStringValue write SetStringValue;
    property ByteValue: Byte read GetByteValue write SetByteValue;
    property Precision: Integer read GetPrecision write SetPrecision;
  end;

  CFNIOFieldInfo = class(TObject)
  protected
    m_Name: String;
    m_Size: Integer;
    m_Precision: Integer;
    m_DataType: Integer;

  public
    Constructor Create;
    Destructor Destroy; override;

    property Name: String read m_Name write m_Name;
    property Size: Integer read m_Size write m_Size;
    property Precision: Integer read m_Precision write m_Precision;
    property DataType: Integer read m_DataType write m_DataType;
  end;

  // ---------------------------------------------------------------------------
  // 레코드 Row 데이터
  CFNIORecord = class(TObject)
  protected
    m_FieldValues: THashedStringList;

  public
    Constructor Create;
    Destructor Destroy; override;

    procedure ClearAll;

    procedure AddStringValue(AName: String; AValue: String);
    procedure SetStringValue(AName: String; AValue: String);

    procedure AddDoubleValue(AName: String; AValue: Double);
    procedure SetDoubleValue(AName: String; AValue: Double);

    procedure AddIntegerValue(AName: String; AValue: Integer);
    procedure SetIntegerValue(AName: String; AValue: Integer);

    procedure AddByteValue(AName: String; AValue: Byte);
    procedure SetByteValue(AName: String; AValue: Byte);

    function GetNameToStringValue(AName: String): String;
    function GetIndexToStringValue(AIndex: Integer): String;

    function GetNameToDoubleValue(AName: String): Double;
    function GetIndexToDoubleValue(AIndex: Integer): Double;

    function GetNameToIntegerValue(AName: String): Integer;
    function GetIndexToIntegerValue(AIndex: Integer): Integer;

    function GetNameToByteValue(AName: String): Byte;
    function GetIndexToByteValue(AIndex: Integer): Byte;

    // 정수형 값을 리턴한다.
    function GetIntegerValue(AName: String): Integer;

    // 정수형 값을 리턴한다.
    function GetDoubleValue(AName: String): Double;

    // 문자형 값을 리턴한다.
    function GetStringValue(AName: String): String;

    // Byte 값을 리턴한다.
    function GetByteValue(AName: String): Byte;

    procedure CopyFieldValues(srcFieldValues: THashedStringList);

    property FieldValues: THashedStringList read m_FieldValues write m_FieldValues;
  end;

  // ---------------------------------------------------------------------------
  // 데이터 셋
  CFNIODataSet = class(TObject)
  protected
    m_Name: String;
    m_FildInfo: THashedStringList;
    m_RecordList: TObjectList;

    m_FixedRecordCount: Integer;
    m_RecordCountWidth: Integer;

  public
    Constructor Create(AFixedRecordCount: Integer = 1; ALength: Integer = 0);
    Destructor Destroy; override;

    procedure ClearAll;
    procedure ClearFieldInfo;
    procedure ClearRecordList;
    procedure ClearData;

    function AddFieldInfo(AFieldName: String; ASize: Integer; APrecision: Integer; AType: Integer): CFNIOFieldInfo;
    function FindFieldInfo(AFieldName: String): CFNIOFieldInfo;

    procedure CloneRecord(var ARecordList: TList);

    procedure Clone(ASource: CFNIODataSet);

    function GetRecordSize: Integer;

    procedure WriteInteger(ADataStream: TStringStream; AValue: Integer; ASize: Integer; APrecision: Integer = 0);
    procedure WriteDouble(ADataStream: TStringStream; AValue: Double; ASize: Integer; APrecision: Integer = 0);
    procedure WriteString(ADataStream: TStringStream; AValue: String; ASize: Integer; APrecision: Integer = 0);

    procedure WriteByteByte(ADataStream: TMemoryStream; AValue: Byte; ASize: Integer; APrecision: Integer = 0);
    procedure WriteIntegerByte(ADataStream: TMemoryStream; AValue: Integer; ASize: Integer; APrecision: Integer = 0);
    procedure WriteDoubleByte(ADataStream: TMemoryStream; AValue: Double; ASize: Integer; APrecision: Integer = 0);
    procedure WriteStringByte(ADataStream: TMemoryStream; AValue: String; ASize: Integer; APrecision: Integer = 0);

    function EncodeData(ADataStream: TStringStream): TStringStream;
    procedure DecodeData(ADataStream: TStringStream);

    function EncodeDataToByte(ADataStream: TMemoryStream): TMemoryStream;

    property Name: String read m_Name write m_Name;
    property Field: THashedStringList read m_FildInfo write m_FildInfo;
    property RecordList: TObjectList read m_RecordList write m_RecordList;
    property FixedRecordCount: Integer read m_FixedRecordCount write m_FixedRecordCount;
  end;

  // ---------------------------------------------------------------------------
  CFNIOHandler = class(TObject)
  public
    m_Head: CFNIOHead;
    m_DataSetList: TObjectList;
    m_SourceStream: TStringStream;

  public
    Constructor Create;
    Destructor Destroy; override;
    procedure ClearAll;
    procedure ClearData;
    procedure ClearIODataSet;
    function GetDataSetRecord(ADataSetIndex, ARecordIndex: Integer): CFNIORecord;
    procedure SetSourceData(ADataStream: TStringStream);

    procedure EncodeData(var ADataStream: TStringStream);
    function DecodeData: Boolean;
    procedure EncodeDataToByte(var ADataStream: TMemoryStream);
  end;

implementation

uses FNGlobal;

{$REGION 'CFNIOHead'}
{$ENDREGION}
{$REGION 'CFNIOValue'}

// ---------------------------------------------------------------------------
Constructor CFNIOValue.Create;
begin
  // inherited Create;

  m_Type := FNIOVALUE_TYPE_STRING;
  m_IntegerValue := 0;
  m_DoubleValue := 0;
  m_StringValue := '';
  m_Precision := 0;
end;

// ---------------------------------------------------------------------------
Destructor CFNIOValue.Destroy;
begin
  inherited Destroy;
end;

procedure CFNIOValue.SetPrecision(AValue: Integer);
begin
  m_Precision := AValue;
end;

procedure CFNIOValue.SetType(AType: Integer);
begin
  m_Type := AType;
end;

function CFNIOValue.GetPrecision: Integer;
begin
  result := m_Precision;
end;

function CFNIOValue.GetType: Integer;
begin
  result := m_Type;
end;

// ---------------------------------------------------------------------------
// String
procedure CFNIOValue.SetStringValue(AValue: String);
begin
  m_Type := FNIOVALUE_TYPE_STRING;
  m_StringValue := AValue;
  m_DoubleValue := 0;
  m_IntegerValue := 0;
end;

// ---------------------------------------------------------------------------
// Double
procedure CFNIOValue.SetDoubleValue(AValue: Double);
begin
  m_Type := FNIOVALUE_TYPE_DOUBLE;
  m_DoubleValue := AValue;
  m_IntegerValue := floor(AValue);
  m_StringValue := FloatToStr(AValue);
end;

// ---------------------------------------------------------------------------
// Integer
procedure CFNIOValue.SetIntegerValue(AValue: Integer);
begin
  m_Type := FNIOVALUE_TYPE_INTEGER;
  m_IntegerValue := AValue;
  m_DoubleValue := AValue;
  m_StringValue := IntToStr(AValue);
end;

// ---------------------------------------------------------------------------
// Byte
procedure CFNIOValue.SetByteValue(AValue: Byte);
begin
  m_Type := FNIOVALUE_TYPE_BYTE;
  m_ByteValue := AValue;
end;

// ---------------------------------------------------------------------------
// String Get
function CFNIOValue.GetStringValue: String;
begin
  result := m_StringValue;
end;

// ---------------------------------------------------------------------------
// Double Get
function CFNIOValue.GetDoubleValue: Double;
begin
  result := m_DoubleValue;
end;

// ---------------------------------------------------------------------------
// Integer Get
function CFNIOValue.GetIntegerValue: Integer;
begin
  result := m_IntegerValue;
end;

// ---------------------------------------------------------------------------
// Byte Get
function CFNIOValue.GetByteValue: Byte;
begin
  result := m_ByteValue;
end;

{$ENDREGION}
{$REGION 'CFNIOFieldInfo'}

// ---------------------------------------------------------------------------
Constructor CFNIOFieldInfo.Create;
begin
  // inherited Create;
  m_Name := '';
  m_Size := 0;
  m_Precision := 0;
  m_DataType := FNIOVALUE_TYPE_STRING;
end;

// ---------------------------------------------------------------------------
Destructor CFNIOFieldInfo.Destroy;
begin
  inherited Destroy;
end;
{$ENDREGION}
{$REGION 'CFNIORecord'}

// ---------------------------------------------------------------------------
Constructor CFNIORecord.Create;
begin
  // inherited Create;

  m_FieldValues := THashedStringList.Create;
end;

// ---------------------------------------------------------------------------
Destructor CFNIORecord.Destroy;
begin
  ClearAll;
  if m_FieldValues <> NIL then
    m_FieldValues.Free;
  m_FieldValues := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 레코드 데이터 전체 삭제한다.
procedure CFNIORecord.ClearAll;
begin
  while 0 < m_FieldValues.Count do
  begin
    CFNIOValue(m_FieldValues.Objects[0]).Destroy;
    m_FieldValues.Delete(0);
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(Integer)
procedure CFNIORecord.AddIntegerValue(AName: String; AValue: Integer);
var
  strObj: CFNIOValue;
begin
  if 0 < Length(AName) then
  begin
    strObj := CFNIOValue.Create;
    strObj.SetIntegerValue(AValue);
    m_FieldValues.AddObject(AName, strObj);
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(Byte)
procedure CFNIORecord.AddByteValue(AName: String; AValue: Byte);
var
  strObj: CFNIOValue;
begin
  if 0 < Length(AName) then
  begin
    strObj := CFNIOValue.Create;
    strObj.SetByteValue(AValue);
    m_FieldValues.AddObject(AName, strObj);
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(Double)
procedure CFNIORecord.AddDoubleValue(AName: String; AValue: Double);
var
  strObj: CFNIOValue;
begin
  if 0 < Length(AName) then
  begin
    strObj := CFNIOValue.Create;
    strObj.SetDoubleValue(AValue);
    m_FieldValues.AddObject(AName, strObj);
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(String)
procedure CFNIORecord.AddStringValue(AName: String; AValue: String);
var
  strObj: CFNIOValue;
begin
  if 0 < Length(AName) then
  begin
    strObj := CFNIOValue.Create;
    strObj.SetStringValue(AValue);
    m_FieldValues.AddObject(AName, strObj);
  end;
end;

// ---------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(Integer)
procedure CFNIORecord.SetIntegerValue(AName: String; AValue: Integer);
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if 0 <= AIndex then
    begin
      CFNIOValue(m_FieldValues.Objects[AIndex]).SetIntegerValue(AValue);
    end
    else
    begin
      AddIntegerValue(AName, AValue);
    end;
  end;
end;

// ---------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(Byte)
procedure CFNIORecord.SetByteValue(AName: String; AValue: Byte);
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if 0 <= AIndex then
    begin
      CFNIOValue(m_FieldValues.Objects[AIndex]).SetByteValue(AValue);
    end
    else
    begin
      AddByteValue(AName, AValue);
    end;
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(Double)
procedure CFNIORecord.SetDoubleValue(AName: String; AValue: Double);
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if 0 <= AIndex then
    begin
      CFNIOValue(m_FieldValues.Objects[AIndex]).SetDoubleValue(AValue);
    end
    else
    begin
      AddDoubleValue(AName, AValue);
    end;
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(String)
procedure CFNIORecord.SetStringValue(AName: String; AValue: String);
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if 0 <= AIndex then
    begin
      CFNIOValue(m_FieldValues.Objects[AIndex]).SetStringValue(AValue);
    end
    else
    begin
      AddStringValue(AName, AValue);
    end;
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 필드 명으로 해당 레코드의 Cell value 값을 리턴한다.(Integer)
function CFNIORecord.GetNameToIntegerValue(AName: String): Integer;
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
    begin
      result := CFNIOValue(m_FieldValues.Objects[AIndex]).GetIntegerValue;
    end
    else
    begin
      result := 0;
    end;
  end
  else
  begin
    result := 0;
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 필드 명으로 해당 레코드의 Cell value 값을 리턴한다.(Byte)
function CFNIORecord.GetNameToByteValue(AName: String): Byte;
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
    begin
      result := CFNIOValue(m_FieldValues.Objects[AIndex]).GetByteValue;
    end
    else
    begin
      result := 0;
    end;
  end
  else
  begin
    result := 0;
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 필드 명으로 해당 레코드의 Cell value 값을 리턴한다.(Double)
function CFNIORecord.GetNameToDoubleValue(AName: String): Double;
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
    begin
      result := CFNIOValue(m_FieldValues.Objects[AIndex]).GetDoubleValue;
    end
    else
    begin
      result := 0;
    end;
  end
  else
  begin
    result := 0;
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 필드 명으로 해당 레코드의 Cell value 값을 리턴한다.
function CFNIORecord.GetNameToStringValue(AName: String): String;
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
    begin
      result := CFNIOValue(m_FieldValues.Objects[AIndex]).GetStringValue;
    end
    else
    begin
      result := '';
    end;
  end
  else
  begin
    result := '';
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 인덱스로 해당 레코드의 Cell value 값을 리턴한다.(Integer)
function CFNIORecord.GetIndexToIntegerValue(AIndex: Integer): Integer;
begin
  if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
  begin
    result := CFNIOValue(m_FieldValues.Objects[AIndex]).GetIntegerValue;
  end
  else
  begin
    result := 0;
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 인덱스로 해당 레코드의 Cell value 값을 리턴한다.(Byte)
function CFNIORecord.GetIndexToByteValue(AIndex: Integer): Byte;
begin
  if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
  begin
    result := CFNIOValue(m_FieldValues.Objects[AIndex]).GetByteValue;
  end
  else
  begin
    result := 0;
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 인덱스로 해당 레코드의 Cell value 값을 리턴한다.(Double)
function CFNIORecord.GetIndexToDoubleValue(AIndex: Integer): Double;
begin
  if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
  begin
    result := CFNIOValue(m_FieldValues.Objects[AIndex]).GetDoubleValue;
  end
  else
  begin
    result := 0;
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 인덱스로 해당 레코드의 Cell value 값을 리턴한다.(String)
function CFNIORecord.GetIndexToStringValue(AIndex: Integer): String;
var
  strReturn: String;
begin
  strReturn := '';

  if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
  begin
    strReturn := CFNIOValue(m_FieldValues.Objects[AIndex]).GetStringValue;
  end;

  result := strReturn;
end;

// ------------------------------------------------------------------------
function CFNIORecord.GetIntegerValue(AName: String): Integer;
begin
  result := GetNameToIntegerValue(AName);
end;

// ------------------------------------------------------------------------
function CFNIORecord.GetByteValue(AName: String): Byte;
begin
  result := GetNameToByteValue(AName);
end;

// ------------------------------------------------------------------------
function CFNIORecord.GetDoubleValue(AName: String): Double;
begin
  result := GetNameToDoubleValue(AName);
end;

// ------------------------------------------------------------------------
function CFNIORecord.GetStringValue(AName: String): String;
begin
  result := GetNameToStringValue(AName);
end;

// ------------------------------------------------------------------------
// Row의 FieldValues의 내용을 복사한다.
procedure CFNIORecord.CopyFieldValues(srcFieldValues: THashedStringList);
var
  nLoop: Integer;

  strObject: CFNIOValue;
  newStrObj: CFNIOValue;
begin
  ClearAll;

  for nLoop := 0 to srcFieldValues.Count - 1 do
  begin
    strObject := CFNIOValue(srcFieldValues.Objects[nLoop]);

    newStrObj := CFNIOValue.Create;
    if (FNIOVALUE_TYPE_DOUBLE = strObject.m_Type) then
    begin
      newStrObj.SetDoubleValue(strObject.GetDoubleValue)
    end
    else if (FNIOVALUE_TYPE_INTEGER = strObject.m_Type) then
    begin
      newStrObj.SetIntegerValue(strObject.GetIntegerValue)
    end
    else if (FNIOVALUE_TYPE_BYTE = strObject.m_Type) then
    begin
      newStrObj.SetByteValue(strObject.GetByteValue)
    end
    else
    begin
      newStrObj.SetStringValue(strObject.GetStringValue);
    end;

    m_FieldValues.AddObject(srcFieldValues.Strings[nLoop], newStrObj);
  end;
end;
{$ENDREGION}
{$REGION 'CFNIODataSet'}

// ---------------------------------------------------------------------------
Constructor CFNIODataSet.Create(AFixedRecordCount: Integer = 1; ALength: Integer = 0);
begin
  // inherited Create;
  m_Name := '';
  m_FildInfo := THashedStringList.Create;
  m_RecordList := TObjectList.Create;
  m_FixedRecordCount := AFixedRecordCount;
  m_RecordCountWidth := ALength;
end;

// ---------------------------------------------------------------------------
Destructor CFNIODataSet.Destroy;
begin
  m_Name := '';
  ClearAll;

  if m_FildInfo <> NIL then
    m_FildInfo.Free;
  m_FildInfo := NIL;

  if m_RecordList <> NIL then
    m_RecordList.Free;
  m_RecordList := NIL;

  inherited;
end;

// ---------------------------------------------------------------------------
// 데이터셋의 필드, 레코드 내용을 전체 삭제한다.
procedure CFNIODataSet.ClearAll;
begin
  // Field
  ClearFieldInfo;

  // Record
  ClearRecordList;
end;

procedure CFNIODataSet.ClearData;
begin
  ClearRecordList;
end;

// ---------------------------------------------------------------------------
// 데이터셋의 필드 정보를 모두 삭제한다.
procedure CFNIODataSet.ClearFieldInfo;
begin
  // Field
  while 0 < m_FildInfo.Count do
  begin
    CFNIOFieldInfo(m_FildInfo.Objects[0]).Free;
    m_FildInfo.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 데이터셋의 레코드 정보를 모두 삭제한다.
procedure CFNIODataSet.ClearRecordList;
begin
  while 0 < m_RecordList.Count do
  begin
    // CFNIORecord(m_RecordList.Items[0]).Destroy;
    m_RecordList.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 데이터셋의 필드를 추가한다.
function CFNIODataSet.AddFieldInfo(AFieldName: String; ASize: Integer; APrecision: Integer; AType: Integer): CFNIOFieldInfo;
var
  f_FieldInfo: CFNIOFieldInfo;
begin
  f_FieldInfo := FindFieldInfo(AFieldName);
  if NIL = f_FieldInfo then
  begin
    f_FieldInfo := CFNIOFieldInfo.Create;
    f_FieldInfo.Name := AFieldName;
    f_FieldInfo.Size := ASize;
    f_FieldInfo.Precision := APrecision;
    f_FieldInfo.DataType := AType;
    m_FildInfo.AddObject(f_FieldInfo.Name, f_FieldInfo);
  end
  else
  begin
    f_FieldInfo.Name := AFieldName;
    f_FieldInfo.Size := ASize;
    f_FieldInfo.Precision := APrecision;
    f_FieldInfo.DataType := AType;
  end;

  result := f_FieldInfo;
end;

// ---------------------------------------------------------------------------
// 필드명으로 필드 상세정보를 리턴한다.
function CFNIODataSet.FindFieldInfo(AFieldName: String): CFNIOFieldInfo;
var
  f_FieldInfo: CFNIOFieldInfo;
  f_Index: Integer;
begin
  f_FieldInfo := NIL;

  if 0 < Length(AFieldName) then
  begin
    f_Index := m_FildInfo.IndexOf(AFieldName);
    if 0 <= f_Index then
    begin
      f_FieldInfo := CFNIOFieldInfo(m_FildInfo.Objects[f_Index]);
    end;
  end;

  result := f_FieldInfo;
end;

procedure CFNIODataSet.WriteInteger(ADataStream: TStringStream; AValue, ASize: Integer; APrecision: Integer);
var
  f_Source: String;
begin
  f_Source := Format('%*d', [ASize, AValue]);
  ADataStream.WriteString(f_Source);
end;

procedure CFNIODataSet.WriteDouble(ADataStream: TStringStream; AValue: Double; ASize: Integer; APrecision: Integer);
var
  f_Source: String;
begin
  f_Source := Format('%*.*f', [ASize, APrecision, AValue]);
  ADataStream.WriteString(f_Source);
end;

procedure CFNIODataSet.WriteString(ADataStream: TStringStream; AValue: String; ASize: Integer; APrecision: Integer);
var
  f_Source: String;
begin
  f_Source := Format('%-*s', [ASize, AValue]);
  ADataStream.WriteString(f_Source);
end;

// ---------------------------------------------------------------------------
procedure CFNIODataSet.WriteByteByte(ADataStream: TMemoryStream; AValue: Byte; ASize: Integer; APrecision: Integer);
begin
  ADataStream.WriteBuffer(AValue, 1);
end;

// ---------------------------------------------------------------------------
procedure CFNIODataSet.WriteIntegerByte(ADataStream: TMemoryStream; AValue, ASize: Integer; APrecision: Integer);
var
  LSource: String;
  LBuffer: Array [0 .. 512] of AnsiChar;
begin
  LSource := Format('%*d', [ASize, AValue]);
  StrPCopy(LBuffer, LSource);
  ADataStream.WriteBuffer(LBuffer, Length(LSource));
end;

// ---------------------------------------------------------------------------
procedure CFNIODataSet.WriteDoubleByte(ADataStream: TMemoryStream; AValue: Double; ASize: Integer; APrecision: Integer);
var
  LSource: String;
  LBuffer: Array [0 .. 512] of AnsiChar;
begin
  LSource := Format('%*.*f', [ASize, APrecision, AValue]);
  StrPCopy(LBuffer, LSource);
  ADataStream.WriteBuffer(LBuffer, Length(LSource));
end;

// ---------------------------------------------------------------------------
procedure CFNIODataSet.WriteStringByte(ADataStream: TMemoryStream; AValue: String; ASize: Integer; APrecision: Integer);
var
  LSource: String;
  LBuffer: Array [0 .. 512] of AnsiChar;
begin
  LSource := Format('%-*s', [ASize, AValue]);
  StrPCopy(LBuffer, LSource);
  ADataStream.WriteBuffer(LBuffer, Length(LSource));
end;

// ---------------------------------------------------------------------------
// 레코드 데이터를 TList로 복사한다.
procedure CFNIODataSet.CloneRecord(var ARecordList: TList);
var
  f_Index: Integer;

  f_OldRecord: CFNIORecord;
  f_NewRecord: CFNIORecord;
begin
  while 0 < ARecordList.Count do
  begin
    CFNIORecord(ARecordList.Items[0]).Destroy;
    ARecordList.Delete(0);
  end;

  for f_Index := 0 to m_RecordList.Count - 1 do
  begin
    f_OldRecord := CFNIORecord(m_RecordList.Items[f_Index]);

    f_NewRecord := CFNIORecord.Create;
    f_NewRecord.CopyFieldValues(f_OldRecord.FieldValues);

    ARecordList.Add(f_NewRecord);
  end;

end;

// ---------------------------------------------------------------------------
procedure CFNIODataSet.Clone(ASource: CFNIODataSet);
var
  f_RecordIndex: Integer;
  f_FieldIndex: Integer;
  f_FieldInfo: CFNIOFieldInfo;
  f_OldRecord: CFNIORecord;
  f_NewRecord: CFNIORecord;
begin
  ClearAll;

  m_Name := ASource.m_Name;

  for f_FieldIndex := 0 to ASource.m_FildInfo.Count - 1 do
  begin
    f_FieldInfo := CFNIOFieldInfo(ASource.m_FildInfo.Objects[f_FieldIndex]);
    if Assigned(f_FieldInfo) then
    begin
      AddFieldInfo(f_FieldInfo.Name, f_FieldInfo.Size, f_FieldInfo.Precision, f_FieldInfo.DataType);
    end;
  end;

  for f_RecordIndex := 0 to ASource.m_RecordList.Count - 1 do
  begin
    f_OldRecord := CFNIORecord(ASource.m_RecordList.Items[f_RecordIndex]);
    f_NewRecord := CFNIORecord.Create;

    f_NewRecord.CopyFieldValues(f_OldRecord.FieldValues);

    m_RecordList.Add(f_NewRecord);
  end;
end;

// ---------------------------------------------------------------------------
function CFNIODataSet.GetRecordSize: Integer;
var
  f_Size: Integer;
  f_FieldIndex: Integer;
  f_FieldInfo: CFNIOFieldInfo;
begin
  f_Size := 0;
  for f_FieldIndex := 0 to m_FildInfo.Count - 1 do
  begin
    f_FieldInfo := CFNIOFieldInfo(m_FildInfo.Objects[f_FieldIndex]);
    if Assigned(f_FieldInfo) then
    begin
      f_Size := f_Size + f_FieldInfo.Size;
    end;
  end;
  result := f_Size;
end;

// ---------------------------------------------------------------------------
function CFNIODataSet.EncodeData(ADataStream: TStringStream): TStringStream;
var
  f_FieldInfo: CFNIOFieldInfo;
  f_Record: CFNIORecord;
  f_FieldIndex: Integer;
  f_RecordIndex: Integer;

  f_RecordCount: Integer;
begin
  // 고정 레코드 갯수 이면
  if (m_FixedRecordCount <> 0) then
  begin
    f_RecordCount := m_FixedRecordCount;
  end
  else
  begin
    f_RecordCount := m_RecordList.Count;
    WriteInteger(ADataStream, f_RecordCount, m_RecordCountWidth);
  end;

  for f_RecordIndex := 0 to f_RecordCount - 1 do
  begin
    if (f_RecordIndex < m_RecordList.Count) then
    begin
      f_Record := CFNIORecord(m_RecordList.Items[f_RecordIndex]);
      for f_FieldIndex := 0 to m_FildInfo.Count - 1 do
      begin
        f_FieldInfo := CFNIOFieldInfo(m_FildInfo.Objects[f_FieldIndex]);

        if not Assigned(f_FieldInfo) then
          continue;

        if FNIOVALUE_TYPE_DOUBLE = f_FieldInfo.DataType then
        begin
          WriteDouble(ADataStream, f_Record.GetDoubleValue(f_FieldInfo.Name), f_FieldInfo.Size, f_FieldInfo.m_Precision);
        end
        else if FNIOVALUE_TYPE_INTEGER = f_FieldInfo.DataType then
        begin
          WriteInteger(ADataStream, f_Record.GetIntegerValue(f_FieldInfo.Name), f_FieldInfo.Size);
        end
        else
        begin
          WriteString(ADataStream, f_Record.GetStringValue(f_FieldInfo.Name), f_FieldInfo.Size);
        end;

      end;
    end
    else
    begin
      for f_FieldIndex := 0 to m_FildInfo.Count - 1 do
      begin
        f_FieldInfo := CFNIOFieldInfo(m_FildInfo.Objects[f_FieldIndex]);

        if not Assigned(f_FieldInfo) then
          continue;

        if FNIOVALUE_TYPE_DOUBLE = f_FieldInfo.DataType then
        begin
          WriteDouble(ADataStream, 0, f_FieldInfo.Size, f_FieldInfo.m_Precision);
        end
        else if FNIOVALUE_TYPE_INTEGER = f_FieldInfo.DataType then
        begin
          WriteInteger(ADataStream, 0, f_FieldInfo.Size);
        end
        else
        begin
          WriteString(ADataStream, '', f_FieldInfo.Size);
        end;

      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
function CFNIODataSet.EncodeDataToByte(ADataStream: TMemoryStream): TMemoryStream;
var
  f_FieldInfo: CFNIOFieldInfo;
  f_Record: CFNIORecord;
  f_FieldIndex: Integer;
  f_RecordIndex: Integer;

  f_RecordCount: Integer;
begin
  // 고정 레코드 갯수 이면
  if (m_FixedRecordCount <> 0) then
  begin
    f_RecordCount := m_FixedRecordCount;
  end
  else
  begin
    f_RecordCount := m_RecordList.Count;
    WriteIntegerByte(ADataStream, f_RecordCount, m_RecordCountWidth);
  end;

  for f_RecordIndex := 0 to f_RecordCount - 1 do
  begin
    if (f_RecordIndex < m_RecordList.Count) then
    begin
      f_Record := CFNIORecord(m_RecordList.Items[f_RecordIndex]);
      for f_FieldIndex := 0 to m_FildInfo.Count - 1 do
      begin
        f_FieldInfo := CFNIOFieldInfo(m_FildInfo.Objects[f_FieldIndex]);

        if not Assigned(f_FieldInfo) then
          continue;

        if FNIOVALUE_TYPE_DOUBLE = f_FieldInfo.DataType then
        begin
          WriteDoubleByte(ADataStream, f_Record.GetDoubleValue(f_FieldInfo.Name), f_FieldInfo.Size, f_FieldInfo.m_Precision);
        end
        else if FNIOVALUE_TYPE_INTEGER = f_FieldInfo.DataType then
        begin
          WriteIntegerByte(ADataStream, f_Record.GetIntegerValue(f_FieldInfo.Name), f_FieldInfo.Size);
        end
        else if FNIOVALUE_TYPE_BYTE = f_FieldInfo.DataType then
        begin
          WriteByteByte(ADataStream, f_Record.GetByteValue(f_FieldInfo.Name), f_FieldInfo.Size);
        end
        else
        begin
          WriteStringByte(ADataStream, f_Record.GetStringValue(f_FieldInfo.Name), f_FieldInfo.Size);
        end;

      end;
    end
    else
    begin
      for f_FieldIndex := 0 to m_FildInfo.Count - 1 do
      begin
        f_FieldInfo := CFNIOFieldInfo(m_FildInfo.Objects[f_FieldIndex]);

        if not Assigned(f_FieldInfo) then
          continue;

        if FNIOVALUE_TYPE_DOUBLE = f_FieldInfo.DataType then
        begin
          WriteDoubleByte(ADataStream, 0, f_FieldInfo.Size, f_FieldInfo.m_Precision);
        end
        else if FNIOVALUE_TYPE_INTEGER = f_FieldInfo.DataType then
        begin
          WriteIntegerByte(ADataStream, 0, f_FieldInfo.Size);
        end
        else if FNIOVALUE_TYPE_BYTE = f_FieldInfo.DataType then
        begin
          WriteByteByte(ADataStream, 0, f_FieldInfo.Size);
        end
        else
        begin
          WriteStringByte(ADataStream, '', f_FieldInfo.Size);
        end;

      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNIODataSet.DecodeData(ADataStream: TStringStream);
var
  f_FieldInfo: CFNIOFieldInfo;
  f_Record: CFNIORecord;
  f_FieldIndex: Integer;
  f_RecordIndex: Integer;
  f_FieldString: String;
  f_RecordCount: Integer;
  f_RecordSize: Integer;

  f_Buffer: Array [0 .. 1024] of AnsiChar;
  f_nValue: Integer;
  f_dValue: Double;
begin
  if m_FixedRecordCount <> 0 then
  begin
    f_RecordCount := m_FixedRecordCount;
  end
  else
  begin
    if m_RecordCountWidth <> 0 then
    begin
      if ADataStream.Position + m_RecordCountWidth <= ADataStream.Size then
      begin
        ADataStream.Read(f_Buffer, m_RecordCountWidth);
        f_Buffer[m_RecordCountWidth] := #$00;
        f_FieldString := Trim(StrPas(f_Buffer));
        f_RecordCount := TFNGlobal.atoi(f_FieldString);
      end
      else
      begin
        ADataStream.Position := ADataStream.Size;
        f_RecordCount := 0;
      end;
    end
    else
    begin
      f_RecordSize := GetRecordSize;
      if f_RecordSize <> 0 then
      begin
        f_RecordCount := Math.Ceil((ADataStream.Size - ADataStream.Position) / f_RecordSize);
      end
      else
      begin
        f_RecordCount := 1;
      end;
    end;
  end;

  for f_RecordIndex := 0 to f_RecordCount - 1 do
  begin
    f_Record := CFNIORecord.Create;
    for f_FieldIndex := 0 to m_FildInfo.Count - 1 do
    begin
      f_FieldInfo := CFNIOFieldInfo(m_FildInfo.Objects[f_FieldIndex]);
      if not Assigned(f_FieldInfo) then
        continue;

      if ADataStream.Position + f_FieldInfo.m_Size <= ADataStream.Size then
      begin
        ADataStream.Read(f_Buffer, f_FieldInfo.m_Size);
        f_Buffer[f_FieldInfo.m_Size] := #$00;
        f_FieldString := Trim(StrPas(f_Buffer));
      end
      else
      begin
        f_FieldString := '';
        ADataStream.Position := ADataStream.Size;
      end;

      if (FNIOVALUE_TYPE_INTEGER = f_FieldInfo.DataType) then
      begin
        f_nValue := TFNGlobal.atoi(f_FieldString);
        f_Record.AddIntegerValue(f_FieldInfo.Name, f_nValue);
      end
      else if (FNIOVALUE_TYPE_DOUBLE = f_FieldInfo.DataType) then
      begin
        f_dValue := TFNGlobal.atof(f_FieldString);
        f_Record.AddDoubleValue(f_FieldInfo.Name, f_dValue);
      end
      else
      begin
        f_Record.AddStringValue(f_FieldInfo.Name, Trim(f_FieldString));
      end;
    end;
    m_RecordList.Add(f_Record);
  end;
end;

{$ENDREGION}
{$REGION 'CFNIOHandler'}

// ---------------------------------------------------------------------------
constructor CFNIOHandler.Create;
begin
  inherited Create;
  m_Head := CFNIOHead.Create;
  m_DataSetList := TObjectList.Create;
  m_SourceStream := TStringStream.Create;
end;

// ---------------------------------------------------------------------------
destructor CFNIOHandler.Destroy;
begin
  ClearAll;

  if m_Head <> NIL then
    m_Head.Free;
  m_Head := NIL;

  if m_DataSetList <> NIL then
    m_DataSetList.Free;
  m_DataSetList := NIL;

  if m_SourceStream <> NIL then
    m_SourceStream.Free;
  m_SourceStream := NIL;

  inherited;
end;

// ---------------------------------------------------------------------------
procedure CFNIOHandler.EncodeData(var ADataStream: TStringStream);
var
  f_Index: Integer;
  f_DataSet: CFNIODataSet;
begin
  for f_Index := 0 to m_DataSetList.Count - 1 do
  begin
    f_DataSet := m_DataSetList.Items[f_Index] as CFNIODataSet;
    if Assigned(f_DataSet) then
      f_DataSet.EncodeData(ADataStream);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNIOHandler.EncodeDataToByte(var ADataStream: TMemoryStream);
var
  f_Index: Integer;
  f_DataSet: CFNIODataSet;
begin
  for f_Index := 0 to m_DataSetList.Count - 1 do
  begin
    f_DataSet := m_DataSetList.Items[f_Index] as CFNIODataSet;
    if Assigned(f_DataSet) then
      f_DataSet.EncodeDataToByte(ADataStream);
  end;
end;

// ---------------------------------------------------------------------------
function CFNIOHandler.DecodeData: Boolean;
var
  f_Index: Integer;
  f_DataSet: CFNIODataSet;
begin
  result := true;
  ClearData;
  m_SourceStream.Position := 0;
  for f_Index := 0 to m_DataSetList.Count - 1 do
  begin
    f_DataSet := m_DataSetList.Items[f_Index] as CFNIODataSet;
    if Assigned(f_DataSet) then
    begin
      if (m_SourceStream.Position < m_SourceStream.Size - 1) then
      begin
        f_DataSet.DecodeData(m_SourceStream);
      end
      else
      begin
        result := false;
        break;
      end;
    end;
  end;
  m_SourceStream.Position := 0;
end;

// ---------------------------------------------------------------------------
function CFNIOHandler.GetDataSetRecord(ADataSetIndex, ARecordIndex: Integer): CFNIORecord;
var
  f_DataSet: CFNIODataSet;
begin
  result := NIL;

  if (ADataSetIndex < 0) then
    exit;
  if (ADataSetIndex >= m_DataSetList.Count) then
    exit;

  f_DataSet := m_DataSetList.Items[ADataSetIndex] as CFNIODataSet;
  if not Assigned(f_DataSet) then
    exit;

  if (ARecordIndex >= f_DataSet.RecordList.Count) then
    exit;

  result := f_DataSet.RecordList.Items[ARecordIndex] as CFNIORecord;
end;

// ---------------------------------------------------------------------------
procedure CFNIOHandler.SetSourceData(ADataStream: TStringStream);
begin
  m_SourceStream.Clear;
  ADataStream.Position := 0;
  m_SourceStream.WriteString(ADataStream.ReadString(ADataStream.Size));
  m_SourceStream.Position := 0;
end;

// ---------------------------------------------------------------------------
// 데이터셋의 필드, 레코드 내용을 전체 삭제한다.
procedure CFNIOHandler.ClearAll;
begin
  while 0 < m_DataSetList.Count do
  begin
    m_DataSetList.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNIOHandler.ClearData;
var
  f_nIndex: Integer;
  f_DataSet: CFNIODataSet;
begin
  for f_nIndex := 0 to m_DataSetList.Count - 1 do
  begin
    f_DataSet := m_DataSetList.Items[f_nIndex] as CFNIODataSet;
    if Assigned(f_DataSet) then
      f_DataSet.ClearData;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNIOHandler.ClearIODataSet;
begin
  while 0 < m_DataSetList.Count do
  begin
    m_DataSetList.Delete(0);
  end;
end;

{$ENDREGION}

end.
