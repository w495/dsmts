%%% @file home
%%%
%%%     Контроллеры front OBend
%%%

-module(home).
-compile(export_all).

-import(mochiweb_cookies, [cookie/2, cookie/3]).

-include("../include/web_session.hrl").
-include("../include/common.hrl").
-include("../include/dao.hrl").
-include("../include/web.hrl").



index(Req, {_, [Self_parent, Item_parent | _ ],   [Xsl_root | _ ]}) ->
    case Req:get_cookie_value(?SPEC) of
        "true" ->
            Xsl_path = Xsl_root ++ "/home/index-spec.xsl";
        _ ->
            Xsl_path = Xsl_root ++ "/home/index.xsl"
    end,

    Data = Req:parse_qs(),


    Source      = [
        {"text",  proplists:get_value("source", Data, [])}
    ],



    Target_old  = [
        {"text",          proplists:get_value("target", Data, [])},
        {"perplexity",    proplists:get_value("perplexity", Data, 0)},
        {"times",         proplists:get_value("times", Data, 0)}
    ],

    Target = internal_decode({Source, Target_old}),

    Meta = [
            {"current-path",        Req:get(path)},
            {"parent-path",         Self_parent},
            {"self-parent-path",    Self_parent},
            {"item-parent-path",    Item_parent},
            {"is-spec",             Req:get_cookie_value(?SPEC)},
            {"spec-variant",        Req:get_cookie_value(?VARIANT)},
            {"spec-color",          Req:get_cookie_value(?COLOR)}
    ],
    Xml  = xml:encode_data(
        [
            {"source",    Source},        % первоначальный запрос
            {"target",    Target},        % первоначальный запрос
            {"meta",    Meta}             % описание запроса
        ]
    ),
    Outty = xslt:apply(Xsl_path, Xml),
    {?OUTPUT_HTML, [], [Outty]}.




rest(Req, {Raw_source_text, _,   _}) ->
    Source_text = string:strip(Raw_source_text, both, $/),
    ?OUT("Source_text = ~s", [Source_text]),
    Target_text = internal_decode(Source_text),
    {?OUTPUT_TEXT, [], [Target_text]}.


internal_decode({Source, Target}) ->

    io:format("{Source, Target} = ~p", [{Source, Target}]),

    Perplexity =
        convert:to_integer(proplists:get_value("perplexity", Target)) + 1,

    Times =
        convert:to_integer(proplists:get_value("times", Target)) + 1,

    [
        {"text",          proplists:get_value("text", Source)},
        {"perplexity",    Perplexity},
        {"times",         Times}
    ].


