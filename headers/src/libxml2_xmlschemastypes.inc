// CVS-REV:gnome-xml/include/libxml/xmlschemastypes.h:1.5:
{
  ------------------------------------------------------------------------------
  Translated into pascal with help of h2pas utility from the FreePascal project.
  Petr Kozelka <pkozelka@email.cz>
  ------------------------------------------------------------------------------
}
(*
 * schemastypes.c : interface of the XML Schema Datatypes
 *             definition and validity checking
 *
 * See Copyright for the status of this software.
 *
 * Daniel Veillard <veillard@redhat.com>
 *)
procedure xmlSchemaInittypes; cdecl; external LIBXML2_SO;
procedure xmlSchemaCleanuptypes; cdecl; external LIBXML2_SO;
function xmlSchemaGetPredefinedtype(name: PxmlChar; ns: PxmlChar): xmlSchematypePtr; cdecl; external LIBXML2_SO;
function xmlSchemaValidatePredefinedtype(aType: xmlSchematypePtr; value: PxmlChar; val: PxmlSchemaValPtr): Longint; cdecl; external LIBXML2_SO;
function xmlSchemaValPredefTypeNode(_type: xmlSchemaTypePtr; value: PxmlChar; val: PxmlSchemaValPtr; node: xmlNodePtr): Longint; cdecl; external LIBXML2_SO;
function xmlSchemaValidateFacet(base: xmlSchematypePtr; facet: xmlSchemaFacetPtr; value: PxmlChar; val: xmlSchemaValPtr): Longint; cdecl; external LIBXML2_SO;
procedure xmlSchemaFreeValue(val: xmlSchemaValPtr); cdecl; external LIBXML2_SO;
function xmlSchemaNewFacet: xmlSchemaFacetPtr; cdecl; external LIBXML2_SO;
function xmlSchemaCheckFacet(facet: xmlSchemaFacetPtr; typeDecl: xmlSchemaTypePtr; ctxt: xmlSchemaParserCtxtPtr; name: PxmlChar): Longint; cdecl; external LIBXML2_SO;
procedure xmlSchemaFreeFacet(facet: xmlSchemaFacetPtr); cdecl; external LIBXML2_SO;
function xmlSchemaCompareValues(x,y: xmlSchemaValPtr): Longint; cdecl; external LIBXML2_SO;
