#!/bin/sh

PATH=$PATH:/usr/local/lib/
export PATH

NODENAME="web@localhost"
CONFIG=web

ERL_ARGS="+K true +A 128 +P 1000000"

ERL_MAX_ETS_TABLES=140000
export ERL_MAX_ETS_TABLES

echo "**************************************" 
LOCALLBINPATH=`find ./ebin -type d -printf '%h/%f '`
OTHERBINPATH="./deps/*/ebin"
BINPATH=${LOCALLBINPATH}${OTHERBINPATH}
erl \
    -pa $BINPATH \
    -boot start_sasl \
    -config ${CONFIG} \
    -sname ${NODENAME} \
    -s reloader \
    +native \
    -s web \
    -mnesia dir "db" \
    ${ERL_ARGS} \
    "$@"
