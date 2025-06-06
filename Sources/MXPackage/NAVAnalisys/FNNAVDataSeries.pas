unit FNNAVDataSeries;

interface

uses
  SysUtils, Classes, Math, FNNAVData;

type
  // ---------------------------------------------------------------------------
  CFNNAVDataSeries = class(TObject)
  public
    m_Items: TList;

  public
    constructor Create;
    destructor Destroy; override;

  public
    procedure Clear;
    procedure Add(p_Value: CFNNAVData);
    function SearchIndex(p_Secquence: Integer; p_Nearest: Boolean): Integer;
    procedure Average(p_Count: Integer; p_Precision: Integer);
    procedure Clone(p_Source: CFNNAVDataSeries);
  end;
  // ---------------------------------------------------------------------------

implementation

uses FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNNAVDataSeries.Create;
begin
  inherited Create;

  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
destructor CFNNAVDataSeries.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVDataSeries.Add(p_Value: CFNNAVData);
var
  f_SearchIndex: Integer;
begin
  // 데이터가 하나라도 존재하면
  if (0 < m_Items.Count) then
  begin
    // 만약 추가할 데이터의 날짜가 가장앞쪽의 데이터 보다 작다면 가장앞에 넣는다.
    if (p_Value.m_Sequence < CFNNAVData(m_Items.Items[0]).m_Sequence) then
    begin
      m_Items.Insert(0, p_Value);
    end
    else
    begin
      // 만약 추가할 데이터의 날짜가 가장 앞쪽의 데이터 보다 크다면 가장뒤에 넣는다.
      if (p_Value.m_Sequence > CFNNAVData(m_Items.Items[m_Items.Count - 1]).m_Sequence) then
      begin
        m_Items.Add(p_Value);
      end
      else
      begin
        // 추가할 위치를 찾아서 그 위치 바로 뒤에 넣는다.
        f_SearchIndex := SearchIndex(p_Value.m_Sequence, TRUE);
        if (f_SearchIndex >= 0) then
        begin
          if (p_Value.m_Sequence = CFNNAVData(m_Items.Items[f_SearchIndex]).m_Sequence) then
          begin
            CFNNAVData(m_Items.Items[f_SearchIndex]).Free;
            m_Items.Items[f_SearchIndex] := p_Value
          end
          else
            m_Items.Insert(f_SearchIndex, p_Value);
        end;
      end;
    end;
  end
  else
  begin
    // 데이터가 없다면 그냥 추가한다.
    m_Items.Add(p_Value);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVDataSeries.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNNAVData(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
function CFNNAVDataSeries.SearchIndex(p_Secquence: Integer; p_Nearest: Boolean): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_NAVData: CFNNAVData;
begin
  f_RecordCount := m_Items.Count;
  if (0 < f_RecordCount) then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_NAVData := CFNNAVData(m_Items.Items[f_PosX]);
      f_Compare := p_Secquence - f_NAVData.m_Sequence;
      if (0 > f_Compare) then
        f_PosR := f_PosX - 1
      else
        f_PosL := f_PosX + 1;
    until (not((f_Compare <> 0) and (f_PosL <= f_PosR)));

    if (0 = f_Compare) then
      Result := f_PosX
    else if (p_Nearest) then
      if (f_PosL >= f_RecordCount) then
        Result := -1
      else
        Result := f_PosL
    else
      Result := -1;
  end
  else
  begin
    Result := -1;
  end;
end;

(*
  //---------------------------------------------------------------------------
  procedure CFNNAVDataSeries.Average(p_Count:Integer; p_Precision:Integer);
  var
  f_Index     : Integer;
  f_Index1    : Integer;
  f_Sum       : Double;
  f_CSum      : Double;
  f_Factor    : Double;
  f_Count     : Integer;

  f_Asset     : Double;
  f_Averge    : Double;
  begin
  f_Factor := Math.Power(10, p_Precision);

  for f_Index := 0 to m_Items.Count - 1 do
  begin
  f_Sum := 0;
  f_CSum := 0;
  if (f_Index - p_Count + 1 > 0) then
  begin
  for f_Index1 := 0 to p_Count - 1 do
  begin
  f_Asset := CFNNAVData(m_Items[f_Index - f_Index1]).m_Asset;
  f_Sum   := f_Sum + f_Asset * (p_Count - f_Index1);
  f_CSum  := f_CSum + p_Count - f_Index1;
  end;

  if (f_CSum > 0) then
  begin
  f_Averge := f_Sum / f_CSum;
  CFNNAVData(m_Items[f_Index]).m_AssetAvg := Round(f_Averge * f_Factor) / f_Factor;
  end else
  begin
  CFNNAVData(m_Items[f_Index]).m_AssetAvg := 0;
  end;
  end
  else
  begin
  f_Count := f_Index + 1;
  for f_Index1 := 0 to f_Count - 1 do
  begin
  f_Asset := CFNNAVData(m_Items[f_Index - f_Index1]).m_Asset;
  f_Sum := f_Sum + f_Asset * (f_Count - f_Index1);
  f_CSum := f_CSum + f_Count - f_Index1;
  end;

  if (f_CSum > 0) then
  begin
  f_Averge := f_Sum / f_CSum;
  CFNNAVData(m_Items[f_Index]).m_AssetAvg := Round(f_Averge * f_Factor) / f_Factor;
  end else
  begin
  CFNNAVData(m_Items[f_Index]).m_AssetAvg := 0;
  end;
  end;
  end;
  end;
*)
procedure CFNNAVDataSeries.Average(p_Count: Integer; p_Precision: Integer);
var
  f_Index: Integer;
  f_Index1: Integer;
  f_Sum: Double;
  f_CSum: Double;
  f_Factor: Double;
  f_Count: Integer;

  f_Asset: Double;
  f_Averge: Double;
  f_ValueIndex: Integer;
begin
  f_Factor := Math.Power(10, p_Precision);

  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_Sum := 0;
    f_CSum := 0;

    for f_Index1 := 0 to p_Count - 1 do
    begin
      f_ValueIndex := f_Index - f_Index1;
      if f_ValueIndex >= 0 then
        f_Asset := CFNNAVData(m_Items[f_ValueIndex]).m_Asset
      else
        f_Asset := CFNNAVData(m_Items[0]).m_Asset;

      f_Sum := f_Sum + f_Asset * (p_Count - f_Index1);
      f_CSum := f_CSum + p_Count - f_Index1;
    end;

    if (f_CSum > 0) then
    begin
      f_Averge := f_Sum / f_CSum;
      CFNNAVData(m_Items[f_Index]).m_AssetAvg := Round(f_Averge * f_Factor) / f_Factor;
    end
    else
    begin
      CFNNAVData(m_Items[f_Index]).m_AssetAvg := 0;
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVDataSeries.Clone(p_Source: CFNNAVDataSeries);
var
  f_OldData: CFNNAVData;
  f_NewData: CFNNAVData;
  f_Index: Integer;
begin
  Clear;
  if (p_Source <> NIL) then
  begin
    for f_Index := 0 to p_Source.m_Items.Count - 1 do
    begin
      f_OldData := CFNNAVData(p_Source.m_Items.Items[f_Index]);
      f_NewData := CFNNAVData.Create;
      f_NewData.Clone(f_OldData);
      m_Items.Add(f_NewData);
    end;
  end;
end;

end.
