{#(@)$Id: TestFramework.pas,v 1.1 2002-01-10 12:55:31 ufechner Exp $ }
{  DUnit: An XTreme testing framework for Delphi programs. }
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
 * Uberto Barbini <uberto@usa.net>
 * Brett Shearer <BrettShearer@users.sourceforge.net>
 * Kris Golko <neuromancer@users.sourceforge.net>
 * The DUnit group at SourceForge <http://dunit.sourceforge.net>
 *
 *)

// use short strings to be able to handle tests in DLLs.
{$LONGSTRINGS OFF}
unit TestFramework;

interface
uses
  SysUtils,
  Classes,
  IniFiles;

const
  rcs_id: string = '#(@)$Id: TestFramework.pas,v 1.1 2002-01-10 12:55:31 ufechner Exp $';
  rcs_verion : string = '$Revision: 1.1 $';

type
  TTestMethod  = procedure of object;
  TTestProc    = procedure;

  TTestCaseClass  = class of TTestCase;

  ITestListener   = interface;
  IStatusListener = interface;

  TTestResult   = class;
  TAbstractTest = class;
  TTestCase     = class;
  TTestSuite    = class;
  TTestFailure  = class;

  ExceptionClass = class of Exception;

  ETestFailure = class(EAbort)
     constructor Create;               overload;
     constructor Create(msg :string);  overload;
  end;

  EDunitException = class(Exception);
  ETestError = class(EDunitException);
  EStopTestsFailure = class(EDunitException);


  { thrown to force a debugger break on a test failure }
  EBreakingTestFailure = class(EDunitException)
     constructor Create;               overload;
     constructor Create(msg :string);  overload;
  end;


  ITest = interface(IUnknown)
    ['{2413C6CC-8EFE-4FB1-9469-D14056F4CA22}']
    function GetName: string;

    function  CountTestCases: integer;
    function  CountEnabledTestCases: integer;
    function  Tests: IInterfaceList;


    procedure SetUp;
    procedure TearDown;

    function  Run : TTestResult;  overload;
    procedure Run(testResult: TTestResult); overload;

    procedure RunBare(testResult: TTestResult);
    procedure RunTest;

    function  GetEnabled: boolean;
    procedure SetEnabled(Value: boolean);

    procedure SetStartTime(Value :Int64);
    function  GetStartTime : Int64;

    procedure SetStopTime(Value :Int64);
    function  GetStopTime : Int64;
    function  ElapsedTestTime: Cardinal;


    procedure SetStatusListener(Listener :IStatusListener);
    function  GetStatus :string;

    procedure LoadConfiguration(const iniFile :TCustomIniFile; const section :string);  overload;
    procedure LoadConfiguration(const fileName: string; const UseRegistry: boolean); overload;

    procedure SaveConfiguration(const iniFile :TCustomIniFile; const section :string);  overload;
    procedure SaveConfiguration(const fileName: string; const UseRegistry: boolean); overload;


    property Name:    string  read GetName;
    property Enabled: boolean read GetEnabled write SetEnabled;
    property Status:  string  read GetStatus;

    property StartTime: Int64 read GetStartTime write SetStartTime;
    property StopTime:  Int64 read GetStopTime  write SetStopTime;
  end;


  { IStatusListeners are notified of test status messages }
  IStatusListener = interface
  ['{8681DC88-033C-4A42-84F4-4C52EF9ABAC0}']
    procedure Status(test :ITest; const Msg :string);
  end;



  { ITestListeners get notified of testing events.
    See TTestResult.AddListener()
  }
  ITestListener = interface(IStatusListener)
  ['{8E99FC5B-0B22-4FCF-B6BD-1F9B19E23591}']

    procedure TestingStarts;
    procedure StartTest(test: ITest);

    procedure AddSuccess(test: ITest);
    procedure AddError(error: TTestFailure);
    procedure AddFailure(Failure: TTestFailure);

    procedure EndTest(test: ITest);
    procedure TestingEnds(testResult :TTestResult);
  end;

  // a named collection of tests
  ITestSuite = interface(ITest)
  ['{715DF8E6-9925-11D3-992E-00207813339E}']

    procedure AddTest(test: ITest);
    procedure AddSuite(suite : ITestSuite);
  end;


  {  Adapter to allow a TTestResult to receive status messages
     from the running test }
  TStatusToResultAdapter = class(TInterfacedObject, IStatusListener)
  protected
    FTestResult :TTestResult;
  public
    constructor Create(TestResult :TTestResult);
    procedure   Status(Test :ITest; const Msg :string);
  end;

  { A TTestResult collects the results of executing a test case.
  And notifies registered ITestListener of testing events. }
  TTestResult = class(TObject)
  private
    FTotalTime: Int64;
  protected
    fFailures: TList;
    fErrors: TList;
    fListeners: IInterfaceList;
    fRunTests: integer;
    fStop: boolean;
    FBreakOnFailures :boolean;

    FStatusAdapter :IStatusListener;

    procedure Run(test: ITest); virtual;
    function  RunTestSetup(test: ITest):boolean; virtual;
    procedure RunTestTearDown(test: ITest); virtual;
    function  RunTestRun(test: ITest) : boolean; virtual;

    procedure TestingStarts;                           virtual;
    procedure StartTest(test: ITest);                  virtual;
    procedure Status(test :ITest; const Msg :string);  virtual;
    procedure EndTest(test: ITest);                     virtual;
    procedure TestingEnds;                              virtual;
  public

    constructor Create;
    destructor  Destroy; override;

    procedure AddListener(listener: ITestListener); virtual;

    procedure RunSuite(test: ITest);  overload;
    procedure AddSuccess(test: ITest);                                                              virtual;
    function  AddFailure(test: ITest; e: Exception; addr :Pointer): TTestFailure;                   virtual;
    function  AddError(  test: ITest; e: Exception; addr :Pointer; msg :string = ''): TTestFailure; virtual;


    procedure Stop; virtual;
    function  ShouldStop: boolean; virtual;

    function RunCount: integer;     virtual;
    function ErrorCount: integer;   virtual;
    function FailureCount: integer; virtual;

    function  Errors: TList;   virtual;
    function  Failures: TList; virtual;

    function  WasStopped :boolean; virtual;
    function  WasSuccessful: boolean; virtual;

    property  BreakOnFailures :boolean read  FBreakOnFailures write FBreakOnFailures;
    property  TotalTime: Int64 read FTotalTime;
  end;


  TAbstractTest = class(TInterfacedObject, ITest)
  protected
    FTestName: string;
    fEnabled: boolean;

    fStartTime: Int64;
    fStopTime:  Int64;

    FStatusListener :IStatusListener;
    FStatusStrings  :TStrings;

    procedure RunBare(testResult: TTestResult); virtual; abstract;
    procedure RunTest; virtual;

    procedure SetUp; virtual;
    procedure TearDown; virtual;

    procedure SetStartTime(Value :Int64); virtual;
    function  GetStartTime : Int64;       virtual;

    procedure SetStopTime(Value :Int64);  virtual;
    function  GetStopTime : Int64;        virtual;
  public
    constructor Create(Name: string);
    destructor Destroy; override;

    function GetName: string; virtual;

    function  GetEnabled: boolean; virtual;
    procedure SetEnabled(value: boolean); virtual;

    function  Tests: IInterfaceList; virtual;

    function  CountTestCases: integer; virtual;
    function  CountEnabledTestCases: integer; virtual;

    function  Run: TTestResult; overload;
    procedure Run(testResult: TTestResult); overload;

    function  ElapsedTestTime: Cardinal; virtual;

    procedure SetStatusListener(Listener :IStatusListener);
    procedure Status(const Msg :string);
    function  GetStatus :string;

    procedure LoadConfiguration(const fileName: string; const UseRegistry: boolean); overload;
    procedure LoadConfiguration(const iniFile :TCustomIniFile; const section :string);  overload; virtual;
    procedure SaveConfiguration(const fileName: string; const UseRegistry: boolean); overload;
    procedure SaveConfiguration(const iniFile :TCustomIniFile; const section :string);  overload; virtual;


    property Name:    string  read GetName;
    property Enabled: boolean read GetEnabled write SetEnabled;
  end;



  TTestCase = class(TAbstractTest, ITest)
  protected
    fMethod:    TTestMethod;
    fExpectedException: ExceptionClass;

    procedure RunBare(testResult: TTestResult); override;
    procedure RunTest; override;

    function  BoolToStr(ABool: boolean): string;

    procedure Check(condition: boolean; msg: string = ''); virtual;
    procedure CheckEquals(expected, actual: double; delta: double = 0; msg: string = ''); overload; virtual;
    procedure CheckEquals(expected, actual: currency; msg: string = ''); overload; virtual;
    procedure CheckEquals(expected, actual: integer; msg: string = ''); overload; virtual;
    procedure CheckEquals(expected, actual: string; msg: string = ''); overload; virtual;
    procedure CheckEquals(expected, actual: boolean; msg: string = ''); overload; virtual;

    procedure CheckNotEquals(expected, actual: integer; msg: string = ''); overload; virtual;
    procedure CheckNotEquals(expected: double; actual: double; delta: double = 0; msg: string = ''); overload; virtual;
    procedure CheckNotEquals(expected, actual: string; msg: string = ''); overload; virtual;
    procedure CheckNotEquals(expected, actual: boolean; msg: string = ''); overload; virtual;

    procedure CheckNotNull(obj :IUnknown; msg :string = ''); overload; virtual;
    procedure CheckNull(obj: IUnknown; msg: string = ''); overload; virtual;
    procedure CheckSame(expected, actual: IUnknown; msg: string = ''); overload; virtual;
    procedure CheckSame(expected, actual: TObject; msg: string = ''); overload; virtual;

    procedure CheckNotNull(obj: TObject; msg: string = ''); overload; virtual;
    procedure CheckNull(obj: TObject; msg: string = ''); overload; virtual;

    procedure CheckException(AMethod: TTestMethod; AExceptionClass: TClass; msg :string = '');
    procedure CheckEquals(  expected, actual: TClass; msg: string = ''); overload; virtual;
    procedure CheckInherits(expected, actual: TClass; msg: string = ''); overload; virtual;
    procedure CheckIs(obj :TObject; klass: TClass; msg: string = ''); overload; virtual;

    procedure Fail(msg: string; errorAddr: Pointer = nil); overload; virtual;
    procedure FailEquals(expected, actual: string; msg: string = ''; errorAddr: Pointer = nil); virtual;
    procedure FailNotEquals(expected, actual: string; msg: string = ''; errorAddr: Pointer = nil); virtual;
    procedure FailNotSame(expected, actual: string; msg: string = ''; errorAddr: Pointer = nil); virtual;

    function EqualsErrorMessage(expected, actual, msg: string): string;
    function NotEqualsErrorMessage(expected, actual, msg: string): string;
    function NotSameErrorMessage(expected, actual, msg: string): string;

    procedure StopTests(msg: String = ''); virtual;

    procedure CheckMethodIsNotEmpty(MethodPointer: pointer);

    procedure StartExpectingException(e: ExceptionClass);
    procedure StopExpectingException(Msg :string = '');

    property ExpectedException :ExceptionClass
      read  fExpectedException
      write StartExpectingException;
  public
    constructor Create(MethodName: string); virtual;

    class function Suite: ITestSuite; virtual;

    procedure Run(testResult: TTestResult); overload;
  published
  end;


  TTestSuite = class(TAbstractTest, ITestSuite, ITest)
  protected
    fTests: IInterfaceList;
  public
    constructor Create; overload;
    constructor Create(Name: string); overload;
    constructor Create(TestClass: TTestCaseClass); overload;
    constructor Create(Name: string; const Tests: array of ITest); overload;

    function CountTestCases: integer;         override;
    function CountEnabledTestCases: integer;  override;

    function Tests: IInterfaceList;                 override;
    procedure AddTest(ATest: ITest);                virtual;
    procedure AddTests(testClass: TTestCaseClass);  virtual;
    procedure AddSuite(suite:  ITestSuite);         virtual;

    procedure RunBare(testResult: TTestResult); override;

    procedure LoadConfiguration(const iniFile: TCustomIniFile; const section: string);  override;
    procedure SaveConfiguration(const iniFile: TCustomIniFile; const section: string);  override;
  end;


  TTestFailure = class(TObject)
  protected
    fFailedTest: ITest;
    fThrownExceptionClass: TClass;
    fThrownExceptionMessage: string;
    FThrownExceptionAddress: Pointer;
    FStackTrace:             string;

    procedure CaptureStackTrace;
  public
    constructor Create(failedTest: ITest; thrownException: Exception; Addr: Pointer; msg: string = '');

    function FailedTest: ITest; virtual;
    function ThrownExceptionClass: TClass; virtual;
    function ThrownExceptionName: string; virtual;
    function ThrownExceptionMessage: string; virtual;
    function ThrownExceptionAddress: pointer; virtual;

    function LocationInfo: string; virtual;
    function AddressInfo:  string; virtual;

    function StackTrace:   string; virtual;
  end;


  TMethodEnumerator = class
  protected
    FMethodNameList:  array of string;
    function GetNameOfMethod(Index: integer):  string;
    function GetMethodCount: Integer;
  public
    constructor Create(AClass: TClass);
    property MethodCount: integer read GetMethodCount;
    property NameOfMethod[index:  integer]: string read GetNameOfMethod;
  end;


