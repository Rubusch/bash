#!/bin/bash
#
# author: Lothar Rubusch
# email: L.Rubusch@gmx.ch
# 11/2013 - GPL v3
#
# TODO implement smart algorithm for long latencies
# TODO implement smart algorithm for MISSes
# TODO upper bounds for addition / subtractions shall be upper product of both
# TODO display picture
# TODO display running time

# DEBUG
#set -x

## user settings
OPERATIONS=(
#    "add"
#    "subtract"
    "multiply"
    "divide"
)
MAXNUMBER=100
MAXTIME=0 # default max time in secs

# e.g. 5 min
let "MAXTIME=5*60"
                                                                                
## default settings
PID=""
A=0
B=0
RES=""

                                                                                
die()
{
    echo "$@"

    ## terminate children, if there are..
    if [ "${PID}" != "" ]; then
        if [ "$(ps | grep ${PID})" != "" ]; then
            sendkill
        fi
    fi

    exit
}

usage()
{
cat <<EOF
Calculation Trainer
usage: ./$0 or ./$0 <max time in secs>
In case set which operations, max values in the header of the script.
Have Fun!

EOF
}

sendkill()
{
    ## don't wait on timeout -> 9
    kill -9 ${PID} > /dev/null
    PID=""
}

stop()
{
    echo
    echo "Timeout"
    echo
    echo "hits:   ${HIT}"
    echo "misses: ${MISS}"
    exit
}

                                                                                

## user input
foreground()
{
    PID=${1}

    ## die by user (INT) or TERM
    trap "die" TERM INT

    ## prepare for output for timeout
    MISS=0
    HIT=0
    trap "stop" HUP

    while true; do
        ## ask
        calculate

        ## evaluate answer
        local guess=""
        read guess
        if [ "${guess}" == "${RES}" ]; then
            let "HIT=${HIT}+1"
        else
            echo "WRONG, correct is: ${RES}"
            let "MISS=${MISS}+1"
        fi
    done

    ## regular termination
    die "READY."
}

                                                                                

## background
background()
{
    PID=${1}

    if test -n "${2}"; then
# TODO check if ${2} valid number
        echo "MAXTIME set to '${2}'"
        MAXTIME=${2}
    fi

    trap "die" TERM

    ## timeout
    sleep $MAXTIME
    kill -HUP ${PID}
}

                                                                                
calculate()
{
#    # get two valid numbers
#    local a=${OLDA} # no duplicates
#    while test ${a} -eq ${OLDA}; do
#        a=$(expr $RANDOM \% ${MAXNUMBER} ) # [0;9]
#        let "a=${a}+1" # [1;10]
#    done
#    OLDA=${a}

#    local b=${OLDB} # no duplicates
#    while test ${b} -eq ${OLDB}; do
#        b=$(expr $RANDOM \% ${MAXNUMBER} ) # [0;9]
#        let "b=${b}+1" # [1;10]
#    done
#    OLDB=${b}

    # operation
    local nops=${#OPERATIONS[*]}
    local op=$(expr ${RANDOM} \% ${nops} )
#    ${OPERATIONS[${op}]} $a $b
    ${OPERATIONS[${op}]}
}

number()
{
    local old=${1}
    local val=${old}
    local max=${2}

    while test ${val} -eq ${old}; do
        val=$(expr $RANDOM \% ${max} ) # [0;9]
        let "val=${val}+1" # [1;10]
    done
    echo ${val}
}

                                                                                
# operations

add()
{
#    local a=$1
#    local b=$2
    A=$(number ${A} ${MAXNUMBER})
    B=$(number ${B} ${MAXNUMBER})
    echo -n "${A} + ${B} = "
    let "RES=${A}+${B}"
}

subtract()
{
#    local a=$1
#    local b=$2
    A=$(number ${A} ${MAXNUMBER})
    B=$(number ${B} ${MAXNUMBER})
    if (( ${A} < ${B} )); then
        tmp=${A}
        A=${B}
        B=${tmp}
    fi
    echo -n "${A} - ${B} = "
    let "RES=${A}-${B}"
}

multiply()
{
#    local a=$1
#    local b=$2
set -x
    A=$(number ${A} ${MAXNUMBER})
    B=$(number ${B} ${MAXNUMBER})
die "XXX"
    echo -n "${A} * ${B} = "
    let "RES=${A}*${B}"
}

divide()
{
#    local a=$1
#    local b=$2
    A=$(number ${A} ${MAXNUMBER})
    B=$(number ${B} ${MAXNUMBER})

    if [ ${A} == 0 ]; then
        die "divide() - denominator was 0"
    fi

    local c=0
    let "c=${A}*${B}"

    echo -n "${c} : ${B} = "
    RES=${A}
}


                                                                                
## main
if [ "x${1}" == "xRun" ]; then
    background ${2} ${3} # timer
else
    # bash <0:name> <1:string> <2:parent PID> <3:opt: MAXTIME>
    bash $0 Run $$ ${1} &
    usage
    foreground $!
fi

