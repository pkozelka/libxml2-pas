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
  WordBool=boolean;

  TGDOMInterface = class(TInterfacedObject)
	public
    function SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HRESULT; override;
  end;

{ TGDOMImplementation }

  TGDOMImplementation = class(TGDOMInterface, IDOMImplementation)
  private
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
    FPrefix: String; //for xpath
    FURI: String;    //for xpath
  protected
    function GetGDOMNode: xmlNodePtr; //new
    function IsReadOnly: boolean;     //new
    function IsAncestorOrSelf(newNode:xmlNodePtr): boolean; //new
    // IDOMNode
		function  get_nodeName: DOMString;
    function  get_nodeValue: DOMString;
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
		function  get_namespaceURI: DOMString;
		function  get_prefix: DOMString;
		procedure set_Prefix(const prefix : DomString);
    function  get_localName: DOMString;
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
    procedure RegisterNS(const prefix,URI: DomString);
  public
    constructor Create(ANode: xmlNodePtr;ADocument:IDOMDocument);
    destructor destroy; override;
    property GNode: xmlNodePtr read FGNode;
  end;

  //xmlNodePtrList=xmlNodePtr;
  PGDomeNamedNodeMap=Pointer;

  TGDOMNodeList = class(TGDOMInterface, IDOMNodeList)
  private
     FParent: xmlNodePtr;
     FXPathObject: xmlXPathObjectPtr;
     FOwnerDocument: IDOMDocument;
  protected
    { IDOMNodeList }
    function get_item(index: Integer): IDOMNode;
    function get_length: Integer;
  public
    constructor Create(AParent: xmlNodePtr;ADocument:IDOMDocument); overload;
    constructor Create(AXpathObject: xmlXPathObjectPtr;ADocument:IDOMDocument); overload;
    destructor destroy; override;
	end;

  TGDOMNamedNodeMap = class(TGDOMInterface, IDOMNamedNodeMap)
  // this class is used for attributes, entities and notations
  private
    FGNamedNodeMap: xmlNodePtr;
    FOwnerDocument: IDOMDocument;
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
    constructor Create(ANamedNodeMap: xmlNodePtr; AOwnerDocument: IDOMDocument);
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
    constructor Create(AAttribute: xmlAttrPtr;ADocument:IDOMDocument;freenode:boolean=false);
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
    constructor Create(ACharacterData: xmlNodePtr;ADocument:IDOMDocument;freenode:boolean=false);
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
    constructor Create(AElement: xmlNodePtr;ADocument:IDOMDocument;freenode:boolean=false);
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
    constructor Create(dtd:xmlDtdPtr;ADocument:IDOMDocument);
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

  PGdomeProcessingInstruction=xmlNodePtr;

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

  IDomInternal = interface
    ['{E9D505C3-D354-4D19-807A-8B964E954C09}']

    {managing the list of nodes and attributes, that must be freed manually}

    procedure removeAttr(attr: xmlAttrPtr);
    procedure appendAttr(attr: xmlAttrPtr);
    procedure appendNode(node: xmlNodePtr);
    procedure appendNs(ns: xmlNsPtr);
  end;

  TGDOMDocument = class(TGDOMNode, IDOMDocument, IDOMParseOptions, IDOMPersist, IDOMInternal)
  private
    FGDOMImpl: IDOMImplementation;
    FPGdomeDoc: xmlDocPtr;
    FAsync: boolean;              //for compatibility, not really supported
    FpreserveWhiteSpace: boolean; //difficult to support
    FresolveExternals: boolean;   //difficult to support
    Fvalidate: boolean;           //check if default is ok
    FAttrList:TList; //keeps a list of attributes, created on this document                                    this document
    FNodeList:TList; //keeps a list of nodes, created on this document
    FNsList:TList;   //keeps a list of namespaces, created on this document
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
    // IDOMInternal
    procedure removeAttr(attr: xmlAttrPtr);
    procedure appendAttr(attr: xmlAttrPtr);
    procedure appendNode(node: xmlNodePtr);
    procedure appendNs(ns: xmlNsPtr);
  public
    constructor Create(
      GDOMImpl:IDOMImplementation;
      const namespaceURI, qualifiedName: DOMString;
      doctype: IDOMDocumentType); overload;
    constructor Create(GDOMImpl:IDOMImplementation); overload;
    constructor Create(GDOMImpl:IDOMImplementation; aUrl: DomString); overload;
		destructor destroy; override;
  end;

  { TMSDOMDocumentFragment }

  TGDOMDocumentFragment = class(TGDOMNode, IDOMDocumentFragment)
  end;

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
    function  load(const url : DomString) : IDomDocument;
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
    Ns:xmlNSPtr;
    localName,FqualifiedName: TGdomString;
    FOwnerDoc:IDOMDocument;
  public
    constructor create(node:xmlNodePtr;namespaceURI,qualifiedName: DOMString;
      OwnerDoc:IDOMDocument);
    destructor destroy; override;
  end;

var
  LIBXML_DOM: IDomDocumentBuilderFactory;
  doccount: integer=0;
  domcount: integer=0;
  nodecount: integer=0;
  elementcount: integer=0;
  node,temp2: xmlNodePtr;

function GetGNode(const Node: IDOMNode): xmlNodePtr;

