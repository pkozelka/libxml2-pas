all:
	echo "Compilation currently not supported by Makefile."
dist:
	./mkrelease dist
upload:
	./mkrelease upload

checkapi:
	sh utils/checkapi.sh $(GNOMECVSROOT) src/*.inc
