unit AgentGlobalVariable;

interface

uses
  Windows, Classes, Messages, HDFCommAgentLib_TLB, FNHDAgentManager,
  FNCMVariable, MXVariable;

var
  g_HDCommAgent: THDFCommAgent;
  g_HDAgentManager: CFNHDAgentManager;

  // procedure MyAppMessage(var Msg: TMsg; var Handled: Boolean);

implementation

procedure MyAppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  // if 0 = g_WRCommAgent.OCommLogin(g_SecUserID, g_SecUserPW, g_SecCertPW) then
  // begin
  // //done := true;
  // end;
end;

end.
