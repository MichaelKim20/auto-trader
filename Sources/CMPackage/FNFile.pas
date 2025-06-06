unit FNFile;

interface

uses
  Registry, Classes;

type
  CFNFile = class(TObject)
  protected
    m_FileHandle: Integer;
    m_Mode: Integer;
    m_FileName: string;

  public
    constructor Create;
    destructor Destroy; override;

    function Open(AFileName: string; AMode: Integer): boolean; virtual;
    procedure Close; virtual;

    function Seek(AOffset: Integer; AOrigin: LongInt): boolean; virtual;
    function Read(ASource: PAnsiChar; ALength: LongInt): boolean; virtual;
    function Write(ASource: PAnsiChar; ALength: LongInt): boolean; virtual;
    procedure Flush; virtual;
    function Exist(AFileName: string): boolean;
    function Delete(AFileName: string): boolean;

    function GetLength: LongInt;
    function SetLength(ASize: LongInt): boolean;

    function IsOpend: boolean;
  end;

  // ---------------------------------------------------------------------------
  (*
    가변배열로써 메모리상에 연속적으로 실제데이터가 저장된다.
    이 때 그 크기가 자동으로 증가되며, 또한 FNQuickSort를 이용하여 고속으로 소팅을 할 수 있다.
    그러나 잦은 추가와 삭제가 예상되는 자료구조에서는 이것 보다는 TList를 상용하기 바란다.
    이것의 장점은 이미 시리얼라이즈 되어 있어므로 압축하여 통신상으로 주고 받기가 용이하면
    파일로 출력시 그 속도가 빠르다.
  *)
  CFNMFile = class(TObject)
  private
    m_AllocSize: LongInt;
    function CheckArraySize(ASize: LongInt): boolean;

  protected
    m_Position: LongInt;
    m_Size: LongInt;
    m_bNewAlloc: boolean;

  public
    m_Data: PAnsiChar;

    constructor Create;
    destructor Destroy; override;

    procedure AssignData(AData: PAnsiChar; ADataSize: LongInt; ANewAlloc: boolean = TRUE);

    procedure InitArray;
    procedure SaveToFile(AFileName: String);

    procedure Next;
    procedure Prev;
    procedure Last;
    procedure First;

    function Read(ASource: PAnsiChar; ALength: LongInt): LongInt;
    function Write(ASource: PAnsiChar; ALength: LongInt): LongInt;

    function IsBOF: boolean;
    function IsEOF: boolean;

    function PrepareSize(AIndex: LongInt; ACount: LongInt): PAnsiChar;

    procedure SetPosition(AIndex: LongInt);
    function GetPosition: LongInt;

    procedure SetFileSize(ASize: LongInt);
    function GetFileSize: LongInt;
  end;

  // ---------------------------------------------------------------------------
  CFNRecordFile = class(TObject)
  private

  protected
    m_FileName: String;
    m_FileHandle: Integer;
    m_RecordSize: LongInt;
    m_Position: LongInt;
    m_RecordCount: LongInt;
    m_Size: LongInt;

    procedure Put; virtual;
    procedure Get; virtual;

  public
    m_Record: PAnsiChar;
    constructor Create;
    destructor Destroy; override;

    procedure SetFileSize(ASize: LongInt);
    procedure Open(AFileName: String);
    procedure Close;

    procedure Next;
    procedure Prev;
    procedure Last;
    procedure First;

    procedure ReadRecord;
    procedure WriteRecord;
    procedure Add;
    procedure Insert;
    procedure Delete;
    procedure Sink(ARecordCount: LongInt);

    function IsBOF: boolean;
    function IsEOF: boolean;

    procedure ReadDataBlock(ABuf: PAnsiChar; AFirst, ALast: LongInt);
    procedure WriteDataBlock(ABuf: PAnsiChar; AFirst, ALast: LongInt);

    procedure SetRecordSize(ARecordSize: LongInt);
    function GetRecordSize: LongInt;
    function GetRecordCount: LongInt;
    procedure SetPosition(AIndex: LongInt);
    function GetPosition: LongInt;
  end;

  // ---------------------------------------------------------------------------
  CFNMRecordFile = class(TObject)
  private
    m_AllocSize: LongInt;
    function CheckArraySize(ASize: LongInt): boolean;

  protected
    m_RecordSize: LongInt;
    m_Position: LongInt;
    m_RecordCount: LongInt;
    m_Size: LongInt;

    procedure Put; virtual;
    procedure Get; virtual;

  public
    m_Record: PAnsiChar;
    m_Data: PAnsiChar;

    constructor Create;
    destructor Destroy; override;

    procedure InitArray;
    procedure SaveToFile(AFileName: String);
    procedure SetFileSize(ASize: LongInt);
    function GetFileSize: LongInt;

    procedure Next;
    procedure Prev;
    procedure Last;
    procedure First;

    procedure Add;
    procedure Insert;

    procedure ReadRecord;
    procedure WriteRecord;

    procedure Delete;
    procedure Sink(ARecordCount: LongInt);

    function IsBOF: boolean;
    function IsEOF: boolean;

    function PrepareSize(AIndex: LongInt; ACount: LongInt): PAnsiChar;

    procedure SetRecordSize(ARecordSize: LongInt);
    function GetRecordSize: LongInt;
    function GetRecordCount: LongInt;
    procedure SetPosition(AIndex: LongInt);
    function GetPosition: LongInt;
  end;

