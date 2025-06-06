unit SDIMain;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Messages,Controls, Menus, Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList, StdActns,
  ActnList, ToolWin,
  MKDefine,
  FNCMVariable,
  FNPOTCollection,
  FNMaterialCollection,
  FNSymbolCollection,
  FNChildFrameCustom,
  MXChildFrame0100,
  MKColorPanel,
  GR32_Image,
  MKAVChartControl,
  XPMan,
  FNSocketManager,
  FNDataDelivery,
  MXTSVariable, FNReceiveSensor, FNDefine;

type
  TSDIMainForm = class(TForm)
    ActionList1: TActionList;
    ImageListMain: TImageList;
    ImageListNavigator: TImageList;
    SplitterNavigator: TSplitter;
    Action_HideNavigator: TAction;
    Action_ShowNavigator: TAction;
    Action_Screen0100: TAction;
    Action_Screen0200: TAction;
    Action_Screen0300: TAction;
    Action_Screen0400: TAction;
    Action_Screen0500: TAction;
    Action_SearchSymbol: TAction;
    Action_Screen0510: TAction;
    Panel4: TPanel;
    PageControl_Screen: TPageControl;
    TabSheet1: TTabSheet;
    PanelNavigator: TPanel;
    PanelNavigatorBody: TPanel;
    Panel5: TPanel;
    Panel_Cutton: TPanel;
    Action_Favorite: TAction;
    PanelSmallView: TPanel;
    Image2: TImage;
    SpeedButton1: TSpeedButton;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    SpeedButton2: TSpeedButton;
    Panel2: TPanel;
    SymbolListView: TListView;
    Panel1: TPanel;
    SpeedButton3: TSpeedButton;
    StatusBar: TStatusBar;
    TimerDisplay: TTimer;
    TimerReConnect: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure SymbolListViewData(Sender: TObject; Item: TListItem);

    procedure SymbolListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure SymbolListViewCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure SplitterNavigatorMoved(Sender: TObject);
    procedure PanelNavigatorResize(Sender: TObject);
    procedure Action_HideNavigatorExecute(Sender: TObject);
    procedure Action_ShowNavigatorExecute(Sender: TObject);
    procedure SymbolListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Action_Screen0100Execute(Sender: TObject);
    procedure PageControl_ScreenChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure StatusBarResize(Sender: TObject);
    procedure TimerDisplayTimer(Sender: TObject);
    procedure CFNReceiveSensor1MTDisconnect(Sender: TObject);
    procedure TimerReConnectTimer(Sender: TObject);

  private
    m_SocketManager         :   CFNSocketManager        ;
    m_SymbolCollection      :   CFNSymbolCollection     ;
    m_MaterialCollection    :   CFNMaterialCollection   ;
    m_POTCollection         :   CFNPOTCollection        ;

    ChildFrame01001: TChildFrame0100;

    m_FirstActivate:Boolean;
    m_EventEnable:Boolean;

    m_DataDelivery  : CFNDataDelivery;

    m_SelectedSymbolItem : CFNSymbolItem;

    m_ChildFrame : Array [0..9] of TChildFrameCustom;
    m_ChildFrameCount:Integer;

    m_NavigatorWidth : Integer;
    m_NavigatorVisible : Boolean;

    procedure InitializeSymbolListView;
    procedure SendMessageOfChangeSymbolItem;
    procedure WMMainProcess(var Message: TMessage); message WM_MAIN_PROCESS;
    procedure UpdateChildFrame;

    procedure SaveMainInformation;
    procedure ReadMainInformation;

    procedure RemoveCutton;

    procedure OnOPSDisconnect(Sender: TObject);
    procedure OnSocketEvent(p_Event:Integer);

  public

  end;

var
    SDIMainForm: TSDIMainForm;

implementation

uses
    WinProcs, FNGlobal, FNRegistry, MXVariable, MXTradeStrategyOptionCollection,
  FNMatrixReConnectDlg;


{$R *.dfm}
procedure TSDIMainForm.OnSocketEvent(p_Event:Integer);
begin
    TimerReConnect.Enabled := true;
end;

//------------------------------------------------------------------------------------

procedure TSDIMainForm.TimerReConnectTimer(Sender: TObject);
begin
    OnOPSDisconnect(Self);
    TimerReConnect.Enabled := false;
