unit XPTest_idom2_TestMemoryLeaks;

interface

uses
  TestFrameWork,
  idom2,
  idom2_ext,
  domSetup,
  SysUtils,
  XPTest_idom2_Shared,
  ActiveX;

type 
  TTestMemoryLeaks = class(TTestCase)
  private
    impl: IDomImplementation;
    doc: IDomDocument;
    doc1: IDomDocument;
    mem: cardinal;
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
    procedure xsltTransformToString1000Times;
    procedure xsltTransformToDoc1000Times;
    procedure jkTestDocument;
    procedure jkTestElement;
    procedure jkNamedNodemap;
  end;

  // Call these functions 10000 times for stability test
  // Returns the number of tests, passed OK
function TestDocument(filename, vendorstr: string; testset: integer): integer;
function TestElement0(filename, vendorstr: string; TestSet: integer): integer;
function TestNamedNodemap(filename, vendorstr: string; TestSet: integer): integer;

  // miscanellous helper for the three functions above
function TestGDom3(Name, vendorstr: string; TestSet: integer): double;
function getDoc(filename, vendorstr: string; TestSet: integer = 0): IDomDocument;
function getEmptyDoc(vendorstr: string): IDomDocument;
function test(Name: string; testexpr: boolean): boolean;

implementation

uses
  ComObj,   // EOleException
  classes,  // TStringList
  Dialogs,  // ShowMessage;
  MicroTime;

var 
  TestsOk: integer;

procedure outLog(temp: string);
begin
end;

function test(Name: string; testexpr: boolean): boolean;
begin
  if testexpr then begin
    outLog(Name +' -> OK');
    inc(TestsOK);
  end else outLog('__' + Name +' => failed ');
  Result := testexpr;
end;

function getEmptyDoc(vendorstr: string): IDomDocument;
var
  dom: IDomImplementation;
begin
  dom := GetDom(vendorstr);
  Result := dom.createDocument('', '', nil);
end;

function getEmptyDoc1(vendorstr: string): IDomDocument;
var
  docbuilder: IDomDocumentBuilder;
begin
  docbuilder := (GetDocumentBuilderFactory(vendorstr)).newDocumentBuilder;
  Result := docbuilder.newDocument;
end;

function getDoc(filename, vendorstr: string; TestSet: integer = 0): IDomDocument;
var
  doc:         IDomDocument;
  FDomPersist: IDomPersist;
  ok:          boolean;
begin
  if (TestSet and 1) = 0 then doc := GetEmptyDoc(vendorstr)
  else doc := GetEmptyDoc1(vendorstr);
  (doc as IDomParseOptions).resolveExternals := True;
  FDomPersist := doc as IDomPersist;
  ok := FDomPersist.load(filename);
  if (TestSet and 1) = 1 then Test('IDomDocumentBuilder.NewDocument', ok);
  if not ok and (vendorstr = 'MSXML') then begin
    //outLog('ErrorCode: '+inttostr((doc as IDomParseError).errorCode));
    //outLog('ErrorLine: '+inttostr((doc as IDomParseError).line));
    //outLog('ErrorLinePos: '+inttostr((doc as IDomParseError).linePos));
  end;
  if ok then Result := doc 
  else Result := nil;
end;

function TestNamedNodemap(filename, vendorstr: string; TestSet: integer): integer;
var
  document: IDomDocument;
  documentElement: IDomElement;
  namedNodeMap: IDomNamedNodeMap;
  node, node1: IDomNode;
  dom2: boolean;
begin
  TestsOK := 0;
  dom2 := True;
  document := getDoc(filename, vendorstr);
  documentElement := document.documentElement;
  namednodemap := documentElement.attributes;
  if namednodemap <> nil then begin
    outlog('namedNodeMap.length: '+IntToStr(namedNodeMap.length));
    Inc(TestsOK);
  end else outlog('__namedNodeMap=NIL');
  documentElement := nil;
  node := document.createAttribute('age') as IDomNode;
  node.nodeValue := '13';
  node := namednodemap.setNamedItem(node);
  node := nil;

  node := namednodemap.getNamedItem('age');
  test('namedNodeMap.getNamedItem/setNamedItem', (node.nodeValue = '13'));

  node1 := document.createAttribute('sex') as IDomNode;
  node1.nodeValue := 'male';
  node1.nodeName;
  namednodemap.setNamedItem(node1);
  if node1 <> nil then begin
    test('namedNodeMap.setNamedItemII', (namedNodeMap[1].nodeValue = 'male'));
    node1 := namednodemap.removeNamedItem('sex');
  end else outLog('__namedNodeMap.setNamedItemII doesn''t work!');

  node := namednodemap.removeNamedItem('age');
  test('namedNodeMap.removeNamedItem', (namednodemap.length = 0));
  node := nil;
  namednodemap := nil;
  if dom2 then try
      namednodemap := document.documentElement.attributes;
      node := document.createAttributeNS('http://xmlns.4commerce.de/eva',
        'eva:age') as IDomNode;
      node.nodeValue := '13';
      namednodemap.setNamedItemNS(node);
      node := nil;
      node := namednodemap.getNamedItemNS('http://xmlns.4commerce.de/eva', 'age');
      test('namedNodeMap.getNamedItemNS/setNamedItemNS', (node.nodeValue = '13'));
      node := namednodemap.removeNamedItemNS('http://xmlns.4commerce.de/eva', 'age');
      test('namedNodeMap.removeNamedItemNS', (namednodemap.length = 0));
      node := nil;
      namednodemap := nil;
    except
      OutLog('__namedNodeMap.getNamedItemNS/setNamedItemNS doesn''t work!');
      OutLog('__namedNodeMap.removeNamedItemNS doesn''t work!');
    end;
  Result := TestsOK;
