%%% @file home
%%%
%%%     Контроллеры front end
%%%

-module(home).
-compile(export_all).

-import(mochiweb_cookies, [cookie/2, cookie/3]).

-include("../include/web_session.hrl").
-include("../include/common.hrl").
-include("../include/web.hrl").

decode(Req, {Raw_source_text, _,   _}) ->
    case Req:get(method) of
        Method when Method =:= 'GET'; Method =:= 'HEAD' ->
            Source_text = string:strip(Raw_source_text, both, $/),

            Response = Req:ok({?OUTPUT_TEXT,
                [{"Server","disista-matrasy rest"}],
                chunked}),

            feed(Response, Source_text , 1);
        'POST' ->
            Req:not_found();
        _ ->
            Req:respond({501, [], []})
    end.


feed(Response, Source_text, N) ->
    receive

    after ?REST_TIMEOUT ->

        Target_text = internal_decode(Source_text),
        Massage = lists:append(Target_text, [$\n]),
        Response:write_chunk(Massage)

    end,
    feed(Response, Source_text, N+1).


internal_decode(Source) ->
    Tagret = Source,
    Tagret.

