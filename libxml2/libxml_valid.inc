{
	valid.h : interface to the DTD handling and the validity checking
  
	See Copyright for the status of this software.
  
	daniel@veillard.com
}

{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}

type
	{
		Validation state added for non-determinist content model
	}
	xmlValidStatePtr = pointer;

	{
		an xmlValidCtxt is used for error reporting when validating
	}
	xmlValidityErrorFunc = procedure (ctx: pointer; msg: PChar; var aVarArgList);
	xmlValidityWarningFunc = procedure (ctx: pointer; msg: PChar; var aVarArgList);

	xmlValidCtxtPtr = ^xmlValidCtxt;
	xmlValidCtxt = record
		userData : pointer;                 { user specific data block  }
		error : xmlValidityErrorFunc;       { the callback in case of errors  }
		warning : xmlValidityWarningFunc;   { the callback in case of warning  }

		{ Node analysis stack used when validating within entities  }
		node : xmlNodePtr;                  { Current parsed Node  }
		nodeNr : longint;                   { Depth of the parsing stack  }
		nodeMax : longint;                  { Max depth of the parsing stack  }
		nodeTab : ^xmlNodePtr;              { array of nodes  }
		finishDtd : longint;                { finished validating the Dtd ?  }
		doc : xmlDocPtr;                    { the document  }
		valid : longint;                    { temporary validity check result  }

		{ state state used for non-determinist content validation  }
		vstate : xmlValidStatePtr;          { current state  }
		vstateNr : longint;                 { Depth of the validation stack  }
		vstateMax : longint;                { Max depth of the validation stack  }
		vstateTab : xmlValidStatePtr;       { array of validation states  }
	end;

	{
	ALl notation declarations are stored in a table
	there is one table per DTD
	}
	xmlNotationTable = xmlHashTable;
	xmlNotationTablePtr = ^xmlNotationTable;

	{
	ALl element declarations are stored in a table
	there is one table per DTD
	}
	xmlElementTable = xmlHashTable;
	xmlElementTablePtr = ^xmlElementTable;

	{
	ALl attribute declarations are stored in a table
	there is one table per DTD
	}
	xmlAttributeTable = xmlHashTable;
	xmlAttributeTablePtr = ^xmlAttributeTable;

	{
	ALl IDs attributes are stored in a table
	there is one table per document
	}
	xmlIDTable = xmlHashTable;
	xmlIDTablePtr = ^xmlIDTable;

	{
	ALl Refs attributes are stored in a table
	there is one table per document
	}
	xmlRefTable = xmlHashTable;
	xmlRefTablePtr = ^xmlRefTable;

{ helper  }
function  xmlSplitQName2(name:PxmlChar; prefix:PPxmlChar):PxmlChar;cdecl;external LIBXML2_SO;

{ Notation  }
function  xmlAddNotationDecl(ctxt:xmlValidCtxtPtr; dtd:xmlDtdPtr; name:PxmlChar; PublicID:PxmlChar; SystemID:PxmlChar):xmlNotationPtr;cdecl;external LIBXML2_SO;
function  xmlCopyNotationTable(table:xmlNotationTablePtr):xmlNotationTablePtr;cdecl;external LIBXML2_SO;
procedure xmlFreeNotationTable(table:xmlNotationTablePtr);cdecl;external LIBXML2_SO;
procedure xmlDumpNotationDecl(buf:xmlBufferPtr; nota:xmlNotationPtr);cdecl;external LIBXML2_SO;
procedure xmlDumpNotationTable(buf:xmlBufferPtr; table:xmlNotationTablePtr);cdecl;external LIBXML2_SO;

{ Element Content  }
function  xmlNewElementContent(name:PxmlChar; aType:xmlElementContentType):xmlElementContentPtr;cdecl;external LIBXML2_SO;
function  xmlCopyElementContent(content:xmlElementContentPtr):xmlElementContentPtr;cdecl;external LIBXML2_SO;
procedure xmlFreeElementContent(cur:xmlElementContentPtr);cdecl;external LIBXML2_SO;
procedure xmlSprintfElementContent(buf:Pchar; content:xmlElementContentPtr; glob:longint);cdecl;external LIBXML2_SO;

