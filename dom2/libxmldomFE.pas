unit libxmldom;

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
  StrUtils;

const

  SLIBXML = 'LIBXML_4CT';  { Do not localize }

type

  { IXMLDOMNodeRef }

  IXmlDomNodeRef = interface
    ['{7787A532-C8C8-4F3C-9529-29098FE954B0}']
    function GetXmlNodePtr: xmlNodePtr;
  end;


function GetGNode(const Node: IDomNode): xmlNodePtr;
function MakeDocument(doc: xmlDocPtr; impl: IDomImplementation): IDomDocument;


function IsSameNode(node1, node2: IDomNode): boolean;

implementation
{$ifdef WIN32}

uses
  qdialogs;
{$endif}

type
  { TDomImplementation }

  TDomImplementation = class(TInterfacedObject, IDomImplementation,IDomDebug)
  private
    fDoccount: integer;
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

  TDomNodeClass = class of TDomNode;

  TDomNode = class(TInterfacedObject, IDomNode, IXMLDOMNodeRef, IDomNodeSelect,
      IDomNodeExt, IDomNodeCompare)
  private
    fXmlNode: xmlNodePtr;
    fOwnerDocument: IDomDocument;

  protected
    function GetXmlNodePtr: xmlNodePtr; //new
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
    property GNode: xmlNodePtr read fXmlNode;
  end;

  TDomNodeList = class(TInterfacedObject, IDomNodeList)
  private
    fParent: xmlNodePtr;
    fXPathObject: xmlXPathObjectPtr;
    fOwnerDocument: IDomDocument;
    fAdditionalNode: xmlNodePtr;
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

  TDomNamedNodeMap = class(TInterfacedObject, IDomNamedNodeMap)
    // this class is used for attributes, entities and notations
    // created with typ=0: attributes
    //              typ=1: entities
  private
    fOwnerElement: xmlNodePtr;  //for attribute-lists only
    fXmlDTD: xmlDtdPtr;            //for dtd.enties etc
    fXmlDTD2: xmlDtdPtr;           //external dtd
    fOwnerDocument: IDomDocument;
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

  { TDomAttr }

  TDomAttr = class(TDomNode, IDomAttr)
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

  TDomCharacterData = class(TDomNode, IDomCharacterData)
  private
    function GetXmlCharacterData: xmlNodePtr;
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
    property xmlCharacterData: xmlNodePtr read GetXmlCharacterData;
  end;

  { TDomElement }

  TDomElement = class(TDomNode, IDomElement)
  private
    function GetXmlElement: xmlNodePtr;
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
    property xmlElement: xmlNodePtr read GetXmlElement;
  end;

  { TMSDOMText }

  TDomText = class(TDomCharacterData, IDomText)
  protected
    function splitText(offset: integer): IDomText;
  end;

  { TDomComment }

  TDomComment = class(TDomCharacterData, IDomComment)
  end;

  { TDomCDATASection }

  TDomCDATASection = class(TDomText, IDomCDATASection)
  end;

  TDomDocumentType = class(TDomNode, IDomDocumentType)
  private
    fDtd2: xmlDtdPtr;
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

  TDomNotation = class(TDomNode, IDomNotation)
  private
    function GetXmlNotation: xmlNodePtr;
  protected
    { IDomNotation }
    function get_publicId: DOMString;
    function get_systemId: DOMString;
  public
    property xmlNotation: xmlNodePtr read GetXmlNotation;
  end;


  TDomEntity = class(TDomNode, IDomEntity)
  private
    function GetXmlEntity: xmlNodePtr;
  protected
    { IDomEntity }
    function get_publicId: DOMString;
    function get_systemId: DOMString;
    function get_notationName: DOMString;
  public
    property xmlEntity: xmlNodePtr read GetxmlEntity;
  end;

  TDomEntityReference = class(TDomNode, IDomEntityReference)
  end;

  { TDomProcessingInstruction }

  TDomProcessingInstruction = class(TDomNode, IDomProcessingInstruction)
  private
    function GetGProcessingInstruction: xmlNodePtr;
  protected
    { IDomProcessingInstruction }
    function get_target: DOMString;
    function get_data: DOMString;
    procedure set_data(const Value: DOMString);
  public
    property GProcessingInstruction: xmlNodePtr
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

    {managing stylesheets, that must be freed differently}
    procedure set_fTempXSL(tempXSL: xsltStylesheetPtr);
  end;

  TDomDocument = class(TDomNode, IDomDocument, IDomParseOptions, IDomPersist,
      IDomInternal, IDomOutputOptions)
  private
    fDomImpl: IDomImplementation;
    fXmlDocPtr: xmlDocPtr;
    fTempXSL: xsltStylesheetPtr;   //if the document was used as stylesheet,
                                   //this Pointer has to be freed and not
                                   //the xmlDocPtr
    fAsync: boolean;               //for compatibility, not really supported
    fPreserveWhiteSpace: boolean;  //difficult to support (doesn't work the same way
                                   //as MSXML)
    fResolveExternals: boolean;    //difficult to support (possibly not threadsafe)
    fValidate: boolean;            //if true, returns nil on failure
                                   //if false, loads a dtd if it exists
    fAttrList: TList;              //keeps a list of attributes, created on this document
    fNodeList: TList;              //keeps a list of nodes, created on this document
    fCompressionLevel: integer;
    fEncoding: DomString;
    fPrettyPrint: boolean;
    fPrefixList: TStringList; //for xpath
    fURIList: TStringList;    //for xpath
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
    procedure set_fTempXSL(tempXSL: xsltStylesheetPtr);
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

  TDomDocumentFragment = class(TDomNode, IDomDocumentFragment)
  end;

  TDomDocumentBuilderFactory = class(TInterfacedObject, IDomDocumentBuilderFactory)
  private
    fFreeThreading: boolean;

  public
    constructor Create(AFreeThreading: boolean);

    function NewDocumentBuilder: IDomDocumentBuilder;
    function Get_VendorID: DomString;
  end;

  TDomDocumentBuilder = class(TInterfacedObject, IDomDocumentBuilder)
  private
    fFreeThreading: boolean;
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

function setAttr(var node: xmlNodePtr; xmlNewAttr: xmlAttrPtr): xmlAttrPtr; forward;
function removeAttr(element: xmlNodePtr; attr: xmlAttrPtr): xmlAttrPtr; forward;
function removeNs(element: xmlNodePtr; nsdecl: xmlNsPtr): xmlNsPtr; forward;
function IsXmlName(const S: WideString): boolean; forward;
function IsXmlChars(const S: WideString): boolean; forward;
function appendNamespace(element: xmlNodePtr; ns: xmlNsPtr): boolean; forward;
procedure CheckError(err: integer); forward;
function IsReadOnlyNode(node: xmlNodePtr): boolean; forward;
function ErrorString(err: integer): string; forward;

function MakeNode(Node: xmlNodePtr; ADocument: IDomDocument): IDomNode;
const
  NodeClasses: array[ELEMENT_NODE..NOTATION_NODE] of TDomNodeClass =
    (TDomElement, TDomAttr, TDomText, TDomCDataSection,
    TDomEntityReference, TDomEntity, TDomProcessingInstruction,
    TDomComment, TDomDocument, TDomDocumentType, TDomDocumentFragment,
    TDomNotation);
var
  nodeType: integer;
begin
  result:=nil;
  if Node=nil then exit;
  nodeType := Node.type_;
  //change xml_entity_decl to TDomEntity
  if nodeType = 17 then nodeType := 6;
  if nodeType = 13 then nodeType := 9;
  //if nodeType<>13 //html
  Result := NodeClasses[nodeType].Create(Node, ADocument)
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

function UTF8Decode1(s: PChar): WideString;
begin
  if s <> nil then begin
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

function getEncoding(PI:string):string;
//extracts the encoding from the xml header
//todo: more general algorithm
var
  pos1: integer;
begin
  result:='';
  pos1:=pos('encoding',PI);
  if pos1=0 then exit;
  pos1:=pos1+length('encoding')+2;
  result:=trim(copy(PI,pos1,length(PI)-pos1-2));
end;

(*
 *  TXDomDocumentBuilder
*)
constructor TDomDocumentBuilder.Create(AFreeThreading: boolean);
begin
  inherited Create;
  FFreeThreading := AFreeThreading;
end;

destructor TDomDocumentBuilder.Destroy;
begin
  inherited Destroy;
end;

function TDomDocumentBuilder.Get_DomImplementation: IDomImplementation;
begin
  Result := TDomImplementation.Create;
end;

function TDomDocumentBuilder.Get_IsNamespaceAware: boolean;
begin
  Result := True;
end;

function TDomDocumentBuilder.Get_IsValidating: boolean;
begin
  Result := True;
end;

function TDomDocumentBuilder.Get_HasAbsoluteURLSupport: boolean;
begin
  Result := False;
end;

function TDomDocumentBuilder.Get_HasAsyncSupport: boolean;
begin
  Result := False;
end;

function TDomImplementation.hasFeature(const feature, version: DOMString): boolean;
begin
  Result := False;
  if (uppercase(feature) = 'CORE') and
    ((version = '2.0') or (version = '1.0') or (version = '')) then Result := True;
  if (uppercase(feature) = 'XML') and
    ((version = '2.0') or (version = '1.0') or (version = '')) then Result := True;
end;

function TDomImplementation.createDocumentType(const qualifiedName, publicId,
  systemId: DOMString): IDomDocumentType;
var
  dtd:        xmlDtdPtr;
  name1, name2, name3: String;
  alocalName: widestring;
begin
  result:=nil;
  alocalName := localName(qualifiedName);
  if ((Pos(':', alocalName)) > 0) then begin
    checkError(NAMESPACE_ERR);
  end;
  if not IsXmlName(qualifiedName) then checkError(INVALID_CHARACTER_ERR);
  name1 := UTF8Encode(qualifiedName);
  name2 := UTF8Encode(publicId);
  name3 := UTF8Encode(systemId);
  dtd := xmlCreateIntSubSet(nil, pchar(name1), pchar(name2), pchar(name3));
  if dtd <> nil
    then Result := TDomDocumentType.Create(dtd, nil, nil) as IDomDocumentType;
end;

function TDomImplementation.createDocument(const namespaceURI, qualifiedName: DOMString;
  doctype: IDomDocumentType): IDomDocument;
