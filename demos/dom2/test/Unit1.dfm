object Form1: TForm1
  Left = 319
  Top = 121
  Width = 663
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
    Top = 233
    Width = 655
    Height = 282
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
    Width = 655
    Height = 201
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 145
      Height = 13
      Caption = 'TestFile for Test and Traverse:'
    end
    object Label2: TLabel
      Left = 200
      Top = 16
      Width = 29
      Height = 13
      Caption = 'Tests:'
    end
    object Button2: TButton
      Left = 352
      Top = 8
      Width = 89
      Height = 25
      Caption = 'TestDom'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button6: TButton
      Left = 352
      Top = 40
      Width = 89
      Height = 25
      Caption = 'TraverseDom'
      TabOrder = 1
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 352
      Top = 72
      Width = 89
      Height = 25
      Caption = 'FullDom'
      TabOrder = 2
      OnClick = Button7Click
    end
    object TestGdome100: TButton
      Left = 448
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
      Left = 448
      Top = 72
      Width = 89
      Height = 25
      Caption = 'FullDom100'
      TabOrder = 6
      OnClick = Button9Click
    end
    object Button12: TButton
      Left = 448
      Top = 40
      Width = 89
      Height = 25
      Caption = 'TraverseDom100'
      TabOrder = 7
      OnClick = Button12Click
    end
    object Button1: TButton
      Left = 552
      Top = 8
      Width = 89
      Height = 25
      Caption = 'ParseBench'
      TabOrder = 8
      OnClick = Button1Click
    end
    object Test1: TCheckBox
      Left = 200
      Top = 40
      Width = 137
      Height = 17
      Caption = 'IDOMDocumentBuilder'
      TabOrder = 9
    end
    object Test2: TCheckBox
      Left = 200
      Top = 56
      Width = 137
      Height = 17
      Caption = 'TestDocument'
      TabOrder = 10
    end
    object Test3: TCheckBox
      Left = 200
      Top = 72
      Width = 137
      Height = 17
      Caption = 'TestElement'
      TabOrder = 11
    end
    object Test4: TCheckBox
      Left = 200
      Top = 88
      Width = 137
      Height = 17
      Caption = 'TestNode'
      TabOrder = 12
    end
    object Test5: TCheckBox
      Left = 200
      Top = 104
      Width = 137
      Height = 17
      Caption = 'TestDocType'
      TabOrder = 13
    end
    object Test6: TCheckBox
      Left = 200
      Top = 120
      Width = 137
      Height = 17
      Caption = 'TestDomImplementation'
      TabOrder = 14
    end
    object Test7: TCheckBox
      Left = 200
      Top = 136
      Width = 137
      Height = 17
      Caption = 'TestCDATA_PI_Text'
      TabOrder = 15
    end
    object Test8: TCheckBox
      Left = 200
      Top = 152
      Width = 137
      Height = 17
      Caption = 'TestNamedNodemap'
      TabOrder = 16
    end
    object Test9: TCheckBox
      Left = 200
      Top = 168
      Width = 137
      Height = 17
      Caption = 'IDomPersist'
      TabOrder = 17
    end
    object dom2: TCheckBox
      Left = 32
      Top = 144
      Width = 137
      Height = 17
      Caption = 'TestDOM2 Methods'
      TabOrder = 18
    end
    object TestDocument5000: TButton
      Left = 448
      Top = 104
      Width = 121
      Height = 25
      Caption = 'TestDocument10000'
      TabOrder = 19
      OnClick = TestDocument5000Click
    end
    object Button3: TButton
      Left = 448
      Top = 136
      Width = 121
      Height = 25
      Caption = 'TestElement10000'
      TabOrder = 20
      OnClick = Button3Click
    end
    object Button5: TButton
      Left = 448
      Top = 168
      Width = 121
      Height = 25
      Caption = 'TestNode10000'
      TabOrder = 21
      OnClick = Button5Click
    end
    object Button8: TButton
      Left = 232
      Top = 16
      Width = 41
      Height = 17
      Caption = 'all'
      TabOrder = 22
      OnClick = Button8Click
    end
    object Button10: TButton
      Left = 280
      Top = 16
      Width = 41
      Height = 17
      Caption = 'none'
      TabOrder = 23
      OnClick = Button10Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 201
    Width = 655
    Height = 32
    Align = alTop
    TabOrder = 2
    DesignSize = (
      655
      32)
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
      Left = 566
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
