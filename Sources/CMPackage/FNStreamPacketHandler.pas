unit FNStreamPacketHandler;

interface

uses
  Classes, WinTypes, Forms, ShellAPI, WinInet, WinProcs, DateUtils, SysUtils,
  ActiveX,
  FNFile, FNGlobal, FNDataArray;

const
  SPVT_I4 = 0; // Int

const
  SPVT_F8 = 1; // Double

const
  SPVT_STR = 2; // String

const
  SPVT_BINARY = 3; // Binary

const
  SPVT_MAXKEYSIZE = 12;

const
  SVIT_MAXKEYSIZE = 24;

type

  /// /////////////////////////////////////////////////////////////////////////////////////////////////////

  CFNStreamPacketHandler = class;
  pCFNStreamValueItem = ^CFNStreamValueItem;
  pCFNMFile = ^CFNMFile;

  CFNStreamValueItem = class
  public
    m_nKey: Array [0 .. SVIT_MAXKEYSIZE - 1] of AnsiChar;
    m_nValueType: Byte;
    m_nValuePrecision: Byte;
    m_Reserve: Array [0 .. 3] of AnsiChar;

    m_nValueSize: LongWord;
    m_pValue: Pointer;
    m_nIndex: Integer;
    m_bNewValue: Boolean;

    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    function SetValueItem(AKey: PAnsiChar; AValueType: Byte; AValuePrecision: Byte; AValueSize: LongWord; AValue: Pointer; ANewValue: Boolean = TRUE): Boolean;
    function DecodeValueItem(AMFile: pCFNMFile): Boolean;
    function EncodeValueItem(AMFile: pCFNMFile): Boolean;
  end;

  CFNStreamValueItemArray = class(CFNDataArray)
  protected
    procedure FinalArray; override;
  end;

  /// /////////////////////////////////////////////////////////////////////////////////////////////////////
  CFNStreamPacketHandler = class(TObject)
  protected
    // 스트리밍 패킷 해더 (m_szKey, m_nValueCount, m_bCompress)
    m_szKey: array [0 .. SPVT_MAXKEYSIZE] of AnsiChar;
    m_nValueCount: Integer;

    m_pStream: pCFNMFile;

  public
    m_Stream: CFNMFile;
    m_ValueItemArray: CFNStreamValueItemArray;

    constructor Create;
    destructor Destroy; override;

    function DecodeFrameData(AData: Pointer; ADataSize: Integer; ANewAlloc: Boolean = TRUE): Boolean;
    function EncodeFrameData: Boolean;

    procedure ClearAll;
    procedure ClearValueItem;

    function GetPacketKey: PAnsiChar;
    procedure SetPacketKey(AKey: PAnsiChar);

    function AddValueItem(AKey: PAnsiChar; AValueType: Byte; AValuePrecision: Byte; AValueSize: LongWord; AValue: Pointer; ANewValue: Boolean = TRUE): Boolean;
    function AddValueItem_AnsiChar(AKey: PAnsiChar; AValue: PAnsiChar): Boolean;
    function AddValueItem_Char(AKey: PAnsiChar; AValue: PChar): Boolean;
    function AddValueItem_Int(AKey: PAnsiChar; AValue: Integer): Boolean;
    function AddValueItem_Float(AKey: PAnsiChar; AValue: Double; AValuePrecision: Byte): Boolean;

    function GetValueItemByIndex(AHeadIndex: Integer): pCFNStreamValueItem;
    function GetValueItemByKey(AKey: PAnsiChar): pCFNStreamValueItem;

    function GetValueByIndex_PChar(AHeadIndex: Integer): PChar;
    function GetValueByIndex_PAnsiChar(AHeadIndex: Integer): PAnsiChar;
    function GetValueByIndex_Int(AHeadIndex: Integer): Integer;
    function GetValueByIndex_Float(AHeadIndex: Integer): Double;

    function GetValueByKey_PChar(AKey: PAnsiChar): PChar;
    function GetValueByKey_PAnsiChar(AKey: PAnsiChar): PAnsiChar;
    function GetValueByKey_Int(AKey: PAnsiChar): Integer;
    function GetValueByKey_Float(AKey: PAnsiChar): Double;

    function GetValueCount: Integer;
  end;

