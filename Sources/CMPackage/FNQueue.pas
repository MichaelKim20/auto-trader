unit FNQueue;

interface

uses
  Contnrs, SysUtils, StrUtils, Classes, SyncObjs;

type

  CFNQueue = class(TObject)
  private
    m_List: TQueue;
    m_QueueLock: TCriticalSection;
    m_AutoFree: Boolean;

  public
    Constructor Create;
    Destructor Destroy; override;

    procedure Store(AData: Pointer);
    function Retrieve: Pointer;
    procedure ManyRetrieve(var AList: TList; AMaxCount: Integer);
    function Empty: Boolean;
    function GetCount: Integer;
    procedure Clear;
    procedure SetAutoFree(bAutoFree: Boolean);
  end;

implementation

// ---------------------------------------------------------------------------
Constructor CFNQueue.Create;
begin
  inherited Create;

  m_List := TQueue.Create;
  m_QueueLock := TCriticalSection.Create;

  m_AutoFree := TRUE;
end;

// ---------------------------------------------------------------------------
Destructor CFNQueue.Destroy;
begin
  Clear;

  m_List.Free;
  m_QueueLock.Free;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNQueue.Store(AData: Pointer);
begin
  m_QueueLock.Enter;
  try
    if Assigned(AData) then
    begin
      m_List.Push(AData);
    end;
  finally
    m_QueueLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
function CFNQueue.Retrieve: Pointer;
begin
  m_QueueLock.Enter;
  result := NIL;
  try
    if 0 < m_List.Count then
    begin
      result := m_List.Pop;
    end;
  finally
    m_QueueLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNQueue.ManyRetrieve(var AList: TList; AMaxCount: Integer);
var
  nLoop: Integer;
  p: Pointer;
begin
  m_QueueLock.Enter;
  try
    if Assigned(AList) then
    begin
      for nLoop := 0 to AMaxCount - 1 do
      begin
        p := Retrieve;
        if Assigned(p) then
          AList.Add(p)
        else
          break;
      end;
    end;
  finally
    m_QueueLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
function CFNQueue.Empty: Boolean;
begin
  if 0 = m_List.Count then
    result := TRUE
  else
    result := FALSE;
end;

// ---------------------------------------------------------------------------
function CFNQueue.GetCount: Integer;
begin
  result := m_List.Count;
end;
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
procedure CFNQueue.Clear;
var
  p: Pointer;
begin
  m_QueueLock.Enter;
  try
    while 0 < m_List.Count do
    begin
      p := m_List.Pop;
      if (m_AutoFree) and (Assigned(p)) then
        Dispose(p);

    end;
  finally
    m_QueueLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
procedure CFNQueue.SetAutoFree(bAutoFree: Boolean);
begin
  m_AutoFree := bAutoFree;
end;

end.