begin
  Result := TDomDocument.Create(self, namespaceURI, qualifiedName,
    doctype) as IDomDocument;
end;

constructor TDomImplementation.Create;
begin
  inherited Create;
end;

destructor TDomImplementation.Destroy;
begin
  inherited Destroy;
end;

  // *************************************************************
  // TDomeNode Implementation
  // *************************************************************

function TDomNode.get_text: DomString;
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

procedure TDomNode.set_text(const Value: DomString);
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

function TDomNode.GetXmlNodePtr: xmlNodePtr;
begin
  Result := fXmlNode;
end;

// IDomNode
function TDomNode.get_nodeName: DOMString;
const
  emptyWString: WideString = '';
begin
  case fXmlNode.type_ of
    XML_HTML_DOCUMENT_NODE,
    //XML_DOCB_DOCUMENT_NODE,
    XML_DOCUMENT_NODE: Result := '#document';
    XML_CDATA_SECTION_NODE: Result := '#cdata-section';
    XML_DOCUMENT_FRAG_NODE: Result := '#document-fragment';
    XML_ENTITY_DECL: Result := '#text';
    XML_TEXT_NODE,
    XML_COMMENT_NODE: Result := emptyWString + '#' + UTF8Decode1(fXmlNode.Name);
    else Result := UTF8Decode1(fXmlNode.Name);
      if (fXmlNode.ns <> nil) and (fXmlNode.ns.prefix <> nil) then begin
        Result := emptyWString + UTF8Decode1(fXmlNode.ns.prefix) + ':' + Result;
      end;
  end;
end;

function TDomNode.get_nodeValue: DOMString;
var
  temp1: PChar;
begin
  if fXmlNode.type_ = ATTRIBUTE_NODE then begin
    if fXmlNode.children <> nil then temp1 := fXmlNode.children.content
    else temp1 := nil;
  end else temp1 := fXmlNode.content;
  Result := UTF8Decode1(temp1);
end;


procedure TDomNode.set_nodeValue(const Value: DOMString);
var
  sValue:   String;
  attr:   xmlAttrPtr;
  buffer: PChar;
  tmp:    xmlNodePtr;
begin
  sValue := UTF8Encode(Value);
  if fXmlNode.type_ = ATTRIBUTE_NODE then begin
    attr := xmlAttrPtr(fXmlNode);
    if attr.children <> nil then xmlFreeNodeList(attr.children);
    attr.children := nil;
    attr.last := nil;
    buffer := xmlEncodeEntitiesReentrant(attr.doc, pchar(sValue));
    attr.children := xmlStringGetNodeList(attr.doc, pchar(sValue));
    tmp := attr.children;
    while tmp <> nil do begin
      tmp.parent := xmlNodePtr(attr);
      tmp.doc := attr.doc;
      if tmp.Next = nil then attr.last := tmp;
      tmp := tmp.Next;
    end;
    xmlFree(buffer);
  end else if (fXmlNode.type_ <> ELEMENT_NODE) and
    (fXmlNode.type_ <> DOCUMENT_NODE) and
    (fXmlNode.type_ <> DOCUMENT_FRAGMENT_NODE) and
    (fXmlNode.type_ <> DOCUMENT_TYPE_NODE) and
    (fXmlNode.type_ <> ENTITY_REFERENCE_NODE) and
    (fXmlNode.type_ <> ENTITY_NODE) and
    (fXmlNode.type_ <> NOTATION_NODE) then xmlNodeSetContent(fXmlNode, pchar(sValue));
end;

function TDomNode.get_nodeType: DOMNodeType;
begin
  Result := domNodeType(fXmlNode.type_);
end;

function TDomNode.get_parentNode: IDomNode;
var 
  node: xmlNodePtr;
begin
  node := fXmlNode.parent;
  if node <> nil then Result := MakeNode(node, fOwnerDocument) as IDomNode
  else Result := nil;
end;

function TDomNode.get_childNodes: IDomNodeList;
var
  Parent: xmlNodePtr;
begin
  Parent := fXmlNode;
  Result := TDomNodeList.Create(Parent, fOwnerDocument) as IDomNodeList;
end;

function TDomNode.get_firstChild: IDomNode;
var 
  node: xmlNodePtr;
begin
  node := fXmlNode.children; //firstChild
  if node <> nil then Result := MakeNode(node, fOwnerDocument) as IDomNode
  else Result := nil;
end;

function TDomNode.get_lastChild: IDomNode;
var 
  node: xmlNodePtr;
begin
  node := fXmlNode.last; //lastChild
  if node <> nil then Result := MakeNode(node, fOwnerDocument) as IDomNode
  else Result := nil;
end;

function TDomNode.get_previousSibling: IDomNode;
var 
  node: xmlNodePtr;
begin
  node := fXmlNode.prev;
  if node <> nil then Result := MakeNode(node, fOwnerDocument) as IDomNode
  else Result := nil;
end;

function TDomNode.get_nextSibling: IDomNode;
var 
  node: xmlNodePtr;
begin
  node := fXmlNode.Next;
  if node <> nil then Result := MakeNode(node, fOwnerDocument) as IDomNode
  else Result := nil;
end;

function TDomNode.get_attributes: IDomNamedNodeMap;
begin
  if fXmlNode.type_ = ELEMENT_NODE then Result :=
      TDomNamedNodeMap.Create(fXmlNode, fOwnerDocument) as IDomNamedNodeMap
  else Result := nil;
end;

function TDomNode.get_ownerDocument: IDomDocument;
begin
  Result := fOwnerDocument
end;

function TDomNode.get_namespaceURI: DOMString;
begin
  Result := '';
  case fXmlNode.type_ of
    XML_ELEMENT_NODE,
    XML_ATTRIBUTE_NODE:
      begin
        if fXmlNode.ns = nil then exit;
        Result := UTF8Decode1(fXmlNode.ns.href);
      end;
  end;
end;

function TDomNode.get_prefix: DOMString;
begin
  Result := '';
  case fXmlNode.type_ of
    XML_ELEMENT_NODE,
    XML_ATTRIBUTE_NODE:
      begin
        if fXmlNode.ns = nil then exit;
        Result := UTF8Decode1(fXmlNode.ns.prefix);
      end;
  end;
end;

function TDomNode.get_localName: DOMString;
begin
  case fXmlNode.type_ of
    XML_HTML_DOCUMENT_NODE,
    //XML_DOCB_DOCUMENT_NODE,
    XML_DOCUMENT_NODE: Result := '#document';
    XML_CDATA_SECTION_NODE: Result := '#cdata-section';
    XML_TEXT_NODE,
    XML_COMMENT_NODE,
    XML_DOCUMENT_FRAG_NODE: Result := '#' + UTF8Decode1(fXmlNode.Name);
    else begin
        Result := UTF8Decode1(fXmlNode.Name);
        // this is neccessary, because according to the dom2
        // specification localName has to be nil for nodes,
        // that don't have a namespace
        if fXmlNode.ns = nil then Result := '';
      end;
  end;
end;

function TDomNode.insertBefore(const newChild, refChild: IDomNode): IDomNode;
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
  if node.doc <> fXmlNode.doc then CheckError(WRONG_DOCUMENT_ERR);
  if (GetGNode(refChild)).parent<>fXmlNode then CheckError(NOT_FOUND_ERR);
  if (newChild <> nil) and (refChild <> nil) then
    node := xmlAddPrevSibling(GetGNode(refChild), GetGNode(newChild))
  else node := nil;
  if node <> nil then Result := newChild
  else Result := nil;
end;

function TDomNode.replaceChild(const newChild, oldChild: IDomNode): IDomNode;
begin
  Result := self.removeChild(oldchild);
  if Result = nil then checkError(NOT_FOUND_ERR);
  self.appendChild(newChild);
end;

function TDomNode.removeChild(const childNode: IDomNode): IDomNode;
var
  node: xmlNodePtr;
begin
  if childNode <> nil then begin
    node := GetGNode(childNode);
    if node.parent <> fXmlNode then checkError(NOT_FOUND_ERR);
    xmlunlinknode(node);
    if node = nil then checkError(NOT_FOUND_ERR);
    node.parent := nil;
    (fOwnerDocument as IDomInternal).appendNode(node);
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
function TDomNode.appendChild(const newChild: IDomNode): IDomNode;
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
  if fXmlNode.type_ = Document_Node then if (newChild.nodeType = Element_Node)
      and (xmlDocGetRootElement(xmlDocPtr(fXmlNode)) <> nil) then
      CheckError(HIERARCHY_REQUEST_ERR);
  if node.doc <> fXmlNode.doc then CheckError(WRONG_DOCUMENT_ERR);
  if self.isAncestorOrSelf(node) then CheckError(HIERARCHY_REQUEST_ERR);
  if IsReadOnlyNode(node.parent) then CheckError(NO_MODIFICATION_ALLOWED_ERR);
  // if the new child is already in the tree, it is first removed
  if node.parent <> nil
    then xmlUnlinkNode(node)
      //if it wasn't already in the tree, then remove it from the list of
      //nodes, that have to be freed
  else begin
    if fOwnerDocument<>nil
      then (fOwnerDocument as IDomInternal).removeNode(node)
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
    if fXmlNode.children <> nil then if fXmlNode.children.last <> nil then
        if fXmlNode.children.last.type_ = XML_TEXT_NODE then if (node.type_ = XML_TEXT_NODE) then
          begin
            (fOwnerDocument as IDomInternal).removeNode((node));
          end;
    if (fXmlNode.type_=Document_Node) and (fXmlNode.children=nil) and (node.type_=XML_PI_NODE) then begin
      PI:=node.content;
      pos1:=pos('encoding',PI)+length('encoding')+2;
      encoding:=trim(copy(PI,pos1,length(PI)-pos1));
      (self as IDomOutputOptions).encoding:=encoding;
      (self as IDomInternal).appendNode(node);
    end else begin
      node := xmlAddChild(fXmlNode, node);
      fXmlNode.children.last := node;
    end;
  end;
  if node <> nil then Result := newChild
  else Result := nil;
end;

function TDomNode.hasChildNodes: boolean;
begin
  if fXmlNode.children <> nil then Result := True
  else Result := False;
end;

function TDomNode.hasAttributes: boolean;
begin
  Result := (fXmlNode.type_ = ELEMENT_NODE) and (get_Attributes.length > 0);
end;

