unit conapp;
{Unit for application methods and variables
which are in the application object if you have a gui-application}

interface

uses classes,unit1;

procedure outLog(text:string='');
procedure outSQLLog(text:string='');
procedure outDebugLog(text:string='');

implementation

procedure outLog(text:string);
begin
  if Form1.EnableOutput.Checked then
    Form1.Memo1.Lines.Add(text);
end;

procedure outSQLLog(text:string);
begin
  if Form1.EnableOutput.Checked then
    Form1.Memo1.Lines.Add(text);
end;

procedure outDebugLog(text:string);
begin
  Form1.Memo1.Lines.Add(text);
end;

end.
