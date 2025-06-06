unit MXOption;

interface

uses
  Math, SysUtils, Classes, FNCMVariable, FNDataSet, FNPOTCollection,
  FNSymbolCollection, XMLIntf,
  MXTradeStrategyOptionCollection;

const
  SINAL_MERGE_TYPE_PROFIT1 = 0;
  SINAL_MERGE_TYPE_PROFIT2 = 1;
  SINAL_MERGE_TYPE_MATCH = 2;

  SYSTEM_MODE_SIMULATION = 0;
  SYSTEM_MODE_REAL = 1;

  FUTURES_POSITION_VALUE = 500000.0;

  PREVCHARTDATATYPE_ORIGNAL_GAPLESS = 0;
  PREVCHARTDATATYPE_OPENPRICE_GAPLESS = 1;
  PREVCHARTDATATYPE_ORIGNAL = 2;

type

  CMXOption = class(CFNRecord)
  private

    m_StrategyOptionCollection: CMXTradeStrategyOptionCollection;

  public

    m_POTItem: CFNPOTItem;

    // 생성자
    constructor Create;

    // 파괴자
    destructor Destroy; override;

    // 복제한다.
    procedure Clone(p_Source: CMXOption);

    // 복사한다.
    procedure CopyValue(p_Source: CMXOption);

    // XML문자에서 로딩한다.
    procedure Read(AXMLNode: IXMLNode);

    // XML문자로 저장한다.
    function Write: String;

    procedure DefaultValue;

    function IndexToTimeFrame(ATFIndex: Integer): Integer;
    function TimeFrameToIndex(ATimeFrame: Integer): Integer;

    function GetVirtualExchangeDateTime: TDateTime;
    function GetRealExchangeDateTime: TDateTime;

    property StrategyOptionCollection: CMXTradeStrategyOptionCollection read m_StrategyOptionCollection write m_StrategyOptionCollection;
  end;

implementation

uses FNGlobal, MXVariable, Variants;

// ---------------------------------------------------------------------------
// 생성자
constructor CMXOption.Create;
begin
  inherited Create;
  m_POTItem := CFNPOTItem.Create;
  m_StrategyOptionCollection := CMXTradeStrategyOptionCollection.Create;
  DefaultValue;
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CMXOption.Destroy;
begin
  m_POTItem.Free;
  m_POTItem := NIL;

  m_StrategyOptionCollection.Free;
  m_StrategyOptionCollection := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 복제한다.
procedure CMXOption.Clone(p_Source: CMXOption);
begin
  inherited Clone(p_Source);

  m_StrategyOptionCollection.Clone(p_Source.m_StrategyOptionCollection);
end;

// ---------------------------------------------------------------------------
// 복사한다.
procedure CMXOption.CopyValue(p_Source: CMXOption);
var
  f_Loop: Integer;

  f_SrcFieldValue: CFNFieldValue;
  f_TagFieldValue: CFNFieldValue;
  f_Key: String;
begin
  if not Assigned(p_Source) then
    exit;

  for f_Loop := 0 to FieldValues.Count - 1 do
  begin
    f_TagFieldValue := CFNFieldValue(FieldValues.Objects[f_Loop]);
    f_Key := FieldValues.Strings[f_Loop];
    if (RECORD_TYPE_DOUBLE = f_TagFieldValue.DataType) then
    begin
      SetDoubleValue(f_Key, p_Source.GetDoubleValue(f_Key));
    end
    else if (RECORD_TYPE_INTEGER = f_TagFieldValue.DataType) then
    begin
      SetIntegerValue(f_Key, p_Source.GetIntegerValue(f_Key));
    end
    else
    begin
      SetStringValue(f_Key, p_Source.GetStringValue(f_Key));
    end;
  end;
end;

// ------------------------------------------------------------------------------------
// XML형태의 문자열에서 읽어오다.
procedure CMXOption.Read(AXMLNode: IXMLNode);
var
  f_Index: Integer;
  f_ValueNode: IXMLNode;

  f_ValueIndex: Integer;

  f_DataType: String;
  f_Key: String;
begin
  ClearAll;
  m_StrategyOptionCollection.Clear;

  if AnsiCompareText('OPTION', AXMLNode.NodeName) = 0 then
  begin
    for f_ValueIndex := 0 to AXMLNode.ChildNodes.Count - 1 do
    begin
      f_ValueNode := AXMLNode.ChildNodes[f_ValueIndex];
      if not Assigned(f_ValueNode) then
        continue;

      if AnsiCompareText('VALUE', f_ValueNode.NodeName) = 0 then
      begin
        if f_ValueNode.HasAttribute('KEY') and f_ValueNode.HasAttribute('TYPE') then
        begin
          f_Key := f_ValueNode.Attributes['KEY'];
          f_DataType := f_ValueNode.Attributes['TYPE'];

          if AnsiCompareText('DOUBLE', f_DataType) = 0 then
          begin
            SetDoubleValue(f_Key, TFNGlobal.atof(VarToStr(f_ValueNode.NodeValue)));
          end
          else if AnsiCompareText('INTEGER', f_DataType) = 0 then
          begin
            SetIntegerValue(f_Key, TFNGlobal.atoi(VarToStr(f_ValueNode.NodeValue)));
          end
          else if AnsiCompareText('STRING', f_DataType) = 0 then
          begin
            SetStringValue(f_Key, VarToStr(f_ValueNode.NodeValue));
          end;
        end;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// XML문자열로 저장한다.
