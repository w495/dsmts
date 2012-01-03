-define(SESSION_TABLE_NAME, list_to_atom(atom_to_list(node()) ++ "_session")).

-record(web_session, {
    uid,
    login,
    customer_id,
    permissions=[],
    time,
    password_hash
}).


-define(AUTHCOOKIE, config:get(cookiename, "MCHS")).
-define(SPEC, config:get(cookiename_site_varaint, "SPEC")).
-define(VARIANT, config:get(cookiename_site_varaint, "VARIANT")).
-define(COLOR, config:get(cookiename_site_color, "COLOR")).
-define(EXPCOOKIE, config:get(expcookie, 18000)).


-define(F_COOKIEOPTIONS, [{max_age, ?EXPCOOKIE}, {path, "/"}]).