procedure CheckError(err:integer);

function IsReadOnlyNode(node:xmlNodePtr): boolean;

function ErrorString(err:integer):string;

implementation

Type GDomeException=Integer;

resourcestring
  SNodeExpected = 'Node cannot be null';
  SGDOMNotInstalled = 'GDOME2 is not installed';

function setAttr(var node:xmlNodePtr; xmlNewAttr:xmlAttrPtr):xmlAttrPtr; forward;

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
  name1,name2,name3: TGdomString;
begin
  name1:=TGdomString.create(qualifiedName);
  name2:=TGdomString.create(publicId);
  name3:=TGdomString.create(systemId);
  dtd:=xmlCreateIntSubSet(nil,name1.CString,name2.CString,name3.CString);
  name1.free;
  name2.free;
  name3.free;
  if dtd<>nil
    then Result := TGDOMDocumentType.Create(dtd,nil) as IDOMDocumentType
    else Result := nil;
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
begin
  case FGNode.type_ of
    XML_HTML_DOCUMENT_NODE,
    //XML_DOCB_DOCUMENT_NODE,
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

(**
/**
 * gdome_xmlSetAttrValue:  * @attr:  the attribute which the value is to be set  * @value:  the value to set  *  * Set a new value to an Attribute node.  */ void gdome_xmlSetAttrValue(xmlAttr *attr, xmlChar *value) {   if(attr == NULL)     return;    if (attr->children != NULL)     xmlFreeNodeList(attr->children);   attr->children = NULL;   attr->last = NULL;    if (value != NULL) {     xmlChar *buffer;     xmlNode *tmp;      buffer = xmlEncodeEntitiesReentrant(attr->doc, value);     attr->children = xmlStringGetNodeList(attr->doc, buffer);     attr->last = NULL;     tmp = attr->children;     for(tmp = attr->children; tmp != NULL; tmp = tmp->next) {       tmp->parent = (xmlNode *  )attr;       tmp->doc = attr->doc;       if (tmp->next == NULL)         attr->last = tmp;     }     xmlFree (buffer);   }    return; }
**)

procedure TGDOMNode.set_nodeValue(const value: DOMString);
var
  temp: TGdomString;
  attr: xmlAttrPtr;
  //buffer:pchar;
  tmp: xmlNodePtr;
begin
  temp:=TGdomString.create(value);
  if FGNode.type_=ATTRIBUTE_NODE then begin
    attr:=xmlAttrPtr(FGNode);
    if attr.children<>nil
      then xmlFreeNodeList(attr.children);
    attr.children:=nil;
    attr.last:=nil;
    //buffer:='';
    //buffer:=xmlEncodeEntitiesReentrant(attr.doc, temp.CString);
    attr.children:=xmlStringGetNodeList(attr.doc, temp.CString);
    tmp:=attr.children;
    while tmp<>nil do begin
      tmp.parent:=xmlNodePtr(attr);
      tmp.doc:=attr.doc;
      if tmp.next=nil
        then attr.last:=tmp;
      tmp:=tmp.next;
    end;
    //ToDo: get the use of buffer working
    //xmlFree(buffer);

  end
  else
    xmlNodeSetContent(FGNode,temp.CString);
  temp.free;
end;

function TGDOMNode.get_nodeType: DOMNodeType;
begin
  result:=domNodeType(FGNode.type_);
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
begin
  if FGNode.type_=ELEMENT_NODE
    then result:=TGDOMNamedNodeMap.Create(FGNode,FOwnerDocument)
      as IDOMNamedNodeMap
    else result:=nil;
end;

function TGDOMNode.get_ownerDocument: IDOMDocument;
begin
  if FGNode.type_<>Document_Node
    then result:=FOwnerDocument
    else begin
      if FOwnerDocument=nil
        then result:=self as IDOMDocument
        else result:=FOwnerDocument;
    end;
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
var node: xmlNodePtr;
begin
  if self.isAncestorOrSelf(GetGNode(newChild))
    then CheckError(HIERARCHY_REQUEST_ERR);
  if newChild<>nil
    then node:=xmlAddPrevSibling(GetGNode(refChild),GetGNode(newChild))
    else node:=nil;
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
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
			result:=MakeNode(node,FOwnerDocument) as IDOMNode
    end
    else result:=nil;
end;

function TGDOMNode.removeChild(const childNode: IDOMNode): IDOMNode;
begin
  if childNode<>nil
    then begin
      xmlUnlinkNode(GetGNode(childNode));
    end;
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
  if node=nil then CheckError(Not_Supported_Err);
  if self.IsReadOnly
    then CheckError(NO_MODIFICATION_ALLOWED_ERR);
  if not (newChild.NodeType in FAllowedChildTypes)
    then CheckError(HIERARCHY_REQUEST_ERR);
  if FGNode.type_=Document_Node then
    if (newChild.nodeType = Element_Node) and (xmlDocGetRootElement(xmlDocPtr(FGNode))<>nil)
      then CheckError(HIERARCHY_REQUEST_ERR);
  if node.doc<>FGNode.doc
    then CheckError(WRONG_DOCUMENT_ERR);
  if self.isAncestorOrSelf(GetGNode(newChild))
    then CheckError(HIERARCHY_REQUEST_ERR);
  {if self.isAncestorOrSelf(xmlDocGetRootElement(xmlDocPtr(FGNode)))
    then if (newChild.nodeType = Element_Node) then begin
      attr:=node.properties;
      while attr<>nil do begin
        (FOwnerDocument as IDOMInternal).appendAttr(attr);
      end;
    end;}
  if IsReadOnlyNode(node.parent)
    then CheckError(NO_MODIFICATION_ALLOWED_ERR);
  if node.parent<>nil
    then xmlUnlinkNode(node);
