#!/bin/bash

SPACES='                                                                        '

#
# Usage:
# checkapi.sh <localroot> [<files>]
#

# TODO:
#   - check that LIBXML2_PAS variable is correctly set
#   - check that <localroot> is a valid CVS working copy
#   - cache files in localroot for later use in diff

# translate file into pascal and apply known conversions
function toPascal()
{
	local aFileName=$1
	local aOutputFile=${2?'output file not specified'}
	local aSOPrefix=${3?'SO prefix not specified'}

	if [ "$H2PAS" != "" ] ; then
		echo "---------------- [$aFileName] -----------------" >>$TMP/h2pas.log
		# translate
		echo "Translating ${aFileName/#*\/} to ${aOutputFile/#*\/}.1"
		h2pas -d -c -i $aFileName -o $aOutputFile.1 1>&2 >>$TMP/h2pas.log

		# apply known replacements
		echo "  applying additional conversions --> ${aOutputFile/#*\/}"
		sed -f "$LIBXML2_PAS/headers/utils/afterconv.sed" $aOutputFile.1 > $aOutputFile.2 || mv $aOutputFile.1 $aOutputFile.2 
		local pfx=`echo ${aSOPrefix} | tr [:lower:] [:upper:]`
		sed 's:UNKNOWN_SO:'${pfx}'_SO:' $aOutputFile.2 > $aOutputFile

		# compare original translation and the one with replacements
#		diff -u4 -w $aOutputFile.1 $aOutputFile >$aOutputFile.diff12
		rm -f $aOutputFile.?
	fi
}

