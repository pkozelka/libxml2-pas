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

uses dom2,libxmldom,msxml_impl; // IDOMIMplementation, IDOMDocument

function TestGDom3(name,vendorstr:string):double;
function getDoc(filename,vendorstr: string): IDOMDocument;
function getEmptyDoc(vendorstr: string): IDomDocument;
function test(name: string; testexpr: boolean): boolean;

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
  else outLog('__ERROR__ '+name+' => failed ');
  result := testexpr;
end;

function getEmptyDoc(vendorstr: string): IDomDocument;
var
  dom: IDomImplementation;
begin
  dom := GetDom(vendorstr);
  result := dom.createDocument('','',nil);
end;

function getDoc(filename, vendorstr: string): IDomDocument;
var
  dom: IDomImplementation;
  docBuilder : IDomDocumentBuilder;
  doc: IDomDocument;
  FDomPersist: IDomPersist;
  ok: boolean;
begin
  doc:=GetEmptyDoc(vendorstr);
  (doc as IDOMParseOptions).validate := true; // we want to use a dtd
  (doc as IDOMParseOptions).resolveExternals := true;
  FDomPersist := doc as IDomPersist;
  ok := FDomPersist.load(filename);
  if not ok and (vendorstr='MSXML') then begin
    //outLog('ErrorCode: '+inttostr((doc as IDOMParseError).errorCode));
    //outLog('ErrorLine: '+inttostr((doc as IDOMParseError).line));
    //outLog('ErrorLinePos: '+inttostr((doc as IDOMParseError).linePos));
  end;
  if ok then result := doc else result := nil;
end;

