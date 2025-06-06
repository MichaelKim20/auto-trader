unit FNNAVAnalLineValueSeries;

interface

uses
  SysUtils, Classes, Types, Math,
  FNNAVAnalChartDataSeries, FNNAVAnalMaxMin, FNNAVAnalLineValue, FNNAVAnalConst,
  FNNAVAnalChartData, FNTradeSystem, FNNAVDataSeries;

const
  NAV_TPROFIT = 0;
  NAV_TPROFIT2 = 1;

  NAV_TDRAWDOWN1 = 2;
  NAV_TDRAWDOWN2 = 3;
  NAV_TDRAWDOWN1MA1 = 4;
  NAV_TDRAWDOWN1MA2 = 5;
  NAV_TDRAWDOWN1MA3 = 6;

  NAV_BPROFIT = 7;
  NAV_BPROFIT_MA1 = 8;
  NAV_BPROFIT_MA2 = 9;
  NAV_BPROFIT_MA3 = 10;
  NAV_BPROFIT_ENAVLE = 11;
  NAV_BPROFIT_ENAVLE2 = 12;
  NAV_BPROFIT2 = 13;
  NAV_BDRAWDOWN1 = 14;
  NAV_BDRAWDOWN2 = 15;
  NAV_BDRAWDOWN1MA1 = 16;
  NAV_BDRAWDOWN1MA2 = 17;
  NAV_BDRAWDOWN1MA3 = 18;
  NAV_SPROFIT = 19;
  NAV_SPROFIT_MA1 = 20;
  NAV_SPROFIT_MA2 = 21;
  NAV_SPROFIT_MA3 = 22;
  NAV_SPROFIT_ENAVLE = 23;
  NAV_SPROFIT_ENAVLE2 = 24;
  NAV_SPROFIT2 = 25;
  NAV_SDRAWDOWN1 = 26;
  NAV_SDRAWDOWN2 = 27;
  NAV_SDRAWDOWN1MA1 = 28;
  NAV_SDRAWDOWN1MA2 = 29;
  NAV_SDRAWDOWN1MA3 = 30;
  NAV_BPROFIT_NMA1 = 31;
  NAV_BPROFIT_STDDEV = 32;
  NAV_BPROFIT_LOWLINE = 33;

