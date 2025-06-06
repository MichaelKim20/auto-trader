unit IODataSet;

interface

uses
  Contnrs, Dialogs, IniFiles, SysUtils, StrUtils, Math, Classes;

const
  IOVALUE_TYPE_INTEGER = 0;

const
  IOVALUE_TYPE_DOUBLE = 1;

const
  IOVALUE_TYPE_STRING = 2;

type
  // ---------------------------------------------------------------------------
  // 레코드의 Cell 데이터
  CIOValue = class
  protected
    m_Type: Integer;
    m_StringValue: String;
    m_DoubleValue: Double;
    m_IntegerValue: Integer;
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
    procedure SetDoubleValue(AValue: Double);
    procedure SetIntegerValue(AValue: Integer);

    function GetStringValue: String;
    function GetDoubleValue: Double;
    function GetIntegerValue: Integer;

    property DataType: Integer read GetType write SetType;
    property IntegerValue: Integer read GetIntegerValue write SetIntegerValue;
    property DoubleValue: Double read GetDoubleValue write SetDoubleValue;
    property StringValue: String read GetStringValue write SetStringValue;
    property Precision: Integer read GetPrecision write SetPrecision;
  end;

  CIOFieldInfo = class(TObject)
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
  CIORecord = class(TObject)
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

    function GetNameToStringValue(AName: String): String;
    function GetIndexToStringValue(AIndex: Integer): String;

    function GetNameToDoubleValue(AName: String): Double;
    function GetIndexToDoubleValue(AIndex: Integer): Double;

    function GetNameToIntegerValue(AName: String): Integer;
    function GetIndexToIntegerValue(AIndex: Integer): Integer;

    // 정수형 값을 리턴한다.
    function GetIntegerValue(AName: String): Integer;

    // 정수형 값을 리턴한다.
    function GetDoubleValue(AName: String): Double;

    // 문자형 값을 리턴한다.
    function GetStringValue(AName: String): String;

    procedure CopyFieldValues(srcFieldValues: THashedStringList);

    property FieldValues: THashedStringList read m_FieldValues write m_FieldValues;
  end;

  // ---------------------------------------------------------------------------
  // 데이터 셋
  CIODataSet = class(TObject)
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

    function AddFieldInfo(AFieldName: String; ASize: Integer; APrecision: Integer; AType: Integer): CIOFieldInfo;
    function FindFieldInfo(AFieldName: String): CIOFieldInfo;

    procedure DecodeData(ADataStream: TMemoryStream; ARecordCount: Integer = 0);

    procedure CloneRecord(var ARecordList: TList);

    procedure Clone(ASource: CIODataSet);

    property Name: String read m_Name write m_Name;
    property Field: THashedStringList read m_FildInfo write m_FildInfo;
    property RecordList: TObjectList read m_RecordList write m_RecordList;
  end;

implementation

/// //////////////////////////////////////////////////////////////////////////
// ---------------------------------------------------------------------------
Constructor CIOValue.Create;
begin
  inherited Create;

  m_Type := IOVALUE_TYPE_STRING;
  m_IntegerValue := 0;
  m_DoubleValue := 0;
  m_StringValue := '';
  m_Precision := 0;
end;

// ---------------------------------------------------------------------------
Destructor CIOValue.Destroy;
begin
  inherited Destroy;
end;

procedure CIOValue.SetPrecision(AValue: Integer);
begin
  m_Precision := AValue;
end;

procedure CIOValue.SetType(AType: Integer);
begin
  m_Type := AType;
end;

function CIOValue.GetPrecision: Integer;
begin
  result := m_Precision;
end;

function CIOValue.GetType: Integer;
begin
  result := m_Type;
end;

// ---------------------------------------------------------------------------
// String
procedure CIOValue.SetStringValue(AValue: String);
begin
  m_Type := IOVALUE_TYPE_STRING;
  m_StringValue := AValue;
  m_DoubleValue := 0;
  m_IntegerValue := 0;
end;

