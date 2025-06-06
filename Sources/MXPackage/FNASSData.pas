unit FNASSData;

interface

uses
    Math, SysUtils, FNDataSet;

type

    CFNASSData = class(TObject)
    public
        m_SEQUENCE              :   Integer;
        m_DAYCOUNT1             :   Integer;
        m_DAYCOUNT2             :   Integer;
        m_DAYCOUNT3             :   Integer;
        m_RANK                  :   Integer;
        m_NEXTCONDITION         :   String;
        m_NET_PROFIT            :   Double;
        m_PERCENT_PROFITABLE    :   Double;
        m_SUCCESS_RATE          :   Double;
        m_PROFIT_FACTOR         :   Double;
        m_MAXDRAWDOWN           :   Double;
        m_TYPE                  :   Integer;
    public
        procedure Clone(p_Source:CFNASSData);
        procedure ArrayToData(p_Record:CFNRecord);
    end;

implementation

uses
    FNGlobal;

//---------------------------------------------------------------------------
//복제한다.
procedure CFNASSData.Clone(p_Source: CFNASSData);
begin
    if Assigned(p_Source) then
    begin
	m_SEQUENCE:= p_Source.m_SEQUENCE;
	m_DAYCOUNT1:= p_Source.m_DAYCOUNT1;
	m_DAYCOUNT2:= p_Source.m_DAYCOUNT2;
	m_DAYCOUNT3:= p_Source.m_DAYCOUNT3;
	m_RANK:= p_Source.m_RANK;
	m_NEXTCONDITION:= p_Source.m_NEXTCONDITION;
	m_NET_PROFIT:= p_Source.m_NET_PROFIT;
	m_PERCENT_PROFITABLE:= p_Source.m_PERCENT_PROFITABLE;
	m_SUCCESS_RATE:= p_Source.m_SUCCESS_RATE;
	m_PROFIT_FACTOR:= p_Source.m_PROFIT_FACTOR;
	m_MAXDRAWDOWN:= p_Source.m_MAXDRAWDOWN;
    m_TYPE:= p_Source.m_TYPE;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNASSData.ArrayToData(p_Record:CFNRecord);
begin
    m_SEQUENCE := p_Record.GetIntegerValue('SEQUENCE');
	m_DAYCOUNT1:= p_Record.GetIntegerValue ('DAYCOUNT1');
	m_DAYCOUNT2:= p_Record.GetIntegerValue('DAYCOUNT2');
	m_DAYCOUNT3:= p_Record.GetIntegerValue('DAYCOUNT3');
	m_RANK:= p_Record.GetIntegerValue('RANK');
	m_NEXTCONDITION:= p_Record.GetStringValue('NEXTCONDITION');
	m_NET_PROFIT:= p_Record.GetDoubleValue('NET_PROFIT');
	m_PERCENT_PROFITABLE:= p_Record.GetDoubleValue('PERCENT_PROFITABLE');
	m_SUCCESS_RATE:= p_Record.GetDoubleValue('SUCCESS_RATE');
	m_PROFIT_FACTOR:= p_Record.GetDoubleValue('PROFIT_FACTOR');
	m_MAXDRAWDOWN:= p_Record.GetDoubleValue('MAXDRAWDOWN');
	m_TYPE:= p_Record.GetIntegerValue('TYPE');
end;

//---------------------------------------------------------------------------

end.