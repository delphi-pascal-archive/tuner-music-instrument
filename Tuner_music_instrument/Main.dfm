object FormMain: TFormMain
  Left = 219
  Top = 124
  Width = 693
  Height = 270
  Caption = #1053#1072#1089#1090#1088#1086#1081#1097#1080#1082' '#1084#1091#1079#1099#1082#1072#1083#1100#1085#1099#1093' '#1080#1085#1089#1090#1088#1091#1084#1077#1085#1090#1086#1074
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object ChartSpec: TChart
    Left = 0
    Top = 55
    Width = 685
    Height = 127
    AllowPanning = pmNone
    AllowZoom = False
    BackWall.Brush.Color = clWhite
    BackWall.Color = clWhite
    MarginBottom = 0
    MarginLeft = 0
    MarginRight = 0
    MarginTop = 0
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    AxisVisible = False
    BackColor = clWhite
    BottomAxis.Labels = False
    BottomAxis.Logarithmic = True
    LeftAxis.Labels = False
    Legend.Visible = False
    RightAxis.Automatic = False
    RightAxis.AutomaticMaximum = False
    RightAxis.AutomaticMinimum = False
    RightAxis.Maximum = 100.000000000000000000
    View3D = False
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object SeriesPointer: TLineSeries
      ColorEachPoint = True
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clRed
      VertAxis = aRightAxis
      Dark3D = False
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
    object Series1: TBarSeries
      ColorEachPoint = True
      Marks.Arrow.Visible = False
      Marks.ArrowLength = -15
      Marks.Frame.Visible = False
      Marks.Transparent = True
      Marks.Visible = True
      SeriesColor = clWhite
      Title = 'SeriesPiano'
      VertAxis = aRightAxis
      AutoMarkPosition = False
      BarPen.Visible = False
      BarWidthPercent = 100
      Dark3D = False
      MultiBar = mbNone
      SideMargins = False
      YOrigin = 100.000000000000000000
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Bar'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
    object SeriesSpec: TFastLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clGreen
      LinePen.Color = clGreen
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 685
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object LabelNoteValue: TLabel
      Left = 54
      Top = 10
      Width = 16
      Height = 16
      Caption = 'A0'
    end
    object LabelRangeValue: TLabel
      Left = 143
      Top = 34
      Width = 7
      Height = 16
      Caption = '1'
    end
    object LabelRangef: TLabel
      Left = 15
      Top = 34
      Width = 132
      Height = 16
      Caption = #1044#1080#1072#1087#1072#1079#1086#1085', '#1087#1086#1083#1091#1090#1086#1085':'
    end
    object LabelNotev: TLabel
      Left = 15
      Top = 10
      Width = 38
      Height = 16
      Caption = #1053#1086#1090#1072':'
    end
    object PanelPiano: TPanel
      Left = 89
      Top = 0
      Width = 738
      Height = 36
      BevelOuter = bvNone
      Caption = 'PanelPiano'
      TabOrder = 0
      object ImagePiano: TImage
        Left = 0
        Top = 0
        Width = 738
        Height = 31
        OnMouseUp = ImagePianoMouseUp
      end
      object PanelPianoPoint: TPanel
        Left = 354
        Top = 14
        Width = 5
        Height = 19
        Caption = ' '
        Color = clLime
        TabOrder = 0
      end
    end
  end
  object PanelDown: TPanel
    Left = 0
    Top = 182
    Width = 685
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 2
    object LabelSoundMode: TLabel
      Left = 5
      Top = 1
      Width = 16
      Height = 16
      Caption = '----'
    end
  end
  object ActionListMain: TActionList
    Left = 560
    Top = 56
    object ActionLeft: TAction
      Caption = #1053#1072' '#1087#1086#1083#1090#1086#1085#1072' '#1085#1080#1078#1077
      ShortCut = 37
      OnExecute = ActionLeftExecute
    end
    object ActionRight: TAction
      Caption = #1053#1072' '#1087#1086#1083#1090#1086#1085#1072' '#1074#1099#1096#1077
      ShortCut = 39
      OnExecute = ActionRightExecute
    end
    object ActionUp: TAction
      Caption = #1059#1084#1077#1085#1100#1096#1080#1090#1100' '#1090#1086#1095#1085#1086#1089#1090#1100
      ShortCut = 38
      OnExecute = ActionUpExecute
    end
    object ActionDown: TAction
      Caption = #1059#1074#1077#1083#1080#1095#1080#1090#1100' '#1090#1086#1095#1085#1086#1089#1090#1100
      ShortCut = 40
      OnExecute = ActionDownExecute
    end
    object ActionHelp: TAction
      Caption = '&'#1055#1086#1084#1086#1097#1100
      ShortCut = 112
      OnExecute = ActionHelpExecute
    end
    object ActionString1: TAction
      Tag = 1
      Category = 'Strings'
      Caption = #1055#1077#1088#1074#1072#1103' '#1089#1090#1088#1091#1085#1072
      ShortCut = 49
      OnExecute = ActionStringExecute
    end
    object ActionString2: TAction
      Tag = 2
      Category = 'Strings'
      Caption = #1042#1090#1086#1088#1072#1103' '#1089#1090#1088#1091#1085#1072
      ShortCut = 50
      OnExecute = ActionStringExecute
    end
    object ActionString3: TAction
      Tag = 3
      Category = 'Strings'
      Caption = #1058#1088#1077#1090#1100#1103' '#1089#1090#1088#1091#1085#1072
      ShortCut = 51
      OnExecute = ActionStringExecute
    end
    object ActionString4: TAction
      Tag = 4
      Category = 'Strings'
      Caption = #1063#1077#1090#1074#1077#1088#1090#1072#1103' '#1089#1090#1088#1091#1085#1072
      ShortCut = 52
      OnExecute = ActionStringExecute
    end
    object ActionString5: TAction
      Tag = 5
      Category = 'Strings'
      Caption = #1055#1103#1090#1072#1103' '#1089#1090#1088#1091#1085#1072
      ShortCut = 53
      OnExecute = ActionStringExecute
    end
    object ActionString6: TAction
      Tag = 6
      Category = 'Strings'
      Caption = #1064#1077#1089#1090#1072#1103' '#1089#1090#1088#1091#1085#1072
      ShortCut = 54
      OnExecute = ActionStringExecute
    end
    object ActionRC: TAction
      Caption = '&'#1059#1088#1086#1074#1077#1085#1100' '#1079#1072#1087#1080#1089#1080
      ShortCut = 116
      OnExecute = ActionRCExecute
    end
    object ActionSpace: TAction
      Category = 'Strings'
      Caption = #1057#1083#1077#1076#1091#1102#1097#1072#1103
      ShortCut = 32
      OnExecute = ActionSpaceExecute
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 592
    Top = 56
  end
  object Timer2: TTimer
    Interval = 50
    OnTimer = Timer2Timer
    Left = 624
    Top = 56
  end
  object MainMenu1: TMainMenu
    Left = 96
    Top = 120
    object NSettings: TMenuItem
      Caption = '&'#1047#1074#1091#1082
      ShortCut = 113
      object ActionDown1: TMenuItem
        Action = ActionDown
      end
      object ActionUp1: TMenuItem
        Action = ActionUp
      end
      object ActionLeft1: TMenuItem
        Action = ActionLeft
      end
      object ActionRight1: TMenuItem
        Action = ActionRight
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object NRC: TMenuItem
        Action = ActionRC
      end
    end
    object NGuitar: TMenuItem
      Caption = '&'#1043#1080#1090#1072#1088#1072
      object NString1: TMenuItem
        Action = ActionString1
      end
      object NString2: TMenuItem
        Action = ActionString2
      end
      object NString3: TMenuItem
        Action = ActionString3
      end
      object NSting4: TMenuItem
        Action = ActionString4
      end
      object NString5: TMenuItem
        Action = ActionString5
      end
      object NString6: TMenuItem
        Action = ActionString6
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object N5: TMenuItem
        Action = ActionSpace
      end
    end
    object N1: TMenuItem
      Caption = '&?'
      object N3: TMenuItem
        Action = ActionHelp
      end
      object N4: TMenuItem
        Caption = '&'#1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = N4Click
      end
    end
  end
end
