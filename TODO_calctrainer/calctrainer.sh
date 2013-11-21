#!/bin/bash

#set -x

PID=""
RES=""

sendkill()
{
    ## don't wait on timeout -> 9
    kill -9 ${PID} > /dev/null
    PID=""
}

die()
{
    echo "$@"

    ## terminate children, if there are..
    if [ "${PID}" != "" ]; then
        if [ "$(ps | grep ${PID})" != "" ]; then
            sendkill
        fi
    fi

    ## end
    exit
}

stop()
{
    echo "Timeout"
    echo "hits: '$HIT', misses: '$MISS'"  
#    echo $RES  
    exit
}

                                                                                

## user input
foreground()
{
    PID=${1}
#    echo "foreground - child PID '$PID', own is $$"   

    ## die by user (INT) or TERM
    trap "die" TERM INT

    ## prepare for output for timeout
    MISS=0
    HIT=0
    trap "stop" HUP

    while true; do

        calculate

        local key=""
        read key  
        if [ "${key}" != "" ]; then
            if (( ${key} == ${RES} )); then # FIXME compare 2 numbers... 
                HIT=$(expr $HIT + 1)
            else
                echo "${RES} ###"
                MISS=$(expr $MISS + 1)
            fi
        else
            echo "${RES} ###"
            MISS=$(expr $MISS + 1)
        fi
    done



    ## regular termination
    die "READY."
}

                                                                                

## background
background()
{
    PID=${1}

    trap "die" TERM

    ## timeout
    sleep 10 # 10 secs
    kill -HUP ${PID}
# TODO communicate timeout   
}

                                                                                
calculate()
{
    add 1 1
#    subtract 1 1
#    multiply 1 1
#    divide 1 1
}

add()
{
    a=$1
    b=$2
    echo -n "${a} + ${b} = "
    RES=$(expr $a + $b)
}

subtract()
{
    a=$1
    b=$2
    echo -n "${a} - ${b} = "
    RES=$(expr $a - $b)
    echo
}

multiply()
{
    a=$1
    b=$2
    echo -n "${a} * ${b} = "
    RES=$(expr $a \* $b)
    echo
}

divide()
{
    echo "${1} : ${2} = "
    RES=$(expr ${1} / ${2})
}


                                                                                
## main
if [ "x${1}" == "xRun" ]; then
    background $2
else
    bash $0 Run $$ &
    foreground $!
fi

