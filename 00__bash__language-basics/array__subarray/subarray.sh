#!/bin/bash
## extracts a sub array, cutting of the first element

## start
(( $# != 1 )) && echo "usage: $0 <valid path>" && exit 1

## get list of folders (cut out files)
folders=($(find $1 -maxdepth 1 -type d -exec basename {} \;))

## cut starting at the 1. element
folders=(${folders[@]:1})

## cut starting at 1. element, slice of 2 elements
#folders=(${folders[@]:1:2})

## print elements
for folder in ${folders[*]}; do
    echo "folder: $folder"
done

echo "READY."

