{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
unit msxml_dom_impl;
(**
 * This unit is an object-oriented wrapper for libxml2.
 * Object interfaces are fully compatitable with those defined by MSXML DOM.
 *
 * Author: Petr Kozelka <pkozelka@email.cz>
 *)
interface

uses
	ComObj,
{$ifdef VER140}
	Variants,
{$endif}
	libxml2,
	msxml_libxml,
	Classes;

type
{$ifdef VER130}
	TMyDispatch = class (TAutoObject)
	end;
{$else}
	TMyDispatch = class (TInterfacedObject, IUnknown)
	protected //IDispatch
		//todo
	protected
	end;
{$endif}

type
	TChildNodeList = class;
	TAttrNodeMap = class;

	ILibXml2Node = interface ['{1D4BD646-0AB9-4810-B4BD-7277FB0CFA30}']
		function  NodePtr: xmlNodePtr;
	end;

	TUniNode = record
		case integer of
		0: (ptr: pointer);
		1: (node: xmlNodePtr);
		2: (doc: xmlDocPtr);
		3: (notation: xmlNotationPtr);
		4: (entity: xmlEntityPtr);
		5: (dtd: xmlDtdPtr);
	end;
	(**
	 * Abstract base for node implementations.
	 *)
	TXMLDOMNode = class (TMyDispatch,
		ILibXml2Node,
		IXMLDOMNode)
	private
		FPtr: TUniNode;
		FChildren_OnDemand: TChildNodeList;
	protected //ILibXml2Node
		function  NodePtr: xmlNodePtr; virtual;
	protected //IXMLDOMNode
		function  Get_nodeName: WideString; safecall;
		function  Get_nodeValue: OleVariant; safecall;
		procedure Set_nodeValue(value: OleVariant); safecall;
		function  Get_nodeType: DOMNodeType; safecall;
		function  Get_parentNode: IXMLDOMNode; safecall;
		function  Get_childNodes: IXMLDOMNodeList; safecall;
		function  Get_firstChild: IXMLDOMNode; safecall;
		function  Get_lastChild: IXMLDOMNode; safecall;
		function  Get_previousSibling: IXMLDOMNode; safecall;
		function  Get_nextSibling: IXMLDOMNode; safecall;
		function  Get_attributes: IXMLDOMNamedNodeMap; safecall;
		function  insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; safecall;
		function  replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; safecall;
		function  removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; safecall;
		function  appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; safecall;
		function  hasChildNodes: WordBool; safecall;
		function  Get_ownerDocument: IXMLDOMDocument; safecall;
		function  cloneNode(deep: WordBool): IXMLDOMNode; safecall;
		function  Get_nodeTypeString: WideString; safecall;
		function  Get_text: WideString; safecall;
		procedure Set_text(const text: WideString); safecall;
		function  Get_specified: WordBool; safecall;
		function  Get_definition: IXMLDOMNode; safecall;
		function  Get_nodeTypedValue: OleVariant; safecall;
		procedure Set_nodeTypedValue(typedValue: OleVariant); safecall;
		function  Get_dataType: OleVariant; safecall;
		procedure Set_dataType(const dataTypeName: WideString); safecall;
		function  Get_xml: WideString; safecall;
		function  transformNode(const stylesheet: IXMLDOMNode): WideString; safecall;
		function  selectNodes(const queryString: WideString): IXMLDOMNodeList; safecall;
		function  selectSingleNode(const queryString: WideString): IXMLDOMNode; safecall;
		function  Get_parsed: WordBool; safecall;
		function  Get_namespaceURI: WideString; safecall;
		function  Get_prefix: WideString; safecall;
		function  Get_baseName: WideString; safecall;
		procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); safecall;
	protected //
		function  Get_data: WideString; safecall;
		procedure Set_data(const data: WideString); safecall;
	protected //
		constructor Create(aLibXmlObj: pointer);
	public
		destructor Destroy; override;
	end;

	(**
	 * Element implementation
	 *)
	TXMLDOMElement = class(TXMLDOMNode,
		IXMLDOMElement, IXMLDOMNode)
	private
		FAttributes_OnDemand: TAttrNodeMap;
	protected //IXMLDOMNode
		function  Get_attributes: IXMLDOMNamedNodeMap; safecall;
	protected //IXMLDOMElement
		function  Get_tagName: WideString; safecall;
		function  getAttribute(const name: WideString): OleVariant; safecall;
		procedure setAttribute(const name: WideString; value: OleVariant); safecall;
		procedure removeAttribute(const name: WideString); safecall;
		function  getAttributeNode(const name: WideString): IXMLDOMAttribute; safecall;
		function  setAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; safecall;
		function  removeAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; safecall;
		function  getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; safecall;
		procedure normalize; safecall;
	end;

	TXMLDOMCharacterData = class(TXMLDOMNode,
		IXMLDOMCharacterData, IXMLDOMNode)
	protected //IXMLDOMCharacterData
		function  Get_length: Integer; safecall;
		function  substringData(offset: Integer; count: Integer): WideString; safecall;
		procedure appendData(const data: WideString); safecall;
		procedure insertData(offset: Integer; const data: WideString); safecall;
		procedure deleteData(offset: Integer; count: Integer); safecall;
		procedure replaceData(offset: Integer; count: Integer; const data: WideString); safecall;
	end;

	TXMLDOMComment = class(TXMLDOMCharacterData)
	end;

	TXMLDOMText = class(TXMLDOMCharacterData,
		IXMLDOMText, IXMLDOMCharacterData, IXMLDOMNode)
	protected //IXMLDOMText
		function  splitText(offset: Integer): IXMLDOMText; safecall;
	end;

	TXMLDOMCDataSection = class(TXMLDOMText)
	end;

	TXMLDOMProcessingInstruction = class(TXMLDOMNode,
		IXMLDOMProcessingInstruction, IXMLDOMNode)
	protected //IXMLDOMProcessingInstruction
		function  IXMLDOMProcessingInstruction.Get_target = Get_nodeName;
		//get_data and set_data methods are reused from IXMLDOMNode
	end;

	TXMLDOMAttribute = class(TXMLDOMNode,
		IXMLDOMAttribute)
	protected //IXMLDOMAttribute
		function  IXMLDOMAttribute.Get_name = Get_nodeName;
		function  IXMLDOMAttribute.Get_value = Get_nodeValue;
		procedure IXMLDOMAttribute.Set_value = Set_nodeValue;
	protected //DOM2
		//todo: function Get_ownerElement: IXMLDOMElement;
	end;

	TXMLDOMEntityReference = class(TXMLDOMNode)
	end;

	TXMLDOMEntity = class(TXMLDOMNode,
		IXMLDOMEntity)
	protected //IXMLDOMEntity
		function  Get_publicId: OleVariant; safecall;
		function  Get_systemId: OleVariant; safecall;
		function  Get_notationName: WideString; safecall;
	end;

	TXMLDOMDocument = class(TXMLDOMNode,
		ILibXml2Node,
		IXMLDOMDocument)
	private
		function  requestDocPtr: xmlDocPtr;
		procedure releaseDocPtr;
	protected //ILibXml2Node
		function  NodePtr: xmlNodePtr; override;
	protected //IXMLDOMDocument
		function  Get_doctype: IXMLDOMDocumentType; safecall;
		function  Get_implementation_: IXMLDOMImplementation; safecall;
		function  Get_documentElement: IXMLDOMElement; safecall;
		procedure Set_documentElement(const DOMElement: IXMLDOMElement); safecall;
		function  createElement(const tagName: WideString): IXMLDOMElement; safecall;
		function  createDocumentFragment: IXMLDOMDocumentFragment; safecall;
		function  createTextNode(const data: WideString): IXMLDOMText; safecall;
		function  createComment(const data: WideString): IXMLDOMComment; safecall;
		function  createCDATASection(const data: WideString): IXMLDOMCDATASection; safecall;
		function  createProcessingInstruction(const target: WideString; const data: WideString): IXMLDOMProcessingInstruction; safecall;
		function  createAttribute(const name: WideString): IXMLDOMAttribute; safecall;
		function  createEntityReference(const name: WideString): IXMLDOMEntityReference; safecall;
		function  getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; safecall;
		function  createNode(type_: OleVariant; const name: WideString; const namespaceURI: WideString): IXMLDOMNode; safecall;
		function  nodeFromID(const idString: WideString): IXMLDOMNode; safecall;
		function  load(xmlSource: OleVariant): WordBool; safecall;
		function  Get_readyState: Integer; safecall;
		function  Get_parseError: IXMLDOMParseError; safecall;
		function  Get_url: WideString; safecall;
		function  Get_async: WordBool; safecall;
		procedure Set_async(isAsync: WordBool); safecall;
		procedure abort; safecall;
		function  loadXML(const bstrXML: WideString): WordBool; safecall;
		procedure save(destination: OleVariant); safecall;
		function  Get_validateOnParse: WordBool; safecall;
		procedure Set_validateOnParse(isValidating: WordBool); safecall;
		function  Get_resolveExternals: WordBool; safecall;
		procedure Set_resolveExternals(isResolving: WordBool); safecall;
		function  Get_preserveWhiteSpace: WordBool; safecall;
		procedure Set_preserveWhiteSpace(isPreserving: WordBool); safecall;
		procedure Set_onreadystatechange(Param1: OleVariant); safecall;
		procedure Set_ondataavailable(Param1: OleVariant); safecall;
		procedure Set_ontransformnode(Param1: OleVariant); safecall;
	public
		constructor Create(aLibXmlObj: xmlNodePtr);
	end;

	TXMLDOMDocumentType = class(TXMLDOMNode,
		IXMLDOMDocumentType)
	protected //IXMLDOMDocumentType
		function  IXMLDOMDocumentType.Get_name = Get_nodeName;
		function  Get_entities: IXMLDOMNamedNodeMap; safecall;
		function  Get_notations: IXMLDOMNamedNodeMap; safecall;
	end;

	TXMLDOMNotation = class(TXMLDOMNode,
		IXMLDOMNotation)
	protected //IXMLDOMNotation
		function  Get_publicId: OleVariant; safecall;
		function  Get_systemId: OleVariant; safecall;
	end;

	(**
	 * Abstract base class for NodeList and NamedNodeMap.
	 * @todo implement it as LIVE ! (needs feedback from libxml2)
	 *)
	TXMLDOMNodeCollection = class(TMyDispatch)
	private
	protected // implementation ready for NodeList and NamedNodeMap
		function  Get_item(index: Integer): IXMLDOMNode; safecall;
		function  Get_length: Integer; safecall;
		function  nextNode: IXMLDOMNode; safecall;
		procedure reset; safecall;
		function  Get__newEnum: IUnknown; safecall;
	public
	end;

	TChildNodeList = class(TXMLDOMNodeCollection,
		IXMLDOMNodeList)
	private
		FParentPtr: xmlNodePtr;
		FParent: TXMLDOMNode;
	protected //IXMLDOMNodeList
		function  Get_item(index: Integer): IXMLDOMNode; safecall;
		function  Get_length: Integer; safecall;
	private
		constructor Create(aParent: TXMLDOMNode);
	public
		destructor Destroy; override;
	end;

	TAttrNodeMap = class(TXMLDOMNodeCollection,
		IXMLDOMNamedNodeMap)
	private
		FParentPtr: xmlNodePtr;
		FParent: TXMLDOMElement;
	protected //IXMLDOMNamedNodeMap
		function  getNamedItem(const name: WideString): IXMLDOMNode; safecall;
		function  setNamedItem(const newItem: IXMLDOMNode): IXMLDOMNode; safecall;
		function  removeNamedItem(const name: WideString): IXMLDOMNode; safecall;
		function  getQualifiedItem(const baseName: WideString; const namespaceURI: WideString): IXMLDOMNode; safecall;
		function  removeQualifiedItem(const baseName: WideString; const namespaceURI: WideString): IXMLDOMNode; safecall;
	private
		constructor Create(aParent: TXMLDOMElement);
	public
		destructor Destroy; override;
	end;

	TNodeArray = class(TXMLDOMNodeCollection,
		IXMLDOMNodeList)
	private
		FItems: array of pointer;
	protected //IXMLDOMNodeList
		function  Get_item(index: Integer): IXMLDOMNode; safecall;
		function  Get_length: Integer; safecall;
	private
		constructor Create(aItems: xmlNodeSetPtr);
	public
		destructor Destroy; override;
	end;

