-module(test).
-export([start/0, stop/0]).


start()->
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
  io:format("[Test] Added 'b' to 'c'~n", []),

  broadcast_update([a, b, c]).

broadcast_update(ProcessList)->
  lists:map(fun(Name) -> Name ! broadcast, timer:sleep(1000) end, ProcessList),
  lists:map(fun(Name) -> Name ! update, timer:sleep(1000) end, ProcessList).


stop() ->
  lists:map(fun(Name) -> Name ! stop, timer:sleep(1000) end, [a,b,c]).