implementation

uses
  SysUtils, WinProcs, FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNFile.Create;
begin
  m_Mode := 0;
  m_FileHandle := 0;
  m_FileName := '';
end;

// ---------------------------------------------------------------------------
destructor CFNFile.Destroy;
begin
  if (m_FileHandle <> 0) then
    Close;
end;

// ---------------------------------------------------------------------------
function CFNFile.Open(AFileName: string; AMode: Integer): boolean;
var
  nOpenError: Integer;
begin
  m_Mode := AMode;

  if (m_FileHandle <> 0) then
    Close;

  m_FileName := AFileName;

  // 읽기모드
  if (m_Mode = 0) then
  begin
    if (not Exist(m_FileName)) then
    begin
      result := FALSE;
      exit;
    end;

    nOpenError := 0;
    while (TRUE) do
    begin
      m_FileHandle := FileOpen(m_FileName, fmOpenRead);

      if (m_FileHandle > 0) then
        break;
      if (nOpenError > 10) then
        break;
      Inc(nOpenError);
      Sleep(10);
    end;

    if (m_FileHandle > 0) then
    begin
      result := TRUE;
      exit;
    end;

    // 읽기쓰기 모드
  end
  else if (m_Mode = 1) then
  begin
    if (not Exist(m_FileName)) then
    begin
      m_FileHandle := FileCreate(m_FileName);
      if (m_FileHandle > 0) then
      begin
        FileClose(m_FileHandle);
        m_FileHandle := 0;
      end;
    end;

    nOpenError := 0;
    while (TRUE) do
    begin
      m_FileHandle := FileOpen(m_FileName, fmOpenReadWrite or fmShareDenyNone);

      if (m_FileHandle > 0) then
        break;
      if (nOpenError > 10) then
        break;
      Inc(nOpenError);
      Sleep(10);
    end;

    if (m_FileHandle > 0) then
    begin
      result := TRUE;
      exit;
    end;

    // 쓰기 모드
  end
  else if (m_Mode = 2) then
  begin
    nOpenError := 0;
    while (TRUE) do
    begin
      m_FileHandle := FileCreate(m_FileName);
      if (m_FileHandle > 0) then
        break;
      if (nOpenError > 10) then
        break;
      Inc(nOpenError);
      Sleep(10);
    end;

    if (m_FileHandle > 0) then
    begin
      result := TRUE;
      exit;
    end;
  end;
  result := FALSE;
end;

// ---------------------------------------------------------------------------
procedure CFNFile.Close;
begin
  if (m_FileHandle <> 0) then
    FileClose(m_FileHandle);
  m_FileHandle := 0;
  m_FileName := '';
end;

