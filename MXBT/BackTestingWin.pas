unit BackTestingWin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ActnList,  StdCtrls, ComCtrls,
  ExtCtrls, FNMatrixOptionFrame, ToolWin, MXBlock, FNTradeSystem, FNTrafficManager,
  MXOption, MXSystemManager, MXOrderManager, Buttons;

const
    WM_BACKTESING_START         =   WM_USER + 1237;

type
  TMDIBackTesting = class(TForm)
    PageControl1: TPageControl;
    TabSheet6: TTabSheet;
    Panel36: TPanel;
    TabSheet8: TTabSheet;
    Panel45: TPanel;
    ActionList1: TActionList;
    Action_0001: TAction;
    Action_0002: TAction;
    ImageListNormal: TImageList;
    ImageList1: TImageList;
    ImageList4: TImageList;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    DateTimePickerStartDate: TDateTimePicker;
    DateTimePickerEndDate: TDateTimePicker;
    Panel2: TPanel;
    ListViewLog: TListView;
    Panel3: TPanel;
    Panel4: TPanel;
    ListViewDailyPM: TListView;
    Splitter1: TSplitter;
    ButtonToday: TButton;
    Button1Week: TButton;
    Button1Month: TButton;
    Button3Month: TButton;
    Button6Month: TButton;
    Button1Year: TButton;
    Button2Year: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    MatrixOptionFrame1: TMatrixOptionFrame;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListViewLogData(Sender: TObject; Item: TListItem);
    procedure Action_0001Execute(Sender: TObject);
    procedure Action_0002Execute(Sender: TObject);
    procedure Action_0001Update(Sender: TObject);
    procedure Action_0002Update(Sender: TObject);
    procedure ListViewDailyPMData(Sender: TObject; Item: TListItem);
    procedure ListViewDailyPMCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure ListViewDailyPMCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ButtonTodayClick(Sender: TObject);
    procedure Button1WeekClick(Sender: TObject);
    procedure Button1MonthClick(Sender: TObject);
    procedure Button3MonthClick(Sender: TObject);
    procedure Button6MonthClick(Sender: TObject);
    procedure Button1YearClick(Sender: TObject);
    procedure Button2YearClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Panel36Click(Sender: TObject);

  private
    m_Block:CMXBlock;
    m_EnableEvent:Boolean;
    m_StandDate : TDateTime;
    m_StartDate : TDateTime;
    m_EndDate : TDateTime;
    m_Doing : Boolean;

    procedure OnLog(ASender: TObject; ADateTime:TDateTime; AType:Integer; AMessage, AClassName:String);

    procedure WMBTStart(var Message: TMessage); message WM_BACKTESING_START;

  protected
    m_StartDateTime:TDateTime;
    m_TradeListFileName : String;
    m_DailyPerfomanceFileName : String;

    m_DailyPMValueCollection:CFNDailyPMValueCollection;
    procedure SaveConfigData;
    procedure MakeTradeListFile;
    procedure SaveTradeList;
    procedure MakeDailyPerfomanceFile;
    procedure SaveDailyPerfomance;

  protected
    procedure OnChangedOption(Sender: TObject);
    procedure ClearLogInfo;
    procedure DisplayLogInfo;
    procedure OnDoneWork1Day(Sender: TObject);
    procedure DoStart1Day;
    procedure DoStop1Day;
    procedure ClearDailyPMListView;
    procedure DisplayDailyPMListView;
    procedure DoStart;
    procedure DoStop;

  public
    constructor Create(AOwner:TComponent);
    destructor Destroy; override;
    procedure UpdateData;
    procedure GetOption;
    property Block:CMXBlock read m_Block;

  end;

var
  MDIBackTesting: TMDIBackTesting;

implementation

{$R *.dfm}

uses
    FNRegistry, FNGlobal, DateUtils, FNCMVariable, Math,
    MKChartDataSeries, MKChartData, MKLineValue, FNPOTCollection, ShellAPI;

//------------------------------------------------------------------------------------
constructor TMDIBackTesting.Create(AOwner:TComponent);
begin
    inherited Create(AOwner);
    m_EnableEvent := true;

    m_Block := CMXBlock.Create;
    m_Block.Option.SetIntegerValue('SYSTEM_MODE'            , SYSTEM_MODE_SIMULATION);

    m_Block.Option.SetBooleanValue('USE_STAND_DATE'         , true);
    m_Block.Option.SetBooleanValue('USE_HISTORY_CHARTDATA'  , true);

    m_Block.SystemManager.BackTestingMode := true;
    m_Block.SystemManager.AloneMode := true;

    m_DailyPMValueCollection := CFNDailyPMValueCollection.Create;

    m_Doing := false;

    m_DailyPerfomanceFileName := '';
    m_TradeListFileName := '';

end;

//------------------------------------------------------------------------------------
destructor TMDIBackTesting.Destroy;
begin
    if Assigned(m_Block) then
    begin
        m_Block.Free;
        m_Block := NIL;
    end;

    m_DailyPMValueCollection.Free;

    m_Doing := false;
    inherited;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.FormClose(Sender: TObject; var Action: TCloseAction);
