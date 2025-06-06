unit FNUpdaterDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, URLMon, ActiveX, WinInet, shellapi,
  IdHTTP, xmldom, msxmldom, XMLDoc, XMLIntf, FNDataSet, ExtCtrls, Buttons;

const
  WM_UPDATER_DOWNLOAD = WM_USER + 9000;

type

  TUpdaterDlg = class;

  CFNUpdaterProgress = class(TInterfacedObject, IBindStatusCallback)
  private
    m_ParentWnd: TUpdaterDlg;
  public
    function OnStartBinding(dwReserved: DWORD; pib: IBinding): HResult; stdcall;
    function OnStopBinding(HResult: HResult; szError: LPCWSTR): HResult; stdcall;
    function OnProgress(ulProgress, ulProgressMax, ulStatusCode: ULONG; szStatusText: LPCWSTR): HResult; stdcall;

    function GetPriority(out nPriority): HResult; stdcall;
    function GetBindInfo(out grfBINDF: DWORD; var bindinfo: TBindInfo): HResult; stdcall;
    function OnLowResource(reserved: DWORD): HResult; stdcall;
    function OnDataAvailable(grfBSCF: DWORD; dwSize: DWORD; formatetc: PFormatEtc; stgmed: PStgMedium): HResult; stdcall;
    function OnObjectAvailable(const iid: TGUID; punk: IUnknown): HResult; stdcall;

    procedure SetForm(p_Dlg: TUpdaterDlg);
  end;

  TUpdaterDlg = class(TForm)
    m_btnExit: TButton;
    m_btnRefresh: TButton;
    m_lbTitle: TLabel;
    ProgressBar1: TProgressBar;
    m_lbStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure m_btnRefreshClick(Sender: TObject);
    procedure m_btnExitClick(Sender: TObject);

  private

    m_VersionCheckURL: String;
    m_LocalFilePath: String;

    m_ServerFilePath: String;
    m_Version: String;
    m_FileSize: Integer;

    m_Completed: Boolean;
    m_LoadXML: Boolean;
    m_bFirstActivate: Boolean;
    m_Abort: Boolean;

  public

    function HttpSetupFileDownLoad(): Boolean;

    procedure WriteCaption();

    procedure DoStart();
    procedure DoStop();
    procedure DoProgress(Max, Position: DWORD; StatusText: String; var Abort: Boolean);
    procedure DownLoadStart();

    function DownLoadCompleted(): Boolean;
    function RunDownLoadFile(): Boolean;

    function LoadXMLDataCompleted: Boolean;
    function LoadXMLData(): Boolean;
    function IsNewVersion(): Boolean;
    function HttpXmlDataDownLoad(): String;

    procedure StartProcess();

    function ExtractURLFileName(p_Url: String): String;

  protected

    procedure WMUpdaterDownLoad(var Message: TMessage); message WM_UPDATER_DOWNLOAD;
  end;

var
  UpdaterDlg: TUpdaterDlg;

implementation

uses
  FNGlobalVariable, FNGlobal, FNDefine, FNCMVariable;
{$R *.dfm}

// ---------------------------------------------------------------------------------------------
function CFNUpdaterProgress.OnStartBinding(dwReserved: DWORD; pib: IBinding): HResult; stdcall;
begin
  if Assigned(m_ParentWnd) then
  begin
    m_ParentWnd.DoStart();
  end;
  Result := S_OK;
end;

// ---------------------------------------------------------------------------------------------
function CFNUpdaterProgress.GetPriority(out nPriority): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

// ---------------------------------------------------------------------------------------------
function CFNUpdaterProgress.OnStopBinding(HResult: HResult; szError: LPCWSTR): HResult; stdcall;
begin
  if Assigned(m_ParentWnd) then
  begin
    m_ParentWnd.DoStop();
  end;

  Result := S_OK;
end;

// ---------------------------------------------------------------------------------------------
function CFNUpdaterProgress.OnProgress(ulProgress, ulProgressMax, ulStatusCode: ULONG; szStatusText: LPCWSTR): HResult;
var
  f_Abort: Boolean;
begin
  if Assigned(m_ParentWnd) then
  begin
    f_Abort := FALSE;

    m_ParentWnd.DoProgress(ulProgressMax, ulProgress, String(szStatusText), f_Abort);
    Application.ProcessMessages;

    if f_Abort then
      Result := E_ABORT
    else
      Result := S_OK;
  end;
end;

// ---------------------------------------------------------------------------------------------
function CFNUpdaterProgress.GetBindInfo(out grfBINDF: DWORD; var bindinfo: TBindInfo): HResult; stdcall;
begin
  Result := S_OK;
end;