implementation

uses
  FNGlobalVariable, WideStrUtils;

/// /////////////////////////////////////////////////////////////////////////////////////////////////////

var
  g_ANSICHARNULLSTREAM: PAnsiChar = '';
  g_CHARNULLSTREAM: PChar = '';

  // ---------------------------------------------------------------------------
constructor CFNStreamValueItem.Create;
begin
  inherited Create;

  TFNGlobal.memset(m_Reserve, 0, sizeof(m_Reserve));

  // Value Item Packet(2, 1, 1, 4)
  m_nKey := '';
  m_nValueType := 0;
  m_nValuePrecision := 0;
  m_nValueSize := 0;
  m_pValue := NIL;

  m_nIndex := 0;
  m_bNewValue := FALSE;
end;

// ---------------------------------------------------------------------------
destructor CFNStreamValueItem.Destroy;
begin
  Clear;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 아이탬 클리어~
procedure CFNStreamValueItem.Clear;
begin
  if (m_bNewValue) then
  begin
    if (m_pValue <> NIL) then
      FreeMem(m_pValue);

    m_pValue := NIL;
  end;
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷 Value Item 세팅
function CFNStreamValueItem.SetValueItem(AKey: PAnsiChar; AValueType: Byte; AValuePrecision: Byte; AValueSize: LongWord; AValue: Pointer; ANewValue: Boolean = TRUE): Boolean;
begin
  try
    Clear;

    TFNGlobal.memset(m_nKey, 0, sizeof(m_nKey));
    TFNGlobal.memcpy(m_nKey, AKey, SVIT_MAXKEYSIZE - 1);
    m_nValueType := AValueType; // 1byte
    m_nValuePrecision := AValuePrecision; // 1byte
    m_nValueSize := AValueSize; // 4byte
    m_bNewValue := ANewValue; // ....

    if m_bNewValue then
    begin
      if (AValue <> NIL) then
      begin
        m_pValue := AllocMem(m_nValueSize);
        TFNGlobal.memcpy(m_pValue, AValue, m_nValueSize);
      end
      else
      begin
        m_pValue := NIL;
        m_nValueSize := 0;
      end;
    end
    else
    begin
      m_pValue := AValue;
    end;

    result := TRUE;
  except
    result := FALSE;
  end
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷 Value Item을 읽는다.
function CFNStreamValueItem.DecodeValueItem(AMFile: pCFNMFile): Boolean;
var
  nPosition: Integer;
begin
  try
    Clear;

    AMFile^.Read(@m_nKey, sizeof(m_nKey));
    AMFile^.Read(@m_nValueType, sizeof(m_nValueType));
    AMFile^.Read(@m_nValuePrecision, sizeof(m_nValuePrecision));
    AMFile^.Read(@m_Reserve, sizeof(m_Reserve));
    AMFile^.Read(@m_nValueSize, sizeof(m_nValueSize));

    m_bNewValue := FALSE;

    nPosition := AMFile^.GetPosition;
    m_pValue := Addr(AMFile^.m_Data[nPosition]);
    AMFile^.SetPosition(nPosition + Integer(m_nValueSize));

    result := TRUE;
  except
    result := FALSE;
  end;
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷 Value Item에 쓴다.
function CFNStreamValueItem.EncodeValueItem(AMFile: pCFNMFile): Boolean;
begin
  try
    AMFile^.Write(@m_nKey, sizeof(m_nKey));
    AMFile^.Write(@m_nValueType, sizeof(m_nValueType));
    AMFile^.Write(@m_nValuePrecision, sizeof(m_nValuePrecision));
    AMFile^.Write(@m_Reserve, sizeof(m_Reserve));
    AMFile^.Write(@m_nValueSize, sizeof(m_nValueSize));
    AMFile^.Write(m_pValue, m_nValueSize);

    result := TRUE;
  except
    result := FALSE;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////////////////////////////
