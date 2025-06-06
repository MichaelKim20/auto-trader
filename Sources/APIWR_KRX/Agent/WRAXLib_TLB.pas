unit WRAXLib_TLB;

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
// File generated on 2015-08-27 오후 4:02:27 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\WorkSpace_MTX\MTXGF02\BinB_KRX\WRAX.ocx (1)
// LIBID: {9EA87740-604D-4E4E-A9BD-34A4D8A76156}
// LCID: 0
// Helpfile: D:\WorkSpace_MTX\MTXGF02\BinB_KRX\WRAX.hlp
// HelpString: WRAX ActiveX Control module
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
  WRAXLibMajorVersion = 4;
  WRAXLibMinorVersion = 7;

  LIBID_WRAXLib: TGUID = '{9EA87740-604D-4E4E-A9BD-34A4D8A76156}';

  DIID__DWRAX: TGUID = '{1B1F1E20-1A9D-429C-AE91-B6ECCC786734}';
  DIID__DWRAXEvents: TGUID = '{17467A5C-AC04-4084-89D9-4DF14FC4E825}';
  CLASS_WRAX: TGUID = '{EC22F588-9228-43EA-8F8D-13C5FC2D5585}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  _DWRAX = dispinterface;
  _DWRAXEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  WRAX = _DWRAX;


// *********************************************************************//
// Declaration of structures, unions and aliases.
// *********************************************************************//
  PWordBool1 = ^WordBool; {*}
  PWideString1 = ^WideString; {*}


