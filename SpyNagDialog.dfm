object SpyNagDlg: TSpyNagDlg
  Left = 802
  Top = 289
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 322
  ClientWidth = 531
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 531
    Height = 293
    Align = alClient
    Lines.Strings = (
      'Spy mode is now working.'
      ''
      'However we have to pay real money to get the drivers'
      ''
      
        'Its now time for some of the companies who profit from Realterm ' +
        'to pony up.'
      ''
      
        'If you are distributing Realterm within your comany or to users,' +
        ' please donate USD50 or more'
      
        'If you are using it for profit, just on your own, please donate ' +
        'USD20 or more'
      'If you just plain want it for yourself, make a donation'
      ''
      
        '----------------------------------------------------------------' +
        '------------------------------------------------'
      
        'http://sourceforge.net/project/project_donations.php?group_id=67' +
        '297'
      
        '----------------------------------------------------------------' +
        '------------------------------------------------'
      ''
      
        'Donations are via Sourceforge, so they get a cut of the pie too ' +
        'to keep the webservers running'
      ''
      ''
      
        'You donate: you get drivers. No one donates, obviously this isn'#39 +
        't a useful feature'
      '(please email requesting the drivers after you have donated)'
      ''
      
        'And thanks to the donors, who have motivated me to add new featu' +
        'res and fix existing bugs!'
      ''
      'thanks,'
      ''
      'Crun')
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 293
    Width = 531
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object OKBtn: TButton
      Left = 311
      Top = 4
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object ButtonDonate: TButton
      Left = 144
      Top = 4
      Width = 89
      Height = 25
      Caption = 'Donate Now!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = ButtonDonateClick
    end
  end
end
