#!/bin/sh
# This program determines if any changes happened to the original api after it's last translation into Pascal.
#
# (C) Petr Kozelka, 2002 - <pkozelka@email.cz>
#
# Creates a temporary directory and stores following info to it:
# - diff between previous and new version (*.diff)
# - log entries between previous and new version (*.log)
# - the new version itself
#
# It heavily relies on a CVS signature present in the Pascal files. It must reside
# in the first line, and have the following syntax:
#
# // CVS-SIGN: [1.10] myfile.h
#
# This record indicates that the pascal translation corresponds to CVS revision 1.10 of myfile.h
#
# PROGRAM ARGUMENTS:
#
# checkApiChanges.sh <aCvsBase> <aCvsRepos> <aReleaseRev> <aFileList>
# where:
#    aCvsBase  is the CVS server to contact (example: ":pserver:anonymous@anoncvs.gnome.org:/cvs/gnome" )
#    aCvsRepos  is directory location of files at the CVS server (example: "gnome-xml/include/libxml" )
#    aReleaseRev  is the 'latest' revision against which we want to check; HEAD means the really latest one
#									 (another example: LIBXML_2_4_12)
#    aFileList is list of files to check - (example: *.inc )
#
# TODO:
# - more efficient operation
# - remove ALL unnecessary files from tmp dir
#

aCvsBase=$1
aCvsRepos=$2
aReleaseRev=$3
shift 3
aFileList=$@

MYDIR=REV-$aReleaseRev.tmp
echo Reading C headers from "$aReleaseRev" revision...
rm -rf $MYDIR
cvs -z4 -d $aCvsBase co -r $aReleaseRev -d $MYDIR gnome-xml/include/libxml

if [ ! -d $MYDIR/CVS ] ; then
	exit
fi
echo Check differences in revision number...
for fn in $aFileList; do
	echo $fn
	origfn=$fn

	LINE=`head -1 $origfn`
	REV=`echo $LINE | sed 's/[^[]*\[\([^]]*\).*/\1/'`
	FILENAME=`echo $LINE | sed 's/[^]]*\][[:space:]]*\(.*\)[:space:]*$/\1/'`

	ENTRY=`grep "/$FILENAME/" $MYDIR/CVS/Entries`
	NEWREV=`echo $ENTRY | sed 's/\/\([^\/]*\)\/\([^\/]*\).*/\2/'`
	CHGDATE=`echo $ENTRY | sed 's/\/\([^\/]*\)\/\([^\/]*\)\/\([^\/]*\).*/\3/'`

	if [ X$NEWREV = X ] ; then
		echo "    NOT FOUND IN CVS ENTRIES"
	else
		if [ X$REV != X$NEWREV ] ; then
			echo "    $FILENAME revision changed from $REV to $NEWREV"
			echo "         (modification date: $CHGDATE)"
			cmd="cvs -z4 -d$aCvsBase rdiff -r $REV -r $aReleaseRev $aCvsRepos/$FILENAME"
			echo "    Extracting diff file ($MYDIR/$FILENAME.diff):"
			echo "    $cmd"
			$cmd >$MYDIR/$FILENAME.diff
			echo "    Extracting log file ($MYDIR/$FILENAME.log)..."
			cvs -z4 -d$aCvsBase log -N -r$REV:$aReleaseRev $MYDIR/$FILENAME >$MYDIR/$FILENAME.log
		else
			rm $MYDIR/$FILENAME
		fi
	fi
done

echo "Removing CVS info from $MYDIR"
rm -rf $MYDIR/CVS
grep -v "$MYDIR" CVS/Entries > CVS/Entries.tmp
mv CVS/Entries.tmp CVS/Entries
