//$Id: libxml2_experimental.pas,v 1.1 2002-01-31 14:11:33 pkozelka Exp $
unit libxml2_experimental;
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
{$ifdef WIN32}
  windows,
{$endif}
  libxml2;

// this one was proposed to Daniel
function  xmlFormatMessage(buf: PChar; aMsg: PChar): Longint; cdecl;external LIBXML2_SO;

type
  TMessageHandler = procedure (aMsg: String) of object;

procedure RegisterErrorHandler(aHandler: TMessageHandler);

implementation

var
  myErrH: TMessageHandler;

// error output redirected to OutputDebugString

procedure myGenericErrorFunc(ctx: pointer; msg: PChar); cdecl;
var
  s: String;
begin
  SetLength(s, 10000);
  SetLength(s, xmlFormatMessage(PChar(s), @msg));
  if Assigned(myErrH) then begin
    myErrH(s);
  end;
{$ifdef WIN32}
  OutputDebugString(PChar(s));
{$endif}
{$ifdef LINUX}
  Writeln(s);
{$endif}
end;

procedure RegisterErrorHandler(aHandler: TMessageHandler);
begin
  myErrH := aHandler;
end;

initialization
  // redirect error output
  xmlSetGenericErrorFunc(nil, @myGenericErrorFunc);
end.

