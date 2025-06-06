unit MKTradeSystemManager;

interface

uses
  Math, Windows, SysUtils, Classes,
  MKTradeSignalDefine,
  MKSignalData,
  MKSignalArray,
  MKTradeData,
  MKTradeArray;

type
  CMKTradeSystemManager = class(TObject)
  public
    constructor Create();
    destructor Destroy(); override;
    procedure Clear;

  public
    m_SignalArray: CMKSignalArray;

    m_LongTradeArray: CMKTradeArray;
    m_ShortTradeArray: CMKTradeArray;
    m_AllTradeArray: CMKTradeArray;

    procedure MakeTradeList;
  end;

implementation

uses
  MKGlobal;

// ---------------------------------------------------------------------------
procedure CMKTradeSystemManager.Clear;
begin
  m_SignalArray.Clear;
  m_LongTradeArray.Clear;
  m_ShortTradeArray.Clear;
  m_AllTradeArray.Clear;
end;

constructor CMKTradeSystemManager.Create();
begin
  inherited Create();

  m_SignalArray := CMKSignalArray.Create;
  m_LongTradeArray := CMKTradeArray.Create;
  m_ShortTradeArray := CMKTradeArray.Create;
  m_AllTradeArray := CMKTradeArray.Create;
end;

// ---------------------------------------------------------------------------
destructor CMKTradeSystemManager.Destroy();
begin
  m_SignalArray.Free;

  m_LongTradeArray.Free;
  m_ShortTradeArray.Free;
  m_AllTradeArray.Free;

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
procedure CMKTradeSystemManager.MakeTradeList;
var
  f_Index: Integer;
  f_SignalData: CMKSignalData;
  f_AllTradeData: CMKTradeData;
  f_LongTradeData: CMKTradeData;
  f_ShortTradeData: CMKTradeData;
  f_SignalData1, f_SignalData2: CMKSignalData;
  f_Signal: Integer;
  f_Count: Integer;
begin

  f_Count := m_SignalArray.m_Items.Count;

  m_AllTradeArray.Clear;
  m_LongTradeArray.Clear;
  m_ShortTradeArray.Clear;

  f_Signal := SIGNAL_NONE;

  for f_Index := 0 to f_Count - 1 do
  begin
    f_SignalData := m_SignalArray.m_Items[f_Index];

    if ((f_SignalData.m_Signal = SIGNAL_SELLENTER) or (f_SignalData.m_Signal = SIGNAL_BUYENTER)) then
    begin
      if (f_Signal = SIGNAL_SELLENTER) then
      begin
        if not Assigned(f_AllTradeData) then
          f_AllTradeData := CMKTradeData.Create;
        f_AllTradeData.CopyExit(f_SignalData);
        m_AllTradeArray.Add(f_AllTradeData);
        f_AllTradeData := NIL;

        if not Assigned(f_ShortTradeData) then
          f_ShortTradeData := CMKTradeData.Create;
        f_ShortTradeData.CopyExit(f_SignalData);
        m_ShortTradeArray.Add(f_ShortTradeData);
        f_ShortTradeData := NIL;

      end
      else if (f_Signal = SIGNAL_BUYENTER) then
      begin
        if not Assigned(f_AllTradeData) then
          f_AllTradeData := CMKTradeData.Create;
        f_AllTradeData.CopyExit(f_SignalData);
        m_AllTradeArray.Add(f_AllTradeData);
        f_AllTradeData := NIL;

        if not Assigned(f_LongTradeData) then
          f_LongTradeData := CMKTradeData.Create;
        f_LongTradeData.CopyExit(f_SignalData);
        m_LongTradeArray.Add(f_LongTradeData);
        f_LongTradeData := NIL;
      end
    end;

    if (f_SignalData.m_Signal = SIGNAL_BUYENTER) then
    begin
      f_LongTradeData := CMKTradeData.Create;
      f_LongTradeData.CopyEnter(f_SignalData);

      f_AllTradeData := CMKTradeData.Create;
      f_AllTradeData.CopyEnter(f_SignalData);
    end
    else if (f_SignalData.m_Signal = SIGNAL_SELLENTER) then
    begin
      f_ShortTradeData := CMKTradeData.Create;
      f_ShortTradeData.CopyEnter(f_SignalData);

      f_AllTradeData := CMKTradeData.Create;
      f_AllTradeData.CopyEnter(f_SignalData);
    end
    else if (f_SignalData.m_Signal = SIGNAL_BUYEXIT) then
    begin
      if not Assigned(f_LongTradeData) then
        f_LongTradeData := CMKTradeData.Create;
      f_LongTradeData.CopyExit(f_SignalData);
      m_LongTradeArray.Add(f_LongTradeData);
      f_LongTradeData := NIL;

      if not Assigned(f_AllTradeData) then
        f_AllTradeData := CMKTradeData.Create;
      f_AllTradeData.CopyExit(f_SignalData);
      m_AllTradeArray.Add(f_AllTradeData);
      f_AllTradeData := NIL;
    end
    else if (f_SignalData.m_Signal = SIGNAL_SELLEXIT) then
    begin
      if not Assigned(f_ShortTradeData) then
        f_ShortTradeData := CMKTradeData.Create;
      f_ShortTradeData.CopyExit(f_SignalData);
      m_ShortTradeArray.Add(f_ShortTradeData);
      f_ShortTradeData := NIL;

      if not Assigned(f_AllTradeData) then
        f_AllTradeData := CMKTradeData.Create;
      f_AllTradeData.CopyExit(f_SignalData);
      m_AllTradeArray.Add(f_AllTradeData);
      f_AllTradeData := NIL;
    end;
    f_Signal := f_SignalData.m_Signal;
  end;

  m_AllTradeArray.MakePerformance;
  m_LongTradeArray.MakePerformance;
  m_ShortTradeArray.MakePerformance;
end;

end.
