// CVS-SIGN: [1.9] nanoftp.h
{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}
(*
 * nanohttp.c: minimalist FTP implementation to fetch external subsets.
 *
 * See Copyright for the status of this software.
 *
 * daniel@veillard.com
 *)

type
  (**
   * ftpListCallback:
   * @userData:  user provided data for the callback
   * @filename:  the file name (including "->" when links are shown)
   * @attrib:  the attribute string
   * @owner:  the owner string
   * @group:  the group string
   * @size:  the file size
   * @links:  the link count
   * @year:  the year
   * @month:  the month
   * @day:  the day
   * @hour:  the hour
   * @minute:  the minute
   *
   * A callback for the xmlNanoFTPList command
   * Note that only one of year and day:minute are specified
   *)
	ftpListCallback = procedure (userData: pointer; filename, attrib, owner, group: PChar;
		size: Longint; links: longint; year: longint; month: byte; day, hour, minute: longint); cdecl;

  (**
   * ftpDataCallback:
   * @userData: the user provided context
   * @data: the data received
   * @len: its size in bytes
   *
   * A callback for the xmlNanoFTPGet command
   *)
	ftpDataCallback = procedure (userData: pointer; data: PChar; len: longint);

(*
 * Init
 *)
procedure xmlNanoFTPInit;cdecl;external LIBXML2_SO;
procedure xmlNanoFTPCleanup;cdecl;external LIBXML2_SO;

(*
 * Creating/freeing contexts
 *)
function  xmlNanoFTPNewCtxt(URL:Pchar):pointer;cdecl;external LIBXML2_SO;
procedure xmlNanoFTPFreeCtxt(ctx:pointer);cdecl;external LIBXML2_SO;
function  xmlNanoFTPConnectTo(server:Pchar; port:longint):pointer;cdecl;external LIBXML2_SO;

(*
 * Opening/closing session connections
 *)
function  xmlNanoFTPOpen(URL:Pchar):pointer;cdecl;external LIBXML2_SO;
function  xmlNanoFTPConnect(ctx:pointer):longint;cdecl;external LIBXML2_SO;
function  xmlNanoFTPClose(ctx:pointer):longint;cdecl;external LIBXML2_SO;
function  xmlNanoFTPQuit(ctx:pointer):longint;cdecl;external LIBXML2_SO;
procedure xmlNanoFTPScanProxy(URL:Pchar);cdecl;external LIBXML2_SO;
procedure xmlNanoFTPProxy(host:Pchar; port:longint; user:Pchar; passwd:Pchar; type_:longint);cdecl;external LIBXML2_SO;
function  xmlNanoFTPUpdateURL(ctx:pointer; URL:Pchar):longint;cdecl;external LIBXML2_SO;

(*
 * Rathern internal commands
 *)
function  xmlNanoFTPGetResponse(ctx:pointer):longint;cdecl;external LIBXML2_SO;
function  xmlNanoFTPCheckResponse(ctx:pointer):longint;cdecl;external LIBXML2_SO;

(*
 * CD/DIR/GET handlers
 *)
function  xmlNanoFTPCwd(ctx:pointer; directory:PChar):longint;cdecl;external LIBXML2_SO;
function  xmlNanoFTPGetConnection(ctx:pointer):longint;cdecl;external LIBXML2_SO;
function  xmlNanoFTPCloseConnection(ctx:pointer):longint;cdecl;external LIBXML2_SO;
function  xmlNanoFTPList(ctx:pointer; callback:ftpListCallback; userData:pointer; filename:Pchar):longint;cdecl;external LIBXML2_SO;
function  xmlNanoFTPGetSocket(ctx:pointer; filename:Pchar):longint;cdecl;external LIBXML2_SO;
function  xmlNanoFTPGet(ctx:pointer; callback:ftpDataCallback; userData:pointer; filename:Pchar):longint;cdecl;external LIBXML2_SO;
function  xmlNanoFTPRead(ctx:pointer; dest:pointer; len:longint):longint;cdecl;external LIBXML2_SO;

