-module(collector).
-export([echo/0, start/0, collector/1]).

echo() ->
    receive
        stop -> ok;
        Msg -> io:format("Echo: ~p\n",[Msg]), echo()
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
    EchoPid = spawn(?MODULE, echo,[]),
    CollectorPid = spawn(?MODULE, collector,[EchoPid]),

    CollectorPid ! reset,
    CollectorPid ! {filter,1},
    CollectorPid ! {filter,b},
    CollectorPid ! {filter,3},

    ok.