// ---------------------------------------------------------------------------
// 스트리밍 패킷 배열을 모두 해제한다.
procedure CFNStreamValueItemArray.FinalArray;
var
  pValueItem: pCFNStreamValueItem;
  nIndex: Integer;
begin
  if (m_Items <> NIL) then
  begin
    for nIndex := 0 to m_Count - 1 do
    begin
      pValueItem := pCFNStreamValueItem(m_Items[nIndex]);
      if (pValueItem <> NIL) then
      begin
        pValueItem^.Free;
        Dispose(pValueItem);
      end;
    end;

    SetLength(m_Items, 0);
    m_Items := NIL;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////////////////////////////
// ---------------------------------------------------------------------------
constructor CFNStreamPacketHandler.Create;
begin
  inherited Create;

  // 스트리밍 패킷 해더부분 초기화(m_szKey, m_nValueCount, m_bCompress)
  TFNGlobal.memset(m_szKey, 0, sizeof(m_szKey));
  m_nValueCount := 0;

  m_Stream := CFNMFile.Create;
  m_ValueItemArray := CFNStreamValueItemArray.Create;
end;

// ---------------------------------------------------------------------------
destructor CFNStreamPacketHandler.Destroy;
begin
  m_Stream.Free;
  m_ValueItemArray.Free;
  m_nValueCount := 0;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷 Value Item 클리어~
procedure CFNStreamPacketHandler.ClearValueItem;
begin
  m_ValueItemArray.Clear;
  m_nValueCount := 0;
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷 전체 클리어~
procedure CFNStreamPacketHandler.ClearAll;
begin
  ClearValueItem;
  m_Stream.AssignData(NIL, 0, TRUE);
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷 Value Item 을 배열에 추가한다.
function CFNStreamPacketHandler.AddValueItem(AKey: PAnsiChar; AValueType: Byte; AValuePrecision: Byte; AValueSize: LongWord; AValue: Pointer; ANewValue: Boolean = TRUE): Boolean;
var
  pValueItem: pCFNStreamValueItem;
begin
  New(pValueItem);
  pValueItem^ := CFNStreamValueItem.Create;
  pValueItem^.SetValueItem(AKey, AValueType, AValuePrecision, AValueSize, AValue, ANewValue);
  pValueItem^.m_nIndex := m_nValueCount;
  m_ValueItemArray.Add(pValueItem);
  m_nValueCount := m_ValueItemArray.GetCount;
  result := TRUE;
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷 Value Items 을 배열에 추가한다. (문자열)
function CFNStreamPacketHandler.AddValueItem_Char(AKey: PAnsiChar; AValue: PChar): Boolean;
var
  f_Length: Integer;
  f_MChar: PAnsiChar;
  f_MLength: Integer;
begin
  f_Length := WStrlen(AValue);
  f_MLength := f_Length * 2 + 1;
  f_MChar := AllocMem(f_MLength);

  WideCharToMultiByte(CODEPAGE, WC_COMPOSITECHECK, AValue, f_Length, f_MChar, f_MLength, NIL, NIL);
  result := AddValueItem(AKey, SPVT_STR, 0, StrLen(f_MChar) + 1, f_MChar, TRUE);
  FreeMem(f_MChar);
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷 Value Items 을 배열에 추가한다. (문자열)
function CFNStreamPacketHandler.AddValueItem_AnsiChar(AKey: PAnsiChar; AValue: PAnsiChar): Boolean;
begin
  result := AddValueItem(AKey, SPVT_STR, 0, StrLen(AValue) + 1, AValue, TRUE);
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷 Value Items 을 배열에 추가한다. (정수형)
function CFNStreamPacketHandler.AddValueItem_Int(AKey: PAnsiChar; AValue: Integer): Boolean;
begin
  result := AddValueItem(AKey, SPVT_I4, 0, sizeof(Integer), @AValue, TRUE);
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷 Value Items 을 배열에 추가한다. (실수형)
function CFNStreamPacketHandler.AddValueItem_Float(AKey: PAnsiChar; AValue: Double; AValuePrecision: Byte): Boolean;
begin
  result := AddValueItem(AKey, SPVT_F8, AValuePrecision, sizeof(Double), @AValue, TRUE);
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷 Value Items 데이터를 Decode한다.
// Decode는 Value Item의 Body부분만 해당된다.
function CFNStreamPacketHandler.DecodeFrameData(AData: Pointer; ADataSize: Integer; ANewAlloc: Boolean): Boolean;
var
  nIndex: Integer;
  pValueItem: pCFNStreamValueItem;
