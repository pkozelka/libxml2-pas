unit idom2_ext;

interface

uses idom2;

type
  { IDomNodeCompare }

  // this interfaces implements the dom3 method IsSameNode
  // it is neccessary to use it with libxml2, because there can be
  // several interfaces pointing to the same node

  IDomNodeCompare = interface
    ['{ED63440C-6A94-4267-89A9-E093247F10F8}']
    function IsSameNode(node: IDomNode): boolean;
  end;

  {IDomNodeSelect} 

  // this interface makes it possible to do xpath queries
  // to optain a nodelist;
  // the nodepath must be a valid xpath-expression according to
  // http://www.w3.org/TR/xpath;
  // an exception is raised, if the result type is not a node or a nodelist
  //
  // if you want to use namespace-prefixes in your xpath expression, you
	// have to register them before using them with the method registerNs
	// if you use msxml, this works with one namespace only
	// libxmldom excepts any number of registered namespaces
	// they are stored in the document, not in the node
  //
  // see also: http://www.zvon.org/xxl/XPathTutorial/General/examples.html
  // @raises: EDomException, SYNTAX_ERROR

  IDomNodeSelect = interface
    ['{A50A05D4-3E67-44CA-9872-C80CD83A47BD}']
    function selectNode(const nodePath : DomString) : IDomNode;
    function selectNodes(const nodePath : DomString) : IDomNodeList;
    procedure registerNs(const prefix : DomString; const uri : DomString);
  end;


  { IDomNodeExt }
	
	// this interface is similar to the interface IDomNodeEx from Borland,
  // but not the same, therefore a slightly different name is used
	// it provides methods for xslt transformation (transformNode)
	// for accessing the text-value of an element (similar to textcontent in dom3)
	// and for obtaining the string-value of a node (property xml)
  
	IDomNodeExt = interface(IDomNode)
    ['{1B41AE3F-6365-41FC-AFDD-26BC143F9C0F}']
    { Property Acessors }
    function get_text: DomString;
    function get_xml: DomString;
    procedure set_text(const Value: DomString);
    { Methods }
    procedure transformNode(const stylesheet: IDomNode; var output: DomString); overload;
    procedure transformNode(const stylesheet: IDomNode; var output: IDomDocument);
      overload;
    { Properties }
    property Text: DomString read get_text write set_text;
    property xml: DomString read get_xml;
  end;

   {IDomOutputOptions}
	 
	 // this interface enables using the output-options, provided by libxml2
	 // it will be replaced by dom3 methods in the future
	 
  IDomOutputOptions = interface
    ['{B2ECC3F1-CC9B-4445-85C6-3D62638F7835}']
    { Property Acessors }
    function get_prettyPrint: boolean;
    function get_encoding: DomString;
    function get_parsedEncoding: DomString;
    function get_compressionLevel: integer;
    procedure set_prettyPrint(prettyPrint: boolean);
    procedure set_encoding(encoding: DomString);
    procedure set_compressionLevel(compressionLevel: integer);
    { Properties }
    property prettyPrint: boolean read get_prettyPrint write set_prettyPrint;
    property encoding: DomString read get_encoding write set_encoding;
    property parsedEncoding: DomString read get_parsedEncoding;
    property compressionLevel: integer read get_compressionLevel write set_compressionLevel;
  end;

  {IDomDebug}
  // this interface enables it, to get the count of currently existing documents
  // for debugging purposes
  IDomDebug = interface
  ['{D5DE14B0-C454-4E75-B6CE-4E8C07FAC9BA}']
    { Property Acessors }
    function get_doccount: integer;
    procedure set_doccount(doccount: integer);
    { Properties }
    property doccount: integer read get_doccount write set_doccount;
  end;

implementation
end.
