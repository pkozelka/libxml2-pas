// CVS-SIGN: [1.16] SAX.h
{
  ------------------------------------------------------------------------------
  Translated into pascal with help of h2pas utility from the FreePascal project.
  Petr Kozelka <pkozelka@email.cz>
  ------------------------------------------------------------------------------
}
(*
 * SAX.h : Default SAX handler interfaces.
 *
 * See Copyright for the status of this software.
 *
 * Daniel Veillard <daniel@veillard.com>
 *)

function  getPublicId(ctx:pointer):PxmlChar;cdecl;external LIBXML2_SO;
function  getSystemId(ctx:pointer):PxmlChar;cdecl;external LIBXML2_SO;
procedure setDocumentLocator(ctx:pointer; loc:xmlSAXLocatorPtr);cdecl;external LIBXML2_SO;
function  getLineNumber(ctx:pointer):longint;cdecl;external LIBXML2_SO;
function  getColumnNumber(ctx:pointer):longint;cdecl;external LIBXML2_SO;
function  isStandalone(ctx:pointer):longint;cdecl;external LIBXML2_SO;
function  hasInternalSubset(ctx:pointer):longint;cdecl;external LIBXML2_SO;
function  hasExternalSubset(ctx:pointer):longint;cdecl;external LIBXML2_SO;
procedure internalSubset(ctx:pointer; name:PxmlChar; ExternalID:PxmlChar; SystemID:PxmlChar);cdecl;external LIBXML2_SO;
procedure externalSubset(ctx:pointer; name:PxmlChar; ExternalID:PxmlChar; SystemID:PxmlChar);cdecl;external LIBXML2_SO;
function  getEntity(ctx:pointer; name:PxmlChar):xmlEntityPtr;cdecl;external LIBXML2_SO;
function  getParameterEntity(ctx:pointer; name:PxmlChar):xmlEntityPtr;cdecl;external LIBXML2_SO;
function  resolveEntity(ctx:pointer; publicId:PxmlChar; systemId:PxmlChar):xmlParserInputPtr;cdecl;external LIBXML2_SO;
procedure entityDecl(ctx:pointer; name:PxmlChar; aType:longint; publicId:PxmlChar; systemId:PxmlChar; content:PxmlChar);cdecl;external LIBXML2_SO;
procedure attributeDecl(ctx:pointer; elem:PxmlChar; fullname:PxmlChar; aType:longint; def:longint; defaultValue:PxmlChar; tree:xmlEnumerationPtr);cdecl;external LIBXML2_SO;
procedure elementDecl(ctx:pointer; name:PxmlChar; aType:longint; content:xmlElementContentPtr);cdecl;external LIBXML2_SO;
procedure notationDecl(ctx:pointer; name:PxmlChar; publicId:PxmlChar; systemId:PxmlChar);cdecl;external LIBXML2_SO;
procedure unparsedEntityDecl(ctx:pointer; name:PxmlChar; publicId:PxmlChar; systemId:PxmlChar; notationName:PxmlChar);cdecl;external LIBXML2_SO;
procedure startDocument(ctx:pointer);cdecl;external LIBXML2_SO;
procedure endDocument(ctx:pointer);cdecl;external LIBXML2_SO;
procedure attribute(ctx:pointer; fullname:PxmlChar; value:PxmlChar);cdecl;external LIBXML2_SO;
procedure startElement(ctx:pointer; fullname:PxmlChar; atts:PPxmlChar);cdecl;external LIBXML2_SO;
procedure endElement(ctx:pointer; name:PxmlChar);cdecl;external LIBXML2_SO;
procedure reference(ctx:pointer; name:PxmlChar);cdecl;external LIBXML2_SO;
procedure characters(ctx:pointer; ch:PxmlChar; len:longint);cdecl;external LIBXML2_SO;
procedure ignorableWhitespace(ctx:pointer; ch:PxmlChar; len:longint);cdecl;external LIBXML2_SO;
procedure processingInstruction(ctx:pointer; target:PxmlChar; data:PxmlChar);cdecl;external LIBXML2_SO;
procedure globalNamespace(ctx:pointer; href:PxmlChar; prefix:PxmlChar);cdecl;external LIBXML2_SO;
procedure setNamespace(ctx:pointer; name:PxmlChar);cdecl;external LIBXML2_SO;
function  getNamespace(ctx:pointer):xmlNsPtr;cdecl;external LIBXML2_SO;
function  checkNamespace(ctx:pointer; nameSpace:PxmlChar):longint;cdecl;external LIBXML2_SO;
procedure namespaceDecl(ctx:pointer; href:PxmlChar; prefix:PxmlChar);cdecl;external LIBXML2_SO;
procedure comment(ctx:pointer; value:PxmlChar);cdecl;external LIBXML2_SO;
procedure cdataBlock(ctx:pointer; value:PxmlChar; len:longint);cdecl;external LIBXML2_SO;
{$ifdef LIBXML_HTML_ENABLED}
procedure inithtmlDefaultSAXHandler	(hdlr: xmlSAXHandlerPtr); cdecl;external LIBXML2_SO;
{$endif}
{$ifdef LIBXML_DOCB_ENABLED}
procedure initdocbDefaultSAXHandler	(hdlr: xmlSAXHandlerPtr); cdecl;external LIBXML2_SO;
{$endif}
procedure xmlDefaultSAXHandlerInit;cdecl;external LIBXML2_SO;
procedure htmlDefaultSAXHandlerInit;cdecl;external LIBXML2_SO;
procedure docbDefaultSAXHandlerInit;cdecl;external LIBXML2_SO;