function TDomNode.cloneNode(deep: boolean): IDomNode;
var
  node:      xmlNodePtr;
  recursive: integer;
  ns: xmlNsPtr;
begin
  result:=nil;
  case integer(fXmlNode.type_) of
    XML_ENTITY_NODE, XML_ENTITY_DECL, XML_NOTATION_NODE, XML_DOCUMENT_TYPE_NODE,
    XML_DTD_NODE: CheckError(NOT_SUPPORTED_ERR);
    ATTRIBUTE_NODE:
      begin
        node:=xmlNodePtr(xmlCopyProp(nil,xmlAttrPtr(fXmlNode)));
        if node <> nil then begin
          node.doc := fXmlNode.doc;
          node.ns:=xmlCopyNamespace(fXmlNode.ns);
          if node.parent = nil
            then (fOwnerDocument as IDomInternal).appendAttr(xmlAttrPtr(node));
          Result := MakeNode(node, fOwnerDocument) as IDomNode
        end;
      end;
    XML_DOCUMENT_NODE:
      begin
        if deep
          then recursive := 1
          else recursive := 0;
        node := xmlNodePtr(xmlCopyDoc(xmlDocPtr(fXmlNode), recursive));
        if node <> nil then begin
          node.doc := nil;
          node.ns:=xmlCopyNamespace(fXmlNode.ns);
          Result := MakeDocument(xmlDocPtr(node), fOwnerDocument.domImplementation) as IDomNode
        end;
      end;
  else
      begin
        if deep
          then recursive := 1
          else recursive := 0;
        ns:=fXmlNode.ns; //debug code
        node := xmlCopyNode(fXmlNode, recursive);
        if node <> nil then begin
          ns:=node.ns;   //debug code
          node.doc := fXmlNode.doc;
          node.ns:=xmlCopyNamespace(fXmlNode.ns);
          if node.parent = nil
            then (fOwnerDocument as IDomInternal).appendNode(node);
          Result := MakeNode(node, fOwnerDocument) as IDomNode
        end;
      end;
  end;
end;

procedure TDomNode.normalize;
var
  node, Next, new_next: xmlNodePtr;
  nodeType: integer;
  temp:     string;
begin
  node := fXmlNode.children;
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
        //(fOwnerDocument as IDomInternal).appendNode(next);
        xmlUnlinkNode(Next);
        xmlFreeNode(Next); //carefull!!
        Next := new_next;
      end;
    end else if nodeType = ELEMENT_NODE then begin
    end;
    node := node.Next;
  end;
end;

function TDomNode.IsSupported(const feature, version: DOMString): boolean;
begin
  if (((upperCase(feature) = 'CORE') and (version = '2.0')) or
    (upperCase(feature) = 'XML') and (version = '2.0')) //[pk] ??? what ???
    then Result := True
  else Result := False;
end;

constructor TDomNode.Create(ANode: xmlNodePtr; ADocument: IDomDocument);
begin
  inherited Create;
  Assert(Assigned(ANode));
  fXmlNode := ANode;
  fOwnerDocument := ADocument;
end;

destructor TDomNode.Destroy;
begin
  fOwnerDocument := nil;
  inherited Destroy;
end;

{ TDomNodeList }

constructor TDomNodeList.Create(AParent: xmlNodePtr; ADocument: IDomDocument);
  // create a IDomNodeList from a var of type xmlNodePtr
  // xmlNodePtr is the same as xmlNodePtrList, because in libxml2 there is no
  // difference in the definition of both
begin
  inherited Create;
  FParent := AParent;
  FXpathObject := nil;
  FAdditionalNode := nil;
  fOwnerDocument := ADocument;
end;

procedure TDomNodeList.AddNode(node: xmlNodePtr);
begin
  FAdditionalNode := node;
end;