end;
//------------------------------------------------------------------------------------
procedure TSDIMainForm.OnOPSDisconnect(Sender: TObject);
begin
    //{$IFNDEF DEBUG}
    if g_SocketManager.GetConnected then exit;
    g_SocketManager.EnableEvent := false;
    try
        if not Assigned(MatrixReConnectDlg) then
        begin
            //LOG_WRITE(LOG_TYPE_INFO, 'TMainForm', '시그널데이터 통신연결이 원활하지 않아 재연결을 시도합니다.');
            g_SocketManager.OnSocketEvent := NIL;
            g_SocketManager.Disconnect;
            MatrixReConnectDlg := TMatrixReConnectDlg.Create(Application);
            MatrixReConnectDlg.ShowModal();
            MatrixReConnectDlg.Free;
            MatrixReConnectDlg := NIL;
            g_SocketManager.OnSocketEvent := OnSocketEvent;
            //LOG_WRITE(LOG_TYPE_INFO, 'TMainForm', '시그널데이터 통신이 재연결 되었습니다.');
        end;
    finally
        g_SocketManager.EnableEvent := true;
    end;
    //{$ENDIF}
end;

{$REGION '생성과 소멸'}

//------------------------------------------------------------------------------
procedure TSDIMainForm.FormCreate(Sender: TObject);
var
    f_Registry:CFNRegistry;
begin
    Caption := g_ApplicationName;

    f_Registry := CFNRegistry.Create(self);
    f_Registry.Company := g_CompanyName;
    f_Registry.ApplicationName := g_ApplicationName;

    g_FirstUseing := f_Registry.ReadBool   ('Setting', 'FirstUseing'  , true);
    f_Registry.WriteBool('Setting', 'FirstUseing' , false);

    f_Registry.Free;

    m_SocketManager        :=   g_SocketManager        ;
    m_SymbolCollection     :=   g_SymbolCollection     ;
    m_MaterialCollection   :=   g_MaterialCollection   ;
    m_POTCollection        :=   g_POTCollection        ;

    ChildFrame01001:= TChildFrame0100.Create(Owner);
    ChildFrame01001.Parent := TabSheet1;
    ChildFrame01001.SetBounds(0, 0, TabSheet1.Width, TabSheet1.Height);
    ChildFrame01001.Align := alClient;

    m_DataDelivery  := CFNDataDelivery.Create();

    m_SelectedSymbolItem := NIL;

    m_FirstActivate := TRUE;
    m_EventEnable := TRUE;

    m_ChildFrameCount := 0;

    m_ChildFrame[m_ChildFrameCount] :=  ChildFrame01001;
    Inc(m_ChildFrameCount);

    ChildFrame01001.SocketManager := m_SocketManager;
    ChildFrame01001.OnFormCreate;
    ChildFrame01001.Active := false;

    UpdateChildFrame;
    Panel_Cutton.Align := alClient;

    //MakeDefaultTSOption;

    InitializeSymbolListView;

    StatusBar.Panels[1].Text := g_Version + ' ' + g_BuilderDate;
    StatusBar.Panels[2].Text := g_MatrixUserID;



    if Assigned(g_SocketManager)  then
    begin
        g_SocketManager.OnSocketEvent := OnSocketEvent;
    end;
end;

//------------------------------------------------------------------------------
procedure TSDIMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    g_StrategyOptionCollection.SaveToFile(g_StrategyOptionFileName);

    SaveMainInformation;

    ChildFrame01001.OnFormCloe;

    Sleep(1000);

    m_DataDelivery.Free;
end;

{$ENDREGION}

{$REGION '폼 이벤트'}
//------------------------------------------------------------------------------
procedure TSDIMainForm.FormActivate(Sender: TObject);
var
    f_TryIndex:Integer;
begin
    //  처음으로 활성화 되었을 때 에만 RequestBasicData를 호출한다.
    if (m_FirstActivate) then
    begin
        m_FirstActivate := false;

        ReadMainInformation;
        UpdateChildFrame;

        ChildFrame01001.OnFormActivate;

        PageControl_Screen.Visible := TRUE;
        PageControl_Screen.Realign;

        RemoveCutton;

    end;
end;
//------------------------------------------------------------------------------
procedure TSDIMainForm.FormResize(Sender: TObject);
begin
    SaveMainInformation;
