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

function copyCommonSourcesToDist()
{
	rm -rf $DIST
	mkdir $DIST

	# copy files to be released there
	mkdir $DIST/src
	cp $SRC/*.inc $SRC/*.pas $DIST/src
	cp $HEADERS_DIR/*.txt $DIST
	cp $HEADERS_DIR/../common/license/COPYING* $DIST

	# prepare JEDI info file
sed -f - $HEADERS_DIR/INFO.txt.template > $DIST/INFO.txt <<EOF
s:@DATE@:`date +'%d %b %Y'`:g
s:@LIBXML_VERSION@:$LIBXML_VER:g
s:@LIBXSLT_VERSION@:$LIBXSLT_VER:g
s:@LIBEXSLT_VERSION@:$LIBEXSLT_VER:g
EOF
}

function prepareWin32Src()
{
	# prepare resource script file
	DCC_VER=`$DCC --version | tr -d '\015' | tr '\012' ';'` 
sed -f - $SRC/libxml2_pas.rc.template > $DIST/src/libxml2_pas.rc <<EOF
s:@COMPILER_VERSION@:$DCC_VER:g
s:@CURRENT_YEAR@:`date +%Y`:g
s:@LIBXML_MAJOR_VERSION@:$LIBXML_MAJOR_VERSION:g
s:@LIBXML_MINOR_VERSION@:$LIBXML_MINOR_VERSION:g
s:@LIBXML_MICRO_VERSION@:$LIBXML_MICRO_VERSION:g
EOF

	cp $SRC/libxml2_pas.dpk $DIST/src
	if $CYGWIN; then
		# create the resource file
		pwd=`pwd`
		cd $DIST/src
		brcc32 libxml2_pas.rc
		rm libxml2_pas.rc
		cd $pwd
	else

cat - >$DIST/src/HOWTO-CreateRes.txt <<EOF
Before you compile the package, you need to supply the libxml2_pas.res file
that is bound to the resulting .BPL file.
It can be created with this command:
	brcc32.exe libxml2_pas.rc
The file could not included, because the distribution was created on Linux.
EOF

	fi
}

function prepareLinuxSrc()
{
	# remove resource include directive (I don't know how to compile resources under Linux)
	sed 's/\$R \*.res//' $SRC/libxml2_pas.dpk >$DIST/src/libxml2_pas.dpk
}

function makeZip()
{
	prepareWin32Src
	pwd=`pwd`
	cd $DIST
	local archFile=$HEADERS_DIR/libxml2-pas-$LIBXML_VER-src.zip
	zip -qr $archFile.part *
	mv $archFile.part $archFile
	cd $pwd
}


function makeTgz()
{
	prepareLinuxSrc
	pwd=`pwd`
	cd $DIST
	local archFile=$HEADERS_DIR/libxml2-pas-$LIBXML_VER-src.tgz
	tar -zcf $archFile.part *
	mv $archFile.part $archFile
	cd $pwd
}

function convertToLf()
{
	for fn in $*; do
		echo -ne "convertToLf: $fn                                \015"
		tr -d '\015' < $fn > $fn.stripcr
		mv $fn.stripcr $fn
	done
	echo -e "                                                                       "
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
	echo -e "                                                                       "
}

function compressDist()
{
	if [ "$TERM" == "cygwin" ]; then
		# native part
		copyCommonSourcesToDist
		makeZip

		# foreign part
		copyCommonSourcesToDist
		cd $DIST
		convertToLf `find . -type f`
		makeTgz
	else
		# native part
		copyCommonSourcesToDist
		makeTgz

		# foreign part
		copyCommonSourcesToDist
		cd $DIST
		convertToCrLf `find . -type f`
		makeZip
	fi
}

function compile()
{
	if $CYGWIN; then
		prepareWin32Src
		pack='zip -qr '
	else
		prepareLinuxSrc
		pack='tar -zcf '
	fi
	pwd=`pwd`
	cd $DIST/src
	for fn in *.pas libxml2_pas.dpk; do
		echo "Compiling $fn:"
		$DCC -H -Q -N. -E. $fn
	done
	rm libxml2_pas.dcu
	mkdir -p $DIST/lib
	cp *.dcp *.bpl *.dcu $DIST/lib
	cd $DIST
	$pack $HEADERS_DIR/libxml2-pas-$LIBXML_VER-$DV.zip lib
	cd $pwd
}

# check that LIBXML2_PAS env. var. is correct
if [ ! -d "$LIBXML2_PAS" ]; then
	echo "ERROR - variable LIBXML2_PAS must point to the root of libxml2-pas working copy" >/dev/stderr
	exit -1
fi

DELPHIVERSION=`dcc --version | head -2 | tail -1 | sed 's/[^[:digit:]]*//'`
case `uname` in
CYGWIN*)
	CYGWIN="true"
	DCC="dcc32"
	case "$DELPHIVERSION" in
	13*)
		DV='D5'
		;;
	14*)
		DV='D6'
		;;
	*)
		echo "Unknown Delphi version: $DELPHIVERSION"
		exit -1
		;;
	esac
	;;
*)
	CYGWIN="false"
	DCC="dcc"
	case "$DELPHIVERSION" in
	13*)
		DV='K1'
		;;
	14*)
		DV='K2'
		;;
	*)
		echo "Unknown Kylix version: $DELPHIVERSION"
		exit -1
		;;
	esac
	;;
esac

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
aCmd=$1

case "$aCmd" in
dist)
	checkSrcVersions
	compressDist
	;;
upload)
#ftp-put.sh upload.log upload.sourceforge.net incoming $1 $1 anonymous libxml2-pas@sourceforge.net
#cat upload.log
#rm -f upload.log
	echo "NOT IMPLEMENTED YET"
	;;
bin)
	checkSrcVersions
	copyCommonSourcesToDist
	compile
	;;
*)
	echo "Invalid command: $aCmd" >/dev/stderr
	exit -1
	;;
esac
