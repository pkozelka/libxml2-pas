unit XPTest_idom2_TestDOM2Methods;

interface

uses
  TestFrameWork,
  TestExtensions,
  idom2,
  idom2_ext,
  SysUtils,
  XPTest_idom2_Shared,
  StrUtils,
  ActiveX,
  Dialogs;

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
    nota: IDOMNotation;
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
    // a leading "basic" indicates that only properties are tested
    // a trailing "10times" indicates that the basic tests are done for 10 diffenent property values
    // a leading "unknown" indicates that we have to discuss this test
    // a trailing "setNodeValue" indicates that a nodeValue is set where it schould have no effect
    // a leading "ext" indicates that the basic test was extended
    procedure basic_appendChild;
    procedure basic_cloneNode;
    procedure basic_createAttribute;
    procedure basic_createAttributeNS;
    procedure basic_createAttributeNS_createNsDecl;
    procedure basic_createCDATASection;
    procedure basic_createComment;
    procedure basic_createDocumentFragment;
    procedure basic_createElement;
    procedure basic_createElementNS;
    procedure basic_createEntityReference;
    procedure basic_createProcessingInstruction;
    procedure basic_createTextNode;
    procedure basic_docType;
    procedure basic_document;
    procedure basic_documentElement;
    procedure basic_documentFragment;
    procedure basic_domImplementation;
    procedure basic_firstChild;
    procedure basic_getAttributeNodeNS_setAttributeNodeNS;
    procedure basic_getAttributeNS_setAttributeNS;
    procedure basic_getAttribute_setAttribute;
    procedure basic_getElementByID;
    procedure basic_getElementsByTagName;
    procedure basic_getElementsByTagNameNS;
    procedure basic_hasAttributeNS_setAttributeNodeNS;
    procedure basic_hasAttributes_setAttribute;
    procedure basic_hasAttribute_setAttributeNode;
    procedure basic_hasChildNodes;
    procedure basic_importNode;
    procedure basic_insertBefore;
    procedure basic_isSupported;
    procedure basic_lastChild;
    procedure basic_nsdecl;
    procedure basic_ownerElement;
    procedure basic_removeAttribute;
    procedure basic_removeAttributeNode;
    procedure basic_removeAttributeNS;
    procedure basic_removeChild;
    procedure basic_replaceChild;
    procedure ext_appendChild_existing;
    procedure ext_appendChild_removeChild;
    procedure ext_append_100_attributes_with_different_namespaces;
    procedure ext_attributes_10times;
    procedure ext_childNodes_10times;
    procedure ext_createElementNS_defaultNS;
    procedure ext_docType;
    procedure ext_document_setNodeValue;
    procedure ext_element_setNodeValue;
    procedure ext_getAttribute;
    procedure ext_getAttributeNodeNS;
    procedure ext_getAttributeNode_setAttributeNode;
    procedure ext_getAttributeNS;
    procedure ext_getElementsByTagName;
    procedure ext_getElementsByTagNameNS;
    procedure ext_getElementsByTagNameNS_10times;
    procedure ext_importNode_with_attribute;
    procedure ext_importNode_with_attributeNs;
    procedure ext_namedNodeMap;
    procedure ext_namedNodeMapNS;
    procedure ext_nextSibling_10times;
    procedure ext_nsdecl;
    procedure ext_previousSibling_10times;
    procedure ext_setAttributeNodeNs;
    procedure ext_setAttributeNS;
    procedure ext_setAttributeNS_removeAttributeNS;
    procedure ext_setDocumentElement;
    procedure ext_TestDocCount;
    procedure ext_unicode_NodeName;
    procedure ext_unicode_TextNodeValue;
    procedure unknown_createElementNS;
    procedure unknown_createElementNS_1;
    procedure unknown_normalize;
    property fqname: WideString read getFqname;
  end;

implementation

uses domSetup;

procedure debugDom(doc: IDOMDocument;bUnify: boolean=false);
begin
  if bUnify
    then showMessage(unify((doc as IDOMPersist).xml))
    else showMessage((doc as IDOMPersist).xml);
end;


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
  prefix := 'ct'; //+getUnicodeStr(1);
  Name := 'test'; //+getUnicodeStr(1);
  Data := 'Dies ist ein Beispiel-Text.'; //+getUnicodeStr(1);
end;

procedure TTestDom2Methods.TearDown;
begin
  nota := nil;
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

procedure TTestDom2Methods.ext_TestDocCount;
begin
  check((GetDoccount(impl) = 3),'Doccount not supported!');
  doc0 := nil;
  doc1 := nil;
  doc := nil;
  check(GetDoccount(impl) = 0,'documents not released');
end;

procedure TTestDom2Methods.ext_appendChild_existing;
var
  node: IDomNode;
  temp: string;
begin
  check(doc0.documentElement.childNodes.length = 0, 'wrong length (A)');
  node := doc0.createElement('sub1');
  doc0.documentElement.appendChild(node);
  check(doc0.documentElement.childNodes.length = 1, 'wrong length (B)');
  doc0.documentElement.appendChild(node);
  // DOM2: If the child is already in the tree, it is first removed. So there
  // must be only one child sub1 after the two calls of appendChild
  check(doc0.documentElement.childNodes.length = 1, 'wrong length');
  temp := ((doc0 as IDomPersist).xml);
  temp := unify(temp);
  check(temp = '<test><sub1/></test>', 'appendChild Error');
end;

procedure TTestDom2Methods.basic_getElementByID;
var
  elem: IDomElement;
begin
  elem := doc0.getElementById('110');
end;

procedure TTestDom2Methods.unknown_createElementNS_1;
var
  node: IDomNode;
  temp: string;
begin
  check(doc0.documentElement.childNodes.length = 0, 'wrong length');
  node := doc0.createElementNS('http://ns.4ct.de', 'ct:test');
  doc0.documentElement.appendChild(node);
  check(doc0.documentElement.childNodes.length = 1, 'wrong length');
  temp := (doc0 as IDomPersist).xml;
  temp := unify(temp);
  check(temp = '<test><ct:test xmlns:ct="http://ns.4ct.de"/></test>',
    'createElementNS failed');
end;

procedure TTestDom2Methods.unknown_createElementNS;
var
  node: IDomNode;
  temp: string;
begin
  check(doc1.documentElement.childNodes.length = 0, 'wrong length');
  node := doc1.createElementNS('http://ns.4ct.de', 'ct:test');
  doc1.documentElement.appendChild(node);
  check(doc1.documentElement.childNodes.length = 1, 'wrong length');
  temp := (doc1 as IDomPersist).xml;
  temp := unify(temp);
  check(temp =
    '<test xmlns="http://ns.4ct.de"><ct:test xmlns:ct="http://ns.4ct.de"/></test>',
    'createElementNS failed');
