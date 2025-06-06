program LaunchMXChartK;

uses
    Forms,
    FNCMVariable,
    MXVariable,
    Main in 'Main.pas' {MainForm},
    FNUpdaterDlg in 'FNUpdaterDlg.pas' {UpdaterDlg};

{$R *.res}
{$R *.rec}

begin
    Application.Initialize;

    g_CompanyName       := 'MatrixSystem';
    g_ApplicationName   := 'MXChartK';
    g_SecCode           := 'B';
    g_GradeCode         := 'X';

    g_AgentCode         := 'M';

    OPS_VERSION_INFO_URL:= 'http://210.116.104.82/Install/VERSION/VersionInfoMXC.aspx';

    Application.Title := g_ApplicationName;
    Application.CreateForm(TMainForm, MainForm);
    Application.Run;
end.
