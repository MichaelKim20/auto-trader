unit FNMainFunction;

interface
    procedure DoBackTesting;
    procedure DoAnalysisBuySell;
    procedure DoDailyReport;
    procedure DoSort;

implementation

uses
    SysUtils, FNGlobal,  FNCMDBackTesting, FNCMDAnlysisBuySell, FNCMDDailyReport, FNCMDSort;


procedure DoBackTesting;
var
    f_CmdBackTesting:CFNCMDBackTesting;
    f_StartDate:String;
    f_EndDate:String;
    f_ThreadCount:Integer;
    f_AttachMode:Boolean;
begin
    if ParamCount >= 5 then
    begin
        f_ThreadCount := TFNGlobal.atoi(ParamStr(5));
        f_AttachMode := false;
        if ParamCount >= 6 then
        begin
            if AnsiCompareText(ParamStr(6), 'A') = 0 then
            begin
                f_AttachMode := true;
            end;
        end;

        f_CmdBackTesting := CFNCMDBackTesting.Create(f_ThreadCount);

        try
            f_StartDate := ParamStr(2);
            f_EndDate := ParamStr(3);
            f_CmdBackTesting.StartDate := TFNGlobal.StringToDateTime(f_StartDate);
            f_CmdBackTesting.EndDate := TFNGlobal.StringToDateTime(f_EndDate);
            f_CmdBackTesting.ConfigFolder := ParamStr(4);
            f_CmdBackTesting.AttachMode := f_AttachMode;

            f_CmdBackTesting.Run;
        finally
            f_CmdBackTesting.Free;
        end;
    end else
    begin
        WriteLn('파라메터의 갯수가 모자랍니다.');
        WriteLn('1 : 명령어');
        WriteLn('2 : 시작일자');
        WriteLn('3 : 마감일자');
        WriteLn('4 : 매매조건이 저장된 폴더명');
        WriteLn('5 : 병렬 계산할 갯수');
    end;

end;

procedure DoAnalysisBuySell;
var
    f_CMDAnlysisBuySell:CFNCMDAnlysisBuySell;
    f_StartDate:String;
    f_EndDate:String;
    f_InputFileName:String;
    f_Symbol:String;
    f_MA:Integer;
    f_DType:Integer;
begin
    if ParamCount >= 10 then
    begin
        try
            f_CMDAnlysisBuySell := CFNCMDAnlysisBuySell.Create;
            f_StartDate := ParamStr(2);
            f_EndDate := ParamStr(3);
            f_InputFileName := ParamStr(4);
            f_Symbol := ParamStr(5);
            f_MA := TFNGlobal.atoi(ParamStr(6));
            f_DType := TFNGlobal.atoi(ParamStr(7));

            f_CMDAnlysisBuySell.m_StartDate := TFNGlobal.StringToDateTime(f_StartDate);
            f_CMDAnlysisBuySell.m_EndDate := TFNGlobal.StringToDateTime(f_EndDate);
            f_CMDAnlysisBuySell.m_InputFileName := f_InputFileName;
            f_CMDAnlysisBuySell.m_Symbol := f_Symbol;
            f_CMDAnlysisBuySell.m_MA := f_MA;
            f_CMDAnlysisBuySell.m_DType := f_DType;
            f_CMDAnlysisBuySell.m_DataSource := ParamStr(8);
            f_CMDAnlysisBuySell.m_UserID := ParamStr(9);
            f_CMDAnlysisBuySell.m_Password := ParamStr(10);

            f_CMDAnlysisBuySell.Analysis;
        finally
            f_CMDAnlysisBuySell.Free;
        end;

    end else
    begin
        WriteLn('파라메터의 갯수가 모자랍니다.');
        WriteLn('1 : 명령어');
        WriteLn('2 : 시작일자');
        WriteLn('3 : 마감일자');
        WriteLn('4 : 입력파일명');
        WriteLn('5 : 종목코드');
        WriteLn('6 : MA입력값');
        WriteLn('7 : 전일데이터사용방식');
    end;
end;

procedure DoDailyReport;
var
    f_CMDDailyReport:CFNCMDDailyReport;
begin
    if ParamCount >= 10 then
    begin
        try
            f_CMDDailyReport := CFNCMDDailyReport.Create;

            f_CMDDailyReport.m_StartDate        := TFNGlobal.StringToDateTime(ParamStr(2));
            f_CMDDailyReport.m_EndDate          := TFNGlobal.StringToDateTime(ParamStr(3));
            f_CMDDailyReport.m_InputFileName    := Trim(ParamStr(4));

            f_CMDDailyReport.m_DataSource       := ParamStr(5);
            f_CMDDailyReport.m_UserID           := ParamStr(6);
            f_CMDDailyReport.m_Password         := ParamStr(7);

            f_CMDDailyReport.m_StoredProcedure  := ParamStr(8);

            f_CMDDailyReport.m_Condition        := ParamStr(9);
            f_CMDDailyReport.m_TimeFrame        := TFNGlobal.atoi(ParamStr(10));

            if ParamCount >= 11 then
            begin
                f_CMDDailyReport.m_Unit        := TFNGlobal.atof(ParamStr(11));
            end else
            begin
                f_CMDDailyReport.m_Unit        := 1;
            end;


            f_CMDDailyReport.Analysis;
        finally
            f_CMDDailyReport.Free;
        end;

    end else
    begin
        WriteLn('파라메터의 갯수가 모자랍니다.');
        WriteLn('1 : 명령어');
        WriteLn('2 : 시작일자');
        WriteLn('3 : 마감일자');
        WriteLn('4 : 입력파일명');
    end;
end;

procedure DoSort;
var
    f_CMDSort:CFNCMDSort;
begin
    if ParamCount >= 3 then
    begin
        try
            f_CMDSort := CFNCMDSort.Create;
            f_CMDSort.m_InputFileName   := Trim(ParamStr(2));
            f_CMDSort.m_OutFileName   := Trim(ParamStr(3));
            f_CMDSort.Analysis;
        finally
            f_CMDSort.Free;
        end;

    end else
    begin
        WriteLn('파라메터의 갯수가 모자랍니다.');
        WriteLn('1 : 입력파일명');
        WriteLn('2 : 출력파일명');
    end;
end;

end.
