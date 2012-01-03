%%% @file home
%%%
%%%     Контроллеры front end
%%%

-module(decoder).
-compile(export_all).

-import(mochiweb_cookies, [cookie/2, cookie/3]).

-include("../include/web_session.hrl").
-include("../include/common.hrl").
-include("../include/dao.hrl").
-include("../include/web.hrl").


decode(_Req, {Raw_source_text, [Self_parent, Item_parent | _ ],   [Xsl_root | _ ]}) ->
    case _Req:get_cookie_value(?SPEC) of
        "true" ->
            Xsl_path = Xsl_root ++ "/home/index-spec.xsl";
        _ ->
            Xsl_path = Xsl_root ++ "/home/index.xsl"
    end,

    Source_text = string:strip(Raw_source_text, both, $/),
    
    ?OUT("Source_text = ~s", [Source_text]),

    Meta = [
            {"current-path",        _Req:get(path)},
            {"parent-path",         Self_parent},
            {"self-parent-path",    Item_parent},
            {"item-parent-path",    Item_parent},
            {"is-spec",             _Req:get_cookie_value(?SPEC)},
            {"spec-variant",        _Req:get_cookie_value(?VARIANT)},
            {"spec-color",          _Req:get_cookie_value(?COLOR)}
    ],

    Xml  = xml:encode_data(
        [
            {"meta",    Meta}             % описание запроса
        ]
    ),
    Outty = xslt:apply(Xsl_path, Xml),
    {?OUTPUT_HTML, [], [Outty]}.

