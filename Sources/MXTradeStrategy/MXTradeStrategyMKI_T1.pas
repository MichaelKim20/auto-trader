unit MXTradeStrategyMKI_T1;

interface

uses
    SysUtils, Classes, MKChartData, MKChartDataSeries, MKLineValue, MKLineValueSeries, MXTSLineValueSeries, MXTradeStrategy;

type
    //---------------------------------------------------------------------------
    CMKGABData = class(TObject)
    public
        m_DateTime : TDateTime;
        m_Gab  : Double;
    end;
    //---------------------------------------------------------------------------

    //---------------------------------------------------------------------------
    CMKGABDataCollection = class(TObject)
    public
        m_Items : TList;

    public
        constructor Create;
        destructor  Destroy; override;

        procedure Clear();
        procedure Add(p_Data:CMKGABData);
        function FindNext(p_TimeDate:TDateTime) : CMKGABData;
        function Find(p_TimeDate:TDateTime) : CMKGABData;        
        procedure Sort;
    end;
    //---------------------------------------------------------------------------

    //---------------------------------------------------------------------------
    // 스토캐스틱 추세 1에 사용하는 보조지표와 신호를 계산하는 클래스
    //---------------------------------------------------------------------------
    CMXTradeStrategyMKI_T1 = class(CMXTradeStrategy)
    public
        //  생성자
        constructor Create();

        //  파괴자
        destructor  Destroy(); override;

        procedure Clear; override;

        //  계산을 시작한다.
        procedure Calculate(ARecalculation:Boolean); override;

        //  계산에 필요한 라인을 생성한다.
        procedure CreateLineValueSeries; override;

        //  신호를 계산한다.
        procedure CalulateSignal(p_Begin:Integer; p_End:Integer);


        procedure SetDailyGab(p_Date:TDateTime; p_Value:Double);

    private
        m_GABDataCollection : CMKGABDataCollection;

    end;
    //---------------------------------------------------------------------------

implementation

uses Math, MKGlobal, MKConst, MXTradeStrategyOptionCollection, MKColorSet, MKTradeStrategyConst;

//---------------------------------------------------------------------------
//  생성자
constructor CMXTradeStrategyMKI_T1.Create();
begin
    m_GABDataCollection := CMKGABDataCollection.Create;
    inherited Create;


    CMXTradeStrategyOption.Default_MKI_T1(m_Option);
    m_Category  := m_Option.GetStringValue ('CATEGORY');
    m_Name      := m_Option.GetStringValue ('NAME');
end;

//---------------------------------------------------------------------------
//  파괴자
destructor CMXTradeStrategyMKI_T1.Destroy();
begin
    inherited Destroy;

    m_GABDataCollection.Free;
end;

//---------------------------------------------------------------------------
procedure CMXTradeStrategyMKI_T1.Clear;
begin
    inherited Clear;
    m_GABDataCollection.Clear;
end;

//---------------------------------------------------------------------------
//  계산에 필요한 라인을 생성한다.
procedure CMXTradeStrategyMKI_T1.CreateLineValueSeries;
var
    f_LineValueSeries : CMXTSLineValueSeries;
