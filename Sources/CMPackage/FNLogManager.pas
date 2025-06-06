unit FNLogManager;

interface

uses
  Classes, DateUtils, SyncObjs;

Const
  TEXT_LF = #$D#$A;

type
  CFNLogManager = class(TObject)
  const
    LOG_DEBUG = 0;
    LOG_INFO = 1;
    LOG_WARNNING = 2;
    LOG_ERROR = 3;
    LOG_MESSAGE = 4;

  protected
    m_FileStream: TFileStream;
    m_AppName: String;
    m_FileName: String;
    m_Level: Integer;

    m_LogLock: TCriticalSection;

  public
    constructor Create;
    destructor Destroy; override;

    function Initialize(p_FilePath: String; p_AppName: String): Boolean;
    function GetLevelString(p_Level: Integer): String;

    procedure Write(p_Buffer: String);
    procedure WriteLog(const p_Level: Integer; const args: array of const);
    procedure WriteDebug(const args: array of const);
    procedure WriteInfo(const args: array of const);
    procedure WriteError(const args: array of const);
    procedure WriteMessage(const args: array of const);

    procedure WriteLog2(const p_Level: Integer; const p_Format: String; const args: array of const);
    procedure WriteDebug2(const p_Format: String; const args: array of const);
    procedure WriteInfo2(const p_Format: String; const args: array of const);
    procedure WriteError2(const p_Format: String; const args: array of const);

    property FileName: String read m_FileName;
  private

  end;

implementation

uses
  SysUtils, WinProcs, FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNLogManager.Create;
begin
  m_LogLock := TCriticalSection.Create();

  m_AppName := '';
  m_FileName := '';
  m_Level := CFNLogManager.LOG_DEBUG;
end;

// ---------------------------------------------------------------------------
destructor CFNLogManager.Destroy;
begin
  if Assigned(m_LogLock) then
  begin
    m_LogLock.Free();
    m_LogLock := NIL;
  end;

  if Assigned(m_FileStream) then
  begin
    m_FileStream.Free();
    m_FileStream := NIL;
  end;
end;

// ---------------------------------------------------------------------------
function CFNLogManager.Initialize(p_FilePath: String; p_AppName: String): Boolean;
var
  f_TimeString: String;
  f_Mode: Word;

  f_DesEncoding: TEncoding;
  f_ByteOrderMark: TBytes;
begin
  Result := FALSE;
  try
    // 해당 경로의 디렉토리가 없으면 생성하도록한다.
    if not DirectoryExists(p_FilePath) then
    begin
      CreateDir(p_FilePath);
    end;

    f_TimeString := TFNGlobal.DateTimeToString2(Now, '%04d%02d%02d');
    m_AppName := p_AppName;
    m_FileName := p_FilePath + m_AppName + '_' + f_TimeString + '.log';

    if Not FileExists(m_FileName) then
    begin
      f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;

      m_FileStream := TFileStream.Create(m_FileName, f_Mode);
      m_FileStream.Free;
      m_FileStream := NIL;

    end;

    if FileExists(m_FileName) then
    begin
      f_Mode := fmOpenReadWrite or fmShareDenyWrite;
    end
    else
    begin
      f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
    end;

    m_FileStream := TFileStream.Create(m_FileName, f_Mode);
    if Assigned(m_FileStream) then
    begin
      // UTF-8 변경
      if (m_FileStream.Size <= 0) then
      begin
        f_DesEncoding := TEncoding.UTF8;
        f_ByteOrderMark := f_DesEncoding.GetPreamble;

        m_FileStream.Size := 0;
        m_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
      end;

      Result := TRUE;
    end;
  except
    Result := FALSE;
  end;
end;

// ---------------------------------------------------------------------------
function CFNLogManager.GetLevelString(p_Level: Integer): String;
begin
  case p_Level of
    LOG_DEBUG:
      Result := '[DEBUG   ] ';
    LOG_INFO:
      Result := '[INFO    ] ';
    LOG_WARNNING:
      Result := '[WARNNING] ';
    LOG_ERROR:
      Result := '[ERROR   ] ';
    LOG_MESSAGE:
      Result := '[MSG     ] ';
  end;
