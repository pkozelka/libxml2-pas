program Dom2Demo;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  jkDomTest in 'jkDomTest.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

