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
	 key.h: interface for the key matching used in template matches.
    
	 See Copyright for the status of this software.

	 daniel@veillard.com
}
function  xsltAddKey(style:xsltStylesheetPtr; name:PxmlChar; nameURI:PxmlChar; match:PxmlChar; use:PxmlChar; inst:xmlNodePtr):longint;cdecl;external LIBXSLT_SO;
function  xsltGetKey(ctxt:xsltTransformContextPtr; name:PxmlChar; nameURI:PxmlChar; value:PxmlChar):xmlNodeSetPtr;cdecl;external LIBXSLT_SO;
procedure xsltInitCtxtKeys(ctxt:xsltTransformContextPtr; doc:xsltDocumentPtr);cdecl;external LIBXSLT_SO;
procedure xsltFreeKeys(style:xsltStylesheetPtr);cdecl;external LIBXSLT_SO;
procedure xsltFreeDocumentKeys(doc:xsltDocumentPtr);cdecl;external LIBXSLT_SO;

