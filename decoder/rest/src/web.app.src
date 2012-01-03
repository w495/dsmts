{application, web,
 [{description, "web"},
  {vsn, "0.01"},
  {modules, [
    web,
    web_app,
    web_sup,
    web_web,
    web_deps
  ]},
  {registered, [erlxsl_port_controller,erlxsl_fast_logger]},
  {mod, {web_app, []}},
  {start_phases, [{go,[]}]},
  {env, [
    {driver_options,
        [
            {engine,"default_provider"},
            {driver,"erlxsl"},
            {load_path,"priv/bin"}
        ]
    }
  ]},
  {applications, [kernel, stdlib, crypto]}]}.