// creating suites
function  TestSuite(name: string; const Tests: array of ITest): ITestSuite;

// test registry
procedure RegisterTest(SuitePath: string; test: ITest); overload;
procedure RegisterTest(test: ITest);                    overload;
procedure RegisterTests(SuitePath: string; const Tests: array of ITest);  overload;
procedure RegisterTests(const Tests: array of ITest);                     overload;
function  RegisteredTests: ITestSuite;
procedure ClearRegistry;

// running tests
function RunTest(suite: ITest; listeners: array of ITestListener): TTestResult; overload;
function RunRegisteredTests(listeners: array of ITestListener): TTestResult;


// utility routines
function CallerAddr: Pointer; assembler;
function PtrToStr(p: Pointer): string;
function PointerToLocationInfo(Addr: Pointer): string;
function PointerToAddressInfo(Addr: Pointer):  string;

///////////////////////////////////////////////////////////////////////////
implementation
uses
{$IFDEF LINUX}
  Libc,
{$ELSE}
  Windows,
  Registry,
{$ENDIF}
{$IFDEF USE_JEDI_JCL}
 JclDebug,
 {$ENDIF}
 TypInfo;

{$STACKFRAMES ON} //required to retreive caller's address

{$IFDEF LINUX}

var
  PerformanceCounterInitValue: Int64;

