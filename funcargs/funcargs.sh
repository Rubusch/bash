#!/bin/bash

func()
{
    local var1=${1}
    local var2=${2}
    local var3=${3}

    echo "passed: "
    echo "1 '${var1}'"
    echo "2 '${var2}'"
    echo "3 '${var3}'"
    echo
}

## call

func "a" "b" "c"

var="a b"
func $var "c"

func "a" "" "c"

echo "READY."
echo
