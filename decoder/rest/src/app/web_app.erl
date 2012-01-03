-module(web_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1,start_phase/3]).

-include("../include/common.hrl").

start(Type, _StartArgs) ->
    erlang:register(?MODULE, self()),
    web_deps:ensure(),
    ok = error_logger:add_report_handler(flog, [web]),
    web:reload_cfg(),
    Rc = web_sup:start_link(),
    case Type of
        {takeover,_} -> ok;
        _ -> start_http(10,2)
    end,
    Rc.

start_phase(go, {takeover,FromNode}, _) ->
%    io:format("start_phase: takeover~n", []),
    case rpc:call(FromNode, web_web, stop, []) of
        ok -> start_http(10,2);
        Error -> {error,{takeover,FromNode,Error}}
    end;
start_phase(go, _Type, _ ) ->
    ok.


start_http(0,_) -> {error,{start_http,eaddrinuse}};
start_http(N,Delay) ->
    WebConfig = [
        {ip, config:get(lsthost, "0.0.0.0")},
        {port, config:get(lstport, 8000)}
    ],
    Web = {web_web, {web_web, start, [WebConfig]}, permanent, 5000, worker, dynamic},
    case supervisor:start_child(web_sup, Web) of
        {ok, _Pid} -> ok;
        {error, {eaddrinuse,_}} ->
            timer:sleep(Delay*1000),
            start_http(N-1,Delay)
    end.

stop(_State) ->
    error_logger:delete_report_handler(flog),
    ok = supervisor:terminate_child(web_sup, web_web),
    ok = supervisor:delete_child(web_sup, web_web),
    ok.

