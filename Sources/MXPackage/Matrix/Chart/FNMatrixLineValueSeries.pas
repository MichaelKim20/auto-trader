unit FNMatrixLineValueSeries;

interface

uses
  SysUtils,
  Classes,
  Types,
  Math,
  MKLineValueSeries,
  MKChartDataSeries,
  MKStreamChartDataSeries,
  MKMaxMin,
  MKLineValue,
  FNMatrixConst,
  MKChartData,
  FNTradeSystem,
  MXOption;

type

  CFNMatrixLineValueSeries = class(CMKLineValueSeries)

  public
    procedure ScanSignalAtTrade(p_ChartDataSeries: CMKChartDataSeries; p_SignalArray: CFNSignalArray; p_SystemNoIndex: integer; p_SrcIndex: integer; p_Begin: integer = -1; p_End: integer = -1);

    procedure Calc_TotalProfit(p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_PriceIndex: integer; p_TagIndex: integer; p_Begin: integer = -1; p_End: integer = -1);
    procedure Calc_TotalProfit_Buy(p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_PriceIndex: integer; p_TagIndex: integer; p_Begin: integer = -1; p_End: integer = -1);
    procedure Calc_TotalProfit_Sell(p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_PriceIndex: integer; p_TagIndex: integer; p_Begin: integer = -1; p_End: integer = -1);

    procedure Calc_TotalProfit_Close(p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_SrcIndex: integer; p_TagIndex: integer; p_Begin: integer = -1; p_End: integer = -1);
    procedure Calc_TotalProfit_Close_Buy(p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_SrcIndex: integer; p_TagIndex: integer; p_Begin: integer = -1; p_End: integer = -1);
    procedure Calc_TotalProfit_Close_Sell(p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_SrcIndex: integer; p_TagIndex: integer; p_Begin: integer = -1; p_End: integer = -1);

    procedure Calc_LastProfit(p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_PriceIndex: integer; p_TagIndex: integer; p_Begin: integer = -1; p_End: integer = -1);
    procedure Calc_RecentProfit(p_Min: integer; p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_TotalProfitIndex: integer; p_TagIndex: integer; p_Begin: integer = -1;
      p_End: integer = -1);

    function ConsecutiveUp(ALineIndex: integer; ACount: integer; APosition: integer): Boolean;
    function ConsecutiveDn(ALineIndex: integer; ACount: integer; APosition: integer): Boolean;
    function AboveOf(ALineIndex1: integer; ALineIndex2: integer; APosition: integer): Boolean;
    function BelowOf(ALineIndex1: integer; ALineIndex2: integer; APosition: integer): Boolean;

  end;

implementation

uses
  DateUtils, FNGlobal, FNVolumePriceArray;

// ---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.ScanSignalAtTrade(p_ChartDataSeries: CMKChartDataSeries; p_SignalArray: CFNSignalArray; p_SystemNoIndex: integer; p_SrcIndex: integer; p_Begin, p_End: integer);
var
  f_Index: integer;
  f_Size: integer;
  f_ChartData: CMKChartData;
  f_Value0: CMKLineValue;
  f_Value1: CMKLineValue;
  f_OldValue: integer;
  f_NewValue: integer;
  f_SignalData: CFNSignalData;
  f_Signal: integer;
  f_SignalIndex: integer;

  f_LastSignalData: CFNSignalData;
