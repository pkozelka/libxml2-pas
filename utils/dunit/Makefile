
TGZFILE=dunit-kylix-4.1.3.tar.gz
ZIPFILE=dunit-5.0.1.zip
URLBASE=http://prdownloads.sourceforge.net/dunit

# The directory where you locally store downloaded files
# please your usual download location here, otherwise current dir will be used
DOWNLOADDIR=.

all: extract-$(OSTYPE)


download: download-$(OSTYPE)
download-cygwin:
	if [ ! -e $(DOWNLOADDIR)/$(ZIPFILE) ] ; then wget $(URLBASE)/$(ZIPFILE); fi
download-linux-gnu:
	if [ ! -e $(DOWNLOADDIR)/$(TGZFILE) ] ; then wget $(URLBASE)/$(TGZFILE); fi

extract-cygwin: download-cygwin
	unzip $(DOWNLOADDIR)/$(ZIPFILE)
extract-linux-gnu: download-linux-gnu
	tar zxvf $(DOWNLOADDIR)/$(TGZFILE)

compile: compile-$(OSTYPE)
compile-cygwin: extract-cygwin
	cd src;dcc32 -B dunit.dpr
compile-linux-gnu: extract-linux-gnu
	cd src;dcc -B dunit.dpr

src/dunit.exe: compile-cygwin
src/dunit: compile-linux-gnu