function GetDOMObject(const aNode: pointer): IUnknown;

implementation

uses
{$ifdef VER130}
	d5utils,
{$endif}
	SysUtils;

procedure ENotImpl(aFunctionName: widestring);
begin
	raise Exception.CreateFmt('Function %s is not implemented yet', [aFunctionName]);
end;

function VarToDOMNode(const aVariant: OleVariant): IXMLDOMNode;
begin
	Result := IUnknown(TVarData(aVariant).VUnknown) as IXMLDOMNode;
end;

function GetNodePtr(aDOMNode: IXMLDOMNode): xmlNodePtr;
begin
	Result := (aDOMNode as ILibXml2Node).NodePtr;
end;

function GetDOMObject(const aNode: pointer): IUnknown;
var
	p: TUniNode absolute aNode;
begin
	if (aNode = nil) then begin
		Result := nil;
	end else if (nil = p.node._private) then begin
		case p.node.type_ of
		XML_ATTRIBUTE_NODE:
			Result := TXMLDOMAttribute.Create(p.node);
		XML_ELEMENT_NODE:
			Result := TXMLDOMElement.Create(p.node);
		XML_TEXT_NODE:
			Result := TXMLDOMText.Create(p.node);
		XML_CDATA_SECTION_NODE:
			Result := TXMLDOMElement.Create(p.node);
		XML_ENTITY_REF_NODE:
			Result := TXMLDOMEntityReference.Create(p.node);
		XML_ENTITY_NODE:
			Result := TXMLDOMEntity.Create(p.node);
		XML_PI_NODE:
			Result := TXMLDOMProcessingInstruction.Create(p.node);
		XML_COMMENT_NODE:
			Result := TXMLDOMComment.Create(p.node);
		XML_DOCUMENT_NODE:
			Result := TXMLDOMDocument.Create(p.node);
		XML_DOCUMENT_TYPE_NODE:
			Result := TXMLDOMDocumentType.Create(p.node);
