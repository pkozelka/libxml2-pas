program DomTestSuiteProject;

uses
  Forms,
  TestFrameWork,
  GUITestRunner,
  Main in 'Main.pas',
  domSetup in 'domSetup.pas',
  DomDocumentTests in 'tests\DomDocumentTests.pas',
  DomImplementationTests in 'tests\DomImplementationTests.pas';

{$R *.res}

begin
  Application.Initialize;
  GUITestRunner.RunRegisteredTests;
end.
