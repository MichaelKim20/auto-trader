program MXCmd;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  FNGlobal,
  FNLogManager,
  FNGlobalVariable,
  FNCMVariable,
  MXVariable,
  FNLoadController,
  FNLoadItem,
  FNSocketManager,
  FNAutoLogin in 'FNAutoLogin.pas',
  FNCalcBackTesting in 'FNCalcBackTesting.pas',
  FNCMDBackTesting in 'FNCMDBackTesting.pas',
  FNCMDAnlysisBuySell in 'FNCMDAnlysisBuySell.pas',
  FNCMDDailyReport in 'FNCMDDailyReport.pas',
  FNMainFunction in 'FNMainFunction.pas',
  FNCMDSort in 'FNCMDSort.pas';

var
    f_Command:String;
    f_AutoLogin:CFNAutoLogin;
    f_CmdBackTesting:CFNCMDBackTesting;
    f_StartDate:String;
    f_EndDate:String;
    f_ThreadCount:Integer;
    f_AttachMode:Boolean;

    f_TryIndex:Integer;
begin
    if ParamCount < 1 then
    begin
        WriteLn('파라메터의 갯수가 모자랍니다.');
        exit;
    end;

    g_UseStreamData     := false;
    g_AgentCode         := 'M';
    g_PGMCode           := '03';
{
    if not Assigned(g_LogMgr1) then
    begin
        g_LogMgr1 := CFNLogManager.Create();
        g_LogMgr1.Initialize(ExtractFilePath(ParamStr(0)) + 'log\', 'MXCMD_L1');
    end;

    if not Assigned(g_LogMgr2) then
    begin
        g_LogMgr2 := CFNLogManager.Create();
        g_LogMgr2.Initialize(ExtractFilePath(ParamStr(0)) + 'log\', 'MXCMD_L2');
    end;
}
    g_StreamServerIP    := '210.116.114.219';
    g_StreamServerIP    := '210.116.104.82';
    g_StreamServerPort  := 7795;

    g_SocketManager := CFNSocketManager.Create;
    g_SocketManager.Start;
    g_SocketManager.Resume;

    f_AutoLogin := CFNAutoLogin.Create;

    f_AutoLogin.Load;

    for f_TryIndex := 0 to 200-1 do
    begin
        if f_AutoLogin.Complete then break;
        Sleep(100);
    end;

    if f_AutoLogin.Complete then
    begin
        f_Command := ParamStr(1);

        if AnsiCompareText(f_Command, 'BackTasting') = 0 then
        begin
            DoBackTesting;
        end else
        if AnsiCompareText(f_Command, 'AnalysisBuySell') = 0 then
        begin
            DoAnalysisBuySell;
        end else
        if AnsiCompareText(f_Command, 'DailyReport') = 0 then
        begin
            DoDailyReport;
        end else
        if AnsiCompareText(f_Command, 'SORT') = 0 then
        begin
            DoSort;
        end else
        begin
            WriteLn('해당 명령어가 존재하지 않습니다.');
        end;
    end;
    f_AutoLogin.Free;

    if Assigned(g_SocketManager) then
    begin
        g_SocketManager.Free;
        g_SocketManager := NIL;
    end;
{
    if Assigned(g_LogMgr1) then
    begin
        g_LogMgr1.Free;
    end;

    if Assigned(g_LogMgr2) then
    begin
        g_LogMgr2.Free;
    end;
}
end.