//		XML_DOCUMENT_FRAG_NODE:
		XML_NOTATION_NODE:
			Result := TXMLDOMNotation.Create(p.node);
//		XML_HTML_DOCUMENT_NODE:
//		XML_DTD_NODE:
//		XML_ELEMENT_DECL:
//		XML_ATTRIBUTE_DECL:
//		XML_ENTITY_DECL:
//		XML_NAMESPACE_DECL:
//		XML_XINCLUDE_START:
//		XML_XINCLUDE_END:
{$ifdef LIBXML_DOCB_ENABLED}
//		XML_DOCB_DOCUMENT_NODE:
{$endif}
		end;
	end else begin
		Result := TXMLDOMNode(p.node._private) as IUnknown;
	end;
end;

{ TXMLDOMNode }

function TXMLDOMNode.appendChild(const newChild: IXMLDOMNode): IXMLDOMNode;
var
	cur: xmlNodePtr;
begin
	cur := GetNodePtr(newChild);
	xmlAddChild(FPtr.node, cur);
	Result := newChild;
end;

function TXMLDOMNode.cloneNode(deep: WordBool): IXMLDOMNode;
var
	node: xmlNodePtr;
begin
	if (deep) then begin
		node := xmlCopyNode(FPtr.node, 1);
	end else begin
		node := xmlCopyNode(FPtr.node, 0);
	end;
	Result := GetDOMObject(node) as IXMLDOMNode;
end;

constructor TXMLDOMNode.Create(aLibXmlObj: pointer);
begin
	FPtr.ptr := aLibXmlObj;
	if (aLibXmlObj<>nil) then begin
		pointer(FPtr.node._private) := self;
	end;
end;

destructor TXMLDOMNode.Destroy;
begin
	pointer(FPtr.node._private) := nil;
	inherited;
end;

function TXMLDOMNode.Get_attributes: IXMLDOMNamedNodeMap;
begin
	Result := nil;
end;

function TXMLDOMNode.Get_baseName: WideString;
var
	prefixSize: integer;
