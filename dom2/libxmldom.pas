unit libxmldom;
//$Id: libxmldom.pas,v 1.107 2002-04-16 21:31:58 pkozelka Exp $
{
    ------------------------------------------------------------------------------
    This unit is an object-oriented wrapper for libxml2.
    It implements the interfaces defined in dom2.pas.

    Authors:
      Uwe Fechner <ufechner@4commerce.de>
        - submitted the original code
        - created various testcases
      Martijn Brinkers <m.brinkers@pobox.com>
        - contributed with hints, ideas, some code, and especially with
          the dom2 interface declarations
        - translated a strict testsuite from javascript code
      Petr Kozelka <pkozelka@email.cz>
        - polishing and optimization
        - complete redesign and restructuralization

    Published under a double license:
      a) the GNU Library General Public License:
         http://www.gnu.org/copyleft/lgpl.html
      b) the Mozilla Public License:
         http://www.mozilla.org/MPL/MPL-1.1.html
    ------------------------------------------------------------------------------
}

interface

uses
{$ifdef VER130} //Delphi 5
  unicode,
{$endif}
  classes,
  idom2,
  idom_experimental,
  libxml2,
  libxslt,
  libxml_impl,
  libxml_impl_utils,
  sysutils;

const
  DOMVENDOR_LIBXML = 'LIBXML';  { Do not localize }

type
  (**
   * Experimental: interface providing access to serialized form of a node.
   *)
  IDomOutput = interface ['{A372B60C-C953-4D93-8DAD-ACEB76A8D3F9}']
    function  get_xml: DomString;
  end;

  { TGDOMNode }

  TGDOMNode = class(TLDomNodeExtension, IDomNodeSelect, IDomOutput)
  protected //IDomNodeSelect
    function  selectNode(const nodePath: DomString): IDomNode;
    function  selectNodes(const nodePath: DomString): IDomNodeList;
    procedure RegisterNS(const prefix, namespaceURI: DomString);
  protected //IDomOutput
    function  get_xml: DomString;
  end;

  { TGDOMXPathNodeList }

  TGDOMXPathNodeList = class(TLDOMObject, IDomNodeList)
  private
    FXPathCtxt: xmlXPathContextPtr;
    FXPathObj: xmlXPathObjectPtr;
    FQuery: String;
    procedure Eval;
  protected //IDomNodeList
    function get_item(index: Integer): IDomNode;
    function get_length: Integer;
  protected
    constructor Create(aBaseNode: TGDOMNode; aQuery: String);
  public
    destructor Destroy; override;
  end;

  { TGDOMDocument }

  TGDOMDocument = class(TLDomDocument, IDomDocument, IDomParseOptions, IDomPersist, IDomNode, IDomOutput)
  private
    fAsync: boolean;              //for compatibility, not really supported
    fPreserveWhiteSpace: boolean; //difficult to support
    fResolveExternals: boolean;   //difficult to support
    fValidate: boolean;           //check if default is ok
  protected //IDomParseOptions
    function  get_async: Boolean;
    function  get_preserveWhiteSpace: Boolean;
    function  get_resolveExternals: Boolean;
    function  get_validate: Boolean;
    procedure set_async(aValue: Boolean);
    procedure set_preserveWhiteSpace(aValue: Boolean);
    procedure set_resolveExternals(aValue: Boolean);
    procedure set_validate(aValue: Boolean);
  protected //IDomPersist
    function  asyncLoadState: Integer;
    function  loadFromStream(const stream: TStream): Boolean;
    procedure save(aUrl: DomString);
    procedure saveToStream(const stream: TStream);
    procedure set_OnAsyncLoad(const Sender: TObject; EventHandler: TAsyncEventHandler);
    function  IDomPersist.loadxml = parse;
  protected //IDomOutput
    function  get_xml: DomString;
  protected //override
    function  internalParse(var aCtxt: xmlParserCtxtPtr): xmlDocPtr; override;
  end;

implementation

{ TGDOMNode }

function TGDOMNode.get_xml: DomString;
var
  buf: xmlBufferPtr;
begin
  buf := xmlBufferCreate;
  xmlNodeDump(buf, LDomNode.requestNodePtr.doc, LDomNode.MyNode, 0, 1);
  Result := UTF8Decode(buf.content);
  xmlBufferFree(buf);
end;

procedure TGDOMNode.RegisterNS(const prefix, namespaceURI: DomString);
//var uprefix, uuri: String;
begin
//  uprefix := UTF8Encode(prefix);
//  uuri := UTF8Encode(namespaceURI);
//  checkNsName(uprefix, 'test', uuri);
//  xmlXPathRegisterNs(ctxt, uprefix, uuri);
//  xmlXPathRegisteredNsCleanup(ctxt);
end;

function TGDOMNode.selectNode(const nodePath: DomString): IDomNode;
// todo: raise  exceptions
//       a) if invalid nodePath expression
//       b) if Result type <> nodelist
var
	ctxt: xmlXPathContextPtr;
	rv: xmlXPathObjectPtr;
	node: xmlNodePtr;
begin
	ctxt := xmlXPathNewContext(LDomNode.MyNode.doc);
	rv := xmlXPathEval(PChar(UTF8Encode(nodePath)), ctxt);
	Result := nil;
	if (rv=nil) then exit;
	if (rv.type_ = XPATH_NODESET) then begin
		if (rv.nodesetval.nodeNr > 0) then begin
			node := rv.nodesetval.nodeTab^;
			Result := GetDomObject(node) as IDomNode;
		end;
	end;
	xmlXPathFreeObject(rv);
