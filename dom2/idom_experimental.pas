unit idom_experimental;
//$Id: idom_experimental.pas,v 1.3 2002-02-11 01:27:24 pkozelka Exp $
(*
 * Experimental extensions to the DOM Level 2 specification.
 *
 * This file is intended to hold definitions of all the interfaces that are not
 * specified in the DOM Level 2 Recommendation, but are needed for the real life
 * programming.
 *
 * Licensing: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * This unit was created by extracting all non-standard interfaces from idom2.
 *
 * Developers:
 *   - the LIBXML2-PAS development team <libxml2-pas-devel@lists.sourceforge.net>
 *   namely
 *   - Martijn Brinkers <m.brinkers@pobox.com>
 *   - Uwe Fechner <ufechner@csi.com>
 *   - Petr Kozelka <pkozelka@email.cz>
 *)

interface

uses
  Classes,
  idom2;

type
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
    function  load(source: DOMString) : Boolean;
    function  loadFromStream(const stream : TStream) : Boolean;

    (*
     * Loads and parses the given XML string
     * @Param value The xml string to parse
     * @Returns The newly created document
     * @Raises DomException
    *)
    function  loadxml(const value : DOMString) : Boolean;

    procedure save(destination: DOMString);
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
  IDomParseOptions = interface
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
    procedure registerNs(const prefix : DomString; const uri : DomString);
  end;

  IDomNodeEx = interface(IDomNode)
    ['{17D937A2-C6EE-448F-8530-221D744AC083}']
    { Property Acessors }
    //function get_text: DOMString; safecall;
    //function get_xml: DOMString; safecall;
    //procedure set_text(const Value: DOMString); safecall;
    { Methods }
    procedure transformNode(const stylesheet: IDomNode; var output: WideString); overload;
    procedure transformNode(const stylesheet: IDomNode; var output: IDomDocument); overload;
    { Properties }
    //property text: DOMString read get_text write set_text;
    //property xml: DOMString read get_xml;
  end;

implementation

end.

