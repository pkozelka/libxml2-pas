unit libxmldom; //$Id: libxmldom.pas,v 1.40 2002-01-15 11:27:33 pkozelka Exp $

{
	 ------------------------------------------------------------------------------
	 This unit is an object-oriented wrapper for libxml2.
	 It implements the interfaces defined in dom2.pas.

	 Author:
	 Uwe Fechner <ufechner@4commerce.de>
	 .
	 Some Code by:
	 Martijn Brinkers
	 Petr Kozelka

		 Copyright:
		 4commerce technologies AG
		 Kamerbalken 10-14
		 22525 Hamburg, Germany

		Published under a double license:
		a) the GNU Library General Public License: 
			 http://www.gnu.org/copyleft/lgpl.html
		b) the Mozilla Public License:
			 http://www.mozilla.org/MPL/MPL-1.1.html
	 ------------------------------------------------------------------------------
}

// implemented methods:
// ====================
// see tests_libxml2.txt

// Partly supported by libxml2:
// IDOMPersist
//
// Not Supported by libxml2:
// IDOMNodeEx, IDOMParseError (extended interfaces, not part of dom-spec)
// Attr.ownerElement

interface

uses
	{$ifdef VER130} //Delphi 5
		unicode,
	{$endif}
	classes,
	xdom2,
	libxml2,
	sysutils;

const
	SLIBXML = 'LIBXML';  { Do not localize }

type

{ TGDOMInterface }
	TGDOMInterface = class(TInterfacedObject)
	public
		function SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HRESULT; override;
	end;

{ TGDOMImplementation }

	TGDOMImplementation = class(TGDOMInterface, IDOMImplementation)
	private
		protected
		 { IDOMImplementation }
		function hasFeature(const feature, version: DOMString): Boolean;
		function createDocumentType(const qualifiedName, publicId, systemId: DOMString): IDOMDocumentType;
		function createDocument(const namespaceURI, qualifiedName: DOMString; doctype: IDOMDocumentType): IDOMDocument;
	public
	end;

	{ IXMLDOMNodeRef }

	TGDOMNodeClass = class of TGDOMNode;

	TGDOMNode = class(TGDOMInterface, IDOMNode, ILibXml2Node, IDOMNodeSelect)
	private
		FGNode: xmlNodePtr;
	protected //IXMLDOMNodeRef
		function  LibXml2NodePtr: xmlNodePtr;
	protected //IDOMNode
		function  get_nodeName: DOMString;
		function  get_nodeValue: DOMString;
		procedure set_nodeValue(const value: DOMString);
		function  get_nodeType: DOMNodeType;
		function  get_parentNode: IDOMNode;
		function  get_childNodes: IDOMNodeList;
		function  get_firstChild: IDOMNode;
		function  get_lastChild: IDOMNode;
		function  get_previousSibling: IDOMNode;
		function  get_nextSibling: IDOMNode;
		function  get_attributes: IDOMNamedNodeMap;
		function  get_ownerDocument: IDOMDocument;
		function  get_namespaceURI: DOMString;
		function  get_prefix: DOMString;
		procedure set_Prefix(const prefix : DomString);
		function  get_localName: DOMString;
		function  insertBefore(const newChild, refChild: IDOMNode): IDOMNode;
		function  replaceChild(const newChild, oldChild: IDOMNode): IDOMNode;
		function  removeChild(const childNode: IDOMNode): IDOMNode;
		function  appendChild(const newChild: IDOMNode): IDOMNode;
		function  hasChildNodes: Boolean;
		function  hasAttributes : Boolean;
		function  cloneNode(deep: Boolean): IDOMNode;
		procedure normalize;
	protected //IDOMNodeSelect
		function  selectNode(const nodePath: WideString): IDOMNode;
		function  selectNodes(const nodePath: WideString): IDOMNodeList;
		procedure RegisterNS(const prefix,URI: DomString);
	protected
		//function supports(const feature, version: DOMString): Boolean;
		function  isSupported(const feature, version: DOMString): Boolean;
		function  IsReadOnly: boolean;
		function  IsAncestorOrSelf(newNode:xmlNodePtr): boolean; //new
	public
		constructor Create(aNode: xmlNodePtr);
		destructor Destroy; override;
		property GNode: xmlNodePtr read FGNode;
	end;

	TGDOMNodeList = class(TGDOMInterface, IDOMNodeList)
	private
		FParent: xmlNodePtr;
		FXPathObject: xmlXPathObjectPtr;
		FOwnerDocument: IDomDocument;
	protected
		{ IDOMNodeList }
		function get_item(index: Integer): IDOMNode;
		function get_length: Integer;
	public
		constructor Create(AParent: xmlNodePtr; AOwnerDocument: IDomDocument); overload;
		constructor Create(AXpathObject: xmlXPathObjectPtr;ADocument:IDOMDocument); overload;
		destructor destroy; override;
	end;

	TGDOMNamedNodeMap = class(TGDOMInterface, IDOMNamedNodeMap)
	// this class is used for attributes, entities and notations
	private
		FGNamedNodeMap: xmlNodePtr;
		FOwnerDocument: IDomDocument;
	protected
		{ IDOMNamedNodeMap }
		function get_GNamedNodeMap: xmlNodePtr;
		function get_item(index: Integer): IDOMNode;
		function get_length: Integer;
		function getNamedItem(const name: DOMString): IDOMNode;
		function setNamedItem(const newItem: IDOMNode): IDOMNode;
		function removeNamedItem(const name: DOMString): IDOMNode;
		function getNamedItemNS(const namespaceURI, localName: DOMString): IDOMNode;
		function setNamedItemNS(const newItem: IDOMNode): IDOMNode;
		function removeNamedItemNS(const namespaceURI, localName: DOMString): IDOMNode;
	public
		constructor Create(ANamedNodeMap: xmlNodePtr; AOwnerDocument: IDomDocument);
		destructor destroy; override;
		property GNamedNodeMap: xmlNodePtr read get_GNamedNodeMap;
	end;

	{ TGDOMAttr }

	TGDOMAttr = class(TGDOMNode, IDOMAttr)
	private
		//ns:
		function GetGAttribute: xmlAttrPtr;
	protected
		{ Property Get/Set }
		function get_name: DOMString;
		function get_specified: Boolean;
		function get_value: DOMString;
		procedure set_value(const attributeValue: DOMString);
		function get_ownerElement: IDOMElement;
		{ Properties }
		property name: DOMString read get_name;
		property specified: Boolean read get_specified;
		property value: DOMString read get_value write set_value;
		property ownerElement: IDOMElement read get_ownerElement;
	public
		property GAttribute: xmlAttrPtr read GetGAttribute;
		constructor Create(AAttribute: xmlAttrPtr);
		destructor destroy; override;
	end;

	TGDOMCharacterData = class(TGDOMNode, IDOMCharacterData)
	private
	protected
		{ IDOMCharacterData }
		function  get_data: DOMString;
		procedure set_data(const data: DOMString);
		function  get_length: Integer;
		function  substringData(offset, count: Integer): DOMString;
		procedure appendData(const data: DOMString);
		procedure insertData(offset: Integer; const data: DOMString);
		procedure deleteData(offset, count: Integer);
		procedure replaceData(offset, count: Integer; const data: DOMString);
	public
		constructor Create(ACharacterData: xmlNodePtr);
		destructor destroy; override;
	end;

	{ TGDOMElement }

	TGDOMElement = class(TGDOMNode, IDOMElement)
	private
	protected
		// IDOMElement
		function  get_tagName: DOMString;
		function  getAttribute(const name: DOMString): DOMString;
		procedure setAttribute(const name, value: DOMString);
		procedure removeAttribute(const name: DOMString);
		function  getAttributeNode(const name: DOMString): IDOMAttr;
		function  setAttributeNode(const newAttr: IDOMAttr): IDOMAttr;
		function  removeAttributeNode(const oldAttr: IDOMAttr):IDOMAttr;
		function  getElementsByTagName(const name: DOMString): IDOMNodeList;
		function  getAttributeNS(const namespaceURI, localName: DOMString): DOMString;
		procedure setAttributeNS(const namespaceURI, qualifiedName, value: DOMString);
		procedure removeAttributeNS(const namespaceURI, localName: DOMString);
		function  getAttributeNodeNS(const namespaceURI, localName: DOMString): IDOMAttr;
		function  setAttributeNodeNS(const newAttr: IDOMAttr): IDOMAttr;
		function  getElementsByTagNameNS(const namespaceURI, localName: DOMString): IDOMNodeList;
		function  hasAttribute(const name: DOMString): Boolean;
		function  hasAttributeNS(const namespaceURI, localName: DOMString): Boolean;
		procedure normalize;
	public
		constructor Create(AElement: xmlNodePtr);
		destructor destroy; override;
	end;

	{ TMSDOMText }

	TGDOMText = class(TGDOMCharacterData, IDOMText)
	protected
		function splitText(offset: Integer): IDOMText;
	end;

	{ TGDOMComment }

	TGDOMComment = class(TGDOMCharacterData, IDOMComment)
	end;

	{ TGDOMCDATASection }

	TGDOMCDATASection = class(TGDOMText, IDOMCDATASection)
	private
	public
	end;

	TGDOMDocumentType = class(TGDOMNode, IDOMDocumentType)
	private
		function GetGDocumentType: xmlDtdPtr;
	protected
		{ IDOMDocumentType }
		function get_name: DOMString;
		function get_entities: IDOMNamedNodeMap;
		function get_notations: IDOMNamedNodeMap;
		function get_publicId: DOMString;
		function get_systemId: DOMString;
		function get_internalSubset: DOMString;
	public
		property GDocumentType: xmlDtdPtr read GetGDocumentType;
		constructor Create(dtd:xmlDtdPtr);
		destructor Destroy; override;
	end;

	{ TGDOMNotation }
	TGDOMNotation = class(TGDOMNode, IDOMNotation)
	private
		function GetGNotation: xmlNotationPtr;
	protected
		{ IDOMNotation }
		function get_publicId: DOMString;
		function get_systemId: DOMString;
	public
		property GNotation: xmlNotationPtr read GetGNotation;
	end;

	TGDOMEntity = class(TGDOMNode, IDOMEntity)
	private
		function GetGEntity: xmlEntityPtr;
	protected
		{ IDOMEntity }
		function get_publicId: DOMString;
		function get_systemId: DOMString;
		function get_notationName: DOMString;
	public
		property GEntity: xmlEntityPtr read GetGEntity;
	end;

	TGDOMEntityReference = class(TGDOMNode, IDOMEntityReference)
	end;

	{ TGDOMProcessingInstruction }

	TGDOMProcessingInstruction = class(TGDOMNode, IDOMProcessingInstruction)
	private
	protected
		{ IDOMProcessingInstruction }
		function get_target: DOMString;
		function get_data: DOMString;
		procedure set_data(const value: DOMString);
	public
	end;

	(**
	 * managing the list of nodes and attributes, that must be freed manually}
	 *)
	IDomInternal = interface
		['{E9D505C3-D354-4D19-807A-8B964E954C09}']
		procedure removeAttr(attr: xmlAttrPtr);
		procedure appendAttr(attr: xmlAttrPtr);
		procedure appendNode(node: xmlNodePtr);
	end;

	TGDOMDocument = class(TGDOMNode, IDOMDocument, IDOMParseOptions, IDOMPersist, IDOMInternal)
	private
		FGDOMImpl: IDOMImplementation;
		FAsync: boolean;              //for compatibility, not really supported
		FpreserveWhiteSpace: boolean; //difficult to support
		FresolveExternals: boolean;   //difficult to support
		Fvalidate: boolean;           //check if default is ok
		FAttrList:TList;
		FNodeList:TList;
	protected
		// IDOMDocument
		function  get_doctype: IDOMDocumentType;
		function  get_domImplementation: IDOMImplementation;
		function  get_documentElement: IDOMElement;
		procedure set_documentElement(const IDOMElement: IDOMElement);
		function  createElement(const tagName: DOMString): IDOMElement;
		function  createDocumentFragment: IDomDocumentFragment;
		function  createTextNode(const data: DOMString): IDOMText;
		function  createComment(const data: DOMString): IDOMComment;
		function  createCDATASection(const data: DOMString): IDomCDataSection;
		function  createProcessingInstruction(const target, data: DOMString): IDomProcessingInstruction;
		function  createAttribute(const name: DOMString): IDOMAttr;
		function  createEntityReference(const name: DOMString): IDOMEntityReference;
		function  getElementsByTagName(const tagName: DOMString): IDOMNodeList;
		function  importNode(importedNode: IDOMNode; deep: Boolean): IDOMNode;
		function  createElementNS(const namespaceURI, qualifiedName: DOMString): IDOMElement;
		function  createAttributeNS(const namespaceURI, qualifiedName: DOMString): IDOMAttr;
		function  getElementsByTagNameNS(const namespaceURI, localName: DOMString): IDOMNodeList;
		function  getElementById(const elementId: DOMString): IDOMElement;
		// IDOMParseOptions
		function  get_async: Boolean;
		function  get_preserveWhiteSpace: Boolean;
		function  get_resolveExternals: Boolean;
		function  get_validate: Boolean;
		procedure set_async(Value: Boolean);
		procedure set_preserveWhiteSpace(Value: Boolean);
		procedure set_resolveExternals(Value: Boolean);
		procedure set_validate(Value: Boolean);
		// IDOMPersist
		function  get_xml: DOMString;
		function  asyncLoadState: Integer;
		function  load(source: OleVariant): Boolean;
		function  loadFromStream(const stream: TStream): Boolean;
		function  loadxml(const Value: DOMString): Boolean;
		procedure save(destination: OleVariant);
		procedure saveToStream(const stream: TStream);
		procedure set_OnAsyncLoad(const Sender: TObject; EventHandler: TAsyncEventHandler);
		// IDOMInternal
		procedure removeAttr(attr: xmlAttrPtr);
		procedure appendAttr(attr: xmlAttrPtr);
		procedure appendNode(node: xmlNodePtr);
		//
		function  requestDocPtr: xmlDocPtr;
		function  GetGDoc: xmlDocPtr;
		procedure SetGDoc(aNewDoc: xmlDocPtr);

		property  GDoc: xmlDocPtr read GetGDoc write SetGDoc;
	public
		constructor Create(GDOMImpl:IDOMImplementation; const namespaceURI, qualifiedName: DOMString; doctype: IDOMDocumentType); overload;
		constructor Create(GDOMImpl:IDOMImplementation); overload;
		constructor Create(GDOMImpl:IDOMImplementation; aUrl: DomString); overload;
		destructor Destroy; override;
	end;

	{ TMSDOMDocumentFragment }

	TGDOMDocumentFragment = class(TGDOMNode, IDOMDocumentFragment)
	end;

	TGDOMDocumentBuilderFactory = class(TInterfacedObject, IDomDocumentBuilderFactory)
	private
		FFreeThreading : Boolean;
	protected //IDomDocumentBuilderFactory
		function  NewDocumentBuilder : IDomDocumentBuilder;
		function  Get_VendorID : DomString;
	public
		constructor Create(AFreeThreading : Boolean);
	end;

	TGDOMDocumentBuilder = class(TInterfacedObject, IDomDocumentBuilder)
	private
		FFreeThreading : Boolean;
	public
		constructor Create(AFreeThreading : Boolean);
		destructor Destroy; override;
		function  Get_DomImplementation : IDomImplementation;
		function  Get_IsNamespaceAware : Boolean;
		function  Get_IsValidating : Boolean;
		function  Get_HasAsyncSupport : Boolean;
		function  Get_HasAbsoluteURLSupport : Boolean;
		function  newDocument : IDomDocument;
		function  parse(const xml : DomString) : IDomDocument;
		function  load(const url : DomString) : IDomDocument;
	end;

