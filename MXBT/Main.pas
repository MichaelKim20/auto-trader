unit MAIN;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList;

type
  TMainForm = class(TForm)
    StatusBar: TStatusBar;
    ActionList1: TActionList;
    Action_2000: TAction;
    Action_2010: TAction;
    Action_1600: TAction;
    WindowCascade: TWindowCascade;
    WindowTileHorizontal: TWindowTileHorizontal;
    WindowTileVertical: TWindowTileVertical;
    WindowMinimizeAll: TWindowMinimizeAll;
    WindowArrange: TWindowArrange;
    Action_3001: TAction;
    Action_3002: TAction;
    Action_Load: TAction;
    Action_Save: TAction;
    WindowAllClose: TAction;
    ImageListNormal: TImageList;
    MainMenu1: TMainMenu;
    MainMenu_1000: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    X1: TMenuItem;
    MainMenu_3000: TMenuItem;
    N23: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    MemuItem_Window: TMenuItem;
    ActionWndCascade1: TMenuItem;
    ActionWndTileHorizontal1: TMenuItem;
    ActionWndTileVertical1: TMenuItem;
    ActionWndArrange1: TMenuItem;
    N74: TMenuItem;
    ActionWndMinimizeAll1: TMenuItem;
    N50: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton4: TToolButton;
    ToolButton7: TToolButton;
    ToolButton5: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton2: TToolButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ToolButton11: TToolButton;

    procedure Action_2010Execute(Sender: TObject);
    procedure Action_3001Update(Sender: TObject);
    procedure Action_LoadExecute(Sender: TObject);
    procedure Action_3001Execute(Sender: TObject);
    procedure Action_3002Execute(Sender: TObject);
    procedure Action_3002Update(Sender: TObject);
    procedure Action_SaveExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure WindowAllCloseExecute(Sender: TObject);
    procedure WindowAllCloseUpdate(Sender: TObject);
    procedure Action_1600Execute(Sender: TObject);

  private
    m_OpenedFileName : String;

    function IsAllStop:Boolean;
    function IsAllStart:Boolean;
    function IsExistBTChild: Boolean;

    procedure LoadFromFile(AFileName:String);
    procedure SaveToFile(AFileName: String);

    // 메인 화면의 상태(최대,최소,일반), 크기, 위치를 저장하고 복원하는 부분
    procedure SaveMainWindow();
    procedure RestoreMainWindow();
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses XMLIntf, xmldom, msxmldom, XMLDoc, FNRegistry, FNCMVariable, BackTestingWin;

//------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
begin
    RestoreMainWindow();
    Caption := g_ApplicationName;
end;
//------------------------------------------------------------------------------------
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
    f_Child:TForm;
    f_ChildIndex:Integer;
begin
    SaveMainWindow();
    for f_ChildIndex := 0 to MDIChildCount - 1 do
    begin
        f_Child := MDIChildren[f_ChildIndex];
        f_Child.Close;
    end;
end;


//------------------------------------------------------------------------------------
function TMainForm.IsExistBTChild: Boolean;
var
    f_Child:TForm;
    f_ChildIndex:Integer;
begin
    Result := false;
    for f_ChildIndex := 0 to MDIChildCount - 1 do
    begin
        f_Child := MDIChildren[f_ChildIndex];
        if f_Child is TMDIBackTesting then
        begin
            Result := true;
            break;
        end;
    end;
end;

//------------------------------------------------------------------------------------
function TMainForm.IsAllStop: Boolean;
var
    f_BTChild : TMDIBackTesting;
    f_Child:TForm;
    f_ChildIndex:Integer;
begin
    Result := true;
    for f_ChildIndex := 0 to MDIChildCount - 1 do
    begin
        f_Child := MDIChildren[f_ChildIndex];
        if f_Child is TMDIBackTesting then
        begin
            f_BTChild := f_Child as TMDIBackTesting;
            if (f_BTChild.Block.SystemManager.State) then
            begin
                Result := false;
                break;
            end;
        end;
    end;
end;

//------------------------------------------------------------------------------------
function TMainForm.IsAllStart: Boolean;
var
    f_BTChild : TMDIBackTesting;
    f_Child:TForm;
    f_ChildIndex:Integer;
begin
    Result := true;
    for f_ChildIndex := 0 to MDIChildCount - 1 do
    begin
        f_Child := MDIChildren[f_ChildIndex];
        if f_Child is TMDIBackTesting then
        begin
            f_BTChild := f_Child as TMDIBackTesting;
            if (not f_BTChild.Block.SystemManager.State) then
            begin
                Result := false;
                break;
            end;
        end;
    end;