end;

function TestElement0(filename, vendorstr: string; TestSet: integer): integer;
var
  document: IDomDocument;
  element:  IDomElement;
  attr:     IDomAttr;
  nodelist: IDomNodeList;
  dom2:     boolean;
begin
  TestsOK := 0;
  document := getDoc(filename, vendorstr, TestSet);
  if (testset and 512) = 512 then dom2 := True 
  else dom2 := False;
  element := document.documentElement;
  test('element.tagName', (element.tagName = 'test'));

  element := nil;
  element := document.createElement('eee');
  attr := document.createAttribute('rrr');
  attr := element.setAttributeNode(attr);
  attr := nil;
  attr := document.createAttribute('rrrVX');
  attr.Value := 'hund';
  attr := element.setAttributeNode(attr);
  attr := nil;
  attr := element.getAttributeNode('rrr');
  //does getAttributNode retrieves a non-empty attribute?
  test('element.getAttributeNode/setAttributeNode', (attr <> nil));
  attr := nil;
  attr := element.getAttributeNode('rrrVX');
  //is the retrieved value correct?
  test('element.getAttributeNode/setAttributeNode2', (attr.Value = 'hund'));  //ok
  attr := nil;
  attr := document.createAttribute('rrrVX');  //ok
  attr.Value := 'hase';  //OK
  attr := element.setAttributeNode(attr);
  //does it overwrite the value of an existing attribute?
  test('element.getAttributeNode/setAttributeNode3', (attr.Value = 'hund'));
  attr := nil;
  attr := element.getAttributeNode('rrrVX');
  test('element.getAttributeNode/setAttributeNode4', (attr.Value = 'hase'));
  attr := nil;
  attr := nil;
  element := nil;

  //to do:
  //add a test, where the attribute das exist, before setAttribute is called
  if dom2 then begin
    element := document.createElement('ttt');
    attr := document.createAttributeNS('http://xmlns.4commerce.de/eva', 'eva:loop');
    attr := element.setAttributeNodeNS(attr);
    attr := nil;
    attr := element.getAttributeNodeNS('http://xmlns.4commerce.de/eva', 'loop');
    test('element.getAttributeNodeNS/setAttributeNodeNS', (attr <> nil));
    attr := nil;
    element := nil;
  end;

  attr := document.createAttribute('loop');
  element := document.createElement('iii');
  attr := element.setAttributeNode(attr);
  attr := nil;
  test('element.setAttributeNode', (element.hasAttribute('loop')));

  if dom2 then begin
    element.removeAttributeNS('http://xmlns.4commerce.de/eva', 'loop');
    test('element.removeAttributeNS',
    (not element.hasAttributeNS('http://xmlns.4commerce.de/eva', 'loop')));
    element := nil;
    // setAttributeNodeNS
    attr := document.createAttributeNS('http://xmlns.4commerce.de/eva', 'eva:loop');
    element := document.createElement('iii');
    attr := element.setAttributeNodeNS(attr);
    attr := nil;
    test('element.setAttributeNodeNS2',
    (element.hasAttributeNS('http://xmlns.4commerce.de/eva', 'loop')));
    element.removeAttributeNS('http://xmlns.4commerce.de/eva', 'loop');
    test('element.removeAttributeNS',
    (not element.hasAttributeNS('http://xmlns.4commerce.de/eva', 'loop')));
  end;
  element := nil;
  element := document.documentElement;
  nodelist := element.getElementsByTagName('sometag');
  test('element.getElementsByTagName', (nodelist <> nil));
  test('element.getElementsByTagName (length)', (nodelist.length = 1));
  nodelist := nil;
  element := nil;
  attr := document.createAttribute('nop');
  element := document.createElement('hub');
  try
    attr := element.setAttributeNode(attr);
    attr := element.getAttributeNode('nop');
    attr := element.removeAttributeNode(attr);
    test('element.removeAttributeNode', (not element.hasAttribute('hub')));
  except
    outLog('__element.removeAttributeNode doesn''t work!');
  end;
  attr := nil;
  element := nil;
  Result := TestsOK;
end;

