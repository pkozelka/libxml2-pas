program LIBXMLTest;

uses
  TestFramework,
  GUITestRunner,
  jkDomTest in 'jkDomTest.pas',
  XPTest_xdom2_TestCase in 'XPTest_xdom2_TestCase.pas',
  domSetup in 'domSetup.pas',
  Main in 'Main.pas';

begin
  GUITestRunner.runRegisteredTests;
end.
