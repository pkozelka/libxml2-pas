PROJECT=Demo1
DCC=dcc
EXECUTABLE=$(PROJECT)
DCCOPTS=-Q -U../../../libxml2

all: test

../../../libxml2.dcu: ../../../libxml2/*.pas ../../../libxml2/*.inc
	$(DCC) $(DCCOPTS) ../../../libxml2/libxml2.pas

./$(EXECUTABLE): $(PROJECT).dpr ../../../libxml2.dcu
	$(DCC) $(DCCOPTS) $(PROJECT).dpr
clean:
	rm -f *.dcu

test: ./$(EXECUTABLE)
	./$(EXECUTABLE) calServer.xml
