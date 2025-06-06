unit MXTSVariable;

interface

uses
  Windows, Classes, SysUtils, MXTradeStrategyOptionCollection;

var
  g_StrategyOptionCollection: CMXTradeStrategyOptionCollection;
  g_StrategyOptionFileName: String;

implementation

uses FNGlobal, FNCMVariable;

// ---------------------------------------------------------------------------
Initialization

begin
  g_StrategyOptionCollection := CMXTradeStrategyOptionCollection.Create;
  g_StrategyOptionFileName := ExtractFilePath(ParamStr(0)) + 'TradeStrategyOption_20131011.config'
end;

// ---------------------------------------------------------------------------
Finalization

begin
end;
// ---------------------------------------------------------------------------

end.
