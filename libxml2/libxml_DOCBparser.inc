// CVS-SIGN: [1.5] DOCBparser.h
{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}
{
	DOCBparser.h : interface for a DocBook SGML non-verifying parser

	See Copyright for the status of this software.

	daniel@veillard.com
}

type
	{
		Most of the back-end structures from XML and SGML are shared
	}
	docbParserCtxt = xmlParserCtxt;
	docbParserCtxtPtr = xmlParserCtxtPtr;
	docbParserNodeInfo = xmlParserNodeInfo;
	docbSAXHandler = xmlSAXHandler;
	docbSAXHandlerPtr = xmlSAXHandlerPtr;
	docbParserInput = xmlParserInput;
	docbParserInputPtr = xmlParserInputPtr;
	docbDocPtr = xmlDocPtr;
	docbNodePtr = xmlNodePtr;

{
	There is only few public functions.
}
function  docbEncodeEntities(aOut:Pbyte; outlen:Plongint; aIn:Pbyte; inlen:Plongint; quoteChar:longint):longint;cdecl;external LIBXML2_SO;
function  docbSAXParseDoc(cur:PxmlChar; encoding:Pchar; sax:docbSAXHandlerPtr; userData:pointer):docbDocPtr;cdecl;external LIBXML2_SO;
function  docbParseDoc(cur:PxmlChar; encoding:Pchar):docbDocPtr;cdecl;external LIBXML2_SO;
function  docbSAXParseFile(filename:Pchar; encoding:Pchar; sax:docbSAXHandlerPtr; userData:pointer):docbDocPtr;cdecl;external LIBXML2_SO;
function  docbParseFile(filename:Pchar; encoding:Pchar):docbDocPtr;cdecl;external LIBXML2_SO;

{
	Interfaces for the Push mode
}
procedure docbFreeParserCtxt(ctxt:docbParserCtxtPtr);cdecl;external LIBXML2_SO;
function  docbCreatePushParserCtxt(sax:docbSAXHandlerPtr; user_data:pointer; chunk:Pchar; size:longint; filename:Pchar; enc:xmlCharEncoding):docbParserCtxtPtr;cdecl;external LIBXML2_SO;
function  docbParseChunk(ctxt:docbParserCtxtPtr; chunk:Pchar; size:longint; terminate:longint):longint;cdecl;external LIBXML2_SO;
function  docbCreateFileParserCtxt(filename:Pchar; encoding:Pchar):docbParserCtxtPtr;cdecl;external LIBXML2_SO;
function  docbParseDocument(ctxt:docbParserCtxtPtr):longint;cdecl;external LIBXML2_SO;

