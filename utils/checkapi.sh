#!/bin/sh

#
# Usage:
# checkapi.sh <localroot> [<files>]
#

# TODO:
#   - check that LIBXML2_PAS variable is correctly set
#   - check that <localroot> is a valid CVS working copy
#   - cache files in localroot for later use in diff

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

	# translate it into pascal and apply known conversions
	if [ "x$H2PAS" != "x" ] ; then
		echo "---------------- [$fn] -----------------" >>$TMP/h2pas.log
		# translate
		echo "Translating $TARGETFILE to $TARGETFILE.1.pas"
		h2pas -d -c -i $TARGETFILE -o $TARGETFILE.1.pas 1>&2 >>$TMP/h2pas.log

		# apply known replacements
		echo "Applying additional conversions --> $TARGETFILE.2.pas"
		sed -f "$LIBXML2_PAS/utils/afterconv.sed" $TARGETFILE.1.pas > $TARGETFILE.2.pas

		# compare original translation and the one with replacements
		diff $TARGETFILE.1.pas $TARGETFILE.2.pas >$TARGETFILE.pas.diff12
	fi

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
	CHGCOUNT=`expr $CHGCOUNT + 1`
done

if [ $CHGCOUNT -gt 0 ]; then
	echo "Compressing results into $RESULTFILE..."
	cd $TMP
	zip -rD ../$RESULTFILE *
	cd $THISPATH
fi
rm -rf $TMP

echo "----------------------------"
echo "Total: $CHGCOUNT files changed"