var
    f_Registry:CFNRegistry;
begin

    f_Registry := CFNRegistry.Create(self);
    f_Registry.Company := g_CompanyName;
    f_Registry.ApplicationName := g_ApplicationName;
    f_Registry.WriteInteger('Setting', 'StartDate', Trunc(DateTimePickerStartDate.DateTime));
    f_Registry.Free;

    Action := caFree;
    if m_Block.SystemManager.State then
    begin
        m_Block.SystemManager.Stop;
    end;

    ClearLogInfo;
    MatrixOptionFrame1.OnFormClose;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.FormCreate(Sender: TObject);
var
    f_Registry:CFNRegistry;
    f_Date:TDateTime;
begin
    f_Registry := CFNRegistry.Create(self);
    f_Registry.Company := g_CompanyName;
    f_Registry.ApplicationName := g_ApplicationName;

    DateTimePickerStartDate.DateTime := f_Registry.ReadInteger('Setting', 'StartDate', Trunc(EncodeDate(2011, 6, 2)));
    DateTimePickerEndDate.DateTime := Now;

    f_Registry.Free;

    PageControl1.ActivePageIndex := 0;

    MatrixOptionFrame1.OnFormCreate;
    MatrixOptionFrame1.AttachBlock(m_Block);
    MatrixOptionFrame1.OnChangedOption :=  OnChangedOption;

    Caption := m_Block.BlockName;

    Width := 1100;
    Height := 670;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.ClearDailyPMListView;
begin
    if not Assigned(m_Block) then exit;

    ListViewDailyPM.Items.Count := 0;
    ListViewDailyPM.Repaint;
    m_DailyPMValueCollection.Clear;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.DisplayDailyPMListView;
begin
    if not Assigned(m_Block) then exit;

    ListViewDailyPM.Items.Count := m_DailyPMValueCollection.m_Items.Count;
    ListViewDailyPM.Repaint;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.Action_0001Execute(Sender: TObject);
begin
    if not Assigned(m_Block) then exit;
    if m_Doing then exit;

    DoStart;

    m_Doing := true;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.Action_0001Update(Sender: TObject);
begin
    if not Assigned(m_Block) then exit;

    if (Not m_Block.SystemManager.State) then Action_0001.Enabled := true else Action_0001.Enabled := false;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.Action_0002Execute(Sender: TObject);
begin
    if not Assigned(m_Block) then exit;
    if not m_Doing then exit;
    DoStop;
    m_Doing := false;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.Action_0002Update(Sender: TObject);
begin
    if not Assigned(m_Block) then exit;

    if (m_Block.SystemManager.State) then Action_0002.Enabled := true else Action_0002.Enabled := false;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.Button6MonthClick(Sender: TObject);
var
    f_Date:TDateTime;
    Year                :   Word;
    Month               :   Word;
    Day                 :   Word;
begin
    f_Date := Now-180;
    DecodeDate(f_Date, Year, Month, Day);

    DateTimePickerStartDate.DateTime := EncodeDate(Year, Month, 1);
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.ButtonTodayClick(Sender: TObject);
begin
    DateTimePickerStartDate.DateTime := Now;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.Button1WeekClick(Sender: TObject);
begin
    DateTimePickerStartDate.DateTime := Now-7;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.Button1YearClick(Sender: TObject);
var
    f_Date:TDateTime;
    Year                :   Word;
    Month               :   Word;
    Day                 :   Word;
begin
    f_Date := Now-365;
    DecodeDate(f_Date, Year, Month, Day);

    DateTimePickerStartDate.DateTime := EncodeDate(Year, Month, 1);
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.Button2YearClick(Sender: TObject);
var
    f_Date:TDateTime;
    Year                :   Word;
    Month               :   Word;
    Day                 :   Word;
begin
    f_Date := Now-365*2;
    DecodeDate(f_Date, Year, Month, Day);

    DateTimePickerStartDate.DateTime := EncodeDate(Year, Month, 1);
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.Button1MonthClick(Sender: TObject);
var
    f_Date:TDateTime;
    Year                :   Word;
    Month               :   Word;
    Day                 :   Word;
begin
    f_Date := Now-30;
    DecodeDate(f_Date, Year, Month, Day);

    DateTimePickerStartDate.DateTime := EncodeDate(Year, Month, 1);
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.Button3MonthClick(Sender: TObject);
var
    f_Date:TDateTime;
    Year                :   Word;
    Month               :   Word;
    Day                 :   Word;
