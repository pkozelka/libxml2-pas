unit libxml_impl;
//$Id: libxml_impl.pas,v 1.2 2002-02-11 00:30:04 pkozelka Exp $
(*
 * Low-level utility functions needed for libxml-based implementation of DOM.
 *
 * Licensing: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * Developers:
 *   - the LIBXML2-PAS development team <libxml2-pas-devel@lists.sourceforge.net>
 *   namely
 *   - Petr Kozelka <pkozelka@email.cz>
 *   - Uwe Fechner <ufechner@csi.com>
 *)

interface

uses
  Classes,
  SysUtils,
  libxml_impl_utils,
  idom2,
  libxml2;

type
  TLDOMChildNodeList = class;

  { TLDOMObject }

  TLDOMObject = class(TInterfacedObject)
  protected
    function  returnNullDomNode: IDomNode;
    function  returnEmptyString: DomString;
    procedure DomAssert(aCondition: boolean; aErrorCode:integer; aMsg: WideString='');
    procedure checkName(aPrefix, aLocalName: String);
    procedure checkNsName(aPrefix, aLocalName, aNamespaceURI: String);
  public
    function SafeCallException(aExceptObject: TObject; aExceptAddr: Pointer): HRESULT; override;
  end;

  { TLDOMNode }

  TLDOMNodeClass = class of TLDOMNode;
  TLDOMNode = class(TLDOMObject, IDomNode, ILibXml2Node)
  protected //temporary!
    FGNode: xmlNodePtr;
    function  returnChildNodes: IDomNodeList;
  private
    FChildNodes: TLDOMChildNodeList; // non-counted reference
    function  isAncestorOrSelf(aNode:xmlNodePtr): boolean; //new
  protected //ILibXml2Node
    function  LibXml2NodePtr: xmlNodePtr;
  protected //IDomNode
    function  get_nodeName: DomString;
    function  get_nodeValue: DomString;
    procedure set_nodeValue(const value: DomString);
    function  get_nodeType: DOMNodeType;
    function  get_parentNode: IDomNode;
    function  get_childNodes: IDomNodeList;
    function  get_firstChild: IDomNode;
    function  get_lastChild: IDomNode;
    function  get_previousSibling: IDomNode;
    function  get_nextSibling: IDomNode;
    function  get_attributes: IDomNamedNodeMap;
    function  get_ownerDocument: IDomDocument; virtual;
    function  get_namespaceURI: DomString;
    function  get_prefix: DomString;
    procedure set_Prefix(const prefix : DomString);
    function  get_localName: DomString;
    function  insertBefore(const newChild, refChild: IDomNode): IDomNode;
    function  replaceChild(const newChild, oldChild: IDomNode): IDomNode;
    function  removeChild(const childNode: IDomNode): IDomNode;
    function  appendChild(const newChild: IDomNode): IDomNode;
    function  hasChildNodes: Boolean;
    function  hasAttributes : Boolean;
    function  cloneNode(deep: Boolean): IDomNode;
    procedure normalize;
    function  isSupported(const feature, version: DomString): Boolean;
  protected
    constructor Create(aLibXml2Node: pointer); virtual;
    function  requestNodePtr: xmlNodePtr; virtual;
  public
    property  GNode: xmlNodePtr read FGNode;
    destructor Destroy; override;
  end;

  { TLDOMChildNodeList }

  TLDOMChildNodeList = class(TLDOMObject, IDomNodeList)
  private
    FOwnerNode: TLDOMNode; // non-counted reference
  protected //IDomNodeList
    function get_item(index: Integer): IDomNode;
    function get_length: Integer;
  protected
    constructor Create(aOwnerNode: TLDOMNode);
  public
    destructor Destroy; override;
  end;

  TLDOMDocument = class(TLDOMNode)
  protected //tmp
    FFlyingNodes: TList;          // on-demand created list of nodes not attached to the document tree (=they have no parent)
  private
    FGDOMImpl: IDomImplementation;
    function  GetFlyingNodes: TList;
  protected //IDomDocument
    function  get_domImplementation: IDomImplementation;
  protected //
    property  FlyingNodes: TList read GetFlyingNodes;
  public
    destructor Destroy; override;
    property  DomImplementation: IDomImplementation read get_domImplementation write FGDOMImpl; // internal mean to 'setup' implementation
  end;

  TLDOMDocumentType = class(TLDOMNode)
  end;

