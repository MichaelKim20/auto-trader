unit COMMOCXLib_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 16059 $
// File generated on 2013-12-26 오후 2:41:22 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\WorkSpace_MTX\MTXGF02\BinBO\CommOCX.ocx (1)
// LIBID: {FCB5A2C9-E712-41EF-826D-A64A1391E0C2}
// LCID: 0
// Helpfile: D:\WorkSpace_MTX\MTXGF02\BinBO\CommOCX.hlp
// HelpString: CommOCX ActiveX Control module
// DepndLst:
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
// *************************************************************************//
// NOTE:
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties
// which return objects that may need to be explicitly created via a function
// call prior to any access via the property. These items have been disabled
// in order to prevent accidental use from within the object inspector. You
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively
// removing them from the $IFDEF blocks. However, such items must still be
// programmatically created via a method of the appropriate CoClass before
// they can be used.
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;



// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  COMMOCXLibMajorVersion = 2;
  COMMOCXLibMinorVersion = 3;

  LIBID_COMMOCXLib: TGUID = '{FCB5A2C9-E712-41EF-826D-A64A1391E0C2}';

  DIID__DCommOCX: TGUID = '{5D77D785-0AD1-4B4F-B786-58539F509552}';
  DIID__DCommOCXEvents: TGUID = '{B17B5AD3-E1C4-44AF-AE86-C396322E9B9E}';
  CLASS_CommOCX: TGUID = '{9D70FC10-5DAA-4A96-9708-D66304E6C8A5}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  _DCommOCX = dispinterface;
  _DCommOCXEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  CommOCX = _DCommOCX;


// *********************************************************************//
// Declaration of structures, unions and aliases.
// *********************************************************************//
  PSmallint1 = ^Smallint; {*}
  PWideString1 = ^WideString; {*}


// *********************************************************************//
// DispIntf:  _DCommOCX
// Flags:     (4112) Hidden Dispatchable
// GUID:      {5D77D785-0AD1-4B4F-B786-58539F509552}
// *********************************************************************//
  _DCommOCX = dispinterface
    ['{5D77D785-0AD1-4B4F-B786-58539F509552}']
    function OCommLogin(const szUser: WideString; const szPassword: WideString;
                        const szElecPwd: WideString): Smallint; dispid 1;
    procedure OCommTerminate; dispid 2;
    function OGetMasterFileFromServer: Smallint; dispid 3;
    function OSendNewOrder(const szAccNum: WideString; const szPassword: WideString;
                           const szCode: WideString; nBuySell: Smallint; nFillType: Smallint;
                           nOrderQty: Smallint; const szOrderPx: WideString;
                           const szStopOrderPx: WideString; lCustID: Integer): WideString; dispid 4;
    function OSendModiOrder(const szAccNum: WideString; const szPassword: WideString;
                            const szCode: WideString; const szModiOrderPx: WideString;
                            const szOriOrdNum: WideString; lCustID: Integer): WideString; dispid 5;
    function OSendCancelOrder(const szAccNum: WideString; const szPassword: WideString;
                              const szCode: WideString; const szOriOrdNum: WideString;
                              lCustID: Integer): WideString; dispid 6;
    function ORequestData(const szTrCode: WideString; const szData: WideString; nDataLen: Smallint;
                          nTimeOut: Smallint; bEncrypt: Integer): Smallint; dispid 7;
    function OCommSetBrod(const szRegType: WideString; nRealKey: Smallint; const szData: WideString): WordBool; dispid 8;
    function OCommRemoveBrodAll: WordBool; dispid 9;
    function ORemoveBrod(const strRegType: WideString; const strKey: WideString): WordBool; dispid 10;
    function OChangePriceFormat(const strCode: WideString; nPrice: Integer): WideString; dispid 11;
    function OChangePriceStrToLong(const strCode: WideString): Integer; dispid 12;
    function OChangePriceToDecimal(const strCode: WideString; nPrice: Integer): Double; dispid 13;
    function OChangePriceDecToLong(const strCode: WideString; dPrice: Double): Integer; dispid 14;
    function OGetGJongmokInfo(const strCode: WideString; var nLog: Smallint;
                              var nLogDispSize: Smallint; var nPrecision: Smallint;
                              var strTickSize: WideString; var strTickValue: WideString;
                              var strPriceInfo: WideString): WordBool; dispid 15;
    function OGetGItemInfo(const strCode: WideString; var strName: WideString;
                           var strMarket: WideString; var strLimirSize: WideString;
                           var strAcntCode: WideString): WordBool; dispid 16;
    function OGet2KoreanStr(const szData: WideString): WideString; dispid 17;
    function OSetRealTimeByMarket(const szMarketCode: WideString): WordBool; dispid 18;
    function OCommSetBrodReal(nRealKey: Smallint; const szData: WideString): WordBool; dispid 19;
    function ORemoveBrodReal(nRealKey: Smallint; const strKey: WideString): WordBool; dispid 20;
    function ORegistRealDataToMainLib(nRealKey: Smallint; const strKey: WideString): Smallint; dispid 21;
    function OUnregistRealDataToMainLib(nRealKey: Smallint; const strKey: WideString): Smallint; dispid 22;
    function OUnregistAllRealMainLib: WordBool; dispid 23;
    function OGetSiseDataFromMainLib(nRealKey: Smallint; const strKey: WideString;
                                     var bIsFirst: Smallint; var szData: WideString): Integer; dispid 24;
    procedure AboutBox; dispid -552;
  end;