end;

procedure TTestDom2Methods.basic_createAttributeNS_createNsDecl;
var
  attr: IDomAttr;
  temp: string;
begin
  // this test failes with libxml2 in the moment
  // that is ok, because we (4ct) don't create ns-decl-attributes
  // manually in our current applications
  check(not doc0.documentElement.hasAttributes, 'has attributes');
  attr := doc0.createAttributeNS(xmlns,'xmlns:ct');
  attr.value := 'http://ns.4ct.de';
  doc0.documentElement.setAttributeNodeNS(attr);
  attr := doc0.createAttributeNS('http://ns.4ct.de', 'ct:name1');
  attr.Value := 'hund';
  doc0.documentElement.setAttributeNodeNS(attr);
  check(doc0.documentElement.attributes.length = 2, 'wrong length');
  temp := (doc0 as IDomPersist).xml;
  temp := unify(temp);
  check(temp = '<test xmlns:ct="http://ns.4ct.de" ct:name1="hund"/>',
    'perhaps namespace declaration attribute twice in the output')
end;

procedure TTestDOM2Methods.ext_append_100_attributes_with_different_namespaces;
var
  attr: IDomAttr;
  i:    integer;
  attrval, temp: string;
  ok:   boolean;
begin
  // create attributes
  for i := 0 to 2 do begin
    attr := doc0.createAttributeNS('http://test'+IntToStr(i)+'.invalid','test'+IntToStr(i)+':attr');
    attr.Value := IntToStr(i);
    doc0.documentElement.setAttributeNodeNS(attr);
    attr := nil;
  end;
  temp := (doc0 as IDomPersist).xml;
  temp := Unify(temp);
  ok := False;
  if temp = '<test xmlns:test0="http://test0.invalid" test0:attr="0" xmlns:test1="http://test1.invalid" test1:attr="1" xmlns:test2="http://test2.invalid" test2:attr="2"/>'
    then ok := True;
  if temp = '<test xmlns:test0="http://test0.invalid" xmlns:test1="http://test1.invalid" xmlns:test2="http://test2.invalid" test0:attr="0" test1:attr="1" test2:attr="2"/>'
    then ok := True;
  Check(ok, 'Test failed!');
  // check attributes
  for i := 0 to 2 do begin
    attrval := doc0.documentElement.getAttributeNS('http://test'+IntToStr(i)+'.invalid','attr');
    check(attrval = IntToStr(i),'expected '+IntToStr(i)+' but found '+attrval);
  end;
end;

procedure TTestDom2Methods.basic_appendChild;
begin
  elem := doc.createElement(Name);
  doc.documentElement.appendChild(elem);
  check(doc.documentElement.hasChildNodes, 'has no childNodes');
  check(myIsSameNode(elem, doc.documentElement.firstChild), 'wrong node');
end;

procedure TTestDom2Methods.ext_attributes_10times;
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

procedure TTestDom2Methods.ext_childNodes_10times;
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

procedure TTestDom2Methods.basic_cloneNode;
var
  OwnerDocument: IDomDocument;
