PROJECT=TestParseFile
DCC=dcc32.exe
EXECUTABLE=$(PROJECT).exe
DCCOPTS=-Q -U../../libxml2

all: test

./$(EXECUTABLE): $(PROJECT).dpr ../../../libxml2/*.pas ../../../libxml2/*.inc
	$(DCC) $(DCCOPTS) $(PROJECT).dpr
clean:
	rm -f *.dcu

test: ./$(EXECUTABLE)
	./$(EXECUTABLE) ../../data/birds.xml
