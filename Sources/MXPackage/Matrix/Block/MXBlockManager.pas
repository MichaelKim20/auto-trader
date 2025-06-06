unit MXBlockManager;

interface

uses
  XMLIntf, xmldom, msxmldom, XMLDoc, SysUtils, Classes, SyncObjs, ExtCtrls,
  FNThread,
  MKStreamChartDataSeries, FNMatrixLineValueSeries;

type

  CMXBlockManagerCondition = class(TObject)
  public
    m_PortfolioGroupName: String;
    m_PortfolioName: String;

    m_UsePLC1: Boolean;
    m_PLC1_V: Array [0 .. 5] of Double;
    m_PLC1_D: Array [0 .. 5] of Double;
    m_PLC1_A: Array [0 .. 5] of Boolean;

    m_UseEnterA: Boolean;
    m_EnterAValue1: Double;

    m_UseEnter2: Boolean;
    m_UseEnter2_1: Boolean;
    m_UseEnter2_2: Boolean;
    m_UseEnter2_3: Boolean;
    m_UseEnter2_4: Boolean;
    m_UseEnter2_5: Boolean;
    m_UseEnter2_6: Boolean;
    m_UseEnter2_7: Boolean;
    m_Enter2Value1: Double;
    m_Enter2Value2: Double;
    m_Enter2Value3: Double;
    m_Enter2Value4: Double;
    m_Enter2Value5: Double;
    m_Enter2Value6: Double;
    m_Enter2Value7: Double;

    m_UseEnterB: Boolean;
    m_EnterBValue1: Double;
    m_EnterBValue2: Double;

    m_UseEnterTypeC1_0: Boolean;
    m_EnterTypeC1_0Value1: Double;

    m_UseEnterTypeC1_1: Boolean;
    m_EnterTypeC1_1Value1: Double;
    m_UseEnterTypeC1_2: Boolean;
    m_EnterTypeC1_2Value1: Double;
    m_UseEnterTypeC1_3: Boolean;

    m_UseEnterTypeC1_4: Boolean;
    m_EnterTypeC1_4Value1: Double;
    m_UseEnterTypeC1_5: Boolean;
    m_EnterTypeC1_5Value1: Double;
    m_UseEnterTypeC1_6: Boolean;
    m_EnterTypeC1_6Value1: Double;

    m_UsePLC1Type2: Boolean;
    m_PLC1Type2Value1: Double;
    m_PLC1Type2Value2: Double;

    m_UsePLC1Type3: Boolean;
    m_PLC1Type3: Double;

    m_UsePLC1Type4: Boolean;
    m_UsePLC1Type4_1: Boolean;
    m_PLC1Type4_1Value1: Double;
    m_UsePLC1Type4_2: Boolean;
    m_PLC1Type4_2Value1: Double;
    m_UsePLC1Type4_3: Boolean;
    m_PLC1Type4Value3: Double;
    m_PLC1Type4Value4: Double;
    m_PLC1Type4Value5: Double;

    m_UsePLC1TypeC_1: Boolean;
    m_PLC1TypeC_1Value1: Double;
    m_UsePLC1TypeC_2: Boolean;
    m_PLC1TypeC_2Value1: Double;
    m_UsePLC1TypeC_3: Boolean;

    m_UsePLC2Type4: Boolean;
    m_UsePLC2Type4_1: Boolean;
    m_PLC2Type4_1Value1: Double;
    m_UsePLC2Type4_2: Boolean;
    m_PLC2Type4_2Value1: Double;
    m_UsePLC2Type4_3: Boolean;
    m_PLC2Type4Value3: Double;
    m_PLC2Type4Value4: Double;
    m_PLC2Type4Value5: Double;

    m_UsePLC2Type5: Boolean;
    m_UsePLC2Type5_1: Boolean;
    m_PLC2Type5_1Value1: Double;
    m_UsePLC2Type5_2: Boolean;
    m_PLC2Type5_2Value1: Double;
    m_UsePLC2Type5_3: Boolean;
    m_PLC2Type5Value3: Double;
    m_PLC2Type5Value4: Double;
    m_PLC2Type5Value5: Double;

    m_UsePLC2TypeC_1: Boolean;
    m_PLC2TypeC_1Value1: Double;
    m_UsePLC2TypeC_2: Boolean;
    m_PLC2TypeC_2Value1: Double;
    m_UsePLC2TypeC_3: Boolean;

    m_UseReEnter1: Boolean;
    m_ReEnter1Value1: Double;

    m_UseReEnter2: Boolean;
    m_ReEnter2Value1: Double;
    m_ReEnter2Value2: Double;

    m_UseReEnter3: Boolean;
    m_ReEnter3Value1: Double;
    m_ReEnter3Value2: Double;
    m_ReEnter3Value3: Double;
    m_ReEnter3Value4: Double;

    m_UseReEnter4: Boolean;
    m_ReEnter4Value1: Double;
    m_ReEnter4Value2: Double;

    m_UseReEnter5: Boolean;
    m_UseReEnter5_1: Boolean;
    m_ReEnter5_1Value1: Double;
    m_UseReEnter5_2: Boolean;
    m_ReEnter5_2Value1: Double;
    m_UseReEnter5_3: Boolean;

    m_UseReEnter6: Boolean;
    m_ReEnter6Value1: Double;
    m_ReEnter6Value2: Double;

    m_ReEnter0Value1: Double;
    m_ReEnter0Value2: Double;

    m_UseReEnterA: Boolean;
    m_ReEnterAValue1: Double;

    m_UseReEnterB: Boolean;
    m_ReEnterBValue1: Double;
    m_ReEnterBValue2: Double;

    m_UseReEnterC: Boolean;
    m_ReEnterCValue1: Double;
    m_ReEnterCValue2: Double;

    m_UseReEnterD: Boolean;
    m_ReEnterDValue1: Double;
    m_ReEnterDValue2: Double;
    m_ReEnterDValue3: Double;

    m_UsePLC2: Boolean;
    m_PLC2_V: Array [0 .. 5] of Double;
    m_PLC2_D: Array [0 .. 5] of Double;
    m_PLC2_A: Array [0 .. 5] of Boolean;

    m_UsePLC2Type2: Boolean;
    m_PLC2Type2Value1: Double;
    m_PLC2Type2Value2: Double;

    m_UsePLC2Type3: Boolean;
    m_PLC2Type3: Double;

    m_UseLossTradeStop: Boolean;
    m_LossTradeStopValue1: Double;

    m_UseProfitTradeStop: Boolean;
    m_ProfitTradeStopValue1: Double;

    m_MAType: Integer;
    m_MA0Number: Integer;
    m_MA1Number: Integer;
    m_MA2Number: Integer;

    m_UseMA1ConsecutiveUp: Boolean;
    m_MA1ConsecutiveUpCount: Integer;

    m_UseMA2ConsecutiveUp: Boolean;
    m_MA2ConsecutiveUpCount: Integer;

    m_UseMA1AboveMA2: Boolean;

    m_UseReEnterTypeC3_4: Boolean;
    m_ReEnterTypeC3_4Value1: Double;
    m_UseReEnterTypeC3_5: Boolean;
    m_ReEnterTypeC3_5Value1: Double;
    m_UseReEnterTypeC3_6: Boolean;
    m_ReEnterTypeC3_6Value1: Double;

    m_ASS_DATECOUNT4: Integer;
    m_ASS_PERCENT_PROFITABLE: Double;
    m_ASS_PROFIT_FACTOR: Double;
    m_ASS_MAXDRAWDOWN: Double;
    m_ASS_TYPE: Integer;

    m_FS_PrevData: Boolean;
    m_UsePrevData: Boolean;

    m_Commission: Double;

    m_ConditionLock: TCriticalSection;

    m_Reverse: Boolean;

    m_FS_PrevDataType: Boolean;

    constructor Create;
    destructor Destroy; override;

    procedure DefaultValue;
    procedure Clone(p_Source: CMXBlockManagerCondition);
    property ConditionLock: TCriticalSection read m_ConditionLock write m_ConditionLock;

  protected

  end;

  CMXBlockManager = class;

  CMXBlockManagerThread = class(CFNThread)
  public
    m_Manager: CMXBlockManager;

  protected
    procedure DoWork; override;
    procedure SetManager(AManager: CMXBlockManager);

  end;

  CMXBlockManager = class(TObject)
  private
    m_Thread: CMXBlockManagerThread;
    m_Start: Boolean;
    m_TimerWorking: Boolean;
    m_Updated: Boolean;
    m_Condition: CMXBlockManagerCondition;
    m_TimeOfStart: TDateTime;

    m_DoStart: Boolean;
    m_DoStop: Boolean;
    m_Reverse: Boolean;

  private
    m_DataLock: TCriticalSection;
    m_UpdatedEvent: TNotifyEvent;
    m_UpdateChartEvent: TNotifyEvent;

    procedure OnTimer(Sender: TObject);

  public
    m_Items: TList;
    m_Timer: TTimer;
    m_ChartDataSeries: CMKStreamChartDataSeries;
    m_MatrixSeries: CFNMatrixLineValueSeries;
    m_MatrixVolumeSeries: CFNMatrixLineValueSeries;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(ABlock: TObject);
    procedure Clear;

    procedure DoWork;

    procedure Lock;
    procedure Unlock;

    procedure Start;
    procedure Stop;

    procedure Read(AXMLNode: IXMLNode);
    function Write: String;

    procedure Calulate;

    property State: Boolean read m_Start;
    property OnUpdated: TNotifyEvent read m_UpdatedEvent write m_UpdatedEvent;
    property OnUpdateChart: TNotifyEvent read m_UpdateChartEvent write m_UpdateChartEvent;
    property Condition: CMXBlockManagerCondition read m_Condition write m_Condition;

    property DoStart: Boolean read m_DoStart write m_DoStart;
    property DoStop: Boolean read m_DoStop write m_DoStop;

  end;

implementation

uses
  FNMatrixLineValueSeriesCreator, FNGlobal, MXOption, MXBlock, MKChartData,
  MKLineValue, Variants,
  FNCMVariable, FNMatrixConst, Types, Math, FNSymbolCollection, FNPOTCollection;

var
  g_BlockCount: Integer;
  g_Epsilon: Double = 0.5;

{$REGION 'CMXBlockManagerCondition'}

constructor CMXBlockManagerCondition.Create;
begin
  inherited Create;
  m_ConditionLock := TCriticalSection.Create;
  DefaultValue;
end;

