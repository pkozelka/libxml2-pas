// CVS-SIGN: [1.20] HTMLtree.h
{
  ------------------------------------------------------------------------------
  Translated into pascal with help of h2pas utility from the FreePascal project.
  Petr Kozelka <pkozelka@email.cz>
  ------------------------------------------------------------------------------
}
(*
 * HTMLtree.h : describes the structures found in an tree resulting
 *              from an XML parsing.
 *
 * See Copyright for the status of this software.
 *
 * daniel@veillard.com
 *)

const
  (**
   * HTML_TEXT_NODE:
   *
   * Macro, a text node in a HTML document is really implemented
   * the same way as a text node in an XML document.
   *)
  HTML_TEXT_NODE = XML_TEXT_NODE;

  (**
   *
   * Macro, an entity reference in a HTML document is really implemented
   * the same way as an entity reference in an XML document.
   *)
  HTML_ENTITY_REF_NODE = XML_ENTITY_REF_NODE;

  (**
   * HTML_COMMENT_NODE:
   *
   * Macro, a comment in a HTML document is really implemented
   * the same way as a comment in an XML document.
   *)
  HTML_COMMENT_NODE = XML_COMMENT_NODE;

  (**
   * HTML_PRESERVE_NODE:
   *
   * Macro, a preserved node in a HTML document is really implemented
   * the same way as a CDATA section in an XML document.
   *)
  HTML_PRESERVE_NODE = XML_CDATA_SECTION_NODE;

  (**
   * HTML_PI_NODE:
   *
   * Macro, a processing instruction in a HTML document is really implemented
   * the same way as a processing instruction in an XML document.
   *)
  HTML_PI_NODE = XML_PI_NODE;

function  htmlNewDoc(URI: PxmlChar; ExternalID: PxmlChar): htmlDocPtr; cdecl; external LIBXML2_SO;
function  htmlNewDocNoDtD(URI: PxmlChar; ExternalID: PxmlChar): htmlDocPtr; cdecl; external LIBXML2_SO;
function  htmlGetMetaEncoding(doc: htmlDocPtr): PxmlChar; cdecl; external LIBXML2_SO;
function  htmlSetMetaEncoding(doc: htmlDocPtr; encoding: PxmlChar): Longint; cdecl; external LIBXML2_SO;
procedure htmlDocDumpMemory(cur: xmlDocPtr; mem: PPxmlChar; size: PLongint); cdecl; external LIBXML2_SO;
function  htmlDocDump(var f: TextFile; cur: xmlDocPtr): Longint; cdecl; external LIBXML2_SO;
function  htmlSaveFile(filename: PChar; cur: xmlDocPtr): Longint; cdecl; external LIBXML2_SO;
procedure htmlNodeDump(buf: xmlBufferPtr; doc: xmlDocPtr; cur: xmlNodePtr); cdecl; external LIBXML2_SO;
procedure htmlNodeDumpFile(var aOut: TextFile; doc: xmlDocPtr; cur: xmlNodePtr); cdecl; external LIBXML2_SO;
function  htmlNodeDumpFileFormat(var aOut: TextFile; doc: xmlDocPtr; cur: xmlNodePtr; encoding: PChar; format: Longint): Longint; cdecl; external LIBXML2_SO;
function  htmlSaveFileEnc(filename: PChar; cur: xmlDocPtr; encoding: PChar): Longint; cdecl; external LIBXML2_SO;
function  htmlSaveFileFormat(filename: PChar; cur: xmlDocPtr; encoding: PChar; format: Longint): Longint; cdecl; external LIBXML2_SO;
procedure htmlNodeDumpFormatOutput(buf: xmlOutputBufferPtr; doc: xmlDocPtr; cur: xmlDocPtr; encoding: PChar; format: Longint); cdecl; external LIBXML2_SO;
procedure htmlDocContentDumpOutput(buf: xmlOutputBufferPtr; cur: xmlDocPtr; encoding: PChar); cdecl; external LIBXML2_SO;
procedure htmlDocContentDumpFormatOutput(buf: xmlOutputBufferPtr; cur: xmlDocPtr; encoding: PChar; format: Longint); cdecl; external LIBXML2_SO;

