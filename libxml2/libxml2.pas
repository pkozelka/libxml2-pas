unit libxml2;
{
	------------------------------------------------------------------------------
	This unit collects all the translated headers of libxml2 (aka gnome-xml).
	2001 (C) Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
	See also:
		http://www.xmlsoft.org  - the libxml2 homepage
		http://kozelka.hyperlink.cz  - my homepage
}

interface

uses
{$ifdef WIN32}
  windows,
{$endif}
{$ifdef LINUX}
  libc,
{$endif}
  iconv;
const
{$ifdef WIN32}
  LIBXML2_SO = 'libxml2.dll';
{$endif}

//{$WEAKPACKAGEUNIT}

{$ifdef VER140}
{$ALIGN 4}
{$endif}
{$MINENUMSIZE 4}
{$ASSERTIONS OFF}

type
	DWORD = integer;
	PLongInt = ^LongInt;
	PByte = ^byte;
	PPChar = ^PChar;

{$define LIBXML_THREAD_ALLOC_ENABLED}
{$define LIBXML_THREAD_ENABLED}
{$define LIBXML_HTML_ENABLED}
{$define LIBXML_DOCB_ENABLED}

{TODO: $I libxml_xmlversion.inc}
{$I libxml_xmlwin32version.inc}

{$I libxml_xmlmemory.inc}
{$I libxml_tree.inc}
{$I libxml_encoding.inc}
{$I libxml_xmlIO.inc}
{$I libxml_hash.inc}
{$I libxml_entities.inc}
{$I libxml_list.inc}
{$I libxml_valid.inc}
{$I libxml_parser.inc}
{$I libxml_SAX.inc}
{$I libxml_xpath.inc}
{$I libxml_xpathInternals.inc}
{$I libxml_xpointer.inc}
{$I libxml_xmlerror.inc}
{$I libxml_xlink.inc}
{$I libxml_xinclude.inc}
{$I libxml_debugXML.inc}
{$I libxml_nanoftp.inc}
{$I libxml_nanohttp.inc}
{$I libxml_uri.inc}
{$I libxml_HTMLparser.inc}
{$I libxml_HTMLtree.inc}
{$I libxml_parserInternals.inc}
{$I libxml_DOCBparser.inc}
{$I libxml_catalog.inc}
{$I libxml_globals.inc}
{$I libxml_threads.inc}

// functions that reference symbols defined later - by header file:

// tree.h
function  xmlSaveFileTo(buf:xmlOutputBufferPtr; cur:xmlDocPtr; encoding:Pchar):longint;cdecl;external LIBXML2_SO;
function  xmlSaveFormatFileTo(buf:xmlOutputBufferPtr; cur:xmlDocPtr; encoding:Pchar; format:longint):longint;cdecl;external LIBXML2_SO;
procedure xmlNodeDumpOutput(buf:xmlOutputBufferPtr; doc:xmlDocPtr; cur:xmlNodePtr; level:longint; format:longint; encoding:Pchar);cdecl;external LIBXML2_SO;

// xmlIO.h
function  xmlNoNetExternalEntityLoader(URL: PChar; ID: PChar; ctxt: xmlParserCtxtPtr): xmlParserInputPtr; cdecl;external LIBXML2_SO;

type
  (**
  * This interface is intended for libxml2 wrappers. It provides a way
  * back - i.e. from the wrapper object to the libxml2 node.
  *)
  ILibXml2Node = interface ['{1D4BD646-0AB9-4810-B4BD-7277FB0CFA30}']
    function  LibXml2NodePtr: xmlNodePtr;
  end;

implementation

// functions from globals.b

procedure xmlFree(str: PxmlChar);
begin
  FreeMem(PChar(str));
end;

// macros from xpath.h

function xmlXPathNodeSetGetLength(ns : xmlNodeSetPtr) : integer;
begin
  if ns=nil then begin
    Result := 0;
  end else begin
    Result := ns^.nodeNr;
  end;
end;

function xmlXPathNodeSetItem(ns: xmlNodeSetPtr; index: integer): xmlNodePtr;
var
  p: PxmlNodePtr;
begin
  Result := nil;
  if ns=nil then exit;
  if index<0 then exit;
  if index>=ns^.nodeNr then exit;
  p := ns^.nodeTab;
  Inc(p, index);
  Result := p^;
end;

function xmlXPathNodeSetIsEmpty(ns: xmlNodeSetPtr): boolean;
begin
  Result := ((ns = nil) or (ns.nodeNr = 0) or (ns.nodeTab = nil));
end;

// macros from parserInternals

procedure SKIP_EOL(var p: PxmlChar);
begin
  if (p^=#13) then begin
    Inc(p);
    if (p^=#10) then Inc(p);
  end;
  if (p^=#10) then begin
    Inc(p);
    if (p^=#13) then Inc(p);
  end;
end;

procedure MOVETO_ENDTAG(var p: PxmlChar);
begin
  while ((p^<>#0) and (p^<>'>')) do Inc(p);
end;

procedure MOVETO_STARTTAG(var p: PxmlChar);
begin
  while ((p^<>#0) and (p^<>'<')) do Inc(p);
end;

//[pk] DEPRECATED, TEMPORARY:
procedure InitExportedVar;
{$ifdef WIN32}
begin
  xmlDoValidityCheckingDefaultValue_PTR := GetProcAddress(GetModuleHandle(PChar(LIBXML2_SO)), 'xmlDoValidityCheckingDefaultValue');
  Assert(xmlDoValidityCheckingDefaultValue_PTR <> nil);
  xmlSubstituteEntitiesDefaultValue_PTR := GetProcAddress(GetModuleHandle(PChar(LIBXML2_SO)), 'xmlSubstituteEntitiesDefaultValue');
  Assert(xmlSubstituteEntitiesDefaultValue_PTR <> nil);
end;
{$else}
begin
  // to do:
  // not yet tested
  // I suppose, that I don't use dlopen correctly
  xmlDoValidityCheckingDefaultValue_PTR := dlsym(dlopen(PChar(LIBXML2_SO)), 'xmlDoValidityCheckingDefaultValue');
  Assert(xmlDoValidityCheckingDefaultValue_PTR <> nil);
  xmlSubstituteEntitiesDefaultValue_PTR := dlsym(dlopen(PChar(LIBXML2_SO)), 'xmlSubstituteEntitiesDefaultValue');
  Assert(xmlSubstituteEntitiesDefaultValue_PTR <> nil);
end;
{$endif}

initialization
  InitExportedVar;
//end of deprecated part
end.




