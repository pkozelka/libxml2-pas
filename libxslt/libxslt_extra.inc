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
     extra.h: interface for the non-standard features

     See Copyright for the status of this software.

     daniel@veillard.com
    }

  {
     XSLT_LIBXSLT_NAMESPACE:

     This is the libxslt namespace for specific extensions
    }
    function XSLT_LIBXSLT_NAMESPACE : PxmlChar;

  {
     XSLT_SAXON_NAMESPACE:

     This is Michael Kay's Saxon processor namespace for extensions
    }
    function XSLT_SAXON_NAMESPACE : PxmlChar;

  {
     XSLT_XT_NAMESPACE:

     This is James Clark's XT processor namespace for extensions
    }
    function XSLT_XT_NAMESPACE : PxmlChar;

  {
     XSLT_XALAN_NAMESPACE:

     This is the Apache project XALAN processor namespace for extensions
    }
    function XSLT_XALAN_NAMESPACE : PxmlChar;

  {
     XSLT_NORM_SAXON_NAMESPACE:

     This is Nom's namespace for SAXON extensions
    }
  function XSLT_NORM_SAXON_NAMESPACE : PxmlChar;

  procedure xsltFunctionNodeSet(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXSLT_SO;

  procedure xsltDebug(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;

  procedure xsltRegisterExtras(ctxt:xsltTransformContextPtr);cdecl;external LIBXSLT_SO;

  procedure xsltRegisterAllExtras;cdecl;external LIBXSLT_SO;

  //continue to read the code of libxslt_extra.imp


