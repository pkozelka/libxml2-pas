UNIT TESTING for libxmldom.pas

I use this program for testing every aspect of libxmldomFE,
apart from threadsafety.

Before I was using the program "dom2demo.dpr" for testing
the dom. (from the demos/dom2/test folder)

To compile it, you have to include the following paths into your
library search path:

dom2
libxml2
libxslt
utils
utils/dunit

Under Project->Options you have to define the following 
conditionals:

FE
WITHOUT_IDOM_EXPERIMENTAL

Have fun!

feedback to:

Uwe Fechner <ufechner@4commerce.de>