begin
  f_Size := p_ChartDataSeries.m_Items.Count;

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

  if p_SignalArray.m_Items.Count > 0 then
  begin
    f_LastSignalData := p_SignalArray.m_Items.Items[p_SignalArray.m_Items.Count - 1];
  end
  else
  begin
    f_LastSignalData := NIL;
  end;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_ChartData := p_ChartDataSeries.m_Items[f_Index];
    f_Value0 := m_Items[f_Index];
    if (f_Value0.m_Value[p_SrcIndex] = NOT_VALUE) then
      f_NewValue := 0
    else
      f_NewValue := Trunc(f_Value0.m_Value[p_SrcIndex]);
    if (f_Index > 0) then
    begin
      f_Value1 := m_Items[f_Index - 1];
      if (f_Value1.m_Value[p_SrcIndex] = NOT_VALUE) then
        f_OldValue := 0
      else
        f_OldValue := Trunc(f_Value1.m_Value[p_SrcIndex])
    end
    else
    begin
      f_Value1 := NIL;
      f_OldValue := 0;
    end;

    if (f_OldValue <> 1) AND (f_NewValue = 1) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_BUY_ENTER;

      if not(Assigned(f_LastSignalData) AND (f_LastSignalData.m_Signal = SIGNAL_BUY_ENTER)) then
      begin
        f_SignalData := CFNSignalData.Create;
        f_SignalData.m_SystemNo := Math.Floor(f_Value0.m_Value[p_SystemNoIndex]);
        f_SignalData.m_Index := f_Index;
        f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
        f_SignalData.m_Signal := SIGNAL_BUY_ENTER;
        f_SignalData.m_Price := f_ChartData.m_ClosePrice;
        f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
        p_SignalArray.Add(f_SignalData);
        f_LastSignalData := f_SignalData;
      end;
    end
    else if (f_OldValue <> -1) AND (f_NewValue = -1) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_SELL_ENTER;
      if not(Assigned(f_LastSignalData) AND (f_LastSignalData.m_Signal = SIGNAL_SELL_ENTER)) then
      begin
        f_SignalData := CFNSignalData.Create;
        f_SignalData.m_SystemNo := Math.Floor(f_Value0.m_Value[p_SystemNoIndex]);
        f_SignalData.m_Index := f_Index;
        f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
        f_SignalData.m_Signal := SIGNAL_SELL_ENTER;
        f_SignalData.m_Price := f_ChartData.m_ClosePrice;
        f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
        p_SignalArray.Add(f_SignalData);
        f_LastSignalData := f_SignalData;
      end;
    end
    else if (f_OldValue = 1) AND (f_NewValue = 0) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_BUY_EXIT;
      if not(Assigned(f_LastSignalData) AND (f_LastSignalData.m_Signal = SIGNAL_BUY_EXIT)) then
      begin
        f_SignalData := CFNSignalData.Create;
        f_SignalData.m_SystemNo := Math.Floor(f_Value0.m_Value[p_SystemNoIndex]);
        f_SignalData.m_Index := f_Index;
        f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
        f_SignalData.m_Signal := SIGNAL_BUY_EXIT;
        f_SignalData.m_Price := f_ChartData.m_ClosePrice;
        f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
        p_SignalArray.Add(f_SignalData);
        f_LastSignalData := f_SignalData;
      end;
    end
    else if (f_OldValue = -1) AND (f_NewValue = 0) then
    begin
      f_SignalIndex := f_Index;
      f_Signal := SIGNAL_SELL_EXIT;
      if not(Assigned(f_LastSignalData) AND (f_LastSignalData.m_Signal = SIGNAL_SELL_EXIT)) then
      begin
        f_SignalData := CFNSignalData.Create;
        f_SignalData.m_SystemNo := Math.Floor(f_Value0.m_Value[p_SystemNoIndex]);
        f_SignalData.m_Index := f_Index;
        f_SignalData.m_DateTime := f_ChartData.m_CloseDateTime;
        f_SignalData.m_Signal := SIGNAL_SELL_EXIT;
        f_SignalData.m_Price := f_ChartData.m_ClosePrice;
        f_SignalData.m_OPS := f_ChartData.m_CloseOPS;
        p_SignalArray.Add(f_SignalData);
        f_LastSignalData := f_SignalData;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
function CFNMatrixLineValueSeries.ConsecutiveUp(ALineIndex: integer; ACount: integer; APosition: integer): Boolean;
var
  f_Index0: integer;
  f_Index1: integer;
  f_Count: integer;
  f_Up: Boolean;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
