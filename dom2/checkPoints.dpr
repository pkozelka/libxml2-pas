program checkPoints;

{$APPTYPE CONSOLE}

uses
	libxml2,
	dom2, libxmldom, msxml_impl, SysUtils;

type
	TErrorSeverity = (NONE, WARNING, ERROR, FATAL);
var
	Glb: record
		Error: record
			Severity: TErrorSeverity;
			Msg: string;
		end;
		Builder: IDomDocumentBuilder;
		Doc: IDomDocument;
	end;

procedure report(aMsg: string; aSeverity: TErrorSeverity = ERROR; aCondition: boolean=true);
begin
	if aCondition then begin
		Glb.Error.Severity := aSeverity;
		Glb.Error.Msg := aMsg;
	end;
end;

procedure checkErrors;
begin
	case Glb.Error.Severity of
	WARNING: write('Warning');
	ERROR: write('ERROR');
	FATAL: raise Exception.Create(Glb.Error.Msg);
	NONE: Write('OK');
	end;
	WriteLN(' ', Glb.Error.Msg);
end;

procedure chk_Build;
var
	doc: IDomDocument;
	el: IDomElement;
begin
	doc := Glb.Builder.newDocument;
	el := doc.createElement('root');
	doc.appendChild(el);
	if doc.firstChild.nodeName<>'root' then report('bad name');
end;

begin
	Glb.Error.Severity := NONE;
	Glb.Builder := getDocumentBuilderFactory(SLIBXML).newDocumentBuilder;
	try
		Write('Build: '); chk_Build; checkErrors;
	except
		on E: Exception do begin
			WriteLN('FATAL: ', E.ClassName,'("',E.Message,'")', Glb.Error.Msg);
		end;
	end;
end.

