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
	templates.h: interface for the template processing

	See Copyright for the status of this software.

	daniel@veillard.com
}
function xsltEvalXPathPredicate(ctxt:xsltTransformContextPtr; comp:xmlXPathCompExprPtr; nsList:PxmlNsPtr; nsNr:longint):longint;cdecl;external LIBXSLT_SO;
function xsltEvalTemplateString(ctxt:xsltTransformContextPtr; node:xmlNodePtr; parent:xmlNodePtr):PxmlChar;cdecl;external LIBXSLT_SO;
function xsltEvalAttrValueTemplate(ctxt:xsltTransformContextPtr; node:xmlNodePtr; name:PxmlChar; ns:PxmlChar):PxmlChar;cdecl;external LIBXSLT_SO;
function xsltEvalStaticAttrValueTemplate(style:xsltStylesheetPtr; node:xmlNodePtr; name:PxmlChar; ns:PxmlChar; found:Plongint):PxmlChar;cdecl;external LIBXSLT_SO;
{ TODO: this is obviously broken ... the namespaces should be passed too !  }
function xsltEvalXPathString(ctxt:xsltTransformContextPtr; comp:xmlXPathCompExprPtr):PxmlChar;cdecl;external LIBXSLT_SO;
function xsltTemplateProcess(ctxt:xsltTransformContextPtr; node:xmlNodePtr):PxmlNodePtr;cdecl;external LIBXSLT_SO;
function xsltAttrListTemplateProcess(ctxt:xsltTransformContextPtr; target:xmlNodePtr; cur:xmlAttrPtr):xmlAttrPtr;cdecl;external LIBXSLT_SO;
function xsltAttrTemplateProcess(ctxt:xsltTransformContextPtr; target:xmlNodePtr; attr:xmlAttrPtr):xmlAttrPtr;cdecl;external LIBXSLT_SO;
function xsltAttrTemplateValueProcess(ctxt:xsltTransformContextPtr; attr:PxmlChar):PxmlChar;cdecl;external LIBXSLT_SO;

