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
     extension.h: interface for the extension support
    
     See Copyright for the status of this software.
    
     daniel@veillard.com
    }
  { 
     Extension Modules API
    }
  { 
     xsltStyleExtInitFunction:
     @ctxt:  an XSLT stylesheet
     @URI:  the namespace URI for the extension
    
     A function called at initialization time of an XSLT extension module
    
     Returns a pointer to the module specific data for this transformation
    }
(* Const before type ignored *)

  type

     xsltStyleExtInitFunction = function (style:xsltStylesheetPtr; URI:PxmlChar):pointer;cdecl;
  { 
     xsltStyleExtShutdownFunction:
     @ctxt:  an XSLT stylesheet
     @URI:  the namespace URI for the extension
     @data:  the data associated to this module
    
     A function called at shutdown time of an XSLT extension module
    }

(* error 
						 void *data);
in declaration at line 45 *)
    { 
       xsltExtInitFunction:
       @ctxt:  an XSLT transformation context
       @URI:  the namespace URI for the extension
      
       A function called at initialization time of an XSLT extension module
      
       Returns a pointer to the module specific data for this transformation
      }

       xsltExtInitFunction = function (ctxt:xsltTransformContextPtr; URI:PxmlChar):pointer;cdecl;
    { 
       xsltExtShutdownFunction:
       @ctxt:  an XSLT transformation context
       @URI:  the namespace URI for the extension
       @data:  the data associated to this module
      
       A function called at shutdown time of an XSLT extension module
      }
(* error 
					 void *data);
in declaration at line 69 *)

    type xsltExtShutdownFunction = procedure;      //workaround
    type xsltStyleExtShutdownFunction = procedure; //workaround
    type xsltPreComputeFunction = procedure;       //workaround
    type xsltTopLevelFunction = procedure;         //workaround

    function xsltRegisterExtModule(URI:PxmlChar; initFunc:xsltExtInitFunction; shutdownFunc:xsltExtShutdownFunction):longint;cdecl;external LIBXSLT_SO;

    function xsltRegisterExtModuleFull(URI:PxmlChar; initFunc:xsltExtInitFunction; shutdownFunc:xsltExtShutdownFunction; styleInitFunc:xsltStyleExtInitFunction; styleShutdownFunc:xsltStyleExtShutdownFunction):longint;cdecl;external LIBXSLT_SO;

    function xsltUnregisterExtModule(URI:PxmlChar):longint;cdecl;external LIBXSLT_SO;

    function xsltGetExtData(ctxt:xsltTransformContextPtr; URI:PxmlChar):pointer;cdecl;external LIBXSLT_SO;

    function xsltStyleGetExtData(style:xsltStylesheetPtr; URI:PxmlChar):pointer;cdecl;external LIBXSLT_SO;

    procedure xsltShutdownCtxtExts(ctxt:xsltTransformContextPtr);cdecl;external LIBXSLT_SO;

    procedure xsltShutdownExts(style:xsltStylesheetPtr);cdecl;external LIBXSLT_SO;

    function xsltXPathGetTransformContext(ctxt:xmlXPathParserContextPtr):xsltTransformContextPtr;cdecl;external LIBXSLT_SO;

    {
       extension functions
     }
    function xsltRegisterExtModuleFunction(name:PxmlChar; URI:PxmlChar; function_:xmlXPathFunction):longint;cdecl;external LIBXSLT_SO;

    function xsltExtFunctionLookup(ctxt:xsltTransformContextPtr; name:PxmlChar; URI:PxmlChar):xmlXPathFunction;cdecl;external LIBXSLT_SO;

    function xsltExtModuleFunctionLookup(name:PxmlChar; URI:PxmlChar):xmlXPathFunction;cdecl;external LIBXSLT_SO;

    function xsltUnregisterExtModuleFunction(name:PxmlChar; URI:PxmlChar):longint;cdecl;external LIBXSLT_SO;

    {
       extension elements
      }

    //type
(* error 
					 xsltTransformFunction function);
in declaration at line 119 *)

    function xsltNewElemPreComp(style:xsltStylesheetPtr; inst:xmlNodePtr; function_:xsltTransformFunction):xsltElemPreCompPtr;cdecl;external LIBXSLT_SO;

    procedure xsltInitElemPreComp(comp:xsltElemPreCompPtr; style:xsltStylesheetPtr; inst:xmlNodePtr; function_:xsltTransformFunction; freeFunc:xsltElemPreCompDeallocator);cdecl;external LIBXSLT_SO;

    function xsltRegisterExtModuleElement(name:PxmlChar; URI:PxmlChar; precomp:xsltPreComputeFunction; transform:xsltTransformFunction):longint;cdecl;external LIBXSLT_SO;

    //function xsltExtElementLookup(ctxt:xsltTransformContextPtr; name:PxmlChar; URI:PxmlChar):xsltTransformFunction;cdecl;external LIBXSLT_SO;

    function xsltExtModuleElementLookup(name:PxmlChar; URI:PxmlChar):xsltTransformFunction;cdecl;external LIBXSLT_SO;

    function xsltExtModuleElementPreComputeLookup(name:PxmlChar; URI:PxmlChar):xsltPreComputeFunction;cdecl;external LIBXSLT_SO;

    function xsltUnregisterExtModuleElement(name:PxmlChar; URI:PxmlChar):longint;cdecl;external LIBXSLT_SO;

    {
       top-level elements
      }

    //type
(* error 
					 xmlNodePtr inst);
in declaration at line 154 *)

    function xsltRegisterExtModuleTopLevel(name:PxmlChar; URI:PxmlChar; function_:xsltTopLevelFunction):longint;cdecl;external LIBXSLT_SO;

    function xsltExtModuleTopLevelLookup(name:PxmlChar; URI:PxmlChar):xsltTopLevelFunction;cdecl;external LIBXSLT_SO;

    function xsltUnregisterExtModuleTopLevel(name:PxmlChar; URI:PxmlChar):longint;cdecl;external LIBXSLT_SO;

    { These 2 functions are deprecated for use within modules  }
    function xsltRegisterExtFunction(ctxt:xsltTransformContextPtr; name:PxmlChar; URI:PxmlChar; function_:xmlXPathFunction):longint;cdecl;external LIBXSLT_SO;

    function xsltRegisterExtElement(ctxt:xsltTransformContextPtr; name:PxmlChar; URI:PxmlChar; function_:xsltTransformFunction):longint;cdecl;external LIBXSLT_SO;

    { 
       Extension Prefix handling API
       Those are used by the XSLT (pre)processor.
      }
    function xsltRegisterExtPrefix(style:xsltStylesheetPtr; prefix:PxmlChar; URI:PxmlChar):longint;cdecl;external LIBXSLT_SO;

    function xsltCheckExtPrefix(style:xsltStylesheetPtr; prefix:PxmlChar):longint;cdecl;external LIBXSLT_SO;

    function xsltInitCtxtExts(ctxt:xsltTransformContextPtr):longint;cdecl;external LIBXSLT_SO;

    procedure xsltFreeCtxtExts(ctxt:xsltTransformContextPtr);cdecl;external LIBXSLT_SO;

    procedure xsltFreeExts(style:xsltStylesheetPtr);cdecl;external LIBXSLT_SO;

    function xsltPreComputeExtModuleElement(style:xsltStylesheetPtr; inst:xmlNodePtr):xsltElemPreCompPtr;cdecl;external LIBXSLT_SO;

    { 
       Test module http://xmlsoft.org/XSLT/
      }
    procedure xsltRegisterTestModule;cdecl;external LIBXSLT_SO;