begin
    DeleteLineValueSeries;
    Clear;

    //  첫번째 라인
    f_LineValueSeries := Creator_AnyLineValueSeries(1);
    f_LineValueSeries.m_TradeStrategy := true;
    f_LineValueSeries.m_TradeStrategyIndex[0] := -1;
    f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
    AddLineValueSeries(f_LineValueSeries);

    //  두번째 라인
    f_LineValueSeries := Creator_MajorLineValueSeries;
    f_LineValueSeries.m_TradeStrategy := true;
    f_LineValueSeries.m_TradeStrategyIndex[0] := -1;
    f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
    AddLineValueSeries(f_LineValueSeries);


    //  세번째 라인
    f_LineValueSeries := Creator_SlowSTC();
    f_LineValueSeries.m_Name := 'ST-MKI-T1-L1';
    f_LineValueSeries.m_TradeStrategy := true;
    f_LineValueSeries.m_TradeStrategyIndex[0] := 0;
    f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
    f_LineValueSeries.m_AbsoluteMaxMin := true;
    f_LineValueSeries.m_AbsoluteMax := 100;
    f_LineValueSeries.m_AbsoluteMin := 0;
    f_LineValueSeries.m_Values[0] := 20;
    f_LineValueSeries.m_Values[1] := 80;
    f_LineValueSeries.m_ValueColors[0] := 1;
    f_LineValueSeries.m_ValueColors[1] := 1;
    f_LineValueSeries.m_ValueEnables[0] := false;
    f_LineValueSeries.m_ValueEnables[1] := false;
    AddLineValueSeries(f_LineValueSeries);

    //  네번째 라인
    f_LineValueSeries := Creator_SignalLineValueSeries;
    f_LineValueSeries.m_Name := 'ST-MKI-T1-S1';
    f_LineValueSeries.m_TradeStrategy := true;
    f_LineValueSeries.m_TradeStrategyIndex[0] :=  1;
    f_LineValueSeries.m_TradeStrategyIndex[1] := -1;
    AddLineValueSeries(f_LineValueSeries);

    m_ChartBlockCount := 2;
end;

//---------------------------------------------------------------------------
//  계산을 시작한다.
procedure CMXTradeStrategyMKI_T1.Calculate(ARecalculation:Boolean);
var
    f_Begin, f_End : Integer;

    f_LineValueSeries : CMXTSLineValueSeries;

    f_LineValueSeries0 : CMXTSLineValueSeries;
    f_LineValueSeries1 : CMXTSLineValueSeries;
    f_LineValueSeries2 : CMXTSLineValueSeries;

begin
    inherited Calculate(ARecalculation);
    if not Assigned(m_ChartDataSeries) then exit;

    {$REGION '계산할 범위를 결정한다'}
    f_Begin := m_PriceLineValueSeries.m_Items.Count-1;
    f_End := m_ChartDataSeries.m_Items.Count;
    {$ENDREGION}

    {$REGION '가격선을 구축한다'}
    CMXTSLineValueSeries(m_PriceLineValueSeries).TS_MajorLine1(m_Option.GetIntegerValue(TSOPTION_KEY_MAJORVALUE), m_ChartDataSeries, CMXTSLineValueSeries(m_OPS2LineValueSeries), f_Begin, f_End);

    f_LineValueSeries1 := m_LineCollection.Items[1];
    f_LineValueSeries1.TS_MajorLine1(m_Option.GetIntegerValue(TSOPTION_KEY_MAJORVALUE), m_ChartDataSeries, CMXTSLineValueSeries(m_OPS2LineValueSeries), f_Begin, f_End);
    {$ENDREGION}

    f_LineValueSeries2 := m_LineCollection.Items[2];
    f_LineValueSeries2.m_Precision := m_ChartDataSeries.m_Precision;

    f_LineValueSeries2.m_Options[0] := m_Option.GetIntegerValue('LENGTH1');
    f_LineValueSeries2.m_Options[1] := m_Option.GetIntegerValue('LENGTH2');
    f_LineValueSeries2.m_Options[2] := m_Option.GetIntegerValue('LENGTH3');

    f_LineValueSeries2.TS_SlowSTC(
        m_Option.GetIntegerValue('LENGTH1'),
        m_Option.GetIntegerValue('LENGTH2'),
        m_Option.GetIntegerValue('LENGTH3'),
        m_PriceLineValueSeries, 1, 2, 3, 0, f_Begin, f_End);


    CalulateSignal(f_Begin, f_End);
    ApplyFilter(f_Begin, f_End);

    SetChartDataSeriesToLineSeries;
end;

