HEADERS_DIR=$1
SRC=$HEADERS_DIR/src
DIST=$HEADERS_DIR/dist

# initialize the distribution directory
rm -rf $DIST
mkdir $DIST

# copy files to be released there
mkdir $DIST/src
cp $SRC/*.inc $SRC/*.pas $DIST/src
cp $SRC/*.txt $DIST
cp $HEADERS_DIR/../common/license/COPYNIG* $DIST

