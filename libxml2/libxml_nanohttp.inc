// CVS-SIGN: [1.12] nanohttp.h
{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}
(*
 * nanohttp.c: minimalist HTTP implementation to fetch external subsets.
 *
 * See Copyright for the status of this software.
 *
 * daniel@veillard.com
 *)
procedure xmlNanoHTTPInit;cdecl;external LIBXML2_SO;
procedure xmlNanoHTTPCleanup;cdecl;external LIBXML2_SO;
procedure xmlNanoHTTPScanProxy(URL:Pchar);cdecl;external LIBXML2_SO;
function  xmlNanoHTTPFetch(URL:Pchar; filename:Pchar; contentType:PPchar):longint;cdecl;external LIBXML2_SO;
function  xmlNanoHTTPMethod(URL:Pchar; method:Pchar; input:Pchar; contentType:PPchar; headers:Pchar; ilen: longint):pointer;cdecl;external LIBXML2_SO;
function  xmlNanoHTTPMethodRedir(URL:Pchar; method:Pchar; input:Pchar; contentType:PPchar; redir:PPchar; headers:Pchar; ilen: longint):pointer;cdecl;external LIBXML2_SO;
function  xmlNanoHTTPOpen(URL:Pchar; contentType:PPchar):pointer;cdecl;external LIBXML2_SO;
function  xmlNanoHTTPOpenRedir(URL:Pchar; contentType:PPchar; redir:PPchar):pointer;cdecl;external LIBXML2_SO;
function  xmlNanoHTTPReturnCode(ctx:pointer):longint;cdecl;external LIBXML2_SO;
function  xmlNanoHTTPAuthHeader(ctx:pointer):Pchar;cdecl;external LIBXML2_SO;
function  xmlNanoHTTPRead(ctx:pointer; dest:pointer; len:longint):longint;cdecl;external LIBXML2_SO;
function  xmlNanoHTTPSave(ctxt:pointer; filename:Pchar):longint;cdecl;external LIBXML2_SO;
procedure xmlNanoHTTPClose(ctx:pointer);cdecl;external LIBXML2_SO;
