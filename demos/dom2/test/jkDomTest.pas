unit jkDomTest;

{
   ------------------------------------------------------------------------------
   This unit shall test every DOM2 method of a xmldom.pas compatible
   DOM-Implementation for Object-Pascal.

   Author:
   Jan Kubatzki (jkubatzki@4commerce.de)
   Maintainer:
   Uwe Fechner (ufechner@4commerce.de)

   Copyright:
   4commerce technologies AG
        Kamerbalken 10-14
        22525 Hamburg, Germany

    Published under a double license:
    a) the GNU Library General Public License:
       http://www.gnu.org/copyleft/lgpl.html
    b) the Mozilla Public License:
       http://www.mozilla.org/MPL/MPL-1.1.html
   ------------------------------------------------------------------------------
}

interface
{$DEFINE NodeTypeInteger}

uses xdom2,libxmldom{,msxml_impl}; // IDOMIMplementation, IDOMDocument

function TestGDom3(name,vendorstr:string;TestSet:integer):double;
function getDoc(filename,vendorstr: string;TestSet:integer=0): IDOMDocument;
function getEmptyDoc(vendorstr: string): IDomDocument;
function test(name: string; testexpr: boolean): boolean;

// Call this function 10000 times for stability test
procedure TestDocument(filename,vendorstr:string;testset: integer);
procedure TestElement0(filename,vendorstr:string;TestSet: integer);

implementation

uses conapp,   // outLog
     SysUtils, // Format
     ComObj,   // EOleException
     classes,  // TStringList
     Dialogs,  // ShowMessage;
     unit1,    // Form1
     MicroTime;

var TestsOk: integer;

function test(name: string; testexpr: boolean): boolean;
begin
  if testexpr then begin
    outLog(name+' -> OK');
    inc(TestsOK);
  end
  else outLog('__'+name+' => failed ');
  result := testexpr;
end;

function getEmptyDoc(vendorstr: string): IDomDocument;
var
  dom: IDomImplementation;
begin
  dom := GetDom(vendorstr);
  result := dom.createDocument('','',nil);
end;

function getEmptyDoc1(vendorstr: string): IDomDocument;
var
  docbuilder: IDOMDocumentBuilder;
begin
  docbuilder:=(GetDocumentBuilderFactory(vendorstr)).newDocumentBuilder;
  result:=docbuilder.newDocument;
end;

function getDoc(filename, vendorstr: string;TestSet:integer=0): IDomDocument;
var
  doc: IDomDocument;
  FDomPersist: IDomPersist;
  ok: boolean;
begin
  if not fileexists(filename)
    then begin
      Outlog('File: '+filename+' doesn''t exist');
      result:=nil;
      exit
    end;
  if (TestSet and 1) = 0
    then doc:=GetEmptyDoc(vendorstr)
    else doc:=GetEmptyDoc1(vendorstr);
  (doc as IDOMParseOptions).validate := true; // we want to use a dtd
  (doc as IDOMParseOptions).resolveExternals := true;
  FDomPersist := doc as IDomPersist;
  ok := FDomPersist.load(filename);
  
  if (TestSet and 1) =1
    then Test('IDomDocumentBuilder.NewDocument',ok);
  if not ok and (vendorstr='MSXML') then begin
    //outLog('ErrorCode: '+inttostr((doc as IDOMParseError).errorCode));
    //outLog('ErrorLine: '+inttostr((doc as IDOMParseError).line));
    //outLog('ErrorLinePos: '+inttostr((doc as IDOMParseError).linePos));
  end;
  if ok then result := doc else result := nil;
end;

procedure TestDocument(filename,vendorstr:string;testset: integer);
var
  element: IDOMElement;
  nodelist: IDOMNodeList;
  dom: IDOMImplementation;
  cdata: IDOMCDATASection;
  comment: IDOMComment;
  documentfragment: IDOMDocumentFragment;
  entityreference: IDOMEntityReference;
  processinginstruction: IDOMProcessingInstruction;
  text: IDOMText;
  attr: IDOMAttr;
  node: IDOMNode;
  dom2: boolean;
  document: IDOMDocument;