begin
  f_Up := true;
  for f_Count := 0 to ACount - 1 do
  begin
    f_Index0 := APosition - f_Count;
    f_Index1 := f_Index0 - 1;

    if (f_Index1 < 0) then
    begin
      f_Up := false;
      break;
    end;

    f_LineValue0 := m_Items.Items[f_Index0];
    f_LineValue1 := m_Items.Items[f_Index1];

    if (f_LineValue0.m_Value[ALineIndex] = NOT_VALUE) or (f_LineValue1.m_Value[ALineIndex] = NOT_VALUE) then
    begin
      f_Up := false;
      break;
    end
    else
    begin
      if (CompareValue(f_LineValue0.m_Value[ALineIndex], f_LineValue1.m_Value[ALineIndex], 1) < 0) then
      begin
        f_Up := false;
        break;
      end
      else if (CompareValue(f_LineValue0.m_Value[ALineIndex], 0, 1) = 0) and (CompareValue(f_LineValue1.m_Value[ALineIndex], 0, 1) = 0) then
      begin
        f_Up := false;
        break;
      end;
    end;
  end;

  result := f_Up;
end;

// ---------------------------------------------------------------------------
function CFNMatrixLineValueSeries.ConsecutiveDn(ALineIndex: integer; ACount: integer; APosition: integer): Boolean;
var
  f_Index0: integer;
  f_Index1: integer;
  f_Count: integer;
  f_Dn: Boolean;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
begin
  f_Dn := true;
  for f_Count := 0 to ACount - 1 do
  begin
    f_Index0 := APosition - f_Count;
    f_Index1 := f_Index0 - 1;

    if (f_Index1 < 0) then
    begin
      f_Dn := false;
      break;
    end;

    f_LineValue0 := m_Items.Items[f_Index0];
    f_LineValue1 := m_Items.Items[f_Index1];

    if (f_LineValue0.m_Value[ALineIndex] = NOT_VALUE) or (f_LineValue1.m_Value[ALineIndex] = NOT_VALUE) then
    begin
      f_Dn := false;
      break;
    end
    else
    begin
      if (CompareValue(f_LineValue0.m_Value[ALineIndex], f_LineValue1.m_Value[ALineIndex], 1) > 0) then
      begin
        f_Dn := false;
        break;
      end
      else if (CompareValue(f_LineValue0.m_Value[ALineIndex], 0, 1) = 0) and (CompareValue(f_LineValue1.m_Value[ALineIndex], 0, 1) = 0) then
      begin
        f_Dn := false;
        break;
      end;
    end;
  end;

  result := f_Dn;
end;

function CFNMatrixLineValueSeries.AboveOf(ALineIndex1: integer; ALineIndex2: integer; APosition: integer): Boolean;
var
  f_Index0: integer;
  f_Up: Boolean;
  f_LineValue0: CMKLineValue;
begin
  f_Index0 := APosition;
  f_LineValue0 := m_Items.Items[f_Index0];
  f_Up := false;
  if (f_LineValue0.m_Value[ALineIndex1] = NOT_VALUE) or (f_LineValue0.m_Value[ALineIndex2] = NOT_VALUE) then
  begin
    f_Up := true;
  end
  else if (CompareValue(f_LineValue0.m_Value[ALineIndex1], f_LineValue0.m_Value[ALineIndex2], 1) >= 0) then
  begin
    f_Up := true;
  end;

  result := f_Up;
end;

// ---------------------------------------------------------------------------
function CFNMatrixLineValueSeries.BelowOf(ALineIndex1: integer; ALineIndex2: integer; APosition: integer): Boolean;
var
  f_Index0: integer;
  f_Dn: Boolean;
  f_LineValue0: CMKLineValue;
begin
  f_Index0 := APosition;
  f_LineValue0 := m_Items.Items[f_Index0];
  f_Dn := false;
  if (f_LineValue0.m_Value[ALineIndex1] = NOT_VALUE) or (f_LineValue0.m_Value[ALineIndex2] = NOT_VALUE) then
  begin
    f_Dn := true;
  end
  else if (CompareValue(f_LineValue0.m_Value[ALineIndex1], f_LineValue0.m_Value[ALineIndex2], 1) <= 0) then
  begin
    f_Dn := true;
  end;

  result := f_Dn;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_TotalProfit(p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_PriceIndex: integer; p_TagIndex: integer; p_Begin: integer = -1;
  p_End: integer = -1);