// ---------------------------------------------------------------------------
function CFNUpdaterProgress.OnLowResource(reserved: DWORD): HResult; stdcall;
begin
  Result := S_OK;
end;

// ---------------------------------------------------------------------------
function CFNUpdaterProgress.OnDataAvailable(grfBSCF: DWORD; dwSize: DWORD; formatetc: PFormatEtc; stgmed: PStgMedium): HResult; stdcall;
begin
  Result := S_OK;
end;

// ---------------------------------------------------------------------------
function CFNUpdaterProgress.OnObjectAvailable(const iid: TGUID; punk: IUnknown): HResult; stdcall;
begin
  Result := S_OK;
end;

// ---------------------------------------------------------------------------
procedure CFNUpdaterProgress.SetForm(p_Dlg: TUpdaterDlg);
begin
  m_ParentWnd := p_Dlg;
end;

// ============================================================================================
procedure TUpdaterDlg.WriteCaption;
var
  f_Idx: Integer;
begin
  Self.Caption := '프로그램 업그레이드';
  m_lbTitle.Caption := '프로그램을 설치를 위해 준비를 합니다. ';
  m_btnRefresh.Caption := '재시도';
  m_btnExit.Caption := '닫기';
end;

// ---------------------------------------------------------------------------
procedure TUpdaterDlg.FormCreate(Sender: TObject);
begin
  WriteCaption();

  m_LocalFilePath := '';
  m_ServerFilePath := '';
  m_VersionCheckURL := '';
  m_Version := '1.000';
  m_FileSize := 0;
  m_Completed := FALSE;
  m_LoadXML := FALSE;
  m_bFirstActivate := TRUE;

  // m_VersionCheckURL   := OPS_VERSION_INFO_URL + '?' + 'p=' + g_GradeCode + '&' + 's=' + g_SecCode;
end;

// ---------------------------------------------------------------------------
procedure TUpdaterDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  m_LocalFilePath := '';
  m_ServerFilePath := '';
  m_Abort := TRUE;
  Action := caFree;
end;

// ------------------------------------------------------------------------------
procedure TUpdaterDlg.StartProcess();
begin
  if m_LoadXML then
  begin
    if IsNewVersion() then
    begin
      DownLoadStart();
      if DownLoadCompleted() then
      begin
        RunDownLoadFile();
        PostMessage(Self.Handle, WM_CLOSE, 0, 0);
      end;
    end
    else
    begin
      PostMessage(Self.Handle, WM_CLOSE, 0, 0);
    end;
  end;
end;

// ------------------------------------------------------------------------------
procedure TUpdaterDlg.WMUpdaterDownLoad(var Message: TMessage);
begin
  StartProcess();
end;

// ---------------------------------------------------------------------------
function TUpdaterDlg.HttpSetupFileDownLoad(): Boolean;
var
  f_Result: HResult;
  f_Now: String;
  m_UpProgress: CFNUpdaterProgress;
  f_FileName: String;
  f_Tempfolder: array [0 .. 254] of AnsiChar;
begin
  Result := FALSE;

  try
    GetTempPathA(MAX_PATH, f_Tempfolder);
    // m_LocalFilePath := StrPas(f_Tempfolder) + g_SetupFileName;

    if (0 < Length(m_LocalFilePath)) then
    begin
      // 디렉토리에있는 파일 삭제
      if FileExists(m_LocalFilePath) then
      begin
        DeleteFile(m_LocalFilePath);
      end;

      // 파일 다운로드시 캐쉬설정안하도록 하기위해서
      DeleteUrlCacheEntry(PWideChar(m_ServerFilePath));
      // f_Now := '?' + DateTimeToString2(Now, '[%04d/%02d/%02d %02d:%02d:%02d:%03d] ');

      // 파일 다운로드
      m_UpProgress := CFNUpdaterProgress.Create();
      m_UpProgress.SetForm(Self);
      f_Result := URLDownloadToFile(NIL, PChar(m_ServerFilePath), PChar(m_LocalFilePath), 0, m_UpProgress);
    end;
  finally

  end;

  if (S_OK = f_Result) then
  begin
    Result := TRUE;
  end;
end;

// ---------------------------------------------------------------------------
procedure TUpdaterDlg.DoStart();
begin
  m_lbStatus.Caption := '다운로드 시작';
end;

// ---------------------------------------------------------------------------
procedure TUpdaterDlg.DoStop;
begin
  m_lbStatus.Caption := '다운로드 중지';
end;

