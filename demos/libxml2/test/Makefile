PROJECT=TestParseFile
DCC=dcc32.exe
EXECUTABLE=$(PROJECT).exe
DCCOPTS=-Q -U../../libxml2

all: test

./$(EXECUTABLE):
	$(DCC) $(DCCOPTS) $(PROJECT).dpr
clean:
	rm -f *.dcu

test: ./$(EXECUTABLE)
	./$(EXECUTABLE) ../../data/birds.xml