var
	//[pk] following should be in implementation, or nowhere at all:
	LIBXML_DOM: IDomDocumentBuilderFactory;

	doccount: integer=0;
	domcount: integer=0;
	nodecount: integer=0;
	elementcount: integer=0;

implementation

type
	GDomeException = Integer;

resourcestring
	SNodeExpected = 'Node cannot be null';
	SGDOMNotInstalled = 'GDOME2 is not installed';

function GetDOMObject(aNode: pointer): IUnknown;
const
	NodeClasses: array[XML_ELEMENT_NODE..XML_NOTATION_NODE] of TGDOMNodeClass = (
		TGDOMElement,
		TGDOMAttr,
		TGDOMText,
		TGDOMCDataSection,
		TGDOMEntityReference,
		TGDOMEntity,
		TGDOMProcessingInstruction,
		TGDOMComment,
		TGDOMDocument,
		TGDOMDocumentType,
		TGDOMDocumentFragment,
		TGDOMNotation
	);
var
	obj: TGDOMNode;
	node: xmlNodePtr;
	ok: boolean;
begin
	if aNode <> nil then begin
		node := xmlNodePtr(aNode);
		if (node._private=nil) then begin
			ok := (node.type_ >= Low(NodeClasses))
				and (node.type_ <= High(NodeClasses))
				and Assigned(NodeClasses[node.type_]);
			Assert(ok, Format('LibXml2 node type "%d" is not supported', [node.type_]));
//todo:      Assert(node.doc<>nil, 'Cannot wrap node not attached to any document');
			obj := NodeClasses[node.type_].Create(node);
			// notify the node that it has a wrapper already
			node._private := obj;
			//todo: handle flying nodes
		end else begin
			// wrapper is already created, use it
			obj := node._private;
		end;
	end else begin
		obj := nil;
	end;
	Result := obj;
end;

function ErrorString(err:integer):string;
begin
	case err of
		INDEX_SIZE_ERR: result:='INDEX_SIZE_ERR';
		DOMSTRING_SIZE_ERR: result:='DOMSTRING_SIZE_ERR';
		HIERARCHY_REQUEST_ERR: result:='HIERARCHY_REQUEST_ERR';
		WRONG_DOCUMENT_ERR: result:='WRONG_DOCUMENT_ERR';
		INVALID_CHARACTER_ERR: result:='INVALID_CHARACTER_ERR';
		NO_DATA_ALLOWED_ERR: result:='NO_DATA_ALLOWED_ERR';
		NO_MODIFICATION_ALLOWED_ERR: result:='NO_MODIFICATION_ALLOWED_ERR';
		NOT_FOUND_ERR: result:='NOT_FOUND_ERR';
		NOT_SUPPORTED_ERR: result:='NOT_SUPPORTED_ERR';
		INUSE_ATTRIBUTE_ERR: result:='INUSE_ATTRIBUTE_ERR';
		INVALID_STATE_ERR: result:='INVALID_STATE_ERR';
		SYNTAX_ERR: result:='SYNTAX_ERR';
		INVALID_MODIFICATION_ERR: result:='INVALID_MODIFICATION_ERR';
		NAMESPACE_ERR: result:='NAMESPACE_ERR';
		INVALID_ACCESS_ERR: result:='INVALID_ACCESS_ERR';
		20: result:='SaveXMLToMemory_ERR';
		21: result:='NotSupportedByLibxmldom_ERR';
		22: result:='SaveXMLToDisk_ERR';
		100: result:='LIBXML2_NULL_POINTER_ERR';
		101: result:='INVALID_NODE_SET_ERR';
		102: result:='PARSE_ERR';
	else
		result:='Unknown error no: '+inttostr(err);
	end;
end;

