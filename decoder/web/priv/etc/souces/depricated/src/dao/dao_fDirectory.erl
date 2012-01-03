%%% @file dao_fDirectory.erl
%%%
%%%     Доступ к данным для сущности директория и документ.
%%%     Версия для внешнего сайта.
%%%     Отображается только то, что существуюет и разрещено явно.
%%%     Например, только опубликованные документы.
%%%

-module(dao_fDirectory).

-include("../include/common.hrl").
-include("../include/dao.hrl").

-compile(export_all).

%%
%% Возвращает содержащиеся в директории обощенные опубликованные документы,
%% не более Limit штук
%%
%% Используется для списка новостей на главной страницы.
%%

stripOk(Module, Method, Value)->
    case Module:Method(Value) of
        {ok, Res, _ } -> Res;
        {ok, Res} ->  Res;
        Res -> Res
    end.


getDocsCount({news, docs}) ->
    getDocsCount({?NEWS_ID, ?DOC_ID});
    
getDocsCount({Dir_id, Doc_type_id}) ->
    Q1 = "select count(document.id)"
            " from document "
        " where " % deleted = false
          " document.dir_id = $1 "
          " and document.published = true "
          " and document.doc_type_id = $2 ",
    dao:simple(Q1, [utils:to_integer(Dir_id), utils:to_integer(Doc_type_id)]).


getDocsLimited({news, docs, Limit}) ->
    getDocsLimitedLf({?NEWS_ID, ?DOC_ID, Limit});

getDocsLimited({news, docs, Limit, Page}) ->
    getDocsLimitedLf({?NEWS_ID, ?DOC_ID, Limit, Page}).


getDocsLimitedBr({Dir_id, Doc_type_id, Limit}) ->
    Q1 = "select document.* from (select "
                "document.id, document.name, "
                "regexp_replace ( content,  E'&lt;br /&gt;+.+$', '' )  as content , "
                    % content выводится до первого перевода строки
                    % эта часть статьи и будет считаться аннонсом
                ?DOC_PUD  ","
                ?DOC_URLS ","
                ?DOC_IDS 
            " from document "
            " where " % deleted = false
              " document.dir_id = $1 "
              " and document.published = true "
              " and document.doc_type_id = $2 "
            " order by id desc "
            " limit $3) as document order by id asc;",
    dao:simple(Q1, [utils:to_integer(Dir_id),
        utils:to_integer(Doc_type_id),
        utils:to_integer(Limit)]).

getDocsLimitedLf({Dir_id, Doc_type_id, Limit}) ->
    Q1 = "select document.* from (select "
                "document.id, document.name, "
                "regexp_replace ( content,  E'[\n]+.+$', '' ) as content , "
                    % content выводится до первого перевода строки
                    % эта часть статьи и будет считаться аннонсом
                ?DOC_PUD  ","
                ?DOC_URLS ","
                ?DOC_IDS 
            " from document "
            " where " % deleted = false
              " document.dir_id = $1 "
              " and document.published = true "
              " and document.doc_type_id = $2 "
            " order by id desc "
            " limit $3) as document order by id asc;",
    dao:simple(Q1, [utils:to_integer(Dir_id),
        utils:to_integer(Doc_type_id),
        utils:to_integer(Limit)]);

getDocsLimitedLf({Dir_id, Doc_type_id, Limit, Page}) ->
    Limit_int = utils:to_integer(Limit),
    Page_int = utils:to_integer(Page),
    Offset_int = Limit_int * Page_int,
    
    Q1 = "select document.* from (select "
                "document.id, document.name, "
                "regexp_replace ( content,  E'[\n]+.+$', '' ) as content , "
                    % content выводится до первого перевода строки
                    % эта часть статьи и будет считаться аннонсом
                ?DOC_PUD  ","
                ?DOC_URLS ","
                ?DOC_IDS 
            " from document "
            " where " % deleted = false
              " document.dir_id = $1 "
              " and document.published = true "
              " and document.doc_type_id = $2 "
            " order by id desc "
            " limit $3 offset $4) as document order by id asc;",
    dao:simple(Q1, [utils:to_integer(Dir_id),
        utils:to_integer(Doc_type_id), Limit_int, Offset_int]).


