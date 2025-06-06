unit FNQuotData;

interface

uses
  SysUtils, FNMaterialCollection, FNDataSet;

type

  /// /////////////////////////////////////////////////////////////////////////
  //
  CFNQuotData = class(TObject)
  public
    m_Key: String; // 구분키
    m_DateTime: TDateTime; // 시간
    m_Year: Integer; // 년
    m_Month: Integer; // 월
    m_Day: Integer; // 일
    m_Hour: Integer; // 시
    m_Min: Integer; // 분
    m_Sec: Integer; // 초
    m_MSec: Integer; // 초
    m_Country: Integer; // 0:한국
    m_Group: Integer; // 0:지수, 1:주식, 2:선물, 3:옵션
    m_Market: Integer; // 0:코스피, 1:코스닥
    m_Symbol: String; // 주식 또는 지수의 심벌
    m_Name: String; // 주식 또는 지수의 이름

    m_OpenPrice: Double; // 시가
    m_HighPrice: Double; // 고가
    m_LowPrice: Double; // 저가
    m_ClosePrice: Double; // 종가(현재가)

    m_OpenOPS: Double; // 시가
    m_HighOPS: Double; // 고가
    m_LowOPS: Double; // 저가
    m_CloseOPS: Double; // 종가(현재가)

    m_Volume: Double; // 체결량
    m_PrevPrice: Double; // 전일종가
    m_ChangeFlag: String; // 등락구분
    m_ChangePrice: Double; // 전일대비
    m_ChangeRate: Double; // 등락률
    m_TotalVolume: Double; // 누적 거래량
    m_TotalPrice: Double; // 누적 거래대금
    m_MaxLimit: Double;
    m_MinLimit: Double;
    m_OfferPrice: Double; // 매도 호가
    m_BidPrice: Double; // 매수 호가
    m_OfferVolume: Double; // 매도 잔량
    m_BidVolume: Double; // 매수 잔량

    m_UpdateRequest: Boolean;
    m_UpdateStreamming: Boolean;
    m_ItemIndex: Integer;

    m_RealPrice: Double; // f

    m_HighLight: Boolean;
    m_UpdateTime: TDateTime; // 시간

    m_Object: TObject;
    m_MaterialItem: CFNMaterialItem;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clone(p_Source: CFNQuotData);
    procedure ArrayToData(p_Record: CFNRecord);

    procedure OPSArrayToData(p_Record: CFNRecord);
    procedure OPSStreamDataToData(p_StreamRecord: CFNStreamRecord);

  end;

implementation

uses FNGlobal, DateUtils;

// ---------------------------------------------------------------------------
constructor CFNQuotData.Create;
begin
  inherited Create;

  m_Volume := 0;
  m_TotalVolume := 0;

  m_UpdateRequest := false;
  m_UpdateStreamming := false;

end;