begin
    f_Date := Now-90;
    DecodeDate(f_Date, Year, Month, Day);

    DateTimePickerStartDate.DateTime := EncodeDate(Year, Month, 1);
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.UpdateData;
begin
    m_Block.Option.SetIntegerValue('SYSTEM_MODE'            , SYSTEM_MODE_SIMULATION);
    m_Block.Option.SetBooleanValue('USE_STAND_DATE'         , true);
    m_Block.Option.SetBooleanValue('USE_HISTORY_CHARTDATA'  , true);
    MatrixOptionFrame1.DetachBlock(false);
    MatrixOptionFrame1.AttachBlock(m_Block);
    MatrixOptionFrame1.UpdateOnChangedBlock;

    //MatrixOptionFrame1.SetOption;

    Caption :=  m_Block.BlockName;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.GetOption;
begin
    MatrixOptionFrame1.GetOption;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.OnChangedOption(Sender: TObject);
begin
    Caption := m_Block.BlockName;
end;

{$REGION 'Log처리'}
//------------------------------------------------------------------------------------
procedure TMDIBackTesting.OnLog(ASender: TObject; ADateTime:TDateTime; AType:Integer; AMessage, AClassName:String);
var
    f_LogItem:CFNLogItem;
begin
    if not Assigned(m_Block) then exit;

    f_LogItem := CFNLogItem.Create;

    f_LogItem.m_DateTime := ADateTime;
    f_LogItem.m_Type := AType;
    f_LogItem.m_Message := AMessage;
    f_LogItem.m_ClassName := AClassName;

    m_Block.LogCollection.m_Items.Insert(0, f_LogItem);

    DisplayLogInfo;
end;

procedure TMDIBackTesting.Panel36Click(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.ClearLogInfo;
begin
    if not Assigned(m_Block) then exit;
    ListViewLog.Items.Count := 0;
    m_Block.LogCollection.Clear;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.DisplayLogInfo;
begin
    if not Assigned(m_Block) then exit;

    ListViewLog.Items.Count := m_Block.LogCollection.m_Items.Count;
    ListViewLog.Repaint;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.ListViewLogData(Sender: TObject; Item: TListItem);
var
    nItemIndex : integer;
    f_LogItem:CFNLogItem;
begin
    if ((Item.Index < 0) or (Item.Index >= m_Block.LogCollection.m_Items.Count)) then exit;
    nItemIndex := Item.Index;
    f_LogItem := m_Block.LogCollection.m_Items[nItemIndex];

    Item.Caption := TFNGlobal.DateTimeToStr6(f_LogItem.m_DateTime);
    Item.SubItems.Add(GetLogTypeText(f_LogItem.m_Type));
    Item.SubItems.Add(f_LogItem.m_Message);
    Item.SubItems.Add(f_LogItem.m_ClassName);
    Item.Data := f_LogItem;
end;
{$ENDREGION}

{$REGION '일별실적화면 출력'}
//------------------------------------------------------------------------------------
procedure TMDIBackTesting.ListViewDailyPMCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
    Sender.Canvas.Brush.Color := RGB($C0,$C0,$C0);
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.ListViewDailyPMCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
    f_PMItem:CFNDailyPMValueItem;
begin
    f_PMItem := Item.Data;

    if Item.Index <= 1 then
    begin
        Sender.Canvas.Brush.Color := RGB($C0,$C0,$C0);
    end else
    begin
        if Item.Index mod 2 = 0 then
        begin
            Sender.Canvas.Brush.Color := RGB($FF,$FF,$FF);
        end else
        begin
            Sender.Canvas.Brush.Color := RGB($F0,$F0,$F0);
        end;
    end;

    if (SubItem = 1) then
    begin
        if (f_PMItem.m_TProfit > 0) then
        begin
            Sender.Canvas.Font.Color := RGB($FF, $00,  $00);
        end else
        if (f_PMItem.m_TProfit < 0) then
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $FF);
        end else
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $00);
        end;
    end else
    if (SubItem = 2) then
    begin
        if (f_PMItem.m_TProfitSum > 0) then
        begin
            Sender.Canvas.Font.Color := RGB($FF, $00,  $00);
        end else
        if (f_PMItem.m_TProfitSum < 0) then
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $FF);
        end else
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $00);
        end;
    end else
    if (SubItem = 3) then
    begin
        if (f_PMItem.m_BProfit > 0) then
        begin
            Sender.Canvas.Font.Color := RGB($FF, $00,  $00);
        end else
        if (f_PMItem.m_BProfit < 0) then
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $FF);
        end else
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $00);
        end;
    end else
    if (SubItem = 4) then
    begin
        if (f_PMItem.m_BProfitSum > 0) then
        begin
            Sender.Canvas.Font.Color := RGB($FF, $00,  $00);
        end else
        if (f_PMItem.m_BProfitSum < 0) then
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $FF);
        end else
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $00);
        end;
    end else
    if (SubItem = 5) then
    begin
        if (f_PMItem.m_SProfit > 0) then
        begin
            Sender.Canvas.Font.Color := RGB($FF, $00,  $00);
        end else
        if (f_PMItem.m_SProfit < 0) then
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $FF);
        end else
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $00);
        end;
    end else
    if (SubItem = 6) then
    begin
        if (f_PMItem.m_SProfitSum > 0) then
        begin
            Sender.Canvas.Font.Color := RGB($FF, $00,  $00);
        end else
        if (f_PMItem.m_SProfitSum < 0) then
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $FF);
        end else
        begin
            Sender.Canvas.Font.Color := RGB($00, $00,  $00);
        end;
    end else
    begin
        Sender.Canvas.Font.Color := RGB($00, $00,  $00);
    end;

    if Item.Index > 1 then
    begin
        if (SubItem = 2) or (SubItem = 4) or (SubItem = 6) then
        begin
            Sender.Canvas.Brush.Color := RGB($EE,$EE,$EE);
        end;
    end;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.ListViewDailyPMData(Sender: TObject; Item: TListItem);