getDocsLimitedFull({news, docs, Limit}) ->
    getDocsLimitedFullContent({?NEWS_ID, ?DOC_ID, Limit}).
    
getDocsLimitedFullContent({Dir_id, Doc_type_id, Limit}) ->
    Q1 = "select document.* from (select "
                ?DOC_MAIN  ","
                ?DOC_PUD  ","
                ?DOC_URLS ","
                ?DOC_IDS 
            " from document "
            " where " % deleted = false
              " document.dir_id = $1 "
              " and document.published = true "
              " and document.doc_type_id = $2 "
            " order by id desc "
            " limit $3) as document order by id asc;",
    dao:simple(Q1, [utils:to_integer(Dir_id),
        utils:to_integer(Doc_type_id),
        utils:to_integer(Limit)]).

%%
%% Возвращает докумень по Id, еслу он опубликован.
%% Используется при отображении новостей, терминов и прочих документов.
%%
getDoc(Id) ->
    Q1 = "select "
            ?DOC_COMMON
          " from document "
          " where "
            " document.id = $1 "
            " and document.published = true; ",
    case dao:simple(Q1, [utils:to_integer(Id)]) of
        {ok, R1Val} ->
            Q2 = "select "
                ?ATTACHE_COMMON
                "  from attach2doc "
                "where doc_id  = $1",
            case dao:simple(Q2, [utils:to_integer(Id)]) of
                {ok, R2Val} -> {ok, R1Val, R2Val};
                E2 -> E2
            end;
        E1 -> E1
    end.

getTestAnswer(Id) ->
    Q1 = "select "
            ?DOC_COMMON
            ", quest_answer.correct_flag as correct_flag "
            " from document, quest_answer"
                " where id = $1 "
                "   and quest_answer.answer_id = id ; ",    
    case dao:simple(Q1, [utils:to_integer(Id)]) of
        {ok, R1Val} ->
            Q2 = "select "
                ?ATTACHE_COMMON
                "  from attach2doc "
                "where doc_id  = $1",
            case dao:simple(Q2, [utils:to_integer(Id)]) of
                {ok, R2Val} -> {ok, R1Val, R2Val};
                E2 -> E2
            end;
        E1 -> E1
    end.

%%
%% Возвращает список поддиректорий для Parent_dir_id
%%
getDirs({Parent_dir_id}) ->
    Q1 = "select directory.id, directory.name, directory.parent_dir_id " ","
            " directory.datatime, directory.updater " ","
            " directory.doc_description_id, directory.dir_type_id "
          "from directory, document  "
          " where directory.deleted = false "
            " and document.dir_id = directory.id "
            " and document.doc_type_id =  $2 "
            " and directory.parent_dir_id = $1 "
            " and directory.parent_dir_id != directory.id  order by datatime desc ;",
    dao:simple(Q1, [utils:to_integer(Parent_dir_id), utils:to_integer(?DESCR_ID)]).

getDirs2({Parent_dir_id}) ->
    Q1 = "select directory.id, directory.name, directory.parent_dir_id " ","
            " directory.datatime, directory.updater " ","
            " directory.doc_description_id, directory.dir_type_id "
          "from directory join document on document.id = directory.doc_description_id "
          " where "
            " directory.parent_dir_id = $1 "
            " and directory.deleted = false "
            " and directory.parent_dir_id != directory.id order by datatime desc ;",
    dao:simple(Q1, [utils:to_integer(Parent_dir_id)]).

test2() ->
    utils:test(fun() ->
        getDirs({3})
    end, 1000),
    utils:test(fun() ->
        getDirs2({3})
    end, 1000).



getTestQuestions({Parent_dir_id}) ->
    Q1 = "select directory.id, directory.name, directory.parent_dir_id " ","
            " directory.datatime, directory.updater " ","
            " document.pic_url as pic_url, "
            " directory.doc_description_id, directory.dir_type_id "
          "from directory, document  "
          " where directory.deleted = false "
            " and document.dir_id = directory.id "
            " and document.doc_type_id =  $2 "
            " and directory.parent_dir_id = $1 "
            " and directory.parent_dir_id != directory.id;",
    dao:simple(Q1, [utils:to_integer(Parent_dir_id), utils:to_integer(?DESCR_ID)]).


