unit XPTest_idom2_TestXPath;

interface

uses
  TestFrameWork,
  idom2,
  idom2_ext,
  SysUtils,
  domSetup,
  XPTest_idom2_Shared,
  ActiveX,
  Dialogs;

const n = 10;

type
  TTestXPath = class(TTestCase)
  private
    impl: IDomImplementation;
    doc: IDomDocument;
    node: IDomNode;
    elem: IDomElement;
    attr: IDomAttr;
    Text: IDomText;
    nodelist: IDomNodeList;
    cdata: IDomCDATASection;
    comment: IDomComment;
    pci: IDomProcessingInstruction;
    docfrag: IDomDocumentFragment;
    ent: IDomEntity;
    entref: IDomEntityReference;
    select: IDomNodeSelect;
    nnmap: IDomNamedNodeMap;
    nsuri: string;
    prefix: string;
    Name: string;
    Data: string;
    function getFqname: string;
    procedure populateDocument;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure selectNodes;
    procedure selectNodesOneNs;
    procedure selectNodes2;
    procedure selectNodes3a;
    procedure selectNodes3b;
    procedure selectNodes3NS;
    procedure selectNodes_self;
    procedure selectNodes_any;
    procedure selectNodes_any_anywhere;
    procedure selectNodes_any_child_of_any_child;
    procedure selectNodes_child_named_child_of_any_child;
    procedure selectNodes_by_name;
    procedure selectNodes_any_by_condition;
    procedure selectNodes_any_anywhere_by_condition;
    procedure selectNodes4;
    property fqname: string read getFqname;
  end;

implementation

{ TTestXPath }

function TTestXPath.getFqname: string;
begin
  if prefix = '' then Result := Name
  else Result := prefix + ':' + Name;
end;

procedure TTestXPath.populateDocument;
var
  i: integer;
begin
  // populate the document ...
  // append n simple nodes to documentElement
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name);
    doc.documentElement.appendChild(elem);
  end;
  // append n nodes with an attribute to documentElement
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name);
    elem.setAttribute(Name, 'lion');
    doc.documentElement.appendChild(elem);
  end;
  // append n nodes with child with an attribute to documentElement
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name +IntToStr(i));
    node := doc.createElement('child');
    (node as IDomElement).setAttribute(Name, 'lion');
    elem.appendChild(node);
    doc.documentElement.appendChild(elem);
  end;
  // documentElemet has n * 3 childs
  // document has n * 4 nodes
  // document has n * 2 attributes
  // documentElement has n childs with an attribute
end;

procedure TTestXPath.selectNodes;
begin
  // test XPath expressions
  select := (doc.documentElement as IDomNodeSelect);
  populateDocument;
  // select self
  nodelist := select.selectNodes('.');
  check(nodelist.length = 1, '1 wrong length');
  check(nodelist[0].nodeName = 'root', 'wrong nodeName');
  // select all childs
  nodelist := select.selectNodes('*');
  check(nodelist.length = n * 3, '2 wrong length');
  // select all descendants
  nodelist := select.selectNodes('//*');
  check(nodelist.length = n * 4 + 1, '3 wrong length');
  // select all childs of childs
  nodelist := select.selectNodes('*/*');
  check(nodelist.length = n, '4 wrong length');
  // select all childs named 'child' of childs
  nodelist := select.selectNodes('*/child');
  check(nodelist.length = n, '5 wrong length');
  // select all childs named %name%
  nodelist := select.selectNodes(Name);
  check(nodelist.length = n * 2, '6 wrong length');
  // select all childs width an attribute named %name% that has the value 'lion'
  nodelist := select.selectNodes('*[@' + Name +' = "lion"]');
  check(nodelist.length = n, '7 wrong length');
  // select all descendants width an attribute named %name% that has the value 'lion'
  nodelist := select.selectNodes('//*[@' + Name +' = "lion"]');
  check(nodelist.length = n * 2, '8 wrong length');
end;

procedure TTestXPath.selectNodes_any_anywhere_by_condition;
begin
  // test XPath expressions
  select := (doc.documentElement as IDomNodeSelect);
  populateDocument;
  // select all descendants width an attribute named %name% that has the value 'lion'
  nodelist := select.selectNodes('//*[@' + Name +' = "lion"]');
  check(nodelist.length = n * 2, '8 wrong length');
