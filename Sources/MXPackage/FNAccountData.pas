unit FNAccountData;

interface

uses
  Math, SysUtils,
  FNDataSet;

type
  CFNAccountData = class(TObject)
  public
    m_AccountNo: String;
    m_AccountPw: String;
    m_AccountName: String;
    m_Serial: String;
    m_Code: String;
    m_AccountNoDisplay: String;
    m_Sequence: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clone(p_Source: CFNAccountData);
    procedure ArrayToData(p_Record: CFNRecord);
  end;

implementation

uses
  FNGlobal;

// ---------------------------------------------------------------------------
constructor CFNAccountData.Create;
begin
  inherited Create;

  m_Sequence := 0;
end;

// ---------------------------------------------------------------------------
destructor CFNAccountData.Destroy;
begin

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 복제한다.
procedure CFNAccountData.Clone(p_Source: CFNAccountData);
begin
  if Assigned(p_Source) then
  begin
    m_AccountNo := p_Source.m_AccountNo;
    m_AccountPw := p_Source.m_AccountPw;
    m_AccountName := p_Source.m_AccountName;
    m_Serial := p_Source.m_Serial;
    m_Code := p_Source.m_Code;
    m_AccountNoDisplay := p_Source.m_AccountNoDisplay;
    m_Sequence := p_Source.m_Sequence;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNAccountData.ArrayToData(p_Record: CFNRecord);
begin
  m_AccountNo := p_Record.GetStringValue('ACCOUNT_NO');
  m_AccountName := p_Record.GetStringValue('ACCOUNT_NAME');
  m_Serial := p_Record.GetStringValue('SERIAL_NO');
  m_Code := p_Record.GetStringValue('CODE');
  m_Sequence := 0;

  if Length(m_AccountNo) >= 11 then
  begin
    if Copy(m_AccountNo, 1, 1) = '0' then
    begin
      m_AccountNoDisplay := Copy(m_AccountNo, 1, 3) + '-' + Copy(m_AccountNo, 4, 2) + '-' + Copy(m_AccountNo, 6, 6)
    end
    else
    begin
      m_AccountNoDisplay := Copy(m_AccountNo, 1, 4) + '-' + Copy(m_AccountNo, 5, 6) + '-' + Copy(m_AccountNo, 10, 2)
    end;
  end
  else
  begin
    m_AccountNoDisplay := m_AccountNo;
  end;
end;

end.
