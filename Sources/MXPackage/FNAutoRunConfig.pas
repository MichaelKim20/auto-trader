unit FNAutoRunConfig;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  CFNAutoRunConfig = class(TObject)
  public
    m_MatrixUserID: String;
    m_MatrixUserPW: String;
    m_SecUserID: String;
    m_SecUserPW: String;
    m_CertPW: String;
    m_TradePW: String;
    m_TradeMode: String;

    m_WRSecUserID: String;
    m_WRSecUserPW: String;

    m_CertWindowTitle: String;
    m_CertWindowOK: String;

    m_MainWindowTitle: String;
    m_OrderCount: Integer;
    m_ConfigFileName: String;
    m_AccountNo: String;
    m_AccountPW: String;
    m_Email: String;

  public
    constructor Create;
    destructor Destroy; override;
    function Load(AFileName: String): Boolean;
  end;

implementation

uses XMLIntf, xmldom, msxmldom, XMLDoc, Variants, ComObj, FNGlobal;

{ CFNAutoRunConfig }

constructor CFNAutoRunConfig.Create;
begin
  m_TradeMode := 'Real';
  m_CertWindowTitle := '인증서 선택  (Ver 9.8.0.2)  ';
  m_CertWindowOK := '인증서 선택(확인)';
  m_OrderCount := 1;
  m_ConfigFileName := '';
  m_Email := '';
end;

destructor CFNAutoRunConfig.Destroy;
begin

  inherited;
end;

function CFNAutoRunConfig.Load(AFileName: String): Boolean;
var
  f_Index0: Integer;
  f_Index1: Integer;
  f_Stream: TStringStream;
  f_XMLDocument: TXMLDocument;
  f_XMLNode: IXMLNode;
  f_ChildNode: IXMLNode;
  f_ValueNode: IXMLNode;
  f_Success: Boolean;