procedure TestGDom3b(name,vendorstr:string);
// shall Test every Method of GDOM2
  procedure TestElement(document: IDOMDocument;vendorstr:string);
    var
      element: IDOMElement;
      attr: IDOMAttr;
      nodelist: IDOMNodeList;
  begin
    element := document.documentElement;
    test('element.tagName',(element.tagName = 'test')) ;

    element := nil;
    element := document.createElement('eee');
    attr := document.createAttribute('rrr');
    attr := element.setAttributeNode(attr);
    attr := nil;
    attr := element.getAttributeNode('rrr');
    test('element.getAttributeNode/setAttributeNode',(attr <> nil));
    attr := nil;
    element := nil;

    //to do:
    //add a test, where the attribute das exist, before setAttribute is called
    element := document.createElement('ttt');
    attr := document.createAttributeNS('http://xmlns.4commerce.de/eva','eva:loop');
    attr := element.setAttributeNodeNS(attr);
    attr := nil;
    attr := element.getAttributeNodeNS('http://xmlns.4commerce.de/eva','loop');
    test('element.getAttributeNodeNS/setAttributeNodeNS',(attr <> nil));
    attr := nil;
    element := nil;
    attr := document.createAttribute('loop');
    element := document.createElement('iii');
    attr := element.setAttributeNode(attr);
    attr := nil;
    test('element.setAttributeNode',(element.hasAttribute('loop')));
    element.removeAttributeNS('http://xmlns.4commerce.de/eva','loop');
    test('element.removeAttributeNS',(not element.hasAttributeNS('http://xmlns.4commerce.de/eva','loop')));
    element := nil;
    // setAttributeNodeNS
    attr := document.createAttributeNS('http://xmlns.4commerce.de/eva','loop');
    element := document.createElement('iii');
    attr := element.setAttributeNodeNS(attr);
    attr := nil;
    test('element.setAttributeNodeNS2',(element.hasAttributeNS('http://xmlns.4commerce.de/eva','loop')));
    element.removeAttributeNS('http://xmlns.4commerce.de/eva','loop');
    test('element.removeAttributeNS',(not element.hasAttributeNS('http://xmlns.4commerce.de/eva','loop')));
    element := nil;
    element := document.documentElement;
    nodelist := element.getElementsByTagName('sometag');
    test('element.getElementsByTagName',(nodelist <> nil));
    test('element.getElementsByTagName (length)',(nodelist.length = 1));
    nodelist := nil;
    element := nil;
    attr := document.createAttribute('nop');
    element := document.createElement('hub');
    attr := element.setAttributeNode(attr);
    attr := element.getAttributeNode('nop');
    attr := element.removeAttributeNode(attr);
    test('element.removeAttributeNode',(not element.hasAttribute('hub')));
    attr := nil;
    element := nil;
  end;

  procedure TestDocument(document: IDOMDocument;vendorstr:string);
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
  begin
    test('document',(document <> nil));
    if document=nil then exit;

    //p=1
    element := document.documentElement;
    test('document.documentElement',(element <> nil));
    element := nil;

    //p=1
    node := document.createElement('abc');
    test('document.createElement',(node <> nil)) ;
    test('document.createElement (nodeName)',(node.nodeName = 'abc')) ;

    //p=1
    node := document.createElementNS('http://xmlns.4commerce.de/eva','eva:abc1');
    test('document.createElementNS',(node <> nil)) ;
    test('document.createElementNS (nodeName)',(node.nodeName = 'eva:abc1')) ;

    //p=1
    attr := document.createAttribute('name');
    test('document.createAttribute',(attr <> nil)) ;
    test('document.createAttribute (name)',(attr.name ='name')) ;

    //p=1
    attr := document.createAttributeNS('http://xmlns.4commerce.de/eva','eva:name1');
    test('document.createAttributeNS',(attr <> nil)) ;
    test('document.createAttributeNS (name)',(attr.name ='eva:name1')) ;

    //p=1
    text := document.createTextNode('eee');
    test('document.createTextNode',(text <> nil));
    test('document.createTextNode (data)',(text.data ='eee'));
    text := nil;

    document.documentElement.appendChild(node);
    node := nil;

    //p=2
    nodelist := document.getElementsByTagNameNS('http://xmlns.4commerce.de/eva','abc1');
    if nodelist<>nil
      then test('document.getElementsByTagNameNS (length)',(nodelist.length = 1));
    nodelist := nil;
    //p=2
    nodelist := document.documentElement.getElementsByTagNameNS('http://xmlns.4commerce.de/eva','abc1');
    if nodelist <> nil
      then test('element.getElementsByTagNameNS (length)',(nodelist.length = 1));
    nodelist := nil;

    //p=2
    nodelist := document.getElementsByTagName('sometag');
    if nodelist <> nil then begin
      test('document.getElementsByTagName',(nodelist <> nil));
      test('document.getElementsByTagName (length)',(nodelist.length = 1)) ;
    end;
    nodelist := nil;
    if vendorstr<>'LIBXML' then begin
      //p=2
      dom := document.domImplementation;
      test('document.domImplementation',(dom <> nil)) ;
      dom := nil;

      //p=2
      cdata := document.createCDATASection('zzz');
      test('document.createCDATASection',(cdata <> nil));
      cdata := nil;

      //p=2
      comment := document.createComment('xxx');
      test('document.createComment',(comment <> nil));
      comment := nil;

      //p=3
      documentfragment := document.createDocumentFragment;
      test('document.createDocumentFragment',(documentfragment <> nil));
      documentfragment := nil;

      //p=3
      entityreference := document.createEntityReference('iii');
      test('document.createEntityReference',(entityreference <> nil));
      entityreference := nil;

      //p=3
      processinginstruction := document.createProcessingInstruction('qqq','www');
      test('document.createProcessingInstruction',(processinginstruction <> nil));
      processinginstruction := nil;
    end;
  end;

  procedure TestNode1(filename,vendorstr:string);
  var
    node,node1,docelement: IDOMNode;
    nodelist: IDOMNodeList;
    nodeselect: IDOMNodeSelect;
    attlist: IDOMNamedNodeMap;
    namednodemap: IDOMNamedNodeMap;
    i: integer;
    document: IDOMDocument;
  begin
    document:=nil;
    document := getDoc(filename,vendorstr);
    node := document.documentElement as IDOMNode;
    test('node.ownerDocument',(node.ownerDocument.nodeName = document.nodeName));
    node := nil;

    node := document.documentElement as IDOMNode;
    test('node.nodeType (ELEMENT_NODE)',(node.nodeType = ntELEMENTNODE));
    node := nil;

    node := document as IDOMNode;
    test('node.nodeType (DOCUMENT_NODE)',(node.nodeType = ntDOCUMENTNODE));
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
      if node.childNodes[i].nodeType = ntTEXTNODE then begin
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
      else outlog('__ERROR__ IDOMNodeSelect.selectNode => failed');
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

    if vendorstr<>'LIBXML' then begin

      node := document.documentElement.lastChild.cloneNode(True);

      //p=2
      node := document.documentElement.replaceChild(node,document.documentElement.firstChild);
      test('node.replaceChild',(node <> nil)) ;
      test('node.clone & replace',(node.nodeName = 'sometag')) ;
      node := nil;

      //if vendorstr <> 'MSXML2_RENTAL_MODEL' then begin
        test('node.isSupported "Core"',(document.documentElement.isSupported('Core','2.0'))) ;
        test('node.isSupported "XML"',(document.documentElement.isSupported('XML','2.0'))) ;
      //end else begin
      //  outLog('node.isSupported doesn''t work with MSXML.')
      //end;

      //p=2
      outLog('node.normalize => disabled');
      // testing normalize
      {
      for i := 0 to node.firstChild.childNodes.length-1 do begin
        if node.firstChild.childNodes[i].nodeType = TEXT_NODE then begin
          childnode := node.firstChild.childNodes[i].cloneNode(True);
          Break;
        end;
      end;
      node.firstChild.appendChild(childnode);
      node.firstChild.appendChild(childnode);
      for i := 0 to node.firstChild.childNodes.length-1 do begin
        if node.firstChild.childNodes[i].nodeType = TEXT_NODE then begin
          outLog('text before normalize: '+node.firstChild.childNodes[i].nodeValue);
        end;
      end;
      node.firstChild.normalize;
      for i := 0 to node.firstChild.childNodes.length-1 do begin
        if node.firstChild.childNodes[i].nodeType = TEXT_NODE then begin
          outLog('text after normalize: '+node.firstChild.childNodes[i].nodeValue);
        end;
      end;
      }
    end;
  end;

  procedure TestNode2(document: IDOMDocument;vendorstr:string);
  var
    node: IDOMNode;
  begin
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

