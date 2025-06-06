unit FNPacketHandler;

interface

uses
  Classes, WinTypes, Forms, ShellAPI, WinInet, WinProcs, DateUtils, SysUtils,
  ActiveX,
  FNFile, FNGlobal, FNDataArray, ZLib, FNDataObject;

const
  COMPRESS_BUFFERSIZE = 4096;

type

{$ALIGN 1}
  /// /////////////////////////////////////////////////////////////////////////////
  TFNPacketHandlerHDData = record
    m_Header: Array [0 .. 4] of AnsiChar;
    m_PacketType: Byte;
    m_Compress: Byte;
    m_Encryption: Byte;
  end;

  /// /////////////////////////////////////////////////////////////////////////////
  TFNPacketHandlerFTData = record
    m_Footer: Array [0 .. 4] of AnsiChar;
  end;
  /// /////////////////////////////////////////////////////////////////////////////
{$ALIGN 8}

  /// /////////////////////////////////////////////////////////////////////////////////////////////////////
  CFNPacketHandler = class(TObject)
  private
    // 패킷의 헤더정보를 가지고 있는 구조체
    m_PacketHeadData: TFNPacketHandlerHDData;

    // 패킷의 풋터정보를 가지고 있는 구조체
    m_PacketFootData: TFNPacketHandlerFTData;

    m_Buffer: array [0 .. COMPRESS_BUFFERSIZE - 1] of Byte;
  public
    // 원본데이터를 가지고 있는 데이터구조
    m_SourceStream: TMemoryStream;

    // 패킷을 가지고 있는 데이터구조
    m_EncodeStream: TMemoryStream;

    // 생성자
    constructor Create;

    // 파괴자
    destructor Destroy; override;

    // 모든 내용을 초기화한다.
    procedure Clear;

    // 패킷의 타입을 설정한다.
    procedure SetPacketType(AValue: AnsiChar);
    // 패킷의 타입을 리턴한다.
    function GetPacketType: AnsiChar;

    // 압축/비압축을 선택한다.
    procedure SetCompress(AValue: Boolean);
    // 압축/비압축 상태를 리턴한다.
    function GetCompress: Boolean;

    // 암호화여부를 설정한다.
    procedure SetEncryption(AValue: Boolean);
    // 암호화여부를 리턴한다.
    function GetEncryption: Boolean;

    // 각종해드와 m_File의 내용을 m_EncodeFile에 출력한다.
    // 이때 압축여부가 true이면 m_File의 내용을 압축하여 m_EncodeFile에 출력한다.
    function EncodeData: Boolean;

    // 각종해드와 바디를 가지고 있는 AData를 가지고, 해드값을 추출한다. 압축여부,에러코드,예약공간,을 먼저 맴버변수에 설정한다.
    // 데이터의 바디 부분만을 추출해서 압축여부가 true일 때는 압축을 해지한다.
    // 이런과정을 거친 바디만을  m_File과, m_EncodeFile에 출력한다.
    function DecodeData(const AData; ADataSize: Integer): Boolean;

    function Write(const AData; ADataSize: Integer): Boolean;

  end;

implementation

uses
  FNGlobalVariable, WideStrUtils, FNStreamPacketHandler;

{ CFNPacketHandler }

constructor CFNPacketHandler.Create;
begin
  inherited Create;
  TFNGlobal.memset(@m_PacketHeadData, 0, sizeof(m_PacketHeadData));
  TFNGlobal.memcpy(m_PacketHeadData.m_Header, g_Header, g_HeaderSize);

  TFNGlobal.memset(@m_PacketFootData, 0, sizeof(m_PacketFootData));
  TFNGlobal.memcpy(m_PacketFootData.m_Footer, g_Footer, g_FooterSize);
  m_SourceStream := TMemoryStream.Create;
  m_EncodeStream := TMemoryStream.Create;
end;

destructor CFNPacketHandler.Destroy;
begin

  m_SourceStream.Free;
  m_EncodeStream.Free;

  inherited;
end;

procedure CFNPacketHandler.Clear;
begin
  TFNGlobal.memset(@m_PacketHeadData, 0, sizeof(m_PacketHeadData));
  TFNGlobal.memcpy(m_PacketHeadData.m_Header, g_Header, g_HeaderSize);

  TFNGlobal.memset(@m_PacketFootData, 0, sizeof(m_PacketFootData));
  TFNGlobal.memcpy(m_PacketFootData.m_Footer, g_Footer, g_FooterSize);

  m_SourceStream.Clear;
  m_EncodeStream.Clear;
