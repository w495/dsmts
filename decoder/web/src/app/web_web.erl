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
    mochiweb_http:start([{name, ?MODULE}, {loop, Loop} | Options1]).

stop() ->
    io:format("~p: ~p got stop signal~n", [erlang:localtime(), ?MODULE]),
    supervisor:terminate_child(web_sup, ?MODULE),
    supervisor:delete_child(web_sup, ?MODULE).

serve_static_inner(P, T, Req, ExtraHeaders) ->
    try
        {Tmp, <<".js">>} = split_binary(list_to_binary(T), length(T) - 3),
        Fname = binary_to_list(Tmp) ++ ".gz.js",
        true = lists:member("gzip", string:tokens(Req:get_header_value("Accept-Encoding"), ", ")),
        {ok, _} = file:read_file_info(P ++ "/" ++ Fname),
        Req:serve_file(Fname, P, [{"content-encoding", "gzip"} | ExtraHeaders])
    catch
        _:_ ->
            Req:serve_file(T, P, ExtraHeaders)
    end.

serve_static(P, T, Req) ->
    serve_static_inner(P, T, Req, []).

serve_static(P, T, Req, ExtraHeaders) ->
    serve_static_inner(P, T, Req, ExtraHeaders).

start_controller(Module, Action, Req) ->
    flog:debug(?FMT("~p:~p 200 ~p REQUEST (~p) ~p:~p ~n", [?MODULE, ?LINE, Req:get(method), Req:get(path), Module, Action])),
    Exports = Module:module_info(exports),
    % % CALL BEFORE
    _NReq = bacRunner(Exports, call_before, Module, Req),
    % % CALL CONTROLLER
    Result = Module:Action(Req),
    % % CALL AFTER
    {_, NResult} = bacRunner(Exports, call_after, Module, {Req, Result}),
    Req:ok(NResult).

start_controller(Module, Action, Req, Param) ->
    flog:debug(?FMT("~p:~p 200 ~p REQUEST (~p) ~p:~p ~n", [?MODULE, ?LINE, Req:get(method), Req:get(path), Module, Action])),
    Exports = Module:module_info(exports),
    % % CALL BEFORE
    _NReq = bacRunner(Exports, call_before, Module, Req),
    % % CALL CONTROLLER
    Result = Module:Action(Req, Param),
    % % CALL AFTER
    {_, NResult} = bacRunner(Exports, call_after, Module, {Req, Result}),
    Req:ok(NResult).


bacRunner([{M, _}|T], Method, Module, Param) ->
    case M =:= Method of
        true -> Module:Method(Param);
        false -> bacRunner(T, Method, Module, Param)
    end;
bacRunner([], _Method, _Module, Param) ->
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

process_controller_exception(throw, {serve_static, Filename, Path, ExtraHeaders}, Req)->
    serve_static(Path, Filename, Req, ExtraHeaders);
    
process_controller_exception(throw, {js_redirect, Url, _Cookie}, Req) ->
    flog:debug(?FMT("~p:~p 200 ~p REQUEST (~p) JS Redirect to ~p~n", [?MODULE, ?LINE, Req:get(method), Req:get(path), Url])),
    V = {struct, [{<<"REDIRECT">>, list_to_binary(Url)}]},
    DataOut = mochijson2:encode(V),
    Req:ok({"application/json", [], [DataOut]});

%%
%% Перенаправление без Cookie, как для аутентификации.
%%
process_controller_exception(throw, {redirect, Url, []}, Req) ->
    flog:debug(?FMT("~p:~p 302 ~p REQUEST (~p) Redirect to ~p~n", [?MODULE, ?LINE, Req:get(method), Req:get(path), Url])),
    Req:respond({302, [{"Location", Url}, {"Content-Type", "text/html; charset=UTF-8"}], ""});

%%
%% Перенаправление с новыми Cookie, как для слепых.
%%
process_controller_exception(throw, {redirect, Url, Cookie}, Req) ->
    flog:debug(?FMT("~p:~p 302 ~p REQUEST (~p) Redirect to ~p~n", [?MODULE, ?LINE, Req:get(method), Req:get(path), Url])),
    Req:respond({302, [{"Location", Url}, {"Content-Type", "text/html; charset=UTF-8"}] ++ Cookie,""});
    
