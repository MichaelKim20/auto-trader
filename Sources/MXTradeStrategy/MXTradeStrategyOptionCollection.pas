unit MXTradeStrategyOptionCollection;

interface

uses
  Math, SysUtils, Classes, FNDataSet, XMLIntf;

type
  // 옵션을 저장하는 해쉬테이블
  CMXTradeStrategyOption = class(CFNRecord)
  private
    m_OnChanged: TNotifyEvent;

  public
    // 복제한다.
    procedure Clone(p_Source: CMXTradeStrategyOption);

    // 복사한다.
    procedure CopyValue(p_Source: CMXTradeStrategyOption);

    // XML문자에서 로딩한다.
    procedure Read(AXMLNode: IXMLNode);

    // XML문자로 저장한다.
    function Write: String;

    // 변경된 내용으로 이벤트를 발생시킨다.
    procedure SendChangedEvent;

    // 변경이벤트
    property OnChanged: TNotifyEvent read m_OnChanged write m_OnChanged;

  public

    class procedure Default_Reinforce1(AOption: CMXTradeStrategyOption);
    class procedure Default_Reinforce2(AOption: CMXTradeStrategyOption);
    class procedure Default_Reinforce3(AOption: CMXTradeStrategyOption);

    class procedure Default_RSI_T1(AOption: CMXTradeStrategyOption);
    class procedure Default_RSI_N1(AOption: CMXTradeStrategyOption);
    class procedure Default_STC_T1(AOption: CMXTradeStrategyOption);
    class procedure Default_STC_T2(AOption: CMXTradeStrategyOption);
    class procedure Default_STC_T3(AOption: CMXTradeStrategyOption);
    class procedure Default_STC_N1(AOption: CMXTradeStrategyOption);
    class procedure Default_STC_N2(AOption: CMXTradeStrategyOption);
    class procedure Default_BB_T1(AOption: CMXTradeStrategyOption);

    class procedure Default_DISPARITY_T1(AOption: CMXTradeStrategyOption);
    class procedure Default_DISPARITY_N1(AOption: CMXTradeStrategyOption);
    class procedure Default_BASELINE_T1(AOption: CMXTradeStrategyOption);
    class procedure Default_BASELINE_T2(AOption: CMXTradeStrategyOption);
    class procedure Default_BASELINE_N1(AOption: CMXTradeStrategyOption);

    class procedure Default_IM_T1_O1(AOption: CMXTradeStrategyOption);
    class procedure Default_IM_T1_O2(AOption: CMXTradeStrategyOption);
    class procedure Default_IM_T1_O3(AOption: CMXTradeStrategyOption);
    class procedure Default_IM_T2_O1(AOption: CMXTradeStrategyOption);
    class procedure Default_IM_T2_O2(AOption: CMXTradeStrategyOption);
    class procedure Default_IM_T2_O3(AOption: CMXTradeStrategyOption);
    class procedure Default_IM_T3_O1(AOption: CMXTradeStrategyOption);
    class procedure Default_IM_T3_O2(AOption: CMXTradeStrategyOption);
    class procedure Default_IM_T3_O3(AOption: CMXTradeStrategyOption);

    class procedure Default_MOV_T1_O1(AOption: CMXTradeStrategyOption);
    class procedure Default_MOV_T1_O2(AOption: CMXTradeStrategyOption);
    class procedure Default_MOV_T2_O1(AOption: CMXTradeStrategyOption);
    class procedure Default_MOV_T2_O2(AOption: CMXTradeStrategyOption);
    class procedure Default_MOV_T3_O1(AOption: CMXTradeStrategyOption);
    class procedure Default_MOV_T3_O2(AOption: CMXTradeStrategyOption);

    class procedure Default_MOV_N1_O1(AOption: CMXTradeStrategyOption);
    class procedure Default_MOV_N1_O2(AOption: CMXTradeStrategyOption);
    class procedure Default_MOV_N2_O1(AOption: CMXTradeStrategyOption);
    class procedure Default_MOV_N2_O2(AOption: CMXTradeStrategyOption);
    class procedure Default_REL_T1_O1(AOption: CMXTradeStrategyOption);
    class procedure Default_REL_T1_O2(AOption: CMXTradeStrategyOption);

    class procedure Default_MKI_T1(AOption: CMXTradeStrategyOption);
  end;

  // 다양한 옵션들을 저장하는 컬렉션
  CMXTradeStrategyOptionCollection = class(TObject)
  public
    m_Items: TList;
    m_AllocType: Integer;

  public
    // 생성자
    constructor Create;

    // 파괴자
    destructor Destroy; override;

  public
    // 내용을 모두 지운다.
    procedure Clear;

    // 오름차순으로 정렬한다.
    procedure Sort;

    // 하나를 추가한다.
    procedure Add(p_TradeStrategyOption: CMXTradeStrategyOption);
    // 복제한다.
    procedure Clone(p_Source: CMXTradeStrategyOptionCollection);
    // 원본의 포인트만을 저장한다.
    procedure CloneVirtual(p_Source: CMXTradeStrategyOptionCollection);

    // 찾는다.
    function Search(p_CATEGORY, p_NAME: String): Integer;

    // 특정 캐테고리의 것만 추출한다.
    function ExtractOnCategory(p_CATEGORY: String; p_Target: CMXTradeStrategyOptionCollection)
        : CMXTradeStrategyOptionCollection;

    // 파일로 저장한다.
    procedure SaveToFile(AFileName: String);

    // 파일에서 불러온다.
    procedure LoadFromFile(AFileName: String; AClear: Boolean = true);

    // 기본값들을 생성한다.
    procedure MakeDefaultOption;
  end;

