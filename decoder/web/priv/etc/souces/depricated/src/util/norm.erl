-module(norm).
-compile(export_all).
-include("../include/common.hrl").


integer(Val) ->
    utils:to_integer(Val).

string(Val) ->
    utils:to_list(Val).


nullable([]) ->
    null;
nullable("null") ->
    null.

dateUnixtime(Val) ->
    {D, _} = utils:unixtime_to_localDatetime(utils:to_integer(Val)),
    D.

datetimeUnixtime(Val) ->
    utils:unixtime_to_localDatetime(utils:to_integer(Val)).

runSpec(Val, [[]|_T]) ->
    {done, Val};
runSpec(Val, [Spec|T]) ->
%    io:format("run spec ~p~n", [Spec]),
    try 
        {done, norm:Spec(Val)}
    catch _ : _ ->
        runSpec(Val, T)
    end;
runSpec(Val, []) ->
    {error, Val}.


extr(Data, Params) ->
    extr(Data, Params, []).

extr(Data, [{Key, Specs}|T], Ret) ->
    case proplists:get_value(Key, Data) of
        undefined -> throw({error, {"no param", Key}});
        Val ->
            case runSpec(Val, Specs) of
                {done, NVal} -> extr(Data, T, [NVal | Ret]);
                {error, _} -> throw({error, {"invalid specs", Key, Val, Specs}})
            end
    end;
extr(_Data, [], Ret) ->
    erlang:list_to_tuple(lists:reverse(Ret)).
