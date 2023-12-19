% Exercise 8: Filters and Pipelines in Erlang

-module(everyOther).
-export([echo/0, start/0, filter_echo/2]).

echo() ->
   receive
   	   stop -> ok;
   	   Msg -> io:format("Echo: ~p\n",[Msg]), echo()
   end.

filter_echo(Echo, Counter) ->
    receive
        {set_sender, Pid} ->
            collector(Pid, Collected);
        {filter, _} = Msg ->
            case Counter rem 2 of
                0 -> Echo ! Msg;
                _ -> ok
            end,
            filter_echo(Echo, Counter + 1);
        stop -> ok
    end.

start() ->
    Echo = spawn(?MODULE, echo,[]),
    Filter = spawn(?MODULE, filter_echo,[Echo, 1]),
    
    P2 = Filter,
 
    P2!{filter,1},
    P2!{filter,2},
    P2!{filter,3},
    P2!{filter,4},
    P2!{filter,5},

    ok.
