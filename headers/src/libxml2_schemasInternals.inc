// CVS-REV:gnome-xml/include/libxml/schemasInternals.h:1.5:
{
  ------------------------------------------------------------------------------
  Translated into pascal with help of h2pas utility from the FreePascal project.
  Petr Kozelka <pkozelka@email.cz>
  ------------------------------------------------------------------------------
}
(*
 * schemasInternals.h: internal interfaces for the XML Schemas handling
 *                      and schema validity checking
 *
 * See Copyright for the status of this software.
 *
 * Daniel.Veillard@w3.org
 *)


(*
 * XML Schemas defines multiple type of types.
 *)
type
  xmlSchemaTypeType = (
    DUMMY__XML_SCHEMA_TYPE_0, // =0 // this is for D5 compatibility
    XML_SCHEMA_TYPE_BASIC,// = 1,
    XML_SCHEMA_TYPE_ANY,
    XML_SCHEMA_TYPE_FACET,
    XML_SCHEMA_TYPE_SIMPLE,
    XML_SCHEMA_TYPE_COMPLEX,
    XML_SCHEMA_TYPE_SEQUENCE,
    XML_SCHEMA_TYPE_CHOICE,
    XML_SCHEMA_TYPE_ALL,
    XML_SCHEMA_TYPE_SIMPLE_CONTENT,
    XML_SCHEMA_TYPE_COMPLEX_CONTENT,
    XML_SCHEMA_TYPE_UR,
    XML_SCHEMA_TYPE_RESTRICTION,
    XML_SCHEMA_TYPE_EXTENSION,
    XML_SCHEMA_TYPE_ELEMENT,
    XML_SCHEMA_TYPE_ATTRIBUTE,
    XML_SCHEMA_TYPE_ATTRIBUTEGROUP,
    XML_SCHEMA_TYPE_GROUP,
    XML_SCHEMA_TYPE_NOTATION,
    XML_SCHEMA_TYPE_LIST,
    XML_SCHEMA_TYPE_UNION,
    XML_SCHEMA_FACET_MININCLUSIVE = 1000,
    XML_SCHEMA_FACET_MINEXCLUSIVE,
    XML_SCHEMA_FACET_MAXINCLUSIVE,
    XML_SCHEMA_FACET_MAXEXCLUSIVE,
    XML_SCHEMA_FACET_TOTALDIGITS,
    XML_SCHEMA_FACET_FRACTIONDIGITS,
    XML_SCHEMA_FACET_PATTERN,
    XML_SCHEMA_FACET_ENUMERATION,
    XML_SCHEMA_FACET_WHITESPACE,
    XML_SCHEMA_FACET_LENGTH,
    XML_SCHEMA_FACET_MAXLENGTH,
    XML_SCHEMA_FACET_MINLENGTH
  );

  xmlSchemaContentType = (
    XML_SCHEMA_CONTENT_UNKNOWN = 0,
    XML_SCHEMA_CONTENT_EMPTY,
    XML_SCHEMA_CONTENT_ELEMENTS,
    XML_SCHEMA_CONTENT_MIXED,
    XML_SCHEMA_CONTENT_SIMPLE,
    XML_SCHEMA_CONTENT_MIXED_OR_ELEMENTS,
    XML_SCHEMA_CONTENT_BASIC,
    XML_SCHEMA_CONTENT_ANY
  );

{[pk] I moved many constants here, because of internal references in pointer forward declarations }
(*
 * An attribute definition.
 *)

const
  XML_SCHEMAS_ANYATTR_SKIP = 1;
  XML_SCHEMAS_ANYATTR_LAX = 2;
  XML_SCHEMAS_ANYATTR_STRICT = 3;

const
  XML_SCHEMAS_TYPE_MIXED = 1;//1 << 0

const
  XML_SCHEMAS_ELEM_NILLABLE	= 1; //1 << 0
  XML_SCHEMAS_ELEM_GLOBAL		= 2; //1 << 1
  XML_SCHEMAS_ELEM_DEFAULT	= 4; //1 << 2
  XML_SCHEMAS_ELEM_FIXED		= 8; //1 << 3
  XML_SCHEMAS_ELEM_ABSTRACT	=16; //1 << 4
  XML_SCHEMAS_ELEM_TOPLEVEL	=32; //1 << 5
  XML_SCHEMAS_ELEM_REF		  =64; //1 << 6

const
  XML_SCHEMAS_FACET_UNKNOWN  = 0;
  XML_SCHEMAS_FACET_PRESERVE = 1;
  XML_SCHEMAS_FACET_REPLACE  = 2;
  XML_SCHEMAS_FACET_COLLAPSE = 3;

const
  XML_SCHEMAS_QUALIF_ELEM = 1; //1 << 0
  XML_SCHEMAS_QUALIF_ATTR	= 2; //1 << 1

{}

