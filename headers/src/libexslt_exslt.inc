// CVS-REV:libxslt/libexslt/exslt.h:1.11:
{
  ------------------------------------------------------------------------------
  Translated into pascal with some help of h2pas utility from the FreePascal project.
  Petr Kozelka <pkozelka@email.cz>
  ------------------------------------------------------------------------------
}

{
LIBEXSLT_PUBLIC extern const char *exsltLibraryVersion;
LIBEXSLT_PUBLIC extern const int exsltLibexsltVersion;
LIBEXSLT_PUBLIC extern const int exsltLibxsltVersion;
LIBEXSLT_PUBLIC extern const int exsltLibxmlVersion;
}
const
  EXSLT_COMMON_NAMESPACE       = 'http://exslt.org/common';
  EXSLT_MATH_NAMESPACE         = 'http://exslt.org/math';
  EXSLT_SETS_NAMESPACE         = 'http://exslt.org/sets';
  EXSLT_FUNCTIONS_NAMESPACE    = 'http://exslt.org/functions';
  EXSLT_STRINGS_NAMESPACE      = 'http://exslt.org/strings';
  EXSLT_DATE_NAMESPACE         = 'http://exslt.org/dates-and-times';
  SAXON_NAMESPACE              = 'http://icl.com/saxon';
  EXSLT_DYNAMIC_NAMESPACE      = 'http://exslt.org/dynamic';

procedure exsltCommonRegister; cdecl; external LIBEXSLT_SO;
procedure exsltMathRegister; cdecl; external LIBEXSLT_SO;
procedure exsltSetsRegister; cdecl; external LIBEXSLT_SO;
procedure exsltFuncRegister; cdecl; external LIBEXSLT_SO;
procedure exsltStrRegister; cdecl; external LIBEXSLT_SO;
procedure exsltDateRegister; cdecl; external LIBEXSLT_SO;
procedure exsltSaxonRegister; cdecl; external LIBEXSLT_SO;
procedure exsltDynRegister; cdecl; external LIBEXSLT_SO;

procedure exsltRegisterAll; cdecl; external LIBEXSLT_SO;

