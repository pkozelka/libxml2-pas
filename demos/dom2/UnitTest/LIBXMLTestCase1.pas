unit LIBXMLTestCase;

interface

uses
  SysUtils, Classes, TestFrameWork, libxmldom, dom2, Dialogs, msxml_impl,
  ActiveX,GUITestRunner,StrUtils,jkDomTest;

const
  xmlstr  = '<?xml version="1.0" encoding="iso-8859-1"?><test />';
  xmlstr1 = '<?xml version="1.0" encoding="iso-8859-1"?><test xmlns=''http://ns.4ct.de''/>';

type TTestDOM2Methods = class(TTestCase)
  private
    doc: IDOMDocument;
    doc1: IDOMDocument;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    function getCont(xml:string):string;
  public
  published
    procedure ShowDom;
    procedure AppendExistingChild;
    procedure TestDocumentElement;
    procedure CreateElementNS;
    procedure CreateElementNS1;
    procedure CreateAttributeNS;
    procedure TestDocCount;
    procedure TestElementByID;
    procedure jkTestDocument;
    procedure jkTestElement;
    procedure jkNamedNodemap;
  end;

type TTestDomExceptions = class(TTestCase)
  private
    doc: IDOMDocument;
    doc1: IDOMDocument;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
  published
    procedure AppendAttribute;

    procedure AppendNilNode;
    procedure InsertNilNode;
    procedure InsertAnchestor;
  end;


type TTestMemoryLeaks = class(TTestCase)
  private
    doc: IDOMDocument;
    doc1: IDOMDocument;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
  published
    procedure ElementAttribute10000Times;
    procedure CreateElement10000Times;
    procedure CreateAttribute10000Times;
    procedure SetAttributeNode10000Times;
    procedure SetAttributeNodes5000Times;
    procedure SetAttributeNodesReplace10000Times;
    procedure CreateAttributeNS10000Times;
    procedure CreateComment10000Times;
    procedure CreateCDataSection10000Times;
    procedure CreateDocumentFragment10000Times;
    procedure CreateTextNode10000Times;
    procedure AppendElement10000Times;
  end;


implementation

var impl: IDOMImplementation;

{ TTestCaseLIBXML }

{ TTestCaseLIBXML }

procedure TTestDom2Methods.SetUp;
begin
  inherited;
  impl := GetDom(domvendor);
  doc := impl.createDocument('','',nil);
  (doc as IDOMPersist).loadxml(xmlstr);
  doc1 := impl.createDocument('','',nil);
  (doc1 as IDOMPersist).loadxml(xmlstr1);
end;

procedure TTestMemoryLeaks.SetUp;
begin
  inherited;
  impl := GetDom(domvendor);
  doc := impl.createDocument('','',nil);
  (doc as IDOMPersist).loadxml(xmlstr);
  doc1 := impl.createDocument('','',nil);
  (doc1 as IDOMPersist).loadxml(xmlstr1);
end;

procedure TTestDomExceptions.SetUp;
begin
  inherited;
  impl := GetDom(domvendor);
  doc := impl.createDocument('','',nil);
  (doc as IDOMPersist).loadxml(xmlstr);
  doc1 := impl.createDocument('','',nil);
  (doc1 as IDOMPersist).loadxml(xmlstr1);
end;

procedure TTestMemoryLeaks.CreateElement10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do doc.createElement('test');
end;

procedure TTestDom2Methods.TestDocCount;
begin
  doc := nil;
  doc1 := nil;
  Check(doccount=0,'documents not released');
end;

procedure TTestMemoryLeaks.TearDown;
begin
  doc := nil;
  doc1 := nil;
end;

procedure TTestDomExceptions.TearDown;
begin
  doc := nil;
  doc1 := nil;
end;

procedure TTestMemoryLeaks.AppendElement10000Times;
var
  i: integer;
  node: IDOMNode;
begin
  for i := 0 to 10000 do begin
    node := (doc.createElement('test') as IDOMNode);
    doc.documentElement.appendChild(node);

  end;
end;

procedure TTestDom2Methods.TestDocumentElement;
begin
  Check(doc.documentElement<>nil,'documentElement is nil');
end;

procedure TTestDomExceptions.AppendAttribute;
var
  attr: IDOMAttr;
