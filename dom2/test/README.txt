Test units should be put in Test sub-dir.

Tests can be created like regular DUnit tests:

(make sure uses contains 'TestFrameWork')

example:

  TDomImplementationFundamentalTests = class(TTestCase)
    private
      fDomImplementation : IDomImplementation;

    public
      procedure setup; override;
      procedure tearDown; override;

    published
      procedure hasFeatureXMLTest1;
  end;

registering the tests will not be done within the test unit's implementation
like it is normally done but should be done within the Main.pas unit.
The reason for this is that before all tests are run some setup needs to be done
to setup the Dom Implementation (VendorID) that is used for the tests. This
setup is done by using TTestSetup decorator.

1. Adding new test suites

Adding new test suits requires the following:

- add the test unit to the uses clause of Main.pas
- add the new test suit to the function 'getAllTests' in Main.pas like

  allTestSuite.addSuite(DomImplementationTests.getUnitTests);

  DomImplementationTests contains a conveniance method that creates a testsuit
  containing all tests within the unit (Adding test suits can ofcourse be done
  differently but using a function 'getUnitTests' in all test units makes it
  easier to manage). See DomImplementationTests.pas for an example.

2. Adding support for new Dom Implementation

- Add the dom implementation unit to the uses clause of Main.pas
- Add test registration to the implementation section of Main.pas

  TestFramework.RegisterTest(
      DomSetup.createDomSetupTest('SomeVendorID', getAllTests('Some TestName')));

  createDomSetupTest will create a TTestSetup derived object. TTestSetup will
  start 'Setup' and 'TearDown' before and after all testing for every Dom
  Implementation. 'Setup' will set a global variable
  (gCurrentDomSetup in DomSetup) that references the current IDomSetup. A
  test case should use getCurrentDomSetup (from DomSetup) to get the vendorID
  (getVendorID) and the documentBuilder (getDocumentBuilder). This approach will
  seperate Dom implementation specific things from the test cases and makes sure
  the right documentBuilder is used for each test.







