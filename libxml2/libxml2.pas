unit libxml2;

{
	------------------------------------------------------------------------------
	This unit collects all the translated headers of libxml2 (aka gnome-xml).
	2001 (C) Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
	See also:
		http://www.xmlsoft.org  - the libxml2 homepage
		http://kozelka.hyperlink.cz  - my homepage
		test
}

interface

const
{$ifdef WIN32}
	LIBXML2_SO = 'libxml2.dll';
{$endif}
{$ifdef LINUX}
	LIBXML2_SO = 'libxml2.so';
{$endif}

{$WEAKPACKAGEUNIT}

{$ifdef VER140}
{$ALIGN 4}
{$endif}
{$MINENUMSIZE 4}
{$ASSERTIONS OFF}

type
	DWORD = integer;
	PLongInt = ^LongInt;
	PByte = ^byte;
	PPChar = ^PChar;

{$I libxml_xmlmemory.inc}
{$I libxml_tree.inc}
{$I libxml_encoding.inc}
{$I libxml_xmlIO.inc}
{$I libxml_hash.inc}
{$I libxml_entities.inc}
{$I libxml_list.inc}
{$I libxml_valid.inc}
{$I libxml_parser.inc}
{$I libxml_SAX.inc}

{$I libxml_xpath.inc}
{$I libxml_xpointer.inc}

{$I libxml_xmlerror.inc}
{$I libxml_xlink.inc}
{$I libxml_DOCBparser.inc}
{$I libxml_HTMLparser.inc}
{$I libxml_HTMLtree.inc}
{$I libxml_xinclude.inc}
{$I libxml_debugXML.inc}
{$I libxml_catalog.inc}
{$I libxml_nanoftp.inc}
{$I libxml_nanohttp.inc}
{$I libxml_uri.inc}

implementation

{$I libxml_xpath_IMPL.inc}

end.







