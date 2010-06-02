object Form1: TForm1
  Left = 1374
  Top = 140
  Width = 520
  Height = 182
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  DesignSize = (
    504
    144)
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
    Top = 96
    Width = 489
    Height = 42
    Anchors = [akLeft, akRight, akBottom]
    ForeColor = clNavy
    Progress = 0
  end
  object Edit1: TEdit
    Left = 80
    Top = 8
    Width = 257
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 80
    Top = 40
    Width = 257
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    TabOrder = 1
    Text = 'Edit2'
  end
  object Button_XtractAll: TButton
    Left = 440
    Top = 8
    Width = 65
    Height = 21
    Hint = 'Extract the selected PAK file to the given directory.'
    Anchors = [akTop, akRight]
    Caption = '&Extract'
    TabOrder = 2
    OnClick = Button_XtractAllClick
  end
  object ComboBox_use_Zlib: TComboBox
    Left = 368
    Top = 8
    Width = 65
    Height = 21
    Hint = 'Use Zlib compression in the created PAK file.'
    Style = csDropDownList
    Anchors = [akTop, akRight]
    ItemHeight = 13
    TabOrder = 3
  end
  object Button_MakeArchive: TButton
    Left = 368
    Top = 40
    Width = 65
    Height = 21
    Hint = 'Make PAK file from the files of the selected directory.'
    Anchors = [akTop, akRight]
    Caption = '&Make PAK'
    TabOrder = 4
    OnClick = Button_MakeArchiveClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Cities XL .PAK files (*.pak)|*.pak|All files (*.*)|*.*'
    Left = 24
    Top = 32
  end
end