procedure CMXBlockManagerCondition.DefaultValue;
begin
  m_PortfolioGroupName := '그룹1';
  m_PortfolioName := '매트릭스-' + TFNGlobal.DateTimeToString(Now, 'YYYYMMDDHHMMSS');

  // 초기진입 - 수익확인후 진입
  m_UseEnterA := true;
  m_EnterAValue1 := 7.5;

  m_UseEnter2 := true;
  m_UseEnter2_1 := true;
  m_UseEnter2_2 := true;
  m_UseEnter2_3 := false;
  m_UseEnter2_4 := true;
  m_UseEnter2_5 := false;
  m_UseEnter2_6 := true;
  m_UseEnter2_7 := true;
  m_Enter2Value1 := 12;
  m_Enter2Value2 := 12;
  m_Enter2Value3 := 0;
  m_Enter2Value4 := 100;
  m_Enter2Value5 := -100;
  m_Enter2Value6 := 0;
  m_Enter2Value7 := 0;

  // 초기진입 - 매매허용 시간 지연
  m_UseEnterB := false;
  m_EnterBValue1 := 60;

  m_UseEnterTypeC1_0 := false;
  m_EnterTypeC1_0Value1 := 32;
  m_UseEnterTypeC1_1 := false;
  m_EnterTypeC1_1Value1 := 32;
  m_UseEnterTypeC1_2 := false;
  m_EnterTypeC1_2Value1 := 32;
  m_UseEnterTypeC1_3 := false;

  m_UseEnterTypeC1_4 := false;
  m_EnterTypeC1_4Value1 := 6;
  m_UseEnterTypeC1_5 := false;
  m_EnterTypeC1_5Value1 := 4;
  m_UseEnterTypeC1_6 := false;
  m_EnterTypeC1_6Value1 := 3;

  m_UsePLC1 := true;

  m_PLC1_V[0] := 100;
  m_PLC1_V[1] := 200;
  m_PLC1_V[2] := 300;
  m_PLC1_V[3] := 400;
  m_PLC1_V[4] := 500;
  m_PLC1_V[5] := 600;

  m_PLC1_D[0] := 61.8;
  m_PLC1_D[1] := 61.8;
  m_PLC1_D[2] := 38.2;
  m_PLC1_D[3] := 20;
  m_PLC1_D[4] := 20;
  m_PLC1_D[5] := 10;

  m_PLC1_A[0] := true;
  m_PLC1_A[1] := true;
  m_PLC1_A[2] := true;
  m_PLC1_A[3] := true;
  m_PLC1_A[4] := true;
  m_PLC1_A[5] := true;

  m_UsePLC1Type2 := true;
  m_PLC1Type2Value1 := 100;
  m_PLC1Type2Value2 := -150;

  m_UsePLC1Type3 := true;
  m_PLC1Type3 := -150;

  m_UsePLC1Type4_1 := false;
  m_PLC1Type4_1Value1 := 0;
  m_UsePLC1Type4_2 := false;
  m_PLC1Type4_2Value1 := 0;
  m_UsePLC1Type4_3 := false;

  m_UseReEnter1 := true;

  m_UseReEnter2 := true;
  m_ReEnter2Value1 := -10;
  m_ReEnter2Value2 := 10;

  // 재진입 조건 3
  m_UseReEnter3 := false;
  m_ReEnter3Value1 := 15;
  m_ReEnter3Value2 := 30;
  m_ReEnter3Value3 := 100;
  m_ReEnter3Value4 := -200;

  m_UseReEnter4 := false;
  m_ReEnter4Value1 := 50;
  m_ReEnter4Value2 := 60;

  m_UseReEnter4 := false;

  m_UseReEnter5 := false;
  m_UseReEnter5_1 := false;
  m_ReEnter5_1Value1 := 1;
  m_UseReEnter5_2 := false;
  m_ReEnter5_2Value1 := 1;
  m_UseReEnter5_3 := false;

  m_UseReEnter6 := false;
  m_ReEnter6Value1 := 50;
  m_ReEnter6Value2 := 30;

  m_ReEnter0Value1 := 1;
  m_ReEnter0Value2 := 30;

  // 재진입 공통조건 - 수익확인후 진입
  m_UseReEnterA := true;
  m_ReEnterAValue1 := 7.5;

  m_UseReEnterB := true;
  m_ReEnterBValue1 := 300;
  m_ReEnterBValue2 := -500;

  m_UseReEnterC := false;
  m_ReEnterCValue1 := 100;
  m_ReEnterCValue2 := -100;

  m_UseReEnterD := false;
  m_ReEnterDValue1 := 50;
  m_ReEnterDValue2 := 50;
  m_ReEnterDValue3 := 60;

  m_UsePLC2 := true;
  m_PLC2_V[0] := 50;
  m_PLC2_V[1] := 150;
  m_PLC2_V[2] := 300;
  m_PLC2_V[3] := 400;
  m_PLC2_V[4] := 500;
  m_PLC2_V[5] := 600;

  m_PLC2_D[0] := 61.8;
  m_PLC2_D[1] := 61.8;
  m_PLC2_D[2] := 38.2;
  m_PLC2_D[3] := 38.2;
  m_PLC2_D[4] := 10;
  m_PLC2_D[5] := 10;

  m_PLC2_A[0] := true;
  m_PLC2_A[1] := true;
  m_PLC2_A[2] := true;
  m_PLC2_A[3] := true;
  m_PLC2_A[4] := true;
  m_PLC2_A[5] := true;

  m_UsePLC2Type2 := true;
  m_PLC2Type2Value1 := 50;
  m_PLC2Type2Value2 := -30;

  m_UsePLC2Type3 := true;
  m_PLC2Type3 := -30;

  m_UseLossTradeStop := false;
  m_LossTradeStopValue1 := -200;

  m_UseProfitTradeStop := false;
  m_ProfitTradeStopValue1 := 1000;

  m_UseMA1ConsecutiveUp := true;
  m_MA1ConsecutiveUpCount := 1;

  m_UseMA2ConsecutiveUp := true;
  m_MA2ConsecutiveUpCount := 1;

  m_UseMA1AboveMA2 := true;

  m_UseReEnterTypeC3_4 := false;
  m_ReEnterTypeC3_4Value1 := 6;
  m_UseReEnterTypeC3_5 := false;
  m_ReEnterTypeC3_5Value1 := 4;
  m_UseReEnterTypeC3_6 := false;
  m_ReEnterTypeC3_6Value1 := 3;

  m_MAType := 0;
  m_MA0Number := 20;
  m_MA1Number := 90;
  m_MA2Number := 300;

  m_UsePLC1Type4 := true;
  m_UsePLC1Type4_1 := true;
  m_PLC1Type4_1Value1 := 1;
  m_UsePLC1Type4_2 := true;
  m_PLC1Type4_2Value1 := 1;
  m_UsePLC1Type4_3 := true;
  m_PLC1Type4Value3 := 500;
  m_PLC1Type4Value4 := 20;
  m_PLC1Type4Value5 := -200;

  m_UsePLC1TypeC_1 := true;
  m_PLC1TypeC_1Value1 := 1;
  m_UsePLC1TypeC_2 := true;
  m_PLC1TypeC_2Value1 := 1;
  m_UsePLC1TypeC_3 := true;

  m_UsePLC2Type4 := true;
  m_UsePLC2Type4_1 := true;
  m_PLC2Type4_1Value1 := 1;
  m_UsePLC2Type4_2 := true;
  m_PLC2Type4_2Value1 := 1;
  m_UsePLC2Type4_3 := true;
  m_PLC2Type4Value3 := 500;
  m_PLC2Type4Value4 := 20;
  m_PLC2Type4Value5 := -200;

  m_UsePLC2Type5 := false;
  m_UsePLC2Type5_1 := true;
  m_PLC2Type5_1Value1 := 1;
  m_UsePLC2Type5_2 := true;
  m_PLC2Type5_2Value1 := 1;
  m_UsePLC2Type5_3 := true;
  m_PLC2Type5Value3 := 500;
  m_PLC2Type5Value4 := 20;
  m_PLC2Type5Value5 := -200;

  m_UsePLC2TypeC_1 := true;
  m_PLC2TypeC_1Value1 := 1;
  m_UsePLC2TypeC_2 := true;
  m_PLC2TypeC_2Value1 := 1;
  m_UsePLC2TypeC_3 := true;

  m_ASS_DATECOUNT4 := 60;
  m_ASS_PERCENT_PROFITABLE := 60.0;
  m_ASS_PROFIT_FACTOR := 2.0;
  m_ASS_MAXDRAWDOWN := 5.0;
  m_ASS_TYPE := 0;

  m_FS_PrevData := false;
  m_UsePrevData := true;

  m_FS_PrevDataType := false;

  m_Reverse := false;

  m_Commission := 0.001;

end;

destructor CMXBlockManagerCondition.Destroy;
begin
  inherited;
  if Assigned(m_ConditionLock) then
  begin
    m_ConditionLock.Free;
    m_ConditionLock := NIL;
  end;
end;

