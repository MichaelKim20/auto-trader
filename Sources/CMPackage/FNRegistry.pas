unit FNRegistry;

interface

uses
  Registry, Classes;

type
  CFNRegistry = class(TComponent)
  private
    m_Reg: TRegistry;
    m_CompanyName: String;
    m_ApplicationName: String;
  protected

  public
    Constructor Create(AOWner: TComponent); override;
    Destructor Destroy; override;

    // 스트링값을 레지스트리에서 읽어/ 써넣는다.
    function ReadString(Section, Entry, DefaultValue: String): String;
    procedure WriteString(Section, Entry, Value: String);

    // 정수값을 레지스트리에서 읽어 / 써넣는다.
    function ReadInteger(Section, Entry: String; DefaultValue: Integer): Integer;
    procedure WriteInteger(Section, Entry: String; Value: Integer);

    // 블린값을 레지스트리에서 읽어 / 써넣는다.
    function ReadBool(Section, Entry: String; DefaultValue: Boolean): Boolean;
    procedure WriteBool(Section, Entry: String; Value: Boolean);

    // 프로그램이 위치한 폴더 주소를 스트링값에 담아온다.
    function GetProgramFolder: String;

  published
    property Company: String read m_CompanyName write m_CompanyName;
    property ApplicationName: String read m_ApplicationName write m_ApplicationName;

  end;

implementation

uses
  WinTypes, SysUtils, Forms;

Constructor CFNRegistry.Create(AOWner: TComponent);
begin
  inherited Create(AOWner);
  m_Reg := TRegistry.Create;
  m_Reg.RootKey := HKEY_CURRENT_USER;

  m_CompanyName := 'Company';
  m_ApplicationName := 'ApplicationName';
end;

// ---------------------------------------------------------------------------
Destructor CFNRegistry.Destroy;
begin
  m_Reg.Free;
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
function CFNRegistry.ReadString(Section, Entry, DefaultValue: String): String;
var
  openkey: String;
begin
  openkey := 'SOFTWARE\' + m_CompanyName + '\' + m_ApplicationName + '\' + Section;
  try
    m_Reg.openkey(openkey, TRUE);
    result := m_Reg.ReadString(Entry);
    m_Reg.CloseKey;
  except
    result := DefaultValue;
    m_Reg.CloseKey;
  end;
  if result = '' then
    result := DefaultValue;
end;

// ---------------------------------------------------------------------------
procedure CFNRegistry.WriteString(Section, Entry, Value: String);
var
  openkey: String;
begin
  openkey := 'SOFTWARE\' + m_CompanyName + '\' + m_ApplicationName + '\' + Section;
  try
    m_Reg.openkey(openkey, TRUE);
    m_Reg.WriteString(Entry, Value);
    m_Reg.CloseKey;
  except
    m_Reg.CloseKey;
  end;
end;

// ---------------------------------------------------------------------------
function CFNRegistry.ReadInteger(Section, Entry: String; DefaultValue: Integer): Integer;
var
  openkey: String;
begin
  openkey := 'SOFTWARE\' + m_CompanyName + '\' + m_ApplicationName + '\' + Section;
  try
    m_Reg.openkey(openkey, TRUE);
    result := m_Reg.ReadInteger(Entry);
    m_Reg.CloseKey;
  except
    result := DefaultValue;
    m_Reg.CloseKey;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNRegistry.WriteInteger(Section, Entry: String; Value: Integer);
var
  openkey: String;
begin
  openkey := 'SOFTWARE\' + m_CompanyName + '\' + m_ApplicationName + '\' + Section;
  try
    m_Reg.openkey(openkey, TRUE);
    m_Reg.WriteInteger(Entry, Value);
    m_Reg.CloseKey;
  except
    m_Reg.CloseKey;
  end;
end;

// ---------------------------------------------------------------------------
function CFNRegistry.ReadBool(Section, Entry: String; DefaultValue: Boolean): Boolean;
var
  openkey: String;
begin
  openkey := 'SOFTWARE\' + m_CompanyName + '\' + m_ApplicationName + '\' + Section;
  try
    m_Reg.openkey(openkey, TRUE);
    result := m_Reg.ReadBool(Entry);
    m_Reg.CloseKey;
  except
    result := DefaultValue;
    m_Reg.CloseKey;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNRegistry.WriteBool(Section, Entry: String; Value: Boolean);
var
  openkey: String;
begin
  openkey := 'SOFTWARE\' + m_CompanyName + '\' + m_ApplicationName + '\' + Section;
  try
    m_Reg.openkey(openkey, TRUE);
    m_Reg.WriteBool(Entry, Value);
    m_Reg.CloseKey;
  except
    m_Reg.CloseKey;
  end;
end;

// ---------------------------------------------------------------------------
function CFNRegistry.GetProgramFolder: String;
var
  Areg: TRegistry;
  ProgramPath: String;
begin
  Areg := TRegistry.Create;
  try
    with Areg do
    begin
      RootKey := HKEY_LOCAL_MACHINE;
      openkey('Software\Microsoft\Windows\CurrentVersion', false);
      ProgramPath := ReadString('ProgramFilesDir');
      CloseKey;
    end;
  except
    ProgramPath := '';
    m_Reg.CloseKey;
  end;
  if ProgramPath <> '' then
    result := ProgramPath + '\'
  else
    result := 'C:\Program Files\';
  Areg.Free;
end;
// ---------------------------------------------------------------------------

end.
