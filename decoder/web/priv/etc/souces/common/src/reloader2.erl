-module(reloader2).

-export([reload_code/0]).

reload_code() ->
    try
      Reload = fun(M) ->
                   code:purge(M),
                   code:soft_purge(M),
                   {module, M} = code:load_file(M),
                   {ok,M}
               end,
%      Modules = [M || {M,P} <- code:all_loaded(),
%                               is_list(P) andalso
%                               string:str(P, filename:absname(""))>0],
      Modules = modified_modules(),
      {ok, lists:sort([Reload(M) || M <- Modules])}
    catch
  Cls:Why -> {error, {Cls,Why}}
    end.

modified_modules() ->
    [M || {M, P} <- code:all_loaded(),
                    is_list(P),
                    string:str(P, filename:absname(""))>0,
                    module_modified(M) == true].

module_modified(Module) ->
    case code:is_loaded(Module) of
  {file, preloaded} ->
      false;
  {file, Path} ->
      CompileOpts = proplists:get_value(compile, Module:module_info()),
      CompileTime = proplists:get_value(time, CompileOpts),
      Src = proplists:get_value(source, CompileOpts),
      module_modified(Path, CompileTime, Src);
  _ ->
      false
    end.

module_modified(Path, PrevCompileTime, PrevSrc) ->
    case find_module_file(Path) of
  false ->
      false;
  ModPath ->
      {ok, {_, [{_, CB}]}} = beam_lib:chunks(ModPath, ["CInf"]),
      CompileOpts = binary_to_term(CB),
      CompileTime = proplists:get_value(time, CompileOpts),
      Src = proplists:get_value(source, CompileOpts),
      not ((CompileTime == PrevCompileTime) and (Src == PrevSrc))
    end.

find_module_file(Path) ->
    case file:read_file_info(Path) of
  {ok, _} ->
      Path;
  _ ->
      %% may be the path was changed?
      case code:where_is_file(filename:basename(Path)) of
    non_existing ->
        false;
    NewPath ->
        NewPath
      end
    end.
