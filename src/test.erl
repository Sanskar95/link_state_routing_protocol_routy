-module(test).
-export([start/0, stop/0, get_all_statuses/0]).

processList()->[r1,r2,r3,r4, r5, r6].
start()->
  routy:start(r1,a),
  io:format("[Test] Started router 'a'~n", []),
  routy:start(r2,b),
  io:format("[Test] Started router 'b'~n", []),
  routy:start(r3,c),
  io:format("[Test] Started router 'c'~n", []),
  routy:start(r4,d),
  io:format("[Test] Started router 'c'~n", []),
  routy:start(r5,e),
  io:format("[Test] Started router 'c'~n", []),
  routy:start(r6,f),
  io:format("[Test] Started router 'c'~n", []),


  r1 ! {add, b, {r2, node()}},
  io:format("[Test] Added 'a' to 'b'~n", []),
  r2 ! {add, c, {r3, node()}},
  io:format("[Test] Added 'b' to 'c'~n", []),
  r3 ! {add, d, {r4, node()}},
  io:format("[Test] Added 'b' to 'c'~n", []),
  r4 ! {add, e, {r5, node()}},
  io:format("[Test] Added 'b' to 'c'~n", []),
  r5 ! {add, a, {r1, node()}},
  io:format("[Test] Added 'b' to 'c'~n", []),
  r5 ! {add, f, {r6, node()}},
  r6! {add, e, {r5, node()}},

  broadcast_update().

broadcast_update()->
  lists:map(fun(Name) -> Name ! broadcast, timer:sleep(1000) end, processList()),
  lists:map(fun(Name) -> Name ! update, timer:sleep(1000) end, processList()).

get_all_statuses()->
  lists:map(fun(Name) -> routy:get_status(Name), timer:sleep(1000) end, processList()).


stop() ->
  lists:map(fun(Name) -> Name ! stop, timer:sleep(1000) end, processList()).
