LIBNAME=libxslt
PACKAGE=$(LIBNAME)-pas
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
	../utils/checkApiChanges.sh :pserver:anonymous@anoncvs.gnome.org:/cvs/gnome libxslt/libxslt HEAD *.inc

clean:
	echo "Cleaning"
	rm -f *.dcu
	rm -rf *.tmp
