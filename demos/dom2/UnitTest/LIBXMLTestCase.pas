unit LIBXMLTestCase;

interface

uses
  SysUtils, Classes, TestFrameWork, libxmldom, dom2, Dialogs, msxml_impl,
  ActiveX,GUITestRunner,StrUtils;

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
  public
  published
    procedure TestDocumentElement;
    procedure CreateElementNS;
    procedure CreateElementNS1;
    procedure CreateAttributeNS;
    procedure TestDocCount;
    procedure TestElementByID;
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
    procedure AppendExistingChild;
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
    procedure CreateElement10000Times;
    procedure CreateAttribute10000Times;
    procedure SetAttributeNode10000Times;
    procedure SetAttributeNodes1000Times;
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

procedure TTestDomExceptions.AppendExistingChild;
var
  node: IDOMNode;
begin
  {
    DOM2: If the child is already in the tree, it
    is first removed.
    So there must be only one child sub1 after the
    two calls of appendChild
  }
  node := doc.createElement('sub1');
  //temp:=node.parentNode;
  doc.documentElement.appendChild(node);
  //temp:=node.parentNode;
  doc.documentElement.appendChild(node);
  outLog((doc as IDOMPersist).xml);
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
  for i := 0 to 10000 do doc.createAttributeNS('http://xmlns.4commerce.de/eva','eva:name1');
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

procedure TTestMemoryLeaks.SetAttributeNodes1000Times;
var
  i: integer;
  attr: IDOMAttr;
begin
  for i := 0 to 1000 do begin
    attr := doc.createAttribute('test'+inttostr(i)) ;
    doc.documentElement.setAttributeNode(attr);
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
  if domvendor<>'LIBXML' then begin
    temp:=(rightStr(temp,53));
    temp:=(leftStr(temp,51));
  end else begin
    temp:=(rightStr(temp,52));
    temp:=(leftStr(temp,51));
  end;
  OutLog(temp);
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
  OutLog(temp);
  if domvendor<>'LIBXML' then begin
    temp:=(rightStr(temp,53));
    temp:=(leftStr(temp,51));
  end else begin
    temp:=(rightStr(temp,52));
    temp:=(leftStr(temp,51));
  end;
  //check(temp='<test><ct:test xmlns:ct="http://ns.4ct.de"/></test>','createElementNS failed');
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
  OutLog(temp);
end;

initialization
  RegisterTest('', TTestDom2Methods.Suite);
  RegisterTest('', TTestMemoryLeaks.Suite);
  RegisterTest('', TTestDomExceptions.Suite);
  CoInitialize(nil);
end.