begin
  if (testset and 512) = 512 then dom2:=true else dom2:=false;
  document := getDoc(filename,vendorstr);
  if document=nil then exit;
  if (testset and 512) = 512 then dom2:=true else dom2:=false;
  test('document',(document <> nil));

  //p=1
  element := document.documentElement;
  test('document.documentElement',(element <> nil));
  element := nil;

  //p=1
  node := document.createElement('abc');
  test('document.createElement',(node <> nil)) ;
  test('document.createElement (nodeName)',(node.nodeName = 'abc')) ;

  if dom2 then begin
    //p=1
    node := document.createElementNS('http://xmlns.4commerce.de/eva','eva:abc1');
    test('document.createElementNS',(node <> nil)) ;
    test('document.createElementNS (nodeName)',(node.nodeName = 'eva:abc1')) ;
  end;

  //p=1
  attr := document.createAttribute('name');
  test('document.createAttribute',(attr <> nil)) ;
  test('document.createAttribute (name)',(attr.name ='name')) ;

  //p=1
  if dom2 then begin
    attr := document.createAttributeNS('http://xmlns.4commerce.de/eva','eva:name1');
    test('document.createAttributeNS',(attr <> nil)) ;
    test('document.createAttributeNS (name)',(attr.name ='eva:name1')) ;
  end;

  //p=1
  text := document.createTextNode('eee');
  test('document.createTextNode',(text <> nil));
  test('document.createTextNode (data)',(text.data ='eee'));
  text := nil;

  document.documentElement.appendChild(node);
  node := nil;

  //p=2
  if dom2 then begin
    nodelist := document.getElementsByTagNameNS('http://xmlns.4commerce.de/eva','abc1');
    if nodelist<>nil
      then test('document.getElementsByTagNameNS (length)',(nodelist.length = 1))
      else outLog('__document.getElementsByTagNameNS (length) doesn''t work!');
    nodelist := nil;
    //p=2
    nodelist := document.documentElement.getElementsByTagNameNS('http://xmlns.4commerce.de/eva','abc1');
    if nodelist <> nil
      then test('element.getElementsByTagNameNS (length)',(nodelist.length = 1))
      else outLog('__element.getElementsByTagNameNS (length) doesn''t work');
    nodelist := nil;
  end;

  //p=2
  nodelist := document.getElementsByTagName('sometag');
  if nodelist <> nil then begin
    test('document.getElementsByTagName',(nodelist <> nil));
    test('document.getElementsByTagName (length)',(nodelist.length = 1)) ;
  end else begin
    outLog('__document.getElementsByTagName doesn''t work!');
  end;
  nodelist := nil;

  //p=2
  dom := document.domImplementation;
  test('document.domImplementation',(dom <> nil)) ;
  dom := nil;

  //p=2
  cdata := document.createCDATASection('zzz');
  test('document.createCDATASection',(cdata <> nil));
  cdata := nil;

  //p=2
  try
    comment := document.createComment('xxx');
    test('document.createComment',(comment <> nil));
    comment := nil;
  except
    outLog('__document.createComment doesn''t work!');
  end;

  //p=3
  try
    processinginstruction := document.createProcessingInstruction('qqq','www');
    test('document.createProcessingInstruction',(processinginstruction <> nil));
    processinginstruction := nil;
  except
    outLog('__document.createProcessingInstruction doesn''t work!');
  end;

  //p=3
  documentfragment := document.createDocumentFragment;
  test('document.createDocumentFragment',(documentfragment <> nil));
  documentfragment := nil;

  //p=3
  entityreference := document.createEntityReference('iii');
  test('document.createEntityReference',(entityreference <> nil));
  entityreference := nil;

end;

procedure TestElement0(filename,vendorstr:string;TestSet: integer);
var
  document:IDOMDocument;
  element: IDOMElement;
  attr: IDOMAttr;
  nodelist: IDOMNodeList;
  dom2: boolean;