end;

//------------------------------------------------------------------------------
procedure TSDIMainForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    if (Dialogs.MessageDlg('종료하시겠습니까?', mtInformation, mbYesNo, 0) = mrYES) then
    begin
        CanClose := true;
    end else
    begin
        CanClose := false;
    end;
end;
{$ENDREGION}

{$REGION '심벌리스트뷰의 이벤트'}
//------------------------------------------------------------------------------
procedure TSDIMainForm.SymbolListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
    Paper : TCanvas;
    pListView : TListView;
begin

    pListView := TListView(Sender);

    Paper := pListView.Canvas;

    if (Item.Index mod 2 = 0) then
    begin
        Paper.Brush.Color := clBlack;
        Paper.Brush.Color := TColor(RGB($FF, $FF, $FF));
    end else
    begin
        Paper.Brush.Color := clBlack;
        Paper.Brush.Color := TColor(RGB($F8, $F8, $F8));
    end;

    DefaultDraw := TRUE;
end;

//------------------------------------------------------------------------------
procedure TSDIMainForm.SymbolListViewCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
var
    Paper : TCanvas;
    pListView : TListView;
begin
    pListView := TListView(Sender);

    Paper := pListView.Canvas;

    if (Item.Index mod 2 = 0) then
    begin
        Paper.Brush.Color := clBlack;
        Paper.Brush.Color := TColor(RGB($FF, $FF, $FF));
    end else
    begin
        Paper.Brush.Color := clBlack;
        Paper.Brush.Color := TColor(RGB($F8, $F8, $F8));
    end;

    DefaultDraw := TRUE;
end;

//------------------------------------------------------------------------------
procedure TSDIMainForm.SymbolListViewData(Sender: TObject; Item: TListItem);
var
    f_SymbolItem : CFNSymbolItem;
    nItemIndex : Integer;
begin
    if not Assigned (Item) then exit;
    if not Assigned (m_SymbolCollection) then exit;
    if not Assigned (m_SymbolCollection.m_Items) then exit;

    if ((Item.Index < 0) or (Item.Index >= m_SymbolCollection.m_Items.Count)) then exit;

    try
        nItemIndex := Item.Index;

        f_SymbolItem := m_SymbolCollection.m_Items[nItemIndex];

        if f_SymbolItem = NIL then exit;

        Item.ImageIndex := f_SymbolItem.m_Market + 2;

        Item.Caption := f_SymbolItem.m_Symbol;
        Item.SubItems.Add(f_SymbolItem.m_Name);

        Item.Data := f_SymbolItem;
    except
    end;
end;

//------------------------------------------------------------------------------
procedure TSDIMainForm.SymbolListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
    if Selected then
    begin
        m_SelectedSymbolItem := CFNSymbolItem(Item.Data);
        SendMessageOfChangeSymbolItem;
    end;
end;

//------------------------------------------------------------------------------
procedure TSDIMainForm.TimerDisplayTimer(Sender: TObject);
begin
    StatusBar.Panels[3].Text := TFNGlobal.DateTimeToStr6(TFNGlobal.ServerNow);
end;


{$ENDREGION}

{$REGION '심벌리스트뷰의 초기화'}
//------------------------------------------------------------------------------
procedure TSDIMainForm.InitializeSymbolListView;
var
    nCount : Integer;
begin
    if Assigned(m_SymbolCollection) then
    begin
        nCount := m_SymbolCollection.m_Items.Count;
        //if nCount > 1 then nCount := 1;
        SymbolListView.Items.Count := 0;
        SymbolListView.Items.Count := nCount;
        SymbolListView.Repaint;
    end else
    begin
        SymbolListView.Items.Count := 0;
        SymbolListView.Repaint;
    end;
end;
{$ENDREGION}

{$REGION '화면의 레이아웃을 관리한다.'}
//------------------------------------------------------------------------------
procedure TSDIMainForm.PanelNavigatorResize(Sender: TObject);
begin
    PanelSmallView.Left := 0;
    PanelSmallView.Top := 0;
    PanelSmallView.Width := PanelNavigator.Width;
    PanelSmallView.Height := PanelNavigator.Height;
    //m_NavigatorWidth := PanelNavigator.Width;
end;

