unit libxml2_experimental;
//$Id: libxml2_experimental.pas,v 1.6 2002-03-08 08:13:17 pkozelka Exp $
(**
 * Title:        libxml2 experimental unit
 * Description:  Contains experimental code for support or development of libxml2
 * Copyright:    Copyright (c) 2002
 * Company:
 * @author       Petr Kozelka <pkozelka@email.cz>
 * @version 0.1
 *)
interface

uses
{$IFDEF WIN32}
  windows,
{$ENDIF}
  libxml2;

type
  TMessageHandler = procedure(aMsg: WideString) of object;

procedure RegisterErrorHandler(aHandler: TMessageHandler);

implementation

uses
  SysUtils;

var
  myErrH: TMessageHandler;

// error output redirected to OutputDebugString

procedure myGenericErrorFunc(ctx: Pointer; msg: PChar); cdecl;
begin
  if Assigned(myErrH) then begin
    myErrH(msg);
  end;
{$IFDEF WIN32}
  OutputDebugStringW(PWideChar(UTF8Decode(msg)));
{$ENDIF}
{$IFDEF LINUX}
  Writeln(UTF8Decode(msg));
{$ENDIF}
end;

procedure RegisterErrorHandler(aHandler: TMessageHandler);
begin
  myErrH := aHandler;
end;

initialization
  // redirect error output
  xmlSetGenericErrorFunc(nil, @myGenericErrorFunc);

end.

