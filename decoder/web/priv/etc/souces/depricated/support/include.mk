## -*- makefile -*-

######################################################################
## Erlang

ERL := erl
ERLC := $(ERL)c

INCLUDE_DIRS := ../include $(wildcard ../deps/*/include)
DEPS_EBIN_DIRS := $(wildcard ../deps/*/ebin)

#ifndef no_debug_info
#  ERLC_FLAGS += +debug_info
#endif

ROOT_DIRECTORY=.
SRC_DIRS := ${shell find ${ROOT_DIRECTORY} -type d -print}

EBIN_DIR := ../ebin
DOC_DIR  := ../doc
EMULATOR := beam

SRC_DIRS_WOPREFIX := $(SRC_DIRS:./%=%)

ERL_SOURCES_WITHDIR := ${foreach dir,${SRC_DIRS_WOPREFIX},$(wildcard ${dir}/*.erl)}
#ERL_SOURCES_WITHDIR := $(ERL_SOURCES_WITHDIR_AND_PREFIX:./%=%)
ERL_SOURCES := $(notdir ${ERL_SOURCES_WITHDIR})
ERL_HEADERS := $(wildcard *.hrl) $(wildcard ../include/*.hrl)
ERL_SOURCES_WITHDIR_WOPREFIX := $(ERL_SOURCES_WITHDIR:./%=%)
ERL_OBJECTS_WITHDIR := $(ERL_SOURCES_WITHDIR_WOPREFIX:%.erl=$(EBIN_DIR)/%.$(EMULATOR))
ERL_OBJECTS := $(ERL_SOURCES:%.erl=$(EBIN_DIR)/%.$(EMULATOR))
ERL_DOCUMENTS := $(ERL_SOURCES:%.erl=$(DOC_DIR)/%.html)
ERL_OBJECTS_LOCAL := $(ERL_SOURCES:%.erl=./%.$(EMULATOR))
APP_FILES := $(wildcard *.app)

EBIN_DIRS := $(SRC_DIRS_WOPREFIX:%=$(EBIN_DIR)/%)

#EBIN_FILES = $(ERL_OBJECTS) $(ERL_DOCUMENTS) $(APP_FILES:%.app=../ebin/%.app)

EBIN_FILES = $(ERL_OBJECTS_WITHDIR) $(APP_FILES:%.app=../ebin/%.app)
EBIN_FILES_NO_DOCS = $(ERL_OBJECTS_WITHDIR) $(APP_FILES:%.app=../ebin/%.app)
MODULES = $(ERL_SOURCES:%.erl=%)

../ebin/%.app: %.app
	cp $< $@


ERLC_FLAGS := -W $(INCLUDE_DIRS:../%=-I ../%) 
#$(DEPS_EBIN_DIRS:%=-pa %) $(SRC_DIRS_WOPREFIX:%=-pa ./%)
ifeq ($(DEBUG), -DDEBUG)
  ERLC_FLAGS += -Ddebug +debug_info
endif



$(EBIN_DIR)/%.$(EMULATOR): %.erl
	$(ERLC) $(ERLC_FLAGS) -o $(@D) $<
#	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR)/$(@D) $<
#	echo $(@D)

./%.$(EMULATOR): %.erl
	$(ERLC) $(ERLC_FLAGS) -o . $<

$(DOC_DIR)/%.html: %.erl
	$(ERL) -noshell -run edoc file $< -run init stop
	mv *.html $(DOC_DIR)
