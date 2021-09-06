object BoardFORM: TBoardFORM
  Left = 0
  Top = 0
  Caption = #1054
  ClientHeight = 388
  ClientWidth = 641
  Color = clActiveCaption
  Constraints.MinHeight = 427
  Constraints.MinWidth = 657
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = ToolBar
  OldCreateOrder = False
  OnCreate = FormCreate
  OnHide = ExitBTNClick
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LeftPAN: TPanel
    Left = 0
    Top = 0
    Width = 145
    Height = 388
    Align = alLeft
    Color = clCream
    ParentBackground = False
    TabOrder = 0
    OnMouseLeave = RigthPANMouseLeave
    object PlayerLBL: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 13
      Width = 137
      Height = 20
      Margins.Top = 12
      Align = alTop
      Alignment = taCenter
      Caption = #1048#1043#1056#1054#1050
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Akzidenz-Grotesk Pro Cnd'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 34
    end
    object PlayerLST: TListBox
      Left = 8
      Top = 32
      Width = 129
      Height = 340
      Align = alCustom
      Anchors = [akLeft, akTop, akBottom]
      ExtendedSelect = False
      ImeName = 'Russian'
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object RigthPAN: TPanel
    Left = 496
    Top = 0
    Width = 145
    Height = 388
    Align = alRight
    Color = clCream
    ParentBackground = False
    TabOrder = 1
    OnMouseLeave = RigthPANMouseLeave
    object CompLBL: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 13
      Width = 137
      Height = 20
      Margins.Top = 12
      Align = alTop
      Alignment = taCenter
      Caption = #1050#1054#1052#1055#1068#1070#1058#1045#1056
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Akzidenz-Grotesk Pro Cnd'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 66
    end
    object CompLST: TListBox
      Left = 8
      Top = 32
      Width = 129
      Height = 340
      Align = alCustom
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object CenterPAN: TPanel
    Left = 145
    Top = 0
    Width = 351
    Height = 388
    Align = alClient
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    OnMouseLeave = RigthPANMouseLeave
    object ScoreLBL: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 7
      Width = 343
      Height = 23
      Margins.Top = 6
      Align = alTop
      Alignment = taCenter
      Caption = #1057#1063#1045#1058' 0/0'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Playtime Cyrillic'
      Font.Style = []
      ParentFont = False
      OnClick = FormResize
      ExplicitWidth = 83
    end
    object BoardPAN: TPanel
      Left = 16
      Top = 36
      Width = 320
      Height = 318
      Align = alCustom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      Color = clCream
      ParentBackground = False
      TabOrder = 0
    end
    object ButtensPAN: TPanel
      Left = 1
      Top = 360
      Width = 349
      Height = 27
      Align = alBottom
      BevelOuter = bvNone
      Color = 12320767
      ParentBackground = False
      TabOrder = 1
      TabStop = True
      object DefBTN: TButton
        Left = 289
        Top = 0
        Width = 60
        Height = 27
        Align = alRight
        Caption = #1057#1076#1072#1090#1100#1089#1103
        TabOrder = 2
        TabStop = False
        OnClick = DefBTNClick
        ExplicitLeft = 288
        ExplicitTop = 1
        ExplicitHeight = 25
      end
      object ExitBTN: TButton
        Tag = 1
        Left = 0
        Top = 0
        Width = 56
        Height = 27
        Align = alLeft
        Caption = #1042#1099#1093#1086#1076
        TabOrder = 0
        OnClick = ExitBTNClick
        ExplicitLeft = 1
        ExplicitTop = 1
        ExplicitHeight = 25
      end
      object BackBTN: TButton
        Left = 56
        Top = 0
        Width = 45
        Height = 27
        Align = alLeft
        Caption = #1052#1077#1085#1102
        TabOrder = 3
        OnClick = ExitBTNClick
        ExplicitLeft = 57
        ExplicitTop = 1
        ExplicitHeight = 25
      end
      object ApplyWrdBTN: TButton
        Left = 101
        Top = 0
        Width = 132
        Height = 27
        Align = alClient
        Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1089#1083#1086#1074#1086
        DoubleBuffered = False
        ParentDoubleBuffered = False
        TabOrder = 1
        TabStop = False
        OnClick = ApplyWrdBTNClick
        ExplicitLeft = 102
        ExplicitTop = 1
        ExplicitWidth = 130
        ExplicitHeight = 25
      end
      object SkipBTN: TButton
        Left = 233
        Top = 0
        Width = 56
        Height = 27
        Align = alRight
        Caption = #1055#1088#1086#1087#1091#1089#1082
        TabOrder = 4
        OnClick = SkipBTNClick
        ExplicitLeft = 232
        ExplicitTop = 1
        ExplicitHeight = 25
      end
    end
  end
  object ToolBar: TMainMenu
    Left = 400
    Top = 96
    object LoadBTN: TMenuItem
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      OnClick = LoadBTNClick
    end
    object N2: TMenuItem
      Caption = '|'
      Enabled = False
    end
    object SaveBTN: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnClick = SaveBTNClick
    end
  end
  object SavDIA: TSaveDialog
    FileName = 'Balda.sav'
    Filter = #1060#1072#1081#1083' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103'|*.sav'
    Options = [ofOverwritePrompt, ofCreatePrompt, ofEnableSizing]
    Left = 344
    Top = 104
  end
  object LoadDIA: TOpenDialog
    Left = 296
    Top = 80
  end
end