// ---------------------------------------------------------------------------
function CFNFile.Seek(AOffset: Integer; AOrigin: LongInt): boolean;
begin
  FileSeek(m_FileHandle, AOffset, AOrigin);
  result := TRUE;
end;

// ---------------------------------------------------------------------------
function CFNFile.Read(ASource: PAnsiChar; ALength: LongInt): boolean;
var
  nOffset, nUnit, nRead: Integer;
  lpByte: PAnsiChar;
  bError: boolean;
begin
  if (ASource = NIL) then
  begin
    result := FALSE;
    exit;
  end;

  lpByte := ASource;

  nUnit := 1024;
  bError := FALSE;

  nOffset := 0;
  while (nOffset < ALength) do
  begin
    if (nOffset + nUnit > ALength) then
    begin
      nRead := ALength - nOffset;
    end
    else
    begin
      nRead := nUnit;
    end;
    if (FileRead(m_FileHandle, lpByte[nOffset], nRead) <> nRead) then
    begin
      bError := TRUE;
      break;
    end;
    Inc(nOffset, nUnit);
  end;

  if (bError) then
    result := FALSE
  else
    result := TRUE;
end;

// ---------------------------------------------------------------------------
function CFNFile.Write(ASource: PAnsiChar; ALength: LongInt): boolean;
var
  nOffset, nUnit, nWrite: Integer;
  lpByte: PAnsiChar;
  bError: boolean;
begin
  if (ASource = NIL) then
  begin
    result := FALSE;
    exit;
  end;

  lpByte := ASource;

  nUnit := 1024;
  bError := FALSE;

  nOffset := 0;
  while (nOffset < ALength) do
  begin
    if (nOffset + nUnit > ALength) then
    begin
      nWrite := ALength - nOffset;
    end
    else
    begin
      nWrite := nUnit;
    end;
    if (FileWrite(m_FileHandle, lpByte[nOffset], nWrite) <> nWrite) then
    begin
      bError := TRUE;
      break;
    end;
    Inc(nOffset, nUnit);
  end;

  if (bError) then
    result := FALSE
  else
    result := TRUE;
end;

// ---------------------------------------------------------------------------
procedure CFNFile.Flush;
begin
  WinProcs.FlushFileBuffers(m_FileHandle);
end;

// ---------------------------------------------------------------------------
function CFNFile.Exist(AFileName: string): boolean;
begin
  result := FileExists(AFileName);
end;

// ---------------------------------------------------------------------------
function CFNFile.Delete(AFileName: string): boolean;
begin
  result := WinProcs.DeleteFile(PChar(AFileName));
end;

// ---------------------------------------------------------------------------
function CFNFile.GetLength: LongInt;
begin
  result := WinProcs.GetFileSize(m_FileHandle, NIL);
end;

// ---------------------------------------------------------------------------
function CFNFile.SetLength(ASize: LongInt): boolean;
begin
  result := TRUE;
  if (m_Mode <> 0) then
  begin
    FileSeek(m_FileHandle, ASize, FILE_BEGIN);
    result := WinProcs.SetEndOfFile(m_FileHandle);
  end;
end;

// ---------------------------------------------------------------------------
function CFNFile.IsOpend: boolean;
begin
  if (m_FileHandle <> 0) then
    result := TRUE
  else
    result := FALSE;
end;

// ---------------------------------------------------------------------------
constructor CFNMFile.Create;
begin
  inherited Create;
  m_bNewAlloc := TRUE;
  m_Data := NIL;
  InitArray;
end;