%%
%% Возвращает список поддиректорий для Parent_dir_id
%%     создавшими c пользователями
%%
getDirsWithCustomer({Parent_dir_id}) ->
    Q1 = "select d.id, d.name, d.parent_dir_id " ","
            " d.datatime, d.updater " ","
            " doc.content as content,  "
            " c.firstname, c.lastname, c.patronimic, "
            " c.city, c.organization, c.position, "
            " c.email, c.login, c.pic_url as customer_pic_url, "
            " d.doc_description_id, d.dir_type_id "
          "from directory as d, document as doc, customer as c"
          " where "
            " d.deleted = false "
            " and doc.dir_id = d.id "
            " and doc.doc_type_id = $2 "
            " and d.updater = c.id "
            " and d.parent_dir_id = $1"
            " and d.parent_dir_id != d.id;",
    dao:simple(Q1, [utils:to_integer(Parent_dir_id), ?DESCR_ID]).

%%
%% Возвращает список поддиректорий для Parent_dir_id
%%     создавшими c пользователями
%%
getDirsWithCustomerP({Parent_dir_id}) ->
    Q1 = "select d.id, d.name, d.parent_dir_id " ","
            " d.datatime, d.updater " ","
            " doc.content as content,  "
            " c.firstname, c.lastname, c.patronimic, "
            " c.city, c.organization, c.position, "
            " c.email, c.login, c.pic_url as customer_pic_url, "
            " d.doc_description_id, d.dir_type_id "
          "from directory as d, document as doc, customer as c"
          " where "
            " d.deleted = false "
            " and doc.dir_id = d.id "
            " and doc.published = true "
            " and doc.doc_type_id = $2 "
            " and d.updater = c.id "
            " and d.parent_dir_id = $1"
            " and d.parent_dir_id != d.id;",
    dao:simple(Q1, [utils:to_integer(Parent_dir_id), ?DESCR_ID]).


getConfs({Parent_dir_id}) ->
    Q1 = "select directory.id, directory.name, directory.parent_dir_id " ","
            " directory.datatime, directory.updater " ","
            " conference.start as start, "
            " conference.stop as stop, "
            " directory.doc_description_id, directory.dir_type_id "
          "from directory, conference "
          " where directory.deleted = false "
            " and directory.Parent_dir_id = $1"
            " and conference.conf_id = directory.id "
            " and directory.Parent_dir_id != id;",
    dao:simple(Q1, [utils:to_integer(Parent_dir_id)]).


getTestsSubDirs({Type}) ->
    Q1 = " select c.id, c.name, c.parent_dir_id " ","
            " c.datatime, c.updater " ","
            " c.doc_description_id, c.dir_type_id "
        " from "
            " directory as d  " ","
            " directory as c  " ","
            " dir_type  as dt "
        " where "
            " d.dir_type_id = dt.id "
            " and c.deleted = false "
            " and c.parent_dir_id = d.id "
            " and dt.name = $1; ",
    dao:simple(Q1, [utils:to_string(Type)]).

getTestsCntSubDirs({Type}) ->
    Q1 = " select "
            " count(d) "
        " from "
            " directory as d  " ","
            " directory as c  " ","
            " dir_type  as dt "
        " where "
            " d.dir_type_id = dt.id "
            " and c.deleted = false "
            " and c.parent_dir_id = d.id  "
            " and dt.name = $1; ",
    dao:simple(Q1, [utils:to_string(Type)]).

%%
%% Возвращает список поддиректорий для Parent_dir_id
%%     и количество их поддериктоий
%%
getDirsCntSubDirs({Parent_dir_id}) ->
    Q1 = " select "
                " pd.id " ","
                " pd.name " ","
                " count(cd.*) as cnt "
            " from " 
                " directory as pd "
            " left join "
                " directory as cd "
            " on "
                " pd.parent_dir_id = $1 and "
                " pd.parent_dir_id != pd.id and "
                " cd.parent_dir_id = pd.id "
            " where "
                " pd.parent_dir_id = $1 and "
                " pd.id != pd.parent_dir_id "
            " group by "
                " pd.id " ","
                " pd.name "
            " order by id; ",
    dao:simple(Q1, [utils:to_integer(Parent_dir_id)]).