procedure InitPerformanceCounter;
var
  TV : TTimeVal;
  TZ : TTimeZone;
begin
  gettimeofday(TV, TZ);
  PerformanceCounterInitValue :=
    LongWord(TV.tv_sec mod (24*60*60) * 1000) + (LongWord(TV.tv_usec) div 1000);
end;

function QueryPerformanceCounter(var PerformanceCounter: Int64): LongBool;
var
  TV : TTimeVal;
  TZ : TTimeZone;
begin
  gettimeofday(TV, TZ);
  PerformanceCounter := (TV.tv_sec mod (24*60*60) * 1000) +
            (TV.tv_usec div 1000);
  PerformanceCounter := PerformanceCounter - PerformanceCounterInitValue;
  Result := true;
end;

function QueryPerformanceFrequency(var Frequency: Int64): LongBool;
begin
  Frequency := 1000;
  Result := true;
end;
{$ENDIF}

{: Convert a pointer into its string representation }
function PtrToStr(p: Pointer): string;
begin
   Result := Format('%p', [p])
end;

function IsBadPointer(P: Pointer):boolean; register;
begin
  try
    Result  := (p = nil)
              or ((Pointer(P^) <> P) and (Pointer(P^) = P));
  except
    Result := false
  end
end;


function CallerAddr: Pointer; assembler;
const
  CallerIP = $4;
asm
   mov   eax, ebp
   call  IsBadPointer
   test  eax,eax
   jne   @@Error

   mov   eax, [ebp].CallerIP
   sub   eax, 5   // 5 bytes for call

   push  eax
   call  IsBadPointer
   test  eax,eax
   pop   eax
   je    @@Finish

@@Error:
   xor eax, eax
@@Finish:
end;

{$IFNDEF USE_JEDI_JCL}
function PointerToLocationInfo(Addr: Pointer): string;
begin
 Result := ''
end;

function PointerToAddressInfo(Addr: Pointer): string;
begin
 Result := '$'+PtrToStr(Addr);
end;

{$ELSE}
function PointerToLocationInfo(Addr: Pointer): string;
var
  _file,
  _module,
  _proc: AnsiString;
  _line: integer;
begin
  JclDebug.MapOfAddr(Addr, _file, _module, _proc, _line);

  if _file <> '' then
    Result   := Format('%s:%d', [_file, _line])
  else
    Result   := _module;
end;

function PointerToAddressInfo(Addr: Pointer): string;
var
  _file,
  _module,
  _proc: AnsiString;
  _line: integer;
begin
  JclDebug.MapOfAddr(Addr, _file, _module, _proc, _line);
  Result := Format('%s$%p', [_proc, Addr]);
end;
{$ENDIF}


{ TTestResult }

constructor TTestResult.Create;
begin
  inherited Create;
  fFailures := TList.Create;
  fErrors := TList.Create;
  fListeners := TInterfaceList.Create;
  fRunTests := 0;
  fStop := false;

  FStatusAdapter := TStatusToResultAdapter.Create(Self);
end;

destructor TTestResult.destroy;
var
  i: Integer;
begin
  fListeners := nil;
  for i := 0 to fErrors.Count - 1 do
  begin
    TTestFailure(fErrors[i]).Free;
  end;
  fErrors.Free;
  for i := 0 to fFailures.Count - 1 do
  begin
    TTestFailure(fFailures[i]).Free;
  end;
  fFailures.Free;
  inherited Destroy;
end;

procedure TTestResult.AddSuccess(test: ITest);
var
  i: integer;
begin
  assert(assigned(test));
  for i := 0 to fListeners.count - 1 do
  begin
    (fListeners[i] as ITestListener).AddSuccess(test);
  end;
end;

function TTestResult.AddError(test: ITest; e: Exception; addr: Pointer; msg: string): TTestFailure;
var
  i: integer;
  error:  TTestFailure;