implementation

uses
  FNGlobal, Variants, XMLDoc, Forms, MKTradeStrategyConst, Dialogs;

// ---------------------------------------------------------------------------
// 복제한다.
procedure CMXTradeStrategyOption.Clone(p_Source: CMXTradeStrategyOption);
var
  f_Loop: Integer;

  f_SrcFieldValue: CFNFieldValue;
  f_TagFieldValue: CFNFieldValue;
begin
  ClearAll;

  for f_Loop := 0 to p_Source.FieldValues.Count - 1 do
  begin
    f_SrcFieldValue := CFNFieldValue(p_Source.FieldValues.Objects[f_Loop]);

    f_TagFieldValue := CFNFieldValue.Create;
    if (RECORD_TYPE_DOUBLE = f_SrcFieldValue.DataType) then
    begin
      f_TagFieldValue.SetDoubleValue(f_SrcFieldValue.GetDoubleValue);
    end
    else if (RECORD_TYPE_INTEGER = f_SrcFieldValue.DataType) then
    begin
      f_TagFieldValue.SetIntegerValue(f_SrcFieldValue.GetIntegerValue);
    end
    else
    begin
      f_TagFieldValue.SetStringValue(f_SrcFieldValue.GetStringValue);
    end;

    FieldValues.AddObject(p_Source.FieldValues.Strings[f_Loop], f_TagFieldValue);
  end;
end;

// ---------------------------------------------------------------------------
// 복사한다.
procedure CMXTradeStrategyOption.CopyValue(p_Source: CMXTradeStrategyOption);
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
procedure CMXTradeStrategyOption.Read(AXMLNode: IXMLNode);
var
  f_Index: Integer;
  f_ValueNode: IXMLNode;

  f_ValueIndex: Integer;

  f_DataType: String;
  f_Key: String;
begin
  ClearAll;

  if AnsiCompareText('TRADESTRATEGY', AXMLNode.NodeName) = 0 then
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
function CMXTradeStrategyOption.Write: String;
var
  f_Stream: TStringStream;
  f_Index: Integer;
  f_FieldValue: CFNFieldValue;
  f_Key: String;
