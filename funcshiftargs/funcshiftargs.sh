#!/bin/bash

func()
{
    echo "num, before '$#'"

    if [[ "$#" -gt 1 ]]; then
        local var=$1
        shift
    fi
    local other_var=$1
    shift

    echo "num, after '$#'"
    echo "var '$var', leaves this empty if no 'var' was defined"
    echo "other var '$other_var'"
    echo
}

## call

func "a"


func "a" "-b"


echo "READY."
echo


