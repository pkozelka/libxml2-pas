{
   tree.h : describes the structures found in an tree resulting
            from an XML parsing.
  
   See Copyright for the status of this software.
  
   daniel@veillard.com
  
   14 Nov 2000 ht - added redefinition of xmlBufferWriteChar for VMS
  
}

{
 	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}

type
	xmlElementType =  Longint;
const
	{
		The different element types carried by an XML tree

		NOTE: This is synchronized with DOM Level1 values
				 See http://www.w3.org/TR/REC-DOM-Level-1/

		Actually this had diverged a bit, and now XML_DOCUMENT_TYPE_NODE should
		be deprecated to use an XML_DTD_NODE.
	}
	XML_ELEMENT_NODE = 1;
	XML_ATTRIBUTE_NODE = 2;
	XML_TEXT_NODE = 3;
	XML_CDATA_SECTION_NODE = 4;
	XML_ENTITY_REF_NODE = 5;
	XML_ENTITY_NODE = 6;
	XML_PI_NODE = 7;
	XML_COMMENT_NODE = 8;
	XML_DOCUMENT_NODE = 9;
	XML_DOCUMENT_TYPE_NODE = 10;
	XML_DOCUMENT_FRAG_NODE = 11;
	XML_NOTATION_NODE = 12;
	XML_HTML_DOCUMENT_NODE = 13;
	XML_DTD_NODE = 14;
	XML_ELEMENT_DECL = 15;
	XML_ATTRIBUTE_DECL = 16;
	XML_ENTITY_DECL = 17;
	XML_NAMESPACE_DECL = 18;
	XML_XINCLUDE_START = 19;
	XML_XINCLUDE_END = 20;
{$ifdef LIBXML_DOCB_ENABLED}
	XML_DOCB_DOCUMENT_NODE = 21;
{$endif}

const
	XML_LOCAL_NAMESPACE = XML_NAMESPACE_DECL;

const
	XML_ELEMENT_CONTENT_PCDATA = 1;
	XML_ELEMENT_CONTENT_ELEMENT = 2;
	XML_ELEMENT_CONTENT_SEQ = 3;
	XML_ELEMENT_CONTENT_OR = 4;

const
	XML_ATTRIBUTE_CDATA = 1;
	XML_ATTRIBUTE_ID = 2;
	XML_ATTRIBUTE_IDREF = 3;
	XML_ATTRIBUTE_IDREFS = 4;
	XML_ATTRIBUTE_ENTITY = 5;
	XML_ATTRIBUTE_ENTITIES = 6;
	XML_ATTRIBUTE_NMTOKEN = 7;
	XML_ATTRIBUTE_NMTOKENS = 8;
	XML_ATTRIBUTE_ENUMERATION = 9;
	XML_ATTRIBUTE_NOTATION = 10;

const
	XML_ATTRIBUTE_NONE = 1;
	XML_ATTRIBUTE_REQUIRED = 2;
	XML_ATTRIBUTE_IMPLIED = 3;
	XML_ATTRIBUTE_FIXED = 4;

const
	XML_ELEMENT_CONTENT_ONCE = 1;
	XML_ELEMENT_CONTENT_OPT = 2;
	XML_ELEMENT_CONTENT_MULT = 3;
	XML_ELEMENT_CONTENT_PLUS = 4;

const
	XML_ELEMENT_TYPE_UNDEFINED = 0;
	XML_ELEMENT_TYPE_EMPTY = 1;
	XML_ELEMENT_TYPE_ANY = 2;
	XML_ELEMENT_TYPE_MIXED = 3;
	XML_ELEMENT_TYPE_ELEMENT = 4;

const
	XML_BUFFER_ALLOC_DOUBLEIT = 0;
	XML_BUFFER_ALLOC_EXACT = 1;
