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

type TTestXPath = class(TTestCase)
  private
    impl: IDOMImplementation;
    doc: IDOMDocument;
    node: IDOMNode;
    elem: IDOMElement;
    attr: IDOMAttr;
    text: IDOMText;
    nodelist: IDOMNodeList;
    cdata: IDOMCDATASection;
    comment: IDOMComment;
    pci: IDOMProcessingInstruction;
    docfrag: IDOMDocumentFragment;
    ent: IDOMEntity;
    entref: IDOMEntityReference;
    select: IDOMNodeSelect;
    nnmap: IDOMNamedNodeMap;
    nsuri: string;
    prefix: string;
    name: string;
    data: string;
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
  if prefix = '' then result := name else result := prefix + ':' + name;
end;

procedure TTestXPath.selectNodes;
const
  n = 10;
var
  i: integer;
begin
  // test XPath expressions
  select := (doc.documentElement as IDOMNodeSelect);
  // populate the document ...
  for i := 0 to n-1 do begin
    elem := doc.createElement(name);
    doc.documentElement.appendChild(elem);
  end;
  for i := 0 to n-1 do begin
    elem := doc.createElement(name);
    elem.setAttribute(name,'lion');
    doc.documentElement.appendChild(elem);
  end;
  for i := 0 to n-1 do begin
    elem := doc.createElement(name+IntToStr(i));
    node := doc.createElement('child');
    (node as IDOMElement).setAttribute(name,'lion');
    elem.appendChild(node);
    doc.documentElement.appendChild(elem);
  end;
  // select self
  nodelist := select.selectNodes('.');
  check(nodelist.length = 1, '1 wrong length');
  check(nodelist[0].nodeName = 'root', 'wrong nodeName');
  // select all childs
  nodelist := select.selectNodes('*');
  check(nodelist.length = n*3, '2 wrong length');
  // select all descendants
  nodelist := select.selectNodes('//*');
  check(nodelist.length = n*4+1, '3 wrong length');
  // select all childs of childs
  nodelist := select.selectNodes('*/*');
  check(nodelist.length = n, '4 wrong length');
  // select all childs named 'child' of childs
  nodelist := select.selectNodes('*/child');
  check(nodelist.length = n, '5 wrong length');
  // select all childs named %name%
  nodelist := select.selectNodes(name);
  check(nodelist.length = n*2, '6 wrong length');
  // select all childs width an attribute named %name% that has the value 'lion'
  nodelist := select.selectNodes('*[@'+name+' = "lion"]');
  check(nodelist.length = n, '7 wrong length');
  // select all descendants width an attribute named %name% that has the value 'lion'
  nodelist := select.selectNodes('//*[@'+name+' = "lion"]');
  check(nodelist.length = n*2, '8 wrong length');
end;

procedure TTestXPath.selectNodes2;
const
  n = 10;
var
  i: integer;
begin
  // test XPath expressions - select every attribute
  select := (doc.documentElement as IDOMNodeSelect);
  // populate the document ...
  for i := 0 to n-1 do begin
    elem := doc.createElement(name);
    doc.documentElement.appendChild(elem);
  end;
  for i := 0 to n-1 do begin
    elem := doc.createElement(name);
    elem.setAttribute(name,'lion');
    doc.documentElement.appendChild(elem);
  end;
  for i := 0 to n-1 do begin
    elem := doc.createElement(name+IntToStr(i));
    node := doc.createElement('child');
    (node as IDOMElement).setAttribute(name,'lion');
    elem.appendChild(node);
    doc.documentElement.appendChild(elem);
  end;
  nodelist := select.selectNodes('//@*');
  check(nodelist.length = n*2, '9 wrong length - expected: '+IntToStr(n*2)+' found: '+IntToStr(nodelist.length));
  // for each selected attribute check the name
  for i := 0 to nodelist.length-1 do begin
    check(nodelist[i].nodeName = name, 'wrong nodeName - expected: "'+name+'" found: "'+nodelist[i].nodeName+'"');
  end;
end;

procedure TTestXPath.SetUp;
begin
  inherited;
  impl := DomSetup.getCurrentDomSetup.getDocumentBuilder.domImplementation;
  doc := impl.createDocument('','',nil);
  (doc as IDOMPersist).loadxml('<?xml version="1.0" encoding="iso-8859-1"?><root />');
  nsuri := 'http://ns.4commerce.de';
  prefix := 'ct';
  name := 'test';
  data := 'Dies ist ein Beispiel-Text.';
end;

procedure TTestXPath.TearDown;
begin
  node := nil;
  elem := nil;
  attr := nil;
  text := nil;
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
finalization
  //CoUninitialize;
end.
