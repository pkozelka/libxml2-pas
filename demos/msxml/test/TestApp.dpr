program TestApp(input, output);

{$APPTYPE CONSOLE}

uses
	TestMain in 'TestMain.pas';

{$R *.res}

begin
	Reset(output);
	if (ParamCount=0) then begin
		main('../../data/birds.xml');
	end else begin
		main(ParamStr(1));
	end;
	Close(output);
end.
