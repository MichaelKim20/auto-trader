program QuarkChart;

uses
  WinProcs,
  SysUtils,
  FNGlobal,
  FNLogManager,
  FNGlobalVariable,
  FNSocketManager,
  FNAgentManager,
  FNCMVariable,
  MXVariable,
  MXTSVariable,
  MXTradeStrategyOptionCollection,
  Forms,
  Controls,
  TSSTC_T3_Frame in '..\Sources\MXChart\TS\TSSTC_T3_Frame.pas' {STC_T3_Frame: TFrame},
  TSBASELINE_N1_Frame in '..\Sources\MXChart\TS\TSBASELINE_N1_Frame.pas' {BASELINE_N1_Frame: TFrame},
  TSBASELINE_T1_Frame in '..\Sources\MXChart\TS\TSBASELINE_T1_Frame.pas' {BASELINE_T1_Frame: TFrame},
  TSBASELINE_T2_Frame in '..\Sources\MXChart\TS\TSBASELINE_T2_Frame.pas' {BASELINE_T2_Frame: TFrame},
  TSBB_T1_Frame in '..\Sources\MXChart\TS\TSBB_T1_Frame.pas' {BB_T1_Frame: TFrame},
  TSREL_T1_Frame in '..\Sources\MXChart\TS\TSREL_T1_Frame.pas' {REL_T1_Frame: TFrame},
  TSDISPARITY_T1_Frame in '..\Sources\MXChart\TS\TSDISPARITY_T1_Frame.pas' {DISPARITY_T1_Frame: TFrame},
  TSIM_T1_Frame in '..\Sources\MXChart\TS\TSIM_T1_Frame.pas' {IM_T1_Frame: TFrame},
  TSIM_T2_Frame in '..\Sources\MXChart\TS\TSIM_T2_Frame.pas' {IM_T2_Frame: TFrame},
  TSIM_T3_Frame in '..\Sources\MXChart\TS\TSIM_T3_Frame.pas' {IM_T3_Frame: TFrame},
  TSMOV_N1_Frame in '..\Sources\MXChart\TS\TSMOV_N1_Frame.pas' {MOV_N1_Frame: TFrame},
  TSMOV_N2_Frame in '..\Sources\MXChart\TS\TSMOV_N2_Frame.pas' {MOV_N2_Frame: TFrame},
  TSMOV_T3_Frame in '..\Sources\MXChart\TS\TSMOV_T3_Frame.pas' {MOV_T3_Frame: TFrame},
  TSMOV_T2_Frame in '..\Sources\MXChart\TS\TSMOV_T2_Frame.pas' {MOV_T2_Frame: TFrame},
  TSRSI_N1_Frame in '..\Sources\MXChart\TS\TSRSI_N1_Frame.pas' {RSI_N1_Frame: TFrame},
  TSRSI_T1_Frame in '..\Sources\MXChart\TS\TSRSI_T1_Frame.pas' {RSI_T1_Frame: TFrame},
  TSSelPriceLineDlg in '..\Sources\MXChart\TS\TSSelPriceLineDlg.pas' {SelPriceLineDlg},
  TSSTC_N1_Frame in '..\Sources\MXChart\TS\TSSTC_N1_Frame.pas' {STC_N1_Frame: TFrame},
  TSSTC_N2_Frame in '..\Sources\MXChart\TS\TSSTC_N2_Frame.pas' {STC_N2_Frame: TFrame},
  TSMKI_T1_Frame in '..\Sources\MXChart\TS\TSMKI_T1_Frame.pas' {MKI_T1_Frame: TFrame},
  TSSTC_T2_Frame in '..\Sources\MXChart\TS\TSSTC_T2_Frame.pas' {STC_T2_Frame: TFrame},
  TSDISPARITY_N1_Frame in '..\Sources\MXChart\TS\TSDISPARITY_N1_Frame.pas' {DISPARITY_N1_Frame: TFrame},
  COND_TradingHour_Frame in '..\Sources\MXChart\TS\COND_TradingHour_Frame.pas' {TradingHour_Frame: TFrame},
  COND_REINFORCE_Frame in '..\Sources\MXChart\TS\COND_REINFORCE_Frame.pas' {REINFORCE_Frame: TFrame},
  COND_Exit_Frame in '..\Sources\MXChart\TS\COND_Exit_Frame.pas' {Exit_Frame: TFrame},
  COND_Random_Frame in '..\Sources\MXChart\TS\COND_Random_Frame.pas' {Random_Frame: TFrame},
  SDIMain in '..\Sources\MXChart\Form\SDIMain.pas' {SDIMainForm},
  MXChangeStandDateDlg in '..\Sources\MXChart\Form\MXChangeStandDateDlg.pas' {ChangeStandDateDlg},
  MXLoginDlg in '..\Sources\MXChart\Form\MXLoginDlg.pas' {LoginDlg},
  MXChildFrame0100 in '..\Sources\MXChart\Frame\MXChildFrame0100.pas' {ChildFrame0100: TFrame},
  TSSTC_T1_Frame in '..\Sources\MXChart\TS\TSSTC_T1_Frame.pas' {STC_T1_Frame: TFrame},
  TSMOV_T1_Frame in '..\Sources\MXChart\TS\TSMOV_T1_Frame.pas' {MOV_T1_Frame: TFrame};