begin
  assert(assigned(test));
  assert(assigned(e));
  assert(assigned(fErrors));

  error := TTestFailure.Create(test, e, addr, msg);
  fErrors.add(error);
  for i := 0 to fListeners.count - 1 do
  begin
    (fListeners[i] as ITestListener).AddError(error);
  end;

  assert(assigned(error));
  Result := error;
end;

function TTestResult.AddFailure(test: ITest; e: Exception; addr: Pointer): TTestFailure;
var
  i: integer;
  Failure:  TTestFailure;
begin
  assert(assigned(test));
  assert(assigned(e));
  assert(assigned(fFailures));

  Failure := TTestFailure.Create(test, e, addr);
  fFailures.add(Failure);
  for i := 0 to fListeners.count - 1 do
  begin
    (fListeners[i] as ITestListener).AddFailure(Failure);
  end;

  assert(assigned(Failure));
  Result := Failure;
end;

procedure TTestResult.addListener(listener: ITestListener);
begin
  assert(assigned(listener), 'listener is nil');
  fListeners.add(listener);
end;

procedure TTestResult.EndTest(test: ITest);
var
  i: integer;
begin
  assert(assigned(fListeners));

  try
    for i := 0 to fListeners.count - 1 do
    begin
      (fListeners[i] as ITestListener).EndTest(test);
    end;
  finally
    test.SetStatusListener(nil);
  end;
end;

procedure TTestResult.Status(test: ITest; const Msg: string);
var
  i: integer;
begin
  assert(assigned(fListeners));

  try
    for i := 0 to fListeners.count - 1 do
    begin
      (fListeners[i] as ITestListener).Status(test, Msg);
    end;
  finally
    test.SetStatusListener(nil);
  end;
end;


function TTestResult.errors: TList;
begin
  result := fErrors;
end;

function TTestResult.Failures: TList;
begin
  result := fFailures;
end;

function TTestResult.RunTestSetup(test: ITest):boolean;
var
  Time :Int64;
begin
  try
    test.StopTime  := 0;
    QueryPerformanceCounter(Time);
    test.StartTime := Time;
    test.SetUp;
    Result := true;
  except
    on e: Exception do
    begin
      AddError(test, e, ExceptAddr, 'SetUp FAILED: ');
      Result := false;
    end
  end;
end;

procedure TTestResult.RunTestTearDown(test: ITest);
var
  Time :Int64;
begin
  try
    test.TearDown;
  except
    on e: Exception do
      AddError(test, e, ExceptAddr, 'TearDown FAILED: ');
  end;
  QueryPerformanceCounter(Time);
  test.StopTime := Time;
end;

function TTestResult.RunTestRun(test: ITest) : boolean;
var
  failure: TTestFailure;
begin
  Result := false;
  failure := nil;
  {$IFDEF USE_JEDI_JCL}
  try
    JclStartExceptionTracking;
  {$ENDIF}
    try
      test.RunTest;
      fTotalTime := test.ElapsedTestTime + fTotalTime;
      AddSuccess(test);
      Result := true;
    except
      on e: EStopTestsFailure do
      begin
        failure := AddFailure(test, e, ExceptAddr);
        FStop := True;
      end;
      on e: ETestFailure do
      begin
        failure := AddFailure(test, e, ExceptAddr);
      end;
      on e: EBreakingTestFailure do
      begin
        failure := AddFailure(test, e, ExceptAddr);
      end;
      on e: Exception do
      begin
        failure := AddError(test, e, ExceptAddr);
      end;
    end;
  {$IFDEF USE_JEDI_JCL}
  finally
    JclStopExceptionTracking;
  end;
  {$ENDIF}
  if BreakOnFailures
  and (failure <> nil)
  and (failure.FThrownExceptionClass.InheritsFrom(ETestFailure))
  then
  begin
    try
       raise EBreakingTestFailure.Create(failure.ThrownExceptionMessage)
          at failure.ThrownExceptionAddress;
    except
    end;
  end;
end;

procedure TTestResult.Run(test: ITest);
begin
  assert(assigned(test));
  if not ShouldStop then
  begin
    StartTest(test);
    try
      if RunTestSetUp(test) then
      begin
        RunTestRun(test);
      end;
      RunTestTearDown(test);
    finally
      EndTest(test);
    end;
  end;
end;

function TTestResult.RunCount: integer;
begin
  result := fRunTests;
end;

function TTestResult.ShouldStop: boolean;
begin
  result := fStop;
end;

procedure TTestResult.StartTest(test: ITest);
var
  i: integer;
begin
  assert(assigned(test));
  assert(assigned(fListeners));

  test.SetStatusListener(FStatusAdapter);

  for i := 0 to fListeners.count - 1 do
  begin
    (fListeners[i] as ITestListener).StartTest(test);
  end;
  inc(fRunTests);
end;

procedure TTestResult.Stop;
begin
  fStop := true;
end;

function TTestResult.ErrorCount: integer;
begin
  assert(assigned(fErrors));

  result := fErrors.count;
end;

function TTestResult.FailureCount: integer;
begin
  assert(assigned(fFailures));

  result := fFailures.count;
end;

function TTestResult.WasSuccessful: boolean;
begin
  result := (FailureCount = 0) and (ErrorCount() = 0) and not WasStopped;
end;

procedure TTestResult.TestingStarts;
var
  i: Integer;
begin
  for i := 0 to fListeners.count - 1 do
  begin
    (fListeners[i] as ITestListener).TestingStarts;
  end;
end;

procedure TTestResult.TestingEnds;
var
  i: Integer;
begin
  for i := 0 to fListeners.count - 1 do
  begin
    (fListeners[i] as ITestListener).TestingEnds(self);
  end;
end;

function TTestResult.WasStopped: boolean;
begin
  result := fStop;
end;

procedure TTestResult.RunSuite(test: ITest);
begin
  TestingStarts;
  try
    test.RunBare(self);
  finally
    TestingEnds
  end
end;

{ TStatusToResultAdapter }

constructor TStatusToResultAdapter.Create(TestResult: TTestResult);
begin
  Assert(TestResult <> nil, 'Expected non nil TestResult');
  inherited Create;

  FTestResult := TestResult;