begin
  f_XMLDocument := NIL;
  if not FileExists(AFileName) then
  begin
    Result := false;
    exit;
  end;

  f_Stream := TStringStream.Create;
  f_Stream.LoadFromFile(AFileName);
  f_Stream.Position := 0;

  f_Success := true;
  try
    f_XMLDocument := TXMLDocument.Create(Application);
    f_XMLDocument.LoadFromXML(f_Stream.ReadString(f_Stream.Size));

    f_XMLNode := f_XMLDocument.DocumentElement;

    if AnsiCompareText('Config', f_XMLNode.NodeName) = 0 then
    begin
      for f_Index0 := 0 to f_XMLNode.ChildNodes.Count - 1 do
      begin
        f_ChildNode := f_XMLNode.ChildNodes[f_Index0];
        if not Assigned(f_ChildNode) then
          continue;
        if AnsiCompareText('LoginWindow', f_ChildNode.NodeName) = 0 then
        begin

          for f_Index1 := 0 to f_ChildNode.ChildNodes.Count - 1 do
          begin
            f_ValueNode := f_ChildNode.ChildNodes[f_Index1];
            if not Assigned(f_ValueNode) then
              continue;
            if AnsiCompareText('MatrixID', f_ValueNode.NodeName) = 0 then
            begin
              m_MatrixUserID := Trim(VarToStr(f_ValueNode.NodeValue));
            end
            else if AnsiCompareText('MatrixPW', f_ValueNode.NodeName) = 0 then
            begin
              m_MatrixUserPW := Trim(VarToStr(f_ValueNode.NodeValue));
            end
            else if AnsiCompareText('LavenderID', f_ValueNode.NodeName) = 0 then
            begin
              m_MatrixUserID := Trim(VarToStr(f_ValueNode.NodeValue));
            end
            else if AnsiCompareText('LavenderPW', f_ValueNode.NodeName) = 0 then
            begin
              m_MatrixUserPW := Trim(VarToStr(f_ValueNode.NodeValue));
            end
            else if AnsiCompareText('SecID', f_ValueNode.NodeName) = 0 then
            begin
              m_SecUserID := Trim(VarToStr(f_ValueNode.NodeValue));
            end
            else if AnsiCompareText('SecPW', f_ValueNode.NodeName) = 0 then
            begin
              m_SecUserPW := Trim(VarToStr(f_ValueNode.NodeValue));
            end
            else if AnsiCompareText('CertPW', f_ValueNode.NodeName) = 0 then
            begin
              m_CertPW := Trim(VarToStr(f_ValueNode.NodeValue));
            end
            else if AnsiCompareText('WRSecID', f_ValueNode.NodeName) = 0 then
            begin
              m_WRSecUserID := Trim(VarToStr(f_ValueNode.NodeValue));
            end
            else if AnsiCompareText('WRSecPW', f_ValueNode.NodeName) = 0 then
            begin
              m_WRSecUserPW := Trim(VarToStr(f_ValueNode.NodeValue));
            end
            else if AnsiCompareText('TradePW', f_ValueNode.NodeName) = 0 then
            begin
              m_TradePW := Trim(VarToStr(f_ValueNode.NodeValue));
            end
            else if AnsiCompareText('TradeMode', f_ValueNode.NodeName) = 0 then
            begin
              m_TradeMode := Trim(VarToStr(f_ValueNode.NodeValue));
            end;
          end;
        end
        else if AnsiCompareText('CertWindow', f_ChildNode.NodeName) = 0 then
        begin
          for f_Index1 := 0 to f_ChildNode.ChildNodes.Count - 1 do
          begin
            f_ValueNode := f_ChildNode.ChildNodes[f_Index1];
            if not Assigned(f_ValueNode) then
              continue;
            if AnsiCompareText('Title', f_ValueNode.NodeName) = 0 then
            begin
              m_CertWindowTitle := VarToStr(f_ValueNode.NodeValue);
            end
            else if AnsiCompareText('OKCaption', f_ValueNode.NodeName) = 0 then
            begin
              m_CertWindowOK := VarToStr(f_ValueNode.NodeValue);
            end;
          end;
        end
        else if AnsiCompareText('MainWindow', f_ChildNode.NodeName) = 0 then
        begin
          for f_Index1 := 0 to f_ChildNode.ChildNodes.Count - 1 do
          begin
            f_ValueNode := f_ChildNode.ChildNodes[f_Index1];
            if not Assigned(f_ValueNode) then
              continue;
            if AnsiCompareText('Title', f_ValueNode.NodeName) = 0 then
            begin
              m_MainWindowTitle := Trim(VarToStr(f_ValueNode.NodeValue));
            end
            else if AnsiCompareText('OrderCount', f_ValueNode.NodeName) = 0 then
            begin
              m_OrderCount := TFNGlobal.atoi(Trim(VarToStr(f_ValueNode.NodeValue)));
            end
            else if AnsiCompareText('FileName', f_ValueNode.NodeName) = 0 then
            begin
              m_ConfigFileName := Trim(VarToStr(f_ValueNode.NodeValue));
            end
            else if AnsiCompareText('AccountNo', f_ValueNode.NodeName) = 0 then
            begin
              m_AccountNo := Trim(VarToStr(f_ValueNode.NodeValue));
            end
            else if AnsiCompareText('AccountPW', f_ValueNode.NodeName) = 0 then
            begin
              m_AccountPW := Trim(VarToStr(f_ValueNode.NodeValue));
            end
            else if AnsiCompareText('EMail', f_ValueNode.NodeName) = 0 then
            begin
              m_Email := Trim(VarToStr(f_ValueNode.NodeValue));
            end;
          end;
        end;
      end;
    end;

  except
    f_Success := false;
  end;
  if Assigned(f_XMLDocument) then
    f_XMLDocument.Free;
  if Assigned(f_Stream) then
    f_Stream.Free;

  Result := f_Success;
end;

end.
