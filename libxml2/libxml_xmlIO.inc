// CVS-SIGN: [1.34] xmlIO.h
{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}

(*
 * xmlIO.h : interface for the I/O interfaces used by the parser
 *
 * See Copyright for the status of this software.
 *
 * daniel@veillard.com
 *
 *)

type
  (*
   * Those are the functions and datatypes for the parser input
   * I/O structures.
   *)

  (**
   * xmlInputMatchCallback:
   * @filename: the filename or URI
   *
   * Callback used in the I/O Input API to detect if the current handler
   * can provide input fonctionnalities for this resource.
   *
   * Returns 1 if yes and 0 if another Input module should be used
   *)
	xmlInputMatchCallback = function (filename: PChar):longint;cdecl;

  (**
   * xmlInputOpenCallback:
   * @filename: the filename or URI
   *
   * Callback used in the I/O Input API to open the resource
   *
   * Returns an Input context or NULL in case or error
   *)
	xmlInputOpenCallback  = function (filename:Pchar): pointer;cdecl;

  (**
   * xmlInputReadCallback:
   * @context:  an Input context
   * @buffer:  the buffer to store data read
   * @len:  the length of the buffer in bytes
   *
   * Callback used in the I/O Input API to read the resource
   *
   * Returns the number of bytes read or -1 in case of error
   *)
	xmlInputReadCallback  = function (context: pointer; buffer: PChar; len: integer):longint;cdecl;

  (**
   * xmlInputCloseCallback:
   * @context:  an Input context
   *
   * Callback used in the I/O Input API to close the resource
   *
   * Returns 0 or -1 in case of error
   *)
	xmlInputCloseCallback = function (context: pointer): longint;

	xmlParserInputBufferPtr = ^xmlParserInputBuffer;
	xmlParserInputBuffer = record
		context : pointer;
		readcallback : xmlInputReadCallback;
		closecallback : xmlInputCloseCallback;
		encoder : xmlCharEncodingHandlerPtr; { I18N conversions to UTF-8  }
		buffer : xmlBufferPtr;          { Local buffer encoded in UTF-8  }
		raw : xmlBufferPtr;             { if encoder != NULL buffer for raw input  }
	end;

  (*
   * Those are the functions and datatypes for the library output
   * I/O structures.
   *)

  (**
   * xmlOutputMatchCallback:
   * @filename: the filename or URI
   *
   * Callback used in the I/O Output API to detect if the current handler
   * can provide output fonctionnalities for this resource.
   *
   * Returns 1 if yes and 0 if another Output module should be used
   *)
	xmlOutputMatchCallback = function (const filename: PChar): integer;

  (**
   * xmlOutputOpenCallback:
   * @filename: the filename or URI
   *
   * Callback used in the I/O Output API to open the resource
   *
   * Returns an Output context or NULL in case or error
   *)
	xmlOutputOpenCallback  = function (filename:Pchar):pointer;cdecl;

  (**
   * xmlOutputWriteCallback:
   * @context:  an Output context
   * @buffer:  the buffer of data to write
   * @len:  the length of the buffer in bytes
   *
   * Callback used in the I/O Output API to write to the resource
   *
   * Returns the number of bytes written or -1 in case of error
   *)
	xmlOutputWriteCallback = function (context: pointer; buffer: PChar; len: longint): longint; cdecl;

  (**
   * xmlOutputCloseCallback:
   * @context:  an Output context
   *
   * Callback used in the I/O Output API to close the resource
   *
   * Returns 0 or -1 in case of error
   *)
	xmlOutputCloseCallback = function (context: pointer): longint; cdecl;


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

(*
 * Interfaces for input
 *)
procedure xmlCleanupInputCallbacks; cdecl;external LIBXML2_SO;
procedure xmlCleanupOutputCallbacks; cdecl;external LIBXML2_SO;
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

(*
 * Interfaces for output
 *)
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

{$ifdef LIBXML_HTTP_ENABLED}
(*  This function only exists if HTTP support built into the library  *)
function  xmlIOHTTPOpenW(post_uri: PChar; compression: longint): pointer; cdecl;external LIBXML2_SO;
procedure xmlRegisterHTTPPostCallbacks; cdecl;external LIBXML2_SO;
{$endif} // LIBXML_HTTP_ENABLED

(**
 * A predefined entity loader disabling network accesses
 *)
{ [pk] declared in libxml2.pas
function xmlNoNetExternalEntityLoader(URL: PChar; ID: PChar; ctxt: xmlParserCtxtPtr): xmlParserInputPtr; cdecl;external LIBXML2_SO;
}
