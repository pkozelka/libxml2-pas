// CVS-SIGN: [1.23] xmlmemory.h
{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}

(*
 * xmlmemory.h: interface for the memory allocation debug.
 *
 * daniel@veillard.com
 *)

(**
 * DEBUG_MEMORY:
 *
 * should be activated only done when debugging libxml. It replaces the
 * allocator with a collect and debug shell to the libc allocator.
 * DEBUG_MEMORY should be activated only when debugging
 * libxml i.e. if libxml has been configured with --with-debug-mem too
 *)
{-$define DEBUG_MEMORY_FREED}
{-$define DEBUG_MEMORY_LOCATION}

{$ifdef DEBUG}
{$ifndef DEBUG_MEMORY}
{$define DEBUG_MEMORY}
{$endif}
{$endif}

(**
 * DEBUG_MEMORY_LOCATION:
 *
 * DEBUG_MEMORY_LOCATION should be activated only when debugging
 * libxml i.e. if libxml has been configured with --with-debug-mem too
 *)

{$ifdef DEBUG}
{$endif}

type
  (*
   * The XML memory wrapper support 4 basic overloadable functions
   *)

  (**
   * xmlFreeFunc:
   * @mem: an already allocated block of memory
   *
   * Signature for a free() implementation
   *)
	xmlFreeFunc = procedure(ptr: pointer); cdecl;
	PxmlFreeFunc = ^xmlFreeFunc;

  (**
   * xmlMallocFunc:
   * @size:  the size requested in bytes
   *
   * Signature for a malloc() implementation
   *
   * Returns a pointer to the newly allocated block or NULL in case of error
   *)
	xmlMallocFunc = function (size:size_t):pointer; cdecl;
	PxmlMallocFunc = ^xmlMallocFunc;

  (**
   * xmlReallocFunc:
   * @mem: an already allocated block of memory
   * @size:  the new size requested in bytes
   *
   * Signature for a realloc() implementation
   *
   * Returns a pointer to the newly reallocated block or NULL in case of error
   *)
	xmlReallocFunc = function (ptr:pointer; size:size_t):pointer; cdecl;
	PxmlReallocFunc = ^xmlReallocFunc;

  (**
   * xmlStrdupFunc:
   * @str: a zero terminated string
   *
   * Signature for an strdup() implementation
   *
   * Returns the copy of the string or NULL in case of error
   *)
	xmlStrdupFunc = function (str:PChar):PChar; cdecl;
	PxmlStrdupFunc = ^xmlStrdupFunc;

  (*
   * The 4 interfaces used for all memory handling within libxml
   *)
(* TODO somehow
LIBXML_DLL_IMPORT extern xmlFreeFunc xmlFree;
LIBXML_DLL_IMPORT extern xmlMallocFunc xmlMalloc;
LIBXML_DLL_IMPORT extern xmlReallocFunc xmlRealloc;
LIBXML_DLL_IMPORT extern xmlStrdupFunc xmlMemStrdup;
*)

(*
 * The way to overload the existing functions
 *)
function  xmlMemSetup(freeFunc: PxmlFreeFunc; mallocFunc: PxmlMallocFunc; reallocFunc: PxmlReallocFunc; strdupFunc: PxmlStrdupFunc):longint;cdecl;external LIBXML2_SO;
function  xmlMemGet(var freeFunc: PxmlFreeFunc; var mallocFunc: PxmlMallocFunc; var reallocFunc: PxmlReallocFunc; var strdupFunc: PxmlStrdupFunc):longint;cdecl;external LIBXML2_SO;

(*
 * Initialization of the memory layer
 *)
function  xmlInitMemory:longint;cdecl;external LIBXML2_SO;

(*
 * Those are specific to the XML debug memory wrapper
 *)
function  xmlMemUsed:longint;cdecl;external LIBXML2_SO;
procedure xmlMemDisplay(var fp:TextFile);cdecl;external LIBXML2_SO;
procedure xmlMemShow(var fp:TextFile; nr:longint);cdecl;external LIBXML2_SO;
procedure xmlMemoryDump;cdecl;external LIBXML2_SO;

{$ifdef XML_DEBUG_MEMORY_LOCATION}
(**
 * xmlMalloc:
 * @size:  number of bytes to allocate
 *
 * Wrapper for the malloc() function used in the XML library
 *
 * Returns the pointer to the allocated area or NULL in case of error
 *)
//TODO: #define xmlMalloc(size) xmlMallocLoc((size), __FILE__, __LINE__)
(**
 * xmlRealloc:
 * @ptr:  pointer to the existing allocated area
 * @size:  number of bytes to allocate
 *
 * Wrapper for the realloc() function used in the XML library
 *
 * Returns the pointer to the allocated area or NULL in case of error
 *)
//TODO: #define xmlRealloc(ptr, size) xmlReallocLoc((ptr), (size), __FILE__, __LINE__)
(**
 * xmlMemStrdup:
 * @str:  pointer to the existing string
 *
 * Wrapper for the strdup() function, xmlStrdup() is usually preferred
 *
 * Returns the pointer to the allocated area or NULL in case of error
 *)
//TODO: #define xmlMemStrdup(str) xmlMemStrdupLoc((str), __FILE__, __LINE__)

procedure xmlMallocLoc(size: size_t; filename: PChar; line: longint);
procedure xmlReallocLoc(ptr: pointer; size: size_t; filename: PChar; line: longint);
function  xmlMemStrdupLoc(str: PChar; filename: PChar; line: longint): PChar;

{$endif} // XML_DEBUG_MEMORY_LOCATION

