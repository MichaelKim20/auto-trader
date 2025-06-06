unit FNVolumePriceArray;

interface

uses
  Math, Windows, SysUtils, Classes, FNVolumePriceData;

const
  VOLUMEPRICE_MACOUNT = 3;

type
  CFNVolumePriceArray = class(TObject)

  public
    m_DateTime: TDateTime; // 집계한 날짜
    m_Items: TList; // 실제 데이터가 들어 있는 자료구조
    m_TotalVolume: Double; // 전체 거래량
    m_AvgVolume: Double; // 평균 거래량
    m_TotalVolumePrice: Double; // 전체 거래대금
    m_AvgPrice: Double; // 평균체결가(전체 거래대금 / 전체거래량)
    m_MaxVolume: Double; // 최고거래량
    m_MinVolume: Double; // 최저거래량
    m_PriceInMaxVolume: Double; // 최고거래량 일 때의 가격
    m_PriceInMinVolume: Double; // 최저거래량 일 때의 가격
    m_IndexInMaxVolume: Integer; // 최고거래량 일 때의 인덱스
    m_BeginIndex: Integer;
    m_EndIndex: Integer;
    m_MaxPrice: Double;
    m_MinPrice: Double;
    m_ClosePrice: Double; // 전체 거래량

    m_VolumeRatio: Double;
    m_VolumePriceRatio: Double;

    m_AvgPriceIndex: Integer;

  public
    constructor Create();
    destructor Destroy(); override;

  public
    procedure Clear();
    procedure Clone(p_Source: CFNVolumePriceArray);

    function Search(p_Date: TDateTime; p_Price: Double; p_Nearest: Boolean = true): Integer;

    procedure Add(p_VolumePriceData: CFNVolumePriceData);
    procedure Update(ADate: Integer; APrice: Double; AVolume: Double);
    procedure AddData(ADate: Integer; APrice: Double; AVolume: Double);

    procedure Sort();
    procedure Calculate;

    procedure FindUpDnRange(p_Percent: Double; var p_LowRange: Double; var p_HighRange: Double);

    function GetPrifitRatio(p_Price: Double): Double;

    procedure SaveToFile(p_DateTime: TDateTime; p_Value1, p_Value2: Double);

  private
    function SumOfBelow(p_Index: Integer): Double;
    function SumOfAbove(p_Index: Integer): Double;
    function SumOfBelowEq(p_Index: Integer): Double;
    function SumOfAboveEq(p_Index: Integer): Double;

  end;

implementation

uses
  FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNVolumePriceArray.Create();
begin
  inherited Create();
  m_MaxVolume := 0;
  m_MinVolume := 0;
  m_TotalVolume := 0;
  m_TotalVolumePrice := 0;
  m_PriceInMaxVolume := 0;
  m_PriceInMaxVolume := 0;

  m_PriceInMaxVolume := 0;
  m_PriceInMinVolume := 0;

  m_BeginIndex := 0;
  m_EndIndex := 0;

  m_VolumeRatio := 0;
  m_VolumeRatio := 0;

  m_Items := TList.Create();
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CFNVolumePriceArray.Destroy();
begin
  Clear();

  m_Items.Free();
  m_Items := NIL;

  inherited Destroy();
end;

function CFNVolumePriceArray.GetPrifitRatio(p_Price: Double): Double;
var
  f_SearchIndex: Integer;
  f_LowRangeSum, f_HighRangeSum: Double;
begin
  if p_Price > m_MaxPrice then
  begin
    f_SearchIndex := m_Items.Count - 1;
  end
  else
  begin
    f_SearchIndex := Search(m_DateTime, p_Price, true);
  end;

  if 0 <= f_SearchIndex then
  begin
    f_LowRangeSum := SumOfBelowEq(f_SearchIndex);
    if 0 = m_TotalVolume then
      Result := 0
    else
      Result := f_LowRangeSum * 100.0 / m_TotalVolumePrice;
  end
  else
  begin
    Result := 0;
  end;
end;

// ---------------------------------------------------------------------------
// 배열의 구성요소를 모두 삭제한다.
procedure CFNVolumePriceArray.Calculate;
var
  f_VolumePriceData: CFNVolumePriceData;
  f_Index: Integer;
  f_AvgCount: Integer;
