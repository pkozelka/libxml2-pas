unit XPTest_idom2_TestXPath;

interface

uses
  TestFrameWork,
  libxmldom,
  idom2,
  SysUtils,
  domSetup,
  XPTest_idom2_Shared,
  ActiveX;

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
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure selectNodes;
    procedure selectNodes2;
    property fqname: string read getFqname;
  end;

implementation

{ TTestXPath }

function TTestXPath.getFqname: string;
begin
  if prefix = '' then Result := Name 
  else Result := prefix + ':' + Name;
end;

procedure TTestXPath.selectNodes;
const
  n = 10;
var
  i: integer;
begin
  // test XPath expressions
  select := (doc.documentElement as IDomNodeSelect);
  // populate the document ...
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name);
    doc.documentElement.appendChild(elem);
  end;
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name);
    elem.setAttribute(Name, 'lion');
    doc.documentElement.appendChild(elem);
  end;
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name +IntToStr(i));
    node := doc.createElement('child');
    (node as IDomElement).setAttribute(Name, 'lion');
    elem.appendChild(node);
    doc.documentElement.appendChild(elem);
  end;
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

procedure TTestXPath.selectNodes2;
const
  n = 10;
var
  i: integer;
begin
  // test XPath expressions - select every attribute
  select := (doc.documentElement as IDomNodeSelect);
  // populate the document ...
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name);
    doc.documentElement.appendChild(elem);
  end;
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name);
    elem.setAttribute(Name, 'lion');
    doc.documentElement.appendChild(elem);
  end;
  for i := 0 to n - 1 do begin
    elem := doc.createElement(Name +IntToStr(i));
    node := doc.createElement('child');
    (node as IDomElement).setAttribute(Name, 'lion');
    elem.appendChild(node);
    doc.documentElement.appendChild(elem);
  end;
  nodelist := select.selectNodes('//@*');
  check(nodelist.length = n * 2, '9 wrong length - expected: ' +
    IntToStr(n * 2) + ' found: ' + IntToStr(nodelist.length));
  // for each selected attribute check the name
  for i := 0 to nodelist.length - 1 do begin
    check(nodelist[i].nodeName = Name, 'wrong nodeName - expected: "' +
      Name +'" found: "' + nodelist[i].nodeName + '"');
  end;
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

initialization
  datapath := getDataPath;
  CoInitialize(nil);

end.
