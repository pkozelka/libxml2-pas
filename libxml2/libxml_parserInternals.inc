{$PACKRECORDS C}

{
   parserInternals.h : internals routines exported by the parser.
  
   See Copyright for the status of this software.
  
   daniel@veillard.com
  
   14 Nov 2000 ht - truncated declaration of xmlParseElementChildrenContentDecl 
   for VMS
  
  }
{$ifndef __XML_PARSER_INTERNALS_H__}
{$define __XML_PARSER_INTERNALS_H__}
{$include <libxml/parser.h>}
{$include <libxml/HTMLparser.h>}
{ C++ extern C conditionnal removed }
{ 
    XML_MAX_NAMELEN:
   
    Identifiers can be longer, but this will be more costly
    at runtime.
   }

const
   XML_MAX_NAMELEN = 100;
{ 
   INPUT_CHUNK:
  
   The parser tries to always have that amount of input ready
   one of the point is providing context when reporting errors
  }
   INPUT_CHUNK = 250;
{                                                                       
  									 
   UNICODE version of the macros.      					 
  									 
                                                                         }
{ 
   IS_CHAR:
   @c:  an UNICODE value (int)
  
   Macro to check the following production in the XML spec
  
   [2] Char ::= #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD]
                    | [#x10000-#x10FFFF]
   any Unicode character, excluding the surrogate blocks, FFFE, and FFFF.
  }
(* error 
#define IS_CHAR(c)							\
in define line 54 *)
(* error 
    ((((c) >= 0x20) && ((c) <= 0xD7FF)) ||				\
    { 
       IS_BLANK:
       @c:  an UNICODE value (int)
      
       Macro to check the following production in the XML spec
      
       [3] S ::= (#x20 | #x9 | #xD | #xA)+
      }
in define line 68 *)
(* error 
                     ((c) == 0x0D))
    { 
       IS_BASECHAR:
       @c:  an UNICODE value (int)
      
       Macro to check the following production in the XML spec
      
       [85] BaseChar ::= ... long list see REC ...
      }
in define line 79 *)
    { 
       IS_DIGIT:
       @c:  an UNICODE value (int)
      
       Macro to check the following production in the XML spec
      
       [88] Digit ::= ... long list see REC ...
      }
    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }   
    function IS_DIGIT(c : longint) : longint;

    { 
       IS_COMBINING:
       @c:  an UNICODE value (int)
      
       Macro to check the following production in the XML spec
      
       [87] CombiningChar ::= ... long list see REC ...
      }
    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }   
    function IS_COMBINING(c : longint) : longint;

    { 
       IS_EXTENDER:
       @c:  an UNICODE value (int)
      
       Macro to check the following production in the XML spec
      
      
       [89] Extender ::= #x00B7 | #x02D0 | #x02D1 | #x0387 | #x0640 |
                         #x0E46 | #x0EC6 | #x3005 | [#x3031-#x3035] |
                         [#x309D-#x309E] | [#x30FC-#x30FE]
      }
    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }   
    function IS_EXTENDER(c : longint) : longint;

    { 
       IS_IDEOGRAPHIC:
       @c:  an UNICODE value (int)
      
       Macro to check the following production in the XML spec
      
      
       [86] Ideographic ::= [#x4E00-#x9FA5] | #x3007 | [#x3021-#x3029]
      }
    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }   
    function IS_IDEOGRAPHIC(c : longint) : longint;

    { 
       IS_LETTER:
       @c:  an UNICODE value (int)
      
       Macro to check the following production in the XML spec
      
      
       [84] Letter ::= BaseChar | Ideographic 
      }
(* error 
#define IS_LETTER(c) (IS_BASECHAR(c) || IS_IDEOGRAPHIC(c))
in define line 134 *)
    { 
       IS_PUBIDCHAR:
       @c:  an UNICODE value (int)
      
       Macro to check the following production in the XML spec
      
      
       [13] PubidChar ::= #x20 | #xD | #xA | [a-zA-Z0-9] | [-'()+,./:=?;! #@$_%]
      }
    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }   
    function IS_PUBIDCHAR(c : longint) : longint;

    { 
       SKIP_EOL:
       @p:  and UTF8 string pointer
      
       Skips the end of line chars
      }
(* error 
#define SKIP_EOL(p) 							\
in define line 154 *)
(* error 
    if (*(p) == 0x13) { p++ ; if (*(p) == 0x10) p++; }			\
 in declarator_list *)
(* error 
    if (*(p) == 0x13) { p++ ; if (*(p) == 0x10) p++; }			\
 in declarator_list *)
