unit MXBlock;

interface

uses
  XMLIntf, xmldom, msxmldom, XMLDoc, SysUtils, Classes, FNDataSet,
  FNDataDelivery,
  MXOption, MXSystemManager, MXOrderManager, FNQuotData, FNTradeSystem,
  SyncObjs,
  MKStreamChartDataSeries, MKLineValueSeries, MXBlockManager, Dialogs;

procedure MatrixStationWriteToXML(AList: TList; AStream: TStringStream);

type
  // ------------------------------------------------------------------------------------
  CMXBlockData = class(TObject)
  protected
    m_BlockName: String;
    m_BlockKey: String;

    m_Option: CMXOption;

    m_ReadEvent: TNotifyEvent;

  protected
    procedure SetOption(AOption: CMXOption);

  public
    constructor Create;
    destructor Destroy; override;
    procedure MakeBlockKey;

  public
    property BlockName: String read m_BlockName write m_BlockName;
    property BlockKey: String read m_BlockKey write m_BlockKey;

    property Option: CMXOption read m_Option write SetOption;

    procedure Read(AXMLNode: IXMLNode);
    function Write(AValue: Boolean = true): String;

    procedure CalculateTradingHour;
    procedure CalculateMaterialItem;
    procedure ApplySymbolItem;

    procedure Clone(ABlockData: CMXBlockData);

    property OnRead: TNotifyEvent read m_ReadEvent write m_ReadEvent;
  end;
  // ------------------------------------------------------------------------------------

  // ------------------------------------------------------------------------------------
  CMXBlock = class(CMXBlockData)
  private
    m_SaveStopedBlock: Boolean;

  protected
    m_BlockManager: CMXBlockManager;
    m_SystemManager: CMXSystemManager;
    m_OrderManager: CMXOrderManager;
    m_LogCollection: CFNLogCollection;

  public
    constructor Create;
    destructor Destroy; override;

    procedure WriteToXML(AStream: TStringStream);

  public
    property BlockManager: CMXBlockManager read m_BlockManager write m_BlockManager;
    property SystemManager: CMXSystemManager read m_SystemManager;
    property OrderManager: CMXOrderManager read m_OrderManager;
    property LogCollection: CFNLogCollection read m_LogCollection;
    property SaveStopedBlock: Boolean read m_SaveStopedBlock write m_SaveStopedBlock;
  end;
  // ------------------------------------------------------------------------------------

  // ------------------------------------------------------------------------------------
  CMXBlockDataCollection = class(TObject)
  private
    m_DataLock: TCriticalSection;
    m_CreateDate: TDateTime;

  public
    m_Items: TList;

  public
    constructor Create;
    destructor Destroy; override;

  public
    procedure Add(ABlockData: CMXBlockData);
    procedure Clear;
    function SearchByKey(AKey: String): CMXBlockData;

    property CreateDate: TDateTime read m_CreateDate;

    function Load(AFileName: String; AClear: Boolean = true): Boolean;
    procedure Save(AFileName: String);
    function DownLoadFromURL(AURL: String; AClear: Boolean = true): Boolean;
  end;
  // ------------------------------------------------------------------------------------

implementation

uses
  WinProcs, ComObj, Forms, FNGlobal, DateUtils, Variants, FNCMVariable,
  MXVariable, FNSymbolCollection, FNPOTCollection,
  FNMaterialCollection,
  CommonTRMaker, DCPsha1, DCPrc4, IdHTTP, HTTPApp,
  MXTradeStrategyOptionCollection;

var
  g_BlockCount: Integer;

  // ---------------------------------------------------------------------------
procedure MatrixStationWriteToXML(AList: TList; AStream: TStringStream);
var
  f_ChildIndex: Integer;
  f_Block: CMXBlock;

  f_FileName: String;
  f_FilePath: String;

  f_SDate: String;
  f_STime: String;
