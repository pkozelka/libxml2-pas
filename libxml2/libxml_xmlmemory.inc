{ [1.21] libxml2-2.4.12
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}

{
	xmlmemory.h: interface for the memory allocation debug.

	daniel@veillard.com
}

{
	DEBUG_MEMORY:

	should be activated only done when debugging libxml. It replaces the
	allocator with a collect and debug shell to the libc allocator.
	DEBUG_MEMORY should be activated only when debugging
	libxml i.e. if libxml has been configured with --with-debug-mem too
}
{-$define DEBUG_MEMORY_FREED}
{-$define DEBUG_MEMORY_LOCATION}

{$ifdef DEBUG}
{$ifndef DEBUG_MEMORY}
{$define DEBUG_MEMORY}
{$endif}
{$endif}

{
	 DEBUG_MEMORY_LOCATION:

	 DEBUG_MEMORY_LOCATION should be activated only when debugging
	 libxml i.e. if libxml has been configured with --with-debug-mem too
}

{$ifdef DEBUG}
(**
 * MEM_LIST:
 *
 * keep track of all allocated blocks for error reporting
 *)
{$define MEM_LIST} (* keep a list of all the allocated memory blocks *)
{$endif}

type
	{
	 The XML memory wrapper support 4 basic overloadable functions
	}
	xmlFreeFunc = function(ptr: pointer): pointer;
	xmlMallocFunc = function (size:size_t):pointer;cdecl;
	xmlReallocFunc = function (ptr:pointer; size:size_t):pointer;cdecl;
	xmlStrdupFunc = function (str:PChar):Pchar;cdecl;

	{
		The 4 interfaces used for all memory handling within libxml
	}
(* TODO somehow
LIBXML_DLL_IMPORT extern xmlFreeFunc xmlFree;
LIBXML_DLL_IMPORT extern xmlMallocFunc xmlMalloc;
LIBXML_DLL_IMPORT extern xmlReallocFunc xmlRealloc;
LIBXML_DLL_IMPORT extern xmlStrdupFunc xmlMemStrdup;
*)

{
	The way to overload the existing functions
}
function  xmlMemSetup(var freeFunc: xmlFreeFunc; var mallocFunc: xmlMallocFunc; var reallocFunc: xmlReallocFunc; var strdupFunc: xmlStrdupFunc):longint;cdecl;external LIBXML2_SO;
function  xmlMemGet(var freeFunc: xmlFreeFunc; var mallocFunc: xmlMallocFunc; var reallocFunc: xmlReallocFunc; var strdupFunc: xmlStrdupFunc):longint;cdecl;external LIBXML2_SO;

{
	Initialization of the memory layer
}
function  xmlInitMemory:longint;cdecl;external LIBXML2_SO;

{
	Those are specific to the XML debug memory wrapper
}
function  xmlMemUsed:longint;cdecl;external LIBXML2_SO;
procedure xmlMemDisplay(var fp:TextFile);cdecl;external LIBXML2_SO;
procedure xmlMemShow(var fp:TextFile; nr:longint);cdecl;external LIBXML2_SO;
procedure xmlMemoryDump;cdecl;external LIBXML2_SO;

{$ifdef XML_DEBUG_MEMORY_LOCATION}
{todo:
xmlMalloc
xmlRealloc
xmlMemStrdup
}
procedure xmlMallocLoc(size: size_t; filename: PChar; line: longint);
procedure xmlReallocLoc(ptr: pointer; size: size_t; filename: PChar; line: longint);
function  xmlMemStrdupLoc(str: PChar; filename: PChar; line: longint): PChar;

{$endif} // XML_DEBUG_MEMORY_LOCATION

