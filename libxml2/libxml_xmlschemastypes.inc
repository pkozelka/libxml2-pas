// CVS-SIGN: [1.1] xmlschemastypes.h
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
function xmlSchemaValidateFacet(base: xmlSchematypePtr; facet: xmlSchemaFacetPtr; value: PxmlChar; val: xmlSchemaValPtr): Longint; cdecl; external LIBXML2_SO;
procedure xmlSchemaFreeValue(val: xmlSchemaValPtr); cdecl; external LIBXML2_SO;