(* error 
    if (*(p) == 0x13) { p++ ; if (*(p) == 0x10) p++; }			\
in declaration at line 156 *)
(* error 
    if (*(p) == 0x10) { p++ ; if (*(p) == 0x13) p++; }
 in declarator_list *)
(* error 
    if (*(p) == 0x10) { p++ ; if (*(p) == 0x13) p++; }
    { 
       MOVETO_ENDTAG:
       @p:  and UTF8 string pointer
      
       Skips to the next '>' char
      }
in define line 164 *)
(* error 
    while ((*p) && (*(p) != '>')) (p)++
    { 
       MOVETO_STARTTAG:
       @p:  and UTF8 string pointer
      
       Skips to the next '<' char
      }
    { 
       Global variables used for predefined strings
      }
 in declarator_list *)
      var
 : while;
(* error 
LIBXML_DLL_IMPORT extern const xmlChar xmlStringTextNoenc[];
in declaration at line 180 *)
(* error 
LIBXML_DLL_IMPORT extern const xmlChar xmlStringComment[];
in declaration at line 181 *)
    {
       Function to finish the work of the macros where needed
      }

function xmlIsBaseChar(c:longint):longint;cdecl;external;
function xmlIsBlank(c:longint):longint;cdecl;external;
function xmlIsPubidChar(c:longint):longint;cdecl;external;
function xmlIsLetter(c:longint):longint;cdecl;external;
function xmlIsDigit(c:longint):longint;cdecl;external;
function xmlIsIdeographic(c:longint):longint;cdecl;external;
function xmlIsCombining(c:longint):longint;cdecl;external;
function xmlIsExtender(c:longint):longint;cdecl;external;
function xmlIsCombining(c:longint):longint;cdecl;external;
function xmlIsChar(c:longint):longint;cdecl;external;
    { 
       Parser context
      }
(* Const before type ignored *)
function xmlCreateFileParserCtxt(filename:Pchar):xmlParserCtxtPtr;cdecl;external;
(* Const before type ignored *)
function xmlCreateMemoryParserCtxt(buffer:Pchar; size:longint):xmlParserCtxtPtr;cdecl;external;
function xmlNewParserCtxt:xmlParserCtxtPtr;cdecl;external;
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
function xmlCreateEntityParserCtxt(URL:PxmlChar; ID:PxmlChar; base:PxmlChar):xmlParserCtxtPtr;cdecl;external;
function xmlSwitchEncoding(ctxt:xmlParserCtxtPtr; enc:xmlCharEncoding):longint;cdecl;external;
function xmlSwitchToEncoding(ctxt:xmlParserCtxtPtr; handler:xmlCharEncodingHandlerPtr):longint;cdecl;external;
procedure xmlFreeParserCtxt(ctxt:xmlParserCtxtPtr);cdecl;external;
    { 
       Entities
      }
procedure xmlHandleEntity(ctxt:xmlParserCtxtPtr; entity:xmlEntityPtr);cdecl;external;
    { 
       Input Streams
      }
(* Const before type ignored *)
function xmlNewStringInputStream(ctxt:xmlParserCtxtPtr; buffer:PxmlChar):xmlParserInputPtr;cdecl;external;
function xmlNewEntityInputStream(ctxt:xmlParserCtxtPtr; entity:xmlEntityPtr):xmlParserInputPtr;cdecl;external;
procedure xmlPushInput(ctxt:xmlParserCtxtPtr; input:xmlParserInputPtr);cdecl;external;
function xmlPopInput(ctxt:xmlParserCtxtPtr):xmlChar;cdecl;external;
procedure xmlFreeInputStream(input:xmlParserInputPtr);cdecl;external;
(* Const before type ignored *)
function xmlNewInputFromFile(ctxt:xmlParserCtxtPtr; filename:Pchar):xmlParserInputPtr;cdecl;external;
function xmlNewInputStream(ctxt:xmlParserCtxtPtr):xmlParserInputPtr;cdecl;external;
    { 
       Namespaces.
      }