end;

procedure TStatusToResultAdapter.Status(Test: ITest; const Msg: string);
begin
  FTestResult.Status(Test, Msg);
end;

{ TAbstractTest }

constructor TAbstractTest.Create(Name: string);
begin
  inherited Create;
  FTestName := Name;
  FEnabled  := true;
end;

destructor TAbstractTest.Destroy;
begin
  FStatusStrings.Free;
  inherited;
end;

procedure TAbstractTest.Run(testResult: TTestResult);
begin
  testResult.RunSuite(self);
end;

function TAbstractTest.CountEnabledTestCases: integer;
begin
  if GetEnabled then
    Result := 1
  else
    Result := 0
end;

function TAbstractTest.CountTestCases: integer;
begin
  Result := 1;
end;

function TAbstractTest.getEnabled: boolean;
begin
  Result := fEnabled
end;

function TAbstractTest.GetName: string;
begin
  Result := fTestName
end;

procedure TAbstractTest.LoadConfiguration(const fileName: string; const UseRegistry: boolean);
var
  f: TCustomIniFile;
begin
{$IFDEF MSWINDOWS}
  if UseRegistry then
    f := TRegistryIniFile.Create(fileName)
  else
{$ENDIF}
    f := TIniFile.Create(fileName);

  try
    LoadConfiguration(f, 'Tests')
  finally
    f.free
  end
end;

procedure TAbstractTest.LoadConfiguration(const iniFile: TCustomIniFile; const section: string);
begin
  self.setEnabled(iniFile.readBool(section, self.GetName, True));
end;

procedure TAbstractTest.SaveConfiguration(const fileName: string; const UseRegistry: boolean);
var
  f: TCustomIniFile;
begin
{$IFDEF MSWINDOWS}
  if UseRegistry then
    f := TRegistryIniFile.Create(fileName)
  else
{$ENDIF}
    f := TIniFile.Create(fileName);

  try
    SaveConfiguration(f, 'Tests');
    f.UpdateFile;
  finally
    f.free
  end
end;

procedure TAbstractTest.SaveConfiguration(const iniFile: TCustomIniFile; const section: string);
begin
  iniFile.writeBool(section, self.GetName, self.getEnabled);
end;

function TAbstractTest.Run: TTestResult;
var
  testResult:  TTestResult;
begin
  testResult := TTestResult.Create;
  try
    testResult.RunSuite(self);
  except
    testResult.Free;
    raise;
  end;
  Result := testResult;
end;

procedure TAbstractTest.setEnabled(value: boolean);
begin
  fEnabled := value;
end;

var
  EmptyTestList: IInterfaceList = nil;

function TAbstractTest.Tests: IInterfaceList;
begin
   if EmptyTestList = nil then
     EmptyTestList := TInterfaceList.Create;
   Result := EmptyTestList;
end;


function TAbstractTest.GetStartTime: Int64;
begin
  Result := FStartTime
end;

procedure TAbstractTest.SetStartTime(Value: Int64);
begin
  FStartTime := Value;
end;

procedure TAbstractTest.SetStopTime(Value: Int64);
begin
  FStopTime := Value;
end;

function TAbstractTest.GetStopTime: Int64;
begin
  Result := FStopTime;
end;

procedure TAbstractTest.SetUp;
begin
 // do nothing
end;

procedure TAbstractTest.TearDown;
begin
  // do nothing
end;

procedure TAbstractTest.RunTest;
begin
  // do nothing
end;

function TAbstractTest.ElapsedTestTime: Cardinal;
var
  Freq, Time: Int64;
begin
// returns TestTime in millisecs
  if fStopTime > 0 then
    Time := fStopTime
  else
    QueryPerformanceCounter(Time);
  Time := Time - fStartTime;
  if QueryPerformanceFrequency(Freq) then
    Result := (1000*Time) div Freq
  else
    Result := 0;
end;


procedure TAbstractTest.SetStatusListener(Listener: IStatusListener);
begin
  FStatusListener := Listener;
end;

function TAbstractTest.GetStatus: string;
begin
  if FStatusStrings = nil then
    Result := ''
  else
    Result := FStatusStrings.Text;
end;

procedure TAbstractTest.Status(const Msg: string);
begin
  if FStatusStrings = nil then
    FStatusStrings := TStringList.Create;
  FStatusStrings.Add(Msg);
  if FStatusListener <> nil then
    FStatusListener.Status(self, Msg);
end;

{ TTestCase }

constructor TTestCase.Create(MethodName: string);
var
  RunMethod: TMethod;
begin
  assert(length(MethodName) >0);
  assert(assigned(MethodAddress(MethodName)));

  inherited Create(MethodName);
  RunMethod.code := MethodAddress(MethodName);
  RunMethod.Data := self;
  fMethod := TTestMethod(RunMethod);

  assert(assigned(fMethod));
end;

procedure TTestCase.RunBare(testResult: TTestResult);
begin
  assert(assigned(testResult));

  if getEnabled then
  begin
    testResult.Run(self);
  end;
end;

procedure TTestCase.RunTest;
begin
  assert(assigned(fMethod), 'Method "' + FTestName + '" not found');
  fExpectedException := nil;
  try
    CheckMethodIsNotEmpty(tMethod(fMethod).Code);
    fMethod;
  except
    on E: Exception  do
    begin
      if  not Assigned(fExpectedException) then
        raise
      else if not E.ClassType.InheritsFrom(fExpectedException) then
         FailNotEquals(fExpectedException.ClassName, E.ClassName, 'unexpected exception', ExceptAddr)
      else
        fExpectedException := nil;
    end
  end;
  StopExpectingException;
end;

procedure TTestCase.Check(condition: boolean; msg: string);
begin
    if (not condition) then
        Fail(msg, CallerAddr);
end;

procedure TTestCase.Fail(msg: string; errorAddr: Pointer = nil);
begin
  if errorAddr = nil then
    raise ETestFailure.Create(msg) at CallerAddr
  else
    raise ETestFailure.Create(msg) at errorAddr;
end;

procedure TTestCase.StopTests(msg: String);
begin
  raise EStopTestsFailure.Create(msg);
end;

procedure TTestCase.Run(testResult: TTestResult);
begin
  testResult.RunSuite(self);