begin
	prefixSize := 0;
	if (FPtr.node.ns<>nil) then begin
		prefixSize := Length(FPtr.node.ns.prefix);
		if (prefixSize > 0) then Inc(prefixSize);
	end;
	Result := UTF8Decode(FPtr.node.name + prefixSize);
end;

function TXMLDOMNode.Get_dataType: OleVariant;
begin
	Result := null; //todo
end;

function TXMLDOMNode.Get_definition: IXMLDOMNode;
begin
	Result := nil; //todo
end;

function TXMLDOMNode.Get_firstChild: IXMLDOMNode;
begin
	Result := GetDOMObject(FPtr.node.children) as IXMLDOMNode;
end;

function TXMLDOMNode.Get_childNodes: IXMLDOMNodeList;
begin
	if FChildren_OnDemand=nil then begin
		case FPtr.node.type_ of
		XML_ELEMENT_NODE,
		XML_DOCUMENT_NODE:
			FChildren_OnDemand := TChildNodeList.Create(self);
		end;
	end;
	Result := FChildren_OnDemand;
end;

function TXMLDOMNode.Get_lastChild: IXMLDOMNode;
begin
	Result := GetDOMObject(FPtr.node.last) as IXMLDOMNode;
end;

function TXMLDOMNode.Get_namespaceURI: WideString;
begin
	Result := UTF8Decode(FPtr.node.ns.href);
end;

function TXMLDOMNode.Get_nextSibling: IXMLDOMNode;
begin
	Result := GetDOMObject(FPtr.node.next) as IXMLDOMNode;
end;

function TXMLDOMNode.Get_nodeName: WideString;
begin
	Result := UTF8Decode(FPtr.node.name);
end;

function TXMLDOMNode.Get_nodeType: DOMNodeType;
begin
	Result := FPtr.node.type_;
end;

function TXMLDOMNode.Get_nodeTypedValue: OleVariant;
begin
	ENotImpl('TXMLDOMNode.Get_nodeTypedValue');
end;

function TXMLDOMNode.Get_nodeTypeString: WideString;
begin
	case FPtr.node.type_ of
		XML_ATTRIBUTE_NODE:
			Result := 'attribute';
		XML_ELEMENT_NODE:
			Result := 'element';
		XML_TEXT_NODE:
			Result := 'text';
		XML_CDATA_SECTION_NODE:
			Result := 'cdata-section';
		XML_ENTITY_REF_NODE:
			Result := 'entity-reference';
		XML_ENTITY_NODE:
			Result := 'entity';
		XML_PI_NODE:
			Result := 'processing-instruction';
		XML_COMMENT_NODE:
			Result := 'comment';
		XML_DOCUMENT_NODE:
			Result := 'document';
		XML_DOCUMENT_TYPE_NODE:
			Result := 'doctype';
		XML_DOCUMENT_FRAG_NODE:
			Result := 'document-fragment';
		XML_NOTATION_NODE:
			Result := 'notation';
		XML_HTML_DOCUMENT_NODE:
			Result := '*html-document';
		XML_DTD_NODE:
			Result := '*dtd';
		XML_ELEMENT_DECL:
			Result := '*element-decl';
		XML_ATTRIBUTE_DECL:
			Result := '*attribute-decl';
		XML_ENTITY_DECL:
			Result := '*entity-decl';
		XML_NAMESPACE_DECL:
			Result := '*namespace-decl';
		XML_XINCLUDE_START:
			Result := '*xinclude-start';
		XML_XINCLUDE_END:
			Result := '*xinclude-end';
{$ifdef LIBXML_DOCB_ENABLED}
		XML_DOCB_DOCUMENT_NODE:
{$endif}
	else Result := '*unknown_'+IntToStr(FPtr.node.type_);
	end;
end;

function TXMLDOMNode.Get_nodeValue: OleVariant;
begin
	Result := UTF8Decode(xmlNodeGetContent(FPtr.node));
end;

function TXMLDOMNode.Get_ownerDocument: IXMLDOMDocument;
begin
	Result := GetDOMObject(xmlNodePtr(FPtr.node.doc)) as IXMLDOMDocument;
end;

function TXMLDOMNode.Get_parentNode: IXMLDOMNode;
begin
	Result := GetDOMObject(FPtr.node.parent) as IXMLDOMNode;
end;

function TXMLDOMNode.Get_parsed: WordBool;
begin
	result := false; //todo
end;

function TXMLDOMNode.Get_prefix: WideString;
begin
	Result := UTF8Decode(FPtr.node.ns.prefix);
end;

function TXMLDOMNode.Get_previousSibling: IXMLDOMNode;
begin
	Result := GetDOMObject(FPtr.node.prev) as IXMLDOMNode;
end;

function TXMLDOMNode.Get_specified: WordBool;
begin
	Result := true; //todo
end;

function TXMLDOMNode.Get_text: WideString;
begin
	Result := UTF8Decode(xmlNodeGetContent(FPtr.node));
end;

function TXMLDOMNode.Get_xml: WideString;
var
	buf: xmlOutputBufferPtr;
	p: PxmlChar;
	sz: integer;
	s: string;
begin
	if (FPtr.node^.type_=XML_DOCUMENT_NODE) then begin
		xmlDocDumpMemory(FPtr.doc, p, @sz);
		s := p;
		xmlFree(p);
	end else begin
		buf := xmlAllocOutputBuffer(nil);
		xmlNodeDump(buf.buffer, FPtr.node^.doc, FPtr.node, 0, 1);
		s := buf.buffer.content;
		xmlOutputBufferFlush(buf);
		xmlOutputBufferClose(buf);
	end;
	Result := s;
end;

