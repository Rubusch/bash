#!/bin/bash
#
## test runs over a list of file contents and zips them one by one


dir="./dir"


## !!! go into the folder - important for zip to work !!!
cd ${dir}

## generate files
touch ./foo1.txt
touch ./foo2.txt
touch ./foo3.txt
touch ./foo4.txt

## get list
LIST=( `ls -1v` )

## zip each
for item in ${LIST[*]}; do
    echo "item '$item'"
    zip ./${item//.txt/}.zip ./${item}
    [ -f ${item} ] && rm ./${item}
done


echo "READY."
echo
