// CVS-SIGN: [1.42] parserInternals.h
{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}
{
	 parserInternals.h : internals routines exported by the parser.

	 See Copyright for the status of this software.

	 daniel@veillard.com

	 14 Nov 2000 ht - truncated declaration of xmlParseElementChildrenContentDecl
	 for VMS

	}

const
	{
		XML_MAX_NAMELEN:

		Identifiers can be longer, but this will be more costly
		at runtime.
	}
	XML_MAX_NAMELEN = 100;
	{
		INPUT_CHUNK:

		The parser tries to always have that amount of input ready
		one of the point is providing context when reporting errors
	}
	INPUT_CHUNK = 250;
	{
		UNICODE version of the macros.
	}

{
	IS_CHAR:
	@c:  an UNICODE value (int)

	Macro to check the following production in the XML spec

	[2] Char ::= #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD]
					| [#x10000-#x10FFFF]
	any Unicode character, excluding the surrogate blocks, FFFE, and FFFF.
}
var
  xmlDoValidityCheckingDefaultValue_PTR: ^longint; //[pk] DEPRECATED, TEMPORARY
  xmlSubstituteEntitiesDefaultValue_PTR: ^longint; //[pk] DEPRECATED, TEMPORARY

function  IS_CHAR(c:longint):longint;cdecl;external LIBXML2_SO name 'xmlIsChar';
{
	IS_BLANK:
	@c:  an UNICODE value (int)

	Macro to check the following production in the XML spec

	[3] S ::= (#x20 | #x9 | #xD | #xA)+
}
function  IS_BLANK(c:longint):longint;cdecl;external LIBXML2_SO name 'xmlIsBlank';
{
	IS_BASECHAR:
	@c:  an UNICODE value (int)

	Macro to check the following production in the XML spec

	[85] BaseChar ::= ... long list see REC ...
}
function  IS_BASECHAR(c:longint):longint;cdecl;external LIBXML2_SO name 'xmlIsBaseChar';
{
	IS_DIGIT:
	@c:  an UNICODE value (int)

	Macro to check the following production in the XML spec

	[88] Digit ::= ... long list see REC ...
}
function  IS_DIGIT(c:longint):longint;cdecl;external LIBXML2_SO name 'xmlIsDigit';

{
	IS_COMBINING:
	@c:  an UNICODE value (int)

	Macro to check the following production in the XML spec

	[87] CombiningChar ::= ... long list see REC ...
}
function IS_COMBINING(c : longint) : longint; cdecl;external LIBXML2_SO name 'xmlIsCombining';

{
	IS_EXTENDER:
	@c:  an UNICODE value (int)

	Macro to check the following production in the XML spec


	[89] Extender ::= #x00B7 | #x02D0 | #x02D1 | #x0387 | #x0640 |
							 #x0E46 | #x0EC6 | #x3005 | [#x3031-#x3035] |
							 [#x309D-#x309E] | [#x30FC-#x30FE]
}
function IS_EXTENDER(c : longint) : longint; cdecl;external LIBXML2_SO name 'xmlIsExtender';
{
	IS_IDEOGRAPHIC:
	@c:  an UNICODE value (int)

	Macro to check the following production in the XML spec


	[86] Ideographic ::= [#x4E00-#x9FA5] | #x3007 | [#x3021-#x3029]
}
function IS_IDEOGRAPHIC(c : longint) : longint;cdecl;external LIBXML2_SO name 'xmlIsIdeographic';

{
	IS_LETTER:
	@c:  an UNICODE value (int)

	Macro to check the following production in the XML spec

	[84] Letter ::= BaseChar | Ideographic
}
function IS_LETTER(c : longint) : longint; cdecl;external LIBXML2_SO name 'xmlIsLetter';
{
	IS_PUBIDCHAR:
	@c:  an UNICODE value (int)

	Macro to check the following production in the XML spec

	[13] PubidChar ::= #x20 | #xD | #xA | [a-zA-Z0-9] | [-'()+,./:=?;! #@$_%]
}
function IS_PUBIDCHAR(c : longint) : longint; cdecl;external LIBXML2_SO name 'xmlIsPubidChar';

{
	SKIP_EOL:
	@p:  and UTF8 string pointer

	Skips the end of line chars
}
procedure SKIP_EOL(var p: PxmlChar); //[pk] implemented in libxml2.pas
{
	MOVETO_ENDTAG:
	@p:  and UTF8 string pointer

	Skips to the next '>' char
}
procedure MOVETO_ENDTAG(var p: PxmlChar); //[pk] implemented in libxml2.pas
{
	MOVETO_STARTTAG:
	@p:  and UTF8 string pointer

	Skips to the next '<' char
}
procedure MOVETO_STARTTAG(var p: PxmlChar); //[pk] implemented in libxml2.pas
{
	Global variables used for predefined strings
}

(*[pk]: todo somehow
LIBXML_DLL_IMPORT extern const xmlChar xmlStringTextNoenc[];
LIBXML_DLL_IMPORT extern const xmlChar xmlStringComment[];
*)

{
	Function to finish the work of the macros where needed
}
function  xmlIsBaseChar(c:longint): LongBool; cdecl;external LIBXML2_SO;
function  xmlIsBlank(c:longint): LongBool; cdecl;external LIBXML2_SO;
function  xmlIsPubidChar(c:longint): LongBool; cdecl;external LIBXML2_SO;
function  xmlIsLetter(c:longint): LongBool; cdecl;external LIBXML2_SO;
function  xmlIsDigit(c:longint): LongBool; cdecl;external LIBXML2_SO;
function  xmlIsIdeographic(c:longint): LongBool; cdecl;external LIBXML2_SO;
function  xmlIsCombining(c:longint): LongBool; cdecl;external LIBXML2_SO;
function  xmlIsExtender(c:longint): LongBool; cdecl;external LIBXML2_SO;
function  xmlIsChar(c:longint): LongBool; cdecl;external LIBXML2_SO;

{
	Parser context
}
function  xmlCreateFileParserCtxt(filename:Pchar):xmlParserCtxtPtr;cdecl;external LIBXML2_SO;
function  xmlCreateMemoryParserCtxt(buffer:Pchar; size:longint):xmlParserCtxtPtr;cdecl;external LIBXML2_SO;
function  xmlNewParserCtxt:xmlParserCtxtPtr;cdecl;external LIBXML2_SO;
function  xmlCreateEntityParserCtxt(URL:PxmlChar; ID:PxmlChar; base:PxmlChar):xmlParserCtxtPtr;cdecl;external LIBXML2_SO;
function  xmlSwitchEncoding(ctxt:xmlParserCtxtPtr; enc:xmlCharEncoding):longint;cdecl;external LIBXML2_SO;
function  xmlSwitchToEncoding(ctxt:xmlParserCtxtPtr; handler:xmlCharEncodingHandlerPtr):longint;cdecl;external LIBXML2_SO;
//[pk] see "parser": procedure xmlFreeParserCtxt(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;

{
	Entities
}
procedure xmlHandleEntity(ctxt:xmlParserCtxtPtr; entity:xmlEntityPtr);cdecl;external LIBXML2_SO;

{
	Input Streams
}
function  xmlNewStringInputStream(ctxt:xmlParserCtxtPtr; buffer:PxmlChar):xmlParserInputPtr;cdecl;external LIBXML2_SO;
function  xmlNewEntityInputStream(ctxt:xmlParserCtxtPtr; entity:xmlEntityPtr):xmlParserInputPtr;cdecl;external LIBXML2_SO;
procedure xmlPushInput(ctxt:xmlParserCtxtPtr; input:xmlParserInputPtr);cdecl;external LIBXML2_SO;
function  xmlPopInput(ctxt:xmlParserCtxtPtr):xmlChar;cdecl;external LIBXML2_SO;
procedure xmlFreeInputStream(input:xmlParserInputPtr);cdecl;external LIBXML2_SO;
function  xmlNewInputFromFile(ctxt:xmlParserCtxtPtr; filename:Pchar):xmlParserInputPtr;cdecl;external LIBXML2_SO;
function  xmlNewInputStream(ctxt:xmlParserCtxtPtr):xmlParserInputPtr;cdecl;external LIBXML2_SO;

{
	Namespaces.
}
function  xmlSplitQName(ctxt:xmlParserCtxtPtr; name:PxmlChar; prefix:PPxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlNamespaceParseNCName(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlNamespaceParseQName(ctxt:xmlParserCtxtPtr; prefix:PPxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlNamespaceParseNSDef(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlParseQuotedString(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
procedure xmlParseNamespace(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;

{
	Generic production rules
}
function  xmlScanName(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlParseName(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlParseNmtoken(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlParseEntityValue(ctxt:xmlParserCtxtPtr; orig:PPxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlParseAttValue(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlParseSystemLiteral(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlParsePubidLiteral(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
procedure xmlParseCharData(ctxt:xmlParserCtxtPtr; cdata:longint);cdecl;external LIBXML2_SO;
function  xmlParseExternalID(ctxt:xmlParserCtxtPtr; publicID:PPxmlChar; strict:longint):PxmlChar;cdecl;external LIBXML2_SO;
procedure xmlParseComment(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
function  xmlParsePITarget(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
procedure xmlParsePI(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
procedure xmlParseNotationDecl(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
procedure xmlParseEntityDecl(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
function  xmlParseDefaultDecl(ctxt:xmlParserCtxtPtr; value:PPxmlChar):longint;cdecl;external LIBXML2_SO;
function  xmlParseNotationType(ctxt:xmlParserCtxtPtr):xmlEnumerationPtr;cdecl;external LIBXML2_SO;
function  xmlParseEnumerationType(ctxt:xmlParserCtxtPtr):xmlEnumerationPtr;cdecl;external LIBXML2_SO;
function  xmlParseEnumeratedType(ctxt:xmlParserCtxtPtr; var tree:xmlEnumerationPtr):longint;cdecl;external LIBXML2_SO;
function  xmlParseAttributeType(ctxt:xmlParserCtxtPtr; var tree:xmlEnumerationPtr):longint;cdecl;external LIBXML2_SO;
procedure xmlParseAttributeListDecl(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
function  xmlParseElementMixedContentDecl(ctxt:xmlParserCtxtPtr):xmlElementContentPtr;cdecl;external LIBXML2_SO;
{$ifdef VMS}
function  xmlParseElementChildrenContentD(ctxt:xmlParserCtxtPtr):xmlElementContentPtr;cdecl;external LIBXML2_SO;
const
	xmlParseElementChildrenContentDecl = xmlParseElementChildrenContentD;
{$else}
function  xmlParseElementChildrenContentDecl(ctxt:xmlParserCtxtPtr):xmlElementContentPtr;cdecl;external LIBXML2_SO;
{$endif}
function  xmlParseElementContentDecl(ctxt:xmlParserCtxtPtr; name:PxmlChar; var result:xmlElementContentPtr):longint;cdecl;external LIBXML2_SO;
function  xmlParseElementDecl(ctxt:xmlParserCtxtPtr):longint;cdecl;external LIBXML2_SO;
procedure xmlParseMarkupDecl(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
function  xmlParseCharRef(ctxt:xmlParserCtxtPtr):longint;cdecl;external LIBXML2_SO;
function  xmlParseEntityRef(ctxt:xmlParserCtxtPtr):xmlEntityPtr;cdecl;external LIBXML2_SO;
procedure xmlParseReference(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
procedure xmlParsePEReference(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
procedure xmlParseDocTypeDecl(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
function  xmlParseAttribute(ctxt:xmlParserCtxtPtr; value:PPxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlParseStartTag(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
procedure xmlParseEndTag(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
procedure xmlParseCDSect(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
procedure xmlParseContent(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
procedure xmlParseElement(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
function  xmlParseVersionNum(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlParseVersionInfo(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlParseEncName(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlParseEncodingDecl(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlParseSDDecl(ctxt:xmlParserCtxtPtr):longint;cdecl;external LIBXML2_SO;
procedure xmlParseXMLDecl(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
procedure xmlParseTextDecl(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
procedure xmlParseMisc(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;

procedure xmlParseExternalSubset(ctxt:xmlParserCtxtPtr; ExternalID:PxmlChar; SystemID:PxmlChar);cdecl;external LIBXML2_SO;

const
	{
		XML_SUBSTITUTE_NONE:

		If no entities need to be substituted
	}
	XML_SUBSTITUTE_NONE = 0;
	{
		XML_SUBSTITUTE_REF:

		Whether general entities need to be substituted
	}
	XML_SUBSTITUTE_REF = 1;
	{
		XML_SUBSTITUTE_PEREF:

		Whether parameter entities need to be substituted
	}
	XML_SUBSTITUTE_PEREF = 2;
	{
		XML_SUBSTITUTE_BOTH:

		Both general and parameter entities need to be substituted
	}
	XML_SUBSTITUTE_BOTH = 3;

function  xmlDecodeEntities(ctxt:xmlParserCtxtPtr; len:longint; what:longint; end1,end2,end3:xmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlStringDecodeEntities(ctxt:xmlParserCtxtPtr; str:PxmlChar; what:longint; end1,end2,end3:xmlChar):PxmlChar;cdecl;external LIBXML2_SO;

{
	Generated by MACROS on top of parser.c c.f. PUSH_AND_POP
}
function  nodePush(ctxt:xmlParserCtxtPtr; value:xmlNodePtr):longint;cdecl;external LIBXML2_SO;
function  nodePop(ctxt:xmlParserCtxtPtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  inputPush(ctxt:xmlParserCtxtPtr; value:xmlParserInputPtr):longint;cdecl;external LIBXML2_SO;
function  inputPop(ctxt:xmlParserCtxtPtr):xmlParserInputPtr;cdecl;external LIBXML2_SO;
function  namePop(ctxt:xmlParserCtxtPtr):PxmlChar;cdecl;external LIBXML2_SO;
function  namePush(ctxt:xmlParserCtxtPtr; value:PxmlChar):longint;cdecl;external LIBXML2_SO;

{
	other commodities shared between parser.c and parserInternals
}
function  xmlSkipBlankChars(ctxt:xmlParserCtxtPtr):longint;cdecl;external LIBXML2_SO;
function  xmlStringCurrentChar(ctxt:xmlParserCtxtPtr; cur:PxmlChar; len:Plongint):longint;cdecl;external LIBXML2_SO;
procedure xmlParserHandlePEReference(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
procedure xmlParserHandleReference(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
function  xmlCheckLanguageID(lang:PxmlChar):longint;cdecl;external LIBXML2_SO;

{
	Really core function  shared with HTML parser
}
function  xmlCurrentChar(ctxt:xmlParserCtxtPtr; len:Plongint):longint;cdecl;external LIBXML2_SO;
function  xmlCopyCharMultiByte(out:PxmlChar; val:longint):longint;cdecl;external LIBXML2_SO;
function  xmlCopyChar(len:longint; out:PxmlChar; val:longint):longint;cdecl;external LIBXML2_SO;
procedure xmlNextChar(ctxt:xmlParserCtxtPtr);cdecl;external LIBXML2_SO;
procedure xmlParserInputShrink(inp:xmlParserInputPtr);cdecl;external LIBXML2_SO;

{$ifdef LIBXML_HTML_ENABLED}
{
	Actually comes from the HTML parser but launched from the init stuff
}
procedure htmlInitAutoClose;cdecl;external LIBXML2_SO;
function  htmlCreateFileParserCtxt(filename:Pchar; encoding:Pchar):htmlParserCtxtPtr;cdecl;external LIBXML2_SO;
{$endif}

