Delphi-Headers for libxml2
==========================
libxml2 is a low-level library for the work with xml-documents.
libxslt is a low-level library implementing the XSL Transformations standard
libxmlsec is a low-level library implementing XML security standards
libxml2-pas is translation of their header files into Pascal language.

Contents:
	AUTHORS
	VERSION COMPLIANCE
	WHAT YOU FIND IN THIS PACKAGE
	USAGE
	GENERATING THE PASCAL BINDINGS
	LINKS
	HOW TO HELP


AUTHORS
-------
Eric Zurcher <Eric.Zurcher@csiro.au>
        - interface generation from API description via XSLT stylesheet 
Petr Kozelka <pkozelka@email.cz>
	-  original header translations

Following people contributed:

Uwe Fechner <ufechner@4commerce.de>
	- testing, demo application(s), initiated the libxslt translation
Martijn Brinkers <martijn_brinkers@yahoo.co.uk>
Mikhail Soukhanov <m.soukhanov@geosys.ru>

VERSION COMPLIANCE
------------------
libxml2: 2.6.26
libxslt: 1.1.17
libexslt: 0.8.13
libxmlsec: 1.2.10

WHAT YOU FIND IN THIS PACKAGE
-----------------------------
libxml2.pas, 
libxslt.pas, 
libexslt.pas,
libxmlsec.pas			 	- pascal bindings generated from API descriptions
style/DelphiAPI.xsl			- XSLT transformation used to generate the Pascal code
src/					- older pascal translations generated from the libxml2 headers (obsolete)
demos/libxml2-test/			- demo applications
demos/demo1/				- demo application for xpath testing (by Uwe Fechner)
demos/simplexslt/			- demo application for XSLT testing
demos/xmlsec-test/			- demo application for xmlsec testing (by Eric Zurcher)


USAGE
-----
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
(plus, for libxslt):
	libxslt.dll
	libexslt.dll

On Linux system, you need the corresponding ".so" shared object files.

KNOWN PROBLEMS
--------------
- extending the xslt-processor with own functions doesn't work yet
- only a rather small part of the API has been tested

GENERATING THE PASCAL BINDINGS (if you want to do it yourself)
------------------------------
DelphiAPI.xsl is an XSLT stylesheet for transforming the interface to libxml2, 
as described in libxml2-api.xml, into Delphi bindings. The same stylesheet may
also be applied to the libxslt and libexslt descriptions to generate Delphi
bindings for those libraries.

Usage:
	xsltproc [--stringparam unit unit-name] DelphiAPI.xsl source-file

Examples:
	xsltproc --output libxml2.pas DelphiAPI.xsl libxml2-api.xml 

	xsltproc --output libxslt.pas --stringparam unit libxslt DelphiAPI.xsl libxslt-api.xml


The resulting Pascal code may not be perfect - a small amount of manual editing
will typically be required to get the code to compile correctly. For example,
a name conflicts may need to be resolved as a consequence of Delphi's lack of
case-sensitivity (e.g. the xmlXPathError enumeration vs. the xmlXPatherror 
procedure). A few delarations may need to be reordered, as when one structure
(e.g., xmlGlobalState) includes other structures within it. 

The transform operates only upon the contents of the <symbols> element of the 
interface description.

No attempt is made to declare or convert the macros defined in the interface,
nor are conditional macros considered when generating the bindings.

Enumerations, typedefs, structs, and functypes are converted to their Delphi 
equivalents, and imported functions are fully declared.

Imported "variables" are a bit more problematic, for two reasons: (1) Delphi
does not provide direct support for the concept of an imported variable, and 
(2) some of these (at least in thread-aware versions of libxml2) are actually
implemented in part as C macros. In many of these cases (for example,
"xmlParserVersion") the "variable" is actually implemented as a function
with a double underscore prepended to the name, which returns a pointer the 
desired value. I attempt to import these functions (though there is
no reliable way of knowing which variables are so implemented); to use
them in a Delphi application, one can use "__xmlParserVersion()^" rather
than "xmlParserVersion". In some other cases (notably xmlMalloc, xmlFree,
and friends), the exported variable is a pointer to a function. These
are handled by proxy functions which are implemented by using GetProcAddress 
during module initialization to obtain the address of the pointer to the 
function.

LINKS
-----
http://sourceforge.net/projects/libxml2-pas			- project's web site
mailto:libxml2-pas-devel@lists.sourceforge.net			- mailing list
http://xmlsoft.org/						- the libxml2 libraries web site
http://www.zlatkovic.com/projects/libxml/index.html		- Windows build of libxml2 by Igor Zlatkovic


HOW TO HELP
-----------
You can help the project in various ways: the best thing to do first is to subscribe 
to the abovementioned mailing-list, have a look at the archives; then you can: 
* provide patches when you find problems 
* provide new documentation pieces (translations, examples, etc ...) 
* implement new features 
* help with the packaging 
* test, give feedback, send bugreports... 