//  if node.type_=XML_ATTRIBUTE_NODE then begin
//    (FOwnerDocument as IDOMInternal).removeAttr(xmlAttrPtr(node));
//  end;
  node:=xmlAddChild(FGNode,node);
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

function TGDOMNode.isSupported(const feature, version: DOMString): WordBool;
begin
  if (((upperCase(feature)='CORE') and (version='2.0')) or
     (upperCase(feature)='XML')  and (version='2.0')) //[pk] ??? what ???
    then result:=true
  else result:=false;
end;

constructor TGDOMNode.Create(ANode: xmlNodePtr;ADocument:IDOMDocument);
begin
  inherited create;
  Assert(Assigned(ANode));
  FGNode := ANode;
  FOwnerDocument:=ADocument;
  inc(nodecount);
end;

destructor TGDOMNode.destroy;
begin
  dec(nodecount);
  FOwnerDocument:=nil;
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
  FXpathObject := nil;
  FOwnerDocument := ADocument;
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
  FOwnerDocument := ADocument;
end;

destructor TGDOMNodeList.destroy;
begin
  FOwnerDocument:=nil;
  if FXPathObject<>nil then
    xmlXPathFreeObject(FXPathObject);
  inherited destroy;
end;

function TGDOMNodeList.get_item(index: Integer): IDOMNode;
var
  node: xmlNodePtr;
  i: integer;
begin
  i:=index;
  node:=nil;
  if FParent<>nil then begin
    node:=FParent.children;
    while (i>0) and (node.next<>nil) do begin
      dec(i);
      node:=node.next
    end;
    if i>0 then checkError(INDEX_SIZE_ERR);
  end else begin
      if FXPathObject<>nil
        then node:=xmlXPathNodeSetItem(FXPathObject.nodesetval,i)
        else checkError(101);
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
  name1:TGdomString;
begin
  node:=GNamedNodeMap;
  if node<>nil then begin
    name1:=TGdomString.create(name);
    node:=xmlNodePtr(xmlHasProp(FGNamedNodeMap,name1.CString));
    name1.free;
  end;
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
end;

function TGDOMNamedNodeMap.setNamedItem(const newItem: IDOMNode): IDOMNode;
var
  xmlNewAttr,attr: xmlAttrPtr;
  node: xmlNodePtr;
begin
  node:=FGNamedNodeMap;
  xmlNewAttr:=xmlAttrPtr(GetGNode(newItem));
  //todo: check type of newItem
  attr:=setattr(node,xmlNewAttr);
  (FOwnerDocument as IDOMInternal).removeAttr(xmlnewAttr);
  FGNamedNodeMap:=node;
    if attr<>nil
      then begin
        (FOwnerDocument as IDOMInternal).appendAttr(attr);
        result:=TGDomAttr.Create(attr,FOwnerDocument) as IDOMNode
      end
      else result:=nil;
end;

function TGDOMNamedNodeMap.removeNamedItem(const name: DOMString): IDOMNode;
var
  node: xmlNodePtr;
  name1:TGdomString;
begin
  node:=GNamedNodeMap;
  if node<>nil then begin
    name1:=TGdomString.create(name);
    node:=xmlNodePtr(xmlUnsetProp(FGNamedNodeMap,name1.CString));
    name1.free;
  end;
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
end;

function TGDOMNamedNodeMap.getNamedItemNS(const namespaceURI, localName: DOMString): IDOMNode;
var
  node: xmlNodePtr;
  name1,name2:TGdomString;
begin
  node:=GNamedNodeMap;
  if node<>nil then begin
    name1:=TGdomString.create(namespaceURI);
    name2:=TGdomString.create(localName);
    node:=xmlNodePtr(xmlHasNSProp(FGNamedNodeMap,name2.CString,name1.CString));
    name1.free;
    name2.free;
  end;
  if node<>nil
		then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
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
        then result:=TGDomAttr.Create(attr,FOwnerDocument) as IDOMAttr
        else result:=nil;
    end;
  end else result:=nil;
end;

function TGDOMNamedNodeMap.removeNamedItemNS(const namespaceURI, localName: DOMString): IDOMNode;
var
  node: xmlNodePtr;
  attr: xmlAttrPtr;
  name1,name2:TGdomString;
begin
  node:=GNamedNodeMap;
  if node<>nil then begin
    name1:=TGdomString.create(namespaceURI);
    name2:=TGdomString.create(localName);
    attr:=(xmlHasNsProp(FGNamedNodeMap,name2.CString,name1.CString));
    if attr<>nil
      then begin
        node:=xmlNodePtr(xmlCopyProp(nil,attr));
        xmlRemoveProp(attr);
      end else node:=nil;
    name1.free;
    name2.free;
	end;
  if node<>nil
    then result:=MakeNode(node,FOwnerDocument) as IDOMNode
    else result:=nil;
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
  checkError(NOT_SUPPORTED_ERR);
  //DOMVendorNotSupported('get_ownerElement', SGXML); { Do not localize }
  Result := nil;
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

