unit FNVPSummaryArray;

interface

uses
  Math, Windows, SysUtils, Classes, FNVPSummaryData;

type
  CFNVPSummaryArray = class(TObject)
  public
    m_MaxDayCount: Integer;
    m_Items: TList; // 실제 데이터가 들어 있는 자료구조
    m_Direction: Integer;

    constructor Create();
    destructor Destroy(); override;

  public
    procedure Clear();
    procedure Clone(p_Source: CFNVPSummaryArray);
    procedure Add(p_SummaryData: CFNVPSummaryData);
    procedure Initialize(p_Direction: Integer);
  end;

implementation

uses
  FNGlobal, Graphics;

// ---------------------------------------------------------------------------
constructor CFNVPSummaryArray.Create();
begin
  inherited Create();

  m_Items := TList.Create();

  m_MaxDayCount := 120;
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CFNVPSummaryArray.Destroy();
begin
  Clear();

  m_Items.Free();
  m_Items := NIL;

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
procedure CFNVPSummaryArray.Initialize(p_Direction: Integer);
var
  f_VPSummaryData: CFNVPSummaryData;
  f_Index: Integer;
  f_Days: Array [0 .. 5] of Integer;
  f_Clor: Array [0 .. 5] of TColor;
begin
  Clear();
  m_Direction := p_Direction;
  if m_Direction = 0 then
  begin
    m_MaxDayCount := 120;
    f_Days[0] := 100;
    f_Days[1] := 60;
    f_Days[2] := 30;
    f_Days[3] := 20;
    f_Days[4] := 10;
    f_Days[5] := 5;

    f_Clor[0] := RGB($FF, $FF, $40);
    f_Clor[1] := RGB($FF, $FF, $A0);
    f_Clor[2] := RGB($FF, $A0, $40);
    f_Clor[3] := RGB($FF, $40, $A0);
    f_Clor[4] := RGB($FF, $A0, $A0);
    f_Clor[5] := RGB($FF, $40, $40);

    for f_Index := 0 to 5 do
    begin
      f_VPSummaryData := CFNVPSummaryData.Create;
      f_VPSummaryData.m_Enable := true;
      f_VPSummaryData.m_DayIndex := f_Days[f_Index];
      f_VPSummaryData.m_Direction := m_Direction;
      f_VPSummaryData.m_Color := f_Clor[f_Index];
      m_Items.Add(f_VPSummaryData);
    end;
  end
  else
  begin
    m_MaxDayCount := 120;

    f_Days[0] := 5;
    f_Days[1] := 10;
    f_Days[2] := 20;
    f_Days[3] := 30;
    f_Days[4] := 60;
    f_Days[5] := 100;

    f_Clor[5] := RGB($40, $FF, $FF);
    f_Clor[4] := RGB($A0, $FF, $FF);
    f_Clor[3] := RGB($A0, $40, $FF);
    f_Clor[2] := RGB($40, $A0, $FF);
    f_Clor[1] := RGB($A0, $A0, $FF);
    f_Clor[0] := RGB($40, $40, $FF);

    for f_Index := 0 to 5 do
    begin
      f_VPSummaryData := CFNVPSummaryData.Create;
      f_VPSummaryData.m_Enable := true;
      f_VPSummaryData.m_DayIndex := f_Days[f_Index];
      f_VPSummaryData.m_Direction := m_Direction;
      f_VPSummaryData.m_Color := f_Clor[f_Index];
      m_Items.Add(f_VPSummaryData);
    end;
  end;
end;

// ---------------------------------------------------------------------------
// 배열의 모든 객체를 새로 생성하여 복제한다.
procedure CFNVPSummaryArray.Add(p_SummaryData: CFNVPSummaryData);
begin
  m_Items.Add(p_SummaryData);
end;

procedure CFNVPSummaryArray.Clear;
begin
  while 0 < m_Items.Count do
  begin
    CFNVPSummaryData(m_Items.Items[0]).Free();
    m_Items.Delete(0);
  end;
end;

procedure CFNVPSummaryArray.Clone(p_Source: CFNVPSummaryArray);
var
  f_OldData: CFNVPSummaryData;
  f_NewData: CFNVPSummaryData;
  f_Index: Integer;
begin
  Clear();
  for f_Index := 0 to p_Source.m_Items.Count - 1 do
  begin
    f_OldData := p_Source.m_Items[f_Index];
    f_NewData := CFNVPSummaryData.Create();
    f_NewData.Clone(f_OldData);
    m_Items.Add(f_OldData);
  end;
end;

end.