// ---------------------------------------------------------------------------
destructor CFNQuotData.Destroy;
begin

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNQuotData.ArrayToData(p_Record: CFNRecord);
var
  f_Date, f_Time: String;
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin
  f_Date := p_Record.GetStringValue('DATE');
  f_Time := p_Record.GetStringValue('TIME');
  if f_Date = '' then
    f_Date := TFNGlobal.DateTimeToString(Now, 'YYYYMMDD');

  m_DateTime := TFNGlobal.StringToDateTime(f_Date + f_Time);
  DecodeDateTime(m_DateTime, Year, Month, Day, Hour, Min, Sec, MSec);

  m_Year := Year;
  m_Month := Month;
  m_Day := Day;
  m_Hour := Hour;
  m_Min := Min;
  m_Sec := Sec;
  m_MSec := MSec;

  m_Country := p_Record.GetIntegerValue('COUNTRY_NO');
  m_Group := p_Record.GetIntegerValue('GROUP_NO');
  m_Market := p_Record.GetIntegerValue('MARKET_NO');

  m_Symbol := p_Record.GetStringValue('SYMBOL');

  m_PrevPrice := p_Record.GetDoubleValue('PREV_CLOSE');
  m_ClosePrice := p_Record.GetDoubleValue('CLOSE_PRICE');
  m_RealPrice := p_Record.GetDoubleValue('REAL_PRICE');
  if m_RealPrice = 0 then
    m_RealPrice := m_ClosePrice;

  m_ChangePrice := p_Record.GetDoubleValue('CHANGE');
  m_ChangeRate := p_Record.GetDoubleValue('CHANGERATE');
  m_OfferPrice := p_Record.GetDoubleValue('BEST_OFFER_PRICE');
  m_BidPrice := p_Record.GetDoubleValue('BEST_BID_PRICE');

  m_OpenPrice := p_Record.GetDoubleValue('OPEN_PRICE');
  m_HighPrice := p_Record.GetDoubleValue('HIGH_PRICE');
  m_LowPrice := p_Record.GetDoubleValue('LOW_PRICE');

  m_Volume := p_Record.GetDoubleValue('VOLUME');
  m_TotalVolume := p_Record.GetDoubleValue('TOTAL_VOLUME');
  m_TotalPrice := p_Record.GetDoubleValue('TOTAL_VALUE');
end;

// ---------------------------------------------------------------------------
procedure CFNQuotData.OPSArrayToData(p_Record: CFNRecord);
var
  f_Date, f_Time: String;
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin
  f_Date := p_Record.GetStringValue('DATE');
  f_Time := p_Record.GetStringValue('TIME');
  if f_Date = '' then
    f_Date := TFNGlobal.DateTimeToString(Now, 'YYYYMMDD');

  m_DateTime := TFNGlobal.StringToDateTime(f_Date + f_Time);
  DecodeDateTime(m_DateTime, Year, Month, Day, Hour, Min, Sec, MSec);

  m_Year := Year;
  m_Month := Month;
  m_Day := Day;
  m_Hour := Hour;
  m_Min := Min;
  m_Sec := Sec;
  m_MSec := MSec;

  m_Country := p_Record.GetIntegerValue('COUNTRY_NO');
  m_Group := p_Record.GetIntegerValue('GROUP_NO');
  m_Market := p_Record.GetIntegerValue('MARKET_NO');
  m_Symbol := p_Record.GetStringValue('SYMBOL');

  m_OpenPrice := p_Record.GetDoubleValue('OPEN_PRICE');
  m_HighPrice := p_Record.GetDoubleValue('HIGH_PRICE');
  m_LowPrice := p_Record.GetDoubleValue('LOW_PRICE');
  m_ClosePrice := p_Record.GetDoubleValue('CLOSE_PRICE');
  m_OfferPrice := p_Record.GetDoubleValue('BEST_OFFER_PRICE');
  m_BidPrice := p_Record.GetDoubleValue('BEST_BID_PRICE');

  m_OpenOPS := p_Record.GetDoubleValue('OPEN_OPS');
  m_HighOPS := p_Record.GetDoubleValue('HIGH_OPS');
  m_LowOPS := p_Record.GetDoubleValue('LOW_OPS');
  m_CloseOPS := p_Record.GetDoubleValue('CLOSE_OPS');

  m_TotalVolume := p_Record.GetDoubleValue('TOTAL_VOLUME');
end;

