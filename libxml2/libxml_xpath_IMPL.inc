{ xpath.h macros }

{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}

function xmlXPathNodeSetGetLength(ns : xmlNodeSetPtr) : integer;
begin
	if ns=nil then begin
		Result := 0;
	end else begin
		Result := ns^.nodeNr;
	end;
end;

function xmlXPathNodeSetItem(ns: xmlNodeSetPtr; index: integer): xmlNodePtr;
var
	p: PxmlNodePtr;
begin
	Result := nil;
	if ns=nil then exit;
	if index<0 then exit;
	if index>=ns^.nodeNr then exit;
	p := ns^.nodeTab;
	Inc(p, index);
	Result := p^;
end;

