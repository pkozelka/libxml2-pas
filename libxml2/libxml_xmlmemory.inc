{
	xmlmemory.h: interface for the memory allocation debug.

	daniel@veillard.com
}

{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}

{
	DEBUG_MEMORY:

	should be activated only done when debugging libxml. It replaces the
	allocator with a collect and debug shell to the libc allocator.
	DEBUG_MEMORY should be activated only when debugging
	libxml i.e. if libxml has been configured with --with-debug-mem too
}

{
	 DEBUG_MEMORY_LOCATION:

	 should be activated
	 DEBUG_MEMORY_LOCATION should be activated only when debugging
	 libxml i.e. if libxml has been configured with --with-debug-mem too
	}
const
	XML_XML_NAMESPACE = 'http://www.w3.org/XML/1998/namespace';
type
	{
	 The XML memory wrapper support 4 basic overloadable functions
	}
	xmlFreeFunc = function: pointer;
	PxmlFreeFunc = ^xmlFreeFunc;

	xmlMallocFunc = function (_para1:longint):pointer;cdecl;
	PxmlMallocFunc = ^xmlMallocFunc;
	xmlReallocFunc = function (_para1:pointer; _para2:longint):pointer;cdecl;
	xmlStrdupFunc = function (_para1:Pchar):Pchar;cdecl;

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
function  xmlMemSetup(freeFunc:xmlFreeFunc; mallocFunc:xmlMallocFunc; reallocFunc:xmlReallocFunc; strdupFunc:xmlStrdupFunc):longint;cdecl;external LIBXML2_SO;
function  xmlMemGet(freeFunc:PxmlFreeFunc; mallocFunc:PxmlMallocFunc; var reallocFunc:xmlReallocFunc; var strdupFunc:xmlStrdupFunc):longint;cdecl;external LIBXML2_SO;

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