(**
 * Checks if the condition is true, and raises specified exception if not.
 *)
procedure DomAssert(aCondition: boolean; aErrorCode:integer; aMsg: widestring='');
begin
	if aErrorCode=0 then exit;
	if aCondition then exit;
	if aMsg='' then begin
		aMsg := ErrorString(aErrorCode);
	end;
	raise EDOMException.Create(aMsg);
end;

function GetGNode(const aNode: IDOMNode): xmlNodePtr;
begin
	DomAssert(Assigned(aNode), INVALID_ACCESS_ERR, SNodeExpected);
	Result := (aNode as ILibXml2Node).LibXml2NodePtr;
end;

function IsReadOnlyNode(node:xmlNodePtr): boolean;
begin
	if node<>nil
		then  case node.type_ of
			XML_NOTATION_NODE,XML_ENTITY_NODE,XML_ENTITY_DECL: result:=true;
		else
			result:=false;
		end
	else
		result:=false;
end;

function canAppendNode(priv,newPriv:xmlNodePtr): boolean;
//var
//	new_type: integer;
begin
//ToDo:
//Finish the translation from C
//	if newPriv<>nil
//		then new_type:=newPriv.type_;
	result:=true;
end;

function prefix(qualifiedName:string):string;
begin
	result := Copy(qualifiedName,1,Pos(':',qualifiedName)-1);
end;

function localName(qualifiedName:string):string;
var prefix: string;
begin
	prefix := Copy(qualifiedName,1,Pos(':',qualifiedName)-1);
	if length(prefix)>0
		then result:=(Copy(qualifiedName,Pos(':',qualifiedName)+1,
			length(qualifiedName)-length(prefix)-1))
		else result:=qualifiedName;
end;

(*
 *  TXDomDocumentBuilder
*)
constructor TGDOMDocumentBuilder.Create(AFreeThreading : Boolean);
begin
	inherited Create;
	FFreeThreading := AFreeThreading;
end;

destructor TGDOMDocumentBuilder.Destroy;
begin
	inherited Destroy;
end;

function TGDOMDocumentBuilder.Get_DomImplementation : IDomImplementation;
begin
	result:=TGDOMImplementation.Create;
end;

function TGDOMDocumentBuilder.Get_IsNamespaceAware : Boolean;
begin
	Result := True;
end;

function TGDOMDocumentBuilder.Get_IsValidating : Boolean;
begin
	Result := True;
end;

function TGDOMDocumentBuilder.Get_HasAbsoluteURLSupport : Boolean;
begin
	Result := false;
end;

function TGDOMDocumentBuilder.Get_HasAsyncSupport : Boolean;
begin
	Result := false;
end;

function TGDOMImplementation.hasFeature(const feature, version: DOMString): Boolean;
begin
	if (uppercase(feature) ='CORE') and (version = '2.0')
		then result:=true
		else result:=false;
end;

function TGDOMInterface.SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HRESULT;
begin
	result:=0; //todo
end;

function TGDOMImplementation.createDocumentType(const qualifiedName, publicId,
								systemId: DOMString): IDOMDocumentType;
var
	dtd:xmlDtdPtr;
	uqname, upubid, usysid: string;
begin
	uqname := UTF8Encode(qualifiedName);
	upubid := UTF8Encode(publicId);
	usysid := UTF8Encode(systemId);
	dtd:=xmlCreateIntSubSet(nil, PChar(uqname), PChar(upubid), PChar(usysid)); //todo: doc!
	if dtd<>nil
	then Result := TGDOMDocumentType.Create(dtd) as IDOMDocumentType
	else Result := nil;
end;

function TGDOMImplementation.createDocument(const namespaceURI, qualifiedName: DOMString;
			doctype: IDOMDocumentType): IDOMDocument;
begin
	Result := TGDOMDocument.Create(self,namespaceURI, qualifiedName,doctype) as IDOMDocument;
end;

// *************************************************************
// TGDomeNode Implementation
// *************************************************************

function TGDOMNode.LibXml2NodePtr: xmlNodePtr;
begin
	Result := FGNode;
end;

// IDOMNode
function TGDOMNode.get_nodeName: DOMString;
begin
	case FGNode.type_ of
	XML_HTML_DOCUMENT_NODE,
	XML_DOCB_DOCUMENT_NODE,
	XML_DOCUMENT_NODE:
		Result := '#document';
	XML_TEXT_NODE,
	XML_CDATA_SECTION_NODE,
	XML_COMMENT_NODE,
	XML_DOCUMENT_FRAG_NODE:
		Result := '#'+UTF8Decode(FGNode.name);
	else
		Result := UTF8Decode(FGNode.name);
		if (FGNode.ns<>nil) and (FGNode.ns.prefix<>nil) then begin
			Result := UTF8Decode(FGNode.ns.prefix)+':'+Result;
		end;
	end;
end;

function TGDOMNode.get_nodeValue: DOMString;
var
	p: PChar;
begin
	case FGNode.type_ of
	XML_ATTRIBUTE_NODE,
	XML_TEXT_NODE,
	XML_CDATA_SECTION_NODE,
	XML_ENTITY_REF_NODE,
	XML_COMMENT_NODE,
	XML_PI_NODE:
		begin
			p := xmlNodeGetContent(FGNode);
			Result := UTF8Decode(p);
			xmlFree(p);
		end;
	else
		Result := '';
	end;
end;

procedure TGDOMNode.set_nodeValue(const value: DOMString);
begin
	case FGNode.type_ of
	XML_ATTRIBUTE_NODE,
	XML_TEXT_NODE,
	XML_CDATA_SECTION_NODE,
	XML_ENTITY_REF_NODE,
	XML_COMMENT_NODE,
	XML_PI_NODE:
		begin
			xmlNodeSetContent(FGNode, PChar(UTF8Encode(value)));
		end;
	else
		//todo: raise exception - this node does not carry a value
	end;
end;

function TGDOMNode.get_nodeType: DOMNodeType;
begin
	result:=domNodeType(FGNode.type_);
end;

function TGDOMNode.get_parentNode: IDOMNode;
begin
	Result := GetDOMObject(FGNode.parent) as IDOMNode
end;

function TGDOMNode.get_childNodes: IDOMNodeList;
begin
	//todo: only if it does not exist yet ! (BUG)
	result:=TGDOMNodeList.Create(FGNode, get_OwnerDocument) as IDOMNodeList;
end;

function TGDOMNode.get_firstChild: IDOMNode;
begin
	Result := GetDOMObject(FGNode.children) as IDOMNode;
end;

function TGDOMNode.get_lastChild: IDOMNode;
begin
	Result := GetDOMObject(FGNode.last) as IDOMNode;
end;

function TGDOMNode.get_previousSibling: IDOMNode;
begin
	Result := GetDOMObject(FGNode.prev) as IDOMNode;
end;

function TGDOMNode.get_nextSibling: IDOMNode;
begin
	Result := GetDOMObject(FGNode.next) as IDOMNode;
end;

function TGDOMNode.get_attributes: IDOMNamedNodeMap;
begin
	//todo: only if it does not exist yet ! (BUG)
	if FGNode.type_=ELEMENT_NODE
		then result:=TGDOMNamedNodeMap.Create(FGNode, get_ownerDocument)
			as IDOMNamedNodeMap
		else result:=nil;
end;

function TGDOMNode.get_ownerDocument: IDOMDocument;
begin
	Result := GetDOMObject(FGNode.doc) as IDOMDocument;
end;

function TGDOMNode.get_namespaceURI: DOMString;
begin
	Result := '';
	case FGNode.type_ of
		XML_ELEMENT_NODE,
		XML_ATTRIBUTE_NODE:
			begin
				if FGNode.ns=nil then exit;
				Result := UTF8Decode(FGNode.ns.href);
			end;
	end;
end;

function TGDOMNode.get_prefix: DOMString;
begin
	Result := '';
	case FGNode.type_ of
		XML_ELEMENT_NODE,
		XML_ATTRIBUTE_NODE:
			begin
				if FGNode.ns=nil then exit;
	Result := UTF8Decode(FGNode.ns.prefix);
			end;
		end;
end;

function TGDOMNode.get_localName: DOMString;
var
	temp: String;
begin
	case FGNode.type_ of
		//todo: check the result for the other nodetypes
		//this is necessary, because libxml2 delivers
		//'text' instead of '#text'
		3: temp:='#text';
		9: temp:='#document';
	else
		begin
			temp:=FGNode.name;
			// this is neccessary, because according to the dom2
			// specification localName has to be nil for nodes,
			// that don't have a namespace
			if FGNode.ns=nil
				then temp:='';
		end;
	end;
	result:=temp;
end;

function TGDOMNode.insertBefore(const newChild, refChild: IDOMNode): IDOMNode;
var
	node: xmlNodePtr;
begin
	if (newChild<>nil) then begin
		node:=xmlAddPrevSibling(GetGNode(refChild),GetGNode(newChild));
		Result := GetDOMObject(node) as IDOMNode;
	end else begin
		Result := nil;
	end;
end;

function TGDOMNode.replaceChild(const newChild, oldChild: IDOMNode): IDOMNode;
var
	old, cur, node: xmlNodePtr;
begin
	//todo: raise exception otherwise
	if (oldChild<>nil) and (newChild<>nil)
		then begin
			old := GetGNode(oldChild);
			cur := GetGNode(newChild);
			node:=xmlReplaceNode(old, cur);
			result:=GetDOMObject(node) as IDOMNode
		end
		else result:=nil;
end;

function TGDOMNode.removeChild(const childNode: IDOMNode): IDOMNode;
begin
	if childNode<>nil
		then xmlUnlinkNode(GetGNode(childNode));
	result:=childNode;
end;

