// CVS-SIGN: [1.28] xpathInternals.h
{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}
{
	 xpathInternals.c: internal interfaces for XML Path Language implementation
										 used to build new modules on top of XPath

   See COPYRIGHT for the status of this software
  
   Author: daniel@veillard.com
	}

(************************************************************************
 *									*
 *			Helpers						*
 *									*
 ************************************************************************)

(**
 * Many of these macros may later turn into functions. They
 * shouldn't be used in #ifdef's preprocessor instructions.
 *)

(**
 * xmlXPathSetError:
 * @ctxt:  an XPath parser context
 * @err:  an xmlXPathError code
 *
 * Raises an error.
 *)
(*TODO: #define xmlXPathSetError(ctxt, err)					\
    { xmlXPatherror((ctxt), __FILE__, __LINE__, (err));			\
    { xmlXPatherror((ctxt), __FILE__, __LINE__, (err));			\
      (ctxt)->error = (err); }
*)

(**
 * xmlXPathSetArityError:
 * @ctxt:  an XPath parser context
 *
 * Raises an XPATH_INVALID_ARITY error
 *)
(*TODO: #define xmlXPathSetArityError(ctxt)					\
    xmlXPathSetError((ctxt), XPATH_INVALID_ARITY)
*)

(**
 * xmlXPathSetTypeError:
 * @ctxt:  an XPath parser context
 *
 * Raises an XPATH_INVALID_TYPE error
 *)
(*TODO: #define xmlXPathSetTypeError(ctxt)					\
    xmlXPathSetError((ctxt), XPATH_INVALID_TYPE)
*)

(**
 * xmlXPathGetError:
 * @ctxt:  an XPath parser context
 *
 * Get the error code of an XPath context
 *
 * Returns the context error
 *)
//TODO: #define xmlXPathGetError(ctxt)	  ((ctxt)->error)

(**
 * xmlXPathCheckError:
 * @ctxt:  an XPath parser context
 *
 * Check if an XPath error was raised
 *
 * Returns true if an error has been raised, false otherwise.
 *)
//TODO: #define xmlXPathCheckError(ctxt)  ((ctxt)->error != XPATH_EXPRESSION_OK)

(**
 * xmlXPathGetDocument:
 * @ctxt:  an XPath parser context
 *
 * Get the document of an XPath context
 *
 * Returns the context document
 *)
//TODO: #define xmlXPathGetDocument(ctxt)	((ctxt)->context->doc)

(**
 * xmlXPathGetContextNode:
 * @ctxt: an XPath parser context
 *
 * Get the context node of an XPath context
 *
 * Returns the context node
 *)
//TODO: #define xmlXPathGetContextNode(ctxt)	((ctxt)->context->node)

function  xmlXPathPopBoolean(ctxt: xmlXPathParserContextPtr): Longint; cdecl;external LIBXML2_SO;
function  xmlXPathPopNumber(ctxt:xmlXPathParserContextPtr):double; cdecl;external LIBXML2_SO;
function  xmlXPathPopString(ctxt:xmlXPathParserContextPtr):PxmlChar; cdecl;external LIBXML2_SO;
function  xmlXPathPopNodeSet(ctxt:xmlXPathParserContextPtr):xmlNodeSetPtr; cdecl;external LIBXML2_SO;
function  xmlXPathPopExternal(ctxt:xmlXPathParserContextPtr):pointer; cdecl;external LIBXML2_SO;
(**
 * xmlXPathReturnBoolean:
 * @ctxt:  an XPath parser context
 * @val:  a boolean
 *
 * Pushes the boolean @val on the context stack
 *)
//TODO: #define xmlXPathReturnBoolean(ctxt, val)    valuePush((ctxt), xmlXPathNewBoolean(val))

(**
 * xmlXPathReturnTrue:
 * @ctxt:  an XPath parser context
 *
 * Pushes true on the context stack
 *)
//TODO: #define xmlXPathReturnTrue(ctxt)   xmlXPathReturnBoolean((ctxt), 1)

(**
 * xmlXPathReturnFalse:
 * @ctxt:  an XPath parser context
 *
 * Pushes false on the context stack
 *)
//TODO: #define xmlXPathReturnFalse(ctxt)  xmlXPathReturnBoolean((ctxt), 0)

(**
 * xmlXPathReturnNumber:
 * @ctxt:  an XPath parser context
 * @val:  a double
 *
 * Pushes the double @val on the context stack
 *)
//TODO: #define xmlXPathReturnNumber(ctxt, val)		valuePush((ctxt), xmlXPathNewFloat(val))

(**
 * xmlXPathReturnString:
 * @ctxt:  an XPath parser context
 * @str:  a string
 *
 * Pushes the string @str on the context stack
 *)
//TODO: #define xmlXPathReturnString(ctxt, str)		valuePush((ctxt), xmlXPathWrapString(str))

(**
 * xmlXPathReturnEmptyString:
 * @ctxt:  an XPath parser context
 *
 * Pushes an empty string on the stack
 *)
//TODO: #define xmlXPathReturnEmptyString(ctxt)		valuePush((ctxt), xmlXPathNewCString(""))

(**
 * xmlXPathReturnNodeSet:
 * @ctxt:  an XPath parser context
 * @ns:  a node-set
 *
 * Pushes the node-set @ns on the context stack
 *)
//TODO: #define xmlXPathReturnNodeSet(ctxt, ns)	  valuePush((ctxt), xmlXPathWrapNodeSet(ns))

(**
 * xmlXPathReturnEmptyNodeSet:
 * @ctxt:  an XPath parser context
 *
 * Pushes an empty node-set on the context stack
 *)
//TODO: #define xmlXPathReturnEmptyNodeSet(ctxt)	valuePush((ctxt), xmlXPathNewNodeSet(NULL))

(**
 * xmlXPathReturnExternal:
 * @ctxt:  an XPath parser context
 * @val:  user data
 *
 * Pushes user data on the context stack
 *)
//TODO: #define xmlXPathReturnExternal(ctxt, val)	  valuePush((ctxt), xmlXPathWrapExternal(val))

(**
 * xmlXPathStackIsNodeSet:
 * @ctxt: an XPath parser context
 *
 * Check if the current value on the XPath stack is a node set or
 * an XSLT value tree
 *
 * Returns true if the current object on the stack is a node-set
 *)
(*TODO:
#define xmlXPathStackIsNodeSet(ctxt)					\
    (((ctxt)->value != NULL)						\
     && (((ctxt)->value->type == XPATH_NODESET)				\
         || ((ctxt)->value->type == XPATH_XSLT_TREE)))
*)

(**
 * xmlXPathStackIsExternal:
 * @ctxt: an XPath parser context
 *
 * Checks if the current value on the XPath stack is an external
 * object.
 *
 * Returns true if the current object on the stack is an external
 * object
 *)
//TODO: #define xmlXPathStackIsExternal(ctxt)		((ctxt->value != NULL) && (ctxt->value->type == XPATH_USERS))

(**
 * xmlXPathEmptyNodeSet:
 * @ns:  a node-set
 *
 * Empties a node-set
 *)
//TODO: #define xmlXPathEmptyNodeSet(ns)	 { while ((ns)->nodeNr > 0) (ns)->nodeTab[(ns)->nodeNr--] = NULL; }

(**
 * CHECK_ERROR:
 *
 * macro to return from the function if an XPath error was detected
 *)
//TODO: #define CHECK_ERROR		 if (ctxt->error != XPATH_EXPRESSION_OK) return

(**
 * CHECK_ERROR0:
 *
 * macro to return 0 from the function if an XPath error was detected
 *)
//TODO: #define CHECK_ERROR0		if (ctxt->error != XPATH_EXPRESSION_OK) return(0)

(**
 * XP_ERROR:
 * @X:  the error code
 *
 * Macro to raise an XPath error and return
 *)
(*TODO:
#define XP_ERROR(X)							\
    { xmlXPatherror(ctxt, __FILE__, __LINE__, X);			\
      ctxt->error = (X); return; }
*)

(**
 * XP_ERROR0:
 * @X:  the error code
 *
 * Macro to raise an XPath error and return 0
 *)
(*TODO:
#define XP_ERROR0(X)							\
    { xmlXPatherror(ctxt, __FILE__, __LINE__, X);			\
      ctxt->error = (X); return(0); }
*)

(**
 * CHECK_TYPE:
 * @typeval:  the XPath type
 *
 * Macro to check that the value on top of the XPath stack is of a given
 * type.
 *)
(*TODO:
#define CHECK_TYPE(typeval)						\
    if ((ctxt->value == NULL) || (ctxt->value->type != typeval))	\
        XP_ERROR(XPATH_INVALID_TYPE)
*)

(**
 * CHECK_TYPE0:
 * @typeval:  the XPath type
 *
 * Macro to check that the value on top of the XPath stack is of a given
 * type. return(0) in case of failure
 *)
(*TODO:
#define CHECK_TYPE0(typeval)						\
    if ((ctxt->value == NULL) || (ctxt->value->type != typeval))	\
        XP_ERROR0(XPATH_INVALID_TYPE)
*)

(**
 * CHECK_ARITY:
 * @x:  the number of expected args
 *
 * Macro to check that the number of args passed to an XPath function matches
 *)
(*TODO:
#define CHECK_ARITY(x)							\
    if (nargs != (x))							\
        XP_ERROR(XPATH_INVALID_ARITY);
*)

(**
 * CAST_TO_STRING:
 *
 * Macro to try to cast the value on the top of the XPath stack to a string
 *)
(*TODO:
#define CAST_TO_STRING							\
    if ((ctxt->value != NULL) && (ctxt->value->type != XPATH_STRING))	\
        xmlXPathStringFunction(ctxt, 1);
*)

(**
 * CAST_TO_NUMBER:
 *
 * Macro to try to cast the value on the top of the XPath stack to a number
 *)
(*TODO:
#define CAST_TO_NUMBER							\
    if ((ctxt->value != NULL) && (ctxt->value->type != XPATH_NUMBER))	\
        xmlXPathNumberFunction(ctxt, 1);
*)

(**
 * CAST_TO_BOOLEAN:
 *
 * Macro to try to cast the value on the top of the XPath stack to a boolean
 *)
(*TODO:
#define CAST_TO_BOOLEAN							\
    if ((ctxt->value != NULL) && (ctxt->value->type != XPATH_BOOLEAN))	\
        xmlXPathBooleanFunction(ctxt, 1);
*)

  (*
   * Variable Lookup forwarding
   *)
  (**
   * xmlXPathVariableLookupFunc:
   * @ctxt:  an XPath context
   * @name:  name of the variable
   * @ns_uri:  the namespace name hosting this variable
   *
   * Prototype for callbacks used to plug variable lookup in the XPath
   * engine
   *
   * Returns the XPath object value or NULL if not found
   *)
type
	xmlXPathVariableLookupFunc = function  (ctxt:pointer; name:PxmlChar; ns_uri:PxmlChar):xmlXPathObjectPtr;cdecl;

procedure xmlXPathRegisterVariableLookup(ctxt:xmlXPathContextPtr; f:xmlXPathVariableLookupFunc; data:pointer);cdecl;external LIBXML2_SO;

type
  (*
   * Function Lookup forwarding
   *)
  (**
   * xmlXPathFuncLookupFunc:
   * @ctxt:  an XPath context
   * @name:  name of the function
   * @ns_uri:  the namespace name hosting this function
   *
   * Prototype for callbacks used to plug function lookup in the XPath
   * engine
   *
   * Returns the XPath function or NULL if not found
   *)
	xmlXPathFuncLookupFunc = function  (ctxt:pointer; name:PxmlChar; ns_uri:PxmlChar):xmlXPathFunction;cdecl;

procedure xmlXPathRegisterFuncLookup(ctxt:xmlXPathContextPtr; f:xmlXPathFuncLookupFunc; funcCtxt:pointer);cdecl;external LIBXML2_SO;

(*
 * Error reporting
 *)
procedure xmlXPatherror(ctxt:xmlXPathParserContextPtr; filename:Pchar; line:longint; no:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathDebugDumpObject(var output:TextFile; cur:xmlXPathObjectPtr; depth:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathDebugDumpCompExpr(var output:TextFile; comp:xmlXPathCompExprPtr; depth:longint);cdecl;external LIBXML2_SO;

(**
 * NodeSet handling
 *)
function  xmlXPathNodeSetContains(cur:xmlNodeSetPtr; val:xmlNodePtr):longint;cdecl;external LIBXML2_SO;
function  xmlXPathDifference(nodes1:xmlNodeSetPtr; nodes2:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external LIBXML2_SO;
function  xmlXPathIntersection(nodes1:xmlNodeSetPtr; nodes2:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external LIBXML2_SO;
function  xmlXPathDistinctSorted(nodes:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external LIBXML2_SO;
function  xmlXPathDistinct(nodes:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external LIBXML2_SO;
function  xmlXPathHasSameNodes(nodes1:xmlNodeSetPtr; nodes2:xmlNodeSetPtr):longint;cdecl;external LIBXML2_SO;
function  xmlXPathNodeLeadingSorted(nodes:xmlNodeSetPtr; node:xmlNodePtr):xmlNodeSetPtr;cdecl;external LIBXML2_SO;
function  xmlXPathLeadingSorted(nodes1:xmlNodeSetPtr; nodes2:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external LIBXML2_SO;
function  xmlXPathNodeLeading(nodes:xmlNodeSetPtr; node:xmlNodePtr):xmlNodeSetPtr;cdecl;external LIBXML2_SO;
function  xmlXPathLeading(nodes1:xmlNodeSetPtr; nodes2:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external LIBXML2_SO;
function  xmlXPathNodeTrailingSorted(nodes:xmlNodeSetPtr; node:xmlNodePtr):xmlNodeSetPtr;cdecl;external LIBXML2_SO;
function  xmlXPathTrailingSorted(nodes1:xmlNodeSetPtr; nodes2:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external LIBXML2_SO;
function  xmlXPathNodeTrailing(nodes:xmlNodeSetPtr; node:xmlNodePtr):xmlNodeSetPtr;cdecl;external LIBXML2_SO;
function  xmlXPathTrailing(nodes1:xmlNodeSetPtr; nodes2:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external LIBXML2_SO;

(**
 * Extending a context
 *)
function  xmlXPathRegisterNs(ctxt:xmlXPathContextPtr;prefix,ns_uri:PxmlChar):longint;cdecl;external LIBXML2_SO;
function  xmlXPathNsLookup(ctxt:xmlXPathContextPtr; prefix:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
procedure xmlXPathRegisteredNsCleanup(ctxt:xmlXPathContextPtr);cdecl;external LIBXML2_SO;
function  xmlXPathRegisterFunc(ctxt:xmlXPathContextPtr; name:PxmlChar; f:xmlXPathFunction):longint;cdecl;external LIBXML2_SO;
function  xmlXPathRegisterFuncNS(ctxt:xmlXPathContextPtr; name,ns_uri:PxmlChar; f:xmlXPathFunction):longint;cdecl;external LIBXML2_SO;
function  xmlXPathRegisterVariable(ctxt:xmlXPathContextPtr; name:PxmlChar; value:xmlXPathObjectPtr):longint;cdecl;external LIBXML2_SO;
function  xmlXPathRegisterVariableNS(ctxt:xmlXPathContextPtr; name, ns_uri:PxmlChar; value:xmlXPathObjectPtr):longint;cdecl;external LIBXML2_SO;
function  xmlXPathFunctionLookup(ctxt:xmlXPathContextPtr; name:PxmlChar):xmlXPathFunction;cdecl;external LIBXML2_SO;
function  xmlXPathFunctionLookupNS(ctxt:xmlXPathContextPtr; name, ns_uri:PxmlChar):xmlXPathFunction;cdecl;external LIBXML2_SO;
procedure xmlXPathRegisteredFuncsCleanup(ctxt:xmlXPathContextPtr);cdecl;external LIBXML2_SO;
function  xmlXPathVariableLookup(ctxt:xmlXPathContextPtr; name:PxmlChar):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
function  xmlXPathVariableLookupNS(ctxt:xmlXPathContextPtr; name, ns_uri:PxmlChar):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
procedure xmlXPathRegisteredVariablesCleanup(ctxt:xmlXPathContextPtr);cdecl;external LIBXML2_SO;

(**
 * Utilities to extend XPath
 *)
function  xmlXPathNewParserContext(str:PxmlChar; ctxt:xmlXPathContextPtr):xmlXPathParserContextPtr;cdecl;external LIBXML2_SO;
procedure xmlXPathFreeParserContext(ctxt:xmlXPathParserContextPtr);cdecl;external LIBXML2_SO;
(* TODO: remap to xmlXPathValuePop and Push *)
function  valuePop(ctxt:xmlXPathParserContextPtr):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
function  valuePush(ctxt:xmlXPathParserContextPtr; value:xmlXPathObjectPtr):longint;cdecl;external LIBXML2_SO;
function  xmlXPathNewString(val:PxmlChar):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
function  xmlXPathNewCString(val:Pchar):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
function  xmlXPathWrapString(val:PxmlChar):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
function  xmlXPathWrapCString(val:Pchar):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
function  xmlXPathNewFloat(val:double):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
function  xmlXPathNewBoolean(val:longint):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
function  xmlXPathNewNodeSet(val:xmlNodePtr):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
function  xmlXPathNewValueTree(val:xmlNodePtr):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
procedure xmlXPathNodeSetAdd(cur:xmlNodeSetPtr; val:xmlNodePtr);cdecl;external LIBXML2_SO;
procedure xmlXPathNodeSetAddUnique(cur:xmlNodeSetPtr; val:xmlNodePtr);cdecl;external LIBXML2_SO;
procedure xmlXPathNodeSetSort(nodeset:xmlNodeSetPtr);cdecl;external LIBXML2_SO;
procedure xmlXPathIdFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathRoot(ctxt:xmlXPathParserContextPtr);cdecl;external LIBXML2_SO;
procedure xmlXPathEvalExpr(ctxt:xmlXPathParserContextPtr);cdecl;external LIBXML2_SO;
function  xmlXPathParseName(ctxt:xmlXPathParserContextPtr):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlXPathParseNCName(ctxt:xmlXPathParserContextPtr):PxmlChar;cdecl;external LIBXML2_SO;
(*
 * Debug
 *)
{$ifdef LIBXML_DEBUG_ENABLED}
//[pk] see the same declaration above: procedure xmlXPathDebugDumpObject(var output:TextFile; cur:xmlXPathObjectPtr; depth:longint);cdecl;external LIBXML2_SO;
{$endif}

(*
 * Existing functions
 *)
function  xmlXPathStringEvalNumber(str:PxmlChar):double;cdecl;external LIBXML2_SO;
function  xmlXPathEvaluatePredicateResult(ctxt:xmlXPathParserContextPtr; res:xmlXPathObjectPtr):longint;cdecl;external LIBXML2_SO;
//[pk] see "xpath": procedure xmlXPathInit;cdecl;external LIBXML2_SO;
procedure xmlXPathStringFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathRegisterAllFunctions(ctxt:xmlXPathContextPtr);cdecl;external LIBXML2_SO;
//[pk] see "xpath": function  xmlXPathNodeSetCreate(val:xmlNodePtr):xmlNodeSetPtr;cdecl;external LIBXML2_SO;
//[pk] see "xpath": procedure xmlXPathNodeSetAdd(cur:xmlNodeSetPtr; val:xmlNodePtr);cdecl;external LIBXML2_SO;
function  xmlXPathNodeSetMerge(val1:xmlNodeSetPtr; val2:xmlNodeSetPtr):xmlNodeSetPtr;cdecl;external LIBXML2_SO;
procedure xmlXPathNodeSetDel(cur:xmlNodeSetPtr; val:xmlNodePtr);cdecl;external LIBXML2_SO;
procedure xmlXPathNodeSetRemove(cur:xmlNodeSetPtr; val:longint);cdecl;external LIBXML2_SO;
//[pk] see "xpath": procedure xmlXPathFreeNodeSet(obj:xmlNodeSetPtr);cdecl;external LIBXML2_SO;
//[pk] see "xpath": function  xmlXPathNewNodeSet(val:xmlNodePtr):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
function  xmlXPathNewNodeSetList(val:xmlNodeSetPtr):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
function  xmlXPathWrapNodeSet(val:xmlNodeSetPtr):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
function  xmlXPathWrapExternal(val:pointer):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
//[pk] see "xpath": procedure xmlXPathFreeNodeSetList(obj:xmlXPathObjectPtr);cdecl;external LIBXML2_SO;
//[pk] see "xpath": function  xmlXPathNewFloat(val:double):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
//[pk] see "xpath": function  xmlXPathNewBoolean(val:longint):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
//[pk] see "xpath": function  xmlXPathNewString(val:PxmlChar):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
//[pk] see "xpath": function  xmlXPathNewCString(val:Pchar):xmlXPathObjectPtr;cdecl;external LIBXML2_SO;
//[pk] see "xpath": procedure xmlXPathFreeObject(obj:xmlXPathObjectPtr);cdecl;external LIBXML2_SO;
//[pk] see "xpath": function  xmlXPathNewContext(doc:xmlDocPtr):xmlXPathContextPtr;cdecl;external LIBXML2_SO;
//[pk] see "xpath": procedure xmlXPathFreeContext(ctxt:xmlXPathContextPtr);cdecl;external LIBXML2_SO;
function  xmlXPathEqualValues(ctxt:xmlXPathParserContextPtr):longint;cdecl;external LIBXML2_SO;
function  xmlXPathCompareValues(ctxt:xmlXPathParserContextPtr; inf:longint; strict:longint):longint;cdecl;external LIBXML2_SO;
procedure xmlXPathValueFlipSign(ctxt:xmlXPathParserContextPtr);cdecl;external LIBXML2_SO;
procedure xmlXPathAddValues(ctxt:xmlXPathParserContextPtr);cdecl;external LIBXML2_SO;
procedure xmlXPathSubValues(ctxt:xmlXPathParserContextPtr);cdecl;external LIBXML2_SO;
procedure xmlXPathMultValues(ctxt:xmlXPathParserContextPtr);cdecl;external LIBXML2_SO;
procedure xmlXPathDivValues(ctxt:xmlXPathParserContextPtr);cdecl;external LIBXML2_SO;
procedure xmlXPathModValues(ctxt:xmlXPathParserContextPtr);cdecl;external LIBXML2_SO;
function  xmlXPathIsNodeType(name:PxmlChar):longint;cdecl;external LIBXML2_SO;

(*
 * Some of the axis navigation routines
 *)
function  xmlXPathNextSelf(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlXPathNextChild(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlXPathNextDescendant(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlXPathNextDescendantOrSelf(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlXPathNextParent(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlXPathNextAncestorOrSelf(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlXPathNextFollowingSibling(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlXPathNextFollowing(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlXPathNextNamespace(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlXPathNextAttribute(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlXPathNextPreceding(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlXPathNextAncestor(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlXPathNextPrecedingSibling(ctxt:xmlXPathParserContextPtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;

(*
 * The official core of XPath functions
 *)
//[pk] see "xpath": procedure xmlXPathRoot(ctxt:xmlXPathParserContextPtr);cdecl;external LIBXML2_SO;
procedure xmlXPathLastFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathPositionFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathCountFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
//[pk] see "xpath": procedure xmlXPathIdFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathLocalNameFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathNamespaceURIFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
//[pk] see "xpath": procedure xmlXPathStringFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathStringLengthFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathConcatFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathContainsFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathStartsWithFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathSubstringFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathSubstringBeforeFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathSubstringAfterFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathNormalizeFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathTranslateFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathNotFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathTrueFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathFalseFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathLangFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathNumberFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathSumFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathFloorFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathCeilingFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathRoundFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;
procedure xmlXPathBooleanFunction(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXML2_SO;

