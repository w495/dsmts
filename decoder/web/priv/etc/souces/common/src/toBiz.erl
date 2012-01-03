-module(toBiz).
-export([call/4, daoCall/5, daoCall/4]).


mkErrorJson({unexpected, E}) ->
    io:format("Unexpected error: ~p~n", [E]),
    {struct, [{<<"ERROR">>, {struct, [{<<"type">>, <<"unexpected">>}, {<<"info">>, <<"unexpected">>}]}}]};
mkErrorJson({Etype, Einfo}) ->
    io:format("Queue error: ~p~n", [Einfo]),
    {struct, [{<<"ERROR">>, {struct, [{<<"type">>, Etype}, {<<"info">>, list_to_binary(Einfo)}]}}]}.

call(Biz, Module, Function, Param) ->
    crpc:call({biz_srv, Biz}, Module, Function, Param).

daoCall(Biz, Module, Function, Param, JsonRetName) ->
    case call(Biz, Module, Function, Param) of
        {ok, Vals} -> Res = db2json:encode(Vals, JsonRetName);
        ok -> Res = {struct, [{<<"result">>, ok}]};
        {retVal, ok} -> Res = {struct, [{<<"result">>, ok}]};
%        {retVal, RVal} -> {struct, [{<<"result">>, RVal);
        {error, E} -> Res = mkErrorJson(E)
    end,
    Res.

daoCall(Biz, Module, Function, Param) ->
    case call(Biz, Module, Function, Param) of
        {ok, Vals} -> Res = db2json:encode(Vals);
        ok -> Res = {struct, [{<<"result">>, ok}]};
        {retVal, ok} -> Res = {struct, [{<<"result">>, ok}]};
        {error, E} -> Res = mkErrorJson(E)
    end,
    Res.

