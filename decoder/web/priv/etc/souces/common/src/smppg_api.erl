%% --------------------------------------------------------------------
%% Created: 24.11.2009
%% SMPP gate API
%% --------------------------------------------------------------------

-module(smppg_api).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Defines
%% --------------------------------------------------------------------
-define(DEFAULT_ARGS, []).

%% --------------------------------------------------------------------
%% API exports
%% --------------------------------------------------------------------
-export([ route_add/3, route_del/2,
          sm_send/3, sm_send/4 ]).

%% --------------------------------------------------------------------
%% API
%% --------------------------------------------------------------------
route_add(GateNode, Phone, {AppGenSrv,AppNode}=AppSpec)
  when is_atom(GateNode), is_integer(Phone),
       is_atom(AppGenSrv), is_atom(AppNode) ->
    route_add_impl(GateNode, Phone, AppSpec).

route_del(GateNode, Phone)
  when is_atom(GateNode), is_integer(Phone) ->
    route_del_impl(GateNode, Phone).

sm_send(GateNode, Phone, Sm) ->
    sm_send(GateNode, Phone, Sm, ?DEFAULT_ARGS).

sm_send(GateNode, Phone, Sm, SendArgs)
  when is_atom(GateNode), is_integer(Phone), is_list(SendArgs) ->
    sm_send_impl(GateNode, Phone, Sm, SendArgs).

%% --------------------------------------------------------------------
%% Internal
%% --------------------------------------------------------------------
route_add_impl(GateNode, Phone, AppSpec) ->
    rpc:call(GateNode, smppg, route_add, [Phone,AppSpec]).

route_del_impl(GateNode, Phone) ->
    rpc:call(GateNode, smppg, route_del, [Phone]).

sm_send_impl(GateNode, Phone, Sm, SendArgs) ->
    rpc:call(GateNode, smppg, sm_send, [Phone, Sm, SendArgs]).
