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
    
    Source_text = proplists:get_value("source", Data, []),
    Source = [
        {"text", Source_text}
    ],

    Target = internal_decode(Source_text),
    


    
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

internal_decode(Source_text) ->
    Tagret_text = Source_text,
    Perplexity = 0.1
    Target = [
        {"text", Tagret_text}
        {"Perplexity ", Perplexity }
    ],
    Tagret_text.


