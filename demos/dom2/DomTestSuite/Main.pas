unit Main;

interface

uses
  xDom2;

implementation

uses
  TestFrameWork,
  DomSetup,
  libxmldom,
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

initialization
  (*
   * for every DomVendorID add a new line. This make sure that all tests will
   * will be run for every Dom Implementation (specified by VendorID)
  *)

  TestFramework.RegisterTest(
      DomSetup.createDomSetupTest(MSXML2Rental, getAllTests('Ms-DOM Rental')));

{remove comments to add testing of the Appartment Free Ms version }       
//  TestFramework.RegisterTest(
//      DomSetup.createDomSetupTest(MSXML2Free, getAllTests('Ms-DOM Free')));

  TestFramework.RegisterTest(
      DomSetup.createDomSetupTest(SLIBXML, getAllTests('Lib XML 2')));

end.