constructor TGDOMAttr.Create(AAttribute: xmlAttrPtr;ADocument:IDOMDocument;freenode:boolean=false);
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
  //temp: xmlAttrPtr;
begin
  name1:=TGdomString.create(name);
  name2:=TGdomString.create(value);
  {temp:=}xmlSetProp(xmlNodePtr(GElement),name1.CString,name2.CString);
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

function setAttr(var node:xmlNodePtr; xmlNewAttr:xmlAttrPtr):xmlAttrPtr;
var
  attr,oldattr: xmlAttrPtr;
  replace: boolean;
  temp: string;
begin
  result:=nil;
  if node=nil then exit;
  if xmlNewAttr=nil then exit;
  xmlnewAttr.last:=nil;
  oldattr:=xmlHasProp(node,xmlNewattr.name);     // already an attribute with this name?
  if oldattr<>nil then replace:=true else replace:=false;
  attr:=node.properties;                         // get the old attr-list
  if (attr=nil)                                 // if it is empty or its an attribute with the same name
    then begin
      xmlNewAttr.next:=nil;
      xmlNewAttr.last:=nil;
      node.properties:=xmlnewAttr;               // replace it with the newattr
    end
    else begin
       if xmlStrCmp(attr.name,xmlNewAttr.name)=0 then begin
         xmlNewAttr.last:=nil;
         xmlNewAttr.next:=attr.next;
         node.properties:=xmlnewAttr;               // replace it with the newattr
       end else begin
         while attr.next <> nil do begin
           if xmlStrCmp(attr.next.name,xmlNewattr.name)=0
             then begin
               attr.next:=xmlNewAttr;
               if attr=node.properties
                 then node.properties.next:=xmlNewAttr;
               attr:=attr.next;
               xmlNewAttr.next:=attr.next;
               temp:=xmlNewAttr.children.content;
               temp:=attr.children.content;
               attr:=xmlNewAttr;

               break;
             end;
           attr:=attr.next
         end;
         if not replace then begin
           xmlNewAttr.next:=nil;
           attr.next:=xmlNewAttr
         end;
       end;
    end;
  result:=oldattr;
end;

function TGDOMElement.setAttributeNode(const newAttr: IDOMAttr):IDOMAttr;
var
  xmlnewAttr,oldattr: xmlAttrPtr;
  temp: string;
  node: xmlNodePtr;
begin
  if newAttr<>nil then begin
    xmlnewAttr:=xmlAttrPtr(GetGNode(newAttr));     // Get the libxml2-Attribute
    xmlnewAttr.last:=nil;
    node:=xmlNodePtr(GElement);
    oldAttr:=setAttr(node,xmlNewAttr);
    (FOwnerDocument as IDOMInternal).removeAttr(xmlnewAttr);
    if oldattr<>nil
      then begin
        temp:=oldattr.name;
        oldattr.parent:=nil;
        result:=TGDomAttr.Create(oldattr,FOwnerDocument) as IDOMAttr;
        (FOwnerDocument as IDOMInternal).appendAttr(oldattr);
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
		node:=xmlNodePtr(GElement);
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
      //(FOwnerDocument as IDOMInternal).appendAttr(oldAttr1);
      if oldattr<>nil
        then begin
          result:=oldattr;
          (FOwnerDocument as IDOMInternal).appendAttr(xmlNewattr);
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
var
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
  //temp: xmlAttrPtr;
  value1: TGdomString;
begin
  value1:=TGdomString.create(value);
  ns := TGDOMNamespace.create(xmlNodePtr(GElement),namespaceURI,qualifiedName,get_ownerDocument);
  node:=xmlNodePtr(GElement);
  xmlSetNs(node,ns.ns);
  {temp:=}xmlSetNSProp(xmlNodePtr(GElement),ns.NS,ns.localName.CString,value1.CString);
  value1.free;
  ns.Free;
  //todo: raise exception if temp=nil?
end;

procedure TGDOMElement.removeAttributeNS(const namespaceURI, localName: DOMString);
var
  attr{,attr1}: xmlAttrPtr;
  name1,name2: TGdomString;
  ok: integer;
  //ns: TGdomNamespace;
begin
  name1:=TGdomString.create(localName);
  name2:=TGdomString.create(namespaceURI);
  attr := xmlHasNSProp(xmlNodePtr(GElement), name1.CString,name2.CString);
  name1.free;
  name2.free;
  if attr <> nil
    then begin
      ok:=xmlRemoveProp(attr);
      if ok<>0 then checkerror(103);
      name1:=TGdomString.create(localName);
      //ns := TGDOMNamespace.create(nil,namespaceURI,qualifiedName);
      //ok:=xmlUnsetNsProp(xmlNodePtr(GElement),ns.ns,name1.CString);
      //ns.free;
      name2:=TGdomString.create(namespaceURI);

      //attr1 := xmlHasNSProp(xmlNodePtr(GElement), name1.CString,name2.CString);
      name1.free;
      name2.free;
    end;
