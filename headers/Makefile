all:
	echo "Compilation currently not supported by Makefile."
dist:
	bash utils/mkrelease.sh dist
upload:
	bash utils/mkrelease.sh upload

bin:
	bash utils/mkrelease.sh bin
	
checkapi:
	bash utils/checkapi.sh $(GNOMECVSROOT) src/*.inc
