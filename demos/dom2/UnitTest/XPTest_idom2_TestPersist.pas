unit XPTest_idom2_TestPersist;

interface

uses
  TestFrameWork,
  libxmldom,
  idom2,
  SysUtils,
  XPTest_idom2_Shared,
  Classes,
  domSetup,
  ActiveX,
  Dialogs;

type TTestPersist = class(TTestCase)
  private
    impl: IDOMImplementation;
    doc: IDOMDocument;
    doc1: IDOMDocument;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure persist;
    procedure valid;
    procedure valid1;
    procedure valid2;
    procedure valid3;
    procedure valid4;
    procedure LoadFiles;
    procedure LoadFilesII;
  end;

implementation

{ TTestPersist }

procedure TTestPersist.persist;
var
  sl: TStrings;
  tmp,data1,data: string;
begin
  try
    // get a textual representation of the dom
    data := (doc as IDOMPersist).xml;
    data1:=unify(data);
    // save the dom to a file and load it as a textfile
    (doc as IDOMPersist).save('temp.xml');
    sl := TSTringList.create;
    sl.LoadFromFile('temp.xml');
    tmp := sl.Text;
    // adjust contents of the textfile
    tmp:=unify(tmp);
    // compare the textual representation of the dom to the contents of the textfile
    check(data1 = tmp, 'wrong content');
    // load the dom from a textfile
    (doc as IDOMPersist).load('temp.xml');
    // get a textual representation of the dom
    tmp := (doc as IDOMPersist).xml;
    // adjust the textual representation of the dom
    tmp:=Unify(tmp);
    check(data1 = tmp, 'wrong content');
  finally
    if FileExists('temp.xml') then DeleteFile('temp.xml');
  end;
end;

procedure TTestPersist.valid;
var data: string;
begin
  // test if the xml structure is validated against the dtd
  // create and save a xml structure that IS valid against the dtd
  data := '<?xml version="1.0" encoding="iso-8859-1"?>'+
          '<!DOCTYPE root ['+
          '<!ELEMENT root (test*,a)>'+
          '<!ELEMENT test (#PCDATA)>'+
          '<!ATTLIST test name CDATA #IMPLIED>'+
          '<!ELEMENT a (#PCDATA)>'+
          ']>'+
          '<root><a/></root>';
  (doc as IDOMParseOptions).validate := True;
  check((doc as IDOMPersist).loadxml(data), 'result of load is false - should be true because xml is valid');
end;

procedure TTestPersist.valid1;
var data: string;
begin
  // test if the xml structure is validated against the dtd
  // create and save a xml structure that NOT valid against the dtd
  data := '<?xml version="1.0" encoding="iso-8859-1"?>'+
          '<!DOCTYPE root ['+
          '<!ELEMENT root (test*)>'+
          '<!ELEMENT test (#PCDATA)>'+
          '<!ATTLIST test name CDATA #IMPLIED>'+
          ']>'+
          '<egon />';

  (doc as IDOMParseOptions).validate := True;
  check(not (doc as IDOMPersist).loadxml(data), 'result of load true - should be false because xml is not valid');
end;

procedure TTestPersist.valid2;
var data: string;
begin
  // test if the xml structure is validated against the dtd
  // create and save a xml structure that NOT valid against the dtd
  data := '<?xml version="1.0" encoding="iso-8859-1"?>'+
          '<!DOCTYPE root ['+
          '<!ELEMENT root (test*)>'+
          '<!ELEMENT test (#PCDATA)>'+
          '<!ATTLIST test name CDATA #IMPLIED>'+
          ']>'+
          '<egon />';

  (doc as IDOMParseOptions).validate := False;
  check((doc as IDOMPersist).loadxml(data), 'result of load is false - should be true because ParseOptions set to false');
end;

procedure TTestPersist.valid3;
var
  sl: TStrings;
