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
      procedure createAttribute;
      (* from documentCreateAttributeMalformedXMLNS.js *)
      procedure createAttributeMalformedXMLNSTest;
      (* from documentCreateAttributeNullXMLNS.js *)
      procedure createAttributeNullXMLNSTest;
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
procedure TDomDocumentFundamentalTests.createAttribute;
var
  document : IDomDocument;
  attr     : IDomAttr;
begin
  document := fDomImplementation.createDocument('', '', nil);
  attr := document.createAttribute('test');
  checkNotNull(attr, 'attr = nil');
  check(attr.nodeName = 'test', 'nodeName <> ''test''');
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
