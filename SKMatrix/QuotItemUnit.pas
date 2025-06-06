 unit QuotItemUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls,
    FNDataSet,
    FNQueue,
    FNQuotData,
    FNDataDelivery,
    FNSocketManager,
    FNSymbolCollection;

type
  TSKMXQuotItemFrame = class(TFrame)
    Label_NAME: TLabel;
    Label_CLOSEPRICE: TLabel;
    GP1: TPanel;
    P1: TGridPanel;
    P2: TPanel;
    P3: TPanel;

  private
    m_SocketManager         :   CFNSocketManager    ;
    m_DataDelivery          :   CFNDataDelivery     ;
    m_SymbolItem            :   CFNSymbolItem       ;
    m_QuotData              :   CFNQuotData         ;

    procedure OnReply(ADataPackage:CFNDataPackage; var AutoFree:Boolean);
    procedure OnStream(AStreamRecord:CFNStreamRecord);

    procedure RequestQuot;

    procedure SubscribeQuot;
    procedure UnSubscribeQuot;

  public
    procedure OnFormCreate;
    procedure OnFormClose;
    procedure OnFormActivate;
    procedure SetSymbolItem(ASymbolItem : CFNSymbolItem);

  public
    property SocketManager : CFNSocketManager write m_SocketManager;
  end;

implementation

uses
    CommonTRMaker, FNGlobal;

{$R *.dfm}

//-------------------------------------------------------------------------------------------------
procedure TSKMXQuotItemFrame.OnFormCreate;
begin
    m_SymbolItem    := CFNSymbolItem.Create;
    m_QuotData      := CFNQuotData.Create;
    m_DataDelivery  := CFNDataDelivery.Create;
    m_DataDelivery.OnStreamEvent := OnStream;   //  스트리밍 수신 이벤트 등록
    m_DataDelivery.OnReplyEvent := OnReply;     //  조회성 데이터 수신 이벤트 등록
end;

//-------------------------------------------------------------------------------------------------
procedure TSKMXQuotItemFrame.OnFormActivate;
begin

end;

//-------------------------------------------------------------------------------------------------
procedure TSKMXQuotItemFrame.OnFormClose;
begin
    m_SymbolItem.Free;
    m_DataDelivery.Free;
    m_QuotData.Free;
end;

//-------------------------------------------------------------------------------------------------
procedure TSKMXQuotItemFrame.OnReply(ADataPackage: CFNDataPackage; var AutoFree: Boolean);
var
    f_DataSet : CFNDataSet;
    f_Record  : CFNRecord;

    f_Success : Boolean;
begin
    if (ADataPackage.GetServiceID = 'SC_QUOTE') then
    begin
        if (ADataPackage.GetTRCode = 'TR_0010') then
        begin
            if (ADataPackage.GetMsgCode <> 'M00000') then
            begin
                Sleep(1000);
                RequestQuot;
            end;

            f_Success := false;

            f_DataSet := ADataPackage.GetDataSet(DATASETID_OUT_01);
            if Assigned(f_DataSet) then
            begin
                if 0 < f_DataSet.RecordList.Count then
                begin
                    f_Record := CFNRecord(f_DataSet.RecordList.Items[0]);
                    if
                        (m_SymbolItem.m_Country  = f_Record.GetIntegerValue('COUNTRY_NO' )) and
                        (m_SymbolItem.m_Group    = f_Record.GetIntegerValue('GROUP_NO'   )) and
                        (m_SymbolItem.m_Market   = f_Record.GetIntegerValue('MARKET_NO'  )) and
                        (m_SymbolItem.m_Symbol   = f_Record.GetStringValue ('SYMBOL'     )) then
                    begin
                        f_Success := true;

                        m_QuotData.OPSArrayToData(f_Record);

                        Label_NAME.Caption := m_SymbolItem.m_Name;
                        Label_CLOSEPRICE.Caption := TFNGlobal.WriteNumber(m_QuotData.m_ClosePrice, 2);

                    end else
                    begin
                        f_Success := false;
                    end;
                end else
                begin
                    f_Success := false;
                end;
            end else
            begin
                f_Success := false;
            end;

            if (f_Success) then
            begin
                SubscribeQuot;
            end;
        end;
    end;
end;

//-------------------------------------------------------------------------------------------------
procedure TSKMXQuotItemFrame.OnStream(AStreamRecord: CFNStreamRecord);
begin
    if
        (m_SymbolItem.m_Country  = AStreamRecord.GetIntegerValue('COUNTRY_NO'   )) and
        (m_SymbolItem.m_Group    = AStreamRecord.GetIntegerValue('GROUP_NO'     )) and
        (m_SymbolItem.m_Market   = AStreamRecord.GetIntegerValue('MARKET_NO'    )) and
        (m_SymbolItem.m_Symbol   = AStreamRecord.GetStringValue ('SYMBOL')      ) then
    begin
        m_QuotData.OPSStreamDataToData(AStreamRecord);
    end;
    AStreamRecord.DecreaseReferenceCount;
end;

//-------------------------------------------------------------------------------------------------
procedure TSKMXQuotItemFrame.SetSymbolItem(ASymbolItem : CFNSymbolItem);
begin
    m_SymbolItem.Clone(ASymbolItem);

    UnSubscribeQuot;
    RequestQuot;
end;

//------------------------------------------------------------------------------------
procedure TSKMXQuotItemFrame.RequestQuot;
var
    f_Record:CFNRecord;
    f_DataPackage:CFNDataPackage;
begin
    if not Assigned(m_SocketManager) then exit;

    f_Record := CFNRecord.Create();
    f_Record.SetStringValue('SYMBOL', m_SymbolItem.m_Symbol);

    f_DataPackage := Make_SC_QUOTE_TR_0010_IN(NIL, f_Record);

    m_SocketManager.Request(m_DataDelivery, f_DataPackage);

    f_DataPackage.Free;
end;

//------------------------------------------------------------------------------------
procedure TSKMXQuotItemFrame.SubscribeQuot;
begin
    if not Assigned(m_SocketManager) then exit;

    m_SocketManager.SubscribeQuote(m_DataDelivery, m_SymbolItem.m_Country, m_SymbolItem.m_Group, m_SymbolItem.m_Market, m_SymbolItem.m_Symbol);
end;

//------------------------------------------------------------------------------------
procedure TSKMXQuotItemFrame.UnSubscribeQuot;
begin
    if not Assigned(m_SocketManager) then exit;

    m_SocketManager.UnSubscribeQuote(m_DataDelivery, m_SymbolItem.m_Country, m_SymbolItem.m_Group, m_SymbolItem.m_Market, m_SymbolItem.m_Symbol);
end;

//------------------------------------------------------------------------------------
end.