end;

function TGDOMElement.getAttributeNodeNS(const namespaceURI, localName: DOMString): IDOMAttr;
var
  temp: xmlAttrPtr;
  name1,name2: TGdomString;
  tstring:string;
begin
  name1:=TGdomString.create(namespaceURI);
  name2:=TGdomString.create(localName);
  temp:=xmlHasNSProp(xmlNodePtr(GElement), name2.CString,name1.CString);
  tstring:=temp.ns.href;
  tstring:=temp.ns.prefix;
  name1.Free;
  name2.free;
  if temp<>nil
    then result:=TGDOMAttr.Create(temp,FOwnerDocument) as IDOMAttr
    else result:=nil;
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
    node:=xmlNodePtr(GElement);
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
    (FOwnerDocument as IDOMInternal).removeAttr(xmlnewAttr);
    if oldattr<>nil
      then begin
        temp:=oldattr.name;
        result:=TGDomAttr.Create(oldattr,FOwnerDocument) as IDOMAttr;
        (FOwnerDocument as IDOMInternal).appendAttr(oldattr);
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

function TGDOMElement.hasAttribute(const name: DOMString): WordBool;
var
  name1: TGdomString;
begin
  name1:=TGdomString.create(name);
  if xmlHasProp(xmlNodePtr(GElement),name1.CString) <> nil
    then result:=true
    else result:=false;
  name1.free;
end;


function TGDOMElement.hasAttributeNS(const namespaceURI, localName: DOMString): WordBool;
var
  name1,name2: TGdomString;
  temp: string;
  node:xmlNodePtr;
begin
  name2:=TGdomString.create(namespaceURI);
  name1:=TGdomString.create(localName);
  node:=xmlNodePtr(GElement);
  if node.ns<>nil then begin
    temp:=node.ns.href;
    temp:=node.ns.prefix;
  end;
  if (xmlGetNSProp(xmlNodePtr(GElement),name1.CString,
    name2.CString)) <> nil
    then result:=true
    else result:=false;
  name1.free;
  name2.free;
end;

procedure TGDOMElement.normalize;
begin
  inherited normalize;
end;

constructor TGDOMElement.Create(AElement: xmlNodePtr;ADocument:IDOMDocument;freenode:boolean=false);
begin
  inc(elementcount);
  inherited create(xmlNodePtr(AElement),ADocument);
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

constructor TGDOMDocument.create(
               GDOMImpl:IDOMImplementation;
               const namespaceURI, qualifiedName: DOMString;
               doctype: IDOMDocumentType);
var
  name2: TGdomString;
  root:xmlNodePtr;
begin
  FGdomimpl:=GDOMImpl;
  FPGdomeDoc:=xmlNewDoc(XML_DEFAULT_VERSION);
  name2:=TGdomString.create(qualifiedName);
  FPGdomeDoc.children:=xmlNewDocNode(FPGdomeDoc,nil,name2.CString,nil);
  name2.Free;
  //Get root-node
  root:= xmlNodePtr(FPGdomeDoc);

  FAttrList:=TList.Create;
  FNodeList:=TList.Create;
  FNsList:=TList.Create;
 //Create root-node as pascal object
  inherited create(root,nil);
  inc(doccount);
end;

destructor TGDOMDocument.destroy;
var
  i: integer;
  AAttr: xmlAttrPtr;
  ANode: xmlNodePtr;
  //ANs:   xmlNsPtr;
begin
  if FPGdomeDoc<>nil then begin

{
    for i:=0 to FNsList.Count-1 do begin
      ANs:=FNsList[i];
      if (ANs<>nil) and (ANs<>FPGdomeDoc.oldNs)
        then xmlFreeNs(ANs);
    end;
}

    for i:=0 to FNodeList.Count-1 do begin
      ANode:=FNodeList[i];
      if ANode<>nil
        then if (ANode.parent=nil)
          then begin
            //ANode.ns:=nil;
            //ANode.nsDef:=nil;
            if ANode.type_=xml_element_node then begin
              AAttr:=ANode.properties;
              while AAttr<>nil do begin
                FAttrList.Remove(AAttr);
                AAttr:=AAttr.next
              end;
            end;
            xmlFreeNode(ANode)
          end;
    end;

    for i:=0 to FAttrList.Count-1 do begin
      AAttr:=FAttrList[i];
      if AAttr<>nil then
        if (AAttr.parent=nil) then
          if (AAttr.ns=nil)
            then xmlFreeProp(AAttr)
            else begin
              if AAttr.ns<>nil then xmlFreeNs(AAttr.ns);
              AAttr.ns:=nil;
              xmlFreeProp(AAttr);
            end;
    end;



    xmlFreeDoc(FPGdomeDoc);
    dec(doccount);

    FAttrList.Free;
    FNodeList.Free;
    FNsList.Free;
  end;
  inherited Destroy;
end;

// IDOMDocument
function TGDOMDocument.get_doctype: IDOMDocumentType;
var dtd: xmlDtdPtr;
begin
  dtd:=FPGdomeDoc.intSubset;
  if dtd <> nil
    then result:=TGDOMDocumentType.Create(dtd,self)
    else result:=nil;
end;