//---------------------------------------------------------------------------
//  신호를 계산한다.
//---------------------------------------------------------------------------
procedure CMXTradeStrategyMKI_T1.CalulateSignal(p_Begin:Integer; p_End:Integer);
var
    f_Index:Integer;

    f_ChartData0:CMKChartData;
    f_ChartData1:CMKChartData;

    f_LineValue0:CMKLineValue;
    f_LineValue1:CMKLineValue;

    f_TLineValue0:CMKLineValue;
    f_TLineValue1:CMKLineValue;

    f_OLineValue0:CMKLineValue;
    f_OLineValue1:CMKLineValue;

    f_SourceLineValue0:CMKLineValue;
    f_SourceLineValue1:CMKLineValue;

    f_SigLineValue0:CMKLineValue;
    f_SigLineValue1:CMKLineValue;

    f_LineValueSeries0 : CMXTSLineValueSeries;
    f_LineValueSeries1 : CMXTSLineValueSeries;
    f_LineValueSeries2 : CMXTSLineValueSeries;
    f_SignalValueSeries0 : CMXTSLineValueSeries;

    f_GABData : CMKGABData;
    f_MajorValueType:Integer;

begin
    if not Assigned(m_ChartDataSeries) then exit;

    {$REGION '계산할 범위를 결정한다.'}
    if (p_Begin = -1) then p_Begin := 0;
    if (p_End = -1) then p_End := m_ChartDataSeries.m_Items.Count;
    if (p_End > m_ChartDataSeries.m_Items.Count) then p_End := m_ChartDataSeries.m_Items.Count;

    if (p_Begin > m_ChartDataSeries.m_Items.Count - 1) then p_Begin := m_ChartDataSeries.m_Items.Count - 1;
    if (p_Begin < 0) then p_Begin := 0;
    {$ENDREGION}

    {$REGION '보조지표의 객체를 연결'}
    f_LineValueSeries0   := m_LineCollection.Items[0];
    f_LineValueSeries1   := m_LineCollection.Items[1];
    f_LineValueSeries2   := m_LineCollection.Items[2];
    f_SignalValueSeries0 := m_LineCollection.Items[3];

    f_LineValueSeries0.SetLengthSeries(m_ChartDataSeries.m_Items.Count);
    f_SignalValueSeries0.SetLengthSeries(m_ChartDataSeries.m_Items.Count);
    {$ENDREGION}

    f_LineValueSeries2.m_Precision := m_ChartDataSeries.m_Precision;
    f_LineValueSeries2.m_Options[0] := m_Option.GetIntegerValue('LENGTH1');
    f_LineValueSeries2.m_Options[1] := m_Option.GetIntegerValue('LENGTH2');
    f_LineValueSeries2.m_Options[2] := m_Option.GetIntegerValue('LENGTH3');

    f_MajorValueType := m_Option.GetIntegerValue(TSOPTION_KEY_MAJORVALUE);

    for f_Index := p_Begin to p_End - 1 do
    begin
        f_OLineValue0   :=  m_PriceLineValueSeries.m_Items   [f_Index];
        f_TLineValue0   :=  f_LineValueSeries0.m_Items       [f_Index];
        f_ChartData0    :=  m_ChartDataSeries.m_Items        [f_Index];
        f_SigLineValue0     := f_SignalValueSeries0.m_Items  [f_Index];

        if (f_Index > 0) then
        begin
            f_OLineValue1   :=  m_PriceLineValueSeries.m_Items   [f_Index-1];
            f_TLineValue1   :=  f_LineValueSeries0.m_Items       [f_Index-1];
            f_ChartData1    :=  m_ChartDataSeries.m_Items        [f_Index-1];
            f_SigLineValue1     := f_SignalValueSeries0.m_Items  [f_Index-1];

            f_TLineValue0.m_Value[0]   := f_TLineValue1.m_Value[0];
            f_SigLineValue0.m_Value[0] := f_SigLineValue1.m_Value[0];

            if Trunc(f_ChartData0.m_OpenDateTime) <> Trunc(f_ChartData1.m_OpenDateTime) then
            begin
                f_TLineValue0.m_Value[0] := f_ChartData0.m_OpenPrice - f_ChartData1.m_ClosePrice;

                if (NIL = m_GABDataCollection.Find(Trunc(f_ChartData0.m_CloseDateTime))) then
                begin
                    f_GABData := CMKGABData.Create;
                    f_GABData.m_DateTime := f_ChartData0.m_CloseDateTime;
                    f_GABData.m_Gab := f_TLineValue0.m_Value[0];
                    m_GABDataCollection.Add(f_GABData);
                end;

                SetDailyGab(Trunc(f_ChartData1.m_OpenDateTime), f_TLineValue0.m_Value[0]);

                f_LineValueSeries2.Clear;
                f_LineValueSeries2.TS_SlowSTC(
                    Trunc(f_LineValueSeries2.m_Options[0]),
                    Trunc(f_LineValueSeries2.m_Options[1]),
                    Trunc(f_LineValueSeries2.m_Options[2]),
                    f_LineValueSeries1, 1, 2, 3, 0, 0, f_Index+1);

                f_SourceLineValue0  := f_LineValueSeries2.m_Items[f_Index];

                if (f_SigLineValue0.m_Value[0] <> STRATEGY_BUY) then
                begin
                    //  %K가 %D 상향돌파 => 매수
                    if (f_SourceLineValue0.m_Value[1] > f_SourceLineValue0.m_Value[2]) then
                    begin
                        f_SigLineValue0.m_Value[0] := STRATEGY_BUY;
                    end;
                end;
                if (f_SigLineValue0.m_Value[0] <> STRATEGY_SELL) then
                begin
                    //  %K가 %D 하향돌파 => 매도
                    if (f_SourceLineValue0.m_Value[1] < f_SourceLineValue0.m_Value[2]) then
                    begin
                        f_SigLineValue0.m_Value[0] := STRATEGY_SELL;
                    end;
                end;
            end;

        end else
        begin
            f_TLineValue0.m_Value[0] := 0;
            f_SigLineValue0.m_Value[0]:= STRATEGY_EXIT;
        end;

    end;
    f_SignalValueSeries0.m_Effect := true;