function TXMLDOMNode.hasChildNodes: WordBool;
begin
	Result := FPtr.node.children <> nil;
end;

function TXMLDOMNode.insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode;
var
	child: xmlNodePtr;
	ref: xmlNodePtr;
begin
	if VarIsNull(refChild) then begin
		appendChild(newChild);
	end else begin
		child := GetNodePtr(newChild);
		ref := GetNodePtr(IXMLDOMNode(TVarData(refChild).VUnknown));
		xmlAddPrevSibling(ref, child);
	end;
	Result := newChild;
end;

function TXMLDOMNode.NodePtr: xmlNodePtr;
begin
	Result := FPtr.node;
end;

function TXMLDOMNode.removeChild(const childNode: IXMLDOMNode): IXMLDOMNode;
var
	node: xmlNodePtr;
begin
	node := GetNodePtr(childNode);
	xmlUnlinkNode(node);
end;

function TXMLDOMNode.replaceChild(const newChild, oldChild: IXMLDOMNode): IXMLDOMNode;
var
	old, cur: xmlNodePtr;
begin
	old := GetNodePtr(oldChild);
	cur := GetNodePtr(newChild);
	xmlReplaceNode(old, cur);
end;

function TXMLDOMNode.selectNodes(const queryString: WideString): IXMLDOMNodeList;
var
	s: string;
	ctxt: xmlXPathContextPtr;
	rv: xmlXPathObjectPtr;
begin
	ctxt := xmlXPathNewContext(FPtr.node.doc);
	s := queryString;
	rv := xmlXPathEval(PChar(s), ctxt);
	Result := nil;
	if (rv=nil) then exit;
	if (rv.type_ = XPATH_NODESET) then begin
		if (rv.nodesetval.nodeNr > 0) then begin
			Result := TNodeArray.Create(rv.nodesetval);
		end;
	end;
	xmlXPathFreeObject(rv);
end;

function TXMLDOMNode.selectSingleNode(const queryString: WideString): IXMLDOMNode;
var
	s: string;
	ctxt: xmlXPathContextPtr;
	rv: xmlXPathObjectPtr;
	node: xmlNodePtr;
begin
	ctxt := xmlXPathNewContext(FPtr.node.doc);
	s := queryString;
	rv := xmlXPathEval(PChar(s), ctxt);
	Result := nil;
	if (rv=nil) then exit;
	if (rv.type_ = XPATH_NODESET) then begin
		if (rv.nodesetval.nodeNr > 0) then begin
			node := rv.nodesetval.nodeTab^;
			Result := GetDOMObject(node) as IXMLDOMNode;
		end;
	end;
	xmlXPathFreeObject(rv);
end;

procedure TXMLDOMNode.Set_dataType(const dataTypeName: WideString);
begin
	ENotImpl('TXMLDOMNode.Set_dataType');
end;

procedure TXMLDOMNode.Set_nodeTypedValue(typedValue: OleVariant);
begin
	ENotImpl('TXMLDOMNode.Set_nodeTypedValue');
end;

procedure TXMLDOMNode.Set_nodeValue(value: OleVariant);
var
	s: string;
begin
	//todo: check node type
	s := VarToStr(value);
	xmlNodeSetContent(FPtr.node, PChar(s));
end;

procedure TXMLDOMNode.Set_text(const text: WideString);
var
	s: string;
begin
	//todo: check node type
	s := VarToStr(text);
	xmlNodeSetContent(FPtr.node, PChar(s));
end;

function TXMLDOMNode.transformNode(const stylesheet: IXMLDOMNode): WideString;
begin
	ENotImpl('TXMLDOMNode.transformNode');
end;

procedure TXMLDOMNode.transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant);
begin
	ENotImpl('TXMLDOMNode.transformNodeToObject');
end;

function TXMLDOMNode.Get_data: WideString;
begin
	Result := UTF8Decode(xmlNodeGetContent(FPtr.node));
end;

procedure TXMLDOMNode.Set_data(const data: WideString);
begin
	Set_nodeValue(data);
end;

{ TXMLDOMNodeCollection }

function TXMLDOMNodeCollection.Get__newEnum: IUnknown;
begin
	ENotImpl('TXMLDOMNodeCollection.Get__newEnum');
end;

function TXMLDOMNodeCollection.Get_item(index: Integer): IXMLDOMNode;
begin
	ENotImpl('TXMLDOMNodeCollection.Get_item');
end;

function TXMLDOMNodeCollection.Get_length: Integer;
begin
	ENotImpl('TXMLDOMNodeCollection.Get_length');
end;

function TXMLDOMNodeCollection.nextNode: IXMLDOMNode;
begin
	ENotImpl('TXMLDOMNodeCollection.nextNode');
end;

procedure TXMLDOMNodeCollection.reset;
begin
	ENotImpl('TXMLDOMNodeCollection.reset');
end;

{ TChildNodeList }

constructor TChildNodeList.Create(aParent: TXMLDOMNode);
begin
	inherited Create;
	FParent := aParent;
	FParentPtr := GetNodePtr(FParent);
end;

destructor TChildNodeList.Destroy;
begin
	FParent.FChildren_OnDemand := nil; //???
	inherited;
end;

function TChildNodeList.Get_item(index: Integer): IXMLDOMNode;
var
	i: integer;
	node: xmlNodePtr;
begin
	node := FParentPtr.children;
	for i:=0 to index-1 do begin
		node := node.next;
		if (nil=node) then begin
			raise Exception.Create('Index too high!');
		end;
	end;
	Result := GetDOMObject(node) as IXMLDOMNode;
