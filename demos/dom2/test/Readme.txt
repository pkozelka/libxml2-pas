This is the updated source of the demo, until now
distributed as dom2_demo.zip.

To compile, you also need the files from the folders:
dom2
libxml2

And to run, you need the examples from:
demos/data

So far tested with Delphi 6 only.

It's a graphical program that performs the follwing
test:
a) Test 98 of 100 DOM2 functions
b) a simple tree walker
c) Benchmark the speed of treewalking and parsing

You can switch between msxml-dom and libxml2 at runtime.

Hints for compiling:
- add the dom2 and the libxml2 folders to your library path
- you have to edit the following lines in dom2demo.dpr with
  a texteditor, to match your installation path:
  > libxmldom in 'L:\dom2\libxmldom.pas',
  > Dom2 in 'L:\dom2\Dom2.pas',
  > msxml_impl in 'L:\dom2\msxml_impl.pas';

Uwe Fechner (ufechner@csi.com)

