unit msxml_impl;

(*
 * Dom2 interface implementation for MSXML2
 *
 * Add this file to the uses section to register the Dom vendor factory.
 * The MSXML registers two VendorIDs:
 *   MSXML2_RENTAL_MODEL and MSXML2_FREETHREADING_MODEL (see MS documentation)
 *
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Initial Developer of the Original Code is:
 *
 *   - Martijn Brinkers (m.brinkers@pobox.com)
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 *
 * some changes by: Uwe Fechner
*)

interface
{$define MSXML3}

uses
  {$ifdef MSXML3}
    MSXML3,
  {$else}
    MSXML_TLB,
  {$endif}
  {$ifdef VER140} //delphi6
    variants,
  {$endif}
  windows,
  ComObj,
  Dom2;

  const MSXML2Rental = 'MSXML2_RENTAL_MODEL';
  const MSXML2Free = 'MSXML2_FREETHREADING_MODEL';

type

  (*
   * Extensions to IDomNode interface.
   *
  *)
  IMSXMLExtDomNode = interface
    ['{692595BF-F4AA-454B-A000-DF858113286B}']
    (* Used to get the MS interface from IDomNode interface *)
    function getOrgInterface : IXMLDOMNode;
  end;

  (*
   * Extensions to IDomAttr interface.
   *
  *)
  IMSXMLExtDomAttr = interface
    ['{72A3E81C-8F5E-43B5-93DB-F229949FD07F}']
    (* Used to get the MS interface from IDomAttr interface *)
    function getOrgInterface : IXMLDOMAttribute;
  end;

implementation

uses
  SysUtils,
  Classes,
  ActiveX;            

