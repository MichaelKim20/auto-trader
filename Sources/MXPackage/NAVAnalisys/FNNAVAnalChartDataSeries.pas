unit FNNAVAnalChartDataSeries;

interface

uses
  SysUtils, Classes, Math, DateUtils, FNNAVAnalChartData, FNPOTCollection,
  FNQuotData, FNDataSet;

type
  // ---------------------------------------------------------------------------
  CFNNAVAnalChartDataSeries = class(TObject)
  public
    m_Items: TList;

    constructor Create;
    destructor Destroy; override;

  public
    procedure Clear;
    procedure Add(p_ValueItem: CFNNAVAnalChartData);
    procedure Clone(p_Source: CFNNAVAnalChartDataSeries);
    function Search(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
  end;

implementation

uses FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNNAVAnalChartDataSeries.Create;
begin
  inherited Create;

  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
destructor CFNNAVAnalChartDataSeries.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
function CFNNAVAnalChartDataSeries.Search(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_ValueItem: CFNNAVAnalChartData;
begin
  f_RecordCount := m_Items.Count;
  if (0 < f_RecordCount) then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_ValueItem := CFNNAVAnalChartData(m_Items.Items[f_PosX]);
      f_Compare := p_TimeDate - f_ValueItem.m_Date;
      if (0 > f_Compare) then
      begin
        f_PosR := f_PosX - 1
      end
      else
      begin
        f_PosL := f_PosX + 1;
      end;
    until (not((f_Compare <> 0) and (f_PosL <= f_PosR)));

    if (0 = f_Compare) then
    begin
      Result := f_PosX
    end
    else if (p_Nearest) then
    begin
      if (f_PosL >= f_RecordCount) then
        Result := -1
      else
        Result := f_PosL
    end
    else
    begin
      Result := -1;
    end;

  end
  else
  begin
    Result := -1;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartDataSeries.Add(p_ValueItem: CFNNAVAnalChartData);
var
  f_SearchIndex: Integer;
begin
  // 데이터가 하나라도 존재하면
  if (0 < m_Items.Count) then
  begin
    // 만약 추가할 데이터의 날짜가 가장앞쪽의 데이터 보다 작다면 가장앞에 넣는다.
    if (p_ValueItem.m_Date < CFNNAVAnalChartData(m_Items.Items[0]).m_Date) then
    begin
      m_Items.Insert(0, p_ValueItem);
    end
    else
    begin
      // 만약 추가할 데이터의 날짜가 가장 앞쪽의 데이터 보다 크다면 가장뒤에 넣는다.
      if (p_ValueItem.m_Date > CFNNAVAnalChartData(m_Items.Items[m_Items.Count - 1]).m_Date) then
      begin
        m_Items.Add(p_ValueItem);
      end
      else
      begin
        // 추가할 위치를 찾아서 그 위치 바로 뒤에 넣는다.
        f_SearchIndex := Search(p_ValueItem.m_Date, TRUE);
        if (f_SearchIndex >= 0) then
        begin
          if (p_ValueItem.m_Date = CFNNAVAnalChartData(m_Items.Items[f_SearchIndex]).m_Date) then
          begin
            CFNNAVAnalChartData(m_Items.Items[f_SearchIndex]).Free;
            m_Items.Items[f_SearchIndex] := p_ValueItem
          end
          else
            m_Items.Insert(f_SearchIndex, p_ValueItem);
        end;
      end;
    end;
  end
  else
  begin
    // 데이터가 없다면 그냥 추가한다.
    m_Items.Add(p_ValueItem);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNNAVAnalChartDataSeries.Clone(p_Source: CFNNAVAnalChartDataSeries);
var
  f_ValueItem1: CFNNAVAnalChartData;
  f_ValueItem2: CFNNAVAnalChartData;
  f_Index: Integer;
begin
  Clear;
  if (p_Source <> NIL) then
  begin
    for f_Index := 0 to p_Source.m_Items.Count - 1 do
    begin
      f_ValueItem1 := CFNNAVAnalChartData(p_Source.m_Items.Items[f_Index]);
      f_ValueItem2 := CFNNAVAnalChartData.Create;
      f_ValueItem2.Clone(f_ValueItem1);
      m_Items.Add(f_ValueItem2);
    end;
  end;
end;

procedure CFNNAVAnalChartDataSeries.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNNAVAnalChartData(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

end.
