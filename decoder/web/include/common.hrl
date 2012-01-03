% -----------------------------------------------------------------------------
%% common defines
% -----------------------------------------------------------------------------

-define( FMT(F,P), lists:flatten(io_lib:format(F,P)) ).
-define( APP, web).
-define( CFG_PROCS, [{gen_server, m_pinger},
                     {gen_event, error_logger}]
       ).

-ifdef(debug).
-define(QOOXDOOBUILD, "source").
-else.
-define(QOOXDOOBUILD, "build").
-endif.

-define( INFO(P),  flog:info(P) ).
-define( ERROR(P), flog:error(P) ).
-define( DEBUG(P), flog:debug(P) ).

-define( OUT(F, P), io:format(F, P) ).


-define(LSTHOST, config:get(lsthost, "0.0.0.0")).
-define(LSTPORT, config:get(lstport, 8080)).
