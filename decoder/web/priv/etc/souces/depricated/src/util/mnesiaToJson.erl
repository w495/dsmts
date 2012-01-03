-module(mnesiaToJson).

-export([encode/3, serialize/2]).
-export([encodeArr/3]).

-include("../include/common.hrl").

-define(Q, $\").

encode(Rows, FieldNames, JsonObjName) when is_list(Rows) ->
    NameRow = fun([_Tabname|R], Fn) -> nameFields(R, Fn) end,
    Res = [{struct, NameRow(tuple_to_list(Row), FieldNames)} || Row <- Rows],
    mountJson(Res, JsonObjName);
encode(Row, FieldNames, JsonObjName) when is_tuple(Row) ->
    NameRow = fun([_Tabname|R], Fn) -> nameFields(R, Fn) end,
    {struct, NameRow(tuple_to_list(Row), FieldNames)};
%    Res = {struct, NameRow(tuple_to_list(Row), FieldNames)},
%    mountJson(Res, JsonObjName);
encode(Row, _FieldNames, JsonObjName) ->
    mountJson(toBinary(Row), JsonObjName).


encodeArr(Arr, Fields, JsonObjName) ->
    FieldsBin = [list_to_binary(atom_to_list(Field)) || Field <- Fields],
    Res = encodeArr_impl(Arr, FieldsBin, [$], $}]),
    [${, encode_string(JsonObjName), $:, $[ | Res ].

serialize(Rows, FieldNames) when is_list(Rows) ->
    NameRow = fun([_Tabname|R], Fn) -> nameFields(R, Fn) end,
    Res = [NameRow(tuple_to_list(Row), FieldNames) || Row <- Rows],
    Res;
serialize(Row, FieldNames) when is_tuple(Row) ->
    NameRow = fun([_Tabname|R], Fn) -> nameFields(R, Fn) end,
    Res = NameRow(tuple_to_list(Row), FieldNames),
    Res;
serialize(Row, _FieldNames) ->
    Row.


mountJson([_H|_T]=Res, JsonObjName) ->
    {struct, [{JsonObjName, Res}]};
mountJson([], JsonObjName) ->
    {struct, [{JsonObjName, <<"">>}]};
mountJson(Res, JsonObjName) ->
    {struct, [{JsonObjName, Res}]}.

nameFields([Hr|Tr], [Hn|Tn]) ->
    [{Hn, encodeValue(Hr)}|nameFields(Tr, Tn)];
nameFields([],[])->
    [];
nameFields(A, []) ->
    flog:error(?FMT("~p:~p not enough names for db rows ~p",[?MODULE, ?LINE, A])),
    [];
nameFields([], A) ->
    flog:error(?FMT("~p:~p not enough db fields for record names ~p",[?MODULE, ?LINE, A])),
    [].

encodeValue(V) when is_tuple(V) ->
    R = string:join([[encodeValue(Vi)] || Vi <- tuple_to_list(V)], " "),
    toBinary(R);
encodeValue(V) ->
    toBinary(V).

toBinary(V) when is_list(V) ->
    list_to_binary(V);
toBinary(V) when is_atom(V) ->
    list_to_binary(atom_to_list(V));
toBinary(V) when is_integer(V) ->
    list_to_binary(integer_to_list(V));
toBinary(V) when is_float(V) ->
    list_to_binary(float_to_list(V));
toBinary(V) when is_binary(V) ->
    list_to_binary(lists:flatten([erlang:integer_to_list(Val, 16) || Val <- binary_to_list(V)])).

%%%
encodeArr_impl([Rows|T], Flds, Acc) ->
    encodeArr_impl(T, Flds, encode_rows(Rows, Flds, Acc));
encodeArr_impl([], _, [[$, | Data] | Data1]) ->
    [Data|Data1];
encodeArr_impl([], _, Acc) ->
    Acc.

encode_rows([Row|T], Flds, Acc) ->
    [_TabName | Values] = tuple_to_list(Row),
    Data = encode_row(Flds, Values, [$}]),
    encode_rows(T, Flds, [Data | Acc]);
encode_rows([], _, Acc) ->
    Acc.

encode_row([F], [D|_], Acc) -> %% последнее поле -> не ставим запятую
    [$,, ${, encode_string(F), $:, ?Q, encodeValue(D), ?Q | Acc];
encode_row([FH|FT], [DH|DT], Acc) ->
    encode_row(FT, DT, [$,, encode_string(FH), $:, ?Q,encodeValue(DH),?Q | Acc]);
encode_row([],_,Acc) ->
    Acc.

encode_string(B) when is_binary(B) ->
    [?Q, B, ?Q];
encode_string(A) when is_atom(A) ->
    encode_string(utils:to_list(A));
encode_string(I) when is_integer(I) ->
    [?Q, integer_to_list(I), ?Q];
encode_string(L) when is_list(L) ->
    encode_string(list_to_binary(L)).
