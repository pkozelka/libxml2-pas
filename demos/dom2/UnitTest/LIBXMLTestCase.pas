unit LIBXMLTestCase;

interface

uses
  SysUtils, Classes, TestFrameWork, libxmldom, dom2, Dialogs, msxml_impl, ActiveX;

const xmlstr = '<?xml version="1.0" encoding="iso-8859-1"?><test />';

type TTestCaseLIBXML = class(TTestCase)
  private
    libdoc: IDOMDocument;
    msdoc: IDOMDocument;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
  published
    procedure TestDocumentElement;
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

var libimpl: IDOMImplementation;

{ TTestCaseLIBXML }

{ TTestCaseLIBXML }

procedure TTestCaseLIBXML.SetUp;
var temp: integer;
begin
  inherited;
  libimpl := GetDom('LIBXML');
  libdoc := libimpl.createDocument('','',nil);
  (libdoc as IDOMPersist).loadxml(xmlstr);
  //msimpl := GetDom('MSXML2_RENTAL_MODEL');
  //msdoc := msimpl.createDocument('','',nil);
  //(msdoc as IDOMPersist).loadxml(xmlstr);
end;

procedure TTestCaseLIBXML.CreateElement10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do libdoc.createElement('test');
end;

procedure TTestCaseLIBXML.TestDocCount;
begin
  libdoc := nil;
  Check(doccount=0,'document not released');
end;

procedure TTestCaseLIBXML.AppendElement10000Times;
var
  i: integer;
  node: IDOMNode;
begin
  for i := 0 to 10000 do begin
    node := (libdoc.createElement('test') as IDOMNode);
    libdoc.documentElement.appendChild(node);

  end;
end;

procedure TTestCaseLIBXML.TestDocumentElement;
begin
  Check(libdoc.documentElement<>nil,'documentElement is nil');
end;

procedure TTestCaseLIBXML.AppendAttribute;
var
  attr: IDOMAttr;
begin
  try
    attr := libdoc.createAttribute('test');
    libdoc.documentElement.appendChild(attr);
    Check(False,'There should have been an EDomException');
  except
    on E: Exception do Check(E is EDomException);
  end;
  {
  attr := msdoc.createAttribute('test');
  msdoc.documentElement.appendChild(attr);
  }
end;

procedure TTestCaseLIBXML.AppendExistingChild;
var
  node,temp: IDOMNode;
begin
  node := libdoc.createElement('sub1');
  //temp:=node.parentNode;
  libdoc.documentElement.appendChild(node);
  //temp:=node.parentNode;
  libdoc.documentElement.appendChild(node);
  {
  node := msdoc.createElement('sub1');
  msdoc.documentElement.appendChild(node);
  msdoc.documentElement.appendChild(node);
  }
  ShowMessage((libdoc as IDOMPersist).xml);
end;

procedure TTestCaseLIBXML.TestElementByID;
var
  elem: IDOMElement;
begin
  elem := libdoc.getElementById('110');
end;

procedure TTestCaseLIBXML.AppendNilNode;
begin
  try
    libdoc.documentElement.appendChild(nil);
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
  node := libdoc.createElement('sub1');
  libdoc.documentElement.appendChild(node);
  libdoc.documentElement.insertBefore(nil,node);
  {
  node := msdoc.createElement('sub1');
  msdoc.documentElement.appendChild(node);
  msdoc.documentElement.insertBefore(nil,node);
  }
end;

procedure TTestCaseLIBXML.InsertAnchestor;
var node1,node2: IDOMNode;
begin
  {
  ms-dom raises an exception for this test;
  lib-dom does not;
  w3c says an exception is not expected !
  }
  node1 := libdoc.createElement('sub1');
  node2 := libdoc.createElement('sub2');
  node1.appendChild(node2);
  libdoc.documentElement.appendChild(node1);
  node1.insertBefore(libdoc.documentElement,node2);
  {
  node1 := msdoc.createElement('sub1');
  node2 := msdoc.createElement('sub2');
  node1.appendChild(node2);
  msdoc.documentElement.appendChild(node1);
  node1.insertBefore(msdoc.documentElement,node2);
  }
end;

procedure TTestCaseLIBXML.TearDown;
begin
  libdoc := nil;
  inherited;
end;

procedure TTestCaseLIBXML.CreateComment10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do libdoc.createComment('test');
end;

procedure TTestCaseLIBXML.CreateAttribute10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do libdoc.createAttribute('test');
end;

procedure TTestCaseLIBXML.CreateCDataSection10000Times;
var
  i: integer;
begin
   for i := 0 to 10000 do libdoc.createCDATASection('test');
end;

procedure TTestCaseLIBXML.CreateTextNode10000Times;
var
  i: integer;
begin
   for i := 0 to 10000 do libdoc.createTextNode('test');
end;

procedure TTestCaseLIBXML.CreateDocumentFragment10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do libdoc.createDocumentFragment;
end;

procedure TTestCaseLIBXML.CreateAttributeNS10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do libdoc.createAttributeNS('http://xmlns.4commerce.de/eva','eva:name1');;
end;

procedure TTestCaseLIBXML.SetAttributeNode10000Times;
var
  i: integer;
  attr: IDOMAttr;
begin
  for i := 0 to 10000 do begin
    attr := libdoc.createAttribute('test') ;
  end;
end;

procedure TTestCaseLIBXML.SetAttributeNodes1000Times;
var
  i: integer;
  attr: IDOMAttr;
begin
  for i := 0 to 1000 do begin
    attr := libdoc.createAttribute('test'+inttostr(i)) ;
    libdoc.documentElement.setAttributeNode(attr);
  end;
end;

procedure TTestCaseLIBXML.SetAttributeNodesReplace10000Times;
var
  i: integer;
  attr: IDOMAttr;
begin
  for i := 0 to 10000 do begin
    attr := libdoc.createAttribute('test') ;
    libdoc.documentElement.setAttributeNode(attr);
  end;
end;

initialization
  RegisterTest('', TTestCaseLIBXML.Suite);
  CoInitialize(nil);
end.


