unit XPTest_idom2_Shared;

interface

uses
  IniFiles,
  domSetup,
  libxmldom,
  idom2,
  sysutils,
  strutils;

const
  CRLF    = #13#10;
  xmlstr  = '<?xml version="1.0" encoding="iso-8859-1"?><test />';
  xmlstr1 = '<?xml version="1.0" encoding="iso-8859-1"?><test xmlns=''http://ns.4ct.de''/>';
  xmlstr2 = '<?xml version="1.0" encoding="iso-8859-1"?>'+
            '<!DOCTYPE root ['+
            '<!ELEMENT root (test*)>'+
            '<!ELEMENT test (#PCDATA)>'+
            '<!ATTLIST test name CDATA #IMPLIED>'+
            '<!ENTITY ct "4 commerce technologies">'+
            '<!NOTATION type2 SYSTEM "program2">'+
            '<!ENTITY FOO2 SYSTEM "file.type2" NDATA type2>'+
            ']>'+
            '<root />';
  xmlstr3 = '<?xml version="1.0" encoding="iso-8859-1"?><test xmlns:ct=''http://ns.4ct.de''/>';
  xslstr  = '<?xml version=''1.0''?>'+
            '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"'+
            '                version="1.0">'+
            '  <xsl:output method="html"'+
            '              version="4.0"'+
            //'              omit-xml-declaration="yes"'+
            '              doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"'+
            '              doctype-system="http://www.w3.org/TR/REC-html40/loose.dtd"'+
            '              encoding="ISO-8859-1" />'+
            '  <xsl:template match="/*">'+
            '    <html>'+
            '      <head>'+
            '        <title><xsl:value-of select="name()" /></title>'+
            '      </head>'+
            '      <body>'+
            '        <h1><xsl:value-of select="name()" /></h1>'+
            '      </body>'+
            '    </html>'+
            '  </xsl:template>'+
            '</xsl:stylesheet>';
  xslstr1 = '<?xml version=''1.0''?>'+
            '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"'+
            '                version="1.0">'+
            '  <xsl:output method="text"'+
            //'              omit-xml-declaration="yes"'+
            '              encoding="ISO-8859-1" />'+
            '  <xsl:template match="/*">'+
            '    <xsl:value-of select="name()" />'+
            '  </xsl:template>'+
            '</xsl:stylesheet>';
  outstr  = '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">'+
            '<html>'+
            '<head>'+
            '<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">'+
            '<title>test</title>'+
            '</head>'+
            '<body>'+
            '<h1>test</h1>'+
            '</body>'+
            '</html>';

  function getDataPath: string;
  function domvendor: string;
  function myIsSameNode(node1, node2: IDOMNode): boolean;
  function Unify(xml: string):string;
  function StrCompare(str1,str2: string):integer;

var
  datapath: string ='';

implementation

function getDataPath: string;
var ini: TIniFile;
begin
  ini := TIniFile.Create('./XPTestSuite_idom2.ini');
  result := Ini.ReadString('TestDocuments','DataPath','../../data');
  Ini.WriteString('TestDocuments','DataPath',result);
end;

function domvendor: string;
begin
  result := domSetup.getCurrentDomSetup.getVendorID;
end;

function Unify(xml: string):string;

begin
  xml := AdjustLineBreaks(xml,tlbsLF);
  xml := StringReplace(xml,#10,'',[rfReplaceAll]);
  xml := StringReplace(xml,#9,'',[rfReplaceAll]);
  xml := StringReplace(xml,' encoding="iso-8859-1"','',[rfReplaceAll]);
  result := xml;
end;

function StrCompare(str1,str2: string):integer;
// compares two strings
// if they are equal, zero is the return value
// if they are unqual, it returns the position,
// where there is a difference
var
  i: integer;
  len,len1,len2: integer;
begin
  result:=0;
  if str1=str2 then exit;
  len1:=length(str1);
  len2:=length(str2);
  len:=len1;
  if len2<len1 then len:=len2;
  for i:=0 to len do begin
    if leftstr(str1,i) <> leftstr(str2,i) then begin
      result:=i;
      exit
    end;
  end;
  if len<len1 then result:=len+1;
  if len<len2 then result:=len+1;
end;

function myIsSameNode(node1, node2: IDOMNode): boolean;
begin
  {$if (SLIBXML = 'LIBXML_4CT')}
    result := (node1 as IDomNodeCompare).IsSameNode(node2);
  {$else}
    result := ((node1 as IUnKnown) = (node2 as IUnKnown));
  {$ifend}
end;

end.