type
	xmlDocPtr = ^xmlDoc;
	xmlDtdPtr = ^xmlDtd;
	xmlNodePtr = ^xmlNode;

	xmlNodePtrArray = array of xmlNodePtr;
	PxmlNodePtr = ^xmlNodePtrArray;

	{
		xmlChar:

		This is a basic byte in an UTF-8 encoded string.
		It's unsigned allowing to pinpoint case where char   are assigned
		to xmlChar   (possibly making serialization back impossible).
	}
	xmlChar = char;
	PxmlChar = PChar;
	PPxmlChar = ^PxmlChar;

	{
		xmlNotation:
		a DTD Notation definition
	}
	xmlNotationPtr = ^xmlNotation;
	xmlNotation = record
		name : PxmlChar;                { Notation name  }
		PublicID : PxmlChar;            { Public identifier, if any  }
		SystemID : PxmlChar;            { System identifier, if any  }
	end;

	{
		xmlAttributeType:

		a DTD Attribute type definition
	}

	xmlAttributeType =  Longint;

	{
		xmlAttributeDefault:
		a DTD Attribute default definition
	}
	xmlAttributeDefault =  Longint;

	{
		xmlEnumeration:
		list structure used when there is an enumeration in DTDs
	}
	xmlEnumerationPtr = ^xmlEnumeration;
	xmlEnumeration = record
		next : xmlEnumerationPtr;       { next one  }
		name : PxmlChar;                { Enumeration name  }
	end;

	{
		xmlAttribute:
		an Attribute declaration in a DTD
	}
	xmlAttributePtr = ^xmlAttribute;
	xmlAttribute = record
{$ifndef XML_WITHOUT_CORBA}
		_private : pointer;             { for Corba, must be first !  }
{$endif}
		type_ : xmlElementType;         { XML_ATTRIBUTE_DECL, must be second !  }
		name : PxmlChar;                { Attribute name  }
		children : xmlNodePtr;          { NULL  }
		last : xmlNodePtr;              { NULL  }
		parent : xmlDtdPtr;             { -> DTD  }
		next : xmlNodePtr;              { next sibling link   }
		prev : xmlNodePtr;              { previous sibling link   }
		doc : xmlDocPtr;                { the containing document  }
		nexth : xmlAttributePtr;        { next in hash table  }
		atype : xmlAttributeType;       { The attribute type  }
		def : xmlAttributeDefault;      { the default  }
		defaultValue : PxmlChar;        { or the default value  }
		tree : xmlEnumerationPtr;       { or the enumeration tree if any  }
		prefix : PxmlChar;              { the namespace prefix if any  }
		elem : PxmlChar;                { Element holding the attribute  }
	end;

	{
		xmlElementContentType:

		Possible definitions of element content types
	}
	xmlElementContentType =  Longint;

	{
		xmlElementContentOccur:

		Possible definitions of element content occurences
	}
	xmlElementContentOccur =  Longint;

	{
		xmlElementContent:
		an XML Element content as stored after parsing an element definition
		in a DTD.
	}
	xmlElementContentPtr = ^xmlElementContent;
	xmlElementContent = record
		type_ : xmlElementContentType;  { PCDATA, ELEMENT, SEQ or OR  }
		ocur : xmlElementContentOccur;  { ONCE, OPT, MULT or PLUS  }
		name : PxmlChar;                { Element name  }
		c1 : xmlElementContentPtr;      { first child  }
		c2 : xmlElementContentPtr;      { second child  }
		parent : xmlElementContentPtr;  { parent  }
	end;

	{
		xmlElementTypeVal:

		the differnt possibility for an element content type
	}
	xmlElementTypeVal =  Longint;

	{
		xmlElement:

		an XML Element declaration from a DTD
	}
	xmlElementPtr = ^xmlElement;
	xmlElement = record
{$ifndef XML_WITHOUT_CORBA}
		_private : pointer;             { for Corba, must be first !  }
{$endif}
		type_ : xmlElementType;         { XML_ELEMENT_DECL, must be second !  }
		name : PxmlChar;                { Element name  }
		children : xmlNodePtr;          { NULL  }
		last : xmlNodePtr;              { NULL  }
		parent : xmlDtdPtr;             { -> DTD  }
		next : xmlNodePtr;              { next sibling link   }
		prev : xmlNodePtr;              { previous sibling link   }
		doc : xmlDocPtr;                { the containing document  }
		etype : xmlElementTypeVal;      { The type  }
		content : xmlElementContentPtr; { the allowed element content  }
		attributes : xmlAttributePtr;   { List of the declared attributes  }
		prefix : PxmlChar;              { the namespace prefix if any  }
	end;

	xmlNsType = xmlElementType;
	{
		xmlNs:

		An XML namespace.
		Note that prefix == NULL is valid, it defines the default namespace
		within the subtree (until overriden).

		XML_GLOBAL_NAMESPACE is now deprecated for good
		xmlNsType is unified with xmlElementType
	}
	xmlNsPtr = ^xmlNs;
	PxmlNsPtr = ^xmlNsPtr;
	xmlNs = record
		next : xmlNsPtr;                { next Ns link for this node   }
		nodetype : xmlNsType;           { global or local  }
		href : PxmlChar;                { URL for the namespace  }
		prefix : PxmlChar;              { prefix for the namespace  }
	end;

	{
		xmlDtd:

		An XML DtD, as defined by <!DOCTYPE ... There is actually one for
		the internal subset and for the external subset
	}
	xmlDtd = record
{$ifndef XML_WITHOUT_CORBA}
		_private : pointer;             { for Corba, must be first !  }
{$endif}
		type_ : xmlElementType;         { XML_DTD_NODE, must be second !  }
		name : PxmlChar;                { Name of the DTD  }
		children : xmlNodePtr;          { the value of the property link  }
		last : xmlNodePtr;              { last child link  }
		parent : xmlDocPtr;             { child->parent link  }
		next : xmlNodePtr;              { next sibling link   }
		prev : xmlNodePtr;              { previous sibling link   }
		doc : xmlDocPtr;                { the containing document  }
																		{ End of common part  }
		notations : pointer;          	{ Hash table for notations if any  }
		elements : pointer;           	{ Hash table for elements if any  }
		attributes : pointer;         	{ Hash table for attributes if any  }
		entities : pointer;           	{ Hash table for entities if any  }
		ExternalID : PxmlChar;        	{ External identifier for PUBLIC DTD  }
		SystemID : PxmlChar;          	{ URI for a SYSTEM or PUBLIC DTD  }
		pentities : pointer;          	{ Hash table for param entities if any  }
	end;

	{
		xmlAttr:

		A attribute on an XML node.
	}

	xmlAttrPtr = ^xmlAttr;
	xmlAttr = record
{$ifndef XML_WITHOUT_CORBA}
		_private : pointer;             { for Corba, must be first !  }
{$endif}
		type_ : xmlElementType;         { XML_ATTRIBUTE_NODE, must be second !  }
		name : PxmlChar;                { the name of the property  }
		children : xmlNodePtr;          { the value of the property  }
		last : xmlNodePtr;              { NULL  }
		parent : xmlNodePtr;            { child->parent link  }
		next : xmlAttrPtr;              { next sibling link   }
		prev : xmlAttrPtr;              { previous sibling link   }
		doc : xmlDocPtr;                { the containing document  }
		ns : xmlNsPtr;                  { pointer to the associated namespace  }
		atype : xmlAttributeType;       { the attribute type if validating  }
	end;

	{
		xmlID:

		An XML ID instance.
	}
	xmlIDPtr = ^xmlID;
	xmlID = record
		next : xmlIDPtr;              	{ next ID  }
		value : PxmlChar;               { The ID name  }
		attr : xmlAttrPtr;              { The attribut holding it  }
	end;

	{
		xmlRef:

		An XML IDREF instance.
	}
	xmlRefPtr = ^xmlRef;
	xmlRef = record
		next : xmlRefPtr;               { next Ref  }
		value : PxmlChar;               { The Ref name  }
		attr : xmlAttrPtr;              { The attribut holding it  }
	end;

	{
		xmlBufferAllocationScheme:

		A buffer allocation scheme can be defined to either match exactly the
		need or double it's allocated size each time it is found too small
	}

	xmlBufferAllocationScheme =  Longint;

	{
		xmlBuffer:

		A buffer structure
	}
	xmlBufferPtr = ^xmlBuffer;
	xmlBuffer = record
		content : PxmlChar;             { The buffer content UTF8  }
		use : dword;                    { The buffer size used  }
		size: dword;                    { The buffer size  }
		alloc: xmlBufferAllocationScheme; { The realloc method  }
	end;

	{
		xmlNode:

		A node in an XML tree.
	}
	xmlNode = record
{$ifndef XML_WITHOUT_CORBA}
		_private : pointer;             { for Corba, must be first !  }
{$endif}
		type_ : xmlElementType;         { type number, must be second !  }
		name : PxmlChar;                { the name of the node, or the entity  }
		children : xmlNodePtr;          { parent->childs link  }
		last : xmlNodePtr;              { last child link  }
		parent : xmlNodePtr;            { child->parent link  }
		next : xmlNodePtr;              { next sibling link   }
		prev : xmlNodePtr;              { previous sibling link   }
		doc : xmlDocPtr;                { the containing document  }
		ns : xmlNsPtr;                  { pointer to the associated namespace  }
		{ End of common part  }
{$ifndef XML_USE_BUFFER_CONTENT    }
		content : PxmlChar;             { the content  }
{$else}
		content : xmlBufferPtr;         { the content in a buffer  }
{$endif}
		properties : xmlAttrPtr;        { properties list  }
		nsDef : xmlNsPtr;               { namespace definitions on this node  }
	end;

	{
		xmlDoc:

		An XML document.
	}
	xmlDoc = record
{$ifndef XML_WITHOUT_CORBA}
		_private : pointer;             { for Corba, must be first !  }
{$endif}
		type_ : xmlElementType;         { XML_DOCUMENT_NODE, must be second !  }
		name : Pchar;                 	{ name/filename/URI of the document  }
		children : xmlNodePtr;          { the document tree  }
		last : xmlNodePtr;              { last child link  }
		parent : xmlNodePtr;            { child->parent link  }
		next : xmlNodePtr;              { next sibling link   }
		prev : xmlNodePtr;              { previous sibling link   }
		doc : xmlDocPtr;                { autoreference to itself  }
		{ End of common part  }
		compression : longint;          { level of zlib compression  }
		standalone : longint;         	{ standalone document (no external refs)  }
		intSubset : xmlDtdPtr;          { the document internal subset  }
		extSubset : xmlDtdPtr;          { the document external subset  }
		oldNs : xmlNsPtr;               { Global namespace, the old way  }
		version : PxmlChar;             { the XML version string  }
		encoding : PxmlChar;            { external initial encoding, if any  }
		ids : pointer;                  { Hash table for ID attributes if any  }
		refs : pointer;                 { Hash table for IDREFs attributes if any  }
		URL : PxmlChar;                 { The URI for that document  }
		charset : longint;              { encoding of the in-memory content - actually an xmlCharEncoding  }
	end;

	{
		Variables.
	}