end;


//------------------------------------------------------------------------------------
procedure TMainForm.Action_1600Execute(Sender: TObject);
begin
    Close;
end;

//------------------------------------------------------------------------------------
procedure TMainForm.Action_2010Execute(Sender: TObject);
begin
    TMDIBackTesting.Create(Application);
end;

//------------------------------------------------------------------------------------
procedure TMainForm.Action_3001Execute(Sender: TObject);
var
    f_BTChild: TMDIBackTesting;
    f_Child:TForm;
    f_ChildIndex:Integer;
begin
    for f_ChildIndex := 0 to MDIChildCount - 1 do
    begin
        f_Child := MDIChildren[f_ChildIndex];
        if f_Child is TMDIBackTesting then
        begin
            f_BTChild := f_Child as TMDIBackTesting;
            f_BTChild.Action_0001Execute(Self);
        end;
    end;
end;
//------------------------------------------------------------------------------------
procedure TMainForm.Action_3001Update(Sender: TObject);
begin

    if IsExistBTChild then
    begin
        if IsAllStart then
        begin
            Action_3001.Enabled := false;
        end else
        begin
            Action_3001.Enabled := true;
        end;
    end else
    begin
        Action_3001.Enabled := false;
    end;
end;

//------------------------------------------------------------------------------------
procedure TMainForm.Action_3002Execute(Sender: TObject);
var
    f_BTChild: TMDIBackTesting;
    f_Child:TForm;
    f_ChildIndex:Integer;
begin
    for f_ChildIndex := 0 to MDIChildCount - 1 do
    begin
        f_Child := MDIChildren[f_ChildIndex];
        if f_Child is TMDIBackTesting then
        begin
            f_BTChild := f_Child as TMDIBackTesting;
            f_BTChild.Action_0002Execute(Self);
        end;
    end;
end;

//------------------------------------------------------------------------------------
procedure TMainForm.Action_3002Update(Sender: TObject);
begin
    if IsExistBTChild then
    begin
        if IsAllStop then
        begin
            Action_3002.Enabled := false;
        end else
        begin
            Action_3002.Enabled := true;
        end;
    end else
    begin
        Action_3002.Enabled := false;
    end;
end;


//------------------------------------------------------------------------------------
procedure TMainForm.Action_LoadExecute(Sender: TObject);
begin
    if IsAllStop then
    begin
        if not IsExistBTChild then
        begin
            if OpenDialog.FileName = '' then OpenDialog.FileName := '*.xml';
            if OpenDialog.Execute then
            begin
                if ExtractFileExt(OpenDialog.FileName) = '' then
                begin
                    OpenDialog.FileName := OpenDialog.FileName + '.xml';
                end;

                LoadFromFile(OpenDialog.FileName);
                m_OpenedFileName := ExtractFileName(OpenDialog.FileName);
                Caption := g_ApplicationName + ' [' + m_OpenedFileName + ']';
            end;
        end else
        begin
            Dialogs.MessageDlg('여러 창이 동시에 새롭게 열리기 때문에 지금 열려진 창은 닫고 실행하여야 새로운 창을 일제히 열었을 때 혼란을 피할 수 있습니다.', mtInformation, [mbOk], 0, mbOk);
        end;
    end else
    begin
        Dialogs.MessageDlg('지금 실행되고 있는 매매의 안전한 종료를 위해, 일단은 모든 매매시템을 종료 한 후, 모든 창을 닫고 실행하여 주세요.', mtInformation, [mbOk], 0, mbOk);
    end;
end;

//------------------------------------------------------------------------------------
procedure TMainForm.Action_SaveExecute(Sender: TObject);
begin
    if SaveDialog.Execute then
    begin
        if ExtractFileExt(SaveDialog.FileName) = '' then
        begin
            SaveDialog.FileName := SaveDialog.FileName + '.xml';
        end;
        SaveToFile(SaveDialog.FileName);
        m_OpenedFileName := ExtractFileName(SaveDialog.FileName);

        Caption := g_ApplicationName + ' [' + m_OpenedFileName + ']';
    end;
end;

{$REGION '설정파일의 입출력'}
//------------------------------------------------------------------------------------
procedure TMainForm.LoadFromFile(AFileName: String);
var
    f_Stream:TStringStream;
    f_XMLDocument : TXMLDocument;
    f_XMLNode:IXMLNode;
    f_ChildNode:IXMLNode;
    f_Loop:Integer;
    f_Child: TMDIBackTesting;