//overridable implementations
var
  GlbNodeClasses: array[XML_ELEMENT_NODE..XML_ENTITY_DECL] of TLDOMNodeClass = (
    nil, //TGDOMElement,
    nil, //TGDOMAttr,
    nil, //TGDOMText,
    nil, //TGDOMCDataSection,
    nil, //TGDOMEntityReference,
    nil, //TGDOMEntity,
    nil, //TGDOMProcessingInstruction,
    nil, //TGDOMComment,
    nil, //TGDOMDocument,
    nil, //TGDOMDocumentType,
    nil, //TGDOMDocumentFragment,
    nil, //TGDOMNotation,
    nil, //TGDOMDocument,
    nil, //TGDOMDocumentType,
    nil,
    nil,
    nil //TGDOMEntity
  );


//temporarily exposed:
function  GetDomObject(aNode: pointer): IUnknown;
function  GetGNode(const aNode: IDomNode): xmlNodePtr;
procedure RegisterFlyingNode(aNode: xmlNodePtr);
procedure UnregisterFlyingNode(aNode: xmlNodePtr);

implementation

const
  IMPLEMENTATION_FEATURES: array [0..9] of DomString = (
    'CORE', '2.0',
    'CORE', '',
    'XML', '2.0',
    'XML', '1.0',
    'XML', '');
const
  DEFAULT_IMPL_FREE_THREADED = false;
var
  LDOMImplementation: array[boolean] of IDomImplementation = (nil, nil);

function GetDomObject(aNode: pointer): IUnknown;
var
  obj: TLDOMNode;
  node: xmlNodePtr;
  ok: boolean;
begin
  if aNode <> nil then begin
    node := xmlNodePtr(aNode);
    if (node._private=nil) then begin
      ok := (node.type_ >= Low(GlbNodeClasses))
        and (node.type_ <= High(GlbNodeClasses))
        and Assigned(GlbNodeClasses[node.type_]);
      DomAssert1(ok, INVALID_ACCESS_ERR, Format('LibXml2 node type "%d" is not supported', [node.type_]), 'GetDomObject()');
      obj := GlbNodeClasses[node.type_].Create(node); // this assigns node._private
      // notify the node that it has a wrapper already
    end else begin
      // wrapper is already created, use it
      // first check if there is not a garbage
      ok := (node.type_ >= Low(GlbNodeClasses))
        and (node.type_ <= High(GlbNodeClasses))
        and Assigned(GlbNodeClasses[node.type_]);
      DomAssert1(ok, INVALID_ACCESS_ERR, 'not a DOM wrapper', 'GetDomObject()');
      obj := node._private;
    end;
  end else begin
    obj := nil;
  end;
  Result := obj;
end;

function GetGNode(const aNode: IDomNode): xmlNodePtr;
begin
  DomAssert1(Assigned(aNode), INVALID_ACCESS_ERR, 'Node cannot be null', 'GetGNode()');
  Result := (aNode as ILibXml2Node).LibXml2NodePtr;
end;

(**
 * Registers a flying node in its document node's wrapper.
 * If the node is already registered, does nothing.
 * Nodes of type that cannot be registered are silently ignored.
 * This is called from TGDOMNode.Create when parent is nil.
 *)
procedure RegisterFlyingNode(aNode: xmlNodePtr);
var
  doc: TLDOMDocument;
begin
  DomAssert1(aNode<>nil, INVALID_ACCESS_ERR, '', 'RegisterFlyingNode()');
  DomAssert1(aNode.parent=nil, INVALID_STATE_ERR, 'Node has a parent, cannot be registered as flying', 'RegisterFlyingNode()');
  case aNode.type_ of
  XML_HTML_DOCUMENT_NODE,
  XML_DOCB_DOCUMENT_NODE,
  XML_DOCUMENT_NODE:
    ; //silently ignore
  else
    GetDOMObject(aNode.doc);  //temporary - ensure that the document's wrapper exists (though it should be almost unneccessary)
    doc := aNode.doc._private; //get the class internal interface
    if doc.FlyingNodes.IndexOf(aNode)<0 then begin
      doc.FlyingNodes.Add(aNode);
    end;
  end;
