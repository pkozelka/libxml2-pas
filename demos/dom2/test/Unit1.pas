unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button2: TButton;
    Button6: TButton;
    Button7: TButton;
    TestGdome100: TButton;
    ComboBox1: TComboBox;
    Panel2: TPanel;
    EnableOutput: TCheckBox;
    Button4: TButton;
    GrpDomVendor: TGroupBox;
    RbMSXML: TRadioButton;
    Button9: TButton;
    Label1: TLabel;
    RbLIBXML: TRadioButton;
    Button12: TButton;
    Button1: TButton;
    dom2: TCheckBox;
    TestDocument5000: TButton;
    Button3: TButton;
    Button5: TButton;
    Test9: TCheckBox;
    Test8: TCheckBox;
    Test7: TCheckBox;
    Test6: TCheckBox;
    Test5: TCheckBox;
    Test4: TCheckBox;
    Test3: TCheckBox;
    Test2: TCheckBox;
    Test1: TCheckBox;
    Button8: TButton;
    Button10: TButton;
    Button11: TButton;
    Button13: TButton;
    Ignore1: TCheckBox;
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure TestGdome100Click(Sender: TObject);
    procedure Native100Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure TestDocument5000Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function GetVendorStr: string;

var
  Form1: TForm1;

implementation

uses
  jkDomTest,feDomTest,conapp,xdom2,libxmldom,msxml_impl;
var
  stack: pointer;

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
begin
  Memo1.lines.Clear;
  EnableOutput.Checked:=true;
  TestDom1(Combobox1.Text,GetVendorStr);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
   Memo1.lines.Clear;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  testset: integer;
  i,j: integer;
begin
  Memo1.lines.Clear;
  EnableOutput.Checked:=false;
  TestSet:=0;
  if Test1.Checked then TestSet:=1;
  if Test2.Checked then TestSet:=TestSet+2;
  if Test3.Checked then TestSet:=TestSet+4;
  if Test4.Checked then TestSet:=TestSet+8;
  if Test5.Checked then TestSet:=TestSet+16;
  if Test6.Checked then TestSet:=TestSet+32;
  if Test7.Checked then TestSet:=TestSet+64;
  if Test8.Checked then TestSet:=TestSet+128;
  if Test9.Checked then TestSet:=TestSet+256;
  for i:=1 to 100 do begin
    for j:=1 to 100 do TestNode1('..\data\test.xml',GetVendorStr,TestSet);
    OutDebugLog('Passed OK: '+inttostr(i*100));
  end;
end;

procedure TForm1.TestGdome100Click(Sender: TObject);
var
  i: integer;
  time: double;
begin
  EnableOutput.Checked:=false;
  time:=0;
  OutDebugLog('Start!');
  for i:=1 to 100 do
    time:=time+TestDom1(Combobox1.Text,GetVendorStr);
  outDebugLog('Everage time: '+format('%8.1f',[time*1000/100])+' ms');
end;

procedure TForm1.Native100Click(Sender: TObject);
//var i: integer;
begin
  OutLog('Disabled!');
  //for i:=1 to 100 do
    //native1(Combobox1.Text);
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  time: double;
begin
  Memo1.lines.Clear;
  if not EnableOutput.Checked then OutDebugLog('Start!');
  //TestDom2(Combobox1.Text,GetVendorStr,Ignore.checked);
  time:=TestDom2(Combobox1.Text,GetVendorStr,ignore1.Checked);
   if not EnableOutput.Checked
     then outDebugLog('Everage time: '+format('%8.1f',[time*1000])+' ms');
end;

procedure TForm1.Button7Click(Sender: TObject);
var TestSet:integer;
begin
  EnableOutput.Checked:=true;
  TestSet:=0;
  if Test1.Checked then TestSet:=1;
  if Test2.Checked then TestSet:=TestSet+2;
  if Test3.Checked then TestSet:=TestSet+4;
  if Test4.Checked then TestSet:=TestSet+8;
  if Test5.Checked then TestSet:=TestSet+16;
  if Test6.Checked then TestSet:=TestSet+32;
  if Test7.Checked then TestSet:=TestSet+64;
  if Test8.Checked then TestSet:=TestSet+128;
  if Test9.Checked then TestSet:=TestSet+256;
  if dom2.Checked then TestSet:=TestSet+512;
  TestGDom3('test.xml',GetVendorStr,TestSet);
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  //test1.Checked:=true;
  test2.Checked:=true;
  test3.Checked:=true;
  test4.Checked:=true;
  test5.Checked:=true;
  test6.Checked:=true;
  test7.Checked:=true;
  test8.Checked:=true;
  test9.Checked:=true;
  dom2.Checked:=true;
end;

function GetVendorStr: string;
begin
  if Form1.RbMSXML.Checked
    then result := 'MSXML2_RENTAL_MODEL'
    else result := 'LIBXML';
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  i,TestSet: integer;
  time: double;
begin
  EnableOutput.Checked:=false;
  TestSet:=0;
  if Test1.Checked then TestSet:=1;
  if Test2.Checked then TestSet:=TestSet+2;
  if Test3.Checked then TestSet:=TestSet+4;
  if Test4.Checked then TestSet:=TestSet+8;
  if Test5.Checked then TestSet:=TestSet+16;
  if Test6.Checked then TestSet:=TestSet+32;
  if Test7.Checked then TestSet:=TestSet+64;
  if Test8.Checked then TestSet:=TestSet+128;
  if Test9.Checked then TestSet:=TestSet+256;
  if dom2.Checked then TestSet:=TestSet+512;
  time:=0;
  OutDebugLog('Start!');
  for i:=1 to 100 do
    time:=time+TestGDom3('test.xml',GetVendorStr,TestSet);
  outDebugLog('Everage time: '+format('%8.1f',[time*1000/100])+' ms');
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
  time1,time2: double;
