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
    procedure Button3Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function GetVendorStr: string;

var
  Form1: TForm1;

implementation
uses jkDomTest,feDomTest,conapp;

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
begin
  OutLog('Disabled!');
  //native1(Combobox1.Text)
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
var i: integer;
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
  TestDom2(Combobox1.Text,GetVendorStr);
  time:=TestDom2(Combobox1.Text,GetVendorStr);
   if not EnableOutput.Checked
     then outDebugLog('Everage time: '+format('%8.1f',[time*1000])+' ms');
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  EnableOutput.Checked:=true;
  TestGDom3('test.xml',GetVendorStr);
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  OutLog('Disabled!');
  //Native2;
end;

function GetVendorStr: string;
begin
  if Form1.RbMSXML.Checked
    then result := 'MSXML2_RENTAL_MODEL'
    else result := 'LIBXML';
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  i: integer;
  time: double;
begin
  EnableOutput.Checked:=false;
  time:=0;
  OutDebugLog('Start!');
  for i:=1 to 100 do
    time:=time+TestGDom3('test.xml',GetVendorStr);
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


procedure TForm1.Button3Click(Sender: TObject);
var i: integer;
begin
  OutLog('Disabled!');
  //for i:=1 to 100 do
    //native3(Combobox1.Text);
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  OutLog('Disabled!');
  //SimpleDom(Combobox1.Text,GetVendorStr);
end;

procedure TForm1.Button11Click(Sender: TObject);
var i: integer;
begin
  OutLog('Disabled!');
  //for i:=1 to 100 do
    //SimpleDom(Combobox1.Text,GetVendorStr);
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
    time:=time+TestDom2(Combobox1.Text,GetVendorStr);
  outDebugLog('Everage time: '+format('%8.1f',[time*1000/100])+' ms');
end;

end.
