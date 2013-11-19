#!/bin/bash

#set -x

PID=""
RES=""

sendkill()
{
    kill -15 ${PID} > /dev/null
    PID=""
}

die()
{
    echo "die"
    echo $@
    exit
}

stop()
{
    echo "stop"
    echo $RES  
    exit
}

                                                                                

## user input
foreground()
{
    PID=${1}
    echo "foreground - child PID '$PID', own is $$"   

    ## die by user (INT) or TERM
    trap "die" TERM INT

    ## react on timeout
    trap "stop" HUP


    
    calculate
    
#    read -s -n 1 key  
    read key
    echo $RES  
    

    ## end of game
    if [ "${PID}" != "" ]; then  
# TODO check if pid is still valid
        sendkill
    fi
}

                                                                                

## background
background()
{
    PID=${1}
#    echo "background - parent PID '$PID', own is $$"   

    trap "die" TERM

    ## timeout
    sleep 10 # 10 secs
    kill -HUP ${PID}
# TODO communicate timeout   


    ## full stop
    sendkill
    die
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
    echo
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


                                                                                
echo "XXX '$1' '$2'"
## main
if [ "x${1}" == "xRun" ]; then
    background $2
else
    bash $0 Run $$ &
    foreground $!
fi

echo "READY."
