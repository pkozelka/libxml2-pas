unit XPTest_idom2_TestDOM2Methods;

interface

uses
  TestFrameWork,
  TestExtensions,
  {$ifdef FE}
    libxmldomFE,
  {$else}
    libxmldom,
  {$endif}
  idom2,
  SysUtils,
  XPTest_idom2_Shared,
  StrUtils,
  ActiveX,
  QDialogs;

type 
  TTestDOM2Methods = class(TTestCase)
  private
    impl: IDomImplementation;
    doc0: IDomDocument;
    doc1: IDomDocument;
    doc: IDomDocument;
    node: IDomNode;
    elem: IDomElement;
    attr: IDomAttr;
    Text: IDomText;
    nodelist: IDomNodeList;
    cdata: IDomCDATASection;
    comment: IDomComment;
    pci: IDomProcessingInstruction;
    docfrag: IDomDocumentFragment;
    ent: IDomEntity;
    entref: IDomEntityReference;
    select: IDomNodeSelect;
    nnmap: IDomNamedNodeMap;
    nsuri: string;
    prefix: WideString;
    Name: WideString;
    Data: WideString;
    function getFqname: WideString;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure ShowDom;
    procedure AppendExistingChild;
    procedure TestDocumentElement;
    procedure CreateElementNS0;
    procedure CreateElementNS01;
    procedure CreateAttributeNS0;
    procedure TestDocCount;
    procedure TestElementByID;
    procedure append_100_attributes_with_different_namespaces;
    procedure document;
    procedure document1;
    procedure documentElement;
    procedure domImplementation;
    procedure docType;
    procedure createElement;
    procedure createElementNS;
    procedure createAttribute;
    procedure createAttributeNS;
    procedure createTextNode;
    procedure createCDATASection;
    procedure createComment;
    procedure createDocumentFragment;
    procedure createProcessingInstruction;
    procedure createEntityReference;
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
    procedure removeChild;
    procedure appendChild;
    procedure replaceChild;
    procedure isSupported;
    procedure normalize;
    procedure importNode;
    procedure hasChildNodes;
    procedure childNodes;
    procedure attributes;
    procedure ownerElement;
    procedure namedNodeMap;
    procedure namedNodeMapNS;
    procedure documentFragment;
    procedure element;
    procedure nsdecl;
    procedure unicode_TextNodeValue;
    procedure unicode_NodeName;
    property fqname: WideString read getFqname;

  end;

implementation

uses domSetup;

{ TTestDom2Methods }

procedure TTestDom2Methods.SetUp;
begin
  inherited;
  impl := DomSetup.getCurrentDomSetup.getDocumentBuilder.domImplementation;
  doc0 := impl.createDocument('', '', nil);
  (doc0 as IDomPersist).loadxml(xmlstr);
  doc1 := impl.createDocument('', '', nil);
  (doc1 as IDomPersist).loadxml(xmlstr1);
  doc := impl.createDocument('', '', nil);
  (doc as IDomPersist).loadxml('<?xml version="1.0" encoding="iso-8859-1"?><root />');
  nsuri := 'http://ns.4commerce.de';
  prefix := 'ct'+getUnicodeStr(1);
  Name := 'test'+getUnicodeStr(1);
  Data := 'Dies ist ein Beispiel-Text.'+getUnicodeStr(1);
end;

procedure TTestDom2Methods.TearDown;
begin
  node := nil;
  elem := nil;
  attr := nil;
  Text := nil;
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
  doc0 := nil;
  doc1 := nil;
  impl := nil;
  inherited;
end;

procedure TTestDom2Methods.TestDocCount;
begin
  doc0 := nil;
  doc1 := nil;
  doc := nil;
  Check(doccount = 0,'documents not released');
end;

procedure TTestDom2Methods.TestDocumentElement;
begin
  Check(doc0.documentElement <> nil, 'documentElement is nil');
end;

procedure TTestDom2Methods.AppendExistingChild;
var
  node: IDomNode;
  temp: string;
begin
  {
    DOM2: If the child is already in the tree, it
    is first removed.
    So there must be only one child sub1 after the
    two calls of appendChild
  }
  node := doc0.createElement('sub1');
  doc0.documentElement.appendChild(node);
  doc0.documentElement.appendChild(node);
  temp := ((doc0 as IDomPersist).xml);
  temp := unify(temp);
  check(temp = '<test><sub1/></test>', 'appendChild Error');
end;

procedure TTestDom2Methods.TestElementByID;
var
  elem: IDomElement;
