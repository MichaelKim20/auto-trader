unit MKTradeStrategyConst;

interface

const

  TSOPTION_KEY_CATEGORY = 'CATEGORY';
  TSOPTION_KEY_NAME = 'NAME';
  TSOPTION_KEY_TYPE = 'TYPE';
  TSOPTION_KEY_MAJORVALUE = 'MAJOR_VALUE';

  TRADE_STRATEGY_OPTION_REAL = 0;
  TRADE_STRATEGY_OPTION_VIRTUAL = 1;

  TSOPTION_VALUE_MAJOR_PRICE = 0;
  TSOPTION_VALUE_MAJOR_OPS = 1;
  TSOPTION_VALUE_MAJOR_OPS2 = 2;

var
  TSOPTION_VALUE_STAND: String;
  TSOPTION_VALUE_FAVORITE: String;

implementation

uses FNCMVariable;

Initialization

begin
  if (g_Language = 0) then
  begin
    TSOPTION_VALUE_STAND := '기본값';
    TSOPTION_VALUE_FAVORITE := '자주사용';
  end
  else
  begin
    TSOPTION_VALUE_STAND := 'Default';
    TSOPTION_VALUE_FAVORITE := 'Favorite';
  end;
end;

end.
