// CVS-SIGN: [1.0] xmlschemastypes.h
(*
 * schemastypes.c : interface of the XML Schema Datatypes
 *             definition and validity checking
 *
 * See Copyright for the status of this software.
 *
 * Daniel Veillard <veillard@redhat.com>
 *)
procedure xmlSchemaInitTypes;cdecl;external;
procedure xmlSchemaCleanupTypes;cdecl;external;
function xmlSchemaGetPredefinedType(name:PxmlChar; ns:PxmlChar):xmlSchemaTypePtr;cdecl;external;
function xmlSchemaValidatePredefinedType(_type:xmlSchemaTypePtr; value:PxmlChar; val:PxmlSchemaValPtr):longint;cdecl;external;
function xmlSchemaValidateFacet(base:xmlSchemaTypePtr; facet:xmlSchemaFacetPtr; value:PxmlChar; val:xmlSchemaValPtr):longint;cdecl;external;
procedure xmlSchemaFreeValue(val:xmlSchemaValPtr);cdecl;external;
