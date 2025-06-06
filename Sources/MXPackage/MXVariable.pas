unit MXVariable;

interface

uses
  Windows,
  Classes,
  SysUtils,
  ComObj,
  FNAutoRunConfig,
  FNAgentManager,
  FNAccountArray,
  FNVirtualTradeManager,
  FNGlobal;

const
  SEC_TRADE_MODE_REAL = 0;
  SEC_TRADE_MODE_TEST = 1;

var
  g_AgentManager: CFNAgentManager;
  g_VirtualTradeManager: CFNVirtualTradeManager;

  g_LogCollection: TLogCollection;

  g_AutoRun: Boolean;
  g_AutoRunConfig: CFNAutoRunConfig;
  g_AccountArray: CFNAccountArray;

  g_MatrixUserID: String;
  g_MatrixUserPW: String;
  g_MatrixGrade: Integer;

  g_SecUserID: String;
  g_SecUserPW: String;
  g_SecCertPW: String;
  g_SecTradePW: String;
  g_SecTradeMode: Integer;

  g_Guid: TGUID;
  g_SessionId: String;
  g_SessionKey: String;
  g_TradeSessionKey: String;
  g_LeaderTradeSessionKey: string;
  g_BuilderDate: String;
  g_MirrorTrade : Boolean;

  g_Version: String;
  g_PGMCode: String;
  g_SecCode: String;

  OPDATA_COLLECTION_URL: String;
  STATIONDATA_COLLECTION_URL: String;

  g_FirstUseing: Boolean;

  g_DefaultCountry: Integer;
  g_DefaultGroup: Integer;
  g_DefaultMarket: Integer;
  g_DefaultSymbol: String;

  g_DefaultOpenTime: TDateTime;
  g_DefaultCloseTime: TDateTime;

  // 시장가 주문이 가능한지의 여부
  g_EnableMarketOrder: Boolean = true;

  // 주문에서 부분 취소가 가능한지의 여부
  g_EnablePartCancelOrder: Boolean = true;

  g_ExecuteTime: TDateTime;

  g_USER_AGENT_IN_ORDERMANAGER: Boolean;

type
  TMXGlobal = class(TObject)
  public
    class function Encrypt(ASourceString: String): String;
    class function Decrypt(ASourceString: String): String;
    class function MD5Hash(AValue: String): String;

    class procedure CheckAutoRun;
    class function GetSessionID: String;
    class procedure SendEMail(AAddress: String; ASubject: String; ABody: String);
    class function GetCertDialogHandle: HWND;
  end;

implementation

uses Dialogs, FNCMVariable, DCPsha1, DCPrc4, DCPmd5, ShellAPI, IdHTTP;

// ---------------------------------------------------------------------------
class function TMXGlobal.Encrypt(ASourceString: String): String;
var
  f_Cipher: TDCP_rc4;
begin
  if Length(ASourceString) = 0 then
  begin
    Result := '';
    exit;
  end;
  f_Cipher := TDCP_rc4.Create(NIL);
  f_Cipher.InitStr('Auto Trading', TDCP_sha1);
  Result := f_Cipher.EncryptString(ASourceString);
  f_Cipher.Burn;
  f_Cipher.Free;
end;

// ---------------------------------------------------------------------------
class function TMXGlobal.Decrypt(ASourceString: String): String;
var
  f_Cipher: TDCP_rc4;
begin
  if Length(ASourceString) = 0 then
  begin
    Result := '';
    exit;
  end;
  f_Cipher := TDCP_rc4.Create(NIL);
  f_Cipher.InitStr('Auto Trading', TDCP_sha1);
  Result := f_Cipher.DecryptString(ASourceString);
  f_Cipher.Burn;
  f_Cipher.Free;
end;

// ---------------------------------------------------------------------------
class function TMXGlobal.MD5Hash(AValue: String): String;
var
  Hash: TDCP_md5;
  Digest: array [0 .. 15] of byte;
  i: Integer;
  p: string;
begin
  if AValue <> '' then
  begin
    Hash := TDCP_md5.Create(NIL); // create the hash
    Hash.Init; // initialize it
    Hash.UpdateStr(AValue); // hash the stream contents
    Hash.Final(Digest); // produce the digest
    p := '';
    for i := 0 to 15 do
      p := p + SysUtils.IntToHex(Digest[i], 2);
  end;
  Result := p;
end;

// ---------------------------------------------------------------------------
class function TMXGlobal.GetSessionID: String;
begin
  Result := g_PGMCode + g_SecCode + TFNGlobal.DateToString_YYYYMMDD(g_ExecuteTime) + TFNGlobal.TimeToString_HHMMSS(g_ExecuteTime) + g_SessionKey;
