unit MXSumaryOption;

interface

uses
  Math, SysUtils, Classes, FNCMVariable, FNDataSet, XMLIntf,
  MXTradeStrategyOptionCollection;

type

  CMXSumaryOption = class(CFNRecord)
  private

    m_StrategyOptionCollection: CMXTradeStrategyOptionCollection;

  public

    // 생성자
    constructor Create;

    // 파괴자
    destructor Destroy; override;

    // 복제한다.
    procedure Clone(p_Source: CMXSumaryOption);

    // 복사한다.
    procedure CopyValue(p_Source: CMXSumaryOption);

    // XML문자에서 로딩한다.
    procedure Read(AXMLNode: IXMLNode);

    // XML문자로 저장한다.
    function Write: String;

    procedure DefaultValue;

    property StrategyOptionCollection: CMXTradeStrategyOptionCollection read m_StrategyOptionCollection write m_StrategyOptionCollection;
  end;

implementation

uses FNGlobal, MXVariable, Variants;

// ---------------------------------------------------------------------------
// 생성자
constructor CMXSumaryOption.Create;
begin
  inherited Create;
  m_StrategyOptionCollection := CMXTradeStrategyOptionCollection.Create;
  DefaultValue;
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CMXSumaryOption.Destroy;
begin
  m_StrategyOptionCollection.Free;
  m_StrategyOptionCollection := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 복제한다.
procedure CMXSumaryOption.Clone(p_Source: CMXSumaryOption);
begin
  inherited Clone(p_Source);

  m_StrategyOptionCollection.Clone(p_Source.m_StrategyOptionCollection);
end;

// ---------------------------------------------------------------------------
// 복사한다.
procedure CMXSumaryOption.CopyValue(p_Source: CMXSumaryOption);
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
procedure CMXSumaryOption.Read(AXMLNode: IXMLNode);
var
  f_Index: Integer;
  f_ValueNode: IXMLNode;

  f_ValueIndex: Integer;

  f_DataType: String;
  f_Key: String;
begin
  ClearAll;
  m_StrategyOptionCollection.Clear;

  if AnsiCompareText('SUMARRY', AXMLNode.NodeName) = 0 then
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
function CMXSumaryOption.Write: String;
var
  f_Stream: TStringStream;
  f_Index: Integer;
  f_FieldValue: CFNFieldValue;
  f_Key: String;
begin
  f_Stream := TStringStream.Create;

  f_Stream.WriteString('<SUMARRY>' + #$0A);

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

  f_Stream.WriteString('</SUMARRY>' + #$0A);

  f_Stream.Position := 0;
  Result := f_Stream.ReadString(f_Stream.Size);
  f_Stream.Free;
end;

// ------------------------------------------------------------------------------------
procedure CMXSumaryOption.DefaultValue;
begin
  if '04' = g_PGMCode then
  begin
    SetBooleanValue('USELOSSTRADESTOP', false);
    SetDoubleValue('LOSSTRADESTOP', -10000000);
  end
  else
  begin
    SetBooleanValue('USELOSSTRADESTOP', false);
    SetDoubleValue('LOSSTRADESTOP', -1000);
  end;

  SetBooleanValue('USE_SEND_SIGNAL', false);
  SetStringValue('SEND_SIGNAL_FOLDERNAME', ExtractFilePath(ParamStr(0)) + 'SignalFile\');
end;

end.
