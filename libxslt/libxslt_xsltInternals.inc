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
     xsltInternals.h: internal data structures, constants and functions used
                      by the XSLT engine
                      They are not part of the API or ABI, i.e. they can change
                      without prior notice, use carefully.

		 See Copyright for the status of this software.

     daniel@veillard.com
    }


{
     XSLT_MAX_SORT:

     Max number of specified xsl:sort on an element
    }

  const
     XSLT_MAX_SORT = 5;
	{
     XSLT_PAT_NO_PRIORITY:

     specific value for pattern without priority expressed
    }
     XSLT_PAT_NO_PRIORITY = -(12345789);
  {
     xsltTemplate:

     The in-memory structure corresponding to an XSLT Template
    }

  type
     //_xsltTemplate = xsltTemplate;
     xsltStylesheetPtr=^xsltStylesheet;
     xsltTemplatePtr = ^xsltTemplate;
  { chained list sorted by priority  }
  { the containing stylesheet  }
  { the matching string  }
  { as given from the stylesheet, not computed  }
  { the local part of the name QName  }
  { the URI part of the name QName  }
  { the local part of the mode QName  }
  { the URI part of the mode QName  }
  { the template replacement value  }
  { the source element  }
  { number of inherited namespaces  }
  { inherited non-excluded namespaces  }
  { Profiling informations  }
  { the number of time the template was called  }
  { the time spent in this template  }
     xsltTemplate = record
					next : xsltTemplatePtr;
          style : xsltStylesheetPtr;
          match : PxmlChar;
          priority : double;
          name : PxmlChar;
          nameURI : PxmlChar;
          mode : PxmlChar;
          modeURI : PxmlChar;
          content : xmlNodePtr;
          elem : xmlNodePtr;
          inheritedNsNr : longint;
          inheritedNs : PxmlNsPtr;
          nbCalls : longint;
          time : dword;
       end;

  { 
     xsltDecimalFormat:
    
     Data structure of decimal-format
    }
     //_xsltDecimalFormat = xsltDecimalFormat;

     //xsltDecimalFormatPtr = PxsltDecimalFormat;
     xsltDecimalFormatPtr = ^xsltDecimalFormat;
  { chained list  }
  { Used for interpretation of pattern  }
  { May appear in result  }
  { Not-a-number  }
  { Used for interpretation of pattern and may appear in result  }
     xsltDecimalFormat = record
          next : xsltDecimalFormatPtr;
					name : PxmlChar;
          digit : PxmlChar;
          patternSeparator : PxmlChar;
          minusSign : PxmlChar;
          infinity : PxmlChar;
          noNumber : PxmlChar;
          decimalPoint : PxmlChar;
          grouping : PxmlChar;
          percent : PxmlChar;
          permille : PxmlChar;
          zeroDigit : PxmlChar;
       end;

  { 
     xsltDocument:
    
     Data structure associated to a parsed document
    }
     //_xsltDocument = xsltDocument;

     //xsltDocumentPtr = PxsltDocument;
     xsltDocumentPtr = ^xsltDocument;
  { documents are kept in a chained list  }
  { is this the main document  }
  { the parsed document  }
  { key tables storage  }
     xsltDocument = record
          next : xsltDocumentPtr;
          main : longint;
          doc : xmlDocPtr;
          keys : pointer;
       end;

     xsltTransformContextPtr = ^xsltTransformContext;
  {
     xsltElemPreComp:

     The in-memory structure corresponding to element precomputed data,
     designed to be extended by extension implementors.
    }
  {
     xsltTransformFunction:
     @ctxt: the XSLT transformation context
     @node: the input node
     @inst: the stylesheet node
     @comp: the compiled information from the stylesheet

     signature of the function associated to elements part of the
     stylesheet language like xsl:if or xsl:apply-templates.
    }
(* error
			               xsltElemPreCompPtr comp);
