#!/bin/bash
#
#
#

DELPHI_HOME=`cygpath -u 'F:\sw\Borland\Delphi6'`
DCC=$DELPHI_HOME/Bin/dcc32.exe

function PasCompile()
{
	local aProjectFile=`cygpath -w "$1"`
	local aUnitDirs=`cygpath -w -p "$2"`

	$DCC -DTEXTTESTRUNNER -B -Q -U$aUnitDirs $aProjectFile
}


PasCompile test/DomTestSuite.dpr $LIBXML2_PAS/headers/src:$LIBXML2_PAS/dom2:$LIBXML2_PAS/dom2/test:$LIBXML2_PAS/dom2/test/tests:$LIBXML2_PAS/../dunit/dunit/src