begin
  try
    ClearValueItem;

    m_Stream.AssignData(AData, ADataSize, ANewAlloc);
    m_pStream := @m_Stream;

    m_pStream^.Read(m_szKey, SPVT_MAXKEYSIZE);
    m_szKey[SPVT_MAXKEYSIZE] := #0;
    m_pStream^.Read(@m_nValueCount, sizeof(m_nValueCount));
    // nOffset := SPVT_MAXKEYSIZE + sizeof(m_nValueCount);

    for nIndex := 0 to m_nValueCount - 1 do
    begin
      New(pValueItem);
      pValueItem^ := CFNStreamValueItem.Create;
      if not pValueItem^.DecodeValueItem(m_pStream) then
      begin
        pValueItem.Free;
        Dispose(pValueItem);
        result := FALSE;
        exit;
      end;

      pValueItem.m_nIndex := nIndex;
      m_ValueItemArray.Add(pValueItem);
    end;

    result := TRUE;
  except
    result := FALSE;
  end;
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷 Value Items 데이터를 Encode한다.
// Encode는 Value Item의 Body부분만 해당된다.
function CFNStreamPacketHandler.EncodeFrameData: Boolean;
var
  nIndex: Integer;
  pValueItem: pCFNStreamValueItem;

begin
  result := TRUE;

  try
    m_Stream.AssignData(NIL, 0, TRUE);

    m_Stream.Write(m_szKey, SPVT_MAXKEYSIZE);
    m_Stream.Write(@m_nValueCount, sizeof(m_nValueCount));

    for nIndex := 0 to m_nValueCount - 1 do
    begin
      pValueItem := pCFNStreamValueItem(m_ValueItemArray.m_Items[nIndex]);
      if (not pValueItem^.EncodeValueItem(pCFNMFile(@m_Stream))) then
      begin
        result := FALSE;
        exit;
      end;
    end;

  except
    result := FALSE;
  end;
end;

// ---------------------------------------------------------------------------
// Value Item Array에서 해당 Index의 Value값을 찾아서 리턴한다.
function CFNStreamPacketHandler.GetValueItemByIndex(AHeadIndex: Integer): pCFNStreamValueItem;
begin
  if (AHeadIndex >= 0) and (AHeadIndex < m_ValueItemArray.GetCount) then
    result := pCFNStreamValueItem(m_ValueItemArray.m_Items[AHeadIndex])
  else
    result := NIL;
end;

// ---------------------------------------------------------------------------
// Value Item Array에서 해당 Key의 Value값을 찾아서 리턴한다.
function CFNStreamPacketHandler.GetValueItemByKey(AKey: PAnsiChar): pCFNStreamValueItem;
var
  nIndex: Integer;
  pValueItem: pCFNStreamValueItem;
begin
  result := NIL;

  for nIndex := 0 to m_ValueItemArray.GetCount - 1 do
  begin
    pValueItem := pCFNStreamValueItem(m_ValueItemArray.m_Items[nIndex]);
    if StrComp(pValueItem^.m_nKey, AKey) = 0 then
    begin
      result := pValueItem;
      exit;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// Value Item Array에서 해당 Index의 Value값을 찾아서 리턴한다. (문자열)
function CFNStreamPacketHandler.GetValueByIndex_PAnsiChar(AHeadIndex: Integer): PAnsiChar;
var
  pValueItem: pCFNStreamValueItem;
begin
  pValueItem := GetValueItemByIndex(AHeadIndex);
  if NIL = pValueItem then
  begin
    result := g_ANSICHARNULLSTREAM;
    exit;
  end;

  if NIL = pValueItem^.m_pValue then
  begin
    result := g_ANSICHARNULLSTREAM;
    exit;
  end;

  result := g_ANSICHARNULLSTREAM;
  case pValueItem^.m_nValueType of
    SPVT_STR:
      begin
        result := PAnsiChar(pValueItem^.m_pValue);
      end;
    SPVT_BINARY:
      begin
        result := PAnsiChar(pValueItem^.m_pValue);
      end;
  end;