procedure CMXBlockManagerCondition.Clone(p_Source: CMXBlockManagerCondition);
begin
  m_PortfolioGroupName := p_Source.m_PortfolioGroupName;
  m_PortfolioName := p_Source.m_PortfolioName;

  m_UsePLC1 := p_Source.m_UsePLC1;

  m_PLC1_V[0] := p_Source.m_PLC1_V[0];
  m_PLC1_V[1] := p_Source.m_PLC1_V[1];
  m_PLC1_V[2] := p_Source.m_PLC1_V[2];
  m_PLC1_V[3] := p_Source.m_PLC1_V[3];
  m_PLC1_V[4] := p_Source.m_PLC1_V[4];
  m_PLC1_V[5] := p_Source.m_PLC1_V[5];

  m_PLC1_D[0] := p_Source.m_PLC1_D[0];
  m_PLC1_D[1] := p_Source.m_PLC1_D[1];
  m_PLC1_D[2] := p_Source.m_PLC1_D[2];
  m_PLC1_D[3] := p_Source.m_PLC1_D[3];
  m_PLC1_D[4] := p_Source.m_PLC1_D[4];
  m_PLC1_D[5] := p_Source.m_PLC1_D[5];

  m_PLC1_A[0] := p_Source.m_PLC1_A[0];
  m_PLC1_A[1] := p_Source.m_PLC1_A[1];
  m_PLC1_A[2] := p_Source.m_PLC1_A[2];
  m_PLC1_A[3] := p_Source.m_PLC1_A[3];
  m_PLC1_A[4] := p_Source.m_PLC1_A[4];
  m_PLC1_A[5] := p_Source.m_PLC1_A[5];

  m_UsePLC1Type2 := p_Source.m_UsePLC1Type2;
  m_PLC1Type2Value1 := p_Source.m_PLC1Type2Value1;
  m_PLC1Type2Value2 := p_Source.m_PLC1Type2Value2;

  m_UsePLC1Type3 := p_Source.m_UsePLC1Type3;
  m_PLC1Type3 := p_Source.m_PLC1Type3;

  m_UsePLC2 := p_Source.m_UsePLC2;

  m_PLC2_V[0] := p_Source.m_PLC2_V[0];
  m_PLC2_V[1] := p_Source.m_PLC2_V[1];
  m_PLC2_V[2] := p_Source.m_PLC2_V[2];
  m_PLC2_V[3] := p_Source.m_PLC2_V[3];
  m_PLC2_V[4] := p_Source.m_PLC2_V[4];
  m_PLC2_V[5] := p_Source.m_PLC2_V[5];

  m_PLC2_D[0] := p_Source.m_PLC2_D[0];
  m_PLC2_D[1] := p_Source.m_PLC2_D[1];
  m_PLC2_D[2] := p_Source.m_PLC2_D[2];
  m_PLC2_D[3] := p_Source.m_PLC2_D[3];
  m_PLC2_D[4] := p_Source.m_PLC2_D[4];
  m_PLC2_D[5] := p_Source.m_PLC2_D[5];

  m_PLC2_A[0] := p_Source.m_PLC2_A[0];
  m_PLC2_A[1] := p_Source.m_PLC2_A[1];
  m_PLC2_A[2] := p_Source.m_PLC2_A[2];
  m_PLC2_A[3] := p_Source.m_PLC2_A[3];
  m_PLC2_A[4] := p_Source.m_PLC2_A[4];
  m_PLC2_A[5] := p_Source.m_PLC2_A[5];

  m_UsePLC2Type2 := p_Source.m_UsePLC2Type2;
  m_PLC2Type2Value1 := p_Source.m_PLC2Type2Value1;
  m_PLC2Type2Value2 := p_Source.m_PLC2Type2Value2;

  m_UsePLC2Type3 := p_Source.m_UsePLC2Type3;
  m_PLC2Type3 := p_Source.m_PLC2Type3;

  m_UseReEnter1 := p_Source.m_UseReEnter1;

  m_UseReEnter2 := p_Source.m_UseReEnter2;
  m_ReEnter2Value1 := p_Source.m_ReEnter2Value1;
  m_ReEnter2Value2 := p_Source.m_ReEnter2Value2;

  m_ReEnter0Value1 := p_Source.m_ReEnter0Value1;
  m_ReEnter0Value2 := p_Source.m_ReEnter0Value2;

  // 초기진입 - 수익확인후 진입
  m_UseEnterA := p_Source.m_UseEnterA;
  m_EnterAValue1 := p_Source.m_EnterAValue1;

  m_UseEnter2 := p_Source.m_UseEnter2;
  m_UseEnter2_1 := p_Source.m_UseEnter2_1;
  m_UseEnter2_2 := p_Source.m_UseEnter2_2;
  m_UseEnter2_3 := p_Source.m_UseEnter2_3;
  m_UseEnter2_4 := p_Source.m_UseEnter2_4;
  m_UseEnter2_5 := p_Source.m_UseEnter2_5;
  m_UseEnter2_6 := p_Source.m_UseEnter2_6;
  m_UseEnter2_7 := p_Source.m_UseEnter2_7;
  m_Enter2Value1 := p_Source.m_Enter2Value1;
  m_Enter2Value2 := p_Source.m_Enter2Value2;
  m_Enter2Value3 := p_Source.m_Enter2Value3;
  m_Enter2Value4 := p_Source.m_Enter2Value4;
  m_Enter2Value5 := p_Source.m_Enter2Value5;
  m_Enter2Value6 := p_Source.m_Enter2Value6;
  m_Enter2Value7 := p_Source.m_Enter2Value7;

  // 초기진입 - 매매허용 시간 지연
  m_UseEnterB := p_Source.m_UseEnterB;
  m_EnterBValue1 := p_Source.m_EnterBValue1;
  m_EnterBValue2 := p_Source.m_EnterBValue2;

  m_UseEnterTypeC1_0 := p_Source.m_UseEnterTypeC1_0;
  m_EnterTypeC1_0Value1 := p_Source.m_EnterTypeC1_0Value1;
  m_UseEnterTypeC1_1 := p_Source.m_UseEnterTypeC1_1;
  m_EnterTypeC1_1Value1 := p_Source.m_EnterTypeC1_1Value1;
  m_UseEnterTypeC1_2 := p_Source.m_UseEnterTypeC1_2;
  m_EnterTypeC1_2Value1 := p_Source.m_EnterTypeC1_2Value1;
  m_UseEnterTypeC1_3 := p_Source.m_UseEnterTypeC1_3;

  m_UseEnterTypeC1_4 := p_Source.m_UseEnterTypeC1_4;
  m_EnterTypeC1_4Value1 := p_Source.m_EnterTypeC1_4Value1;
  m_UseEnterTypeC1_5 := p_Source.m_UseEnterTypeC1_5;
  m_EnterTypeC1_5Value1 := p_Source.m_EnterTypeC1_5Value1;
  m_UseEnterTypeC1_6 := p_Source.m_UseEnterTypeC1_6;
  m_EnterTypeC1_6Value1 := p_Source.m_EnterTypeC1_6Value1;

  // 재진입 조건 3
  m_UseReEnter3 := p_Source.m_UseReEnter3;
  m_ReEnter3Value1 := p_Source.m_ReEnter3Value1;
  m_ReEnter3Value2 := p_Source.m_ReEnter3Value2;
  m_ReEnter3Value3 := p_Source.m_ReEnter3Value3;
  m_ReEnter3Value4 := p_Source.m_ReEnter3Value4;

  m_UseReEnter4 := p_Source.m_UseReEnter4;
  m_ReEnter4Value1 := p_Source.m_ReEnter4Value1;
  m_ReEnter4Value2 := p_Source.m_ReEnter4Value2;

  m_UseReEnter5 := p_Source.m_UseReEnter5;
  m_UseReEnter5_1 := p_Source.m_UseReEnter5_1;
  m_ReEnter5_1Value1 := p_Source.m_ReEnter5_1Value1;
  m_UseReEnter5_2 := p_Source.m_UseReEnter5_2;
  m_ReEnter5_2Value1 := p_Source.m_ReEnter5_2Value1;
  m_UseReEnter5_3 := p_Source.m_UseReEnter5_3;

  m_UseReEnter6 := p_Source.m_UseReEnter6;
  m_ReEnter6Value1 := p_Source.m_ReEnter6Value1;
  m_ReEnter6Value2 := p_Source.m_ReEnter6Value2;

  m_UseReEnterA := p_Source.m_UseReEnterA;
  m_ReEnterAValue1 := p_Source.m_ReEnterAValue1;

  m_UseReEnterB := p_Source.m_UseReEnterB;
  m_ReEnterBValue1 := p_Source.m_ReEnterBValue1;
  m_ReEnterBValue2 := p_Source.m_ReEnterBValue2;

  m_UseReEnterC := p_Source.m_UseReEnterC;
  m_ReEnterCValue1 := p_Source.m_ReEnterCValue1;
  m_ReEnterCValue2 := p_Source.m_ReEnterCValue2;

  m_UseReEnterD := p_Source.m_UseReEnterD;
  m_ReEnterDValue1 := p_Source.m_ReEnterDValue1;
  m_ReEnterDValue2 := p_Source.m_ReEnterDValue2;
  m_ReEnterDValue3 := p_Source.m_ReEnterDValue3;

  m_UseLossTradeStop := p_Source.m_UseLossTradeStop;
  m_LossTradeStopValue1 := p_Source.m_LossTradeStopValue1;

  m_UseProfitTradeStop := p_Source.m_UseProfitTradeStop;
  m_ProfitTradeStopValue1 := p_Source.m_ProfitTradeStopValue1;

  m_MAType := p_Source.m_MAType;
  m_MA0Number := p_Source.m_MA0Number;
  m_MA1Number := p_Source.m_MA1Number;
  m_MA2Number := p_Source.m_MA2Number;

  m_UseMA1ConsecutiveUp := p_Source.m_UseMA1ConsecutiveUp;
  m_MA1ConsecutiveUpCount := p_Source.m_MA1ConsecutiveUpCount;

  m_UseMA2ConsecutiveUp := p_Source.m_UseMA2ConsecutiveUp;
  m_MA2ConsecutiveUpCount := p_Source.m_MA2ConsecutiveUpCount;

  m_UseMA1AboveMA2 := p_Source.m_UseMA1AboveMA2;

  m_UseReEnterTypeC3_4 := p_Source.m_UseReEnterTypeC3_4;
  m_ReEnterTypeC3_4Value1 := p_Source.m_ReEnterTypeC3_4Value1;
  m_UseReEnterTypeC3_5 := p_Source.m_UseReEnterTypeC3_5;
  m_ReEnterTypeC3_5Value1 := p_Source.m_ReEnterTypeC3_5Value1;
  m_UseReEnterTypeC3_6 := p_Source.m_UseReEnterTypeC3_6;
  m_ReEnterTypeC3_6Value1 := p_Source.m_ReEnterTypeC3_6Value1;

  m_ASS_DATECOUNT4 := p_Source.m_ASS_DATECOUNT4;
  m_ASS_PERCENT_PROFITABLE := p_Source.m_ASS_PERCENT_PROFITABLE;
  m_ASS_PROFIT_FACTOR := p_Source.m_ASS_PROFIT_FACTOR;
  m_ASS_MAXDRAWDOWN := p_Source.m_ASS_MAXDRAWDOWN;
  m_ASS_TYPE := p_Source.m_ASS_TYPE;

  m_UsePLC1Type4 := p_Source.m_UsePLC1Type4;
  m_UsePLC1Type4_1 := p_Source.m_UsePLC1Type4_1;
  m_PLC1Type4_1Value1 := p_Source.m_PLC1Type4_1Value1;
  m_UsePLC1Type4_2 := p_Source.m_UsePLC1Type4_2;
  m_PLC1Type4_2Value1 := p_Source.m_PLC1Type4_2Value1;
  m_UsePLC1Type4_3 := p_Source.m_UsePLC1Type4_3;
  m_PLC1Type4Value3 := p_Source.m_PLC1Type4Value3;
  m_PLC1Type4Value4 := p_Source.m_PLC1Type4Value4;
  m_PLC1Type4Value5 := p_Source.m_PLC1Type4Value5;

  m_UsePLC2Type4 := p_Source.m_UsePLC2Type4;
  m_UsePLC2Type4_1 := p_Source.m_UsePLC2Type4_1;
  m_PLC2Type4_1Value1 := p_Source.m_PLC2Type4_1Value1;
  m_UsePLC2Type4_2 := p_Source.m_UsePLC2Type4_2;
  m_PLC2Type4_2Value1 := p_Source.m_PLC2Type4_2Value1;
  m_UsePLC2Type4_3 := p_Source.m_UsePLC2Type4_3;
  m_PLC2Type4Value3 := p_Source.m_PLC2Type4Value3;
  m_PLC2Type4Value4 := p_Source.m_PLC2Type4Value4;
  m_PLC2Type4Value5 := p_Source.m_PLC2Type4Value5;

  m_UsePLC2Type5 := p_Source.m_UsePLC2Type5;
  m_UsePLC2Type5_1 := p_Source.m_UsePLC2Type5_1;
  m_PLC2Type5_1Value1 := p_Source.m_PLC2Type5_1Value1;
  m_UsePLC2Type5_2 := p_Source.m_UsePLC2Type5_2;
  m_PLC2Type5_2Value1 := p_Source.m_PLC2Type5_2Value1;
  m_UsePLC2Type5_3 := p_Source.m_UsePLC2Type5_3;
  m_PLC2Type5Value3 := p_Source.m_PLC2Type5Value3;
  m_PLC2Type5Value4 := p_Source.m_PLC2Type5Value4;
  m_PLC2Type5Value5 := p_Source.m_PLC2Type5Value5;

  m_UsePLC1TypeC_1 := p_Source.m_UsePLC1TypeC_1;
  m_PLC1TypeC_1Value1 := p_Source.m_PLC1TypeC_1Value1;
  m_UsePLC1TypeC_2 := p_Source.m_UsePLC1TypeC_2;
  m_PLC1TypeC_2Value1 := p_Source.m_PLC1TypeC_2Value1;
  m_UsePLC1TypeC_3 := p_Source.m_UsePLC1TypeC_3;

  m_UsePLC2TypeC_1 := p_Source.m_UsePLC2TypeC_1;
  m_PLC2TypeC_1Value1 := p_Source.m_PLC2TypeC_1Value1;
  m_UsePLC2TypeC_2 := p_Source.m_UsePLC2TypeC_2;
  m_PLC2TypeC_2Value1 := p_Source.m_PLC2TypeC_2Value1;
  m_UsePLC2TypeC_3 := p_Source.m_UsePLC2TypeC_3;

  m_FS_PrevData := p_Source.m_FS_PrevData;
  m_UsePrevData := p_Source.m_UsePrevData;

  m_FS_PrevDataType := p_Source.m_FS_PrevDataType;

  m_Reverse := p_Source.m_Reverse;

  m_Commission := p_Source.m_Commission;

end;
{$ENDREGION}

procedure CMXBlockManagerThread.DoWork;
begin
  if Assigned(m_Manager) then
  begin
    if m_Manager.State then
    begin
      m_Working := true;
      m_Manager.DoWork;
    end;
  end;
  m_Working := false;
end;

procedure CMXBlockManagerThread.SetManager(AManager: CMXBlockManager);
begin
  m_Manager := AManager;
end;

constructor CMXBlockManager.Create;
begin
  m_DoStart := false;
  m_DoStop := false;
  m_Reverse := false;

  m_TimeOfStart := Now;
  m_Start := false;
  m_Items := TList.Create;
  m_ChartDataSeries := CMKStreamChartDataSeries.Create;
  m_MatrixSeries := FNMatrixLineValueSeriesCreator.Creator_MatrixSeries;
  m_MatrixVolumeSeries := FNMatrixLineValueSeriesCreator.Creator_MatrixVolumeSeries;
  m_DataLock := TCriticalSection.Create;
  m_Condition := CMXBlockManagerCondition.Create;

  m_Timer := TTimer.Create(NIL);
  m_Timer.Enabled := false;
  m_Timer.OnTimer := OnTimer;
  m_Timer.Interval := 2000;

  m_Thread := CMXBlockManagerThread.Create;
  m_Thread.SetSleepTime(100);
  m_Thread.SetManager(Self);
  m_Thread.Resume;
end;

destructor CMXBlockManager.Destroy;
var
  nTry: Integer;
  f_Loop: Integer;