(**
 * gdome_xml_n_appendChild:
 * @self:  Node Object ref
 * @newChild:  The node to add
 * @exc:  Exception Object ref
 *
 * Adds the node @newChild to the end of the list of children of this node.
 * If the @newChild is already in the tree, it is first removed. If it is a
 * DocumentFragment node, the entire contents of the document fragment are
 * moved into the child list of this node
 *
 * %GDOME_HIERARCHY_REQUEST_ERR: Raised if this node is of a type that does not
 * allow children of the type of the @newChild node, or if the node to append is
 * one of this node's ancestors or this node itself.
 * %GDOME_WRONG_DOCUMENT_ERR: Raised if @newChild was created from a different
 * document than the one that created this node.
 * %GDOME_NO_MODIFICATION_ALLOWED_ERR: Raised when the node is readonly.
 * Returns: the node added.
 *)
function TGDOMNode.appendChild(const newChild: IDOMNode): IDOMNode;

const
	FAllowedChildTypes= [ Element_Node,
												Text_Node,
												CDATA_Section_Node,
												Entity_Reference_Node,
												Processing_Instruction_Node,
												Comment_Node,
												Document_Type_Node,
												Document_Fragment_Node,
												Notation_Node];
var
	node: xmlNodePtr;
begin
	node:=GetGNode(newChild);
	DomAssert(node<>nil, NOT_SUPPORTED_ERR);
	DomAssert(not IsReadOnly, NO_MODIFICATION_ALLOWED_ERR);
	DomAssert((newChild.NodeType in FAllowedChildTypes), HIERARCHY_REQUEST_ERR);
	if (FGNode.type_=XML_DOCUMENT_NODE) and (newChild.nodeType = XML_ELEMENT_NODE) then begin
		DomAssert((xmlDocGetRootElement(xmlDocPtr(FGNode))=nil), HIERARCHY_REQUEST_ERR);
	end;
	DomAssert(node.doc=FGNode.doc, WRONG_DOCUMENT_ERR);
	DomAssert(not IsAncestorOrSelf(GetGNode(newChild)), HIERARCHY_REQUEST_ERR);
	DomAssert(not IsReadOnlyNode(node.parent), NO_MODIFICATION_ALLOWED_ERR);
	if node.parent<>nil then begin
		xmlUnlinkNode(node);
	end;
//  /* If the newChild is already in the tree, it is first removed. */
//	if (gdome_xmlGetParent(new_priv->n) != NULL)
//		gdome_xmlUnlinkChild(gdome_xmlGetParent(new_priv->n), new_priv->n);
//
	if node.type_=XML_ATTRIBUTE_NODE then begin
		(get_OwnerDocument as IDOMInternal).removeAttr(xmlAttrPtr(node));
	end;
	node := xmlAddChild(FGNode,node);
	Result:=GetDOMObject(node) as IDOMNode;
end;

function TGDOMNode.hasChildNodes: Boolean;
begin
	if FGNode.children<>nil
		then result:=true
		else result:=false;
end;

function TGDOMNode.hasAttributes: Boolean;
begin
	result:=false;
end;

function TGDOMNode.cloneNode(deep: Boolean): IDOMNode;
var
	node: xmlNodePtr;
	recursive: Integer;
begin
	if deep
	then recursive:= 1
	else recursive:= 0;
	node:=xmlCopyNode(FGNode,recursive);
	Result:=GetDOMObject(node) as IDOMNode;
end;

procedure TGDOMNode.normalize;
var
	node,next,new_next: xmlNodePtr;
	nodeType: integer;
begin
	node:=FGNode.children;
	next:=nil;
	while node<>nil do begin
		nodeType:=node.type_;
		if nodeType=TEXT_NODE then begin
			next:=node.next;
			while next<>nil do begin
				if next.type_<>TEXT_NODE then break;
				xmlTextConcat(node,next.content,length(next.content));
				new_next:=next.next;
				xmlUnlinkNode(next);
				xmlFreeNode(next); //carefull!!
				next:=new_next;
			end;
		end else if nodeType=ELEMENT_NODE then begin
			//todo
		end;
		node:=next;
	end;
end;

function TGDOMNode.isSupported(const feature, version: DOMString): Boolean;
begin
	if (((upperCase(feature)='CORE') and (version='2.0')) or
		 (upperCase(feature)='XML')  and (version='2.0')) //[pk] ??? what ???
		then result:=true
	else result:=false;
end;

constructor TGDOMNode.Create(aNode: xmlNodePtr);
begin
	inherited Create;
	if(not Assigned(aNode)) then begin
		raise EDomException.Create('TGDOMNode.Create: Cannot wrap unassigned node');
	end;
	FGNode := aNode;
	inc(nodecount);
end;

destructor TGDOMNode.destroy;
begin
	Dec(nodecount);
	inherited Destroy;
end;

{ TGDOMNodeList }

constructor TGDOMNodeList.Create(AParent: xmlNodePtr; aOwnerDocument: IDomDocument);
// create a IDOMNodeList from a var of type xmlNodePtr
// xmlNodePtr is the same as xmlNodePtrList, because in libxml2 there is no
// difference in the definition of both
begin
	inherited Create;
	FParent := AParent;
	FXpathObject := nil;
	FOwnerDocument := aOwnerDocument;
end;

constructor TGDOMNodeList.Create(AXpathObject: xmlXPathObjectPtr;
	ADocument: IDOMDocument);
// create a IDOMNodeList from a var of type xmlNodeSetPtr
//	xmlNodeSetPtr = ^xmlNodeSet;
//	xmlNodeSet = record
//		nodeNr : longint;               { number of nodes in the set  }
//		nodeMax : longint;              { size of the array as allocated  }
//		nodeTab : PxmlNodePtr;          { array of nodes in no particular order  }
//	end;
begin
	inherited Create;
	FParent := nil;
	FXpathObject := AXpathObject;
end;

destructor TGDOMNodeList.destroy;
begin
	if FXPathObject<>nil then xmlXPathFreeObject(FXPathObject);
	inherited destroy;
end;

function TGDOMNodeList.get_item(index: Integer): IDOMNode;
var
	node: xmlNodePtr;
	i: integer;
begin
	i:=index;
	if FParent<>nil then begin
		node:=FParent.children;
		while (i>0) and (node.next<>nil) do begin
			dec(i);
			node:=node.next;
		end;
		DomAssert(i>0, INDEX_SIZE_ERR);
	end else begin
		DomAssert(FXPathObject<>nil, 101);
		node := xmlXPathNodeSetItem(FXPathObject.nodesetval,i)
	end;
	Result:=GetDOMObject(node) as IDOMNode;
end;

function TGDOMNodeList.get_length: Integer;
var
	node: xmlNodePtr;
	i: integer;
begin
	if FParent<>nil then begin
		i:=1;
		node:=FParent.children;
		while (node.next<>nil) do begin
			inc(i);
			node:=node.next
		end;
		result:=i;
	end else begin
		result:=FXPathObject.nodesetval.nodeNr;
	end;
end;

{TGDOMNamedNodeMap}
function TGDOMNamedNodeMap.get_item(index: Integer): IDOMNode;
//same as NodeList.get_item
var
	node: xmlNodePtr;
	i: integer;
begin
	i:=index;
	node:=GNamedNodeMap;
	while (i>0) and (node.next<>nil) do begin
		dec(i);
		node:=node.next
	end;
	Result:=GetDOMObject(node) as IDOMNode
end;

function TGDOMNamedNodeMap.get_length: Integer;
// same as NodeList.get_length
var
	node: xmlNodePtr;
	i: integer;
begin
	i:=1;
	node:=GNamedNodeMap;
	if node=nil
		then begin
			result:=0;
			exit
		end;
	while (node.next<>nil) do begin
		inc(i);
		node:=node.next
	end;
	result:=i;
end;

function TGDOMNamedNodeMap.getNamedItem(const name: DOMString): IDOMNode;
var
	node: xmlNodePtr;
	uname: string;
begin
	node:=GNamedNodeMap;
	if node<>nil then begin
		uname:=UTF8Encode(name);
		node:=xmlNodePtr(xmlHasProp(FGNamedNodeMap, PChar(uname)));
	end;
	Result := GetDOMObject(node) as IDOMNode;
end;

function TGDOMNamedNodeMap.setNamedItem(const newItem: IDOMNode): IDOMNode;
var
	attr: xmlAttrPtr;
	node,node1: xmlNodePtr;
	slocalname,value:pchar;
begin
	node:=GNamedNodeMap;
	node1:=GetGNode(newItem);
	slocalName:=node1.name;
	attr:=xmlHasProp(FGNamedNodeMap,slocalName);
//???  (FOwnerDocument as IDOMInternal).removeAttr(xmlAttrPtr(attr));
	//if the NamedNodeMap is empty, replace its first element with the newItem
	if node=nil
		then begin
			FGNamedNodeMap.properties:=xmlAttrPtr(node1);
		end
		else begin

			// if the newItem does exit, replace it
			if attr<>nil
				then begin
					node:=xmlReplaceNode(node,node1);
					attr:=xmlAttrPtr(node);
				end
				// if the newItem doesn't exist, add it
				else begin
					if node1.children<>nil
						then value:=node1.children.content
						else value:='';
					attr:=xmlSetProp(FGNamedNodeMap,slocalName,value);
				end;
		end;
		if attr<>nil
			then result:=TGDomAttr.Create(attr) as IDOMNode
			else result:=nil;
end;

function TGDOMNamedNodeMap.removeNamedItem(const name: DOMString): IDOMNode;
var
	node: xmlNodePtr;
	uname: string;
begin
	node:=GNamedNodeMap;
	if node<>nil then begin
		uname := UTF8Encode(name);
		node:=xmlNodePtr(xmlUnsetProp(FGNamedNodeMap, PChar(uname)));
	end;
	Result := GetDOMObject(node) as IDOMNode;
end;