process_controller_exception(throw, not_found, Req) ->
    flog:info(?FMT("~p:~p 404 ~p REQUEST (~p) Not Found~n", [?MODULE, ?LINE, Req:get(method), Req:get(path)])),
    Req:not_found();

process_controller_exception(throw, auth_required, Req) ->
    flog:debug(?FMT("~p:~p 200 ~p REQUEST (~p) AUTH REQUIRED~n", [?MODULE, ?LINE, Req:get(method), Req:get(path)])),
    V = {struct, [{<<"REDIRECT">>, <<"/login">>}]},
    DataOut = mochijson2:encode(V),
    Req:ok({"application/json", [], [DataOut]});

%%
%% Перенаправление без аутентификации.
%%
process_controller_exception(throw, {auth_required_front, RetPath} , Req) ->
    flog:debug(?FMT("~p:~p 302 ~p REQUEST (~p) AUTH REQUIRED~n", [?MODULE, ?LINE, Req:get(method), Req:get(path)])),
    process_controller_exception(throw, {redirect, "/Users/Login" ++ RetPath, []}, Req);

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

%%
%% application/json
%%
process_controller_exception(throw, {banners_ajax, State} , Req) ->
    Req:ok({"application/json", [], [mochijson2:encode(State)]});

process_controller_exception(throw, auth_required_dialog, Req) ->
    flog:debug(?FMT("~p:~p 200 ~p REQUEST (~p) AUTH REQUIRED~n", [?MODULE, ?LINE, Req:get(method), Req:get(path)])),
    V = {struct, [{<<"ERROR">>, <<"auth_required">>}]},
    DataOut = mochijson2:encode(V),
    Req:ok({"application/json", [], [DataOut]});
    
process_controller_exception(Type, Exc, Req) ->
    flog:error(?FMT("~p:~p Catch unknown exception (~p) on ~p request ~p ~n",[?MODULE, ?LINE, Exc, Req:get(method), Req:get(path)])),
    Type(Exc).


%% ========================================================================
%% СТАТИЧЕСКОЕ ОТОБРАЖЕНИЕ АДРЕСОВ
%% ========================================================================


serve_request(?STATIC_FAVICON_URL, Req) ->
    serve_static(?STATIC_FAVICON_PATH, [], Req);

serve_request(?STATIC_DATA_URL ++ T, Req) ->
    serve_static(?STATIC_DATA_PATH, T, Req);

serve_request(?STATIC_MEDIA_URL ++ T, Req) ->
    serve_static(?STATIC_MEDIA_PATH, T, Req);

serve_request(?STATIC_CSS_URL ++ T, Req) ->
    serve_static(?STATIC_CSS_PATH, T, Req);

serve_request(?STATIC_JS_URL ++ T, Req) ->
    serve_static(?STATIC_JS_PATH, T, Req);

serve_request(?STATIC_IMAGES_URL ++ T, Req) ->
    serve_static(?STATIC_IMAGES_PATH, T, Req);
    
%% ========================================================================
%% КОНТРОЛЛЕРЫ  
%% ========================================================================
    
serve_request(Path, Req) ->

    case Path of

        %%% Неявные  Перенаправления

            "/" ->
                serve_request("/home/index/" , Req);
                "/wap/" ->
                    serve_request("/wap/home/index/" , Req);
                "/mobile/" ->
                    serve_request("/mobile/home/index/" , Req);

            "/home/" ->
                serve_request("/home/index/" , Req);
                "/wap/home/" ->
                    serve_request("/wap/home/index/" , Req);
                "/mobile/home/" ->
                    serve_request("/mobile/home/index/" , Req);

        %%% Явные вызовы

            "/home/index/" ++ Param ->
                save_start_controller(home, index, Req, {foo_param, ?LINKS_TRANSOPTIONS, ?TEMPLATE_NORMALOPTIONS });

            %"/decode/" ++ Source ->
            %    save_start_controller(home, decode, Req, {Source , ?LINKS_TRANSOPTIONS, ?TEMPLATE_NORMALOPTIONS });

            "/rest/" ++ Source ->
                save_start_controller(home, rest, Req, {Source , [], []});
                
        _   ->
            ?ERROR(?FMT("404:~s", [Path])),
            Req:not_found()

    end.

loop(Req, _DocRoot) ->
    serve_request(Req:get(path), Req).

%% Internal API

get_option(Option, Options) ->
    {proplists:get_value(Option, Options), proplists:delete(Option, Options)}.

