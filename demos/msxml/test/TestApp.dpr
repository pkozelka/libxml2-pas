program TestApp(input, output);

{$APPTYPE CONSOLE}

uses
	TestMain in 'TestMain.pas';

{$R *.RES}

begin
	Reset(output);
	main(ParamStr(1));
	Close(output);
end.