function TGDOMDocument.get_domImplementation: IDOMImplementation;
begin
  result:=FGDOMImpl;
end;

function TGDOMDocument.get_documentElement: IDOMElement;
var
	root1:xmlNodePtr;
	FGRoot: TGDOMElement;
begin
  root1:= xmlDocGetRootElement(FPGdomeDoc);
  if root1<>nil
    then FGRoot:=TGDOMElement.create(root1,self)
    else FGRoot:=nil;
  Result := FGRoot;
end;

procedure TGDOMDocument.set_documentElement(const IDOMElement: IDOMElement);
begin
  checkError(NOT_SUPPORTED_ERR);
end;

function TGDOMDocument.createElement(const tagName: DOMString): IDOMElement;
var
  name1: TGdomString;
	AElement: xmlNodePtr;
begin
  name1:=TGdomString.create(tagName);
  AElement:=xmlNewDocNode(FPGdomeDoc,nil,name1.CString,nil);
  name1.free;
  if AElement<>nil
    then begin
      AElement.parent:=nil;
      FNodeList.Add(AElement);
      result:=TGDOMElement.Create(AElement,self)
    end
    else result:=nil;
end;

function TGDOMDocument.createDocumentFragment: IDOMDocumentFragment;
var
  node: xmlNodePtr;
begin
  node := xmlNewDocFragment(FPGdomeDoc);
  if node<>nil
    then begin
      FNodeList.Add(node);
      result:=TGDOMDocumentFragment.Create(node,self)
    end
    else result:=nil;
end;

function TGDOMDocument.createTextNode(const data: DOMString): IDOMText;
var
  data1: TGdomString;
  ATextNode: xmlNodePtr;
begin
  data1:=TGdomString.create(data);
  ATextNode:=xmlNewDocText(FPGdomeDoc,data1.CString);
  data1.free;
  if ATextNode<> nil
    then begin
      FNodeList.Add(ATextNode);
      result:=TGDOMText.Create((ATextNode),self)
    end
    else result:=nil;
end;

function TGDOMDocument.createComment(const data: DOMString): IDOMComment;
var
  data1: TGdomString;
  node: xmlNodePtr;
begin
  data1:=TGdomString.create(data);
  node := xmlNewDocComment(FPGdomeDoc, data1.CString);
  data1.free;
  if node<>nil
    then begin
      FNodeList.Add(node);
      result:=TGDOMComment.Create(PGdomeCharacterData(node),self)
    end
    else result:=nil;
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
    then begin
      FNodeList.Add(node);
      result:=TGDOMCDataSection.Create(node,self,false)
    end
    else result:=nil;
end;

function TGDOMDocument.createProcessingInstruction(const target,
  data: DOMString): IDOMProcessingInstruction;
var
  name1,name2: TGdomString;
	AProcessingInstruction: PGdomeProcessingInstruction;
begin
  name1:=TGdomString.create(target);
  name2:=TGdomString.create(data);
  AProcessingInstruction:=xmlNewPI(name1.CString, name2.CString);
  name1.free;
  name2.free;
  if AProcessingInstruction <>nil
    then begin
      AProcessingInstruction.parent:=nil;
      AProcessingInstruction.doc:=FPGdomeDoc;
      FNodeList.Add(AProcessingInstruction);
      result:=TGDOMProcessingInstruction.Create(AProcessingInstruction,self)
    end
    else result:=nil;
end;

function TGDOMDocument.createAttribute(const name: DOMString): IDOMAttr;
var
  name1: TGdomString;
  AAttr: xmlAttrPtr;
begin
  name1:=TGdomString.create(name);
  AAttr:=xmlNewDocProp(FPGdomeDoc,name1.CString,nil);
  AAttr.parent:=nil;
  name1.free;
  if AAttr<>nil
    then begin
      FAttrList.Add(AAttr);
      result:=TGDOMAttr.Create(AAttr,self)
    end else result:=nil;
end;

function TGDOMDocument.createEntityReference(const name: DOMString): IDOMEntityReference;
//var
  //name1: TGdomString;
  //AEntityReference: PGdomeEntityReference;
begin
  checkError(NOT_SUPPORTED_ERR);
  {name1:=TGdomString.create(name);
  AEntityReference:=gdome_doc_createEntityReference(FPGdomeDoc,name1.GetPString,@exc);
  CheckError(exc);
  name1.free;
  if AEntityReference<>nil
    then result:=TGDOMEntityReference.Create(xmlNodePtr(AEntityReference),self)
    else result:=nil;}
end;

function TGDOMDocument.getElementsByTagName(const tagName: DOMString): IDOMNodeList;
begin
  result:=(self.get_documentElement as IDOMNodeSelect).selectNodes(tagName);
end;

function TGDOMDocument.importNode(importedNode: IDOMNode; deep: WordBool): IDOMNode;
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
    DOCUMENT_NODE,DOCUMENT_TYPE_NODE,NOTATION_NODE,ENTITY_NODE: CheckError(21);
    ATTRIBUTE_NODE: CheckError(21); //ToDo: implement this case
  else
    if deep
      then recurse:=1
      else recurse:=0;
    node:=xmlDocCopyNode(GetGNode(importedNode),FPGdomeDoc,recurse);
    if node <> nil
      then result:=MakeNode(node,self)
      else result:=nil;
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

