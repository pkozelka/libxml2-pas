{
    ------------------------------------------------------------------------------
    This unit collects all the translated headers of libxslt (aka gnome-xslt).
    Copyright for the header translation:
        4commerce technologies AG
        Kamerbalken 10-14
        22525 Hamburg, Germany
    Published under a double license:
    a) the GNU Library General Public License: 
       http://www.gnu.org/copyleft/lgpl.html
    b) the Mozilla Public License:
       http://www.mozilla.org/MPL/MPL-1.1.html
    Please send corrections to: ufechner@4commerce.de
    See also:
        http://xmlsoft.org/XSLT/  - the libxslt homepage
    ------------------------------------------------------------------------------
}
unit libxslt;

interface

uses libxml2;

const
	LIBXSLT_SO = 'libxslt.dll';

{$WEAKPACKAGEUNIT}

{$MINENUMSIZE 4}
{$ASSERTIONS OFF}

const
	XSLT_DEFAULT_VERSION = '1.0';
	XSLT_DEFAULT_VENDOR = 'libxslt';
	XSLT_DEFAULT_URL = 'http://xmlsoft.org/XSLT/';

type
	PFILE = ^file; // work around
								 // access to filehandles doesn't work yet

function XSLT_NAMESPACE : PxmlChar;

{
	Global cleanup function
}
procedure xsltCleanupGlobals;cdecl;external LIBXSLT_SO;

{$I libxslt_xsltInternals.inc}
{$I libxslt_transform.inc}
{$I libxslt_xsltutils.inc}
{$I libxslt_attributes.inc}
{$I libxslt_documents.inc}

{$I libxslt_extensions.inc}
{$I libxslt_extra.inc}
{$I libxslt_functions.inc}
{$I libxslt_keys.inc}
{$I libxslt_namespaces.inc}
{$I libxslt_pattern.inc}
{$I libxslt_preproc.inc}
{$I libxslt_templates.inc}
{$I libxslt_imports.inc}
{$I libxslt_variables.inc}

implementation

function XSLT_NAMESPACE : PxmlChar;
begin
	 XSLT_NAMESPACE:=PxmlChar('http://www.w3.org/1999/XSL/Transform');
end;

{$I libxslt_extra.imp}

end.


