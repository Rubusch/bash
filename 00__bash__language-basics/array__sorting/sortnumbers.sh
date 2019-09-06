#!/bin/bash
##
## sorts some numbers from echo (array)

echo "array by 'echo output'"
sorted=$(echo "03 53 50 88 01 32 28 74 95 06" | tr ' ' '\n' | sort -n -k 2 | paste -s -d' ' -)
echo "sorted:"
echo "${sorted[*]}"
echo

echo "array by 'bash array'"
arr=( "03" "53" "50" "88" "01" "32" "28" "74" "95" "06" )
sorted=( $(printf "%s\n" ${arr[*]} | sort -n) )
## alternatively
#sorted="${arr[*]}"
#sorted=( $(printf "%s\n" ${sorted} | sort -n) )
echo "sorted:"
echo "${sorted[*]}"
echo

echo "READY."
