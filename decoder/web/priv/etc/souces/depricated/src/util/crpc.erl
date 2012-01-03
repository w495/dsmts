-module(crpc).
-export([rpc/4, call/4]).

-include("../include/common.hrl").

rpc(Node, Module, Action, Param) ->
    case global:whereis_name(Node) of
        Pid when is_pid(Pid) ->
            call(Pid, Module, Action, Param);
        _ ->
            flog:error(?FMT("~p:~p no active ~p servers", [?MODULE, ?LINE, Node])),
            []
    end.

call(Pid, M, F, A) ->
    case gen_server:call(Pid, {apply, {M,F,A}}) of
        {ok, Res} ->
            flog:debug(?FMT("~p:~p success RPC call ~p:~p(~p) = ok~n~p~n", [?MODULE, ?LINE, M,F,A, Res])),
            Res;
        Exc ->
            flog:error(?FMT("~p:~p exception RPC call ~p:~p(~p) = ~p~n", [?MODULE, ?LINE, M,F,A, Exc])),
            []
    end.