constructor TDomNodeList.Create(AXpathObject: xmlXPathObjectPtr;
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
  fOwnerDocument := ADocument;
end;

destructor TDomNodeList.Destroy;
begin
  fOwnerDocument := nil;
  if FXPathObject <> nil then xmlXPathFreeObject(FXPathObject);
  inherited Destroy;
end;

function TDomNodeList.get_item(index: integer): IDomNode;
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
  if node <> nil then Result := MakeNode(node, fOwnerDocument) as IDomNode
  else Result := nil;
end;

function TDomNodeList.get_length: integer;
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

{TDomNamedNodeMap}
function TDomNamedNodeMap.get_item(index: integer): IDomNode;
  //same as NodeList.get_item
var
  node: xmlNodePtr;
  ns:   xmlNsPtr;
  i:    integer;
  NsAttr: IDomAttr;
begin
  // not supported for named node map <> attributes yet
  if FOwnerElement=nil then checkError(NOT_SUPPORTED_ERR);
  i := index;
  node := GNamedNodeMap;
  if node<>nil then begin
    while (i > 0) and (node.Next <> nil) do begin
      dec(i);
      node := node.Next
    end;
  end;
  if (node <> nil) and (i=0) then begin
    Result := MakeNode(node, fOwnerDocument) as IDomNode;
  end else begin
    checkError(INDEX_SIZE_ERR);
  end;
end;

function TDomNamedNodeMap.get_length: integer;
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
    if fXmlDTD<>nil then begin
      if fXmlDTD.entities <> nil then begin
        result := xmlHashSize(fXmlDTD.entities);
        //for testing:
        {buff:=xmlBufferCreate();
        xmlDumpEntitiesTable(buff,FGDTD.entities);
        dtdtable:=xmlBufferContent(buff);
        xmlBufferFree(buff);}
      end;
    end;
    if fXmlDTD2<>nil then begin
      if fXmlDTD2.entities <> nil then begin
        result := result + xmlHashSize(fXmlDTD2.entities);
      end;
    end;
  end else begin
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

function TDomNamedNodeMap.getNamedItem(const Name: DOMString): IDomNode;
var
  node:  xmlNodePtr;
begin
  result := nil;
  node := GNamedNodeMap;
  if node=nil then checkError(NOT_SUPPORTED_ERR);
  node := xmlNodePtr(xmlHasProp(FOwnerElement, PChar(UTF8Encode(Name))));
  if node <> nil then begin
    Result := MakeNode(node, fOwnerDocument) as IDomNode;
  end else begin
    Result := nil;
  end;
end;

function TDomNamedNodeMap.setNamedItem(const newItem: IDomNode): IDomNode;
var
  xmlNewAttr, attr: xmlAttrPtr;
  node,node1: xmlNodePtr;
begin
  node := FOwnerElement;
  if node=nil then checkError(NOT_SUPPORTED_ERR);
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
  (fOwnerDocument as IDomInternal).removeAttr(xmlnewAttr);
  FOwnerElement := node;
  if attr <> nil then begin
    (fOwnerDocument as IDomInternal).appendAttr(attr);
    Result := TDomAttr.Create(attr, fOwnerDocument) as IDomNode
  end else Result := nil;
end;

function TDomNamedNodeMap.removeNamedItem(const Name: DOMString): IDomNode;
var
  attr:  xmlAttrPtr;
  sName: String;
begin
  result:= nil;
  attr := nil;
  if FOwnerElement=nil then checkError(NOT_SUPPORTED_ERR);
  sName := UTF8Encode(Name);
  attr := xmlHasProp(FOwnerElement, pchar(sName));
  if attr = nil then begin
    checkError(NOT_FOUND_ERR);
  end;
  attr := removeAttr(FOwnerElement, attr);
  (fOwnerDocument as IDomInternal).appendAttr(attr);
  if attr <> nil
    then Result := MakeNode(xmlNodePtr(attr), fOwnerDocument) as IDomNode;
end;

function TDomNamedNodeMap.getNamedItemNS(const namespaceURI,
  localName: DOMString): IDomNode;
var
  node:         xmlNodePtr;
  name1, name2: string;
  NSAttr: IDOMAttr;
  ns: xmlNsPtr;
begin
  result := nil;
  node := GNamedNodeMap;
  if node=nil then exit;
  name1 := UTF8Encode(namespaceURI);
  name2 := UTF8Encode(localName);
  node := xmlNodePtr(xmlHasNSProp(FOwnerElement, PChar(name2), PChar(name1)));
  if node <> nil then result := MakeNode(node, fOwnerDocument) as IDomNode;
end;

function TDomNamedNodeMap.setNamedItemNS(const newItem: IDomNode): IDomNode;
var
  attr, oldattr, xmlnewAttr: xmlAttrPtr;
  temp, slocalName: string;
  ns:        xmlNSPtr;
  namespace: PChar;
  newAttr:   IDomAttr;
  node,node1: xmlNodePtr;
begin
  node := FOwnerElement;
  if node=nil then checkError(NOT_SUPPORTED_ERR);
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
        {if namespace <> 'http://www.w3.org/2000/xmlns/' then begin
          ns := xmlCopyNamespace(xmlnewAttr.ns);
          appendNamespace(node, ns);
        end;}
      end;
    end;
    // already an attribute with this name?
    attr := node.properties;                                   // if not, then oldattr=nil
    if attr = oldattr then begin
      node.properties := xmlNewAttr;
    end else begin
      while attr.Next <> oldattr do begin
        attr := attr.Next
      end;
      attr.Next := xmlNewAttr;
    end;
    (fOwnerDocument as IDomInternal).removeAttr(xmlnewAttr);
    if oldattr <> nil then begin
      temp := oldattr.Name;
      Result := TDomAttr.Create(oldattr, fOwnerDocument) as IDomAttr;
      oldattr.parent := nil;
      (fOwnerDocument as IDomInternal).appendAttr(oldattr);
    end else begin
      Result := nil;
    end;
  end;
end;

function TDomNamedNodeMap.removeNamedItemNS(const namespaceURI,
  localName: DOMString): IDomNode;
var
  attr: xmlAttrPtr;
  name1, name2: string;
  ns: xmlNsPtr;
  NsAttr: IDOMAttr;
begin
  result := nil;
  if FOwnerElement = nil then exit;
  name1 := UTF8Encode(namespaceURI);
  name2 := UTF8Encode(localName);
  attr := (xmlHasNsProp(FOwnerElement, PChar(name2), PChar(name1)));
  if attr = nil then checkError(NOT_FOUND_ERR);
  attr := removeAttr(FOwnerElement, attr);
  (fOwnerDocument as IDomInternal).appendAttr(attr);
  if attr <> nil then result := MakeNode(xmlNodePtr(attr), fOwnerDocument) as IDomNode;
end;

constructor TDomNamedNodeMap.Create(ANamedNodeMap: xmlNodePtr;
  AOwnerDocument: IDomDocument; typ: integer = 0; dtd2: xmlDtdPtr = nil);
  // ANamedNodeMap=nil for empty NodeMap
begin
  fOwnerDocument := AOwnerDocument;
  if typ = 0 then begin
    fXmlDTD := nil;
    fOwnerElement := ANamedNodeMap;
  end else begin
    fXmlDTD := xmlDtdPtr(ANamedNodeMap);
    fXmlDTD2:=dtd2;
    fOwnerElement := nil;
  end;
  inherited Create;
end;

destructor TDomNamedNodeMap.Destroy;
begin
  fOwnerDocument := nil;
  fOwnerElement := nil;
  fXmlDTD := nil;
  fXmlDTD2:= nil;
  inherited Destroy;
end;

function TDomNamedNodeMap.get_GNamedNodeMap: xmlNodePtr;
begin
  if FOwnerElement <> nil then Result := xmlNodePtr(FOwnerElement.properties)
  else Result := nil;
end;

{ TDomAttr }

function TDomAttr.GetGAttribute: xmlAttrPtr;
begin
  Result := xmlAttrPtr(GNode);
end;

function TDomAttr.get_name: DOMString;
begin
  Result := inherited get_nodeName;
end;

function TDomAttr.get_ownerElement: IDomElement;
begin
  Result := ((self as IDomNode).parentNode) as IDomElement;
end;

function TDomAttr.get_specified: boolean;
begin
  //todo: implement it correctly
  Result := True;
end;

function TDomAttr.get_value: DOMString;
begin
  Result := inherited get_nodeValue;
end;

procedure TDomAttr.set_value(const attributeValue: DOMString);
begin
  inherited set_nodeValue(attributeValue);
end;

constructor TDomAttr.Create(AAttribute: xmlAttrPtr; ADocument: IDomDocument;
  freenode: boolean = False);
begin
  inherited Create(xmlNodePtr(AAttribute), ADocument);
end;

destructor TDomAttr.Destroy;
begin
  inherited Destroy;
end;


  //***************************
  //TDomElement Implementation
  //***************************

function TDomElement.GetXmlElement: xmlNodePtr;
begin
  Result := GNode;
end;
// IDomElement

function TDomElement.get_tagName: DOMString;
begin
  Result := self.get_nodeName;
end;

function TDomElement.getAttribute(const Name: DOMString): DOMString;
var
  sName: String;
  temp1: PChar;
  attr:  xmlAttrPtr;
begin
  sName := UTF8Encode(Name);
  attr := xmlHasProp(xmlElement, pchar(sName));
  if attr <> nil then begin
{ TODO : use libxml2-function instead of children.content }
    if attr.children <> nil
      then temp1 := attr.children.content
      else temp1 := nil;
    Result := UTF8Decode1(temp1);
  end else Result := '';
end;

procedure TDomElement.setAttribute(const Name, Value: DOMString);
var
  sName, sValue: String;
  attr:         xmlAttrPtr;
  node:         xmlNodePtr;
begin
  if not IsXMLName(Name) then checkError(INVALID_CHARACTER_ERR);
  sName := UTF8Encode(Name);
  sValue := UTF8Encode(Value);
  node := xmlElement;
  attr := xmlSetProp(node, pchar(sName), pchar(sValue));
  attr.parent := node;
  attr.doc := node.doc;
end;

procedure TDomElement.removeAttribute(const Name: DOMString);
var
  sName: String;
begin
  sName := UTF8Encode(Name);
  xmlUnsetProp(xmlElement,pchar(sName));
end;

function TDomElement.getAttributeNode(const Name: DOMString): IDomAttr;
var
  temp:  xmlAttrPtr;
  sName: String;
begin
  result:=nil;
  sName := UTF8Encode(Name);
  temp := xmlHasProp(xmlElement, pchar(sName));
  if temp <> nil
    then Result := TDomAttr.Create(temp, fOwnerDocument) as IDomAttr;
end;

function setAttr(var node: xmlNodePtr; xmlNewAttr: xmlAttrPtr): xmlAttrPtr;
var
  attr, oldattr: xmlAttrPtr;
  replace:       boolean;
begin
  Result := nil;
  if node = nil then exit;
  if xmlNewAttr = nil then exit;
  xmlnewAttr.last := nil;
  oldattr := xmlHasProp(node, xmlNewattr.Name);
  // already an attribute with this name?
  if oldattr <> nil
    then replace := True
    else replace := False;
  attr := node.properties;                         // get the old attr-list
  if (attr = nil) then begin                       // if it is empty or its an attribute with the same name
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

procedure copyNsDecl(doc: xmlDocPtr);
// copies the namespace declarations of all elements
// to the attributes list of all elements
var
  node: xmlNodePtr;
  ns:   xmlNsPtr;
  prefix: pchar;
  namespaceURI: pchar;
  attr: xmlAttrPtr;
  sName,sValue: string;
begin
  node:=xmlDocGetRootElement(doc);
  ns:=node.nsDef;
  while ns<>nil do begin
    prefix:=ns.prefix;
    namespaceURI:=ns.href;
    sName:='xmlns:'+prefix;
    sValue:=namespaceURI;
    attr := xmlSetProp(node, pchar(sName), pchar(sValue));
    attr.parent := node;
    attr.doc := node.doc;
    ns:=ns.next;
  end;
end;

procedure removeNsDecl(doc: xmlDocPtr);
// removes the namespace declaration attributes of all elements
// of their attributes lists, if already on the nsdecl list
var
  node: xmlNodePtr;
  ns:   xmlNsPtr;
  prefix: pchar;
  namespaceURI: pchar;
  attr: xmlAttrPtr;
  sName,sValue: string;
begin
  node:=xmlDocGetRootElement(doc);
  ns:=node.nsDef;
  while ns<>nil do begin
    prefix:=ns.prefix;
    namespaceURI:=ns.href;
    sName:='xmlns:'+prefix;
    sValue:=namespaceURI;
    attr := xmlHasProp(node, pchar(sName));
    removeAttr(node,attr);
    xmlFreeProp(attr);
    ns:=ns.next;
  end;
end;

function TDomElement.setAttributeNode(const newAttr: IDomAttr): IDomAttr;
var
  xmlnewAttr, oldattr: xmlAttrPtr;
  temp: string;
  node: xmlNodePtr;
  ns: xmlNsPtr;
begin
  if newAttr <> nil then begin
    xmlnewAttr := xmlAttrPtr(GetGNode(newAttr));     // Get the libxml2-Attribute
    node := xmlElement;
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
      (fOwnerDocument as IDomInternal).removeAttr(xmlnewAttr);
      if oldattr <> nil then begin
        temp := oldattr.Name;
        oldattr.parent := nil;
        Result := TDomAttr.Create(oldattr, fOwnerDocument) as IDomAttr;
        (fOwnerDocument as IDomInternal).appendAttr(oldattr);
      end else begin
        Result := nil;
      end;
    end;
  end;
end;

function TDomElement.removeAttributeNode(const oldAttr: IDomAttr): IDomAttr;
var
  attr, xmlnewAttr, oldattr1: xmlAttrPtr;
  node: xmlNodePtr;
begin
  if oldAttr <> nil then begin
    xmlnewAttr := xmlAttrPtr(GetGNode(oldAttr));     // Get the libxml2-Attribute
    node := xmlElement;
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
        (fOwnerDocument as IDomInternal).appendAttr(xmlNewattr);
      end else begin
        Result := nil;
      end;
    end else begin
      checkError(NOT_FOUND_ERR)
    end;
  end else Result := nil;
end;

function TDomElement.getElementsByTagName(const Name: DOMString): IDomNodeList;
begin
  Result := selectNodes('.//'+Name);
end;

function TDomElement.getAttributeNS(const namespaceURI, localName: DOMString): DOMString;
var
  sNamespaceURI,sLocalName: string;
  attr:         xmlAttrPtr;
  temp1:        PChar;
begin
  result:='';
  sNamespaceURI:=UTF8Encode(namespaceURI);
  sLocalName:=UTF8Encode(localName);
  attr := xmlHasNSProp(xmlElement, pchar(sLocalName), pchar(sNamespaceURI));
  if attr <> nil then begin
    if attr.children <> nil
{ TODO : use libxml2-function instead of children.content }
      then temp1 := attr.children.content
      else temp1 := nil;
    Result := UTF8Decode1(temp1);
  end;
end;

procedure TDomElement.setAttributeNS(const namespaceURI, qualifiedName, Value: DOMString);
var
  ns: xmlNsPtr;
  sValue: string;
  wLocalName: WideString;
  sLocalName,sPrefix,sNamespaceURI: string;
  node: xmlNodePtr;
begin
  wLocalName    := localName(qualifiedName);
  sLocalName    := UTF8Encode(wLocalName);
  sPrefix       := UTF8Encode(prefix(qualifiedName));
  sNamespaceURI := UTF8Encode(namespaceURI);
  if (prefix(qualifiedName) = 'xml') and (namespaceURI <>
    'http://www.w3.org/XML/1998/namespace') then checkError(NAMESPACE_ERR);
  if (prefix(qualifiedName) = 'xmlns') and (namespaceURI <>
    'http://www.w3.org/2000/xmlns/') then checkError(NAMESPACE_ERR);
  if ((qualifiedName) = 'xmlns') and (namespaceURI <>
    'http://www.w3.org/2000/xmlns/') then checkError(NAMESPACE_ERR);
  if (((Pos(':', wlocalName)) > 0) or ((length(namespaceURI)) = 0) and
    ((Pos(':', qualifiedName)) > 0)) then checkError(NAMESPACE_ERR);
  if qualifiedName <> '' then if not IsXmlName(qualifiedName) then
      checkError(INVALID_CHARACTER_ERR);
  sValue := UTF8Encode(Value);
  node := xmlElement;
  if namespaceURI<>''then begin
    ns := xmlNewNs(nil,PChar(sNamespaceURI),PChar(sPrefix));
    xmlSetNSProp(xmlElement, ns, PChar(sLocalName), PChar(sValue));
  end else begin
    xmlSetProp(xmlElement, PChar(UTF8Encode(qualifiedName)), PChar(sValue));
  end;
end;

procedure TDomElement.removeAttributeNS(const namespaceURI, localName: DOMString);
var
  attr:         xmlAttrPtr;
  sLocalName, sNamespaceURI: string;
begin
  sLocalName := UTF8Encode(localName);
  sNamespaceURI := UTF8Encode(namespaceURI);
  attr := xmlHasNSProp(xmlElement, PChar(sLocalName), PChar(sNamespaceURI));
  if attr <> nil then begin
    xmlRemoveProp(attr);
  end;
end;

function TDomElement.getAttributeNodeNS(const namespaceURI,
  localName: DOMString): IDomAttr;
var
  temp:          xmlAttrPtr;
  sNamespaceURI,
  sLocalName:    string;
begin
  result:=nil;
  sNamespaceURI := UTF8Encode(namespaceURI);
  sLocalName    := UTF8Encode(localName);
  temp := xmlHasNSProp(xmlElement, pchar(sLocalName), pchar(sNamespaceURI));
  if temp <> nil
    then Result := TDomAttr.Create(temp, fOwnerDocument) as IDomAttr;
end;

function TDomElement.setAttributeNodeNS(const newAttr: IDomAttr): IDomAttr;
var
  attr, xmlnewAttr, oldattr: xmlAttrPtr;
  temp:       string;
  node:       xmlNodePtr;
  namespace:  PChar;
  sLocalname: string;
  ns:xmlNsPtr;
begin
  result:=nil;
  if newAttr=nil then exit;
  xmlnewAttr := xmlAttrPtr(GetGNode(newAttr));    // Get the libxml2-Attribute
  node := xmlElement;
  if xmlnewAttr.doc<>node.doc
    then checkError(WRONG_DOCUMENT_ERR);
  if xmlnewAttr.parent<>nil
    then checkError(INUSE_ATTRIBUTE_ERR);
  xmlnewAttr.parent := node;
  sLocalName := UTF8Encode(newAttr.localName);
  if xmlnewAttr.ns <> nil then begin
    namespace := xmlnewAttr.ns.href;
    if (xmlnewAttr.ns.prefix <> 'xmlns') and (xmlnewAttr.name <> 'xmlns') then begin
      appendNamespace(node, xmlnewAttr.ns);
    end;
  end else namespace := '';
  oldattr := xmlHasNSProp(node, PChar(sLocalName), namespace);
  // already an attribute with this name?
  attr := node.properties;                                   // if not, then oldattr=nil
  if attr = oldattr then node.properties := xmlNewAttr
  else begin
    while attr.Next <> oldattr do begin
      attr := attr.Next
    end;
    attr.Next := xmlNewAttr;
  end;
  (fOwnerDocument as IDomInternal).removeAttr(xmlnewAttr);
  if oldattr <> nil then begin
    temp := oldattr.Name;
    Result := TDomAttr.Create(oldattr, fOwnerDocument) as IDomAttr;
    oldattr.parent := nil;
    (fOwnerDocument as IDomInternal).appendAttr(oldattr);
  end else begin
    Result := nil;
  end;
end;

function appendNamespace(element: xmlNodePtr; ns: xmlNsPtr): boolean;
var
  tmp, last: xmlNsPtr;
begin
  Result := False;
  last := nil;
  if element.type_ <> Element_Node then exit;
  // do not append namespace declaration if it already exists
  tmp := element.nsDef;
  while tmp <> nil do begin
    if xmlStrCmp(tmp.prefix,ns.prefix) = 0 then begin
      if xmlStrCmp(tmp.href,ns.href) = 0 then begin
        result := True;
      end else begin
        result := False;
      end;
      Exit;
    end;
    tmp := tmp.next;
  end;
  // namespace declaration does not exist - append it
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

function removeNs(element: xmlNodePtr; nsdecl: xmlNsPtr): xmlNsPtr;
  // removes an namespace declaration from an element and returns the removed
  // namespace declaration
var
  tmp, last: xmlNsPtr;
begin
  result := nil;
  last := nil;
  if element.type_ <> Element_Node then exit;
  if element.nsDef = nil then exit;
  tmp := element.nsDef;
  while tmp <> nil do begin
    if tmp = nsdecl then begin
      result := nsdecl;
      if tmp.Next <> nil then begin
         if last <> nil then begin
           last.Next := tmp.Next;
         end else begin
           element.nsDef := tmp.Next;
         end;
      end else begin
        if last <> nil then begin
          last.Next := nil;
        end else begin
          element.nsDef := nil;
        end;
      end;
      result.Next := nil;
      Break;
    end;
    last := tmp;
    tmp := tmp.Next;
  end;
end;


function TDomElement.getElementsByTagNameNS(const namespaceURI,
  localName: DOMString): IDomNodeList;
begin
  if namespaceURI = '*' then begin
    // what is meant by namespaceURI = * ?
    // a) a namespace exists
    // b) namespace does not matter
    // case b) is currently implemented
    if localName <> '*' then begin
      result := selectNodes('.//*[local-name() = "'+localName+'"]');
    end else begin
      result := selectNodes('.//*');
    end;
  end else begin
    if localName <> '*' then begin
      result := selectNodes('.//*[(namespace-uri() = "'+namespaceURI+'") and (local-name() = "'+localName+'")]');
    end else begin
      result := selectNodes('.//*[namespace-uri() = "'+namespaceURI+'"]');
    end;
  end;
end;

function TDomElement.hasAttribute(const Name: DOMString): boolean;
begin
  if xmlHasProp(xmlElement, pchar(UTF8Encode(name))) <> nil
    then Result := True
    else Result := False;
end;

function TDomElement.hasAttributeNS(const namespaceURI, localName: DOMString): boolean;
var
  sNamespaceURI,
  sLocalName:   string;
  node:         xmlNodePtr;
begin
  sNamespaceURI := UTF8Encode(namespaceURI);
  sLocalName    := UTF8Encode(localName);
  if (xmlHasNSProp(xmlElement, pchar(sLocalName),
    pchar(sNamespaceURI))) <> nil
    then Result := True
    else Result := False;
end;

procedure TDomElement.normalize;
begin
  inherited normalize;
end;

constructor TDomElement.Create(AElement: xmlNodePtr; ADocument: IDomDocument;
  freenode: boolean = False);
begin
  inherited Create(xmlNodePtr(AElement), ADocument);
end;

destructor TDomElement.Destroy;
begin
  inherited Destroy;
end;


  //************************************************************************
  // functions of TDomDocument
  //************************************************************************

constructor TDomDocument.Create(GDOMImpl: IDomImplementation;
  const namespaceURI, qualifiedName: DOMString;
  doctype: IDomDocumentType);
var
  root:       xmlNodePtr;
  ns:         xmlNsPtr;
  wLocalName: widestring;
begin
  fDomImpl := GDOMImpl;
  if doctype <> nil then if doctype.ownerDocument <> nil then
      if (doctype.ownerDocument as IUnknown) <> (self as IUnknown) then
        checkError(WRONG_DOCUMENT_ERR);
  wLocalName := localName(qualifiedName);
  if (qualifiedName = '') and (namespaceURI <> '') then checkError(NAMESPACE_ERR);
  if (prefix(qualifiedName) = 'xml') and (namespaceURI <>
    'http://www.w3.org/XML/1998/namespace') then checkError(NAMESPACE_ERR);
  if (((Pos(':', wLocalName)) > 0) or ((length(namespaceURI)) = 0) and
    ((Pos(':', qualifiedName)) > 0)) then checkError(NAMESPACE_ERR);
  if qualifiedName <> '' then if not IsXmlName(qualifiedName) then
      checkError(INVALID_CHARACTER_ERR);
  ns:=nil;
  if namespaceUri<>''
    then ns := xmlNewNs(nil,pchar(UTF8Encode(namespaceURI)),pchar(UTF8Encode(prefix(qualifiedName))));
  fXmlDocPtr := xmlNewDoc(nil);
  if (namespaceUri<>'') and (length(wLocalName)>0)
    then fXmlDocPtr.children := xmlNewDocNode(fXmlDocPtr, ns, pchar(UTF8Encode(wLocalName)), nil);
  if (namespaceUri='') and (length(wLocalName)>0)
    then fXmlDocPtr.children:=xmlNewDocNode(fXmlDocPtr,nil,pchar(UTF8Encode(wlocalName)),nil);
  if namespaceUri<>''
    then begin
      fXmlDocPtr.children.nsDef := ns;
    end;
  //Get root-node
  root := xmlNodePtr(fXmlDocPtr);
  FAttrList := TList.Create;
  FNodeList := TList.Create;
  FPrefixList:=TStringList.Create;
  FUriList:=TStringList.Create;
  FtempXSL := nil;
  //Create root-node as pascal object
  inherited Create(root, nil);
  (fDomImpl as IDomDebug).doccount:=(fDomImpl as IDomDebug).doccount+1;
end;

destructor TDomDocument.Destroy;
var
  i:     integer;
  AAttr: xmlAttrPtr;
  ANode: xmlNodePtr;
begin
  if fXmlDocPtr <> nil then begin
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
    if FtempXSL = nil then xmlFreeDoc(fXmlDocPtr)
    else begin
      xsltFreeStylesheet(FtempXSL);
    end;
    (fDomImpl as IDomDebug).doccount:=(fDomImpl as IDomDebug).doccount-1;
    FAttrList.Free;
    FNodeList.Free;
    if FPrefixList<>nil then FPrefixList.Free;
    if FUriList<>nil then FURIList.Free;
  end;
  inherited Destroy;
end;

// IDomDocument
function TDomDocument.get_doctype: IDomDocumentType;
var 
  dtd1, dtd2: xmlDtdPtr;
begin
  dtd1 := fXmlDocPtr.intSubset;
  dtd2 := fXmlDocPtr.extSubset;
  if (dtd1 <> nil) or (dtd2 <> nil) then Result :=
      TDomDocumentType.Create(dtd1, dtd2, self)
  else Result := nil;
end;

function TDomDocument.get_domImplementation: IDomImplementation;
begin
  Result := fDomImpl;
end;

function TDomDocument.get_documentElement: IDomElement;
var
  root1:  xmlNodePtr;
  FGRoot: TDomElement;
begin
  root1 := xmlDocGetRootElement(fXmlDocPtr);
  if root1 <> nil then FGRoot := TDomElement.Create(root1, self)
  else FGRoot := nil;
  Result := FGRoot;
end;

procedure TDomDocument.set_documentElement(const IDomElement: IDomElement);
begin
  checkError(NOT_SUPPORTED_ERR);
end;

function TDomDocument.createElement(const tagName: DOMString): IDomElement;
var
  sTagName: string;
  AElement: xmlNodePtr;
begin
  result:=nil;
  if not IsXMLName(tagName) then checkError(INVALID_CHARACTER_ERR);
  sTagName := UTF8Encode(tagName);
  AElement := xmlNewDocNode(fXmlDocPtr, nil, pchar(sTagName), nil);
  if AElement <> nil then begin
    AElement.parent := nil;
    fNodeList.Add(AElement);
    Result := TDomElement.Create(AElement, self)
  end;
end;

function TDomDocument.createDocumentFragment: IDomDocumentFragment;
var
  node: xmlNodePtr;
begin
  node := xmlNewDocFragment(fXmlDocPtr);
  if node <> nil then begin
    fNodeList.Add(node);
    result := TDomDocumentFragment.Create(node, self)
  end else Result := nil;
end;

function TDomDocument.createTextNode(const Data: DOMString): IDomText;
var
  sData:    string;
  textNode: xmlNodePtr;
begin
  result:=nil;
  sData := UTF8Encode(Data);
  textNode := xmlNewDocText(fXmlDocPtr, pchar(sData));
  if textNode <> nil then begin
    fNodeList.Add(textNode);
    result := TDomText.Create(textNode, self)
  end;
end;

function TDomDocument.createComment(const Data: DOMString): IDomComment;
var
  sData: string;
  node:  xmlNodePtr;
begin
  result:=nil;
  sData := UTF8Encode(Data);
  node := xmlNewDocComment(fXmlDocPtr, pchar(sData));
  if node <> nil then begin
    fNodeList.Add(node);
    result := TDomComment.Create((node), self)
  end;
end;

function TDomDocument.createCDATASection(const Data: DOMString): IDomCDATASection;
var
  sData: string;
  node:  xmlNodePtr;
begin
  result:=nil;
  sData := UTF8Encode(Data);
  node := xmlNewCDataBlock(fXmlDocPtr, pchar(sData), length(sData));
  if node <> nil then begin
    FNodeList.Add(node);
    Result := TDomCDataSection.Create(node, self, False)
  end;
end;

function TDomDocument.createProcessingInstruction(const target,
  Data: DOMString): IDomProcessingInstruction;
var
  sTarget,sData: string;
  AProcessingInstruction: xmlNodePtr;
begin
  result:=nil;
  if not IsXMLChars(target) then CheckError(INVALID_CHARACTER_ERR);
  sTarget := UTF8Encode(target);
  sData   := UTF8Encode(Data);
  AProcessingInstruction := xmlNewPI(pchar(sTarget), pchar(sData));
  if AProcessingInstruction <> nil then begin
    AProcessingInstruction.parent := nil;
    AProcessingInstruction.doc := fXmlDocPtr;
    FNodeList.Add(AProcessingInstruction);
    Result := TDomProcessingInstruction.Create(AProcessingInstruction, self)
  end;
end;

function TDomDocument.createAttribute(const Name: DOMString): IDomAttr;
var
  sName: string;
  AAttr: xmlAttrPtr;
begin
  result:=nil;
  if not IsXMLName(Name) then checkError(INVALID_CHARACTER_ERR);
  sName := UTF8Encode(Name);
  AAttr := xmlNewDocProp(fXmlDocPtr, pchar(sName), nil);
  AAttr.parent := nil;
  if AAttr <> nil then begin
    FAttrList.Add(AAttr);
    Result := TDomAttr.Create(AAttr, self)
  end;
end;

function TDomDocument.createEntityReference(const Name: DOMString): IDomEntityReference;
var
  sName: string;
  AEntityReference: xmlNodePtr;
begin
  result:=nil;
  if not IsXMLName(Name) then checkError(INVALID_CHARACTER_ERR);
  sName:=UTF8Encode(Name);
  AEntityReference := xmlNewReference(fXmlDocPtr, pchar(sName));
  if AEntityReference <> nil then begin
    FNodeList.Add(AEntityReference);
    Result := TDomEntityReference.Create(AEntityReference, self)
  end;
end;

function TDomDocument.getElementsByTagName(const tagName: DOMString): IDomNodeList;
begin
  result := (self.get_documentElement as IDomNodeSelect).selectNodes('//' + tagName);
end;

function TDomDocument.importNode(importedNode: IDomNode; deep: boolean): IDomNode;
var
  recurse:            integer;
  node,node1,root:    xmlNodePtr;
  attr:               xmlAttrPtr;
begin
  Result := nil;
  if importedNode = nil then exit;
  node1:=GetGNode(importedNode);
  case integer(importedNode.nodeType) of
    DOCUMENT_NODE, DOCUMENT_TYPE_NODE, NOTATION_NODE, ENTITY_NODE: CheckError(NOT_SUPPORTED_ERR);
    ATTRIBUTE_NODE:
      begin
        root := xmlDocGetRootElement(fXmlDocPtr);
        attr:=xmlCopyProp(root,xmlAttrPtr(node1));
        if attr <>nil then begin
          attr.parent:=nil;
          attr.doc:=fXmlDocPtr;
          attr.ns:=xmlCopyNamespace(node1.ns);
          appendAttr(attr);
          result:=MakeNode(xmlNodePtr(attr),self);
        end;
      end;
    else if deep then recurse := 1
      else recurse := 0;
        node := xmlDocCopyNode(node1, fXmlDocPtr, recurse);
        node.doc:=fXmlDocPtr;
        node.ns:=xmlCopyNamespace(node1.ns);
        if node <> nil
          then Result := MakeNode(node, self);
  end;
end;

function TDomDocument.createElementNS(const namespaceURI,
  qualifiedName: DOMString): IDomElement;
var
  AElement:     xmlNodePtr;
  ns,ns1:       xmlNsPtr;
  wlocalName:   widestring;
  sLocalName,
  sNamespaceUri,
  temp,
  sPrefix:      string;
begin
  sPrefix       :=UTF8Encode(prefix(qualifiedName));
  wlocalName    := localName(qualifiedName);
  sLocalName    :=UTF8Encode(wLocalName);
  sNamespaceURI :=UTF8Encode(namespaceURI);
  if (sPrefix = 'xml') and (namespaceURI <>
    'http://www.w3.org/XML/1998/namespace') then checkError(NAMESPACE_ERR);
  if (((Pos(':', wLocalName)) > 0) or ((length(namespaceURI)) = 0) and
    ((Pos(':', qualifiedName)) > 0)) then checkError(NAMESPACE_ERR);
  if qualifiedName <> '' then if not IsXmlName(qualifiedName) then
      checkError(INVALID_CHARACTER_ERR);
  if namespaceURI<>'' then begin
    ns := xmlNewNs(nil,PChar(sNamespaceURI),PChar(sPrefix));
    AElement := xmlNewDocNode(fXmlDocPtr, ns, pchar(sLocalName), nil);
    temp := AElement.ns.href;
    temp := AElement.ns.prefix;
    AElement.nsdef := ns;
    ns1:=AElement.nsDef;
  end else begin
    AElement := xmlNewDocNode(fXmlDocPtr, nil, pchar(UTF8Encode(qualifiedName)), nil);
  end;
  if AElement <> nil then begin
    AElement.parent := nil;
    FNodeList.Add(AElement);
    Result := TDomElement.Create(AElement, self)
  end else Result := nil;
end;

function TDomDocument.createAttributeNS(const namespaceURI,
  qualifiedName: DOMString): IDomAttr;
var
  AAttr:         xmlAttrPtr;
  ns:            xmlNsPtr;
  wlocalName:    widestring;
  sPrefix,
  sLocalName,
  sNamespaceURI: string;
begin
  result:=nil;
  sPrefix       := UTF8Encode(prefix(qualifiedName));
  sNamespaceURI := UTF8Encode(namespaceURI);
  wlocalName    := localName(qualifiedName);
  sLocalName    := UTF8Encode(wlocalName);
  if (sPrefix = 'xml') and (namespaceURI <>
    'http://www.w3.org/XML/1998/namespace') then checkError(NAMESPACE_ERR);
  if ((qualifiedName = 'xmlns') or (prefix(qualifiedName) = 'xmlns'))
    and (namespaceURI <> 'http://www.w3.org/2000/xmlns/') then checkError(NAMESPACE_ERR);
  if (((Pos(':', wlocalName)) > 0) or ((length(namespaceURI)) = 0) and
    ((Pos(':', qualifiedName)) > 0)) then checkError(NAMESPACE_ERR);
  if qualifiedName <> '' then if not IsXmlName(qualifiedName) then
      checkError(INVALID_CHARACTER_ERR);
  ns := xmlNewNs(nil,PChar(sNamespaceURI),PChar(sPrefix));
  AAttr := xmlNewNsProp(nil, ns, pchar(sLocalName), nil);
  AAttr.doc:=self.fXmlDocPtr;
  if AAttr <> nil then begin
    FAttrList.Add(AAttr);
    Result := TDomAttr.Create(AAttr, self)
  end;
end;

function TDomDocument.getElementsByTagNameNS(const namespaceURI,
  localName: DOMString): IDomNodeList;
var
  docElement: IDomElement;
  tmp1:       IDomNodeList;
begin
  if (namespaceURI = '*') then begin
    if (localname <> '*') then begin
      docElement := self.get_documentElement;
      tmp1 := (docElement as IDomNodeSelect).selectNodes('//*[local-name()="' +
        localname + '"]');
      Result := tmp1;
    end else begin
      docElement := self.get_documentElement;
      tmp1 := (docElement as IDomNodeSelect).selectNodes('//*');
      Result := tmp1;
    end
  end else begin
    docElement := self.get_documentElement;
    tmp1 := (docElement as IDomNodeSelect).selectNodes('//*[(local-name() = "'+
      localname+'") and (namespace-uri() = "'+namespaceURI+'")]');
    Result := tmp1;
  end;
end;

function TDomDocument.getElementById(const elementId: DOMString): IDomElement;
var
  AAttr:    xmlAttrPtr;
  AElement: xmlNodePtr;
  sElementId:    string;
begin
  result:=nil;
  sElementId := UTF8Encode(elementID);
  AAttr := xmlGetID(fXmlDocPtr, pchar(sElementId));
  if AAttr <> nil
    then AElement := AAttr.parent
    else AElement := nil;
  if AElement <> nil
    then Result := TDomElement.Create(AElement, self);
end;

// IDomParseOptions
function TDomDocument.get_async: boolean;
begin
  Result := fAsync;
end;

function TDomDocument.get_preserveWhiteSpace: boolean;
begin
  Result := fPreserveWhiteSpace;
end;

function TDomDocument.get_resolveExternals: boolean;
begin
  Result := fResolveExternals;
end;

function TDomDocument.get_validate: boolean;
begin
  Result := fValidate;
end;

procedure TDomDocument.set_async(Value: boolean);
begin
  fAsync := True;
end;

procedure TDomDocument.set_preserveWhiteSpace(Value: boolean);
begin
  fPreserveWhiteSpace := Value;
  if Value then xmlKeepBlanksDefault(1)
  else xmlKeepBlanksDefault(0);
end;

procedure TDomDocument.set_resolveExternals(Value: boolean);
begin
  if Value
    then xmlSubstituteEntitiesDefault(1)
    else xmlSubstituteEntitiesDefault(0);
  fResolveExternals := Value;
end;

procedure TDomDocument.set_validate(Value: boolean);
begin
  fValidate := Value;
end;

// IDomPersist
function TDomDocument.get_xml: DOMString;
var
  CString, encoding: PChar;
  length: longint;
  temp:   string;
  format: integer;
begin
  result:='';
  temp := fEncoding;
  if fEncoding = ''
    then encoding := fXmlDocPtr.encoding
    else encoding := PChar(temp);
  // if the xml document doesn't have an encoding or a documentElement,
  // return an empty string (it works like this in msdom)
  if (fXmlDocPtr.children<>nil) or (encoding<>'')
    then begin
      format := 0;
      if fPrettyPrint then begin
        format := -1;
      end;
      {$ifdef new}
      removeNsDecl(fXmlDocPtr);
      {$endif}
      xmlDocDumpFormatMemoryEnc(fXmlDocPtr, CString, @length, encoding, format);
      {$ifdef new}
      copyNsDecl(fXmlDocPtr);
      {$endif}
      if encoding<>'utf8'
        then Result := CString
        else Result := UTF8Decode1(CString);
      xmlFree(CString);  //this works with the new dll from 2001-01-25
    end;
end;

function TDomDocument.asyncLoadState: integer;
begin
  Result := 0;
end;

function TDomDocument.load(Source: DOMString): boolean;
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
        xmlFreeDoc(fXmlDocPtr);
        inherited Destroy;
        fXmlDocPtr := ctxt.myDoc;
        Result := True;
      end else begin
        xmlFreeDoc(ctxt.myDoc);
        ctxt.myDoc := nil;
        Result := False;
      end;
    xmlFreeParserCtxt(ctxt);
  end;
  if Result then begin
    root := xmlNodePtr(fXmlDocPtr);
    inherited Create(root, nil);
  end else Result := False;
end;

function TDomDocument.loadFromStream(const stream: TStream): boolean;
begin
  checkError(NOT_SUPPORTED_ERR);
  Result := False;
end;

function TDomDocument.loadxml(const Value: DOMString): boolean;
  // Load dom from string;
var
  root: xmlNodePtr;
  ctxt: xmlParserCtxtPtr;
  pxml: string;
  header,encoding: string;
begin
  Result := False;
  xmlInitParser();
  header:=leftstr(Value,pos('>',value));
  encoding:=getEncoding(header);
  fEncoding:=encoding;
  if (encoding<>'utf8') and (encoding<>'utf16') then begin
    pxml := Value + #0;
    ctxt := xmlCreateDocParserCtxt(@pxml[1]);
  end else begin
    pxml:=UTF8Encode(value);
    ctxt := xmlCreateDocParserCtxt(pchar(pxml));
  end;
  if (ctxt <> nil) then begin
    ctxt.validate := -1;
    //todo: async (separate thread)
    //todo: resolveExternals
    xmlParseDocument(ctxt);
    if (ctxt.wellFormed <> 0) then if not Fvalidate or (ctxt.valid <> 0) then begin
        xmlFreeDoc(fXmlDocPtr);
        inherited Destroy;
        Result := True;
        fXmlDocPtr := ctxt.myDoc
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
  if Result then begin
    {$ifdef new}
    // copy namespace declarations into the list of attributes
    copyNsDecl(fXmlDocPtr);
    {$endif}
    root := xmlNodePtr(fXmlDocPtr);
    inherited Create(root, nil);
  end else Result := False;
end;

procedure TDomDocument.save(Source: DOMString);
var
  encoding:    PChar;
  bytes:       integer;
  temp, temp1: string;
  format:      integer;
begin
  temp := fEncoding;
  if fEncoding = '' then encoding := fXmlDocPtr.encoding
  else encoding := PChar(temp);
  format := 0;
  if fPrettyPrint then begin
    format := -1;
    //xmlIndentTreeOutputPtr^:=-1;
  end;
  temp1 := Source;
  bytes := xmlSaveFormatFileEnc(PChar(temp1), fXmlDocPtr, encoding, format);
  if bytes < 0 then CheckError(22); //write error
end;

procedure TDomDocument.saveToStream(const stream: TStream);
begin
  checkError(NOT_SUPPORTED_ERR);
end;

procedure TDomDocument.set_OnAsyncLoad(const Sender: TObject;
  EventHandler: TAsyncEventHandler);
begin
  checkError(NOT_SUPPORTED_ERR);
end;

function GetGNode(const Node: IDomNode): xmlNodePtr;
begin
  if not Assigned(Node) then checkError(INVALID_ACCESS_ERR);
  Result := (Node as IXMLDOMNodeRef).GetXmlNodePtr;
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


{ TDomCharacterData }

procedure TDomCharacterData.appendData(const Data: DOMString);
var
  sValue: String;
begin
  sValue := UTF8Encode(Data);
  xmlNodeAddContent(GetXmlCharacterData, pchar(sValue));
end;

procedure TDomCharacterData.deleteData(offset, Count: integer);
begin
  replaceData(offset, Count, '');
end;

function TDomCharacterData.get_data: DOMString;
begin
  result := inherited get_nodeValue;
end;

function TDomCharacterData.get_length: integer;
begin
  result := length(get_data);
end;

function TDomCharacterData.GetXmlCharacterData: xmlNodePtr;
begin
  result := GNode;
end;

procedure TDomCharacterData.insertData(offset: integer;
  const Data: DOMString);
begin
  replaceData(offset, 0, Data);
end;

procedure TDomCharacterData.replaceData(offset, Count: integer;
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

procedure TDomCharacterData.set_data(const Data: DOMString);
begin
  inherited set_nodeValue(Data);
end;

function TDomCharacterData.substringData(offset,
  Count: integer): DOMString;
var
  s: widestring;
begin
  if (offset < 0) or (offset > length(s)) or (Count < 0) then checkError(INDEX_SIZE_ERR);
  s := Get_data;
  s := copy(s, offset, Count);
  Result := s
end;

constructor TDomCharacterData.Create(ACharacterData: xmlNodePtr;
  ADocument: IDomDocument; freenode: boolean = False);
begin
  inherited Create(xmlNodePtr(ACharacterData), ADocument);
end;

destructor TDomCharacterData.Destroy;
begin
  inherited Destroy;
end;

{ TDomText }

function TDomText.splitText(offset: integer): IDomText;
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
  tmp := self.fOwnerDocument.createTextNode(s1);
  if self.get_parentNode <> nil then begin
    node := self.get_parentNode;
    if self.get_nextSibling = nil then node.appendChild(tmp)
    else node.insertBefore(tmp, self.get_nextSibling);
  end;
  Result := tmp;
end;

{ TMSDOMEntity }

function TDomEntity.get_notationName: DOMString;
begin
  checkError(NOT_SUPPORTED_ERR);
end;

function TDomEntity.get_publicId: DOMString;
begin
  checkError(NOT_SUPPORTED_ERR);
end;

function TDomEntity.get_systemId: DOMString;
begin
  checkError(NOT_SUPPORTED_ERR);
end;

function TDomEntity.getXmlEntity: xmlNodePtr;
begin
  checkError(NOT_SUPPORTED_ERR);
  Result := nil;
end;

{ TDomProcessingInstruction }

function TDomProcessingInstruction.get_data: DOMString;
begin
  Result := inherited get_nodeValue;
end;

function TDomProcessingInstruction.get_target: DOMString;
begin
  Result := inherited get_nodeName;
end;

function TDomProcessingInstruction.GetGProcessingInstruction: xmlNodePtr;
begin
  Result := xmlNodePtr(GNode);
end;

procedure TDomProcessingInstruction.set_data(const Value: DOMString);
begin
  inherited set_nodeValue(Value);
end;

{ TDomDocumentType }

function TDomDocumentType.get_entities: IDomNamedNodeMap;
var
  dtd: xmlDtdPtr;
begin
  dtd := GDocumentType;
  if (dtd <> nil) or (Fdtd2 <> nil) then Result :=
      TDomNamedNodeMap.Create(xmlNodePtr(dtd), fOwnerDocument, 1,Fdtd2) as IDomNamedNodeMap
  else Result := nil;
end;

function TDomDocumentType.get_internalSubset: DOMString;
var
  buff: xmlBufferPtr;
begin
  buff := xmlBufferCreate();
  xmlNodeDump(buff, nil, xmlNodePtr(GetGDocumentType), 0,0);
  Result := UTF8Decode1(buff.content);
  xmlBufferFree(buff);
end;

function TDomDocumentType.get_name: DOMString;
begin
  Result := self.get_nodeName;
end;

function TDomDocumentType.get_notations: IDomNamedNodeMap;
begin
  checkError(NOT_SUPPORTED_ERR);
  //Implementing this method requires to implement a new
  //type of NodeList
  //GetGDocumentType.notations;
end;

function TDomDocumentType.get_publicId: DOMString;
begin
  Result := UTF8Decode1(GetGDocumentType.ExternalID);
end;

function TDomDocumentType.get_systemId: DOMString;
begin
  Result := UTF8Decode1(GetGDocumentType.SystemID);
end;

function TDomDocumentType.GetGDocumentType: xmlDtdPtr;
begin
  Result := xmlDtdPtr(GNode);
end;

constructor TDomDocumentType.Create(dtd1, dtd2: xmlDtdPtr; ADocument: IDomDocument);
var
  root: xmlNodePtr;
begin
  //Get root-node
  root := xmlNodePtr(dtd1);
  Fdtd2 := dtd2;
  //Create root-node as pascal object
  inherited Create(root, ADocument);
end;


destructor TDomDocumentType.Destroy;
begin
  if (GDocumentType <> nil) and (get_ownerDocument = nil) then xmlFreeDtd(GDocumentType);
  inherited Destroy;
end;

{ TDomNotation }

function TDomNotation.get_publicId: DOMString;
begin
  checkError(NOT_SUPPORTED_ERR);
end;

function TDomNotation.get_systemId: DOMString;
begin
  checkError(NOT_SUPPORTED_ERR);
end;

function TDomNotation.GetXmlNotation: xmlNodePtr;
begin
  Result := GNode;
end;

function TDomNode.selectNode(const nodePath: WideString): IDomNode;
  // todo: raise  exceptions
  //       a) if invalid nodePath expression
  //       b) if result type <> nodelist
  //       c) perhaps if nodelist.length > 1 ???
begin
  Result := selectNodes(nodePath)[0];
end;

function TDomNode.selectNodes(const nodePath: WideString): IDomNodeList;
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
  //nodecount1:integer;
begin
  temp := UTF8Encode(nodePath);
  doc := fXmlNode.doc;
  if doc = nil then CheckError(100);  // jk: what is Error 100 ???
  ctxt := xmlXPathNewContext(doc);
  ctxt.node := fXmlNode;
  FPrefixList:=(fOwnerDocument as IDomInternal).getPrefixList;
  FUriList:=(fOwnerDocument as IDomInternal).getUriList;
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
          //if res.nodesetval<> nil
            //then nodecount1 := res.nodesetval.nodeNr;
          Result := TDomNodeList.Create(res, fOwnerDocument)
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
constructor TDomDocumentBuilderFactory.Create(AFreeThreading: boolean);
begin
  FFreeThreading := AFreeThreading;
end;

function TDomDocumentBuilderFactory.NewDocumentBuilder: IDomDocumentBuilder;
begin
  Result := TDomDocumentBuilder.Create(FFreeThreading);
end;

function TDomDocumentBuilderFactory.Get_VendorID: DomString;
begin
  if FFreeThreading then Result := SLIBXML
  else Result := SLIBXML;
end;

procedure TDomNode.set_Prefix(const prefix: DomString);
begin
  checkError(NOT_SUPPORTED_ERR);
end;

function TDomDocumentBuilder.load(const url: DomString): IDomDocument;
begin
  Result := (TDomDocument.Create(Get_DomImplementation, url)) as IDomDocument;
end;

function TDomDocumentBuilder.newDocument: IDomDocument;
begin
  Result := TDomDocument.Create(Get_DomImplementation);
end;

function TDomDocumentBuilder.parse(const xml: DomString): IDomDocument;
begin
  Result := TDomDocument.Create(Get_DomImplementation, '', '', nil);
  (Result as IDomParseOptions).resolveExternals := True;
  (Result as IDomPersist).loadxml(xml);
end;

procedure TDomNode.RegisterNS(const prefix, URI: DomString);
begin
  (fOwnerDocument as IDomInternal).appendNS(UTF8Encode(prefix),UTF8Encode(Uri));
end;

function TDomNode.IsReadOnly: boolean;
begin
  Result := IsReadOnlyNode(fXmlNode)
end;

function TDomNode.IsAncestorOrSelf(newNode: xmlNodePtr): boolean;
var
  node: xmlNodePtr;
begin
  node := fXmlNode;
  Result := True;
  while node <> nil do begin
    if node = newNode then exit;
    node := node.parent;
  end;
  Result := False;
end;

constructor TDomDocument.Create(GDOMImpl: IDomImplementation);
var
  root: xmlNodePtr;
begin
  fDomImpl := GDOMImpl;
  fXmlDocPtr := xmlNewDoc(nil);
  //Get root-node
  root := xmlNodePtr(fXmlDocPtr);
  FAttrList := TList.Create;
  FNodeList := TList.Create;
  FPrefixList:=TStringList.Create;
  FURIList:=TStringList.Create;
  //Create root-node as pascal object
  inherited Create(root, nil);
  (fDomImpl as IDomDebug).doccount:=(fDomImpl as IDomDebug).doccount+1;
end;

constructor TDomDocument.Create(GDOMImpl: IDomImplementation; aUrl: DomString);
var
  fn:   string;
  ctxt: xmlParserCtxtPtr;
begin
  fDomImpl := GDOMImpl;
  {$ifdef WIN32}
  fn := UTF8Encode(StringReplace(aUrl, '\', '\\', [rfReplaceAll]));
  {$else}
  fn := aUrl;
  {$endif}
  //fXmlDocPtr:=(xmlParseFile(PChar(fn)));
  //Load DOM from file
  fXmlDocPtr := nil;
  xmlInitParser();
  ctxt := xmlCreateFileParserCtxt(PChar(fn));
  if (ctxt <> nil) then begin
    // validation
    ctxt.validate := -1;
    //todo: async (separate thread)
    //todo: resolveExternals
    xmlParseDocument(ctxt);
    if (ctxt.wellFormed <> 0) then if not Fvalidate or (ctxt.valid <> 0) then begin
        fXmlDocPtr := ctxt.myDoc;
      end else begin
        xmlFreeDoc(ctxt.myDoc);
        ctxt.myDoc := nil;
      end;
    xmlFreeParserCtxt(ctxt);
  end;
  if (fXmlDocPtr <> nil) then begin
    FtempXSL := nil;
    FAttrList := TList.Create;
    FNodeList := TList.Create;
    FPrefixList:=TStringList.Create;
    FURIList:=TStringList.Create;
    inherited Create(xmlNodePtr(fXmlDocPtr), nil);
    (fDomImpl as IDomDebug).doccount:=(fDomImpl as IDomDebug).doccount+1;
  end;
end;

procedure TDomDocument.removeAttr(attr: xmlAttrPtr);
begin
  if attr <> nil
    then FAttrList.Remove(attr);
end;



procedure TDomDocument.appendAttr(attr: xmlAttrPtr);
begin
  if attr <> nil then FAttrList.add(attr);
end;

procedure TDomDocument.appendNode(node: xmlNodePtr);
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

procedure TDomDocument.removeNode(node: xmlNodePtr);
begin
  if node <> nil then FNodeList.Remove(node);
end;

procedure TDomNode.transformNode(const stylesheet: IDomNode;
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
  doc := fXmlNode.doc;
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

procedure TDomNode.transformNode(const stylesheet: IDomNode;
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
  doc := fXmlNode.doc;
  // if the node is the documentnode, it's ownerdocument is nil,
  // so you have to use self to get the domImplementation
  if self.fOwnerDocument<>nil
    then impl:= self.fOwnerDocument.domImplementation
    else impl:= (self as IDomDocument).domImplementation;
  styleNode := GetGNode(stylesheet);
  styleDoc := styleNode.doc;
  if (styleDoc = nil) or (doc = nil) then exit;
  tempXSL := xsltParseStyleSheetDoc(styleDoc);
  if tempXSL = nil then exit;
  // mark the document as stylesheetdocument;
  // it holds additional information, so a different free method must
  // be used
  (stylesheet.ownerDocument as IDomInternal).set_fTempXSL(tempXSL);
  outputDoc := xsltApplyStylesheet(tempXSL, doc, nil);
  if outputDoc = nil then exit;
  output := TDomDocument.Create(impl, xmlNodePtr(outputDoc)) as IDomDocument;
end;

function TDomNode.IsSameNode(node: IDomNode): boolean;
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

procedure TDomDocument.set_fTempXSL(tempXSL: xsltStylesheetPtr);
begin
  fTempXSL := tempXSL;
end;

constructor TDomDocument.Create(GDOMImpl: IDomImplementation;
  docnode: xmlNodePtr);
begin
  fDomImpl := GDOMImpl;
  fXmlDocPtr := xmlDocPtr(docnode);
  FtempXSL := nil;
  FAttrList := TList.Create;
  FNodeList := TList.Create;
  FPrefixList:=TStringList.Create;
  FURIList:=TStringList.Create;
  //Create root-node as pascal object
  inherited Create(docnode, nil);
  (fDomImpl as IDomDebug).doccount:=(fDomImpl as IDomDebug).doccount+1;
end;

function TDomNode.get_xml: DOMString;
var
  CString: PChar;
  buffer:  xmlBufferPtr;
begin
  buffer := xmlBufferCreate;
  xmlNodeDump(buffer, fXmlNode.doc, fXmlNode, 0,0);
  CString := xmlBufferContent(buffer);
  Result := CString;
  xmlFree(CString);
end;

function TDomDocument.get_compressionLevel: integer;
begin
  Result := FcompressionLevel;
end;

function TDomDocument.get_encoding: DomString;
begin
  Result := fEncoding;
end;

function TDomDocument.get_prettyPrint: boolean;
begin
  Result := fPrettyPrint;
end;

procedure TDomDocument.set_compressionLevel(compressionLevel: integer);
begin
  FcompressionLevel := compressionLevel;
end;

procedure TDomDocument.set_encoding(encoding: DomString);
begin
  fEncoding := encoding;
end;

procedure TDomDocument.set_prettyPrint(prettyPrint: boolean);
begin
  fPrettyPrint := prettyPrint;
end;

function TDomDocument.get_parsedEncoding: DomString;
var
  encoding: widestring;
begin
  encoding := fXmlDocPtr.encoding;
  Result := encoding;
end;

procedure TDomDocument.appendNS(prefix, uri: string);
begin
  FPrefixList.Add(prefix);
  FUriList.Add(uri);
end;

function TDomDocument.getPrefixList: TStringList;
begin
  result:=FPrefixList;
end;

function TDomDocument.getUriList: TStringList;
begin
  result:=FUriList;
end;

function MakeDocument(doc: xmlDocPtr; impl: IDomImplementation): IDomDocument;
begin
   result := TDomDocument.Create(impl, xmlNodePtr(doc)) as IDomDocument;
end;

procedure TDomImplementation.set_doccount(doccount: integer);
begin
  Fdoccount:=doccount;
end;

function TDomImplementation.get_doccount: integer;
begin
  result:=Fdoccount;
end;

initialization
  RegisterDomVendorFactory(TDomDocumentBuilderFactory.Create(False));

finalization
end.
