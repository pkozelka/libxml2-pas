UNIT MicroTime;

(*
    Provides time values with a resolution of better than
    a microsecond.

    Works on Pentium and later. Reported to work with 486.
*)



interface


  FUNCTION TimeOK : BOOLEAN;
(* Call this to see if this unit can report times OK. *)


  FUNCTION CurrentTime : DOUBLE;
(* returns the elapsed time in seconds since the unit was started.

   To time some event, call this before the event starts, and
   again after the event ends. Subtract the times to get the elapsed
   time in seconds between the 2 events.

   Returns a negative value if there is a problem or if the
   time can't be read on the current system.
*)


  FUNCTION TimeResolution : DOUBLE;
(*  Returns the resolution of the timer used by this unit.
    If the resolution is 1 millisecond, then 0.001 is returned,
    and if 1 microsecond, then 1.0e-6, etc.
*)

  procedure StartTimer;

  function EndTime: double;

implementation


{$IFDEF WIN32}
USES
  windows,MMSystem;
{$ELSE}
USES
  sysutils,libc;
{$ENDIF}


{$IFDEF LINUX}
  type TLargeInteger = Extended;
  //type TLargeInteger = record
  //  case Integer of
  //  0: (
  //    LowPart: DWORD;
  //    HighPart: Longint);
  //  1: (
  //    QuadPart: LONGLONG);
  //end;
{$ENDIF}

VAR

  timerOK : BOOLEAN;                (* is this unit's timer OK? *)
  ticksPerSecond : TLargeInteger;
  spt : DOUBLE;                     (* seconds per tick *)
  startTime : TLargeInteger;        (* time when this unit started *)
  time: double;


FUNCTION TimeOK : BOOLEAN;
(* Call this to see if this unit can report times OK. *)

BEGIN  (* TimeOK  *)
  TimeOK := timerOK;
END;   (* TimeOK  *)





FUNCTION CurrentTime : DOUBLE;
(* returns the elapsed time in seconds since the unit was started.

   To time some event, call this before the event starts, and
   again after the event ends. Subtract the times to get the elapsed
   time in seconds between the 2 events.

   Returns a negative value if there is a problem or if the
   time can't be read on the current system.
*)
VAR
  t : TLargeInteger;

BEGIN  (* CurrentTime  *)
{$IFDEF WIN32}
  IF timerOK AND QueryPerformanceCounter( t ) THEN begin
{$ELSE}
  IF timerOK then begin
    //t:=(now());
    t:=clock();
{$ENDIF}
    result := (t - startTime) * spt;
  END ELSE
    result := -1.0;
END;   (* CurrentTime  *)

procedure StartTimer;
begin
  time:=CurrentTime;
end;

function EndTime: double;
begin
  EndTime:=CurrentTime-time;
end;

FUNCTION TimeResolution : DOUBLE;
(*  Returns the resolution of the timer used by this unit.
    If the resolution is 1 millisecond, then 0.001 is returned,
    and if 1 microsecond, then 1.0e-6, etc.
*)

BEGIN  (* TimeResolution  *)
  TimeResolution := spt;
END;   (* TimeResolution  *)



PROCEDURE InitTimeValues;

BEGIN  (* InitTimeValues *)
{$IFDEF WIN32}
  timerOK := FALSE;
  IF (QueryPerformanceFrequency( ticksPerSecond )) AND
     ( ticksPerSecond > 1 ) THEN
    BEGIN
      spt := 1.0 / ticksPerSecond;
      IF QueryPerformanceCounter( startTime ) THEN
        timerOK := TRUE;
    END;
{$ELSE}
  timerOK := true;
  spt:=1/CLOCKS_PER_SEC;
  ticksPerSecond:=CLOCKS_PER_SEC
{$ENDIF}
END;   (* InitTimeValues *)



INITIALIZATION

  BEGIN
    {$IFDEF WIN32}
      timeBeginPeriod( 1 );
    {$ENDIF}
    InitTimeValues;
  END;



FINALIZATION

  BEGIN
    {$IFDEF WIN32}
      timeEndPeriod( 1 );
    {$ENDIF}
  END;


end.




