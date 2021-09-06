object StatsFORM: TStatsFORM
  Left = 0
  Top = 0
  Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1080#1075#1088
  ClientHeight = 261
  ClientWidth = 684
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 700
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 678
    Height = 220
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    ExplicitWidth = 368
    ExplicitHeight = 258
  end
  object Filler: TPanel
    Left = 0
    Top = 226
    Width = 684
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 264
    ExplicitWidth = 374
    object ClearBTN: TButton
      AlignWithMargins = True
      Left = 558
      Top = 3
      Width = 123
      Height = 29
      Align = alRight
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091
      TabOrder = 0
      OnClick = ClearBTNClick
      ExplicitLeft = 248
    end
    object OkBTN: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 549
      Height = 29
      Align = alClient
      Caption = 'OK'
      TabOrder = 1
      OnClick = OkBTNClick
      ExplicitWidth = 239
    end
  end
  object StrGRID: TStringGrid
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 678
    Height = 220
    Align = alClient
    ColCount = 6
    FixedCols = 0
    ScrollBars = ssVertical
    TabOrder = 2
    ExplicitWidth = 368
    ExplicitHeight = 258
  end
end
