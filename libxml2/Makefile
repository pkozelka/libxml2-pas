LIBNAME=libxml2
VERSION=2.4.12
PACKAGE=$(LIBNAME)-pas
ARCHIVE=$(PACKAGE)-$(VERSION)
TAG=`echo "LIBXML_$(VERSION)" | sed "s/\./_/g"`
MYTMP=./$(TAG).tmp
CVSROOT=:pserver:anonymous@cvs.sourceforge.net:/cvsroot/libxml2-pas
DCCOPTS=-B -U../libxml2

all: compile

compile: compile-$(OSTYPE)
compile-cygwin:
	dcc32 $(DCCOPTS) $(LIBNAME).pas
compile-linux-gnu:
	dcc $(DCCOPTS) $(LIBNAME).pas

checkapi:
	../utils/checkApiChanges.sh :pserver:anonymous@anoncvs.gnome.org:/cvs/gnome gnome-xml/include/libxml HEAD *.inc

cvsexport: clean
	mkdir $(MYTMP)
	cvs -z4 -d $(CVSROOT) export -l -r HEAD -d $(MYTMP) .
	cvs -z4 -d $(CVSROOT) export -r $(TAG) -d $(MYTMP) .

tgz:
	cd $(MYTMP);tar -zcf ../$(ARCHIVE).tgz *;cd ..

zip:
	cd $(MYTMP);zip -rq ../$(ARCHIVE).zip *;cd ..

upload-tgz:
	ftp-put.sh upload.log upload.sourceforge.net incoming $(ARCHIVE).tgz $(ARCHIVE).tgz anonymous libxml2-pas@sourceforge.net; cat upload.log; rm upload.log

upload-zip:
	ftp-put.sh upload.log upload.sourceforge.net incoming $(ARCHIVE).zip $(ARCHIVE).zip anonymous libxml2-pas@sourceforge.net; cat upload.log; rm upload.log

utgz: cvsexport tgz upload-tgz clean

uzip: cvsexport zip upload-zip clean


clean:
	rm -rf *.tmp
	rm -f $(ARCHIVE).tgz
	rm -f $(ARCHIVE).zip