%%
%% Возвращает директорию с описанием (content).
%%

getDir(Id) ->
    Q1 = "select "
            " directory.id, directory.name, directory.parent_dir_id " ","
            " directory.datatime, directory.updater " ","
            " directory.doc_description_id, directory.dir_type_id " ","
            " document.content as content, "
            " document.pic_url as pic_url "
         "from directory, document "
         "where "
            " directory.id = $1 "
            " and directory.deleted = false "
            " and document.dir_id = directory.id "
            " and document.doc_type_id = $2; ",

    dao:simple(Q1, [utils:to_integer(Id), ?DESCR_ID]).

getDir2(Id) ->
    Q2 = "select "
            " directory.id, directory.name, directory.parent_dir_id, "
            " directory.datatime, directory.updater, directory.doc_description_id, directory.dir_type_id, "
            " document.content as content, document.pic_url as pic_url "
         "from directory join document on document.id = directory.doc_description_id "
         "where "
            " directory.id = $1 "
            " and directory.deleted = false;",

    dao:simple(Q2, [utils:to_integer(Id)]).



test1() ->
    utils:test(fun() ->
        getDir(3)
    end, 1000),
    utils:test(fun() ->
        getDir2(3)
    end, 1000).


getDirA(Id) ->
    case getDir2(Id) of
        {ok, [R1ValS]} ->
            Doc_description_id = proplists:get_value("doc_description_id", R1ValS),
            Q2 = "select "
                ?ATTACHE_COMMON
                "  from attach2doc "
                "where doc_id  = $1",
                io:format(":::~p~n", [Doc_description_id]),
            case dao:simple(Q2, [utils:to_integer(Doc_description_id)]) of
                {ok, R2Val} ->  {ok, [R1ValS], R2Val};
                E2 -> E2
            end;
        {ok, []} -> [];
        E1 -> E1
    end.

getDirA2(Id) -> %TODO FIX double queue
    Q = "select "
        ?ATTACHE_COMMON
        " from attach2doc join directory on attach2doc.doc_id=directory.doc_description_id "
        "where directory.id = $1 and directory.deleted = false;",
    case dao:simple(Q, [Id]) of
        {ok, Ret} -> {ok, [], Ret};
        Error -> 
            flog:error([{error, getDirA2, Error}]),
            []
    end.

test3() ->
    utils:test(fun() ->
        getDirA(3)
    end, 1000),
    utils:test(fun() ->
        getDirA2(3)
    end, 1000).



getConfA(Id) ->
    Q1 = " select directory.id, directory.name, directory.parent_dir_id, "
        " directory.datatime, directory.updater, "
        " directory.doc_description_id, directory.dir_type_id, "
        " conference.start as start, "
        " conference.stop as stop, "
        " document.content as content "
        " from directory, conference, document "
        " where "
            " directory.id = $1 "
                " and conference.conf_id = directory.id "
                " and document.dir_id = directory.id "
                " and document.doc_type_id = $2; ",
                
    io:format("Q1 = ~p~n", [Q1]),
    Res  = dao:simple(Q1, [utils:to_integer(Id), ?DESCR_ID]),
%    io:format("Res = ~p~n", [Res]),
    case Res   of
        {ok, R1Val} ->
            [R1ValS] = R1Val,
            Doc_description_id = proplists:get_value("doc_description_id", R1ValS),
            Q2 = "select "
                ?ATTACHE_COMMON
                "  from attach2doc "
                "where doc_id  = $1",
            case dao:simple(Q2, [utils:to_integer(Doc_description_id)]) of
                {ok, R2Val} -> % {ok, R1Val, R2Val};
                    Q3 = "select cg.customer_id as id  from  "
                            " permission as p_conf,  "
                            " customer_group as c_group, "
                            " customer2group as cg, "
                            " permission2group as pg "
                        " where "
                            " p_conf.entity_id = $1 "
                            " and pg.perm_id = p_conf.id "
                            " and pg.group_id = c_group.id "
                            " and cg.group_id = c_group.id;",
%                    io:format("Q3 = ~p~n", [Q3]),
                    case dao:simple(Q3, [utils:to_integer(Id)]) of
                        {ok, R3Val} ->
                            {ok, R1Val, R2Val, [X || [{"id", X}] <- R3Val]};
                        E3 -> E3
                    end;
                E2 -> E2
            end;
        E1 -> E1
    end.