end;

(**
 * Unregisters the node from the owner document's wrapper.
 * Does not check if parent is already assigned.
 * Nothing happens if the node is not present in the registry.
 *)
procedure UnregisterFlyingNode(aNode: xmlNodePtr);
var
  doc: TLDOMDocument;
  idx: integer;
begin
  GetDOMObject(aNode.doc);  //temporary - ensure that the document's wrapper exists (though it should be almost unneccessary)
  doc := aNode.doc._private; //get the class internal interface
  idx := doc.FlyingNodes.IndexOf(aNode);
  if (idx>0) then begin
    doc.FlyingNodes.Delete(idx);
  end;
end;

{ TLDOMObject }

procedure TLDOMObject.DomAssert(aCondition: boolean; aErrorCode: integer; aMsg: WideString);
begin
  DomAssert1(aCondition, aErrorCode, aMsg, ClassName);
end;

procedure TLDOMObject.checkName(aPrefix, aLocalName: String);
begin
  if (aPrefix<>'') then begin
    DomAssert(isNCName(aPrefix), INVALID_CHARACTER_ERR, 'Invalid character in prefix: "'+aPrefix+'"');
  end;
  DomAssert(isNCName(aLocalName), INVALID_CHARACTER_ERR, 'Invalid character in local name: "'+aLocalName+'"');
end;

procedure TLDOMObject.checkNsName(aPrefix, aLocalName, aNamespaceURI: String);
begin
  if (aPrefix='') then begin
  end else if (aPrefix='xml') then begin
    DomAssert(aNamespaceURI=XML_NAMESPACE_URI, NAMESPACE_ERR, 'Invalid namespaceURI for prefix "xml": "'+aNamespaceURI+'"');
  end else if (aPrefix='xmlns') then begin
    DomAssert(aNamespaceURI=XMLNS_NAMESPACE_URI, NAMESPACE_ERR, 'Invalid namespaceURI for prefix "xmlns": "'+aNamespaceURI+'"');
  end else begin
    DomAssert(isNCName(aPrefix), INVALID_CHARACTER_ERR, 'Invalid character in prefix: "'+aPrefix+'"');
    DomAssert(aNamespaceURI<>'', NAMESPACE_ERR, 'Empty namespaceURI for prefix "'+aPrefix+'"');
  end;
  DomAssert(isNCName(aLocalName), INVALID_CHARACTER_ERR, 'Invalid character in local name: "'+aLocalName+'"');
end;

function TLDOMObject.returnEmptyString: DomString;
begin
  Result := '';
end;

function TLDOMObject.returnNullDomNode: IDomNode;
begin
  Result := nil;
end;

function TLDOMObject.SafeCallException(aExceptObject: TObject; aExceptAddr: Pointer): HRESULT;
begin
  Result := 0; //todo
end;

{ TLDOMNode }

(**
 * Appends a node at the end of childlist.
 * @param newChild  The node to add
 *
 * @return  the node added.
 *)
function TLDOMNode.appendChild(const newChild: IDomNode): IDomNode;
begin
  Result := insertBefore(newChild, nil);
end;

function TLDOMNode.cloneNode(deep: Boolean): IDomNode;
var
  node: xmlNodePtr;
  recursive: Integer;
begin
  if deep
  then recursive:= 1
  else recursive:= 0;
  node := xmlCopyNode(requestNodePtr, recursive);
  Result := GetDOMObject(node) as IDomNode;
end;