type
  CFNNAVAnalLineValueSeries = class(TObject)
  public
    m_Items: TList;
    m_ChartDataSeries: CFNNAVAnalChartDataSeries;
    m_TimeFrame: Integer;
    m_Name: String;
    m_FullName: String;

    m_LastValueVisible: Boolean;
    m_ViewLabel: Boolean;
    m_LineCount: Integer;
    m_LineColors: Array of Integer;
    m_LineWidths: Array of Integer;
    m_LineAlphas: Array of Integer;
    m_LineTypes: Array of Integer;
    m_LineVisibles: Array of Boolean;
    m_LineLabelVisibles: Array of Boolean;
    m_LineLabelNameVisibles: Array of Boolean;
    m_LinePosValueVisibles: Array of Boolean;
    m_LineLastValueVisibles: Array of Boolean;
    m_LineNames: Array of String;
    m_LineMaxMinIndexs: Array of Integer;
    m_OptionCount: Integer;
    m_Options: Array of Double;
    m_ValueCount: Integer;
    m_Values: Array of Double;
    m_ValueColors: Array of Integer;
    m_ValueWidths: Array of Integer;
    m_ValueEnables: Array of Boolean;
    m_MaxMinCount: Integer;
    m_MaxMinTable: Array of CFNNAVAnalMaxMin;
    m_MaxMinFactor: Array of Double;
    m_Precision: Integer;
    m_StartIndex: Integer;
    m_Effect: Boolean;
    m_Type: Integer;
    m_Signal: Boolean;

  public
    constructor Create(p_Name: String; p_Type: Integer; p_LineCount: Integer = 1; p_OptionCount: Integer = 0; p_ValueCount: Integer = 0; p_MaxMinCount: Integer = 1);
    destructor Destroy; override;

    procedure Clone(p_Source: CFNNAVAnalLineValueSeries);
    procedure Update(p_Source: CFNNAVAnalLineValueSeries);

    procedure SetLineCount(p_LineCount: Integer);
    procedure GetLineMaxMin(p_X1: Integer; p_X2: Integer);
    procedure Clear;
    procedure Fill(p_Count: Integer);
    procedure SetLengthSeries(p_Length: Integer);

    procedure CreateLineValueAdd(p_Index: Integer; p_Value: Double; p_Count: Integer = 1);

    // procedure Indicator_NAV(p_ChartDataSeries:CFNNAVAnalChartDataSeries; p_Begin:Integer = -1; p_End:Integer = -1);

    procedure HiLoPrice(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_HiIndex: Integer; p_LoIndex: Integer; p_Position: Integer; var f_Hi, f_Low: Double);
    function HighestPrice(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_PriceIndex: Integer; p_Position: Integer): Double;
    function LowestPrice(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_PriceIndex: Integer; p_Position: Integer): Double;
    function HighestIndex(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_PriceIndex: Integer; p_Position: Integer): Integer;
    function LowestIndex(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_PriceIndex: Integer; p_Position: Integer): Integer;
    procedure Indicator_NAverage(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_NAverage2(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_NXAverage(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_XAverage(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_WAverage(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    // procedure Indicator_WAverage2(p_Count:Integer; p_SrcValueArray:CFNNAVAnalLineValueSeries; p_SrcIndex:Integer; p_TagIndex:Integer; p_Begin:Integer = -1; p_End:Integer = -1);
    procedure Indicator_WAverage3(p_Count: Integer; p_Precision: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
      p_End: Integer = -1);

    procedure Indicator_Subtraction(p_SrcLineSeries1: CFNNAVAnalLineValueSeries; p_SrcIndex1: Integer; p_SrcValueArray2: CFNNAVAnalLineValueSeries; p_SrcIndex2: Integer; p_TagIndex: Integer;
      p_Begin: Integer = -1; p_End: Integer = -1);
    procedure Indicator_Division(p_SrcLineSeries1: CFNNAVAnalLineValueSeries; p_SrcIndex1: Integer; p_SrcValueArray2: CFNNAVAnalLineValueSeries; p_SrcIndex2: Integer; p_TagIndex: Integer;
      p_Begin: Integer = -1; p_End: Integer = -1);

    procedure Indicator_StdDev(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_PriceIndex: Integer; p_SrcValueArray2: CFNNAVAnalLineValueSeries; p_MIndex: Integer; p_TagIndex: Integer;
      p_Begin: Integer = -1; p_End: Integer = -1);
  end;

implementation

uses
  DateUtils, FNGlobal, FNVolumePriceArray;

// ---------------------------------------------------------------------------
{ /**
  * 생성자
  *
  * @param    p_Name         라인의 이름
  * @param    p_Type         라인의 형식
  * @param    p_LineCount    전체 라인의 수
  * @param    p_OptionCount  옵션의 수
  * @param    p_ValueCount   가로선의 수
  * @param    p_MaxMinCount  최대최소값의 수
  **/ }
constructor CFNNAVAnalLineValueSeries.Create(p_Name: String; p_Type: Integer; p_LineCount: Integer = 1; p_OptionCount: Integer = 0; p_ValueCount: Integer = 0; p_MaxMinCount: Integer = 1);
var
  f_Index: Integer;
  p_MaxMin: CFNNAVAnalMaxMin;
begin
  inherited Create;
  m_Signal := FALSE;
  m_Effect := FALSE;
  m_Items := TList.Create;
  m_Name := p_Name;
  m_FullName := p_Name;
  m_Type := p_Type;
  m_LineCount := p_LineCount;
  SetLength(m_LineColors, m_LineCount);
  SetLength(m_LineWidths, m_LineCount);
  SetLength(m_LineAlphas, m_LineCount);
  SetLength(m_LineTypes, m_LineCount);
  SetLength(m_LineNames, m_LineCount);
  SetLength(m_LineVisibles, m_LineCount);
  SetLength(m_LineLabelVisibles, m_LineCount);
  SetLength(m_LineLabelNameVisibles, m_LineCount);
  SetLength(m_LinePosValueVisibles, m_LineCount);
  SetLength(m_LineMaxMinIndexs, m_LineCount);
  SetLength(m_LineLastValueVisibles, m_LineCount);
  for f_Index := 0 to m_LineCount - 1 do
  begin
    m_LineColors[f_Index] := f_Index;
    m_LineWidths[f_Index] := 0;
    m_LineAlphas[f_Index] := 0;
    m_LineTypes[f_Index] := 0;
    m_LineNames[f_Index] := '';
    m_LineVisibles[f_Index] := TRUE;
    m_LineLabelVisibles[f_Index] := TRUE;
    m_LineLabelNameVisibles[f_Index] := TRUE;
    m_LinePosValueVisibles[f_Index] := TRUE;
    m_LineLastValueVisibles[f_Index] := FALSE;
    m_LineMaxMinIndexs[f_Index] := 0;
  end;

  m_OptionCount := p_OptionCount;
  SetLength(m_Options, m_OptionCount);
  for f_Index := 0 to m_OptionCount - 1 do
  begin
    m_Options[f_Index] := 1;
  end;

  m_ValueCount := p_ValueCount;
  SetLength(m_Values, m_ValueCount);
  SetLength(m_ValueColors, m_ValueCount);
  SetLength(m_ValueWidths, m_ValueCount);
  SetLength(m_ValueEnables, m_ValueCount);
  for f_Index := 0 to m_ValueCount - 1 do
  begin
    m_Values[f_Index] := 0;
    m_ValueColors[f_Index] := f_Index;
    m_ValueWidths[f_Index] := 1;
    m_ValueEnables[f_Index] := TRUE;
  end;

  m_MaxMinCount := p_MaxMinCount;
  if (m_MaxMinCount <= 0) then
    m_MaxMinCount := 1;

  SetLength(m_MaxMinTable, m_MaxMinCount);
  SetLength(m_MaxMinFactor, m_MaxMinCount);
  for f_Index := 0 to m_MaxMinCount - 1 do
  begin
    p_MaxMin := CFNNAVAnalMaxMin.Create;
    m_MaxMinTable[f_Index] := p_MaxMin;
    m_MaxMinFactor[f_Index] := 1.0;
  end;

  m_TimeFrame := 360;
  m_Effect := FALSE;
  m_ViewLabel := TRUE;
  m_Precision := 2;
  m_StartIndex := 0;

  m_LastValueVisible := FALSE;

end;

// ---------------------------------------------------------------------------
destructor CFNNAVAnalLineValueSeries.Destroy;
var
  f_Index: Integer;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;
  m_LineColors := NIL;
  m_LineWidths := NIL;
  m_LineAlphas := NIL;
  m_LineTypes := NIL;
  m_LineNames := NIL;
  m_LineVisibles := NIL;
  m_LineMaxMinIndexs := NIL;
  m_LineLabelVisibles := NIL;
  m_LineLabelNameVisibles := NIL;
  m_LinePosValueVisibles := NIL;

  for f_Index := 0 to m_MaxMinCount - 1 do
  begin
    CFNNAVAnalMaxMin(m_MaxMinTable[f_Index]).Free;
    m_MaxMinTable[f_Index] := NIL;
  end;
  m_MaxMinTable := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalLineValueSeries.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNNAVAnalLineValue(m_Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

procedure CFNNAVAnalLineValueSeries.Clone(p_Source: CFNNAVAnalLineValueSeries);
var
  f_LineIndex: Integer;
  f_ValueIndex: Integer;
  f_TagValue: CFNNAVAnalLineValue;
  f_SrcValue: CFNNAVAnalLineValue;
begin
  Clear;
  SetLengthSeries(p_Source.m_Items.Count);

  for f_ValueIndex := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_SrcValue := p_Source.m_Items[f_ValueIndex];
    f_TagValue := m_Items[f_ValueIndex];
    for f_LineIndex := 0 to m_LineCount - 1 do
    begin
      f_TagValue.m_Value[f_LineIndex] := f_SrcValue.m_Value[f_LineIndex];
    end;
  end;
  m_ChartDataSeries := p_Source.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CFNNAVAnalLineValueSeries.Update(p_Source: CFNNAVAnalLineValueSeries);
var
  f_LineIndex: Integer;
  f_ValueIndex: Integer;
  f_TagValue: CFNNAVAnalLineValue;
  f_SrcValue: CFNNAVAnalLineValue;
  f_Begin, f_End: Integer;
begin
  if m_Items.Count > 0 then
  begin
    f_Begin := m_Items.Count - 1;
    if f_Begin < 0 then
      f_Begin := 0;
    f_End := p_Source.m_Items.Count;

    SetLengthSeries(p_Source.m_Items.Count);

    for f_ValueIndex := f_Begin to f_End - 1 do
    begin
      f_SrcValue := p_Source.m_Items[f_ValueIndex];
      f_TagValue := m_Items[f_ValueIndex];
      for f_LineIndex := 0 to m_LineCount - 1 do
      begin
        f_TagValue.m_Value[f_LineIndex] := f_SrcValue.m_Value[f_LineIndex];
      end;
    end;
  end
  else
  begin
    Clone(p_Source);
  end;
end;

// ---------------------------------------------------------------------------
{ **
  * 지정한 갯수만큼 데이터를 모두 채운다.
  *
  * @param    p_Count
  ** }
procedure CFNNAVAnalLineValueSeries.Fill(p_Count: Integer);
var
  f_Index: Integer;
  f_Value: CFNNAVAnalLineValue;
begin
  for f_Index := 0 to p_Count - 1 do
  begin
    f_Value := CFNNAVAnalLineValue.Create(m_LineCount);
    m_Items.Add(f_Value);
  end;
end;

// ---------------------------------------------------------------------------
{ **
  * 라인의 최대값과 최소값을 계산한다. 이때 라인의 Type과 비교모드의 상태에 따라 계산방법이 달라 지므로 주의하여야한다.
  *
  * @param    p_X1            시작인덱스
  * @param    p_X2            마자막인덱스
  * @param    p_Origin        비교모드일 때 기준인덱스, 기준인덱의 값을 100으로 보면된다.
  * @param    p_CompareState  비교모드인지 아닌지 결정한다
  ** }
procedure CFNNAVAnalLineValueSeries.GetLineMaxMin(p_X1, p_X2: Integer);
var
  f_MaxLength: Integer;
  f_Index: Integer;
  f_Line: Integer;
  f_MaxMin: Integer;
  f_X1: Integer;
  f_X2: Integer;
  f_YOldMaxMin: Double;
  f_YNewMaxMin: Double;
  f_LineValue: CFNNAVAnalLineValue;

  f_Value: Double;
  f_ChartData: CFNNAVAnalChartData;
begin
  if (m_ChartDataSeries = NIL) then
    f_MaxLength := m_Items.Count
  else
    f_MaxLength := m_ChartDataSeries.m_Items.Count;

  f_X1 := p_X1;
  f_X2 := p_X2;

  if (f_X1 < 0) then
    f_X1 := 0;

  if (f_X1 >= f_MaxLength) then
    f_X1 := f_MaxLength - 1;

  if (f_X1 < 0) then
    f_X2 := 0;

  if (f_X2 >= f_MaxLength) then
    f_X2 := f_MaxLength - 1;

  if ((f_X1 < 0) or (f_X1 < 0)) then
    exit;

  for f_MaxMin := 0 to m_MaxMinCount - 1 do
  begin
    m_MaxMinTable[f_MaxMin].m_YMax := MIN_VALUE;
    m_MaxMinTable[f_MaxMin].m_YMin := MAX_VALUE;
  end;

{$REGION '그 밖의 차트'}
  for f_MaxMin := 0 to m_MaxMinCount - 1 do
  begin
    m_MaxMinTable[f_MaxMin].m_XMin := p_X1;
    m_MaxMinTable[f_MaxMin].m_XMax := p_X2;
  end;

  for f_Line := 0 to m_LineCount - 1 do
  begin
    if (not m_LineVisibles[f_Line]) then
      continue;
    if (4 = m_LineTypes[f_Line]) then
      continue;

    f_Index := f_X1;
    while ((f_Index <= f_X2) and (f_Index < m_Items.Count)) do
    begin
      f_LineValue := CFNNAVAnalLineValue(m_Items[f_Index]);
      if (f_LineValue.m_Value[f_Line] = NOT_VALUE) then
      begin
        Inc(f_Index);
        continue;
      end;

      if (f_LineValue.m_Value[f_Line] > m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMax) then
        m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMax := f_LineValue.m_Value[f_Line];

      if (f_LineValue.m_Value[f_Line] < m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMin) then
        m_MaxMinTable[m_LineMaxMinIndexs[f_Line]].m_YMin := f_LineValue.m_Value[f_Line];

      Inc(f_Index);
    end;
  end;

{$ENDREGION}
  if (m_MaxMinFactor[f_MaxMin] <> 1.0) then
  begin
    for f_MaxMin := 0 to m_MaxMinCount - 1 do
    begin
      f_YOldMaxMin := m_MaxMinTable[f_MaxMin].m_YMax - m_MaxMinTable[f_MaxMin].m_YMin;
      f_YNewMaxMin := f_YOldMaxMin * m_MaxMinFactor[f_MaxMin];
      m_MaxMinTable[f_MaxMin].m_YMax := m_MaxMinTable[f_MaxMin].m_YMax + (f_YNewMaxMin - f_YOldMaxMin) / 2;
      m_MaxMinTable[f_MaxMin].m_YMin := m_MaxMinTable[f_MaxMin].m_YMin - (f_YNewMaxMin - f_YOldMaxMin) / 2;
    end;
  end;
end;

// ---------------------------------------------------------------------------
{ **
  *  p_Position에서 p_Position--p_Count+1 까지 최대값이 들어 있는 인덱스를 찾는다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_PriceIndex
  * @param    p_Position
  ** }
function CFNNAVAnalLineValueSeries.HighestIndex(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_PriceIndex, p_Position: Integer): Integer;
var
  f_Index: Integer;
  f_DHighest: Double;
  f_HighestIndex: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
    Result := 0;

  f_DHighest := MIN_VALUE;
  if (p_Position - p_Count + 1 < 0) then
    p_Count := p_Position + 1;

  for f_Index := 0 to p_Count - 1 do
  begin
    if (f_DHighest < CFNNAVAnalLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex]) then
    begin
      f_DHighest := CFNNAVAnalLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex];
      f_HighestIndex := p_Position - f_Index;
    end;
  end;

  Result := f_HighestIndex;
end;

// ---------------------------------------------------------------------------
{ **
  *  p_Position에서 p_Position--p_Count+1 까지 최대값을 찾는다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_PriceIndex
  * @param    p_Position
  ** }
function CFNNAVAnalLineValueSeries.HighestPrice(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_PriceIndex, p_Position: Integer): Double;
var
  f_Index: Integer;
  f_DHighest: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
  begin
    Result := 0.0;
    exit;
  end;

  f_DHighest := MIN_VALUE;
  if (p_Position - p_Count + 1 < 0) then
    p_Count := p_Position + 1;

  for f_Index := 0 to p_Count - 1 do
  begin
    if (f_DHighest < CFNNAVAnalLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex]) then
      f_DHighest := CFNNAVAnalLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex];
  end;

  Result := f_DHighest;
end;

// ---------------------------------------------------------------------------
{ **
  * 최대 최소를 계산할 갯수로서 p_Position에서 p_Position--p_Count+1 까지 구간의 최대 최소를 계산한다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray  라인 시리즈
  * @param    p_HiIndex        고가가 들어 있는 인덱스
  * @param    p_LoIndex        저가가 들어 잇는 인덱스
  * @param    p_Position       현재 위치
  * @param    p_HiLow          최대값과 최소값을 담아서 전달한다.
  ** }
procedure CFNNAVAnalLineValueSeries.HiLoPrice(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_HiIndex, p_LoIndex, p_Position: Integer; var f_Hi, f_Low: Double);
var
  f_Index: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
    exit;

  // p_HiLow.x := MIN_VALUE;
  // p_HiLow.y := MAX_VALUE;
  f_Hi := MIN_VALUE; // -1.0E100;
  f_Low := MAX_VALUE; // 1.0E100;

  if (p_Position - p_Count + 1 < 0) then
    p_Count := p_Position + 1;

  for f_Index := 0 to p_Count - 1 do
  begin
    if (f_Hi < CFNNAVAnalLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_HiIndex]) then
      f_Hi := CFNNAVAnalLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_HiIndex];

    if (f_Low > CFNNAVAnalLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_LoIndex]) then
      f_Low := CFNNAVAnalLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_LoIndex];
  end;
