Delphi-Headers for libxslt
==========================
libxslt is a low-level library for the work with xml-documents.
libxslt-pas is translation of the header files into Pascal language.

AUTHORS
-------
Uwe Fechner <ufechner@4commerce.de> - original header translations
Petr Kozelka <pkozelka@email.cz>    - completed the translations and converted files into the CVS-SIGN maintenance format

VERSION COMPLIANCE
------------------
Please look into file 'libxml_xsltwin32config.inc' for value of constant LIBXSLT_DOTTED_VERSION.

WHAT YOU FIND IN THIS PACKAGE
-----------------------------
libxslt/		- pascal translations of the libxslt headers


KNOWN PROBLEMS
--------------
- extending the xslt-processor with own functions doesn't work yet
- no demo-program yet


USAGE
-----
The libxslt unit is typically used in applications which also use libxml2 unit.
Note that you should *NEVER* need to include any of the *.inc files in the translation directory.
To use functions implemented in libxslt, you just put "libxslt" into your _uses_ list:

program MyPrg;
uses libxml2,libxslt;
begin
  ... your code here ...
end.

The following dlls are necessary and must be placed in this directory or in a 
directory listed in the PATH environment variable:

iconv.dll
libxml2.dll
libxslt.dll
libexslt.dll


LINKS
-----
http://sourceforge.net/projects/libxml2-pas			- project's web site
mailto:libxml2-pas-devel@lists.sourceforge.net			- mailing list
http://xmlsoft.org/						- the libxml2 libraries web site
http://www.fh-frankfurt.de/~igor/projects/libxml/index.html	- Windows build of libxml2 by Igor Zlatkovic

