#!/bin/bash

function grepWarn()
{
	local aPattern=$1
	local aFile=$2
	local aPattern2=$3

	if grep "$aPattern" "$aFile" >/dev/null; then
		true
	else
		echo "WARNING - file \"$aFile\" does not contain pattern \"$aPattern\"" >/dev/stderr
		if [ "$aPattern2" != "" ]; then
			grep "$aPattern2" "$aFile" >/dev/stderr
		fi
	fi
}

function checkSrcVersions()
{
	# warn on forgotten version updates
	grepWarn "libxml2-pas $LIBXML_VERSION" NEWS.txt
	grepWarn "libxslt-pas $LIBXSLT_VERSION" NEWS.txt
	grepWarn "libexslt-pas $LIBEXSLT_VERSION" NEWS.txt
	grepWarn "LIBXML_DOTTED_VERSION = '"$LIBXML_VERSION"'" src/libxml2_xmlwin32version.inc 'LIBXML_DOTTED_VERSION[[:space:]]*='
	grepWarn "LIBXSLT_DOTTED_VERSION = '"$LIBXSLT_VERSION"'" src/libxslt_xsltwin32config.inc 'LIBXSLT_DOTTED_VERSION[[:space:]]*='
	grepWarn "LIBEXSLT_DOTTED_VERSION = '"$LIBEXSLT_VERSION"'" src/libexslt_exsltconfig.inc 'LIBEXSLT_DOTTED_VERSION[[:space:]]*='
}

function copySourceFilesToDist()
{
	# copy files to be released there
	mkdir $DIST/src
	cp $SRC/*.inc $SRC/*.pas $DIST/src
	cp $HEADERS_DIR/*.txt $DIST
	cp $HEADERS_DIR/../common/license/COPYING* $DIST

	local pkgVer="$LIBXML_MAJOR_VERSION"_"$LIBXML_MINOR_VERSION"_"$LIBXML_MICRO_VERSION"
	# update LIBSUFIX and remove resource include directive
sed -f - $SRC/libxml2_pas.dpk >$DIST/src/libxml2_pas.dpk <<EOF
s/devel/_$pkgVer/
s/\$R \*.res//
EOF
	# prepare JEDI info file
sed -f - INFO.txt.template > $DIST/INFO.txt <<EOF
s:@DATE@:`date +'%d %b %Y'`:g
s:@LIBXML_VERSION@:$LIBXML_VER:g
s:@LIBXSLT_VERSION@:$LIBXSLT_VER:g
s:@LIBEXSLT_VERSION@:$LIBEXSLT_VER:g
EOF
}

function makeZip()
{
	zip -qr $HEADERS_DIR/libxml2-pas-$LIBXML_VER-src.zip *
}

function makeTgz()
{
	tar -zcf $HEADERS_DIR/libxml2-pas-$LIBXML_VER-src.tgz *
}

function convertToLf()
{
	for fn in $*; do
		echo -ne "convertToLf: $fn                                \015"
		tr -d '\015' < $fn > $fn.stripcr
		mv $fn.stripcr $fn
	done
	echo -ne "                                                                       "
}

function singleFileToCrLf()
{
	local fn=$1
	cat $fn | while read line; do
		echo -n "$line"
		echo -ne "\r\n"
	done;
}

function convertToCrLf()
{
	for fn in $*; do
		echo -ne "convertToLf: $fn                                \015"
		singleFileToCrLf $fn >$fn.crlf
		mv $fn.crlf $fn
	done
	echo -ne "                                                                       "
}

function compressDist()
{
	cd $DIST
	if [ "$TERM" == "cygwin" ]; then
		makeZip
		convertToLf `find . -type f`
		makeTgz
	else
		makeTgz
		convertToCrLf `find . -type f`
		makeZip
	fi
}

function compile()
{
	cd $DIST/src
	dcc -H -Q -N. -E. libxml2_pas.dpk
	zip -qr $HEADERS_DIR/libxml2-pas-$LIBXML_VER-D6.zip *.dcp *.bpl
}

# check that LIBXML2_PAS env. var. is correct
if [ ! -d "$LIBXML2_PAS" ]; then
	echo "ERROR - variable LIBXML2_PAS must point to the root of libxml2-pas working copy" >/dev/stderr
	exit -1
fi

# check that GNOMECVSROOT env. var. is correct
if [ ! -d "$GNOMECVSROOT/gnome-xml" ]; then
	echo "ERROR - variable GNOMECVSROOT must point to the root of libxml2-pas working copy" >/dev/stderr
	exit -1
fi

# initialize versions
for cmd in `grep -he '^LIB[[:alnum:]]\+_[[:alpha:]]\+_VERSION=[[:digit:]]\+$' $GNOMECVSROOT/gnome-xml/configure.in $GNOMECVSROOT/libxslt/configure.in`; do
	export $cmd
done

#  dotted versions
export LIBXML_VERSION=$LIBXML_MAJOR_VERSION.$LIBXML_MINOR_VERSION.$LIBXML_MICRO_VERSION
export LIBXSLT_VERSION=$LIBXSLT_MAJOR_VERSION.$LIBXSLT_MINOR_VERSION.$LIBXSLT_MICRO_VERSION
export LIBEXSLT_VERSION=$LIBEXSLT_MAJOR_VERSION.$LIBEXSLT_MINOR_VERSION.$LIBEXSLT_MICRO_VERSION

#  dashed versions
export LIBXML_VER=$LIBXML_MAJOR_VERSION-$LIBXML_MINOR_VERSION-$LIBXML_MICRO_VERSION
export LIBXSLT_VER=$LIBXSLT_MAJOR_VERSION-$LIBXSLT_MINOR_VERSION-$LIBXSLT_MICRO_VERSION
export LIBEXSLT_VER=$LIBEXSLT_MAJOR_VERSION-$LIBEXSLT_MINOR_VERSION-$LIBEXSLT_MICRO_VERSION

# Initialize directories
HEADERS_DIR=$LIBXML2_PAS/headers
SRC=$HEADERS_DIR/src
TMP=${TMP:-"$HOME/tmp"}/libxml2-pas-$LIBXML_VER
rm -rf $TMP
mkdir -p $TMP
DIST=$TMP/dist
rm -rf $DIST
mkdir $DIST

aCmd=$1

case $aCmd in
dist)
	checkSrcVersions
	copySourceFilesToDist
	compressDist
	;;
upload)
	echo "NOT IMPLEMENTED YET"
	;;
bin)
	checkSrcVersions
	copySourceFilesToDist
	compile
	;;
esac
