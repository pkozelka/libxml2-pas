// CVS-SIGN: [1.18] catalog.h
{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}
(**
 * catalog.h: interfaces of the Catalog handling system
 *
 * Reference:  SGML Open Technical Resolution TR9401:1997.
 *             http://www.jclark.com/sp/catalog.htm
 *
 *             XML Catalogs Working Draft 12 Jun 2001
 *             http://www.oasis-open.org/committees/entity/spec-2001-06-12.html
 *
 * See Copyright for the status of this software.
 *
 * daniel@veillard.com
 *)

const
  (**
   * XML_CATALOGS_NAMESPACE:
   *
   * The namespace for the XML Catalogs elements
   *)
	XML_CATALOGS_NAMESPACE = 'urn:oasis:names:tc:entity:xmlns:xml:catalog';
  (**
   * XML_CATALOG_PI:
   *
   * the specific XML Catalog Processing Instuction name
   *)
	XML_CATALOG_PI = 'oasis-xml-catalog';

  (*
   * The API is voluntarily limited to general cataloging
   *)
type
	xmlCatalogPrefer = longint;
const
	XML_CATA_PREFER_NONE   = 0;
	XML_CATA_PREFER_PUBLIC = 1;
	XML_CATA_PREFER_SYSTEM = 2;


type
	xmlCatalogAllow =  Longint;
const
	XML_CATA_ALLOW_NONE     = 0;
	XML_CATA_ALLOW_GLOBAL   = 1;
	XML_CATA_ALLOW_DOCUMENT = 2;
	XML_CATA_ALLOW_ALL      = 3;

type
	xmlCatalog = pointer;
	xmlCatalogPtr = ^xmlCatalog;

(*
 * Operations on a given catalog
 *)
function  xmlNewCatalog(sgml:longint):xmlCatalogPtr;cdecl;external LIBXML2_SO;
function  xmlLoadACatalog(filename:Pchar):xmlCatalogPtr;cdecl;external LIBXML2_SO;
function  xmlLoadSGMLSuperCatalog(filename:Pchar):xmlCatalogPtr;cdecl;external LIBXML2_SO;
function  xmlConvertSGMLCatalog(catal:xmlCatalogPtr):longint;cdecl;external LIBXML2_SO;
function  xmlACatalogAdd(catal:xmlCatalogPtr; _type:PxmlChar; orig:PxmlChar; replace:PxmlChar):longint;cdecl;external LIBXML2_SO;
function  xmlACatalogRemove(catal:xmlCatalogPtr; value:PxmlChar):longint;cdecl;external LIBXML2_SO;
function  xmlACatalogResolve(catal:xmlCatalogPtr; pubID:PxmlChar; sysID:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlACatalogResolveSystem(catal:xmlCatalogPtr; sysID:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlACatalogResolvePublic(catal:xmlCatalogPtr; pubID:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlACatalogResolveURI(catal:xmlCatalogPtr; URI:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
procedure xmlACatalogDump(catal:xmlCatalogPtr; var outfile:TextFile);cdecl;external LIBXML2_SO;
procedure xmlFreeCatalog(catal:xmlCatalogPtr);cdecl;external LIBXML2_SO;
function  xmlCatalogIsEmpty(catal:xmlCatalogPtr):longint;cdecl;external LIBXML2_SO;

(*
 * Global operations
 *)
procedure xmlInitializeCatalog;cdecl;external LIBXML2_SO;
function  xmlLoadCatalog(filename:Pchar):longint;cdecl;external LIBXML2_SO;
procedure xmlLoadCatalogs(paths:Pchar);cdecl;external LIBXML2_SO;
procedure xmlCatalogCleanup;cdecl;external LIBXML2_SO;
procedure xmlCatalogDump(var outfile:TextFile);cdecl;external LIBXML2_SO;
function  xmlCatalogResolve(pubID:PxmlChar; sysID:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlCatalogResolveSystem(sysID:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlCatalogResolvePublic(pubID:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlCatalogResolveURI(URI:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlCatalogAdd(_type:PxmlChar; orig:PxmlChar; replace:PxmlChar):longint;cdecl;external LIBXML2_SO;
function  xmlCatalogRemove(value:PxmlChar):longint;cdecl;external LIBXML2_SO;
function  xmlParseCatalogFile(filename:Pchar):xmlDocPtr;cdecl;external LIBXML2_SO;
function  xmlCatalogConvert:longint;cdecl;external LIBXML2_SO;

(*
 * Strictly minimal interfaces for per-document catalogs used
 * by the parser.
 *)
procedure xmlCatalogFreeLocal(catalogs:pointer);cdecl;external LIBXML2_SO;
function  xmlCatalogAddLocal(catalogs:pointer; URL:PxmlChar):pointer;cdecl;external LIBXML2_SO;
function  xmlCatalogLocalResolve(catalogs:pointer; pubID:PxmlChar; sysID:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlCatalogLocalResolveURI(catalogs:pointer; URI:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;

(*
 * Preference settings
 *)
function  xmlCatalogSetDebug(level:longint):longint;cdecl;external LIBXML2_SO;
function  xmlCatalogSetDefaultPrefer(prefer:xmlCatalogPrefer):xmlCatalogPrefer;cdecl;external LIBXML2_SO;
procedure xmlCatalogSetDefaults(allow:xmlCatalogAllow);cdecl;external LIBXML2_SO;
function  xmlCatalogGetDefaults:xmlCatalogAllow;cdecl;external LIBXML2_SO;

(* DEPRECATED interfaces *)
function  xmlCatalogGetSystem(sysID:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO; {$ifdef VER140} deprecated; {$endif}
function  xmlCatalogGetPublic(pubID:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO; {$ifdef VER140} deprecated; {$endif}

