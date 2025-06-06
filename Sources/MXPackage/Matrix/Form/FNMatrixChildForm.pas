unit FNMatrixChildForm;

interface

uses
    Contnrs, SysUtils, StrUtils, Classes, SyncObjs, Forms, ExtCtrls, Windows, Messages,
    FNDefine, FNThread, FNQueue, FNDataSet, FNDataDelivery,
    FNDataObject, FNPOTArray, FNSymbolArray, FNSymbolData;

type

    CFNMatrixChildForm = class(TForm)
    public
    protected
        m_DataDelivery : CFNDataDelivery;

        //스트리밍, 조회 데이터 수신 이벤트 상속받은 클래스에서 오버라이드해야한다.
	    procedure OnReply(ADataPackage:CFNDataPackage); virtual;
	    procedure OnStream(AStreamRecord:CFNStreamRecord); virtual;

        procedure WMReply(var Message: TMessage); message WM_REPLY_EVENT;
        procedure WMStream(var Message: TMessage); message WM_STREAM_EVENT;

    public
        constructor Create(AOwner:TComponent); override;
        destructor Destroy; override;

        //윈도 메세지 처리
        procedure WMChildProcess(var Message: TMessage); message WM_CHILD_PROCESS;

    private

	    // CFNMatrixChildForm 에 포함된 넌비주얼 컴포넌터인 CFNDataDelivery에서 발생한 OnReply을 처리하기 위해 생성한 이벤트함수이다.
	    // 이 함수는 조회성 요청의 응답데이터를 반환한다.
	    procedure _OnReplyEvent(ADataPackage:CFNDataPackage; var AutoFree:Boolean);
	    // CFNMatrixChildForm 에 포함된 넌비주얼 컴포넌터인 CFNDataDelivery에서 발생한 OnStream을 처리하기 위해 생성한 이벤트함수이다.
	    // 이 함수는 스트리밍으로 전달받은 데이터를 반환한다.
	    procedure _OnStreamEvent(AStreamRecord:CFNStreamRecord);

    end;

implementation
uses
    FNSocketManager, FNGlobal, FNCommonVariable;

/////////////////////////////////////////////////////////////////////////////
//CFNMatrixChildForm
//---------------------------------------------------------------------------
constructor CFNMatrixChildForm.Create(AOwner:TComponent);
begin
    inherited Create(AOwner);
    m_DataDelivery := CFNDataDelivery.Create;
    m_DataDelivery.OnStreamEvent := _OnStreamEvent;   //스트리밍 수신 이벤트 등록
    m_DataDelivery.OnReplyEvent := _OnReplyEvent;     //조회성 데이터 수신 이벤트 등록
end;

//---------------------------------------------------------------------------
destructor CFNMatrixChildForm.Destroy;
begin
    if Assigned(m_DataDelivery) then
    begin
        if Assigned(g_AgentManager) then g_AgentManager.UnSubscribeAll(m_DataDelivery);
        if Assigned(g_OPSSocketManager) then g_OPSSocketManager.UnSubscribeAll(m_DataDelivery);
        if Assigned(g_OPSAgentManager) then g_OPSAgentManager.UnSubscribeAll(m_DataDelivery);
        m_DataDelivery.Free;
        m_DataDelivery := NIL;
    end;
    inherited Destroy;
end;

//---------------------------------------------------------------------------
//  CFNMatrixChildForm 에 포함된 넌비주얼 컴포넌터인 CFNDataDelivery에서 발생한 OnReply을 처리하기 위해 생성한 이벤트함수이다.
//  이 함수는 조회성 요청의 응답데이터를 반환한다.
procedure CFNMatrixChildForm._OnReplyEvent(ADataPackage:CFNDataPackage; var AutoFree:Boolean);
begin
    AutoFree := false;
    //StoreRecvData(ADataPackage);
    PostMessage(Handle, WM_REPLY_EVENT, 0, UINT(ADataPackage));
end;

//---------------------------------------------------------------------------
//  CFNMatrixChildForm 에 포함된 넌비주얼 컴포넌터인 CFNDataDelivery에서 발생한 OnStream을 처리하기 위해 생성한 이벤트함수이다.
//  이 함수는 스트리밍으로 전달받은 데이터를 반환한다.
procedure CFNMatrixChildForm._OnStreamEvent(AStreamRecord:CFNStreamRecord);
begin
    PostMessage(Handle, WM_STREAM_EVENT, 0, UINT(AStreamRecord));
end;

//---------------------------------------------------------------------------
//윈도 메세지 처리
procedure CFNMatrixChildForm.WMChildProcess(var Message: TMessage);
begin

end;

//---------------------------------------------------------------------------
procedure CFNMatrixChildForm.WMReply(var Message: TMessage);
var
    f_DataPackage:CFNDataPackage;
begin
    f_DataPackage := CFNDataPackage(Message.LParam);
    if Assigned(f_DataPackage) then
    begin
        OnReply(f_DataPackage);
        f_DataPackage.Free;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixChildForm.WMStream(var Message: TMessage);
var
    f_StreamRecord:CFNStreamRecord;
begin
    f_StreamRecord := CFNStreamRecord(Message.LParam);
    if Assigned(f_StreamRecord) then
    begin
        OnStream(f_StreamRecord);
        f_StreamRecord.DecreaseReferenceCount;
    end;
end;

//---------------------------------------------------------------------------
procedure CFNMatrixChildForm.OnReply(ADataPackage: CFNDataPackage);
begin

end;

//---------------------------------------------------------------------------
procedure CFNMatrixChildForm.OnStream(AStreamRecord: CFNStreamRecord);
begin

end;


end.