procedure TestGDom3b(Name, vendorstr: string; TestSet: integer);
  // shall Test every Method of GDOM2

  procedure TestNode1(filename, vendorstr: string);
  var
    node, node1, docelement, childnode: IDomNode;
    nodeselect: IDomNodeSelect;
    i:          integer;
    document:   IDomDocument;
    temp:       string;
    //dom2: boolean;
  begin
    //if (testset and 512) = 512 then dom2:=true else dom2:=false;
    document := nil;
    document := getDoc(filename, vendorstr);
    node := document.documentElement as IDomNode;
    test('node.ownerDocument', (node.ownerDocument.nodeName = document.nodeName));
    node := nil;

    node := document.documentElement as IDomNode;
    test('node.nodeType (ELEMENT_NODE)', (node.nodeType = ELEMENT_NODE));
    node := nil;

    node := document as IDomNode;
    test('node.nodeType (DOCUMENT_NODE)', (node.nodeType = DOCUMENT_NODE));
    node := nil;

    //p=1
    node := document.documentElement as IDomNode;
    //FE: The following line causes a problem:
    //outlog(node.firstchild.nodeName);
    test('node.parentNode', (document.documentElement.firstChild.parentNode.nodeName =
      node.nodeName));
    node := nil;

    //p=1
    node := (document.documentElement as IDomNode);
    test('node.hasChildNodes', node.hasChildNodes);
    node := nil;

    //p=1
    node := (document.documentElement as IDomNode).firstChild;
    test('node.firstChild', (node <> nil));

    //p=1
    test('node.nodeName', (node.nodeName = 'sometag'));

    //p=1
    test('node.firstChild.hasChildNodes', node.hasChildNodes);

    //P=1
    for i := 0 to node.childNodes.length - 1 do begin
      if node.childNodes[i].nodeType = TEXT_NODE then begin
        test('node.nodeValue of TEXT_NODE (get)', (node.childNodes[i].nodeValue = 'abc'));
        node.childNodes[i].nodeValue := 'def';
        test('node.nodeValue of TEXT_NODE (set)', (node.childNodes[i].nodeValue = 'def'));
      end;
    end;
    node := nil;

    //p=1
    node := document.documentElement.firstChild;
    node := node.nextSibling;
    test('node.nextSibling', (node <> nil));

    //p=1
    node := node.previousSibling;
    test('node.previousSibling', (node <> nil));
    node := nil;

    //p=1
    node := document.documentElement.firstChild.lastChild;
    test('node.lastChild', (node <> nil));
    node := nil;

    document := nil;
    document := getDoc(filename, vendorstr);

    // supported by LIBXML and MSXML but not by W3C
    nodeselect := document.documentElement as IDomNodeSelect;
    node := nodeselect.selectNode('sometag/@name');
    if node <> nil then test('IDomNodeSelect.selectNode',
      (node.nodeValue = '1st child of DocumentElement'))
    else outlog('__IDomNodeSelect.selectNode => failed');
    node := nil;
    nodeselect := nil;

    //p=1
    node := document.documentElement.firstChild.cloneNode(True);
    test('node.cloneNode', (node <> nil));

    //p=1
    docelement := document.documentElement;
    node1 := docelement.firstChild;
    node := docelement.insertBefore(node, node1);
    test('node.insertBefore', (node <> nil));
    test('node.clone & insert', (node.nodeName = 'sometag'));
    node := nil;
    node1 := nil;
    docelement := nil;

    //p=1
    node := document.documentElement.removeChild(document.documentElement.firstChild);
    test('node.removeChild', (node <> nil));

    //p=1
    node := (document.documentElement as IDomNode).appendChild(node);
    test('node.appendChild', (node <> nil));
    //outlog('___'+node.nodeName);
    test('node.remove & append', (node.nodeName = 'sometag'));
    node := nil;

    try
      //p=2
      node := document.documentElement.lastChild.cloneNode(True);
      node := document.documentElement.replaceChild(node,
        document.documentElement.firstChild);
      test('node.replaceChild', (node <> nil));
      test('node.clone & replace', (node.nodeName = 'sometag'));
      node := nil;
    except
      outLog('__node.replaceChild doesn''t work!');
      outLog('__node.clone & replace doesn''t work!');
    end;

    test('node.isSupported "Core"', (document.documentElement.isSupported('Core', '2.0')));
    test('node.isSupported "XML"', (document.documentElement.isSupported('XML', '2.0')));

    try
      //p=2
      // testing normalize
      temp := '';
      node := document.documentElement as IDomNode;
      for i := 0 to node.firstChild.childNodes.length - 1 do begin
        if node.firstChild.childNodes[i].nodeType = TEXT_NODE then begin
          childnode := node.firstChild.childNodes[i].cloneNode(True);
          Break;
        end;
      end;
      node.firstChild.appendChild(childnode);
      //node.firstChild.appendChild(childnode);
      for i := 0 to node.firstChild.childNodes.length - 1 do begin
        if node.firstChild.childNodes[i].nodeType = TEXT_NODE then begin
          temp := temp + node.firstChild.childNodes[i].nodeValue;
        end;
      end;
      node.firstChild.normalize;
      for i := 0 to node.firstChild.childNodes.length - 1 do begin
        if node.firstChild.childNodes[i].nodeType = TEXT_NODE then begin
          test('node.normalize', node.firstChild.childNodes[i].nodeValue = temp);
          //outLog('text after normalize: '+node.firstChild.childNodes[i].nodeValue);
        end;
      end;
    except
      outLog('__node.normalize doesn''t work!');
    end;
  end;

  procedure TestNode2(document: IDomDocument; vendorstr: string);
  var
    node: IDomNode;
    //dom2: boolean;
  begin
    //if (testset and 512) = 512 then dom2:=true else dom2:=false;
    node := document.createElement('urgs') as IDomNode;
    test('node.prefix', (node.prefix = ''));
    test('node.namespaceUri', (node.namespaceURI = ''));
    test('node.localName', (node.localName = ''));
    // see W3C.ORG: if using createElement instead of createElementNS localName has to return null
    node := nil;

    node := document.createElementNS('http://xmlns.4commerce.de/eva',
      'eva:urgs') as IDomNode;
    test('node.prefix (NS)', (node.prefix = 'eva'));
    test('node.namespaceUri (NS)', (node.namespaceURI = 'http://xmlns.4commerce.de/eva'));
    test('node.localName (NS)', (node.localName = 'urgs'));
    node := nil;
  end;

  procedure TestDocType(filename, vendorstr: string);
  var
    document:     IDomDocument;
    documentType: IDomDocumentType;
    namedNodeMap: IDomNamedNodeMap;
    temp:         string;
  begin
    document := getDoc(filename, vendorstr);
    // testing documenttype
    documenttype := document.doctype;
    test('document.docType', (documenttype <> nil));
    try
      test('documentType.internalSubset', (documenttype.internalSubset =
        '<!DOCTYPE test SYSTEM "test.dtd">'));
    except
      outLog('__documentType.internalSubset doesn''t work!');
    end;
    test('documentType.name', (documenttype.Name = 'test'));
    if vendorstr <> 'LIBXML' then begin
      namednodemap := documenttype.entities;
      test('documentType.entities', (namednodemap <> nil));
      test('entity.length', (namednodemap.length = 2));
      test('entity.notationName', ((namednodemap[0] as IDomEntity).notationName = 'type2'));
      temp := ((namednodemap[0] as IDomEntity).systemId);
      test('entity.systemId', temp = 'file.type2');
      test('entity.publicId', ((namednodemap[0] as IDomEntity).publicId = ''));
      namednodemap := nil;
      namednodemap := documenttype.notations;
      test('documentType.notations', (namednodemap <> nil));
      outlog('documentType.notations.length: ' + IntToStr(namednodemap.length));
      test('notation.publicId', ((namednodemap[0] as IDomNotation).publicId = ''));
      test('notation.systemId', ((namednodemap[0] as IDomNotation).systemId = 'program2'));
      namednodemap := nil;
      documenttype := nil;
    end;
    // end
    document := nil;

    // testing documenttype, part II
    document := getDoc(filename, vendorstr);
    try
      documenttype := document.domImplementation.createDocumentType
        ('http://xmlns.4commerce.de/eva', 'a', 'test');
      test('documentType.name', (documenttype.Name = 'http://xmlns.4commerce.de/eva'));

      //outLog('___'+documenttype.internalSubset);

      test('documentType.systemId', (documenttype.systemId = 'test'));
      test('documentType.publicId', (documenttype.publicId = 'a'));
      documenttype := nil;
    except
      outLog('__documentType.systemId doesn''t work!');
      outLog('__documentType.publicId doesn''t work!');
    end;
  end;

  procedure TestDomImpl(filename, vendorstr: string);
  var
    document:     IDomDocument;
    documentType: IDomDocumentType;
  begin
    document := getDoc(filename, vendorstr);
    try
      documenttype := document.domImplementation.createDocumentType
        ('http://xmlns.4commerce.de/eva', '', 'test');
      test('domImplementation.createDocument (NS)',
      (document.domImplementation.createDocument('http://xmlns.4commerce.de/eva',
        'eva:test', documenttype) <> nil));
      documenttype := nil;
    except
      outLog('__domImplementation.createDocument (NS) doesn''t work!');
    end;
    try
      documenttype := document.domImplementation.createDocumentType
        ('http://xmlns.4commerce.de/eva', '', '');
      test('domImplementation.createDocumentType', (documenttype <> nil));
      documenttype := nil;
    except
      outLog('__domImplementation.createDocumentType doesn''t work!');
    end;
    test('domImplementation.hasFeature', document.domImplementation.hasFeature('CORE', '2.0'));
  end;

  procedure TestCDATA_PI_Text(filename, vendorstr: string);
  var
    document: IDomDocument;
    cdata:    IDomCDataSection;
    processingInstruction: IDomProcessingInstruction;
    Text:     IDomText;
  begin
    // testing character data
    document := getDoc(filename, vendorstr);
    cdata := document.createCDATASection('yyy');
    test('document.createCDATASection', (cdata <> nil));
    test('characterData.data (get)', (cdata.Data = 'yyy'));
    test('characterData.length', (cdata.length = 3));
    cdata.Data := 'zzz';
    test('characterData.data (set)', (cdata.Data = 'zzz'));
    cdata.appendData('aaa');
    test('characterData.appendData', (cdata.Data = 'zzzaaa'));
    cdata.deleteData(3,3);
    test('characterData.deleteData', (cdata.Data = 'zzz'));
    cdata.insertData(1,'aaa');
    test('characterData.insertData', (cdata.Data = 'zaaazz'));
    cdata.replaceData(1,3,'bbb');
    test('characterData.replaceData', (cdata.Data = 'zbbbzz'));
    cdata := nil;

    // testing processingInstruction

    processinginstruction := document.createProcessingInstruction('abc', 'def');
    test('processingInstruction.target', (processinginstruction.target = 'abc'));
    test('processingInstruction.data', (processinginstruction.Data = 'def'));
    //todo: test pi.setdata
    processinginstruction := nil;

    // testing text
    try
      // testing text
      Text := document.createTextNode('blabla');
      Text := Text.splitText(3);
      test('text.splitText', (Text.Data = 'bla'));
      Text := nil;
    except
      OutLog('__text.splitText doesn''t work!');
    end;
  end;

  procedure TestElement1(filename, vendorstr: string);
  var
    document: IDomDocument;
    element:  IDomElement;
    attlist:  IDomNamedNodeMap;
    node:     IDomNode;
    attr:     IDomAttr;
    dom2:     boolean;
  begin
    if (testset and 512) = 512 then dom2 := True 
    else dom2 := False;
    document := getDoc(filename, vendorstr);
    element := document.documentElement.firstChild as IDomElement;
    test('element-interface of Node', (element <> nil));
    test('element.tagName', (element.tagName = 'sometag'));
    element := nil;

    element := document.documentElement.firstChild as IDomElement;
    element.setAttribute('test', 'hallo welt');
    test('element.getAttribute/setAttribute', (element.getAttribute('test') = 'hallo welt'));
    element := nil;

    if dom2 then begin
      element := document.documentElement.firstChild as IDomElement;
      element.setAttributeNS('http://xmlns.4commerce.de/eva', 'eva:sulze', 'wabbelig');
      test('element.getAttributeNS/setAttributeNS',
      (element.getAttributeNS('http://xmlns.4commerce.de/eva', 'sulze') = 'wabbelig'));
    end;

    element := nil;
    attlist := document.documentElement.firstChild.attributes;

    test('namedNodeMap', (attlist <> nil));
    if dom2 then test('namedNodeMap.length', (attlist.length = 3))
    else test('namedNodeMap.length', (attlist.length = 2));
    test('namedNodeMap.item[i]', (attlist.item[0].nodeName = 'name'));
    attlist := document.documentElement.firstChild.attributes;
    node := attlist.item[0];
    attlist := nil;
    test('namedNodeMap.item[i].nodeType = ATTRIBUTE_NODE (attributes)',
    (node.nodeType = ATTRIBUTE_NODE));
    attr := node as IDomAttr;
    node := nil;
    test('attribute-interface of node', (attr <> nil));
    test('attribute.name', (attr.Name = 'name'));
    test('attribute.value', (attr.Value = '1st child of DocumentElement'));
    test('attribute.specified', attr.specified);
    test('attribute.nodeType = ATTRIBUTE_NODE', (attr.nodeType = ATTRIBUTE_NODE));
    attr := nil;
    element := document.documentElement.firstChild as IDomElement;
    test('element.hasAttribute', element.hasAttribute('name'));
    element.removeAttribute('name');
    test('element.removeAttribute', (not element.hasAttribute('name')));
    element := nil;

    if dom2 then begin
      attr := document.createAttributeNS('http://xmlns.4commerce.de/eva', 'eva:name1');
      element := document.documentElement;
      element.setAttributeNodeNS(attr);
      attr := nil;

      test('element.hasAttributeNS/setAttributeNodeNS',
        element.hasAttributeNS('http://xmlns.4commerce.de/eva', 'name1'));
      element := nil;
    end;
  end;
