unit libxmldomFE;

{
  ------------------------------------------------------------------------------
   This unit is an object-oriented wrapper for libxml2.
   It implements the interfaces defined in idom2.pas.

   Original author:
   Uwe Fechner <ufechner@4commerce.de>

   Contributers:
   Martijn Brinkers <m.brinkers@pobox.com>
   Petr Kozelka     <pkozelka@centrum.cz>

   Thanks to the gdome2 project, where I got many ideas from.
   (see: http://phd.cs.unibo.it/gdome2/)

   Thanks to Jan Kubatzki for testing.

   | The routines for testing XML rules were taken from the Extended Document
   | Object Model (XDOM) package, copyright (c) 1999-2002 by Dieter Köhler.
   | The latest XDOM version is available at "http://www.philo.de/xml/" under
   | a different open source license.  In addition, the author gave permission
   | to use the routines for testing XML rules included in this file under the
   | terms of either MPL 1.1, GPL 2.0 or LGPL 2.1.


   Copyright:
   4commerce technologies AG
   Kamerbalken 10-14
   22525 Hamburg, Germany

   http://www.4commerce.de

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
  // IDomPersist
  //
  // Not Supported by libxml2:
  // IDomParseError (extended interface, not part of dom-spec)


interface


uses
  {$ifdef VER130} //Delphi 5
  unicode,
  {$endif}
  classes,
  idom2,
  idom2_ext,
  libxml2,
  libxslt,
  sysutils,
  strutils;

const

  SLIBXML = 'LIBXML_4CT';  { Do not localize }

type

  { TGDOMInterface }

  TGDOMInterface = class(TInterfacedObject)
  public
    function SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HRESULT;
      override;
  end;

  { IXMLDOMNodeRef }

  IXMLDOMNodeRef = interface
    ['{7787A532-C8C8-4F3C-9529-29098FE954B0}']
    function GetGDOMNode: xmlNodePtr;
  end;

  { TGDOMImplementation }

  TGDOMImplementation = class(TGDOMInterface, IDomImplementation,IDomDebug)
  private
    Fdoccount: integer;
  protected
    { IDomImplementation }
    function hasFeature(const feature, version: DOMString): boolean;
    function createDocumentType(const qualifiedName, publicId,
      systemId: DOMString): IDomDocumentType;
    function createDocument(const namespaceURI, qualifiedName: DOMString;
      doctype: IDomDocumentType): IDomDocument;
    { IDomDebug }
    procedure set_doccount(doccount: integer);
    function get_doccount: integer;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TGDOMNodeClass = class of TGDOMNode;

  TGDOMNode = class(TGDOMInterface, IDomNode, IXMLDOMNodeRef, IDomNodeSelect,
      IDomNodeExt, IDomNodeCompare)
  private
    FGNode: xmlNodePtr;
    FOwnerDocument: IDomDocument;

  protected
    function GetGDOMNode: xmlNodePtr; //new
    function IsReadOnly: boolean;     //new
    function IsAncestorOrSelf(newNode: xmlNodePtr): boolean; //new
    // IDomNode
    function get_nodeName: DOMString;
    function get_nodeValue: DOMString;
    procedure set_nodeValue(const Value: DOMString);
    function get_nodeType: DOMNodeType;
    function get_parentNode: IDomNode;
    function get_childNodes: IDomNodeList;
    function get_firstChild: IDomNode;
    function get_lastChild: IDomNode;
    function get_previousSibling: IDomNode;
    function get_nextSibling: IDomNode;
    function get_attributes: IDomNamedNodeMap;
    function get_ownerDocument: IDomDocument;
    function get_namespaceURI: DOMString;
    function get_prefix: DOMString;
    procedure set_Prefix(const prefix: DomString);
    function get_localName: DOMString;
    function insertBefore(const newChild, refChild: IDomNode): IDomNode;
    function replaceChild(const newChild, oldChild: IDomNode): IDomNode;
    function removeChild(const childNode: IDomNode): IDomNode;
    function appendChild(const newChild: IDomNode): IDomNode;
    function hasChildNodes: boolean;
    function hasAttributes: boolean; 
    function cloneNode(deep: boolean): IDomNode;
    procedure normalize;
    function IsSupported(const feature, version: DOMString): boolean;
    { IDomNodeSelect }
    function selectNode(const nodePath: WideString): IDomNode;
    function selectNodes(const nodePath: WideString): IDomNodeList;
    procedure RegisterNS(const prefix, URI: DomString);
    { IDomNodeEx}
    procedure transformNode(const stylesheet: IDomNode; var output: DomString); overload;
    procedure transformNode(const stylesheet: IDomNode; var output: IDomDocument);
      overload;
    function get_text: DomString;
    procedure set_text(const Value: DomString);
    function get_xml: DOMString;
    property Text: DomString read get_text write set_text;
    property xml: DOMString read get_xml;
    { IDomNodeCompare }
    function IsSameNode(node: IDomNode): boolean;
  public
    constructor Create(ANode: xmlNodePtr; ADocument: IDomDocument);
    destructor Destroy; override;
    property GNode: xmlNodePtr read FGNode;
  end;

  TGDOMNodeList = class(TGDOMInterface, IDomNodeList)
  private
    FParent: xmlNodePtr;
    FXPathObject: xmlXPathObjectPtr;
    FOwnerDocument: IDomDocument;
    FAdditionalNode: xmlNodePtr;
  protected
    { IDomNodeList }
    function get_item(index: integer): IDomNode;
    function get_length: integer;
    {IXMLDOMNodeListExt}
    procedure AddNode(node: xmlNodePtr);
  public
    constructor Create(AParent: xmlNodePtr; ADocument: IDomDocument); overload;
    constructor Create(AXpathObject: xmlXPathObjectPtr; ADocument: IDomDocument);
      overload;
    destructor Destroy; override;
  end;

  TGDOMNamedNodeMap = class(TGDOMInterface, IDomNamedNodeMap)
    // this class is used for attributes, entities and notations
    // created with typ=0: attributes
    //              typ=1: entities
  private
    FOwnerElement: xmlNodePtr;  //for attribute-lists only
    FGDTD: xmlDtdPtr;            //for dtd.enties etc
    FGDTD2: xmlDtdPtr;           //external dtd
    FOwnerDocument: IDomDocument;
  protected
    { IDomNamedNodeMap }
    function get_GNamedNodeMap: xmlNodePtr;
    function get_item(index: integer): IDomNode;
    function get_length: integer;
    function getNamedItem(const Name: DOMString): IDomNode;
    function setNamedItem(const newItem: IDomNode): IDomNode;
    function removeNamedItem(const Name: DOMString): IDomNode;
    function getNamedItemNS(const namespaceURI, localName: DOMString): IDomNode;
    function setNamedItemNS(const newItem: IDomNode): IDomNode;
    function removeNamedItemNS(const namespaceURI, localName: DOMString): IDomNode;
  public
    constructor Create(ANamedNodeMap: xmlNodePtr; AOwnerDocument: IDomDocument;
      typ: integer = 0; dtd2: xmlDtdPtr = nil);
    destructor Destroy; override;
    property GNamedNodeMap: xmlNodePtr read get_GNamedNodeMap;
  end;

  { TGDOMAttr }

  TGDOMAttr = class(TGDOMNode, IDomAttr)
  private
    //ns:
    function GetGAttribute: xmlAttrPtr;
  protected
    { Property Get/Set }
    function get_name: DOMString;
    function get_specified: boolean;
    function get_value: DOMString;
    procedure set_value(const attributeValue: DOMString);
    function get_ownerElement: IDomElement;
    { Properties }
    property Name: DOMString read get_name;
    property specified: boolean read get_specified;
    property Value: DOMString read get_value write set_value;
    property ownerElement: IDomElement read get_ownerElement;
  public
    property GAttribute: xmlAttrPtr read GetGAttribute;
    constructor Create(AAttribute: xmlAttrPtr; ADocument: IDomDocument;
      freenode: boolean = False);
    destructor Destroy; override;
  end;

  PGDomeCharacterData = Pointer;

  TGDOMCharacterData = class(TGDOMNode, IDomCharacterData)
  private
    function GetGCharacterData: PGDomeCharacterData;
  protected
    { IDomCharacterData }
    function get_data: DOMString;
    procedure set_data(const Data: DOMString);
    function get_length: integer;
    function substringData(offset, Count: integer): DOMString;
    procedure appendData(const Data: DOMString);
    procedure insertData(offset: integer; const Data: DOMString);
    procedure deleteData(offset, Count: integer);
    procedure replaceData(offset, Count: integer; const Data: DOMString);
  public
    constructor Create(ACharacterData: xmlNodePtr; ADocument: IDomDocument;
      freenode: boolean = False);
    destructor Destroy; override;
    property GCharacterData: PGDomeCharacterData read GetGCharacterData;
  end;

  { TGDOMElement }

  TGDOMElement = class(TGDOMNode, IDomElement)
  private
    function GetGElement: xmlNodePtr;
  protected
    // IDomElement
    function get_tagName: DOMString;
    function getAttribute(const Name: DOMString): DOMString;
    procedure setAttribute(const Name, Value: DOMString);
    procedure removeAttribute(const Name: DOMString);
    function getAttributeNode(const Name: DOMString): IDomAttr;
    function setAttributeNode(const newAttr: IDomAttr): IDomAttr;
    function removeAttributeNode(const oldAttr: IDomAttr): IDomAttr;
    function getElementsByTagName(const Name: DOMString): IDomNodeList;
    function getAttributeNS(const namespaceURI, localName: DOMString): DOMString;
    procedure setAttributeNS(const namespaceURI, qualifiedName, Value: DOMString);
    procedure removeAttributeNS(const namespaceURI, localName: DOMString);
    function getAttributeNodeNS(const namespaceURI, localName: DOMString): IDomAttr;
    function setAttributeNodeNS(const newAttr: IDomAttr): IDomAttr;
    function getElementsByTagNameNS(const namespaceURI,
      localName: DOMString): IDomNodeList;
    function hasAttribute(const Name: DOMString): boolean;
    function hasAttributeNS(const namespaceURI, localName: DOMString): boolean;
    procedure normalize;
  public
    constructor Create(AElement: xmlNodePtr; ADocument: IDomDocument;
      freenode: boolean = False);
    destructor Destroy; override;
    property GElement: xmlNodePtr read GetGElement;
  end;

  { TMSDOMText }

  TGDOMText = class(TGDOMCharacterData, IDomText)
  protected
    function splitText(offset: integer): IDomText;
  end;

  { TGDOMComment }

  TGDOMComment = class(TGDOMCharacterData, IDomComment)
  end;

  { TGDOMCDATASection }

  TGDOMCDATASection = class(TGDOMText, IDomCDATASection)
  private
  public
  end;

  PGdomeDocumentType = record
    dtd1, dtd2: xmlDtdPtr;
  end;

  PGdomeDomImplementation = Pointer;

  TGDOMDocumentType = class(TGDOMNode, IDomDocumentType)
  private
    Fdtd2: xmlDtdPtr;
    function GetGDocumentType: xmlDtdPtr;
  protected
    { IDomDocumentType }
    function get_name: DOMString;
    function get_entities: IDomNamedNodeMap;
    function get_notations: IDomNamedNodeMap;
    function get_publicId: DOMString;
    function get_systemId: DOMString;
    function get_internalSubset: DOMString;
  public
    property GDocumentType: xmlDtdPtr read GetGDocumentType;
    constructor Create(dtd1, dtd2: xmlDtdPtr; ADocument: IDomDocument);
    destructor Destroy; override;
  end;

  { TMSDOMNotation }
  PGdomeNotation = xmlNotationPtr;

  TGDOMNotation = class(TGDOMNode, IDomNotation)
  private
    function GetGNotation: PGdomeNotation;
  protected
    { IDomNotation }
    function get_publicId: DOMString;
    function get_systemId: DOMString;
  public
    property GNotation: PGdomeNotation read GetGNotation;
  end;

  PGdomeEntity = Pointer;

  TGDOMEntity = class(TGDOMNode, IDomEntity)
  private
    function GetGEntity: PGdomeEntity;
  protected
    { IDomEntity }
    function get_publicId: DOMString;
    function get_systemId: DOMString;
    function get_notationName: DOMString;
  public
    property GEntity: PGdomeEntity read GetGEntity;
  end;

  TGDOMEntityReference = class(TGDOMNode, IDomEntityReference)
  end;

  { TGDOMProcessingInstruction }

  PGdomeProcessingInstruction = xmlNodePtr;

  TGDOMProcessingInstruction = class(TGDOMNode, IDomProcessingInstruction)
  private
    function GetGProcessingInstruction: PGdomeProcessingInstruction;
  protected
    { IDomProcessingInstruction }
    function get_target: DOMString;
    function get_data: DOMString;
    procedure set_data(const Value: DOMString);
  public
    property GProcessingInstruction: PGdomeProcessingInstruction
      read GetGProcessingInstruction;
  end;

  IDomInternal = interface
    ['{E9D505C3-D354-4D19-807A-8B964E954C09}']

    {managing the list of nodes and attributes, that must be freed manually}

    procedure removeNode(node: xmlNodePtr);
    procedure removeAttr(attr: xmlAttrPtr);
    procedure appendAttr(attr: xmlAttrPtr);
    procedure appendNode(node: xmlNodePtr);
    procedure appendNS(prefix,uri:string);
    function getPrefixList:TStringList;
    function getUriList:TStringList;

    {managing stylesheets}
    procedure set_FtempXSL(tempXSL: xsltStylesheetPtr);
  end;

  TGDOMDocument = class(TGDOMNode, IDomDocument, IDomParseOptions, IDomPersist,
      IDomInternal, IDomOutputOptions)
  private
    FGDOMImpl: IDomImplementation;
    FPGdomeDoc: xmlDocPtr;
    FtempXSL: xsltStylesheetPtr;   //if the document was used as stylesheet,
                                   //this Pointer has to be freed and not
                                   //the xmlDocPtr
    FAsync: boolean;               //for compatibility, not really supported
    FpreserveWhiteSpace: boolean;  //difficult to support
    FresolveExternals: boolean;    //difficult to support
    Fvalidate: boolean;            //check if default is ok
    FAttrList: TList;              //keeps a list of attributes, created on this document
    FNodeList: TList;              //keeps a list of nodes, created on this document
    FCompressionLevel: integer;
    Fencoding: DomString;
    FprettyPrint: boolean;
    FPrefixList: TStringList; //for xpath
    FURIList: TStringList;    //for xpath
  protected
    // IDomDocument
    function get_doctype: IDomDocumentType;
    function get_domImplementation: IDomImplementation;
    function get_documentElement: IDomElement;
    procedure set_documentElement(const IDomElement: IDomElement);
    function createElement(const tagName: DOMString): IDomElement;
    function createDocumentFragment: IDomDocumentFragment;
    function createTextNode(const Data: DOMString): IDomText;
    function createComment(const Data: DOMString): IDomComment;
    function createCDATASection(const Data: DOMString): IDomCDATASection;
    function createProcessingInstruction(const target,
      Data: DOMString): IDomProcessingInstruction;
    function createAttribute(const Name: DOMString): IDomAttr;
    function createEntityReference(const Name: DOMString): IDomEntityReference;
    function getElementsByTagName(const tagName: DOMString): IDomNodeList;
    function importNode(importedNode: IDomNode; deep: boolean): IDomNode;
    function createElementNS(const namespaceURI,
      qualifiedName: DOMString): IDomElement;
    function createAttributeNS(const namespaceURI,
      qualifiedName: DOMString): IDomAttr;
    function getElementsByTagNameNS(const namespaceURI,
      localName: DOMString): IDomNodeList;
    function getElementById(const elementId: DOMString): IDomElement;
    // IDomParseOptions
    function get_async: boolean;
    function get_preserveWhiteSpace: boolean;
    function get_resolveExternals: boolean;
    function get_validate: boolean;
    procedure set_async(Value: boolean);
    procedure set_preserveWhiteSpace(Value: boolean);
    procedure set_resolveExternals(Value: boolean);
    procedure set_validate(Value: boolean);
    // IDomPersist
    function get_xml: DOMString;
    function asyncLoadState: integer;
    function load(Source: DOMString): boolean;
    function loadFromStream(const stream: TStream): boolean;
    function loadxml(const Value: DOMString): boolean;
    procedure save(Source: DOMString);
    procedure saveToStream(const stream: TStream);
    procedure set_OnAsyncLoad(const Sender: TObject;
      EventHandler: TAsyncEventHandler);
    // IDomInternal
    procedure removeNode(node: xmlNodePtr);
    procedure removeAttr(attr: xmlAttrPtr);
    procedure appendAttr(attr: xmlAttrPtr);
    procedure appendNode(node: xmlNodePtr);
    procedure appendNS(prefix,uri:string);
    procedure set_FtempXSL(tempXSL: xsltStylesheetPtr);
    function getPrefixList:TStringList;
    function getUriList:TStringList;
    // IDomOutputOptions
    function get_prettyPrint: boolean;
    function get_encoding: DomString;
    function get_parsedEncoding: DomString;
    function get_compressionLevel: integer;
    procedure set_prettyPrint(prettyPrint: boolean);
    procedure set_encoding(encoding: DomString);
    procedure set_compressionLevel(compressionLevel: integer);
  public
    constructor Create(GDOMImpl: IDomImplementation;
      const namespaceURI, qualifiedName: DOMString;
      doctype: IDomDocumentType); overload;
    constructor Create(GDOMImpl: IDomImplementation); overload;
    constructor Create(GDOMImpl: IDomImplementation; aUrl: DomString); overload;
    constructor Create(GDOMImpl: IDomImplementation; docnode: xmlNodePtr); overload;
    destructor Destroy; override;
  end;

  { TMSDOMDocumentFragment }

  TGDOMDocumentFragment = class(TGDOMNode, IDomDocumentFragment)
  end;

  TGDOMDocumentBuilderFactory = class(TInterfacedObject, IDomDocumentBuilderFactory)
  private
    FFreeThreading: boolean;

  public
    constructor Create(AFreeThreading: boolean);

    function NewDocumentBuilder: IDomDocumentBuilder;
    function Get_VendorID: DomString;
  end;

  TGDOMDocumentBuilder = class(TInterfacedObject, IDomDocumentBuilder)
  private
    FFreeThreading: boolean;
  public
    constructor Create(AFreeThreading: boolean);
    destructor Destroy; override;
    function Get_DomImplementation: IDomImplementation;
    function Get_IsNamespaceAware: boolean;
    function Get_IsValidating: boolean;
    function Get_HasAsyncSupport: boolean;
    function Get_HasAbsoluteURLSupport: boolean;
    function newDocument: IDomDocument;
    function parse(const xml: DomString): IDomDocument;
    function load(const url: DomString): IDomDocument;
  end;

  PGdomeDomString = string;

  TGDOMString = class
  private
    CString: PChar;
  public
    constructor Create(ADOMString: DOMString);
    destructor Destroy; override;
  end;

  TGDOMNameSpace = class
  private
    Ns: xmlNSPtr;
    localName, FqualifiedName: TGdomString;
    FOwnerDoc: IDomDocument;
  public
    constructor Create(node: xmlNodePtr; namespaceURI, qualifiedName: DOMString;
      OwnerDoc: IDomDocument);
    destructor Destroy; override;
  end;

var
  LIBXML_DOM:   IDomDocumentBuilderFactory;

function GetGNode(const Node: IDomNode): xmlNodePtr;
function MakeDocument(doc: xmlDocPtr; impl: IDomImplementation): IDomDocument;


function IsSameNode(node1, node2: IDomNode): boolean;

implementation
{$ifdef WIN32}

uses
  windows, qdialogs;
{$endif}

var
  xmlIndentTreeOutputPtr: PInteger;

function setAttr(var node: xmlNodePtr; xmlNewAttr: xmlAttrPtr): xmlAttrPtr; forward;
function removeAttr(element: xmlNodePtr; attr: xmlAttrPtr): xmlAttrPtr; forward;
function xmlRemoveChild(element: xmlNodePtr; node: xmlNodePtr): xmlNodePtr; forward;
function IsXmlName(const S: WideString): boolean; forward;
function IsXmlChars(const S: WideString): boolean; forward;
function appendNamespace(element: xmlNodePtr; ns: xmlNsPtr): boolean; forward;
procedure CheckError(err: integer); forward;
function IsReadOnlyNode(node: xmlNodePtr): boolean; forward;
function ErrorString(err: integer): string; forward;

function MakeNode(Node: xmlNodePtr; ADocument: IDomDocument): IDomNode;
const
  NodeClasses: array[ELEMENT_NODE..NOTATION_NODE] of TGDOMNodeClass =
    (TGDOMElement, TGDOMAttr, TGDOMText, TGDOMCDataSection,
    TGDOMEntityReference, TGDOMEntity, TGDOMProcessingInstruction,
    TGDOMComment, TGDOMDocument, TGDOMDocumentType, TGDOMDocumentFragment,
    TGDOMNotation);
var
  nodeType: integer;
begin
  if Node <> nil then begin
    nodeType := Node.type_;
    //change xml_entity_decl to TGDOMEntity
    if nodeType = 17 then nodeType := 6;
    if nodeType = 13 then nodeType := 9;
    //if nodeType<>13 //html
    Result := NodeClasses[nodeType].Create(Node, ADocument)
      //else Result:=nil;
  end else Result := nil;
end;

function prefix(qualifiedName: WideString): WideString;
begin
  Result := Copy(qualifiedName, 1,Pos(':', qualifiedName) - 1);
end;

function localName(qualifiedName: WideString): WideString;
var
  prefix: widestring;
begin
  prefix := Copy(qualifiedName, 1,Pos(':', qualifiedName) - 1);
  if length(prefix) > 0 then Result := (Copy(qualifiedName, Pos(':', qualifiedName) + 1,
      length(qualifiedName) - length(prefix) - 1))
  else Result := qualifiedName;
end;

function libxmlStringToString(libstring: PChar): WideString;
var
  s: string;
begin
  if libstring <> nil then begin
    s := libstring;
    //xmlFree(libstring);
    Result := UTF8Decode(s);
  end else Result := '';
end;

function IsSameNode(node1, node2: IDomNode): boolean;
begin
  try
    Result := (node1 as IDomNodeCompare).IsSameNode(node2);
  except
    if node1 = node2 then Result := True
    else Result := False;
  end;
end;

(*
function TGDOMImplementationFactory.DOMImplementation: IDomImplementation;
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
constructor TGDOMDocumentBuilder.Create(AFreeThreading: boolean);
begin
  inherited Create;
  FFreeThreading := AFreeThreading;
end;

destructor TGDOMDocumentBuilder.Destroy;
begin
  inherited Destroy;
end;

function TGDOMDocumentBuilder.Get_DomImplementation: IDomImplementation;
begin
  Result := TGDOMImplementation.Create;
end;

function TGDOMDocumentBuilder.Get_IsNamespaceAware: boolean;
begin
  Result := True;
end;

function TGDOMDocumentBuilder.Get_IsValidating: boolean;
begin
  Result := True;
end;

function TGDOMDocumentBuilder.Get_HasAbsoluteURLSupport: boolean;
begin
  Result := False;
end;

function TGDOMDocumentBuilder.Get_HasAsyncSupport: boolean;
begin
  Result := False;
end;

function TGDOMImplementation.hasFeature(const feature, version: DOMString): boolean;
begin
  Result := False;
  if (uppercase(feature) = 'CORE') and
    ((version = '2.0') or (version = '1.0') or (version = '')) then Result := True;
  if (uppercase(feature) = 'XML') and
    ((version = '2.0') or (version = '1.0') or (version = '')) then Result := True;
end;

function TGDOMInterface.SafeCallException(ExceptObject: TObject;
  ExceptAddr: Pointer): HRESULT;
begin
  Result := 0; //todo
end;

function TGDOMImplementation.createDocumentType(const qualifiedName, publicId,
  systemId: DOMString): IDomDocumentType;
var
  dtd:        xmlDtdPtr;
  name1, name2, name3: TGdomString;
  alocalName: widestring;
begin
  alocalName := localName(qualifiedName);
  if ((Pos(':', alocalName)) > 0) then begin
    checkError(NAMESPACE_ERR);
  end;
  if not IsXmlName(qualifiedName) then checkError(INVALID_CHARACTER_ERR);
  name1 := TGdomString.Create(qualifiedName);
  name2 := TGdomString.Create(publicId);
  name3 := TGdomString.Create(systemId);
  dtd := xmlCreateIntSubSet(nil, name1.CString, name2.CString, name3.CString);
  name1.Free;
  name2.Free;
  name3.Free;
  if dtd <> nil then Result := TGDOMDocumentType.Create(dtd, nil,
      nil) as IDomDocumentType
  else Result := nil;
end;

function TGDOMImplementation.createDocument(const namespaceURI, qualifiedName: DOMString;
  doctype: IDomDocumentType): IDomDocument;
begin
  Result := TGDOMDocument.Create(self, namespaceURI, qualifiedName,
    doctype) as IDomDocument;
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

function TGDomNode.get_text: DomString;
var
  i:    integer;
  node: IDomNode;
begin
  // concat content of all text node children of node
  Result := '';
  node := self as IDomNode;
  for i := 0 to node.childNodes.length - 1 do begin
    if node.childNodes[i].nodeType = TEXT_NODE then begin
      Result := Result + node.childnodes[i].nodeValue;
    end;
  end;
end;

procedure TGDomNode.set_text(const Value: DomString);
var
  node, child: IDomNode;
  Text:        IDomText;
begin
  // replace all children of node with value as text node
  node := self as IDomNode;
  while node.hasChildNodes do begin
    child := node.lastChild;
    node.removeChild(child);
  end;
  Text := node.ownerDocument.createTextNode(Value);
  node.appendChild(Text);
end;

function TGDOMNode.GetGDOMNode: xmlNodePtr;
begin
  Result := FGNode;
end;

// IDomNode
function TGDOMNode.get_nodeName: DOMString;
const
  emptyWString: WideString = '';
begin
  case FGNode.type_ of
    XML_HTML_DOCUMENT_NODE,
    //XML_DOCB_DOCUMENT_NODE,
    XML_DOCUMENT_NODE: Result := '#document';
    XML_CDATA_SECTION_NODE: Result := '#cdata-section';
    XML_DOCUMENT_FRAG_NODE: Result := '#document-fragment';
    XML_ENTITY_DECL: Result := '#text';
    XML_TEXT_NODE,
    XML_COMMENT_NODE: Result := emptyWString + '#' + UTF8Decode(FGNode.Name);
    else Result := UTF8Decode(FGNode.Name);
      if (FGNode.ns <> nil) and (FGNode.ns.prefix <> nil) then begin
        Result := emptyWString + UTF8Decode(FGNode.ns.prefix) + ':' + Result;
      end;
  end;
end;

function TGDOMNode.get_nodeValue: DOMString;
var
  temp1: PChar;
begin
  if FGNode.type_ = ATTRIBUTE_NODE then begin
    if FGNode.children <> nil then temp1 := FGNode.children.content
    else temp1 := nil;
  end else temp1 := FGNode.content;
  Result := libxmlStringToString(temp1);
end;


procedure TGDOMNode.set_nodeValue(const Value: DOMString);
var
  temp:   TGdomString;
  attr:   xmlAttrPtr;
  buffer: PChar;
  tmp:    xmlNodePtr;
begin
  temp := TGdomString.Create(Value);
  if FGNode.type_ = ATTRIBUTE_NODE then begin
    attr := xmlAttrPtr(FGNode);
    if attr.children <> nil then xmlFreeNodeList(attr.children);
    attr.children := nil;
    attr.last := nil;
    buffer := xmlEncodeEntitiesReentrant(attr.doc, temp.CString);
    attr.children := xmlStringGetNodeList(attr.doc, temp.CString);
    tmp := attr.children;
    while tmp <> nil do begin
      tmp.parent := xmlNodePtr(attr);
      tmp.doc := attr.doc;
      if tmp.Next = nil then attr.last := tmp;
      tmp := tmp.Next;
    end;
    xmlFree(buffer);
  end else if (FGNode.type_ <> ELEMENT_NODE) and
    (FGNode.type_ <> DOCUMENT_NODE) and
    (FGNode.type_ <> DOCUMENT_FRAGMENT_NODE) and
    (FGNode.type_ <> DOCUMENT_TYPE_NODE) and
    (FGNode.type_ <> ENTITY_REFERENCE_NODE) and
    (FGNode.type_ <> ENTITY_NODE) and
    (FGNode.type_ <> NOTATION_NODE) then xmlNodeSetContent(FGNode, temp.CString);
  temp.Free;
end;

function TGDOMNode.get_nodeType: DOMNodeType;
begin
  Result := domNodeType(FGNode.type_);
end;

function TGDOMNode.get_parentNode: IDomNode;
var 
  node: xmlNodePtr;
begin
  node := FGNode.parent;
  if node <> nil then Result := MakeNode(node, FOwnerDocument) as IDomNode
  else Result := nil;
end;

function TGDOMNode.get_childNodes: IDomNodeList;
var
  Parent: xmlNodePtr;
begin
  Parent := FGNode;
  Result := TGDOMNodeList.Create(Parent, FOwnerDocument) as IDomNodeList;
end;

function TGDOMNode.get_firstChild: IDomNode;
var 
  node: xmlNodePtr;
begin
  node := FGNode.children; //firstChild
  if node <> nil then Result := MakeNode(node, FOwnerDocument) as IDomNode
  else Result := nil;
end;

function TGDOMNode.get_lastChild: IDomNode;
var 
  node: xmlNodePtr;
begin
  node := FGNode.last; //lastChild
  if node <> nil then Result := MakeNode(node, FOwnerDocument) as IDomNode
  else Result := nil;
end;

function TGDOMNode.get_previousSibling: IDomNode;
var 
  node: xmlNodePtr;
begin
  node := FGNode.prev;
  if node <> nil then Result := MakeNode(node, FOwnerDocument) as IDomNode
  else Result := nil;
end;

function TGDOMNode.get_nextSibling: IDomNode;
var 
  node: xmlNodePtr;
begin
  node := FGNode.Next;
  if node <> nil then Result := MakeNode(node, FOwnerDocument) as IDomNode
  else Result := nil;
end;

function TGDOMNode.get_attributes: IDomNamedNodeMap;
begin
  if FGNode.type_ = ELEMENT_NODE then Result :=
      TGDOMNamedNodeMap.Create(FGNode, FOwnerDocument) as IDomNamedNodeMap
  else Result := nil;
end;

function TGDOMNode.get_ownerDocument: IDomDocument;
begin
  Result := FOwnerDocument
end;

function TGDOMNode.get_namespaceURI: DOMString;
begin
  Result := '';
  case FGNode.type_ of
    XML_ELEMENT_NODE,
    XML_ATTRIBUTE_NODE:
      begin
        if FGNode.ns = nil then exit;
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
        if FGNode.ns = nil then exit;
        Result := UTF8Decode(FGNode.ns.prefix);
      end;
  end;
end;

function TGDOMNode.get_localName: DOMString;
begin
  case FGNode.type_ of
    XML_HTML_DOCUMENT_NODE,
    //XML_DOCB_DOCUMENT_NODE,
    XML_DOCUMENT_NODE: Result := '#document';
    XML_CDATA_SECTION_NODE: Result := '#cdata-section';
    XML_TEXT_NODE,
    XML_COMMENT_NODE,
    XML_DOCUMENT_FRAG_NODE: Result := '#' + UTF8Decode(FGNode.Name);
    else begin
        Result := UTF8Decode(FGNode.Name);
        // this is neccessary, because according to the dom2
        // specification localName has to be nil for nodes,
        // that don't have a namespace
        if FGNode.ns = nil then Result := '';
      end;
  end;
end;

function TGDOMNode.insertBefore(const newChild, refChild: IDomNode): IDomNode;
const
  FAllowedChildTypes = [Element_Node, Text_Node, CDATA_Section_Node,
    Entity_Reference_Node, Processing_Instruction_Node, Comment_Node,
    Document_Type_Node, Document_Fragment_Node, Notation_Node];
var 
  node: xmlNodePtr;
begin
  node := GetGNode(newChild);
  if self.isAncestorOrSelf(node) then CheckError(HIERARCHY_REQUEST_ERR);
  if not (newChild.NodeType in FAllowedChildTypes) then
    CheckError(HIERARCHY_REQUEST_ERR);
  if (GetGNode(refChild) = GetGNode(refChild.OwnerDocument.documentElement)) then
    if (newChild.nodeType = Element_Node) then CheckError(HIERARCHY_REQUEST_ERR);
  if node.doc <> FGNode.doc then CheckError(WRONG_DOCUMENT_ERR);
  if (GetGNode(refChild)).parent<>FGNode then CheckError(NOT_FOUND_ERR);
  if (newChild <> nil) and (refChild <> nil) then
    node := xmlAddPrevSibling(GetGNode(refChild), GetGNode(newChild))
  else node := nil;
  if node <> nil then Result := newChild
  else Result := nil;
end;

function TGDOMNode.replaceChild(const newChild, oldChild: IDomNode): IDomNode;
begin
  Result := self.removeChild(oldchild);
  if Result = nil then checkError(NOT_FOUND_ERR);
  self.appendChild(newChild);
end;

function TGDOMNode.removeChild(const childNode: IDomNode): IDomNode;
var
  node: xmlNodePtr;
begin
  if childNode <> nil then begin
    node := GetGNode(childNode);
    if node.parent <> FGNode then checkError(NOT_FOUND_ERR);
    node := xmlRemoveChild(FGNode, node);
    if node = nil then checkError(NOT_FOUND_ERR);
    node.parent := nil;
    (FOwnerDocument as IDomInternal).appendNode(node);
  end;
  Result := childNode;
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
function TGDOMNode.appendChild(const newChild: IDomNode): IDomNode;
const
  FAllowedChildTypes = [Element_Node, Text_Node, CDATA_Section_Node,
    Entity_Reference_Node, Processing_Instruction_Node, Comment_Node,
    Document_Type_Node, Document_Fragment_Node, Notation_Node];
var
  node: xmlNodePtr;
  PI,encoding: string;
  pos1:integer;
begin
  node := GetGNode(newChild);
  if node = nil then CheckError(Not_Supported_Err);
  if self.IsReadOnly then CheckError(NO_MODIFICATION_ALLOWED_ERR);
  if not (newChild.NodeType in FAllowedChildTypes) then
    CheckError(HIERARCHY_REQUEST_ERR);
  if FGNode.type_ = Document_Node then if (newChild.nodeType = Element_Node)
      and (xmlDocGetRootElement(xmlDocPtr(FGNode)) <> nil) then
      CheckError(HIERARCHY_REQUEST_ERR);
  if node.doc <> FGNode.doc then CheckError(WRONG_DOCUMENT_ERR);
  if self.isAncestorOrSelf(node) then CheckError(HIERARCHY_REQUEST_ERR);
  if IsReadOnlyNode(node.parent) then CheckError(NO_MODIFICATION_ALLOWED_ERR);
  // if the new child is already in the tree, it is first removed
  if node.parent <> nil
    then node := xmlRemoveChild(node.parent, node)
      //if it wasn't already in the tree, then remove it from the list of
      //nodes, that have to be freed
  else begin
    if FOwnerDocument<>nil
      then (FOwnerDocument as IDomInternal).removeNode(node)
      else (self as IDomInternal).removeNode(node);
  end;
  // if the new child is a document_fragment, then the entire contents of the document fragment are
  // moved into the child list of this node
  if node.type_ = XML_DOCUMENT_FRAG_NODE then begin
    //todo: implement a faster loop
    while NewChild.HasChildNodes do begin
      appendChild(newChild.ChildNodes[0])
    end;
  end else begin
    if FGNode.children <> nil then if FGNode.children.last <> nil then
        if FGNode.children.last.type_ = XML_TEXT_NODE then if (node.type_ = XML_TEXT_NODE) then
          begin
            (FOwnerDocument as IDomInternal).removeNode((node));
          end;
    if (FGNode.type_=Document_Node) and (FGNode.children=nil) and (node.type_=XML_PI_NODE) then begin
      PI:=node.content;
      pos1:=pos('encoding',PI)+length('encoding')+2;
      encoding:=trim(copy(PI,pos1,length(PI)-pos1));
      (self as IDomOutputOptions).encoding:=encoding;
      (self as IDomInternal).appendNode(node);
    end else begin
      node := xmlAddChild(FGNode, node);
      FGNode.children.last := node;
    end;
  end;
  if node <> nil then Result := newChild
  else Result := nil;
end;

function TGDOMNode.hasChildNodes: boolean;
begin
  if FGNode.children <> nil then Result := True
  else Result := False;
end;

function TGDOMNode.hasAttributes: boolean;
begin
  Result := (FGNode.type_ = ELEMENT_NODE) and (get_Attributes.length > 0);
end;

function TGDOMNode.cloneNode(deep: boolean): IDomNode;
var
  node:      xmlNodePtr;
  recursive: integer;
begin
  result:=nil;
  case integer(FGNode.type_) of
    XML_ENTITY_NODE, XML_ENTITY_DECL, XML_NOTATION_NODE, XML_DOCUMENT_TYPE_NODE,
    XML_DTD_NODE: CheckError(NOT_SUPPORTED_ERR);
    ATTRIBUTE_NODE:
      begin
        node:=xmlNodePtr(xmlCopyProp(nil,xmlAttrPtr(FGNode)));
        if node <> nil then begin
          node.doc := FGNode.doc;
          if node.parent = nil
            then (FOwnerDocument as IDomInternal).appendAttr(xmlAttrPtr(node));
          Result := MakeNode(node, FOwnerDocument) as IDomNode
        end;
      end;
    XML_DOCUMENT_NODE:
      begin
        if deep
          then recursive := 1
          else recursive := 0;
        node := xmlNodePtr(xmlCopyDoc(xmlDocPtr(FGNode), recursive));
        if node <> nil then begin
          node.doc := nil;
          Result := MakeDocument(xmlDocPtr(node), FOwnerDocument.domImplementation) as IDomNode
        end;
      end;
  else
      begin
        if deep
          then recursive := 1
          else recursive := 0;
        node := xmlCopyNode(FGNode, recursive);
        if node <> nil then begin
          node.doc := FGNode.doc;
          if node.parent = nil
            then (FOwnerDocument as IDomInternal).appendNode(node);
          Result := MakeNode(node, FOwnerDocument) as IDomNode
        end;
      end;
  end;
end;

procedure TGDOMNode.normalize;
var
  node, Next, new_next: xmlNodePtr;
  nodeType: integer;
  temp:     string;
begin
  node := FGNode.children;
  while node <> nil do begin
    nodeType := node.type_;
    if nodeType = TEXT_NODE then begin
      Next := node.Next;
      while Next <> nil do begin
        if Next.type_ <> TEXT_NODE then break;
        temp := Next.content;
        xmlTextConcat(node, PChar(temp), length(temp));
        new_next := Next.Next;
        Next.parent := nil;
        //(FOwnerDocument as IDomInternal).appendNode(next);
        xmlUnlinkNode(Next);
        xmlFreeNode(Next); //carefull!!
        Next := new_next;
      end;
    end else if nodeType = ELEMENT_NODE then begin
    end;
    node := node.Next;
  end;
end;

function TGDOMNode.IsSupported(const feature, version: DOMString): boolean;
begin
  if (((upperCase(feature) = 'CORE') and (version = '2.0')) or
    (upperCase(feature) = 'XML') and (version = '2.0')) //[pk] ??? what ???
    then Result := True
  else Result := False;
end;

constructor TGDOMNode.Create(ANode: xmlNodePtr; ADocument: IDomDocument);
begin
  inherited Create;
  Assert(Assigned(ANode));
  FGNode := ANode;
  FOwnerDocument := ADocument;
end;

destructor TGDOMNode.Destroy;
begin
  FOwnerDocument := nil;
  inherited Destroy;
end;

{ TGDOMNodeList }

constructor TGDOMNodeList.Create(AParent: xmlNodePtr; ADocument: IDomDocument);
  // create a IDomNodeList from a var of type xmlNodePtr
  // xmlNodePtr is the same as xmlNodePtrList, because in libxml2 there is no
  // difference in the definition of both
begin
  inherited Create;
  FParent := AParent;
  FXpathObject := nil;
  FAdditionalNode := nil;
  FOwnerDocument := ADocument;
end;

procedure TGDOMNodeList.AddNode(node: xmlNodePtr);
begin
  FAdditionalNode := node;
end;

constructor TGDOMNodeList.Create(AXpathObject: xmlXPathObjectPtr;
  ADocument: IDomDocument);
  // create a IDomNodeList from a var of type xmlNodeSetPtr
  //  xmlNodeSetPtr = ^xmlNodeSet;
  //  xmlNodeSet = record
  //    nodeNr : longint;                { number of nodes in the set  }
  //    nodeMax : longint;              { size of the array as allocated  }
  //    nodeTab : PxmlNodePtr;       { array of nodes in no particular order  }
  //  end;
begin
  inherited Create;
  FParent := nil;
  FAdditionalNode := nil;
  FXpathObject := AXpathObject;
  FOwnerDocument := ADocument;
end;

destructor TGDOMNodeList.Destroy;
begin
  FOwnerDocument := nil;
  if FXPathObject <> nil then xmlXPathFreeObject(FXPathObject);
  inherited Destroy;
end;

function TGDOMNodeList.get_item(index: integer): IDomNode;
var
  node: xmlNodePtr;
  i:    integer;
begin
  i := index;
  node := nil;
  if (i = 0) and (FAdditionalNode <> nil) then node := FAdditionalNode
  else begin
    if FAdditionalNode <> nil then i := i - 1;
    if FParent <> nil then begin
      node := FParent.children;
      while (i > 0) and (node.Next <> nil) do begin
        dec(i);
        node := node.Next
      end;
      if i > 0 then checkError(INDEX_SIZE_ERR);
    end else begin
      if FXPathObject <> nil then node :=
          xmlXPathNodeSetItem(FXPathObject.nodesetval, i)
      else checkError(101);
    end;
  end;
  if node <> nil then Result := MakeNode(node, FOwnerDocument) as IDomNode
  else Result := nil;
end;

function TGDOMNodeList.get_length: integer;
var
  node: xmlNodePtr;
  i:    integer;
begin
  if FParent <> nil then begin
    i := 1;
    node := FParent.children;
    if node <> nil then while (node.Next <> nil) do begin
        inc(i);
        node := node.Next
      end else i := 0;
    if FAdditionalNode = nil then Result := i
    else Result := i + 1;
  end else begin
    if FAdditionalNode = nil then begin
      if FXPathObject.nodesetval<>nil
        then Result := FXPathObject.nodesetval.nodeNr
        else result := 0;
    end
    else begin
      if FXPathObject.nodesetval<>nil
        then Result := FXPathObject.nodesetval.nodeNr + 1
        else result:=1;
    end;
  end;
end;

{TGDOMNamedNodeMap}
function TGDOMNamedNodeMap.get_item(index: integer): IDomNode;
  //same as NodeList.get_item
var
  node: xmlNodePtr;
  ns:   xmlNsPtr;
  i:    integer;
  NsAttr: IDomAttr;
begin
  i := index;
  ns := FOwnerElement.nsDef;
  if ns <> nil then begin
    while (i > 0) and (ns.next <> nil) do begin
      dec(i);
      ns := ns.next;
    end;
    if (i<>0) and (ns.next=nil) then begin
      dec(i);
      ns:=nil;
    end;
  end;
  if ns <> nil then begin
    //create an orphan attribute for the namespace declaration
    NsAttr:=FOwnerDocument.createAttributeNS('http://www.w3.org/2000/xmlns/','xmlns:'+UTF8Decode(ns.prefix));
    NsAttr.value:=UTF8Decode(ns.href);
    result := NsAttr as IDOMNode;
  end else begin
    node := GNamedNodeMap;
    if node<>nil then begin
      while (i > 0) and (node.Next <> nil) do begin
        dec(i);
        node := node.Next
      end;
    end;
    if node <> nil then begin
      Result := MakeNode(node, FOwnerDocument) as IDomNode;
    end else begin
      checkError(INDEX_SIZE_ERR);
    end;
  end;
end;

function TGDOMNamedNodeMap.get_length: integer;
  // same as NodeList.get_length
var
  node: xmlNodePtr;
  ns: xmlNsPtr;
  //buff:xmlBufferPtr;
  //dtdtable: pchar;
begin
  result := 0;
  node:=GNamedNodeMap;
  if FOwnerElement=nil then begin
    // if the namedNodeMap is of type entities
    if FGDTD<>nil then begin
      if FGDTD.entities <> nil then begin
        result := xmlHashSize(FGDTD.entities);
        //for testing:
        {buff:=xmlBufferCreate();
        xmlDumpEntitiesTable(buff,FGDTD.entities);
        dtdtable:=xmlBufferContent(buff);
        xmlBufferFree(buff);}
      end;
    end;
    if FGDTD2<>nil then begin
      if FGDTD2.entities <> nil then begin
        result := result + xmlHashSize(FGDTD2.entities);
      end;
    end;
  end else begin
    // if the namedNodeMap is of type attributes
    // count namespace declarations
    ns:=FOwnerElement.nsDef;
    if ns<>nil then begin
      inc(result);
      while (ns.next<>nil) do begin
        inc(result);
        ns := ns.Next
      end;
    end;
    // count normal attributes
    if node<>nil then begin
      inc(result);
      while (node.next<>nil) do begin
        inc(result);
        node := node.Next
      end;
    end;
  end;
end;

function TGDOMNamedNodeMap.getNamedItem(const Name: DOMString): IDomNode;
var
  node:  xmlNodePtr;
  name1: TGdomString;
begin
  node := GNamedNodeMap;
  if node <> nil then begin
    name1 := TGdomString.Create(Name);
    node := xmlNodePtr(xmlHasProp(FOwnerElement, name1.CString));
    name1.Free;
  end;
  if node <> nil then Result := MakeNode(node, FOwnerDocument) as IDomNode
  else Result := nil;
end;

function TGDOMNamedNodeMap.setNamedItem(const newItem: IDomNode): IDomNode;
var
  xmlNewAttr, attr: xmlAttrPtr;
  node,node1: xmlNodePtr;
begin
  node := FOwnerElement;
  node1:=GetGNode(newItem);
  if node.doc<>node1.doc
    then checkError(WRONG_DOCUMENT_ERR);
  if node1.parent<>nil
    then checkError(INUSE_ATTRIBUTE_ERR);
  if node1.type_<>ATTRIBUTE_NODE
    then checkError(HIERARCHY_REQUEST_ERR);
  xmlNewAttr := xmlAttrPtr(node1);
  //todo: check type of newItem
  attr := setattr(node, xmlNewAttr);
  (FOwnerDocument as IDomInternal).removeAttr(xmlnewAttr);
  FOwnerElement := node;
  if attr <> nil then begin
    (FOwnerDocument as IDomInternal).appendAttr(attr);
    Result := TGDomAttr.Create(attr, FOwnerDocument) as IDomNode
  end else Result := nil;
end;

function TGDOMNamedNodeMap.removeNamedItem(const Name: DOMString): IDomNode;
var
  attr:  xmlAttrPtr;
  name1: TGdomString;
begin
  attr := nil;
  if FOwnerElement <> nil then begin
    name1 := TGdomString.Create(Name);
    attr := xmlHasProp(FOwnerElement, name1.CString);
    if attr = nil then begin
      name1.Free;
      checkError(NOT_FOUND_ERR);
    end;
    name1.Free;
    attr := removeAttr(FOwnerElement, attr);
    (FOwnerDocument as IDomInternal).appendAttr(attr);
  end;
  if attr <> nil then Result := MakeNode(xmlNodePtr(attr), FOwnerDocument) as IDomNode
  else Result := nil;
end;

function TGDOMNamedNodeMap.getNamedItemNS(const namespaceURI,
  localName: DOMString): IDomNode;
var
  node:         xmlNodePtr;
  name1, name2: TGdomString;
begin
  node := GNamedNodeMap;
  if node <> nil then begin
    name1 := TGdomString.Create(namespaceURI);
    name2 := TGdomString.Create(localName);
    node := xmlNodePtr(xmlHasNSProp(FOwnerElement, name2.CString, name1.CString));
    name1.Free;
    name2.Free;
  end;
  if node <> nil then Result := MakeNode(node, FOwnerDocument) as IDomNode
  else Result := nil;
end;

function TGDOMNamedNodeMap.setNamedItemNS(const newItem: IDomNode): IDomNode;
var
  attr, oldattr, xmlnewAttr: xmlAttrPtr;
  temp, slocalName: string;
  ns:        xmlNSPtr;
  namespace: PChar;
  newAttr:   IDomAttr;
  node,node1: xmlNodePtr;
begin
  node := FOwnerElement;
  node1:= GetGNode(newItem);
  if node1 <> nil then begin
    if node.doc<>node1.doc
      then checkError(WRONG_DOCUMENT_ERR);
    if node1.parent<>nil
      then checkError(INUSE_ATTRIBUTE_ERR);
    if node1.type_<>ATTRIBUTE_NODE
      then checkError(HIERARCHY_REQUEST_ERR);
    newAttr := newItem as IDomAttr;
    xmlnewAttr := xmlAttrPtr(node1);    // Get the libxml2-Attribute
    xmlnewAttr.parent := node;
    slocalName := localName(xmlNewattr.Name);
    namespace:=xmlNewattr.ns.href;
    oldattr := xmlHasNSProp(node, PChar(slocalName), namespace);
    if oldattr=nil then begin
      if xmlnewAttr.ns <> nil then begin
        //namespace := xmlnewAttr.ns.href;
        ns := xmlCopyNamespace(xmlnewAttr.ns);
        appendNamespace(node, ns);
      end;
    end;
    // already an attribute with this name?
    attr := node.properties;                                   // if not, then oldattr=nil
    if attr = oldattr then node.properties := xmlNewAttr
    else begin
      while attr.Next <> oldattr do begin
        attr := attr.Next
      end;
      attr.Next := xmlNewAttr;
    end;
    (FOwnerDocument as IDomInternal).removeAttr(xmlnewAttr);
    if oldattr <> nil then begin
      temp := oldattr.Name;
      Result := TGDomAttr.Create(oldattr, FOwnerDocument) as IDomAttr;
      oldattr.parent := nil;
      (FOwnerDocument as IDomInternal).appendAttr(oldattr);
    end else begin
      Result := nil;
    end;
  end;
end;

function TGDOMNamedNodeMap.removeNamedItemNS(const namespaceURI,
  localName: DOMString): IDomNode;
var
  attr:         xmlAttrPtr;
  name1, name2: TGdomString;
begin
  attr := nil;
  if FOwnerElement <> nil then begin
    name1 := TGdomString.Create(namespaceURI);
    name2 := TGdomString.Create(localName);
    attr := (xmlHasNsProp(FOwnerElement, name2.CString, name1.CString));
    name1.Free;
    name2.Free;
    if attr = nil then checkError(NOT_FOUND_ERR);
    attr := removeAttr(FOwnerElement, attr);
    (FOwnerDocument as IDomInternal).appendAttr(attr);
  end;
  if attr <> nil then Result := MakeNode(xmlNodePtr(attr), FOwnerDocument) as IDomNode
  else Result := nil;
end;

constructor TGDOMNamedNodeMap.Create(ANamedNodeMap: xmlNodePtr;
  AOwnerDocument: IDomDocument; typ: integer = 0; dtd2: xmlDtdPtr = nil);
  // ANamedNodeMap=nil for empty NodeMap
begin
  FOwnerDocument := AOwnerDocument;
  if typ = 0 then begin
    FGDTD := nil;
    FOwnerElement := ANamedNodeMap;
  end else begin
    FGDTD := xmlDtdPtr(ANamedNodeMap);
    FGDTD2:=dtd2;
    FOwnerElement := nil;
  end;
  inherited Create;
end;

destructor TGDOMNamedNodeMap.Destroy;
begin
  FOwnerDocument := nil;
  FOwnerElement := nil;
  FGDTD := nil;
  inherited Destroy;
end;

function TGDOMNamedNodeMap.get_GNamedNodeMap: xmlNodePtr;
begin
  if FOwnerElement <> nil then Result := xmlNodePtr(FOwnerElement.properties)
  else Result := nil;
end;

{ TGDOMAttr }

function TGDOMAttr.GetGAttribute: xmlAttrPtr;
begin
  Result := xmlAttrPtr(GNode);
end;

function TGDOMAttr.get_name: DOMString;
begin
  Result := inherited get_nodeName;
end;

function TGDOMAttr.get_ownerElement: IDomElement;
begin
  Result := ((self as IDomNode).parentNode) as IDomElement;
end;

function TGDOMAttr.get_specified: boolean;
begin
  //todo: implement it correctly
  Result := True;
end;

function TGDOMAttr.get_value: DOMString;
begin
  Result := inherited get_nodeValue;
end;

procedure TGDOMAttr.set_value(const attributeValue: DOMString);
begin
  inherited set_nodeValue(attributeValue);
end;

constructor TGDOMAttr.Create(AAttribute: xmlAttrPtr; ADocument: IDomDocument;
  freenode: boolean = False);
begin
  inherited Create(xmlNodePtr(AAttribute), ADocument);
end;

destructor TGDOMAttr.Destroy;
begin
  inherited Destroy;
end;


  //***************************
  //TGDOMElement Implementation
  //***************************

function TGDOMElement.GetGElement: xmlNodePtr;
begin
  Result := xmlNodePtr(GNode);
end;
// IDomElement

function TGDOMElement.get_tagName: DOMString;
begin
  Result := self.get_nodeName;
end;

function TGDOMElement.getAttribute(const Name: DOMString): DOMString;
var
  name1: TGdomString;
  temp1: PChar;
  attr:  xmlAttrPtr;
begin
  name1 := TGdomString.Create(Name);
  attr := xmlHasProp(GElement, name1.CString);
  if attr <> nil then begin
    if attr.children <> nil then temp1 := attr.children.content
    else temp1 := nil;
    Result := libxmlstringToString(temp1);
  end else Result := '';
  name1.Free;
end;

procedure TGDOMElement.setAttribute(const Name, Value: DOMString);
var
  name1, name2: TGdomString;
  temp:         xmlAttrPtr;
  node:         xmlNodePtr;
begin
  if not IsXMLName(Name) then checkError(INVALID_CHARACTER_ERR);
  name1 := TGdomString.Create(Name);
  name2 := TGdomString.Create(Value);
  node := xmlNodePtr(GElement);
  temp := xmlSetProp(node, name1.CString, name2.CString);
  temp.parent := node;
  temp.doc := node.doc;
  name1.Free;
  name2.Free;
end;

procedure TGDOMElement.removeAttribute(const Name: DOMString);
var
  name1: TGdomString;
  ok: integer;
begin
  name1 := TGdomString.Create(Name);
  ok:=xmlUnsetProp(GElement,name1.CString);
  if ok <> 0 then checkerror(103);
  name1.Free;
  //todo: make it work with xmlns attributes
end;

function TGDOMElement.getAttributeNode(const Name: DOMString): IDomAttr;
var
  temp:  xmlAttrPtr;
  name1: TGdomString;
begin
  name1 := TGdomString.Create(Name);
  temp := xmlHasProp(xmlNodePtr(GElement), name1.CString);
  name1.Free;
  if temp <> nil then Result := TGDOMAttr.Create(temp, FOwnerDocument) as IDomAttr
  else Result := nil;
end;

function setAttr(var node: xmlNodePtr; xmlNewAttr: xmlAttrPtr): xmlAttrPtr;
var
  attr, oldattr: xmlAttrPtr;
  replace:       boolean;
  temp:          string;
begin
  Result := nil;
  if node = nil then exit;
  if xmlNewAttr = nil then exit;
  xmlnewAttr.last := nil;
  oldattr := xmlHasProp(node, xmlNewattr.Name);
  // already an attribute with this name?
  if oldattr <> nil then replace := True
  else replace := False;
  attr := node.properties;                         // get the old attr-list
  if (attr = nil)                                  // if it is empty or its an attribute with the same name
    then begin
    xmlNewAttr.Next := nil;
    xmlNewAttr.last := nil;
    node.properties := xmlnewAttr;               // replace it with the newattr
  end else begin
    if xmlStrCmp(attr.Name, xmlNewAttr.Name) = 0 then begin
      xmlNewAttr.last := nil;
      xmlNewAttr.Next := attr.Next;
      node.properties := xmlnewAttr;               // replace it with the newattr
    end else begin
      while attr.Next <> nil do begin
        if xmlStrCmp(attr.Next.Name, xmlNewattr.Name) = 0 then begin
          attr.Next := xmlNewAttr;
          if attr = node.properties then node.properties.Next := xmlNewAttr;
          attr := attr.Next;
          xmlNewAttr.Next := attr.Next;
          temp := xmlNewAttr.children.content;
          temp := attr.children.content;
          attr := xmlNewAttr;

          break;
        end;
        attr := attr.Next
      end;
      if not replace then begin
        xmlNewAttr.Next := nil;
        attr.Next := xmlNewAttr
      end;
    end;
  end;
  Result := oldattr;
end;

function TGDOMElement.setAttributeNode(const newAttr: IDomAttr): IDomAttr;
var
  xmlnewAttr, oldattr: xmlAttrPtr;
  temp: string;
  node: xmlNodePtr;
  ns: xmlNsPtr;
begin
  if newAttr <> nil then begin
    xmlnewAttr := xmlAttrPtr(GetGNode(newAttr));     // Get the libxml2-Attribute
    node := xmlNodePtr(GElement);
    if xmlnewAttr.doc<>node.doc
      then checkError(WRONG_DOCUMENT_ERR);
    if xmlnewAttr.parent<>nil
      then checkError(INUSE_ATTRIBUTE_ERR);
    xmlnewAttr.last := nil;
    xmlnewAttr.parent := node;
    //if newAttr is a namespace definition attribute
    if (newAttr.prefix='xmlns') or (newAttr.name='xmlns') then begin
      ns := xmlNewNs(nil,pchar(UTF8Encode(newAttr.namespaceURI)),
        pchar(UTF8Encode(newAttr.localName)));
      appendNamespace(node,ns);
      result:=nil;
    end else begin
      oldAttr := setAttr(node, xmlNewAttr);
      (FOwnerDocument as IDomInternal).removeAttr(xmlnewAttr);
      if oldattr <> nil then begin
        temp := oldattr.Name;
        oldattr.parent := nil;
        Result := TGDomAttr.Create(oldattr, FOwnerDocument) as IDomAttr;
        (FOwnerDocument as IDomInternal).appendAttr(oldattr);
      end else begin
        Result := nil;
      end;
    end;
  end;
end;

function TGDOMElement.removeAttributeNode(const oldAttr: IDomAttr): IDomAttr;
var
  attr, xmlnewAttr, oldattr1: xmlAttrPtr;
  node: xmlNodePtr;
begin
  if oldAttr <> nil then begin
    xmlnewAttr := xmlAttrPtr(GetGNode(oldAttr));     // Get the libxml2-Attribute
    node := xmlNodePtr(GElement);
    oldattr1 := xmlHasProp(node, xmlNewattr.Name);
    // already an attribute with this name?
    if oldattr1 <> nil then begin
      attr := node.properties;                         // if not, then oldattr=nil
      if attr = oldattr1 then node.properties := nil
      else begin
        while attr.Next <> oldattr1 do begin
          attr := attr.Next
        end;
        attr.Next := nil;
      end;
      if oldattr <> nil then begin
        Result := oldattr;
        xmlNewAttr.parent := nil;     //important, otherwise it would be freed
        (FOwnerDocument as IDomInternal).appendAttr(xmlNewattr);
      end else begin
        Result := nil;
      end;
    end else begin
      checkError(NOT_FOUND_ERR)
    end;
  end else Result := nil;
end;

function TGDOMElement.getElementsByTagName(const Name: DOMString): IDomNodeList;
begin
  Result := selectNodes(Name);
end;

function TGDOMElement.getAttributeNS(const namespaceURI, localName: DOMString): DOMString;
var
  name1, name2: TGdomString;
  attr:         xmlAttrPtr;
  temp1:        PChar;
begin
  name2 := TGdomString.Create(namespaceURI);
  name1 := TGdomString.Create(localName);
  attr := xmlHasNSProp(xmlNodePtr(GElement), name1.CString,
    name2.CString);
  name1.Free;
  name2.Free;
  if attr <> nil then begin
    if attr.children <> nil then temp1 := attr.children.content
    else temp1 := nil;
    Result := libxmlstringToString(temp1);
  end else Result := '';
end;

procedure TGDOMElement.setAttributeNS(const namespaceURI, qualifiedName, Value: DOMString);
var
  ns: TGdomNamespace;
  value1: TGdomString;
  alocalName: WideString;
  node: xmlNodePtr;
begin
  alocalName := localName(qualifiedName);
  if (prefix(qualifiedName) = 'xml') and (namespaceURI <>
    'http://www.w3.org/XML/1998/namespace') then checkError(NAMESPACE_ERR);
  if (prefix(qualifiedName) = 'xmlns') and (namespaceURI <>
    'http://www.w3.org/2000/xmlns/') then checkError(NAMESPACE_ERR);
  if ((qualifiedName) = 'xmlns') and (namespaceURI <>
    'http://www.w3.org/2000/xmlns/') then checkError(NAMESPACE_ERR);
  if (((Pos(':', alocalName)) > 0) or ((length(namespaceURI)) = 0) and
    ((Pos(':', qualifiedName)) > 0)) then checkError(NAMESPACE_ERR);
  if qualifiedName <> '' then if not IsXmlName(qualifiedName) then
      checkError(INVALID_CHARACTER_ERR);
  value1 := TGdomString.Create(Value);
  node := xmlNodePtr(GElement);
  if namespaceURI<>''
    then begin
      ns := TGDOMNamespace.Create(xmlNodePtr(GElement), namespaceURI,
        qualifiedName, get_ownerDocument);
      xmlSetNs(node, ns.ns);
      xmlSetNSProp(xmlNodePtr(GElement), ns.NS, ns.localName.CString, value1.CString);
      ns.Free;
    end else begin
      xmlSetProp(xmlNodePtr(GElement), pchar(UTF8Encode(qualifiedName)), value1.CString);
    end;
  value1.Free;
end;

procedure TGDOMElement.removeAttributeNS(const namespaceURI, localName: DOMString);
var
  attr:         xmlAttrPtr;
  name1, name2: TGdomString;
  ok:           integer;
begin
  name1 := TGdomString.Create(localName);
  name2 := TGdomString.Create(namespaceURI);
  attr := xmlHasNSProp(xmlNodePtr(GElement), name1.CString, name2.CString);
  name1.Free;
  name2.Free;
  if attr <> nil then begin
    ok := xmlRemoveProp(attr);
    if ok <> 0 then checkerror(103);
  end;
end;

function TGDOMElement.getAttributeNodeNS(const namespaceURI,
  localName: DOMString): IDomAttr;
var
  temp:         xmlAttrPtr;
  name1, name2: TGdomString;
  tstring:      string;
begin
  name1 := TGdomString.Create(namespaceURI);
  name2 := TGdomString.Create(localName);
  temp := xmlHasNSProp(xmlNodePtr(GElement), name2.CString, name1.CString);
  tstring := temp.ns.href;
  tstring := temp.ns.prefix;
  name1.Free;
  name2.Free;
  if temp <> nil then Result := TGDOMAttr.Create(temp, FOwnerDocument) as IDomAttr
  else Result := nil;
end;

function TGDOMElement.setAttributeNodeNS(const newAttr: IDomAttr): IDomAttr;
var
  attr, xmlnewAttr, oldattr: xmlAttrPtr;
  temp:       string;
  node:       xmlNodePtr;
  namespace:  PChar;
  slocalname: string;
begin
  if newAttr <> nil then begin
    xmlnewAttr := xmlAttrPtr(GetGNode(newAttr));    // Get the libxml2-Attribute
    node := xmlNodePtr(GElement);
    if xmlnewAttr.doc<>node.doc
      then checkError(WRONG_DOCUMENT_ERR);
    if xmlnewAttr.parent<>nil
      then checkError(INUSE_ATTRIBUTE_ERR);
    xmlnewAttr.parent := node;
    if xmlnewAttr.ns <> nil then begin
      namespace := xmlnewAttr.ns.href;
      if (xmlNewAttr.ns.prefix<>'xmlns') and (newAttr.name<>'xmlns') then begin
        appendNamespace(node, xmlnewAttr.ns);
      end;
    end else namespace := '';
    slocalName := localName(xmlNewattr.Name);
    oldattr := xmlHasNSProp(node, PChar(slocalName), namespace);
    // already an attribute with this name?
    attr := node.properties;                                   // if not, then oldattr=nil
    if attr = oldattr then node.properties := xmlNewAttr
    else begin
      while attr.Next <> oldattr do begin
        attr := attr.Next
      end;
      attr.Next := xmlNewAttr;
    end;
    (FOwnerDocument as IDomInternal).removeAttr(xmlnewAttr);
    if oldattr <> nil then begin
      temp := oldattr.Name;
      Result := TGDomAttr.Create(oldattr, FOwnerDocument) as IDomAttr;
      oldattr.parent := nil;
      (FOwnerDocument as IDomInternal).appendAttr(oldattr);
    end else begin
      Result := nil;
    end;
  end;
end;

function appendNamespace(element: xmlNodePtr; ns: xmlNsPtr): boolean;
var
  tmp, last: xmlNsPtr;
begin
  Result := False;
  last := nil;
  if element.type_ <> Element_Node then exit;
  tmp := element.nsDef;
  while tmp <> nil do begin
    last := tmp;
    tmp := tmp.Next;
  end;
  if element.nsDef = nil then element.nsDef := ns
  else last.Next := ns;
  Result := True;
end;

function removeAttr(element: xmlNodePtr; attr: xmlAttrPtr): xmlAttrPtr;
  //removes an attribute from an element and returns the removed attribute
var
  tmp, last: xmlAttrPtr;
begin
  Result := nil;
  last := nil;
  if element.type_ <> Element_Node then exit;
  if element.properties = nil then exit;
  tmp := element.properties;
  while tmp <> nil do begin
    if tmp = attr then begin
      Result := attr;
      if tmp.Next <> nil then if last <> nil then last.Next := tmp.Next
        else element.properties := tmp.Next
      else if last <> nil then last.Next := nil
      else element.properties := nil;
      Result.parent := nil;
      Result.Next := nil;
      Result.doc := nil;
      break;
    end;
    last := tmp;
    tmp := tmp.Next;
  end;
end;
function xmlRemoveChild(element: xmlNodePtr; node: xmlNodePtr): xmlNodePtr;
begin
  xmlunlinknode(node);
  result:=node;
end;

function TGDOMElement.getElementsByTagNameNS(const namespaceURI,
  localName: DOMString): IDomNodeList;
begin
  //todo: more generic code
  RegisterNs('xyz4ct', namespaceURI);
  Result := selectNodes('xyz4ct:' + localName);
end;

function TGDOMElement.hasAttribute(const Name: DOMString): boolean;
var
  name1: TGdomString;
begin
  name1 := TGdomString.Create(Name);
  if xmlHasProp(GElement, name1.CString) <> nil
    then Result := True
    else Result := False;
  name1.Free;
end;

function TGDOMElement.hasAttributeNS(const namespaceURI, localName: DOMString): boolean;
var
  name1, name2: TGdomString;
  temp:         string;
  node:         xmlNodePtr;
begin
  name2 := TGdomString.Create(namespaceURI);
  name1 := TGdomString.Create(localName);
  node := xmlNodePtr(GElement);
  if node.ns <> nil then begin
    temp := node.ns.href;
    temp := node.ns.prefix;
  end;
  if (xmlHasNSProp(xmlNodePtr(GElement), name1.CString,
    name2.CString)) <> nil then Result := True
  else Result := False;
  name1.Free;
  name2.Free;
end;

procedure TGDOMElement.normalize;
begin
  inherited normalize;
end;

constructor TGDOMElement.Create(AElement: xmlNodePtr; ADocument: IDomDocument;
  freenode: boolean = False);
begin
  inherited Create(xmlNodePtr(AElement), ADocument);
end;

destructor TGDOMElement.Destroy;
begin
  inherited Destroy;
end;


  //************************************************************************
  // functions of TGDOMDocument
  //************************************************************************

constructor TGDOMDocument.Create(GDOMImpl: IDomImplementation;
  const namespaceURI, qualifiedName: DOMString;
  doctype: IDomDocumentType);
var
  root:       xmlNodePtr;
  ns:         TGDOMNamespace;
  alocalName: widestring;
begin
  FGdomimpl := GDOMImpl;
  if doctype <> nil then if doctype.ownerDocument <> nil then
      if (doctype.ownerDocument as IUnknown) <> (self as IUnknown) then
        checkError(WRONG_DOCUMENT_ERR);
  alocalName := localName(qualifiedName);
  if (qualifiedName = '') and (namespaceURI <> '') then checkError(NAMESPACE_ERR);
  if (prefix(qualifiedName) = 'xml') and (namespaceURI <>
    'http://www.w3.org/XML/1998/namespace') then checkError(NAMESPACE_ERR);
  if (((Pos(':', alocalName)) > 0) or ((length(namespaceURI)) = 0) and
    ((Pos(':', qualifiedName)) > 0)) then checkError(NAMESPACE_ERR);
  if qualifiedName <> '' then if not IsXmlName(qualifiedName) then
      checkError(INVALID_CHARACTER_ERR);
  ns:=nil;
  if namespaceUri<>''
    then ns := TGDOMNamespace.Create(nil, namespaceURI, qualifiedName, self);
  FPGdomeDoc := xmlNewDoc(nil);
  if (namespaceUri<>'') and (length(alocalName)>0)
    then FPGdomeDoc.children := xmlNewDocNode(FPGdomeDoc, ns.ns, ns.localName.CString, nil);
  if (namespaceUri='') and (length(alocalName)>0)
    then FPGdomeDoc.children:=xmlNewDocNode(FPGdomeDoc,nil,pchar(UTF8Encode(alocalName)),nil);
  if namespaceUri<>''
    then begin
      FPGdomeDoc.children.nsDef := ns.Ns;
      ns.Free;
    end;
  //Get root-node
  root := xmlNodePtr(FPGdomeDoc);
  FAttrList := TList.Create;
  FNodeList := TList.Create;
  FPrefixList:=TStringList.Create;
  FUriList:=TStringList.Create;
  FtempXSL := nil;
  //Create root-node as pascal object
  inherited Create(root, nil);
  (FGDomImpl as IDomDebug).doccount:=(FGdomImpl as IDomDebug).doccount+1;
end;

destructor TGDOMDocument.Destroy;
var
  i:     integer;
  AAttr: xmlAttrPtr;
  ANode: xmlNodePtr;
begin
  if FPGdomeDoc <> nil then begin
    for i := 0 to FNodeList.Count - 1 do begin
      ANode := FNodeList[i];
      if ANode <> nil then if (ANode.parent = nil) then begin
          if ANode.type_ = xml_element_node then begin
            AAttr := ANode.properties;
            while AAttr <> nil do begin
              FAttrList.Remove(AAttr);
              AAttr := AAttr.Next
            end;
          end;
          xmlFreeNode(ANode)
        end;
    end;
    for i := 0 to FAttrList.Count - 1 do begin
      AAttr := FAttrList[i];
      if AAttr <> nil then if (AAttr.parent = nil) then if (AAttr.ns = nil) then
            xmlFreeProp(AAttr)
          else begin
            if AAttr.ns <> nil then xmlFreeNs(AAttr.ns);
            AAttr.ns := nil;
            xmlFreeProp(AAttr);
          end;
    end;
    if FtempXSL = nil then xmlFreeDoc(FPGdomeDoc)
    else begin
      xsltFreeStylesheet(FtempXSL);
    end;
    (FGDomImpl as IDomDebug).doccount:=(FGdomImpl as IDomDebug).doccount-1;
    FAttrList.Free;
    FNodeList.Free;
    if FPrefixList<>nil then FPrefixList.Free;
    if FUriList<>nil then FURIList.Free;
  end;
  inherited Destroy;
end;

// IDomDocument
function TGDOMDocument.get_doctype: IDomDocumentType;
var 
  dtd1, dtd2: xmlDtdPtr;
begin
  dtd1 := FPGdomeDoc.intSubset;
  dtd2 := FPGdomeDoc.extSubset;
  if (dtd1 <> nil) or (dtd2 <> nil) then Result :=
      TGDOMDocumentType.Create(dtd1, dtd2, self)
  else Result := nil;
end;

function TGDOMDocument.get_domImplementation: IDomImplementation;
begin
  Result := FGDOMImpl;
end;

function TGDOMDocument.get_documentElement: IDomElement;
var
  root1:  xmlNodePtr;
  FGRoot: TGDOMElement;
begin
  root1 := xmlDocGetRootElement(FPGdomeDoc);
  if root1 <> nil then FGRoot := TGDOMElement.Create(root1, self)
  else FGRoot := nil;
  Result := FGRoot;
end;

procedure TGDOMDocument.set_documentElement(const IDomElement: IDomElement);
begin
  checkError(NOT_SUPPORTED_ERR);
end;

function TGDOMDocument.createElement(const tagName: DOMString): IDomElement;
var
  name1:    TGdomString;
  AElement: xmlNodePtr;
begin
  if not IsXMLName(tagName) then checkError(INVALID_CHARACTER_ERR);
  name1 := TGdomString.Create(tagName);
  AElement := xmlNewDocNode(FPGdomeDoc, nil, name1.CString, nil);
  name1.Free;
  if AElement <> nil then begin
    AElement.parent := nil;
    FNodeList.Add(AElement);
    Result := TGDOMElement.Create(AElement, self)
  end else Result := nil;
end;

function TGDOMDocument.createDocumentFragment: IDomDocumentFragment;
var
  node: xmlNodePtr;
begin
  node := xmlNewDocFragment(FPGdomeDoc);
  if node <> nil then begin
    FNodeList.Add(node);
    Result := TGDOMDocumentFragment.Create(node, self)
  end else Result := nil;
end;

function TGDOMDocument.createTextNode(const Data: DOMString): IDomText;
var
  data1:     TGdomString;
  ATextNode: xmlNodePtr;
begin
  data1 := TGdomString.Create(Data);
  ATextNode := xmlNewDocText(FPGdomeDoc, data1.CString);
  data1.Free;
  if ATextNode <> nil then begin
    FNodeList.Add(ATextNode);
    Result := TGDOMText.Create((ATextNode), self)
  end else Result := nil;
end;

function TGDOMDocument.createComment(const Data: DOMString): IDomComment;
var
  data1: TGdomString;
  node:  xmlNodePtr;
begin
  data1 := TGdomString.Create(Data);
  node := xmlNewDocComment(FPGdomeDoc, data1.CString);
  data1.Free;
  if node <> nil then begin
    FNodeList.Add(node);
    Result := TGDOMComment.Create(PGdomeCharacterData(node), self)
  end else Result := nil;
end;

function TGDOMDocument.createCDATASection(const Data: DOMString): IDomCDATASection;
var
  name1: TGdomString;
  node:  xmlNodePtr;
begin
  name1 := TGdomString.Create(Data);
  node := xmlNewCDataBlock(FPGdomeDoc, name1.CString, length(name1.CString));
  name1.Free;
  if node <> nil then begin
    FNodeList.Add(node);
    Result := TGDOMCDataSection.Create(node, self, False)
  end else Result := nil;
end;

function TGDOMDocument.createProcessingInstruction(const target,
  Data: DOMString): IDomProcessingInstruction;
var
  name1, name2:           TGdomString;
  AProcessingInstruction: PGdomeProcessingInstruction;
begin
  if not IsXMLChars(target) then CheckError(INVALID_CHARACTER_ERR);
  name1 := TGdomString.Create(target);
  name2 := TGdomString.Create(Data);
  AProcessingInstruction := xmlNewPI(name1.CString, name2.CString);
  name1.Free;
  name2.Free;
  if AProcessingInstruction <> nil then begin
    AProcessingInstruction.parent := nil;
    AProcessingInstruction.doc := FPGdomeDoc;
    FNodeList.Add(AProcessingInstruction);
    Result := TGDOMProcessingInstruction.Create(AProcessingInstruction, self)
  end else Result := nil;
end;

function TGDOMDocument.createAttribute(const Name: DOMString): IDomAttr;
var
  name1: TGdomString;
  AAttr: xmlAttrPtr;
begin
  if not IsXMLName(Name) then checkError(INVALID_CHARACTER_ERR);
  name1 := TGdomString.Create(Name);
  AAttr := xmlNewDocProp(FPGdomeDoc, name1.CString, nil);
  AAttr.parent := nil;
  name1.Free;
  if AAttr <> nil then begin
    FAttrList.Add(AAttr);
    Result := TGDOMAttr.Create(AAttr, self)
  end else Result := nil;
end;

function TGDOMDocument.createEntityReference(const Name: DOMString): IDomEntityReference;
var
  name1: TGdomString;
  AEntityReference: xmlNodePtr;
begin
  if not IsXMLName(Name) then checkError(INVALID_CHARACTER_ERR);
  name1 := TGdomString.Create(Name);
  AEntityReference := xmlNewReference(FPGdomeDoc, name1.CString);
  name1.Free;
  if AEntityReference <> nil then begin
    FNodeList.Add(AEntityReference);
    Result := TGDOMEntityReference.Create(AEntityReference, self)
  end else Result := nil;
end;

function TGDOMDocument.getElementsByTagName(const tagName: DOMString): IDomNodeList;
var
  tmp: IDomNodeList;
begin
  tmp := (self.get_documentElement as IDomNodeSelect).selectNodes('//' + tagName);
  Result := tmp;
end;

function TGDOMDocument.importNode(importedNode: IDomNode; deep: boolean): IDomNode;
var
  recurse: integer;
  node,root:    xmlNodePtr;
  attr:    xmlAttrPtr;
begin
  Result := nil;
  if importedNode = nil then exit;
  case integer(importedNode.nodeType) of
    DOCUMENT_NODE, DOCUMENT_TYPE_NODE, NOTATION_NODE, ENTITY_NODE: CheckError(21);
    ATTRIBUTE_NODE:
      begin
        root := xmlDocGetRootElement(FPGdomeDoc);
        attr:=xmlCopyProp(root,xmlAttrPtr(GetGNode(importedNode)));
        if attr <>nil then begin
          attr.parent:=nil;
          attr.doc:=FPGdomeDoc;
          appendAttr(attr);
          result:=MakeNode(xmlNodePtr(attr),self);
        end;
      end;
    else if deep then recurse := 1
      else recurse := 0;
        node := xmlDocCopyNode(GetGNode(importedNode), FPGdomeDoc, recurse);
        if node <> nil then Result := MakeNode(node, self)
        else Result := nil;
  end;
end;

function TGDOMDocument.createElementNS(const namespaceURI,
  qualifiedName: DOMString): IDomElement;
var
  AElement:   xmlNodePtr;
  ns:         TGDOMNamespace;
  temp:       string;
  alocalName: widestring;
begin
  alocalName := localName(qualifiedName);
  if (prefix(qualifiedName) = 'xml') and (namespaceURI <>
    'http://www.w3.org/XML/1998/namespace') then checkError(NAMESPACE_ERR);
  if (((Pos(':', alocalName)) > 0) or ((length(namespaceURI)) = 0) and
    ((Pos(':', qualifiedName)) > 0)) then checkError(NAMESPACE_ERR);
  if qualifiedName <> '' then if not IsXmlName(qualifiedName) then
      checkError(INVALID_CHARACTER_ERR);
  if namespaceURI<>'' then begin
    ns := TGDOMNamespace.Create(nil, namespaceURI, qualifiedName, self);
    AElement := xmlNewDocNode(FPGdomeDoc, ns.NS, ns.localName.CString, nil);
    temp := AElement.ns.href;
    temp := AElement.ns.prefix;
    AElement.nsdef := ns.NS;
    ns.Free;
  end else begin
    AElement := xmlNewDocNode(FPGdomeDoc, nil, pchar(UTF8Encode(qualifiedName)), nil);
  end;
  if AElement <> nil then begin
    AElement.parent := nil;
    FNodeList.Add(AElement);
    Result := TGDOMElement.Create(AElement, self)
  end else Result := nil;
end;

function TGDOMDocument.createAttributeNS(const namespaceURI,
  qualifiedName: DOMString): IDomAttr;
var
  AAttr:      xmlAttrPtr;
  ns:         TGDOMNameSpace;
  alocalName: widestring;
begin
  alocalName := localName(qualifiedName);
  if (prefix(qualifiedName) = 'xml') and (namespaceURI <>
    'http://www.w3.org/XML/1998/namespace') then checkError(NAMESPACE_ERR);
  if ((qualifiedName = 'xmlns') or (prefix(qualifiedName) = 'xmlns'))
    and (namespaceURI <> 'http://www.w3.org/2000/xmlns/') then checkError(NAMESPACE_ERR);
  if (((Pos(':', alocalName)) > 0) or ((length(namespaceURI)) = 0) and
    ((Pos(':', qualifiedName)) > 0)) then checkError(NAMESPACE_ERR);
  if qualifiedName <> '' then if not IsXmlName(qualifiedName) then
      checkError(INVALID_CHARACTER_ERR);
  ns := TGDOMNamespace.Create(nil, namespaceURI, qualifiedName, self);
  AAttr := xmlNewNsProp(nil, ns.ns, ns.localName.CString, nil);
  AAttr.doc:=self.FPGdomeDoc;
  ns.Free;
  if AAttr <> nil then begin
    FAttrList.Add(AAttr);
    Result := TGDOMAttr.Create(AAttr, self)
  end else Result := nil;
end;

function TGDOMDocument.getElementsByTagNameNS(const namespaceURI,
  localName: DOMString): IDomNodeList;
var
  docElement: IDomElement;
  tmp1:       IDomNodeList;
begin
  if (namespaceURI = '*') then if (localname <> '*') then begin
      docElement := self.get_documentElement;
      tmp1 := (docElement as IDomNodeSelect).selectNodes('//*[local-name()="' +
        localname + '"]');
      Result := tmp1;
    end else begin
      docElement := self.get_documentElement;
      tmp1 := (docElement as IDomNodeSelect).selectNodes('//*');
      Result := tmp1;
    end else begin
    docElement := self.get_documentElement;
    tmp1 := (docElement as IDomNodeSelect).selectNodes('//*[(local-name() = "'+
      localname+'") and (namespace-uri() = "'+namespaceURI+'")]');
    Result := tmp1;
  end;
end;

function TGDOMDocument.getElementById(const elementId: DOMString): IDomElement;
var
  AAttr:    xmlAttrPtr;
  AElement: xmlNodePtr;
  name1:    TGdomString;
begin
  name1 := TGdomString.Create(elementID);
  AAttr := xmlGetID(FPGdomeDoc, name1.CString);
  if AAttr <> nil then AElement := AAttr.parent
  else AElement := nil;
  name1.Free;
  if AElement <> nil then Result := TGDOMElement.Create(AElement, self)
  else Result := nil;
end;

// IDomParseOptions
function TGDOMDocument.get_async: boolean;
begin
  Result := FAsync;
end;

function TGDOMDocument.get_preserveWhiteSpace: boolean;
begin
  Result := FPreserveWhiteSpace;
end;

function TGDOMDocument.get_resolveExternals: boolean;
begin
  Result := FResolveExternals;
end;

function TGDOMDocument.get_validate: boolean;
begin
  Result := FValidate;
end;

procedure TGDOMDocument.set_async(Value: boolean);
begin
  FAsync := True;
end;

procedure TGDOMDocument.set_preserveWhiteSpace(Value: boolean);
begin
  FPreserveWhitespace := Value;
  if Value then xmlKeepBlanksDefault(1)
  else xmlKeepBlanksDefault(0);
end;

procedure TGDOMDocument.set_resolveExternals(Value: boolean);
begin
  if Value
    then xmlSubstituteEntitiesDefault(1)
    else xmlSubstituteEntitiesDefault(0);
  FResolveExternals := Value;
end;

procedure TGDOMDocument.set_validate(Value: boolean);
begin
  Fvalidate := Value;
end;

// IDomPersist
function TGDOMDocument.get_xml: DOMString;
var
  CString, encoding: PChar;
  length: longint;
  temp:   string;
  format: integer;
begin
  result:='';
  temp := Fencoding;
  if Fencoding = ''
    then encoding := FPGdomeDoc.encoding
    else encoding := PChar(temp);
  // if the xml document doesn't have an encoding or a documentElement,
  // return an empty string (it works like this in msdom)
  if (FPGdomeDoc.children<>nil) or (encoding<>'')
    then begin
      format := 0;
      if FprettyPrint then begin
        format := -1;
      end;
      xmlDocDumpFormatMemoryEnc(FPGdomeDoc, CString, @length, encoding, format);
      Result := CString;
      xmlFree(CString);  //this works with the new dll from 2001-01-25
    end;
end;

function TGDOMDocument.asyncLoadState: integer;
begin
  Result := 0;
end;

function TGDOMDocument.load(Source: DOMString): boolean;
  // Load dom from file
var
  fn:   string;
  ctxt: xmlParserCtxtPtr;
  root: xmlNodePtr;
begin
  Result := False;
  fn := Source;
  {$ifdef WIN32}
  fn := UTF8Encode(StringReplace(Source, '\', '\\', [rfReplaceAll]));
  {$else}
  fn := Source;
  {$endif}
  xmlInitParser();
  ctxt := xmlCreateFileParserCtxt(PChar(fn));
  if (ctxt <> nil) then begin
    // validation
    ctxt.validate := -1;
    //todo: async (separate thread)
    //todo: resolveExternals
    xmlParseDocument(ctxt);
    if (ctxt.wellFormed <> 0) then if not Fvalidate or (ctxt.valid <> 0) then begin
        xmlFreeDoc(FPGdomeDoc);
        inherited Destroy;
        FPGdomeDoc := ctxt.myDoc;
        Result := True;
      end else begin
        xmlFreeDoc(ctxt.myDoc);
        ctxt.myDoc := nil;
        Result := False;
      end;
    xmlFreeParserCtxt(ctxt);
  end;
  if Result then begin
    root := xmlNodePtr(FPGdomeDoc);
    inherited Create(root, nil);
  end else Result := False;
end;

function TGDOMDocument.loadFromStream(const stream: TStream): boolean;
begin
  checkError(NOT_SUPPORTED_ERR);
  Result := False;
end;

function TGDOMDocument.loadxml(const Value: DOMString): boolean;
  // Load dom from string;
var
  temp: TGdomString;
  root: xmlNodePtr;
  ctxt: xmlParserCtxtPtr;
begin
  // to do: add the following line to the other load methods
  Result := False;
  temp := TGdomString.Create(Value);
  xmlInitParser();
  ctxt := xmlCreateDocParserCtxt(temp.CString);
  if (ctxt <> nil) then begin
    ctxt.validate := -1;
    //todo: async (separate thread)
    //todo: resolveExternals
    xmlParseDocument(ctxt);
    if (ctxt.wellFormed <> 0) then if not Fvalidate or (ctxt.valid <> 0) then begin
        xmlFreeDoc(FPGdomeDoc);
        inherited Destroy;
        // to do: add the following line to the other load methods
        Result := True;
        FPGdomeDoc := ctxt.myDoc
      end else begin
        xmlFreeDoc(ctxt.myDoc);
        ctxt.myDoc := nil;
        Result := False;
      end
    else begin
      xmlFreeDoc(ctxt.myDoc);
      ctxt.myDoc := nil;
      Result := False;
    end;
    xmlFreeParserCtxt(ctxt);
  end;
  temp.Free;
  if Result then begin
    root := xmlNodePtr(FPGdomeDoc);
    inherited Create(root, nil);
  end else Result := False;
end;

procedure TGDOMDocument.save(Source: DOMString);
var
  encoding:    PChar;
  bytes:       integer;
  temp, temp1: string;
  format:      integer;
begin
  temp := Fencoding;
  if Fencoding = '' then encoding := FPGdomeDoc.encoding
  else encoding := PChar(temp);
  format := 0;
  if FprettyPrint then begin
    format := -1;
    //xmlIndentTreeOutputPtr^:=-1;
  end;
  temp1 := Source;
  bytes := xmlSaveFormatFileEnc(PChar(temp1), FPGdomeDoc, encoding, format);
  if bytes < 0 then CheckError(22); //write error
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

function GetGNode(const Node: IDomNode): xmlNodePtr;
begin
  if not Assigned(Node) then checkError(INVALID_ACCESS_ERR);
  Result := (Node as IXMLDOMNodeRef).GetGDOMNode;
end;

function ErrorString(err: integer): string;
begin
  case err of
    INDEX_SIZE_ERR: Result := 'INDEX_SIZE_ERR';
    DOMSTRING_SIZE_ERR: Result := 'DOMSTRING_SIZE_ERR';
    HIERARCHY_REQUEST_ERR: Result := 'HIERARCHY_REQUEST_ERR';
    WRONG_DOCUMENT_ERR: Result := 'WRONG_DOCUMENT_ERR';
    INVALID_CHARACTER_ERR: Result := 'INVALID_CHARACTER_ERR';
    NO_DATA_ALLOWED_ERR: Result := 'NO_DATA_ALLOWED_ERR';
    NO_MODIFICATION_ALLOWED_ERR: Result := 'NO_MODIFICATION_ALLOWED_ERR';
    NOT_FOUND_ERR: Result := 'NOT_FOUND_ERR';
    NOT_SUPPORTED_ERR: Result := 'NOT_SUPPORTED_ERR';
    INUSE_ATTRIBUTE_ERR: Result := 'INUSE_ATTRIBUTE_ERR';
    INVALID_STATE_ERR: Result := 'INVALID_STATE_ERR';
    SYNTAX_ERR: Result := 'SYNTAX_ERR';
    INVALID_MODIFICATION_ERR: Result := 'INVALID_MODIFICATION_ERR';
    NAMESPACE_ERR: Result := 'NAMESPACE_ERR';
    INVALID_ACCESS_ERR: Result := 'INVALID_ACCESS_ERR';
    20: Result := 'SaveXMLToMemory_ERR';
    21: Result := 'NotSupportedByLibxmldom_ERR';
    22: Result := 'SaveXMLToDisk_ERR';
    100: Result := 'LIBXML2_NULL_POINTER_ERR';
    101: Result := 'INVALID_NODE_SET_ERR';
    else Result := 'Unknown error no: ' + IntToStr(err);
  end;
end;

procedure CheckError(err: integer);
begin
  if err <> 0 then raise EDOMException.Create(err, ErrorString(err));
end;

function IsReadOnlyNode(node: xmlNodePtr): boolean;
begin
  if node <> nil then case node.type_ of
      XML_NOTATION_NODE, XML_ENTITY_NODE, XML_ENTITY_DECL: Result := True;
      else Result := False;
    end else Result := False;
end;

{ TGdomString }

constructor TGdomString.Create(ADOMString: DOMString);
var
  temp:  string;
  temp1: integer;
begin
  inherited Create;
  temp := UTF8Encode(ADOMString);
  temp1 := length(temp) + 1;
  CString := '';
  CString := StrAlloc(temp1);
  strcopy(CString, PChar(temp));
end;

destructor TGdomString.Destroy;
begin
  strdispose(CString);
  inherited Destroy;
end;

{ TGDOMCharacterData }

procedure TGDOMCharacterData.appendData(const Data: DOMString);
var
  value1: TGdomString;
begin
  value1 := TGdomString.Create(Data);
  xmlNodeAddContent(GetGCharacterData, value1.CString);
  value1.Free;
end;

procedure TGDOMCharacterData.deleteData(offset, Count: integer);
begin
  replaceData(offset, Count, '');
end;

function TGDOMCharacterData.get_data: DOMString;
begin
  Result := inherited get_nodeValue;
end;

function TGDOMCharacterData.get_length: integer;
begin
  Result := length(get_data);
end;

function TGDOMCharacterData.GetGCharacterData: PGDomeCharacterData;
begin
  Result := xmlNodePtr(GNode);
end;

procedure TGDOMCharacterData.insertData(offset: integer;
  const Data: DOMString);
var
  value1: TGdomString;
begin
  value1 := TGdomString.Create(Data);
  replaceData(offset, 0, Data);
  value1.Free;
end;

procedure TGDOMCharacterData.replaceData(offset, Count: integer;
  const Data: DOMString);
var
  s1, s2, s: widestring;
begin
  s := Get_data;
  if (offset < 0) or (offset > length(s)) or (Count < 0) then checkError(INDEX_SIZE_ERR);
  s1 := Copy(s, 1, offset);
  s2 := Copy(s, offset + Count + 1, Length(s) - offset - Count);
  s := s1 + Data + s2;
  Set_data(s);
end;

procedure TGDOMCharacterData.set_data(const Data: DOMString);
begin
  inherited set_nodeValue(Data);
end;

function TGDOMCharacterData.substringData(offset,
  Count: integer): DOMString;
var
  s: widestring;
begin
  if (offset < 0) or (offset > length(s)) or (Count < 0) then checkError(INDEX_SIZE_ERR);
  s := Get_data;
  s := copy(s, offset, Count);
  Result := s
end;

constructor TGDOMCharacterData.Create(ACharacterData: xmlNodePtr;
  ADocument: IDomDocument; freenode: boolean = False);
begin
  inherited Create(xmlNodePtr(ACharacterData), ADocument);
end;

destructor TGDOMCharacterData.Destroy;
begin
  inherited Destroy;
end;

{ TGDOMText }

function TGDOMText.splitText(offset: integer): IDomText;
var
  s, s1: widestring;
  tmp:   IDomText;
  node:  IDomNode;
begin
  s := Get_data;
  if (offset < 0) or (offset > length(s)) then checkError(INDEX_SIZE_ERR);
  s1 := Copy(s, 1, offset);
  Set_data(s1);
  s1 := Copy(s, 1 + offset, length(s));
  tmp := self.FOwnerDocument.createTextNode(s1);
  if self.get_parentNode <> nil then begin
    node := self.get_parentNode;
    if self.get_nextSibling = nil then node.appendChild(tmp)
    else node.insertBefore(tmp, self.get_nextSibling);
  end;
  Result := tmp;
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
  Result := nil;
end;

{ TGDOMProcessingInstruction }

function TGDOMProcessingInstruction.get_data: DOMString;
begin
  Result := inherited get_nodeValue;
end;

function TGDOMProcessingInstruction.get_target: DOMString;
begin
  Result := inherited get_nodeName;
end;

function TGDOMProcessingInstruction.GetGProcessingInstruction: PGdomeProcessingInstruction;
begin
  Result := PGdomeProcessingInstruction(GNode);
end;

procedure TGDOMProcessingInstruction.set_data(const Value: DOMString);
begin
  inherited set_nodeValue(Value);
end;

{ TGDOMDocumentType }

function TGDOMDocumentType.get_entities: IDomNamedNodeMap;
var
  dtd: xmlDtdPtr;
begin
  dtd := GDocumentType;
  if (dtd <> nil) or (Fdtd2 <> nil) then Result :=
      TGDOMNamedNodeMap.Create(xmlNodePtr(dtd), FOwnerDocument, 1,Fdtd2) as IDomNamedNodeMap
  else Result := nil;
end;

function TGDOMDocumentType.get_internalSubset: DOMString;
var
  buff: xmlBufferPtr;
begin
  buff := xmlBufferCreate();
  xmlNodeDump(buff, nil, xmlNodePtr(GetGDocumentType), 0,0);
  Result := libxmlStringToString(buff.content);
  xmlBufferFree(buff);
end;

function TGDOMDocumentType.get_name: DOMString;
begin
  Result := self.get_nodeName;
end;

function TGDOMDocumentType.get_notations: IDomNamedNodeMap;
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
    then result:=TGDOMNamedNodeMap.Create(notations,FOwnerDocument) as IDomNamedNodeMap
    else result:=nil;}
end;

function TGDOMDocumentType.get_publicId: DOMString;
begin
  Result := libxmlStringToString(GetGDocumentType.ExternalID);
end;

function TGDOMDocumentType.get_systemId: DOMString;
begin
  Result := libxmlStringToString(GetGDocumentType.SystemID);
end;

function TGDOMDocumentType.GetGDocumentType: xmlDtdPtr;
begin
  Result := xmlDtdPtr(GNode);
end;

constructor TGDOMDocumentType.Create(dtd1, dtd2: xmlDtdPtr; ADocument: IDomDocument);
var
  root: xmlNodePtr;
begin
  //Get root-node
  root := xmlNodePtr(dtd1);
  Fdtd2 := dtd2;
  //Create root-node as pascal object
  inherited Create(root, ADocument);
end;


destructor TGDOMDocumentType.Destroy;
begin
  if (GDocumentType <> nil) and (get_ownerDocument = nil) then xmlFreeDtd(GDocumentType);
  inherited Destroy;
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
  Result := PGdomeNotation(GNode);
end;

{ TGDOMNameSpace }

constructor TGDOMNameSpace.Create(node: xmlNodePtr;
  namespaceURI, qualifiedName: DOMString; OwnerDoc: IDomDocument);
var
  name1, name3: TGdomString;
  prefix:       widestring;
  alocalName:   widestring;
begin
  FOwnerDoc := OwnerDoc;
  name1 := TGdomString.Create(namespaceURI);
  prefix := Copy(qualifiedName, 1,Pos(':', qualifiedName) - 1);
  FqualifiedName := TGdomString.Create(qualifiedName);
  alocalName := (Copy(qualifiedName, Pos(':', qualifiedName) + 1,
    length(qualifiedName) - length(prefix) - 1));
  localName := TGdomString.Create(alocalname);
  name3 := TGdomString.Create(prefix);
  ns := xmlNewNs(node, name1.CString, name3.CString);
  name1.Free;
  name3.Free;
end;

destructor TGDOMNameSpace.Destroy;
begin
  //(FOwnerDoc as IDomInternal).appendNs(Ns);
  FOwnerDoc := nil;
  localName.Free;
  FqualifiedName.Free;
  inherited Destroy;
end;

function TGDOMNode.selectNode(const nodePath: WideString): IDomNode;
  // todo: raise  exceptions
  //       a) if invalid nodePath expression
  //       b) if result type <> nodelist
  //       c) perhaps if nodelist.length > 1 ???
begin
  Result := selectNodes(nodePath)[0];
end;

function TGDOMNode.selectNodes(const nodePath: WideString): IDomNodeList;
// raises SYNTAX_ERR,
// if invalid xpath expression or
// if the result type is string or number
var
  doc:  xmlDocPtr;
  ctxt: xmlXPathContextPtr;
  res:  xmlXPathObjectPtr;
  temp: string;
  nodetype: integer;
  i: integer;
  Prefix,Uri,Uri1: string;
  FPrefixList,FUriList:TStringList;
  nodecount1:integer;
begin
  temp := UTF8Encode(nodePath);
  doc := FGNode.doc;
  if doc = nil then CheckError(100);  // jk: what is Error 100 ???
  ctxt := xmlXPathNewContext(doc);
  ctxt.node := FGNode;
  FPrefixList:=(FOwnerDocument as IDomInternal).getPrefixList;
  FUriList:=(FOwnerDocument as IDomInternal).getUriList;
  for i:=0 to FPrefixList.Count-1 do begin
    Prefix:=FPrefixList[i];
    Uri:=FUriList[i];
    Uri1:=xmlXPathNsLookup(ctxt,pchar(prefix));
    if (Prefix <> '') and (Uri <> '') and (Uri<>Uri1)
      then xmlXPathRegisterNs(ctxt, PChar(Prefix), PChar(URI));
  end;
  res := xmlXPathEvalExpression(PChar(temp), ctxt);
  if res <> nil then begin
    nodetype := res.type_;
    case nodetype of
      XPATH_NODESET:
        begin
          if res.nodesetval<> nil
            then nodecount1 := res.nodesetval.nodeNr;
          Result := TGDOMNodeList.Create(res, FOwnerDocument)
        end else begin
          Result := nil;
          checkError(SYNTAX_ERR);
        end;
    end;
  end else begin
    Result := nil;
    checkError(SYNTAX_ERR);
  end;
  xmlXPathFreeContext(ctxt);
end;

(*
 *  TXDomDocumentBuilderFactory
*)
constructor TGDOMDocumentBuilderFactory.Create(AFreeThreading: boolean);
begin
  FFreeThreading := AFreeThreading;
end;

function TGDOMDocumentBuilderFactory.NewDocumentBuilder: IDomDocumentBuilder;
begin
  Result := TGDOMDocumentBuilder.Create(FFreeThreading);
end;

function TGDOMDocumentBuilderFactory.Get_VendorID: DomString;
begin
  if FFreeThreading then Result := SLIBXML
  else Result := SLIBXML;
end;

procedure TGDOMNode.set_Prefix(const prefix: DomString);
begin
  checkError(NOT_SUPPORTED_ERR);
end;

function TGDOMDocumentBuilder.load(const url: DomString): IDomDocument;
begin
  Result := (TGDOMDocument.Create(Get_DomImplementation, url)) as IDomDocument;
end;

function TGDOMDocumentBuilder.newDocument: IDomDocument;
begin
  Result := TGDOMDocument.Create(Get_DomImplementation);
end;

function TGDOMDocumentBuilder.parse(const xml: DomString): IDomDocument;
begin
  Result := TGDOMDocument.Create(Get_DomImplementation, '', '', nil);
  (Result as IDomParseOptions).resolveExternals := True;
  (Result as IDomPersist).loadxml(xml);
end;

procedure TGDOMNode.RegisterNS(const prefix, URI: DomString);
begin
  (FOwnerdocument as IDomInternal).appendNS(UTF8Encode(prefix),UTF8Encode(Uri));
end;

function TGDOMNode.IsReadOnly: boolean;
begin
  Result := IsReadOnlyNode(FGNode)
end;

function TGDOMNode.IsAncestorOrSelf(newNode: xmlNodePtr): boolean;
var
  node: xmlNodePtr;
begin
  node := FGNode;
  Result := True;
  while node <> nil do begin
    if node = newNode then exit;
    node := node.parent;
  end;
  Result := False;
end;

constructor TGDOMDocument.Create(GDOMImpl: IDomImplementation);
var
  root: xmlNodePtr;
begin
  FGdomimpl := GDOMImpl;
  FPGdomeDoc := xmlNewDoc(nil);
  //Get root-node
  root := xmlNodePtr(FPGdomeDoc);
  FAttrList := TList.Create;
  FNodeList := TList.Create;
  FPrefixList:=TStringList.Create;
  FURIList:=TStringList.Create;
  //Create root-node as pascal object
  inherited Create(root, nil);
  (FGDomImpl as IDomDebug).doccount:=(FGdomImpl as IDomDebug).doccount+1;
end;

constructor TGDOMDocument.Create(GDOMImpl: IDomImplementation; aUrl: DomString);
var
  fn:   string;
  ctxt: xmlParserCtxtPtr;
begin
  FGdomimpl := GDOMImpl;
  {$ifdef WIN32}
  fn := UTF8Encode(StringReplace(aUrl, '\', '\\', [rfReplaceAll]));
  {$else}
  fn := aUrl;
  {$endif}
  //FPGdomeDoc:=(xmlParseFile(PChar(fn)));
  //Load DOM from file
  FPGdomeDoc := nil;
  xmlInitParser();
  ctxt := xmlCreateFileParserCtxt(PChar(fn));
  if (ctxt <> nil) then begin
    // validation
    ctxt.validate := -1;
    //todo: async (separate thread)
    //todo: resolveExternals
    xmlParseDocument(ctxt);
    if (ctxt.wellFormed <> 0) then if not Fvalidate or (ctxt.valid <> 0) then begin
        FPGdomeDoc := ctxt.myDoc;
      end else begin
        xmlFreeDoc(ctxt.myDoc);
        ctxt.myDoc := nil;
      end;
    xmlFreeParserCtxt(ctxt);
  end;
  if (FPGdomeDoc <> nil) then begin
    FtempXSL := nil;
    FAttrList := TList.Create;
    FNodeList := TList.Create;
    FPrefixList:=TStringList.Create;
    FURIList:=TStringList.Create;
    inherited Create(xmlNodePtr(FPGdomeDoc), nil);
    (FGDomImpl as IDomDebug).doccount:=(FGdomImpl as IDomDebug).doccount+1;
  end;
end;

procedure TGDOMDocument.removeAttr(attr: xmlAttrPtr);
begin
  if attr <> nil
    then FAttrList.Remove(attr);
end;



procedure TGDOMDocument.appendAttr(attr: xmlAttrPtr);
begin
  if attr <> nil then FAttrList.add(attr);
end;

procedure TGDOMDocument.appendNode(node: xmlNodePtr);
begin
  if node <> nil then FNodeList.add(node);
end;

  //********************************************************************//
  // | The following routines for testing XML rules were taken from the //
  // | Extended Document Object Model (XDOM) package,                   //
  // | copyright (c) 1999-2002 by Dieter Köhler.                        //
  //********************************************************************//

function IsXmlIdeographic(const S: widechar): boolean;
begin
  case word(S) of
    $4E00..$9FA5,$3007,$3021..$3029: Result := True;
    else Result := False;
  end;
end;

function IsXmlBaseChar(const S: widechar): boolean;
begin
  case word(S) of
    $0041..$005a,$0061..$007a,$00c0..$00d6,$00d8..$00f6,$00f8..$00ff,
    $0100..$0131,$0134..$013E,$0141..$0148,$014a..$017e,$0180..$01c3,
    $01cd..$01f0,$01f4..$01f5,$01fa..$0217,$0250..$02a8,$02bb..$02c1,
    $0386,$0388..$038a,$038c,$038e..$03a1,$03a3..$03ce,$03D0..$03D6,
    $03DA,$03DC,$03DE,$03E0,$03E2..$03F3,$0401..$040C,$040E..$044F,
    $0451..$045C,$045E..$0481,$0490..$04C4,$04C7..$04C8,$04CB..$04CC,
    $04D0..$04EB,$04EE..$04F5,$04F8..$04F9,$0531..$0556,$0559,
    $0561..$0586,$05D0..$05EA,$05F0..$05F2,$0621..$063A,$0641..$064A,
    $0671..$06B7,$06BA..$06BE,$06C0..$06CE,$06D0..$06D3,$06D5,
    $06E5..$06E6,$0905..$0939,$093D,$0958..$0961,$0985..$098C,
    $098F..$0990,$0993..$09A8,$09AA..$09B0,$09B2,$09B6..$09B9,
    $09DC..$09DD,$09DF..$09E1,$09F0..$09F1,$0A05..$0A0A,$0A0F..$0A10,
    $0A13..$0A28,$0A2A..$0A30,$0A32..$0A33,$0A35..$0A36,$0A38..$0A39,
    $0A59..$0A5C,$0A5E,$0A72..$0A74,$0A85..$0A8B,$0A8D,$0A8F..$0A91,
    $0A93..$0AA8,$0AAA..$0AB0,$0AB2..$0AB3,$0AB5..$0AB9,$0ABD,$0AE0,
    $0B05..$0B0C,$0B0F..$0B10,$0B13..$0B28,$0B2A..$0B30,$0B32..$0B33,
    $0B36..$0B39,$0B3D,$0B5C..$0B5D,$0B5F..$0B61,$0B85..$0B8A,
    $0B8E..$0B90,$0B92..$0B95,$0B99..$0B9A,$0B9C,$0B9E..$0B9F,
    $0BA3..$0BA4,$0BA8..$0BAA,$0BAE..$0BB5,$0BB7..$0BB9,$0C05..$0C0C,
    $0C0E..$0C10,$0C12..$0C28,$0C2A..$0C33,$0C35..$0C39,$0C60..$0C61,
    $0C85..$0C8C,$0C8E..$0C90,$0C92..$0CA8,$0CAA..$0CB3,$0CB5..$0CB9,
    $0CDE,$0CE0..$0CE1,$0D05..$0D0C,$0D0E..$0D10,$0D12..$0D28,
    $0D2A..$0D39,$0D60..$0D61,$0E01..$0E2E,$0E30,$0E32..$0E33,
    $0E40..$0E45,$0E81..$0E82,$0E84,$0E87..$0E88,$0E8A,$0E8D,
    $0E94..$0E97,$0E99..$0E9F,$0EA1..$0EA3,$0EA5,$0EA7,$0EAA..$0EAB,
    $0EAD..$0EAE,$0EB0,$0EB2..$0EB3,$0EBD,$0EC0..$0EC4,$0F40..$0F47,
    $0F49..$0F69,$10A0..$10C5,$10D0..$10F6,$1100,$1102..$1103,
    $1105..$1107,$1109,$110B..$110C,$110E..$1112,$113C,$113E,$1140,
    $114C,$114E,$1150,$1154..$1155,$1159,$115F..$1161,$1163,$1165,
    $1167,$1169,$116D..$116E,$1172..$1173,$1175,$119E,$11A8,$11AB,
    $11AE..$11AF,$11B7..$11B8,$11BA,$11BC..$11C2,$11EB,$11F0,$11F9,
    $1E00..$1E9B,$1EA0..$1EF9,$1F00..$1F15,$1F18..$1F1D,$1F20..$1F45,
    $1F48..$1F4D,$1F50..$1F57,$1F59,$1F5B,$1F5D,$1F5F..$1F7D,
    $1F80..$1FB4,$1FB6..$1FBC,$1FBE,$1FC2..$1FC4,$1FC6..$1FCC,
    $1FD0..$1FD3,$1FD6..$1FDB,$1FE0..$1FEC,$1FF2..$1FF4,$1FF6..$1FFC,
    $2126,$212A..$212B,$212E,$2180..$2182,$3041..$3094,$30A1..$30FA,
    $3105..$312C,$AC00..$d7a3: Result := True;
    else Result := False;
  end;
end;

function IsXmlLetter(const S: widechar): boolean;
begin
  Result := IsXmlIdeographic(S) or IsXmlBaseChar(S);
end;

function IsXmlDigit(const S: widechar): boolean;
begin
  case word(S) of
    $0030..$0039,$0660..$0669,$06F0..$06F9,$0966..$096F,$09E6..$09EF,
    $0A66..$0A6F,$0AE6..$0AEF,$0B66..$0B6F,$0BE7..$0BEF,$0C66..$0C6F,
    $0CE6..$0CEF,$0D66..$0D6F,$0E50..$0E59,$0ED0..$0ED9,$0F20..$0F29: Result := True;
    else Result := False;
  end;
end;

function IsXmlCombiningChar(const S: widechar): boolean;
begin
  case word(S) of
    $0300..$0345,$0360..$0361,$0483..$0486,$0591..$05A1,$05A3..$05B9,
    $05BB..$05BD,$05BF,$05C1..$05C2,$05C4,$064B..$0652,$0670,
    $06D6..$06DC,$06DD..$06DF,$06E0..$06E4,$06E7..$06E8,$06EA..$06ED,
    $0901..$0903,$093C,$093E..$094C,$094D,$0951..$0954,$0962..$0963,
    $0981..$0983,$09BC,$09BE,$09BF,$09C0..$09C4,$09C7..$09C8,
    $09CB..$09CD,$09D7,$09E2..$09E3,$0A02,$0A3C,$0A3E,$0A3F,
    $0A40..$0A42,$0A47..$0A48,$0A4B..$0A4D,$0A70..$0A71,$0A81..$0A83,
    $0ABC,$0ABE..$0AC5,$0AC7..$0AC9,$0ACB..$0ACD,$0B01..$0B03,$0B3C,
    $0B3E..$0B43,$0B47..$0B48,$0B4B..$0B4D,$0B56..$0B57,$0B82..$0B83,
    $0BBE..$0BC2,$0BC6..$0BC8,$0BCA..$0BCD,$0BD7,$0C01..$0C03,
    $0C3E..$0C44,$0C46..$0C48,$0C4A..$0C4D,$0C55..$0C56,$0C82..$0C83,
    $0CBE..$0CC4,$0CC6..$0CC8,$0CCA..$0CCD,$0CD5..$0CD6,$0D02..$0D03,
    $0D3E..$0D43,$0D46..$0D48,$0D4A..$0D4D,$0D57,$0E31,$0E34..$0E3A,
    $0E47..$0E4E,$0EB1,$0EB4..$0EB9,$0EBB..$0EBC,$0EC8..$0ECD,
    $0F18..$0F19,$0F35,$0F37,$0F39,$0F3E,$0F3F,$0F71..$0F84,
    $0F86..$0F8B,$0F90..$0F95,$0F97,$0F99..$0FAD,$0FB1..$0FB7,$0FB9,
    $20D0..$20DC,$20E1,$302A..$302F,$3099,$309A: Result := True;
    else Result := False;
  end;
end;

function IsXmlExtender(const S: widechar): boolean;
begin
  case word(S) of
    $00B7,$02D0,$02D1,$0387,$0640,$0E46,$0EC6,$3005,$3031..$3035,
    $309D..$309E,$30FC..$30FE: Result := True;
    else Result := False;
  end;
end;

function IsXmlNameChar(const S: widechar): boolean;
begin
  if IsXmlLetter(S) or IsXmlDigit(S) or IsXmlCombiningChar(S) or
    IsXmlExtender(S) or (S = '.') or (S = '-') or (S = '_') or (S = ':') then Result := True
  else Result := False;
end;

function IsUtf16LowSurrogate(const S: widechar): boolean;
begin
  case word(S) of
    $DC00..$DFFF: Result := True;
    else Result := False;
  end;
end;

function IsXmlChars(const S: WideString): boolean;
var
  i, l, pl: integer;
  sChar:    widechar;
begin
  Result := True;
  i := 0;
  l := length(S);
  pl := pred(l);
  while i < pl do begin
    inc(i);
    sChar := S[i];
    case word(sChar) of
      $0009,$000A,$000D,$0020..$D7FF,$E000..$FFFD: // Unicode below $FFFF
      ; // do nothing.
      $D800..$DBFF: // High surrogate of Unicode character [$10000..$10FFFF]
        begin
          if i = l then begin 
            Result := False; 
            break; 
          end; // End of wideString --> No low surrogate found
          inc(i);
          sChar := S[i];
          if not IsUtf16LowSurrogate(sChar) then begin 
            Result := False; 
            break; 
          end; // No low surrogate found
        end;
      else begin 
          Result := False; 
          break; 
        end;
    end; {case ...}
  end;   {while ...}
end;

function IsXmlName(const S: WideString): boolean;
var
  i: integer;
begin
  Result := True;
  if Length(S) = 0 then begin 
    Result := False; 
    exit; 
  end;
  if not (IsXmlLetter(PWideChar(S)^) or (PWideChar(S)^ = '_') or (PWideChar(S)^ = ':')) then
  begin 
    Result := False; 
    exit; 
  end;
  for i := 2 to length(S) do if not IsXmlNameChar((PWideChar(S) + i - 1)^) then begin 
      Result := False; 
      exit; 
    end;
end;

  //********************************************************************//
  // | The preceding routines for testing XML rules were taken from the //
  // | Extended Document Object Model (XDOM) package,                   //
  // | copyright (c) 1999-2002 by Dieter Köhler.                        //
  //********************************************************************//

procedure TGDOMDocument.removeNode(node: xmlNodePtr);
begin
  if node <> nil then FNodeList.Remove(node);
end;

procedure TGDOMNode.transformNode(const stylesheet: IDomNode;
  var output: DomString);
var
  doc:       xmlDocPtr;
  styleDoc:  xmlDocPtr;
  outputDoc: xmlDocPtr;
  styleNode: xmlNodePtr;
  tempXSL:   xsltStylesheetPtr;
  encoding:  widestring;
  length1:   longint;
  CString:   PChar;
  len:       integer;
  meta:      widestring;
  doctype:   integer;
  element:   xmlNodePtr;
begin
  doc := FGNode.doc;
  styleNode := GetGNode(stylesheet);
  styleDoc := styleNode.doc;
  if (styleDoc = nil) or (doc = nil) then exit;
  tempXSL := xsltParseStyleSheetDoc(styleDoc);
  if tempXSL = nil then exit;
  // mark the document as stylesheetdocument;
  // it holds additional information, so a different free method must
  // be used
  (stylesheet.ownerDocument as IDomInternal).set_FtempXSL(tempXSL);
  outputDoc := xsltApplyStylesheet(tempXSL, doc, nil);
  if outputDoc = nil then exit;
  doctype := outputDoc.type_;
  element := xmlDocGetRootElement(outputDoc);
  encoding := outputDoc.encoding;
  xmlDocDumpMemoryEnc(outputDoc, CString, @length1, outputDoc.encoding);
  output := CString;
  // free the document as a string is returned, and not the document
  xmlFreeDoc(outputDoc);
  // if the document is of type plain-text or html
  if (element = nil) or (doctype = 13) then begin
    //cut the leading xml header
    len := pos('>', output) + 2;
    output := copy(output, len, length1 - len);
  end;
  if doctype = 13 //html-document
    then begin
    //insert the meta tag for html output after the head tag
    meta := '<META http-equiv="Content-Type" content="text/html; charset=' +
      encoding + '">';
    len := pos('<head>', output) + 6 - 1;
    output := leftstr(output, len) + meta + rightstr(output, length(output) - len);
  end;
  xmlFree(CString);
end;

procedure TGDOMNode.transformNode(const stylesheet: IDomNode;
  var output: IDomDocument);
var
  doc:       xmlDocPtr;
  styleDoc:  xmlDocPtr;
  outputDoc: xmlDocPtr;
  styleNode: xmlNodePtr;
  tempXSL:   xsltStylesheetPtr;
  impl:      IDomImplementation;
begin
  output := nil;
  doc := FGNode.doc;
  if self.FOwnerDocument<>nil
    then impl:= self.FOwnerDocument.domImplementation
    else impl:= (self as IDomDocument).domImplementation;
  styleNode := GetGNode(stylesheet);
  styleDoc := styleNode.doc;
  if (styleDoc = nil) or (doc = nil) then exit;
  tempXSL := xsltParseStyleSheetDoc(styleDoc);
  if tempXSL = nil then exit;
  // mark the document as stylesheetdocument;
  // it holds additional information, so a different free method must
  // be used
  (stylesheet.ownerDocument as IDomInternal).set_FtempXSL(tempXSL);
  outputDoc := xsltApplyStylesheet(tempXSL, doc, nil);
  if outputDoc = nil then exit;

  //  if outputDoc.type_=13 then begin
  //    xmlFreeDoc(outputDoc);
  //    output:=nil;
  //    exit; //html
  //  end;
  output := TGDOMDocument.Create(impl, xmlNodePtr(outputDoc)) as IDomDocument;
end;

function TGDOMNode.IsSameNode(node: IDomNode): boolean;
var
  xnode1, xnode2: xmlNodePtr;
begin
  Result := True;
  if (self = nil) and (node = nil) then exit;
  Result := False;
  if (self = nil) or (node = nil) then exit;
  xnode1 := GetGNode(self);
  xnode2 := GetGNode(node);
  if xnode1 = xnode2 then Result := True
  else Result := False;
end;

procedure TGDOMDocument.set_FtempXSL(tempXSL: xsltStylesheetPtr);
begin
  FtempXSL := tempXSL;
end;

constructor TGDOMDocument.Create(GDOMImpl: IDomImplementation;
  docnode: xmlNodePtr);
begin
  FGdomimpl := GDOMImpl;
  FPGdomeDoc := xmlDocPtr(docnode);
  FtempXSL := nil;
  FAttrList := TList.Create;
  FNodeList := TList.Create;
  FPrefixList:=TStringList.Create;
  FURIList:=TStringList.Create;
  //Create root-node as pascal object
  inherited Create(docnode, nil);
  (FGDomImpl as IDomDebug).doccount:=(FGdomImpl as IDomDebug).doccount+1;
end;

function TGDOMNode.get_xml: DOMString;
var
  CString: PChar;
  buffer:  xmlBufferPtr;
begin
  buffer := xmlBufferCreate;
  xmlNodeDump(buffer, FGNode.doc, FGNode, 0,0);
  CString := xmlBufferContent(buffer);
  Result := CString;
  xmlFree(CString);
end;

function TGDOMDocument.get_compressionLevel: integer;
begin
  Result := FcompressionLevel;
end;

function TGDOMDocument.get_encoding: DomString;
begin
  Result := Fencoding;
end;

function TGDOMDocument.get_prettyPrint: boolean;
begin
  Result := FprettyPrint;
end;

procedure TGDOMDocument.set_compressionLevel(compressionLevel: integer);
begin
  FcompressionLevel := compressionLevel;
end;

procedure TGDOMDocument.set_encoding(encoding: DomString);
begin
  Fencoding := encoding;
end;

procedure TGDOMDocument.set_prettyPrint(prettyPrint: boolean);
begin
  FprettyPrint := prettyPrint;
end;

function TGDOMDocument.get_parsedEncoding: DomString;
var
  encoding: widestring;
begin
  encoding := FPGdomeDoc.encoding;
  Result := encoding;
end;

procedure InitExportedVar;
  {$ifdef WIN32}
begin
  xmlIndentTreeOutputPtr := GetProcAddress(GetModuleHandle(PChar(LIBXML2_SO)),
    'xmlIndentTreeOutput');
end;
{$else}
begin
  // to do:
  // implement a working solution for linux
{xmlDoValidityCheckingDefaultValue_PTR := dlsym(dlopen(PChar(LIBXML2_SO)),
    'xmlDoValidityCheckingDefaultValue');
  Assert(xmlDoValidityCheckingDefaultValue_PTR <> nil);
  xmlSubstituteEntitiesDefaultValue_PTR := dlsym(dlopen(PChar(LIBXML2_SO)),
    'xmlSubstituteEntitiesDefaultValue');
  Assert(xmlSubstituteEntitiesDefaultValue_PTR <> nil);}
end;
{$endif}

procedure TGDOMDocument.appendNS(prefix, uri: string);
begin
  FPrefixList.Add(prefix);
  FUriList.Add(uri);
end;

function TGDOMDocument.getPrefixList: TStringList;
begin
  result:=FPrefixList;
end;

function TGDOMDocument.getUriList: TStringList;
begin
  result:=FUriList;
end;

function MakeDocument(doc: xmlDocPtr; impl: IDomImplementation): IDomDocument;
begin
   result := TGDOMDocument.Create(impl, xmlNodePtr(doc)) as IDomDocument;
end;

procedure TGDOMImplementation.set_doccount(doccount: integer);
begin
  Fdoccount:=doccount;
end;

function TGDOMImplementation.get_doccount: integer;
begin
  result:=Fdoccount;
end;

initialization
  RegisterDomVendorFactory(TGDOMDocumentBuilderFactory.Create(False));
  InitExportedVar;

finalization
end.