(* Const before type ignored *)
function xmlSplitQName(ctxt:xmlParserCtxtPtr; name:PxmlChar; prefix:PPxmlChar):^xmlChar;cdecl;external;
function xmlNamespaceParseNCName(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
function xmlNamespaceParseQName(ctxt:xmlParserCtxtPtr; prefix:PPxmlChar):^xmlChar;cdecl;external;
function xmlNamespaceParseNSDef(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
function xmlParseQuotedString(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
procedure xmlParseNamespace(ctxt:xmlParserCtxtPtr);cdecl;external;
    { 
       Generic production rules
      }
function xmlScanName(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
function xmlParseName(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
function xmlParseNmtoken(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
function xmlParseEntityValue(ctxt:xmlParserCtxtPtr; orig:PPxmlChar):^xmlChar;cdecl;external;
function xmlParseAttValue(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
function xmlParseSystemLiteral(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
function xmlParsePubidLiteral(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
procedure xmlParseCharData(ctxt:xmlParserCtxtPtr; cdata:longint);cdecl;external;
function xmlParseExternalID(ctxt:xmlParserCtxtPtr; publicID:PPxmlChar; strict:longint):^xmlChar;cdecl;external;
procedure xmlParseComment(ctxt:xmlParserCtxtPtr);cdecl;external;
function xmlParsePITarget(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
procedure xmlParsePI(ctxt:xmlParserCtxtPtr);cdecl;external;
procedure xmlParseNotationDecl(ctxt:xmlParserCtxtPtr);cdecl;external;
procedure xmlParseEntityDecl(ctxt:xmlParserCtxtPtr);cdecl;external;
function xmlParseDefaultDecl(ctxt:xmlParserCtxtPtr; value:PPxmlChar):longint;cdecl;external;
function xmlParseNotationType(ctxt:xmlParserCtxtPtr):xmlEnumerationPtr;cdecl;external;
function xmlParseEnumerationType(ctxt:xmlParserCtxtPtr):xmlEnumerationPtr;cdecl;external;
function xmlParseEnumeratedType(ctxt:xmlParserCtxtPtr; tree:PxmlEnumerationPtr):longint;cdecl;external;
function xmlParseAttributeType(ctxt:xmlParserCtxtPtr; tree:PxmlEnumerationPtr):longint;cdecl;external;
procedure xmlParseAttributeListDecl(ctxt:xmlParserCtxtPtr);cdecl;external;
function xmlParseElementMixedContentDecl(ctxt:xmlParserCtxtPtr):xmlElementContentPtr;cdecl;external;
{$ifdef VMS}

function xmlParseElementChildrenContentD(ctxt:xmlParserCtxtPtr):xmlElementContentPtr;cdecl;external;

    const
       xmlParseElementChildrenContentDecl = xmlParseElementChildrenContentD;
{$else}

function xmlParseElementChildrenContentDecl(ctxt:xmlParserCtxtPtr):xmlElementContentPtr;cdecl;external;
{$endif}

function xmlParseElementContentDecl(ctxt:xmlParserCtxtPtr; name:PxmlChar; result:PxmlElementContentPtr):longint;cdecl;external;
function xmlParseElementDecl(ctxt:xmlParserCtxtPtr):longint;cdecl;external;
procedure xmlParseMarkupDecl(ctxt:xmlParserCtxtPtr);cdecl;external;
function xmlParseCharRef(ctxt:xmlParserCtxtPtr):longint;cdecl;external;
function xmlParseEntityRef(ctxt:xmlParserCtxtPtr):xmlEntityPtr;cdecl;external;
procedure xmlParseReference(ctxt:xmlParserCtxtPtr);cdecl;external;
procedure xmlParsePEReference(ctxt:xmlParserCtxtPtr);cdecl;external;
procedure xmlParseDocTypeDecl(ctxt:xmlParserCtxtPtr);cdecl;external;
function xmlParseAttribute(ctxt:xmlParserCtxtPtr; value:PPxmlChar):^xmlChar;cdecl;external;
function xmlParseStartTag(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
procedure xmlParseEndTag(ctxt:xmlParserCtxtPtr);cdecl;external;
procedure xmlParseCDSect(ctxt:xmlParserCtxtPtr);cdecl;external;
procedure xmlParseContent(ctxt:xmlParserCtxtPtr);cdecl;external;
procedure xmlParseElement(ctxt:xmlParserCtxtPtr);cdecl;external;
function xmlParseVersionNum(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
function xmlParseVersionInfo(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
function xmlParseEncName(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
function xmlParseEncodingDecl(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
function xmlParseSDDecl(ctxt:xmlParserCtxtPtr):longint;cdecl;external;
procedure xmlParseXMLDecl(ctxt:xmlParserCtxtPtr);cdecl;external;
procedure xmlParseTextDecl(ctxt:xmlParserCtxtPtr);cdecl;external;
procedure xmlParseMisc(ctxt:xmlParserCtxtPtr);cdecl;external;
(* Const before type ignored *)
(* Const before type ignored *)
procedure xmlParseExternalSubset(ctxt:xmlParserCtxtPtr; ExternalID:PxmlChar; SystemID:PxmlChar);cdecl;external;
    { 
       XML_SUBSTITUTE_NONE:
      
       If no entities need to be substituted
      }

    const
       XML_SUBSTITUTE_NONE = 0;
    { 
       XML_SUBSTITUTE_REF:
      
       Whether general entities need to be substituted
      }
       XML_SUBSTITUTE_REF = 1;
    { 
       XML_SUBSTITUTE_PEREF:
      
       Whether parameter entities need to be substituted
      }
       XML_SUBSTITUTE_PEREF = 2;
    { 
       XML_SUBSTITUTE_BOTH:
      
       Both general and parameter entities need to be substituted
      }
       XML_SUBSTITUTE_BOTH = 3;

function xmlDecodeEntities(ctxt:xmlParserCtxtPtr; len:longint; what:longint; end:xmlChar; end2:xmlChar; 
               end3:xmlChar):^xmlChar;cdecl;external;
(* Const before type ignored *)
function xmlStringDecodeEntities(ctxt:xmlParserCtxtPtr; str:PxmlChar; what:longint; end:xmlChar; end2:xmlChar; 
               end3:xmlChar):^xmlChar;cdecl;external;
    {
       Generated by MACROS on top of parser.c c.f. PUSH_AND_POP
      }
function nodePush(ctxt:xmlParserCtxtPtr; value:xmlNodePtr):longint;cdecl;external;
function nodePop(ctxt:xmlParserCtxtPtr):xmlNodePtr;cdecl;external;
function inputPush(ctxt:xmlParserCtxtPtr; value:xmlParserInputPtr):longint;cdecl;external;
function inputPop(ctxt:xmlParserCtxtPtr):xmlParserInputPtr;cdecl;external;
function namePop(ctxt:xmlParserCtxtPtr):^xmlChar;cdecl;external;
function namePush(ctxt:xmlParserCtxtPtr; value:PxmlChar):longint;cdecl;external;
    {
       other commodities shared between parser.c and parserInternals
      }
function xmlSkipBlankChars(ctxt:xmlParserCtxtPtr):longint;cdecl;external;
(* Const before type ignored *)
function xmlStringCurrentChar(ctxt:xmlParserCtxtPtr; cur:PxmlChar; len:Plongint):longint;cdecl;external;
procedure xmlParserHandlePEReference(ctxt:xmlParserCtxtPtr);cdecl;external;
procedure xmlParserHandleReference(ctxt:xmlParserCtxtPtr);cdecl;external;
(* Const before type ignored *)
function xmlCheckLanguageID(lang:PxmlChar):longint;cdecl;external;
    {
       Really core function shared with HTML parser
      }
function xmlCurrentChar(ctxt:xmlParserCtxtPtr; len:Plongint):longint;cdecl;external;
function xmlCopyCharMultiByte(out:PxmlChar; val:longint):longint;cdecl;external;
function xmlCopyChar(len:longint; out:PxmlChar; val:longint):longint;cdecl;external;
procedure xmlNextChar(ctxt:xmlParserCtxtPtr);cdecl;external;
procedure xmlParserInputShrink(in:xmlParserInputPtr);cdecl;external;
{$ifdef LIBXML_HTML_ENABLED}
    {
       Actually comes from the HTML parser but launched from the init stuff
      }

procedure htmlInitAutoClose;cdecl;external;
(* Const before type ignored *)
(* Const before type ignored *)
function htmlCreateFileParserCtxt(filename:Pchar; encoding:Pchar):htmlParserCtxtPtr;cdecl;external;
{$endif}
{ C++ end of extern C conditionnal removed }
{$endif}
    { __XML_PARSER_INTERNALS_H__  }
    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }   
    function IS_DIGIT(c : longint) : longint;
    begin
       IS_DIGIT:=xmlIsDigit(c);
    end;

    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }   
    function IS_COMBINING(c : longint) : longint;
    begin
       IS_COMBINING:=xmlIsCombining(c);
    end;

    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }   
    function IS_EXTENDER(c : longint) : longint;
    begin
       IS_EXTENDER:=xmlIsExtender(c);
    end;

    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }   
    function IS_IDEOGRAPHIC(c : longint) : longint;
    begin
       IS_IDEOGRAPHIC:=xmlIsIdeographic(c);
    end;

    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }   
    function IS_PUBIDCHAR(c : longint) : longint;
    begin
       IS_PUBIDCHAR:=xmlIsPubidChar(c);
    end;


