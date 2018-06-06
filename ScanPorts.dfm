object FormScanPorts: TFormScanPorts
  Left = 459
  Top = 313
  Width = 873
  Height = 488
  BorderIcons = [biSystemMenu]
  Caption = 'Realterm: Scanning for Ports'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000077777777777777700000000
    0000000000000000000000000700000000000000007878878878878800700000
    0000000000708778778778778000000000000000000708080808080808000000
    00000FFFFFF0000000000000000000000000F000000000888888888888800000
    0000F00000000080000000000080000000000FF000000080CCCCCCCCC0800000
    0000000FF0000080CCCCCCCCC0800000000000000FF00080CCCCCCCCC0800000
    00000000000F0080CCCCCCCCC080000000000000077F0080CCCCCCCCC0800070
    7070707000000080CCCCCCCCC080000888888888000000800000000000800008
    F8F8F8F800000088888888888880000000000000000000000000000000000700
    00000000007660000000000000000000FAAAAAAA000000000000000000000000
    FFAAFAFA000000000000000000000000FFFAAAAA000000000000000000000000
    AFAFFAFA0000000000000000000000000FFFFAAA000000000000000000000007
    0000000070000000000000000000000600000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00007FFF00003FFF00001FFF80000FFFC
    0000FFFE0000FFFF0000FFFF8000FFFF8000FFFF8000FFFF8000FFFF8000FFFF
    8000000180008001800080018000800180008001800080007FFFE007FFFFE007
    FFFFE007FFFFE007FFFFE007FFFFE007FFFFEFFFFFFFFFFFFFFFFFFFFFFF}
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 56
    Top = 16
    Width = 292
    Height = 20
    Caption = 'Scanning for Ports is taking a while. '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 504
    Top = 32
    Width = 3
    Height = 13
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 865
    Height = 378
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Realterm is Scanning for Ports.'
      ''
      'It'#39's taking a while.....'
      ''
      'Bluetooth is a likely cause (as each adaptor tries to '
      'connect to '
      '10 ports for a second each)'
      ''
      'If this is annoying, use Commandline options:'
      ''
      'SCANPORTS=0 to suppress automatic port scanning '
      'SCANPORTS=N to limit scanning to ports < N'
      ''
      'Abort button will not take effect until this port has been '
      'scanned. Please be patient')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 378
    Width = 865
    Height = 83
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Label3: TLabel
      Left = 8
      Top = 23
      Width = 102
      Height = 20
      Caption = 'Trying Port #'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 120
      Top = 21
      Width = 31
      Height = 24
      Caption = 'NN'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BitBtnAbort: TBitBtn
      Left = 216
      Top = 17
      Width = 313
      Height = 33
      Caption = 'Abort Scanning'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = BitBtnAbortClick
      Kind = bkAbort
    end
    object BitBtnOK: TBitBtn
      Left = 600
      Top = 17
      Width = 177
      Height = 33
      Caption = 'OK- continue'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Visible = False
      OnClick = BitBtnOKClick
      Kind = bkOK
    end
    object ProgressBar1: TProgressBar
      Left = 0
      Top = 63
      Width = 865
      Height = 20
      Align = alBottom
      Min = 1
      Position = 1
      Step = 1
      TabOrder = 2
    end
  end
  object GroupBox1: TGroupBox
    Left = 504
    Top = 8
    Width = 305
    Height = 369
    Caption = 'Registry: HKLM\HARDWARE\DEVICEMAP\SERIALCOMM'
    TabOrder = 2
    object ValueListEditorComDevices: TValueListEditor
      Left = 2
      Top = 15
      Width = 301
      Height = 352
      Align = alClient
      TabOrder = 0
      TitleCaptions.Strings = (
        'Device'
        'Port')
      ColWidths = (
        143
        152)
    end
  end
  object Timer1: TTimer
    Interval = 20000
    OnTimer = Timer1Timer
    Left = 368
    Top = 8
  end
end
