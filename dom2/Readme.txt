The files in this directory:

Dom2.pas

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

tests_libxml2.pas
a list of the dom2-functions, already implemented in libxmldom.pas

Uwe Fechner, 2001-12-23



