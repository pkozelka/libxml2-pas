unit XPTest_idom2_TestDomExceptions;

interface

uses
  TestFrameWork,
  //libxmldom,
  idom2,
  domSetup,
  SysUtils,
  XPTest_idom2_Shared,
  ActiveX;

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
    pci: IDomProcessingInstruction;
    entref: IDomEntityReference;
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
  attr := nil;
  node := nil;
  select := nil;
  nodelist := nil;
  pci := nil;
  entref := nil;
  doc := nil;
  doc1 := nil;
  impl := nil;
  inherited;
end;

function TTestDomExceptions.getFqname: string;
begin
  if prefix = '' then Result := Name 
  else Result := prefix + ':' + Name;
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
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, 'wrong exception raised');
      end else begin
        fail('wrong exception: ' + E.Message);
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
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, 'wrong exception raised');
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
        check((E as EDomException).code = HIERARCHY_REQUEST_ERR, 'wrong exception raised');
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
        check((E as EDomException).code = WRONG_DOCUMENT_ERR, 'wrong exception raised');
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
        check((E as EDomException).code = INVALID_CHARACTER_ERR, 'wrong exception raised');
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
        check((E as EDomException).code = INVALID_CHARACTER_ERR, 'wrong exception raised');
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
        check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
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
        check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
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
        check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
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
        check((E as EDomException).code = NAMESPACE_ERR, 'wrong exception raised');
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

initialization
  datapath := getDataPath;
  CoInitialize(nil);

finalization
  //CoUnInitialize;
end.