// ---------------------------------------------------------------------------
destructor CFNMFile.Destroy;
begin
  if (m_bNewAlloc) then
  begin
    if (m_Data <> NIL) then
      ReallocMem(m_Data, 0);
    m_Data := NIL;
  end;
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNMFile.AssignData(AData: PAnsiChar; ADataSize: LongInt; ANewAlloc: boolean);
begin
  if (m_bNewAlloc) then
  begin
    if (m_Data <> NIL) then
      ReallocMem(m_Data, 0);
    m_Data := NIL;
  end;

  m_bNewAlloc := ANewAlloc;

  if (m_bNewAlloc) then
  begin
    if (AData = NIL) then
    begin
      m_Size := 0;
      m_Data := NIL;
      m_AllocSize := 0;
    end
    else
    begin
      m_Size := ADataSize;
      ReallocMem(m_Data, m_Size);
      TFNGlobal.memcpy(m_Data, AData, m_Size);
      m_AllocSize := m_Size;
    end;
  end
  else
  begin
    m_Size := ADataSize;
    m_Data := AData;
    m_AllocSize := m_Size;
  end;
  m_Position := 0;
end;

// ---------------------------------------------------------------------------
procedure CFNMFile.InitArray;
begin
  if (m_bNewAlloc) then
  begin
    if (m_Data <> NIL) then
      ReallocMem(m_Data, 0);
  end;

  m_Data := NIL;

  m_AllocSize := 0;

  SetFileSize(0);
  m_Position := 0;
end;

// ---------------------------------------------------------------------------
function CFNMFile.CheckArraySize(ASize: LongInt): boolean;
var
  OldAllocSize: LongInt;
begin
  if (ASize > m_AllocSize) then
  begin
    OldAllocSize := m_AllocSize;
    m_AllocSize := ASize + 1024;
    ReallocMem(m_Data, m_AllocSize);
    TFNGlobal.memset(Addr(m_Data[OldAllocSize]), 0, m_AllocSize - OldAllocSize);
  end;
  result := TRUE;
end;

// ---------------------------------------------------------------------------
procedure CFNMFile.SetPosition(AIndex: LongInt);
begin
  m_Position := AIndex;
  if (m_Position > m_Size) then
    m_Position := m_Size;
  if (m_Position < 0) then
    m_Position := 0;
end;

// ---------------------------------------------------------------------------
function CFNMFile.GetPosition: LongInt;
begin
  result := m_Position;
end;

// ---------------------------------------------------------------------------
function CFNMFile.Read(ASource: PAnsiChar; ALength: LongInt): LongInt;
var
  nReadByte: LongInt;
begin
  if (ASource = NIL) then
  begin
    result := 0;
    exit;
  end;
  if (IsEOF) then
  begin
    result := 0;
    exit;
  end;

  TFNGlobal.memset(ASource, 0, ALength);

  if ((m_Position + ALength) <= m_Size) then
  begin
    nReadByte := ALength;
  end
  else
  begin
    nReadByte := m_Size - m_Position;
    if (nReadByte < 0) then
      nReadByte := 0;
  end;

  if (nReadByte > 0) then
  begin
    TFNGlobal.memcpy(ASource, Addr(m_Data[m_Position]), nReadByte);
    SetPosition(m_Position + nReadByte);
  end;

  result := nReadByte;
end;

// ---------------------------------------------------------------------------
function CFNMFile.Write(ASource: PAnsiChar; ALength: LongInt): LongInt;
var
  lpData: PAnsiChar;
begin
  if (ASource = NIL) then
  begin
    result := 0;
    exit;
  end;

  if ((m_Position + ALength) <= m_Size) then
  begin
    lpData := Addr(m_Data[m_Position]);
  end
  else
  begin
    lpData := PrepareSize(m_Position, ALength);
  end;

  if (lpData = NIL) then
  begin
    result := 0;
    exit;
  end;

  TFNGlobal.memcpy(lpData, ASource, ALength);
  SetPosition(m_Position + ALength);
  result := ALength;
end;

// ---------------------------------------------------------------------------
function CFNMFile.PrepareSize(AIndex: LongInt; ACount: LongInt): PAnsiChar;
var
  size: Integer;
begin
  if (not CheckArraySize(AIndex + ACount)) then
  begin
    result := NIL;
    exit;
  end;

  size := AIndex + ACount;
  SetFileSize(size);
  result := Addr(m_Data[AIndex]);
end;

// ---------------------------------------------------------------------------
procedure CFNMFile.Next;
begin
  SetPosition(m_Position + 1);
end;

