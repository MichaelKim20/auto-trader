unit FNThread;

interface

uses
  Classes;

type
  CFNThread = class(TThread)
  protected
    m_Stop: Boolean;
    m_SleepTime: LongWord;
    m_Finished: Boolean;
    m_Working: Boolean;
    m_ThreadIndex: Integer;

    procedure StartWork; virtual;
    procedure DoWork; virtual;
    procedure EndWork; virtual;
    procedure Execute; override;

  public
    Constructor Create;
    Destructor Destroy; override;

    procedure StopThread;
    procedure ExitThread;

    function GetSleepTime: LongWord;
    procedure SetSleepTime(AValue: LongWord);

    function GetFinished: Boolean;
    procedure SetFinished(AValue: Boolean);

    function GetThreadIndex: Integer;
    procedure SetThreadIndex(AValue: Integer);

    function GetWorking: Boolean;
    procedure SetWorking(AValue: Boolean);
  end;

implementation

uses SysUtils, ActiveX, WinProcs, FNGlobal;

Constructor CFNThread.Create;
begin
  inherited Create(TRUE);

  m_ThreadIndex := 0;
  m_SleepTime := 0;
  m_Finished := TRUE;
  m_Working := FALSE;
  m_Stop := FALSE;
  FreeOnTerminate := FALSE;
end;

// ---------------------------------------------------------------------------
Destructor CFNThread.Destroy;
begin
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNThread.Execute;
begin
  m_Finished := FALSE;
  StartWork;

  while (not m_Stop) do
  begin
    try
      DoWork;
      m_Working := FALSE;
      Sleep(m_SleepTime);
    except
      m_Working := FALSE;

    end;
  end;

  EndWork;
  m_Finished := TRUE;
end;

// ---------------------------------------------------------------------------
procedure CFNThread.StartWork;
begin
  CoInitialize(NIL);
end;

// ---------------------------------------------------------------------------
procedure CFNThread.DoWork;
begin
  m_Working := TRUE;
end;

// ---------------------------------------------------------------------------
procedure CFNThread.EndWork;
begin
  CoUninitialize;
end;

// ---------------------------------------------------------------------------
procedure CFNThread.StopThread;
begin
  m_Stop := TRUE;
end;

// ---------------------------------------------------------------------------
procedure CFNThread.ExitThread;
begin
  TerminateThread(ThreadID, 0);
end;

// ---------------------------------------------------------------------------
function CFNThread.GetSleepTime: LongWord;
begin
  Result := m_SleepTime;
end;

// ---------------------------------------------------------------------------
procedure CFNThread.SetSleepTime(AValue: LongWord);
begin
  m_SleepTime := AValue;
end;

// ---------------------------------------------------------------------------
function CFNThread.GetFinished: Boolean;
begin
  Result := m_Finished;
end;

// ---------------------------------------------------------------------------
procedure CFNThread.SetFinished(AValue: Boolean);
begin
  m_Finished := AValue;
end;

// ---------------------------------------------------------------------------
function CFNThread.GetThreadIndex: Integer;
begin
  Result := m_ThreadIndex;
end;

// ---------------------------------------------------------------------------
procedure CFNThread.SetThreadIndex(AValue: Integer);
begin
  m_ThreadIndex := AValue;
end;

// ---------------------------------------------------------------------------
function CFNThread.GetWorking: Boolean;
begin
  Result := m_Working;
end;

// ---------------------------------------------------------------------------
procedure CFNThread.SetWorking(AValue: Boolean);
begin
  m_Working := AValue;
end;

// ---------------------------------------------------------------------------
end.
