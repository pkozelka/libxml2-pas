unit libxmldom;

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
uses classes,dom2,libxml2,conapp,sysutils;

const

  SLIBXML = 'LIBXML';  { Do not localize }

type

{ TGDOMInterface }
  WordBool=boolean;

  TGDOMInterface = class(TInterfacedObject)
  public
    function SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HRESULT; override;
  end;

{ TGDOMImplementation }

  TGDOMImplementation = class(TGDOMInterface, IDOMImplementation)
  private
    //FGDOMImpl: IXMLDOMImplementation;
    //FPGdomimpl: PGdomeDOMImplementation;
  protected
     { IDOMImplementation }
    function hasFeature(const feature, version: DOMString): WordBool;
    function createDocumentType(const qualifiedName, publicId,
      systemId: DOMString): IDOMDocumentType;
    function createDocument(const namespaceURI, qualifiedName: DOMString;
      doctype: IDOMDocumentType): IDOMDocument; 
  public
    constructor Create;
    destructor Destroy; override;
    //property PGDOMImpl: PGdomeDOMImplementation read FPGdomimpl;
  end;

  { IXMLDOMNodeRef }

  IXMLDOMNodeRef = interface
  ['{7787A532-C8C8-4F3C-9529-29098FE954B0}']
    function GetGDOMNode: xmlNodePtr;
  end;

 TGDOMNodeClass = class of TGDOMNode;

 TGDOMNode = class(TGDOMInterface, IDOMNode, IXMLDOMNodeRef,IDOMNodeSelect)
  private
    FGNode: xmlNodePtr;
    FOwnerDocument: IDOMDocument;
  protected
    function GetGDOMNode: xmlNodePtr; //new
    // IDOMNode
    function get_nodeName: DOMString;
    function get_nodeValue: DOMString;
    procedure set_nodeValue(const value: DOMString);
    function get_nodeType: DOMNodeType;
    function get_parentNode: IDOMNode;
    function get_childNodes: IDOMNodeList;
    function get_firstChild: IDOMNode;
    function get_lastChild: IDOMNode;
    function get_previousSibling: IDOMNode;
    function get_nextSibling: IDOMNode;
    function get_attributes: IDOMNamedNodeMap;
    function get_ownerDocument: IDOMDocument;
    function get_namespaceURI: DOMString;
    function get_prefix: DOMString;
    procedure set_Prefix(const prefix : DomString);
    function get_localName: DOMString;
    function insertBefore(const newChild, refChild: IDOMNode): IDOMNode;
    function replaceChild(const newChild, oldChild: IDOMNode): IDOMNode;
    function removeChild(const childNode: IDOMNode): IDOMNode;
    function appendChild(const newChild: IDOMNode): IDOMNode;
    function hasChildNodes: WordBool;
    function  hasAttributes : WordBool;
    function cloneNode(deep: WordBool): IDOMNode;
    procedure normalize;
    //function supports(const feature, version: DOMString): WordBool;
    function isSupported(const feature, version: DOMString): WordBool;
    { IDOMNodeSelect }
    function selectNode(const nodePath: WideString): IDOMNode;
    function selectNodes(const nodePath: WideString): IDOMNodeList;
  public
    constructor Create(ANode: xmlNodePtr;ADocument:IDOMDocument;parentnode:boolean=false);
    destructor destroy; override;
    property GNode: xmlNodePtr read FGNode;
  end;

  //xmlNodePtrList=xmlNodePtr;
  PGDomeNamedNodeMap=Pointer;

  TGDOMNodeList = class(TGDOMInterface, IDOMNodeList)
  private
     FParent: xmlNodePtr;
     FXPathList: xmlNodeSetPtr;
     FOwnerDocument: IDOMDocument;
  protected
    { IDOMNodeList }
    function get_item(index: Integer): IDOMNode;
    function get_length: Integer;
  public
    constructor Create(AParent: xmlNodePtr;ADocument:IDOMDocument); overload;
    constructor Create(AXpathNodeList: xmlNodeSetPtr;ADocument:IDOMDocument); overload;
    destructor destroy; override;
  end;

  TGDOMNamedNodeMap = class(TGDOMInterface, IDOMNamedNodeMap)
  // this class is used for attributes, entities and notations
  private
    FGNamedNodeMap: xmlNodePtr;
    FOwnerDocument: IDOMDocument;
  protected
    { IDOMNamedNodeMap }
    function get_item(index: Integer): IDOMNode;
    function get_length: Integer;
    function getNamedItem(const name: DOMString): IDOMNode;
    function setNamedItem(const newItem: IDOMNode): IDOMNode;
    function removeNamedItem(const name: DOMString): IDOMNode;
    function getNamedItemNS(const namespaceURI, localName: DOMString): IDOMNode;
    function setNamedItemNS(const newItem: IDOMNode): IDOMNode;
    function removeNamedItemNS(const namespaceURI, localName: DOMString): IDOMNode; 
  public
    constructor Create(ANamedNodeMap: xmlNodePtr; AOwnerDocument: IDOMDocument);
    destructor destroy; override;
    property GNamedNodeMap: xmlNodePtr read FGNamedNodeMap;
  end;

  { TGDOMAttr }

  TGDOMAttr = class(TGDOMNode, IDOMAttr)
  private
    //ns:
    function GetGAttribute: xmlAttrPtr;
  protected
    { Property Get/Set }
    function get_name: DOMString;
    function get_specified: WordBool;
    function get_value: DOMString;
    procedure set_value(const attributeValue: DOMString);
    function get_ownerElement: IDOMElement;
    { Properties }
    property name: DOMString read get_name;
    property specified: WordBool read get_specified;
    property value: DOMString read get_value write set_value;
    property ownerElement: IDOMElement read get_ownerElement;
  public
    property GAttribute: xmlAttrPtr read GetGAttribute;
    constructor Create(AAttribute: xmlAttrPtr;ADocument:IDOMDocument);
    destructor destroy; override;
  end;

  PGDomeCharacterData=Pointer;

  TGDOMCharacterData = class(TGDOMNode, IDOMCharacterData)
  private
    function GetGCharacterData: PGDomeCharacterData;
  protected
    { IDOMCharacterData }
    function get_data: DOMString;
    procedure set_data(const data: DOMString);
    function get_length: Integer;
    function substringData(offset, count: Integer): DOMString;
    procedure appendData(const data: DOMString);
    procedure insertData(offset: Integer; const data: DOMString);
    procedure deleteData(offset, count: Integer);
    procedure replaceData(offset, count: Integer; const data: DOMString);
  public
    constructor Create(ACharacterData: xmlNodePtr;ADocument:IDOMDocument);
    destructor destroy; override;
    property GCharacterData: PGDomeCharacterData read GetGCharacterData;
  end;

  { TGDOMElement }

  TGDOMElement = class(TGDOMNode, IDOMElement)
  private
    function GetGElement: xmlElementPtr;
  protected
    // IDOMElement
    function get_tagName: DOMString;
    function getAttribute(const name: DOMString): DOMString;
    procedure setAttribute(const name, value: DOMString);
    procedure removeAttribute(const name: DOMString);
    function getAttributeNode(const name: DOMString): IDOMAttr;
    function setAttributeNode(const newAttr: IDOMAttr): IDOMAttr;
    function removeAttributeNode(const oldAttr: IDOMAttr):IDOMAttr;
    function getElementsByTagName(const name: DOMString): IDOMNodeList;
    function getAttributeNS(const namespaceURI, localName: DOMString): DOMString;
    procedure setAttributeNS(const namespaceURI, qualifiedName, value: DOMString);
    procedure removeAttributeNS(const namespaceURI, localName: DOMString);
    function getAttributeNodeNS(const namespaceURI, localName: DOMString): IDOMAttr;
    function setAttributeNodeNS(const newAttr: IDOMAttr): IDOMAttr;
    function getElementsByTagNameNS(const namespaceURI,
      localName: DOMString): IDOMNodeList;
    function hasAttribute(const name: DOMString): WordBool; 
    function hasAttributeNS(const namespaceURI, localName: DOMString): WordBool;
    procedure normalize;
  public
    constructor Create(AElement: xmlElementPtr;ADocument:IDOMDocument);
    destructor destroy; override;
    property GElement: xmlElementPtr read GetGElement;
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

  PGdomeDocumentType=Pointer;
  PGdomeDomImplementation=Pointer;

  TGDOMDocumentType = class(TGDOMNode, IDOMDocumentType)
  private
    function GetGDocumentType: PGDomeDocumentType;
  protected
    { IDOMDocumentType }
    function get_name: DOMString; 
    function get_entities: IDOMNamedNodeMap; 
    function get_notations: IDOMNamedNodeMap; 
    function get_publicId: DOMString; 
    function get_systemId: DOMString; 
    function get_internalSubset: DOMString; 
  public
    property GDocumentType: PGdomeDocumentType read GetGDocumentType;
    constructor Create(PGDOMImplementation:PGdomeDOMImplementation;
         const qualifiedName, publicID, systemID: DOMString);
    destructor destroy; override;
  end;

  { TMSDOMNotation }
  PGdomeNotation=xmlNotationPtr;

  TGDOMNotation = class(TGDOMNode, IDOMNotation)
  private
    function GetGNotation: PGdomeNotation;
  protected
    { IDOMNotation }
    function get_publicId: DOMString; 
    function get_systemId: DOMString; 
  public
    property GNotation: PGdomeNotation read GetGNotation;
  end;

  PGdomeEntity=Pointer;

  TGDOMEntity = class(TGDOMNode, IDOMEntity)
  private
    function GetGEntity: PGdomeEntity;
  protected
    { IDOMEntity }
    function get_publicId: DOMString; 
    function get_systemId: DOMString; 
    function get_notationName: DOMString; 
  public
    property GEntity: PGdomeEntity read GetGEntity;
  end;

  TGDOMEntityReference = class(TGDOMNode, IDOMEntityReference)
  end;

  { TGDOMProcessingInstruction }

  PGdomeProcessingInstruction=Pointer;

  TGDOMProcessingInstruction = class(TGDOMNode, IDOMProcessingInstruction)
  private
    function GetGProcessingInstruction: PGdomeProcessingInstruction;
  protected
    { IDOMProcessingInstruction }
    function get_target: DOMString; 
    function get_data: DOMString; 
    procedure set_data(const value: DOMString);
  public
    property GProcessingInstruction: PGdomeProcessingInstruction read GetGProcessingInstruction;
  end;

  TGDOMDocument = class(TGDOMNode, IDOMDocument, IDOMParseOptions, IDOMPersist)
  private
    FGDOMImpl: IDOMImplementation;
    FPGdomeDoc: xmlDocPtr;
    FAsync: boolean;     //for compatibility, not really supported
    FpreserveWhiteSpace: boolean; //difficult to support
    FresolveExternals: boolean; //difficult to support
    Fvalidate: boolean;  //check if default is ok
  protected
    // IDOMDocument
    function get_doctype: IDOMDocumentType; 
    function get_domImplementation: IDOMImplementation; 
    function get_documentElement: IDOMElement; 
    procedure set_documentElement(const IDOMElement: IDOMElement);
    function createElement(const tagName: DOMString): IDOMElement; 
    function createDocumentFragment: IDOMDocumentFragment; 
    function createTextNode(const data: DOMString): IDOMText; 
    function createComment(const data: DOMString): IDOMComment; 
    function createCDATASection(const data: DOMString): IDOMCDATASection; 
    function createProcessingInstruction(const target,
      data: DOMString): IDOMProcessingInstruction; 
    function createAttribute(const name: DOMString): IDOMAttr; 
    function createEntityReference(const name: DOMString): IDOMEntityReference;
    function getElementsByTagName(const tagName: DOMString): IDOMNodeList;
    function importNode(importedNode: IDOMNode; deep: WordBool): IDOMNode;
    function createElementNS(const namespaceURI,
      qualifiedName: DOMString): IDOMElement;
    function createAttributeNS(const namespaceURI,
      qualifiedName: DOMString): IDOMAttr;
    function getElementsByTagNameNS(const namespaceURI,
      localName: DOMString): IDOMNodeList; 
    function getElementById(const elementId: DOMString): IDOMElement;
    // IDOMParseOptions
    function get_async: Boolean;
    function get_preserveWhiteSpace: Boolean;
    function get_resolveExternals: Boolean;
    function get_validate: Boolean;
    procedure set_async(Value: Boolean);
    procedure set_preserveWhiteSpace(Value: Boolean);
    procedure set_resolveExternals(Value: Boolean);
    procedure set_validate(Value: Boolean);
    // IDOMPersist
    function get_xml: DOMString; 
    function asyncLoadState: Integer; 
    function load(source: OleVariant): WordBool; 
    function loadFromStream(const stream: TStream): WordBool; 
    function loadxml(const Value: DOMString): WordBool; 
    procedure save(destination: OleVariant); 
    procedure saveToStream(const stream: TStream); 
    procedure set_OnAsyncLoad(const Sender: TObject;
      EventHandler: TAsyncEventHandler); 
  public
    constructor Create(
         GDOMImpl:IDOMImplementation;
      const namespaceURI, qualifiedName: DOMString;
      doctype: IDOMDocumentType);
    destructor destroy; override;
  end;

  { TMSDOMDocumentFragment }

  TGDOMDocumentFragment = class(TGDOMNode, IDOMDocumentFragment)
  end;

 { TGDOMImplementationFactory }
 (* TGDOMImplementationFactory = class(TDOMVendor)
  public
    function DOMImplementation: IDOMImplementation; override;
    function Description: String; override;
  end; *)

  TGDOMDocumentBuilderFactory = class(TInterfacedObject, IDomDocumentBuilderFactory)
  private
    FFreeThreading : Boolean;

  public
    constructor Create(AFreeThreading : Boolean);

    function NewDocumentBuilder : IDomDocumentBuilder;
    function Get_VendorID : DomString;
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
    function load(const url : DomString) : IDomDocument;
  end;

  PGdomeDomString=string;

  TGDOMString = class
  private
    CString:pchar;
  public
    constructor create(ADOMString:DOMString);
    destructor destroy; override;
  end;

  TGDOMNameSpace = class
  private
    NS:xmlNSPtr;
    localName: TGdomString;
  public
    constructor create(node:xmlNodePtr;namespaceURI,qualifiedName: DOMString);
    destructor destroy; override;
  end;

