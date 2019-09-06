#!/bin/bash -e
##
## prints stdout unchanged, while standard error is redirected 
## for processing by awk
##
## demonstrates more complex filedescriptor closing

INPUTDIR="$1"

exec 6>&1

ls "$INPUTDIR"/* 2>&1 >&6 6>&- \
    ## closes fd 6 just for awk, but not for ls

| awk 'BEGIN { FS=":" } { print "YOU HAVE NO ACCESS TO" $2 }' 6>&-

exec 6>&-


