#!/bin/bash
#
#
#

function PasCompile()
{
	local aProjectFile=`cygpath -w "$1"`
	local aUnitDirs=`cygpath -w -p "$2"`

	$DCC -DTEXTTESTRUNNER -B -Q -U$aUnitDirs $aProjectFile
}

myUnitPath=$LIBXML2_PAS/headers/src
myUnitPath=$myUnitPath:$LIBXML2_PAS/dom2/src
myUnitPath=$myUnitPath:$LIBXML2_PAS/dom2/src/test
myUnitPath=$myUnitPath:$LIBXML2_PAS/dom2/src/test/tests
myUnitPath=$myUnitPath:$LIBXML2_PAS/../dunit/dunit/src

# D5
DELPHI_HOME=`cygpath -u 'F:\sw\Borland\Delphi50'`
DCC=$DELPHI_HOME/Bin/dcc32.exe

PasCompile DomTestSuite.dpr $myUnitPath

# D6
DELPHI_HOME=`cygpath -u 'F:\sw\Borland\Delphi6'`
DCC=$DELPHI_HOME/Bin/dcc32.exe

PasCompile DomTestSuite.dpr $myUnitPath