begin
  document := getDoc(filename,vendorstr);
  if document=nil then exit;
  if (testset and 512) = 512 then dom2:=true else dom2:=false;
  element := document.documentElement;
  test('element.tagName',(element.tagName = 'test')) ;

  element := nil;
  element := document.createElement('eee');
  attr := document.createAttribute('rrr');
  attr := element.setAttributeNode(attr);
  attr := nil;
  attr := document.createAttribute('rrrVX');
  attr.value:='hund';
  attr := element.setAttributeNode(attr);
  attr := nil;
  attr := element.getAttributeNode('rrr');
  test('element.getAttributeNode/setAttributeNode',(attr <> nil));
  attr := nil;
  attr := element.getAttributeNode('rrrVX');
  test('element.getAttributeNode/setAttributeNode2',(attr.value='hund'));
  attr:=nil;
  attr := document.createAttribute('rrrVX');
  attr.value:='hase';
  attr := element.setAttributeNode(attr);
  test('element.getAttributeNode/setAttributeNode3',(attr.value='hund'));
  attr:=nil;
  attr := element.getAttributeNode('rrrVX');
  test('element.getAttributeNode/setAttributeNode4',(attr.value='hase'));
  attr:=nil;
  attr := nil;
  element := nil;

  //to do:
  //add a test, where the attribute das exist, before setAttribute is called
  element := document.createElement('ttt');
  if dom2 then begin
    attr := document.createAttributeNS('http://xmlns.4commerce.de/eva','eva:loop');
    attr := element.setAttributeNodeNS(attr);
    attr := nil;
    attr := element.getAttributeNodeNS('http://xmlns.4commerce.de/eva','loop');
    test('element.getAttributeNodeNS/setAttributeNodeNS',(attr <> nil));
    attr := nil;
    element := nil;
  end;
  attr := document.createAttribute('loop');
  element := document.createElement('iii');
  attr := element.setAttributeNode(attr);
  attr := nil;
  test('element.setAttributeNode',(element.hasAttribute('loop')));
  if dom2 then begin
    element.removeAttributeNS('http://xmlns.4commerce.de/eva','loop');
    test('element.removeAttributeNS',(not element.hasAttributeNS('http://xmlns.4commerce.de/eva','loop')));
    element := nil;
    // setAttributeNodeNS
    attr := document.createAttributeNS('http://xmlns.4commerce.de/eva','eva:loop');
    element := document.createElement('iii');
    attr := element.setAttributeNodeNS(attr);
    attr := nil;
    test('element.setAttributeNodeNS2',(element.hasAttributeNS('http://xmlns.4commerce.de/eva','loop')));
    element.removeAttributeNS('http://xmlns.4commerce.de/eva','loop');
    test('element.removeAttributeNS',(not element.hasAttributeNS('http://xmlns.4commerce.de/eva','loop')));
  end;
  element := nil;
  element := document.documentElement;
  nodelist := element.getElementsByTagName('sometag');
  test('element.getElementsByTagName',(nodelist <> nil));
  test('element.getElementsByTagName (length)',(nodelist.length = 1));
  nodelist := nil;
  element := nil;
  attr := document.createAttribute('nop');
  element := document.createElement('hub');
  try
    attr := element.setAttributeNode(attr);
    attr := element.getAttributeNode('nop');
    attr := element.removeAttributeNode(attr);
    test('element.removeAttributeNode',(not element.hasAttribute('hub')));
  except
    outLog('__element.removeAttributeNode doesn''t work!');
  end;
  attr := nil;
  element := nil;
end;