var
  f_Index: integer;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_SrcLineValue0: CMKLineValue;
  f_SrcLineValue1: CMKLineValue;
  f_SrcLineValue2: CMKLineValue;
  f_Close0, f_Close1: Double;
  f_BarCount, f_X1, f_X0: integer;
begin
  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;
  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;
  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;
  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];
    f_Close0 := f_SrcLineValue0.m_Value[p_PriceIndex];

    f_LineValue0 := m_Items[f_Index];
    if f_Index > 0 then
    begin
      f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index - 1];
      f_Close1 := f_SrcLineValue1.m_Value[p_PriceIndex];

      f_LineValue1 := m_Items[f_Index - 1];
      if (f_SrcLineValue1.m_Value[p_SignalIndex] <> NOT_VALUE) then
      begin
        // 매수 거래일 경우
        if (f_SrcLineValue1.m_Value[p_SignalIndex] > 0) then
        begin
          f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex] + (f_Close0 - f_Close1);
        end
        else
          // 매도 거래일 경우
          if (f_SrcLineValue1.m_Value[p_SignalIndex] < 0) then
          begin
            f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex] - (f_Close0 - f_Close1);
          end
          else
          begin
            f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
          end;
      end
      else
      begin
        f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
      end;
    end
    else
    begin
      f_LineValue0.m_Value[p_TagIndex] := 0;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_TotalProfit_Close(p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_SrcIndex: integer; p_TagIndex: integer; p_Begin: integer = -1;
  p_End: integer = -1);
var
  f_Index: integer;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_SrcLineValue0: CMKLineValue;
  f_SrcLineValue1: CMKLineValue;
begin
  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;
  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;
  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;
  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];

    f_LineValue0 := m_Items[f_Index];
    if f_Index > 0 then
    begin
      f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index - 1];

      f_LineValue1 := m_Items[f_Index - 1];

      if (f_SrcLineValue1.m_Value[p_SignalIndex] < 0) AND (f_SrcLineValue0.m_Value[p_SignalIndex] >= 0) then
      begin
        f_LineValue0.m_Value[p_TagIndex] := f_LineValue0.m_Value[p_SrcIndex];
      end
      else if (f_SrcLineValue1.m_Value[p_SignalIndex] > 0) AND (f_SrcLineValue0.m_Value[p_SignalIndex] <= 0) then
      begin
        f_LineValue0.m_Value[p_TagIndex] := f_LineValue0.m_Value[p_SrcIndex];
      end
      else
      begin
        f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
      end;
    end
    else
    begin
      f_LineValue0.m_Value[p_TagIndex] := 0;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_TotalProfit_Close_Buy(p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_SrcIndex: integer; p_TagIndex: integer; p_Begin: integer = -1;
  p_End: integer = -1);
var
  f_Index: integer;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_SrcLineValue0: CMKLineValue;
  f_SrcLineValue1: CMKLineValue;
begin
  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;
  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;
  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;
  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];

    f_LineValue0 := m_Items[f_Index];
    if f_Index > 0 then
    begin
      f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index - 1];

      f_LineValue1 := m_Items[f_Index - 1];

      if (f_SrcLineValue1.m_Value[p_SignalIndex] > 0) AND (f_SrcLineValue0.m_Value[p_SignalIndex] <= 0) then
      begin
        f_LineValue0.m_Value[p_TagIndex] := f_LineValue0.m_Value[p_SrcIndex];
      end
      else
      begin
        f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
      end;
    end
    else
    begin
      f_LineValue0.m_Value[p_TagIndex] := 0;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_TotalProfit_Close_Sell(p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_SrcIndex: integer; p_TagIndex: integer; p_Begin: integer = -1;
  p_End: integer = -1);
