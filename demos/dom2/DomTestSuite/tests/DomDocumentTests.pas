unit DomDocumentTests;

interface

uses
  TestFrameWork,
  xDom2,
  DomSetup;

const
  (* some test xml docs *)
  XML_VALID_DOC_1 =
         '<?xml version=''1.0''?>' +
         '  <!DOCTYPE testDoc [' +
         '  <!ELEMENT testDoc (#PCDATA)>' +
         '  ]>' +
         '  <testDoc>some text</testDoc>';

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
 * checks if creating a attribute with a qualified name using illegal chars
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
  check(cDataSection.nodeName = '#cdata-section',
          'CDATASection nodeName <> #cdata-section');
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
  check(comment.nodeName = '#comment',
          'comment nodeName <> #comment');
  check(comment.nodeValue = COMMENT_NAME, 'nodevalue not correct');
  check(comment.nodeType = COMMENT_NODE);
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