function TGDOMNamedNodeMap.getNamedItemNS(const namespaceURI, localName: DOMString): IDOMNode;
var
	node: xmlNodePtr;
	uns, ulocal: string;
begin
	node:=GNamedNodeMap;
	if node<>nil then begin
		uns := UTF8Encode(namespaceURI);
		ulocal := UTF8Encode(localName);
		node := xmlNodePtr(xmlHasNSProp(FGNamedNodeMap, PChar(uns), PChar(ulocal)));
	end;
	Result := GetDOMObject(node) as IDOMNode;
end;

function TGDOMNamedNodeMap.setNamedItemNS(const newItem: IDOMNode): IDOMNode;
var
	attr,xmlnewAttr: xmlAttrPtr;
	value:pchar;
	temp,slocalName: string;
	ns:xmlNSPtr;
	namespace:pchar;
begin
	if newItem<>nil then begin
		xmlnewAttr:=xmlAttrPtr(GetGNode(newItem));              // Get the libxml2-Attribute
		ns:=xmlnewAttr.ns;
		if ns<>nil
			then namespace:=ns.href
			else namespace:='';
		slocalName:=localName(xmlNewattr.name);
		attr:=xmlHasNSProp(FGNamedNodeMap,pchar(slocalName),namespace); // Check if the Element has
																																		// already an attribute with this name
		if attr=nil then begin
			temp:=(newItem as IDOMAttr).value;
			if xmlnewAttr.children<>nil
				//todo: test the following case with a non-empty newAttr.value
				//newAttr.value must be the same as xmlnewAttr.children.content
				then value:=xmlnewAttr.children.content             // not tested
				else value:='';
			if ns<> nil
				then attr:=xmlSetNSProp(FGNamedNodeMap,ns,pchar(slocalName),value)
				else attr:=xmlSetProp(FGNamedNodeMap,pchar(slocalName),value);
			if attr<>nil
				then result:=TGDomAttr.Create(attr) as IDOMAttr
				else result:=nil;
		end;
	end else result:=nil;
end;

function TGDOMNamedNodeMap.removeNamedItemNS(const namespaceURI, localName: DOMString): IDOMNode;
var
	node: xmlNodePtr;
	attr: xmlAttrPtr;
	uns, ulocal: string;
begin
	node:=GNamedNodeMap;
	if node<>nil then begin
		uns := UTF8Encode(namespaceURI);
		ulocal := UTF8Encode(localName);
		attr:=(xmlHasNsProp(FGNamedNodeMap, PChar(uns), PChar(ulocal)));
		if attr<>nil
			then begin
				node:=xmlNodePtr(xmlCopyProp(nil,attr));
				xmlRemoveProp(attr);
			end else node:=nil;
	end;
	result:=GetDOMObject(node) as IDOMNode;
end;

constructor TGDOMNamedNodeMap.Create(ANamedNodeMap: xmlNodePtr; AOwnerDocument: IDomDocument);
// ANamedNodeMap=nil for empty NodeMap
begin
	FOwnerDocument:=AOwnerDocument;
	FGNamedNodeMap:=ANamedNodeMap;
	inherited create;
end;

destructor TGDOMNamedNodeMap.destroy;
begin
	if FGNamedNodeMap<>nil
		then begin
			FOwnerDocument:=nil;
			FGNamedNodeMap:=nil;
		end;
	inherited destroy;
end;

function TGDOMNamedNodeMap.get_GNamedNodeMap: xmlNodePtr;
begin
	if FGNamedNodeMap <> nil
		then result:=xmlNodePtr(FGNamedNodeMap.properties)
		else result:=nil;
end;

{ TGDOMAttr }

function TGDOMAttr.GetGAttribute: xmlAttrPtr;
begin
	result:=xmlAttrPtr(GNode);
end;

function TGDOMAttr.get_name: DOMString;
var
	temp: string;
begin
	//temp:=libxmlStringToString(GAttribute.name);
	temp:=inherited get_nodeName;
	result:=temp;
end;

function TGDOMAttr.get_ownerElement: IDOMElement;
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
	//DOMVendorNotSupported('get_ownerElement', SGXML); { Do not localize }
	Result := nil;
end;

function TGDOMAttr.get_specified: Boolean;
begin
	//todo: implement it correctly
	result:=true;
end;

function TGDOMAttr.get_value: DOMString;
begin
	result:= inherited get_nodeValue;
end;

procedure TGDOMAttr.set_value(const attributeValue: DOMString);
begin
	inherited set_nodeValue(attributeValue);
end;

constructor TGDOMAttr.Create(AAttribute: xmlAttrPtr);
begin
	inherited create(xmlNodePtr(AAttribute));
end;

destructor TGDOMAttr.destroy;
begin
	inherited destroy;
end;


//***************************
//TGDOMElement Implementation
//***************************

// IDOMElement
function TGDOMElement.get_tagName: DOMString;
begin
	result:=self.get_nodeName;
end;

function TGDOMElement.getAttribute(const name: DOMString): DOMString;
var
	p: PxmlChar;
begin
	//todo: handle prefixed case
	p := xmlGetProp(FGNode,PChar(UTF8Encode(name)));
	Result := UTF8Decode(p);
	xmlFree(p);
end;

procedure TGDOMElement.setAttribute(const name, value: DOMString);
begin
	xmlSetProp(FGNode,
		PChar(UTF8Encode(name)),
		PChar(UTF8Encode(value)));
end;

procedure TGDOMElement.removeAttribute(const name: DOMString);
var
	attr: xmlAttrPtr;
begin
	attr := xmlHasProp(FGNode, PChar(UTF8Encode(name)));
	if attr <> nil then begin
		xmlRemoveProp(attr);
	end;
end;

function TGDOMElement.getAttributeNode(const name: DOMString): IDOMAttr;
var
	attr: xmlAttrPtr;
begin
	attr := xmlHasProp(FGNode, PChar(UTF8Encode(name)));
	if attr<>nil
	then result := TGDOMAttr.Create(attr) as IDOMAttr
	else result := nil;
end;

function TGDOMElement.setAttributeNode(const newAttr: IDOMAttr):IDOMAttr;
var
	attr,xmlnewAttr,oldattr: xmlAttrPtr;
	temp: string;
	node: xmlNodePtr;
begin
	if newAttr<>nil then begin
		xmlnewAttr:=xmlAttrPtr(GetGNode(newAttr));     // Get the libxml2-Attribute
		node:=FGNode;
		oldattr:=xmlHasProp(node,xmlNewattr.name);     // already an attribute with this name?
		attr:=node.properties;                         // if not, then oldattr=nil
		if attr=oldattr
			then node.properties:=xmlNewAttr
			else begin
				 while attr.next <> oldattr do begin
					 attr:=attr.next
				 end;
				 attr.next:=xmlNewAttr;
			end;
//		(get_OwnerDocument as IDOMInternal).removeAttr(xmlnewAttr);
		if oldattr<>nil
			then begin
				temp:=oldattr.name;
				result:=TGDomAttr.Create(oldattr) as IDOMAttr;
				(get_OwnerDocument as IDOMInternal).appendAttr(oldattr);
			end
			else begin
				result:=nil;
			end;
	end;
end;


function TGDOMElement.removeAttributeNode(const oldAttr: IDOMAttr):IDOMAttr;
var
	attr,xmlnewAttr,oldattr1: xmlAttrPtr;
	node: xmlNodePtr;
begin
	if oldAttr<>nil then begin
		xmlnewAttr:=xmlAttrPtr(GetGNode(oldAttr));     // Get the libxml2-Attribute
		node:=FGNode;
		oldattr1:=xmlHasProp(node,xmlNewattr.name);     // already an attribute with this name?
		if oldattr1<>nil then begin
			attr:=node.properties;                         // if not, then oldattr=nil
			if attr=oldattr1
				then node.properties:=nil
				else begin
					 while attr.next <> oldattr1 do begin
						 attr:=attr.next
					 end;
					 attr.next:=nil;
				end;
			//(FOwnerDocument as IDOMInternal).removeAttr(oldAttr1);
			if oldattr<>nil
				then begin
					result:=oldattr;
					//(FOwnerDocument as IDOMInternal).appendAttr(oldattr);
				end
				else begin
					result:=nil;
				end;
		end;
	end else result:=nil;
end;

function TGDOMElement.getElementsByTagName(const name: DOMString): IDOMNodeList;
begin
	result:=selectNodes(name);
end;

function TGDOMElement.getAttributeNS(const namespaceURI, localName: DOMString):
	DOMString;
begin
	Result := UTF8Decode(xmlGetNSProp(FGNode,
		PChar(UTF8Encode(localName)),
		PChar(UTF8Encode(namespaceURI))));
end;

procedure TGDOMElement.setAttributeNS(const namespaceURI, qualifiedName, value: DOMString);
var
	uprefix, ulocal: string;
	ns: xmlNsPtr;
begin
	uprefix := prefix(qualifiedName);
	ulocal := localName(qualifiedName);
	ns := xmlNewNs(FGNode, PChar(UTF8Encode(namespaceURI)), PChar(uprefix));
	xmlSetNSProp(FGNode, ns, PChar(ulocal), PChar(UTF8Encode(value)));
end;

procedure TGDOMElement.removeAttributeNS(const namespaceURI, localName: DOMString);
var
	attr: xmlAttrPtr;
	uns, ulocal: string;
	ok: integer;
begin
	uns := UTF8Encode(localName);
	ulocal := UTF8Encode(namespaceURI);
	attr := xmlHasNSProp(FGNode, PChar(uns), PChar(ulocal));
	if (attr <> nil) then begin
		ok:=xmlRemoveProp(attr);
		DomAssert(ok=0, 103); //???
	end;
end;

function TGDOMElement.getAttributeNodeNS(const namespaceURI, localName: DOMString): IDOMAttr;
var
	attr: xmlAttrPtr;