end;

function CFNPacketHandler.GetCompress: Boolean;
begin
  if (m_PacketHeadData.m_Compress = Byte('1')) then
    Result := true
  else
    Result := false;
end;

function CFNPacketHandler.GetEncryption: Boolean;
begin
  if (m_PacketHeadData.m_Encryption = Byte('1')) then
    Result := true
  else
    Result := false;
end;

function CFNPacketHandler.GetPacketType: AnsiChar;
begin
  Result := AnsiChar(m_PacketHeadData.m_PacketType);
end;

procedure CFNPacketHandler.SetCompress(AValue: Boolean);
begin
  if AValue then
    m_PacketHeadData.m_Compress := Byte('1')
  else
    m_PacketHeadData.m_Compress := Byte('0');
end;

procedure CFNPacketHandler.SetEncryption(AValue: Boolean);
begin
  if AValue then
    m_PacketHeadData.m_Encryption := Byte('1')
  else
    m_PacketHeadData.m_Encryption := Byte('0');
end;

procedure CFNPacketHandler.SetPacketType(AValue: AnsiChar);
begin
  m_PacketHeadData.m_PacketType := Byte(AValue);
end;

function CFNPacketHandler.Write(const AData; ADataSize: Integer): Boolean;
begin
  m_SourceStream.Write(AData, ADataSize);
  Result := true;
end;

function CFNPacketHandler.DecodeData(const AData; ADataSize: Integer): Boolean;
var
  lpData: PAnsiChar;
  nDataSize: Integer;
  f_DecompressionStream: TDecompressionStream;
  f_CompressStream: TMemoryStream;
  f_Count: Integer;
begin
  m_SourceStream.Clear;
  m_EncodeStream.Clear;
  m_EncodeStream.Write(AData, ADataSize);

  lpData := PAnsiChar(@AData) + sizeof(TFNPacketHandlerHDData);
  nDataSize := ADataSize - sizeof(TFNPacketHandlerHDData) - sizeof(TFNPacketHandlerFTData);

  if (nDataSize <= 0) then
  begin
    Result := false;
    exit;
  end;
  m_EncodeStream.Position := 0;
  m_EncodeStream.Read(m_PacketHeadData, sizeof(TFNPacketHandlerHDData));

  f_CompressStream := TMemoryStream.Create;
  f_CompressStream.Write(lpData^, nDataSize);
  f_CompressStream.Position := 0;

  if GetCompress then
  begin
    f_DecompressionStream := TDecompressionStream.Create(f_CompressStream);
    try
      while true do
      begin
        f_Count := f_DecompressionStream.Read(m_Buffer, COMPRESS_BUFFERSIZE);
        if f_Count <> 0 then
          m_SourceStream.Write(m_Buffer, f_Count)
        else
          break;
      end;
    finally
      f_DecompressionStream.Free;
    end;
  end
  else
  begin
    while true do
    begin
      f_Count := f_CompressStream.Read(m_Buffer, COMPRESS_BUFFERSIZE);
      if f_Count <> 0 then
        m_SourceStream.Write(m_Buffer, f_Count)
      else
        break;
    end;
  end;

  f_CompressStream.Free;

  Result := true;
end;

function CFNPacketHandler.EncodeData: Boolean;
var
  f_Count: Integer;
  f_CompressionStream: TCompressionStream;
begin
  try
    m_EncodeStream.Clear;
    m_EncodeStream.Write(m_PacketHeadData, sizeof(TFNPacketHandlerHDData));

    m_SourceStream.Position := 0;

    if GetCompress then
    begin
      f_CompressionStream := TCompressionStream.Create(m_SourceStream);
      try
        while true do
        begin
          f_Count := f_CompressionStream.Read(m_Buffer, COMPRESS_BUFFERSIZE);
          if f_Count <> 0 then
            m_EncodeStream.Write(m_Buffer, f_Count)
          else
            break;
        end;
      finally
        f_CompressionStream.Free;
      end;
    end
    else
    begin
      while true do
      begin
        f_Count := m_SourceStream.Read(m_Buffer, COMPRESS_BUFFERSIZE);
        if f_Count <> 0 then
          m_EncodeStream.Write(m_Buffer, f_Count)
        else
          break;
      end;

    end;

    m_EncodeStream.Write(m_PacketFootData, sizeof(TFNPacketHandlerFTData));

    Result := true;
  except
    Result := false;
  end;
end;

end.
