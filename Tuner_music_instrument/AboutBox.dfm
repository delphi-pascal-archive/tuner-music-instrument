object FormAbout: TFormAbout
  Left = 699
  Top = 255
  BorderStyle = bsDialog
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  ClientHeight = 233
  ClientWidth = 423
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object ImageMain: TImage
    Left = 0
    Top = 0
    Width = 105
    Height = 233
    Align = alLeft
  end
  object Label2: TLabel
    Left = 123
    Top = 185
    Width = 123
    Height = 16
    Cursor = crHandPoint
    Caption = 'te.anton@gmail.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label2Click
  end
  object Label1: TLabel
    Left = 123
    Top = 166
    Width = 212
    Height = 16
    Cursor = crHandPoint
    Caption = 'http://ecsoft.mephi.ru/anton/tune.htm'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label1Click
  end
  object LabelGNUGPL: TLabel
    Left = 345
    Top = 131
    Width = 59
    Height = 16
    Cursor = crHandPoint
    Caption = 'GNU GPL'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = LabelGNUGPLClick
  end
  object Label3: TLabel
    Left = 123
    Top = 205
    Width = 155
    Height = 16
    Cursor = crHandPoint
    Caption = #1044#1086#1088#1072#1073#1086#1090#1082#1072': '#1052#1086#1090#1086#1088#1086#1082#1077#1088
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label3Click
  end
  object Button1: TButton
    Left = 315
    Top = 200
    Width = 94
    Height = 25
    Cancel = True
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 0
  end
  object MemoName: TMemo
    Left = 118
    Top = 10
    Width = 297
    Height = 60
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      #1053#1072#1089#1090#1088#1086#1081#1097#1080#1082' '#1084#1091#1079#1099#1082#1072#1083#1100#1085#1099#1093' '
      #1080#1085#1089#1090#1088#1091#1084#1077#1085#1090#1086#1074)
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 118
    Top = 94
    Width = 297
    Height = 19
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      #1042#1099#1087#1091#1097#1077#1085#1072' '#1087#1086#1076' GNU GPL.'
      'Copyrigth '#169' 2004 '#1058#1105' '#1040#1085#1090#1086#1085)
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
  end
end