// ---------------------------------------------------------------------------
// Double
procedure CIOValue.SetDoubleValue(AValue: Double);
begin
  m_Type := IOVALUE_TYPE_DOUBLE;
  m_DoubleValue := AValue;
  m_IntegerValue := floor(AValue);
  m_StringValue := FloatToStr(AValue);
end;

// ---------------------------------------------------------------------------
// Integer
procedure CIOValue.SetIntegerValue(AValue: Integer);
begin
  m_Type := IOVALUE_TYPE_INTEGER;
  m_IntegerValue := AValue;
  m_DoubleValue := AValue;
  m_StringValue := IntToStr(AValue);
end;

// ---------------------------------------------------------------------------
// String Get
function CIOValue.GetStringValue: String;
begin
  result := m_StringValue;
end;

// ---------------------------------------------------------------------------
// Double Get
function CIOValue.GetDoubleValue: Double;
begin
  result := m_DoubleValue;
end;

// ---------------------------------------------------------------------------
// Integer Get
function CIOValue.GetIntegerValue: Integer;
begin
  result := m_IntegerValue;
end;

// ---------------------------------------------------------------------------
Constructor CIOFieldInfo.Create;
begin
  inherited Create;
  m_Name := '';
  m_Size := 0;
  m_Precision := 0;
  m_DataType := IOVALUE_TYPE_STRING;
end;

// ---------------------------------------------------------------------------
Destructor CIOFieldInfo.Destroy;
begin
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
Constructor CIORecord.Create;
begin
  inherited Create;

  m_FieldValues := THashedStringList.Create;
end;

// ---------------------------------------------------------------------------
Destructor CIORecord.Destroy;
begin
  ClearAll;
  if m_FieldValues <> NIL then
    m_FieldValues.Free;
  m_FieldValues := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 레코드 데이터 전체 삭제한다.
procedure CIORecord.ClearAll;
begin
  while 0 < m_FieldValues.Count do
  begin
    CIOValue(m_FieldValues.Objects[0]).Destroy;
    m_FieldValues.Delete(0);
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(Integer)
procedure CIORecord.AddIntegerValue(AName: String; AValue: Integer);
var
  strObj: CIOValue;
begin
  if 0 < Length(AName) then
  begin
    strObj := CIOValue.Create;
    strObj.SetIntegerValue(AValue);
    m_FieldValues.AddObject(AName, strObj);
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(Double)
procedure CIORecord.AddDoubleValue(AName: String; AValue: Double);
var
  strObj: CIOValue;
begin
  if 0 < Length(AName) then
  begin
    strObj := CIOValue.Create;
    strObj.SetDoubleValue(AValue);
    m_FieldValues.AddObject(AName, strObj);
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(String)
procedure CIORecord.AddStringValue(AName: String; AValue: String);
var
  strObj: CIOValue;
begin
  if 0 < Length(AName) then
  begin
    strObj := CIOValue.Create;
    strObj.SetStringValue(AValue);
    m_FieldValues.AddObject(AName, strObj);
  end;
end;

// ---------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(Integer)
procedure CIORecord.SetIntegerValue(AName: String; AValue: Integer);
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if 0 <= AIndex then
    begin
      CIOValue(m_FieldValues.Objects[AIndex]).SetIntegerValue(AValue);
    end
    else
    begin
      AddIntegerValue(AName, AValue);
    end;
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(Double)
procedure CIORecord.SetDoubleValue(AName: String; AValue: Double);
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if 0 <= AIndex then
    begin
      CIOValue(m_FieldValues.Objects[AIndex]).SetDoubleValue(AValue);
    end
    else
    begin
      AddDoubleValue(AName, AValue);
    end;
  end;
end;