var
  filename:    string;
  FDomPersist: IDomPersist;
  document:    IDomDocument;
  element:     IDomElement;
  node:        IDomNode;
  attlist:     IDomNamedNodeMap;
  //documentElement: IDomNode;
  stringlist: TStringList;
  //temp: string;
  dom2: boolean;
begin
  // init

  //Form1.Memo1.Lines.Clear;
  TestsOK := 0; //Number of passed Tests
  stringlist := TStringList.Create;
  filename := '..\data\' + Name;
  if (testset and 512) = 512 then dom2 := True 
  else dom2 := False;

  // testing document
  if (testset and 2) = 2 then TestDocument(filename, vendorstr, testset);

  // testing element
  if (testset and 4) = 4 then begin
    TestElement0(filename, vendorstr, testset);
    TestElement1(filename, vendorstr);
  end;

  // testing node, part 1
  if (testset and 8) = 8 then begin
    TestNode1(filename, vendorstr);
    if dom2 then TestNode2(document, vendorstr);
  end;

  // testing documentType
  if (testset and 16) = 16 then TestDocType(filename, vendorstr);

  // testing domImpl
  if (testset and 32) = 32 then TestDomImpl(filename, vendorstr);

  // testing domImpl
  if (testset and 64) = 64 then TestCDATA_PI_Text(filename, vendorstr);

  // testing namedNodeMap
  if (testset and 128) = 128 then TestNamedNodemap(filename, vendorstr, testset);

  //document.documentElement.setAttributeNS('http://xmlns.4commerce.de/eva','eva:test','huhu');

  // testing IDomPersist
  if (testset and 256) = 256 then begin
    document := nil;
    document := getDoc(filename, vendorstr, TestSet);
    FDomPersist := document as IDomPersist;
    FDomPersist.save('..\data\saved.xml');
    //todo: test .xml with large xml-file
    //outLog(FDomPersist.xml);
    FDomPersist := nil;

    document := getEmptyDoc(vendorstr);
    (document as IDomParseOptions).validate := False;
    //(document as IDomPersist).loadxml('<?xml version="1.0" encoding="iso-8859-1"?><aaa />');
    (document as IDomPersist).loadxml('<?xml version="1.0" ?><aaa />');
    if document.documentElement <> nil then test('IDomPersist.loadxml',
      (document.documentElement.nodeName = 'aaa'))
    else outLog('__ERROR__ IDomPersist.loadxml => failed');
    document := nil;
  end;

  // --- end of tests, beautify results ---

  stringlist.Clear;
  //stringlist.AddStrings(Form1.Memo1.Lines);
  stringlist.Sort;
  //Form1.Memo1.Lines.Clear;
  //Form1.Memo1.Lines.AddStrings(stringlist);

  // --- free all ---

  stringlist.Free;
  attlist := nil;
  node := nil;
  element := nil;
  FDomPersist := nil;
  document := nil;
