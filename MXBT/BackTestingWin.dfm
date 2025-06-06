object MDIBackTesting: TMDIBackTesting
  Left = 0
  Top = 0
  Caption = 'MDIBackTesting'
  ClientHeight = 612
  ClientWidth = 987
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #44404#47548
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 987
    Height = 612
    ActivePage = TabSheet6
    Align = alClient
    TabHeight = 22
    TabOrder = 0
    TabWidth = 120
    object TabSheet6: TTabSheet
      Caption = #49444#51221
      ImageIndex = 3
      object Panel36: TPanel
        Left = 0
        Top = 0
        Width = 979
        Height = 580
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        OnClick = Panel36Click
        inline MatrixOptionFrame1: TMatrixOptionFrame
          Left = 0
          Top = 0
          Width = 979
          Height = 580
          Margins.Bottom = 10
          Align = alClient
          Color = clBtnFace
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #44404#47548
          Font.Style = []
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          ExplicitWidth = 979
          ExplicitHeight = 580
          inherited PageControl1: TPageControl
            Width = 979
            Height = 580
            ExplicitWidth = 979
            ExplicitHeight = 580
            inherited TabSheet1: TTabSheet
              ExplicitLeft = 4
              ExplicitTop = 32
              ExplicitWidth = 971
              ExplicitHeight = 544
              inherited Panel1: TPanel
                Width = 971
                Height = 544
                ExplicitWidth = 971
                ExplicitHeight = 544
                inherited Panel8: TPanel
                  Width = 957
                  Height = 530
                  ExplicitWidth = 957
                  ExplicitHeight = 530
                  inherited Panel9: TPanel
                    Width = 957
                    ExplicitWidth = 957
                  end
                  inherited Panel11: TPanel
                    Width = 957
                    Height = 499
                    ExplicitWidth = 957
                    ExplicitHeight = 499
                    inherited PageControlStrategyConfig: TPageControl
                      Width = 957
                      Height = 499
                      ExplicitWidth = 957
                      ExplicitHeight = 499
                      inherited TabSheetConfig: TTabSheet
                        ExplicitLeft = 4
                        ExplicitTop = 30
                        ExplicitWidth = 949
                        ExplicitHeight = 465
                        inherited Panel6: TPanel
                          Width = 949
                          Height = 465
                          ExplicitWidth = 949
                          ExplicitHeight = 465
                          inherited Panel12: TPanel
                            Width = 935
                            Height = 451
                            ExplicitWidth = 935
                            ExplicitHeight = 451
                            inherited PageControl3: TPageControl
                              Width = 935
                              Height = 451
                              ExplicitWidth = 935
                              ExplicitHeight = 451
                              inherited TabSheet13: TTabSheet
                                ExplicitLeft = 4
                                ExplicitTop = 30
                                ExplicitWidth = 927
                                ExplicitHeight = 417
                                inherited PageControlStrategy: TPageControl
                                  Width = 927
                                  Height = 417
                                  ExplicitWidth = 927
                                  ExplicitHeight = 417
                                  inherited TabSheetX000: TTabSheet
                                    ExplicitWidth = 919
                                    ExplicitHeight = 392
                                    inherited STC_T1_Frame1: TSTC_T1_Frame
                                      Width = 919
                                      Height = 392
                                      ExplicitWidth = 919
                                      ExplicitHeight = 392
                                      inherited Panel1: TPanel
                                        Width = 919
                                        Height = 392
                                        ExplicitWidth = 919
                                        ExplicitHeight = 392
                                        inherited Panel2: TPanel
                                          Width = 915
                                          ExplicitWidth = 915
                                        end
                                        inherited Panel3: TPanel
                                          Width = 915
                                          ExplicitWidth = 915
                                        end
                                        inherited GroupBoxMajorType: TGroupBox
                                          Width = 915
                                          ExplicitWidth = 915
                                        end
                                        inherited Panel4: TPanel
                                          Width = 915
                                          ExplicitWidth = 915
                                        end
                                        inherited Panel5: TPanel
                                          Width = 915
                                          ExplicitWidth = 915
                                        end
                                        inherited GroupBox2: TGroupBox
                                          Width = 915
                                          ExplicitWidth = 915
                                        end
                                        inherited Panel6: TPanel
                                          Width = 915
                                          ExplicitWidth = 915
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          Width = 915
                                          ExplicitWidth = 915
                                        end
                                        inherited GroupBox1: TGroupBox
                                          Width = 915
                                          ExplicitWidth = 915
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX010: TTabSheet
                                    inherited STC_T2_Frame1: TSTC_T2_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox1: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX020: TTabSheet
                                    inherited STC_T3_Frame1: TSTC_T3_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox1: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX030: TTabSheet
                                    inherited STC_N1_Frame1: TSTC_N1_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox1: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX040: TTabSheet
                                    inherited STC_N2_Frame1: TSTC_N2_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox1: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX050: TTabSheet
                                    inherited RSI_T1_Frame1: TRSI_T1_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox1: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX060: TTabSheet
                                    inherited RSI_N1_Frame1: TRSI_N1_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox3: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX070: TTabSheet
                                    inherited BB_T1_Frame1: TBB_T1_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox2: TGroupBox
                                          inherited ComboBoxPRICEMETHOD: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox1: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX080: TTabSheet
                                    inherited DISPARITY_T1_Frame1: TDISPARITY_T1_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX090: TTabSheet
                                    inherited DISPARITY_N1_Frame1: TDISPARITY_N1_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX100: TTabSheet
                                    inherited BASELINE_T1_Frame1: TBASELINE_T1_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBox2: TGroupBox
                                          inherited ComboBoxPRICEMETHOD: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox3: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX110: TTabSheet
                                    inherited BASELINE_T2_Frame1: TBASELINE_T2_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBox2: TGroupBox
                                          inherited ComboBoxPRICEMETHOD: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox3: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX120: TTabSheet
                                    inherited BASELINE_N1_Frame1: TBASELINE_N1_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox1: TGroupBox
                                          inherited ComboBoxPRICEMETHOD: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox3: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX130: TTabSheet
                                    inherited IM_T1_Frame1: TIM_T1_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox2: TGroupBox
                                          inherited ComboBoxVALUE_TYPE: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox3: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX140: TTabSheet
                                    inherited IM_T2_Frame1: TIM_T2_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox2: TGroupBox
                                          inherited ComboBoxVALUE_TYPE: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox3: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX150: TTabSheet
                                    inherited IM_T3_Frame1: TIM_T3_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox2: TGroupBox
                                          inherited ComboBoxVALUE_TYPE: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox3: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheet4: TTabSheet
                                    inherited MOV_T1_Frame1: TMOV_T1_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox2: TGroupBox
                                          inherited ComboBoxAVERAGE_TYPE: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox3: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheet5: TTabSheet
                                    inherited MOV_T2_Frame1: TMOV_T2_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox1: TGroupBox
                                          inherited ComboBoxAVERAGE_TYPE: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox3: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheet6: TTabSheet
                                    inherited MOV_T3_Frame1: TMOV_T3_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox2: TGroupBox
                                          inherited ComboBoxAVERAGE_TYPE: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheet7: TTabSheet
                                    inherited MOV_N1_Frame1: TMOV_N1_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox1: TGroupBox
                                          inherited ComboBoxAVERAGE_TYPE: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox3: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheet8: TTabSheet
                                    inherited MOV_N2_Frame1: TMOV_N2_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox1: TGroupBox
                                          inherited ComboBoxAVERAGE_TYPE: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBox3: TGroupBox
                                          inherited ComboBoxTOLERANCE_UNIT: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                  inherited TabSheetX160: TTabSheet
                                    inherited REL_T1_Frame1: TREL_T1_Frame
                                      inherited Panel1: TPanel
                                        inherited GroupBox2: TGroupBox
                                          inherited ComboBoxMETHOD: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxMajorType: TGroupBox
                                          inherited ComboBoxMajorType: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                        inherited GroupBoxOptionManagement: TGroupBox
                                          inherited ComboBoxOptionCollection: TComboBox
                                            ItemHeight = 0
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                              inherited TabSheet14: TTabSheet
                                inherited m_REINFORCE_Frame: TREINFORCE_Frame
                                  inherited Panel9: TPanel
                                    inherited GroupBox1: TGroupBox
                                      inherited ComboBoxRF1_STD_VALUE: TComboBox
                                        ItemHeight = 0
                                      end
                                      inherited ComboBoxRF1_PRICEMETHOD: TComboBox
                                        ItemHeight = 0
                                      end
                                      inherited ComboBoxRF1_VALUE_TYPE: TComboBox
                                        ItemHeight = 0
                                      end
                                      inherited GroupBox4: TGroupBox
                                        inherited ComboBoxRF1_TOLERANCE_UNIT: TComboBox
                                          ItemHeight = 0
                                        end
                                      end
                                    end
                                    inherited GroupBox3: TGroupBox
                                      inherited ComboBoxRF2_VALUE_TYPE: TComboBox
                                        ItemHeight = 0
                                      end
                                      inherited ComboBoxRF2_AVERAGE_TYPE: TComboBox
                                        ItemHeight = 0
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                      inherited TabSheetCFG02: TTabSheet
                        inherited Panel5: TPanel
                          inherited Panel2: TPanel
                            inherited m_Random_Frame: TRandom_Frame
                              inherited Panel9: TPanel
                                inherited GroupBoxOptionManagement: TGroupBox
                                  inherited ComboBoxOptionCollection: TComboBox
                                    ItemHeight = 0
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                      inherited TabSheetCFG03: TTabSheet
                        inherited Panel15: TPanel
                          inherited Panel13: TPanel
                            inherited m_EXIT_Frame: TExit_Frame
                              inherited Panel9: TPanel
                                inherited GroupBoxOptionManagement: TGroupBox
                                  inherited ComboBoxOptionCollection: TComboBox
                                    ItemHeight = 0
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                      inherited TabSheetCFG04: TTabSheet
                        inherited Panel16: TPanel
                          inherited Panel14: TPanel
                            inherited m_ENTER_Frame: TENTER_Frame
                              inherited Panel9: TPanel
                                inherited GroupBoxOptionManagement: TGroupBox
                                  inherited ComboBoxOptionCollection: TComboBox
                                    ItemHeight = 0
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
            inherited TabSheet2: TTabSheet
              ExplicitLeft = 4
              ExplicitTop = 32
              ExplicitWidth = 733
              ExplicitHeight = 568
              inherited Panel3: TPanel
                inherited Panel7: TPanel
                  inherited GroupBox6: TGroupBox
                    inherited ComboBoxACCOUNT_NO: TComboBox
                      ItemHeight = 0
                    end
                  end
                  inherited GroupBox9: TGroupBox
                    inherited ComboBoxTIMEFRAME: TComboBox
                      ItemHeight = 0
                    end
                  end
                  inherited GroupBox1: TGroupBox
                    inherited ComboBoxSYMBOL: TComboBox
                      ItemHeight = 0
                    end
                  end
                  inherited GroupBox2: TGroupBox
                    inherited ComboBoxORDER_TYPE: TComboBox
                      ItemHeight = 0
                    end
                  end
                end
              end
            end
            inherited TabSheet3: TTabSheet
              ExplicitLeft = 4
              ExplicitTop = 32
              ExplicitWidth = 733
              ExplicitHeight = 568
            end
            inherited TabSheet9: TTabSheet
              ExplicitLeft = 4
              ExplicitTop = 32
              ExplicitWidth = 733
              ExplicitHeight = 568
              inherited Panel4: TPanel
                inherited Panel10: TPanel
                  inherited GroupBox3: TGroupBox
                    inherited ComboBox_CP_T1: TComboBox
                      ItemHeight = 0
                    end
                    inherited ComboBox_CP_T2: TComboBox
                      ItemHeight = 0
                    end
                    inherited ComboBox_CP_T3: TComboBox
                      ItemHeight = 0
                    end
                    inherited ComboBox_CP_T4: TComboBox
                      ItemHeight = 0
                    end
                    inherited ComboBox_CP_T5: TComboBox
                      ItemHeight = 0
                    end
                  end
                end
              end
            end
          end
          inherited PanelClear: TPanel
            Top = 556
            ExplicitTop = 556
          end
        end
      end
    end
    object TabSheet8: TTabSheet
      Caption = #48177#53580#49828#54021
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel45: TPanel
        Left = 0
        Top = 0
        Width = 979
        Height = 580
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 979
          Height = 85
          Align = alTop
          BevelKind = bkFlat
          BevelOuter = bvNone
          TabOrder = 0
          object Label1: TLabel
            Left = 20
            Top = 18
            Width = 64
            Height = 12
            Caption = #49884#51089' '#51068#51088' : '
          end
          object Label2: TLabel
            Left = 21
            Top = 54
            Width = 64
            Height = 12
            Caption = #47560#44048' '#51068#51088' : '
          end
          object DateTimePickerStartDate: TDateTimePicker
            Left = 88
            Top = 13
            Width = 100
            Height = 20
            Date = 41114.430841481480000000
            Time = 41114.430841481480000000
            ImeName = 'Microsoft Office IME 2007'
            TabOrder = 0
          end
          object DateTimePickerEndDate: TDateTimePicker
            Left = 88
            Top = 49
            Width = 100
            Height = 20
            Date = 41114.430841481480000000
            Time = 41114.430841481480000000
            ImeName = 'Microsoft Office IME 2007'
            TabOrder = 1
          end
          object ButtonToday: TButton
            Left = 198
            Top = 10
            Width = 70
            Height = 25
            Caption = #44552#51068
            TabOrder = 2
            OnClick = ButtonTodayClick
          end
          object Button1Week: TButton
            Left = 272
            Top = 10
            Width = 70
            Height = 25
            Caption = #52572#44540' 1'#51452#51068
            TabOrder = 3
            OnClick = Button1WeekClick
          end
          object Button1Month: TButton
            Left = 346
            Top = 10
            Width = 70
            Height = 25
            Caption = #52572#44540' 1'#44060#50900
            TabOrder = 4
            OnClick = Button1MonthClick
          end
          object Button3Month: TButton
            Left = 420
            Top = 10
            Width = 70
            Height = 25
            Caption = #52572#44540' 3'#44060#50900
            TabOrder = 5
            OnClick = Button3MonthClick
          end
          object Button6Month: TButton
            Left = 494
            Top = 10
            Width = 70
            Height = 25
            Caption = #52572#44540' 6'#44060#50900
            TabOrder = 6
            OnClick = Button6MonthClick
          end
          object Button1Year: TButton
            Left = 568
            Top = 10
            Width = 70
            Height = 25
            Caption = #52572#44540' 1'#45380
            TabOrder = 7
            OnClick = Button1YearClick
          end
          object Button2Year: TButton
            Left = 644
            Top = 10
            Width = 70
            Height = 25
            Caption = #52572#44540' 2'#45380
            TabOrder = 8
            OnClick = Button2YearClick
          end
          object BitBtn1: TBitBtn
            Left = 198
            Top = 46
            Width = 147
            Height = 25
            Action = Action_0001
            Caption = #48177#53580#49828#54021' '#49884#51089
            DoubleBuffered = True
            ParentDoubleBuffered = False
            TabOrder = 9
          end
          object BitBtn2: TBitBtn
            Left = 356
            Top = 46
            Width = 147
            Height = 25
            Action = Action_0002
            Caption = #48177#53580#49828#54021' '#51333#47308
            DoubleBuffered = True
            ParentDoubleBuffered = False
            TabOrder = 10
          end
          object Button1: TButton
            Left = 723
            Top = 10
            Width = 120
            Height = 25
            Caption = 'DailyReport'
            TabOrder = 11
            OnClick = Button1Click
          end
          object Button2: TButton
            Left = 849
            Top = 10
            Width = 120
            Height = 25
            Caption = 'TradeList'
            TabOrder = 12
            OnClick = Button2Click
          end
        end
        object Panel3: TPanel
          Left = 0
          Top = 85
          Width = 979
          Height = 495
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object Splitter1: TSplitter
            Left = 576
            Top = 0
            Height = 495
            Align = alRight
            ExplicitLeft = 472
            ExplicitHeight = 505
          end
          object Panel2: TPanel
            Left = 579
            Top = 0
            Width = 400
            Height = 495
            Align = alRight
            BevelEdges = [beRight, beBottom]
            BevelKind = bkFlat
            BevelOuter = bvNone
            TabOrder = 0
            object ListViewLog: TListView
              Left = 0
              Top = 0
              Width = 398
              Height = 493
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              Columns = <
                item
                  Caption = #48156#49373#49884#44036
                  Width = 60
                end
                item
                  Caption = #50976#54805
                  Width = 60
                end
                item
                  Caption = #47700#49464#51648
                  Width = 400
                end>
              ColumnClick = False
              DoubleBuffered = True
              GridLines = True
              OwnerData = True
              ReadOnly = True
              RowSelect = True
              ParentDoubleBuffered = False
              TabOrder = 0
              ViewStyle = vsReport
              OnData = ListViewLogData
            end
          end
          object Panel4: TPanel
            Left = 0
            Top = 0
            Width = 576
            Height = 495
            Align = alClient
            BevelEdges = [beLeft, beRight, beBottom]
            BevelKind = bkFlat
            BevelOuter = bvNone
            TabOrder = 1
            object ListViewDailyPM: TListView
              Left = 0
              Top = 0
              Width = 572
              Height = 493
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              Columns = <
                item
                  Caption = #45216#51676
                  Width = 80
                end
                item
                  Alignment = taRightJustify
                  Caption = #51204#52404#44144#47000
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = #45572#51201
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = #47588#49688#44144#47000
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = #45572#51201
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = #47588#46020#44144#47000
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = #45572#51201
                  Width = 60
                end
                item
                  Alignment = taRightJustify
                  Caption = #44144#47000#49688
                end
                item
                  Alignment = taRightJustify
                  Caption = #47588#49688
                end
                item
                  Alignment = taRightJustify
                  Caption = #47588#46020
                end
                item
                  Alignment = taRightJustify
                  Caption = #44032#44201
                  Width = 68
                end>
              ColumnClick = False
              DoubleBuffered = True
              GridLines = True
              OwnerData = True
              ReadOnly = True
              RowSelect = True
              ParentDoubleBuffered = False
              TabOrder = 0
              ViewStyle = vsReport
              OnCustomDrawItem = ListViewDailyPMCustomDrawItem
              OnCustomDrawSubItem = ListViewDailyPMCustomDrawSubItem
              OnData = ListViewDailyPMData
            end
          end
        end
      end
    end
  end
  object ActionList1: TActionList
    Images = ImageListNormal
    Left = 840
    Top = 40
    object Action_0001: TAction
      Category = 'Action_0000'
      Caption = #48177#53580#49828#54021' '#49884#51089
      ImageIndex = 37
      OnExecute = Action_0001Execute
      OnUpdate = Action_0001Update
    end
    object Action_0002: TAction
      Category = 'Action_0000'
      Caption = #48177#53580#49828#54021' '#51333#47308
      ImageIndex = 38
      OnExecute = Action_0002Execute
      OnUpdate = Action_0002Update
    end
  end
  object ImageListNormal: TImageList
    Left = 916
    Top = 44
    Bitmap = {
      494C010127002900380010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000A0000000010020000000000000A0
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A49E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A49E00000000000000000000000000B3827B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000D9739000D973900AECBAB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C92
      8E003F3F3F003F3F3F003F3F3F003F3F3F003F3F3F003F3F3F003F3F3F003F3F
      3F009C928E000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A49E00000000000000000000000000B3827B00B3827B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000BAD3F0071DC83000D973900ADCAAA0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003F3F
      3F004545450056565600595959005C5C5C006060600063636300686868006767
      67003F3F3F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A49F00000000000000000000000000B3827B00DCC4C000B382
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000000BAD3F003BC54E0071DC83000D973900ACC9A900000000000000
      0000000000000000000000000000000000000000000000000000000000003F3F
      3F00454545004646460047474700494949004B4B4B004E4E4E00515151006767
      67003F3F3F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A49F00000000000000000000000000B3837B00EBDCD900EBDC
      D900B3837B00B3837B00B3837B00000000000000000000000000000000000000
      0000000000000CAE40003FCD54003BC64D0078DD8A0007933500ACC9A8000000
      0000000000000000000000000000000000000000000000000000000000003F3F
      3F0045454500454545004646460047474700494949004B4B4B004E4E4E006262
      62003F3F3F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A59F00000000000000000000000000B3837C00F2E7E500F2E7
      E500F2E7E500B3837C0000000000000000000000000000000000000000000000
      0000000000000BAD3F0046D55C0040CC54003BC64E0078DD8A000D973900C7D2
      BB00000000000000000000000000000000000000000000000000000000003F3F
      3F004747470045454500454545004646460047474700484848004B4B4B005C5C
      5C003F3F3F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A59F00000000000000000000000000B3837C00FBF5F400FDF9
      F900B3837C000000000000000000000000000000000000000000000000000000
      0000000000000CAE40004BDC640045D55C0040CC54003BC64D0025AA4F00C6D1
      BA00000000000000000000000000000000000000000000000000000000003F3F
      3F004C4C4C004949490046464600454545004545450047474700484848005757
      57003F3F3F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A59F00000000000000000000000000B3837C00FFFBFB00B383
      7C00000000000000000000000000000000000000000000000000000000000000
      0000000000000CAE400051E36A004BDC640046D45C0023A34C00C5D0B9000000
      0000000000000000000000000000000000000000000000000000000000003F3F
      3F00515151004D4D4D004A4A4A00474747004646460046464600464646005353
      53003F3F3F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A59F00000000000000000000000000B3847C00B3847C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001CAB4A0054E86F0051E36A0023A34C00C5CFB900000000000000
      0000000000000000000000000000000000000000000000000000000000003F3F
      3F0056565600525252004D4D4D004A4A4A004848480047474700464646005050
      50003F3F3F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C8A5A000C8A5A000C8A5
      A000C8A5A000C8A5A000C8A5A000C8A5A000C8A5A000B3847D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001CAB4A0054E86F001CAB4A00C5CFB90000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003F3F
      3F005959590057575700525252004E4E4E004A4A4A0048484800474747004646
      46003F3F3F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A5A00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001CAB4A001CAB4A00C5CEB8000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000988D
      89003F3F3F003F3F3F003F3F3F003F3F3F003F3F3F003F3F3F003F3F3F003F3F
      3F00988D89000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8A5A00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005199FF002981FF00217D
      FF0063A3FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000065A7FF0061A4FF0097C2FF0094C0
      FF005198FF0065A3FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DEDE
      DF00CBD2D8000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DEDE
      DF00CBD2D8000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DEDE
      DF00CBD2D8000000000000000000000000004995FF00A0C7FF0083B7FF007FB4
      FF0097C2FF005399FF0067A4FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DCDDDE005A8B
      B10022679D00729AB70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DCDDDE005A8B
      B10022679D00729AB70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DCDDDE005A8B
      B10022679D00729AB7000000000000000000539DFF00A4CBFF008BBCFF0077B0
      FF0080B5FF0098C3FF00569CFF006BA7FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DCDDDF006592B800558D
      BC0089B5DD00185F970000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DCDDDF006592B800558D
      BC0089B5DD00185F970000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DCDDDF006592B800558D
      BC0089B5DD00185F97000000000000000000A1CAFF0079B3FF00A5CCFF008DBD
      FF0079B2FF0083B6FF0099C3FF00589CFF006CA9FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDEDF00719AC0006497C5009DC1
      E4006699C7002E6FA20000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDEDF00719AC0006497C5009DC1
      E4006699C7002E6FA20000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCDEDF00719AC0006497C5009DC1
      E4006699C7002E6FA200000000000000000000000000A3CBFF007BB4FF00A6CC
      FF008EBEFF007CB3FF0085B8FF009BC5FF00599EFF0070ABFF00000000000000
      0000000000000000000000000000000000000000000000000000E0E0DF00DCC2
      AD00D7AF8F00D3A58000D0A17C00CFA38100AA9D950075A2CC00ABCBE80076A4
      CE003E79AC00C4CED70000000000000000000000000000000000E0E0DF00DCC2
      AD00D7AF8F00D3A58000D0A17C00CFA38100AA9D950075A2CC00ABCBE80076A4
      CE003E79AC00C4CED70000000000000000000000000000000000E0E0DF00DCC2
      AD00D7AF8F00D3A58000D0A17C00CFA38100AA9D950075A2CC00ABCBE80076A4
      CE003E79AC00C4CED70000000000000000000000000000000000A5CBFF007CB6
      FF00A8CEFF0090BFFF008BBDFF00A0C8FF0061A4FF0061A0FB00000000000000
      00000000000000000000000000000000000000000000E0E0DF00E1C2A800E8C9
      AE00F5E1CD00F7E5D300F7E5D100F3DDC800DFBA9C003D7F3E002C7331002B6F
      3B00C6D0D90000000000000000000000000000000000E0E0DF00E1C2A800E8C9
      AE00F5E1CD00F7E5D300F7E5D100F3DDC800DFBA9C00C7A8910086AED5004D85
      B800C6D0D90000000000000000000000000000000000E0E0DF00E1C2A800E8C9
      AE00F5E1CD00F7E5D300F7E5D100F3DDC800DFBA9C00C7A8910086AED5004D85
      B800C6D0D900000000000000000000000000000000000000000000000000A7CD
      FF007EB7FF00A9CEFF00A8CDFF0070ACFF005F9AEE008C8C8C00000000000000
      00000000000000000000000000000000000000000000E5CFBB00EDD0B700F8E8
      D900F5DEC800F3D8BD00F3D6BB00F4DBC200F7E4D2003986400054A970002E75
      33000000000000000000000000000000000000000000E5CFBB00EDD0B700F8E8
      D900F5DEC800F3D8BD00F3D6BB00F4DBC200F7E4D200DFBB9D009F969400C9D2
      DA000000000000000000000000000000000000000000E5CFBB00EDD0B700F8E8
      D900F5DEC800F3D8BD00F3D6BB00F4DBC200F7E4D200DFBB9D009F969400C9D2
      DA00000000000000000000000000000000000000000000000000000000000000
      0000A7CEFF0081B7FF007CB4FF006FA7F200D2D2D200B5B5B500898989008989
      89008787870097979700C8C8C8000000000000000000EBCBAE00F7E7D700F6E1
      CC00F4DBC200F4DAC000F3D8BD0061A86200489A500051A0620060B27E004493
      53002F78350030743500000000000000000000000000EBCBAE00F7E7D700F6E1
      CC00F4DBC200F4DAC000F3D8BD007371F3005654F7004845F4003A35F1002E26
      EE00231AEC002217EA00000000000000000000000000EBCBAE00F7E7D700F6E1
      CC00F4DBC200F4DAC000F3D8BD00F3D7BB00F4DBC200F3DEC900CFA585000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A9CFFF0084B6F70094949400C7C7C700CCCCCC00C7C7C700C6C6
      C600C3C3C300C0C0C00089898900C8C8C80000000000F0CEAE00F9ECDF00F5DF
      C800F5DDC600F4DCC300F4DAC10056AD5F0079C49C0073BF94006CBA8C0065B6
      84005EB07B00317B3700000000000000000000000000F0CEAE00F9ECDF00F5DF
      C800F5DDC600F4DCC300F4DAC1006D6FFC0095A7F20091A1F0008D9BED008793
      EB00828CE800231AEC00000000000000000000000000F0CEAE00F9ECDF00F5DF
      C800F5DDC600F4DCC300F4DAC100F3D9BE00F3D7BD00F8E6D300D3A580000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000093939300D4D4D400C8C8C800BCBC
      BC00BABABA00C2C2C200C4C4C4009999990000000000F4D3B400F9EDE100F6E1
      CC00F5DFC900F5DEC700F4DCC40069BB6E0058B0610064B5780078C39A0058A7
      69003F8E4600448C4B00000000000000000000000000F4D3B400F9EDE100F6E1
      CC00F5DFC900F5DEC700F4DCC4007E80F9006D6FFC006263FA005654F7004845
      F4003A35F1003A32ED00000000000000000000000000F4D3B400F9EDE100F6E1
      CC00F5DFC900F5DEC700F4DCC400F4DBC200F4DAC000F8E7D600D7AA87000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000097979700DDDDDD00C5C5C500AAAA
      AA00A8A8A800ACACAC00D7D7D7008989890000000000F4D8BD00F9EBDE00F7E7
      D600F6E1CC00F5E0CA00F5DEC800F5DDC500F6E1CB0059B3630082CAA7004EA2
      56000000000000000000000000000000000000000000F4D8BD00F9EBDE00F7E7
      D600F6E1CC00F5E0CA00F5DEC800F5DDC500F6E1CB00F5E2D000DCB595000000
      00000000000000000000000000000000000000000000F4D8BD00F9EBDE00F7E7
      D600F6E1CC00F5E0CA00F5DEC800F5DDC500F6E1CB00F5E2D000DCB595000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009A9A9A00E4E4E400CFCFCF00ACAC
      AC00000000008E8E8E008C8C8C008C8C8C0000000000EFDDCB00F8E2CC00FAEE
      E300F7E7D600F6E2CE00F6E1CB00F6E3D000F9EADD0069BD70005BB565005AAF
      63000000000000000000000000000000000000000000EFDDCB00F8E2CC00FAEE
      E300F7E7D600F6E2CE00F6E1CB00F6E3D000F9EADD00ECCFB500DFC7B2000000
      00000000000000000000000000000000000000000000EFDDCB00F8E2CC00FAEE
      E300F7E7D600F6E2CE00F6E1CB00F6E3D000F9EADD00ECCFB500DFC7B2000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000ABABAB00E2E2E200E7E7E700B9B9
      B900939393000000000000000000000000000000000000000000F4DCC600F9E2
      CD00FAECDE00F9EEE200F9EDE200F8E9DA00F0D5BD00E5C8AF00E0E0DF000000
      0000000000000000000000000000000000000000000000000000F4DCC600F9E2
      CD00FAECDE00F9EEE200F9EDE200F8E9DA00F0D5BD00E5C8AF00E0E0DF000000
      0000000000000000000000000000000000000000000000000000F4DCC600F9E2
      CD00FAECDE00F9EEE200F9EDE200F8E9DA00F0D5BD00E5C8AF00E0E0DF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D4D4D4009F9F9F00E4E4E400EEEE
      EE0096969600000000000000000000000000000000000000000000000000EFDE
      CC00F6DABF00F6D6B800F4D3B400EFD1B400E8D4C10000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFDE
      CC00F6DABF00F6D6B800F4D3B400EFD1B400E8D4C10000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFDE
      CC00F6DABF00F6D6B800F4D3B400EFD1B400E8D4C10000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D4D4D400ACACAC009D9D
      9D009B9B9B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C2A69100B5937800AD88
      6A00A67C5B009F724E0098674100925E3500956139009A694100A3744F00AD82
      5F009F724F000000000000000000000000000000000000000000000000000000
      000000000000B05A3500AC583300A7563200A7563200A1533000A15330000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006E9B7000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CFB9A700B8906D00D6BAA300DFC6
      B300E7D4C300EEDFD300F5EAE200FBF4EF00FDFAF600FFFEFD00FBEBDF00FBEF
      E600C19D8000CCB5A2000000000000000000000000000000000000000000B65E
      3700B25B3500AD593400AD593400A5553100A05230009C502E00974E2D00974E
      2D009D512F000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000619765004F885300000000000000
      0000000000000000000000000000000000001340580015425E0025699C002C76
      B4007AB0D0000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C4A88F00C7A48500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFEFC00FEFBF700FEF7F100FEF6F100E4AE8600FAE8
      DB00CEAF9500C4A78E0000000000000000000000000000000000BA623B00B65F
      3900B35C3600AF5A3400BC785A00BF816600AB603E009F512F00984E2D00984E
      2D00984E2D00984E2D000000000000000000DFB49300D59D7400D1966800CE92
      6300CB8E5E00C98A5B00C787560066945B00569D5E0053995A002A712F00266B
      2B00236627004C723A000000000000000000124259005D9CD400A6CFF500A9CF
      EC00488BC1002C76B40000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D9C7B600A16E4000B4855900D9A5
      7B00D89E6F00D79B6A00D8966300D6925D00D48F5900D38E5700E29D6900FAE3
      D100D8BBA200C09F8100000000000000000000000000BF674000BF674000B962
      3C00B75F3900B75F3900EDD7CD00FFFFFF00D8AD9A00A9573300A2533000994E
      2E00934B2C00934B2C009F512F0000000000D7A17500F8F2ED00F7F0EA00F6ED
      E600F4EAE200F3E7DE00529A580060A768008DCD97008ACB940087CA910084C9
      8E0081C88C0060A768004D825000000000001E6D9300CBE3F90061AAEC004098
      E8001567C2001660AA002C76B400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BF9C7900D5AE8C00FDF0
      E500F7C7A200F7CFAD00F9D5B500F8DABD00F8DEC200FAE1C600FAE4CC00FDF5
      EC00E2CEBA00BD987400000000000000000000000000C16B4500C16B4500BE66
      4000BC623B00BC623B00EACEC100FFFFFF00DCAF9C00B45D3600AD593400A454
      31009A4F2E00954C2C009A4F2E0000000000D9A47A00F9F3EE00EBD2BE00FFFF
      FF00EBD3BF00FFFFFF00FFFFFF0075B17B0062A96A005DA4650035803B00317A
      36005197580082C88D005BA163007AA27C001E6D9300C8E1F200D1E7FA00347D
      B5003199C3006DC4DC004A9CCF003483C7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B7865600FEFE
      FD00FADEC200FADCBF00F9DBC000F9DBC000F9DDC100FADBC000FADCC300FDEB
      DE00ECDCCD00BA9066000000000000000000C46D4700C46D4700C46D4700C069
      4200BF643C00BD613900D69D8400DFB19C00CB805E00BD613900B65E3700AE59
      3400A35431009A4F2E009A4F2E00A4543100DDA87E00F9F3EF00EBD0BA00EBD0
      BB00EBD0BB00F4E6DA00F4EFE700F9F1EC0070AB7200609F6200F4E6D900F4E6
      D900619763002D753300296F2E00407C4400000000002689B900B0CBE10067A9
      C80060DCF50044D6F4008EEEFA005DB4E6003B8FD90000000000000000000000
      0000000000000000000000000000000000000000000000000000B9865200FEFC
      F900F9DCBF00F8DBBF00F8DCC000F9DBC200F9DCC100F9DDC200FADDC300FBE7
      D400F5EDE200B88856000000000000000000C5704B00C5704B00C5704B00C26A
      4300BF653D00BE623900EFD8CE00FFFFFF00E3BBA900BF623900BF623900B55D
      3600AB583300A1533000A1533000A1533000DFAA8200F9F3EF00EACEB700FFFF
      FF00EBD0BB00FFFFFF00FFFFFF00FFFFFF00F9F2EC0082B88600FFFFFF00FFFF
      FF00F7F0EB00C88D5F00000000000000000000000000000000002689B900BEE6
      F200B3F4FC0060DCF50044D6F4008EEEFA005DB4E6003B8FD900000000000000
      0000000000000000000000000000000000000000000000000000B9854B00FEFB
      F700F9DCC100F8DCBF00F8DCBF00F8DBC000F9DDC000F9DDC000F9DDC300FBE2
      CB00FCF9F500B8844A000000000000000000C6734F00C6734F00C6734F00C36B
      4500C0653D00BF623900D3937700FFFFFF00FBF6F300D3937700BF623900B85F
      3700B15B3500A7563200A3533100A3533100E1AE8700FAF4F000EACBB200EACC
      B300EACCB300F6E9DE00F9F1EA00F9F2EB00F3E5D900F5E6DB00F3E3D7007CAC
      7800F5EFE900C486540000000000000000000000000000000000000000002790
      BF00C3EDF800B3F4FC0060DCF50044D6F4008EEEFA005DB4E6003B8FD9000000
      0000000000000000000000000000000000000000000000000000BE8B4F00FCF6
      F000F9DFC700F9DCBD00FADCBF00FADBC100FADDC300FADDC200F9DDC400FBE0
      C900FFFCFA00C18D53000000000000000000C7765200C8795600C7765200C46E
      4800C0674000BF623900BF623900D79D8400FFFFFF00FFFFFF00D79D8400BA5F
      3700B45C3600AC583300A7563200A7563200E3B18C00FAF6F100EAC9AE00FFFF
      FF00EAC9B00074C57E005DB868005AB364007CBB7D00FFFFFF00FFFFFF0068AC
      6F006EAA7200C586550000000000000000000000000000000000000000000000
      00002FBAE400C3EDF800B3F4FC0060DCF50044D6F4008EEEFA005DB4E6003B8F
      D900000000000000000000000000000000000000000000000000CB9D6700F5E7
      D800FAE5D200F9DABC00F9DBBC00FADBBF00FADDC100FADDC100F9DDC400FBE1
      C800FFFDFB00C89457000000000000000000C8785400CA7C5A00CA7C5A00C673
      4E00C6734E00CB806000BF623900BF623900D3937700FFFFFF00FBF6F300BF6A
      4400B55D3600AF5A3400AF5A3400AF5A3400E5B48F00FAF6F200E9C6AA00E9C6
      AC00EAC7AC009ECF98008ECF9700AAD9B1007AC3830057AF610052A95C006FB7
      78006BB3740068924F0000000000000000000000000000000000000000000000
      0000000000002FBAE400C3EDF800B3F4FC0060DCF50044D6F4008EEEFA005DB4
      E6003B8FD9000000000000000000000000000000000000000000D6AE7E00F0D9
      C100FBEDE100F9DAC000F9DCC200F9DEC500FAE0C700FAE2CA00FAE2CD00FAE5
      D000FFFEFD00CB8F5A00CC995B0000000000C8785500CB805E00CB805E00D392
      7700FFFFFF00FFFFFF00C7775400BF623900C36C4500FFFFFF00FFFFFF00CC89
      6B00B65E3700B15B3500B15B3500B15B3500E7B79400FBF7F400E9C3A600FFFF
      FF00E8C4A900D9F1DC0084CF8D0094D29C00ABDAB200A8D9AF00A5D8AD00A2D6
      AA009FD5A7006CB474005FA56600000000000000000000000000000000000000
      000000000000000000002FBAE400C3EDF800B3F4FC0068D9F5006FCFF300599D
      D00073ABDD004F91C90000000000000000000000000000000000DEBB8F00EDD0
      B200FFF6F000FAE1CA00FBE3CC00FBE3D000FBE6D300FBE9D500FCE9D800FCEA
      DB00FFFFFD00D29D7100EED9C100D4A3660000000000CB805E00CD846400CC81
      6000F1DED500FFFFFF00F4E4DD00E0B3A000F3E3DB00FFFFFF00FBF6F400C16E
      4900B8603A00B45D3700B45D370000000000E9BA9800FBF7F400E9C3A600E9C3
      A600E9C3A600EFD3BD00D3E0C3008BCF900063C06F0060BC6B005DB7670079C2
      820075BE7E0073A15C0000000000000000000000000000000000000000000000
      00000000000000000000000000002FBAE400C3EDF800A8E2F8006CAEDD00A5CF
      F400A5CFF400BDDBF7005896CD00000000000000000000000000E4C59C00EBCA
      A500FFFDFB00FDE9D500FDEBD800FDEADB00FDEDDF00FDF0E200FDF1E400FCF0
      E400FFFFFF00E0A07000FFFBF900DFB8870000000000CA7C5A00CD856500CD85
      6500CF896A00F2DED500FFFFFF00FFFFFF00FFFFFF00F8EDE800CD866700BF68
      4100BB643E00B8613A00B8613A0000000000EBBD9B00FBF7F400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007AC5
      830082C58900D1976A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002FBAE400A7D4F400C5E1F800CCE3
      F900CCE3F900BDDBF7005091C900000000000000000000000000E8CCA600EBC6
      9A00FFFFFF00FCEFE200FDF0E700FDF1EB00FDF5EE00FDF8F100FDFAF700FFFC
      FA00FFFFFF00FEFBF700F4DAC000DCAB68000000000000000000CB7F5D00CD84
      6400CD846400CB805E00D08C6D00D5987E00D18D6F00C5714C00C5714C00C16C
      4600BE674100BB633C000000000000000000ECBF9E00FBF7F4009CD5A50098D3
      A10094D09D0090CE98008BCB930087C98E00A3D5A800B9DFBC00CDE8CF007FC9
      8700F9F6F200D49B6F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000050A8D9006AA5D800C9E1
      F700CBE3F8004295CA0072AAD500000000000000000000000000ECD5B500EAC0
      8C00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FDF9F400FBF3EA00F8EBD900F8E6
      D300F5DFC600E9CBA600E0AE680000000000000000000000000000000000CA7C
      5A00CA7C5A00CB805E00CA7C5A00CA7C5A00C7765300C6734F00C6734F00C36D
      4700C0684200000000000000000000000000EFC6A800FBF7F400FBF7F400FBF7
      F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7
      F400FBF7F400D8A3780000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005DB1DE005194
      CA004E90C80049A9D8000000000000000000000000000000000000000000E7BD
      8100EABC8100E8B77700E6B26D00E4B06800E3B06800E4B47000E6BA7C00E6BB
      7D00E8C08800E9C6930000000000000000000000000000000000000000000000
      000000000000C8785400C8785400C8785400C6745000C5714C00C5714C000000
      000000000000000000000000000000000000F7E1D200F1C8AC00EDC09F00EBBE
      9D00EBBC9A00E9BA9600E7B79300E6B59000E4B28C00E2AF8800E0AC8400DDA9
      8000DCA57D00E2B6960000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009F9F9F00919191009191
      9100919191009191910091919100919191009191910091919100919191009191
      910091919100697A89004A789F00416F96000000000000000000000000001843
      5A002B6189004C8ABE006EA7CA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000095959500BFBFBF00C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C4C4
      C4008E9EAE005F8DB6008CB1D40045749F000000000000000000000000002E67
      850094C7F90091C9F9004185C900266BAE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BCBCBC00EFEFEF00FBFB
      FB00FCFCFC00FCFCFC00FCFCFC00ECE9E600D3C4B800C7AC9400CDAF9600C9A8
      8D00AB998E0096B1CB005A89B500ADBDCD009090900089888800878686004389
      AA00E0F2FF00549AD8001A7ABE004998C5003D83BB0079869300878685009595
      9500000000000000000000000000000000000000000000000000000000000000
      000000000000000000009ABA9A006BA66C006AA56B0098B79800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C9C9C900FBFBFB00FBFB
      FB00FBFBFB00FBFBFB00FBFBFB00C7B7A900E2CDBC00F5E0CC00F7E0C700F8E2
      CB00F3D1B300A7998F0094A5B5000000000088888800C2C2C100BCBCBC007E9C
      B0007AB6D50090B7D10055C9E4005BDFF50078D0ED004C97D700B0BBC4008B8B
      8A00000000000000000000000000000000000000000000000000000000009EBE
      9E009DBE9E009CBD9D007DB07E008BBA8C006FAA72007AAC7B0098B8990098B7
      980097B79700000000000000000000000000A87B5E00B46C3D00BC733C00BF79
      3F00C27D4300C3804500C3824800C4844A00C4884C00C4884D00C4894E00C489
      4E00C4894F00C0885100B5835600A87B5E0000000000C9C9C900FCFCFC00FBFB
      FB00FBFBFB00FBFBFB00AEAEAE00C9AC9400F3E3D400F4DAC100F3D8BD00F3D8
      BD00F8E3CC00C4A48B00CBCBCB00000000008C8C8B00FFFFFF00EBEBEB00EBEB
      EB00A5C8D80076B9D600C2F6FD0063DFF7005DE2F80079D3F0004A99DC00838D
      96000000000000000000000000000000000000000000000000000000000077AD
      78006AA96C0068A96B007FB380008FBD90008EBB8F007AB07D00629F6400619F
      620078AA7900000000000000000000000000AE714B00F8F3EE00F5ECE400FBF5
      F000FBF7F100FBF7F300FBF8F400FCF9F500FCF9F500FCF9F600FCF9F700FCFA
      F700FCFAF700F7F1EC00EADACD00B5875A0000000000C9C9C900FCFCFC00FBFB
      FB00FBFBFB00FBFBFB00AEAEAE00C8A98D00F8EADC00F4DDC600F4DCC400F3D8
      BD00F8E2CD00CCAD9300C7C7C7000000000092919100FFFFFF00B4B4B4009494
      9400E7E7E7007EA2B40077CBE700C7F7FD005EDCF5005AE1F7007BD4F1004695
      D800000000000000000000000000000000000000000000000000000000000000
      000000000000000000009EBF9F007AB17B0070AA71009BBC9C00000000000000
      000000000000000000000000000000000000BE703D00FCF9F500ECD0BC00F9E4
      D600FEECDF00FEEBDF00FEEBDE00FEEBDB00FEEBDC00FEEADD00FDEADB00FDE8
      D800F8E0CD00EACBB300F3EBE300C78B510000000000C9C9C900FCFCFC00FBFB
      FB00FCFCFC00FCFCFC00AEAEAE00CAAE9500F2E3D500F6E0CA00F5DEC600F5DE
      C500F7E5D200C5AA9400C8C8C8000000000095959500FFFFFF00E8E8E800E7E7
      E700E5E5E500E3E3E300ABD3E00079D3EE00C7F7FD005FDCF5005BE2F7007AD6
      F20051A1E100000000000000000000000000000000000000000000000000A3C4
      A300A2C3A200A1C2A20086B787008EBD8F0078B07B0080B380009CBD9D009BBB
      9C009ABB9B00000000000000000000000000C2764600FDFBF800F9E3D200ECCF
      B900F8E1D000FDE7D600F4D5BD00E9BFA000E9BFA200F4D3BD00FDE6D400F7DE
      C900EBCAB000F8DBC400F8F2EC00C98C500000000000C9C9C900FCFCFC00FCFC
      FC00FCFCFC00CBCBCB00AFAFAF00C1B5A700DDC3AB00F4E6DA00F8ECDF00F2DD
      C900E3C9B200C2B2A400C8C8C800000000009A9A9900FFFFFF00B1B1B1009191
      9100E2E2E200ADADAD008F8F8F00A8D2DE007CD4ED00C4F6FD006CDDF6006DCA
      ED0063A3D70068A2D50000000000000000000000000000000000000000007BB4
      7C0072B2750070B073007DB77F0090C0920095C2970083B7840068A76B0067A6
      6A0078AE7A00000000000000000000000000C57D5000FDFBF900FDE9D800F9E1
      D000EBCAB300ECC5A700E3B69800F7E7DD00F7E8DE00E3B69700ECC3A400EAC5
      A900F8DAC200FCDFC600F8F3ED00C88D500000000000C9C9C900FCFCFC00FCFC
      FC00FCFCFC00F5F5F500CBCBCB00ECEDED00B6AA9C00BFAE9700C9AB8F00CDAF
      9500BEAB9800F4F7F800C9C9C900000000009E9D9D00FFFFFF00E3E3E300E1E1
      E100DCDCDC00DBDBDB00D7D7D700D3D3D30098C9D80080D5ED00B2E3F9008BC0
      E700AED3F600C4E0FC006BA2D400000000000000000000000000000000000000
      0000000000000000000070B2740092C294008BBE8D0078B17A00000000000000
      000000000000000000000000000000000000C9865B00FDFBF900FDE8D700FDE6
      D400EDC6AB00DCAA8900F9ECE300FFFBF900FFFCFA00F9EEE600DCA88700EDBF
      9C00FCDBC000FCDBC000F8F3ED00C88C500000000000C9C9C900FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FBFBFB00000000000000
      0000FFFFFF00FCFCFC00C9C9C90000000000A0A0A000FFFFFF00ADADAD008E8E
      8E00D8D8D800A5A5A5008A8A8A00CECECE007374E800417ADE0077BEE700B4D2
      F000E5F3FF00ACD2EF005896CB00000000000000000000000000000000000000
      000000000000A5C8A60080BB840084BD87008DC08F007AB47C00000000000000
      000000000000000000000000000000000000CC8E6600FDFBF900FDE5D300F1CC
      B200E3B59600F9EAE000FFF9F500FEF3EA00FEF4ED00FFFBF900F9EDE500E3B0
      8D00F0C19E00FCD7B700F8F3ED00C88C5000000000000000DC001313F3003B3B
      E9003333E8002D2DE7002828E3002323E1001E1EDF001B1BDD001717DC001414
      DB001111DC000404ED000000DC0000000000A3A3A300FCFCFC00DADADA00D7D7
      D700D2D2D200CECECE00C9C9C900C5C5C500C2C2C200BFBFBF00BCE5F40058A5
      D80085B1DB00469DD000ACD3E900000000000000000000000000000000000000
      00000000000077B7780084BE860091BD930071B3750081BA85008FB990000000
      000000000000000000000000000000000000D0967000FDFBF900F1CDB100E3B5
      9600F9E9DE00FEF7F100FDEDE100FEEFE400FEF1E700FEF3EA00FFFAF700F9EC
      E300E2AE8A00F0BC9500F8F4EC00C88C5000000000000000DC000F0FEB002828
      BD001C1C98001F1FBC001E1EDD001B1BDF001616DE001212D7000D0DB5000808
      92000606B4000101E6000000DC0000000000A3A3A300FFFFFF00B07B5600C38D
      6700C58F6800C6906900C8926B00CA946C00CA956E00B07B5600FFFFFF00A1A0
      9F00000000000000000000000000000000000000000000000000000000000000
      000085BF86008AC38C0078B87C0000000000BDD5BD007EBA810079B67B000000
      000000000000000000000000000000000000D39D7B00FBF6F200E3B49600F9E8
      DC00FEF5EE00FDE9DA00FDEADC00FDECDE00FDEDE100FEEFE400FEF1E700FFFA
      F600F9EAE000E2AA8500F1E4D900C88C5100000000000000DC000B0BDA00A1A1
      AE00E0E0E0009F9FAE001414CE001212E1000E0EE1000909CC009E9EAE00E0E0
      E0009E9EAE000000D7000000DC0000000000A4A4A400FFFFFF00B07B5600C18B
      6400C38D6600C58F6700C6906900C8926B00CA946C00B07B5600FFFFFF00A0A0
      A00000000000000000000000000000000000000000000000000000000000BFDA
      C00085C3890083C1860000000000000000000000000083BA840087BF880074B3
      760000000000000000000000000000000000DBB59F00FDFAF800FCF5F100FFFC
      F900FFFCF900FFFCF900FFFCF900FFFCFA00FFFCFA00FFFCFA00FFFCFB00FFFD
      FB00FFFDFC00FBF6F300F8EFEA00B6895C00000000000000DC000707D200C4C4
      D600E3E3E300C4C4D5000303D0000202ED000202ED000101CF00C5C5D600E3E3
      E300C4C4D6000000CF000000DC0000000000A3A3A300FFFFFF00A7724D00A772
      4D00A7724D00A7724D00A7724D00A7724D00A7724D00A7724D00FFFFFF009E9E
      9E00000000000000000000000000000000000000000000000000000000007DC0
      81008DC890008DC38F000000000000000000000000000000000075B7780083BE
      86009AC19B00000000000000000000000000D4B19B00D7A98B00D1997200CC90
      6500CC8F6300CB8F6100CA8D5E00C98C5C00C88B5900C7895700C6875400C585
      5100C5834F00C3875200BA875B00A87B5E00000000000000DC000000C700B5B5
      CB00E6E6E600B3B3C9000000C7000000DC000000DC000000C700B8B8CE00E6E6
      E600B6B6CD000000C7000000DC0000000000A8A8A800FEFEFE00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A2A2
      A20000000000000000000000000000000000000000000000000097C9980080C4
      84007FC2830000000000000000000000000000000000000000009CC69D0077BA
      7C0075B778000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000A6A6A600BCBCBC0000000000000000000000000000000000C9C9C900AFAF
      AF00C0C0C000000000000000000000000000AFAFAF00A8A8A800A8A8A800ABAB
      AB00ACACAC00ADADAD00ACACAC00ABABAB00A8A8A800A4A4A400A2A2A200B2B2
      B200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C8896000C3845800D38B6800E18F7000DC8D6C00DA8B
      6D00D78A6E00CD8B6C00AB6D4400A65F2E000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000949494008D8D8D0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AB693D00AA6440000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6835500EFCEBA00DDFFFF0087EEC700A2F4D700A2F6
      D7008CEEC700E0FFFF00DDA28500AB6A3E000000000000000000000000000000
      0000CE937700AA543700AD4C2A00AD492600AC482600AA472900A64C3100C57C
      5D00EDEBEB000000000000000000000000000000000000000000000000009A9A
      9A00B0B0B000B1B1B1008B8B8B00000000000000000000000000000000000000
      000000000000000000000000000000000000BA7B4A00C0895F00BF896200AF6D
      4700000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEB39100D59D7400D1966800CE92
      6300CB8E5E00C98A5B00C37F5100EFB69A00EAF3E80051BF84006FC9980071C9
      990054BF8400E4F4E900DD9C7B00AA693A000000000000000000287BCE008863
      6300BF603500FEB96100FEB96200FEB96200FEB96200FEB96100FEB96100B149
      24007F6A72003481CF00B0CBE5000000000000000000000000009F9F9F00B6B6
      B600AEAEAE00DDDDDD00B8B8B8008B8B8B000000000000000000000000000000
      000000000000000000000000000000000000C3885900CFA27D00CDA28000C08C
      6600B0724900C79D870000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D7A17500F8F2ED00F7F0EA00F6ED
      E600F4EAE200F3E7DE00C4815400EAB69700F3F3EA00EDF1E600EFF1E600EFF0
      E600EDF1E500F3F5ED00D59C7900B0704400000000002A7DD10082BAEE009F66
      5800F5BB8400FFAC5B00FEA85A00FEA25700FE9C5300FFA35500FF9F5000F8AE
      7800A45E4A0083BCEF002B78CA0000000000000000009F9F9F00BBBBBB00AFAF
      AF00EDEDED00F1F1F100D3D3D300BCBCBC008B8B8B0000000000000000000000
      00000000000000000000000000000000000000000000CC997100D0A38100CFA4
      8300CA9E7B00BC855D00AF714900A76440009E573800AC715C00000000000000
      000000000000000000000000000000000000D9A47A00F9F3EE00EBD2BE00FFFF
      FF00EBD3BF00FFFFFF00C98B6100E6B59200E2A78100E1A78100DEA37D00DCA1
      7B00DB9F7900D99E7700D49A7300BB7E5700000000002A7DCE0078B3EA00B39E
      9400FFB76000FFB66300FEB26100FEAC5D00FEA55900FD9E5300FE974E00FF8D
      4300BC8F82007EB8ED002D77C80000000000ACACAC00C5C5C500B7B7B700EEEE
      EE00D7D7D700D9D9D900D5D5D500CFCFCF00B6B6B6008D8D8D00000000000000
      0000000000000000000000000000000000000000000000000000CE9D7600D5AC
      8C00CB9B7600CCA07C00C89B7600C5956F00C08F6900AC6D4800CBA89B000000
      000000000000000000000000000000000000DDA87E00F9F3EF00EBD0BA00EBD0
      BB00EBD0BB00EBD0BB00CA8D6500EAB89900DDA57E00DDA68000DBA37C00D9A0
      7A00D9A07900D89F7800D89E7800BF845D0000000000DBC4B7008A544400FCC8
      AB00FFD19800FEC76D00FEBF6800FEB96400FEB15E00FEA85900FDA05400FFB7
      7A00FEA9800088504200CEB7AA0000000000ABABAB00D2D2D200F0F0F000DADA
      DA00D9D9D900B0B0B000B5B5B500D6D6D600D0D0D000B7B7B7008D8D8D000000
      0000000000000000000000000000000000000000000000000000DBB59700D3A8
      8600D6AC8E00C9987100C4906800BF8A5F00C28F6700BF8B6400816A4A000000
      000000000000000000000000000000000000DFAA8200F9F3EF00EACEB700FFFF
      FF00EBD0BB00FFFFFF00C8885D00EFBFA100FDFCFA00FEFCFB00FEFDFD00FEFD
      FC00FDFBFA00FDFCFB00DDA88500C17F53000000000000000000DAB49F00C44C
      1F00F6E4D600FFE4A400FFD47200FFC96900FFC06300FFB65F00FFC18000F6D7
      C600C5491F00D2AB9600F5F4F30000000000C0C0C000A8A8A800E4E4E400DBDB
      DB00BABABA00EAEAEA00B1B1B100B6B6B600DDDDDD00D5D5D500B9B8B7008D8D
      8D0000000000000000000000000000000000000000000000000000000000D4A3
      7E00DCB59800D0A17D00CC9A7400CFA48300C89A76007D8C64006AB87A008E53
      3800AF7A6A00000000000000000000000000E1AE8700FAF4F000EACBB200EACC
      B300EACCB300EACCB300C7865B00EFC09E00FFFFFF00CC936E00FFFFFF00FFFF
      FF00FFFBF700FFF8F100E4AF8C00C78A6100000000000000000000000000D5AF
      9900BC481C00F4E2D4004E7BA9004D7BA8004D7BA8004E7BA900F3D6C300BE46
      1C00D0A89300000000000000000000000000C1C1C100ACACAC00E9E9E900ACAC
      AC00A2A2A200B0B0B000EAEAEA00B2B2B200BEBEBE00DFDFDF00DDD9D500BCB1
      A5008E8E8E00000000000000000000000000000000000000000000000000DBAB
      8900E1BDA200D6AA8700D9B39400CE9F7A00978B61006DBC7C00936F4600B075
      4F00A46241009E5D49000000000000000000E3B18C00FAF6F100EAC9AE00FFFF
      FF00EAC9B000FFFFFF00CC8D6500F3CDB000FFFFFF00E3C7B300FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EABFA100C98960000000000000000000000000000000
      00009D807200346DA7009CCCF800AFD4F700AFD4F700A5CFF6003474AE009679
      6E000000000000000000000000000000000000000000C2C2C200AFAFAF00E5E5
      E500ADADAD00A3A3A300B1B1B100EAEAEA00C0C0C000EEEDEC00CFA97B00D7C2
      A900C3BCB2008D8D8D000000000000000000000000000000000000000000E0B1
      8F00E6C4AB00E2BFA400D8AD8E00AA967400D4C4AC00A5794A00BB845D00C08F
      6900BC8A61009C5235000000000000000000E5B48F00FAF6F200E9C6AA00E9C6
      AC00EAC7AC00E9C7AD00D4976E00D49E7B00D0987100D6A48200CD8E6800CD90
      6900D09A7500D1997300C88B6200E7D6C9000000000000000000000000000000
      0000597FA900A6CAEE00ABCCEA00A7D0F600A8D0F600ABCCEA00A7CDEE005580
      AD00000000000000000000000000000000000000000000000000C2C2C200AFAF
      AF00E5E5E500AEAEAE00A4A4A400B3B3B300EDEDED00D7B99500C99B6400CEA3
      7300E6E4E20094949400DEDEDE00000000000000000000000000000000000000
      0000E4BB9F00E4BB9F00A1A7860076C17F00B1905C00C7966F00CB9E7B00BC85
      5900C3926C00A6633F000000000000000000E7B79400FBF7F400E9C3A600FFFF
      FF00E8C4A900FFFFFF00FFFFFF00FFFFFF00E8C7AC00FFFFFF00FFFFFF00FFFF
      FF00F7F1EB00CB8F5F0000000000000000000000000000000000000000000000
      00002E69A100D9E8F70097C5F1008EBBE5007FA9D10089B5DF00CDDFEE002F70
      AB0000000000000000000000000000000000000000000000000000000000C3C3
      C300B0B0B000E5E5E500AFAFAF00A6A6A600B4B4B400E5DBCE00D5B58F00E1CB
      B00095959500ABABAB00F0F0F000000000000000000000000000000000000000
      0000EBCCB700BBB4940077C58200B5B08100D8B09200D7AE8F00C9976F00C38F
      6600C89B7600B1714A00DDC7BC0000000000E9BA9800FBF7F400E9C3A600E9C3
      A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3
      A600FBF7F400CE93640000000000000000000000000000000000000000000000
      00000C3E87007C97B8008AB7E400719CC80015406E001944720022456B00163F
      6900000000000000000000000000000000000000000000000000000000000000
      0000C3C3C300B1B1B100E6E6E600B0B0B000A7A7A700B5B5B500EFEFEF00F4F4
      F4009E9E9E00C3C3C30000000000000000000000000000000000000000000000
      00000000000000000000C5B48700E2BEA300DFB79A00D5A88600D0A17D00CB9A
      7300CEA28000BF8B6200CBA38A0000000000EBBD9B00FBF7F400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FBF7F400D1976A0000000000000000000000000000000000000000000000
      00000F4B970012589F000F4A8A000F4B8700114B8700154C8500124175001C3E
      6500000000000000000000000000000000000000000000000000000000000000
      000000000000C4C4C400B1B1B100E6E6E600B1B1B100B0B0B000F2F2F200A0A0
      A000B7B7B7000000000000000000000000000000000000000000000000000000
      00000000000000000000EFD8CA00E4BA9D00E6C4AB00E2BEA400DEB99C00D9B2
      9300D1A37F00D1A68500BB7F510000000000ECBF9E00FBF7F4009CD5A50098D3
      A10094D09D0090CE98008BCB930087C98E0082C689007EC384007AC1800076BE
      7C00FBF7F400D49B6F0000000000000000000000000000000000000000000000
      00008C9CB400124F960012589B0012589900115393000F4A87000F3F72008491
      A000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C4C4C400B2B2B200E8E8E800F4F4F400A8A8A800CACA
      CA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000EAC6AD00E3B49300DFB18E00DAAB8900DAAD
      8C00DCB59800D7AF9000CC9B7400B87A4800EFC5A800FBF7F400FBF7F400FBF7
      F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7
      F400FBF7F400D8A2780000000000000000000000000000000000000000000000
      0000000000008898B2001C509200104B90000F488A001A4982008292A6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C4C4C400B2B2B200B0B0B000CDCDCD000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E6C9
      B300D8A78200D7AC8B00D3A78400C3895C00F3DDCD00F0C7AB00EDC09F00EBBE
      9D00EBBC9A00E9BA9600E7B79300E6B59000E4B28C00E2AF8800E0AC8400DDA9
      8000DCA57D00E0B4940000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C5C5C500D1D1D100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D5A27E00D19D7500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000091C0DF0054A7D800519AD000B0C6DB00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272005C5C
      5C00000000000000000000000000000000000000000000000000000000000000
      000000000000000000006DBDE70086E9F9004DD9F5004397CE00AAC0D6000000
      0000000000000000000000000000000000000000000000000000DEB39100D59D
      7400D1966800CE926300CB8E5E00C98A5B00C7875600C3845200C3845200C384
      5200C3845200C3845200C3845200CE9F7A000000000000000000000000000000
      0000606060006A6A6A006F6F6F006E6E6E000000000000000000727272006F6F
      6F006A6A6A00606060000000000000000000DEB39100D59D7400D1966800CE92
      6300CB8E5E00C98A5B00C78756009F86720069696900AE815E00A2A2A2008B8B
      8B00A37958005E5E5E008484840000000000DEB39100D59D7400D1966800CE92
      6300CB8E5E00C98A5B0060A4C700A1E6F80038D2F20047D6F6004093C8008674
      6D00BA825700C59B7E0000000000000000000000000000000000B7A28700D3E4
      EA00F7F0EA00F6EDE600F4EAE200F3E7DE00F1E4DB00F0E2D800F0E2D800F0E2
      D800F0E2D800F0E2D800F0E2D800C58B5E00DEB39100D59D7400B6845E006158
      5000918D8A00ACA8A400AEAEAE0097979700717171007878780097979700AEAE
      AE00ACA7A400918E8C006868680000000000D7A17500F8F2ED00F7F0EA00F6ED
      E600F4EAE200F3E7DE00F1E4DB00A0A0A000C9C9C900A5A5A500CACACA00C2C2
      C200A1A1A100C4C4C4006D6D6D0000000000D7A17500F8F2ED00F7F0EA00F6ED
      E600F4EAE200F3E7DE00ABC9DB005DABDC0099E2F60053DCF50046D9F6003F94
      CD00468CD0004385C700B1C5DD00000000000000000000000000A6A6960040B0
      DD00ACC3C700FFFFFF00EBD3BF00FFFFFF00FFFFFF00FFFFFF00EAC7AD00FFFF
      FF00FFFFFF00FFFFFF00F0E2D800C68C5F00D7A17500F8F2ED00A4A09C00706F
      6F00D3D3CE007E7B780044444400464646005151510051515100464646004444
      44007D7A7700C4C4C4007070700000000000D9A47A00F9F3EE00EBD2BE00FFFF
      FF00EBD3BF00FFFFFF00F9F9F900CDCDCD00C9C9C900BDBDBD009C9C9C009A9A
      9A00B5B5B500C2C2C200A3A3A30000000000D9A47A00F9F3EE00EBD2BE00FFFF
      FF00EBD3BF00FFFFFF00FFFFFF00D4E9F70068B0D60067C1E8005ED9F2004EDB
      F6005BDDF70055D8F5003484CE00ACC0D9000000000000000000DDA87E005FBE
      E20043B5E30066B2D000DECDBD00EBD0BB00EBD0BB00EBD1BD00EACDB500EACD
      B500EACDB500EACDB500F0E2D800C68A5C00D9A47A00F9F3EE00877B72008686
      8600D3D3CE00F8F8F80048484800BDBDBD00CECECE00C2C2C200ADADAD004848
      4800EADCD300C4C4C4008686860000000000DDA87E00F9F3EF00EBD0BA00EBD0
      BB00EBD0BB00EBD0BB00A5A5A500B7B7B700E1E1E1009C9C9C00EACDB500EACD
      B5009A9A9900D5D5D5009999990065656500DDA87E00F9F3EF00EBD0BA00EBD0
      BB00EBD0BB00EBD0BB00EBD0BB00EBD1BD00EACDB5008AB2C80089DDF4006AE0
      F60073E2F7005FDFF60055DAF6004185CF000000000000000000DFAA8200EEEF
      EE0031ADDC0051BAE60039A8D700ABD9F000FFFFFF00FFFFFF00EACFBA00FBF6
      F200FFFFFF00FFFFFF00F0E2D800C88D5F00DDA87E00F9F3EF00B29F90007A78
      7700D3D3CE00827A74004D4D4C00656565009292920079797900656565004D4D
      4C0084807D00C4C4C4007B7B7B0000000000DFAA8200F9F3EF00EACEB700FFFF
      FF00EBD0BB00FFFFFF00B4B4B400CACACA00E8E8E80086868600FFFFFF00FFFF
      FF009A999900E2E2E200B6B6B60087878700DFAA8200F9F3EF00EACEB700FFFF
      FF00EBD0BB00FFFFFF00FFFFFF00FFFFFF00EACFBA0077BCE400A9EEF9007EE6
      F8009AE8F8007ED1F00080E2F6004A9EDB00A0DEEF008CD7ED0084B4B8008BD1
      E8003CB3DC007DD0F0006DC7EC0044B2E2006CAEC900CEC6BB00E8C7AC00E8C7
      AC00E8C8B000E8C8AE00F0E2D800C4865400DFAA8200F9F3EF00E6CAB4009E9E
      9E0091919100E8E8E800DDDDDD00C1C1C1008F8B88009A989700DADADA00DDDD
      DD00C4C4C400919191009A9A9A0000000000E1AE8700FAF4F000EACBB200EACC
      B300EACCB300EACCB300EACCB300CEC1B600D2D2D200ABABAB00818181008A8A
      8A00B4B4B400CACACA00B9B9B90000000000E1AE8700FAF4F000EACBB200EACC
      B300EACCB300EACCB300EACCB300EACEB700E8C7AC009EB3BE005EC1EA00A3F0
      FB0080D4F0007EC7EC0057A6DE00ACC7E00061CFEB006ED8F00068D3EF0066CF
      ED0084D9F30088D7F4007DCFF10058BCE80052B7E500229DD70099B3BB00F5FA
      FD00FFFFFF00FFFFFF00F1E5DB00C6865500E1AE8700FAF4F000EACBB200E3C6
      AE00AF9F92008C8A88009E9E9E0089868300CDB39E00DCBEA6008A8683009E9E
      9E008C8B8B009B795E000000000000000000E3B18C00FAF6F100EAC9AE00FFFF
      FF00EAC9B000FFFFFF00FFFFFF00BABABA00DADADA00BFBFBF00D6D6D600D8D8
      D800B8B8B800D4D4D4008888880000000000E3B18C00FAF6F100EAC9AE00FFFF
      FF00EAC9B000FFFFFF00FFFFFF00FFFFFF00E8C7AC00FFFFFF00A1CFEE006FC9
      EC00C9F3FB005FB6DD00BCD7EB00000000000000000049C9E90090E6F8008DE3
      F70060D2F20084D7F4003AB3DC007EB8C80082B8C6007BB4C80086B3C100D1C3
      B400E8C8B000E8CCB500F2E7DE00C88A5900E3B18C00FAF6F100EAC9AE00FFFF
      FF00EAC9B000FFFFFF00FFFFFF00FFFFFF00E8C7AC00FFFFFF00FFFFFF00FFFF
      FF00F1E5DB00C68655000000000000000000E5B48F00FAF6F200E9C6AA00E9C6
      AC00EAC7AC00E9C7AD00E9C9AE00D5C4B700BDBBBA00DFC5B100C0C0C000BEBE
      BE00E0D7D100ABA39E00C5C5C50000000000E5B48F00FAF6F200E9C6AA00E9C6
      AC00EAC7AC00E9C7AD00E9C9AE00E9C9B000E8C7AC00E9C9B000E7C8B00086B1
      C90069B7E0008B8F8B0000000000000000000000000097DFF0006BD9F10096E7
      F80047CFF20089DCF40037B7E000A6DEF200FFFFFF00FFFFFF00E8C7AC00FFFF
      FF00FFFFFF00FFFFFF00F7F1EB00CB8F5F00E5B48F00FAF6F200E9C6AA00E9C6
      AC00EAC7AC00E9C7AD00E9C9AE00E9C9B000E8C7AC00E9C9B000E8C8B000E8CC
      B500F2E7DE00C88A59000000000000000000E7B79400FBF7F400E9C3A600FFFF
      FF00E8C4A900FFFFFF00FFFFFF00FFFFFF00E8C7AC00FFFFFF00BABABA00B4B4
      B400F7F1EB00CB8F5F000000000000000000E7B79400FBF7F400E9C3A600FFFF
      FF00E8C4A900FFFFFF00FFFFFF00FFFFFF00E8C7AC00FFFFFF00FFFFFF00FFFF
      FF00F7F1EB00CB8F5F000000000000000000000000000000000046C8E60093E7
      F8005FD8F40090E0F6007DD6F20052C3E9009FBDBD00E9C3A600E9C3A600E9C3
      A600E9C3A600E9C3A600FBF7F400CE936400E7B79400FBF7F400E9C3A600FFFF
      FF00E8C4A900FFFFFF00FFFFFF00FFFFFF00E8C7AC00FFFFFF00FFFFFF00FFFF
      FF00F7F1EB00CB8F5F000000000000000000E9BA9800FBF7F400E9C3A600E9C3
      A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3
      A600FBF7F400CE9364000000000000000000E9BA9800FBF7F400E9C3A600E9C3
      A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3
      A600FBF7F400CE9364000000000000000000000000000000000086C6CA0074DE
      F30089E3F60085DEF50081D9F40078D3F10050C2E800B3E3F400FDFEFF00FFFF
      FF00FFFFFF00FFFFFF00FBF7F400D1976A00E9BA9800FBF7F400E9C3A600E9C3
      A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3
      A600FBF7F400CE9364000000000000000000EBBD9B00FBF7F400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FBF7F400D1976A000000000000000000EBBD9B00FBF7F400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FBF7F400D1976A0000000000000000000000000000000000BFC3B2005DD4
      EC004BCCE00049C9DE0047C5DC0043C2DA0040BED90042BBD20079C493007EC3
      84007AC1800076BE7C00FBF7F400D49B6F00EBBD9B00FBF7F400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FBF7F400D1976A000000000000000000ECBF9E00FBF7F4009CD5A50098D3
      A10094D09D0090CE98008BCB930087C98E0082C689007EC384007AC1800076BE
      7C00FBF7F400D49B6F000000000000000000ECBF9E00FBF7F4009CD5A50098D3
      A10094D09D0090CE98008BCB930087C98E0082C689007EC384007AC1800076BE
      7C00FBF7F400D49B6F0000000000000000000000000000000000EFC5A800FBF7
      F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7
      F400FBF7F400FBF7F400FBF7F400D8A27800ECBF9E00FBF7F4009CD5A50098D3
      A10094D09D0090CE98008BCB930087C98E0082C689007EC384007AC1800076BE
      7C00FBF7F400D49B6F000000000000000000EFC5A800FBF7F400FBF7F400FBF7
      F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7
      F400FBF7F400D8A278000000000000000000EFC5A800FBF7F400FBF7F400FBF7
      F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7
      F400FBF7F400D8A2780000000000000000000000000000000000F3DDCD00F0C7
      AB00EDC09F00EBBE9D00EBBC9A00E9BA9600E7B79300E6B59000E4B28C00E2AF
      8800E0AC8400DDA98000DCA57D00E0B49400EFC5A800FBF7F400FBF7F400FBF7
      F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7
      F400FBF7F400D8A278000000000000000000F3DDCD00F0C7AB00EDC09F00EBBE
      9D00EBBC9A00E9BA9600E7B79300E6B59000E4B28C00E2AF8800E0AC8400DDA9
      8000DCA57D00E0B494000000000000000000F3DDCD00F0C7AB00EDC09F00EBBE
      9D00EBBC9A00E9BA9600E7B79300E6B59000E4B28C00E2AF8800E0AC8400DDA9
      8000DCA57D00E0B4940000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F3DDCD00F0C7AB00EDC09F00EBBE
      9D00EBBC9A00E9BA9600E7B79300E6B59000E4B28C00E2AF8800E0AC8400DDA9
      8000DCA57D00E0B494000000000000000000000000009F9F9F00919191009191
      9100919191009191910091919100919191009191910091919100919191009191
      910091919100919191009797970000000000000000000000000000000000C896
      6200CA986500CA976500CA976500CA976500CA976400C9976400C9976400CA98
      6500C89562000000000000000000000000000000000000000000BEC3D2008693
      BA009EA5BD00C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300D8D8D8000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000095959500BFBFBF00C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C4C4
      C400C5C5C500C2C2C20095959500000000009E9E9E007878780058585800C795
      6100F9F7F600F9F1EC00F9F1EB00F8F0E900F7EDE600F4EAE100F2E8DE00FAF8
      F600C794610024242400494949009292920000000000000000002C4BA500355D
      AF002142AB00DCDCDC00D8D8D800D4D4D400D2D2D200D1D1D100D3D3D300D1D1
      D100CBCBCB00CDCDCD00C7C7C700C3C3C30000000000DEB39100D59D7400D196
      6800CE926300CB8E5E00C98A5B00C7875600C3845200C3845200C3845200C384
      5200C3845200C3845200CE9F7A000000000000000000BCBCBC00EFEFEF00FBFB
      FB00FCFCFC00FCFCFC00FCFCFC00F9F9F900F6F6F600ECECEC00D8D8D800E0E0
      E000FFFFFF00F7F7F700C7C7C700000000006B6B6B00A7A7A700B5B5B5008181
      8100AFACAA00C5C0BD00C5C0BD00C5C0BD00C5C0BD00C5C0BD00C5C0BD00ADAA
      A8002C2C2C00B5B5B5009B9B9B002323230000000000CECECE00C4C6CA00C0C6
      CC002143AC00FDFDFD00FBFBFB00F8F8F800F4F4F400EDEDED00D5D5D500E9E9
      E900FFFFFF00FFFFFF00FFFFFF00C3C3C30000000000D7A17500F8F2ED00F7F0
      EA00F6EDE600F4EAE200F3E7DE00F1E4DB00F0E2D800F0E2D800F0E2D800F0E2
      D800F0E2D800F0E2D800C58B5E000000000000000000C9C9C900FBFBFB00FBFB
      FB00FBFBFB00FBFBFB00FBFBFB00F8F8F800F3F3F300EBEBEB00DBDBDB00FDFD
      FD00E2E2E200FFFFFF00CCCCCC000000000070707000B5B5B500B5B5B5009595
      95008181810081818100797979006E6E6E006161610052525200434343004242
      42006E6E6E00B5B5B500B5B5B5002525250000000000000000006379B300618F
      BF002246AE00FAFAFA00FAFAFA00F6F6F600F3F3F300EEEEEE00F3F3F300CACA
      CA00E6E6E600FBFBFB00FCFCFC00C3C3C30000000000D9A47A00F9F3EE00EBD2
      BE00FFFFFF00EBD3BF00FFFFFF00FFFFFF00FFFFFF00EAC7AD00FFFFFF00FFFF
      FF00FFFFFF00F0E2D800C68C5F000000000000000000C9C9C900FCFCFC00FBFB
      FB00FBFBFB00FBFBFB00AEAEAE00F9F9F900BEBEBE00E0E0E000DDDDDD00FCFC
      FC00FDFDFD00E0E0E000CBCBCB000000000075757500BBBBBB00BBBBBB008D8D
      8D00D4D4D400B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900D3D3
      D30083838300BBBBBB00BBBBBB002A2A2A0000000000CECECE00C4C6CA00C0C6
      CC002249AE00FAFAFA00FAFAFA00F8F8F800F4F4F400F1F1F100FBFBFB00F2F2
      F200CACACA00E6E6E600FCFCFC00C3C3C30000000000DDA87E00F9F3EF00EBD0
      BA00EBD0BB00EBD0BB00EBD0BB00EBD0BB00EBD1BD00EACDB500EACDB500EACD
      B500EACDB500F0E2D800C68A5C000000000000000000C9C9C900FCFCFC00FBFB
      FB00FBFBFB00FBFBFB00AEAEAE00FAFAFA00E8E8E800BABABA00E0E0E000DFDF
      DF00DDDDDD00DBDBDB00C7C7C700000000007A7A7A00D7D7D700D7D7D7009797
      9700D8D8D800BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00D7D7
      D7008E8E8E00D7D7D700D7D7D7003F3F3F000000000000000000647CB3006392
      C100234BAF00F9F9F900F9F9F900F9F9F900F6F6F600F3F3F300FAFAFA00FAFA
      FA00F2F2F200C9C9C900E8E8E800C3C3C30000000000DFAA8200F9F3EF00EACE
      B700FFFFFF00EBD0BB00FFFFFF00FFFFFF00FFFFFF00EACFBA00FBF6F200FFFF
      FF00FFFFFF00F0E2D800C88D5F000000000000000000C9C9C900FCFCFC00FBFB
      FB00FCFCFC00FCFCFC00AEAEAE00FAFAFA00F8F8F800BCBCBC00E5E5E500F6F6
      F600F3F3F300EFEFEF00C8C8C800000000007E7E7E00F9F9F900F9F9F900ABAB
      AB00DFDFDF00CBCBCB00CBCBCB00CBCBCB00CBCBCB00CBCBCB00CBCBCB00DFDF
      DF00A3A3A300F9F9F900F9F9F9006161610000000000CECECE00C4C6CA00C0C6
      CD00234EB100FAFAFA00F9F9F900F8F8F800F7F7F700F6F6F600FAFAFA00FAFA
      FA00FAFAFA00F2F2F200D1D1D100C1C1C10000000000E1AE8700FAF4F000EACB
      B200EACCB300EACCB300EACCB300EACCB300EACEB700E8C7AC00E8C7AC00E8C8
      B000E8C8AE00F0E2D800C48654000000000000000000C9C9C900FCFCFC00FCFC
      FC00FCFCFC00CBCBCB00AFAFAF00FBFBFB00F9F9F900E8E8E800C2C2C200FBFB
      FB00FAFAFA00F8F8F800C8C8C8000000000084848400FCFCFC00FCFCFC00CBCB
      CB00F2F2F200F2F2F200F2F2F200F2F2F200F2F2F200F2F2F200F2F2F200F2F2
      F200C6C6C600FCFCFC00FCFCFC00717171000000000000000000657FB5006494
      C2002451B200FAFAFA00F8F8F800E09F7300DD9D7100DC9A6E00DA996B00D998
      6A00D4936A00EAEAEA00ECECEC00C3C3C30000000000E3B18C00FAF6F100EAC9
      AE00FFFFFF00EAC9B000FFFFFF00FFFFFF00FFFFFF00E8C7AC00FFFFFF00FFFF
      FF00FFFFFF00F1E5DB00C68655000000000000000000C9C9C900FCFCFC00FCFC
      FC00FCFCFC00F5F5F500CBCBCB00EEEEEE00CACACA00C7C7C700B8B8B800FFFF
      FF00FEFEFE00FCFCFC00C9C9C9000000000096969600D2D2D200E8E8E8007D7D
      7D007D7D7D007D7D7D007D7D7D007D7D7D007D7D7D007D7D7D007D7D7D007D7D
      7D007D7D7D00E8E8E800C4C4C4006C6C6C0000000000CECECE00C4C6CA00C0C7
      CD002552B200FBFBFB00FAFAFA00F8F8F800F8F8F800F8F8F800F7F7F700F3F3
      F300F2F2F200F0F0F000EEEEEE00C6C6C60000000000E5B48F00FAF6F200E9C6
      AA00E9C6AC00EAC7AC00E9C7AD00E9C9AE00E9C9B000E8C7AC00E9C9B000E8C8
      B000E8CCB500F2E7DE00C88A59000000000000000000C9C9C900FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FBFBFB00F7F7F700F7F7
      F700FFFFFF00FCFCFC00C9C9C90000000000D7D7D7009A9A9A00CCCCCC00C78B
      4E00F9F4ED00FEE8D800FEE8D700FDE5D300FCE4D100FAE0C700F9DDC300FAF4
      ED00C7854A00C3C3C30074747400C7C7C70000000000000000006682B5006596
      C3002555B400FAFAFA00FAFAFA00E0A27600E0A07600E0A07400DF9E7300DC9C
      7200DC9B6F00F2F2F200F6F6F600C3C3C30000000000E7B79400FBF7F400E9C3
      A600FFFFFF00E8C4A900FFFFFF00FFFFFF00FFFFFF00E8C7AC00FFFFFF00FFFF
      FF00FFFFFF00F7F1EB00CB8F5F0000000000000000000000DC001313F3003B3B
      E9003333E8002D2DE7002828E3002323E1001E1EDF001B1BDD001717DC001414
      DB001111DC000404ED000000DC000000000000000000C9C9C90087878700C589
      4C00F9F4EF00FEE7D700FDE7D500FCE6D200FBE1CC00F8DCC200F6DABD00FAF4
      EF00C483480060606000B7B7B7000000000000000000CECECE00C4C6CA00C0C7
      CD002656B500F9F9F900F9F9F900E1A37800EAC0A300EAC0A200EABFA100EABE
      A000DF9E7100F4F4F400F7F7F700C3C3C30000000000E9BA9800FBF7F400E9C3
      A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3
      A600E9C3A600FBF7F400CE93640000000000000000000000DC000F0FEB002828
      BD001C1C98001F1FBC001E1EDD001B1BDF001616DE001212D7000D0DB5000808
      92000606B4000101E6000000DC0000000000000000000000000000000000C68C
      4F00F9F4F000FCE6D300FDE7D300FBE3CD00FAE0C800F5D6BB00F3D4B500F8F4
      F000C4854A0000000000000000000000000000000000000000006783B7006699
      C4002659B700F8F8F800F8F8F800E1A57A00E1A37800E1A37700E0A27600E0A0
      7600E0A07400F4F4F400FAFAFA00C3C3C30000000000EBBD9B00FBF7F400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FBF7F400D1976A0000000000000000000000DC000B0BDA00A1A1
      AE00E0E0E0009F9FAE001414CE001212E1000E0EE1000909CC009E9EAE00E0E0
      E0009E9EAE000000D7000000DC0000000000000000000000000000000000C88C
      5000F9F5F100FCE3CF00FCE4CF00FAE1CA00F9DDC400F4E9DF00F7F2EC00F5EF
      E900C380480000000000000000000000000000000000CECECE00C4C7CA00C0C7
      CD00265BB700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F5F5F500F5F5
      F500F5F5F500F3F3F300FAFAFA00C3C3C30000000000ECBF9E00FBF7F4009CD5
      A50098D3A10094D09D0090CE98008BCB930087C98E0082C689007EC384007AC1
      800076BE7C00FBF7F400D49B6F0000000000000000000000DC000707D200C4C4
      D600E3E3E300C4C4D5000303D0000202ED000202ED000101CF00C5C5D600E3E3
      E300C4C4D6000000CF000000DC0000000000000000000000000000000000C88D
      5200F9F5F100FCE3CD00FBE3CD00F9E0C800F8DCC200FDFBF800FCE6CD00E2B6
      8400D3A5810000000000000000000000000000000000000000006787B900679A
      C500275EB800F7F7F700F7F7F700F7F7F700F7F7F700F5F5F500F4F4F400F4F4
      F400F4F4F400F2F2F200FBFBFB00C3C3C30000000000EFC5A800FBF7F400FBF7
      F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7
      F400FBF7F400FBF7F400D8A2780000000000000000000000DC000000C700B5B5
      CB00E6E6E600B3B3C9000000C7000000DC000000DC000000C700B8B8CE00E6E6
      E600B6B6CD000000C7000000DC0000000000000000000000000000000000C588
      4C00F7F2EC00F8F4EE00F8F3ED00F8F3ED00F8F2EC00F2E6D700E2B27D00DB95
      68000000000000000000000000000000000000000000CECECE00C4C7CA00C1C7
      CD00275FB800FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00C3C3C30000000000F3DDCD00F0C7AB00EDC0
      9F00EBBE9D00EBBC9A00E9BA9600E7B79300E6B59000E4B28C00E2AF8800E0AC
      8400DDA98000DCA57D00E0B4940000000000000000000000000000000000C0C0
      C000A6A6A600BCBCBC0000000000000000000000000000000000C9C9C900AFAF
      AF00C0C0C0000000000000000000000000000000000000000000000000000000
      0000D5A87A00C88C5000C88C4F00C9905400CA8F5400C5894D00D9AC8A000000
      0000000000000000000000000000000000000000000000000000648BC2004978
      BE002861BA00C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300D8D8D8000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AFAFAF00A4A4
      A400000000000000000000000000000000000000000000000000000000000000
      0000A7A7A700ABABAB0000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000B7B7B700DBDB
      DB00B8B8B700B9A892009A7F5E0084633A0084633A009A7F5E00B9A79100B6B6
      B600D9D9D900B5B5B50000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00800000000000000000000000000000000000000000000000D3D3
      D300C3C0BE009C6B3B00A66C3500AE6F3700AE6F3700A66C3500A1764A00C5C4
      C300C6C6C5000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000CCBCA900A68C
      6F00AF784400BB8C5E00C2937100C4917400C38F7100BF906C00B88A5D00B486
      5900A4896A00CCBCA90000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000A6845A00B37D
      4600C2997100D8AA8900EFDFCF00FAF6F300FAF5F300EFDFD100D7A78500BE94
      6C00B37D4600A6845A0000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF0080000000800000008000000080000000800000008000
      00008000000080000000FFFFFF00800000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      00008000000080000000000000000000000000000000CCB69C00B0804A00C69B
      6F00D9AA8800FFFEEB00FFFAEE00FFFDF200FFFEF200FFFCEF00FFFDEB00D9A3
      7A00C2996C00B0804A00CCB69C00000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF0080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000FFFFFF0080000000000000000000000000000000BF9C7300BF8F5800CDA3
      8100F0DBC100FFF7E600FAF2E300C5C0B600F1EDDE00FFFCE800FFF5DF00EFD4
      AF00C8997200BF8F5800BF9C7300000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      00008000000080000000000000000000000000000000BC8F5A00C99C6600CF9F
      8000FAF3E200FDF6E900F2F0E3008D8C8400817F7700D2CFC200FFFBEB00FAEC
      CC00C7906D00C99C6600BC8F5A00000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080000000000000000000000000000000C6976000CEA67100D1A5
      8900FAF6E900FDF8EE00FFFFF90081807900B1AEA400817F7700C9C6BA00FAF0
      D300C9967200CEA67100C6976000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000FFFFFF008000
      000080000000800000008000000080000000800000008000000080000000FFFF
      FF00800000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080000000000000000000000000000000D7B08200D3AC7500D9B7
      9800F1E3D600FEFBF500F5F5F3009F9E9500F0F0E900F8F8F200BEB9AD00F0DA
      C200D2AA8700D3AC7500D7B08200000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000FFFFFF008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080000000000000000000000000000000D2C6B000D3AD7700DFC4
      9A00DEBDAA00FFFFFF00F0F0EE00E7E5DA00FFFFF700FFFFF700FFFEF300DCB4
      9800DBC09600C2AA7E00DDC9AD00000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000800000000000000000000000BCE1F1002DA8DD0036A0C700DEBF
      8A00E2C9A700DFBFAE00F1E3DC00F3F1EC00F4F1EB00F1E2D900DCBAA300DFC3
      9E008CB1A9003DA8D2003BACDC00000000000000000080000000800000008000
      00008000000080000000FFFFFF00800000008000000080000000800000008000
      0000FFFFFF008000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000FFFFFF008000000000000000000000007ECCED0085D4F2006AC6E9003DA5
      C700E2C79200E6D1A900E0C2A600D5AE9600D5AB9200DEBDA000E4CFA600BFC1
      9E0048B3D700ACE3F60048BBEA00000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000080000000800000008000
      00008000000080000000800000008000000080000000FFFFFF00800000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      00008000000080000000000000000000000080D0F0006DCEF200B5E8F9006ACA
      EC0043AECE00ECC48800E9CB9400E7D09D00E7D09D00E9CB9400DEC28E003AAD
      D20086D4F0007ED3F30030B7EC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000071CFF3006CD0F400BFEC
      FA0069CFF20074C2D400F9CB9400FAC07D00FAC07D00F9CB940079C3D30074D2
      F20085D8F60034BDF10000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007BD6F5002DC1
      F50033C3F5000000000000000000000000000000000000000000000000002DC1
      F50034C3F5000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084B094002573
      4100196B37002573410084B09400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CDCDCD00B6B6B600ACACAC00A9A9A900A7A7A700A4A4A400A6A6A600BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EC09F600CC15E800A524
      D6008030C5006339B800165B93001D5197000000000000000000000000008686
      860081818100C6C6C60000000000000000000000000088B29700288C530064BA
      8D0095D2B20064BA8D00288C530081AE91007AB98000579E5E00619C66004678
      4A0059755B007C7C7C0087878700898989008B8B8B008C8C8C00696969005C7D
      5F0048864E00609964003A7B3E00598A5B000000000000000000000000000000
      0000BABABA00FAFAFA00FAFAFA00FAFAFA00FAFAFA00FAFAFA00FAFAFA00A9A9
      A900000000000000000000000000000000009999990071717100545454005151
      51004F4F4F004C4C4C004A4A4A00474747004545450025679D003274A8003D7C
      AF004784B5004E8ABA003E7EAD002050980000000000CBCBCB0090909000ACAC
      AC00C9C9C900A6A6A6007E7E7E0079797900757575001E6C3B0062BA8B0060BA
      87000000000060B9870067BC8F0020703D006AB9730066B4700072BF7D0062B4
      6D005E916200E5E5E50082828200A9A9A900ACACAC0089898900E2E2E20076BC
      7E0084CA8F0074C1800055A45E00337638000000000000000000000000000000
      0000B9B9B900FAFAFA00EBEBEB00CFCFCF00CFCFCF00EAEAEA00FAFAFA00A6A6
      A60000000000000000000000000000000000000000000000000058585800A2A2
      A200A2A2A200A3A3A300A4A4A400A4A4A400A5A5A5002F6FA50078ABD20078AB
      D30073A7D10069A0CD00407FAE0023529A0000000000CECECE0000000000CFCF
      CF009A9A9A00CBCBCB00000000000000000000000000317B4C009CD4B6000000
      0000000000000000000095D2B200196B370000000000C3E3C7007CBA8200528E
      5800A2C1A400F0F0F0007E7E7E00A4A4A400A6A6A60085858500F0F0F000A1D6
      A80059AF62006AAE7200A0C8A400000000000000000000000000000000000000
      0000BCBCBC00FAFAFA00E9E9E900E9E9E900E9E9E900E8E8E800FAFAFA00A9A9
      A9000000000000000000000000000000000000000000000000005C5C5C00A0A0
      A0003C734000A2A2A200A3A3A300A3A3A300A4A4A4003674AA007DAFD4005B9A
      C9005495C7005896C8004180AE0026549D000000000000000000C3C3C3009797
      9700929292008D8D8D0088888800848484007F7F7F0046875E0090D3B10092D6
      B1000000000065BC8C0067BC8F0020703D000000000000000000000000008B8B
      8B00F0F0F000EFEFEF007B7B7B009E9E9E00A1A1A10081818100EFEFEF00F4F4
      F400717171000000000000000000000000000000000000000000000000000000
      0000C0C0C000FAFAFA00DEB08400ECC59E00ECC59E00ECC59E00FAFAFA00ACAC
      AC00000000000000000000000000000000000000000000000000606060003A77
      3F003D764100A1A1A100A2A2A200A2A2A200A3A3A3003D79B00082B3D700629F
      CC005A9AC9005E9BCA004381AF002C58A0000000000000000000000000000000
      00000000000000000000000000000000000000000000A8C7B30061AB810095D4
      B400BAE6D0006ABB8F002D8F570081AE91000000000000000000000000009090
      9000F1F1F100EFEFEF0077777700999999009C9C9C007C7C7C00EFEFEF00F4F4
      F400767676000000000000000000000000000000000000000000000000000000
      0000C3C3C300FAFAFA00DEB08400F4DBC200F4DBC200EEC8A200FAFAFA00B0B0
      B00000000000000000000000000000000000000000000000000039763E004D95
      540049915000286E2D00266A2A002366270021632500457EB40088B7D90067A3
      CF00619ECC00639FCC004583B100315CA400000000000000000000000000A1A1
      A1009D9D9D0098989800939393008F8F8F008A8A8A00858585006E8A78005A93
      6F004F8E660043835A0099BDA600000000000000000000000000679CC3008D8F
      9100F6F6F600EFEFEF0074747400767676007777770078787800EFEFEF00F4F4
      F4008A8B8D004E618E00000000000000000080B1FF007AADFF0065A0FF000000
      0000BFC4CB00FAFAFA00DEB08400DEB08400DEB08400DEB08400FAFAFA00ACB2
      BC0000000000428EFF003C8CFF004D95FF00000000005A6D5F00569D5D0080C6
      88007BC3830077C17F0072BE79006FBC7500246728004C84BA008DBBDB006EA8
      D10066A6D1005FB4DF004785B1003760A9000000000000000000D6D6D600CACA
      CA00DADADA00B2B2B200D7D7D700AAAAAA00D3D3D300A3A3A300D0D0D0009B9B
      9B00CCCCCC00797979000000000000000000000000003B85BB005796C2003F80
      B300DCDEE000EDEDED00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00DFE1
      E3002D4B81003A5F900027407A00000000007BB1FF00A1C6FF006BA5FF000000
      0000D2D4D600FAFAFA00FAFAFA00FAFAFA00FAFAFA00FAFAFA00FAFAFA00C9CA
      CA00000000003A88FF0071ABFF003486FF0085588A005EA566008BCC94007DC5
      860073C07C006EBD770069BB710075BF7C00276C2C005489BF0094BFDD0075AD
      D40063B8E1004BD4FF00428BB8003D65AD000000000000000000B0B0B000F4F4
      F400B9B9B900ECECEC00B2B2B200EAEAEA00ABABAB00E7E7E700A4A4A400E6E6
      E6009C9C9C007E7E7E000000000000000000629BCA005395C6007AAFD3005797
      C4004387BA00CDCFD000EEEEEE00EFEFEF00EFEFEF00EFEFEF00D9DADB003864
      970044709F005C8CB1003C649400566B970084B5FF00A8CAFF0076AEFF000000
      0000DFE5ED00C9D3E300CACACA00C5C5C500C2C2C200C0C0C000B5BECB00D4D7
      DC00000000003E89FF0073AAFF003787FF0000000000617367005FA667008DCD
      960089CB920084C88D0080C688007BC383002A7030005A8EC40098C3E0007CB3
      D70074AFD6005EC4ED004B88B300456AB20000000000B8B8B800D2D2D200C0C0
      C000DEDEDE00BABABA00DBDBDB00B3B3B300D7D7D700ACACAC00D4D4D400A4A4
      A400D0D0D000898989000000000000000000000000003F85BE005293C60079AE
      D3005597C4004287BA00CACBCC00EDEDED00EFEFEF00D9DBDC003D76A6004D80
      AE006B9ABD004775A200395D9100000000009CC5FF00A9CAFF0080B3FF000000
      0000B7D4FF009BC2FF009CC3FF00D7E7FF00D5E6FF008EBAFF0085B5FF00A9CB
      FF00000000003F89FF0070AAFF005396FF00000000000000000047894F0060A7
      69005DA4650037823E00347E3B00317937002E7534006092C9009EC7E20083B8
      DA007DB4D7007EB3D7004F89B4004B6FB70000000000BCBCBC00C6C6C600EFEF
      EF00C1C1C100EEEEEE00BBBBBB00ECECEC00B3B3B300EAEAEA00ACACAC00E8E8
      E800A5A5A5009A9A9A00000000000000000000000000000000003E81BE005091
      C60076ADD3005495C6004189BC00D2D4D500D2D4D5004183B400558DBB0077A5
      C7005084B2003E70A3000000000000000000C1DAFF00A2C5FF0094BFFF000000
      00000000000089B9FF0088B8FF0076ACFF0071ABFF0077ACFF006DA8FF000000
      0000000000005497FF0064A2FF0093BEFF000000000000000000777777004D90
      54003D8A45009B9B9B009C9C9C009D9D9D009D9D9D006696CC00A2CBE30089BD
      DC0083B9DA0084B9DA00518BB5005274BC00C2C2C200D8D8D800E3E3E300C7C7
      C700E1E1E100C2C2C200DFDFDF00BBBBBB00DBDBDB00B4B4B400D8D8D800ACAC
      AC00D4D4D400ABABAB00E0E0E000000000000000000000000000000000003C80
      BC004D90C40073ABD3005294C6003B83BA003C85B9005695C2007DACCF005591
      BC004380B100000000000000000000000000EDF4FF0097C1FF00AACAFF008EBD
      FF000000000000000000BBD6FF0095C0FF008FBBFF00B1D1FF00000000000000
      00005698FF0078ADFF004990FF000000000000000000000000007A7A7A009899
      9800529159009A9A9A009B9B9B009C9C9C009C9C9C006C9AD000A7CEE5008FC1
      DF0089BDDC008BBDDC00538DB6005A79C200C4C4C400FCFCFC00F9F9F900F9F9
      F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F3F3F300A7A7
      A700F1F1F100D8D8D8009D9D9D00CECECE000000000000000000000000000000
      00003C7EBB004B8DC30070AAD20071AAD20074ACD2007AAFD3005697C4004589
      BB000000000000000000000000000000000000000000C7DDFF00A9CDFF00A9CC
      FF0091BDFF0000000000000000000000000000000000000000000000000068A4
      FF007DB0FF0070A8FF009FC4FF000000000000000000000000007D7D7D009999
      9900999999009A9A9A009A9A9A009B9B9B009B9B9B006F9DD300AAD1E700ABD1
      E70098C7E10091C2DE00568FB700607EC600C5C5C500C5C5C500C3C3C300C0C0
      C000BDBDBD00BABABA00B7B7B700B3B3B300AFAFAF00ABABAB00A7A7A700A2A2
      A200C5C5C500FBFBFB00E4E4E400A3A3A3000000000000000000000000000000
      0000000000003A7BB900488BC2006AA6D0006EA9D1005193C6004389BF000000
      0000000000000000000000000000000000000000000000000000B9D5FF00A9CC
      FF00B0D1FF009BC2FF008DB9FF008ABAFF0083B4FF007DB2FF0084B5FF0092BF
      FF0080B3FF008FBCFF0000000000000000000000000000000000808080007E7E
      7E007C7C7C007A7A7A00777777007575750072727200719ED4006F9ED60087B2
      DC00ABD3E800A9D0E6005890B8006782CB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A3A3A3009E9E9E009A9A9A00000000000000000000000000000000000000
      00000000000000000000427FBB003577B700367BB9004788C100000000000000
      000000000000000000000000000000000000000000000000000000000000D4E5
      FF009FC4FF00ACCBFF00B4D2FF00B7D3FF00B4D2FF00A8C9FF0099C3FF0080B2
      FF00C2DBFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008488
      DC006D9CD40085B1DA005A91B9006D87CF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CADFFF00B0CEFF0099C2FF0095BEFF00A6C9FF00BED9FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B154E8006C98D300708DD200000000000000000000000000B1E0
      F200000000000000000000000000000000000000000000000000000000000000
      0000ABD2ED000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DBDBDB00616161006B6B6B00707070006E6E6E0000000000000000007373
      7300707070006B6B6B0061616100000000000000000000000000000000000000
      000000000000616161006B6B6B00707070006E6E6E00C1C1C100D3D3D3007373
      7300707070006B6B6B00616161000000000000000000000000000000000032B0
      DF0030ADDE0087CEEB00000000000000000000000000000000009ACDEB002290
      D3000D81CC0000000000000000000000000000000000DFB49300D59D7400D196
      6800CE926300CB8E5E00C98A5B00C7875600C3845200C3845200C3845200C384
      5200C3845200C3845200D0A17D000000000000000000B4692B00B3682B009C5E
      2A005D5148008F8B8700AAA5A100AEAEAE009797970071717100787878009797
      9700AEAEAE00AAA5A1008F8A8700696969000000000000000000000000000000
      00005857680089889300A09FAE00AEAEAE009797970071717100787878009797
      9700AEAEAE00B0B0B000949494006969690000000000000000000000000044B8
      E30050CBEF0039B7E5002AA9DD000000000000000000269ED9002AA3DD0039AE
      E500198CD10000000000000000000000000000000000D7A17500F8F2ED00F7F0
      EA00F6EDE600F4EAE200F3E7DE00F1E4DB00F0E2D800F0E2D800F0E2D800F0E2
      D800F0E2D800F0E2D800C58B5E000000000000000000B66A2D00BDD0BF008690
      87006D6E6D00D3D3CE0081818100444444004646460051515100515151004646
      4600444444006A6F6900C4C4C40071717100000000000000000000000000423F
      A20066666F00D3D3CE0049487B00444445004646460051515100515151004646
      46004545450081818100C4C4C400717171000000000000000000000000005BC3
      E7004DCAEE0054CEF10050C8EF0040BAE80039B5E50046BDEB0044BAEB003EB3
      E8002C9AD60000000000000000000000000000000000D9A47A00F9F3EE00EBD2
      BE0000000000EBD3BF00000000000000000000000000EAC7AD00000000000000
      000000000000F0E2D800C68C5F000000000000000000B76B2D00EAF1EC00566B
      590080828000D3D3CE00A5C2AA0048484800BDBDBD00CECECE00C2C2C200ADAD
      AD004043410083B48900C4C4C4008686860000000000000000006262F3005455
      880083838500D3D3CE003C38E60047474700BDBDBD00CECECE00C2C2C200ADAD
      AD0047464600F8F8F800C4C4C400868686000000000000000000000000007AD0
      EC0049C8EC0049CCF10031C3ED0042C4EE0046C3ED002CB6EA0026B1E8003CB4
      E70046ABDD0000000000000000000000000000000000DDA87E00F9F3EF00EBD0
      BA00EBD0BB00EBD0BB00EBD0BB00EBD0BB00EBD1BD00EACDB500EACDB500EACD
      B500EACDB500F0E2D800C68A5C000000000000000000B96D2E00C9C4E600C0C0
      C0007B7B7B00D3D3CE00516755004C4C4C006565650092929200797979006565
      65004B4C4B0088888800C4C4C4007B7B7B00000000006767F8009599F2008285
      B40073747A00D3D3CE00525183004C4C4D006565650092929200797979006565
      65004C4B4B007D767200C4C4C4007B7B7B000000000000000000000000009BDC
      F10044C6EA0057D2F20027C2ED0023BDEC001FB7EA001BB3E90036B9EA003AB3
      E60067BDE40000000000000000000000000000000000DFAA8200F9F3EF00EACE
      B70000000000EBD0BB00000000000000000000000000EACFBA00FBF6F2000000
      000000000000F0E2D800C88D5F000000000000000000BB6E2F00ACABFD000000
      00009E9E9E0091919100E8E8E800DDDDDD00C1C1C1008088820077897A00D4D7
      D500DDDDDD00C4C4C400919191009E9E9E0000000000A6A7FC006666F9008283
      EF007476970091919100E8E8E800DDDDDD00C1C1C1008D858000937E7300D9D8
      D700DDDDDD00C4C4C400919191009E9E9E0000000000000000000000000046C2
      E60059D5F20046D0F20029C4EE0025C0ED0022BBEB001DB6E90021B4E90046BD
      EB002AA7DB0000000000000000000000000000000000E1AE8700FAF4F000EACB
      B200EACCB300EACCB300EACCB300EACCB300EACEB700E8C7AC00E8C7AC00E8C8
      B000E8C8AE00F0E2D800C48654000000000000000000BD6F3000B2B0FF002825
      FF0000000000BBBBBB008D8D8D009E9E9E007E857E0065A66E0062AF6C008489
      85009E9E9E008D8D8D006664B900F7F7F700ABD1AE00B1D3B400EEF0FA00AAAA
      FC006262F1007475B40082828C009E9E9E00847D7900C89B7C00D58E6500887C
      76009E9E9E00898481009C877C000000000000000000000000004DC8E9004ACE
      ED005EDBF50030CDF1002CC8EF0027C3EE0024BEEC0020B8EA001CB4E90049C0
      EC0037B2E4002DA8DD00000000000000000000000000E3B18C00FAF6F100EAC9
      AE0000000000EAC9B000000000000000000000000000E8C7AC00000000000000
      000000000000F1E5DB00C68655000000000000000000BE713000DFD9E700120E
      FD008280FD00EFA97B00E0570000E0580400E0580400F4C5AA00000000000000
      000000000000000000002825F900000000006FB6760090BF93004F9C5500A6CB
      A900ECEFF700B2B2FC006261F800E0DFFD00CE8D6500E4B08B00E39C6D00DD85
      5400E2966700DA976D00AD6E4C00000000000000000054CEEB004CD2EE0063E1
      F60041D6F40032CFF2002ECBF0002AC6EF0026C1ED0022BCEB001FB7EA0020B4
      E90047BEEC0036B2E40032ABDD000000000000000000E5B48F00FAF6F200E9C6
      AA00E9C6AC00EAC7AC00E9C7AD00E9C9AE00E9C9B000E8C7AC00E9C9B000E8C8
      B000E8CCB500F2E7DE00C88A59000000000000000000C0723200000000006B68
      FC00201DF900BC544300EDA5730000000000E88E5300DF651800EEB18B000000
      000000000000615FFA003A37F7000000000060B46900CAE8C800AFD9AB0092BF
      940048954D009BC19D00F5F4F900F6F2F500D4966B00E7B79300E7A67700E090
      5D00DE8E5C00E6AD8800A75B3200000000005ED3EE004DD5EF0058DCF2005EDE
      F50060DEF5005FDCF60048D4F3002DC9EF0029C4EE0035C4ED0050C9EF004CC4
      EE0045BEEB003DB7E70033B0E20036ADDE0000000000E7B79400FBF7F400E9C3
      A60000000000E8C4A900000000000000000000000000E8C7AC00000000000000
      000000000000F7F1EB00CB8F5F000000000000000000C2733200000000000000
      00003A2BEB004936E200000000000000000000000000EBA06C00DF742700EAA8
      7800E2E1FE003633F600B99ECA000000000064BA6E00B6E0B1007BCC6F0092D2
      8900ADD9A90089B88B0083B38600F2DAC800D38D5A00EFC8A900E6A67300E29B
      6700E2986600E7B38F00B0663A000000000000000000B6EBF7007FDCF1005BD0
      ED0042C7E90049CEED005BD9F40047D3F2003ACBF00055CFF1003EBFE80035B7
      E2004BBCE4006EC8E900A3DBF1000000000000000000E9BA9800FBF7F400E9C3
      A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3
      A600E9C3A600FBF7F400CE9364000000000000000000C373330000000000EFB5
      8400B1636A003E38F5008B8AFA00000000000000000000000000EEB88E00DF82
      3900E0843C00E0894100DF883F000000000084CD8F00BADFB8007ACC6D0066C6
      590072C86600A8DAA30068A86D00D0E3D100E1AC8300E6B58E00F0CCAC00E5A6
      7100E9B18400E3AF8800C2815B00000000000000000000000000000000000000
      0000000000009CE2F30049CEED005DD9F40059D6F30043C5EA0079D1ED000000
      00000000000000000000000000000000000000000000EBBD9B00FBF7F4000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FBF7F400D1976A000000000000000000C474340000000000E182
      3100E9A56B009A99FA004441F400D3D3FC000000000000000000000000005552
      F2005650EF00EFC9A5000000000000000000B7E3BD00B3DAB500A2D89A006DCA
      5F0066C6580080CC7500A3CEA30063A76900F7EBE000D9946000F2D1B200EBB9
      8D00F0C9AA00D89C7000DCB39B00000000000000000000000000000000000000
      0000000000000000000047CAEA0056D6F20059D6F3003AC0E600000000000000
      00000000000000000000000000000000000000000000ECBF9E00FBF7F4009CD5
      A50098D3A10094D09D0090CE98008BCB930087C98E0082C689007EC384007AC1
      800076BE7C00FBF7F400D49B6F000000000000000000C5753400F9E7D700DE8A
      410000000000000000007977F4005552F2007674F5006A68F2005654F0006765
      F20000000000000000000000000000000000000000007BCC8800BEE1BE0094D4
      89006ECA62006EC960009ED6970093C19600B1D4B300ECC5A500E7B48E00F3D3
      B500E9BB9800CD865300FBF5F200000000000000000000000000000000000000
      00000000000000000000BCECF70048CEED0048CDED009BE0F300000000000000
      00000000000000000000000000000000000000000000EFC6A800FBF7F400FBF7
      F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7
      F400FBF7F400FBF7F400D8A378000000000000000000C6763400E8CBB200E9B8
      8C00000000000000000000000000A6A5F6006E6CF1007674F200C2C1F9000000
      0000000000000000000000000000000000000000000000000000A0D5A800BAE0
      BB00A7DAA0007DCE70007FCD7300B0D9AD0057A85E00F1F2E800E1A57300EBC2
      9E00DDA27300F0DAC90000000000000000000000000000000000000000000000
      000000000000000000000000000058D1EC0047CBEA0000000000000000000000
      00000000000000000000000000000000000000000000F7E1D200F1C8AC00EDC0
      9F00EBBE9D00EBBC9A00E9BA9600E7B79300E6B59000E4B28C00E2AF8800E0AC
      8400DDA98000DCA57D00E2B696000000000000000000C6763400F4DDC9000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000089D3
      9500B4DCB700BCE0BA00B9E1B500CEEACB00A4CEA60095C99A00F3DAC400E3AB
      7C00F6E6D8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D8F5FB00C1EEF80000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDE7C40092D49C006CC3790065BD710080C68900ACD7B000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000A00000000100010000000000000500000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      FBFFFFFFFFFF0000FBBFF8FFE0070000FB9FF87FE0070000FB8FF83FE0070000
      FB81F81FE0070000FB83F80FE0070000FB87F80FE0070000FB8FF81FE0070000
      FB9FF83FE0070000803FF87FE0070000FBFFF8FFE0070000FBFFFFFFFFFF0000
      FFFFFFFFFFFF0000FFFFFFFFFFFF000087FFFFFFFFFFFFFF03FFFFE7FFE7FFE7
      01FFFFC3FFC3FFC300FFFF83FF83FF83007FFF03FF03FF03803FC003C003C003
      C03F800780078007E03F800F800F800FF00180038003801FF80080038003801F
      FF0080038003801FFF00800F801F801FFF08800F801F801FFF07C01FC01FC01F
      FF07E07FE07FE07FFF87FFFFFFFFFFFF8007F81FFFBFFFFF0003E007FF3F07FF
      0003C003000303FF00038001000101FF80038001000000FFC00300000000807F
      C00300000003C03FC00300000003E01FC00300000003F00FC00300000003F807
      C00100000001FC03C00080010003FE01C00080010003FF01C000C0030003FF81
      C001E0070003FFC3E003F81F0003FFFF8000E1FFFFFFFFFF8000E0FFFFFFFFFF
      8000000FFC3FFFFF8001000FE00700008001000FE00700008001000FFC3F0000
      80010007E007000080010003E007000080010001FC3F000080310001F83F0000
      80010001F81F00008001000FF11F00008001000FE38F00008001000FE3C70000
      8001000FC7C7FFFFE3C7000FFFFFFFFFFC00FFFFF3FF9FFFFC00F007E1FF0FFF
      0000C001C0FF03FF00008001807F803F00008001003FC01F00008001001FC01F
      0000C001000FE0070000E0070007E0030000F00F8003E0030000F00FC001F003
      0003F00FE001F0010003F00FF003FC010003F00FF807FC010003F00FFC0FFE00
      0003F81FFE1FFFE00003FFFFFF3FFFF9FFFFFC3FFFFFFFFFFFCFFC1FC000F0C3
      00010003C000000100010001C000000100010000C000000100000000C0000001
      0000000000000001000100000000000300010001800000030001000380000003
      00030003C000000300030003C000000300030003C000000300030003C0000003
      00030003C000000300030003FFFF00038001E007C000FFFF80010000C0008001
      800100008000800180010000C0008001800100008000800180010000C0008001
      800100008000800180010000C0008001800100008000800180010000C0008001
      80018001800080018001E007C00080018001E007800080018001E007C0008001
      8001E00F80008001E3C7F01FC000FFFFFFFFFC00FFFFCFF38003FC008003C003
      8003FC008003E0078003FC008003C0038003E0008003C0038003E00080038001
      8003E000800380018003E0078003800180038007800380018003800780038001
      80038007800380018003801F800300018003801F800300018003801F80030001
      FFFF801FFFFF8003FFFFFFFFFFFFC7E7FFC1FFFFF00FFF80E3800000F00F0000
      80080000F00FC000A39C8001F00FC000C008E007F00FC000FF80E007F00FC000
      E001C00310088000C003800110080000C003000010088000800380011008C000
      8003C0031818C0000001E0070C31C0000000F00F87E1C0000000F81FC003C000
      FFF1FC3FE007FFE0FFFFFFFFF81FFFF8EFF7FFFFF061F801E3C780018000F000
      E18780018000E000E0078BB98000C000E007800180008000E0078B9990008000
      E007800188000001C0038BB9803D000180018001A119000100008BB9B3810001
      80018001A1C10001F81F9FF9A0E30001FC3F80018C0F8001FC3F80018E1FC003
      FE7F80019FFFE007FE7FFFFFFFFFF03F00000000000000000000000000000000
      000000000000}
  end
  object ImageList1: TImageList
    BlendColor = 15790320
    BkColor = 15790320
    Left = 914
    Top = 98
    Bitmap = {
      494C010106000800380010001000F0F0F000FF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      000000000000000000000000000000000000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F00095B0E300235C
      C2000543BC001F59C10086A6DD00F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F0008CABE1002866CA002177
      E6000579EA000164DD00074FBE0086A6DD00F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F000A2CAEE0076B2E6003E91
      DB00348CD900348CD900348CD900348CD900348CD900084DBC00639DF400187F
      FF000076F8000076EE000368E1001E59C000F0F0F000F0F0F000F0F0F000F0F0
      F000C04E1600D38C7000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F0004799DD00DEF1FA00A8DD
      F4009EDBF40096DAF3008ED8F30086D7F3007FD4F2000443BC00AECDFE00F0F0
      F000F0F0F000F0F0F000187FEF000543BC00F0F0F000F0F0F000F0F0F000F0F0
      F000C4591800CC713B00D38A6C00F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F0003B97DB00EFFAFE00A1E9
      F90091E5F80081E1F70072DEF60063DAF50054D7F4000C57C1008DB5F6004D92
      FF001177FF002186FF00408AEB00245CC200F0F0F000F0F0F000F0F0F000F0F0
      F000C9621A00DFA37500CF743C00D58C6B00F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F0003C9DDB00F2FAFD00B3ED
      FA00A4E9F90095E6F80085E2F70076DEF60065DBF5003C9BDE003875D2008DB5
      F700B8D6FE0072A8F5002D6CCB0094AFE200F0F0F000F0F0F000F0F0F000F0F0
      F000CD6E2300E1A87E00E0A67900D0773D00D38B6500F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F0003BA3DB00F6FCFE00C8F2
      FC00B9EFFB00ACECFA009CE8F9008BE3F7007CE0F6006CDCF6003F9CDE00165D
      C6000443BC001A59C1002176CB00F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000D2773500E4AF8700DFA17200E1A97C00D07A3F00D58B6300F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F0003BA8DB00FEFFFF00F8FD
      FF00F6FDFF00F5FCFF00F3FCFE00D8F6FC0094E6F80085E3F70076DFF60068DB
      F5005CD8F400D7F4FC003BA7DB00F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000D6844300E7B59000E0A37400E0A47700E2AB8100D37F4300D78A5E00F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F00039ADDB00E8F6FB0094D4
      EF0088CEEE0073C1E900C9E9F600F2FCFE00F3FCFE00F2FCFE00F0FCFE00EFFB
      FE00EEFBFE00FEFFFF003CAEDB00F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000DB8E5300EABB9900E3AA8000E3AB8100E4B18A00D6884B00CC743400F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F00040AEDC00F1FAFD0094DE
      F50093DCF40081D5F2006ACAED006CCBEA0085D3EF0080D2EF007AD0EF0076CF
      EE0072CFEE00E9F7FB003EB2DC00F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000E1976200ECC1A100E8B79200E9BB9900DD976100DFA47700F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F00041B4DC00F7FCFE008EE4
      F80091DEF5009FE0F500ACE1F600EFFBFE00F4FDFE00F3FCFE00F1FCFE00EFFB
      FE00EEFBFE00FAFDFF0058BCE000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000E2A06E00EEC7A800EDC2A300E3A47500E6B38D00F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F0003CB5DB00FDFEFE00FEFF
      FF00FEFEFF00FDFEFF00FEFFFF00EAF7FB006EC8E5006FC9E4006FC9E4006FC9
      E4007DCFE70084D0E800BAE5F200F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000E6A77900EFC8AD00E8B08700ECC4A600F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F00059C2E00061C3E20063C4
      E30063C4E30063C4E30062C4E30056C0E000EDF8FC00F3FAFD00F3FAFD00F3FA
      FD00F3FAFD00F3FBFD00FCFEFE00F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000EAAB8000E8A97D00F0CEB500F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000E9AF8500F3D1BB00F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000DDEE
      FB0057A7EB00469DE800DEEDFA00F0F0F000F0F0F000ACCCEF00488CD7008BB3
      E400EEF4FB00F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000E0EEE0008FC091003B8D3F00257A2900257729003B853F008FB99100E0EB
      E000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000E5F0E700A0C8A600569C5E003F8F49003C8D45004C95530098C19B00E1ED
      E300F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000E5E8F7009EA9E100546BC7003F59C0003A53BF004C67C20097A7DC00E1E6
      F500F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000ABD5F7001488
      E80032A1F3002A9AEF0089C1F000F0F0F000F0F0F0003789DC0037A1F2002488
      E3001769CA00ACC8EB00F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000B5D9
      B700318F350042A0520087CA9A009BD3AB009BD2AB0083C796003D974C00307C
      3400B5D0B600F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000C4DE
      C90057A06400419950007DC28F0096D0A60096CFA60078BE8900368D4200418D
      4800B9D5BC00F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000C3C9
      ED005566CC003C52CC00757AE8008F92EE008F92EE007178E400334DC100405C
      BE00B9C4E700F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000ABD6F8002198
      F00052BBFE004AB4FC001485E400EEF6FD00BCDBF6001885E20040B3FF003BAA
      F9001373D500CDDFF400F0F0F000F0F0F000F0F0F000F0F0F000B5DBBA00258F
      2A006DBE8300A8DBB50087CC980066BC7D0064BA7C0086CB9800A5D9B40066B7
      7D0024722700B5D1B600F0F0F000F0F0F000F0F0F000F0F0F000C6E0CC0055A0
      640064B47800A8DBB50087CC980066BC7D0064BA7C0086CB9800A5D9B40058AA
      6B0035863D00B9D5BC00F0F0F000F0F0F000F0F0F000F0F0F000C5C9EF005160
      CD005C65E000A1A6F5007E86EF005B63E900595DE7007D84EE009EA0F400515D
      D7003452BA00B9C4E700F0F0F000F0F0F000F0F0F000F0F0F000F0F0F00078BE
      F400289DF10055BDFF002598EF009ACBF30068AFEC002F9EF20042B4FF00218C
      E6008AB9E900F0F0F000F0F0F000F0F0F000F0F0F000E1F2E40033A1440072C2
      8700A8DBB20060BC77005CBA730059B8700059B56F0058B56F005BB77400A5D9
      B30069B87F00317F3500E1ECE100F0F0F000F0F0F000E9F3EB0067AC76006AB9
      7D00A8DBB20060BC77005CBA730059B8700059B56F0058B56F005BB77400A5D9
      B3005AAA6C00428F4900E2EEE300F0F0F000F0F0F000E8EAF9006571D400616B
      E300A1ACF500545FEC00505CEA004D59E9004E59E6004C56E6005056E6009EA2
      F4005460D600405CBF00E2E7F500F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F00045A6F0002EA1F40047B2FA002590E80032A2F30048B6FF002797EE0068AC
      E900F0F0F000F0F0F000F0F0F000F0F0F000F0F0F00090D29F004CB06400AADD
      B40064C179005FBE710075C58500D4ECD9008ACD990056B66C0058B56E005CB7
      7400A6DAB400419B4E008EBC9000F0F0F000F0F0F000AFD5B80053AB6800AADD
      B40064C179005FBE710060BC7700F0F0F000F0F0F00059B8700058B56E005CB7
      7400A6DAB400388F430097C19B00F0F0F000F0F0F000ACB0EA004B56DB00A2AB
      F6005664F0005266EE004D59E9004D59E9004D59E9004D59E9004C58E600525A
      E6009FA3F5003450C40096A6DC00F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000EEF7FE00138EEC0050B9FE0042B2FC0046B7FF003CABF9003595E700EEF6
      FD00F0F0F000F0F0F000F0F0F000F0F0F000F0F0F0003FB55D0091D29F008DD4
      9A0064C3740079C98700F2FAF400F0F0F000FDFEFD0086CB960057B76D005BB9
      720085CC970087C79A003B8B3F00F0F0F000F0F0F00077B888008ACC980089D3
      96006BC67A0063C1700055AB6500F0F0F000F0F0F00059B8700059B870005BB9
      720085CC97007BBE8D004D965500F0F0F000F0F0F0007378DD00818CEE007E91
      F7005D73F3004D59E9004D59E9004D59E9004D59E9004D59E9004D59E9004F5B
      E9007B83F000757BE2004C64C400F0F0F00045AFF8000190F400018EF30035A4
      F40045AAF30045A8F2003EAEFA0046B7FF0042B5FF003CADFA003598E900469E
      E900258BE3000475DC000470D7004892DE00F0F0F00027B04900A6DCAF0070CA
      7F0073CA8000F0F9F100F0F0F000EBF7ED00F0F0F000FBFDFC0088CD96005BB9
      710067BE7D00A0D7AF00237F2600F0F0F000F0F0F0006AB27F00A9DDB3007DCF
      8A0075CC8100F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F00059B8
      700067BE7D009CD4AB003B8C4400F0F0F000F0F0F0006569DB00A1ABF7007086
      F8006882F600F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F0004D59
      E9005C66EA00969CF1003956BE00F0F0F00045B1FA0050BAFD006BC7FF0053BB
      FD004AB5FB0049B3FB0052BDFF0047B8FF0043B5FF0048B8FF0043AFFA003BAA
      F80044B1FB004BB7FF0036A5F6004797E200F0F0F0002EB75100A7DDB10072CC
      800066C77300B0E1B700D2EED60063C17000B8E3BF00F0F0F000FBFDFC008CD0
      990069C17E00A1D7AE0023842600F0F0F000F0F0F0006EB58300B6E2BE008BD5
      97007AC98600F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F00059B8
      700069C17E009DD4AA003F8F4900F0F0F000F0F0F000696EDC00AFB9F9007F93
      FA007085F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F0004D59
      E9005E6AEE00969DF1003D55C000F0F0F00045B2FB00179FF9000193F6001298
      F60045ADF60034A4F40045B4FC0049B9FF0047B7FF003FAFFB00359CED0046A3
      ED00258FE800037CE2001186E600479BE600F0F0F0004BC56C0095D7A10091D7
      9B0069C9760064C66F0061C46E0061C36F0061C26F00B9E4C000F0F0F000E3F4
      E6008BD199008BCE9D003C993F00F0F0F000F0F0F00082BF9500ACDDB600A6DF
      AF0081CB8C007CC986006EBD7900F0F0F000F0F0F0005BAC6A0060BC77005CBA
      73008BD1990080C59200589E6100F0F0F000F0F0F0007C7FE300A5AFF5009DAB
      FA00778CF000545FEC00545FEC00545FEC00545FEC00545FEC00545FEC006377
      F200818EF400787FE900566BC900F0F0F000CCEAFE00CCEAFE00F0F0F000F0F0
      F000EEF8FE001296F40056BDFE004EB9FE004EBAFF0042B1FB00359DEE00EEF7
      FD00F0F0F000F0F0F000CDE5F900CDE4F900F0F0F0009BDFAD0057BF7000AFE1
      B7006DCC7A0068C8720065C7700063C56E0062C46E0063C47100B6E3BE006FC7
      7E00ACDFB50048A95E008FC89400F0F0F000F0F0F000B8DCC40085C79700D2EE
      D70095D9A0008AD394007FC88900F0F0F000F0F0F00079CD85006BC37C006FC7
      7E00ACDFB500459E5700A1C9A700F0F0F000F0F0F000B5B5F0007D83EA00CDD4
      FC008B9DFA007E93F700758AEE006C84F6006C84F6006C84F6006C84F6006379
      F300A4AFF8003E4FD000A0ABE100F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F00045B0F90032ABFA005AC0FE001296F30038ACF90053BCFF002CA2F60067B6
      F300F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000E5F7E90049C566007FCE
      9000AEE1B5006DCC7A006ACA760068C8720068C8740068C875006BC97900ACDF
      B40076C4890033A14200E1F1E300F0F0F000F0F0F000ECF6EF007FBF9300AADA
      B700D8F1DC0092D89D0088CD930084CC8E008BD496008AD4950083D28E00AFE0
      B7006BB97D005BA36700E6F1E800F0F0F000F0F0F000EBEBFB007978E300A3A7
      F300D4DBFD00879AFA007F91F0007A8EF1007F94F8007E92F900768CF800A8B6
      F800636EE3005868CD00E6E8F700F0F0F000F0F0F000F0F0F000F0F0F00088CE
      FD002DAAFB0061C4FF0038AEFB0067BCF80067BBF70037ABF90052BBFF00249D
      F4009ACFF700F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000BFECCB003DC3
      5C007FCE9000AFE1B70092D89D0077CE830077CE830092D89D00AEE1B50078C8
      8B0027A13B00B5DFBE00F0F0F000F0F0F000F0F0F000F0F0F000D1E9D90076BB
      8C00AFDCBB00DCF2E000B6E4BD009BDBA50096D9A000A5DFAF00C0E8C50079C2
      8A0058A26600C5DECA00F0F0F000F0F0F000F0F0F000F0F0F000CFCFF600706F
      E100AAADF200D8DCFD00AEBAFA0091A3FA008B9DFA009CA9FB00BAC7FC00707B
      E9005462CE00C3C9EE00F0F0F000F0F0F000F0F0F000F0F0F000BBE4FE001EA5
      FD005BC0FE0063C4FF000F9BF800DDF0FE00BBE1FC001A9CF60054BCFF0046B4
      FC001391EE00CCE7FB00F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000C0ED
      CB004AC8690059C2740096D7A300A5DCAE00A5DCAE0095D6A10050B96A0035B3
      5500B6E3C100F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000D1E9
      D9007FBF930094CEA400C3E6CB00CFEBD400C9E9CE00AFDDB8006DB97F0068AE
      7800C7E0CD00F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000CFCF
      F6007979E2008E93ED00BEC3F800CCD3F900C4CBF900AAB4F4006670E200646E
      D600C6CAEF00F0F0F000F0F0F000F0F0F000F0F0F000F0F0F00099D7FF0016A4
      FD0043B6FE004EBBFE0045B2FB00F0F0F000F0F0F00034A7F7004BB8FD0033A8
      F9001393F000ABD8F900F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000E5F8E9009FE3B00055CB72003BC05C0037BE5A0049C36A0097DCAA00E1F5
      E700F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000ECF6EF00B9DDC50082C0950071B786006EB5820079B98A00B1D6BA00E9F3
      EB00F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000EBEBFB00B6B6F0007D7FE2006A6BDE00686BDC007479DE00AFB3EB00E8E9
      F900F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000CCEB
      FF0044B5FE000099FC00AADCFE00F0F0F000F0F0F00099D4FB000191F50045AD
      F600DDF0FD00F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00FFC1FFFF00000000FF80FFFF00000000
      8000F3FF00000000801CF1FF000000008000F0FF000000008000F07F00000000
      8001F03F000000008001F01F000000008001F01F000000008001F03F00000000
      8001F07F000000008001F0FF000000008001F1FF00000000FFFFF3FF00000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFFFFFFFFFE187F00FF00FF00FC183
      E007E007E007C003C003C003C003E007800180018001F00F800181818001F00F
      8101818180010000828187E187E10000804187E187E10000802181818001300C
      800181818001F00F800180018001E007C003C003C003C003E007E007E007C183
      F00FF00FF00FE187FFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ImageList4: TImageList
    Left = 912
    Top = 152
    Bitmap = {
      494C010105000700380010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FCECFC00EDA2EB00DB64D600D364CD00DBA2D600F6ECF5000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F5A2F400F39FF200F6AEF800F4A6F600EC9DEA00DDA2D8000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F664F400F9C1FA00F497F800F590F700F6A7F500D764D1000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FB64FC00FACCFC00F5A1FA00F595F800F7AFF800DF64DA000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FEA3FF00FEA2FD00FACCFC00F9C7FB00F4A0F300F0A2EE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFECFF00FEA3FF00FC64FC00F864F900F8A2F700FDECFD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000094940063C6FF0063C6
      FF0063C6FF0063C6FF0063C6FF0063C6FF0063C6FF0063C6FF0063C6FF0063C6
      FF0063C6FF0063C6FF0063C6FF00000000000000000000000000009494000094
      9400009494000094940000949400009494000094940000949400009494000094
      9400009494000094940000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000949400D6FFFF008CD6
      FF008CFFFF008CD6FF008CFFFF008CD6FF008CFFFF008CD6FF008CFFFF008CD6
      FF008CD6FF008CD6FF0063C6FF0000000000000000000000000000949400EFEF
      EF008CD6FF008CFFFF008CD6FF008CFFFF008CD6FF008CD6FF008CD6FF008CD6
      FF0063C6FF000094940000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000949400D6FFFF008CFF
      FF008CFFFF008CFFFF008CD6FF008CFFFF008CD6FF008CFFFF008CD6FF008CFF
      FF008CD6FF008CD6FF0063C6FF00000000000000000000949400EFEFEF008CFF
      FF008CFFFF008CD6FF008CFFFF008CD6FF008CFFFF008CD6FF008CD6FF008CD6
      FF0063C6FF000000000000949400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000949400D6FFFF008CFF
      FF008CFFFF008CFFFF008CFFFF008CFFFF008CFFFF008CD6FF008CFFFF008CD6
      FF008CFFFF008CD6FF0063C6FF00000000000000000000949400EFEFEF008CFF
      FF008CFFFF008CFFFF008CFFFF008CFFFF008CD6FF008CFFFF008CD6FF008CD6
      FF00009494000000000000949400000000000000000000000000000000000000
      000000000000FBF4E500E6C57F00CD9B2A00C2952A00CDB97F00F3F0E5000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E5F5FB007FCBE6002AA0CD002A96C2007FB4CD00E5EEF3000000
      0000000000000000000000000000000000000000000000949400D6FFFF008CFF
      FF008CFFFF008CFFFF008CFFFF008CFFFF008CD6FF008CFFFF008CD6FF008CFF
      FF008CD6FF008CFFFF0063C6FF000000000000949400EFEFEF008CFFFF008CFF
      FF008CFFFF008CFFFF008CD6FF008CFFFF008CFFFF008CD6FF008CFFFF0063C6
      FF000000000063C6FF0063C6FF00000000000000000000000000000000000000
      000000000000F2CB7F00EEC87C00F5D09000F3CB8500E4C17800D0BA7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007FD5F20080D1ED00B2E5F500AEE1F20080C2DD007FB6D0000000
      0000000000000000000000000000000000000000000000949400D6FFFF008CFF
      FF008CFFFF008CFFFF008CFFFF008CFFFF008CFFFF008CFFFF008CFFFF008CD6
      FF008CFFFF008CD6FF0063C6FF000000000000949400EFEFEF008CFFFF008CFF
      FF008CFFFF008CFFFF008CFFFF008CFFFF008CD6FF008CFFFF008CD6FF0063C6
      FF000000000063C6FF0063C6FF00000000000000000000000000000000000000
      000000000000F2AE2A00F8DBA900F5C27000F4C06700F3CD8600C7972A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002AC1F200B8EBF90078DEF60067D5F400ADE0F3002A9AC7000000
      0000000000000000000000000000000000000000000000949400D6FFFF008CFF
      FF008CFFFF008CFFFF008CFFFF008CFFFF008CFFFF008CFFFF008CD6FF008CFF
      FF008CD6FF008CFFFF0063C6FF00000000000094940000949400009494000094
      9400009494000094940000949400009494000094940000949400009494000094
      940063C6FF008CFFFF0063C6FF00000000000000000000000000000000000000
      000000000000FAB12A00FBE1B800F8C77E00F5C26E00F5D19100D39D2A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002AC8FA00BAEEFB0081E2F80072DAF500AFE4F5002AA5D3000000
      0000000000000000000000000000000000000000000000949400D6FFFF008CFF
      FF008CFFFF008CFFFF008CFFFF008CFFFF008CFFFF008CFFFF008CFFFF008CFF
      FF008CFFFF008CD6FF0063C6FF00000000000000000000949400EFEFEF008CFF
      FF008CFFFF008CFFFF008CFFFF008CFFFF008CFFFF008CFFFF008CFFFF008CFF
      FF008CFFFF008CFFFF0063C6FF00000000000000000000000000000000000000
      000000000000FFD27F00FDD28000FBE2B900FADEB100F0C97D00EBC77F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007FE1FF0080DFFD00B9EDFB00B5EBFA0080D4F0007FCFEB000000
      0000000000000000000000000000000000000000000000949400D6FFFF00D6FF
      FF00D6FFFF00D6FFFF00D6FFFF00D6FFFF00D6FFFF00D6FFFF00D6FFFF00D6FF
      FF00D6FFFF008CFFFF0063C6FF00000000000000000000949400EFEFEF008CFF
      FF008CFFFF008CFFFF008CFFFF008CFFFF008CFFFF008CFFFF00EFEFEF00EFEF
      EF00EFEFEF00EFEFEF0063C6FF00000000000000000000000000000000000000
      000000000000FFF6E500FFD27F00FCB22A00F7B02A00F6CD7F00FCF4E5000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E5F9FF007FE1FF002ACAFC002AC5F7007FD8F600E5F6FC000000
      000000000000000000000000000000000000000000000094940063C6FF0063C6
      FF0063C6FF0063C6FF0063C6FF0063C6FF0063C6FF0000949400009494000094
      9400009494000094940000949400000000000000000000949400EFEFEF008CFF
      FF008CFFFF008CFFFF008CFFFF008CFFFF00EFEFEF0000949400009494000094
      9400009494000094940000949400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000949400EFEF
      EF00D6FFFF00D6FFFF008CFFFF008CFFFF000094940000000000000000000000
      000000000000000000000000000000000000000000000000000000949400EFEF
      EF00EFEFEF00EFEFEF00EFEFEF00EFEFEF000094940000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000094
      9400009494000094940000949400009494000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000094
      9400009494000094940000949400009494000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      FFFF000000000000FFFF000000000000FFFF000000000000F81F000000000000
      F81F000000000000F81F000000000000F81F000000000000F81F000000000000
      F81F000000000000FFFF000000000000FFFF000000000000FFFF000000000000
      FFFF000000000000FFFF000000000000FFFFFFFFFFFFFFFFC000E000FFFFFFFF
      8000C000FFFFFFFF8000C000FFFFFFFF80008000FFFFFFFF80008000F81FF81F
      80000000F81FF81F80000000F81FF81F80000000F81FF81F80008000F81FF81F
      80008000F81FF81F80018001FFFFFFFFC03FC07FFFFFFFFFE07FE0FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
end
