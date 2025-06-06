unit MKGlobal;

interface

uses
  Classes, DateUtils, Types, Graphics, Math, SyncObjs;

const
  MAXTIMEFRAMECOUNT = 14;

var
  g_TimeFrame: Array [0 .. MAXTIMEFRAMECOUNT - 1] of Integer;

type

  TMKGlobal = class(TObject)
  public

    class function WriteNumber(AValue: Double; APrecision: Integer): String;
    class function WriteNumberF(AValue: Double; APrecision: Integer): String;

    class function GetTextColor(ABaseValue, AValue: Double): TColor;
    class function StrToPChar(AString: String; APChar: PChar): PChar;

    class procedure GetToken(ASource: PChar; AStr1: PChar; AStr2: PChar; var ATocken: PChar; var ANext: PChar);
    class procedure ParsingURL(ASource: String; var AServer: String; var AFile: String);

    class function FileReadLn(AHandle: Integer; var ALine: String): Boolean;
    class procedure FileWriteLn(AHandle: Integer; ALine: String);

    // 지정된 주소페지로 가기
    class procedure GotoURL(AURL: String);
    class function GetHTTPFile(AServerIP, AServerFile: String; APort: LongWord; var AReceiveData: PChar;
        var AReceiveByte: LongWord): Integer;

    class procedure GetDateTime(ATimeDate: TDateTime; var ADate: TDateTime; var ATime: TDateTime);

    // 메모리를 복사
    class procedure memcpy(ADest: PAnsiChar; ASource: PAnsiChar; ACount: Integer);
    class procedure memset(ADest: PAnsiChar; AValue: Byte; ACount: Integer);

    // 문자열을 정수로 전환
    class function atoi(AString: String): Integer;

    // 문자를 실수로 전환
    class function atof(AString: String): Double;

    class function TrimString(ASource: PChar): PChar;

    // 소문자를 대문자로 바꾸기
    class function Upper(ASource: PChar): PChar;
    class function PtrToInt(APointer: Pointer): Integer;

    class function BoolToString(AValue: Boolean): String;
    class function StringToBool(AValue: String): Boolean;
    class function BoolToInt(AValue: Boolean): Integer;
    class function IntToBool(AValue: Integer): Boolean;

    // 더블인 시간값을 스트링으로 전환하는 함수
    class function DateTimeToStr1(ADateTime: TDateTime): String;
    class function DateTimeToStr2(ADateTime: TDateTime): String;
    class function DateTimeToStr3(ADateTime: TDateTime): String;
    class function DateTimeToStr31(ADateTime: TDateTime): String;
    class function DateTimeToStr32(ADateTime: TDateTime): String;
    class function DateTimeToStr4(ADateTime: TDateTime): String;
    class function DateTimeToStr5(ADateTime: TDateTime): String;
    class function DateTimeToStr6(ADateTime: TDateTime): String;
    class function DateToString1(ADateTime: TDateTime): String;
    class function DateToString2(ADateTime: TDateTime): String;

    class function DateToString_YYYYMMDD(ADateTime: TDateTime): String;
    class function TimeToString_HHMMSS(ADateTime: TDateTime): String;

    // 더블값을 스트링으로 바꾸기
    class function NumberToString(ADouble: Double; APrecision: Integer): String;
    class function FloatToString(ADouble: Double; APrecision: Integer): String;

    // 날짜에 관련된 스트링값과 TDateTime 전환함수들
    class function StringToDateTime(strDate: String): TDateTime;
    class function StringToTime(strDate: String): TDateTime;
    class function DateTimeToString(ADate: TDateTime; AFormat: String): String;
    class function DateTimeToString2(ADate: TDateTime; AFormat: String): String;

    class function DateToMM_DD(AMonth: Integer; ADay: Integer): String;
    class function TimeToHH_MM(AHour: Integer; AMin: Integer): String;
    class function TimeToHH_MM_SS(AHour: Integer; AMin: Integer; ASec: Integer): String;
    class function DateToYY_MM_DD(AYear: Integer; AMonth: Integer = -1): String;
    class function DateToYYYY_MM_DD(AYear: Integer; AMonth: Integer; ADay: Integer = -1): String;
    class function DateToYYYY_MM_DD_HH_MM(ADateTime: TDateTime): String;
    //
    class function GetTimeFrameStrToInt(strTimeFrame: String): Integer;
    class function GetTimeFrameIntToStr(nTimeFrame: Integer): String;

    class function RectToWidth(rect: TRect): Integer;
    class function RectToHeight(rect: TRect): Integer;
    class function Rect2(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer): TRect;

    // 색상
    class function GetAlphaValue(p_Value: Integer): Integer;
    class function GetRectToRealRect(x1, y1, x2, y2: Integer): TRect;

    // 문자열
    class function NextPos(SearchStr, Str: String; Position: Integer): Integer;
    class function LastPos(SearchStr, Str: String): Integer;

    class procedure TimeToString(ATimeString: PChar);

    class function ServerNow: TDateTime;

  end;