begin
  elem := doc0.getElementById('110');
end;

procedure TTestDom2Methods.createElementNS0;
const
  CRLF = #13#10;
var
  node: IDomNode;
  temp: string;
begin
  node := doc0.createElementNS('http://ns.4ct.de', 'ct:test');
  doc0.documentElement.appendChild(node);
  temp := (doc0 as IDomPersist).xml;
  temp := unify(temp);
  check(temp = '<test><ct:test xmlns:ct="http://ns.4ct.de"/></test>',
    'createElementNS failed');
end;

procedure TTestDom2Methods.createElementNS01;
const
  CRLF = #13#10;
var
  node: IDomNode;
  temp: string;
begin
  node := doc1.createElementNS('http://ns.4ct.de', 'ct:test');
  doc1.documentElement.appendChild(node);
  temp := (doc1 as IDomPersist).xml;
  temp := unify(temp);
  check(temp =
    '<test xmlns="http://ns.4ct.de"><ct:test xmlns:ct="http://ns.4ct.de"/></test>',
    'createElementNS failed');
end;

procedure TTestDom2Methods.createAttributeNS0;
var
  attr: IDomAttr;
  temp: string;
begin
  attr := doc0.createAttributeNS('http://ns.4ct.de', 'ct:name1');
  attr.Value := 'hund';
  doc0.documentElement.setAttributeNodeNS(attr);
  temp := (doc0 as IDomPersist).xml;
  temp := unify(temp);
  check(temp = '<test xmlns:ct="http://ns.4ct.de" ct:name1="hund"/>',
    'failed')
end;

procedure TTestDOM2Methods.append_100_attributes_with_different_namespaces;
var
  attr: IDomAttr;
  i:    integer;
  attrval, temp: string;
  ok:   boolean;
begin
  // create attributes
  for i := 0 to 2 do begin
    attr := doc0.createAttributeNS('http://test' + IntToStr(i) + '.invalid',
      'test' + IntToStr(i) + ':attr');
    attr.Value := IntToStr(i);
    doc0.documentElement.setAttributeNodeNS(attr);
    attr := nil;
  end;
  temp := (doc0 as IDomPersist).xml;
  temp := Unify(temp);
  //jk: OutLog(temp);
  ok := False;
  if temp =
    '<test xmlns:test0="http://test0.invalid" test0:attr="0" xmlns:test1="http://test1.invalid" test1:attr="1" xmlns:test2="http://test2.invalid" test2:attr="2"/>'
    then ok := True;
  if temp =
    '<test xmlns:test0="http://test0.invalid" xmlns:test1="http://test1.invalid" xmlns:test2="http://test2.invalid" test0:attr="0" test1:attr="1" test2:attr="2"/>'
    then ok := True;
  Check(ok, 'Test failed!');
  // check attributes
  for i := 0 to 2 do begin
    attrval := doc0.documentElement.getAttributeNS('http://test' + IntToStr(i) + '.invalid',
      'attr');
    check(attrval = IntToStr(i), 'expected ' + IntToStr(i) + ' but found ' + attrval);
  end;
end;

procedure TTestDOM2Methods.ShowDom;
var
  el:   IDomElement;
  temp: string;
begin
  el := doc0.createElement('books');
  doc0.documentElement.appendChild(el);
  temp := ((doc0 as IDomPersist).xml);
end;

procedure TTestDom2Methods.appendChild;
begin
  elem := doc.createElement(Name);
  doc.documentElement.appendChild(elem);
  check(doc.documentElement.hasChildNodes, 'is false');
  check(myIsSameNode(elem, doc.documentElement.firstChild), 'wrong node');
end;

procedure TTestDom2Methods.attributes;
const
  n = 10;
var
  i: integer;
begin
  elem := doc.createElement(Name);
  for i := 0 to n - 1 do begin
    elem.setAttribute(Name +IntToStr(i), IntToStr(i));
  end;
  check(elem.attributes.length = n, 'wrong length');
  for i := 0 to elem.attributes.length - 1 do begin
    check(elem.attributes.item[i].nodeName = Name +IntToStr(i), 'wrong nodeName');
    check(elem.attributes.item[i].nodeValue = IntToStr(i), 'wrong nodeValue');
    check(elem.attributes.item[i].nodeType = ATTRIBUTE_NODE, 'wrong nodeType');
  end;
end;

procedure TTestDom2Methods.childNodes;
const
  n = 10;
var
  i: integer;