var
  filename: string;
  FDomPersist: IDOMPersist;
  dom: IDOMImplementation;
  document: IDOMDocument;
  element: IDOMElement;
  node: IDOMNode;
  nodelist: IDOMNodeList;
  nodeselect: IDOMNodeSelect;
  attlist: IDOMNamedNodeMap;
  namednodemap: IDOMNamedNodeMap;
  attr: IDOMAttr;
  cdata: IDOMCDATASection;
  comment: IDOMComment;
  documentfragment: IDOMDocumentFragment;
  documentElement: IDOMNode;
  entityreference: IDOMEntityReference;
  processinginstruction: IDOMProcessingInstruction;
  text: IDOMText;
  documenttype: IDOMDocumentType;
  stringlist: TStringList;
  i: integer;
  temp: string;
begin
  // init

  Form1.Memo1.Lines.Clear;
  TestsOK:=0; //Number of passed Tests
  stringlist := TStringList.Create;
  filename := '..\data\'+name;
  document := getDoc(filename,vendorstr);

  // testing document
  TestDocument(document,vendorstr);
  if document=nil then exit;

  // testing element
  TestElement(document,vendorstr);

  // testing node, part 1
  document:=nil;
  document := getDoc(filename,vendorstr);
  TestNode1(filename,vendorstr);

  if vendorstr<>'LIBXML' then begin

    // testing documenttype
    documenttype:=document.doctype;
    test('document.docType',(documenttype <> nil));
    if vendorstr<>'MSXML2_RENTAL_MODEL' then begin
      test('documentType.internalSubset',(documenttype.internalSubset = '<!DOCTYPE test SYSTEM "test.dtd">'));
    end else begin
      outLog('documentType.internalSubset doesn''t work with MSXML.');
    end;
    test('documentType.name',(documenttype.name = 'test'));
    namednodemap := documenttype.entities;
    test('documentType.entities',(namednodemap <> nil));
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
    // end
    document:=nil;
    document := getDoc(filename,vendorstr);

    // testing domimplementation

    if vendorstr <> 'MSXML2_RENTAL_MODEL' then begin
      documenttype := document.domImplementation.createDocumentType('http://xmlns.4commerce.de/eva','','test');
      test('domImplementation.createDocument (NS)',(document.domImplementation.createDocument('http://xmlns.4commerce.de/eva','eva:test',documenttype) <> nil));
      documenttype := nil;
    end else begin
      outLog('domImplementation.createDocument (NS) doesn''t work with MSXML.');
    end;

    if vendorstr <> 'MSXML2_RENTAL_MODEL' then begin
      documenttype := document.domImplementation.createDocumentType('http://xmlns.4commerce.de/eva','','');
      test('domImplementation.createDocumentType',(documenttype <> nil));
      documenttype := nil;
    end else begin
      outLog('domImplementation.createDocumentType doesn''t work with MSXML.');
    end;

    test('domImplementation.hasFeature',document.domImplementation.hasFeature('CORE','2.0'));

    // testing documenttype, part II

    if vendorstr <> 'MSXML2_RENTAL_MODEL' then begin
      documenttype := document.domImplementation.createDocumentType('http://xmlns.4commerce.de/eva','a','test');
      test('documentType.name',(documenttype.name = '//xmlns.4commerce.de/eva'));

      //outLog('___'+documenttype.internalSubset);

      test('documentType.systemId',(documenttype.systemId = 'test'));
      test('documentType.publicId',(documenttype.publicId = 'a'));
      documenttype := nil;
    end else begin
      outLog('documentType.systemId doesn''t work with MSXML');
      outLog('documentType.publicId doesn''t work with MSXML');
    end;


    // testing character data

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
    processinginstruction := nil;

    // testing text

    text := document.createTextNode('blabla');
    text := text.splitText(3);
    test('text.splitText',(text.data = 'bla'));
    text := nil;
  end;

  // testing namedNodeMap
  documentElement:= document.documentElement;
  namednodemap := documentElement.attributes;
  if namednodemap<>nil
    then outlog('namedNodeMap.length: '+inttostr(namedNodeMap.length))
    else outlog('namedNodeMap=NIL');
  documentElement:=nil;
  node := document.createAttribute('age') as IDOMNode;
  node.nodeValue := '13';
  node := namednodemap.setNamedItem(node);
  node := nil;

  node := namednodemap.getNamedItem('age');
  test('namedNodeMap.getNamedItem/setNamedItem',(node.nodeValue = '13'));
  if vendorstr<>'LIBXML' then begin
    node := namednodemap.removeNamedItem('age');
    test('namedNodeMap.removeNamedItem',(namednodemap.length = 0));
    node := nil;
    namednodemap := nil;

    if vendorstr <> 'MSXML2_RENTAL_MODEL' then begin
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
    end;
  end;
  // testing element
  element := document.documentElement.firstChild as IDOMElement;
  test('element-interface of Node',(element <> nil));
  test('element.tagName',(element.tagName = 'sometag'));
  element := nil;

  element := document.documentElement.firstChild as IDOMElement;
  element.setAttribute('test','hallo welt');
  test('element.getAttribute/setAttribute',(element.getAttribute('test') = 'hallo welt'));
  element := nil;

  element := document.documentElement.firstChild as IDOMElement;
  element.setAttributeNS('http://xmlns.4commerce.de/eva','eva:sulze','wabbelig');
  test('element.getAttributeNS/setAttributeNS',(element.getAttributeNS('http://xmlns.4commerce.de/eva','sulze') = 'wabbelig'));

  element := nil;
  attlist := document.documentElement.firstChild.attributes;

  test('namedNodeMap',(attlist <> nil)) ;
  test('namedNodeMap.length',(attlist.length = 3)) ;
  test('namedNodeMap.item[i]',(attlist.item[0].nodeName = 'name')) ;
  attlist := document.documentElement.firstChild.attributes;
  node := attlist.item[0];
  attlist := nil;
  test('namedNodeMap.item[i].nodeType = ATTRIBUTE_NODE (attributes)',(node.nodeType = ntATTRIBUTENODE)) ;
  attr := node as IDOMAttr;
  node := nil;
  test('attribute-interface of node',(attr <> nil)) ;
  test('attribute.name',(attr.name = 'name')) ;
  test('attribute.value',(attr.value = '1st child of DocumentElement')) ;
  test('attribute.specified',attr.specified) ;
  test('attribute.nodeType = ATTRIBUTE_NODE',(attr.nodeType = ntATTRIBUTENODE)) ;
  attr := nil;
  element := document.documentElement.firstChild as IDOMElement;
  test('element.hasAttribute',element.hasAttribute('name')) ;
  element.removeAttribute('name');
  test('element.removeAttribute',(not element.hasAttribute('name'))) ;
  element := nil;

  attr := document.createAttributeNS('http://xmlns.4commerce.de/eva','eva:name1');
  element := document.documentElement;
  element.setAttributeNodeNS(attr);
  attr := nil;

  test('element.hasAttributeNS/setAttributeNodeNS',element.hasAttributeNS('http://xmlns.4commerce.de/eva','name1'));
  element := nil;

  // testing node, part 2
  //document:=nil;
  //document := getDoc(filename,vendorstr);
  TestNode2(document,vendorstr);

  document.documentElement.setAttributeNS('http://xmlns.4commerce.de/eva','eva:test','huhu');

  // testing IDOMPersist

  FDomPersist := document as IDomPersist;
  FDomPersist.save('..\data\saved.xml');
  //todo: test .xml with large xml-file
  //outLog(FDomPersist.xml);
  FDomPersist:=nil;

  document := getEmptyDoc(vendorstr);
  (document as IDOMParseOptions).validate := False;
  //(document as IDomPersist).loadxml('<?xml version="1.0" encoding="iso-8859-1"?><aaa />');
  (document as IDomPersist).loadxml('<?xml version="1.0" ?><aaa />');
  IF document.documentElement<>nil
    then test('IDOMPersist.loadxml',(document.documentElement.nodeName = 'aaa'))
    else outLog('__ERROR__ IDOMPersist.loadxml => failed');
  document := nil;


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

function TestGDom3(name,vendorstr:string):double;
begin
  StartTimer;
  TestGdom3b(name,vendorstr);
  result:=EndTime;
  outLog('');
  outLog('Number of tests passed OK:  '+inttostr(TestsOK));
  outLog('Number of tests total:     108');
  //outLog('doccount='+inttostr(doccount));
  //outLog('nodecount='+inttostr(nodecount));
  //outLog('elementcount='+inttostr(elementcount));
end;

end.

