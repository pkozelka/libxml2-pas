#!/bin/bash

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
	if [ "x$H2PAS" != "x" ] ; then
		echo "---------------- [$aFileName] -----------------" >>$TMP/h2pas.log
		# translate
		echo "  translating $aFileName to $aFileName.1.pas"
		h2pas -d -c -i $aFileName -o $aFileName.1.pas 1>&2 >>$TMP/h2pas.log

		# apply known replacements
		echo "  applying additional conversions --> $aFileName.2.pas"
		sed -f "$LIBXML2_PAS/headers/utils/afterconv.sed" $aFileName.1.pas > $aFileName.2.pas

		# compare original translation and the one with replacements
		diff $aFileName.1.pas $aFileName.2.pas >$aFileName.pas.diff12
	fi
}

LOCALROOT=$1
shift 1
FILELIST="$*"
TMP=CHECKAPI.TMP
RESULTFILE=checkapi-results.zip

CHGCOUNT=0
H2PAS=`which h2pas`
if [ "x$H2PAS" = "x" ] ; then
	echo "h2pas not found, Pascal conversion will not take place"
fi


rm -rf $TMP $RESULTFILE
mkdir $TMP

THISPATH=`pwd`
for fn in $FILELIST ; do
	cd $THISPATH
	echo -n "  checking: $fn:  "
	LINE=`head $fn | grep CVS-REV`
	if [ "x$LINE" = "x" ]; then
		echo
		echo "ERROR: no CVS-REV in $fn"
		continue
	fi
	ORIGFILE=`echo $LINE | cut -d: -f2`
	ORIGFILENAME=`basename $ORIGFILE`
	ORIGFILEPATH=`dirname $ORIGFILE`
	REV=`echo $LINE | cut -d: -f3`
	CVSENTRY=`grep "^/$ORIGFILENAME/" $LOCALROOT/$ORIGFILEPATH/CVS/Entries`

	echo "$ORIGFILEPATH/$ORIGFILENAME" >>$TMP/allFiles
	echo "$ORIGFILEPATH" >>$TMP/allPaths1

	if [ "x$CVSENTRY" = "x" ]; then
		echo
		echo "ERROR: file $ORIGFILENAME not found in $LOCALROOT/$ORIGFILEPATH/CVS/Entries"
		continue
	fi
	NEWREV=`echo $CVSENTRY | cut -d/ -f3`
	if [ "x$REV" = "x$NEWREV" ]; then
		echo "ok"
		continue
	fi
	echo "changed from $REV to $NEWREV - gathering info:"

# --- Choose the version that fits you: ---

# this version stores the info into complete dir hierarchy, which is cleaner but a bit uncomfortable
#	TARGETFILE=$TMP/$ORIGFILE

# this version is more comfortable - it creates more flat directory structure
	TARGETFILE=$TMP/`basename $ORIGFILEPATH`/$ORIGFILENAME
# ---  ---
	mkdir -p `dirname $TARGETFILE`

	# copy orig. file
	echo "Copying $ORIGFILENAME to $TARGETFILE"
	cp $LOCALROOT/$ORIGFILE $TARGETFILE

	toPascal $TARGETFILE

	# find the CVSROOT for this file - it is stored with the CVS local copy
	CVSROOT="`cat $LOCALROOT/$ORIGFILEPATH/CVS/Root`"

	# get diff
	cmd="cvs -z4 -d$CVSROOT rdiff -r $REV -r $NEWREV $ORIGFILE"
	echo "Extracting diff file ($TARGETFILE.diff):"
	echo "$cmd"
	$cmd >$TARGETFILE.diff

	# get log entries
	cmd="cvs -z4 -d$CVSROOT log -N -r$REV:$NEWREV $ORIGFILE"
	echo "Extracting log file ($TARGETFILE.log):"
	echo "$cmd"
	cd $LOCALROOT
	$cmd >$THISPATH/$TARGETFILE.log
	cd $THISPATH
	CHGCOUNT=$((CHGCOUNT + 1))
done

# prepare list of files that do not use CVS SIGN and should not be reported as unconverted
cat >$TMP/ignoredFiles <<EOF
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

		ORIGFILENAME=NEWLIB_`basename $sfn`
		ORIGFILEPATH=`dirname $sfn`
		TARGETFILE=$TMP/`basename $ORIGFILEPATH`/$ORIGFILENAME
		mkdir -p `dirname $TARGETFILE`

		echo "  copying $ORIGFILENAME to $TARGETFILE"
		cp $fn $TARGETFILE
		toPascal $TARGETFILE

		CHGCOUNT=$((CHGCOUNT + 1))
	done
done

if [ $CHGCOUNT -gt 0 ]; then
	echo "Compressing results into $RESULTFILE..."
	cd $TMP
	zip -rD ../$RESULTFILE *
	cd $THISPATH
fi
#rm -rf $TMP

echo "----------------------------"
echo "Total: $CHGCOUNT files changed"