begin
  m_Start := false;

  if Assigned(m_Thread) then
  begin
    m_Thread.StopThread;
  end;

  nTry := 0;
  while Assigned(m_Thread) do
  begin
    if (not m_Thread.Finished) then
    begin
      m_Thread.StopThread;
      Inc(nTry);
      if (nTry > 50) then
      begin
        m_Thread.ExitThread;
        m_Thread.Free;
        m_Thread := NIL;
        break;
      end;
    end
    else
    begin
      m_Thread.Free;
      m_Thread := NIL;
      break;
    end;
    Sleep(100);
  end;

  f_Loop := 0;
  while true do
  begin
    if f_Loop > 30 then
      break;
    if not m_TimerWorking then
      break;
    Sleep(10);
    Inc(f_Loop);
  end;

  if Assigned(m_Timer) then
  begin
    m_Timer.Enabled := false;
    m_Timer.Free;
    m_Timer := NIL;
  end;

  if Assigned(m_DataLock) then
  begin
    m_DataLock.Free;
    m_DataLock := NIL;
  end;

  if Assigned(m_Items) then
  begin
    m_Items.Free;
    m_Items := NIL;
  end;

  if Assigned(m_ChartDataSeries) then
  begin
    m_ChartDataSeries.Free;
    m_ChartDataSeries := NIL;
  end;

  if Assigned(m_MatrixSeries) then
  begin
    m_MatrixSeries.Free;
    m_MatrixSeries := NIL;
  end;

  if Assigned(m_MatrixVolumeSeries) then
  begin
    m_MatrixVolumeSeries.Free;
    m_MatrixVolumeSeries := NIL;
  end;

  if Assigned(m_Condition) then
  begin
    m_Condition.Free;
    m_Condition := NIL;
  end;
end;

procedure CMXBlockManager.Add(ABlock: TObject);
var
  f_SearchBlock: CMXBlock;
begin
  m_DataLock.Enter;
  try
    CMXBlock(ABlock).BlockManager := Self;
    m_Items.Add(ABlock);
  finally
    m_DataLock.Leave;
  end;
end;

procedure CMXBlockManager.Clear;
begin
  m_DataLock.Enter;
  try
    while 0 < m_Items.Count do
    begin
      m_Items.Delete(0);
    end;
  finally
    m_DataLock.Leave;
  end;
end;

procedure CMXBlockManager.Lock;
begin
  m_DataLock.Enter;
end;

procedure CMXBlockManager.Unlock;
begin
  m_DataLock.Leave;
end;

procedure CMXBlockManager.Start;
var
  f_Loop: Integer;
begin
  if m_Start then
    exit;

  m_Updated := false;

  f_Loop := 0;
  while true do
  begin
    if f_Loop > 30 then
      break;
    if not m_TimerWorking then
      break;
    Sleep(10);
    Inc(f_Loop);
  end;

  m_ChartDataSeries.Clear;
  m_MatrixSeries.Clear;

  m_TimeOfStart := Now;
  m_Start := true;
  m_Timer.Enabled := true;
  m_DoStart := false;
  m_DoStop := false;
end;

procedure CMXBlockManager.Stop;
var
  f_Loop: Integer;
begin
  if not m_Start then
    exit;

  f_Loop := 0;
  while true do
  begin
    if f_Loop > 30 then
      break;
    if not m_TimerWorking then
      break;
    Sleep(10);
    Inc(f_Loop);
  end;

  m_Start := false;
end;

procedure CMXBlockManager.DoWork;
begin
  m_DataLock.Enter;
  m_Condition.ConditionLock.Enter;
  try
    Calulate;
  finally
    m_Condition.ConditionLock.Leave;
    m_DataLock.Leave;
  end;
end;

procedure CMXBlockManager.OnTimer(Sender: TObject);
var
  f_Index: Integer;
begin
  m_Timer.Enabled := false;
  m_TimerWorking := true;
  try
    if m_Start then
    begin
      if m_Updated then
      begin
        if Assigned(m_UpdatedEvent) then
        begin
          m_UpdatedEvent(Self);
        end;

        if Assigned(m_UpdateChartEvent) then
        begin
          m_UpdateChartEvent(Self);
        end;

        m_Updated := false;
      end;
    end;
  finally
    m_Timer.Enabled := true;
    m_TimerWorking := false;
  end;
end;

{$REGION '계산을 한다'}

procedure CMXBlockManager.Calulate;
var
  f_ItemIndex, f_Index: Integer;
  f_Block: CMXBlock;
  f_Begin, f_End: Integer;
  f_ValueIndex: Integer;

  f_OldMarketData: CMKChartData;
  f_NewMarketData: CMKChartData;
  // f_OpenQuarkPrice,f_OpenRealPrice:Double;

  f_LineValue0: CMKLineValue;
  f_LineValue1: CMKLineValue;
  f_LineValue2: CMKLineValue;
  f_LineValue6: CMKLineValue;
  f_SrcLineValue0: CMKLineValue;
  f_SrcLineValue1: CMKLineValue;

  f_ChartData: CMKChartData;
  f_SumOfProfit: Double;

  f_VolatilityGrade: Integer;
  f_MaxValue: Double;
  f_ConditionValue: Double;

  f_CurrValue: Double;
  f_CurrValue0: Double;
  f_CurrValue1: Double;
  f_StopValue: Double;
  f_TargetValue: Double;
  f_TargetValue1: Double;
  f_TargetValue2: Double;

  f_ZeroIndex: Integer;
  f_TodayCount: Integer;

  f_Changed: Boolean;
  f_ChangedFromStart: Boolean;

  f_BarCount: Integer;
  f_BarInterval: Integer;
  f_LowestValue: Double;
  f_ValueIndex2: Integer;
  f_CalcIndex: Integer;

  f_RangeValue: Double;

  f_TR_VALUE: Double;
  f_TR_EXIT_VALUE: Double;
  f_CondiValue: Double;

  f_SpecialCondition: Boolean;
  f_MAUpCondition: Boolean;
  f_MADnCondition: Boolean;
  f_ProfitCondition1: Boolean;
  f_ProfitCondition2: Boolean;
  f_ProfitCondition3: Boolean;

  f_BarIndex: Integer;

  f_RangeCount: Integer;
  f_RangeLowest: Double;
begin
  if m_Items.Count <= 0 then
    exit;

{$REGION '각 아이템의 계산이 시작되었는지 확인한다.'}
  f_ChangedFromStart := true;
  for f_ItemIndex := 0 to m_Items.Count - 1 do
  begin
    f_Block := CMXBlock(m_Items[f_ItemIndex]);
    if not f_Block.SystemManager.GetMerge1ChangedFromStart then
    begin
      f_ChangedFromStart := false;
      break;
    end;
  end;

  if not f_ChangedFromStart then
  begin
    exit;
  end;
{$ENDREGION}
{$REGION '각 아이템의 계산후 내용이 변경되었는지 확인한다.'}
  f_Changed := false;
  for f_ItemIndex := 0 to m_Items.Count - 1 do
  begin
    f_Block := CMXBlock(m_Items[f_ItemIndex]);
    if (f_Block.SystemManager.GetMerge1Changed) then
    begin
      f_Changed := true;
      break;
    end;
  end;
{$ENDREGION}
  if f_Changed then
  begin

    for f_ItemIndex := 0 to m_Items.Count - 1 do
    begin
      f_Block := CMXBlock(m_Items[f_ItemIndex]);
      f_Block.SystemManager.SetMerge1Changed(false);
    end;

{$REGION '각 아이템의 락을 건다'}
    for f_ItemIndex := 0 to m_Items.Count - 1 do
    begin
      f_Block := CMXBlock(m_Items[f_ItemIndex]);
      f_Block.SystemManager.Lock;
    end;
{$ENDREGION}
    try

{$REGION '계산할 시작점을 찾는다. 이전에 작업한 마지막 부분이다'}
      f_Begin := m_MatrixSeries.m_Items.Count;
      if f_Begin < 0 then
        f_Begin := 0;
{$ENDREGION}
{$REGION '계산할 마지막지점을 찾는다. 모든 시스템중 가장 적은 바를 가지고 있는 시스템의 바의 갯수'}
      f_End := -1;
      for f_ItemIndex := 0 to m_Items.Count - 1 do
      begin
        f_Block := CMXBlock(m_Items[f_ItemIndex]);
        f_ZeroIndex := f_Block.SystemManager.m_ChartDataSeries.m_ZeroIndex;
        f_TodayCount := f_Block.SystemManager.m_MergeSeries1.m_Items.Count - f_ZeroIndex;
        if f_End < 0 then
          f_End := f_TodayCount
        else if f_End > f_TodayCount then
          f_End := f_TodayCount;
      end;
      if f_End <= 0 then
        exit;
{$ENDREGION}
{$REGION '보조지표의 길이를 설정한다'}
      m_MatrixSeries.SetLengthSeries(f_End);
      m_MatrixVolumeSeries.SetLengthSeries(f_End);
{$ENDREGION}
{$REGION '차트데이터를 업데이터 한다'}
      f_Block := CMXBlock(m_Items[0]);
      try
        m_ChartDataSeries.m_Country := f_Block.SystemManager.m_ChartDataSeries.m_Country;
        m_ChartDataSeries.m_Group := f_Block.SystemManager.m_ChartDataSeries.m_Group;
        m_ChartDataSeries.m_Market := f_Block.SystemManager.m_ChartDataSeries.m_Market;
        m_ChartDataSeries.m_Symbol := f_Block.SystemManager.m_ChartDataSeries.m_Symbol;
        m_ChartDataSeries.m_Name := f_Block.SystemManager.m_ChartDataSeries.m_Name;
        m_ChartDataSeries.m_TimeFrame := f_Block.SystemManager.m_ChartDataSeries.m_TimeFrame;
        m_ChartDataSeries.m_Precision := f_Block.SystemManager.m_ChartDataSeries.m_Precision;
        f_ZeroIndex := f_Block.SystemManager.m_ChartDataSeries.m_ZeroIndex;

        for f_ValueIndex := f_Begin - 1 to f_End - 1 do
        begin
          if f_ValueIndex < 0 then
            continue;

          f_OldMarketData := CMKChartData(f_Block.SystemManager.m_ChartDataSeries.m_Items.Items[f_ZeroIndex + f_ValueIndex]);
          if (f_ValueIndex < m_ChartDataSeries.m_Items.Count) then
          begin
            f_NewMarketData := m_ChartDataSeries.m_Items[f_ValueIndex];
            // f_OpenQuarkPrice := f_NewMarketData.m_OpenOPS;
            // f_OpenRealPrice := f_NewMarketData.m_OpenPrice;
            f_NewMarketData.Clone(f_OldMarketData);

            // f_NewMarketData.m_OpenOPS := f_OpenQuarkPrice;
            // f_NewMarketData.m_OpenPrice  := f_OpenRealPrice;
          end
          else
          begin
            f_NewMarketData := CMKChartData.Create;
            f_NewMarketData.Clone(f_OldMarketData);
            m_ChartDataSeries.m_Items.Add(f_NewMarketData);
          end;
        end;
      finally
      end;
{$ENDREGION}
{$REGION '새로운바가 추가 되었을 때 만 계산한다'}
      if f_Begin < f_End then
      begin

