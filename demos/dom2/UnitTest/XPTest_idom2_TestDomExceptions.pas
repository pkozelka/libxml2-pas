unit XPTest_idom2_TestDomExceptions;

interface

uses
  TestFrameWork,
  libxmldom,
  idom2,
  domSetup,
  SysUtils,
  XPTest_idom2_Shared,
  ActiveX,
  QDialogs;

type 
  TTestDomExceptions = class(TTestCase)
  private
    impl: IDomImplementation;
    doc: IDomDocument;
    doc1: IDomDocument;
    elem: IDomElement;
    prefix: string;
    Name: string;
    nsuri: string;
    Data: string;
    attr: IDomAttr;
    node: IDomNode;
    select: IDomNodeSelect;
    nodelist: IDomNodeList;
    nnmap: IDOMNamedNodeMap;
    pci: IDomProcessingInstruction;
    entref: IDomEntityReference;
    cdata: IDomCharacterData;
    text: IDOMText;
    noex: boolean;
    function getFqname: string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure AppendAttribute;
    procedure AppendNilNode;
    procedure InsertNilNode;
    procedure InsertAnchestor;
    procedure appendChild1;
    procedure appendChild2;
    procedure appendChild3;
    procedure appendChild4;
    procedure createAttribute1;
    procedure createAttributeNS1;
    procedure createAttributeNS2;
    procedure createAttributeNS3;
    procedure createAttributeNS4;
    procedure createAttributeNS5;
    procedure createDocument;
    procedure createDocument1;
    procedure createDocument2;
    procedure createDocument3;
    procedure createElement1;
    procedure createElementNS1;
    procedure createElementNS2;
    procedure createElementNS3;
    procedure createEntityReference1;
    procedure createProcessingInstruction1;
    procedure insertBefore1;
    procedure insertBefore2;
    procedure insertBefore3;
    procedure insertBefore4;
    procedure insertBefore5;
    procedure insertBefore6;
    procedure removeChild1;
    procedure removeChild2;
    procedure replaceChild1;
    procedure replaceChild2;
    procedure replaceChild3;
    procedure removeNamedItem1;
    procedure removeNamedItem2;
    procedure removeNamedItem3;
    procedure setNamedItem1;
    procedure setNamedItem2;
    procedure setNamedItem3;
    procedure setNamedItem4;
    procedure setNamedItemNS1;
    procedure setNamedItemNS2;
    procedure setNamedItemNS3;
    procedure setNamedItemNS4;
    procedure deleteData1;
    procedure deleteData2;
    procedure deleteData3;
    procedure insertData1;
    procedure insertData2;
    procedure replaceData1;
    procedure replaceData2;
    procedure replaceData3;
    procedure substringData1;
    procedure substringData2;
    procedure substringData3;
    procedure removeAttributeNode1;
    procedure setAttribute1;
    procedure setAttributeNS1;
    procedure setAttributeNS2;
    procedure setAttributeNS3;
    procedure setAttributeNS4;
    procedure setAttributeNS5;
    procedure setAttributeNode1;
    procedure setAttributeNode2;
    procedure setAttributeNodeNS1;
    procedure setAttributeNodeNS2;
    procedure splitText1;
    procedure splitText2;
    procedure selectNodes3;
    property fqname: string read getFqname;
  end;

implementation

{ TTestDomExceptions }

procedure TTestDomExceptions.SetUp;
begin
  inherited;
  impl := DomSetup.getCurrentDomSetup.getDocumentBuilder.domImplementation;
  doc := impl.createDocument('', '', nil);
  (doc as IDomPersist).loadxml(xmlstr);
  doc1 := impl.createDocument('', '', nil);
  (doc1 as IDomPersist).loadxml(xmlstr1);
  nsuri := 'http://ns.4commerce.de';
  prefix := 'ct';
  Name := 'test';
  Data := 'Dies ist ein Beispiel-Text.';
  noex := False;
end;

procedure TTestDomExceptions.TearDown;
begin
  elem := nil;
  nnmap := nil;
  attr := nil;
  node := nil;
  select := nil;
  nodelist := nil;
  pci := nil;
  entref := nil;
  cdata := nil;
  text := nil;
  doc := nil;
  doc1 := nil;
  impl := nil;
  check(doccount = 0,'doccount<>0');
  inherited;
