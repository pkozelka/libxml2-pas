unit domSetup;

interface

uses
  TestFramework,
  idom2;

const
  illegalChars: array[0..25] of widechar =
    ('{', '}', '~', '''', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')',
    '+', '=', '[', ']', '\', '/', ';', #96, '<', '>', ',', '"');

type

  IDomSetup = interface
    function getVendorID: string;
    function getDocumentBuilder: IDomDocumentBuilder;
  end;

function createDomSetupTest(const vendorID: string; test: ITest): ITest;

  (*
   * provides a reference to the current IDomSetup. Use it within the Dom test
   * cases to get the current VendorID and current documentBuilder.
  *)
function getCurrentDomSetup: IDomSetup;

implementation

uses
  TestExtensions;

type

  (*
   * Test decorator that will initialize the DOM for a specific VendorID
  *)
  TDomSetup = class(TTestSetup, IDomSetup)
  private
    fVendorID: string;
    fDocumentBuilder: IDomDocumentBuilder;

  public
    constructor Create(const vendorID: string; test: ITest);
    destructor Destroy; override;

    procedure Setup; override;
    procedure TearDown; override;

    (* IDomSetup methods *)
    function getVendorID: string;
    function getDocumentBuilder: IDomDocumentBuilder;
  end;

var
  (* reference to the current DomSetup *)
  gCurrentDomSetup: IDomSetup;

constructor TDomSetup.Create(const vendorID: string; test: ITest);
begin
  inherited Create(test);
  fVendorID := vendorID;
end;

destructor TDomSetup.Destroy;
begin
  fDocumentBuilder := nil;
end;

procedure TDomSetup.Setup;
begin
  {get DocumentBuilder on demand in setup so exceptions will be caught by DUnit}
  if fDocumentBuilder = nil then begin
    fDocumentBuilder := getDocumentBuilderFactory(fVendorID).newDocumentBuilder;
  end;

  {register this DomSetup as the current one}
  gCurrentDomSetup := self;
end;

procedure TDomSetup.TearDown;
begin
  gCurrentDomSetup := nil;
end;

function TDomSetup.getVendorID: string;
begin
  Result := fVendorID;
end;

function TDomSetup.getDocumentBuilder: IDomDocumentBuilder;
begin
  Result := fDocumentBuilder;
end;

(* creator for DomSetup *)
function createDomSetupTest(const vendorID: string; test: ITest): ITest;
begin
  Result := TDomSetup.Create(vendorID, test);
end;


(* returns the current dom setup *)
function getCurrentDomSetup: IDomSetup;
begin
  Result := gCurrentDomSetup;
end;


end.
