unit MXTSLineValueSeries;

interface

uses
  SysUtils, Classes, Types, Math, GR32,
  MKChartDataSeries, MKMaxMin, MKStreamChartDataSeries, MKLineValue, MKConst,
  MKChartData,
  MKSignalArray,
  MKSignalData,
  MKTradeSignalDefine,
  MKLineValueSeries;

type

  CMXTSLineValueSeries = class(CMKLineValueSeries)
  public

    procedure TS_MajorLine1(p_ValueType: Integer; p_ChartDataSeries: CMKChartDataSeries; p_TempValueArray: CMXTSLineValueSeries;
        p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_MajorLine2(p_ValueType: Integer; p_ChartDataSeries: CMKChartDataSeries; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure TS_CurveFitting(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_OIndex: Integer; p_PIndex: Integer;
        p_OMAIndex: Integer; p_PMAIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);

    function GetLineValueDay(p_DayChartDataSeries: CMKChartDataSeries; AStandDate: Double; APosition: Integer): CMKChartData;
    function GetLineValueDayO(p_DayChartDataSeries: CMKChartDataSeries; AStandDate: Double; APosition: Integer;
        AValueType: Integer): Double;
    function GetLineValueDayH(p_DayChartDataSeries: CMKChartDataSeries; AStandDate: Double; APosition: Integer;
        AValueType: Integer): Double;
    function GetLineValueDayL(p_DayChartDataSeries: CMKChartDataSeries; AStandDate: Double; APosition: Integer;
        AValueType: Integer): Double;
    function GetLineValueDayC(p_DayChartDataSeries: CMKChartDataSeries; AStandDate: Double; APosition: Integer;
        AValueType: Integer): Double;
    function GetLineValueDayHL(p_DayChartDataSeries: CMKChartDataSeries; AStandDate: Double; APosition: Integer;
        AValueType: Integer): Double;

    procedure TS_DayO(p_ChartDataSeries: CMKChartDataSeries; p_DayChartDataSeries: CMKChartDataSeries; APosition: Integer;
        AValueType: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_DayH(p_ChartDataSeries: CMKChartDataSeries; p_DayChartDataSeries: CMKChartDataSeries; APosition: Integer;
        AValueType: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_DayL(p_ChartDataSeries: CMKChartDataSeries; p_DayChartDataSeries: CMKChartDataSeries; APosition: Integer;
        AValueType: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_DayC(p_ChartDataSeries: CMKChartDataSeries; p_DayChartDataSeries: CMKChartDataSeries; APosition: Integer;
        AValueType: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_DayHL(p_ChartDataSeries: CMKChartDataSeries; p_DayChartDataSeries: CMKChartDataSeries; APosition: Integer;
        AValueType: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);

    procedure TS_IntraDayO(p_ChartDataSeries: CMKChartDataSeries; AValueType: Integer; p_TagIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_IntraDayH(p_ChartDataSeries: CMKChartDataSeries; AValueType: Integer; p_TagIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_IntraDayL(p_ChartDataSeries: CMKChartDataSeries; AValueType: Integer; p_TagIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_IntraDayC(p_ChartDataSeries: CMKChartDataSeries; AValueType: Integer; p_TagIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_IntraDayHL(p_ChartDataSeries: CMKChartDataSeries; AValueType: Integer; p_TagIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);

    procedure TS_RSI(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);

    procedure TS_HLPrice(p_SrcValueArray: CMKLineValueSeries; p_HighIndex: Integer; p_LowIndex: Integer; p_TagIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_Disparity(p_PriceValueArray: CMKLineValueSeries; p_PIndex: Integer; p_MAValueArray: CMKLineValueSeries;
        p_MAIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);

    procedure TS_NAverage(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_XAverage(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_WAverage(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer; p_TagIndex: Integer;
        p_Begin: Integer = -1; p_End: Integer = -1);

    procedure TS_NAverageP(p_Count: Integer; p_Precision: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_XAverageP(p_Count: Integer; p_Precision: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_WAverageP(p_Count: Integer; p_Precision: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);

    procedure TS_SlowSTC(p_Length1: Integer; p_Length2: Integer; p_Length3: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_HighIndex: Integer; p_LowIndex: Integer; p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure TS_StdDev(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer;
        p_SrcValueArray2: CMKLineValueSeries; p_MIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);
    procedure TS_BBand(p_Count: Integer; p_Factor: Double; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer;
        p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
    procedure TS_BBWidth(p_Count: Integer; p_Factor: Double; p_MA: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_PIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);

    procedure TS_IMLine(p_Length1: Integer; p_Length2: Integer; p_Length3: Integer; p_SrcValueArray: CMKLineValueSeries;
        p_HighIndex: Integer; p_LowIndex: Integer; p_CloseIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
        p_End: Integer = -1);

  end;

implementation

uses MKGlobal;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_MajorLine1(p_ValueType: Integer; p_ChartDataSeries: CMKChartDataSeries;
    p_TempValueArray: CMXTSLineValueSeries; p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
  f_OPS0: Double;
  f_OPS1: Double;
begin
  m_Effect := false;
  f_Size := p_ChartDataSeries.m_Items.Count;
  SetLengthSeries(p_ChartDataSeries.m_Items.Count);

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

  if (p_ValueType = 0) then
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_Value := CMKLineValue(m_Items[f_Index]);
      f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
      f_Value.m_Value[0] := f_ChartData.m_OpenPrice;
      f_Value.m_Value[1] := f_ChartData.m_HighPrice;
      f_Value.m_Value[2] := f_ChartData.m_LowPrice;
      f_Value.m_Value[3] := f_ChartData.m_ClosePrice;
    end;
  end
  else if (p_ValueType = 1) then
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_Value := CMKLineValue(m_Items[f_Index]);
      f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
      f_Value.m_Value[0] := f_ChartData.m_OpenOPS;
      f_Value.m_Value[1] := f_ChartData.m_HighOPS;
      f_Value.m_Value[2] := f_ChartData.m_LowOPS;
      f_Value.m_Value[3] := f_ChartData.m_CloseOPS;
    end;
  end
  else if (p_ValueType = 2) then
  begin
    p_TempValueArray.SetLengthSeries(p_ChartDataSeries.m_Items.Count);

    for f_Index := p_Begin to p_End - 1 do
    begin
      f_Value := CMKLineValue(p_TempValueArray.m_Items[f_Index]);
      f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
      f_Value.m_Value[0] := f_ChartData.m_OpenPrice;
      f_Value.m_Value[1] := f_ChartData.m_HighPrice;
      f_Value.m_Value[2] := f_ChartData.m_LowPrice;
      f_Value.m_Value[3] := f_ChartData.m_ClosePrice;
      f_Value.m_Value[4] := f_ChartData.m_OpenOPS;
      f_Value.m_Value[5] := f_ChartData.m_HighOPS;
      f_Value.m_Value[6] := f_ChartData.m_LowOPS;
      f_Value.m_Value[7] := f_ChartData.m_CloseOPS;
    end;
    p_TempValueArray.TS_NAverage(60, p_TempValueArray, 0, 8, p_Begin, p_End);
    p_TempValueArray.TS_NAverage(60, p_TempValueArray, 1, 9, p_Begin, p_End);
    p_TempValueArray.TS_NAverage(60, p_TempValueArray, 2, 10, p_Begin, p_End);
    p_TempValueArray.TS_NAverage(60, p_TempValueArray, 3, 11, p_Begin, p_End);
    p_TempValueArray.TS_NAverage(60, p_TempValueArray, 4, 12, p_Begin, p_End);
    p_TempValueArray.TS_NAverage(60, p_TempValueArray, 5, 13, p_Begin, p_End);
    p_TempValueArray.TS_NAverage(60, p_TempValueArray, 6, 14, p_Begin, p_End);
    p_TempValueArray.TS_NAverage(60, p_TempValueArray, 7, 15, p_Begin, p_End);

    TS_CurveFitting(60, p_TempValueArray, 4, 0, 12, 8, 0, p_Begin, p_End);
    TS_CurveFitting(60, p_TempValueArray, 5, 1, 13, 9, 1, p_Begin, p_End);
    TS_CurveFitting(60, p_TempValueArray, 6, 2, 14, 10, 2, p_Begin, p_End);
    TS_CurveFitting(60, p_TempValueArray, 7, 3, 15, 11, 3, p_Begin, p_End);
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_MajorLine2(p_ValueType: Integer; p_ChartDataSeries: CMKChartDataSeries;
    p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
  f_OPS0: Double;
  f_OPS1: Double;
begin
  m_Effect := false;
  f_Size := p_ChartDataSeries.m_Items.Count;
  SetLengthSeries(p_ChartDataSeries.m_Items.Count);

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

  if (p_ValueType = 0) then
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_Value := CMKLineValue(m_Items[f_Index]);
      f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
      f_Value.m_Value[0] := f_ChartData.m_OpenPrice;
      f_Value.m_Value[1] := f_ChartData.m_HighPrice;
      f_Value.m_Value[2] := f_ChartData.m_LowPrice;
      f_Value.m_Value[3] := f_ChartData.m_ClosePrice;
    end;
  end
  else if (p_ValueType = 1) then
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      f_Value := CMKLineValue(m_Items[f_Index]);
      f_ChartData := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
      f_Value.m_Value[0] := f_ChartData.m_OpenOPS;
      f_Value.m_Value[1] := f_ChartData.m_HighOPS;
      f_Value.m_Value[2] := f_ChartData.m_LowOPS;
      f_Value.m_Value[3] := f_ChartData.m_CloseOPS;
    end;
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := true;
end;

procedure CMXTSLineValueSeries.TS_CurveFitting(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_OIndex: Integer;
    p_PIndex: Integer; p_OMAIndex: Integer; p_PMAIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1;
    p_End: Integer = -1);
var
  f_Count: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Size: Integer;
  f_ChartData: CMKChartData;
  f_Value: CMKLineValue;
  f_SrcValue: CMKLineValue;
  f_Value1: CMKLineValue;
  f_Value2: CMKLineValue;

  f_X: Double;
  f_Y: Double;
  f_XX: Double;
  f_YY: Double;
  f_XY: Double;

  f_SumX: Double;
  f_SumY: Double;
  f_SumXX: Double;
  f_SumYY: Double;
  f_SumXY: Double;

  f_AllEffect: Boolean;

  f_A0: Double;
  f_A1: Double;
begin
  m_Effect := false;
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
    f_Value := CMKLineValue(m_Items[f_Index]);
    f_Value.m_Value[p_TagIndex] := NOT_VALUE;

    if (f_Index < p_Count - 1) then
      continue;
    if (f_Index < 1) then
      continue;

    f_SrcValue := p_SrcValueArray.m_Items[f_Index];

    if (f_SrcValue.m_Value[p_OIndex] = NOT_VALUE) then
      continue;
    if (f_SrcValue.m_Value[p_PIndex] = NOT_VALUE) then
      continue;

    f_SumX := 0;
    f_SumY := 0;
    f_SumXX := 0;
    f_SumYY := 0;
    f_SumXY := 0;

    f_AllEffect := true;
    for f_Index1 := 0 to p_Count - 1 do
    begin
      f_Value1 := p_SrcValueArray.m_Items[f_Index - f_Index1];

      if ((f_Value1.m_Value[p_OIndex] = NOT_VALUE) OR (f_Value1.m_Value[p_PIndex] = NOT_VALUE)) then
      begin
        f_AllEffect := false;
        break;
      end;

      f_X := f_Value1.m_Value[p_OIndex];
      f_Y := f_Value1.m_Value[p_PIndex];
      f_XX := f_X * f_X;
      f_YY := f_Y * f_Y;
      f_XY := f_X * f_Y;
      f_SumX := f_SumX + f_X;
      f_SumY := f_SumY + f_Y;
      f_SumXX := f_SumXX + f_XX;
      f_SumYY := f_SumYY + f_YY;
      f_SumXY := f_SumXY + f_XY;
    end;

    if f_AllEffect then
    begin
      if ((f_SrcValue.m_Value[p_OMAIndex] <> NOT_VALUE) AND (f_SrcValue.m_Value[p_PMAIndex] <> NOT_VALUE)) then
      begin
        if (p_Count * f_SumXX - f_SumX * f_SumX) <> 0 then
        begin
          f_A1 := (p_Count * f_SumXY - f_SumX * f_SumY) / (p_Count * f_SumXX - f_SumX * f_SumX);
        end
        else
        begin
          f_A1 := 0;
        end;
        f_A0 := f_SrcValue.m_Value[p_PMAIndex] - f_A1 * f_SrcValue.m_Value[p_OMAIndex];
        f_Value1 := p_SrcValueArray.m_Items[f_Index];

        f_Value.m_Value[p_TagIndex] := f_A0 + f_A1 * f_Value1.m_Value[p_OIndex];
      end
      else
      begin

      end;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
function CMXTSLineValueSeries.GetLineValueDay(p_DayChartDataSeries: CMKChartDataSeries; AStandDate: Double; APosition: Integer)
    : CMKChartData;
var
  f_SearchIndex: Integer;
  f_DataIndex: Integer;
  f_ChartData: CMKChartData;
begin
  f_ChartData := NIL;
  if Assigned(p_DayChartDataSeries) then
  begin
    if (APosition < 0) then
      APosition := 0;

    f_SearchIndex := p_DayChartDataSeries.SearchDayByClose(Floor(AStandDate), true);
    if f_SearchIndex >= 0 then
    begin
      f_DataIndex := f_SearchIndex - APosition;
      if (f_DataIndex >= 0) then
      begin
        f_ChartData := p_DayChartDataSeries.m_Items[f_DataIndex];
      end;
    end;
  end;

  Result := f_ChartData;
end;

// ---------------------------------------------------------------------------
function CMXTSLineValueSeries.GetLineValueDayO(p_DayChartDataSeries: CMKChartDataSeries; AStandDate: Double; APosition: Integer;
    AValueType: Integer): Double;
var
  f_SearchIndex: Integer;
  f_DataIndex: Integer;
  f_ChartData: CMKChartData;
begin
  f_ChartData := GetLineValueDay(p_DayChartDataSeries, AStandDate, APosition);
  if Assigned(f_ChartData) then
  begin
    if (AValueType = 0) or (AValueType = 2) then
    begin
      Result := f_ChartData.m_OpenPrice;
    end
    else
    begin
      Result := f_ChartData.m_OpenOPS;
    end;
  end
  else
  begin
    Result := NOT_VALUE;
  end;
end;

// ---------------------------------------------------------------------------
function CMXTSLineValueSeries.GetLineValueDayH(p_DayChartDataSeries: CMKChartDataSeries; AStandDate: Double; APosition: Integer;
    AValueType: Integer): Double;
var
  f_SearchIndex: Integer;
  f_DataIndex: Integer;
  f_ChartData: CMKChartData;
begin
  f_ChartData := GetLineValueDay(p_DayChartDataSeries, AStandDate, APosition);
  if Assigned(f_ChartData) then
  begin
    if (AValueType = 0) or (AValueType = 2) then
    begin
      Result := f_ChartData.m_HighPrice;
    end
    else
    begin
      Result := f_ChartData.m_HighOPS;
    end;
  end
  else
  begin
    Result := NOT_VALUE;
  end;
end;

// ---------------------------------------------------------------------------
function CMXTSLineValueSeries.GetLineValueDayL(p_DayChartDataSeries: CMKChartDataSeries; AStandDate: Double; APosition: Integer;
    AValueType: Integer): Double;
var
  f_SearchIndex: Integer;
  f_DataIndex: Integer;
  f_ChartData: CMKChartData;
begin
  f_ChartData := GetLineValueDay(p_DayChartDataSeries, AStandDate, APosition);
  if Assigned(f_ChartData) then
  begin
    if (AValueType = 0) or (AValueType = 2) then
    begin
      Result := f_ChartData.m_LowPrice;
    end
    else
    begin
      Result := f_ChartData.m_LowOPS;
    end;
  end
  else
  begin
    Result := NOT_VALUE;
  end;
end;

// ---------------------------------------------------------------------------
function CMXTSLineValueSeries.GetLineValueDayHL(p_DayChartDataSeries: CMKChartDataSeries; AStandDate: Double;
    APosition: Integer; AValueType: Integer): Double;
var
  f_SearchIndex: Integer;
  f_DataIndex: Integer;
  f_ChartData: CMKChartData;
begin
  f_ChartData := GetLineValueDay(p_DayChartDataSeries, AStandDate, APosition);
  if Assigned(f_ChartData) then
  begin
    if (AValueType = 0) or (AValueType = 2) then
    begin
      Result := (f_ChartData.m_HighPrice + f_ChartData.m_LowPrice) / 2.0;
    end
    else
    begin
      Result := (f_ChartData.m_HighOPS + f_ChartData.m_LowOPS) / 2.0;
    end;
  end
  else
  begin
    Result := NOT_VALUE;
  end;
end;

// ---------------------------------------------------------------------------
function CMXTSLineValueSeries.GetLineValueDayC(p_DayChartDataSeries: CMKChartDataSeries; AStandDate: Double; APosition: Integer;
    AValueType: Integer): Double;
var
  f_SearchIndex: Integer;
  f_DataIndex: Integer;
  f_ChartData: CMKChartData;
begin
  f_ChartData := GetLineValueDay(p_DayChartDataSeries, AStandDate, APosition);
  if Assigned(f_ChartData) then
  begin
    if (AValueType = 0) or (AValueType = 2) then
    begin
      Result := f_ChartData.m_ClosePrice;
    end
    else
    begin
      Result := f_ChartData.m_CloseOPS;
    end;
  end
  else
  begin
    Result := NOT_VALUE;
  end;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_DayC(p_ChartDataSeries, p_DayChartDataSeries: CMKChartDataSeries;
    APosition, AValueType, p_TagIndex: Integer; p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;
  f_Value0: CMKLineValue;
  f_Value1: CMKLineValue;
begin
  m_Effect := false;
  f_Size := p_ChartDataSeries.m_Items.Count;
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
    f_ChartData0 := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    f_Value0 := CMKLineValue(m_Items[f_Index]);
    if (f_Index > 0) then
    begin
      f_ChartData1 := CMKChartData(p_ChartDataSeries.m_Items[f_Index - 1]);
      f_Value1 := CMKLineValue(m_Items[f_Index - 1]);

      if Floor(f_ChartData0.m_CloseDateTime) = Floor(f_ChartData1.m_CloseDateTime) then
      begin
        f_Value0.m_Value[p_TagIndex] := f_Value1.m_Value[p_TagIndex];
      end
      else
      begin
        f_Value0.m_Value[p_TagIndex] := GetLineValueDayC(p_DayChartDataSeries, f_ChartData0.m_CloseDateTime, APosition,
            AValueType);
      end;

    end
    else
    begin
      f_Value0.m_Value[p_TagIndex] := GetLineValueDayC(p_DayChartDataSeries, f_ChartData0.m_CloseDateTime, APosition,
          AValueType);
    end;
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_DayHL(p_ChartDataSeries, p_DayChartDataSeries: CMKChartDataSeries;
    APosition, AValueType, p_TagIndex: Integer; p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;
  f_Value0: CMKLineValue;
  f_Value1: CMKLineValue;
begin
  m_Effect := false;
  f_Size := p_ChartDataSeries.m_Items.Count;
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
    f_ChartData0 := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    f_Value0 := CMKLineValue(m_Items[f_Index]);
    if (f_Index > 0) then
    begin
      f_ChartData1 := CMKChartData(p_ChartDataSeries.m_Items[f_Index - 1]);
      f_Value1 := CMKLineValue(m_Items[f_Index - 1]);

      if Floor(f_ChartData0.m_CloseDateTime) = Floor(f_ChartData1.m_CloseDateTime) then
      begin
        f_Value0.m_Value[p_TagIndex] := f_Value1.m_Value[p_TagIndex];
      end
      else
      begin
        f_Value0.m_Value[p_TagIndex] := GetLineValueDayHL(p_DayChartDataSeries, f_ChartData0.m_CloseDateTime, APosition,
            AValueType);
      end;

    end
    else
    begin
      f_Value0.m_Value[p_TagIndex] := GetLineValueDayHL(p_DayChartDataSeries, f_ChartData0.m_CloseDateTime, APosition,
          AValueType);
    end;
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_DayH(p_ChartDataSeries, p_DayChartDataSeries: CMKChartDataSeries;
    APosition, AValueType, p_TagIndex: Integer; p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;
  f_Value0: CMKLineValue;
  f_Value1: CMKLineValue;
begin
  m_Effect := false;
  f_Size := p_ChartDataSeries.m_Items.Count;
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
    f_ChartData0 := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    f_Value0 := CMKLineValue(m_Items[f_Index]);
    if (f_Index > 0) then
    begin
      f_ChartData1 := CMKChartData(p_ChartDataSeries.m_Items[f_Index - 1]);
      f_Value1 := CMKLineValue(m_Items[f_Index - 1]);

      if Floor(f_ChartData0.m_CloseDateTime) = Floor(f_ChartData1.m_CloseDateTime) then
      begin
        f_Value0.m_Value[p_TagIndex] := f_Value1.m_Value[p_TagIndex];
      end
      else
      begin
        f_Value0.m_Value[p_TagIndex] := GetLineValueDayH(p_DayChartDataSeries, f_ChartData0.m_CloseDateTime, APosition,
            AValueType);
      end;

    end
    else
    begin
      f_Value0.m_Value[p_TagIndex] := GetLineValueDayH(p_DayChartDataSeries, f_ChartData0.m_CloseDateTime, APosition,
          AValueType);
    end;
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_DayL(p_ChartDataSeries, p_DayChartDataSeries: CMKChartDataSeries;
    APosition, AValueType, p_TagIndex: Integer; p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;
  f_Value0: CMKLineValue;
  f_Value1: CMKLineValue;
begin
  m_Effect := false;
  f_Size := p_ChartDataSeries.m_Items.Count;
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
    f_ChartData0 := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    f_Value0 := CMKLineValue(m_Items[f_Index]);
    if (f_Index > 0) then
    begin
      f_ChartData1 := CMKChartData(p_ChartDataSeries.m_Items[f_Index - 1]);
      f_Value1 := CMKLineValue(m_Items[f_Index - 1]);

      if Floor(f_ChartData0.m_CloseDateTime) = Floor(f_ChartData1.m_CloseDateTime) then
      begin
        f_Value0.m_Value[p_TagIndex] := f_Value1.m_Value[p_TagIndex];
      end
      else
      begin
        f_Value0.m_Value[p_TagIndex] := GetLineValueDayL(p_DayChartDataSeries, f_ChartData0.m_CloseDateTime, APosition,
            AValueType);
      end;

    end
    else
    begin
      f_Value0.m_Value[p_TagIndex] := GetLineValueDayL(p_DayChartDataSeries, f_ChartData0.m_CloseDateTime, APosition,
          AValueType);
    end;
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_DayO(p_ChartDataSeries, p_DayChartDataSeries: CMKChartDataSeries;
    APosition, AValueType, p_TagIndex: Integer; p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData0: CMKChartData;
  f_ChartData1: CMKChartData;
  f_Value0: CMKLineValue;
  f_Value1: CMKLineValue;
begin
  m_Effect := false;
  f_Size := p_ChartDataSeries.m_Items.Count;
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
    f_ChartData0 := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    f_Value0 := CMKLineValue(m_Items[f_Index]);
    if (f_Index > 0) then
    begin
      f_ChartData1 := CMKChartData(p_ChartDataSeries.m_Items[f_Index - 1]);
      f_Value1 := CMKLineValue(m_Items[f_Index - 1]);

      if Floor(f_ChartData0.m_CloseDateTime) = Floor(f_ChartData1.m_CloseDateTime) then
      begin
        f_Value0.m_Value[p_TagIndex] := f_Value1.m_Value[p_TagIndex];
      end
      else
      begin
        f_Value0.m_Value[p_TagIndex] := GetLineValueDayO(p_DayChartDataSeries, f_ChartData0.m_CloseDateTime, APosition,
            AValueType);
      end;

    end
    else
    begin
      f_Value0.m_Value[p_TagIndex] := GetLineValueDayO(p_DayChartDataSeries, f_ChartData0.m_CloseDateTime, APosition,
          AValueType);
    end;
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_IntraDayL(p_ChartDataSeries: CMKChartDataSeries; AValueType: Integer; p_TagIndex: Integer;
    p_Begin: Integer = -1; p_End: Integer = -1);
var
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData0: CMKChartData;
  f_Value0: CMKLineValue;
begin
  m_Effect := false;
  f_Size := p_ChartDataSeries.m_Items.Count;
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
    f_ChartData0 := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    f_Value0 := CMKLineValue(m_Items[f_Index]);

    if (AValueType = 0) or (AValueType = 2) then
    begin
      f_Value0.m_Value[p_TagIndex] := f_ChartData0.m_LowPrice;
    end
    else
    begin
      f_Value0.m_Value[p_TagIndex] := f_ChartData0.m_LowOPS;
    end
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_IntraDayH(p_ChartDataSeries: CMKChartDataSeries; AValueType: Integer; p_TagIndex: Integer;
    p_Begin: Integer = -1; p_End: Integer = -1);
var
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData0: CMKChartData;
  f_Value0: CMKLineValue;
begin
  m_Effect := false;
  f_Size := p_ChartDataSeries.m_Items.Count;
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
    f_ChartData0 := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    f_Value0 := CMKLineValue(m_Items[f_Index]);

    if (AValueType = 0) or (AValueType = 2) then
    begin
      f_Value0.m_Value[p_TagIndex] := f_ChartData0.m_HighPrice;
    end
    else
    begin
      f_Value0.m_Value[p_TagIndex] := f_ChartData0.m_HighOPS;
    end
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_IntraDayC(p_ChartDataSeries: CMKChartDataSeries; AValueType: Integer; p_TagIndex: Integer;
    p_Begin: Integer = -1; p_End: Integer = -1);
var
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData0: CMKChartData;
  f_Value0: CMKLineValue;
begin
  m_Effect := false;
  f_Size := p_ChartDataSeries.m_Items.Count;
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
    f_ChartData0 := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    f_Value0 := CMKLineValue(m_Items[f_Index]);

    if (AValueType = 0) or (AValueType = 2) then
    begin
      f_Value0.m_Value[p_TagIndex] := f_ChartData0.m_ClosePrice;
    end
    else
    begin
      f_Value0.m_Value[p_TagIndex] := f_ChartData0.m_CloseOPS;
    end
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_IntraDayHL(p_ChartDataSeries: CMKChartDataSeries; AValueType: Integer; p_TagIndex: Integer;
    p_Begin: Integer = -1; p_End: Integer = -1);
var
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData0: CMKChartData;
  f_Value0: CMKLineValue;
begin
  m_Effect := false;
  f_Size := p_ChartDataSeries.m_Items.Count;
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
    f_ChartData0 := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    f_Value0 := CMKLineValue(m_Items[f_Index]);

    if (AValueType = 0) or (AValueType = 2) then
    begin
      f_Value0.m_Value[p_TagIndex] := (f_ChartData0.m_HighPrice + f_ChartData0.m_LowPrice) / 2.0;
    end
    else
    begin
      f_Value0.m_Value[p_TagIndex] := (f_ChartData0.m_HighOPS + f_ChartData0.m_LowOPS) / 2.0;
    end
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_IntraDayO(p_ChartDataSeries: CMKChartDataSeries; AValueType: Integer; p_TagIndex: Integer;
    p_Begin: Integer = -1; p_End: Integer = -1);
var
  f_Index: Integer;
  f_Size: Integer;
  f_ChartData0: CMKChartData;
  f_Value0: CMKLineValue;
begin
  m_Effect := false;
  f_Size := p_ChartDataSeries.m_Items.Count;
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
    f_ChartData0 := CMKChartData(p_ChartDataSeries.m_Items[f_Index]);
    f_Value0 := CMKLineValue(m_Items[f_Index]);

    if (AValueType = 0) or (AValueType = 2) then
    begin
      f_Value0.m_Value[p_TagIndex] := f_ChartData0.m_OpenPrice;
    end
    else
    begin
      f_Value0.m_Value[p_TagIndex] := f_ChartData0.m_OpenOPS;
    end
  end;

  m_ChartDataSeries := p_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_RSI(p_Length: Integer; p_SrcValueArray: CMKLineValueSeries; p_SrcIndex: Integer;
    p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
var
  f_Count: Integer;
  f_Index: Integer;
  f_Index2: Integer;
  f_Size: Integer;
  f_mount: Double;
  f_UpSum: Double;
  f_DownSum: Double;
  f_NewPrice: Double;
  f_OldPrice: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := false;
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

  for f_Count := p_Begin to p_End - 1 do
  begin
    f_Index := f_Count - (p_Length - 1);
    if (f_Index > 0) then
    begin
      f_UpSum := 0.0;
      f_DownSum := 0.0;
      CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := 0;
      for f_Index2 := 0 to p_Length - 1 do
      begin
        f_OldPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2 - 1]).m_Value[p_SrcIndex];
        f_NewPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_SrcIndex];
        f_mount := f_NewPrice - f_OldPrice;

        if (f_mount >= 0) then
          f_UpSum := f_UpSum + f_mount
        else
          f_DownSum := f_DownSum + (-f_mount);

        if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2 - 1]).m_Value[p_SrcIndex] = NOT_VALUE) or
            (CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_SrcIndex] = NOT_VALUE)) then
        begin
          CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := NOT_VALUE;
          break;
        end;
      end;

      if (CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex] <> NOT_VALUE) then
      begin
        if (f_UpSum + f_DownSum = 0) then
          CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := 0.0
        else
          CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := f_UpSum / (f_UpSum + f_DownSum) * 100.0;
      end;
    end
    else
      CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex] := NOT_VALUE;
  end;
  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_HLPrice(p_SrcValueArray: CMKLineValueSeries;
    p_HighIndex, p_LowIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;

  f_LineValue: CMKLineValue;
  f_SrcLineValue: CMKLineValue;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := false;
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
    if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <> NOT_VALUE) and
        (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <> NOT_VALUE)) then
    begin
      f_SrcLineValue := p_SrcValueArray.m_Items[f_Index];
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
          (f_SrcLineValue.m_Value[p_HighIndex] + f_SrcLineValue.m_Value[p_LowIndex]) / 2.0;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_Disparity(p_PriceValueArray: CMKLineValueSeries; p_PIndex: Integer;
    p_MAValueArray: CMKLineValueSeries; p_MAIndex: Integer; p_TagIndex: Integer; p_Begin: Integer = -1; p_End: Integer = -1);
var
  f_Index: Integer;

  f_PLineValue: CMKLineValue;
  f_MLineValue: CMKLineValue;
  f_Size: Integer;
  f_Price, f_MA: Double;
begin
  if not Assigned(p_PriceValueArray) then
    exit;
  if not Assigned(p_MAValueArray) then
    exit;

  m_Effect := false;
  f_Size := p_PriceValueArray.m_Items.Count;
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
    if ((CMKLineValue(p_PriceValueArray.m_Items[f_Index]).m_Value[p_PIndex] <> NOT_VALUE) and
        (CMKLineValue(p_MAValueArray.m_Items[f_Index]).m_Value[p_MAIndex] <> NOT_VALUE)) then
    begin
      f_Price := CMKLineValue(p_PriceValueArray.m_Items[f_Index]).m_Value[p_PIndex];
      f_MA := CMKLineValue(p_MAValueArray.m_Items[f_Index]).m_Value[p_MAIndex];

      if f_MA <> 0 then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := (f_Price / f_MA) * 100.0;
      end
      else
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
      end;
    end;
  end;

  m_ChartDataSeries := p_PriceValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_NAverage(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_AllEffect: Boolean;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := false;
  m_Effect := false;
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
    CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if (f_Index < p_Count - 1) then
      continue;

    if (f_Index < 1) then
      continue;

    if (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] = NOT_VALUE) then
    begin
      if (not f_AllEffect) then
      begin
        f_AllEffect := (CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_SrcIndex] <> NOT_VALUE);
        if (f_AllEffect) then
        begin
          f_Index1 := 0;
          f_Sum := 0;
          while (f_Index1 < p_Count) do
          begin
            f_Sum := f_Sum + CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];

            Inc(f_Index1);
          end;

          CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / p_Count;
        end;

        continue;
      end;
    end
    else if (f_Index >= p_Count) then
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
          (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] * p_Count + CMKLineValue(p_SrcValueArray.m_Items[f_Index])
          .m_Value[p_SrcIndex] - CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Count]).m_Value[p_SrcIndex]) / p_Count;
    end
    else
    begin
      continue;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_XAverage(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
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
  f_AllEffect := false;
  m_Effect := false;
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
      if (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] = NOT_VALUE) then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        continue;
      end;

      if ((f_Index <= 0) or (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] = NOT_VALUE)) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex]
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex]
            * f_Factor + (1 - f_Factor) * CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex];
    end;
  end
  else
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_WAverage(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
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
  f_AllEffect := false;
  m_Effect := false;
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
        f_Price := CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        f_Sum := f_Sum + f_Price * (p_Count - f_Index1);
        f_CSum := f_CSum + p_Count - f_Index1;
      end;

      if (f_CSum > 0) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
    end
    else
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_NAverageP(p_Count: Integer; p_Precision: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_AllEffect: Boolean;
  f_Factor2: Double;
begin
  f_Factor2 := Math.Power(10, p_Precision);
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := false;
  m_Effect := false;
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
    CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if (f_Index < p_Count - 1) then
      continue;

    if (f_Index < 1) then
      continue;

    if (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] = NOT_VALUE) then
    begin
      if (not f_AllEffect) then
      begin
        f_AllEffect := (CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_SrcIndex] <> NOT_VALUE);
        if (f_AllEffect) then
        begin
          f_Index1 := 0;
          f_Sum := 0;
          while (f_Index1 < p_Count) do
          begin
            f_Sum := f_Sum + CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];

            Inc(f_Index1);
          end;

          CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / p_Count;
          CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
              Round(CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] * f_Factor2) / f_Factor2;
        end;

        continue;
      end;
    end
    else if (f_Index >= p_Count) then
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
          (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] * p_Count + CMKLineValue(p_SrcValueArray.m_Items[f_Index])
          .m_Value[p_SrcIndex] - CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Count]).m_Value[p_SrcIndex]) / p_Count;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
          Round(CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] * f_Factor2) / f_Factor2;
    end
    else
    begin
      continue;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_XAverageP(p_Count: Integer; p_Precision: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_AllEffect: Boolean;
  f_Factor: Double;
  f_Factor2: Double;
begin
  f_Factor2 := Math.Power(10, p_Precision);
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := false;
  m_Effect := false;
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
      if (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex] = NOT_VALUE) then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
        continue;
      end;

      if ((f_Index <= 0) or (CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex] = NOT_VALUE)) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex]
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_SrcIndex]
            * f_Factor + (1 - f_Factor) * CMKLineValue(m_Items[f_Index - 1]).m_Value[p_TagIndex];

      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
          Round(CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] * f_Factor2) / f_Factor2;
    end;
  end
  else
  begin
    for f_Index := p_Begin to p_End - 1 do
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_WAverageP(p_Count: Integer; p_Precision: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_SrcIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Size: Integer;
  f_Index: Integer;
  f_Index1, f_Count: Integer;
  f_Sum: Double;
  f_CSum: Double;
  f_Price: Double;
  f_AllEffect: Boolean;
  f_Factor: Double;
  f_Factor2: Double;
begin
  f_Factor2 := Math.Power(10, p_Precision);
  if not Assigned(p_SrcValueArray) then
    exit;
  f_AllEffect := false;
  m_Effect := false;
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
        f_Price := CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        f_Sum := f_Sum + f_Price * (p_Count - f_Index1);
        f_CSum := f_CSum + p_Count - f_Index1;
      end;

      if (f_CSum > 0) then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
            Round(CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] * f_Factor2) / f_Factor2;
      end
      else
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
      end;
    end
    else
    begin
      f_Count := f_Index + 1;
      for f_Index1 := 0 to f_Count - 1 do
      begin
        f_Price := CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index1]).m_Value[p_SrcIndex];
        f_Sum := f_Sum + f_Price * (f_Count - f_Index1);
        f_CSum := f_CSum + f_Count - f_Index1;
      end;

      if (f_CSum > 0) then
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := f_Sum / f_CSum;
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] :=
            Round(CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] * f_Factor2) / f_Factor2;
      end
      else
      begin
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := 0;
      end;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_SlowSTC(p_Length1, p_Length2, p_Length3: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_SlowKIndex: Integer;
  f_SlowDIndex: Integer;
  f_FastKIndex: Integer;
  f_Count: Integer;
  f_Index: Integer;
  f_Index2: Integer;
  f_DHighest: Double;
  f_DLowest: Double;
  f_HighPrice: Double;
  f_LowPrice: Double;
  f_ClosePrice: Double;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_FastKIndex := p_TagIndex;
  f_SlowKIndex := p_TagIndex + 1;
  f_SlowDIndex := p_TagIndex + 2;
  m_Effect := false;
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

  for f_Count := p_Begin to p_End - 1 do
  begin
    f_Index := f_Count - (p_Length1 - 1);
    if (f_Index >= 0) then
    begin
      if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_HighIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_LowIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray.m_Items[f_Index]).m_Value[p_CloseIndex] <> NOT_VALUE)) then
      begin
        f_DHighest := MIN_VALUE;
        f_DLowest := MAX_VALUE;
        for f_Index2 := 0 to p_Length1 - 1 do
        begin
          f_HighPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_HighIndex];
          f_LowPrice := CMKLineValue(p_SrcValueArray.m_Items[f_Index + f_Index2]).m_Value[p_LowIndex];
          if (f_LowPrice < f_DLowest) then
            f_DLowest := f_LowPrice;

          if (f_HighPrice > f_DHighest) then
            f_DHighest := f_HighPrice;
        end;

        f_ClosePrice := CMKLineValue(p_SrcValueArray.m_Items[f_Count]).m_Value[p_CloseIndex];
        if (f_DHighest = f_DLowest) then
          CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := 0
        else
          CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := (f_ClosePrice - f_DLowest) / (f_DHighest - f_DLowest) * 100.0;
      end
      else
        CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := NOT_VALUE;
    end
    else
      CMKLineValue(m_Items[f_Count]).m_Value[f_FastKIndex] := NOT_VALUE;
  end;

  TS_XAverage(p_Length2, Self, f_FastKIndex, f_SlowKIndex, p_Begin, p_End);
  TS_XAverage(p_Length3, Self, f_SlowKIndex, f_SlowDIndex, p_Begin, p_End);
  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_StdDev(p_Count: Integer; p_SrcValueArray: CMKLineValueSeries; p_PIndex: Integer;
    p_SrcValueArray2: CMKLineValueSeries; p_MIndex, p_TagIndex, p_Begin, p_End: Integer);
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
  f_AllEffect := false;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  m_Effect := false;

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
    CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    if (f_Index < p_Count - 1) then
      continue;

    if (not f_AllEffect) then
    begin
      if ((CMKLineValue(p_SrcValueArray.m_Items[f_Index - p_Count + 1]).m_Value[p_PIndex] <> NOT_VALUE) and
          (CMKLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_MIndex] <> NOT_VALUE)) then
        f_AllEffect := true
      else
        f_AllEffect := false;

      if (f_AllEffect) then
      begin
        f_MA0 := CMKLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_MIndex];
        f_Sum := 0;
        for f_Index2 := 0 to p_Count - 1 do
        begin
          f_v1 := (f_MA0 - CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[p_PIndex]);
          f_Sum := f_Sum + (f_v1 * f_v1);
        end;
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Sqrt(f_Sum / p_Count);
      end;

      continue;
    end;

    f_v0 := 0;
    f_v2 := 0;
    if (f_Index >= p_Count) then
    begin
      f_MA0 := CMKLineValue(p_SrcValueArray2.m_Items[f_Index]).m_Value[p_MIndex];
      f_Sum := 0;
      for f_Index2 := 0 to p_Count - 1 do
      begin
        f_v1 := (f_MA0 - CMKLineValue(p_SrcValueArray.m_Items[f_Index - f_Index2]).m_Value[p_PIndex]);
        f_Sum := f_Sum + (f_v1 * f_v1);
      end;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := Sqrt(f_Sum / p_Count);
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
{ **
  * Bollinger Band를 계산한다.
  *
  * @param    p_Count
  * @param    p_Factor
  * @param    p_SrcValueArray
  * @param    p_PIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMXTSLineValueSeries.TS_BBand(p_Count: Integer; p_Factor: Double; p_SrcValueArray: CMKLineValueSeries;
    p_PIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := false;
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

  TS_NAverage(p_Count, p_SrcValueArray, p_PIndex, p_TagIndex + 2);
  TS_StdDev(p_Count, p_SrcValueArray, p_PIndex, Self, p_TagIndex + 2, p_TagIndex + 3);
  for f_Index := p_Begin to p_End - 1 do
  begin
    if ((CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] <> NOT_VALUE) and
        (CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] <> NOT_VALUE)) then
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] +
          p_Factor * CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3];
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] -
          p_Factor * CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3];
    end
    else
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
    end;
  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
{ **
  * Bollinger Band의 Width를 계산한다.
  *
  * @param    p_Count
  * @param    p_Factor
  * @param    p_SrcValueArray
  * @param    p_PIndex
  * @param    p_TagIndex
  * @param    p_Begin
  * @param    p_End
  ** }