var
    nItemIndex : integer;
    f_Item:CFNDailyPMValueItem;
begin
    if ((Item.Index < 0) or (Item.Index >= m_DailyPMValueCollection.m_Items.Count)) then exit;
    nItemIndex := Item.Index;
    f_Item := m_DailyPMValueCollection.m_Items[m_DailyPMValueCollection.m_Items.Count - nItemIndex - 1];

    if f_Item.m_Date = 1 then
    begin
        Item.Caption := '합계';
    end else
    if f_Item.m_Date = 2 then
    begin
        Item.Caption := '평균';
    end else
    begin
        Item.Caption := DateToStr(f_Item.m_Date);
    end;

    Item.SubItems.Add(Format('%.5n', [f_Item.m_TProfit]));
    if f_Item.m_Date < 10 then
    begin
        Item.SubItems.Add('');
    end else
    begin
        Item.SubItems.Add(Format('%.5n', [f_Item.m_TProfitSum]));
    end;

    Item.SubItems.Add(Format('%.5f', [f_Item.m_BProfit]));
    if f_Item.m_Date < 10 then
    begin
        Item.SubItems.Add('');
    end else
    begin
        Item.SubItems.Add(Format('%.5n', [f_Item.m_BProfitSum]));
    end;

    Item.SubItems.Add(Format('%.5f', [f_Item.m_SProfit]));
    if f_Item.m_Date < 10 then
    begin
        Item.SubItems.Add('');
    end else
    begin
        Item.SubItems.Add(Format('%.5n', [f_Item.m_SProfitSum]));
    end;

    Item.SubItems.Add(Format('%.5n', [f_Item.m_TNumberOfTrades]));
    Item.SubItems.Add(Format('%.5n', [f_Item.m_BNumberOfTrades]));
    Item.SubItems.Add(Format('%.5n', [f_Item.m_SNumberOfTrades]));
    Item.SubItems.Add(Format('%.5n', [f_Item.m_Price]));
    Item.Data := f_Item;
end;
{$ENDREGION}

{$REGION '파일로 출력'}
//------------------------------------------------------------------------------------
procedure TMDIBackTesting.SaveConfigData;
var
    f_FileName:String;
    f_FilePath:String;
    f_Stream:TStringStream;