// ---------------------------------------------------------------------------
procedure CFNMFile.Prev;
begin
  SetPosition(m_Position - 1);
end;

// ---------------------------------------------------------------------------
procedure CFNMFile.Last;
begin
  SetPosition(m_Size - 1);
end;

// ---------------------------------------------------------------------------
procedure CFNMFile.First;
begin
  SetPosition(0);
end;

// ---------------------------------------------------------------------------
function CFNMFile.IsBOF: boolean;
begin
  if (m_Position <= 0) then
    result := TRUE
  else
    result := FALSE;
end;

// ---------------------------------------------------------------------------
function CFNMFile.IsEOF: boolean;
begin
  if (m_Position >= m_Size) then
    result := TRUE
  else
    result := FALSE;
end;

// ---------------------------------------------------------------------------
procedure CFNMFile.SetFileSize(ASize: LongInt);
begin
  m_Size := ASize;

  if (m_Size = 0) then
    TFNGlobal.memset(Addr(m_Data[0]), 0, m_AllocSize);
  if (m_Position > m_Size) then
    m_Position := m_Size;
end;

// ---------------------------------------------------------------------------
function CFNMFile.GetFileSize: LongInt;
begin
  result := m_Size;
end;

// ---------------------------------------------------------------------------
procedure CFNMFile.SaveToFile(AFileName: String);
var
  FileHandle: Integer;
begin
  FileHandle := FileCreate(AFileName);
  FileWrite(FileHandle, m_Data^, m_Size);
  FileClose(FileHandle);
end;

// ---------------------------------------------------------------------------
constructor CFNRecordFile.Create;
begin
  inherited Create;
  m_Record := NIL;
  m_FileName := '';
  m_FileHandle := 0;
  m_RecordSize := 1;
  m_Position := 0;
  m_RecordCount := 0;
  m_Size := 0;
  SetRecordSize(1);
end;

// ---------------------------------------------------------------------------
destructor CFNRecordFile.Destroy;
begin
  if m_FileHandle <> 0 then
    Close;
  if (m_Record <> NIL) then
    ReallocMem(m_Record, 0);
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.SetRecordSize(ARecordSize: LongInt);
begin
  if (ARecordSize <= 0) then
    m_RecordSize := 1
  else
    m_RecordSize := ARecordSize;
  ReallocMem(m_Record, m_RecordSize);
end;

// ---------------------------------------------------------------------------
function CFNRecordFile.GetRecordSize: LongInt;
begin
  result := m_RecordSize;
end;

// ---------------------------------------------------------------------------
function CFNRecordFile.GetRecordCount: LongInt;
begin
  result := m_RecordCount;
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.SetPosition(AIndex: LongInt);
begin
  if m_FileHandle = 0 then
    exit;

  m_Position := AIndex;
  if m_Position > m_RecordCount then
    m_Position := m_RecordCount;
  if m_Position < 0 then
    m_Position := 0;

  FileSeek(m_FileHandle, m_Position * m_RecordSize, FILE_BEGIN);
  ReadRecord;
end;

// ---------------------------------------------------------------------------
function CFNRecordFile.GetPosition: LongInt;
begin
  result := m_Position;
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.Put;
begin

end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.Get;
begin