constructor TLDOMNode.Create(aLibXml2Node: pointer);
begin
  inherited Create;
  FGNode := aLibXml2Node;
  if not (self is TLDOMDocument) then begin
    // this node is not a document
    DomAssert(Assigned(aLibXml2Node), INVALID_ACCESS_ERR, 'TGDOMNode.Create: Cannot wrap null node');
    FGNode._private := self;

    if not (self is TLDOMDocumentType) then begin
      DomAssert(FGNode.doc<>nil, INVALID_ACCESS_ERR, 'TGDOMNode.Create: Cannot wrap node not attached to any document');
    end;
    if (FGNode.doc<>nil) then begin
      // if the node is flying, register it in the owner document
      if (FGNode.parent=nil) then begin
        RegisterFlyingNode(FGNode);
      end;
      // if this is not the document itself, pretend having a reference to the owner document.
      // This ensures that the document lives exactly as long as any wrapper node (created by this doc) exists
      get_ownerDocument._AddRef;
    end;
  end;
  Inc(GlbNodeCount);
end;

destructor TLDOMNode.Destroy;
begin
  if not (self is TLDOMDocument) then begin
    if (FGNode.doc<>nil) then begin
      // if this is not the document itself, release the pretended reference to the owner document:
      // This ensures that the document lives exactly as long as any wrapper node (created by this doc) exists
      get_ownerDocument._Release;
    end;
  end;
  if (FGNode<>nil) then begin
    FGNode._private := nil;
  end;
  FChildNodes.Free;
  Dec(GlbNodeCount);
  inherited Destroy;
end;

function TLDOMNode.get_attributes: IDomNamedNodeMap;
begin
  Result := nil;
end;

function TLDOMNode.get_firstChild: IDomNode;
begin
  if FGNode=nil then begin
    Result := nil;
  end else begin
    Result := GetDOMObject(FGNode.children) as IDomNode;
  end;
end;

function TLDOMNode.get_childNodes: IDomNodeList;
begin
  // classes that need to support childNodes
  // must redirect this VMT record to returnChildNodes
  Result := nil;
end;

function TLDOMNode.get_lastChild: IDomNode;
begin
  if FGNode=nil then begin
    Result := nil;
  end else begin
    Result := GetDOMObject(FGNode.last) as IDomNode;
  end;
end;

function TLDOMNode.get_localName: DomString;
begin
  Result := '';
  case FGNode.type_ of
  XML_ELEMENT_NODE,
  XML_ATTRIBUTE_NODE:
    // this is neccessary, because according to the dom2
    // specification localName has to be nil for nodes,
    // that don't have a namespace
    if (FGNode.ns <> nil) then begin
      Result := UTF8Decode(FGNode.name);
    end;
  end;
end;

function TLDOMNode.get_namespaceURI: DomString;
begin
  case FGNode.type_ of
  XML_ELEMENT_NODE,
  XML_ATTRIBUTE_NODE:
    begin
      if FGNode.ns=nil then exit;
      Result := UTF8Decode(FGNode.ns.href);
    end;
  else
    Result := '';
  end;
end;

function TLDOMNode.get_nextSibling: IDomNode;
begin
  Result := GetDOMObject(FGNode.next) as IDomNode;
end;

function TLDOMNode.get_nodeName: DomString;
begin
  case FGNode.type_ of
  XML_HTML_DOCUMENT_NODE,
  XML_DOCB_DOCUMENT_NODE,
  XML_DOCUMENT_NODE:
    Result := '#document';
  XML_CDATA_SECTION_NODE:
    Result := '#cdata-section';
  XML_DOCUMENT_FRAG_NODE:
    Result := '#document-fragment';
  XML_TEXT_NODE,
  XML_COMMENT_NODE:
    Result := '#'+UTF8Decode(FGNode.name);
  else
    Result := UTF8Decode(FGNode.name);
    if (FGNode.ns<>nil) and (FGNode.ns.prefix<>nil) then begin
      Result := UTF8Decode(FGNode.ns.prefix)+':'+Result;
    end;
  end;
end;

function TLDOMNode.get_nodeType: DOMNodeType;
begin
  Result := domNodeType(FGNode.type_);
end;

function TLDOMNode.get_nodeValue: DomString;
var
  p: PxmlChar;
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
      if (p<>nil) then begin
        Result := UTF8Decode(p);
        xmlFree(p);
      end;
    end;
  else
    Result := '';
  end;
end;