begin
    f_FilePath := ExtractFilePath(ParamStr(0)) + 'BackTesting\';
    if not DirectoryExists(f_FilePath) then
    begin
        CreateDir(f_FilePath);
    end;

    f_FileName := f_FilePath + m_Block.BlockName + '_' + TFNGlobal.DateTimeToString(m_StartDateTime, 'YYYYMMDDHHMMSS') + '_Config.xml';

    f_Stream := TStringStream.Create;
    f_Stream.WriteString('<BlockCollection>' + #$0A);
    f_Stream.WriteString(m_Block.Write);
    f_Stream.WriteString('</BlockCollection>' + #$0A);

    f_Stream.SaveToFile(f_FileName);
    f_Stream.Free;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.SaveDailyPerfomance;
var
    f_TrafficManager:CFNTrafficManager;
    f_TrafficCollection : CFNTrafficCollection;
    f_Mode:Word;
    f_FileStream:TFileStream;
    f_TimeString:String;
    f_DesEncoding:TEncoding;
    f_ByteOrderMark:TBytes;
    f_Buffer:TBytes;
    f_ItemIndex:integer;
    f_TrafficItem : CFNTrafficItem;
    f_Line:String;
    f_DailyPMValueItem:CFNDailyPMValueItem;
    f_PMItem:CFNDailyPMValueItem;

    f_SumPMItem:CFNDailyPMValueItem;
    f_AvgPMItem:CFNDailyPMValueItem;

    f_Index:Integer;

    f_TProfitSum : Double;
    f_BProfitSum : Double;
    f_SProfitSum : Double;
begin
    try
        if m_DailyPMValueCollection.m_Items.Count > 0 then
        begin
            CFNDailyPMValueItem(m_DailyPMValueCollection.m_Items.Items[m_DailyPMValueCollection.m_Items.Count-1]).Free;
            m_DailyPMValueCollection.m_Items.Delete(m_DailyPMValueCollection.m_Items.Count-1);
        end;

        if m_DailyPMValueCollection.m_Items.Count > 0 then
        begin
            CFNDailyPMValueItem(m_DailyPMValueCollection.m_Items.Items[m_DailyPMValueCollection.m_Items.Count-1]).Free;
            m_DailyPMValueCollection.m_Items.Delete(m_DailyPMValueCollection.m_Items.Count-1);
        end;

        f_TrafficManager := CFNTrafficManager.Create;

        f_TrafficManager.MakeTradeListOfBacktesting(
            m_Block.Option,
            m_Block.SystemManager.m_SignalArray,
            m_Block.SystemManager.m_RealPrice
        );

        f_TrafficCollection := f_TrafficManager.m_AllTrafficCollection;

        f_DailyPMValueItem := CFNDailyPMValueItem.Create;
        f_DailyPMValueItem.m_Date := m_StandDate;

        f_DailyPMValueItem.m_TProfit := f_TrafficManager.m_AllTrafficCollection.m_NetProfit;
        f_DailyPMValueItem.m_TNumberOfTrades := f_TrafficManager.m_AllTrafficCollection.m_NumberOfTrades;

        f_DailyPMValueItem.m_BProfit := f_TrafficManager.m_LongTrafficCollection.m_NetProfit;
        f_DailyPMValueItem.m_BNumberOfTrades := f_TrafficManager.m_LongTrafficCollection.m_NumberOfTrades;

        f_DailyPMValueItem.m_SProfit := f_TrafficManager.m_ShortTrafficCollection.m_NetProfit;
        f_DailyPMValueItem.m_SNumberOfTrades := f_TrafficManager.m_ShortTrafficCollection.m_NumberOfTrades;

        f_DailyPMValueItem.m_Price := m_Block.SystemManager.m_RealPrice;

        m_DailyPMValueCollection.Add(f_DailyPMValueItem);

        f_TProfitSum := 0;
        f_BProfitSum := 0;
        f_SProfitSum := 0;


        f_SumPMItem := CFNDailyPMValueItem.Create;
        f_SumPMItem.m_Date := 1;

        f_SumPMItem.m_TProfit := 0;
        f_SumPMItem.m_TNumberOfTrades := 0;

        f_SumPMItem.m_BProfit := 0;
        f_SumPMItem.m_BNumberOfTrades := 0;

        f_SumPMItem.m_SProfit := 0;
        f_SumPMItem.m_SNumberOfTrades := 0;

        f_SumPMItem.m_Price := 0;

        for f_Index := 0 to m_DailyPMValueCollection.m_Items.Count - 1 do
        begin
            f_PMItem := m_DailyPMValueCollection.m_Items[f_Index];

            f_SumPMItem.m_TProfit := f_SumPMItem.m_TProfit + f_PMItem.m_TProfit;
            f_SumPMItem.m_BProfit := f_SumPMItem.m_BProfit + f_PMItem.m_BProfit;
            f_SumPMItem.m_SProfit := f_SumPMItem.m_SProfit + f_PMItem.m_SProfit;

            f_SumPMItem.m_TProfitSum := 0;
            f_SumPMItem.m_BProfitSum := 0;
            f_SumPMItem.m_SProfitSum := 0;

            f_SumPMItem.m_TNumberOfTrades := f_SumPMItem.m_TNumberOfTrades + f_PMItem.m_TNumberOfTrades;
            f_SumPMItem.m_BNumberOfTrades := f_SumPMItem.m_BNumberOfTrades + f_PMItem.m_BNumberOfTrades;
            f_SumPMItem.m_SNumberOfTrades := f_SumPMItem.m_SNumberOfTrades + f_PMItem.m_SNumberOfTrades;

            f_TProfitSum := f_TProfitSum + f_PMItem.m_TProfit;
            f_BProfitSum := f_BProfitSum + f_PMItem.m_BProfit;
            f_SProfitSum := f_SProfitSum + f_PMItem.m_SProfit;

            f_PMItem.m_TProfitSum := f_TProfitSum;
            f_PMItem.m_BProfitSum := f_BProfitSum;
            f_PMItem.m_SProfitSum := f_SProfitSum;
        end;

        f_AvgPMItem := CFNDailyPMValueItem.Create;
        f_AvgPMItem.m_Date := 2;

        if m_DailyPMValueCollection.m_Items.Count > 0 then
        begin
            f_AvgPMItem.m_TProfit := f_SumPMItem.m_TProfit / m_DailyPMValueCollection.m_Items.Count;
            f_AvgPMItem.m_BProfit := f_SumPMItem.m_BProfit / m_DailyPMValueCollection.m_Items.Count;
            f_AvgPMItem.m_SProfit := f_SumPMItem.m_SProfit / m_DailyPMValueCollection.m_Items.Count;

            f_AvgPMItem.m_TProfitSum := 0;
            f_AvgPMItem.m_BProfitSum := 0;
            f_AvgPMItem.m_SProfitSum := 0;

            f_AvgPMItem.m_TNumberOfTrades := f_SumPMItem.m_TNumberOfTrades / m_DailyPMValueCollection.m_Items.Count;
            f_AvgPMItem.m_BNumberOfTrades := f_SumPMItem.m_BNumberOfTrades / m_DailyPMValueCollection.m_Items.Count;
            f_AvgPMItem.m_SNumberOfTrades := f_SumPMItem.m_SNumberOfTrades / m_DailyPMValueCollection.m_Items.Count;

            f_AvgPMItem.m_Price := 0;
        end else
        begin
            f_AvgPMItem.m_TProfit := 0;
            f_AvgPMItem.m_BProfit := 0;
            f_AvgPMItem.m_SProfit := 0;

            f_AvgPMItem.m_TProfitSum := 0;
            f_AvgPMItem.m_BProfitSum := 0;
            f_AvgPMItem.m_SProfitSum := 0;

            f_AvgPMItem.m_TNumberOfTrades := 0;
            f_AvgPMItem.m_BNumberOfTrades := 0;
            f_AvgPMItem.m_SNumberOfTrades := 0;

            f_AvgPMItem.m_Price := 0;
        end;

        m_DailyPMValueCollection.Add(f_SumPMItem);
        m_DailyPMValueCollection.Add(f_AvgPMItem);

        if FileExists(m_DailyPerfomanceFileName) then
        begin
            f_Mode := fmOpenReadWrite or fmShareDenyWrite;
        end else
        begin
            f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
        end;

        f_FileStream  := TFileStream.Create(m_DailyPerfomanceFileName, f_Mode);
        if Assigned(f_FileStream) then
        begin
            f_DesEncoding   := TEncoding.UTF8;
            f_ByteOrderMark := f_DesEncoding.GetPreamble;
            if (f_FileStream.Size <= 0) then
            begin
                f_FileStream.Size := 0;
                f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
            end;

            f_Line :=
                DateToStr(f_DailyPMValueItem.m_Date) + ',' +
                Format('%.5f', [f_DailyPMValueItem.m_TProfit]) + ',' +
                Format('%.5f', [f_DailyPMValueItem.m_TProfitSum]) + ',' +
                Format('%.5f', [f_DailyPMValueItem.m_BProfit]) + ',' +
                Format('%.5f', [f_DailyPMValueItem.m_BProfitSum]) + ',' +
                Format('%.5f', [f_DailyPMValueItem.m_SProfit]) + ',' +
                Format('%.5f', [f_DailyPMValueItem.m_SProfitSum]) + ',' +
                Format('%.2f', [f_DailyPMValueItem.m_TNumberOfTrades]) + ',' +
                Format('%.2f', [f_DailyPMValueItem.m_BNumberOfTrades]) + ',' +
                Format('%.2f', [f_DailyPMValueItem.m_SNumberOfTrades]) + ',' +
                Format('%.2f', [f_DailyPMValueItem.m_Price]) + #$D#$A;

            f_Buffer := f_DesEncoding.GetBytes(f_Line);
            f_FileStream.Seek(0, FILE_END);
            f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

            f_FileStream.Free;
            f_FileStream := NIL;
        end;

    finally
        if Assigned(f_TrafficManager) then f_TrafficManager.Free;
    end;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.SaveTradeList;
var
    f_TrafficManager:CFNTrafficManager;
    f_TrafficCollection : CFNTrafficCollection;
    f_Mode:Word;
    f_FileStream:TFileStream;
    f_TimeString:String;
    f_DesEncoding:TEncoding;
    f_ByteOrderMark:TBytes;
    f_Buffer:TBytes;
    f_ItemIndex:integer;
    f_TrafficItem : CFNTrafficItem;
    f_Line:String;
begin
    try
        f_TrafficManager := CFNTrafficManager.Create;
        f_TrafficManager.MakeTradeListOfBacktesting(m_Block.Option, m_Block.SystemManager.m_SignalArray, m_Block.SystemManager.m_RealPrice);

        f_TrafficCollection := f_TrafficManager.m_AllTrafficCollection;

        if FileExists(m_TradeListFileName) then
        begin
            f_Mode := fmOpenReadWrite or fmShareDenyWrite;
        end else
        begin
            f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
        end;

        f_FileStream  := TFileStream.Create(m_TradeListFileName, f_Mode);
        if Assigned(f_FileStream) then
        begin
            f_DesEncoding   := TEncoding.UTF8;
            f_ByteOrderMark := f_DesEncoding.GetPreamble;
            if (f_FileStream.Size <= 0) then
            begin
                f_FileStream.Size := 0;
                f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
            end;

            for f_ItemIndex := 0 to f_TrafficCollection.m_Items.Count-1 do
            begin
                f_TrafficItem := f_TrafficCollection.m_Items[f_ItemIndex];
                if not f_TrafficItem.m_Enable then continue;
                f_Line :=
                    Format('%d', [f_ItemIndex]) + ',' +
                    GetSignalText(f_TrafficItem.m_Signal) + ',' +
                    TFNGlobal.DateTimeToStr4(f_TrafficItem.m_EnterDateTime) + ',' +
                    TFNGlobal.DateTimeToStr4(f_TrafficItem.m_ExitDateTime) + ',' +
                    Format('%.5f', [f_TrafficItem.m_EnterPrice]) + ',' +
                    Format('%.5f', [f_TrafficItem.m_ExitPrice]) + ',' +
                    Format('%.5f', [f_TrafficItem.m_Profit]) + #$D#$A;

                f_Buffer := f_DesEncoding.GetBytes(f_Line);
                f_FileStream.Seek(0, FILE_END);
                f_FileStream.Write(f_Buffer[0], Length(f_Buffer));
            end;

            f_FileStream.Free;
            f_FileStream := NIL;
        end;

    finally
        if Assigned(f_TrafficManager) then f_TrafficManager.Free;
    end;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.MakeDailyPerfomanceFile;
var
    f_FileName:String;
    f_FilePath:String;
    f_Mode:Word;
    f_FileStream:TFileStream;
    f_DesEncoding:TEncoding;
    f_ByteOrderMark:TBytes;
    f_Line:String;
    f_Buffer:TBytes;
begin
    f_FilePath := ExtractFilePath(ParamStr(0)) + 'BackTesting\';
    if not DirectoryExists(f_FilePath) then
    begin
        CreateDir(f_FilePath);
    end;

    m_DailyPerfomanceFileName := f_FilePath + m_Block.BlockName + '_' + TFNGlobal.DateTimeToString(m_StartDateTime, 'YYYYMMDDHHMMSS') + '_DailyPerfomance.csv';

    if Not FileExists(m_DailyPerfomanceFileName) then
    begin
        f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
        f_FileStream  := TFileStream.Create(m_DailyPerfomanceFileName, f_Mode);
        if Assigned(f_FileStream) then
        begin
            //UTF-8 변경
            if (f_FileStream.Size <= 0) then
            begin
                f_DesEncoding   := TEncoding.UTF8;
                f_ByteOrderMark := f_DesEncoding.GetPreamble;

                f_FileStream.Size := 0;
                f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
            end;
        end;

        f_Line := '날짜,전체거래의 이익,전체거래의 이익 누적,매수거래의 이익,매수거래의 이익 누적,매도거래의 이익,매도거래의 이익누적,전체거래의 거래횟수,매수거래의 거래횟수,매도거래의 거래횟수,가격'+ #$D#$A;

        f_Buffer := f_DesEncoding.GetBytes(f_Line);
        f_FileStream.Seek(0, FILE_END);
        f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

        f_FileStream.Free;
        f_FileStream := NIL;
    end;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.MakeTradeListFile;
var
    f_FileName:String;
    f_FilePath:String;
    f_Mode:Word;
    f_FileStream:TFileStream;
    f_DesEncoding:TEncoding;
    f_ByteOrderMark:TBytes;
    f_Line:String;
    f_Buffer:TBytes;
begin
    f_FilePath := ExtractFilePath(ParamStr(0)) + 'BackTesting\';
    if not DirectoryExists(f_FilePath) then
    begin
        CreateDir(f_FilePath);
    end;

    m_TradeListFileName := f_FilePath + m_Block.BlockName + '_' + TFNGlobal.DateTimeToString(m_StartDateTime, 'YYYYMMDDHHMMSS') + '_TradeList.csv';

    if Not FileExists(m_TradeListFileName) then
    begin
        f_Mode := fmOpenReadWrite or fmShareDenyWrite or fmCreate;
        f_FileStream  := TFileStream.Create(m_TradeListFileName, f_Mode);
        if Assigned(f_FileStream) then
        begin
            if (f_FileStream.Size <= 0) then
            begin
                f_DesEncoding   := TEncoding.UTF8;
                f_ByteOrderMark := f_DesEncoding.GetPreamble;

                f_FileStream.Size := 0;
                f_FileStream.Write(f_ByteOrderMark[0], Length(f_ByteOrderMark));
            end;
        end;

        f_Line := '순번,신호종류,진입시간,청산시간,진입가격,청산가격,수익'+ #$D#$A;

        f_Buffer := f_DesEncoding.GetBytes(f_Line);
        f_FileStream.Seek(0, FILE_END);
        f_FileStream.Write(f_Buffer[0], Length(f_Buffer));

        f_FileStream.Free;
        f_FileStream := NIL;
    end;

end;

{$ENDREGION}

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.OnDoneWork1Day(Sender: TObject);
var
    f_ChartDataSeries:CMKChartDataSeries ;
    f_Index:integer;
    f_ChartData:CMKChartData;
    f_CountOfSameDate:Integer;
    f_DataCount:Integer;
    f_TimeFrame:Integer;
begin
    if not Assigned(m_Block) then exit;

    m_Block.SystemManager.Stop;
    OnLog(Self, Now, LOG_TYPE_INFO, '계산을 완료하였습니다.' + DateToStr(m_StandDate), '');

    try
        f_CountOfSameDate := 0;
        f_ChartDataSeries := m_Block.SystemManager.m_ChartDataSeries;
        for f_Index := f_ChartDataSeries.m_Items.Count - 1 downto 0 do
        begin
            f_ChartData := f_ChartDataSeries.m_Items[f_Index];

            if SameDate(f_ChartData.m_OpenDateTime, m_StandDate) then
            begin
                Inc(f_CountOfSameDate);
            end else
            begin
                break;
            end;
        end;
    finally
    end;

    f_TimeFrame := m_Block.Option.GetIntegerValue('TIMEFRAME');
    if 9000 <= f_TimeFrame then
    begin
        f_DataCount := 9000 div 3;
    end else
    if 1 >= f_TimeFrame then
    begin
        f_DataCount := 1600 div 3;
    end else
    if 2 >= f_TimeFrame then
    begin
        f_DataCount :=  800 div 3;
    end else
    if 5 >= f_TimeFrame then
    begin
        f_DataCount :=  600 div 3;
    end else
    begin
        f_DataCount := 10;
    end;

    try
        if f_CountOfSameDate > f_DataCount then
        begin
            SaveTradeList;
            SaveDailyPerfomance;
            DisplayDailyPMListView;
        end else
        begin
            OnLog(Self, Now, LOG_TYPE_INFO, '휴일이라 판단되어 출력을 하지 않았습니다.' + DateToStr(m_StandDate), '');
        end;
    finally
    end;

    m_StandDate := m_StandDate + 1;
    if (DayOfWeek(m_StandDate) = 7) then m_StandDate := m_StandDate + 1;
    if (DayOfWeek(m_StandDate) = 1) then m_StandDate := m_StandDate + 1;

    if m_StandDate <= m_EndDate then
    begin
        PostMessage(Handle, WM_BACKTESING_START, 0, 0);
    end else
    begin
        MatrixOptionFrame1.SetEnable(true);
        m_Doing := false;
        OnLog(Self, Now, LOG_TYPE_INFO, '모든 계산을 완료하였습니다.', '');
        m_Block.SystemManager.StopDelay;
    end;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.DoStart;
var
    f_POTData:CFNPOTItem;
begin
    if not Assigned(m_Block) then exit;
    if m_Block.SystemManager.State then exit;

    ClearDailyPMListView;
    m_DailyPMValueCollection.Clear;

    m_StartDateTime := Now;
    MatrixOptionFrame1.GetOption;

    Caption := m_Block.BlockName;

    m_StartDate := Trunc(DateTimePickerStartDate.DateTime);
    m_EndDate := Trunc(DateTimePickerEndDate.DateTime);
    m_StandDate := m_StartDate;
    SaveConfigData;
    MakeTradeListFile;
    MakeDailyPerfomanceFile;

    PostMessage(Handle, WM_BACKTESING_START, 0, 0);
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.DoStop;
begin
    m_StandDate := m_EndDate + 1;
    m_Block.SystemManager.StopDelay;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.WMBTStart(var Message: TMessage);
begin
    DoStart1Day;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.DoStart1Day;
begin
    OnLog(Self, Now, LOG_TYPE_INFO, '계산을 시작합니다.' + DateToStr(m_StandDate), '');

    m_Block.Option.SetIntegerValue('SYSTEM_MODE'            , SYSTEM_MODE_SIMULATION);
    m_Block.Option.SetBooleanValue('USE_STAND_DATE'         , true);
    m_Block.Option.SetBooleanValue('USE_HISTORY_CHARTDATA'  , true);
    m_Block.Option.SetIntegerValue('STAND_DATE'             , Trunc(m_StandDate));

    m_Block.SystemManager.Option            := m_Block.Option;
    m_Block.SystemManager.BlockName         := m_Block.BlockName;
    m_Block.SystemManager.BlockKey          := m_Block.BlockKey;
    m_Block.SystemManager.BackTestingMode   := true;
    m_Block.SystemManager.AloneMode         := true;
    m_Block.SystemManager.OrderManager      := NIL;

    m_Block.SystemManager.OnDoneWork        := OnDoneWork1Day;
    m_Block.SystemManager.OnLog             := OnLog;

    m_Block.SystemManager.ApplyTSOCollection(m_Block.SystemManager.Option.StrategyOptionCollection);
    m_Block.SystemManager.Start;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.DoStop1Day;
begin
    if not Assigned(m_Block) then exit;
    if not m_Block.SystemManager.State then exit;

    m_Block.SystemManager.StopDelay;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.Button1Click(Sender: TObject);
begin
    if m_DailyPerfomanceFileName <> '' then
    begin
        ShellExecute(Handle,'open', PWideChar(m_DailyPerfomanceFileName), '', '', SW_SHOWNORMAL);
    end;
end;

//------------------------------------------------------------------------------------
procedure TMDIBackTesting.Button2Click(Sender: TObject);
begin
    if m_TradeListFileName <> '' then
    begin
        ShellExecute(Handle,'open', PWideChar(m_TradeListFileName), '', '', SW_SHOWNORMAL);
    end;
end;


end.