{ Element  }
function  xmlAddElementDecl(ctxt:xmlValidCtxtPtr; dtd:xmlDtdPtr; name:PxmlChar; aType:xmlElementTypeVal; content:xmlElementContentPtr):xmlElementPtr;cdecl;external LIBXML2_SO;
function  xmlCopyElementTable(table:xmlElementTablePtr):xmlElementTablePtr;cdecl;external LIBXML2_SO;
procedure xmlFreeElementTable(table:xmlElementTablePtr);cdecl;external LIBXML2_SO;
procedure xmlDumpElementTable(buf:xmlBufferPtr; table:xmlElementTablePtr);cdecl;external LIBXML2_SO;
procedure xmlDumpElementDecl(buf:xmlBufferPtr; elem:xmlElementPtr);cdecl;external LIBXML2_SO;

{ Enumeration  }
function  xmlCreateEnumeration(name:PxmlChar):xmlEnumerationPtr;cdecl;external LIBXML2_SO;
procedure xmlFreeEnumeration(cur:xmlEnumerationPtr);cdecl;external LIBXML2_SO;
function  xmlCopyEnumeration(cur:xmlEnumerationPtr):xmlEnumerationPtr;cdecl;external LIBXML2_SO;

{ Attribute  }
function  xmlAddAttributeDecl(ctxt:xmlValidCtxtPtr; dtd:xmlDtdPtr; elem:PxmlChar; name:PxmlChar; ns:PxmlChar; aType:xmlAttributeType; def:xmlAttributeDefault; defaultValue:PxmlChar; tree:xmlEnumerationPtr):xmlAttributePtr;cdecl;external LIBXML2_SO;
function  xmlCopyAttributeTable(table:xmlAttributeTablePtr):xmlAttributeTablePtr;cdecl;external LIBXML2_SO;
procedure xmlFreeAttributeTable(table:xmlAttributeTablePtr);cdecl;external LIBXML2_SO;
procedure xmlDumpAttributeTable(buf:xmlBufferPtr; table:xmlAttributeTablePtr);cdecl;external LIBXML2_SO;
procedure xmlDumpAttributeDecl(buf:xmlBufferPtr; attr:xmlAttributePtr);cdecl;external LIBXML2_SO;

{ IDs  }
function xmlAddID(ctxt:xmlValidCtxtPtr; doc:xmlDocPtr; value:PxmlChar; attr:xmlAttrPtr):xmlIDPtr;cdecl;external LIBXML2_SO;
function xmlCopyIDTable(table:xmlIDTablePtr):xmlIDTablePtr;cdecl;external LIBXML2_SO;
procedure xmlFreeIDTable(table:xmlIDTablePtr);cdecl;external LIBXML2_SO;

function xmlGetID(doc:xmlDocPtr; ID:PxmlChar):xmlAttrPtr;cdecl;external LIBXML2_SO;
function xmlIsID(doc:xmlDocPtr; elem:xmlNodePtr; attr:xmlAttrPtr):longint;cdecl;external LIBXML2_SO;
function xmlRemoveID(doc:xmlDocPtr; attr:xmlAttrPtr):longint;cdecl;external LIBXML2_SO;

{ IDREFs  }
function xmlAddRef(ctxt:xmlValidCtxtPtr; doc:xmlDocPtr; value:PxmlChar; attr:xmlAttrPtr):xmlRefPtr;cdecl;external LIBXML2_SO;
function xmlCopyRefTable(table:xmlRefTablePtr):xmlRefTablePtr;cdecl;external LIBXML2_SO;
procedure xmlFreeRefTable(table:xmlRefTablePtr);cdecl;external LIBXML2_SO;
function xmlIsRef(doc:xmlDocPtr; elem:xmlNodePtr; attr:xmlAttrPtr):longint;cdecl;external LIBXML2_SO;
function xmlRemoveRef(doc:xmlDocPtr; attr:xmlAttrPtr):longint;cdecl;external LIBXML2_SO;

