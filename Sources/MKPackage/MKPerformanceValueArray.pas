unit MKPerformanceValueArray;

interface

uses
  Math, Windows, SysUtils, Classes;

type

  CMKPerformanceValue = class(TObject)
  public
    m_Name: String;
    m_Value: Double;
    m_Precision: Integer;
    m_Unit: String;
    m_SignColor: Boolean;
  private

  public
    constructor Create();
  end;

  CMKPerformanceValueArray = class(TObject)
  public
    m_Items: TList;
  public
    constructor Create();
    destructor Destroy(); override;
  private

  public
    procedure Clear();
    procedure Add(p_Value: CMKPerformanceValue);
  end;

implementation

// ---------------------------------------------------------------------------
constructor CMKPerformanceValue.Create();
begin
  inherited Create();
  m_Unit := '';
  m_SignColor := false;
end;

// ---------------------------------------------------------------------------
constructor CMKPerformanceValueArray.Create();
begin
  inherited Create();

  m_Items := TList.Create();
end;

// ---------------------------------------------------------------------------
destructor CMKPerformanceValueArray.Destroy();
begin
  Clear();

  m_Items.Free();
  m_Items := NIL;

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
procedure CMKPerformanceValueArray.Clear();
begin
  while 0 < m_Items.Count do
  begin
    CMKPerformanceValue(m_Items.Items[0]).Free();
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
procedure CMKPerformanceValueArray.Add(p_Value: CMKPerformanceValue);
begin
  m_Items.Add(p_Value);
end;

end.