end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.Open(AFileName: String);
begin
  if m_FileHandle <> 0 then
    Close;
  m_FileName := AFileName;
  if FileExists(m_FileName) then
  begin
    m_FileHandle := FileOpen(m_FileName, fmOpenReadWrite);
  end
  else
  begin
    m_FileHandle := FileCreate(m_FileName);
  end;

  if m_FileHandle < 0 then
  begin
    m_FileHandle := 0;
    m_Size := 0;
  end
  else
  begin
    m_Position := 0;
    m_Size := GetFileSize(m_FileHandle, NIL);
    SetFileSize(m_Size);
  end;
  First;
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.Close;
begin
  if m_FileHandle <> 0 then
    FileClose(m_FileHandle);
  m_FileHandle := 0;
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.Next;
begin
  SetPosition(m_Position + 1);
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.Prev;
begin
  SetPosition(m_Position - 1);
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.Last;
begin
  SetPosition(m_RecordCount - 1);
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.First;
begin
  SetPosition(0);
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.ReadRecord;
begin
  if (m_FileHandle = 0) then
    exit;
  FileRead(m_FileHandle, m_Record^, m_RecordSize);
  FileSeek(m_FileHandle, -m_RecordSize, FILE_CURRENT);
  Get;
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.WriteRecord;
begin
  if m_FileHandle = 0 then
    exit;
  Put;
  FileWrite(m_FileHandle, m_Record^, m_RecordSize);
  FileSeek(m_FileHandle, -m_RecordSize, FILE_CURRENT);
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.Add;
begin
  if m_FileHandle = 0 then
    exit;
  Put;
  FileSeek(m_FileHandle, 0, FILE_END);
  FileWrite(m_FileHandle, m_Record^, m_RecordSize);
  SetFileSize(m_Size + m_RecordSize);
  Last;
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.Insert;
var
  Index, Pos: Integer;
  Buffer: array [0 .. 100] of Char;
begin
  if m_FileHandle = 0 then
    exit;
  if EOF then
  begin
    Add;
  end
  else
  begin
    for Index := 0 to m_RecordCount - m_Position - 1 do
    begin
      Pos := m_RecordCount - Index - 1;
      FileSeek(m_FileHandle, Pos * m_RecordSize, FILE_BEGIN);
      FileRead(m_FileHandle, Buffer, m_RecordSize);
      FileSeek(m_FileHandle, (Pos + 1) * m_RecordSize, FILE_BEGIN);
      FileWrite(m_FileHandle, Buffer, m_RecordSize);
    end;

    FileSeek(m_FileHandle, m_Position * m_RecordSize, FILE_BEGIN);
    Put;
    Write;
    SetFileSize(m_Size + m_RecordSize);
    SetPosition(m_Position);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.Delete;
var
  Index: Integer;
  Buffer: array [0 .. 100] of Char;
begin
  if (m_FileHandle = 0) or EOF then
    exit;
  for Index := m_Position + 1 to m_RecordCount - 1 do
  begin
    FileSeek(m_FileHandle, Index * m_RecordSize, FILE_BEGIN);
    FileRead(m_FileHandle, Buffer, m_RecordSize);
    FileSeek(m_FileHandle, (Index - 1) * m_RecordSize, FILE_BEGIN);
    FileWrite(m_FileHandle, Buffer, m_RecordSize);
  end;
  SetFileSize(m_Size - m_RecordSize);
  SetPosition(m_Position);
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.Sink(ARecordCount: LongInt);
var
  Index, x: Integer;
  Buffer: array [0 .. 100] of Char;
begin
  if (m_FileHandle = 0) then
    exit;
  if (ARecordCount = 0) then
  begin
    SetFileSize(0);
    m_Position := 0;
  end
  else if (ARecordCount < m_RecordCount) then
  begin
    x := m_RecordCount - ARecordCount;
    for index := 0 to ARecordCount - 1 do
    begin
      FileSeek(m_FileHandle, x * m_RecordSize, FILE_BEGIN);
      FileRead(m_FileHandle, Buffer, m_RecordSize);
      FileSeek(m_FileHandle, index * m_RecordSize, FILE_BEGIN);
      FileWrite(m_FileHandle, Buffer, m_RecordSize);
      Inc(x);
    end;
    SetFileSize(ARecordCount * m_RecordSize);
    First;
  end;
end;

// ---------------------------------------------------------------------------
function CFNRecordFile.IsBOF: boolean;
begin
  if (m_Position <= 0) then
    result := TRUE
  else
    result := FALSE;
end;

// ---------------------------------------------------------------------------
function CFNRecordFile.IsEOF: boolean;
begin
  if (m_Position >= m_RecordCount) then
    result := TRUE
  else
    result := FALSE;
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.SetFileSize(ASize: LongInt);
begin
  if m_FileHandle = 0 then
    exit;
  m_Size := ASize;
  m_RecordCount := m_Size div m_RecordSize;
  m_Size := m_RecordCount * m_RecordSize;
  FileSeek(m_FileHandle, m_Size, FILE_BEGIN);
  SetEndOfFile(m_FileHandle);
  FileSeek(m_FileHandle, m_Position * m_RecordSize, FILE_BEGIN);
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.ReadDataBlock(ABuf: PAnsiChar; AFirst, ALast: LongInt);
var
  DataSize: LongInt;
