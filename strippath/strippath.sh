#!/bin/bash
## 
## strippath
##
## TODO
##

echo "code tester"

echo "preconditions:"
echo -e "\tpwd = $PWD"

MY_PATH=$PATH:/doubled:/doubled
echo -e "\tMY_PATH = $MY_PATH"

found=empty
echo -e "\tfound - $found"
echo

## function definition
strippath () {
    ##
    echo -e "\tstrippath starts"
    [ -z $1 ] && return;


    ##
    echo -e "\tstrippath checks if the first element is equal to the path variable"
    [ "$MY_PATH" == "$1" ] && return;

    ## 
    for p in "$@"; do
	echo -e "\tcheck parameters in list for:\"$p\""
	found=`expr "$MY_PATH" : "\ ($p/\?:\ )"` && MY_PATH=${MY_PATH#$found} || 
	echo -e "\t\t1. found = $found\n\t\tMY_PATH = $MY_PATH"

	found=`expr "$MY_PATH" : ".*\ (:$p/\?:\ )"` && MY_PATH=${MY_PATH//${found%:}} || 
	echo -e "\t\t2. found = $found\n\t\tMY_PATH = $MY_PATH"

	found=`expr "$MY_PATH" : ".*\ (:$p/\?$\ )"` && MY_PATH=${MY_PATH%$found}
	echo -e "\t\t3. found = $found\n\t\tMY_PATH = $MY_PATH"
	echo
    done
    echo -e "\texit strippath terminates normally"
}

## function call
echo "call the function"
strippath $PWD/dir_a $PWD/dir_b /double
echo

## results
echo "Result:"
echo -e "\tMY_PATH\t= $MY_PATH"
echo -e "\tfound  \t= $found"
echo
echo "READY."

