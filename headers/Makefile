all:
	echo "Compilation currently not supported by Makefile."
dist:
	sh utils/mkrelease.sh dist
upload:
	sh utils/mkrelease.sh upload

bin:
	sh utils/mkrelease.sh bin
	
checkapi:
	sh utils/checkapi.sh $(GNOMECVSROOT) src/*.inc
