#!/bin/sh
# This program compares list of symbols in the libxml2.dll, with list of functions implemented in libxml2 module.
# The lists are sorted and compared; resulting differences indicate what is missing where.
#
# (C) Petr Kozelka, 2002
#     <pkozelka@email.cz>
#
# TODO:
# - convert hardcoded parts into script arguments
# - make it more generic, so that it can later be usable for libxslt
# - autodetect source of DLL symbols
# - polish, brush, beautify :-)
#
# NOTES:
# - this script expects the file libxml2.def.src in current directory
# - the output displays symbols missing in the Pascal implementation at the left side, and symbols missing in the library on the right.


FILES="../libxml2/*.inc"
grep -h '^function'  $FILES >PASSYMBOLS.tmp
grep -h '^procedure' $FILES >>PASSYMBOLS.tmp
grep "external LIBXML2_SO;" PASSYMBOLS.tmp | sed "s/[a-zA-Z][a-zA-Z]*[[:space:]]*\([[:alnum:]]*\).*/\1/" | sort -u >PASSYMBOLS.txt
rm PASSYMBOLS.tmp

# libxml2.def version
#grep -v " DATA" libxml2.def | grep '^[[:space:]][[:alpha:]]' | sed "s/ //g" | sed "s/[[:space:]]*\([[:alnum:]]*\).*/\1/" | sort -u >DLLSYMBOLS.txt

# libxml2.def.src version
cvs -d:pserver:anonymous@anoncvs.gnome.org:/cvs/gnome export -d EXPORT -r HEAD gnome-xml/win32/dsp/libxml2.def.src
mv EXPORT/libxml2.def.src .
grep -v " DATA" libxml2.def.src | grep '^[[:space:]][[:alnum:]]*$' | sed "s/ //g" | sed "s/[[:space:]]*\([[:alnum:]]*\).*/\1/" | sort -u >DLLSYMBOLS.txt
rm -rf EXPORT

# DUMPBIN version - shows variables
#grep '^[[:space:]]\{6,\}[[:digit:]]\{1,\}[[:space:]]\{1,\}[[:digit:]]' libxml2.dll.txt \
# | sed "s/[[:space:]]\{6,\}[[:digit:]]\{1,\}[[:space:]]\{1,\}[[:xdigit:]]\{1,\}[[:space:]]\{1,\}[[:xdigit:]]\{1,\}[[:space:]]\{1,\}\(.*\)/\1/" \
# | sort -u >DLLSYMBOLS.txt


diff -d -y --suppress-common-lines DLLSYMBOLS.txt PASSYMBOLS.txt
