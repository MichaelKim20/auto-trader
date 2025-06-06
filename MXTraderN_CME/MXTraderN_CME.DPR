program MXTraderN_CME;

uses
  COMMOCXLib_TLB,
  H5MGREXLib_TLB,
  FNHNCMEAgentManager,
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
  SDIMAIN in 'SDIMAIN.PAS' {MainForm},
  AgentGlobalVariable in 'AgentGlobalVariable.pas',
  FNAgentDlg in 'FNAgentDlg.pas' {AgentDlg},
  FNLoginDlg in 'FNLoginDlg.pas' {LoginDlg},
  FNReLoginDlg in 'FNReLoginDlg.pas' {ReLoginDlg},
  FNBlockItemControl in '..\Sources\S\Classes\FNBlockItemControl.pas',
  FNUpdaterDlg in '..\Sources\S\Dialog\FNUpdaterDlg.pas' {UpdaterDlg},
  FNChangeStandDateDlg in '..\Sources\S\Dialog\FNChangeStandDateDlg.pas' {ChangeStandDateDlg},
  FNMatrixReConnectDlg in '..\Sources\S\Dialog\FNMatrixReConnectDlg.pas' {MatrixReConnectDlg},
  FNSystemItemViewFrame in '..\Sources\S\Frame\FNSystemItemViewFrame.pas' {SystemItemViewFrame: TFrame},
  FNBlockContentFrame in '..\Sources\S\Frame\FNBlockContentFrame.pas' {BlockContentFrame: TFrame},
  FNMatrixChartFrame in '..\Sources\S\Frame\FNMatrixChartFrame.pas' {MatrixChartFrame: TFrame},
  FNMatrixManageChartFrame in '..\Sources\S\Frame\FNMatrixManageChartFrame.pas' {MatrixManageChartFrame: TFrame},
  FNMatrixOptionFrame in '..\Sources\S\Frame\FNMatrixOptionFrame.pas' {MatrixOptionFrame: TFrame},
  TSSTC_T3_Frame in '..\Sources\S\TS\TSSTC_T3_Frame.pas' {STC_T3_Frame: TFrame},
  COND_Enter_Frame in '..\Sources\S\TS\COND_Enter_Frame.pas' {ENTER_Frame: TFrame},
  COND_Exit_Frame in '..\Sources\S\TS\COND_Exit_Frame.pas' {Exit_Frame: TFrame},
  COND_Random_Frame in '..\Sources\S\TS\COND_Random_Frame.pas' {Random_Frame: TFrame},
  COND_REINFORCE_Frame in '..\Sources\S\TS\COND_REINFORCE_Frame.pas' {REINFORCE_Frame: TFrame},
  COND_TradingHour_Frame in '..\Sources\S\TS\COND_TradingHour_Frame.pas' {TradingHour_Frame: TFrame},
  TSBASELINE_N1_Frame in '..\Sources\S\TS\TSBASELINE_N1_Frame.pas' {BASELINE_N1_Frame: TFrame},
  TSBASELINE_T1_Frame in '..\Sources\S\TS\TSBASELINE_T1_Frame.pas' {BASELINE_T1_Frame: TFrame},
  TSBASELINE_T2_Frame in '..\Sources\S\TS\TSBASELINE_T2_Frame.pas' {BASELINE_T2_Frame: TFrame},
  TSBB_T1_Frame in '..\Sources\S\TS\TSBB_T1_Frame.pas' {BB_T1_Frame: TFrame},
  TSDISPARITY_N1_Frame in '..\Sources\S\TS\TSDISPARITY_N1_Frame.pas' {DISPARITY_N1_Frame: TFrame},
  TSDISPARITY_T1_Frame in '..\Sources\S\TS\TSDISPARITY_T1_Frame.pas' {DISPARITY_T1_Frame: TFrame},
  TSIM_T1_Frame in '..\Sources\S\TS\TSIM_T1_Frame.pas' {IM_T1_Frame: TFrame},
  TSIM_T2_Frame in '..\Sources\S\TS\TSIM_T2_Frame.pas' {IM_T2_Frame: TFrame},
  TSIM_T3_Frame in '..\Sources\S\TS\TSIM_T3_Frame.pas' {IM_T3_Frame: TFrame},
  TSMKI_T1_Frame in '..\Sources\S\TS\TSMKI_T1_Frame.pas' {MKI_T1_Frame: TFrame},
  TSMOV_N1_Frame in '..\Sources\S\TS\TSMOV_N1_Frame.pas' {MOV_N1_Frame: TFrame},
  TSMOV_N2_Frame in '..\Sources\S\TS\TSMOV_N2_Frame.pas' {MOV_N2_Frame: TFrame},
  TSMOV_T1_Frame in '..\Sources\S\TS\TSMOV_T1_Frame.pas' {MOV_T1_Frame: TFrame},
  TSMOV_T2_Frame in '..\Sources\S\TS\TSMOV_T2_Frame.pas' {MOV_T2_Frame: TFrame},
  TSMOV_T3_Frame in '..\Sources\S\TS\TSMOV_T3_Frame.pas' {MOV_T3_Frame: TFrame},
  TSREL_T1_Frame in '..\Sources\S\TS\TSREL_T1_Frame.pas' {REL_T1_Frame: TFrame},
  TSRSI_N1_Frame in '..\Sources\S\TS\TSRSI_N1_Frame.pas' {RSI_N1_Frame: TFrame},
  TSRSI_T1_Frame in '..\Sources\S\TS\TSRSI_T1_Frame.pas' {RSI_T1_Frame: TFrame},
  TSSelPriceLineDlg in '..\Sources\S\TS\TSSelPriceLineDlg.pas' {SelPriceLineDlg},
  TSSTC_N1_Frame in '..\Sources\S\TS\TSSTC_N1_Frame.pas' {STC_N1_Frame: TFrame},
  TSSTC_N2_Frame in '..\Sources\S\TS\TSSTC_N2_Frame.pas' {STC_N2_Frame: TFrame},
  TSSTC_T1_Frame in '..\Sources\S\TS\TSSTC_T1_Frame.pas' {STC_T1_Frame: TFrame},
  TSSTC_T2_Frame in '..\Sources\S\TS\TSSTC_T2_Frame.pas' {STC_T2_Frame: TFrame},
  FNMatrixSumaryOptionFrame in '..\Sources\S\Frame\FNMatrixSumaryOptionFrame.pas',
  TradeListUnit in 'TradeListUnit.pas' {TradeListDlg},
  FNAccountPWDlg in 'FNAccountPWDlg.pas' {AccountPWDlg};

