unit FNASSLoadDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, IniFiles, DCPsha1, DCPrc4, FNDataDelivery, FNDataSet;

type
//---------------------------------------------------------------------------
    TASSLoadDlg = class(TForm)
    TimerAutoRun: TTimer;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerAutoRunTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    private
		m_DataDelivery:CFNDataDelivery;
        m_IDataPackage:CFNDataPackage;
        m_ODataPackage:CFNDataPackage;

        procedure Request;
        procedure OnReply(ADataPackage: CFNDataPackage; var AutoFree:Boolean);
    private
        m_Message:String;

		procedure OnLoadComplete;
		procedure OnLoadFault;

    public

        m_ASS_DATECOUNT4        :   Integer;
        m_ASS_PERCENT_PROFITABLE:   Double;
        m_ASS_PROFIT_FACTOR     :   Double;
        m_ASS_MAXDRAWDOWN       :   Double;
        m_ASS_TYPE              :   Integer;
    end;

var
  ASSLoadDlg: TASSLoadDlg;

implementation

uses FNCMVariable, FNRegistry, CommonTRMaker, FNASSData, FNASSArray;

{$R *.dfm}
//---------------------------------------------------------------------------
procedure TASSLoadDlg.FormCreate(Sender: TObject);
begin
    m_DataDelivery := CFNDataDelivery.Create;
    m_DataDelivery.OnReplyEvent := OnReply;     //조회성 데이터 수신 이벤트 등록

    m_IDataPackage:=CFNDataPackage.Create;
    m_ODataPackage:=CFNDataPackage.Create;

    TimerAutoRun.Enabled := true;
end;


procedure TASSLoadDlg.TimerAutoRunTimer(Sender: TObject);
begin
    TimerAutoRun.Enabled := false;
    Request;
end;

//---------------------------------------------------------------------------
procedure TASSLoadDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if Assigned(m_DataDelivery) then
    begin
        m_DataDelivery.Free;
        m_DataDelivery := NIL;
    end;
    m_IDataPackage.Free;
    m_ODataPackage.Free;
    Action := caFree;
end;
//---------------------------------------------------------------------------

procedure TASSLoadDlg.Request;
var
    f_Record:CFNRecord;
begin
    f_Record := CFNRecord.Create;
    f_Record.SetIntegerValue('DATECOUNT4'           , m_ASS_DATECOUNT4);
    f_Record.SetDoubleValue ('PERCENT_PROFITABLE'   , m_ASS_PERCENT_PROFITABLE);
    f_Record.SetDoubleValue ('PROFIT_FACTOR'        , m_ASS_PROFIT_FACTOR);
    f_Record.SetDoubleValue ('MAXDRAWDOWN'          , m_ASS_MAXDRAWDOWN);
    f_Record.SetIntegerValue('TYPE'                 , m_ASS_TYPE);

    Make_SC_ASS_TR_0010_IN(m_IDataPackage, f_Record);
    g_OPSAgentManager.Request(m_DataDelivery, m_IDataPackage);
end;
//-----------------------------------------------------------------------------
procedure TASSLoadDlg.OnReply(ADataPackage: CFNDataPackage; var AutoFree:Boolean);
var
    f_Record            : CFNRecord;
    f_Index             : Integer;
    f_DataSet1          : CFNDataSet;
    f_ASSData      : CFNASSData;
begin
    m_ODataPackage.Clone(ADataPackage);
    if m_ODataPackage.GetServiceID = 'SC_ASS' then
    begin
        if m_ODataPackage.GetTRCode = 'TR_0010' then
        begin
            if (m_ODataPackage.GetMsgCode <> 'M00000') then
            begin
                m_Message := '로딩을 완료하지 못했습니다.';
                OnLoadFault;
            end else
            begin
                g_ASSArray.Clear;
                f_DataSet1 := m_ODataPackage.GetDataSet(DATASETID_OUT_01);
                if Assigned(f_DataSet1) and (0 < f_DataSet1.RecordList.Count) then
                begin
                    for f_Index := 0 to f_DataSet1.RecordList.Count - 1 do
                    begin
                        f_Record := CFNRecord(f_DataSet1.RecordList.Items[f_Index]);

                        f_ASSData := CFNASSData.Create;
                        f_ASSData.ArrayToData(f_Record);

                        g_ASSArray.Add(f_ASSData);
                    end;
                    m_Message := '정상적으로 로딩을 완료하였습니다.';
                    OnLoadComplete;
                end else
                begin
                    m_Message := '로딩을 완료하지 못했습니다.';
                    OnLoadFault;
                end;
            end;
        end;
    end;
end;


procedure TASSLoadDlg.OnLoadComplete;
begin
    Label1.Caption := m_Message;
    Label1.Update;
    Close();
end;

//-----------------------------------------------------------------------------
procedure TASSLoadDlg.OnLoadFault;
begin
    Label1.Caption := m_Message;
    Label1.Update;
    Close();
end;

end.
