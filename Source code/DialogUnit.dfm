object DialogFORM: TDialogFORM
  Left = 600
  Top = 400
  BorderStyle = bsDialog
  Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
  ClientHeight = 99
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClick = YesBTNClick
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object StatusLBL: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 321
    Height = 27
    Align = alTop
    Alignment = taCenter
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -22
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitWidth = 64
  end
  object Filler: TPanel
    Left = 0
    Top = 64
    Width = 327
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 100
    ExplicitWidth = 374
    object YesBTN: TButton
      Tag = 1
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 87
      Height = 29
      Align = alLeft
      Caption = #1044#1072
      TabOrder = 0
      OnClick = YesBTNClick
    end
    object NoBTN: TButton
      AlignWithMargins = True
      Left = 237
      Top = 3
      Width = 87
      Height = 29
      Align = alRight
      Caption = #1053#1077#1090
      TabOrder = 1
      OnClick = YesBTNClick
      ExplicitLeft = 284
    end
    object rstBTN: TButton
      AlignWithMargins = True
      Left = 96
      Top = 3
      Width = 135
      Height = 29
      Align = alClient
      Caption = #1056#1077#1089#1090#1072#1088#1090
      TabOrder = 2
      OnClick = rstBTNClick
      ExplicitWidth = 182
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 33
    Width = 327
    Height = 31
    Align = alClient
    Alignment = taCenter
    Caption = 'StaticText1'
    TabOrder = 1
    ExplicitWidth = 374
    ExplicitHeight = 67
  end
end
