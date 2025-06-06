unit FNLoadController;

interface

uses Contnrs;

type
  CFNLoadController = class;

  // -----------------------------------------------------------------------------
  CFNLoadItem = class(TObject)

  private
    function GetController: CFNLoadController;
    procedure SetController(AValue: CFNLoadController);

  protected
    m_Controller: CFNLoadController;
    m_Failed: Boolean;
    m_IsComplete: Boolean;
    m_Message: String;
    m_WorkName: String;
    m_StopOnFault: Boolean;

    procedure OnLoadStart;
    procedure OnLoadComplete;
    procedure OnLoadFault;
    procedure OnLoadMessage;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Load; virtual;

    property Controller: CFNLoadController read GetController write SetController;
    property Failed: Boolean read m_Failed write m_Failed;
    property Completed: Boolean read m_IsComplete write m_IsComplete;
    property ResultMessage: String read m_Message write m_Message;
    property WorkName: String read m_WorkName write m_WorkName;
    property StopOnFault: Boolean read m_StopOnFault write m_StopOnFault;
  end;

  TFNLoadControllerEvent = Procedure(p_Item: CFNLoadItem) of Object;

  // -----------------------------------------------------------------------------
  CFNLoadController = class(TObject)
  private
    m_Items: TObjectList;
    m_Position: Integer;
    m_IsComplete: Boolean;
    m_IsError: Boolean;

    m_OnItemLoadStartedEvent: TFNLoadControllerEvent;
    m_OnItemLoadCompleteEvent: TFNLoadControllerEvent;
    m_OnItemLoadFaultEvent: TFNLoadControllerEvent;
    m_OnItemLoadMessageEvent: TFNLoadControllerEvent;

    m_OnStartEvent: TFNLoadControllerEvent;
    m_OnCompleteEvent: TFNLoadControllerEvent;
    m_OnFaultEvent: TFNLoadControllerEvent;

    function GetItemCount: Integer;
    procedure Process;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Load;

    function AddItem(p_Item: CFNLoadItem): CFNLoadController;
    procedure Clear;
    function HasNext(): Boolean;

    procedure ItemLoadStarted(p_Item: CFNLoadItem);
    procedure ItemLoadComplete(p_Item: CFNLoadItem);
    procedure ItemLoadFault(p_Item: CFNLoadItem);
    procedure ItemLoadMessage(p_Item: CFNLoadItem);
    procedure Complete;
    procedure Fault;

    property Count: Integer read GetItemCount;

    property OnItemLoadStartedEvent: TFNLoadControllerEvent read m_OnItemLoadStartedEvent write m_OnItemLoadStartedEvent;
    property OnItemLoadCompleteEvent: TFNLoadControllerEvent read m_OnItemLoadCompleteEvent write m_OnItemLoadCompleteEvent;
    property OnItemLoadFaultEvent: TFNLoadControllerEvent read m_OnItemLoadFaultEvent write m_OnItemLoadFaultEvent;
    property OnItemLoadMessageEvent: TFNLoadControllerEvent read m_OnItemLoadMessageEvent write m_OnItemLoadMessageEvent;
    property OnStartEvent: TFNLoadControllerEvent read m_OnStartEvent write m_OnStartEvent;
    property OnCompleteEvent: TFNLoadControllerEvent read m_OnCompleteEvent write m_OnCompleteEvent;
    property OnFaultEvent: TFNLoadControllerEvent read m_OnFaultEvent write m_OnFaultEvent;
  end;

implementation

{ CFNLoadItem }

// -----------------------------------------------------------------------------
constructor CFNLoadItem.Create;
begin
  m_Failed := false;
  m_IsComplete := false;
  m_Message := '';
  m_WorkName := '';
  m_StopOnFault := true;
end;

// -----------------------------------------------------------------------------
destructor CFNLoadItem.Destroy;
begin

  inherited;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem.Load;
begin

end;

// -----------------------------------------------------------------------------
function CFNLoadItem.GetController: CFNLoadController;
begin
  Result := m_Controller;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem.SetController(AValue: CFNLoadController);