end;

function TestGDom3(Name, vendorstr: string; TestSet: integer): double;
var
  testCount: integer;
  dom2:      boolean;
begin
  StartTimer;
  TestGdom3b(Name, vendorstr, TestSet);
  Result := EndTime;
  outLog('');
  outLog('Number of tests passed OK:  ' + IntToStr(TestsOK));
  //testCount:=115-22-13-16-24-6-14-3-11-5-1;
  testCount := 0;
  if (testset and 512) = 512 then dom2 := True 
  else dom2 := False;

  if (TestSet and 1) = 1 then inc(testCount);
  if (TestSet and 2) = 2 then if dom2 then testCount := testCount + 22
    else testCount := testCount + 18;
  if (TestSet and 4) = 4 then if dom2 then testCount := testCount + 13 + 16
    else testCount := testCount + 13 + 16 - 6;
  if (TestSet and 8) = 8 then if dom2 then testCount := testCount + 25 + 6
    else testCount := testCount + 25;
  if (TestSet and 16) = 16 then testCount := testCount + 14;
  if (TestSet and 32) = 32 then testCount := testCount + 3;
  if (TestSet and 64) = 64 then testCount := testCount + 11;
  if (TestSet and 128) = 128 then testCount := testCount + 5;
  if (TestSet and 256) = 256 then testCount := testCount + 1;

  outLog('Number of tests total:    ' + IntToStr(TestCount));
  //outLog('doccount='+inttostr(doccount));
  //outLog('nodecount='+inttostr(nodecount));
  //outLog('elementcount='+inttostr(elementcount));
