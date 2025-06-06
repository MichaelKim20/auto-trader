unit FNMultiMap;

interface

uses
  Contnrs, SysUtils, StrUtils, Classes, SyncObjs, IniFiles;

type

  // 멀티 Map List
  CFNMultiMap = class(TObject)
  private
    m_List: THashedStringList;
    m_MapLock: TCriticalSection;
    m_AutoFree: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function AddKeyValue(AKey: String; AObj: TObject): Boolean;
    function DeleteKeyValue(AKey: String; AObj: TObject): Boolean;
    function DeleteKey(AKey: String): Boolean;
    function DeleteValue(AObj: TObject): Boolean;
    function GetKey(AKey: String): TObjectList;
    function GetValue(AObj: TObject): THashedStringList;
    procedure Clear(bAutoFree: Boolean = TRUE);

    function GetAllKeys: TStringList;

    function GetCount: Integer;
    procedure SetAutoFree(bAutoFree: Boolean);
    function GetMapList: THashedStringList;

  end;

implementation

// ---------------------------------------------------------------------------
constructor CFNMultiMap.Create;
begin
  inherited Create;

  m_AutoFree := TRUE;
  m_List := THashedStringList.Create;
  m_MapLock := TCriticalSection.Create;
end;

// ---------------------------------------------------------------------------
destructor CFNMultiMap.Destroy;
begin
  Clear;
  m_List.Free;
  m_MapLock.Free;

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// 키에 해당하는 하나의 값을 추가 합니다.
function CFNMultiMap.AddKeyValue(AKey: String; AObj: TObject): Boolean;
var
  bFirstAdd: Boolean;
  nMapIdx: Integer;
  nListIdx: Integer;
  objList: TObjectList;
begin
  m_MapLock.Enter;

  bFirstAdd := FALSE;
  try
    if 0 < Length(AKey) then
    begin
      nMapIdx := m_List.IndexOf(AKey);

      // 해당 키로 생성된것이 있으면 해당리스트에 추가합니다.
      if 0 <= nMapIdx then
      begin
        objList := TObjectList(m_List.Objects[nMapIdx]);
        if 0 = objList.Count then
          bFirstAdd := TRUE;

        nListIdx := objList.IndexOf(AObj);
        if 0 > nListIdx then
        begin
          objList.Add(AObj);
        end;
      end
      // 생성된 것이 없으면 해당키로 생성하여 추가합니다.
      else
      begin
        objList := TObjectList.Create;
        objList.OwnsObjects := m_AutoFree;
        objList.Add(AObj);
        bFirstAdd := TRUE;

        m_List.AddObject(AKey, objList);
      end;
    end;
  finally
    Result := bFirstAdd;
    m_MapLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// 키에 해당하는 모든 값을 삭제 합니다.
function CFNMultiMap.DeleteKey(AKey: String): Boolean;
var
  bLastDelete: Boolean;
  nMapIdx: Integer;
  objList: TObjectList;
begin
  m_MapLock.Enter;
  bLastDelete := FALSE;
  try
    if 0 < Length(AKey) then
    begin
      nMapIdx := m_List.IndexOf(AKey);
      if 0 <= nMapIdx then
      begin
        objList := TObjectList(m_List.Objects[nMapIdx]);

        while 0 < objList.Count do
        begin
          objList.Delete(0);
        end;
        objList.Clear;
        objList.Free;

        m_List.Delete(nMapIdx);
        bLastDelete := TRUE;
      end;
    end;
  finally
    Result := bLastDelete;
    m_MapLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// 해당하는 키의 해당값을 삭제합니다.
function CFNMultiMap.DeleteKeyValue(AKey: String; AObj: TObject): Boolean;
var
  bLastDelete: Boolean;
  nMapIdx: Integer;
  nListIdx: Integer;
  objList: TObjectList;
begin
  m_MapLock.Enter;
  bLastDelete := FALSE;
  try
    if 0 < Length(AKey) then
    begin
      nMapIdx := m_List.IndexOf(AKey);
      if 0 <= nMapIdx then
      begin
        objList := TObjectList(m_List.Objects[nMapIdx]);
        if Assigned(objList) then
        begin
          nListIdx := objList.IndexOf(AObj);
          if 0 <= nListIdx then
            objList.Delete(nListIdx);

          // 마지막인경우 맵에서 제거한다.
          if 0 >= objList.Count then
          begin
            objList.Free;
            m_List.Delete(nMapIdx);
            bLastDelete := TRUE;
          end;
        end;
      end
      else
      begin
        bLastDelete := FALSE;
      end;
    end;
  finally
    Result := bLastDelete;
    m_MapLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// 모든 키에서 해당 값을 삭제합니다.
