Special Remark:
===============

The current version of dom2 works only with the libxml2 dll,
that is contained in libxml.zip in this directory.
There is a bug in the current libxml2.dll from Igor.
Get this libxml.dll file, rename it to libxml2.dll and use
it until the bug in Igor's dll is fixed.

New in the version from 2001-01-03 in Dom2.pas:
-----------------------------------------------

You can choose between enums for NodeTypes and integer for NodeTypes.
Integer-values are used by xmldom.pas from Borland (D6 Enterprise),
so if you want to write code, that is compatible to xmldom.pas than
use {$DEFINE NodeTypeInteger}.


The files in this directory:
----------------------------

Dom2.pas
.
a dom2-complient interface unit, translated from Java by Martijn Brinkers,
some xmldom.pas (a similar wrapper from Borland, but not open source) 
compatibility added by Uwe Fechner

libxmldom.pas

an implementation for the dom2.pas interfaces, using the libxml2-pas wrapper,
that you can find in the folder libxml2 here in the cvs

msxmldom.pas

an implementation for the dom2.pas interfaces, using msxml-dom

MSXML_TLB.pas

a type-library, needed by msxmldom.pas

MSXML3.pas

a new version of this type-library, needed if you use the msxml 4.0 parser

You can download it at:
http://www.microsoft.com/downloads/release.asp?ReleaseID=33037

Be careful, msxml 3.0 and msxml 4.0 are not completly compatible.
The nodeselect interface of msxml 4.0 uses the full xpath syntax,
msxml 3.0 a proprietary limited syntax.

tests_libxml2.pas
a list of the dom2-functions, already implemented in libxmldom.pas

Uwe Fechner