//------------------------------------------------------------------------------
procedure TSDIMainForm.SplitterNavigatorMoved(Sender: TObject);
begin
    if PanelNavigator.Width < 120 then
    begin
        Action_HideNavigatorExecute(Sender);
        m_NavigatorWidth := 200;
    end;
end;

procedure TSDIMainForm.StatusBarResize(Sender: TObject);
begin
    StatusBar.Panels[0].Width := StatusBar.Width - 420;
end;

//------------------------------------------------------------------------------
procedure TSDIMainForm.Action_Screen0100Execute(Sender: TObject);
begin
    PageControl_Screen.ActivePageIndex := 0;
    UpdateChildFrame;
end;

//------------------------------------------------------------------------------
procedure TSDIMainForm.Action_ShowNavigatorExecute(Sender: TObject);
begin
    PanelSmallView.Visible := false;
    SplitterNavigator.Visible := true;
    PanelNavigator.Width := m_NavigatorWidth;
    SplitterNavigator.Left := PanelNavigator.Left + PanelNavigator.Width + 1;
    m_NavigatorVisible := true;
    Self.Realign;
    Panel4.Realign;
end;


procedure TSDIMainForm.CFNReceiveSensor1MTDisconnect(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------
procedure TSDIMainForm.Action_HideNavigatorExecute(Sender: TObject);
begin
    m_NavigatorWidth := PanelNavigator.Width;
    PanelNavigator.Width := 11;

    SplitterNavigator.Visible := false;
    PanelSmallView.Visible := true;
    PanelSmallView.Left := 0;
    PanelSmallView.Top := 0;
    PanelSmallView.Width := PanelNavigator.Width;
    PanelSmallView.Height := PanelNavigator.Height;
    m_NavigatorVisible := false;
    Self.Realign;
    Panel4.Realign;
end;
procedure TSDIMainForm.RemoveCutton;
begin
    Panel_Cutton.Visible := false;
end;
{$ENDREGION}

{$REGION '화면의 크기와 좌표를 저장하고 읽어오는 부분'}
//------------------------------------------------------------------------------
procedure TSDIMainForm.SaveMainInformation;
var
    f_Registry:CFNRegistry;
    f_WindowState:Integer;
begin
    f_Registry := CFNRegistry.Create(self);
    f_Registry.Company := g_CompanyName;
    f_Registry.ApplicationName := g_ApplicationName;

    if (WindowState = wsNormal) then f_WindowState := 0
    else if (WindowState = wsMinimized) then f_WindowState := 1
    else f_WindowState := 2;

    f_Registry.WriteInteger('MainWindow', 'WindowState'    , f_WindowState);
    if (WindowState = wsNormal) then
    begin
        f_Registry.WriteInteger('MainWindow', 'WindowLeft'     , Left  );
        f_Registry.WriteInteger('MainWindow', 'WindowTop'      , Top   );
        f_Registry.WriteInteger('MainWindow', 'WindowWidth'    , Width );
        f_Registry.WriteInteger('MainWindow', 'WindowHeight'   , Height);
    end;

    if m_NavigatorVisible then
    begin
        f_Registry.WriteInteger('MainWindow', 'NavigatorWidth' , PanelNavigator.Width);
    end else
    begin
        f_Registry.WriteInteger('MainWindow', 'NavigatorWidth' , m_NavigatorWidth);
    end;

    f_Registry.WriteBool('MainWindow', 'NavigatorVisible' , m_NavigatorVisible);

    f_Registry.Free;
end;
//------------------------------------------------------------------------------
procedure TSDIMainForm.ReadMainInformation;
var
    f_Registry:CFNRegistry;
    f_WindowState:Integer;
    f_Left, f_Top, f_Width, f_Height:Integer;
    f_NavigatorWidth:Integer;
begin
    f_Registry := CFNRegistry.Create(self);
    f_Registry.Company := g_CompanyName;
    f_Registry.ApplicationName := g_ApplicationName;

    f_WindowState       := f_Registry.ReadInteger('MainWindow', 'WindowState'       ,  0);
    f_Left              := f_Registry.ReadInteger('MainWindow', 'WindowLeft'        , -1);
    f_Top               := f_Registry.ReadInteger('MainWindow', 'WindowTop'         , -1);
    f_Width             := f_Registry.ReadInteger('MainWindow', 'WindowWidth'       , -1);
    f_Height            := f_Registry.ReadInteger('MainWindow', 'WindowHeight'      , -1);
    m_NavigatorWidth    := f_Registry.ReadInteger('MainWindow', 'NavigatorWidth'    , 120);
    m_NavigatorVisible  := f_Registry.ReadBool   ('MainWindow', 'NavigatorVisible'  , true);

    if m_NavigatorVisible  AND (m_NavigatorWidth < 10) then m_NavigatorWidth := 120;

    PanelNavigator.Width := m_NavigatorWidth;

    if ((f_Left <> -1) and (f_Top <> -1) and (f_Width <> -1) and (f_Height <> -1)) then
    begin
        if (f_Left >= Screen.Width-32) then f_Left := Screen.Width-32;
        if (f_Left < 0) then f_Left := 0;

        if (f_Top >= Screen.Height-32) then f_Top := Screen.Height-32;
        if (f_Top < 0) then f_Top := 0;

        Self.SetBounds(f_Left, f_Top, f_Width, f_Height);
    end;

    if not m_NavigatorVisible then
    begin
        Action_HideNavigatorExecute(Self);
    end;

    if (f_WindowState = 0) then WindowState := wsNormal
    else if (f_WindowState = 1) then WindowState := wsMinimized
    else WindowState := wsMaximized;


    f_Registry.Free;
end;

{$ENDREGION}

{$REGION '오른쪽 화면의 탭의 상태변경을 관리'}
//------------------------------------------------------------------------------
procedure TSDIMainForm.UpdateChildFrame;
var
    I : Integer;
    f_ScreenIndex:Integer;
begin
    f_ScreenIndex := PageControl_Screen.TabIndex;

    for I := 0 to m_ChildFrameCount - 1 do
    begin
        if I = f_ScreenIndex then
        begin
            m_ChildFrame[I].Active := true;
        end else
        begin
            m_ChildFrame[I].Active := false;
        end;
    end;
end;
//------------------------------------------------------------------------------
procedure TSDIMainForm.PageControl_ScreenChange(Sender: TObject);
begin
    UpdateChildFrame;
end;
{$ENDREGION}

{$REGION '차일드 프레임과의 데이터 교환'}
//------------------------------------------------------------------------------
procedure TSDIMainForm.WMMainProcess(var Message: TMessage);
var
    f_SymbolItem : CFNSymbolItem;
    I : Integer;
begin

    //  심벌 변경 이벤트
    if (WPARAM_SELECT_SYMBOLITEM = Message.WParam) then
    begin
        //m_MDISelectMarketQuotData := CMKMarketQuotData(Message.LParam);
        //if Assigned(m_MDISelectMarketQuotData) then SendMessageOfChangeSymbolItem;

        f_SymbolItem := CFNSymbolItem(Message.LParam);
        if Assigned(f_SymbolItem) then
        begin
            if Assigned(m_SelectedSymbolItem)
                and (f_SymbolItem.m_Country = m_SelectedSymbolItem.m_Country)
                and (f_SymbolItem.m_Group   = m_SelectedSymbolItem.m_Group)
                and (f_SymbolItem.m_Market  = m_SelectedSymbolItem.m_Market)
                and (f_SymbolItem.m_Symbol  = m_SelectedSymbolItem.m_Symbol) then
            begin
                ;
            end
            else
            begin
                m_SelectedSymbolItem := f_SymbolItem;
                SendMessageOfChangeSymbolItem;
            end;
        end
        else
        begin
            //
        end;
    end else

    //  현재 선택된 마켓워치데이터를 요구한다.
    if (WPARAM_GET_SELECTED_SYMBOL = Message.WParam) then
    begin
        Message.Result := Integer(Pointer(m_SelectedSymbolItem));
    end;
end;

//------------------------------------------------------------------------------
procedure TSDIMainForm.SendMessageOfChangeSymbolItem;
var
    I : Integer;
    f_ScreenIndex:Integer;
begin
    f_ScreenIndex := PageControl_Screen.TabIndex;

    //차일드 폼에게 메세지 전달
    for I := 0 to m_ChildFrameCount - 1 do
    begin
        SendMessage(m_ChildFrame[I].Handle, WM_CHILD_PROCESS, WPARAM_SELECT_SYMBOLITEM, LParam(Pointer(m_SelectedSymbolItem)));
    end;
end;
{$ENDREGION}

end.
