unit XPTest_xdom2_TestCase;

interface

uses
  SysUtils, Classes, TestFrameWork, libxmldom, xdom2, Dialogs, msxml_impl,
  ActiveX,GUITestRunner,StrUtils,jkDomTest, ComObj;

const

  xmlstr  = '<?xml version="1.0" encoding="iso-8859-1"?><test />';
  xmlstr1 = '<?xml version="1.0" encoding="iso-8859-1"?><test xmlns=''http://ns.4ct.de''/>';
  xmlstr2 = '<?xml version="1.0" encoding="iso-8859-1"?>'+
            '<!DOCTYPE root ['+
            '<!ELEMENT root (test*)>'+
            '<!ELEMENT test (#PCDATA)>'+
            '<!ATTLIST test name CDATA #IMPLIED>'+
            '<!ENTITY ct "4 commerce technologies">'+
            '<!NOTATION type2 SYSTEM "program2">'+
            '<!ENTITY FOO2 SYSTEM "file.type2" NDATA type2>'+
            ']>'+
            '<root />';

type EUnknownDomVendor = Exception;

type TTestDOM2Methods = class(TTestCase)
  private
    doc: IDOMDocument;
    doc1: IDOMDocument;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    function getCont(xml:string):string;
  published
    procedure ShowDom;
    procedure AppendExistingChild;
    procedure TestDocumentElement;
    procedure CreateElementNS;
    procedure CreateElementNS1;
    procedure CreateAttributeNS;
    procedure TestDocCount;
    procedure TestElementByID;
    procedure LoadFiles;
    procedure LoadFilesII;
    procedure append_100_attributes_with_different_namespaces;
  end;

type TTestDomExceptions = class(TTestCase)
  private
    doc: IDOMDocument;
    doc1: IDOMDocument;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
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
    procedure jkTestDocument;
    procedure jkTestElement;
    procedure jkNamedNodemap;
  end;

type TSimpleTests = class(TTestCase)
  private
    doc: IDOMDocument;
    node: IDOMNode;
    elem: IDOMElement;
    attr: IDOMAttr;
    text: IDOMText;
    nodelist: IDOMNodeList;
    cdata: IDOMCDATASection;
    comment: IDOMComment;
    pci: IDOMProcessingInstruction;
    docfrag: IDOMDocumentFragment;
    ent: IDOMEntity;
    entref: IDOMEntityReference;
    select: IDOMNodeSelect;
    nnmap: IDOMNamedNodeMap;
    nsuri: string;
    prefix: string;
    name: string;
    data: string;
    function getFqname: string;
    function myIsSameNode(node1,node2: IDOMNode): boolean;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure document;
    procedure documentElement;
    procedure domImplementation;
    procedure docType;
    procedure createDocument;
    procedure createDocument1;
    procedure createDocument2;
    procedure createDocument3;
    procedure createElement;
    procedure createElement1;
    procedure createElementNS;
    procedure createElementNS1;
    procedure createElementNS2;
    procedure createElementNS3;
    procedure createAttribute;
    procedure createAttribute1;
    procedure createAttributeNS;
    procedure createAttributeNS1;
    procedure createAttributeNS2;
    procedure createAttributeNS3;
    procedure createAttributeNS4;
    procedure createAttributeNS5;
    procedure createTextNode;
    procedure createCDATASection;
    procedure createComment;
    procedure createDocumentFragment;
    procedure createProcessingInstruction;
    procedure createProcessingInstruction1;
    procedure createEntityReference;
    procedure createEntityReference1;
    procedure getAttribute_setAttribute;
    procedure getAttributeNS_setAttributeNS;
    procedure getAttributeNode_setAttributeNode;
    procedure getAttributeNodeNS_setAttributeNodeNS;
    procedure hasAttribute;
    procedure hasAttributeNS;
    procedure removeAttribute;
    procedure removeAttributeNS;
    procedure removeAttributeNode;
    procedure getElementsByTagName;
    procedure getElementsByTagNameNS;
    procedure firstChild;
    procedure lastChild;
    procedure nextSibling;
    procedure previousSibling;
    procedure cloneNode;
    procedure insertBefore;
    procedure insertBefore1;
    procedure insertBefore2;
    procedure insertBefore3;
    procedure insertBefore4;
    procedure removeChild;
    procedure appendChild;
    procedure appendChild1;
    procedure appendChild2;
    procedure appendChild3;
    procedure appendChild4;
    procedure replaceChild;
    procedure isSupported;
    procedure normalize;
    procedure importNode;
    procedure hasChildNodes;
    procedure childNodes;
    procedure attributes;
    procedure ownerElement;
    procedure selectNodes;
    procedure selectNodes2;
    procedure selectNodes3;
    procedure namedNodeMap;
    procedure namedNodeMapNS;
    procedure persist;
    procedure documentFragment;
    property fqname: string read getFqname;
  end;


implementation

var
  impl: IDOMImplementation;
  datapath: string ='';

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

procedure TTestMemoryLeaks.createElement10000Times;
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

procedure TTestMemoryLeaks.createComment10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do doc.createComment('test');
end;

procedure TTestMemoryLeaks.createAttribute10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do doc.createAttribute('test');
end;

procedure TTestMemoryLeaks.createCDataSection10000Times;
var
  i: integer;
begin
   for i := 0 to 10000 do doc.createCDATASection('test');
end;

procedure TTestMemoryLeaks.createTextNode10000Times;
var
  i: integer;
begin
   for i := 0 to 10000 do doc.createTextNode('test');
end;

procedure TTestMemoryLeaks.createDocumentFragment10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do doc.createDocumentFragment;
end;

procedure TTestMemoryLeaks.createAttributeNS10000Times;
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

procedure TTestDom2Methods.createElementNS;
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

procedure TTestDom2Methods.createElementNS1;
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

procedure TTestDom2Methods.createAttributeNS;
var
  attr: IDOMAttr;
  temp: String;
begin
  attr:=doc.createAttributeNS('http://ns.4ct.de','ct:name1');
  attr.value:='hund';
  doc.documentElement.setAttributeNodeNS(attr);
  temp:=(doc as IDOMPersist).xml;
  temp:=getCont(temp);
  check(temp='<test xmlns:ct="http://ns.4ct.de" ct:name1="hund"/>','failed')
