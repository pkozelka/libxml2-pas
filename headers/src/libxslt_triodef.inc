// CVS-REV:libxslt/libxslt/triodef.h:1.3:
{
  ------------------------------------------------------------------------------
  Translated into pascal with help of h2pas utility from the FreePascal project.
  Petr Kozelka <pkozelka@email.cz>
  ------------------------------------------------------------------------------
}

(*
 *
 * $Id: libxslt_triodef.inc,v 1.1 2003-08-21 14:08:30 pkozelka Exp $
 *
 * Copyright (C) 2001 Bjorn Reese <breese@users.sourceforge.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
 * MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE AUTHORS AND
 * CONTRIBUTORS ACCEPT NO RESPONSIBILITY IN ANY CONCEIVABLE MANNER.
 *
 *                                                                      *)
{$IFNDEF TRIO_TRIODEF_H}
{$DEFINE TRIO_TRIODEF_H}
(*
 * Platform and compiler support detection
 *)
{$IF defined(__GNUC__)}
{$DEFINE TRIO_COMPILER_GCC}
(*** was #elif ****){$ELSE defined(__SUNPRO_C)}
{$DEFINE TRIO_COMPILER_SUNPRO}
(*** was #elif ****){$ELSE defined(__SUNPRO_CC)}
{$DEFINE TRIO_COMPILER_SUNPRO}
const
  __SUNPRO_C = __SUNPRO_CC;
(*** was #elif ****){$ELSE defined(__xlC__) || defined(__IBMC__) || defined(__IBMCPP__)}
{$DEFINE TRIO_COMPILER_XLC}
(*** was #elif ****){$ELSE defined(_AIX) && !defined(__GNUC__)}
{ Workaround for old xlc  }
{$DEFINE TRIO_COMPILER_XLC}
(*** was #elif ****){$ELSE defined(__DECC) || defined(__DECCXX)}
{$DEFINE TRIO_COMPILER_DECC}
(*** was #elif ****){$ELSE defined(__osf__) && defined(__LANGUAGE_C__)}
{ Workaround for old DEC C compilers  }
{$DEFINE TRIO_COMPILER_DECC}
(*** was #elif ****){$ELSE defined(_MSC_VER)}
{$DEFINE TRIO_COMPILER_MSVC}
(*** was #elif ****){$ELSE defined(__BORLANDC__)}
{$DEFINE TRIO_COMPILER_BCB}
{$ENDIF}
{$IF defined(VMS) || defined(__VMS)}
(*
 * VMS is placed first to avoid identifying the platform as Unix
 * based on the DECC compiler later on.
 *)
{$DEFINE TRIO_PLATFORM_VMS}
(*** was #elif ****){$ELSE defined(unix) || defined(__unix) || defined(__unix__)}
{$DEFINE TRIO_PLATFORM_UNIX}
(*** was #elif ****){$ELSE defined(TRIO_COMPILER_XLC) || defined(_AIX)}
{$DEFINE TRIO_PLATFORM_UNIX}
(*** was #elif ****){$ELSE defined(TRIO_COMPILER_DECC) || defined(__osf___)}
{$DEFINE TRIO_PLATFORM_UNIX}
(*** was #elif ****){$ELSE defined(__NetBSD__)}
{$DEFINE TRIO_PLATFORM_UNIX}
(*** was #elif ****){$ELSE defined(__QNX__)}
{$DEFINE TRIO_PLATFORM_UNIX}
{$DEFINE TRIO_PLATFORM_QNX}
(*** was #elif ****){$ELSE defined(__CYGWIN__)}
{$DEFINE TRIO_PLATFORM_UNIX}
(*** was #elif ****){$ELSE defined(AMIGA) && defined(TRIO_COMPILER_GCC)}
{$DEFINE TRIO_PLATFORM_UNIX}
(*** was #elif ****){$ELSE defined(TRIO_COMPILER_MSVC) || defined(WIN32) || defined(_WIN32)}
{$DEFINE TRIO_PLATFORM_WIN32}
(*** was #elif ****){$ELSE defined(mpeix) || defined(__mpexl)}
{$DEFINE TRIO_PLATFORM_MPEIX}
{$ENDIF}
{$IF defined(_AIX)}
{$DEFINE TRIO_PLATFORM_AIX}
(*** was #elif ****){$ELSE defined(__hpux)}
{$DEFINE TRIO_PLATFORM_HPUX}
(*** was #elif ****){$ELSE defined(sun) || defined(__sun__)}
{$IF defined(__SVR4) || defined(__svr4__)}
{$DEFINE TRIO_PLATFORM_SOLARIS}
{$ELSE}
{$DEFINE TRIO_PLATFORM_SUNOS}
{$ENDIF}
{$ENDIF}
{$IF defined(__STDC__) || defined(TRIO_COMPILER_MSVC) || defined(TRIO_COMPILER_BCB)}
{$DEFINE TRIO_COMPILER_SUPPORTS_C89}
{$IF defined(__STDC_VERSION__)}
{$DEFINE TRIO_COMPILER_SUPPORTS_C90}
{$IF (__STDC_VERSION__ >= 199409L)}
{$DEFINE TRIO_COMPILER_SUPPORTS_C94}
{$ENDIF}
{$IF (__STDC_VERSION__ >= 199901L)}
{$DEFINE TRIO_COMPILER_SUPPORTS_C99}
{$ENDIF}
(*** was #elif ****){$ELSE defined(TRIO_COMPILER_SUNPRO)}
{$IF (__SUNPRO_C >= 0x420)}
{$DEFINE TRIO_COMPILER_SUPPORTS_C94}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$IF defined(_XOPEN_SOURCE)}
{$IF defined(_XOPEN_SOURCE_EXTENDED)}
{$DEFINE TRIO_COMPILER_SUPPORTS_UNIX95}
{$ENDIF}
{$IF (_XOPEN_VERSION >= 500)}
{$DEFINE TRIO_COMPILER_SUPPORTS_UNIX98}
{$ENDIF}
{$IF (_XOPEN_VERSION >= 600)}
{$DEFINE TRIO_COMPILER_SUPPORTS_UNIX01}
{$ENDIF}
{$ENDIF}
(*
 * Generic defines
 *)
{$IF !defined(TRIO_PUBLIC)}
{$DEFINE TRIO_PUBLIC}
{$ENDIF}
{$IF !defined(TRIO_PRIVATE)}
const
  TRIO_PRIVATE = static;
{$ENDIF}
{$IF !(defined(TRIO_COMPILER_SUPPORTS_C89) || defined(__cplusplus))}
{$DEFINE TRIO_COMPILER_ANCIENT}
{$ENDIF}
{$IF defined(TRIO_COMPILER_ANCIENT)}
{$DEFINE TRIO_CONST}
{$DEFINE TRIO_VOLATILE}
{$DEFINE TRIO_SIGNED}
type
  trio_long_double_t = double;
  trio_ Pointer_t = char;
{ was #define dname(params) para_def_expr }
{ argument types are unknown }
{ return type might be wrong }
function TRIO_SUFFIX_LONG(x: Longint) : Longint;
(* error
# define TRIO_PROTO(x) ()
in define line 135 *)
{$DEFINE TRIO_NOARGS}
(* error
# define TRIO_ARGS1(list,a1) list a1;
in declaration at line 137 *)
(* error
# define TRIO_ARGS2(list,a1,a2) list a1; a2;
in declaration at line 138 *)
(* error
# define TRIO_ARGS2(list,a1,a2) list a1; a2;
in declaration at line 138 *)
(* error
# define TRIO_ARGS3(list,a1,a2,a3) list a1; a2; a3;
in declaration at line 139 *)
(* error
# define TRIO_ARGS3(list,a1,a2,a3) list a1; a2; a3;
in declaration at line 139 *)
(* error
# define TRIO_ARGS3(list,a1,a2,a3) list a1; a2; a3;
in declaration at line 139 *)
(* error
# define TRIO_ARGS4(list,a1,a2,a3,a4) list a1; a2; a3; a4;
in declaration at line 140 *)
(* error
# define TRIO_ARGS4(list,a1,a2,a3,a4) list a1; a2; a3; a4;
in declaration at line 140 *)
(* error
# define TRIO_ARGS4(list,a1,a2,a3,a4) list a1; a2; a3; a4;
in declaration at line 140 *)
(* error
# define TRIO_ARGS4(list,a1,a2,a3,a4) list a1; a2; a3; a4;
in declaration at line 140 *)
(* error
# define TRIO_ARGS5(list,a1,a2,a3,a4,a5) list a1; a2; a3; a4; a5;
in declaration at line 141 *)
(* error
# define TRIO_ARGS5(list,a1,a2,a3,a4,a5) list a1; a2; a3; a4; a5;
in declaration at line 141 *)
(* error
# define TRIO_ARGS5(list,a1,a2,a3,a4,a5) list a1; a2; a3; a4; a5;
in declaration at line 141 *)
(* error
# define TRIO_ARGS5(list,a1,a2,a3,a4,a5) list a1; a2; a3; a4; a5;
in declaration at line 141 *)
(* error
# define TRIO_ARGS5(list,a1,a2,a3,a4,a5) list a1; a2; a3; a4; a5;
in declaration at line 141 *)
(* error
# define TRIO_ARGS6(list,a1,a2,a3,a4,a5,a6) list a1; a2; a3; a4; a5; a6;
in declaration at line 142 *)
(* error
# define TRIO_ARGS6(list,a1,a2,a3,a4,a5,a6) list a1; a2; a3; a4; a5; a6;
in declaration at line 142 *)
(* error
# define TRIO_ARGS6(list,a1,a2,a3,a4,a5,a6) list a1; a2; a3; a4; a5; a6;
in declaration at line 142 *)
(* error
# define TRIO_ARGS6(list,a1,a2,a3,a4,a5,a6) list a1; a2; a3; a4; a5; a6;
in declaration at line 142 *)
(* error
# define TRIO_ARGS6(list,a1,a2,a3,a4,a5,a6) list a1; a2; a3; a4; a5; a6;
in declaration at line 142 *)
(* error
# define TRIO_ARGS6(list,a1,a2,a3,a4,a5,a6) list a1; a2; a3; a4; a5; a6;
in declaration at line 142 *)
(* error
# define TRIO_VARGS2(list,a1,a2) list a1; a2
in declaration at line 143 *)
(* error
# define TRIO_VARGS3(list,a1,a2,a3) list a1; a2; a3
in declaration at line 144 *)
(* error
# define TRIO_VARGS3(list,a1,a2,a3) list a1; a2; a3
in declaration at line 144 *)
(* error
# define TRIO_VARGS4(list,a1,a2,a3,a4) list a1; a2; a3; a4
in declaration at line 145 *)
(* error
# define TRIO_VARGS4(list,a1,a2,a3,a4) list a1; a2; a3; a4
in declaration at line 145 *)
(* error
# define TRIO_VARGS4(list,a1,a2,a3,a4) list a1; a2; a3; a4
in declaration at line 145 *)
(* error
# define TRIO_VARGS5(list,a1,a2,a3,a4,a5) list a1; a2; a3; a4; a5
in declaration at line 146 *)
(* error
# define TRIO_VARGS5(list,a1,a2,a3,a4,a5) list a1; a2; a3; a4; a5
in declaration at line 146 *)
(* error
# define TRIO_VARGS5(list,a1,a2,a3,a4,a5) list a1; a2; a3; a4; a5
in declaration at line 146 *)
(* error
# define TRIO_VARGS5(list,a1,a2,a3,a4,a5) list a1; a2; a3; a4; a5
in declaration at line 146 *)
(* error
# define TRIO_VA_DECL va_dcl
in define line 147 *)
    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }
    function TRIO_VA_START(x,y: Longint) : Longint;
    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }
    function TRIO_VA_END(x: Longint) : Longint;
{$ELSE}
    { ANSI C  }
(* error
# define TRIO_CONST const
in define line 151 *)
const
       TRIO_VOLATILE =