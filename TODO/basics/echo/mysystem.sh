#!/bin/bash
##
## @author: Lothar Rubusch
## @email: L.Rubusch@gmx.ch
## @license: GPLv3

clear
echo "This is information provided by mysystem.sh. Program starts now."

echo "Hello, $USER"
echo

echo "Today's date is `date`, this is week `date +"%V"`."

echo "This is `uname -s` running on a `uname -m` processor."
echo

echo "This is the updime information:"
uptime
echo 

echo "READY."
