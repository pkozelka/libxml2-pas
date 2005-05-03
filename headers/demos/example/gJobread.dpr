program gJobread;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  libxml2;

type

 // A person record
  person = record
    name: PChar;
    email: PChar;
    company: PChar;
    organisation: PChar;
    smail: PChar;
    webPage: PChar;
    phone: PChar;
  end;
  personPtr = ^person;

  job = record  // a Description for a Job
    projectID: PChar;
    application: PChar;
    category: PChar;
    contact: personPtr;
    nbDevelopers: integer;
    developers: array[1..100] of personPtr;
  end;
  jobPtr = ^job;

  gjob = record  //  A pool of Gnome Jobs
    nbJobs: integer;
    jobs: array[1..500] of jobPtr;
  end;
  gJobPtr = ^gJob;

function parsePerson(doc: xmlDocPtr; ns: xmlNsPtr; cur: xmlNodePtr) : personPtr;
begin
  Result := nil;

  // allocate the struct
  try
    new(Result);
  except
    on EOutOfMemory do
    begin
      Writeln(ErrOutput, 'out of memory');
      Exit;
    end;
  end;

  FillChar(Result^, sizeof(Result^), 0);

  // We don't care what the top level element name is
  cur := cur.children;
  while Assigned(cur) do
  begin
    if (xmlStrcmp(cur.name, 'Person') = 0) and (cur.ns = ns) then
      Result.name := xmlNodeListGetString(doc, cur.children, 1);
    if (xmlStrcmp(cur.name, 'Email') = 0) and (cur.ns = ns) then
      Result.email := xmlNodeListGetString(doc, cur.children, 1);
    cur := cur.next;
  end;
end;

procedure printPerson(cur: personPtr);
begin
  if not Assigned(cur) then Exit;
  Writeln('------ Person');
  if Assigned(cur.name) then Writeln(' name: ', cur.name);
  if Assigned(cur.email) then Writeln('  email: ', cur.email);
  if Assigned(cur.company) then Writeln('  company: ', cur.company);
  if Assigned(cur.organisation) then Writeln(' organisation: ', cur.organisation);
  if Assigned(cur.smail) then Writeln('  samil: ', cur.smail);
  if Assigned(cur.webPage) then Writeln('  Web: ', cur.webPage);
  if Assigned(cur.phone) then Writeln('  phone: ', cur.phone);
  writeln('------');
end;

function parseJob(doc: xmlDocPtr; ns: xmlNsPtr; cur: xmlNodePtr): jobPtr;
begin
  Result := nil;

  // allocate the struct
  try
    new(Result);
  except
    on EOutOfMemory do
    begin
      Writeln(ErrOutput, 'out of memory');
      Exit;
    end;
  end;

  FillChar(Result^, sizeof(Result^), 0);

  // We don't care what the top level element name is
  cur := cur.children;
  while Assigned(cur) do
  begin
    if (xmlStrcmp(cur.name, 'Project') = 0) and (cur.ns = ns) then
    begin
      Result.projectID := xmlGetProp(cur, 'ID');
      if not Assigned(Result.projectID) then
        writeln(ErrOutput, 'Project has no ID');
    end;

    if (xmlStrcmp(cur.name, 'Application') = 0) and (cur.ns = ns) then
	    Result.application := xmlNodeListGetString(doc, cur.children, 1);
    if (xmlStrcmp(cur.name, 'Category') = 0) and (cur.ns = ns) then
	    Result.category := xmlNodeListGetString(doc, cur.children, 1);
    if (xmlStrcmp(cur.name, 'Contact') = 0) and (cur.ns = ns) then
	    Result.contact := parsePerson(doc, ns, cur);
    cur := cur.next;
  end;
end;

procedure printJob(cur: jobPtr);
var
  i: integer;
begin
  if not Assigned(cur) then Exit;
  Writeln('=======  Job');
  if Assigned(cur.projectID) then writeln('projectID: ',cur.projectID);
  if Assigned(cur.application) then writeln('application: ',cur.application);
  if Assigned(cur.category) then writeln('category: ',cur.category);
  if Assigned(cur.contact) then printPerson(cur.contact);
  Writeln(cur.nbDevelopers, ' developers');

  for i := 1 to cur.nbDevelopers do
    printPerson(cur.developers[i]);
  Writeln('======= ');