(* TODO: translate somehow
LIBXML_DLL_IMPORT extern xmlNsPtr baseDTD;
LIBXML_DLL_IMPORT extern int oldXMLWDcompatibility;/* maintain compatibility with old WD */
LIBXML_DLL_IMPORT extern int xmlIndentTreeOutput;  /* try to indent the tree dumps */
LIBXML_DLL_IMPORT extern xmlBufferAllocationScheme xmlBufferAllocScheme; /* alloc scheme to use */
LIBXML_DLL_IMPORT extern int xmlSaveNoEmptyTags; /* save empty tags as <empty></empty> */
LIBXML_DLL_IMPORT extern int xmlDefaultBufferSize; /* default buffer size */
*)

{
	Handling Buffers.
}
procedure xmlSetBufferAllocationScheme(scheme:xmlBufferAllocationScheme);cdecl;external LIBXML2_SO;
function  xmlGetBufferAllocationScheme:xmlBufferAllocationScheme;cdecl;external LIBXML2_SO;
function  xmlBufferCreate:xmlBufferPtr;cdecl;external LIBXML2_SO;
function  xmlBufferCreateSize(size:integer):xmlBufferPtr;cdecl;external LIBXML2_SO;
function  xmlBufferResize(buf:xmlBufferPtr; size:dword):longint;cdecl;external LIBXML2_SO;
procedure xmlBufferFree(buf:xmlBufferPtr);cdecl;external LIBXML2_SO;
function  xmlBufferDump(var file_:TextFile; buf:xmlBufferPtr):longint;cdecl;external LIBXML2_SO;
procedure xmlBufferAdd(buf:xmlBufferPtr; str:PxmlChar; len:longint);cdecl;external LIBXML2_SO;
procedure xmlBufferAddHead(buf:xmlBufferPtr; str:PxmlChar; len:longint);cdecl;external LIBXML2_SO;
procedure xmlBufferCat(buf:xmlBufferPtr; str:PxmlChar);cdecl;external LIBXML2_SO;
procedure xmlBufferCCat(buf:xmlBufferPtr; str:Pchar);cdecl;external LIBXML2_SO;
function  xmlBufferShrink(buf:xmlBufferPtr; len:dword):longint;cdecl;external LIBXML2_SO;
function  xmlBufferGrow(buf:xmlBufferPtr; len:dword):longint;cdecl;external LIBXML2_SO;
procedure xmlBufferEmpty(buf:xmlBufferPtr);cdecl;external LIBXML2_SO;
function  xmlBufferContent(buf:xmlBufferPtr):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlBufferUse(buf:xmlBufferPtr):longint;cdecl;external LIBXML2_SO;
procedure xmlBufferSetAllocationScheme(buf:xmlBufferPtr; scheme:xmlBufferAllocationScheme);cdecl;external LIBXML2_SO;
function  xmlBufferLength(buf:xmlBufferPtr):longint;cdecl;external LIBXML2_SO;

