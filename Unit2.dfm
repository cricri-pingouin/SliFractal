object Form2: TForm2
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 306
  ClientWidth = 202
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object lblCanvasWidth: TLabel
    Left = 8
    Top = 8
    Width = 38
    Height = 16
    Caption = 'Width:'
  end
  object lblHeight: TLabel
    Left = 8
    Top = 40
    Width = 41
    Height = 16
    Caption = 'Height:'
  end
  object lblXmin: TLabel
    Left = 8
    Top = 72
    Width = 38
    Height = 16
    Caption = 'X min:'
  end
  object lblXmax: TLabel
    Left = 8
    Top = 104
    Width = 41
    Height = 16
    Caption = 'X max:'
  end
  object lblYmin: TLabel
    Left = 8
    Top = 136
    Width = 37
    Height = 16
    Caption = 'Y min:'
  end
  object lblYmax: TLabel
    Left = 8
    Top = 168
    Width = 40
    Height = 16
    Caption = 'Y max:'
  end
  object lblMaxIterations: TLabel
    Left = 8
    Top = 200
    Width = 85
    Height = 16
    Caption = 'Max iterations:'
  end
  object lblColour: TLabel
    Left = 8
    Top = 232
    Width = 42
    Height = 16
    Caption = 'Colour:'
  end
  object edtWidth: TEdit
    Left = 104
    Top = 8
    Width = 89
    Height = 24
    TabOrder = 0
    Text = '400'
  end
  object edtHeight: TEdit
    Left = 104
    Top = 40
    Width = 89
    Height = 24
    TabOrder = 1
    Text = '400'
  end
  object edtXmin: TEdit
    Left = 104
    Top = 72
    Width = 89
    Height = 24
    TabOrder = 2
    Text = '-2'
  end
  object edtXmax: TEdit
    Left = 104
    Top = 104
    Width = 89
    Height = 24
    TabOrder = 3
    Text = '1'
  end
  object edtYmin: TEdit
    Left = 104
    Top = 136
    Width = 89
    Height = 24
    TabOrder = 4
    Text = '-1.5'
  end
  object edtYmax: TEdit
    Left = 104
    Top = 168
    Width = 89
    Height = 24
    TabOrder = 5
    Text = '1.5'
  end
  object edtMaxIterations: TEdit
    Left = 104
    Top = 200
    Width = 89
    Height = 24
    TabOrder = 6
    Text = '90'
  end
  object btnOK: TButton
    Left = 8
    Top = 264
    Width = 81
    Height = 33
    Caption = 'OK'
    TabOrder = 7
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 112
    Top = 264
    Width = 81
    Height = 33
    Caption = 'Cancel'
    TabOrder = 8
    OnClick = btnCancelClick
  end
  object cbbColour: TComboBox
    Left = 104
    Top = 232
    Width = 89
    Height = 24
    ItemHeight = 16
    TabOrder = 9
    Text = 'cbbColour'
    Items.Strings = (
      'Red'
      'Green'
      'Blue'
      'Fire')
  end
end
