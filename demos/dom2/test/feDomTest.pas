unit feDomTest;
{
    ------------------------------------------------------------------------------  
    Author:
    Uwe Fechner <uwe.fechner@4commerce.de>
    
    Copyright:
        4commerce technologies AG
        Kamerbalken 10-14
        22525 Hamburg, Germany
    Published under a double license:
    a) the GNU Library General Public License: 
       http://www.gnu.org/copyleft/lgpl.html
    b) the Mozilla Public License:
       http://www.mozilla.org/MPL/MPL-1.1.html
     ------------------------------------------------------------------------------
}

interface

  // just read an xml-document from a file
  function TestDom1(name,vendor:string):double;

  // walk through the tree
  // result: passed time
  // ignore: ignore whitespace;
  //   this value is true as default for msxml,
  //   false for libxml2
  //   the result is not exactly defined, if set to true, because it is not
  //   defined in any specification, what whitespace is and what not
  function TestDom2(name,vendor:string;ignore:boolean):double;

  function TestDom3(name,vendor:string):double;


implementation

uses MicroTime, conapp, sysutils, Dialogs, xdom2, libxml2,libxmldom,
  jkDomTest;

function TestDom1b(name,vendor:string):double;
var
  //dom: IDomImplementation;
  filename: string;
  doc: IDomDocument;
  FDomPersist: IDomPersist;
  ok: boolean;
  root:IDomElement;
begin
  filename:='..\data\'+name;
  StartTimer;
  doc:=GetEmptyDoc(vendor);

  FDomPersist:=doc as IDomPersist;
  ok:=FDomPersist.load(filename);
  if ok then begin
    outLog('Parsed file ok!');
    result:=EndTime;
    outLog('Elapsed time: '+format('%8.1f',[result*1000])+' ms');
  end else begin
    result := -1;
    outLog('Parse error!');
  end;
  // Erster Test
  outLog('doccount='+inttostr(doccount));
  root:=doc.documentElement;
  if root<>nil then outLog('Name of root element: '+root.nodeName);
  outlog(root.firstchild.nodeName);
  root:=nil;
  FDomPersist:=nil;
  doc:=nil;
end;

function TestDom1(name,vendor:string):double;
begin
  result:=TestDom1b(name,vendor);
  //The following code can help to check the
  //reference counting, if there are memory leaks
  //outLog('FINALLY:');
  //outLog('doccount='+inttostr(doccount));
  //outLog('nodecount='+inttostr(doccount));
  //outLog('elementcount='+inttostr(elementcount));
end;


function NextNode(node: IDomNode): IDomNode;
// a helper function for the tree-walker
  function NextDownNode(node: IDomNode): IDomNode;
  begin
    node:=node.parentNode;
    if node<>nil then
      if node.nextSibling<> nil
        then node:=node.nextSibling
        else node:=NextDownNode(node);
    result:=node
  end;
begin
  if node.hasChildNodes {and (node.firstChild.nodeType<>Text_Node)}
    then node:=node.firstChild
    else if node.nextSibling<> nil
      then node:=node.nextSibling
      else node:=NextDownNode(node);
  result:=node;
end;

function TestDom2b(name,vendor:string;ignore: boolean):double;
// a simple tree-walker
var node: IDomNode;
    filename: string;
    doc: IDomDocument;
    dom: IDomImplementation;
    FDomPersist: IDomPersist;
    ok: boolean;
    i: integer;
begin
  result:=0;
  filename:='..\data\'+name;
  StartTimer;
  dom:=getDom(vendor);
  doc:=dom.createDocument('','',nil);
  (doc as IDomParseOptions).preserveWhiteSpace:=not(ignore);
  FDomPersist:=doc as IDomPersist;
  ok:=FDomPersist.load(filename);
  if ok then
    begin
      outLog('Parsed file ok!');
      result:=EndTime;
      outLog('Elapsed time: '+format('%8.1f',[result*1000])+' ms');
      StartTimer;
      node:=doc.documentElement as IDOMNode;
      if node=nil
        then outLog('No root element!')
        else outLog(node.nodeName);
      i:=0;
      while (node<>nil) do begin
        outLog(node.nodeName);
        node:=NextNode(node);
        inc(i);
      end;
      outLog('NodeCount: '+inttostr(i));
      outLog('Traversed tree!');
      result:=EndTime;
      outLog('Elapsed time: '+format('%8.1f',[result*1000])+' ms');
    end;
  FDomPersist:=nil;
  doc:=nil;
end;

function TestDom2(name,vendor:string;ignore:boolean):double;
begin
  result:=TestDom2b(name,vendor,ignore);
  //The following code can help to check the
  //reference counting, if there are memory leaks//outLog('doccount='+inttostr(doccount));
  //outLog('nodecount='+inttostr(nodecount));
  //outLog('elementcount='+inttostr(elementcount));
end;

function getDoc(filename,vendor: string): IDomDocument;
var dom: IDomImplementation;
    doc: IDomDocument;
    FDomPersist: IDomPersist;
    ok: boolean;
begin
  dom := GetDom(vendor);
  doc := dom.createDocument('','',nil);
  FDomPersist := doc as IDomPersist;
  ok := FDomPersist.load(filename);
  if ok then result := doc else result := nil;
end;

function TestDom3(name,vendor:string):double;
var
  doc: IDomDocument;
  temp: string;
begin
  doc:=getDoc('..\data\'+name,vendor);
  if doc<>nil then
    begin
      outLog('Parsed file ok!');
    end;
  temp:=(doc as IDOMPersist).xml;
  // MSXML uses tabs for indentation,
  // LIBXML uses two spaces
  temp:=stringReplace(temp,#09,'  ',[rfReplaceAll]);
  // LIBXML has Unix-Style LF in it's output
  temp:=adjustLineBreaks(temp);
  outLog(temp);
end;

end.