end;

function TTestDomExceptions.getFqname: string;
begin
  if prefix = '' then Result := Name
  else Result := prefix + ':' + Name;
end;

procedure TTestDomExceptions.selectNodes3;
begin
  select := doc.documentElement as IDomNodeSelect;
  try
    nodelist := select.selectNodes('"');
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = SYNTAX_ERR,
          'wrong exception raised: ' + E.Message);
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.AppendAttribute;
var
  attr: IDomAttr;
begin
  try
    attr := doc.createAttribute('test');
    doc.documentElement.appendChild(attr);
    fail('There should have been an EDomException');
  except
    on E: Exception do Check(E is EDomException, 'Warning: Wrong exception type!');
  end;
end;

procedure TTestDomExceptions.AppendNilNode;
begin
  try
    doc.documentElement.appendChild(nil);
    fail('There should have been an EDomError');
  except
    on E: Exception do Check(E is EDomException, 'Warning: Wrong exception type!');
  end;
end;

procedure TTestDomExceptions.InsertNilNode;
var
  node: IDomNode;
begin
  node := doc.createElement('sub1');
  doc.documentElement.appendChild(node);
  try
    doc.documentElement.insertBefore(nil, node);
    fail('There should have been an EDomError');
  except
    on E: Exception do Check(E is EDomException, 'Warning: Wrong exception type!');
  end;
end;

procedure TTestDomExceptions.InsertAnchestor;
var 
  node1, node2: IDomNode;
begin
  node1 := doc.createElement('sub1');
  node2 := doc.createElement('sub2');
  node1.appendChild(node2);
  doc.documentElement.appendChild(node1);
  try
    node1.insertBefore(doc.documentElement, node2);
    fail('There should have been an EDomError');
  except
    on E: Exception do Check(E is EDomException, 'Warning: Wrong exception type!');
  end;
end;

function getCodeStr(code: integer): string;
begin
  result := 'error';
  case code of
    HIERARCHY_REQUEST_ERR: result := 'HIERARCHY_REQUEST_ERR';
    WRONG_DOCUMENT_ERR   : result := 'WRONG_DOCUMENT_ERR';
  end;
end;

function getErrStr(e: Exception; code: integer = 0): string;
var
  expected,found: string;
begin
  result := 'error';
  if e is EDomException then begin
    expected := getCodeStr(code);
    found    := getCodeStr((E as EDomException).code);
    result := Format('wrong exception raised - expected "%s" found "%s"', [expected,found]);
  end else begin
    result := Format('wrong exception raised: %s "%s"',[E.ClassName,E.Message]);
  end;
end;

procedure TTestDomExceptions.appendChild1;
begin
  elem := doc.createElement(Name);
  // node is of a type that does not allow children of the type of the newChild node
  try
    elem.appendChild(doc as IDomNode);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, getErrStr(E,HIERARCHY_REQUEST_ERR));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.appendChild2;
begin
  elem := doc.createElement(Name);
  doc.documentElement.appendChild(elem);
  // node to append is one of this node's ancestors
  try
    elem.appendChild(doc.documentElement);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, getErrStr(E,HIERARCHY_REQUEST_ERR));
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.appendChild3;
begin
  elem := doc.createElement(Name);
  // node to append is this node itself
  try
    elem.appendChild(elem);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, getErrStr(E,HIERARCHY_REQUEST_ERR));
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.appendChild4;
var
  doc2: IDomDocument;