getHeadDir(Id) ->
    Q1 = "select "
            " directory.id, directory.name, directory.parent_dir_id " ","
            " directory.datatime, directory.updater " ","
            " directory.doc_description_id, directory.dir_type_id " ","
            " document.content as content, "
            " document.pic_url as pic_url "
         "from directory "
            "inner join document "
                "on directory.id = $1 "
            " and directory.deleted = false "
            " and document.dir_id = directory.id "
            " and document.doc_type_id = $2; ",
    dao:simple(Q1, [utils:to_integer(Id), ?DESCR_ID]).


%%
%% Возвращает описание директории
%%
getDocs({Dir_id, descr}) ->
    getDocs({Dir_id, ?DESCR_ID});

%%
%% Возвращает содержащиеся в директории news документы
%%
getDocs({news, doc}) ->
    getDocs({?NEWS_ID, ?DOC_ID });

getDocs({news, docs}) ->
    getDocs({?NEWS_ID, ?DOC_ID });
    
%%
%% Возвращает содержащиеся в директории документы
%%
getDocs({term, doc}) ->
    getDocs({?TERM_ID, ?DOC_ID, termin});

%%
%% Возвращает содержащиеся в директории документы
%%
getDocs({Dir_id, doc}) ->
    getDocs({Dir_id, ?DOC_ID});

getDocs({Dir_id}) ->
    getDocs({Dir_id, ?DOC_ID});

%%
%% 
%%
getDocs({Dir_id, Doc_type_id, termin}) ->
    Q1 = "select "
                ?DOC_MAIN_MIN ","
                ?DOC_PUD  ","
                ?DOC_URLS ","
                ?DOC_IDS  ","
                "quest_answer.correct_flag as correct_flag "
                
            "from document, directory, quest_answer "
            "where "
                "document.dir_id = directory.id "
                "and (directory.id = $1 or directory.parent_dir_id = $1) "
                "and quest_answer.answer_id = id "
                "and doc_type_id = $2 "
                " order by id asc "
                ";",
    dao:simple(Q1, [utils:to_integer(Dir_id), utils:to_integer(Doc_type_id)]);

getDocs({Dir_id, Doc_type_id, answer}) ->
    Q1 = "select "
                ?DOC_MAIN_MIN ","
                ?DOC_PUD  ","
                ?DOC_URLS ","
                ?DOC_IDS ","
            "from document, directory "
            "where "
                "document.dir_id = directory.id "
                "and (directory.id = $1 or directory.parent_dir_id = $1) "
                "and doc_type_id = $2 "
                " order by id asc "
                ";",
    dao:simple(Q1, [utils:to_integer(Dir_id), utils:to_integer(Doc_type_id)]);
    
%%
%% Возвращает содержащиеся в директории обощенные документы
%%
getDocs({Dir_id, Doc_type_id}) ->
    Q1 = "select"
                ?DOC_MAIN_MIN ","
                ?DOC_PUD  ","
                ?DOC_URLS ","
                ?DOC_IDS 
            "from document "
                "where " % deleted = false
                "   dir_id = $1"
                "   and published = true "
                "   and doc_type_id = $2"
                " order by datatime desc "
                ";",
    dao:simple(Q1, [utils:to_integer(Dir_id), utils:to_integer(Doc_type_id)]).

getDocsWithCustomer({Dir_id}) ->
    getDocsWithCustomer({Dir_id, ?DOC_ID});
    
getDocsWithCustomer({Dir_id, Doc_type_id}) ->
    Q1 = "select"
                ?DDOC_MAIN ","
                ?DDOC_PUD  ","
                ?DDOC_URLS ","
                ?DDOC_IDS ","
            " c.firstname, c.lastname, c.patronimic, "
            " c.city, c.organization, c.position, "
            " c.email, c.login, c.pic_url as customer_pic_url "
            "from document as d, customer as c "
                "where " % deleted = false
                "   d.updater = c.id "
                "   and d.published = true "
                "   and d.dir_id = $1 "
                "   and d.doc_type_id = $2 "
                " order by d.id asc "
                ";",
    dao:simple(Q1, [utils:to_integer(Dir_id), utils:to_integer(Doc_type_id)]).