end;

procedure TTestCase.FailNotEquals( expected,
                                   actual   : string;
                                   msg      : string = '';
                                   errorAddr: Pointer = nil);
begin
    Fail(notEqualsErrorMessage(expected, actual, msg), errorAddr);
end;

procedure TTestCase.FailEquals( expected,
                                actual   : string;
                                msg      : string = '';
                                errorAddr: Pointer = nil);
begin
    Fail(EqualsErrorMessage(expected, actual, msg), errorAddr);
end;

procedure TTestCase.FailNotSame( expected,
                                 actual   : string;
                                 msg      : string = '';
                                 errorAddr: Pointer = nil);
begin
    Fail(NotSameErrorMessage(expected, actual, msg), errorAddr);
end;

procedure TTestCase.CheckEquals( expected,
                                 actual   : double;
                                 delta    : double = 0;
                                 msg      : string = '');
begin
    if (abs(expected-actual) > delta) then
        FailNotEquals(FloatToStr(expected), FloatToStr(actual), msg, CallerAddr);
end;

procedure TTestCase.CheckEquals( expected,
                                 actual   : currency;
                                 msg      : string = '');
begin
  if actual <> expected then
    FailNotEquals(FloatToStr(expected), FloatToStr(actual), msg, CallerAddr);
end;

procedure TTestCase.CheckNotNull(obj: IUnknown; msg: string);
begin
    if obj = nil then
      Fail(msg, CallerAddr);
end;

procedure TTestCase.CheckNull(obj: IUnknown; msg: string);
begin
    if obj <>  nil then
      Fail(msg, CallerAddr);
end;

procedure TTestCase.CheckSame(expected, actual: IUnknown; msg: string = '');
begin
    if (expected <> actual) then
      FailNotSame(PtrToStr(Pointer(expected)), PtrToStr(Pointer(actual)), msg, CallerAddr);
end;

procedure TTestCase.CheckEquals(expected, actual: string; msg: string = '');
begin
   if expected <> actual then begin
      FailNotEquals(expected, actual, msg, CallerAddr);
   end
end;

procedure TTestCase.CheckNotEquals(expected, actual: string; msg: string = '');
begin
   if expected = actual then begin
      FailEquals(expected, actual, msg, CallerAddr);
   end
end;

procedure TTestCase.CheckEquals(expected, actual: integer; msg: string);
begin
  if (expected <> actual) then
    FailNotEquals(IntToStr(expected), IntToStr(actual), msg, CallerAddr);
end;

procedure TTestCase.CheckNotEquals(expected, actual: integer; msg: string = '');
begin
  if expected = actual then
    FailEquals(IntToStr(expected), IntToStr(actual), msg, CallerAddr);
end;

procedure TTestCase.CheckNotEquals(expected: double; actual: double; delta: double = 0; msg: string = '');
begin
    if (abs(expected-actual) <= delta) then
        FailNotEquals(FloatToStr(expected), FloatToStr(actual), msg, CallerAddr);
end;

procedure TTestCase.CheckEquals(expected, actual: boolean; msg: string);
begin
  if (expected <> actual) then
    FailNotEquals(BoolToStr(expected), BoolToStr(actual), msg, CallerAddr);
end;

procedure TTestCase.CheckNotEquals(expected, actual: boolean; msg: string);
begin
  if (expected = actual) then
    FailEquals(BoolToStr(expected), BoolToStr(actual), msg, CallerAddr);
end;

procedure TTestCase.CheckSame(expected, actual: TObject; msg: string);
begin
    if (expected <> actual) then
      FailNotSame(PtrToStr(Pointer(expected)), PtrToStr(Pointer(actual)), msg, CallerAddr);
end;

procedure TTestCase.CheckNotNull(obj: TObject; msg: string);
begin
    if obj = nil then
       FailNotSame('object', PtrToStr(Pointer(obj)), msg, CallerAddr);
end;

procedure TTestCase.CheckNull(obj: TObject; msg: string);
begin
    if obj <> nil then
       FailNotSame('nil', PtrToStr(Pointer(obj)), msg, CallerAddr);
end;

function TTestCase.NotEqualsErrorMessage(expected, actual: string; msg: string): string;
begin
    if (msg <> '') then
        msg := msg + ', ';
    Result := Format('%sexpected: <%s> but was: <%s>', [msg, expected, actual])
end;

function TTestCase.EqualsErrorMessage(expected, actual: string; msg: string): string;
begin
    if (msg <> '') then
        msg := msg + ', ';
    Result := Format('%sexpected and actual were: <%s>', [msg, expected])
end;

function TTestCase.NotSameErrorMessage(expected, actual, msg: string): string;
begin
    if (msg <> '') then
        msg := msg + ', ';
    Result := Format('%sexpected: <%s> but was: <%s>', [msg, expected, actual])
end;

class function TTestCase.Suite: ITestSuite;
begin
  Result := TTestSuite.Create(self);
end;

function TTestCase.BoolToStr(ABool: boolean): string;
begin
	Result := BooleanIdents[aBool];
end;

procedure TTestCase.StartExpectingException(e: ExceptionClass);
begin
  StopExpectingException;
  fExpectedException := e;
end;

procedure TTestCase.StopExpectingException(Msg :string);
begin
  if fExpectedException <> nil then
    raise ETestFailure.Create(Format('Expected exception <%s> but there was none. %s', [fExpectedException.ClassName, Msg]));
end;

procedure TTestCase.CheckMethodIsNotEmpty(MethodPointer: pointer);
const
  AssemblerRet = $C3;
begin
  if byte(MethodPointer^) = AssemblerRet then
    fail('Empty test', MethodPointer);
end;

procedure TTestCase.CheckException(AMethod: TTestMethod; AExceptionClass: TClass; msg :string);
begin
  try
    AMethod;
  except
    on e :Exception do
    begin
      if  not Assigned(AExceptionClass) then
        raise
      else if not e.ClassType.InheritsFrom(AExceptionClass) then
        FailNotEquals(AExceptionClass.ClassName, e.ClassName, msg, CallerAddr)
      else
        AExceptionClass := nil;
    end;
  end;
  if Assigned(AExceptionClass) then
    FailNotEquals(AExceptionClass.ClassName, 'nothing', msg, CallerAddr)