begin
  doc2 := impl.createDocument('', '', nil);
  (doc2 as IDomPersist).loadxml(xmlstr);
  elem := doc2.createElement(Name);
  // if newChild was created from a different document
  // than the one that created this node
  try
    doc.documentElement.appendChild(elem);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = WRONG_DOCUMENT_ERR, getErrStr(E,WRONG_DOCUMENT_ERR));
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createAttribute1;
begin
  // the specified name contains an illegal character
  try
    attr := doc.createAttribute('!@"#');
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INVALID_CHARACTER_ERR, getErrStr(E,INVALID_CHARACTER_ERR));
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createAttributeNS1;
begin
  // the specified name contains an illegal character
  try
    attr := doc.createAttributeNS(nsuri, '!@"#');
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INVALID_CHARACTER_ERR, getErrStr(E,INVALID_CHARACTER_ERR));
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createAttributeNS2;
begin
  // the qualifiedName has a prefix and the namespaceURI is null
  try
    attr := doc.createAttributeNS('', 'ct:test');
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NAMESPACE_ERR, getErrStr(E,NAMESPACE_ERR));
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createAttributeNS3;
begin
  // the qualifiedName has a prefix that is "xml" and
  // the namespaceURI is different from "http://www.w3.org/XML/1998/namespace"
  try
    attr := doc.createAttributeNS(nsuri, 'xml:test');
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NAMESPACE_ERR, getErrStr(E,NAMESPACE_ERR));
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createAttributeNS4;
begin
  // the qualifiedName is "xmlns"
  // and the namespaceURI is different from "http://www.w3.org/2000/xmlns/".
  try
    attr := doc.createAttributeNS(nsuri, 'xmlns');
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NAMESPACE_ERR, getErrStr(E,NAMESPACE_ERR));
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createAttributeNS5;
begin
  // the prefix is "xmlns"
  // and the namespaceURI is different from "http://www.w3.org/2000/xmlns/".
  try
    attr := doc.createAttributeNS(nsuri, 'xmlns:test');
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NAMESPACE_ERR, getErrStr(E,NAMESPACE_ERR));
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createDocument;
begin
  // the specified qualified name contains an illegal character
  try
    doc := impl.createDocument('', '"', nil);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INVALID_CHARACTER_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createDocument1;
begin
  // the qualifiedName has a prefix and the namespaceURI is null
  try
    doc := impl.createDocument('', fqname, nil);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createDocument2;
begin
  // the qualifiedName is null and the namespaceURI is different from null
  try
    doc := impl.createDocument(nsuri, '', nil);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createDocument3;
begin
  // the qualifiedName has a prefix that is "xml" and
  // the namespaceURI is different from "http://www.w3.org/XML/1998/namespace"
  try
    doc := impl.createDocument(nsuri, 'xml:test', nil);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createElement1;
begin
  // the specified name contains an illegal character
  try
    elem := doc.createElement('!@#"');
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INVALID_CHARACTER_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createElementNS1;
begin
  // the specified qualified name contains an illegal character
  try
    elem := doc.createElementNS(nsuri, '"');
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INVALID_CHARACTER_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createElementNS2;
begin
  // the qualifiedName has a prefix and the namespaceURI is null
  try
    elem := doc.createElementNS('', fqname);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createElementNS3;
begin
  // the qualifiedName has a prefix that is "xml" and
  // the namespaceURI is different from "http://www.w3.org/XML/1998/namespace"
  try
    elem := doc.createElementNS(nsuri, 'xml:test');
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createEntityReference1;
begin
  // the specified name contains an illegal character
  try
    entref := doc.createEntityReference('"');
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INVALID_CHARACTER_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.createProcessingInstruction1;
begin
  // the specified name contains an illegal character
  try
    pci := doc.createProcessingInstruction('!@#"', Data);
    //don't know, what an illegal character in the target is
    //noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INVALID_CHARACTER_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.insertBefore1;
begin
  elem := doc.createElement(Name);
  node := doc.createElement(Name);
  elem.appendChild(node);
  // node is of a type that does not allow children of the type of the newChild node
  try
    elem.insertBefore(doc as IDomNode, node);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.insertBefore2;
begin
  elem := doc.createElement(Name);
  node := doc.createElement(Name);
  elem.appendChild(node);
  doc.documentElement.appendChild(elem);
  // node to insert is one of this node's ancestors
  try
    elem.insertBefore(doc.documentElement, node);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.insertBefore3;
begin
  elem := doc.createElement(Name);
  node := doc.createElement(Name);
  elem.appendChild(node);
  // node to insert is this node itself
  try
    elem.insertBefore(elem, node);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.insertBefore4;
begin
  elem := doc.createElement(Name);
  // node if of type Document and the DOM application
  // attempts to insert a second Element node
  try
    doc.insertBefore(elem, doc.documentElement);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.insertBefore5;
