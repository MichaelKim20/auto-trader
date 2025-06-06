program SKMatrix;

uses
  FNGlobal,
  FNLogManager,
  FNGlobalVariable,
  FNSocketManager,
  FNAgentManager,
  FNCMVariable,
  FNMXVariable,
  Forms,
  Controls,
  SDIMAIN in 'SDIMAIN.PAS' {SDIAppForm},
  SKMXChildFrame01 in 'SKMXChildFrame01.pas' {SKMXFrame01: TFrame},
  QuotItemUnit in 'QuotItemUnit.pas' {SKMXQuotItemFrame: TFrame},
  SKLoginDlg in 'SKLoginDlg.pas' {LoginDlg};

{$R *.RES}

var
    g_LogInDlgResult:Integer;
    g_OPSLogin:Boolean;
    g_SECLogin:Boolean;
begin
    g_CompanyName       := 'QuarkSystem';
    g_ApplicationName   := 'SK Q';
    g_SecCode           := 'D';
    g_GradeCode         := 'S';

    g_AgentCode         := 'M';
    g_PGMCode           := '04';

    g_Version           :=  '1.0039';
    g_BuilderDate       :=  '(2013년 11월 22일 16시 00분)';

    Application.Initialize;
    Application.Title   := g_ApplicationName;

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
            Application.CreateForm(TSDIAppForm, SDIAppForm);
            Application.Run;
        end;
    end;

    if not Assigned(g_SocketManager) then
    begin
        g_SocketManager.Free;
        g_SocketManager := NIL;
    end;

end.
 
