// CVS-SIGN: [1.24] HTMLparser.h
{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}
{
	HTMLparser.h : inf=terface for an HTML 4.0 non-verifying parser

	See Copyright for the status of this software.

	daniel@veillard.com
}

type
	{
		Most of the back-end structures from XML and HTML are shared
	}
	htmlParserCtxt = xmlParserCtxt;
	htmlParserCtxtPtr = xmlParserCtxtPtr;
	htmlParserNodeInfo = xmlParserNodeInfo;
	htmlSAXHandler = xmlSAXHandler;
	htmlSAXHandlerPtr = xmlSAXHandlerPtr;
	htmlParserInput = xmlParserInput;
	htmlParserInputPtr = xmlParserInputPtr;
	htmlDocPtr = xmlDocPtr;
	htmlNodePtr = xmlNodePtr;

	{
		Internal description of an HTML element
	}
	htmlElemDescPtr = ^htmlElemDesc;
	htmlElemDesc = record
		name : Pchar;                   { The tag name  }
		startTag : char;                { Whether the start tag can be implied  }
		endTag : char;                  { Whether the end tag can be implied  }
		saveEndTag : char;              { Whether the end tag should be saved  }
		empty : char;                   { Is this an empty element ?  }
		depr : char;                    { Is this a deprecated element ?  }
		dtd : char;                     { 1: only in Loose DTD, 2: only Frameset one  }
		isinline : char;                { is this a block 0 or inline 1 element  }
		desc : Pchar;                   { the description  }
	end;

	{
		Internal description of an HTML entity
	}
	htmlEntityDescPtr = ^htmlEntityDesc;
	htmlEntityDesc = record
		value : dword;                  { the UNICODE value for the character  }
		name : Pchar;                   { The entity name  }
		desc : Pchar;                   { the description  }
	end;

	{
		There is only few public functions.
	}
function  htmlTagLookup(tag:PxmlChar):htmlElemDescPtr;cdecl;external LIBXML2_SO;
function  htmlEntityLookup(name:PxmlChar):htmlEntityDescPtr;cdecl;external LIBXML2_SO;
function  htmlEntityValueLookup(value:dword):htmlEntityDescPtr;cdecl;external LIBXML2_SO;
function  htmlIsAutoClosed(doc:htmlDocPtr; elem:htmlNodePtr):longint;cdecl;external LIBXML2_SO;
function  htmlAutoCloseTag(doc:htmlDocPtr; name:PxmlChar; elem:htmlNodePtr):longint;cdecl;external LIBXML2_SO;
function  htmlParseEntityRef(ctxt:htmlParserCtxtPtr; str:PPxmlChar):htmlEntityDescPtr;cdecl;external LIBXML2_SO;
function  htmlParseCharRef(ctxt:htmlParserCtxtPtr):longint;cdecl;external LIBXML2_SO;
procedure htmlParseElement(ctxt:htmlParserCtxtPtr);cdecl;external LIBXML2_SO;
function  htmlSAXParseDoc(cur:PxmlChar; encoding:Pchar; sax:htmlSAXHandlerPtr; userData:pointer):htmlDocPtr;cdecl;external LIBXML2_SO;
function  htmlParseDoc(cur:PxmlChar; encoding:Pchar):htmlDocPtr;cdecl;external LIBXML2_SO;
function  htmlSAXParseFile(filename:Pchar; encoding:Pchar; sax:htmlSAXHandlerPtr; userData:pointer):htmlDocPtr;cdecl;external LIBXML2_SO;
function  htmlParseFile(filename:Pchar; encoding:Pchar):htmlDocPtr;cdecl;external LIBXML2_SO;
function  UTF8ToHtml(aOut:Pbyte; outlen:Plongint; aIn:Pbyte; inlen:Plongint):longint;cdecl;external LIBXML2_SO;
function  htmlEncodeEntities(aOut:Pbyte; outlen:Plongint; aIn:Pbyte; inlen:Plongint; quoteChar:longint):longint;cdecl;external LIBXML2_SO;
function  htmlIsScriptAttribute(name:PxmlChar):longint;cdecl;external LIBXML2_SO;
function  htmlHandleOmittedElem(val:longint):longint;cdecl;external LIBXML2_SO;

{
	Interfaces for the Push mode
}
procedure htmlFreeParserCtxt(ctxt:htmlParserCtxtPtr);cdecl;external LIBXML2_SO;
function  htmlCreatePushParserCtxt(sax:htmlSAXHandlerPtr; user_data:pointer; chunk:Pchar; size:longint; filename:Pchar; enc:xmlCharEncoding):htmlParserCtxtPtr;cdecl;external LIBXML2_SO;
function  htmlParseChunk(ctxt:htmlParserCtxtPtr; chunk:Pchar; size:longint; terminate:longint):longint;cdecl;external LIBXML2_SO;

