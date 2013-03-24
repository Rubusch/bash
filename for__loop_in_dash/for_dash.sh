#!/bin/bash

list=( "fulano" "beltrano" "cicrano" )

## foreach style
for item in ${list[*]}; do
    echo "item: '$item'";
done
echo


## bash style, indexed for loop
for (( idx=0; idx < ${#list[*]}; idx++ )); do
    echo "item: '${list[$idx]}'"
done
echo


## dash style, indexed for loop
idx=0; while test $idx -lt ${#list[*]}; do
    echo "item: '${list[$idx]}'"

    ## incrementation needed!!
    idx=$((idx=$idx+1))
done
echo

printf "READY.\n"