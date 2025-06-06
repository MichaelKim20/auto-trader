unit H5MGREXLib_Const;

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;

const
    hf_INITH5MGR    =    99;		// lParam	  : product key(reg key) only ocx version
    hf_ENCRIPT	    =   100;		// HIWORD(wParam) : 0 - encrypt data(password...) by account no.
                                    //		    1 - encrypt data(password...) by user ID.
                                    // lParam	  : pass\tkey(userid or account no)

    hf_SIP		    =   101;	    // HIWORD(wParam) : 0 - real, 1 - stockgame
                                    // lParam : receive buffer

    hf_CONNECT	    =   102;		// HIWORD(wParam) : port
                                    // lParam : server ip

    hf_LOGIN	    =   103;		// HIWORD(wParam) : length
                                    // lParam : login struct
                                    //	struct	_signM {
                                    //		char	user[12];
                                    //		char	pass[8];
                                    //		char	optn[10];
                                    //		char	cpas[30];
                                    //		char	uips[15];
                                    //		char	madr[16];
                                    //	}

    hf_LOGOUT	    =   104;		// log out

    hf_ACCLIST	    =   105;		// lParam : receive buffer
                                    // 계좌\t계좌명\n계좌\t계좌명\n...

    hf_QUERYTR	    =   106;		// HIWORD(wParam) : length
                                    // lParam	  : struct _hfcallH + query data

    hf_DUALSIGN	    =   107;		// HIWORD(wParam) : port
                                    // lParam : server ip

    hf_OFFCASAVE	=   108;		// off save ca pass (Only uracle)

    hf_LOGINS 	    =   120;    	// staff login
                                    // HIWORD(wParam) : length
                                    // lParam : login struct

    US_ENC			=   $01;
    US_OOP			=   $02;
    US_PASS			=   $04;
    US_CA			=   $08;
    US_KEY			=   $10;		// userTH + DATAs[0] ... DATAs[0] -> user TRx key
    US_XRTM			=   $80;		// no RTM


    MAX_BUFFER	    =   1024*15;