procedure TestGDom3b(name,vendorstr:string;TestSet:integer);
// shall Test every Method of GDOM2

  procedure TestNode1(filename,vendorstr:string);
  var
    node,node1,docelement,childnode: IDOMNode;
    nodeselect: IDOMNodeSelect;
    i: integer;
    document: IDOMDocument;
    temp: string;
    dom2: boolean;
  begin
    if (testset and 512) = 512 then dom2:=true else dom2:=false;
    document:=nil;
    document := getDoc(filename,vendorstr);
    if document=nil then exit;
    node := document.documentElement as IDOMNode;
    test('node.ownerDocument',(node.ownerDocument.nodeName = document.nodeName));
    node := nil;

    node := document.documentElement as IDOMNode;
    test('node.nodeType (ELEMENT_NODE)',(node.nodeType = ELEMENT_NODE));
    node := nil;

    node := document as IDOMNode;
    test('node.nodeType (DOCUMENT_NODE)',(node.nodeType = DOCUMENT_NODE));
    node := nil;

    //p=1
    node := document.documentElement as IDOMNode;
    //FE: The following line causes a problem:
    //outlog(node.firstchild.nodeName);
    test('node.parentNode',(document.documentElement.firstChild.parentNode.nodeName = node.nodeName));
    node := nil;

    //p=1
    node := (document.documentElement as IDOMNode);
    test('node.hasChildNodes',node.hasChildNodes) ;
    node := nil;

    //p=1
    node := (document.documentElement as IDOMNode).firstChild;
    test('node.firstChild',(node <> nil)) ;

    //p=1
    test('node.nodeName',(node.nodeName = 'sometag')) ;

    //p=1
    test('node.firstChild.hasChildNodes',node.hasChildNodes) ;

    //P=1
    for i := 0 to node.childNodes.length-1 do begin
      if node.childNodes[i].nodeType = TEXT_NODE then begin
         test('node.nodeValue of TEXT_NODE (get)',(node.childNodes[i].nodeValue = 'abc')) ;
         node.childNodes[i].nodeValue := 'def';
         test('node.nodeValue of TEXT_NODE (set)',(node.childNodes[i].nodeValue = 'def')) ;
      end;
    end;
    node := nil;

    //p=1
    node := document.documentElement.firstChild;
    node := node.nextSibling;
    test('node.nextSibling',(node <> nil)) ;

    //p=1
    node := node.previousSibling;
    test('node.previousSibling',(node <> nil)) ;
    node := nil;

    //p=1
    node := document.documentElement.firstChild.lastChild;
    test('node.lastChild',(node <> nil)) ;
    node := nil;

    document:=nil;
    document := getDoc(filename,vendorstr);

    // supported by LIBXML and MSXML but not by W3C
    nodeselect := document.documentElement as IDOMNodeSelect;
    node := nodeselect.selectNode('sometag/@name');
    if node <> nil
      then test('IDOMNodeSelect.selectNode',(node.nodeValue = '1st child of DocumentElement'))
      else outlog('__IDOMNodeSelect.selectNode => failed');
    node := nil;
    nodeselect := nil;

    //p=1
    node := document.documentElement.firstChild.cloneNode(True);
    test('node.cloneNode',(node <> nil));

    //p=1
    docelement:=document.documentElement;
    node1:=docelement.firstChild;
    node := docelement.insertBefore(node,node1);
    test('node.insertBefore',(node <> nil)) ;
    test('node.clone & insert',(node.nodeName = 'sometag')) ;
    node := nil;
    node1:=nil;
    docelement:=nil;

    //p=1
    node := document.documentElement.removeChild(document.documentElement.firstChild);
    test('node.removeChild',(node <> nil)) ;

    //p=1
    node := (document.documentElement as IDOMNode).appendChild(node);
    test('node.appendChild',(node <> nil)) ;
    //outlog('___'+node.nodeName);
    test('node.remove & append',(node.nodeName = 'sometag')) ;
    node := nil;

    try
      //p=2
      node := document.documentElement.lastChild.cloneNode(True);
      node := document.documentElement.replaceChild(node,document.documentElement.firstChild);
      test('node.replaceChild',(node <> nil)) ;
      test('node.clone & replace',(node.nodeName = 'sometag')) ;
      node := nil;
    except
      outLog('__node.replaceChild doesn''t work!');
      outLog('__node.clone & replace doesn''t work!');
    end;

    test('node.isSupported "Core"',(document.documentElement.isSupported('Core','2.0'))) ;
    test('node.isSupported "XML"',(document.documentElement.isSupported('XML','2.0'))) ;

    try
      //p=2
      // testing normalize
    temp:='';
    node:=document.documentElement as IDOMNode;
      for i := 0 to node.firstChild.childNodes.length-1 do begin
        if node.firstChild.childNodes[i].nodeType = TEXT_NODE then begin
          childnode := node.firstChild.childNodes[i].cloneNode(True);
          Break;
        end;
      end;
      childnode:=document.importNode(childnode,false);
      node.firstChild.appendChild(childnode);
      //node.firstChild.appendChild(childnode);
      for i := 0 to node.firstChild.childNodes.length-1 do begin
        if node.firstChild.childNodes[i].nodeType = TEXT_NODE then begin
          temp:=temp+node.firstChild.childNodes[i].nodeValue;
        end;
      end;
      node.firstChild.normalize;
      for i := 0 to node.firstChild.childNodes.length-1 do begin
        if node.firstChild.childNodes[i].nodeType = TEXT_NODE then begin
          test('node.normalize',node.firstChild.childNodes[i].nodeValue=temp);
          //outLog('text after normalize: '+node.firstChild.childNodes[i].nodeValue);
        end;
      end;
    except
      outLog('__node.normalize doesn''t work!');
    end;
  end;

  procedure TestNode2(filename,vendorstr:string);
  var
    node: IDOMNode;
    dom2: boolean;
    document: IDOMDocument;
  begin
    document := getDoc(filename,vendorstr);
    if document=nil then exit;
    if (testset and 512) = 512 then dom2:=true else dom2:=false;
    node := document.createElement('urgs') as IDOMNode;
    test('node.prefix',(node.prefix = '')) ;
    test('node.namespaceUri',(node.namespaceURI = '')) ;
    test('node.localName',(node.localName = ''));  // see W3C.ORG: if using createElement instead of createElementNS localName has to return null
    node := nil;

    node := document.createElementNS('http://xmlns.4commerce.de/eva','eva:urgs') as IDOMNode;
    test('node.prefix (NS)',(node.prefix = 'eva')) ;
    test('node.namespaceUri (NS)',(node.namespaceURI = 'http://xmlns.4commerce.de/eva')) ;
    test('node.localName (NS)',(node.localName = 'urgs'));
    node := nil;
  end;

