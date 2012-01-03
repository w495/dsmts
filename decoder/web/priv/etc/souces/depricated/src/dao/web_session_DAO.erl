-module(web_session_DAO).
-export([create/5, get/1, remove/1, removeExpired/0]).
-import(db, [read/2, write/1]).
-include("../include/web_session.hrl").
-include("../include/common.hrl").
-include("../../common/include/customer.hrl").
-include_lib("stdlib/include/qlc.hrl").

create(UID, Id, Login, Permissions, PasswordHash) ->
    io:format("~p~p~p~p~p", [UID, Id, Login, Permissions, PasswordHash]),
    Row = #web_session{login=utils:to_list(Login),customer_id=Id,permissions=Permissions,uid=UID, time=erlang:localtime(),password_hash=PasswordHash},
    F = fun() -> mnesia:write(?SESSION_TABLE_NAME, Row, write) end,
    mnesia:transaction(F).
%    db:write(Row).

get(UID) ->
    db:read({?SESSION_TABLE_NAME, UID}).

remove(UID) ->
    db:delete({?SESSION_TABLE_NAME, UID}).

removeExpired() ->
    Curtime = calendar:datetime_to_gregorian_seconds(erlang:localtime()),
    F = fun() ->
        Q = qlc:q([X || X <- mnesia:table(?SESSION_TABLE_NAME), 
                Curtime - calendar:datetime_to_gregorian_seconds(X#web_session.time) > config:get(web_session_expire_timeout, 18000)]),
        S = qlc:e(Q),
        lists:foreach(fun(#web_session{uid = UID}) -> mnesia:delete({?SESSION_TABLE_NAME, UID}) end, S)
    end,
    db:transaction(F).
