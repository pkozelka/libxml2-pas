// CVS-SIGN: [1.13] uri.h
{
  ------------------------------------------------------------------------------
  Translated into pascal with help of h2pas utility from the FreePascal project.
  Petr Kozelka <pkozelka@email.cz>
  ------------------------------------------------------------------------------
}
(**
 * uri.c: library of generic URI related routines
 *
 * Reference: RFC 2396
 *
 * See Copyright for the status of this software.
 *
 * daniel@veillard.com
 *)

type
  (**
   * xmlURI:
   *
   * A parsed URI reference. This is a struct containing the various fields
   * as described in RFC 2396 but separated for further processing
   *)
  xmlURIPtr = ^xmlURI;
  xmlURI = record
    scheme : Pchar;                 { the URI scheme  }
    opaque : Pchar;                 { opaque part  }
    authority : Pchar;              { the authority part  }
    server : Pchar;                 { the server part  }
    user : Pchar;                   { the user part  }
    port : longint;                 { the port number  }
    path : Pchar;                   { the path string  }
    query : Pchar;                  { the query string  }
    fragment : Pchar;               { the fragment identifier  }
    cleanup : longint;              { parsing potentially unclean URI }
  end;

(*
 * This function is in tree.h:
 * xmlChar *  xmlNodeGetBase (xmlDocPtr doc,
 *                            xmlNodePtr cur);
 *)

function  xmlCreateURI:xmlURIPtr;cdecl;external LIBXML2_SO;
function  xmlBuildURI(URI:PxmlChar; base:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlParseURI(str:PChar):xmlURIPtr;cdecl;external LIBXML2_SO;
function  xmlParseURIReference(uri:xmlURIPtr; str:Pchar):longint;cdecl;external LIBXML2_SO;
function  xmlSaveUri(uri:xmlURIPtr):PxmlChar;cdecl;external LIBXML2_SO;
procedure xmlPrintURI(var stream:TextFile; uri:xmlURIPtr);cdecl;external LIBXML2_SO;
function  xmlURIEscapeStr(str:PxmlChar; list:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlURIUnescapeString(str:Pchar; len:longint; target:Pchar):Pchar;cdecl;external LIBXML2_SO;
function  xmlNormalizeURIPath(path:Pchar):longint;cdecl;external LIBXML2_SO;
function  xmlURIEscape(str:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
procedure xmlFreeURI(uri:xmlURIPtr);cdecl;external LIBXML2_SO;