type
  xmlSchemaVal = record end;
  xmlSchemaValPtr = ^xmlSchemaVal;
  PxmlSchemaValPtr = ^xmlSchemaValPtr;
  
  xmlSchemaType = record end;
  xmlSchemaTypePtr = ^xmlSchemaType;

  xmlSchemaFacetPtr = ^xmlSchemaFacet;

  (**
   * Annotation
   *)
  xmlSchemaAnnotPtr = ^xmlSchemaAnnot;
  xmlSchemaAnnot = record
    next: xmlSchemaAnnotpTR;
    content: xmlNodePtr;                         (* the annotation *)
  end;

  xmlSchemaAttributePtr = ^xmlSchemaAttribute;
  xmlSchemaAttribute = record
    _type: xmlSchemaTypeType;                    (* The kind of type *)
    next: xmlSchemaAttributePtr;                 (* the next attribute if in a group ... *)
    name: PxmlChar;
    id: PxmlChar;
    ref: PxmlChar;
    refNs: PxmlChar;
    typeName: PxmlChar;
    typeNs: PxmlChar;
    annot: xmlSchemaAnnotPtr;
    base: xmlSchemaTypePtr;
    occurs: Longint;
    defValue: PxmlChar;
    subtypes: xmlSchemaTypePtr;
  end;

  (**
   * An attribute group definition.
   *
   * xmlSchemaAttribute and xmlSchemaAttributeGroup start of structures
   * must be kept similar
   *)
  xmlSchemaAttributeGroupPtr = ^xmlSchemaAttributeGroup;
  xmlSchemaAttributeGroup = record
    _type: xmlSchemaTypeType;                    (* The kind of type *)
    next: xmlSchemaAttributePtr;                 (* the next attribute if in a group ... *)
    name: PxmlChar;
    id: PxmlChar;
    ref: PxmlChar;
    refNs: PxmlChar;
    annot: xmlSchemaAnnotPtr;
    attributes: xmlSchemaAttributePtr;
  end;

  (*
   * Schemas type definition.
   *)
  _xmlSchemaType = record
    _type: xmlSchemaTypeType;                    (* The kind of type *)
    next: xmlSchemaTypePtr;                      (* the next type if in a sequence ... *)
    name: PxmlChar;
    id: PxmlChar;
    ref: PxmlChar;
    refNs: PxmlChar;
    annot: xmlSchemaAnnotPtr;
    subtypes: xmlSchemaTypePtr;
    attributes: xmlSchemaAttributePtr;
    node: xmlNodePtr;
    minOccurs: Longint;
    maxOccurs: Longint;
    flags: Longint;
    contentType: xmlSchemaContentType;
    base: PxmlChar;
    baseNs: PxmlChar;
    baseType: xmlSchemaTypePtr;
    facets: xmlSchemaFacetPtr;
  end;

  (**
   * An element definition.
   *
   * xmlSchemaType, xmlSchemaFacet and xmlSchemaElement start of
   * structures must be kept similar
   *)
  xmlSchemaElementPtr = ^xmlSchemaElement;
  xmlSchemaElement = record
    _type: xmlSchemaTypeType;                   (* The kind of type *)
    next: ^_xmlSchemaType;                      (* the next type if in a sequence ... *)
    name: PxmlChar;
    id: PxmlChar;
    ref: PxmlChar;
    refNs: PxmlChar;
    annot: xmlSchemaAnnotPtr;
    subtypes: xmlSchemaTypePtr;
    attributes: xmlSchemaAttributePtr;
    node: xmlNodePtr;
    minOccurs: Longint;
    maxOccurs: Longint;
    flags: Longint;
    targetNamespace: PxmlChar;
    namedType: PxmlChar;
    namedTypeNs: PxmlChar;
    substGroup: PxmlChar;
    substGroupNs: PxmlChar;
    scope: PxmlChar;
    value: PxmlChar;
    refDecl: xmlSchemaElementPtr;
    contModel: xmlRegexpPtr;
    contentType: xmlSchemaContentType;
  end;

  (**
   * An facet definition.
   *
   *)
  xmlSchemaFacet = record
    _type: xmlSchemaTypeType;                   (* The kind of type *)
    next: xmlSchemaFacetPtr;                     (* the next type if in a sequence ... *)
    value: PxmlChar;
    id: PxmlChar;
    annot: xmlSchemaAnnotPtr;
    node: xmlNodePtr;
    fixed: Longint;
    whitespace: Longint;
    val: xmlSchemaValPtr;
    regexp: xmlRegexpPtr;
  end;

  (**
   * A notation definition.
   *)
  xmlSchemaNotationPtr = ^xmlSchemaNotation;
  xmlSchemaNotation = record
    _type: xmlSchemaTypeType;
    name: PxmlChar;                              (* The kind of type *)
    annot: xmlSchemaAnnotPtr;
    identifier: PxmlChar;
  end;

  (**
   * A Schemas definition
   *)
  _xmlSchema = record
    name: PxmlChar;                              (* schema name *)
    targetNamespace: PxmlChar;                   (* the target namespace *)
    version: PxmlChar;
    id: PxmlChar;
    doc: xmlDocPtr;
    annot: xmlSchemaAnnotPtr;
    flags: Longint;
    typeDecl: xmlHashTablePtr;
    attrDecl: xmlHashTablePtr;
    attrgrpDecl: xmlHashTablePtr;
    elemDecl: xmlHashTablePtr;
    notaDecl: xmlHashTablePtr;

    schemasImports: xmlHashTablePtr;

    _private: Pointer; (* unused by the library for users or bindings *)
  end;

procedure xmlSchemaFreeType(aType: xmlSchemaTypePtr); cdecl; external LIBXML2_SO;

