// CVS-SIGN: [1.0] xmlregexp.h
(*
 * regexp.h : describes the basic API for libxml regular expressions handling
 *
 * See Copyright for the status of this software.
 *
 * Daniel Veillard <veillard@redhat.com>
 *)


(**
 * xmlRegexpPtr:
 *
 * A libxml regular expression, they can actually be far more complex
 * thank the POSIX regex expressions.
 *)
type
   _xmlRegexp = xmlRegexp;
   xmlRegexpPtr = xmlRegexp;

(**
 * xmlRegExecCtxtPtr:
 *
 * A libxml progressive regular expression evaluation context
 *)
   _xmlRegExecCtxt = xmlRegExecCtxt;
   xmlRegExecCtxtPtr = xmlRegExecCtxt;

(*
 * The POSIX like API
 *)
function xmlRegexpCompile(regexp:PxmlChar):xmlRegexpPtr;cdecl;external;
procedure xmlRegFreeRegexp(regexp:xmlRegexpPtr);cdecl;external;
function xmlRegexpExec(comp:xmlRegexpPtr; value:PxmlChar):longint;cdecl;external;
procedure xmlRegexpPrint(output:PFILE; regexp:xmlRegexpPtr);cdecl;external;

(*
 * Callback function when doing a transition in the automata
 *)
type
  xmlRegExecCallbacks = procedure (exec:xmlRegExecCtxtPtr; token:PxmlChar; transdata:pointer; inputdata:pointer);cdecl;

(*
 * The progressive API
 *)
function xmlRegNewExecCtxt(comp:xmlRegexpPtr; callback:xmlRegExecCallbacks; data:pointer):xmlRegExecCtxtPtr;cdecl;external;
procedure xmlRegFreeExecCtxt(exec:xmlRegExecCtxtPtr);cdecl;external;
function xmlRegExecPushString(exec:xmlRegExecCtxtPtr; value:PxmlChar; data:pointer):longint;cdecl;external;
