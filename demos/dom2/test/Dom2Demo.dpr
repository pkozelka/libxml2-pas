program Dom2Demo;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  conapp in 'conapp.pas',
  MicroTime in 'MicroTime.pas',
  jkDomTest in 'jkDomTest.pas',
  libxmldom in 'L:\dom2\libxmldom.pas',
  Dom2 in 'L:\dom2\Dom2.pas',
  msxml_impl in 'L:\dom2\msxml_impl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
