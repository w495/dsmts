-module(userLdapDAO).
-compile(export_all).

-include("../include/common.hrl").

getAllUsers() ->
    F = fun(Handle) -> 
        eldap:search(Handle, [{base, "ou=People,o=AVProjects"}, 
                                {scope, eldap:wholeSubtree()}, 
                                {filter, eldap:'and'([  eldap:equalityMatch("objectclass", "posixAccount"), 
                                                        eldap:equalityMatch("objectclass", "account")])}])
    end,
    {ok,{eldap_search_result, UList, _X3}} = ldapCP:ldapQueue(F),
    [[{"eldap_entry", EVal} | proplists:delete("userPassword",X2)] || {eldap_entry, EVal, X2} <- UList].


getUserByLogin(Login) ->
    F = fun(Handle) ->
            eldap:search(Handle, [  {base, "ou=People,o=AVProjects"},
                                    {scope, eldap:wholeSubtree()},
                                    {filter, eldap:'and'([  eldap:equalityMatch("objectclass", "posixAccount"),
                                                            eldap:equalityMatch("objectclass", "account"),
                                                            eldap:equalityMatch("uid", Login)])}])
    end,
    {ok,{eldap_search_result, UList, _X3}} = ldapCP:ldapQueue(F),
    case UList of
        [{eldap_entry, _, Params}] -> {Params, null};
        _ -> null
    end.

getUserByEntry(Login) ->
    F = fun(Handle) ->
            eldap:search(Handle, [  {base, Login},
                                    {scope, eldap:baseObject()},
                                    {filter, eldap:'and'([  eldap:equalityMatch("objectclass", "posixAccount"),
                                                            eldap:equalityMatch("objectclass", "account")])}])
    end,
    {ok,{eldap_search_result, UList, _X3}} = ldapCP:ldapQueue(F),
    [[{"eldap_entry", EVal} | proplists:delete("userPassword",X2)] || {eldap_entry, EVal, X2} <- UList].


updateUser({null, Login, Password}) ->
    PassHash = base64:encode_to_string(binary_to_list(erlang:md5(Password))), 
    PVal = ?FMT("{MD5}~s",[PassHash]),
    F = fun(Handle) ->
        eldap:add(Handle, ?FMT("uid=~p,ou=People,o=AVProjects", [Login]), [ {"objectclass", ["posixAccount", "account"]},
                                                                            {"cn", [Login]},
                                                                            {"gidNumber", ["10000"]},
                                                                            {"homeDirectory", ["/home/avuser"]},
                                                                            {"uidNumber", ["10000"]},
                                                                            {"uid", [Login]},
                                                                            {"userPassword", [PVal]}])
    end,
    ldapCP:ldapQueue(F);
updateUser({Entry, Login, Password}) ->
    Mod1 = [eldap:mod_replace("cn", [Login])],
    if 
        Password =/= null ->
            PassHash = base64:encode_to_string(binary_to_list(erlang:md5(Password))),
            PVal = ?FMT("{MD5}~s",[PassHash]),
            Mod2 =  [eldap:mod_replace("userPassword", [PVal]) | Mod1];
        true ->
            Mod2 = Mod1
    end,

    F = fun(Handle) ->
        eldap:modify(Handle, Entry, Mod2)
    end,
    ldapCP:ldapQueue(F).

deleteUser(Entry) ->
    F = fun(Handle) -> eldap:delete(Handle, Entry) end,
    ldapCP:ldapQueue(F).
