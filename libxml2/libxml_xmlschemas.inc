// CVS-SIGN: [1.1] xmlschemas.h
(*
 * schemas.h: interface to the XML Schemas handling and schema validity
 *             checking
 *
 * See Copyright for the status of this software.
 *
 * Daniel.Veillard@w3.org
 *)
type
  xmlSchemaValidError =  Longint;
const
  XML_SCHEMAS_ERR_OK = 0;
  XML_SCHEMAS_ERR_NOROOT = 1;
  XML_SCHEMAS_ERR_UNDECLAREDELEM = 2;
  XML_SCHEMAS_ERR_NOTTOPLEVEL = 3;
  XML_SCHEMAS_ERR_MISSING = 4;
  XML_SCHEMAS_ERR_WRONGELEM = 5;
  XML_SCHEMAS_ERR_NOTYPE = 6;
  XML_SCHEMAS_ERR_NOROLLBACK = 7;
  XML_SCHEMAS_ERR_ISABSTRACT = 8;
  XML_SCHEMAS_ERR_NOTEMPTY = 9;
  XML_SCHEMAS_ERR_ELEMCONT = 10;
  XML_SCHEMAS_ERR_HAVEDEFAULT = 11;
  XML_SCHEMAS_ERR_NOTNILLABLE = 12;
  XML_SCHEMAS_ERR_EXTRACONTENT = 13;
  XML_SCHEMAS_ERR_INVALIDATTR = 14;
  XML_SCHEMAS_ERR_INVALIDELEM = 15;
  XML_SCHEMAS_ERR_CONSTRUCT = 16;
  XML_SCHEMAS_ERR_INTERNAL = 17;
  XML_SCHEMAS_ERR_NOTSIMPLE = 18;
  XML_SCHEMAS_ERR_ATTRUNKNOWN = 19;
  XML_SCHEMAS_ERR_ATTRINVALID = 20;
  XML_SCHEMAS_ERR_ = 21;
  XML_SCHEMAS_ERR_XXX = 22;
(*
 *  The schemas related types are kept internal
 *)
type
  xmlSchema = record end;
  xmlSchemaPtr = ^xmlSchema;

  (*
   *  A schemas validation context
   *)
  xmlSchemaValidityErrorFunc = procedure (ctx: Pointer; msg: Pchar; args: array of const);cdecl;
  xmlSchemaValidityWarningFunc = procedure (ctx: Pointer; msg: Pchar; args: array of const);cdecl;

  xmlSchemaParserCtxt = record end;
  xmlSchemaParserCtxtPtr = ^xmlSchemaParserCtxt;

  xmlSchemaValidCtxt = record end;
  xmlSchemaValidCtxtPtr = ^xmlSchemaValidCtxt;

(*
 * Interfaces for parsing.
 *)
function  xmlSchemaNewParserCtxt(URL: Pchar): xmlSchemaParserCtxtPtr; cdecl; external LIBXML2_SO;
procedure xmlSchemaFreeParserCtxt(ctxt: xmlSchemaParserCtxtPtr); cdecl; external LIBXML2_SO;
procedure xmlSchemaSetParserErrors(ctxt: xmlSchemaParserCtxtPtr; err: xmlSchemaValidityErrorFunc; warn: xmlSchemaValidityWarningFunc; ctx: Pointer); cdecl; external LIBXML2_SO;
function  xmlSchemaParse(ctxt: xmlSchemaParserCtxtPtr): xmlSchemaPtr; cdecl; external LIBXML2_SO;
procedure xmlSchemaFree(schema: xmlSchemaPtr); cdecl; external LIBXML2_SO;
procedure xmlSchemaDump(output: PLibXml2File; schema: xmlSchemaPtr); cdecl; external LIBXML2_SO;

(*
 * Interfaces for validating
 *)
procedure xmlSchemaSetValidErrors(ctxt: xmlSchemaValidCtxtPtr; err: xmlSchemaValidityErrorFunc; warn: xmlSchemaValidityWarningFunc; ctx: Pointer); cdecl; external LIBXML2_SO;
function  xmlSchemaNewValidCtxt(schema: xmlSchemaPtr): xmlSchemaValidCtxtPtr; cdecl; external LIBXML2_SO;
procedure xmlSchemaFreeValidCtxt(ctxt: xmlSchemaValidCtxtPtr); cdecl; external LIBXML2_SO;
function  xmlSchemaValidateDoc(ctxt: xmlSchemaValidCtxtPtr; instance: xmlDocPtr): Longint; cdecl; external LIBXML2_SO;
function  xmlSchemaValidateStream(ctxt: xmlSchemaValidCtxtPtr; input: xmlParserInputBufferPtr; enc: xmlCharEncoding; sax: xmlSAXHandlerPtr; user_data: Pointer): Longint; cdecl; external LIBXML2_SO;