getDocsWithCustomerA({Dir_id}) ->
    getDocsWithCustomerA({Dir_id, ?DOC_ID});

getDocsWithCustomerA({Dir_id, Doc_type_id}) ->
    {ok, Docs} = getDocsWithCustomer({Dir_id, Doc_type_id}),
    ExDoc = [
        lists:flatten([
            Doc | [{
                "attach", stripOk(dao_fDirectory, getAttaches, {proplists:get_value("id", Doc)})
            }]
        ])
        || Doc <- Docs
    ],    
    {ok, ExDoc}.

getAttaches({Doc_id}) ->
    Qselect = "select "
        " attach2doc.id, "
        " attach2doc.name, "
        " attach2doc.alt, "
        " attach2doc.doc_id, "
        " attach2doc.attach_type_id, "
        " attach2doc.url, "
        " attach2doc.updater "
        " from attach2doc "
        " where "
             " attach2doc.doc_id = $1",
    dao:simple(Qselect, [utils:to_integer(Doc_id)]).

%%
%% Рекурсивный обход подпапок и предоставдение списка документов.
%% Используется для отображения терминов.
%%
getDocsRecursive(Con, Id) ->
    Q1 = "select "
           ?DOC_MAIN ","
           ?DOC_PUD  ","            
           ?DOC_URLS ","
           ?DOC_IDS 
         "from document "
         " where document.dir_id = $1 "
           " and document.published = true; ",
           " and document.doc_type_id = 2 "
            " order by id asc "
            ";",
    {ok,FwdItem,DocList} = pgsql:equery(Con, Q1, [Id]),
    Q2 = "select directory.id "
            "from directory "
            " where "
              " directory.parent_dir_id = $1 "
              " and directory.deleted = false"
              " and directory.parent_dir_id != id; ",
    {ok,_,DirList} = pgsql:equery(Con, Q2, [Id]),
    ResList = lists:append([DocList, getDocsRecursiveRest(Con, DirList)]),
    {FwdItem, ResList}.

getDocsRecursiveRest(_, []) -> [];
getDocsRecursiveRest(Con, [{Id}|Rest]) ->
    {_, DocList} = getDocsRecursive(Con, Id),
    ResList = lists:append([DocList, getDocsRecursiveRest(Con, Rest)]),
    ResList.

getDocsRecursive_(Con, Id) ->
    {FwdItem, ResList} = getDocsRecursive(Con, Id),
    {ok, FwdItem, ResList}.

%%
%% Рекурсивный обход подпапок и предоставдение списка документов,
%%  которые начинаются с FirstLeter.
%%  Мы сознантельно не вводим параметр Condition, для таких случаев.
%%  Возмножно придется уменьшать число полей.
%%
getDocsRecursive(Con, Id, FirstLeter) ->
    Q1 = string:join([
        "select "
          ?DOC_MAIN ","
          ?DOC_PUD  ","
          ?DOC_URLS ","
          ?DOC_IDS 
        "from document "
        " where document.dir_id = $1"
           " and document.published = true "
           " and document.doc_type_id = 2 "
           " and document.name like '", FirstLeter ,"%'; "], ""),
    {ok,FwdItem,DocList} = pgsql:equery(Con, Q1, [Id]),
    Q2 = "select directory.id "
            "from directory "
            " where "
                " directory.parent_dir_id = $1 "
                " and directory.deleted = false"
                " and directory.parent_dir_id != id; ",
    {ok,_,DirList} = pgsql:equery(Con, Q2, [Id]),
    ResList = lists:append([DocList,
        getDocsRecursiveRest(Con, DirList, FirstLeter)]),
    {FwdItem, ResList}.

getDocsRecursiveRest(_, [], _) -> [];
getDocsRecursiveRest(Con, [{Id}|Rest], FirstLeter) ->
    {_, DocList} = getDocsRecursive(Con, Id, FirstLeter),
    ResList = lists:append([DocList,
        getDocsRecursiveRest(Con, Rest, FirstLeter)]),
    ResList.

getDocsRecursive_(Con, Id, FirstLeter) ->
    {FwdItem, ResList} = getDocsRecursive(Con, Id, FirstLeter),
    {ok, FwdItem, ResList}.

