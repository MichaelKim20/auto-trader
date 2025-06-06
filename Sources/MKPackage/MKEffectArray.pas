unit MKEffectArray;

interface

uses
  Math, Windows, SysUtils, Classes, MKEffectData, ExtCtrls;

const
  EFFECT_DURATION = 60;
  EFFECT_INTERVAL = 20;

type
  CMKEffectArray = class(TObject)
  private
    m_OnStart: TNotifyEvent;
    m_OnEnd: TNotifyEvent;

    m_DeltaT: Integer;
    m_Duration: Integer;
    m_Interval: Integer;

    function ExponentiaEaseIn(t: Double; b: Double; c: Double; d: Double): Double;
    function ExponentiaEaseOut(t: Double; b: Double; c: Double; d: Double): Double;

    procedure OnTimer(Sender: TObject);

  public
    m_Items: TList;
    m_Timer: TTimer;

  public
    constructor Create();
    destructor Destroy(); override;

    procedure Start(p_Duration: Integer = EFFECT_DURATION);
    procedure Stop;

  public
    procedure Clear();
    procedure Add(p_EffectData: CMKEffectData);

    property OnStart: TNotifyEvent read m_OnStart write m_OnStart;
    property OnEnd: TNotifyEvent read m_OnEnd write m_OnEnd;
    property Interval: Integer read m_Interval write m_Interval;
  end;

implementation

uses
  MKGlobal;

// ---------------------------------------------------------------------------
constructor CMKEffectArray.Create();
begin
  inherited Create();
  m_Interval := EFFECT_INTERVAL;
  m_Items := TList.Create();
  m_Timer := TTimer.Create(NIL);
  m_Timer.Enabled := FALSE;
  m_Timer.OnTimer := OnTimer;
  m_Timer.Interval := m_Interval;;
end;

// ---------------------------------------------------------------------------
// 파괴자
destructor CMKEffectArray.Destroy();
begin
  Clear();

  m_Items.Free();
  m_Items := NIL;

  m_Timer.Free;
  m_Timer := NIL;

  inherited Destroy();
end;

// ---------------------------------------------------------------------------
// 배열의 구성요소를 모두 삭제한다.
procedure CMKEffectArray.Clear();
begin
  while 0 < m_Items.Count do
  begin
    CMKEffectData(m_Items.Items[0]).Free();
    m_Items.Delete(0);
  end;
end;

// ---------------------------------------------------------------------------
// 하나를 추가한다.
procedure CMKEffectArray.Add(p_EffectData: CMKEffectData);
begin
  m_Items.Add(p_EffectData);
end;

procedure CMKEffectArray.Start(p_Duration: Integer);
begin
  m_DeltaT := 0;
  m_Duration := p_Duration;
  m_Timer.Enabled := FALSE;
  m_Timer.OnTimer := OnTimer;
  m_Timer.Interval := m_Interval;
  m_Timer.Enabled := TRUE;
end;

procedure CMKEffectArray.Stop;
begin
  m_Timer.Enabled := FALSE;

end;

// ------------------------------------------------------------------------------
function CMKEffectArray.ExponentiaEaseIn(t: Double; b: Double; c: Double; d: Double): Double;
var
  f_Factor1: Double;
  f_Factor2: Double;
begin
  if (t = 0) then
  begin
    result := b;
  end
  else
  begin
    f_Factor1 := 10 * ((t / d) - 1);
    f_Factor2 := Power(2, f_Factor1);
    result := c * f_Factor2 + b;
  end;
end;

// ------------------------------------------------------------------------------
function CMKEffectArray.ExponentiaEaseOut(t: Double; b: Double; c: Double; d: Double): Double;
var
  f_Factor1: Double;
  f_Factor2: Double;
begin
  if (t = d) then
  begin
    result := b + c;
  end
  else
  begin
    f_Factor1 := -10 * t / d;
    f_Factor2 := Power(2, f_Factor1);
    result := c * (-Power(2, f_Factor1) + 1) + b;
  end;
