{ $Id: TestExtensions.pas,v 1.1 2002-01-10 12:55:31 ufechner Exp $ }
{: DUnit: An XTreme testing framework for Delphi programs.
   @author  The DUnit Group.
   @version $Revision: 1.1 $
}
(*
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code is DUnit.
 *
 * The Initial Developers of the Original Code are Kent Beck, Erich Gamma,
 * and Juancarlo Añez.
 * Portions created The Initial Developers are Copyright (C) 1999-2000.
 * Portions created by The DUnit Group are Copyright (C) 2000-2001.
 * All rights reserved.
 *
 * Contributor(s):
 * Kent Beck <kentbeck@csi.com>
 * Erich Gamma <Erich_Gamma@oti.com>
 * Juanco Añez <juanco@users.sourceforge.net>
 * Chris Morris <chrismo@users.sourceforge.net>
 * Jeff Moore <JeffMoore@users.sourceforge.net>
 * Kenneth Semeijn <kennethsem@users.sourceforge.net>
 * The DUnit group at SourceForge <http://dunit.sourceforge.net>
 *
 *)

// use short strings to be able to handle tests in DLLs.
{$LONGSTRINGS OFF}
unit TestExtensions;

interface

uses
  Classes,
  IniFiles,
  TestFramework;

type
  {: General interface for test decorators}
  ITestDecorator = interface(ITest)
    ['{85DE7EC1-686E-11D4-B323-00C04F5E43B6}']
    {: Get the decorated test
    @return The decorated test }
    function GetTest: ITest;
    property Test: ITest read GetTest;
  end;

  {:A Decorator for Tests. Use TTestDecorator as the base class
    for defining new test decorators. Test decorator subclasses
    can be introduced to add behaviour before or after a test
    is run. }
  TTestDecorator = class(TAbstractTest, ITestDecorator, ITest)
  protected
    FName:  string;
    FTest:  ITest;
    FTests: IInterfaceList;

    function GetTest: ITest;
  public
    {: Decorate a test. If no name parameter is given, the decorator
       will be named as the decorated test, with some extra information
       prepended.
       @param ATest The test to decorate.
       @param AName  Optional name to give to the decorator. }
    constructor Create(ATest: ITest; AName: string = '');

    function  CountTestCases: integer;          override;
    function  CountEnabledTestCases: integer;   override;

    function  GetName: string;                  override;
    function  Tests: IInterfaceList;            override;

    {: Overrides the inherited behavior and executes the
       decorated test's RunBare instead }
    procedure RunBare(ATestResult: TTestResult); override;

    procedure LoadConfiguration(const iniFile :TCustomIniFile; const section :string);  override;
    procedure SaveConfiguration(const iniFile :TCustomIniFile; const section :string);  override;

    property Test: ITest read GetTest;
  end;

  {:A Decorator to set up and tear down additional fixture state.
    Subclass TestSetup and insert it into your tests when you want
    to set up additional state once before the tests are run.
    @example <br>
    <code>
    function UnitTests: ITest;
    begin
      Result := TSetubDBDecorator.Create(TDatabaseTests.Suite, 10);
    end; </code> }
  TTestSetup = class(TTestDecorator)
  protected
  public
    constructor Create(ATest: ITest; AName: string = '');
    procedure RunBare(ATestResult: TTestResult); override;
  end;

 {:A test decorator that runs a test repeatedly.
   Use TRepeatedTest to run a given test or suite a specific number
   of times.
    @example <br>
    <code>
    function UnitTests: ITestSuite;
    begin
      Result := TRepeatedTest.Create(ATestArithmetic.Suite, 10);
    end;
    </code> }
  TRepeatedTest = class(TTestDecorator)
  private
    FTimesRepeat: integer;
  public
    {: Construct decorator that repeats the decorated test.
       The ITest parameter can hold a single test or a suite. The Name parameter
       is optional.
       @param ATest The test to repeat.
       @param Itrations The number of times to repeat the test.
       @param AName An optional name to give to the decorator instance }
    constructor Create(ATest: ITest; Iterations: integer; AName: string = '');
    function  GetName: string;                    override;

    {: Overrides the inherited behavior to included the number of repetitions.
       @return Iterations * inherited CountTestCases }
    function  CountTestCases: integer;            override;

    {: Overrides the inherited behavior to included the number of repetitions.
       @return Iterations * inherited CountEnabledTestCases }
    function  CountEnabledTestCases: integer;     override;

    {: Overrides the behavior of the base class as to execute
       the test repeatedly. }
    procedure RunBare(ATestResult: TTestResult);  override;
  end;

  {: A test decorator for running tests in a separate thread
     @todo Implement this class }
  TActiveTest = class(TTestDecorator)
  end;

  {: A test decorator for running tests expecting a specific exceptions
     to be thrown.
     @todo Implement this class }
  TExceptionTestCase = class(TTestDecorator)
  end;

  {: A test decorator for running tests while checking memory when a test is
   succesfull, expecting the memory to be equal before and after the setup,
   run and teardown.
   This decorator does not function correctly when the tested code
   creates singleton objects or strings that are not set to ''.
   Testing after the normal test run tests the memory with singletons in place.
   The memory test is windows platform specific, because of the GetHeapStatus
   function, which is platform specific. On other platforms, the
   test should not give errors.
    @example <br>
    <code>
    function UnitTests: ITestSuite;
    begin
      Result := TMemoryTest.Create(ATestArithmetic.Suite);
    end;
    </code> }

  EMemoryError = class(ETestFailure);

  TMemoryTestTypes = (mttMemoryTestBeforeNormalTest, mttExecuteNormalTest, mttMemoryTestAfterNormalTest);
  TMemoryTestTypesSet = set of TMemoryTestTypes;

  TMemoryTest = class(TTestDecorator)
  private
    FMemoryTest: TMemoryTestTypesSet;
  protected
    {: Overrides the behavior of the base class as to execute
       the tests twice.
       According to the MemoryTestTypesSet arguments in the constructor
       the test is run.
       First try, without listeners (No GUI) to test the memory without interference.
       Second try, with the listeners in place, but no memory checking.
       Third try, without listeners (No GUI) to test the memory without interference.
     }
    procedure RunMemoryTest(ATestResult: TTestResult); virtual;

    property MemoryTest : TMemoryTestTypesSet read FMemoryTest write FMemoryTest;
  public
    constructor Create(ATest: ITest;
        AMemoryTest : TMemoryTestTypesSet = [mttMemoryTestBeforeNormalTest, mttExecuteNormalTest]);

    function GetName : string; override;

    {: Overrides the behavior of the base class as to execute
       the tests three times.
       First try, without listeners (No GUI) to test the memory without interference.
       Second try, with the listeners in place, but no memory checking.
       Third try, without listeners (No GUI) to test the memory without interference.
       The tests are according to the MemoryTest value set in the constructor.
    }
    procedure RunBare(ATestResult: TTestResult); override;
  end;

  {: A test result class for memory testing execution of a succesfull test
     for memory leaks. Used by the TMemoryTest decorator.
  }
  TMemoryTestResult = class(TTestResult)
  private
    FMemoryAllocatedAtBeginTests : Cardinal;
    FTestResultWithListeners: TTestResult;
    FTestResultOK : boolean;
    function MemoryAllocated: Cardinal;
  protected

    {: Calls TTestCase.RunTestSetup, recording errors.
       @param test The TTestCase.
     }
    function RunTestSetup(test: ITest):boolean; override;

    {: Calls TTestCase.TearDown, recording errors.
       Overriden to get the heap status.
       @param test The TTestCase.
     }
    procedure RunTestTearDown(test: ITest); override;

    {: Calls a TTestCase.RunTest, recording errors.
       Overriden to get the heap status. Here an exception is thrown
       when a difference is detected from the heap status in
       the RunTestSetup.
       @param test The TTestCase.
     }
    function RunTestRun(test: ITest) : boolean; override; 
  public
    {: property TestResultWithListeners : TTestResult;
       The original TestResult instance with which the test is called
       is stored in this property. It is used to communicate the
       MemoryTest failures.
     }
    property TestResultWithListeners : TTestResult read FTestResultWithListeners write FTestResultWithListeners;
  end;


implementation

uses SysUtils;

{ TTestDecorator }

procedure TTestDecorator.RunBare(ATestResult: TTestResult);
begin
  FTest.RunBare(ATestResult);
end;

function TTestDecorator.CountEnabledTestCases: integer;
begin
  if Enabled then
    Result := FTest.countEnabledTestCases
  else
    Result := 0;
end;

function TTestDecorator.CountTestCases: integer;
begin
  if Enabled then
    Result := FTest.countTestCases
  else
    Result := 0;
end;

constructor TTestDecorator.Create(ATest: ITest; AName: string);
begin
  if AName <> '' then
    inherited Create(AName)
  else
    inherited Create(ATest.name);
  FTest := ATest;
  FTests:= TInterfaceList.Create;
  FTests.Add(FTest);
end;

function TTestDecorator.GetTest: ITest;
begin
  Result := FTest;
end;

procedure TTestDecorator.LoadConfiguration(const iniFile: TCustomIniFile; const section: string);
begin
  FTest.LoadConfiguration(iniFile, section)
end;

procedure TTestDecorator.SaveConfiguration(const iniFile: TCustomIniFile; const section: string);
begin
  FTest.SaveConfiguration(iniFile, section)
end;

function TTestDecorator.tests: IInterfaceList;
begin
   Result := FTests;
end;


function TTestDecorator.GetName: string;
begin
  Result := Format('[d] %s', [getTest.Name]);
end;

{ TTestSetup }

constructor TTestSetup.Create(ATest: ITest; AName: string);
begin
  inherited Create(ATest, AName);
end;

procedure TTestSetup.RunBare(ATestResult: TTestResult);
begin
  try
    Setup;
  except
    on E: Exception do
      assert(false, 'Setup failed: ' + e.message);
  end;
  try
    inherited RunBare(ATestResult);
  finally
    try
      TearDown;
    except
      on E: Exception do
        assert(false, 'Teardown failed: ' + e.message);
    end;
  end;
end;

{ TRepeatedTest }

function TRepeatedTest.CountEnabledTestCases: integer;
begin
  Result := inherited CountTestCases * FTimesRepeat;
end;

function TRepeatedTest.CountTestCases: integer;
begin
  Result := inherited CountTestCases * FTimesRepeat;
end;

constructor TRepeatedTest.Create(ATest: ITest; Iterations: integer;
  AName: string);
begin
  inherited Create(ATest, AName);
  FTimesRepeat := Iterations;
end;

function TRepeatedTest.GetName: string;
begin
  Result := Format('%d x %s', [FTimesRepeat, getTest.Name]);
end;

procedure TRepeatedTest.RunBare(ATestResult: TTestResult);
var
  i: integer;
begin
  assert(assigned(ATestResult));

  for i := 0 to FTimesRepeat - 1 do
  begin
    if ATestResult.shouldStop then
      Break;
    inherited RunBare(ATestResult);
  end;
end;

{ TMemoryTest }

constructor TMemoryTest.Create(ATest: ITest;
  AMemoryTest: TMemoryTestTypesSet);
begin
  inherited Create(ATest, '');

  FMemoryTest := AMemoryTest;
end;

function TMemoryTest.GetName: string;
begin
  Result := Format('Test memory of %s', [getTest.Name]);
end;

procedure TMemoryTest.RunMemoryTest(ATestResult : TTestResult);
var aLocalTestResult : TMemoryTestResult;
begin
  // Without listeners, they could interfere with memory
  aLocalTestResult := TMemoryTestResult.Create;
  try
    aLocalTestResult.TestResultWithListeners := ATestResult;
    try
      FTest.RunBare(aLocalTestResult);
    except
      on E : Exception do
        if E is EMemoryError then
          ATestResult.AddError(self, E, nil, '')
    end;
  finally
    aLocalTestResult.Free;
  end;
end;

procedure TMemoryTest.RunBare(ATestResult: TTestResult);
begin
  // Run the memorytest before the normal tests
  if mttMemoryTestBeforeNormalTest in FMemoryTest then
    RunMemoryTest(ATestResult);

  // Run the test again for the listeners
  if mttExecuteNormalTest in FMemoryTest then
    FTest.RunBare(aTestResult);

  // Run the memorytest after the normal tests
  if mttMemoryTestAfterNormalTest in FMemoryTest then
    RunMemoryTest(ATestResult);
end;

{ TMemoryTestResult }

function TMemoryTestResult.MemoryAllocated: Cardinal;
begin
{$IFDEF WIN32}
  Result := GetHeapStatus.TotalAllocated
{$ELSE}
  // Memory check is always correct on other platforms
  Result := 0;
{$ENDIF}
end;

function TMemoryTestResult.RunTestRun(test: ITest): boolean;
begin
  FTestResultOK := inherited RunTestRun(test); {KS}
  Result := FTestResultOK; {KS}
end;

function TMemoryTestResult.RunTestSetup(test: ITest): boolean;
begin
  FMemoryAllocatedAtBeginTests := MemoryAllocated;

  Result := inherited RunTestSetup(test);

  FTestResultOK := Result;
end;

procedure TMemoryTestResult.RunTestTearDown(test: ITest);
var DifferenceMemAllocatedAfterTeardown : Cardinal;
begin

  try

    inherited RunTestTearDown(test);

    if FTestResultOK then // Do the memory test only when the test is OK
    begin
      DifferenceMemAllocatedAfterTeardown := MemoryAllocated - FMemoryAllocatedAtBeginTests;

      if DifferenceMemAllocatedAfterTeardown <> 0 then
      begin
        // Memory has leaked
        raise EMemoryError.CreateFmt('Memory has leaked %d bytes in memory test of %s',
            [DifferenceMemAllocatedAfterTeardown, Test.Name]);
      end;
    end;

  except
    on E : Exception do
      if not Assigned(FTestResultWithListeners) then
        raise // re raise exception, because it cannot be handled
      else
        if E is EMemoryError then
          FTestResultWithListeners.AddError(test, E, nil, '')
        else
          FTestResultWithListeners.AddError(test, E, ExceptAddr, 'TearDown FAILED: ');
  end;
end;

end.

