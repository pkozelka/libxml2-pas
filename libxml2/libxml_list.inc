{
	list.h: lists interfaces
  
	Copyright (C) 2000 Gary Pennington and Daniel Veillard.
  
	Permission to use, copy, modify, and distribute this software for any
	purpose with or without fee is hereby granted, provided that the above
	copyright notice and this permission notice appear in all copies.
  
	THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED
	WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
	MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE AUTHORS AND
	CONTRIBUTORS ACCEPT NO RESPONSIBILITY IN ANY CONCEIVABLE MANNER.
  
	Author: Gary.Pennington@uk.sun.com
}

{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}

type
	xmlLink = pointer;
	xmlLinkPtr = ^xmlLink;

	xmlList = pointer; //???
	xmlListPtr = ^xmlList;
	xmlListDeallocator = procedure (lk: xmlLinkPtr);
	xmlListDataCompare = function (data0,data1: pointer): integer;
	xmlListWalker = function (data, user: pointer): integer;

{ Creation/Deletion  }
function  xmlListCreate(deallocator:xmlListDeallocator; compare:xmlListDataCompare):xmlListPtr;cdecl;external LIBXML2_SO;
procedure xmlListDelete(l:xmlListPtr);cdecl;external LIBXML2_SO;

{ Basic Operators  }
function  xmlListSearch(l:xmlListPtr; data:pointer):pointer;cdecl;external LIBXML2_SO;
function  xmlListReverseSearch(l:xmlListPtr; data:pointer):pointer;cdecl;external LIBXML2_SO;
function  xmlListInsert(l:xmlListPtr; data:pointer):longint;cdecl;external LIBXML2_SO;
function  xmlListAppend(l:xmlListPtr; data:pointer):longint;cdecl;external LIBXML2_SO;
function  xmlListRemoveFirst(l:xmlListPtr; data:pointer):longint;cdecl;external LIBXML2_SO;
function  xmlListRemoveLast(l:xmlListPtr; data:pointer):longint;cdecl;external LIBXML2_SO;
function  xmlListRemoveAll(l:xmlListPtr; data:pointer):longint;cdecl;external LIBXML2_SO;
procedure xmlListClear(l:xmlListPtr);cdecl;external LIBXML2_SO;
function  xmlListEmpty(l:xmlListPtr):longint;cdecl;external LIBXML2_SO;
function  xmlListFront(l:xmlListPtr):xmlLinkPtr;cdecl;external LIBXML2_SO;
function  xmlListEnd(l:xmlListPtr):xmlLinkPtr;cdecl;external LIBXML2_SO;
function  xmlListSize(l:xmlListPtr):longint;cdecl;external LIBXML2_SO;
procedure xmlListPopFront(l:xmlListPtr);cdecl;external LIBXML2_SO;
procedure xmlListPopBack(l:xmlListPtr);cdecl;external LIBXML2_SO;
function  xmlListPushFront(l:xmlListPtr; data:pointer):longint;cdecl;external LIBXML2_SO;
function  xmlListPushBack(l:xmlListPtr; data:pointer):longint;cdecl;external LIBXML2_SO;

{ Advanced Operators  }
procedure xmlListReverse(l:xmlListPtr);cdecl;external LIBXML2_SO;
procedure xmlListSort(l:xmlListPtr);cdecl;external LIBXML2_SO;
procedure xmlListWalk(l:xmlListPtr; walker:xmlListWalker; user:pointer);cdecl;external LIBXML2_SO;
procedure xmlListReverseWalk(l:xmlListPtr; walker:xmlListWalker; user:pointer);cdecl;external LIBXML2_SO;
procedure xmlListMerge(l1:xmlListPtr; l2:xmlListPtr);cdecl;external LIBXML2_SO;
function  xmlListDup(old:xmlListPtr):xmlListPtr;cdecl;external LIBXML2_SO;
function  xmlListCopy(cur:xmlListPtr; old:xmlListPtr):longint;cdecl;external LIBXML2_SO;

{ Link operators  }
function  xmlLinkGetData(lk:xmlLinkPtr):pointer;cdecl;external LIBXML2_SO;
{ xmlListUnique()  }
{ xmlListSwap  }