const
    //
    //    CALLBACK function
    //        type   : event type
    //        wParam : detail information
    //        lParam : DATAs...
    //
    FEV_OPEN    =    0;         // axis connected
                                // zero  : success
                                // other : fail code
    FEV_CLOSE   =    1;         // axis closed
    FEV_RUN     =    2;         // axis/workstation start
                                // true  : axis update
                                // false : axis start
    FEV_SIZE    =    3;         // file size information
    FEV_VERS    =    4;         // screen version table

    FEV_ANM     =    5;         // alert message(tick, flash)
    FEV_AXIS    =    6;         // axis message
                                // LOWORD(wParam) : key
                                // HIWORD(wParam) : ...
    FEV_STAT    =    7;         // progress stat
                                // resource name, progress stat
    FEV_PUSH    =    8;         // push message

    FEV_ERROR   =    9;         // error, string
                                // LOWORD(wParam) : key
                                // HIWORD(wParam) : level
    FEV_GUIDE   =    10;        // guide, code
                                // LOWORD(wParam) : key

    FEV_FMX     =    20;        // request AXIS/Frame TRx
                                // LOWORD(nBytes), LOWORD(wParam) : key
                                // HIWORD(nBytes), HIWORD(wParam) : size

    FEV_CA      =    30;        // certify message
                                // LOWORD(wParam) : key
                                // HIWORD(wParam) : ...

    //    FEV_AXIS.key
    //    LOWORD(wParam)
    //
    loginERR           =     $99;   // type : HIWORD(wParam)
    runAXIS            =     $00;   //
    noticePAN          =     $0c;   // text : lParam
    dialogPAN          =     $0d;   // type : HIWORD(wParam), data  : lParam
    menuAXIS           =     $12;   // load menu
    closeAXIS          =     $14;   // terminate AXIS
                                    // reboot : HIWORD(wParam)
    runDUAL            =     $19;   // [DUAL-SESSION] : DualSession

    //    error code
    HE_ERR             =      -1;
    HE_OK              =       0;
    HE_EPRODUCT        =      10;   // No Setting product key
    HE_EPRODUCTINFO    =      11;   // Product information error.
    HE_GLBIP           =     101;   // GLB function call error
    HE_ESIGNON         =     102;   // SIGNON 수행시 서버 종료(#35)
    HE_INVALIDSVC      =     201;   // invalid service
    HE_INVALIDACC      =     202;   // invalid accout no

    TR_ORDER_START	    =      1;	// 주문 start key
    TR_ORDER_END	    =	 200;	// 주문 end key
    TR_FCODELIST	    =	 201;	// 선물코드리스트
    TR_OPCODELIST	    =	 202;	// 옵션코드리스트
    TR_ELWCODELIST	    =	 203;	// ELW 코드 리스트
    TR_MIJAN	        =	 204;	// 미결제 잔고
    TR_YMONEY	        =	 205;	// 예탁금조회
    TR_DEAL		        =	 206;	// 주문체결내역
    TR_ACCLIST	        =	 207;	// 계좌 리스트
    TR_PROG		        =	 208;	// 프로그램 매매동향
    TR_INVEST	        =	 209;	// 투자자별 매매동향
    TR_CHART	        =	 210;	// 챠트 분봉데이터
    TR_VGFACC	        =	 211;	// 계좌 리스트(모의 해외선물)
    TR_GFCODELIST	    =	 212;	// 해외선물 코드리스트
    TR_GFMIJAN	        =	 213;	// 미결제 잔고(GF)
    TR_GFYMONEY	        =	 214;	// 예탁금조회(GF)
    TR_GFDEAL	        =	 215;	// 주문체결내역(GF)
    TR_GFNEWORDER	    =	 220;	// 해외선물 신규주문
    TR_GFJJORDER	    =	 221;	// 해외선물 정정주문
    TR_GFCSORDER	    =	 222;	// 해외선물 취소주문
    TR_GFALLORDER	    =	 223;	// 해외선물 일괄청산

    TR_FSISE	        =	 231;	// 선물 시세
    TR_FHOGA	        =	 232;	// 선물 호가
    TR_OPSISE	        =	 233;	// 옵션 시세
    TR_OPHOGA	        =	 234;	// 옵션 호가
    TR_SSISE	        =	 235;	// 주식 시세
    TR_SHOGA	        =	 236;	// 주식 호가
    TR_GFSISE	        =	 237;	// 해외선물 시세
type

