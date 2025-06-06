unit FNMatrixColorSet;

interface

uses
  SysUtils, Math;

type
  CFNMatrixColorSet = class(TObject)
  public const
    STRING_FONT_FAMILY: String = 'Gulim';
    STRING_FONT_BIGSIZE: Integer = 12;
    STRING_FONT_SMALLSIZE: Integer = 9;
    STRING_FONT_SMALLSIZE2: Integer = 8;

    NUMBER_FONT_FAMILY: String = 'Tahoma';
    NUMBER_FONT_BIGSIZE: Integer = 12;
    NUMBER_FONT_SMALLSIZE: Integer = 9;
    NUMBER_FONT_SMALLSIZE2: Integer = 8;

    NUMBER2_FONT_FAMILY: String = 'Gulim';
    NUMBER2_FONT_BIGSIZE: Integer = 12;
    NUMBER2_FONT_SMALLSIZE: Integer = 9;
    NUMBER2_FONT_SMALLSIZE2: Integer = 8;

    ACTIVE_FACTOR: Double = 0.8;

    FRAME_COLOR: Integer = 50;
    BACKGROUND_COLOR: Integer = 51;
    TEXT_COLOR: Integer = 52;
    AXIS_COLOR: Integer = 53;
    GRID_COLOR: Integer = 54;
    PRICE_COLOR: Integer = 56;

    PRICE_MAX_COLOR: Integer = 57;
    PRICE_MIN_COLOR: Integer = 58;

    PRICE_UP_FILLED_COLOR: Integer = 60;
    PRICE_UP_LINE_COLOR: Integer = 61;
    PRICE_DN_FILLED_COLOR: Integer = 64;
    PRICE_DN_LINE_COLOR: Integer = 65;
    VOLUME_FILLED_COLOR: Integer = 68;
    VOLUME_LINE_COLOR: Integer = 69;
    OSC_UP_FILLED_COLOR: Integer = 72;
    OSC_UP_LINE_COLOR: Integer = 73;
    OSC_DN_FILLED_COLOR: Integer = 76;
    OSC_DN_LINE_COLOR: Integer = 77;
    EXIT_BTN_FILLED_COLOR: Integer = 80;
    EXIT_BTN_LINE_COLOR: Integer = 81;
    PAXSTYLE_UP_LINE: Integer = 82;
    PAXSTYLE_EQ_LINE: Integer = 83;
    PAXSTYLE_DN_LINE: Integer = 84;

    TEXT_UP_LINE: Integer = 85;
    TEXT_EQ_LINE: Integer = 86;
    TEXT_DN_LINE: Integer = 87;

    IMCLOUDE_UP_FILLED_COLOR: Integer = 88;
    IMCLOUDE_DN_FILLED_COLOR: Integer = 89;

    ZONE_LINE_COLOR: Integer = 90;
    ZONE_FILLED_COLOR: Integer = 91;
    TRACE_LINE_COLOR: Integer = 92;
    TRACE_FILLED_COLOR: Integer = 93;

    UNIT_LINE_COLOR: Integer = 94;
    UNIT_FILLED_COLOR: Integer = 95;
    UNIT_TEXT_COLOR: Integer = 96;

    TRACE_XY_LINE_COLOR: Integer = 97;
    TRACE_XY_FILLED_COLOR: Integer = 98;
    TRACE_XY_TEXT_COLOR: Integer = 99;

    TRACE_VALUE_LINE_COLOR: Integer = 100;
    TRACE_VALUE_FILLED_COLOR: Integer = 101;
    TRACE_VALUE_TEXT_COLOR: Integer = 102;

    CAPTION_BACKGROUND_COLOR: Integer = 110;
    CAPTION_FIELDNAME_TEXT_COLOR: Integer = 111;
    CAPTION_FIELDVALUE_TEXT_COLOR: Integer = 112;

    CHART_BACKGROUND_COLOR: Integer = 113;
    SELECTED_CHART_BACKGROUND_COLOR: Integer = 114;
    OVERED_CHART_BACKGROUND_COLOR: Integer = 115;

    XTICK_LABEL_COLOR: Integer = 117;
    YTICK_LABEL_COLOR: Integer = 118;
    CHART_COLOR: Integer = 119;
    SELECTED_CHART_COLOR: Integer = 120;
    OVERED_CHART_COLOR: Integer = 121;

    MAEMUOVERLAY_TEXT_COLOR: Integer = 140;

    IND_LINE1_COLOR: Integer = 45;
    IND_LINE2_COLOR: Integer = 46;
    IND_LINE3_COLOR: Integer = 47;
    IND_LINE4_COLOR: Integer = 48;
    IND_LINE5_COLOR: Integer = 49;

    DRAW_OBJECT_DEFAULT_COLOR: Integer = 4;

    OPS_LINE_OPS: Integer = 160;
    OPS_LINE_IGUK: Integer = 161;
    OPS_LINE_IGUK2: Integer = 162;
    OPS_LINE_STDDEV: Integer = 163;
    OPS_LINE_REL: Integer = 164;

    ALPHA_LINE: Integer = 0;
    ALPHA_PRICE_LINE: Integer = 1;
    ALPHA_VOLUME_LINE: Integer = 2;
    ALPHA_MA_LINE: Integer = 3;
    ALPHA_COMPARE_LINE: Integer = 4;
    ALPHA_DARK_LINE: Integer = 5;
    ALPHA_LIGHT_LINE: Integer = 6;
    ALPHA_PAXSTYLE_LINE: Integer = 10;
    ALPHA_OSC_LINE: Integer = 12;
    ALPHA_BTN_LINE: Integer = 14;
    ALPHA_BTN_FILLED: Integer = 16;
    ALPHA_MAX_LINE: Integer = 18;
    ALPHA_MAX_ARROW: Integer = 19;
    ALPHA_MIN_LINE: Integer = 20;
    ALPHA_MIN_ARROW: Integer = 21;
    ALPHA_IMCLOUDE_UP_FILLED: Integer = 22;
    ALPHA_IMCLOUDE_DN_FILLED: Integer = 23;
    ALPHA_BAND_FILLED: Integer = 24;

  public
    m_ColorSetIndex: Integer;
    m_Color: Array of Integer;
    m_Alpha: Array of Integer;

    constructor Create;
    destructor Destroy; override;

    procedure Initialize;
    procedure SetColorSetIndex(p_Value: Integer);

  end;

