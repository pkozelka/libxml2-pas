{ [1.9] hash.h
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}
{
	hash.c: chained hash tables

	Copyright (C) 2000 Bjorn Reese and Daniel Veillard.

	Permission to use, copy, modify, and distribute this software for any
	purpose with or without fee is hereby granted, provided that the above
	copyright notice and this permission notice appear in all copies.

	THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED
	WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
	MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE AUTHORS AND
	CONTRIBUTORS ACCEPT NO RESPONSIBILITY IN ANY CONCEIVABLE MANNER.

	Author: bjorn.reese@systematic.dk
}

type
	{
		The hash table
	}
	xmlHashTablePtr = ^xmlHashTable;
	xmlHashTable = record nothing:pointer end;
	{
		 function types:
	}
	xmlHashDeallocator = procedure (payload:pointer; name:PxmlChar);cdecl;
	xmlHashCopier = function (payload:pointer; name:PxmlChar):pointer;cdecl;
	xmlHashScanner = function (payload:pointer; data:pointer; name:PxmlChar):pointer;cdecl;
	xmlHashScannerFull = function (payload:pointer; data:pointer; name,name2,name3:PxmlChar):pointer;cdecl;

{
	Constructor and destructor
}
function  xmlHashCreate(size:longint):xmlHashTablePtr;cdecl;external LIBXML2_SO;
procedure xmlHashFree(table:xmlHashTablePtr; f:xmlHashDeallocator);cdecl;external LIBXML2_SO;

{
	Add a new entry to the hash table
}
function  xmlHashAddEntry(table:xmlHashTablePtr; name:PxmlChar; userdata:pointer):longint;cdecl;external LIBXML2_SO;
function  xmlHashUpdateEntry(table:xmlHashTablePtr; name:PxmlChar; userdata:pointer; f:xmlHashDeallocator):longint;cdecl;external LIBXML2_SO;
function  xmlHashAddEntry2(table:xmlHashTablePtr; name:PxmlChar; name2:PxmlChar; userdata:pointer):longint;cdecl;external LIBXML2_SO;
function  xmlHashUpdateEntry2(table:xmlHashTablePtr; name:PxmlChar; name2:PxmlChar; userdata:pointer; f:xmlHashDeallocator):longint;cdecl;external LIBXML2_SO;
function  xmlHashAddEntry3(table:xmlHashTablePtr; name:PxmlChar; name2:PxmlChar; name3:PxmlChar; userdata:pointer):longint;cdecl;external LIBXML2_SO;
function  xmlHashUpdateEntry3(table:xmlHashTablePtr; name:PxmlChar; name2:PxmlChar; name3:PxmlChar; userdata:pointer; f:xmlHashDeallocator):longint;cdecl;external LIBXML2_SO;

{
	Remove an entry from the hash table
}
function  xmlHashRemoveEntry(table:xmlHashTablePtr; name:PxmlChar; f:xmlHashDeallocator):longint;cdecl;external LIBXML2_SO;
function  xmlHashRemoveEntry2(table:xmlHashTablePtr; name:PxmlChar; name2:PxmlChar; f:xmlHashDeallocator):longint;cdecl;external LIBXML2_SO;
function  xmlHashRemoveEntry3(table:xmlHashTablePtr; name:PxmlChar; name2:PxmlChar; name3:PxmlChar; f:xmlHashDeallocator):longint;cdecl;external LIBXML2_SO;

{
	Retrieve the userdata
}
function  xmlHashLookup(table:xmlHashTablePtr; name:PxmlChar):pointer;cdecl;external LIBXML2_SO;
function  xmlHashLookup2(table:xmlHashTablePtr; name:PxmlChar; name2:PxmlChar):pointer;cdecl;external LIBXML2_SO;
function  xmlHashLookup3(table:xmlHashTablePtr; name:PxmlChar; name2:PxmlChar; name3:PxmlChar):pointer;cdecl;external LIBXML2_SO;

{
	Helpers
}
function  xmlHashCopy(table:xmlHashTablePtr; f:xmlHashCopier):xmlHashTablePtr;cdecl;external LIBXML2_SO;
function  xmlHashSize(table:xmlHashTablePtr):longint;cdecl;external LIBXML2_SO;
procedure xmlHashScan(table:xmlHashTablePtr; f:xmlHashScanner; data:pointer);cdecl;external LIBXML2_SO;
procedure xmlHashScan3(table:xmlHashTablePtr; name,name2,name3:PxmlChar; f:xmlHashScanner;data:pointer);cdecl;external LIBXML2_SO;
procedure xmlHashScanFull(table:xmlHashTablePtr; f:xmlHashScannerFull; data:pointer);cdecl;external LIBXML2_SO;
procedure xmlHashScanFull3(table:xmlHashTablePtr; name,name2,name3:PxmlChar; f:xmlHashScannerFull; data:pointer);cdecl;external LIBXML2_SO;