begin
	attr := xmlHasNSProp(FGNode,
		PChar(UTF8Encode(localName)),
		PChar(UTF8Encode(namespaceURI)));
	Result:=TGDOMAttr.Create(attr) as IDOMAttr;
end;

function TGDOMElement.setAttributeNodeNS(const newAttr: IDOMAttr): IDOMAttr;
var
	attr,xmlnewAttr,oldattr: xmlAttrPtr;
	temp: string;
	node: xmlNodePtr;
	namespace: pchar;
	slocalname: string;
begin
	if newAttr<>nil then begin
		xmlnewAttr:=xmlAttrPtr(GetGNode(newAttr));    // Get the libxml2-Attribute
		node:=FGNode;
		xmlnewAttr.parent:=node;
		if xmlnewAttr.ns<>nil
			then begin
				namespace:=xmlnewAttr.ns.href;
				node.nsDef:=xmlnewAttr.ns;
				//xmlSetNs(node,xmlnewAttr.ns);
			end else namespace:='';
		slocalName:=localName(xmlNewattr.name);
		oldattr:=xmlHasNSProp(node,pchar(slocalName),namespace); // already an attribute with this name?
		attr:=node.properties;                                   // if not, then oldattr=nil
		if attr=oldattr
			then node.properties:=xmlNewAttr
			else begin
				 while attr.next <> oldattr do begin
					 attr:=attr.next
				 end;
				 attr.next:=xmlNewAttr;
			end;
		(get_OwnerDocument as IDOMInternal).removeAttr(xmlnewAttr);
		if oldattr<>nil
			then begin
				temp:=oldattr.name;
				result:=TGDomAttr.Create(oldattr) as IDOMAttr;
				(get_OwnerDocument as IDOMInternal).appendAttr(oldattr);
			end
			else begin
				result:=nil;
			end;
	end;
end;

function TGDOMElement.getElementsByTagNameNS(const namespaceURI, localName: DOMString): IDOMNodeList;
begin
	//todo: more generic code
	RegisterNs('xyz4ct',namespaceURI);
	result:=selectNodes('xyz4ct:'+localName);
end;

function TGDOMElement.hasAttribute(const name: DOMString): Boolean;
begin
	Result := xmlHasProp(FGNode, PChar(UTF8Encode(name)))<>nil;
end;


function TGDOMElement.hasAttributeNS(const namespaceURI, localName: DOMString): Boolean;
begin
	Result := (nil<>xmlHasNsProp(FGNode,
		PChar(UTF8Encode(localName)),
		PChar(UTF8Encode(namespaceURI))));
end;

procedure TGDOMElement.normalize;
begin
	inherited normalize;
end;

constructor TGDOMElement.Create(AElement: xmlNodePtr);
begin
	inc(elementcount);
	inherited create(xmlNodePtr(AElement));
end;

destructor TGDOMElement.destroy;
begin
	if elementcount >0 then begin
		dec(elementcount);
	end;
	inherited destroy;
end;


//************************************************************************
// functions of TGDOMDocument
//************************************************************************

constructor TGDOMDocument.create(GDOMImpl:IDOMImplementation; const namespaceURI, qualifiedName: DOMString; doctype: IDOMDocumentType);
begin
//	DomAssert(doctype<>nil, NOT_SUPPORTED_ERR, 'TGDOMDocument.create with doctype not implemented yet');
	FGdomimpl:=GDOMImpl;
	//Create doc-node as pascal object
	inherited create(xmlNodePtr(xmlNewDoc(XML_DEFAULT_VERSION)));
	FAttrList:=TList.Create;
	FNodeList:=TList.Create;
	inc(doccount);
	// prepare documentElement
	if (qualifiedName<>'') then begin
		appendChild(createElementNS(namespaceURI, qualifiedName));
	end;
	_AddRef; //todo: replace with better solution
end;

destructor TGDOMDocument.Destroy;
var
	i: integer;
	AAttr: xmlAttrPtr;
	ANode: xmlNodePtr;
begin
	if GDoc<>nil then begin
		if FAttrList<>nil then begin
			for i:=0 to FAttrList.Count-1 do begin
				AAttr:=FAttrList[i];
				if AAttr<>nil then begin
					if (AAttr.parent=nil) then begin
						if (AAttr.ns=nil) then begin
							xmlFreeProp(AAttr)
						end else begin
							AAttr.ns:=nil;
							//xmlFreeProp(AAttr);
						end;
					end;
				end;
			end;
			FAttrList.Free;
			FAttrList := nil;
		end;
		if FNodeList<>nil then begin
			for i:=0 to FNodeList.Count-1 do begin
				ANode:=FNodeList[i];
				if ANode<>nil then begin
					if (ANode.parent=nil) then begin
						xmlFreeNode(ANode);
					end;
				end;
			end;
			FNodeList.Free;
			FNodeList := nil;
		end;
		xmlFreeDoc(GDoc);
		FGNode := nil;
	end;
	Dec(doccount);
	inherited Destroy;
end;

// IDOMDocument
function TGDOMDocument.get_doctype: IDomDocumentType;
var
	dtd: xmlDtdPtr;
begin
	Result := nil;
	if GDoc=nil then exit;
	dtd := GDoc.intSubset;
	if dtd = nil then exit;
	Result := GetDomObject(dtd) as IDomDocumentType;
end;

function TGDOMDocument.get_domImplementation: IDOMImplementation;
begin
	result:=FGDOMImpl;
end;

function TGDOMDocument.get_documentElement: IDOMElement;
begin
	Result := GetDOMObject(xmlDocGetRootElement(GDoc)) as IDomElement;
end;

procedure TGDOMDocument.set_documentElement(const IDOMElement: IDOMElement);
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
end;

function TGDOMDocument.createElement(const tagName: DOMString): IDomElement;
var
	node: xmlNodePtr;
begin
	node := xmlNewDocNode(requestDocPtr, nil, PChar(UTF8Encode(tagName)),nil);
	Result := GetDOMObject(node) as IDomElement;
end;

function TGDOMDocument.createDocumentFragment: IDomDocumentFragment;
var
	node: xmlNodePtr;
begin
	node := xmlNewDocFragment(requestDocPtr);
	Result := GetDOMObject(node) as IDomDocumentFragment;
end;

function TGDOMDocument.createTextNode(const data: DOMString): IDomText;
var
	node: xmlNodePtr;
begin
	node := xmlNewDocText(requestDocPtr, PChar(UTF8Encode(data)));
	Result := GetDOMObject(node) as IDomText;
end;

function TGDOMDocument.createComment(const data: DOMString): IDomComment;
var
	node: xmlNodePtr;
begin
	node := xmlNewDocComment(requestDocPtr, PChar(UTF8Encode(data)));
	Result := GetDOMObject(node) as IDomComment;
end;

function TGDOMDocument.createCDATASection(const data: DOMString): IDomCDataSection;
var
	s: string;
	node: xmlNodePtr;
begin
	s := UTF8Encode(data);
	node := xmlNewCDataBlock(requestDocPtr, PChar(s), length(s));
	Result := GetDOMObject(node) as IDomCDataSection;
end;

function TGDOMDocument.createProcessingInstruction(const target, data: DOMString): IDomProcessingInstruction;
var
	pi: xmlNodePtr;
begin
	pi := xmlNewPI(PChar(UTF8Encode(target)), PChar(UTF8Encode(data)));
	pi.doc := requestDocPtr;
	Result := GetDOMObject(pi) as IDomProcessingInstruction;
end;

function TGDOMDocument.createAttribute(const name: DOMString): IDomAttr;
var
	attr: xmlAttrPtr;
begin
	attr := xmlNewDocProp(requestDocPtr, PChar(UTF8Encode(name)), nil);
	Result := GetDOMObject(attr) as IDomAttr;
end;

function TGDOMDocument.createEntityReference(const name: DOMString): IDomEntityReference;
var
	node: xmlNodePtr;
begin
	node := xmlNewReference(requestDocPtr, PChar(UTF8Encode(name)));
	Result := GetDOMObject(node) as IDomEntityReference;
end;

function TGDOMDocument.getElementsByTagName(const tagName: DOMString): IDOMNodeList;
begin
	//todo: restrict tagName to QNAME production
	//todo: selectNodes must work also directly at docnode
	Result := (get_documentElement as IDOMNodeSelect).selectNodes(tagName);
end;

function TGDOMDocument.importNode(importedNode: IDOMNode; deep: Boolean): IDOMNode;
var
	recurse: integer;
	node: xmlNodePtr;
(**
 * gdome_xml_doc_importNode:
 * @self:  Document Objects ref
 * @importedNode:  The node to import.
 * @deep:  If %TRUE, recursively import the subtree under the specified node;
 *         if %FALSE, import only the node itself. This has no effect on Attr,
 *         EntityReference, and Notation nodes.
 * @exc:  Exception Object ref
 *
 *
 * Imports a node from another document to this document. The returned node has
 * no parent; (parentNode is %NULL). The source node is not altered or removed
 * from the original document; this method creates a new copy of the source
 * node. %GDOME_DOCUMENT_NODE, %GDOME_DOCUMENT_TYPE_NODE, %GDOME_NOTATION_NODE
 * and %GDOME_ENTITY_NODE nodes are not supported.
 *
 * %GDOME_NOT_SUPPORTED_ERR: Raised if the type of node being imported is not
 * supported.
 * Returns: the imported node that belongs to this Document.
 *)
begin
	result:=nil;
	if importedNode=nil then exit;
	case integer(importedNode.nodeType) of
		DOCUMENT_NODE,DOCUMENT_TYPE_NODE,NOTATION_NODE,ENTITY_NODE:
			DomAssert(false, 21);
		ATTRIBUTE_NODE:
			DomAssert(false, 21); //ToDo: implement this case
	else
		if deep
		then recurse:=1
		else recurse:=0;
		node:=xmlDocCopyNode(GetGNode(importedNode), requestDocPtr, recurse);
		Result := GetDOMObject(node) as IDomNode;
	end;
