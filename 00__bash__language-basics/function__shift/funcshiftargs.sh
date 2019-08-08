#!/bin/bash
##
## demostrates shift of function arguments
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3

func()
{
    echo "num, before '$#'"

    if [[ "$#" -gt 1 ]]; then
        local var=$1
        echo "shift"
        shift
    fi
    local other_var=$1

## now shift
    echo "shift"
    shift

    echo "num, after '$#'"
    echo

    echo "var '$var', leaves this empty if no 'var' was defined"
    echo "other var '$other_var'"
    echo
}

## call

func "a"


func "a" "-b"


echo "READY."
echo


