{
  This file configures various capabilities specific to particular compilers.
  2001-2002 (C) Petr Kozelka <pkozelka@email.cz>
}

{$MINENUMSIZE 4}
{$ASSERTIONS OFF}

// Memory alignment
{$IFDEF VER140} {$ALIGN 4} {$ELSE} {$ALIGN ON} {$ENDIF}

// Do we have deprecation directive ?
{$IFDEF VER140} {$DEFINE HAS_DEPR} {$ENDIF}