procedure TestDocType(filename,vendorstr:string);
var
    document: IDOMDocument;
    documentType: IDOMDocumentType;
    namedNodeMap: IDOMNamedNodeMap;
    temp: string;
begin
  document := getDoc(filename,vendorstr);
  if document=nil then exit;
  // testing documenttype
  documenttype:=document.doctype;
  test('document.docType',(documenttype <> nil));
  try
    test('documentType.internalSubset',(documenttype.internalSubset = '<!DOCTYPE test SYSTEM "test.dtd">'));
  except
    outLog('__documentType.internalSubset doesn''t work!');
  end;
  test('documentType.name',(documenttype.name = 'test'));
  namednodemap := documenttype.entities;
  test('documentType.entities',(namednodemap <> nil));
  if vendorstr<>'LIBXML' then begin
    test('entity.length',(namednodemap.length = 2));
    test('entity.notationName',((namednodemap[0] as IDOMEntity).notationName = 'type2'));
    temp:=((namednodemap[0] as IDOMEntity).systemId);
    test('entity.systemId', temp = 'file.type2');
    test('entity.publicId',((namednodemap[0] as IDOMEntity).publicId = ''));
    namednodemap := nil;
    namednodemap := documenttype.notations;
    test('documentType.notations',(namednodemap <> nil));
    outlog('documentType.notations.length: '+inttostr(namednodemap.length));
    test('notation.publicId',((namednodemap[0] as IDOMNotation).publicId = ''));
    test('notation.systemId',((namednodemap[0] as IDOMNotation).systemId = 'program2'));
    namednodemap := nil;
    documenttype:=nil;
  end
  else begin
    OutLog('___entity.length not tested!');
    OutLog('___entity.notationName not tested!');
    OutLog('___entity.systemID not tested!');
    OutLog('___entity.publicID not tested!');
    OutLog('___documentType.notations not tested!');
    OutLog('___notation.publicId not tested!');
    OutLog('___notation.systemId not tested!');
  end;
  document:=nil;
  // testing documenttype, part II
  document := getDoc(filename,vendorstr);
  try
    documenttype := document.domImplementation.createDocumentType('eva:special','a','test');
    test('createdocumentType.name',(documenttype.name = 'eva:special'));
  except
    outLog('__creatDocumentType.name doesn''t work!');
  end;
  try
    //outLog('___'+documenttype.internalSubset);

    test('documentType.systemId',(documenttype.systemId = 'test'));
    test('documentType.publicId',(documenttype.publicId = 'a'));
    documenttype := nil;
  except
    outLog('__documentType.systemId doesn''t work!');
    outLog('__documentType.publicId doesn''t work!');
  end;
end;

procedure TestDomImpl(filename,vendorstr:string);
var
  document,temp: IDOMDocument;
  documentType: IDOMDocumentType;
