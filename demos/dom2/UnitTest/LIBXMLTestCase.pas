unit LIBXMLTestCase;

interface

uses
  SysUtils, Classes, TestFrameWork, libxmldom, dom2, Dialogs, msxml_impl,
  ActiveX,GUITestRunner;

const xmlstr = '<?xml version="1.0" encoding="iso-8859-1"?><test />';

type TTestCaseLIBXML = class(TTestCase)
  private
    doc: IDOMDocument;
    msdoc: IDOMDocument;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
  published
    procedure TestDocumentElement;
    procedure CreateElementNS;
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
    procedure AppendAttribute;
    procedure AppendExistingChild;
    procedure TestDocCount;
    procedure AppendNilNode;
    procedure InsertNilNode;
    procedure InsertAnchestor;
    procedure TestElementByID;
  end;


implementation

var impl: IDOMImplementation;

{ TTestCaseLIBXML }

{ TTestCaseLIBXML }

procedure TTestCaseLIBXML.SetUp;
var temp: integer;
begin
  inherited;
  impl := GetDom(domvendor);
  doc := impl.createDocument('','',nil);
  (doc as IDOMPersist).loadxml(xmlstr);
end;

procedure TTestCaseLIBXML.CreateElement10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do doc.createElement('test');
end;

procedure TTestCaseLIBXML.TestDocCount;
begin
  doc := nil;
  Check(doccount=0,'document not released');
end;

procedure TTestCaseLIBXML.AppendElement10000Times;
var
  i: integer;
  node: IDOMNode;
begin
  for i := 0 to 10000 do begin
    node := (doc.createElement('test') as IDOMNode);
    doc.documentElement.appendChild(node);

  end;
end;

procedure TTestCaseLIBXML.TestDocumentElement;
begin
  Check(doc.documentElement<>nil,'documentElement is nil');
end;

procedure TTestCaseLIBXML.AppendAttribute;
var
  attr: IDOMAttr;
begin
  try
    attr := doc.createAttribute('test');
    doc.documentElement.appendChild(attr);
    Check(False,'There should have been an EDomException');
  except
    on E: Exception do Check(E is EDomException);
  end;
end;

procedure TTestCaseLIBXML.AppendExistingChild;
var
  node,temp: IDOMNode;
begin
  node := doc.createElement('sub1');
  //temp:=node.parentNode;
  doc.documentElement.appendChild(node);
  //temp:=node.parentNode;
  doc.documentElement.appendChild(node);
  outLog((doc as IDOMPersist).xml);
end;

procedure TTestCaseLIBXML.TestElementByID;
var
  elem: IDOMElement;
begin
  elem := doc.getElementById('110');
end;

procedure TTestCaseLIBXML.AppendNilNode;
begin
  try
    doc.documentElement.appendChild(nil);
    Check(False,'There should have been an EDomError');
  except
    on E: Exception do Check(E is EDomException);
  end;
end;

procedure TTestCaseLIBXML.InsertNilNode;
var
  node: IDOMNode;
begin
  {
  ms-dom raises an exception for this test;
  lib-dom does not;
  w3c says an exception is not expected !
  }
  node := doc.createElement('sub1');
  doc.documentElement.appendChild(node);
  doc.documentElement.insertBefore(nil,node);
end;

procedure TTestCaseLIBXML.InsertAnchestor;
var node1,node2: IDOMNode;
begin
  {
  ms-dom raises an exception for this test;
  lib-dom does not;
  w3c says an exception is not expected !
  }
  node1 := doc.createElement('sub1');
  node2 := doc.createElement('sub2');
  node1.appendChild(node2);
  doc.documentElement.appendChild(node1);
  node1.insertBefore(doc.documentElement,node2);
end;

procedure TTestCaseLIBXML.TearDown;
begin
  doc := nil;
  inherited;
end;

procedure TTestCaseLIBXML.CreateComment10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do doc.createComment('test');
end;

procedure TTestCaseLIBXML.CreateAttribute10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do doc.createAttribute('test');
end;

procedure TTestCaseLIBXML.CreateCDataSection10000Times;
var
  i: integer;
begin
   for i := 0 to 10000 do doc.createCDATASection('test');
end;

procedure TTestCaseLIBXML.CreateTextNode10000Times;
var
  i: integer;
begin
   for i := 0 to 10000 do doc.createTextNode('test');
end;

procedure TTestCaseLIBXML.CreateDocumentFragment10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do doc.createDocumentFragment;
end;

procedure TTestCaseLIBXML.CreateAttributeNS10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do doc.createAttributeNS('http://xmlns.4commerce.de/eva','eva:name1');;
end;

procedure TTestCaseLIBXML.SetAttributeNode10000Times;
var
  i: integer;
  attr: IDOMAttr;
begin
  for i := 0 to 10000 do begin
    attr := doc.createAttribute('test') ;
  end;
end;

procedure TTestCaseLIBXML.SetAttributeNodes1000Times;
var
  i: integer;
  attr: IDOMAttr;
begin
  for i := 0 to 1000 do begin
    attr := doc.createAttribute('test'+inttostr(i)) ;
    doc.documentElement.setAttributeNode(attr);
  end;
end;

procedure TTestCaseLIBXML.SetAttributeNodesReplace10000Times;
var
  i: integer;
  attr: IDOMAttr;
begin
  for i := 0 to 10000 do begin
    attr := doc.createAttribute('test') ;
    doc.documentElement.setAttributeNode(attr);
  end;
end;

procedure TTestCaseLIBXML.CreateElementNS;
var
  node: IDOMNode;
begin
  node:=doc.createElementNS('http://ns.4ct.de','ct:test');
  doc.documentElement.appendChild(node);
  OutLog((doc as IDOMPersist).xml);
end;

initialization
  RegisterTest('', TTestCaseLIBXML.Suite);
  CoInitialize(nil);
end.


