program TestApp(input, output);

{$APPTYPE CONSOLE}

uses
	msxml_libxml in 'msxml_libxml.pas',
	msxml_dom_impl in 'msxml_dom_impl.pas',
	d5utils in 'd5utils.pas',
	TestMain in 'TestMain.pas';

{$R *.RES}

begin
	Reset(output);
	main(ParamStr(1));
	Close(output);
end.
