// CVS-SIGN: [1.11] libxslt/extra.h
{
    ------------------------------------------------------------------------------
    Translated into pascal with help of h2pas utility from the FreePascal project.
    Copyright for the header translation:
        4commerce technologies AG
        Kamerbalken 10-14
        22525 Hamburg, Germany
    Updated by Petr Kozelka <pkozelka@email.cz>

    Published under a double license:
    a) the GNU Library General Public License:
       http://www.gnu.org/copyleft/lgpl.html
    b) the Mozilla Public License:
       http://www.mozilla.org/MPL/MPL-1.1.html
    Please send corrections to: ufechner@4commerce.de
    ------------------------------------------------------------------------------
}
(*
 * extra.h: interface for the non-standard features
 *
 * See Copyright for the status of this software.
 *
 * daniel@veillard.com
 *)

const
  (**
   * XSLT_LIBXSLT_NAMESPACE:
   *
   * This is the libxslt namespace for specific extensions
   *)
  XSLT_LIBXSLT_NAMESPACE = 'http://xmlsoft.org/XSLT/namespace';

  (**
   * XSLT_SAXON_NAMESPACE:
   *
   * This is Michael Kay's Saxon processor namespace for extensions
   *)
  XSLT_SAXON_NAMESPACE = 'http://icl.com/saxon';

  (**
   * XSLT_XT_NAMESPACE:
   *
   * This is James Clark's XT processor namespace for extensions
   *)
  XSLT_XT_NAMESPACE = 'http://www.jclark.com/xt';

  (**
   * XSLT_XALAN_NAMESPACE:
   *
   * This is the Apache project XALAN processor namespace for extensions
   *)
  XSLT_XALAN_NAMESPACE = 'org.apache.xalan.xslt.extensions.Redirect';

  (**
   * XSLT_NORM_SAXON_NAMESPACE:
   *
   * This is Nom's namespace for SAXON extensions
   *)
  XSLT_NORM_SAXON_NAMESPACE = 'http://nwalsh.com/xslt/ext/com.nwalsh.saxon.CVS';

procedure xsltFunctionNodeSet(ctxt:xmlXPathParserContextPtr; nargs:longint);cdecl;external LIBXSLT_SO;
procedure xsltDebug(ctxt:xsltTransformContextPtr; node:xmlNodePtr; inst:xmlNodePtr; comp:xsltStylePreCompPtr);cdecl;external LIBXSLT_SO;
procedure xsltRegisterExtras(ctxt:xsltTransformContextPtr);cdecl;external LIBXSLT_SO;
procedure xsltRegisterAllExtras;cdecl;external LIBXSLT_SO;


