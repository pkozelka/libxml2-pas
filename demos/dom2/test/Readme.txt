This is the updated source of the demo, until now
distributed as dom2_demo.zip.

To compile, you also need the files from the folders:
dom2
libxml2

And to run, you need the examples from:
demos/data

Tested with Delphi 5 and with Delphi 6.

It's a graphical program that performs the follwing
test:
a) Test 98 of 100 DOM2 functions
b) a simple tree walker
c) Benchmark the speed of treewalking and parsing

You can switch between msxml-dom and libxml2 at runtime.

Hints for compiling:
- add the dom2 and the libxml2 folders to your library path
- edit the paths in project-options to fit your enviroment

Uwe Fechner (ufechner@csi.com)