function CFNMultiMap.DeleteValue(AObj: TObject): Boolean;
var
  bReturn: Boolean;
  nMapIdx: Integer;
  nMapCnt: Integer;
  objList: TObjectList;
  nListIdx: Integer;
begin
  m_MapLock.Enter;
  bReturn := FALSE;
  try
    if Assigned(AObj) then
    begin
      nMapCnt := m_List.Count;
      nMapIdx := 0;

      while 0 < nMapCnt do
      begin
        objList := TObjectList(m_List.Objects[nMapIdx]);
        nListIdx := objList.IndexOf(AObj);
        if 0 <= nListIdx then
        begin
          objList.Delete(nListIdx);
        end;
        {
          if Assigned(AObj) then
          begin
          objList.Extract(AObj);
          end;
        }
        if 0 >= objList.Count then
        begin
          objList.Free;
          m_List.Delete(nMapIdx);
          nMapIdx := nMapIdx - 1;
        end;

        nMapIdx := nMapIdx + 1;
        nMapCnt := nMapCnt - 1;
      end;

      bReturn := TRUE;
    end;
  finally
    Result := bReturn;
    m_MapLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// 모든 키에서 해당 값을 리턴합니다.
function CFNMultiMap.GetKey(AKey: String): TObjectList;
var
  objList: TObjectList;
  nMapIdx: Integer;

  newObjList: TObjectList;
  newIdx: Integer;
begin
  m_MapLock.Enter;
  newObjList := NIL;
  try
    if 0 < Length(AKey) then
    begin
      nMapIdx := m_List.IndexOf(AKey);
      if 0 <= nMapIdx then
      begin
        objList := TObjectList(m_List.Objects[nMapIdx]);

        // 복사?
        newObjList := TObjectList.Create;
        newObjList.OwnsObjects := m_AutoFree;
        for newIdx := 0 to objList.Count - 1 do
        begin
          newObjList.Add(objList.Items[newIdx]);
        end;

      end;
    end;
  finally
    Result := newObjList;
    m_MapLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// 해당값을 포함하는 키들을 리턴합니다.
function CFNMultiMap.GetValue(AObj: TObject): THashedStringList;
var
  newMapList: THashedStringList;

  objList: TObjectList;
  strMapKey: String;
  nMapIdx: Integer;
  nListIdx: Integer;
begin
  m_MapLock.Enter;
  newMapList := NIL;
  try
    if Assigned(AObj) then
    begin
      newMapList := THashedStringList.Create;
      for nMapIdx := 0 to m_List.Count - 1 do
      begin
        objList := TObjectList(m_List.Objects[nMapIdx]);
        nListIdx := objList.IndexOf(AObj);
        if 0 <= nListIdx then
        begin
          strMapKey := m_List[nMapIdx];
          newMapList.AddObject(strMapKey, objList);
        end;
      end;

      if 0 >= newMapList.Count then
      begin
        newMapList.Free;
        newMapList := NIL;
      end;
    end;
  finally
    Result := newMapList;
    m_MapLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// 해당값을 포함하는 키들을 리턴합니다.
function CFNMultiMap.GetAllKeys: TStringList;
var
  newStringList: TStringList;
  objList: TObjectList;
  strMapKey: String;
  nMapIdx: Integer;
  nListIdx: Integer;
begin
  m_MapLock.Enter;
  newStringList := NIL;
  try
    newStringList := TStringList.Create;
    for nMapIdx := 0 to m_List.Count - 1 do
    begin
      strMapKey := m_List[nMapIdx];
      newStringList.Add(strMapKey);
    end;

    if 0 >= newStringList.Count then
    begin
      newStringList.Free;
      newStringList := NIL;
    end;
  finally
    Result := newStringList;
    m_MapLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
// 모든 데이터를 삭제합니다.
procedure CFNMultiMap.Clear(bAutoFree: Boolean = TRUE);
var
  objList: TObjectList;
begin
  m_MapLock.Enter;
  try
    while 0 < m_List.Count do
    begin
      objList := TObjectList(m_List.Objects[0]);
      if Assigned(objList) then
      begin
        // objList.OwnsObjects := bAutoFree;
        while 0 < objList.Count do
        begin
          objList.Delete(0);
        end;
        objList.Clear;
        objList.Free;
      end;
      m_List.Delete(0);
    end;
  finally
    m_MapLock.Leave;
  end;
end;

// ---------------------------------------------------------------------------
function CFNMultiMap.GetCount: Integer;
begin
  Result := m_List.Count;
end;

// ---------------------------------------------------------------------------
procedure CFNMultiMap.SetAutoFree(bAutoFree: Boolean);
begin
  m_AutoFree := bAutoFree;
end;

// ---------------------------------------------------------------------------
function CFNMultiMap.GetMapList: THashedStringList;
begin
  Result := m_List;
end;

end.
