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
     attributes.h: interface for the XSLT attribute handling
    
     See Copyright for the status of this software.
    
     daniel@veillard.com
    }

  procedure xsltParseStylesheetAttributeSet(style:xsltStylesheetPtr; cur:xmlNodePtr);cdecl;external LIBXSLT_SO;

  procedure xsltFreeAttributeSetsHashes(style:xsltStylesheetPtr);cdecl;external LIBXSLT_SO;

  procedure xsltApplyAttributeSet(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; attributes:PxmlChar);cdecl;external LIBXSLT_SO;