end;

// ---------------------------------------------------------------------------
{ **
  * 두 라인의 나눗셈을 계산한다.
  *
  * @param    p_SrcLineSeries1
  * @param    p_SrcIndex1
  * @param    p_SrcValueArray2
  * @param    p_SrcIndex2
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CFNNAVAnalLineValueSeries.Indicator_Division(p_SrcLineSeries1: CFNNAVAnalLineValueSeries; p_SrcIndex1: Integer; p_SrcValueArray2: CFNNAVAnalLineValueSeries;
  p_SrcIndex2, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
begin
  if not Assigned(p_SrcLineSeries1) then
    exit;
  if not Assigned(p_SrcValueArray2) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcLineSeries1.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if ((CFNNAVAnalLineValue(p_SrcLineSeries1.m_Items[f_Index]).m_Value[p_SrcIndex1] <> NOT_VALUE) and (CFNNAVAnalLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_SrcIndex2] <> NOT_VALUE)) then
    begin
      if (CFNNAVAnalLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_SrcIndex2] <> 0) then
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CFNNAVAnalLineValue(p_SrcLineSeries1.m_Items[f_Index]).m_Value[p_SrcIndex1] / CFNNAVAnalLineValue(p_SrcValueArray2.m_Items[f_Index]
          ).m_Value[p_SrcIndex2]
      else
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
    end;
  end;

  m_ChartDataSeries := p_SrcLineSeries1.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 단순이동평균을 계산한다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CFNNAVAnalLineValueSeries.Indicator_NAverage(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_AllEffect: Boolean;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if (f_Index < p_Count - 1) then
      continue;

    if (f_Index < 1) then
      continue;

    if (CFNNAVAnalLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] = NOT_VALUE) then
    begin
      if (not f_AllEffect) then
      begin
        f_AllEffect := (CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_SrcIndex] <> NOT_VALUE);
        if (f_AllEffect) then
        begin
          f_Index1 := 0;
          f_Sum := 0;
          while (f_Index1 < p_Count) do
          begin
            f_Sum := f_Sum + CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];

            Inc(f_Index1);
          end;

          CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / p_Count;
        end;

        continue;
      end;
    end
    else if (f_Index >= p_Count) then
    begin
      CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := (CFNNAVAnalLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] * p_Count + CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index])
        .m_Value[p_SrcIndex] - CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - p_Count]).m_Value[p_SrcIndex]) / p_Count;
    end
    else
    begin
      continue;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

