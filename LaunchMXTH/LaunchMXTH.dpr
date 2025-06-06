program LaunchMXTH;

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
    g_ApplicationName   := 'MXTraderH_CME';
    g_SecCode           := 'H';
    g_GradeCode         := 'S';

    g_AgentCode         := 'M';

    OPS_VERSION_INFO_URL:= 'http://210.116.104.82/INSTALL/VERSION/VersionInfoPGM.aspx';

    Application.Title := g_ApplicationName;
    Application.CreateForm(TMainForm, MainForm);
    Application.Run;
end.
