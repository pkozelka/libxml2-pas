Abstract
--------

The dom2-pas library is an implementation of the W3C DOM standard.
It consists of
	- generic DOM2 interfaces (idom2.pas)
	- implementation wrapper for libxml parser
	- implementation wrapper for MS XMLDOM parser


History
-------
At the beginning, Petr started to work on the "msxml" module. The intent was to
develop a wrapper for the libxml2 using the interfaces introduced by MS XMLDOM component.
Soon, Uwe joined the team offering an implementation of libxml2 wrapper with different
DOM2 interfaces - idom2.pas (called just dom2.pas by that time) from Martijn Brinkers.
Also Martijn decided to join the team and supplied also his idom2.pas wrapper for MSXML.
Later, Martijn and Uwe also started to supply various unittests based on the DUNIT 
project (at SourceForge).
After some time of development, Uwe decided to start independent project at SourceForge.
See more at http://idom2-pas.sourceforge.net

Links
-----
Project site: http://libxml2-pas.sourceforge.net
Mailing list: libxml2-pas-devel@lists.sourceforge.net
Gnome-xml:    http://xmlsoft.org

Original authors
----------------
[pk]	Petr Kozelka <pkozelka@email.cz>
[mb]	Martijn Brinkers <martijn_brinkers@yahoo.co.uk>
[uf]	Uwe Fechner <ufechner@4commerce.de>