begin
  check(doc.documentElement.childNodes.length = 0, 'wrong length');
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name +IntToStr(i));
    doc.documentElement.appendChild(elem);
  end;
  check(doc.documentElement.childNodes.length = n, 'wrong length');
  for i := 0 to doc.documentElement.childNodes.length - 1 do begin
    node := doc.documentElement.childNodes.item[i];
    check(node <> nil, 'is nil');
    check(node.nodeName = Name +IntToStr(i), 'wrong nodeName');
    check(node.nodeType = ELEMENT_NODE, 'wrong noodeType');
    check(myIsSameNode(node.parentNode, doc.documentElement), 'wrong parentNode');
    node := doc.documentElement.childNodes[i];
    check(node <> nil, 'is nil');
    check(node.nodeName = Name +IntToStr(i), 'wrong nodeName');
    check(node.nodeType = ELEMENT_NODE, 'wrong noodeType');
    check(myIsSameNode(node.parentNode, doc.documentElement), 'wrong parentNode');
  end;
end;

procedure TTestDom2Methods.cloneNode;
begin
  elem := doc.createElement(Name);
  node := doc.createElement('child');
  elem.appendChild(node);
  doc.documentElement.appendChild(elem);
  node := elem.cloneNode(False);
  check(node <> nil, 'is nil');
  check(node.nodeName = Name, 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(not node.hasChildNodes, 'is true');
  node := elem.cloneNode(True);
  check(node <> nil, 'is nil');
  check(node.nodeName = Name, 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(node.hasChildNodes, 'is false');
end;

procedure TTestDom2Methods.createAttribute;
begin
  attr := doc.createAttribute(Name);
  check(attr <> nil, 'is nil');
  check(attr.Name = Name, 'wrong name');
  check(attr.nodeName = Name, 'wrong nodeName');
  check(attr.namespaceURI = '', 'wrong namespaceURI');
  check(attr.localName = '', 'wrong localName');
  check(attr.prefix = '', 'wrong prefix');
  check(attr.Value = '', 'wrong value');
  check(attr.ownerDocument = doc, 'wrong ownerDocument');
end;

procedure TTestDom2Methods.createAttributeNS;
begin
  attr := doc.createAttributeNS(nsuri, fqname);
  check(attr <> nil, 'is nil');
  attr.Value := 'kamel';
  check(attr.Name = fqname, 'wrong name');
  check(attr.nodeName = fqname, 'wrong nodeName');
  check(attr.nodeType = ATTRIBUTE_NODE, 'wrong nodeType');
  check(attr.namespaceURI = nsuri, 'wrong namespaceURI');
  check(attr.prefix = prefix, 'wrong prefix');
  check(attr.localName = Name, 'wrong localName - expected: "'+Name+'" found: "'+attr.localName+'"');
  check(attr.specified, 'is false');
  check(attr.Value = 'kamel', 'wrong value');
end;

procedure TTestDom2Methods.createCDATASection;
begin
  cdata := doc.createCDataSection(Data);
  check(cdata <> nil, 'is nil');
  check(cdata.Data = Data, 'wrong data');
  check(cdata.length = Length(Data), 'wrong length');
  check(cdata.nodeName = '#cdata-section', 'wrong nodeName');
  check(cdata.nodeValue = Data, 'wrong nodeValue');
  check(cdata.nodeType = CDATA_SECTION_NODE, 'wrong nodeType');
  cdata.appendData(Data);
  check(cdata.nodeValue = Data + Data, 'wrong nodeValue');
  check(cdata.subStringData(0,Length(Data)) = Data,
    'wrong subStringData - expected: "' + Data + '" found: "' +
    cdata.subStringData(0,Length(Data)) + '"');
  cdata.insertData(0,'0');
  check(cdata.nodeValue = '0' + Data + Data, 'wrong nodeValue');
  cdata.deleteData(0,1);
  check(cdata.nodeValue = Data + Data, 'wrong nodeValue');
  cdata.replaceData(Length(Data), Length(Data), '');
  check(cdata.nodeValue = Data, 'wrong nodeValue');
end;

procedure TTestDom2Methods.createComment;
begin
  comment := doc.createComment(Data);
  check(comment <> nil, 'is nil');
  check(comment.Data = Data, 'wrong data');
  check(comment.length = Length(Data), 'wrong length');
  check(comment.nodeName = '#comment', 'wrong nodeName');
  check(comment.nodeValue = Data, 'wrong nodeValue');
  check(comment.nodeType = COMMENT_NODE, 'wrong nodeType');
end;

procedure TTestDom2Methods.createDocumentFragment;
begin
  docfrag := doc.createDocumentFragment;
  check(docfrag <> nil, 'is nil');
  check(docfrag.nodeName = '#document-fragment', 'wrong nodeName');
  check(docfrag.nodeType = DOCUMENT_FRAGMENT_NODE, 'wrong nodeType');
end;

procedure TTestDom2Methods.createElement;
begin
  elem := doc.createElement(Name);
  check(elem <> nil, 'is nil');
  check(elem.nodeName = Name, 'wrong nodeName');
  check(elem.tagName = Name, 'wrong tagName');
  check(elem.ownerDocument = doc, 'wrong ownerDocument');
  check(elem.namespaceURI = '', 'wrong namespaceURI');
  check(elem.prefix = '', 'wrong prefix');
  check(elem.localName = '', 'wrong localName');
end;

procedure TTestDom2Methods.createElementNS;
begin
  elem := doc.createElementNS(nsuri, fqname);
  check(elem <> nil, 'is nil');
  check(elem.nodeName = fqname, 'wrong nodeName');
  check(elem.tagName = fqname, 'wrong tagName');
  check(elem.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(elem.namespaceURI = nsuri, 'wrong namespaceURI');
  check(elem.prefix = prefix, 'wrong prefix');
  check(elem.localName = Name, 'wrong name');
end;

procedure TTestDom2Methods.createEntityReference;
begin
  entref := doc.createEntityReference(Name);
  check(entref <> nil, 'is nil');
  check(entref.nodeName = Name, 'wrong nodeName');
  check(entref.nodeType = ENTITY_REFERENCE_NODE, 'wrong nodeType');
end;

procedure TTestDom2Methods.createProcessingInstruction;
begin
  pci := doc.createProcessingInstruction(Name, Data);
  check(pci <> nil, 'is nil');
  check(pci.target = Name, 'wrong target');
  check(pci.Data = Data, 'wrong data');
  check(pci.nodeName = Name, 'wrong nodeName');
  check(pci.nodeValue = Data, 'wrong nodeValue');
  check(pci.nodeType = PROCESSING_INSTRUCTION_NODE, 'wrong nodeType');
end;

procedure TTestDom2Methods.createTextNode;
begin
  Text := doc.createTextNode(Data);
  check(Text <> nil, 'is nil');
  check(Text.Data = Data, 'wrong data');
  check(Text.length = Length(Data), 'wrong length');
  check(Text.nodeName = '#text', 'wrong nodeName');
  check(Text.nodeValue = Data, 'wrong nodeValue');
  check(Text.nodeType = TEXT_NODE, 'wrong nodeType');
  Text := Text.splitText(4);
  check(Text.Data = Copy(Data, 5,Length(Data) - 1),
    'wrong splitText - expected: "' + Copy(Data, 5,Length(Data) - 1) +
    '" found: "' + Text.Data + '"');
end;

procedure TTestDom2Methods.docType;
  //var i: integer;
begin
  // there's no DTD !
  check(doc.docType = nil, 'not nil');
  // load xml with dtd
  (doc as IDomPersist).loadxml(xmlstr2);
  check(doc.docType <> nil, 'doc.doctype is nil, but must not');
  check(doc.docType.entities <> nil, 'doc.docType.entities is nil, but must not');
  check(doc.docType.entities.length = 2, 'wrong entities length');
  //ent := doc.docType.entities[0] as IDomEntity;
  // to be continued ...
  {
  i := doc.docType.notations.length;
  ShowMessage(IntToStr(i));
  }
end;

procedure TTestDom2Methods.document;
begin
  check(doc <> nil, 'is nil');
  check(doc.nodeName = '#document', 'wrong nodeName');
  check(doc.nodeType = DOCUMENT_NODE, 'wrong nodeType');
  check(doc.ownerDocument = nil, 'ownerDocument not nil');
  check(doc.parentNode = nil, 'parentNode not nil');
end;

procedure TTestDom2Methods.documentElement;
begin
  elem := doc.documentElement;
  check(elem <> nil, 'is nil');
  check(elem.tagName = 'root', 'wrong tagName');
  check(elem.nodeName = 'root', 'wrong nodeName');
  check(elem.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(elem.parentNode.nodeName = '#document', 'wrong parentNode');
  check(elem.ownerDocument = doc, 'wrong ownerDocument');
end;

procedure TTestDom2Methods.documentFragment;
const
  n = 10;
var
  i: integer;
begin
  check(doc.documentElement.childNodes.length = 0, 'wrong childNodes.length');
  docfrag := doc.createDocumentFragment;
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name);
    elem.setAttribute(Name, Data + IntToStr(i));
    docfrag.appendChild(elem);
  end;
  check(docfrag.childNodes.length = n, 'wrong childNodes.length');
  doc.documentElement.appendChild(docfrag);
  check(doc.documentElement.childNodes.length <> 0, 'childNodes.length = 0');
  check(doc.documentElement.childNodes[0].nodeName = Name,
    'wrong nodeName - expected: "' + Name +'" found: "' +
    doc.documentElement.childNodes[0].nodeName + '"');
  check(doc.documentElement.childNodes.length = n, 'wrong childNodes.length');
end;

procedure TTestDom2Methods.domImplementation;
begin
  check(doc.domImplementation <> nil, 'is nil');
end;

procedure TTestDom2Methods.firstChild;
const
  n = 10;
var
  i: integer;
begin
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name +IntToStr(i));
    doc.documentElement.appendChild(elem);
  end;
  node := doc.documentElement.firstChild;
  elem := doc.documentElement;
  check(elem.hasChildNodes, 'is false');
  check(node <> nil, 'is nil');
  check(node.nodeName = Name +'0', 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(myIsSameNode(node.parentNode, elem), 'wrong parentNode');
  check(node.ownerDocument = doc, 'wrong ownerDocument');
end;

procedure TTestDom2Methods.getAttributeNodeNS_setAttributeNodeNS;
begin
  elem := doc.createElement(Name);
  attr := doc.createAttributeNS(nsuri, fqname);
  elem.setAttributeNodeNS(attr);
  attr := elem.getAttributeNodeNS(nsuri, Name);
  check(attr <> nil, 'is nil');
end;

procedure TTestDom2Methods.getAttributeNode_setAttributeNode;
begin
  elem := doc.createElement(Name);
  attr := doc.createAttribute('attr1');
  elem.setAttributeNode(attr);
  attr := doc.createAttribute('attr2');
  attr.Value := 'hund';
  elem.setAttributeNode(attr);
  attr := elem.getAttributeNode('attr1');
  check(attr <> nil, 'is nil');
  attr := elem.getAttributeNode('attr2');
  check(attr.Value = 'hund', 'wrong value1');
  attr := doc.createAttribute('attr2');
  attr.Value := 'hase';
  elem.setAttributeNode(attr);
  attr := elem.getAttributeNode('attr2');
  check(attr.Value = 'hase', 'wrong value2');
end;

procedure TTestDom2Methods.getAttributeNS_setAttributeNS;
begin
  elem := doc.createElement(Name);
  elem.setAttributeNS(nsuri, fqname, 'tiger');
  check(elem.getAttributeNS(nsuri, Name) = 'tiger', 'wrong value');
end;

procedure TTestDom2Methods.getAttribute_setAttribute;
begin
  elem := doc.createElement(Name);
  elem.setAttribute(Name, 'elephant');
  check(elem.getAttribute(Name) = 'elephant', 'wrong value');
end;

procedure TTestDom2Methods.getElementsByTagName;
const
  n = 10;
var
  i: integer;
begin
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name);
    doc.documentElement.appendChild(elem);
  end;
  // check document interface
  nodelist := doc.getElementsByTagName(Name);
  check(nodelist <> nil, ' is nil');
  check(nodelist.length = n, 'wrong length');
  // check element interface
  nodelist := doc.documentElement.getElementsByTagName(Name);
  check(nodelist <> nil, ' is nil');
  check(nodelist.length = n, 'wrong length');
  nodelist := doc.getElementsByTagName('*');
  check(nodelist.length = n + 1, 'wrong length');
end;

procedure TTestDom2Methods.getElementsByTagNameNS;
const
  n = 10;
var
  i: integer;
begin
  for i := 0 to n - 1 do begin
    elem := doc.createElementNS(nsuri, fqname);
    doc.documentElement.appendChild(elem);
  end;
  // check document interface
  nodelist := doc.getElementsByTagNameNS(nsuri, Name);
  check(nodelist <> nil, ' is nil');
  check(nodelist.length = n, 'wrong length');
  // check element interface
  nodelist := doc.documentElement.getElementsByTagNameNS(nsuri, Name);
  check(nodelist <> nil, ' is nil');
  check(nodelist.length = n, 'wrong length');
end;

function TTestDom2Methods.getFqname: WideString;
begin
  if prefix = '' then result := Name
  else result := prefix + ':' + Name;
end;

procedure TTestDom2Methods.hasAttribute;
begin
  elem := doc.createElement(Name);
  attr := doc.createAttribute(Name);
  elem.setAttributeNode(attr);
  check(elem.hasAttribute(Name), 'is false');
end;

procedure TTestDom2Methods.hasAttributeNS;
begin
  elem := doc.createElement(Name);
  attr := doc.createAttributeNS(nsuri, fqname);
  elem.setAttributeNodeNS(attr);
  check(elem.hasAttributeNS(nsuri, Name), 'is false');
end;

procedure TTestDom2Methods.hasChildNodes;
begin
  check(not doc.documentElement.hasChildNodes, 'is true');
  elem := doc.createElement(Name);
  doc.documentElement.appendChild(elem);
  check(doc.documentElement.hasChildNodes, 'is false');
end;

procedure TTestDom2Methods.importNode;
var 
  adoc: IDomDocument;
begin
  // create a second dom
  adoc := impl.createDocument('', '', nil);
  (adoc as IDomPersist).loadxml(xmlstr);
  elem := adoc.createElement(Name);
  node := adoc.createElement('second');
  elem.appendChild(node);
  adoc.documentElement.appendChild(elem);
  // import node not deep
  node := doc.importNode(adoc.documentElement.firstChild, False);
  check(node <> nil, 'is nil');
  check(node.ownerDocument = doc, 'wrong ownerDocument');
  check(node.parentNode = nil, 'not nil');
  check(not node.hasChildNodes, 'is true');
  doc.documentElement.appendChild(node);
  // import node deep
  node := doc.importNode(adoc.documentElement.firstChild, True);
  check(node <> nil, 'is nil');
  check(node.ownerDocument = doc, 'wrong ownerDocument');
  check(node.parentNode = nil, 'not nil');
  check(node.hasChildNodes, 'is false');
  doc.documentElement.appendChild(node);
  // check result
  node := doc.documentElement.firstChild;
  check(node <> nil, 'is nil');
  check(node.nodeName = Name, 'wrong nodeName');
  node := doc.documentElement.lastChild;
  check(node <> nil, 'is nil');
  check(node.nodeName = Name, 'wrong nodeName');
  check(node.firstChild.nodeName = 'second', 'wrong nodeName');
end;

procedure TTestDom2Methods.insertBefore;
begin
  elem := doc.createElement(Name +'0');
  doc.documentElement.appendChild(elem);
  elem := doc.createElement(Name +'1');
  doc.documentElement.insertBefore(elem, doc.documentElement.firstChild);
  node := doc.documentElement.firstChild;
  check(node.nodeName = Name +'1', 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(myIsSameNode(node.parentNode, doc.documentElement), 'wrong parentNode');
  check(node.ownerDocument = doc, 'wrong ownerDocument');
end;

procedure TTestDom2Methods.isSupported;
begin
  check(doc.isSupported('Core', '2.0'), 'is false');
  check(doc.isSupported('XML', '2.0'), 'is false');
end;

procedure TTestDom2Methods.lastChild;
const
  n = 10;
var
  i: integer;
begin
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name +IntToStr(i));
    doc.documentElement.appendChild(elem);
  end;
  node := doc.documentElement.lastChild;
  elem := doc.documentElement;
  check(elem.hasChildNodes, 'is false');
  check(node <> nil, 'is nil');
  check(node.nodeName = Name +'9', 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(myIsSameNode(node.parentNode, elem), 'wrong parentNode');
  check(node.ownerDocument = doc, 'wrong ownerDocument');
end;

procedure TTestDom2Methods.namedNodeMap;
begin
  nnmap := doc.documentElement.attributes;
  check(nnmap <> nil, 'is nil');
  check(nnmap.length = 0, 'wrong length');
  // set a namedItem
  attr := doc.createAttribute(Name);
  attr.Value := Data;
  nnmap.setNamedItem(attr);
  check(nnmap.length = 1, 'wrong length');
  check(myIsSameNode(nnmap.getNamedItem(Name), attr), 'wrong node');
  check(nnmap.getNamedItem(Name).nodeValue = Data, 'wrong nodeValue');
  // set a namedItem with the same name as before
  attr := doc.createAttribute(Name);
  attr.Value := Data;
  nnmap.setNamedItem(attr);
  check(nnmap.length = 1, 'wrong length');
  // set a namedItem with a different name
  attr := doc.createAttribute('snake');
  attr.Value := 'python';
  nnmap.setNamedItem(attr);
  check(nnmap.length = 2, 'wrong length');
  check(myIsSameNode(nnmap.getNamedItem('snake'), attr), 'wrong node');
  check(nnmap.getNamedItem('snake').nodeValue = 'python', 'wrong nodeValue');
  nnmap.removeNamedItem(Name);
  check(nnmap.length = 1, 'wrong length');
  check(nnmap.item[0].nodeName = 'snake', 'wrong nodeName');
  attr := nil;
  attr := nnmap.namedItem['snake'] as IDomAttr;
  check(attr.Value = 'python', 'wrong value');
end;

procedure TTestDom2Methods.namedNodeMapNS;
begin
  nnmap := doc.documentElement.attributes;
  check(nnmap <> nil, 'is nil');
  check(nnmap.length = 0, 'wrong length');
  // set a namedItem
  attr := doc.createAttributeNS(nsuri, fqname);
  attr.Value := Data;
  nnmap.setNamedItemNS(attr);
  check(nnmap.length = 1, 'wrong length');
  node := nnmap.getNamedItemNS(nsuri, Name);
  check(myIsSameNode(node,attr), 'wrong node');
  check(nnmap.getNamedItemNS(nsuri, Name).nodeValue = Data, 'wrong nodeValue');
  // set a namedItem with the same name as before
  attr := doc.createAttributeNS(nsuri, fqname);
  attr.Value := Data;
  nnmap.setNamedItemNS(attr);
  check(nnmap.length = 1, 'wrong length');
  // set a namedItem with a different name
  attr := doc.createAttributeNS(nsuri, prefix + ':snake');
  attr.Value := 'python';
  nnmap.setNamedItemNS(attr);
  check(nnmap.length = 2, 'wrong length');
  check(myIsSameNode(nnmap.getNamedItemNS(nsuri, 'snake'), attr), 'wrong node');
  check(nnmap.getNamedItemNS(nsuri, 'snake').nodeValue = 'python', 'wrong nodeValue');
  nnmap.removeNamedItemNS(nsuri, Name);
  check(nnmap.length = 1, 'wrong length');
  check(nnmap.item[0].localName = 'snake', 'wrong localName');
  attr := nil;
  attr := nnmap.namedItem['snake'] as IDomAttr;
  check(attr.Value = 'python', 'wrong value');
end;

procedure TTestDom2Methods.nextSibling;
const
  n = 10;
var
  i: integer;
begin
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name +IntToStr(i));
    doc.documentElement.appendChild(elem);
  end;
  elem := doc.documentElement;
  node := elem.firstChild;
  for i := 1 to n - 1 do begin
    node := node.nextSibling;
    check(node.nodeName = Name +IntToStr(i), 'wrong nodeName');
  end;
end;

procedure TTestDom2Methods.normalize;
const
  n = 10;
var
  i:   integer;
  tmp: WideString;
begin
  // normalize summarizes text-nodes
  for i := 0 to n - 1 do begin
    Text := doc.createTextNode(Data + IntToStr(i));
    doc.documentElement.appendChild(Text);
  end;
  //check(doc.documentElement.firstChild.nodeValue = data+'0', 'wrong nodeValue');
  for i := 0 to doc.documentElement.childNodes.length - 1 do begin
    node := doc.documentElement.childNodes[i];
    if node.nodeType = TEXT_NODE then tmp := tmp + node.nodeValue;
  end;
  doc.documentElement.normalize;
  for i := 0 to doc.documentElement.childNodes.length - 1 do begin
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

procedure TTestDom2Methods.ownerElement;
begin
  attr := doc.createAttribute(Name);
  elem := doc.createElement(Name);
  elem.setAttributeNode(attr);
  doc.documentElement.appendChild(elem);
  check(myIsSameNode(attr.ownerElement, elem), 'wrong ownerElement');
end;

procedure TTestDom2Methods.previousSibling;
const
  n = 10;
var
  i: integer;
begin
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name +IntToStr(i));
    doc.documentElement.appendChild(elem);
  end;
  elem := doc.documentElement;
  node := elem.lastChild;
  for i := n - 2 downto 0 do begin
    node := node.previousSibling;
    check(node.nodeName = Name +IntToStr(i), 'wrong nodeName');
  end;
end;

procedure TTestDom2Methods.removeAttribute;
begin
  elem := doc.createElement(Name);
  attr := doc.createAttribute(Name);
  elem.setAttributeNode(attr);
  elem.removeAttribute(Name);
  check(not elem.hasAttribute(Name), 'is true');
end;

procedure TTestDom2Methods.removeAttributeNode;
begin
  elem := doc.createElement(Name);
  attr := doc.createAttribute(Name);
  elem.setAttributeNode(attr);
  elem.removeAttributeNode(attr);
  check(not elem.hasAttribute(Name), 'is true');
end;

procedure TTestDom2Methods.removeAttributeNS;
begin
  elem := doc.createElement(Name);
  attr := doc.createAttributeNS(nsuri, fqname);
  elem.setAttributeNodeNS(attr);
  elem.removeAttributeNS(nsuri, Name);
  check(not elem.hasAttributeNS(nsuri, Name), 'is true');
end;

procedure TTestDom2Methods.removeChild;
begin
  elem := doc.createElement(Name);
  doc.documentElement.appendChild(elem);
  doc.documentElement.removeChild(elem);
  check(not doc.documentElement.hasChildNodes, 'is true');
end;

procedure TTestDom2Methods.replaceChild;
begin
  elem := doc.createElement(Name +'0');
  doc.documentElement.appendChild(elem);
  elem := doc.createElement(Name +'1');
  doc.documentElement.replaceChild(elem, doc.documentElement.firstChild);
  check(doc.documentElement.hasChildNodes, 'is false');
  check(doc.documentElement.childNodes.length = 1, 'wrong count of childNodes');
  check(doc.documentElement.firstChild.nodeName = Name +'1', 'wrong nodeName');
end;

procedure TTestDom2Methods.element;
var 
  tmp: string;
begin
  // setting the nodeValue of an element node should have no effect (w3c.org)
  elem := doc.createElement(Name);
  doc.documentElement.appendChild(elem);
  tmp := (doc as IDomPersist).xml;
  elem.nodeValue := Data;
  check((doc as IDomPersist).xml = tmp,
    'Setting the nodeValue of an element node has an effect.');
end;

procedure TTestDom2Methods.document1;
var 
  tmp: string;
begin
  // setting the nodeValue of an document node should have no effect (w3c.org)
  tmp := (doc as IDomPersist).xml;
  doc.nodeValue := Data;
  check((doc as IDomPersist).xml = tmp,
    'Setting the nodeValue of an document node has an effect.');
end;

procedure TTestDom2Methods.nsdecl;
begin
  // test if the namespace declaration is an attribute of the element
  // load a simple xml structure with a namespace declaration at the documentElement
  (doc as IDomPersist).loadxml(xmlstr3);
  nnmap := doc.documentElement.attributes;
  // if the namespace declaration is an attribute there must be one
  check(nnmap.length = 1, 'if the namespace declaration is an attribute there must be one but there''s none');
  attr := nnmap.item[0] as IDomAttr;
  // test standard properties of the attribute
  check(attr.Name = 'xmlns:ct', 'wrong name');
  check(attr.Value = 'http://ns.4ct.de', 'wrong value');
  check(attr.prefix = 'xmlns', 'wrong prefix');
  check(attr.localName = 'ct', 'wrong localName');
  {
  Note: In the DOM, all namespace declaration attributes are BY DEFINITION bound
  to the namespace URI: "http://www.w3.org/2000/xmlns/". These are the attributes
  whose namespace prefix or qualified name is "xmlns". Although, at the time of
  writing, this is not part of the XML Namespaces specification [XML Namespaces],
  it is planned to be incorporated in a future revision. (w3c.org)
  }
  check(attr.namespaceURI = 'http://www.w3.org/2000/xmlns/',
    'wrong namespaceURI - expected: "http://www.w3.org/2000/xmlns/" found: "' +
    attr.namespaceURI + '"');
end;

procedure TTestDOM2Methods.unicode_TextNodeValue;
  // this test appends a text node with greek and coptic unicode characters
var
  ws: widestring;
  ok: boolean;
begin
  ws := getUnicodeStr;
  text := doc.createTextNode(ws);
  ws := '';
  doc.documentElement.appendChild(text);
  ws := doc.documentElement.firstChild.nodeValue;
  ok := WideSameStr(ws,getUnicodeStr);
  check(ok, 'incorrect unicode handling');
end;

procedure TTestDOM2Methods.unicode_NodeName;
  // this test appends a node with a name containing unicode characters
var
  ws: WideString;
  ok: boolean;
begin
  ws := getUnicodeStr(1);
  node := doc.createElement(ws);
  doc.documentElement.appendChild(node);
  ws := '';
  ws := doc.documentElement.firstChild.nodeName;
  ok := WideSameStr(ws,getUnicodeStr(1));
  check(ok, 'incorrect unicode handling');
end;

initialization
  datapath := getDataPath;
  CoInitialize(nil);

end.