begin
  m_Controller := AValue;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem.OnLoadStart;
begin
  if Assigned(m_Controller) then
    m_Controller.ItemLoadStarted(Self);
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem.OnLoadComplete;
begin
  if Assigned(m_Controller) then
    m_Controller.ItemLoadComplete(Self);
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem.OnLoadFault;
begin
  if Assigned(m_Controller) then
    m_Controller.ItemLoadFault(Self);
end;

// -----------------------------------------------------------------------------
procedure CFNLoadItem.OnLoadMessage;
begin
  if Assigned(m_Controller) then
    m_Controller.ItemLoadMessage(Self);
end;

{ CFNLoadController }

// -----------------------------------------------------------------------------
constructor CFNLoadController.Create;
begin
  m_Items := TObjectList.Create;
  m_Position := -1;
  m_IsComplete := true;
  m_IsError := false;
end;

// -----------------------------------------------------------------------------
destructor CFNLoadController.Destroy;
begin
  Clear;
  m_Items.Free;
  inherited;
end;

// -----------------------------------------------------------------------------
function CFNLoadController.AddItem(p_Item: CFNLoadItem): CFNLoadController;
begin
  p_Item.Controller := Self;
  m_Items.Add(p_Item);
end;

// -----------------------------------------------------------------------------
procedure CFNLoadController.Clear;
begin
  while 0 < m_Items.Count do
  begin
    // CFNLoadItem(m_Items.Items[0]).Free;
    m_Items.Delete(0);
  end;
end;

// -----------------------------------------------------------------------------
function CFNLoadController.GetItemCount: Integer;
begin
  Result := m_Items.Count;
end;

// -----------------------------------------------------------------------------
function CFNLoadController.HasNext: Boolean;
begin
  if (m_Position + 1 < m_Items.Count) then
  begin
    Result := true;
  end
  else
  begin
    Result := false;
  end;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadController.ItemLoadStarted(p_Item: CFNLoadItem);
begin
  if Assigned(m_OnItemLoadStartedEvent) then
    m_OnItemLoadStartedEvent(p_Item);
end;

// -----------------------------------------------------------------------------
procedure CFNLoadController.ItemLoadComplete(p_Item: CFNLoadItem);
begin
  if Assigned(m_OnItemLoadCompleteEvent) then
    m_OnItemLoadStartedEvent(p_Item);
  Process;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadController.ItemLoadFault(p_Item: CFNLoadItem);
begin
  if Assigned(m_OnItemLoadFaultEvent) then
    m_OnItemLoadFaultEvent(p_Item);
  if (not p_Item.StopOnFault) then
  begin
    Process;
  end
  else
  begin
    Fault;
  end;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadController.ItemLoadMessage(p_Item: CFNLoadItem);
begin
  if Assigned(m_OnItemLoadMessageEvent) then
    m_OnItemLoadMessageEvent(p_Item);
end;

// -----------------------------------------------------------------------------
procedure CFNLoadController.Load;
begin
  if m_IsComplete then
  begin
    m_IsComplete := false;
    m_IsError := false;
    m_Position := -1;
    Process;
  end;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadController.Process;
var
  f_CurrentItem: CFNLoadItem;
begin
  if (m_Position = -1) then
  begin
    if Assigned(m_OnStartEvent) then
      m_OnStartEvent(NIL);
  end;

  if not m_IsError then
  begin
    if (HasNext) then
    begin
      Inc(m_Position);
      f_CurrentItem := CFNLoadItem(m_Items[m_Position]);
      f_CurrentItem.Load;
    end
    else
    begin
      Complete;
    end;
  end;
end;

// -----------------------------------------------------------------------------
procedure CFNLoadController.Complete;
begin
  m_IsComplete := true;
  if Assigned(m_OnCompleteEvent) then
    m_OnCompleteEvent(NIL);
end;

// -----------------------------------------------------------------------------
procedure CFNLoadController.Fault;
begin
  m_IsError := true;
  m_IsComplete := true;
  if Assigned(m_OnFaultEvent) then
    m_OnFaultEvent(NIL);
end;

end.