type

  TMSXMLDocumentBuilderFactory = class(TInterfacedObject, IDomDocumentBuilderFactory)
    private
      fFreeThreading : Boolean;

    public
      constructor create(freeThreading : Boolean);

      function newDocumentBuilder : IDomDocumentBuilder;
      function get_VendorID : DomString;
  end;


  TMSXMLDocumentBuilder = class(TInterfacedObject, IDomDocumentBuilder)
    private
      fFreeThreading : Boolean;

    public
      constructor create(freeThreading : Boolean);
      destructor destroy; override;
      function  get_DomImplementation : IDomImplementation;
      function  newDocument : IDomDocument;
      function  parse(const xml : DomString) : IDomDocument;
      function  load(const url : DomString) : IDomDocument;
      function  get_IsNamespaceAware : Boolean;
      function  get_IsValidating : Boolean;
      function  get_HasAsyncSupport : Boolean;
      function  get_HasAbsoluteURLSupport : Boolean;
  end;

  TMSXMLImplementation = class(TInterfacedObject, IDomImplementation)
    private
      (*
       *DomDocument is only used for providing info for the other methods, ie.
       *it does represent a specific document
      *)
      fMSDomImplementation : IXMLDOMImplementation;
      fFreeThreading: boolean;

      constructor create(msDomImplementation : IXMLDOMImplementation);

    public

      destructor destroy; override;

      function hasFeature(
              const feature : DomString;
              const version : DomString) : Boolean;

      function createDocumentType(
              const qualifiedName : DomString;
              const publicId      : DomString;
              const systemId      : DomString) : IDomDocumentType;

      function createDocument(
              const namespaceURI  : DomString;
              const qualifiedName : DomString;
              docType             : IDomDocumentType) : IDomDocument;
  end;

  TMSXMLNodeList = class(TInterfacedObject, IDomNodeList)
    private
      fMSDomNodeList : IXMLDOMNodeList;

    public
      constructor create(msDomNodeList : IXMLDOMNodeList);
      destructor destroy; override;

      function  get_Length : Integer;
      function  get_Item(index : Integer) : IDomNode;
  end;


  TMSXMLNamedNodeMap = class(TInterfacedObject, IDomNamedNodeMap)
    private
      fMSDomNamedNodeMap : IXMLDOMNamedNodeMap;

    public

      constructor create(msDomNamedNodeMap : IXMLDOMNamedNodeMap);
      destructor destroy; override;

      function  get_Item(index : Integer) : IDomNode;
      function  get_Length : Integer;
      function  getNamedItem(const name : DomString) : IDomNode;
      function  setNamedItem(const newItem : IDomNode) : IDomNode;
      function  removeNamedItem(const name : DomString) : IDomNode;
      function  getNamedItemNS(
              const namespaceURI : DomString;
              const localName    : DomString) : IDomNode;
      function  setNamedItemNS(const newItem : IDomNode) : IDomNode;
      function  removeNamedItemNS(
              const namespaceURI : DomString;
              const localName    : DomString) : IDomNode;
  end;


  TMSXMLNode = class(TInterfacedObject, IDomNode, IDomNodeSelect, IMSXMLExtDomNode)
    private
      fMSDomNode : IXMLDOMNode;

      function getOrgInterface : IXMLDOMNode;

    public
      constructor create(msDomNode : IXMLDOMNode);
      destructor destroy; override;

      function  get_NodeName : DomString;
      procedure set_NodeValue(const value : DomString);
      function  get_NodeValue : DomString;
      function  get_NodeType : TNodeType;
      function  get_ParentNode : IDomNode;
      function  get_ChildNodes : IDomNodeList;
      function  get_FirstChild : IDomNode;
      function  get_LastChild : IDomNode;
      function  get_PreviousSibling : IDomNode;
      function  get_NextSibling : IDomNode;
      function  get_Attributes : IDomNamedNodeMap;
      function  get_OwnerDocument : IDomDocument;
      function  get_NamespaceURI : DomString;
      procedure set_Prefix(const prefix : DomString);
      function  get_Prefix : DomString;
      function  get_LocalName : DomString;
      function  insertBefore(
              const newChild : IDomNode;
              const refChild : IDomNode) : IDomNode;
      function  replaceChild(
              const newChild : IDomNode;
              const oldChild : IDomNode) : IDomNode;
      function  removeChild(const oldChild : IDomNode) : IDomNode;
      function  appendChild(const newChild : IDomNode) : IDomNode;
      function  hasChildNodes : Boolean;
      function  hasAttributes : Boolean;
      function  cloneNode(deep : Boolean) : IDomNode;
      procedure normalize;
      function  isSupported(
              const feature : DomString;
              const version : DomString) : Boolean;
    function selectNode(const nodePath: WideString): IDOMNode;
    function selectNodes(const nodePath: WideString): IDOMNodeList;

  end;


  TMSXMLDocument = class(TMSXMLNode, IDomDocument, IDOMPersist, IDOMParseOptions)
    private
      fMSDomDocument : IXMLDOMDocument;

    public
      constructor create(msDomDocument : IXMLDOMDocument); overload;

      destructor  destroy; override;

      function  get_DocType : IDomDocumentType;
      function  get_DomImplementation : IDomImplementation;
      function  get_DocumentElement : IDomElement;

      function  createElement(const TagName : DomString) : IDomElement;

      function  createDocumentFragment : IDomDocumentFragment;
      function  createTextNode(const data : DomString) : IDomText;
      function  createComment(const data : DomString) : IDomComment;
      function  createCDataSection(const data : DomString) : IDomCDataSection;
      function  createProcessingInstruction(
              const target : DomString;
              const data   : DomString) : IDomProcessingInstruction;
      function  createAttribute(const name : DomString) : IDomAttr;
      function  createEntityReference(
              const name : DomString) : IDomEntityReference;
      function  getElementsByTagName(const tagName : DomString) : IDomNodeList;
      function  importNode(importedNode : IDomNode; deep : Boolean) : IDomNode;
      function  createElementNS(
              const namespaceURI  : DomString;
              const qualifiedName : DomString) : IDomElement;
      function  createAttributeNS(
              const namespaceURI  : DomString;
              const qualifiedName : DomString) : IDomAttr;
      function  getElementsByTagNameNS(
              const namespaceURI : DomString;
              const localName    : DomString) : IDomNodeList;
      function  getElementById(const elementId : DomString) : IDomElement;

      { IDOMPersist methods}
      function  get_xml : DOMString;
      function  asyncLoadState : Integer;
      function  load(source : OleVariant) : Boolean;
      function  loadFromStream(const stream : TStream) : Boolean;
      function  loadxml(const value : DomString) : Boolean;
      procedure save(destination : OleVariant);
      procedure saveToStream(const stream : TStream);
      procedure set_OnAsyncLoad(
              const sender : TObject;
              eventHandler : TAsyncEventHandler);
      { IDOMParseOptions methods}
      function get_async: Boolean;
      procedure set_async(Value: Boolean);
      function get_preserveWhiteSpace: Boolean;
      function get_resolveExternals: Boolean;
      function get_validate: Boolean;
      procedure set_preserveWhiteSpace(Value: Boolean);
      procedure set_resolveExternals(Value: Boolean);
      procedure set_validate(Value: Boolean);
  end;


  TMSXMLDocumentType = class(TMSXMLNode, IDomDocumentType)
    private
      fMSDocumentType : IXMLDOMDocumentType;

    public
      constructor create(msDocumentType : IXMLDOMDocumentType);
      destructor destroy; override;

      function  get_Name : DomString;
      function  get_Entities : IDomNamedNodeMap;
      function  get_Notations : IDomNamedNodeMap;
      function  get_PublicId : DomString;
      function  get_SystemId : DomString;
      function  get_InternalSubset : DomString;
  end;

  TMSXMLElement = class(TMSXMLNode, IDomElement)
    private
      fMSElement : IXMLDOMElement;

    public
      constructor create(msElement : IXMLDOMElement);
      destructor destroy; override;

      function  get_TagName : DomString;
      function  getAttribute(const name : DomString) : DomString;
      procedure setAttribute(const name : DomString; const value : DomString);
      procedure removeAttribute(const name : DomString);
      function  getAttributeNode(const name : DomString) : IDomAttr;
      function  setAttributeNode(const newAttr : IDomAttr) : IDomAttr;
      function  removeAttributeNode(const oldAttr : IDomAttr) : IDomAttr;
      function  getElementsByTagName(const name : DomString) : IDomNodeList;
      function  getAttributeNS(
              const namespaceURI : DomString;
              const localName    : DomString) : DomString;
      procedure setAttributeNS(
              const namespaceURI  : DomString;
              const qualifiedName : DomString;
              const value         : DomString);
      procedure removeAttributeNS(
              const namespaceURI : DomString;
              const localName    : DomString);
      function  getAttributeNodeNS(
              const namespaceURI : DomString;
              const localName : DomString) : IDomAttr;
      function  setAttributeNodeNS(const newAttr : IDomAttr) : IDomAttr;
      function  getElementsByTagNameNS(
              const namespaceURI : DomString;
              const localName    : DomString) : IDomNodeList;
      function hasAttribute(const name : DomString) : Boolean;
      function hasAttributeNS(
              const namespaceURI : DomString;
              const localName    : DomString) : Boolean;
  end;


  TMSXMLAttr = class(TMSXMLNode, IDomAttr, IMSXMLExtDomAttr)
    private
      fMSAttribute : IXMLDOMAttribute;

      function getOrgInterface : IXMLDOMAttribute;

    public
      constructor create(msAttribute : IXMLDOMAttribute);
      destructor destroy; override;

      function  get_Name : DomString;
      function  get_Specified : Boolean;
      procedure set_Value(const value : DomString);
      function  get_Value : DomString;
      function  get_OwnerElement : IDomElement;
  end;


  TMSXMLDocumentFragment = class(TMSXMLNode, IDomDocumentFragment)
    private
      fMSDocumentFragment : IXMLDOMDocumentFragment;

    public
      constructor create(msDocumentFragment : IXMLDOMDocumentFragment);
      destructor destroy; override;
  end;


  TMSXMLCharacterData = class(TMSXMLNode, IDomCharacterData)
    private
      fMSCharacterData : IXMLDOMCharacterData;

    public
      constructor create(msCharacterData : IXMLDOMCharacterData);
      destructor destroy; override;

      procedure set_Data(const data : DomString);
      function  get_Data : DomString;
      function  get_Length : Integer;
      function  subStringData(
              offset : Integer;
              count  : Integer) : DomString;
      procedure appendData(const arg : DomString);
      procedure insertData(offset : Integer; const arg : DomString);
      procedure deleteData(offset : Integer; count : Integer);
      procedure replaceData(
              offset    : Integer;
              count     : Integer;
              const arg : DomString);
  end;

  TMSXMLText = class(TMSXMLCharacterData, IDomText)
    private
      (* because the MS interface does not adhere to w3c specs we must use
       * TMSXMLCharacterData instead of IXMLDOMText. For some methods the
       * MS interface returns IXMLDOMCharacterData where it should return
       * IXMLDOMText (eg. IXMLDOMDocument.createTextNode).
      *)
      fMSText : IXMLDOMCharacterData;

    public
      constructor create(msText : IXMLDOMCharacterData);
      destructor destroy; override;

      function splitText(offset : Integer) : IDomText;
  end;

  TMSXMLComment = class(TMSXMLCharacterData, IDomComment)
    private
      fMSComment : IXMLDOMComment;

    public
      constructor create(msComment : IXMLDOMComment);
      destructor destroy; override;
  end;

  TMSXMLCDataSection = class(TMSXMLText, IDomCDataSection)
    private
      fMSCDataSection : IXMLDOMCDATASection;

    public
      constructor create(msCDataSection : IXMLDOMCDATASection);
      destructor destroy; override;
  end;

  TMSXMLProcessingInstruction = class(TMSXMLNode, IDomProcessingInstruction)
    private
      fMSProcessingInstruction : IXMLDOMProcessingInstruction;

    public
      constructor create(msProcessingInstruction : IXMLDOMProcessingInstruction);
      destructor destroy; override;

      function  get_Target : DomString;
      procedure set_Data(const data : DomString);
      function  get_Data : DomString;
  end;

  TMSXMLEntityReference = class(TMSXMLNode, IDomEntityReference)
    private
      fMSEntityReference : IXMLDOMEntityReference;

    public
      constructor create(msEntityReference : IXMLDOMEntityReference);
      destructor destroy; override;
  end;

  TMSXMLEntity = class(TMSXMLNode, IDomEntity)
    private
      fMSEntity : IXMLDOMEntity;

    public
      constructor create(msEntity : IXMLDOMEntity);
      destructor destroy; override;

      function  get_PublicId : DomString;
      function  get_SystemId : DomString;
      function  get_NotationName : DomString;
  end;

  TMSXMLNotation = class(TMSXMLNode, IDomNotation)
    private
      fMSNotation : IXMLDOMNotation;

    public
      constructor create(msNotation : IXMLDOMNotation);
      destructor destroy; override;

      function  get_PublicId : DomString;
      function  get_SystemId : DomString;
  end;

