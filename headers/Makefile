all:
	echo "Compilation currently not supported by Makefile."
dist:
	utils/mkrelease.sh dist
upload:
	utils/mkrelease.sh upload

bin:
	utils/mkrelease.sh bin
	
checkapi:
	sh utils/checkapi.sh $(GNOMECVSROOT) src/*.inc