var
  f_Index: integer;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_SrcLineValue0: CMKLineValue;
  f_SrcLineValue1: CMKLineValue;
begin
  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;
  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;
  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;
  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];

    f_LineValue0 := m_Items[f_Index];
    if f_Index > 0 then
    begin
      f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index - 1];

      f_LineValue1 := m_Items[f_Index - 1];

      if (f_SrcLineValue1.m_Value[p_SignalIndex] < 0) AND (f_SrcLineValue0.m_Value[p_SignalIndex] >= 0) then
      begin
        f_LineValue0.m_Value[p_TagIndex] := f_LineValue0.m_Value[p_SrcIndex];
      end
      else
      begin
        f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
      end;
    end
    else
    begin
      f_LineValue0.m_Value[p_TagIndex] := 0;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_TotalProfit_Buy(p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_PriceIndex: integer; p_TagIndex: integer; p_Begin: integer = -1;
  p_End: integer = -1);
var
  f_Index: integer;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_SrcLineValue0: CMKLineValue;
  f_SrcLineValue1: CMKLineValue;
  f_SrcLineValue2: CMKLineValue;
  f_Close0, f_Close1: Double;
  f_BarCount, f_X1, f_X0: integer;
begin
  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;
  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;
  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;
  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];
    f_Close0 := f_SrcLineValue0.m_Value[p_PriceIndex];

    f_LineValue0 := m_Items[f_Index];
    if f_Index > 0 then
    begin
      f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index - 1];
      f_Close1 := f_SrcLineValue1.m_Value[p_PriceIndex];

      f_LineValue1 := m_Items[f_Index - 1];
      if (f_SrcLineValue1.m_Value[p_SignalIndex] <> NOT_VALUE) then
      begin
        // 매수 거래일 경우
        if (f_SrcLineValue1.m_Value[p_SignalIndex] > 0) then
        begin
          f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex] + (f_Close0 - f_Close1);
        end
        else
        begin
          f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
        end;
      end
      else
      begin
        f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
      end;
    end
    else
    begin
      f_LineValue0.m_Value[p_TagIndex] := 0;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_TotalProfit_Sell(p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_PriceIndex: integer; p_TagIndex: integer; p_Begin: integer = -1;
  p_End: integer = -1);
var
  f_Index: integer;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_SrcLineValue0: CMKLineValue;
  f_SrcLineValue1: CMKLineValue;
  f_SrcLineValue2: CMKLineValue;
  f_Close0, f_Close1: Double;
  f_BarCount, f_X1, f_X0: integer;
begin
  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;
  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;
  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;
  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];
    f_Close0 := f_SrcLineValue0.m_Value[p_PriceIndex];

    f_LineValue0 := m_Items[f_Index];
    if f_Index > 0 then
    begin
      f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index - 1];
      f_Close1 := f_SrcLineValue1.m_Value[p_PriceIndex];

      f_LineValue1 := m_Items[f_Index - 1];
      if (f_SrcLineValue1.m_Value[p_SignalIndex] <> NOT_VALUE) then
      begin
        // 매도 거래일 경우
        if (f_SrcLineValue1.m_Value[p_SignalIndex] < 0) then
        begin
          f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex] - (f_Close0 - f_Close1);
        end
        else
        begin
          f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
        end;
      end
      else
      begin
        f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
      end;
    end
    else
    begin
      f_LineValue0.m_Value[p_TagIndex] := 0;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_LastProfit(p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_PriceIndex: integer; p_TagIndex: integer; p_Begin: integer = -1; p_End: integer = -1);
var
  f_Index: integer;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_SrcLineValue0: CMKLineValue;
  f_SrcLineValue1: CMKLineValue;
  f_SrcLineValue2: CMKLineValue;
  f_Close0, f_Close1: Double;
  f_X1, f_X0: integer;
  f_OldValue: Double;
