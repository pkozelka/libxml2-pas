program dunit;

uses
  Windows,
  SysUtils,
  Forms,
  Dialogs,
  TestFramework in 'TestFramework.pas',
  GUITestRunner in 'GUITestRunner.pas' {GUITestRunner},
  TextTestRunner in 'TextTestRunner.pas',
  DUnitMainForm in 'DUnitMainForm.pas',
  DunitAbout in 'DunitAbout.pas' {DunitAboutBox},
  TestModules in 'TestModules.pas';

{$R *.RES}
{$R versioninfo.res }

const
  rcs_id :string = '#(@)$Id: dunit.dpr,v 1.1 2002-01-10 12:55:31 ufechner Exp $';
  SwitchChars = ['-','/'];

procedure RunInConsoleMode;
var
  i :Integer;
begin
  try
    if not IsConsole then
      Windows.AllocConsole;
    for i := 1 to ParamCount do
    begin
      if not (ParamStr(i)[1] in SwitchChars) then
         RegisterModuleTests(ParamStr(i));
    end;
    TextTestRunner.RunRegisteredTests(rxbHaltOnFailures);
  except
    on e:Exception do
      Writeln(Format('%s: %s', [e.ClassName, e.Message]));
  end;
end;

begin
  if FindCmdLineSwitch('c', SwitchChars, true) then
    RunInConsoleMode
  else
  begin
    Application.Initialize;
    Application.Title := 'DUnit - An Extreme Testing Framework';
    if not SysUtils.FindCmdLineSwitch('nologo', ['/','-'], true) then
      DUnitAbout.Splash;
    Application.CreateForm(TDUnitForm, DUnitForm);
    try
      Application.Run;
    except
      on e:Exception do
        ShowMessage(e.Message);
    end;
  end;
end.
