program Demo1;

{
Author:
Uwe Fechner <ufechner@4commerce.de>
copyright:
4commerce technologies AG
kamerbalken 10-14
22525 Hamburg
}

{$APPTYPE CONSOLE}

uses
  SysUtils,TestXPATH;

begin
  writeln;
  writeln('Demo1 for libxml2!');
  writeln('==================');
  writeln('Using XPATH');
  writeln;
  if paramcount=0 then begin
    writeln('Usage:');
    writeln('demo1 <xml-filename> <xpath-expression>');
    writeln;
    writeln('For example:');
    writeln('demo1 calServer.xml //remark');
  end
  else
    if paramcount = 2 then begin
      test1(paramStr(1),paramStr(2));
    end else begin
      writeln('Invalid parameter count!')
    end;
end.