end;

// ---------------------------------------------------------------------------
class procedure TMXGlobal.CheckAutoRun;
var
  f_AutoRunConfigPath: String;
  f_AutoRunConfigFile: String;
  f_Success: Boolean;
begin
  if ParamCount > 0 then
  begin
    f_AutoRunConfigPath := ExtractFilePath(ParamStr(0));

    g_AutoRun := true;
    f_AutoRunConfigFile := ParamStr(1);

    f_Success := g_AutoRunConfig.Load(f_AutoRunConfigPath + f_AutoRunConfigFile);
    if not f_Success then
    begin
      ShowMessage('자동실행이 중지되었습니다. 설정파일을 읽는 중 오류가 발생했습니다.');
      SendEMail(g_AutoRunConfig.m_EMail, g_AutoRunConfig.m_MainWindowTitle, '[오류] 자동실행이 중지되었습니다. 설정파일을 읽는 중 오류가 발생했습니다.');
      g_AutoRun := false;
    end;

  end
  else
  begin
    g_AutoRun := false;
  end;
end;

// ---------------------------------------------------------------------------
class procedure TMXGlobal.SendEMail(AAddress: String; ASubject: String; ABody: String);
var
  f_PGM: String;
  f_PRAM: String;
begin
  if AAddress = '' then
    exit;

  f_PGM := ExtractFilePath(ParamStr(0)) + 'SendEMail.exe';
  f_PRAM := '"' + AAddress + '"' + ' "' + ASubject + '"' + ' "' + ABody + '"';
  ShellExecute(0, 'open', PWideChar(f_PGM), PWideChar(f_PRAM), NIL, SW_SHOWNORMAL);
end;

// ---------------------------------------------------------------------------
class function TMXGlobal.GetCertDialogHandle: HWND;
var
  f_MainHWnd: HWND;
  f_PrevHWnd: HWND;
  f_HWnd: HWND;
  f_WideChar: Array [0 .. 512] of Char;
  f_WindowText: String;
  f_FindString: String;
begin
  Result := HWND(NIL);

  f_FindString := '인증서 선택';
  f_MainHWnd := GetDesktopWindow();
  if f_MainHWnd <> 0 then
  begin
    f_PrevHWnd := HWND(NIL);
    while true do
    begin
      f_HWnd := FindWindowEx(f_MainHWnd, f_PrevHWnd, NIL, NIL);
      if f_HWnd = 0 then
        break;

      GetWindowText(f_HWnd, @f_WideChar, 512);
      f_WindowText := f_WideChar;

      if Length(f_WindowText) >= Length(f_FindString) then
      begin
        if StrLComp(PAnsiChar(f_WindowText), PAnsiChar(f_FindString), Length(f_FindString)) = 0 then
        begin
          Result := f_HWnd;
          break;
        end;
      end;

      f_PrevHWnd := f_HWnd;
    end;
  end;
end;

// ---------------------------------------------------------------------------
Initialization

begin
  g_AutoRun := false;
  g_AutoRunConfig := CFNAutoRunConfig.Create;
  g_AccountArray := CFNAccountArray.Create;

  g_SecUserID := '';
  g_SecUserPW := '';
  g_SecTradePW := '';
  g_SecTradeMode := SEC_TRADE_MODE_REAL;

  g_Version := '6.062';
  g_BuilderDate := '(2013-07-16 15:00)';

  g_PGMCode := '01';
  g_SecCode := 'A'; // 'A' : 교보증권, 'B' : 우리선물, 'C' : 동양증권

  g_SessionId := TFNGlobal.DateToString_YYYYMMDD(Now) + TFNGlobal.TimeToString_HHMMSS(Now);

  OleCheck(CreateGUID(g_Guid));

  g_SessionKey := '';
  g_TradeSessionKey := '';
  g_LeaderTradeSessionKey := '';
  g_MirrorTrade := false;

  g_ExecuteTime := Now;

  g_FirstUseing := true;

  g_DefaultCountry := 2;
  g_DefaultGroup := 2;
  g_DefaultMarket := 0;
  g_DefaultSymbol := 'CME003_FN';

  g_DefaultOpenTime := EncodeTime(0, 0, 0, 0);
  g_DefaultCloseTime := EncodeTime(23, 15, 0, 0);
  g_LogCollection := TLogCollection.Create;

  g_USER_AGENT_IN_ORDERMANAGER := false;
end;

// ---------------------------------------------------------------------------
Finalization

begin
  g_AutoRunConfig.Free;
  g_AccountArray.Free;
  g_LogCollection.Free;
end;
// ---------------------------------------------------------------------------

end.
