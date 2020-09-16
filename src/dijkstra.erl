-module(dijkstra).

-export([table/2, route/2]).

table(Gateways, Map) ->
	  io:format("GW and map: ~w~p~n", [Gateways, Map]),
    NodesList = lists:foldl( fun(X, Acc) ->
			case lists:member(X, Gateways) of
				true ->
					Temp= [{X, 0, X}],
					lists:append(Temp, Acc);
				false ->
					Temp= [{X, inf, unknown} ],
					lists:append(Temp, Acc)
			end
														 end, [], map:all_nodes(Map)),
    Sorted = lists:keysort(2, NodesList),
    iterate(Sorted, Map, []).


route(Node, Table) ->
    case lists:keyfind(Node, 1, Table) of
	{Node, Gw} ->
		io:format("Routing table is ~p~n", [Table]),
		io:format("GW and Node: ~w ~p~n", [Gw, Node]),
	    {ok, Gw};
	false ->
	    notfound
    end.

%% private functions
update(Node, N, Gw, Nodes) ->
	M =  entry(Node, Nodes),
	if
		N < M ->
			replace(Node, N, Gw, Nodes);
		true ->
			Nodes
	end.

iterate([], _Map, Table) ->
    Table;
iterate([{_, inf, _} | _Rest], _Map, Table) ->
    Table;
iterate([{Node, Hops, Gw} | Sorted], Map, Table) ->
    case map:reachable(Node, Map) of
	[] ->
	    iterate(Sorted, Map, [{Node, Gw} | Table]);
	Nodes ->
	    NewSorted = lists:foldl(fun(X, Acc) ->
					    update(X, Hops + 1, Gw, Acc)
				    end,
				    Sorted, Nodes),
	    NewTable = [{Node, Gw} | Table],
	    iterate(NewSorted, Map, NewTable)
    end.

entry(Node, SortedList) ->
    case lists:keyfind(Node, 1, SortedList) of
	{Node, L,_} ->
	    L;
	false ->
	    0
    end.

replace(Node, N , Gateway, Sorted) ->
    case lists:keyfind(Node, 1, Sorted) of
	{Node, _, _Gateway} ->
	    TempList = lists:keyreplace(Node, 1, Sorted, {Node, N, Gateway}),
	    lists:keysort(2, TempList);
	false ->
	    Sorted
    end.

