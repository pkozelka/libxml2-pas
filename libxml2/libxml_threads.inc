{$PACKRECORDS C}

{ 
   threads.c: set of generic threading related routines 
  
   See Copyright for the status of this software.
  
   daniel@veillard.com
  }
{$ifndef __XML_THREADS_H__}
{$define __XML_THREADS_H__}
{$include <libxml/globals.h>}
{ C++ extern C conditionnal removed }
{
   xmlMutex are a simple mutual exception locks
  }
type
   _xmlMutex = xmlMutex;

   xmlMutexPtr = xmlMutex;

function xmlNewMutex:xmlMutexPtr;cdecl;external;
procedure xmlMutexLock(tok:xmlMutexPtr);cdecl;external;
procedure xmlMutexUnlock(tok:xmlMutexPtr);cdecl;external;
procedure xmlFreeMutex(tok:xmlMutexPtr);cdecl;external;
{
   xmlRMutex are reentrant mutual exception locks
  }
type
   _xmlRMutex = xmlRMutex;

   xmlRMutexPtr = xmlRMutex;

function xmlNewRMutex:xmlRMutexPtr;cdecl;external;
procedure xmlRMutexLock(tok:xmlRMutexPtr);cdecl;external;
procedure xmlRMutexUnlock(tok:xmlRMutexPtr);cdecl;external;
procedure xmlFreeRMutex(tok:xmlRMutexPtr);cdecl;external;
{
   Library wide APIs
  }
procedure xmlInitThreads;cdecl;external;
procedure xmlLockLibrary;cdecl;external;
procedure xmlUnlockLibrary;cdecl;external;
function xmlGetThreadId:longint;cdecl;external;
function xmlIsMainThread:longint;cdecl;external;
procedure xmlCleanupThreads;cdecl;external;
function xmlGetGlobalState:xmlGlobalStatePtr;cdecl;external;
{ C++ end of extern C conditionnal removed }
{$endif}
{ __XML_THREADS_H__  }

