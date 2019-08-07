#!/bin/bash
##
## demonstrates usage of wait
##

baba ()
{
    for a in $(seq 10); do
        echo "baba '$a'"
        sleep 1
    done
}

bobo ()
{
    for b in $(seq 10); do
        echo "bobo '$b'"
        sleep 1
    done
}


echo "start"

## start two threads in bash
(baba) &
(bobo) &

## wait on end of both threads
wait

echo "READY."