begin
  m_TotalVolume := 0;
  m_TotalVolumePrice := 0;
  m_PriceInMaxVolume := 0;
  m_PriceInMinVolume := 0;
  m_IndexInMaxVolume := 0;

  // 최고최거거래량과, 합계를 계산한다.
  if (m_Items.Count > 0) then
  begin
    m_MaxVolume := -1.0E100;
    m_MinVolume := 1.0E100;

    f_AvgCount := VOLUMEPRICE_MACOUNT;

    for f_Index := 0 to m_Items.Count - 1 do
    begin
      f_VolumePriceData := m_Items[f_Index];
      m_TotalVolume := m_TotalVolume + f_VolumePriceData.m_Volume;
      m_TotalVolumePrice := m_TotalVolumePrice + (f_VolumePriceData.m_Volume * f_VolumePriceData.m_Price);
      if m_MaxVolume < f_VolumePriceData.m_Volume then
      begin
        m_MaxVolume := f_VolumePriceData.m_Volume;
        m_PriceInMaxVolume := f_VolumePriceData.m_Price;
        m_IndexInMaxVolume := f_Index;
      end;
      if m_MinVolume > f_VolumePriceData.m_Volume then
      begin
        m_MinVolume := f_VolumePriceData.m_Volume;
        m_PriceInMinVolume := f_VolumePriceData.m_Price;
      end;

    end;

    f_VolumePriceData := m_Items[0];
    m_MinPrice := f_VolumePriceData.m_Price;

    f_VolumePriceData := m_Items[m_Items.Count - 1];
    m_MaxPrice := f_VolumePriceData.m_Price;

  end
  else
  begin
    m_MaxVolume := 0;
    m_MinVolume := 0;
    m_MinPrice := 0;
    m_MaxPrice := 0;

  end;
  // 평균체결가격을 계산한다.
  if m_TotalVolume <> 0 then
  begin
    m_AvgPrice := m_TotalVolumePrice / m_TotalVolume;
  end
  else
  begin
    m_AvgPrice := 0;
  end;
  // 평균거래량을 계산한다.
  if m_Items.Count <> 0 then
  begin
    m_AvgVolume := m_TotalVolumePrice / m_Items.Count;
  end
  else
  begin
    m_AvgVolume := 0;
  end;

  m_AvgPriceIndex := Search(m_DateTime, m_AvgPrice, true);

  if m_AvgPriceIndex < 0 then
  begin
    m_AvgPriceIndex := m_Items.Count div 2;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNVolumePriceArray.Clear();
begin
  while 0 < m_Items.Count do
  begin
    CFNVolumePriceData(m_Items.Items[0]).Free();
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 하나를 추가한다.
procedure CFNVolumePriceArray.Add(p_VolumePriceData: CFNVolumePriceData);
begin
  m_Items.Add(p_VolumePriceData);
end;

// ---------------------------------------------------------------------------
function CMP_VPData(ADate1: Integer; APrice1: Double; ADate2: Integer; APrice2: Double): Integer;
var
  f_Compare: Integer;
begin
  f_Compare := 0;

  if ADate1 > ADate2 then
  begin
    f_Compare := 1;
  end
  else if ADate1 < ADate2 then
  begin
    f_Compare := -1;
  end
  else
  begin
    f_Compare := 0;
  end;
  if (f_Compare = 0) then
  begin
    if APrice1 > APrice2 then
    begin
      f_Compare := 1;
    end
    else if APrice1 < APrice2 then
    begin
      f_Compare := -1;
    end
    else
    begin
      f_Compare := 0;
    end;
  end;
  Result := f_Compare;
end;

// ---------------------------------------------------------------------------
// 해당값을 가지고 있는 요소를 찾아 그 인덱스를 리턴한다.
procedure CFNVolumePriceArray.SaveToFile(p_DateTime: TDateTime; p_Value1, p_Value2: Double);
var
  f_FileName: String;
  f_FilePath: String;
  f_Mode: Word;
  f_FileStream: TFileStream;
  f_TimeString: String;
  f_DesEncoding: TEncoding;
  f_ByteOrderMark: TBytes;
  f_Buffer: TBytes;
  f_ItemIndex: Integer;
  f_Line: String;
  f_VolumePriceData: CFNVolumePriceData;
