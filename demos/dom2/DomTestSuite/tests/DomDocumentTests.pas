unit DomDocumentTests;

(*
 * Tests cases for IDomDocument.
 *
 * NOTE: writing tests and compliance tests without a fully non-compliant DOM
 * could easily result in incorrect test code.
*)

interface

uses
  TestFrameWork,
  idom2,
  DomSetup;

type

  TDomDocumentFundamentalTests = class(TTestCase)
    private
      fDomImplementation : IDomImplementation;

    public
      procedure setup; override;
      procedure tearDown; override;

    published
      procedure checkNodeTypeTest;
      procedure checkNodeNameTest;

      (* from documentCreateAttribute.js *)
      procedure createAttributeTest;
      (* from documentCreateAttributeMalformedXMLNS.js *)
      procedure createAttributeMalformedXMLNSTest;
      (* from documentCreateAttributeNullXMLNS.js *)
      procedure createAttributeNullXMLNSTest;
      (* converted from: documentCreateAttributeXMLNSIllegalName.js *)
      procedure createAttributeXMLNSIllegalNameTest;
      (* converted from: documentCreateAttributeXMLNSPrefixXML.js *)
      procedure createAttributeXMLNSPrefixXMLTest;
      (* converted from: documentCreateCDATASection.js *)
      procedure createCDATASectionTest;
      (* converted from: documentCreateComment.js *)
      procedure createCommentTest;
      (* converted from: documentCreateDocumentFragment.js *)
      procedure createDocumentFragmentTest;
      (* converted from: documentCreateElement.js *)
      procedure createElementTest;
      (* converted from: documentCreateElementCaseSensitive.js *)
      procedure createElementCaseSensitiveTest;
      (* converted from: documentCreateElementDefaultAttr.js *)
      procedure createElementDefaultAttrTest;
      (* converted from: documentCreateElementMalformedXMLNS.js *)
      procedure createElementMalformedXMLNSTest;
      (* converted from: documentCreateElementNullXMLNS.js *)
      procedure createElementNullXMLNSTest;
      (* converted from: documentCreateElementXMLNSIllegalName.js *)
      procedure createElementXMLNSIllegalNameTest;
      (* converted from: documentCreateELementXMLNSPrefixXML.js *)
      procedure createELementXMLNSPrefixXMLTest;
      (* converted from: documentCreateEntityReference.js *)
      procedure createEntityReferenceTest;
      (* converted from: documentCreateEntityReferenceKnown.js *)
      procedure createEntityReferenceKnownTest;
      (* converted from: documentCreateProcessingInstruction.js *)
      procedure createProcessingInstructionTargetXMLTest;
      procedure createProcessingInstructionTest;
      (* converted from: documentCreateTextNode.js *)
      procedure createTextNodeTest;
      (* converted from: documentGetDocType.js *)
      procedure getDocTypeTest;
      (* converted from: documentGetDocTypeNoDTD.js *)
      procedure getDocTypeNoDTDTest;
      (* converted from: documentGetDocumentElementHTML.js *)
      procedure getDocumentElementHTMLTest;
      (* converted from: documentGetElementByIdXMLNS.js *)
      procedure getElementByIdXMLNSTest;
      (* converted from: documentGetElementByIdXMLNSNull.js *)
      procedure getElementByIdXMLNSNullTest;
      (* converted from: documentGetElementsByTagNameAllXMLNS.js *)
      procedure getElementsByTagNameAllXMLNSTest;
      (* converted from: documentGetElementsByTagNameLength.js *)
      procedure getElementsByTagNameLengthTest;
      (* converted from: documentGetElementsByTagNameSpecifiedXMLNS.js *)
      procedure getElementsByTagNameSpecifiedXMLNSTest;
      (* converted from: documentGetElementsByTagNameTotalLength.js *)
      procedure getElementsByTagNameTotalLengthTest;
      (* converted from: documentGetElementsByTagNameValue.js *)
      procedure getElementsByTagNameValueTest;
      (* converted from: documentGetImplementation.js *)
      procedure getImplementationTest;
      (* converted from: documentGetRootNode.js *)
      procedure getRootNodeTest;
      (* converted from: documentHTMLNull.js *)
      procedure docTypeHTMLNilTest;

  end;

  function getUnitTests : ITestSuite;