var
  g_DateTimeDiff: TDateTime = 0;

  // ---------------------------------------------------------------------------

implementation

uses
  SysUtils, WinInet, WinProcs, ShellAPI;

// ---------------------------------------------------------------------------
class function TMKGlobal.ServerNow: TDateTime;
begin
  Result := Now + g_DateTimeDiff;
end;

{$REGION '숫자를 문자로'}

// ---------------------------------------------------------------------------
class function TMKGlobal.WriteNumber(AValue: Double; APrecision: Integer): String;
var
  f_Format: String;
begin
  f_Format := Format('%%.%dn', [APrecision]);
  Result := Format(f_Format, [AValue]);
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.WriteNumberF(AValue: Double; APrecision: Integer): String;
var
  f_Format: String;
begin
  f_Format := Format('%%.%df', [APrecision]);
  Result := Format(f_Format, [AValue]);
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.GetTextColor(ABaseValue, AValue: Double): TColor;
begin
  if AValue > ABaseValue then
  begin
    Result := RGB($F0, 0, 0);
  end
  else if AValue < ABaseValue then
  begin
    Result := RGB(0, 0, $F0);
  end
  else
  begin
    Result := RGB(0, 0, 0);
  end;
end;
{$ENDREGION}
{$REGION ''}

// ---------------------------------------------------------------------------
class function TMKGlobal.StrToPChar(AString: String; APChar: PChar): PChar;
begin
  StrPCopy(APChar, AString);

  Result := APChar;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.BoolToString(AValue: Boolean): String;
begin
  if AValue then
    Result := 'true'
  else
    Result := 'false';
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.StringToBool(AValue: String): Boolean;
begin
  if AValue = 'true' then
    Result := true
  else
    Result := false;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.BoolToInt(AValue: Boolean): Integer;
begin
  if AValue then
    Result := 1
  else
    Result := 0;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.IntToBool(AValue: Integer): Boolean;
begin
  if AValue <> 0 then
    Result := true
  else
    Result := false;
end;
// ---------------------------------------------------------------------------
{$WARNINGS OFF}

class function TMKGlobal.PtrToInt(APointer: Pointer): Integer;
begin
end;
{$WARNINGS ON}
// ---------------------------------------------------------------------------

{$ENDREGION}

// ---------------------------------------------------------------------------
class procedure TMKGlobal.GetToken(ASource: PChar; AStr1: PChar; AStr2: PChar; var ATocken: PChar; var ANext: PChar);
var
  pdest: PChar;
  length, i: Integer;