begin
  // first simple test
  node := doc.createElement('child');
  elem := doc.createElement('test');
  elem.appendChild(node);
  doc.documentElement.appendChild(elem);
  node := elem.cloneNode(False);
  check(node <> nil, 'is nil');
  check(node.nodeName = Name, 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(not node.hasChildNodes, 'has child nodes');
  node := elem.cloneNode(True);
  check(node <> nil, 'is nil');
  check(node.nodeName = 'test', 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(node.hasChildNodes, 'has no child nodes');
  // the same with namespaces
  node := doc.createElementNs(nsuri, 'ct:child');
  check(node.namespaceURI=nsuri,'wrong nsuri');
  elem := doc.createElementNs(nsuri, 'ct:test');
  elem.appendChild(node);
  check(elem.namespaceURI=nsuri,'wrong nsuri');
  doc.documentElement.appendChild(elem);
  //debugDom(doc);
  check(elem.namespaceURI=nsuri,'wrong nsuri');
  OwnerDocument:=node.ownerDocument;
  check(OwnerDocument<>nil,'Ownerdocument is nil');
  node := elem.cloneNode(False);
  check(MyIsSameNode(node.ownerDocument,OwnerDocument),'wrong ownerdocument');
  check(node <> nil, 'is nil');
  check(node.nodeName = 'ct:test', 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(node.namespaceURI=nsuri,'wrong nsuri');
  check(not node.hasChildNodes, 'has child nodes');
  node := elem.cloneNode(True);
  check(node <> nil, 'is nil');
  check(node.nodeName = 'ct:test', 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(node.hasChildNodes, 'has no child nodes');
  check(node.firstChild.nodeName='ct:child', 'wrong childnode Name');
  check(node.firstChild.namespaceURI=nsuri,'wrong nsuri');
  // the same with attribute nodes
  attr := doc.createAttribute('test');
  doc.documentElement.setAttributeNode(attr);
  node := attr.cloneNode(False);
  check(node <> nil, 'is nil');
  check(node.nodeName = 'test', 'wrong nodeName');
  check(node.nodeType = ATTRIBUTE_NODE, 'wrong nodeType');
  check(not node.hasChildNodes, 'has child nodes');
end;

procedure TTestDom2Methods.basic_createAttribute;
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

procedure TTestDom2Methods.basic_createAttributeNS;
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
  check(attr.specified, 'is not specified');
  check(attr.Value = 'kamel', 'wrong value');
end;

procedure TTestDom2Methods.basic_createCDATASection;
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

procedure TTestDom2Methods.basic_createComment;
begin
  comment := doc.createComment(Data);
  check(comment <> nil, 'is nil');
  check(comment.Data = Data, 'wrong data');
  check(comment.length = Length(Data), 'wrong length');
  check(comment.nodeName = '#comment', 'wrong nodeName');
  check(comment.nodeValue = Data, 'wrong nodeValue');
  check(comment.nodeType = COMMENT_NODE, 'wrong nodeType');
end;

procedure TTestDom2Methods.basic_createDocumentFragment;
begin
  docfrag := doc.createDocumentFragment;
  check(docfrag <> nil, 'is nil');
  check(docfrag.nodeName = '#document-fragment', 'wrong nodeName');
  check(docfrag.nodeType = DOCUMENT_FRAGMENT_NODE, 'wrong nodeType');
end;

procedure TTestDom2Methods.basic_createElement;
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

procedure TTestDom2Methods.basic_createElementNS;
begin
  elem := doc.createElementNs(nsuri, fqname);
  check(elem <> nil, 'is nil');
  check(elem.nodeName = fqname, 'wrong nodeName');
  check(elem.tagName = fqname, 'wrong tagName');
  check(elem.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(elem.namespaceURI = nsuri, 'wrong namespaceURI');
  check(elem.prefix = prefix, 'wrong prefix');
  check(elem.localName = Name, 'wrong name');
  check(elem.attributes.length=0,'namespace decl attribute');
end;

procedure TTestDom2Methods.basic_createEntityReference;
begin
  entref := doc.createEntityReference(Name);
  check(entref <> nil, 'is nil');
  check(entref.nodeName = Name, 'wrong nodeName');
  check(entref.nodeType = ENTITY_REFERENCE_NODE, 'wrong nodeType');
end;

procedure TTestDom2Methods.basic_createProcessingInstruction;
begin
  pci := doc.createProcessingInstruction(Name, Data);
  check(pci <> nil, 'is nil');
  check(pci.target = Name, 'wrong target');
  check(pci.Data = Data, 'wrong data');
  check(pci.nodeName = Name, 'wrong nodeName');
  check(pci.nodeValue = Data, 'wrong nodeValue');
  check(pci.nodeType = PROCESSING_INSTRUCTION_NODE, 'wrong nodeType');
end;

procedure TTestDom2Methods.basic_createTextNode;
begin
  Text := doc.createTextNode(Data);
  check(Text <> nil, 'is nil');
  check(Text.Data = Data, 'wrong data');
  check(Text.length = Length(Data), 'wrong length');
  check(Text.nodeName = '#text', 'wrong nodeName');
  check(Text.nodeValue = Data, 'wrong nodeValue');
  check(Text.nodeType = TEXT_NODE, 'wrong nodeType');
  Text := Text.splitText(4);
  check(Text.Data = Copy(Data,5,Length(Data)-1),'wrong splitText - expected: "'+Copy(Data,5,Length(Data)-1)+'" found: "'+Text.Data+'"');
end;

procedure TTestDom2Methods.basic_docType;
  //var i: integer;
begin
  // there's no DTD !
  check(doc.docType = nil, 'not nil');
  // load xml with dtd
  (doc as IDomPersist).loadxml(xmlstr2);
  check(doc.docType <> nil, 'there is a DTD but docType is nil');
  check(doc.docType.entities <> nil, 'there are entities but entities are nil');
  check(doc.docType.entities.length = 2, 'wrong entities length');
  //ent := doc.docType.entities[0] as IDomEntity;
  // to be continued ...
  {
  i := doc.docType.notations.length;
  ShowMessage(IntToStr(i));
  }
end;

procedure TTestDom2Methods.basic_document;
begin
  check(doc <> nil, 'is nil');
  check(doc.nodeName = '#document', 'wrong nodeName');
  check(doc.nodeType = DOCUMENT_NODE, 'wrong nodeType');
  check(doc.ownerDocument = nil, 'ownerDocument not nil');
  check(doc.parentNode = nil, 'parentNode not nil');
end;

procedure TTestDom2Methods.basic_documentElement;
begin
  elem := doc.documentElement;
  check(elem <> nil, 'is nil');
  check(elem.tagName = 'root', 'wrong tagName');
  check(elem.nodeName = 'root', 'wrong nodeName');
  check(elem.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(myIsSameNode(elem.parentNode,doc), 'wrong parentNode');
  check(myIsSameNode(elem.ownerDocument,doc), 'wrong ownerDocument');
end;

procedure TTestDom2Methods.basic_documentFragment;
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

procedure TTestDom2Methods.basic_domImplementation;
begin
  check(doc.domImplementation <> nil, 'is nil');
end;

procedure TTestDom2Methods.basic_firstChild;
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
  check(elem.hasChildNodes, 'has no child nodes');
  check(node <> nil, 'first child is nil');
  check(node.nodeName = Name +'0', 'wrong nodeName');
  check(node.nodeType = ELEMENT_NODE, 'wrong nodeType');
  check(myIsSameNode(node.parentNode,elem), 'wrong parentNode');
  check(myIsSameNode(node.ownerDocument,doc), 'wrong ownerDocument');
end;

procedure TTestDom2Methods.basic_getAttributeNodeNS_setAttributeNodeNS;
begin
  elem := doc.createElement(Name);
  attr := doc.createAttributeNS(nsuri, fqname);
  elem.setAttributeNodeNS(attr);
  attr := elem.getAttributeNodeNS(nsuri, Name);
  check(attr <> nil, 'attribute is nil');
end;

procedure TTestDom2Methods.ext_getAttributeNodeNS;
begin
  elem := doc.createElement(Name);
  try
    attr := elem.getAttributeNodeNS(nsuri,Name);
    check(attr = nil, 'attribute is not nil');
  except
    fail('an exception was raised while getting a non existant attribute but nil should be returned');
  end;
end;

procedure TTestDom2Methods.ext_getAttributeNode_setAttributeNode;
begin
  elem := doc.createElement(Name);
  attr := doc.createAttribute('attr1');
  elem.setAttributeNode(attr);
  attr := doc.createAttribute('attr2');
  attr.Value := 'hund';
  elem.setAttributeNode(attr);
  attr := elem.getAttributeNode('attr1');
  check(attr <> nil, 'attribute is nil');
  attr := elem.getAttributeNode('attr2');
  check(attr.Value = 'hund', 'wrong value (I)');
  attr := doc.createAttribute('attr3');
  attr.Value := 'hase';
  elem.setAttributeNode(attr);
  attr := elem.getAttributeNode('attr3');
  check(attr.Value = 'hase', 'wrong value (II)');
  // try to get an attribute that does not exist
  attr := elem.getAttributeNode('item');
  check(attr = nil, 'getAttributeNode does not return nil');
end;

procedure TTestDom2Methods.basic_getAttributeNS_setAttributeNS;
begin
  elem := doc.createElement(Name);
  elem.setAttributeNS(nsuri, fqname, 'tiger');
  check(elem.getAttributeNS(nsuri, Name) = 'tiger', 'wrong value');
end;

procedure TTestDom2Methods.ext_getAttributeNS;
begin
  elem := doc.createElement(Name);
  try
    check(elem.getAttributeNS(nsuri, Name) = '', 'wrong value');
  except
    fail('getting the nodeValue of a non existant attribute raised an exception but should return an empty string');
  end;
end;

procedure TTestDom2Methods.basic_getAttribute_setAttribute;
begin
  elem := doc.createElement(Name);
  elem.setAttribute(Name, 'elephant');
  check(elem.getAttribute(Name) = 'elephant', 'wrong value');
end;

procedure TTestDom2Methods.ext_getAttribute;
begin
  elem := doc.createElement(Name);
  check(elem.getAttribute(Name) = '', 'getAttribute does not return an empty string but "'+elem.getAttribute(Name)+'"');
end;

procedure TTestDom2Methods.basic_getElementsByTagName;
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
  check(nodelist <> nil, 'getElementsByTagName returns nil');
  check(nodelist.length = n, 'wrong length');
  // check element interface
  nodelist := doc.documentElement.getElementsByTagName(Name);
  check(nodelist <> nil, 'getElementsByTagName returns nil');
  check(nodelist.length = n, 'wrong length');
  nodelist := doc.getElementsByTagName('*');
  check(nodelist.length = n + 1, 'wrong length');
end;

procedure TTestDom2Methods.basic_getElementsByTagNameNS;
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
  check(nodelist <> nil, 'getElementsByTagNameNS returns nil');
  check(nodelist.length = n, 'wrong length');
  // check element interface
  nodelist := doc.documentElement.getElementsByTagNameNS(nsuri, Name);
  check(nodelist <> nil, 'getElementsByTagNameNS returns nil');
  check(nodelist.length = n, 'wrong length');
end;

function TTestDom2Methods.getFqname: WideString;
begin
  if prefix = '' then result := Name
  else result := prefix + ':' + Name;
end;

procedure TTestDom2Methods.basic_hasAttribute_setAttributeNode;
begin
  elem := doc.createElement(Name);
  check(not elem.hasAttribute(Name), 'has attribute');
  attr := doc.createAttribute(Name);
  elem.setAttributeNode(attr);
  check(elem.hasAttribute(Name), 'has no attribute');
end;

procedure TTestDom2Methods.basic_hasAttributeNS_setAttributeNodeNS;
begin
  elem := doc.createElement(Name);
  check(not elem.hasAttributeNS(nsuri,Name), 'has attribute');
  attr := doc.createAttributeNS(nsuri, fqname);
  elem.setAttributeNodeNS(attr);
  check(elem.hasAttributeNS(nsuri, Name), 'has not attribute');
end;

procedure TTestDom2Methods.basic_hasChildNodes;
begin
  check(not doc.documentElement.hasChildNodes, 'has child nodes');
  elem := doc.createElement(Name);
  doc.documentElement.appendChild(elem);
  check(doc.documentElement.hasChildNodes, 'has no child nodes');
end;

procedure TTestDom2Methods.basic_importNode;
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
  check(node <> nil, 'importNode returned nil');
  check(node.ownerDocument = doc, 'wrong ownerDocument');
  check(node.parentNode = nil, 'parent node is not nil');
  check(not node.hasChildNodes, 'has child nodes');
  doc.documentElement.appendChild(node);
  // import node deep
  node := doc.importNode(adoc.documentElement.firstChild, True);
  check(node <> nil, 'importNode returned nil');
  check(node.ownerDocument = doc, 'wrong ownerDocument');
  check(node.parentNode = nil, 'parent node is not nil');
  check(node.hasChildNodes, 'has no child nodes');
  doc.documentElement.appendChild(node);
  // check result
  node := doc.documentElement.firstChild;
  check(node <> nil, 'first child is nil');
  check(node.nodeName = Name, 'wrong nodeName');
  node := doc.documentElement.lastChild;
  check(node <> nil, 'last child is nil');
  check(node.nodeName = Name, 'wrong nodeName');
  check(node.firstChild.nodeName = 'second', 'wrong nodeName');
end;

procedure TTestDOM2Methods.ext_importNode_with_attribute;
var
  adoc: IDomDocument;
  attr1,attr2: IDOMAttr;
begin
  // create a second dom
  adoc := impl.createDocument('', '', nil);
  check((adoc as IDomPersist).loadxml(xmlstr), 'parse error');
  // append new attribute to documentElement of 2nd dom
  attr1 := adoc.createAttribute(Name);
  attr1.value:='blau';
  adoc.documentElement.setAttributeNode(attr1);
  // clone the attribute => 2nd new attribute
  // this is unneccessary, if you use libxmldom.pas
  attr2 := ((attr1 as IDOMNode).cloneNode(false)) as IDOMAttr;
  // import the attribute => 3rd new attribute
  // this is unneccessary, if you use msxml
  attr := (doc.importNode(attr2,false)) as IDOMAttr;
  // append the attribute to documentElement of 1st dom
  doc.documentElement.setAttributeNode(attr);
  attr:=nil;
  attr:=doc.documentElement.attributes[0] as IDomAttr;
  check(attr <> nil, 'attribute is nil');
  check(attr.name=Name,'wrong name of imported attribute');
  check(attr.value='blau','wrong value of imported attribute');
  check(not myIsSameNode(doc,adoc),'the two documents must not be the same');
  check(myIsSameNode(attr.ownerDocument,doc), 'wrong ownerDocument');
end;


procedure TTestDom2Methods.basic_insertBefore;
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

procedure TTestDom2Methods.basic_isSupported;
begin
  check(doc.isSupported('Core', '2.0'), 'is false');
  check(doc.isSupported('XML', '2.0'), 'is false');
end;

procedure TTestDom2Methods.basic_lastChild;
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
  check(myIsSameNode(node.parentNode,elem), 'wrong parentNode');
  check(myIsSameNode(node.ownerDocument,doc), 'wrong ownerDocument');
end;

procedure TTestDom2Methods.ext_namedNodeMap;
begin
  nnmap := doc.documentElement.attributes;
  check(nnmap <> nil, 'attributes are  nil');
  check(nnmap.length = 0, 'wrong length I)');
  // set a namedItem
  attr := doc.createAttribute(Name);
  attr.Value := Data;
  nnmap.setNamedItem(attr);
  check(nnmap.length = 1, 'wrong length (II)');
  check(myIsSameNode(nnmap.getNamedItem(Name), attr), 'wrong node');
  check(nnmap.getNamedItem(Name).nodeValue = Data, 'wrong nodeValue');
  // set a namedItem with the same name as before
  attr := doc.createAttribute(Name);
  attr.Value := Data;
  nnmap.setNamedItem(attr);
  check(nnmap.length = 1, 'wrong length (III)');
  // set a namedItem with a different name
  attr := doc.createAttribute('snake');
  attr.Value := 'python';
  nnmap.setNamedItem(attr);
  check(nnmap.length = 2, 'wrong length (IV)');
  check(myIsSameNode(nnmap.getNamedItem('snake'), attr), 'wrong node');
  check(nnmap.getNamedItem('snake').nodeValue = 'python', 'wrong nodeValue');
  nnmap.removeNamedItem(Name);
  check(nnmap.length = 1, 'wrong length (V)');
  check(nnmap.item[0].nodeName = 'snake', 'wrong nodeName');
  attr := nil;
  attr := nnmap.namedItem['snake'] as IDomAttr;
  check(attr.Value = 'python', 'wrong value');
  // try to get an item that does not exist
  node := nnmap.namedItem['purzelbaum'];
  check(node = nil, 'getting namedItem for an item that does not exist does not return nil');
end;

procedure TTestDom2Methods.ext_namedNodeMapNS;
begin
  nnmap := doc.documentElement.attributes;
  check(nnmap <> nil, 'is nil');
  check(nnmap.length = 0, 'wrong length (I)');
  // set a namedItem
  // 1. set the nsdecl
  attr := doc.createAttributeNS('http://www.w3.org/2000/xmlns/','xmlns:'+prefix);
  attr.value := nsuri;
  nnmap.setNamedItemNS(attr);
  // 2. set the item itself
  attr := doc.createAttributeNS(nsuri, fqname);
  attr.Value := Data;
  nnmap.setNamedItem(attr);
  check(nnmap.length = 2, 'wrong length (II)');
  node := nnmap.getNamedItemNS(nsuri, Name);
  check(myIsSameNode(node,attr), 'wrong node');
  check(nnmap.getNamedItemNS(nsuri, Name).nodeValue = Data, 'wrong nodeValue');
  // set a namedItem with the same name as before
  attr := doc.createAttributeNS(nsuri, fqname);
  attr.Value := Data;
  nnmap.setNamedItemNS(attr);
  check(nnmap.length = 2, 'wrong length (III)');
  // set a namedItem with a different name
  attr := doc.createAttributeNS(nsuri, prefix + ':snake');
  attr.Value := 'python';
  nnmap.setNamedItemNS(attr);
  check(nnmap.length = 3, 'wrong length (IV)');
  check(myIsSameNode(nnmap.getNamedItemNS(nsuri, 'snake'), attr), 'wrong node');
  check(nnmap.getNamedItemNS(nsuri, 'snake').nodeValue = 'python', 'wrong nodeValue');
  // remove the first named item - nsdecl should be kept
  nnmap.removeNamedItemNS(nsuri, Name);
  check(nnmap.length = 2, 'wrong length (V)');
  check(nnmap.getNamedItemNS(nsuri,'snake').localName = 'snake', 'wrong localName');
  attr := nil;
  attr := nnmap.getNamedItemNS(nsuri,'snake') as IDomAttr;
  check(attr.Value = 'python', 'wrong value');
  // remove secound named item
  nnmap.removeNamedItemNS(nsuri,'snake');
  check(nnmap.length = 1, 'wrong length (VI)');
  // remove the nsdecl
  nnmap.removeNamedItemNS(xmlns,prefix);
  check(nnmap.length = 0, 'wrong length (VII)');
  // try to get an item that does not exist
  try
    node := nnmap.getNamedItemNS('http://invalid.item.org','item');
    check(node = nil, 'getNamedItemNS does not return nil');
  except
    fail('getNamedItemNS raised an exception but should return nil');
  end;
end;

procedure TTestDom2Methods.ext_nextSibling_10times;
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

procedure TTestDom2Methods.unknown_normalize;
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

procedure TTestDom2Methods.basic_ownerElement;
begin
  attr := doc.createAttribute(Name);
  elem := doc.createElement(Name);
  elem.setAttributeNode(attr);
  doc.documentElement.appendChild(elem);
  check(myIsSameNode(attr.ownerElement, elem), 'wrong ownerElement');
end;

procedure TTestDom2Methods.ext_previousSibling_10times;
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

procedure TTestDom2Methods.basic_removeAttribute;
begin
  elem := doc.createElement(Name);
  attr := doc.createAttribute(Name);
  elem.setAttributeNode(attr);
  elem.removeAttribute(Name);
  check(not elem.hasAttribute(Name), 'attribute still exists');
end;

procedure TTestDom2Methods.basic_removeAttributeNode;
begin
  elem := doc.createElement(Name);
  attr := doc.createAttribute(Name);
  elem.setAttributeNode(attr);
  elem.removeAttributeNode(attr);
  check(not elem.hasAttribute(Name), 'attribute still exists');
end;

procedure TTestDom2Methods.basic_removeAttributeNS;
begin
  elem := doc.createElement(Name);
  attr := doc.createAttributeNS(nsuri, fqname);
  elem.setAttributeNodeNS(attr);
  elem.removeAttributeNS(nsuri, Name);
  check(not elem.hasAttributeNS(nsuri, Name), 'is true');
end;

procedure TTestDom2Methods.basic_removeChild;
begin
  elem := doc.createElement(Name);
  doc.documentElement.appendChild(elem);
  doc.documentElement.removeChild(elem);
  check(not doc.documentElement.hasChildNodes, 'has child nodes');
end;

procedure TTestDom2Methods.basic_replaceChild;
begin
  elem := doc.createElement(Name +'0');
  doc.documentElement.appendChild(elem);
  elem := doc.createElement(Name +'1');
  doc.documentElement.replaceChild(elem, doc.documentElement.firstChild);
  check(doc.documentElement.hasChildNodes, 'has no child nodes');
  check(doc.documentElement.childNodes.length = 1, 'wrong count of childNodes');
  check(doc.documentElement.firstChild.nodeName = Name +'1', 'wrong nodeName');
end;

procedure TTestDom2Methods.ext_element_setNodeValue;
var
  tmp: string;
begin
  // setting the nodeValue of an element node should have no effect (w3c.org)
  elem := doc.createElement(Name);
  doc.documentElement.appendChild(elem);
  tmp := (doc as IDomPersist).xml;
  try
    elem.nodeValue := Data;
  except
    fail('setting the nodeValue of an element raised an exception but should have no effect');
  end;
  check((doc as IDomPersist).xml = tmp, 'Setting the nodeValue of an element node has an effect.');
end;

procedure TTestDom2Methods.ext_document_setNodeValue;
var
  tmp: string;
begin
  // setting the nodeValue of an document node should have no effect (w3c.org)
  tmp := (doc as IDomPersist).xml;
  try
    doc.nodeValue := Data;
  except
    fail('setting the nodeValue of a document raised an exception but schould have no effect');
  end;
  check((doc as IDomPersist).xml = tmp, 'Setting the nodeValue of a document node has an effect.');
end;

procedure TTestDom2Methods.ext_nsdecl;
const
  xmlstr3 = xmldecl +
            '<xObject'+
            ' id="xcl.customers.list"'+
            ' executor="sql"'+
            ' xmlns:xob="http://xmlns.4commerce.de/xob"'+
            ' auth="xcl.customers.list"'+
            ' connection="ib.kis"'+
            '>' +
            '  <result />' +
            '</xObject>';
begin
  // test if the namespace declaration is an attribute of the element
  // load a simple xml structure with a namespace declaration at the documentElement
  (doc as IDomPersist).loadxml(xmlstr3);
  nnmap := doc.documentElement.attributes;
  // test if parsed namespace attributes appear in attributes.length
  check(nnmap.length = 5, 'wrong length (I) - maybe the namespace declaration is left out');
  // test standard attribute
  attr := nnmap.namedItem['id'] as IDOMAttr;
  // test standard properties of the attribute
  check(attr.Name = 'id', 'normal attr: wrong name');
  check(attr.Value = 'xcl.customers.list', 'normal attr: wrong value');
  // test namespace attribute
  attr := nnmap.getNamedItemNS('http://www.w3.org/2000/xmlns/','xob') as IDOMAttr;
  // test standard properties of the attribute
  check(attr <> nil, 'attr is nil');
  check(attr.Name = 'xmlns:xob', 'xmlns attr: wrong name');
  check(attr.Value = 'http://xmlns.4commerce.de/xob', 'xmlns attr: wrong value');
  check(attr.prefix = 'xmlns', 'xmlns attr: wrong prefix');
  check(attr.localName = 'xob', 'xmlns attr: wrong localName');
  //debugDom(doc,true);
  {
  Note: In the DOM, all namespace declaration attributes are BY DEFINITION bound
  to the namespace URI: "http://www.w3.org/2000/xmlns/". These are the attributes
  whose namespace prefix or qualified name is "xmlns". Although, at the time of
  writing, this is not part of the XML Namespaces specification [XML Namespaces],
  it is planned to be incorporated in a future revision. (w3c.org)
  }
  {check(attr.namespaceURI = 'http://www.w3.org/2000/xmlns/',
    'xmlns attr: wrong namespaceURI - expected: "http://www.w3.org/2000/xmlns/" found: "' +
    attr.namespaceURI + '"');}
end;

procedure TTestDOM2Methods.ext_unicode_TextNodeValue;
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

procedure TTestDOM2Methods.ext_unicode_NodeName;
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

procedure TTestDOM2Methods.ext_setDocumentElement;
const
  header='<?xml version="1.0" encoding="iso-8859-1"?>';
var
  temp: string;
begin
  doc := impl.createDocument('','',nil);
  check(doc.documentElement = nil,'docelement is not nil');
  check((doc as IDomPersist).xml='','document isn''t empty');
  pci := doc.createProcessingInstruction('xml','version="1.0" encoding="iso-8859-1"');
  doc.appendChild(pci);
  elem := doc.createElement('root');
  doc.appendChild(elem);
  check(doc.documentElement.nodeName = 'root', 'wrong documentElement');
  temp:=((doc as IDOMPersist).xml);
  temp:=GetHeader(temp);
  check(temp=header,'wrong header')
end;

procedure TTestDOM2Methods.basic_nsdecl;
begin
  attr := doc.createAttributeNS('http://www.w3.org/2000/xmlns/','xmlns:frieda');
  attr.nodeValue := 'http://frieda.org';
  doc.documentElement.setAttributeNodeNs(attr);
  check(doc.documentElement.attributes.length = 1, 'wrong length');
  check(doc.documentElement.attributes[0].nodeName = 'xmlns:frieda', 'wrong nodeName');
  check(doc.documentElement.attributes[0].nodeValue = 'http://frieda.org', 'wrong nodeValue');
  check(doc.documentElement.attributes[0].prefix = 'xmlns', 'wrong prefix');
  check(doc.documentElement.attributes[0].localName = 'frieda', 'wrong localName');
  check(doc.documentElement.attributes[0].namespaceURI = 'http://www.w3.org/2000/xmlns/', 'wrong namespaceURI');
end;

procedure TTestDOM2Methods.ext_getElementsByTagNameNS_10times;
const
  n = 10;
  m = 5;
var
  i,j: integer;
  s: string;
begin
  for i := 0 to n-1 do begin
    for j := 0 to m-1 do begin
      elem := doc.createElementNS(Format('http://www.%dcommerce.de/test',[i]),Format('test%d:elem',[i]));
      elem.setAttribute('id',IntToStr(j));
      doc.documentElement.appendChild(elem);
    end;
  end;
  for i := 0 to n-1 do begin
    nodelist := doc.getElementsByTagNameNS(Format('http://www.%dcommerce.de/test',[i]),'elem');
    check(nodelist.length = m, 'wrong length');
    for j := 0 to m-1 do begin
      s := (nodelist[j] as IDOMElement).getAttribute('id');
      check(s=IntToStr(j),'wrong id');
    end;
  end;
end;

procedure TTestDOM2Methods.basic_hasAttributes_setAttribute;
begin
  elem := doc.createElement(Name);
  check(not elem.hasAttributes, 'has attributes');
  elem.setAttribute(Name,Data);
  check(elem.hasAttributes, 'has no attributes');
end;

procedure TTestDOM2Methods.ext_setAttributeNS;
//var err: boolean;
begin
  elem := doc.createElementNS(nsuri,fqname);
    // there's a namespace declaration
    // even though it's an attribute, it must not be shown
    check(not elem.hasAttributes, 'namespace declaration attributes must not be shown here');
    check(elem.attributes.length = 0, 'wrong length (I)');

  // make elem visible to ().xml
  doc.documentElement.appendChild(elem);

  elem.setAttributeNS(xmlns,'xmlns:abc','http://abc.org');
    // namespace declaration was set
    check(elem.attributes.length = 1, 'wrong length (Ia)');

  //I don't know, whether this check is OK
  //check(elem.getAttributeNS(xmlns,'abc') = 'http://abc.org', 'wrong value - found: "'+elem.getAttributeNS(xmlns,'abc')+'"');

  elem.setAttributeNS('http://abc.org','abc:wauwau',Data);
    // an attribute and a namespace declaration has been appended
    check(elem.attributes.length = 2, 'wrong length (II)');

  elem.setAttributeNS('http://abc.org','abc:mietze',Data);
    check(elem.attributes.length = 3, 'wrong length (III)');

  elem.setAttributeNS(nsuri,prefix+':bobo',Data);
    check(elem.attributes.length = 4, 'wrong length (IV)');

  elem.setAttributeNS('',Name,Data);
    // i wish to set an attribute that is not bount to a namespace
    check(elem.attributes.length = 5, 'wrong length (V)');

  elem.setAttributeNS(xmlns,'xmlns:def','http://abc.org');
    check(elem.attributes.length = 6, 'wrong length (VI)');

  elem.setAttributeNS('http://abc.org','def:zebra',Data);
    // the namespace uri was previously bound to the prefix 'abc'
    // is it an error ?
    check(elem.attributes.length = 7, 'wrong length (VII)');

  (*

{ TODO : please move to TestDomExceptions }

  err := False;
  try
    elem.setAttributeNS('http://def.org','abc:zebra',Data);
      // this should crash because the prefix 'abc' was previously used for a
      // different namspace uri
    err := True;
  except
    on E: Exception do begin
      check(E is EDOMException, 'wrong exception class');
      check((E as EDOMException).code = NAMESPACE_ERR, 'wrong exception code');
    end;
  end;
  if err then fail('exception not raised');

  *)
end;

procedure TTestDOM2Methods.ext_appendChild_removeChild;
var a,b,c,d,e: IDOMElement;
begin
  a := doc.createElement('el_A');
  b := doc.createElement('el_B');
  c := doc.createElement('el_C');
  d := doc.createElement('el_D');
  e := doc.createElement('el_E');
    check(doc.documentElement.childNodes.length = 0, 'wrong length (I)');

  // append a child to an empty list
  doc.documentElement.appendChild(a);
    check(doc.documentElement.childNodes.length = 1, 'wrong length (II)');

  // remove child that is first and last
  doc.documentElement.removeChild(a);
    check(doc.documentElement.childNodes.length = 0, 'wrong length (III)');

  doc.documentElement.appendChild(b);
    check(doc.documentElement.childNodes.length = 1, 'wrong length (IV)');

  // append child to a filled list
  doc.documentElement.appendChild(c);
    check(doc.documentElement.childNodes.length = 2, 'wrong length (V)');

  // remove child that is last but not first
  doc.documentElement.removeChild(c);
    check(doc.documentElement.childNodes.length = 1, 'wrong length (VI)');

  doc.documentElement.appendChild(d);
    check(doc.documentElement.childNodes.length = 2, 'wrong length (VII)');

  doc.documentElement.appendChild(e);
    check(doc.documentElement.childNodes.length = 3, 'wrong length (VIII)');

  // remove child that is in the middle of the list
  doc.documentElement.removeChild(d);
    check(doc.documentElement.childNodes.length = 2, 'wrong length (IX)');

  // remove child that is first but not last
  doc.documentElement.removeChild(b);
    check(doc.documentElement.childNodes.length = 1, 'wrong length (X)');

end;

procedure TTestDOM2Methods.ext_setAttributeNS_removeAttributeNS;
begin
  elem := doc.createElementNS('','test');
    check(not elem.hasAttributes, 'has attributes (I)');

  // make elem visible to ().xml
  doc.documentElement.appendChild(elem);

  elem.setAttributeNS('http://www.w3.org/2000/xmlns/','xmlns:abc','http://abc.org');
    // append a namespace declaration explicitly
    check(elem.hasAttributes, 'has no attributes');
    check(elem.attributes.length = 1, 'wrong length (0)');

  elem.setAttributeNS('http://abc.org','abc:zebra',Data);
    // append an attribute
    check(elem.nodeName = 'test', 'wrong nodeName');
    check(elem.hasAttributes, 'has no attributes (I)');
    check(elem.attributes.length = 2, 'wrong length (I)');
    check(elem.hasAttributeNS('http://abc.org','zebra'), 'has no attribute named "abc:zebra"');

  elem.removeAttributeNS('http://abc.org','zebra');
    // remove an attribute that is the first and last
    check(elem.hasAttributes, 'has no attributes (II)');
    check(elem.attributes.length = 1, 'wrong length (II)');

  // try to remove an attribute that does not exist
  try
    elem.removeAttributeNS('http://invalid.item.org','item');
  except
    fail('removeAttributeNS raises an exception but this action should have no effect');
  end;

  elem.setAttributeNS('http://abc.org','abc:zebra',Data);
  elem.setAttributeNS('http://abc.org','abc:okapi',Data);
  elem.setAttributeNS('http://abc.org','abc:apple',Data);
    check(elem.attributes.length = 4, 'wrong length (IIIa)');

  elem.removeAttributeNS('http://abc.org','apple');
    // remove an attribute that is the last but not first
    check(elem.attributes.length = 3, 'wrong length (IIIb)');

  elem.setAttributeNS('http://def.org','def:spider',Data);
    check(elem.attributes.length = 4, 'wrong length (IV)');

  elem.removeAttributeNS('http://abc.org','zebra');
    // remove an attribute that is the first but not last
    check(elem.attributes.length = 3, 'wrong length (V)');

  elem.setAttributeNS('http://abc.org','abc:zebra',Data);
  elem.setAttributeNS('http://ghi.org','ghi:bear',Data);
    check(elem.attributes.length = 5, 'wrong length (VI)');

  elem.removeAttributeNS('http://abc.org','zebra');
    // remove an attribute that is in the middle
    check(elem.attributes.length = 4, 'wrong legth (VII)');
end;

procedure TTestDOM2Methods.ext_createElementNS_defaultNS;
begin
  // xmlns:abc="..." declares a namespace
  // xmlns="..." declares the default namespace
  // the default namespace is not copied to each child
  check((doc as IDOMPersist).loadxml(xmldecl+'<root xmlns="http://orf.org" />'), 'parse error');
  check(doc.documentElement.hasAttributes, 'doesn''t show namespace declaration attribute');
  elem := doc.createElementNS('','def');
  doc.documentElement.appendChild(elem);
  check(not elem.hasAttributes, 'has attributes');
end;

procedure TTestDOM2Methods.ext_docType;
  var i: integer;
begin
  // there's no DTD !
  check(doc.docType = nil, 'not nil');
  // load xml with dtd
  (doc as IDomPersist).loadxml(xmlstr2);
  check(doc.docType <> nil, 'there is a DTD but docType is nil');
  check(doc.docType.entities <> nil, 'there are entities but entities are nil');
  check(doc.docType.entities.length = 2, 'wrong entities length');
  for i := 0 to doc.docType.entities.length-1 do begin
    ent := doc.docType.entities[i] as IDomEntity;
    //check(ent.notationName = 'type2', 'wrong notationName');
    // to be continued ...
  end;
  check(doc.docType.notations <> nil, 'there are notations but notations are nil');
  check(doc.docType.notations.length = 1, 'wrong notations length');
  for i := 0 to doc.docType.notations.length-1 do begin
    nota := doc.docType.notations[i] as IDOMNotation;
    check(nota.systemId = 'program2', 'wrong systemId');
    check(nota.nodeName = 'type2', nota.nodeName);
    check(nota.nodeType = NOTATION_NODE, 'wrong nodeType');
    check(myIsSameNode(nota.parentNode,doc.docType), 'wrong parentNode');
    check(myIsSameNode(nota.ownerDocument,doc), 'wrong ownerDocument');
  end;
end;

procedure TTestDOM2Methods.ext_getElementsByTagName;
var
  i: integer;
begin
  // build scenario
  elem := doc.createElement(Name);
  doc.documentElement.appendChild(elem);
  for i := 0 to 9 do begin
    elem := doc.createElement(Name);
    doc.documentElement.firstChild.appendChild(elem);
    elem := doc.createElement('bear');
    doc.documentElement.firstChild.appendChild(elem);
  end;

  // test
  nodelist := doc.documentElement.getElementsByTagName(Name);
  check(nodelist <> nil, 'getElementsByTagName returned nil (I)');
  check(nodelist.length = 11, 'wrong length (I)'+IntToStr(nodelist.length));

  nodelist := doc.documentElement.getElementsByTagName('*');
  check(nodelist <> nil, 'getElementsByTagName returned nil (II)');
  check(nodelist.length = 21, 'wrong length (II)'+IntToStr(nodelist.length));

  nodelist := (doc.documentElement.firstChild as IDOMElement).getElementsByTagName(Name);
  check(nodelist <> nil, 'getElementsByTagName returned nil (III)');
  check(nodelist.length = 10, 'wrong length (II)'+IntToStr(nodelist.length));

  nodelist := (doc.documentElement.firstChild as IDOMElement).getElementsByTagName('*');
  check(nodelist <> nil, 'getElementsByTagName returned nil (II)');
  check(nodelist.length = 20, 'wrong length (II)'+IntToStr(nodelist.length));
end;

procedure TTestDOM2Methods.ext_getElementsByTagNameNS;
const
  n = 10;
var
  i,j: integer;
  elem1: IDOMElement;
  //s: string;
begin
  // build scenario
  for i := 0 to n - 1 do begin
    elem := doc.createElementNS(nsuri, fqname);
    doc.documentElement.appendChild(elem);
    for j := 0 to n - 1 do begin
      elem1 := doc.createElementNS(nsuri,'abc:tag');
      elem.appendChild(elem1);
      elem1 := doc.createElementNS('http://orf.org','orf:tag');
      elem.appendChild(elem1);
      elem1 := doc.createElementNS('http://orf.org','orf:'+Name);
      elem.appendChild(elem1);
    end;
  end;
  // check element interface
  nodelist := doc.documentElement.getElementsByTagNameNS(nsuri, Name);
  check(nodelist <> nil, 'getElementsByTagNameNS returns nil');
  check(nodelist.length = n, 'wrong length (I)'+IntToStr(nodelist.length));
  nodelist := doc.documentElement.getElementsByTagNameNS(nsuri, '*');
  check(nodelist <> nil, 'getElementsByTagNameNS returns nil');
  {s := '';
  for i := 0 to nodelist.length-1 do begin
    s := s + nodelist[i].nodeName + ' - ' + nodelist[i].namespaceURI + CRLF;
  end;
  showMessage(s);}
  check(nodelist.length = n+n*n, 'wrong length (II)'+IntToStr(nodelist.length));
  nodelist := doc.documentElement.getElementsByTagNameNS('*', Name);
  check(nodelist <> nil, 'getElementsByTagNameNS returns nil');
  check(nodelist.length = n+n*n, 'wrong length (III)'+IntToStr(nodelist.length));
  nodelist := doc.documentElement.getElementsByTagNameNS('*', 'tag');
  check(nodelist <> nil, 'getElementsByTagNameNS returns nil');
  check(nodelist.length = n*n*2, 'wrong length IV)'+IntToStr(nodelist.length));
  nodelist := doc.documentElement.getElementsByTagNameNS('http://orf.org', '*');
  check(nodelist <> nil, 'getElementsByTagNameNS returns nil');
  check(nodelist.length = n*n*2, 'wrong length V'+IntToStr(nodelist.length));
end;

procedure TTestDOM2Methods.ext_setAttributeNodeNs;
begin
  elem := doc.createElementNS('','test');
  check(not elem.hasAttributes, 'has attributes');
  attr := doc.createAttributeNS(xmlns,'xmlns:abc');
  attr.value := 'http://abc.org';
  elem.setAttributeNodeNS(attr);
  check(elem.hasAttributes, 'has no attributes');
  attr := elem.getAttributeNodeNS(xmlns,'abc');
  check(attr<>nil,'namespace-attribute is not shown');
end;

procedure TTestDOM2Methods.ext_importNode_with_attributeNs;
var
  adoc: IDomDocument;
  attr1,attr2: IDOMAttr;
begin
  // create a second dom
  adoc := impl.createDocument('', '', nil);
  check((adoc as IDomPersist).loadxml(xmlstr), 'parse error');
  // append new attribute to documentElement of 2nd dom
  attr1 := adoc.createAttributeNs(nsuri, fqname);
  attr1.value:='grün';
  check(attr1.name=fqname,'wrong name of original attribute');
  adoc.documentElement.setAttributeNodeNs(attr1);
  attr1:=nil;
  attr1:=adoc.documentElement.attributes[0] as IDomAttr;
  check(attr1.name=fqname,'wrong name of original attribute');
  // clone the attribute => 2nd new attribute
  // this is unneccessary, if you use libxmldom.pas
  attr2 := ((attr1 as IDOMNode).cloneNode(false)) as IDOMAttr;
  check(attr2.name=fqname,'wrong name of original attribute');
  // import the attribute => 3rd new attribute
  // this is unneccessary, if you use msxml
  attr := (doc.importNode(attr2,false)) as IDOMAttr;
  check(attr.name=fqname,'wrong name of imported attribute');
  // append the attribute to documentElement of 1st dom
  doc.documentElement.setAttributeNodeNs(attr);
  attr:=nil;
  attr:=doc.documentElement.attributes[0] as IDomAttr;
  check(attr <> nil, 'attribute is nil');
  check(attr.name=fqname,'wrong name of imported attribute');
  check(attr.value='grün','wrong value of imported attribute');
  check(not myIsSameNode(doc,adoc),'the two documents must not be the same');
  check(myIsSameNode(attr.ownerDocument,doc), 'wrong ownerDocument');
end;

initialization
  datapath := getDataPath;
  CoInitialize(nil);

end.