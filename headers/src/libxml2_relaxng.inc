// CVS-REV:gnome-xml/include/libxml/relaxng.h:1.12:
{
  ------------------------------------------------------------------------------
  Translated into pascal with help of h2pas utility from the FreePascal project.
  Petr Kozelka <pkozelka@email.cz>
  ------------------------------------------------------------------------------
}
(*
 * relaxng.h: header for the implementation of the Relax-NG validation
 *
 * See Copyright for the status of this software.
 *
 * daniel@veillard.com
 *)
type
  xmlRelaxNG = record end;
  xmlRelaxNGPtr = ^xmlRelaxNG;

  (*
   * A schemas validation context
   *)
  xmlRelaxNGValidityErrorFunc = procedure (ctx: Pointer; msg: Pchar); cdecl;  {$IFDEF HAS_TVA} varargs; {$ENDIF}
  xmlRelaxNGValidityWarningFunc = procedure (ctx: Pointer; msg: Pchar); cdecl;  {$IFDEF HAS_TVA} varargs; {$ENDIF}

  xmlRelaxNGParserCtxt = record end;
  xmlRelaxNGParserCtxtPtr = ^xmlRelaxNGParserCtxt;
  xmlRelaxNGValidCtxt = record end;
  xmlRelaxNGValidCtxtPtr = ^xmlRelaxNGValidCtxt;


  (*
   * xmlRelaxNGValidErr:
   *
   * List of possible Relax NG validation errors
   *)
  xmlRelaxNGValidErr = (
    XML_RELAXNG_OK,         // = 0
    XML_RELAXNG_ERR_MEMORY, // = 1
    XML_RELAXNG_ERR_TYPE,
    XML_RELAXNG_ERR_TYPEVAL,
    XML_RELAXNG_ERR_DUPID,
    XML_RELAXNG_ERR_TYPECMP,
    XML_RELAXNG_ERR_NOSTATE,
    XML_RELAXNG_ERR_NODEFINE,
    XML_RELAXNG_ERR_LISTEXTRA,
    XML_RELAXNG_ERR_LISTEMPTY,
    XML_RELAXNG_ERR_INTERNODATA,
    XML_RELAXNG_ERR_INTERSEQ,
    XML_RELAXNG_ERR_INTEREXTRA,
    XML_RELAXNG_ERR_ELEMNAME,
    XML_RELAXNG_ERR_ATTRNAME,
    XML_RELAXNG_ERR_ELEMNONS,
    XML_RELAXNG_ERR_ATTRNONS,
    XML_RELAXNG_ERR_ELEMWRONGNS,
    XML_RELAXNG_ERR_ATTRWRONGNS,
    XML_RELAXNG_ERR_ELEMEXTRANS,
    XML_RELAXNG_ERR_ATTREXTRANS,
    XML_RELAXNG_ERR_ELEMNOTEMPTY,
    XML_RELAXNG_ERR_NOELEM,
    XML_RELAXNG_ERR_NOTELEM,
    XML_RELAXNG_ERR_ATTRVALID,
    XML_RELAXNG_ERR_CONTENTVALID,
    XML_RELAXNG_ERR_EXTRACONTENT,
    XML_RELAXNG_ERR_INVALIDATTR,
    XML_RELAXNG_ERR_DATAELEM,
    XML_RELAXNG_ERR_VALELEM,
    XML_RELAXNG_ERR_LISTELEM,
    XML_RELAXNG_ERR_DATATYPE,
    XML_RELAXNG_ERR_VALUE,
    XML_RELAXNG_ERR_LIST,
    XML_RELAXNG_ERR_NOGRAMMAR,
    XML_RELAXNG_ERR_EXTRADATA,
    XML_RELAXNG_ERR_LACKDATA,
    XML_RELAXNG_ERR_INTERNAL,
    XML_RELAXNG_ERR_ELEMWRONG,
    XML_RELAXNG_ERR_TEXTWRONG
  );

(*
 * Interfaces for parsing.
 *)
