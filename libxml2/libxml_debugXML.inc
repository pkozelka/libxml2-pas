// CVS-SIGN: [1.21] debugXML.h
{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}

(*
 * debugXML.h : Interfaces to a set of routines used for debugging the tree
 *              produced by the XML parser.
 *
 * Daniel Veillard <daniel@veillard.com>
 *)

(*
 * The standard Dump routines
 *)
procedure xmlDebugDumpString(var aOutput: TextFile; str:PxmlChar);cdecl;external LIBXML2_SO;
procedure xmlDebugDumpAttr(var aOutput: TextFile; attr:xmlAttrPtr; depth:longint);cdecl;external LIBXML2_SO;
procedure xmlDebugDumpAttrList(var aOutput: TextFile; attr:xmlAttrPtr; depth:longint);cdecl;external LIBXML2_SO;
procedure xmlDebugDumpOneNode(var aOutput: TextFile; node:xmlNodePtr; depth:longint);cdecl;external LIBXML2_SO;
procedure xmlDebugDumpNode(var aOutput: TextFile; node:xmlNodePtr; depth:longint);cdecl;external LIBXML2_SO;
procedure xmlDebugDumpNodeList(var aOutput: TextFile; node:xmlNodePtr; depth:longint);cdecl;external LIBXML2_SO;
procedure xmlDebugDumpDocumentHead(var aOutput: TextFile; doc:xmlDocPtr);cdecl;external LIBXML2_SO;
procedure xmlDebugDumpDocument(var aOutput: TextFile; doc:xmlDocPtr);cdecl;external LIBXML2_SO;
procedure xmlDebugDumpDTD(var aOutput: TextFile; dtd:xmlDtdPtr);cdecl;external LIBXML2_SO;
procedure xmlDebugDumpEntities(var aOutput: TextFile; doc:xmlDocPtr);cdecl;external LIBXML2_SO;
procedure xmlLsOneNode(var aOutput: TextFile; node:xmlNodePtr);cdecl;external LIBXML2_SO;
function  xmlBoolToText(boolval: longint): PChar; cdecl;external LIBXML2_SO;

(****************************************************************
 *								                                              *
 *	 The XML shell related structures and functions		          *
 *								                                              *
 ****************************************************************)

type
  (**
   * xmlShellReadlineFunc:
   * @prompt:  a string prompt
   *
   * This is a generic signature for the XML shell input function
   *
   * Returns a string which will be freed by the Shell
   *)
	xmlShellReadlineFunc = function (prompt:Pchar):Pchar;cdecl;

  (**
   * xmlShellCtxt:
   *
   * A debugging shell context
   * TODO: add the defined function tables.
   *)
	xmlShellCtxtPtr = ^xmlShellCtxt;
	xmlShellCtxt = record
		filename : Pchar;
		doc : xmlDocPtr;
		node : xmlNodePtr;
		pctxt : xmlXPathContextPtr;
		loaded : longint;
		output : ^TextFile;
		input : xmlShellReadlineFunc;
	end;

  (**
   * xmlShellCmd:
   * @ctxt:  a shell context
   * @arg:  a string argument
   * @node:  a first node
   * @node2:  a second node
   *
   * This is a generic signature for the XML shell functions
   *
   * Returns an int, negative returns indicating errors
   *)
	xmlShellCmd = function(ctxt: xmlShellCtxtPtr; arg: PChar; node, node2: xmlNodePtr): longint; cdecl;


procedure xmlShellPrintXPathError	(errorType: longint; arg: PChar); cdecl;external LIBXML2_SO;
procedure xmlShellPrintNode	(node: xmlNodePtr); cdecl;external LIBXML2_SO;
procedure xmlShellPrintXPathResult(list: xmlXPathObjectPtr); cdecl;external LIBXML2_SO;
function  xmlShellList(ctxt: xmlShellCtxtPtr; arg: PChar; node, node2: xmlNodePtr): longint; cdecl;external LIBXML2_SO;
function  xmlShellBase(ctxt: xmlShellCtxtPtr; arg: PChar; node, node2: xmlNodePtr): longint; cdecl;external LIBXML2_SO;
function  xmlShellDir(ctxt: xmlShellCtxtPtr; arg: PChar; node, node2: xmlNodePtr): longint; cdecl;external LIBXML2_SO;
function  xmlShellCat(ctxt: xmlShellCtxtPtr; arg: PChar; node, node2: xmlNodePtr): longint; cdecl;external LIBXML2_SO;
function  xmlShellLoad(ctxt: xmlShellCtxtPtr; filename: PChar; node, node2: xmlNodePtr): longint; cdecl;external LIBXML2_SO;
function  xmlShellWrite(ctxt: xmlShellCtxtPtr; filename: PChar; node, node2: xmlNodePtr): longint; cdecl;external LIBXML2_SO;
function  xmlShellSave(ctxt: xmlShellCtxtPtr; filename: PChar; node, node2: xmlNodePtr): longint; cdecl;external LIBXML2_SO;
function  xmlShellValidate(ctxt: xmlShellCtxtPtr; dtd: PChar; node, node2: xmlNodePtr): longint; cdecl;external LIBXML2_SO;
function  xmlShellDu(ctxt: xmlShellCtxtPtr; arg: PChar; node, node2: xmlNodePtr): longint; cdecl;external LIBXML2_SO;
function  xmlShellPwd(ctxt: xmlShellCtxtPtr; buffer: PChar; node, node2: xmlNodePtr): longint; cdecl;external LIBXML2_SO;

(*
 * The Shell interface.
 *)
procedure xmlShell(doc:xmlDocPtr; filename:Pchar; input:xmlShellReadlineFunc; var aOutput: TextFile);cdecl;external LIBXML2_SO;