// *********************************************************************//
// DispIntf:  _DCommOCXEvents
// Flags:     (4096) Dispatchable
// GUID:      {B17B5AD3-E1C4-44AF-AE86-C396322E9B9E}
// *********************************************************************//
  _DCommOCXEvents = dispinterface
    ['{B17B5AD3-E1C4-44AF-AE86-C396322E9B9E}']
    procedure ORecvData(const szTrCode: WideString; nRqID: Smallint; nDataLen: Smallint;
                        var szData: WideString); dispid 1;
    procedure ORecvMsg(const cFlag: WideString; const szMsg: WideString); dispid 2;
    procedure ORecvRealData(nKey: Smallint; nDataLen: Smallint; const szData: WideString); dispid 3;
    procedure OEndWaitCursor(nMinorID: Smallint); dispid 4;
    procedure OSocketStatus(nStatus: Smallint); dispid 5;
    procedure ORecvMasterFile(nFinish: Smallint); dispid 6;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TCommOCX
// Help String      : CommOCX Control
// Default Interface: _DCommOCX
// Def. Intf. DISP? : Yes
// Event   Interface: _DCommOCXEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TCommOCXORecvData = procedure(ASender: TObject; const szTrCode: WideString; nRqID: Smallint;
                                                  nDataLen: Smallint; var szData: WideString) of object;
  TCommOCXORecvMsg = procedure(ASender: TObject; const cFlag: WideString; const szMsg: WideString) of object;
  TCommOCXORecvRealData = procedure(ASender: TObject; nKey: Smallint; nDataLen: Smallint;
                                                      const szData: WideString) of object;
  TCommOCXOEndWaitCursor = procedure(ASender: TObject; nMinorID: Smallint) of object;
  TCommOCXOSocketStatus = procedure(ASender: TObject; nStatus: Smallint) of object;
  TCommOCXORecvMasterFile = procedure(ASender: TObject; nFinish: Smallint) of object;

  TCommOCX = class(TOleControl)
  private
    FOnORecvData: TCommOCXORecvData;
    FOnORecvMsg: TCommOCXORecvMsg;
    FOnORecvRealData: TCommOCXORecvRealData;
    FOnOEndWaitCursor: TCommOCXOEndWaitCursor;
    FOnOSocketStatus: TCommOCXOSocketStatus;
    FOnORecvMasterFile: TCommOCXORecvMasterFile;
    FIntf: _DCommOCX;
    function  GetControlInterface: _DCommOCX;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function OCommLogin(const szUser: WideString; const szPassword: WideString;
                        const szElecPwd: WideString): Smallint;
    procedure OCommTerminate;
    function OGetMasterFileFromServer: Smallint;
    function OSendNewOrder(const szAccNum: WideString; const szPassword: WideString;
                           const szCode: WideString; nBuySell: Smallint; nFillType: Smallint;
                           nOrderQty: Smallint; const szOrderPx: WideString;
                           const szStopOrderPx: WideString; lCustID: Integer): WideString;
    function OSendModiOrder(const szAccNum: WideString; const szPassword: WideString;
                            const szCode: WideString; const szModiOrderPx: WideString;
                            const szOriOrdNum: WideString; lCustID: Integer): WideString;
    function OSendCancelOrder(const szAccNum: WideString; const szPassword: WideString;
                              const szCode: WideString; const szOriOrdNum: WideString;
                              lCustID: Integer): WideString;
    function ORequestData(const szTrCode: WideString; const szData: WideString; nDataLen: Smallint;
                          nTimeOut: Smallint; bEncrypt: Integer): Smallint;
    function OCommSetBrod(const szRegType: WideString; nRealKey: Smallint; const szData: WideString): WordBool;
    function OCommRemoveBrodAll: WordBool;
    function ORemoveBrod(const strRegType: WideString; const strKey: WideString): WordBool;
    function OChangePriceFormat(const strCode: WideString; nPrice: Integer): WideString;
    function OChangePriceStrToLong(const strCode: WideString): Integer;
    function OChangePriceToDecimal(const strCode: WideString; nPrice: Integer): Double;
    function OChangePriceDecToLong(const strCode: WideString; dPrice: Double): Integer;
    function OGetGJongmokInfo(const strCode: WideString; var nLog: Smallint;
                              var nLogDispSize: Smallint; var nPrecision: Smallint;
                              var strTickSize: WideString; var strTickValue: WideString;
                              var strPriceInfo: WideString): WordBool;
    function OGetGItemInfo(const strCode: WideString; var strName: WideString;
                           var strMarket: WideString; var strLimirSize: WideString;
                           var strAcntCode: WideString): WordBool;
    function OGet2KoreanStr(const szData: WideString): WideString;
    function OSetRealTimeByMarket(const szMarketCode: WideString): WordBool;
    function OCommSetBrodReal(nRealKey: Smallint; const szData: WideString): WordBool;
    function ORemoveBrodReal(nRealKey: Smallint; const strKey: WideString): WordBool;
    function ORegistRealDataToMainLib(nRealKey: Smallint; const strKey: WideString): Smallint;
    function OUnregistRealDataToMainLib(nRealKey: Smallint; const strKey: WideString): Smallint;
    function OUnregistAllRealMainLib: WordBool;
    function OGetSiseDataFromMainLib(nRealKey: Smallint; const strKey: WideString;
                                     var bIsFirst: Smallint; var szData: WideString): Integer;
    procedure AboutBox;
    property  ControlInterface: _DCommOCX read GetControlInterface;
    property  DefaultInterface: _DCommOCX read GetControlInterface;
  published
    property Anchors;
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property OnORecvData: TCommOCXORecvData read FOnORecvData write FOnORecvData;
    property OnORecvMsg: TCommOCXORecvMsg read FOnORecvMsg write FOnORecvMsg;
    property OnORecvRealData: TCommOCXORecvRealData read FOnORecvRealData write FOnORecvRealData;
    property OnOEndWaitCursor: TCommOCXOEndWaitCursor read FOnOEndWaitCursor write FOnOEndWaitCursor;
    property OnOSocketStatus: TCommOCXOSocketStatus read FOnOSocketStatus write FOnOSocketStatus;
    property OnORecvMasterFile: TCommOCXORecvMasterFile read FOnORecvMasterFile write FOnORecvMasterFile;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TCommOCX.InitControlData;
