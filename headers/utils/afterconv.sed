s/\([[:alnum:]]*\)[[:space:]]*:[[:space:]]*\([[:alnum:]]\)/\1: \2/
s/longint/Longint/gi
s/\(\* Const before type ignored \*\)//g
s/{ C++ end of extern C conditionnal removed }//g
s/[[:space:]]*Const/const/gi
s/[[:space:]]*pointer/ Pointer/gi
s/[[:space:]]pvoid/ Pointer/gi
s/ to:/ aTo:/g
s/;cdecl;/; cdecl;/gi
s/;external/; external/gi
s/external;/external LIBXML2_SO;/gi
s/\^xmlChar/PxmlChar/g
s/ file:/ aFile:/gi
s/:\([[:alnum:]]\)/: \1/g
s/ _type:/ aType:/g
s/ PFILE/ PLibXml2File/g
s/var [[:space:]]*\([[:alnum:]]*\):[[:space:]]*TextFile/\1: PLibXml2File/g
s/{\$ifdef /{\$IFDEF /gi
s/{\$else/{\$ELSE/gi
s/{\$endif/{\$ENDIF/gi
s/{\$if /{\$IF /gi
s/{\$ifend/{\$IFEND/gi
s:/\*:(\*:g
s:\*/:\*):g
s/[[:space:]]*$//