function CMXOption.Write: String;
var
  f_Stream: TStringStream;
  f_Index: Integer;
  f_FieldValue: CFNFieldValue;
  f_Key: String;
begin
  f_Stream := TStringStream.Create;

  f_Stream.WriteString('<OPTION>' + #$0A);

  for f_Index := 0 to FieldValues.Count - 1 do
  begin
    f_FieldValue := CFNFieldValue(FieldValues.Objects[f_Index]);
    f_Key := FieldValues.Strings[f_Index];
    if (RECORD_TYPE_DOUBLE = f_FieldValue.DataType) then
    begin
      f_Stream.WriteString('<VALUE KEY="' + f_Key + '" TYPE="DOUBLE">' + FloatToStr(GetDoubleValue(f_Key)) + '</VALUE>' + #$0A);
    end
    else if (RECORD_TYPE_INTEGER = f_FieldValue.DataType) then
    begin
      f_Stream.WriteString('<VALUE KEY="' + f_Key + '" TYPE="INTEGER">' + IntToStr(GetIntegerValue(f_Key)) + '</VALUE>' + #$0A);
    end
    else
    begin
      f_Stream.WriteString('<VALUE KEY="' + f_Key + '" TYPE="STRING"><![CDATA[' + GetStringValue(f_Key) + ']]></VALUE>' + #$0A);
    end;
  end;

  f_Stream.WriteString('</OPTION>' + #$0A);

  f_Stream.Position := 0;
  Result := f_Stream.ReadString(f_Stream.Size);
  f_Stream.Free;
end;

// ------------------------------------------------------------------------------------
procedure CMXOption.DefaultValue;
begin
{$REGION '계좌정보'}
  SetStringValue('ACCOUNT_NO', '');
  SetStringValue('ACCOUNT_PW', '');
{$ENDREGION}
{$REGION '종목정보'}
  SetIntegerValue('COUNTRY_NO', 1);
  SetIntegerValue('GROUP_NO', 4);
  SetIntegerValue('MARKET_NO', 0);
  SetStringValue('SYMBOL', '');
  SetStringValue('SEC_SYMBOL', '');
  SetStringValue('CONTRACT', '');
{$ENDREGION}
{$REGION '주문가격'}
  SetIntegerValue('ORDER_PRICETYPE', 3);
  SetIntegerValue('ORDER_COUNT', 1);
  SetIntegerValue('SECOND_ORDER_DELAY_TIME', 5);
{$ENDREGION}
{$REGION '매매시간'}
  if '04' = g_PGMCode then
  begin
    SetIntegerValue('START_OFFSET', 3);
    SetIntegerValue('STOP_OFFSET', 2);
    SetBooleanValue('USE_REGULAR_MARKET', false);
    SetIntegerValue('REGULAR_START_TIME', Trunc(EncodeTime(15, 30, 0, 0) * 86400000 + 0.5));
    SetIntegerValue('REGULAR_STOP_TIME', Trunc(EncodeTime(22, 00, 0, 0) * 86400000 + 0.5));
    SetDoubleValue('TIME_DIFFRENCE', 0);
  end
  else
  begin
    SetIntegerValue('START_OFFSET', 3);
    SetIntegerValue('STOP_OFFSET', 2);
    SetBooleanValue('USE_REGULAR_MARKET', true);
    SetIntegerValue('REGULAR_START_TIME', Trunc(EncodeTime(15, 30, 0, 0) * 86400000 + 0.5));
    SetIntegerValue('REGULAR_STOP_TIME', Trunc(EncodeTime(22, 00, 0, 0) * 86400000 + 0.5));
    SetDoubleValue('TIME_DIFFRENCE', 0);
  end;
{$ENDREGION}
{$REGION '갭처리'}
  if '04' = g_PGMCode then
  begin
    SetBooleanValue('USER_GAB_PROCESS', true);
    SetIntegerValue('GAB_INSERT_MIN', 180);
  end
  else
  begin
    SetBooleanValue('USER_GAB_PROCESS', false);
    SetIntegerValue('GAB_INSERT_MIN', 180);
  end;
{$ENDREGION}
{$REGION '매매시스템이름'}
  SetStringValue('BLOCK_NAME', '');
{$ENDREGION}
{$REGION '월물과 타임프레임'}
  SetIntegerValue('TIMEFRAME', 1);
{$ENDREGION}
{$REGION '시스템 주문 모드'}
  SetIntegerValue('SYSTEM_MODE', SYSTEM_MODE_SIMULATION);
{$ENDREGION}
{$REGION '추격주문'}
  SetIntegerValue('TICK_COUNT', 1);
  SetDoubleValue('TICK_STEP', 0.05);
{$ENDREGION}
{$REGION '매매규칙'}
  SetBooleanValue('ACTION_ON_START', true);
  SetBooleanValue('NOTRADE_FIRST_SIGNAL', false);
{$ENDREGION}
{$REGION '기준일'}
  SetBooleanValue('USE_STAND_DATE', false);
  SetIntegerValue('STAND_DATE', Trunc(Now));
{$ENDREGION}
{$REGION '손실 및 이익 정지'}
  if '04' = g_PGMCode then
  begin
    SetBooleanValue('USE_RISK_MAX_LOSS', false);
    SetDoubleValue('RISK_MAX_LOSS', -500000);

    SetBooleanValue('USE_RISK_MAX_PROFIT', false);
    SetDoubleValue('RISK_MAX_PROFIT', 5000000);

    SetBooleanValue('USE_REALTIME_RISK_CHECK', true);
  end
  else
  begin
    SetBooleanValue('USE_RISK_MAX_LOSS', false);
    SetDoubleValue('RISK_MAX_LOSS', -500);

    SetBooleanValue('USE_RISK_MAX_PROFIT', false);
    SetDoubleValue('RISK_MAX_PROFIT', 5000);

    SetBooleanValue('USE_REALTIME_RISK_CHECK', true);
  end;
{$ENDREGION}
{$REGION '매매시스템 자동 선정기준'}
  SetIntegerValue('SIGNAL_MERGE_TYPE', SINAL_MERGE_TYPE_PROFIT2);
{$ENDREGION}
{$REGION '매매시스템 자동 선정기준의 세부조건'}
  SetBooleanValue('MERGE_MATCH_EVERYBAR', true);
  SetBooleanValue('MMEBBeforFirstSignal', true);
  SetIntegerValue('MERGE_MATCH_COUNT', 1);
  SetBooleanValue('ChangeSystemValue', false);
{$ENDREGION}
{$REGION '매매시스템 자동선정 타이머'}
  SetBooleanValue('USE_CPTIMER', false);
  SetIntegerValue('CPINTERVAL', 0);

  SetBooleanValue('CP_A_0', true);
  SetBooleanValue('CP_A_1', false);
  SetBooleanValue('CP_A_2', false);
  SetBooleanValue('CP_A_3', false);
  SetBooleanValue('CP_A_4', false);

  SetIntegerValue('CP_T_0', 0);
  SetIntegerValue('CP_T_1', 1);
  SetIntegerValue('CP_T_2', 0);
  SetIntegerValue('CP_T_3', 0);
  SetIntegerValue('CP_T_4', 0);

  SetIntegerValue('CP_S_0', 60);
  SetIntegerValue('CP_S_1', 60);
  SetIntegerValue('CP_S_2', 60);
  SetIntegerValue('CP_S_3', 60);
  SetIntegerValue('CP_S_4', 60);

  SetIntegerValue('CP_V_0', 3);
  SetIntegerValue('CP_V_1', 10);
  SetIntegerValue('CP_V_2', 10);
  SetIntegerValue('CP_V_3', 10);
  SetIntegerValue('CP_V_4', 10);
{$ENDREGION}
end;

// ------------------------------------------------------------------------------------
function CMXOption.IndexToTimeFrame(ATFIndex: Integer): Integer;
begin
  Result := 30;
  case ATFIndex of
    0:
      Result := 9010;
    1:
      Result := 9020;
    2:
      Result := 9030;
    3:
      Result := 9050;
    4:
      Result := 1;
    5:
      Result := 2;
    6:
      Result := 3;
    7:
      Result := 5;
    8:
      Result := 10;
    9:
      Result := 15;
    10:
      Result := 20;
    11:
      Result := 30;
    12:
      Result := 60;
    13:
      Result := 360;
  end;
end;

// ------------------------------------------------------------------------------------
function CMXOption.TimeFrameToIndex(ATimeFrame: Integer): Integer;
begin
  Result := 11;
  case ATimeFrame of
    9010:
      Result := 0;
    9020:
      Result := 1;
    9030:
      Result := 2;
    9050:
      Result := 3;
    1:
      Result := 4;
    2:
      Result := 5;
    3:
      Result := 6;
    5:
      Result := 7;
    10:
      Result := 8;
    15:
      Result := 9;
    20:
      Result := 10;
    30:
      Result := 11;
    60:
      Result := 12;
    360:
      Result := 13;
  end;
end;

// ---------------------------------------------------------------------------
function CMXOption.GetVirtualExchangeDateTime: TDateTime;
begin
  Result := TFNGlobal.ServerNow + GetDoubleValue('TIME_DIFFRENCE');
end;

// ---------------------------------------------------------------------------
function CMXOption.GetRealExchangeDateTime: TDateTime;
begin
  Result := TFNGlobal.ServerNow + GetDoubleValue('TIME_DIFFRENCE2');
end;

end.