function xmlRelaxNGNewParserCtxt(URL: Pchar): xmlRelaxNGParserCtxtPtr; cdecl; external LIBXML2_SO;
function xmlRelaxNGNewMemParserCtxt(buffer: Pchar; size: Longint): xmlRelaxNGParserCtxtPtr; cdecl; external LIBXML2_SO;
function xmlRelaxNGNewDocParserCtxt(doc: xmlDocPtr): xmlRelaxNGParserCtxtPtr; cdecl; external LIBXML2_SO;
procedure xmlRelaxNGFreeParserCtxt(ctxt: xmlRelaxNGParserCtxtPtr); cdecl; external LIBXML2_SO;
procedure xmlRelaxNGSetParserErrors(ctxt: xmlRelaxNGParserCtxtPtr; err: xmlRelaxNGValidityErrorFunc; warn: xmlRelaxNGValidityWarningFunc; ctx: Pointer); cdecl; external LIBXML2_SO;
function xmlRelaxNGGetParserErrors(ctxt: xmlRelaxNGParserCtxtPtr; var err: xmlRelaxNGValidityErrorFunc; var warn: xmlRelaxNGValidityWarningFunc; var ctx: Pointer): Longint; cdecl; external LIBXML2_SO;
function xmlRelaxNGParse(ctxt: xmlRelaxNGParserCtxtPtr): xmlRelaxNGPtr; cdecl; external LIBXML2_SO;
procedure xmlRelaxNGFree(schema: xmlRelaxNGPtr); cdecl; external LIBXML2_SO;
procedure xmlRelaxNGDump(output: PLibXml2File; schema: xmlRelaxNGPtr); cdecl; external LIBXML2_SO;
procedure xmlRelaxNGDumpTree (output: PLibXml2File; schema: xmlRelaxNGPtr); cdecl; external LIBXML2_SO;
(*
 * Interfaces for validating
 *)
procedure xmlRelaxNGSetValidErrors(ctxt: xmlRelaxNGValidCtxtPtr; err: xmlRelaxNGValidityErrorFunc; warn: xmlRelaxNGValidityWarningFunc; ctx: Pointer); cdecl; external LIBXML2_SO;
function xmlRelaxNGGetValidErrors(ctxt: xmlRelaxNGValidCtxtPtr; var err: xmlRelaxNGValidityErrorFunc; var warn: xmlRelaxNGValidityWarningFunc; var ctx: Pointer): Longint; cdecl; external LIBXML2_SO;
function xmlRelaxNGNewValidCtxt(schema: xmlRelaxNGPtr): xmlRelaxNGValidCtxtPtr; cdecl; external LIBXML2_SO;
procedure xmlRelaxNGFreeValidCtxt(ctxt: xmlRelaxNGValidCtxtPtr); cdecl; external LIBXML2_SO;
function xmlRelaxNGValidateDoc(ctxt: xmlRelaxNGValidCtxtPtr; doc: xmlDocPtr): Longint; cdecl; external LIBXML2_SO;
procedure xmlRelaxNGCleanupTypes; cdecl; external LIBXML2_SO;
(*
 * Interfaces for progressive validation when possible
 *)
function xmlRelaxNGValidatePushElement (ctxt: xmlRelaxNGValidCtxtPtr; doc: xmlDocPtr; elem: xmlNodePtr): Longint; cdecl; external LIBXML2_SO;
function xmlRelaxNGValidatePushCData (ctxt: xmlRelaxNGValidCtxtPtr; data: PxmlChar; len: Longint): Longint; cdecl; external LIBXML2_SO;
function xmlRelaxNGValidatePopElement (ctxt: xmlRelaxNGValidCtxtPtr; doc: xmlDocPtr; elem: xmlNodePtr): Longint; cdecl; external LIBXML2_SO;
function xmlRelaxNGValidateFullElement (ctxt: xmlRelaxNGValidCtxtPtr; doc: xmlDocPtr; elem: xmlNodePtr): Longint; cdecl; external LIBXML2_SO;

