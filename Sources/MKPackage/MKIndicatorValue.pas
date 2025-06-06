unit MKIndicatorValue;

interface

uses
  SysUtils;

type
  CMKIndicatorValue = class(TObject)
  public
    m_Name: String;
    m_Value: Integer;

    m_AddType: Integer;
    m_OptionCount: Integer;
    m_OptionLabel: Array of String;
    m_OptionMaximum: Array of Double;
    m_OptionMinimum: Array of Double;
    m_OptionStepSize: Array of Double;
    m_OptionValue: Array of Double;
    m_OptionFactor: Array of Integer;
    m_OptionDefaultValue: Array of Double;
    m_ViewIndicator: Boolean;
    m_Precision: Integer;

  public
    constructor Create();
    destructor Destroy(); override;

    procedure Initialize();
    procedure Finalize();
    procedure SetDefaultValue();
    procedure SetOptionCount(f_Count: Integer);

  end;

implementation

uses
  MKGlobal;

// ---------------------------------------------------------------------------
constructor CMKIndicatorValue.Create();
begin
  inherited Create();

  m_AddType := 1;
  m_Precision := 0;
  Initialize();
end;

// ---------------------------------------------------------------------------
destructor CMKIndicatorValue.Destroy();
begin
  Finalize();

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
procedure CMKIndicatorValue.Initialize;
begin
  m_OptionCount := 0;
  m_OptionLabel := NIL;
  m_OptionMaximum := NIL;
  m_OptionMinimum := NIL;
  m_OptionStepSize := NIL;
  m_OptionValue := NIL;
  m_OptionFactor := NIL;
  m_OptionDefaultValue := NIL;
end;

// ---------------------------------------------------------------------------
procedure CMKIndicatorValue.Finalize();
begin
  m_OptionLabel := NIL;
  m_OptionMaximum := NIL;
  m_OptionMinimum := NIL;
  m_OptionStepSize := NIL;
  m_OptionDefaultValue := NIL;
  m_OptionValue := NIL;
  m_OptionFactor := NIL;
end;

// ---------------------------------------------------------------------------
// 사용자 설정값을 기본값으로 설정하는 함수
procedure CMKIndicatorValue.SetDefaultValue();
var
  f_Index: Integer;
begin
  for f_Index := 0 to m_OptionCount - 1 do
  begin
    m_OptionValue[f_Index] := m_OptionDefaultValue[f_Index];
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKIndicatorValue.SetOptionCount(f_Count: Integer);
begin
  m_OptionCount := f_Count;

  SetLength(m_OptionLabel, m_OptionCount);
  SetLength(m_OptionMaximum, m_OptionCount);
  SetLength(m_OptionMinimum, m_OptionCount);
  SetLength(m_OptionStepSize, m_OptionCount);
  SetLength(m_OptionValue, m_OptionCount);
  SetLength(m_OptionFactor, m_OptionCount);
  SetLength(m_OptionDefaultValue, m_OptionCount);

end;

end.