begin

  f_FilePath := ExtractFilePath(ParamStr(0)) + 'PriceVolume\';
  if not DirectoryExists(f_FilePath) then
  begin
    CreateDir(f_FilePath);
  end;

  f_TimeString := TFNGlobal.DateTimeToString(p_DateTime, 'YYYYMMDDHHMMSS');

  f_FileName := f_FilePath + f_TimeString + '.csv';

  f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
  f_FileStream := TFileStream.Create(f_FileName, f_Mode);
  if Assigned(f_FileStream) then
  begin

    if (f_FileStream.Size <= 0) then
    begin
      f_DesEncoding := TEncoding.UTF8;
      f_ByteOrderMark := f_DesEncoding.GetPreamble;

      f_FileStream.Size := 0;
      f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
    end;

    f_Line := 'TotalVolume' + ',' + TFNGlobal.WriteNumberF(m_TotalVolume, 0) + #$D#$A;
    f_Buffer := f_DesEncoding.GetBytes(f_Line);
    f_FileStream.Write(f_Buffer[0], Length(f_Buffer));
    f_Line := 'AvgVolume' + ',' + TFNGlobal.WriteNumberF(m_AvgVolume, 2) + #$D#$A;
    f_Buffer := f_DesEncoding.GetBytes(f_Line);
    f_FileStream.Write(f_Buffer[0], Length(f_Buffer));
    f_Line := 'AvgPrice' + ',' + TFNGlobal.WriteNumberF(m_AvgPrice, 2) + #$D#$A;
    f_Buffer := f_DesEncoding.GetBytes(f_Line);
    f_FileStream.Write(f_Buffer[0], Length(f_Buffer));
    f_Line := 'UpPrice' + ',' + TFNGlobal.WriteNumberF(p_Value1, 2) + #$D#$A;
    f_Buffer := f_DesEncoding.GetBytes(f_Line);
    f_FileStream.Write(f_Buffer[0], Length(f_Buffer));
    f_Line := 'DnPrice' + ',' + TFNGlobal.WriteNumberF(p_Value2, 2) + #$D#$A;
    f_Buffer := f_DesEncoding.GetBytes(f_Line);
    f_FileStream.Write(f_Buffer[0], Length(f_Buffer));
    f_Line := 'Volatility' + ',' + TFNGlobal.WriteNumberF(p_Value1 - p_Value2, 2) + #$D#$A;
    f_Buffer := f_DesEncoding.GetBytes(f_Line);
    f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

    for f_ItemIndex := 0 to m_Items.Count - 1 do
    begin
      f_VolumePriceData := m_Items[f_ItemIndex];

      f_Line := TFNGlobal.WriteNumberF(f_VolumePriceData.m_Price, 2) + ',' + TFNGlobal.WriteNumberF(f_VolumePriceData.m_Volume, 0) + #$D#$A;

      f_Buffer := f_DesEncoding.GetBytes(f_Line);
      f_FileStream.Seek(0, FILE_END);
      f_FileStream.Write(f_Buffer[0], Length(f_Buffer));
    end;

    f_FileStream.Free;
    f_FileStream := NIL;
  end;
end;

function CFNVolumePriceArray.Search(p_Date: TDateTime; p_Price: Double; p_Nearest: Boolean): Integer;
var
  f_PosX: Integer;
  f_PosL: Integer;
  f_PosR: Integer;
  f_RecordCount: Integer;
  f_Compare: Integer;
  f_VolumePriceData: CFNVolumePriceData;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_PosL := 0;
    f_PosR := f_RecordCount - 1;

    repeat
      f_PosX := Math.floor((f_PosL + f_PosR) / 2);
      f_VolumePriceData := CFNVolumePriceData(m_Items.Items[f_PosX]);

      f_Compare := CMP_VPData(Trunc(p_Date), p_Price, Trunc(f_VolumePriceData.m_DateTime), f_VolumePriceData.m_Price);

      if (0 > f_Compare) then
        f_PosR := f_PosX - 1
      else
        f_PosL := f_PosX + 1;
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
function VolumePriceData_Compare(Item1, Item2: Pointer): Integer;
var
  f_VolumePriceData1: CFNVolumePriceData;
  f_VolumePriceData2: CFNVolumePriceData;
  f_Compare: Integer;
