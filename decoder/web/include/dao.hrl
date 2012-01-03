
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% %
% %     Возможно стоит описать селектами, но так было удобнее.
% %

%%
%% Глобальные папки 
%%

-define(KEY_ID,         1). % Новости
-define(NEWS_ID,        2). % Новости
-define(REG_ID,         3). % Нормативные документы
-define(SECURE_ID,      4). % Безопасность на транпорте
-define(CONF_ID,        5). % Конференции
-define(TEST_ID,        6). % Тесты
-define(TERM_ID,        7). % Термины

%%
%% ----------------------------------------
%%

-define(DT_NEWS_ID,                  1). 
-define(DT_SUBDIR_ID,                2). 
-define(DT_KEY_ID,                   3). 
-define(DT_ROOT_TEST_ID,             4). 
-define(DT_ROOT_TEST_SURFACE_ID,     5). 
-define(DT_ROOT_TEST_AIR_ID,         6). 
-define(DT_ROOT_TEST_WATER_ID,       7). 
-define(DT_TEST_ID,                  8). 
-define(DT_TEST_QUESTION_ID,         9). 
-define(DT_ROOT_CONFERENCE_ID,      10). 
-define(DT_CONFERENCE_ID,           11). 
-define(DT_CONF_QUESTION_ID,        12). 
-define(DT_CONF_ANSW_ID,            13). 
-define(DT_TERM_ID,                 14). 
-define(DT_TERM_AIR_ID,             15). 
-define(DT_TERM_SURFACE_ID,         16). 
-define(DT_TERM_WATER_ID,           17). 


%%
%% ----------------------------------------
%%

-define(HEAD_ID,        11). % 
-define(AIR_ID,         12). % 
-define(WATER_ID,       13). % 
-define(SURFACE_ID,     14). % 

%%
%% Виды терминов
%%

-define(T_ALL,      0).
-define(T_AIR,      1).
-define(T_WATER,    2).
-define(T_SURFACE,  3).



-define(DESCR_ID,       1).
-define(DOC_ID,         2).

% % % % % % % % % % % % % % % % % %

-define(DESCR_NAME_PREFFIX,  "Описание директории --- ").

%% % % % % % % % % % % % % % % % % %% % % % % % % % % % % % % % % % %
%% 
%% Основные описания полей для документа
%%

-define(DOC_MAIN,   " document.id, document.name, document.content ").

-define(DOC_MAIN_MIN,   " document.id, document.name ").

-define(DOC_URLS,   " document.pdf_url, document.msw_url, document.pic_url ").
-define(DOC_PUD,    " document.published, document.updater, document.datatime ").
-define(DOC_IDS,    " document.dir_id, document.doc_type_id ").


-define(DDOC_MAIN,   " d.id,        d.name,     d.content ").

-define(DDOC_MAIN_MIN,   " d.id,        d.name ").

-define(DDOC_URLS,   " d.pdf_url,   d.msw_url,  d.pic_url ").
-define(DDOC_PUD,    " d.published, d.updater,  d.datatime ").
-define(DDOC_IDS,    " d.dir_id,    d.doc_type_id ").

-define(DOC_COMMON, ?DOC_MAIN "," ?DOC_PUD  "," ?DOC_URLS "," ?DOC_IDS ).

%% % % % % % % % % % % % % % % % % %% % % % % % % % % % % % % % % % %
%% 
%% Основные описания полей для аттача
%%

-define(ATTACHE_COMMON, " attach2doc.id " " , " 
                        " attach2doc.name " " , " 
                        " attach2doc.alt " " , "
                        " attach2doc.doc_id " " , "
                        " attach2doc.attach_type_id" " , "
                        " attach2doc.url " " , "
                        " attach2doc.updater " ).