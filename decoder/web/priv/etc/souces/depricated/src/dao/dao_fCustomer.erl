%%% @file dao_fCustomer.erl
%%%
%%%     Доступ к данным для сущности пользователя.
%%%     Описаны опирации с пользователями, группами и правами.
%%%     Версия для внешнего сайта.
%%%     Отображается только то, что существуюет и разрещено явно.
%%%

-module(dao_fCustomer).
-compile(export_all).

getCustomer(Id) ->
    Q1 = "select customer.id, "
                "customer.firstname, customer.lastname, customer.patronimic, "
                "customer.city, customer.organization, customer.position, "
                "customer.email, customer.login, customer.pic_url, customer.password_hash "
            "from customer where customer.id=$1;",
    case dao:simple(Q1, [utils:to_integer(Id)]) of
        {ok, R1Val} ->
            Q2 = "select group_id from customer2group where customer_id = $1",
            case dao:simple(Q2, [utils:to_integer(Id)]) of
                {ok, R2Val} -> {ok, R1Val, [X || [{"group_id", X}] <- R2Val]};
                E2 -> E2
            end;
        E1 -> E1
    end.

%%
%% Создает нового пользователя
%%
updateCustomer({{null, Firstname, Lastname, Patronimic, Login, Email, City,
                    Organization, Position}, Password_hash, GroupList, UID}) ->
    Q1 = "insert into customer (firstname, lastname, patronimic, "
            "login, email, city, organization, position, password_hash) "
         "values ($1, $2, $3, $4, $5, $6, $7, $8, $9) returning customer.id;",
         
    PGRet = dao:withTransactionMchs(
        fun(Con) ->
            {ok, 1, _, [{Id}]} = pgsql:equery(Con, Q1,
                [Firstname, Lastname, Patronimic, Login, Email,
                    City, Organization, Position, Password_hash]),
            io:format("New CustomerID: ~p~n", [Id]),
            case length(GroupList) of
                0 ->
                    ok;
                L ->
                    Q2 = "insert into customer2group (customer_id, group_id) values " ++
                        string:join([lists:flatten(io_lib:format("(~p, ~p)",
                            [Id, X])) || X <- GroupList], ", "),
                    {ok, L} = pgsql:equery(Con, Q2, [])
            end,
            {return, Id}
        end
    ),
    dao:processPGRet2(PGRet);

%%
%% Изменяет существующего пользователя
%%
updateCustomer({{Id, Firstname, Lastname, Patronimic, Login, Email, City,
                    Organization, Position}, Password_hash, GroupList, UID}) ->

    Q1 = "update customer set firstname = $1, lastname = $2, patronimic = $3, "
            "login = $4, email = $5,"
            "city = $6, organization = $7, position = $8 "
         "where id=$9;",

    Q2 = "delete from customer2group where customer_id = $1;",
    Q3 = "insert into customer2group (customer_id, group_id) values " ++ 
            string:join([lists:flatten(io_lib:format("(~p, ~p)",
                [Id, X])) || X <- GroupList], ", "),

    PGRet = dao:withTransactionMchs(
        fun(Con) ->
             {ok, 1} = pgsql:equery(Con, Q1,
                    [Firstname, Lastname, Patronimic, Login,
                        Email, City, Organization, Position, Id]),
             if Password_hash =/= null ->
                    {ok, 1} = pgsql:equery(Con, "update customer set password_hash=$1 "
                        "where id = $2;", [Password_hash, Id]);
                true ->
                    ok
             end,
             {ok, _} = pgsql:equery(Con, Q2, [Id]),
             case length(GroupList) of
                0 -> ok;
                L -> {ok, L} = pgsql:equery(Con, Q3, [])
            end,
            ok
        end
    ),
    dao:processPGRet2(PGRet).


updateTest2Customer({Customer_id, Test_id, Result}) ->
    Q = "insert into test2customer (customer_id, test_id, result) "
            "values ($1, $2, $3) returning test2customer.id;",
    dao:simple(Q, [utils:to_int(Customer_id), utils:to_int(Test_id), utils:to_int(Result)]).


getTest2CustomerLastRes({Customer_id, Test_id}) ->
    Q = "select result from test2customer where customer_id = $1 and test_id = $2 order by id desc limit 1;",
    {ok, Result} = dao:simple(Q, [utils:to_int(Customer_id), utils:to_int(Test_id)]),
    Result. 