begin
  EnableOutput.Checked:=false;
  time1:=0;
  time2:=0;
  OutDebugLog('Start!');
  for i:=1 to 100 do
    if i >0 then begin //don't measure the time for loading
                       //the dll/ com-object
      time1:=time1+TestDom1('events.xml',GetVendorStr);
      time2:=time2+TestDom1('xslbenchdream.xml',GetVendorStr);
    end;
  outDebugLog('Everage time parsing events.xml: '+format('%8.1f',[time1*1000/100])+' ms');
  outDebugLog('Everage time parsing xslbenchdream.xml: '+format('%8.1f',[time2*1000/100])+' ms');
end;

procedure TForm1.Button12Click(Sender: TObject);
var
  i: integer;
  time: double;
begin
  EnableOutput.Checked:=false;
  time:=0;
  OutDebugLog('Start!');
  for i:=1 to 100 do
    time:=time+TestDom2(Combobox1.Text,GetVendorStr,ignore1.Checked);
  outDebugLog('Everage time: '+format('%8.1f',[time*1000/100])+' ms');
end;

procedure TForm1.TestDocument5000Click(Sender: TObject);
var
  testset: integer;
  i,j: integer;
begin
  Memo1.lines.Clear;
  EnableOutput.Checked:=false;
  TestSet:=0;
  if Test1.Checked then TestSet:=1;
  if Test2.Checked then TestSet:=TestSet+2;
  if Test3.Checked then TestSet:=TestSet+4;
  if Test4.Checked then TestSet:=TestSet+8;
  if Test5.Checked then TestSet:=TestSet+16;
  if Test6.Checked then TestSet:=TestSet+32;
  if Test7.Checked then TestSet:=TestSet+64;
  if Test8.Checked then TestSet:=TestSet+128;
  if Test9.Checked then TestSet:=TestSet+256;
  for i:=1 to 100 do begin
    for j:=1 to 100 do TestDocument('..\data\test.xml',GetVendorStr,TestSet);
    OutDebugLog('Passed OK: '+inttostr(i*100));
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  testset: integer;
  i,j: integer;
begin
  Memo1.lines.Clear;
  EnableOutput.Checked:=false;
  TestSet:=0;
  if Test1.Checked then TestSet:=1;
  if Test2.Checked then TestSet:=TestSet+2;
  if Test3.Checked then TestSet:=TestSet+4;
  if Test4.Checked then TestSet:=TestSet+8;
  if Test5.Checked then TestSet:=TestSet+16;
  if Test6.Checked then TestSet:=TestSet+32;
  if Test7.Checked then TestSet:=TestSet+64;
  if Test8.Checked then TestSet:=TestSet+128;
  if Test9.Checked then TestSet:=TestSet+256;
  for i:=1 to 100 do begin
    for j:=1 to 100 do TestElement0('..\data\test.xml',GetVendorStr,TestSet);
    OutDebugLog('Passed OK: '+inttostr(i*100));
  end;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  //test1.Checked:=false;
  test2.Checked:=false;
  test3.Checked:=false;
  test4.Checked:=false;
  test5.Checked:=false;
  test6.Checked:=false;
  test7.Checked:=false;
  test8.Checked:=false;
  test9.Checked:=false;
  dom2.Checked:=false;
end;

Procedure GetSizeInfo( p: Pointer; s: String );
Var
  MemInfo: TMemoryBasicInformation;
Begin
  FillChar( MemInfo, Sizeof( MemInfo ), 0 );
  VirtualQuery( p,
                MemInfo, Sizeof( MemInfo ));
  OutLog( format('%s: %d',[S, MemInfo.RegionSize]));
End;

Procedure GetHeapInfo;
Begin
  //Form1.memo1.lines.add('Heap size: '+IntToStr( AllocMemSize ));
  With GetHeapStatus, Form1.memo1.lines Do Begin
    Add('TotalAddrSpace: '+IntToStr(TotalAddrSpace));
    //Add('TotalUncommitted: '+IntToStr(TotalUncommitted));
    //Add('TotalCommitted: '+IntToStr( TotalCommitted ));
    //Add('TotalAllocated: '+IntToStr( TotalAllocated ));
    //Add('TotalFree: '+IntToStr( TotalFree ));
    //Add('FreeSmall: '+IntToStr( FreeSmall ));
    //Add('FreeBig: '+IntToStr( FreeBig ));
    //Add('Unused: '+IntToStr( Unused ));
    //Add('Overhead: '+IntToStr( Overhead ));
    //Add('HeapErrorCode: '+IntToStr( HeapErrorCode ));
  End;
End;

procedure TForm1.Button11Click(Sender: TObject);
begin
  memo1.clear;
//  GetSizeInfo( Pointer( HInstance ), 'Commited bytes for process image');
//  GetSizeInfo( stack, 'Commited bytes for stack' );
//  GetSizeInfo( @Sysinit.Datamark, 'Commited bytes for data section' );
  GetHeapInfo;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  Memo1.lines.Clear;
  EnableOutput.Checked:=true;
  TestDom3(Combobox1.Text,GetVendorStr);
end;

Initialization
  asm
    mov stack, esp
  End;

end.
