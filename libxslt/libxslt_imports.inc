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
     imports.h: interface for the XSLT import support

     See Copyright for the status of this software.

     daniel@veillard.com
    }
  {
     XSLT_GET_IMPORT_PTR:
    
     a macro to import pointers from the stylesheet cascading order
    }

    {
       Module interfaces
      }

    procedure xsltParseStylesheetInclude(style:xsltStylesheetPtr; cur:xmlNodePtr);cdecl;external LIBXSLT_SO;

    function xsltNextImport(style:xsltStylesheetPtr):xsltStylesheetPtr;cdecl;external LIBXSLT_SO;

    function xsltNeedElemSpaceHandling(ctxt:xsltTransformContextPtr):longint;cdecl;external LIBXSLT_SO;

    function xsltFindElemSpaceHandling(ctxt:xsltTransformContextPtr; node:xmlNodePtr):longint;cdecl;external LIBXSLT_SO;

    function xsltFindTemplate(ctxt:xsltTransformContextPtr; name:PxmlChar; nameURI:PxmlChar):xsltTemplatePtr;cdecl;external LIBXSLT_SO;


