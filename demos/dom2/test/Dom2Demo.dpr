program Dom2Demo;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  conapp in 'conapp.pas',
  MicroTime in 'MicroTime.pas',
  jkDomTest in 'jkDomTest.pas',
  libxmldom in 'libxmldom.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