{$ALIGN 1}
    pTH5RQHead = ^TH5RQHead;
    TH5RQHead = record
        key             :   Array [0.. 1-1] of AnsiChar;    // receive key
        stat            :   Array [0.. 1-1] of AnsiChar;    //
        bizH            :   Array [0.. 1-1] of AnsiChar;    // 1 - ledgerH setting, else ledgerH no setting
        bizK            :   Array [0.. 6-1] of AnsiChar;    // if bizH[0] == '1', user data setting
        trx_Name        :   Array [0.. 8-1] of AnsiChar;    // Tx name : pibotuxq
        svc_Name        :   Array [0..10-1] of AnsiChar;    // service name
        job_cod         :   Array [0.. 1-1] of AnsiChar;    // '1' setting
        max_row         :   Array [0.. 3-1] of AnsiChar;    // if need, request data cnt
        next_key        :   Array [0..50-1] of AnsiChar;    // next_key, 	add 2013.01.30
        contf           :   Array [0.. 1-1] of AnsiChar;    // 연속거래구분 (0:정상, 1:연속거래) add 2013.02.15
    end;

    pTH5RPHead = ^TH5RPHead;
    TH5RPHead = record
        tran	:	Array [0.. 4-1] of AnsiChar;	//   0	tr_code			TR CODE(화면번호)
        svcn	:	Array [0..10-1] of AnsiChar;	//   4	svc_name		TUXEDO Service Name
        svr	    :	Array [0.. 2-1] of AnsiChar;    //  14	src_svr			Channel Server
                                                    //              T1:업무계, T2:Call Center, H1:HTS(영업점), H2:HTS(고객),  W1:Wrap
                                                    //				M1:MTS,    H3:WTS,         I1:인터넷뱅킹,  R1:ARS,        P1:011
                                                    //				P6:016,    P7:017,         P8:018,         P9:019,        N1:AirPost
                                                    //				N2:Micess, K1:방카,        X1:CRM,         E1:ERP,        Z1:RM
                                                    //				N3:PDA,    B1:은행(CD),    B2:은행(기타),  C1:현금지급기, D1:시스템
                                                    //				F1:FIX,    I2:홈페이지
        pgm	    :	Array [0.. 8-1] of AnsiChar;    //  16	pgm_id			Program ID

        idno	:	Array [0..12-1] of AnsiChar;	//  24	id_no			사번
        regno	:	Array [0..13-1] of AnsiChar;	//  36	reg_no			사용자 주민등록번호
        group	:	Array [0.. 2-1] of AnsiChar;	//  49	emp_grp			사용자 그룹
        open	:	Array [0.. 3-1] of AnsiChar;	//  51	open_dept		소속점
        dept	:	Array [0.. 3-1] of AnsiChar;	//  54	dept_cd			부서 (처리점)
        term	:	Array [0.. 8-1] of AnsiChar;	//  57	term_id			단말기번호
        ips	    :	Array [0..15-1] of AnsiChar;	//  65	ip_no			IP Address

        media	:	Array [0.. 1-1] of AnsiChar;	//  80	mdr_cd			입력매체구분 (0:수기, 1:카드, 2:통장, 3:책임자카드)
        gubn	:	Array [0.. 1-1] of AnsiChar;	//  81	job_cd			작업구분 (1:Query, 2:Insert, 3:Update, 4:Delete)
        rows	:	Array [0.. 3-1] of AnsiChar;	//  82	max_row			GRID MAX ROW
        book	:	Array [0..10-1] of AnsiChar;	//  85	book_seq		통장번호
        card	:	Array [0.. 8-1] of AnsiChar;	//  95	card_seq		카드일련번호
        report	:	Array [0.. 1-1] of AnsiChar;	// 103	rpt_tool_use_cd 레포팅툴 사용구분 (0:TR, 1:Use Tool)

        optp	:	Array [0.. 1-1] of AnsiChar;	// 104	mgr_appr_tp		책임자 승인구분 (0:발생전, 1:대상 및 요청, 2:승인, 3:취소)
        opid	:	Array [0.. 5-1] of AnsiChar;	// 105	mgr_appr_empno  승인 책임자 사번
        optm	:	Array [0.. 8-1] of AnsiChar;	// 110	mgr_appr_term_id책임자승인단말번호
        opno	:	Array [0.. 5-1] of AnsiChar;	// 118	mgr_appr_seqno	책임자 승인번호
        opn	    :	Array [0.. 1-1] of AnsiChar;    // 123	mgr_appr_cnt	책임자승인건수
        opgb	:	Array [0.. 1-1] of AnsiChar;	// 124	mgr_job_cd		책임자 업무구분
        opcd	:	Array [0.. 1-1] of AnsiChar;	// 125	mgr_card_cd		책임자카드구분 (1:지점장, 3:책임자)

        func	:	Array [0.. 1-1] of AnsiChar;	// 126	tr_fnkey		처리기능구분(사용자 지정)
        ecode	:	Array [0.. 6-1] of AnsiChar;	// 127	tr_err_code		에러코드
        etype	:	Array [0.. 1-1] of AnsiChar;	// 133	tr_err_cd		에러구분 (0:상태바, 1:메세지박스, 3:메세지처리없음)
        msg	    :	Array [0..130-1] of AnsiChar;	// 134	tr_err_msg		에러메시지
        contf	:	Array [0.. 1-1] of AnsiChar;	// 264	tr_cont_yn		연속거래구분 (0:정상, 1:연속거래)

        nrec	:	Array [0.. 4-1] of AnsiChar;	// 265	tr_cnt			처리건수
        keys	:	Array [0.. 6-1] of AnsiChar;	// 269	lst_key			row 처리 last key
        next	:	Array [0..50-1] of AnsiChar;	// 275	next_key		next key
        svcno	:	Array [0.. 4-1] of AnsiChar;	// 325	svc_no			service no
        mts	    :	Array [0.. 5-1] of AnsiChar;    // 329	mts_key			mts key

        rsv	    :	Array [0..60-1] of AnsiChar;
        apik	:	Array [0.. 6-1] of AnsiChar;
    end;

    TSignM = record
		user            :   Array [0.. 12-1] of AnsiChar;
		pass            :   Array [0..  8-1] of AnsiChar;
		cpas            :   Array [0.. 30-1] of AnsiChar;
		sips            :   Array [0.. 16-1] of AnsiChar;
	end;

    pTPIBOFODR = ^TPIBOFODR;
    TPIBOFODR = record
	    rcnt    :   Array [0.. 4-1] of AnsiChar;	// 처리건수 : 1 setting
	    odgb    :   Array [0.. 1-1] of AnsiChar;	// 주문유형 : 1 - 일반(위탁, 저축), 2 - 선물옵션
	    mkgb    :   Array [0.. 1-1] of AnsiChar;	// 시장구분 : 1 - 거래소, 2 - 코스닥, 3 - 프리보드, 5 - 장외
	    mmgb    :   Array [0.. 1-1] of AnsiChar;	// 매매구분 : 1 - 매도, 2 - 매수, 3 - 정정, 4 - 취소
	    acno    :   Array [0..10-1] of AnsiChar;	// 계좌번호
	    pswd    :   Array [0.. 8-1] of AnsiChar;	// 비밀번호
	    ogno    :   Array [0..12-1] of AnsiChar;	// 원주문번호 : 정정/취소 주문시
	    code    :   Array [0..12-1] of AnsiChar;	// 종목코드
	    jqty    :   Array [0.. 8-1] of AnsiChar;	// 주문수량
	    jprc    :   Array [0..10-1] of AnsiChar;	// 주문단가 : 선물옵션의 경우 100배수 처리 ex) 112.13 -> 11213
	    hogb    :   Array [0.. 2-1] of AnsiChar;	// 호가 구분
		                                            // ** 일반매매
		                                            // 00: 지정가 03: 시장가 05: 조건부지정가 06: 최유리지정가
		                                            // 07: 최우선지정가
		                                            // 61: 장개시전시간외 81: 시간외종가 91:시간외단일가
		                                            // 99: 원주문호가(정정주문시 사용)
	    jmgb    :   Array [0.. 2-1] of AnsiChar;	// 주문조건 : 01 - IOC, 02 - FOK
	    mdgb    :   Array [0.. 1-1] of AnsiChar;	// 정정취소 : 1 - 일부, 2 - 전부
	    prgb    :   Array [0.. 1-1] of AnsiChar;	// 처리구분 : no use 'X' setting
	end;

    pTPIBOFODR_OUT = ^TPIBOFODR_OUT;
    TPIBOFODR_OUT = record
	    rcnt    :   Array [0.. 4-1] of AnsiChar;
	    jmno    :   Array [0.. 6-1] of AnsiChar;
	    mono    :   Array [0.. 6-1] of AnsiChar;
	    omsg    :   Array [0..80-1] of AnsiChar;
	end;
{$ALIGN 8}

implementation

end.
