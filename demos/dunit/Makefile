#REV=build_5_0_1
REV=build_5_0_2
#REV=HEAD

TGZFILE=dunit-kylix-4.1.3.tar.gz
ZIPFILE=dunit-5.0.1.zip
URLBASE=http://prdownloads.sourceforge.net/dunit
CVS_DUNIT=:pserver:anonymous@cvs.sourceforge.net:/cvsroot/dunit

MYTMP=$(TMP)/dunit-$(REV).tmp

# The directory where you locally store downloaded files
# please your usual download location here, otherwise current dir will be used
DOWNLOADDIR=.

all: cvsexport

cvsclean:
	rm -rf $(MYTMP)

#
# Extracts the specified build (tag) out from the dunit's CVS repository
# if necessary (it is cached in the $TMP directory)
# and makes it ready for compiling
#
cvsexport: $(MYTMP)
	rm -rf *.dcu *.pas *.dfm *.txt *.kfm dunit.* images
	rm -rf $(MYTMP)/Makefile $(MYTMP)/.cvsignore
	cp -R $(MYTMP)/* .
	echo "$(REV)" >REVINFO.TXT
	
$(MYTMP):
	rm -rf $(MYTMP)
	cvs -d $(CVS_DUNIT) export -d $(REV).tmp -r $(REV) dunit/src
	mv $(REV).tmp $(MYTMP) 

#
# Copies dunit's sources from a local working copy,
# assuming that it is placed in the same directory base as the whole
# libxml2-pas project
#
cp:
	rm -rf tmp
	cp -R ../../../dunit/dunit/src tmp
	rm -rf *.dcu *.pas *.dfm *.txt *.kfm dunit.* images
	rm -rf tmp/CVS tmp/Makefile tmp/.cvsignore tmp/bin
	cp -R tmp/* .
	rm -rf tmp
	echo "LOCAL COPY" >REVINFO.TXT

#################################################33

download: download-$(OSTYPE)
download-cygwin:
	if [ ! -e $(DOWNLOADDIR)/$(ZIPFILE) ] ; then wget $(URLBASE)/$(ZIPFILE); fi
download-linux-gnu:
	if [ ! -e $(DOWNLOADDIR)/$(TGZFILE) ] ; then wget $(URLBASE)/$(TGZFILE); fi

extract: extract-$(OSTYPE)
	mv $(MYTMP)/src/* .
	rm -rf $(MYTMP)
extract-cygwin: download-cygwin
	mkdir $(MYTMP) | true
	unzip -d $(MYTMP) $(DOWNLOADDIR)/$(ZIPFILE)
extract-linux-gnu: download-linux-gnu
	mkdir $(MYTMP) | true
	cp $(DOWNLOADDIR)/$(TGZFILE) $(MYTMP)/
	cd $(MYTMP);tar zxvf $(TGZFILE);cd ..
	mv $(MYTMP)/dunit/src $(MYTMP)/src


compile: compile-$(OSTYPE)
compile-cygwin: extract-cygwin
	cd src;dcc32 -B dunit.dpr
compile-linux-gnu: extract-linux-gnu
	cd src;dcc -B dunit.dpr

src/dunit.exe: compile-cygwin
src/dunit: compile-linux-gnu