function TGDOMDocument.createElementNS(const namespaceURI,
  qualifiedName: DOMString): IDOMElement;
var
  AElement: xmlNodePtr;
  ns: TGDOMNamespace;
  temp:string;
begin
  ns := TGDOMNamespace.create(nil,namespaceURI,qualifiedName,self);
  AElement:=xmlNewDocNode(FPGdomeDoc,ns.NS,ns.localName.CString,nil);
  temp:=AElement.ns.href;
  temp:=AElement.ns.prefix;
  AElement.nsdef:=ns.NS;
  ns.free;
  if AElement<>nil
    then result:=TGDOMElement.Create(AElement,self)
    else result:=nil;
end;

function TGDOMDocument.createAttributeNS(const namespaceURI,
  qualifiedName: DOMString): IDOMAttr;
var
  AAttr: xmlAttrPtr;
  ns: TGDOMNameSpace;
  //temp:string;
begin
  ns := TGDOMNamespace.create(nil,namespaceURI,qualifiedName,self);
  AAttr:=xmlNewNsProp(nil,ns.ns,ns.localName.CString,nil);
  ns.free;
  if AAttr<>nil
    then begin
      FAttrList.Add(AAttr);
      result:=TGDOMAttr.Create(AAttr,self)
    end else result:=nil;
end;

function TGDOMDocument.getElementsByTagNameNS(const namespaceURI,
  localName: DOMString): IDOMNodeList;
var docElement:IDOMElement;
begin
  docElement:=self.get_documentElement;
  result:=docElement.getElementsByTagNameNS(namespaceURI,localName);
end;

function TGDOMDocument.getElementById(const elementId: DOMString): IDOMElement;
//var
  //AElement: xmlElementPtr;
  //name1: TGdomString;
begin
  checkError(NOT_SUPPORTED_ERR);
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
  CString,encoding:pchar;
  length:LongInt;
begin
  CString:='';
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
//  filename:=StringReplace(source, '\', '/', [rfReplaceAll]);
	filename:=source;
	xmlFreeDoc(FPGdomeDoc);
//	inherited Destroy;
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
  checkError(NOT_SUPPORTED_ERR);
  result:=false;
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
  checkError(NOT_SUPPORTED_ERR);
end;

procedure TGDOMDocument.set_OnAsyncLoad(const Sender: TObject;
  EventHandler: TAsyncEventHandler);
begin
  checkError(NOT_SUPPORTED_ERR);
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
    101: result:='INVALID_NODE_SET_ERR';
    102: result:='PARSE_ERR';
  else
    result:='Unknown error no: '+inttostr(err);
  end;
end;

procedure CheckError(err:integer);
begin
  if err <>0
    then raise EDOMException.Create(ErrorString(err));
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
//var
//  temp:PGdomeDomString;
begin
  checkError(NOT_SUPPORTED_ERR);
  {temp:=gdome_cd_substringData(GCharacterData,offset,count,@exc);
	CheckError(exc);
  result:=GdomeDOMStringToString(temp);}
end;

constructor TGDOMCharacterData.Create(ACharacterData: xmlNodePtr;
  ADocument: IDOMDocument;freenode:boolean=false);
begin
  inherited create(xmlNodePtr(ACharacterData),ADocument);
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
  checkError(NOT_SUPPORTED_ERR);
  //result:=GdomeDOMStringToString(gdome_ent_notationName(GEntity,@exc));
  //CheckError(exc);
end;

function TGDOMEntity.get_publicId: DOMString;
begin
  checkError(NOT_SUPPORTED_ERR);
  //result:=GdomeDOMStringToString(gdome_ent_publicID(GEntity,@exc));
  //CheckError(exc);
end;

function TGDOMEntity.get_systemId: DOMString;
begin
  checkError(NOT_SUPPORTED_ERR);
  //result:=GdomeDOMStringToString(gdome_ent_systemID(GEntity,@exc));
end;

function TGDOMEntity.GetGEntity: PGdomeEntity;
begin
  checkError(NOT_SUPPORTED_ERR);
  //result:=PGdomeEntity(GNode);
  result:=nil;
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

function TGDOMProcessingInstruction.GetGProcessingInstruction: PGdomeProcessingInstruction;
begin
  result:=PGdomeProcessingInstruction(GNode);
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
  checkError(NOT_SUPPORTED_ERR);
  {entities:=gdome_dt_entities(GDocumentType,@exc);
  CheckError(exc);
  if entities<>nil
    then result:=TGDOMNamedNodeMap.Create(entities,FOwnerDocument) as IDOMNamedNodeMap
    else result:=nil;}
end;

function TGDOMDocumentType.get_internalSubset: DOMString;
var
  buff:xmlBufferPtr;
begin
  buff:=xmlBufferCreate();
  xmlNodeDump(buff,nil,xmlNodePtr(GetGDocumentType),0,0);
  result:=libxmlStringToString(buff.content);
  xmlBufferFree(buff);
end;

function TGDOMDocumentType.get_name: DOMString;
begin
  result:=self.get_nodeName;
end;

