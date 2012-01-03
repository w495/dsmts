-module(dao).

-include("../include/common.hrl").
-include_lib("epgsql/include/pgsql.hrl").

-compile(export_all).

mkErrorJson({unexpected, E}) ->
    io:format("Unexpected error: ~p~n", [E]),
    {struct, [{<<"ERROR">>, {struct, [{<<"type">>, <<"unexpected">>}, {<<"info">>, <<"unexpected">>}]}}]};
mkErrorJson({Etype, Einfo}) ->
    io:format("Queue error: ~p~n", [Einfo]),
    {struct, [{<<"ERROR">>, {struct, [{<<"type">>, Etype}, {<<"info">>, list_to_binary(Einfo)}]}}]}.

%call(Module, Function, Param) ->
%    crpc:call({biz_srv, config:get(biz_srv, biz@localhost)}, Module, Function, Param).

daoCall(Module, Function, undefined, JsonRetName) ->
    case Module:Function() of
        {ok, Vals} -> Res = db2json:encode(Vals, JsonRetName);
        ok -> Res = {struct, [{<<"result">>, ok}]};
        {retVal, ok} -> Res = {struct, [{<<"result">>, ok}]};
        {error, E} -> Res = mkErrorJson(E)
    end,
    Res;
    
daoCall(Module, Function, Param, JsonRetName) ->
    case Module:Function(Param) of
        {ok, Vals} -> Res = db2json:encode(Vals, JsonRetName);
        ok -> Res = {struct, [{<<"result">>, ok}]};
        {retVal, ok} -> Res = {struct, [{<<"result">>, ok}]};
