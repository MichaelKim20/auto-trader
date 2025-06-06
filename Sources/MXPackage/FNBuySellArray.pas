unit FNBuySellArray;

interface
uses
    Math, SysUtils, Classes, FNBuySellData;

const
    ARRAY_TYPE_REAL       =   0;
    ARRAY_TYPE_VIRTUAL    =   1;

type
    ////////////////////////////////////////////////////////////////////////////
    //CFNBuySellData를 배열의 구성요소로 가지고 있는 자료구조이다.
    CFNBuySellArray = class(TObject)
    public
        m_Items     : TList;                        //각 구성요소를 저장하는 배열
        m_Type          :   Integer ;

    public
        constructor Create;
        destructor  Destroy; override;

    private

    public
        //메모리를 해제
        procedure Clear;
        //CFNBuySellData을 m_Items에 추가한다.
        procedure Add(p_BuySellData:CFNBuySellData);
        //country,group,market에 대응하는 데이타의 인덱스를 리턴한다.
        function  Search(p_Date:TDateTime; p_Symbol:String; p_MA, p_DType: Integer) : CFNBuySellData;
        function  SearchDate(p_Date:TDateTime) : Integer;
        procedure Sort;
        //깊은 복사를 해서 복제한다.
        procedure Clone(p_Source:CFNBuySellArray);
        procedure CloneVirtual(p_Source: CFNBuySellArray);


        procedure GetBuySell(p_Date:TDateTime; p_Symbol:String; p_MA, p_DType: Integer; var p_Buy:Boolean; var p_Sell:Boolean);
    end;

implementation
uses
    FNGlobal;

//---------------------------------------------------------------------------
//비교함수이다. 여기서는 국가번호, 그룹번호, 거래소번호순으로 오름차순이다.
function Compare(Item1, Item2: Pointer): Integer;
var
    f_BuySellData1 : CFNBuySellData;
    f_BuySellData2 : CFNBuySellData;
    f_Compare : Integer;
begin
    f_Compare := 0;

    f_BuySellData1 := CFNBuySellData(Item1);
	f_BuySellData2 := CFNBuySellData(Item2);

    if (0 = f_Compare) then
        f_Compare := CompareValue(f_BuySellData1.m_Date, f_BuySellData2.m_Date, 0.1);

    if (0 = f_Compare) then
        f_Compare := CompareText(f_BuySellData1.m_Symbol, f_BuySellData2.m_Symbol);

    if (0 = f_Compare) then
        f_Compare := f_BuySellData1.m_MA - f_BuySellData2.m_MA;

    if (0 = f_Compare) then
        f_Compare := f_BuySellData1.m_DType - f_BuySellData2.m_DType;

    if (0 < f_Compare) then
        Result := 1
    else if (0 > f_Compare) then
        Result := -1
    else
        Result := 0;
end;

//---------------------------------------------------------------------------
constructor CFNBuySellArray.Create;
begin
    inherited Create;
    m_Type := ARRAY_TYPE_REAL;

    m_Items := TList.Create;
end;

//---------------------------------------------------------------------------
//파괴자
destructor CFNBuySellArray.Destroy;
begin
    Clear;

    m_Items.Free;
    m_Items := NIL;

    inherited Destroy;
end;

//---------------------------------------------------------------------------
procedure CFNBuySellArray.GetBuySell(p_Date: TDateTime; p_Symbol: String; p_MA, p_DType: Integer; var p_Buy, p_Sell: Boolean);
var
    f_BuySellData : CFNBuySellData;
begin
    f_BuySellData := Search(p_Date, p_Symbol, p_MA, p_DType);
    if f_BuySellData <> NIL then
    begin
        p_Buy := f_BuySellData.m_Buy;
        p_Sell := f_BuySellData.m_Sell;
    end else
    begin
        p_Buy := true;
        p_Sell := true;
    end;
end;

//---------------------------------------------------------------------------
//배열의 구성요소를 모두 삭제한다.
procedure CFNBuySellArray.Clear;
begin
    while 0 < m_Items.Count  do
    begin
        if (m_Type = ARRAY_TYPE_REAL) then CFNBuySellData(m_Items.Items[0]).Free;
        m_Items.Delete(0);
    end;
end;

//---------------------------------------------------------------------------
//하나를 추가한다.
procedure CFNBuySellArray.Add(p_BuySellData: CFNBuySellData);
begin
    m_Items.Add(p_BuySellData);