// ------------------------------------------------------------------------
// 레코드 Cell에 데이터를 저장한다.(String)
procedure CIORecord.SetStringValue(AName: String; AValue: String);
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if 0 <= AIndex then
    begin
      CIOValue(m_FieldValues.Objects[AIndex]).SetStringValue(AValue);
    end
    else
    begin
      AddStringValue(AName, AValue);
    end;
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 필드 명으로 해당 레코드의 Cell value 값을 리턴한다.(Integer)
function CIORecord.GetNameToIntegerValue(AName: String): Integer;
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
    begin
      result := CIOValue(m_FieldValues.Objects[AIndex]).GetIntegerValue;
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
function CIORecord.GetNameToDoubleValue(AName: String): Double;
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
    begin
      result := CIOValue(m_FieldValues.Objects[AIndex]).GetDoubleValue;
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
function CIORecord.GetNameToStringValue(AName: String): String;
var
  AIndex: Integer;
begin
  if 0 < Length(AName) then
  begin
    AIndex := m_FieldValues.IndexOf(AName);
    if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
    begin
      result := CIOValue(m_FieldValues.Objects[AIndex]).GetStringValue;
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
function CIORecord.GetIndexToIntegerValue(AIndex: Integer): Integer;
begin
  if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
  begin
    result := CIOValue(m_FieldValues.Objects[AIndex]).GetIntegerValue;
  end
  else
  begin
    result := 0;
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 인덱스로 해당 레코드의 Cell value 값을 리턴한다.(Double)
function CIORecord.GetIndexToDoubleValue(AIndex: Integer): Double;
begin
  if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
  begin
    result := CIOValue(m_FieldValues.Objects[AIndex]).GetDoubleValue;
  end
  else
  begin
    result := 0;
  end;
end;

// ------------------------------------------------------------------------
// FieldValues의 인덱스로 해당 레코드의 Cell value 값을 리턴한다.(String)
function CIORecord.GetIndexToStringValue(AIndex: Integer): String;
var
  strReturn: String;
begin
  strReturn := '';

  if (0 <= AIndex) and (AIndex < m_FieldValues.Count) then
  begin
    strReturn := CIOValue(m_FieldValues.Objects[AIndex]).GetStringValue;
  end;

  result := strReturn;
end;

// ------------------------------------------------------------------------
function CIORecord.GetIntegerValue(AName: String): Integer;
begin
  result := GetNameToIntegerValue(AName);
end;

// ------------------------------------------------------------------------
function CIORecord.GetDoubleValue(AName: String): Double;
begin
  result := GetNameToDoubleValue(AName);
end;

// ------------------------------------------------------------------------
function CIORecord.GetStringValue(AName: String): String;
begin
  result := GetNameToStringValue(AName);
end;

// ------------------------------------------------------------------------
// Row의 FieldValues의 내용을 복사한다.
procedure CIORecord.CopyFieldValues(srcFieldValues: THashedStringList);
var
  nLoop: Integer;

  strObject: CIOValue;
  newStrObj: CIOValue;
begin
  ClearAll;

  for nLoop := 0 to srcFieldValues.Count - 1 do
  begin
    strObject := CIOValue(srcFieldValues.Objects[nLoop]);

    newStrObj := CIOValue.Create;
    if (IOVALUE_TYPE_DOUBLE = strObject.m_Type) then
      newStrObj.SetDoubleValue(strObject.GetDoubleValue)
    else if (IOVALUE_TYPE_INTEGER = strObject.m_Type) then
      newStrObj.SetIntegerValue(strObject.GetIntegerValue)
    else
      newStrObj.SetStringValue(strObject.GetStringValue);

    m_FieldValues.AddObject(srcFieldValues.Strings[nLoop], newStrObj);
  end;
end;

// ---------------------------------------------------------------------------
Constructor CIODataSet.Create;
begin
  inherited Create;
  m_Name := '';
  m_FildInfo := THashedStringList.Create;
  m_RecordList := TObjectList.Create;
end;

// ---------------------------------------------------------------------------
procedure CIODataSet.DecodeData(ADataStream: TMemoryStream; ARecordCount: Integer = 0);
var
  f_FieldInfo: CIOFieldInfo;
  f_Record: CIORecord;
  f_FieldIndex: Integer;
  f_RecordIndex: Integer;
  f_FieldString: String;
  f_RecordCount: Integer;
  f_RecordSize: Integer;
  f_Buffer: Array [0 .. 1024] of AnsiChar;
  f_nValue: Integer;
  f_dValue: Double;