in declaration at line 131 *)

       xsltStyleType = (XSLT_FUNC_COPY = 1,XSLT_FUNC_SORT,
         XSLT_FUNC_TEXT,XSLT_FUNC_ELEMENT,XSLT_FUNC_ATTRIBUTE,
         XSLT_FUNC_COMMENT,XSLT_FUNC_PI,XSLT_FUNC_COPYOF,
         XSLT_FUNC_VALUEOF,XSLT_FUNC_NUMBER,
         XSLT_FUNC_APPLYIMPORTS,XSLT_FUNC_CALLTEMPLATE,
         XSLT_FUNC_APPLYTEMPLATES,XSLT_FUNC_CHOOSE,
         XSLT_FUNC_IF,XSLT_FUNC_FOREACH,XSLT_FUNC_DOCUMENT,
         XSLT_FUNC_WITHPARAM,XSLT_FUNC_PARAM,
         XSLT_FUNC_VARIABLE,XSLT_FUNC_WHEN,
         XSLT_FUNC_EXTENSION);
		{
       xsltElemPreCompDeallocator:
       @comp:  the #xsltElemPreComp to free up

       Deallocates an #xsltElemPreComp structure
      }
(* error 
typedef void (*xsltElemPreCompDeallocator) (xsltElemPreCompPtr comp);
in declaration at line 164 *)
    { 
       xsltElemPreComp:
      
       The in-memory structure corresponding to element precomputed data,
       designed to be extended by extension implementors.
      }
    { chained list  }
    { type of the element  }
    { handling function  }
    { the instruction  }
    { end of common part  }
    { the deallocator  }

    {todo1: add parameters}
    xsltElemPreCompDeallocator = procedure;
    xsltTransformFunction = procedure;

    xsltElemPreCompPtr=^xsltElemPreComp; //by FE

       xsltElemPreComp = record
            next : xsltElemPreCompPtr;
            type_ : xsltStyleType;
            func : xsltTransformFunction;
						inst : xmlNodePtr;
            free : xsltElemPreCompDeallocator;
         end;

    { 
       xsltStylePreComp:
      
       The in-memory structure corresponding to XSLT stylesheet constructs
       precomputed data.
      }
       xsltStylePreCompPtr = ^xsltStylePreComp;
    { chained list  }
    { type of the element  }
    { handling function  }
    { the instruction  }
    {
           Pre computed values
          }
    { sort  }
    { sort  }
    { sort  }
    { sort  }
    { sort  }
    { sort  }
    { copy, element  }
    { copy, element  }
    { text  }
    { element, attribute, pi  }
    { element, attribute, pi  }
    { element  }
    { element  }
    { apply-templates  }
		{ apply-templates  }
    { if  }
    { call-template  }
    { sort, copy-of, value-of, apply-templates  }
    { document  }
    { document URL  }
    { document  }
    { number  }
    { a precompiled XPath expression  }
    { the namespaces in scope  }
    { the number of namespaces in scope  }
       xsltStylePreComp = record
            next : xsltElemPreCompPtr;
            type_ : xsltStyleType;
            func : xsltTransformFunction;
            inst : xmlNodePtr;
            stype : PxmlChar;
            has_stype : longint;
            number : longint;
            order : PxmlChar;
            has_order : longint;
            descending : longint;
            use : PxmlChar;
            has_use : longint;
            noescape : longint;
            name : PxmlChar;
            has_name : longint;
            ns : PxmlChar;
            has_ns : longint;
            mode : PxmlChar;
            modeURI : PxmlChar;
            test : PxmlChar;
						templ : xsltTemplatePtr;
            select : PxmlChar;
            ver11 : longint;
            filename : PxmlChar;
            has_filename : longint;
            numdata : xsltNumberData;
            comp : xmlXPathCompExprPtr;
            nsList : PxmlNsPtr;
            nsNr : longint;
         end;

    {
       The in-memory structure corresponding to an XSLT Variable
       or Param
      }
       xsltStackElemPtr = ^xsltStackElem;
    { chained list  }
    { the compiled form  }
    { was the evaluation done  }
    { the local part of the name QName  }
    { the URI part of the name QName  }
    { the eval string  }
    { the tree if no eval string or the location  }
    { The value if computed  }
       xsltStackElem = record
            next : xsltStackElemPtr;
            comp : xsltStylePreCompPtr;
            computed : longint;
            name : PxmlChar;
            nameURI : PxmlChar;
            select : PxmlChar;
            tree : xmlNodePtr;
						value : xmlXPathObjectPtr;
         end;

    {
       The in-memory structure corresponding to an XSLT Stylesheet
       NOTE: most of the content is simply linked from the doc tree
             structure, no specific allocation is made.
      }


       //xsltStylesheetPtr = PxsltStylesheet;

    {
           The stylesheet import relation is kept as a tree
          }
    { the include document list  }
    {
           General data on the style sheet document
          }
    { the parsed XML stylesheet  }
    { the hash table of the strip-space and
    				   preserve space elements  }
    { strip-space   (1) preserve-space   (-1)  }
    { the hash table of the cdata-section  }
    {
           Global variable or parameters
          }
    { linked list of param and variables  }
    {
           Template descriptions
          }
    { the ordered list of templates  }
		{ hash table or wherever compiled templates
    				   informations are stored  }
    { template based on /  }
    { template based on key()  }
    { template based on    }
    { template based on @   }
    { template based on ..  }
    { template based on text()  }
    { template based on processing-instruction()  }
    { template based on comment()  }
    {
           Namespace aliases
          }
    { the namespace alias hash tables  }
    {
           Attribute sets
          }
    { the attribute sets hash tables  }
    {
           Namespaces
          }
    { the set of namespaces in use  }
    { the namespaces defined  }
    {
           Key definitions
          }
    { key definitions  }
    {
           Output related stuff.
          }
    { the output method  }
    { associated namespace if any  }
		{ version string  }
    { encoding string  }
    { omit-xml-declaration = "yes" | "no"  }
    { Number formatting  }
    { standalone = "yes" | "no"  }
    { doctype-public string  }
    { doctype-system string  }
    { should output being indented  }
    { media-type string  }
    {
           Precomputed blocks
          }
    { list of precomputed blocks  }
    { number of warnings found at compilation  }
    { number of errors found at compilation  }
    { last excluded prefixes  }
    { array of excluded prefixes  }
    { number of excluded prefixes in scope  }
    { size of the array  }
    { user defined data  }
    {
           Extensions
          }
    { the extension data  }
       xsltStylesheet = record
            parent : xsltStylesheetPtr;
            next : xsltStylesheetPtr;
            imports : xsltStylesheetPtr;
            docList : xsltDocumentPtr;
            doc : xmlDocPtr;
            stripSpaces : xmlHashTablePtr;
            stripAll : longint;
						cdataSection : xmlHashTablePtr;
            variables : xsltStackElemPtr;
            templates : xsltTemplatePtr;
            templatesHash : pointer;
            rootMatch : pointer;
            keyMatch : pointer;
            elemMatch : pointer;
            attrMatch : pointer;
            parentMatch : pointer;
            textMatch : pointer;
            piMatch : pointer;
            commentMatch : pointer;
            nsAliases : xmlHashTablePtr;
            attributeSets : xmlHashTablePtr;
            nsHash : xmlHashTablePtr;
            nsDefs : pointer;
            keys : pointer;
            method : PxmlChar;
            methodURI : PxmlChar;
            version : PxmlChar;
            encoding : PxmlChar;
            omitXmlDeclaration : longint;
            decimalFormat : xsltDecimalFormatPtr;
            standalone : longint;
            doctypePublic : PxmlChar;
            doctypeSystem : PxmlChar;
            indent : longint;
            mediaType : PxmlChar;
            preComps : xsltElemPreCompPtr;
            warnings : longint;
            errors : longint;
            exclPrefix : PxmlChar;
						exclPrefixTab : PPxmlChar;
            exclPrefixNr : longint;
            exclPrefixMax : longint;
            _private : pointer;
            extInfos : xmlHashTablePtr;
         end;

    {
       The in-memory structure corresponding to an XSLT Transformation
      }

       xsltOutputType = (XSLT_OUTPUT_XML = 0,XSLT_OUTPUT_HTML,
         XSLT_OUTPUT_TEXT);

       xsltTransformState = (XSLT_STATE_OK = 0,XSLT_STATE_ERROR,
         XSLT_STATE_STOPPED);
    { the stylesheet used  }
    { the type of output  }
    { the current template  }
    { Nb of templates in the stack  }
    { Size of the templtes stack  }
    { the template stack  }
    { the current variable list  }
    { Nb of variable list in the stack  }
    { Size of the variable list stack  }
    { the variable list stack  }
    { the var base for current templ  }
    {
           Extensions
          }
    { the extension functions  }
    { the extension elements  }
		{ the extension data  }
    { the current mode  }
    { the current mode URI  }
    { the document list  }
    { the current document  }
    { the current node being processed  }
    { the current node list  }
    { xmlNodePtr current;			the node  }
    { the resulting document  }
    { the insertion node  }
    { the XPath context  }
    { the current state  }
    {
           Global variables
          }
    { the global variables and params  }
    { the instruction in the stylesheet  }
    { should XInclude be processed  }
    { the output URI if known  }
    { is this run profiled  }
    { the current profiled value  }
    { Nb of templates in the stack  }
    { Size of the templtaes stack  }
    { the profile template stack  }
    { user defined data  }
       xsltTransformContext = record
            style : xsltStylesheetPtr;
            type_ : xsltOutputType;
            templ : xsltTemplatePtr;
            templNr : longint;
            templMax : longint;
            templTab : xsltTemplatePtr;
						vars : xsltStackElemPtr;
            varsNr : longint;
            varsMax : longint;
            varsTab : xsltStackElemPtr;
            varsBase : longint;
            extFunctions : xmlHashTablePtr;
            extElements : xmlHashTablePtr;
            extInfos : xmlHashTablePtr;
            mode : PxmlChar;
            modeURI : PxmlChar;
            docList : xsltDocumentPtr;
            document : xsltDocumentPtr;
            node : xmlNodePtr;
            nodeList : xmlNodeSetPtr;
            output : xmlDocPtr;
            insert : xmlNodePtr;
            xpathCtxt : xmlXPathContextPtr;
            state : xsltTransformState;
            globalVars : xmlHashTablePtr;
            inst : xmlNodePtr;
            xinclude : longint;
            outputFile : Pchar;
            profile : longint;
            prof : longint;
            profNr : longint;
            profMax : longint;
            profTab : Plongint;
            _private : pointer;
         end;

    {
       CHECK_STOPPED:

       Macro to check if the XSLT processing should be stopped
       will return from the function
      }