begin
  f_Stream := TStringStream.Create;

  f_Stream.WriteString('<TRADESTRATEGY>' + #$0A);

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

  f_Stream.WriteString('</TRADESTRATEGY>' + #$0A);

  f_Stream.Position := 0;
  Result := f_Stream.ReadString(f_Stream.Size);
  f_Stream.Free;
end;

// ---------------------------------------------------------------------------
// 비교함수이다. 여기서는 국가번호, 그룹번호, 거래소번호순으로 오름차순이다.
function CMXTradeStrategyOption_Compare(Item1, Item2: Pointer): Integer;
var
  f_Option1: CMXTradeStrategyOption;
  f_Option2: CMXTradeStrategyOption;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_Option1 := CMXTradeStrategyOption(Item1);
  f_Option2 := CMXTradeStrategyOption(Item2);

  if (0 = f_Compare) then
    f_Compare := AnsiCompareText(f_Option1.GetStringValue(TSOPTION_KEY_CATEGORY),
        f_Option2.GetStringValue(TSOPTION_KEY_CATEGORY));
  if (0 = f_Compare) then
    f_Compare := AnsiCompareText(f_Option1.GetStringValue(TSOPTION_KEY_NAME), f_Option2.GetStringValue(TSOPTION_KEY_NAME));

  if (0 < f_Compare) then
  begin
    Result := 1
  end
  else if (0 > f_Compare) then
  begin
    Result := -1
  end
  else
  begin
    Result := 0;
  end;
end;

// ---------------------------------------------------------------------------
constructor CMXTradeStrategyOptionCollection.Create;
begin
  inherited Create;

  m_AllocType := TRADE_STRATEGY_OPTION_REAL;
  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CMXTradeStrategyOptionCollection.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 배열의 구성요소를 모두 삭제한다.
procedure CMXTradeStrategyOptionCollection.Clear;
begin
  while 0 < m_Items.Count do
  begin
    if (m_AllocType = TRADE_STRATEGY_OPTION_REAL) then
      CMXTradeStrategyOption(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 하나를 추가한다.
procedure CMXTradeStrategyOptionCollection.Add(p_TradeStrategyOption: CMXTradeStrategyOption);
begin
  m_Items.Add(p_TradeStrategyOption);
end;

// ---------------------------------------------------------------------------
// 비교함수를 이용하여 정렬한다.
procedure CMXTradeStrategyOptionCollection.Sort;
begin
  m_Items.Sort(@CMXTradeStrategyOption_Compare);
end;

// ---------------------------------------------------------------------------
// 해당값을 가지고 있는 요소를 찾아 그 인덱스를 리턴한다.
procedure CMXTradeStrategyOptionCollection.SaveToFile(AFileName: String);
var
  f_Index: Integer;
  f_Option: CMXTradeStrategyOption;
  f_Stream: TStringStream;
begin
  try
    f_Stream := TStringStream.Create;
    f_Stream.WriteString('<COLLECTION>' + #$0A);
    for f_Index := 0 to m_Items.Count - 1 do
    begin
      f_Option := m_Items.Items[f_Index];
      f_Stream.WriteString(f_Option.Write);
    end;
    f_Stream.WriteString('</COLLECTION>' + #$0A);
    f_Stream.SaveToFile(AFileName);
    f_Stream.Free;
  finally
  end;
end;

// ---------------------------------------------------------------------------
procedure CMXTradeStrategyOptionCollection.MakeDefaultOption;
var
  f_Option: CMXTradeStrategyOption;
begin
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_RSI_T1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_RSI_N1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_STC_T1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_STC_T2(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_STC_T3(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_STC_N1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_STC_N2(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_BB_T1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_DISPARITY_T1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_DISPARITY_N1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_BASELINE_T1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_BASELINE_T2(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_BASELINE_N1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_IM_T1_O1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_IM_T1_O2(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_IM_T1_O3(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_IM_T2_O1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_IM_T2_O2(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_IM_T2_O3(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_IM_T3_O1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_IM_T3_O2(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_IM_T3_O3(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_MOV_T1_O1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_MOV_T1_O2(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_MOV_T2_O1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_MOV_T2_O2(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_MOV_T3_O1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_MOV_T3_O2(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_MOV_N1_O1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_MOV_N1_O2(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_MOV_N2_O1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_MOV_N2_O2(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_REL_T1_O1(f_Option);
  m_Items.Add(f_Option);
  f_Option := CMXTradeStrategyOption.Create;
  CMXTradeStrategyOption.Default_REL_T1_O2(f_Option);
  m_Items.Add(f_Option);

  Sort;
end;

// ---------------------------------------------------------------------------
procedure CMXTradeStrategyOptionCollection.LoadFromFile(AFileName: String; AClear: Boolean);
var
  f_Index: Integer;
  f_Stream: TStringStream;
  f_XMLDocument: TXMLDocument;
  f_XMLNode: IXMLNode;
  f_ChildNode: IXMLNode;
  f_Option: CMXTradeStrategyOption;
begin
  if AClear then
    Clear;

  if not FileExists(AFileName) then
  begin
    MakeDefaultOption;
    exit;
  end;

  f_Stream := TStringStream.Create;
  f_Stream.LoadFromFile(AFileName);
  f_Stream.Position := 0;

  try
    f_XMLDocument := TXMLDocument.Create(Application);
    f_XMLDocument.LoadFromXML(f_Stream.ReadString(f_Stream.Size));

    f_XMLNode := f_XMLDocument.DocumentElement;

    if SameText('COLLECTION', f_XMLNode.NodeName) then
    begin
      for f_Index := 0 to f_XMLNode.ChildNodes.Count - 1 do
      begin
        f_ChildNode := f_XMLNode.ChildNodes[f_Index];
        if SameText('TRADESTRATEGY', f_ChildNode.NodeName) then
        begin
          f_Option := CMXTradeStrategyOption.Create;
          f_Option.Read(f_ChildNode);
          m_Items.Add(f_Option);
        end;
      end;
    end;

  finally
    if Assigned(f_XMLDocument) then
      f_XMLDocument.Free;
    if Assigned(f_Stream) then
      f_Stream.Free;
  end;

  Sort;
end;

// ---------------------------------------------------------------------------
function CMXTradeStrategyOptionCollection.Search(p_CATEGORY, p_NAME: String): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_Option: CMXTradeStrategyOption;
  f_Category, f_Name: String;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_Option := CMXTradeStrategyOption(m_Items.Items[f_PosX]);
      f_Category := f_Option.GetStringValue(TSOPTION_KEY_CATEGORY);
      f_Name := f_Option.GetStringValue(TSOPTION_KEY_NAME);

      f_Compare := 0;
      if (0 = f_Compare) then
        f_Compare := AnsiCompareText(p_CATEGORY, f_Category);
      if (0 = f_Compare) then
        f_Compare := AnsiCompareText(p_NAME, f_Name);

      if (0 > f_Compare) then
        f_PosR := f_PosX - 1
      else
        f_PosL := f_PosX + 1;
    until (not((f_Compare <> 0) and (f_PosL <= f_PosR)));

    if (0 = f_Compare) then
      Result := f_PosX
    else
      Result := -1;
  end
  else
  begin
    Result := -1;
  end;
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하여 복제한다.
procedure CMXTradeStrategyOptionCollection.Clone(p_Source: CMXTradeStrategyOptionCollection);
var
  f_OldTradeStrategyOption: CMXTradeStrategyOption;
  f_NewTradeStrategyOption: CMXTradeStrategyOption;
  f_Index: Integer;
begin
  Clear;
  for f_Index := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_OldTradeStrategyOption := CMXTradeStrategyOption(p_Source.m_Items.Items[f_Index]);
    f_NewTradeStrategyOption := CMXTradeStrategyOption.Create;
    f_NewTradeStrategyOption.Clone(f_OldTradeStrategyOption);
    m_Items.Add(f_NewTradeStrategyOption);
  end;
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하지 않고 참조 포인터만 전달하여 복제한다.
// 이것은 정렬의 인덱스로 사용하기 위함이다.
procedure CMXTradeStrategyOptionCollection.CloneVirtual(p_Source: CMXTradeStrategyOptionCollection);
var
  f_OldTradeStrategyOption: CMXTradeStrategyOption;
  f_Index: Integer;
begin
  Clear;
  for f_Index := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_OldTradeStrategyOption := CMXTradeStrategyOption(p_Source.m_Items.Items[f_Index]);
    m_Items.Add(f_OldTradeStrategyOption);
  end;
end;

// ---------------------------------------------------------------------------
function CMXTradeStrategyOptionCollection.ExtractOnCategory(p_CATEGORY: String; p_Target: CMXTradeStrategyOptionCollection)
    : CMXTradeStrategyOptionCollection;
var
  f_Collection: CMXTradeStrategyOptionCollection;
  f_Option: CMXTradeStrategyOption;
  f_Index: Integer;
begin
  if Assigned(p_Target) then
  begin
    f_Collection := p_Target;
  end
  else
  begin
    f_Collection := CMXTradeStrategyOptionCollection.Create;
  end;

  f_Collection.Clear;
  f_Collection.m_AllocType := TRADE_STRATEGY_OPTION_VIRTUAL;
  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_Option := m_Items.Items[f_Index];

    if AnsiCompareText(p_CATEGORY, f_Option.GetStringValue(TSOPTION_KEY_CATEGORY)) = 0 then
    begin
      f_Collection.Add(f_Option);
    end;
  end;
  f_Collection.Sort;

  Result := f_Collection;
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_RSI_T1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.SetIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'RSI-T1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

  AOption.SetIntegerValue('LENGTH1', 35);

  AOption.SetDoubleValue('UP', 75);
  AOption.SetDoubleValue('DN', 25);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_RSI_N1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'RSI-N1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);
  AOption.SetIntegerValue('LENGTH1', 23);
  AOption.SetDoubleValue('UP', 75);
  AOption.SetDoubleValue('DN', 25);
  AOption.AddBooleanValue('USE_DEFAULT_EXIT_CONDITON', true);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_STC_T1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'STC-T1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

  AOption.SetIntegerValue('LENGTH1', 270);
  AOption.SetIntegerValue('LENGTH2', 90);
  AOption.SetIntegerValue('LENGTH3', 30);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_STC_T2(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'STC-T2');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

  AOption.SetIntegerValue('LENGTH1', 270);
  AOption.SetIntegerValue('LENGTH2', 20);
  AOption.SetIntegerValue('LENGTH3', 10);

  AOption.SetIntegerValue('UP', 80);
  AOption.SetIntegerValue('DN', 20);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_STC_T3(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'STC-T3');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

  AOption.SetIntegerValue('LENGTH1', 270);
  AOption.SetIntegerValue('LENGTH2', 90);
  AOption.SetIntegerValue('LENGTH3', 90);

  AOption.SetIntegerValue('LENGTH4', 30);
  AOption.SetIntegerValue('LENGTH5', 10);
  AOption.SetIntegerValue('LENGTH6', 10);

  AOption.SetIntegerValue('UP', 80);
  AOption.SetIntegerValue('DN', 20);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
procedure CMXTradeStrategyOption.SendChangedEvent;
begin
  if Assigned(m_OnChanged) then
    m_OnChanged(Self);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_STC_N1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'STC-N1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

  AOption.SetIntegerValue('LENGTH1', 270);
  AOption.SetIntegerValue('LENGTH2', 30);
  AOption.SetIntegerValue('LENGTH3', 30);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_STC_N2(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'STC-N2');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

  AOption.SetIntegerValue('LENGTH1', 270);
  AOption.SetIntegerValue('LENGTH2', 60);
  AOption.SetIntegerValue('LENGTH3', 30);

  AOption.AddDoubleValue('UP', 80);
  AOption.AddDoubleValue('DN', 20);

  AOption.AddBooleanValue('USE_DEFAULT_EXIT_CONDITON', true);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_BB_T1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'BB-T1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

  AOption.AddIntegerValue('LENGTH0', 180);
  AOption.AddDoubleValue('SIGMA0', 2);

  AOption.AddDoubleValue('THRESHOLD', 10);

  AOption.AddIntegerValue('LENGTH1', 180);
  AOption.AddDoubleValue('SIGMA1', 2);

  AOption.AddIntegerValue('LENGTH2', 180);
  AOption.AddDoubleValue('SIGMA2', 1);

  AOption.SetIntegerValue('PRICEMETHOD', 0);

  // 종가이평
  AOption.SetIntegerValue('PM1_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('PM1_V2', 0);

  // 고가, 저가이평
  AOption.SetIntegerValue('PM2_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('PM2_V2', 0);

  // 고가, 저가이평
  AOption.SetIntegerValue('PM3_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('PM3_V2', 0);

  // 볼랜저밴드 이평
  AOption.SetIntegerValue('PM4_V1', 5);
  AOption.SetDoubleValue('PM4_V2', 2);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_DISPARITY_T1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'DISPARITY-T1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

  AOption.AddIntegerValue('LENGTH1', 5);
  AOption.AddIntegerValue('LENGTH2', 50);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_IM_T1_O1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'IM-T1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '단기');

  AOption.AddIntegerValue('LENGTH1', 9);
  AOption.AddIntegerValue('LENGTH2', 26);
  AOption.AddIntegerValue('LENGTH3', 52);

  AOption.AddIntegerValue('TREND_FILTER', 2);
  AOption.AddDoubleValue('M1V1', 1.5);
  AOption.AddDoubleValue('M2V1', 7.5);
  AOption.AddIntegerValue('M3V1', 30);
  AOption.AddDoubleValue('M4V1', 0.5);

  AOption.SetIntegerValue('VALUE_TYPE', 0);
  AOption.SetBooleanValue('USE_SIDECONDITION', true);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_IM_T1_O2(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'IM-T1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '중기');

  AOption.AddIntegerValue('LENGTH1', 27);
  AOption.AddIntegerValue('LENGTH2', 78);
  AOption.AddIntegerValue('LENGTH3', 156);

  AOption.AddIntegerValue('TREND_FILTER', 2);
  AOption.AddDoubleValue('M1V1', 1.5);
  AOption.AddDoubleValue('M2V1', 7.5);
  AOption.AddIntegerValue('M3V1', 30);
  AOption.AddDoubleValue('M4V1', 0.5);

  AOption.SetIntegerValue('VALUE_TYPE', 0);
  AOption.SetBooleanValue('USE_SIDECONDITION', true);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_IM_T1_O3(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'IM-T1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '장기');

  AOption.AddIntegerValue('LENGTH1', 52);
  AOption.AddIntegerValue('LENGTH2', 156);
  AOption.AddIntegerValue('LENGTH3', 468);

  AOption.AddIntegerValue('TREND_FILTER', 2);
  AOption.AddDoubleValue('M1V1', 1.5);
  AOption.AddDoubleValue('M2V1', 7.5);
  AOption.AddIntegerValue('M3V1', 30);
  AOption.AddDoubleValue('M4V1', 0.5);

  AOption.SetIntegerValue('VALUE_TYPE', 0);
  AOption.SetBooleanValue('USE_SIDECONDITION', true);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_IM_T2_O1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'IM-T2');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '단기');

  AOption.AddIntegerValue('LENGTH1', 9);
  AOption.AddIntegerValue('LENGTH2', 26);
  AOption.AddIntegerValue('LENGTH3', 52);

  AOption.AddIntegerValue('TREND_FILTER', 2);
  AOption.AddDoubleValue('M1V1', 1.5);
  AOption.AddDoubleValue('M2V1', 7.5);
  AOption.AddIntegerValue('M3V1', 30);
  AOption.AddDoubleValue('M4V1', 0.5);

  AOption.SetIntegerValue('VALUE_TYPE', 0);
  AOption.SetBooleanValue('USE_SIDECONDITION', true);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_IM_T2_O2(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'IM-T2');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '중기');

  AOption.AddIntegerValue('LENGTH1', 27);
  AOption.AddIntegerValue('LENGTH2', 78);
  AOption.AddIntegerValue('LENGTH3', 156);

  AOption.AddIntegerValue('TREND_FILTER', 2);
  AOption.AddDoubleValue('M1V1', 1.5);
  AOption.AddDoubleValue('M2V1', 7.5);
  AOption.AddIntegerValue('M3V1', 30);
  AOption.AddDoubleValue('M4V1', 0.5);

  AOption.SetIntegerValue('VALUE_TYPE', 0);
  AOption.SetBooleanValue('USE_SIDECONDITION', true);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_IM_T2_O3(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'IM-T2');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '장기');

  AOption.AddIntegerValue('LENGTH1', 52);
  AOption.AddIntegerValue('LENGTH2', 156);
  AOption.AddIntegerValue('LENGTH3', 468);

  AOption.AddIntegerValue('TREND_FILTER', 2);
  AOption.AddDoubleValue('M1V1', 1.5);
  AOption.AddDoubleValue('M2V1', 7.5);
  AOption.AddIntegerValue('M3V1', 30);
  AOption.AddDoubleValue('M4V1', 0.5);

  AOption.SetIntegerValue('VALUE_TYPE', 0);
  AOption.SetBooleanValue('USE_SIDECONDITION', true);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_IM_T3_O1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'IM-T3');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '단기');

  AOption.AddIntegerValue('LENGTH1', 9);
  AOption.AddIntegerValue('LENGTH2', 26);
  AOption.AddIntegerValue('LENGTH3', 52);

  AOption.AddIntegerValue('TREND_FILTER', 2);
  AOption.AddDoubleValue('M1V1', 1.5);
  AOption.AddDoubleValue('M2V1', 7.5);
  AOption.AddIntegerValue('M3V1', 30);
  AOption.AddDoubleValue('M4V1', 0.5);

  AOption.SetIntegerValue('VALUE_TYPE', 0);
  AOption.SetBooleanValue('USE_SIDECONDITION', true);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_IM_T3_O2(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'IM-T3');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '중기');

  AOption.AddIntegerValue('LENGTH1', 27);
  AOption.AddIntegerValue('LENGTH2', 78);
  AOption.AddIntegerValue('LENGTH3', 156);

  AOption.AddIntegerValue('TREND_FILTER', 2);
  AOption.AddDoubleValue('M1V1', 1.5);
  AOption.AddDoubleValue('M2V1', 7.5);
  AOption.AddIntegerValue('M3V1', 30);
  AOption.AddDoubleValue('M4V1', 0.5);

  AOption.SetIntegerValue('VALUE_TYPE', 0);
  AOption.SetBooleanValue('USE_SIDECONDITION', true);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_IM_T3_O3(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'IM-T3');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '장기');

  AOption.AddIntegerValue('LENGTH1', 52);
  AOption.AddIntegerValue('LENGTH2', 156);
  AOption.AddIntegerValue('LENGTH3', 468);

  AOption.AddIntegerValue('TREND_FILTER', 2);
  AOption.AddDoubleValue('M1V1', 1.5);
  AOption.AddDoubleValue('M2V1', 7.5);
  AOption.AddIntegerValue('M3V1', 30);
  AOption.AddDoubleValue('M4V1', 0.5);

  AOption.SetIntegerValue('VALUE_TYPE', 0);
  AOption.SetBooleanValue('USE_SIDECONDITION', true);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_DISPARITY_N1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'DISPARITY-N1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

  AOption.AddIntegerValue('LENGTH1', 5);
  AOption.AddDoubleValue('DN1', 99.98);
  AOption.AddDoubleValue('UP1', 100.05);

  AOption.AddIntegerValue('LENGTH2', 60);
  AOption.AddDoubleValue('DN2', 99.8);
  AOption.AddDoubleValue('UP2', 100.1);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_BASELINE_T1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'BASELINE-T1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

  AOption.SetIntegerValue('PRICEMETHOD', 0);

  // 종가이평
  AOption.SetIntegerValue('PM1_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('PM1_V2', 0);

  // 고가, 저가이평
  AOption.SetIntegerValue('PM2_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('PM2_V2', 0);

  // 고가, 저가이평
  AOption.SetIntegerValue('PM3_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('PM3_V2', 0);

  // 볼랜저밴드 이평
  AOption.SetIntegerValue('PM4_V1', 5);
  AOption.SetDoubleValue('PM4_V2', 2);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_BASELINE_T2(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'BASELINE-T2');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

  AOption.SetIntegerValue('PRICEMETHOD', 0);

  // 종가이평
  AOption.SetIntegerValue('PM1_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('PM1_V2', 0);

  // 고가, 저가이평
  AOption.SetIntegerValue('PM2_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('PM2_V2', 0);

  // 고가, 저가이평
  AOption.SetIntegerValue('PM3_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('PM3_V2', 0);

  // 볼랜저밴드 이평
  AOption.SetIntegerValue('PM4_V1', 5);
  AOption.SetDoubleValue('PM4_V2', 2);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_BASELINE_N1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'BASELINE-N1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

  AOption.AddIntegerValue('TREND_FILTER', 0);
  AOption.AddDoubleValue('M1V1', 1.5);
  AOption.AddDoubleValue('M2V1', 30);
  AOption.AddDoubleValue('M3V1', 1.7);

  AOption.SetIntegerValue('PRICEMETHOD', 0);

  // 종가이평
  AOption.SetIntegerValue('PM1_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('PM1_V2', 0);

  // 고가, 저가이평
  AOption.SetIntegerValue('PM2_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('PM2_V2', 0);

  // 고가, 저가이평
  AOption.SetIntegerValue('PM3_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('PM3_V2', 0);

  // 볼랜저밴드 이평
  AOption.SetIntegerValue('PM4_V1', 5);
  AOption.SetDoubleValue('PM4_V2', 2);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_MOV_T1_O1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'MOV-T1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '단기');

  AOption.AddIntegerValue('LENGTH1', 5);
  AOption.AddIntegerValue('LENGTH2', 60);

  AOption.AddIntegerValue('AVERAGE_TYPE', 0);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_MOV_T1_O2(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'MOV-T1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '장기');

  AOption.AddIntegerValue('LENGTH1', 15);
  AOption.AddIntegerValue('LENGTH2', 180);

  AOption.AddIntegerValue('AVERAGE_TYPE', 0);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_MOV_T2_O1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'MOV-T2');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '단기');

  AOption.AddIntegerValue('LENGTH1', 5);
  AOption.AddIntegerValue('LENGTH2', 20);
  AOption.AddIntegerValue('LENGTH3', 60);

  AOption.AddIntegerValue('AVERAGE_TYPE', 0);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_MOV_T2_O2(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'MOV-T2');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '장기');

  AOption.AddIntegerValue('LENGTH1', 15);
  AOption.AddIntegerValue('LENGTH2', 60);
  AOption.AddIntegerValue('LENGTH3', 180);

  AOption.AddIntegerValue('AVERAGE_TYPE', 0);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_MOV_T3_O1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'MOV-T3');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '단기');

  AOption.AddIntegerValue('LENGTH1', 226);
  AOption.AddIntegerValue('PRECISION', 4);

  AOption.AddIntegerValue('AVERAGE_TYPE', 1);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_MOV_T3_O2(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'MOV-T3');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '장기');

  AOption.AddIntegerValue('LENGTH1', 300);
  AOption.AddIntegerValue('PRECISION', 4);

  AOption.AddIntegerValue('AVERAGE_TYPE', 1);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_MOV_N1_O1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'MOV-N1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '단기');

  AOption.AddIntegerValue('LENGTH1', 5);
  AOption.AddIntegerValue('LENGTH2', 20);
  AOption.AddIntegerValue('LENGTH3', 60);

  AOption.AddIntegerValue('AVERAGE_TYPE', 0);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_MOV_N1_O2(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'MOV-N1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '장기');

  AOption.AddIntegerValue('LENGTH1', 15);
  AOption.AddIntegerValue('LENGTH2', 60);
  AOption.AddIntegerValue('LENGTH3', 180);

  AOption.AddIntegerValue('AVERAGE_TYPE', 0);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_MOV_N2_O1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);
  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'MOV-N2');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '단기');

  AOption.AddIntegerValue('LENGTH1', 5);
  AOption.AddIntegerValue('LENGTH2', 20);
  AOption.AddIntegerValue('LENGTH3', 60);

  AOption.AddIntegerValue('AVERAGE_TYPE', 0);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_MOV_N2_O2(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'MOV-N2');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '장기');

  AOption.AddIntegerValue('LENGTH1', 15);
  AOption.AddIntegerValue('LENGTH2', 60);
  AOption.AddIntegerValue('LENGTH3', 180);

  AOption.AddIntegerValue('AVERAGE_TYPE', 0);

  AOption.SetBooleanValue('USE_TOLERANCE', false);
  AOption.SetDoubleValue('TOLERANCE', 0.01);
  AOption.SetIntegerValue('TOLERANCE_UNIT', 0);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_REL_T1_O1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'REL-T1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '기본값2');

  AOption.AddIntegerValue('LENGTH1', 13);
  AOption.AddDoubleValue('UP', 0.0002);
  AOption.AddDoubleValue('DN', -0.0002);
  AOption.AddIntegerValue('METHOD', 0);
  AOption.AddBooleanValue('USEEXIT', false);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_REL_T1_O2(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'REL-T1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, '기본값1');

  AOption.AddIntegerValue('LENGTH1', 9);
  AOption.AddDoubleValue('UP', 0.0002);
  AOption.AddDoubleValue('DN', -0.0002);
  AOption.AddIntegerValue('METHOD', 1);
  AOption.AddBooleanValue('USEEXIT', false);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_MKI_T1(AOption: CMXTradeStrategyOption);
begin
  if not Assigned(AOption) then
    exit;

  AOption.ClearAll;

  AOption.AddIntegerValue(TSOPTION_KEY_MAJORVALUE, TSOPTION_VALUE_MAJOR_OPS);

  AOption.SetStringValue(TSOPTION_KEY_CATEGORY, 'MKI-T1');
  AOption.SetStringValue(TSOPTION_KEY_TYPE, TSOPTION_VALUE_STAND);
  AOption.SetStringValue(TSOPTION_KEY_NAME, TSOPTION_VALUE_STAND);

  AOption.SetIntegerValue('LENGTH1', 270);
  AOption.SetIntegerValue('LENGTH2', 90);
  AOption.SetIntegerValue('LENGTH3', 30);

  Default_Reinforce1(AOption);
  Default_Reinforce2(AOption);
  Default_Reinforce3(AOption);
end;

// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_Reinforce1(AOption: CMXTradeStrategyOption);
begin
  AOption.AddBooleanValue('RF1_USE_CONDITION', false);

  AOption.SetIntegerValue('RF1_STD_VALUE', 0); // 0:전일종가; 1:당일시가;
  AOption.SetIntegerValue('RF1_VALUE_TYPE', 1); // 0:가격; 1:OPS;

  AOption.SetIntegerValue('RF1_PRICEMETHOD', 0);

  // 종가이평
  AOption.SetIntegerValue('RF1_PM1_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('RF1_PM1_V2', 0);

  // 고가, 저가이평
  AOption.SetIntegerValue('RF1_PM2_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('RF1_PM2_V2', 0);

  // 고가, 저가이평
  AOption.SetIntegerValue('RF1_PM3_V1', 5);
  // 이평이 종류 : 0:단순; 1:가중, 2:지수
  AOption.SetIntegerValue('RF1_PM3_V2', 0);

  // 볼랜저밴드 이평
  AOption.SetIntegerValue('RF1_PM4_V1', 5);
  AOption.SetDoubleValue('RF1_PM4_V2', 2);

  AOption.SetBooleanValue('RF1_USE_TOLERANCE', false);
  AOption.SetDoubleValue('RF1_TOLERANCE', 0.01);
  AOption.SetIntegerValue('RF1_TOLERANCE_UNIT', 0);
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_Reinforce2(AOption: CMXTradeStrategyOption);
begin
  AOption.AddBooleanValue('RF2_USE_CONDITION', false);

  AOption.SetIntegerValue('RF2_VALUE_TYPE', 0); // 0:가격; 1:OPS;
  AOption.SetIntegerValue('RF2_LENGTH', 38); // 이평계산일 수
  AOption.SetIntegerValue('RF2_PRECISION', 4); // 소수점의 자리수
  AOption.SetIntegerValue('RF2_AVERAGE_TYPE', 1); // 이평이 종류 : 0:단순; 1:가중, 2:지수
end;

// ---------------------------------------------------------------------------
class procedure CMXTradeStrategyOption.Default_Reinforce3(AOption: CMXTradeStrategyOption);
begin
  AOption.AddBooleanValue('RF3_USE_CONDITION', false);
end;

end.