function TGDOMDocumentType.get_notations: IDOMNamedNodeMap;
//var
//  notations: PGdomeNamedNodeMap;
//  exc: GdomeException;
begin
  checkError(NOT_SUPPORTED_ERR);
  //Implementing this method requires to implement a new
  //type of NodeList
  //GetGDocumentType.notations;
  {notations:=gdome_dt_notations(GDocumentType,@exc);
	CheckError(exc);
  if notations<>nil
    then result:=TGDOMNamedNodeMap.Create(notations,FOwnerDocument) as IDOMNamedNodeMap
    else result:=nil;}
end;

function TGDOMDocumentType.get_publicId: DOMString;
begin
  result:=libxmlStringToString(GetGDocumentType.ExternalID);
end;

function TGDOMDocumentType.get_systemId: DOMString;
begin
  result:=libxmlStringToString(GetGDocumentType.SystemID);
end;

function TGDOMDocumentType.GetGDocumentType: xmlDtdPtr;
begin
  result:=xmlDtdPtr(GNode);
end;

constructor TGDOMDocumentType.Create(dtd:xmlDtdPtr;ADocument:IDOMDocument);
var
  root:xmlNodePtr;
begin
  //Get root-node
  root:= xmlNodePtr(dtd);
  //Create root-node as pascal object
  inherited create(root,ADocument);
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
  checkError(NOT_SUPPORTED_ERR);
  //temp:=GdomeDOMStringToString(gdome_not_publicId(GNotation, @exc));
  //CheckError(exc);
  //result:=temp;
end;

function TGDOMNotation.get_systemId: DOMString;
//var
//  temp: String;
begin
  checkError(NOT_SUPPORTED_ERR);
  //temp:=GdomeDOMStringToString(gdome_not_systemId(GNotation, @exc));
  //CheckError(exc);
  //result:=temp;
end;

function TGDOMNotation.GetGNotation: PGdomeNotation;
begin
  result:=PGdomeNotation(GNode);
end;

{ TGDOMNameSpace }

constructor TGDOMNameSpace.create(node:xmlNodePtr;
  namespaceURI,qualifiedName: DOMString;OwnerDoc:IDOMDocument);
var
  name1,name3: TGdomString;
  prefix: string;
begin
  FOwnerDoc:=OwnerDoc;
  name1:=TGdomString.create(namespaceURI);
  prefix := Copy(qualifiedName,1,Pos(':',qualifiedName)-1);
  FqualifiedName:=TGdomString.create(qualifiedName);
  localName:=TGdomString.create(Copy(qualifiedName,Pos(':',qualifiedName)+1,
    length(qualifiedName)-length(prefix)-1));
  name3:=TGdomString.create(prefix);
  ns := xmlNewNs(node, name1.CString, name3.CString);
  name1.free;
  name3.free;
end;

destructor TGDOMNameSpace.destroy;
begin
  (FOwnerDoc as IDOMInternal).appendNs(Ns);
  FOwnerDoc:=nil;
  localName.free;
  FqualifiedName.Free;
  inherited destroy;
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
	if doc=nil then CheckError(100);
	ctxt:=xmlXPathNewContext(doc);
	ctxt.node:=FGNode;
	{ok:=}xmlXPathRegisterNs(ctxt,pchar(FPrefix),pchar(FURI));
	res:=xmlXPathEvalExpression(pchar(temp),ctxt);
	if res<>nil then  begin
		nodetype:=res.type_;
		case nodetype of
		XPATH_NODESET:
			begin
				nodecount:=res.nodesetval.nodeNr;
				result:=TGDOMNodeList.Create(res,FOwnerDocument)
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
  checkError(NOT_SUPPORTED_ERR);
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
  FPrefix:=prefix;
  FURI:=URI;
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
var
  root:xmlNodePtr;
begin
  FGdomimpl:=GDOMImpl;
  FPGdomeDoc:=xmlNewDoc(XML_DEFAULT_VERSION);
  //Get root-node
  root:= xmlNodePtr(FPGdomeDoc);
  FAttrList:=TList.Create;
  FNodeList:=TList.Create;
  FNsList:=TList.Create;
  //Create root-node as pascal object
  inherited create(root,nil);
  inc(doccount);
end;

constructor TGDOMDocument.Create(GDOMImpl: IDOMImplementation; aUrl: DomString);
var
  root:xmlNodePtr;
  fn: string;
begin
  FGdomimpl:=GDOMImpl;
  FPGdomeDoc:=xmlNewDoc(XML_DEFAULT_VERSION);
  //Get root-node
  {$ifdef WIN32}
    fn := UTF8Encode(StringReplace(aUrl, '\', '\\', [rfReplaceAll]));
  {$else}
    fn := aUrl;
  {$endif}
  root:= xmlNodePtr(xmlParseFile(PChar(fn)));
  if (root=nil) then begin
    checkError(102);
  end;
  FAttrList:=TList.Create;
  FNodeList:=TList.Create;
  FNsList:=TList.Create;
  //Create root-node as pascal object
  inherited create(root,nil);
  inc(doccount);
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

procedure TGDOMDocument.appendNs(ns: xmlNsPtr);
begin   if ns<>nil     then FNsList.add(ns); end;  initialization
  RegisterDomVendorFactory(TGDOMDocumentBuilderFactory.Create(False));
finalization
end.