function xmlGetRefs(doc:xmlDocPtr; ID:PxmlChar):xmlListPtr;cdecl;external LIBXML2_SO;

{
	The public function calls related to validity checking
}
function xmlValidateRoot(ctxt:xmlValidCtxtPtr; doc:xmlDocPtr):longint;cdecl;external LIBXML2_SO;
function xmlValidateElementDecl(ctxt:xmlValidCtxtPtr; doc:xmlDocPtr; elem:xmlElementPtr):longint;cdecl;external LIBXML2_SO;
function xmlValidNormalizeAttributeValue(doc:xmlDocPtr; elem:xmlNodePtr; name:PxmlChar; value:PxmlChar):PxmlChar;cdecl;external LIBXML2_SO;
function xmlValidateAttributeDecl(ctxt:xmlValidCtxtPtr; doc:xmlDocPtr; attr:xmlAttributePtr):longint;cdecl;external LIBXML2_SO;
function xmlValidateAttributeValue(aType:xmlAttributeType; value:PxmlChar):longint;cdecl;external LIBXML2_SO;
function xmlValidateNotationDecl(ctxt:xmlValidCtxtPtr; doc:xmlDocPtr; nota:xmlNotationPtr):longint;cdecl;external LIBXML2_SO;
function xmlValidateDtd(ctxt:xmlValidCtxtPtr; doc:xmlDocPtr; dtd:xmlDtdPtr):longint;cdecl;external LIBXML2_SO;
function xmlValidateDtdFinal(ctxt:xmlValidCtxtPtr; doc:xmlDocPtr):longint;cdecl;external LIBXML2_SO;
function xmlValidateDocument(ctxt:xmlValidCtxtPtr; doc:xmlDocPtr):longint;cdecl;external LIBXML2_SO;
function xmlValidateElement(ctxt:xmlValidCtxtPtr; doc:xmlDocPtr; elem:xmlNodePtr):longint;cdecl;external LIBXML2_SO;
function xmlValidateOneElement(ctxt:xmlValidCtxtPtr; doc:xmlDocPtr; elem:xmlNodePtr):longint;cdecl;external LIBXML2_SO;
function xmlValidateOneAttribute(ctxt:xmlValidCtxtPtr; doc:xmlDocPtr; elem:xmlNodePtr; attr:xmlAttrPtr; value:PxmlChar):longint;cdecl;external LIBXML2_SO;
function xmlValidateDocumentFinal(ctxt:xmlValidCtxtPtr; doc:xmlDocPtr):longint;cdecl;external LIBXML2_SO;
function xmlValidateNotationUse(ctxt:xmlValidCtxtPtr; doc:xmlDocPtr; notationName:PxmlChar):longint;cdecl;external LIBXML2_SO;
function xmlIsMixedElement(doc:xmlDocPtr; name:PxmlChar):longint;cdecl;external LIBXML2_SO;
function xmlGetDtdAttrDesc(dtd:xmlDtdPtr; elem:PxmlChar; name:PxmlChar):xmlAttributePtr;cdecl;external LIBXML2_SO;
function xmlGetDtdNotationDesc(dtd:xmlDtdPtr; name:PxmlChar):xmlNotationPtr;cdecl;external LIBXML2_SO;
function xmlGetDtdElementDesc(dtd:xmlDtdPtr; name:PxmlChar):xmlElementPtr;cdecl;external LIBXML2_SO;
function xmlValidGetValidElements(prev:xmlNodePtr; next:xmlNodePtr; list:PPxmlChar; max:longint):longint;cdecl;external LIBXML2_SO;
function xmlValidGetPotentialChildren(ctree:xmlElementContentPtr; list:PPxmlChar; len:Plongint; max:longint):longint;cdecl;external LIBXML2_SO;

