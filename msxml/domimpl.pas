unit domimpl;

interface

uses
	ComObj,
{$ifdef VER140}
	Variants,
{$endif}
	libxml2,
	MSXML_TLB,
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
	ILibXml2Node = interface ['{1D4BD646-0AB9-4810-B4BD-7277FB0CFA30}']
		function  NodePtr: xmlNodePtr;
	end;

	TXMLDOMNode = class (TMyDispatch,
		ILibXml2Node,
		IXMLDOMNode)
		FNode: xmlNodePtr;
	protected //ILibXml2Node
		function  NodePtr: xmlNodePtr;
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
		constructor Create(aNode: xmlNodePtr);
	public
		destructor Destroy; override;
	end;

	TXMLDOMElement = class(TXMLDOMNode)
		//todo
	end;

	TXMLDOMComment = class(TXMLDOMNode)
		//todo
	end;

	TXMLDOMText = class(TXMLDOMNode)
		//todo
	end;

	TXMLDOMProcessingInstruction = class(TXMLDOMNode)
		//todo
	end;

	TXMLDOMAttribute = class(TXMLDOMNode)
		//todo
	end;

	TXMLDOMEntityReference = class(TXMLDOMNode)
		//todo
	end;

	TXMLDOMEntity = class(TXMLDOMNode)
		//todo
	end;

	TXMLDOMDocument = class(TXMLDOMNode)
		//todo
	end;

	TXMLDOMDocumentType = class(TXMLDOMNode)
		//todo
	end;

	TXMLDOMNotation = class(TXMLDOMNode)
		//todo
	end;

	TListType = (LT_CHILDREN, LT_ATTRS, LT_OTHER);

	TXMLDOMNodeCollection = class(TMyDispatch)
	private
		FInitNode: xmlNodePtr;
		FList: array of pointer;
	protected // implementation ready for NodeList and NamedNodeMap
		function  Get_item(index: Integer): IXMLDOMNode; safecall;
		function  Get_length: Integer; safecall;
		function  nextNode: IXMLDOMNode; safecall;
		procedure reset; safecall;
		function  Get__newEnum: IUnknown; safecall;
	protected
		constructor Create(aNode: xmlNodePtr; aListType: TListType);
	public
		destructor Destroy; override;
	end;

	TXMLDOMNodeList = class(TXMLDOMNodeCollection,
		IXMLDOMNodeList)
	end;

	TXMLDOMNamedNodeMap = class(TXMLDOMNodeCollection,
		IXMLDOMNamedNodeMap)
	protected //IXMLDOMNamedNodeMap
		function  getNamedItem(const name: WideString): IXMLDOMNode; safecall;
		function  setNamedItem(const newItem: IXMLDOMNode): IXMLDOMNode; safecall;
		function  removeNamedItem(const name: WideString): IXMLDOMNode; safecall;
		function  getQualifiedItem(const baseName: WideString; const namespaceURI: WideString): IXMLDOMNode; safecall;
		function  removeQualifiedItem(const baseName: WideString; const namespaceURI: WideString): IXMLDOMNode; safecall;
	end;

procedure GetNodeObject(const aNode: xmlNodePtr; var aResult);

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

procedure GetNodeObject(const aNode: xmlNodePtr; var aResult);
begin
	if (aNode = nil) then begin
		IUnknown(aResult) := nil;
	end else if (nil = aNode._private) then begin
		case aNode.type_ of
		XML_ATTRIBUTE_NODE:
			IUnknown(aResult) := TXMLDOMAttribute.Create(aNode);
		XML_ELEMENT_NODE:
			IUnknown(aResult) := TXMLDOMElement.Create(aNode);
		XML_TEXT_NODE:
			IUnknown(aResult) := TXMLDOMText.Create(aNode);
		XML_CDATA_SECTION_NODE:
			IUnknown(aResult) := TXMLDOMElement.Create(aNode);
		XML_ENTITY_REF_NODE:
			IUnknown(aResult) := TXMLDOMEntityReference.Create(aNode);
		XML_ENTITY_NODE:
			IUnknown(aResult) := TXMLDOMEntity.Create(aNode);
		XML_PI_NODE:
			IUnknown(aResult) := TXMLDOMProcessingInstruction.Create(aNode);
		XML_COMMENT_NODE:
			IUnknown(aResult) := TXMLDOMComment.Create(aNode);
		XML_DOCUMENT_NODE:
			IUnknown(aResult) := TXMLDOMDocument.Create(aNode);
		XML_DOCUMENT_TYPE_NODE:
			IUnknown(aResult) := TXMLDOMDocumentType.Create(aNode);