end;

function TChildNodeList.Get_length: Integer;
var
	node: xmlNodePtr;
begin
	node := FParentPtr.children;
	Result := 0;
	while (node<>nil) do begin
		Inc(Result);
		node := node.next;
	end;
end;

{ TAttrNodeMap }

constructor TAttrNodeMap.Create(aParent: TXMLDOMElement);
begin
	inherited Create;
	FParent := aParent;
	FParentPtr := GetNodePtr(FParent);
end;

destructor TAttrNodeMap.Destroy;
begin
	FParent.FAttributes_OnDemand := nil;
	inherited;
end;

function TAttrNodeMap.getNamedItem(const name: WideString): IXMLDOMNode;
begin
	Result := FParent.getAttributeNode(name);
end;

function TAttrNodeMap.getQualifiedItem(const baseName, namespaceURI: WideString): IXMLDOMNode;
var
	attr: xmlAttrPtr;
	s, ns: string;
begin
	s := baseName;
	ns := namespaceURI;
	attr := xmlHasNsProp(FParentPtr, PChar(s), PChar(ns));
	Result := GetDOMObject(xmlNodePtr(attr)) as IXMLDOMNode;
end;

function TAttrNodeMap.removeNamedItem(const name: WideString): IXMLDOMNode;
begin
	FParent.removeAttribute(name);
end;

function TAttrNodeMap.removeQualifiedItem(const baseName, namespaceURI: WideString): IXMLDOMNode;
var
	attr: xmlAttrPtr;
	s, ns: string;
begin
	s := baseName;
	ns := namespaceURI;
	attr := xmlHasNsProp(FParentPtr, PChar(s), PChar(ns));
	xmlRemoveProp(attr);
	Result := GetDOMObject(xmlNodePtr(attr)) as IXMLDOMNode;
end;

function TAttrNodeMap.setNamedItem(const newItem: IXMLDOMNode): IXMLDOMNode;
begin
	Result := FParent.setAttributeNode(newItem as IXMLDOMAttribute);
end;

{ TNodeArray }

constructor TNodeArray.Create(aItems: xmlNodeSetPtr);
begin
	SetLength(FItems, aItems^.nodeNr);
	Move(aItems.nodeTab^, Addr(FItems[0])^, aItems^.nodeNr * sizeof (pointer));
end;

destructor TNodeArray.Destroy;
begin
	inherited;
end;

function TNodeArray.Get_item(index: Integer): IXMLDOMNode;
begin
	Result :=  GetDOMObject(FItems[index]) as IXMLDOMNode;
end;

function TNodeArray.Get_length: Integer;
begin
	Result := Length(FItems);
end;

{ TXMLDOMElement }

function TXMLDOMElement.Get_tagName: WideString;
begin
	Result := Get_nodeName;
end;

function TXMLDOMElement.getAttribute(const name: WideString): OleVariant;
var
	domnode: IXMLDOMNode;
begin
	domnode := getAttributeNode(name);
	if (nil=domnode) then begin
		Result := null;
	end else begin
		Result := domnode.nodeValue;
	end;
end;

function TXMLDOMElement.getAttributeNode(const name: WideString): IXMLDOMAttribute;
var
	attr: xmlAttrPtr;
	s: string;
begin
	s := name;
	attr := xmlHasProp(FPtr.node, PChar(s));
	Result := GetDOMObject(xmlNodePtr(attr)) as IXMLDOMAttribute;
end;

function TXMLDOMElement.Get_attributes: IXMLDOMNamedNodeMap;
begin
	if FAttributes_OnDemand=nil then begin
		FAttributes_OnDemand := TAttrNodeMap.Create(self);
	end;
	Result := FAttributes_OnDemand;
end;

function TXMLDOMElement.getElementsByTagName(const tagName: WideString): IXMLDOMNodeList;
begin
	ENotImpl('TXMLDOMElement.getElementsByTagName');
end;

procedure TXMLDOMElement.normalize;
begin
	ENotImpl('TXMLDOMElement.normalize');
end;

procedure TXMLDOMElement.removeAttribute(const name: WideString);
var
	attr: xmlAttrPtr;
	s: string;
begin
	s := name;
	attr := xmlHasProp(FPtr.node, PChar(s));
	xmlRemoveProp(attr);
end;

function TXMLDOMElement.removeAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute;
var
	attr: xmlAttrPtr;
begin
	attr := xmlAttrPtr(GetNodePtr(DOMAttribute));
	xmlRemoveProp(attr);
end;

procedure TXMLDOMElement.setAttribute(const name: WideString; value: OleVariant);
var
	s: string;
	v: string;
begin
	s := name;
	v := value;
	xmlSetProp(FPtr.node, PChar(s), PChar(v));
end;

function TXMLDOMElement.setAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute;
var
	attr: xmlAttrPtr;
	s: string;
	v: string;
begin
	s := DOMAttribute.name;
	attr := xmlHasProp(FPtr.node, PChar(s));
	if (attr=nil) then begin
		v := DOMAttribute.value;
		xmlSetProp(FPtr.node, PChar(s), PChar(v));
		Result := GetDOMObject(xmlNodePtr(attr)) as IXMLDOMAttribute;
	end else begin
		xmlAddChild(FPtr.node, xmlNodePtr(DOMAttribute)); //???
		Result := DOMAttribute;
	end;
end;

{ TXMLDOMDocument }

procedure TXMLDOMDocument.abort;
begin
	ENotImpl('TXMLDOMDocument.abort');
end;