procedure CFNNAVAnalLineValueSeries.Indicator_NAverage2(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_AllEffect: Boolean;
  f_Count: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if (f_Index < p_Count - 1) then
      continue;
    if (f_Index < 1) then
      continue;

    if ((f_Index < p_Count - 1) or (f_Index < 1)) then
    begin
      f_Count := f_Index + 1;
      f_Sum := 0;
      for f_Index1 := 0 to f_Count - 1 do
      begin
        f_Sum := f_Sum + CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
      end;
      CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_Count;
    end
    else
    begin
      if (CFNNAVAnalLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] = NOT_VALUE) then
      begin
        if (not f_AllEffect) then
        begin
          f_AllEffect := (CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_SrcIndex] <> NOT_VALUE);
          if (f_AllEffect) then
          begin
            f_Index1 := 0;
            f_Sum := 0;
            while (f_Index1 < p_Count) do
            begin
              f_Sum := f_Sum + CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];

              Inc(f_Index1);
            end;

            CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / p_Count;
          end;

          continue;
        end;
      end
      else if (f_Index >= p_Count) then
      begin
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := (CFNNAVAnalLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] * p_Count + CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index])
          .m_Value[p_SrcIndex] - CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - p_Count]).m_Value[p_SrcIndex]) / p_Count;
      end
      else
      begin
        continue;
      end;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 단순이동평균을 근사치로 계산한다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CFNNAVAnalLineValueSeries.Indicator_NXAverage(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_AllEffect: Boolean;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if ((f_Index < p_Count - 1) or (f_Index < 1)) then
      continue;

    if (CFNNAVAnalLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] <> NOT_VALUE) then
      f_AllEffect := TRUE;

    if (not f_AllEffect) then
    begin
      f_AllEffect := (CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_SrcIndex] <> NOT_VALUE);
      if (f_AllEffect) then
      begin
        f_Sum := 0;
        for f_Index1 := 0 to p_Count - 1 do
        begin
          f_Sum := f_Sum + CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        end;

        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / p_Count;
      end;

      continue;
    end;

    CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CFNNAVAnalLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] - CFNNAVAnalLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] / p_Count
      + CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] / p_Count;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 표준편차를 계산한다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_PriceIndex
  * @param    p_SrcValueArray2
  * @param    p_MIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CFNNAVAnalLineValueSeries.Indicator_StdDev(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_PriceIndex: Integer; p_SrcValueArray2: CFNNAVAnalLineValueSeries;
  p_MIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Sum: Double;
  f_v0: Double;
  f_v1: Double;
  f_v2: Double;
  f_Index2: Integer;
  f_Index: Integer;
  f_Size: Integer;
  f_AllEffect: Boolean;
  f_MA0: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  if not Assigned(p_SrcValueArray2) then
    exit;
  f_AllEffect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  m_Effect := FALSE;

  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := f_Size;
  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  f_Sum := 0;
  f_v1 := 0;
  for f_Index := p_Begin to p_End - 1 do
  begin
    CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if (f_Index < p_Count - 1) then
      continue;

    if (not f_AllEffect) then
    begin
      if ((CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_PriceIndex] <> NOT_VALUE) and
        (CFNNAVAnalLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_MIndex] <> NOT_VALUE)) then
        f_AllEffect := TRUE
      else
        f_AllEffect := FALSE;

      if (f_AllEffect) then
      begin
        f_MA0 := CFNNAVAnalLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_MIndex];
        f_Sum := 0;
        for f_Index2 := 0 to p_Count - 1 do
        begin
          f_v1 := (f_MA0 - CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[p_PriceIndex]);
          f_Sum := f_Sum + (f_v1 * f_v1);
        end;
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Sqrt(f_Sum / p_Count);
      end;

      continue;
    end;

    f_v0 := 0;
    f_v2 := 0;
    if (f_Index >= p_Count) then
    begin
      f_MA0 := CFNNAVAnalLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_MIndex];
      f_Sum := 0;
      for f_Index2 := 0 to p_Count - 1 do
      begin
        f_v1 := (f_MA0 - CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[p_PriceIndex]);
        f_Sum := f_Sum + (f_v1 * f_v1);
      end;
      CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Sqrt(f_Sum / p_Count);
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 두라인의 차이를 계산한다.
  *
  * @param    p_SrcLineSeries1
  * @param    p_SrcIndex1
  * @param    p_SrcValueArray2
  * @param    p_SrcIndex2
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CFNNAVAnalLineValueSeries.Indicator_Subtraction(p_SrcLineSeries1: CFNNAVAnalLineValueSeries; p_SrcIndex1: Integer; p_SrcValueArray2: CFNNAVAnalLineValueSeries;
  p_SrcIndex2, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
begin
  if not Assigned(p_SrcLineSeries1) then
    exit;
  if not Assigned(p_SrcValueArray2) then
    exit;
  m_Effect := FALSE;
  f_Size := p_SrcLineSeries1.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if ((CFNNAVAnalLineValue(p_SrcLineSeries1.m_Items[f_Index]).m_Value[p_SrcIndex1] <> NOT_VALUE) and (CFNNAVAnalLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_SrcIndex2] <> NOT_VALUE)) then
      CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CFNNAVAnalLineValue(p_SrcLineSeries1.m_Items[f_Index]).m_Value[p_SrcIndex1] - CFNNAVAnalLineValue(p_SrcValueArray2.m_Items[f_Index])
        .m_Value[p_SrcIndex2];
  end;

  m_ChartDataSeries := p_SrcLineSeries1.m_ChartDataSeries;
  m_Effect := TRUE;

