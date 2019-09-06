#!/bin/bash -e
#
## test runs over a list of file contents and zips them one by one


dir="./dir"
mkdir -p $dir


## !!! go into the folder - important for zip to work !!!
cd ${dir}

## setup list of files to zip
touch ./foo1.txt
touch ./foo2.txt
touch ./foo3.txt
touch ./foo4.txt
LIST=( `ls -1v` )

## zip each
for item in ${LIST[*]}; do
    echo "item '$item'"
    zip ./${item//.txt/}.zip ./${item}
    [ -f ${item} ] && rm ./${item}
done


echo "READY."
echo