end;

function TestDocument(filename, vendorstr: string; testset: integer): integer;
var
  element:  IDomElement;
  nodelist: IDomNodeList;
  dom:      IDomImplementation;
  cdata:    IDomCDATASection;
  comment:  IDomComment;
  documentfragment: IDomDocumentFragment;
  entityreference: IDomEntityReference;
  processinginstruction: IDomProcessingInstruction;
  Text:     IDomText;
  attr:     IDomAttr;
  node:     IDomNode;
  dom2:     boolean;
  document: IDomDocument;
begin
  TestsOK := 0;
  Result := 0;
  if (testset and 512) = 512 then dom2 := True 
  else dom2 := False;
  document := getDoc(filename, vendorstr, TestSet);
  //if (testset and 512) = 512 then dom2:=true else dom2:=false;
  test('document', (document <> nil));
  if document = nil then exit;

  //p=1
  element := document.documentElement;
  test('document.documentElement', (element <> nil));
  element := nil;

  //p=1
  node := document.createElement('abc');
  test('document.createElement', (node <> nil));
  test('document.createElement (nodeName)', (node.nodeName = 'abc'));

  if dom2 then begin
    //p=1
    node := document.createElementNS('http://xmlns.4commerce.de/eva', 'eva:abc1');
    test('document.createElementNS', (node <> nil));
    test('document.createElementNS (nodeName)', (node.nodeName = 'eva:abc1'));
  end;

  //p=1
  attr := document.createAttribute('name');
  test('document.createAttribute', (attr <> nil));
  test('document.createAttribute (name)', (attr.Name = 'name'));

  //p=1
  if dom2 then begin
    attr := document.createAttributeNS('http://xmlns.4commerce.de/eva', 'eva:name1');
    test('document.createAttributeNS', (attr <> nil));
    test('document.createAttributeNS (name)', (attr.Name = 'eva:name1'));
  end;

  //p=1
  Text := document.createTextNode('eee');
  test('document.createTextNode', (Text <> nil));
  test('document.createTextNode (data)', (Text.Data = 'eee'));
  Text := nil;


  document.documentElement.appendChild(node);
  node := nil;

  //p=2
  if dom2 then begin
    nodelist := document.getElementsByTagNameNS('http://xmlns.4commerce.de/eva', 'abc1');
    if nodelist <> nil then test('document.getElementsByTagNameNS (length)',
      (nodelist.length = 1))
    else outLog('__document.getElementsByTagNameNS (length) doesn''t work!');
    nodelist := nil;
    //p=2
    nodelist := document.documentElement.getElementsByTagNameNS('http://xmlns.4commerce.de/eva',
      'abc1');
    if nodelist <> nil then test('element.getElementsByTagNameNS (length)',
      (nodelist.length = 1))
    else outLog('__element.getElementsByTagNameNS (length) doesn''t work');
    nodelist := nil;
  end;

  //p=2
  nodelist := document.getElementsByTagName('sometag');
  if nodelist <> nil then begin
    test('document.getElementsByTagName', (nodelist <> nil));
    test('document.getElementsByTagName (length)', (nodelist.length = 1));
  end else begin
    outLog('__document.getElementsByTagName doesn''t work!');
  end;
  nodelist := nil;

  //p=2
  dom := document.domImplementation;
  test('document.domImplementation', (dom <> nil));
  dom := nil;

  //p=2
  cdata := document.createCDATASection('zzz');
  test('document.createCDATASection', (cdata <> nil));
  cdata := nil;

  //p=2
  try
    comment := document.createComment('xxx');
    test('document.createComment', (comment <> nil));
    comment := nil;
  except
    outLog('__document.createComment doesn''t work!');
  end;

  //p=3
  try
    processinginstruction := document.createProcessingInstruction('qqq', 'www');
    test('document.createProcessingInstruction', (processinginstruction <> nil));
    processinginstruction := nil;
  except
    outLog('__document.createProcessingInstruction doesn''t work!');
  end;

  //p=3
  documentfragment := document.createDocumentFragment;
  test('document.createDocumentFragment', (documentfragment <> nil));
  documentfragment := nil;

  if vendorstr <> 'LIBXML' then begin
    //p=3
    entityreference := document.createEntityReference('iii');
    test('document.createEntityReference', (entityreference <> nil));
    entityreference := nil;
  end else begin
    outLog('__document.createEntityReference doesn''t work!');
  end;
  Result := TestsOK;