end;

// ---------------------------------------------------------------------------
{ **
  * 가중이동평균을 계산한다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CFNNAVAnalLineValueSeries.Indicator_WAverage(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_CSum: Double;
  f_Price: Double;
  f_AllEffect: Boolean;
  f_Factor: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Sum := 0;
    f_CSum := 0;
    if (f_Index - p_Count + 1 > 0) then
    begin
      for f_Index1 := 0 to p_Count - 1 do
      begin
        f_Price := CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        f_Sum := f_Sum + f_Price * (p_Count - f_Index1);
        f_CSum := f_CSum + p_Count - f_Index1;
      end;

      if (f_CSum > 0) then
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum
      else
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
    end
    else
    begin
      CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

(*
  procedure CFNNAVAnalLineValueSeries.Indicator_WAverage2(p_Count: Integer;
  p_SrcValueArray: CFNNAVAnalLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
  var
  f_Size      : Integer;
  f_Index     : Integer;
  f_Index1    : Integer;
  f_Sum       : Double;
  f_CSum      : Double;
  f_Price     : Double;
  f_AllEffect : Boolean;
  f_Factor    : Double;
  f_Count     : Integer;
  f_Factor2   : Double;
  begin
  f_Factor2 := Math.Power(10, 6);
  if not Assigned(p_SrcValueArray) then exit;
  f_AllEffect := false;
  m_Effect    := false;
  f_Size      := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
  p_Begin := 0;

  if (p_End = -1) then
  p_End := f_Size;

  if (p_End > f_Size) then
  p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
  p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
  f_Sum := 0;
  f_CSum := 0;
  if (f_Index - p_Count + 1 > 0) then
  begin
  for f_Index1 := 0 to p_Count - 1 do
  begin
  f_Price := CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
  f_Sum   := f_Sum + f_Price * (p_Count - f_Index1);
  f_CSum  := f_CSum + p_Count - f_Index1;
  end;

  if (f_CSum > 0) then
  begin
  CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
  CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Round(CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] * f_Factor2) / f_Factor2;
  end else
  begin
  CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
  end;
  end
  else
  begin
  f_Count := f_Index + 1;
  for f_Index1 := 0 to f_Count - 1 do
  begin
  f_Price := CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
  f_Sum   := f_Sum + f_Price * (f_Count - f_Index1);
  f_CSum  := f_CSum + f_Count - f_Index1;
  end;

  if (f_CSum > 0) then
  begin
  CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
  CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Round(CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] * f_Factor2) / f_Factor2;
  end else
  begin
  CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
  end;
  end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
  end; *)
// -------------------------------------------------------------------------------------------------------
procedure CFNNAVAnalLineValueSeries.Indicator_WAverage3(p_Count: Integer; p_Precision: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer;
  p_Begin: Integer = -1; p_End: Integer = -1);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_CSum: Double;
  f_Price: Double;
  f_AllEffect: Boolean;
  f_Factor: Double;
  f_Count: Integer;
  f_Factor2: Double;
begin
  f_Factor2 := Math.Power(10, p_Precision);
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_Sum := 0;
    f_CSum := 0;
    if (f_Index - p_Count + 1 > 0) then
    begin
      for f_Index1 := 0 to p_Count - 1 do
      begin
        f_Price := CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        f_Sum := f_Sum + f_Price * (p_Count - f_Index1);
        f_CSum := f_CSum + p_Count - f_Index1;
      end;

      if (f_CSum > 0) then
      begin
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Round(CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] * f_Factor2) / f_Factor2;
      end
      else
      begin
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
      end;
    end
    else
    begin
      f_Count := f_Index + 1;
      for f_Index1 := 0 to f_Count - 1 do
      begin
        f_Price := CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        f_Sum := f_Sum + f_Price * (f_Count - f_Index1);
        f_CSum := f_CSum + f_Count - f_Index1;
      end;

      if (f_CSum > 0) then
      begin
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Round(CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] * f_Factor2) / f_Factor2;
      end
      else
      begin
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
      end;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  * 지수이동평균을 계산한다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_SrcIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CFNNAVAnalLineValueSeries.Indicator_XAverage(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_AllEffect: Boolean;
  f_Factor: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := FALSE;
  m_Effect := FALSE;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  if (p_Begin = -1) then
    p_Begin := 0;

  if (p_End = -1) then
    p_End := f_Size;

  if (p_End > f_Size) then
    p_End := f_Size;

  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;

  if (p_Begin < 0) then
    p_Begin := 0;

  if (p_Count + 1 <> 0) then
  begin
    f_Factor := 2.0 / (p_Count + 1);
    for f_Index := p_Begin to p_End - 1 do
    begin
      if (CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] = NOT_VALUE) then
      begin
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        continue;
      end;

      if ((f_Index <= 0) or (CFNNAVAnalLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] = NOT_VALUE)) then
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex]
      else
        CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CFNNAVAnalLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] * f_Factor + (1 - f_Factor) *
          CFNNAVAnalLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex];
    end;
  end
  else
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      CFNNAVAnalLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := TRUE;
end;