begin
  f_SDate := TFNGlobal.DateToString_YYYYMMDD(Now + g_DateTimeDiff);
  f_STime := TFNGlobal.TimeToString_HHMMSS(Now + g_DateTimeDiff);

  AStream.Clear;
  AStream.WriteString('<Station>' + #$0A);
  AStream.WriteString('<SessionID>' + TMXGlobal.GetSessionID + '</SessionID>' + #$0A);
  AStream.WriteString('<ApplicationName>' + g_ApplicationName + '</ApplicationName>' + #$0A);
  AStream.WriteString('<OPSUserID>' + g_MatrixUserID + '</OPSUserID>' + #$0A);
  AStream.WriteString('<OPSSessionId>' + g_SessionId + '</OPSSessionId>' + #$0A);
  AStream.WriteString('<SecUserName>' + g_SecUserID + '</SecUserName>' + #$0A);
  // AStream.WriteString('<SecPassWord><![CDATA[' + Encrypt(g_SecUserPW) + ']]></SecPassWord>' + #$0A);
  AStream.WriteString('<SecTradeMode>' + IntToStr(g_SecTradeMode) + '</SecTradeMode>' + #$0A);
  AStream.WriteString('<Version>' + g_Version + '</Version>' + #$0A);
  AStream.WriteString('<BuilderDate>' + g_BuilderDate + '</BuilderDate>' + #$0A);
  AStream.WriteString('<PGMCode>' + g_PGMCode + '</PGMCode>' + #$0A);
  AStream.WriteString('<SecCode>' + g_SecCode + '</SecCode>' + #$0A);
  AStream.WriteString('<Date>' + f_SDate + '</Date>' + #$0A);
  AStream.WriteString('<Time>' + f_STime + '</Time>' + #$0A);

  for f_ChildIndex := 0 to AList.Count - 1 do
  begin
    f_Block := AList[f_ChildIndex];
    f_Block.WriteToXML(AStream);
  end;

  g_LogCollection.WriteToXML(AStream, 'LogFile');
  AStream.WriteString('</Station>' + #$0A);
  AStream.Position := 0;

end;

// ------------------------------------------------------------------------------------
procedure CMXBlockData.Clone(ABlockData: CMXBlockData);
var
  f_Index: Integer;
  f_MAIndex: Integer;
  f_OIndex: Integer;
begin
  m_BlockName := ABlockData.BlockName;
  m_BlockKey := ABlockData.BlockKey;
  m_Option.Clone(ABlockData.Option);

end;

// ------------------------------------------------------------------------------------
constructor CMXBlockData.Create;
begin
  inherited Create;
  MakeBlockKey;
  m_BlockName := 'QS' + IntToStr(g_BlockCount + 1);
  Inc(g_BlockCount);

  m_Option := CMXOption.Create;

  CalculateTradingHour;
  CalculateMaterialItem;

  m_Option.SetBooleanValue('USE_STAND_DATE', false);
  m_Option.SetIntegerValue('STAND_DATE', Trunc(TFNGlobal.ServerNow + m_Option.GetDoubleValue('TIME_DIFFRENCE')));
end;

// ------------------------------------------------------------------------------------
destructor CMXBlockData.Destroy;
begin
  if Assigned(m_Option) then
    m_Option.Free;
  m_Option := NIL;

  inherited;
end;

// ------------------------------------------------------------------------------------
procedure CMXBlockData.MakeBlockKey;
var
  Guid: TGUID;
begin
  inherited Create;
  OleCheck(CreateGUID(Guid));
  m_BlockKey := GUIDToString(Guid);
end;

// ------------------------------------------------------------------------------------
procedure CMXBlockData.SetOption(AOption: CMXOption);
begin
  try
    m_Option.Clone(AOption);
  finally
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXBlockData.Read(AXMLNode: IXMLNode);
var
  f_Index: Integer;
  f_ChildNode: IXMLNode;
  f_OptionNode: IXMLNode;
  f_ChildIndex: Integer;
  f_OptionIndex: Integer;
  Guid: TGUID;
  f_StrategyOption: CMXTradeStrategyOption;
begin
  m_Option.DefaultValue;
  m_Option.StrategyOptionCollection.Clear;
  if AnsiCompareText('BLOCK', AXMLNode.NodeName) = 0 then
  begin
    if AXMLNode.HasAttribute('KEY') then
    begin
      m_BlockKey := AXMLNode.Attributes['KEY'];
    end
    else
    begin
      OleCheck(CreateGUID(Guid));
      m_BlockKey := GUIDToString(Guid);
    end;

    if AXMLNode.HasAttribute('NAME') then
    begin
      m_BlockName := AXMLNode.Attributes['NAME'];
    end
    else
    begin
      m_BlockName := m_BlockKey;
    end;

    for f_ChildIndex := 0 to AXMLNode.ChildNodes.Count - 1 do
    begin
      f_ChildNode := AXMLNode.ChildNodes[f_ChildIndex];
      if not Assigned(f_ChildNode) then
        continue;
      if AnsiCompareText('OPTION', f_ChildNode.NodeName) = 0 then
      begin
        m_Option.Read(f_ChildNode);
      end
      else if AnsiCompareText('TRADESTRATEGY', f_ChildNode.NodeName) = 0 then
      begin
        f_StrategyOption := CMXTradeStrategyOption.Create;
        f_StrategyOption.Read(f_ChildNode);
        m_Option.StrategyOptionCollection.Add(f_StrategyOption);
      end;
    end;
  end;

  CalculateTradingHour;
  CalculateMaterialItem;
  ApplySymbolItem;

  m_Option.SetBooleanValue('USE_STAND_DATE', false);
  m_Option.SetIntegerValue('STAND_DATE', Trunc(TFNGlobal.ServerNow + m_Option.GetDoubleValue('TIME_DIFFRENCE')));

  if Assigned(m_ReadEvent) then
  begin
    m_ReadEvent(Self);
  end;
end;

// -----------------------------------------------------------------------------
procedure CMXBlockData.CalculateTradingHour;
var
  f_Time: TTime;
  f_OpenDateTime: TDateTime;
  f_CloseDateTime: TDateTime;
  f_POTItem: CFNPOTItem;
  f_MaterialItem: CFNMaterialItem;
  f_TimeDifference: Double;
begin
  f_TimeDifference := 0;
  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(m_Option.GetIntegerValue('COUNTRY_NO'), m_Option.GetIntegerValue('GROUP_NO'), m_Option.GetIntegerValue('MARKET_NO'), m_Option.GetStringValue('SYMBOL'));

    if Assigned(f_MaterialItem) then
    begin
      f_TimeDifference := f_MaterialItem.m_TimeDiffrence
    end;
  end;

  f_OpenDateTime := g_DefaultOpenTime;
  f_CloseDateTime := g_DefaultCloseTime;

  if Assigned(g_POTCollection) then
  begin
    f_POTItem := g_POTCollection.Find(TFNGlobal.ServerNow + f_TimeDifference, m_Option.GetIntegerValue('COUNTRY_NO'), m_Option.GetIntegerValue('GROUP_NO'), m_Option.GetIntegerValue('MARKET_NO'),
      m_Option.GetStringValue('SYMBOL'));

    if not Assigned(f_POTItem) then
    begin
      f_POTItem := g_POTCollection.Find(TFNGlobal.ServerNow + f_TimeDifference, g_DefaultCountry, g_DefaultGroup, g_DefaultMarket, g_DefaultSymbol);
    end;

    if Assigned(f_POTItem) then
    begin
      f_OpenDateTime := EncodeTime(f_POTItem.NumberToHour(f_POTItem.m_Open[0]), f_POTItem.NumberToMin(f_POTItem.m_Open[0]), 0, 0);
      f_CloseDateTime := EncodeTime(f_POTItem.NumberToHour(f_POTItem.m_Close[f_POTItem.m_HourCount - 1]), f_POTItem.NumberToMin(f_POTItem.m_Close[f_POTItem.m_HourCount - 1]), 0, 0);
    end;
  end;

  f_Time := f_OpenDateTime + m_Option.GetIntegerValue('START_OFFSET') / 1440.0;
  m_Option.SetIntegerValue('START_TIME', Trunc(f_Time * 86400000 + 0.5));

  f_Time := f_CloseDateTime - m_Option.GetIntegerValue('STOP_OFFSET') / 1440.0;
  m_Option.SetIntegerValue('STOP_TIME', Trunc(f_Time * 86400000 + 0.5));
end;

// -----------------------------------------------------------------------------
procedure CMXBlockData.CalculateMaterialItem;
var
  f_MaterialItem: CFNMaterialItem;
begin
  if Assigned(g_MaterialCollection) then
  begin
    f_MaterialItem := g_MaterialCollection.Find(m_Option.GetIntegerValue('COUNTRY_NO'), m_Option.GetIntegerValue('GROUP_NO'), m_Option.GetIntegerValue('MARKET_NO'), m_Option.GetStringValue('SYMBOL'));

    if not Assigned(f_MaterialItem) then
    begin
      f_MaterialItem := g_MaterialCollection.Find(g_DefaultCountry, g_DefaultGroup, g_DefaultMarket, g_DefaultSymbol);
    end;

    if Assigned(f_MaterialItem) then
    begin
      m_Option.SetDoubleValue('TICK_STEP', f_MaterialItem.m_TickSize);
      m_Option.SetDoubleValue('TIME_DIFFRENCE', f_MaterialItem.m_TimeDiffrence);
      m_Option.SetDoubleValue('POINT_VALUE', f_MaterialItem.m_TickValue / f_MaterialItem.m_TickSize);
    end
    else
    begin
      m_Option.SetDoubleValue('TICK_STEP', 0.25);
      m_Option.SetDoubleValue('TIME_DIFFRENCE', 0);
      m_Option.SetDoubleValue('POINT_VALUE', 1);
    end;
  end;
end;

// -----------------------------------------------------------------------------
procedure CMXBlockData.ApplySymbolItem;
var
  f_SymbolItem: CFNSymbolItem;
begin
  if Assigned(g_SymbolCollection) then
  begin
    f_SymbolItem := g_SymbolCollection.Find(m_Option.GetIntegerValue('COUNTRY_NO'), m_Option.GetIntegerValue('GROUP_NO'), m_Option.GetIntegerValue('MARKET_NO'), m_Option.GetStringValue('SYMBOL'));

    if Assigned(f_SymbolItem) then
    begin
      m_Option.SetStringValue('SEC_SYMBOL', f_SymbolItem.m_SecSymbol);
      m_Option.SetStringValue('CONTRACT', f_SymbolItem.m_Contract);
      m_Option.SetStringValue('TRADESYMBOL', f_SymbolItem.m_SecSymbol + f_SymbolItem.m_Contract);
    end
    else
    begin
      m_Option.SetStringValue('SEC_SYMBOL', '');
      m_Option.SetStringValue('CONTRACT', '');
      m_Option.SetStringValue('TRADESYMBOL', '');
    end;
  end;
end;

// ------------------------------------------------------------------------------------
function CMXBlockData.Write(AValue: Boolean): String;
var
  f_Stream: TStringStream;
  f_Index: Integer;
  f_StrategyOption: CMXTradeStrategyOption;
begin
  f_Stream := TStringStream.Create('', TEncoding.UTF8, true);

  f_Stream.WriteString('<BLOCK NAME="' + m_BlockName + '" KEY="' + m_BlockKey + '" >' + #$0A);
  f_Stream.WriteString(m_Option.Write);

  for f_Index := 0 to m_Option.StrategyOptionCollection.m_Items.Count - 1 do
  begin
    f_StrategyOption := m_Option.StrategyOptionCollection.m_Items[f_Index];
    f_Stream.WriteString(f_StrategyOption.Write);
  end;
  f_Stream.WriteString('</BLOCK>' + #$0A);

  f_Stream.Position := 0;
  Result := f_Stream.ReadString(f_Stream.Size);
  f_Stream.Free;
end;

{ CMXBlock }

// ------------------------------------------------------------------------------------
constructor CMXBlock.Create;
begin
  inherited Create;

  m_SystemManager := CMXSystemManager.Create;
  m_OrderManager := CMXOrderManager.Create;
  m_LogCollection := CFNLogCollection.Create;

  m_SystemManager.OrderManager := m_OrderManager;

  m_SaveStopedBlock := false;
end;

// ------------------------------------------------------------------------------------
destructor CMXBlock.Destroy;
begin
  if Assigned(m_SystemManager) then
    m_SystemManager.Free;
  m_SystemManager := NIL;

  if Assigned(m_OrderManager) then
    m_OrderManager.Free;
  m_OrderManager := NIL;

  if Assigned(m_LogCollection) then
    m_LogCollection.Free;
  m_LogCollection := NIL;

  inherited;
end;

// ------------------------------------------------------------------------------------
procedure CMXBlock.WriteToXML(AStream: TStringStream);
begin
  AStream.WriteString('<Block>' + #$0A);
  AStream.WriteString(Self.Write(false));
  m_SystemManager.WriteToXML(AStream);
  m_OrderManager.WriteToXML(AStream);
  m_LogCollection.WriteToXML(AStream, 'LogCollection');
  AStream.WriteString('</Block>' + #$0A);
end;

{ CMXBlockDataCollection }
// ------------------------------------------------------------------------------------
constructor CMXBlockDataCollection.Create;
begin
  m_Items := TList.Create;
  m_DataLock := TCriticalSection.Create;
  m_CreateDate := TFNGlobal.ServerNow;
end;

// ------------------------------------------------------------------------------------
destructor CMXBlockDataCollection.Destroy;
begin
  Clear;
  m_Items.Free;
  m_Items := NIL;

  m_DataLock.Free;
  m_DataLock := NIL;
  inherited;
end;

// ------------------------------------------------------------------------------------
procedure CMXBlockDataCollection.Add(ABlockData: CMXBlockData);
var
  f_SearchBlock: CMXBlockData;
begin
  m_DataLock.Enter;
  try
    f_SearchBlock := SearchByKey(ABlockData.BlockKey);
    if Assigned(f_SearchBlock) then
      ABlockData.MakeBlockKey;
    m_Items.Add(ABlockData);
  finally
    m_DataLock.Leave;
  end;
end;

// ------------------------------------------------------------------------------------
procedure CMXBlockDataCollection.Clear;
begin
  m_DataLock.Enter;
  try
    while 0 < m_Items.Count do
    begin
      CMXBlock(m_Items.Items[0]).Free;
      m_Items.Delete(0);
    end;
  finally
    m_DataLock.Leave;
  end;
end;

// ------------------------------------------------------------------------------------
function CMXBlockDataCollection.Load(AFileName: String; AClear: Boolean): Boolean;
var
  f_Index: Integer;
  f_Stream: TStringStream;
  f_XMLDocument: TXMLDocument;
  f_XMLNode: IXMLNode;
  f_ChildNode: IXMLNode;
  f_Loop: Integer;
  f_Block: CMXBlockData;
  f_SearchBlock: CMXBlockData;
begin
  if not FileExists(AFileName) then
  begin
    Result := false;
    exit;
  end;

  if AClear then
    Clear;

  m_CreateDate := TFNGlobal.ServerNow;

  f_Stream := TStringStream.Create('', TEncoding.UTF8, true);
  f_Stream.LoadFromFile(AFileName);
  f_Stream.Position := 0;

  try
    f_XMLDocument := TXMLDocument.Create(Application);
    f_XMLDocument.LoadFromXML(f_Stream.ReadString(f_Stream.Size));

    f_XMLNode := f_XMLDocument.DocumentElement;

    if AnsiCompareText('BlockCollection', f_XMLNode.NodeName) = 0 then
    begin
      for f_Loop := 0 to f_XMLNode.ChildNodes.Count - 1 do
      begin
        f_ChildNode := f_XMLNode.ChildNodes[f_Loop];
        if AnsiCompareText('Block', f_ChildNode.NodeName) = 0 then
        begin
          f_Block := CMXBlockData.Create;
          f_Block.Read(f_ChildNode);

          f_SearchBlock := SearchByKey(f_Block.BlockKey);
          if Assigned(f_SearchBlock) then
            f_Block.MakeBlockKey;

          m_Items.Add(f_Block);
        end
        else if AnsiCompareText('CreateDate', f_ChildNode.NodeName) = 0 then
        begin
          m_CreateDate := TFNGlobal.StringToDateTime(VarToStr(f_ChildNode.NodeValue));
        end;
      end;
    end;

  finally
    if Assigned(f_XMLDocument) then
      f_XMLDocument.Free;
    if Assigned(f_Stream) then
      f_Stream.Free;
  end;

  Result := true;
end;

// ------------------------------------------------------------------------------------
procedure CMXBlockDataCollection.Save(AFileName: String);
var
  f_Index: Integer;
  f_Block: CMXBlockData;
  f_Stream: TStringStream;
begin
  m_DataLock.Enter;
  try
    f_Stream := TStringStream.Create('', TEncoding.UTF8, true);
    f_Stream.WriteString('<BlockCollection>' + #$0A);
    for f_Index := 0 to m_Items.Count - 1 do
    begin
      f_Block := m_Items.Items[f_Index];
      f_Stream.WriteString(f_Block.Write);
    end;
    f_Stream.WriteString('<CreateDate>' + TFNGlobal.DateToString_YYYYMMDD(m_CreateDate) + '</CreateDate>' + #$0A);
    f_Stream.WriteString('</BlockCollection>' + #$0A);
    f_Stream.SaveToFile(AFileName);
    f_Stream.Free;
  finally
    m_DataLock.Leave;
  end;
end;

// ------------------------------------------------------------------------------------
function CMXBlockDataCollection.DownLoadFromURL(AURL: String; AClear: Boolean): Boolean;
var
  f_Index: Integer;
  f_Stream: TStringStream;
  f_XMLDocument: TXMLDocument;
  f_XMLNode: IXMLNode;
  f_ChildNode: IXMLNode;
  f_Loop: Integer;
  f_Block: CMXBlockData;
  f_SearchBlock: CMXBlockData;
  f_HTTP: TIdHTTP;
  f_TryIndex, I: Integer;
  f_QueryURL: String;
  f_Success: Boolean;
  f_Status: String;
begin
  if AClear then
    Clear;
  m_CreateDate := TFNGlobal.ServerNow;
  f_QueryURL := AURL; // + '?' + 'timestamp=' + DateTimeToStr5(Now);
  f_Stream := TStringStream.Create('', TEncoding.UTF8, true);
  f_XMLDocument := TXMLDocument.Create(Application);
  try
    f_Stream.Clear;
    for I := 0 to 5 do
    begin
      f_Success := true;
      f_HTTP := TIdHTTP.Create(NIL);
      try
        f_HTTP.Get(f_QueryURL, f_Stream);
      except
        f_Success := false;
      end;
      f_HTTP.Free;

      if f_Success then
        break;
      Sleep(500);
    end;

    f_Stream.Position := 0;
    if (f_Success) then
    begin
      f_Stream.Position := 0;
      f_XMLDocument.LoadFromXML(f_Stream.ReadString(f_Stream.Size));
      f_XMLNode := f_XMLDocument.DocumentElement;
      if AnsiCompareText('BlockCollection', f_XMLNode.NodeName) = 0 then
      begin
        for f_Loop := 0 to f_XMLNode.ChildNodes.Count - 1 do
        begin
          f_ChildNode := f_XMLNode.ChildNodes[f_Loop];
          if AnsiCompareText('Block', f_ChildNode.NodeName) = 0 then
          begin
            f_Block := CMXBlockData.Create;
            f_Block.Read(f_ChildNode);
            f_SearchBlock := SearchByKey(f_Block.BlockKey);
            if Assigned(f_SearchBlock) then
              f_Block.MakeBlockKey;
            m_Items.Add(f_Block);
          end;
        end;
      end;
    end;
  finally
    if Assigned(f_XMLDocument) then
      f_XMLDocument.Free;
    if Assigned(f_Stream) then
      f_Stream.Free;
  end;

  Result := true;
end;

// ------------------------------------------------------------------------------------
function CMXBlockDataCollection.SearchByKey(AKey: String): CMXBlockData;
var
  f_Index: Integer;
  f_Block: CMXBlockData;
begin
  m_DataLock.Enter;
  try
    Result := NIL;
    for f_Index := 0 to m_Items.Count - 1 do
    begin
      f_Block := m_Items.Items[f_Index];
      if f_Block.m_BlockKey = AKey then
      begin
        Result := f_Block;
        break;
      end;
    end;
  finally
    m_DataLock.Leave;
  end;
end;

end.
