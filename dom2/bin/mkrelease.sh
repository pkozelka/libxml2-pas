#!/bin/bash

PROJECT=pdom2
DOTTED_VERSION='0.0.1'

function prepareDist()
{
	mkdir $TMP/src $TMP/test
	cp ../common/license/COPYING* $TMP
	cp src/*.pas src/*.res $TMP/src
	cp test/*.pas test/*.dpr test/*.res $TMP/test
}


function makeArchive()
{
	origDir=`pwd`
	cd $TMP
	zip -vr $origDir/$PROJECT-$DOTTED_VERSION.zip *
	cd $origDir
}

TMP=${TMP:-'~/tmp'}/$PROJECT/$$
mkdir -p $TMP

cmd=$1

case "$cmd" in
'dist')
	prepareDist
	makeArchive
	;;
*)
	echo "Invalid command: $cmd" >&2
	exit -1
	;;
esac

rm -rf $TMP