end;

function TGDOMNode.selectNodes(const nodePath: DomString): IDomNodeList;
begin
  Result := TGDOMXPathNodeList.Create(self, UTF8Encode(nodePath));
end;

{ TGDOMXPathNodeList }

constructor TGDOMXPathNodeList.Create(aBaseNode: TGDOMNode; aQuery: String);
begin
  inherited Create;
  DomAssert(aBaseNode<>nil, HIERARCHY_REQUEST_ERR, 'XPath query must have a parent');
  FXPathCtxt := xmlXPathNewContext(aBaseNode.LDomNode.MyNode.doc);
  FXPathCtxt.node := aBaseNode.LDomNode.MyNode;
  FQuery := aQuery;
  Eval;
end;

destructor TGDOMXPathNodeList.Destroy;
begin
	if (FXPathObj<>nil) then begin
    xmlXPathFreeObject(FXPathObj);
  end;
  xmlXPathFreeContext(FXPathCtxt);
  inherited;
end;

(**
 * This function re-evaluates the query against the base node.
 * The purpose of having it is, to achieve DOM requirement that
 * all nodelists are 'live'. Later (but very soon) we should call it in get_item
 * and get_length whenever any tree change is detected after the last call. [pk]
 *)
procedure TGDOMXPathNodeList.Eval;
begin
	if (FXPathObj<>nil) then begin
    xmlXPathFreeObject(FXPathObj);
  end;
  FXPathObj := xmlXPathEvalExpression(PChar(FQuery), FXPathCtxt);
  DomAssert(FXPathObj<>nil, SYNTAX_ERR, 'XPath object does not exist');
  if (FXPathObj.type_ <> XPATH_NODESET) then begin
    DomAssert(false, INVALID_ACCESS_ERR, 'XPath object is not a nodeset');
    xmlXPathFreeObject(FXPathObj);
    FXPathObj := nil;
  end;
end;

function TGDOMXPathNodeList.get_item(index: Integer): IDomNode;
begin
  DomAssert(index>=0, INVALID_ACCESS_ERR, 'Index below zero');
  DomAssert(index<FXPathObj.nodesetval.nodeNr, INVALID_ACCESS_ERR, 'Index too high');
  Result := GetDomObject(xmlXPathNodeSetItem(FXPathObj.nodesetval, index)) as IDomNode;
end;

function TGDOMXPathNodeList.get_length: Integer;
begin
  Result := xmlXPathNodeSetGetLength(FXPathObj.nodesetval);
end;

{ TGDOMDocument }

function TGDOMDocument.get_async: Boolean;
begin
  Result := fAsync;
end;

function TGDOMDocument.get_preserveWhiteSpace: Boolean;
begin
  Result := fPreserveWhiteSpace;
end;

function TGDOMDocument.get_resolveExternals: Boolean;
begin
  Result := fResolveExternals;
end;

function TGDOMDocument.get_validate: Boolean;
begin
  Result := fValidate;
end;

procedure TGDOMDocument.set_async(aValue: Boolean);
begin
  fAsync := aValue;
end;

procedure TGDOMDocument.set_preserveWhiteSpace(aValue: Boolean);
begin
  fPreserveWhiteSpace := aValue;
end;

procedure TGDOMDocument.set_resolveExternals(aValue: Boolean);
begin
  fResolveExternals := aValue;
end;

procedure TGDOMDocument.set_validate(aValue: Boolean);
begin
  fValidate := aValue;
end;

function TGDOMDocument.asyncLoadState: Integer;
begin
  Result := 0;
end;

function TGDOMDocument.loadFromStream(const stream: TStream): Boolean;
begin
  DomAssert(False, NOT_SUPPORTED_ERR);
  Result := False;
end;

procedure TGDOMDocument.save(aUrl: DomString);
var
  sz: Integer;
begin
  sz := xmlSaveFileEnc(PChar(UTF8Encode(aUrl)), GDoc, GDoc.encoding);
  DomAssert(sz>0, 22); //DIRTY // write error
end;

procedure TGDOMDocument.saveToStream(const stream: TStream);
begin
  DomAssert(False, NOT_SUPPORTED_ERR);
end;

procedure TGDOMDocument.set_OnAsyncLoad(const Sender: TObject;
  EventHandler: TAsyncEventHandler);
begin
  DomAssert(False, NOT_SUPPORTED_ERR);
end;

function TGDOMDocument.get_xml: DomString;
var
	p: PxmlChar;
	sz: Integer;
begin
  xmlDocDumpMemory(requestDocPtr, p, @sz);
  Result := UTF8Decode(p);
  xmlFree(p);
end;

function TGDOMDocument.internalParse(var aCtxt: xmlParserCtxtPtr): xmlDocPtr;
begin
  //todo: preserve whitespace
  //todo: async (separate thread)
  //todo: resolveExternals
  // validation
  if fValidate then begin
    aCtxt.validate := -1;
  end else begin
    aCtxt.validate := 0;
  end;
  xmlParseDocument(aCtxt);
  if (aCtxt.wellFormed=0) then begin
    xmlFreeDoc(aCtxt.myDoc);
    aCtxt.myDoc := nil;
  end;
  Result := aCtxt.myDoc;
end;

initialization
  GlbNodeClasses[XML_DOCUMENT_NODE] := TGDOMDocument;
  GlbNodeExtensionClass := TGDOMNode;
  RegisterDomVendorFactory(TLDomDocumentBuilderFactory.Create(DOMVENDOR_LIBXML, TLDomDocumentBuilder));
end.

