unit MKEffectData;

interface

uses
  SysUtils, Controls;

const
  EFFECT_MOVE = 0;
  EFFECT_SIZE = 1;

type

  /// /////////////////////////////////////////////////////////////////////////
  //
  CMKEffectData = class(TObject)
  public
    m_Type: Integer;

    m_FromX: Integer;
    m_FromY: Integer;
    m_ToX: Integer;
    m_ToY: Integer;
    m_X: Integer;
    m_Y: Integer;

    m_FromWidth: Integer;
    m_FromHeight: Integer;
    m_ToWidth: Integer;
    m_ToHeight: Integer;

    m_Width: Integer;
    m_Height: Integer;

    m_Control: TControl;
  public
    constructor Create();
    destructor Destroy(); override;
  end;

implementation

// ---------------------------------------------------------------------------
constructor CMKEffectData.Create();
begin
  inherited Create();
end;

// ---------------------------------------------------------------------------
destructor CMKEffectData.Destroy();
begin

  inherited Destroy();
end;

// ---------------------------------------------------------------------------

end.
