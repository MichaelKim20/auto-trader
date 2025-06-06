unit FNMatrixChartControlBase;

interface

uses
  SysUtils, Classes, Controls, GR32_Image, GR32, Types, Messages, Graphics,
  DateUtils, Dialogs, Math,
  StdCtrls, Windows, GR32_Layers;

type
  TFNMatrixChartTraceChange = Procedure(p_Index: Integer; p_ValueX: Double; p_ValueY: Double) of Object;

  CFNMatrixChartControlBase = class(TImgView32)
  private

    m_OnChartTraceChange: TFNMatrixChartTraceChange;
    m_OnClickPos: TFNMatrixChartTraceChange;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnChartTraceChange: TFNMatrixChartTraceChange read m_OnChartTraceChange write m_OnChartTraceChange;
    property OnClickPos: TFNMatrixChartTraceChange read m_OnClickPos write m_OnClickPos;

  end;

implementation

// ---------------------------------------------------------------------------
constructor CFNMatrixChartControlBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

// ---------------------------------------------------------------------------
destructor CFNMatrixChartControlBase.Destroy;
begin
  inherited Destroy;
end;

end.
