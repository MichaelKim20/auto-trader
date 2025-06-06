unit FNASSArray;

interface
uses
    Math, SysUtils, Classes, FNASSData;

const
    ARRAY_TYPE_REAL       =   0;
    ARRAY_TYPE_VIRTUAL    =   1;

type
    ////////////////////////////////////////////////////////////////////////////
    //CFNASSData를 배열의 구성요소로 가지고 있는 자료구조이다.
    CFNASSArray = class(TObject)
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
        //CFNASSData을 m_Items에 추가한다.
        procedure Add(p_ASSData:CFNASSData);

        procedure Clone(p_Source:CFNASSArray);
        procedure CloneVirtual(p_Source: CFNASSArray);

    end;

implementation
uses
    FNGlobal;

//---------------------------------------------------------------------------
constructor CFNASSArray.Create;
begin
    inherited Create;
    m_Type := ARRAY_TYPE_REAL;

    m_Items := TList.Create;
end;

//---------------------------------------------------------------------------
//파괴자
destructor CFNASSArray.Destroy;
begin
    Clear;

    m_Items.Free;
    m_Items := NIL;

    inherited Destroy;
end;

//---------------------------------------------------------------------------
//배열의 구성요소를 모두 삭제한다.
procedure CFNASSArray.Clear;
begin
    while 0 < m_Items.Count  do
    begin
        if (m_Type = ARRAY_TYPE_REAL) then CFNASSData(m_Items.Items[0]).Free;
        m_Items.Delete(0);
    end;
end;

//---------------------------------------------------------------------------
//하나를 추가한다.
procedure CFNASSArray.Add(p_ASSData: CFNASSData);
begin
    m_Items.Add(p_ASSData);
end;

//---------------------------------------------------------------------------
//배열의 모든 객체를 새로 생성하여 복제한다.
procedure CFNASSArray.Clone(p_Source: CFNASSArray);
var
    f_OldASSData    : CFNASSData;
    f_NewASSData    : CFNASSData;
    f_Index         : Integer;
begin
    Clear;

    m_Type := Array_TYPE_REAL;
    for f_Index := 0 to p_Source.m_Items.Count - 1 do
    begin
        f_OldASSData := CFNASSData(p_Source.m_Items.Items[f_Index]);
        f_NewASSData := CFNASSData.Create;
        f_NewASSData.Clone(f_OldASSData);
        m_Items.Add(f_NewASSData);
    end;
end;

//---------------------------------------------------------------------------
//배열의 모든 객체를 새로 생성하지 않고 참조 포인터만 전달하여 복제한다.
//이것은 정렬의 인덱스로 사용하기 위함이다.
procedure CFNASSArray.CloneVirtual(p_Source:CFNASSArray);
var
    f_OldASSData    : CFNASSData;
    f_Index         : Integer;
begin
    Clear;

    m_Type := Array_TYPE_VIRTUAL;
    for f_Index := 0 to p_Source.m_Items.Count - 1 do
    begin
        f_OldASSData := CFNASSData(p_Source.m_Items.Items[f_Index]);
        m_Items.Add(f_OldASSData);
    end;
end;

end.