begin
  try
    attr := doc.createAttribute('test');
    doc.documentElement.appendChild(attr);
    Check(False,'There should have been an EDomException');
  except
    on E: Exception do Check(E is EDomException,'Warning: Wrong exception type!');
  end;
end;

procedure TTestDom2Methods.AppendExistingChild;
var
  node: IDOMNode;
  temp: string;
begin
  {
    DOM2: If the child is already in the tree, it
    is first removed.
    So there must be only one child sub1 after the
    two calls of appendChild
  }
  node := doc.createElement('sub1');
  doc.documentElement.appendChild(node);
  doc.documentElement.appendChild(node);
  temp:=((doc as IDOMPersist).xml);
  temp:=getCont(temp);
  check(temp='<test><sub1/></test>','appendChild Error');
end;

procedure TTestDom2Methods.TestElementByID;
var
  elem: IDOMElement;
begin
  elem := doc.getElementById('110');
end;

procedure TTestDomExceptions.AppendNilNode;
begin
  try
    doc.documentElement.appendChild(nil);
    Check(False,'There should have been an EDomError');
  except
    on E: Exception do Check(E is EDomException,'Warning: Wrong exception type!');
  end;
end;

procedure TTestDomExceptions.InsertNilNode;
var
  node: IDOMNode;
begin
  node := doc.createElement('sub1');
  doc.documentElement.appendChild(node);
  try
    doc.documentElement.insertBefore(nil,node);
    Check(False,'There should have been an EDomError');
  except
    on E: Exception do Check(E is EDomException,'Warning: Wrong exception type!');
  end;
end;

procedure TTestDomExceptions.InsertAnchestor;
var node1,node2: IDOMNode;
begin
  node1 := doc.createElement('sub1');
  node2 := doc.createElement('sub2');
  node1.appendChild(node2);
  doc.documentElement.appendChild(node1);
  try
    node1.insertBefore(doc.documentElement,node2);
    Check(False,'There should have been an EDomError');
  except
    on E: Exception do Check(E is EDomException,'Warning: Wrong exception type!');
  end;
end;

procedure TTestDom2Methods.TearDown;
begin
  doc := nil;
  doc1:= nil;
  inherited;
end;

procedure TTestMemoryLeaks.CreateComment10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do doc.createComment('test');
end;

procedure TTestMemoryLeaks.CreateAttribute10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do doc.createAttribute('test');
end;

procedure TTestMemoryLeaks.CreateCDataSection10000Times;
var
  i: integer;
begin
   for i := 0 to 10000 do doc.createCDATASection('test');
end;

procedure TTestMemoryLeaks.CreateTextNode10000Times;
var
  i: integer;
begin
   for i := 0 to 10000 do doc.createTextNode('test');
end;

procedure TTestMemoryLeaks.CreateDocumentFragment10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do doc.createDocumentFragment;
end;

procedure TTestMemoryLeaks.CreateAttributeNS10000Times;
var
  i: integer;
begin
  for i := 0 to 2000 do
    doc.createAttributeNS('http://xmlns.4commerce.de/eva','eva:name1');
end;

procedure TTestMemoryLeaks.SetAttributeNode10000Times;
var
  i: integer;
  attr: IDOMAttr;
begin
  for i := 0 to 10000 do begin
    attr := doc.createAttribute('test') ;
  end;
end;

procedure TTestMemoryLeaks.SetAttributeNodes5000Times;
var
  i: integer;
  attr: IDOMAttr;
  element:IDOMElement;
begin
  for i := 0 to 5000 do begin
    attr := doc.createAttribute('test'+inttostr(i)) ;
    element:=doc.documentElement;
    element.setAttributeNode(attr);
  end;
end;

procedure TTestMemoryLeaks.SetAttributeNodesReplace10000Times;
var
  i: integer;
  attr: IDOMAttr;
begin
  for i := 0 to 10000 do begin
    attr := doc.createAttribute('test') ;
    doc.documentElement.setAttributeNode(attr);
  end;
end;

procedure TTestDom2Methods.CreateElementNS;
const
  CRLF=#13#10;
var
  node: IDOMNode;
  temp: string;
begin
  node:=doc.createElementNS('http://ns.4ct.de','ct:test');
  doc.documentElement.appendChild(node);
  temp:=(doc as IDOMPersist).xml;
  temp:=getCont(temp);
  check(temp='<test><ct:test xmlns:ct="http://ns.4ct.de"/></test>','createElementNS failed');
