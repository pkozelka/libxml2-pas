// CVS-SIGN: [1.0] schemasInternals.h
(*
 * schemasInternals.h : internal interfaces for the XML Schemas handling
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
  xmlSchemaTypeType =  Longint;
const
  XML_SCHEMA_TYPE_BASIC = 1;
  XML_SCHEMA_TYPE_ANY = 2;
  XML_SCHEMA_TYPE_FACET = 3;
  XML_SCHEMA_TYPE_SIMPLE = 4;
  XML_SCHEMA_TYPE_COMPLEX = 5;
  XML_SCHEMA_TYPE_SEQUENCE = 6;
  XML_SCHEMA_TYPE_CHOICE = 7;
  XML_SCHEMA_TYPE_ALL = 8;
  XML_SCHEMA_TYPE_SIMPLE_CONTENT = 9;
  XML_SCHEMA_TYPE_COMPLEX_CONTENT = 10;
  XML_SCHEMA_TYPE_UR = 11;
  XML_SCHEMA_TYPE_RESTRICTION = 12;
  XML_SCHEMA_TYPE_EXTENSION = 13;
  XML_SCHEMA_TYPE_ELEMENT = 14;
  XML_SCHEMA_TYPE_ATTRIBUTE = 15;
  XML_SCHEMA_TYPE_GROUP = 16;
  XML_SCHEMA_TYPE_NOTATION = 17;
  XML_SCHEMA_TYPE_LIST = 18;
  XML_SCHEMA_TYPE_UNION = 19;
  XML_SCHEMA_FACET_MININCLUSIVE = 1000;
  XML_SCHEMA_FACET_MINEXCLUSIVE = 1001;
  XML_SCHEMA_FACET_MAXINCLUSIVE = 1002;
  XML_SCHEMA_FACET_MAXEXCLUSIVE = 1003;
  XML_SCHEMA_FACET_TOTALDIGITS = 1004;
  XML_SCHEMA_FACET_FRACTIONDIGITS = 1005;
  XML_SCHEMA_FACET_PATTERN = 1006;
  XML_SCHEMA_FACET_ENUMERATION = 1007;
  XML_SCHEMA_FACET_WHITESPACE = 1008;
  XML_SCHEMA_FACET_LENGTH = 1009;
  XML_SCHEMA_FACET_MAXLENGTH = 1010;
  XML_SCHEMA_FACET_MINLENGTH = 1011;

type
  xmlSchemaContentType =  Longint;
const
  XML_SCHEMA_CONTENT_UNKNOWN = 0;
  XML_SCHEMA_CONTENT_EMPTY = 1;
  XML_SCHEMA_CONTENT_ELEMENTS = 2;
  XML_SCHEMA_CONTENT_MIXED = 3;
  XML_SCHEMA_CONTENT_SIMPLE = 4;
  XML_SCHEMA_CONTENT_MIXED_OR_ELEMENTS = 5;
  XML_SCHEMA_CONTENT_BASIC = 6;

type
   _xmlSchemaVal = xmlSchemaVal;

   xmlSchemaValPtr = xmlSchemaVal;
   _xmlSchemaType = xmlSchemaType;

   xmlSchemaTypePtr = xmlSchemaType;
   _xmlSchemaFacet = xmlSchemaFacet;

   xmlSchemaFacetPtr = xmlSchemaFacet;
(**
 * Annotation
 *)
   _xmlSchemaAnnot = xmlSchemaAnnot;
   xmlSchemaAnnotPtr = xmlSchemaAnnot;
   _xmlSchemaAnnot = record
        next : ^_xmlSchemaAnnot;
        content : xmlNodePtr;                     (* the annotation *)
     end;

(*
 * An attribute definition.
 *)

const
   XML_SCHEMAS_ANYATTR_SKIP = 1;
   XML_SCHEMAS_ANYATTR_LAX = 2;
   XML_SCHEMAS_ANYATTR_STRICT = 3;
type
   _xmlSchemaAttribute = xmlSchemaAttribute;

   xmlSchemaAttributePtr = xmlSchemaAttribute;
   _xmlSchemaAttribute = record
        _type : xmlSchemaTypeType;                (* The kind of type *)
        next : ^_xmlSchemaAttribute;              (* the next attribute if in a group ... *)
        name : ^xmlChar;
        id : ^xmlChar;
        ref : ^xmlChar;
        refNs : ^xmlChar;
        typeName : ^xmlChar;
        typeNs : ^xmlChar;
        annot : xmlSchemaAnnotPtr;
        base : xmlSchemaTypePtr;
        occurs : longint;
        defValue : ^xmlChar;
        subtypes : xmlSchemaTypePtr;
     end;

(**
 * An attribute group definition.
 *
 * xmlSchemaAttribute and xmlSchemaAttributeGroup start of structures
 * must be kept similar
 *)
  _xmlSchemaAttributeGroup = xmlSchemaAttributeGroup;

  xmlSchemaAttributeGroupPtr = xmlSchemaAttributeGroup;
  _xmlSchemaAttributeGroup = record
    _type : xmlSchemaTypeType;                   (* The kind of type *)
    next : ^_xmlSchemaAttribute;                 (* the next attribute if in a group ... *)
    name : ^xmlChar;
    id : ^xmlChar;
    ref : ^xmlChar;
    refNs : ^xmlChar;
    annot : xmlSchemaAnnotPtr;
    attributes : xmlSchemaAttributePtr;
  end;

(*
 * Schemas type definition.
 *)
const
  XML_SCHEMAS_TYPE_MIXED = 1;//1 << 0
type
  _xmlSchemaType = record                        (* The kind of type *)
    _type : xmlSchemaTypeType;                   (* the next type if in a sequence ... *)
    next : ^_xmlSchemaType;
    name : ^xmlChar;
    id : ^xmlChar;
    ref : ^xmlChar;
    refNs : ^xmlChar;
    annot : xmlSchemaAnnotPtr;
    subtypes : xmlSchemaTypePtr;
    attributes : xmlSchemaAttributePtr;
    node : xmlNodePtr;
    minOccurs : longint;
    maxOccurs : longint;
    flags : longint;
    contentType : xmlSchemaContentType;
    base : ^xmlChar;
    baseNs : ^xmlChar;
    baseType : xmlSchemaTypePtr;
    facets : xmlSchemaFacetPtr;
  end;

(**
 * An element definition.
 *
 * xmlSchemaType, xmlSchemaFacet and xmlSchemaElement start of
 * structures must be kept similar
 *)
const
  XML_SCHEMAS_ELEM_NILLABLE	= 1; //1 << 0
  XML_SCHEMAS_ELEM_GLOBAL		= 2; //1 << 1
  XML_SCHEMAS_ELEM_DEFAULT	= 4; //1 << 2
  XML_SCHEMAS_ELEM_FIXED		= 8; //1 << 3
  XML_SCHEMAS_ELEM_ABSTRACT	=16; //1 << 4
  XML_SCHEMAS_ELEM_TOPLEVEL	=32; //1 << 5
  XML_SCHEMAS_ELEM_REF		  =64; //1 << 6
type
  _xmlSchemaElement = xmlSchemaElement;
  xmlSchemaElementPtr = xmlSchemaElement;
  _xmlSchemaElement = record
    _type : xmlSchemaTypeType;                   (* The kind of type *)
    next : ^_xmlSchemaType;                      (* the next type if in a sequence ... *)
    name : ^xmlChar;
    id : ^xmlChar;
    ref : ^xmlChar;
    refNs : ^xmlChar;
    annot : xmlSchemaAnnotPtr;
    subtypes : xmlSchemaTypePtr;
    attributes : xmlSchemaAttributePtr;
    node : xmlNodePtr;
    minOccurs : longint;
    maxOccurs : longint;
    flags : longint;
    targetNamespace : ^xmlChar;
    namedType : ^xmlChar;
    namedTypeNs : ^xmlChar;
    substGroup : ^xmlChar;
    substGroupNs : ^xmlChar;
    scope : ^xmlChar;
    value : ^xmlChar;
    refDecl : ^_xmlSchemaElement;
    contModel : xmlRegexpPtr;
  end;

(**
 * An facet definition.
 *
 *)
const
  XML_SCHEMAS_FACET_UNKNOWN = 0;
  XML_SCHEMAS_FACET_PRESERVE = 1;
  XML_SCHEMAS_FACET_REPLACE = 2;
  XML_SCHEMAS_FACET_COLLAPSE = 3;
type
  _xmlSchemaFacet = record
    _type : xmlSchemaTypeType;                   (* The kind of type *)
    next : ^_xmlSchemaFacet;                     (* the next type if in a sequence ... *)
    value : ^xmlChar;
    id : ^xmlChar;
    annot : xmlSchemaAnnotPtr;
    node : xmlNodePtr;
    fixed : longint;
    whitespace : longint;
    val : xmlSchemaValPtr;
    regexp : xmlRegexpPtr;
  end;

  (**
   * A notation definition.
   *)
  _xmlSchemaNotation = xmlSchemaNotation;

  xmlSchemaNotationPtr = xmlSchemaNotation;
  _xmlSchemaNotation = record
    _type : xmlSchemaTypeType;
    name : ^xmlChar;                             (* The kind of type *)
    annot : xmlSchemaAnnotPtr;
    identifier : ^xmlChar;
  end;

(**
 * A Schemas definition
 *)
const
  XML_SCHEMAS_QUALIF_ELEM = 1; //1 << 0
  XML_SCHEMAS_QUALIF_ATTR	= 2; //1 << 1

type
  _xmlSchema = record
    name : ^xmlChar;                             (* schema name *)
    targetNamespace : ^xmlChar;                  (* the target namespace *)
    version : ^xmlChar;
    id : ^xmlChar;
    doc : xmlDocPtr;
    annot : xmlSchemaAnnotPtr;
    flags : longint;
    typeDecl : xmlHashTablePtr;
    attrDecl : xmlHashTablePtr;
    attrgrpDecl : xmlHashTablePtr;
    elemDecl : xmlHashTablePtr;
    notaDecl : xmlHashTablePtr;
  end;


procedure xmlSchemaFreeType(_type:xmlSchemaTypePtr);cdecl;external;

