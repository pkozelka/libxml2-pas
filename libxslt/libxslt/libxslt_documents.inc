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
     document.h: interface for the document handling
    
     See Copyright for the status of this software.
    
     daniel@veillard.com
    }

  function xsltNewDocument(ctxt:xsltTransformContextPtr; doc:xmlDocPtr):xsltDocumentPtr;cdecl;external LIBXSLT_SO;
  function xsltLoadDocument(ctxt:xsltTransformContextPtr; URI:PxmlChar):xsltDocumentPtr;cdecl;external LIBXSLT_SO;
  function xsltFindDocument(ctxt:xsltTransformContextPtr; doc:xmlDocPtr):xsltDocumentPtr;cdecl;external LIBXSLT_SO;
  procedure xsltFreeDocuments(ctxt:xsltTransformContextPtr);cdecl;external LIBXSLT_SO;
  function xsltLoadStyleDocument(style:xsltStylesheetPtr; URI:PxmlChar):xsltDocumentPtr;cdecl;external LIBXSLT_SO;
  function xsltNewStyleDocument(style:xsltStylesheetPtr; doc:xmlDocPtr):xsltDocumentPtr;cdecl;external LIBXSLT_SO;
  procedure xsltFreeStyleDocuments(style:xsltStylesheetPtr);cdecl;external LIBXSLT_SO;

