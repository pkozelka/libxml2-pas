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
