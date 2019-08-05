#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## demonstrates the for loop in doing a backup of .txt files
##


tmplist="./list"

## check if there is already a file by the name of list
if [ -e $tmplist ]
    then
    echo "file $tmplist already exists"
    echo "cancel!"
    exit 1
fi

echo "do a backup of .txt files"

## make a variable list with the content of the files
ls *.txt > $tmplist

## for each element in that list (i = element in that list, NOT a number!!!)
## it also might be possible to put `ls *.txt` directly instead of `cat list`
for i in $(cat list); do
    cp "$i" "$i".bak
done

## remove list
rm $tmplist

echo "READY."
