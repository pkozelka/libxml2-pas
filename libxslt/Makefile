VERSION=1.0.8
PACKAGE=libxslt-pas
ARCHIVE=$(PACKAGE)-$(VERSION)
TAG=`echo "LIBXSLT_$(VERSION)" | sed "s/\./_/" | sed "s/\./_/"`
CVSROOT=:pserver:anonymous@cvs.sourceforge.net:/cvsroot/libxml2-pas

all:
	echo $(TAG)

cvsexport: clean
	mkdir tmp
	cvs -d $(CVSROOT) export -l -r HEAD -d tmp .
	cvs -d $(CVSROOT) export -r $(TAG) -d tmp .

tgz:
	cd tmp;tar -zcf ../$(ARCHIVE).tgz *;cd ..
	mv $(ARCHIVE).tgz ..

zip:
	cd tmp;zip -rq ../$(ARCHIVE).zip *;cd ..
	mv $(ARCHIVE).zip ..

upload-tgz:
	ftp-put.sh upload.log upload.sourceforge.net incoming $(ARCHIVE).tgz $(ARCHIVE).tgz anonymous libxml2-pas@sourceforge.net; cat upload.log; rm upload.log

upload-zip:
	ftp-put.sh upload.log upload.sourceforge.net incoming $(ARCHIVE).zip $(ARCHIVE).zip anonymous libxml2-pas@sourceforge.net; cat upload.log; rm upload.log

clean:
	rm -rf ./tmp
	rm -f $(ARCHIVE).tgz | true
	rm -f $(ARCHIVE).zip | true
	rm -f ../$(ARCHIVE).tgz | true
	rm -f ../$(ARCHIVE).zip | true
