// CVS-REV:gnome-xml/include/libxml/dict.h:1.1:
{
  ------------------------------------------------------------------------------
  Translated into pascal with help of h2pas utility from the FreePascal project.
  Petr Kozelka <pkozelka@email.cz>
  ------------------------------------------------------------------------------
}

(*
 * dict.h: dictionary of reusable strings, just used to avoid allocation
 *         and freeing operations.
 *
 * Copyright (C) 2003 Daniel Veillard.
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
 * Author: daniel@veillard.com
 *)
(*
 * The dictionnary.
 *)
type
  xmlDict = record end;
  xmlDictPtr = ^xmlDict;
(*
 * constructor and destructor.
 *)
function xmlDictCreate: xmlDictPtr; cdecl; external LIBXML2_SO;
procedure xmlDictFree(dict: xmlDictPtr); cdecl; external LIBXML2_SO;
(*
 * Lookup of entry in the dictionnary.
 *)
function xmlDictLookup(dict: xmlDictPtr; name: PxmlChar; len: Longint): PxmlChar; cdecl; external LIBXML2_SO;
function xmlDictSize(dict: xmlDictPtr): Longint; cdecl; external LIBXML2_SO;