begin
  elem := doc.createElement(Name);
  node := doc1.createElement(Name);
  doc.documentElement.appendChild(elem);
  // WRONG_DOCUMENT_ERR: Raised if newChild was created from a different document
  // than the one that created this node
  try
    doc.documentElement.insertBefore(node,elem);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = WRONG_DOCUMENT_ERR, getErrStr(E,WRONG_DOCUMENT_ERR));
      end else begin
        fail('wrong exception: ' + E.Message);
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.insertBefore6;
begin
  elem := doc.createElement(Name);
  node := doc.createElement(Name);
  // NOT_FOUND_ERR: Raised if refChild is not a child of this node.
  try
    doc.documentElement.insertBefore(node,elem);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NOT_FOUND_ERR, getErrStr(E,NOT_FOUND_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.removeChild1;
begin
  elem := doc.createElement(Name);
  // NOT_FOUND_ERR: Raised if oldChild is not a child of this node.
  try
    doc.documentElement.removeChild(elem);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NOT_FOUND_ERR, getErrStr(E,NOT_FOUND_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.removeChild2;
begin
  attr := doc.createAttribute(Name);
  // HIERARCHY_REQUEST_ERR: Raised if this node is of a type that does not allow
  // children of the type of the newChild node
  try
    doc.appendChild(attr);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, getErrStr(E,HIERARCHY_REQUEST_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.replaceChild1;
begin
  elem := doc.createElement(Name);
  node := doc.createElement(Name);
  elem.appendChild(node);
  doc.documentElement.appendChild(elem);
  // HIERARCHY_REQUEST_ERR: Raised if the node to put in is one
  // of this node's ancestors or this node itself.
  try
    elem.replaceChild(doc.documentElement,node);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, getErrStr(E,HIERARCHY_REQUEST_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.replaceChild2;
begin
  elem := doc.createElement(Name);
  node := doc1.createElement(Name);
  doc.documentElement.appendChild(elem);
  // WRONG_DOCUMENT_ERR: Raised if newChild was created from a different document
  // than the one that created this node.
  try
    doc.documentElement.replaceChild(node,elem);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = WRONG_DOCUMENT_ERR, getErrStr(E,WRONG_DOCUMENT_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.replaceChild3;
begin
  elem := doc.createElement(Name);
  node := doc.createElement(Name);
  // NOT_FOUND_ERR: Raised if oldChild is not a child of this node.
  try
    doc.documentElement.replaceChild(node,elem);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NOT_FOUND_ERR, getErrStr(E,NOT_FOUND_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.removeNamedItem1;
begin
  elem := doc.createElement(Name);
  elem.setAttribute(Name,Data);
  nnmap := elem.attributes;
  // NOT_FOUND_ERR: Raised if there is no node named name in this map.
  try
    nnmap.removeNamedItem('X');
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NOT_FOUND_ERR, getErrStr(E,NOT_FOUND_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.removeNamedItem2;
begin
  elem := doc.createElementNS(nsuri,fqname);
  elem.setAttributeNS(nsuri,Name,Data);
  nnmap := elem.attributes;
  // NOT_FOUND_ERR: Raised if there is no node with the specified namespaceURI
  // and localName in this map.
  try
    nnmap.removeNamedItemNS(nsuri,'X');
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NOT_FOUND_ERR, getErrStr(E,NOT_FOUND_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.removeNamedItem3;
begin
  elem := doc.createElementNS(nsuri,fqname);
  elem.setAttributeNS(nsuri,Name,Data);
  nnmap := elem.attributes;
  // NOT_FOUND_ERR: Raised if there is no node with the specified namespaceURI
  // and localName in this map.
  try
    nnmap.removeNamedItemNS('X',Name);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NOT_FOUND_ERR, getErrStr(E,NOT_FOUND_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setNamedItem1;
begin
  elem := doc.createElement(Name);
  elem.setAttribute(Name,Data);
  attr := doc1.createAttribute(Name);
  nnmap := elem.attributes;
  // WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than
  // the one that created this map.
  try
    nnmap.setNamedItem(attr);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = WRONG_DOCUMENT_ERR, getErrStr(E,WRONG_DOCUMENT_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setNamedItem2;
begin
  elem := doc.createElement(Name);
  node := doc.createElement(Name);
  elem.setAttribute(Name,Data);
  //doc.documentElement.appendChild(elem);
  attr := elem.getAttributeNode(Name);
  nnmap := node.attributes;
  // INUSE_ATTRIBUTE_ERR: Raised if arg is an Attr that is already an attribute
  // of another Element object. The DOM user must explicitly clone Attr nodes to
  // re-use them in other elements.
  try
    nnmap.setNamedItem(attr);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INUSE_ATTRIBUTE_ERR, getErrStr(E,INUSE_ATTRIBUTE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setNamedItem3;
begin
  elem := doc.createElement(Name);
  node := doc.createElement(Name);
  elem.setAttribute(Name,Data);
  nnmap := elem.attributes;
  // HIERARCHY_REQUEST_ERR: Raised if an attempt is made to add a node doesn't
  // belong in this NamedNodeMap. Examples would include trying to insert
  // something other than an Attr node into an Element's map of attributes.
  try
    nnmap.setNamedItem(node);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, getErrStr(E,HIERARCHY_REQUEST_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setNamedItem4;
begin
  // entities are read only in DOM Level 2 !!!
  if doc.docType<>nil
    then nnmap := doc.docType.entities;
  {
  elem := doc.createElement(Name);
  // HIERARCHY_REQUEST_ERR: Raised if an attempt is made to add a node doesn't
  // belong in this NamedNodeMap. Examples would include trying to insert
  // a non-Entity node into the DocumentType's map of Entities.
  try
    nnmap.setNamedItem(elem);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, getErrStr(E,HIERARCHY_REQUEST_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
  }
end;

procedure TTestDomExceptions.setNamedItemNS1;
begin
  elem := doc.createElementNS(nsuri,fqname);
  elem.setAttributeNS(nsuri,fqname,Data);
  nnmap := elem.attributes;
  attr := doc1.createAttributeNS(nsuri,fqname+'1');
  // WRONG_DOCUMENT_ERR: Raised if arg was created from a different document
  // than the one that created this map.
  try
    nnmap.setNamedItem(attr);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = WRONG_DOCUMENT_ERR, getErrStr(E,WRONG_DOCUMENT_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setNamedItemNS2;
begin
  elem := doc.createElementNS(nsuri,fqname);
  elem.setAttributeNS(nsuri,fqname+'0',Data);
  nnmap := elem.attributes;
  node := doc.createElementNS(nsuri,fqname);
  attr := doc.createAttributeNS(nsuri,fqname+'1');
  (node as IDOMElement).setAttributeNodeNS(attr);
  // INUSE_ATTRIBUTE_ERR: Raised if arg is an Attr that is already an attribute
  // of another Element object. The DOM user must explicitly clone Attr nodes
  // to re-use them in other elements.
  try
    nnmap.setNamedItem(attr);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code =  INUSE_ATTRIBUTE_ERR, getErrStr(E,WRONG_DOCUMENT_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setNamedItemNS3;
begin
  elem := doc.createElementNS(nsuri,fqname);
  node := doc.createElementNS(nsuri,fqname);
  elem.setAttributeNS(nsuri,fqname,Data);
  nnmap := elem.attributes;
  // HIERARCHY_REQUEST_ERR: Raised if an attempt is made to add a node doesn't
  // belong in this NamedNodeMap. Examples would include trying to insert
  // something other than an Attr node into an Element's map of attributes.
  try
    nnmap.setNamedItem(node);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, getErrStr(E,HIERARCHY_REQUEST_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setNamedItemNS4;
begin
  // entities are read only in DOM Level 2 !!!
  if doc.docType<>nil
    then nnmap := doc.docType.entities;
  {
  elem := doc.createElementNS(nsuri,fqname);
  // HIERARCHY_REQUEST_ERR: Raised if an attempt is made to add a node doesn't
  // belong in this NamedNodeMap. Examples would include trying to insert
  // a non-Entity node into the DocumentType's map of Entities.
  try
    nnmap.setNamedItemNS(elem);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, getErrStr(E,HIERARCHY_REQUEST_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
  }
end;

procedure TTestDomExceptions.deleteData1;
begin
  cdata := doc.createTextNode(Data);
  // INDEX_SIZE_ERR: Raised if the specified offset is negative
  try
    cdata.deleteData(-1,1);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INDEX_SIZE_ERR, getErrStr(E,INDEX_SIZE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.deleteData2;
begin
  cdata := doc.createTextNode(Data);
  // INDEX_SIZE_ERR: Raised if the specified offset is greater than the number
  // of 16-bit units in data
  try
    cdata.deleteData(Length(Data)+100,1);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INDEX_SIZE_ERR, getErrStr(E,INDEX_SIZE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.deleteData3;
begin
  cdata := doc.createTextNode(Data);
  // INDEX_SIZE_ERR: Raised if the specified count is negative.
  try
    cdata.deleteData(0,-1);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INDEX_SIZE_ERR, getErrStr(E,INDEX_SIZE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.insertData1;
begin
  cdata := doc.createTextNode(Data);
  // INDEX_SIZE_ERR: Raised if the specified offset is negative
  try
    cdata.insertData(-1,Data);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INDEX_SIZE_ERR, getErrStr(E,INDEX_SIZE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.insertData2;
begin
  cdata := doc.createTextNode(Data);
  // INDEX_SIZE_ERR: Raised if the specified offset is greater than the number
  // of 16-bit units in data.
  try
    cdata.insertData(Length(Data)+100,Data);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INDEX_SIZE_ERR, getErrStr(E,INDEX_SIZE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.replaceData1;
begin
  cdata := doc.createTextNode(Data);
  // INDEX_SIZE_ERR: Raised if the specified offset is negative
  try
    cdata.replaceData(-1,1,Data);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INDEX_SIZE_ERR, getErrStr(E,INDEX_SIZE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.replaceData2;
begin
  cdata := doc.createTextNode(Data);
  // INDEX_SIZE_ERR: Raised if the specified offset is greater than the number
  // of 16-bit units in data
  try
    cdata.replaceData(Length(Data)+100,1,Data);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INDEX_SIZE_ERR, getErrStr(E,INDEX_SIZE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.replaceData3;
begin
  cdata := doc.createTextNode(Data);
  // INDEX_SIZE_ERR: Raised if the specified count is negative.
  try
    cdata.replaceData(1,-1,Data);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INDEX_SIZE_ERR, getErrStr(E,INDEX_SIZE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.substringData1;
begin
  cdata := doc.createTextNode(Data);
  // INDEX_SIZE_ERR: Raised if the specified offset is negative
  try
    Data := cdata.subStringData(-1,1);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INDEX_SIZE_ERR, getErrStr(E,INDEX_SIZE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.substringData2;
begin
  cdata := doc.createTextNode(Data);
  // INDEX_SIZE_ERR: Raised if the specified offset is greater than the number
  // of 16-bit units in data
  try
    Data := cdata.subStringData(Length(Data)+100,1);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INDEX_SIZE_ERR, getErrStr(E,INDEX_SIZE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.substringData3;
begin
  cdata := doc.createTextNode(Data);
  // INDEX_SIZE_ERR: Raised if the specified count is negative.
  try
    Data := cdata.subStringData(1,-1);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INDEX_SIZE_ERR, getErrStr(E,INDEX_SIZE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.removeAttributeNode1;
begin
  attr := doc.createAttribute(Name);
  // NOT_FOUND_ERR: Raised if oldAttr is not an attribute of the element.
  try
    doc.documentElement.removeAttributeNode(attr);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NOT_FOUND_ERR, getErrStr(E,NOT_FOUND_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setAttribute1;
begin
  // INVALID_CHARACTER_ERR: Raised if the specified name contains an illegal
  // character.
  try
    doc.documentElement.setAttribute('"',Data);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INVALID_CHARACTER_ERR, getErrStr(E,INVALID_CHARACTER_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setAttributeNS1;
begin
  // INVALID_CHARACTER_ERR: Raised if the specified qualified name contains an
  // illegal character, per the XML 1.0 specification [XML].
  try
    doc.documentElement.setAttributeNS(nsuri,'":"',Data);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INVALID_CHARACTER_ERR, getErrStr(E,INVALID_CHARACTER_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setAttributeNS2;
begin
  // NAMESPACE_ERR: Raised if the qualifiedName has a prefix and the
  // namespaceURI is null
  try
    doc.documentElement.setAttributeNS('',fqname,Data);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NAMESPACE_ERR, getErrStr(E,NAMESPACE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setAttributeNS3;
begin
  // NAMESPACE_ERR: Raised if the qualifiedName has a prefix that is "xml" and
  // the namespaceURI is different from "http://www.w3.org/XML/1998/namespace"
  try
    doc.documentElement.setAttributeNS('http://somedomain.invalid/namespace','xml:lang',Data);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NAMESPACE_ERR, getErrStr(E,NAMESPACE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setAttributeNS4;
begin
  // NAMESPACE_ERR: Raised if its prefix is "xmlns" and the namespaceURI is
  // different from "http://www.w3.org/2000/xmlns/".
  try
    doc.documentElement.setAttributeNS('http://somedomain.invalid/namespace','xmlns:ct',Data);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NAMESPACE_ERR, getErrStr(E,NAMESPACE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setAttributeNS5;
begin
  // NAMESPACE_ERR: Raised if the qualifiedName is "xmlns" and the namespaceURI
  // is different from "http://www.w3.org/2000/xmlns/".
  try
    doc.documentElement.setAttributeNS('http://somedomain.invalid/namespace','xmlns',Data);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = NAMESPACE_ERR, getErrStr(E,NAMESPACE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setAttributeNode1;
begin
  attr := doc1.createAttribute(Name);
  // WRONG_DOCUMENT_ERR: Raised if newAttr was created from a different document
  // than the one that created the element.
  try
    doc.documentElement.setAttributeNode(attr);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = WRONG_DOCUMENT_ERR, getErrStr(E,WRONG_DOCUMENT_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setAttributeNode2;
begin
  attr := doc.createAttribute(Name);
  elem := doc.createElement(Name);
  elem.setAttributeNode(attr);
  // INUSE_ATTRIBUTE_ERR: Raised if newAttr is already an attribute of another
  // Element object. The DOM user must explicitly clone Attr nodes to re-use
  // them in other elements.
  try
    doc.documentElement.setAttributeNode(attr);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INUSE_ATTRIBUTE_ERR, getErrStr(E,INUSE_ATTRIBUTE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;



procedure TTestDomExceptions.setAttributeNodeNS1;
begin
  attr := doc1.createAttributeNS(nsuri,fqname);
  // WRONG_DOCUMENT_ERR: Raised if newAttr was created from a different document
  // than the one that created the element.
  try
    doc.documentElement.setAttributeNodeNS(attr);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = WRONG_DOCUMENT_ERR, getErrStr(E,WRONG_DOCUMENT_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.setAttributeNodeNS2;
begin
  attr := doc.createAttributeNS(nsuri,fqname);
  elem := doc.createElementNS(nsuri,fqname);
  elem.setAttributeNodeNS(attr);
  // INUSE_ATTRIBUTE_ERR: Raised if newAttr is already an attribute of another
  // Element object. The DOM user must explicitly clone Attr nodes to re-use
  // them in other elements.
  try
    doc.documentElement.setAttributeNodeNS(attr);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INUSE_ATTRIBUTE_ERR, getErrStr(E,INUSE_ATTRIBUTE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.splitText1;
begin
  text := doc.createTextNode(Data);
  // INDEX_SIZE_ERR: Raised if the specified offset is negative
  try
    text.splitText(-1);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INDEX_SIZE_ERR, getErrStr(E,INDEX_SIZE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

procedure TTestDomExceptions.splitText2;
begin
  text := doc.createTextNode(Data);
  // INDEX_SIZE_ERR: Raised if the specified offset is greater than the number
  // of 16-bit units in data.
  try
    text.splitText(Length(data)+100);
    noex := True;
  except
    on E: Exception do begin
      if E is EDomException then begin
        check((E as EDomException).code = INDEX_SIZE_ERR, getErrStr(E,INDEX_SIZE_ERR));
      end else begin
        fail(getErrStr(E));
      end;
    end;
  end;
  if noex then fail('exception not raised');
end;

initialization
  datapath := getDataPath;
  CoInitialize(nil);

end.
