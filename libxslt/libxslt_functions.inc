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
     functions.h: interface for the XSLT extra functions

     See Copyright for the status of this software.

     daniel@veillard.com
     Bjorn Reese <breese@users.sourceforge.net> for number formatting
    }

  {
     XSLT_REGISTER_FUNCTION_LOOKUP:

     registering macro, not general purpose at all but used in different modules
    }

  (* error
  #define XSLT_REGISTER_FUNCTION_LOOKUP(ctxt)  xmlXPathRegisterFuncLookup((ctxt)->xpathCtxt,
  (xmlXPathFuncLookupFunc) xsltXPathFunctionLookup, (void //(ctxt->xpathCtxt));
  in declaration at line 26 *)

    function xsltXPathFunctionLookup(ctxt:xmlXPathContextPtr; name:PxmlChar; ns_uri:PxmlChar):xmlXPathFunction;cdecl;external LIBXSLT_SO;

    {
       Interfaces for the functions implementations
      }
    procedure xsltDocumentFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXSLT_SO;

    procedure xsltKeyFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXSLT_SO;

    procedure xsltUnparsedEntityURIFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXSLT_SO;

    procedure xsltFormatNumberFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXSLT_SO;

    procedure xsltGenerateIdFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXSLT_SO;

    procedure xsltSystemPropertyFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXSLT_SO;

    procedure xsltElementAvailableFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXSLT_SO;

    procedure xsltFunctionAvailableFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXSLT_SO;

    {
       And the registration
      }
    procedure xsltRegisterAllFunctions(ctxt:xmlXPathContextPtr);cdecl;external LIBXSLT_SO;


