unit XPTest_idom2_TestXSLT;

interface

uses
  TestFrameWork,
  libxmldom,
  idom2,
  SysUtils,
  domSetup,
  XPTest_idom2_Shared,
  ActiveX,
  Classes;

type TTestXSLT = class(TTestCase)
  private
    impl: IDOMImplementation;
    xml: IDOMDocument;
    xsl: IDOMDocument;
    xnode: IDOMNode;
    snode: IDOMNode;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure transformNode2Text;
    procedure transformNode2Text1;
    procedure transformNode2Document;
    procedure transformNode2Document1;
  end;

implementation

{ TTestXSLT }

procedure TTestXSLT.SetUp;
begin
  inherited;
  impl := DomSetup.getCurrentDomSetup.getDocumentBuilder.domImplementation;
  xml := impl.createDocument('','',nil);
  (xml as IDOMPersist).loadxml(xmlstr);
  xsl := impl.createDocument('','',nil);
end;

procedure TTestXSLT.TearDown;
begin
  snode := nil;
  xnode := nil;
  xsl := nil;
  xml := nil;
  impl := nil;
  inherited;
end;

procedure TTestXSLT.transformNode2Document;
var
  text: WideString;
begin
  // apply a stylesheet that produces html-output
  (xsl as IDOMPersist).loadxml(xslstr);
  xnode := xml as IDOMNode;
  snode := xsl.documentElement as IDOMNode;
  (xnode as IDOMNodeEx).transformNode(snode,text);
  text := Unify(text);
  check(text = outstr, 'wrong content');
end;

procedure TTestXSLT.transformNode2Document1;
var
  doc: IDOMDocument;
  text: string;
begin
  // apply a stylesheet that produces html-output
  doc := impl.createDocument('','',nil);
  (xsl as IDOMPersist).loadxml(xslstr);
  xnode := xml as IDOMNode;
  snode := xsl.documentElement as IDOMNode;
  (xnode as IDOMNodeEx).transformNode(snode,doc);
  text := Unify((doc as IDOMPersist).xml);
  check(text = outstr, 'wrong content');
end;

procedure TTestXSLT.transformNode2Text;
var
  text: WideString;
begin
  // apply a stylesheet that produces text-output
  (xsl as IDOMPersist).loadxml(xslstr1);
  xnode := xml as IDOMNode;
  snode := xsl.documentElement as IDOMNode;
  (xnode as IDOMNodeEx).transformNode(snode,text);
  check(text = 'test', 'wrong content - expected: "test" found: "'+text+'"');
end;

procedure TTestXSLT.transformNode2Text1;
var
  doc: IDOMDocument;
  //text: string;
begin
  // apply a stylesheet that produces text-output
  //doc := impl.createDocument('','',nil);
  (xsl as IDOMPersist).loadxml(xslstr1);
  xnode := xml as IDOMNode;
  snode := xsl.documentElement as IDOMNode;
  (xnode as IDOMNodeEx).transformNode(snode,doc);

  // i don't know what should be up with doc now
  // what's the correct behaviour ?

  //text := Unify((doc as IDOMPersist).xml);
end;

initialization
  datapath := getDataPath;
  CoInitialize(nil);
finalization
  //CoUnInitialize;
end.
