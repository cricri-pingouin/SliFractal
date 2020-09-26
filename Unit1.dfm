object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Fractal'
  ClientHeight = 378
  ClientWidth = 353
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001002020020001000100300100001600000028000000200000004000
    0000010001000000000000000000000000000000000000000000000000000000
    0000FFFFFF00000000000000000000000000000000001E3C3C780C9999300DD9
    9BB001C3C38003E3C7C00007E00003EFF7C001CFF38001DFFB80009FF900003F
    FC0000000000003E7C00001C3800001C380000099000000BD0000003C0000000
    00000003C0000003C00000018000000000000000000000000000000000000000
    000000000000FFFFFFFFFFFFFFFF00000000000000008000000180000001C000
    0003E0000007E0000007F000000FF000000FF800001FFC00001FFC00003FFE00
    007FFE00007FFF0000FFFF0000FFFF8001FFFFC003FFFFC003FFFFE007FFFFE0
    07FFFFF00FFFFFF00FFFFFF81FFFFFFC3FFFFFFC3FFFFFFE7FFFFFFE7FFFFFFF
    FFFFFFFFFFFF}
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 337
    Height = 337
  end
  object MainMenu1: TMainMenu
    Left = 272
    Top = 16
    object mniDraw: TMenuItem
      Caption = 'Draw'
      OnClick = mniDrawClick
    end
    object mniOptions: TMenuItem
      Caption = 'Options'
      OnClick = mniOptionsClick
    end
    object mniPNG: TMenuItem
      Caption = 'Save PNG'
      Enabled = False
      OnClick = mniPNGClick
    end
  end
end
