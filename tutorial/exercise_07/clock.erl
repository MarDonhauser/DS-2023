-module(clock).
-export([start/1, get/1, clock_process/2, loop/3, enable_trace/1, disable_trace/1]).

clock_process(Speed, Ref) ->
    clock_loop(0, Speed, true, Ref, true).

clock_loop(Time, Speed, Running, Ref, TraceEnabled) ->
    receive
        {set, Value} ->
            log_trace(TraceEnabled, "Setting time to ~p", [Value]),
            clock_loop(Value, Speed, Running, Ref, TraceEnabled);
        {get, Pid} ->
            log_trace(TraceEnabled, "Sending time ~p to ~p", [Time, Pid]),
            Pid ! {clock, Time},
            clock_loop(Time, Speed, Running, Ref, TraceEnabled);
        pause ->
            log_trace(TraceEnabled, "Pausing clock", []),
            clock_loop(Time, Speed, false, Ref, TraceEnabled);
        resume ->
            log_trace(TraceEnabled, "Resuming clock", []),
            clock_loop(Time, Speed, true, Ref, TraceEnabled);
        stop ->
            log_trace(TraceEnabled, "Stopping clock", []),
            ok;
        {tick, Ref} ->
            NewTime = if Running -> Time + 1; true -> Time end,
            log_trace(TraceEnabled, "Tick: ~p", [NewTime]),
            clock_loop(NewTime, Speed, Running, Ref, TraceEnabled);
        {trace, enable} ->
            clock_loop(Time, Speed, Running, Ref, true);
        {trace, disable} ->
            clock_loop(Time, Speed, Running, Ref, false)
    end.


log_trace(true, Format, Data) ->
    io:format(Format ++ "\n", Data);
log_trace(false, _Format, _Data) ->
    ok.

enable_trace(Pid) ->
    Pid ! {trace, enable}.

disable_trace(Pid) ->
    Pid ! {trace, disable}.


get(ClockPid) ->
    ClockPid ! {get, self()},
    receive
        {clock, Time} ->
            Time
    end.


loop(ClockPid, Speed, Ref) ->
    timer:sleep(Speed),
    ClockPid ! {tick, Ref},
    loop(ClockPid, Speed, Ref).



start(Speed) ->
    Ref = make_ref(),
    ClockPid = spawn(?MODULE, clock_process, [Speed, Ref]),
    spawn(?MODULE, loop, [ClockPid, Speed, Ref]),
    ClockPid.