begin
  f_VolumePriceData1 := CFNVolumePriceData(Item1);
  f_VolumePriceData2 := CFNVolumePriceData(Item2);

  f_Compare := CMP_VPData(Trunc(f_VolumePriceData1.m_DateTime), f_VolumePriceData1.m_Price, Trunc(f_VolumePriceData2.m_DateTime), f_VolumePriceData2.m_Price);

  Result := f_Compare;
end;

// ---------------------------------------------------------------------------
// 비교함수를 이용하여 정렬한다.
procedure CFNVolumePriceArray.Sort();
begin
  m_Items.Sort(@VolumePriceData_Compare);
end;

// ---------------------------------------------------------------------------
function CFNVolumePriceArray.SumOfAbove(p_Index: Integer): Double;
var
  f_VolumePriceData: CFNVolumePriceData;
  f_Sum: Double;
  f_Index: Integer;
begin
  f_Sum := 0;
  for f_Index := p_Index + 1 to m_Items.Count - 1 do
  begin
    f_VolumePriceData := m_Items[f_Index];
    f_Sum := f_Sum + f_VolumePriceData.m_Volume;
  end;
  Result := f_Sum;
end;

// ---------------------------------------------------------------------------
function CFNVolumePriceArray.SumOfBelow(p_Index: Integer): Double;
var
  f_VolumePriceData: CFNVolumePriceData;
  f_Sum: Double;
  f_Index: Integer;
begin
  f_Sum := 0;
  for f_Index := p_Index - 1 downto 0 do
  begin
    f_VolumePriceData := m_Items[f_Index];
    f_Sum := f_Sum + f_VolumePriceData.m_Volume;
  end;
  Result := f_Sum;
end;

// ---------------------------------------------------------------------------
function CFNVolumePriceArray.SumOfAboveEq(p_Index: Integer): Double;
var
  f_VolumePriceData: CFNVolumePriceData;
  f_Sum: Double;
  f_Index: Integer;
begin
  f_Sum := 0;
  for f_Index := p_Index to m_Items.Count - 1 do
  begin
    if p_Index < 0 then
      continue;
    f_VolumePriceData := m_Items[f_Index];
    f_Sum := f_Sum + (f_VolumePriceData.m_Price * f_VolumePriceData.m_Volume);
  end;
  Result := f_Sum;
end;

// ---------------------------------------------------------------------------
function CFNVolumePriceArray.SumOfBelowEq(p_Index: Integer): Double;
var
  f_VolumePriceData: CFNVolumePriceData;
  f_Sum: Double;
  f_Index: Integer;
begin
  f_Sum := 0;
  for f_Index := p_Index downto 0 do
  begin
    if p_Index >= m_Items.Count then
      continue;
    f_VolumePriceData := m_Items[f_Index];
    f_Sum := f_Sum + (f_VolumePriceData.m_Price * f_VolumePriceData.m_Volume);
  end;
  Result := f_Sum;
end;

