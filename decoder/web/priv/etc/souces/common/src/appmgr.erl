-module(appmgr).

-include("../include/common.hrl").

%%% --------------------------------------------------------------------
%%% API
%%% --------------------------------------------------------------------
-export([start/1, stop/1, stop_and_halt/0,
         status/0, version/0,
         recover_if_needed/0,
         start_applications/1, stop_applications/1,
         reload_code/0,
         reload_cfg/0,
         log_level/1,
         debug_opts/1]).

%%% --------------------------------------------------------------------
%%% Macros
%%% --------------------------------------------------------------------

start(StartApps) ->
    try
        %Apps = (StartApps -- [mnesia]) ++ [?APP],
        Apps = StartApps  ++ [?APP],
        case lists:member(mnesia, Apps) of
            true ->
                recover_if_needed(),
                catch deps:ensure(),
                ok = amnesia:ensure_mnesia_dir(),
                ok = start_applications([mnesia]),
                ok = amnesia:init();
            false ->
                done
        end,
        ok = start_applications(Apps)
    after
      %% give the error loggers some time to catch up
      timer:sleep(100)
    end.


stop(StopApps) ->
    %Apps = (StopApps -- [mnesia]) ++ [?APP],
    Apps = StopApps ++ [?APP],
    case lists:member(mnesia, Apps) of
        true -> ok = stop_applications([mnesia|Apps]);
        false -> ok = stop_applications(Apps)
    end,
    ok.

stop_and_halt() ->
    spawn(fun() ->
            SleepTime = 1000,
%            flog:info([{?MODULE,"received stop_and_halt"}]),
            timer:sleep(SleepTime),
            halt(0)
          end),
    case catch stop([?APP]) of _ -> ok end.


status() ->
    utils:status().


%% TODO: version.erl
version() -> {0,1}.


%% ---------------------------------------------------------------------------
log_level(<<>>) ->
    config:get(log_level, info);
log_level(BinArgs) ->
    Args = lists:map(fun binary_to_list/1, BinArgs),
    case Args of
  ["info"]  -> config:put(log_level, info);   %% info + errors
  ["error"] -> config:put(log_level, error);  %% no info, only errors
  ["debug","all"] -> config:put(log_level, {debug,all}); %% info + errors + all debug events
  ["debug","partial"] -> config:put(log_level, {debug,partial}); %% info + errors + some debug events
  Other -> {error, {badarg, Other}}
    end.

debug_opts(BinArgs) ->
    Args = lists:map(fun binary_to_list/1, BinArgs),
    case Args of
  ["phone", Phone, "true"]  -> config:rewrite({phone,Phone}, debug, true);
  ["phone", Phone, "false"] -> config:rewrite({phone,Phone}, debug, false);
  [Module, "true"]  -> config:put(utils:to_atom(Module), true);
  [Module, "false"] -> config:put(utils:to_atom(Module), false);
  Other -> {error, {badarg, Other}}
    end.

% -----------------------------------------------------------------------------
recover_if_needed() ->
    case init:get_argument(recover) of
  {ok,[["true"]]} ->
      MasterNodes = mnesia:system_info(db_nodes) -- [node()],
      io:format("recover DB from nodes: ~p~n", [MasterNodes]),
      ok = mnesia:set_master_nodes(MasterNodes);
  {ok, [MasterNodes]} when is_list(MasterNodes) ->
      MasterNodesAtom = lists:map(fun(NodeStr) -> utils:to_atom(NodeStr) end,
                                  MasterNodes),
      io:format("recover DB from nodes: ~p~n", [MasterNodesAtom]),
      ok =
 mnesia:set_master_nodes(MasterNodesAtom),
      ok;
  _ -> ok
    end.

% -----------------------------------------------------------------------------
reload_code() ->
    reloader2:reload_code().

%% ---------------------------------------------------------------------------
reload_cfg() ->
    reload_cfg(?APP, ?CFG_PROCS).

reload_cfg(App, CfgProcs) ->
    try
       ok = config:init(),
       CfgFile = get_config_name(),
       Args = get_app_params(App, CfgFile),
       config:store(Args),
       notify_procs(cfg_reloaded, CfgProcs),
       after_reload_cfg(),
       [{config_file,CfgFile}|Args]
    catch
  _:{error, Why} ->
       flog:error([{?MODULE,reload_cfg},{error,Why}]);
  _:Err ->
       flog:error([{?MODULE,reload_cfg},{error,Err}])
    end.


get_config_name() ->
    case init:get_argument(config) of
  error -> throw({error,{config,undefined}});
  {ok,[[File]]} -> File ++ ".config"
    end.


get_app_params(App, File) ->
    case file:consult(File) of
  {ok, [L]} ->
      proplists:get_value(App, L, []);
  Err -> throw(Err)
    end.

notify_procs(Msg, L) ->
    F = fun({Type,Proc}) ->
                case whereis(Proc) of
              Pid when is_pid(Pid) -> catch notify_proc(Type, Pid, Msg);
              _ -> ok
                end
    end,
    lists:foreach(F, L).

notify_proc(gen_server, Pid, Msg) ->
    gen_server:cast(Pid, Msg);
notify_proc(gen_event, Pid, Msg) ->
    gen_event:notify(Pid, Msg).


after_reload_cfg() ->
    handle_os_mon().

handle_os_mon() ->
    case config:get(os_mon, false) of
  true  ->
      application:start(os_mon, permanent);
  false ->
      application:stop(os_mon)
    end.

%%% ============================================================================
%%% APP manage
%%% ============================================================================
manage_applications_s(Iterate, Do, Undo, SkipError, ErrorTag, Result, Apps) ->
    Iterate(fun(App,Acc) ->
                case Do(App,permanent) of
              ok -> [{App,Result} | Acc];
              {error, {SkipError, _}} -> Acc;
              {error, Reason} ->
                  lists:foreach(Undo, Acc),
                  throw({error, {ErrorTag, App, Reason}})
                end
            end, [], Apps),
    ok.


manage_applications_e(Iterate, Do, Undo, SkipError, ErrorTag, Result, Apps) ->
    Iterate(fun(App,Acc) ->
                case Do(App) of
              ok -> [{App,Result} | Acc];
              {error, {SkipError, _}} -> Acc;
              {error, Reason} ->
                  lists:foreach(Undo, Acc),
                  throw({error, {ErrorTag, App, Reason}})
                end
            end, [], Apps),
    ok.


start_applications(Apps) ->
    manage_applications_s(fun lists:foldl/3,
                          fun application:start/2,
                          fun application:stop/1,
                          already_started,
                          cannot_start_application,
                          started,
                          Apps).

stop_applications(Apps) ->
    manage_applications_e(fun lists:foldr/3,
                          fun application:stop/1,
                          fun application:start/1,
                          not_started,
                          cannot_stop_application,
                          stopped,
                          Apps).
