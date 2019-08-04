#!/bin/bash
##
## set

## exit if any command or function results in non-zero value
set -e

## turn off exit on error / non-zero values for commands or functions
set +e

## turn on debugging
set -x

## stop on uninitialized variables
set -u

printf "READY\n"