(* creates a M$ type node based on nodetype *)
function createXMLNode(msNode : IXMLDOMNode) : IDomNode;
begin
  case msNode.nodeType of
    NODE_ELEMENT :
      result := TMSXMLElement.create(msNode as IXMLDOMElement);

    NODE_ATTRIBUTE :
      result := TMSXMLAttr.create(msNode as IXMLDOMAttribute);

    NODE_TEXT :
      result := TMSXMLText.create(msNode as IXMLDOMText);

    NODE_CDATA_SECTION :
      result := TMSXMLCDataSection.create(msNode as IXMLDOMCDataSection);

    NODE_ENTITY_REFERENCE :
      result := TMSXMLEntityReference.create(
              msNode as IXMLDOMEntityReference);

    NODE_ENTITY :
      result := TMSXMLEntity.create(msNode as IXMLDOMEntity);

    NODE_PROCESSING_INSTRUCTION :
      result := TMSXMLProcessingInstruction.create(
              msNode as IXMLDOMProcessingInstruction);

    NODE_COMMENT :
      result := TMSXMLComment.create(msNode as IXMLDOMComment);

    NODE_DOCUMENT :
      result := TMSXMLDocument.create(msNode as IXMLDOMDocument);

    NODE_DOCUMENT_TYPE :
      result := TMSXMLDocumentType.create(msNode as IXMLDOMDocumentType);

    NODE_DOCUMENT_FRAGMENT :
      result := TMSXMLDocumentFragment.create(
              msNode as IXMLDOMDocumentFragment);

    NODE_NOTATION :
      result := TMSXMLNotation.create(msNode as IXMLDOMNotation);

  else
    assert(false);
  end;
end;



function TryObjectCreate(const GuidList: array of TGuid): IUnknown;
var
  I: Integer;
  Status: HResult;
begin
  for I := Low(GuidList) to High(GuidList) do
  begin
    Status := CoCreateInstance(GuidList[I], nil, CLSCTX_INPROC_SERVER or
      CLSCTX_LOCAL_SERVER, IDispatch, Result);
    if Status = S_OK then Break;
    if Status <> REGDB_E_CLASSNOTREG then
      OleCheck(Status);
  end;
end;

function CreateDOMDocument: IXMLDOMDocument;
const
 CLASS_DOMDocument40: TGUID = '{88D969C0-F192-11D4-A65F-0040963251E5}';
begin
  Result := TryObjectCreate([CLASS_DOMDocument40, CLASS_DOMDocument30, CLASS_DOMDocument26])
    as IXMLDOMDocument;
  if not Assigned(Result) then
    raise EDOMException.Create(etNotFoundErr,'MSDOM not installed!');
end;


(*
 *  TXDomDocumentBuilderFactory
*)
constructor TMSXMLDocumentBuilderFactory.create(freeThreading : Boolean);
begin
  fFreeThreading := freeThreading;
end;

function TMSXMLDocumentBuilderFactory.newDocumentBuilder : IDomDocumentBuilder;
begin
  result := TMSXMLDocumentBuilder.create(fFreeThreading);
end;

function TMSXMLDocumentBuilderFactory.get_VendorID : DomString;
begin
  if fFreeThreading then
    result := MSXML2Free
  else
    result := MSXML2Rental;
end;

(*
 *  TXDomDocumentBuilder
*)
constructor TMSXMLDocumentBuilder.create(freeThreading : Boolean);
begin
  inherited create;
  fFreeThreading := freeThreading;
end;

destructor TMSXMLDocumentBuilder.destroy;
begin
  inherited destroy;
end;


function TMSXMLDocumentBuilder.get_DomImplementation : IDomImplementation;
begin
  result:=TMSXMLImplementation.create(nil);
end;

function TMSXMLDocumentBuilder.NewDocument : IDomDocument;
begin
  if fFreeThreading then
    //result := TMSXMLDocument.create(CoDOMFreeThreadedDocument.create)
  else
    result := TMSXMLDocument.create(CoDOMDocument.create);
end;

function TMSXMLDocumentBuilder.Parse(const xml : DomString) : IDomDocument;
var
  document : IDomDocument;
begin
  document := newDocument;
  (document as IDOMPersist).loadXML(xml);
  result := document;
end;

function TMSXMLDocumentBuilder.load(const url : DomString) : IDomDocument;
var
  document : IDomDocument;
begin
  document := newDocument;
  (document as IDomPersist).load(url);
  result := document;
end;


function TMSXMLDocumentBuilder.get_IsNamespaceAware : Boolean;
begin
  result := true;
end;

function TMSXMLDocumentBuilder.get_IsValidating : Boolean;
begin
  result := true;
end;

function TMSXMLDocumentBuilder.get_HasAsyncSupport : Boolean;
begin
  result := true;
end;

function TMSXMLDocumentBuilder.get_HasAbsoluteURLSupport : Boolean;
begin
  result := true;
end;


(*
 *  TXDomImplementation
*)
constructor TMSXMLImplementation.create(
        msDomImplementation : IXMLDOMImplementation);
begin
  inherited create;
  fMSDomImplementation := msDomImplementation;
end;

destructor TMSXMLImplementation.destroy;
begin
  fMSDomImplementation := nil;
  inherited destroy;
end;

function TMSXMLImplementation.hasFeature(
        const feature : DomString;
        const version : DomString) : Boolean;
begin
  //todo: check version of msdom installed
  if (uppercase(feature) ='CORE') and (version = '2.0')
    then result:=true
    else result:=false;
end;


function TMSXMLImplementation.createDocumentType(
        const qualifiedName : DomString;
        const publicId      : DomString;
        const systemId      : DomString) : IDomDocumentType;
begin
  (* CreateDocumentType is not supported *)
  raise EDomException.create(
          etNotSupportedErr, 'CreateDocumentType is not supported');