// ---------------------------------------------------------------------------
// 날짜와 가격에 해당되는 값이 존재 하면 누적하고, 없으면 삽입한다.
procedure CFNVolumePriceArray.Update(ADate: Integer; APrice: Double; AVolume: Double);
var
  f_RecordCount: Integer;
  f_SearchIndex: Integer;
  f_VolumePriceData: CFNVolumePriceData;
  f_NewVolumePriceData: CFNVolumePriceData;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_VolumePriceData := m_Items[0];
    if (CMP_VPData(ADate, APrice, Trunc(f_VolumePriceData.m_DateTime), f_VolumePriceData.m_Price) < 0) then
    begin
      f_NewVolumePriceData := CFNVolumePriceData.Create;
      f_NewVolumePriceData.m_DateTime := ADate;
      f_NewVolumePriceData.m_Price := APrice;
      f_NewVolumePriceData.m_Volume := AVolume;
      m_Items.Insert(0, f_NewVolumePriceData);
    end
    else
    begin
      f_VolumePriceData := m_Items[f_RecordCount - 1];
      if (CMP_VPData(ADate, APrice, Trunc(f_VolumePriceData.m_DateTime), f_VolumePriceData.m_Price) > 0) then
      begin
        f_NewVolumePriceData := CFNVolumePriceData.Create;
        f_NewVolumePriceData.m_DateTime := ADate;
        f_NewVolumePriceData.m_Price := APrice;
        f_NewVolumePriceData.m_Volume := AVolume;
        m_Items.Add(f_NewVolumePriceData);
      end
      else
      begin
        f_SearchIndex := Search(ADate, APrice, true);
        if (f_SearchIndex >= 0) then
        begin
          f_VolumePriceData := m_Items[f_SearchIndex];
          if (CMP_VPData(ADate, APrice, Trunc(f_VolumePriceData.m_DateTime), f_VolumePriceData.m_Price) = 0) then
          begin
            f_VolumePriceData.m_Volume := f_VolumePriceData.m_Volume + AVolume;
          end
          else
          begin
            f_NewVolumePriceData := CFNVolumePriceData.Create;
            f_NewVolumePriceData.m_DateTime := ADate;
            f_NewVolumePriceData.m_Price := APrice;
            f_NewVolumePriceData.m_Volume := AVolume;
            m_Items.Insert(f_SearchIndex, f_NewVolumePriceData);
          end;
        end;
      end;
    end;
  end
  else
  begin
    f_NewVolumePriceData := CFNVolumePriceData.Create;
    f_NewVolumePriceData.m_DateTime := ADate;
    f_NewVolumePriceData.m_Price := APrice;
    f_NewVolumePriceData.m_Volume := AVolume;
    m_Items.Add(f_NewVolumePriceData);
  end;
end;

// ---------------------------------------------------------------------------
// 날짜와 가격에 해당되는 값이 존재 하면 교체하고, 없으면 삽입한다.
procedure CFNVolumePriceArray.AddData(ADate: Integer; APrice: Double; AVolume: Double);
var
  f_RecordCount: Integer;
  f_SearchIndex: Integer;
  f_VolumePriceData: CFNVolumePriceData;
  f_NewVolumePriceData: CFNVolumePriceData;
begin
  f_RecordCount := m_Items.Count;
  if 0 < f_RecordCount then
  begin
    f_VolumePriceData := m_Items[0];
    if (CMP_VPData(ADate, APrice, Trunc(f_VolumePriceData.m_DateTime), f_VolumePriceData.m_Price) < 0) then
    begin
      f_NewVolumePriceData := CFNVolumePriceData.Create;
      f_NewVolumePriceData.m_DateTime := ADate;
      f_NewVolumePriceData.m_Price := APrice;
      f_NewVolumePriceData.m_Volume := AVolume;
      m_Items.Insert(0, f_NewVolumePriceData);
    end
    else
    begin
      f_VolumePriceData := m_Items[f_RecordCount - 1];
      if (CMP_VPData(ADate, APrice, Trunc(f_VolumePriceData.m_DateTime), f_VolumePriceData.m_Price) > 0) then
      begin
        f_NewVolumePriceData := CFNVolumePriceData.Create;
        f_NewVolumePriceData.m_DateTime := ADate;
        f_NewVolumePriceData.m_Price := APrice;
        f_NewVolumePriceData.m_Volume := AVolume;
        m_Items.Add(f_NewVolumePriceData);
      end
      else
      begin
        f_SearchIndex := Search(ADate, APrice, true);
        if (f_SearchIndex >= 0) then
        begin
          f_VolumePriceData := m_Items[f_SearchIndex];
          if (CMP_VPData(ADate, APrice, Trunc(f_VolumePriceData.m_DateTime), f_VolumePriceData.m_Price) = 0) then
          begin
            f_VolumePriceData.m_DateTime := ADate;
            f_VolumePriceData.m_Price := APrice;
            f_VolumePriceData.m_Volume := f_VolumePriceData.m_Volume + AVolume;
          end
          else
          begin
            f_NewVolumePriceData := CFNVolumePriceData.Create;
            f_NewVolumePriceData.m_DateTime := ADate;
            f_NewVolumePriceData.m_Price := APrice;
            f_NewVolumePriceData.m_Volume := AVolume;
            m_Items.Insert(f_SearchIndex, f_NewVolumePriceData);
          end;
        end;
      end;
    end;
  end
  else
  begin
    f_NewVolumePriceData := CFNVolumePriceData.Create;
    f_NewVolumePriceData.m_DateTime := ADate;
    f_NewVolumePriceData.m_Price := APrice;
    f_NewVolumePriceData.m_Volume := AVolume;
    m_Items.Add(f_NewVolumePriceData);
  end;
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하여 복제한다.
procedure CFNVolumePriceArray.Clone(p_Source: CFNVolumePriceArray);
var
  f_OldVolumePriceData: CFNVolumePriceData;
  f_NewVolumePriceData: CFNVolumePriceData;
  f_Index: Integer;
