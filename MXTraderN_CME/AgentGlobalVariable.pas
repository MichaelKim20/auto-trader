unit AgentGlobalVariable;

interface

uses
    Windows, Classes, Messages, H5MGREXLib_TLB, COMMOCXLib_TLB, FNHNCMEAgentManager;

var
    g_H5MgrEx: TH5MgrEx;
    g_WRCommAgent:TCommOCX;
    g_WRAgentManager:CFNHNCMEAgentManager;
    g_WRSecUserName:String;
    g_WRSecPassWord:String;

implementation

end.