{$R *.RES}


var
    g_LogInDlgResult:Integer;
    g_OPSLogin:Boolean;
    g_SECLogin:Boolean;
begin
    g_Language          := 0;
    if (g_Language = 0) then
    begin
        TSOPTION_VALUE_STAND        :=  '기본값';
        TSOPTION_VALUE_FAVORITE     :=  '자주사용';
    end else
    begin
        TSOPTION_VALUE_STAND        :=  'Default';
        TSOPTION_VALUE_FAVORITE     :=  'Favorite';
    end;

    g_CompanyName       := 'ABLE';
    g_ApplicationName   := 'MXTraderN-CME';
    g_SecCode           := 'N';
    g_GradeCode         := 'S';

    g_AgentCode         := 'M';
    g_PGMCode           := '13';

    g_UseStreamData         := true;
    g_EnableMarketOrder     := true;
    g_EnablePartCancelOrder := false;

    Application.Initialize;
    Application.Title := g_ApplicationName;
    Randomize;

    TMXGlobal.CheckAutoRun;

    g_StrategyOptionFileName := ExtractFilePath(ParamStr(0)) +  'TradeStrategyOption_20140702.config';
    if not Assigned(g_StrategyOptionCollection) then
    begin
        g_StrategyOptionCollection := CMXTradeStrategyOptionCollection.Create;
        g_StrategyOptionCollection.LoadFromFile(g_StrategyOptionFileName);
    end else
    begin
        g_StrategyOptionCollection.LoadFromFile(g_StrategyOptionFileName);
    end;

    g_Version           :=  '6.230';
    g_BuilderDate       :=  '(2015년 8월 25일 12시 00분)';

    if not Assigned(g_LogMgr1) then
    begin
        g_LogMgr1 := CFNLogManager.Create();
        g_LogMgr1.Initialize(ExtractFilePath(ParamStr(0)) + 'log\', TMXGlobal.GetSessionID +'_L1');
    end;

    if not Assigned(g_LogMgr2) then
    begin
        g_LogMgr2 := CFNLogManager.Create();
        g_LogMgr2.Initialize(ExtractFilePath(ParamStr(0)) + 'log\', TMXGlobal.GetSessionID +'_L2');
    end;

    g_StreamServerIP    := '210.116.104.82';
    g_StreamServerPort  := 7795;

    g_SocketManager := CFNSocketManager.Create;
    g_SocketManager.Start;
    g_SocketManager.Resume;

    g_VirtualTradeManager := CFNVirtualTradeManager.Create;
    g_VirtualTradeManager.Start;
    g_VirtualTradeManager.Resume;

    AgentDlg := TAgentDlg.Create(Application);
    AgentDlg.Left := - 200;
    AgentDlg.Top  := - 200;
    AgentDlg.Show;

    g_WRAgentManager    := CFNHNCMEAgentManager.Create;
    g_WRAgentManager.AssignAgent(g_WRCommAgent);
    g_WRAgentManager.AssignH5Agent(g_H5MgrEx);

    g_AgentManager      := g_WRAgentManager;

    g_AgentManager.Start;
    g_AgentManager.Resume;

    LoginDlg := TLoginDlg.Create(Application);
    g_LogInDlgResult := LoginDlg.ShowModal();
    g_OPSLogin := LoginDlg.OPSLogin;
    g_SECLogin := LoginDlg.SECLogin;
    //LoginDlg.Free;

    if g_LogInDlgResult = mrOK then
    begin
        if g_OPSLogin and g_SECLogin then
        begin
            Application.CreateForm(TMainForm, MainForm);
            Application.Run;
        end;
    end;

    g_WRCommAgent.OnOSocketStatus := NIL;
    //AgentDlg.Close;

    if Assigned(g_SocketManager) then
    begin
        g_SocketManager.Free;
        g_SocketManager := NIL;
    end;

    if Assigned(g_VirtualTradeManager) then
    begin
        g_VirtualTradeManager.Free;
        g_VirtualTradeManager := NIL;
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

    if Assigned(g_StrategyOptionCollection) then
    begin
        g_StrategyOptionCollection.Free;
        g_StrategyOptionCollection := NIL;
    end;

end.