end;

procedure freeJob(cur: jobPtr);
var
  i: integer;
begin
  if Assigned(cur) then
  begin
    if Assigned(cur.contact) then
      Dispose(cur.contact);
    for i := 1 to cur.nbDevelopers do
      if Assigned(cur.developers[i]) then
        Dispose(cur.developers[i]);
    Dispose(cur);
  end;
end;

function parseGjobFile(filename: string): gJobPtr;
var
  doc: xmlDocPtr;
  curjob: jobPtr;
  ns: xmlNsPtr;
  cur: xmlNodePtr;
begin
  Result := nil;
  doc := xmlParseFile(PChar(filename));
  if not Assigned(doc) then Exit;

  // Check the document is of the right kind

  cur := xmlDocGetRootElement(doc);
  if not Assigned(cur) then
  begin
    Writeln(ErrOutput, 'empty document');
  	xmlFreeDoc(doc);
    Exit;
  end;

  ns := xmlSearchNsByHref(doc, cur,
	    'http://www.gnome.org/some-location');
  if not Assigned(ns) then
  begin
    Writeln(ErrOutput, 'document of the wrong type, GJob Namespace not found');
  	xmlFreeDoc(doc);
    Exit;
  end;

  if (xmlStrcmp(cur.name, 'Helping') <> 0) then
  begin
    Writeln(ErrOutput, 'document of the wrong type, root node <> Helping');
  	xmlFreeDoc(doc);
    Exit;
  end;

  // Allocate the structure to be returned.

  // allocate the struct
  try
    new(Result);
  except
    on EOutOfMemory do
    begin
      Writeln(ErrOutput, 'out of memory');
      xmlFreeDoc(doc);
      Exit;
    end;
  end;

  FillChar(Result^, sizeof(Result^), 0);

  // Now, walk the tree.

  // First level we expect just Jobs
  cur := cur.children;
  while Assigned(cur) and (xmlIsBlankNode(cur) <> 0) do
    cur := cur.next;
  if not Assigned(cur) then
    Exit;
  if (xmlStrcmp(cur.name, 'Jobs') <> 0) or (cur.ns <> ns) then
  begin
    Writeln(ErrOutput, 'document of the wrong type, was ', cur.name, ', Jobs expected');
  	xmlFreeDoc(doc);
    Dispose(Result);
  end;

  // Second level is a list of Job, but be laxist */
  cur := cur.children;
  while Assigned(cur) do
  begin
    if (xmlStrcmp(cur.name, 'Job') = 0) and (cur.ns = ns) then
    begin
      curjob := parseJob(doc, ns, cur);
      if Assigned(curjob) then
      begin
        Inc(Result.nbJobs);
        if Result.nbJobs > 500 then
          Break;
        Result.jobs[Result.nbJobs] := curjob;
      end;
    end;
	  cur := cur.next;
  end;
end;

procedure freeGJob(cur: gJobPtr);
var
  i: integer;
begin
  if Assigned(cur) then
  begin
    for i := 1 to cur.nbJobs do
      freeJob(cur.jobs[i]);
    Dispose(cur);
  end;
end;

procedure handleGjob(cur: gJobPtr);
var
  i: integer;
begin
  // Do whatever you want and free the structure.
  Writeln(cur.nbJobs, ' Jobs registered');
  for i := 1 to cur.nbJobs do
    printJob(cur.jobs[i]);
end;

var
  i: integer;
  cur: gJobPtr;
begin

  xmlCheckVersion(20617);
  //  COMPAT: Do not genrate nodes for formatting spaces
  xmlKeepBlanksDefault(0);

  for i := 1 to paramcount do
  begin
    cur := parseGjobFile(paramStr(i));
    if Assigned(cur) then
    begin
      handleGjob(cur);
      freeGjob(cur);
    end
    else
      writeln(ErrOutput, 'Error parsing file ', paramStr(i));
  end;

   // Clean up everything else before quitting.
  xmlCleanupParser();
end.
