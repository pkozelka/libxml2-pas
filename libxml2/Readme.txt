TEMPORARY NOTE:
---------------
- special build of libxml2.dll is needed to work with this release. 
You will find it at http://cvs.sourceforge.net/cgi-bin/viewcvs.cgi/*checkout*/libxml2-pas/libxml2/Attic/libxml2.zip?rev=1.4

Delphi-Headers for libxml2
==========================
Libxml2 is a low-level library for the work with xml-documents.
libxml2-pas is translation of the header files into Pascal language.

AUTHORS
-------
Petr Kozelka <pkozelka@email.cz>	-  original header translations
Uwe Fechner <ufechner@4commerce.de>	-  testing, demo application(s)


VERSION COMPLIANCE
------------------
This set of units was successfully tested with libxml2 version 2.4.11. However, 
translations of some API functions might be missing.


WHAT YOU FIND IN THIS PACKAGE
-----------------------------
libxml2/		- pascal translations of the libxml2 headers
demos/libxml2/		- demo applications
demos/libxml2/demo1/	- demo application for xpath testing (by Uwe Fechner)


USAGE
-----
Note that you should *NEVER* need to include any of the *.inc files in the translation directory.
To use functions implemented in libxml2, you just put "libxml2" into your _uses_ list:

program MyPrg;
uses libxml2;
begin
  ... your code here ...
end.

The following dlls are necessary and must be placed in this directory or in a 
directory listed in the PATH environment variable:

iconv.dll
libxml2.dll

H2PAS options
-------------
The utility h2pas was used with the following options:
h2pas -d -e -c -i <filename>.h -o libxml_<filename>.inc

LINKS
-----
http://sourceforge.net/projects/libxml2-pas			- project's web site
mailto:libxml2-pas-devel@lists.sourceforge.net			- mailing list
http://xmlsoft.org/						- the libxml2 libraries web site
http://www.fh-frankfurt.de/~igor/projects/libxml/index.html	- Windows build of libxml2 by Igor Zlatkovic

