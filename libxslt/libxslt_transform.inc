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
	 transform.h: Interfaces, constants and types related to the XSLT engine transform part.
	 See Copyright for the status of this software.
	 daniel@veillard.com
}


{
	XInclude default processing
}


procedure xsltSetXIncludeDefault(xinclude:longint);cdecl;external LIBXSLT_SO;
function  xsltGetXIncludeDefault:longint;cdecl;external LIBXSLT_SO;

{
	Export context to users.
}
function  xsltNewTransformContext(style:xsltStylesheetPtr; doc:xmlDocPtr):xsltTransformContextPtr;cdecl;external LIBXSLT_SO;
procedure xsltFreeTransformContext(ctxt:xsltTransformContextPtr);cdecl;external LIBXSLT_SO;
function  xsltApplyStylesheetUser(style:xsltStylesheetPtr; doc:xmlDocPtr; params:PPchar; output:Pchar; var profile:TextFile; userCtxt:xsltTransformContextPtr):xmlDocPtr;cdecl;external LIBXSLT_SO;

{
	Private Interfaces
}
procedure xsltApplyStripSpaces(ctxt:xsltTransformContextPtr; node:xmlNodePtr);cdecl;external LIBXSLT_SO;
function  xsltExtElementLookup(ctxt:xsltTransformContextPtr; name:PxmlChar; URI:PxmlChar):xsltTransformFunction;cdecl;external LIBXSLT_SO;
function  xsltApplyStylesheet(style:xsltStylesheetPtr; doc:xmlDocPtr; params:PPchar):xmlDocPtr;cdecl;external LIBXSLT_SO;
function  xsltProfileStylesheet(style:xsltStylesheetPtr; doc:xmlDocPtr; params:PPchar; var output:TextFile):xmlDocPtr;cdecl;external LIBXSLT_SO;
function  xsltRunStylesheet(style:xsltStylesheetPtr; doc:xmlDocPtr; params:PPchar; output:Pchar; SAX:xmlSAXHandlerPtr; IObuf:xmlOutputBufferPtr):longint;cdecl;external LIBXSLT_SO;
procedure xsltApplyOneTemplate(ctxt:xsltTransformContextPtr; node:xmlNodePtr; list:xmlNodePtr; templ:xsltTemplatePtr; params:xsltStackElemPtr);cdecl;external LIBXSLT_SO;
procedure xsltDocumentElem(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltSort(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltCopy(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltText(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltElement(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltComment(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltAttribute(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltProcessingInstruction(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltCopyOf(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltValueOf(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltNumber(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltApplyImports(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltCallTemplate(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltApplyTemplates(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltChoose(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltIf(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltForEach(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltRegisterAllElement(ctxt:xsltTransformContextPtr);cdecl;external LIBXSLT_SO;

{
	Hook for the debugger if activated.
}
procedure xslHandleDebugger(cur:xmlNodePtr; node:xmlNodePtr; templ:xsltTemplatePtr; ctxt:xsltTransformContextPtr);cdecl;external LIBXSLT_SO;


