#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3
##
## keeps an addressbook up to date
##
## echo -n = doesn't print linefeeds
## echo -e = executes escape sequences
##

friends="./friends.txt"
echo "keeps the file $firends up to date"

## ask $name
echo -n "enter your name and press ENTER: "
read name

## ask password (hidden)
stty -echo
read -p "password: " password
stty echo
echo

## ask for favorit color
read -p "favorite color: " favcolor

## ask $gender
echo -n "enter your gender [m|f] and presse ENTER: "
read -n 1 gender
echo

## find name in the file and..
grep -i "$name" "$friends"

## ..check if entry already exists
if [ $? == 0 ]; then
    echo "you are already registered, exiting"
    exit 1
elif [ "$gender" == "m" ]; then
    echo -n "I see..."
    exit 1
else
    ## ask $age
    echo -n "how old are you: "
    read age

    ## -lt = lower than
    ## -gt = greater than
    if [ $age -gt 25 ]; then

	## ask $phonenumber
	echo -n "enter your phone number and press ENTER: "
	read phonenumber

	## write to file
	echo "$name $age $phone" >> "$friends"

	echo "you are added, thx"
    else
	echo "ok, I see..."
	exit 1
    fi
fi

echo "READY."