begin
  document := getDoc(filename,vendorstr);
  if document=nil then exit;
  try
    documenttype := document.domImplementation.createDocumentType('eva:special','','test');
    temp:=documenttype.ownerDocument;
    //documenttype:=nil;
    test('domImplementation.createDocument (NS)',(document.domImplementation.createDocument('http://xmlns.4commerce.de/eva','eva:test',documenttype) <> nil));
    documenttype := nil;
  except
    outLog('__domImplementation.createDocument (NS) doesn''t work!');
  end;
  try
    documenttype := document.domImplementation.createDocumentType('eva:special','','');
    test('domImplementation.createDocumentType',(documenttype <> nil));
    documenttype := nil;
  except
    outLog('__domImplementation.createDocumentType doesn''t work!');
  end;
  test('domImplementation.hasFeature',document.domImplementation.hasFeature('CORE','2.0'));
end;

procedure TestCDATA_PI_Text(filename,vendorstr:string);
var
  document: IDOMDocument;
  cdata: IDOMCDataSection;
  processingInstruction: IDOMProcessingInstruction;
  text: IDOMText;
begin
  // testing character data
  document := getDoc(filename,vendorstr);
  if document=nil then exit;
  cdata := document.createCDATASection('yyy');
  test('document.createCDATASection',(cdata <> nil));
  test('characterData.data (get)',(cdata.data = 'yyy'));
  test('characterData.length',(cdata.length = 3));
  cdata.data := 'zzz';
  test('characterData.data (set)',(cdata.data = 'zzz'));
  cdata.appendData('aaa');
  test('characterData.appendData',(cdata.data = 'zzzaaa'));
  cdata.deleteData(3,3);
  test('characterData.deleteData',(cdata.data = 'zzz'));
  cdata.insertData(1,'aaa');
  test('characterData.insertData',(cdata.data = 'zaaazz'));
  cdata.replaceData(1,3,'bbb');
  test('characterData.replaceData',(cdata.data = 'zbbbzz'));
  cdata := nil;

  // testing processingInstruction

  processinginstruction := document.createProcessingInstruction('abc','def');
  test('processingInstruction.target',(processinginstruction.target = 'abc'));
  test('processingInstruction.data',(processinginstruction.data = 'def'));
  //todo:
  //test pi.setdata
  processinginstruction := nil;

  // testing text
  try
    // testing text
    text := document.createTextNode('blabla');
    text := text.splitText(3);
    test('text.splitText',(text.data = 'bla'));
    text := nil;
  except
    OutLog('__text.splitText doesn''t work!');
  end;
end;

procedure TestNamedNodemap(filename,vendorstr:string);
var
  document: IDOMDocument;
  documentElement: IDOMElement;
  namedNodeMap: IDOMNamedNodeMap;
  node,node1: IDOMNode;
  dom2: boolean;
  len: integer;
begin
  if (testset and 512) = 512 then dom2:=true else dom2:=false;
  document := getDoc(filename,vendorstr);
  if document=nil then exit;
  documentElement:= document.documentElement;
  namednodemap := documentElement.attributes;
  if namednodemap<>nil
    then outlog('namedNodeMap.length: '+inttostr(namedNodeMap.length))
    else outlog('__namedNodeMap=NIL');
  documentElement:=nil;
  node := document.createAttribute('age') as IDOMNode;
  node.nodeValue := '13';
  node := namednodemap.setNamedItem(node);
  node := nil;

  len:= namednodemap.length;
  node := namednodemap.getNamedItem('age');
  test('namedNodeMap.getNamedItem/setNamedItem',(node.nodeValue = '13'));

  node1 := document.createAttribute('sex') as IDOMNode;
  node1.nodeValue:='female';
  node1 := namednodemap.setNamedItem(node1);
  len:= namednodemap.length;

  node1 := document.createAttribute('sex') as IDOMNode;
  node1.nodeValue:='male';
  node1 := namednodemap.setNamedItem(node1);
  len:= namednodemap.length;
  if node1<> nil
    then begin
      test('namedNodeMap.setNamedItemII',(namedNodeMap[1].nodeValue = 'male'));
      node1 := namednodemap.removeNamedItem('sex');
    end
    else outLog('__namedNodeMap.setNamedItemII doesn''t work!');

  node := namednodemap.removeNamedItem('age');
  test('namedNodeMap.removeNamedItem',(namednodemap.length = 0));
  node := nil;
  namednodemap := nil;
  if dom2 then
    try
      namednodemap := document.documentElement.attributes;
      node := document.createAttributeNS('http://xmlns.4commerce.de/eva','eva:age') as IDOMNode;
      node.nodeValue := '13';
      node := namednodemap.setNamedItemNS(node);
      node := nil;
      node := namednodemap.getNamedItemNS('http://xmlns.4commerce.de/eva','age');
      test('namedNodeMap.getNamedItemNS/setNamedItemNS',(node.nodeValue = '13'));
      node := namednodemap.removeNamedItemNS('http://xmlns.4commerce.de/eva','age');
      test('namedNodeMap.removeNamedItemNS',(namednodemap.length = 0));
      node := nil;
      namednodemap := nil;
    except
      OutLog('__namedNodeMap.getNamedItemNS/setNamedItemNS doesn''t work!');
      OutLog('__namedNodeMap.removeNamedItemNS doesn''t work!');
    end;
