{
	uri.c: interfaces of the Catalog handling system

	Reference:  SGML Open Technical Resolution TR9401:1997.
						 http://www.jclark.com/sp/catalog.htm

						 XML Catalogs Working Draft 12 Jun 2001
						 http://www.oasis-open.org/committees/entity/spec-2001-06-12.html

	See Copyright for the status of this software.

	daniel@veillard.com
}

{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}

{
	XML_CATALOGS_NAMESPACE:

	The namespace for the XML Catalogs elements
}

const
	XML_CATALOGS_NAMESPACE = 'urn:oasis:names:tc:entity:xmlns:xml:catalog';

function  xmlLoadCatalog(URL:Pchar):longint;cdecl;external LIBXML2_SO;
procedure xmlLoadCatalogs(paths:Pchar);cdecl;external LIBXML2_SO;
procedure xmlCatalogCleanup;cdecl;external LIBXML2_SO;
procedure xmlCatalogDump(var out_:TextFile);cdecl;external LIBXML2_SO;
function  xmlCatalogGetSystem(sysID:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlCatalogGetPublic(pubID:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;

