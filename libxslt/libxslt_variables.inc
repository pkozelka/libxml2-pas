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
     variable.h: interface for the variable matching and lookup.
    
     See Copyright for the status of this software.
    
     daniel@veillard.com
    }

  { 
     XSLT_REGISTER_VARIABLE_LOOKUP:

     registering macro, not general purpose at all but used in different modules
    }

{
	Interfaces for the variable module.
}
type pvoid = pointer; //workaround
function  xsltEvalUserParams(ctxt:xsltTransformContextPtr; params:PPchar):longint;cdecl;external LIBXSLT_SO;
function  xsltQuoteUserParams(ctxt:xsltTransformContextPtr; params:PPchar):longint;cdecl;external LIBXSLT_SO;
function  xsltEvalOneUserParam(ctxt:xsltTransformContextPtr; name:PxmlChar; value:PxmlChar):longint;cdecl;external LIBXSLT_SO;
function  xsltQuoteOneUserParam(ctxt:xsltTransformContextPtr; name:PxmlChar; value:PxmlChar):longint;cdecl;external LIBXSLT_SO;
procedure xsltParseGlobalVariable(style:xsltStylesheetPtr; cur:xmlNodePtr);cdecl;external LIBXSLT_SO;
procedure xsltParseGlobalParam(style:xsltStylesheetPtr; cur:xmlNodePtr);cdecl;external LIBXSLT_SO;
procedure xsltParseStylesheetVariable(ctxt:xsltTransformContextPtr; cur:xmlNodePtr);cdecl;external LIBXSLT_SO;
procedure xsltParseStylesheetParam(ctxt:xsltTransformContextPtr; cur:xmlNodePtr);cdecl;external LIBXSLT_SO;
function  xsltParseStylesheetCallerParam(ctxt:xsltTransformContextPtr; cur:xmlNodePtr):xsltStackElemPtr;cdecl;external LIBXSLT_SO;
function  xsltAddStackElemList(ctxt:xsltTransformContextPtr; elems:xsltStackElemPtr):longint;cdecl;external LIBXSLT_SO;
procedure xsltFreeGlobalVariables(ctxt:xsltTransformContextPtr);cdecl;external LIBXSLT_SO;
function  xsltVariableLookup(ctxt:xsltTransformContextPtr; name:PxmlChar; ns_uri:PxmlChar):xmlXPathObjectPtr;cdecl;external LIBXSLT_SO;
function  xsltXPathVariableLookup(ctxt:Pvoid; name:PxmlChar; ns_uri:PxmlChar):xmlXPathObjectPtr;cdecl;external LIBXSLT_SO;

