// CVS-REV:libxslt/libxslt/trio.h:1.2:
{
  ------------------------------------------------------------------------------
  Translated into pascal with help of h2pas utility from the FreePascal project.
  Petr Kozelka <pkozelka@email.cz>
  ------------------------------------------------------------------------------
}

(*
 *
 * $Id: libxslt_trio.inc,v 1.1 2003-08-21 14:08:30 pkozelka Exp $
 *
 * Copyright (C) 1998 Bjorn Reese and Daniel Stenberg.
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
 *
 *
 * http://ctrio.sourceforge.net/
 *
 *                                                                      *)
{$IFNDEF TRIO_TRIO_H}
{$DEFINE TRIO_TRIO_H}
{$IF !defined(WITHOUT_TRIO)}
(*
 * Use autoconf defines if present. Packages using trio must define
 * HAVE_CONFIG_H as a compiler option themselves.
 *)
{$IF defined(HAVE_CONFIG_H)}
{$ENDIF}
{$IF defined(TRIO_COMPILER_ANCIENT)}
{$ELSE}
{$ENDIF}
(*
 * Error codes.
 *
 * Remember to add a textual description to trio_strerror.
 *)
(* error
enum {
in declaration at line 64 *)
    { Error macros  }
    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }
    function TRIO_ERROR_CODE(x: Longint) : Longint;
    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }
    function TRIO_ERROR_POSITION(x: Longint) : Longint;
    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }
    function TRIO_ERROR_NAME(x: Longint) : Longint;
(* error
typedef int (*trio_outstream_t) TRIO_PROTO((trio_ Pointer_t, int));
in declaration at line 71 *)
(* error
typedef int (*trio_instream_t) TRIO_PROTO((trio_ Pointer_t));
in declaration at line 72 *)
(* error
TRIO_CONST char *trio_strerror TRIO_PROTO((int));
in declaration at line 74 *)
    {
       Print Functions
     *)
(* error
int trio_printf TRIO_PROTO((TRIO_CONST char *format, ...));
(* error
int trio_printf TRIO_PROTO((TRIO_CONST char *format, ...));
 in declarator_list *)
 in declarator_list *)
(* error
int trio_vprintf TRIO_PROTO((TRIO_CONST char *format, va_list args));
(* error
int trio_vprintf TRIO_PROTO((TRIO_CONST char *format, va_list args));
 in declarator_list *)
 in declarator_list *)
(* error
int trio_printfv TRIO_PROTO((TRIO_CONST char *format, void **args));
(* error
int trio_printfv TRIO_PROTO((TRIO_CONST char *format, void **args));
 in declarator_list *)
 in declarator_list *)