end;

procedure TTestDOM2Methods.append_100_attributes_with_different_namespaces;
var
  attr: IDOMAttr;
  i: integer;
  attrval,temp: string;
  ok: boolean;
begin
  // create attributes
  for i := 0 to 2 do begin
    attr := doc.createAttributeNS('http://test'+IntToStr(i)+'.invalid','test'+IntToStr(i)+':attr');
    attr.value := IntToStr(i);
    doc.documentElement.setAttributeNodeNS(attr);
    attr := nil;
  end;
  temp:=(doc as IDOMPersist).xml;
  temp:=getCont(temp);
  OutLog(temp);
  ok:=false;
  if temp='<test xmlns:test0="http://test0.invalid" test0:attr="0" xmlns:test1="http://test1.invalid" test1:attr="1" xmlns:test2="http://test2.invalid" test2:attr="2"/>'
    then ok:=true;
  if temp='<test xmlns:test0="http://test0.invalid" xmlns:test1="http://test1.invalid" xmlns:test2="http://test2.invalid" test0:attr="0" test1:attr="1" test2:attr="2"/>'
    then ok:=true;
  Check(ok,'Test failed!');
  // check attributes
  for i := 0 to 2 do begin
    attrval := doc.documentElement.getAttributeNS('http://test'+IntToStr(i)+'.invalid','attr');
    check(attrval = IntToStr(i),'expected '+IntToStr(i)+' but found '+attrval);
  end;
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

procedure TTestMemoryLeaks.jkTestDocument;
var
  TestSet: integer;
  TestsOK: integer;
  i,j: integer;
  temp:string;
begin
  temp:=includetrailingpathdelimiter(datapath);
  TestSet:=0;
  for j:=1 to 50 do begin
    for i:=1 to 100 do begin
      TestsOK:=TestDocument(temp+'test.xml',domvendor,TestSet);
      //OutLog('Passed OK: '+inttostr(TestsOK));
      Check((TestsOK >= 15),(inttostr(15-TestsOK)+' Tests failed!')); //15
    end;
    OutLog('Passed OK: '+inttostr(j*100));
  end;
end;

procedure TTestMemoryLeaks.jkTestElement;
var
  TestSet: integer;
  TestsOK: integer;
  i,j: integer;
  temp: string;
begin
  temp:=includetrailingpathdelimiter(datapath);
  TestSet:=0;
  for j:=1 to 50 do begin
    for i:=1 to 100 do begin
      TestsOK:=TestElement0(temp+'test.xml',domvendor,TestSet);
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

procedure TTestMemoryLeaks.jkNamedNodemap;
var
  TestSet: integer;
  TestsOK: integer;
  i,j: integer;
  temp: string;
begin
  temp:=includetrailingpathdelimiter(datapath);
  TestSet:=0;
  for j:=1 to 50 do begin
    for i:=1 to 1 do begin
      TestsOK:=TestNamedNodemap(temp+'test.xml',domvendor,TestSet);
      //OutLog('Passed OK: '+inttostr(TestsOK));
      Check((TestsOK >= 1),(inttostr(1-TestsOK)+' Tests failed!')); //15
    end;
    OutLog('Passed OK: '+inttostr(j*100));
  end;
end;

{ TSimpleTests }

procedure TSimpleTests.appendChild;
begin
  elem := doc.createElement(name);
  doc.documentElement.appendChild(elem);
  check(doc.documentElement.hasChildNodes, 'is false');
  check(myIsSameNode(elem,doc.documentElement.firstChild) ,'wrong node');
end;

