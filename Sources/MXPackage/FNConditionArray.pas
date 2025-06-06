unit FNConditionArray;

interface

uses
  Math, SysUtils, Classes, FNConditionData, IniFiles;

type
  CFNConditionArray = class(TObject)
  public
    m_Items: TList;

  public
    constructor Create;
    destructor Destroy; override;

  public
    // m_Items자료구조 메모리를 해제한다.
    procedure Clear;

    // CFNConditionData를 하나 추가해준다.
    procedure Add(p_ConditionData: CFNConditionData);

    // 파라메터로 전달받은 데이타를 복사해둔다.
    procedure Clone(p_Source: CFNConditionArray);
    procedure ExtractByCount(APCount: Integer; ATarget: CFNConditionArray);
    function ExtractCountValue: THashedStringList;
  end;

implementation

uses
  FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNConditionArray.Create;
begin
  inherited Create;

  m_Items := TList.Create;
end;

// ---------------------------------------------------------------------------
destructor CFNConditionArray.Destroy;
begin
  Clear;

  m_Items.Free;
  m_Items := NIL;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNConditionArray.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNConditionData(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNConditionArray.Add(p_ConditionData: CFNConditionData);
begin
  m_Items.Add(p_ConditionData);
end;

// ---------------------------------------------------------------------------
procedure CFNConditionArray.Clone(p_Source: CFNConditionArray);
var
  f_OldConditionData: CFNConditionData;
  f_NewConditionData: CFNConditionData;
  f_Index: Integer;
begin
  Clear;

  for f_Index := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_OldConditionData := CFNConditionData(p_Source.m_Items.Items[f_Index]);
    f_NewConditionData := CFNConditionData.Create;
    f_NewConditionData.Clone(f_OldConditionData);
    m_Items.Add(f_NewConditionData);
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNConditionArray.ExtractByCount(APCount: Integer; ATarget: CFNConditionArray);
var
  f_OldConditionData: CFNConditionData;
  f_NewConditionData: CFNConditionData;
  f_Index: Integer;
begin
  ATarget.Clear;

  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_OldConditionData := CFNConditionData(m_Items.Items[f_Index]);
    if f_OldConditionData.m_PortfolioCount = APCount then
    begin
      f_NewConditionData := CFNConditionData.Create;
      f_NewConditionData.Clone(f_OldConditionData);
      ATarget.Add(f_NewConditionData);
    end;
  end;
end;

// ---------------------------------------------------------------------------
function CFNConditionArray.ExtractCountValue: THashedStringList;
var
  f_ConditionData: CFNConditionData;
  f_CountList: THashedStringList;
  f_Index: Integer;
  f_Key: String;
  f_ValueIndex: Integer;
begin
  f_CountList := THashedStringList.Create;

  for f_Index := 0 to m_Items.Count - 1 do
  begin
    f_ConditionData := CFNConditionData(m_Items.Items[f_Index]);

    f_Key := IntToStr(f_ConditionData.m_PortfolioCount);

    f_ValueIndex := f_CountList.IndexOf(f_Key);
    if (0 > f_ValueIndex) then
    begin
      f_CountList.AddObject(f_Key, f_ConditionData);
    end;

  end;

  result := f_CountList;
end;

// ---------------------------------------------------------------------------
end.
