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
(baba) &
(bobo) &

wait

echo "READY."