end;

function TMSXMLImplementation.createDocument(
        const namespaceURI  : DomString;
        const qualifiedName : DomString;
        docType             : IDomDocumentType) : IDomDocument;
var
  document: IXMLDOMDocument;
  fFreeThreading: boolean;
begin
  //fFreeThreading:=false; //TODO: correct this line
  //if fFreeThreading then
    //document := CoDOMFreeThreadedDocument.create
  //else
  //  document := CoDOMDocument.create;
  document:= CreateDOMDocument;
  Result := TMSXMLDocument.Create(document);
end;


(*
 *  TMSXMLDocument
*)

constructor TMSXMLDocument.create(msDomDocument : IXMLDOMDocument);
begin
  inherited create(msDomDocument);
  fMSDomDocument := msDomDocument;
end;

destructor TMSXMLDocument.destroy;
begin
  fMSDomDocument := nil;
  inherited destroy;
end;

function TMSXMLDocument.get_DocType : IDomDocumentType;
var
  msDocType : IXMLDOMDocumentType;
begin
  msDocType := fMSDomDocument.doctype;
  if msDocType = nil then
    result := nil
  else
    result := TMSXMLDocumentType.create(msDocType);
end;

function TMSXMLDocument.get_DomImplementation : IDomImplementation;
var
  msDomImplementation : IXMLDOMImplementation;
begin
  msDomImplementation := fMSDomDocument.implementation_;
  if msDomImplementation = nil then
    result := nil
  else
    result := TMSXMLImplementation.create(msDomImplementation);
end;

function TMSXMLDocument.get_DocumentElement : IDomElement;
var
  msDomElement : IXMLDOMElement;
begin
  msDomElement := fMSDomDocument.documentElement;
  if msDomElement = nil then
    result := nil
  else
    result := TMSXMLElement.create(msDomElement);
end;

function TMSXMLDocument.createElement(const tagName : DomString) : IDomElement;
var
  msDomElement : IXMLDOMElement;
begin
  msDomElement := fMSDomDocument.createElement(tagName);
  if msDomElement = nil then
    result := nil
  else
    result := TMSXMLElement.create(msDomElement);
end;

function TMSXMLDocument.createDocumentFragment : IDomDocumentFragment;
var
  msDocumentFragment : IXMLDOMDocumentFragment;
begin
  msDocumentFragment := fMSDomDocument.createDocumentFragment;
  if msDocumentFragment = nil then
    result := nil
  else
    result := TMSXMLDocumentFragment.create(msDocumentFragment);
end;

function TMSXMLDocument.createTextNode(const data : DomString) : IDomText;
var
  msText : IXMLDOMCharacterData;
begin
  msText := fMSDomDocument.createTextNode(data);
  if msText = nil then
    result := nil
  else
    result := TMSXMLText.create(msText);
end;

function TMSXMLDocument.createComment(const data : DomString) : IDomComment;
var
  msComment : IXMLDOMComment;
begin
  msComment := fMSDomDocument.createComment(data);
  if msComment = nil then
    result := nil
  else
    result := TMSXMLComment.create(msComment);
end;

function TMSXMLDocument.createCDataSection(const data : DomString) : IDomCDataSection;
var
  msCDataSection : IXMLDOMCDATASection;
begin
  msCDataSection := fMSDomDocument.createCDATASection(data);
  if msCDataSection = nil then
    result := nil
  else
    result := TMSXMLCDataSection.create(msCDataSection);
end;

function TMSXMLDocument.createProcessingInstruction(
        const target : DomString;
        const data   : DomString) : IDomProcessingInstruction;
var
  msProcessingInstruction : IXMLDOMProcessingInstruction;
begin
  msProcessingInstruction :=
          fMSDomDocument.createProcessingInstruction(target, data);
  if msProcessingInstruction = nil then
    result := nil
  else
    result := TMSXMLProcessingInstruction.create(msProcessingInstruction);
end;

function TMSXMLDocument.createAttribute(const name : DomString) : IDomAttr;
var
  msAttr : IXMLDOMAttribute;
begin
  msAttr := fMSDomDocument.createAttribute(name);
  if msAttr = nil then
    result := nil
  else
    result := TMSXMLAttr.create(msAttr);
end;

function TMSXMLDocument.createEntityReference(
        const name : DomString) : IDomEntityReference;
var
  msEntityReference : IXMLDOMEntityReference;
begin
  msEntityReference := fMSDomDocument.createEntityReference(name);
  if msEntityReference = nil then
    result := nil
  else
    result := TMSXMLEntityReference.create(msEntityReference);
end;

function TMSXMLDocument.getElementsByTagName(
        const tagName : DomString) : IDomNodeList;
var
  msNodeList : IXMLDOMNodeList;
begin
  msNodeList := fMSDomDocument.getElementsByTagName(tagName);
  if msNodeList = nil then
    result := nil
  else
    result := TMSXMLNodeList.create(msNodeList);
end;

function TMSXMLDocument.importNode(
        importedNode : IDomNode;
        deep         : Boolean) : IDomNode;
begin
  raise EDomException.create(etNotSupportedErr, 'ImportNode is not supported');
end;

function TMSXMLDocument.createElementNS(
        const namespaceURI  : DomString;
        const qualifiedName : DomString) : IDomElement;
var
  msElement : IXMLDOMElement;
  node: IXMLDOMNode;
begin
  //Changes by FE
  node := fMSDomDocument.createNode(NODE_ELEMENT, qualifiedName, namespaceURI);
  msElement:=node as IXMLDOMElement;
  if msElement = nil then
    result := nil
  else
    result := TMSXMLElement.create(msElement);
end;

function TMSXMLDocument.createAttributeNS(
        const namespaceURI  : DomString;
        const qualifiedName : DomString) : IDomAttr;
var
  msAttr : IXMLDOMAttribute;
  node: IXMLDOMNode;
begin
  node := fMSDomDocument.createNode(NODE_ATTRIBUTE, qualifiedName, namespaceURI);
  msAttr:=node as IXMLDOMAttribute;
  if msAttr = nil then
    result := nil
  else
    result := TMSXMLAttr.create(msAttr);
end;

function TMSXMLDocument.getElementsByTagNameNS(
        const namespaceURI : DomString;
        const localName    : DomString) : IDomNodeList;