{$REGION '실물가격를 복제한다'}
        for f_ValueIndex := f_Begin to f_End - 1 do
        begin
          if f_ValueIndex < 0 then
            continue;
          f_LineValue0 := m_MatrixSeries.m_Items.Items[f_ValueIndex];
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
          f_LineValue0.m_Value[M_MATRIX_LINE_REALPRICE] := f_ChartData.m_OpenPrice;
        end;
{$ENDREGION}
{$REGION '거래량을 복제한다'}
        for f_ValueIndex := f_Begin to f_End - 1 do
        begin
          if f_ValueIndex < 0 then
            continue;
          f_LineValue0 := m_MatrixVolumeSeries.m_Items.Items[f_ValueIndex];
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
          f_LineValue0.m_Value[M_MATRIX_VLINE_VOLUME] := f_ChartData.m_Volume;
        end;
{$ENDREGION}
{$REGION '수익의 합계를 계산한다'}
        for f_ValueIndex := f_Begin to f_End - 1 do
        begin
          f_LineValue0 := m_MatrixSeries.m_Items.Items[f_ValueIndex];
          f_SumOfProfit := 0;
          for f_ItemIndex := 0 to m_Items.Count - 1 do
          begin
            f_Block := CMXBlock(m_Items[f_ItemIndex]);
            f_ZeroIndex := f_Block.SystemManager.m_ChartDataSeries.m_ZeroIndex;
            f_SrcLineValue0 := f_Block.SystemManager.m_MergeSeries1.m_Items.Items[f_ZeroIndex + f_ValueIndex];

            f_SumOfProfit := f_SumOfProfit + (f_SrcLineValue0.m_Value[M_MERGE_LINE_PROFIT1] * f_Block.Option.GetIntegerValue('ORDER_COUNT'));

          end;
          f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] := f_SumOfProfit * f_Block.Option.GetDoubleValue('POINT_VALUE');
        end;
{$ENDREGION}
        if 0 = m_Condition.m_MAType then
        begin
          m_MatrixSeries.Indicator_NAverageZ(m_Condition.m_MA0Number, m_MatrixSeries, M_MATRIX_LINE_VALUE, M_MATRIX_LINE_VALUE_MA0, f_Begin, f_End);
          m_MatrixSeries.Indicator_NAverageZ(m_Condition.m_MA1Number, m_MatrixSeries, M_MATRIX_LINE_VALUE, M_MATRIX_LINE_VALUE_MA1, f_Begin, f_End);
          m_MatrixSeries.Indicator_NAverageZ(m_Condition.m_MA2Number, m_MatrixSeries, M_MATRIX_LINE_VALUE, M_MATRIX_LINE_VALUE_MA2, f_Begin, f_End);
        end
        else if 1 = m_Condition.m_MAType then
        begin
          m_MatrixSeries.Indicator_WAverageZ(m_Condition.m_MA0Number, m_MatrixSeries, M_MATRIX_LINE_VALUE, M_MATRIX_LINE_VALUE_MA0, f_Begin, f_End);
          m_MatrixSeries.Indicator_WAverageZ(m_Condition.m_MA1Number, m_MatrixSeries, M_MATRIX_LINE_VALUE, M_MATRIX_LINE_VALUE_MA1, f_Begin, f_End);
          m_MatrixSeries.Indicator_WAverageZ(m_Condition.m_MA2Number, m_MatrixSeries, M_MATRIX_LINE_VALUE, M_MATRIX_LINE_VALUE_MA2, f_Begin, f_End);
        end
        else
        begin
          m_MatrixSeries.Indicator_XAverage(m_Condition.m_MA0Number, m_MatrixSeries, M_MATRIX_LINE_VALUE, M_MATRIX_LINE_VALUE_MA0, f_Begin, f_End);
          m_MatrixSeries.Indicator_XAverage(m_Condition.m_MA1Number, m_MatrixSeries, M_MATRIX_LINE_VALUE, M_MATRIX_LINE_VALUE_MA1, f_Begin, f_End);
          m_MatrixSeries.Indicator_XAverage(m_Condition.m_MA2Number, m_MatrixSeries, M_MATRIX_LINE_VALUE, M_MATRIX_LINE_VALUE_MA2, f_Begin, f_End);
        end;

