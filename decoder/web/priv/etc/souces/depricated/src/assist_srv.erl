-module(assist_srv).
-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------


-include("../include/common.hrl").
%% ----------------------------------------------------------------------------
%% Defines
%% ----------------------------------------------------------------------------
-record(state, {debug=false, ldap}). %% Server state
-define(TIMEOUT, 1000).

%% ----------------------------------------------------------------------------
%% External exports
%% ----------------------------------------------------------------------------
-export([start_link/0]).

%% --------------------------------------------------------------------
%% gen_server callbacks
%% --------------------------------------------------------------------
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% ====================================================================
%% External functions
%% ====================================================================
start_link()->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], [{spawn_opt,[{min_heap_size,200000}]}]).


%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
    ?INFO(?FMT("ASSIST STARTING...~n~n~n", [])),
    process_flag(trap_exit, true),
    {ok, #state{}, ?TIMEOUT}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_call({apply,{Module, Action, Param}}, From, State) when is_atom(Module), is_atom(Action) ->
    spawn(fun() ->
        Reply =
            case catch(Module:Action(Param)) of
                {'EXIT', Reason} ->
                    flog:error(?FMT("EXCEPTION Call ~p:~p(~p) = ~p", [Module, Action, Param, Reason])),
                    {exception, Reason};
                Res -> flog:info(?FMT("SUCCESS Call ~p:~p(~p) = ~p", [Module, Action, Param, Res])),
                    {ok, Res}
            end,
            gen_server:reply(From, Reply)
    end),
    {noreply, State, ?TIMEOUT};

handle_call({biz_info, {Obj, Events, Pids}}, _From, State) ->
    notifyFeed(Obj, Events, Pids),
    {reply, done, State, ?TIMEOUT};
handle_call(Request, _From, State) ->
    flog:error(?FMT("~p:~p unexpected call: ~p~n", [?MODULE, ?LINE, Request])),
    {reply, {error, unexpected_call},  State, ?TIMEOUT}.


notifyFeed(Obj, Events, [Pid|T]) ->
    P = list_to_pid(utils:hex_to_list(Pid)),
    case erlang:is_process_alive(P) of
        true ->
            P ! {update, {Obj, Events}};
        false -> 
            done
            %crpc:call({biz_srv, config:get(biz_srv, biz@localhost)}, webSubscriberDAO, unsubscribe, 
            %{binary_to_list(term_to_binary({?MODULE, node()})), Pid})
    end,
    notifyFeed(Obj, Events, T);
notifyFeed(_Obj, _Events, []) ->
    done.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast({subscribe, {TrackerPhoneList, Pid, EventsTrackerPhone, D1, D2}}, State) ->
    %case csrv:subscribeWeb(CustomerPhone, TrackerPhone, ?BIZ2WEBNAME, Pid, DT) of
    case crpc:call({biz_srv, config:get(biz_srv, biz@localhost)}, webSubscriberDAO, subscribe, 
            {TrackerPhoneList, {?MODULE, node()}, utils:to_hex(pid_to_list(Pid)), EventsTrackerPhone, D1, D2}) of
        {error, E} ->
            flog:info(?FMT("~p:~p log subscribe error for TrackerPhoneList(~p) ~p ~n", [?MODULE, ?LINE, [EventsTrackerPhone|TrackerPhoneList], E]));
        {ok, []} ->
            done;
        {ok, Events} ->
            Pid ! {update, {null, Events}}
    end,
    {noreply, State, ?TIMEOUT};

handle_cast({unsubscribe, Pid}, State) ->
    crpc:call({biz_srv, config:get(biz_srv, biz@localhost)}, webSubscriberDAO, unsubscribe, 
            {{?MODULE, node()}, utils:to_hex(pid_to_list(Pid))}),
    {noreply, State, ?TIMEOUT};
 
handle_cast(Msg, State) ->
    flog:error(?FMT("~p:~p unexpected cast: ~p~n", [?MODULE, ?LINE, Msg])),
    {noreply, State, ?TIMEOUT}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(timeout, State) ->
    web_session_DAO:removeExpired(),
    {noreply, State, ?TIMEOUT};
handle_info(Info, State) ->
    flog:error(?FMT("~p:~p info at node ~p, info=~p~n", [?MODULE, ?LINE, node(), Info])),
    {noreply, State, ?TIMEOUT}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, _State) ->
    flog:info(?FMT("~p:~p terminated, reason: ~p~n", [?MODULE, ?LINE, Reason])),
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

