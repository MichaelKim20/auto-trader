unit SDIMAIN;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Messages, ComCtrls, ImgList, StdActns,
  ActnList, ToolWin, FNSocketManager, FNDataSet, AgentGlobalVariable,
  IdComponent, IdTCPConnection, IdTCPClient,
  IdGlobal,
  FNReceiveSensor,
  FNDefine, FNDataDelivery, FNQuotData, SyncObjs, FNQueue,
  System.Actions;

type
{$ALIGN 1}
  pCMEQuoteData = ^TCMEQuoteData;

  TCMEQuoteData = record

    HEADER: array [0 .. 4] of AnsiChar;

    COUNTRY_NO: Integer;
    GROUP_NO: Integer;
    MARKET_NO: Integer;
    SYMBOL: Array [0 .. 15 + 1] of AnsiChar;
    DATE: Array [0 .. 7 + 1] of AnsiChar;
    TIME: Array [0 .. 5 + 1] of AnsiChar;
    PREV_CLOSE: Double;
    CLOSE_PRICE: Double;
    CHANGE: Double;
    CHANGERATE: Double;
    BEST_OFFER_PRICE: Double;
    BEST_BID_PRICE: Double;
    OPEN_PRICE: Double;
    HIGH_PRICE: Double;
    LOW_PRICE: Double;
    VOLUME: Double;
    TOTAL_VOLUME: Double;
    TOTAL_VALUE: Double;
    OPEN_VOLUME: Double;

    FOOTER: array [0 .. 4] of AnsiChar;
  end;
{$ALIGN 8}

  TMainForm = class(TForm)
    ActionList1: TActionList;
    Action_3001: TAction;
    ImageList1: TImageList;
    StatusBar: TStatusBar;
    TimerDisplay: TTimer;
    ReceiveSensor: CFNReceiveSensor;
    Action_GoSite: TAction;
    PanelWorkSpace: TPanel;
    MemoQuote: TMemo;
    TimerCheck: TTimer;
    TimerStart: TTimer;
    MemoMessage: TMemo;
    Splitter1: TSplitter;
    procedure StatusBarResize(Sender: TObject);
    procedure TimerDisplayTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Action_3001Update(Sender: TObject);
    procedure Action_3001Execute(Sender: TObject);
    procedure OnSecDisconnect(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
    procedure TimerCheckTimer(Sender: TObject);

  private

  private
    procedure SaveMainWindow();
    procedure RestoreMainWindow();

  private
    m_SecReConnecting: Boolean;

    m_TCPClient: TIdTCPClient;
    m_SocketLock: TCriticalSection;

    m_DataDelivery: CFNDataDelivery;
    m_QuoteData: TCMEQuoteData;
    m_bInitialize: Boolean;

    m_CountValue : Integer;

    procedure OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
    procedure OnStream(AStreamRecord: CFNStreamRecord);

    procedure OnSocketConnect(Sender: TObject);
    procedure OnSocketDisconnect(Sender: TObject);
    procedure SocketStatus(ASender: TObject; const aStatus: TIdStatus; const AStatusText: string);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  IniFiles, XMLIntf, xmldom, msxmldom, XMLDoc,
  FNRegistry, FNGlobalVariable, FNCMVariable, MXVariable,
  FNGlobal, Math, FNPOTCollection, DateUtils, FNReLoginDlg,
  FNMatrixReConnectDlg, FNSymbolCollection, FNMaterialCollection;

{$R *.dfm}

// ---------------------------------------------------------------------------
procedure TMainForm.OnSocketConnect(Sender: TObject);
begin
end;

// ---------------------------------------------------------------------------
procedure TMainForm.OnSocketDisconnect(Sender: TObject);
begin
end;

// ---------------------------------------------------------------------------
procedure TMainForm.SocketStatus(ASender: TObject; const aStatus: TIdStatus; const AStatusText: string);
begin

end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Application.Title := g_ApplicationName;
  m_DataDelivery := CFNDataDelivery.Create;
  m_DataDelivery.OnStreamEvent := OnStream; // 스트리밍 수신 이벤트 등록
  m_DataDelivery.OnReplyEvent := OnReply;

  m_SocketLock := TCriticalSection.Create;
  m_TCPClient := TIdTCPClient.Create(NIL);
  m_TCPClient.ReadTimeout := 50;
  m_TCPClient.Host := '127.0.0.1';
  m_TCPClient.Port := 3333;

  m_TCPClient.OnConnected := OnSocketConnect;
  m_TCPClient.OnDisconnected := OnSocketDisconnect;
  m_TCPClient.OnStatus := SocketStatus;

  m_SecReConnecting := false;

  m_CountValue := 0;

  RestoreMainWindow();
  ReceiveSensor.Start;

  g_AgentManager.OnDisconnect := OnSecDisconnect;

  StatusBar.Panels[1].Text := g_Version + ' ' + g_BuilderDate;
  StatusBar.Panels[2].Text := g_MatrixUserID + ' / ' + g_SecUserID;

  m_bInitialize := false;

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveMainWindow();
  ReceiveSensor.Stop;

  if Assigned(m_DataDelivery) then
  begin
    m_DataDelivery.Free;
    m_DataDelivery := NIL;
  end;

  if Assigned(m_TCPClient) then
  begin
    FreeAndNil(m_TCPClient);
    m_TCPClient := NIL;
  end;
  if Assigned(m_SocketLock) then
  begin
    FreeAndNil(m_SocketLock);
    m_SocketLock := NIL;
  end;
end;

{$REGION '메인 화면의 상태(최대,최소,일반), 크기, 위치를 저장하고 복원하는 부분'}

// ------------------------------------------------------------------------------
// 메인 화면의 상태(최대,최소,일반), 크기, 위치를 저장하는 부분
procedure TMainForm.SaveMainWindow();
var
  f_Registry: CFNRegistry;
  f_WindowState: Integer;
begin
  f_Registry := CFNRegistry.Create(Self);
  f_Registry.Company := g_CompanyName;
  f_Registry.ApplicationName := g_ApplicationName;

  if (WindowState = wsNormal) then
    f_WindowState := 0
  else if (WindowState = wsMinimized) then
    f_WindowState := 1
  else
    f_WindowState := 2;
  f_Registry.WriteInteger('MainWindow', 'WindowState', f_WindowState);

  if (WindowState = wsNormal) then
  begin
    f_Registry.WriteInteger('MainWindow', 'WindowLeft', Left);
    f_Registry.WriteInteger('MainWindow', 'WindowTop', Top);
    f_Registry.WriteInteger('MainWindow', 'WindowWidth', Width);
    f_Registry.WriteInteger('MainWindow', 'WindowHeight', Height);
  end;
end;

// ------------------------------------------------------------------------------
// 메인 화면의 상태(최대,최소,일반), 크기, 위치를 복원하는 부분
procedure TMainForm.RestoreMainWindow();
var
  f_Registry: CFNRegistry;
  f_WindowState: Integer;
  f_Left, f_Top, f_Width, f_Height: Integer;
var
  f_Screen_X: Integer;
  f_Screen_Y: Integer;
begin
  f_Screen_X := Windows.GetSystemMetrics(SM_CXSCREEN);
  f_Screen_Y := Windows.GetSystemMetrics(SM_CYSCREEN);

  f_Registry := CFNRegistry.Create(Self);
  f_Registry.Company := g_CompanyName;
  f_Registry.ApplicationName := g_ApplicationName;

  f_WindowState := f_Registry.ReadInteger('MainWindow', 'WindowState', 0);
  f_Left := f_Registry.ReadInteger('MainWindow', 'WindowLeft', -1);
  f_Top := f_Registry.ReadInteger('MainWindow', 'WindowTop', -1);
  f_Width := f_Registry.ReadInteger('MainWindow', 'WindowWidth', -1);
  f_Height := f_Registry.ReadInteger('MainWindow', 'WindowHeight', -1);

  if ((f_Left > 0) and (f_Top > 0) and (f_Width > 0) and (f_Height > 0) and (f_Left < f_Screen_X) and (f_Top < f_Screen_Y)) then
  begin
    Self.SetBounds(f_Left, f_Top, f_Width, f_Height);
  end;

  if (f_WindowState = 0) then
    WindowState := wsNormal
  else if (f_WindowState = 1) then
    WindowState := wsMinimized
  else
    WindowState := wsMaximized;

  f_Registry.Free;
end;
{$ENDREGION}

// ------------------------------------------------------------------------------------
procedure TMainForm.OnSecDisconnect(Sender: TObject);
begin
  // {$IFNDEF DEBUG}
  if not m_SecReConnecting then
  begin
    m_SecReConnecting := true;
    if not Assigned(ReLoginDlg) then
    begin
      ReLoginDlg := TReLoginDlg.Create(Application);
    end;

    if Sender = ReceiveSensor then
    begin
      LOG_WRITE(LOG_TYPE_INFO, 'TMainForm', '증권사와의 통신연결이 원활하지 않아 재연결을 시도합니다.');
    end;

    ReLoginDlg.ShowModal();
    g_AgentManager.ReSubscribeAll;
    LOG_WRITE(LOG_TYPE_INFO, 'TMainForm', '증권사와 통신이 재연결 되었습니다.');
    m_SecReConnecting := false;
  end;
  // {$ENDIF}
end;

// ------------------------------------------------------------------------------------
procedure TMainForm.StatusBarResize(Sender: TObject);
begin
  StatusBar.Panels[0].Width := StatusBar.Width - 660 - 20 * 3;
end;

// ------------------------------------------------------------------------------------
procedure TMainForm.TimerCheckTimer(Sender: TObject);
begin

  m_SocketLock.Enter;
  try
    if not m_TCPClient.Connected then
    begin
      try
        m_TCPClient.Connect;
      except
      end;
    end;
  finally
    m_SocketLock.Leave;
  end;

end;

procedure TMainForm.TimerDisplayTimer(Sender: TObject);
var
  f_Time1: TDateTime;
  f_CloseDateTime: TDateTime;
  f_Year, f_Month, f_Day, f_Hour, f_Min, f_Sec, f_MSec: Word;
  f_TimeDiffrence1: Double;
  f_TimeDiffrence2: Double;
  f_MaterialItem: CFNMaterialItem;
begin
  f_TimeDiffrence1 := 0;
  f_TimeDiffrence2 := 0;

  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(2, 2, 0, 'CME003_FN');

    f_TimeDiffrence1 := 0;
    if Assigned(f_MaterialItem) then
    begin
      f_TimeDiffrence1 := f_MaterialItem.m_TimeDiffrence;
      f_TimeDiffrence2 := f_MaterialItem.m_TimeDiffrence2;
    end;
  end;

  StatusBar.Panels[3].Text := TFNGlobal.DateTimeToStr6(TFNGlobal.ServerNow);
  StatusBar.Panels[4].Text := TFNGlobal.DateTimeToStr6(TFNGlobal.ServerNow + f_TimeDiffrence1);
  StatusBar.Panels[5].Text := TFNGlobal.DateTimeToStr6(TFNGlobal.ServerNow + f_TimeDiffrence2);
end;

procedure TMainForm.TimerStartTimer(Sender: TObject);
begin

  TimerStart.Enabled := false;

  MemoMessage.Lines.Insert(0, '----------------------------------------------------');
  MemoMessage.Lines.Insert(0, '[정보] 재시작은 이미 스케줄러에 등록이 되어 있습니다.');
  MemoMessage.Lines.Insert(0, '[정보] 오전7시에 재시작하도록 해야 합니다.');
  MemoMessage.Lines.Insert(0, '[정보] CME의 해외선물의 시세를 수신합니다.');
  MemoMessage.Lines.Insert(0, '----------------------------------------------------');

  m_bInitialize := true;

  m_SocketLock.Enter;
  try
    if not m_TCPClient.Connected then
    begin
      try
        m_TCPClient.Connect;
      except
      end;
    end;
  finally
    m_SocketLock.Leave;
  end;

  Action_3001Execute(Self);
  TimerCheck.Enabled := true;
end;

// ------------------------------------------------------------------------------------
procedure TMainForm.Action_3001Execute(Sender: TObject);
var
  LSymbolItem: CFNSymbolItem;
  LIndex: Integer;
begin
  if Assigned(g_AgentManager) then
  begin
    for LIndex := 0 to g_SymbolCollection.m_Items.Count - 1 do
    begin
      LSymbolItem := g_SymbolCollection.m_Items[LIndex];
      if (('ES' = LSymbolItem.m_SecSymbol) or ('NQ' = LSymbolItem.m_SecSymbol) or ('6E' = LSymbolItem.m_SecSymbol) or ('GC' = LSymbolItem.m_SecSymbol) or ('CL' = LSymbolItem.m_SecSymbol)) then
      //if  ('6E' = LSymbolItem.m_SecSymbol) then
      begin
        g_AgentManager.SubscribeQuote(m_DataDelivery, LSymbolItem.m_Country, LSymbolItem.m_Group, LSymbolItem.m_Market, LSymbolItem.m_SecSymbol + LSymbolItem.m_Contract);
      end;
    end;
  end;
end;

// ------------------------------------------------------------------------------------
procedure TMainForm.Action_3001Update(Sender: TObject);
begin //
end;

// ---------------------------------------------------------------------------
procedure TMainForm.OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
begin

end;

// ---------------------------------------------------------------------------
procedure TMainForm.OnStream(AStreamRecord: CFNStreamRecord);
begin
  if AStreamRecord.GetPacketKey <> 'QUOTE' then
    exit;

  try
    FillChar(m_QuoteData, sizeof(TCMEQuoteData), 0);
    m_QuoteData.COUNTRY_NO := AStreamRecord.GetIntegerValue('COUNTRY_NO');
    m_QuoteData.GROUP_NO := AStreamRecord.GetIntegerValue('GROUP_NO');
    m_QuoteData.MARKET_NO := AStreamRecord.GetIntegerValue('MARKET_NO');

    StrPCopy(m_QuoteData.SYMBOL, AStreamRecord.GetStringValue('SYMBOL'));
    StrPCopy(m_QuoteData.DATE, AStreamRecord.GetStringValue('DATE'));
    StrPCopy(m_QuoteData.TIME, AStreamRecord.GetStringValue('TIME'));

    m_QuoteData.PREV_CLOSE := AStreamRecord.GetDoubleValue('PREV_CLOSE');
    m_QuoteData.CLOSE_PRICE := AStreamRecord.GetDoubleValue('CLOSE_PRICE');
    m_QuoteData.CHANGE := AStreamRecord.GetDoubleValue('CHANGE');
    m_QuoteData.CHANGERATE := AStreamRecord.GetDoubleValue('CHANGERATE');

    m_QuoteData.BEST_OFFER_PRICE := AStreamRecord.GetDoubleValue('BEST_OFFER_PRICE');
    m_QuoteData.BEST_BID_PRICE := AStreamRecord.GetDoubleValue('BEST_BID_PRICE');

    m_QuoteData.OPEN_PRICE := AStreamRecord.GetDoubleValue('OPEN_PRICE');
    m_QuoteData.HIGH_PRICE := AStreamRecord.GetDoubleValue('HIGH_PRICE');
    m_QuoteData.LOW_PRICE := AStreamRecord.GetDoubleValue('LOW_PRICE');

    m_QuoteData.VOLUME := AStreamRecord.GetDoubleValue('VOLUME');
    m_QuoteData.TOTAL_VOLUME := AStreamRecord.GetDoubleValue('TOTAL_VOLUME');
    m_QuoteData.TOTAL_VALUE := AStreamRecord.GetDoubleValue('TOTAL_VALUE');
    m_QuoteData.OPEN_VOLUME := 0;

    StrLCopy(m_QuoteData.HEADER, 'BOQ'#$0D#$0A, 5);
    StrLCopy(m_QuoteData.FOOTER, 'EOQ'#$0D#$0A, 5);


    AStreamRecord.DecreaseReferenceCount;

    m_SocketLock.Enter;
    try
      if m_TCPClient.Connected then
      begin
        try
          m_TCPClient.IOHandler.WriteBufferOpen;
          m_TCPClient.IOHandler.Write(TIdBytes(@m_QuoteData), sizeof(TCMEQuoteData));
          m_TCPClient.IOHandler.WriteBufferFlush;
        finally
          m_TCPClient.IOHandler.WriteBufferClose;
        end;
      end;
    finally
      m_SocketLock.Leave;
    end;

    if (m_CountValue mod 50) = 0 then
    begin

      //if (Copy(m_QuoteData.SYMBOL, 0, 2) = '6E') then

      MemoQuote.Lines.Insert(0, m_QuoteData.SYMBOL + ' , ' + 'D : ' + m_QuoteData.DATE + ' , ' + 'T : ' + m_QuoteData.TIME + ' , ' + 'P : ' + TFNGlobal.NumberToString(m_QuoteData.CLOSE_PRICE, 4) + ' , ' + 'V : ' + TFNGlobal.NumberToString(m_QuoteData.TOTAL_VOLUME, 0) + ' , ' + 'O : ' + TFNGlobal.NumberToString(m_QuoteData.BEST_OFFER_PRICE, 4) + ' , ' + 'B : ' + TFNGlobal.NumberToString(m_QuoteData.BEST_BID_PRICE, 4));

      while MemoQuote.Lines.Count > 10 do
      begin
        MemoQuote.Lines.Delete(MemoQuote.Lines.Count - 1);
      end;
    end;

    Inc(m_CountValue);

    if (m_CountValue > 1000) then m_CountValue := 0;


  except
  end;
end;

end.