begin
  if m_FileHandle = 0 then
    exit;
  FileSeek(m_FileHandle, m_RecordSize * AFirst, FILE_BEGIN);
  DataSize := m_RecordSize * (ALast - AFirst + 1);
  FileRead(m_FileHandle, ABuf, DataSize);
  FileSeek(m_FileHandle, m_Position * m_RecordSize, FILE_BEGIN);
end;

// ---------------------------------------------------------------------------
procedure CFNRecordFile.WriteDataBlock(ABuf: PAnsiChar; AFirst, ALast: LongInt);
var
  DataSize: LongInt;
begin
  if m_FileHandle = 0 then
    exit;
  FileSeek(m_FileHandle, m_RecordSize * AFirst, FILE_BEGIN);
  DataSize := m_RecordSize * (ALast - AFirst + 1);
  FileWrite(m_FileHandle, ABuf, DataSize);
  FileSeek(m_FileHandle, m_Position * m_RecordSize, FILE_BEGIN);
end;

// ---------------------------------------------------------------------------
constructor CFNMRecordFile.Create;
begin
  inherited Create;
  m_Record := NIL;
  m_Data := NIL;
  m_RecordSize := 1;
  InitArray;

  SetRecordSize(1);
end;

// ---------------------------------------------------------------------------
destructor CFNMRecordFile.Destroy;
begin
  if (m_Data <> NIL) then
    ReallocMem(m_Data, 0);
  if (m_Record <> NIL) then
    ReallocMem(m_Record, 0);
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.InitArray;
begin
  m_AllocSize := 0;
  if (m_Data <> NIL) then
    ReallocMem(m_Data, 0);
  m_Data := NIL;

  SetFileSize(0);
  m_RecordCount := 0;
  m_Position := 0;
end;

// ---------------------------------------------------------------------------
function CFNMRecordFile.CheckArraySize(ASize: LongInt): boolean;
var
  OldAllocSize: LongInt;
begin
  if (ASize > m_AllocSize) then
  begin
    OldAllocSize := m_AllocSize;
    m_AllocSize := ASize + 200;
    ReallocMem(m_Data, m_RecordSize * m_AllocSize);
    TFNGlobal.memset(Addr(m_Data[OldAllocSize * m_RecordSize]), 0, (m_AllocSize - OldAllocSize) * m_RecordSize);
  end;
  result := TRUE;
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.SetRecordSize(ARecordSize: LongInt);
begin
  if (ARecordSize <= 0) then
    m_RecordSize := 1
  else
    m_RecordSize := ARecordSize;
  ReallocMem(m_Record, m_RecordSize);
  InitArray;
end;

// ---------------------------------------------------------------------------
function CFNMRecordFile.GetRecordSize: LongInt;
begin
  result := m_RecordSize;
end;

// ---------------------------------------------------------------------------
function CFNMRecordFile.GetRecordCount: LongInt;
begin
  result := m_RecordCount;
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.SetPosition(AIndex: LongInt);
begin
  if AIndex < 0 then
    m_Position := 0
  else if AIndex > m_RecordCount then
    m_Position := m_RecordCount
  else
    m_Position := AIndex;
  ReadRecord;
end;

// ---------------------------------------------------------------------------
function CFNMRecordFile.GetPosition: LongInt;
begin
  result := m_Position;
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.ReadRecord;
begin
  TFNGlobal.memset(m_Record, 0, m_RecordSize);
  if IsEOF then
    exit;
  TFNGlobal.memcpy(m_Record, Addr(m_Data[m_Position * m_RecordSize]), m_RecordSize);
  Get;
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.WriteRecord;
begin
  Put;
  TFNGlobal.memcpy(Addr(m_Data[m_Position * m_RecordSize]), m_Record, m_RecordSize);
  Get;
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.Add;
begin
  if (not CheckArraySize(m_RecordCount + 1)) then
    exit;
  Put;
  TFNGlobal.memcpy(Addr(m_Data[m_RecordCount * m_RecordSize]), m_Record, m_RecordSize);
  SetFileSize(m_Size + m_RecordSize);
  Last;
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.Insert;
var
  Index: Integer;