end;

procedure TestElement1(filename,vendorstr:string);
var
  document: IDOMDocument;
  element:  IDOMElement;
  attlist:  IDOMNamedNodeMap;
  node:     IDOMNode;
  attr:     IDOMAttr;
  dom2:  boolean;
begin
  if (testset and 512) = 512 then dom2:=true else dom2:=false;
  document := getDoc(filename,vendorstr);
  if document=nil then exit;
  element := document.documentElement.firstChild as IDOMElement;
  test('element-interface of Node',(element <> nil));
  test('element.tagName',(element.tagName = 'sometag'));
  element := nil;

  element := document.documentElement.firstChild as IDOMElement;
  element.setAttribute('test','hallo welt');
  test('element.getAttribute/setAttribute',(element.getAttribute('test') = 'hallo welt'));
  element := nil;

  if dom2 then begin
    element := document.documentElement.firstChild as IDOMElement;
    element.setAttributeNS('http://xmlns.4commerce.de/eva','eva:sulze','wabbelig');
    test('element.getAttributeNS/setAttributeNS',(element.getAttributeNS('http://xmlns.4commerce.de/eva','sulze') = 'wabbelig'));
  end;

  element := nil;
  attlist := document.documentElement.firstChild.attributes;

  test('namedNodeMap',(attlist <> nil)) ;
  if dom2
    then test('namedNodeMap.length',(attlist.length = 3))
    else test('namedNodeMap.length',(attlist.length = 2)) ;
  test('namedNodeMap.item[i]',(attlist.item[0].nodeName = 'name')) ;
  attlist := document.documentElement.firstChild.attributes;
  node := attlist.item[0];
  attlist := nil;
  test('namedNodeMap.item[i].nodeType = ATTRIBUTE_NODE (attributes)',(node.nodeType = ATTRIBUTE_NODE)) ;
  attr := node as IDOMAttr;
  node := nil;
  test('attribute-interface of node',(attr <> nil)) ;
  test('attribute.name',(attr.name = 'name')) ;
  test('attribute.value',(attr.value = '1st child of DocumentElement')) ;
  test('attribute.specified',attr.specified) ;
  test('attribute.nodeType = ATTRIBUTE_NODE',(attr.nodeType = ATTRIBUTE_NODE)) ;
  attr := nil;
  element := document.documentElement.firstChild as IDOMElement;
  test('element.hasAttribute',element.hasAttribute('name')) ;
  element.removeAttribute('name');
  test('element.removeAttribute',(not element.hasAttribute('name'))) ;
  element := nil;

  if dom2 then begin
    attr := document.createAttributeNS('http://xmlns.4commerce.de/eva','eva:name1');
    element := document.documentElement;
    element.setAttributeNodeNS(attr);
    attr := nil;

    test('element.hasAttributeNS/setAttributeNodeNS',element.hasAttributeNS('http://xmlns.4commerce.de/eva','name1'));
    element := nil;
  end;
end;

var
  filename: string;
  FDomPersist: IDOMPersist;
  document: IDOMDocument;
  element: IDOMElement;
  node: IDOMNode;
  attlist: IDOMNamedNodeMap;
  //documentElement: IDOMNode;
  stringlist: TStringList;
  temp: string;
  dom2: boolean;