end;

// ---------------------------------------------------------------------------
// Value Item Array에서 해당 Index의 Value값을 찾아서 리턴한다. (문자열)
function CFNStreamPacketHandler.GetValueByIndex_PChar(AHeadIndex: Integer): PChar;
var
  pValueItem: pCFNStreamValueItem;
  f_WChar: PWideChar;
  f_WLength: Integer;
begin
  pValueItem := GetValueItemByIndex(AHeadIndex);
  if NIL = pValueItem then
  begin
    result := g_CHARNULLSTREAM;
    exit;
  end;

  if NIL = pValueItem^.m_pValue then
  begin
    result := g_CHARNULLSTREAM;
    exit;
  end;

  result := g_CHARNULLSTREAM;
  case pValueItem^.m_nValueType of
    SPVT_STR:
      begin
        f_WLength := StrLen(PAnsiChar(pValueItem^.m_pValue)) * 2 + 1;
        f_WChar := AllocMem(f_WLength);
        MultiByteToWideChar(CODEPAGE, MB_PRECOMPOSED, PAnsiChar(pValueItem^.m_pValue), StrLen(PAnsiChar(pValueItem^.m_pValue)), f_WChar, f_WLength);
        FreeMem(f_WChar);
        result := f_WChar;
      end;
    SPVT_BINARY:
      begin
        result := PChar(pValueItem^.m_pValue);
      end;
  end;
end;

// ---------------------------------------------------------------------------
// Value Item Array에서 해당 Index의 Value값을 찾아서 리턴한다. (정수형)
function CFNStreamPacketHandler.GetValueByIndex_Int(AHeadIndex: Integer): Integer;
var
  pValueItem: pCFNStreamValueItem;
begin
  pValueItem := GetValueItemByIndex(AHeadIndex);

  if NIL = pValueItem then
  begin
    result := 0;
    exit;
  end;

  if NIL = pValueItem^.m_pValue then
  begin
    result := 0;
    exit;
  end;

  result := 0;
  case pValueItem^.m_nValueType of
    SPVT_I4:
      begin
        result := PInteger(pValueItem^.m_pValue)^;
      end;
    SPVT_F8:
      begin
        result := round(PDouble(pValueItem^.m_pValue)^);
      end;
  end;
end;

// ---------------------------------------------------------------------------
// Value Item Array에서 해당 Index의 Value값을 찾아서 리턴한다. (실수형)
function CFNStreamPacketHandler.GetValueByIndex_Float(AHeadIndex: Integer): Double;
var
  pValueItem: pCFNStreamValueItem;
begin
  pValueItem := GetValueItemByIndex(AHeadIndex);

  if NIL = pValueItem then
  begin
    result := 0;
    exit;
  end;

  if NIL = pValueItem^.m_pValue then
  begin
    result := 0;
    exit;
  end;

  result := 0;
  case pValueItem^.m_nValueType of
    SPVT_I4:
      begin
        result := PInteger(pValueItem^.m_pValue)^;
      end;
    SPVT_F8:
      begin
        result := PDouble(pValueItem^.m_pValue)^;
      end;
  end;
end;

// ---------------------------------------------------------------------------
// Value Item Array에서 해당 Key의 Value값을 찾아서 리턴한다. (문자열)
function CFNStreamPacketHandler.GetValueByKey_PAnsiChar(AKey: PAnsiChar): PAnsiChar;
var
  pValueItem: pCFNStreamValueItem;
begin
  pValueItem := GetValueItemByKey(AKey);

  if NIL = pValueItem then
  begin
    result := g_ANSICHARNULLSTREAM;
    exit;
  end;

  if NIL = pValueItem^.m_pValue then
  begin
    result := g_ANSICHARNULLSTREAM;
    exit;
  end;

  result := g_ANSICHARNULLSTREAM;
  case pValueItem^.m_nValueType of
    SPVT_STR:
      begin
        result := PAnsiChar(pValueItem^.m_pValue);
      end;
    SPVT_BINARY:
      begin
        result := PAnsiChar(pValueItem^.m_pValue);
      end;
  end;
