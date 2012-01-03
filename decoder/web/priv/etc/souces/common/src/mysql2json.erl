-module(mysql2json).
-export([encode/1, encode/2]).
-include("../include/common.hrl").


encode([R]) ->
    {struct, nameFields(R)}.

encode(Rows, JsonObjName) when is_list(Rows)->
    Res = [{struct, nameFields(R)} || R <- Rows],
    mountJson(Res, JsonObjName);
encode([R], JsonObjName) ->
    mountJson({struct, nameFields(R)}, JsonObjName);
encode(Row, JsonObjName) ->
    mountJson(toBinary(Row), JsonObjName).

mountJson([_H|_T]=Res, JsonObjName) ->
    {struct, [{JsonObjName, Res}]};
mountJson([], JsonObjName) ->
    {struct, [{JsonObjName, <<"">>}]};
mountJson(Res, JsonObjName) ->
    {struct, [{JsonObjName, Res}]}.

nameFields([{Name, Val}|T]) ->
    [{Name, encodeValue(Val)}|nameFields(T)];
nameFields([])->
    [].

encodeValue(V) when is_tuple(V) ->
    R = string:join([[encodeValue(Vi)] || Vi <- tuple_to_list(V)], " "),
    toBinary(R);
encodeValue(V) ->
    toBinary(V).

toBinary(V) when is_list(V) ->
    list_to_binary(V);
toBinary(V) when is_atom(V), V =:= null ->
    toBinary("");
toBinary(V) when is_atom(V) ->
    list_to_binary(atom_to_list(V));
toBinary(V) when is_integer(V) ->
    list_to_binary(integer_to_list(V));
toBinary(V) when is_float(V) ->
    list_to_binary(float_to_list(V));
toBinary(V) when is_binary(V) ->
    V.
%    list_to_binary(lists:flatten([erlang:integer_to_list(Val, 16) || Val <- binary_to_list(V)])).