procedure CMXTSLineValueSeries.TS_BBWidth(p_Count: Integer; p_Factor: Double; p_MA: Integer;
    p_SrcValueArray: CMKLineValueSeries; p_PIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  m_Effect := false;
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

  TS_NAverage(p_Count, p_SrcValueArray, p_PIndex, p_TagIndex + 2);
  TS_StdDev(p_Count, p_SrcValueArray, p_PIndex, Self, p_TagIndex + 2, p_TagIndex + 3);
  for f_Index := p_Begin to p_End - 1 do
  begin
    if (CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] <> NOT_VALUE) then
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := p_Factor * CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3];
    end
    else
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex] := NOT_VALUE;
    end;
  end;
  TS_NAverage(p_MA, Self, p_TagIndex + 0, p_TagIndex + 1);

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

// ---------------------------------------------------------------------------
procedure CMXTSLineValueSeries.TS_IMLine(p_Length1, p_Length2, p_Length3: Integer; p_SrcValueArray: CMKLineValueSeries;
    p_HighIndex, p_LowIndex, p_CloseIndex, p_TagIndex, p_Begin, p_End: Integer);
var
  f_Index: Integer;
  f_Size: Integer;
  f_Count: Integer;
  f_MaxValue: Double;
  f_MinValue: Double;
