{
  This file configures various capabilities specific to particular compilers.
  2001-2002 (C) Petr Kozelka <pkozelka@email.cz>
}

{$MINENUMSIZE 4}
{$ASSERTIONS OFF}
{$DEFINE ALWAYS_TRUE}
{$UNDEF ALWAYS_FALSE}

// Memory alignment
{$IFDEF VER140} {$ALIGN 4} {$ELSE} {$ALIGN ON} {$ENDIF}

// Do we have deprecation directive ?
{$IFDEF VER140} {$DEFINE HAS_DEPR} {$ENDIF}

// Do we have varargs directive for procedures and functions ?
{$IFDEF VER140} {$DEFINE HAS_VA} {$ENDIF}

// Do we have varargs directive for functional types ?
{$IFDEF VER_NOT_YET} {$DEFINE HAS_TVA} {$ENDIF}

// Can we use global variables from shared modules ?
{$IFDEF VER_NOT_YET} {$DEFINE HAS_SO_VARS} {$ENDIF}