// ---------------------------------------------------------------------------
{ **
  *  p_Position에서 p_Position--p_Count+1 까지 최소값이 들어 있는 인덱스를 찾는다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_PriceIndex
  * @param    p_Position
  ** }
function CFNNAVAnalLineValueSeries.LowestIndex(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_PriceIndex, p_Position: Integer): Integer;
var
  f_Index: Integer;
  f_DLowest: Double;
  f_LowestIndex: Integer;
begin
  if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
  begin
    Result := 0;
    exit;
  end;

  f_DLowest := MAX_VALUE;
  if (p_Position - p_Count + 1 < 0) then
    p_Count := p_Position + 1;

  for f_Index := 0 to p_Count - 1 do
  begin
    if (f_DLowest > CFNNAVAnalLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex]) then
    begin
      f_DLowest := CFNNAVAnalLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex];
      f_LowestIndex := p_Position - f_Index;
    end;
  end;

  Result := f_LowestIndex;
end;

// ---------------------------------------------------------------------------
{ **
  *  p_Position에서 p_Position--p_Count+1 까지 최소값을 찾는다.
  *
  * @param    p_Count
  * @param    p_SrcValueArray
  * @param    p_PriceIndex
  * @param    p_Position
  ** }
function CFNNAVAnalLineValueSeries.LowestPrice(p_Count: Integer; p_SrcValueArray: CFNNAVAnalLineValueSeries; p_PriceIndex, p_Position: Integer): Double;
var
  f_Index: Integer;
  f_DLowest: Double;