begin
  if ((ASource = NIL) or (StrComp(ASource, '') = 0)) then
  begin
    ANext := NIL;
    ATocken := ASource;
  end
  else
  begin
    if (AStr1 = NIL) then
      ATocken := ASource
    else
      ATocken := StrPos(ASource, AStr1);

    if (ATocken <> NIL) then
    begin
      if (AStr1 <> NIL) then
        ATocken := Addr(ATocken[Strlen(AStr1)]);
      pdest := StrPos(ATocken, AStr2);
      if (pdest <> NIL) then
      begin
        pdest[0] := char(0);
        pdest := pdest + 1;
      end;
      ANext := pdest;

      length := Strlen(ATocken);
      for i := 0 to length - 1 do
      begin
        if ((ATocken[length - 1 - i] = #$9) or (ATocken[length - 1 - i] = #$D) or (ATocken[length - 1 - i] = #$A) or
            (ATocken[length - 1 - i] = ' ')) then
          ATocken[length - 1 - i] := char(0)
        else
          break;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
class procedure TMKGlobal.ParsingURL(ASource: String; var AServer: String; var AFile: String);
var
  pToken1, pToken2: PChar;
  buffer: array [0 .. 255] of char;
begin
  StrPCopy(buffer, ASource);
  GetToken(buffer, nil, '/', pToken1, pToken2);
  AServer := pToken1;
  AFile := pToken2;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.FileReadLn(AHandle: Integer; var ALine: String): Boolean;
var
  done: Boolean;
  ch: char;
  count: Integer;
  value: Boolean;
  buffer: array [0 .. 512] of char;
begin
  count := 0;
  done := false;
  value := false;
  while (not done) do
  begin
    if (FileRead(AHandle, ch, 1) <> 1) then
    begin
      if (count > 0) then
        value := true
      else
        value := false;
      done := true;
    end
    else
    begin
      if (ch = #$A) then
      begin
        value := true;
        done := true;
      end
      else
      begin
        buffer[count] := ch;
        Inc(count);
      end;
    end;
  end;
  buffer[count] := char(0);
  ALine := TrimRight(buffer);
  Result := value;
end;

// ---------------------------------------------------------------------------
class procedure TMKGlobal.FileWriteLn(AHandle: Integer; ALine: String);
var
  buffer: array [0 .. 4096] of char;
begin
  StrPCopy(buffer, ALine + #$D#$A);
  FileWrite(AHandle, buffer, Strlen(buffer));
end;

// ---------------------------------------------------------------------------
class procedure TMKGlobal.GotoURL(AURL: String);
var
  pUrl: array [0 .. 512] of char;
begin
  StrPCopy(pUrl, AURL);
  ShellExecute(0, 'open', pUrl, nil, nil, SW_SHOWNORMAL);
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.GetHTTPFile(AServerIP, AServerFile: String; APort: LongWord; var AReceiveData: PChar;
    var AReceiveByte: LongWord): Integer;
var
  hSession, hConnection, hFile: HINTERNET;
  dwBytes, MemorySize, ReceiveByte: LongWord;
  bDone, bReturnValue: Boolean;
  error: Integer;
begin
  error := 0;
  hSession := NIL;
  hConnection := NIL;
  hFile := NIL;

  ReceiveByte := 0;
  MemorySize := 0;

  try
    if (error = 0) then
    begin
      hSession := InternetOpen('IE', INTERNET_OPEN_TYPE_PRECONFIG, NIL, NIL, 0);
      if (hSession = NIL) then
        error := 1;
    end;

    if (error = 0) then
    begin
      hConnection := InternetConnect(hSession, PChar(AServerIP), APort, NIL, NIL, INTERNET_SERVICE_HTTP, 0, 1);
      if (hConnection = NIL) then
        error := 2;
    end;

    if (error = 0) then
    begin
      hFile := HttpOpenRequest(hConnection, 'GET', PChar(AServerFile), HTTP_VERSION, NIL, NIL, INTERNET_FLAG_DONT_CACHE, 1);
      if (hFile = NIL) then
        error := 3;
    end;

    if (error = 0) then
    begin
      bReturnValue := HttpSendRequest(hFile, NIL, 0, NIL, 0);
      if (not bReturnValue) then
        error := 4;
    end;

    if (error = 0) then
    begin
      bDone := false;
      while (not bDone) do
      begin
        if (MemorySize < ReceiveByte + 4096) then
        begin
          MemorySize := ReceiveByte + 4096;
          ReallocMem(AReceiveData, MemorySize + 1);
        end;

        if (InternetReadFile(hFile, @AReceiveData[ReceiveByte], 4096, dwBytes)) then
        begin
          ReceiveByte := ReceiveByte + dwBytes;
          if (dwBytes = 0) then
            bDone := true;
        end
        else
        begin
          bDone := true;
          error := 5;
        end;
      end;
    end;

    if (hFile <> NIL) then
      InternetCloseHandle(hFile);
    if (hConnection <> NIL) then
      InternetCloseHandle(hConnection);
    if (hSession <> NIL) then
      InternetCloseHandle(hSession);

    if (error = 0) then
    begin
      if (AReceiveData[0] = '<') then
        error := 7
      else if (ReceiveByte = 0) then
        error := 6;
    end;

    if (error <> 0) then
    begin
      ReallocMem(AReceiveData, 0);
      AReceiveByte := 0;
    end
    else
    begin
      AReceiveData[ReceiveByte] := char(0);
      AReceiveByte := ReceiveByte;
    end;

  except
    error := 8;
    ReallocMem(AReceiveData, 0);
    AReceiveByte := 0;
  end;

  Result := error;
end;

// ---------------------------------------------------------------------------
class procedure TMKGlobal.GetDateTime(ATimeDate: TDateTime; var ADate: TDateTime; var ATime: TDateTime);
var
  Year, Month, Day, Hour, Min, Sec, MSec: word;
begin
  DecodeDateTime(ATimeDate, Year, Month, Day, Hour, Min, Sec, MSec);
  ADate := EncodeDate(Year, Month, Day);
  ATime := EncodeTime(Hour, Min, 0, 0);
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateToString1(ADateTime: TDateTime): String;
var
  Year, Month, Day: word;
  buffer: array [0 .. 256] of char;
  xValue: array [0 .. 3] of Integer;
begin
  try
    DecodeDate(ADateTime, Year, Month, Day);
    xValue[0] := Year;
    xValue[1] := Month;
    xValue[2] := Day;
    WinProcs.wvsprintf(buffer, '%04d/%02d/%02d', Addr(xValue));
    Result := buffer;
  except
    Result := '';
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateToString2(ADateTime: TDateTime): String;
var
  Year, Month, Day: word;
  buffer: array [0 .. 256] of char;
  xValue: array [0 .. 3] of Integer;
begin
  try
    DecodeDate(ADateTime, Year, Month, Day);
    xValue[0] := Year mod 100;
    xValue[1] := Month;
    xValue[2] := Day;
    WinProcs.wvsprintf(buffer, '%02d/%02d/%02d', Addr(xValue));
    Result := buffer;
  except
    Result := '';
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateToString_YYYYMMDD(ADateTime: TDateTime): String;
var
  Year, Month, Day: word;
  buffer: array [0 .. 256] of char;
  xValue: array [0 .. 3] of Integer;
begin
  try
    DecodeDate(ADateTime, Year, Month, Day);
    xValue[0] := Year;
    xValue[1] := Month;
    xValue[2] := Day;
    WinProcs.wvsprintf(buffer, '%04d%02d%02d', Addr(xValue));
    Result := buffer;
  except
    Result := '';
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.TimeToString_HHMMSS(ADateTime: TDateTime): String;
var
  Hour, Min, Sec, MSec: word;
  buffer: array [0 .. 256] of char;
  xValue: array [0 .. 3] of Integer;
begin
  try
    DecodeTime(ADateTime, Hour, Min, Sec, MSec);
    xValue[0] := Hour;
    xValue[1] := Min;
    xValue[2] := Sec;
    WinProcs.wvsprintf(buffer, '%02d%02d%02d', Addr(xValue));
    Result := buffer;
  except
    Result := '';
  end;
end;

// ---------------------------------------------------------------------------
class procedure TMKGlobal.TimeToString(ATimeString: PChar);
var
  Year, Month, Day: word;
  Hour, Min, Sec, MSec: word;
  xValue: array [0 .. 6] of Integer;
begin
  DecodeDateTime(Now, Year, Month, Day, Hour, Min, Sec, MSec);
  xValue[0] := Year;
  xValue[1] := Month;
  xValue[2] := Day;
  xValue[3] := Hour;
  xValue[4] := Min;
  xValue[5] := Sec;
  xValue[6] := MSec;
  wvsprintf(ATimeString, '%04d%02d%02d%02d%02d%02d%03d', Addr(xValue));
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateTimeToStr1(ADateTime: TDateTime): String;
var
  Year, Month, Day: word;
  Hour, Min, Sec, MSec: word;
  xValue: array [0 .. 6] of Integer;
  szTimeDate: array [0 .. 255] of char;
begin
  if (ADateTime = 0) then
  begin
    Result := '';
  end
  else
  begin
    DecodeDateTime(ADateTime, Year, Month, Day, Hour, Min, Sec, MSec);
    xValue[0] := Month;
    xValue[1] := Day;
    xValue[2] := Hour;
    xValue[3] := Min;
    xValue[4] := Sec;
    xValue[5] := MSec;
    wvsprintf(szTimeDate, '%02d/%02d %02d:%02d:%02d', Addr(xValue));
    Result := szTimeDate;
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateTimeToStr2(ADateTime: TDateTime): String;
var
  Year, Month, Day: word;
  Hour, Min, Sec, MSec: word;
  xValue: array [0 .. 6] of Integer;
  szTimeDate: array [0 .. 255] of char;
begin
  if (ADateTime = 0) then
  begin
    Result := '';
  end
  else
  begin
    DecodeDateTime(ADateTime, Year, Month, Day, Hour, Min, Sec, MSec);
    xValue[0] := Month;
    xValue[1] := Day;
    xValue[2] := Hour;
    xValue[3] := Min;
    xValue[4] := Sec;
    xValue[5] := MSec;
    wvsprintf(szTimeDate, '%02d/%02d %02d:%02d', Addr(xValue));
    Result := szTimeDate;
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateTimeToStr3(ADateTime: TDateTime): String;
var
  Year, Month, Day: word;
  Hour, Min, Sec, MSec: word;
  xValue: array [0 .. 6] of Integer;
  szTimeDate: array [0 .. 255] of char;
begin
  if (ADateTime = 0) then
  begin
    Result := '';
  end
  else
  begin
    DecodeDateTime(ADateTime, Year, Month, Day, Hour, Min, Sec, MSec);
    xValue[0] := Year;
    xValue[1] := Month;
    xValue[2] := Day;
    xValue[3] := Hour;
    xValue[4] := Min;
    xValue[5] := Sec;
    xValue[6] := MSec;
    wvsprintf(szTimeDate, '%02d/%02d/%02d %02d:%02d', Addr(xValue));
    Result := szTimeDate;
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateTimeToStr31(ADateTime: TDateTime): String;
var
  Year, Month, Day: word;
  Hour, Min, Sec, MSec: word;
  xValue: array [0 .. 6] of Integer;
  szTimeDate: array [0 .. 255] of char;
begin
  if (ADateTime = 0) then
  begin
    Result := '';
  end
  else
  begin
    DecodeDateTime(ADateTime, Year, Month, Day, Hour, Min, Sec, MSec);
    xValue[0] := Year;
    xValue[1] := Month;
    xValue[2] := Day;
    xValue[3] := Hour;
    xValue[4] := Min;
    xValue[5] := Sec;
    xValue[6] := MSec;
    wvsprintf(szTimeDate, '%02d-%02d-%02d %02d:%02d', Addr(xValue));
    Result := szTimeDate;
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateTimeToStr32(ADateTime: TDateTime): String;
var
  Year, Month, Day: word;
  Hour, Min, Sec, MSec: word;
  xValue: array [0 .. 6] of Integer;
  szTimeDate: array [0 .. 255] of char;
begin
  if (ADateTime = 0) then
  begin
    Result := '';
  end
  else
  begin
    DecodeDateTime(ADateTime, Year, Month, Day, Hour, Min, Sec, MSec);
    xValue[0] := Year;
    xValue[1] := Month;
    xValue[2] := Day;
    xValue[3] := Hour;
    xValue[4] := Min;
    xValue[5] := Sec;
    xValue[6] := MSec;
    wvsprintf(szTimeDate, '%02d-%02d-%02d %02d:%02d:%02d', Addr(xValue));
    Result := szTimeDate;
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateTimeToStr4(ADateTime: TDateTime): String;
var
  Year, Month, Day: word;
  Hour, Min, Sec, MSec: word;
  xValue: array [0 .. 6] of Integer;
  szTimeDate: array [0 .. 255] of char;
begin
  if (ADateTime = 0) then
  begin
    Result := '';
  end
  else
  begin
    DecodeDateTime(ADateTime, Year, Month, Day, Hour, Min, Sec, MSec);
    xValue[0] := Year;
    xValue[1] := Month;
    xValue[2] := Day;
    xValue[3] := Hour;
    xValue[4] := Min;
    xValue[5] := Sec;
    xValue[6] := MSec;
    wvsprintf(szTimeDate, '%02d/%02d/%02d %02d:%02d:%02d', Addr(xValue));
    Result := szTimeDate;
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateTimeToStr5(ADateTime: TDateTime): String;
var
  Year, Month, Day: word;
  Hour, Min, Sec, MSec: word;
  xValue: array [0 .. 6] of Integer;
  szTimeDate: array [0 .. 255] of char;
begin
  if (ADateTime = 0) then
  begin
    Result := '';
  end
  else
  begin
    DecodeDateTime(ADateTime, Year, Month, Day, Hour, Min, Sec, MSec);
    xValue[0] := Year;
    xValue[1] := Month;
    xValue[2] := Day;
    xValue[3] := Hour;
    xValue[4] := Min;
    xValue[5] := Sec;
    xValue[6] := MSec;
    wvsprintf(szTimeDate, '%04d%02d%02d%02d%02d%02d%03d', Addr(xValue));
    Result := szTimeDate;
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateTimeToStr6(ADateTime: TDateTime): String;
var
  Hour, Min, Sec, MSec: word;
  xValue: array [0 .. 6] of Integer;
  szTimeDate: array [0 .. 255] of char;
begin
  if (ADateTime = 0) then
  begin
    Result := '';
  end
  else
  begin
    DecodeTime(ADateTime, Hour, Min, Sec, MSec);
    xValue[0] := Hour;
    xValue[1] := Min;
    xValue[2] := Sec;
    wvsprintf(szTimeDate, '%02d:%02d:%02d', Addr(xValue));
    Result := szTimeDate;
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.Upper(ASource: PChar): PChar;
var
  length: Integer;
  idx: Integer;
begin
  length := Strlen(ASource);
  for idx := 0 to length - 1 do
  begin
    if ((ASource[idx] >= 'a') and (ASource[idx] <= 'z')) then
    begin
      ASource[idx] := char(Ord(ASource[idx]) - 32);
    end;
  end;
  Result := ASource;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.TrimString(ASource: PChar): PChar;
var
  length: Integer;
  idx: Integer;
  pdest: PChar;
begin
  length := Strlen(ASource);
  pdest := ASource;
  for idx := 0 to length - 1 do
  begin
    if ((ASource[idx] = ' ') or (ASource[idx] = #$9)) then
      pdest := Addr(ASource[idx + 1])
    else
      break;
  end;

  for idx := 0 to length - 1 do
  begin
    if ((ASource[length - 1 - idx] = #$9) or (ASource[length - 1 - idx] = #$D) or (ASource[length - 1 - idx] = #$A) or
        (ASource[length - 1 - idx] = ' ')) then
      ASource[length - 1 - idx] := char(0)
    else
      break;
  end;
  Result := pdest;
end;

// ---------------------------------------------------------------------------
class procedure TMKGlobal.memcpy(ADest: PAnsiChar; ASource: PAnsiChar; ACount: Integer);
begin
  System.Move(ASource^, ADest^, ACount);
end;

// ---------------------------------------------------------------------------
class procedure TMKGlobal.memset(ADest: PAnsiChar; AValue: Byte; ACount: Integer);
var
  i: Integer;
begin
  for i := 0 to ACount - 1 do
    ADest[i] := AnsiChar(AValue);
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.atoi(AString: String): Integer;
var
  f_String: String;
begin
  f_String := Trim(AString);
  if f_String = '' then
  begin
    Result := 0;
    exit;
  end;
  try
    Result := StrToInt(f_String);
  except
    Result := 0;
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.atof(AString: String): Double;
var
  f_String: String;
begin
  f_String := Trim(AString);
  if f_String = '' then
  begin
    Result := 0;
    exit;
  end;
  try
    Result := StrToFloat(f_String);
  except
    Result := 0;
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.NumberToString(ADouble: Double; APrecision: Integer): String;
begin
  Result := Format('%.*n', [APrecision, ADouble]);
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.FloatToString(ADouble: Double; APrecision: Integer): String;
begin
  Result := Format('%.*f', [APrecision, ADouble]);
end;

// ---------------------------------------------------------------------------
// 200901011200
// 년월일시분 문자열을 TDateTime으로변경한다.
class function TMKGlobal.StringToDateTime(strDate: String): TDateTime;
var
  Year: word;
  Month: word;
  Day: word;
  Hour: word;
  Min: word;
  Sec: word;
  MSec: word;
  // MilSec :Word;
begin
  if (8 = length(strDate)) then
  begin
    Year := atoi(Copy(strDate, 0, 4));
    Month := atoi(Copy(strDate, 5, 2));
    Day := atoi(Copy(strDate, 7, 2));

    Result := EncodeDateTime(Year, Month, Day, 0, 0, 0, 0);
  end
  // YYYYMMDDhhmm(200901011210)
  else if (12 = length(strDate)) then
  begin
    Year := atoi(Copy(strDate, 0, 4));
    Month := atoi(Copy(strDate, 5, 2));
    Day := atoi(Copy(strDate, 7, 2));
    Hour := atoi(Copy(strDate, 9, 2));
    Min := atoi(Copy(strDate, 11, 2));

    Result := EncodeDateTime(Year, Month, Day, Hour, Min, 0, 0);
  end
  // YYYYMMDDhhmmss(20090101121030)
  else if (14 = length(strDate)) then
  begin
    Year := atoi(Copy(strDate, 0, 4));
    Month := atoi(Copy(strDate, 5, 2));
    Day := atoi(Copy(strDate, 7, 2));
    Hour := atoi(Copy(strDate, 9, 2));
    Min := atoi(Copy(strDate, 11, 2));
    Sec := atoi(Copy(strDate, 13, 2));

    Result := EncodeDateTime(Year, Month, Day, Hour, Min, Sec, 0);
  end
  // YYYYMMDDhhmmssMM(2009010112103022)
  else if (16 = length(strDate)) then
  begin
    Year := atoi(Copy(strDate, 0, 4));
    Month := atoi(Copy(strDate, 5, 2));
    Day := atoi(Copy(strDate, 7, 2));
    Hour := atoi(Copy(strDate, 9, 2));
    Min := atoi(Copy(strDate, 11, 2));
    Sec := atoi(Copy(strDate, 13, 2));
    MSec := atoi(Copy(strDate, 15, 2));

    Result := EncodeDateTime(Year, Month, Day, Hour, Min, Sec, MSec);
  end
  else
  begin
    Result := 0;
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.StringToTime(strDate: String): TDateTime;
var
  Year: word;
  Month: word;
  Day: word;
  Hour: word;
  Min: word;
  Sec: word;
  MSec: word;
begin
  // hhmm(1210)
  if (4 = length(strDate)) then
  begin
    Hour := atoi(Copy(strDate, 0, 2));
    Min := atoi(Copy(strDate, 3, 2));

    Result := EncodeTime(Hour, Min, 0, 0);
  end
  // hhmmss(121030)
  else if (6 = length(strDate)) then
  begin
    Hour := atoi(Copy(strDate, 0, 2));
    Min := atoi(Copy(strDate, 3, 2));
    Sec := atoi(Copy(strDate, 5, 2));

    Result := EncodeTime(Hour, Min, Sec, 0);
  end
  // hhmmssMM(2009010112103022)
  else if (8 = length(strDate)) then
  begin
    Hour := atoi(Copy(strDate, 0, 2));
    Min := atoi(Copy(strDate, 3, 2));
    Sec := atoi(Copy(strDate, 5, 2));
    MSec := atoi(Copy(strDate, 7, 2));

    Result := EncodeTime(Hour, Min, Sec, MSec);
  end
  else
  begin
    Result := 0;
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateTimeToString(ADate: TDateTime; AFormat: String): String;
var
  Year, Month, Day: word;
  Hour, Min, Sec, MSec: word;
  xValue: array [0 .. 6] of Integer;
  // ATimeString:PChar;
  ATimeString: array [0 .. 255] of char;
begin
  DecodeDateTime(ADate, Year, Month, Day, Hour, Min, Sec, MSec);
  xValue[0] := Year;
  xValue[1] := Month;
  xValue[2] := Day;
  xValue[3] := Hour;
  xValue[4] := Min;
  xValue[5] := Sec;
  xValue[6] := MSec;

  if AFormat = 'YYYYMMDD' then
  begin
    wvsprintf(ATimeString, '%04d%02d%02d', Addr(xValue));
  end
  else if AFormat = 'YYYYMMDDHHMM' then
  begin
    wvsprintf(ATimeString, '%04d%02d%02d%02d%02d', Addr(xValue));
  end
  else if AFormat = 'YYYYMMDDHHMMSS' then
  begin
    wvsprintf(ATimeString, '%04d%02d%02d%02d%02d%02d', Addr(xValue));
  end
  else if AFormat = 'YYYYMMDDHHMMSSMSS' then
  begin
    wvsprintf(ATimeString, '%04d%02d%02d%02d%02d%02d%03d', Addr(xValue));
  end;

  Result := ATimeString;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateTimeToString2(ADate: TDateTime; AFormat: String): String;
var
  Year, Month, Day: word;
  Hour, Min, Sec, MSec: word;
  xValue: array [0 .. 6] of Integer;
  // ATimeString:PChar;
  ATimeString: array [0 .. 255] of char;
begin
  DecodeDateTime(ADate, Year, Month, Day, Hour, Min, Sec, MSec);
  xValue[0] := Year;
  xValue[1] := Month;
  xValue[2] := Day;
  xValue[3] := Hour;
  xValue[4] := Min;
  xValue[5] := Sec;
  xValue[6] := MSec;

  wvsprintf(ATimeString, PWideChar(AFormat), Addr(xValue));

  Result := ATimeString;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateToMM_DD(AMonth: Integer; ADay: Integer): String;
var
  xValue: array [0 .. 1] of Integer;
  ATimeString: array [0 .. 255] of char;
begin
  xValue[0] := AMonth;
  xValue[1] := ADay;

  wvsprintf(ATimeString, '%02d/%02d', Addr(xValue));

  Result := ATimeString;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.TimeToHH_MM(AHour: Integer; AMin: Integer): String;
var
  xValue: array [0 .. 1] of Integer;
  ATimeString: array [0 .. 255] of char;
begin
  xValue[0] := AHour;
  xValue[1] := AMin;

  wvsprintf(ATimeString, '%02d:%02d', Addr(xValue));

  Result := ATimeString;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.TimeToHH_MM_SS(AHour: Integer; AMin: Integer; ASec: Integer): String;
var
  xValue: array [0 .. 2] of Integer;
  ATimeString: array [0 .. 255] of char;
begin
  xValue[0] := AHour;
  xValue[1] := AMin;
  xValue[2] := ASec;

  wvsprintf(ATimeString, '%02d:%02d:%02d', Addr(xValue));

  Result := ATimeString;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateToYY_MM_DD(AYear: Integer; AMonth: Integer = -1): String;
var
  xValue: array [0 .. 1] of Integer;
  ATimeString: array [0 .. 255] of char;
begin

  if -1 = AMonth then
  begin
    xValue[0] := AYear;
    wvsprintf(ATimeString, '%02d', Addr(xValue));
  end
  else
  begin
    xValue[0] := AYear;
    xValue[1] := AMonth;
    wvsprintf(ATimeString, '%02d/%02d', Addr(xValue));
  end;

  Result := ATimeString;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateToYYYY_MM_DD(AYear: Integer; AMonth: Integer; ADay: Integer = -1): String;
var
  xValue: array [0 .. 2] of Integer;
  ATimeString: array [0 .. 255] of char;
begin

  if -1 = ADay then
  begin
    xValue[0] := AYear;
    xValue[1] := AMonth;
    wvsprintf(ATimeString, '%04d/%02d', Addr(xValue));
  end
  else
  begin
    xValue[0] := AYear;
    xValue[1] := AMonth;
    xValue[2] := ADay;
    wvsprintf(ATimeString, '%04d/%02d/%02d', Addr(xValue));
  end;

  Result := ATimeString;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.DateToYYYY_MM_DD_HH_MM(ADateTime: TDateTime): String;
var
  Year, Month, Day: word;
  Hour, Min, Sec, MSec: word;
  xValue: array [0 .. 6] of Integer;
  // ATimeString:PChar;
  ATimeString: array [0 .. 255] of char;
begin
  DecodeDateTime(ADateTime, Year, Month, Day, Hour, Min, Sec, MSec);
  xValue[0] := Year;
  xValue[1] := Month;
  xValue[2] := Day;
  xValue[3] := Hour;
  xValue[4] := Min;
  xValue[5] := Sec;
  xValue[6] := MSec;

  wvsprintf(ATimeString, '%04d/%02d/%02d|%02d:%02d', Addr(xValue));

  Result := ATimeString;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.GetTimeFrameStrToInt(strTimeFrame: String): Integer;
var
  f_Min: String;
begin
  f_Min := Copy(strTimeFrame, 1, 3);

  if (f_Min = 'min') then
  begin
    Result := StrToInt(Copy(strTimeFrame, 4, length(strTimeFrame) - 3));
  end
  else if (f_Min = 'sec') then
  begin
    Result := StrToInt(Copy(strTimeFrame, 4, length(strTimeFrame) - 3)) + 9000;
  end
  else if ('day' = strTimeFrame) then // 일간
  begin
    Result := 360;
  end
  else if ('week' = strTimeFrame) then // 주간
  begin
    Result := 1000;
  end
  else if ('month' = strTimeFrame) then // 월간
  begin
    Result := 2000;
  end
  else
  begin
    Result := 0;
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.GetTimeFrameIntToStr(nTimeFrame: Integer): String;
begin
  if (9000 < nTimeFrame) then
  begin
    // 분간
    Result := 'sec' + IntToStr(nTimeFrame - 9000);
  end
  else if (360 > nTimeFrame) then
  begin
    // 분간
    Result := 'min' + IntToStr(nTimeFrame);
  end
  else if (360 = nTimeFrame) then // 일간
  begin
    Result := 'day';
  end
  else if (1000 = nTimeFrame) then // 주간
  begin
    Result := 'week';
  end
  else if (2000 = nTimeFrame) then // 월간
  begin
    Result := 'month';
  end
  else
  begin
    Result := '';
  end;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.RectToWidth(rect: TRect): Integer;
begin
  Result := (rect.Right - rect.Left);
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.RectToHeight(rect: TRect): Integer;
begin
  Result := (rect.Bottom - rect.Top);
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.Rect2(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer): TRect;
begin
  Result.Left := ALeft;
  Result.Top := ATop;
  Result.Right := ALeft + AWidth;
  Result.Bottom := ATop + AHeight;
end;

// ---------------------------------------------------------------------------
// Alpha 값은 0 ~ 255 이다..(100% 비율로계산하여 값을 리턴한다.)
class function TMKGlobal.GetAlphaValue(p_Value: Integer): Integer;
begin
  if (0 < p_Value) then
    Result := Math.Floor(255 / 100 * p_Value)
  else
    Result := 0;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.GetRectToRealRect(x1, y1, x2, y2: Integer): TRect;
var
  rc: TRect;
begin
  if ((x2) <= x1) then
  begin
    rc.Left := x2;
    rc.Right := x1;
  end
  else
  begin
    rc.Left := x1;
    rc.Right := x2;
  end;

  if (y2 <= y1) then
  begin
    rc.Top := y2;
    rc.Bottom := y1;
  end
  else
  begin
    rc.Top := y1;
    rc.Bottom := y2;
  end;

  Result := rc;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.NextPos(SearchStr, Str: String; Position: Integer): Integer;
begin
  Delete(Str, 1, Position - 1);
  Result := Pos(SearchStr, upperCase(Str));

  if Result = 0 then
    exit;

  if (length(Str) > 0) and (length(SearchStr) > 0) then
    Result := Result + Position - 1;
end;

// ---------------------------------------------------------------------------
class function TMKGlobal.LastPos(SearchStr, Str: String): Integer;
var
  i: Integer;
  TempStr: String;
begin
  Result := Pos(SearchStr, Str);
  if Result = 0 then
    exit;

  if (length(Str) > 0) and (length(SearchStr) > 0) then
  begin
    for i := length(Str) + length(SearchStr) - 1 downto Result do
    begin
      TempStr := Copy(Str, i, length(Str));
      if Pos(SearchStr, TempStr) > 0 then
      begin
        Result := i;
        break;
      end;
    end;
  end;
end;

Initialization

begin
  g_TimeFrame[0] := 9010;
  g_TimeFrame[1] := 9020;
  g_TimeFrame[2] := 9030;
  g_TimeFrame[3] := 9050;
  g_TimeFrame[4] := 1;
  g_TimeFrame[5] := 2;
  g_TimeFrame[6] := 3;
  g_TimeFrame[7] := 5;
  g_TimeFrame[8] := 10;
  g_TimeFrame[9] := 15;
  g_TimeFrame[10] := 20;
  g_TimeFrame[11] := 30;
  g_TimeFrame[12] := 60;
  g_TimeFrame[13] := 360;
end;

end.
