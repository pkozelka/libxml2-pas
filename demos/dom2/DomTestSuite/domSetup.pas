unit domSetup;

interface

uses
  TestFramework,
  xDom2;

const
  illegalChars : array[0..25] of WideChar =
      ('{', '}', '~', '''', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')',
       '+', '=', '[', ']', '\', '/', ';', #96, '<', '>', ',', '"' );

type

  IDomSetup = interface
    function getVendorID : String;
    function getDocumentBuilder : IDomDocumentBuilder;
  end;

  function createDomSetupTest(const vendorID : String; test : ITest) : ITest;

  (*
   * provides a reference to the current IDomSetup. Use it within the Dom test
   * cases to get the current VendorID and current documentBuilder.
  *)
  function getCurrentDomSetup : IDomSetup;

implementation

uses
  TestExtensions;

type

  (*
   * Test decorator that will initialize the DOM for a specific VendorID
  *)
  TDomSetup = class(TTestSetup, IDomSetup)
    private
      fVendorID        : String;
      fDocumentBuilder : IDomDocumentBuilder;

    public
      constructor create(const vendorID : String; test : ITest);
      destructor destroy; override;

      procedure Setup; override;
      procedure TearDown; override;

      (* IDomSetup methods *)
      function getVendorID : String;
      function getDocumentBuilder : IDomDocumentBuilder;
  end;

var
  (* reference to the current DomSetup *)
  gCurrentDomSetup : IDomSetup;

constructor TDomSetup.create(const vendorID : String; test : ITest);
begin
  inherited create(test);
  fVendorID := vendorID;
end;

destructor TDomSetup.destroy;
begin
  fDocumentBuilder := nil;
end;

procedure TDomSetup.Setup;
begin
  {get DocumentBuilder on demand in setup so exceptions will be caught by DUnit}
  if fDocumentBuilder = nil then
  begin
    fDocumentBuilder := getDocumentBuilderFactory(fVendorID).newDocumentBuilder;
  end;

  {register this DomSetup as the current one}
  gCurrentDomSetup := self;
end;

procedure TDomSetup.TearDown;
begin
  gCurrentDomSetup := nil;
end;

function TDomSetup.getVendorID : String;
begin
  result := fVendorID;
end;

function TDomSetup.getDocumentBuilder : IDomDocumentBuilder;
begin
  result := fDocumentBuilder;
end;

(* creator for DomSetup *)
function createDomSetupTest(const vendorID : String; test : ITest) : ITest;
begin
  result := TDomSetup.create(vendorID, test);
end;


(* returns the current dom setup *)
function getCurrentDomSetup : IDomSetup;
begin
  result := gCurrentDomSetup;
end;


end.