begin
  if (((p_Count <= 0) or (p_Count >= p_SrcValueArray.m_Items.Count)) or ((p_Position < 0) or (p_Position >= p_SrcValueArray.m_Items.Count))) then
  begin
    Result := 0.0;
    exit;
  end;

  f_DLowest := MAX_VALUE;
  if (p_Position - p_Count + 1 < 0) then
    p_Count := p_Position + 1;

  for f_Index := 0 to p_Count - 1 do
  begin
    if (f_DLowest > CFNNAVAnalLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex]) then
      f_DLowest := CFNNAVAnalLineValue(p_SrcValueArray.m_Items[p_Position - f_Index]).m_Value[p_PriceIndex];
  end;

  Result := f_DLowest;
end;

// ---------------------------------------------------------------------------
{ **
  * 라인의 수를 설정한다.
  *
  * @param    p_LineCount  라인의 수
  ** }
procedure CFNNAVAnalLineValueSeries.SetLineCount(p_LineCount: Integer);
var
  f_Index: Integer;
begin
  Clear;

  m_LineCount := p_LineCount;
  SetLength(m_LineColors, m_LineCount);
  SetLength(m_LineWidths, m_LineCount);
  SetLength(m_LineAlphas, m_LineCount);
  SetLength(m_LineTypes, m_LineCount);
  SetLength(m_LineNames, m_LineCount);
  SetLength(m_LineVisibles, m_LineCount);
  SetLength(m_LineLabelVisibles, m_LineCount);
  SetLength(m_LineLabelNameVisibles, m_LineCount);
  SetLength(m_LinePosValueVisibles, m_LineCount);
  SetLength(m_LineMaxMinIndexs, m_LineCount);
  for f_Index := 0 to m_LineCount - 1 do
  begin
    m_LineColors[f_Index] := f_Index;
    m_LineWidths[f_Index] := 0;
    m_LineAlphas[f_Index] := 0;
    m_LineTypes[f_Index] := 0;
    m_LineNames[f_Index] := '';
    m_LineVisibles[f_Index] := TRUE;
    m_LineLabelVisibles[f_Index] := TRUE;
    m_LineLabelNameVisibles[f_Index] := TRUE;
    m_LinePosValueVisibles[f_Index] := TRUE;
    m_LineMaxMinIndexs[f_Index] := 0;
  end;
