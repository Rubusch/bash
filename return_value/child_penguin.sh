#!/bin/bash
## Makefile penguin
##
## demonstrates the usage of a parent/child structure in 
## the scripts - this is the child script!
## 
## demonstrates the usage of the "exit" statement 
## return value is stored in the $? variable
##
## this script lets you present different menus to Tux
## he will only be happy when given a fish we've also 
## added a dolphin and (presumably) a camel
##

if [ "$menu" == "fish" ]; then
    if [ "$animal" == "penguin" ]; then
	echo "Hmmmm fish.. - tux happy!"
    elif [ "$animal" == "dolphin" ]; then
	echo "Pweet! Pweet!"
    else
	echo "*prrrrrrrrrrrrt"
    fi
else
    if [ "$animal" == "penguin" ]; then
	echo "don't like that - enter \"fish\""
	exit 1
    elif [ "$animal" == "dolphin" ]; then
	echo "Pweet!"
	exit 2
    else
	echo "start proggy like: ./parent_feed.sh <text>"
	exit 3
    fi
fi

