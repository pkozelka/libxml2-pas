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
     preproc.h: precomputing data interfaces
    
     See Copyright for the status of this software.
    
     daniel@veillard.com
    }

  {
     Interfaces
    }
	 // var
			 //xsltExtMarker : PxmlChar;cvar;external LIBXSLT_SO 'xsltExtMarker';
function  xsltDocumentComp(style:xsltStylesheetPtr; inst:xmlNodePtr; transformfunction:xsltTransformFunction):xsltElemPreCompPtr;cdecl;external LIBXSLT_SO;
procedure xsltStylePreCompute(style:xsltStylesheetPtr; inst:xmlNodePtr);cdecl;external LIBXSLT_SO;
procedure xsltFreeStylePreComps(style:xsltStylesheetPtr);cdecl;external LIBXSLT_SO;

