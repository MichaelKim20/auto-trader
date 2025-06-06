program MXQuote;

uses
  ActiveX,
  HDFCommAgentLib_TLB,
  FNHDAgentManager,
  WinProcs,
  SysUtils,
  FNGlobal,
  FNLogManager,
  FNCMVariable,
  MXVariable,
  FNSocketManager,
  FNAgentManager,
  FNVirtualTradeManager,
  MXTradeStrategyOptionCollection,
  MXTSVariable,
  Forms,
  Controls,
  MKTradeStrategyConst,
  SDIMAIN in 'SDIMAIN.PAS' {MainForm} ,
  AgentGlobalVariable in 'AgentGlobalVariable.pas',
  FNAgentDlg in 'FNAgentDlg.pas' {AgentDlg} ,
  FNLoginDlg in 'FNLoginDlg.pas' {LoginDlg} ,
  FNReLoginDlg in 'FNReLoginDlg.pas' {ReLoginDlg} ,
  FNUpdaterDlg in '..\Sources\S\Dialog\FNUpdaterDlg.pas' {UpdaterDlg} ,
  FNMatrixReConnectDlg in '..\Sources\S\Dialog\FNMatrixReConnectDlg.pas' {MatrixReConnectDlg} ,
  Vcl.Themes,
  Vcl.Styles;

{$R *.RES}

var
  g_LogInDlgResult: Integer;
  g_OPSLogin: Boolean;
  g_SECLogin: Boolean;
  g_Path: array [0 .. 256] of WideChar;

begin
  g_Language := 0;

  g_AutoRun := true;

  g_AutoRunConfig.m_MatrixUserID := 'mxdev';
  g_AutoRunConfig.m_MatrixUserPW := '1111';

  g_AutoRunConfig.m_SecUserID := 'sky09377';
  g_AutoRunConfig.m_SecUserPW := 'sky0642';
  g_AutoRunConfig.m_CertPW := '';
  g_AutoRunConfig.m_TradeMode := 'VT';

  g_CompanyName := 'ABLE';
  g_ApplicationName := 'MXQuote';
  g_SecCode := 'H';

  g_PGMCode := '13';

  g_EnableMarketOrder := true;
  g_EnablePartCancelOrder := false;

  Application.Initialize;
  Application.Title := g_ApplicationName;
  Randomize;

  g_Version := '6.230';
  g_BuilderDate := '(2015년 8월 25일 12시 00분)';

  if not Assigned(g_LogMgr1) then
  begin
    g_LogMgr1 := CFNLogManager.Create();
    g_LogMgr1.Initialize(ExtractFilePath(ParamStr(0)) + 'log\', TMXGlobal.GetSessionID + '_L1');
  end;

  if not Assigned(g_LogMgr2) then
  begin
    g_LogMgr2 := CFNLogManager.Create();
    g_LogMgr2.Initialize(ExtractFilePath(ParamStr(0)) + 'log\', TMXGlobal.GetSessionID + '_L2');
  end;

  g_StreamServerIP := '210.116.104.82';
  g_StreamServerPort := 7795;

  g_HDAgentManager := CFNHDAgentManager.Create;
  g_AgentManager := g_HDAgentManager;

  g_AgentManager.Start;
  g_AgentManager.Resume;

  g_SocketManager := CFNSocketManager.Create;
  g_SocketManager.Start;
  g_SocketManager.Resume;

  AgentDlg := TAgentDlg.Create(Application);
  AgentDlg.Left := -2000;
  AgentDlg.Top := -2000;
  AgentDlg.Show;

  LoginDlg := TLoginDlg.Create(Application);
  g_LogInDlgResult := LoginDlg.ShowModal();
  g_OPSLogin := LoginDlg.OPSLogin;
  g_SECLogin := LoginDlg.SECLogin;
  // LoginDlg.Free;

  if Assigned(g_SocketManager) then
  begin
    g_SocketManager.Stop;
    g_SocketManager.Free;
    g_SocketManager := NIL;
  end;

  if g_LogInDlgResult = mrOK then
  begin
    if g_OPSLogin and g_SECLogin then
    begin
      Application.CreateForm(TMainForm, MainForm);
      Application.Run;

      g_HDCommAgent.CommLogout(g_SecUserID);
      g_HDCommAgent.CommTerminate(1);
    end;
  end;

  // g_HDCommAgent.OnOSocketStatus := NIL;

  AgentDlg.Close;

  if Assigned(g_SocketManager) then
  begin
    g_SocketManager.Free;
    g_SocketManager := NIL;
  end;

  if Assigned(g_AgentManager) then
  begin
    g_AgentManager.Free;
    g_AgentManager := NIL;
  end;

  if Assigned(g_LogMgr1) then
  begin
    g_LogMgr1.Free;
  end;

  if Assigned(g_LogMgr2) then
  begin
    g_LogMgr2.Free;
  end;

end.