implementation

uses
  SysUtils;


procedure TDomDocumentFundamentalTests.setup;
begin
  fDomImplementation :=
          DomSetup.getCurrentDomSetup.getDocumentBuilder.domImplementation;
end;

procedure TDomDocumentFundamentalTests.tearDown;
begin
  fDomImplementation := nil;
end;


(* checks if nodeType =  DOCUMENT_NODE *)
procedure TDomDocumentFundamentalTests.checkNodeTypeTest;
var
  document : IDomDocument;
begin
  document := fDomImplementation.createDocument('', '', nil);
  check(document.nodeType = DOCUMENT_NODE);
end;

(* checks if nodeName = #document DOCUMENT_NODE *)
procedure TDomDocumentFundamentalTests.checkNodeNameTest;
var
  document : IDomDocument;
begin
  document := fDomImplementation.createDocument('', '', nil);
  check(document.nodeName = '#document');
end;

(* creates an attribute and checks its properties *)
procedure TDomDocumentFundamentalTests.createAttributeTest;
const
  ATTR_NAME = 'test';
var
  document : IDomDocument;
  attr     : IDomAttr;
begin
  document := fDomImplementation.createDocument('', '', nil);
  attr := document.createAttribute(ATTR_NAME);
  checkNotNull(attr, 'attr = nil');
  check(attr.nodeName = ATTR_NAME, 'nodeName is incorrect');
  check(attr.nodeName = attr.name, 'nodeName <> name');
  check(attr.value = '', 'value <> ''''');
  check(attr.nodeType = ATTRIBUTE_NODE, 'nodeType <> ATTRIBUTE_NODE');
  check(attr.localName = '', 'localname <> ''''');
  check(attr.prefix = '', 'prefix <> ''''');
  check(attr.namespaceURI = '', 'namespaceURI <> ''''');
end;

(*
 * creates an attribute with a malformed name and checks if exception
 * NAMESPACE_ERR is thrown
*)
procedure TDomDocumentFundamentalTests.createAttributeMalformedXMLNSTest;
var
  document      : IDomDocument;
  attr          : IDomAttr;
  namespaceURI  : DomString;
  malformedName : DomString;
begin
  document := fDomImplementation.createDocument('', '', nil);
  namespaceURI  := 'http://www.ecommerce.org/';
  malformedName := 'prefix::local';
  try
    attr := document.createAttributeNS(namespaceURI, malformedName);
    fail('EDomException NAMESPACE_ERR should have been thrown for attribute name='+malformedName);
  except
    on e : EDomException do
      check(e.code = NAMESPACE_ERR, 'NAMESPACE_ERR should have been thrown for attribute name='+malformedName);
  end;
end;


(*
 * creates an attribute with a empty namespaceURI which should throw
 * NAMESPACE_ERR
*)
procedure TDomDocumentFundamentalTests.createAttributeNullXMLNSTest;
var
  document      : IDomDocument;
  attr          : IDomAttr;
  namespaceURI  : DomString;
  qualifiedName : DomString;
begin
  document := fDomImplementation.createDocument('', '', nil);
  namespaceURI  := '';
  qualifiedName := 'prefix:local';
  try
    attr := document.createAttributeNS(namespaceURI, qualifiedName);
    fail('EDomException NAMESPACE_ERR should have been thrown');
  except
    on e : EDomException do
      check(e.code = NAMESPACE_ERR, 'NAMESPACE_ERR should have been thrown');
  end;
end;



(*
 * checks if creating an attribute with a qualified name using illegal chars
 * results in EDomException etInvalidCharacterErr
*)
procedure TDomDocumentFundamentalTests.createAttributeXMLNSIllegalNameTest;
var
  document      : IDomDocument;
  attr          : IDomAttr;
  qualifiedName : DomString;
  prefix        : DomString;
  namespaceURI  : DomString;
  i             : Integer;
begin
  document     := fDomImplementation.createDocument('', '', nil);
	namespaceURI := 'www.pingpolice.com';
  prefix       := 'prefix:suffix';
  for i := low(DomSetup.illegalChars) to high(DomSetup.illegalChars) do
  begin
    try
      qualifiedName := prefix + DomSetup.illegalChars[i];
      attr := document.createAttributeNS(namespaceURI, qualifiedName);

      fail('EDomException INVALID_CHARACTER_ERR should have been thrown ' +
           'but was not');
    except
      on e : EDomException do
        check(e.code = INVALID_CHARACTER_ERR,
                'INVALID_CHARACTER_ERR should be thrown but was: ' + e.message);
    end;
  end;
end;



(*
 * creates an attribute with prefix xml and namespaceURI which is not uqual to
 * http://www.w3.org/XML/1998/namespace. This should result in NAMESPACE_ERR
*)
procedure TDomDocumentFundamentalTests.createAttributeXMLNSPrefixXMLTest;
var
  document      : IDomDocument;
  attr          : IDomAttr;
  namespaceURI  : DomString;
  qualifiedName : DomString;
begin
  document := fDomImplementation.createDocument('', '', nil);
  namespaceURI  := 'http://www.w3.org/XML/1998/someothernamespaces';
  qualifiedName := 'xml:local';
  try
    attr := document.createAttributeNS(namespaceURI, qualifiedName);
    fail('EDomException NAMESPACE_ERR should have been thrown');
  except
    on e : EDomException do
      check(e.code = NAMESPACE_ERR, 'NAMESPACE_ERR should have been thrown');
  end;
end;



(* creates a CDataSection and checks its properties *)
procedure TDomDocumentFundamentalTests.createCDATASectionTest;
const
  SECTION_NAME = 'new datasection';
var
  document     : IDomDocument;
  cDataSection : IDomCDataSection;
begin
  document := fDomImplementation.createDocument('', '', nil);
  cDataSection := document.createCDataSection(SECTION_NAME);
  check(cDataSection.nodeName = '#cdata-section', 'nodeName <> #cdata-section');
  check(cDataSection.nodeValue = SECTION_NAME, 'nodevalue not correct');
  check(cDataSection.nodeType = CDATA_SECTION_NODE);
end;


(* creates a comment and checks its properties *)
procedure TDomDocumentFundamentalTests.createCommentTest;
const
  COMMENT_NAME = 'new comment';
var
  document : IDomDocument;
  comment  : IDomComment;
begin
  document := fDomImplementation.createDocument('', '', nil);
  comment := document.createComment(COMMENT_NAME);
  check(comment.nodeName = '#comment', 'nodeName <> #comment');
  check(comment.nodeValue = COMMENT_NAME, 'nodevalue not correct');
  check(comment.nodeType = COMMENT_NODE);
end;


(* creates a documentFragment and checks its properties *)
procedure TDomDocumentFundamentalTests.createDocumentFragmentTest;
var
  document : IDomDocument;
  fragment : IDomDocumentFragment;
begin
  document := fDomImplementation.createDocument('', '', nil);
  fragment := document.createDocumentFragment;
  check(fragment.childNodes.length = 0, 'number of childs <> 0');
  check(fragment.nodeName = '#document-fragment', 'nodeName <> #document-fragment');
  check(fragment.nodeValue = '', 'nodevalue not correct');
  check(fragment.nodeType = DOCUMENT_FRAGMENT_NODE);
end;


(* creates an element and checks its properties *)
procedure TDomDocumentFundamentalTests.createElementTest;
const
  ELEMENT_NAME = 'somename';
var
  document : IDomDocument;
  node     : IDomElement;
begin
  document := fDomImplementation.createDocument('', '', nil);
  node := document.createElement(ELEMENT_NAME);
  check(node.nodeName = ELEMENT_NAME, 'nodeName <> "'+ELEMENT_NAME+'"');
  check(node.nodeValue = '', 'nodevalue not correct');
  check(node.nodeType = ELEMENT_NODE);
  check(node.localName = '', 'localname <> ''''');
  check(node.prefix = '', 'prefix <> ''''');
  check(node.namespaceURI = '', 'namespaceURI <> ''''');
end;


(* creates an element and checks its properties *)
procedure TDomDocumentFundamentalTests.createElementCaseSensitiveTest;
const
  ELEMENT_NAME_LC = 'somename';
  ELEMENT_NAME_UC = 'SOMENAME';
  ATTR_NAME_1     = 'city';
  ATTR_NAME_2     = 'country';
  ATTR_VALUE_1    = 'amsterdam';
  ATTR_VALUE_2    = 'netherlands';
var
  document : IDomDocument;
  nodeLC   : IDomElement;
  nodeUC   : IDomElement;
begin
  document := fDomImplementation.createDocument('', '', nil);
  nodeLC := document.createElement(ELEMENT_NAME_LC);
  nodeUC := document.createElement(ELEMENT_NAME_UC);
  nodeLC.setAttribute(ATTR_NAME_1, ATTR_VALUE_1);
  nodeUC.setAttribute(ATTR_NAME_2, ATTR_VALUE_2);
  check(nodeLC.getAttribute(ATTR_NAME_1) = ATTR_VALUE_1);
  check(nodeUC.getAttribute(ATTR_NAME_2) = ATTR_VALUE_2);
end;


(* creates an element and checks if it has a default attribute *)
procedure TDomDocumentFundamentalTests.createElementDefaultAttrTest;
const
  XML_VALID_DOC =
         '<?xml version=''1.0''?>' +
         '  <!DOCTYPE address [' +
         '  <!ELEMENT address (#PCDATA)>' +
         '  <!ATTLIST address' +
         '            domestic CDATA #IMPLIED' +
         '            street CDATA "Yes">' +
         '  ]>' +
         '  <address>some text</address>';

  ATTR_NAME = 'street';
var
  document : IDomDocument;
  element  : IDomElement;
  attrMap  : IDomNamedNodeMap;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(XML_VALID_DOC);
  element := document.createElement('address');
  attrMap := element.attributes;
  (* because of default attr there should be a default attr street/ Yes *)
  check(attrMap.length = 1, 'there should be 1 attribute');
  check(attrMap.item[0].nodeName = ATTR_NAME, 'attr.nodename <> street');
  check(attrMap.item[0].nodeValue = 'Yes', 'attr.nodeValue <> Yes');
end;


(* creates an element with malformed name *)
procedure TDomDocumentFundamentalTests.createElementMalformedXMLNSTest;
var
  document      : IDomDocument;
  element       : IDomElement;
  namespaceURI  : DomString;
  malformedName : DomString;
begin
  document := fDomImplementation.createDocument('', '', nil);
  try
    namespaceURI := 'http://www.ecommerce.org/';
    malformedName := 'prefix::local';
    element := document.createElementNS(namespaceURI, malformedName);
    fail('NAMESPACE_ERR should have been thrown');
  except
    on e : EDomException do
      check(e.code = NAMESPACE_ERR, 'NAMESPACE_ERR should have been thrown');
  end;
end;


(* creates an element with nil namespacURI but with name *)
procedure TDomDocumentFundamentalTests.createElementNullXMLNSTest;
var
  document      : IDomDocument;
  element       : IDomElement;
  namespaceURI  : DomString;
  qualifiedName : DomString;
begin
  document := fDomImplementation.createDocument('', '', nil);
  try
    namespaceURI := '';
    qualifiedName := 'prefix:local';
    element := document.createElementNS(namespaceURI, qualifiedName);
    fail('NAMESPACE_ERR should have been thrown');
  except
    on e : EDomException do
      check(e.code = NAMESPACE_ERR, 'NAMESPACE_ERR should have been thrown');
  end;
end;

(*
 * checks if creating an element with a qualified name using illegal chars
 * results in EDomException etInvalidCharacterErr
*)
procedure TDomDocumentFundamentalTests.createElementXMLNSIllegalNameTest;
var
  document      : IDomDocument;
  element       : IDomElement;
  qualifiedName : DomString;
  prefix        : DomString;
  namespaceURI  : DomString;
  i             : Integer;
begin
  document     := fDomImplementation.createDocument('', '', nil);
	namespaceURI := 'www.pingpolice.com';
  prefix       := 'prefix:local';
  for i := low(DomSetup.illegalChars) to high(DomSetup.illegalChars) do
  begin
    try
      qualifiedName := prefix + DomSetup.illegalChars[i];
      element := document.createElementNS(namespaceURI, qualifiedName);

      fail('EDomException INVALID_CHARACTER_ERR should have been thrown ' +
           'but was not');
    except
      on e : EDomException do
        check(e.code = INVALID_CHARACTER_ERR,
                'INVALID_CHARACTER_ERR should be thrown but was: ' + e.message);
    end;
  end;
end;


(*
 * creates an element with xml prefix and namespace <>
 * http://www.w3.org/XML/1998/namespace. This should result in NAMESPACE_ERR
*)
procedure TDomDocumentFundamentalTests.createELementXMLNSPrefixXMLTest;
var
  document      : IDomDocument;
  element       : IDomElement;
  namespaceURI  : DomString;
  qualifiedName : DomString;
begin
  document := fDomImplementation.createDocument('', '', nil);
  try
    namespaceURI := 'http://www.w3.org/XML/1998/AnotherNamespace';
    qualifiedName := 'xml:local';
    element := document.createElementNS(namespaceURI, qualifiedName);
    fail('NAMESPACE_ERR should have been thrown');
  except
    on e : EDomException do
      check(e.code = NAMESPACE_ERR, 'NAMESPACE_ERR should have been thrown');
  end;
end;


(* creates an entity reference and checks its properties *)
procedure TDomDocumentFundamentalTests.createEntityReferenceTest;
const
  ENTITY_NAME = 'SomeEntity';
var
  document  : IDomDocument;
  entityRef : IDomEntityReference;
begin
  document := fDomImplementation.createDocument('', '', nil);
  entityRef := document.createEntityReference(ENTITY_NAME);
  check(entityRef.nodeType = ENTITY_REFERENCE_NODE,
          'nodeType <> ENTITY_REFERENCE_NODE');
  check(entityRef.nodeName = ENTITY_NAME, 'entity name <> SomeEntity');
  check(entityRef.nodeValue = '', 'entity nodeValue <> ''''');
  check(entityRef.childNodes.length = 0, 'entityRef.childNodes.length <> 0');
end;



(* creates an entity reference with a known name and checks its properties *)
procedure TDomDocumentFundamentalTests.createEntityReferenceKnownTest;
const
  XML_VALID_DOC =
         '<?xml version=''1.0''?>' +
         '  <!DOCTYPE address [' +
         '  <!ELEMENT address (#PCDATA)>' +
         '  <!ENTITY ent1 "SomeEntity">' +
         '  ]>' +
         '  <address>some text</address>';

  ENTITY_NAME  = 'ent1';
  ENTITY_VALUE = 'SomeEntity';
var
  document  : IDomDocument;
  entityRef : IDomEntityReference;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(XML_VALID_DOC);
  entityRef := document.createEntityReference(ENTITY_NAME);
  check(entityRef.childNodes.length = 1, 'entityRef.childNodes.length <> 1');
  check(entityRef.childNodes.item[0].nodeName = '#text',
          'entity nodeName <> #text');
  check(entityRef.childNodes.item[0].nodeValue = ENTITY_VALUE,
          'entity nodeValue <> SomeEntity');
end;



(* creates a createProcessingInstructionTest and checks its properties *)
procedure TDomDocumentFundamentalTests.createProcessingInstructionTargetXMLTest;
const
  TARGET = 'XML';
  DATA   = 'new PI node';
var
  document : IDomDocument;
  pi       : IDomProcessingInstruction;
begin
  document := fDomImplementation.createDocument('', '', nil);
  pi := document.createProcessingInstruction(TARGET, DATA);
  check(pi.nodeType = PROCESSING_INSTRUCTION_NODE,
          'nodeType <> PROCESSING_INSTRUCTION_NODE');
  check(pi.target = TARGET, 'target <> XML');
  check(pi.data = DATA, 'data <> ''new PI node''');
end;

(* creates a createProcessingInstructionTest and checks its properties *)
procedure TDomDocumentFundamentalTests.createProcessingInstructionTest;
const
  TARGET = 'SomeTarget';
  DATA   = 'new PI node';
var
  document : IDomDocument;
  pi       : IDomProcessingInstruction;
begin
  document := fDomImplementation.createDocument('', '', nil);
  pi := document.createProcessingInstruction(TARGET, DATA);
  check(pi.nodeType = PROCESSING_INSTRUCTION_NODE,
          'nodeType <> PROCESSING_INSTRUCTION_NODE');
  check(pi.target = TARGET, 'target <> someTarget');
  check(pi.data = DATA, 'data <> ''new PI node''');
end;



(* creates a text node and checks its properties *)
procedure TDomDocumentFundamentalTests.createTextNodeTest;
const
  NODE_TEXT = 'Some Text';
var
  document : IDomDocument;
  textNode : IDomText;
begin
  document := fDomImplementation.createDocument('', '', nil);
  textNode := document.createTextNode(NODE_TEXT);
  check(textNode.nodeType = TEXT_NODE, 'nodeType <> TEXT_NODE');
  check(textNode.nodeName = '#text', 'nodeName <> #text');
  check(textNode.nodeValue = NODE_TEXT, 'nodeValue <> "Some Text"');
end;


(* checks the name of the docType *)
procedure TDomDocumentFundamentalTests.getDocTypeTest;
const
  XML_VALID_DOC =
         '<?xml version=''1.0''?>' +
         '  <!DOCTYPE address [' +
         '  <!ELEMENT address (#PCDATA)>' +
         '  <!ENTITY ent1 "SomeEntity">' +
         '  ]>' +
         '  <address>some text</address>';
var
  document : IDomDocument;
  docType  : IDomDocumentType;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(XML_VALID_DOC);
  docType := document.docType;
  check(docType.name = 'address', 'docType.name <> ''address''');
end;


(* checks the name of the docType if no DTD is specified *)
procedure TDomDocumentFundamentalTests.getDocTypeNoDTDTest;
const
  XML_VALID_DOC =
         '<?xml version=''1.0''?>' +
         '  <address>some text</address>';
var
  document : IDomDocument;
  docType  : IDomDocumentType;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(XML_VALID_DOC);
  docType := document.docType;
  check(docType = nil, 'docType <> nil');
end;


(* Tests if documentElement is HTML *)
procedure TDomDocumentFundamentalTests.getDocumentElementHTMLTest;
const
  HTML_VALID_DOC =
         '<HTML>' +
         '<HEAD>' +
         '<TITLE>Some Title</TITLE>' +
         '</HEAD>' +
         '<BODY>' +
         'Some Body' +
         '</BODY>' +
         '</HTML>';
var
  document   : IDomDocument;
  docElement : IDomElement;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(HTML_VALID_DOC);
  docElement := document.documentElement;
  check(docElement.nodeName = 'HTML', 'docElement.nodeName <> HTML');
end;

(* checks if getElementById retrieves the correct element *)
procedure TDomDocumentFundamentalTests.getElementByIdXMLNSTest;
const
  XML_VALID_DOC =
     '<?xml version=''1.0''?>' +
     '  <!DOCTYPE someNS:address [' +
     '  <!ELEMENT someNS:address (#PCDATA)>' +
     '  <!ATTLIST someNS:address xmlns:someNS CDATA #IMPLIED>' +
     '  <!ATTLIST someNS:address someNS:someID ID #IMPLIED>' +
     '  ]>' +
     '  <someNS:address xmlns:someNS="http:/localhost" someNS:someID="NAME">' +
     '  some text' +
     '  </someNS:address>';
var
  document : IDomDocument;
  element  : IDomElement;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(XML_VALID_DOC);
  element := document.getElementById('NAME');
  check(element <> nil, 'getElementById(''NAME'') = nil');
  check(element.nodeName = 'someNS:address',
          'element.nodeName <> ''someNs:address''');
end;

(* checks if getElementById returns nil if ID does not exist *)
procedure TDomDocumentFundamentalTests.getElementByIdXMLNSNullTest;
const
  XML_VALID_DOC =
     '<?xml version=''1.0''?>' +
     '  <!DOCTYPE someNS:address [' +
     '  <!ELEMENT someNS:address (#PCDATA)>' +
     '  <!ATTLIST someNS:address xmlns:someNS CDATA #IMPLIED>' +
     '  <!ATTLIST someNS:address someNS:someID ID #IMPLIED>' +
     '  ]>' +
     '  <someNS:address xmlns:someNS="http:/localhost" someNS:someID="NAME">' +
     '  some text' +
     '  </someNS:address>';
var
  document : IDomDocument;
  element  : IDomElement;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(XML_VALID_DOC);
  element := document.getElementById('nonexisting');
  check(element = nil, 'getElementById(''nonexisting'') <> nil');
end;



(* checks if getElementsByTagNameNS('*', '*') returns all elements *)
procedure TDomDocumentFundamentalTests.getElementsByTagNameAllXMLNSTest;
const
  XML_VALID_DOC =
     '<?xml version=''1.0''?>' +
     '  <!DOCTYPE someNS:address [' +
     '  <!ELEMENT someNS:address (someNS:street, someNS:info*)>' +
     '  <!ELEMENT someNS:street (#PCDATA)>' +
     '  <!ELEMENT someNS:info (#PCDATA)>' +
     '  <!ATTLIST someNS:address xmlns:someNS CDATA #IMPLIED>' +
     '  <!ATTLIST someNS:address someNS:someID ID #IMPLIED>' +
     '  ]>' +
     '  <someNS:address xmlns:someNS="http:/localhost" someNS:someID="NAME">' +
     '    <someNS:street>the street</someNS:street>' +
     '    <someNS:info>1</someNS:info>' +
     '    <someNS:info>2</someNS:info>' +
     '    <someNS:info>3</someNS:info>' +
     '    <someNS:info>4</someNS:info>' +
     '  </someNS:address>';
var
  document : IDomDocument;
  nodeList : IDomNodeList;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(XML_VALID_DOC);
  nodeList := document.getElementsByTagNameNS('*', '*');
  check(nodeList.length = 6, 'nodeList.length <> 6');
end;



(* checks if getElementsByTagName returns all elements *)
procedure TDomDocumentFundamentalTests.getElementsByTagNameLengthTest;
const
  XML_VALID_DOC =
     '<?xml version=''1.0''?>' +
     '  <address>' +
     '    <street>the street</street>' +
     '    <info>1' +
     '      <info>2' +
     '        <info>3' +
     '        </info>' +
     '      </info>' +
     '    </info>' +
     '    <info>4</info>' +
     '    <info>5</info>' +
     '  </address>';
var
  document : IDomDocument;
  nodeList : IDomNodeList;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(XML_VALID_DOC);
  nodeList := document.getElementsByTagName('info');
  check(nodeList.length = 5, 'nodeList.length <> 5');
end;



(*
 * checks if getElementsByTagNameNS returns the correct elements in the
 * correct order
*)
procedure TDomDocumentFundamentalTests.getElementsByTagNameSpecifiedXMLNSTest;
const
  XML_VALID_DOC =
     '<?xml version=''1.0''?>' +
     '  <!DOCTYPE someNS:address [' +
     '  <!ELEMENT someNS:address (someNS:street, someNS:info*, info*)>' +
     '  <!ELEMENT someNS:street (someNS:info)*>' +
     '  <!ELEMENT someNS:info (#PCDATA)>' +
     '  <!ELEMENT info (#PCDATA)>' +
     '  <!ATTLIST someNS:address xmlns:someNS CDATA #IMPLIED>' +
     '  ]>' +
     '  <someNS:address xmlns:someNS="http:/localhost">' +
     '    <someNS:street><someNS:info>1</someNS:info></someNS:street>' +
     '    <someNS:info>2</someNS:info>' +
     '    <someNS:info>3</someNS:info>' +
     '    <someNS:info>4</someNS:info>' +
     '    <someNS:info>5</someNS:info>' +
     '    <info>6</info>' +
     '  </someNS:address>';
var
  document : IDomDocument;
  nodeList : IDomNodeList;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(XML_VALID_DOC);
  nodeList := document.getElementsByTagNameNS('*', 'info');
  check(nodeList.length = 6, 'nodeList.length <> 6');
  //XXX TODO: check the order of elements
end;

(*
 * checks if getElementsByTagName('*') returns all elements in the correct order
*)
procedure TDomDocumentFundamentalTests.getElementsByTagNameTotalLengthTest;
const
  XML_VALID_DOC =
     '<?xml version=''1.0''?>' +
     '  <address>' +
     '    <street>0</street>' +
     '    <info1>1' +
     '      <info2>2' +
     '        <info3 someAttr="123">3' +
     '        </info3>' +
     '      </info2>' +
     '    </info1>' +
     '    <info4>4</info4>' +
     '    <info5>5</info5>' +
     '  </address>';
var
  document : IDomDocument;
  nodeList : IDomNodeList;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(XML_VALID_DOC);
  nodeList := document.getElementsByTagName('*');
  check(nodeList.length = 7, 'nodeList.length <> 7');
  check(nodeList.item[0].nodeName = 'address', 'nodeName <> address');
  check(nodeList.item[1].nodeName = 'street', 'nodeName <> street');
  check(nodeList.item[2].nodeName = 'info1', 'nodeName <> info1');
  check(nodeList.item[3].nodeName = 'info2', 'nodeName <> info2');
  check(nodeList.item[4].nodeName = 'info3', 'nodeName <> info3');
  check(nodeList.item[5].nodeName = 'info4', 'nodeName <> info4');
  check(nodeList.item[6].nodeName = 'info5', 'nodeName <> info5');
end;


(*
 * checks if getElementsByTagName('info') returns all elements
*)
procedure TDomDocumentFundamentalTests.getElementsByTagNameValueTest;
const
  XML_VALID_DOC =
     '<?xml version=''1.0''?>' +
     '  <address>' +
     '    <street>0</street>' +
     '    <info>1</info>' +
     '    <info>2</info>' +
     '    <info>3</info>' +
     '  </address>';
var
  document : IDomDocument;
  nodeList : IDomNodeList;
  element  : IDomElement;
  textNode : IDomText;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(XML_VALID_DOC);
  nodeList := document.getElementsByTagName('info');
  element := nodeList.item[2] as IDomElement;
  textNode := element.firstChild as IDomText;
  check(textNode.nodeValue = '3', 'textNode.nodeValue <> ''3''');
end;


(*
 * checks the domImplementation from document
*)
procedure TDomDocumentFundamentalTests.getImplementationTest;
const
  XML_VALID_DOC =
     '<?xml version=''1.0''?>' +
     '  <address>' +
     '  </address>';
var
  document          : IDomDocument;
  domImplementation : IDomImplementation;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(XML_VALID_DOC);
  domImplementation := document.domImplementation;
  check(domImplementation.hasFeature('xml', '1.0'),
          'hasFeature(''xml'', ''1.0'' = false')
end;


(* checks the root node *)
procedure TDomDocumentFundamentalTests.getRootNodeTest;
const
  XML_VALID_DOC =
     '<?xml version=''1.0''?>' +
     '  <address>' +
     '  </address>';
var
  document : IDomDocument;
  element  : IDomElement;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(XML_VALID_DOC);
  element := document.documentElement;
  check(element.nodeName = 'address', 'root name <> ''address''');
end;



(* checks if docType is nil *)
procedure TDomDocumentFundamentalTests.docTypeHTMLNilTest;
const
  HTML_VALID_DOC =
         '<HTML>' +
         '<HEAD>' +
         '<TITLE>Some Title</TITLE>' +
         '</HEAD>' +
         '<BODY>' +
         'Some Body' +
         '</BODY>' +
         '</HTML>';
var
  document : IDomDocument;
begin
  document := DomSetup.getCurrentDomSetup.getDocumentBuilder.
          parse(HTML_VALID_DOC);
  check(document.docType = nil, 'document.docType <> nil');
end;



(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
(*
 * returns a testSuite containing all tests within this suite
 * if new test cases are created they should be added to this function
*)
function getUnitTests : ITestSuite;
var
 suite : TTestSuite;
begin
 suite := TTestSuite.create('Dom Document fundamental tests');
 suite.addSuite(TDomDocumentFundamentalTests.suite);
 result := suite;
end;


end.