end;

procedure TTestCase.CheckEquals(expected, actual: TClass; msg: string);
begin
 if expected <> actual then
 begin
   if expected = nil then
     FailNotEquals('nil', actual.ClassName, msg, CallerAddr)
   else if actual = nil then
     FailNotEquals(expected.ClassName, 'nil', msg, CallerAddr)
   else
     FailNotEquals(expected.ClassName, actual.ClassName, msg, CallerAddr)
 end;
end;

procedure TTestCase.CheckInherits(expected, actual: TClass; msg: string);
begin
 if expected = nil then
   FailNotEquals('nil', actual.ClassName, msg, CallerAddr)
 else if actual = nil then
   FailNotEquals(expected.ClassName, 'nil', msg, CallerAddr)
 else if not actual.InheritsFrom(expected) then
   FailNotEquals(expected.ClassName, actual.ClassName, msg, CallerAddr)
end;

procedure TTestCase.CheckIs(obj: TObject; klass: TClass; msg: string);
begin
 Assert(klass <> nil);
 if obj = nil then
   FailNotEquals('nil', klass.ClassName, msg, CallerAddr)
 else if not obj.ClassType.InheritsFrom(klass) then
   FailNotEquals(obj.ClassName, klass.ClassName, msg, CallerAddr)
end;

{ TTestFailure }

constructor TTestFailure.Create(FailedTest: ITest; thrownException: Exception; Addr: Pointer; msg: string);
begin
  assert(assigned(thrownException));

  inherited Create;
  fFailedTest := FailedTest;
  fThrownExceptionClass := thrownException.ClassType;
  fThrownExceptionMessage := msg + thrownException.message;
  FThrownExceptionAddress := Addr;
  CaptureStackTrace;
end;

function TTestFailure.FailedTest: ITest;
begin
  result := fFailedTest;
end;

function TTestFailure.ThrownExceptionName: string;
begin
  result := fThrownExceptionClass.ClassName;
end;

function TTestFailure.ThrownExceptionMessage: string;
begin
  result := fThrownExceptionMessage;
end;

function TTestFailure.ThrownExceptionAddress: pointer;
begin
  Result := FThrownExceptionAddress;
end;

function TTestFailure.ThrownExceptionClass: TClass;
begin
  Result := FThrownExceptionClass;
end;

function TTestFailure.LocationInfo: string;
begin
  Result := PointerToLocationInfo(ThrownExceptionAddress);
end;

function TTestFailure.AddressInfo: string;
begin
  Result := PointerToAddressInfo(ThrownExceptionAddress);
end;

function TTestFailure.StackTrace: string;
begin
  Result := FStackTrace;
end;

procedure TTestFailure.CaptureStackTrace;
var
  Trace :TStrings;
begin
  Trace := TStringList.Create;
  try
    {$IFDEF USE_JEDI_JCL}
      JclDebug.JclLastExceptStackListToStrings(Trace, true);
    {$ENDIF}
    FStackTrace := Trace.Text;
  finally
    Trace.Free;
  end;
end;

{ TTestSuite }

constructor TTestSuite.Create;
begin
  self.Create(self.ClassName);
end;

constructor TTestSuite.Create(name: string);
begin
  assert(length(name) > 0);

  inherited Create(name);

  fTests := TInterfaceList.Create;
end;

constructor TTestSuite.Create( testClass: TTestCaseClass);
begin
  self.Create(testClass.ClassName);
  AddTests(testClass);
end;

constructor TTestSuite.Create(Name: string; const Tests: array of ITest);
var
  i: Integer;
begin
  self.Create(Name);
  for i := Low(Tests) to High(Tests) do begin
    Self.addTest(Tests[i])
  end;
end;

procedure TTestSuite.AddTest(ATest: ITest);
begin
  Assert(Assigned(ATest));

  fTests.Add(ATest);
end;

procedure TTestSuite.AddSuite(suite: ITestSuite);
begin
  AddTest(suite);
end;


procedure TTestSuite.AddTests(testClass: TTestCaseClass);
var
  MethodIter     :  Integer;
  NameOfMethod   :  string;
  MethodEnumerator:  TMethodEnumerator;
begin
  { call on the method enumerator to get the names of the test
    cases in the testClass }
  MethodEnumerator := nil;
  try
    MethodEnumerator := TMethodEnumerator.Create(testClass);
    { make sure we add each test case  to the list of tests }
    for MethodIter := 0 to MethodEnumerator.Methodcount-1 do
      begin
        NameOfMethod := MethodEnumerator.nameOfMethod[MethodIter];
        self.addTest(testClass.Create(NameOfMethod) as ITest);
      end;
  finally
    MethodEnumerator.free;
  end;
end;

function TTestSuite.CountTestCases: integer;
var
  test: ITest;
  i: Integer;
  Total:  integer;
begin
  assert(assigned(fTests));

  Total := 0;
  for i := 0 to fTests.Count - 1 do
  begin
    test := fTests[i] as ITest;
    Total := Total + test.CountTestCases;
  end;
  Result := Total;
end;

function TTestSuite.CountEnabledTestCases: integer;
var
  i: Integer;
  test: ITest;
  Total:  Integer;
begin
  assert(assigned(fTests));

  Total := 0;
  if getEnabled then
  begin
    for i := 0 to fTests.Count - 1 do
    begin
      test := fTests[i] as ITest;
      Total := Total + test.CountEnabledTestCases;
    end;
  end;
  Result := Total;
end;

procedure TTestSuite.RunBare(testResult: TTestResult);
var
  i: Integer;
  test: ITest;
begin
  assert(assigned(testResult));
  assert(assigned(fTests));

  if getEnabled then
  begin
    for i := 0 to fTests.Count - 1 do
    begin
      if testResult.ShouldStop then
        BREAK;
      test := fTests[i] as ITest;
      test.RunBare(testResult);
    end;
  end;
end;

function TTestSuite.Tests: IInterfaceList;
begin
  result := fTests;
end;

procedure TTestSuite.LoadConfiguration(const iniFile: TCustomIniFile; const section: string);
var
  i    : integer;
  Tests: IInterfaceList;