%        {retVal, RVal} -> {struct, [{<<"result">>, RVal);
        {error, E} -> Res = mkErrorJson(E)
    end,
    Res.

daoCall(Module, Function, Param) ->
    
    case Module:Function(Param) of
        {ok, Vals} -> Res = db2json:encode(Vals);
        ok -> Res = {struct, [{<<"result">>, ok}]};
        {retVal, ok} -> Res = {struct, [{<<"result">>, ok}]};
        {error, E} -> io:format("$~p~n", [E]), Res = mkErrorJson(E)
    end,
    Res.
                                                                                                            

pg2rs({ok, _, Vals}, RecordName) ->
    [list_to_tuple([RecordName | tuple_to_list(X)]) || X <- Vals];
pg2rs(Vals, RecordName) ->
    [list_to_tuple([RecordName | tuple_to_list(X)]) || X <- Vals].

stripRs(Vals) when is_list(Vals)->
    stripRs(Vals, []);
stripRs(Val) when is_tuple(Val) ->
    [_|T]=tuple_to_list(Val),
    T.

stripRs([Vh|Vt], Ret) ->
    [_|T]=tuple_to_list(Vh),
    stripRs(Vt, [list_to_tuple(T)|Ret]);
stripRs([], Ret) ->
    Ret.

collectWhereParams(Params) ->
    collectWhereParams([], [], Params).

collectWhereParams(Where, Params, [{Val}|T]) when is_list(Val) ->
    collectWhereParams([Val|Where], Params, T);
collectWhereParams(Where, Params, [{Key, Val}|T]) ->
    collectWhereParams(Where, Params, [{Key, "=", Val}|T]);
%    collectWhereParams([lists:append([Key, " = $", utils:to_list(length(Params) + 1)])|Where], [Val | Params], T);
collectWhereParams(Where, Params, [{Key, Action, Val}|T]) ->
    collectWhereParams([lists:append([Key, " ", Action, " $", utils:to_list(length(Params) + 1)])|Where], [Val | Params], T);
collectWhereParams(Where, Params, []) when length(Where) > 0->
    {?FMT(" WHERE ~s", [string:join(lists:reverse(Where), " and ")]), lists:reverse(Params)};
collectWhereParams(_, _, []) ->
    {";", []}.


%processPGRet({pgcp_error, {error, {badmatch, {error, #error{code=ECodeBin, message=Msg}}}}}) ->
%    case ECodeBin of
%        <<"23502">> ->
%            try
%                {ok, RE} = re:compile("\"(.+)\""),
%                {match, [_, C | _]} = re:run(Msg, RE, [{capture, all, list}]),
%                {error, {not_null, C}}
%            catch
%                E:R ->
%                    io:format("processPGRet ERROR: ~p - ~p~n", [E, R]),
%                    {error, {unknown, Msg}}
%            end;
%        <<"23505">> ->
%            try
%                {ok, RE} = re:compile("\".*_([^_]?.+)_key\""),
%                {match, [_, C | _]} = re:run(Msg, RE, [{capture, all, list}]),
%                {error, {not_unique, C}}
%            catch
%                E:R ->
%                    io:format("processPGRet ERROR: ~p - ~p~n", [E, R]),
%                    {error, {unknown, binary_to_list(Msg)}}
%            end;
%        _ ->
%            {error, {unknown, binary_to_list(Msg)}}
%    end;
%processPGRet({pgcp_error, {error, {badmatch, E}}}) ->
%    {error, {unexpected, E}};
%processPGRet(_) ->
%    ok.
%
%processPGRet(Ret, RecordName) ->
%    case processPGRet(Ret) of
%        ok -> {ok, pg2rs(Ret, RecordName)};
%        Val -> Val
%    end.

toType(null, _Type) ->
    null;
toType(V, int4) ->
    utils:to_int(V);
toType(V, varchar) ->
    binary_to_list(V);
toType(V, text) ->
    binary_to_list(V);
toType(V, Type) ->
%    io:format("DAO: undefined type: ~p.~n", [Type]),
    V.


nameColumns([{column, Name, Type, _P3, _P4, _P5}|Ct], [V|Vt], Ret) ->
    nameColumns(Ct, Vt, [{binary_to_list(Name), toType(V, Type)}|Ret]);
nameColumns([], [], Ret) ->
    Ret;
nameColumns([], V, Ret) ->
    io:format("unexpected values: ~p~n", [V]),
    Ret;
nameColumns(C, [], Ret) ->
    io:format("unexpected columns: ~p~n", [C]),
    Ret.



mkProplist(Columns, [V|T], Ret) ->
    mkProplist(Columns, T, [nameColumns(Columns, tuple_to_list(V), [])|Ret]);
mkProplist(_C, [], Ret) ->
    Ret.

processPGRet2({return, Value}) ->
    {ok, Value};

% select sq & eq
processPGRet2({ok, Columns, Vals}) ->
    {ok, mkProplist(Columns, Vals, [])};
% update sq & eq

processPGRet2({ok, _Count}) ->
    ok;
    
% insert sq & eq
processPGRet2({ok, _Count, _Columns, _Rows}) ->
    ok;

% ошибка сиквела - неожиданный возврат в функции дает ошибку ожидаемого возврата.
%processPGRet2({pgcp_error, {error, {badmatch, {error, #error{code=ECodeBin, message=Msg}}}}}) ->
processPGRet2({pgcp_error, E}) ->
    processPGErrorRet2(E);
processPGRet2({error, E}) ->
    processPGErrorRet2(E);
processPGRet2(V) ->
    {retVal, V}.

processPGErrorRet2({error, E}) ->
    processPGErrorRet2(E);
processPGErrorRet2({badmatch, E}) ->
    processPGErrorRet2(E);
processPGErrorRet2(#error{code=ECodeBin, message=Msg}) ->
    case ECodeBin of
        <<"23502">> ->
            try
                {ok, RE} = re:compile("\"(.+)\""),
                {match, [_, C | _]} = re:run(Msg, RE, [{capture, all, list}]),
                {error, {not_null, C}}
            catch
                E:R ->
                    io:format("processPGRet ERROR: ~p - ~p~n", [E, R]),
                    {error, {unknown, Msg}}
            end;
        <<"23505">> ->
            try
                {ok, RE} = re:compile("\".*_([^_]?.+)_key\""),
                {match, [_, C | _]} = re:run(Msg, RE, [{capture, all, list}]),
                {error, {not_unique, C}}
            catch
                E:R ->
                    io:format("processPGRet ERROR: ~p - ~p~n", [E, R]),
                    {error, {unknown, binary_to_list(Msg)}}
            end;
        _ ->
            {error, {unknown, binary_to_list(Msg)}}
    end;
processPGErrorRet2(E) ->
    {error, {unexpected, E}}.

% cover for logictics db connection pool
withConnectionMchs(Fun) ->
    pgConPool:withConnection(Fun, config:get(geo_db_name, "mchs")).
    %pgConPool:withConnection(Fun, config:get(logistics_db_name, "logistics")).
withTransactionMchs(Fun) ->
    pgConPool:withTransaction(Fun, config:get(geo_db_name, "mchs")).
    %pgConPool:withTransaction(Fun, config:get(logistics_db_name, "logistics")).

simple(Q) ->
    dao:processPGRet2(dao:withConnectionMchs(fun(Con) -> pgsql:equery(Con, Q) end)).

simple(Q, Params) ->
    dao:processPGRet2(dao:withConnectionMchs(fun(Con) -> pgsql:equery(Con, Q, Params) end)).

