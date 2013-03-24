#!/bin/bash
##
## demonstrates subfunctions and passing parameters
##
## a function can be defined by writing
##
## function FUNC { COMMANDS; }
##
## or
##
## FUNC () { COMMANDS; }
##


echo "demonstrates function arguments"
echo

echo "positional parameter 1 in the script is \"$1\""
echo

## definition of a function
test()
{
    echo "positional parameter 1 in the function is \"$1\""
    RETURN_VALUE=$?
    echo "the exit code of this function is $RETURN_VALUE"
}

## call of a function
test other_param


echo "READY."