begin
  if ARecordCount = 0 then
  begin
    f_RecordSize := 0;
    for f_FieldIndex := 0 to m_FildInfo.Count - 1 do
    begin
      f_FieldInfo := CIOFieldInfo(m_FildInfo.Objects[f_FieldIndex]);
      if not Assigned(f_FieldInfo) then
        continue;
      f_RecordSize := f_RecordSize + f_FieldInfo.Size;
    end;
    f_RecordCount := Round(ADataStream.Size / f_RecordSize);
  end
  else
  begin
    f_RecordCount := ARecordCount;
  end;

  for f_RecordIndex := 0 to f_RecordCount - 1 do
  begin
    f_Record := CIORecord.Create;
    for f_FieldIndex := 0 to m_FildInfo.Count - 1 do
    begin
      f_FieldInfo := CIOFieldInfo(m_FildInfo.Objects[f_FieldIndex]);
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

      if (IOVALUE_TYPE_INTEGER = f_FieldInfo.DataType) then
      begin
        if f_FieldString = '' then
        begin
          f_nValue := 0;
        end
        else
        begin
          try
            f_nValue := StrToInt(f_FieldString);
          except
            f_nValue := 0;
          end;
        end;

        f_Record.AddIntegerValue(f_FieldInfo.Name, f_nValue);
      end
      else if (IOVALUE_TYPE_DOUBLE = f_FieldInfo.DataType) then
      begin
        if f_FieldString = '' then
        begin
          f_dValue := 0;
        end
        else
        begin
          try
            f_dValue := StrToFloat(f_FieldString);
          except
            f_dValue := 0;
          end;
        end;
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

Destructor CIODataSet.Destroy;
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

// 데이터셋의 필드, 레코드 내용을 전체 삭제한다.
procedure CIODataSet.ClearAll;
begin
  // Field
  ClearFieldInfo;

  // Record
  ClearRecordList;
end;

// ---------------------------------------------------------------------------
// 데이터셋의 필드 정보를 모두 삭제한다.
procedure CIODataSet.ClearFieldInfo;
begin
  // Field
  while 0 < m_FildInfo.Count do
  begin
    CIOFieldInfo(m_FildInfo.Objects[0]).Free;
    m_FildInfo.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 데이터셋의 레코드 정보를 모두 삭제한다.
procedure CIODataSet.ClearRecordList;
begin
  try
    while 0 < m_RecordList.Count do
    begin
      // CIORecord(m_RecordList.Items[0]).Destroy;
      m_RecordList.Delete(0);
    end;
  finally
  end;
end;

// ---------------------------------------------------------------------------
// 데이터셋의 필드를 추가한다.
function CIODataSet.AddFieldInfo(AFieldName: String; ASize: Integer; APrecision: Integer; AType: Integer): CIOFieldInfo;
var
  fieldInfo: CIOFieldInfo;
begin
  fieldInfo := FindFieldInfo(AFieldName);
  if NIL = fieldInfo then
  begin
    fieldInfo := CIOFieldInfo.Create;
    fieldInfo.Name := AFieldName;
    fieldInfo.Size := ASize;
    fieldInfo.Precision := APrecision;
    fieldInfo.DataType := AType;
    m_FildInfo.AddObject(fieldInfo.Name, fieldInfo);
  end
  else
  begin
    fieldInfo.Name := AFieldName;
    fieldInfo.Size := ASize;
    fieldInfo.Precision := APrecision;
    fieldInfo.DataType := AType;
  end;

  result := fieldInfo;
end;

// ---------------------------------------------------------------------------
// 필드명으로 필드 상세정보를 리턴한다.
function CIODataSet.FindFieldInfo(AFieldName: String): CIOFieldInfo;
var
  fieldInfo: CIOFieldInfo;
  AIndex: Integer;
