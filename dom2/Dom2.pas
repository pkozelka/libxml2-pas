unit Dom2;
(*
 * Interface specifications for Dom level 2.
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
 * The Initial Developers of the Original Code are:

 *   - Martijn Brinkers (m.brinkers@pobox.com)
 *   - Uwe Fechner (ufechner@csi.com)
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
 * for DOM specs see:
 * http://www.w3.org/TR/2000/REC-DOM-Level-2-Core-20001113/
 *
*)

interface

uses
  SysUtils,
  classes;

const

  (*
   * The official DOM specs works with Integer values for Exceptions.
   * These Integer values are provided for supporting DOM implementations
   * that work with Integer values. Conversion routines are provided to convert
   * from TExceptionType <-> Integer
  *)

  (*
   * If index or size is negative, or greater than the allowed value
  *)
  INDEX_SIZE_ERR = 1;

  (*
   * If the specified range of text does not fit into a DOMString
  *)
  DOMSTRING_SIZE_ERR = 2;

  (*
   * If any node is inserted somewhere it doesn't belong
  *)
  HIERARCHY_REQUEST_ERR = 3;

  (*
   * If a node is used in a different document than the one that created it
   * (that doesn't support it)
  *)
  WRONG_DOCUMENT_ERR = 4;

  (*
   * If an invalid or illegal character is specified, such as in a name.
   * See production 2 in the XML specification for the definition of a legal
   * character, and production 5 for the definition of a legal name character.
  *)
  INVALID_CHARACTER_ERR = 5;

  (*
   * If data is specified for a node which does not support data
  *)
  NO_DATA_ALLOWED_ERR = 6;

  (*
   * If an attempt is made to modify an object where modifications are not
   * allowed
  *)
  NO_MODIFICATION_ALLOWED_ERR = 7;

  (*
   * If an attempt is made to reference a node in a context where it does not
   * exist
  *)
  NOT_FOUND_ERR = 8;

  (*
   * If the implementation does not support the requested type of object or
   * operation
  *)
  NOT_SUPPORTED_ERR = 9;

  (*
   * If an attempt is made to add an attribute that is already in use elsewhere
  *)
  INUSE_ATTRIBUTE_ERR = 10;

  (*
   * If an attempt is made to use an object that is not, or is no longer, usable
  *)
  INVALID_STATE_ERR = 11;

  (*
   * If an invalid or illegal string is specified
  *)
  SYNTAX_ERR = 12;

  (*
   * If an attempt is made to modify the type of the underlying object
  *)
  INVALID_MODIFICATION_ERR = 13;

  (*
   * If an attempt is made to create or change an object in a way which is
   * incorrect with regard to namespaces
  *)
  NAMESPACE_ERR = 14;

  (*
   * If a parameter or an operation is not supported by the underlying object
  *)
  INVALID_ACCESS_ERR = 15;


  (*
   * The official DOM specs works with Integer values for Node Types.
   * These Integer values are provided for supporting DOM implementations
   * that work with Integer values. Conversion routines are provided to convert
   * from TNodeType <-> Integer
  *)
  (*
   * The node is an IDomElement
  *)
  ELEMENT_NODE = 1;

  (*
   * The node is an IDomAttr
  *)
  ATTRIBUTE_NODE = 2;

  (*
   * The node is a IDomText node
  *)
  TEXT_NODE = 3;

  (*
   * The node is a IDomCDATASection
  *)
  CDATA_SECTION_NODE = 4;

  (*
   * The node is an IDomEntityReference
  *)
  ENTITY_REFERENCE_NODE = 5;

  (*
   * The node is an IDomEntity
  *)
  ENTITY_NODE = 6;

  (*
   * The node is a IDomProcessingInstruction
  *)
  PROCESSING_INSTRUCTION_NODE = 7;

  (*
   * The node is a IDomComment
  *)
  COMMENT_NODE = 8;

  (*
   * The node is a IDomDocument
  *)
  DOCUMENT_NODE = 9;

  (*
   * The node is a IDomDocumentType
  *)
  DOCUMENT_TYPE_NODE = 10;

  (*
   * The node is a IDomDocumentFragment
  *)
  DOCUMENT_FRAGMENT_NODE = 11;

  (*
   * The node is a IDomNotation
  *)
  NOTATION_NODE = 12;

type

  DomString    = WideString;
  DomTimeStamp = Int64;

  (*
   * Although strict DOM specs works with constants for node types, enums are
   * used. For explanation of the Node Types see comments above.
   *
   * See functions: domNodeTypeToOrd and domOrdToNodeType for conversion to and
   * from constants to the enum nodetype
  *)
  TNodeType = (ntUndefined,
               ntElementNode,
               ntAttributeNode,
               ntTextNode,
               ntCDataSectionNode,
               ntEntityReferenceNode,
               ntEntityNode,
               ntProcessingInstructionNode,
               ntCommenNode,
               ntDocumentNode,
               ntDocumentTypeNode,
               ntDocumentFragmentNode,
               ntNotationNode);

  (* added for compatibillity with borland xml *)             
  DomNodeType = TNodeType;

  (*
   * Although strict DOM specs works with constants for Exception types, enums
   * are used. For explanation of Exception Types see comments above
  *)
  TExceptionType = (etUndefined,
                    etIndexSizeErr,
                    etDomStringSizeErr,
                    etHierarchyRequestErr,
                    etWrongDocumentErr,
                    etInvalidCharacterErr,
                    etNoDataAllowedErr,
                    etNoModificationAllowedErr,
                    etNotFoundErr,
                    etNotSupportedErr,
                    etInuseAttributeErr,
                    etInvalidStateErr,
                    etSyntaxErr,
                    etInvalidModificationErr,
                    etNamespaceErr,
                    etInvalidAccessErr,
                    etParseErr);

  EDomException = class(Exception)
    private
      fCode : TExceptionType;
    public
      constructor create(code : TExceptionType; const msg : DomString); overload;
      constructor createFmt(
              code       : TExceptionType;
              const msg  : string;
              const args : array of const); overload;
      property code : TExceptionType read fCode;
  end;

  type TAsyncEventHandler = procedure(
          sender         : TObject;
          asyncLoadState : Integer) of object;

  IDomDocumentType = interface;
  IDomDocument     = interface;
  IDomNodeList     = interface;
  IDomNamedNodeMap = interface;
  IDomElement      = interface;

  IDomImplementation  = interface
    ['{A372B60C-C953-4D93-8DAD-EBCB76A8D3F9}']

    (*
      @param Feature [in]
      @param Version [in]
    *)
    function hasFeature(
            const feature : DomString;
            const version : DomString) : Boolean;
    (*
      @param QualifiedName [in]
      @param PublicId [in]
      @param SystemId [in]
      @Raises EDomException
    *)
    function createDocumentType(
            const qualifiedName : DomString;
            const publicId      : DomString;
            const systemId      : DomString) : IDomDocumentType;

    (*
     * @param NamespaceURI [in]
     * @param QualifiedName [in]
     * @param DocType [in]
     * @Raises EDomException
    *)
    function createDocument(
            const namespaceURI  : DomString;
            const qualifiedName : DomString;
            docType             : IDomDocumentType) : IDomDocument;
  end;

  IDomNode = interface
    ['{D415EB3C-463D-4F6D-BD1F-168B8A364666}']
    {property setters/getters}

    function  get_NodeName : DomString;

    (*
     * @param Value [in]
     * @Raises EDomException
    *)
    procedure set_NodeValue(const value : DomString);

    (*
     * @Raises EDomException
    *)
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

    (*
     * @param Prefix [in]
     * @Raises EDomException
    *)
    procedure set_Prefix(const prefix : DomString);
    function  get_Prefix : DomString;

    function  get_LocalName : DomString;

    {methods}

    (*
     * @param NewChild [in]
     * @param RefChild [in]
     * @Raises EDomException
    *)
    function  insertBefore(const newChild, refChild : IDomNode) : IDomNode;

    (*
     * @param NewChild [in]
     * @param OldChild [in]
     * @Raises EDomException
    *)
    function  replaceChild(const newChild, oldChild : IDomNode) : IDomNode;

    (*
     * @param OldChild [in]
     * @Raises EDomException
    *)
    function  removeChild(const oldChild : IDomNode) : IDomNode;

    (*
     * @param NewChild [in]
     * @Raises EDomException
    *)
    function  appendChild(const newChild : IDomNode) : IDomNode;

    function  hasChildNodes : Boolean;

    function  hasAttributes : Boolean;

    (*
     * @param Deep [in]
    *)
    function  cloneNode(deep : Boolean) : IDomNode;

    procedure normalize;

    (*
     * @param Feature [in]
     * @param Version [in]
    *)
    function  isSupported(
            const feature : DomString;
            const version : DomString) : Boolean;

    {properties}
    property nodeName        : DomString read get_NodeName;

    (*
     * @Raises EDomException
    *)
    property nodeValue       : DomString read get_NodeValue write set_NodeValue;
    property nodeType        : TNodeType read get_NodeType;
    property parentNode      : IDomNode read get_ParentNode;
    property childNodes      : IDomNodeList read get_ChildNodes;
    property firstChild      : IDomNode read get_FirstChild;
    property lastChild       : IDomNode read get_LastChild;
    property previousSibling : IDomNode read get_PreviousSibling;
    property nextSibling     : IDomNode read get_NextSibling;
    property attributes      : IDomNamedNodeMap read get_Attributes;
    property ownerDocument   : IDomDocument read get_OwnerDocument;
    property namespaceURI    : DomString read get_NamespaceURI;

    (*
     * @Raises EDomException
    *)
    property prefix          : DomString read get_Prefix write set_Prefix;
    property localName       : DomString read get_LocalName;
  end;


  IDomNodeList = interface
    ['{9CA29D2D-9B7B-40F2-913D-440FECE581BE}']
    {property setters/getters}
    function  get_Length : Integer;

    {methods}

    (*
     * @Param Index [in]
    *)
    function  get_Item(index : Integer) : IDomNode;

    {properties}
    property length : Integer read get_Length;
    property item[index : Integer] : IDomNode read get_Item; default;

  end;

  IDomNamedNodeMap = interface
    ['{B8879EB5-E22F-4F75-A4D3-D83DD2380D2D}']
    {property setters/getters}

    (*
     * @Param Index [in]
    *)
    function  get_Item(index : Integer) : IDomNode;
    function  get_Length : Integer;

    {methods}

    (*
     * @Param Name [in]
    *)
    function  getNamedItem(const name : DomString) : IDomNode;

    (*
     * @Param Arg [in]
     * @Raises EDomException
    *)
    function  setNamedItem(const newItem : IDomNode) : IDomNode;

    (*
     * @Param Name [in]
     * @Raises EDomException
    *)
    function  removeNamedItem(const name : DomString) : IDomNode;

    (*
     * @Param NamespaceURI [in]
     * @Param LocalName [in]
     * @Raises EDomException
    *)
    function  getNamedItemNS(
            const namespaceURI : DomString;
            const localName    : DomString) : IDomNode;

    (*
     * @Param Arg [in]
     * @Raises EDomException
    *)
    function  setNamedItemNS(const NewItem : IDomNode) : IDomNode;

    (*
     * @Param NamespaceURI [in]
     * @Param LocalName [in]
     * @Raises EDomException
    *)
    function  removeNamedItemNS(
            const namespaceURI : DomString;
            const localName    : DomString) : IDomNode;

    {properties}
    property item[index : Integer] : IDomNode read get_Item; default;
    property namedItem[const name : DomString] : IDomNode read getNamedItem;
    property length : Integer read get_Length;
  end;


  IDomCharacterData = interface(IDomNode)
    ['{2FE51653-C541-40FB-8962-9150E40211A6}']
    {property setters/getters}

    (*
     * @Param [in] Data
     * @Raises EDomException
    *)
    procedure set_Data(const data : DomString);

    (*
     * @Raises EDomException
    *)
    function  get_Data : DomString;

    function  get_Length : Integer;

    {methods}

    (*
     * @Param Offset [in]
     * @Param Count [in]
     * @Raises EDomException
    *)
    function  subStringData(offset : Integer; count : Integer) : DomString;
    (*
     * @Param Arg [in]
     * @Raises EDomException
    *)
    procedure appendData(const arg : DomString);

    (*
     * @Param Offset [in]
     * @Param Arg [in]
     * @Raises EDomException
    *)
    procedure insertData(offset : Integer; const arg : DomString);

    (*
     * @Param Offset [in]
     * @Param Count [in]
     * @Raises EDomException
    *)
    procedure deleteData(offset : Integer; count : Integer);

    (*
     * @Param Offset [in]
     * @Param Count [in]
     * @Param Arg [in]
     * @Raises EDomException
    *)
    procedure replaceData(
            offset    : Integer;
            count     : Integer;
            const arg : DomString);

    {properties}

    (*
     * @Raises EDomException
    *)
    property data : DOMString read get_Data write set_Data;

    property length : Integer read get_Length;
  end;

  IDomAttr = interface(IDomNode)
    ['{AD6B078B-C1D0-461A-AD51-45E7D72370E2}']

    {property setters/getters}

    function  get_Name : DomString;
    function  get_Specified : Boolean;

    (*
     * @Param Value [in]
     * @Raises EDomException
    *)
    procedure set_Value(const value : DomString);
    function  get_Value : DomString;
    function  get_OwnerElement : IDomElement;

    {properties}

    property name : DomString read get_Name;
    property specified : Boolean read get_Specified;
    (*
     * @Raises EDomException on write
    *)
    property value : DomString read get_Value write set_Value;
    property ownerElement : IDomElement read get_OwnerElement;
  end;

  IDomElement = interface(IDomNode)
    ['{955D5EEC-6160-4AC9-ADFB-767E6AC09511}']

    {property setters/getters}
    function  get_TagName : DomString;

    {methods}

    (**
     * @Param [in] Name
    *)
    function  getAttribute(const name : DomString) : DomString;

    (**
     * @Raises EDomException
    *)
    procedure setAttribute(const name : DomString; const value : DomString);

    (**
     * @Param [in] Name
     * @Raises EDomException
    *)
    procedure removeAttribute(const name : DomString);

    (**
     * @Param Name [in]
     * @Raises EDomException
    *)
    function  getAttributeNode(const name : DomString) : IDomAttr;

    (**
     * @Param NewAttr [in]
     * @Raises EDomException
    *)
    function setAttributeNode(const newAttr : IDomAttr) : IDomAttr;

    (**
     * @Param OldAttr [in]
     * @Raises EDomException
    *)
    function removeAttributeNode(const oldAttr : IDomAttr) : IDomAttr;

    (**
     * @Param Name [in]
    *)
    function  getElementsByTagName(const name : DomString) : IDomNodeList;

    (*
     * @Param NamespaceURI [in]
     * @Param LocalName [in]
    *)
    function  getAttributeNS(
            const namespaceURI : DomString;
            const localName    : DomString) : DomString;

    (*
     * @Param NamespaceURI [in]
     * @Param QualifiedName [in]
     * @Param Value [in]
     * @Raises EDomException
    *)
    procedure setAttributeNS(
            const namespaceURI  : DomString;
            const qualifiedName : DomString;
            const value         : DomString);

    (*
     * @Param NamespaceURI [in]
     * @Param LocalName [in]
     * @Raises EDomException
    *)
    procedure removeAttributeNS(
            const namespaceURI : DomString;
            const localName    : DomString);
    (*
     * @Param NamespaceURI [in]
     * @Param LocalName [in]
    *)
    function  getAttributeNodeNS(
            const namespaceURI : DomString;
            const localName    : DomString) : IDomAttr;

    (*
     * @Param NewAttr [in]
     * @Raises EDomException
    *)
    function  setAttributeNodeNS(const newAttr : IDomAttr) : IDomAttr;

    (*
     * @Param NamespaceURI [in]
     * @Param LocalName [in]
    *)
    function  getElementsByTagNameNS(
            const namespaceURI : DomString;
            const localName    : DomString) : IDomNodeList;

    (*
     * @Param Name [in]
    *)
    function  hasAttribute(const name : DomString) : Boolean;

    (*
     * @Param NamespaceURI [in]
     * @Param LocalName [in]
    *)
    function  hasAttributeNS(
            const namespaceURI : DomString;
            const localName    : DomString) : Boolean;

    {properties}
    property tagName : DomString  read get_TagName;
  end;

  IDomText = interface(IDomCharacterData)
    ['{61D2EAAC-284E-4B5B-8C34-66CD54C1AE29}']

    {methods}

    (*
     * @Param Offset [in]
     * @Raises EDomException
    *)
    function splitText(offset : Integer) : IDomText;
  end;

  IDomComment = interface(IDomCharacterData)
    ['{18F226C0-75D3-41FA-980B-580E26F2F028}']
  end;

  IDomCDataSection = interface(IDomText)
    ['{79437C77-C14C-4E4D-96E7-2F1273DC8E71}']
  end;

  IDomDocumentType = interface(IDomNode)
    ['{31C37A3A-82A0-4646-AF50-06683D36841D}']
    {property setters/getters}

    function  get_Name : DomString;
    function  get_Entities : IDomNamedNodeMap;
    function  get_Notations : IDomNamedNodeMap;
    function  get_PublicId : DomString;
    function  get_SystemId : DomString;
    function  get_InternalSubset : DomString;

    {properties}

    property name : DomString read get_Name;
    property entities : IDomNamedNodeMap read get_Entities;
    property notations : IDomNamedNodeMap read get_Notations;
    property publicId : DomString read get_PublicId;
    property systemId : DomString read get_SystemId;
    property internalSubset : DomString read get_InternalSubset;
  end;

  IDomNotation = interface(IDomNode)
    ['{C34654CA-12EC-4254-A2C2-64EAB3B63095}']

    {property setters/getters}

    function  get_PublicId : DomString;
    function  get_SystemId : DomString;

    {properties}

    property publicId : DomString read get_PublicId;
    property systemId : DomString read get_SystemId;
  end;

  IDomEntity = interface(IDomNode)
    ['{89821990-42CB-4762-A409-31CE9D7046CD}']
    {property setters/getters}

    function  get_PublicId : DomString;
    function  get_SystemId : DomString;
    function  get_NotationName : DomString;

    {properties}

    property publicId : DomString read get_PublicId;
    property systemId : DomString read get_SystemId;
    property notationName : DomString read get_NotationName;
  end;

  IDomEntityReference = interface(IDomNode)
    ['{3E331CB7-8E7D-4B72-91D2-173CEC2F0818}']
  end;

  IDomProcessingInstruction = interface(IDomNode)
    ['{D92EF1AA-963C-41AC-8DCA-E59A71C51132}']

    {property setters/getters}

    function  get_Target : DomString;

    (*
     * @Param Data [in]
     * @Raises EDomException
    *)
    procedure set_Data(const data : DomString);
    function  get_Data : DomString;

    {properties}
    property target : DomString read get_Target;
    property data : DomString read get_Data write set_Data;
  end;

  IDomDocumentFragment = interface(IDomNode)
    ['{5C0F44E9-DC84-47AF-A757-18F87A1D9830}']
  end;

  IDomDocument = interface(IDomNode)
    ['{40062327-5F8A-475D-8404-491FE7ED4DA5}']

    {property setters/getters}

    function  get_DocType : IDomDocumentType;
    function  get_DomImplementation : IDomImplementation;
    function  get_DocumentElement : IDomElement;

    {methods}

    (*
     * @Param TagName [in]
     * @Raises EDomException
    *)
    function  createElement(const tagName : DomString) : IDomElement;

    function  createDocumentFragment : IDomDocumentFragment;

    (*
     * @Param Data [in]
    *)
    function  createTextNode(const data : DomString) : IDomText;

    (*
     * @Param Data [in]
    *)
    function  createComment(const data : DomString) : IDomComment;

    (*
     * @Param Data [in]
     * @Raises EDomException
    *)
    function  createCDataSection(const data : DomString) : IDomCDataSection;

    (*
     * @Param Target [in]
     * @Param Data [in]
     * @Raises EDomException
    *)
    function  createProcessingInstruction(
            const target : DomString;
            const data   : DomString) : IDomProcessingInstruction;

    (*
     * @Param Name [in]
     * @Raises EDomException
    *)
    function  createAttribute(const name : DomString) : IDomAttr;

    (*
     * @Param Name [in]
     * @Raises EDomException
    *)
    function  createEntityReference(const name : DomString) :
            IDomEntityReference;

    (*
     * @Param TagName [in]
    *)
    function  getElementsByTagName(const tagName : DomString) : IDomNodeList; //FE

    (*
     * @Param ImportedNode [in]
     * @Param Deep [in]
     * @Raises EDomException
    *)
    function  importNode(importedNode : IDomNode; deep : Boolean) : IDomNode;

    (*
     * @Param NamespaceURI [in]
     * @Param QualifiedName [in]
     * @Raises EDomException
    *)
    function  createElementNS(
            const namespaceURI  : DomString;
            const qualifiedName : DomString) : IDomElement;

    (*
     * @Param NamespaceURI [in]
     * @Param QualifiedName [in]
     * @Raises EDomException
    *)
    function  createAttributeNS(
            const namespaceURI  : DomString;
            const qualifiedName : DomString) : IDomAttr;

    (*
     * @Param NamespaceURI [in]
     * @Param LocalName [in]
     * @Raises EDomException
    *)
    function  getElementsByTagNameNS(
            const namespaceURI : DomString;
            const localName    : DomString) : IDomNodeList; //FE

    (*
     * @Param ElementId [in]
    *)
    function  getElementById(const elementId : DomString) : IDomElement;

    {properties}

    property docType : IDomDocumentType read get_DocType;
    {implementation is a reserved word so DomImplementation is used}
    property domImplementation : IDomImplementation read get_DomImplementation;
    property documentElement : IDomElement read get_DocumentElement;
  end;


  (****************************************************************************
   ***   the following interfaces are not part of the official DOM specs    ***
   ****************************************************************************
  *)

  (*
   * non standard DOM extension for persistency. Asynchronous operations are
   * not always supported (check IDomDocumentBuilder.hasAsyncSupport for
   * availabillity of async operations)
  *)
  IDomPersist = interface
    ['{F644523B-3F88-49BC-9B31-976FE4B8153C}']
    {property setters/getters}
    function get_xml : DOMString;

    { Methods }

    (*
     * Indicates the current state of the XML document. 
    *)
    function  asyncLoadState : Integer;

    (*
     * loads and parses the xml document from URL source.
    *)
    function  load(source : OleVariant) : Boolean;
    function  loadFromStream(const stream : TStream) : Boolean;

    (*
     * Loads and parses the given XML string
     * @Param value The xml string to parse
     * @Returns The newly created document
     * @Raises DomException
    *)
    function  loadxml(const value : DOMString) : Boolean;

    procedure save(destination : OleVariant);
    procedure saveToStream(const stream : TStream);
    procedure set_OnAsyncLoad(
            const sender : TObject;
            eventHandler : TAsyncEventHandler);

    {properties}
    property xml : DomString read get_xml;
  end;

  (*
   * IDOMParseOptions
   *)
  IDOMParseOptions = interface
    ['{FA884EC2-A131-4992-904A-0D71289FB87A}']
    { Property Acessors }
    function get_async : Boolean;
    function get_preserveWhiteSpace : Boolean;
    function get_resolveExternals : Boolean;
    function get_validate : Boolean;
    procedure set_async(value : Boolean);
    procedure set_preserveWhiteSpace(value : Boolean);
    procedure set_resolveExternals(value : Boolean);
    procedure set_validate(value : Boolean);

    { Properties }
    property async : Boolean read get_async write set_async;
    property preserveWhiteSpace : Boolean
            read get_preserveWhiteSpace
            write set_preserveWhiteSpace;
    property resolveExternals : Boolean
            read get_resolveExternals
            write set_resolveExternals;
    property validate : Boolean read get_validate write set_validate;
  end;

  (*
   * non standard DOM extension.
  *)
  IDomNodeSelect = interface
    ['{A50A05D4-3E67-44CA-9872-C80CD83A47BD}']
    function selectNode(const nodePath : DomString) : IDomNode;
    function selectNodes(const nodePath : DomString) : IDomNodeList;
  end;


  (*
   * Defines the interface to obtain DOM Document instances.
  *)
  IDomDocumentBuilder = interface
    ['{92724EDA-8951-4E46-8415-84221EAE0044}']
    {property setters/getters}
    (* true if DOM supports namespace *)
    function  get_IsNamespaceAware : Boolean;
    (* true if DOM is a validating parser *)
    function  get_IsValidating : Boolean;

    (* true if IDomPersist provides async support *)
    function  get_HasAsyncSupport : Boolean;

    (*
     * true if asbsolute URLs are supported, false if only relative or local
     * URLs are supported
    *)
    function get_HasAbsoluteURLSupport : Boolean;

    {methods}

    function  get_DomImplementation : IDomImplementation;
    function  newDocument : IDomDocument;

    (*
     * Parses the given XML string
     * @Param XML The xml to parse
     * @Returns The newly created document
     * @Raises DomException
    *)
    function  parse(const xml : DomString) : IDomDocument;

    (*
     * Loads and parses XML from url and returns a new document.
    *)
    function load(const url : DomString) : IDomDocument;

    property domImplementation : IDomImplementation read get_DomImplementation;
    (* true if DOM supports namespace *)
    property isNamespaceAware : Boolean read get_IsNamespaceAware;
    (* true if DOM is a validating parser *)
    property isValidating : Boolean read get_IsValidating;
    (* true if IDomPersist provides async support*)
    property hasAsyncSupport : Boolean read get_HasAsyncSupport;
    (*
     * true if asbsolute URLs are supported, false if only relative or local
     * URLs are supported
    *)
    property hasAbsoluteURLSupport : Boolean read get_HasAbsoluteURLSupport;
  end;

  (*
   * DomDocumentBuilder Factory for creating Vendor specified DocumentBuilder.
  *)
  IDomDocumentBuilderFactory = interface
    ['{27E9F2B1-98D6-49D0-AAE4-2B0D2DF128BE}']
    {property setters/getters}
    (* returns the vendorID under which this factory is registered *)
    function get_VendorID : DomString;

    {methods}
    (* creates a new IDomDocumentBuilder *)
    function newDocumentBuilder : IDomDocumentBuilder;

    (* the vendorID under which this factory is registered *)
    property vendorID : DomString read get_VendorID;
  end;

  (*
   * Exception class for Vendor Registration
  *)
  EDomVendorRegisterException = class(Exception);

  (*
   * Conversion from TNodeType to the official DOM specs Integer values.
   * Results in RunError is ANodeType is not an official DOM spec Node Type
   * NOTE: Should only be used for supporting DOM implementation that works with
   * integer values for Node Types.
  *)
  function domNodeTypeToOrd(nodeType : TNodeType) : Integer;

  (*
   * Conversion from the official DOM specs Integer values to TNodeType.
   * Results in RunError if AOrd is not an official DOM spec Node Type
   * NOTE: Should only be used for supporting DOM implementation that works with
   * integer values for Node Types.
  *)
  function domOrdToNodeType(domOrd : Integer) : TNodeType;

  (*
   * Conversion from TExceptionType to the official DOM specs Integer values.
   * Results in RunError is AEType is not an official DOM spec Exception Type
   * NOTE: Should only be used for supporting DOM implementation that works with
   * integer values for Exception Types.
  *)
  function domETypeToOrd(eType : TExceptionType) : Integer;

  (*
   * Conversion from the official DOM specs Integer values to TExceptionType.
   * Results in RunError if AOrd is not an official DOM spec Exception Type
   * NOTE: Should only be used for supporting DOM implementation that works with
   * integer values for Exception Types.
  *)
  function domOrdToEType(domOrd : Integer) : TExceptionType;

  (*
   * used for registering a DomcumentBuilderFactory
   * @Param AFactory the factory that need to be registered.
   * @Raise EDomVendorRegisterException if a factory has already registered with
   * the same AVendorID.
  *)
  procedure registerDomVendorFactory(factory : IDomDocumentBuilderFactory);

  (*
   * get a DomcumentBuilderFactory based on its Vendor  ID
   * @Param AVendorID the ID that uniquely specifies the DOM implementation
   * @Raise EDomVendorRegisterException if AVendorID does not exist
  *)
  function getDocumentBuilderFactory(vendorID : DomString) :
          IDomDocumentBuilderFactory;

  (*
   * equivalent to get_DocumentBuilderFactory. for compatibillity with Borland
  *)
  function getDOM(const vendorDesc : string = '') : IDOMImplementation;

implementation

type

  (*
   * Register for registering different DocumentBuilderFactories. Each
   * DocumentBuilderFactory is identified by a vendorID.
  *)
  TDomVendorRegister = class(TObject)
    private
      (* list of DocumentBuilderFactories *)
      fFactoryList : TInterfaceList;

    public
      constructor create;
      destructor destroy; override;

      (*
       * add a new DocumentBuilderFactory to the list.
       * Pre-condition:
       *   - vendorID must be set
       *   - vendorID must be unique (if not EDomVendorRegisterException)
      *)
      procedure add(domDocumentBuilderFactory : IDomDocumentBuilderFactory);

      (*
       * returns the DomDocumentBuilderFactory with id vendorId
       * if vendorId is not found then result := nil
      *)
      function get_Factory(vendorID : DomString) : IDomDocumentBuilderFactory;
  end;

var
  (*
   * global TDomVendorRegister. Used to register the domDocumentBuilderFactories
  *)
  gDomVendorRegister : TDomVendorRegister;

(******************************************************************************)
constructor TDomVendorRegister.create;
begin
  inherited create;
  fFactoryList := TInterfaceList.Create;
end;

destructor TDomVendorRegister.destroy;
begin
  fFactoryList.free;
end;

procedure TDomVendorRegister.add(
        domDocumentBuilderFactory : IDomDocumentBuilderFactory);
begin
  {check if a factory with same VendorID is already registered}
  if get_Factory(domDocumentBuilderFactory.vendorID) <> nil then
    Raise EDomVendorRegisterException.create('Vendor ID already present');
  fFactoryList.add(domDocumentBuilderFactory);
end;

function TDomVendorRegister.get_Factory(
        vendorID : DomString) : IDomDocumentBuilderFactory;
var
  i : Integer;
begin
  for i := 0 to fFactoryList.Count - 1 do
  begin
    {check the name}
    if (fFactoryList.items[i] as IDomDocumentBuilderFactory).vendorID
      =  vendorID then
    begin
      result := fFactoryList.items[i] as IDomDocumentBuilderFactory;
      exit;
    end;
  end;
  result := nil;
end;

(******************************************************************************)
(*
 * returns the global TDomVendorRegister (create on demand)
*)
function get_DomVendorRegisterSingleton : TDomVendorRegister;
begin
  if gDomVendorRegister = nil then
  begin
    gDomVendorRegister := TDomVendorRegister.create;
  end;
  result := gDomVendorRegister;
end;

(******************************************************************************)

procedure registerDomVendorFactory(factory : IDomDocumentBuilderFactory);
begin
  get_DomVendorRegisterSingleton.add(factory);
end;

(******************************************************************************)

function getDocumentBuilderFactory(
        vendorID : DomString) : IDomDocumentBuilderFactory;
var
  factory : IDomDocumentBuilderFactory;
begin
  factory := get_DomVendorRegisterSingleton.get_Factory(vendorID);
  if factory = nil then
    Raise EDomVendorRegisterException.create('Vendor ID not present');

  result := factory;
end;

function getDOM(const vendorDesc : string = '') : IDOMImplementation;
begin
  result := getDocumentBuilderFactory(VendorDesc).
      newDocumentBuilder.DOMImplementation;
end;

function domNodeTypeToOrd(nodeType : TNodeType) : Integer;
begin
  result := 0;
  case nodeType of
    ntElementNode               : result := ELEMENT_NODE;
    ntAttributeNode             : result := ATTRIBUTE_NODE;
    ntTextNode                  : result := TEXT_NODE;
    ntCDataSectionNode          : result := CDATA_SECTION_NODE;
    ntEntityReferenceNode       : result := ENTITY_REFERENCE_NODE;
    ntEntityNode                : result := ENTITY_NODE;
    ntProcessingInstructionNode : result := PROCESSING_INSTRUCTION_NODE;
    ntCommenNode                : result := COMMENT_NODE;
    ntDocumentNode              : result := DOCUMENT_NODE;
    ntDocumentTypeNode          : result := DOCUMENT_TYPE_NODE;
    ntDocumentFragmentNode      : result := DOCUMENT_FRAGMENT_NODE;
    ntNotationNode              : result := NOTATION_NODE;
  else
    runError;
  end;
end;

function domOrdToNodeType(domOrd : Integer) : TNodeType;
begin
  result := ntUndefined;
  case domOrd of
    ELEMENT_NODE                : result := ntElementNode;
    ATTRIBUTE_NODE              : result := ntAttributeNode;
    TEXT_NODE                   : result := ntTextNode;
    CDATA_SECTION_NODE          : result := ntCDataSectionNode;
    ENTITY_REFERENCE_NODE       : result := ntEntityReferenceNode;
    ENTITY_NODE                 : result := ntEntityNode;
    PROCESSING_INSTRUCTION_NODE : result := ntProcessingInstructionNode;
    COMMENT_NODE                : result := ntCommenNode;
    DOCUMENT_NODE               : result := ntDocumentNode;
    DOCUMENT_TYPE_NODE          : result := ntDocumentTypeNode;
    DOCUMENT_FRAGMENT_NODE      : result := ntDocumentFragmentNode;
    NOTATION_NODE               : result := ntNotationNode;
  else
    runError;
  end;
end;


function domETypeToOrd(eType : TExceptionType) : Integer;
begin
  result := 0;
  case eType of
    etIndexSizeErr              : result := INDEX_SIZE_ERR;
    etDomStringSizeErr          : result := DOMSTRING_SIZE_ERR;
    etHierarchyRequestErr       : result := HIERARCHY_REQUEST_ERR;
    etWrongDocumentErr          : result := WRONG_DOCUMENT_ERR;
    etInvalidCharacterErr       : result := INVALID_CHARACTER_ERR;
    etNoDataAllowedErr          : result := NO_DATA_ALLOWED_ERR;
    etNoModificationAllowedErr  : result := NO_MODIFICATION_ALLOWED_ERR;
    etNotFoundErr               : result := NOT_FOUND_ERR;
    etNotSupportedErr           : result := NOT_SUPPORTED_ERR;
    etInuseAttributeErr         : result := INUSE_ATTRIBUTE_ERR;
    etInvalidStateErr           : result := INVALID_STATE_ERR;
    etSyntaxErr                 : result := SYNTAX_ERR;
    etInvalidModificationErr    : result := INVALID_MODIFICATION_ERR;
    etNamespaceErr              : result := NAMESPACE_ERR;
    etInvalidAccessErr          : result := INVALID_ACCESS_ERR;
  else
    runError;
  end;
end;

function domOrdToEType(domOrd : Integer) : TExceptionType;
begin
  result := etUndefined;
  case domOrd of
    INDEX_SIZE_ERR              : result := etIndexSizeErr;
    DOMSTRING_SIZE_ERR          : result := etDomStringSizeErr;
    HIERARCHY_REQUEST_ERR       : result := etHierarchyRequestErr;
    WRONG_DOCUMENT_ERR          : result := etWrongDocumentErr;
    INVALID_CHARACTER_ERR       : result := etInvalidCharacterErr;
    NO_DATA_ALLOWED_ERR         : result := etNoDataAllowedErr;
    NO_MODIFICATION_ALLOWED_ERR : result := etNoModificationAllowedErr;
    NOT_FOUND_ERR               : result := etNotFoundErr;
    NOT_SUPPORTED_ERR           : result := etNotFoundErr;
    INUSE_ATTRIBUTE_ERR         : result := etInuseAttributeErr;
    INVALID_STATE_ERR           : result := etInvalidStateErr;
    SYNTAX_ERR                  : result := etSyntaxErr;
    INVALID_MODIFICATION_ERR    : result := etInvalidModificationErr;
    NAMESPACE_ERR               : result := etNamespaceErr;
    INVALID_ACCESS_ERR          : result := etInvalidAccessErr;
  else
    runError;
  end;
end;

(******************************************************************************)

constructor EDomException.create(code : TExceptionType; const msg : DomString);
begin
  inherited create(msg);
  fCode := code;
end;

constructor EDomException.createFmt(
        code       : TExceptionType;
        const msg  : string;
        const args : array of const);
begin
  inherited createFmt(msg, args);
  fCode := code;
end;

end.