begin
  if not Assigned(p_SrcValueArray) then
    exit;
  f_Size := p_SrcValueArray.m_Items.Count;
  SetLengthSeries(f_Size);
  m_Effect := false;
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
    if ((f_Index >= 0) and (f_Index < f_Size)) then
    begin
      f_MaxValue := HighestPrice(p_Length1, p_SrcValueArray, p_HighIndex, f_Index);
      f_MinValue := LowestPrice(p_Length1, p_SrcValueArray, p_LowIndex, f_Index);
      if ((f_MaxValue <> MIN_VALUE) and (f_MinValue <> MAX_VALUE)) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := (f_MinValue + f_MaxValue) / 2
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;

      f_MaxValue := HighestPrice(p_Length2, p_SrcValueArray, p_HighIndex, f_Index);
      f_MinValue := LowestPrice(p_Length2, p_SrcValueArray, p_LowIndex, f_Index);
      if ((f_MaxValue <> MIN_VALUE) and (f_MinValue <> MAX_VALUE)) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := (f_MinValue + f_MaxValue) / 2
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
    end
    else
    begin
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 0] := NOT_VALUE;
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 1] := NOT_VALUE;
    end;

    f_Count := f_Index - (p_Length2);
    if ((f_Count >= 0) and (f_Count < f_Size)) then
    begin
      if ((CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 0] <> NOT_VALUE) and
          (CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 1] <> NOT_VALUE)) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] :=
            (CMKLineValue(m_Items[f_Count]).m_Value[p_TagIndex + 0] + CMKLineValue(m_Items[f_Count])
            .m_Value[p_TagIndex + 1]) / 2
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := NOT_VALUE;
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 2] := NOT_VALUE;

    f_Count := f_Index - (p_Length2);
    if ((f_Count >= 0) and (f_Count < f_Size)) then
    begin
      f_MaxValue := HighestPrice(p_Length3, p_SrcValueArray, p_HighIndex, f_Count);
      f_MinValue := LowestPrice(p_Length3, p_SrcValueArray, p_LowIndex, f_Count);
      if ((f_MaxValue <> MIN_VALUE) and (f_MinValue <> MAX_VALUE)) then
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] := (f_MinValue + f_MaxValue) / 2
      else
        CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] := NOT_VALUE;
    end
    else
      CMKLineValue(m_Items[f_Index]).m_Value[p_TagIndex + 3] := NOT_VALUE;

  end;

  m_ChartDataSeries := p_SrcValueArray.m_ChartDataSeries;
  m_Effect := true;
end;

end.
