program LIBXMLTest;

uses
  TestFramework,
  GUITestRunner,
  jkDomTest in 'jkDomTest.pas',
  XPTest_xdom2_TestCase in 'XPTest_xdom2_TestCase.pas';

{$R *.res}

begin
  GUITestRunner.runRegisteredTests;
end.