{$R *.RES}

var
    g_LogInDlgResult:Integer;
    g_OPSLogin:Boolean;
    g_SECLogin:Boolean;
begin
    g_CompanyName       := 'MatrixSystem';
    g_ApplicationName   := 'QuarkChart';
    g_SecCode           := 'B';
    g_GradeCode         := 'S';

    g_AgentCode         := 'M';
    g_PGMCode           := '04';

    g_Version           :=  '1.0053';
    g_BuilderDate       :=  '(2013년 11월 28일 18시 00분)';

    Application.Initialize;
    Application.Title   := g_ApplicationName;

    Randomize;

    g_StrategyOptionFileName := ExtractFilePath(ParamStr(0)) +  'TradeStrategyOption_20131128.config';
    if not Assigned(g_StrategyOptionCollection) then
    begin
        g_StrategyOptionCollection := CMXTradeStrategyOptionCollection.Create;
        g_StrategyOptionCollection.LoadFromFile(g_StrategyOptionFileName);
    end else
    begin
        g_StrategyOptionCollection.LoadFromFile(g_StrategyOptionFileName);
    end;

(*
    if not Assigned(g_LogMgr1) then
    begin
        g_LogMgr1 := CFNLogManager.Create();
        g_LogMgr1.Initialize(ExtractFilePath(ParamStr(0)) + 'log\', CFNMXGlobal.GetSessionID +'_L1');
    end;

    if not Assigned(g_LogMgr2) then
    begin
        g_LogMgr2 := CFNLogManager.Create();
        g_LogMgr2.Initialize(ExtractFilePath(ParamStr(0)) + 'log\', CFNMXGlobal.GetSessionID +'_L2');
    end;
*)

    g_StreamServerIP        := '210.116.114.219';
    //g_StreamServerIP      := '127.0.0.1';
    g_StreamServerPort      := 7795;

    g_SocketManager :=  CFNSocketManager.Create;
    g_SocketManager.Start;
    g_SocketManager.Resume;

    LoginDlg := TLoginDlg.Create(Application);
    g_LogInDlgResult := LoginDlg.ShowModal();
    g_OPSLogin := LoginDlg.OPSLogin;
    g_SECLogin := LoginDlg.SECLogin;
    LoginDlg.Free;

    if g_LogInDlgResult = mrOK then
    begin
        if g_OPSLogin and g_SECLogin then
        begin
            Application.CreateForm(TSDIMainForm, SDIMainForm);
            Application.Run;
        end;
    end;

    if not Assigned(g_SocketManager) then
    begin
        g_SocketManager.Free;
        g_SocketManager := NIL;
    end;

(*
    if not Assigned(g_LogMgr1) then
    begin
        g_LogMgr1.Free;
        g_LogMgr1 := NIL;
    end;
    if not Assigned(g_LogMgr2) then
    begin
        g_LogMgr2.Free;
        g_LogMgr2 := NIL;
    end;
*)

    if not Assigned(g_StrategyOptionCollection) then
    begin
        g_StrategyOptionCollection.Free;
        g_StrategyOptionCollection := NIL;
    end;
end.