%%
%% Возвращает все документы директориии (общий случай)
%%
getDocsRecursive({Id}) ->
    Ret = dao:withTransactionMchs(fun(Con) -> getDocsRecursive_(Con, Id) end),
    dao:processPGRet2(Ret);

%%
%% Возвращает все документы директориии, которые начинаются с FirstLeter
%%
getDocsRecursive({Id, FirstLeter}) ->
    Ret = dao:withTransactionMchs(fun(Con) ->
        getDocsRecursive_(Con, Id, FirstLeter) end),
    dao:processPGRet2(Ret).

%%
%% 
%%
updateConfAnswer({{null, Name, Content}, {Dir_id}, UID}) ->
    Q1 =    "insert into document "
                "(name, content, dir_id, doc_type_id, updater, published) "
            "values ($1, $2, $3, $4, $5, true) returning document.id;",
    Ret = dao:withTransactionMchs(fun(Con) ->
            {ok, 1, _, [{DocId}]} = pgsql:equery(Con, Q1, [Name, Content, utils:to_integer(Dir_id), ?DOC_ID, UID])
        end),
    Result = dao:processPGRet2(Ret),
    {_, _, _, [{DocId}]} = Ret,
    DocId;

updateConfAnswer({{Id, Name, Content}, {Dir_id}, UID}) ->
    Q1 = "update document set "
                "name = $2, content = $3, "
                "dir_id = $4, doc_type_id = $5, "
                "updater = $6 , published = true "
            "where id = $1;",
    Ret = dao:withTransactionMchs(fun(Con) ->
            {ok, 1} = pgsql:equery(Con, Q1, [Id, Name, Content, utils:to_integer(Dir_id), ?DOC_ID, UID])
        end),
    Result = dao:processPGRet2(Ret),
    Result.

mergeDirs({CurrentId, ChoosenId}) ->
    Qselect  = "select id from document where doc_type_id = 2 and dir_id = $1",
    QupdateP = "update directory set parent_dir_id = $1 where id = $2;",
    QupdateC = "update directory set parent_dir_id = $1 where parent_dir_id  = $2;",

    Ret = dao:withTransactionMchs(fun(Con) ->
            case pgsql:equery(Con, Qselect, [CurrentId]) of
                {ok, _, []} ->
                    {ok, 1} = pgsql:equery(Con, QupdateP, [ChoosenId, CurrentId]),
                    {ok, _} = pgsql:equery(Con, QupdateC, [ChoosenId, CurrentId]);
                SSS -> io:format("=> (~p)~n~n~n~n~n~n", [SSS])
            end
        end),
    dao:processPGRet2(Ret).

updateConfQuestion({{null, Name, Content}, {Parent_dir_id}, UID}) ->
    io:format("~n~nupdateConfQuestion= ~s ~s~n~n", [Name, Content]),
    
    updateDir({{null, Name, Content, false}, {Parent_dir_id, ?DT_CONF_QUESTION_ID, null}, UID});

updateConfQuestion({{Id, Name, Content}, {Parent_dir_id, Doc_description_id}, UID}) ->
    updateDir({{Id, Name, Content, false}, {Parent_dir_id, ?DT_CONF_QUESTION_ID, Doc_description_id}, UID}).
    
updateDir({{null, Name, Content}, {Parent_dir_id, Dir_type_id, null}, UID}) ->
    Q1 =    "insert into directory "
                "(name, parent_dir_id, dir_type_id, updater, deleted) "
            "values ($1, $2, $3, $4, false) returning directory.id;",
    Q2 =    "insert into document "
                "(name, content, dir_id, doc_type_id, updater, published) "
            "values ($1, $2, $3, $4, $5, true) returning document.id;",
    Q3 =    "update directory set Doc_description_id  = $2,"
            " updater = $3 where id = $1;",
    Ret = dao:withTransactionMchs(fun(Con) ->
            {ok, 1, _, [{Dir_Id}]} = pgsql:equery(Con, Q1,
                [Name, Parent_dir_id, Dir_type_id, UID]),
            {ok, 1, _, [{Doc_Id}]} = pgsql:equery(Con, Q2,
                [?DESCR_NAME_PREFFIX ++ Name, Content, Dir_Id, ?DESCR_ID, UID]),
            {ok, 1} = pgsql:equery(Con, Q3, [Dir_Id, Doc_Id, UID])
        end),
    dao:processPGRet2(Ret);

