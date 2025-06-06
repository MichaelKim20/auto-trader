unit FNCMDBackTesting;

interface

uses
    Windows, Math, SysUtils, Classes, ExtCtrls, SyncObjs, FNQueue, FNThread, FNTradeSystem, MXBlock, FNCalcBackTesting;

type
    CFNCMDBackTesting = class(TObject)
    private
        m_State : Integer;
        m_StartDate : TDateTime;
        m_EndDate : TDateTime;
        m_ConfigFolder : String;
        m_AttachMode : Boolean;

        m_FileList : TStringList;
        m_BlockCollection:CMXBlockDataCollection;

        m_CalcItem:TList;

    public
        constructor Create(ACount:Integer = 5);
        destructor Destroy; override;
        procedure ClearCalcItem;
        procedure Run;

        property StartDate:TDateTime read m_StartDate write m_StartDate;
        property EndDate:TDateTime read m_EndDate write m_EndDate;
        property ConfigFolder:String read m_ConfigFolder write m_ConfigFolder;
        property AttachMode:Boolean read m_AttachMode write m_AttachMode;
        property State:Integer read m_State;
    end;

implementation

{ CFNCMDBackTesting }

procedure GetSearchedFileList(sPath : String;
                              slFileList : TStringList;
                              sWildStr : string;
                              bSchSubFolder : Bool);
var
    sTempPath : String;
    SchRec : TSearchRec;
    iSchRec : integer;
begin
    // 뒤에 '\' 붙이기
    if sPath[length(sPath)] <> '\' then sPath := sPath + '\';

    // 와일드 카드 설정
    if (sWildStr = '') or (bSchSubFolder = true) then
    begin
        sTempPath := sPath + '*.*';
    end else
    begin
        sTempPath := sPath + sWildStr;
    end;

    iSchRec := FindFirst(sTempPath, faAnyFile or faDirectory, SchRec);
    while (iSchRec = 0) do
    begin
        // '.', '..' 폴더는 제외
        if not ((SchRec.Name = '.') or (SchRec.Name = '..')) then
        begin
            // 폴더가 아닌 것
            if (SchRec.Attr and faDirectory) = 0 then
            begin
                // 와일드카드를 설정하고 서브폴더 밑도 검색할 경우
                if (bSchSubFolder = true) and
                   ((sWildStr <> '') or (sWildStr <> '*.*')) then
                begin
                  // 수동 필터링 : *.확장자만 지원 / '?'는 지원안함
                  if ExtractFileExt(SchRec.Name) = ExtractFileExt(sWildStr) then
                    slFileList.add(sPath + SchRec.Name);
                end
                // 일반적인 경우 : 서브폴더 밑 검색안함
                else
                  slFileList.add(sPath + SchRec.Name);
            end
            // 폴더인 경우
            else
            begin
                // 폴더 안에 파일도 검색하는 경우
                if bSchSubFolder = true then
                begin
                // 파일 검색 함수 : 재귀호출
                GetSearchedFileList(sPath + SchRec.Name + '\',
                              slFileList, sWildStr, bSchSubFolder);
                end;
            end;
        end;
        iSchRec := FindNext(SchRec);
    end;
    FindClose(SchRec);
end;

//---------------------------------------------------------------------------
constructor CFNCMDBackTesting.Create(ACount:Integer = 5);
var
    f_Index:Integer;
    f_CalcBT:CFNCalcBackTesting;
begin
    m_BlockCollection := CMXBlockDataCollection.Create;
    m_FileList := TStringList.Create;

    m_CalcItem := TList.Create;
    m_State := 0;
    m_AttachMode := false;

    for f_Index := 0 to ACount - 1 do
    begin
        f_CalcBT := CFNCalcBackTesting.Create;
        m_CalcItem.Add(f_CalcBT);
    end;

end;

//---------------------------------------------------------------------------
destructor CFNCMDBackTesting.Destroy;
begin
    if m_BlockCollection <> NIL then m_BlockCollection.Free;
    m_BlockCollection := NIL;

    if m_FileList <> NIL then m_FileList.Free;
    m_FileList := NIL;

    ClearCalcItem;
    if m_CalcItem <> NIL then m_CalcItem.Free;
    m_CalcItem := NIL;
    m_State := 0;
    inherited;
end;

//------------------------------------------------------------------------------------
procedure CFNCMDBackTesting.ClearCalcItem;
begin

    while 0 < m_CalcItem.Count  do
    begin
        CFNCalcBackTesting(m_CalcItem.Items[0]).Free;
        m_CalcItem.Delete(0);
    end;
end;

//---------------------------------------------------------------------------
procedure CFNCMDBackTesting.Run;
var
    f_Index:Integer;
    f_Block:CMXBlockData;

    f_CalcIndex:Integer;
    f_CalcBT:CFNCalcBackTesting;
    f_Done : Boolean;
begin
    m_State := 1;
    GetSearchedFileList(m_ConfigFolder, m_FileList, '*.xml', false);

    for f_Index := 0 to m_FileList.Count - 1 do
    begin
        WriteLn(m_FileList[f_Index]);
        WriteLn('[ '+ m_FileList[f_Index] + ' ] 해당 설정파일에서 매매조건을 읽어 옵니다.');
        m_BlockCollection.Load(m_FileList[f_Index], false);
    end;

    f_CalcIndex := 0;

    while (true) do
    begin
        if f_CalcIndex < m_BlockCollection.m_Items.Count then
        begin
            f_Block := m_BlockCollection.m_Items[f_CalcIndex];

            try
                for f_Index := 0 to m_CalcItem.Count - 1 do
                begin
                    f_CalcBT := CFNCalcBackTesting(m_CalcItem.Items[f_Index]);

                    if not f_CalcBT.Doing then
                    begin
                        WriteLn('[ '+ f_Block.BlockName +  '_' +  IntToStr(f_Block.Option.GetIntegerValue('TIMEFRAME')) + ' ] 해당 조건에 대한 계산을 시작합니다.');
                        f_CalcBT.SetBlockData(f_Block);
                        f_CalcBT.StartDate := m_StartDate;
                        f_CalcBT.EndDate := m_EndDate;
                        f_CalcBT.AttachMode := AttachMode;
                        f_CalcBT.Start;
                        Inc(f_CalcIndex);
                        break;
                    end;
                end;
            finally
            end;

        end;

        for f_Index := 0 to m_CalcItem.Count - 1 do
        begin
            f_CalcBT := CFNCalcBackTesting(m_CalcItem.Items[f_Index]);

            if f_CalcBT.Doing and f_CalcBT.m_NextDay then
            begin
                f_CalcBT.DoStart1Day;
            end;
        end;


        Sleep(100);

        if (f_CalcIndex >= m_BlockCollection.m_Items.Count) then
        begin
            //  모두 종료 될때 까지 기다린다.
            f_Done := true;
            for f_Index := 0 to m_CalcItem.Count - 1 do
            begin
                f_CalcBT := CFNCalcBackTesting(m_CalcItem.Items[f_Index]);
                if f_CalcBT.Doing then
                begin
                    f_Done := false;
                    break;
                end;
            end;

            if f_Done then break;
        end;

    end;

    m_State := 1;
end;

//---------------------------------------------------------------------------
end.