(* error
int trio_fprintf TRIO_PROTO((FILE *file, TRIO_CONST char *format, ...));
(* error
int trio_fprintf TRIO_PROTO((FILE *file, TRIO_CONST char *format, ...));
(* error
int trio_fprintf TRIO_PROTO((FILE *file, TRIO_CONST char *format, ...));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_vfprintf TRIO_PROTO((FILE *file, TRIO_CONST char *format, va_list args));
(* error
int trio_vfprintf TRIO_PROTO((FILE *file, TRIO_CONST char *format, va_list args));
(* error
int trio_vfprintf TRIO_PROTO((FILE *file, TRIO_CONST char *format, va_list args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_fprintfv TRIO_PROTO((FILE *file, TRIO_CONST char *format, void **args));
(* error
int trio_fprintfv TRIO_PROTO((FILE *file, TRIO_CONST char *format, void **args));
(* error
int trio_fprintfv TRIO_PROTO((FILE *file, TRIO_CONST char *format, void **args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_dprintf TRIO_PROTO((int fd, TRIO_CONST char *format, ...));
(* error
int trio_dprintf TRIO_PROTO((int fd, TRIO_CONST char *format, ...));
(* error
int trio_dprintf TRIO_PROTO((int fd, TRIO_CONST char *format, ...));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_vdprintf TRIO_PROTO((int fd, TRIO_CONST char *format, va_list args));
(* error
int trio_vdprintf TRIO_PROTO((int fd, TRIO_CONST char *format, va_list args));
(* error
int trio_vdprintf TRIO_PROTO((int fd, TRIO_CONST char *format, va_list args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_dprintfv TRIO_PROTO((int fd, TRIO_CONST char *format, void **args));
(* error
int trio_dprintfv TRIO_PROTO((int fd, TRIO_CONST char *format, void **args));
(* error
int trio_dprintfv TRIO_PROTO((int fd, TRIO_CONST char *format, void **args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_cprintf TRIO_PROTO((trio_outstream_t stream, trio_ Pointer_t closure,
(* error
int trio_cprintf TRIO_PROTO((trio_outstream_t stream, trio_ Pointer_t closure,
(* error
			     TRIO_CONST char *format, ...));
(* error
			     TRIO_CONST char *format, ...));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_vcprintf TRIO_PROTO((trio_outstream_t stream, trio_ Pointer_t closure,
(* error
int trio_vcprintf TRIO_PROTO((trio_outstream_t stream, trio_ Pointer_t closure,
(* error
			      TRIO_CONST char *format, va_list args));
(* error
			      TRIO_CONST char *format, va_list args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_cprintfv TRIO_PROTO((trio_outstream_t stream, trio_ Pointer_t closure,
(* error
int trio_cprintfv TRIO_PROTO((trio_outstream_t stream, trio_ Pointer_t closure,
(* error
			      TRIO_CONST char *format, void **args));
(* error
			      TRIO_CONST char *format, void **args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_sprintf TRIO_PROTO((char *buffer, TRIO_CONST char *format, ...));
(* error
int trio_sprintf TRIO_PROTO((char *buffer, TRIO_CONST char *format, ...));
(* error
int trio_sprintf TRIO_PROTO((char *buffer, TRIO_CONST char *format, ...));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_vsprintf TRIO_PROTO((char *buffer, TRIO_CONST char *format, va_list args));
(* error
int trio_vsprintf TRIO_PROTO((char *buffer, TRIO_CONST char *format, va_list args));
(* error
int trio_vsprintf TRIO_PROTO((char *buffer, TRIO_CONST char *format, va_list args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_sprintfv TRIO_PROTO((char *buffer, TRIO_CONST char *format, void **args));
(* error
int trio_sprintfv TRIO_PROTO((char *buffer, TRIO_CONST char *format, void **args));
(* error
int trio_sprintfv TRIO_PROTO((char *buffer, TRIO_CONST char *format, void **args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_snprintf TRIO_PROTO((char *buffer, size_t max, TRIO_CONST char *format, ...));
(* error
int trio_snprintf TRIO_PROTO((char *buffer, size_t max, TRIO_CONST char *format, ...));
(* error
int trio_snprintf TRIO_PROTO((char *buffer, size_t max, TRIO_CONST char *format, ...));
(* error
int trio_snprintf TRIO_PROTO((char *buffer, size_t max, TRIO_CONST char *format, ...));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_vsnprintf TRIO_PROTO((char *buffer, size_t bufferSize, TRIO_CONST char *format,
(* error
int trio_vsnprintf TRIO_PROTO((char *buffer, size_t bufferSize, TRIO_CONST char *format,
(* error
int trio_vsnprintf TRIO_PROTO((char *buffer, size_t bufferSize, TRIO_CONST char *format,
(* error
		   va_list args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_snprintfv TRIO_PROTO((char *buffer, size_t bufferSize, TRIO_CONST char *format,
(* error
int trio_snprintfv TRIO_PROTO((char *buffer, size_t bufferSize, TRIO_CONST char *format,
(* error
int trio_snprintfv TRIO_PROTO((char *buffer, size_t bufferSize, TRIO_CONST char *format,
(* error
		   void **args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_snprintfcat TRIO_PROTO((char *buffer, size_t max, TRIO_CONST char *format, ...));
(* error
int trio_snprintfcat TRIO_PROTO((char *buffer, size_t max, TRIO_CONST char *format, ...));
(* error
int trio_snprintfcat TRIO_PROTO((char *buffer, size_t max, TRIO_CONST char *format, ...));
(* error
int trio_snprintfcat TRIO_PROTO((char *buffer, size_t max, TRIO_CONST char *format, ...));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_vsnprintfcat TRIO_PROTO((char *buffer, size_t bufferSize, TRIO_CONST char *format,
(* error
int trio_vsnprintfcat TRIO_PROTO((char *buffer, size_t bufferSize, TRIO_CONST char *format,
(* error
int trio_vsnprintfcat TRIO_PROTO((char *buffer, size_t bufferSize, TRIO_CONST char *format,
(* error
                      va_list args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
char *trio_aprintf TRIO_PROTO((TRIO_CONST char *format, ...));
(* error
char *trio_aprintf TRIO_PROTO((TRIO_CONST char *format, ...));
 in declarator_list *)
 in declarator_list *)
(* error
char *trio_vaprintf TRIO_PROTO((TRIO_CONST char *format, va_list args));
(* error
char *trio_vaprintf TRIO_PROTO((TRIO_CONST char *format, va_list args));
 in declarator_list *)
 in declarator_list *)
(* error
int trio_asprintf TRIO_PROTO((char **ret, TRIO_CONST char *format, ...));
(* error
int trio_asprintf TRIO_PROTO((char **ret, TRIO_CONST char *format, ...));
(* error
int trio_asprintf TRIO_PROTO((char **ret, TRIO_CONST char *format, ...));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_vasprintf TRIO_PROTO((char **ret, TRIO_CONST char *format, va_list args));
(* error
int trio_vasprintf TRIO_PROTO((char **ret, TRIO_CONST char *format, va_list args));
(* error
int trio_vasprintf TRIO_PROTO((char **ret, TRIO_CONST char *format, va_list args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
    {
       Scan Functions
     *)
(* error
int trio_scanf TRIO_PROTO((TRIO_CONST char *format, ...));
(* error
int trio_scanf TRIO_PROTO((TRIO_CONST char *format, ...));
 in declarator_list *)
 in declarator_list *)
(* error
int trio_vscanf TRIO_PROTO((TRIO_CONST char *format, va_list args));
(* error
int trio_vscanf TRIO_PROTO((TRIO_CONST char *format, va_list args));
 in declarator_list *)
 in declarator_list *)
(* error
int trio_scanfv TRIO_PROTO((TRIO_CONST char *format, void **args));
(* error
int trio_scanfv TRIO_PROTO((TRIO_CONST char *format, void **args));
 in declarator_list *)
 in declarator_list *)
(* error
int trio_fscanf TRIO_PROTO((FILE *file, TRIO_CONST char *format, ...));
(* error
int trio_fscanf TRIO_PROTO((FILE *file, TRIO_CONST char *format, ...));
(* error
int trio_fscanf TRIO_PROTO((FILE *file, TRIO_CONST char *format, ...));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_vfscanf TRIO_PROTO((FILE *file, TRIO_CONST char *format, va_list args));
(* error
int trio_vfscanf TRIO_PROTO((FILE *file, TRIO_CONST char *format, va_list args));
(* error
int trio_vfscanf TRIO_PROTO((FILE *file, TRIO_CONST char *format, va_list args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_fscanfv TRIO_PROTO((FILE *file, TRIO_CONST char *format, void **args));
(* error
int trio_fscanfv TRIO_PROTO((FILE *file, TRIO_CONST char *format, void **args));
(* error
int trio_fscanfv TRIO_PROTO((FILE *file, TRIO_CONST char *format, void **args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_dscanf TRIO_PROTO((int fd, TRIO_CONST char *format, ...));
(* error
int trio_dscanf TRIO_PROTO((int fd, TRIO_CONST char *format, ...));
(* error
int trio_dscanf TRIO_PROTO((int fd, TRIO_CONST char *format, ...));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_vdscanf TRIO_PROTO((int fd, TRIO_CONST char *format, va_list args));
(* error
int trio_vdscanf TRIO_PROTO((int fd, TRIO_CONST char *format, va_list args));
(* error
int trio_vdscanf TRIO_PROTO((int fd, TRIO_CONST char *format, va_list args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_dscanfv TRIO_PROTO((int fd, TRIO_CONST char *format, void **args));
(* error
int trio_dscanfv TRIO_PROTO((int fd, TRIO_CONST char *format, void **args));
(* error
int trio_dscanfv TRIO_PROTO((int fd, TRIO_CONST char *format, void **args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_cscanf TRIO_PROTO((trio_instream_t stream, trio_ Pointer_t closure,
(* error
int trio_cscanf TRIO_PROTO((trio_instream_t stream, trio_ Pointer_t closure,
(* error
			    TRIO_CONST char *format, ...));
(* error
			    TRIO_CONST char *format, ...));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_vcscanf TRIO_PROTO((trio_instream_t stream, trio_ Pointer_t closure,
(* error
int trio_vcscanf TRIO_PROTO((trio_instream_t stream, trio_ Pointer_t closure,
(* error
			     TRIO_CONST char *format, va_list args));
(* error
			     TRIO_CONST char *format, va_list args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_cscanfv TRIO_PROTO((trio_instream_t stream, trio_ Pointer_t closure,
(* error
int trio_cscanfv TRIO_PROTO((trio_instream_t stream, trio_ Pointer_t closure,
(* error
			     TRIO_CONST char *format, void **args));
(* error
			     TRIO_CONST char *format, void **args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_sscanf TRIO_PROTO((TRIO_CONST char *buffer, TRIO_CONST char *format, ...));
(* error
int trio_sscanf TRIO_PROTO((TRIO_CONST char *buffer, TRIO_CONST char *format, ...));
(* error
int trio_sscanf TRIO_PROTO((TRIO_CONST char *buffer, TRIO_CONST char *format, ...));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_vsscanf TRIO_PROTO((TRIO_CONST char *buffer, TRIO_CONST char *format, va_list args));
(* error
int trio_vsscanf TRIO_PROTO((TRIO_CONST char *buffer, TRIO_CONST char *format, va_list args));
(* error
int trio_vsscanf TRIO_PROTO((TRIO_CONST char *buffer, TRIO_CONST char *format, va_list args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error
int trio_sscanfv TRIO_PROTO((TRIO_CONST char *buffer, TRIO_CONST char *format, void **args));
(* error
int trio_sscanfv TRIO_PROTO((TRIO_CONST char *buffer, TRIO_CONST char *format, void **args));
(* error
int trio_sscanfv TRIO_PROTO((TRIO_CONST char *buffer, TRIO_CONST char *format, void **args));
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
    {
       Locale Functions
     *)
(* error
void trio_locale_set_decimal_point TRIO_PROTO((char *decimalPoint));
 in declarator_list *)
(* error
void trio_locale_set_thousand_separator TRIO_PROTO((char *thousandSeparator));
 in declarator_list *)
(* error
void trio_locale_set_grouping TRIO_PROTO((char *grouping));
 in declarator_list *)
    {
       Renaming
     *)
{$IFDEF TRIO_REPLACE_STDIO}
    { Replace the <stdio.h> functions  }
{$IFNDEF HAVE_PRINTF}
const
       printf = trio_printf;
{$ENDIF}
{$IFNDEF HAVE_VPRINTF}
const
       vprintf = trio_vprintf;
{$ENDIF}
{$IFNDEF HAVE_FPRINTF}
const
       fprintf = trio_fprintf;
{$ENDIF}
{$IFNDEF HAVE_VFPRINTF}
const
       vfprintf = trio_vfprintf;
{$ENDIF}
{$IFNDEF HAVE_SPRINTF}
const
       sprintf = trio_sprintf;
{$ENDIF}
{$IFNDEF HAVE_VSPRINTF}
const
       vsprintf = trio_vsprintf;
{$ENDIF}
{$IFNDEF HAVE_SNPRINTF}
const
       snprintf = trio_snprintf;
{$ENDIF}
{$IFNDEF HAVE_VSNPRINTF}
const
       vsnprintf = trio_vsnprintf;
{$ENDIF}
{$IFNDEF HAVE_SCANF}
const
       scanf = trio_scanf;
{$ENDIF}
{$IFNDEF HAVE_VSCANF}
const
       vscanf = trio_vscanf;
{$ENDIF}
{$IFNDEF HAVE_FSCANF}
const
       fscanf = trio_fscanf;
{$ENDIF}
{$IFNDEF HAVE_VFSCANF}
const
       vfscanf = trio_vfscanf;
{$ENDIF}
{$IFNDEF HAVE_SSCANF}
const
       sscanf = trio_sscanf;
{$ENDIF}
{$IFNDEF HAVE_VSSCANF}
const
       vsscanf = trio_vsscanf;
{$ENDIF}
    { These aren't stdio functions, but we make them look similar  }
const
       dprintf = trio_dprintf;
       vdprintf = trio_vdprintf;
       aprintf = trio_aprintf;
       vaprintf = trio_vaprintf;
       asprintf = trio_asprintf;
       vasprintf = trio_vasprintf;
       dscanf = trio_dscanf;
       vdscanf = trio_vdscanf;
{$ENDIF}
{$IFDEF __cplusplus}
(* error
} (* extern "C" *)
    { extern "C"  }
{$ENDIF}
{$ENDIF}
    { WITHOUT_TRIO  }
{$ENDIF}
    { TRIO_TRIO_H  }
    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }
    function TRIO_ERROR_CODE(x: Longint) : Longint;
    begin
       TRIO_ERROR_CODE:=(-(x)) and $00FF;
    end;
    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }
    function TRIO_ERROR_POSITION(x: Longint) : Longint;
    begin
       TRIO_ERROR_POSITION:=(-(x)) shr 8;
    end;
    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }
    function TRIO_ERROR_NAME(x: Longint) : Longint;
    begin
       TRIO_ERROR_NAME:=trio_strerror(x);
    end;