function getCvsRevision()
{
	local aFileName=$1
	local dirName=${aFileName%/*}
	local entry=${aFileName:${#dirName}+1}

	sed -n '/^\/'$entry'\//{s:^/'$entry'/\([^/]*\)/.*:\1:;p;}' $dirName/CVS/Entries
}

function cacheGet()
{
	local aPathName=$1
	local aRev=${2}
	local aTarget=${3?'target not specified'}

	local filePath=${aPathName%/*}
	local fileName=${aPathName:${#filePath}+1}
	local repos=`cat $filePath/CVS/Repository`

	local cachedFile=$TMPBASE/$repos/$fileName-$aRev
	[ -s "$cachedFile" ] || return -1
	cp $cachedFile $aTarget
}

function cachePut()
{
	local aPathName=$1
	local aRev=${2?'revision not specified'}

	local filePath=${aPathName%/*}
	local fileName=${aPathName:${#filePath}+1}
	local repos=`cat $filePath/CVS/Repository`

	local cachedFile=$TMPBASE/$repos/$fileName-$aRev
	if [ -s "$cachedFile" ]; then
		true
	else
		mkdir -p ${cachedFile%/*}
		cp $aPathName $cachedFile
	fi
}


LOCALROOT=$1
shift 1
FILELIST="$*"
TMPBASE=${TMP-"$HOME/tmp"}/checkapi
TMP=$TMPBASE/$$
RESULTFILE=checkapi-results.zip

CHGCOUNT=0
H2PAS=`which h2pas 2>/dev/null`
if [ "$H2PAS" = "" ] ; then
	haveH2Pas="false"
	echo "ERROR: h2pas not found, Pascal conversion will not take place" >&2
else
	haveH2Pas="true"
fi


rm -rf $TMP $RESULTFILE
mkdir -p $TMP

THISPATH=`pwd`
for fn in $FILELIST ; do
	cd $THISPATH
	echo -n "  $fn:  ${SPACES:0:40-${#fn}}"
	revInfo=`head $fn | sed -n '/CVS-REV/{s#.*CVS-REV:\([^:]*\):\([^:]*\):#\1:\2#;p;}'`
	if [ "$revInfo" = "" ]; then
		echo "-         -"
		echo "ERROR: no CVS-REV in $fn" >&2
		continue
	fi
	origFile=${revInfo%:*}
	curRev=${revInfo:${#origFile}+1}

	origFilePath="${origFile%/*}"
	origFileName="${origFile:${#origFilePath}+1}"
	echo "$origFile" >>$TMP/allFiles
	echo "$origFilePath" >>$TMP/allPaths1
	newRev=`getCvsRevision $LOCALROOT/$origFile`
	if [ "$newRev" = "" ]; then
		echo "ERROR: file $origFileName is not under revision control" >&2
		continue
	fi

	cachePut "$LOCALROOT/$origFile" "$newRev"

	if [ "$curRev" = "$newRev" ]; then
		echo "${newRev}${SPACES:0:10-${#newRev}}$origFile"
		continue
	fi
	echo "changed from $curRev to $newRev - gathering info:"

	s=${origFilePath%/*}
	dirPrefix=${origFilePath:${#s}+1}
	dirPrefix=${dirPrefix/libxml/libxml2}

	TARGETFILE=$TMP/$dirPrefix/$origFileName
	mkdir -p $TMP/$dirPrefix

	# copy orig. file
	echo "Copying $origFileName to $TARGETFILE"
	cp $LOCALROOT/$origFile $TARGETFILE

	if $haveH2Pas; then
		pasFile=$TMP/$dirPrefix/${origFileName%.h}.pas
		toPascal "$TARGETFILE" "$pasFile" "$dirPrefix"
	fi

	# find the CVSROOT for this file - it is stored with the CVS local copy
	CVSROOT="`cat $LOCALROOT/$origFilePath/CVS/Root`"

	oldHfile="$TMP/$dirPrefix/${origFileName%.h}-${curRev}.h"
#	if [ ! -s "$oldHfile" ]; then
	if false; then
		echo "Retrieving file ${origFileName%.h}-${curRev}.h" >&2
		pushd $LOCALROOT >/dev/null
		cmd="cvs -z4 -d$CVSROOT up -r $curRev $origFilePath/$origFileName"
		echo "$cmd"
		$cmd
		cmd="cp $origFilePath/$origFileName $oldHfile"
		echo "$cmd"
		$cmd
		cmd="cvs -z4 -d$CVSROOT up -r $newRev $origFilePath/$origFileName"
		echo "$cmd"
		$cmd
		popd >/dev/null
	fi
	if cacheGet "$LOCALROOT/$origFile" "$curRev" "$oldHfile"; then
		diff -u4 $oldHfile $LOCALROOT/$origFile >$TARGETFILE.$curRev-$newRev.diff
	else
		cmd="cvs -z4 -d$CVSROOT diff -u4 -r $curRev -r $newRev $origFile"
		echo "$cmd"
		pushd $LOCALROOT >/dev/null
		$cmd >$TARGETFILE.$curRev-$newRev.diff
		popd >/dev/null
	fi
	if $haveH2Pas && [ -s "$oldHfile" ]; then
		oldPasFile=${oldHfile%.h}.pas
		toPascal "$oldHfile" "$oldPasFile" "$dirPrefix"
		diff -u4 $oldPasFile $pasFile >$TMP/$dirPrefix/${origFileName%.h}.pas.$curRev-$newRev.diff
		rm -f $oldPasFile
	fi
	rm -f $oldHfile

	# get diff
#	cmd="cvs -z4 -d$CVSROOT rdiff -u -r $REV -r $newRev $origFile"
#	echo "Extracting diff file ($TARGETFILE.diff):"
#	echo "$cmd"
#	$cmd >$TARGETFILE.diff


	# get log entries
	cmd="cvs -z4 -d$CVSROOT log -N -r$curRev:$newRev $origFile"
#	echo "Extracting log file ($TARGETFILE.log):"
	pushd $LOCALROOT >/dev/null
	echo "$cmd"
	$cmd >$TARGETFILE.log
	popd >/dev/null
	CHGCOUNT=$((CHGCOUNT + 1))
done

# prepare list of files that do not use CVS SIGN and should not be reported as unconverted
cat >$TMP/ignoredFiles <<EOF
gnome-xml/include/libxml/xmlversion.h
libxslt/libexslt/exsltconfig.h
libxslt/libexslt/libexslt.h
libxslt/libxslt/libxslt.h
libxslt/libxslt/win32config.h
libxslt/libxslt/xsltconfig.h
EOF

# find unconverted header files
echo "Checking for other header files in used directories..."
sort -u $TMP/allPaths1 >$TMP/allPaths
rm $TMP/allPaths1
for dir in `cat $TMP/allPaths`; do
	echo "  $dir:"
	for fn in $LOCALROOT/$dir/*.h; do
		if [ ! -e "$fn" ]; then
			echo "No header files."
			break
		fi
		sfn=${fn:${#LOCALROOT}+1}
		
		# ignore used files
		if grep -q '^'$sfn'$' $TMP/allFiles; then
			continue
		fi
		
		# ignore files explicitly listed for ignoring
		if grep -q '^'$sfn'$' $TMP/ignoredFiles; then
			continue
		fi
		
		# report any other files
		echo "CONVERTING $sfn"

		origFilePath="${sfn%/*}"
		origFileName="${sfn:${#origFilePath}+1}"

		s=${origFilePath%/*}
		dirPrefix=${origFilePath:${#s}+1}
		dirPrefix=${dirPrefix/libxml/libxml2}

		newFn=$TMP/$dirPrefix/${dirPrefix}_${origFileName%.h}.inc
		h2pasFn=${newFn%.inc}.h2pas
		HFILE=$TMP/$dirPrefix/${dirPrefix}_${origFileName}
		mkdir -p ${HFILE%/*}
		echo "  copying $origFileName to $HFILE"
		cp $fn $HFILE

		toPascal $HFILE $h2pasFn "$dirPrefix"

		cat >$newFn <<EOF
// CVS-REV:$sfn:`getCvsRevision $fn`:
{
  ------------------------------------------------------------------------------
  Translated into pascal with help of h2pas utility from the FreePascal project.
  Petr Kozelka <pkozelka@email.cz>
  ------------------------------------------------------------------------------
}

//////////// h2pas translation:
EOF

		if [ -s $h2pasFn ]; then
			cat $h2pasFn >>$newFn
			rm -f $h2pasFn
		else
			echo "//   Sorry - h2pas is not available" >>$newFn
			echo "//   Use original C code instead:" >>$newFn
			cat $fn >>$newFn
		fi

		CHGCOUNT=$((CHGCOUNT + 1))
	done
done

if [ $CHGCOUNT -gt 0 ]; then
	echo "Compressing results into $RESULTFILE..."
	cd $TMP
	zip -rD ../$RESULTFILE *
	mv ../$RESULTFILE $THISPATH
	cd $THISPATH
fi
#rm -rf $TMP

echo "----------------------------"
echo "Total: $CHGCOUNT files changed"