var
  //LIBXML_DOM: TGDOMImplementationFactory;
  LIBXML_DOM: IDomDocumentBuilderFactory;
  doccount: integer=0;
  domcount: integer=0;
  nodecount: integer=0;
  elementcount: integer=0;
  node,temp2: xmlNodePtr;

function GetGNode(const Node: IDOMNode): xmlNodePtr;

procedure CheckError(err:integer);

function ErrorString(err:integer):string;

implementation

Type GDomeException=Integer;

resourcestring
  SNodeExpected = 'Node cannot be null';
  SGDOMNotInstalled = 'GDOME2 is not installed';

function MakeNode(Node: xmlNodePtr;ADocument:IDOMDocument): IDOMNode;
const
  NodeClasses: array[ELEMENT_NODE..NOTATION_NODE] of TGDOMNodeClass =
    (TGDOMElement, TGDOMAttr, TGDOMText, TGDOMCDataSection,
     TGDOMEntityReference, TGDOMEntity ,TGDOMProcessingInstruction,
     TGDOMComment, TGDOMDocument, TGDOMDocumentType, TGDOMDocumentFragment,
     TGDOMNotation);
var
  nodeType: integer;
begin
  if Node <> nil
    then begin
      nodeType:=Node.type_;
      Result := NodeClasses[nodeType].Create(Node,ADocument)
    end
    else Result := nil;
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

function libxmlStringToString(libstring:pchar):String;
  var s: string;
  begin
    if libstring<>nil
      then begin
        s := libstring;
        result:= s;
      end
      else result:='';
  end;

{ TGDOMImplementationFactory }

