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
     namespaces.h: interface for the XSLT namespace handling
    
     See Copyright for the status of this software.
    
     daniel@veillard.com
    }

  procedure xsltNamespaceAlias(style:xsltStylesheetPtr; node:xmlNodePtr);cdecl;external LIBXSLT_SO;

  function xsltGetNamespace(ctxt:xsltTransformContextPtr; cur:xmlNodePtr; ns:xmlNsPtr; out:xmlNodePtr):xmlNsPtr;cdecl;external LIBXSLT_SO;

  function xsltGetSpecialNamespace(ctxt:xsltTransformContextPtr; cur:xmlNodePtr; URI:PxmlChar; prefix:PxmlChar; out:xmlNodePtr):xmlNsPtr;cdecl;external LIBXSLT_SO;

  function xsltCopyNamespace(ctxt:xsltTransformContextPtr; node:xmlNodePtr; cur:xmlNsPtr):xmlNsPtr;cdecl;external LIBXSLT_SO;

  function xsltCopyNamespaceList(ctxt:xsltTransformContextPtr; node:xmlNodePtr; cur:xmlNsPtr):xmlNsPtr;cdecl;external LIBXSLT_SO;

  procedure xsltFreeNamespaceAliasHashes(style:xsltStylesheetPtr);cdecl;external LIBXSLT_SO;