{
	Creating/freeing new structures
}
function  xmlCreateIntSubset(doc:xmlDocPtr; name:PxmlChar; ExternalID:PxmlChar; SystemID:PxmlChar):xmlDtdPtr;cdecl;external LIBXML2_SO;
function  xmlNewDtd(doc:xmlDocPtr; name:PxmlChar; ExternalID:PxmlChar; SystemID:PxmlChar):xmlDtdPtr;cdecl;external LIBXML2_SO;
function  xmlGetIntSubset(doc:xmlDocPtr):xmlDtdPtr;cdecl;external LIBXML2_SO;
procedure xmlFreeDtd(cur:xmlDtdPtr);cdecl;external LIBXML2_SO;
function  xmlNewGlobalNs(doc:xmlDocPtr; href:PxmlChar; prefix:PxmlChar):xmlNsPtr;cdecl;external LIBXML2_SO;
function  xmlNewNs(node:xmlNodePtr; href:PxmlChar; prefix:PxmlChar):xmlNsPtr;cdecl;external LIBXML2_SO;
procedure xmlFreeNs(cur:xmlNsPtr);cdecl;external LIBXML2_SO;
procedure xmlFreeNsList(cur:xmlNsPtr);cdecl;external LIBXML2_SO;
function  xmlNewDoc(version:PxmlChar):xmlDocPtr;cdecl;external LIBXML2_SO;
procedure xmlFreeDoc(cur:xmlDocPtr);cdecl;external LIBXML2_SO;
function  xmlNewDocProp(doc:xmlDocPtr; name:PxmlChar; value:PxmlChar):xmlAttrPtr;cdecl;external LIBXML2_SO;
function  xmlNewProp(node:xmlNodePtr; name:PxmlChar; value:PxmlChar):xmlAttrPtr;cdecl;external LIBXML2_SO;
function  xmlNewNsProp(node:xmlNodePtr; ns:xmlNsPtr; name:PxmlChar; value:PxmlChar):xmlAttrPtr;cdecl;external LIBXML2_SO;
procedure xmlFreePropList(cur:xmlAttrPtr);cdecl;external LIBXML2_SO;
procedure xmlFreeProp(cur:xmlAttrPtr);cdecl;external LIBXML2_SO;
function  xmlCopyProp(target:xmlNodePtr; cur:xmlAttrPtr):xmlAttrPtr;cdecl;external LIBXML2_SO;
function  xmlCopyPropList(target:xmlNodePtr; cur:xmlAttrPtr):xmlAttrPtr;cdecl;external LIBXML2_SO;
function  xmlCopyDtd(dtd:xmlDtdPtr):xmlDtdPtr;cdecl;external LIBXML2_SO;
function  xmlCopyDoc(doc:xmlDocPtr; recursive:longint):xmlDocPtr;cdecl;external LIBXML2_SO;

