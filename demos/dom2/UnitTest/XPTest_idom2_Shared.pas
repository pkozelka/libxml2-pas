unit XPTest_idom2_Shared;

interface

uses
  IniFiles,
  domSetup,
  libxmldom,
  idom2,
  sysutils,
  strutils,
  TestFrameWork;

const
  CRLF    = #13#10;
  xmldecl = '<?xml version="1.0" encoding="iso-8859-1"?>';
  xmlstr  = xmldecl + '<test />';
  xmlstr1 = xmldecl + '<test xmlns=''http://ns.4ct.de''/>';
  xmlstr2 = xmldecl +
            '<!DOCTYPE root [' + '<!ELEMENT root (test*)>' +
            '<!ELEMENT test (#PCDATA)>' +
            '<!ATTLIST test name CDATA #IMPLIED>' +
            '<!ENTITY ct "4 commerce technologies">' +
            '<!NOTATION type2 SYSTEM "program2">' +
            '<!ENTITY FOO2 SYSTEM "file.type2" NDATA type2>' + ']>' +
            '<root />';
  xmlstr3 = xmldecl + '<test xmlns:ct=''http://ns.4ct.de''/>';
  xslstr  = xmldecl +
            '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"' +
            '                version="1.0">' + '  <xsl:output method="html"' +
            '              version="4.0"' +
            //'              omit-xml-declaration="yes"'+
            '              doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"' +
            '              doctype-system="http://www.w3.org/TR/REC-html40/loose.dtd"' +
            '              encoding="ISO-8859-1" />' + '  <xsl:template match="/*">' +
            '    <html>' +
            '      <head>' +
            '        <title><xsl:value-of select="name()" /></title>' +
            '      </head>' +
            '      <body>' +
            '        <h1><xsl:value-of select="name()" /></h1>' +
            '      </body>' +
            '    </html>' +
            '  </xsl:template>' +
            '</xsl:stylesheet>';
  xslstr2 = xmldecl +
            '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"' +
            '                version="1.0">' +
            '  <xsl:output method="xml"' +
            '              doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"' +
            '              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"' +
            '              encoding="iso-8859-1" />' +
            '  <xsl:template match="/*">' +
            '    <html>' +
            '      <head>' +
            '        <title><xsl:value-of select="name()" /></title>' +
            '      </head>' +
            '      <body>' +
            '        <h1><xsl:value-of select="name()" /></h1>' +
            '      </body>' +
            '    </html>' +
            '  </xsl:template>' +
            '</xsl:stylesheet>';
  xslstr1 = xmldecl +
            '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"' +
            '                version="1.0">' + '  <xsl:output method="text"' +
            //'              omit-xml-declaration="yes"'+
            '                encoding="ISO-8859-1" />' +
            '  <xsl:template match="/*">' +
            '    <xsl:value-of select="name()" />' +
            '  </xsl:template>' +
            '</xsl:stylesheet>';
  outstr  = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">' +
            '<html>' +
            '<head>' +
            '<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">' +
            '<title>test</title>' +
            '</head>' +
            '<body>' +
            '<h1>test</h1>' +
            '</body>' +
            '</html>';
  outstr1 = xmldecl +
            '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' +
            '<html>' +
            '<head>' +
            '<title>test</title>' +
            '</head>' +
            '<body>' +
            '<h1>test</h1>' +
            '</body>' +
            '</html>';

type
  TMemoryTestCase = class(TTestCase)
  private
    mem: cardinal;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  end;

function getDataPath: string;
function domvendor: string;
function myIsSameNode(node1, node2: IDomNode): boolean;
function Unify(xml: string; removeEncoding: boolean = True): string;
function StrCompare(str1, str2: WideString): integer;
function getUnicodeStr(mode: integer = 0): WideString;

var
  datapath: string = '';

implementation

function getUnicodeStr(mode: integer = 0): WideString;
  // this function returns an unicode string
var
  i: integer;
begin
  result := '';
  case mode of
    0: begin
         // return an unicode string with all defined greek and coptic characters
         for i := $0370 to $03FF do begin
           case i of
             $0370..$0373,$0376..$0379,$037B..$037D,$037F..$0383,
             $038B,$038D,$03A2,$03CF,$03D8,$03D9,$03F6..$03FF: // exclude undefined
           else
             result := result + WideChar(i);
           end;
         end;
       end;
    1: begin
         // return an unicode string that is save for tag names
         result := result + WideChar($0391)+WideChar($0392)+WideChar($0395);
       end;
  end;
end;

function getDataPath: string;
  // this function returns the path to the sample files
var
  ini: TIniFile;
begin
  ini := TIniFile.Create('./XPTestSuite_idom2.ini');
  Result := Ini.ReadString('TestDocuments', 'DataPath', '../../data');
  Ini.WriteString('TestDocuments', 'DataPath', Result);
end;

function domvendor: string;
begin
  Result := domSetup.getCurrentDomSetup.getVendorID;
end;

function Unify(xml: string; removeEncoding: boolean = True): string;
  // this procedure unifies the result of the method xml of IDOMPersist
var
  len : integer;
begin
  xml := AdjustLineBreaks(xml, tlbsLF);
  xml := StringReplace(xml, #10, '', [rfReplaceAll]);
  xml := StringReplace(xml, #9, '', [rfReplaceAll]);
  if removeEncoding then
    if pos('<?xml',xml)>0 then begin
      len:=pos('>',xml)+1;
      xml:=copy(xml,len,length(xml)-len+1);
    end;
  Result := xml;
end;

function StrCompare(str1, str2: WideString): integer;
  // compares two strings
  // if they are equal, zero is the return value
  // if they are unqual, it returns the position,
  // where there is a difference
var
  i: integer;
  len, len1, len2: integer;
begin
  Result := 0;
  if str1 = str2 then exit;
  len1 := length(str1);
  len2 := length(str2);
  len := len1;
  if len2 < len1 then len := len2;
  for i := 0 to len do begin
    if leftstr(str1, i) <> leftstr(str2, i) then begin
      Result := i;
      exit
    end;
  end;
  if len < len1 then Result := len + 1;
  if len < len2 then Result := len + 1;
end;

function myIsSameNode(node1, node2: IDomNode): boolean;
  // compare if two nodes are the same (not equal)
begin
  if (domvendor = 'LIBXML_4CT')
    then Result := (node1 as IDomNodeCompare).IsSameNode(node2)
    else Result := ((node1 as IUnknown) = (node2 as IUnknown));
end;

{ TMemoryTestCase }

procedure TMemoryTestCase.SetUp;
begin
  inherited;
  mem := GetHeapStatus.TotalAllocated;
end;

procedure TMemoryTestCase.TearDown;
var
  delta: cardinal;
begin
  inherited;
  delta := GetHeapStatus.TotalAllocated - mem;
  check(delta < 10000,'Memory leak, delta= ' + IntToStr(delta));
end;

end.
