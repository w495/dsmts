-module(web).
-author('author <author@example.com>').

-export([start/0, stop/0, status/0, stop_and_halt/0,
         reload_cfg/0, reload_code/0, version/0]).

-include("../include/common.hrl").

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

start() ->
    try
        recover_if_needed(),
        web_deps:ensure(),
        ensure_started(crypto),
        ensure_started(mnesia),
        inets:start(),
        %amnesia:init(),
        application:start(?APP)
    after
      %% give the error loggers some time to catch up
      timer:sleep(100)
    end.

stop() ->
    Res = application:stop(?APP),
    inets:stop(),
    application:stop(mnesia),
    application:stop(crypto),
    Res.

%% @spec stop_and_halt() -> ok
%% @doc Stop the adm server ans shutdown node.
stop_and_halt() ->
    spawn(fun() ->
            SleepTime = 1000,
            flog:info([{?MODULE,"received stop_and_halt"}]),
            timer:sleep(SleepTime),
            halt(0)
          end),
    case catch stop() of _ -> ok end.

%% @spec status() -> list
%% @doc Return running applications and adm version
status() ->
    utils:status().

%% @spec reload_cfg() -> term
%% @doc Reload adm config
reload_cfg() ->
    utils:reload_cfg(?APP, ?CFG_PROCS).

%% @spec reload_code() -> term
%% @doc Reload adm code
reload_code() ->
    utils:reload_code().

version() -> {0,1}.

% ----------------------------------------------------------------------------
recover_if_needed() ->
    utils:recover_if_needed().
