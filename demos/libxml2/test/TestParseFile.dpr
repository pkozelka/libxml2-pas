program TestParseFile;

{$APPTYPE CONSOLE}

uses
  libxml2,
  SysUtils;

procedure TestXmlDocParseFile(aFileName: string);
var
  doc: xmlDocPtr;
begin
  Write(aFilename, ': ');
  doc := xmlParseFile(PChar(aFileName));
  if (doc=nil) then begin
    WriteLN('failed');
  end else begin
    WriteLN('ok');
    xmlFreeDoc(doc);
  end;
end;

var
  i: integer;
begin
  WriteLN('TestXmlDocParseFile');
  if (ParamCount=0) then begin
    WriteLN('Usage: ', ParamStr(0),' <filename> [<filename>]');
  end else begin
    for i:=1 to ParamCount do begin
      TestXmlDocParseFile(ParamStr(i));
    end;
  end;
end.

