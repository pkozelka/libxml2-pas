all:
	cd test; ./compile.sh

ctest: all
	test/DomTestSuite.exe

zip:
	zip -r dom2-pas-0.0.1.zip src/*.pas src/*.dpr src/*.res test/*.pas test/*.dpr test/*.res
