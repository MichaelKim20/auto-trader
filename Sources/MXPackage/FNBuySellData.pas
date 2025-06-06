unit FNBuySellData;

interface

uses
    Math, SysUtils, FNDataSet;

type

    CFNBuySellData = class(TObject)
    public
        m_Date		: TDateTime;
        m_Symbol	: String;
        m_MA		: Integer;
        m_DType		: Integer;
        m_Buy		: Boolean;
        m_Sell		: Boolean;
    public
        procedure Clone(p_Source:CFNBuySellData);
        procedure ArrayToData(p_Record:CFNRecord);
    end;

implementation

uses
    FNGlobal;

//---------------------------------------------------------------------------
//복제한다.
procedure CFNBuySellData.Clone(p_Source: CFNBuySellData);
begin
    if Assigned(p_Source) then
    begin
	m_Date:= p_Source.m_Date;
	m_Symbol:= p_Source.m_Symbol;
	m_MA:= p_Source.m_MA;
	m_DType:= p_Source.m_DType;
	m_Buy:= p_Source.m_Buy;
	m_Sell:= p_Source.m_Sell;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNBuySellData.ArrayToData(p_Record:CFNRecord);
var
    f_Year, f_Month, f_Day  :   Integer     ;
    f_DateString            :   String      ;
begin
    f_DateString    := p_Record.GetStringValue('DATE');
    f_Year          :=  TFNGlobal.atoi(Copy(f_DateString, 1, 4));
    f_Month         :=  TFNGlobal.atoi(Copy(f_DateString, 5, 2));
    f_Day           :=  TFNGlobal.atoi(Copy(f_DateString, 7, 2));
    m_Date          := EncodeDate(f_Year, f_Month, f_Day);

	m_Symbol:= p_Record.GetStringValue ('SYMBOL');
	m_MA	:= p_Record.GetIntegerValue('MA');
	m_DType	:= p_Record.GetIntegerValue('DTYPE');
	if p_Record.GetIntegerValue('BUY') = 1 then m_Buy := true else m_Buy := false;
	if p_Record.GetIntegerValue('SELL') = 1 then m_Sell := true else m_Sell := false;
end;

//---------------------------------------------------------------------------

end.