end;

{ TTestMemoryLeaks }

procedure TTestMemoryLeaks.SetUp;
begin
  inherited;
  mem := GetHeapStatus.TotalAllocated;
  impl := DomSetup.getCurrentDomSetup.getDocumentBuilder.domImplementation;
  doc := impl.createDocument('', '', nil);
  (doc as IDomPersist).loadxml(xmlstr);
  doc1 := impl.createDocument('', '', nil);
  (doc1 as IDomPersist).loadxml(xmlstr1);
end;

procedure TTestMemoryLeaks.TearDown;
var
  delta: cardinal;
begin
  doc := nil;
  doc1 := nil;
  check(GetDoccount(impl) = 0,'doccount<>0');
  impl := nil;
  delta := GetHeapStatus.TotalAllocated - mem;
  check(delta < 10000,'Memory leak, delta= ' + IntToStr(delta));
  inherited;
end;

procedure TTestMemoryLeaks.createElement10000Times;
var
  i: integer;
begin
  for i := 0 to 10000 do doc.createElement('test');
end;

procedure TTestMemoryLeaks.AppendElement10000Times;
var
  i:    integer;
  node: IDomNode;
begin
  for i := 0 to 5000 do begin
    node := (doc.createElement('test') as IDomNode);
    doc.documentElement.appendChild(node);
  end;

  for i := 0 to 5000 do begin
    node := (doc.createElement('test') as IDomNode);
    doc.documentElement.appendChild(node);
  end;
  node := nil;
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
  for i := 0 to 2000 do doc.createAttributeNS('http://xmlns.4commerce.de/eva', 'eva:name1');
end;

procedure TTestMemoryLeaks.SetAttributeNode10000Times;
var
  i:    integer;
  attr: IDomAttr;
begin
  for i := 0 to 10000 do begin
    attr := doc.createAttribute('test');
  end;
end;

procedure TTestMemoryLeaks.SetAttributeNodes5000Times;
var
  i:       integer;
  attr:    IDomAttr;
  element: IDomElement;