begin
  // test if the xml structure is validated against the dtd
  // create and save a xml structure that IS valid against the dtd
  sl := TStringList.Create;
  sl.Text := '<?xml version="1.0" encoding="iso-8859-1"?>'+
             '<!DOCTYPE root ['+
             '<!ELEMENT root (test*)>'+
             '<!ELEMENT test (#PCDATA)>'+
             '<!ATTLIST test name CDATA #IMPLIED>'+
             ']>'+
             '<root />';
  sl.SaveToFile('temp.xml');
  sl.Free;
  (doc as IDOMParseOptions).validate := True;
  try
    check((doc as IDOMPersist).load('temp.xml'), 'result of load is false - should be true because xml is valid');
  finally
    if FileExists('temp.xml') then DeleteFile('temp.xml');
  end;
end;

procedure TTestPersist.valid4;
var
  sl: TStrings;
begin
  // test if the xml structure is validated against the dtd
  // create and save a xml structure that is NOT valid against the dtd
  sl := TStringList.Create;
  sl.Text := '<?xml version="1.0" encoding="iso-8859-1"?>'+
             '<!DOCTYPE root ['+
             '<!ELEMENT root (test*)>'+
             '<!ELEMENT test (#PCDATA)>'+
             '<!ATTLIST test name CDATA #IMPLIED>'+
             ']>'+
             '<egon />';
  sl.SaveToFile('temp.xml');
  sl.Free;
  (doc as IDOMParseOptions).validate := True;
  try
    check(not (doc as IDOMPersist).load('temp.xml'), 'result of load is true - should be false because xml is not vaild');
  finally
    if FileExists('temp.xml') then DeleteFile('temp.xml');
  end;
end;

procedure TTestPersist.LoadFiles;
var
  builder: IDomDocumentBuilder;
  mydoc: IDomDocument;
  fd: string; // file directory
  fn: string; // file name
  sr: TSearchRec;
  rv: integer; // returned value
  cnt: integer; // tested file counter
begin
  fd := datapath;
  try
    cnt := 0;
    rv := FindFirst(fd+'/*.xml', faAnyFile, sr);
    while (rv=0) do begin
      Inc(cnt);
      builder := getDocumentBuilderFactory(DomVendor).newDocumentBuilder;
      fn := fd + '/' + sr.Name;
      mydoc := builder.load(fn);
      check(mydoc<>nil, fn+': document not loaded');
      check(mydoc.documentElement<>nil, fn+': documentElement is nil');
      rv := FindNext(sr);
    end;
    if (cnt=0) then begin
      check(false, 'No XML file available for testing in directory '+fd);
    end;
  finally
    FindClose(sr);
  end;
end;

procedure TTestPersist.LoadFilesII;
var
  mydoc: IDomDocument;
  fd: string; // file directory
  fn: string; // file name
  sr: TSearchRec;
  rv: integer; // returned value
  cnt: integer; // tested file counter
begin
  impl := GetDom(domvendor);
  mydoc := impl.createDocument('','',nil);
  fd := datapath;
  try
    cnt := 0;
    rv := FindFirst(fd+'/*.xml', faAnyFile, sr);
    while (rv=0) do begin
      Inc(cnt);
      fn := fd + '/' + sr.Name;
      (mydoc as IDOMPersist).load(fn);
      check(mydoc<>nil, fn+': document not loaded');
      check(mydoc.documentElement<>nil, fn+': documentElement is nil');
      rv := FindNext(sr);
    end;
    if (cnt=0) then begin
      check(false, 'No XML file available for testing in directory '+fd);
    end;
  finally
    FindClose(sr);
  end;
end;

procedure TTestPersist.SetUp;
begin
  inherited;
  impl := DomSetup.getCurrentDomSetup.getDocumentBuilder.domImplementation;
  doc := impl.createDocument('','',nil);
  (doc as IDOMPersist).loadxml(xmlstr);
  doc1 := impl.createDocument('','',nil);
  (doc1 as IDOMPersist).loadxml(xmlstr1);
end;

procedure TTestPersist.TearDown;
begin
  doc := nil;
  doc1:= nil;
  impl := nil;
  inherited;
end;

initialization
  datapath := getDataPath;
  CoInitialize(nil);
finalization
  CoUnInitialize;
end.
