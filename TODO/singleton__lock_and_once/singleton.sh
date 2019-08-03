#!/bin/bash
## a not 100% safe apporach to ensure a script has only one (or few) instance
## running :)
##
## start w/o any arguments shows usage!
##
## reset option kills all instances of the script, and removes any locks
##
## issues
##
## when locking, race condition can appear, this may lead to a run of more than
## one instances
##
## when killing, a pid might be assigned to another process in meantime, which
## eventually may be killed in case of an unlucky reset (never execute this as
## root!)
##
## as quick'n dirty solution, where the worst case scenarios aren't dangerous,
## e.g. sufficient to reduce fireworks on incron jobs...
##
## anyway for safer approaches check out flock
set -C # do not overwrite existing files, using > or use >| to force overwriting

LOCKFILE=/var/lock/$(basename ${0}).lock

## keep active for how many secs?
SLEEP=10


# DEBUG
#set -x    

die ()
{
    echo $@
    exit
}

reset()
{
    if [ "${RUNNING}" == "running" ]; then
        rm -f "${LOCKFILE}"
    fi
}

usage()
{
cat << EOF
usage $0 [run|reset]

        run
                try to lock (singleton mode), if it fails exit

        reset
                reset and remove any locks explicitely

        help
                show this help
EOF
}

sendkill()
{
    for item in $@; do
        if [ ${item} != "$$" ]; then
            kill -9 ${item} &> /dev/null
        fi
    done
}

## trap SIGINT, SIGTERM, SIGEXIT - will fail on SIGKILL!!
trap "reset; exit" INT TERM EXIT

## arg: empty -> EXIT
if [ "${1}" == "" ]; then
    usage
    exit
fi

## arg: RESET -> EXIT and reset
arg="$(echo "${1}" | tr '[A-Z]' '[a-z]')"
if [ "reset" == "${arg}" ]; then
    RUNNING="running"
    sendkill "$(ps -e | grep "$(basename ${0})" | awk '{ print $1}')"
    exit
fi

## check lock
if [ -e ${LOCKFILE} ]; then
    exit
fi

## arg: not run -> EXIT
if [ "run" != "${arg}" ]; then
    usage
    exit
fi

## arg: RUN

## lock
#touch ${LOCKFILE} || die
echo $$ > ${LOCKFILE}
RUNNING="running"

## ensure all events within last 5 minute only trigger the script ONCE
sleep ${SLEEP}

## execution at the end
echo "TODO" # TODO   

## unlock
reset
echo "READY."
