program XPTestSuite_idom2;

uses
  Windows,
  SysUtils,
  Forms,
  TestModules,
  TestFramework,
  TextTestRunner,
  GUITestRunner,
  Main in 'Main.pas',
  domSetup in 'domSetup.pas',
  XPTest_idom2_Shared in 'XPTest_idom2_Shared.pas',
  XPTest_idom2_TestDOM2Methods in 'XPTest_idom2_TestDOM2Methods.pas',
  XPTest_idom2_TestDomExceptions in 'XPTest_idom2_TestDomExceptions.pas',
  XPTest_idom2_TestMemoryLeaks in 'XPTest_idom2_TestMemoryLeaks.pas',
  XPTest_idom2_TestXPath in 'XPTest_idom2_TestXPath.pas',
  XPTest_idom2_TestXSLT in 'XPTest_idom2_TestXSLT.pas',
  XPTest_idom2_TestPersist in 'XPTest_idom2_TestPersist.pas',
  DomDocumentTests in '../DomTestSuite/tests/DomDocumentTests.pas',
  DomImplementationTests in '../DomTestSuite/tests/DomImplementationTests.pas';

{$R *.res}

const SwitchChars = ['-','/'];

procedure RunInConsoleMode;
var
  i :Integer;
  rxbBehavior: TRunnerExitBehavior;
begin
  try
    try
      if not IsConsole then begin
        Windows.AllocConsole;
      end;
      writeln('XPTest Suite ist started ...');
      writeln;
      writeln;
      for i := 1 to ParamCount do begin
        if not (ParamStr(i)[1] in SwitchChars) then begin
          RegisterModuleTests(ParamStr(i));
        end;
      end;
      if FindCmdLineSwitch('haltonfailure', SwitchChars, true) then begin
        rxbBehavior := rxbHaltOnFailures;
      end else if FindCmdLineSwitch('pause', SwitchChars, true) then begin
        rxbBehavior := rxbPause;
      end else begin
        rxbBehavior := rxbContinue;
      end;
      TextTestRunner.RunRegisteredTests(rxbBehavior);
    except
      on e:Exception do Writeln(Format('%s: %s', [e.ClassName, e.Message]));
    end;
  finally
    if not IsConsole then begin
       writeln;
       write  ('Press <RETURN> to exit.');
       readln;
    end;
  end;
end;

begin
  if FindCmdLineSwitch('c', SwitchChars, true) then begin
    RunInConsoleMode;
  end else begin
    Application.Initialize;
    GUITestRunner.RunRegisteredTests;
  end;
end.
