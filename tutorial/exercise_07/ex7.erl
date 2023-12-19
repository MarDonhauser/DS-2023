-module(ex7).
-export([convert/2, maxitem/1, diff/3]).

convert(Amount, Unit) -> 
    case Unit of
        inch -> 
            {cm, Amount * 2.54};
        cm -> 
            {inch, Amount * 0.39};
        _ -> 
            {error, "Unit not found"}
    end.

maxitem([]) -> 0;
maxitem([First | Rest]) ->
    io:format("Start der Rekursion mit: ~p~n", [First]),
    maxitem(Rest, First).

maxitem([], Max) ->
    io:format("Ende der Rekursion. Maximaler Wert: ~p~n", [Max]),
    Max;
maxitem([Head | Tail], Max) ->
    NewMax = if
        Head > Max ->
            io:format("Neues Maximum gefunden: ~p (früheres Maximum war: ~p)~n", [Head, Max]),
            Head;
        true ->
            io:format("Beibehalten des aktuellen Maximums: ~p (aktuelles Element: ~p)~n", [Max, Head]),
            Max
    end,
    maxitem(Tail, NewMax).


diff(F,X,H) ->
    (F(X+H) - F(X-H)) / (2 * H).