end;
(* the c-code to translate (from gdome)

GdomeNode *
gdome_xml_doc_importNode (GdomeDocument *self, GdomeNode *importedNode, GdomeBoolean deep, GdomeException *exc) {
	Gdome_xml_Document *priv = (Gdome_xml_Document * )self;
	Gdome_xml_Node *priv_node = (Gdome_xml_Node * )importedNode;
	xmlNode *ret = NULL;

	g_return_val_if_fail (priv != NULL, NULL);
	g_return_val_if_fail (GDOME_XML_IS_DOC (priv), NULL);
	g_return_val_if_fail (importedNode != NULL, NULL);
	g_return_val_if_fail (exc != NULL, NULL);

	switch (gdome_xml_n_nodeType (importedNode, exc)) {
	case XML_ATTRIBUTE_NODE:
		g_assert (gdome_xmlGetOwner ((xmlNode * )priv->n) == priv->n);
		ret = (xmlNode * )xmlCopyProp ((xmlNode * )priv->n, (xmlAttr * )priv_node->n);
		gdome_xmlSetParent (ret, NULL);
		break;
	case XML_DOCUMENT_FRAG_NODE:
	case XML_ELEMENT_NODE:
	case XML_ENTITY_REF_NODE:
	case XML_PI_NODE:
	case XML_TEXT_NODE:
	case XML_CDATA_SECTION_NODE:
	case XML_COMMENT_NODE:
		ret = xmlDocCopyNode (priv_node->n, priv->n, deep);
		break;
	default:
		*exc = GDOME_NOT_SUPPORTED_ERR;
	}

	return gdome_xml_n_mkref (ret);
}
*)

function TGDOMDocument.createElementNS(const namespaceURI, qualifiedName: DOMString): IDOMElement;
var
	node: xmlNodePtr;
	ns: xmlNsPtr;
	uprefix, ulocal: string;
begin
	if (namespaceURI<>'') then begin
		uprefix := prefix(qualifiedName);
		ulocal := localName(qualifiedName);
		node := xmlNewDocNode(requestDocPtr, nil, PChar(UTF8Encode(qualifiedName)), nil);
		ns := xmlNewNs(node, PChar(UTF8Encode(namespaceURI)), PChar(uprefix));
		xmlSetNs(node, ns);
	end else begin
		ulocal := UTF8Encode(qualifiedName);
		node := xmlNewDocNode(requestDocPtr, nil, PChar(UTF8Encode(qualifiedName)), nil);
	end;
	Result := GetDOMObject(node) as IDomElement;
end;

function TGDOMDocument.createAttributeNS(const namespaceURI, qualifiedName: DOMString): IDOMAttr;
var
	attr: xmlAttrPtr;
	ns: xmlNsPtr;
	uprefix, ulocal: string;
begin
	if (namespaceURI<>'') then begin
		uprefix := prefix(qualifiedName);
		ulocal := localName(qualifiedName);
		ns := xmlNewNs(FGNode, PChar(UTF8Encode(namespaceURI)), PChar(uprefix));
	end else begin
		ns := nil;
		ulocal := UTF8Encode(qualifiedName);
	end;
	attr := xmlNewNsProp(FGNode, ns, PChar(ulocal), nil); //todo:fix
	Result := GetDOMObject(attr) as IDomAttr;
	if attr<>nil then begin
		FAttrList.Add(attr);
	end;
end;

function TGDOMDocument.getElementsByTagNameNS(const namespaceURI, localName: DOMString): IDOMNodeList;
var
	docElement: IDOMElement;
begin
	docElement := get_documentElement;
	Result := docElement.getElementsByTagNameNS(namespaceURI,localName);
end;

function TGDOMDocument.getElementById(const elementId: DOMString): IDOMElement;
//var
	//AElement: xmlElementPtr;
	//name1: string;
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
	{name1:=TGdomString.create(elementID);
	AElement:=gdome_doc_getElementById(FPGdomeDoc,name1.GetPString, @exc);
	DomAssert(false, exc);
	name1.Free;
	if AElement <> nil
		then result:=TGDOMElement.Create(AElement,self)
		else result:=nil;}
end;

// IDOMParseOptions
function TGDOMDocument.get_async: Boolean;
begin
	result:=FAsync;
end;

function TGDOMDocument.get_preserveWhiteSpace: Boolean;
begin
	result:=FPreserveWhiteSpace;
end;

function TGDOMDocument.get_resolveExternals: Boolean;
begin
	result:=FResolveExternals;
end;

function TGDOMDocument.get_validate: Boolean;
begin
	result:=FValidate;
end;

procedure TGDOMDocument.set_async(Value: Boolean);
begin
	FAsync:=true;
end;

procedure TGDOMDocument.set_preserveWhiteSpace(Value: Boolean);
begin
	FPreserveWhitespace:=true;
end;

procedure TGDOMDocument.set_resolveExternals(Value: Boolean);
begin
	FResolveExternals:=true;
end;

procedure TGDOMDocument.set_validate(Value: Boolean);
begin
	Fvalidate:=true;
end;

// IDOMPersist
function TGDOMDocument.get_xml: DOMString;
var
	CString,encoding:pchar;
	length:LongInt;
begin
	CString:='';
	encoding:=GDoc.encoding;
	xmlDocDumpMemoryEnc(GDoc,CString,@length,encoding);
	result:=CString;
end;

function TGDOMDocument.asyncLoadState: Integer;
begin
	result:=0;
end;

function TGDOMDocument.load(source: OleVariant): Boolean;
// Load dom from file
var filename: string;
		root: xmlNodePtr;
begin
//  filename:=StringReplace(source, '\', '/', [rfReplaceAll]);
	filename:=source;
	xmlFreeDoc(GDoc);
//	inherited Destroy;
	GDoc:=xmlParseFile(pchar(filename));
	if GDoc<>nil
		then
			begin
				root:= xmlNodePtr(GDoc);
				inherited create(root);
				result:=true
			end
		else result:=false;
end;

function TGDOMDocument.loadFromStream(const stream: TStream): Boolean;
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
	result:=false;
end;

function TGDOMDocument.loadxml(const Value: DOMString): Boolean;
var
	newdoc: xmlDocPtr;
begin
//	destroyNode;
//	xmlFreeDoc(FPGdomeDoc); //DIRTY ! todo: createFPGdomeDoc on demand
	//FPGdomeDoc:=xmlParseMemory(temp.CString,length(temp.CString));
	newdoc := xmlParseDoc(PChar(UTF8Encode(Value)));
	if newdoc<>nil then begin
		FGNode := xmlNodePtr(newDoc);
		GDoc._private := nil;
		newdoc._private := self;
		GDoc := newdoc;
//		Create(xmlNodePtr(FPGdomeDoc),nil); //DIRTY
		result := true;
	end else begin
		result := false;
	end;
end;

procedure TGDOMDocument.save(destination: OleVariant);
var
	temp:string;
	encoding:pchar;
	bytes: integer;
begin
	temp:=destination;
	encoding:=GDoc.encoding;
	bytes:=xmlSaveFileEnc(pchar(temp),GDoc,encoding);
	if bytes<0 then DomAssert(false, 22); //write error
end;

procedure TGDOMDocument.saveToStream(const stream: TStream);
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
end;

procedure TGDOMDocument.set_OnAsyncLoad(const Sender: TObject;
	EventHandler: TAsyncEventHandler);
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
end;

{ TGDOMCharacterData }

procedure TGDOMCharacterData.appendData(const data: DOMString);
begin
	xmlNodeAddContent(FGNode, PChar(UTF8Encode(data)));
end;

procedure TGDOMCharacterData.deleteData(offset, count: Integer);
begin
	replaceData(offset, count, '');
end;

function TGDOMCharacterData.get_data: DOMString;
begin
	result:= inherited get_nodeValue;
end;

function TGDOMCharacterData.get_length: Integer;
begin
	result:=length(get_data);
end;

procedure TGDOMCharacterData.insertData(offset: Integer;
	const data: DOMString);
begin
	replaceData(offset, 0, PChar(UTF8Encode(data)));
end;

procedure TGDOMCharacterData.replaceData(offset, count: Integer;
	const data: DOMString);
var
	s1,s2,s: WideString;
begin
	s := Get_data;
	s1:= Copy(s, 1, offset);
	s2:= Copy(s, offset + count+1, Length(s)-offset-count);
	s := s1 + data + s2;
	Set_data(s);
end;

procedure TGDOMCharacterData.set_data(const data: DOMString);
begin
 inherited set_nodeValue(data);
end;

function TGDOMCharacterData.substringData(offset,
	count: Integer): DOMString;
//var
//  temp:PGdomeDomString;
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
	{temp:=gdome_cd_substringData(GCharacterData,offset,count,@exc);
	DomAssert(false, exc);
	result:=GdomeDOMStringToString(temp);}
end;

constructor TGDOMCharacterData.Create(ACharacterData: xmlNodePtr);
begin
	inherited create(xmlNodePtr(ACharacterData));
end;

destructor TGDOMCharacterData.destroy;
begin
	inherited destroy;
end;

{ TGDOMText }

function TGDOMText.splitText(offset: Integer): IDOMText;
var
	s: WideString;
begin
	s := Get_data;
	s:= Copy(s, 1, offset);
	Set_data(s);
	result:= self;
end;

{ TMSDOMEntity }

function TGDOMEntity.get_notationName: DOMString;
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
	//result:=GdomeDOMStringToString(gdome_ent_notationName(GEntity,@exc));
	//DomAssert(exc);
end;

