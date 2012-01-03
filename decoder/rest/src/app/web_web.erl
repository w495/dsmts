-module(web_web).
-author('author <author@example.com>').

-export([start/1, stop/0, loop/2]).
-include_lib("xmerl/include/xmerl.hrl").
-include("../include/common.hrl").


-include("../include/web.hrl").

-compile(export_all).

%% External API

start(Options) ->
    {DocRoot, Options1} = get_option(docroot, Options),
    Loop = fun (Req) ->
                   ?MODULE:loop(Req, DocRoot)
           end,
    mochiweb_http:start([{max, 1000000}, {name, ?MODULE}, {loop, Loop} | Options1]).

stop() ->
    io:format("~p: ~p got stop signal~n", [erlang:localtime(), ?MODULE]),
    supervisor:terminate_child(web_sup, ?MODULE),
    supervisor:delete_child(web_sup, ?MODULE).

start_controller(Module, Action, Req) ->
    flog:debug(?FMT("~p:~p 200 ~p REQUEST (~p) ~p:~p ~n", [?MODULE, ?LINE, Req:get(method), Req:get(path), Module, Action])),
    Exports = Module:module_info(exports),
    % % CALL BEFORE
    _NReq = bac_runner(Exports, call_before, Module, Req),
    % % CALL CONTROLLER
    Result = Module:Action(Req),
    % % CALL AFTER
    {_, NResult} = bac_runner(Exports, call_after, Module, {Req, Result}),
    Req:ok(NResult).

start_controller(Module, Action, Req, Param) ->
    flog:debug(?FMT("~p:~p 200 ~p REQUEST (~p) ~p:~p ~n", [?MODULE, ?LINE, Req:get(method), Req:get(path), Module, Action])),
    Exports = Module:module_info(exports),
    % % CALL BEFORE
    _NReq = bac_runner(Exports, call_before, Module, Req),
    % % CALL CONTROLLER
    Result = Module:Action(Req, Param),
    % % CALL AFTER
    {_, NResult} = bac_runner(Exports, call_after, Module, {Req, Result}),
    Req:ok(NResult).


bac_runner([{M, _}|T], Method, Module, Param) ->
    case M =:= Method of
        true -> Module:Method(Param);
        false -> bac_runner(T, Method, Module, Param)
    end;
bac_runner([], _Method, _Module, Param) ->
    Param.


save_start_controller(Module, Action, Req) ->
    try
        start_controller(Module, Action, Req)
    catch throw:Val ->
        process_controller_exception(throw, Val, Req)
    end.

save_start_controller(Module, Action, Req, T) ->
    try
        start_controller(Module, Action, Req, T)
    catch throw:Val ->
        process_controller_exception(throw, Val, Req)
    end.

%% ========================================================================
%% ПРОБЛЕМЫ И ОШИБКИ
%% ========================================================================

process_controller_exception(throw, nothing_to_be_done, _Req) ->
    [];

process_controller_exception(throw, {redirect, Url, []}, Req) ->
    flog:debug(?FMT("~p:~p 302 ~p REQUEST (~p) Redirect to ~p~n", [?MODULE, ?LINE, Req:get(method), Req:get(path), Url])),
    Req:respond({302, [{"Location", Url}, {"Content-Type", "text/html; charset=UTF-8"}], ""});
    
process_controller_exception(throw, not_found, Req) ->
    flog:info(?FMT("~p:~p 404 ~p REQUEST (~p) Not Found~n", [?MODULE, ?LINE, Req:get(method), Req:get(path)])),
    Req:not_found();

%%
%% application/json 
%%
process_controller_exception(throw, {auth_ajax, State} , Req) ->
    {Iserr, Val} = State,
    case Iserr of
        ok      ->
            V = {struct, [{<<"mess">>, null }, {"val", list_to_binary(Val)}]};
        error   ->
            case Val of
                {M, _N} ->
                    ErrMess = list_to_binary(M);
                [_H | _] ->
                    ErrMess = list_to_binary(Val);
                _ ->
                    ErrMess = <<"unknown">> 
            end,
            V = {struct, [{<<"mess">>, ErrMess }, {"val", ErrMess}]}
    end,
    DataOut = mochijson2:encode(V),
    Req:ok({"application/json", [], [DataOut]});

process_controller_exception(Type, Exc, Req) ->
    flog:error(?FMT("~p:~p Catch unknown exception (~p) on ~p request ~p ~n",[?MODULE, ?LINE, Exc, Req:get(method), Req:get(path)])),
    Type(Exc).

%% ========================================================================
%% КОНТРОЛЛЕРЫ  
%% ========================================================================
    
serve_request(Path, Req) ->
    case Path of

            "/decode/" ++ Source ->
                save_start_controller(home, decode, Req, {Source , [], []});

        _   ->
            ?ERROR(?FMT("404:~s", [Path])),
            Req:not_found()

    end.

loop(Req, _DocRoot) ->
    serve_request(Req:get(path), Req).

%% Internal API

get_option(Option, Options) ->
    {proplists:get_value(Option, Options), proplists:delete(Option, Options)}.

