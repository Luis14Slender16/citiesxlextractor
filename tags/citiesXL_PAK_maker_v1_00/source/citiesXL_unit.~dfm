object Form1: TForm1
  Left = 1302
  Top = 840
  Width = 520
  Height = 133
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnResize = FormResize
  DesignSize = (
    504
    95)
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
    Top = 80
    Width = 497
    Height = 17
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
  object Button_selectPAK: TButton
    Left = 344
    Top = 8
    Width = 17
    Height = 20
    Hint = 'Select the PAK file to Extract/Make...'
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 2
    OnClick = Button_selectPAKClick
  end
  object Button_selDIR: TButton
    Left = 344
    Top = 40
    Width = 17
    Height = 20
    Hint = 'Select the Source/Target directory...'
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 3
    OnClick = Button_selDIRClick
  end
  object Button_Exit: TButton
    Left = 440
    Top = 40
    Width = 65
    Height = 21
    Hint = 'End of the hard work.'
    Anchors = [akTop, akRight]
    Caption = 'E&xit'
    TabOrder = 4
    OnClick = Button_ExitClick
  end
  object Button_XtractAll: TButton
    Left = 440
    Top = 8
    Width = 65
    Height = 21
    Hint = 'Extract the selected PAK file to the given directory.'
    Anchors = [akTop, akRight]
    Caption = '&Extract'
    TabOrder = 5
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
    TabOrder = 6
  end
  object Button_MakeArchive: TButton
    Left = 368
    Top = 40
    Width = 65
    Height = 21
    Hint = 'Make PAK file from the files of the selected directory.'
    Anchors = [akTop, akRight]
    Caption = '&Make PAK'
    TabOrder = 7
    OnClick = Button_MakeArchiveClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Cities XL .PAK files (*.pak)|*.pak|All files (*.*)|*.*'
    Left = 24
    Top = 32
  end
end
