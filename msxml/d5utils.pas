unit d5utils;

interface

function UTF8Decode(aUTF8Chars: string): widestring;

implementation

function UTF8Decode(aUTF8Chars: string): widestring;
begin
	Result := aUTF8Chars;
end;

end.
