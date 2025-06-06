unit FNCMVariable;

interface

uses
  Classes, SysUtils, ComObj, FNSocketManager, FNSymbolCollection,
  FNMaterialCollection, FNPOTCollection, FNMessageManager;

var
  g_SocketManager: CFNSocketManager;
  g_SymbolCollection: CFNSymbolCollection;
  g_MaterialCollection: CFNMaterialCollection;
  g_POTCollection: CFNPOTCollection;
  g_MessageManager : CFNMessageManager;

  g_StreamServerIP: String;
  g_StreamServerPort: Integer;

  g_ApplicationName: String;
  g_CompanyName: String;

  g_LibraryAllow: Boolean;

  g_Language: Integer;

function CheckAllow: Boolean;

implementation

uses FNGlobal, IdHTTP, Dialogs;

function CheckAllow: Boolean;
var
  f_Sucess: Boolean;
  f_Allow: Boolean;
  f_QueryURL: String;
  f_Stream: TStringStream;
  f_HTTP: TIdHTTP;

  f_ValueString: String;
  f_P1, f_P2: Integer;
  f_Content: String;
  f_RecordList: TStringList;
  f_FieldList: TStringList;
  f_RecordIndex: Integer;
begin
  f_Allow := false;
  f_QueryURL := 'http://blog.naver.com/PostView.nhn?blogId=worldia&logNo=70178209021&redirect=Dlog&widgetTypeCall=true';

  f_HTTP := TIdHTTP.Create(NIL);
  f_Stream := TStringStream.Create;
  f_RecordList := TStringList.Create;
  f_FieldList := TStringList.Create;
  try
    f_Sucess := true;
    try
      f_HTTP.Get(f_QueryURL, f_Stream);
    except
      on E: Exception do
        f_Sucess := false;
    end;

    if f_Sucess then
    begin
      f_Stream.Position := 0;

      f_ValueString := f_Stream.ReadString(f_Stream.Size);
      f_P1 := Pos('[HTTP DATA]', f_ValueString);
      f_P2 := Pos('[/HTTP DATA]', f_ValueString);

      if (f_P1 <> 0) and (f_P2 <> 0) then
      begin
        f_P1 := f_P1 + 11;
        f_Content := Copy(f_ValueString, f_P1, f_P2 - f_P1);

        if CompareText(Trim(f_Content), '1') = 0 then
          f_Allow := true;
      end;
    end;
  finally
    f_Stream.Free;
    f_HTTP.Free;
    f_RecordList.Free;
    f_FieldList.Free;
  end;

  Result := f_Allow;
end;

// ---------------------------------------------------------------------------
Initialization

begin
  g_LibraryAllow := true;

  g_Language := 0;

  g_SymbolCollection := CFNSymbolCollection.Create;
  g_MaterialCollection := CFNMaterialCollection.Create;
  g_POTCollection := CFNPOTCollection.Create;
  g_MessageManager := CFNMessageManager.Create;

  g_StreamServerIP := '210.116.104.82';
  g_StreamServerPort := 7795;

  g_CompanyName := '';
  g_ApplicationName := '';
end;

// ---------------------------------------------------------------------------
Finalization

begin
  g_SymbolCollection.Free;
  g_MaterialCollection.Free;
  g_POTCollection.Free;
  g_MessageManager.Free;
end;
// ---------------------------------------------------------------------------

end.