end;

procedure TTestXPath.selectNodes_any_by_condition;
begin
  // test XPath expressions
  select := (doc.documentElement as IDomNodeSelect);
  populateDocument;
  // select all childs width an attribute named %name% that has the value 'lion'
  nodelist := select.selectNodes('*[@' + Name +' = "lion"]');
  check(nodelist.length = n, '7 wrong length');
end;

procedure TTestXPath.selectNodes_by_name;
begin
  // test XPath expressions
  select := (doc.documentElement as IDomNodeSelect);
  populateDocument;
  // select all childs named %name%
  nodelist := select.selectNodes(Name);
  check(nodelist.length = n * 2, '6 wrong length');
end;

procedure TTestXPath.selectNodes_child_named_child_of_any_child;
begin
  // test XPath expressions
  select := (doc.documentElement as IDomNodeSelect);
  populateDocument;
  // select all childs named 'child' of childs
  nodelist := select.selectNodes('*/child');
  check(nodelist.length = n, 'wrong length');
end;

procedure TTestXPath.selectNodes_any_child_of_any_child;
begin
  // test XPath expressions
  select := (doc.documentElement as IDomNodeSelect);
  populateDocument;
  nodelist := select.selectNodes('*/*');
  check(nodelist.length = n, '4 wrong length');
end;

procedure TTestXPath.selectNodes_any_anywhere;
begin
  // test XPath expressions
  select := (doc.documentElement as IDomNodeSelect);
  populateDocument;
  nodelist := select.selectNodes('//*');
  check(nodelist.length = n * 4 + 1, 'wrong length');
end;

procedure TTestXPath.selectNodes_any;
begin
  // test XPath expressions
  select := (doc.documentElement as IDomNodeSelect);
  populateDocument;
  // select all childs
  nodelist := select.selectNodes('*');
  check(nodelist.length = n * 3, 'wrong length');
end;

procedure TTestXPath.selectNodes_self;
begin
  // test XPath expressions
  select := (doc.documentElement as IDomNodeSelect);
  populateDocument;
  // select self
  nodelist := select.selectNodes('.');
  check(nodelist.length = 1, 'wrong length');
  check(nodelist[0].nodeName = 'root', 'wrong nodeName');
end;

procedure TTestXPath.selectNodes2;
var
  i: integer;
begin
  // test XPath expressions - select every attribute
  select := (doc.documentElement as IDomNodeSelect);
  populateDocument;
  nodelist := select.selectNodes('//@*');
  check(nodelist.length = n * 2, '9 wrong length - expected: ' +
    IntToStr(n * 2) + ' found: ' + IntToStr(nodelist.length));
  // for each selected attribute check the name
  for i := 0 to nodelist.length - 1 do begin
    check(nodelist[i].nodeName = Name, 'wrong nodeName - expected: "' +
      Name +'" found: "' + nodelist[i].nodeName + '"');
  end;
end;

procedure TTestXPath.selectNodes3NS;
const
  xml=
    '<?xml version="1.0" encoding="iso-8859-1"?>' +
    '<xds:repository xmlns:xds="http://xmlns.4commerce.de/xds">' +
      '<xds:config xmlns:hallo="http://xmlns.4commerce.de/hallo">' +
        '<xds:datalinks>' +
          '<dlink id="ib.omega"/>' +
          '<dlink id="ib.kis"/>' +
        '</xds:datalinks>' +
      '</xds:config>' +
    '</xds:repository>';
var
  doc: IDomDocument;
  xds_datalinks: IDomNodeList;
  docelement: IDomNode;
begin
  doc:=impl.createDocument('','',nil);
  check((doc as IDomPersist).loadxml(xml), 'parse error');
  docElement:=doc.DocumentElement;
  xds_datalinks := (docElement as IDomNodeSelect).selectNodes('//*[name() = concat("xds:",local-name())]');
  check(xds_datalinks.length = 3, 'wrong length');
end;

procedure TTestXPath.selectNodes3b;
const
  xml=
    '<?xml version="1.0" encoding="iso-8859-1"?>' +
    '<repository>' +
      '<config>' +
        '<datalinks>' +
          '<dlink id="ib.omega" />' +
          '<dlink id="ib.kis" />' +
        '</datalinks>' +
      '</config>' +
    '</repository>';