begin
    f_Stream := TStringStream.Create('', TEncoding.UTF8, true);
    f_Stream.LoadFromFile(AFileName);
    f_Stream.Position := 0;

    f_XMLDocument := TXMLDocument.Create(Application);
    try
        f_XMLDocument.LoadFromXML(f_Stream.ReadString(f_Stream.Size));
        f_XMLNode := f_XMLDocument.DocumentElement;
        if AnsiCompareText('BlockCollection', f_XMLNode.NodeName) = 0 then
        begin
            for f_Loop := 0 to f_XMLNode.ChildNodes.Count - 1 do
            begin
                f_ChildNode := f_XMLNode.ChildNodes[f_Loop];
                if AnsiCompareText('Block', f_ChildNode.NodeName) = 0 then
                begin
                    f_Child := TMDIBackTesting.Create(Application);
                    f_Child.Block.Read(f_ChildNode);
                    f_Child.UpdateData;
                end;
            end;
        end;
    finally
        if Assigned(f_XMLDocument) then f_XMLDocument.Free;
        f_Stream.Free;
    end;
end;
//------------------------------------------------------------------------------------
procedure TMainForm.SaveToFile(AFileName: String);
var
    f_TradingForm: TMDIBackTesting;
    f_Child:TForm;
    f_ChildIndex:Integer;

    f_Stream:TStringStream;
begin
    f_Stream := TStringStream.Create('', TEncoding.UTF8, true);
    f_Stream.WriteString('<BlockCollection>' + #$0A);

    for f_ChildIndex := 0 to MDIChildCount - 1 do
    begin
        f_Child := MDIChildren[f_ChildIndex];
        if f_Child is TMDIBackTesting then
        begin
            f_TradingForm := f_Child as TMDIBackTesting;
            f_TradingForm.GetOption;
            f_Stream.WriteString(f_TradingForm.Block.Write);
        end;
    end;
    f_Stream.WriteString('</BlockCollection>' + #$0A);

    f_Stream.SaveToFile(AFileName);
    f_Stream.Free;
end;

//------------------------------------------------------------------------------------
procedure TMainForm.WindowAllCloseExecute(Sender: TObject);
var
    f_Child:TForm;
    f_ChildIndex:Integer;
begin
    for f_ChildIndex := 0 to MDIChildCount - 1 do
    begin
        f_Child := MDIChildren[f_ChildIndex];
        f_Child.Close;
    end;
end;
//------------------------------------------------------------------------------------
procedure TMainForm.WindowAllCloseUpdate(Sender: TObject);
begin
    if MDIChildCount > 0 then WindowAllClose.Enabled := true else WindowAllClose.Enabled := false;
end;
//------------------------------------------------------------------------------------
{$ENDREGION}

{$REGION '메인 화면의 상태(최대,최소,일반), 크기, 위치를 저장하고 복원하는 부분'}
//------------------------------------------------------------------------------
// 메인 화면의 상태(최대,최소,일반), 크기, 위치를 저장하는 부분
procedure TMainForm.SaveMainWindow();
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
end;

//------------------------------------------------------------------------------
// 메인 화면의 상태(최대,최소,일반), 크기, 위치를 복원하는 부분
procedure TMainForm.RestoreMainWindow();
var
    f_Registry:CFNRegistry;
    f_WindowState:Integer;
    f_Left, f_Top, f_Width, f_Height:Integer;
begin
    f_Registry := CFNRegistry.Create(self);
    f_Registry.Company := g_CompanyName;
    f_Registry.ApplicationName := g_ApplicationName;

    f_WindowState   := f_Registry.ReadInteger('MainWindow', 'WindowState', 0);
    f_Left          := f_Registry.ReadInteger('MainWindow', 'WindowLeft'  , -1);
    f_Top           := f_Registry.ReadInteger('MainWindow', 'WindowTop'   , -1);
    f_Width         := f_Registry.ReadInteger('MainWindow', 'WindowWidth' , -1);
    f_Height        := f_Registry.ReadInteger('MainWindow', 'WindowHeight', -1);

    if ((f_Left <> -1) and (f_Top <> -1) and (f_Width <> -1) and (f_Height <> -1)) then
    begin
        Self.SetBounds(f_Left, f_Top, f_Width, f_Height);
    end;

    if (f_WindowState = 0) then WindowState := wsNormal
    else if (f_WindowState = 1) then WindowState := wsMinimized
    else WindowState := wsMaximized;

    f_Registry.Free;
end;
{$ENDREGION}

end.
