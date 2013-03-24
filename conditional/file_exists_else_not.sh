#!/bin/bash

## checks if a certain file exists
##

echo "checking..."

## checking existence of regular file: -f
if [ -f /data/foobar.txt ] 
    then 
    echo "file exists" 

    else
    echo "file foobar does not exist"
fi
echo

echo "checking if globbing is set:"

## checking variable set: -o
if [ -o noglobber ]
    then 
    echo "files are protected against accidental overwriting using redirection"
    else
    echo "files are NOT protected against accidental overwriting using redirection"
fi
echo

echo "compare variables:"

## comparing variables: -eq
if [ $? -eq 0 ]
    then echo "that was easy"
fi
echo


echo "READY."
