unit DomDocumentTests;

interface

uses
  TestFrameWork,
  xDom2,
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
    fail('EDomException NAMESPACE_ERR should have been thrown');
  except
    on e : EDomException do
      check(e.code = NAMESPACE_ERR, 'NAMESPACE_ERR should have been thrown');
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
  check(fragment.nodeName = '#document-fragment', 'nodeName <> #comment');
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
  check(node.nodeName = ELEMENT_NAME, 'nodeName <> #comment');
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