(*
function TGDOMImplementationFactory.DOMImplementation: IDOMImplementation;
begin
  Result := TGDOMImplementation.Create;
end;

function TGDOMImplementationFactory.Description: String;
begin
  Result := SLIBXML;
end;
*)

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

function TGDOMImplementation.hasFeature(const feature, version: DOMString): WordBool;
begin
  result:=false;
end;

function TGDOMInterface.SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HRESULT;
begin
  result:=0;
end;

function TGDOMImplementation.createDocumentType(const qualifiedName, publicId,
                systemId: DOMString): IDOMDocumentType; 
begin
  //Result := TGDOMDocumentType.Create(qualifiedName,publicId, systemID) as IDOMDocumentType;
end;

function TGDOMImplementation.createDocument(const namespaceURI, qualifiedName: DOMString;
      doctype: IDOMDocumentType): IDOMDocument; 
begin
  Result := TGDOMDocument.Create(self,namespaceURI, qualifiedName,doctype) as IDOMDocument;
end;

constructor TGDomImplementation.Create;

begin
  inherited Create;
end;

destructor TGDomImplementation.Destroy;
begin
  inherited Destroy;
end;

// *************************************************************
// TGDomeNode Implementation
// *************************************************************

function TGDOMNode.GetGDOMNode: xmlNodePtr;
begin
  result:=FGNode;
end;

// IDOMNode
function TGDOMNode.get_nodeName: DOMString; 
var
  temp,prefix: String;
begin
  prefix:='';
  case FGNode.type_ of
    //todo: check the result for the other nodetypes
    3: temp:='#text';
    9: temp:='#document';
  else
    begin
      temp:=FGNode.name;
      if FGNode.ns<>nil
        then prefix:=libxmlstringtostring(FGNode.ns.prefix)+':'
        else prefix:='';
    end;
  end;
  result:=prefix+temp;
end;

function TGDOMNode.get_nodeValue: DOMString; 
var
  temp: string;
  temp1:pchar;
begin
  if FGNode.type_=ATTRIBUTE_NODE
    then begin
      if FGNode.children<>nil then
        temp1:=FGNode.children.content
      else
        temp1:=nil;
    end
    else temp1:=FGNode.content;
  temp:=libxmlStringToString(temp1);
  result:=temp;
end;

procedure TGDOMNode.set_nodeValue(const value: DOMString);
var
  temp: TGdomString;
  attr: xmlAttrPtr;
begin
  temp:=TGdomString.create(value);
  if FGNode.type_=ATTRIBUTE_NODE then begin
    attr:=xmlNewProp(nil,FGNode.name,temp.CString);
    node:=xmlNodePtr(attr);
    temp2:=node.children;
    temp2:=FGNode;
    FGNode:=node;
    xmlUnlinkNode(temp2);
    if temp2<>nil then xmlFreeProp(xmlAttrPtr(temp2));
  end
  else
    xmlNodeSetContent(FGNode,temp.CString);
  temp.free;
end;

function TGDOMNode.get_nodeType: DOMNodeType; 
begin
  result:=domOrdToNodeType(FGNode.type_);
end;

function TGDOMNode.get_parentNode: IDOMNode; 
var node: xmlNodePtr;
begin
  node:=FGNode.parent;
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
end;

function TGDOMNode.get_childNodes: IDOMNodeList; 
var
  Parent: xmlNodePtr;
begin
  Parent:=FGNode;
  result:=TGDOMNodeList.Create(Parent,FOwnerDocument) as IDOMNodeList;
end;

function TGDOMNode.get_firstChild: IDOMNode; 
var node: xmlNodePtr;
begin
  node:=FGNode.children; //firstChild
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
end;

function TGDOMNode.get_lastChild: IDOMNode; 
var node: xmlNodePtr;
begin
  node:=FGNode.last; //lastChild
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
end;

function TGDOMNode.get_previousSibling: IDOMNode; 
var node: xmlNodePtr;
begin
  node:=FGNode.prev;
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
end;

function TGDOMNode.get_nextSibling: IDOMNode; 

var node: xmlNodePtr;
begin
  node:=FGNode.next;
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
end;

function TGDOMNode.get_attributes: IDOMNamedNodeMap; 
var
  node: xmlNodePtr;
begin
  node:=xmlNodePtr(FGNode.properties);
  if FGNode.type_=ELEMENT_NODE
    then result:=TGDOMNamedNodeMap.Create(node,FOwnerDocument)
      as IDOMNamedNodeMap
    else result:=nil;
end;

function TGDOMNode.get_ownerDocument: IDOMDocument; 
begin
  result:=FOwnerDocument;
end;

function TGDOMNode.get_namespaceURI: DOMString; 
var
  ns: xmlNsPtr;
  temp: pchar;
begin
  if FGNode<>nil then ns:=FGNode.ns else ns:=nil;
  if ns <>nil then temp:=ns.href else temp:=nil;
  if temp <> nil
    then result:=libxmlStringToString(temp)
    else result:='';
end;

function TGDOMNode.get_prefix: DOMString; 
var
  ns: xmlNsPtr;
  temp: pchar;
begin
  if FGNode<>nil then ns:=FGNode.ns else ns:=nil;
  if ns <>nil then temp:=ns.prefix else temp:=nil;
  if temp <> nil
    then result:=libxmlStringToString(temp)
    else result:='';
end;

function TGDOMNode.get_localName: DOMString; 
var
  temp,prefix: String;
begin
  prefix:='';
  case FGNode.type_ of
    //todo: check the result for the other nodetypes
    3: temp:='#text';
    9: temp:='#document';
  else
    begin
      temp:=FGNode.name;
      if FGNode.ns<>nil
        then prefix:=libxmlstringtostring(FGNode.ns.prefix)+':'
        else
          begin
               prefix:='';
               temp:='';
          end;
    end;
  end;
  result:=temp;
end;

function TGDOMNode.insertBefore(const newChild, refChild: IDOMNode): IDOMNode; 
var node: xmlNodePtr;
begin
  node:=xmlAddPrevSibling(GetGNode(refChild),GetGNode(newChild));
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
end;

function TGDOMNode.replaceChild(const newChild, oldChild: IDOMNode): IDOMNode; 
var
  node: xmlNodePtr;
begin
  {node:=gdome_n_replaceChild(FGNode,GetGNode(newChild),GetGNode(oldChild),@exc);
  CheckError(exc);
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;}
end;

function TGDOMNode.removeChild(const childNode: IDOMNode): IDOMNode; 
begin
  if childNode<>nil
    then xmlUnlinkNode(GetGNode(childNode));
  result:=childNode;
end;

function TGDOMNode.appendChild(const newChild: IDOMNode): IDOMNode; 
var
  node: xmlNodePtr;
begin
  node:=xmlAddChild(FGNode,GetGNode(newChild));
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
end;

function TGDOMNode.hasChildNodes: WordBool;
begin
  if FGNode.children<>nil
    then result:=true
    else result:=false;
end;

function TGDOMNode.hasAttributes: WordBool;
begin
  result:=false;
end;

function TGDOMNode.cloneNode(deep: WordBool): IDOMNode; 
var
  node: xmlNodePtr;
  recursive: Integer;
begin
  if deep
    then recursive:= 1
    else recursive:= 0;
  node:=xmlCopyNode(FGNode,recursive);
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
end;

procedure TGDOMNode.normalize;
begin
  //gdome_n_normalize(FGNode,@exc);
  //CheckError(exc);
end;

function TGDOMNode.isSupported(const feature, version: DOMString): WordBool;
begin
  {feature1:=TGdomString.create(feature);
  version1:=TGdomString.create(version);
  result:=gdome_n_issupported(FGNode,feature1.GetPString,version1.GetPString,@exc)<>0;
  CheckError(exc);
  feature1.free;
  version1.free;}
  result:=false;
end;

constructor TGDOMNode.Create(ANode: xmlNodePtr;ADocument:IDOMDocument;parentnode:boolean=false);
begin
  inherited create;
  Assert(Assigned(ANode));
  FGNode := ANode;
  FOwnerDocument:=ADocument;
  inc(nodecount);
