unit FNMessageManager;

interface

uses
  Math, SysUtils, Classes, ExtCtrls,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.SyncObjs,
  VCL.Dialogs;

type

  // --------------------------------------------------------------------------
  TFNMessageData = class(TObject)
  private
    FTitle: String;
    FText: String;

  public
    constructor Create;

    property Title: String read FTitle write FTitle;
    property Text: String read FText write FText;
  end;

  /// /////////////////////////////////////////////////////////////////////////
  // CFNSymbolItem를 배열의 구성요소로 가지고 있는 자료구조이다.
  /// /////////////////////////////////////////////////////////////////////////
  CFNMessageManager = class(TObject)
  private
    FListLock: TCriticalSection;
    FMessageList: TObjectList<TFNMessageData>;
    FTimer: TTimer;

    function GetCount: Integer;

    procedure OnTimer(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;

  public
    procedure AddMessageData(AMessageData: TFNMessageData);
    procedure AddMessage(AMessage: String);
    procedure RemoveAll;

    property MessageList: TObjectList<TFNMessageData> read FMessageList write FMessageList;
    property Count: Integer read GetCount;
  end;

implementation

uses
  FNGlobal;

// --------------------------------------------------------------------------
constructor TFNMessageData.Create;
begin
  FTitle := '';
  FText := '';
end;

// ---------------------------------------------------------------------------
constructor CFNMessageManager.Create;
begin
  inherited Create;

  FMessageList := TObjectList<TFNMessageData>.Create;
  FListLock := TCriticalSection.Create;
  FTimer := TTimer.Create(NIL);
  FTimer.Enabled := true;
  FTimer.OnTimer := OnTimer;
  FTimer.Interval := 100;
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CFNMessageManager.Destroy;
begin

  if Assigned(FTimer) then
  begin
    FTimer.Enabled := false;
    FreeAndNil(FTimer);
  end;
  if Assigned(FMessageList) then
    FreeAndNil(FMessageList);

  if Assigned(FListLock) then
    FreeAndNil(FListLock);

  inherited Destroy;
end;

function CFNMessageManager.GetCount: Integer;
begin
    Result := FMessageList.Count;
end;

// --------------------------------------------------------------------------
procedure CFNMessageManager.RemoveAll;
begin
  FListLock.Enter;
  try
    FMessageList.Clear;
  finally
    FListLock.Leave;
  end;
end;

// --------------------------------------------------------------------------
procedure CFNMessageManager.AddMessageData(AMessageData: TFNMessageData);
begin
  FListLock.Enter;
  try
    FMessageList.Add(AMessageData);
  finally
    FListLock.Leave;
  end;
end;
// --------------------------------------------------------------------------
procedure CFNMessageManager.AddMessage(AMessage: String);
var
  LMessageData: TFNMessageData;
begin
  FListLock.Enter;
  try
    LMessageData:= TFNMessageData.Create;
    LMessageData.Text := AMessage;
    FMessageList.Add(LMessageData);
  finally
    FListLock.Leave;
  end;
end;

procedure CFNMessageManager.OnTimer(Sender: TObject);
var
  LMessageText: String;
begin
  FTimer.Enabled := false;
  FListLock.Enter;
  try
    if (FMessageList.Count > 0) then
    begin
      LMessageText := FMessageList.Items[0].Text;
      FMessageList.Delete(0);
      ShowMessage(LMessageText);
    end;
  finally
    FListLock.Leave;
    FTimer.Enabled := true;
  end;
end;
end.