begin
  for i := 0 to 5000 do begin
    attr := doc.createAttribute('test' + IntToStr(i));
    element := doc.documentElement;
    element.setAttributeNode(attr);
  end;
end;

procedure TTestMemoryLeaks.SetAttributeNodesReplace10000Times;
var
  i:    integer;
  attr: IDomAttr;
begin
  for i := 0 to 10000 do begin
    attr := doc.createAttribute('test');
    doc.documentElement.setAttributeNode(attr);
  end;
end;

procedure TTestMemoryLeaks.jkTestElement;
var
  TestSet: integer;
  TestsOK: integer;
  i, j:    integer;
  temp:    string;
begin
  Status('Be patient...');
  temp := includetrailingpathdelimiter(datapath);
  TestSet := 0;
  for j := 1 to 10 do begin
    for i := 1 to 100 do begin
      TestsOK := TestElement0(temp + 'test.xml', domvendor, TestSet);
      Check((TestsOK >= 1), (IntToStr(1 - TestsOK) + ' Tests failed!'));
    end;
  end;
end;

procedure TTestMemoryLeaks.ElementAttribute10000Times;
var
  attr:    IDomAttr;
  element: IDomElement;
  i:       integer;
begin
  for i := 1 to 10000 do begin
    attr := doc.createAttribute('loop');
    element := doc.createElement('iii');
    attr := element.setAttributeNode(attr);
    attr := nil;
    //test('element.setAttributeNode',(element.hasAttribute('loop')));
    element.hasAttribute('loop');
    element := nil;
  end;
end;

procedure TTestMemoryLeaks.jkNamedNodemap;
var
  TestSet: integer;
  TestsOK: integer;
  i, j:    integer;
  temp:    string;
begin
  Status('Be patient...');
  temp := includetrailingpathdelimiter(datapath);
  TestSet := 0;
  for j := 1 to 10 do begin
    for i := 1 to 100 do begin
      TestsOK := TestNamedNodemap(temp + 'test.xml', domvendor, TestSet);
      Check((TestsOK >= 6), (IntToStr(6 - TestsOK) + ' Tests failed!')); //15
    end;
  end;
end;

procedure TTestMemoryLeaks.jkTestDocument;
var
  TestSet: integer;
  TestsOK: integer;
  i, j:    integer;
  temp:    string;
begin
  temp := includetrailingpathdelimiter(datapath);
  TestSet := 0;
  Status('Be patient...');
  for j := 1 to 10 do begin
    for i := 1 to 100 do begin
      TestsOK := TestDocument(temp + 'test.xml', domvendor, TestSet);
      Check((TestsOK >= 15), (IntToStr(15 - TestsOK) + ' Tests failed!')); //15
    end;
  end;
end;

procedure TTestMemoryLeaks.xsltTransformToString1000Times;
var
  Text:     widestring;
  i:        integer;
  xml:      IDomDocument;
  xsl:      IDomDocument;
  xnode:    IDomNode;
  snode:    IDomNode;
  persist:  IDomPersist;
  delement: IDomElement;
  exNode:   IDomNodeExt;
begin
  for i := 1 to 1000 do begin
    // apply a stylesheet that produces html-output
    impl := DomSetup.getCurrentDomSetup.getDocumentBuilder.domImplementation;
    xml := impl.createDocument('', '', nil);
    persist := xml as IDomPersist;
    persist.loadxml(xmlstr);
    persist := nil;
    xsl := impl.createDocument('', '', nil);
    persist := xsl as IDomPersist;
    persist.loadxml(xslstr2);
    persist := nil;
    xnode := xml as IDomNode;
    delement := xsl.documentElement;
    snode := delement as IDomNode;
    exNode := xnode as IDomNodeExt;
    exNode.transformNode(snode, Text);
    Text := Unify(Text,False);
    check(Text = outstr1, 'wrong content');
    Text := '';
  end;
end;

procedure TTestMemoryLeaks.xsltTransformToDoc1000Times;
var
  Text:     widestring;
  i:        integer;
  xml:      IDomDocument;
  xsl:      IDomDocument;
  xnode:    IDomNode;
  snode:    IDomNode;
  persist:  IDomPersist;
  delement: IDomElement;
  exNode:   IDomNodeExt;
begin
  for i := 1 to 1000 do begin
    // apply a stylesheet that produces html-output
    xml := impl.createDocument('', '', nil);
    persist := xml as IDomPersist;
    persist.loadxml(xmlstr);
    persist := nil;
    xsl := impl.createDocument('', '', nil);
    persist := xsl as IDomPersist;
    persist.loadxml(xslstr2);
    persist := nil;
    xnode := xml as IDomNode;
    doc:=xnode.ownerDocument;
    delement := xsl.documentElement;
    snode := delement as IDomNode;
    exNode := xnode as IDomNodeExt;
    exNode.transformNode(snode, doc);
    Text := (doc as IDompersist).xml;
    Text := Unify(Text,False);
    check(Text = outstr1, 'wrong content');
    Text := '';
  end;
end;

end.