procedure TSimpleTests.appendChild1;
begin
  elem := doc.createElement(name);
  // node is of a type that does not allow children of the type of the newChild node
  try
    elem.appendChild(doc as IDOMNode);
    check(False, 'exception not raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = HIERARCHY_REQUEST_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.appendChild2;
begin
  elem := doc.createElement(name);
  doc.documentElement.appendChild(elem);
  // node to append is one of this node's ancestors
  try
    elem.appendChild(doc.documentElement);
    check(False, 'exception not raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = HIERARCHY_REQUEST_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.appendChild3;
begin
  elem := doc.createElement(name);
  // node to append is this node itself
  try
    elem.appendChild(elem);
    check(False, 'exception not raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = HIERARCHY_REQUEST_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.appendChild4;
var
  doc2: IDOMDocument;
begin
  doc2 := impl.createDocument('','',nil);
  (doc2 as IDOMPersist).loadxml(xmlstr);
  elem := doc2.createElement(name);
  // if newChild was created from a different document
  // than the one that created this node
  try
    doc.documentElement.appendChild(elem);
    check(False, 'exception not raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = WRONG_DOCUMENT_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.attributes;
const
  n = 10;
var
  i: integer;
begin
  elem := doc.createElement(name);
  for i := 0 to n-1 do begin
    elem.setAttribute(name+IntToStr(i),IntToStr(i));
  end;
  check(elem.attributes.length = n, 'wrong length');
  for i := 0 to elem.attributes.length-1 do begin
    check(elem.attributes.item[i].nodeName = name+IntToStr(i), 'wrong nodeName');
    check(elem.attributes.item[i].nodeValue = IntToStr(i), 'wrong nodeValue');
    check(elem.attributes.item[i].nodeType = ATTRIBUTE_NODE, 'wrong nodeType');
  end;
end;

procedure TSimpleTests.childNodes;
const
  n = 10;
var
  i: integer;
begin
  check(doc.documentElement.childNodes.length = 0, 'wrong length');
  for i := 0 to n-1 do begin
    elem := doc.createElement(name+IntToStr(i));
    doc.documentElement.appendChild(elem);
  end;
  check(doc.documentElement.childNodes.length = n, 'wrong length');
  for i := 0 to doc.documentElement.childNodes.length-1 do begin
    node := doc.documentElement.childNodes.item[i];
    check(node <> nil, 'is nil');
    check(node.nodeName = name+IntToStr(i), 'wrong nodeName');
    check(node.nodeType = ELEMENT_NODE, 'wrong noodeType');
    check(myIsSameNode(node.parentNode,doc.documentElement), 'wrong parentNode');
    node := doc.documentElement.childNodes[i];
    check(node <> nil, 'is nil');
    check(node.nodeName = name+IntToStr(i), 'wrong nodeName');
    check(node.nodeType = ELEMENT_NODE, 'wrong noodeType');
    check(myIsSameNode(node.parentNode,doc.documentElement), 'wrong parentNode');
  end;
end;

procedure TSimpleTests.cloneNode;
begin
  elem := doc.createElement(name);
  node := doc.createElement('child');
  elem.appendChild(node);
  doc.documentElement.appendChild(elem);
  node := elem.cloneNode(False);
  check(node <> nil, 'is nil');
  check(node.nodeName = name, 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(not node.hasChildNodes, 'is true');
  node := elem.cloneNode(True);
  check(node <> nil, 'is nil');
  check(node.nodeName = name, 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(node.hasChildNodes, 'is false');
end;

procedure TSimpleTests.createAttribute;
begin
  attr := doc.createAttribute(name);
  check(attr <> nil, 'is nil');
  check(attr.name = name, 'wrong name');
  check(attr.nodeName = name, 'wrong nodeName');
  check(attr.namespaceURI = '', 'wrong namespaceURI');
  check(attr.localName = '', 'wrong localName');
  check(attr.prefix = '', 'wrong prefix');
  check(attr.value = '', 'wrong value');
  check(attr.ownerDocument = doc, 'wrong ownerDocument');
end;

procedure TSimpleTests.createAttribute1;
begin
  // the specified name contains an illegal character
  try
    attr := doc.createAttribute('!@"#');
    check(False, 'exception not raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = INVALID_CHARACTER_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createAttributeNS;
begin
  attr := doc.createAttributeNS(nsuri,fqname);
  check(attr <> nil, 'is nil');
  attr.value := 'kamel';
  check(attr.name = fqname, 'wrong name');
  check(attr.nodeName = fqname, 'wrong nodeName');
  check(attr.nodeType = ATTRIBUTE_NODE, 'wrong nodeType');
  check(attr.namespaceURI = nsuri, 'wrong namespaceURI');
  check(attr.prefix = prefix, 'wrong prefix');
  check(attr.localName = name, 'wrong localName');
  check(attr.specified, 'is false');
  check(attr.value = 'kamel', 'wrong value');
end;

procedure TSimpleTests.createAttributeNS1;
begin
  // the specified name contains an illegal character
  try
    attr := doc.createAttributeNS(nsuri,'!@"#');
    check(False, 'exception not raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = INVALID_CHARACTER_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createAttributeNS2;
begin
  // the qualifiedName has a prefix and the namespaceURI is null
  try
    attr := doc.createAttributeNS('','ct:test');
    check(False, 'exception not raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createAttributeNS3;
begin
  // the qualifiedName has a prefix that is "xml" and
  // the namespaceURI is different from "http://www.w3.org/XML/1998/namespace"
  try
    attr := doc.createAttributeNS(nsuri,'xml:test');
    check(False, 'exception not raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createAttributeNS4;
begin
  // the qualifiedName is "xmlns"
  // and the namespaceURI is different from "http://www.w3.org/2000/xmlns/".
  try
    attr := doc.createAttributeNS(nsuri,'xmlns');
    check(False, 'exception not raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createAttributeNS5;
begin
  // the prefix is "xmlns"
  // and the namespaceURI is different from "http://www.w3.org/2000/xmlns/".
  try
    attr := doc.createAttributeNS(nsuri,'xmlns:test');
    check(False, 'exception not raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createCDATASection;
begin
  cdata := doc.createCDataSection(data);
  check(cdata <> nil, 'is nil');
  check(cdata.data = data, 'wrong data');
  check(cdata.length = Length(data), 'wrong length');
  check(cdata.nodeName = '#cdata-section', 'wrong nodeName');
  check(cdata.nodeValue = data, 'wrong nodeValue');
  check(cdata.nodeType = CDATA_SECTION_NODE, 'wrong nodeType');
  cdata.appendData(data);
  check(cdata.nodeValue = data+data, 'wrong nodeValue');
  check(cdata.subStringData(0,Length(data)) = data, 'wrong subStringData - expected: "'+data+'" found: "'+cdata.subStringData(0,Length(data))+'"');
  cdata.insertData(0,'0');
  check(cdata.nodeValue = '0'+data+data, 'wrong nodeValue');
  cdata.deleteData(0,1);
  check(cdata.nodeValue = data+data, 'wrong nodeValue');
  cdata.replaceData(Length(data),Length(data),'');
  check(cdata.nodeValue = data, 'wrong nodeValue');
end;

procedure TSimpleTests.createComment;
begin
  comment := doc.createComment(data);
  check(comment <> nil, 'is nil');
  check(comment.data = data, 'wrong data');
  check(comment.length = Length(data), 'wrong length');
  check(comment.nodeName = '#comment', 'wrong nodeName');
  check(comment.nodeValue = data, 'wrong nodeValue');
  check(comment.nodeType = COMMENT_NODE, 'wrong nodeType');
end;

procedure TSimpleTests.createDocument;
begin
  // the specified qualified name contains an illegal character
  try
    doc := impl.createDocument('','"',nil);
    check(False, 'no exception raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = INVALID_CHARACTER_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createDocument1;
begin
  // the qualifiedName has a prefix and the namespaceURI is null
  try
    doc := impl.createDocument('',fqname,nil);
    check(False, 'no exception raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createDocument2;
begin
  // the qualifiedName is null and the namespaceURI is different from null
  try
    doc := impl.createDocument(nsuri,'',nil);
    check(False, 'no exception raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createDocument3;
begin
  // the qualifiedName has a prefix that is "xml" and
  // the namespaceURI is different from "http://www.w3.org/XML/1998/namespace"
  try
    doc := impl.createDocument(nsuri,'xml:test',nil);
    check(False, 'no exception raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createDocumentFragment;
begin
  docfrag := doc.createDocumentFragment;
  check(docfrag <> nil, 'is nil');
  check(docfrag.nodeName = '#document-fragment', 'wrong nodeName');
  check(docfrag.nodeType = DOCUMENT_FRAGMENT_NODE, 'wrong nodeType');
end;

procedure TSimpleTests.createElement;
begin
  elem := doc.createElement(name);
  check(elem <> nil, 'is nil');
  check(elem.nodeName = name, 'wrong nodeName');
  check(elem.tagName = name, 'wrong tagName');
  check(elem.ownerDocument = doc, 'wrong ownerDocument');
  check(elem.namespaceURI = '', 'wrong namespaceURI');
  check(elem.prefix = '', 'wrong prefix');
  check(elem.localName = '', 'wrong localName');
end;

procedure TSimpleTests.createElement1;
begin
  // the specified name contains an illegal character
  try
    elem := doc.createElement('!@#"');
    check(False, 'no exception raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = INVALID_CHARACTER_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createElementNS;
begin
  elem := doc.createElementNS(nsuri,fqname);
  check(elem <> nil, 'is nil');
  check(elem.nodeName = fqname, 'wrong nodeName');
  check(elem.tagName = fqname, 'wrong tagName');
  check(elem.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(elem.namespaceURI = nsuri, 'wrong namespaceURI');
  check(elem.prefix = prefix, 'wrong prefix');
  check(elem.localName = name, 'wrong name');
end;

procedure TSimpleTests.createElementNS1;
begin
  // the specified qualified name contains an illegal character
  try
    elem := doc.createElementNS(nsuri,'"');
    check(False, 'no exception raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = INVALID_CHARACTER_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createElementNS2;
begin
  // the qualifiedName has a prefix and the namespaceURI is null
  try
    elem := doc.createElementNS('',fqname);
    check(False, 'no exception raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createElementNS3;
begin
  // the qualifiedName has a prefix that is "xml" and
  // the namespaceURI is different from "http://www.w3.org/XML/1998/namespace"
  try
    elem := doc.createElementNS(nsuri,'xml:test');
    check(False, 'no exception raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createEntityReference;
begin
  entref := doc.createEntityReference(name);
  check(entref <> nil, 'is nil');
  check(entref.nodeName = name, 'wrong nodeName');
  check(entref.nodeType = ENTITY_REFERENCE_NODE, 'wrong nodeType');
end;

procedure TSimpleTests.createEntityReference1;
begin
  // the specified name contains an illegal character
  try
    entref := doc.createEntityReference('"');
    check(False, 'no exception raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = INVALID_CHARACTER_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createProcessingInstruction;
begin
  pci := doc.createProcessingInstruction(name,data);
  check(pci <> nil, 'is nil');
  check(pci.target = name, 'wrong target');
  check(pci.data = data, 'wrong data');
  check(pci.nodeName = name, 'wrong nodeName');
  check(pci.nodeValue = data, 'wrong nodeValue');
  check(pci.nodeType = PROCESSING_INSTRUCTION_NODE, 'wrong nodeType');
end;

procedure TSimpleTests.createProcessingInstruction1;
begin
  // the specified name contains an illegal character
  try
    pci := doc.createProcessingInstruction('!@#"',data);
    //don't know, what an illegal character in the target is
    //check(False, 'no exception raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = INVALID_CHARACTER_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.createTextNode;
begin
  text := doc.createTextNode(data);
  check(text <> nil, 'is nil');
  check(text.data = data, 'wrong data');
  check(text.length = Length(data), 'wrong length');
  check(text.nodeName = '#text', 'wrong nodeName');
  check(text.nodeValue = data, 'wrong nodeValue');
  check(text.nodeType = TEXT_NODE, 'wrong nodeType');
  text := text.splitText(4);
  check(text.data = Copy(data,5,Length(data)-1), 'wrong splitText - expected: "'+Copy(data,5,Length(data)-1)+'" found: "'+text.data+'"');
end;

procedure TSimpleTests.docType;
//var i: integer;
begin
  // there's no DTD !
  check(doc.docType = nil, 'not nil');
  // load xml with dtd
  (doc as IDOMPersist).loadxml(xmlstr2);
  check(doc.docType <> nil, 'doc.doctype is nil, but must not');
  check(doc.docType.entities <> nil, 'doc.docType.entities is nil, but must not');
  check(doc.docType.entities.length = 1, 'wrong entities length');
  //ent := doc.docType.entities[0] as IDOMEntity;
  // to be continued ...
  {
  i := doc.docType.notations.length;
  ShowMessage(IntToStr(i));
  }
end;

procedure TSimpleTests.document;
begin
  check(doc <> nil, 'is nil');
  check(doc.nodeName = '#document', 'wrong nodeName');
  check(doc.nodeType = DOCUMENT_NODE, 'wrong nodeType');
  check(doc.ownerDocument = nil, 'ownerDocument not nil');
  check(doc.parentNode = nil, 'parentNode not nil');
end;

procedure TSimpleTests.documentElement;
begin
  elem := doc.documentElement;
  check(elem <> nil, 'is nil');
  check(elem.tagName = 'root', 'wrong tagName');
  check(elem.nodeName = 'root', 'wrong nodeName');
  check(elem.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(elem.parentNode.nodeName = '#document', 'wrong parentNode');
  check(elem.ownerDocument = doc, 'wrong ownerDocument');
end;

procedure TSimpleTests.documentFragment;
const
  n = 10;
var
  i: integer;
begin
  check(doc.documentElement.childNodes.length = 0, 'wrong childNodes.length');
  docfrag := doc.createDocumentFragment;
  for i := 0 to n-1 do begin
    elem := doc.createElement(name);
    elem.setAttribute(name,data+IntToStr(i));
    docfrag.appendChild(elem);
  end;
  check(docfrag.childNodes.length = n, 'wrong childNodes.length');
  doc.documentElement.appendChild(docfrag);
  check(doc.documentElement.childNodes.length <> 0, 'childNodes.length = 0');
  check(doc.documentElement.childNodes[0].nodeName = name, 'wrong nodeName - expected: "'+name+'" found: "'+doc.documentElement.childNodes[0].nodeName+'"');
  check(doc.documentElement.childNodes.length = n, 'wrong childNodes.length');
end;

procedure TSimpleTests.domImplementation;
begin
  check(doc.domImplementation <> nil, 'is nil');
end;

procedure TSimpleTests.firstChild;
const
  n = 10;
var
  i: integer;
begin
  for i := 0 to n-1 do begin
    elem := doc.createElement(name+IntToStr(i));
    doc.documentElement.appendChild(elem);
  end;
  node := doc.documentElement.firstChild;
  elem := doc.documentElement;
  check(elem.hasChildNodes, 'is false');
  check(node <> nil, 'is nil');
  check(node.nodeName = name+'0', 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(myIsSameNode(node.parentNode,elem), 'wrong parentNode');
  check(node.ownerDocument = doc, 'wrong ownerDocument');
end;

procedure TSimpleTests.getAttributeNodeNS_setAttributeNodeNS;
begin
  elem := doc.createElement(name);
  attr := doc.createAttributeNS(nsuri,fqname);
  elem.setAttributeNodeNS(attr);
  attr := elem.getAttributeNodeNS(nsuri,name);
  check(attr <> nil, 'is nil');
end;

procedure TSimpleTests.getAttributeNode_setAttributeNode;
begin
  elem := doc.createElement(name);
  attr := doc.createAttribute('attr1');
  elem.setAttributeNode(attr);
  attr := doc.createAttribute('attr2');
  attr.value := 'hund';
  elem.setAttributeNode(attr);
  attr := elem.getAttributeNode('attr1');
  check(attr <> nil, 'is nil');
  attr := elem.getAttributeNode('attr2');
  check(attr.value = 'hund', 'wrong value1');
  attr := doc.createAttribute('attr2');
  attr.value := 'hase';
  elem.setAttributeNode(attr);
  attr := elem.getAttributeNode('attr2');
  check(attr.value = 'hase', 'wrong value2');
end;

procedure TSimpleTests.getAttributeNS_setAttributeNS;
begin
  elem := doc.createElement(name);
  elem.setAttributeNS(nsuri,fqname,'tiger');
  check(elem.getAttributeNS(nsuri,name) = 'tiger', 'wrong value');
end;

procedure TSimpleTests.getAttribute_setAttribute;
begin
  elem := doc.createElement(name);
  elem.setAttribute(name,'elephant');
  check(elem.getAttribute(name) = 'elephant', 'wrong value');
end;

procedure TSimpleTests.getElementsByTagName;
const
  n = 10;
var
  i: integer;
begin
  for i := 0 to n-1 do begin
    elem := doc.createElement(name);
    doc.documentElement.appendChild(elem);
  end;
  // check document interface
  nodelist := doc.getElementsByTagName(name);
  check(nodelist <> nil, ' is nil');
  check(nodelist.length = n, 'wrong length');
  // check element interface
  nodelist := doc.documentElement.getElementsByTagName(name);
  check(nodelist <> nil, ' is nil');
  check(nodelist.length = n, 'wrong length');
  nodelist := doc.getElementsByTagName('*');
  check(nodelist.length = n+1, 'wrong length');
end;

procedure TSimpleTests.getElementsByTagNameNS;
const
  n = 10;
var
  i: integer;
begin
  for i := 0 to n-1 do begin
    elem := doc.createElementNS(nsuri,fqname);
    doc.documentElement.appendChild(elem);
  end;
  // check document interface
  nodelist := doc.getElementsByTagNameNS(nsuri,name);
  check(nodelist <> nil, ' is nil');
  check(nodelist.length = n, 'wrong length');
  // check element interface
  nodelist := doc.documentElement.getElementsByTagNameNS(nsuri,name);
  check(nodelist <> nil, ' is nil');
  check(nodelist.length = n, 'wrong length');
end;

function TSimpleTests.getFqname: string;
begin
  if prefix = '' then result := name else result := prefix + ':' + name;
end;

procedure TSimpleTests.hasAttribute;
begin
  elem := doc.createElement(name);
  attr := doc.createAttribute(name);
  elem.setAttributeNode(attr);
  check(elem.hasAttribute(name), 'is false');
end;

procedure TSimpleTests.hasAttributeNS;
begin
  elem := doc.createElement(name);
  attr := doc.createAttributeNS(nsuri,fqname);
  elem.setAttributeNodeNS(attr);
  check(elem.hasAttributeNS(nsuri,name), 'is false');
end;

procedure TSimpleTests.hasChildNodes;
begin
  check(not doc.documentElement.hasChildNodes, 'is true');
  elem := doc.createElement(name);
  doc.documentElement.appendChild(elem);
  check(doc.documentElement.hasChildNodes, 'is false');
end;

procedure TSimpleTests.importNode;
var adoc: IDOMDocument;
begin
  // create a second dom
  adoc := impl.createDocument('','',nil);
  (adoc as IDOMPersist).loadxml(xmlstr);
  elem := adoc.createElement(name);
  node := adoc.createElement('second');
  elem.appendChild(node);
  adoc.documentElement.appendChild(elem);
  // import node not deep
  node := doc.importNode(adoc.documentElement.firstChild,False);
  check(node <> nil, 'is nil');
  check(node.ownerDocument = doc, 'wrong ownerDocument');
  check(node.parentNode = nil, 'not nil');
  check(not node.hasChildNodes, 'is true');
  doc.documentElement.appendChild(node);
  // import node deep
  node := doc.importNode(adoc.documentElement.firstChild,True);
  check(node <> nil, 'is nil');
  check(node.ownerDocument = doc, 'wrong ownerDocument');
  check(node.parentNode = nil, 'not nil');
  check(node.hasChildNodes, 'is false');
  doc.documentElement.appendChild(node);
  // check result
  node := doc.documentElement.firstChild;
  check(node <> nil, 'is nil');
  check(node.nodeName = name, 'wrong nodeName');
  node := doc.documentElement.lastChild;
  check(node <> nil, 'is nil');
  check(node.nodeName = name, 'wrong nodeName');
  check(node.firstChild.nodeName = 'second', 'wrong nodeName');
end;

procedure TSimpleTests.insertBefore;
begin
  elem := doc.createElement(name+'0');
  doc.documentElement.appendChild(elem);
  elem := doc.createElement(name+'1');
  doc.documentElement.insertBefore(elem,doc.documentElement.firstChild);
  node := doc.documentElement.firstChild;
  check(node.nodeName = name+'1', 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(myIsSameNode(node.parentNode,doc.documentElement), 'wrong parentNode');
  check(node.ownerDocument = doc, 'wrong ownerDocument');
end;

procedure TSimpleTests.insertBefore1;
begin
  elem := doc.createElement(name);
  node := doc.createElement(name);
  elem.appendChild(node);
  // node is of a type that does not allow children of the type of the newChild node
  try
    elem.insertBefore(doc as IDOMNode,node);
    check(False, 'no exception raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = HIERARCHY_REQUEST_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.insertBefore2;
begin
  elem := doc.createElement(name);
  node := doc.createElement(name);
  elem.appendChild(node);
  doc.documentElement.appendChild(elem);
  // node to insert is one of this node's ancestors
  try
    elem.insertBefore(doc.documentElement,node);
    check(False, 'no exception raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = HIERARCHY_REQUEST_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.insertBefore3;
begin
  elem := doc.createElement(name);
  node := doc.createElement(name);
  elem.appendChild(node);
  // node to insert is this node itself
  try
    elem.insertBefore(elem,node);
    check(False, 'no exception raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = HIERARCHY_REQUEST_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.insertBefore4;
begin
  elem := doc.createElement(name);
  // node if of type Document and the DOM application
  // attempts to insert a second Element node
  try
    doc.insertBefore(elem,doc.documentElement);
    check(False, 'no exception raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = HIERARCHY_REQUEST_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.isSupported;
begin
  check(doc.isSupported('Core','2.0'), 'is false');
  check(doc.isSupported('XML','2.0'), 'is false');
end;

procedure TSimpleTests.lastChild;
const
  n = 10;
var
  i: integer;
begin
  for i := 0 to n-1 do begin
    elem := doc.createElement(name+IntToStr(i));
    doc.documentElement.appendChild(elem);
  end;
  node := doc.documentElement.lastChild;
  elem := doc.documentElement;
  check(elem.hasChildNodes, 'is false');
  check(node <> nil, 'is nil');
  check(node.nodeName = name+'9', 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(myIsSameNode(node.parentNode,elem), 'wrong parentNode');
  check(node.ownerDocument = doc, 'wrong ownerDocument');
end;

function TSimpleTests.myIsSameNode(node1, node2: IDOMNode): boolean;
begin
  try
    result:=(node1 as IDomNodeCompare).IsSameNode(node2);
  except
    if (node1 as IUnKnown) = (node2 as IUnKnown)
      then result:=true
      else result:=false;
  end;
end;


procedure TSimpleTests.namedNodeMap;
begin
  nnmap := doc.documentElement.attributes;
  check(nnmap <> nil, 'is nil');
  check(nnmap.length = 0, 'wrong length');
  // set a namedItem
  attr := doc.createAttribute(name);
  attr.value := data;
  nnmap.setNamedItem(attr);
  check(nnmap.length = 1, 'wrong length');
  check(myIsSameNode(nnmap.getNamedItem(name),attr),'wrong node');
  check(nnmap.getNamedItem(name).nodeValue = data, 'wrong nodeValue');
  // set a namedItem with the same name as before
  attr := doc.createAttribute(name);
  attr.value := data;
  nnmap.setNamedItem(attr);
  check(nnmap.length = 1, 'wrong length');
  // set a namedItem with a different name
  attr := doc.createAttribute('snake');
  attr.value := 'python';
  nnmap.setNamedItem(attr);
  check(nnmap.length = 2, 'wrong length');
  check(myIsSameNode(nnmap.getNamedItem('snake'),attr),'wrong node');
  check(nnmap.getNamedItem('snake').nodeValue = 'python', 'wrong nodeValue');
  nnmap.removeNamedItem(name);
  check(nnmap.length = 1, 'wrong length');
  check(nnmap.item[0].nodeName = 'snake', 'wrong nodeName');
  attr := nil;
  attr := nnmap.namedItem['snake'] as IDOMAttr;
  check(attr.value = 'python', 'wrong value');
end;

procedure TSimpleTests.namedNodeMapNS;
begin
  nnmap := doc.documentElement.attributes;
  check(nnmap <> nil, 'is nil');
  check(nnmap.length = 0, 'wrong length');
  // set a namedItem
  attr := doc.createAttributeNS(nsuri,fqname);
  attr.value := data;
  nnmap.setNamedItemNS(attr);
  check(nnmap.length = 1, 'wrong length');
  check(myIsSameNode(nnmap.getNamedItemNS(nsuri,name),attr),'wrong node');
  check(nnmap.getNamedItemNS(nsuri,name).nodeValue = data, 'wrong nodeValue');
  // set a namedItem with the same name as before
  attr := doc.createAttributeNS(nsuri,fqname);
  attr.value := data;
  nnmap.setNamedItemNS(attr);
  check(nnmap.length = 1, 'wrong length');
  // set a namedItem with a different name
  attr := doc.createAttributeNS(nsuri,prefix+':snake');
  attr.value := 'python';
  nnmap.setNamedItemNS(attr);
  check(nnmap.length = 2, 'wrong length');
  check(myIsSameNode(nnmap.getNamedItemNS(nsuri,'snake'),attr),'wrong node');
  check(nnmap.getNamedItemNS(nsuri,'snake').nodeValue = 'python', 'wrong nodeValue');
  nnmap.removeNamedItemNS(nsuri,name);
  check(nnmap.length = 1, 'wrong length');
  check(nnmap.item[0].localName = 'snake', 'wrong localName');
  attr := nil;
  attr := nnmap.namedItem['snake'] as IDOMAttr;
  check(attr.value = 'python', 'wrong value');
end;

procedure TSimpleTests.nextSibling;
const
  n = 10;
var
  i: integer;
begin
  for i := 0 to n-1 do begin
    elem := doc.createElement(name+IntToStr(i));
    doc.documentElement.appendChild(elem);
  end;
  elem := doc.documentElement;
  node := elem.firstChild;
  for i := 1 to n-1 do begin
    node := node.nextSibling;
    check(node.nodeName = name+IntToStr(i), 'wrong nodeName');
  end;
end;

procedure TSimpleTests.normalize;
const
  n = 10;
var
  i: integer;
  tmp: string;
begin
  // normalize summarizes text-nodes
  for i := 0 to n-1 do begin
    text := doc.createTextNode(data+IntToStr(i));
    doc.documentElement.appendChild(text);
  end;
  //check(doc.documentElement.firstChild.nodeValue = data+'0', 'wrong nodeValue');
  for i := 0 to doc.documentElement.childNodes.length-1 do begin
    node := doc.documentElement.childNodes[i];
    if node.nodeType = TEXT_NODE then tmp := tmp + node.nodeValue;
  end;
  doc.documentElement.normalize;
  for i := 0 to doc.documentElement.childNodes.length-1 do begin
    node := doc.documentElement.childNodes[i];
    if node.nodeType = TEXT_NODE then begin
      check(node.nodeValue = tmp, 'wrong nodeValue');
      break;
    end;
  end;
  {
  // normalize sorts element-nodes before text-nodes ???
  elem := doc.createElement(name);
  doc.documentElement.appendChild(elem);
  check(doc.documentElement.firstChild.nodeType = TEXT_NODE, 'wrong nodeType');
  doc.documentElement.normalize;
  check(doc.documentElement.firstChild.nodeType = ELEMENT_NODE, 'wrong nodeType - element-node should be first');
  }
end;

procedure TSimpleTests.ownerElement;
begin
  attr := doc.createAttribute(name);
  elem := doc.createElement(name);
  elem.setAttributeNode(attr);
  doc.documentElement.appendChild(elem);
  check(myIsSameNode(attr.ownerElement,elem) , 'wrong ownerElement');
end;

procedure TSimpleTests.persist;
var
  sl: TStrings;
  tmp: string;
begin
  // get a textual representation of the dom
  data := (doc as IDOMPersist).xml;
  // save the dom to a file and load it as a textfile
  (doc as IDOMPersist).save('temp.xml');
  sl := TSTringList.create;
  sl.LoadFromFile('temp.xml');
  tmp := sl.Text;
  // adjust contents of the textfile
  if domvendor = 'LIBXML' then begin
    // libxml xml-method adds LF
    tmp := AdjustLineBreaks(tmp,tlbsLF);
  end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
    // ms save-method saves the encoding-attribute
    // but ms xml-method doesn't hides it
    // ms xml-method adds CRLF
    tmp := StringReplace(tmp,' encoding="iso-8859-1"','',[rfReplaceAll]);
  end else begin
    raise EUnknownDomVendor.create('unknown dom vendor '+domvendor);
  end;
  // compare the textual representation of the dom to the contents of the textfile
  check(data = tmp, 'wrong content');
  // load the dom from a textfile
  (doc as IDOMPersist).load('temp.xml');
  // get a textual representation of the dom
  tmp := (doc as IDOMPersist).xml;
  // adjust the textual representation of the dom
  if domvendor = 'LIBXML' then begin
    // libxml xml-method adds LF
    tmp := AdjustLineBreaks(tmp,tlbsLF);
  end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
    // ms save-method saves the encoding-attribute
    // but ms xml-method doesn't hides it
    // ms xml-method adds CRLF
    tmp := StringReplace(tmp,' encoding="iso-8859-1"','',[rfReplaceAll]);
  end else begin
    raise EUnknownDomVendor.create('unknown dom vendor '+domvendor);
  end;
  // compare the old textual representation of the dom with the new loaded
  check(data = tmp, 'wrong content');
end;


procedure TSimpleTests.previousSibling;
const
  n = 10;
var
  i: integer;
begin
  for i := 0 to n-1 do begin
    elem := doc.createElement(name+IntToStr(i));
    doc.documentElement.appendChild(elem);
  end;
  elem := doc.documentElement;
  node := elem.lastChild;
  for i := n-2 downto 0 do begin
    node := node.previousSibling;
    check(node.nodeName = name+IntToStr(i), 'wrong nodeName');
  end;
end;

procedure TSimpleTests.removeAttribute;
begin
  elem := doc.createElement(name);
  attr := doc.createAttribute(name);
  elem.setAttributeNode(attr);
  elem.removeAttribute(name);
  check(not elem.hasAttribute(name), 'is true');
end;

procedure TSimpleTests.removeAttributeNode;
begin
  elem := doc.createElement(name);
  attr := doc.createAttribute(name);
  elem.setAttributeNode(attr);
  elem.removeAttributeNode(attr);
  check(not elem.hasAttribute(name), 'is true');
end;

procedure TSimpleTests.removeAttributeNS;
begin
  elem := doc.createElement(name);
  attr := doc.createAttributeNS(nsuri,fqname);
  elem.setAttributeNodeNS(attr);
  elem.removeAttributeNS(nsuri,name);
  check(not elem.hasAttributeNS(nsuri,name), 'is true');
end;

procedure TSimpleTests.removeChild;
begin
  elem := doc.createElement(name);
  doc.documentElement.appendChild(elem);
  doc.documentElement.removeChild(elem);
  check(not doc.documentElement.hasChildNodes, 'is true');
end;

procedure TSimpleTests.replaceChild;
begin
  elem := doc.createElement(name+'0');
  doc.documentElement.appendChild(elem);
  elem := doc.createElement(name+'1');
  doc.documentElement.replaceChild(elem,doc.documentElement.firstChild);
  check(doc.documentElement.hasChildNodes, 'is false');
  check(doc.documentElement.childNodes.length = 1, 'wrong count of childNodes');
  check(doc.documentElement.firstChild.nodeName = name+'1', 'wrong nodeName');
end;

procedure TSimpleTests.selectNodes;
const
  n = 10;
var
  i: integer;
begin
  select := (doc.documentElement as IDOMNodeSelect);
  for i := 0 to n-1 do begin
    elem := doc.createElement(name);
    doc.documentElement.appendChild(elem);
  end;
  for i := 0 to n-1 do begin
    elem := doc.createElement(name);
    elem.setAttribute(name,'lion');
    doc.documentElement.appendChild(elem);
  end;
  for i := 0 to n-1 do begin
    elem := doc.createElement(name+IntToStr(i));
    node := doc.createElement('child');
    (node as IDOMElement).setAttribute(name,'lion');
    elem.appendChild(node);
    doc.documentElement.appendChild(elem);
  end;
  nodelist := select.selectNodes('.');
  check(nodelist.length = 1, '1 wrong length');
  check(nodelist[0].nodeName = 'root', 'wrong nodeName');
  nodelist := select.selectNodes('*');
  check(nodelist.length = n*3, '2 wrong length');
  nodelist := select.selectNodes('//*');
  check(nodelist.length = n*4+1, '3 wrong length');
  nodelist := select.selectNodes('*/*');
  check(nodelist.length = n, '4 wrong length');
  nodelist := select.selectNodes('*/child');
  check(nodelist.length = n, '5 wrong length');
  nodelist := select.selectNodes(name);
  check(nodelist.length = n*2, '6 wrong length');
  nodelist := select.selectNodes('*[@'+name+' = "lion"]');
  check(nodelist.length = n, '7 wrong length');
  nodelist := select.selectNodes('//*[@'+name+' = "lion"]');
  check(nodelist.length = n*2, '8 wrong length');
end;

procedure TSimpleTests.selectNodes2;
const
  n = 10;
var
  i: integer;
begin
  select := (doc.documentElement as IDOMNodeSelect);
  for i := 0 to n-1 do begin
    elem := doc.createElement(name);
    doc.documentElement.appendChild(elem);
  end;
  for i := 0 to n-1 do begin
    elem := doc.createElement(name);
    elem.setAttribute(name,'lion');
    doc.documentElement.appendChild(elem);
  end;
  for i := 0 to n-1 do begin
    elem := doc.createElement(name+IntToStr(i));
    node := doc.createElement('child');
    (node as IDOMElement).setAttribute(name,'lion');
    elem.appendChild(node);
    doc.documentElement.appendChild(elem);
  end;
  nodelist := select.selectNodes('//@*');
  check(nodelist.length = n*2, '9 wrong length - expected: '+IntToStr(n*2)+' found: '+IntToStr(nodelist.length));
  for i := 0 to nodelist.length-1 do begin
    check(nodelist[i].nodeName = name, 'wrong nodeName - expected: "'+name+'" found: "'+nodelist[i].nodeName+'"');
  end;
end;

procedure TSimpleTests.selectNodes3;
begin
  select := doc.documentElement as IDOMNodeSelect;
  try
    nodelist := select.selectNodes('"');
    check(False, 'exception not raised');
  except
    on E: Exception do begin
      if E is ETestFailure then check(False, 'exception not raised');
      if domvendor = 'LIBXML' then begin
        if E is EDomException then begin
          check((E as EDomException).code = SYNTAX_ERR, 'wrong exception raised');
        end;
      end else if domvendor = 'MSXML2_RENTAL_MODEL' then begin
        check(E is EOleException, 'wrong exception raised');
      end else begin
        raise EUnknownDomVendor.create('unknown domvendor '+domvendor);
      end;
    end;
  end;
end;

procedure TSimpleTests.SetUp;
begin
  inherited;
  impl := GetDom(domvendor);
  doc := impl.createDocument('','',nil);
  (doc as IDOMPersist).loadxml('<?xml version="1.0" encoding="iso-8859-1"?><root />');
  nsuri := 'http://ns.4commerce.de';
  prefix := 'ct';
  name := 'test';
  data := 'Dies ist ein Beispiel-Text.';
end;

procedure TSimpleTests.TearDown;
begin
  node := nil;
  elem := nil;
  attr := nil;
  text := nil;
  nodelist := nil;
  cdata := nil;
  comment := nil;
  pci := nil;
  docfrag := nil;
  entref := nil;
  ent := nil;
  select := nil;
  nnmap := nil;
  doc := nil;
  impl := nil;
  inherited;
end;

procedure TTestDOM2Methods.LoadFiles;
var
	builder: IDomDocumentBuilder;
	mydoc: IDomDocument;
	fd: string; // file directory
	fn: string; // file name
	sr: TSearchRec;
	rv: integer; // returned value
	cnt: integer; // tested file counter
begin
	fd := datapath;
	try
		cnt := 0;
		rv := FindFirst(fd+'/*.xml', faAnyFile, sr);
		while (rv=0) do begin
			Inc(cnt);
			builder := getDocumentBuilderFactory(DomVendor).newDocumentBuilder;
			fn := fd + '/' + sr.Name;
			mydoc := builder.load(fn);
			check(mydoc<>nil, fn+': document not loaded');
			check(mydoc.documentElement<>nil, fn+': documentElement is nil');
			rv := FindNext(sr);
		end;
		if (cnt=0) then begin
			check(false, 'No XML file available for testing in directory '+fd);
		end;
	finally
		FindClose(sr);
	end;
end;

procedure TTestDOM2Methods.LoadFilesII;
var
	mydoc: IDomDocument;
	fd: string; // file directory
	fn: string; // file name
	sr: TSearchRec;
	rv: integer; // returned value
	cnt: integer; // tested file counter
begin
  impl := GetDom(domvendor);
  mydoc := impl.createDocument('','',nil);
	fd := datapath;
	try
		cnt := 0;
		rv := FindFirst(fd+'/*.xml', faAnyFile, sr);
		while (rv=0) do begin
			Inc(cnt);
			fn := fd + '/' + sr.Name;
      (mydoc as IDOMPersist).load(fn);
			check(mydoc<>nil, fn+': document not loaded');
			check(mydoc.documentElement<>nil, fn+': documentElement is nil');
			rv := FindNext(sr);
		end;
		if (cnt=0) then begin
			check(false, 'No XML file available for testing in directory '+fd);
		end;
	finally
		FindClose(sr);
	end;
end;

initialization
  {$ifdef WIN32}
    if DirectoryExists('L:\@Demos\Open_xdom\Data')
      then datapath:='L:\@Demos\Open_xdom\Data'
      else datapath:='../../data';
  {$endif}
  {$ifdef LINUX}
    datapath:='../../data';
  {$endif}
  RegisterTest('', TTestDom2Methods.Suite);
  RegisterTest('', TTestMemoryLeaks.Suite);
  RegisterTest('', TTestDomExceptions.Suite);
  RegisterTest('', TSimpleTests.Suite);
  CoInitialize(nil);
end.



