#!/bin/sh

#
# Usage:
# checkapi.sh <LOCAL_ROOT> [<files>]
#

# TODO:
#   - check that LIBXML2_PAS variable is correctly set
#
#

TRANSLATED_FILES="`find libxml2 libxslt -name '*.inc'`"
LOCALROOT=/home/pk/cvs/gnome.org
TMP=CHECKAPI.TMP

rm -rf $TMP
for fn in $TRANSLATED_FILES ; do
	echo -n "$fn:  "
	LINE=`head $fn | grep CVS-REV`
	if [ "x$LINE" = "x" ]; then
		echo
		echo "  ERROR: no CVS-REV in $fn"
		continue
	fi
	ORIGFILE=`echo $LINE | cut -d: -f2`
	ORIGFILENAME=`basename $ORIGFILE`
	ORIGFILEPATH=`dirname $ORIGFILE`
	REV=`echo $LINE | cut -d: -f3`
	CVSENTRY=`grep "^/$ORIGFILENAME/" $LOCALROOT/$ORIGFILEPATH/CVS/Entries`
	if [ "x$CVSENTRY" = "x" ]; then
		echo
		echo "  ERROR: file $ORIGFILENAME not found in $LOCALROOT/$ORIGFILEPATH/CVS/Entries"
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
	echo "    copying $ORIGFILENAME to $TARGETFILE"
	cp $LOCALROOT/$ORIGFILE $TARGETFILE

	# translate it into pascal and apply known conversions
	if [ -x "h2pas" ]; then

		# translate
		h2pas -d -e -c -i $TARGETFILE -o $TARGETFILE.1.pas

		# apply known replacements
		sed -f $LIBXML2_PAS/utils/afterconv.sed $TARGETFILE.1.pas >$TARGETFILE.2.pas

		# compare original translation and the one with replacements
		diff $TARGETFILE.h2pas.pas $TARGETFILE.sed.pas >$TARGETFILE.pas.diff12
	fi

	# find the CVSROOT for this file - it is stored with the CVS local copy
	CVSROOT="`cat $LOCALROOT/$ORIGFILEPATH/CVS/Root`"

	# get diff
	cmd="cvs -z4 -d$CVSROOT rdiff -r $REV -r $NEWREV $ORIGFILE"
	echo "    Extracting diff file ($TARGETFILE.diff):"
	echo "    $cmd"
	$cmd >$TARGETFILE.diff

	# get log entries
	origpwd=`pwd`
	cd $LOCALROOT
	cmd="cvs -z4 -d$CVSROOT log -N -r$REV:$NEWREV $ORIGFILE"
	echo "    Extracting log file ($TARGETFILE.log):"
	echo "    $cmd"
	$cmd >$origpwd/$TARGETFILE.log
	cd $origpwd
done
