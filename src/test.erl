-module(test).
-export([start/0, stop/0, get_all_statuses/0]).

processList()->[a,b,c].
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

  broadcast_update().

broadcast_update()->
  lists:map(fun(Name) -> Name ! broadcast, timer:sleep(1000) end, processList()),
  lists:map(fun(Name) -> Name ! update, timer:sleep(1000) end, processList()).

get_all_statuses()->
  lists:map(fun(Name) -> routy:get_status(Name), timer:sleep(1000) end, processList()).


stop() ->
  lists:map(fun(Name) -> Name ! stop, timer:sleep(1000) end, processList()).