end;

procedure CFNLogManager.Write(p_Buffer: String);
var
  f_Buffer: TBytes;
  f_DesEncoding: TEncoding;
begin
  if Assigned(m_FileStream) then
  begin
    m_LogLock.Enter;
    try
      f_DesEncoding := TEncoding.UTF8;
      f_Buffer := f_DesEncoding.GetBytes(p_Buffer);

      m_FileStream.Seek(0, FILE_END);
      m_FileStream.Write(f_Buffer[0], Length(f_Buffer));
    finally
      m_LogLock.Leave;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNLogManager.WriteLog(const p_Level: Integer; const args: array of const);
var
  f_FullBuff: String;
  f_Buf: String;
  f_TimeString: String;
  f_Level: String;
  I: Integer;
begin
  if Assigned(m_FileStream) then
  begin
    try
      f_Buf := '';
      for I := 0 to High(args) do
        with args[I] do
          case VType of
            vtInteger:
              f_Buf := f_Buf + IntToStr(VInteger);
            vtBoolean:
              f_Buf := f_Buf + BoolToStr(VBoolean);
            vtChar:
              f_Buf := f_Buf + VChar;
            vtExtended:
              f_Buf := f_Buf + FloatToStr(VExtended^);
            vtString:
              f_Buf := f_Buf + VString^;
            vtPChar:
              f_Buf := f_Buf + VPChar;
            vtObject:
              f_Buf := f_Buf + VObject.ClassName;
            vtClass:
              f_Buf := f_Buf + VClass.ClassName;
            vtAnsiString:
              f_Buf := f_Buf + string(VAnsiString);
            vtCurrency:
              f_Buf := f_Buf + CurrToStr(VCurrency^);
            vtVariant:
              f_Buf := f_Buf + string(VVariant^);
            vtInt64:
              f_Buf := f_Buf + IntToStr(VInt64^);
            vtUnicodeString:
              f_Buf := f_Buf + String(VUnicodeString);
            vtWideChar:
              f_Buf := f_Buf + String(VWideChar);
            vtPointer:
              f_Buf := f_Buf + IntToStr(Integer(VPointer));
          end;

      f_TimeString := '[' + TFNGlobal.DateTimeToStr6(Now) + '] ';
      f_Level := GetLevelString(p_Level);
      f_FullBuff := f_TimeString + f_Level + f_Buf + TEXT_LF;

      // 파일에쓰기
      Write(f_FullBuff);
    except
      ; //
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNLogManager.WriteLog2(const p_Level: Integer; const p_Format: String; const args: array of const);
var
  f_FullBuff: String;
  f_Buf: String;
  f_TimeString: String;
  f_Level: String;

  nnn: Integer;
begin
  if Assigned(m_FileStream) then
  begin
    try
      f_Buf := Format(p_Format, args);

      f_TimeString := '[' + TFNGlobal.DateTimeToStr6(Now) + '] ';
      f_Level := GetLevelString(p_Level);
      f_FullBuff := f_TimeString + f_Level + f_Buf + TEXT_LF;

      // 파일에쓰기
      Write(f_FullBuff);
    finally; //
    end;
  end;
end;

procedure CFNLogManager.WriteDebug(const args: array of const);
begin
  WriteLog(LOG_DEBUG, args);
end;

procedure CFNLogManager.WriteInfo(const args: array of const);
begin
  WriteLog(LOG_INFO, args);
end;

procedure CFNLogManager.WriteMessage(const args: array of const);
begin
  WriteLog(LOG_MESSAGE, args);
end;

procedure CFNLogManager.WriteError(const args: array of const);
begin
  WriteLog(LOG_ERROR, args);
end;

procedure CFNLogManager.WriteDebug2(const p_Format: String; const args: array of const);
begin
  WriteLog2(LOG_DEBUG, p_Format, args);
end;

procedure CFNLogManager.WriteInfo2(const p_Format: String; const args: array of const);
begin
  WriteLog2(LOG_INFO, p_Format, args);
end;

procedure CFNLogManager.WriteError2(const p_Format: String; const args: array of const);
begin
  WriteLog2(LOG_ERROR, p_Format, args);
end;

end.