end;

// ------------------------------------------------------------------------------
// 점진적으로 창의 크기가 변경될 수 있도록 타이머를 사용하여 관리한다.
procedure CMKEffectArray.OnTimer(Sender: TObject);
var
  f_Value: Integer;
  f_OtherWidth: Integer;
  f_End: Boolean;
  f_EffectIndex: Integer;
  f_EffectData: CMKEffectData;
  f_NewX, f_NewY, f_NewWidth, f_NewHeight: Integer;
begin
  if (0 = m_DeltaT) then
  begin
    if Assigned(m_OnStart) then
    begin
      m_OnStart(Sender);
    end;
  end;
  for f_EffectIndex := 0 to m_Items.Count - 1 do
  begin
    f_EffectData := CMKEffectData(m_Items.Items[f_EffectIndex]);
    if not Assigned(f_EffectData) then
      continue;

    if (f_EffectData.m_Type = EFFECT_MOVE) then
    begin
      f_EffectData.m_X := Round(ExponentiaEaseOut(m_DeltaT, f_EffectData.m_FromX, f_EffectData.m_ToX - f_EffectData.m_FromX,
          m_Duration));
      f_EffectData.m_Y := Round(ExponentiaEaseOut(m_DeltaT, f_EffectData.m_FromY, f_EffectData.m_ToY - f_EffectData.m_FromY,
          m_Duration));
    end
    else
    begin
      f_EffectData.m_Width := Round(ExponentiaEaseOut(m_DeltaT, f_EffectData.m_FromWidth,
          f_EffectData.m_ToWidth - f_EffectData.m_FromWidth, m_Duration));
      f_EffectData.m_Height := Round(ExponentiaEaseOut(m_DeltaT, f_EffectData.m_FromHeight,
          f_EffectData.m_ToHeight - f_EffectData.m_FromHeight, m_Duration));
    end;
  end;
  f_End := FALSE;

  m_DeltaT := m_DeltaT + m_Interval;
  if (m_DeltaT > m_Duration) then
  begin
    m_Timer.Enabled := FALSE;
    f_End := TRUE;
  end;

  if (f_End) then
  begin
    for f_EffectIndex := 0 to m_Items.Count - 1 do
    begin
      f_EffectData := CMKEffectData(m_Items.Items[f_EffectIndex]);
      if not Assigned(f_EffectData) then
        continue;

      if (f_EffectData.m_Type = EFFECT_MOVE) then
      begin
        f_EffectData.m_X := f_EffectData.m_ToX;
        f_EffectData.m_Y := f_EffectData.m_ToY;
      end
      else
      begin
        f_EffectData.m_Width := f_EffectData.m_ToWidth;
        f_EffectData.m_Height := f_EffectData.m_ToHeight;
      end;
    end;
  end;

  for f_EffectIndex := 0 to m_Items.Count - 1 do
  begin
    f_EffectData := CMKEffectData(m_Items.Items[f_EffectIndex]);
    if not Assigned(f_EffectData) then
      continue;
    if not Assigned(f_EffectData.m_Control) then
      continue;

    if (f_EffectData.m_Type = EFFECT_MOVE) then
    begin
      f_EffectData.m_Control.SetBounds(f_EffectData.m_X, f_EffectData.m_Y, f_EffectData.m_Control.Width,
          f_EffectData.m_Control.Height);
      f_EffectData.m_Control.RePaint;
    end
    else
    begin
      f_EffectData.m_Control.SetBounds(f_EffectData.m_Control.Left, f_EffectData.m_Control.Top, f_EffectData.m_Width,
          f_EffectData.m_Height);
      f_EffectData.m_Control.RePaint;
    end;
  end;

  if (f_End) then
  begin
    if Assigned(m_OnEnd) then
    begin
      m_OnEnd(Sender);
    end;
  end;
end;

end.
