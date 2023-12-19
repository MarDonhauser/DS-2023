% Exercise 8: Filters and Pipelines in Erlang

-module(combined).
-export([echo/0, start/0, collector/1, filter_echo/2]).

echo() ->
   receive
   	   stop -> ok;
   	   Msg -> io:format("Echo: ~p\n",[Msg]), echo()
   end.

filter_echo(Collector, Counter) ->
    receive
        {set_sender, Pid} ->
            collector(Pid, Collector);
        {filter, _} = Msg ->
            case Counter rem 2 of
                0 -> Collector ! Msg;
                _ -> ok
            end,
            filter_echo(Collector, Counter + 1);
        stop -> ok
    end.

collector(TargetPid) ->
    collector(TargetPid, []).

collector(TargetPid, Collected) ->
    receive
        {set_sender, Pid} ->
            collector(Pid, Collected);
        reset ->
            collector(TargetPid, []);
        {filter, Msg} ->
            NewList = Collected ++ [Msg],
            TargetPid ! NewList,
            collector(TargetPid, NewList)
    end.

start() ->
    Echo = spawn(?MODULE, echo,[]),
    CollectorPid = spawn(?MODULE, collector,[Echo]),
    Filter = spawn(?MODULE, filter_echo,[CollectorPid, 1]),
    
    
    P2 = Filter,
 
    P2!{filter,120},
    P2!{filter,109},
    P2!{filter,150},
    P2!{filter,101},
    P2!{filter,155},
    P2!{filter,114},
    P2!{filter,189},
    P2!{filter,114},
    P2!{filter,27},
    P2!{filter,121},
    P2!{filter,68},
    P2!{filter,32},
    P2!{filter,198},
    P2!{filter,99},
    P2!{filter,33},
    P2!{filter,104},
    P2!{filter,164},
    P2!{filter,114},
    P2!{filter,212},
    P2!{filter,105},
    P2!{filter,194},
    P2!{filter,115},
    P2!{filter,24},
    P2!{filter,116},
    P2!{filter,148},
    P2!{filter,109},
    P2!{filter,173},
    P2!{filter,97},
    P2!{filter,8},
    P2!{filter,115},
    P2!{filter,191},
    P2!{filter,33},


    ok.
