{
	xmlIO.h : interface for the I/O interfaces used by the parser

	See Copyright for the status of this software.

	daniel@veillard.com

	15 Nov 2000 ht - modified for VMS
}

{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}

type
	{
		Those are the functions and datatypes for the parser input
		I/O structures.
	}
	xmlInputMatchCallback = function(filename: PChar):Integer;cdecl;
	xmlInputOpenCallback = procedure (filename:Pchar);cdecl;
	xmlInputReadCallback = function (context: pointer; buffer: PChar; len: integer):Integer;cdecl;
	xmlInputCloseCallback = procedure (context: pointer);

	xmlParserInputBufferPtr = ^xmlParserInputBuffer;
	xmlParserInputBuffer = record
		context : pointer;
		readcallback : xmlInputReadCallback;
		closecallback : xmlInputCloseCallback;
		encoder : xmlCharEncodingHandlerPtr; { I18N conversions to UTF-8  }
		buffer : xmlBufferPtr;          { Local buffer encoded in UTF-8  }
		raw : xmlBufferPtr;             { if encoder != NULL buffer for raw input  }
	end;

	{
		Those are the functions and datatypes for the library output
		I/O structures.
	}
	xmlOutputMatchCallback = function (const filename: PChar): integer;
	xmlOutputOpenCallback = function (filename:Pchar):pointer;cdecl;
	xmlOutputWriteCallback = function(context: pointer; buffer: PChar; len: integer): integer; cdecl;
	xmlOutputCloseCallback = procedure (context: pointer); cdecl;

	xmlOutputBufferPtr = ^xmlOutputBuffer;
	xmlOutputBuffer = record
		context : pointer;
		writecallback : xmlOutputWriteCallback;
		closecallback : xmlOutputCloseCallback;
		encoder : xmlCharEncodingHandlerPtr; { I18N conversions to UTF-8  }
		buffer : xmlBufferPtr;          { Local buffer encoded in UTF-8 or ISOLatin  }
		conv : xmlBufferPtr;            { if encoder != NULL buffer for output  }
		written : longint;              { total number of byte written  }
	end;

{
	Interfaces for input
}
procedure xmlRegisterDefaultInputCallbacks;cdecl;external LIBXML2_SO;
function  xmlAllocParserInputBuffer(enc:xmlCharEncoding):xmlParserInputBufferPtr;cdecl;external LIBXML2_SO;
function  xmlParserInputBufferCreateFilename(URI:Pchar; enc:xmlCharEncoding):xmlParserInputBufferPtr;cdecl;external LIBXML2_SO;

function  xmlParserInputBufferCreateFile(var file_:TextFile; enc:xmlCharEncoding):xmlParserInputBufferPtr;cdecl;external LIBXML2_SO;
function  xmlParserInputBufferCreateFd(fd:longint; enc:xmlCharEncoding):xmlParserInputBufferPtr;cdecl;external LIBXML2_SO;
function  xmlParserInputBufferCreateMem(mem:Pchar; size:longint; enc:xmlCharEncoding):xmlParserInputBufferPtr;cdecl;external LIBXML2_SO;
function  xmlParserInputBufferCreateIO(ioread:xmlInputReadCallback; ioclose:xmlInputCloseCallback; ioctx: pointer; enc:xmlCharEncoding):xmlParserInputBufferPtr;cdecl;external LIBXML2_SO;
function  xmlParserInputBufferRead(aIn:xmlParserInputBufferPtr; len:longint):longint;cdecl;external LIBXML2_SO;
function  xmlParserInputBufferGrow(aIn:xmlParserInputBufferPtr; len:longint):longint;cdecl;external LIBXML2_SO;
function  xmlParserInputBufferPush(aIn:xmlParserInputBufferPtr; len:longint; buf:Pchar):longint;cdecl;external LIBXML2_SO;
procedure xmlFreeParserInputBuffer(aIn:xmlParserInputBufferPtr);cdecl;external LIBXML2_SO;
function  xmlParserGetDirectory(filename:Pchar):Pchar;cdecl;external LIBXML2_SO;
function  xmlRegisterInputCallbacks(matchFunc:xmlInputMatchCallback; openFunc:xmlInputOpenCallback; readFunc:xmlInputReadCallback; closeFunc:xmlInputCloseCallback):longint;cdecl;external LIBXML2_SO;

{
	Interfaces for output
}
procedure xmlRegisterDefaultOutputCallbacks;cdecl;external LIBXML2_SO;
function  xmlAllocOutputBuffer(encoder:xmlCharEncodingHandlerPtr):xmlOutputBufferPtr;cdecl;external LIBXML2_SO;
function  xmlOutputBufferCreateFilename(URI:Pchar; encoder:xmlCharEncodingHandlerPtr; compression:longint):xmlOutputBufferPtr;cdecl;external LIBXML2_SO;
function  xmlOutputBufferCreateFile(var file_:TextFile; encoder:xmlCharEncodingHandlerPtr):xmlOutputBufferPtr;cdecl;external LIBXML2_SO;
function  xmlOutputBufferCreateFd(fd:longint; encoder:xmlCharEncodingHandlerPtr):xmlOutputBufferPtr;cdecl;external LIBXML2_SO;
function  xmlOutputBufferCreateIO(iowrite:xmlOutputWriteCallback; ioclose:xmlOutputCloseCallback; ioctx:pointer; encoder:xmlCharEncodingHandlerPtr):xmlOutputBufferPtr;cdecl;external LIBXML2_SO;
function  xmlOutputBufferWrite(out:xmlOutputBufferPtr; len:longint; buf:Pchar):longint;cdecl;external LIBXML2_SO;
function  xmlOutputBufferWriteString(out:xmlOutputBufferPtr; str:Pchar):longint;cdecl;external LIBXML2_SO;
function  xmlOutputBufferFlush(out:xmlOutputBufferPtr):longint;cdecl;external LIBXML2_SO;
function  xmlOutputBufferClose(out:xmlOutputBufferPtr):longint;cdecl;external LIBXML2_SO;
function  xmlRegisterOutputCallbacks(matchFunc:xmlOutputMatchCallback; openFunc:xmlOutputOpenCallback; writeFunc:xmlOutputWriteCallback; closeFunc:xmlOutputCloseCallback):longint;cdecl;external LIBXML2_SO;

{
	This save function are part of tree.h and HTMLtree.h actually
}
function  xmlSaveFileTo(buf:xmlOutputBufferPtr; cur:xmlDocPtr; encoding:Pchar):longint;cdecl;external LIBXML2_SO;
function  xmlSaveFormatFileTo(buf:xmlOutputBufferPtr; cur:xmlDocPtr; encoding:Pchar; format:longint):longint;cdecl;external LIBXML2_SO;
procedure xmlNodeDumpOutput(buf:xmlOutputBufferPtr; doc:xmlDocPtr; cur:xmlNodePtr; level:longint; format:longint; encoding:Pchar);cdecl;external LIBXML2_SO;
procedure htmlDocContentDumpOutput(buf:xmlOutputBufferPtr; cur:xmlDocPtr; encoding:Pchar);cdecl;external LIBXML2_SO;