// ---------------------------------------------------------------------------
procedure CFNQuotData.OPSStreamDataToData(p_StreamRecord: CFNStreamRecord);
var
  f_Date, f_Time: String;
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin
  f_Date := p_StreamRecord.GetNameToStringValue('DATE');
  f_Time := p_StreamRecord.GetNameToStringValue('TIME');
  if f_Date = '' then
    f_Date := TFNGlobal.DateTimeToString(Now, 'YYYYMMDD');

  m_DateTime := TFNGlobal.StringToDateTime(f_Date + f_Time);
  DecodeDateTime(m_DateTime, Year, Month, Day, Hour, Min, Sec, MSec);

  m_Year := Year;
  m_Month := Month;
  m_Day := Day;
  m_Hour := Hour;
  m_Min := Min;
  m_Sec := Sec;
  m_MSec := MSec;

  m_Country := p_StreamRecord.GetNameToIntegerValue('COUNTRY_NO');
  m_Group := p_StreamRecord.GetNameToIntegerValue('GROUP_NO');
  m_Market := p_StreamRecord.GetNameToIntegerValue('MARKET_NO');
  m_Symbol := p_StreamRecord.GetNameToStringValue('SYMBOL');

  m_OpenPrice := p_StreamRecord.GetNameToDoubleValue('OPEN_PRICE');
  m_HighPrice := p_StreamRecord.GetNameToDoubleValue('HIGH_PRICE');
  m_LowPrice := p_StreamRecord.GetNameToDoubleValue('LOW_PRICE');
  m_ClosePrice := p_StreamRecord.GetNameToDoubleValue('CLOSE_PRICE');

  m_OpenOPS := p_StreamRecord.GetNameToDoubleValue('OPEN_OPS');
  m_HighOPS := p_StreamRecord.GetNameToDoubleValue('HIGH_OPS');
  m_LowOPS := p_StreamRecord.GetNameToDoubleValue('LOW_OPS');
  m_CloseOPS := p_StreamRecord.GetNameToDoubleValue('CLOSE_OPS');
  m_OfferPrice := p_StreamRecord.GetNameToDoubleValue('BEST_OFFER_PRICE');
  m_BidPrice := p_StreamRecord.GetNameToDoubleValue('BEST_BID_PRICE');

  m_TotalVolume := p_StreamRecord.GetNameToDoubleValue('TOTAL_VOLUME');
end;

procedure CFNQuotData.Clone(p_Source: CFNQuotData);
begin
  m_DateTime := p_Source.m_DateTime;

  m_Year := p_Source.m_Year;
  m_Month := p_Source.m_Month;
  m_Day := p_Source.m_Day;
  m_Hour := p_Source.m_Hour;
  m_Min := p_Source.m_Min;
  m_Sec := p_Source.m_Sec;
  m_MSec := p_Source.m_MSec;

  m_Key := p_Source.m_Key;
  m_Symbol := p_Source.m_Symbol;
  m_Name := p_Source.m_Name;

  m_Country := p_Source.m_Country;
  m_Group := p_Source.m_Group;
  m_Market := p_Source.m_Market;

  m_OpenPrice := p_Source.m_OpenPrice;
  m_HighPrice := p_Source.m_HighPrice;
  m_LowPrice := p_Source.m_LowPrice;
  m_ClosePrice := p_Source.m_ClosePrice;

  m_OpenOPS := p_Source.m_OpenOPS;
  m_HighOPS := p_Source.m_HighOPS;
  m_LowOPS := p_Source.m_LowOPS;
  m_CloseOPS := p_Source.m_CloseOPS;

  m_Volume := p_Source.m_Volume;

  m_PrevPrice := p_Source.m_PrevPrice;
  m_ChangeFlag := p_Source.m_ChangeFlag;
  m_ChangePrice := p_Source.m_ChangePrice;
  m_ChangeRate := p_Source.m_ChangeRate;
  m_TotalVolume := p_Source.m_TotalVolume;
  m_TotalPrice := p_Source.m_TotalPrice;

  m_MaxLimit := p_Source.m_MaxLimit;
  m_MinLimit := p_Source.m_MinLimit;

  m_BidPrice := p_Source.m_BidPrice;
  m_OfferPrice := p_Source.m_OfferPrice;
  m_BidVolume := p_Source.m_BidVolume;
  m_OfferVolume := p_Source.m_OfferVolume;

  m_RealPrice := p_Source.m_RealPrice;

  m_Object := p_Source.m_Object;
end;

end.
