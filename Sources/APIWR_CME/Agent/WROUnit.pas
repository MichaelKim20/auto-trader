unit WROUnit;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls;

const
    ImportDLLFile = 'CommDll.dll';

    function RegisterHWD(ASocketWnd:HWND) : Integer; cdecl; external ImportDLLFile;

    function CommLogin(AUserID:PAnsiChar; AUserPW:PAnsiChar; ACertPW:PAnsiChar) : Integer; cdecl; external ImportDLLFile;
 
    procedure CommTerminate(ASocketClose:Integer = 1); cdecl; external ImportDLLFile
(*
	// 조회요청 함수 
    function RequestData(
                AHWND:HWND;
                ATRCode:PAnsiChar; 
                AData:PAnsiChar; 
                ADataSize:Integer; 
                ATimeOut:Integer = 30; 
                AEncrypt:Integer=0; 
                ACompress:Integer=0; 
                ADownLoad:Integer=0;
                AProgressType:Integer=-1;
                AWaitCursor:Integer=1;
                AMinorID:Byte=1) : Byte; cdecl; external ImportDLLFile;

    function GetMasterFileFromServer: Byte; cdecl; external ImportDLLFile;

	// 실시간 등록
    function CommSetBroad_Real(AHWND:HWND; ARealGubun:Byte; AKey:PAnsiChar) : Integer; cdecl; external ImportDLLFile;

	// 리얼 부분키 해제
    function CommRemoveBroad_Real(AHWND:HWND; ARealGubun:Byte; AKey:PAnsiChar) : Integer; cdecl; external ImportDLLFile;


	// 신규주문 : 화면핸들, 계좌번호, 계좌비밀번호,
	//            종목코드,매수/도(1,2),주문유형(일반1, STOP2),체결형태(2지정가,1시장가,STOP-Market,STOP-Limit)
	//            주문수량,주문가격(호가대로),Stop조건가격
	function SendNewOrder (
                AHWND:HWND; 
                AAccountNO:PAnsiChar; 
                AAccountPW:PAnsiChar; 
				ASymbol:PAnsiChar;
                ABuySell:Integer; 
			    AOrderType:Integer;
                AFillType:Integer;
                AOrderQty:Integer;
                AOrderPx:PAnsiChar;
                AStopOrderPx:PAnsiChar;
                ACustID:Integer=0) : PAnsiChar; cdecl; external ImportDLLFile;


	// 정정주문 : 화면핸들, 계좌번호, 계좌비밀번호,
	//            종목코드, 정정가격(마스크 씌운 값으로),원주문번호
	function SendModiOrder(
                AHWND:HWND;
                AAccountNO:PAnsiChar; 
                AAccountPW:PAnsiChar; 
				ASymbol:PAnsiChar;
                AModiOrderPx:PAnsiChar;
                AOrgOrdNm:PAnsiChar;
                ACustID:Integer=0) : PAnsiChar; cdecl; external ImportDLLFile;


	// 취소주문 : 화면핸들, 계좌번호, 계좌비밀번호,
	//            종목코드, 원주문번호
	function SendCancelOrder(
                AHWND:HWND;
                AAccountNO:PAnsiChar; 
                AAccountPW:PAnsiChar; 
				ASymbol:PAnsiChar;
                AOrgOrdNm:PAnsiChar;
                ACustID:Integer=0) : PAnsiChar; cdecl; external ImportDLLFile;

	// 우리선물 시세에 마스킹 씌워 주는 함수
	function ChangePriceStrToLong(ASymbol:PAnsiChar) : LongInt; cdecl; external ImportDLLFile;

	// 진법 품목의 시세(마스킹이 씌워져 있지 않은 상태)를 10진법 값으로 변환해 주는 함수
	function ChangePriceToDecimal(
                ASymbol:PAnsiChar; 
                APrice:LongInt) : Double; cdecl; external ImportDLLFile;

	// 10진법 값을 마스킹 없는 long으로 계산함
	function ChangePriceDecToLong(
                ASymbol:PAnsiChar; 
                APrice:Double) : LongInt; cdecl; external ImportDLLFile;

*)



implementation



end.