// ---------------------------------------------------------------------------
procedure TUpdaterDlg.DoProgress(Max, Position: DWORD; StatusText: String; var Abort: Boolean);
begin
  ProgressBar1.Max := Max;
  ProgressBar1.Position := Position;
  m_lbStatus.Caption := '다운로드 중...';
  Self.Repaint;

  if (0 < Max) and (Max = Position) then
    m_Completed := TRUE
  else
    m_Completed := FALSE;

  Abort := m_Abort;
end;

// ---------------------------------------------------------------------------
procedure TUpdaterDlg.DownLoadStart();
begin
  m_Abort := FALSE;

  if HttpSetupFileDownLoad() then
  begin
    m_lbStatus.Caption := '다운로드 완료';
    Self.Repaint;
  end
  else
  begin
    m_lbStatus.Caption := '다운로드 실패';
    Self.Repaint;
  end;
end;

// ---------------------------------------------------------------------------
function TUpdaterDlg.DownLoadCompleted(): Boolean;
begin
  Result := m_Completed;
end;

// ---------------------------------------------------------------------------
function TUpdaterDlg.RunDownLoadFile(): Boolean;
var
  f_Result: Integer;
begin
  Result := FALSE;

  if (DownLoadCompleted() and FileExists(m_LocalFilePath)) then
  begin
    f_Result := ShellExecute(Handle, 'open', PWideChar(m_LocalFilePath), '', '', SW_SHOWNORMAL);
    Result := (0 < f_Result);
  end;
end;

// ---------------------------------------------------------------------------
function TUpdaterDlg.LoadXMLData(): Boolean;
var
  f_ReceiveString: String;
  f_RecordList: TStringList;
  f_RecordIndex: Integer;
  f_Line: String;
  f_LineIndex: Integer;
begin
  Result := FALSE;
  try
    f_ReceiveString := HttpXmlDataDownLoad();
    if (0 < Length(f_ReceiveString)) then
    begin
      f_RecordList := TStringList.Create;
      try
        ExtractStrings([#$0A], [], PChar(f_ReceiveString), f_RecordList);

        f_LineIndex := 0;
        for f_RecordIndex := 0 to f_RecordList.Count - 1 do
        begin
          f_Line := Trim(f_RecordList[f_RecordIndex]);

          if Length(f_Line) < 3 then
            continue;

          if f_LineIndex = 0 then
          begin
            m_Version := f_Line;
          end
          else if f_LineIndex = 1 then
          begin
            m_ServerFilePath := f_Line;
          end
          else if f_LineIndex = 2 then
          begin
            m_FileSize := TFNGlobal.atoi(f_Line);
            m_LoadXML := TRUE;
            Result := TRUE;
          end;

          Inc(f_LineIndex);
        end;
      finally
        f_RecordList.Free;
      end;
    end;
  finally
  end;
end;

// ---------------------------------------------------------------------------
procedure TUpdaterDlg.m_btnExitClick(Sender: TObject);
begin
  m_Abort := TRUE;
  PostMessage(Self.Handle, WM_CLOSE, 0, 0);
end;

// ---------------------------------------------------------------------------
procedure TUpdaterDlg.m_btnRefreshClick(Sender: TObject);
begin
  PostMessage(Handle, WM_UPDATER_DOWNLOAD, 0, 0);
end;

// ---------------------------------------------------------------------------
function TUpdaterDlg.IsNewVersion(): Boolean;
begin

end;

// ---------------------------------------------------------------------------
function TUpdaterDlg.LoadXMLDataCompleted(): Boolean;
begin
  Result := m_LoadXML;
end;

// ---------------------------------------------------------------------------
function TUpdaterDlg.HttpXmlDataDownLoad(): String;
var
  IdHTTP1: TIdHTTP;
  StrStream: TStringStream;
  StrResStream: TStringStream;

  nError: Integer;
begin
  Result := '';

  if (0 < Length(m_VersionCheckURL)) then
  begin
    IdHTTP1 := TIdHTTP.Create;
    StrStream := TStringStream.Create;
    StrResStream := TStringStream.Create;
    try
      try
        IdHTTP1.Post(m_VersionCheckURL, StrStream, StrResStream);
        Result := StrResStream.DataString;
      except
        nError := IdHTTP1.ResponseCode;
      end;
    finally
      StrStream.Free;
      StrResStream.Free;
      IdHTTP1.Free;
    end;
  end;
end;

// ---------------------------------------------------------------------------
function TUpdaterDlg.ExtractURLFileName(p_Url: String): String;
var
  i: Integer;
begin
  Result := p_Url;

  if Length(p_Url) > 0 then
  begin
    for i := Length(p_Url) downto 1 do
    begin
      if p_Url[i] in ['/', '\', '=', '&'] then
      begin
        Result := Copy(p_Url, i + 1, Length(p_Url) - i);
        Exit;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
end.
