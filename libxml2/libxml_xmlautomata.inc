(*
 * automata.h : description of the API to build regexp automats
 *
 * See Copyright for the status of this software.
 *
 * Daniel Veillard <veillard@redhat.com>
 *)

(* 
 * xmlAutomataPtr:
 * 
 * A libxml automata description, It can be compiled into a regexp
 *)
type
  _xmlAutomata = xmlAutomata;
  xmlAutomataPtr = xmlAutomata;

(* 
 * xmlAutomataStatePtr:
 *
 * A state int the automata description,
 *)
  _xmlAutomataState = xmlAutomataState;
  xmlAutomataStatePtr = xmlAutomataState;

(*
 * Building API
 *)
function xmlNewAutomata:xmlAutomataPtr;cdecl;external;
procedure xmlFreeAutomata(am:xmlAutomataPtr);cdecl;external;
function xmlAutomataGetInitState(am:xmlAutomataPtr):xmlAutomataStatePtr;cdecl;external;
function xmlAutomataSetFinalState(am:xmlAutomataPtr; state:xmlAutomataStatePtr):longint;cdecl;external;
function xmlAutomataNewState(am:xmlAutomataPtr):xmlAutomataStatePtr;cdecl;external;
function xmlAutomataNewTransition(am:xmlAutomataPtr; from:xmlAutomataStatePtr; to:xmlAutomataStatePtr; token:PxmlChar; data:pointer):xmlAutomataStatePtr;cdecl;external;
function xmlAutomataNewCountTrans(am:xmlAutomataPtr; from:xmlAutomataStatePtr; to:xmlAutomataStatePtr; token:PxmlChar; min:longint; max:longint; data:pointer):xmlAutomataStatePtr;cdecl;external;
function xmlAutomataNewEpsilon(am:xmlAutomataPtr; from:xmlAutomataStatePtr; to:xmlAutomataStatePtr):xmlAutomataStatePtr;cdecl;external;
function xmlAutomataNewCounter(am:xmlAutomataPtr):longint;cdecl;external;
function xmlAutomataCompile(am:xmlAutomataPtr):xmlRegexpPtr;cdecl;external;

