{
   security.h: interface for the XSLT security framework

   See Copyright for the status of this software.

   daniel@veillard.com
  }
{$IFNDEF __XML_XSLT_SECURITY_H__}
{$DEFINE __XML_XSLT_SECURITY_H__}
{$include <libxml/tree.h>}
{$include "xsltInternals.h"}
{ C++ extern C conditionnal removed }
{
   xsltSecurityPref:

   structure to indicate the preferences for security in the XSLT
   transformation.
  }
type
   _xsltSecurityPrefs = xsltSecurityPrefs;

   xsltSecurityPrefsPtr = xsltSecurityPrefs;
{
   xsltSecurityOption:

   the set of option that can be configured
  }

   xsltSecurityOption = (XSLT_SECPREF_READ_FILE := 1,XSLT_SECPREF_WRITE_FILE,
     XSLT_SECPREF_CREATE_DIRECTORY,XSLT_SECPREF_READ_NETWORK,
     XSLT_SECPREF_WRITE_NETWORK);
{
   xsltSecurityCheck:

   User provided function to check the value of a string like a file
   path or an URL ...
  }
()

   xsltSecurityCheck = function (sec: xsltSecurityPrefsPtr; ctxt: xsltTransformContextPtr; value: Pchar): Longint; cdecl;
{
   Module interfaces
  }

function xsltNewSecurityPrefs: xsltSecurityPrefsPtr; cdecl; external LIBXML2_SO;
procedure xsltFreeSecurityPrefs(sec: xsltSecurityPrefsPtr); cdecl; external LIBXML2_SO;
function xsltSetSecurityPrefs(sec: xsltSecurityPrefsPtr; option: xsltSecurityOption; func: xsltSecurityCheck): Longint; cdecl; external LIBXML2_SO;
function xsltGetSecurityPrefs(sec: xsltSecurityPrefsPtr; option: xsltSecurityOption): xsltSecurityCheck; cdecl; external LIBXML2_SO;
procedure xsltSetDefaultSecurityPrefs(sec: xsltSecurityPrefsPtr); cdecl; external LIBXML2_SO;
function xsltGetDefaultSecurityPrefs: xsltSecurityPrefsPtr; cdecl; external LIBXML2_SO;
function xsltSetCtxtSecurityPrefs(sec: xsltSecurityPrefsPtr; ctxt: xsltTransformContextPtr): Longint; cdecl; external LIBXML2_SO;
()
function xsltSecurityAllow(sec: xsltSecurityPrefsPtr; ctxt: xsltTransformContextPtr; value: Pchar): Longint; cdecl; external LIBXML2_SO;
()
function xsltSecurityForbid(sec: xsltSecurityPrefsPtr; ctxt: xsltTransformContextPtr; value: Pchar): Longint; cdecl; external LIBXML2_SO;
{
   internal interfaces
  }
()
function xsltCheckWrite(sec: xsltSecurityPrefsPtr; ctxt: xsltTransformContextPtr; URL: PxmlChar): Longint; cdecl; external LIBXML2_SO;
()
function xsltCheckRead(sec: xsltSecurityPrefsPtr; ctxt: xsltTransformContextPtr; URL: PxmlChar): Longint; cdecl; external LIBXML2_SO;

{$ENDIF}
{ __XML_XSLT_SECURITY_H__  }