{$REGION '주'}
        (*
          f_BarInterval := Trunc(m_Condition.m_ReEnter3Value1 * 60.0 / 10.0);

          {$REGION '로스컷을 적용한다'}
          for f_ValueIndex := f_Begin to f_End - 1 do
          begin
          f_LineValue0 := m_MatrixSeries.m_Items.Items[f_ValueIndex];

          if (1 <= f_ValueIndex) then
          begin
          f_LineValue1 := m_MatrixSeries.m_Items.Items[f_ValueIndex-1];
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := f_LineValue1.m_Value[M_MATRIX_LINE_CANTRADE01      ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX         ] := f_LineValue1.m_Value[M_MATRIX_LINE_TR_INDEX        ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := f_LineValue1.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE  ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := f_LineValue1.m_Value[M_MATRIX_LINE_TR_MAXVALUE     ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX    ] := f_LineValue1.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX   ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_STOP_TYPE     ] := f_LineValue1.m_Value[M_MATRIX_LINE_TR_STOP_TYPE    ];
          f_LineValue0.m_Value[M_MATRIX_LINE_MAXVALUE         ] := f_LineValue1.m_Value[M_MATRIX_LINE_MAXVALUE        ];
          f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE ] := f_LineValue1.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE];

          if f_LineValue0.m_Value[M_MATRIX_LINE_MAXVALUE] < f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_MAXVALUE] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];
          end;

          {$REGION '1차 허용구간'}

          {$REGION '매매허용구간일때'}
          if (1 = f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01]) then
          begin
          f_CurrValue := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);

          if f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] < f_CurrValue then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] := f_CurrValue;
          end;

          f_MaxValue := f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE];

          if (m_DoStop) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX    ] := f_ValueIndex;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_STOP_TYPE     ] := 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
          LOG_WRITE
          (
          LOG_TYPE_INFO,
          'CMXBlockManager',
          '[수동]에 의해 전체매매가 정지됩니다.-' + TFNGlobal.DateTimeToStr6(f_ChartData.m_OpenDateTime)
          );
          m_DoStop := false;

          end else
          begin
          if 1 = f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX] then
          begin

          {$REGION '수익금액별 손절매방식'}
          if m_Condition.m_UsePLC1 then
          begin
          f_ConditionValue := 1000000;
          f_VolatilityGrade := -1;
          for f_Index := 5 downto 0 do
          begin
          f_CondiValue := m_Condition.m_PLC1_V[f_Index]*10000.0;
          if (m_Condition.m_PLC1_A[f_Index]) and (CompareValue(f_CondiValue,  f_MaxValue, g_Epsilon) <= 0) then
          begin
          f_VolatilityGrade := f_Index;
          f_ConditionValue := m_Condition.m_PLC1_D[f_Index];
          break;
          end;
          end;

          if (f_VolatilityGrade >= 0) then
          begin
          f_MADnCondition :=
          (
          (
          not m_Condition.m_UsePLC1TypeC_1
          ) or
          (
          (m_Condition.m_UsePLC1TypeC_1) and m_MatrixSeries.ConsecutiveDn(M_MATRIX_LINE_VALUE_MA1, Trunc(m_Condition.m_PLC1TypeC_1Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UsePLC1TypeC_2
          ) or
          (
          (m_Condition.m_UsePLC1TypeC_2) and m_MatrixSeries.ConsecutiveDn(M_MATRIX_LINE_VALUE_MA2, Trunc(m_Condition.m_PLC1TypeC_2Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UsePLC1TypeC_3
          ) or
          (
          (m_Condition.m_UsePLC1TypeC_3) and m_MatrixSeries.BelowOf(M_MATRIX_LINE_VALUE_MA1, M_MATRIX_LINE_VALUE_MA2, f_ValueIndex)
          )
          );

          f_StopValue := f_MaxValue - (abs(f_MaxValue) * f_ConditionValue) / 100.0;
          if (CompareValue(f_CurrValue, f_StopValue, g_Epsilon) < 0) and (f_MADnCondition) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX    ] := f_ValueIndex;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_STOP_TYPE     ] := 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
          LOG_WRITE
          (
          LOG_TYPE_INFO,
          'CMXBlockManager',
          '[손절매 방식 1]에 의해 전체매매가 정지됩니다.-' + TFNGlobal.DateTimeToStr6(f_ChartData.m_OpenDateTime)
          );
          m_DoStop := false;
          end;
          end;
          end;
          {$ENDREGION}

          {$REGION '손절매 방식 2'}
          if m_Condition.m_UsePLC1Type2 then
          begin
          if (f_MaxValue < m_Condition.m_PLC1Type2Value1*10000.0) then
          begin
          f_CurrValue := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          if CompareValue(f_CurrValue, m_Condition.m_PLC1Type2Value2*10000.0, g_Epsilon) <= 0 then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX    ] := f_ValueIndex;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_STOP_TYPE     ] := 2;
          f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
          LOG_WRITE
          (
          LOG_TYPE_INFO,
          'CMXBlockManager',
          '[손절매 방식 2]에 의해 전체매매가 정지됩니다.-' + TFNGlobal.DateTimeToStr6(f_ChartData.m_OpenDateTime)
          );
          m_DoStop := false;
          end;
          end;
          end;
          {$ENDREGION}

          {$REGION '손절매 방식 3'}
          if m_Condition.m_UsePLC1Type3 then
          begin
          f_CurrValue := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          if CompareValue(f_CurrValue, m_Condition.m_PLC1Type3*10000.0, g_Epsilon) <= 0 then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX    ] := f_ValueIndex;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_STOP_TYPE     ] := 3;
          f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
          LOG_WRITE
          (
          LOG_TYPE_INFO,
          'CMXBlockManager',
          '[손절매 방식 3]에 의해 전체매매가 정지됩니다.-' + TFNGlobal.DateTimeToStr6(f_ChartData.m_OpenDateTime)
          );
          m_DoStop := false;
          end;
          end;
          {$ENDREGION}

          {$REGION '손절매 방식 4'}
          if m_Condition.m_UsePLC1Type4 then
          begin
          f_MADnCondition :=
          (
          (
          not m_Condition.m_UsePLC1Type4_1
          ) or
          (
          (m_Condition.m_UsePLC1Type4_1) and m_MatrixSeries.ConsecutiveDn(M_MATRIX_LINE_VALUE_MA1, Trunc(m_Condition.m_PLC1Type4_1Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UsePLC1Type4_2
          ) or
          (
          (m_Condition.m_UsePLC1Type4_2) and m_MatrixSeries.ConsecutiveDn(M_MATRIX_LINE_VALUE_MA2, Trunc(m_Condition.m_PLC1Type4_2Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UsePLC1Type4_3
          ) or
          (
          (m_Condition.m_UsePLC1Type4_3) and m_MatrixSeries.BelowOf(M_MATRIX_LINE_VALUE_MA1, M_MATRIX_LINE_VALUE_MA2, f_ValueIndex)
          )
          );

          f_BarIndex := Trunc(m_Condition.m_PLC1Type4Value4 * 60 / 10);

          f_CurrValue := Max(f_LineValue0.m_Value[M_MATRIX_LINE_VALUE], (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]));

          if  (
          (f_MADnCondition) and
          (
          (CompareValue(f_CurrValue, m_Condition.m_PLC1Type4Value3*10000.0, g_Epsilon) >= 0) or
          (CompareValue(f_CurrValue, m_Condition.m_PLC1Type4Value5*10000.0, g_Epsilon) <= 0)
          ) and
          (f_ValueIndex > f_BarIndex)
          ) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX    ] := f_ValueIndex;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_STOP_TYPE     ] := 4;
          f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
          LOG_WRITE
          (
          LOG_TYPE_INFO,
          'CMXBlockManager',
          '[손절매 방식 4]에 의해 전체매매가 정지됩니다.-' + TFNGlobal.DateTimeToStr6(f_ChartData.m_OpenDateTime)
          );
          m_DoStop := false;
          end;
          end;
          {$ENDREGION}

          end else
          begin

          {$REGION '수익금액별 손절매방식'}
          if m_Condition.m_UsePLC2 then
          begin
          f_ConditionValue := 1000000;
          f_VolatilityGrade := -1;
          for f_Index := 5 downto 0 do
          begin
          f_CondiValue := m_Condition.m_PLC2_V[f_Index]*10000.0;
          if (m_Condition.m_PLC2_A[f_Index]) and (CompareValue(f_CondiValue,  f_MaxValue, g_Epsilon) <= 0) then
          begin
          f_VolatilityGrade := f_Index;
          f_ConditionValue := m_Condition.m_PLC2_D[f_Index];
          break;
          end;
          end;

          if (f_VolatilityGrade >= 0) then
          begin
          f_MADnCondition :=
          (
          (
          not m_Condition.m_UsePLC2TypeC_1
          ) or
          (
          (m_Condition.m_UsePLC2TypeC_1) and m_MatrixSeries.ConsecutiveDn(M_MATRIX_LINE_VALUE_MA1, Trunc(m_Condition.m_PLC2TypeC_1Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UsePLC2TypeC_2
          ) or
          (
          (m_Condition.m_UsePLC2TypeC_2) and m_MatrixSeries.ConsecutiveDn(M_MATRIX_LINE_VALUE_MA2, Trunc(m_Condition.m_PLC2TypeC_2Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UsePLC2TypeC_3
          ) or
          (
          (m_Condition.m_UsePLC2TypeC_3) and m_MatrixSeries.BelowOf(M_MATRIX_LINE_VALUE_MA1, M_MATRIX_LINE_VALUE_MA2, f_ValueIndex)
          )
          );
          f_StopValue := f_MaxValue - (abs(f_MaxValue) * f_ConditionValue) / 100.0;
          if (CompareValue(f_CurrValue, f_StopValue, g_Epsilon) < 0) and (f_MADnCondition) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX    ] := f_ValueIndex;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_STOP_TYPE     ] := 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
          LOG_WRITE
          (
          LOG_TYPE_INFO,
          'CMXBlockManager',
          '[손절매 방식 1]에 의해 전체매매가 정지됩니다.-' + TFNGlobal.DateTimeToStr6(f_ChartData.m_OpenDateTime)
          );
          m_DoStop := false;
          end;
          end;
          end;
          {$ENDREGION}

          {$REGION '손절매 방식 2'}
          if m_Condition.m_UsePLC2Type2 then
          begin

          if (f_MaxValue < m_Condition.m_PLC2Type2Value1*10000.0) then
          begin
          f_CurrValue := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          if CompareValue(f_CurrValue,  m_Condition.m_PLC2Type2Value2*10000.0, g_Epsilon) <= 0 then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX    ] := f_ValueIndex;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_STOP_TYPE     ] := 2;
          f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
          LOG_WRITE
          (
          LOG_TYPE_INFO,
          'CMXBlockManager',
          '[손절매 방식 2]에 의해 전체매매가 정지됩니다.-' + TFNGlobal.DateTimeToStr6(f_ChartData.m_OpenDateTime)
          );
          m_DoStop := false;
          end;
          end;
          end;
          {$ENDREGION}

          {$REGION '손절매 방식 3'}
          if m_Condition.m_UsePLC2Type3 then
          begin
          f_CurrValue := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          if CompareValue(f_CurrValue,  m_Condition.m_PLC2Type3*10000.0, g_Epsilon) <= 0 then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX    ] := f_ValueIndex;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_STOP_TYPE     ] := 3;
          f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
          LOG_WRITE
          (
          LOG_TYPE_INFO,
          'CMXBlockManager',
          '[손실정지]에 의해 전체매매가 정지됩니다.-' + TFNGlobal.DateTimeToStr6(f_ChartData.m_OpenDateTime)
          );
          m_DoStop := false;
          end;
          end;
          {$ENDREGION}

          {$REGION '손절매 방식 4'}
          if m_Condition.m_UsePLC2Type4 then
          begin
          f_MADnCondition :=
          (
          (
          not m_Condition.m_UsePLC2Type4_1
          ) or
          (
          (m_Condition.m_UsePLC2Type4_1) and m_MatrixSeries.ConsecutiveDn(M_MATRIX_LINE_VALUE_MA1, Trunc(m_Condition.m_PLC2Type4_1Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UsePLC2Type4_2
          ) or
          (
          (m_Condition.m_UsePLC2Type4_2) and m_MatrixSeries.ConsecutiveDn(M_MATRIX_LINE_VALUE_MA2, Trunc(m_Condition.m_PLC2Type4_2Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UsePLC2Type4_3
          ) or
          (
          (m_Condition.m_UsePLC2Type4_3) and m_MatrixSeries.BelowOf(M_MATRIX_LINE_VALUE_MA1, M_MATRIX_LINE_VALUE_MA2, f_ValueIndex)
          )
          );
          f_BarIndex := Trunc(m_Condition.m_PLC2Type4Value4 * 60 / 10);

          //f_CurrValue := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          f_CurrValue := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];

          if  (
          (f_MADnCondition) and
          (
          (CompareValue(f_CurrValue, m_Condition.m_PLC2Type4Value3*10000.0, g_Epsilon) >= 0) or
          (CompareValue(f_CurrValue, m_Condition.m_PLC2Type4Value5*10000.0, g_Epsilon) <= 0)
          ) and
          (f_ValueIndex > f_BarIndex)
          ) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX    ] := f_ValueIndex;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_STOP_TYPE     ] := 4;
          f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
          LOG_WRITE
          (
          LOG_TYPE_INFO,
          'CMXBlockManager',
          '[손실정지]에 의해 전체매매가 정지됩니다.-' + TFNGlobal.DateTimeToStr6(f_ChartData.m_OpenDateTime)
          );
          m_DoStop := false;
          end;
          end;
          {$ENDREGION}

          {$REGION '손절매 방식 5'}
          if m_Condition.m_UsePLC2Type5 then
          begin
          f_MADnCondition :=
          (
          (
          not m_Condition.m_UsePLC2Type5_1
          ) or
          (
          (m_Condition.m_UsePLC2Type5_1) and m_MatrixSeries.ConsecutiveDn(M_MATRIX_LINE_VALUE_MA1, Trunc(m_Condition.m_PLC2Type5_1Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UsePLC2Type5_2
          ) or
          (
          (m_Condition.m_UsePLC2Type5_2) and m_MatrixSeries.ConsecutiveDn(M_MATRIX_LINE_VALUE_MA2, Trunc(m_Condition.m_PLC2Type5_2Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UsePLC2Type5_3
          ) or
          (
          (m_Condition.m_UsePLC2Type5_3) and m_MatrixSeries.BelowOf(M_MATRIX_LINE_VALUE_MA1, M_MATRIX_LINE_VALUE_MA2, f_ValueIndex)
          )
          );
          f_BarIndex := Trunc(m_Condition.m_PLC2Type5Value4 * 60 / 10);

          f_CurrValue := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);

          if  (
          (f_MADnCondition) and
          (
          (CompareValue(f_CurrValue, m_Condition.m_PLC2Type5Value3*10000.0, g_Epsilon) >= 0) or
          (CompareValue(f_CurrValue, m_Condition.m_PLC2Type5Value5*10000.0, g_Epsilon) <= 0)
          ) and
          (f_ValueIndex > f_BarIndex)
          ) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX    ] := f_ValueIndex;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_STOP_TYPE     ] := 5;
          f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
          LOG_WRITE
          (
          LOG_TYPE_INFO,
          'CMXBlockManager',
          '[손실정지]에 의해 전체매매가 정지됩니다.-' + TFNGlobal.DateTimeToStr6(f_ChartData.m_OpenDateTime)
          );
          m_DoStop := false;
          end;
          end;
          {$ENDREGION}

          end;
          end;

          end else
          {$ENDREGION}

          {$REGION '매매허용구간이 아닐때'}
          if (0 = f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01]) then
          begin

          if f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE] > f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];
          end;

          if (m_DoStart) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 2;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX         ] := f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX    ] + 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE       ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := 0;

          if f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] < (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          end;

          f_LineValue0.m_Value[M_MATRIX_LINE_ENTERSTEP        ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE02       ] := 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE       ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := 0;

          m_DoStart := false;
          end else

          {$REGION '초기진입'}
          if 0 >= f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX] then
          begin
          f_MAUpCondition :=
          (
          (
          not m_Condition.m_UseEnterTypeC1_0
          ) or
          (
          (m_Condition.m_UseEnterTypeC1_0) and m_MatrixSeries.ConsecutiveUp(M_MATRIX_LINE_VALUE_MA0, Trunc(m_Condition.m_EnterTypeC1_0Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UseEnterTypeC1_1
          ) or
          (
          (m_Condition.m_UseEnterTypeC1_1) and m_MatrixSeries.ConsecutiveUp(M_MATRIX_LINE_VALUE_MA1, Trunc(m_Condition.m_EnterTypeC1_1Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UseEnterTypeC1_2
          ) or
          (
          (m_Condition.m_UseEnterTypeC1_2) and m_MatrixSeries.ConsecutiveUp(M_MATRIX_LINE_VALUE_MA2, Trunc(m_Condition.m_EnterTypeC1_2Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UseEnterTypeC1_3
          ) or
          (
          (m_Condition.m_UseEnterTypeC1_3) and m_MatrixSeries.AboveOf(M_MATRIX_LINE_VALUE_MA1, M_MATRIX_LINE_VALUE_MA2, f_ValueIndex)
          )
          );

          if (6 <= f_ValueIndex) then
          begin
          f_LineValue6 := m_MatrixSeries.m_Items.Items[f_ValueIndex-6];

          if
          (
          (
          (not m_Condition.m_UseEnterA)
          ) or
          (
          (m_Condition.m_UseEnterA) and
          ((f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]) > m_Condition.m_EnterAValue1*10000) and
          (f_MAUpCondition)  and
          (
          (
          not m_Condition.m_UseEnterTypeC1_4
          ) or
          (
          (m_Condition.m_UseEnterTypeC1_4) and ((f_LineValue0.m_Value[M_MATRIX_LINE_VALUE_MA0] - f_LineValue6.m_Value[M_MATRIX_LINE_VALUE_MA0]) > m_Condition.m_EnterTypeC1_4Value1*10000)
          )
          ) and
          (
          (
          not m_Condition.m_UseEnterTypeC1_5
          ) or
          (
          (m_Condition.m_UseEnterTypeC1_5) and ((f_LineValue0.m_Value[M_MATRIX_LINE_VALUE_MA1] - f_LineValue6.m_Value[M_MATRIX_LINE_VALUE_MA1]) > m_Condition.m_EnterTypeC1_5Value1*10000)
          )
          ) and
          (
          (
          not m_Condition.m_UseEnterTypeC1_6
          ) or
          (
          (m_Condition.m_UseEnterTypeC1_6) and ((f_LineValue0.m_Value[M_MATRIX_LINE_VALUE_MA2] - f_LineValue6.m_Value[M_MATRIX_LINE_VALUE_MA2]) > m_Condition.m_EnterTypeC1_6Value1*10000)
          )
          )
          )
          )
          then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX         ] := f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX    ] + 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE       ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := 0;

          if f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] < (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          end;
          m_DoStart := false;
          end;
          end;

          if (m_Condition.m_UseEnter2) and (f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01] = 0) then
          begin
          if (6 <= f_ValueIndex) then
          begin
          f_LineValue6 := m_MatrixSeries.m_Items.Items[f_ValueIndex-6];

          f_MAUpCondition :=
          (
          (
          not m_Condition.m_UseEnter2_1
          ) or
          (
          (m_Condition.m_UseEnter2_1) and m_MatrixSeries.ConsecutiveUp(M_MATRIX_LINE_VALUE_MA1, Trunc(m_Condition.m_Enter2Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UseEnter2_2
          ) or
          (
          (m_Condition.m_UseEnter2_2) and m_MatrixSeries.ConsecutiveUp(M_MATRIX_LINE_VALUE_MA2, Trunc(m_Condition.m_Enter2Value2), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UseEnter2_3
          ) or
          (
          (m_Condition.m_UseEnter2_3) and m_MatrixSeries.AboveOf(M_MATRIX_LINE_VALUE_MA1, M_MATRIX_LINE_VALUE_MA2, f_ValueIndex)
          )
          );

          if
          (f_MAUpCondition) and
          (
          (
          not m_Condition.m_UseEnter2_4
          ) or
          (
          (m_Condition.m_UseEnter2_4) and (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] < m_Condition.m_Enter2Value4*10000)
          )
          ) and
          (
          (
          not m_Condition.m_UseEnter2_5
          ) or
          (
          (m_Condition.m_UseEnter2_5) and (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] > m_Condition.m_Enter2Value5*10000)
          )
          ) and
          (
          (
          not m_Condition.m_UseEnter2_6
          ) or
          (
          (m_Condition.m_UseEnter2_6) and ((f_LineValue0.m_Value[M_MATRIX_LINE_VALUE_MA1] - f_LineValue6.m_Value[M_MATRIX_LINE_VALUE_MA1]) > m_Condition.m_Enter2Value6*10000)
          )
          ) and
          (
          (
          not m_Condition.m_UseEnter2_7
          ) or
          (
          (m_Condition.m_UseEnter2_7) and ((f_LineValue0.m_Value[M_MATRIX_LINE_VALUE_MA2] - f_LineValue6.m_Value[M_MATRIX_LINE_VALUE_MA2]) > m_Condition.m_Enter2Value7*10000)
          )
          )
          then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX         ] := f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX    ] + 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE       ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := 0;

          if f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] < (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          end;
          m_DoStart := false;
          end;
          end;
          end;

          end else
          {$ENDREGION}

          {$REGION '재진입'}
          begin

          if (6 <= f_ValueIndex) then
          begin
          f_LineValue6 := m_MatrixSeries.m_Items.Items[f_ValueIndex-6];

          f_SpecialCondition :=
          (
          (
          not m_Condition.m_UseMA1ConsecutiveUp
          ) or
          (
          (m_Condition.m_UseMA1ConsecutiveUp) and m_MatrixSeries.ConsecutiveUp(M_MATRIX_LINE_VALUE_MA1, m_Condition.m_MA1ConsecutiveUpCount, f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UseMA2ConsecutiveUp
          ) or
          (
          (m_Condition.m_UseMA2ConsecutiveUp) and m_MatrixSeries.ConsecutiveUp(M_MATRIX_LINE_VALUE_MA2, m_Condition.m_MA2ConsecutiveUpCount, f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UseMA1AboveMA2
          ) or
          (
          (m_Condition.m_UseMA1AboveMA2) and m_MatrixSeries.AboveOf(M_MATRIX_LINE_VALUE_MA1, M_MATRIX_LINE_VALUE_MA2, f_ValueIndex)
          )
          )  and
          (
          (
          not m_Condition.m_UseReEnterTypeC3_4
          ) or
          (
          (m_Condition.m_UseReEnterTypeC3_4) and ((f_LineValue0.m_Value[M_MATRIX_LINE_VALUE_MA0] - f_LineValue6.m_Value[M_MATRIX_LINE_VALUE_MA0]) > m_Condition.m_ReEnterTypeC3_4Value1*10000)
          )
          ) and
          (
          (
          not m_Condition.m_UseReEnterTypeC3_5
          ) or
          (
          (m_Condition.m_UseReEnterTypeC3_5) and ((f_LineValue0.m_Value[M_MATRIX_LINE_VALUE_MA1] - f_LineValue6.m_Value[M_MATRIX_LINE_VALUE_MA1]) > m_Condition.m_ReEnterTypeC3_5Value1*10000)
          )
          ) and
          (
          (
          not m_Condition.m_UseReEnterTypeC3_6
          ) or
          (
          (m_Condition.m_UseReEnterTypeC3_6) and ((f_LineValue0.m_Value[M_MATRIX_LINE_VALUE_MA2] - f_LineValue6.m_Value[M_MATRIX_LINE_VALUE_MA2]) > m_Condition.m_ReEnterTypeC3_6Value1*10000)
          )
          );

          f_CurrValue := f_LineValue1.m_Value[M_MATRIX_LINE_VALUE];
          f_ProfitCondition1  :=
          (
          (
          not m_Condition.m_UseReEnterB
          ) or
          (
          (m_Condition.m_UseReEnterB) and
          (CompareValue(f_CurrValue,  m_Condition.m_ReEnterBValue1 * 10000.0, g_Epsilon) < 0) and
          (CompareValue(f_CurrValue,  m_Condition.m_ReEnterBValue2 * 10000.0, g_Epsilon) > 0)
          )
          );

          f_ProfitCondition2  :=
          (
          (
          not m_Condition.m_UseReEnterC
          ) or
          (
          (m_Condition.m_UseReEnterC) and
          (
          (CompareValue(f_CurrValue,  m_Condition.m_ReEnterCValue1 * 10000.0, g_Epsilon) >= 0) or
          (CompareValue(f_CurrValue,  m_Condition.m_ReEnterCValue2 * 10000.0, g_Epsilon) <= 0)
          )
          )
          );

          if m_Condition.m_UseReEnterD then
          begin
          f_RangeCount := Trunc(m_Condition.m_ReEnterDValue1 * 60 / 10);
          f_RangeLowest := m_MatrixSeries.LowestPrice(f_RangeCount, m_MatrixSeries, M_MATRIX_LINE_VALUE, f_ValueIndex);
          end;

          f_ProfitCondition3  :=
          (
          (
          not m_Condition.m_UseReEnterD
          ) or
          (
          (m_Condition.m_UseReEnterD) and
          (
          (CompareValue(f_CurrValue,  f_RangeLowest + m_Condition.m_ReEnterDValue2 * 10000.0, g_Epsilon) >= 0) and
          (CompareValue(f_CurrValue,  f_RangeLowest + m_Condition.m_ReEnterDValue3 * 10000.0, g_Epsilon) <= 0)
          )
          )
          );


          {$REGION '조건1'}
          if m_Condition.m_UseReEnter1 and (f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01] = 0)  then
          begin
          if (f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX]) <= (m_Condition.m_ReEnter0Value1) then
          begin
          f_BarCount := f_ValueIndex - Trunc(f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX]);
          if ((f_BarCount) >= (m_Condition.m_ReEnter0Value2 * 60 / 10)) then
          begin
          f_TargetValue := f_LineValue1.m_Value[M_MATRIX_LINE_MAXVALUE];
          f_CurrValue := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];
          if  (
          (CompareValue(f_TargetValue,  f_CurrValue, g_Epsilon) <= 0) and
          (f_SpecialCondition) and (f_ProfitCondition1)
          )
          then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX         ] := f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX    ] + 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE       ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := 0;

          if f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] <
          (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          end;
          m_DoStart := false;

          end;
          end;
          end;
          end;
          {$ENDREGION}

          {$REGION '조건2'}
          if m_Condition.m_UseReEnter2 and (f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01] = 0)  then
          begin
          if (f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX]) <= (m_Condition.m_ReEnter0Value1) then
          begin
          f_BarCount := f_ValueIndex - Trunc(f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX]);
          if ((f_BarCount) >= (m_Condition.m_ReEnter0Value2 * 60 / 10)) then
          begin
          if m_Condition.m_ReEnter2Value1 < m_Condition.m_ReEnter2Value2 then
          begin
          f_TargetValue1 := m_Condition.m_ReEnter2Value1*10000;
          f_TargetValue2 := m_Condition.m_ReEnter2Value2*10000;
          end else
          begin
          f_TargetValue1 := m_Condition.m_ReEnter2Value2*10000;
          f_TargetValue2 := m_Condition.m_ReEnter2Value1*10000;
          end;

          f_CurrValue := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];
          if  (
          (CompareValue(f_TargetValue1,  f_CurrValue, g_Epsilon) <= 0) and
          (CompareValue(f_CurrValue,  f_TargetValue2, g_Epsilon) <= 0) and
          (f_SpecialCondition) and (f_ProfitCondition1) and (f_ProfitCondition2) and (f_ProfitCondition3)
          )
          then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX         ] := f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX    ] + 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE       ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := 0;

          if f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] < (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          end;
          m_DoStart := false;
          end;
          end;
          end;
          end;
          {$ENDREGION}

          {$REGION '조건3'}
          if m_Condition.m_UseReEnter3 and (f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01] = 0)  then
          begin
          if (f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX]) <= (m_Condition.m_ReEnter0Value1) then
          begin
          f_BarCount := f_ValueIndex - Trunc(f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX]);
          if ((f_BarCount) >= (m_Condition.m_ReEnter0Value2 * 60 / 10)) then
          begin
          f_RangeValue := abs(f_LineValue0.m_Value[M_MATRIX_LINE_MAXVALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE]);
          f_CurrValue := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];

          if m_Condition.m_ReEnter3Value1 < m_Condition.m_ReEnter3Value2 then
          begin
          f_TargetValue1 := f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE] +
          (f_RangeValue * m_Condition.m_ReEnter3Value1) / 100.0;
          f_TargetValue2 := f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE] +
          (f_RangeValue * m_Condition.m_ReEnter3Value2) / 100.0;
          end else
          begin
          f_TargetValue1 := f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE] +
          (f_RangeValue * m_Condition.m_ReEnter3Value2) / 100.0;
          f_TargetValue2 := f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE] +
          (f_RangeValue * m_Condition.m_ReEnter3Value1) / 100.0;
          end;

          if  (
          (CompareValue(f_TargetValue1,  f_CurrValue, g_Epsilon) <= 0) and
          (CompareValue(f_CurrValue,  f_TargetValue2, g_Epsilon) <= 0)
          )
          then
          begin
          if  (
          (CompareValue(abs(m_Condition.m_ReEnter3Value3 * 10000.0),  f_RangeValue, g_Epsilon) <= 0) and
          (CompareValue(m_Condition.m_ReEnter3Value4 * 10000.0,  f_CurrValue, g_Epsilon) <= 0) and
          (f_SpecialCondition) and (f_ProfitCondition1)  and (f_ProfitCondition2) and (f_ProfitCondition3)
          )
          then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX         ] := f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX    ] + 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE       ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := 0;

          if f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] < (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          end;
          m_DoStart := false;
          end;
          end;
          end;
          end;
          end;
          {$ENDREGION}

          {$REGION '조건4'}
          if m_Condition.m_UseReEnter4 and (f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01] = 0)  then
          begin
          //  정해진 횟수 미만으로 재진입을 하였고, 즉 재진입 횟수조건에 만족하고.
          if (f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX]) <= (m_Condition.m_ReEnter0Value1) then
          begin
          //  이전 매매구역 정지후 일정시간이 지난 후에..
          f_BarCount := f_ValueIndex - Trunc(f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX]);
          if ((f_BarCount) >= (m_Condition.m_ReEnter0Value2 * 60 / 10)) then
          begin

          //  최저점에서 일정금액 상승한 후 에
          f_CurrValue := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];

          if m_Condition.m_ReEnter4Value1 < m_Condition.m_ReEnter4Value2 then
          begin
          f_TargetValue1 := f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE] + m_Condition.m_ReEnter4Value1 * 10000.0;
          f_TargetValue2 := f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE] + m_Condition.m_ReEnter4Value2 * 10000.0;
          end else
          begin
          f_TargetValue1 := f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE] + m_Condition.m_ReEnter4Value2 * 10000.0;
          f_TargetValue2 := f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE] + m_Condition.m_ReEnter4Value1 * 10000.0;
          end;


          if  (
          (CompareValue(f_TargetValue1,  f_CurrValue, g_Epsilon) <= 0) and
          (CompareValue(f_CurrValue,  f_TargetValue2, g_Epsilon) <= 0)
          )
          then
          begin
          if ((f_SpecialCondition) and (f_ProfitCondition1) and (f_ProfitCondition2) and (f_ProfitCondition3))
          then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 2;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX         ] := f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX    ] + 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE       ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := 0;

          if f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] < (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          end;

          f_LineValue0.m_Value[M_MATRIX_LINE_ENTERSTEP        ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE02       ] := 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE       ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := 0;

          m_DoStart := false;
          end;
          end;
          end;
          end;
          end;
          {$ENDREGION}

          {$REGION '조건5'}
          if m_Condition.m_UseReEnter5 and (f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01] = 0)  then
          begin
          //  정해진 횟수 미만으로 재진입을 하였고, 즉 재진입 횟수조건에 만족하고.
          if (f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX]) <= (m_Condition.m_ReEnter0Value1) then
          begin
          //  이전 매매구역 정지후 일정시간이 지난 후에..
          f_BarCount := f_ValueIndex - Trunc(f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX]);
          if ((f_BarCount) >= (m_Condition.m_ReEnter0Value2 * 60 / 10)) then
          begin

          f_MAUpCondition :=
          (
          (
          not m_Condition.m_UseReEnter5_1
          ) or
          (
          (m_Condition.m_UseReEnter5_1) and m_MatrixSeries.ConsecutiveUp(M_MATRIX_LINE_VALUE_MA1, Trunc(m_Condition.m_ReEnter5_1Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UseReEnter5_2
          ) or
          (
          (m_Condition.m_UseReEnter5_2) and m_MatrixSeries.ConsecutiveUp(M_MATRIX_LINE_VALUE_MA2, Trunc(m_Condition.m_ReEnter5_2Value1), f_ValueIndex)
          )
          ) and
          (
          (
          not m_Condition.m_UseReEnter5_3
          ) or
          (
          (m_Condition.m_UseReEnter5_3) and m_MatrixSeries.AboveOf(M_MATRIX_LINE_VALUE_MA1, M_MATRIX_LINE_VALUE_MA2, f_ValueIndex)
          )
          );

          if (f_MAUpCondition) and (f_ProfitCondition1) and (f_ProfitCondition2) and (f_ProfitCondition3) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX         ] := f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX    ] + 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE       ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := 0;

          if f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] < (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          end;
          m_DoStart := false;
          end;
          end;
          end;
          end;
          {$ENDREGION}

          {$REGION '조건6'}
          if m_Condition.m_UseReEnter6 and (f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01] = 0)  then
          begin
          //  정해진 횟수 미만으로 재진입을 하였고, 즉 재진입 횟수조건에 만족하고.
          if (f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX]) <= (m_Condition.m_ReEnter0Value1) then
          begin
          //  이전 매매구역 정지후 일정시간이 지난 후에..
          f_BarCount := f_ValueIndex - Trunc(f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX]);
          if ((f_BarCount) >= (m_Condition.m_ReEnter0Value2 * 60 / 10)) then
          begin
          f_RangeCount := Trunc(m_Condition.m_ReEnter6Value1 * 60 / 10);

          //  최저점에서 일정금액 상승한 후 에
          f_CurrValue := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE];

          f_RangeLowest := m_MatrixSeries.LowestPrice(f_RangeCount, m_MatrixSeries, M_MATRIX_LINE_VALUE, f_ValueIndex);

          f_TargetValue := f_RangeLowest + m_Condition.m_ReEnter6Value2 * 10000.0;

          if  (
          (CompareValue(f_TargetValue,  f_CurrValue, g_Epsilon) < 0)
          )
          then
          begin
          if  (
          (f_SpecialCondition) and (f_ProfitCondition1) and (f_ProfitCondition2) and (f_ProfitCondition3)
          )
          then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 2;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX         ] := f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX    ] + 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE       ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := 0;

          if f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] < (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          end;

          f_LineValue0.m_Value[M_MATRIX_LINE_ENTERSTEP        ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE02       ] := 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE       ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := 0;
          m_DoStart := false;

          end;
          end;
          end;
          end;
          end;
          {$ENDREGION}
          end;
          end;
          {$ENDREGION}

          end;
          {$ENDREGION}

          {$ENDREGION}

          {$REGION '2차 허용구간'}
          if (f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01] = 2) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 1;
          end else
          begin

          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE02] := f_LineValue1.m_Value[M_MATRIX_LINE_CANTRADE02];
          f_LineValue0.m_Value[M_MATRIX_LINE_ENTERSTEP ] := f_LineValue1.m_Value[M_MATRIX_LINE_ENTERSTEP ];

          if 1 < f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX] then
          begin
          if (f_LineValue1.m_Value[M_MATRIX_LINE_CANTRADE01] =  0) and (f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01] <> 0) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_ENTERSTEP] := 1;
          end else
          if (f_LineValue1.m_Value[M_MATRIX_LINE_CANTRADE01] <> 0) and (f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01] =  0) then
          begin
          if 1 = f_LineValue0.m_Value[M_MATRIX_LINE_ENTERSTEP] then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX] := f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX] - 1;
          if f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX] < 0  then f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX] := 0;
          end;
          f_LineValue0.m_Value[M_MATRIX_LINE_ENTERSTEP] := 0;
          end;

          if (0 = f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE02]) then
          begin
          if 1 = f_LineValue0.m_Value[M_MATRIX_LINE_ENTERSTEP] then
          begin
          f_RangeValue := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE];

          if
          (
          (not m_Condition.m_UseReEnterA)
          ) or
          (
          (m_Condition.m_UseReEnterA) and
          (f_RangeValue > m_Condition.m_ReEnterAValue1*10000)
          )
          then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_ENTERSTEP        ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE02       ] := 1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := f_LineValue0.m_Value[M_MATRIX_LINE_VALUE       ];
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := 0;
          if f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] < (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE] := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          end;
          end else
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE02] := 0;
          end;
          end;
          end else
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE02] := f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01];
          end;
          end else
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE02] := f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01];
          end;
          end;
          {$ENDREGION}

          end else
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE01       ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_INDEX         ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE   ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_MAXVALUE      ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXITI_NDEX    ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_STOP_TYPE     ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_MAXVALUE         ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_NOTR_LOWESTVALUE ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE02       ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_ENTERSTEP        ] := 0;
          end;

          //end;
          {$ENDREGION}

          {$REGION '중간수익을 추출한다'}
          //for f_ValueIndex := f_Begin to f_End - 1 do
          //begin
          f_LineValue0 := m_MatrixSeries.m_Items.Items[f_ValueIndex];
          if (1 <= f_ValueIndex) then
          begin
          f_LineValue1 := m_MatrixSeries.m_Items.Items[f_ValueIndex-1];

          if (1 = f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE02]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_VALUE] := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          end else
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_VALUE] := 0;
          end;

          if (1 = f_LineValue1.m_Value[M_MATRIX_LINE_CANTRADE02]) AND (0 = f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE02]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXIT_VALUE] :=
          f_LineValue1.m_Value[M_MATRIX_LINE_TR_EXIT_VALUE] + (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          end else
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXIT_VALUE] := f_LineValue1.m_Value[M_MATRIX_LINE_TR_EXIT_VALUE];
          end;

          f_LineValue0.m_Value[M_MATRIX_LINE_INTERVALUE1] :=
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXIT_VALUE] +
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_VALUE     ];

          end else
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_VALUE     ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXIT_VALUE] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_INTERVALUE1   ] := 0;
          end;
          //end;


          m_DoStop := false;
          m_DoStart := false;
          end;
          {$ENDREGION}

          {$REGION '최대 이익 정지, 최대 손실 정지'}
          for f_ValueIndex := f_Begin to f_End - 1 do
          begin
          f_LineValue0 := m_MatrixSeries.m_Items.Items[f_ValueIndex];
          if (1 <= f_ValueIndex) then
          begin
          f_LineValue1 := m_MatrixSeries.m_Items.Items[f_ValueIndex-1];
          if (0 <> f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE02]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE03] := -1;
          end else
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE03] :=  0;
          end;

          f_LineValue0.m_Value[M_MATRIX_LINE_TRADE_STOP       ] := f_LineValue1.m_Value[M_MATRIX_LINE_TRADE_STOP      ];

          if (0 = f_LineValue0.m_Value[M_MATRIX_LINE_TRADE_STOP]) then
          begin
          f_CurrValue := f_LineValue0.m_Value[M_MATRIX_LINE_INTERVALUE1];
          if m_Condition.m_UseLossTradeStop then
          begin
          if CompareValue(f_CurrValue, m_Condition.m_LossTradeStopValue1*10000.0, g_Epsilon) <= 0 then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TRADE_STOP] := 1;
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
          LOG_WRITE
          (
          LOG_TYPE_INFO,
          'CMXBlockManager',
          '[최대손실정지]에 의해 전체매매가 정지됩니다.-' + TFNGlobal.DateTimeToStr6(f_ChartData.m_OpenDateTime)
          );
          end;
          end;

          if m_Condition.m_UseProfitTradeStop then
          begin
          if CompareValue(f_CurrValue, m_Condition.m_ProfitTradeStopValue1*10000.0, g_Epsilon) >= 0 then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TRADE_STOP] := 1;
          f_ChartData := CMKChartData(m_ChartDataSeries.m_Items.Items[f_ValueIndex]);
          LOG_WRITE
          (
          LOG_TYPE_INFO,
          'CMXBlockManager',
          '[최대이익정지]에 의해 전체매매가 정지됩니다.-' + TFNGlobal.DateTimeToStr6(f_ChartData.m_OpenDateTime)
          );
          end;
          end;
          end;

          if 1 = f_LineValue0.m_Value[M_MATRIX_LINE_TRADE_STOP] then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE03       ] := 0;
          end;

          end else
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE03       ] := -1;
          f_LineValue0.m_Value[M_MATRIX_LINE_TRADE_STOP       ] := 0;
          end;
          end;
          {$ENDREGION}

          {$REGION '최종수익을 추출한다'}
          for f_ValueIndex := f_Begin to f_End - 1 do
          begin
          f_LineValue0 := m_MatrixSeries.m_Items.Items[f_ValueIndex];
          if (1 <= f_ValueIndex) then
          begin
          f_LineValue1 := m_MatrixSeries.m_Items.Items[f_ValueIndex-1];

          if (-1 = f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE03]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_VALUE03] := (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          end else
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_VALUE03] := 0;
          end;

          if (-1 = f_LineValue1.m_Value[M_MATRIX_LINE_CANTRADE03]) AND (0 = f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE03]) then
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXIT_VALUE03] :=
          f_LineValue1.m_Value[M_MATRIX_LINE_TR_EXIT_VALUE03] + (f_LineValue0.m_Value[M_MATRIX_LINE_VALUE] - f_LineValue0.m_Value[M_MATRIX_LINE_TR_ENTER_VALUE]);
          end else
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXIT_VALUE03] := f_LineValue1.m_Value[M_MATRIX_LINE_TR_EXIT_VALUE03];
          end;

          f_LineValue0.m_Value[M_MATRIX_LINE_FINALVALUE] :=
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXIT_VALUE03] +
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_VALUE03     ];

          end else
          begin
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_VALUE03     ] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_TR_EXIT_VALUE03] := 0;
          f_LineValue0.m_Value[M_MATRIX_LINE_FINALVALUE   ] := 0;
          end;

          end;
          {$ENDREGION}
        *)
{$ENDREGION}
{$REGION '각 매매블럭에 값을 전달한다'}
        for f_ItemIndex := 0 to m_Items.Count - 1 do
        begin
          f_Block := CMXBlock(m_Items[f_ItemIndex]);
          f_ZeroIndex := f_Block.SystemManager.m_ChartDataSeries.m_ZeroIndex;
          f_Block.SystemManager.m_MergeSeries2.SetLengthSeries(f_End + f_ZeroIndex);
          try
            if (0 = f_Begin) then
            begin
              for f_ValueIndex := 0 to f_ZeroIndex - 1 do
              begin
                f_SrcLineValue0 := f_Block.SystemManager.m_MergeSeries2.m_Items.Items[f_ValueIndex];
                f_SrcLineValue0.m_Value[0] := 1;
              end;
            end;
            for f_ValueIndex := f_Begin to f_End - 1 do
            begin
              f_LineValue0 := m_MatrixSeries.m_Items.Items[f_ValueIndex];
              f_SrcLineValue0 := f_Block.SystemManager.m_MergeSeries2.m_Items.Items[f_ValueIndex + f_ZeroIndex];
              f_SrcLineValue0.m_Value[0] := abs(f_LineValue0.m_Value[M_MATRIX_LINE_CANTRADE03]);
              f_SrcLineValue0.m_Value[0] := 1;
            end;
            f_Block.SystemManager.SetMerge2Changed(true);
          finally
          end;
        end;
{$ENDREGION}
        m_Updated := true;
      end;
{$ENDREGION}
    finally

{$REGION '각 아이템의 락을 푼다'}
      for f_ItemIndex := 0 to m_Items.Count - 1 do
      begin
        f_Block := CMXBlock(m_Items[f_ItemIndex]);
        f_Block.SystemManager.Unlock;
      end;
{$ENDREGION}
    end;

  end;
end;
{$ENDREGION}
{$REGION '파일입출력'}

procedure CMXBlockManager.Read(AXMLNode: IXMLNode);
begin

end;

function CMXBlockManager.Write: String;
begin

end;
{$ENDREGION}

end.