begin
  // init

  Form1.Memo1.Lines.Clear;
  TestsOK:=0; //Number of passed Tests
  stringlist := TStringList.Create;
  filename := '..\data\'+name;
  if (testset and 512) = 512 then dom2:=true else dom2:=false;

  // testing IDOMDocumentBuilder
  document := getDoc(filename,vendorstr,testset);

  // testing document
  if (testset and 2) = 2
     then TestDocument(filename,vendorstr,testset);

  // testing element
  if (testset and 4) = 4
    then begin
      TestElement0(filename,vendorstr,testset);
      TestElement1(filename,vendorstr);
    end;

  // testing node, part 1
  if (testset and 8) = 8
    then begin
      TestNode1(filename,vendorstr);
      if dom2
        then TestNode2(filename,vendorstr);
    end;

  // testing documentType
  if (testset and 16) = 16
    then TestDocType(filename,vendorstr);

  // testing domImpl
  if (testset and 32) =32
    then TestDomImpl(filename,vendorstr);

  // testing domImpl
  if (testset and 64) =64
    then TestCDATA_PI_Text(filename,vendorstr);

  // testing namedNodeMap
  if (testset and 128) =128
    then TestNamedNodemap(filename,vendorstr);


  //document.documentElement.setAttributeNS('http://xmlns.4commerce.de/eva','eva:test','huhu');

  // testing IDOMPersist
  if (testset and 256) =256 then begin
    document := nil;
    document := getDoc(filename,vendorstr);
    if document=nil then exit;
    FDomPersist := document as IDomPersist;
    FDomPersist.save('..\data\saved.xml');
    //todo: test .xml with large xml-file
    //outLog(FDomPersist.xml);
    FDomPersist:=nil;

    document := getEmptyDoc(vendorstr);
    (document as IDOMParseOptions).validate := False;
    //(document as IDomPersist).loadxml('<?xml version="1.0" encoding="iso-8859-1"?><aaa />');
    (document as IDomPersist).loadxml('<?xml version="1.0"?><aaa>12345678901234567890</aaa>');
    IF document.documentElement<>nil
      then test('IDOMPersist.loadxml',(document.documentElement.nodeName = 'aaa'))
      else outLog('__ERROR__ IDOMPersist.loadxml => failed');
    temp:=(document as IDomPersist).xml;
    temp:=StringReplace(temp,#$d#$a,'',[rfReplaceAll]);
    temp:=StringReplace(temp,#10,'',[rfReplaceAll]);
    test('IDOMPersist.xml',(temp='<?xml version="1.0"?><aaa>12345678901234567890</aaa>'));
    document := nil;
  end;


  // --- end of tests, beautify results ---

  stringlist.Clear;
  stringlist.AddStrings(Form1.Memo1.Lines);
  stringlist.Sort;
  Form1.Memo1.Lines.Clear;
  Form1.Memo1.Lines.AddStrings(stringlist);

  // --- free all ---

  stringlist.Free;
  attlist := nil;
  node := nil;
  element := nil;
  FDomPersist:=nil;
  document := nil;
end;

function TestGDom3(name,vendorstr:string;TestSet:integer):double;
var
  testCount: integer;
  dom2: boolean;
begin
  StartTimer;
  TestGdom3b(name,vendorstr,TestSet);
  result:=EndTime;
  outLog('');
  outLog('Number of tests passed OK:  '+inttostr(TestsOK));
  //testCount:=115-22-13-16-24-6-14-3-11-5-1;
  testCount:=0;
  if (testset and 512) = 512 then dom2:=true else dom2:=false;

  if (TestSet and 1) = 1
    then inc(testCount);
  if (TestSet and 2) = 2
    then if dom2
      then testCount:=testCount+22
      else testCount:=testCount+16;
  if (TestSet and 4) = 4
    then if dom2
      then testCount:=testCount+13+16
      else testCount:=testCount+13+16-6;
  if (TestSet and 8) = 8
    then if dom2
      then testCount:=testCount+25+6
      else testCount:=testCount+25;
  if (TestSet and 16) = 16
    then testCount:=testCount+5+8+1;
  if (TestSet and 32) = 32
    then testCount:=testCount+3;
  if (TestSet and 64) = 64
    then testCount:=testCount+11;
  if (TestSet and 128) = 128
    then if dom2
      then testCount:=testCount+5
      else testCount:=testCount+3;
  if (TestSet and 256) = 256
    then testCount:=testCount+2;

  outLog('Number of tests total:    '+inttostr(TestCount));
end;

end.

