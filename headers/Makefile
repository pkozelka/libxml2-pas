all:
	echo "Compilation currently not supported by Makefile."
dist:
	utils/mkrelease.sh dist
upload:
	utils/mkrelease.sh upload

bin:
	utils/mkrelease.sh bin
	
checkapi:
	utils/checkapi.sh $(GNOMECVSROOT) src/lib*.inc

libxml2.html: style/headers.xsl $(GNOMECVSROOT)/gnome-xml/doc/libxml2-api.xml
	xsltproc --stringparam aExternalConst LIBXML2_SO -o libxml2.html style/headers.xsl $(GNOMECVSROOT)/gnome-xml/doc/libxml2-api.xml

libxslt.html: style/headers.xsl $(GNOMECVSROOT)/libxslt/doc/libxslt-api.xml
	xsltproc --stringparam aExternalConst LIBXSLT_SO -o libxslt.html style/headers.xsl $(GNOMECVSROOT)/libxslt/doc/libxslt-api.xml

libexslt.html: style/headers.xsl $(GNOMECVSROOT)/libxslt/doc/libexslt-api.xml
	xsltproc --stringparam aExternalConst LIBEXSLT_SO -o libexslt.html style/headers.xsl $(GNOMECVSROOT)/libxslt/doc/libexslt-api.xml

html: libxml2.html libxslt.html libexslt.html
