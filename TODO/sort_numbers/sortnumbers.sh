#!/bin/bash
##
## sorts some numbers from echo (array)

echo "output"
sorted=$(echo "03 53 50 88 01 32 28 74 95 06" | tr ' ' '\n' | sort -n -k 2 | paste -s -d' ' -)
echo "${sorted[*]}"
echo

echo "array"
arr=( "03" "53" "50" "88" "01" "32" "28" "74" "95" "06" )
sorted=( $(printf "%s\n" ${arr[*]} | sort -n) )
## or also
#sorted="${arr[*]}"
#sorted=( $(printf "%s\n" ${sorted} | sort -n) )
echo "${sorted[*]}"
echo

echo "READY."