begin
  if (p_Begin = -1) then
    p_Begin := 0;
  if (p_End = -1) then
    p_End := p_SrcValueArray.m_Items.Count;
  if (p_End > p_SrcValueArray.m_Items.Count) then
    p_End := p_SrcValueArray.m_Items.Count;
  if (p_Begin > m_Items.Count - 1) then
    p_Begin := m_Items.Count - 1;
  if (p_Begin < 0) then
    p_Begin := 0;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];
    f_Close0 := f_SrcLineValue0.m_Value[p_PriceIndex];

    f_LineValue0 := m_Items[f_Index];
    if f_Index > 0 then
    begin
      f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index - 1];
      f_Close1 := f_SrcLineValue1.m_Value[p_PriceIndex];

      f_LineValue1 := m_Items[f_Index - 1];

      if (f_SrcLineValue1.m_Value[p_SignalIndex] <> NOT_VALUE) then
      begin

        if (f_SrcLineValue0.m_Value[p_SignalIndex] <> f_SrcLineValue1.m_Value[p_SignalIndex]) and ((f_SrcLineValue0.m_Value[p_SignalIndex] > 0) or (f_SrcLineValue0.m_Value[p_SignalIndex] < 0)) then
        begin
          f_OldValue := 0;
        end
        else
        begin
          f_OldValue := f_LineValue1.m_Value[p_TagIndex];
        end;

        // 매수 거래일 경우
        if (f_SrcLineValue1.m_Value[p_SignalIndex] > 0) then
        begin
          f_LineValue0.m_Value[p_TagIndex] := f_OldValue + (f_Close0 - f_Close1);
        end
        else
          // 매도 거래일 경우
          if (f_SrcLineValue1.m_Value[p_SignalIndex] < 0) then
          begin
            f_LineValue0.m_Value[p_TagIndex] := f_OldValue - (f_Close0 - f_Close1);
          end
          else
          begin
            f_LineValue0.m_Value[p_TagIndex] := f_OldValue;
          end;
      end
      else
      begin
        f_LineValue0.m_Value[p_TagIndex] := f_LineValue1.m_Value[p_TagIndex];
      end;
    end
    else
    begin
      f_LineValue0.m_Value[p_TagIndex] := 0;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixLineValueSeries.Calc_RecentProfit(p_Min: integer; p_SrcValueArray: CMKLineValueSeries; p_SignalIndex: integer; p_TotalProfitIndex: integer; p_TagIndex: integer;
  p_Begin: integer = -1; p_End: integer = -1);
var
  f_Index: integer;
  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_SrcLineValue0: CMKLineValue;
  f_SrcLineValue1: CMKLineValue;
  f_SrcLineValue2: CMKLineValue;
  f_Close0, f_Close1: Double;
  f_BarCount, f_X1, f_X0: integer;
begin
  if (m_ChartDataSeries.m_TimeFrame >= 9000) then
  begin
    f_BarCount := ((p_Min * 60) div (m_ChartDataSeries.m_TimeFrame - 9000));
  end
  else if (m_ChartDataSeries.m_TimeFrame < 360) then
  begin
    f_BarCount := ((p_Min * 60) div (m_ChartDataSeries.m_TimeFrame * 60));
  end
  else
  begin
    f_BarCount := 0;
  end;

  for f_Index := p_Begin to p_End - 1 do
  begin
    f_SrcLineValue0 := p_SrcValueArray.m_Items.Items[f_Index];
    f_LineValue0 := m_Items[f_Index];
    if f_Index - f_BarCount > 0 then
    begin
      f_SrcLineValue1 := p_SrcValueArray.m_Items.Items[f_Index - f_BarCount];
      f_LineValue1 := m_Items[f_Index - f_BarCount];

      f_LineValue0.m_Value[p_TagIndex] := f_SrcLineValue0.m_Value[p_TotalProfitIndex] - f_SrcLineValue1.m_Value[p_TotalProfitIndex];
    end
    else
    begin
      f_LineValue0.m_Value[p_TagIndex] := f_SrcLineValue0.m_Value[p_TotalProfitIndex];
    end;
  end;
end;

end.