constructor TXMLDOMDocument.Create(aLibXmlObj: xmlNodePtr);
begin
	inherited Create(aLibXmlObj);
	// we have to ensure that this node does not just disappear when all
	// object references are released, because it holds some data not present in
	// the underlying xmlDoc object. One way of doing this is to pretend that
	// one reference always exists.

	//todo: PROBLEM - therefore it will never be automaticaly destroyed... 
	_AddRef;
end;

function TXMLDOMDocument.createAttribute(const name: WideString): IXMLDOMAttribute;
var
	s: string;
	node: xmlAttrPtr;
begin
	s := name;
	node := xmlNewDocProp(FPtr.doc, PChar(s), nil);
	Result := GetDOMObject(node) as IXMLDOMAttribute;
end;

function TXMLDOMDocument.createCDATASection(const data: WideString): IXMLDOMCDATASection;
var
	s: string;
	node: xmlNodePtr;
begin
	s := data;
	node := xmlNewCDataBlock(FPtr.doc, PChar(s), -1);
	Result := GetDOMObject(node) as IXMLDOMCDataSection;
end;

function TXMLDOMDocument.createComment(const data: WideString): IXMLDOMComment;
var
	s: string;
	node: xmlNodePtr;
begin
	s := data;
	node := xmlNewDocComment(FPtr.doc, PChar(s));
	Result := GetDOMObject(node) as IXMLDOMComment;
end;

function TXMLDOMDocument.createDocumentFragment: IXMLDOMDocumentFragment;
var
	node: xmlNodePtr;
begin
	node := xmlNewDocFragment(FPtr.doc);
	Result := GetDOMObject(node) as IXMLDOMDocumentFragment;
end;

function TXMLDOMDocument.createElement(const tagName: WideString): IXMLDOMElement;
var
	s: string;
	node: xmlNodePtr;
begin
	s := tagName;
	node := xmlNewDocNode(requestDocPtr, nil, PChar(s), nil);
	Result := GetDOMObject(node) as IXMLDOMElement;
end;

function TXMLDOMDocument.createEntityReference(const name: WideString): IXMLDOMEntityReference;
var
	s: string;
	node: xmlNodePtr;
begin
	s := name;
	node := xmlNewReference(requestDocPtr, PChar(s));
	Result := GetDOMObject(node) as IXMLDOMEntityReference;
end;

function TXMLDOMDocument.createNode(type_: OleVariant; const name, namespaceURI: WideString): IXMLDOMNode;
begin
	ENotImpl('TXMLDOMDocument.createNode');
end;

function TXMLDOMDocument.createProcessingInstruction(const target, data: WideString): IXMLDOMProcessingInstruction;
var
	s, d: string;
	node: xmlNodePtr;
begin
	s := target;
	d := data;
	node := xmlNewPI(PChar(s), PChar(d));
	Result := GetDOMObject(node) as IXMLDOMProcessingInstruction;
end;

function TXMLDOMDocument.createTextNode(const data: WideString): IXMLDOMText;
var
	d: string;
	node: xmlNodePtr;
begin
	d := data;
	node := xmlNewDocText(requestDocPtr, PChar(d));
	Result := GetDOMObject(node) as IXMLDOMText;
end;

function TXMLDOMDocument.Get_async: WordBool;
begin
	ENotImpl('TXMLDOMDocument.Get_async');
end;

function TXMLDOMDocument.Get_doctype: IXMLDOMDocumentType;
begin
	ENotImpl('TXMLDOMDocument.Get_doctype');
end;

function TXMLDOMDocument.Get_documentElement: IXMLDOMElement;
var
	node: xmlNodePtr;
begin
	node := xmlDocGetRootElement(requestDocPtr);
	Result := GetDOMObject(node) as IXMLDOMElement;
end;

function TXMLDOMDocument.Get_implementation_: IXMLDOMImplementation;
begin
	ENotImpl('TXMLDOMDocument.Get_implementation_');
end;

function TXMLDOMDocument.Get_parseError: IXMLDOMParseError;
begin
	ENotImpl('TXMLDOMDocument.Get_parseError');
end;

function TXMLDOMDocument.Get_preserveWhiteSpace: WordBool;
begin
	ENotImpl('TXMLDOMDocument.Get_parseError');
end;

function TXMLDOMDocument.Get_readyState: Integer;
begin
	ENotImpl('TXMLDOMDocument.Get_readyState');
end;

function TXMLDOMDocument.Get_resolveExternals: WordBool;
begin
	ENotImpl('TXMLDOMDocument.Get_resolveExternals');
end;

function TXMLDOMDocument.Get_url: WideString;
var
	s: string;
begin
	s := requestDocPtr.URL;
	Result := s;
end;

function TXMLDOMDocument.Get_validateOnParse: WordBool;
begin
	ENotImpl('TXMLDOMDocument.Get_validateOnParse');
end;

function TXMLDOMDocument.getElementsByTagName(const tagName: WideString): IXMLDOMNodeList;
begin
	ENotImpl('TXMLDOMDocument.getElementsByTagName');
end;

function TXMLDOMDocument.load(xmlSource: OleVariant): WordBool;
var
	fn: string;
begin
	fn := xmlSource;
	releaseDocPtr;
	FPtr.doc := xmlParseFile(PChar(fn));
	//todo: update the ParseError object
end;

function TXMLDOMDocument.loadXML(const bstrXML: WideString): WordBool;
var
	s: string;
begin
	s := bstrXML;
	releaseDocPtr;
	FPtr.doc := xmlParseMemory(PChar(s), Length(s));
	//todo: update the ParseError object
end;