var temp: IXMLDOMElement;
begin
  (fMSDomDocument as IXMLDomDocument2).setProperty('SelectionNamespaces',
    'xmlns:xyz4ct='''+namespaceURI+'''');
  temp:=fMSDomDocument.DocumentElement;
  temp.selectNodes('xyz4ct:'+localName);
  if temp<>nil
    then result:=TMSXMLNodeList.create(temp.selectNodes('xyz4ct:'+localName))
    else result:=nil;
end;

function TMSXMLDocument.getElementById(
        const elementId : DomString) : IDomElement;
begin
  raise EDomException.create(
          etNotSupportedErr, 'GetElementById is not supported');
end;


function TMSXMLDocument.get_xml : DOMString;
begin
  result := fMSDomDocument.xml;
end;

function TMSXMLDocument.asyncLoadState : Integer;
begin
  result := fMSDomDocument.readyState;
end;

function TMSXMLDocument.load(source : OleVariant) : Boolean;
begin
  result := fMSDomDocument.load(source);
  if not result then
  begin
    raise EDomException.createFmt(
            etParseErr,
            'Reason: %s, Line: %d, LinePos: %d',
            [fMSDomDocument.parseError.reason,
            fMSDomDocument.parseError.line,
            fMSDomDocument.parseError.linePos]);
  end;
end;

function TMSXMLDocument.loadFromStream(const stream : TStream) : Boolean;
var
  msStream : IStream;
begin
  msStream := TStreamAdapter.create(stream);
  result := fMSDomDocument.load(msStream);
  if not result then
  begin
    raise EDomException.createFmt(
            etParseErr,
            'Reason: %s, Line: %d, LinePos: %d',
            [fMSDomDocument.parseError.reason,
            fMSDomDocument.parseError.line,
            fMSDomDocument.parseError.linePos]);
  end;
end;

function TMSXMLDocument.loadxml(const value : DOMString) : Boolean;
begin
  result := fMSDomDocument.loadXML(value);
  if not result then
  begin
    raise EDomException.createFmt(
            etParseErr,
            'Reason: %s, Line: %d, LinePos: %d',
            [fMSDomDocument.parseError.reason,
            fMSDomDocument.parseError.line,
            fMSDomDocument.parseError.linePos]);
  end;
end;

procedure TMSXMLDocument.save(destination : OleVariant);
begin
  fMSDomDocument.save(destination);
end;

procedure TMSXMLDocument.saveToStream(const stream : TStream);
var
  msStream : IStream;
begin
  msStream := TStreamAdapter.create(stream);
  fMSDomDocument.save(msStream);
end;

procedure TMSXMLDocument.set_OnAsyncLoad(
        const sender : TObject;
        eventHandler : TAsyncEventHandler);
begin
  // XXX NOT YET IMPLEMENTED
end;

{ IDOMParseOptions Interface }

function TMSXMLDocument.get_async: Boolean;
begin
  Result := fMSDomDocument.async;
end;

procedure TMSXMLDocument.set_async(Value: Boolean);
begin
  fMSDomDocument.async := Value
end;

function TMSXMLDocument.get_preserveWhiteSpace: Boolean;
begin
  Result := fMSDomDocument.Get_preserveWhiteSpace;
end;

function TMSXMLDocument.get_resolveExternals: Boolean;
begin
  Result := fMSDomDocument.Get_resolveExternals;
end;

function TMSXMLDocument.get_validate: Boolean;
begin
  Result := fMSDomDocument.Get_validateOnParse;
end;

procedure TMSXMLDocument.set_preserveWhiteSpace(Value: Boolean);
begin
  fMSDomDocument.Set_preserveWhiteSpace(Value);
end;

procedure TMSXMLDocument.set_resolveExternals(Value: Boolean);
begin
  fMSDomDocument.Set_resolveExternals(Value);
end;

procedure TMSXMLDocument.set_validate(Value: Boolean);
begin
  fMSDomDocument.Set_validateOnParse(Value);
end;



(*
 *  TMSXMLNode
*)
constructor TMSXMLNode.create(msDomNode : IXMLDOMNode);
begin
  inherited create;
  fMSDomNode := msDomNode;
end;

destructor TMSXMLNode.destroy;
begin
  fMSDomNode := Nil;
  inherited destroy;
end;


function TMSXMLNode.getOrgInterface : IXMLDOMNode;
begin
  result := fMSDomNode;
end;

function TMSXMLNode.get_NodeName : DomString;
begin
  result := fMSDomNode.nodeName;
end;

procedure TMSXMLNode.set_NodeValue(const value : DomString);
begin
  fMSDomNode.nodeValue := value;
end;

function TMSXMLNode.get_NodeValue : DomString;
var
  value : OleVariant;
begin
  value := fMSDomNode.nodeValue;
  if value = null then
    result := ''
  else
    result := Value;
end;

function TMSXMLNode.get_NodeType : TNodeType;
begin
  result := domOrdToNodeType(fMSDomNode.nodeType);
end;

function TMSXMLNode.get_ParentNode : IDomNode;
var
  msNode : IXMLDOMNode;
begin
  msNode := fMSDomNode.parentNode;
  if msNode = nil then
    result := nil
  else
    result := createXMLNode(msNode);
end;

function TMSXMLNode.get_ChildNodes : IDomNodeList;
var
  msNodeList : IXMLDOMNodeList;
begin
  msNodeList := fMSDomNode.childNodes;
  if msNodeList = nil then
    result := nil
  else
    result := TMSXMLNodeList.create(msNodeList);
end;

function TMSXMLNode.get_FirstChild : IDomNode;
var
  msNode : IXMLDOMNode;
begin
  msNode := fMSDomNode.firstChild;
  if msNode = nil then
    result := nil
  else
    result := createXMLNode(msNode);
end;

function TMSXMLNode.get_LastChild : IDomNode;
var
  msNode : IXMLDOMNode;
begin
  msNode := fMSDomNode.lastChild;
  if msNode = nil then
    result := nil
  else
    result := createXMLNode(msNode);
end;

function TMSXMLNode.get_PreviousSibling : IDomNode;
var
  msNode : IXMLDOMNode;
begin
  msNode := fMSDomNode.previousSibling;
  if msNode = nil then
    result := nil
  else
    result := createXMLNode(msNode);
end;

function TMSXMLNode.get_NextSibling : IDomNode;
var
  msNode : IXMLDOMNode;
begin
  msNode := fMSDomNode.nextSibling;
  if msNode = nil then
    result := nil
  else
    result := createXMLNode(msNode);
end;

function TMSXMLNode.get_Attributes : IDomNamedNodeMap;
var
  msNamedNodeMap : IXMLDOMNamedNodeMap;
begin
  msNamedNodeMap := fMSDomNode.attributes;
  if msNamedNodeMap = nil then
    result := nil
  else
    result := TMSXMLNamedNodeMap.create(msNamedNodeMap);
end;

function TMSXMLNode.get_OwnerDocument : IDomDocument;
var
  msDocument : IXMLDOMDocument;
begin
  msDocument := fMSDomNode.ownerDocument;
  if msDocument = nil then
    result := nil
  else
    result := TMSXMLDocument.create(msDocument);
end;

function TMSXMLNode.get_NamespaceURI : DomString;
begin
  result := fMSDomNode.namespaceURI;
end;

procedure TMSXMLNode.set_Prefix(const prefix : DomString);
begin
  (* SetPrefix is not supported *)
  raise EDomException.create(etNotSupportedErr, 'SetPrefix is not supported');
end;

function TMSXMLNode.get_Prefix : DomString;
begin
  result := fMSDomNode.prefix;
end;

function TMSXMLNode.get_LocalName : DomString;
begin
  //by FE
  if fMSDomNode.nodeName=fMSDomNode.baseName
    then result:='' //see DOM2 specification
    else result := fMSDomNode.baseName;
end;

function TMSXMLNode.insertBefore(
        const newChild : IDomNode;
        const refChild : IDomNode) : IDomNode;
var
  msNewChild : IXMLDOMNode;
  msRefChild : IXMLDOMNode;
begin
  msNewChild := (newChild as IMSXMLExtDomNode).getOrgInterface;
  msRefChild := (refChild as IMSXMLExtDomNode).getOrgInterface;
  result := createXMLNode(fMSDomNode.insertBefore(msNewChild, msRefChild));
end;

function TMSXMLNode.replaceChild(
        const newChild : IDomNode;
        const oldChild : IDomNode) : IDomNode;
var
  msNewChild : IXMLDOMNode;
  msOldChild : IXMLDOMNode;
begin
  msNewChild := (newChild as IMSXMLExtDomNode).getOrgInterface;
  msOldChild := (oldChild as IMSXMLExtDomNode).getOrgInterface;
  result := createXMLNode(fMSDomNode.replaceChild(msNewChild, msOldChild));
end;

function TMSXMLNode.removeChild(const oldChild : IDomNode) : IDomNode;
var
  msOldChild : IXMLDOMNode;
begin
  msOldChild := (oldChild as IMSXMLExtDomNode).getOrgInterface;
  result := createXMLNode(fMSDomNode.removeChild(msOldChild));
end;

function TMSXMLNode.appendChild(const newChild : IDomNode) : IDomNode;
var
  msNewChild : IXMLDOMNode;
begin
  msNewChild := (newChild as IMSXMLExtDomNode).getOrgInterface;
  result := createXMLNode(fMSDomNode.appendChild(msNewChild));
end;

function TMSXMLNode.hasChildNodes : Boolean;
begin
  result := fMSDomNode.hasChildNodes;
end;

function TMSXMLNode.hasAttributes : Boolean;
begin
  if fMSDomNode.attributes = nil then
  begin
    result := false;
    exit;
  end;
  result := fMSDomNode.attributes.length > 0;
end;

function TMSXMLNode.cloneNode(deep : Boolean) : IDomNode;
begin
  result := createXMLNode(fMSDomNode.cloneNode(deep));
end;

procedure TMSXMLNode.normalize;
begin
  (fMSDomNode as IXMLDomElement).normalize;
end;

function TMSXMLNode.isSupported(
        const feature : DomString;
        const version : DomString) : Boolean;
begin
  if (((upperCase(feature)='CORE') and (version='2.0')) or
     (upperCase(feature)='XML')  and (version='2.0'))
    then result:=true
    else result:=false;
end;

(*
 *  TMSXMLNodeList
*)
constructor TMSXMLNodeList.create(msDomNodeList : IXMLDOMNodeList);
begin
  inherited create;
  fMSDomNodeList := msDomNodeList;
end;

destructor TMSXMLNodeList.destroy;
begin
  fMSDomNodeList := nil;
  inherited destroy;
end;

function TMSXMLNodeList.get_Length : Integer;
begin
  result := fMSDomNodeList.length;
end;

function TMSXMLNodeList.get_Item(index : Integer) : IDomNode;
var
  msNode : IXMLDOMNode;
begin
  msNode := fMSDomNodeList.item[index];
  if msNode = nil then
    result := nil
  else
    result := createXMLNode(msNode);
end;

(*
 *  TMSXMLNamedNodeMap
 *)
constructor TMSXMLNamedNodeMap.create(msDomNamedNodeMap : IXMLDOMNamedNodeMap);
begin
  inherited create; //by FE
  fMSDomNamedNodeMap := msDomNamedNodeMap;
end;

destructor TMSXMLNamedNodeMap.destroy;
begin
  fMSDomNamedNodeMap := nil;
  inherited destroy;
end;

function TMSXMLNamedNodeMap.get_Item(index : Integer) : IDomNode;
var
  msNode : IXMLDOMNode;
begin
  msNode := fMSDomNamedNodeMap.item[index];
  if msNode = nil then
    result := nil
  else
    result := createXMLNode(msNode);
end;

function TMSXMLNamedNodeMap.get_Length : Integer;
begin
  result := fMSDomNamedNodeMap.length;
end;

function TMSXMLNamedNodeMap.getNamedItem(const name : DomString) : IDomNode;
var
  msNode : IXMLDOMNode;
begin
  msNode := fMSDomNamedNodeMap.getNamedItem(name);
  if msNode = nil then
    result := nil
  else
    result := createXMLNode(msNode);
end;

function TMSXMLNamedNodeMap.setNamedItem(const newItem : IDomNode) : IDomNode;
var
  msNode : IXMLDOMNode;
begin
  msNode := fMSDomNamedNodeMap.setNamedItem(
          (newItem as IMSXMLExtDomNode).getOrgInterface);
  if msNode = nil then
    result := nil
  else
    result := createXMLNode(msNode);
end;

function TMSXMLNamedNodeMap.removeNamedItem(const name : DomString) : IDomNode;
var
  msNode : IXMLDOMNode;
begin
  msNode := fMSDomNamedNodeMap.removeNamedItem(name);
  if msNode = nil then
    result := nil
  else
    result := createXMLNode(msNode);
end;

function TMSXMLNamedNodeMap.getNamedItemNS(
        const namespaceURI : DomString;
        const localName    : DomString) : IDomNode;
begin
  (* Namespace is not supported*)
  result := getNamedItem(localName);
end;

function TMSXMLNamedNodeMap.setNamedItemNS(const newItem : IDomNode) : IDomNode;
begin
  (* Namespace is not supported*)
  result := setNamedItem(newItem);
end;

function TMSXMLNamedNodeMap.removeNamedItemNS(
        const namespaceURI : DomString;
        const localName    : DomString) : IDomNode;
begin
  (* Namespace is not supported*)
  result := removeNamedItem(localName);
end;

(*
 *  TMSXMLDocumentType
*)
constructor TMSXMLDocumentType.create(msDocumentType : IXMLDOMDocumentType);
begin
  inherited create(msDocumentType);
  fMSDocumentType := msDocumentType;
end;

destructor TMSXMLDocumentType.destroy;
begin
  fMSDocumentType := nil;
  inherited destroy;
end;

function TMSXMLDocumentType.get_Name : DomString;
begin
  result := fMSDocumentType.name;
end;

function TMSXMLDocumentType.get_Entities : IDomNamedNodeMap;
var
  msNamedNodeMap : IXMLDOMNamedNodeMap;
begin
  msNamedNodeMap := fMSDocumentType.entities;
  if msNamedNodeMap = nil then
    result := nil
  else
    result := TMSXMLNamedNodeMap.create(msNamedNodeMap);
end;

function TMSXMLDocumentType.get_Notations : IDomNamedNodeMap;
var
  msNamedNodeMap : IXMLDOMNamedNodeMap;
begin
  msNamedNodeMap := fMSDocumentType.notations;
  if msNamedNodeMap = nil then
    result := nil
  else
  result := TMSXMLNamedNodeMap.create(msNamedNodeMap);
end;

function TMSXMLDocumentType.get_PublicId : DomString;
begin
  (* GetPublicId is not supported *)
  raise EDomException.create(etNotSupportedErr, 'GetPublicId is not supported');
end;

function TMSXMLDocumentType.get_SystemId : DomString;
begin
  (* GetSystemId is not supported *)
  raise EDomException.create(etNotSupportedErr, 'GetSystemId is not supported');
end;

function TMSXMLDocumentType.get_InternalSubset : DomString;
begin
  (* GetInternalSubset is not supported *)
  raise EDomException.create(
          etNotSupportedErr, 'GetInternalSubset is not supported');
end;


(*
 *  TMSXMLElement
*)
constructor TMSXMLElement.create(msElement : IXMLDOMElement);
begin
  inherited create(msElement);
  fMSElement := msElement;
end;

destructor TMSXMLElement.destroy;
begin
  fMSElement := nil;
  inherited destroy;
end;

function TMSXMLElement.get_TagName : DomString;
begin
  result := fMSElement.tagName;
end;

function TMSXMLElement.getAttribute(const name : DomString) : DomString;
begin
  result := fMSElement.getAttribute(name);
end;

procedure TMSXMLElement.setAttribute(
        const name  : DomString;
        const value : DomString);
begin
  fMSElement.setAttribute(name, value);
end;

procedure TMSXMLElement.removeAttribute(const name : DomString);
begin
  fMSElement.removeAttribute(name);
end;

function TMSXMLElement.getAttributeNode(const name : DomString) : IDomAttr;
var
  msAttr : IXMLDOMAttribute;
begin
  msAttr := fMSElement.getAttributeNode(name);
  if msAttr = nil then
    result := nil
  else
    result := TMSXMLAttr.create(msAttr);
end;

function TMSXMLElement.setAttributeNode(const newAttr : IDomAttr) : IDomAttr;
var
  msAttr : IXMLDOMAttribute;
begin
  msAttr := fMSElement.setAttributeNode(
          (newAttr as IMSXMLExtDomAttr).getOrgInterface);
  if msAttr = nil then
    result := nil
  else
    result := TMSXMLAttr.create(msAttr);
end;

function TMSXMLElement.removeAttributeNode(const oldAttr : IDomAttr) : IDomAttr;
var
  msAttr : IXMLDOMAttribute;
begin
  msAttr := fMSElement.removeAttributeNode(
          (oldAttr as IMSXMLExtDomAttr).getOrgInterface);
  if msAttr = nil then
    result := nil
  else
    result := TMSXMLAttr.create(msAttr);
end;

function TMSXMLElement.getElementsByTagName(
        const name : DomString) : IDomNodeList;
var
  msNodeList : IXMLDOMNodeList;
begin
  msNodeList := fMSElement.getElementsByTagName(name);
  if msNodeList = nil then
    result := nil
  else
    result := TMSXMLNodeList.create(msNodeList);
end;

function TMSXMLElement.getAttributeNS(
        const namespaceURI : DomString;
        const localName    : DomString) : DomString;
var
  Attr : IDOMAttr;
begin
  Attr := getAttributeNodeNS(namespaceURI, localName);
  if Assigned(Attr) then
    Result := Attr.NodeValue
  else
    Result := '';
end;

procedure TMSXMLElement.setAttributeNS(
        const namespaceURI  : DomString;
        const qualifiedName : DomString;
        const value         : DomString);
//begin
//  (* namespace not supported *)
//  setAttribute(qualifiedName, value);
//end;

var
  AttrNode: IXMLDOMAttribute;
begin
  AttrNode := fMSElement.ownerDocument.createNode(NODE_ATTRIBUTE, qualifiedName,
    namespaceURI) as IXMLDOMAttribute;
  AttrNode.nodeValue := value;
  fMSElement.setAttributeNode(AttrNode);
end;



procedure TMSXMLElement.removeAttributeNS(
        const namespaceURI : DomString;
        const localName    : DomString);
begin
  (* namespace not supported *)
  removeAttribute(localName);
end;

function TMSXMLElement.getAttributeNodeNS(
        const namespaceURI : DomString;
        const localName    : DomString) : IDomAttr;
var attr: IXMLDomNode;
begin
  attr:=fMSElement.Attributes.getQualifiedItem(localName, namespaceURI);
  if attr<>nil
    then Result := createXMLNode(attr) as IDOMAttr
    else Result := nil;
end;

function TMSXMLElement.setAttributeNodeNS(const newAttr : IDomAttr) : IDomAttr;
begin
  setAttributeNode(newAttr);
end;

function TMSXMLElement.getElementsByTagNameNS(
        const namespaceURI : DomString;
        const localName    : DomString) : IDomNodeList;
var  msNodeList : IXMLDOMNodeList;
begin
  (fMSElement.ownerDocument as IXMLDomDocument2).setProperty('SelectionNamespaces',
    'xmlns:xyz4ct='''+namespaceURI+'''');
  result:=selectNodes('xyz4ct:'+localName);
end;

function TMSXMLElement.hasAttribute(const name : DomString) : Boolean;
begin
  result := fMSElement.getAttributeNode(name) <> nil;
end;

function TMSXMLElement.hasAttributeNS(
        const namespaceURI : DomString;
        const localName    : DomString) : Boolean;
begin
  try
    Result := getAttributeNodeNS(namespaceURI, localName) <> nil;
  except
    Result := False;
  end;
end;


(*
 *  TMSAttr
*)
constructor TMSXMLAttr.create(msAttribute : IXMLDOMAttribute);
begin
  inherited create(msAttribute);
  fMSAttribute := msAttribute;
end;

destructor TMSXMLAttr.destroy;
begin
  fMSAttribute := nil;
  inherited destroy;
end;

function TMSXMLAttr.getOrgInterface : IXMLDOMAttribute;
begin
  result := fMSAttribute;
end;


function TMSXMLAttr.get_Name : DomString;
begin
  result := fMSAttribute.name;
end;

function TMSXMLAttr.get_Specified : Boolean;
begin
  result := fMSAttribute.specified;
end;

procedure TMSXMLAttr.set_Value(const value : DomString);
begin
  fMSAttribute.value := value;
end;

function TMSXMLAttr.get_Value : DomString;
begin
  result := fMSAttribute.value;
end;

function TMSXMLAttr.get_OwnerElement : IDomElement;
begin
  (* not supported *)
  raise EDomException.create(
          etNotSupportedErr, 'GetOwnerElement is not supported');
end;


(*
 * TMSDocumentFragment
*)
constructor TMSXMLDocumentFragment.create(
        msDocumentFragment : IXMLDOMDocumentFragment);
begin
  inherited create(msDocumentFragment);
  fMSDocumentFragment := msDocumentFragment;
end;

destructor TMSXMLDocumentFragment.destroy;
begin
  fMSDocumentFragment := nil;
  inherited destroy;
end;


(*
 * TMSXMLCharacterData
*)
constructor TMSXMLCharacterData.create(msCharacterData : IXMLDOMCharacterData);
begin
  inherited create(msCharacterData);
  fMSCharacterData := msCharacterData;
end;

destructor TMSXMLCharacterData.destroy;
begin
  fMSCharacterData := nil;
  inherited destroy;
end;

procedure TMSXMLCharacterData.set_Data(const data : DomString);
begin
  fMSCharacterData.data := data;
end;

function  TMSXMLCharacterData.get_Data : DomString;
begin
  result := fMSCharacterData.data;
end;

function  TMSXMLCharacterData.get_Length : Integer;
begin
  result := fMSCharacterData.length;
end;

function  TMSXMLCharacterData.subStringData(
        offset : Integer;
        count  : Integer) : DomString;
begin
  result := fMSCharacterData.substringData(offset, count);
end;

procedure TMSXMLCharacterData.appendData(const arg : DomString);
begin
  fMSCharacterData.appendData(arg);
end;

procedure TMSXMLCharacterData.insertData(
        offset    : Integer;
        const arg : DomString);
begin
  fMSCharacterData.insertData(offset, arg);
end;

procedure TMSXMLCharacterData.deleteData(
        offset : Integer;
        count  : Integer);
begin
  fMSCharacterData.deleteData(offset, count);
end;

procedure TMSXMLCharacterData.replaceData(
        offset    : Integer;
        count     : Integer;
        const arg : DomString);
begin
  fMSCharacterData.replaceData(offset, count, arg);
end;


(*
 * TMSText
*)
constructor TMSXMLText.create(msText : IXMLDOMCharacterData);
begin
  inherited create(msText);
  fMSText := msText;
end;

destructor TMSXMLText.destroy;
begin
  fMSText := nil;
  inherited destroy;
end;

function TMSXMLText.splitText(offset : Integer) : IDomText;
var
  msText : IXMLDOMCharacterData;
begin
  (* check if FMSText is actually IXMLDOMText. MS interface specs do not adhere
   * to the w3c specs and I therefore had to use IXMLDOMCharacterData
  *)
  try
    msText := (fMSText as IXMLDOMText).splitText(offSet);
    if msText = nil then
      result := nil
    else
      result := TMSXMLText.create(msText);
  except
    on e : EIntfCastError do
    begin
      (* SplitText is not supported. The MS implementation returns
       * IXMLDOMCharacterData instead of IDomText
      *)
      raise EDomException.create(
              etNotSupportedErr, 'SplitText is not supported');
    end;
  end;
end;


(*
 * TMSComment
*)
constructor TMSXMLComment.create(msComment : IXMLDOMComment);
begin
  inherited create(msComment);
  fMSComment := msComment;
end;

destructor TMSXMLComment.destroy;
begin
  fMSComment := nil;
  inherited destroy;
end;


(*
 * TMSCDataSection
*)
constructor TMSXMLCDataSection.create(msCDataSection : IXMLDOMCDATASection);
begin
  inherited create(msCDataSection);
  fMSCDataSection := msCDataSection;
end;

destructor TMSXMLCDataSection.destroy;
begin
  fMSCDataSection := nil;
  inherited destroy;
end;


(*
 * TMSProcessingInstruction
*)
constructor TMSXMLProcessingInstruction.create(
        msProcessingInstruction : IXMLDOMProcessingInstruction);
begin
  inherited create(msProcessingInstruction);
  fMSProcessingInstruction := msProcessingInstruction;
end;

destructor TMSXMLProcessingInstruction.destroy;
begin
  fMSProcessingInstruction := nil;
  inherited destroy;
end;

function TMSXMLProcessingInstruction.get_Target : DomString;
begin
  result := fMSProcessingInstruction.target;
end;

procedure TMSXMLProcessingInstruction.set_Data(const data : DomString);
begin
  fMSProcessingInstruction.data := data;
end;

function TMSXMLProcessingInstruction.get_Data : DomString;
begin
  result := fMSProcessingInstruction.data;
end;


(*
 * TMSXMLEntityReference
*)
constructor TMSXMLEntityReference.create(
        msEntityReference : IXMLDOMEntityReference);
begin
  inherited create(msEntityReference);
  fMSEntityReference := msEntityReference;
end;

destructor TMSXMLEntityReference.destroy;
begin
  fMSEntityReference := nil;
  inherited destroy;
end;


(*
 * TMSXMLEntity
*)
constructor TMSXMLEntity.create(msEntity : IXMLDOMEntity);
begin
  inherited create(msEntity);
  fMSEntity := msEntity;
end;

destructor TMSXMLEntity.destroy;
begin
  fMSEntity := nil;
  inherited destroy;
end;

function TMSXMLEntity.get_PublicId : DomString;
begin
  result := fMSEntity.publicId;
end;

function TMSXMLEntity.get_SystemId : DomString;
begin
  result := fMSEntity.systemId;
end;

function TMSXMLEntity.get_NotationName : DomString;
begin
  result := fMSEntity.notationName;
end;

(*
 * TMSXMLNotation
*)
constructor TMSXMLNotation.create(msNotation : IXMLDOMNotation);
begin
  inherited create(msNotation);
  fMSNotation := msNotation;
end;

destructor TMSXMLNotation.destroy;
begin
  fMSNotation := nil;
  inherited destroy;
end;

function TMSXMLNotation.get_PublicId : DomString;
begin
  result := fMSNotation.publicId;
end;

function TMSXMLNotation.get_SystemId : DomString;
begin
  result := fMSNotation.systemId;
end;


function TMSXMLNode.selectNode(const nodePath: WideString): IDOMNode;
var
  Node: IXMLDOMNode;
begin
  Node := fMSDomNode.selectSingleNode(nodePath);
  if Assigned(Node)
    then Result := createXMLNode(Node)
    else Result := nil;
end;

function TMSXMLNode.selectNodes(const nodePath: WideString): IDOMNodeList;
var
  NodeList: IXMLDOMNodeList;
begin
  NodeList := fMSDomNode.selectNodes(nodePath);
  if Assigned(NodeList)
    then Result :=  TMSXMLNodeList.Create(NodeList)
    else Result := nil;
end;

initialization
  {register non-threading aware factory}
  registerDomVendorFactory(TMSXMLDocumentBuilderFactory.create(false));
  {register Free-threading factory}
  registerDomVendorFactory(TMSXMLDocumentBuilderFactory.create(true));

end.