begin
  fieldInfo := NIL;

  if 0 < Length(AFieldName) then
  begin
    AIndex := m_FildInfo.IndexOf(AFieldName);
    if 0 <= AIndex then
    begin
      fieldInfo := CIOFieldInfo(m_FildInfo.Objects[AIndex]);
    end;
  end;

  result := fieldInfo;
end;

// ---------------------------------------------------------------------------
// 레코드 데이터를 TList로 복사한다.
procedure CIODataSet.CloneRecord(var ARecordList: TList);
var
  nLoop1: Integer;

  srcRecord: CIORecord;
  newRecord: CIORecord;
begin
  while 0 < ARecordList.Count do
  begin
    CIORecord(ARecordList.Items[0]).Destroy;
    ARecordList.Delete(0);
  end;

  for nLoop1 := 0 to m_RecordList.Count - 1 do
  begin
    srcRecord := CIORecord(m_RecordList.Items[nLoop1]);

    newRecord := CIORecord.Create;
    newRecord.CopyFieldValues(srcRecord.FieldValues);

    ARecordList.Add(newRecord);
  end;

end;

// ---------------------------------------------------------------------------
procedure CIODataSet.Clone(ASource: CIODataSet);
var
  f_nRecordIndex: Integer;
  f_nFieldInfoIndex: Integer;
  f_OldFieldInfo: CIOFieldInfo;
  f_NewFieldInfo: CIOFieldInfo;
  f_OldRecord: CIORecord;
  f_NewRecord: CIORecord;
  f_OldRecordCell: CIOValue;
begin
  ClearAll;

  m_Name := ASource.m_Name;

  for f_nFieldInfoIndex := 0 to ASource.m_FildInfo.Count - 1 do
  begin
    f_OldFieldInfo := CIOFieldInfo(ASource.m_FildInfo.Objects[f_nFieldInfoIndex]);
    if Assigned(f_OldFieldInfo) then
    begin
      AddFieldInfo(f_OldFieldInfo.Name, f_OldFieldInfo.Size, f_OldFieldInfo.Precision, f_OldFieldInfo.DataType);
    end;
  end;

  for f_nRecordIndex := 0 to ASource.m_RecordList.Count - 1 do
  begin
    f_OldRecord := CIORecord(ASource.m_RecordList.Items[f_nRecordIndex]);
    f_NewRecord := CIORecord.Create;
    for f_nFieldInfoIndex := 0 to ASource.m_FildInfo.Count - 1 do
    begin
      f_OldFieldInfo := CIOFieldInfo(ASource.m_FildInfo.Objects[f_nFieldInfoIndex]);
      if Assigned(f_OldFieldInfo) then
      begin
        f_OldRecordCell := CIOValue(f_OldRecord.m_FieldValues.Objects[f_nFieldInfoIndex]);
        if Assigned(f_OldRecordCell) then
        begin
          if IOVALUE_TYPE_DOUBLE = f_OldFieldInfo.DataType then
          begin
            if Assigned(f_OldRecordCell) then
            begin
              f_NewRecord.AddDoubleValue(f_OldFieldInfo.Name, f_OldRecordCell.GetDoubleValue);
            end
            else
            begin
              f_NewRecord.AddDoubleValue(f_OldFieldInfo.Name, 0);
            end;
          end
          else if IOVALUE_TYPE_INTEGER = f_OldFieldInfo.DataType then
          begin
            if Assigned(f_OldRecordCell) then
            begin
              f_NewRecord.AddIntegerValue(f_OldFieldInfo.Name, f_OldRecordCell.GetIntegerValue);
            end
            else
            begin
              f_NewRecord.AddIntegerValue(f_OldFieldInfo.Name, 0);
            end;
          end
          else
          begin
            if Assigned(f_OldRecordCell) and (0 < Length(f_OldRecordCell.GetStringValue)) then
            begin
              f_NewRecord.AddStringValue(f_OldFieldInfo.Name, f_OldRecordCell.GetStringValue);
            end
            else
            begin
              f_NewRecord.AddStringValue(f_OldFieldInfo.Name, '');
            end;
          end;
        end;
      end;
    end;
    m_RecordList.Add(f_NewRecord);
  end;
end;

end.