(* error
#define CHECK_STOPPED if (ctxt->state == XSLT_STATE_STOPPED) return;
in declaration at line 438 *)
    {
       CHECK_STOPPEDE:

       Macro to check if the XSLT processing should be stopped
       will goto the error: label
      }
(* error
#define CHECK_STOPPEDE if (ctxt->state == XSLT_STATE_STOPPED) goto error;
in declaration at line 446 *)
    {
       CHECK_STOPPED0:

       Macro to check if the XSLT processing should be stopped
       will return from the function with a 0 value
      }
(* error
#define CHECK_STOPPED0 if (ctxt->state == XSLT_STATE_STOPPED) return(0);
in declaration at line 454 *)
    {
       Functions associated to the internal types
    xsltDecimalFormatPtr	xsltDecimalFormatGetByName(xsltStylesheetPtr sheet,
    						   xmlChar  name);
      }

function  xsltNewStylesheet:xsltStylesheetPtr;cdecl;external LIBXSLT_SO;
function  xsltParseStylesheetFile(filename:PxmlChar):xsltStylesheetPtr;cdecl;external LIBXSLT_SO;
procedure xsltFreeStylesheet(sheet:xsltStylesheetPtr);cdecl;external LIBXSLT_SO;
function  xsltIsBlank(str:PxmlChar):longint;cdecl;external LIBXSLT_SO;
procedure xsltFreeStackElemList(elem:xsltStackElemPtr);cdecl;external LIBXSLT_SO;
function  xsltDecimalFormatGetByName(sheet:xsltStylesheetPtr; name:PxmlChar):xsltDecimalFormatPtr;cdecl;external LIBXSLT_SO;
function  xsltParseStylesheetProcess(ret:xsltStylesheetPtr; doc:xmlDocPtr):xsltStylesheetPtr;cdecl;external LIBXSLT_SO;
procedure xsltParseStylesheetOutput(style:xsltStylesheetPtr; cur:xmlNodePtr);cdecl;external LIBXSLT_SO;
function  xsltParseStylesheetDoc(doc:xmlDocPtr):xsltStylesheetPtr;cdecl;external LIBXSLT_SO;
function  xsltLoadStylesheetPI(doc:xmlDocPtr):xsltStylesheetPtr;cdecl;external LIBXSLT_SO;
procedure xsltNumberFormat(ctxt:xsltTransformContextPtr; data:xsltNumberDataPtr; node:xmlNodePtr);cdecl;external LIBXSLT_SO;
function  xsltFormatNumberConversion(self:xsltDecimalFormatPtr; format:PxmlChar; number:double; result:PPxmlChar):TxmlXPathError;cdecl;external LIBXSLT_SO;
procedure xsltParseTemplateContent(style:xsltStylesheetPtr; templ:xmlNodePtr);cdecl;external LIBXSLT_SO;