const
  CEventDispIDs: array [0..5] of DWORD = (
    $00000001, $00000002, $00000003, $00000004, $00000005, $00000006);
  CControlData: TControlData2 = (
    ClassID: '{9D70FC10-5DAA-4A96-9708-D66304E6C8A5}';
    EventIID: '{B17B5AD3-E1C4-44AF-AE86-C396322E9B9E}';
    EventCount: 6;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004005*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnORecvData) - Cardinal(Self);
end;

procedure TCommOCX.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DCommOCX;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TCommOCX.GetControlInterface: _DCommOCX;
begin
  CreateControl;
  Result := FIntf;
end;

function TCommOCX.OCommLogin(const szUser: WideString; const szPassword: WideString;
                             const szElecPwd: WideString): Smallint;
begin
  Result := DefaultInterface.OCommLogin(szUser, szPassword, szElecPwd);
end;

procedure TCommOCX.OCommTerminate;
begin
  DefaultInterface.OCommTerminate;
end;

function TCommOCX.OGetMasterFileFromServer: Smallint;
begin
  Result := DefaultInterface.OGetMasterFileFromServer;
end;

function TCommOCX.OSendNewOrder(const szAccNum: WideString; const szPassword: WideString;
                                const szCode: WideString; nBuySell: Smallint; nFillType: Smallint;
                                nOrderQty: Smallint; const szOrderPx: WideString;
                                const szStopOrderPx: WideString; lCustID: Integer): WideString;
begin
  Result := DefaultInterface.OSendNewOrder(szAccNum, szPassword, szCode, nBuySell, nFillType,
                                           nOrderQty, szOrderPx, szStopOrderPx, lCustID);
end;

function TCommOCX.OSendModiOrder(const szAccNum: WideString; const szPassword: WideString;
                                 const szCode: WideString; const szModiOrderPx: WideString;
                                 const szOriOrdNum: WideString; lCustID: Integer): WideString;
begin
  Result := DefaultInterface.OSendModiOrder(szAccNum, szPassword, szCode, szModiOrderPx,
                                            szOriOrdNum, lCustID);
end;

