unit FNNAVAnalChartControlBase;

interface

uses
  SysUtils, Classes, Controls, GR32_Image, GR32, Types, Messages, Graphics,
  DateUtils, Dialogs, Math,
  StdCtrls, Windows, GR32_Layers;

type
  TFNNAVAnalChartTraceChange = Procedure(p_Index: Integer; p_ValueX: Double; p_ValueY: Double) of Object;

  CFNNAVAnalChartControlBase = class(TImgView32)
  private

    m_OnChartTraceChange: TFNNAVAnalChartTraceChange;
    m_OnClickPos: TFNNAVAnalChartTraceChange;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnChartTraceChange: TFNNAVAnalChartTraceChange read m_OnChartTraceChange write m_OnChartTraceChange;
    property OnClickPos: TFNNAVAnalChartTraceChange read m_OnClickPos write m_OnClickPos;

  end;

implementation

// ---------------------------------------------------------------------------
constructor CFNNAVAnalChartControlBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

// ---------------------------------------------------------------------------
destructor CFNNAVAnalChartControlBase.Destroy;
begin
  inherited Destroy;
end;

end.