//		XML_DOCUMENT_FRAG_NODE:
		XML_NOTATION_NODE:
			IUnknown(aResult) := TXMLDOMNotation.Create(aNode);
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
		IUnknown(aResult) := IUnknown(aNode._private);
	end;
end;

{ TXMLDOMNode }

function TXMLDOMNode.appendChild(const newChild: IXMLDOMNode): IXMLDOMNode;
var
	cur: xmlNodePtr;
begin
	cur := (newChild as ILibXml2Node).NodePtr;
	xmlAddChild(FNode, cur);
	Result := newChild;
end;

function TXMLDOMNode.cloneNode(deep: WordBool): IXMLDOMNode;
var
	node: xmlNodePtr;
begin
	if (deep) then begin
		node := xmlCopyNode(FNode, 1);
	end else begin
		node := xmlCopyNode(FNode, 0);
	end;
	GetNodeObject(node, Result);
end;

constructor TXMLDOMNode.Create(aNode: xmlNodePtr);
begin
	FNode := aNode;
	pointer(FNode._private) := self; // establish weak reference
end;

destructor TXMLDOMNode.Destroy;
begin
	pointer(FNode._private) := nil;  // remove weak reference
	inherited;
end;

function TXMLDOMNode.Get_attributes: IXMLDOMNamedNodeMap;
begin
	ENotImpl('');
end;

function TXMLDOMNode.Get_baseName: WideString;
begin
	Result := UTF8Decode(FNode.ns.prefix);
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
	GetNodeObject(FNode.children, Result);
end;

function TXMLDOMNode.Get_childNodes: IXMLDOMNodeList;
begin
	ENotImpl('');
end;

function TXMLDOMNode.Get_lastChild: IXMLDOMNode;
begin
	GetNodeObject(FNode.last, Result);
end;

function TXMLDOMNode.Get_namespaceURI: WideString;
begin
	Result := UTF8Decode(FNode.ns.href);
end;

function TXMLDOMNode.Get_nextSibling: IXMLDOMNode;
begin
	GetNodeObject(FNode.next, Result);
end;

function TXMLDOMNode.Get_nodeName: WideString;
begin
	Result := UTF8Decode(FNode.name);
end;

function TXMLDOMNode.Get_nodeType: DOMNodeType;
begin
	Result := FNode.type_;
end;

function TXMLDOMNode.Get_nodeTypedValue: OleVariant;
begin
	ENotImpl('');
end;

function TXMLDOMNode.Get_nodeTypeString: WideString;
begin
	case FNode.type_ of
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
	else Result := '*unknown_'+IntToStr(FNode.type_);
	end;
end;

function TXMLDOMNode.Get_nodeValue: OleVariant;
begin
	Result := UTF8Decode(xmlNodeGetContent(FNode));
end;

function TXMLDOMNode.Get_ownerDocument: IXMLDOMDocument;
begin
	GetNodeObject(xmlNodePtr(FNode.doc), Result);
end;

function TXMLDOMNode.Get_parentNode: IXMLDOMNode;
begin
	GetNodeObject(FNode.parent, Result);
end;

function TXMLDOMNode.Get_parsed: WordBool;
begin
	result := false; //todo
end;

function TXMLDOMNode.Get_prefix: WideString;
begin
	Result := UTF8Decode(FNode.ns.prefix);
end;

function TXMLDOMNode.Get_previousSibling: IXMLDOMNode;
begin
	GetNodeObject(FNode.prev, Result);
end;

