unit Main;

interface

uses
  idom2;

implementation

uses
  TestFrameWork,
  DomSetup,
  msxml_impl,
  {$ifdef FE}
    libxmldomFE,
  {$else}
    libxmldom,
  {$endif}

  (* add new tests to uses class *)

  XPTest_idom2_TestDOM2Methods,
  XPTest_idom2_TestDomExceptions,
  XPTest_idom2_TestMemoryLeaks,
  XPTest_idom2_TestXPath,
  XPTest_idom2_TestXSLT,
  XPTest_idom2_TestPersist,
  DomImplementationTests,
  DomDocumentTests;

(*
 * Returns a TestSuite made up of all individual test suits. This will be used
 * for registering all tests for every Dom VendorID.
 * If a new test suite is created it should be added to this suite
 *
 * @param name the name of the All Test suite
*)
function getAllTests(const Name: string): ITestSuite;
var
  allTestSuite: TTestSuite;
begin
  allTestSuite := TTestSuite.Create(Name);

  (* add all test suits to the allTestSuite *)

  allTestSuite.addSuite(TTestDOM2Methods.Suite);
  allTestSuite.addSuite(TTestDomExceptions.Suite);
  allTestSuite.addSuite(TTestMemoryLeaks.Suite);
  allTestSuite.addSuite(TTestXPath.Suite);
  allTestSuite.addSuite(TTestXSLT.Suite);
  allTestSuite.addSuite(TTestPersist.Suite);
  allTestSuite.addSuite(TDomImplementationFundamentalTests.Suite);
  allTestSuite.addSuite(TDomDocumentFundamentalTests.Suite);

  Result := allTestSuite;
end;

initialization
  (*
   * for every DomVendorID add a new line. This make sure that all tests
   * will be run for every Dom Implementation (specified by VendorID)
  *)

  TestFramework.RegisterTest(DomSetup.createDomSetupTest(MSXML2Rental,
    getAllTests('Ms-DOM Rental')));

  {remove comments to add testing of the Appartment Free Ms version }
  //  TestFramework.RegisterTest(
  //      DomSetup.createDomSetupTest(MSXML2Free, getAllTests('Ms-DOM Free')));

  TestFramework.RegisterTest(DomSetup.createDomSetupTest(SLIBXML, getAllTests('Lib XML 2')));
end.