function TLDOMNode.get_ownerDocument: IDomDocument;
begin
  if FGNode=nil then begin
    Result := nil;
  end else begin
    Result := GetDOMObject(FGNode.doc) as IDomDocument;
  end;
end;

function TLDOMNode.get_parentNode: IDomNode;
begin
  Result := GetDOMObject(FGNode.parent) as IDomNode
end;

function TLDOMNode.get_prefix: DomString;
begin
  case FGNode.type_ of
  XML_ELEMENT_NODE,
  XML_ATTRIBUTE_NODE:
    begin
      if FGNode.ns=nil then exit;
      Result := UTF8Decode(FGNode.ns.prefix);
    end;
  end;
end;

function TLDOMNode.get_previousSibling: IDomNode;
begin
  Result := GetDOMObject(FGNode.prev) as IDomNode;
end;

function TLDOMNode.hasAttributes: Boolean;
begin
  Result := False;
end;

function TLDOMNode.hasChildNodes: Boolean;
begin
  Result := False;
  if FGNode=nil then exit;
  if FGNode.children=nil then exit;
  Result := True;
end;

function TLDOMNode.insertBefore(const newChild, refChild: IDomNode): IDomNode;
var
  node: xmlNodePtr;
  child: xmlNodePtr;
const
  CHILD_TYPES = [
    ELEMENT_NODE,
    TEXT_NODE,
    CDATA_SECTION_NODE,
    ENTITY_REFERENCE_NODE,
    PROCESSING_INSTRUCTION_NODE,
    COMMENT_NODE,
    DOCUMENT_TYPE_NODE,
    DOCUMENT_FRAGMENT_NODE,
    NOTATION_NODE
  ];
begin
  DomAssert(newChild<>nil, INVALID_ACCESS_ERR, 'TGDOMNode.insertBefore: cannot append null');
  DomAssert((newChild.nodeType in CHILD_TYPES), HIERARCHY_REQUEST_ERR, 'TGDOMNode.insertBefore: newChild cannot be inserted, nodetype = '+IntToStr(get_nodeType));
  DomAssert(not IsReadOnlyNode(requestNodePtr), NO_MODIFICATION_ALLOWED_ERR);
  if (requestNodePtr.type_=XML_DOCUMENT_NODE) and (newChild.nodeType = ELEMENT_NODE) then begin
    DomAssert((xmlDocGetRootElement(xmlDocPtr(FGNode))=nil), HIERARCHY_REQUEST_ERR, 'TGDOMNode.insertBefore: document already has a documentElement');
  end;

  child := GetGNode(newChild);
  DomAssert(not IsAncestorOrSelf(child), HIERARCHY_REQUEST_ERR);
  DomAssert(child.doc=FGNode.doc, WRONG_DOCUMENT_ERR, 'TGDOMNode.insertBefore: cannot insert a node from other document');
  DomAssert(not IsReadOnlyNode(child.parent), NO_MODIFICATION_ALLOWED_ERR, 'TGDOMNode.insertBefore: modification not allowed here');

  UnregisterFlyingNode(child);
  if (refChild=nil) then begin
    xmlUnlinkNode(child);
    node := xmlAddChild(FGNode, child);
  end else begin
    node := xmlAddPrevSibling(GetGNode(refChild), child);
  end;
  Result := GetDOMObject(node) as IDomNode;
end;

function TLDOMNode.isAncestorOrSelf(aNode: xmlNodePtr): boolean;
var
  node: xmlNodePtr;
begin
  node := FGNode;
  Result := True;
  while (node<>nil) do begin
    if (node=aNode) then exit;
    node := node.parent;
  end;
  Result := False;
end;

function TLDOMNode.isSupported(const feature, version: DomString): Boolean;
begin
//TODO!  Result := TLDOMImplementation.featureIsSupported(feature, version, IMPLEMENTATION_FEATURES);
end;

function TLDOMNode.LibXml2NodePtr: xmlNodePtr;
begin
  Result := FGNode;
end;

(**
 * @todo check carefully
 *)
procedure TLDOMNode.normalize;
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

function TLDOMNode.removeChild(const childNode: IDomNode): IDomNode;
var
  child: xmlNodePtr;
