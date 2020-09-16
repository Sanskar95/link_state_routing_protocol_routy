-module(test2).
-export([start_world/0, stop_world/0, connect_paris_berlin/0, start_triangle/0]).


start_triangle()->
  routy:start(a),
  io:format("[Test] Started router 'a'~n", []),
  routy:start(b),
  io:format("[Test] Started router 'b'~n", []),
  routy:start(c),
  io:format("[Test] Started router 'c'~n", []),

  a ! {add, b, {b, node()}},
  io:format("[Test] Added 'a' to 'b'~n", []),
  b ! {add, c, {c, node()}},
  io:format("[Test] Added 'b' to 'c'~n", []),
  c ! {add, a, {a, node()}},
  io:format("[Test] Added 'b' to 'c'~n", []).

broadcast_update(ProcessList)->
  lists:map(fun(Name) -> Name ! broadcast, timer:sleep(1000) end, ProcessList),
  lists:map(fun(Name) -> Name ! update, timer:sleep(1000) end, ProcessList).


stop_world() ->
  routy:stop(rome),
  routy:stop(paris),
  routy:stop(madrid),
  routy:stop(berlin).