end;


//---------------------------------------------------------------------------
procedure CMXTradeStrategyMKI_T1.SetDailyGab(p_Date:TDateTime; p_Value:Double);
var
    f_Index:Integer;
    f_ChartData0:CMKChartData;
    f_OLineValue0:CMKLineValue;
    f_PLineValue0:CMKLineValue;
    f_TLineValue0:CMKLineValue;
    f_LineValueSeries0 : CMXTSLineValueSeries;
    f_LineValueSeries1 : CMXTSLineValueSeries;
begin
    {$REGION '보조지표의 객체를 연결'}
    f_LineValueSeries0   := m_LineCollection.Items[0];
    f_LineValueSeries1   := m_LineCollection.Items[1];
    {$ENDREGION}

    for f_Index := 0 to m_ChartDataSeries.m_Items.Count - 1 do
    begin
        f_OLineValue0   :=  m_PriceLineValueSeries.m_Items[f_Index];
        f_TLineValue0   :=  f_LineValueSeries0.m_Items[f_Index];
        f_PLineValue0   :=  f_LineValueSeries1.m_Items[f_Index];
        f_ChartData0    :=  m_ChartDataSeries.m_Items[f_Index];
        if Trunc(f_ChartData0.m_OpenDateTime) >= Trunc(p_Date) then
        begin
            f_PLineValue0.m_Value[0] := f_OLineValue0.m_Value[0] - f_TLineValue0.m_Value[0] + p_Value;
            f_PLineValue0.m_Value[1] := f_OLineValue0.m_Value[1] - f_TLineValue0.m_Value[0] + p_Value;
            f_PLineValue0.m_Value[2] := f_OLineValue0.m_Value[2] - f_TLineValue0.m_Value[0] + p_Value;
            f_PLineValue0.m_Value[3] := f_OLineValue0.m_Value[3] - f_TLineValue0.m_Value[0] + p_Value;
        end;
    end;
end;

{$REGION 'CMKGABDataCollection'}
//---------------------------------------------------------------------------
constructor CMKGABDataCollection.Create;
begin
    inherited Create;

    m_Items := TList.Create;
end;
//---------------------------------------------------------------------------
destructor  CMKGABDataCollection.Destroy;
begin
    Clear;

    m_Items.Free;
    m_Items := NIL;

    inherited Destroy;