{
	Creating new nodes
}
function  xmlNewDocNode(doc:xmlDocPtr; ns:xmlNsPtr; name:PxmlChar; content:PxmlChar):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewDocRawNode(doc:xmlDocPtr; ns:xmlNsPtr; name:PxmlChar; content:PxmlChar):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewNode(ns:xmlNsPtr; name:PxmlChar):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewChild(parent:xmlNodePtr; ns:xmlNsPtr; name:PxmlChar; content:PxmlChar):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewTextChild(parent:xmlNodePtr; ns:xmlNsPtr; name:PxmlChar; content:PxmlChar):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewDocText(doc:xmlDocPtr; content:PxmlChar):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewText(content:PxmlChar):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewPI(name:PxmlChar; content:PxmlChar):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewDocTextLen(doc:xmlDocPtr; content:PxmlChar; len:longint):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewTextLen(content:PxmlChar; len:longint):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewDocComment(doc:xmlDocPtr; content:PxmlChar):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewComment(content:PxmlChar):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewCDataBlock(doc:xmlDocPtr; content:PxmlChar; len:longint):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewCharRef(doc:xmlDocPtr; name:PxmlChar):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewReference(doc:xmlDocPtr; name:PxmlChar):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlCopyNode(node:xmlNodePtr; recursive:longint):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlDocCopyNode(node:xmlNodePtr; doc:xmlDocPtr; recursive:longint):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlCopyNodeList(node:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNewDocFragment(doc:xmlDocPtr):xmlNodePtr;cdecl;external LIBXML2_SO;

{
	Navigating
}
function  xmlDocGetRootElement(doc:xmlDocPtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlGetLastChild(parent:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNodeIsText(node:xmlNodePtr):longint;cdecl;external LIBXML2_SO;
function  xmlIsBlankNode(node:xmlNodePtr):longint;cdecl;external LIBXML2_SO;

{
	Changing the structure
}
function  xmlDocSetRootElement(doc:xmlDocPtr; root:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
procedure xmlNodeSetName(cur:xmlNodePtr; name:PxmlChar);cdecl;external LIBXML2_SO;
function  xmlAddChild(parent:xmlNodePtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlAddChildList(parent:xmlNodePtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlReplaceNode(old:xmlNodePtr; cur:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlAddSibling(cur:xmlNodePtr; elem:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlAddPrevSibling(cur:xmlNodePtr; elem:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlAddNextSibling(cur:xmlNodePtr; elem:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
procedure xmlUnlinkNode(cur:xmlNodePtr);cdecl;external LIBXML2_SO;
function  xmlTextMerge(first:xmlNodePtr; second:xmlNodePtr):xmlNodePtr;cdecl;external LIBXML2_SO;
procedure xmlTextConcat(node:xmlNodePtr; content:PxmlChar; len:longint);cdecl;external LIBXML2_SO;
procedure xmlFreeNodeList(cur:xmlNodePtr);cdecl;external LIBXML2_SO;
procedure xmlFreeNode(cur:xmlNodePtr);cdecl;external LIBXML2_SO;
procedure xmlSetTreeDoc(tree:xmlNodePtr; doc:xmlDocPtr);cdecl;external LIBXML2_SO;
procedure xmlSetListDoc(list:xmlNodePtr; doc:xmlDocPtr);cdecl;external LIBXML2_SO;

{
	Namespaces
}
function  xmlSearchNs(doc:xmlDocPtr; node:xmlNodePtr; nameSpace:PxmlChar):xmlNsPtr;cdecl;external LIBXML2_SO;
function  xmlSearchNsByHref(doc:xmlDocPtr; node:xmlNodePtr; href:PxmlChar):xmlNsPtr;cdecl;external LIBXML2_SO;
function  xmlGetNsList(doc:xmlDocPtr; node:xmlNodePtr):PxmlNsPtr;cdecl;external LIBXML2_SO;
procedure xmlSetNs(node:xmlNodePtr; ns:xmlNsPtr);cdecl;external LIBXML2_SO;
function  xmlCopyNamespace(cur:xmlNsPtr):xmlNsPtr;cdecl;external LIBXML2_SO;
function  xmlCopyNamespaceList(cur:xmlNsPtr):xmlNsPtr;cdecl;external LIBXML2_SO;

{
	Changing the content.
}
function  xmlSetProp(node:xmlNodePtr; name:PxmlChar; value:PxmlChar):xmlAttrPtr;cdecl;external LIBXML2_SO;
function  xmlGetProp(node:xmlNodePtr; name:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlHasProp(node:xmlNodePtr; name:PxmlChar):xmlAttrPtr;cdecl;external LIBXML2_SO;
function  xmlHasNsProp(node:xmlNodePtr; name:PxmlChar; nameSpace:PxmlChar):xmlAttrPtr;cdecl;external LIBXML2_SO;
function  xmlSetNsProp(node:xmlNodePtr; ns:xmlNsPtr; name:PxmlChar; value:PxmlChar):xmlAttrPtr;cdecl;external LIBXML2_SO;
function  xmlGetNsProp(node:xmlNodePtr; name:PxmlChar; nameSpace:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlStringGetNodeList(doc:xmlDocPtr; value:PxmlChar):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlStringLenGetNodeList(doc:xmlDocPtr; value:PxmlChar; len:longint):xmlNodePtr;cdecl;external LIBXML2_SO;
function  xmlNodeListGetString(doc:xmlDocPtr; list:xmlNodePtr; ainLine:longint):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlNodeListGetRawString(doc:xmlDocPtr; list:xmlNodePtr; ainLine:longint):PxmlChar;cdecl;external LIBXML2_SO;
procedure xmlNodeSetContent(cur:xmlNodePtr; content:PxmlChar);cdecl;external LIBXML2_SO;
procedure xmlNodeSetContentLen(cur:xmlNodePtr; content:PxmlChar; len:longint);cdecl;external LIBXML2_SO;
procedure xmlNodeAddContent(cur:xmlNodePtr; content:PxmlChar);cdecl;external LIBXML2_SO;
procedure xmlNodeAddContentLen(cur:xmlNodePtr; content:PxmlChar; len:longint);cdecl;external LIBXML2_SO;
function  xmlNodeGetContent(cur:xmlNodePtr):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlNodeGetLang(cur:xmlNodePtr):PxmlChar;cdecl;external LIBXML2_SO;
procedure xmlNodeSetLang(cur:xmlNodePtr; lang:PxmlChar);cdecl;external LIBXML2_SO;
function  xmlNodeGetSpacePreserve(cur:xmlNodePtr):longint;cdecl;external LIBXML2_SO;
procedure xmlNodeSetSpacePreserve(cur:xmlNodePtr; val:longint);cdecl;external LIBXML2_SO;
function  xmlNodeGetBase(doc:xmlDocPtr; cur:xmlNodePtr):PxmlChar;cdecl;external LIBXML2_SO;
procedure xmlNodeSetBase(cur:xmlNodePtr; uri:PxmlChar);cdecl;external LIBXML2_SO;

{
	Removing content.
}
function  xmlRemoveProp(attr:xmlAttrPtr):longint;cdecl;external LIBXML2_SO;
function  xmlRemoveNode(node:xmlNodePtr):longint;cdecl;external LIBXML2_SO;

{ TODO  }

function  xmlUnsetProp(node:xmlNodePtr; name:PxmlChar):longint;cdecl;external LIBXML2_SO;
function  xmlUnsetNsProp(node:xmlNodePtr; ns:xmlNsPtr; name:PxmlChar):longint;cdecl;external LIBXML2_SO;

{
	Internal, don't use
}
{$ifdef VMS}
procedure xmlBufferWriteXmlCHAR(buf:xmlBufferPtr; aString:PxmlChar);cdecl;external LIBXML2_SO;
procedure xmlBufferWriteCHAR(buf:xmlBufferPtr; aString:PxmlChar);cdecl;external LIBXML2_SO;
{$endif}

procedure xmlBufferWriteChar(buf:xmlBufferPtr; aString:Pchar);cdecl;external LIBXML2_SO;
procedure xmlBufferWriteQuotedString(buf:xmlBufferPtr; aString:PxmlChar);cdecl;external LIBXML2_SO;

{
	Namespace handling
}
function  xmlReconciliateNs(doc:xmlDocPtr; tree:xmlNodePtr):longint;cdecl;external LIBXML2_SO;

{
	Saving
}
procedure xmlDocDumpFormatMemory(cur:xmlDocPtr; var mem:PxmlChar; size:Plongint; format:longint);cdecl;external LIBXML2_SO;
procedure xmlDocDumpMemory(cur:xmlDocPtr; var mem:PxmlChar; size:Plongint);cdecl;external LIBXML2_SO;
procedure xmlDocDumpMemoryEnc(out_doc:xmlDocPtr; var doc_txt_ptr:PxmlChar; doc_txt_len:Plongint; txt_encoding:Pchar);cdecl;external LIBXML2_SO;
procedure xmlDocDumpFormatMemoryEnc(out_doc:xmlDocPtr; var doc_txt_ptr:PxmlChar; doc_txt_len:Plongint; txt_encoding:Pchar; format:longint);cdecl;external LIBXML2_SO;
function  xmlDocDump(var f:TextFile; cur:xmlDocPtr):longint;cdecl;external LIBXML2_SO;
procedure xmlElemDump(var f:TextFile; doc:xmlDocPtr; cur:xmlNodePtr);cdecl;external LIBXML2_SO;
function  xmlSaveFile(filename:Pchar; cur:xmlDocPtr):longint;cdecl;external LIBXML2_SO;
function  xmlSaveFormatFile(filename:Pchar; cur:xmlDocPtr; format:longint):longint;cdecl;external LIBXML2_SO;
procedure xmlNodeDump(buf:xmlBufferPtr; doc:xmlDocPtr; cur:xmlNodePtr; level:longint; format:longint);cdecl;external LIBXML2_SO;

{ These are exported from xmlIO.h

int xmlSaveFileTo (xmlOutputBuffer  buf, xmlDocPtr cur, const char  encoding);
int xmlSaveFormatFileTo (xmlOutputBuffer  buf, xmlDocPtr cur, const char  encoding, int format);
}

function  xmlSaveFileEnc(filename:Pchar; cur:xmlDocPtr; encoding:Pchar):longint;cdecl;external LIBXML2_SO;

{
	Compression
}
function  xmlGetDocCompressMode(doc:xmlDocPtr):longint;cdecl;external LIBXML2_SO;
procedure xmlSetDocCompressMode(doc:xmlDocPtr; mode:longint);cdecl;external LIBXML2_SO;
function  xmlGetCompressMode:longint;cdecl;external LIBXML2_SO;
procedure xmlSetCompressMode(mode:longint);cdecl;external LIBXML2_SO;

