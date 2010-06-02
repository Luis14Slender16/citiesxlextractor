object Form1: TForm1
  Left = 930
  Top = 661
  Width = 766
  Height = 178
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  ShowHint = True
  OnCreate = FormCreate
  DesignSize = (
    750
    140)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 10
    Width = 44
    Height = 13
    Caption = '.PAK file:'
  end
  object Label2: TLabel
    Left = 8
    Top = 42
    Width = 48
    Height = 13
    Caption = 'Directory:'
  end
  object Gauge1: TGauge
    Left = 8
    Top = 64
    Width = 735
    Height = 70
    Anchors = [akLeft, akRight, akBottom]
    ForeColor = clNavy
    Progress = 0
  end
  object Edit1: TEdit
    Left = 56
    Top = 8
    Width = 687
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Enabled = False
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 56
    Top = 40
    Width = 687
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Enabled = False
    ReadOnly = True
    TabOrder = 1
    Text = 'Edit2'
  end
  object ComboBox_use_Zlib: TComboBox
    Left = 6
    Top = 24
    Width = 65
    Height = 21
    Hint = 'Use Zlib compression in the created PAK file.'
    Style = csDropDownList
    Anchors = [akTop, akRight]
    ItemHeight = 13
    TabOrder = 2
    Visible = False
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 24
    Top = 8
  end
end