begin
  inherited LoadConfiguration(iniFile, section);
  Tests := self.Tests;
  for i := 0 to Tests.count-1 do
    (Tests[i] as ITest).LoadConfiguration(iniFile, section + '.' + self.GetName);
end;

procedure TTestSuite.SaveConfiguration(const iniFile: TCustomIniFile; const section: string);
var
  i    : integer;
  Tests: IInterfaceList;
begin
  inherited SaveConfiguration(iniFile, section);
  Tests := self.Tests;
  for i := 0 to Tests.count-1 do
    (Tests[i] as ITest).SaveConfiguration(iniFile, section + '.' + self.GetName);
end;


{ ETestFailure }

constructor ETestFailure.Create;
begin
   inherited Create('')
end;

constructor ETestFailure.Create(msg: string);
begin
   inherited Create(msg)
end;

{ EBreakingTestFailure }

constructor EBreakingTestFailure.Create;
begin
   inherited Create('')
end;

constructor EBreakingTestFailure.Create(msg: string);
begin
   inherited Create(msg)
end;

{ TMethodEnumerator }

constructor TMethodEnumerator.Create(AClass: TClass);
type
  TMethodTable = packed record
    count: SmallInt;
  //[...methods...]
  end;
var
  table: ^TMethodTable;
  name:  ^ShortString;
  i, j:  Integer;
begin
  inherited Create;
  while aclass <> nil do
  begin
    // *** HACK ALERT *** !!!
    // Review System.MethodName to grok how this method works
    asm
      mov  EAX, [aclass]
      mov  EAX,[EAX].vmtMethodTable { fetch pointer to method table }
      mov  [table], EAX
    end;
    if table <> nil then
    begin
      name := Pointer(PChar(table) + 8);
      for i := 1 to table.count do
      begin
        // check if we've seen the method name
        j := Low(FMethodNameList);
        while (j <= High(FMethodNameList)) 
        and (name^ <> FMethodNameList[j]) do
          inc(j);
        // if we've seen the name, then the method has probably been overridden
        if j > High(FMethodNameList) then begin
          SetLength(FMethodNameList,length(FMethodNameList)+1);
          FMethodNameList[j] := name^;
        end;
        name := Pointer(PChar(name) + length(name^) + 7)
      end;
    end;
    aclass := aclass.ClassParent;
  end;
end;

function TMethodEnumerator.GetMethodCount: Integer;
begin
  Result := Length(FMethodNameList);
end;

function TMethodEnumerator.GetNameOfMethod(Index: integer): string;
begin
  Result := FMethodNameList[Index];
end;

{ Convenience routines }

function  TestSuite(name: string; const Tests: array of ITest): ITestSuite;
begin
   result := TTestSuite.Create(name, Tests);
end;

{ test registry }

var
  __TestRegistry: ITestSuite = nil;

procedure RegisterTestInSuite(rootSuite: ITestSuite; path: string; test: ITest);
var
  pathRemainder:  String;
  suiteName:  String;
  targetSuite:  ITestSuite;
  suite:  ITestSuite;
  currentTest:  ITest;
  Tests:  IInterfaceList;
  dotPos:  Integer;
  i: Integer;
begin
  if (path = '') then
  begin
    // End any recursion
    rootSuite.addTest(test);
  end
  else
  begin
    // Split the path on the dot (.)
    dotPos := Pos('.', Path);
    if (dotPos <= 0) then dotPos := Pos('\', Path);
    if (dotPos <= 0) then dotPos := Pos('/', Path);
    if (dotPos > 0) then
    begin
      suiteName := Copy(path, 1, dotPos - 1);
      pathRemainder := Copy(path, dotPos + 1, length(path) - dotPos);
    end
    else
    begin
      suiteName := path;
      pathRemainder := '';
		end;
		Tests := rootSuite.Tests;

		// Check to see if the path already exists
		targetSuite := nil;
		Tests := rootSuite.Tests;
		for i := 0 to Tests.count -1 do
		begin
			currentTest := Tests[i] as ITest;
			currentTest.queryInterface(ITestSuite, suite);
			if suite <> nil then
			begin
				if (currentTest.GetName = suiteName) then
				begin
					targetSuite := suite;
					break;
				end;
			end;
		end;

		if not assigned(targetSuite) then
		begin
			targetSuite := TTestSuite.Create(suiteName);
			rootSuite.addTest(targetSuite);
		end;

		RegisterTestInSuite(targetSuite, pathRemainder, test);
	end;
end;

procedure CreateRegistry;
var
	MyName :AnsiString;
begin
	SetLength(MyName, 1024);
	GetModuleFileName(hInstance, PChar(MyName), Length(MyName));
	MyName := Trim(PChar(MyName));
	MyName := ExtractFileName(MyName);
	__TestRegistry := TTestSuite.Create(MyName);
end;

procedure RegisterTest(SuitePath: string; test: ITest);
begin
	assert(assigned(test));
	if __TestRegistry = nil then CreateRegistry;
	RegisterTestInSuite(__TestRegistry, SuitePath, test);
end;

procedure RegisterTest(test: ITest);
begin
	RegisterTest('', test);
end;

procedure RegisterTests(SuitePath: string; const Tests: array of ITest);
var
  i: Integer;
begin
  for i := Low(Tests) to High(Tests) do begin
    TestFramework.RegisterTest(SuitePath, Tests[i])
  end
end;

procedure RegisterTests(const Tests: array of ITest);
begin
  RegisterTests('', Tests);
end;

function RegisteredTests: ITestSuite;
begin
  result := __TestRegistry;
end;

function RunTest(suite: ITest; listeners: array of ITestListener): TTestResult; overload;
var
  i        : Integer;
begin
  result := TTestResult.Create;
  for i := low(listeners) to high(listeners) do
      result.addListener(listeners[i]);
  if suite <> nil then
    suite.Run(result);
end;

function RunRegisteredTests(listeners: array of ITestListener): TTestResult;
begin
  result := RunTest(RegisteredTests, listeners);
end;

procedure ClearRegistry;
begin
	__TestRegistry := nil;
end;

initialization
{$IFDEF LINUX}
//  PerformanceCounterInitValue := Now;
  InitPerformanceCounter;
{$ENDIF}
finalization
  ClearRegistry;
end.