var
  xds_datalinks: IDomNodeList;
  docelement: IDomNode;
begin
  doc:=impl.createDocument('','',nil);
  check((doc as IDomPersist).loadxml(xml), 'parse error');
  docElement:=doc.DocumentElement;
  xds_datalinks := (docElement as IDomNodeSelect).selectNodes('//*');
  check(xds_datalinks.length = 5, 'wrong length');
end;

procedure TTestXPath.selectNodes3a;
const
  xml=
    '<?xml version="1.0" encoding="iso-8859-1"?>' +
    '<xds:repository xmlns:xds="http://xmlns.4commerce.de/xds">' +
      '<hallo:config xmlns:hallo="http://xmlns.4commerce.de/hallo">' +
        '<xds:datalinks>' +
          '<dlink id="ib.omega"/>' +
          '<dlink id="ib.kis"/>' +
        '</xds:datalinks>' +
      '</hallo:config>' +
    '</xds:repository>';
var
  xds_datalinks: IDomNodeList;
  docelement: IDomNode;
begin
  doc := impl.createDocument('','',nil);
  (doc as IDomParseOptions).resolveExternals := false;
  check((doc as IDomPersist).loadxml(xml),'parse error');
  docElement := doc.documentElement;
  (docElement as IDOMNodeSelect).registerNs('xds','http://xmlns.4commerce.de/xds');
  (docElement as IDOMNodeSelect).registerNs('hallo','http://xmlns.4commerce.de/hallo');
  xds_datalinks := (docElement as IDOMNodeSelect).selectNodes('/xds:repository/hallo:config/xds:datalinks/dlink');
  check(xds_datalinks.length = 2, 'wrong length');
end;

procedure TTestXPath.selectNodesOneNs;
const
  xml=
    '<?xml version="1.0" encoding="iso-8859-1"?>' +
    '<xds:repository xmlns:xds="http://xmlns.4commerce.de/xds">' +
      '<xds:config>' +
        '<xds:datalinks>' +
          '<dlink id="ib.omega"/>' +
          '<dlink id="ib.kis"/>' +
        '</xds:datalinks>' +
      '</xds:config>' +
    '</xds:repository>';
var
  xds_datalinks: IDomNodeList;
  docelement: IDomNode;
begin
  doc := impl.createDocument('','',nil);
  (doc as IDomParseOptions).resolveExternals := false;
  check((doc as IDomPersist).loadxml(xml),'parse error');
  docElement := doc.documentElement;
  (docElement as IDOMNodeSelect).registerNs('xds','http://xmlns.4commerce.de/xds');
  xds_datalinks := (docElement as IDOMNodeSelect).selectNodes('/xds:repository/xds:config/xds:datalinks/dlink');
  check(xds_datalinks.length = 2, 'wrong length');
end;

procedure TTestXPath.SetUp;
begin
  inherited;
  impl := DomSetup.getCurrentDomSetup.getDocumentBuilder.domImplementation;
  doc := impl.createDocument('', '', nil);
  (doc as IDomPersist).loadxml('<?xml version="1.0" encoding="iso-8859-1"?><root />');
  nsuri := 'http://ns.4commerce.de';
  prefix := 'ct';
  Name := 'test';
  Data := 'Dies ist ein Beispiel-Text.';
end;

procedure TTestXPath.TearDown;
begin
  node := nil;
  elem := nil;
  attr := nil;
  Text := nil;
  nodelist := nil;
  cdata := nil;
  comment := nil;
  pci := nil;
  docfrag := nil;
  entref := nil;
  ent := nil;
  select := nil;
  nnmap := nil;
  doc := nil;
  impl := nil;
  inherited;
end;

procedure TTestXPath.selectNodes4;
begin
  check((doc as IDOMPersist).load(IncludeTrailingPathDelimiter(datapath)+'xds.repository.xml'), 'parse error');
  select := doc.documentElement as IDOMNodeSelect;
  nodelist := select.selectNodes('//xObject');
  check(nodelist.length = 19, 'wrong length');
  nodelist := select.selectNodes('//xClass');
  check(nodelist.length = 5, 'wrong length');
end;

initialization
  datapath := getDataPath;
  CoInitialize(nil);

end.
