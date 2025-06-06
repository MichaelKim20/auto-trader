unit FNDataObject;

interface

type
  TDeliveryType = (dvtStream, dvtQuery);
  TDeliverySet = set of TDeliveryType;

const
  StrDatabaseNames: array [TDeliveryType] of String = ('Stream', 'Query');

type
  IFNDataObject = interface
    ['{C72E643F-911E-4B6C-8DE5-145C99BEE3A8}']
    procedure SetDeliveryType(AValue: TDeliveryType);
    function GetDeliveryType: TDeliveryType;
    property DeliveryType: TDeliveryType read GetDeliveryType write SetDeliveryType;
  end;

  CFNDataObject = Class(TInterfacedObject, IFNDataObject)
  private
    m_DeliveryType: TDeliveryType;

  public
    Constructor Create;
    Destructor Destroy; override;

    procedure SetDeliveryType(AValue: TDeliveryType);
    function GetDeliveryType: TDeliveryType;

    property DeliveryType: TDeliveryType read GetDeliveryType write SetDeliveryType;
  end;

implementation

// ---------------------------------------------------------------------------
Constructor CFNDataObject.Create;
begin
  inherited Create;
  m_DeliveryType := dvtQuery;
end;

// ---------------------------------------------------------------------------
Destructor CFNDataObject.Destroy;
begin
  m_DeliveryType := dvtQuery;
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNDataObject.SetDeliveryType(AValue: TDeliveryType);
begin
  m_DeliveryType := AValue;
end;

// ---------------------------------------------------------------------------
function CFNDataObject.GetDeliveryType: TDeliveryType;
begin
  Result := m_DeliveryType;
end;

end.