end;

procedure TTestDom2Methods.CreateElementNS1;
const
  CRLF=#13#10;
var
  node: IDOMNode;
  temp: string;
begin
  node:=doc1.createElementNS('http://ns.4ct.de','ct:test');
  doc1.documentElement.appendChild(node);
  temp:=(doc1 as IDOMPersist).xml;
  temp:=getCont(temp);
  check(temp='<test xmlns="http://ns.4ct.de"><ct:test xmlns:ct="http://ns.4ct.de"/></test>','createElementNS failed');
end;

procedure TTestDom2Methods.CreateAttributeNS;
var
  attr: IDOMAttr;
  temp: String;
begin
  attr:=doc.createAttributeNS('http://ns.4ct.de','ct:name1');
  attr.value:='hund';
  doc.documentElement.setAttributeNodeNS(attr);
  temp:=(doc as IDOMPersist).xml;
  temp:=getCont(temp);
  //OutLog(temp);
  check(temp='<test xmlns:ct="http://ns.4ct.de" ct:name1="hund"/>','failed')
end;

function TTestDOM2Methods.getCont(xml:string):string;
// this function cuts the first line and
// the leading crlf
// ToDo: should be replaced by a more general implementation
begin
  if domvendor='LIBXML' then begin
    result:=rightstr(xml,length(xml)-44);
    result:=leftstr(result,length(result)-1);
  end else begin
    result:=rightstr(xml,length(xml)-23);
    result:=leftstr(result,length(result)-2);
  end;
end;

procedure TTestDOM2Methods.ShowDom;
var
  el: IDOMElement;
  temp: string;
begin
  el:=doc.createElement('books');
  doc.documentElement.appendChild(el);
  temp:=((doc as IDOMPersist).xml);
  outlog(getCont(temp));
end;

procedure TTestDOM2Methods.jkTestDocument;
var
  TestSet: integer;
  TestsOK: integer;
  i,j: integer;
begin
  TestSet:=0;
  for j:=1 to 50 do begin
    for i:=1 to 100 do begin
      TestsOK:=TestDocument('..\data\test.xml',domvendor,TestSet);
      //OutLog('Passed OK: '+inttostr(TestsOK));
      Check((TestsOK >= 1),(inttostr(1-TestsOK)+' Tests failed!')); //15
    end;
    OutLog('Passed OK: '+inttostr(j*100));
  end;
end;

procedure TTestDOM2Methods.jkTestElement;
var
  TestSet: integer;
  TestsOK: integer;
  i,j: integer;
begin
  TestSet:=0;
  for j:=1 to 50 do begin
    for i:=1 to 100 do begin
      TestsOK:=TestElement0('..\data\test.xml',domvendor,TestSet);
      //OutLog('Passed OK: '+inttostr(TestsOK));
      Check((TestsOK >= 1),(inttostr(1-TestsOK)+' Tests failed!'));
    end;
    OutLog('Passed OK: '+inttostr(j*100));
  end;
end;

procedure TTestMemoryLeaks.ElementAttribute10000Times;
var
  attr: IDOMAttr;
  element: IDOMElement;
  i: integer;
begin
  for i:=1 to 10000 do begin
    attr := doc.createAttribute('loop');
    element := doc.createElement('iii');
    attr := element.setAttributeNode(attr);
    attr := nil;
    //test('element.setAttributeNode',(element.hasAttribute('loop')));
    element.hasAttribute('loop');
    element:=nil;
    //outLog (inttostr(elementcount));
  end;
end;

procedure TTestDOM2Methods.jkNamedNodemap;
var
  TestSet: integer;
  TestsOK: integer;
  i,j: integer;
begin
  TestSet:=0;
  for j:=1 to 50 do begin
    for i:=1 to 1 do begin
      TestsOK:=TestNamedNodemap('..\data\test.xml',domvendor,TestSet);
      //OutLog('Passed OK: '+inttostr(TestsOK));
      Check((TestsOK >= 1),(inttostr(1-TestsOK)+' Tests failed!')); //15
    end;
    OutLog('Passed OK: '+inttostr(j*100));
  end;
end;

initialization
  RegisterTest('', TTestDom2Methods.Suite);
  RegisterTest('', TTestMemoryLeaks.Suite);
  RegisterTest('', TTestDomExceptions.Suite);
  CoInitialize(nil);
end.