begin
  Clear();
  for f_Index := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_OldVolumePriceData := CFNVolumePriceData(p_Source.m_Items.Items[f_Index]);
    f_NewVolumePriceData := CFNVolumePriceData.Create();
    f_NewVolumePriceData.Clone(f_OldVolumePriceData);
    m_Items.Add(f_NewVolumePriceData);
  end;
end;

procedure CFNVolumePriceArray.FindUpDnRange(p_Percent: Double; var p_LowRange: Double; var p_HighRange: Double);
var
  f_VolumePriceData: CFNVolumePriceData;
  f_LowIndex: Integer;
  f_HighIndex: Integer;
  f_SumRange: Double;
  f_NewSumRange: Double;
  f_LowRangeSum, f_HighRangeSum: Double;
begin
  if (m_TotalVolume <= 0) OR (m_Items.Count < 0) then
  begin
    p_LowRange := 0;
    p_HighRange := 0;
    exit;
  end;
  f_LowIndex := m_AvgPriceIndex;
  f_HighIndex := m_AvgPriceIndex;
  f_VolumePriceData := m_Items[m_AvgPriceIndex];

  f_SumRange := f_VolumePriceData.m_Volume;
  if ((f_SumRange / m_TotalVolume) >= p_Percent / 100.0) then
  begin
    exit;
  end;

  while (true) do
  begin
    f_LowRangeSum := SumOfBelow(f_LowIndex);
    f_HighRangeSum := SumOfAbove(f_HighIndex);

    if (f_LowRangeSum < f_HighRangeSum) then
    begin
      if (f_HighIndex < m_Items.Count - 1) then
      begin
        f_HighIndex := f_HighIndex + 1;
        if (f_HighIndex < 0) OR (f_HighIndex >= m_Items.Count) then
        begin
          exit;
        end;
        f_VolumePriceData := m_Items[f_HighIndex];
        f_NewSumRange := f_SumRange + f_VolumePriceData.m_Volume;
      end
      else
      begin
        f_LowIndex := f_LowIndex - 1;
        if (f_LowIndex < 0) OR (f_LowIndex >= m_Items.Count) then
        begin
          exit;
        end;
        f_VolumePriceData := m_Items[f_LowIndex];
        f_NewSumRange := f_SumRange + f_VolumePriceData.m_Volume;
      end;
    end
    else
    begin
      if f_LowIndex > 0 then
      begin
        f_LowIndex := f_LowIndex - 1;
        if (f_LowIndex < 0) OR (f_LowIndex >= m_Items.Count) then
        begin
          exit;
        end;
        f_VolumePriceData := m_Items[f_LowIndex];
        f_NewSumRange := f_SumRange + f_VolumePriceData.m_Volume;
      end
      else
      begin
        f_HighIndex := f_HighIndex + 1;
        if (f_HighIndex < 0) OR (f_HighIndex >= m_Items.Count) then
        begin
          exit;
        end;
        f_VolumePriceData := m_Items[f_HighIndex];
        f_NewSumRange := f_SumRange + f_VolumePriceData.m_Volume;
      end;
    end;

    if ((f_SumRange / m_TotalVolume) < p_Percent / 100.0) AND ((f_NewSumRange / m_TotalVolume) >= p_Percent / 100.0) then
    begin
      f_VolumePriceData := m_Items[f_LowIndex];
      p_LowRange := f_VolumePriceData.m_Price;

      f_VolumePriceData := m_Items[f_HighIndex];
      p_HighRange := f_VolumePriceData.m_Price;

      exit;
    end;

    f_SumRange := f_NewSumRange;
  end;
end;

end.