begin
  if (not CheckArraySize(m_RecordCount + 1)) then
    exit;
  if IsEOF then
  begin
    Add;
  end
  else
  begin
    for Index := m_RecordCount - 1 downto m_Position do
    begin
      TFNGlobal.memcpy(Addr(m_Data[(index + 1) * m_RecordSize]), Addr(m_Data[index * m_RecordSize]), m_RecordSize);
    end;
    WriteRecord;
    SetFileSize(m_Size + m_RecordSize);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.Delete;
var
  Index: Integer;
begin
  for index := m_Position + 1 to m_RecordCount - 1 do
  begin
    TFNGlobal.memcpy(Addr(m_Data[(index - 1) * m_RecordSize]), Addr(m_Data[index * m_RecordSize]), m_RecordSize);
  end;
  SetFileSize(m_Size - m_RecordSize);
  SetPosition(m_Position);
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.Sink(ARecordCount: LongInt);
var
  Index, x: Integer;
begin
  if (ARecordCount = 0) then
  begin
    SetFileSize(0);
    m_Position := 0;
  end
  else if (ARecordCount < m_RecordCount) then
  begin
    x := m_RecordCount - ARecordCount;
    for index := 0 to ARecordCount - 1 do
    begin
      TFNGlobal.memcpy(Addr(m_Data[index * m_RecordSize]), Addr(m_Data[x * m_RecordSize]), m_RecordSize);
      Inc(x);
    end;
    SetFileSize(ARecordCount * m_RecordSize);
    First;
  end;
end;

// ---------------------------------------------------------------------------
function CFNMRecordFile.PrepareSize(AIndex: LongInt; ACount: LongInt): PAnsiChar;
var
  size: Integer;
begin
  if (not CheckArraySize(AIndex + ACount)) then
  begin
    result := NIL;
    exit;
  end;

  size := (AIndex + ACount) * m_RecordSize;
  SetFileSize(size);
  result := Addr(m_Data[AIndex * m_RecordSize]);
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.Put;
begin

end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.Get;
begin

end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.Next;
begin
  SetPosition(m_Position + 1);
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.Prev;
begin
  SetPosition(m_Position - 1);
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.Last;
begin
  SetPosition(m_RecordCount - 1);
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.First;
begin
  SetPosition(0);
end;

// ---------------------------------------------------------------------------
function CFNMRecordFile.IsBOF: boolean;
begin
  if (m_Position <= 0) then
    result := TRUE
  else
    result := FALSE;
end;

// ---------------------------------------------------------------------------
function CFNMRecordFile.IsEOF: boolean;
begin
  if (m_Position >= m_RecordCount) then
    result := TRUE
  else
    result := FALSE;
end;

// ---------------------------------------------------------------------------
function CFNMRecordFile.GetFileSize: LongInt;
begin
  result := m_Size;
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.SetFileSize(ASize: LongInt);
begin
  m_Size := ASize;
  if (m_RecordSize = 0) then
    m_RecordCount := 0
  else
    m_RecordCount := m_Size div m_RecordSize;
  m_Size := m_RecordCount * m_RecordSize;

  if (m_Size = 0) then
    TFNGlobal.memset(Addr(m_Data[0]), 0, m_AllocSize * m_RecordSize);
end;

// ---------------------------------------------------------------------------
procedure CFNMRecordFile.SaveToFile(AFileName: String);
var
  FileHandle: Integer;
begin
  FileHandle := FileCreate(AFileName);
  FileWrite(FileHandle, m_Data, m_Size);
  FileClose(FileHandle);
end;

// ---------------------------------------------------------------------------
end.
