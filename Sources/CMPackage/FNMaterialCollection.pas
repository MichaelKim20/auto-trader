unit FNMaterialCollection;

interface

uses
  Math, SysUtils, Classes, FNDataSet, Messages, Dialogs;

type

  CFNMaterialItem = class(TObject)
  public
    m_Country: Integer;
    m_Group: Integer;
    m_Market: Integer;
    m_Key: String;
    m_Material: Integer;
    m_Precision: Integer;
    m_PODIndex: Integer;
    m_POTIndex: Integer;
    m_CurrencyIndex: Integer;
    m_MarginI: Double;
    m_MarginM: Double;
    m_PointValue: Double;
    m_TickSize: Double;
    m_TickValue: Double;
    m_TimeDiffrence: Double;
    m_TimeDiffrence2: Double;
  public
    procedure Clone(p_Source: CFNMaterialItem);
    procedure ArrayToData(p_Record: CFNRecord);
  end;

  CFNMaterialCollection = class(TObject)
  public
    m_Items: TList;

  public
    constructor Create;
    destructor Destroy; override;

  public
    procedure Clear;
    procedure Add(p_MaterialItem: CFNMaterialItem);
    function Search(p_Country: Integer; p_Group: Integer; p_Market: Integer; p_Key: String = ''): Integer;
    function Find(p_Country: Integer; p_Group: Integer; p_Market: Integer; p_Key: String = ''): CFNMaterialItem;
    procedure Sort;
    procedure Clone(p_Source: CFNMaterialCollection);
  end;

implementation

uses
  FNGlobal;

// ---------------------------------------------------------------------------
// 복제한다.
procedure CFNMaterialItem.Clone(p_Source: CFNMaterialItem);
begin
  if Assigned(p_Source) then
  begin
    m_Country := p_Source.m_Country;
    m_Group := p_Source.m_Group;
    m_Market := p_Source.m_Market;
    m_Key := p_Source.m_Key;
    m_Material := p_Source.m_Material;
    m_Precision := p_Source.m_Precision;
    m_PODIndex := p_Source.m_PODIndex;
    m_POTIndex := p_Source.m_POTIndex;
    m_CurrencyIndex := p_Source.m_CurrencyIndex;
    m_MarginI := p_Source.m_MarginI;
    m_MarginM := p_Source.m_MarginM;
    m_PointValue := p_Source.m_PointValue;
    m_TickSize := p_Source.m_TickSize;
    m_TickValue := p_Source.m_TickValue;
    m_TimeDiffrence := p_Source.m_TimeDiffrence;
    m_TimeDiffrence2 := p_Source.m_TimeDiffrence2;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMaterialItem.ArrayToData(p_Record: CFNRecord);
var
  nLoop: Integer;
begin
  (*
    for nLoop := 0 to p_Record.FieldValues.Count - 1 do
    begin
    ShowMessage(p_Record.FieldValues.Strings[nLoop]);
    end;
  *)
  m_Country := p_Record.GetIntegerValue('COUNTRY_NO');
  m_Group := p_Record.GetIntegerValue('GROUP_NO');
  m_Market := p_Record.GetIntegerValue('MARKET_NO');
  m_Key := p_Record.GetStringValue('KEY');
  m_Material := p_Record.GetIntegerValue('MATERIAL_NO');
  m_Precision := p_Record.GetIntegerValue('PRECISION');
  m_PODIndex := p_Record.GetIntegerValue('POD_INDEX');
  m_POTIndex := p_Record.GetIntegerValue('POT_INDEX');
  m_CurrencyIndex := p_Record.GetIntegerValue('CURRENCY_INDEX');
  m_MarginI := p_Record.GetDoubleValue('MARGIN_I');
  m_MarginM := p_Record.GetDoubleValue('MARGIN_M');
  m_PointValue := p_Record.GetDoubleValue('POINT_VALUE');
  m_TickSize := p_Record.GetDoubleValue('TICK_SIZE');
  m_TickValue := p_Record.GetDoubleValue('TICK_VALUE');
  m_TimeDiffrence := p_Record.GetIntegerValue('TIME_DIFFRENCE') / 1440.0;
  m_TimeDiffrence2 := p_Record.GetIntegerValue('TIME_DIFFRENCE2') / 1440.0;
end;