begin
  DomAssert(childNode<>nil, INVALID_CHARACTER_ERR, 'TGDOMNode.removeChild: childNode is null');
  child := GetGNode(childNode);
  xmlUnlinkNode(child);
  RegisterFlyingNode(child);
  Result := childNode;
end;

function TLDOMNode.replaceChild(const newChild, oldChild: IDomNode): IDomNode;
var
  old, cur, node: xmlNodePtr;
begin
  DomAssert(oldChild<>nil, INVALID_CHARACTER_ERR, 'TGDOMNode.replaceChild: oldChild is null');
  DomAssert(newChild<>nil, INVALID_CHARACTER_ERR, 'TGDOMNode.replaceChild: newChild is null');
  old := GetGNode(oldChild);
  cur := GetGNode(newChild);
  node := xmlReplaceNode(old, cur);
  RegisterFlyingNode(old);
  UnregisterFlyingNode(cur);
  Result := GetDOMObject(node) as IDomNode
end;

function TLDOMNode.requestNodePtr: xmlNodePtr;
begin
  DomAssert(FGNode<>nil, INVALID_ACCESS_ERR, ClassName+'.requestNodePtr: wrapping null node');
  Result := FGNode;
end;

function TLDOMNode.returnChildNodes: IDomNodeList;
begin
  if (FChildNodes=nil) then begin
    TLDOMChildNodeList.Create(self); // assigns FChildNodes
  end;
  Result := FChildNodes;
end;

procedure TLDOMNode.set_nodeValue(const value: DomString);
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
    DomAssert(false, NO_MODIFICATION_ALLOWED_ERR);
  end;
end;

procedure TLDOMNode.set_Prefix(const prefix: DomString);
begin
  DomAssert(false, NOT_SUPPORTED_ERR);
end;

{ TLDOMChildNodeList }

constructor TLDOMChildNodeList.Create(aOwnerNode: TLDOMNode);
begin
  inherited Create;
  DomAssert(aOwnerNode<>nil, HIERARCHY_REQUEST_ERR, 'Child list must have a parent');
  FOwnerNode := aOwnerNode;
  FOwnerNode.FChildNodes := self;
  FOwnerNode._AddRef; //as long as the list exists, its owner must exist too
end;

destructor TLDOMChildNodeList.Destroy;
begin
  FOwnerNode.FChildNodes := nil;
  FOwnerNode._Release;
  FOwnerNode := nil;
  inherited Destroy;
end;

function TLDOMChildNodeList.get_item(index: Integer): IDomNode;
var
  node: xmlNodePtr;
  cnt: integer;
begin
  DomAssert(index>=0, INDEX_SIZE_ERR);
  node := FOwnerNode.requestNodePtr.children;
  cnt := 0;
  while (cnt<index) do begin
    if (node=nil) then begin
      DomAssert(false, INDEX_SIZE_ERR, Format('Trying to access item %d [zero based] of %d items', [index, cnt]));
    end;
    Inc(cnt);
    node := node.next;
  end;
  Result := GetDOMObject(node) as IDomNode;
end;

function TLDOMChildNodeList.get_length: Integer;
var
  node: xmlNodePtr;
begin
  Result := 0;
  node := FOwnerNode.GNode.children;
  while (node<>nil) do begin
    Inc(Result);
    node := node.next;
  end;
end;

{ TLDOMDocument }

destructor TLDOMDocument.Destroy;
begin
  Dec(GlbDocCount);
  FFlyingNodes.Free;
  FFlyingNodes := nil;
  inherited Destroy;
end;

function TLDOMDocument.GetFlyingNodes: TList;
begin
  if FFlyingNodes=nil then begin
    FFlyingNodes := TList.Create;
  end;
  Result := FFlyingNodes;
end;

function TLDOMDocument.get_domImplementation: IDomImplementation;
begin
  if FGDOMImpl=nil then begin
//TODO!    FGDOMImpl := TGDOMImplementation.getInstance(DEFAULT_IMPL_FREE_THREADED);
  end;
  Result := FGDOMImpl;
end;

end.

