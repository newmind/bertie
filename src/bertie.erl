-module(bertie).
-export([start/0]).

start() ->
    Handle = bitcask:open("bertie database", [read_write]),
    N = fetch(Handle),
    store(Handle, N+1),
    io:format("Bertie has been run ~p times~n", [N]),
    bitcask:close(Handle),
    init:stop().

store(Handle, N) ->
    bitcask:put(Handle, <<"bertie_executions">>, term_to_binary(N)).

fetch(Handle) ->
    case bitcask:get(Handle, <<"bertie_executions">>) of
        now_found -> 1;
        {ok, Bin} -> binary_to_term(Bin);
        _ -> 1
    end.

