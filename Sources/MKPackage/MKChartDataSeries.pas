unit MKChartDataSeries;

interface

uses
  SysUtils, Classes, Math, DateUtils, ExtCtrls, MKChartData;

type
  CMKChartDataSeries = class(TObject)
  public
    m_Items: TList;
    m_TimeFrame: Integer;
    m_Precision: Integer;

    m_OriginTime: TDateTime;
    m_Effect: Boolean;

    m_Country: Integer;
    m_Group: Integer;
    m_Market: Integer;
    m_Symbol: String;
    m_Name: String;

    m_IsGapVirtualData: Boolean;
    m_GapVirtualCount: Integer;

  public
    constructor Create();
    destructor Destroy(); override;

    procedure Clear();
    function SearchDayByClose(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
    function SearchWeekByClose(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
    function SearchMonthByClose(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;

    function SearchByClose(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
    function SearchByOpen(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
    function SearchByClose2(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
    function SearchByClose3(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
    function SearchByKey(p_Key: String; p_Nearest: Boolean): Integer;

    procedure Add(p_MarketData: CMKChartData);
    procedure AddTick(p_MarketData: CMKChartData);
    procedure Clone(p_Source: CMKChartDataSeries);
    procedure Update(p_Source: CMKChartDataSeries);
    procedure SaveToFile(p_FileName: String);

    procedure RemoveVirtualData;
    procedure AddVirtualDataAtOpening(ACount: Integer);
  end;

implementation

uses
  MKGlobal;

// ------------------------------------------------------------------------------
constructor CMKChartDataSeries.Create();
begin
  inherited Create;

  m_Items := TList.Create();
  m_Effect := FALSE;
  m_Precision := 0;
  m_TimeFrame := 360;
  m_OriginTime := 0;

  m_IsGapVirtualData := FALSE;
  m_GapVirtualCount := 0;

end;

// ------------------------------------------------------------------------------
destructor CMKChartDataSeries.Destroy();
begin
  Clear();

  m_Items.Free();
  m_Items := NIL;

  inherited Destroy();
end;

// ------------------------------------------------------------------------------
procedure CMKChartDataSeries.Clear();
begin
  while 0 < m_Items.Count do
  begin
    CMKChartData(m_Items.Items[0]).Free();
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKChartDataSeries.Update(p_Source: CMKChartDataSeries);
var
  f_OldMarketData: CMKChartData;
  f_NewMarketData: CMKChartData;
  f_Index: Integer;
  f_Begin, f_End: Integer;
begin

  if m_Items.Count > 0 then
  begin
    if (p_Source <> NIL) then
    begin
      f_Begin := m_Items.Count - 1;
      if f_Begin < 0 then
        f_Begin := 0;
      f_End := p_Source.m_Items.Count;

      for f_Index := f_Begin to f_End - 1 do
      begin
        f_OldMarketData := CMKChartData(p_Source.m_Items.Items[f_Index]);
        if (f_Index < m_Items.Count) then
        begin
          f_NewMarketData := m_Items[f_Index];
          f_NewMarketData.Clone(f_OldMarketData);
        end
        else
        begin
          f_NewMarketData := CMKChartData.Create;
          f_NewMarketData.Clone(f_OldMarketData);
          m_Items.Add(f_NewMarketData);
        end;
      end;
    end;
  end
  else
  begin
    Clone(p_Source);
  end;
end;

// ------------------------------------------------------------------------------
function CMKChartDataSeries.SearchDayByClose(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_MarketData: CMKChartData;
begin

  f_RecordCount := m_Items.Count;
  if (0 < f_RecordCount) then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_MarketData := CMKChartData(m_Items.Items[f_PosX]);
      f_Compare := CompareDate(p_TimeDate, f_MarketData.m_CloseDateTime);

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

// ------------------------------------------------------------------------------
function CMKChartDataSeries.SearchWeekByClose(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_MarketData: CMKChartData;
  f_SDate: Double;
  f_FDate: Double;
begin

  f_SDate := StartOfTheWeek(p_TimeDate); // 해당일의 시작주를 구한다
  f_RecordCount := m_Items.Count;
  if (0 < f_RecordCount) then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_MarketData := CMKChartData(m_Items.Items[f_PosX]);
      f_FDate := StartOfTheWeek(f_MarketData.m_CloseDateTime); // 해당일의 시작주를구한다.
      f_Compare := CompareDate(f_SDate, f_FDate);

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

// ------------------------------------------------------------------------------
function CMKChartDataSeries.SearchMonthByClose(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_MarketData: CMKChartData;
  f_SDate: Double;
  f_FDate: Double;

  Year: Word;
  Month: Word;
  Day: Word;
begin

  DecodeDate(p_TimeDate, Year, Month, Day);
  f_SDate := EncodeDate(Year, Month, 1);
  f_RecordCount := m_Items.Count;
  if (0 < f_RecordCount) then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_MarketData := CMKChartData(m_Items.Items[f_PosX]);
      DecodeDate(f_MarketData.m_CloseDateTime, Year, Month, Day);
      f_FDate := EncodeDate(Year, Month, 1);

      f_Compare := f_SDate - f_FDate;
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

// ------------------------------------------------------------------------------
function CMKChartDataSeries.SearchByClose(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_MarketData: CMKChartData;
begin
  f_RecordCount := m_Items.Count;
  if (0 < f_RecordCount) then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_MarketData := CMKChartData(m_Items.Items[f_PosX]);
      f_Compare := p_TimeDate - f_MarketData.m_CloseDateTime;
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

// ------------------------------------------------------------------------------
function CMKChartDataSeries.SearchByClose2(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_MarketData: CMKChartData;
begin
  f_RecordCount := m_Items.Count;
  if (0 < f_RecordCount) then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_MarketData := CMKChartData(m_Items.Items[f_PosX]);
      f_Compare := p_TimeDate - f_MarketData.m_CloseDateTime;
      if (0 > f_Compare) then
        f_PosR := f_PosX - 1
      else
        f_PosL := f_PosX + 1;
    until (not((f_Compare <> 0) and (f_PosL <= f_PosR)));

    if (0 = f_Compare) then
      Result := f_PosX
    else if (p_Nearest) then
      if (f_PosL >= f_RecordCount) then
        Result := f_RecordCount - 1
      else
        Result := f_PosL - 1
    else
      Result := -1;

  end
  else
  begin
    Result := -1;
  end;
end;

// ------------------------------------------------------------------------------
function CMKChartDataSeries.SearchByClose3(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_MarketData: CMKChartData;
begin
  f_RecordCount := m_Items.Count;
  if (0 < f_RecordCount) then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_MarketData := CMKChartData(m_Items.Items[f_PosX]);
      f_Compare := p_TimeDate - f_MarketData.m_CloseDateTime;
      if (0 > f_Compare) then
        f_PosR := f_PosX - 1
      else
        f_PosL := f_PosX + 1;
    until (not((f_Compare <> 0) and (f_PosL <= f_PosR)));

    if (0 = f_Compare) then
      Result := f_PosX
    else if (p_Nearest) then
      if (f_PosL >= f_RecordCount) then
        Result := f_RecordCount - 1
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

// ------------------------------------------------------------------------------
function CMKChartDataSeries.SearchByKey(p_Key: String; p_Nearest: Boolean): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_MarketData: CMKChartData;
begin
  f_RecordCount := m_Items.Count;
  if (0 < f_RecordCount) then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_MarketData := CMKChartData(m_Items.Items[f_PosX]);

      if (p_Key > f_MarketData.m_Key) then
        f_Compare := 1
      else if (p_Key < f_MarketData.m_Key) then
        f_Compare := -1
      else
        f_Compare := 0;

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

// ------------------------------------------------------------------------------
function CMKChartDataSeries.SearchByOpen(p_TimeDate: TDateTime; p_Nearest: Boolean): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Double;
  f_MarketData: CMKChartData;
begin
  f_RecordCount := m_Items.Count;
  if (0 < f_RecordCount) then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_MarketData := CMKChartData(m_Items.Items[f_PosX]);
      f_Compare := p_TimeDate - f_MarketData.m_OpenDateTime;
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

// ------------------------------------------------------------------------------
procedure CMKChartDataSeries.Add(p_MarketData: CMKChartData);
var
  f_SearchIndex: Integer;
begin
  // 데이터가 하나라도 존재하면
  if (0 < m_Items.Count) then
  begin
    // 만약 추가할 데이터의 날짜가 가장앞쪽의 데이터 보다 작다면 가장앞에 넣는다.
    if (p_MarketData.m_CloseDateTime < CMKChartData(m_Items.Items[0]).m_CloseDateTime) then
    begin
      m_Items.Insert(0, p_MarketData);
    end
    else
    begin
      // 만약 추가할 데이터의 날짜가 가장 앞쪽의 데이터 보다 크다면 가장뒤에 넣는다.
      if (p_MarketData.m_CloseDateTime > CMKChartData(m_Items.Items[m_Items.Count - 1]).m_CloseDateTime) then
      begin
        m_Items.Add(p_MarketData);
      end
      else
      begin
        // 추가할 위치를 찾아서 그 위치 바로 뒤에 넣는다.
        f_SearchIndex := SearchByClose(p_MarketData.m_CloseDateTime, TRUE);
        if (f_SearchIndex >= 0) then
        begin
          if (p_MarketData.m_CloseDateTime = CMKChartData(m_Items.Items[f_SearchIndex]).m_CloseDateTime) then
          begin
            CMKChartData(m_Items.Items[f_SearchIndex]).Free();
            m_Items.Items[f_SearchIndex] := p_MarketData
          end
          else
            m_Items.Insert(f_SearchIndex, p_MarketData);
        end;
      end;
    end;
  end
  else
  begin
    // 데이터가 없다면 그냥 추가한다.
    m_Items.Add(p_MarketData);
  end;
end;

// ------------------------------------------------------------------------------
procedure CMKChartDataSeries.AddTick(p_MarketData: CMKChartData);
var
  f_SearchIndex: Integer;
begin
  if (0 < m_Items.Count) then
  begin
    if (p_MarketData.m_Key < CMKChartData(m_Items.Items[0]).m_Key) then
    begin
      m_Items.Insert(0, p_MarketData);
    end
    else if (p_MarketData.m_Key >= CMKChartData(m_Items.Items[m_Items.Count - 1]).m_Key) then
    begin
      m_Items.Add(p_MarketData);
    end
    else
    begin
      f_SearchIndex := SearchByKey(p_MarketData.m_Key, TRUE);
      if (f_SearchIndex >= 0) then
      begin
        if (f_SearchIndex < m_Items.Count) then
          m_Items.Insert(f_SearchIndex, p_MarketData)
        else
          m_Items.Add(p_MarketData);
      end;
    end;
  end
  else
  begin
    m_Items.Add(p_MarketData);
  end;
end;

// ------------------------------------------------------------------------------
procedure CMKChartDataSeries.RemoveVirtualData;
var
  f_OldMarketData: CMKChartData;
  f_NewMarketData: CMKChartData;
  f_Index: Integer;
  m_TempList: TList;
begin
  (*
    m_TempList := TList.Create;

    for f_Index := 0 to m_Items.Count - 1 do
    begin
    f_OldMarketData := m_Items.Items[f_Index];
    if not f_OldMarketData.m_Virtual then
    begin
    f_NewMarketData := CMKChartData.Create();
    f_NewMarketData.Clone(f_OldMarketData);
    m_TempList.Add(f_NewMarketData);
    end;
    end;
    Clear();

    for f_Index := 0 to m_TempList.Count - 1 do
    begin
    f_NewMarketData := m_TempList.Items[f_Index];
    m_Items.Add(f_NewMarketData);
    end;

    m_TempList.Free; *)

  f_Index := 0;
  while f_Index < m_Items.Count do
  begin
    f_OldMarketData := m_Items.Items[f_Index];
    if f_OldMarketData.m_Virtual then
    begin
      m_Items.Delete(f_Index);
      f_OldMarketData.Free;
      Dec(f_Index);
    end;
    Inc(f_Index);
  end;

  m_IsGapVirtualData := FALSE;
  m_GapVirtualCount := 0;
end;

// ------------------------------------------------------------------------------
procedure CMKChartDataSeries.AddVirtualDataAtOpening(ACount: Integer);
var
  f_MarketData0: CMKChartData;
  f_MarketData1: CMKChartData;
  f_NewMarketData: CMKChartData;
  f_Index: Integer;
  m_TempList: TList;
  f_Count: Integer;
begin

  m_IsGapVirtualData := TRUE;
  m_GapVirtualCount := ACount;

  f_MarketData1 := NIL;

  f_Index := 0;
  while f_Index < m_Items.Count do
  begin
    f_MarketData0 := m_Items.Items[f_Index];
    if Assigned(f_MarketData1) then
    begin
      if not SameDate(f_MarketData0.m_OpenDateTime, f_MarketData1.m_OpenDateTime) then
      begin
        for f_Count := 0 to ACount - 1 do
        begin
          f_NewMarketData := CMKChartData.Create();
          f_NewMarketData.Clone(f_MarketData0);

          f_NewMarketData.m_Virtual := TRUE;

          f_NewMarketData.m_OpenDateTime := f_MarketData1.m_CloseDateTime;
          f_NewMarketData.m_CloseDateTime := f_MarketData1.m_CloseDateTime;

          f_NewMarketData.m_OpenPrice := f_MarketData0.m_OpenPrice;
          f_NewMarketData.m_HighPrice := f_MarketData0.m_OpenPrice;
          f_NewMarketData.m_LowPrice := f_MarketData0.m_OpenPrice;
          f_NewMarketData.m_ClosePrice := f_MarketData0.m_OpenPrice;

          f_NewMarketData.m_OpenOPS := f_MarketData0.m_OpenOPS;
          f_NewMarketData.m_HighOPS := f_MarketData0.m_OpenOPS;
          f_NewMarketData.m_LowOPS := f_MarketData0.m_OpenOPS;
          f_NewMarketData.m_CloseOPS := f_MarketData0.m_OpenOPS;

          f_NewMarketData.m_Volume := 0;

          m_Items.Insert(f_Index, f_NewMarketData);
          Inc(f_Index);
        end;
      end;
    end;
    Inc(f_Index);
    f_MarketData1 := f_MarketData0;
  end;
end;

// ------------------------------------------------------------------------------
procedure CMKChartDataSeries.Clone(p_Source: CMKChartDataSeries);
var
  f_OldMarketData: CMKChartData;
  f_NewMarketData: CMKChartData;
  f_Index: Integer;
begin
  Clear();
  if (p_Source <> NIL) then
  begin
    m_Country := p_Source.m_Country;
    m_Group := p_Source.m_Group;
    m_Market := p_Source.m_Market;
    m_Symbol := p_Source.m_Symbol;
    m_Name := p_Source.m_Name;
    m_TimeFrame := p_Source.m_TimeFrame;
    m_Precision := p_Source.m_Precision;
    m_OriginTime := p_Source.m_OriginTime;
    m_Effect := p_Source.m_Effect;

    for f_Index := 0 to p_Source.m_Items.Count - 1 do
    begin
      f_OldMarketData := CMKChartData(p_Source.m_Items.Items[f_Index]);
      f_NewMarketData := CMKChartData.Create();
      f_NewMarketData.Clone(f_OldMarketData);
      m_Items.Add(f_NewMarketData);
    end;
  end;
end;

// ------------------------------------------------------------------------------
procedure CMKChartDataSeries.SaveToFile(p_FileName: String);
var
  f_Index: Integer;
  f_Mode: Word;
  f_FileStream: TFileStream;
  f_TimeString: String;
  f_DesEncoding: TEncoding;
  f_ByteOrderMark: TBytes;
  f_Buffer: TBytes;
  f_Line: String;
  f_RecordIndex: Integer;
  f_ChartData: CMKChartData;
begin
  try
    f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
    f_FileStream := TFileStream.Create(p_FileName, f_Mode);
    if Assigned(f_FileStream) then
    begin

      if (f_FileStream.Size <= 0) then
      begin
        f_DesEncoding := TEncoding.UTF8;
        f_ByteOrderMark := f_DesEncoding.GetPreamble;

        f_FileStream.Size := 0;
        f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
      end;

      f_Line := '순번,날짜,시간,OPS,선물가격' + #$D#$A;

      f_Buffer := f_DesEncoding.GetBytes(f_Line);
      f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

      for f_RecordIndex := 0 to m_Items.Count - 1 do
      begin
        f_ChartData := m_Items[f_RecordIndex];

        f_Line := Format('%d', [f_RecordIndex]) + ',' + DateToStr(f_ChartData.m_CloseDateTime) + ',' +
            TMKGlobal.DateTimeToStr6(f_ChartData.m_CloseDateTime) + ',' + Format('%.6f', [f_ChartData.m_CloseOPS]) + ',' +
            Format('%.2f', [f_ChartData.m_ClosePrice]) + #$D#$A;

        f_Buffer := f_DesEncoding.GetBytes(f_Line);
        f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

      end;

      f_FileStream.Free;
      f_FileStream := NIL;

    end;
  finally
  end;
end;

end.
