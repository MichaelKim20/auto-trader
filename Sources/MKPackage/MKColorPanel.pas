unit MKColorPanel;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, Graphics, Messages;

type
  TColorPanel = class(TPanel)
  private
    m_PaddingColor: TColor;
    procedure SetPaddingColor(AColor: TColor);
  protected
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property PaddingColor: TColor read m_PaddingColor write SetPaddingColor default clGray;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MKPackage', [TColorPanel]);
end;

{ TColorPanel }

constructor TColorPanel.Create(AOwner: TComponent);
begin
  inherited;
  BevelOuter := bvNone;
  BevelInner := bvNone;
  m_PaddingColor := clGray;
end;

procedure TColorPanel.Paint;
var
  I: Integer;
  f_Canvas: TCanvas;
begin
  inherited;
  f_Canvas := Canvas;
  f_Canvas.Pen.Color := m_PaddingColor;
  f_Canvas.Pen.Style := psSolid;
  f_Canvas.Pen.Width := 1;
  if Padding.Left > 0 then
  begin
    for I := 0 to Padding.Left - 1 do
    begin
      f_Canvas.MoveTo(I, 0);
      f_Canvas.LineTo(I, Height);
    end;
  end;
  if Padding.Right > 0 then
  begin
    for I := 0 to Padding.Right - 1 do
    begin
      f_Canvas.MoveTo(Width - 1 - I, 0);
      f_Canvas.LineTo(Width - 1 - I, Height);
    end;
  end;
  if Padding.Top > 0 then
  begin
    for I := 0 to Padding.Top - 1 do
    begin
      f_Canvas.MoveTo(0, I);
      f_Canvas.LineTo(Width, I);
    end;
  end;
  if Padding.Bottom > 0 then
  begin
    for I := 0 to Padding.Bottom - 1 do
    begin
      f_Canvas.MoveTo(0, Height - 1 - I);
      f_Canvas.LineTo(Width, Height - 1 - I);
    end;
  end;
end;

// ---------------------------------------------------------------------------
procedure TColorPanel.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  Message.Result := 0;
end;

procedure TColorPanel.SetPaddingColor(AColor: TColor);
begin
  m_PaddingColor := AColor;
  Invalidate;
end;

end.
