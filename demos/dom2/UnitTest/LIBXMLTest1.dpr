program LIBXMLTest;

uses
  TestFramework,
  GUITestRunner,
  LIBXMLTestCase in 'LIBXMLTestCase.pas',
  libxmldom in 'L:\open\dom2\libxmldom.pas',
  jkDomTest in 'jkDomTest.pas';

{$R *.res}

begin
  GUITestRunner.runRegisteredTests;
end.
