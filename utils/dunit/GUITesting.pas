{ #(@)$Id: GUITesting.pas,v 1.1 2002-01-10 12:55:31 ufechner Exp $ }
{: DUnit: An XTreme testing framework for Delphi programs.
   @author  The DUnit Group.
   @version $Revision: 1.1 $ 2001/03/08 uberto
}
(*
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code is DUnit.
 *
 * The Initial Developers of the Original Code are Serge Beaumont
 * and Juancarlo Añez.
 * Portions created The Initial Developers are Copyright (C) 1999-2000.
 * Portions created by The DUnit Group are Copyright (C) 2000-2001.
 * All rights reserved.
 *
 * Contributor(s):
 * Serge Beaumont <beaumose@iquip.nl>
 * Juanco Añez <juanco@users.sourceforge.net>
 * Uberto Barbini <uberto@usa.net>
 * Kris Golko <neuromancer@users.sourceforge.net>
 * The DUnit group at SourceForge <http://dunit.sourceforge.net>
 *
 *)

// use short strings to be able to handle tests in DLLs.
{$LONGSTRINGS OFF}
unit GUITesting;

interface
uses
  TestFramework,

{$IFNDEF LINUX}
  Windows,
  Messages,
  Controls,
  Forms,
{$ELSE}
  Qt,
  Types,
  QControls,
  QForms,
{$ENDIF}
  SysUtils,
  Classes;

const
  rcs_id: string = '#(@)$Id: GUITesting.pas,v 1.1 2002-01-10 12:55:31 ufechner Exp $';

type
  TGUITestCase = class(TTestCase)
  public
    constructor Create(MethodName :string); override;
    destructor  Destroy; override;

    procedure TearDown; override;

  protected
    FGUI         :TControl; // this is the control we're testing
    FActionDelay :Integer;

    function  FindControl(Comp: TComponent; const CtlName: string; Addr :Pointer = nil): TControl; overload;
    function  FindControl(const Name: string; Addr :Pointer = nil): TControl;                      overload;

    function  FindParentWinControl(Control :TControl):TWinControl;

    function  ShiftStateToKeyData(ShiftState :TShiftState):Longint;
    procedure ClickLeftMouseButtonOn(Control: TControl);

    procedure Click;                      overload;
    procedure Click(ControlName :string); overload;
    procedure Click(control :TControl);   overload;

    procedure EnterKey(Key :Word; const ShiftState :TShiftState = []); overload;
    procedure EnterKeyInto(Control :TControl;   Key :Word; const ShiftState :TShiftState = []); overload;
    procedure EnterKeyInto(ControlName :string; Key :Word; const ShiftState :TShiftState = []); overload;

    procedure EnterKey(Key :Char; const ShiftState :TShiftState = []); overload;
    procedure EnterKeyInto(Control :TControl;   Key :Char; const ShiftState :TShiftState = []); overload;
    procedure EnterKeyInto(ControlName :string; Key :Char; const ShiftState :TShiftState = []); overload;

    procedure EnterText(Text :string);
    procedure EnterTextInto(Control :TControl;   Text :string); overload;
    procedure EnterTextInto(ControlName :string; Text :string); overload;

    procedure Show(OnOff :boolean = true);                      overload;
    procedure Show(Control :TControl; OnOff :boolean = true);   overload;
    procedure Show(ControlName :string; OnOff :boolean = true); overload;

    procedure Hide;                      overload;
    procedure Hide(Control :TControl);   overload;
    procedure Hide(ControlName :string); overload;

    procedure Tab(n :Integer =1);


    procedure CheckTabTo(Control :TControl; Addr :Pointer = nil); overload;
    procedure CheckTabTo(ControlName :string);                    overload;

    function  GetFocused :TControl;
    procedure SetFocus(Control :TControl; Addr :Pointer = nil); overload;
    procedure SetFocus(ControlName :string);                    overload;

    procedure CheckFocused(Control :TControl; Addr :Pointer = nil); overload;
    procedure CheckFocused(ControlName :string);                    overload;

    procedure CheckEnabled(Control :TControl; Addr :Pointer = nil);  overload;
    procedure CheckEnabled(ControlName :string);                     overload;

    procedure CheckVisible(Control :TControl; Addr :Pointer = nil);  overload;
    procedure CheckVisible(ControlName :string);                     overload;
    procedure CheckVisible;                                          overload;

    property GUI :TControl read FGUI write FGUI;
    property ActionDelay :Integer  read FActionDelay write FActionDelay;
  end;


implementation

// assertions are always on so we can check for own consistency
{$ASSERTIONS ON}
// need stack frames to use CallerAddr
{$STACKFRAMES ON}

{ TGUITestCase }

constructor TGUITestCase.Create(MethodName :string);
begin
  inherited Create(MethodName);
  FActionDelay := 100;
end;

destructor TGUITestCase.Destroy;
begin
  FGUI.Free;
  inherited Destroy;
end;

procedure TGUITestCase.TearDown;
begin
  inherited TearDown;
  FGUI.Free;
  FGUI := nil;
end;

function TGUITestCase.FindControl(Comp: TComponent; const CtlName: string; Addr :Pointer): TControl;

  function DoFind(C :TComponent; const CName :string) :TControl;
  var
    i: Integer;
  begin
    Result := nil;
    i := 0;
    while (Result = nil) and (i < C.ComponentCount) do
    begin
      with C do
      begin
        if (Components[i] is TControl)
        and (UpperCase(Components[i].Name) = CName) then
          Result := Components[I] as TControl
        else
          Result := DoFind(Components[I], CName);
      end;
      Inc(i);
    end;
  end;
begin
  if Addr = nil then
    Addr := CallerAddr;


  if Trim(CtlName) = '' then
    Fail('No control name', Addr);

  Result := DoFind(Comp, UpperCase(CtlName));

  if Result = nil then
    Fail( Format('Control named "%s" not found in %s',
                  [CtlName, Screen.ActiveForm.Name])
    );
end;

procedure TGUITestCase.ClickLeftMouseButtonOn(Control: TControl);
var
{$IFDEF LINUX}
  P: TPoint;
  evMouse: QMouseEventH;
{$ELSE}
  P: TSmallPoint;
{$ENDIF}
begin
  Assert(Control <> nil, 'No control');

  Control := FindParentWinControl(Control);
  if Control <> nil then
  begin
    {:@ todo consider if this method should have X,Y parameters.
      @todo This doesn't work if the original control is not a TWinControl and is not in
       the middle of its parent. }
{$IFDEF LINUX}
    P := Point(Control.Width  div 2, Control.Height div 2);
    evMouse := QMouseEvent_create(QEventType_MouseButtonPress, @P, Integer(ButtonState_LeftButton), Integer(ButtonState_LeftButton));
    QApplication_sendEvent(TWidgetControl(Control).Handle, evMouse);
    evMouse := QMouseEvent_create(QEventType_MouseButtonRelease, @P, Integer(ButtonState_LeftButton), Integer(ButtonState_LeftButton));
    QApplication_sendEvent(TWidgetControl(Control).Handle, evMouse);
{$ELSE}
    P := SmallPoint(Control.Width  div 2, Control.Height div 2);
    PostMessage(TWinControl(Control).Handle, WM_LBUTTONDOWN, 0, Longint(P));
    PostMessage(TWinControl(Control).Handle, WM_LBUTTONUP, 0,   Longint(P));
{$ENDIF}
    Sleep(ActionDelay);
  end;
  Application.ProcessMessages;
end;

function TGUITestCase.FindControl(const Name: string; Addr :Pointer): TControl;
begin
  Result := FindControl(Screen.ActiveForm, Name, Addr);
end;

function TGUITestCase.FindParentWinControl(Control: TControl): TWinControl;
begin
  while (Control <> nil) and not (Control is TWinControl) do
    Control := Control.Parent;
  Result := TWinControl(Control);
end;

function TGUITestCase.ShiftStateToKeyData(ShiftState :TShiftState):Longint;
const
  AltMask = $20000000;
{$IFDEF LINUX}
  VK_SHIFT = KEY_SHIFT;
  VK_CONTROL = KEY_CONTROL;
{$ENDIF}
begin
  Result := 0;
  if ssShift in ShiftState then
    Result := Result or VK_SHIFT;
  if ssCtrl in ShiftState then
    Result := Result or VK_CONTROL;
  if ssAlt in ShiftState then
    Result := Result or AltMask;
end;

procedure TGUITestCase.Click;
begin
  Click(Screen.ActiveControl);
end;

procedure TGUITestCase.Click(ControlName: string);
begin
  Click(FindControl(ControlName, CallerAddr));
end;

procedure TGUITestCase.Click(Control: TControl);
begin
  Assert(Control <> nil, 'No control');
  ClickLeftMouseButtonOn(Control);
end;

procedure TGUITestCase.EnterKey(Key: Word; const ShiftState: TShiftState);
begin
  EnterKeyInto(Screen.ActiveForm, Key, ShiftState);
end;

procedure TGUITestCase.EnterKeyInto(Control: TControl; Key: Word; const ShiftState: TShiftState);
{$IFDEF LINUX}
var
  E: QKeyEventH;
  S: WideString;
  state: integer;
{$ENDIF}
begin
  Assert(Control <> nil, 'No control');
  Control := FindParentWinControl(Control);
  if Control <> nil then
  begin
{$IFDEF LINUX}
{    if ssAlt in ShiftState then
    begin
      E := QKeyEvent_create(QEventType_KeyPress, Key_Alt, Key_Alt, 0, @S, false, 1);
      QApplication_sendEvent(TWidgetControl(Control).Handle, E);
      QKeyEvent_destroy(E);
    end; }
    if Key <= 255 then
      S := Char(Key)
    else
      S := '';
    if ssAlt in ShiftState then
      State := integer(ButtonState_AltButton)
    else
      State := 0;
    E := QKeyEvent_create(QEventType_KeyPress, Key, Key, State, @S, false, 1);
    QApplication_sendEvent(TWidgetControl(Control).Handle, E);
    QKeyEvent_destroy(E);
{$ELSE}
    PostMessage(TWinControl(Control).Handle, WM_KEYDOWN, Key, ShiftStateToKeyData(ShiftState));
{$ENDIF}
    Sleep(ActionDelay);
{$IFDEF LINUX}
    E := QKeyEvent_create(QEventType_KeyRelease, Key, Key, State, @S, false, 1);
    QApplication_sendEvent(TWidgetControl(Control).Handle, E);
    QKeyEvent_destroy(E);
{$ELSE}
    PostMessage(TWinControl(Control).Handle, WM_KEYUP,   Key, ShiftStateToKeyData(ShiftState));
{$ENDIF}
    Sleep(ActionDelay);
    Application.ProcessMessages;
  end;
end;

procedure TGUITestCase.EnterKeyInto(ControlName: string; Key: Word; const ShiftState: TShiftState);
begin
  EnterKeyInto(FindControl(ControlName, CallerAddr), Key, ShiftState);
end;

procedure TGUITestCase.EnterKey(Key: Char; const ShiftState: TShiftState);
begin
  EnterKey(Ord(Key), ShiftState);
end;

procedure TGUITestCase.EnterKeyInto(Control: TControl; Key: Char; const ShiftState: TShiftState);
begin
  EnterKeyInto(Control, Ord(Key), ShiftState);
end;

procedure TGUITestCase.EnterKeyInto(ControlName: string; Key: Char; const ShiftState: TShiftState);
begin
  EnterKeyInto(ControlName, Ord(Key), ShiftState);
end;

procedure TGUITestCase.EnterText(Text: string);
begin
  EnterTextInto(GetFocused, Text);
end;

procedure TGUITestCase.EnterTextInto(ControlName, Text: string);
begin
  EnterTextInto(FindControl(ControlName, CallerAddr), Text);
end;

procedure TGUITestCase.EnterTextInto(Control: TControl; Text: string);
var
  i :Integer;
begin
  Assert(Control <> nil, 'No control');
  Control := FindParentWinControl(Control);
  if Control <> nil then
  begin
    for i := 1 to Length(Text) do
    begin
{$IFDEF LINUX}
      //* NOT YET IN KYLIX *//
{$ELSE}
      PostMessage(TWinControl(Control).Handle, WM_CHAR, Ord(Text[i]), 0);
{$ENDIF}
      Sleep(ActionDelay);
    end;
  end;
  Application.ProcessMessages;
end;

procedure TGUITestCase.Show(OnOff: boolean);
begin
  Show(GUI, OnOff);
end;

procedure TGUITestCase.Show(ControlName: string; OnOff: boolean);
begin                 
  Show(FindControl(ControlName, CallerAddr), OnOff);
end;

procedure TGUITestCase.Show(Control: TControl; OnOff: boolean);
begin
  Assert(Control <> nil);
  Control.Visible := OnOff;
{$IFDEF LINUX}
  if Control is TCustomForm then
    (Control as TCustomForm).SetFocusedControl(Control as TWidgetControl);
{$ENDIF}
  Assert(Control.Visible = OnOff);
  Application.ProcessMessages;
  Sleep(ActionDelay);
end;

procedure TGUITestCase.Hide;
begin
  Screen.ActiveForm.Visible := false;
end;

procedure TGUITestCase.Hide(ControlName: string);
begin
  Show(ControlName, false);
end;

procedure TGUITestCase.Hide(Control: TControl);
begin
  Show(Control, false);
end;

procedure TGUITestCase.Tab(n: Integer);
{$IFDEF LINUX}
const
  VK_TAB = KEY_TAB;
{$ENDIF}
var
  i :Integer;
  s :TShiftState;
begin
  s := [];
  if n < 0 then
  begin
    s := [ssShift];
    n := -n;
  end;

  for i := 1 to n do
    EnterKey(VK_TAB);

  Application.ProcessMessages;
  Sleep(ActionDelay);
end;

function TGUITestCase.GetFocused: TControl;
begin
  Result := Screen.ActiveControl;
end;

procedure TGUITestCase.CheckTabTo(Control: TControl; Addr :Pointer = nil);
var
  i :Integer;
begin
  if Addr = nil then
    Addr := CallerAddr;

  if not (Control is TWinControl) then
     Fail(
        Format('%s: Expected a TWinControl, but %s is a %s',
               [Control.Name, Control.ClassName]),
               Addr
        );
  if not TWinControl(Control).CanFocus then
      Fail(
        Format('Control %s:%s cannot focus', [Control.Name, Control.ClassName]),
        Addr
        );

  for i := 1 to Screen.ActiveForm.ComponentCount do
  begin
     if GetFocused = Control then
       EXIT;
     Tab;
  end;
  Fail(Format('%s: Could not Tab to control "%s"', [Control.Name]), Addr);
end;


procedure TGUITestCase.CheckFocused(Control: TControl; Addr :Pointer);
var
  F :TControl;
begin
  Assert(Control <> nil, 'No control');

  if Addr = nil then
    Addr := CallerAddr;

  if not (Control is TWinControl) then
    Fail(
        Format('Expected a TWinControl, but %s is a %s',
               [Control.Name, Control.ClassName]),
        Addr
        );
  if not TWinControl(Control).CanFocus then
     Fail(
        Format('Control %s cannot focus', [Control.ClassName]),
        Addr
        );
  if (Control.Owner <> nil) and (Control.Owner is TCustomForm) then
    F := TCustomForm(Control.Owner).ActiveControl
  else
    F := GetFocused;
  if  F <> Control then
  begin
    if F <> nil then
      Fail(Format('Expected control %s to have focus, but %s had it.', [Control.Name, F.Name]), Addr)
    else
      Fail(Format('Expected control %s to have focus', [Control.Name]), Addr);
  end
end;

procedure TGUITestCase.CheckFocused(ControlName: string);
begin
  CheckFocused(FindControl(ControlName, CallerAddr), CallerAddr);
end;

procedure TGUITestCase.CheckTabTo(ControlName: string);
begin
  CheckTabTo(FindControl(ControlName, CallerAddr), CallerAddr);
end;

procedure TGUITestCase.CheckEnabled(Control: TControl; Addr :Pointer = nil);
begin
  if not Control.Enabled then
      Fail(Format('Expected control %s to be enabled', [Control.Name]), CallerAddr);
end;

procedure TGUITestCase.CheckEnabled(ControlName: string);
begin
  CheckEnabled(FindControl(ControlName, CallerAddr), CallerAddr);
end;

procedure TGUITestCase.SetFocus(Control: TControl; Addr: Pointer);
begin
  if Addr = nil then
    Addr := CallerAddr;

  if not (Control is TWinControl) then
     Fail(
        Format('%s: Expected a TWinControl, but %s is a %s',
               [Control.Name, Control.ClassName]),
               Addr
        );
  if not TWinControl(Control).CanFocus then
      Fail(
        Format('Control %s:%s cannot focus', [Control.Name, Control.ClassName]),
        Addr
        );
  TWinControl(Control).SetFocus;
end;

procedure TGUITestCase.SetFocus(ControlName: string);
begin
  SetFocus(FindControl(ControlName, CallerAddr), CallerAddr);
end;

procedure TGUITestCase.CheckVisible(Control: TControl; Addr: Pointer);
begin
  if not Control.Visible then
      Fail(Format('Expected control %s to be visible', [Control.Name]), CallerAddr);
end;

procedure TGUITestCase.CheckVisible(ControlName: string);
begin
  CheckVisible(FindControl(ControlName, CallerAddr), CallerAddr);
end;

procedure TGUITestCase.CheckVisible;
begin
  CheckVisible(GUI, CallerAddr);
end;

end.
