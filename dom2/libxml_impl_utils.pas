unit libxml_impl_utils;
//$Id: libxml_impl_utils.pas,v 1.3 2002-08-05 01:31:27 pkozelka Exp $
(*
 * Low-level utility functions needed for libxml-based implementation of DOM.
 *
 * Licensing: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * Developers:
 *   - the LIBXML2-PAS development team <libxml2-pas-devel@lists.sourceforge.net>
 *   namely
 *   - Petr Kozelka <pkozelka@email.cz>
 *   - Uwe Fechner <ufechner@csi.com>
 *)

interface

uses
  SysUtils,
  idom2,
  libxml2;

function  ErrorString(err:integer):String;
procedure DomAssert1(aCondition: boolean; aErrorCode:integer; aMsg: WideString; aLocation: String);
function  IsReadOnlyNode(node:xmlNodePtr): boolean;
procedure SplitQName(aQName: String; out aPrefix, aLocalName: String);
function  xmlSetPropNode(elem: xmlNodePtr; attr: xmlAttrPtr): xmlAttrPtr;
function  isNameChar(c: Longint): boolean;
function  isNCName(aStr: DomString): boolean;
function  isNamespaceUri(aStr: DomString): boolean;
function  featureIsSupported(const aFeature, aVersion: DomString; const aFeatures: array of DomString): Boolean;

// object counters
var
  GlbDocCount: Integer=0;
  GlbDomCount: Integer=0;
  GlbNodeCount: Integer=0;
  GlbElementCount: Integer=0;

implementation

function ErrorString(err:integer):String;
begin
  case err of
    INDEX_SIZE_ERR: Result:='INDEX_SIZE_ERR';
    DOMSTRING_SIZE_ERR: Result:='DOMSTRING_SIZE_ERR';
    HIERARCHY_REQUEST_ERR: Result:='HIERARCHY_REQUEST_ERR';
    WRONG_DOCUMENT_ERR: Result:='WRONG_DOCUMENT_ERR';
    INVALID_CHARACTER_ERR: Result:='INVALID_CHARACTER_ERR';
    NO_DATA_ALLOWED_ERR: Result:='NO_DATA_ALLOWED_ERR';
    NO_MODIFICATION_ALLOWED_ERR: Result:='NO_MODIFICATION_ALLOWED_ERR';
    NOT_FOUND_ERR: Result:='NOT_FOUND_ERR';
    NOT_SUPPORTED_ERR: Result:='NOT_SUPPORTED_ERR';
    INUSE_ATTRIBUTE_ERR: Result:='INUSE_ATTRIBUTE_ERR';
    INVALID_STATE_ERR: Result:='INVALID_STATE_ERR';
    SYNTAX_ERR: Result:='SYNTAX_ERR';
    INVALID_MODIFICATION_ERR: Result:='INVALID_MODIFICATION_ERR';
    NAMESPACE_ERR: Result:='NAMESPACE_ERR';
    INVALID_ACCESS_ERR: Result:='INVALID_ACCESS_ERR';
    20: Result:='SaveXMLToMemory_ERR';
    21: Result:='NotSupportedByLibxmldom_ERR';
    22: Result:='SaveXMLToDisk_ERR';
    100: Result:='LIBXML2_NULL_POINTER_ERR';
    101: Result:='INVALID_NODE_SET_ERR';
    102: Result:='PARSE_ERR';
  else
    Result:='Unknown error no: '+inttostr(err);
  end;
end;

(**
 * Checks if the condition is true, and raises specified exception if not.
 *)
procedure DomAssert1(aCondition: boolean; aErrorCode:integer; aMsg: WideString; aLocation: String);
begin
  if aErrorCode=0 then exit;
  if aCondition then exit;
  if aMsg='' then begin
    aMsg := ErrorString(aErrorCode);
  end;
  if (aLocation<>'') then begin
    aMsg := 'in class '+aLocation+': '+aMsg;
  end;
  raise EDomException.Create(aErrorCode, aMsg);
end;

function IsReadOnlyNode(node:xmlNodePtr): boolean;
begin
  if node<>nil then begin
    case node.type_ of
      XML_NOTATION_NODE,
      XML_ENTITY_NODE,
      XML_ENTITY_DECL:
        Result := True;
    else
      Result := False;
    end;
  end else begin
    Result := False;
  end;
end;

function canAppendNode(priv,newPriv:xmlNodePtr): boolean;
//var
//	new_type: integer;
begin
//ToDo:
//Finish the translation from C
//	if newPriv<>nil
//		then new_type:=newPriv.type_;
  Result := True;
end;

procedure SplitQName(aQName: String; out aPrefix, aLocalName: String);
var
	n: integer;
begin
	n := Pos(':', aQName);
	if (n>0) then begin
		aPrefix := Copy(aQName, 1, n-1);
		aLocalName := Copy(aQName, n+1, Length(aQName));
	end else begin
		aPrefix := '';
		aLocalName := aQName;
	end;
end;

(**
 * [ This function will later be submitted in C to xml@gnome.org
 *   Note that order-preserving implementation will have to be posted.
 *   ]
 * Sets an existing attribute node into an element property list.
 * Returns the previous attribute or NULL.
 *)
function xmlSetPropNode(elem: xmlNodePtr; attr: xmlAttrPtr): xmlAttrPtr;
begin
  if (attr.ns=nil) then begin
    Result := xmlHasProp(elem, attr.name);
  end else begin
    Result := xmlHasNsProp(elem, attr.name, attr.ns.href);
  end;
  if (Result<>nil) then begin
    xmlUnlinkNode(xmlNodePtr(Result));
  end;
  xmlAddChild(elem, xmlNodePtr(attr));
  elem.nsDef := attr.ns; //DIRTY
end;

function isNameChar(c: Longint): boolean;
begin
  Result := true;
  if xmlIsDigit(c) then exit;
  if xmlIsBaseChar(c) then exit;
  case c of
    Ord('.'),
    Ord('-'),
    Ord('_'),
    Ord(':'): exit;
  end;
  if xmlIsIdeographic(c) then exit;
  if xmlIsCombining(c) then exit;
  if xmlIsExtender(c) then exit;
  Result := false;
end;

function isNCName(aStr: DomString): boolean;
var
  i: integer;
begin
  Result := false;
  if (Length(aStr)=0) then exit;
  if xmlIsDigit(Ord(aStr[1])) then exit;
  for i:=1 to Length(aStr) do begin
    if (aStr[i] = ':') then exit;
    if not isNameChar(Ord(aStr[i])) then exit;
  end;
  Result := true;
end;

function isNamespaceUri(aStr: DomString): boolean;
var
  i: integer;
begin
  Result := false;
  if (Length(aStr)=0) then exit;
  if (not xmlIsLetter(Ord(aStr[1]))) then exit;
  for i:=2 to Length(aStr) do begin
    if xmlIsBlank(Ord(aStr[i])) then exit;  //???
  end;
  Result := true;
end;

function featureIsSupported(const aFeature, aVersion: DomString; const aFeatures: array of DomString): Boolean;
var
  i: integer;
  fea: string;
  ver: string;
begin
  fea := UpperCase(aFeature);
  ver := UpperCase(aVersion);
  i := Low(aFeatures);
  while (i<High(aFeatures)) do begin
    Result := (fea = aFeatures[i]);
    Inc(i);
    Result := Result and (ver=aFeatures[i]);
    if Result then exit;
    Inc(i);
  end;
  Result := false;
end;

end.