function TCommOCX.OSendCancelOrder(const szAccNum: WideString; const szPassword: WideString;
                                   const szCode: WideString; const szOriOrdNum: WideString;
                                   lCustID: Integer): WideString;
begin
  Result := DefaultInterface.OSendCancelOrder(szAccNum, szPassword, szCode, szOriOrdNum, lCustID);
end;

function TCommOCX.ORequestData(const szTrCode: WideString; const szData: WideString;
                               nDataLen: Smallint; nTimeOut: Smallint; bEncrypt: Integer): Smallint;
begin
  Result := DefaultInterface.ORequestData(szTrCode, szData, nDataLen, nTimeOut, bEncrypt);
end;

function TCommOCX.OCommSetBrod(const szRegType: WideString; nRealKey: Smallint;
                               const szData: WideString): WordBool;
begin
  Result := DefaultInterface.OCommSetBrod(szRegType, nRealKey, szData);
end;

function TCommOCX.OCommRemoveBrodAll: WordBool;
begin
  Result := DefaultInterface.OCommRemoveBrodAll;
end;

function TCommOCX.ORemoveBrod(const strRegType: WideString; const strKey: WideString): WordBool;
begin
  Result := DefaultInterface.ORemoveBrod(strRegType, strKey);
end;

function TCommOCX.OChangePriceFormat(const strCode: WideString; nPrice: Integer): WideString;
begin
  Result := DefaultInterface.OChangePriceFormat(strCode, nPrice);
end;

function TCommOCX.OChangePriceStrToLong(const strCode: WideString): Integer;
begin
  Result := DefaultInterface.OChangePriceStrToLong(strCode);
end;

function TCommOCX.OChangePriceToDecimal(const strCode: WideString; nPrice: Integer): Double;
begin
  Result := DefaultInterface.OChangePriceToDecimal(strCode, nPrice);
end;

function TCommOCX.OChangePriceDecToLong(const strCode: WideString; dPrice: Double): Integer;
begin
  Result := DefaultInterface.OChangePriceDecToLong(strCode, dPrice);
end;

function TCommOCX.OGetGJongmokInfo(const strCode: WideString; var nLog: Smallint;
                                   var nLogDispSize: Smallint; var nPrecision: Smallint;
                                   var strTickSize: WideString; var strTickValue: WideString;
                                   var strPriceInfo: WideString): WordBool;
begin
  Result := DefaultInterface.OGetGJongmokInfo(strCode, nLog, nLogDispSize, nPrecision, strTickSize,
                                              strTickValue, strPriceInfo);
end;

function TCommOCX.OGetGItemInfo(const strCode: WideString; var strName: WideString;
                                var strMarket: WideString; var strLimirSize: WideString;
                                var strAcntCode: WideString): WordBool;
begin
  Result := DefaultInterface.OGetGItemInfo(strCode, strName, strMarket, strLimirSize, strAcntCode);
end;

function TCommOCX.OGet2KoreanStr(const szData: WideString): WideString;
begin
  Result := DefaultInterface.OGet2KoreanStr(szData);
end;

function TCommOCX.OSetRealTimeByMarket(const szMarketCode: WideString): WordBool;
begin
  Result := DefaultInterface.OSetRealTimeByMarket(szMarketCode);
end;

function TCommOCX.OCommSetBrodReal(nRealKey: Smallint; const szData: WideString): WordBool;
begin
  Result := DefaultInterface.OCommSetBrodReal(nRealKey, szData);
end;

function TCommOCX.ORemoveBrodReal(nRealKey: Smallint; const strKey: WideString): WordBool;
begin
  Result := DefaultInterface.ORemoveBrodReal(nRealKey, strKey);
end;

function TCommOCX.ORegistRealDataToMainLib(nRealKey: Smallint; const strKey: WideString): Smallint;
begin
  Result := DefaultInterface.ORegistRealDataToMainLib(nRealKey, strKey);
end;

function TCommOCX.OUnregistRealDataToMainLib(nRealKey: Smallint; const strKey: WideString): Smallint;
begin
  Result := DefaultInterface.OUnregistRealDataToMainLib(nRealKey, strKey);
end;

function TCommOCX.OUnregistAllRealMainLib: WordBool;
begin
  Result := DefaultInterface.OUnregistAllRealMainLib;
end;

function TCommOCX.OGetSiseDataFromMainLib(nRealKey: Smallint; const strKey: WideString;
                                          var bIsFirst: Smallint; var szData: WideString): Integer;
begin
  Result := DefaultInterface.OGetSiseDataFromMainLib(nRealKey, strKey, bIsFirst, szData);
end;

procedure TCommOCX.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TCommOCX]);
end;

end.
