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
     pattern.h: interface for the pattern matching used in template matches.
    
     See Copyright for the status of this software.
    
     daniel@veillard.com
    }

  { 
     xsltCompMatch:
    
     Data structure used for the implementation of patterns.
     It is kept private (in pattern.c)
    }

  type
     //_xsltCompMatch = xsltCompMatch;
     xsltCompMatch = pointer; //workaround, probably ok
     xsltCompMatchPtr = ^xsltCompMatch;
  {
     Pattern related interfaces
		}
function  xsltCompilePattern(pattern:PxmlChar; doc:xmlDocPtr; node:xmlNodePtr):xsltCompMatchPtr;cdecl;external LIBXSLT_SO;
procedure xsltFreeCompMatchList(comp:xsltCompMatchPtr);cdecl;external LIBXSLT_SO;
function  xsltTestCompMatchList(ctxt:xsltTransformContextPtr; node:xmlNodePtr; comp:xsltCompMatchPtr):longint;cdecl;external LIBXSLT_SO;

{
	Template related interfaces
}
function  xsltAddTemplate(style:xsltStylesheetPtr; cur:xsltTemplatePtr; mode:PxmlChar; modeURI:PxmlChar):longint;cdecl;external LIBXSLT_SO;
function  xsltGetTemplate(ctxt:xsltTransformContextPtr; node:xmlNodePtr; style:xsltStylesheetPtr):xsltTemplatePtr;cdecl;external LIBXSLT_SO;
procedure xsltFreeTemplateHashes(style:xsltStylesheetPtr);cdecl;external LIBXSLT_SO;
procedure xsltCleanupTemplates(style:xsltStylesheetPtr);cdecl;external LIBXSLT_SO;

{$if false}
function  xsltMatchPattern(ctxt:xsltTransformContextPtr; node:xmlNodePtr; pattern:PxmlChar):longint;cdecl;external LIBXSLT_SO;
{$ifend}

