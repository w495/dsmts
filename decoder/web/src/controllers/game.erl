%%% @file web_cb.erl
%%%
%%%     Контроллеры front end
%%%

-module(game).
-compile(export_all).

-import(mochiweb_cookies, [cookie/2, cookie/3]).

-include("../include/web_session.hrl").
-include("../include/common.hrl").
-include("../include/dao.hrl").

%%% 
%%% Головная станица игры
%%%

index(_Req, {_, _,  [SelfParent, ItemParent | _ ],   [XslRoot | _ ]}) ->
    %#web_session{login=Login} = authorization:auth_required_front(_Req),
    Login = authorization:auth_getlogin(_Req),    
    
    case utils:to_integer(proplists:get_value("print", _Req:parse_qs())) of
        1   ->                   XslPath = XslRoot ++ "/game/details-print.xsl";
        _   ->  case _Req:get_cookie_value(?SPEC) of
                "true"  ->       XslPath = XslRoot ++ "/game/details-spec.xsl";
                _       ->       XslPath = XslRoot ++ "/game/index.xsl"
            end
    end,
    
    Meta = [[
            {"current-path", _Req:get(path)},
            {"parent-path", SelfParent},
            {"self-parent-path", SelfParent},
            {"self-retpath", _Req:get(path)},
            
            {"login", Login},
            {"item-parent-path", ItemParent},
            {"is-spec",             _Req:get_cookie_value(?SPEC)},
            {"spec-variant",        _Req:get_cookie_value(?VARIANT)},
            {"spec-color",          _Req:get_cookie_value(?COLOR)}
    ]],
    XMLTerms  = pg2xml:encodeData(
        [
            {one, Meta, "meta"}             % описание запроса
        ]
    ),    
    Outty = xslt:apply(XslPath, XMLTerms),
    {"text/html", [], [Outty]}.


%%% 
%%% Описание игры
%%%

details(_Req, {_, _,  [SelfParent, ItemParent | _ ],   [XslRoot | _ ]}) ->
    Login = authorization:auth_getlogin(_Req),
    
    case utils:to_integer(proplists:get_value("print", _Req:parse_qs())) of
        1   ->                   XslPath = XslRoot ++ "/game/details-print.xsl";
        _   ->  case _Req:get_cookie_value(?SPEC) of
                "true"  ->       XslPath = XslRoot ++ "/game/details-spec.xsl";
                _       ->       XslPath = XslRoot ++ "/game/details.xsl"
            end
    end,
    
    Meta = [[
            {"current-path", _Req:get(path)},
            {"parent-path", SelfParent},
            {"self-parent-path", SelfParent},
            {"self-retpath", _Req:get(path)},
            
            {"login", Login},
            {"item-parent-path", ItemParent},
            {"is-spec",             _Req:get_cookie_value(?SPEC)},
            {"spec-variant",        _Req:get_cookie_value(?VARIANT)},
            {"spec-color",          _Req:get_cookie_value(?COLOR)}
    ]],
    
    XMLTerms  = pg2xml:encodeData(
        [
            {one, Meta, "meta"}             % описание запроса
        ]
    ),
    
    Outty = xslt:apply(XslPath, XMLTerms),
    {"text/html", [], [Outty]}.

