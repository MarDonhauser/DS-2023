-module(timertick).
-export([start/1, set_timer/3, timer_process/1]).


start(Speed) ->
    spawn(?MODULE, timer_process, [Speed]).

set_timer(TimerPid, Ticks, Callback) ->
    TimerPid ! {set_timer, Ticks, Callback}.

timer_process(Speed) ->
    timer_loop(Speed, 0, fun() -> io:format("Ich bin eine Funktion!~n") end
, 100).

timer_loop(Speed, Count, Callback, TargetTicks) ->
    receive
        {set_timer, Ticks, NewCallback} ->
            timer_loop(Speed, 0, NewCallback, Ticks);
        tick ->
            NewCount = Count + 1,
            io:format("Tick: ~p~n", [NewCount]),
            case NewCount of
                TargetTicks ->
                    if
                        is_function(Callback) ->
                            Callback(),
                            io:format("Timer finished after ~p ticks. Timer process terminating.~n", [TargetTicks]);
                        true ->
                            io:format("No valid callback provided. Timer process terminating.~n")
                    end;
                _ ->
                    timer_loop(Speed, NewCount, Callback, TargetTicks)
            end
    after Speed ->
        self() ! tick,
        timer_loop(Speed, Count, Callback, TargetTicks)
    end.