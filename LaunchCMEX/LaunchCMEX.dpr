program LaunchCMEX;

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

    g_CompanyName       := 'ABLE';
    g_ApplicationName   := 'CMEX';
    g_SecCode           := 'X';

    OPS_VERSION_INFO_URL:= 'http://210.116.104.82:5000/INSTALL/VERSION/VersionInfoCMEX.aspx';

    Application.Title := g_ApplicationName;
    Application.CreateForm(TMainForm, MainForm);
    Application.Run;
end.