end;

destructor TGDOMNode.destroy;
begin
  if nodecount>0 then begin
    //if FOwnerDocument<>nil then xmlFreeNode(FGNode);
    dec(nodecount);
    FOwnerDocument:=nil;
  end;
  inherited destroy;
end;

{ TGDOMNodeList }

constructor TGDOMNodeList.Create(AParent: xmlNodePtr;ADocument:IDOMDocument);
// create a IDOMNodeList from a var of type xmlNodePtr
// xmlNodePtr is the same as xmlNodePtrList, because in libxml2 there is no
// difference in the definition of both
begin
  inherited Create;
  FParent := AParent;
  FXpathList := nil;
  FOwnerDocument := ADocument;
end;

constructor TGDOMNodeList.Create(AXpathNodeList: xmlNodeSetPtr;
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
  FXpathList := AXpathNodeList;
  FOwnerDocument := ADocument;
end;

destructor TGDOMNodeList.destroy;
begin
  FOwnerDocument:=nil;
  inherited destroy;
  // ToDo:
  // nodeTab freigeben
  {if FGNodeList<>nil
    then begin
      gdome_nl_unref(FGNodeList,@exc);
      CheckError(exc);
    end;
  FGNodeList:=nil;
  FOwnerDocument:=nil;
  inherited destroy;}
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
      node:=node.next
    end;
  end else begin
      node:=xmlXPathNodeSetItem(FXPathList,i);
  end;
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
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
    result:=FXPathList.nodeNr;
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
  node:=FGNamedNodeMap;
  while (i>0) and (node.next<>nil) do begin
    dec(i);
    node:=node.next
  end;
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
end;

function TGDOMNamedNodeMap.get_length: Integer;
// same as NodeList.get_length
var
  node: xmlNodePtr;
  i: integer;
begin
  i:=1;
  node:=FGNamedNodeMap;
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
  name1:TGdomString;
  found: boolean;
begin
  node:=FGNamedNodeMap;
  if node<>nil then begin
    name1:=TGdomString.create(name);
    found:=false;
    repeat
      if xmlStrEqual(node.name,name1.CString)<>0 then
        begin
          found:=true;
          break
        end;
      node:=node.next
    until node.next=nil;
    if found
      then begin end
      else node:=nil;
    name1.free;
  end;
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
end;

function TGDOMNamedNodeMap.setNamedItem(const newItem: IDOMNode): IDOMNode;
var
  node,node1: xmlNodePtr;
  found: boolean;
begin
  node:=FGNamedNodeMap;
  node1:=GetGNode(newItem);
  // if the nodemap is empty, replace it by the
  // passed node
  if node=nil then begin
    node:=node1;
    FGNamedNodeMap:=node;
  end
  else begin
    found:=false;
    while node.next<>nil do begin
      if node.name=node1.name then
        begin
          found:=true;
          break
        end;
      node:=node.next
    end;
    if found
      then node:=xmlReplaceNode(node,node1)
      else node:=nil;
  end;
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
end;

function TGDOMNamedNodeMap.removeNamedItem(const name: DOMString): IDOMNode; 
var node: xmlNodePtr;
    name1:TGdomString;
begin
  {name1:=TGdomString.create(name);
  node:=gdome_nnm_removeNamedItem(FGNamedNodeMap,name1.GetPString,@exc);
  CheckError(exc);
  name1.free;
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;}
end;

function TGDOMNamedNodeMap.getNamedItemNS(const namespaceURI, localName: DOMString): IDOMNode;
var
  node: xmlNodePtr;
  name1,name2:TGdomString;
begin
  {name1:=TGdomString.create(namespaceURI);
  name2:=TGdomString.create(localName);
  node:=gdome_nnm_getNamedItemNS(FGNamedNodeMap,name1.GetPString,name2.GetPString,@exc);
  CheckError(exc);
  name1.free;
  name2.free;
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;}
end;

function TGDOMNamedNodeMap.setNamedItemNS(const newItem: IDOMNode): IDOMNode;
var
  node: xmlNodePtr;
begin
  {node:=gdome_nnm_setNamedItemNS(FGNamedNodeMap,GetGNode(newItem),@exc);
  CheckError(exc);
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;}
end;

function TGDOMNamedNodeMap.removeNamedItemNS(const namespaceURI, localName: DOMString): IDOMNode; 
var
  node: xmlNodePtr;
  name1,name2:TGdomString;
begin
  {name1:=TGdomString.create(namespaceURI);
  name2:=TGdomString.create(localName);
  node:=gdome_nnm_removeNamedItemNS(FGNamedNodeMap,name1.GetPString,name2.GetPString,@exc);
  CheckError(exc);
  name1.free;
  name2.free;
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;}
end;

constructor TGDOMNamedNodeMap.Create(ANamedNodeMap: xmlNodePtr;AOwnerDocument:IDOMDocument);
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

{ TGDOMAttr }

function TGDOMAttr.GetGAttribute: xmlAttrPtr;
begin
  result:=xmlAttrPtr(GNode);
end;

function TGDOMAttr.get_name: DOMString;
var
  temp: string;
begin
  temp:=libxmlStringToString(GAttribute.name);
  result:=temp;
end;

function TGDOMAttr.get_ownerElement: IDOMElement;
begin
  //DOMVendorNotSupported('get_ownerElement', SGXML); { Do not localize }
  //Result := nil;
end;

function TGDOMAttr.get_specified: WordBool;
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

constructor TGDOMAttr.Create(AAttribute: xmlAttrPtr;ADocument:IDOMDocument);
begin
  inherited create(xmlNodePtr(AAttribute),ADocument);
end;

destructor TGDOMAttr.destroy;
begin
  inherited destroy;
end;


//***************************
//TGDOMElement Implementation
//***************************

function TGDOMElement.GetGElement: xmlElementPtr;
begin
  result:=xmlElementPtr(GNode);
end;
// IDOMElement
function TGDOMElement.get_tagName: DOMString; 
begin
  result:=self.get_nodeName;
end;

function TGDOMElement.getAttribute(const name: DOMString): DOMString;
var
  name1: TGdomString;
begin
  name1:=TGdomString.create(name);
  result:=libxmlstringToString(xmlGetProp(xmlNodePtr(GElement),name1.CString));
  name1.free;
end;

procedure TGDOMElement.setAttribute(const name, value: DOMString);
var
  name1,name2: TGdomString;
  temp: xmlAttrPtr;
begin
  name1:=TGdomString.create(name);
  name2:=TGdomString.create(value);
  temp:=xmlSetProp(xmlNodePtr(GElement),name1.CString,name2.CString);
  //todo: raise exception if temp=nil?
  name1.free;
  name2.free;
end;

procedure TGDOMElement.removeAttribute(const name: DOMString);
var
  attr: xmlAttrPtr;
  name1: TGdomString;
begin
  name1:=TGdomString.create(name);
  attr := xmlHasProp(xmlNodePtr(GElement), name1.CString);
  name1.free;
  if attr <> nil
    then xmlRemoveProp(attr);
end;

function TGDOMElement.getAttributeNode(const name: DOMString): IDOMAttr;
var
  temp: xmlAttrPtr;
  name1: TGdomString;
begin
  name1:=TGdomString.create(name);
  temp:=xmlHasProp(xmlNodePtr(GElement), name1.CString);
  name1.Free;
  if temp<>nil
    then result:=TGDOMAttr.Create(temp,FOwnerDocument) as IDOMAttr
    else result:=nil;
end;

function TGDOMElement.setAttributeNode(const newAttr: IDOMAttr):IDOMAttr;
var
  attr,xmlnewAttr: xmlAttrPtr;
  value:pchar;
  temp: string;
begin
  if newAttr<>nil then begin
    xmlnewAttr:=xmlAttrPtr(GetGNode(newAttr));              // Get the libxml2-Attribute
    attr:=xmlHasProp(xmlNodePtr(GElement),xmlNewattr.name); // Check if the Element has
                                                            // already an attribute with this name
    if attr=nil then begin
      temp:=newAttr.value;
      if xmlnewAttr.children<>nil
        //todo: test the following case with a non-empty newAttr.value
        //newAttr.value must be the same as xmlnewAttr.children.content
        then value:=xmlnewAttr.children.content             // not tested
        else value:='';
      attr:=xmlSetProp(xmlNodePtr(GElement),xmlnewAttr.name,value);
      if attr<>nil
        then result:=TGDomAttr.Create(attr,FOwnerDocument) as IDOMAttr
        else result:=nil;
    end;
  end else begin end;// result:=nil;
end;
{var
	attr: xmlAttrPtr;
	s: string;
	v: string;
begin
	s := DOMAttribute.name;
	attr := xmlHasProp(FNode.node, PChar(s));
	if (attr=nil) then begin
		v := DOMAttribute.value;
		xmlSetProp(FNode.node, PChar(s), PChar(v));
		Result := GetDOMObject(xmlNodePtr(attr)) as IXMLDOMAttribute;
	end else begin
		xmlAddChild(FNode.node, xmlNodePtr(DOMAttribute)); //???
		Result := DOMAttribute;
	end;
end;}

function TGDOMElement.removeAttributeNode(const oldAttr: IDOMAttr):IDOMAttr;
var
  temp: xmlAttributePtr;
begin
  {temp:=gdome_el_removeAttributeNode(GElement,xmlAttributePtr(GetGNode(oldAttr)), @exc);
  CheckError(exc);
  if temp<>nil
    then result:=TGDOMAttr.Create(temp,FOwnerDocument) as IDOMAttr
    else result:=nil;}
end;

function TGDOMElement.getElementsByTagName(const name: DOMString): IDOMNodeList;
//var
  //nodeList: xmlNodePtrList;
  //name1: TGdomString;
begin
  {name1:=TGdomString.create(name);
  nodeList:=gdome_el_getElementsByTagName(GElement,name1.GetPString,@exc);
  CheckError(exc);
  name1.free;
  if nodeList<>nil
    then result:=TGDOMNodeList.Create(nodeList,FOwnerDocument) as IDOMNodeList
    else result:=nil;}
  //result:=nil;
  result:=selectNodes(name);
end;

function TGDOMElement.getAttributeNS(const namespaceURI, localName: DOMString):
  DOMString;
var
  temp: string;
  name1,name2: TGdomString;
begin
  name2:=TGdomString.create(namespaceURI);
  name1:=TGdomString.create(localName);
  result:=libxmlstringToString(xmlGetNSProp(xmlNodePtr(GElement),name1.CString,
    name2.CString));
  name1.free;
  name2.free;
end;

procedure TGDOMElement.setAttributeNS(const namespaceURI, qualifiedName, value: DOMString);
var
  ns: TGdomNamespace;
  temp: xmlAttrPtr;
  value1: TGdomString;
begin
  value1:=TGdomString.create(value);
  ns := TGDOMNamespace.create(xmlNodePtr(GElement),namespaceURI,qualifiedName);
  temp:=xmlSetNSProp(xmlNodePtr(GElement),ns.NS,ns.localName.CString,value1.CString);
  value1.free;
  ns.Free;
  //todo: raise exception if temp=nil?
end;

procedure TGDOMElement.removeAttributeNS(const namespaceURI, localName: DOMString);
var
  attr: xmlAttrPtr;
  name1,name2: TGdomString;
begin
  name1:=TGdomString.create(localName);
  name2:=TGdomString.create(namespaceURI);
  attr := xmlHasNSProp(xmlNodePtr(GElement), name1.CString,name2.CString);
  name1.free;
  name2.free;
  if attr <> nil
    then xmlRemoveProp(attr);
end;

function TGDOMElement.getAttributeNodeNS(const namespaceURI, localName: DOMString): IDOMAttr;
var
  temp: xmlAttrPtr;
  name1,name2: TGdomString;
begin
  name1:=TGdomString.create(namespaceURI);
  name2:=TGdomString.create(localName);
  temp:=xmlHasNSProp(xmlNodePtr(GElement), name2.CString,name1.CString);
  name1.Free;
  name2.free;
  if temp<>nil
    then result:=TGDOMAttr.Create(temp,FOwnerDocument) as IDOMAttr
    else result:=nil;
end;

function TGDOMElement.setAttributeNodeNS(const newAttr: IDOMAttr): IDOMAttr;
var
  attr,xmlnewAttr: xmlAttrPtr;
  value:pchar;
  temp,slocalName: string;
  ns:xmlNSPtr;
  namespace:pchar;
begin
  if newAttr<>nil then begin
    xmlnewAttr:=xmlAttrPtr(GetGNode(newAttr));              // Get the libxml2-Attribute
    ns:=xmlnewAttr.ns;
    if ns<>nil
      then namespace:=ns.href
      else namespace:='';
    slocalName:=localName(xmlNewattr.name);
    attr:=xmlHasNSProp(xmlNodePtr(GElement),pchar(slocalName),namespace); // Check if the Element has
                                                                        // already an attribute with this name
    if attr=nil then begin
      temp:=newAttr.value;
      if xmlnewAttr.children<>nil
        //todo: test the following case with a non-empty newAttr.value
        //newAttr.value must be the same as xmlnewAttr.children.content
        then value:=xmlnewAttr.children.content             // not tested
        else value:='';
      if ns<> nil
        then attr:=xmlSetNSProp(xmlNodePtr(GElement),ns,pchar(slocalName),value)
        else attr:=xmlSetProp(xmlNodePtr(GElement),pchar(slocalName),value);
      if attr<>nil
        then result:=TGDomAttr.Create(attr,FOwnerDocument) as IDOMAttr
        else result:=nil;
    end;
  end else result:=nil;
end;

function TGDOMElement.getElementsByTagNameNS(const namespaceURI, localName: DOMString): IDOMNodeList; 
var
  //nodeList: xmlNodePtrList;
  name1,name2: TGdomString;
begin
  {name1:=TGdomString.create(namespaceURI);
  name2:=TGdomString.create(localName);
  nodeList:=gdome_el_getElementsByTagNameNS(GElement,name1.GetPString,name2.GetPString,@exc);
  CheckError(exc);
  if nodeList<>nil
    then result:=TGDOMNodeList.Create(nodeList,FOwnerDocument) as IDOMNodeList
    else result:=nil;
  name1.Free;
  name2.Free;}
  //result:=nil;
  result:=selectNodes(namespaceURI+'::'+localName);
end;

function TGDOMElement.hasAttribute(const name: DOMString): WordBool; 
var
  name1: TGdomString;
begin
  name1:=TGdomString.create(name);
  if xmlGetProp(xmlNodePtr(GElement),name1.CString) <> nil
    then result:=true
    else result:=false;
  name1.free;
end;


function TGDOMElement.hasAttributeNS(const namespaceURI, localName: DOMString): WordBool;
var
  temp: string;
  name1,name2: TGdomString;
begin
  name2:=TGdomString.create(namespaceURI);
  name1:=TGdomString.create(localName);
  if (xmlGetNSProp(xmlNodePtr(GElement),name1.CString,
    name2.CString)) <> nil
    then result:=true
    else result:=false;
  name1.free;
  name2.free;
end;

procedure TGDOMElement.normalize;
begin
  //gdome_el_normalize(GElement,@exc);
  //CheckError(exc);
end;

constructor TGDOMElement.Create(AElement: xmlElementPtr;ADocument:IDOMDocument);
begin
  inc(elementcount);
  inherited create(xmlNodePtr(AElement),ADocument);
end;

destructor TGDOMElement.destroy;
begin
  if elementcount >0 then begin
    //ToDo: Is there anything to free?
    dec(elementcount);
  end;
  inherited destroy;
end;


//************************************************************************
// functions of TGDOMDocument
//************************************************************************

constructor TGDOMDocument.create(
               GDOMImpl:IDOMImplementation;
               const namespaceURI, qualifiedName: DOMString;
               doctype: IDOMDocumentType);
var
  exc: GdomeException;
  name1,name2: TGdomString;
  root:xmlNodePtr;
begin
  FGdomimpl:=GDOMImpl;
  FPGdomeDoc:=xmlNewDoc('1.0');
  name2:=TGdomString.create(qualifiedName);
  FPGdomeDoc.children:=xmlNewDocNode(FPGdomeDoc,nil,name2.CString,nil);
  name2.Free;
  {name1:=TGdomString.create(namespaceURI);
 
  //#ToDo2 add doctype to the following function-call
  if length(namespaceURI)=0
    then FPGdomeDoc:=gdome_di_createDocument(FPGDOMImpl,nil,name2.GetPString,nil,@exc)
    else FPGdomeDoc:=gdome_di_createDocument(FPGDOMImpl,name1.GetPString,name2.GetPString,nil,@exc);
  CheckError(exc);
  name1.Free;
  name2.Free;}
  //Get root-node
  root:= xmlNodePtr(FPGdomeDoc);
  //Create root-node as pascal object
  inherited create(root,nil);
  inc(doccount);
end;

destructor TGDOMDocument.destroy;
var
  exc: GdomeException;
begin
  if doccount>0 then begin
    if FPGdomeDoc<>nil
      then begin
        xmlFreeDoc(FPGdomeDoc);
        dec(doccount);
      end;
  end;
  inherited Destroy;
end;

// IDOMDocument
function TGDOMDocument.get_doctype: IDOMDocumentType; 
begin
end;

function TGDOMDocument.get_domImplementation: IDOMImplementation; 
begin
  //result:=FGDOMImpl;
end;

function TGDOMDocument.get_documentElement: IDOMElement; 
var root1:xmlElementPtr;
    exc: GdomeException;
    FGRoot: TGDOMElement;
begin
  //root1:=xmlElementPtr(FPGdomeDoc.children);
  root1:=xmlElementPtr(xmlDocGetRootElement(FPGdomeDoc));
  if root1<>nil
    then FGRoot:=TGDOMElement.create(root1,self)
    else FGRoot:=nil;
  Result := FGRoot;
end;

procedure TGDOMDocument.set_documentElement(const IDOMElement: IDOMElement);
begin

end;

function TGDOMDocument.createElement(const tagName: DOMString): IDOMElement; 
var
  exc:GdomeException;
  name1: TGdomString;
  AElement: xmlElementPtr;
begin
  name1:=TGdomString.create(tagName);
  AElement:=xmlElementPtr(xmlNewDocNode(FPGdomeDoc,nil,name1.CString,nil));
  name1.free;
  if AElement<>nil
    then result:=TGDOMElement.Create(AElement,self)
    else result:=nil;
end;

function TGDOMDocument.createDocumentFragment: IDOMDocumentFragment; 
var
  exc:GdomeException;
  //ADocumentFragment: PGdomeDocumentFragment;
begin
  {ADocumentFragment:=gdome_doc_createDocumentFragment(FPGdomeDoc,@exc);
  CheckError(exc);
  if ADocumentFragment<>nil
    then result:=TGDOMDocumentFragment.Create(xmlNodePtr(ADocumentFragment),self)
    else result:=nil;}
end;

function TGDOMDocument.createTextNode(const data: DOMString): IDOMText; 
var
  exc:GdomeException;
  data1: TGdomString;
  ATextNode: xmlNodePtr;
begin
  data1:=TGdomString.create(data);
  ATextNode:=xmlNewDocText(FPGdomeDoc,data1.CString);
  data1.free;
  if ATextNode<> nil
    then result:=TGDOMText.Create((ATextNode),self)
    else result:=nil;
end;

function TGDOMDocument.createComment(const data: DOMString): IDOMComment; 
var
  exc:GdomeException;
  data1: TGdomString;
  //AComment: PGdomeComment;
begin
  {data1:=TGdomString.create(data);
  AComment:=gdome_doc_createComment(FPGdomeDoc,data1.GetPString,@exc);
  CheckError(exc);
  data1.free;
  if AComment<>nil
    then result:=TGDOMComment.Create(PGdomeCharacterData(AComment),self)
    else result:=nil;}
end;

function TGDOMDocument.createCDATASection(const data: DOMString): IDOMCDATASection;
var
  name1: TGdomString;
  node: xmlNodePtr;
begin
  name1:=TGdomString.create(data);
  node := xmlNewCDataBlock(FPGdomeDoc, name1.CString, length(name1.CString));
  name1.Free;
  if node<>nil
    then result:=TGDOMCDataSection.Create(node,self)
    else result:=nil;
end;

function TGDOMDocument.createProcessingInstruction(const target,
  data: DOMString): IDOMProcessingInstruction;
var
  exc:GdomeException;
  name1,name2: TGdomString;
  AProcessingInstruction: PGdomeProcessingInstruction;
begin
  {name1:=TGdomString.create(target);
  name2:=TGdomString.create(data);
  AProcessingInstruction:=gdome_doc_createProcessingInstruction(FPGdomeDoc,
    name1.GetPString, name2.GetPString,@exc);
  CheckError(exc);
  name1.free;
  name2.free;
  if AProcessingInstruction <>nil
    then result:=TGDOMProcessingInstruction.Create(xmlNodePtr(AProcessingInstruction),self)
    else result:=nil;}
end;

function TGDOMDocument.createAttribute(const name: DOMString): IDOMAttr; 
var
  exc:GdomeException;
  name1: TGdomString;
  AAttr: xmlAttrPtr;
begin
  name1:=TGdomString.create(name);
  //AAttr:=xmlNewProp(xmlNodePtr(FPGdomeDoc),name1.CString,nil);
  AAttr:=xmlNewProp(nil,name1.CString,nil);
  name1.free;
  if AAttr<>nil
    then result:=TGDOMAttr.Create(AAttr,self)
    else result:=nil;
end;

function TGDOMDocument.createEntityReference(const name: DOMString): IDOMEntityReference; 
var
  exc:GdomeException;
  name1: TGdomString;
  //AEntityReference: PGdomeEntityReference;
begin
  {name1:=TGdomString.create(name);
  AEntityReference:=gdome_doc_createEntityReference(FPGdomeDoc,name1.GetPString,@exc);
  CheckError(exc);
  name1.free;
  if AEntityReference<>nil
    then result:=TGDOMEntityReference.Create(xmlNodePtr(AEntityReference),self)
    else result:=nil;}
end;

function TGDOMDocument.getElementsByTagName(const tagName: DOMString): IDOMNodeList; 
var
  //ANodeList: xmlNodePtrList;
  name1: TGdomString;
begin
  {name1:=TGdomString.create(tagName);
  ANodeList:=gdome_doc_getElementsByTagName(FPGdomeDoc,name1.GetPString, @exc);
  CheckError(exc);
  name1.Free;
  if ANodeList<>nil
    then result:=TGDOMNodeList.Create(ANodeList,self)
    else result:=nil;}
  result:=nil;
end;

function TGDOMDocument.importNode(importedNode: IDOMNode; deep: WordBool): IDOMNode; 
begin
end;

function TGDOMDocument.createElementNS(const namespaceURI,
  qualifiedName: DOMString): IDOMElement; 
var
  exc:GdomeException;
  name2: TGdomString;
  AElement: xmlElementPtr;
  ns: TGDOMNamespace;
  prefix: string;
begin
  ns := TGDOMNamespace.create(nil,namespaceURI,qualifiedName);
  AElement:=xmlElementPtr(xmlNewDocNode(FPGdomeDoc,ns.NS,ns.localName.CString,nil));
  ns.free;
  if AElement<>nil
    then result:=TGDOMElement.Create(AElement,self)
    else result:=nil;
end;

{var
  exc:GdomeException;
  name1,name2: TGdomString;
  AElement: xmlElementPtr;
begin
  name1:=TGdomString.create(namespaceURI);
  name2:=TGdomString.create(qualifiedName);
  AElement:=gdome_doc_createElementNS(FPGdomeDoc,name1.GetPString,name2.GetPString,@exc);
  CheckError(exc);
  name1.Free;
  name2.Free;
  if AElement<>nil
    then result:=TGDOMElement.Create(AElement,self)
    else result:=nil;
end;}

function TGDOMDocument.createAttributeNS(const namespaceURI,
  qualifiedName: DOMString): IDOMAttr; 
var
  name1,name2: TGdomString;
  AAttr: xmlAttrPtr;
  ns: xmlNsPtr;
begin
  name1:=TGdomString.create(namespaceURI);
  name2:=TGdomString.create(qualifiedName);
  ns := xmlNewNs(nil, name1.CString, nil); //prefix:=nil
  AAttr:=xmlNewNsProp(nil,ns,name2.CString,nil);
  name1.free;
  if AAttr<>nil
    then result:=TGDOMAttr.Create(AAttr,self)
    else result:=nil;
end;

function TGDOMDocument.getElementsByTagNameNS(const namespaceURI,
  localName: DOMString): IDOMNodeList; 
var
  //ANodeList: xmlNodePtrList;
  name1,name2: TGdomString;
begin
  {name1:=TGdomString.create(namespaceURI);
  name2:=TGdomString.create(localName);
  ANodeList:=gdome_doc_getElementsByTagNameNS(FPGdomeDoc,name1.GetPString, name2.GetPString,@exc);
  CheckError(exc);
  name1.Free;
  name2.Free;
  if ANodeList<>nil
    then result:=TGDOMNodeList.Create(ANodeList,self)
    else result:=nil;}
  result:=nil;
end;

function TGDOMDocument.getElementById(const elementId: DOMString): IDOMElement;
var
  AElement: xmlElementPtr;
  exc: GdomeException;
  name1: TGdomString;
begin
  {name1:=TGdomString.create(elementID);
  AElement:=gdome_doc_getElementById(FPGdomeDoc,name1.GetPString, @exc);
  CheckError(exc);
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
  exc: GdomeException;
  mem: ppchar;
  err: boolean;
  CString,encoding:pchar;
  length:LongInt;
begin
  CString:='';
  mem:=addr(CString);
  encoding:=FPGdomeDoc.encoding;
  xmlDocDumpMemoryEnc(FPGdomeDoc,CString,@length,encoding);
  result:=CString;
end;

function TGDOMDocument.asyncLoadState: Integer; 
begin
  result:=0;
end;

function TGDOMDocument.load(source: OleVariant): WordBool; 
// Load dom from file
var filename: string;
    root: xmlNodePtr;
begin
  filename:=source;
  xmlFreeDoc(FPGdomeDoc);
  inherited Destroy;
  FPGdomeDoc:=xmlParseFile(pchar(filename));
  if FPGdomeDoc<>nil
    then
      begin
        root:= xmlNodePtr(FPGdomeDoc);
        inherited create(root,nil);
        result:=true
      end
    else result:=false;
end;

function TGDOMDocument.loadFromStream(const stream: TStream): WordBool; 
begin
end;

function TGDOMDocument.loadxml(const Value: DOMString): WordBool; 
// Load dom from file
var
  temp: TGdomString;
  root: xmlNodePtr;
begin
  temp:=TGdomString.create(Value);
  xmlFreeDoc(FPGdomeDoc);
  inherited Destroy;
  //FPGdomeDoc:=xmlParseMemory(temp.CString,length(temp.CString));
  FPGdomeDoc:=xmlParseDoc(temp.CString);
  temp.free;
  if FPGdomeDoc<>nil
    then
      begin
        root:= xmlNodePtr(FPGdomeDoc);
        inherited create(root,nil);
        result:=true
      end
    else result:=false;
end;

procedure TGDOMDocument.save(destination: OleVariant); 
var
  exc: GdomeException;
  temp:string;
  encoding:pchar;
  bytes: integer;
begin
  temp:=destination;
  encoding:=FPGdomeDoc.encoding;
  bytes:=xmlSaveFileEnc(pchar(temp),FPGdomeDoc,encoding);
  if bytes<0 then CheckError(22); //write error
end;

procedure TGDOMDocument.saveToStream(const stream: TStream); 
begin
end;

procedure TGDOMDocument.set_OnAsyncLoad(const Sender: TObject;
  EventHandler: TAsyncEventHandler); 
begin
end;

function GetGNode(const Node: IDOMNode): xmlNodePtr;
begin
  if not Assigned(Node) then
    raise EDOMException.Create(SNodeExpected);
  Result := (Node as IXMLDOMNodeRef).GetGDOMNode;
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
  else
    result:='Unknown error no: '+inttostr(err);
  end;
end;

procedure CheckError(err:integer);
begin
  if err <>0
    then raise EDOMException.Create(ErrorString(err));
end;

{ TGdomString }

constructor TGdomString.create(ADOMString: DOMString);
var
  temp: string;
  temp1: integer;
begin
  inherited create;
  temp:=UTF8Encode(ADOMString);
  temp1:=length(temp)+1;
  CString:='';
  CString:=StrAlloc(temp1);
  //CString:=pchar(temp);
  strcopy(CString,pchar(temp));
end;

destructor TGdomString.destroy;
begin
  strdispose(CString);
  inherited destroy;
end;

{ TGDOMCharacterData }

procedure TGDOMCharacterData.appendData(const data: DOMString);
var
  value1: TGdomString;
begin
  value1:=TGdomString.create(data);
  xmlNodeAddContent(GetGCharacterData, value1.CString);
  value1.free;
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

function TGDOMCharacterData.GetGCharacterData: PGDomeCharacterData;
begin
  result:=xmlNodePtr(GNode);
end;

procedure TGDOMCharacterData.insertData(offset: Integer;
  const data: DOMString);
var
  value1: TGdomString;
begin
  value1:=TGdomString.create(data);
  replaceData(offset, 0, data);
  value1.free;
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
var
  temp:PGdomeDomString;
  exc: GdomeException;
begin
  {temp:=gdome_cd_substringData(GCharacterData,offset,count,@exc);
  CheckError(exc);
  result:=GdomeDOMStringToString(temp);}
end;

constructor TGDOMCharacterData.Create(ACharacterData: xmlNodePtr;
  ADocument: IDOMDocument);
begin
  inherited create(xmlNodePtr(ACharacterData),ADocument);
end;

destructor TGDOMCharacterData.destroy;
var exc: GdomeException;
begin
  inherited destroy;
end;

{ TGDOMText }

function TGDOMText.splitText(offset: Integer): IDOMText;
var
  exc: GdomeException;
  //temp:PGdomeText;
begin
  {temp:=gdome_t_splitText(PGdomeText(GCharacterData),offset,@exc);
  CheckError(exc);
  result:=MakeNode(xmlNodePtr(temp),FOwnerDocument) as IDOMText;}
end;

{ TMSDOMEntity }

function TGDOMEntity.get_notationName: DOMString;
var exc: GdomeException;
begin
  //result:=GdomeDOMStringToString(gdome_ent_notationName(GEntity,@exc));
  //CheckError(exc);
end;

function TGDOMEntity.get_publicId: DOMString;
var exc: GdomeException;
begin
  //result:=GdomeDOMStringToString(gdome_ent_publicID(GEntity,@exc));
  //CheckError(exc);
end;

function TGDOMEntity.get_systemId: DOMString;
var exc: GdomeException;
begin
  //result:=GdomeDOMStringToString(gdome_ent_systemID(GEntity,@exc));
end;

function TGDOMEntity.GetGEntity: PGdomeEntity;
begin
  //result:=PGdomeEntity(GNode);
end;

{ TGDOMProcessingInstruction }

function TGDOMProcessingInstruction.get_data: DOMString;
var exc: GdomeException;
begin
  //result:=GdomeDOMStringToString(gdome_pi_data(GProcessingInstruction,@exc));
  //CheckError(exc);
end;

function TGDOMProcessingInstruction.get_target: DOMString;
var exc: GdomeException;
begin
  //result:=GdomeDOMStringToString(gdome_pi_target(GProcessingInstruction,@exc));
  //CheckError(exc);
end;

function TGDOMProcessingInstruction.GetGProcessingInstruction: PGdomeProcessingInstruction;
begin
  //result:=PGdomeProcessingInstruction(GNode);
end;

procedure TGDOMProcessingInstruction.set_data(const value: DOMString);
var
  exc:GdomeException;
  value1: TGdomString;
begin
  {value1:=TGdomString.create(value);
  gdome_pi_set_data(GProcessingInstruction,value1.GetPString,@exc);
  CheckError(exc);
  value1.free;}
end;

{ TGDOMDocumentType }

function TGDOMDocumentType.get_entities: IDOMNamedNodeMap;
var entities: PGdomeNamedNodeMap;
    exc: GdomeException;
begin
  {entities:=gdome_dt_entities(GDocumentType,@exc);
  CheckError(exc);
  if entities<>nil
    then result:=TGDOMNamedNodeMap.Create(entities,FOwnerDocument) as IDOMNamedNodeMap
    else result:=nil;}
end;

function TGDOMDocumentType.get_internalSubset: DOMString;
var
  temp: String;
  exc: GdomeException;
begin
  //temp:=GdomeDOMStringToString(gdome_dt_internalSubset(GDocumentType, @exc));
  //CheckError(exc);
  //result:=temp;
end;

function TGDOMDocumentType.get_name: DOMString;
var
  temp: String;
  exc: GdomeException;
begin
  //temp:=GdomeDOMStringToString(gdome_dt_name(GDocumentType, @exc));
  //CheckError(exc);
  //result:=temp;
end;

function TGDOMDocumentType.get_notations: IDOMNamedNodeMap;
var notations: PGdomeNamedNodeMap;
    exc: GdomeException;
begin
  {notations:=gdome_dt_notations(GDocumentType,@exc);
  CheckError(exc);
  if notations<>nil
    then result:=TGDOMNamedNodeMap.Create(notations,FOwnerDocument) as IDOMNamedNodeMap
    else result:=nil;}
end;

function TGDOMDocumentType.get_publicId: DOMString;
var
  temp: String;
  exc: GdomeException;
begin
  {temp:=GdomeDOMStringToString(gdome_dt_publicId(GDocumentType, @exc));
  CheckError(exc);
  result:=temp;}
end;

function TGDOMDocumentType.get_systemId: DOMString;
var
  temp: String;
  exc: GdomeException;
begin
  {temp:=GdomeDOMStringToString(gdome_dt_systemId(GDocumentType, @exc));
  CheckError(exc);
  result:=temp;}
end;

function TGDOMDocumentType.GetGDocumentType: PGDomeDocumentType;
begin
  //result:=PGdomeDocumentType(GNode);
end;

constructor TGDOMDocumentType.Create(
  PGDOMImplementation: PGdomeDOMImplementation; const qualifiedName,
  publicID, systemID: DOMString);
var
  exc: GdomeException;
  name1,name2,name3: TGdomString;
  root:xmlNodePtr;
  temp:PGdomeDocumentType;
begin
  {name1:=TGdomString.create(qualifiedName);
  name2:=TGdomString.create(publicID);
  name3:=TGdomString.create(systemID);
  temp:=gdome_di_createDocumentType(PGDOMImplementation,
    name1.GetPString,name2.GetPString,name3.GetPString,@exc);
  CheckError(exc);
  name1.Free;
  name2.Free;
  name3.Free;
  //Get root-node
  root:= xmlNodePtr(temp);
  //Create root-node as pascal object
  inherited create(root,nil);}
end;


destructor TGDOMDocumentType.destroy;
var
  exc: GdomeException;
begin
  //gdome_dt_unref(GetGDocumentType,@exc);
  //CheckError(exc);
  inherited destroy;
end;

{ TGDOMNotation }

function TGDOMNotation.get_publicId: DOMString;
var
  temp: String;
  exc: GdomeException;
begin
  //temp:=GdomeDOMStringToString(gdome_not_publicId(GNotation, @exc));
  //CheckError(exc);
  //result:=temp;
end;

function TGDOMNotation.get_systemId: DOMString;
var
  temp: String;
  exc: GdomeException;
begin
  //temp:=GdomeDOMStringToString(gdome_not_systemId(GNotation, @exc));
  //CheckError(exc);
  //result:=temp;
end;

function TGDOMNotation.GetGNotation: PGdomeNotation;
begin
  result:=PGdomeNotation(GNode);
end;

{ TGDOMNameSpace }

constructor TGDOMNameSpace.create(node:xmlNodePtr;namespaceURI,qualifiedName: DOMString);
var
  name1,name3: TGdomString;
  prefix: string;
begin
  name1:=TGdomString.create(namespaceURI);
  prefix := Copy(qualifiedName,1,Pos(':',qualifiedName)-1);
  localName:=TGdomString.create(Copy(qualifiedName,Pos(':',qualifiedName)+1,
    length(qualifiedName)-length(prefix)-1));
  name3:=TGdomString.create(prefix);
  ns := xmlNewNs(node, name1.CString, name3.CString);
  name1.free;
  name3.free;
end;

destructor TGDOMNameSpace.destroy;
begin
  //todo: xmlFreeNs(ns);
  localName.free;
  inherited destroy;
end;

function TGDOMNode.selectNode(const nodePath: WideString): IDOMNode;
// todo: raise  exceptions
//       a) if invalid nodePath expression
//       b) if result type <> nodelist
//       c) perhaps if nodelist.length > 1 ???
var
  doc: xmlDocPtr;
  ctxt: xmlXPathContextPtr;
  expr: TGdomString;
  res:  xmlXPathObjectPtr;
  node1: xmlNodePtr;
  temp: string;
  nodetype,nodecount: integer;
begin
  temp:=UTF8Encode(nodePath);
  doc:=FGNode.doc;
  if doc=nil then CheckError(100);
  ctxt:=xmlXPathNewContext(doc);
  ctxt.node:=FGNode;
  res:=xmlXPathEvalExpression(pchar(temp),ctxt);
  if res<>nil then  begin
    nodetype:=res.type_;   //1 = nodeset
    if nodetype = 1 then begin
      nodecount:=res.nodesetval.nodeNr;
      node1:=xmlXPathNodeSetItem(res.nodesetval,0);
    end else
      node1:=nil;
    xmlXPathFreeNodeSetList(res);
    //xmlXPathFreeObject(res);
    xmlXPathFreeContext(ctxt);
  end;
  result:=MakeNode(node1,FOwnerDocument);
end;

function TGDOMNode.selectNodes(const nodePath: WideString): IDOMNodeList;
// todo: raise  exceptions
//       a) if invalid nodePath expression
//       b) if result type <> nodelist
var
  doc: xmlDocPtr;
  ctxt: xmlXPathContextPtr;
  res:  xmlXPathObjectPtr;
  node1: xmlNodePtr;
  temp: string;
  nodetype,nodecount: integer;
  filename: string;
begin
  temp:=UTF8Encode(nodePath);
  doc:=FGNode.doc;
  if doc=nil then CheckError(100);
  ctxt:=xmlXPathNewContext(doc);
  ctxt.node:=FGNode;
  res:=xmlXPathEvalExpression(pchar(temp),ctxt);
  if res<>nil then  begin
    nodetype:=res.type_;   //1 = nodeset
    if nodetype = 1
      then begin
        nodecount:=res.nodesetval.nodeNr;
        result:=TGDOMNodeList.Create(res.nodesetval,FOwnerDocument)
      end
      else result:=nil;
    xmlXPathFreeNodeSetList(res);
    //xmlXPathFreeObject(res);
    xmlXPathFreeContext(ctxt);
  end else result:=nil;
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

end;

function TGDOMDocumentBuilder.load(const url: DomString): IDomDocument;
begin
  result:=nil;
end;

function TGDOMDocumentBuilder.newDocument: IDomDocument;
begin
  result:=nil;
end;

function TGDOMDocumentBuilder.parse(const xml: DomString): IDomDocument;
begin
  result:=nil;
end;

initialization
  RegisterDomVendorFactory(TGDOMDocumentBuilderFactory.Create(False));
finalization
end.