end;

// ---------------------------------------------------------------------------
{ **
  * 값의 갯수를 결정한다.
  *
  * @param    p_Length
  ** }
procedure CFNNAVAnalLineValueSeries.SetLengthSeries(p_Length: Integer);
var
  f_Value: CFNNAVAnalLineValue;
  f_Index: Integer;
  f_delIndex: Integer;
  f_DelCnt: Integer;
  f_DelTotalCnt: Integer;
begin
  while (p_Length > m_Items.Count) do
  begin
    f_Value := CFNNAVAnalLineValue.Create(m_LineCount);
    m_Items.Add(f_Value);
  end;

  // if (p_Length < m_Items.length) {
  // m_Items.splice(p_Length - 1, m_Items.length - p_Length);
  // }

  f_delIndex := p_Length - 1;
  f_DelCnt := 0;
  f_DelTotalCnt := (m_Items.Count - p_Length);
  while (f_DelCnt < f_DelTotalCnt) do
  begin
    f_Value := CFNNAVAnalLineValue(m_Items[f_delIndex]);
    f_Value.Free;
    m_Items.Delete(f_delIndex);

    Inc(f_DelCnt);
  end;
end;

procedure CFNNAVAnalLineValueSeries.CreateLineValueAdd(p_Index: Integer; p_Value: Double; p_Count: Integer = 1);
var
  f_Index: Integer;
  f_Value: CFNNAVAnalLineValue;
begin
  for f_Index := 0 to p_Count - 1 do
  begin
    f_Value := CFNNAVAnalLineValue.Create(m_LineCount);
    f_Value.m_Value[p_Index] := p_Value;
    m_Items.Add(f_Value);
  end;
end;

end.