end;

//---------------------------------------------------------------------------
//해당값을 가지고 있는 요소를 찾아 그 인덱스를 리턴한다.
function CFNBuySellArray.Search(p_Date:TDateTime; p_Symbol:String; p_MA, p_DType: Integer): CFNBuySellData;
var
    f_BuySellData : CFNBuySellData;
    f_Array : CFNBuySellArray;
    f_Index : Integer;
    f_SearchIndex:Integer;
begin
    f_Array := CFNBuySellArray.Create;
    f_Array.m_Type := ARRAY_TYPE_VIRTUAL;
    try
        for f_Index := 0 to m_Items.Count - 1 do
        begin
            f_BuySellData := CFNBuySellData(m_Items.Items[f_Index]);

            if
                (CompareText(p_Symbol, f_BuySellData.m_Symbol) = 0) and
                (p_MA = f_BuySellData.m_MA) and
                (p_DType = f_BuySellData.m_DType) then
            begin
                f_Array.Add(f_BuySellData);
            end;
        end;

        f_SearchIndex := f_Array.SearchDate(p_Date);
        if f_SearchIndex < 0 then
        begin
            Result := NIL;
        end else
        begin
            Result := f_Array.m_Items[f_SearchIndex];
        end;
    finally
        f_Array.Free;
    end;
end;

function CFNBuySellArray.SearchDate(p_Date: TDateTime): Integer;
var
    f_PosX : Integer;
    f_PosL : Integer;
    f_PosR : Integer;
    f_RecordCount : Integer;
    f_Compare : Double;
    f_BuySellData : CFNBuySellData;
begin
    f_RecordCount := m_Items.Count;
    if 0 < f_RecordCount then
    begin
        f_PosL := 0;
        f_PosR := f_RecordCount - 1;

        repeat
            f_PosX := Math.floor((f_PosL + f_PosR) / 2);
            f_BuySellData := CFNBuySellData(m_Items.Items[f_PosX]);

            f_Compare := p_Date - f_BuySellData.m_Date;

            if (0 > f_Compare) then
            begin
                f_PosR := f_PosX - 1
            end else
            begin
                f_PosL := f_PosX + 1;
            end;
        until (not ((f_Compare <> 0) and (f_PosL <= f_PosR)));

        if (0 = f_Compare) then
        begin
            Result := f_PosX-1;
        end else
        if (f_PosL >= f_RecordCount) then
        begin
            Result := f_RecordCount-1;
        end else
        begin
            Result := f_PosL-1;
        end;

        if Result < 0 then Result := -1;


    end else
    begin
        Result := -1;
    end;

end;

//---------------------------------------------------------------------------
//비교함수를 이용하여 정렬한다.
procedure CFNBuySellArray.Sort;
begin
    m_Items.Sort(@Compare);
end;

//---------------------------------------------------------------------------
//배열의 모든 객체를 새로 생성하여 복제한다.
procedure CFNBuySellArray.Clone(p_Source: CFNBuySellArray);
var
    f_OldBuySellData    : CFNBuySellData;
    f_NewBuySellData    : CFNBuySellData;
    f_Index         : Integer;
begin
    Clear;

    m_Type := Array_TYPE_REAL;
    for f_Index := 0 to p_Source.m_Items.Count - 1 do
    begin
        f_OldBuySellData := CFNBuySellData(p_Source.m_Items.Items[f_Index]);
        f_NewBuySellData := CFNBuySellData.Create;
        f_NewBuySellData.Clone(f_OldBuySellData);
        m_Items.Add(f_NewBuySellData);
    end;
end;

//---------------------------------------------------------------------------
//배열의 모든 객체를 새로 생성하지 않고 참조 포인터만 전달하여 복제한다.
//이것은 정렬의 인덱스로 사용하기 위함이다.
procedure CFNBuySellArray.CloneVirtual(p_Source:CFNBuySellArray);
var
    f_OldBuySellData    : CFNBuySellData;
    f_Index         : Integer;
begin
    Clear;

    m_Type := Array_TYPE_VIRTUAL;
    for f_Index := 0 to p_Source.m_Items.Count - 1 do
    begin
        f_OldBuySellData := CFNBuySellData(p_Source.m_Items.Items[f_Index]);
        m_Items.Add(f_OldBuySellData);
    end;
end;

end.