updateDir({{null, Name, Content, Published}, {Parent_dir_id, Dir_type_id, null}, UID}) ->
    Q1 =    "insert into directory "
                "(name, parent_dir_id, dir_type_id, updater, deleted) "
            "values ($1, $2, $3, $4, false) returning directory.id;",
    Q2 =    "insert into document "
                "(name, content, dir_id, doc_type_id, updater, published) "
            "values ($1, $2, $3, $4, $5, $6) returning document.id;",
    Q3 =    "update directory set Doc_description_id  = $2,"
            " updater = $3 where id = $1;",
    Ret = dao:withTransactionMchs(fun(Con) ->
            {ok, 1, _, [{Dir_Id}]} = pgsql:equery(Con, Q1,
                [Name, Parent_dir_id, Dir_type_id, UID]),
            {ok, 1, _, [{Doc_Id}]} = pgsql:equery(Con, Q2,
                [?DESCR_NAME_PREFFIX ++ Name, Content, Dir_Id, ?DESCR_ID, UID, Published]),
            {ok, 1} = pgsql:equery(Con, Q3, [Dir_Id, Doc_Id, UID])
        end),
    dao:processPGRet2(Ret);

updateDir({{Id, Name, Content}, {Parent_dir_id, Dir_type_id, Doc_description_id}, UID}) ->
    %
    % Doc_description_id берется из аргументов. Так проще и быстрее.
    %      Иначе мы можем его вычислять по directory.id.
    %      Но считаем, что у директории уже есть описание.

    Q1 =    "update directory set name = $2, parent_dir_id = $3, "
                "dir_type_id = $4, doc_description_id = $5, updater = $6 "
            "where id = $1;",
    Q2 =    "update document set content = $2, updater = $3 "
            "where id = $1;",

    Ret = dao:withTransactionMchs(fun(Con) ->
            {ok, 1} = pgsql:equery(Con, Q1, [Id, Name, Parent_dir_id,
                Dir_type_id, Doc_description_id, UID]),
            {ok, 1} = pgsql:equery(Con, Q2, [Doc_description_id, Content, UID])
        end),
    dao:processPGRet2(Ret);
    
updateDir({{Id, Name, Content, Published}, {Parent_dir_id, Dir_type_id, Doc_description_id}, UID}) ->
    %
    % Doc_description_id берется из аргументов. Так проще и быстрее.
    %      Иначе мы можем его вычислять по directory.id.
    %      Но считаем, что у директории уже есть описание.

    Q1 =    "update directory set name = $2, parent_dir_id = $3, "
                "dir_type_id = $4, doc_description_id = $5, updater = $6 "
            "where id = $1;",
    Q2 =    "update document set content = $2, updater = $3, published = $4 "
            "where id = $1;",

    Ret = dao:withTransactionMchs(fun(Con) ->
            {ok, 1} = pgsql:equery(Con, Q1, [Id, Name, Parent_dir_id,
                Dir_type_id, Doc_description_id, UID]),
            {ok, 1} = pgsql:equery(Con, Q2, [Doc_description_id, Content, UID, Published])
        end),
    dao:processPGRet2(Ret).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Аттачи
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


updateAttach({null, Name, Alt, Doc_id,  Attach_type_id, Url, UID}) ->
    Q1 =    "insert into  attach2doc"
                "(name, alt, doc_id, attach_type_id, url, updater) "
            "values ($1, $2, $3, $4, $5, $6) returning attach2doc.id; ",
    
    Ret = dao:withTransactionMchs(fun(Con) ->
            {ok, 1, _, [{Id}]} = pgsql:equery(Con, Q1, [Name, Alt,
                utils:to_integer(Doc_id),
                utils:to_integer(Attach_type_id),
                Url, utils:to_integer(UID)]),
            put("id", Id),
            io:format("Id = ~p~n", [Id])
        end),
    io:format("Ret = ~p~n", [Ret]),
    {dao:processPGRet2(Ret), get("id")}.
