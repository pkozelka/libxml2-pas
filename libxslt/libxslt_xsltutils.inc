{
    ------------------------------------------------------------------------------
    Translated into pascal with help of h2pas utility from the FreePascal project.
    Copyright for the header translation:
        4commerce technologies AG
        Kamerbalken 10-14
        22525 Hamburg, Germany
    Published under a double license:
    a) the GNU Library General Public License: 
       http://www.gnu.org/copyleft/lgpl.html
    b) the Mozilla Public License:
       http://www.mozilla.org/MPL/MPL-1.1.html
    Please send corrections to: ufechner@4commerce.de
    ------------------------------------------------------------------------------
}
  {
     xsltutils.h: interfaces for the utilities module of the XSLT engine

     See Copyright for the status of this software.

     daniel@veillard.com
    }

  {
     TODO:

     macro to flag unimplemented blocks
    }
{$define XSLT_TODO}
(* error
    xsltGenericError(xsltGenericErrorContext,
(* error
	    "Unimplemented block at %s:%d\n",
 in declarator_list *)

(* error
            __FILE__, __LINE__);
 in declarator_list *)
  {
		 STRANGE:

     macro to flag that a problem was detected internally
    }
{$define XSLT_STRANGE}
(* error
    xsltGenericError(xsltGenericErrorContext,
(* error
	    "Internal error at %s:%d\n",
 in declarator_list *)

(* error
            __FILE__, __LINE__);
 in declarator_list *)
  {
     IS_XSLT_ELEM:

     Checks that the element pertains to XSLt namespace
    }
(* error
#define IS_XSLT_ELEM(n)
in define line 51 *)
(* error
    (((n) != NULL) && ((n)->ns != NULL) &&
    {
       IS_XSLT_NAME:

       Checks the value of an element in XSLT namespace
			}
in define line 60 *)
(* error
    (xmlStrEqual((n)->name, (const xmlChar *)
    {
       IS_XSLT_REAL_NODE:

       check that a node is a 'real' one: document, element, text or attribute
      }


(* error
    (((n) != NULL) &&
{$else}
in define line 78 *)
(* error
    (((n) != NULL) &&
{$endif}
    {
       Our own version of namespaced atributes lookup
      }
in declaration at line 92 *)
    {
       XSLT specific error and debug reporting functions
      }
(* error
LIBXSLT_PUBLIC extern xmlGenericErrorFunc xsltGenericError;
in declaration at line 97 *)
(* error
LIBXSLT_PUBLIC extern void *xsltGenericErrorContext;
in declaration at line 98 *)
(* error
LIBXSLT_PUBLIC extern xmlGenericErrorFunc xsltGenericDebug;
in declaration at line 99 *)
(* error
LIBXSLT_PUBLIC extern void *xsltGenericDebugContext;
in declaration at line 100 *)

procedure xsltPrintErrorContext(ctxt:xsltTransformContextPtr; style:xsltStylesheetPtr; node:xmlNodePtr);cdecl;external LIBXSLT_SO;
procedure xsltMessage(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr);cdecl;external LIBXSLT_SO;
//procedure xsltSetGenericErrorFunc(ctx:Pvoid; handler:xmlGenericErrorFunc);cdecl;external LIBXSLT_SO;
//procedure xsltSetGenericDebugFunc(ctx:Pvoid; handler:xmlGenericErrorFunc);cdecl;external LIBXSLT_SO;

{
	Sorting
}
procedure xsltDocumentSortFunction(list:xmlNodeSetPtr);cdecl;external LIBXSLT_SO;
procedure xsltDoSortFunction(ctxt:xsltTransformContextPtr; sorts:PxmlNodePtr; nbsorts:longint);cdecl;external LIBXSLT_SO;

{
	QNames handling
}
function xsltGetQNameURI(node:xmlNodePtr; name:PPxmlChar):PxmlChar;cdecl;external LIBXSLT_SO;

{
	Output, reuse libxml I/O buffers
}
function  xsltSaveResultTo(buf:xmlOutputBufferPtr; result:xmlDocPtr; style:xsltStylesheetPtr):longint;cdecl;external LIBXSLT_SO;
function  xsltSaveResultToFilename(URI:Pchar; result:xmlDocPtr; style:xsltStylesheetPtr; compression:longint):longint;cdecl;external LIBXSLT_SO;
function  xsltSaveResultToFile(file_:PFILE; result:xmlDocPtr; style:xsltStylesheetPtr):longint;cdecl;external LIBXSLT_SO;
function  xsltSaveResultToFd(fd:longint; result:xmlDocPtr; style:xsltStylesheetPtr):longint;cdecl;external LIBXSLT_SO;

{
	profiling
}
procedure xsltSaveProfiling(ctxt:xsltTransformContextPtr; output:PFILE);cdecl;external LIBXSLT_SO;
function  xsltTimestamp:longint;cdecl;external LIBXSLT_SO;
procedure xsltCalibrateAdjust(delta:longint);cdecl;external LIBXSLT_SO;

