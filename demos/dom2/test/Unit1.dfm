object Form1: TForm1
  Left = 382
  Top = 121
  Width = 600
  Height = 542
  Caption = 'Dom2Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 177
    Width = 592
    Height = 338
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 145
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 145
      Height = 13
      Caption = 'TestFile for Test and Traverse:'
    end
    object Button2: TButton
      Left = 200
      Top = 8
      Width = 89
      Height = 25
      Caption = 'TestDom'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button6: TButton
      Left = 200
      Top = 40
      Width = 89
      Height = 25
      Caption = 'TraverseDom'
      TabOrder = 1
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 200
      Top = 72
      Width = 89
      Height = 25
      Caption = 'FullDom'
      TabOrder = 2
      OnClick = Button7Click
    end
    object TestGdome100: TButton
      Left = 296
      Top = 8
      Width = 89
      Height = 25
      Caption = 'TestDom100'
      TabOrder = 3
      OnClick = TestGdome100Click
    end
    object ComboBox1: TComboBox
      Left = 24
      Top = 36
      Width = 153
      Height = 21
      ItemHeight = 13
      TabOrder = 4
      Text = 'events.xml'
      Items.Strings = (
        'events.xml'
        'xslbenchdream.xml'
        'test.xml'
        '17-1.xml')
    end
    object GrpDomVendor: TGroupBox
      Left = 24
      Top = 72
      Width = 89
      Height = 57
      Caption = ' DomVendor '
      TabOrder = 5
      object RbMSXML: TRadioButton
        Left = 8
        Top = 16
        Width = 73
        Height = 17
        Caption = 'MSXML'
        TabOrder = 0
      end
      object RbLIBXML: TRadioButton
        Left = 8
        Top = 32
        Width = 73
        Height = 17
        Caption = 'LIBXML'
        Checked = True
        TabOrder = 1
        TabStop = True
      end
    end
    object Button9: TButton
      Left = 296
      Top = 72
      Width = 89
      Height = 25
      Caption = 'FullDom100'
      TabOrder = 6
      OnClick = Button9Click
    end
    object Button12: TButton
      Left = 296
      Top = 40
      Width = 89
      Height = 25
      Caption = 'TraverseDom100'
      TabOrder = 7
      OnClick = Button12Click
    end
    object Button1: TButton
      Left = 400
      Top = 8
      Width = 89
      Height = 25
      Caption = 'ParseBench'
      TabOrder = 8
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 145
    Width = 592
    Height = 32
    Align = alTop
    TabOrder = 2
    object EnableOutput: TCheckBox
      Left = 8
      Top = 8
      Width = 97
      Height = 17
      Caption = 'EnableOutput'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object Button4: TButton
      Left = 503
      Top = 7
      Width = 81
      Height = 17
      Anchors = [akRight, akBottom]
      Caption = 'clear'
      TabOrder = 1
      OnClick = Button4Click
    end
  end
end
