unit Main;

interface

uses
  idom2;

implementation

uses
  TestFrameWork,
  DomSetup,
  libxml_impl,
//  libxmldomFE,
  msxml_impl,

  (* add new tests to uses class *)
  DomImplementationTests,
  DomDocumentTests;

(*
 * Returns a TestSuite made up of all individual test suits. This will be used
 * for registering all tests for every Dom VendorID.
 * If a new test suite is created it should be added to this suite
 *
 * @param name the name of the All Test suite
*)
function getAllTests(const name : String) : ITestSuite;
var
 allTestSuite : TTestSuite;
begin
 allTestSuite := TTestSuite.create(name);

 (* add all test suits to the allTestSuite *)
 allTestSuite.addSuite(DomImplementationTests.getUnitTests);
 allTestSuite.addSuite(DomDocumentTests.getUnitTests);

 result := allTestSuite;
end;

procedure RegisterAllTests;
var
  i: integer;
  vlist: IDomVendorList;
  vfact: IDomDocumentBuilderFactory;
  vid: DomString;
begin
  vlist := getDomVendorList;
  if (vlist=nil) then exit;
  for i:=0 to vlist.Count-1 do begin
    vfact := vlist.Item[i];
    vid := vfact.vendorID;
    TestFramework.RegisterTest(createDomSetupTest(vid, getAllTests(vid)));
  end;
end;

initialization
  RegisterAllTests;
end.