function TXMLDOMNode.Get_specified: WordBool;
begin
	Result := true; //todo
end;

function TXMLDOMNode.Get_text: WideString;
begin
	ENotImpl('');
end;

function TXMLDOMNode.Get_xml: WideString;
begin
	ENotImpl('');
end;

function TXMLDOMNode.hasChildNodes: WordBool;
begin
	Result := FNode.children <> nil;
end;

function TXMLDOMNode.insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode;
var
	child: xmlNodePtr;
	ref: xmlNodePtr;
begin
	if VarIsNull(refChild) then begin
		appendChild(newChild);
	end else begin
		child := (newChild as ILibXml2Node).NodePtr;
		ref := (VarToDOMNode(refChild) as ILibXml2Node).NodePtr;
		xmlAddPrevSibling(ref, child);
	end;
	Result := newChild;
end;

function TXMLDOMNode.NodePtr: xmlNodePtr;
begin
	Result := FNode;
end;

function TXMLDOMNode.removeChild(const childNode: IXMLDOMNode): IXMLDOMNode;
var
	node: xmlNodePtr;
begin
	node := (childNode as ILibXml2Node).NodePtr;
	xmlRemoveNode(node);
end;

function TXMLDOMNode.replaceChild(const newChild, oldChild: IXMLDOMNode): IXMLDOMNode;
var
	old, cur: xmlNodePtr;
begin
	old := (oldChild as ILibXml2Node).NodePtr;
	cur := (newChild as ILibXml2Node).NodePtr;
	xmlReplaceNode(old, cur);
end;

function TXMLDOMNode.selectNodes(const queryString: WideString): IXMLDOMNodeList;
begin
	ENotImpl('');
end;

function TXMLDOMNode.selectSingleNode(const queryString: WideString): IXMLDOMNode;
begin
	ENotImpl('');
end;

procedure TXMLDOMNode.Set_dataType(const dataTypeName: WideString);
begin
	ENotImpl('');
end;

procedure TXMLDOMNode.Set_nodeTypedValue(typedValue: OleVariant);
begin
	ENotImpl('');
end;

procedure TXMLDOMNode.Set_nodeValue(value: OleVariant);
begin
	ENotImpl('');
end;

procedure TXMLDOMNode.Set_text(const text: WideString);
begin
	ENotImpl('');
end;

function TXMLDOMNode.transformNode(const stylesheet: IXMLDOMNode): WideString;
begin
	ENotImpl('');
end;

procedure TXMLDOMNode.transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant);
begin
	ENotImpl('');
end;

{ TXMLDOMNodeCollection }

function TXMLDOMNodeCollection.Get__newEnum: IUnknown;
begin
	ENotImpl('');
end;

function TXMLDOMNodeCollection.Get_item(index: Integer): IXMLDOMNode;
begin
end;

function TXMLDOMNodeCollection.Get_length: Integer;
begin

end;

function TXMLDOMNodeCollection.nextNode: IXMLDOMNode;
begin
	ENotImpl('');
end;

procedure TXMLDOMNodeCollection.reset;
begin
	ENotImpl('');
end;

constructor TXMLDOMNodeCollection.Create(aNode: xmlNodePtr; aListType: TListType);
begin
end;

destructor TXMLDOMNodeCollection.Destroy;
begin
	inherited;
end;

{ TXMLDOMNamedNodeMap }

function TXMLDOMNamedNodeMap.getNamedItem(const name: WideString): IXMLDOMNode;
begin

end;

function TXMLDOMNamedNodeMap.getQualifiedItem(const baseName, namespaceURI: WideString): IXMLDOMNode;
begin

end;

function TXMLDOMNamedNodeMap.removeNamedItem(const name: WideString): IXMLDOMNode;
begin

end;

function TXMLDOMNamedNodeMap.removeQualifiedItem(const baseName, namespaceURI: WideString): IXMLDOMNode;
begin

end;

function TXMLDOMNamedNodeMap.setNamedItem(const newItem: IXMLDOMNode): IXMLDOMNode;
begin

end;

end.