// ---------------------------------------------------------------------------
// 비교함수이다. 여기서는 국가번호, 그룹번호, 거래소번호순으로 오름차순이다.
function CMP_CFNMaterialItem(Item1, Item2: Pointer): Integer;
var
  f_MaterialItem1: CFNMaterialItem;
  f_MaterialItem2: CFNMaterialItem;
  f_Compare: Integer;
begin
  f_Compare := 0;

  f_MaterialItem1 := CFNMaterialItem(Item1);
  f_MaterialItem2 := CFNMaterialItem(Item2);

  if (0 = f_Compare) then
    f_Compare := f_MaterialItem1.m_Country - f_MaterialItem2.m_Country;
  if (0 = f_Compare) then
    f_Compare := f_MaterialItem1.m_Group - f_MaterialItem2.m_Group;
  if (0 = f_Compare) then
    f_Compare := f_MaterialItem1.m_Market - f_MaterialItem2.m_Market;
  if (0 = f_Compare) then
    f_Compare := CompareStr(f_MaterialItem1.m_Key, f_MaterialItem2.m_Key);

  if (0 < f_Compare) then
    Result := 1
  else if (0 > f_Compare) then
    Result := -1
  else
    Result := 0;
end;

// ---------------------------------------------------------------------------
constructor CFNMaterialCollection.Create;
begin
  inherited Create;

  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CFNMaterialCollection.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 배열의 구성요소를 모두 삭제한다.
procedure CFNMaterialCollection.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNMaterialItem(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 하나를 추가한다.
procedure CFNMaterialCollection.Add(p_MaterialItem: CFNMaterialItem);
begin
  m_Items.Add(p_MaterialItem);
end;

// ---------------------------------------------------------------------------
// 해당값을 가지고 있는 요소를 찾아 그 인덱스를 리턴한다.
function CFNMaterialCollection.Search(p_Country, p_Group, p_Market: Integer; p_Key: String = ''): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_MaterialItem: CFNMaterialItem;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_MaterialItem := CFNMaterialItem(m_Items.Items[f_PosX]);
      f_Compare := p_Country - f_MaterialItem.m_Country;
      if (0 = f_Compare) then
        f_Compare := p_Group - f_MaterialItem.m_Group;
      if (0 = f_Compare) then
        f_Compare := p_Market - f_MaterialItem.m_Market;
      if p_Key <> '' then
      begin
        if (0 = f_Compare) then
          f_Compare := CompareStr(p_Key, f_MaterialItem.m_Key);
      end;
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
// 해당값을 가지고 있는 요소를 찾아 그 객체를 리턴한다.
function CFNMaterialCollection.Find(p_Country, p_Group, p_Market: Integer; p_Key: String = ''): CFNMaterialItem;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_MaterialItem: CFNMaterialItem;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_MaterialItem := CFNMaterialItem(m_Items.Items[f_PosX]);

      f_Compare := p_Country - f_MaterialItem.m_Country;
      if (0 = f_Compare) then
        f_Compare := p_Group - f_MaterialItem.m_Group;
      if (0 = f_Compare) then
        f_Compare := p_Market - f_MaterialItem.m_Market;
      if p_Key <> '' then
      begin
        if (0 = f_Compare) then
          f_Compare := CompareStr(p_Key, f_MaterialItem.m_Key);
      end;

      if (0 > f_Compare) then
        f_PosR := f_PosX - 1
      else
        f_PosL := f_PosX + 1;
    until (not((f_Compare <> 0) and (f_PosL <= f_PosR)));

    if (0 = f_Compare) then
      Result := f_MaterialItem
    else
      Result := NIL;
  end
  else
  begin
    Result := NIL;
  end;
end;

// ---------------------------------------------------------------------------
// 비교함수를 이용하여 정렬한다.
procedure CFNMaterialCollection.Sort;
begin
  m_Items.Sort(@CMP_CFNMaterialItem);
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하여 복제한다.
procedure CFNMaterialCollection.Clone(p_Source: CFNMaterialCollection);
var
  f_OldMaterialItem: CFNMaterialItem;
  f_NewMaterialItem: CFNMaterialItem;
  f_Index: Integer;
begin
  Clear;
  for f_Index := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_OldMaterialItem := CFNMaterialItem(p_Source.m_Items.Items[f_Index]);
    f_NewMaterialItem := CFNMaterialItem.Create;
    f_NewMaterialItem.Clone(f_OldMaterialItem);
    m_Items.Add(f_NewMaterialItem);
  end;
end;

end.