implementation

uses
  FNGlobal, FNMatrixConst;

// ---------------------------------------------------------------------------
constructor CFNMatrixColorSet.Create;
begin
  inherited Create;

  Initialize;
end;

// ---------------------------------------------------------------------------
destructor CFNMatrixColorSet.Destroy;
begin

  inherited Destroy;
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixColorSet.Initialize;
var
  nIndex: Integer;
begin
  m_ColorSetIndex := 1;
  SetLength(m_Color, 512);
  SetLength(m_Alpha, 512);

  for nIndex := 0 to 512 - 1 do
  begin
    m_Color[nIndex] := $00FFFFFF;
    m_Color[nIndex] := 0;
  end;
  SetColorSetIndex(1);
end;

// ---------------------------------------------------------------------------
procedure CFNMatrixColorSet.SetColorSetIndex(p_Value: Integer);
begin
  if (p_Value = CFNMatrixConst.COLOR_SET_BLACK) then
  begin
    m_Color[0] := $00F08080;
    m_Color[1] := $008080F0;
    m_Color[2] := $0080F080;
    m_Color[3] := $00F0F080;
    m_Color[4] := $0080F0F0;
    m_Color[5] := $00F080F0;
    m_Color[6] := $00F0F0F0;
    m_Color[7] := $00F09030;
    m_Color[8] := $0030F090;
    m_Color[9] := $009030F0;
    m_Color[10] := $00F03090;
    m_Color[11] := $0090F030;
    m_Color[12] := $003090F0;
    m_Color[13] := $00909090;
    m_Color[14] := $00F06000;
    m_Color[15] := $0000F060;
    m_Color[16] := $006000F0;
    m_Color[17] := $00F00060;
    m_Color[18] := $0060F000;
    m_Color[19] := $000060F0;
    m_Color[20] := $00606060;
    m_Color[21] := $00906000;
    m_Color[22] := $00009060;
    m_Color[23] := $00600090;
    m_Color[24] := $00900060;
    m_Color[25] := $00609000;
    m_Color[26] := $00006090;
    m_Color[27] := $00303030;
    m_Color[28] := $00FFFFFF;
    m_Color[29] := $00FFFFF0;

    m_Color[30] := $003030E0;
    m_Color[31] := $00A0A030;
    m_Color[32] := $0080A0A0;
    m_Color[33] := $00A06000;
    m_Color[34] := $00A0A0A0;
    m_Color[35] := $003A9EDA;
    m_Color[36] := $00A0A0A0;
    m_Color[37] := $00D662DD;
    m_Color[38] := $00F37753;
    m_Color[39] := $008F96A8;
    m_Color[40] := $00A0A0A0;
    m_Color[41] := $00101010;
    m_Color[42] := $00909090;
    m_Color[43] := $00808080;
    m_Color[44] := $00707070;

    m_Color[45] := $00999999;
    m_Color[46] := $00409940;

    // main chart
    m_Color[200] := $009D4ED4;
    m_Color[201] := $00CFABE8;
    m_Color[202] := $0067C032;
    m_Color[203] := $00B5DE9C;
    m_Color[204] := $00E8802C;
    m_Color[205] := $00F1C098;

    m_Color[FRAME_COLOR] := $00404040;
    m_Color[BACKGROUND_COLOR] := $00000000;
    m_Color[TEXT_COLOR] := $00E0E0E0;
    m_Color[AXIS_COLOR] := $00404040;
    m_Color[GRID_COLOR] := $00181818;
    m_Color[CHART_BACKGROUND_COLOR] := $00000000;

    m_Color[PRICE_COLOR] := $00C0C0C0;

    m_Color[PRICE_MAX_COLOR] := $00B4162C;
    m_Color[PRICE_MIN_COLOR] := $00175BA9;

    // m_Color[PRICE_UP_FILLED_COLOR        	] := $00D06060;
    // m_Color[PRICE_UP_LINE_COLOR           ] := $00F06060;
    // m_Color[PRICE_DN_FILLED_COLOR        	] := $006060D0;
    // m_Color[PRICE_DN_LINE_COLOR           ] := $006060F0;
    m_Color[PRICE_UP_FILLED_COLOR] := $00C03030;
    m_Color[PRICE_UP_LINE_COLOR] := $00FF6060;
    m_Color[PRICE_DN_FILLED_COLOR] := $00309030;
    m_Color[PRICE_DN_LINE_COLOR] := $0060AD60;

    m_Color[VOLUME_FILLED_COLOR] := $0053626F;
    m_Color[VOLUME_LINE_COLOR] := $0073828F;

    m_Color[OSC_UP_FILLED_COLOR] := $009B293C;
    m_Color[OSC_UP_LINE_COLOR] := $00C37D7D;
    m_Color[OSC_DN_FILLED_COLOR] := $003C9B29;
    m_Color[OSC_DN_LINE_COLOR] := $007DC37D;

    m_Color[EXIT_BTN_FILLED_COLOR] := $00404040;
    m_Color[EXIT_BTN_LINE_COLOR] := $00A0A0A0;

    m_Color[PAXSTYLE_UP_LINE] := $00FFAAAA;
    m_Color[PAXSTYLE_EQ_LINE] := $00AAFFAA;
    m_Color[PAXSTYLE_DN_LINE] := $00AAAAFF;

    m_Color[TEXT_UP_LINE] := $00FF8080;
    m_Color[TEXT_EQ_LINE] := $00A0A0A0;
    m_Color[TEXT_DN_LINE] := $0080FF80;

    m_Color[IMCLOUDE_UP_FILLED_COLOR] := $00408080;
    m_Color[IMCLOUDE_DN_FILLED_COLOR] := $00808040;

    m_Color[ZONE_LINE_COLOR] := $00FFFFFF;
    m_Color[ZONE_FILLED_COLOR] := $00308030;

    m_Color[TRACE_LINE_COLOR] := $00909090;
    m_Color[TRACE_FILLED_COLOR] := $00909090;

    m_Color[UNIT_LINE_COLOR] := $00404040;
    m_Color[UNIT_FILLED_COLOR] := $00101010;
    m_Color[UNIT_TEXT_COLOR] := $00808080;

    m_Color[TRACE_XY_LINE_COLOR] := $00707070;
    m_Color[TRACE_XY_FILLED_COLOR] := $00505040;
    m_Color[TRACE_XY_TEXT_COLOR] := $00E0E0E0;

    m_Color[TRACE_VALUE_LINE_COLOR] := $00707070;
    m_Color[TRACE_VALUE_FILLED_COLOR] := $00505040;
    m_Color[TRACE_VALUE_TEXT_COLOR] := $00E0E0E0;

    m_Color[CAPTION_BACKGROUND_COLOR] := $00BABABA;
    m_Color[CAPTION_FIELDNAME_TEXT_COLOR] := $00E6E6E6;
    m_Color[CAPTION_FIELDVALUE_TEXT_COLOR] := $00E6E6E6;

    m_Color[XTICK_LABEL_COLOR] := $00E6E6E6;
    m_Color[YTICK_LABEL_COLOR] := $00E6E6E6;
    m_Color[CHART_COLOR] := $00000000;

    m_Color[MAEMUOVERLAY_TEXT_COLOR] := $00777777;

    // 추세선 라인 색상
    m_Color[DRAW_OBJECT_DEFAULT_COLOR] := $00557095;

    m_Alpha[ALPHA_LINE] := TFNGlobal.GetAlphaValue(80);
    m_Alpha[ALPHA_PRICE_LINE] := TFNGlobal.GetAlphaValue(80);
    m_Alpha[ALPHA_VOLUME_LINE] := TFNGlobal.GetAlphaValue(80);
    m_Alpha[ALPHA_MA_LINE] := TFNGlobal.GetAlphaValue(80);
    m_Alpha[ALPHA_COMPARE_LINE] := TFNGlobal.GetAlphaValue(80);
    m_Alpha[ALPHA_LINE] := TFNGlobal.GetAlphaValue(80);
    m_Alpha[ALPHA_DARK_LINE] := TFNGlobal.GetAlphaValue(100);
    m_Alpha[ALPHA_LIGHT_LINE] := TFNGlobal.GetAlphaValue(30);
    m_Alpha[ALPHA_PAXSTYLE_LINE] := TFNGlobal.GetAlphaValue(100);
    m_Alpha[ALPHA_OSC_LINE] := TFNGlobal.GetAlphaValue(80);

    m_Alpha[ALPHA_MAX_LINE] := TFNGlobal.GetAlphaValue(20);
    m_Alpha[ALPHA_MAX_ARROW] := TFNGlobal.GetAlphaValue(100);
    m_Alpha[ALPHA_MIN_LINE] := TFNGlobal.GetAlphaValue(20);
    m_Alpha[ALPHA_MIN_ARROW] := TFNGlobal.GetAlphaValue(100);

    m_Alpha[ALPHA_IMCLOUDE_UP_FILLED] := TFNGlobal.GetAlphaValue(30);
    m_Alpha[ALPHA_IMCLOUDE_DN_FILLED] := TFNGlobal.GetAlphaValue(30);
    m_Alpha[ALPHA_BAND_FILLED] := TFNGlobal.GetAlphaValue(05);

  end
  else if (p_Value = CFNMatrixConst.COLOR_SET_WHITE) then
  begin
    m_Color[0] := $00C18A60;
    m_Color[1] := $00DA568B;
    m_Color[2] := $00AF7F08;
    m_Color[3] := $00609144;
    m_Color[4] := $004B67D0;
    m_Color[5] := $008D4A9A;
    m_Color[6] := $00C484A7;
    m_Color[7] := $00A684C1;
    m_Color[8] := $0076B5E8;
    m_Color[9] := $009030C0;

    m_Color[10] := $009793FF;
    m_Color[11] := $00F29943;
    m_Color[12] := $003090C0;
    m_Color[13] := $00909090;
    m_Color[14] := $00C06000;
    m_Color[15] := $0000C060;
    m_Color[16] := $006000C0;
    m_Color[17] := $00C00060;
    m_Color[18] := $0060C000;
    m_Color[19] := $000060C0;
    m_Color[20] := $00606060;
    m_Color[21] := $00906000;
    m_Color[22] := $00009060;
    m_Color[23] := $00600090;
    m_Color[24] := $00900060;
    m_Color[25] := $00609000;
    m_Color[26] := $00006090;
    m_Color[27] := $00303030;
    m_Color[28] := $00000000;
    m_Color[29] := $00000000;

    m_Color[30] := $0054A21B;
    m_Color[31] := $00D90200;
    m_Color[32] := $00005FDF;
    m_Color[33] := $00D66A00;
    m_Color[34] := $00000000;
    m_Color[35] := $003A9EDA;
    m_Color[36] := $00000000;
    m_Color[37] := $00D662DD;
    m_Color[38] := $00F37753;
    m_Color[39] := $008F96A8;
    m_Color[40] := $00A0A0A0;
    m_Color[41] := $00101010;
    m_Color[42] := $00909090;
    m_Color[43] := $00808080;
    m_Color[44] := $00707070;

    m_Color[45] := $00666666;
    m_Color[46] := $00005FDF;
    m_Color[47] := $0054A21B;
    m_Color[48] := $00FF0000;
    m_Color[49] := $000000FF;
    m_Color[50] := $0067C032;

    // main chart
    m_Color[200] := $009D4ED4;
    m_Color[201] := $00CFABE8;
    m_Color[202] := $0067C032;
    m_Color[203] := $00B5DE9C;
    m_Color[204] := $00E8802C;
    m_Color[205] := $00F1C098;

    m_Color[FRAME_COLOR] := $00CCCCCC;
    m_Color[BACKGROUND_COLOR] := $00FFFFFF;
    m_Color[TEXT_COLOR] := $00000000;
    m_Color[AXIS_COLOR] := $00AAAAAA;
    m_Color[GRID_COLOR] := $00DDDDDD;

    m_Color[CHART_COLOR] := $00FFFFFF;
    m_Color[OVERED_CHART_COLOR] := $00FAFAFA;
    m_Color[SELECTED_CHART_COLOR] := $00FAFAFA;

    m_Color[CHART_BACKGROUND_COLOR] := $00F6F6F6;
    m_Color[OVERED_CHART_BACKGROUND_COLOR] := $00E6E6E6;
    m_Color[SELECTED_CHART_BACKGROUND_COLOR] := $00E0E0E0;

    m_Color[PRICE_COLOR] := $00101010;

    m_Color[PRICE_MAX_COLOR] := $00D80200;
    m_Color[PRICE_MIN_COLOR] := $00000FB3;

    m_Color[PRICE_UP_FILLED_COLOR] := $00FF4208;
    m_Color[PRICE_UP_LINE_COLOR] := $00DA0300;
    m_Color[PRICE_DN_FILLED_COLOR] := $0001A7F3;
    m_Color[PRICE_DN_LINE_COLOR] := $00005DDF;

    m_Color[VOLUME_FILLED_COLOR] := $0041C41C;
    m_Color[VOLUME_LINE_COLOR] := $0041C41C;

    m_Color[OSC_UP_FILLED_COLOR] := $00DB774C;
    m_Color[OSC_UP_LINE_COLOR] := $00DB774C;
    m_Color[OSC_DN_FILLED_COLOR] := $004BB1DB;
    m_Color[OSC_DN_LINE_COLOR] := $004BB1DB;

    m_Color[EXIT_BTN_FILLED_COLOR] := $00F8F6F4;
    m_Color[EXIT_BTN_LINE_COLOR] := $00B8B3A0;

    m_Color[PAXSTYLE_UP_LINE] := $00F00000;
    m_Color[PAXSTYLE_EQ_LINE] := $0000F000;
    m_Color[PAXSTYLE_DN_LINE] := $000000F0;

    m_Color[TEXT_UP_LINE] := $00CF0000;
    m_Color[TEXT_EQ_LINE] := $00676B92;
    m_Color[TEXT_DN_LINE] := $002147C5;

    m_Color[IMCLOUDE_UP_FILLED_COLOR] := $0066FF99;
    m_Color[IMCLOUDE_DN_FILLED_COLOR] := $00FF3300;

    m_Color[ZONE_LINE_COLOR] := $00000000;
    m_Color[ZONE_FILLED_COLOR] := $0066FF66;

    m_Color[TRACE_LINE_COLOR] := $00909090;
    m_Color[TRACE_FILLED_COLOR] := $00909090;

    m_Color[UNIT_LINE_COLOR] := $00E0E0D0;
    m_Color[UNIT_FILLED_COLOR] := $00EEEEDD;
    m_Color[UNIT_TEXT_COLOR] := $00000000;

    m_Color[TRACE_XY_LINE_COLOR] := $00A0A080;
    m_Color[TRACE_XY_FILLED_COLOR] := $00F0F066;
    m_Color[TRACE_XY_TEXT_COLOR] := $00000000;

    m_Color[TRACE_VALUE_LINE_COLOR] := $00B7B9D3;
    m_Color[TRACE_VALUE_FILLED_COLOR] := $00E6E9FC;
    m_Color[TRACE_VALUE_TEXT_COLOR] := $00000000;

    m_Color[CAPTION_BACKGROUND_COLOR] := $00E6E6E6;
    m_Color[CAPTION_FIELDNAME_TEXT_COLOR] := $00202020;
    m_Color[CAPTION_FIELDVALUE_TEXT_COLOR] := $00202020;

    m_Color[XTICK_LABEL_COLOR] := $00000000;
    m_Color[YTICK_LABEL_COLOR] := $00000000;

    m_Color[MAEMUOVERLAY_TEXT_COLOR] := $00999999;

    // 추세선 라인 색상
    m_Color[DRAW_OBJECT_DEFAULT_COLOR] := $00336633;

    m_Color[OPS_LINE_OPS] := $00008000;
    m_Color[OPS_LINE_IGUK] := $00AA0000;
    m_Color[OPS_LINE_IGUK2] := $00CC0A85;
    m_Color[OPS_LINE_STDDEV] := $0000AAAA;
    m_Color[OPS_LINE_REL] := $00404040;

    m_Alpha[ALPHA_LINE] := TFNGlobal.GetAlphaValue(85);
    m_Alpha[ALPHA_PRICE_LINE] := TFNGlobal.GetAlphaValue(85);
    m_Alpha[ALPHA_VOLUME_LINE] := TFNGlobal.GetAlphaValue(85);
    m_Alpha[ALPHA_MA_LINE] := TFNGlobal.GetAlphaValue(85);
    m_Alpha[ALPHA_COMPARE_LINE] := TFNGlobal.GetAlphaValue(85);
    m_Alpha[ALPHA_LINE] := TFNGlobal.GetAlphaValue(85);
    m_Alpha[ALPHA_DARK_LINE] := TFNGlobal.GetAlphaValue(90);
    m_Alpha[ALPHA_LIGHT_LINE] := TFNGlobal.GetAlphaValue(60);
    m_Alpha[ALPHA_PAXSTYLE_LINE] := TFNGlobal.GetAlphaValue(100);
    m_Alpha[ALPHA_OSC_LINE] := TFNGlobal.GetAlphaValue(85);

    m_Alpha[ALPHA_MAX_LINE] := TFNGlobal.GetAlphaValue(20);
    m_Alpha[ALPHA_MAX_ARROW] := TFNGlobal.GetAlphaValue(100);
    m_Alpha[ALPHA_MIN_LINE] := TFNGlobal.GetAlphaValue(20);
    m_Alpha[ALPHA_MIN_ARROW] := TFNGlobal.GetAlphaValue(100);

    m_Alpha[ALPHA_IMCLOUDE_UP_FILLED] := TFNGlobal.GetAlphaValue(20);
    m_Alpha[ALPHA_IMCLOUDE_DN_FILLED] := TFNGlobal.GetAlphaValue(20);
    m_Alpha[ALPHA_BAND_FILLED] := TFNGlobal.GetAlphaValue(5);

  end;
end;

end.
