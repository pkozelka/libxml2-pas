LIBNAME=libxml2
I_VERSION="VERSION=`../utils/cutver.sh libxml_xmlwin32version.inc`"
PACKAGE=$(LIBNAME)-pas
ARCHIVE=$(PACKAGE)-$(VERSION)-src
TAG="`echo LIBXML2_$(VERSION) | sed 's/\./_/g'`"
MYTMP=./$(TAG).tmp
CVSROOT=:pserver:anonymous@cvs.sourceforge.net:/cvsroot/libxml2-pas
DCCOPTS=-B -U../libxml2

all: compile

compile: compile-$(OSTYPE)
compile-cygwin:
	dcc32 $(DCCOPTS) $(LIBNAME).pas
compile-linux-gnu:
	dcc $(DCCOPTS) $(LIBNAME).pas

dist:
	./mkrelease dist
upload:
	./mkrelease upload

checkapi:
	../utils/checkApiChanges.sh :pserver:anonymous@anoncvs.gnome.org:/cvs/gnome gnome-xml/include/libxml HEAD *.inc

clean:
	echo "Cleaning"
	rm -f *.dcu
	rm -rf *.tmp
	rm -f $(ARCHIVE).tgz
	rm -f $(ARCHIVE).zip