end;

// ---------------------------------------------------------------------------
// Value Item Array에서 해당 Key의 Value값을 찾아서 리턴한다. (문자열)
function CFNStreamPacketHandler.GetValueByKey_PChar(AKey: PAnsiChar): PChar;
var
  pValueItem: pCFNStreamValueItem;
  f_WChar: PWideChar;
  f_WLength: Integer;
begin
  pValueItem := GetValueItemByKey(AKey);

  if NIL = pValueItem then
  begin
    result := g_CHARNULLSTREAM;
    exit;
  end;

  if NIL = pValueItem^.m_pValue then
  begin
    result := g_CHARNULLSTREAM;
    exit;
  end;

  result := g_CHARNULLSTREAM;
  case pValueItem^.m_nValueType of
    SPVT_STR:
      begin
        f_WLength := StrLen(PAnsiChar(pValueItem^.m_pValue)) * 2 + 1;
        f_WChar := AllocMem(f_WLength);
        MultiByteToWideChar(CODEPAGE, MB_PRECOMPOSED, PAnsiChar(pValueItem^.m_pValue), StrLen(PAnsiChar(pValueItem^.m_pValue)), f_WChar, f_WLength);
        result := f_WChar;
        FreeMem(f_WChar);
      end;
    SPVT_BINARY:
      begin
        result := PChar(pValueItem^.m_pValue);
      end;
  end;
end;

// ---------------------------------------------------------------------------
// Value Item Array에서 해당 Key의 Value값을 찾아서 리턴한다. (정수형)
function CFNStreamPacketHandler.GetValueByKey_Int(AKey: PAnsiChar): Integer;
var
  pValueItem: pCFNStreamValueItem;
begin
  pValueItem := GetValueItemByKey(AKey);

  if NIL = pValueItem then
  begin
    result := 0;
    exit;
  end;

  if NIL = pValueItem^.m_pValue then
  begin
    result := 0;
    exit;
  end;

  result := 0;
  case pValueItem^.m_nValueType of
    SPVT_I4:
      begin
        result := PInteger(pValueItem^.m_pValue)^;
      end;
    SPVT_F8:
      begin
        result := round(PDouble(pValueItem^.m_pValue)^);
      end;
  end;
end;

// ---------------------------------------------------------------------------
// Value Item Array에서 해당 Key의 Value값을 찾아서 리턴한다. (실수형)
function CFNStreamPacketHandler.GetValueByKey_Float(AKey: PAnsiChar): Double;
var
  pValueItem: pCFNStreamValueItem;
begin
  pValueItem := GetValueItemByKey(AKey);

  if NIL = pValueItem then
  begin
    result := 0;
    exit;
  end;

  if NIL = pValueItem^.m_pValue then
  begin
    result := 0;
    exit;
  end;

  result := 0;
  case pValueItem^.m_nValueType of
    SPVT_I4:
      begin
        result := PInteger(pValueItem^.m_pValue)^;
      end;
    SPVT_F8:
      begin
        result := PDouble(pValueItem^.m_pValue)^;
      end;
  end;
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷 해더의 키값을 리턴한다.
function CFNStreamPacketHandler.GetPacketKey: PAnsiChar;
begin
  result := m_szKey;
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷 해더의 키값을 세팅한다.
procedure CFNStreamPacketHandler.SetPacketKey(AKey: PAnsiChar);
begin
  TFNGlobal.memset(m_szKey, 0, sizeof(m_szKey));
  TFNGlobal.memcpy(m_szKey, AKey, SPVT_MAXKEYSIZE);
end;

// ---------------------------------------------------------------------------
// 스트리밍 패킷의 Value Item Count를 리턴한다.
function CFNStreamPacketHandler.GetValueCount: Integer;
begin
  result := m_nValueCount;
end;

end.