// *********************************************************************//
// DispIntf:  _DWRAX
// Flags:     (4112) Hidden Dispatchable
// GUID:      {1B1F1E20-1A9D-429C-AE91-B6ECCC786734}
// *********************************************************************//
  _DWRAX = dispinterface
    ['{1B1F1E20-1A9D-429C-AE91-B6ECCC786734}']
    procedure ConnectHost(const szIP: WideString; const szPort: WideString); dispid 1;
    procedure CloseHost; dispid 2;
    procedure Login(const szUserID: WideString; const szPWD: WideString; const szCertPWD: WideString); dispid 3;
    function RequestData(const szTrName: WideString; nDataSize: Integer; const szData: WideString;
                         bEncrypt: Integer; bCompress: Integer; nTimeOut: Smallint): Smallint; dispid 4;
    function RegistRealData(const szTrName: WideString; const szKeyCode: WideString): Smallint; dispid 5;
    function UnregistRealData(nRealID: Smallint): WordBool; dispid 6;
    procedure GetMasterFile(const szFileName: WideString); dispid 7;
    function SendNewOrder(const szAccNum: WideString; const szPassword: WideString;
                          const szCode: WideString; nBuySell: Smallint; nOrderType: Smallint;
                          nFillType: Smallint; nOrderQty: Smallint; dOrderPx: Double;
                          nCustOrderKey: Smallint): WideString; dispid 8;
    function SendModiOrder(const szAccNum: WideString; const szPassword: WideString;
                           const szCode: WideString; nBuySell: Smallint; nOrderType: Smallint;
                           nFillType: Smallint; nOrderQty: Smallint; dOrderPx: Double;
                           const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString; dispid 9;
    function SendCancelOrder(const szAccNum: WideString; const szPassword: WideString;
                             const szCode: WideString; nBuySell: Smallint; nOrderQty: Smallint;
                             const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString; dispid 10;
    function Get2KoreanStr(const szData: WideString): WideString; dispid 11;
    function SendCMENewOrder(const szAccNum: WideString; const szPassword: WideString;
                             const szCode: WideString; nBuySell: Smallint; nFillType: Smallint;
                             nOrderQty: Smallint; dOrderPx: Double; nCustOrderKey: Smallint): WideString; dispid 12;
    function SendCMECancelOrder(const szAccNum: WideString; const szPassword: WideString;
                                const szCode: WideString; nBuySell: Smallint;
                                const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString; dispid 13;
    function CopyToClipboard(const szInputData: WideString): WordBool; dispid 14;
    function IsLogined: WordBool; dispid 15;
    function SendCMEModiOrder(const szAccNum: WideString; const szPassword: WideString;
                              const szCode: WideString; nBuySell: Smallint; dOrderPx: Double;
                              const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString; dispid 16;
    function ClearAllCount: WordBool; dispid 17;
    function GetJongMokInfo(nType: Smallint; const strItemCode: WideString): WideString; dispid 18;
    function GetPLAmtByPx(const strItemCode: WideString; nTradeSect: Smallint; nQty: Smallint;
                          dAvgPx: Double; dCurrentPx: Double): Double; dispid 19;
    function GetPLAmtByAmt(const strItemCode: WideString; nTradeSect: Smallint; nQty: Smallint;
                           dAvgAmt: Double; dCurrentPx: Double): Double; dispid 20;
    function RegistRealDataToMainLib(const strRealTrCode: WideString; const strKeyCode: WideString): Smallint; dispid 21;
    function UnregistRealDataToMainLib(nSBID: Smallint): WordBool; dispid 22;
    function GetSiseDataFromMainLib(const strRealTrCode: WideString; const strKeyCode: WideString;
                                    var bIsFirstGet: WordBool; var strOutData: WideString): Integer; dispid 23;
    function GetAccountInfCount: Smallint; dispid 24;
    function GetAccountInf(nIndex: Smallint; var pszAccountNo: WideString;
                           var pszAccountName: WideString): Integer; dispid 25;
    function GetCMEAccountInfCount: Smallint; dispid 26;
    function GetCMEAccountInf(nIndex: Smallint; var pszAccountNo: WideString;
                              var pszAccountName: WideString): Integer; dispid 27;
    function SendEUREXNewOrder(const szAccNum: WideString; const szPassword: WideString;
                               const szCode: WideString; nBuySell: Smallint; nOrderType: Smallint;
                               nOrderQty: Smallint; dOrderPx: Double; nCustOrderKey: Smallint): WideString; dispid 28;
    function SendEUREXModiOrder(const szAccNum: WideString; const szPassword: WideString;
                                const szCode: WideString; nBuySell: Smallint; nOrderType: Smallint;
                                nOrderQty: Smallint; dOrderPx: Double;
                                const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString; dispid 29;
    function SendEUREXCancelOrder(const szAccNum: WideString; const szPassword: WideString;
                                  const szCode: WideString; nBuySell: Smallint;
                                  nOrderType: Smallint; nOrderQty: Smallint;
                                  const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString; dispid 30;
    procedure AboutBox; dispid -552;
  end;

// *********************************************************************//
// DispIntf:  _DWRAXEvents
// Flags:     (4096) Dispatchable
// GUID:      {17467A5C-AC04-4084-89D9-4DF14FC4E825}
// *********************************************************************//
  _DWRAXEvents = dispinterface
    ['{17467A5C-AC04-4084-89D9-4DF14FC4E825}']
    procedure RecvData(DataType: Smallint; const TrCode: WideString; RqID: Smallint;
                       DataSize: Integer; var szData: WideString); dispid 1;
    procedure RecvRealData(const TrCode: WideString; const KeyValue: WideString; RealID: Smallint;
                           DataSize: Integer; const szData: WideString); dispid 2;
    procedure NetConnected; dispid 3;
    procedure NetDisconnected; dispid 4;
    procedure ReplyLogin(Result: Smallint; const Message: WideString); dispid 5;
    procedure ReplyFileDown(Result: Smallint; const Message: WideString); dispid 6;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TWRAX
// Help String      : WRAX Control
// Default Interface: _DWRAX
// Def. Intf. DISP? : Yes
// Event   Interface: _DWRAXEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TWRAXRecvData = procedure(ASender: TObject; DataType: Smallint; const TrCode: WideString;
                                              RqID: Smallint; DataSize: Integer;
                                              var szData: WideString) of object;
  TWRAXRecvRealData = procedure(ASender: TObject; const TrCode: WideString;
                                                  const KeyValue: WideString; RealID: Smallint;
                                                  DataSize: Integer; const szData: WideString) of object;
  TWRAXReplyLogin = procedure(ASender: TObject; Result: Smallint; const Message: WideString) of object;
  TWRAXReplyFileDown = procedure(ASender: TObject; Result: Smallint; const Message: WideString) of object;

  TWRAX = class(TOleControl)
  private
    FOnRecvData: TWRAXRecvData;
    FOnRecvRealData: TWRAXRecvRealData;
    FOnNetConnected: TNotifyEvent;
    FOnNetDisconnected: TNotifyEvent;
    FOnReplyLogin: TWRAXReplyLogin;
    FOnReplyFileDown: TWRAXReplyFileDown;
    FIntf: _DWRAX;
    function  GetControlInterface: _DWRAX;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure ConnectHost(const szIP: WideString; const szPort: WideString);
    procedure CloseHost;
    procedure Login(const szUserID: WideString; const szPWD: WideString; const szCertPWD: WideString);
    function RequestData(const szTrName: WideString; nDataSize: Integer; const szData: WideString;
                         bEncrypt: Integer; bCompress: Integer; nTimeOut: Smallint): Smallint;
    function RegistRealData(const szTrName: WideString; const szKeyCode: WideString): Smallint;
    function UnregistRealData(nRealID: Smallint): WordBool;
    procedure GetMasterFile(const szFileName: WideString);
    function SendNewOrder(const szAccNum: WideString; const szPassword: WideString;
                          const szCode: WideString; nBuySell: Smallint; nOrderType: Smallint;
                          nFillType: Smallint; nOrderQty: Smallint; dOrderPx: Double;
                          nCustOrderKey: Smallint): WideString;
    function SendModiOrder(const szAccNum: WideString; const szPassword: WideString;
                           const szCode: WideString; nBuySell: Smallint; nOrderType: Smallint;
                           nFillType: Smallint; nOrderQty: Smallint; dOrderPx: Double;
                           const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString;
    function SendCancelOrder(const szAccNum: WideString; const szPassword: WideString;
                             const szCode: WideString; nBuySell: Smallint; nOrderQty: Smallint;
                             const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString;
    function Get2KoreanStr(const szData: WideString): WideString;
    function SendCMENewOrder(const szAccNum: WideString; const szPassword: WideString;
                             const szCode: WideString; nBuySell: Smallint; nFillType: Smallint;
                             nOrderQty: Smallint; dOrderPx: Double; nCustOrderKey: Smallint): WideString;
    function SendCMECancelOrder(const szAccNum: WideString; const szPassword: WideString;
                                const szCode: WideString; nBuySell: Smallint;
                                const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString;
    function CopyToClipboard(const szInputData: WideString): WordBool;
    function IsLogined: WordBool;
    function SendCMEModiOrder(const szAccNum: WideString; const szPassword: WideString;
                              const szCode: WideString; nBuySell: Smallint; dOrderPx: Double;
                              const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString;
    function ClearAllCount: WordBool;
    function GetJongMokInfo(nType: Smallint; const strItemCode: WideString): WideString;
    function GetPLAmtByPx(const strItemCode: WideString; nTradeSect: Smallint; nQty: Smallint;
                          dAvgPx: Double; dCurrentPx: Double): Double;
    function GetPLAmtByAmt(const strItemCode: WideString; nTradeSect: Smallint; nQty: Smallint;
                           dAvgAmt: Double; dCurrentPx: Double): Double;
    function RegistRealDataToMainLib(const strRealTrCode: WideString; const strKeyCode: WideString): Smallint;
    function UnregistRealDataToMainLib(nSBID: Smallint): WordBool;
    function GetSiseDataFromMainLib(const strRealTrCode: WideString; const strKeyCode: WideString;
                                    var bIsFirstGet: WordBool; var strOutData: WideString): Integer;
    function GetAccountInfCount: Smallint;
    function GetAccountInf(nIndex: Smallint; var pszAccountNo: WideString;
                           var pszAccountName: WideString): Integer;
    function GetCMEAccountInfCount: Smallint;
    function GetCMEAccountInf(nIndex: Smallint; var pszAccountNo: WideString;
                              var pszAccountName: WideString): Integer;
    function SendEUREXNewOrder(const szAccNum: WideString; const szPassword: WideString;
                               const szCode: WideString; nBuySell: Smallint; nOrderType: Smallint;
                               nOrderQty: Smallint; dOrderPx: Double; nCustOrderKey: Smallint): WideString;
    function SendEUREXModiOrder(const szAccNum: WideString; const szPassword: WideString;
                                const szCode: WideString; nBuySell: Smallint; nOrderType: Smallint;
                                nOrderQty: Smallint; dOrderPx: Double;
                                const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString;
    function SendEUREXCancelOrder(const szAccNum: WideString; const szPassword: WideString;
                                  const szCode: WideString; nBuySell: Smallint;
                                  nOrderType: Smallint; nOrderQty: Smallint;
                                  const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString;
    procedure AboutBox;
    property  ControlInterface: _DWRAX read GetControlInterface;
    property  DefaultInterface: _DWRAX read GetControlInterface;
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
    property OnRecvData: TWRAXRecvData read FOnRecvData write FOnRecvData;
    property OnRecvRealData: TWRAXRecvRealData read FOnRecvRealData write FOnRecvRealData;
    property OnNetConnected: TNotifyEvent read FOnNetConnected write FOnNetConnected;
    property OnNetDisconnected: TNotifyEvent read FOnNetDisconnected write FOnNetDisconnected;
    property OnReplyLogin: TWRAXReplyLogin read FOnReplyLogin write FOnReplyLogin;
    property OnReplyFileDown: TWRAXReplyFileDown read FOnReplyFileDown write FOnReplyFileDown;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TWRAX.InitControlData;
const
  CEventDispIDs: array [0..5] of DWORD = (
    $00000001, $00000002, $00000003, $00000004, $00000005, $00000006);
  CControlData: TControlData2 = (
    ClassID: '{EC22F588-9228-43EA-8F8D-13C5FC2D5585}';
    EventIID: '{17467A5C-AC04-4084-89D9-4DF14FC4E825}';
    EventCount: 6;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004005*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnRecvData) - Cardinal(Self);
end;

procedure TWRAX.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DWRAX;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TWRAX.GetControlInterface: _DWRAX;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TWRAX.ConnectHost(const szIP: WideString; const szPort: WideString);
begin
  DefaultInterface.ConnectHost(szIP, szPort);
end;

procedure TWRAX.CloseHost;
begin
  DefaultInterface.CloseHost;
end;

procedure TWRAX.Login(const szUserID: WideString; const szPWD: WideString;
                      const szCertPWD: WideString);
begin
  DefaultInterface.Login(szUserID, szPWD, szCertPWD);
end;

function TWRAX.RequestData(const szTrName: WideString; nDataSize: Integer;
                           const szData: WideString; bEncrypt: Integer; bCompress: Integer;
                           nTimeOut: Smallint): Smallint;
begin
  Result := DefaultInterface.RequestData(szTrName, nDataSize, szData, bEncrypt, bCompress, nTimeOut);
end;

function TWRAX.RegistRealData(const szTrName: WideString; const szKeyCode: WideString): Smallint;
begin
  Result := DefaultInterface.RegistRealData(szTrName, szKeyCode);
end;

function TWRAX.UnregistRealData(nRealID: Smallint): WordBool;
begin
  Result := DefaultInterface.UnregistRealData(nRealID);
end;

procedure TWRAX.GetMasterFile(const szFileName: WideString);
begin
  DefaultInterface.GetMasterFile(szFileName);
end;

function TWRAX.SendNewOrder(const szAccNum: WideString; const szPassword: WideString;
                            const szCode: WideString; nBuySell: Smallint; nOrderType: Smallint;
                            nFillType: Smallint; nOrderQty: Smallint; dOrderPx: Double;
                            nCustOrderKey: Smallint): WideString;
begin
  Result := DefaultInterface.SendNewOrder(szAccNum, szPassword, szCode, nBuySell, nOrderType,
                                          nFillType, nOrderQty, dOrderPx, nCustOrderKey);
end;

function TWRAX.SendModiOrder(const szAccNum: WideString; const szPassword: WideString;
                             const szCode: WideString; nBuySell: Smallint; nOrderType: Smallint;
                             nFillType: Smallint; nOrderQty: Smallint; dOrderPx: Double;
                             const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString;
begin
  Result := DefaultInterface.SendModiOrder(szAccNum, szPassword, szCode, nBuySell, nOrderType,
                                           nFillType, nOrderQty, dOrderPx, szOriOrdNum,
                                           nCustOrderKey);
end;

function TWRAX.SendCancelOrder(const szAccNum: WideString; const szPassword: WideString;
                               const szCode: WideString; nBuySell: Smallint; nOrderQty: Smallint;
                               const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString;
begin
  Result := DefaultInterface.SendCancelOrder(szAccNum, szPassword, szCode, nBuySell, nOrderQty,
                                             szOriOrdNum, nCustOrderKey);
end;

function TWRAX.Get2KoreanStr(const szData: WideString): WideString;
begin
  Result := DefaultInterface.Get2KoreanStr(szData);
end;

function TWRAX.SendCMENewOrder(const szAccNum: WideString; const szPassword: WideString;
                               const szCode: WideString; nBuySell: Smallint; nFillType: Smallint;
                               nOrderQty: Smallint; dOrderPx: Double; nCustOrderKey: Smallint): WideString;
begin
  Result := DefaultInterface.SendCMENewOrder(szAccNum, szPassword, szCode, nBuySell, nFillType,
                                             nOrderQty, dOrderPx, nCustOrderKey);
end;

function TWRAX.SendCMECancelOrder(const szAccNum: WideString; const szPassword: WideString;
                                  const szCode: WideString; nBuySell: Smallint;
                                  const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString;
begin
  Result := DefaultInterface.SendCMECancelOrder(szAccNum, szPassword, szCode, nBuySell,
                                                szOriOrdNum, nCustOrderKey);
end;

function TWRAX.CopyToClipboard(const szInputData: WideString): WordBool;
begin
  Result := DefaultInterface.CopyToClipboard(szInputData);
end;

function TWRAX.IsLogined: WordBool;
begin
  Result := DefaultInterface.IsLogined;
end;

function TWRAX.SendCMEModiOrder(const szAccNum: WideString; const szPassword: WideString;
                                const szCode: WideString; nBuySell: Smallint; dOrderPx: Double;
                                const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString;
begin
  Result := DefaultInterface.SendCMEModiOrder(szAccNum, szPassword, szCode, nBuySell, dOrderPx,
                                              szOriOrdNum, nCustOrderKey);
end;

function TWRAX.ClearAllCount: WordBool;
begin
  Result := DefaultInterface.ClearAllCount;
end;

function TWRAX.GetJongMokInfo(nType: Smallint; const strItemCode: WideString): WideString;
begin
  Result := DefaultInterface.GetJongMokInfo(nType, strItemCode);
end;

function TWRAX.GetPLAmtByPx(const strItemCode: WideString; nTradeSect: Smallint; nQty: Smallint;
                            dAvgPx: Double; dCurrentPx: Double): Double;
begin
  Result := DefaultInterface.GetPLAmtByPx(strItemCode, nTradeSect, nQty, dAvgPx, dCurrentPx);
end;

function TWRAX.GetPLAmtByAmt(const strItemCode: WideString; nTradeSect: Smallint; nQty: Smallint;
                             dAvgAmt: Double; dCurrentPx: Double): Double;
begin
  Result := DefaultInterface.GetPLAmtByAmt(strItemCode, nTradeSect, nQty, dAvgAmt, dCurrentPx);
end;

function TWRAX.RegistRealDataToMainLib(const strRealTrCode: WideString; const strKeyCode: WideString): Smallint;
begin
  Result := DefaultInterface.RegistRealDataToMainLib(strRealTrCode, strKeyCode);
end;

function TWRAX.UnregistRealDataToMainLib(nSBID: Smallint): WordBool;
begin
  Result := DefaultInterface.UnregistRealDataToMainLib(nSBID);
end;

function TWRAX.GetSiseDataFromMainLib(const strRealTrCode: WideString;
                                      const strKeyCode: WideString; var bIsFirstGet: WordBool;
                                      var strOutData: WideString): Integer;
begin
  Result := DefaultInterface.GetSiseDataFromMainLib(strRealTrCode, strKeyCode, bIsFirstGet,
                                                    strOutData);
end;

function TWRAX.GetAccountInfCount: Smallint;
begin
  Result := DefaultInterface.GetAccountInfCount;
end;

function TWRAX.GetAccountInf(nIndex: Smallint; var pszAccountNo: WideString;
                             var pszAccountName: WideString): Integer;
begin
  Result := DefaultInterface.GetAccountInf(nIndex, pszAccountNo, pszAccountName);
end;

function TWRAX.GetCMEAccountInfCount: Smallint;
begin
  Result := DefaultInterface.GetCMEAccountInfCount;
end;

function TWRAX.GetCMEAccountInf(nIndex: Smallint; var pszAccountNo: WideString;
                                var pszAccountName: WideString): Integer;
begin
  Result := DefaultInterface.GetCMEAccountInf(nIndex, pszAccountNo, pszAccountName);
end;

function TWRAX.SendEUREXNewOrder(const szAccNum: WideString; const szPassword: WideString;
                                 const szCode: WideString; nBuySell: Smallint;
                                 nOrderType: Smallint; nOrderQty: Smallint; dOrderPx: Double;
                                 nCustOrderKey: Smallint): WideString;
begin
  Result := DefaultInterface.SendEUREXNewOrder(szAccNum, szPassword, szCode, nBuySell, nOrderType,
                                               nOrderQty, dOrderPx, nCustOrderKey);
end;

function TWRAX.SendEUREXModiOrder(const szAccNum: WideString; const szPassword: WideString;
                                  const szCode: WideString; nBuySell: Smallint;
                                  nOrderType: Smallint; nOrderQty: Smallint; dOrderPx: Double;
                                  const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString;
begin
  Result := DefaultInterface.SendEUREXModiOrder(szAccNum, szPassword, szCode, nBuySell, nOrderType,
                                                nOrderQty, dOrderPx, szOriOrdNum, nCustOrderKey);
end;

function TWRAX.SendEUREXCancelOrder(const szAccNum: WideString; const szPassword: WideString;
                                    const szCode: WideString; nBuySell: Smallint;
                                    nOrderType: Smallint; nOrderQty: Smallint;
                                    const szOriOrdNum: WideString; nCustOrderKey: Smallint): WideString;
begin
  Result := DefaultInterface.SendEUREXCancelOrder(szAccNum, szPassword, szCode, nBuySell,
                                                  nOrderType, nOrderQty, szOriOrdNum, nCustOrderKey);
end;

procedure TWRAX.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TWRAX]);
end;

end.