end;
//---------------------------------------------------------------------------
procedure CMKGABDataCollection.Add(p_Data: CMKGABData);
begin
    m_Items.Add(p_Data);
end;

//---------------------------------------------------------------------------
procedure CMKGABDataCollection.Clear;
begin
    while 0 < m_Items.Count  do
    begin
        CMKGABData(m_Items.Items[0]).Free();
        m_Items.Delete(0);
    end;
end;

//---------------------------------------------------------------------------
function CMKGABDataCollection.Find(p_TimeDate: TDateTime): CMKGABData;
var
    f_PosX : Integer;
    f_PosL : Integer;
    f_PosR : Integer;
    f_RecordCount : Integer;
    f_Compare : Double;
    f_GABData : CMKGABData;
begin
    f_RecordCount := m_Items.Count;
    if 0 < f_RecordCount then
    begin
        f_PosL := 0;
        f_PosR := f_RecordCount - 1;

        repeat
            f_PosX := Math.floor((f_PosL + f_PosR) / 2);
            f_GABData := CMKGABData(m_Items.Items[f_PosX]);

            f_Compare := Trunc(p_TimeDate) - Trunc(f_GABData.m_DateTime);

            if (0 > f_Compare) then
                f_PosR := f_PosX - 1
            else
                f_PosL := f_PosX + 1;
        until (not ((f_Compare <> 0) and (f_PosL <= f_PosR)));

        if (0 = f_Compare) then
            Result := f_GABData
        else
            Result := NIL;
    end else
    begin
        Result := NIL;
    end;
end;

//---------------------------------------------------------------------------
function CMKGABDataCollection.FindNext(p_TimeDate: TDateTime): CMKGABData;
var
    f_PosX : Integer;
    f_PosL : Integer;
    f_PosR : Integer;
    f_RecordCount : Integer;
    f_Compare : Double;
    f_GABData : CMKGABData;
begin
    f_RecordCount := m_Items.Count;
    if 0 < f_RecordCount then
    begin
        f_PosL := 0;
        f_PosR := f_RecordCount - 1;

        repeat
            f_PosX := Math.floor((f_PosL + f_PosR) / 2);
            f_GABData := CMKGABData(m_Items.Items[f_PosX]);

            f_Compare := Trunc(p_TimeDate) - Trunc(f_GABData.m_DateTime);

            if (0 > f_Compare) then
                f_PosR := f_PosX - 1
            else
                f_PosL := f_PosX + 1;
        until (not ((f_Compare <> 0) and (f_PosL <= f_PosR)));

        if (0 = f_Compare) then
        begin
            f_PosX := f_PosX + 1;

            if (f_PosX >= f_RecordCount) then
            begin
                f_PosX := f_RecordCount - 1;
            end;

            f_GABData := CMKGABData(m_Items.Items[f_PosX]);
            Result := f_GABData;
        end else
        begin
            f_PosX := f_PosL;

            if (f_PosX >= f_RecordCount) then
            begin
                f_PosX := f_RecordCount - 1;
            end;

            f_GABData := CMKGABData(m_Items.Items[f_PosX]);
            Result := f_GABData;
        end;
    end else
    begin
        Result := NIL;
    end;
end;
          
//---------------------------------------------------------------------------
//비교함수이다. 여기서는 국가번호, 그룹번호, 거래소번호순으로 오름차순이다.
function CMP_CMKGABData(Item1, Item2: Pointer): Integer;
var
    f_Data1 : CMKGABData;
    f_Data2 : CMKGABData;
    f_Compare : Integer;
begin
    f_Compare := 0;

    f_Data1 := CMKGABData(Item1);
	f_Data2 := CMKGABData(Item2);

    if (0 = f_Compare) then f_Compare := Trunc(f_Data1.m_DateTime) - Trunc(f_Data2.m_DateTime);

    if (0 < f_Compare) then
        Result := 1
    else if (0 > f_Compare) then
        Result := -1
    else
        Result := 0;
end;             

//---------------------------------------------------------------------------
procedure CMKGABDataCollection.Sort;
begin   
    m_Items.Sort(@CMP_CMKGABData);
end;
{$ENDREGION}

end.

