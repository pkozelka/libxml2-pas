{$PACKRECORDS C}

{
   xpathInternals.c: internal interfaces for XML Path Language implementation
                     used to build new modules on top of XPath
  
   See COPYRIGHT for the status of this software
  
   Author: daniel@veillard.com
  }
{$ifndef __XML_XPATH_INTERNALS_H__}
{$define __XML_XPATH_INTERNALS_H__}
{$if defined(WIN32) && defined(_MSC_VER)}
{$include <libxml/xmlwin32version.h>}
{$else}
{$include <libxml/xmlversion.h>}
{$endif}
{$include <libxml/xpath.h>}
{ C++ extern C conditionnal removed }
{                                                                       
  									 
  			Helpers						 
  									 
                                                                         }
{ 
   Many of these macros may later turn into functions. They
   shouldn't be used in #ifdef's preprocessor instructions.
  }
{ 
   xmlXPathSetError:
   @ctxt:  an XPath parser context
   @err:  an xmlXPathError code
  
   Raises an error.
  }
(* error 
#define xmlXPathSetError(ctxt, err)					\
in define line 41 *)
(* error 
    { xmlXPatherror((ctxt), __FILE__, __LINE__, (err));			\
in declaration at line 42 *)
(* error 
    { xmlXPatherror((ctxt), __FILE__, __LINE__, (err));			\
(* error 
      (ctxt)->error = (err); }
in declaration at line 43 *)
(* error 
      (ctxt)->error = (err); }
    { 
       xmlXPathSetArityError:
       @ctxt:  an XPath parser context
      
       Raises an XPATH_INVALID_ARITY error
      }
in define line 51 *)
(* error 
    xmlXPathSetError((ctxt), XPATH_INVALID_ARITY)
(* error 
    xmlXPathSetError((ctxt), XPATH_INVALID_ARITY)
    { 
       xmlXPathSetTypeError:
       @ctxt:  an XPath parser context
      
       Raises an XPATH_INVALID_TYPE error
      }
(* error 
    xmlXPathSetError((ctxt), XPATH_INVALID_TYPE)
    { 
       xmlXPathGetError:
       @ctxt:  an XPath parser context
      
       Get the error code of an XPath context
      
       Returns the context error
      }
    { 
       xmlXPathCheckError:
       @ctxt:  an XPath parser context
      
       Check if an XPath error was raised
      
       Returns true if an error has been raised, false otherwise.
      }
    { 
       xmlXPathGetDocument:
       @ctxt:  an XPath parser context
      
       Get the document of an XPath context
      
       Returns the context document
      }
    { 
       xmlXPathGetContextNode:
       @ctxt: an XPath parser context
      
       Get the context node of an XPath context
      
       Returns the context node
      }
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)

function xmlXPathPopNumber(ctxt:xmlXPathParserContextPtr):double;cdecl;external;
function xmlXPathPopString(ctxt:xmlXPathParserContextPtr):^xmlChar;cdecl;external;
function xmlXPathPopNodeSet(ctxt:xmlXPathParserContextPtr):xmlNodeSetPtr;cdecl;external;
function xmlXPathPopExternal(ctxt:xmlXPathParserContextPtr):pointer;cdecl;external;
    { 
       xmlXPathReturnBoolean:
       @ctxt:  an XPath parser context
       @val:  a boolean
      
       Pushes the boolean @val on the context stack
      }
(* error 
#define xmlXPathReturnBoolean(ctxt, val)				\
in define line 116 *)
(* error 
    valuePush((ctxt), xmlXPathNewBoolean(val))
(* error 
    valuePush((ctxt), xmlXPathNewBoolean(val))
    { 
       xmlXPathReturnTrue:
       @ctxt:  an XPath parser context
      
       Pushes true on the context stack
      }
(* error 
#define xmlXPathReturnTrue(ctxt)   xmlXPathReturnBoolean((ctxt), 1)
    { 
       xmlXPathReturnFalse:
       @ctxt:  an XPath parser context
      
       Pushes false on the context stack
      }
(* error 
#define xmlXPathReturnFalse(ctxt)  xmlXPathReturnBoolean((ctxt), 0)
    { 
       xmlXPathReturnNumber:
       @ctxt:  an XPath parser context
       @val:  a double
      
       Pushes the double @val on the context stack
      }
(* error 
#define xmlXPathReturnNumber(ctxt, val)					\
(* error 
    valuePush((ctxt), xmlXPathNewFloat(val))
    { 
       xmlXPathReturnString:
       @ctxt:  an XPath parser context
       @str:  a string
      
       Pushes the string @str on the context stack
      }
(* error 
#define xmlXPathReturnString(ctxt, str)					\
(* error 
    valuePush((ctxt), xmlXPathWrapString(str))
    { 
       xmlXPathReturnEmptyString:
       @ctxt:  an XPath parser context
      
       Pushes an empty string on the stack
      }
(* error 
    valuePush((ctxt), xmlXPathNewCString(""))
    { 
       xmlXPathReturnNodeSet:
       @ctxt:  an XPath parser context
       @ns:  a node-set
      
       Pushes the node-set @ns on the context stack
      }
(* error 
#define xmlXPathReturnNodeSet(ctxt, ns)					\
(* error 
    valuePush((ctxt), xmlXPathWrapNodeSet(ns))
    { 
       xmlXPathReturnEmptyNodeSet:
       @ctxt:  an XPath parser context
      
       Pushes an empty node-set on the context stack
      }
(* error 
    valuePush((ctxt), xmlXPathNewNodeSet(NULL))
    { 
       xmlXPathReturnExternal:
       @ctxt:  an XPath parser context
       @val:  user data
      
       Pushes user data on the context stack
      }
(* error 
#define xmlXPathReturnExternal(ctxt, val)				\
(* error 
    valuePush((ctxt), xmlXPathWrapExternal(val))
    { 
       xmlXPathStackIsNodeSet:
       @ctxt: an XPath parser context
      
       Check if the current value on the XPath stack is a node set or
       an XSLT value tree
      
       Returns true if the current object on the stack is a node-set
      }
    { 
       xmlXPathStackIsExternal:
       @ctxt: an XPath parser context
      
       Checks if the current value on the XPath stack is an external
       object.
      
       Returns true if the current object on the stack is an external
       object
      }
    { 
       xmlXPathEmptyNodeSet:
       @ns:  a node-set
      
       Empties a node-set
      }
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
      var
 : valuePush;
(* error 
    { while ((ns)->nodeNr > 0) (ns)->nodeTab[(ns)->nodeNr--] = NULL; }
    { 
       CHECK_ERROR:
      
       macro to return from the function if an XPath error was detected
      }
in define line 234 *)
(* error 
    if (ctxt->error != XPATH_EXPRESSION_OK) return
    { 
       CHECK_ERROR0:
      
       macro to return 0 from the function if an XPath error was detected
      }
    { 
       XP_ERROR:
       @X:  the error code
      
       Macro to raise an XPath error and return
      }
 in declarator_list *)
(* error 
    { xmlXPatherror(ctxt, __FILE__, __LINE__, X);			\
 in declarator_list *)
(* error 
    { xmlXPatherror(ctxt, __FILE__, __LINE__, X);			\
(* error 
      ctxt->error = (X); return; }
in declaration at line 253 *)
(* error 
      ctxt->error = (X); return; }
in declaration at line 253 *)
(* error 
      ctxt->error = (X); return; }
    { 
       XP_ERROR0:
       @X:  the error code
      
       Macro to raise an XPath error and return 0
      }
in define line 261 *)
(* error 
    { xmlXPatherror(ctxt, __FILE__, __LINE__, X);			\
in declaration at line 262 *)
(* error 
    { xmlXPatherror(ctxt, __FILE__, __LINE__, X);			\
(* error 
      ctxt->error = (X); return(0); }
in declaration at line 263 *)
(* error 
      ctxt->error = (X); return(0); }
 in declarator_list *)
(* error 
      ctxt->error = (X); return(0); }
    { 
       CHECK_TYPE:
       @typeval:  the XPath type
      
       Macro to check that the value on top of the XPath stack is of a given
       type.
      }
in define line 272 *)
(* error 
    if ((ctxt->value == NULL) || (ctxt->value->type != typeval))	\
    { 
       CHECK_TYPE0:
       @typeval:  the XPath type
      
       Macro to check that the value on top of the XPath stack is of a given
       type. return(0) in case of failure
      }
    { 
       CHECK_ARITY:
       @x:  the number of expected args
      
       Macro to check that the number of args passed to an XPath function matches
      }
 in declarator_list *)
    { 
       CAST_TO_STRING:
      
       Macro to try to cast the value on the top of the XPath stack to a string
      }
(* error 
#define CAST_TO_STRING							\
in define line 302 *)
(* error 
    if ((ctxt->value != NULL) && (ctxt->value->type != XPATH_STRING))	\
(* error 
        xmlXPathStringFunction(ctxt, 1);
 in declarator_list *)
 in declarator_list *)
    { 
       CAST_TO_NUMBER:
      
       Macro to try to cast the value on the top of the XPath stack to a number
      }
(* error 
#define CAST_TO_NUMBER							\
in define line 311 *)
(* error 
    if ((ctxt->value != NULL) && (ctxt->value->type != XPATH_NUMBER))	\
(* error 
        xmlXPathNumberFunction(ctxt, 1);
 in declarator_list *)
 in declarator_list *)
    { 
       CAST_TO_BOOLEAN:
      
       Macro to try to cast the value on the top of the XPath stack to a boolean
      }
(* error 
#define CAST_TO_BOOLEAN							\
in define line 320 *)
(* error 
    if ((ctxt->value != NULL) && (ctxt->value->type != XPATH_BOOLEAN))	\
(* error 
        xmlXPathBooleanFunction(ctxt, 1);
 in declarator_list *)
 in declarator_list *)
    {
       Variable Lookup forwarding
      }
(* Const before type ignored *)
(* Const before type ignored *)
    type

       xmlXPathVariableLookupFunc = function (ctxt:pointer; name:PxmlChar; ns_uri:PxmlChar):xmlXPathObjectPtr;cdecl;

procedure xmlXPathRegisterVariableLookup(ctxt:xmlXPathContextPtr; f:xmlXPathVariableLookupFunc; data:pointer);cdecl;external;
    {
       Function Lookup forwarding
      }
(* Const before type ignored *)
(* Const before type ignored *)
    type

       xmlXPathFuncLookupFunc = function (ctxt:pointer; name:PxmlChar; ns_uri:PxmlChar):xmlXPathFunction;cdecl;

procedure xmlXPathRegisterFuncLookup(ctxt:xmlXPathContextPtr; f:xmlXPathFuncLookupFunc; funcCtxt:pointer);cdecl;external;
    {
       Error reporting
      }
(* Const before type ignored *)
procedure xmlXPatherror(ctxt:xmlXPathParserContextPtr; file:Pchar; line:longint; no:longint);cdecl;external;
procedure xmlXPathDebugDumpObject(output:PFILE; cur:xmlXPathObjectPtr; depth:longint);cdecl;external;
procedure xmlXPathDebugDumpCompExpr(output:PFILE; comp:xmlXPathCompExprPtr; depth:longint);cdecl;external;
    { 
       NodeSet handling
      }
function xmlXPathNodeSetContains(cur:xmlNodeSetPtr; val:xmlNodePtr):longint;cdecl;external;
function xmlXPathDifference(nodes1:xmlNodeSetPtr; nodes2:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external;
function xmlXPathIntersection(nodes1:xmlNodeSetPtr; nodes2:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external;
function xmlXPathDistinctSorted(nodes:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external;
function xmlXPathDistinct(nodes:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external;
function xmlXPathHasSameNodes(nodes1:xmlNodeSetPtr; nodes2:xmlNodeSetPtr):longint;cdecl;external;
function xmlXPathNodeLeadingSorted(nodes:xmlNodeSetPtr; node:xmlNodePtr):xmlNodeSetPtr;cdecl;external;
function xmlXPathLeadingSorted(nodes1:xmlNodeSetPtr; nodes2:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external;
function xmlXPathNodeLeading(nodes:xmlNodeSetPtr; node:xmlNodePtr):xmlNodeSetPtr;cdecl;external;
function xmlXPathLeading(nodes1:xmlNodeSetPtr; nodes2:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external;
function xmlXPathNodeTrailingSorted(nodes:xmlNodeSetPtr; node:xmlNodePtr):xmlNodeSetPtr;cdecl;external;
function xmlXPathTrailingSorted(nodes1:xmlNodeSetPtr; nodes2:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external;
function xmlXPathNodeTrailing(nodes:xmlNodeSetPtr; node:xmlNodePtr):xmlNodeSetPtr;cdecl;external;
function xmlXPathTrailing(nodes1:xmlNodeSetPtr; nodes2:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external;
    { 
       Extending a context
      }
(* Const before type ignored *)
(* Const before type ignored *)
function xmlXPathRegisterNs(ctxt:xmlXPathContextPtr; prefix:PxmlChar; ns_uri:PxmlChar):longint;cdecl;external;
(* Const before type ignored *)
(* Const before type ignored *)
function xmlXPathNsLookup(ctxt:xmlXPathContextPtr; prefix:PxmlChar):^xmlChar;cdecl;external;
procedure xmlXPathRegisteredNsCleanup(ctxt:xmlXPathContextPtr);cdecl;external;
(* Const before type ignored *)
function xmlXPathRegisterFunc(ctxt:xmlXPathContextPtr; name:PxmlChar; f:xmlXPathFunction):longint;cdecl;external;
(* Const before type ignored *)
(* Const before type ignored *)
function xmlXPathRegisterFuncNS(ctxt:xmlXPathContextPtr; name:PxmlChar; ns_uri:PxmlChar; f:xmlXPathFunction):longint;cdecl;external;
(* Const before type ignored *)
function xmlXPathRegisterVariable(ctxt:xmlXPathContextPtr; name:PxmlChar; value:xmlXPathObjectPtr):longint;cdecl;external;
(* Const before type ignored *)
(* Const before type ignored *)
function xmlXPathRegisterVariableNS(ctxt:xmlXPathContextPtr; name:PxmlChar; ns_uri:PxmlChar; value:xmlXPathObjectPtr):longint;cdecl;external;
(* Const before type ignored *)
function xmlXPathFunctionLookup(ctxt:xmlXPathContextPtr; name:PxmlChar):xmlXPathFunction;cdecl;external;
(* Const before type ignored *)
(* Const before type ignored *)
function xmlXPathFunctionLookupNS(ctxt:xmlXPathContextPtr; name:PxmlChar; ns_uri:PxmlChar):xmlXPathFunction;cdecl;external;
procedure xmlXPathRegisteredFuncsCleanup(ctxt:xmlXPathContextPtr);cdecl;external;
(* Const before type ignored *)
function xmlXPathVariableLookup(ctxt:xmlXPathContextPtr; name:PxmlChar):xmlXPathObjectPtr;cdecl;external;
(* Const before type ignored *)
(* Const before type ignored *)
function xmlXPathVariableLookupNS(ctxt:xmlXPathContextPtr; name:PxmlChar; ns_uri:PxmlChar):xmlXPathObjectPtr;cdecl;external;
procedure xmlXPathRegisteredVariablesCleanup(ctxt:xmlXPathContextPtr);cdecl;external;
    { 
       Utilities to extend XPath
      }
(* Const before type ignored *)
function xmlXPathNewParserContext(str:PxmlChar; ctxt:xmlXPathContextPtr):xmlXPathParserContextPtr;cdecl;external;
procedure xmlXPathFreeParserContext(ctxt:xmlXPathParserContextPtr);cdecl;external;
    { TODO: remap to xmlXPathValuePop and Push  }
function valuePop(ctxt:xmlXPathParserContextPtr):xmlXPathObjectPtr;cdecl;external;
function valuePush(ctxt:xmlXPathParserContextPtr; value:xmlXPathObjectPtr):longint;cdecl;external;
(* Const before type ignored *)
function xmlXPathNewString(val:PxmlChar):xmlXPathObjectPtr;cdecl;external;
(* Const before type ignored *)
function xmlXPathNewCString(val:Pchar):xmlXPathObjectPtr;cdecl;external;
function xmlXPathWrapString(val:PxmlChar):xmlXPathObjectPtr;cdecl;external;
function xmlXPathWrapCString(val:Pchar):xmlXPathObjectPtr;cdecl;external;
function xmlXPathNewFloat(val:double):xmlXPathObjectPtr;cdecl;external;
function xmlXPathNewBoolean(val:longint):xmlXPathObjectPtr;cdecl;external;
function xmlXPathNewNodeSet(val:xmlNodePtr):xmlXPathObjectPtr;cdecl;external;
function xmlXPathNewValueTree(val:xmlNodePtr):xmlXPathObjectPtr;cdecl;external;
procedure xmlXPathNodeSetAdd(cur:xmlNodeSetPtr; val:xmlNodePtr);cdecl;external;
procedure xmlXPathNodeSetAddUnique(cur:xmlNodeSetPtr; val:xmlNodePtr);cdecl;external;
procedure xmlXPathNodeSetSort(set:xmlNodeSetPtr);cdecl;external;
procedure xmlXPathIdFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathRoot(ctxt:xmlXPathParserContextPtr);cdecl;external;
procedure xmlXPathEvalExpr(ctxt:xmlXPathParserContextPtr);cdecl;external;
function xmlXPathParseName(ctxt:xmlXPathParserContextPtr):^xmlChar;cdecl;external;
function xmlXPathParseNCName(ctxt:xmlXPathParserContextPtr):^xmlChar;cdecl;external;
    {
       Debug
      }
{$ifdef LIBXML_DEBUG_ENABLED}

procedure xmlXPathDebugDumpObject(output:PFILE; cur:xmlXPathObjectPtr; depth:longint);cdecl;external;
{$endif}
    {
       Existing functions
      }
(* Const before type ignored *)

function xmlXPathStringEvalNumber(str:PxmlChar):double;cdecl;external;
function xmlXPathEvaluatePredicateResult(ctxt:xmlXPathParserContextPtr; res:xmlXPathObjectPtr):longint;cdecl;external;
procedure xmlXPathInit;cdecl;external;
procedure xmlXPathStringFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathRegisterAllFunctions(ctxt:xmlXPathContextPtr);cdecl;external;
function xmlXPathNodeSetCreate(val:xmlNodePtr):xmlNodeSetPtr;cdecl;external;
procedure xmlXPathNodeSetAdd(cur:xmlNodeSetPtr; val:xmlNodePtr);cdecl;external;
function xmlXPathNodeSetMerge(val1:xmlNodeSetPtr; val2:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external;
procedure xmlXPathNodeSetDel(cur:xmlNodeSetPtr; val:xmlNodePtr);cdecl;external;
procedure xmlXPathNodeSetRemove(cur:xmlNodeSetPtr; val:longint);cdecl;external;
procedure xmlXPathFreeNodeSet(obj:xmlNodeSetPtr);cdecl;external;
function xmlXPathNewNodeSet(val:xmlNodePtr):xmlXPathObjectPtr;cdecl;external;
function xmlXPathNewNodeSetList(val:xmlNodeSetPtr):xmlXPathObjectPtr;cdecl;external;
function xmlXPathWrapNodeSet(val:xmlNodeSetPtr):xmlXPathObjectPtr;cdecl;external;
function xmlXPathWrapExternal(val:pointer):xmlXPathObjectPtr;cdecl;external;
procedure xmlXPathFreeNodeSetList(obj:xmlXPathObjectPtr);cdecl;external;
function xmlXPathNewFloat(val:double):xmlXPathObjectPtr;cdecl;external;
function xmlXPathNewBoolean(val:longint):xmlXPathObjectPtr;cdecl;external;
(* Const before type ignored *)
function xmlXPathNewString(val:PxmlChar):xmlXPathObjectPtr;cdecl;external;
(* Const before type ignored *)
function xmlXPathNewCString(val:Pchar):xmlXPathObjectPtr;cdecl;external;
procedure xmlXPathFreeObject(obj:xmlXPathObjectPtr);cdecl;external;
function xmlXPathNewContext(doc:xmlDocPtr):xmlXPathContextPtr;cdecl;external;
procedure xmlXPathFreeContext(ctxt:xmlXPathContextPtr);cdecl;external;
function xmlXPathEqualValues(ctxt:xmlXPathParserContextPtr):longint;cdecl;external;
function xmlXPathCompareValues(ctxt:xmlXPathParserContextPtr; inf:longint; strict:longint):longint;cdecl;external;
procedure xmlXPathValueFlipSign(ctxt:xmlXPathParserContextPtr);cdecl;external;
procedure xmlXPathAddValues(ctxt:xmlXPathParserContextPtr);cdecl;external;
procedure xmlXPathSubValues(ctxt:xmlXPathParserContextPtr);cdecl;external;
procedure xmlXPathMultValues(ctxt:xmlXPathParserContextPtr);cdecl;external;
procedure xmlXPathDivValues(ctxt:xmlXPathParserContextPtr);cdecl;external;
procedure xmlXPathModValues(ctxt:xmlXPathParserContextPtr);cdecl;external;
(* Const before type ignored *)
function xmlXPathIsNodeType(name:PxmlChar):longint;cdecl;external;
    {
       Some of the axis navigation routines
      }
function xmlXPathNextSelf(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external;
function xmlXPathNextChild(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external;
function xmlXPathNextDescendant(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external;
function xmlXPathNextDescendantOrSelf(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external;
function xmlXPathNextParent(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external;
function xmlXPathNextAncestorOrSelf(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external;
function xmlXPathNextFollowingSibling(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external;
function xmlXPathNextFollowing(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external;
function xmlXPathNextNamespace(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external;
function xmlXPathNextAttribute(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external;
function xmlXPathNextPreceding(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external;
function xmlXPathNextAncestor(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external;
function xmlXPathNextPrecedingSibling(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external;
    {
       The official core of XPath functions
      }
procedure xmlXPathRoot(ctxt:xmlXPathParserContextPtr);cdecl;external;
procedure xmlXPathLastFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathPositionFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathCountFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathIdFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathLocalNameFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathNamespaceURIFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathStringFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathStringLengthFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathConcatFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathContainsFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathStartsWithFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathSubstringFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathSubstringBeforeFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathSubstringAfterFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathNormalizeFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathTranslateFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathNotFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathTrueFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathFalseFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathLangFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathNumberFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathSumFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathFloorFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathCeilingFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathRoundFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
procedure xmlXPathBooleanFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external;
{ C++ end of extern C conditionnal removed }
{$endif}
    { ! __XML_XPATH_INTERNALS_H__  }

