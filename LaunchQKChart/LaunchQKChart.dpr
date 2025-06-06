program LaunchQKChart;

uses
    Forms,
    FNCMVariable,
    FNMXVariable,
    Main in 'Main.pas' {MainForm},
    FNUpdaterDlg in 'FNUpdaterDlg.pas' {UpdaterDlg};

{$R *.res}

begin
    Application.Initialize;

    g_CompanyName       := 'MatrixSystem';
    g_ApplicationName   := 'QuarkChart';
    g_SecCode           := 'B';
    g_GradeCode         := 'Q';

    g_AgentCode         := 'M';

    OPS_VERSION_INFO_URL:= 'http://210.116.114.219/PGM/VersionInfoMXC.aspx';

    Application.Title := g_ApplicationName;
    Application.CreateForm(TMainForm, MainForm);
    Application.Run;
end.
