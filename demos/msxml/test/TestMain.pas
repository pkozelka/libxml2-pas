unit TestMain;

interface

uses
	msxml_libxml;

procedure Test_SelectSingleNode(aDoc: IXMLDOMDocument; aQuery: string);
procedure Test_SelectNodes(aNode: IXMLDOMDocument; aQuery: string);
procedure main(aFileName: widestring);

implementation

procedure Test_SelectSingleNode(aDoc: IXMLDOMDocument; aQuery: string);
var
	node: IXMLDOMNode;
	s: string;
begin
	WriteLN('selectSingleNode("'+aQuery+'")');
	node := aDoc.selectSingleNode(aQuery);
	if (node=nil) then begin
		WriteLN(' not found.');
	end else begin
		s := node.nodeName;
		WriteLN(' found: ', s);
	end;
end;

procedure Test_SelectNodes(aNode: IXMLDOMDocument; aQuery: string);
var
	lst: IXMLDOMNodeList;
	i: integer;
	s: string;
begin
	WriteLN('IXMLDOMNode.selectNodes("',aQuery,'")');
	lst := aNode.selectNodes(aQuery);
	for i:=0 to lst.length-1 do begin
		s := lst.item[i].nodeName;
		WriteLN(i:4, '.  ', s);
	end;
end;

procedure Test_XmlOutput(aNode: IXMLDOMNode);
var
	s: string;
begin
	WriteLN('IXMLDOMNode.xml');
	s := aNode.xml;
	WriteLN(s);
end;

procedure main(aFileName: widestring);
var
	doc: IXMLDOMDocument;
begin
	doc := CoDOMDocument.Create;
	doc.load(aFileName);
	Test_SelectSingleNode(doc, '//Family[@Name="ANHINGIDAE"]');
	Test_SelectNodes(doc, '/Class/Order');
	Test_XmlOutput(doc.documentElement);
	WriteLN('Press ENTER to continue...');
	ReadLN;
end;

end.