function TXMLDOMDocument.nodeFromID(const idString: WideString): IXMLDOMNode;
var
	s: string;
	attr: xmlAttrPtr;
begin
	s := idString;
	attr := xmlGetID(requestDocPtr, PChar(s));
	Result := GetDOMObject(attr.parent) as IXMLDOMNode;
end;

procedure TXMLDOMDocument.save(destination: OleVariant);
var
	fn: string;
	rv: integer;
begin
	//todo: handle stream (and perhaps other) variant types!
	case TVarData(destination).VType of
	varEmpty,
	varNull:
		begin
			rv := xmlSaveFile(requestDocPtr.URL, FPtr.doc);
		end;
	varString:
		begin
			fn := destination;
			rv := xmlSaveFile(PChar(fn), requestDocPtr);
		end;
	else
		rv := -1;
		ENotImpl('TXMLDOMDocument.save(unknown variant type)');
	end;
	if (rv < 0) then begin
		raise Exception.Create('Error while saving document'); //todo: DOMException
	end;
end;

procedure TXMLDOMDocument.Set_async(isAsync: WordBool);
begin
	ENotImpl('TXMLDOMDocument.Set_async');
end;

procedure TXMLDOMDocument.Set_documentElement(const DOMElement: IXMLDOMElement);
begin
	xmlDocSetRootElement(FPtr.doc, GetNodePtr(DOMElement));
end;

procedure TXMLDOMDocument.Set_ondataavailable(Param1: OleVariant);
begin
	ENotImpl('TXMLDOMDocument.Set_ondataavailable');
end;

procedure TXMLDOMDocument.Set_onreadystatechange(Param1: OleVariant);
begin
	ENotImpl('TXMLDOMDocument.Set_onreadystatechange');
end;

procedure TXMLDOMDocument.Set_ontransformnode(Param1: OleVariant);
begin
	ENotImpl('TXMLDOMDocument.Set_ontransformnode');
end;

procedure TXMLDOMDocument.Set_preserveWhiteSpace(isPreserving: WordBool);
begin
	ENotImpl('TXMLDOMDocument.Set_preserveWhiteSpace');
end;

procedure TXMLDOMDocument.Set_resolveExternals(isResolving: WordBool);
begin
	ENotImpl('TXMLDOMDocument.Set_resolveExternals');
end;

procedure TXMLDOMDocument.Set_validateOnParse(isValidating: WordBool);
begin
	ENotImpl('TXMLDOMDocument.Set_validateOnParse');
end;

procedure TXMLDOMDocument.releaseDocPtr;
begin
	if (FPtr.doc <> nil) then begin
		xmlFreeDoc(FPtr.doc);
		FPtr.doc := nil;
	end;
end;

function TXMLDOMDocument.requestDocPtr: xmlDocPtr;
begin
	if (FPtr.doc=nil) then begin
		FPtr.doc := xmlNewDoc(XML_DEFAULT_VERSION);
	end;
	Result := FPtr.doc;
end;

function TXMLDOMDocument.NodePtr: xmlNodePtr;
begin
	Result := xmlNodePtr(requestDocPtr);
end;

{ TXMLDOMCharacterData }

procedure TXMLDOMCharacterData.appendData(const data: WideString);
var
	s: string;
begin
	s := data;
	xmlNodeAddContent(FPtr.node, PChar(s));
end;

procedure TXMLDOMCharacterData.deleteData(offset, count: Integer);
begin
	replaceData(offset, count, '');
end;

function TXMLDOMCharacterData.Get_length: Integer;
begin
	Result := Length(Get_data);
end;

procedure TXMLDOMCharacterData.insertData(offset: Integer; const data: WideString);
begin
	replaceData(offset, 0, data);
end;

procedure TXMLDOMCharacterData.replaceData(offset, count: Integer; const data: WideString);
var
	s: widestring;
begin
	//todo: check bounds !
	//todo: needs testing
	s := Get_data;
	s := Copy(s, 1, offset) + data + Copy(s, offset + count, Length(s));   
	Delete(s, offset, count);
	Set_data(s);
end;

function TXMLDOMCharacterData.substringData(offset, count: Integer): WideString;
begin
	Result := Copy(Get_data, offset, count);
end;

{ TXMLDOMText }

function TXMLDOMText.splitText(offset: Integer): IXMLDOMText;
begin
	ENotImpl('TXMLDOMText.splitText');
end;

{ TXMLDOMEntity }

function TXMLDOMEntity.Get_notationName: WideString;
begin
	ENotImpl('TXMLDOMEntity.Get_notationName');
end;

function TXMLDOMEntity.Get_publicId: OleVariant;
begin
	Result := UTF8Decode(FPtr.entity.ExternalID);
end;

function TXMLDOMEntity.Get_systemId: OleVariant;
begin
	Result := UTF8Decode(FPtr.entity.SystemID);
end;

{ TXMLDOMDocumentType }

function TXMLDOMDocumentType.Get_entities: IXMLDOMNamedNodeMap;
begin
	ENotImpl('TXMLDOMDocumentType.Get_entities');
end;

function TXMLDOMDocumentType.Get_notations: IXMLDOMNamedNodeMap;
begin
	ENotImpl('TXMLDOMDocumentType.Get_notations');
end;

{ TXMLDOMNotation }

function TXMLDOMNotation.Get_publicId: OleVariant;
begin
	Result := UTF8Decode(FPtr.notation.PublicID);
end;

function TXMLDOMNotation.Get_systemId: OleVariant;
begin
	Result := UTF8Decode(FPtr.notation.SystemID);
end;

end.