function TGDOMEntity.get_publicId: DOMString;
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
	//result:=GdomeDOMStringToString(gdome_ent_publicID(GEntity,@exc));
	//DomAssert(exc);
end;

function TGDOMEntity.get_systemId: DOMString;
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
	//result:=GdomeDOMStringToString(gdome_ent_systemID(GEntity,@exc));
end;

function TGDOMEntity.GetGEntity: xmlEntityPtr;
begin
	Result := xmlEntityPtr(GNode);
end;

{ TGDOMProcessingInstruction }

function TGDOMProcessingInstruction.get_data: DOMString;
begin
	result:=inherited get_nodeValue;
end;

function TGDOMProcessingInstruction.get_target: DOMString;
begin
	result:=inherited get_nodeName;
end;

procedure TGDOMProcessingInstruction.set_data(const value: DOMString);
begin
	inherited set_nodeValue(value);
end;

{ TGDOMDocumentType }

function TGDOMDocumentType.get_entities: IDOMNamedNodeMap;
//var entities: PGdomeNamedNodeMap;
//    exc: GdomeException;
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
	{entities:=gdome_dt_entities(GDocumentType,@exc);
	DomAssert(exc);
	if entities<>nil
		then result:=TGDOMNamedNodeMap.Create(entities,FOwnerDocument) as IDOMNamedNodeMap
		else result:=nil;}
end;

function TGDOMDocumentType.get_internalSubset: DOMString;
var
	buff: xmlBufferPtr;
begin
	buff := xmlBufferCreate();
	xmlNodeDump(buff,nil,xmlNodePtr(GetGDocumentType),0,0);
	Result := UTF8Decode(buff.content);
	xmlBufferFree(buff);
end;

function TGDOMDocumentType.get_name: DOMString;
begin
	Result := self.get_nodeName;
end;

function TGDOMDocumentType.get_notations: IDOMNamedNodeMap;
//var
//  notations: PGdomeNamedNodeMap;
//  exc: GdomeException;
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
	//Implementing this method requires to implement a new
	//type of NodeList
	//GetGDocumentType.notations;
	{notations:=gdome_dt_notations(GDocumentType,@exc);
	DomAssert(exc);
	if notations<>nil
		then result:=TGDOMNamedNodeMap.Create(notations,FOwnerDocument) as IDOMNamedNodeMap
		else result:=nil;}
end;

function TGDOMDocumentType.get_publicId: DOMString;
begin
	Result := UTF8Decode(GetGDocumentType.ExternalID);
end;

function TGDOMDocumentType.get_systemId: DOMString;
begin
	Result := UTF8Decode(GetGDocumentType.SystemID);
end;

function TGDOMDocumentType.GetGDocumentType: xmlDtdPtr;
begin
	result:=xmlDtdPtr(GNode);
end;

constructor TGDOMDocumentType.Create(dtd:xmlDtdPtr);
begin
	//Create root-node as pascal object
	inherited Create(xmlNodePtr(dtd));
end;


destructor TGDOMDocumentType.destroy;
begin
	inherited destroy;
end;

{ TGDOMNotation }

function TGDOMNotation.get_publicId: DOMString;
//var
//  temp: String;
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
	//temp:=GdomeDOMStringToString(gdome_not_publicId(GNotation, @exc));
	//DomAssert(exc);
	//result:=temp;
end;

function TGDOMNotation.get_systemId: DOMString;
//var
//  temp: String;
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
	//temp:=GdomeDOMStringToString(gdome_not_systemId(GNotation, @exc));
	//DomAssert(exc);
	//result:=temp;
end;

function TGDOMNotation.GetGNotation: xmlNotationPtr;
begin
	Result := pointer(GNode);
end;

function TGDOMNode.selectNode(const nodePath: WideString): IDOMNode;
// todo: raise  exceptions
//       a) if invalid nodePath expression
//       b) if result type <> nodelist
//       c) perhaps if nodelist.length > 1 ???
begin
	result:=selectNodes(nodePath)[0];
end;

function TGDOMNode.selectNodes(const nodePath: WideString): IDOMNodeList;
// todo: raise  exceptions
//       a) if invalid nodePath expression
//       b) if result type <> nodelist
var
	doc: xmlDocPtr;
	ctxt: xmlXPathContextPtr;
	res:  xmlXPathObjectPtr;
	temp: string;
	nodetype{,nodecount}: integer;
	//ok:integer;
begin
	temp:=UTF8Encode(nodePath);
	doc:=FGNode.doc;
	if doc=nil then DomAssert(false, 100);
	ctxt:=xmlXPathNewContext(doc);
	ctxt.node:=FGNode;
//???	{ok:=}xmlXPathRegisterNs(ctxt,pchar(FPrefix),pchar(FURI));
	res:=xmlXPathEvalExpression(pchar(temp),ctxt);
	if res<>nil then  begin
		nodetype:=res.type_;
		case nodetype of
		XPATH_NODESET:
			begin
				nodecount:=res.nodesetval.nodeNr;
				result:=TGDOMNodeList.Create(res, get_OwnerDocument)
			end
		else
			result:=nil;
		end;
		//xmlXPathFreeNodeSetList(res);
		//xmlXPathFreeObject(res);
	end else begin
		result:=nil;
	end;
	xmlXPathFreeContext(ctxt);
end;

(*
 *  TXDomDocumentBuilderFactory
*)
constructor TGDOMDocumentBuilderFactory.Create(AFreeThreading : Boolean);
begin
	FFreeThreading := AFreeThreading;
end;

function TGDOMDocumentBuilderFactory.NewDocumentBuilder : IDomDocumentBuilder;
begin
	Result := TGDOMDocumentBuilder.Create(FFreeThreading);
end;

function TGDOMDocumentBuilderFactory.Get_VendorID : DomString;
begin
	if FFreeThreading then
		Result := SLIBXML
	else
		Result := SLIBXML;
end;

procedure TGDOMNode.set_Prefix(const prefix: DomString);
begin
	DomAssert(false, NOT_SUPPORTED_ERR);
end;

function TGDOMDocumentBuilder.load(const url: DomString): IDomDocument;
begin
	result:=TGDOMDocument.Create(Get_DomImplementation, url);
end;

function TGDOMDocumentBuilder.newDocument: IDomDocument;
begin
	result:=TGDOMDocument.Create(Get_DomImplementation);
end;

function TGDOMDocumentBuilder.parse(const xml: DomString): IDomDocument;
begin
	result:=TGDOMDocument.Create(Get_DomImplementation,'','',nil);
	(result as IDOMPersist).loadxml(xml);
end;

procedure TGDOMNode.RegisterNS(const prefix, URI: DomString);
begin
//todo
end;

function TGDOMNode.IsReadOnly: boolean;
begin
	result:=IsReadOnlyNode(FGNode)
end;

function TGDOMNode.IsAncestorOrSelf(newNode: xmlNodePtr): boolean;
var
	node:xmlNodePtr;
begin
	node:=FGNode;
	result:=true;
	while node<>nil do begin
		if node=newNode
			then exit;
		node:=node.parent;
	end;
	result:=false;
end;

constructor TGDOMDocument.Create(GDOMImpl: IDOMImplementation);
begin
	FGdomimpl:=GDOMImpl;
	//Create root-node as pascal object
	inherited create(xmlNodePtr(xmlNewDoc(XML_DEFAULT_VERSION)));
	FAttrList:=TList.Create;
	FNodeList:=TList.Create;
	inc(doccount);
	_AddRef; //todo: replace with better solution
end;

constructor TGDOMDocument.Create(GDOMImpl: IDOMImplementation; aUrl: DomString);
var
	fn: string;
	doc: xmlDocPtr;
begin
	//Get root-node
	{$ifdef WIN32}
		fn := UTF8Encode(StringReplace(aUrl, '\', '\\', [rfReplaceAll]));
	{$else}
		fn := aUrl;
	{$endif}
	doc := xmlParseFile(PChar(fn));
	if (doc=nil) then begin
		DomAssert(false, 102);
	end;

	inherited create(xmlNodePtr(doc));
	FGdomimpl:=GDOMImpl;
	FAttrList:=TList.Create;
	FNodeList:=TList.Create;
	inc(doccount);
	_AddRef; //todo: replace with better solution
end;

procedure TGDOMDocument.removeAttr(attr: xmlAttrPtr);
begin
	if attr<>nil
		then FAttrList.Remove(attr);
end;

procedure TGDOMDocument.appendAttr(attr: xmlAttrPtr);
begin
	if attr<>nil
		then FAttrList.add(attr);
end;

procedure TGDOMDocument.appendNode(node: xmlNodePtr);
begin
	if node<>nil
		then FNodeList.add(node);
end;

function TGDOMDocument.GetGDoc: xmlDocPtr;
begin
	Result := xmlDocPtr(FGNode);
end;

procedure TGDOMDocument.SetGDoc(aNewDoc: xmlDocPtr);
var
	old: xmlDocPtr;
begin
	old := GetGDoc;
	if (old<>nil) then begin
		old._private := nil;
	end;
	if (aNewDoc<>nil) then begin
		aNewDoc._private := self;
	end;
	FGNode := xmlNodePtr(aNewDoc);
end;

(**
 * On-demand creation of the underlying document.
 *)
function TGDOMDocument.requestDocPtr: xmlDocPtr;
var
	doc: xmlDocPtr;
begin
	Result := GetGDoc;
	if Result<>nil then exit; //the document is already created so we have to use it
	// otherwise, we create the document, using all the parameters specified so far

	//todo: distinguish empty doc, parsing, and push-parsing cases (for async)
	doc := xmlNewDoc(XML_DEFAULT_VERSION);

	SetGDoc(doc);
end;

initialization
	RegisterDomVendorFactory(TGDOMDocumentBuilderFactory.Create(False));
finalization
end.

