#!/bin/sh

CVSBASE=:pserver:anonymous@anoncvs.gnome.org:/cvs/gnome
CVSREPOS=gnome-xml/include/libxml
RELEASE_REV="HEAD"

MYDIR=REV-$RELEASE_REV.tmp
rm -rf $MYDIR

cvs -d $CVSBASE co -r $RELEASE_REV -d $MYDIR gnome-xml/include/libxml

for fn in *.inc; do
	echo $fn
	origfn=$fn

	LINE=`head -1 $origfn`
	REV=`echo $LINE | sed 's/[^[]*\[\([^]]*\).*/\1/'`
	FILENAME=`echo $LINE | sed 's/[^]]*\][[:space:]]*\(.*\)[:space:]*$/\1/'`

	ENTRY=`grep "/$FILENAME/" $MYDIR/CVS/Entries`
	NEWREV=`echo $ENTRY | sed 's/\/\([^\/]*\)\/\([^\/]*\).*/\2/'`
	CHGDATE=`echo $ENTRY | sed 's/\/\([^\/]*\)\/\([^\/]*\)\/\([^\/]*\).*/\3/'`

	if [ X$REV != X$NEWREV ] ; then
		echo "    $FILENAME revision changed from $REV to $NEWREV"
		echo "         (modification date: $CHGDATE)"
		cmd="cvs -d$CVSBASE rdiff -r $REV -r $RELEASE_REV $CVSREPOS/$FILENAME"
		echo "    Creating diff file ($MYDIR/$FILENAME.diff) :"
		echo "    $cmd"
		$cmd >$MYDIR/$FILENAME.diff
		cvs -d$CVSBASE log -N -r$REV:$NEWREV $MYDIR/$FILENAME >$MYDIR/$FILENAME.log
	else
		rm $MYDIR/$FILENAME
	fi

#	echo LINE=$LINE
#	echo REV=$REV
#	echo FILENAME=*$FILENAME*
#
#	echo $ENTRY
#	echo NEWREV=$NEWREV
done
rm -rf $MYDIR/CVS
